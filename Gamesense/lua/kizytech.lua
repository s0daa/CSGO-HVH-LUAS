local vector = require 'vector'
local c_entity = require 'gamesense/entity'
local images = require("gamesense/images")
local base64 = require 'gamesense/base64'
local clipboard = require 'gamesense/clipboard'
local steamworks = require 'gamesense/steamworks'
local color_r, color_g, color_b, color_a = 255,255,0,255
local client_set_event_callback, client_unset_event_callback = client.set_event_callback, client.unset_event_callback
local entity_get_local_player, entity_get_player_weapon, entity_get_prop = entity.get_local_player, entity.get_player_weapon, entity.get_prop
local ui_get, ui_set, ui_set_callback, ui_set_visible, ui_reference, ui_new_checkbox, ui_new_slider = ui.get, ui.set, ui.set_callback, ui.set_visible, ui.reference, ui.new_checkbox, ui.new_slider
X,Y = client.screen_size()
local notify_data = {}
local ref = {
    aa_enable = ui.reference("AA","anti-aimbot angles","enabled"),
    pitch = ui.reference("AA","anti-aimbot angles","pitch"),
    pitch_value = select(2, ui.reference("AA","anti-aimbot angles","pitch")),
    yaw_base = ui.reference("AA","anti-aimbot angles","yaw base"),
    yaw = ui.reference("AA","anti-aimbot angles","yaw"),
    yaw_value = select(2, ui.reference("AA","anti-aimbot angles","yaw")),
    yaw_jitter = ui.reference("AA","Anti-aimbot angles","Yaw Jitter"),
    yaw_jitter_value = select(2, ui.reference("AA","Anti-aimbot angles","Yaw Jitter")),
    body_yaw = ui.reference("AA","Anti-aimbot angles","Body yaw"),
    body_yaw_value = select(2, ui.reference("AA","Anti-aimbot angles","Body yaw")),
    freestand_body_yaw = ui.reference("AA","Anti-aimbot angles","freestanding body yaw"),
    edgeyaw = ui.reference("AA","anti-aimbot angles","edge yaw"),
    freestand = {ui.reference("AA","anti-aimbot angles","freestanding")},
    roll = ui.reference("AA","anti-aimbot angles","roll"),
    slide = {ui.reference("AA","other","slow motion")},
    fakeduck = ui.reference("rage","other","duck peek assist"),
    quick_peek = {ui.reference("rage", "other", "quick peek assist")},
    doubletap = {ui.reference("rage", "aimbot", "double tap")},
}

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
    aa_enable = ui.reference("AA","anti-aimbot angles","enabled")
}

local prev_simulation_time = 0

local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end

local diff_sim = 0

function sim_diff() 
    local current_simulation_time = time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
end

function rgba_to_hex(b,c,d,e)
    return string.format('%02x%02x%02x%02x',b,c,d,e)
end

