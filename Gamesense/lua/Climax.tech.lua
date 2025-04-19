--powered by Bingice#6563
require 'bit'
local ffi = require("ffi")
local vector = require('vector')
local images = require 'gamesense/images'
local base64 = require("gamesense/base64") or error("download base64 from workshop")
local clipboard = require("gamesense/clipboard") or error("download clipboard from workshop")
local client_userid_to_entindex, client_set_event_callback, client_screen_size, client_trace_bullet, client_unset_event_callback, client_color_log, client_camera_position, client_create_interface, client_random_int, client_latency, client_find_signature, client_delay_call, client_trace_line, client_register_esp_flag, client_exec, client_key_state, client_set_cvar, client_unix_time, client_error_log, client_draw_debug_text, client_update_player_list, client_camera_angles, client_eye_position, client_draw_hitboxes, client_random_float, entity_get_local_player, entity_is_enemy, entity_get_all, entity_set_prop, entity_is_alive, entity_get_steam64, entity_get_classname, entity_get_player_resource, entity_is_dormant, entity_get_player_name, entity_get_origin, entity_hitbox_position, entity_get_player_weapon, entity_get_players, entity_get_prop, globals_absoluteframetime, globals_chokedcommands, globals_oldcommandack, globals_tickcount, globals_commandack, globals_lastoutgoingcommand, globals_curtime, globals_tickinterval, globals_framecount, globals_frametime, ui_new_slider, ui_new_combobox, ui_reference, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_new_checkbox, ui_new_multiselect, ui_new_hotkey, ui_set, ui_set_callback, ui_new_button, ui_new_label, ui_get, renderer_world_to_screen, renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_triangle, renderer_measure_text, renderer_indicator, math_atan2, math_rad, math_ceil, math_tan, math_cos, math_sinh, math_random, math_huge, math_pi, math_max, math_floor, math_sqrt, math_deg, math_atan, math_pow, math_abs, math_min, math_sin, math_log, table_concat, string_format, string_byte, string_char, bit_band, panorama_loadstring, panorama_open = 
    client.userid_to_entindex, client.set_event_callback, client.screen_size, client.trace_bullet, client.unset_event_callback, client.color_log, client.camera_position, client.create_interface, client.random_int, client.latency, client.find_signature, client.delay_call, client.trace_line, client.register_esp_flag, client.exec, client.key_state, client.set_cvar, client.unix_time, client.error_log, client.draw_debug_text, client.update_player_list, client.camera_angles, client.eye_position, client.draw_hitboxes, client.random_float, entity.get_local_player, entity.is_enemy, entity.get_all, entity.set_prop, entity.is_alive, entity.get_steam64, entity.get_classname, entity.get_player_resource, entity.is_dormant, entity.get_player_name, entity.get_origin, entity.hitbox_position, entity.get_player_weapon, entity.get_players, entity.get_prop, globals.absoluteframetime, globals.chokedcommands, globals.oldcommandack, globals.tickcount, globals.commandack, globals.lastoutgoingcommand, globals.curtime, globals.tickinterval, globals.framecount, globals.frametime, ui.new_slider, ui.new_combobox, ui.reference, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.new_checkbox, ui.new_multiselect, ui.new_hotkey, ui.set, ui.set_callback, ui.new_button, ui.new_label, ui.get, renderer.world_to_screen, renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.triangle, renderer.measure_text, renderer.indicator, math.atan2, math.rad, math.ceil, math.tan, math.cos, math.sinh, math.random, math.huge, math.pi, math.max, math.floor, math.sqrt, math.deg, math.atan, math.pow, math.abs, math.min, math.sin, math.log, table.concat, string.format, string.byte, string.char, bit.band, panorama.loadstring, panorama.open
