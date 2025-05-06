local t_player_models = {

    ["markus"] = "models/player/custom_player/hekut/marcusreed/marcusreed.mdl",
    ["ballas pink"] = "models/player/custom_player/eminem/gta_sa/ballas1.mdl",
    ["bmybar"] = "models/player/custom_player/eminem/gta_sa/bmybar.mdl",
    ["fam1"] = "models/player/custom_player/eminem/gta_sa/fam1.mdl",
    ["somyst"] = "models/player/custom_player/eminem/gta_sa/somyst.mdl",
    ["vwfypro"] = "models/player/custom_player/eminem/gta_sa/vwfypro.mdl",
    ["wuzimu"] = "models/player/custom_player/eminem/gta_sa/wuzimu.mdl",
    ["artic"] = "models/player/custom_player/eminem/css/t_arctic.mdl",
    ["gs tate"] = "models/player/custom_player/frnchise9812/gamesensee.mdl",
    ["jumpscout"] = "models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl",
    ["pig"] = "models/player/wcsnik/animals/pig/pig_v2.mdl",
    ["ghostface"] = "models/player/custom_player/kaesar/ghostface/ghostface.mdl",
    ["william"] = "models/player/custom_player/darnias/sas_william_fix.mdl",
    ["helga"] = "models/player/custom_player/kuristaja/cso2/helga/helga.mdl",
    ["phoenix"] = "models/player/custom_player/kuristaja/cso2/phoenix/phoenix.mdl",
    ["natali"] = "models/player/custom_player/kuristaja/cso2/natalie/natalie.mdl",
    ["miyu"] = "models/player/custom_player/kuristaja/cso2/miyu_schoolgirl/miyu.mdl",
    ["santagirl"] = "models/player/custom_player/kuristaja/cso2/natalie_santagirl/natalie.mdl",
    ["arctic2"] = "models/player/custom_player/legacy/tm_arctic.mdl",
    ["arctic3"] = "models/player/custom_player/legacy/tm_arctic_variantd.mdl",
    ["balas_black"] = "models/player/custom_player/frnchise9812/ballas2.mdl",
}

local ct_player_models = {

    ["markus"] = "models/player/custom_player/hekut/marcusreed/marcusreed.mdl",
    ["ballas pink"] = "models/player/custom_player/eminem/gta_sa/ballas1.mdl",
    ["bmybar"] = "models/player/custom_player/eminem/gta_sa/bmybar.mdl",
    ["fam1"] = "models/player/custom_player/eminem/gta_sa/fam1.mdl",
    ["somyst"] = "models/player/custom_player/eminem/gta_sa/somyst.mdl",
    ["vwfypro"] = "models/player/custom_player/eminem/gta_sa/vwfypro.mdl",
    ["wuzimu"] = "models/player/custom_player/eminem/gta_sa/wuzimu.mdl",
    ["artic"] = "models/player/custom_player/eminem/css/t_arctic.mdl",
    ["gs tate"] = "models/player/custom_player/frnchise9812/gamesensee.mdl",
    ["jumpscout"] = "models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl",
    ["pig"] = "models/player/wcsnik/animals/pig/pig_v2.mdl",
    ["ghostface"] = "models/player/custom_player/kaesar/ghostface/ghostface.mdl",
    ["william"] = "models/player/custom_player/darnias/sas_william_fix.mdl",
    ["helga"] = "models/player/custom_player/kuristaja/cso2/helga/helga.mdl",
    ["phoenix"] = "models/player/custom_player/kuristaja/cso2/phoenix/phoenix.mdl",
    ["natali"] = "models/player/custom_player/kuristaja/cso2/natalie/natalie.mdl",
    ["miyu"] = "models/player/custom_player/kuristaja/cso2/miyu_schoolgirl/miyu.mdl",
    ["santagirl"] = "models/player/custom_player/kuristaja/cso2/natalie_santagirl/natalie.mdl",
    ["arctic2"] = "models/player/custom_player/legacy/tm_arctic.mdl",
    ["arctic3"] = "models/player/custom_player/legacy/tm_arctic_variantd.mdl",
    ["balas_black"] = "models/player/custom_player/frnchise9812/ballas2.mdl",
}

local function contains(tab, val)
	for i = 1, #tab do
		if tab[i] == val then
			return true
		end
	end
	return false
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local ffi = require("ffi")