function text_fade_animation(speed, r, g, b, a, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i=0, #text do
        local color = rgba_to_hex(r, g, b, a*math.abs(1*math.cos(2*speed*curtime/4+i*5/30)))
        final_text = final_text..'\a'..color..text:sub(i, i)
    end
    return final_text
end

function text_fade_animation_guwno(speed, r, g, b, a, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local color = rgba_to_hex(r, g, b, a * math.abs(1 * math.cos(2 * speed * curtime / 4 - i * 5 / 30)))
        final_text = final_text .. '\a' .. color .. text:sub(i, i)
    end
    return final_text
end

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

text1 = ui.new_label('AA', 'Anti-aimbot angles', ".")
text2 = ui.new_label('AA', 'Anti-aimbot angles', ".")
text3 = ui.new_label('AA', 'Anti-aimbot angles', ".")
current_tab = ui.new_combobox('AA', 'Anti-aimbot angles', '\n ', {'Anti-Aim', 'Visuals', "Misc", "Config"})
current_color = ui.new_color_picker("AA", 'Anti-aimbot angles', "colormenu", 173, 144, 90)
current_state_menu = ui.new_combobox("AA", "Anti-aimbot angles", "\n ", "builder", "keybinds", "other")
settings.anti_aim_state = ui.new_combobox('AA', 'Anti-aimbot angles', "condition", anti_aim_states)

local master_switch = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Hitlogs')
local fastladder = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Fast Ladder')
local force_safe_point = ui.reference('RAGE', 'Aimbot', 'Force safe point')
local clantagchanger = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Clan Tag')
local anim_breakerx = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Animation Breaker')
local console_filter = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Console Filter')

for i = 1, #anti_aim_states do
    anti_aim_settings[i] = {
        override_state = ui.new_checkbox('AA', 'Anti-aimbot angles', 'enable ' .. string.lower(anti_aim_states[i])),
        pitch1 = ui.new_combobox('AA', 'Anti-aimbot angles', 'pitch' .. anti_aim_different[i], 'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random', 'Custom'),
        pitch2 = ui.new_slider('AA', 'Anti-aimbot angles', '\npitch' .. anti_aim_different[i], -89, 89, 0, true, '°'),
        yaw_base = ui.new_combobox('AA', 'Anti-aimbot angles', 'yaw base' .. anti_aim_different[i], 'Local view', 'At targets'),
        yaw1 = ui.new_combobox('AA', 'Anti-aimbot angles', 'yaw' .. anti_aim_different[i], 'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'),
        yaw2_left = ui.new_slider('AA', 'Anti-aimbot angles', 'yaw left' .. anti_aim_different[i], -180, 180, 0, true, '°'),
        yaw2_right = ui.new_slider('AA', 'Anti-aimbot angles', 'yaw right' .. anti_aim_different[i], -180, 180, 0, true, '°'),
        yaw2_randomize = ui.new_slider('AA', 'Anti-aimbot angles', 'yaw randomize' .. anti_aim_different[i], 0, 180, 0, true, '°'),
        yaw_jitter1 = ui.new_combobox('AA', 'Anti-aimbot angles', 'yaw jitter' .. anti_aim_different[i], 'Off', 'Offset', 'Center', 'Random', 'Skitter', 'Delay'),
        yaw_jitter2_left = ui.new_slider('AA', 'Anti-aimbot angles', 'yaw jitter left' .. anti_aim_different[i], -180, 180, 0, true, '°'),
        yaw_jitter2_right = ui.new_slider('AA', 'Anti-aimbot angles', 'yaw jitter right' .. anti_aim_different[i], -180, 180, 0, true, '°'),
        yaw_jitter2_randomize = ui.new_slider('AA', 'Anti-aimbot angles', 'yaw jitter randomize' .. anti_aim_different[i], 0, 180, 0, true, '°'),
        yaw_jitter2_delay = ui.new_slider('AA', 'Anti-aimbot angles', 'yaw jitter delay' .. anti_aim_different[i], 2, 10, 2, true, 't'),
        body_yaw1 = ui.new_combobox('AA', 'Anti-aimbot angles', 'body yaw' .. anti_aim_different[i], 'Off', 'Opposite', 'Jitter', 'Static'),
        body_yaw2 = ui.new_slider('AA', 'Anti-aimbot angles', 'body Yaw' .. anti_aim_different[i], -180, 180, 0, true, '°'),
        freestanding_body_yaw = ui.new_checkbox('AA', 'Anti-aimbot angles', 'freestanding body yaw' .. anti_aim_different[i]),
        defensive_anti_aimbot = ui.new_checkbox('AA', 'Anti-aimbot angles', 'defensive builder' .. anti_aim_different[i]),
        defensive_pitch1 = ui.new_combobox('AA', 'Anti-aimbot angles', 'pitch' .. anti_aim_different[i], 'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random', 'Custom'),
        defensive_pitch2 = ui.new_slider('AA', 'Anti-aimbot angles', '\n ' .. anti_aim_different[i], -89, 89, 0, true, '°'),
        defensive_pitch3 = ui.new_slider('AA', 'Anti-aimbot angles', '\n ' .. anti_aim_different[i], -89, 89, 0, true, '°'),
        defensive_yaw1 = ui.new_combobox('AA', 'Anti-aimbot angles', 'yaw' .. anti_aim_different[i], '180', 'Spin', '180 Z', 'Sideways', 'Random'),
        defensive_yaw2 = ui.new_slider('AA', 'Anti-aimbot angles', '\n ' .. anti_aim_different[i], -180, 180, 0, true, '°')
    }
end

settings.warmup_disabler = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Warmup disabler')
settings.avoid_backstab = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Avoid backstab')
settings.safe_head_in_air = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Safe head in air')
settings.manual_left = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual left')
settings.manual_right = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual right')
settings.manual_forward = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual forward')
settings.freestanding = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Freestanding')
settings.freestanding_conditions = ui.new_multiselect('AA', 'Anti-aimbot angles', '\nFreestanding', 'Standing', 'Moving', 'Slow motion', 'Crouching', 'In air')
settings.tweaks = ui.new_multiselect('AA', 'Anti-aimbot angles', '\nTweaks', 'Off jitter while freestanding', 'Off jitter on manual')


local data = {
    integers = {
        settings.anti_aim_state,
        anti_aim_settings[1].override_state, anti_aim_settings[2].override_state, anti_aim_settings[3].override_state, anti_aim_settings[4].override_state, anti_aim_settings[5].override_state, anti_aim_settings[6].override_state, anti_aim_settings[7].override_state, anti_aim_settings[8].override_state, anti_aim_settings[9].override_state, anti_aim_settings[10].override_state,
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
        anti_aim_settings[1].defensive_anti_aimbot, anti_aim_settings[2].defensive_anti_aimbot, anti_aim_settings[3].defensive_anti_aimbot, anti_aim_settings[4].defensive_anti_aimbot, anti_aim_settings[5].defensive_anti_aimbot, anti_aim_settings[6].defensive_anti_aimbot, anti_aim_settings[7].defensive_anti_aimbot, anti_aim_settings[8].defensive_anti_aimbot, anti_aim_settings[9].defensive_anti_aimbot, anti_aim_settings[10].defensive_anti_aimbot,
        anti_aim_settings[1].defensive_pitch1, anti_aim_settings[2].defensive_pitch1, anti_aim_settings[3].defensive_pitch1, anti_aim_settings[4].defensive_pitch1, anti_aim_settings[5].defensive_pitch1, anti_aim_settings[6].defensive_pitch1, anti_aim_settings[7].defensive_pitch1, anti_aim_settings[8].defensive_pitch1, anti_aim_settings[9].defensive_pitch1, anti_aim_settings[10].defensive_pitch1,
        anti_aim_settings[1].defensive_pitch2, anti_aim_settings[2].defensive_pitch2, anti_aim_settings[3].defensive_pitch2, anti_aim_settings[4].defensive_pitch2, anti_aim_settings[5].defensive_pitch2, anti_aim_settings[6].defensive_pitch2, anti_aim_settings[7].defensive_pitch2, anti_aim_settings[8].defensive_pitch2, anti_aim_settings[9].defensive_pitch2, anti_aim_settings[10].defensive_pitch2,
        anti_aim_settings[1].defensive_pitch3, anti_aim_settings[2].defensive_pitch3, anti_aim_settings[3].defensive_pitch3, anti_aim_settings[4].defensive_pitch3, anti_aim_settings[5].defensive_pitch3, anti_aim_settings[6].defensive_pitch3, anti_aim_settings[7].defensive_pitch3, anti_aim_settings[8].defensive_pitch3, anti_aim_settings[9].defensive_pitch3, anti_aim_settings[10].defensive_pitch3,
        anti_aim_settings[1].defensive_yaw1, anti_aim_settings[2].defensive_yaw1, anti_aim_settings[3].defensive_yaw1, anti_aim_settings[4].defensive_yaw1, anti_aim_settings[5].defensive_yaw1, anti_aim_settings[6].defensive_yaw1, anti_aim_settings[7].defensive_yaw1, anti_aim_settings[8].defensive_yaw1, anti_aim_settings[9].defensive_yaw1, anti_aim_settings[10].defensive_yaw1,
        anti_aim_settings[1].defensive_yaw2, anti_aim_settings[2].defensive_yaw2, anti_aim_settings[3].defensive_yaw2, anti_aim_settings[4].defensive_yaw2, anti_aim_settings[5].defensive_yaw2, anti_aim_settings[6].defensive_yaw2, anti_aim_settings[7].defensive_yaw2, anti_aim_settings[8].defensive_yaw2, anti_aim_settings[9].defensive_yaw2, anti_aim_settings[10].defensive_yaw2,
        settings.avoid_backstab,
        settings.safe_head_in_air,
        settings.freestanding_conditions,
        settings.tweaks, master_switch, console_filter, anim_breakerx, trashtalk, hitmarker, fastladder, clantagchanger, settings.warmup_disabler
    }
}

--https://media.discordapp.net/attachments/1062810573814910987/1189738364727988285/guwno.png?ex=659f4132&is=658ccc32&hm=a4962ecb6e62ee48ce924d8605feab5e91abb466dfdcfd70d9614edc71fcdf6e&=&format=webp&quality=lossless
local logo = nil
function get_logo()
    http.get("https://media.discordapp.net/attachments/1172939228771004416/1204093124343894027/red_star_PNG48.png", function(s, r)
        if s then
            logo = images.load(r.body)
        end
    end)
end
get_logo()

to_draw = "no"
to_up = "no"
to_draw_ticks = 0
local y = 0
local alpha = 255
local timer_test = 0
local ctx = (function()
    local ctx = {}

    ctx.m_render = {
        rec = function(self, x, y, w, h, radius, color)
            radius = math.min(x/2, y/2, radius)
            local r, g, b, a = unpack(color)
            renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
            renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
            renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
            renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
            renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
            renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
            renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
        end,

        rec_outline = function(self, x, y, w, h, radius, thickness, color)
            radius = math.min(w/2, h/2, radius)
            local r, g, b, a = unpack(color)
            if radius == 1 then
                renderer.rectangle(x, y, w, thickness, r, g, b, a)
                renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
            else
                renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
                renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
            end
        end,

        glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
            local thickness = 1
            local offset = 1
            local r, g, b, a = unpack(accent)
            if accent_inner then
                self:rec(x , y, w, h + 1, rounding, accent_inner)
            end
            for k = 0, width do
                if a * (k/width)^(1) > 5 then
                    local accent = {r, g, b, a * (k/width)^(2)}
                    self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
                end
            end
        end,

        pandora_og = function(self, x,y,w,h,r,g,b,a, text)
            self:rec(x,y,w,h,3, {0,0,0,255})
            self:rec_outline(x + 1, y + 1, w - 2, h - 2, 3, 1, {45,45,45,255})
            self:rec(x + 3, y + 3, w - 6, h - 6, 2, {15,15,15,255})
            renderer.text(x + 5, y + 6, r,g,b,a, '', nil, text)
        end
    }

    ctx.get_defensive = {
        get = function()
            local diff = sim_diff()

            if diff <= -1 then
                to_draw = "yes"
                to_up = "yes"
            end
        end
    }

    ctx.helps = {
        calculatePercentage = function(ticks, przez)
            local percentage = (ticks / przez) * 100
            return percentage
        end
    }

    ctx.defensive_ind = {
        render = function()
            local r,g,b,a = ui.get(current_color)
            if to_draw == "yes" and ui.get(ref.doubletap[2]) then
            
                draw_art = to_draw_ticks * 100 / 27
            
                --ctx.m_render:glow_module(X / 2 - 50, Y / 2 * 0.5, 100,4, 10,2,{r,g,50}, {30,30,30,100})
                --renderer.text(X / 2 , Y / 2  * 0.5 - 10 ,255,255,255,255,"c",0,"- defensive -")
                ctx.m_render:rec(X / 2 - 65, Y /2 * 0.5, 130, 40, 20, {20,20,20,255})
                renderer.text(X / 2 - 20, Y /2 * 0.52, 255,255,255,255, "b", 0, math.floor(ctx.helps.calculatePercentage(to_draw_ticks, 27)).."%")
                ctx.m_render:rec(X / 2 - 59, Y /2 * 0.558, 5, 6, 2, {r,g,b,255})
                ctx.m_render:rec(X / 2 - 57, Y /2 * 0.558, 10, 8, 4, {r,g,b,255})
                ctx.m_render:rec(X / 2 - 50, Y /2 * 0.558, draw_art, 8, 2, {r,g,b,255})

                if logo ~= nil then
                    logo:draw(X /2 + 20, Y /2 * 0.48, 60, 60, r,g,b,255, true)
                else 
                    get_logo()
                end

                if to_draw_ticks == 27 then
                    to_draw_ticks = 0
                    to_draw = "no"
                end
                to_draw_ticks = to_draw_ticks + 1
            end
        end
    }

    ctx.arrows = {
        render = function()
            if direction == -90 then
                renderer.text(X / 2 - 60, Y /2 - 6, 255,255,255,255, "", 0, "⯇")
            end
            if direction == 90 then
                renderer.text(X / 2 + 50, Y /2 - 6, 255,255,255,255, "", 0, "⯈")
            end
        end
    }

    ctx.helps = {
        lerp = function(a, b, t)
            return a + (b - a) * t
        end
    }

    ctx.loading_anim = {
        run = function()
            local sizing = ctx.helps.lerp(0.1, 0.9, math.sin(globals.realtime() * 2) * 0.5 + 0.5)
            local rotation = ctx.helps.lerp(0, 360, globals.realtime() % 1)
            y = ctx.helps.lerp(y, 20, globals.frametime() * 2)
            --alpha = ctx.helps.lerp(alpha, 0, globals.frametime() * 1)
            timer_test = timer_test + 2

            if timer_test > X - 200 then
                alpha = ctx.helps.lerp(alpha, 0, globals.frametime() * 2.7)
            end

            if timer_test > X then
                timer_test = X + 1
            end

            renderer.rectangle(0, 0, X, Y, 20, 20, 20, alpha)
            renderer.rectangle(0, 0, timer_test, 3, color_r, color_g, color_b, alpha)
            if logo ~= nil then
                logo:draw(X/2 - (y * 2) - 10, Y/2 - 180, 25 + (y * 4),25 + (y * 4), 255,255,255,alpha)
            else
                get_logo()
            end
            renderer.text(X/2, Y /2 - 30, 184, 184, 184, alpha, 'c+', 0, 'Welcome \a'..rgba_to_hex(color_r, color_g, color_b, alpha)..celestia.username)
            renderer.text(X/2, Y /2, 184, 184, 184, alpha, 'c+', 0, 'Build \a'..rgba_to_hex(color_r, color_g, color_b, alpha)..celestia.build)
            renderer.text(X/2, Y - y, 184, 184, 184, alpha, 'c', 0, 'stardust.lua')
        end
    }

    return ctx
end)()

client.set_event_callback('paint_ui', function()
    ctx.loading_anim.run()
end)

function new_notify(string, r, g, b, a)
    local notification = {
        text = string,
        timer = globals.realtime(),
        color = { r, g, b, a },
        alpha = 0,
        fraction = 0,
        time_left = 0
    }

    if #notify_data == 0 then
        notification.y = Y + 20
    else
        local lastNotification = notify_data[#notify_data]
        notification.y = lastNotification.y + 20 
    end

    table.insert(notify_data, notification)
end

local function import(text)
    local status, config =
        pcall(
        function()
            return json.parse(base64.decode(text))
        end
    )

    if not status or status == nil then
        client.color_log(255, 0, 0, "stardust~\0")
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

    client.color_log(124, 252, 0, "stardust~\0")
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

    cmd.force_defensive = ui.get(anti_aim_settings[state_id].defensive_anti_aimbot)

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

    --defensive_aa
    if ui.get(anti_aim_settings[state_id].defensive_anti_aimbot) and is_defensive_active and ((ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2])) or (ui.get(reference.on_shot_anti_aim[1]) and ui.get(reference.on_shot_anti_aim[2]))) and not (direction == 180 or direction == 90 or direction == -90) then
        ui.set(reference.pitch[1], ui.get(anti_aim_settings[state_id].defensive_pitch1))

        if ui.get(anti_aim_settings[state_id].defensive_pitch1) == 'Random' then
            ui.set(reference.pitch[1], 'Custom')
            ui.set(reference.pitch[2], math.random(ui.get(anti_aim_settings[state_id].defensive_pitch2), ui.get(anti_aim_settings[state_id].defensive_pitch3)))
        else
            ui.set(reference.pitch[2], ui.get(anti_aim_settings[state_id].defensive_pitch2))
        end

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

    if ui.get(settings.safe_head_in_air) and (cmd.in_jump == 1 or bit.band(entity.get_prop(self, 'm_fFlags'), 1) == 0) and entity.get_prop(self, 'm_flDuckAmount') > 0.8 and (entity.get_classname(entity.get_player_weapon(self)) == 'CKnife' or entity.get_classname(entity.get_player_weapon(self)) == 'CWeaponTaser') and anti_aim_on_use == false and not (direction == 180 or direction == 90 or direction == -90) then
        ui.set(reference.pitch[1], 'Down')
        ui.set(reference.yaw[1], '180')
        ui.set(reference.yaw[2], 0)
        ui.set(reference.yaw_jitter[1], 'Off')
        ui.set(reference.body_yaw[1], 'Off')
    end

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

client.set_event_callback('paint_ui', function()
    if entity.get_local_player() == nil then cheked_ticks = 0 end

    if ui.is_menu_open() then
        ui.set_visible(reference.aa_enable, false)
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
        ui.set_visible(current_state_menu, ui.get(current_tab) == "Anti-Aim")
        ui.set_visible(settings.anti_aim_state, ui.get(current_tab) == 'Anti-Aim' and ui.get(current_state_menu) == "builder")
        ui.set_visible(settings.avoid_backstab, ui.get(current_tab) == 'Anti-Aim' and ui.get(current_state_menu) == "other")
        ui.set_visible(settings.safe_head_in_air, ui.get(current_tab) == 'Anti-Aim' and ui.get(current_state_menu) == "other")
        ui.set_visible(settings.manual_forward, ui.get(current_tab) == 'Anti-Aim' and ui.get(current_state_menu) == "keybinds")
        ui.set_visible(settings.manual_right, ui.get(current_tab) == 'Anti-Aim' and ui.get(current_state_menu) == "keybinds")
        ui.set_visible(settings.manual_left, ui.get(current_tab) == 'Anti-Aim' and ui.get(current_state_menu) == "keybinds")
        ui.set_visible(settings.freestanding, ui.get(current_tab) == 'Anti-Aim' and ui.get(current_state_menu) == "keybinds")
        ui.set_visible(settings.warmup_disabler, ui.get(current_tab) == 'Anti-Aim' and ui.get(current_state_menu) == "other")
        ui.set_visible(settings.freestanding_conditions, ui.get(current_tab) == 'Anti-Aim' and ui.get(current_state_menu) == "keybinds")
        ui.set_visible(settings.tweaks, ui.get(current_tab) == 'Anti-Aim' and ui.get(current_state_menu) == "keybinds")
        ui.set_visible(master_switch, ui.get(current_tab) == 'Visuals')
        ui.set_visible(console_filter, ui.get(current_tab) == 'Misc')
        ui.set_visible(anim_breakerx, ui.get(current_tab) == 'Misc')
        ui.set_visible(fastladder, ui.get(current_tab) == 'Misc')
        ui.set_visible(clantagchanger, ui.get(current_tab) == 'Misc')
        ui.set_visible(watermark_mode, ui.get(current_tab) == 'Visuals')
        

        for i = 1, #anti_aim_states do
            ui.set_visible(anti_aim_settings[i].override_state, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(current_state_menu) == "builder"); ui.set(anti_aim_settings[1].override_state, true); ui.set_visible(anti_aim_settings[1].override_state, false)
            ui.set_visible(anti_aim_settings[i].pitch1,ui.get(current_tab) == 'Anti-Aim' and  ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].pitch2, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].pitch1) == 'Custom' and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].yaw_base, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].yaw1, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].yaw2_left, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Delay' and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].yaw2_right, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Delay' and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].yaw2_randomize, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Delay' and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].yaw_jitter1, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].yaw_jitter2_left, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Off' and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].yaw_jitter2_right, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Off' and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].yaw_jitter2_randomize, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Off' and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].yaw_jitter2_delay, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) == 'Delay' and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].body_yaw1, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Delay' and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].body_yaw2, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and (ui.get(anti_aim_settings[i].body_yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].body_yaw1) ~= 'Opposite') and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Delay' and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].freestanding_body_yaw, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].body_yaw1) ~= 'Off' and ui.get(anti_aim_settings[i].yaw_jitter1) ~= 'Delay' and ui.get(current_state_menu) == "builder")
            ui.set_visible(anti_aim_settings[i].defensive_anti_aimbot, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(current_state_menu) == "builder"); ui.set_visible(anti_aim_settings[9].defensive_anti_aimbot, false)
            ui.set_visible(anti_aim_settings[i].defensive_pitch1, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].defensive_anti_aimbot) and ui.get(current_state_menu) == "builder"); ui.set_visible(anti_aim_settings[9].defensive_pitch1, false)
            ui.set_visible(anti_aim_settings[i].defensive_pitch2, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].defensive_anti_aimbot) and (ui.get(anti_aim_settings[i].defensive_pitch1) == 'Random' or ui.get(anti_aim_settings[i].defensive_pitch1) == 'Custom') and ui.get(current_state_menu) == "builder"); ui.set_visible(anti_aim_settings[9].defensive_pitch2, false)
            ui.set_visible(anti_aim_settings[i].defensive_pitch3, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].defensive_anti_aimbot) and ui.get(anti_aim_settings[i].defensive_pitch1) == 'Random' and ui.get(current_state_menu) == "builder"); ui.set_visible(anti_aim_settings[9].defensive_pitch3, false)
            ui.set_visible(anti_aim_settings[i].defensive_yaw1, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].defensive_anti_aimbot) and ui.get(current_state_menu) == "builder"); ui.set_visible(anti_aim_settings[9].defensive_yaw1, false)
            ui.set_visible(anti_aim_settings[i].defensive_yaw2, ui.get(current_tab) == 'Anti-Aim' and ui.get(settings.anti_aim_state) == anti_aim_states[i] and ui.get(anti_aim_settings[i].defensive_anti_aimbot) and (ui.get(anti_aim_settings[i].defensive_yaw1) == '180' or ui.get(anti_aim_settings[i].defensive_yaw1) == 'Spin' or ui.get(anti_aim_settings[i].defensive_yaw1) == '180 Z') and ui.get(current_state_menu) == "builder"); ui.set_visible(anti_aim_settings[9].defensive_yaw2, false)
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
    client.color_log(124, 252, 0, "stardust      ~\0")
	client.color_log(200, 200, 200, " config successfully exported!")
