-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server

client.exec("cl_showerror 0")


-- Decryption key = HWID * THE RANDOM NUMBER (DEFAULT 421)
---------------------------------------------
--[STEAM-ID]
---------------------------------------------
        --client.exec("clear")
        client.color_log(215, 189, 226, " ---------------------------------------------------- [Hell-Yaw Loaded] -----------------------------------------------------")
        client.color_log(255, 255, 255, "|                                                                                                                           |")
        client.color_log(245, 238, 248, "|                    :::    :::       ::::::::::      :::             :::                                                      |")
        client.color_log(235, 222, 240, "|                   :+:    #+#       :+:             :+:             :+:                                                       |")
        client.color_log(215, 189, 226, "|                  +:+    #+#       +:+             +:+             +:+                                                        |")
        client.color_log(195, 155, 211, "|                +#++:++#++       +#++:++#++      +#+             +#+                                                         |")
        client.color_log(175, 122, 197, "|               +#+    #+#       +#+             +#+             +#+                                                          |")
        client.color_log(155, 89, 182,  "|              #+#    #+#       #+#             +#+             #+#                                                           |")
        client.color_log(136, 78, 160,  "|             #+#    #+#       ##########      ###########     ###########                                                    |")   
        client.color_log(136, 78, 160,  "|           ___________________________________                               ___________________________________            |")
        client.color_log(136, 78, 160,  "|           ___________________________________ \0")
        client.color_log(255, 255, 255, "Discord: https://discord.gg/NTVh5kGE2T\0")
        client.color_log(136, 78, 160, " ___________________________________             |")
        client.color_log(136, 78, 160,  "|             ___________________________________\0 ")
        client.color_log(255, 255, 255, "  Contact: Fluffy.#7067\0")
        client.color_log(136, 78, 160,  "  ___________________________________               |")
        client.color_log(136, 78, 160,  "|                                                                                                                           |")
        client.color_log(215, 189, 226, " ---------------------------------------------------------------------------------------------------------------------------")




--localize
-- math localizing
math_abs, math_acos, math_asin, math_atan, math_ceil, math_cos, math_exp, math_floor, math_fmod, math_huge, math_log, math_max, math_maxinteger, math_min, math_mininteger, math_modf, math_pi, math_rad, math_random, math_randomseed, math_sin, math_sqrt, math_tan, math_tointeger, math_type, math_ult
= 
math.abs, math.acos, math.asin, math.atan, math.ceil, math.cos, math.exp, math.floor, math.fmod, math.huge, math.log, math.max, math.maxinteger, math.min, math.mininteger, math.modf, math.pi, math.rad, math.random, math.randomseed, math.sin, math.sqrt, math.tan, math.tointeger, math.type, math.ult
--client localizing
client_set_event_callback, client_unset_event_callback, client_log, client_color_log, client_error_log, client_exec, client_userid_to_entindex, client_draw_debug_text, client_draw_hitboxes, client_random_int, client_random_float, client_screen_size, client_visible, client_trace_line, client_trace_bullet, client_scale_damage, client_delay_call, client_latency, client_camera_angles, client_camera_position, client_timestamp, client_eye_position, client_set_clan_tag, client_system_time, client_unix_time, client_reload_active_scripts, client_create_interface, client_find_signature, client_key_state, client_get_model_name, client_register_esp_flag
=
client.set_event_callback, client.unset_event_callback, client.log, client.color_log, client.error_log, client.exec, client.userid_to_entindex, client.draw_debug_text, client.draw_hitboxes, client.random_int, client.random_float, client.screen_size, client.visible, client.trace_line, client.trace_bullet, client.scale_damage, client.delay_call, client.latency, client.camera_angles, client.camera_position, client.timestamp, client.eye_position, client.set_clan_tag, client.system_time, client.unix_time, client.reload_active_scripts, client.create_interface, client.find_signature, client.key_state, client.get_model_name, client.register_esp_flag
--config localizing
config_load, config_export = config.load, config.export
--cvar localizing
cvar_set_string, cvar_get_string, cvar_set_float, cvar_set_raw_float, cvar_get_float, cvar_set_int, cvar_set_raw_int, cvar_get_int, cvar_invoke_callback
=
cvar.set_string, cvar.get_string, cvar.set_float, cvar.set_raw_float, cvar.get_float, cvar.set_int, cvar.set_raw_int, cvar.get_int, cvar.invoke_callback
--database localizing
database_write, database_read = database.write, database.read
--entity localizing
entity_get_local_player, entity_get_all, entity_get_players, entity_get_game_rules, entity_get_player_resource, entity_get_classname, entity_set_prop, entity_get_prop, entity_is_enemy, entity_is_alive, entity_is_dormant, entity_get_player_name, entity_get_player_weapon, entity_hitbox_position, entity_get_steam64, entity_get_bounding_box, entity_get_origin, entity_get_esp_data
=
entity.get_local_player, entity.get_all, entity.get_players, entity.get_game_rules, entity.get_player_resource, entity.get_classname, entity.set_prop, entity.get_prop, entity.is_enemy, entity.is_alive, entity.is_dormant, entity.get_player_name, entity.get_player_weapon, entity.hitbox_position, entity.get_steam64, entity.get_bounding_box, entity.get_origin, entity.get_esp_data
--globals localizing
globals_realtime, globals_curtime, globals_frametime, globals_absoluteframetime, globals_maxplayers, globals_tickcount, globals_tickinterval, globals_framecount, globals_mapname, globals_lastoutgoingcommand, globals_oldcommandack, globals_commandack, globals_chokedcommands
=
globals.realtime, globals.curtime, globals.frametime, globals.absoluteframetime, globals.maxplayers, globals.tickcount, globals.tickinterval, globals.framecount, globals.mapname, globals.lastoutgoingcommand, globals.oldcommandack, globals.commandack, globals.chokedcommands
--panorama localizing
panorama_open, panorama_loadstring = panorama.open, panorama.loadstring
--materialsystem localizing
materialsystem_get_name, materialsystem_reload, materialsystem_color_modulate, materialsystem_alpha_modulate, materialsystem_set_shader_param, materialsystem_get_shader_param, materialsystem_set_material_var_flag, materialsystem_get_material_var_flag, materialsystem_find_material, materialsystem_find_materials, materialsystem_find_texture, materialsystem_get_model_materials, materialsystem_arms_material, materialsystem_chams_material
=
materialsystem.get_name, materialsystem.reload, materialsystem.color_modulate, materialsystem.alpha_modulate, materialsystem.set_shader_param, materialsystem.get_shader_param, materialsystem.set_material_var_flag, materialsystem.get_material_var_flag, materialsystem.find_material, materialsystem.find_materials, materialsystem.find_texture, materialsystem.get_model_materials, materialsystem.arms_material, materialsystem.chams_material
--plist localizing
plist_set, plist_get = plist.set, plist.get
--renderer localizing
renderer_text, renderer_measure_text, renderer_rectangle, renderer_line, renderer_gradient, renderer_circle, renderer_circle_outline, renderer_triangle, renderer_world_to_screen, renderer_indicator, renderer_texture, renderer_load_svg, renderer_load_png, renderer_load_jpg, renderer_load_rgba
=
renderer.text, renderer.measure_text, renderer.rectangle, renderer.line, renderer.gradient, renderer.circle, renderer.circle_outline, renderer.triangle, renderer.world_to_screen, renderer.indicator, renderer.texture, renderer.load_svg, renderer.load_png, renderer.load_jpg, renderer.load_rgba
--ui localizing 
ui_new_checkbox, ui_new_slider, ui_new_combobox, ui_new_multiselect, ui_new_hotkey, ui_new_button, ui_new_color_picker, ui_new_textbox, ui_new_listbox, ui_new_string, ui_new_label, ui_reference, ui_set, ui_get, ui_set_callback, ui_set_visible, ui_is_menu_open, ui_mouse_position, ui_menu_position, ui_menu_size, ui_name 
= 
ui.new_checkbox, ui.new_slider, ui.new_combobox, ui.new_multiselect, ui.new_hotkey, ui.new_button, ui.new_color_picker, ui.new_textbox, ui.new_listbox, ui.new_string, ui.new_label, ui.reference, ui.set, ui.get, 
ui.set_callback, ui.set_visible, ui.is_menu_open, ui.mouse_position, ui.menu_position, ui.menu_size, ui.name
entity.get_steam64 = 0
local function multicolor_log(...)
  local args = {
    ...
  }
  local len = #args
  for i = 1, len do
    local arg = args[i]
    local r, g, b = unpack(arg)
    local msg = { }
    if #arg == 3 then
      table.insert(msg, " ")
    else
      for i = 4, #arg do
        table.insert(msg, arg[i])
      end
    end
    msg = table.concat(msg)
    if len > i then
      msg = msg .. "\0"
    end
    client_color_log(r, g, b, msg)
  end
  
  


  local pitch_ref = ui.reference("AA", "Anti-aimbot angles", "Pitch")
  local base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
  local yaw, yaw_num = ui.reference("AA", "Anti-aimbot angles", "Yaw")
  local yaw_jt, yaw_jt_num = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
  local yaw_limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
  local body, body_num = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
  local limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
  local fl_active = ui.reference("AA", "Fake lag", "Enabled")
  local fr_bodyyaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
  local fr, fr_hk = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
  local edge = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
  local slowmo, slowmo_key = ui.reference("AA", "Other", "Slow motion")
  local safe = ui.reference("RAGE", "Aimbot", "Force safe point")
  local baim = ui.reference("RAGE", "Other", "Force body aim")
  local ref_legmovement = ui.reference ("AA", "Other", "Leg movement")
  local silentaa = ui.reference("RAGE", "Aimbot", "Silent aim")


  local state = ui.get(master)

  local visible = not ui.get(master) -- or (e == nil and menu_call == nil)
    
  if e == nil then visible = true end
  if menu_call == nil then
      setup_menu(menu_data, ui.get(condition2), not visible)
  end

  if not ui_get(hotkey) then return end
    