ffi.cdef[[
    typedef struct 
    {
    	void*   fnHandle;        
    	char    szName[260];     
    	int     nLoadFlags;      
    	int     nServerCount;    
    	int     type;            
    	int     flags;           
    	float  vecMins[3];       
    	float  vecMaxs[3];       
    	float   radius;          
    	char    pad[0x1C];       
    }model_t;
    
    typedef int(__thiscall* get_model_index_t)(void*, const char*);
    typedef const model_t(__thiscall* find_or_load_model_t)(void*, const char*);
    typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
    typedef void*(__thiscall* find_table_t)(void*, const char*);
    typedef void(__thiscall* set_model_index_t)(void*, int);
    typedef int(__thiscall* precache_model_t)(void*, const char*, bool);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]

local class_ptr = ffi.typeof("void***")

local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(class_ptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

local rawivmodelinfo = client.create_interface("engine.dll", "VModelInfoClient004") or error("VModelInfoClient004 wasnt found", 2)
local ivmodelinfo = ffi.cast(class_ptr, rawivmodelinfo) or error("rawivmodelinfo is nil", 2)
local get_model_index = ffi.cast("get_model_index_t", ivmodelinfo[0][2]) or error("get_model_info is nil", 2)
local find_or_load_model = ffi.cast("find_or_load_model_t", ivmodelinfo[0][39]) or error("find_or_load_model is nil", 2)

local rawnetworkstringtablecontainer = client.create_interface("engine.dll", "VEngineClientStringTable001") or error("VEngineClientStringTable001 wasnt found", 2)
local networkstringtablecontainer = ffi.cast(class_ptr, rawnetworkstringtablecontainer) or error("rawnetworkstringtablecontainer is nil", 2)
local find_table = ffi.cast("find_table_t", networkstringtablecontainer[0][3]) or error("find_table is nil", 2)

local cl_fullupdate = cvar.cl_fullupdate

local model_names = {}
local model_names_ct = {}

for k,v in pairs(t_player_models) do
    table.insert(model_names, k)
end

for k,v in pairs(ct_player_models) do
    table.insert(model_names_ct, k)
end

label1 = ui.new_label('LUA', 'A', 'On some models need disable gloves')
local model_check = ui.new_multiselect('lua', 'a', 'Agent changer', {"CT", "T"})
local localplayer_model_ct = ui.new_combobox("lua", "a", "CT Model", model_names_ct)
local localplayer_model_t = ui.new_combobox("lua", "a", "T Model", model_names)

local function precache_model(modelname)
    local rawprecache_table = find_table(networkstringtablecontainer, "modelprecache") or error("couldnt find modelprecache", 2)
    if rawprecache_table then 
        local precache_table = ffi.cast(class_ptr, rawprecache_table) or error("couldnt cast precache_table", 2)
        if precache_table then 
            local add_string = ffi.cast("add_string_t", precache_table[0][8]) or error("add_string is nil", 2)

            find_or_load_model(ivmodelinfo, modelname)
            local idx = add_string(precache_table, false, modelname, -1, nil)
            if idx == -1 then 
                return false
            end
        end
    end
    return true
end

local function set_model_index(entity, idx)
    local raw_entity = get_client_entity(ientitylist, entity)
    if raw_entity then 
        local gce_entity = ffi.cast(class_ptr, raw_entity)
        local a_set_model_index = ffi.cast("set_model_index_t", gce_entity[0][75])
        if a_set_model_index == nil then 
            error("set_model_index is nil")
        end
        a_set_model_index(gce_entity, idx)
    end
end

local function change_model(ent, model)
    if model:len() > 5 then 
        if precache_model(model) == false then 
            error("invalid model", 2)
        end
        local idx = get_model_index(ivmodelinfo, model)
        if idx == -1 then 
            return
        end
        set_model_index(ent, idx)
    end
end

local update_skins = true
client.set_event_callback("pre_render", function()
    local me = entity.get_local_player()
    if me == nil then return end

    local team = entity.get_prop(me, 'm_iTeamNum') 

    if (team == 2 and contains(ui.get(model_check), 'T') ) or (team == 3 and contains(ui.get(model_check), 'CT') ) then
		change_model(me, team == 2 and t_player_models[ui.get(localplayer_model_t)] or ct_player_models[ui.get(localplayer_model_ct)] )
    end
end)

client.set_event_callback("paint_ui", function()
    ui.set_visible(localplayer_model_t, contains(ui.get(model_check), 'T'))  
    ui.set_visible(localplayer_model_ct, contains(ui.get(model_check), 'CT'))
end)