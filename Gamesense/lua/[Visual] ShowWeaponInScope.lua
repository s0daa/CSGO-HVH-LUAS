local function vtable_bind(class, _type, index)
    local this = ffi.cast("void***", class)
    local ffitype = ffi.typeof(_type)
    return function (...)
        return ffi.cast(ffitype, this[0][index])(this, ...)
    end
end

local ShowWeaponInScope = gui.add_checkbox("Show weapon in scope", "visuals>misc>local")

local WeaponSystem  = ffi.cast("void**", utils.find_pattern("client.dll", "8B 35 ? ? ? ? FF 10 0F B7 C0") + 2)[0]
local GetWeaponData = vtable_bind(WeaponSystem, "uintptr_t(__thiscall*)(void*, short)", 2)

local function GetWeaponDataAddress(player_index)
    local Player = entities.get_entity(player_index)
    if not Player or not Player:is_alive() then
        return nil
    end
    
    local Weapon = Player:get_weapon()
    if not Weapon then
        return nil
    end
    
    return GetWeaponData(Weapon:get_prop("m_iItemDefinitionIndex"))
end

function on_create_move()
    local pWeaponData = GetWeaponDataAddress(engine.get_local_player())
    if not pWeaponData then
        return
    end

    ffi.cast("bool*", tonumber(pWeaponData) + 0x1CD)[0] = not ShowWeaponInScope:get_bool()
end

function on_shutdown()
    local pWeaponData = GetWeaponDataAddress(engine.get_local_player())
    if not pWeaponData then
        return
    end

    ffi.cast("bool*", tonumber(pWeaponData) + 0x1CD)[0] = true
end