end
local csgo_weapons = require "gamesense/csgo_weapons"
local js = panorama.open()
local MyPersonaAPI = js.MyPersonaAPI
local steamid = MyPersonaAPI.GetXuid() 
local gui = {
    master = ui_new_checkbox("AA", "Anti-aimbot angles", "                     Enable HellYaw"),
    indicator_maincolorr = ui_new_color_picker("AA", "Anti-aimbot angles", "Indic.mainn", 122, 187, 235, 255),
    presets = ui_new_slider("AA", "Anti-aimbot angles", "                      Smart anti-aim", 0, 2, 0, true, "", 1, {[0] = "Off", [1] = "Basic", [2] = "Advanced"}),
    fakeyaw = ui_new_multiselect("AA", "Anti-aimbot angles", "Fake yaw improvements", { "Low delta", "Velocity fix" }),
    freestandingopts = ui_new_combobox("AA", "Anti-aimbot angles", "Freestanding", { "Regular", "Reverse", "Experimental" }),
    fakelag = ui_new_checkbox("AA", "Fake lag", "Fake lag"),
    manual = ui_new_checkbox("AA", "Anti-aimbot angles", "Manual anti-aim (Use toggle)"),
    indicator_maincolor = ui_new_color_picker("AA", "Anti-aimbot angles", "Indic.main", 255, 255, 255, 255),
    manual_back = ui_new_hotkey("AA", "Anti-aimbot angles", " ☟   Backwards", false),
    manual_right = ui_new_hotkey("AA", "Anti-aimbot angles", " ☞  Right", false),
    manual_left = ui_new_hotkey("AA", "Anti-aimbot angles", " ☜  Left", false),
    epeek = ui_new_checkbox("AA", "Anti-aimbot angles", "In-Use anti-aim"),
    jitters = ui_new_multiselect("AA", "Anti-aimbot angles", "Jitter modes", { "Agressive", "Dangerous", "Low, yaw", "High, body", "Custom Body" }),
    yawinair = ui_new_slider("AA", "Anti-aimbot angles", "Yaw in Air", -180, 180, 0, true, "°"),
    fakeyawlimitinair = ui_new_slider("AA", "Anti-aimbot angles", "Fake Yaw in Air", 0, 60, 59, true, "°"),
    yawslowmo = ui_new_slider("AA", "Anti-aimbot angles", "Yaw in Slowwalk", -180, 180, 0, true, "°"),
    bodyyawinair = ui_new_slider("AA", "Anti-aimbot angles", "Body yaw In air", -180, 180, 0, true, "°"),
    bodyyawslowwalk = ui_new_slider("AA", "Anti-aimbot angles", "Body yaw Slowwalk", -180, 180, -98, true, "°"),
    dangerousslider = ui_new_slider("AA", "Anti-aimbot angles", "Dangerous", -180, 180, 32, true, "°"),
    dangeroussliderslowwalk = ui_new_slider("AA", "Anti-aimbot angles", "Dangerous Slowwalk", -180, 180, 32, true, "°"),
    dangeroussliderinair = ui_new_slider("AA", "Anti-aimbot angles", "Dangerous In air", -180, 180, 32, true, "°"),
    dangerousslidersafe = ui_new_slider("AA", "Anti-aimbot angles", "Dangerous (Safe)", -180, 180, 32, true, "°"),
    dangeroussliderdangerous = ui_new_slider("AA", "Anti-aimbot angles", "Dangerous (Dangerous)", -180, 180, 32, true, "°"),
    dangeroussliderverydangerous = ui_new_slider("AA", "Anti-aimbot angles", "Dangerous (Very Dangerous)", -180, 180, 32, true, "°"),
    betteryawbase = ui_new_checkbox("AA", "Anti-aimbot angles", "Adaptive yaw base"),
    indicators = ui_new_checkbox("AA", "Fake lag", "Indicators"),
    indicator_color = ui_new_color_picker("AA", "Fake lag", "Indic.color", 255, 66, 66, 255),
    indicator_coverride = ui_new_checkbox("AA", "Fake lag", "Override indicator color"),
    indicator_angle = ui_new_combobox("AA", "Fake lag", "Real angle indicator",  { "Off", "Clean", "Fire" }),
    indicator_anglecol = ui_new_color_picker("AA", "Fake lag", "Angle", 255, 66, 66, 255),
    doubletap = ui_new_combobox("AA", "Other", "Improved doubletap",  { "Off", "No teleport", "Teleport" }),
    edgeyaw = ui_new_checkbox("AA", "Anti-aimbot angles", "Automatic edge yaw"),
    enable = ui.new_checkbox("AA", "Anti-aimbot Angles", "Animation"),
    enableLegs = ui.new_combobox("AA", "Anti-aimbot Angles", "Leg movement", {"Off", "Random", "Jitter", "Exploit"}),
    indicator_label = ui.new_label("AA", "Fake lag", "Safe Color"),
    indicator_safe = ui_new_color_picker("AA", "Fake lag", "Indic.safe", 161, 201, 38, 255),
    indicator_label = ui.new_label("AA", "Fake lag", "Dangerous Color"),
    indicator_dangerous = ui_new_color_picker("AA", "Fake lag", "Indic.dangerous", 235, 128, 52, 255),
    indicator_label = ui.new_label("AA", "Fake lag", "Very Dangerous Color"),
    indicator_verydangerous = ui_new_color_picker("AA", "Fake lag", "Indic.vdangerous", 255, 10, 10, 255)
}
local references = {
    enabled = { ui_reference("AA", "Anti-aimbot angles", "Enabled") },
    ref_legmovement = ui.reference("AA", "Other", "Leg movement"),
    pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
    checkbox_reference = ui.reference("AA", "Other", "Slow motion"),
    yawbase = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = { ui_reference("AA", "Anti-aimbot angles", "Yaw") },
    yawjitter = { ui_reference("AA", "Anti-aimbot angles", "Yaw jitter") },
    bodyyaw = { ui_reference("AA", "Anti-aimbot angles", "Body yaw") },
    freestandbodyyaw = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    fakeyawlimit = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
    freestand = { ui_reference("AA", "Anti-aimbot angles", "Freestanding") },
    forcebaim = ui_reference("RAGE", "Other", "Force body aim"),
    forcesafe = ui_reference("RAGE", "Aimbot", "Force safe point"),
    aacorrectionor = ui_reference("RAGE", "Other", "Anti-aim correction override"),
    slowmotion = { ui_reference("AA", "Other", "Slow motion") },
    legmovement = ui_reference("AA", "Other", "Leg movement"),
    duckpeek = ui_reference("RAGE", "Other", "Duck peek assist"),
    doubletap = { ui_reference("RAGE", "Other", "Double tap") },
    dthitchance = ui_reference("RAGE", "Other", "Double tap hit chance"),
    dtfakelag = ui_reference("RAGE", "Other", "Double tap fake lag limit"),
    fakelag = ui_reference("AA", "Fake lag", "Enabled"),
    fakelaglimit = ui_reference("AA", "Fake lag", "Limit"),
    fakelagamount = ui_reference("AA", "Fake lag", "Amount"),
    onshot = { ui_reference("AA", "Other", "On shot anti-aim") },
    sv_maxusrcmdprocessticks = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    gsclantag = ui_reference("MISC", "Miscellaneous", "Clan tag spammer"),
    silent = ui_reference("RAGE", "Aimbot", "Silent aim")
}


local isabdone = false
local newtime = 0
local abdone = false
local abdonetime = 0
local l_velocity = 0
local inair = false
local desyncside = "right"
local lasttimenothittable = 0
local ground_ticks = 1
local fade
local nextAttack, nextShot, nextShotSecondary = nil, nil, nil
local mleft, mright, mback = false, false, false
local lmvtval = 1
local setlegonce = false
local weapontype = nil
local lmvttime = 0
local ldelay = 1
local closest_enemydist = 9999
local closest_enemy = nil
local enemies_count = 0
local epeeking = false
local closest_enemy_crosshair = nil
local antibrute_dormant = false
local enemy_missed = nil
local fakejitter = false
local isbruteforcing = false
local enemy_shot_angle = 0
local pshot = false
local actualshot = false
local phurt = false
local bestenemy = nil
local phurtshooter = nil
local invertonce = false
local shitjitter = false
local dangerstate = "Safe"
local isfreestanding = false
local storedfreestandingangle = 0
local tlast = 0
local dynamic_time = 0
local dynamic_ent = nil
local dynamic_lastent = nil
local dynamic_ticks = 0
local edge_count = { [1] = 7, [2] = 12, [3] = 15, [4] = 19, [5] = 23, [6] = 28, [7] = 35, [8] = 39 }
local dtcache = {
    shot = 1
}
local paintindicator = {
    defaultcolors = {
        main = {
            fakeduckup = { 255, 255, 255 },
            fakeduckdown = { 200, 200, 200 }
        },
    },
    flags = {
        postition = 40,
        space = 8,
        flags = "c-",
        mflags = "cb",
        linethickness = 3
    },
    main = {
        options = {
            "HELLYAW",
            { "SAFE", "DANGEROUS", "VERY DANGEROUS", "UNKNOWN" },
            "DUCK",
            { "CHARGING ", "READY", "INACTIVE" },
        }
    },
    additional = {
        "ONSHOT",
        "BAIM",
        "ROVERRIDE",
        "SAFE POINT",
        "FREESTAND",
    }
}

local function multi_contains(multiselect, position)
    for i = 1, #multiselect do
        if multiselect[i] == position then
            return true
        end
    end
    return false
end
local function laa_invertbodyyaw()
    return ui_get(references.bodyyaw[2])*-1
end
local function Angle_Vector(angle_x, angle_y)
	local sp, sy, cp, cy = nil
    sy = math_sin(math_rad(angle_y));
    cy = math_cos(math_rad(angle_y));
    sp = math_sin(math_rad(angle_x));
    cp = math_cos(math_rad(angle_x));
    return cp * cy, cp * sy, -sp;
end
local function vec_3(_x, _y, _z) 
	return { x = _x or 0, y = _y or 0, z = _z or 0 } 
end
local function vec3_dot(ax, ay, az, bx, by, bz)
	return ax*bx + ay*by + az*bz
end
local function vec3_normalize(x, y, z)
	local len = math_sqrt(x * x + y * y + z * z)
	if len == 0 then
		return 0, 0, 0
	end
	local r = 1 / len
	return x*r, y*r, z*r
end
local function get_fov_cos(ent, vx,vy,vz, lx,ly,lz)
	local ox,oy,oz = entity_get_prop(ent, "m_vecOrigin")
	if ox == nil then
		return -1
	end
	local dx,dy,dz = vec3_normalize(ox-lx, oy-ly, oz-lz)
	return vec3_dot(dx,dy,dz, vx,vy,vz)
end
local function lmath_adddelay(delay)
    local time = globals_curtime()
    if time < tlast then
		return false
    end
    tlast = time + delay
    return true
end
local clamp_angles = function(angle)
    angle = angle % 360
    angle = (angle + 360) % 360

    if angle > 180 then
        angle = angle - 360
    end

    return angle
end
local function vector(x, y, z)
    x = x ~= nil and x or 0
    y = y ~= nil and y or 0
    z = z ~= nil and z or 0
    return {
        ["x"] = x,
        ["y"] = y,
        ["z"] = z
    }
