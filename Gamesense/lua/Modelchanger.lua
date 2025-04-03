local player_models = {
    ["ctm_fbi"] = "models/player/custom_player/legacy/ctm_fbi.mdl",
    ["ctm_fbi_varianta"] = "models/player/custom_player/legacy/ctm_fbi_varianta.mdl",
    ["ctm_fbi_variantc"] = "models/player/custom_player/legacy/ctm_fbi_variantc.mdl",
    ["ctm_fbi_variantd"] = "models/player/custom_player/legacy/ctm_fbi_variantd.mdl",
    ["ctm_fbi_variante"] = "models/player/custom_player/legacy/ctm_fbi_variante.mdl",
    ["ctm_fbi_variante"] = "models/player/custom_player/legacy/ctm_fbi_variante.mdl",
    ["ctm_sas"] = "models/player/custom_player/legacy/ctm_sas.mdl",
    ["ctm_sas_varianta"] = "models/player/custom_player/legacy/ctm_sas_varianta.mdl",
    ["ctm_sas_variantb"] = "models/player/custom_player/legacy/ctm_sas_variantb.mdl",
    ["ctm_sas_variantc"] = "models/player/custom_player/legacy/ctm_sas_variantc.mdl",
    ["ctm_sas_variantd"] = "models/player/custom_player/legacy/ctm_sas_variantd.mdl",
    ["ctm_sas_variante"] = "models/player/custom_player/legacy/ctm_sas_variante.mdl",
    ["tm_jumpsuit_varianta"] = "models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl",
    ["tm_jumpsuit_variantb"] = "models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl",
    ["tm_jumpsuit_variantc"] = "models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl",
    ["tm_leet_varianta"] = "models/player/custom_player/legacy/tm_leet_varianta.mdl",
    ["tm_leet_variantb"] = "models/player/custom_player/legacy/tm_leet_variantb.mdl",
    ["tm_leet_variantc"] = "models/player/custom_player/legacy/tm_leet_variantc.mdl",
    ["tm_leet_variantd"] = "models/player/custom_player/legacy/tm_leet_variantd.mdl",
    ["tm_leet_variante"] = "models/player/custom_player/legacy/tm_leet_variante.mdl",
    ["tm_phoenix"] = "models/player/custom_player/legacy/tm_phoenix.mdl",
    ["tm_phoenix_varianta"] = "models/player/custom_player/legacy/tm_phoenix_varianta.mdl",
    ["tm_phoenix_variantb"] = "models/player/custom_player/legacy/tm_phoenix_variantb.mdl",
    ["tm_phoenix_variantc"] = "models/player/custom_player/legacy/tm_phoenix_variantc.mdl",
    ["tm_phoenix_variantd"] = "models/player/custom_player/legacy/tm_phoenix_variantd.mdl",
}

local ffi = require("ffi")

ffi.cdef [[
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

local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or
    error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(class_ptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

local rawivmodelinfo = client.create_interface("engine.dll", "VModelInfoClient004") or
    error("VModelInfoClient004 wasnt found", 2)
local ivmodelinfo = ffi.cast(class_ptr, rawivmodelinfo) or error("rawivmodelinfo is nil", 2)
local get_model_index = ffi.cast("get_model_index_t", ivmodelinfo[0][2]) or error("get_model_info is nil", 2)
local find_or_load_model = ffi.cast("find_or_load_model_t", ivmodelinfo[0][39]) or error("find_or_load_model is nil", 2)

local rawnetworkstringtablecontainer = client.create_interface("engine.dll", "VEngineClientStringTable001") or
    error("VEngineClientStringTable001 wasnt found", 2)
local networkstringtablecontainer = ffi.cast(class_ptr, rawnetworkstringtablecontainer) or
    error("rawnetworkstringtablecontainer is nil", 2)
local find_table = ffi.cast("find_table_t", networkstringtablecontainer[0][3]) or error("find_table is nil", 2)

local model_names = {}

for key, value in pairs(player_models) do
    table.insert(model_names, key)
end
local sl_box = ui.new_checkbox("lua", "b", "Script Leaks ~ Change local player model")
local localplayer_model_all = ui.new_listbox("lua", "b", "Change local player model", model_names)

local function precache_model(modelname)
    local rawprecache_table = find_table(networkstringtablecontainer, "modelprecache") or
        error("couldnt find modelprecache", 2)
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

client.set_event_callback("pre_render", function()
    local me = entity.get_local_player()
    if me == nil then return end

    local team = entity.get_prop(me, 'm_iTeamNum')

    if (team == 2) or (team == 3) then
        if (ui.get(sl_box) == true) then
        change_model(me, player_models[model_names[ui.get(localplayer_model_all)+ 1]])
        end
    end
end)