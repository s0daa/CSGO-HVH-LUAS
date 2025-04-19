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
    slow_motion = {ui.reference('AA', 'Other', 'Slow motion')}
}

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

current_tab = ui.new_combobox('AA', 'Anti-aimbot angles', 'Tabs', {'Home', 'Anti-Aim', 'Misc/Vis'})
local text1 = ui.new_label('AA', 'Anti-aimbot angles', 'mytools for gs ~ \a95b806ffbeta test', 'string')
local text2 = ui.new_label('AA', 'Anti-aimbot angles', 'last upd ~ 23.10.2023', 'string')
local text3 = ui.new_label('AA', 'Anti-aimbot angles', 'if you find a bug, write to discord ticket', 'string')
settings.anti_aim_state = ui.new_combobox('AA', 'Anti-aimbot angles', 'Anti-aimbot state', anti_aim_states)

local master_switch = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Log Aimbot Shots')
local console_filter = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Console Filter')
local anim_breakerx = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Animation Breaker')
local force_safe_point = ui.reference('RAGE', 'Aimbot', 'Force safe point')
local trashtalk = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Trash Talk')
local clantagchanger = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Clan Tag')
local fastladder = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Fast Ladder')
local hitmarker = ui.new_checkbox('AA', 'Anti-aimbot angles', '3D Hit Marker')

local aspectratio = ui.new_slider('AA', 'Anti-aimbot angles', 'Aspect Ratio', 0, 200, 0, true, nil, 0.01, {[0] = "Off"})

local override_zoom_fov = ui_reference("Misc", "Miscellaneous", "Override zoom FOV")
local cache = ui.get(override_zoom_fov)
local scope_fov = ui_new_slider('AA', 'Anti-aimbot angles', "Second Zoom FOV", -0, 100, 0, true, '%', 1, {[0] = "Off"})

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
        client.color_log(255, 0, 0, "mytools ~\0")
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

    client.color_log(124, 252, 0, "mytools ~\0")
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
    local text_to_draw = "M Y T O O L S"
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
    renderer.text(width - (width-70), height - 555, r, g, b, 255, "c", 0, output .. ' \afa5757FF[DEV]')
end
client.set_event_callback("paint", on_paint)