local globals_realtime = globals.realtime
local dependencies = {
    ["gamesense/csgo_weapons"] = "https://gamesense.pub/forums/viewtopic.php?id=18807"
}
local missing_libs = { }
local gamerules_ptr = client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")
local gamerules = ffi.cast("intptr_t**", ffi.cast("intptr_t", gamerules_ptr) + 2)[0]
for i, v in pairs(dependencies) do
    if not pcall(require, i) then
        missing_libs[#missing_libs + 1] = dependencies[i]
    end
end

for i=1, #missing_libs do
    error("Please subscribe to the following libraries! \n" .. table_concat(missing_libs, ", \n"))
end

--required csgo lib[Bingice#6563]
local base64 = require("gamesense/base64")
local antiaim_funcs = require("gamesense/antiaim_funcs")
local csgo_weapons = require("gamesense/csgo_weapons")

--references[Bingice#6563]
local refs = {
    dt = { ui_reference("RAGE", "Other", "Double tap") },
    pitch = ui_reference("AA", "Anti-aimbot angles", "pitch"),
    yaw = { ui_reference("AA", "Anti-aimbot angles", "Yaw") },
    yaw_base = { ui_reference("AA", "Anti-aimbot angles", "Yaw base") },
    yawj = { ui_reference("AA", "Anti-aimbot angles", "Yaw jitter") },
    bodyyaw = { ui_reference("AA", "Anti-aimbot angles", "Body yaw") },
    fs = { ui_reference("AA", "Anti-aimbot angles", "Freestanding") },
    slowwalk = { ui_reference("AA", "Other", "Slow motion") },
    leg_movement = ui_reference("AA", "Other", "Leg movement"),
    hs = { ui_reference("AA", "Other", "On shot anti-aim") },
    edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    fd = ui_reference("RAGE", "Other", "Duck peek assist"),
    pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
    ping_spike = { ui.reference('MISC', 'Miscellaneous', 'Ping spike') },
    yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    fs_bodyyaw = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    fakelimit = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
    roll = ui_reference("AA", "Anti-aimbot angles", "Roll"),
    fakelag = ui.reference("AA", "Fake lag", "Limit"),
    antiuntrusted = ui.reference("Misc", "Settings", "Anti-untrusted"),
    ref_force_bodyaim = ui.reference("RAGE", "Other", "Force body aim"),
    sp_key = ui_reference("RAGE", "Aimbot", "Force safe point"),
}

local bind_systeam = {
	left = false,
	right = false,
	back = false,
}

local vars = {
    state_to_idx = {["Stand"]=1, ["Move"]=2, ["Crouch"]=3, ["Slowwalk"]=4, ["Air"]=5,},
    player_states = {"Stand", "Move", "Crouch", "Slowwalk", "Air"},
    active_i = 1,
    p_state = 0,
    yaw_status = "default",
    best_enemy = nil,
    best_angle = 0,
    indexed_angle = 0,
    misses = { },
    last_miss = 0,
    steamid = panorama.loadstring([[
	return MyPersonaAPI.GetXuid()
    ]])()
}

local anti_aim = { }
local ground_ticks, end_time = 1, 0
local current_tag = 1
local current_time = 0

--menu design[Bingice#6563]"  

local master_switch = ui_new_checkbox("AA", "Anti-aimbot angles", "\aFF881BFF> Master switch \a00FFFFFF-Bingice AA")
local element_type = ui_new_combobox("AA", "Anti-aimbot angles", "\aFF881BFF[+]Group element", {"Anti-aim", "Visuals", "Misc"})
lab2 = ui.new_label("AA", "anti-aimbot angles", "\aFF881BFFBingiceQQ:\aFFFFFFFF359492464")
local items = {
    --aa
    anti_aim = ui_new_checkbox("AA", "Anti-aimbot angles", "\aFF881BFF>Enable \aFFFFFFFFAntiAim-Function module"),
    manual_left_dir = ui_new_hotkey("AA", "anti-aimbot angles", "\aFF881BFF>Force \aFFFFFFFFmanual left"),
    manual_right_dir = ui_new_hotkey("AA", "anti-aimbot angles","\aFF881BFF>Force \aFFFFFFFFmanual right"),
    manual_backward_dir = ui_new_hotkey("AA", "anti-aimbot angles","\aFF881BFF>Force \aFFFFFFFFmanual reset"),
    manual_state = ui_new_slider("AA", "anti-aimbot angles","\n",0,3,0),
    fs_mode = ui_new_combobox("AA", "Anti-aimbot angles", "\aFF881BFF[+]Body \aFFFFFFFFyaw freestand", "Default", "Reversed", "Bullet freestand bodyyaw"),
    abf = ui_new_multiselect("AA", "Anti-aimbot angles", "\aFF881BFF[+]Anti-\aFFFFFFFFbruteforce", "Flip if miss", "Flip if hit"),
    roll_inverter = ui_new_hotkey("AA", "anti-aimbot angles","\aFF881BFF>Force \aFFFFFFFFroll inverter"),
    --misc
    break_leg_anims = ui_new_checkbox("AA", "Anti-aimbot angles", "Break leg animations"),
    legzy = ui.new_checkbox("AA", "Anti-aimbot angles", "Jitter legs"),
    sliderint = ui.new_slider("AA", "Anti-aimbot angles", "Value", 1, 10, 4),
    enable_leg = ui.new_checkbox("AA", "Anti-aimbot angles", "Static legs in air"),
    fake_up = ui_new_checkbox("AA", "Anti-aimbot angles", "Fake up on land"),
	anti_knife = ui_new_checkbox("AA", "Anti-aimbot angles", "Anti-knife"),
    --indicators
    indicator = ui_new_checkbox("AA", "Anti-aimbot angles", "\aFF00FFFE Enable indicators"),
    indicator_mode = ui_new_combobox("AA", "Anti-aimbot angles", "\aFF00FFFE Indicator mode", "Default", "2"),
    color_a = ui.new_color_picker("AA", "Anti-aimbot angles", "color A", 22, 165, 229, 85),
    color_b = ui.new_color_picker("AA", "Anti-aimbot angles", "color B", 255, 255, 255, 255),
    arrows_mode = ui_new_combobox("AA", "Anti-aimbot angles", "\aFF00FFFE Arrows mode", "Default", "C"),
    color_cir = ui.new_color_picker("AA", "Anti-aimbot angles", "Circular arrow color", 255, 255, 255, 255),
    clr_size = ui.new_slider("AA", "Anti-aimbot angles", "Circular arrow size location", 8, 14, 10),
    left_indicator = ui_new_checkbox("AA", "Anti-aimbot angles", "\aFF00FFFE Enable left antiaim panel"),
    watermark = ui_new_checkbox("AA", "Anti-aimbot angles", "\aFF00FFFE Watermark"),
    watermark_cir = ui.new_color_picker("AA", "Anti-aimbot angles", "Watermark color", 255, 255, 255, 255),
    watermark_cir_ex = ui.new_color_picker("AA", "Anti-aimbot angles", "Watermark ex color", 0, 255, 255, 255),
}

ui.set(refs.antiuntrusted, true)
local conditions = ui_new_combobox("AA","Anti-aimbot angles","\aFF881BFF[+]Custom \aFFFFFFFF>state select", vars.player_states)


for i=1, 5 do
    anti_aim[i] = {
		pitch = ui_new_combobox("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."]\aFFFFFFFF >Pitch \a00FFFFFF[Anti-target state]" , { "Off", "Default", "Up", "Down", "Minimal", "Random" }),
		yawbase = ui_new_combobox("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Yaw base \a00FFFFFF[Back options]", { "Local view", "At targets" }),
		yaw = ui_new_combobox("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Yaw \a00FFFFFF[Angle]", { "Off", "180", "Spin", "Static", "180 Z", "Crosshair" }),
		yawadd = ui_new_slider("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Yaw add\a00FFFFFF[definition]", -180, 180, 0),
		yawadd_right = ui_new_slider("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Yaw add right\a00FFFFFF[definition]", -180, 180, 0),
		yawjitter = ui_new_combobox("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Yaw jitter\a00FFFFFF[definition]", { "Off", "Offset", "Center", "Random" }),
		yawjitteradd = ui_new_slider("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Yaw jitter add\a00FFFFFF[definition]", -180, 180, 0),
		yawjitteradd_right = ui_new_slider("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Yaw jitter add right\a00FFFFFF[definition]", -180, 180, 0),
		bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Body yaw\a00FFFFFF[definition]", { "Off", "Opposite", "Jitter", "Static"}),
		bodyyaw_settings = ui_new_slider("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Body yaw add\a00FFFFFF[definition]", 0, 180, 0),
		bodyyaw_extended = ui_new_combobox("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Body yaw extended\a00FFFFFF[definition]", { "Off", "Random", "Jitter", "Tickcount inverter"}),
		bodyyaw_extended_add = ui_new_slider("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Body yaw extended add\a00FFFFFF[definition]", 0, 180, 0),
		fakeyawlimit = ui_new_slider("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Fake yaw limit\a00FFFFFF[definition]", 0, 60, 60),
		fakeyawlimit_right = ui_new_slider("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Fake yaw limit right\a00FFFFFF[definition]", 0, 60, 60),
		fakeyawlimit_extended = ui_new_combobox("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Fake yaw extended\a00FFFFFF[definition]", { "Off", "Random", "Jitter", "Tickcount inverter"}),
		fakeyawlimit_extended_add = ui_new_slider("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Fake yaw extended add\a00FFFFFF[definition]", 0, 60, 60),
		roll_ext = ui_new_checkbox("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Exteneded angle\a00FFFFFF[Roll VAC]"),
		roll_extended_limit = ui_new_slider("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Extended anlge\a00FFFFFF[Roll VAC]", - 180, 180, 0),
		roll_extended_limit_r = ui_new_slider("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Extended anlge right\a00FFFFFF[Roll VAC]", - 180, 180, 0),
		roll_extended_extra = ui_new_combobox("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Extended anlge extra\a00FFFFFF[Roll VAC]", { "Off", "Random", "Jitter", "Tickcount inverter"}),
		roll_extended_limit_extra = ui_new_slider("AA", "Anti-aimbot angles", "\aFF881BFF[+]["..vars.player_states[i].."] \aFFFFFFFF>Extended anlge extra add\a00FFFFFF[Roll VAC]", - 180, 180, 0),
	}
end

local get_config_package = function()
	local packages = {}
	for idx, element in pairs(anti_aim) do
		for key, data in pairs(element) do
			packages[("%s %s"):format(idx, key)] = data
		end
	end

	return packages
end

local export = function()
	local configs = {}
	local elements = get_config_package()
	for key, data in pairs(elements) do
		configs[key] = ui.get(data)
	end

	clipboard.set(base64.encode(json.stringify(configs)))
end

local import = function()
	local elements = get_config_package()
	local config = json.parse(base64.decode(clipboard.get()))
	for key, data in pairs(elements) do
		if config[key] ~= nil then
			ui.set(data, config[key])
		end
	end
end

items.import = ui.new_button("AA", "Other", "\aFF00FFFE Import from clipboard", import)
items.export = ui.new_button("AA", "Other", "\aFF00FFFE Export to clipboard", export)

--functional variables[Bingice#6563]
local includes = function(table, value)
    for _, v in ipairs(ui_get(table)) do
        if v == value then return true end
    end
    return false
end

function bind_systeam:updata()

    ui.set(items.manual_left_dir,"On hotkey")
	ui.set(items.manual_right_dir,"On hotkey")
	ui.set(items.manual_backward_dir,"On hotkey")
	
	m_state = ui.get(items.manual_state)
	
	left_state,right_state,backward_state = 
	ui.get(items.manual_left_dir),
	ui.get(items.manual_right_dir), 
	ui.get(items.manual_backward_dir)

	if left_state == self.left and
		right_state == self.right and
		backward_state == self.back then
		return
	end
	
	self.left,self.right,self.back =
		left_state,
		right_state,
		backward_state

	if (left_state and m_state == 1) or (right_state and m_state == 2)  then
		ui.set(items.manual_state, 0)
		return
	end

	if left_state and m_state ~= 1 then
		ui.set(items.manual_state,1)
	end
	if right_state and m_state ~= 2 then  
		ui.set(items.manual_state,2)
	end
	if backward_state and m_state ~= 0 then
		ui.set(items.manual_state,0)
	end
end

local vec_3 = function(_x, _y, _z) 
	return { x = _x or 0, y = _y or 0, z = _z or 0 } 
end

local function vec_dist(current, target)
    local len = vec_3(target.x - current.x, target.y - current.y, target.z - current.z)
    return math_sqrt(len.x * len.x + len.y * len.y + len.z * len.z)
end


local function ang_on_screen(x, y)
    if x == 0 and y == 0 then
        return 0
    end
    return math_deg(math_atan2(y, x))
end


local function normalize_yaw(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end

local function calc_angle(local_x, local_y, enemy_x, enemy_y)
    if local_x == nil or local_y == nil or enemy_x == nil or enemy_y == nil then return 0 end
	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math.atan( ydelta / xdelta )
	relativeyaw = normalize_yaw( relativeyaw * 180 / math.pi )
	if xdelta >= 0 then
		relativeyaw = normalize_yaw(relativeyaw + 180)
	end
	return relativeyaw
end

local function angle_vector(angle_x, angle_y)
	local sy, cy = math_sin(math_rad(angle_y)), math_cos(math_rad(angle_y))
    local sp, cp = math_sin(math_rad(angle_x)), math_cos(math_rad(angle_x))
	return cp * cy, cp * sy, -sp
end

local function rotate_point(x, y, rot, size)
	return math_cos(math_rad(rot)) * size + x, math_sin(math_rad(rot)) * size + y
end

local function renderer_arrow(x, y, r, g, b, a, rotation, size)
	local x0, y0 = rotate_point(x, y, rotation, 45)
	local x1, y1 = rotate_point(x, y, rotation + (size / 3.5), 45 - (size / 4))
	local x2, y2 = rotate_point(x, y, rotation - (size / 3.5), 45 - (size / 4))
	renderer_triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
end

local function in_air(player)
	local flags = entity.get_prop(player, "m_fFlags")	
	if bit.band(flags, 1) == 0 then
		return true
	end	
	return false
end

local function is_crouching(player)
	local flags = entity.get_prop(player, "m_fFlags")
	if bit.band(flags, 4) == 4 then
		return true
	end	
	return false
end

local build_tag = function(tag)
    local ret = {''}
    for i = 1, #tag do
      table.insert(ret, tag:sub(1, i))
    end
    for i = #ret - 1, 1, -1 do
      table.insert(ret, ret[i])
    end
    return ret
end

local function get_best_enemy()
    -- We store the best target in a global variable so we don't have to re run the calculations every time we want to find the best target.
    vars.best_enemy = nil

    local enemies = entity_get_players(true)
    local best_fov = 180

    local lx, ly, lz = client_eye_position()
    local view_x, view_y, roll = client_camera_angles()
    
    for i=1, #enemies do
        local cur_x, cur_y, cur_z = entity_get_prop(enemies[i], "m_vecOrigin")
        local cur_fov = math.abs(normalize_yaw(ang_on_screen(lx - cur_x, ly - cur_y) - view_y + 180))
        if cur_fov < best_fov then
            best_fov = cur_fov
            best_enemy = enemies[i]
        end
    end
end

local function get_damage(me, enemy, x, y,z)
    local ex = { }
    local ey = { }
    local ez = { }
    ex[0], ey[0], ez[0] = entity_hitbox_position(enemy, 1)
    if ex[0] == nil or ey[0] == nil or ez[0] == nil then return 0 end
    ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
    ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
    ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
    ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
    ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
    ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
    local bestdamage = 0
    local bent = nil
    for i=0, 6 do
        local ent, damage = client_trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
        if damage > bestdamage then
            bent = ent
            bestdamage = damage
        end
    end
    return bent == nil and client.scale_damage(me, 1, bestdamage) or bestdamage
end

local data = {side = 1, last_side = 0, last_hit = 0, hit_side = 0}
local calculate_freestand = function()
	local x, y, z = client.eye_position()
	local curt_times = globals.curtime()
	local _, yaw = client.camera_angles()
	local trace_data = {left = 0, right = 0}
	if data.hit_side ~= 0 and curt_times - data.last_hit > 5 then
		data.last_hit = 0
		data.hit_side = 0
		data.last_side = 0
	end

	for i = yaw - 90, yaw + 90, 30 do
		if i ~= yaw then
			local rad = math.rad(i)
			local side = i < yaw and "left" or "right"
			local px, py, pz = x + 256 * math.cos(rad), y + 256 * math.sin(rad), z
			local fraction = client.trace_line(entity.get_local_player(), x, y, z, px, py, pz)
			trace_data[side] = trace_data[side] + fraction
		end
	end

	return trace_data.left > trace_data.right and 1 or 2
end

client.set_event_callback("weapon_fire", function(e)
	local local_player_userid = client.userid_to_entindex(e.attacker)
	if local_player_userid == entity.get_local_player() then
		data.last_side = 0
		data.hit_side = data.side
		data.last_hit = globals.curtime()
	end
end)

local function get_best_angle()
    -- Since we run this from run_command no need to check if we are alive or anything.
    local me = entity_get_local_player()

    vars.best_angle = 0

    if not me or not ui_get(items.anti_aim) and ui.get(master_switch) then return end

    if best_enemy == nil then return end

    local lx, ly, lz = client_eye_position()
    local view_x, view_y, roll = client_camera_angles()
    
    local e_x, e_y, e_z = entity_hitbox_position(best_enemy, 0)

    local yaw = calc_angle(lx, ly, e_x, e_y)
    local rdir_x, rdir_y, rdir_z = angle_vector(0, (yaw + 90))
    local rend_x = lx + rdir_x * 15
    local rend_y = ly + rdir_y * 15
            
    local ldir_x, ldir_y, ldir_z = angle_vector(0, (yaw - 90))
    local lend_x = lx + ldir_x * 15
    local lend_y = ly + ldir_y * 15
            
    local r2dir_x, r2dir_y, r2dir_z = angle_vector(0, (yaw + 90))
    local r2end_x = lx + r2dir_x * 100
    local r2end_y = ly + r2dir_y * 100

    local l2dir_x, l2dir_y, l2dir_z = angle_vector(0, (yaw - 90))
    local l2end_x = lx + l2dir_x * 100
    local l2end_y = ly + l2dir_y * 100      
            
    local ldamage = get_damage(me, best_enemy, rend_x, rend_y, lz)
    local rdamage = get_damage(me, best_enemy, lend_x, lend_y, lz)

    local l2damage = get_damage(me, best_enemy, r2end_x, r2end_y, lz)
    local r2damage = get_damage(me, best_enemy, l2end_x, l2end_y, lz)

    if l2damage > r2damage or ldamage > rdamage then
        vars.best_angle = ui_get(items.fs_mode) == "Default" and 1 or 2
    elseif r2damage > l2damage or rdamage > ldamage then
        vars.best_angle = ui_get(items.fs_mode) == "Default" and 2 or 1
    end

    if ui_get(items.fs_mode) == "Bullet freestand bodyyaw" then
        vars.best_angle = calculate_freestand()
    end
end

local function stop_micromove(cmd)
    if (math.abs(cmd.forwardmove) > 1) or (math.abs(cmd.sidemove) > 1) or cmd.in_jump == 1 then
        return
    end

    local desync_amount = antiaim_funcs.get_desync(2)
    if desync_amount == nil then
        return
    end

        if math.abs(desync_amount) < 15 or cmd.chokedcommands == 0 then
            return
        end

    if (entity.get_prop(entity.get_local_player(), "m_MoveType") or 0) == 9 then --ladder fix
        return
    end

    ui.set(refs.fakelimit, 60)
    cmd.forwardmove = 0.000000000000000000000000000000001 --ez gains
    cmd.in_forward = 1
end

local function miss_detection(e)
    local me, shooter = entity_get_local_player(), client_userid_to_entindex(e.userid)

    if not ui_get(items.anti_aim) or not entity_is_alive(me) or not entity_is_enemy(shooter) or entity_is_dormant(shooter) or globals_curtime() - vars.last_miss <= 0.005 or not includes(items.abf, "Flip if miss") then
        return
    end

    local enemy_pos = vec_3(get_player_position(shooter))

    for i=1, 19 do
        local local_pos = vec_3(entity_hitbox_position(me, i - 1))
        local dist = ((e.y - enemy_pos.y)*local_pos.x - (e.x - enemy_pos.x)*local_pos.y + e.x*enemy_pos.y - e.y*enemy_pos.x) / math_sqrt((e.y-enemy_pos.y)^2 + (e.x - enemy_pos.x)^2)

        if math_abs(dist) <= 35 then
            vars.last_miss = globals_curtime()
            if vars.misses[shooter] ~= nil and vars.misses[shooter] >= 2 then
                vars.misses[shooter] = nil
            else
                vars.misses[shooter] = vars.misses[shooter] == nil and 1 or vars.misses[shooter] + 1
            end
            return
        elseif math_abs(dist) > 250 then
            return
        end
    end
end

client.set_event_callback('player_hurt', function(e)
    if e == nil or not includes(items.abf, "Flip if hit") then
        return
    end
    
    local shooter = client.userid_to_entindex(e.attacker)
	local target = client.userid_to_entindex(e.userid)
	if target ~= entity.get_local_player() then
		return
	end

    vars.misses[shooter] = vars.misses[shooter] == nil and 1 or vars.misses[shooter] + 1
end)

local function anti_aim_on_use(e)
    if e.in_use == 1 then
        if entity_get_classname(entity_get_player_weapon(entity_get_local_player())) == "CC4" then return end
        if e.in_attack == 1 then
            e.in_use = 1
        end
    
        if e.chokedcommands == 0 then
            e.in_use = 0
        end
    end
end


local function doubletap_charged()
    if not ui_get(refs.dt[1]) or not ui_get(refs.dt[2]) or ui_get(refs.fd) then return false end
    if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then return end
    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if weapon == nil then return false end
    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
	local jewfag = entity.get_prop(weapon, "m_flNextPrimaryAttack")
	if jewfag == nil then return end
    local next_primary_attack = jewfag + 0.5
    if next_attack == nil or next_primary_attack == nil then return false end
    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
end

local function aa_main()
    bind_systeam:updata()

    local me = entity.get_local_player()
    local on_ground = (bit.band(entity.get_prop(entity_get_local_player(), 'm_fFlags'), 1) == 1)
	local vx, vy, vz = entity_get_prop(me, "m_vecVelocity")
	local p_still = math_sqrt(vx ^ 2 + vy ^ 2) < 2 

    if not ui_get(items.anti_aim) and ui_get(master_switch) then
        return
    end

    if not on_ground then
        vars.p_state = 5
        vars.yaw_status = "air"
    elseif is_crouching(me) and not in_air(me) then
        vars.p_state = 3
        vars.yaw_status = "crouch"
    else
        if ui_get(refs.slowwalk[1]) and ui_get(refs.slowwalk[2]) then
            vars.p_state = 4
            vars.yaw_status = "slowwalk"
        else
            if p_still then
                vars.p_state = 1
                vars.yaw_status = "stand"
            elseif not p_still then
                vars.p_state = 2
                vars.yaw_status = "move"
            end
        end
    end
end

ffi.cdef[[
	struct cusercmd
	{
		struct cusercmd (*cusercmd)();
		int     command_number;
		int     tick_count;
		Vector m_view_angles;
	};
	typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
]]

local is_switcher = false
local signature_ginput = base64.decode("uczMzMyLQDj/0ITAD4U=")
local match = client.find_signature("client.dll", signature_ginput) or error("sig1 not found")
local g_input = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("match is nil")
local g_inputclass = ffi.cast("void***", g_input)
local g_inputvtbl = g_inputclass[0]
local rawgetusercmd = g_inputvtbl[8]
local get_user_cmd = ffi.cast("get_user_cmd_t", rawgetusercmd)
local function set_data(cmd)
    if cmd.chokedcommands == 0 then
	is_switcher = not is_switcher
    end

    local m_cmd = get_user_cmd(g_inputclass, 0, cmd.command_number)
    if ui_get(items.anti_aim) and ui_get(master_switch) then
        local is_inverter = ui.get(refs.bodyyaw[2]) > 0
        ui.set(refs.pitch, ui.get(anti_aim[vars.p_state].pitch))
        ui.set(refs.yaw[1], ui.get(anti_aim[vars.p_state].yaw))
        if ui_get(items.manual_state) == 1 then
            ui.set(refs.yaw_base, "Local view")
            ui.set(refs.yaw[2], -90)
        elseif ui_get(items.manual_state) == 2 then
            ui.set(refs.yaw_base, "Local view")
            ui.set(refs.yaw[2], 90)
        elseif ui_get(items.manual_state) == 0 then
            ui.set(refs.yaw_base, ui.get(anti_aim[vars.p_state].yawbase))
            ui.set(refs.yaw[2], ui.get(is_inverter and anti_aim[vars.p_state].yawadd_right or anti_aim[vars.p_state].yawadd))
        end
        ui.set(refs.yawj[1], ui.get(anti_aim[vars.p_state].yawjitter))
        ui.set(refs.yawj[2], ui.get(is_inverter and anti_aim[vars.p_state].yawjitteradd_right or anti_aim[vars.p_state].yawjitteradd))
        ui.set(refs.bodyyaw[1], ui.get(anti_aim[vars.p_state].bodyyaw))
        local bodyyaw_add = ui.get(anti_aim[vars.p_state].bodyyaw_settings)
        if ui.get(anti_aim[vars.p_state].bodyyaw_extended) == "Random" then
	bodyyaw_add = math.random(bodyyaw_add, ui.get(anti_aim[vars.p_state].bodyyaw_extended_add))
        elseif ui.get(anti_aim[vars.p_state].bodyyaw_extended) == "Jitter" then
	bodyyaw_add = is_switcher and bodyyaw_add or ui.get(anti_aim[vars.p_state].bodyyaw_extended_add)
        elseif ui.get(anti_aim[vars.p_state].bodyyaw_extended) == "Tickcount inverter" then
	bodyyaw_add = globals.tickcount() % 2 == 0 and bodyyaw_add or ui.get(anti_aim[vars.p_state].bodyyaw_extended_add)
        end

        local fakelimit = ui.get(is_inverter and anti_aim[vars.p_state].fakeyawlimit_right or anti_aim[vars.p_state].fakeyawlimit)
        if ui.get(anti_aim[vars.p_state].fakeyawlimit_extended) == "Random" then
	fakelimit = math.random(fakelimit, ui.get(anti_aim[vars.p_state].fakeyawlimit_extended_add))
        elseif ui.get(anti_aim[vars.p_state].fakeyawlimit_extended) == "Jitter" then
	fakelimit = is_switcher and fakelimit or ui.get(anti_aim[vars.p_state].fakeyawlimit_extended_add)
        elseif ui.get(anti_aim[vars.p_state].fakeyawlimit_extended) == "Tickcount inverter" then
	fakelimit = globals.tickcount() % 2 == 0 and fakelimit or ui.get(anti_aim[vars.p_state].fakeyawlimit_extended_add)
        end

        if vars.best_angle == 1 or vars.indexed_angle == 1 then
            if vars.misses[vars.best_enemy] == nil then 
                ui.set(refs.bodyyaw[2], - bodyyaw_add)
            else
                ui.set(refs.bodyyaw[2], bodyyaw_add)
            end
        elseif vars.best_angle == 2 or vars.indexed_angle == 2 then
            if vars.misses[vars.best_enemy] == nil or vars.misses[vars.best_enemy] == 2 then
                ui.set(refs.bodyyaw[2], bodyyaw_add)
            else
                ui.set(refs.bodyyaw[2], - bodyyaw_add)
            end
        end

        ui.set(refs.fs_bodyyaw, false)
        ui.set(refs.fakelimit, fakelimit)
        if ui.get(anti_aim[vars.p_state].roll_ext) then
	ui.set(refs.roll, 50)
                ui.set(refs.bodyyaw[2], 180)
	local default_roll = ui.get(ui.get(items.roll_inverter) and anti_aim[vars.p_state].roll_extended_limit_r or anti_aim[vars.p_state].roll_extended_limit)
	if ui.get(anti_aim[vars.p_state].roll_extended_extra) == "Random" then
		default_roll = math.random(default_roll, ui.get(anti_aim[vars.p_state].roll_extended_limit_extra))
	elseif ui.get(anti_aim[vars.p_state].roll_extended_extra) == "Jitter" then
		default_roll = is_switcher and default_roll or ui.get(anti_aim[vars.p_state].roll_extended_limit_extra)
	elseif ui.get(anti_aim[vars.p_state].roll_extended_extra) == "Tickcount inverter" then
		default_roll = globals.tickcount() % 2 == 0 and default_roll or ui.get(anti_aim[vars.p_state].roll_extended_limit_extra)
	end

	cmd.roll = default_roll
	local is_valve_ds = ffi.cast("bool*", gamerules[0] + 124)
	if is_valve_ds ~= nil then
		is_valve_ds[0] = 0
		ui.set(refs.antiuntrusted, false)
	end

	stop_micromove(cmd)
        else
	ui.set(refs.roll, 0)
        end
    end
end

local antiuntrusted = function()
	ui.set(refs.antiuntrusted, true)
end

local function hsv_to_rgb(h, s, v, a)
    local r, g, b
    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    return r * 255, g * 255, b * 255, a * 255
end

local function func_rgb_rainbowize(frequency, rgb_split_ratio)
    local r, g, b, a = hsv_to_rgb(globals.realtime() * frequency, 1, 1, 1)
    r = r * rgb_split_ratio
    g = g * rgb_split_ratio
    b = b * rgb_split_ratio
    return r, g, b
end

local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
	local output = ''

	local len = #text-1

	local rinc = (r2 - r1) / len
	local ginc = (g2 - g1) / len
	local binc = (b2 - b1) / len
	local ainc = (a2 - a1) / len

	for i=1, len+1 do
		output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))

		r1 = r1 + rinc

		g1 = g1 + ginc
		b1 = b1 + binc
		a1 = a1 + ainc
	end

	return output
end

local lerp = function(start, vend, time)
    return start + (vend - start) * time
end

    local ani = {
        dt = 0,
        onshot = 0,
        fd = 0,
        fs = 0,
        baim = 0,
        ping = 0,
        sp = 0,
        s = 0,
        xx = 0,
        x1 =0,
        x2 = 0,
        x3 = 0,
        x4 = 0,
        x5 = 0,
        x6 = 0,
        x7 = 0,
        y1 = 0,
        y2 = 0,
        y3 = 0,
        y4 = 0,
        y5 = 0,
        y6 = 0,
        y7 = 0,
        yy1 = 0,
        yy2 = 0,
        yy3 = 0,
        yy4 = 0,
        yy5 = 0,
        yy6 = 0,
        yy7 = 0,
        fs_alpha = 0,
        dt_alpha = 0,
        hide_alpha = 0,
        baim_alpha = 0,
        duck_alpha = 0,
        ping_alpha = 0,
        sp_alpha = 0,
        glow = 0,
        glow2 = 0,
    }

local classptr = ffi.typeof('void***')
local rawivengineclient = client.create_interface('engine.dll', 'VEngineClient014') or error('VEngineClient014 wasnt found', 2)
local ivengineclient = ffi.cast(classptr, rawivengineclient) or error('rawivengineclient is nil', 2)
local is_in_game = ffi.cast('bool(__thiscall*)(void*)', ivengineclient[0][26]) or error('is_in_game is nil')
local function draw_crosshair_indicators()
    if ui.get(master_switch) then
        local w, h = client_screen_size()
        local plocal = entity_get_local_player()
        local h_index = 0
        local color_a = {ui.get(items.color_a)}
        local realtime = globals_realtime() % 3
        local alpha = math.floor(math.sin(realtime * 4) * (255/2-1) + 255/2) or 255
        local body = math.min(57, entity.get_prop(plocal, "m_flPoseParameter", 11)*120-60)
        local r, g, b = func_rgb_rainbowize(0.01, 1)
        local e_pose_param = math.min(57, entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60)

        local LUA_tag = build_tag("CliMax.yaw")
        if current_time + 0.5 < globals.curtime() then
            current_tag = current_tag + 1
            current_time = globals.curtime()
        end 
        if current_tag == #LUA_tag then
            current_tag = 1
        end
    
        local x, y = client_screen_size() * 0.99, 0
        local u, m, s, ms = client.system_time()
        u = u < 10 and "0"..u or u
        m = m < 10 and "0"..m or m
        s = s < 10 and "0"..s or s
        --[[local text = LUA_tag[current_tag] .. " | time:"..u..":"..m..":"..s.." | Delay: "..math.floor(client.real_latency()*1000).."ms"
        local text_weight, text_height = renderer.measure_text("", text)
        renderer.rectangle(x - text_weight - 6, y + text_height - 4, text_weight + 10, text_height + 6, 15, 15, 15, 115)
        renderer.blur(x - text_weight - 6, y + text_height - 3, text_weight + 12, text_height + 5)
        renderer.text(x - text_weight, y + text_height - 2, 255, 255, 255, 255, "", 0, text)

        renderer.gradient(x - text_weight - 4, y + text_height - 5, text_weight + 4, 1, r, g, b, 255, b, g, r, 255, true)
        renderer.gradient(x - text_weight - 2, y + text_height + 14, text_weight + 4, 1, b, g, r, 255, r, g, b, 255, true)
        renderer.gradient(x - text_weight - 7, y + text_height - 1, 1, text_height, r, g, b, 255, b, g, r, 255, false)
        renderer.gradient(x + 4, y + text_height - 1, 1, text_height, b, g, r, 255, r, g, b, 255, false)

        renderer.circle_outline(x - text_weight - 2, y + text_height, r, g, b, 255, 5, 180, 0.25, 1)
	    renderer.circle_outline(x - text_weight - 2, y + text_height + 10, b, g, r, 255, 5, 90, 0.25, 1)
	    renderer.circle_outline(x, y + text_height + 10, r, g, b, 255, 5, 360, 0.25, 1)
	    renderer.circle_outline(x, y + text_height, b, g, r, 255, 5, 270, 0.25, 1)]]

        if not entity.is_alive(plocal) then
            return
        end

        if ui.get(items.indicator) then
            if ui.get(items.indicator_mode) == "Default" then
               renderer.text(w / 2 + 15 , h / 2 + (h_index * 10) + 30, 255, 255, 255, 255, "-", 0, string.upper("CliMax"))
               renderer.text(w / 2 + 15 + renderer_measure_text("-", string.upper("CliMax  ")) , h / 2 + (h_index * 10) + 30, color_a[1], color_a[2], color_a[3], alpha, "-", 0, "YAW")
               h_index = h_index + 1
               renderer.text(w / 2 + 15 , h / 2 + (h_index * 10) + 30, 100, 100, 255, 255, "-", 0, string.upper(vars.yaw_status))
               renderer.text(w / 2 + 15 + renderer_measure_text("-", string.upper(vars.yaw_status.."  ")) , h / 2 + (h_index * 10) + 30, 255, 255, 255, 255, "-", 0, body > 0 and "LEFT" or "RIGHT")
               h_index = h_index + 1
               if ui.get(refs.dt[1]) and ui.get(refs.dt[2]) then
                  if doubletap_charged() then
                       renderer.text(w / 2 + 15 , h / 2 + (h_index * 10) + 30, 0, 255, 0, 255, "-", 0, "DT")
                   else
                       renderer.text(w / 2 + 15 , h / 2 + (h_index * 10) + 30, 255, 0, 0, 255, "-", 0, "DT")
                   end
                   h_index = h_index + 1
               end
               renderer.text(w / 2 + 15 , h / 2 + (h_index * 10) + 30, 155, 155, 155, 155, "-", 0, 'BAIM')
               renderer.text(w / 2 + 37 , h / 2 + (h_index * 10) + 30, 155, 155, 155, 155, "-", 0, 'FS')
               renderer.text(w / 2 + 50 , h / 2 + (h_index * 10) + 30, 155, 155, 155, 155, "-", 0, 'OS')
            else

    if ui.get(refs.fs[2]) then
        ani.y1 = lerp(ani.y1,10,globals.frametime() * 6)
        ani.yy1 = lerp(ani.yy1,80,globals.frametime() * 6)
        ani.fs_alpha = lerp(ani.fs_alpha,255,globals.frametime() * 6)
    else
        ani.y1 = lerp(ani.y1,0,globals.frametime() * 6)
        ani.yy1 = lerp(ani.yy1,0,globals.frametime() * 6)
        ani.fs_alpha = lerp(ani.fs_alpha,0,globals.frametime() * 6)
    end
    if ui_get(refs.dt[2]) then
        ani.y2 = lerp(ani.y2,10,globals.frametime() * 6)
        ani.yy2 = lerp(ani.yy2,80,globals.frametime() * 6)
        ani.dt_alpha = lerp(ani.dt_alpha,255,globals.frametime() * 6)
    else
        ani.y2 = lerp(ani.y2,0,globals.frametime() * 6)
        ani.yy2 = lerp(ani.yy2,0,globals.frametime() * 6)
        ani.dt_alpha = lerp(ani.dt_alpha,0,globals.frametime() * 6)
    end
    if ui.get(refs.hs[2]) then
        ani.y3 = lerp(ani.y3,10,globals.frametime() * 6)
        ani.yy3 = lerp(ani.yy3,80,globals.frametime() * 6)
        ani.hide_alpha = lerp(ani.hide_alpha,255,globals.frametime() * 6)
    else
        ani.y3 = lerp(ani.y3,0,globals.frametime() * 6)
        ani.yy3 = lerp(ani.yy3,0,globals.frametime() * 6)
        ani.hide_alpha = lerp(ani.hide_alpha,0,globals.frametime() * 6)
    end
    if ui.get(refs.ref_force_bodyaim) then
        ani.y4 = lerp(ani.y4,10,globals.frametime() * 6)
        ani.yy4 = lerp(ani.yy4,80,globals.frametime() * 6)
        ani.baim_alpha = lerp(ani.baim_alpha,255,globals.frametime() * 6)
    else
        ani.y4 = lerp(ani.y4,0,globals.frametime() * 6)
        ani.yy4 = lerp(ani.yy4,0,globals.frametime() * 6)
        ani.baim_alpha = lerp(ani.baim_alpha,0,globals.frametime() * 6)
    end
    if ui.get(refs.fd) then
        ani.y5 = lerp(ani.y5,10,globals.frametime() * 6)
        ani.yy5 = lerp(ani.yy5,80,globals.frametime() * 6)
        ani.duck_alpha = lerp(ani.duck_alpha,255,globals.frametime() * 6)
    else
        ani.y5 = lerp(ani.y5,0,globals.frametime() * 6)
        ani.yy5 = lerp(ani.yy5,0,globals.frametime() * 6)
        ani.duck_alpha = lerp(ani.duck_alpha,0,globals.frametime() * 6)
    end
    if ui.get(refs.ping_spike[1] ) and ui.get( refs.ping_spike[2]) then
        ani.y6 = lerp(ani.y6,10,globals.frametime() * 6)
        ani.yy6 = lerp(ani.yy6,80,globals.frametime() * 6)
        ani.ping_alpha = lerp(ani.ping_alpha,255,globals.frametime() * 6)
    else
        ani.y6 = lerp(ani.y6,0,globals.frametime() * 6)
        ani.yy6 = lerp(ani.yy6,0,globals.frametime() * 6)
        ani.ping_alpha = lerp(ani.ping_alpha,0,globals.frametime() * 6)
    end
    if ui.get(refs.sp_key) then
        ani.y7 = lerp(ani.y7,10,globals.frametime() * 6)
        ani.yy7 = lerp(ani.yy7,80,globals.frametime() * 6)
        ani.sp_alpha = lerp(ani.sp_alpha,255,globals.frametime() * 6)
    else
        ani.y7 = lerp(ani.y7,0,globals.frametime() * 6)
        ani.yy7 = lerp(ani.yy7,0,globals.frametime() * 6)
        ani.sp_alpha = lerp(ani.sp_alpha,0,globals.frametime() * 6)
    end
    local wpn_id = entity.get_prop(entity.get_player_weapon(plocal), "m_iItemDefinitionIndex")
    local is_scoped = entity.get_prop(entity.get_player_weapon(plocal), "m_zoomLevel" )
    local is_grenade =
        ({
        [43] = true,
        [44] = true,
        [45] = true,
        [46] = true,
        [47] = true,
        [48] = true,
        [68] = true
    })[wpn_id] or false
    if is_scoped == nil then is_scoped = 0 end
    if is_scoped >= 1 or is_grenade then
        ani.s = lerp(ani.s, 40,globals.frametime() * 4)
        ani.xx = lerp(ani.xx, 35,globals.frametime() * 4)
        ani.x1 = lerp(ani.x1, 34,globals.frametime() * 4)
        ani.x2 = lerp(ani.x2, 33,globals.frametime() * 4)
        ani.x3 = lerp(ani.x3, 30,globals.frametime() * 4)
        ani.x4 = lerp(ani.x4, 31,globals.frametime() * 4)
        ani.x5 = lerp(ani.x5, 32,globals.frametime() * 4)
        ani.x6 = lerp(ani.x6, 30,globals.frametime() * 4)
        ani.x7 = lerp(ani.x7, 30,globals.frametime() * 4)
        ani.glow = lerp(ani.glow, 0,globals.frametime() * 4)
        ani.glow2 = lerp(ani.glow2, 255,globals.frametime() * 4)
    else
        ani.glow = lerp(ani.glow, 255,globals.frametime() * 4)
        ani.glow2 = lerp(ani.glow2, 0,globals.frametime() * 4)
        ani.s = lerp(ani.s, 0,globals.frametime() * 4)
        ani.xx = lerp(ani.xx, 0,globals.frametime() * 4)
        ani.x1 = lerp(ani.x1, 0,globals.frametime() * 4)
        ani.x2 = lerp(ani.x2, 0,globals.frametime() * 4)
        ani.x3 = lerp(ani.x3, 0,globals.frametime() * 4)
        ani.x4 = lerp(ani.x4, 0,globals.frametime() * 4)
        ani.x5 = lerp(ani.x5, 0,globals.frametime() * 4)
        ani.x6 = lerp(ani.x6, 0,globals.frametime() * 4)
        ani.x7 = lerp(ani.x7, 0,globals.frametime() * 4)
    end

	local alpha = math.floor(math.sin(realtime * 4) * (255/3-1) + 255/2) or 255
    local first_offset = ani.y1
    local second_offset = first_offset + ani.y2
    local thrid_offset = second_offset + ani.y3
    local fourth_offset = thrid_offset + ani.y4
    local fiveth_offset = fourth_offset + ani.y5
    local sixth_offset = fiveth_offset + ani.y6
    local seventh_offset = sixth_offset + ani.y7
            local body = math.min(57, entity.get_prop(plocal, "m_flPoseParameter", 11)*120-60)
    local e_pose_param = math.min(57, entity.get_prop(plocal, "m_flPoseParameter", 11)*120-60)
    local perc = math.abs( e_pose_param )/60
    local dys = math.floor( perc*40 )
        local color_a = {ui.get(items.color_a)}
        local color_b = {ui.get(items.color_b)}
            local logo = gradient_text(color_a[1], color_a[2], color_a[3], 255, color_b[1], color_b[2], color_b[3],  alpha, ("CliMax.tech"))
            renderer.text(w / 2 + ani.s , h / 2 + 30 , 255, 255, 255, 255, "c-", 0, string.upper(logo))
            renderer.text(w / 2  + ani.s , h / 2 + 40 , 255, 255, 255, ani.glow, "c-", 0, body > 0 and "%" or "/", string.upper(""..vars.yaw_status), 0, body > 0 and "%" or "/")
            renderer.rectangle(w / 2 - 12 + ani.xx,h / 2 + 37 , 41, 8, 15, 15, 15, ani.glow2)
            renderer.gradient(w / 2 - 11 + ani.xx,h / 2 + 39 ,math.floor(math.abs(dys)), 4, color_a[1], color_a[2], color_a[3],ani.glow2, color_b[1], color_b[2], color_b[3], ani.glow2,true)
            renderer.text(w / 2 + 38 + ani.xx , h / 2 + 40 , 255, 255, 255, ani.glow2, "c-", 0, string.upper(math.floor(math.abs(dys))).." %")
            renderer.text(w / 2  + ani.x1 , h / 2 + 59 - math_floor(ani.y1) , 220, 220, 220, ani.fs_alpha, "c-", nil, "FREESTAND")
            renderer.text(w / 2  + ani.x2 , h / 2 + 59 - math_floor(ani.y2) + first_offset , 255, 0, 0, ani.dt_alpha, "c-", nil, "READY")
            renderer.text(w / 2  + ani.x3 , h / 2 + 59 - math_floor(ani.y3) + second_offset , 255, 255, 255, ani.hide_alpha, "c-", nil, "HIDE")
            renderer.text(w / 2  + ani.x4 , h / 2 + 59 - math_floor(ani.y4) + thrid_offset , 170, 50, 255, ani.baim_alpha, "c-", nil, "BAIM")
            renderer.text(w / 2  + ani.x5 , h / 2 + 59 - math_floor(ani.y5) + fourth_offset , 80, 80, 255, ani.duck_alpha, "c-", nil, "DUCK")
            renderer.text(w / 2  + ani.x6 , h / 2 + 59 - math_floor(ani.y6) + fiveth_offset , 255, 255, 255, ani.ping_alpha, "c-", nil, "PING")
            renderer.text(w / 2  + ani.x7 , h / 2 + 59 - math_floor(ani.y7) + sixth_offset , 120, 200, 120, ani.sp_alpha, "c-", nil, "SAFE")
            end

            if ui.get(items.arrows_mode) == "C" then
                local crosshair_size_1 = ui.get(items.clr_size)
                local circular_color = {ui.get(items.color_cir)}
                local cam = vector(client_camera_angles())
                local plocal = entity.get_local_player()
                local h = vector(entity_hitbox_position(plocal, "head_0"))
                local p = vector(entity_hitbox_position(plocal, "pelvis"))
                local scrsize_x, scrsize_y = client.screen_size()
                local center_x, center_y = scrsize_x / 2, scrsize_y / 2.003
                local yaw = normalize_yaw(calc_angle(p.x, p.y, h.x, h.y) - cam.y + 120)
                renderer.circle_outline(center_x + 1, center_y, circular_color[1], circular_color[2], circular_color[3], circular_color[4], crosshair_size_1 * 1.833, (yaw * -1) - 15, 0.14, 3.6)
            else
            if ui.get(items.manual_state) == 1 then 
                renderer_text(w / 2 - 55, h / 2 , color_a[1], color_a[2], color_a[3], 255, "cb+", 0, "<")
                renderer_text(w / 2 + 55, h / 2 , 25, 25, 25, 255, "cb+", 0, ">")
            elseif ui.get(items.manual_state) == 2 then
                renderer_text(w / 2 - 55, h / 2 , 25, 25, 25, 255, "cb+", 0, "<")
                renderer_text(w / 2 + 55, h / 2 , color_a[1], color_a[2], color_a[3], 255, "cb+", 0, ">")
            elseif ui.get(items.manual_state) == 0 then
                renderer_text(w / 2 - 55, h / 2 , 25, 25, 25, 255, "cb+", 0, "<")
                renderer_text(w / 2 + 55, h / 2 , 25, 25, 25, 255, "cb+", 0, ">")
            end

            end

            h_index = h_index + 1
            if ui.get(items.watermark) then
	local sys_time = { client.system_time() }
	local actual_time = ('%02d:%02d:%02d'):format(sys_time[1], sys_time[2], sys_time[3])
	local latency = is_in_game(is_in_game) and client.latency()*1000 or 0
	local latency_text = latency > 5 and (' | delay: %dms'):format(latency) or ''
	local text = ("CliMax.Tech | time: %s%s"):format(actual_time, latency_text)
	local r, g, b, a = ui.get(items.watermark_cir)
	local rx, gx, bx, ax = ui.get(items.watermark_cir_ex)
	local h, w = 18, renderer.measure_text(nil, text) + 23
	local wx, y = client.screen_size(), 9
	local x = wx - w - 10
	renderer.gradient(x, y, (w/2)+2, 2, r, g, b, 200, rx, gx, bx, 255, true)
	renderer.gradient(x + w/2+1, y, w-w/2, 2, rx, gx, bx, 255, r, g, b, 200, true)
	renderer.circle_outline(x, y+5, r, g, b, 200, 5, 180, 0.25, 2)
	renderer.circle_outline(x + w, y+5, r, g, b, 200, 5, 270, 0.25, 2)
	renderer.gradient(x-5, y+5, 2, 12, r, g, b, 155, r, g, b, 0, false)
	renderer.gradient(x + w+3, y+5, 2, 12, r, g, b, 155, r, g, b, 0, false)
	local avatar = images.get_steam_avatar(vars.steamid)
	local texture = renderer.load_rgba(avatar.contents, avatar.width, avatar.height)
	renderer.texture(texture, x + 3, y + 4, 13, 13, 255, 255, 255, 255, "f")
	renderer.text(x+18, y + 4, 255, 255, 255, 255, '', 0,text)
            end

            if ui.get(items.left_indicator) then
                renderer_text(15, h / 2 , 255, 255, 255, 255, "", 0, "» CliMax anti-aim")
                renderer_text(15 + renderer_measure_text("", "» CliMax anti-aim "), h / 2 , color_a[1], color_a[2], color_a[3], 255, "", 0, "technology")
                renderer_text(15, h / 2 + 15, 255, 255, 255, 255, "", 0, "» current version:")
                renderer_text(15 + renderer_measure_text("", "» current version: "), h / 2 + 15 , color_a[1], color_a[2], color_a[3], 255, "", 0, "default")
                renderer_text(15, h / 2 + 30, 255, 255, 255, 255, "", 0, "» desync angle:")
                renderer_text(15 + renderer_measure_text("", "» desync angle: "), h / 2 + 30 , color_a[1], color_a[2], color_a[3], 255, "", 0, math.floor(e_pose_param).."°")
           end
        end
    end
end

client.set_event_callback("pre_render", function()
    if ui.get(items.break_leg_anims) then
        ui.set(refs.leg_movement, "Always slide") 
    end

    if ui.get(items.legzy) and ui.get(items.break_leg_anims) then
        randome = math.random(1,10)
        if randome > ui.get(items.sliderint) then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
        end
    end
    if ui.get(items.enable_leg) then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
    end
end)

local ground_ticks, end_time = 1, 0
client.set_event_callback("pre_render", function()
    if entity.is_alive(entity.get_local_player()) then
        
        if ui.get(items.fake_up) and ui_get(master_switch) then
            local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
    
            if on_ground == 1 then
                ground_ticks = ground_ticks + 1
            else
                ground_ticks = 0
                end_time = globals.curtime() + 1
            end 
        
            if ground_ticks > ui.get(refs.fakelag)+1 and end_time > globals.curtime() then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
            end
        end
    end 
end)

local event_handler_functions = {
    [true]  = client.set_event_callback,
    [false] = client.unset_event_callback,
}

local function get_distance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

local function on_run_command()
    local players = entity.get_players(true)
    local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
	local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
    for i=1, #players do
        local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
        local distance = get_distance(lx, ly, lz, x, y, z)
        local weapon = entity.get_player_weapon(players[i])
        if entity.get_classname(weapon) == "CKnife" and distance <= 164 then
            ui.set(yaw_slider,180)
        end
    end
end

local function on_script_toggle_change()
    local state = ui.get(items.anti_knife)
    local handle_event = event_handler_functions[state]
    handle_event("run_command", on_run_command)
end

on_script_toggle_change()
ui.set_callback(items.anti_knife, on_script_toggle_change)



local function menu()
    local master = ui_get(master_switch)
    local element = ui_get(element_type)
    ui_set_visible(element_type, master)
    ui_set_visible(items.anti_aim, master and element == "Anti-aim")
    ui_set_visible(items.indicator, master and element == "Visuals")
    ui_set_visible(items.indicator_mode, master and ui.get(items.indicator) and element == "Visuals")
    ui_set_visible(items.left_indicator, master and ui.get(items.indicator) and element == "Visuals")
    ui_set_visible(items.color_a, master and ui.get(items.indicator) and element == "Visuals")


    ui_set_visible(items.watermark, master and ui.get(items.indicator) and element == "Visuals")
    ui_set_visible(items.watermark_cir_ex, master and ui.get(items.indicator) and element == "Visuals" and ui.get(items.watermark))
    ui_set_visible(items.watermark_cir, master and ui.get(items.indicator) and element == "Visuals" and ui.get(items.watermark))

    ui_set_visible(items.arrows_mode, master and ui.get(items.indicator) and element == "Visuals")
    ui_set_visible(items.clr_size, master and ui.get(items.indicator) and ui.get(items.arrows_mode) == "C" and element == "Visuals")
    ui_set_visible(items.color_cir, master and ui.get(items.indicator) and ui.get(items.arrows_mode) == "C" and element == "Visuals")

    ui_set_visible(items.color_b, master and ui.get(items.indicator) and ui.get(items.indicator_mode) ~= "Default" and element == "Visuals")
    ui_set_visible(items.roll_inverter, master and ui.get(items.anti_aim) and element == "Anti-aim")
    ui_set_visible(items.manual_backward_dir, ui_get(items.anti_aim) and master and element == "Anti-aim")
    ui_set_visible(items.manual_left_dir, ui_get(items.anti_aim) and master and element == "Anti-aim")
    ui_set_visible(items.manual_right_dir, ui_get(items.anti_aim) and master and element == "Anti-aim")
    ui_set_visible(items.abf, ui_get(items.anti_aim) and master and element == "Anti-aim")
    ui_set_visible(items.fs_mode, ui_get(items.anti_aim) and master and element == "Anti-aim")
    ui_set_visible(items.break_leg_anims, master and element == "Misc")
    ui_set_visible(items.fake_up, master and element == "Misc")
    ui_set_visible(items.enable_leg, master and element == "Misc")
    ui_set_visible(items.anti_knife, master and element == "Misc")
    ui_set_visible(items.legzy, ui_get(items.break_leg_anims) and master and element == "Misc")
    ui_set_visible(items.sliderint, ui_get(items.break_leg_anims) and ui_get(items.legzy) and master and element == "Misc")

    vars.active_i = vars.state_to_idx[ui_get(conditions)]

    ui_set_visible(conditions,  ui_get(items.anti_aim) and master and element == "Anti-aim")
    for i= 1, 5 do
        ui_set_visible(anti_aim[i].pitch, vars.active_i == i  and ui_get(items.anti_aim) and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].yawbase, vars.active_i == i  and ui_get(items.anti_aim) and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].yaw, vars.active_i == i  and ui_get(items.anti_aim) and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].yawadd, vars.active_i == i and ui_get(anti_aim[i].yaw) ~= "Off"  and ui_get(items.anti_aim) and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].yawadd_right, vars.active_i == i and ui_get(anti_aim[i].yaw) ~= "Off"  and ui_get(items.anti_aim) and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].yawjitter, vars.active_i == i  and ui_get(items.anti_aim) and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].yawjitteradd, vars.active_i == i and ui_get(anti_aim[i].yawjitter) ~= "Off" and ui_get(items.anti_aim) and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].yawjitteradd_right, vars.active_i == i and ui_get(anti_aim[i].yawjitter) ~= "Off" and ui_get(items.anti_aim) and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].fakeyawlimit, vars.active_i == i  and ui_get(items.anti_aim) and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].bodyyaw, vars.active_i == i  and ui_get(items.anti_aim) and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].bodyyaw_settings, vars.active_i == i and (ui_get(anti_aim[i].bodyyaw) == "Jitter" or ui_get(anti_aim[i].bodyyaw) == "Static") and ui_get(items.anti_aim) and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].bodyyaw_extended, vars.active_i == i and (ui_get(anti_aim[i].bodyyaw) == "Jitter" or ui_get(anti_aim[i].bodyyaw) == "Static") and ui_get(items.anti_aim) and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].bodyyaw_extended_add, vars.active_i == i and (ui_get(anti_aim[i].bodyyaw) == "Jitter" or ui_get(anti_aim[i].bodyyaw) == "Static") and ui_get(items.anti_aim) and master and ui.get(anti_aim[i].bodyyaw_extended) ~= "Off" and element == "Anti-aim")
        ui_set_visible(anti_aim[i].fakeyawlimit, vars.active_i == i  and ui_get(items.anti_aim) and ui_get(anti_aim[i].bodyyaw) ~= "Off" and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].fakeyawlimit_right, vars.active_i == i  and ui_get(items.anti_aim) and ui_get(anti_aim[i].bodyyaw) ~= "Off" and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].fakeyawlimit_extended, vars.active_i == i  and ui_get(items.anti_aim) and ui_get(anti_aim[i].bodyyaw) ~= "Off" and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].fakeyawlimit_extended_add, vars.active_i == i  and ui_get(items.anti_aim) and ui_get(anti_aim[i].bodyyaw) ~= "Off" and master and ui.get(anti_aim[i].fakeyawlimit_extended) ~= "Off" and element == "Anti-aim")
        ui_set_visible(anti_aim[i].roll_ext, vars.active_i == i  and ui_get(items.anti_aim) and ui_get(anti_aim[i].bodyyaw) ~= "Off" and master and element == "Anti-aim")
        ui_set_visible(anti_aim[i].roll_extended_limit, vars.active_i == i  and ui_get(items.anti_aim) and ui_get(anti_aim[i].bodyyaw) ~= "Off" and master and ui.get(anti_aim[i].roll_ext) and element == "Anti-aim")
        ui_set_visible(anti_aim[i].roll_extended_limit_r, vars.active_i == i  and ui_get(items.anti_aim) and ui_get(anti_aim[i].bodyyaw) ~= "Off" and master and ui.get(anti_aim[i].roll_ext) and element == "Anti-aim")
        ui_set_visible(anti_aim[i].roll_extended_extra, vars.active_i == i  and ui_get(items.anti_aim) and ui_get(anti_aim[i].bodyyaw) ~= "Off" and master and ui.get(anti_aim[i].roll_ext) and element == "Anti-aim")
        ui_set_visible(anti_aim[i].roll_extended_limit_extra, vars.active_i == i  and ui_get(items.anti_aim) and ui_get(anti_aim[i].bodyyaw) ~= "Off" and master and ui.get(anti_aim[i].roll_ext) and ui.get(anti_aim[i].roll_extended_extra) ~= "Off" and element == "Anti-aim")
    end
    ui_set_visible(items.manual_state, false)
    ui_set_visible(refs.yaw[2], not master)
    ui_set_visible(refs.yawj[1], not master)
    ui_set_visible(refs.yaw[1], not master)
    ui_set_visible(refs.yawj[2], not master)
    ui_set_visible(refs.pitch, not master)
    ui_set_visible(refs.bodyyaw[1], not master)
    ui_set_visible(refs.bodyyaw[2], not master)
    ui_set_visible(refs.fs_bodyyaw, not master)
    ui_set_visible(refs.yaw_base, not master)
    ui_set_visible(refs.fakelimit, not master)
    ui_set_visible(refs.roll, not master)