end)
default_btn = ui.new_button("AA", "Anti-aimbot angles", "Default Config", function() 
    import('W1siTm8gZXhwbG9pdHMiLHRydWUsdHJ1ZSx0cnVlLGZhbHNlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSxmYWxzZSwiT2ZmIiwiRG93biIsIkRvd24iLCJPZmYiLCJEb3duIiwiRG93biIsIkRvd24iLCJEb3duIiwiRG93biIsIk9mZiIsMCwwLDAsMCwwLDAsMCwwLDAsMCwiTG9jYWwgdmlldyIsIkxvY2FsIHZpZXciLCJBdCB0YXJnZXRzIiwiTG9jYWwgdmlldyIsIkF0IHRhcmdldHMiLCJBdCB0YXJnZXRzIiwiQXQgdGFyZ2V0cyIsIkF0IHRhcmdldHMiLCJBdCB0YXJnZXRzIiwiTG9jYWwgdmlldyIsIk9mZiIsIjE4MCIsIjE4MCIsIk9mZiIsIjE4MCIsIjE4MCIsIjE4MCIsIjE4MCIsIjE4MCIsIk9mZiIsMCwtMjYsMCwwLC0zNiwwLC0zOCwtMjgsMCwwLDAsMzAsMCwwLDI4LDAsNTAsNDIsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsIk9mZiIsIkRlbGF5IiwiRGVsYXkiLCJPZmYiLCJEZWxheSIsIkRlbGF5IiwiRGVsYXkiLCJEZWxheSIsIkRlbGF5IiwiT2ZmIiwwLC0zMywtMzMsMCwtNTIsLTM4LC00MiwtNDIsLTMyLDAsMCw0Miw0NCwwLDQyLDMyLDU2LDU0LDM2LDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwyLDYsNywyLDQsNyw3LDcsNiwyLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLCJPZmYiLDAsMCwwLDAsMCwwLDAsMCwwLDAsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSxmYWxzZSxmYWxzZSwiT2ZmIiwiRG93biIsIkRvd24iLCJPZmYiLCJEb3duIiwiRG93biIsIkRvd24iLCJEb3duIiwiRG93biIsIk9mZiIsMSwwLDAsMCwtODksLTg5LC00MSwtODksMCwwLDEsMCwwLDAsLTg5LC04OSwtNDEsLTg5LDAsMCwiMTgwIiwiU3BpbiIsIlNwaW4iLCIxODAiLCJTcGluIiwiU3BpbiIsIlNwaW4iLCJTcGluIiwiU2lkZXdheXMiLCIxODAiLDEsMCwwLDAsLTg5LC04OSwtNDEsLTg5LDAsMCx0cnVlLHRydWUsWyJTdGFuZGluZyIsIk1vdmluZyIsIlNsb3cgbW90aW9uIiwiQ3JvdWNoaW5nIiwiSW4gYWlyIl0sWyJPZmYgaml0dGVyIHdoaWxlIGZyZWVzdGFuZGluZyIsIk9mZiBqaXR0ZXIgb24gbWFudWFsIl0sdHJ1ZSx0cnVlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlXV0=')
end)

