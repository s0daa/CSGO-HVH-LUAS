local client_current_threat, client_find_signature, entity_get_local_player, entity_get_origin, entity_get_player_weapon, entity_get_prop, entity_is_alive, globals_chokedcommands, math_max, renderer_indicator, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_hotkey, ui_new_multiselect, ui_reference, ipairs, ui_set_callback, ui_set_visible = client.current_threat, client.find_signature, entity.get_local_player, entity.get_origin, entity.get_player_weapon, entity.get_prop, entity.is_alive, globals.chokedcommands, math.max, renderer.indicator, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_hotkey, ui.new_multiselect, ui.reference, ipairs, ui.set_callback, ui.set_visible

local bit = require "bit"
local ffi = require "ffi"
local vector = require "vector" -- there for the Vector struct to work in FFI

local antiaim_funcs = require "gamesense/antiaim_funcs"

local user_cmd_t = ffi.typeof([[
    struct {
        int vtable;
        int m_command_number;
        int m_tick_count;
        Vector m_view_angles;
        Vector m_aim_direction;
        Vector m_move;
        int m_buttons;
        char m_impulse;
        int m_select;
        int m_subtype;
        int m_seed;
        short m_mouse_dx;
        short m_mouse_dy;
        bool m_predicted;
        char pad[24];
    }
]])

local input_t = ffi.typeof([[struct {
    char			    pad0[0xC];				//0x0000
    bool				  bTrackIRAvailable;		//0x000C
    bool				  bMouseInitialized;		//0x000D
    bool				  bMouseActive;			//0x000E
    char    			pad1[0xB2];				//0x000F
    bool				  bCameraInThirdPerson;	//0x00C1
    char    			pad2[0x2];				//0x00C2
    Vector				vecCameraOffset;		//0x00C4
    char    			pad3[0x38];				//0x00D0
    $*            m_pCommands;			//0x0108
    uintptr_t*    pVerifiedCommands;		//0x010C
}]], user_cmd_t)

local g_input = ffi.cast(ffi.typeof("$**", input_t), ffi.cast("char*", client_find_signature("client.dll", "\xb9\xcc\xcc\xcc\xcc\xf3\x0f\x11\x04\x24\xff\x50\x10")) + 1)[0]

local g_ref_fakelag_limit = ui_reference("aa", "fake lag", "limit")
local g_ref_dt_fakelag_limit = ui_reference("rage", "other", "double tap fake lag limit")

local g_ref_yaw, g_ref_yaw_offset = ui_reference("aa", "anti-aimbot angles", "yaw")

local g_master_switch = ui_new_checkbox("aa", "other", "Enable extended desync")
local g_accent_color = ui_new_color_picker("aa", "other", "Extended desync color", 255, 170, 0, 0)
local g_hotkey = ui_new_hotkey("aa", "other", "Extended desync key")
local g_disabler_selection = ui_new_multiselect("aa", "other", "Extended desync disablers", {
    "Throwing grenade",
    "Double tap",
    "In air",
    "Moving"
})

local g_disabled_commands = {}

local g_run_command = function(data)
    if g_disabled_commands[(data.command_number % 150) + 1] then
        return
    end
    local ffi_cmd = g_input.m_pCommands[ data.command_number % 150 ]
    if not ffi_cmd then
        return
    end
    ffi_cmd.m_buttons = bit.bor(ffi_cmd.m_buttons, bit.lshift(1, 5))
end

local g_disablers = {
    ["Throwing grenade"] = function(cmd)
        local me = entity_get_local_player()
        local my_weapon = entity_get_player_weapon(me)
        local is_grenade = ({
            [43] = true, [44] = true,
            [45] = true, [46] = true,
            [47] = true, [48] = true,
            [68] = true
        })[ bit.band(0xffff, entity_get_prop(my_weapon, "m_iItemDefinitionIndex")) ] or false
        if not is_grenade then 
            return false
        end
        local throw_time = entity_get_prop(my_weapon, "m_fThrowTime")
        if cmd.in_attack == 0 or cmd.in_attack2 == 0 and throw_time > 0 then
            return true
        end
        return false
    end,
    ["Double tap"] = function()
        return antiaim_funcs.get_double_tap()
    end,
    ["In air"] = function(cmd)
        local me = entity_get_local_player()
        return entity_get_prop(me, "m_bOnGround") == 0 or cmd.in_jump == 1
    end,
    ["Moving"] = function(cmd)
        return math_max(cmd.in_forward, cmd.in_back, cmd.in_moveleft, cmd.in_moveright) > 0
    end
}

local g_active = false -- Yes, global variables are ugly - no, I'm not removing them

local g_setup_command = function(cmd)
    g_active = false
    local cmd_index = (cmd.command_number % 150) + 1
    if not ui_get(g_hotkey) or cmd.in_use == 1 or cmd.in_attack == 1 then
        g_disabled_commands[cmd_index] = true
        return
    end
    for iter, disabler in ipairs(ui_get(g_disabler_selection)) do
        if g_disablers[disabler](cmd) then
            g_disabled_commands[cmd_index] = true
            return
        end
    end
    g_disabled_commands[cmd_index] = false

    local ffi_cmd = g_input.m_pCommands[ cmd.command_number % 150 ]
    if not ffi_cmd then
        return
    end
    g_active = true
    local selected_lag_limit = (antiaim_funcs.get_double_tap() and g_ref_dt_fakelag_limit or g_ref_fakelag_limit)
    local lag_limit = ui_get(selected_lag_limit)
    local is_final_tick = globals_chokedcommands() >= math_max(1, lag_limit - 1)

    local current_threat = client_current_threat()
    local base_yaw
    if current_threat and entity_is_alive(current_threat) then
        base_yaw = ({ vector(entity_get_origin( entity_get_local_player() )):to( vector(entity_get_origin(current_threat)) ):angles() })[2] - 180
    end
    base_yaw = (base_yaw or cmd.yaw + 180) + ui_get(g_ref_yaw_offset)
    cmd.pitch, cmd.yaw = 89, ( not is_final_tick and (base_yaw - 120) or base_yaw )

    local is_applying_roll_jitter = lag_limit <= 4
    if is_applying_roll_jitter then
        ffi_cmd.m_view_angles.z = -45 * ( cmd.command_number % 2 == 0 and 1 or -1 )
    end
    cmd.allow_send_packet = false
    if is_final_tick then
        if not is_applying_roll_jitter then
            ffi_cmd.m_view_angles.z = -45
        end
        cmd.allow_send_packet = true
    end
end

local g_paint = function()
    if not ui_get(g_hotkey) or not g_active then
        return
    end

    local r, g, b, a = ui_get(g_accent_color)
    if a == 0 then
        return
    end
    local me = entity_get_local_player()
    if not me or not entity_is_alive(me) then
        return
    end
    renderer_indicator(r, g, b, a, "EXTENDED")
end

local g_ui_callback = function()
    local state = ui_get(g_master_switch)
    local fn = state and client.set_event_callback or client.unset_event_callback

    fn("setup_command", g_setup_command)
    fn("run_command", g_run_command)
    fn("paint", g_paint)

    ui_set_visible(g_hotkey, state)
    ui_set_visible(g_disabler_selection, state)
end

g_ui_callback()
ui_set_callback(g_master_switch, g_ui_callback)