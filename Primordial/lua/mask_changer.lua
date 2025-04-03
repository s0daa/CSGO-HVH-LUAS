local function __thiscall(func, this) -- bind wrapper for __thiscall functions
    return function(...)
        return func(this, ...)
    end
end

local interface_ptr = ffi.typeof("void***")
local vtable_bind = function(module, interface, index, typedef)
    local addr = ffi.cast("void***", memory.create_interface(module, interface)) or safe_error(interface .. " is nil.")
    return __thiscall(ffi.cast(typedef, addr[0][index]), addr)
end

local vtable_entry = function(instance, i, ct)
    return ffi.cast(ct, ffi.cast(interface_ptr, instance)[0][i])
end

local vtable_thunk = function(i, ct)
    local t = ffi.typeof(ct)
    return function(instance, ...)
        return vtable_entry(instance, i, t)(instance, ...)
    end
end

local nativeCBaseEntityGetClassName = vtable_thunk(143, "const char*(__thiscall*)(void*)")
local nativeCBaseEntitySetModelIndex = vtable_thunk(75, "void(__thiscall*)(void*,int)")

local nativeClientEntityListGetClientEntityFromHandle = vtable_bind("client.dll", "VClientEntityList003", 4, "void*(__thiscall*)(void*,void*)")
local nativeModelInfoClientGetModelIndex = vtable_bind("engine.dll", "VModelInfoClient004", 2, "int(__thiscall*)(void*, const char*)")

local list_names =
{
    'Dallas',
    'Battle Mask',
    'Evil Clown',
    'Anaglyph',
    'Boar',
    'Bunny',
    'Bunny Gold',
    'Chains',
    'Chicken',
    'Devil Plastic',
    'Hoxton',
    'Pumpkin',
    'Samurai',
    'Sheep Bloody',
    'Sheep Gold',
    'Sheep Model',
    'Skull',
    'Template',
    'Wolf',
    'Doll',
}

local filepath = {
    'player/holiday/facemasks/facemask_dallas',
    'player/holiday/facemasks/facemask_battlemask',
    'player/holiday/facemasks/evil_clown',
    'player/holiday/facemasks/facemask_anaglyph',
    'player/holiday/facemasks/facemask_boar',
    'player/holiday/facemasks/facemask_bunny',
    'player/holiday/facemasks/facemask_bunny_gold',
    'player/holiday/facemasks/facemask_chains',
    'player/holiday/facemasks/facemask_chicken',
    'player/holiday/facemasks/facemask_devil_plastic',
    'player/holiday/facemasks/facemask_hoxton',
    'player/holiday/facemasks/facemask_pumpkin',
    'player/holiday/facemasks/facemask_samurai',
    'player/holiday/facemasks/facemask_sheep_bloody',
    'player/holiday/facemasks/facemask_sheep_gold',
    'player/holiday/facemasks/facemask_sheep_model',
    'player/holiday/facemasks/facemask_skull',
    'player/holiday/facemasks/facemask_template',
    'player/holiday/facemasks/facemask_wolf',
    'player/holiday/facemasks/porcelain_doll',
}

local masks = menu.add_selection("Mask Changer", "Select", list_names)
local custom_models = menu.add_checkbox("Mask Changer", "Enable Custom Models", false)
local custom_modes_path = menu.add_text_input("Mask Changer", "Path")

callbacks.add(e_callbacks.PAINT, function()

    local local_player = entity_list.get_local_player()

    if local_player == nil then return end

    local models = ""

    if custom_models:get() then
        custom_modes_path:set_visible(true)
        models = custom_modes_path:get()
    else
        custom_modes_path:set_visible(false)
        models = "models/" .. filepath[masks:get()] .. ".mdl"
    end

    local modelIndex = nativeModelInfoClientGetModelIndex(models)
    if modelIndex == -1 then
        client.precache_model(models)
    end
    modelIndex = nativeModelInfoClientGetModelIndex(models)

    local local_player = entity_list.get_local_player()

    local lpAddr = ffi.cast("intptr_t*", local_player:get_address())

    local m_AddonModelsHead = ffi.cast("intptr_t*", lpAddr + 0x462F) -- E8 ? ? ? ? A1 ? ? ? ? 8B CE 8B 40 10
    local m_AddonModelsInvalidIndex = -1

    local i, next = m_AddonModelsHead[0], -1

    while i ~= m_AddonModelsInvalidIndex do
        next = ffi.cast("intptr_t*", lpAddr + 0x462C)[0] + 0x18 * i -- this is the pModel (CAddonModel) afaik
        i = ffi.cast("intptr_t*", next + 0x14)[0]

        local m_pEnt = ffi.cast("intptr_t**", next)[0] -- CHandle<C_BaseAnimating> m_hEnt -> Get()
        local m_iAddon = ffi.cast("intptr_t*", next + 0x4)[0]

        if tonumber(m_iAddon) == 16 and modelIndex ~= -1 then -- face mask addon bits
            local entity = nativeClientEntityListGetClientEntityFromHandle(m_pEnt)
            nativeCBaseEntitySetModelIndex(entity, modelIndex)
        end
    end
end)

callbacks.add(e_callbacks.NET_UPDATE, function()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    if bit.band(local_player:get_prop("m_iAddonBits"), 0x10000) ~= 0x10000 then
        local_player:set_prop("m_iAddonBits", 0x10000 + local_player:get_prop("m_iAddonBits"))
    end
end)