client.set_event_callback('paint_ui', function()
    if entity.get_local_player() == nil then cheked_ticks = 0 end

    ui.set_visible(export_btn, ui.get(current_tab) == 'Config')
    ui.set_visible(import_btn, ui.get(current_tab) == 'Config')
    ui.set_visible(default_btn, ui.get(current_tab) == 'Config')
end)

ui.set_callback(console_filter, function()
    cvar.con_filter_text:set_string("cool text")
    cvar.con_filter_enable:set_int(1)
end)

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
    local lua_name = "✴"
    if ui.get(clantagchanger) then
        if ui.get(ui.reference("Misc", "Miscellaneous", "Clan tag spammer")) then ui.set(ui.reference("Misc", "Miscellaneous", "Clan tag spammer"), false) end

		local clan_tag = clantag_anim(lua_name, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25})

        if entity.get_prop(entity.get_game_rules(), "m_gamePhase") == 5 then
            clan_tag = clantag_anim('stardust.lua ', {13})
            client.set_clan_tag(clan_tag)
        elseif entity.get_prop(entity.get_game_rules(), "m_timeUntilNextPhaseStarts") ~= 0 then
            clan_tag = clantag_anim('stardust.lua ', {13})
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
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 3)
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 7)
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 6)
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
    ctx.get_defensive.get()
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

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
local weapon_to_verb = { knife = '     Knifed', hegrenade = '     Naded', inferno = '     Burned' }