end
local vector_add = function(vector1, vector2)
    return {
        ["x"] = vector1.x + vector2.x,
        ["y"] = vector1.y + vector2.y,
        ["z"] = vector1.z + vector2.z
    }
end
local rad2deg = function(rad)
    return (rad * 180 / math.pi)
end
local deg2rad = function(deg)
    return (deg * math.pi / 180)
end
local function angle_to_vec(pitch, yaw)
	local p, y = math_rad(pitch), math_rad(yaw)
	local sp, cp, sy, cy = math_sin(p), math_cos(p), math_sin(y), math_cos(y)
	return cp*cy, cp*sy, -sp
end
local function normalise_angle(angle)
	angle =  angle % 360 
	angle = (angle + 360) % 360
	if (angle > 180)  then
		angle = angle - 360
	end
	return angle
end
local function get_body_yaw(player)
	local _, model_yaw = entity_get_prop(player, "m_angAbsRotation")
	local _, eye_yaw = entity_get_prop(player, "m_angEyeAngles")
	if model_yaw == nil or eye_yaw ==nil then return 0 end
	return normalise_angle(model_yaw - eye_yaw)
end
local function lmath_closestpoint(A, B, P)
    local a_to_p = { P[1] - A[1], P[2] - A[2] }
    local a_to_b = { B[1] - A[1], B[2] - A[2] }
    local ab = a_to_b[1]^2 + a_to_b[2]^2
    local dots = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    local t = dots / ab
     
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end
local function lmath_3ddistance(x1,y1,z1,x2,y2,z2)
	return math_sqrt( (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) )
end
local function CalcAngle(localplayerxpos, localplayerypos, enemyxpos, enemyypos)
    local relativeyaw = math_atan( (localplayerypos - enemyypos) / (localplayerxpos - enemyxpos) )
    return relativeyaw * 180 / math_pi
 end
local function flags_landed(ent)
    if not inair then
        ground_ticks = ground_ticks + 1
    else
        ground_ticks = 0
        newtime = globals_curtime() + 1
    end
    if ground_ticks > ui_get(references.fakelaglimit) + 1 and newtime > globals_curtime() then 
        return true
    end
    return false
end
local function flags_crouching(ent)
    if ent == nil then 
        ent = entity_get_local_player()
    end
	local flags = entity_get_prop(ent, "m_fFlags")
	local crouching = bit.band(flags, 4)
	if crouching == 4 then
		return true
	end
	return false
end
local function flags_fakeduck()
    if not ui_get(references.duckpeek) then return end
	local flags = entity_get_prop(entity_get_local_player(), "m_fFlags")
	local crouching = bit.band(flags, 4)
	return crouching
end

local function ticks_to_time(ticks)
	return globals_tickinterval() * ticks
end 
local function time_to_ticks(dt)
	return math_floor(0.5 + dt / globals_tickinterval() - 3)
end
local function lp_head_hittable(enemy)
    if not enemy or not entity_is_alive(enemy) then return end
    local enemyorigin = { entity_get_prop(ent, "m_vecOrigin") }
    if not enemyorigin[3] then return end
    enemyorigin[3] = enemyorigin[3] + 64
    local hbposition = { entity_hitbox_position(entity_get_local_player(), 0) }
    local _, damage = client_trace_bullet(enemy, enemyorigin[1], enemyorigin[2], enemyorigin[3], hbposition[1], hbposition[2], hbposition[3], true)
    return damage ~= nil and damage > 25
end

--slowwalk
checkbox_reference, hotkey_reference = ui.reference("AA", "Other", "Slow motion")



slowwalkcheck = ui.new_checkbox("AA", "Other", "Slow motion limit")
limit_reference = ui.new_slider("AA", "Other", "Slow motion limit", 10, 57, 50, 57, "", 1, { [57] = "Max" })
function modify_velocity(cmd, goalspeed)
    if ui.get(slowwalkcheck, true) then
    else
        return
    end
    if goalspeed <= 0 then
        return
    end

    local minimalspeed = math.sqrt((cmd.forwardmove * cmd.forwardmove) + (cmd.sidemove * cmd.sidemove))

    if minimalspeed <= 0 then
        return
    end

    if cmd.in_duck == 1 then
        goalspeed = goalspeed * 2.94117647 -- wooo cool magic number
    end

    if minimalspeed <= goalspeed then
        return
    end

    local speedfactor = goalspeed / minimalspeed
    cmd.forwardmove = cmd.forwardmove * speedfactor
    cmd.sidemove = cmd.sidemove * speedfactor
end

function on_setup_cmd(cmd)
    if ui.get(slowwalkcheck, true) then
    else
        return
    end
    local checkbox = ui.get(checkbox_reference)
    local hotkey = ui.get(hotkey_reference)
    local limit = ui.get(limit_reference)

    if limit >= 42 then
        return
    end

    if checkbox and hotkey then
        modify_velocity(cmd, limit)
    end
end

client.set_event_callback('setup_command', on_setup_cmd)
local function dtcolor(val)
    local r, g, b
    if val > 22 then
        r, g, b = 255, 40, 40
    elseif val > 20 then
        r, g, b = 255, 83, 40
    elseif val > 18 then
        r, g, b = 255, 130, 40
    elseif val > 12 then
        r, g, b = 255, 151, 40
    elseif val > 14 then
        r, g, b = 255, 183, 40
    elseif val > 12 then
        r, g, b = 255, 212, 40
    elseif val > 1 then
        r, g, b = 148, 190, 12
    end
    return r, g, b
end
local function lp_peeking()
	local enemies = entity.get_players(true)
	if not enemies then
		return false
    end
    if inair then
        return false
    end
	-- Predict the local player's eye
	local predicted = 18
	local eye_position = vec_3(client_eye_position())
	local velocity_prop_local = vec_3(entity_get_prop( entity_get_local_player( ), "m_vecVelocity"))
	local predicted_eye_position = vec_3(eye_position.x + velocity_prop_local.x * ticks_to_time(predicted), eye_position.y + velocity_prop_local.y * ticks_to_time(predicted), eye_position.z + velocity_prop_local.z * ticks_to_time(predicted))
	for i = 1, #enemies do
		local player = enemies[i]
		local velocity_prop = vec_3(entity_get_prop(player, "m_vecVelocity"))
		-- Store and predict player origin
		local origin = vec_3( entity_get_prop( player, "m_vecOrigin" ) )
		local predicted_origin = vec_3( origin.x + velocity_prop.x * ticks_to_time( 16 ), origin.y + velocity_prop.y * ticks_to_time( 16 ), origin.z + velocity_prop.z * ticks_to_time( 16 ) )
		-- Set their origin to their predicted origin so we can run calculations on it
		entity_get_prop(player, "m_vecOrigin", predicted_origin)
		-- Predict their head position and fire an autowall trace to see if any damage can be dealt
		local head_origin = vec_3(entity_hitbox_position(player, 0))
		local predicted_head_origin = vec_3(head_origin.x + velocity_prop.x * ticks_to_time( 16 ), head_origin.y + velocity_prop.y * ticks_to_time( 16 ), head_origin.z + velocity_prop.z * ticks_to_time( 16 ))
		local trace_entity, damage = client_trace_bullet(entity_get_local_player( ), predicted_eye_position.x, predicted_eye_position.y, predicted_eye_position.z, predicted_head_origin.x, predicted_head_origin.y, predicted_head_origin.z )
		-- Restore their origin to their networked origin
		entity_get_prop(player, "m_vecOrigin", origin)
		-- Check if damage can be dealt to their predicted head
		if damage > 0 then
			return true
		end
	end
	return false
end
local function dofreestanding()
    if not entity_get_local_player() or not entity.is_alive(entity_get_local_player()) then return end
    local m_vecOrigin = vector(entity_get_prop(entity_get_local_player(), "m_vecOrigin"))
    local m_vecViewOffset = vector(entity_get_prop(entity_get_local_player(), "m_vecViewOffset"))
    local m_vecOrigin = vector_add(m_vecOrigin, m_vecViewOffset)
    local radius = 20 + 110 + 0.1
    local step = math.pi * 2.0 / edge_count[8]
    local camera = vector(client.camera_angles())
    local central = deg2rad(math.floor(camera.y + 0.5))
    local data = {
        fraction = 1,
        surpassed = false,
        angle = vector(0, 0, 0),
        var = 0,
        side = "LAST KNOWN"
    }
    for a = central, math           .pi * 3.0, step do
        if a == central then
            central = clamp_angles(rad2deg(a))
        end
        local clm = clamp_angles(central - rad2deg(a))
        local abs = math.abs(clm)
        if abs < 90 and abs > 1 then
            local side = "LAST KNOWN"
            local location = vector(radius * math.cos(a) + m_vecOrigin.x, radius * math.sin(a) + m_vecOrigin.y, m_vecOrigin.z)
            local _fr, entindex = client.trace_line(entity_get_local_player(), m_vecOrigin.x, m_vecOrigin.y, m_vecOrigin.z, location.x, location.y, location.z)
            if math.floor(clm + 0.5) < -21 then
                side = "LEFT"
            end
            if math.floor(clm + 0.5) > 21 then
                side = "RIGHT"
            end
            local fr_info = {
                fraction = _fr,
                surpassed = (_fr < 1),
                angle = vector(0, clamp_angles(rad2deg(a)), 0),
                var = math.floor(clm + 0.5),
                side = side
            }
            if data.fraction > _fr then
                data = fr_info
            end
        end
    end
    return data
end
local function dtcharged()
	if not ui_get(gui.master) then return end
	local active_weapon = entity_get_prop(entity_get_local_player(), "m_hActiveWeapon")
    if not active_weapon then return end
    nextAttack = entity_get_prop(entity_get_local_player(),"m_flNextAttack")
	nextShot = entity_get_prop(active_weapon,"m_flNextPrimaryAttack")
	nextShotSecondary = entity_get_prop(active_weapon,"m_flNextSecondaryAttack")
	if not nextAttack or not nextShot or not nextShotSecondary then return end
	nextAttack = nextAttack + 0.5
	nextShot = nextShot + 0.5
	nextShotSecondary = nextShotSecondary + 0.5
	if ui_get(references.doubletap[1]) and ui_get(references.doubletap[2]) then
		if math_max(nextShot, nextShotSecondary) < nextAttack then -- swapping
            if nextAttack - globals_curtime() > 0.00 then
                local swaptime = 0.016275634765625
                local fadetime = nextAttack - globals_curtime()
                fade = fadetime / swaptime
                return false
			else
				return true
			end
        else -- shooting or just shot
            if math_max(nextShot, nextShotSecondary) - globals_curtime() > 0.00 then
                local shottime = 0.01779296875
                local fadetime = math_max(nextShot,nextShotSecondary) - globals_curtime()
                fade = fadetime / shottime
                return false
			else
				return true
			end
		end
	end
	return false
