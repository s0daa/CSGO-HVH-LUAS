local vector = require 'vector'
local c_entity = require 'gamesense/entity'
local http = require 'gamesense/http'
local base64 = require 'gamesense/base64'
local clipboard = require 'gamesense/clipboard'
local steamworks = require 'gamesense/steamworks'

local client_set_event_callback, client_unset_event_callback = client.set_event_callback, client.unset_event_callback
local entity_get_local_player, entity_get_player_weapon, entity_get_prop = entity.get_local_player, entity.get_player_weapon, entity.get_prop
local ui_get, ui_set, ui_set_callback, ui_set_visible, ui_reference, ui_new_checkbox, ui_new_slider = ui.get, ui.set, ui.set_callback, ui.set_visible, ui.reference, ui.new_checkbox, ui.new_slider

local reference = {
    double_tap = {ui.reference('RAGE', 'Aimbot', 'Double tap')},
    duck_peek_assist = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    pitch = {ui.reference('AA', 'Anti-aimbot angles', 'Pitch')},
    yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
    yaw_jitter = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
    body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
    freestanding_body_yaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    freestanding = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
    roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
    on_shot_anti_aim = {ui.reference('AA', 'Other', 'On shot anti-aim')},
    slow_motion = {ui.reference('AA', 'Other', 'Slow motion')},
    fakelag = {ui.reference('AA', 'Fake lag', 'Enabled')};
    fakelag_amount = ui.reference('AA', 'Fake lag', 'Amount');
    fakelag_variance = ui.reference('AA', 'Fake lag', 'Variance');
    fakelag_limit = ui.reference('AA', 'Fake lag', 'Limit');
    slow_motion = {ui.reference('AA', 'Other', 'Slow motion')};
    leg_movement = ui.reference('AA', 'Other', 'Leg movement');
    on_shot_anti_aim = {ui.reference('AA', 'Other', 'On shot anti-aim')};
    fake_peek = {ui.reference('AA', 'Other', 'Fake peek')};
};

local globals_frametime = globals.frametime
local globals_tickinterval = globals.tickinterval
local entity_is_enemy = entity.is_enemy
local entity_is_dormant = entity.is_dormant
local entity_is_alive = entity.is_alive
local entity_get_origin = entity.get_origin
local entity_get_player_resource = entity.get_player_resource
local table_insert = table.insert
local math_floor = math.floor

local last_press = 0
local direction = 0
local anti_aim_on_use_direction = 0
local cheked_ticks = 0

local E_POSE_PARAMETERS = {
    STRAFE_YAW = 0,
    STAND = 1,
    LEAN_YAW = 2,
    SPEED = 3,
    LADDER_YAW = 4,
    LADDER_SPEED = 5,
    JUMP_FALL = 6,
    MOVE_YAW = 7,
    MOVE_BLEND_CROUCH = 8,
    MOVE_BLEND_WALK = 9,
    MOVE_BLEND_RUN = 10,
    BODY_YAW = 11,
    BODY_PITCH = 12,
    AIM_BLEND_STAND_IDLE = 13,
    AIM_BLEND_STAND_WALK = 14,
    AIM_BLEND_STAND_RUN = 14,
    AIM_BLEND_CROUCH_IDLE = 16,
    AIM_BLEND_CROUCH_WALK = 17,
    DEATH_YAW = 18
}

local function contains(source, target)
	for id, name in pairs(ui.get(source)) do
		if name == target then
			return true
		end
	end

	return false
end

local function is_defensive(index)
    cheked_ticks = math.max(entity.get_prop(index, 'm_nTickBase'), cheked_ticks or 0)

    return math.abs(entity.get_prop(index, 'm_nTickBase') - cheked_ticks) > 2 and math.abs(entity.get_prop(index, 'm_nTickBase') - cheked_ticks) < 14
end

local settings = {}
local anti_aim_settings = {}
local anti_aim_states = {'Global', 'Standing', 'Moving', 'Slow motion', 'Crouching', 'Crouching & moving', 'In air', 'In air & crouching', 'No exploits', 'On use'}
local anti_aim_different = {'', ' ', '  ', '   ', '    ', '     ', '      ', '       ', '        ', '         '}

current_tab = ui.new_combobox('AA', 'Anti-aimbot angles', 'Tabs', {'Home', 'Anti-Aim', 'Keybinds'})
local text1 = ui.new_label('AA', 'Anti-aimbot angles', ' ', 'string')
local text2 = ui.new_label('AA', 'Anti-aimbot angles', 'I N V I N S I B L E ~ RECODE', 'string')
local text3 = ui.new_label('AA', 'Anti-aimbot angles', ' ', 'string')
local text4 = ui.new_label('AA', 'Fake lag', 'Misc/Visuals')
local text5 = ui.new_label('AA', 'Fake lag', '\aFFFFFF6F━━━━━━━━━━━━━━━━━━━━━━━━━━━')
local text6 = ui.new_label('AA', 'Fake lag', ' ')
local text7 = ui.new_label('AA', 'Other', 'Animations')
local text8 = ui.new_label('AA', 'Other', '\aFFFFFF6F━━━━━━━━━━━━━━━━━━━━━━━━━━━')
settings.anti_aim_state = ui.new_combobox('AA', 'Anti-aimbot angles', 'Anti-aimbot state', anti_aim_states) 

local master_switch = ui.new_checkbox('AA', 'Fake lag', 'Log Aimbot Shots')
local console_filter = ui.new_checkbox('AA', 'Fake lag', 'Console Filter')
local anim_breakerx = ui.new_checkbox('AA', 'Other', 'Skeet leg fucker')
local m_elements = ui.new_multiselect("AA", "Other", "Anim Breaker", {"earthquake", "airbreak", "kangaroo"})
local force_safe_point = ui.reference('RAGE', 'Aimbot', 'Force safe point')
local trashtalk = ui.new_checkbox('AA', 'Fake lag', 'Trash Talk')
local clantagchanger = ui.new_checkbox('AA', 'Fake lag', 'Clan Tag')
local fastladder = ui.new_checkbox('AA', 'Fake lag', 'Fast Ladder')
local hitmarker = ui.new_checkbox('AA', 'Fake lag', '3D Hit Marker')

local aspectratio = ui.new_slider('AA', 'Fake lag', 'Aspect Ratio', 0, 200, 0, true, nil, 0.01, {[0] = "Off"})

local override_zoom_fov = ui_reference("Misc", "Miscellaneous", "Override zoom FOV")
local cache = ui.get(override_zoom_fov)
local scope_fov = ui_new_slider('AA', 'Fake lag', "Second Zoom FOV", -0, 100, 0, true, '%', 1, {[0] = "Off"})

for i = 1, #anti_aim_states do
    anti_aim_settings[i] = {
        override_state = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Override ' .. string.lower(anti_aim_states[i])),
        pitch1 = ui.new_combobox('AA', 'Anti-aimbot angles', 'Pitch' .. anti_aim_different[i], 'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random', 'Custom'),
        pitch2 = ui.new_slider('AA', 'Anti-aimbot angles', '\nPitch' .. anti_aim_different[i], -89, 89, 0, true, '°'),
        yaw_base = ui.new_combobox('AA', 'Anti-aimbot angles', 'Yaw base' .. anti_aim_different[i], 'Local view', 'At targets'),
        yaw1 = ui.new_combobox('AA', 'Anti-aimbot angles', 'Yaw' .. anti_aim_different[i], 'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'),
        yaw2_left = ui.new_slider('AA', 'Anti-aimbot angles', 'Yaw left' .. anti_aim_different[i], -180, 180, 0, true, '°'),
        yaw2_right = ui.new_slider('AA', 'Anti-aimbot angles', 'Yaw right' .. anti_aim_different[i], -180, 180, 0, true, '°'),
        yaw2_randomize = ui.new_slider('AA', 'Anti-aimbot angles', 'Yaw randomize' .. anti_aim_different[i], 0, 180, 0, true, '°'),
        yaw_jitter1 = ui.new_combobox('AA', 'Anti-aimbot angles', 'Yaw jitter' .. anti_aim_different[i], 'Off', 'Offset', 'Center', 'Random', 'Skitter', 'Delay'),
        yaw_jitter2_left = ui.new_slider('AA', 'Anti-aimbot angles', 'Yaw jitter left' .. anti_aim_different[i], -180, 180, 0, true, '°'),
        yaw_jitter2_right = ui.new_slider('AA', 'Anti-aimbot angles', 'Yaw jitter right' .. anti_aim_different[i], -180, 180, 0, true, '°'),
        yaw_jitter2_randomize = ui.new_slider('AA', 'Anti-aimbot angles', 'Yaw jitter randomize' .. anti_aim_different[i], 0, 180, 0, true, '°'),
        yaw_jitter2_delay = ui.new_slider('AA', 'Anti-aimbot angles', 'Yaw jitter delay' .. anti_aim_different[i], 2, 10, 2, true, 't'),
        body_yaw1 = ui.new_combobox('AA', 'Anti-aimbot angles', 'Body yaw' .. anti_aim_different[i], 'Off', 'Opposite', 'Jitter', 'Static'),
        body_yaw2 = ui.new_slider('AA', 'Anti-aimbot angles', 'Body Yaw' .. anti_aim_different[i], -180, 180, 0, true, '°'),
        freestanding_body_yaw = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Freestanding body yaw' .. anti_aim_different[i]),
        roll = ui.new_slider('AA', 'Anti-aimbot angles', 'Roll' .. anti_aim_different[i], -45, 45, 0, true, '°'),
        force_defensive = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Force defensive' .. anti_aim_different[i]),
        defensive_anti_aimbot = ui.new_checkbox('AA', 'Anti-aimbot angles', '\aB6B665FF✥ Defensive AA' .. anti_aim_different[i]),
        defensive_pitch = ui.new_checkbox('AA', 'Anti-aimbot angles', '\aB6B665FF· Pitch' .. anti_aim_different[i]),
        defensive_pitch1 = ui.new_combobox('AA', 'Anti-aimbot angles', '\n· Pitch 2' .. anti_aim_different[i], 'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random', 'Custom'),
        defensive_pitch2 = ui.new_slider('AA', 'Anti-aimbot angles', '\n· Pitch 3' .. anti_aim_different[i], -89, 89, 0, true, '°'),
        defensive_pitch3 = ui.new_slider('AA', 'Anti-aimbot angles', '\n· Pitch 4' .. anti_aim_different[i], -89, 89, 0, true, '°'),
        defensive_yaw = ui.new_checkbox('AA', 'Anti-aimbot angles', '\aB6B665FF· Yaw' .. anti_aim_different[i]),
        defensive_yaw1 = ui.new_combobox('AA', 'Anti-aimbot angles', '· Yaw 1' .. anti_aim_different[i], '180', 'Spin', '180 Z', 'Sideways', 'Random'),
        defensive_yaw2 = ui.new_slider('AA', 'Anti-aimbot angles', '· Yaw 2' .. anti_aim_different[i], -180, 180, 0, true, '°')
    }
end

settings.warmup_disabler = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Warmup disabler')
settings.avoid_backstab = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Avoid backstab')
settings.safe_head_in_air = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Safe head in air')
settings.manual_forward = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual forward')
settings.manual_right = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual right')
settings.manual_left = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual left')
settings.edge_yaw = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Edge yaw')
settings.freestanding = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Freestanding')
settings.freestanding_conditions = ui.new_multiselect('AA', 'Anti-aimbot angles', '\nFreestanding', 'Standing', 'Moving', 'Slow motion', 'Crouching', 'In air')
settings.tweaks = ui.new_multiselect('AA', 'Anti-aimbot angles', '\nTweaks', 'Off jitter while freestanding', 'Off jitter on manual')