client.set_event_callback('aim_hit', function(e)
	if not ui.get(master_switch) or e.id == nil then
		return
	end

	local group = hitgroup_names[e.hitgroup + 1] or "?"

	-- client.color_log(124, 252, 0, "✴        ~\0")
	-- client.color_log(200, 200, 200, " Hit\0")
	-- client.color_log(124, 252, 0, string.format(" %s\0", entity.get_player_name(e.target)))
	-- client.color_log(200, 200, 200, " in the\0")
	-- client.color_log(124, 252, 0, string.format(" %s\0", group))
	-- client.color_log(200, 200, 200, " for\0")
	-- client.color_log(124, 252, 0, string.format(" %s\0", e.damage))
	-- client.color_log(200, 200, 200, " damage\0")
	-- client.color_log(200, 200, 200, " (\0")
	-- client.color_log(124, 252, 0, string.format("%s\0", entity.get_prop(e.target, "m_iHealth")))
	-- client.color_log(200, 200, 200, " health remaining)")

    local r,g,b,a = ui.get(current_color)
    new_notify(string.format("\aFFFFFFFF     Hit \a%s%s\aFFFFFFFF in the \a%s%s\aFFFFFFFF for \a%s%d\aFFFFFFFF damage (%d health remaining)", rgba_to_hex(r,g,b,255), entity.get_player_name(e.target), rgba_to_hex(r,g,b,255), group, rgba_to_hex(r,g,b,255), e.damage, entity.get_prop(e.target, "m_iHealth") ), r,g,b,255)
end)