end
client_set_event_callback("run_command", function()
    if not ui_get(gui.manual) then
        mleft, mright, mback = false, false, false
        return
    end
    if ui_get(gui.manual_back) then
        mleft, mright, mback = false, false, true
        ui_set(references.yawbase, "Local view")
        ui_set(references.yaw[2], 0)
    elseif ui_get(gui.manual_right) then
        mleft, mright, mback = false, true, false
        ui_set(references.yawbase, "Local view")
        ui_set(references.yaw[2], 90)
    elseif ui_get(gui.manual_left) then
        mleft, mright, mback = true, false, false
        ui_set(references.yawbase, "Local view")
        ui_set(references.yaw[2], -90)
    else
        mleft, mright, mback = false, false, false
    end
end)




client_set_event_callback("run_command", function()
    enemies_count = 0
    local plist = entity_get_players(true)
    for i = 1, #plist do
        if not entity_is_dormant(plist[i]) and entity_is_alive(plist[i]) then
            eposition = { entity_get_origin(plist[i]) }
            lposition = { entity_get_origin(entity_get_local_player()) }
            local distance = lmath_3ddistance(eposition[1], eposition[2], eposition[3], lposition[1], lposition[2], lposition[3])
            if distance < 1000 then
                enemies_count = enemies_count + 1
            end
        end
    end
end)
client_set_event_callback("run_command", function()
    if not entity_is_alive(closest_enemy) then
        closest_enemy = nil
        closest_enemydist = 9999
    end
    local plist = entity_get_players(true)
	local pitch, yaw = client_camera_angles()
    local vx, vy, vz = angle_to_vec(pitch, yaw)
    local lx,ly,lz = entity_get_prop(entity_get_local_player(), "m_vecOrigin")
	if lx == nil then return end
	local closest_fov_cos = -1
    for i = 1, #plist do
        if not entity_is_dormant(plist[i]) and entity_is_alive(plist[i]) then
            local fov_cos = get_fov_cos(plist[i], vx,vy,vz, lx,ly,lz)
			if fov_cos > closest_fov_cos then
				closest_fov_cos = fov_cos
				closest_enemy_crosshair = plist[i]
			end
            eposition = { entity_get_origin(plist[i]) }
            lposition = { entity_get_origin(entity_get_local_player()) }
            local distance = lmath_3ddistance(eposition[1], eposition[2], eposition[3], lposition[1], lposition[2], lposition[3])
            if distance - 1 < closest_enemydist or plist[i] == closest_enemy then
                if closest_enemydist > distance then
                    closest_enemydist = distance
                    closest_enemy = plist[i]
                end
            end
            if closest_enemy == plist[i] or closest_enemy_crosshair == plist[i] then
                return
            end
        end
    end
end)
local setaaonce = false
client_set_event_callback("setup_command", function(e)
    if not ui_get(gui.master) or not entity_get_local_player() or not entity_is_alive(entity_get_local_player()) or sl_user then return end
    local hasc4 = entity_get_classname(entity_get_player_weapon(entity_get_local_player())) == "CC4"
    local defusing = entity_get_prop(entity_get_local_player(), "m_bIsDefusing") == 1
    if defusing or hasc4 then
        if hasc4 then
            if e.in_attack == 1 then
                e.in_attack = 0 
                e.in_use = 1
            end
        end
        return
    end
    if ui_get(gui.epeek) then
        if e.chokedcommands == 0 then
            --ui_set(references.enabled[1], true)
            if client_key_state(0x45) then
                epeeking = true
            else
                epeeking = false
            end
            --if e.in_use == 1 then
                e.in_use = 0
            --end
        --[[elseif e.chokedcommands ~= 0 and epeeking then
            ui_set(references.enabled[1], false)
            setaaonce = true
        else
            if setaaonce then
                ui_set(references.enabled[1], true)
                setaaonce = false
            end]]
        end
    end
end)
client_set_event_callback("setup_command", function(e)
    if not ui_get(gui.master) or not entity_get_local_player() or not entity_is_alive(entity_get_local_player()) or sl_user then return end
    if not ui_get(gui.edgeyaw) then return end
    if epeeking then
        ui_set(references.edgeyaw, false)
        return
    end
    if not mright and not mleft and not mback then
        if lp_peeking() then
            ui_set(references.edgeyaw, false)
        elseif not lp_peeking() and not lp_head_hittable(bestenemy) then
            ui_set(references.edgeyaw, true)
        end
    elseif mright or mleft or mback then
        ui_set(references.edgeyaw, false)
    end
end)

client_set_event_callback("bullet_impact", function(c)
    if not ui_get(gui.master) then return end
	if entity_is_alive(entity_get_local_player()) then
        local ent = client_userid_to_entindex(c.userid)
        if entity_is_enemy(ent) and entity_is_alive(ent) then
            local ent_shoot = { entity_get_prop(ent, "m_vecOrigin") }
            ent_shoot[3] = ent_shoot[3] + entity_get_prop(ent, "m_vecViewOffset[2]")
            local player_head = { entity_hitbox_position(entity_get_local_player(), 0) }
            local closest = lmath_closestpoint(ent_shoot, { c.x, c.y, c.z }, player_head)
            local delta = { player_head[1]-closest[1], player_head[2]-closest[2] }
            local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)
            if math.abs(delta_2d) < 32 and ui_get(references.fakeyawlimit) > 34 then
                enemy_shot_angle = ui_get(references.bodyyaw[2])
                bodyflip = true
                enemy_missed = ent
                isbruteforcing = true
                client_delay_call(2.0, function()
                    isbruteforcing = false
                    enemy_shot_angle = 0
                end)
                client_delay_call(3.0, function()
                    enemy_missed = nil
                end)
            end
        end
    else
        isbruteforcing = false
    end
end)

client_set_event_callback("setup_command", function()
    if entity_is_alive(enemy_missed) and fakejitter then
        client_delay_call(1.5, function()
            antibrute_dormant = false
            enemy_missed = nil
            fakejitter = false
        end)
        return
    elseif not entity_is_alive(enemy_missed) then
        antibrute_dormant = false
        enemy_missed = nil
        fakejitter = false
    end
    if enemy_missed ~= nil then
        if entity_is_dormant(enemy_missed) and entity_is_alive(enemy_missed) and not fakejitter then
            fakejitter = true
            antibrute_dormant = true
        end
    end
end)
client_set_event_callback("weapon_fire", function(e)
    if not ui_get(gui.master) or ui_get(gui.doubletap) == "Off" or sl_user then return end
    if client_userid_to_entindex(e.userid) == entity_get_local_player() then
       dtcache.shot = dtcache.shot + 1
       pshot = true
    end
    client_delay_call(0.125, function()
        pshot = false
        actualshot = false
    end)
end)
client_set_event_callback("player_hurt", function(e)
    if not ui_get(gui.master) or not entity_is_alive(entity_get_local_player()) or sl_user then return end
    if client_userid_to_entindex(e.userid) == entity_get_local_player() and e.hitgroup ~= 6 and e.hitgroup ~= 7 then
        phurt = true
        phurtshooter = e.attacker
        --ui_set(references.bodyyaw[2], invertbodyyaw())
        client.delay_call(0.6, function()
            phurt = false
            phurtshooter = nil
        end)
    end
end)
client.set_event_callback("run_command", function(e)
    if pshot then
        local weapon_name = entity.get_classname(entity.get_player_weapon(entity_get_local_player()))
        if weapon_name == "CWeaponSSG08" or weapon_name == "CWeaponAWP" or weapon_name == "CKnife" or weapon_name == "CKnifeGG" or weapon_name == "CDecoyGrenade" or weapon_name == "CFlashbang" or weapon_name == "CHEGrenade" or weapon_name == "CIncendiaryGrenade" or weapon_name == "CItem_Healthshot" or weapon_name == "CMelee" or weapon_name == "CMolotovGrenade" or weapon_name == "CWeaponXM1014" or weapon_name == "CWeaponNOVA" or weapon_name == "CWeaponMag7" or weapon_name == "CWeaponSawedoff" or weapon_name == "CWeaponTaser" or weapon_name == "CSmokeGrenade" and not invertonce then
            bodyflip = true
            actualshot = true
            if ui_get(gui.fakelag) then
                ui_set(references.fakelag, false)
                client_delay_call(0.5, function()
                    ui_set(references.fakelag, true)  
                end)
            end
            dtcache.shot = 1
        else
            if ui_get(references.doubletap[1]) and ui_get(references.doubletap[2]) then
                if dtcache.shot == 2 then
                    bodyflip = true
                    actualshot = true
                    dtcache.shot = 1
                else
                    actualshot = false
                end
            else
                dtcache.shot = 1
                bodyflip = true
                actualshot = true
            end
        end
    end
    --if actualshot then
        --actualshot = false
    --end
end)
local function premiumdoubletap()
    if not ui_get(gui.master) or ui_get(gui.doubletap) == "Off" or ui_get(references.duckpeek) or not (ui_get(references.doubletap[1]) or ui.get(references.doubletap[2])) then
        return
    end
    local weapon_name = entity_get_classname(entity_get_player_weapon(entity_get_local_player()))
	if weapon_name == "CWeaponSSG08" or weapon_name == "CWeaponAWP" or weapon_name == "CKnife" or weapon_name == "CKnifeGG" or weapon_name == "CDecoyGrenade" or weapon_name == "CFlashbang" or weapon_name == "CHEGrenade" or weapon_name == "CIncendiaryGrenade" or weapon_name == "CItem_Healthshot" or weapon_name == "CMelee" or weapon_name == "CMolotovGrenade" or weapon_name == "CWeaponXM1014" or weapon_name == "CWeaponNOVA" or weapon_name == "CWeaponMag7" or weapon_name == "CWeaponSawedoff" or weapon_name == "CWeaponTaser" or weapon_name == "CSmokeGrenade" then
        ui_set(references.sv_maxusrcmdprocessticks, 16)
        cvar.cl_clock_correction:set_int(1)
        return
    end
    local max_ticks = 16 
    if (pshot and not actualshot) then
        if not inair then
            max_ticks = max_ticks + 2
            client_delay_call(0.5, function()
                ui_set(references.fakelag, false)
                ui_set(references.doubletap[1], false)
                client_delay_call(0.1, function()
                    ui_set(references.fakelag, true) 
                    ui_set(references.doubletap[1], true)
                end) 
            end)
        end
    else
        max_ticks = 16
    end
    if lp_peeking() then
        cvar.cl_clock_correction:set_int(0)
        if ui_get(gui.doubletap) == "Teleport" and l_velocity > 110 and entity.get_player_weapon(entity_get_local_player()) ~= 64 then
            ui_set(references.dtfakelag, 8)
        else
            ui_set(references.dtfakelag, 1)
        end
        if l_velocity > 180 then
            max_ticks = max_ticks + 4
        else
            max_ticks = max_ticks + 2
        end
    elseif dangerstate == "Very dangerous" then
        ui_set(references.dtfakelag, 1)
        max_ticks = 18
        cvar.cl_clock_correction:set_int(1)
    else
        ui_set(references.dtfakelag, 1)
        if l_velocity > 180 then
            max_ticks = max_ticks + 2
        end
        cvar.cl_clock_correction:set_int(1)
    end
    ui_set(references.sv_maxusrcmdprocessticks, max_ticks)