local data = {
    integers = {
        settings.anti_aim_state,
        anti_aim_settings[1].override_state, anti_aim_settings[2].override_state, anti_aim_settings[3].override_state, anti_aim_settings[4].override_state, anti_aim_settings[5].override_state, anti_aim_settings[6].override_state, anti_aim_settings[7].override_state, anti_aim_settings[8].override_state, anti_aim_settings[9].override_state, anti_aim_settings[10].override_state,
        anti_aim_settings[1].force_defensive, anti_aim_settings[2].force_defensive, anti_aim_settings[3].force_defensive, anti_aim_settings[4].force_defensive, anti_aim_settings[5].force_defensive, anti_aim_settings[6].force_defensive, anti_aim_settings[7].force_defensive, anti_aim_settings[8].force_defensive, anti_aim_settings[9].force_defensive, anti_aim_settings[10].force_defensive,
        anti_aim_settings[1].pitch1, anti_aim_settings[2].pitch1, anti_aim_settings[3].pitch1, anti_aim_settings[4].pitch1, anti_aim_settings[5].pitch1, anti_aim_settings[6].pitch1, anti_aim_settings[7].pitch1, anti_aim_settings[8].pitch1, anti_aim_settings[9].pitch1, anti_aim_settings[10].pitch1,
        anti_aim_settings[1].pitch2, anti_aim_settings[2].pitch2, anti_aim_settings[3].pitch2, anti_aim_settings[4].pitch2, anti_aim_settings[5].pitch2, anti_aim_settings[6].pitch2, anti_aim_settings[7].pitch2, anti_aim_settings[8].pitch2, anti_aim_settings[9].pitch2, anti_aim_settings[10].pitch2,
        anti_aim_settings[1].yaw_base, anti_aim_settings[2].yaw_base, anti_aim_settings[3].yaw_base, anti_aim_settings[4].yaw_base, anti_aim_settings[5].yaw_base, anti_aim_settings[6].yaw_base, anti_aim_settings[7].yaw_base, anti_aim_settings[8].yaw_base, anti_aim_settings[9].yaw_base, anti_aim_settings[10].yaw_base,
        anti_aim_settings[1].yaw1, anti_aim_settings[2].yaw1, anti_aim_settings[3].yaw1, anti_aim_settings[4].yaw1, anti_aim_settings[5].yaw1, anti_aim_settings[6].yaw1, anti_aim_settings[7].yaw1, anti_aim_settings[8].yaw1, anti_aim_settings[9].yaw1, anti_aim_settings[10].yaw1,
        anti_aim_settings[1].yaw2_left, anti_aim_settings[2].yaw2_left, anti_aim_settings[3].yaw2_left, anti_aim_settings[4].yaw2_left, anti_aim_settings[5].yaw2_left, anti_aim_settings[6].yaw2_left, anti_aim_settings[7].yaw2_left, anti_aim_settings[8].yaw2_left, anti_aim_settings[9].yaw2_left, anti_aim_settings[10].yaw2_left,
        anti_aim_settings[1].yaw2_right, anti_aim_settings[2].yaw2_right, anti_aim_settings[3].yaw2_right, anti_aim_settings[4].yaw2_right, anti_aim_settings[5].yaw2_right, anti_aim_settings[6].yaw2_right, anti_aim_settings[7].yaw2_right, anti_aim_settings[8].yaw2_right, anti_aim_settings[9].yaw2_right, anti_aim_settings[10].yaw2_right,
        anti_aim_settings[1].yaw2_randomize, anti_aim_settings[2].yaw2_randomize, anti_aim_settings[3].yaw2_randomize, anti_aim_settings[4].yaw2_randomize, anti_aim_settings[5].yaw2_randomize, anti_aim_settings[6].yaw2_randomize, anti_aim_settings[7].yaw2_randomize, anti_aim_settings[8].yaw2_randomize, anti_aim_settings[9].yaw2_randomize, anti_aim_settings[10].yaw2_randomize,
        anti_aim_settings[1].yaw_jitter1, anti_aim_settings[2].yaw_jitter1, anti_aim_settings[3].yaw_jitter1, anti_aim_settings[4].yaw_jitter1, anti_aim_settings[5].yaw_jitter1, anti_aim_settings[6].yaw_jitter1, anti_aim_settings[7].yaw_jitter1, anti_aim_settings[8].yaw_jitter1, anti_aim_settings[9].yaw_jitter1, anti_aim_settings[10].yaw_jitter1,
        anti_aim_settings[1].yaw_jitter2_left, anti_aim_settings[2].yaw_jitter2_left, anti_aim_settings[3].yaw_jitter2_left, anti_aim_settings[4].yaw_jitter2_left, anti_aim_settings[5].yaw_jitter2_left, anti_aim_settings[6].yaw_jitter2_left, anti_aim_settings[7].yaw_jitter2_left, anti_aim_settings[8].yaw_jitter2_left, anti_aim_settings[9].yaw_jitter2_left, anti_aim_settings[10].yaw_jitter2_left,
        anti_aim_settings[1].yaw_jitter2_right, anti_aim_settings[2].yaw_jitter2_right, anti_aim_settings[3].yaw_jitter2_right, anti_aim_settings[4].yaw_jitter2_right, anti_aim_settings[5].yaw_jitter2_right, anti_aim_settings[6].yaw_jitter2_right, anti_aim_settings[7].yaw_jitter2_right, anti_aim_settings[8].yaw_jitter2_right, anti_aim_settings[9].yaw_jitter2_right, anti_aim_settings[10].yaw_jitter2_right,
        anti_aim_settings[1].yaw_jitter2_randomize, anti_aim_settings[2].yaw_jitter2_randomize, anti_aim_settings[3].yaw_jitter2_randomize, anti_aim_settings[4].yaw_jitter2_randomize, anti_aim_settings[5].yaw_jitter2_randomize, anti_aim_settings[6].yaw_jitter2_randomize, anti_aim_settings[7].yaw_jitter2_randomize, anti_aim_settings[8].yaw_jitter2_randomize, anti_aim_settings[9].yaw_jitter2_randomize, anti_aim_settings[10].yaw_jitter2_randomize,
        anti_aim_settings[1].yaw_jitter2_delay, anti_aim_settings[2].yaw_jitter2_delay, anti_aim_settings[3].yaw_jitter2_delay, anti_aim_settings[4].yaw_jitter2_delay, anti_aim_settings[5].yaw_jitter2_delay, anti_aim_settings[6].yaw_jitter2_delay, anti_aim_settings[7].yaw_jitter2_delay, anti_aim_settings[8].yaw_jitter2_delay, anti_aim_settings[9].yaw_jitter2_delay, anti_aim_settings[10].yaw_jitter2_delay,
        anti_aim_settings[1].body_yaw1, anti_aim_settings[2].body_yaw1, anti_aim_settings[3].body_yaw1, anti_aim_settings[4].body_yaw1, anti_aim_settings[5].body_yaw1, anti_aim_settings[6].body_yaw1, anti_aim_settings[7].body_yaw1, anti_aim_settings[8].body_yaw1, anti_aim_settings[9].body_yaw1, anti_aim_settings[10].body_yaw1,
        anti_aim_settings[1].body_yaw2, anti_aim_settings[2].body_yaw2, anti_aim_settings[3].body_yaw2, anti_aim_settings[4].body_yaw2, anti_aim_settings[5].body_yaw2, anti_aim_settings[6].body_yaw2, anti_aim_settings[7].body_yaw2, anti_aim_settings[8].body_yaw2, anti_aim_settings[9].body_yaw2, anti_aim_settings[10].body_yaw2,
        anti_aim_settings[1].freestanding_body_yaw, anti_aim_settings[2].freestanding_body_yaw, anti_aim_settings[3].freestanding_body_yaw, anti_aim_settings[4].freestanding_body_yaw, anti_aim_settings[5].freestanding_body_yaw, anti_aim_settings[6].freestanding_body_yaw, anti_aim_settings[7].freestanding_body_yaw, anti_aim_settings[8].freestanding_body_yaw, anti_aim_settings[9].freestanding_body_yaw, anti_aim_settings[10].freestanding_body_yaw,
        anti_aim_settings[1].roll, anti_aim_settings[2].roll, anti_aim_settings[3].roll, anti_aim_settings[4].roll, anti_aim_settings[5].roll, anti_aim_settings[6].roll, anti_aim_settings[7].roll, anti_aim_settings[8].roll, anti_aim_settings[9].roll, anti_aim_settings[10].roll,
        anti_aim_settings[1].defensive_anti_aimbot, anti_aim_settings[2].defensive_anti_aimbot, anti_aim_settings[3].defensive_anti_aimbot, anti_aim_settings[4].defensive_anti_aimbot, anti_aim_settings[5].defensive_anti_aimbot, anti_aim_settings[6].defensive_anti_aimbot, anti_aim_settings[7].defensive_anti_aimbot, anti_aim_settings[8].defensive_anti_aimbot, anti_aim_settings[9].defensive_anti_aimbot, anti_aim_settings[10].defensive_anti_aimbot,
        anti_aim_settings[1].defensive_pitch, anti_aim_settings[2].defensive_pitch, anti_aim_settings[3].defensive_pitch, anti_aim_settings[4].defensive_pitch, anti_aim_settings[5].defensive_pitch, anti_aim_settings[6].defensive_pitch, anti_aim_settings[7].defensive_pitch, anti_aim_settings[8].defensive_pitch, anti_aim_settings[9].defensive_pitch, anti_aim_settings[10].defensive_pitch,
        anti_aim_settings[1].defensive_pitch1, anti_aim_settings[2].defensive_pitch1, anti_aim_settings[3].defensive_pitch1, anti_aim_settings[4].defensive_pitch1, anti_aim_settings[5].defensive_pitch1, anti_aim_settings[6].defensive_pitch1, anti_aim_settings[7].defensive_pitch1, anti_aim_settings[8].defensive_pitch1, anti_aim_settings[9].defensive_pitch1, anti_aim_settings[10].defensive_pitch1,
        anti_aim_settings[1].defensive_pitch2, anti_aim_settings[2].defensive_pitch2, anti_aim_settings[3].defensive_pitch2, anti_aim_settings[4].defensive_pitch2, anti_aim_settings[5].defensive_pitch2, anti_aim_settings[6].defensive_pitch2, anti_aim_settings[7].defensive_pitch2, anti_aim_settings[8].defensive_pitch2, anti_aim_settings[9].defensive_pitch2, anti_aim_settings[10].defensive_pitch2,
        anti_aim_settings[1].defensive_pitch3, anti_aim_settings[2].defensive_pitch3, anti_aim_settings[3].defensive_pitch3, anti_aim_settings[4].defensive_pitch3, anti_aim_settings[5].defensive_pitch3, anti_aim_settings[6].defensive_pitch3, anti_aim_settings[7].defensive_pitch3, anti_aim_settings[8].defensive_pitch3, anti_aim_settings[9].defensive_pitch3, anti_aim_settings[10].defensive_pitch3,
        anti_aim_settings[1].defensive_yaw, anti_aim_settings[2].defensive_yaw, anti_aim_settings[3].defensive_yaw, anti_aim_settings[4].defensive_yaw, anti_aim_settings[5].defensive_yaw, anti_aim_settings[6].defensive_yaw, anti_aim_settings[7].defensive_yaw, anti_aim_settings[8].defensive_yaw, anti_aim_settings[9].defensive_yaw, anti_aim_settings[10].defensive_yaw,
        anti_aim_settings[1].defensive_yaw1, anti_aim_settings[2].defensive_yaw1, anti_aim_settings[3].defensive_yaw1, anti_aim_settings[4].defensive_yaw1, anti_aim_settings[5].defensive_yaw1, anti_aim_settings[6].defensive_yaw1, anti_aim_settings[7].defensive_yaw1, anti_aim_settings[8].defensive_yaw1, anti_aim_settings[9].defensive_yaw1, anti_aim_settings[10].defensive_yaw1,
        anti_aim_settings[1].defensive_yaw2, anti_aim_settings[2].defensive_yaw2, anti_aim_settings[3].defensive_yaw2, anti_aim_settings[4].defensive_yaw2, anti_aim_settings[5].defensive_yaw2, anti_aim_settings[6].defensive_yaw2, anti_aim_settings[7].defensive_yaw2, anti_aim_settings[8].defensive_yaw2, anti_aim_settings[9].defensive_yaw2, anti_aim_settings[10].defensive_yaw2,
        settings.avoid_backstab,
        settings.safe_head_in_air,
        settings.freestanding_conditions,
        settings.tweaks, master_switch, console_filter, anim_breakerx, scope_fov, trashtalk, aspectratio, hitmarker, fastladder, clantagchanger, settings.warmup_disabler
    }
}

local function import(text)
    local status, config =
        pcall(
        function()
            return json.parse(base64.decode(text))
        end
    )

    if not status or status == nil then
        client.color_log(255, 0, 0, "[Invinsible]\0")
	    client.color_log(200, 200, 200, " error while importing!")
        return
    end

    if config ~= nil then
        for k, v in pairs(config) do
            k = ({[1] = 'integers'})[k]

            for k2, v2 in pairs(v) do
                if k == 'integers' then
                    ui.set(data[k][k2], v2)
                end
            end
        end
    end

    client.color_log(124, 252, 0, "[Invinsible]\0")
	client.color_log(200, 200, 200, " config successfully imported!")