client.set_event_callback("aim_miss", function(e)
	if not ui.get(master_switch) then
		return
	end

	local group = hitgroup_names[e.hitgroup + 1] or "?"

	-- client.color_log(255, 0, 0, "✴             ~\0")
	-- client.color_log(200, 200, 200, " Missed shot in\0")
	-- client.color_log(255, 0, 0, string.format(" %s\'s\0", entity.get_player_name(e.target)))
	-- client.color_log(255, 0, 0, string.format(" %s\0", group))
	-- client.color_log(200, 200, 200, " due to\0")
	-- client.color_log(255, 0, 0, string.format(" %s", e.reason))

    local r,g,b,a = ui.get(current_color)
    new_notify(string.format("\aFFFFFFFF     Missed \a%s%s\aFFFFFFFF (\a%s%s\aFFFFFFFF) due to \a%s%s", rgba_to_hex(219, 99, 96,255), entity.get_player_name(e.target), rgba_to_hex(219, 99, 96,255), group, rgba_to_hex(219, 99, 96,255), e.reason), 219, 99, 96,255)
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
		-- client.color_log(124, 252, 0, "✴         ~\0")
		-- client.color_log(200, 200, 200, string.format(" %s\0", weapon_to_verb[e.weapon]))
		-- client.color_log(124, 252, 0, string.format(" %s\0", target_name))
		-- client.color_log(200, 200, 200, " for\0")
		-- client.color_log(124, 252, 0, string.format(" %s\0", e.dmg_health))
		-- client.color_log(200, 200, 200, " damage\0")
		-- client.color_log(200, 200, 200, " (\0")
		-- client.color_log(124, 252, 0, string.format("%s\0", e.health))
		-- client.color_log(200, 200, 200, " health remaining)")

        local r,g,b,a = ui.get(current_color)
        new_notify(weapon_to_verb[e.weapon].." \a"..rgba_to_hex(r,g,b,a)..target_name.."\aFFFFFFFF for".." \a"..rgba_to_hex(r,g,b,a)..e.dmg_health.."\aFFFFFFFF damage (".."\a"..rgba_to_hex(r,g,b,a)..e.health.."\aFFFFFFFF)", r,g,b,a)
	end
end)