end
local function fakelag()
    if inair or phurt then
        ui_set(references.fakelagamount, "Fluctuate")
    elseif flags_landed(entity_get_local_player()) or (pshot and actualshot) then
        ui_set(references.fakelagamount, "Maximum")
    else
        ui_set(references.fakelagamount, "Dynamic")
    end
end
local function dynamicaa(ent)
    if entity_is_dormant(ent) then return end
    local entvel = {
            entity_get_prop(entity_get_local_player(), "m_vecVelocity[0]"),
            entity_get_prop(entity_get_local_player(), "m_vecVelocity[1]"),
            entity_get_prop(entity_get_local_player(), "m_vecVelocity[2]")
    }
    local entvelocity = math.sqrt(entvel[1] * entvel[1] + entvel[2] * entvel[2] + entvel[3] * entvel[3])
    local hx, hy, hz = entity_hitbox_position(entity_get_local_player(), 0)
    local lx, ly, lz = client_eye_position()
    local _, eye_yaw = entity_get_prop(entity_get_local_player(), "m_angEyeAngles")
    local desync = normalise_angle(eye_yaw - get_body_yaw(entity_get_local_player()))
    lx = lx + math_cos(math_rad(desync)) * 20
    ly = ly + math_sin(math_rad(desync)) * 12
    lz = hz
    local ex, ey, ez = entity_get_prop(ent, "m_vecOrigin")
    local vx, vy, vz = entity_get_prop(ent, "m_vecViewOffset")
    ex, ey, ez = ex + vx, ey + vy, ez + vz
    local _, damage = client_trace_bullet(ent, ex, ey, ez, lx, ly, lz,true)
    local rdamage = ui_get(gui.presets) == 2 and 55 or ui_get(gui.presets) == 1 and 25
    if damage >= rdamage then
        dynamic_lastent = dynamic_ent
        dynamic_ent = ent
    else
        dynamic_lastent = dynamic_ent
        dynamic_ent = nil
    end
    if dynamic_time <= globals_realtime() then 
        if ent ~= nil and dynamic_ent ~= nil and l_velocity > 5 and dynamic_ent ~= dynamic_lastent then 
            local player_resource = entity_get_player_resource()
            if player_resource == nil then return end
            local ping = entity_get_prop(player_resource, "m_iPing", dynamic_ent)
            local pingticks = time_to_ticks(ping / 1000) + 1
            if entvelocity <= 210 + 1 then
                dynamic_ticks = dynamic_ticks + 1
            end
            if dynamic_ticks > pingticks then
                dynamic_time = globals_realtime() + 0.5
                bodyflip = true
            end
        else	
            dynamic_ticks = 0
        end
    end
end
local function betterfakeyaw()
    if (pshot and actualshot) or inair then
        local reset = 24
        client_delay_call(0.09, function()
            reset = 26
        end)
        return 32
    end
    local fakedelta = multi_contains(ui_get(gui.fakeyaw), "Low delta") and 34 or 36
    local adaptive = multi_contains(ui_get(gui.fakeyaw), "Velocity fix")
    if ui_get(references.slowmotion[1]) and ui_get(references.slowmotion[2]) and l_velocity > 5 then
        fakedelta = 20
    end
    if flags_landed(entity_get_local_player()) then
        ui.set(references.yawjitter[2], 66)
        return 51
    end
    if not adaptive then
        return fakedelta
    end
    local wpnid = entity_get_player_weapon(entity_get_local_player())
    local wpnclass = entity_get_prop(wpnid, "m_iItemDefinitionIndex")
    local weapon = csgo_weapons[wpnclass]
    weapontype = weapon.type
    local velperc = weapon.max_player_speed / 100
    local f = l_velocity / velperc
    local mind = multi_contains(ui_get(gui.fakeyaw), "Low delta") and 34 or 35
    local minimumdlt = mind / 100
    local finalvelocity = f * ((fakedelta / 100) - minimumdlt) + mind
    if finalvelocity > 60 then
        finalvelocity = 50
    end
    return math_floor(finalvelocity)
end
local function setantiaim()
    shitjitter = not shitjitter
    local tcrouching = flags_crouching(entity_get_local_player()) and entity_get_prop(entity_get_local_player(), "m_iTeamNum") == 2
    local ctcrouching = flags_crouching(entity_get_local_player()) and entity_get_prop(entity_get_local_player(), "m_iTeamNum") == 3
    local smartmode = ui_get(gui.presets)
    ui_set(references.bodyyaw[1], "Jitter")
    ui_set(references.yawjitter[1], "Center")
    ui_set(references.yawjitter[2], 43)
    isfreestanding = false
    if not mleft and not mright then
        ui_set(references.yaw[2], 5)
    end
    if phurtshooter ~= nil and phurt then
        bestenemy = phurtshooter
    elseif enemy_missed ~= nil and isbruteforcing then
        bestenemy = enemy_missed
    else
        --if bestenemy == nil then
            bestenemy = (closest_enemy_crosshair ~= nil and not entity_is_dormant(closest_enemy_crosshair) and closest_enemy_crosshair) or (closest_enemy ~= nil and closest_enemy) or nil
        --end
    end
    local freestanddata = dofreestanding()
    local freestandangle =  freestanddata.fraction < 1 and (freestanddata.var > 0 and 5 or 0) or 0 --(freestand1 == 45 or freestand1 == -45) and freestand1 or (freestand2 == 45 or freestand2 == -45) and freestand2 or 0 
    if epeeking then
        ui.set(references.bodyyaw[1], "Jitter")
        ui_set(references.fakeyawlimit, 57)                 
        ui_set(references.bodyyaw[2], freestandangle)
        return
    end
    ui_set(references.fakeyawlimit, betterfakeyaw())
    if ui_get(gui.freestandingopts) == "Reverse" then
        freestandangle = -freestandangle
    end 
    if ui_get(gui.freestandingopts) == "Experimental" then
        if lp_peeking() then
            freestandangle = -freestandangle
            if lp_head_hittable(bestenemy) and globals_curtime() - lasttimenothittable > 2 or isbruteforcing then
                freestandangle = -freestandangle
            end
        end
    end
    storedfreestandingangle = freestandangle
    --print(bestenemy)
    if bestenemy ~= nil and not (isabdone and lp_head_hittable(bestenemy)) then
        if not isbruteforcing and not (pshot and actualshot) and (freestanddata.fraction < 1) then
            --freestandangle = freestandangle * 2
            isfreestanding = true
            ui_set(references.bodyyaw[2], freestandangle)
            --[[if freestandangle == 45 and ui_get(references.bodyyaw[2]) > 0 then
                bodyflip = true
            elseif freestandangle == -45 and ui_get(references.bodyyaw[2]) < 0 then
                bodyflip = true
            end]]
        end
        --if lp_head_hittable(bestenemy) and not isbruteforcing and not (pshot and actualshot) then
            --bodyflip = true
        --end
        if smartmode == 0 then
            if isbruteforcing or (pshot and actualshot) then
                ui_set(references.yawjitter[2], 4)
            end
            if not mleft and not mright and not mback then
                --ui_set(references.yaw[2], (not ctcrouching and not inair and entity_get_prop(entity_get_local_player(), "m_iTeamNum") == 3 and -13) or 0)
                ui_set(references.yaw[2], ui_get(references.bodyyaw[2]) > 0 and 0 or -15)
            end
        else
            dynamicaa(bestenemy)
            if smartmode == 1 then
                if not mleft and not mright and not mback then
                    --ui_set(references.yaw[2], (not ctcrouching and not inair and entity_get_prop(entity_get_local_player(), "m_iTeamNum") == 3 and -13) or 0)
                    ui_set(references.yaw[2], ui_get(references.bodyyaw[2]) > 0 and 15 or -10)
                end
                if dangerstate == "Dangerous" or "Very dangerous" then
                    if multi_contains(ui_get(gui.jitters), "Dangerous") then
                        ui_set(references.yawjitter[2], ui_get(gui.dangerousslider))
                    end
                end
                if tcrouching and weapontype == "sniperrifle" then
                    if not mleft and not mright and not mback then
                        ui_set(references.yaw[2], 5)
                    end
                    ui_set(references.yawjitter[1], "Center")
                    ui_set(references.fakeyawlimit, 32)
                elseif ctcrouching then
                    ui_set(references.fakeyawlimit, math_random(48,60))
                end
                if isbruteforcing or (pshot and actualshot) then
                    ui_set(references.yawjitter[2], 4)
                end
            elseif smartmode == 2 then
                if not mleft and not mright and not mback then
                    --ui_set(references.yaw[2], (not ctcrouching and not inair and entity_get_prop(entity_get_local_player(), "m_iTeamNum") == 3 and -13) or 0)
                    ui_set(references.yaw[2], ui_get(references.bodyyaw[2]) > 0 and 0 or 3)
                end
                --ui_set(references.yaw[2], (not ctcrouching and not inair and entity_get_prop(entity_get_local_player(), "m_iTeamNum") == 3 and 13) or 0)
                if dangerstate == "Very dangerous" then
                    ui_set(references.yawjitter[2], ui_get(gui.dangeroussliderverydangerous))
                    ui_set(references.bodyyaw[1], "Jitter")
                    ui_set(references.bodyyaw[2], 0)
                    ui_set(references.fakeyawlimit, 60)
                    ui_set(references.yaw[2], 0)
                    if lp_peeking() then
                        ui_set(references.bodyyaw[1], "Jitter")
                    end
                elseif dangerstate == "Dangerous" then
                    if multi_contains(ui_get(gui.jitters), "Dangerous") then
                        ui_set(references.bodyyaw[1], "Jitter")
                        ui_set(references.fakeyawlimit, math_random(57, 60))
                        ui_set(references.fakelaglimit, 15)                        
                        ui_set(references.yawjitter[2], ui_get(gui.dangeroussliderdangerous))
                    elseif not mleft and not mright and not mback then
                        ui_set(references.yaw[2], 0)
                    end
                elseif dangerstate == "Safe" then
                    if multi_contains(ui_get(gui.jitters), "Dangerous") then
                        ui_set(references.yawjitter[2], ui_get(gui.dangerousslidersafe))
                        ui_set(references.bodyyaw[1], "Jitter")
                        ui_set(references.fakelaglimit, 15)
                    elseif not mleft and not mright and not mback then
                        ui_set(references.yaw[2], 0)
                    end
                end
                if pshot and (pshot and actualshot) then
                    ui_set(references.bodyyaw[1], "Jitter")
                end
                if tcrouching and weapontype == "sniperrifle" then
                    ui_set(references.bodyyaw[1], "Jitter")
                    if not mleft and not mright and not mback then
                        ui_set(references.yaw[2], 0)
                    end
                    ui_set(references.yawjitter[2], 66)
                    ui_set(references.fakeyawlimit, 59)
                elseif ctcrouching then
                    if not mleft and not mright and not mback then
                        ui_set(references.yaw[2], 0)
                    end
                    ui_set(references.fakeyawlimit, math_random(48,59))
                end
            end
        end
        if multi_contains(ui_get(gui.jitters), "Low, yaw") and not flags_crouching() then
            if ui_get(references.yawjitter[2]) < 4 then
                ui_set(references.yawjitter[2], 4)
            else
                local limit = ui_get(references.fakeyawlimit)
                if limit > 58 then
                    limit = 58
                end
                ui_set(references.fakeyawlimit, math_random(limit - 2, limit + 2))
            end
        end
        if multi_contains(ui_get(gui.jitters), "Agressive") then
            if lp_peeking() and dangerstate ~= "Very dangerous" and not flags_crouching(entity_get_local_player()) and l_velocity > 59 then --and ((lp_head_hittable(bestenemy) and globals_curtime() - lasttimenothittable >= 1) or not lp_head_hittable(bestenemy)) then
                ui_set(references.yawjitter[2], 66)
            end
        end
        if multi_contains(ui_get(gui.jitters), "High, body") then
            ui_set(references.yawjitter[1], "Center")
            if not isbruteforcing then
                ui_set(references.bodyyaw[1], "Static")
                --bodyflip = true
            end
            --ui_set(references.bodyyaw[1], "Jitter")
        end
        if flags_landed(entity_get_local_player()) then
            ui_set(references.yawjitter[1], "Center")
        end
        if isbruteforcing then
            abdone = true
            abdonetime = globals_curtime() + 1
        elseif abdone and not isbruteforcing then
            if globals_curtime() > abdonetime then
                isabdone = true
                client_delay_call(0.75, function()
                    abdone = false
                    isabdone = false
                end)
            end
        end
    else
        if abdone then
            client_delay_call(0.75, function()
                abdone = false
                isabdone = false
            end)
        end
        ui_set(references.bodyyaw[1], enemies_count > 2 and "Static" or "Jitter")
        ui_set(references.yawjitter[2], 0)
        if not mleft and not mright and not mback then
            ui_set(references.yaw[2], 0)
        end
        ui_set(references.fakeyawlimit, 50)
    end
    if desyncside == "left" and ui_get(references.yawjitter[2]) > 0 then
        local leftj = ui_get(references.yawjitter[2])
        if not mleft and not mright and not mback then
            --ui_set(references.yaw[2], leftj/1.4)
        end
        ui_set(references.yawjitter[2], -leftj)
    end
    if bodyflip and not tcrouching then
        ui_set(references.bodyyaw[2], laa_invertbodyyaw())
        if ui_get(references.bodyyaw[2]) < 0 then
            desyncside = "left"
        elseif ui_get(references.bodyyaw[2]) > 0 then
            desyncside = "right"
        end
        bodyflip = false
    end