end

client.set_event_callback('setup_command', function(cmd)
    local self = entity.get_local_player()

    if entity.get_player_weapon(self) == nil then return end

    local using = false
    local anti_aim_on_use = false

    local inverted = entity.get_prop(self, "m_flPoseParameter", 11) * 120 - 60

    local is_planting = entity.get_prop(self, 'm_bInBombZone') == 1 and entity.get_classname(entity.get_player_weapon(self)) == 'CC4' and entity.get_prop(self, 'm_iTeamNum') == 2
    local CPlantedC4 = entity.get_all('CPlantedC4')[1]

    local eye_x, eye_y, eye_z = client.eye_position()
	local pitch, yaw = client.camera_angles()

    local sin_pitch = math.sin(math.rad(pitch))
	local cos_pitch = math.cos(math.rad(pitch))

	local sin_yaw = math.sin(math.rad(yaw))
	local cos_yaw = math.cos(math.rad(yaw))

    local direction_vector = {cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch}

    local fraction, entity_index = client.trace_line(self, eye_x, eye_y, eye_z, eye_x + (direction_vector[1] * 8192), eye_y + (direction_vector[2] * 8192), eye_z + (direction_vector[3] * 8192))

    if CPlantedC4 ~= nil then
        dist_to_c4 = vector(entity.get_prop(self, 'm_vecOrigin')):dist(vector(entity.get_prop(CPlantedC4, 'm_vecOrigin')))

        if entity.get_prop(CPlantedC4, 'm_bBombDefused') == 1 then dist_to_c4 = 56 end

        is_defusing = dist_to_c4 < 56 and entity.get_prop(self, 'm_iTeamNum') == 3
    end

    if entity_index ~= -1 then
        if vector(entity.get_prop(self, 'm_vecOrigin')):dist(vector(entity.get_prop(entity_index, 'm_vecOrigin'))) < 146 then
            using = entity.get_classname(entity_index) ~= 'CWorld' and entity.get_classname(entity_index) ~= 'CFuncBrush' and entity.get_classname(entity_index) ~= 'CCSPlayer'
        end
    end

    if cmd.in_use == 1 and not using and not is_planting and not is_defusing and ui.get(anti_aim_settings[10].override_state) then cmd.buttons = bit.band(cmd.buttons, bit.bnot(bit.lshift(1, 5))); anti_aim_on_use = true; state_id = 10 else if (ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2])) == false and (ui.get(reference.on_shot_anti_aim[1]) and ui.get(reference.on_shot_anti_aim[2])) == false and ui.get(anti_aim_settings[9].override_state) then anti_aim_on_use = false; state_id = 9 else if (cmd.in_jump == 1 or bit.band(entity.get_prop(self, 'm_fFlags'), 1) == 0) and entity.get_prop(self, 'm_flDuckAmount') > 0.8 and ui.get(anti_aim_settings[8].override_state) then anti_aim_on_use = false; state_id = 8 elseif (cmd.in_jump == 1 or bit.band(entity.get_prop(self, 'm_fFlags'), 1) == 0) and entity.get_prop(self, 'm_flDuckAmount') < 0.8 and ui.get(anti_aim_settings[7].override_state) then anti_aim_on_use = false; state_id = 7 elseif bit.band(entity.get_prop(self, 'm_fFlags'), 1) ~= 0 and (entity.get_prop(self, 'm_flDuckAmount') > 0.8 or ui.get(reference.duck_peek_assist)) and vector(entity.get_prop(self, 'm_vecVelocity')):length() > 2 and ui.get(anti_aim_settings[6].override_state) then anti_aim_on_use = false; state_id = 6 elseif bit.band(entity.get_prop(self, 'm_fFlags'), 1) ~= 0 and entity.get_prop(self, 'm_flDuckAmount') > 0.8 and vector(entity.get_prop(self, 'm_vecVelocity')):length() < 2 and ui.get(anti_aim_settings[5].override_state) then anti_aim_on_use = false; state_id = 5 elseif bit.band(entity.get_prop(self, 'm_fFlags'), 1) ~= 0 and vector(entity.get_prop(self, 'm_vecVelocity')):length() > 2 and entity.get_prop(self, 'm_flDuckAmount') < 0.8 and (ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2])) == true and ui.get(anti_aim_settings[4].override_state) then anti_aim_on_use = false; state_id = 4 elseif bit.band(entity.get_prop(self, 'm_fFlags'), 1) ~= 0 and vector(entity.get_prop(self, 'm_vecVelocity')):length() > 2 and entity.get_prop(self, 'm_flDuckAmount') < 0.8 and (ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2])) == false and ui.get(anti_aim_settings[3].override_state) then anti_aim_on_use = false; state_id = 3 elseif bit.band(entity.get_prop(self, 'm_fFlags'), 1) ~= 0 and vector(entity.get_prop(self, 'm_vecVelocity')):length() < 2 and entity.get_prop(self, 'm_flDuckAmount') < 0.8 and ui.get(anti_aim_settings[2].override_state) then anti_aim_on_use = false; state_id = 2 else anti_aim_on_use = false; state_id = 1 end end end
    if cmd.in_jump == 1 or bit.band(entity.get_prop(self, 'm_fFlags'), 1) == 0 then freestanding_state_id = 5 elseif (entity.get_prop(self, 'm_flDuckAmount') > 0.8 or ui.get(reference.duck_peek_assist)) and bit.band(entity.get_prop(self, 'm_fFlags'), 1) ~= 0 then freestanding_state_id = 4 elseif bit.band(entity.get_prop(self, 'm_fFlags'), 1) ~= 0 and vector(entity.get_prop(self, 'm_vecVelocity')):length() > 2 and (ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2])) == true then freestanding_state_id = 3 elseif bit.band(entity.get_prop(self, 'm_fFlags'), 1) ~= 0 and vector(entity.get_prop(self, 'm_vecVelocity')):length() > 2 and (ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2])) == false then freestanding_state_id = 2 elseif bit.band(entity.get_prop(self, 'm_fFlags'), 1) ~= 0 and vector(entity.get_prop(self, 'm_vecVelocity')):length() < 2 then freestanding_state_id = 1 end

    ui.set(settings.manual_forward, 'On hotkey')
    ui.set(settings.manual_right, 'On hotkey')
    ui.set(settings.manual_left, 'On hotkey')

    cmd.force_defensive = ui.get(anti_aim_settings[state_id].force_defensive)

    ui.set(reference.pitch[1], ui.get(anti_aim_settings[state_id].pitch1))
    ui.set(reference.pitch[2], ui.get(anti_aim_settings[state_id].pitch2))
    ui.set(reference.yaw_base, (direction == 180 or direction == 90 or direction == -90) and anti_aim_on_use == false and 'Local view' or ui.get(anti_aim_settings[state_id].yaw_base))
    ui.set(reference.yaw[1], (direction == 180 or direction == 90 or direction == -90) and anti_aim_on_use == false and '180' or ui.get(anti_aim_settings[state_id].yaw1))

    if ui.get(anti_aim_settings[state_id].yaw1) ~= 'Off' and ui.get(anti_aim_settings[state_id].yaw_jitter1) == 'Delay' then
        if inverted > 0 then
            if ui.get(settings.manual_left) and last_press + 0.2 < globals.realtime() then
                direction = direction == -90 and ui.get(anti_aim_settings[state_id].yaw_jitter2_left) or -90

                last_press = globals.realtime()
            elseif ui.get(settings.manual_right) and last_press + 0.2 < globals.realtime() then
                direction = direction == 90 and ui.get(anti_aim_settings[state_id].yaw_jitter2_left) or 90

                last_press = globals.realtime()
            elseif ui.get(settings.manual_forward) and last_press + 0.2 < globals.realtime() then
                direction = direction == 180 and ui.get(anti_aim_settings[state_id].yaw_jitter2_left) or 180

                last_press = globals.realtime()
            end
        else
            if ui.get(settings.manual_left) and last_press + 0.2 < globals.realtime() then
                direction = direction == -90 and ui.get(anti_aim_settings[state_id].yaw_jitter2_right) or -90

                last_press = globals.realtime()
            elseif ui.get(settings.manual_right) and last_press + 0.2 < globals.realtime() then
                direction = direction == 90 and ui.get(anti_aim_settings[state_id].yaw_jitter2_right) or 90

                last_press = globals.realtime()
            elseif ui.get(settings.manual_forward) and last_press + 0.2 < globals.realtime() then
                direction = direction == 180 and ui.get(anti_aim_settings[state_id].yaw_jitter2_right) or 180

                last_press = globals.realtime()
            end
        end
    else
        if inverted > 0 then
            if ui.get(settings.manual_left) and last_press + 0.2 < globals.realtime() then
                direction = direction == -90 and ui.get(anti_aim_settings[state_id].yaw2_left) or -90

                last_press = globals.realtime()
            elseif ui.get(settings.manual_right) and last_press + 0.2 < globals.realtime() then
                direction = direction == 90 and ui.get(anti_aim_settings[state_id].yaw2_left) or 90

                last_press = globals.realtime()
            elseif ui.get(settings.manual_forward) and last_press + 0.2 < globals.realtime() then
                direction = direction == 180 and ui.get(anti_aim_settings[state_id].yaw2_left) or 180

                last_press = globals.realtime()
            end
        else
            if ui.get(settings.manual_left) and last_press + 0.2 < globals.realtime() then
                direction = direction == -90 and ui.get(anti_aim_settings[state_id].yaw2_right) or -90

                last_press = globals.realtime()
            elseif ui.get(settings.manual_right) and last_press + 0.2 < globals.realtime() then
                direction = direction == 90 and ui.get(anti_aim_settings[state_id].yaw2_right) or 90

                last_press = globals.realtime()
            elseif ui.get(settings.manual_forward) and last_press + 0.2 < globals.realtime() then
                direction = direction == 180 and ui.get(anti_aim_settings[state_id].yaw2_right) or 180

                last_press = globals.realtime()
            end
        end
    end

    if ui.get(anti_aim_settings[state_id].yaw1) ~= 'Off' and ui.get(anti_aim_settings[state_id].yaw_jitter1) == 'Delay' then
        if math.random(0, 1) ~= 0 then
            yaw_jitter2_left = ui.get(anti_aim_settings[state_id].yaw_jitter2_left) - math.random(0, ui.get(anti_aim_settings[state_id].yaw_jitter2_randomize))
            yaw_jitter2_right = ui.get(anti_aim_settings[state_id].yaw_jitter2_right) - math.random(0, ui.get(anti_aim_settings[state_id].yaw_jitter2_randomize))
        else
            yaw_jitter2_left = ui.get(anti_aim_settings[state_id].yaw_jitter2_left) + math.random(0, ui.get(anti_aim_settings[state_id].yaw_jitter2_randomize))
            yaw_jitter2_right = ui.get(anti_aim_settings[state_id].yaw_jitter2_right) + math.random(0, ui.get(anti_aim_settings[state_id].yaw_jitter2_randomize))
        end

        if inverted > 0 then
            if yaw_jitter2_left == 180 then yaw_jitter2_left = -180 elseif yaw_jitter2_left == 90 then yaw_jitter2_left = 89 elseif yaw_jitter2_left == -90 then yaw_jitter2_left = -89 end

            if not (direction == 180 or direction == 90 or direction == -90) then direction = yaw_jitter2_left end
        else
            if yaw_jitter2_right == 180 then yaw_jitter2_right = -180 elseif yaw_jitter2_right == 90 then yaw_jitter2_right = 89 elseif yaw_jitter2_right == -90 then yaw_jitter2_right = -89 end

            if not (direction == 180 or direction == 90 or direction == -90) then direction = yaw_jitter2_right end
        end
    else
        if inverted > 0 then
            if math.random(0, 1) ~= 0 then yaw2_left = ui.get(anti_aim_settings[state_id].yaw2_left) - math.random(0, ui.get(anti_aim_settings[state_id].yaw2_randomize)) else yaw2_left = ui.get(anti_aim_settings[state_id].yaw2_left) + math.random(0, ui.get(anti_aim_settings[state_id].yaw2_randomize)) end

            if yaw2_left == 180 then yaw2_left = -180 elseif yaw2_left == 90 then yaw2_left = 89 elseif yaw2_left == -90 then yaw2_left = -89 end

            if not (direction == 90 or direction == -90 or direction == 180) then direction = yaw2_left end
        else
            if math.random(0, 1) ~= 0 then yaw2_right = ui.get(anti_aim_settings[state_id].yaw2_right) - math.random(0, ui.get(anti_aim_settings[state_id].yaw2_randomize)) else yaw2_right = ui.get(anti_aim_settings[state_id].yaw2_right) + math.random(0, ui.get(anti_aim_settings[state_id].yaw2_randomize)) end

            if yaw2_right == 180 then yaw2_right = -180 elseif yaw2_right == 90 then yaw2_right = 89 elseif yaw2_right == -90 then yaw2_right = -89 end

            if not (direction == 90 or direction == -90 or direction == 180) then direction = yaw2_right end
        end
    end

    if anti_aim_on_use == true then
        if ui.get(anti_aim_settings[state_id].yaw1) ~= 'Off' and ui.get(anti_aim_settings[state_id].yaw_jitter1) == 'Delay' then
            if inverted > 0 then
                if math.random(0, 1) ~= 0 then
                    anti_aim_on_use_direction = ui.get(anti_aim_settings[state_id].yaw_jitter2_left) - math.random(0, ui.get(anti_aim_settings[state_id].yaw_jitter2_randomize))
                else
                    anti_aim_on_use_direction = ui.get(anti_aim_settings[state_id].yaw_jitter2_left) + math.random(0, ui.get(anti_aim_settings[state_id].yaw_jitter2_randomize))
                end
            else
                if math.random(0, 1) ~= 0 then
                    anti_aim_on_use_direction = ui.get(anti_aim_settings[state_id].yaw_jitter2_right) - math.random(0, ui.get(anti_aim_settings[state_id].yaw_jitter2_randomize))
                else
                    anti_aim_on_use_direction = ui.get(anti_aim_settings[state_id].yaw_jitter2_right) + math.random(0, ui.get(anti_aim_settings[state_id].yaw_jitter2_randomize))
                end
            end
        else
            if inverted > 0 then
                if math.random(0, 1) ~= 0 then
                    anti_aim_on_use_direction = ui.get(anti_aim_settings[state_id].yaw2_left) - math.random(0, ui.get(anti_aim_settings[state_id].yaw2_randomize))
                else
                    anti_aim_on_use_direction = ui.get(anti_aim_settings[state_id].yaw2_left) + math.random(0, ui.get(anti_aim_settings[state_id].yaw2_randomize))
                end
            else
                if math.random(0, 1) ~= 0 then
                    anti_aim_on_use_direction = ui.get(anti_aim_settings[state_id].yaw2_right) - math.random(0, ui.get(anti_aim_settings[state_id].yaw2_randomize))
                else
                    anti_aim_on_use_direction = ui.get(anti_aim_settings[state_id].yaw2_right) + math.random(0, ui.get(anti_aim_settings[state_id].yaw2_randomize))
                end
            end
        end
    end

    if direction > 180 or direction < -180 then direction = -180 end
    if anti_aim_on_use_direction > 180 or anti_aim_on_use_direction < -180 then anti_aim_on_use_direction = -180 end

    ui.set(reference.yaw[2], anti_aim_on_use == false and direction or anti_aim_on_use_direction)
    ui.set(reference.yaw_jitter[1], ((direction == 180 or direction == 90 or direction == -90) and contains(settings.tweaks, 'Off jitter on manual') and anti_aim_on_use == false or ui.get(anti_aim_settings[state_id].yaw_jitter1) == 'Delay' or ui.get(anti_aim_settings[state_id].yaw1) == 'Off') and 'Off' or ui.get(anti_aim_settings[state_id].yaw_jitter1))

    if inverted > 0 then
        if math.random(0, 1) ~= 0 then yaw_jitter2_left = ui.get(anti_aim_settings[state_id].yaw_jitter2_left) - math.random(0, ui.get(anti_aim_settings[state_id].yaw_jitter2_randomize)) else yaw_jitter2_left = ui.get(anti_aim_settings[state_id].yaw_jitter2_left) + math.random(0, ui.get(anti_aim_settings[state_id].yaw_jitter2_randomize)) end

        if yaw_jitter2_left > 180 or yaw_jitter2_left < -180 then yaw_jitter2_left = -180 end

        ui.set(reference.yaw_jitter[2], ui.get(anti_aim_settings[state_id].yaw1) ~= 'Off' and yaw_jitter2_left or 0)
    else
        if math.random(0, 1) ~= 0 then yaw_jitter2_right = ui.get(anti_aim_settings[state_id].yaw_jitter2_right) - math.random(0, ui.get(anti_aim_settings[state_id].yaw_jitter2_randomize)) else yaw_jitter2_right = ui.get(anti_aim_settings[state_id].yaw_jitter2_right) + math.random(0, ui.get(anti_aim_settings[state_id].yaw_jitter2_randomize)) end

        if yaw_jitter2_right > 180 or yaw_jitter2_right < -180 then yaw_jitter2_right = -180 end

        ui.set(reference.yaw_jitter[2], ui.get(anti_aim_settings[state_id].yaw1) ~= 'Off' and yaw_jitter2_right or 0)
    end

    if ui.get(anti_aim_settings[state_id].yaw1) ~= 'Off' and ui.get(anti_aim_settings[state_id].yaw_jitter1) == 'Delay' then
        if (ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2])) == true or (ui.get(reference.on_shot_anti_aim[1]) and ui.get(reference.on_shot_anti_aim[2])) == true then
            ui.set(reference.body_yaw[1], (direction == 180 or direction == 90 or direction == -90) and contains(settings.tweaks, 'Off jitter on manual') and anti_aim_on_use == false and 'Opposite' or 'Static')
        else
            ui.set(reference.body_yaw[1], (direction == 180 or direction == 90 or direction == -90) and contains(settings.tweaks, 'Off jitter on manual') and anti_aim_on_use == false and 'Opposite' or 'Jitter')
        end
    else
        ui.set(reference.body_yaw[1], (direction == 180 or direction == 90 or direction == -90) and contains(settings.tweaks, 'Off jitter on manual') and anti_aim_on_use == false and 'Opposite' or ui.get(anti_aim_settings[state_id].body_yaw1))
    end

    if cmd.command_number % ui.get(anti_aim_settings[state_id].yaw_jitter2_delay) + 1 > ui.get(anti_aim_settings[state_id].yaw_jitter2_delay) - 1 then
        delayed_jitter = not delayed_jitter
    end

    if ui.get(anti_aim_settings[state_id].yaw1) ~= 'Off' and ui.get(anti_aim_settings[state_id].yaw_jitter1) == 'Delay' then
        if (ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2])) == true or (ui.get(reference.on_shot_anti_aim[1]) and ui.get(reference.on_shot_anti_aim[2])) == true then
            ui.set(reference.body_yaw[2], delayed_jitter and -90 or 90)
        else
            ui.set(reference.body_yaw[2], -40)
        end
    else
        ui.set(reference.body_yaw[2], ui.get(anti_aim_settings[state_id].body_yaw2))
    end

    ui.set(reference.freestanding_body_yaw, ui.get(anti_aim_settings[state_id].yaw1) ~= 'Off' and ui.get(anti_aim_settings[state_id].yaw_jitter1) == 'Delay' and false or ui.get(anti_aim_settings[state_id].freestanding_body_yaw))
    ui.set(reference.roll, ui.get(anti_aim_settings[state_id].roll))

    if ui.get(anti_aim_settings[state_id].defensive_anti_aimbot) and is_defensive_active and ((ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2])) or (ui.get(reference.on_shot_anti_aim[1]) and ui.get(reference.on_shot_anti_aim[2]))) and not (direction == 180 or direction == 90 or direction == -90) then
        if ui.get(anti_aim_settings[state_id].defensive_pitch) then
            ui.set(reference.pitch[1], ui.get(anti_aim_settings[state_id].defensive_pitch1))

            if ui.get(anti_aim_settings[state_id].defensive_pitch1) == 'Random' then
                ui.set(reference.pitch[1], 'Custom')
                ui.set(reference.pitch[2], math.random(ui.get(anti_aim_settings[state_id].defensive_pitch2), ui.get(anti_aim_settings[state_id].defensive_pitch3)))
            else
                ui.set(reference.pitch[2], ui.get(anti_aim_settings[state_id].defensive_pitch2))
            end
        end

        if ui.get(anti_aim_settings[state_id].defensive_yaw) then
            ui.set(reference.yaw_jitter[1], 'Off')
            ui.set(reference.body_yaw[1], 'Opposite')

            if ui.get(anti_aim_settings[state_id].defensive_yaw1) == '180' then
                ui.set(reference.yaw[1], '180')

                ui.set(reference.yaw[2], ui.get(anti_aim_settings[state_id].defensive_yaw2))
            elseif ui.get(anti_aim_settings[state_id].defensive_yaw1) == 'Spin' then
                ui.set(reference.yaw[1], 'Spin')

                ui.set(reference.yaw[2], ui.get(anti_aim_settings[state_id].defensive_yaw2))
            elseif ui.get(anti_aim_settings[state_id].defensive_yaw1) == '180 Z' then
                ui.set(reference.yaw[1], '180 Z')

                ui.set(reference.yaw[2], ui.get(anti_aim_settings[state_id].defensive_yaw2))
            elseif ui.get(anti_aim_settings[state_id].defensive_yaw1) == 'Sideways' then
                ui.set(reference.yaw[1], '180')

                if cmd.command_number % 4 >= 2 then
                    ui.set(reference.yaw[2], math.random(85, 100))
                else
                    ui.set(reference.yaw[2], math.random(-100, -85))
                end
            elseif ui.get(anti_aim_settings[state_id].defensive_yaw1) == 'Random' then
                ui.set(reference.yaw[1], '180')

                ui.set(reference.yaw[2], math.random(-180, 180))
            end
        end
    end

    if ui.get(settings.safe_head_in_air) and (cmd.in_jump == 1 or bit.band(entity.get_prop(self, 'm_fFlags'), 1) == 0) and entity.get_prop(self, 'm_flDuckAmount') > 0.8 and (entity.get_classname(entity.get_player_weapon(self)) == 'CKnife' or entity.get_classname(entity.get_player_weapon(self)) == 'CWeaponTaser') and anti_aim_on_use == false and not (direction == 180 or direction == 90 or direction == -90) then
        ui.set(reference.pitch[1], 'Down')
        ui.set(reference.yaw[1], '180')
        ui.set(reference.yaw[2], 0)
        ui.set(reference.yaw_jitter[1], 'Off')
        ui.set(reference.body_yaw[1], 'Off')
        ui.set(reference.roll, 0)
    end

    ui.set(reference.edge_yaw, ui.get(settings.edge_yaw) and anti_aim_on_use == false and true or false)

    if ui.get(settings.freestanding) and ((contains(settings.freestanding_conditions, 'Standing') and freestanding_state_id == 1) or (contains(settings.freestanding_conditions, 'Moving') and freestanding_state_id == 2) or (contains(settings.freestanding_conditions, 'Slow motion') and freestanding_state_id == 3) or (contains(settings.freestanding_conditions, 'Crouching') and freestanding_state_id == 4) or (contains(settings.freestanding_conditions, 'In air') and freestanding_state_id == 5)) and anti_aim_on_use == false and not (direction == 180 or direction == 90 or direction == -90) then
        ui.set(reference.freestanding[1], true)
        ui.set(reference.freestanding[2], 'Always on')

        if contains(settings.tweaks, 'Off jitter while freestanding') then
            ui.set(reference.yaw[1], '180')
            ui.set(reference.yaw[2], 0)
            ui.set(reference.yaw_jitter[1], 'Off')
            ui.set(reference.body_yaw[1], 'Opposite')
            ui.set(reference.body_yaw[2], 0)
            ui.set(reference.freestanding_body_yaw, true)
        end
    else
        ui.set(reference.freestanding[1], false)
        ui.set(reference.freestanding[2], 'On hotkey')
    end

    if ui.get(settings.avoid_backstab) and anti_aim_on_use == false and not (direction == 180 or direction == 90 or direction == -90) then
        local players = entity.get_players(true)

        if players ~= nil then
            for i, enemy in pairs(players) do
                for h = 0, 18 do
                    local head_x, head_y, head_z = entity.hitbox_position(players[i], h)
                    local wx, wy = renderer.world_to_screen(head_x, head_y, head_z)
                    local fractions, entindex_hit = client.trace_line(self, eye_x, eye_y, eye_z, head_x, head_y, head_z)

                    if 250 >= vector(entity.get_prop(enemy, 'm_vecOrigin')):dist(vector(entity.get_prop(self, 'm_vecOrigin'))) and entity.is_alive(enemy) and entity.get_player_weapon(enemy) ~= nil and entity.get_classname(entity.get_player_weapon(enemy)) == 'CKnife' and (entindex_hit == players[i] or fractions == 1) and not entity.is_dormant(players[i]) then
                        ui.set(reference.yaw[1], '180')
                        ui.set(reference.yaw[2], -180)
                    end
                end
            end
        end
    end