end

--callbacks[Bingice#6563]
local events = {
    setup_command = function(e)
        aa_main()
        anti_aim_on_use(e)
        set_data(e)
    end,
    paint = function()
        bind_systeam:updata()
        draw_crosshair_indicators()
    end,
    run_command = function(e)
        get_best_enemy()
        get_best_angle()
    end,
    bullet_impact = function(e)
        miss_detection(e)
    end,
    handle_menu = function() 
        menu() 
    end,
    reset = function()
        vars.misses, vars.last_miss, vars.indexed_angle = { }, 0, 0
    end,
}

client.set_event_callback("paint_ui", function()
    local menux, menuy = ui.menu_position()
    if ui.is_menu_open() then
        renderer.gradient(menux - 300, menuy + 80, 270, 2, 135, 206, 235, 255, 0, 0, 255, 0, true)
        renderer.rectangle(menux - 300, menuy + 80, 270, 270, 0, 0, 0, 10)
        renderer.blur(menux - 300, menuy + 80, 270, 270, 0, 0, 0, 100)
        renderer.text(menux - 280, menuy + 90, 255, 255, 255, 255, '-', 0, 'CliMax  YAW')
        renderer.text(menux - 230, menuy + 90, 0, 255, 0, 255, '-', 0, 'V3.0')
        renderer.text(menux - 210, menuy + 90, 255, 127, 0, 255, '-', 0, 'BETA')
        renderer.text(menux - 280, menuy + 100, 255, 225, 255, 255, '-', 0, '[ANTI-AIM]')
        renderer.text(menux - 270, menuy + 110, 255, 255, 255, 255, '-', 0, '^CliMax ANTIAIM')
        renderer.text(menux - 270, menuy + 120, 255, 255, 255, 255, '-', 0, '^QQ：359492464')
        renderer.text(menux - 270, menuy + 130, 255, 255, 255, 255, '-', 0, '^qun：722290812')
        renderer.text(menux - 270, menuy + 140, 255, 255, 255, 255, '-', 0, 'Bingice CliMax-yaw')
        renderer.text(menux - 280, menuy + 150, 255, 225, 255, 255, '-', 0, '[BINGICE]')
        renderer.text(menux - 270, menuy + 160, 255, 255, 255, 255, '-', 0, '^THANK YOU FOR YOUR SUPPORT ')
        renderer.text(menux - 280, menuy + 180, 255, 225, 255, 255, '-', 0, '[TEAM]')
        renderer.text(menux - 270, menuy + 190, 0, 255, 0, 255, '-', 0, '2022.07.29')
        renderer.text(menux - 270, menuy + 200, 0, 255, 0, 255, '-', 0, '^THE LUA WAS BORN')
        renderer.text(menux - 270, menuy + 210, 0, 255, 0, 255, '-', 0, '^OUR TEAM MEMBERS BINGICE L GGGB')
        renderer.text(menux - 270, menuy + 260, 255, 165, 0, 255, '-', 0, '>> CliMax  ANTI-AIM  SYSTEM')
    end

end)

local function main()
    client.set_event_callback("setup_command", events.setup_command)
    client.set_event_callback("paint", events.paint)
    client.set_event_callback("run_command", events.run_command)
    client.set_event_callback("client_disconnect", events.reset)
    client.set_event_callback("game_newmap", events.reset)
    client.set_event_callback("cs_game_disconnected", events.reset)
    client.set_event_callback("round_start", events.reset)
    client.set_event_callback("paint_ui", events.handle_menu)
    client.set_event_callback("shutdown", antiuntrusted)
    client.set_event_callback("pre_config_load", antiuntrusted)
    client.set_event_callback("pre_config_save", antiuntrusted)
end
main()
ui_set_callback(master_switch, main)
--lua finished[Bingice#6563]
