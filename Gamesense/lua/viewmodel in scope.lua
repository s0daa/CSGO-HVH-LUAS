local ffi = require "ffi"

local ccsweaponinfo_t = [[
    struct {
        char         __pad_0x0000[0x1cd];                   // 0x0000
        bool         hide_vm_scope;                // 0x01d1
    }
]]

local match = client.find_signature("client_panorama.dll", "\x8B\x35\xCC\xCC\xCC\xCC\xFF\x10\x0F\xB7\xC0")
local weaponsystem_raw = ffi.cast("void****", ffi.cast("char*", match) + 2)[0]

local get_weapon_info = vtable_thunk(2, ccsweaponinfo_t .. "*(__thiscall*)(void*, unsigned int)")

local toggle = ui.new_checkbox("Visuals", "Effects", "Show viewmodel in scope")

client.set_event_callback("run_command", function()
    local w_id = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex")
    local res = get_weapon_info(weaponsystem_raw, w_id)
    res.hide_vm_scope = not ui.get(toggle)
end)