end)

local function on_paint()
    local me = entity.get_local_player()
    if me == nil then return end
    local rr,gg,bb = 87, 235, 61
    local width, height = client.screen_size()
    local r2, g2, b2, a2 = 55, 55, 55,255
    local highlight_fraction =  (globals.realtime() / 2 % 1.2 * 2) - 1.2
    local output = ""
    local text_to_draw = "I N V I N S I B L E"
    for idx = 1, #text_to_draw do
        local character = text_to_draw:sub(idx, idx)
        local character_fraction = idx / #text_to_draw
        local r1, g1, b1, a1 = 255, 255, 255, 255
        local highlight_delta = (character_fraction - highlight_fraction)
        if highlight_delta >= 0 and highlight_delta <= 1.4 then
            if highlight_delta > 0.7 then
            highlight_delta = 1.4 - highlight_delta
            end
            local r_fraction, g_fraction, b_fraction, a_fraction = r2 - r1, g2 - g1, b2 - b1
            r1 = r1 + r_fraction * highlight_delta / 0.8
            g1 = g1 + g_fraction * highlight_delta / 0.8
            b1 = b1 + b_fraction * highlight_delta / 0.8
        end
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, 255, text_to_draw:sub(idx, idx))
    end
    output = output
    
    local r,g,b,a = 87, 235, 61
    renderer.text(width - (width-965), height - 15, r, g, b, 255, "cb", 0, output .. ' \afa5757FF[RECODE]')