end


client_set_event_callback("run_command", function(e)
    if not ui_get(gui.master) or sl_user then return end
    local vel = {
        entity_get_prop(entity_get_local_player(), "m_vecVelocity[0]"),
	    entity_get_prop(entity_get_local_player(), "m_vecVelocity[1]"),
	    entity_get_prop(entity_get_local_player(), "m_vecVelocity[2]")
    }
    l_velocity = math.sqrt(vel[1] * vel[1] + vel[2] * vel[2] + vel[3] * vel[3])
    inair = bit.band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 0
    setantiaim()
    premiumdoubletap()
    if not lp_head_hittable(bestenemy) then
        lasttimenothittable = globals_curtime()
    end
    ui_set(references.silent, not pshot)
    if ui_get(gui.fakelag) then 
        fakelag()
    end
    dangerstate = "Safe"
    if entity_is_dormant(bestenemy) then
        dangerstate = "Dangerous"
    end
    if ui_get(references.doubletap[1]) and ui_get(references.doubletap[2]) then
        if not dtcharged() then
            dangerstate = "Dangerous"
        end
    end
    if enemies_count > 3 then
        dangerstate = "Very dangerous"
    end
    if antibrute_dormant or phurt then
        dangerstate = "Very dangerous"
    end
    if ui_get(gui.betteryawbase) and not mleft and not mright and not mback then
        if inair then
            ui.set(references.yaw[2], 0)
            ui_set(references.yaw[2], ui_get(gui.yawinair))
            ui_set(references.yawjitter[1], "Center")
            ui_set(references.yawjitter[2], ui_get(gui.dangeroussliderinair))
            ui_set(references.bodyyaw[2], ui_get(gui.bodyyawinair))
            ui_set(references.bodyyaw[1], "Jitter")
            ui_set(references.yawbase, "At targets")
            ui_set(references.fakeyawlimit, ui_get(gui.fakeyawlimitinair))
            return
        end

        if ui.get(references.slowmotion[2]) then
            ui.set(references.yaw[2], 13)
            ui_set(references.yaw[2], ui_get(gui.yawslowmo))
            ui.set(references.fakeyawlimit, math_random(49, 59))
            ui_set(references.yawjitter[2], ui_get(gui.dangeroussliderslowwalk))
            ui_set(references.bodyyaw[2], ui_get(gui.bodyyawslowwalk))
            return
        end
        if bestenemy ~= nil then
            if entity_is_dormant(bestenemy) then
                ui_set(references.yawbase, "At targets")
            elseif not entity_is_dormant(bestenemy) then
                if bestenemy == closest_enemy or bestenemy == enemy_missed then
                    ui_set(references.yawbase, "At targets")
                else
                    if lp_peeking() and lp_head_hittable(bestenemy) and globals_curtime() - lasttimenothittable >= 1 then
                        ui_set(references.yawbase, "Local view")
                    end
                end
            --else
                --ui_set(references.yawbase, "Local view")
            end
        end
        if enemies_count > 3 and closest_enemy == nil then
            if lp_peeking() and lp_head_hittable(bestenemy) and globals_curtime() - lasttimenothittable >= 1 then
                ui_set(references.yawbase, "Local view")
            end
        end
    end
end)
local function angleindicator(x, y, r, g, b)
    local h_head_pos = { entity_get_prop(entity_get_local_player(), "m_angAbsRotation") }
    local cam_angles = { client_camera_angles() }
    rot = cam_angles[2] - h_head_pos[2]-120
    local acolor = { ui_get(gui.indicator_anglecol) }
    if ui.get(gui.indicator_angle) == "Clean" then
        renderer_circle_outline(x, y, r, g, b, 135, 18 - 4, rot -1, 0.28, 2)
        renderer_circle_outline(x, y, r, g, b, 190, 18 - 2, rot -3, 0.29, 2)
        renderer_circle_outline(x, y, r, g, b, 255, 18, rot - 5, 0.3, 2)
    elseif ui.get(gui.indicator_angle) == "Fire" then
        renderer_circle_outline(x, y, r, g, b, 135, 18 - 4, rot + 10, 0.20, 2)
        renderer_circle_outline(x, y, r, g, b, 190, 18 - 2, rot + 5, 0.25, 2)
        renderer_circle_outline(x, y, r, g, b, 255, 18, rot - 5, 0.3, 2)
    end
    if entity_get_prop(entity_get_game_rules(), "m_bFreezePeriod") == 1 then
        renderer_circle_outline(x, y, 20, 20, 20, 255, 18 + 2, 140, 0.5, 2)
        renderer_circle_outline(x, y, 20, 20, 20, 255, 18 + 2, 320, 0.5, 2)
    else
        if ui_get(references.bodyyaw[2]) < 0 then
            renderer_circle_outline(x, y, acolor[1], acolor[2], acolor[3], acolor[4], 18 + 2, 320, 0.5, 2)
           --renderer_circle_outline(x, y, 128, 128, 128, 200, 18 + 3, 320, 0.5, 1)
            renderer_circle_outline(x, y, 20, 20, 20, 255, 18 + 2, 140, 0.5, 2)
            renderer_circle_outline(x, y, 20, 20, 20, 120, 18 + 3, 140, 0.5, 2)
        elseif ui_get(references.bodyyaw[2]) > 0 then
            renderer_circle_outline(x, y, 20, 20, 20, 255, 18 + 2, 320, 0.5, 2)
            renderer_circle_outline(x, y, 20, 20, 20, 120, 18 + 3, 320, 0.5, 1)
            renderer_circle_outline(x, y, acolor[1], acolor[2], acolor[3], acolor[4], 18 + 2, 140, 0.5, 2)
            --renderer_circle_outline(x, y, 128, 128, 128, 200, 18 + 3, 140, 0.5, 1)
        end
    end
end
local function aaarows(x, y, r, g, b, a)
    local arrowalpha = math_sin(math_abs(-math_pi + (globals_curtime() * (1 / 0.75)) % (math_pi * 2))) * a
    arrowalpha = arrowalpha + (255 - a)
    local colorsright =  { 180, 180, 180, 220 }
    local colorsleft = { 180, 180, 180, 220 }
    if desyncside == "left" then
        colorsright =  { r, g, b, arrowalpha }
        colorsleft = { 180, 180, 180, 220 }
    elseif desyncside == "right" then
        colorsright =  { 180, 180, 180, 220 }
        colorsleft = { r, g, b, arrowalpha }
    end
    if enemy_shot_angle ~= nil or enemy_shot_angle ~= 0 then
        if enemy_shot_angle > 0 then
            renderer_text(x - 60, y + 30, colorsleft[1], colorsleft[2], colorsleft[3], colorsleft[4], "c+", 0, "\226\174\156")
        elseif enemy_shot_angle < 0 then
            renderer_text(x + 60, y + 30, colorsright[1], colorsright[2], colorsright[3], colorsright[4], "c+", 0, "\226\174\158")
        end
    end
    renderer_text(x + 45, y + 30, colorsright[1], colorsright[2], colorsright[3], colorsright[4], "c+", 0, "\226\174\158")
    renderer_text(x - 45, y + 30, colorsleft[1], colorsleft[2], colorsleft[3], colorsleft[4], "c+", 0, "\226\174\156")
    