client.set_event_callback('paint_ui', function()
    if entity.get_local_player() == nil then cheked_ticks = 0 end

    if ui.is_menu_open() then
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
        ui.set_visible(settings.avoid_backstab, ui.get(current_tab) == 'Anti-Aim')
        ui.set_visible(settings.safe_head_in_air, ui.get(current_tab) == 'Anti-Aim')
        ui.set_visible(settings.manual_forward, ui.get(current_tab) == 'Anti-Aim')
        ui.set_visible(settings.manual_right, ui.get(current_tab) == 'Anti-Aim')
        ui.set_visible(settings.manual_left, ui.get(current_tab) == 'Anti-Aim')
        ui.set_visible(settings.edge_yaw, ui.get(current_tab) == 'Anti-Aim')
        ui.set_visible(settings.freestanding, ui.get(current_tab) == 'Anti-Aim')
        ui.set_visible(settings.warmup_disabler, ui.get(current_tab) == 'Anti-Aim')
        ui.set_visible(settings.freestanding_conditions, ui.get(current_tab) == 'Anti-Aim')
        ui.set_visible(settings.tweaks, ui.get(current_tab) == 'Anti-Aim')
        ui.set_visible(trashtalk, ui.get(current_tab) == 'Misc/Vis')
        ui.set_visible(master_switch, ui.get(current_tab) == 'Misc/Vis')
        ui.set_visible(console_filter, ui.get(current_tab) == 'Misc/Vis')
        ui.set_visible(anim_breakerx, ui.get(current_tab) == 'Misc/Vis')
        ui.set_visible(aspectratio, ui.get(current_tab) == 'Misc/Vis')
        ui.set_visible(scope_fov, ui.get(current_tab) == 'Misc/Vis')
        ui.set_visible(hitmarker, ui.get(current_tab) == 'Misc/Vis')
        ui.set_visible(fastladder, ui.get(current_tab) == 'Misc/Vis')
        ui.set_visible(clantagchanger, ui.get(current_tab) == 'Misc/Vis')
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
    client.color_log(124, 252, 0, "mytools ~\0")
	client.color_log(200, 200, 200, " config successfully exported!")
end)
default_btn = ui.new_button("AA", "Anti-aimbot angles", "Default Config", function() 
    import('W1siTW92aW5nIix0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLHRydWUsdHJ1ZSxmYWxzZSxmYWxzZSwiT2ZmIiwiTWluaW1hbCIsIk1pbmltYWwiLCJNaW5pbWFsIiwiTWluaW1hbCIsIk1pbmltYWwiLCJNaW5pbWFsIiwiTWluaW1hbCIsIk1pbmltYWwiLCJPZmYiLDAsMCwwLDAsMCwwLDAsMCwwLDAsIkxvY2FsIHZpZXciLCJBdCB0YXJnZXRzIiwiQXQgdGFyZ2V0cyIsIkF0IHRhcmdldHMiLCJBdCB0YXJnZXRzIiwiQXQgdGFyZ2V0cyIsIkF0IHRhcmdldHMiLCJBdCB0YXJnZXRzIiwiQXQgdGFyZ2V0cyIsIkxvY2FsIHZpZXciLCJPZmYiLCIxODAiLCIxODAiLCIxODAiLCIxODAiLCIxODAiLCIxODAiLCIxODAiLCIxODAiLCJPZmYiLDAsOCwtMzMsLTE0LDAsLTE1LDAsMCw3LDAsMCw4LC0zMywtMTQsMCwtMTUsMCwwLDcsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLCJPZmYiLCJDZW50ZXIiLCJPZmZzZXQiLCJPZmZzZXQiLCJEZWxheSIsIk9mZnNldCIsIkRlbGF5IiwiRGVsYXkiLCJDZW50ZXIiLCJPZmYiLDAsNTQsNjgsNDAsLTI5LDUxLC0yNSwtMjMsNTAsMCwwLDU0LDY4LDQwLDQzLDUxLDQwLDQxLDUwLDAsMCwwLDUsNCwwLDMsMCwwLDAsMCwyLDIsMiwyLDQsMiw2LDQsMiwyLCJPZmYiLCJKaXR0ZXIiLCJKaXR0ZXIiLCJKaXR0ZXIiLCJPZmYiLCJKaXR0ZXIiLCJPZmYiLCJPZmYiLCJKaXR0ZXIiLCJPcHBvc2l0ZSIsMCwtNDAsLTQwLC00MCwwLC00MCwwLDAsLTQwLDAsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsdHJ1ZSwwLDAsMCwwLDAsMCwwLDAsMCwwLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwiMTgwIiwwLDAsMCwwLDAsMCwwLDAsMCwwLHRydWUsdHJ1ZSxbIlN0YW5kaW5nIiwiTW92aW5nIiwiQ3JvdWNoaW5nIl0sWyJPZmYgaml0dGVyIHdoaWxlIGZyZWVzdGFuZGluZyIsIk9mZiBqaXR0ZXIgb24gbWFudWFsIl0sdHJ1ZSx0cnVlLHRydWUsMzUsdHJ1ZSwxNTAsZmFsc2UsZmFsc2UsdHJ1ZSx0cnVlXV0=')
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
    {'⠀1', 'nice iq'},
    {'cgb gblfhfc', 'спи пидорас'},
    {'пздц', 'игрок'},
    {'1 моча', 'изи'},
    {'куда ты', 'сынок ебаный'},
    {'найс аа хуесос', 'долго делал?'},
    {'ебать что', 'как я убил ахуеть'},
    {'mytools over all pidoras'},
    {'nice iq', 'churka)'},
    {'1 чмо', 'нищий без майтулса'},
    {'лол', 'как же я тебя выебал'},
    {'че за луашку юзаешь'},
    {'чей кфг юзаешь'},
    {'найс айкью', 'хуесос'},
    {']f]f]f]f]f]f]', 'хахахаха'},
    {'jq ,kz', 'ой бля', 'найс кфг уебище'},
    {'jq', 'я в афк чит настраивал хаха'},
    {'какой же у тебя сочный ник'},
    {'хуйсос анимешный', 'думал не убью тебя?)'},
    {'моча ебаная', 'кого ты пытаешься убить'},
    {'mad cuz bad?', 'hhhhhh retardw'},
    {'учись пока я жив долбаеб'},
    {'еблан', 'включи монитор'},
    {'1', 'опять умер моча'},
    {'egc', 'упссс', 'сорри'},
    {'хахаха ебать я тебя трахнул'},
    {'nice iq', 'u sell'},
    {'изи шлюха', 'че в хуй?'},
    {'получай тварь ебаная', 'фу нахуй'},
    {']f]f]f]f]f]]f]f', 'как же мне похуй долбаеб'},
    {'изи моча', 'я ору с тебя какой же ты сочный'},
    {'ez owned', 'weak dog + rat'},
    {'пиздец ты легкий ботик'},
    {'1', 'не отвечаю?', 'мне похуй'},
    {'как же мне похуй', 'ботик'},
    {'retard', 'just fucking bot'},
    {'♕ M Y T O O L S > A L L ♕'},
    {'закупись майтулсом на скит чмо ебаное'}
}
    