end
client.set_event_callback("paint", on_paint)

client.set_event_callback('paint_ui', function()
    if entity.get_local_player() == nil then cheked_ticks = 0 end

    if ui.is_menu_open() then
        ui_set_visible(reference.fake_peek[1], false);
        ui_set_visible(reference.fake_peek[2], false);
        ui_set_visible(reference.on_shot_anti_aim[1], false);
        ui_set_visible(reference.on_shot_anti_aim[2], false);

        ui_set_visible(reference.leg_movement, false);
        ui_set_visible(reference.slow_motion[1], false);
        ui_set_visible(reference.slow_motion[2], false);
        ui_set_visible(reference.fakelag[1], false);
        ui_set_visible(reference.fakelag[2], false);
        ui_set_visible(reference.fakelag_amount, false);
        ui_set_visible(reference.fakelag_variance, false);
        ui_set_visible(reference.fakelag_limit, false);
        ui.set_visible(reference.pitch[1], false)
        ui.set_visible(reference.pitch[2], false)
        ui.set_visible(reference.yaw_base, false)
        ui.set_visible(reference.yaw[1], false)
        ui.set_visible(reference.yaw[2], false)
        ui.set_visible(reference.yaw_jitter[1], false)
        ui.set_visible(reference.yaw_jitter[2], false)
        ui.set_visible(reference.body_yaw[1], false)
        ui.set_visible(reference.body_yaw[2], false)
        ui.set_visible(reference.freestanding_body_yaw, false)
        ui.set_visible(reference.edge_yaw, false)
        ui.set_visible(reference.freestanding[1], false)
        ui.set_visible(reference.freestanding[2], false)
        ui.set_visible(reference.roll, false)
        ui.set_visible(settings.anti_aim_state, ui.get(current_tab) == 'Anti-Aim')
        ui.set_visible(settings.avoid_backstab, ui.get(current_tab) == 'Keybinds')
        ui.set_visible(settings.safe_head_in_air, ui.get(current_tab) == 'Keybinds')
        ui.set_visible(settings.manual_forward, ui.get(current_tab) == 'Keybinds')
        ui.set_visible(settings.manual_right, ui.get(current_tab) == 'Keybinds')
        ui.set_visible(settings.manual_left, ui.get(current_tab) == 'Keybinds')
        ui.set_visible(settings.edge_yaw, ui.get(current_tab) == 'Keybinds')
        ui.set_visible(settings.freestanding, ui.get(current_tab) == 'Keybinds')
        ui.set_visible(settings.warmup_disabler, ui.get(current_tab) == 'Keybinds')
        ui.set_visible(settings.freestanding_conditions, ui.get(current_tab) == 'Keybinds')
        ui.set_visible(settings.tweaks, ui.get(current_tab) == 'Keybinds')
        ui.set_visible(text1, ui.get(current_tab) == 'Home')
        ui.set_visible(text2, ui.get(current_tab) == 'Home')
        ui.set_visible(text3, ui.get(current_tab) == 'Home')

        for i = 1, #anti_aim_states do
            ui.set_visible(anti_aim_settings[i].override_state, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i]); ui.set(anti_aim_settings[1].override_state, true); ui.set_visible(anti_aim_settings[1].override_state, false)
            ui.set_visible(anti_aim_settings[i].force_defensive, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i]); ui.set_visible(anti_aim_settings[9].force_defensive, false)
            ui.set_visible(anti_aim_settings[i].pitch1,ui.get(current_tab) == 'Anti-Aim' and  ui.get(settings.anti_aim_state) == anti_aim_states[i])
            ui.set_visible(anti_aim_settings[i].pitch2, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].pitch1) == 'Custom')
            ui.set_visible(anti_aim_settings[i].yaw_base, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i])
            ui.set_visible(anti_aim_settings[i].yaw1, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i])
            ui.set_visible(anti_aim_settings[i].yaw2_left, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Delay')
            ui.set_visible(anti_aim_settings[i].yaw2_right, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Delay')
            ui.set_visible(anti_aim_settings[i].yaw2_randomize, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Delay')
            ui.set_visible(anti_aim_settings[i].yaw_jitter1, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off')
            ui.set_visible(anti_aim_settings[i].yaw_jitter2_left, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Off')
            ui.set_visible(anti_aim_settings[i].yaw_jitter2_right, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Off')
            ui.set_visible(anti_aim_settings[i].yaw_jitter2_randomize, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Off')
            ui.set_visible(anti_aim_settings[i].yaw_jitter2_delay, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) == 'Delay')
            ui.set_visible(anti_aim_settings[i].body_yaw1, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Delay')
            ui.set_visible(anti_aim_settings[i].body_yaw2, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and (ui.get(anti_aim_settings[i].body_yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].body_yaw1) ~= 'Opposite') and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Delay')
            ui.set_visible(anti_aim_settings[i].freestanding_body_yaw, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].body_yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Delay')
            ui.set_visible(anti_aim_settings[i].roll, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i])
            ui.set_visible(anti_aim_settings[i].defensive_anti_aimbot, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i]); ui.set_visible(anti_aim_settings[9].defensive_anti_aimbot, false)
            ui.set_visible(anti_aim_settings[i].defensive_pitch, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].defensive_anti_aimbot)); ui.set_visible(anti_aim_settings[9].defensive_pitch, false)
            ui.set_visible(anti_aim_settings[i].defensive_pitch1, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].defensive_anti_aimbot) and ui.get(anti_aim_settings[i].defensive_pitch)); ui.set_visible(anti_aim_settings[9].defensive_pitch1, false)
            ui.set_visible(anti_aim_settings[i].defensive_pitch2, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].defensive_anti_aimbot) and ui.get(anti_aim_settings[i].defensive_pitch) and (ui.get(anti_aim_settings[i].defensive_pitch1) == 'Random' or ui.get(anti_aim_settings[i].defensive_pitch1) == 'Custom')); ui.set_visible(anti_aim_settings[9].defensive_pitch2, false)
            ui.set_visible(anti_aim_settings[i].defensive_pitch3, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].defensive_anti_aimbot) and ui.get(anti_aim_settings[i].defensive_pitch) and ui.get(anti_aim_settings[i].defensive_pitch1) == 'Random'); ui.set_visible(anti_aim_settings[9].defensive_pitch3, false)
            ui.set_visible(anti_aim_settings[i].defensive_yaw, ui.get(current_tab) == 'Anti-Aim' and  ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].defensive_anti_aimbot)); ui.set_visible(anti_aim_settings[9].defensive_yaw, false)
            ui.set_visible(anti_aim_settings[i].defensive_yaw1, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].defensive_anti_aimbot) and ui.get(anti_aim_settings[i].defensive_yaw)); ui.set_visible(anti_aim_settings[9].defensive_yaw1, false)
            ui.set_visible(anti_aim_settings[i].defensive_yaw2, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].defensive_anti_aimbot) and ui.get(anti_aim_settings[i].defensive_yaw) and (ui.get(anti_aim_settings[i].defensive_yaw1) == '180' or ui.get(anti_aim_settings[i].defensive_yaw1) == 'Spin' or ui.get(anti_aim_settings[i].defensive_yaw1) == '180 Z')); ui.set_visible(anti_aim_settings[9].defensive_yaw2, false)
        end
    end
end)

import_btn = ui.new_button("AA", "Anti-aimbot angles", "Import settings", function() import(clipboard.get()) end)
export_btn = ui.new_button("AA", "Anti-aimbot angles", "Export settings", function() 
    local code = {{}}

    for i, integers in pairs(data.integers) do
        table.insert(code[1], ui.get(integers))
    end

    clipboard.set(base64.encode(json.stringify(code)))
    client.color_log(124, 252, 0, "I N V I N S I B L E ~\0")
	client.color_log(200, 200, 200, " config successfully exported!")
end)
default_btn = ui.new_button("AA", "Anti-aimbot angles", "Default Config", function() 
    import('W1siSW4gYWlyICYgY3JvdWNoaW5nIix0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLHRydWUsdHJ1ZSx0cnVlLHRydWUsZmFsc2UsZmFsc2UsIk9mZiIsIk1pbmltYWwiLCJNaW5pbWFsIiwiTWluaW1hbCIsIk1pbmltYWwiLCJNaW5pbWFsIiwiTWluaW1hbCIsIk1pbmltYWwiLCJNaW5pbWFsIiwiT2ZmIiwwLDAsMCwwLDAsMCwwLDAsMCwwLCJMb2NhbCB2aWV3IiwiQXQgdGFyZ2V0cyIsIkF0IHRhcmdldHMiLCJBdCB0YXJnZXRzIiwiQXQgdGFyZ2V0cyIsIkF0IHRhcmdldHMiLCJBdCB0YXJnZXRzIiwiQXQgdGFyZ2V0cyIsIkF0IHRhcmdldHMiLCJMb2NhbCB2aWV3IiwiT2ZmIiwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwiT2ZmIiwwLDgsLTMzLC0xNCwwLC0xNSwwLDAsNywwLDAsOCwtMzMsLTE0LDAsLTE1LDAsMCw3LDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwiT2ZmIiwiQ2VudGVyIiwiT2Zmc2V0IiwiT2Zmc2V0IiwiRGVsYXkiLCJPZmZzZXQiLCJEZWxheSIsIkRlbGF5IiwiQ2VudGVyIiwiT2ZmIiwwLDU0LDY4LDQwLC0yOSw1MSwtMjUsLTIzLDUwLDAsMCw1NCw2OCw0MCw0Myw1MSw0MCw0MSw1MCwwLDAsMCw1LDQsMCwzLDAsMCwwLDAsMiwyLDIsMiw0LDIsNiw0LDIsMiwiT2ZmIiwiSml0dGVyIiwiSml0dGVyIiwiSml0dGVyIiwiT2ZmIiwiSml0dGVyIiwiT2ZmIiwiT2ZmIiwiSml0dGVyIiwiT3Bwb3NpdGUiLDAsLTQwLC00MCwtNDAsMCwtNDAsMCwwLC00MCwwLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLHRydWUsMCwwLDAsMCwwLDAsMCwwLDAsMCxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLHRydWUsdHJ1ZSx0cnVlLHRydWUsZmFsc2UsZmFsc2UsIk9mZiIsIk9mZiIsIk9mZiIsIk9mZiIsIkRlZmF1bHQiLCJEZWZhdWx0IiwiVXAiLCJEZWZhdWx0IiwiT2ZmIiwiT2ZmIiwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSxmYWxzZSxmYWxzZSwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwiU3BpbiIsIlNwaW4iLCJTcGluIiwiU3BpbiIsIjE4MCIsIjE4MCIsMCwwLDAsMCw1MCw1MCw0Myw0MywwLDAsdHJ1ZSx0cnVlLFsiU3RhbmRpbmciLCJNb3ZpbmciLCJDcm91Y2hpbmciXSxbIk9mZiBqaXR0ZXIgd2hpbGUgZnJlZXN0YW5kaW5nIiwiT2ZmIGppdHRlciBvbiBtYW51YWwiXSx0cnVlLHRydWUsdHJ1ZSwzNSx0cnVlLDkwLGZhbHNlLGZhbHNlLHRydWUsdHJ1ZV1d')
end)