end
local function dooutlinedtxt(x, y, flags, text, r, g, b)
    renderer_text(x + 1, y, 0, 0, 0, 200, flags, 0, text)
    renderer_text(x - 1, y, 0, 0, 0, 200, flags, 0, text)
    renderer_text(x, y + 1, 0, 0, 0, 200, flags, 0, text)
    renderer_text(x, y - 1, 0, 0, 0, 200, flags, 0, text)
    renderer_text(x, y, r, g, b, 255, flags, 0, text)
end
local function dogradient(x, y, r, g, b, thickness)
    local lowerbodyvalue = math.min(57, math.abs(entity_get_prop(entity_get_local_player(), 'm_flPoseParameter', 11)*120-60))
    if lowerbodyvalue < 5 then
        lowerbodyvalue = 5
    end
    lowerbodyvalue = lowerbodyvalue / 0.6
    renderer_gradient(x, y, -lowerbodyvalue*0.4, thickness, r/1.78, g/1.78, b/1.78, 200, r, g, b, 255, true)
    renderer_gradient(x, y, lowerbodyvalue*0.4, thickness, r/1.78, g/1.78, b/1.78, 200, r, g, b, 255, true)
end 

local screen = {client.screen_size()}
local center = {screen[1]/2, screen[2]/2}
    --dogradient(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, maincolss[1], maincolss[2], maincolss[3], paintindicator.flags.linethickness)
client_set_event_callback("paint", function()
    if not ui_get(gui.master) or not entity_is_alive(entity_get_local_player()) or sl_user then return end
    local screensize = { client_screen_size() }
    local local_weapon = entity_get_player_weapon(entity_get_local_player())
    local weapon_name = entity_get_classname(local_weapon)
    paintindicator.flags.position = 30
    if ui.get(gui.master) then
        local maincolss = { ui_get(gui.indicator_maincolorr) }
        renderer_text(screensize[1]/2, screensize[2]/2 + 22, maincolss[1], maincolss[2], maincolss[3], 255, paintindicator.flags.flags, 0, "HELLYAW" )
    end

    local safeindic = { ui_get(gui.indicator_safe) }
    local dangerousindic = { ui_get(gui.indicator_dangerous) }
    local vdangerousindic = { ui_get(gui.indicator_verydangerous) }


    --dooutlinedtxt(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, paintindicator.flags.mflags, paintindicator.main.options[1], maincols[1], maincols[2], maincols[3])
    --paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
    --dogradient(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, maincols[1], maincols[2], maincols[3], paintindicator.flags.linethickness)
    --paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
    if ui_get(gui.presets) ~= 0 then
        if dangerstate == "Safe" then
            renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, safeindic[1], safeindic[2], safeindic[3], 255, paintindicator.flags.flags, 0, paintindicator.main.options[2][1])
        elseif dangerstate == "Dangerous" then
            renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, dangerousindic[1], dangerousindic[2], dangerousindic[3], 255, paintindicator.flags.flags, 0, paintindicator.main.options[2][2])
        elseif dangerstate == "Very dangerous" then
            renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, vdangerousindic[1], vdangerousindic[2], vdangerousindic[3], 255, paintindicator.flags.flags, 0, paintindicator.main.options[2][3])
        else
            renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, safeindic[1], safeindic[2], safeindic[3], 255, paintindicator.flags.flags, 0, paintindicator.main.options[2][4])
        end
        
        if ui_get(gui.manual_left) then
            local maincols = { ui_get(gui.indicator_maincolor) }
            renderer_text(center[1] - 43, center[2] - 3, maincols[1], maincols[2], maincols[3], 255, "c+d", 0, "⮜" )
        end

        if ui_get(gui.manual_right) then
            local maincols = { ui_get(gui.indicator_maincolor) }
            renderer_text(center[1] + 43, center[2] - 3, maincols[1], maincols[2], maincols[3], 255, "c+d", 0, "⮞" )
        end


        paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
    end 
    if entity_get_prop(entity_get_game_rules(), "m_bFreezePeriod") ~= 1 and ui_get(references.doubletap[1]) and ui_get(references.doubletap[2]) and not ui_get(references.duckpeek) then 
        if weapon_name == "CWeaponSSG08" or weapon_name == "CWeaponAWP" or weapon_name == "CKnife" or weapon_name == "CKnifeGG" or weapon_name == "CDecoyGrenade" or weapon_name == "CFlashbang" or weapon_name == "CHEGrenade" or weapon_name == "CIncendiaryGrenade" or weapon_name == "CItem_Healthshot" or weapon_name == "CMelee" or weapon_name == "CMolotovGrenade" or weapon_name == "CWeaponXM1014" or weapon_name == "CWeaponNOVA" or weapon_name == "CWeaponMag7" or weapon_name == "CWeaponSawedoff" or weapon_name == "CWeaponTaser" or weapon_name == "CSmokeGrenade"
        then
            renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, 255, 40, 40, 255, paintindicator.flags.flags, 0, paintindicator.main.options[4][3])
            paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
        else
            if dtcharged() then
                renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, 148, 190, 12, 255, paintindicator.flags.flags, 0, paintindicator.main.options[4][2])
                paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
            else
                local dtr, dtg, dtb = dtcolor(fade)
                renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, dtr, dtg, dtb, 255, paintindicator.flags.flags, 0, paintindicator.main.options[4][1])
                local txt = { renderer_measure_text(paintindicator.flags.flags, "CHARGING") }
                local circlefade = fade / 30
                if circlefade > 1 then
                    circlefade = 1
                end
                --renderer_circle_outline(screensize[1]/2 + txt[1] / 1.5, screensize[2]/2 + paintindicator.flags.position + txt[2] / 4.5, dtr, dtg, dtb, 255, txt[1] / 11, 0, circlefade, 1)
                paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
            end
        end
    elseif ui_get(references.duckpeek) then
        if flags_fakeduck() == 4 then
            renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, 255, 255, 255, 255, paintindicator.flags.flags, 0, paintindicator.main.options[3])
            paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
        else
            renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, 200, 200, 200, 255, paintindicator.flags.flags, 0, paintindicator.main.options[3])
            paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
        end
    end
    if not ui_get(gui.indicators) then
        if isbruteforcing or antibrute_dormant or phurt or lp_peeking() then
            --aaarows(screensize[1]/2, screensize[2]/2)
        end
        return
    end
    local indicols = { ui_get(gui.indicator_color) }
    if ui_get(gui.indicator_angle) ~= "Off" then
        angleindicator(screensize[1]/2, screensize[2]/2, indicols[1], indicols[2], indicols[3])
    end
    if isbruteforcing or antibrute_dormant or phurt or lp_peeking() then
        aaarows(screensize[1]/2, screensize[2]/2, indicols[1], indicols[2], indicols[3], indicols[4])
    end
    local newcols = {
        onshot = { 218, 139, 230 },
        baim = { 189, 151, 255 },
        override = { 210, 50, 73 },
        fsafe = { 160, 200, 180 },
        freestnd = { 26, 219, 219 }
    }
    if ui_get(gui.indicator_coverride) then
        newcols = {
            onshot = { indicols[1], indicols[2], indicols[3] },
            baim = { indicols[1], indicols[2], indicols[3] },
            override = { indicols[1], indicols[2], indicols[3] },
            fsafe = { indicols[1], indicols[2], indicols[3] },
            freestnd = { indicols[1], indicols[2], indicols[3] }
        }
    end
    if ui_get(references.onshot[1]) and ui_get(references.onshot[2]) and not ui_get(references.duckpeek) then
        renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, newcols.onshot[1], newcols.onshot[2], newcols.onshot[3], 255, paintindicator.flags.flags, 0, paintindicator.additional[1])
        paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
    end 
    if ui_get(references.forcebaim) then
        renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, newcols.baim[1], newcols.baim[2], newcols.baim[3], 255, paintindicator.flags.flags, 0, paintindicator.additional[2])
        paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
    end 
    if ui_get(references.aacorrectionor) then
        renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, newcols.override[1], newcols.override[2], newcols.override[3], 255, paintindicator.flags.flags, 0, paintindicator.additional[3])
        paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
    end 
    if ui_get(references.forcesafe) then
        renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, newcols.fsafe[1], newcols.fsafe[2], newcols.fsafe[3], 255, paintindicator.flags.flags, 0, paintindicator.additional[4])
        paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
    end 
    if ui_get(references.freestand[2]) then
        renderer_text(screensize[1]/2, screensize[2]/2 + paintindicator.flags.position, newcols.freestnd[1], newcols.freestnd[2], newcols.freestnd[3], 255, paintindicator.flags.flags, 0, paintindicator.additional[5])
        paintindicator.flags.position = paintindicator.flags.position + paintindicator.flags.space
    end
end)




local function reset()
    antibrute_dormant = false
    enemy_missed = nil
    fakejitter = false
    dtcache.shot = 1
    isfreestanding = false
    isbruteforcing = false
    closest_enemydist = 9999
    closest_enemy = nil
    closest_enemy_crosshair = nil
    enemy_shot_angle = 0
    enemies_count = 0
    dangerstate = "Safe"
    actualshot = false
    abdone = false
    abdonetime = 0
