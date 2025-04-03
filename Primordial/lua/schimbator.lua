local vtable = {}
local __thiscall = function(func, this)
    return function(...) return func(this, ...) end
end
local interface_ptr = ffi.typeof("void***")
vtable.bind = function(module, interface, index, typedef)
    local addr = ffi.cast("void***", memory.create_interface(module, interface)) or error(interface .. " was not found")
    return __thiscall(ffi.cast(typedef, addr[0][index]), addr)
end
vtable.entry = function(instance, i, ct)
    return ffi.cast(ct, ffi.cast(interface_ptr, instance)[0][i])
end
vtable.thunk = function(i, ct)
    local t = ffi.typeof(ct)
    return function(instance, ...)
        return vtable.entry(instance, i, t)(instance, ...)
    end
end

local get_class_name = vtable.thunk(143, "const char*(__thiscall*)(void*)")
local set_model_index = vtable.thunk(75, "void(__thiscall*)(void*,int)")

local get_client_entity_from_handle = vtable.bind("client.dll", "VClientEntityList003", 4, "void*(__thiscall*)(void*,void*)")
local get_model_index = vtable.bind("engine.dll", "VModelInfoClient004", 2, "int(__thiscall*)(void*, const char*)")

local rawientitylist = memory.create_interface('client.dll', 'VClientEntityList003') or error('VClientEntityList003 was not found', 2)

local ientitylist = ffi.cast(interface_ptr, rawientitylist) or error('rawientitylist is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity was not found', 2)

local client_string_table_container = ffi.cast(interface_ptr, memory.create_interface('engine.dll', 'VEngineClientStringTable001')) or error('VEngineClientStringTable001 was not found', 2)
local find_table = vtable.thunk(3, 'void*(__thiscall*)(void*, const char*)')

local model_info = ffi.cast(interface_ptr, memory.create_interface('engine.dll', 'VModelInfoClient004')) or error('VModelInfoClient004 wasnt found', 2)

ffi.cdef [[
    typedef void(__thiscall* find_or_load_model_t)(void*, const char*);
]]

local add_string = vtable.thunk(8, "int*(__thiscall*)(void*, bool, const char*, int length, const void* userdata)")
local find_or_load_model = ffi.cast("find_or_load_model_t", model_info[0][43]) -- vtable thunk crashes (?)

local function _precache(szModelName)
    if szModelName == "" then return end -- don't precache empty strings (crash)
    if szModelName == nil then return end
    szModelName = string.gsub(szModelName, [[\]], [[/]])

    local m_pModelPrecacheTable = find_table(client_string_table_container, "modelprecache")
    if m_pModelPrecacheTable ~= nil then
        find_or_load_model(model_info, szModelName)
        add_string(m_pModelPrecacheTable, false, szModelName, -1, nil)
    end
end

local list_names =
{
    'None',
    'Evil Clown',
    'Anaglyph',
    'Boar',
    'Bunny',
    'Bunny Gold',
    'Chains',
    'Chicken',
    'Dallas',
    'Devil Plastic',
    'Hoxton',
    'Doll Kabuki',
    'Pumpkin',
    'Samurai',
    'Sheep Bloody',
    'Sheep Gold',
    'Sheep Model',
    'Skull',
    'Skull Gold',
    'Template',
    'TF2 Demo',
    'TF2 Engi',
    'TF2 Heavy',
    'TF2 Medic',
    'TF2 Pyro',
    'TF2 Scout',
    'TF2 Sniper',
    'TF2 Soldier',
    'TF2 Spy',
    'Tiki',
    'Wolf',
    'Zombie Fortune Plastic',
    'Doll'
}

local masks = menu.add_selection("Mask Changer", "Mask Changer", list_names)