client.set_event_callback('paint_ui', function()
    if entity.get_local_player() == nil then cheked_ticks = 0 end

    ui.set_visible(export_btn, ui.get(current_tab) == 'Home')
    ui.set_visible(import_btn, ui.get(current_tab) == 'Home')
    ui.set_visible(default_btn, ui.get(current_tab) == 'Home')
end)

ui.set_callback(console_filter, function()
    cvar.con_filter_text:set_string("cool text")
    cvar.con_filter_enable:set_int(1)
end)

--killsay
local killsay_pharases = {
    {"♛ ｇａｍｅｓｅｎｓｅ ♛"},
    {"1."},
    {"𝙨𝙡𝙚𝙚𝙥"},
    {"𝙞𝙦𝙡𝙚𝙨𝙨? 𝙄 𝙪𝙨𝙚 𝙄𝙣𝙫𝙞𝙣𝙨𝙞𝙗𝙡𝙚 𝙡𝙪𝙖"},
    {"𝘽𝙚𝙨𝙩 𝙧𝙚𝙨𝙤𝙡𝙫𝙚𝙧 𝙗𝙮 𝙞𝙣𝙫𝙞𝙣𝙨𝙞𝙗𝙡𝙚 𝙡𝙪𝙖"},
    {"「✦𝙄𝙣𝙫𝙞𝙣𝙨𝙞𝙗𝙡𝙚✦」"},
    {"𝙂𝙚𝙩 𝙜𝙤𝙤𝙙. 𝙂𝙚𝙩 𝙄𝙣𝙫𝙞𝙣𝙨𝙞𝙗𝙡𝙚."},
}
    
