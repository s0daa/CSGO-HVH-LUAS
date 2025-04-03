--[[
    primordial.dev | 2022
    Author: Classy
]]

local new_weapon_struct = ffi.typeof([[
    struct{
        char pad_0000[461]; //0x0000
        bool shouldnt_draw_view; //0x01CD classy is a baller also dont paste my code u fkin kidz grr
        char pad_01CE[115]; //0x01CE
    }
]])

local viewmodel_enable = menu.add_checkbox("viewmodel scope","allow viewmodel in scope")
local sig = memory.find_pattern("client.dll", "8B 35 ?? ?? ?? ?? FF 10 0F B7 C0") or error("IWeaponSystem signature invalid")
local weapon_system_raw = ffi.cast("void****", ffi.cast("char*", sig) + 0x2)[0]
local get_weapon_info = memory.get_vfunc(tonumber(ffi.cast("unsigned int",weapon_system_raw)), 2) or error("invalid GetCSWeaponInfo index")
local get_weapon_info_fn = ffi.cast( ffi.typeof("$*(__thiscall*)(void*, unsigned int)",new_weapon_struct),get_weapon_info)

local function paint_callback()
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end


    if not local_player:is_player() or not local_player:is_alive() then
        return
    end

    local active_weapon = local_player:get_active_weapon()
    if (active_weapon == nil) then
        return
    end

    local index = active_weapon:get_prop("m_iItemDefinitionIndex")
    if(index == nil) then
        return
    end
    local get_weapon_info_data = get_weapon_info_fn(weapon_system_raw,index)

    if(get_weapon_info_data == nil) then
        return
    end

    get_weapon_info_data.shouldnt_draw_view = not viewmodel_enable:get()
end

local function on_shutdown()
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end

    if not local_player:is_player() or not local_player:is_alive() then
        return
    end

    local active_weapon = local_player:get_active_weapon()
    if (active_weapon == nil) then
        return
    end

    local index = active_weapon:get_prop("m_iItemDefinitionIndex")
    if(index == nil) then
        return
    end
    local get_weapon_info_data = get_weapon_info_fn(weapon_system_raw,index)

    if(get_weapon_info_data == nil) then
        return
    end

    get_weapon_info_data.shouldnt_draw_view = true
end

callbacks.add(e_callbacks.SHUTDOWN,on_shutdown)

callbacks.add(e_callbacks.PAINT,paint_callback)