local death_say = {
    {'пиздец че я за хуйню купил', 'лучше бы майтулс купил бля'},
    {'ну фу', 'хуесос'},
    {'что ты делаешь', 'моча умалишенная'},
    {'бля', 'я стрелял вообще чи шо?'},
    {'чит подвел'},
    {'БЛЯЯЯЯЯЯЯЯЯЯЯЯТЬ', 'как же ты меня заебал'},
    {'ну и зачем', 'дал бы клип', 'пиздец клоун'},
    {'ахахахах', 'ну да', 'опять сын шлюхи убил бестолковый'},
    {'м', 'пон)', 'найс чит'},
    {'да блять', 'какой джиттер поставить сука'},
    {'ну фу', 'ублюдок', 'ебаный'},
    {'да сука', 'где тимейты блять', 'как же сука они меня бесят'},
    {'lf ,kznm', 'да блять', 'опять я мисснул'},
    {'да блять', 'ало', 'я вообще стрелять буду нет'},
    {'хех', 'ты сам то хоть понял', 'как меня убил'},
    {'сука', 'опять по дезу ебаному'},
    {'бля', 'клиентнуло', 'лаки'},
    {'понятно', 'ик ак ты так играешь', 'еблан бестолковый'},
    {'ну блять', 'он просто пошел', 'пиздец'},
    {'&', 'и че это', 'откуда ты меня убил?'},
    {'тварь', 'ебаная', 'ЧТО ТЫ ДЕЛАЕШЬ'},
    {'YE LF', 'ну да', 'хуесос', 'норм играешь'},
    {'сочник ебаный', 'как же ты меня заебал уже', 'что ты делаешь'},
    {'хуевый без скита', 'как ты меня убиваешь с пастой своей'},
    {'подпивас ебаный', 'как же ты меня переиграл'},
    {'бля', 'признаю, переиграл'},
    {'как ты меня убиваешь', 'ебаный owosh'},
    {'дефектус че ты делаешь', 'пиздец'},
    {'хуйсосик анимешный', 'как ты убиваешь', 'эт пздц'},
    {'бля ну бро', 'посмотри на мою команду', 'это пзиидец'},
    {'ммм', 'хуесосы бездарные в команде'},
    {'ik.[f', 'шлюха пошла нахуй'},
    {'ndfhm t,fyfz', 'тварь ебаная как же ты меня бесишь'},
    {'фу нахуй', 'опять в бекшут'},
    {'только так и умеешь да?', 'блядь ебаная'},
    {'нахуй ты меня трешкаешь', 'шлюха ебаная'},
    {'ну повезло тебе', 'дальше то что хуесос'},
    {'ебанная ты мразь', 'которая мне все проебала'},
    {'ujcgjlb', 'господи', 'мразь убогая'},
    {'хахахах', 'ну бля заебись фристенд в чите)'},
    {'фу ты заебал конч'},
    {')', 'хорош)'},
    {'норм трекаешь', 'ублюдина'},
    {'а че', 'хайдшоты на фд уже не работают?'}
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
    local lua_name = "mytools.gs "
    if ui.get(clantagchanger) then
        if ui.get(ui.reference("Misc", "Miscellaneous", "Clan tag spammer")) then ui.set(ui.reference("Misc", "Miscellaneous", "Clan tag spammer"), false) end

		local clan_tag = clantag_anim(lua_name, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25})

        if entity.get_prop(entity.get_game_rules(), "m_gamePhase") == 5 then
            clan_tag = clantag_anim('mytools.gs ', {13})
            client.set_clan_tag(clan_tag)
        elseif entity.get_prop(entity.get_game_rules(), "m_timeUntilNextPhaseStarts") ~= 0 then
            clan_tag = clantag_anim('mytools.gs ', {13})
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

	client.color_log(124, 252, 0, "mytools ~\0")
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

	client.color_log(255, 0, 0, "mytools ~\0")
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
		client.color_log(124, 252, 0, "mytools ~\0")
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