local death_say = {
    {'ну сука', 'не повезло'}
}

    
client.set_event_callback('player_death', function(e)
    delayed_msg = function(delay, msg)
        return client.delay_call(delay, function() client.exec('say ' .. msg) end)
    end

    local delay = 2.3
    local me = entity_get_local_player()
    local victim = client.userid_to_entindex(e.userid)
    local attacker = client.userid_to_entindex(e.attacker)

    local killsay_delay = 0
    local deathsay_delay = 0

    if entity_get_local_player() == nil then return end

    gamerulesproxy = entity.get_all("CCSGameRulesProxy")[1]
    warmup = entity.get_prop(gamerulesproxy,"m_bWarmupPeriod")
    if warmup == 1 then return end

    if not ui.get(trashtalk) then return end

    if (victim ~= attacker and attacker == me) then
        local phase_block = killsay_pharases[math.random(1, #killsay_pharases)]

            for i=1, #phase_block do
                local phase = phase_block[i]
                local interphrase_delay = #phase_block[i]/24*delay
                killsay_delay = killsay_delay + interphrase_delay

                delayed_msg(killsay_delay, phase)
            end
        end
            
    if (victim == me and attacker ~= me) then
        local phase_block = death_say[math.random(1, #death_say)]

        for i=1, #phase_block do
            local phase = phase_block[i]
            local interphrase_delay = #phase_block[i]/20*delay
            deathsay_delay = deathsay_delay + interphrase_delay

            delayed_msg(deathsay_delay, phase)
        end
    end
end)
    
--

--
local clantag = {
    steam = steamworks.ISteamFriends,
    prev_ct = "",
    orig_ct = "",
    enb = false,
}

local function get_original_clantag()
    local clan_id = cvar.cl_clanid.get_int()
    if clan_id == 0 then return "\0" end

    local clan_count = clantag.steam.GetClanCount()
    for i = 0, clan_count do 
        local group_id = clantag.steam.GetClanByIndex(i)
        if group_id == clan_id then
            return clantag.steam.GetClanTag(group_id)
        end
    end
end

local clantag_anim = function(text, indices)

    time_to_ticks = function(t)
        return math.floor(0.5 + (t / globals.tickinterval()))
    end

    local text_anim = "               " .. text ..                       "" 
    local tickinterval = globals.tickinterval()
    local tickcount = globals.tickcount() + time_to_ticks(client.latency())
    local i = tickcount / time_to_ticks(0.3)
    i = math.floor(i % #indices)
    i = indices[i+1]+1
    return string.sub(text_anim, i, i+15)
end

local function clantag_set()
    local lua_name = "Invinsible "
    if ui.get(clantagchanger) then
        if ui.get(ui.reference("Misc", "Miscellaneous", "Clan tag spammer")) then ui.set(ui.reference("Misc", "Miscellaneous", "Clan tag spammer"), false) end

		local clan_tag = clantag_anim(lua_name, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25})

        if entity.get_prop(entity.get_game_rules(), "m_gamePhase") == 5 then
            clan_tag = clantag_anim('Invinsible ', {13})
            client.set_clan_tag(clan_tag)
        elseif entity.get_prop(entity.get_game_rules(), "m_timeUntilNextPhaseStarts") ~= 0 then
            clan_tag = clantag_anim('Invinsible ', {13})
            client.set_clan_tag(clan_tag)
        elseif clan_tag ~= clantag.prev_ct  then
            client.set_clan_tag(clan_tag)
        end

        clantag.prev_ct = clan_tag
        clantag.enb = true
    elseif clantag.enb == true then
        client.set_clan_tag(get_original_clantag())
        clantag.enb = false
    end
end

clantag.paint = function()
    if entity.get_local_player() ~= nil then
        if globals.tickcount() % 2 == 0 then
            clantag_set()
        end
    end
end

clantag.run_command = function(e)
    if entity.get_local_player() ~= nil then 
        if e.chokedcommands == 0 then
            clantag_set()
        end
    end
end

clantag.player_connect_full = function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then 
        clantag.orig_ct = get_original_clantag()
    end
end

clantag.shutdown = function()
    client.set_clan_tag(get_original_clantag())
end

client.set_event_callback("paint", clantag.paint)
client.set_event_callback("run_command", clantag.run_command)
client.set_event_callback("player_connect_full", clantag.player_connect_full)
client.set_event_callback("shutdown", clantag.shutdown)
--


--[[client.set_event_callback('console_input', function(text)
    if string.find(text, '//export') then
        local code = {{}}

        for i, integers in pairs(data.integers) do
            table.insert(code[1], ui.get(integers))
        end

        clipboard.set(base64.encode(json.stringify(code)))
    elseif string.find(text, '//import') then
        import(clipboard.get())
    elseif string.find(text, '//default') then
        http.get('https://pastebin.com/raw/xJy4ipac', function(success, response)
            if not success or response.status ~= 200 then return end

            import(response.body)
        end)
    end
end)]]

client.set_event_callback('net_update_end', function()
    if entity.get_local_player() ~= nil then
        is_defensive_active = is_defensive(entity.get_local_player())
    end
end)

--fastladder
client.set_event_callback('setup_command', function(cmd)
    if ui.get(fastladder) then
        local pitch, yaw = client.camera_angles()
        if entity.get_prop(entity.get_local_player(), "m_MoveType") == 9 then
            cmd.yaw = math.floor(cmd.yaw+0.5)
            cmd.roll = 0
            
            if cmd.forwardmove > 0 then
                if pitch < 45 then

                    cmd.pitch = 89
                    cmd.in_moveright = 1
                    cmd.in_moveleft = 0
                    cmd.in_forward = 0
                    cmd.in_back = 1

                    if cmd.sidemove == 0 then
                        cmd.yaw = cmd.yaw + 90
                    end

                    if cmd.sidemove < 0 then
                        cmd.yaw = cmd.yaw + 150
                    end

                    if cmd.sidemove > 0 then
                        cmd.yaw = cmd.yaw + 30
                    end
                end 
            end

            if cmd.forwardmove < 0 then
                cmd.pitch = 89
                cmd.in_moveleft = 1
                cmd.in_moveright = 0
                cmd.in_forward = 1
                cmd.in_back = 0
                if cmd.sidemove == 0 then
                    cmd.yaw = cmd.yaw + 90
                end
                if cmd.sidemove > 0 then
                    cmd.yaw = cmd.yaw + 150
                end
                if cmd.sidemove < 0 then
                    cmd.yaw = cmd.yaw + 30
                end
            end

        end
    end
end)

--legbreaker
local ref = {
    leg_movement = ui.reference('AA', 'Other', 'Leg movement')
}

local ab = {}

ab.pre_render = function()
    if ui.get(anim_breakerx) then
        local local_player = entity.get_local_player()
        if not entity.is_alive(local_player) then return end

        entity.set_prop(local_player, "m_flPoseParameter", client.random_float(0.8/10, 1), 0)
        ui.set(ref.leg_movement, client.random_int(1, 2) == 1 and "Off" or "Always slide")
    end
end

ab.setup_command = function(e)
    if not ui.get(anim_breakerx) then return end

    local local_player = entity.get_local_player()
    if not entity.is_alive(local_player) then return end

    ui.set(ref.leg_movement, 'Always slide')
end

local ui_callback = function(c)
    local enabled, addr = ui.get(c), ''

    if not enabled then
        addr = 'un'
    end
    
    local _func = client[addr .. 'set_event_callback']

    _func('pre_render', ab.pre_render)
    _func('setup_command', ab.setup_command)
end

ui.set_callback(master_switch, ui_callback)
ui_callback(master_switch)

local is_on_ground = false

--- @region: process main work
--
client.set_event_callback("setup_command", function()
    if entity.get_local_player() == nil then return end

    gamerulesproxy = entity.get_all("CCSGameRulesProxy")[1]
    warmup = entity.get_prop(gamerulesproxy,"m_bWarmupPeriod")
    --print(warmup)
  
    if ui.get(settings.warmup_disabler) and warmup == 1 then
        ui.set(reference.body_yaw[1], 'Off')
        ui.set(reference.yaw[2], math.random(-180, 180))
        ui.set(reference.yaw_jitter[1], 'Random')
        ui.set(reference.pitch[1], 'Off')
    end
end)
--

client.set_event_callback("setup_command", function(cmd)
    is_on_ground = cmd.in_jump == 0

    if ui.get(anim_breakerx) then
        ui.set(ref.leg_movement, cmd.command_number % 3 == 0 and "Off" or "Always slide")
    end
end)

client.set_event_callback("pre_render", function()
    local self = entity.get_local_player()
    if not self or not entity.is_alive(self) then
        return
    end

    local self_index = c_entity.new(self)
    local self_anim_state = self_index:get_anim_state()

    if not self_anim_state then
        return
    end

    if ui.get(anim_breakerx) then
        entity.set_prop(self, "m_flPoseParameter", E_POSE_PARAMETERS.STAND, globals.tickcount() % 4 > 1 and 5 / 10 or 1)
    
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then
            return
        end

        local x_velocity = entity.get_prop(self, "m_vecVelocity[0]")
        if math.abs(x_velocity) >= 3 then
            self_anim_overlay.weight = 100 / 100
        end
    end
end)
--- @endregion

--scope
local second_zoom do
    second_zoom = { }

    local old_value

    local function callback(item)
        local fn = client_set_event_callback
        local value = ui_get(item)

        if not value then
            second_zoom.shutdown()
            fn = client_unset_event_callback
        end

        ui_set_visible(scope_fov, value)

        fn("shutdown", second_zoom.shutdown)
        fn("pre_render", second_zoom.pre_render)
    end

    local function reset()
        if old_value == nil then
            return
        end

        ui_set(override_zoom_fov, old_value)
        old_value = nil
    end

    local function update()
        if old_value == nil then
            old_value = ui_get(override_zoom_fov)
        end

        ui_set(override_zoom_fov, ui_get(scope_fov))
    end

    
    client.set_event_callback('paint', function()

    if ui.get(scope_fov) == 0 then
        return
    end

    if ui.get(scope_fov) > 0 then
            local me = entity_get_local_player()

            if me == nil then
                return
            end

            local wpn = entity_get_player_weapon(me)

            if wpn == nil then
                return
            end

            local zoom_level = entity_get_prop(wpn, "m_zoomLevel")

            if zoom_level ~= 2 then
                reset()
                return
            end

            update()
        end
    end)
end
--

client.set_event_callback('paint', function()
    cvar.r_aspectratio:set_float(ui.get(aspectratio)/100)
end)
--

local queue = {}

local function aim_firec(c)
	queue[globals.tickcount()] = {c.x, c.y, c.z, globals.curtime() + 2}
end

local function paintc(c)
	if ui.get(hitmarker) then
        for tick, data in pairs(queue) do
            if globals.curtime() <= data[4] then
                local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
                if x1 ~= nil and y1 ~= nil then
                    renderer.line(x1 - 6, y1, x1 + 6, y1, 34, 214, 132, 255)
                    renderer.line(x1, y1 - 6, x1, y1 + 6, 108, 182, 203, 255)
                end
            end
        end
    end
end

client.set_event_callback("aim_fire", aim_firec)
client.set_event_callback("paint", paintc)
client.set_event_callback("round_prestart", function() queue = {} end)
--

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
local weapon_to_verb = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' }

client.set_event_callback('aim_hit', function(e)
	if not ui.get(master_switch) or e.id == nil then
		return
	end

	local group = hitgroup_names[e.hitgroup + 1] or "?"

	client.color_log(124, 252, 0, "[Invinsible]\0")
	client.color_log(200, 200, 200, " Hit\0")
	client.color_log(124, 252, 0, string.format(" %s\0", entity.get_player_name(e.target)))
	client.color_log(200, 200, 200, " in the\0")
	client.color_log(124, 252, 0, string.format(" %s\0", group))
	client.color_log(200, 200, 200, " for\0")
	client.color_log(124, 252, 0, string.format(" %s\0", e.damage))
	client.color_log(200, 200, 200, " damage\0")
	client.color_log(200, 200, 200, " (\0")
	client.color_log(124, 252, 0, string.format("%s\0", entity.get_prop(e.target, "m_iHealth")))
	client.color_log(200, 200, 200, " health remaining)")
end)

client.set_event_callback("aim_miss", function(e)
	if not ui.get(master_switch) then
		return
	end

	local group = hitgroup_names[e.hitgroup + 1] or "?"

	client.color_log(255, 0, 0, "[Invinsible]\0")
	client.color_log(200, 200, 200, " Missed shot in\0")
	client.color_log(255, 0, 0, string.format(" %s\'s\0", entity.get_player_name(e.target)))
	client.color_log(255, 0, 0, string.format(" %s\0", group))
	client.color_log(200, 200, 200, " due to\0")
	client.color_log(255, 0, 0, string.format(" %s", e.reason))
end)

client.set_event_callback('player_hurt', function(e)
	if not ui.get(master_switch) then
		return
	end
	
	local attacker_id = client.userid_to_entindex(e.attacker)

	if attacker_id == nil or attacker_id ~= entity.get_local_player() then
        return
    end

	if weapon_to_verb[e.weapon] ~= nil then
        local target_id = client.userid_to_entindex(e.userid)
		local target_name = entity.get_player_name(target_id)

		--print(string.format("%s %s for %i damage (%i remaining)", weapon_to_verb[e.weapon], string.lower(target_name), e.dmg_health, e.health))
		client.color_log(124, 252, 0, "[Invinsible]\0")
		client.color_log(200, 200, 200, string.format(" %s\0", weapon_to_verb[e.weapon]))
		client.color_log(124, 252, 0, string.format(" %s\0", target_name))
		client.color_log(200, 200, 200, " for\0")
		client.color_log(124, 252, 0, string.format(" %s\0", e.dmg_health))
		client.color_log(200, 200, 200, " damage\0")
		client.color_log(200, 200, 200, " (\0")
		client.color_log(124, 252, 0, string.format("%s\0", e.health))
		client.color_log(200, 200, 200, " health remaining)")
	end
end)

client.set_event_callback('shutdown', function()
    ui.set_visible(reference.pitch[1], true)
    ui.set_visible(reference.yaw_base, true)
    ui.set_visible(reference.yaw[1], true)
    ui.set_visible(reference.body_yaw[1], true)
    ui.set_visible(reference.edge_yaw, true)
    ui.set_visible(reference.freestanding[1], true)
    ui.set_visible(reference.freestanding[2], true)
    ui.set_visible(reference.roll, true)

    cvar.r_aspectratio:set_float(0)

    ui.set(override_zoom_fov, 0)
    ui.set(reference.pitch[1], 'Off')
    ui.set(reference.pitch[2], 0)
    ui.set(reference.yaw_base, 'Local view')
    ui.set(reference.yaw[1], 'Off')
    ui.set(reference.yaw[2], 0)
    ui.set(reference.yaw_jitter[1], 'Off')
    ui.set(reference.yaw_jitter[2], 0)
    ui.set(reference.body_yaw[1], 'Off')
    ui.set(reference.body_yaw[2], 0)
    ui.set(reference.freestanding_body_yaw, false)
    ui.set(reference.edge_yaw, false)
    ui.set(reference.freestanding[1], false)
    ui.set(reference.freestanding[2], 'On hotkey')
    ui.set(reference.roll, 0)
end)

local IsNewClientAvailable = panorama.loadstring([[
	var oldClientStatus = NewsAPI.IsNewClientAvailable;

	return {
		disable: function(){
			NewsAPI.IsNewClientAvailable = function(){ return false };
		},
		restore: function(){
            NewsAPI.IsNewClientAvailable = oldClientStatus;
		}
	}
]])()

IsNewClientAvailable.disable()

client.set_event_callback("shutdown", function()
	IsNewClientAvailable.restore()
end)

--- @region: prepare helpers
table.contains = function(source, target)
    local source_element = ui.get(source)
    for id, name in pairs(source_element) do
        if name == target then
            return true
        end
    end

    return false
end

local c_entity = require("gamesense/entity")
local E_POSE_PARAMETERS = {
    STRAFE_YAW = 0,
    STAND = 1,
    LEAN_YAW = 2,
    SPEED = 3,
    LADDER_YAW = 4,
    LADDER_SPEED = 5,
    JUMP_FALL = 6,
    MOVE_YAW = 7,
    MOVE_BLEND_CROUCH = 8,
    MOVE_BLEND_WALK = 9,
    MOVE_BLEND_RUN = 10,
    BODY_YAW = 11,
    BODY_PITCH = 12,
    AIM_BLEND_STAND_IDLE = 13,
    AIM_BLEND_STAND_WALK = 14,
    AIM_BLEND_STAND_RUN = 14,
    AIM_BLEND_CROUCH_IDLE = 16,
    AIM_BLEND_CROUCH_WALK = 17,
    DEATH_YAW = 18
}

local is_on_ground = false
--- @endregion

--- @region: prepare menu elements

--- @endregion

--- @region: process main work
client.set_event_callback("setup_command", function(cmd)
    is_on_ground = cmd.in_jump == 0
end)

function jitterValue()
    local currentTime = globals.tickcount() / 10
    local jitterFrequency = 7  

    local jitterFactor = 0.5 + 0.5 * math.sin(currentTime * jitterFrequency)

    return jitterFactor * 100
end

-- Example usage
client.set_event_callback("pre_render", function()
    local self = entity.get_local_player()
    if not self or not entity.is_alive(self) then
        return
    end

    local self_index = c_entity.new(self)
    local self_anim_state = self_index:get_anim_state()

    if not self_anim_state then
        return
    end

    if table.contains(m_elements, "kangaroo") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 3)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 7)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 6)
    end

    if table.contains(m_elements, "airbreak") then
        entity.set_prop(self, "m_flPoseParameter", globals.tickcount() % 4 > 1 and math.random(0, 10) / 10, E_POSE_PARAMETERS.JUMP_FALL)
    end
    
    if table.contains(m_elements, "earthquake") then
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then
            return
        end

        if globals.tickcount() % 10 > 1 then
            self_anim_overlay.weight = jitterValue() / 100
        end
    end
end)
--- @endregion

function lerp(a, b, t)
    if not b or not a or not t then return end
    return a + (b - a) * t
end
function ui.multiReference(tab, groupbox, name)
    local ref1, ref2, ref3 = ui.reference(tab, groupbox, name)
    return { ref1, ref2, ref3 }
end
rgba_to_hex = function(r, g, b, a)
    return bit.tohex((math.floor(r + 0.5) * 16777216) + (math.floor(g + 0.5) * 65536) + (math.floor(b + 0.5) * 256) + (math.floor(a + 0.5)))
end
func = {
    table_contains = function(tbl, value)
        for i = 1, #tbl do
            if tbl[i] == value then
                return true
            end
        end
        return false
    end,
    includes = function(tbl, value)
        for i = 1, #tbl do
            if tbl[i] == value then
                return true
            end
        end
        return false
    end,
}
animate_text = function(time, string, r, g, b, a, r2, g2, b2, a2)
    local m, n, o, p = r2, g2, b2, a2
    local t_out = {}
    local l = string:len() - 1
    local r_add = (m - r)
    local g_add = (n - g)
    local b_add = (o - b)
    local a_add = (p - a)

    for i = 1, #string do
        local iter = (i - 1) / (#string - 1) + time
        t_out[#t_out + 1] = "\a" .. rgba_to_hex(r + r_add * math.abs(math.cos(iter)), g + g_add * math.abs(math.cos(iter)), b + b_add * math.abs(math.cos(iter)), a + a_add * math.abs(math.cos(iter)))
        t_out[#t_out + 1] = string:sub(i, i)
    end

    return table.concat(t_out)
end

function animate_color(time, r, g, b, a, r2, g2, b2, a2)
    local finished = false
    local newR, newG, newB, newA = r, g, b, a
    if newR == r2 and newG == g2 and newB == b2 and newA == a2 then
        newR = lerp(r, r2, time)
        newG = lerp(g, g2, time)
        newB = lerp(b, b2, time)
        newA = lerp(a, a2, time)
    else
        newR = lerp(r2, r, time)
        newG = lerp(g2, g, time)
        newB = lerp(b2, b, time)
        newA = lerp(a2, a, time)
    end
    return newR, newG, newB, newA
end

local function traverse_table(tbl, prefix)
    prefix = prefix or ""
    local stack = {{tbl, prefix}}

    while #stack > 0 do
        local current = table.remove(stack)
        local current_tbl = current[1]
        local current_prefix = current[2]

        for key, value in pairs(current_tbl) do
            local full_key = current_prefix .. key
            if type(value) == "table" then
                table.insert(stack, {value, full_key .. "."})
            else
                -- Применяем ui.set_visible к каждому элементу
                ui.set_visible(value, false) -- Здесь можно изменить параметр видимости на нужное значение
            end
        end
    end
end

local function traverse_table_on(tbl, prefix)
    prefix = prefix or ""
    local stack = {{tbl, prefix}}

    while #stack > 0 do
        local current = table.remove(stack)
        local current_tbl = current[1]
        local current_prefix = current[2]

        for key, value in pairs(current_tbl) do
            local full_key = current_prefix .. key
            if type(value) == "table" then
                table.insert(stack, {value, full_key .. "."})
            else
                -- Применяем ui.set_visible к каждому элементу
                ui.set_visible(value, true) -- Здесь можно изменить параметр видимости на нужное значение
            end
        end
    end
end

---@diagnostic disable: undefined-global
local ffi = require 'ffi'
local crr_t = ffi.typeof('void*(__thiscall*)(void*)')
local cr_t = ffi.typeof('void*(__thiscall*)(void*)')
local gm_t = ffi.typeof('const void*(__thiscall*)(void*)')
local gsa_t = ffi.typeof('int(__fastcall*)(void*, void*, int)')
ffi.cdef[[
    struct animation_layer_t
    {
	    char pad20[24];
	    uint32_t m_nSequence;
	    float m_flPrevCycle;
	    float m_flWeight;
	    float m_flWeightDeltaRate;
	    float m_flPlaybackRate;
	    float m_flCycle;
	    uintptr_t m_pOwner;
	    char pad_0038[ 4 ];
    };
    struct c_animstate { 
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    };
]]

local classptr = ffi.typeof('void***')
local rawientitylist = client.create_interface('client_panorama.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)

local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
local get_client_networkable = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][0]) or error('get_client_networkable_t is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity is nil', 2)

local rawivmodelinfo = client.create_interface('engine.dll', 'VModelInfoClient004')
local ivmodelinfo = ffi.cast(classptr, rawivmodelinfo) or error('rawivmodelinfo is nil', 2)
local get_studio_model = ffi.cast('void*(__thiscall*)(void*, const void*)', ivmodelinfo[0][32])

local seq_activity_sig = client.find_signature('client_panorama.dll','\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83')

local function get_model(b)if b then b=ffi.cast(classptr,b)local c=ffi.cast(crr_t,b[0][0])local d=c(b)or error('error getting client unknown',2)if d then d=ffi.cast(classptr,d)local e=ffi.cast(cr_t,d[0][5])(d)or error('error getting client renderable',2)if e then e=ffi.cast(classptr,e)return ffi.cast(gm_t,e[0][8])(e)or error('error getting model_t',2)end end end end
local function get_sequence_activity(b,c,d)b=ffi.cast(classptr,b)local e=get_studio_model(ivmodelinfo,get_model(c))if e==nil then return-1 end;local f=ffi.cast(gsa_t, seq_activity_sig)return f(b,e,d)end
local function get_anim_layer(b,c)c=c or 1;b=ffi.cast(classptr,b)return ffi.cast('struct animation_layer_t**',ffi.cast('char*',b)+0x2990)[0][c]end

local Tools = {}

Tools.Clamp = function(n, mn, mx)
    if n > mx then
        return mx;
    elseif n < mn then
        return mn;
    else
        return n;
    end
end

Tools.YawTo360 = function(yawbruto)
    if yawbruto < 0 then
        return 360 + yawbruto;
    end

    return yawbruto;
end

Tools.YawTo180 = function(yawbruto)
    if yawbruto > 180 then
        return yawbruto - 360;
    end

    return yawbruto;
end

Tools.YawNormalizer = function(yawbruto)
    if yawbruto > 360 then
        return yawbruto - 360;
    elseif yawbruto < 0 then
        return 360 + yawbruto;
    end

    return yawbruto;
end

local MenuV = {};

MenuV["Anti-Aim Correction"] =  ui.reference("Rage", "Other", "Anti-Aim Correction");
MenuV["ResetAll"] =             ui.reference("Players", "Players", "Reset All");
MenuV["ForceBodyYaw"] =         ui.reference("Players", "Adjustments", "Force Body Yaw");
MenuV["CorrectionActive"] =     ui.reference("Players", "Adjustments", "Correction Active");

local MenuC = {};

MenuC["Enable"] =               ui.new_checkbox("Rage", "Other", "\aFF0000FF ⚠ | Invinsible custom Resolver");
MenuC["DebugLogs"] =            ui.new_checkbox("Rage", "Other", "\aFF0000FF Resolver Debug Logs");
MenuC["Flag"] =                 ui.new_checkbox("Rage", "Other", "\aFF0000FF Resolver Flags");

function Enable_Update()
    if ui.get(MenuC["Enable"]) then
        ui.set_visible(MenuC["DebugLogs"], true);
        ui.set_visible(MenuC["Flag"], true);
        --ui.set_visible(MenuV["Anti-Aim Correction"], false);
        ui.set_visible(MenuV["ForceBodyYaw"], false);
        ui.set_visible(MenuV["CorrectionActive"], false);
        --ui.set(MenuV["Anti-Aim Correction"], false);
    else
        ui.set_visible(MenuC["DebugLogs"], false);
        ui.set_visible(MenuC["Flag"], false);
        --ui.set_visible(MenuV["Anti-Aim Correction"], true);
        ui.set_visible(MenuV["ForceBodyYaw"], true);
        ui.set_visible(MenuV["CorrectionActive"], true);
        --ui.set(MenuV["Anti-Aim Correction"], true);
        ui.set(MenuV["ResetAll"], true);
    end
end
Enable_Update();

ui.set_callback(MenuC["Enable"], function()
    Enable_Update();
end)

local Animlayers =  {};
local AnimParts =   {};
local AnimList =    {"m_flPrevCycle", "m_flWeight", "m_flWeightDeltaRate", "m_flPlaybackRate", "m_flCycle"};
local SideCount =   {};
local Side =        {};
local Desync =      {};
local TempPitch =   {};

for i = 1, 64, 1 do
    SideCount[i] = 0;
    Side[i] = "Left";
    Desync[i] = 25;
    TempPitch[i] = 0;
end

function Resolver()
    if not ui.get(MenuC["Enable"]) then
        return;
    end

    --local Lp =          entity.get_local_player();

    local Players =     entity.get_players(true);

    for i, Player in pairs(Players) do
        local PlayerP = get_client_entity(ientitylist, Player);

        plist.set(Player, "Force Body Yaw", true);

        for u = 1, 13, 1 do
            Animlayers[u] = {};
            Animlayers[u]["Main"] =                 get_anim_layer(PlayerP, u);

            Animlayers[u]["m_flPrevCycle"] =        Animlayers[u]["Main"].m_flPrevCycle;
            Animlayers[u]["m_flWeight"] =           Animlayers[u]["Main"].m_flWeight;
            Animlayers[u]["m_flWeightDeltaRate"] =  Animlayers[u]["Main"].m_flWeightDeltaRate;
            Animlayers[u]["m_flPlaybackRate"] =     Animlayers[u]["Main"].m_flPlaybackRate;
            Animlayers[u]["m_flCycle"] =            Animlayers[u]["Main"].m_flCycle;

            AnimParts[u] = {};
            for y, val in pairs(AnimList) do
                AnimParts[u][val] = {};
                for i = 1, 13, 1 do
                    AnimParts[u][val][i] = math.floor(Animlayers[u][val]*(10^i)) - (math.floor(Animlayers[u][val]*(10^(i-1)))*10);
                end
            end
        end

        local RSideR = AnimParts[6]["m_flPlaybackRate"][4]+AnimParts[6]["m_flPlaybackRate"][5]+AnimParts[6]["m_flPlaybackRate"][6]+AnimParts[6]["m_flPlaybackRate"][7];
        local RSideS = AnimParts[6]["m_flPlaybackRate"][6]+AnimParts[6]["m_flPlaybackRate"][7]+AnimParts[6]["m_flPlaybackRate"][8]+AnimParts[6]["m_flPlaybackRate"][9];

        local Tmp;

        if AnimParts[6]["m_flPlaybackRate"][3] == 0 then --Desync detection
            Tmp = -3.4117*RSideS + 98.9393;
            if Tmp < 64 then
                Desync[Player] = Tmp;
            end
        else
            Tmp = -3.4117*RSideR + 98.9393;
            if Tmp < 64 then
                Desync[Player] = Tmp;
            end
        end

        local Temp45 = tonumber(AnimParts[6]["m_flWeight"][4]..AnimParts[6]["m_flWeight"][5]);

        if AnimParts[6]["m_flWeight"][2] == 0 then
            if (Animlayers[6]["m_flWeight"]*10^5 > 300) then
                SideCount[Player] = SideCount[Player] + 1;
            else
                SideCount[Player] = 0;
            end
        elseif AnimParts[6]["m_flWeight"][1] == 9 then
            if Temp45 == 29 then
                Side[Player] = "Left";
            elseif Temp45 == 30 then
                Side[Player] = "Right";
            elseif AnimParts[6]["m_flWeight"][2] == 9 then
                SideCount[Player] = SideCount[Player] + 2;
            else
                SideCount[Player] = 0;
            end
        end

        if SideCount[Player] >= 4 then
            if Side[Player] == "Left" then
                Side[Player] = "Right";
            else
                Side[Player] = "Left";
            end
            SideCount[Player] = 0;
        end

        Desync[Player] = Tools.Clamp(math.abs(math.floor(Desync[Player])), 0, 60);

        --------------------------------------------------------------------------------------

        local PlayerPitch = ({entity.get_prop(Player, "m_angEyeAngles")})[1];

        if PlayerPitch < 0 and TempPitch[Player] > 0 then-- Defensive Correction
            plist.set(Player, "Force Pitch", true);
            plist.set(Player, "Force Pitch Value", TempPitch[Player]);
        else
            plist.set(Player, "Force Pitch", false);
            TempPitch[Player] = PlayerPitch;
        end

        --------------------------------------------------------------------------------------

        if Side[Player] == "Right" then
            plist.set(Player, "force body yaw value", Desync[Player]);
        else
            plist.set(Player, "force body yaw value", -Desync[Player]);
        end
    end
end

local trashcan = {
    --if Animlayers["m_flPlaybackRate"][3] == 0 then
        --print(string.format("Anim67: %s | Anim89: %s | Diff: %s", Anim67, Anim89, math.abs(Anim67-Anim89)));
        --print(Anim6789);
        --if RSideS > 30 then
        --print(RSideS);
        --end
    --else
        --print(string.format("Anim45: %s | Anim67: %s | Diff: %s", Anim45, Anim67, math.abs(Anim45-Anim67)));
        --print(Anim4567);
        --print(RSideR);
    --end

    --print(string.format("Desync: %s | Side: %s", Desync[Player], Side[Player]));  

    --entity.get_prop(Player, "m_fFlags");
    --entity.get_prop(Player, "m_bSpotted");
    --entity.get_prop(Player, "m_flSimulationTime"); 

    --local EnemyOrigin =     {entity.get_origin(Player)};
    --local EnemyHeadPos =    {entity.hitbox_position(Player, 1)};

    --local LpToCenter =      ({client.trace_line(-1, LpEyeAngle[1], LpEyeAngle[2], LpEyeAngle[3], EnemyOrigin[1], EnemyOrigin[2], EnemyOrigin[3]+56)})[1];
    --local LpToHead =       ({client.trace_line(-1, LpEyeAngle[1], LpEyeAngle[2], LpEyeAngle[3], EnemyHeadPos[1], EnemyHeadPos[2], EnemyHeadPos[3])})[1];

    --local Angulo =  math.cos(LpToEnemy/LpToHead)*(10^2); --50
    --local Angulo1 = Angulo*(10^2) - (math.floor(Angulo)*10^2);
    --local RDesync = Angulo*10 - (math.floor(Angulo/(10^1))*10^2);

    --print(string.format("Center Pos: %s | Head Pos: %s | Difference: %s", LpToCenter, LpToHead, LpToCenter-LpToHead));

    --if LpToCenter > LpToHead then
    --    ResolverWorking[Player] = true;

    --    if LpToCenter-LpToHead >= 0.014 then
    --        Side[Player] = "Left";
    --    else
    --        Side[Player] = "Right"
    --    end

    --    Desync[Player] = 60;
    --else
    --    ResolverWorking[Player] = false;
    --end
};

client.set_event_callback("net_update_end", Resolver);

client.register_esp_flag("R", 255, 255, 255, function(Player)
    if not ui.get(MenuC["Enable"]) or not ui.get(MenuC["Flag"]) then
        return false;
    end

    if Side[Player] == "Right" then
        return true;
    end

    return false;
end)

client.register_esp_flag("L", 255, 255, 255, function(Player)
    if not ui.get(MenuC["Enable"]) or not ui.get(MenuC["Flag"]) then
        return false;
    end

    if Side[Player] == "Left" then
        return true;
    end

    return false;
end)

client.set_event_callback('aim_hit', function(e)
    if not ui.get(MenuC["Enable"]) or not ui.get(MenuC["DebugLogs"]) then
        return;
    end

    local P = e.target;

    if e.hitgroup == 1 then
        print(string.format("Hitted shot (Side: %s | Desync: %s)", Side[P], Desync[P]));
    end
end)

client.set_event_callback('aim_miss', function(e)
    if ui.get(MenuC["Enable"]) then
        local P = e.target;

        if e.reason == "?" then
            if ui.get(MenuC["DebugLogs"]) then
                print(string.format("Missed shot (Side: %s | Desync: %s)", Side[P], Desync[P]));
                if Side[P] == "Left" then
                    Side[P] = "Right";
                else
                    Side[P] = "Left";
                end
            end
        else
            if ui.get(MenuC["DebugLogs"]) then
                print(e.reason);
            end
        end
    end
end)

client.set_event_callback('shutdown', function()
    --ui.set_visible(MenuV["Anti-Aim Correction"], true);
    ui.set_visible(MenuV["ForceBodyYaw"], true);
    ui.set_visible(MenuV["CorrectionActive"], true);
    --ui.set(MenuV["Anti-Aim Correction"], true);
    ui.set(MenuV["ResetAll"], true);
end)