client.set_event_callback('shutdown', function()
    ui.set_visible(reference.aa_enable, true)
    ui.set_visible(reference.pitch[1], true)
    ui.set_visible(reference.yaw_base, true)
    ui.set_visible(reference.yaw[1], true)
    ui.set_visible(reference.body_yaw[1], true)
    ui.set_visible(reference.edge_yaw, true)
    ui.set_visible(reference.freestanding[1], true)
    ui.set_visible(reference.freestanding[2], true)
    ui.set_visible(reference.roll, true)

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

client.set_event_callback("paint_ui", function()
    local r,g,b,a = ui.get(current_color)

    color_r = r
    color_g = g
    color_b = b
    color_a = a


    ui.set(text1, text_fade_animation(3, r,g,b,a, "stardust   .lua"))
    ui.set(text2, text_fade_animation(3, r,g,b,a, "- "..string.lower(celestia.username)))
    ui.set(text3, text_fade_animation(3, r,g,b,a, "- "..string.lower(celestia.build)))

    ctx.notify.render()
end)

client.set_event_callback("paint", function()
    --ctx.defensive_ind.render()
    ctx.arrows.render()
end)

local defensive1 = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Force Defensive')
client.set_event_callback("setup_command", function(cmd)
if ui.get(defensive1) then
  cmd.force_defensive = true
  end
end)