end
client_set_event_callback("round_start", reset)
client_set_event_callback("game_newmap", reset)
client_set_event_callback("cs_game_disconnected", reset)
client_set_event_callback("shutdown", function()
    client_delay_call(0.1, client_set_clan_tag)
    ui_set(references.fakeyawlimit, 60)
    ui_set(references.yaw[2], 0)
end)
local function setupuserinterface()
    local enabled = ui_get(gui.master)
    if sl_user and searched then
        enabled = false
    end
    ui_set_visible(gui.presets, enabled)
    ui_set_visible(gui.dangerousslider, enabled and ui_get(gui.presets) ~= 0 and multi_contains(ui_get(gui.jitters), "Dangerous"))
    ui_set_visible(gui.dangeroussliderslowwalk, enabled and ui_get(gui.presets) ~= 0 and multi_contains(ui_get(gui.jitters), "Dangerous"))
    ui_set_visible(gui.dangeroussliderinair, enabled and ui_get(gui.presets) ~= 0 and multi_contains(ui_get(gui.jitters), "Dangerous"))
    ui_set_visible(gui.dangerousslidersafe, enabled and ui_get(gui.presets) ~= 0 and multi_contains(ui_get(gui.jitters), "Dangerous"))
    ui_set_visible(gui.dangeroussliderdangerous, enabled and ui_get(gui.presets) ~= 0 and multi_contains(ui_get(gui.jitters), "Dangerous"))
    ui_set_visible(gui.dangeroussliderverydangerous, enabled and ui_get(gui.presets) ~= 0 and multi_contains(ui_get(gui.jitters), "Dangerous"))
    ui_set_visible(gui.bodyyawinair, enabled and ui_get(gui.presets) ~= 0 and multi_contains(ui_get(gui.jitters), "Custom Body"))
    ui_set_visible(gui.fakeyawlimitinair, enabled and ui_get(gui.presets) ~= 0 and multi_contains(ui_get(gui.jitters), "Custom Body"))
    ui_set_visible(gui.bodyyawslowwalk, enabled and ui_get(gui.presets) ~= 0 and multi_contains(ui_get(gui.jitters), "Custom Body"))
    ui_set_visible(gui.yawinair, enabled and ui_get(gui.presets) ~= 0 and multi_contains(ui_get(gui.jitters), "Custom Body"))
    ui_set_visible(gui.yawslowmo, enabled and ui_get(gui.presets) ~= 0 and multi_contains(ui_get(gui.jitters), "Custom Body"))
    ui_set_visible(gui.edgeyaw, enabled)
    ui_set_visible(gui.enable, enabled)
    ui_set_visible(gui.enableLegs, enabled)
    ui_set_visible(gui.freestandingopts, enabled)
    ui_set_visible(gui.fakeyaw, enabled)
    ui_set_visible(gui.fakelag, enabled)
    ui_set_visible(gui.manual, enabled)
    if ui_get(gui.manual) then
        ui_set_visible(gui.manual_back, enabled)
        ui_set_visible(gui.manual_right, enabled)
        ui_set_visible(gui.manual_left, enabled)
    else
        ui_set_visible(gui.manual_back, false)
        ui_set_visible(gui.manual_right, false)
        ui_set_visible(gui.manual_left, false)
    end
    ui_set_visible(gui.epeek, enabled)
    ui_set_visible(gui.edgeyaw, enabled)
    ui_set_visible(gui.enable, enabled)
    ui_set_visible(gui.enableLegs, enabled)
    ui_set_visible(gui.jitters, enabled)
    ui_set_visible(gui.betteryawbase, enabled)
    ui_set_visible(gui.indicators, enabled)
    if ui_get(gui.indicators) then
        ui_set_visible(gui.indicator_color, enabled)
        ui_set_visible(gui.indicator_coverride, enabled)
        ui_set_visible(gui.indicator_angle, enabled)
        ui_set_visible(gui.indicator_anglecol, enabled)
    else
        ui_set_visible(gui.indicator_color, false)
        ui_set_visible(gui.indicator_coverride, false)
        ui_set_visible(gui.indicator_angle, false)
        ui_set_visible(gui.indicator_anglecol, false)
    end
    ui_set_visible(gui.doubletap, enabled)
end
setupuserinterface()
client_set_event_callback("post_render", function()
    setupuserinterface()
end)
ui_set_callback(gui.betteryawbase, function()
    ui_set(references.yawbase, "At targets")
end)
ui_set_callback(gui.edgeyaw, function()
    ui_set(references.edgeyaw, false)
end)
ui_set_callback(gui.betteryawbase, function()
    ui_set(references.yawbase, "At targets")
end)

local fakelag = ui.reference("AA", "Fake lag", "Limit")
local ground_ticks, end_time = 1, 0


client.set_event_callback("pre_render", function()

    if ui.get(gui.enable) then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
    end
end)

local sv_maxusrcmdprocessticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
ui.set_visible(sv_maxusrcmdprocessticks, true)

ui.set(sv_maxusrcmdprocessticks, 22)



        ---------------------------------------------
--[MISC]            
---------------------------------------------
    client.set_event_callback("net_update_end", function()
        if ui.get(gui.enableLegs) == "Exploit" then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
        end
    end)
    
    client.set_event_callback("paint", function()
        legChanger = math.random(1,4)
        if ui.get(gui.enableLegs) == "Random" then
            if legChanger == 1 then
                ui.set(references.legmovement, "Off")
            elseif legChanger == 2 then
                ui.set(references.legmovement, "Always slide")
            elseif legChanger == 3 then
                ui.set(references.legmovement, "Off")
            elseif legChanger == 4 then
                ui.set(references.legmovement, "Never slide")
            else
                ui.set(references.legmovement, "Off")
            end
        end
        if ui.get(gui.enableLegs) == "Jitter" then
            if globals.tickcount()%5 < 1 then
                ui.set(references.legmovement, "Off")
            elseif globals.tickcount()%6 < 1 then
                ui.set(references.legmovement, "Always slide")
            elseif globals.tickcount()%8< 1 then
                ui.set(references.legmovement, "Off")
            elseif globals.tickcount()%13 < 2 then
                ui.set(references.legmovement, "Never slide")
            elseif globals.tickcount()%15 < 1 then
                ui.set(references.legmovement, "Off")
            elseif globals.tickcount()%20 < 1 then
                ui.set(references.legmovement, "Always slide")
            elseif globals.tickcount()%25 < 1 then
                ui.set(references.legmovement, "Off")
            elseif globals.tickcount()%30 < 2 then
                ui.set(references.legmovement, "Never slide")
            else
                ui.set(references.legmovement, "Off")
            end
        end
        p = client.random_int(1, 3)
        if ui.get(gui.enableLegs) == "Exploit" then
            if p == 1 then
                ui.set(references.ref_legmovement, "Off")
            elseif p == 2 then
                ui.set(references.legmovement, "Always slide")
            elseif p == 3 then
                ui.set(references.legmovement, "Off")
            end
        end
    end)








client_set_event_callback("paint", function()
    local scrsize_x, scrsize_y = client.screen_size()
local center_x, center_y = scrsize_x / 2, scrsize_y / 2

local screen = { client.screen_size() }
local center = { screen[1] / 2, screen[1] / 2 }

local w, h = client.screen_size()
local pos_x =  w / 2
local pos_y =  h / 2


local w, h = client.screen_size()
local pos_x =  w / 2
local pos_y =  h / 2
local offset = -10


  end)

  
-- ANTIAIM REFERENCES

local ffi = require("ffi")
local js = panorama['open']()
local MyPersonaAPI, LobbyAPI, PartyListAPI, FriendsListAPI, GameStateAPI = js['MyPersonaAPI'], js['LobbyAPI'], js['PartyListAPI'], js['FriendsListAPI'], js['GameStateAPI']

local android_notify=(function()local a={callback_registered=false,maximum_count=7,data={}}function a:register_callback()if self.callback_registered then return end;client.set_event_callback('paint_ui',function()local b={client.screen_size()}local c={56,56,57}local d=5;local e=self.data;for f=#e,1,-1 do self.data[f].time=self.data[f].time-globals.frametime()local g,h=255,0;local i=e[f]if i.time<0 then table.remove(self.data,f)else local j=i.def_time-i.time;local j=j>1 and 1 or j;if i.time<0.5 or j<0.5 then h=(j<1 and j or i.time)/0.5;g=h*255;if h<0.2 then d=d+15*(1.0-h/0.2)end end;local k={renderer.measure_text(nil,i.draw)}local l={b[1]/2-k[1]/2+3,b[2]-b[2]/100*17.4+d}renderer.circle(l[1],l[2],c[1],c[2],c[3],g,20,180,0.5)renderer.circle(l[1]+k[1],l[2],c[1],c[2],c[3],g,20,0,0.5)renderer.rectangle(l[1],l[2]-20,k[1],40,c[1],c[2],c[3],g)renderer.text(l[1]+k[1]/2,l[2],255,255,255,g,'c',nil,i.draw)d=d-50 end end;self.callback_registered=true end)end;function a:paint(m,n)local o=tonumber(m)+1;for f=self.maximum_count,2,-1 do self.data[f]=self.data[f-1]end;self.data[1]={time=o,def_time=o,draw=n}self:register_callback()end;return a end)()

ffi.cdef[[
  typedef struct
  {
    int64_t pad_0;
    union {
      int xuid;
      struct {
        int xuidlow;
        int xuidhigh;
      };
    };
    char name[128];
    int userid;
    char guid[33];
    unsigned int friendsid;
    char friendsname[128];
    bool fakeplayer;
    bool ishltv;
    unsigned int customfiles[4];
    unsigned char filesdownloaded;
  } S_playerInfo_t;

  typedef bool(__thiscall* fnGetPlayerInfo)(void*, int, S_playerInfo_t*);

  typedef void(__thiscall* clientcmdun)(void*, const char* , bool);
  
  typedef bool(__thiscall* is_in_game)(void*);
  
  typedef bool(__thiscall* is_connected)(void*, bool);
  
  typedef int(__thiscall* get_local_player_ffi)(void*);

  typedef void*(__thiscall* get_net_channel_info_t)(void*);

  typedef float(__thiscall* get_avg_latency_t)(void*, int);
  typedef float(__thiscall* get_avg_loss_t)(void*, int);
  typedef float(__thiscall* get_avg_choke_t)(void*, int);
]]




local pEngineClient = ffi.cast(ffi.typeof("void***"), client.create_interface("engine.dll", "VEngineClient014"))

-- c++ function predefs


local fnGetPlayerInfo = ffi.cast("fnGetPlayerInfo", pEngineClient[0][8])
local clientcmdun = ffi.cast("clientcmdun", pEngineClient[0][114])

-- c++ function predefs
local pinfo_struct = ffi.new("S_playerInfo_t[1]")
local lp_entidx = entity.get_local_player()
local steamid = nil
local pritsteamid = nil

if lp_entidx then
    fnGetPlayerInfo(pEngineClient, lp_entidx, pinfo_struct)
    steamid = pinfo_struct[0].xuid
    pritsteamid = ffi.string(pinfo_struct[0].guid)
end

print("Buy lua script at: shoppy.gg/@FluffyHvH ")
android_notify:paint(8, "Buy lua script at: shoppy.gg/@FluffyHvH ")
return false
