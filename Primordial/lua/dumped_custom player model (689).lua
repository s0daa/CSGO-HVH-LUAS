local player_models = {
	{"T Model", "models/player/custom_player/legacy/tm_phoenix.mdl", true},
	{"CT Model", "models/player/custom_player/legacy/ctm_sas.mdl", false},
	{"GTA1", "models/player/custom_player/eminem/gta_sa/swmotr5.mdl", true},
	{"GTA2", "models/player/custom_player/eminem/gta_sa/ballas1.mdl", true},
	{"GTA3", "models/player/custom_player/eminem/gta_sa/bmybar.mdl", true},
	{"GTA4", "models/player/custom_player/eminem/gta_sa/fam1.mdl", true},
	{"GTA5", "models/player/custom_player/eminem/gta_sa/vwfypro.mdl", true},
	{"GTA6", "models/player/custom_player/eminem/gta_sa/wuzimu.mdl", true},
	{"ARCTIC", "models/player/custom_player/eminem/css/t_arctic.mdl", true},
	{"GTA1", "models/player/custom_player/eminem/gta_sa/swmotr5.mdl", false},
	{"GTA2", "models/player/custom_player/eminem/gta_sa/ballas1.mdl", false},
	{"GTA3", "models/player/custom_player/eminem/gta_sa/bmybar.mdl", false},
	{"GTA4", "models/player/custom_player/eminem/gta_sa/fam1.mdl", false},
	{"GTA5", "models/player/custom_player/eminem/gta_sa/vwfypro.mdl", false},
	{"GTA6", "models/player/custom_player/eminem/gta_sa/wuzimu.mdl", false},
	{"ARCTIC", "models/player/custom_player/eminem/css/t_arctic.mdl", false},
    {"Helga", "models/player/custom_player/kuristaja/cso2/helga/helga.mdl", true},
	{"Helga", "models/player/custom_player/kuristaja/cso2/helga/helga.mdl", false},
    {"arms", "models/player/custom_player/kuristaja/cso2/gsg9/gsg9.mdl", true},
	{"arms", "models/player/custom_player/kuristaja/cso2/gsg9/gsg9.mdl", false},
	{"Phoenix", "models/player/custom_player/kuristaja/cso2/phoenix/phoenix.mdl", true},
	{"Phoenix", "models/player/custom_player/kuristaja/cso2/phoenix/phoenix.mdl", false},
    {"lieon", "models/player/custom_player/darnias/leon_fix.mdl", true},
    {"lieon", "models/player/custom_player/darnias/leon_fix.mdl", false},
    
    
    {"Player model1", "models/player/custom_player/kuristaja/cso2/miyu_schoolgirl/miyu.mdl", true},
	{"Player model1", "models/player/custom_player/kuristaja/cso2/miyu_schoolgirl/miyu.mdl", false},
	
	
	{"Player model3", "models/player/custom_player/kuristaja/cso2/natalie/natalie.mdl", true},
	{"Player model3", "models/player/custom_player/kuristaja/cso2/natalie/natalie.mdl", false},
	
	
	
	
}

local cs_teams = {
	{"Counter-Terrorist", false},
	{"Terrorist", true}
}

local ent_list = memory.create_interface("client.dll", "VClientEntityList003")
local entity_list_raw = ffi.cast("void***",ent_list)
local get_client_entity = ffi.cast("void*(__thiscall*)(void*,int)",memory.get_vfunc(ent_list,3))
local model_info_interface = memory.create_interface("engine.dll","VModelInfoClient004")
local raw_model_info = ffi.cast("void***",model_info_interface)
local get_model_index = ffi.cast("int(__thiscall*)(void*, const char*)",memory.get_vfunc(tonumber(ffi.cast("unsigned int",raw_model_info)),2))
local set_model_index_t = ffi.typeof("void(__thiscall*)(void*,int)")
--reversed for no reason cuz ducarii n i thought modelindex no worky
local set_model_index = ffi.cast(set_model_index_t, memory.find_pattern("client.dll","55 8B EC 8B 45 08 56 8B F1 8B 0D ?? ?? ?? ??"))


local team_references, team_model_paths = {}, {}
local model_index_prev

for i=1, #cs_teams do
	local teamname, is_t = unpack(cs_teams[i])

	team_model_paths[is_t] = {}
	local model_names = {}
	local l_i = 0
	for i=1, #player_models do
		local model_name, model_path, model_is_t = unpack(player_models[i])

		if model_is_t == nil or model_is_t == is_t then
			table.insert(model_names, model_name)
			l_i = l_i + 1
			team_model_paths[is_t][l_i] = model_path
		end
	end

	team_references[is_t] = {
		enabled_reference = menu.add_checkbox("Agent Changer",string.format("Enable changer",teamname)),
		model_reference = menu.add_list("Agent Changer","Player Models",model_names,20)
	}
	for _, v in pairs(team_references[is_t]) do
		v:set_visible(false)
	end
end


local function do_model_change()
	local local_player = entity_list.get_local_player()

	if local_player == nil then
		return
	end

	if not local_player:is_alive() then
		return
	end

	local player_ptr = ffi.cast("void***",get_client_entity(entity_list_raw,local_player:get_index()))
	local set_model_idx  = ffi.cast(set_model_index_t,memory.get_vfunc(tonumber(ffi.cast("unsigned int",player_ptr)),75))

	if(player_ptr == nil) then
		return
	end

	if(set_model_idx == nil) then
		return
	end

	local model_path, model_index
	local teamnum = local_player:get_prop("m_iTeamNum")
	local is_t = teamnum == 2 and true or false

	for references_is_t, references in pairs(team_references) do
		references.enabled_reference:set_visible(references_is_t == is_t)

		if references_is_t == is_t and references.enabled_reference:get() then
			references.model_reference:set_visible(true)
			model_path = team_model_paths[is_t][tonumber(references.model_reference:get())]
		else
			references.model_reference:set_visible(false)
		end
	end

	local model_index

	if model_path ~= nil then
		model_index = get_model_index(raw_model_info,model_path)
		if model_index == -1 then
			model_index = nil
		end
	end

	if(model_index == nil and model_path ~= nil) then
		client.precache_model(model_path)
	end

	model_index_prev = model_index

	if model_index ~= nil then
		set_model_idx(player_ptr,model_index)
	end
end

callbacks.add(e_callbacks.NET_UPDATE,do_model_change)