local models = {
    '',
    'models\\player\\holiday\\facemasks\\evil_clown.mdl',
    'models\\player\\holiday\\facemasks\\facemask_anaglyph.mdl',
    'models\\player\\holiday\\facemasks\\facemask_boar.mdl',
    'models\\player\\holiday\\facemasks\\facemask_bunny.mdl',
    'models\\player\\holiday\\facemasks\\facemask_bunny_gold.mdl',
    'models\\player\\holiday\\facemasks\\facemask_chains.mdl',
    'models\\player\\holiday\\facemasks\\facemask_chicken.mdl',
    'models\\player\\holiday\\facemasks\\facemask_dallas.mdl',
    'models\\player\\holiday\\facemasks\\facemask_devil_plastic.mdl',
    'models\\player\\holiday\\facemasks\\facemask_hoxton.mdl',
    'models\\player\\holiday\\facemasks\\facemask_porcelain_doll_kabuki.mdl',
    'models\\player\\holiday\\facemasks\\facemask_pumpkin.mdl',
    'models\\player\\holiday\\facemasks\\facemask_samurai.mdl',
    'models\\player\\holiday\\facemasks\\facemask_sheep_bloody.mdl',
    'models\\player\\holiday\\facemasks\\facemask_sheep_gold.mdl',
    'models\\player\\holiday\\facemasks\\facemask_sheep_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_skull.mdl',
    'models\\player\\holiday\\facemasks\\facemask_skull_gold.mdl',
    'models\\player\\holiday\\facemasks\\facemask_template.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_demo_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_engi_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_heavy_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_medic_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_pyro_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_scout_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_sniper_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_soldier_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_spy_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tiki.mdl',
    'models\\player\\holiday\\facemasks\\facemask_wolf.mdl',
    'models\\player\\holiday\\facemasks\\facemask_zombie_fortune_plastic.mdl',
    'models\\player\\holiday\\facemasks\\porcelain_doll.mdl'
}

local last_model = 0

local model_index = -1
local enabled = false

local function precache(modelPath)
    if modelPath == "" then return -1 end -- don't crash.
    local local_model_index = get_model_index(modelPath)
    if local_model_index == -1 then
        _precache(modelPath)
    end
    return get_model_index(modelPath)
end

local function on_paint()
    if not engine.is_in_game() then
        last_model = 0
        return
    end
    if last_model ~= masks:get() - 1 then
        last_model = masks:get() - 1
        if last_model == 0 then
            enabled = false
        else
            enabled = true
            model_index = precache(models[last_model + 1])
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)

local function get_player_address(lp)
    return get_client_entity(ientitylist, lp:get_index())
end

local function on_setup_command(cmd)
    if model_index == -1 then return precache(models[last_model + 1]) end

    local local_player = entity_list.get_local_player()
    if enabled then
        local lp_addr = ffi.cast("intptr_t*", get_player_address(local_player))
        local m_AddonModelsHead = ffi.cast("intptr_t*", lp_addr + 0x462F) -- E8 ? ? ? ? A1 ? ? ? ? 8B CE 8B 40 10
        local i, next_model = m_AddonModelsHead[0], -1

        while i ~= -1 do
            next_model = ffi.cast("intptr_t*", lp_addr + 0x462C)[0] + 0x18 * i -- this is the pModel (CAddonModel) afaik
            i = ffi.cast("intptr_t*", next_model + 0x14)[0]
            local m_pEnt = ffi.cast("intptr_t**", next_model)[0] -- CHandle<C_BaseAnimating> m_hEnt -> Get()
            local m_iAddon = ffi.cast("intptr_t*", next_model + 0x4)[0]
            if tonumber(m_iAddon) == 16 then -- face mask addon bits knife = 10
                local entity = get_client_entity_from_handle(m_pEnt)
                set_model_index(entity, model_index)
            end
        end
    end
end

callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)

callbacks.add(e_callbacks.NET_UPDATE, function()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    if enabled then
        if bit.band(local_player:get_prop("m_iAddonBits"), 0x10000) ~= 0x10000 then
            local_player:set_prop("m_iAddonBits", 0x10000 + local_player:get_prop("m_iAddonBits"))
        end
    else
        if bit.band(local_player:get_prop("m_iAddonBits"), 0x10000) == 0x10000 then
            local_player:set_prop("m_iAddonBits", local_player:get_prop("m_iAddonBits") - 0x10000)
        end
    end
end)

callbacks.add(e_callbacks.SHUTDOWN, function()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    if bit.band(local_player:get_prop("m_iAddonBits"), 0x10000) == 0x10000 then
        local_player:set_prop("m_iAddonBits", local_player:get_prop("m_iAddonBits") - 0x10000)
    end
end)