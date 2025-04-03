local player_models = {
	{"T Model", "models/player/custom_player/legacy/tm_phoenix.mdl", true},
	{"CT Model", "models/player/custom_player/legacy/ctm_sas.mdl", false},
	{"Silent | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf1.mdl", true},
 	{"Vypa Sista of the Revolution | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variante.mdl", true},
	{"'Medium Rare' Crasswater | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantb2.mdl", true},
	{"Crasswater The Forgotten | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantb.mdl", true},
	{"Skullhead | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf2.mdl", true},
	{"Chef d'Escadron Rouchard | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_variantc.mdl", false},
	{"Cmdr. Frank 'Wet Sox' Baroud | SEAL Frogman", "models/player/custom_player/legacy/ctm_diver_variantb.mdl", false},
	{"Cmdr. Davida 'Goggles' Fernandez | SEAL Frogman", "models/player/custom_player/legacy/ctm_diver_varianta.mdl", false},
	{"Royale | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf3.mdl", true},
	{"Loudmouth | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf4.mdl", true},
	{"Miami | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf.mdl", true},
	{"Getaway Sally | Professional", "models/player/custom_player/legacy/tm_professional_varj.mdl", true},
	{"Elite Trapper Solman | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_varianta.mdl", true},
	{"Bloody Darryl The Strapped | The Professionals", "models/player/custom_player/legacy/tm_professional_varf5.mdl", true},
	{"Chem-Haz Capitaine | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_variantb.mdl", false},
	{"Lieutenant Rex Krikey | SEAL Frogman", "models/player/custom_player/legacy/ctm_diver_variantc.mdl", false},
	{"Arno The Overgrown | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantс.mdl", true},
	{"Col. Mangos Dabisi | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantd.mdl", true},
	{"Officer Jacques Beltram | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_variante.mdl", false},
	{"Trapper | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantf2.mdl", true},
	{"Lieutenant 'Tree Hugger' Farlow | SWAT", "models/player/custom_player/legacy/ctm_swat_variantk.mdl", false},
	{"Sous-Lieutenant Medic | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_varianta.mdl", false},
	{"Primeiro Tenente | Brazilian 1st Battalion", "models/player/custom_player/legacy/ctm_st6_variantn.mdl", false},
	{"D Squadron Officer | NZSAS", "models/player/custom_player/legacy/ctm_sas_variantg.mdl", false},
	{"Trapper Aggressor | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantf.mdl", true},
	{"Aspirant | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_variantd.mdl", false},
	{"AGENT Gandon | Professional", "models/player/custom_player/legacy/tm_professional_vari.mdl", true},
	{"Safecracker Voltzmann | Professional", "models/player/custom_player/legacy/tm_professional_varg.mdl", true},
	{"Little Kev | Professional", "models/player/custom_player/legacy/tm_professional_varh.mdl", true},
	{"Blackwolf | Sabre", "models/player/custom_player/legacy/tm_balkan_variantj.mdl", true},
	{"Rezan the Redshirt | Sabre", "models/player/custom_player/legacy/tm_balkan_variantk.mdl", true},
	{"Rezan The Ready | Sabre", "models/player/custom_player/legacy/tm_balkan_variantg.mdl", true},
	{"Maximus | Sabre", "models/player/custom_player/legacy/tm_balkan_varianti.mdl", true},
	{"Dragomir | Sabre", "models/player/custom_player/legacy/tm_balkan_variantf.mdl", true},
	{"Dragomir | Sabre Footsoldier", "models/player/custom_player/legacy/tm_balkan_variantl.mdl", true},
	{"Lt. Commander Ricksaw | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_varianti.mdl", false},
	{"'Two Times' McCoy | USAF TACP", "models/player/custom_player/legacy/ctm_st6_variantm.mdl", false},
	{"'Two Times' McCoy | USAF Cavalry", "models/player/custom_player/legacy/ctm_st6_variantl.mdl", false},
	{"Buckshot | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variantg.mdl", false},
	{"'Blueberries' Buckshot | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variantj.mdl", false},
	{"Seal Team 6 Soldier | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variante.mdl", false},
	{"3rd Commando Company | KSK", "models/player/custom_player/legacy/ctm_st6_variantk.mdl", false},
	{"'The Doctor' Romanov | Sabre", "models/player/custom_player/legacy/tm_balkan_varianth.mdl", true},
	{"Michael Syfers| FBI Sniper", "models/player/custom_player/legacy/ctm_fbi_varianth.mdl", false},
	{"Markus Delrow | FBI HRT", "models/player/custom_player/legacy/ctm_fbi_variantg.mdl", false},
	{"Cmdr. Mae | SWAT", "models/player/custom_player/legacy/ctm_swat_variante.mdl", false},
	{"1st Lieutenant Farlow | SWAT", "models/player/custom_player/legacy/ctm_swat_variantf.mdl", false},
	{"John 'Van Healen' Kask | SWAT", "models/player/custom_player/legacy/ctm_swat_variantg.mdl", false},
	{"Bio-Haz Specialist | SWAT", "models/player/custom_player/legacy/ctm_swat_varianth.mdl", false},
	{"Chem-Haz Specialist | SWAT", "models/player/custom_player/legacy/ctm_swat_variantj.mdl", false},
	{"Sergeant Bombson | SWAT", "models/player/custom_player/legacy/ctm_swat_varianti.mdl", false},
	{"Operator | FBI SWAT", "models/player/custom_player/legacy/ctm_fbi_variantf.mdl", false},
	{"Street Soldier | Phoenix", "models/player/custom_player/legacy/tm_phoenix_varianti.mdl", true},
	{"Slingshot | Phoenix", "models/player/custom_player/legacy/tm_phoenix_variantg.mdl", true},
	{"Enforcer | Phoenix", "models/player/custom_player/legacy/tm_phoenix_variantf.mdl", true},
	{"Soldier | Phoenix", "models/player/custom_player/legacy/tm_phoenix_varianth.mdl", true},
	{"The Elite Mr. Muhlik | Elite Crew", "models/player/custom_player/legacy/tm_leet_variantf.mdl", true},
	{"Prof. Shahmat | Elite Crew", "models/player/custom_player/legacy/tm_leet_varianti.mdl", true},
	{"Osiris | Elite Crew", "models/player/custom_player/legacy/tm_leet_varianth.mdl", true},
	{"Ground Rebel| Elite Crew", "models/player/custom_player/legacy/tm_leet_variantg.mdl", true},
	{"Special Agent Ava | FBI", "models/player/custom_player/legacy/ctm_fbi_variantb.mdl", false},
	{"B Squadron Officer | SAS", "models/player/custom_player/legacy/ctm_sas_variantf.mdl", false},
	{"Jumpsuit Variant A","models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl",true},
	{"Jumpsuit Variant B","models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl",true},
	{"Jumpsuit Variant C","models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl",true},
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