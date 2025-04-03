-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local obex_data = obex_fetch and obex_fetch() or {username = 'Peterik', build = 'Source'}
local bit = require "bit"
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ffi = require("ffi")
local vector = require("vector")
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard")
local http = require('gamesense/http')

local username = _G.obex_name == nil and 'Peterik' or _G.obex_name:lower()
local build = _G.obex_build == nil and 'source' or _G.obex_build:lower()

if build == "User" then
    build = "live"
end

local update_date = "16.10.22"
local version = "0.37"

local label1 = ui.new_label ("AA", "Anti-aimbot angles", "r8 anti-aim system")
local label2 = ui.new_label ("AA", "Anti-aimbot angles", "Updated \a749dd0FF16.10.22")
local label3 = ui.new_label ("AA", "Anti-aimbot angles", "Powered by \a749dd0FFPeterik")

local anim = { }

local hitler = {}

hitler.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

local ref = {
	ref_edge_yaw = ui.reference( "AA", "Anti-aimbot angles", "Edge yaw" ),
	leg_movement = ui.reference("AA", "Other", "Leg movement"),
	menu_color = ui.reference("Misc", "Settings", "Menu color"),
	enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
	fakeyawlimit = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
	fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
	edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
	maxprocticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
	dtholdaim = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks_holdaim"),
	fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
	safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
	forcebaim = ui.reference("RAGE", "Other", "Force body aim"),
	player_list = ui.reference("PLAYERS", "Players", "Player list"),
	reset_all = ui.reference("PLAYERS", "Players", "Reset all"),
	apply_all = ui.reference("PLAYERS", "Adjustments", "Apply to all"),
	load_cfg = ui.reference("Config", "Presets", "Load"),
	fl_limit = ui.reference("AA", "Fake lag", "Limit"),
	dt_limit = ui.reference("RAGE", "Other", "Double tap fake lag limit"),
	quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
	pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
	yawjitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
	bodyyaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
	freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
	os = {ui.reference("AA", "Other", "On shot anti-aim")},
	slow = {ui.reference("AA", "Other", "Slow motion")},
	dt = {ui.reference("RAGE", "Other", "Double tap")},
	ps = {ui.reference("RAGE", "Other", "Double tap")},
	fakelag = {ui.reference("AA", "Fake lag", "Limit")}
}

local function on_load()
	ui.set(ref.yawjitter[1], "off")
	ui.set(ref.yawjitter[2], 0)
	ui.set(ref.bodyyaw[1], "static")
	ui.set(ref.bodyyaw[2], -180)
	ui.set(ref.yaw[1], "180")
	ui.set(ref.yaw[2], -90)
	ui.set(ref.fakeyawlimit, 60)
end

on_load()

local aa_init = { }

local function colour_console(prefix, text, string)
    client.color_log(prefix[1], prefix[2], prefix[3], "r8-tools - \0")
    client.color_log(text[1], text[2], text[3], string)
end

local col = {
    r8_blue = {
        178, 163, 236
    },
    r8_white = {
        207, 207, 207
    },
    r8_red = {
        255, 100, 100
    },
    r8_darkblue = {
        10, 145, 255
    },
    r8_green = {
        0, 255, 21
    },
    r8_pink = {
        255, 154, 255
    }
}

local var = {
	p_states = {"stand", "move", "slowwalk", "air", "duck", "air-duck", "fakelag"},
	s_to_int = {["air-duck"] = 6,["fakelag"] = 7, ["stand"] = 1, ["move"] = 2, ["slowwalk"] = 3, ["air"] = 4, ["duck"] = 5},
	player_states = {"S", "M", "SW", "A", "C", "AC", "FL"},
	state_to_int = {["AC"] = 6,["FL"] = 7, ["S"] = 1, ["M"] = 2, ["SW"] = 3, ["A"] = 4, ["C"] = 5},
	p_state = 1
}


local function contains(table, value)

	if table == nil then
		return false
	end
	
	table = ui.get(table)
	for i=0, #table do
		if table[i] == value then
			return true
		end
	end
	return false
end

local function table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

aa_init[0] = {
	aa_dir   = 0,
	last_press_t = 0,
	lua_select = ui.new_combobox("AA", "Anti-aimbot angles", "Tab Selection", "Anti-Aim", "Visuals", "Misc", "Config"),
	features = ui.new_multiselect("AA", "Anti-aimbot angles", "Features", "[Yaw Management]", "[Anti-Aim on Use]", "[Fix Hideshots]"),
	fs = ui.new_hotkey("AA", "Anti-aimbot angles", "Freestand"),
	manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "Left"),
	manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "Right"),
	manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "Forward"),
	legit_aa_hotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "Legit AA"),
	aa_stc_tillhit = ui.new_checkbox("AA", "Anti-aimbot angles","static until hittable"),
	player_state = ui.new_combobox("AA", "Anti-aimbot angles", "antiaim-states", "stand", "move", "slowwalk", "air", "duck", "air-duck", "fakelag"),
}

local function print_welcome(x)
	client.color_log(192, 187, 255, "r8 \0")
	client.color_log(155, 155, 155, "- \0")
	client.color_log(225, 225, 225, "welcome to \0")
	client.color_log(192, 187, 255, "r8")
	--return client.color_log(200, 200, 200, " " .. x)
end

local function print_error(x)
	client.color_log(192, 187, 255, "r8 \0")
	client.color_log(155, 155, 155, "- \0")
	client.color_log(225, 225, 225, "error occured \0")
	client.color_log(155, 155, 155, "-> \0")
	return client.color_log(255, 150, 150, " " .. x)
end

--#region "visuals indicators whatever"
local indicator = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Crosshair Indicators")

local main_clr_l2 = ui.new_label("AA", "Anti-aimbot angles", "color 1")
local main_clr2 = ui.new_color_picker("AA", "Anti-aimbot angles", "main color", 130, 177, 236, 255)

local main_clr_l4 = ui.new_label("AA", "Anti-aimbot angles", "color 2")
local main_clr4 = ui.new_color_picker("AA", "Anti-aimbot angles", "main color", 255, 255, 255, 255)

local main_clr_l3 = ui.new_label("AA", "Anti-aimbot angles", "color 3")
local main_clr3 = ui.new_color_picker("AA", "Anti-aimbot angles", "main color", 255, 161, 161, 255)

local Snapline = ui.new_checkbox("AA", "Anti-aimbot angles", "Snapline")
local Snaplinecolor = ui.new_color_picker("AA", "Anti-aimbot angles", "Snapline color", 243, 165, 120, 235)

local master_switch = ui.new_checkbox("AA", "Anti-aimbot angles", 'Enable logs')
local force_safe_point = ui.reference('RAGE', 'Aimbot', 'Force safe point')
local dtimp = ui.new_checkbox("AA", "Anti-aimbot angles", "doubletap")
local anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti Backstab")
local knife_distance = ui.new_slider("AA", "Anti-aimbot angles", "Anti Backstab Radius",0,300,150,true,"u")

for i=1, 7 do
	aa_init[i] = {
		pitch = ui.new_combobox("AA", "Anti-aimbot angles","pitch", { "off", "Default", "Up", "Down", "Minimal", "Random" }),
		yawbase = ui.new_combobox("AA", "Anti-aimbot angles","Yaw base", { "Local view", "At targets"}),
		yawaddl = ui.new_slider("AA", "Anti-aimbot angles", "yaw left", -180, 180, 0),
		yawaddr = ui.new_slider("AA", "Anti-aimbot angles","yaw right", -180, 180, 0),
		yawjitter = ui.new_combobox("AA", "Anti-aimbot angles","yaw jitter", { "off", "offset", "center", "random" }),
		yawjitteradd = ui.new_slider("AA", "Anti-aimbot angles","yaw jitter add",  -180, 180, 0),
		bodyyaw = ui.new_combobox("AA", "Anti-aimbot angles","Body yaw",  { "off", "opposite", "jitter", "static"}),
		aa_static = ui.new_slider("AA", "Anti-aimbot angles","body yaw add", -180, 180, 0),
		additions = ui.new_multiselect("AA", "Anti-aimbot angles", "Features", "Anti-Bruteforce", "Freestanding", "Avoid Overlap"),
		fakeyawlimit = ui.new_slider("AA", "Anti-aimbot angles","fake limit left",  0, 60, 60,true),
		fakeyawlimitr = ui.new_slider("AA", "Anti-aimbot angles","fake limit right",  0, 60, 60,true),
		roll = ui.new_slider("AA", "Anti-aimbot angles"," roll", -50, 50, 0, true),
	}
end

local function oppositefix(c)
	local desync_amount = antiaim_funcs.get_desync(2)
    if math.abs(desync_amount) < 15 or c.chokedcommands ~= 0 then
        return
    end
end

local globals_frametime = globals.frametime
local globals_tickinterval = globals.tickinterval
local entity_is_enemy = entity.is_enemy
local entity_get_prop = entity.get_prop
local entity_is_dormant = entity.is_dormant
local entity_is_alive = entity.is_alive
local entity_get_origin = entity.get_origin
local entity_get_local_player = entity.get_local_player
local entity_get_player_resource = entity.get_player_resource
local table_insert = table.insert
local math_floor = math.floor

local time_to_ticks = function(t) return math_floor(0.5 + (t / globals_tickinterval())) end
local vec_substract = function(a, b) return { a[1] - b[1], a[2] - b[2], a[3] - b[3] } end
local vec_lenght = function(x, y) return (x * x + y * y) end

local g_aimbot_data = { }
local g_sim_ticks, g_net_data = { }, { }

local cl_data = {
    tick_shifted = false,
    tick_base = 0
}

local get_entities = function(enemy_only, alive_only)
    local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true
    
    local result = {}
    local player_resource = entity_get_player_resource()
    
    for player = 1, globals.maxplayers() do
        local is_enemy, is_alive = true, true
        
        if enemy_only and not entity_is_enemy(player) then is_enemy = false end
        if is_enemy then
            if alive_only and entity_get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
            if is_alive then table_insert(result, player) end
        end
    end

    return result
end

local generate_flags = function(e, on_fire_data)
    return {
		e.refined and 'R' or '',
		e.expired and 'X' or '',
		e.noaccept and 'N' or '',
		cl_data.tick_shifted and 'S' or '',
		on_fire_data.teleported and 'T' or '',
		on_fire_data.interpolated and 'I' or '',
		on_fire_data.extrapolated and 'E' or '',
		on_fire_data.boosted and 'B' or '',
		on_fire_data.high_priority and 'H' or ''
    }
end

local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
local weapon_to_verb = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' }
if reason == "?" then
    reason = "resolver"
else
    reason = reason
end


--region net_update
local function g_net_update()
	local me = entity_get_local_player()
    local players = get_entities(true, true)
	local m_tick_base = entity_get_prop(me, 'm_nTickBase')
	
    cl_data.tick_shifted = false
    
	if m_tick_base ~= nil then
		if cl_data.tick_base ~= 0 and m_tick_base < cl_data.tick_base then
			cl_data.tick_shifted = true
		end
	
		cl_data.tick_base = m_tick_base
    end

	for i=1, #players do
		local idx = players[i]
        local prev_tick = g_sim_ticks[idx]
        
        if entity_is_dormant(idx) or not entity_is_alive(idx) then
            g_sim_ticks[idx] = nil
            g_net_data[idx] = nil
        else
            local player_origin = { entity_get_origin(idx) }
            local simulation_time = time_to_ticks(entity_get_prop(idx, 'm_flSimulationTime'))
    
            if prev_tick ~= nil then
                local delta = simulation_time - prev_tick.tick

                if delta < 0 or delta > 0 and delta <= 64 then
                    local m_fFlags = entity_get_prop(idx, 'm_fFlags')

                    local diff_origin = vec_substract(player_origin, prev_tick.origin)
                    local teleport_distance = vec_lenght(diff_origin[1], diff_origin[2])

                    g_net_data[idx] = {
                        tick = delta-1,

                        origin = player_origin,
                        tickbase = delta < 0,
                        lagcomp = teleport_distance > 4096,
                    }
                end
            end

            g_sim_ticks[idx] = {
                tick = simulation_time,
                origin = player_origin,
            }
        end
    end
end
--endregion

local function g_aim_fire(e)
    local data = e

    local plist_sp = plist.get(e.target, 'Override safe point')
    local checkbox = ui.get(force_safe_point)

    if g_net_data[e.target] == nil then
        g_net_data[e.target] = { }
    end

    data.teleported = g_net_data[e.target].lagcomp or false
    data.choke = g_net_data[e.target].tick or '?'
    data.self_choke = globals.chokedcommands()
    data.safe_point = ({
        ['Off'] = 'off',
        ['On'] = true,
        ['-'] = checkbox
    })[plist_sp]
    local reason

    g_aimbot_data[e.id] = data
end

local function g_aim_hit(e)
    if not ui.get(master_switch) or g_aimbot_data[e.id] == nil then
        return
    end

    local on_fire_data = g_aimbot_data[e.id]
	local name = string.lower(entity.get_player_name(e.target))
	local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local aimed_hgroup = hitgroup_names[on_fire_data.hitgroup + 1] or '?'
    
    local hitchance = math_floor(on_fire_data.hit_chance + 0.5) .. '%'
    local health = entity_get_prop(e.target, 'm_iHealth')

    local flags = generate_flags(e, on_fire_data)

    print(string.format(
        '[%d] Hit %s\'s %s for %i(%d) (%i remaining) aimed=%s(%s) safety=%s (%s) (%s:%s)', 
        e.id, name, hgroup, e.damage, on_fire_data.damage, health, aimed_hgroup, hitchance, on_fire_data.safe_point, table.concat(flags), on_fire_data.self_choke, on_fire_data.choke
    ))
end

local function g_aim_miss(e)
    if not ui.get(master_switch) or g_aimbot_data[e.id] == nil then
        return
    end

    local on_fire_data = g_aimbot_data[e.id]
    local name = string.lower(entity.get_player_name(e.target))

	local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local hitchance = math_floor(on_fire_data.hit_chance + 0.5) .. '%'

    local flags = generate_flags(e, on_fire_data)

    print(string.format(
        '[%d] Missed %s\'s %s(%i)(%s) due to %s, safety=%s (%s) (%s:%s)', 
        e.id, name, hgroup, on_fire_data.damage, hitchance, e.reason, on_fire_data.safe_point, table.concat(flags), on_fire_data.self_choke, on_fire_data.choke
    ))
end

local function g_player_hurt(e)
    local attacker_id = client.userid_to_entindex(e.attacker)
	
    if not ui.get(master_switch) or attacker_id == nil or attacker_id ~= entity.get_local_player() then
        return
    end

    local group = hitgroup_names[e.hitgroup + 1] or "?"
	
    if group == "generic" and weapon_to_verb[e.weapon] ~= nil then
        local target_id = client.userid_to_entindex(e.userid)
		local target_name = entity.get_player_name(target_id)

		print(string.format("%s %s for %i damage (%i remaining) ", weapon_to_verb[e.weapon], string.lower(target_name), e.dmg_health, e.health))
	end
end

local bit_band, client_set_event_callback, entity_get_bounding_box, entity_get_local_player, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, math_ceil, math_pow, math_sqrt, renderer_line, renderer_text, renderer_world_to_screen, ui_get, ui_new_checkbox = bit.band, client.set_event_callback, entity.get_bounding_box, entity.get_local_player, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, math.ceil, math.pow, math.sqrt, renderer.line, renderer.text, renderer.world_to_screen, ui.get, ui.new_checkbox

local third_check, third  = ui.reference("Visuals", "Effects", "Force Third Person (alive)")
local function Vector(x,y,z) 
	return {x=x or 0,y=y or 0,z=z or 0} 
end

local function Distance(from_x,from_y,from_z,to_x,to_y,to_z)  
  return math_ceil(math_sqrt(math_pow(from_x - to_x, 2) + math_pow(from_y - to_y, 2) + math_pow(from_z - to_z, 2)))
end

local function paint()
	if not ui_get(Snapline) then return end
	local lp = entity_get_local_player()
	if lp == nil then return end
	if not entity_is_alive(lp) then return end
	
    local players = entity_get_players(true)
	if #players == nil or #players == 0 then
		return
	end
	
	local threat = client.current_threat()

	for i = 1, #players do
		local entindex = players[i]	
		if (entindex ~= nil and entindex ~= entity_get_local_player() and entindex == threat) then
			local line_start = Vector(entity_hitbox_position(entindex, 3))
			local line_stop = Vector(entity_hitbox_position(lp, 3))
			local x1, y1 = renderer_world_to_screen(line_start.x,line_start.y,line_start.z)
			local thrid_x, thrid_y = renderer_world_to_screen(line_stop.x,line_stop.y,line_stop.z)
			local screen_x, screen_y = client.screen_size()
			local x2 = (screen_x / 2)
			local y2 = screen_y
			local Snaplineclr = {ui.get(Snaplinecolor)}
			if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
				renderer_line(x1, y1, x2, y2, Snaplineclr[1], Snaplineclr[2], Snaplineclr[3], Snaplineclr[4])
			end
		end
	end
	
end

local function setup_callback(i)
    if ui.get(i) then
        client.set_event_callback("paint", paint)
    else
        client.unset_event_callback("paint", paint)
    end
end

ui.set_callback(Snapline, setup_callback)

client.set_event_callback('aim_fire', g_aim_fire)
client.set_event_callback('aim_hit', g_aim_hit)
client.set_event_callback('aim_miss', g_aim_miss)
client.set_event_callback('net_update_end', g_net_update)

client.set_event_callback('player_hurt', g_player_hurt)

local yaw_am, yaw_val = ui.reference("AA","Anti-aimbot angles","Yaw")
jyaw, jyaw_val = ui.reference("AA","Anti-aimbot angles","Yaw Jitter")
byaw, byaw_val = ui.reference("AA","Anti-aimbot angles","Body yaw")
fs_body_yaw = ui.reference("AA","Anti-aimbot angles","Freestanding body yaw")
fake_yaw = ui.reference("AA","Anti-aimbot angles","Fake yaw limit")

local function set_og_menu(state)
	ui.set_visible(ref.pitch, state)
	ui.set_visible(ref.roll, state)
	ui.set_visible(ref.yawbase, state)
	ui.set_visible(ref.yaw[1], state)
	ui.set_visible(ref.yaw[2], state)
	ui.set_visible(ref.yawjitter[1], state)
	ui.set_visible(ref.yawjitter[2], state)
	ui.set_visible(ref.bodyyaw[1], state)
	ui.set_visible(ref.bodyyaw[2], state)
	ui.set_visible(ref.freestand[1], state)
	ui.set_visible(ref.freestand[2], state)
	ui.set_visible(ref.fakeyawlimit, state)
	ui.set_visible(ref.fsbodyyaw, state)
	ui.set_visible(ref.edgeyaw, state)
end

function logo()
    local logo = { } 

    client.exec("clear")
    for _, line in pairs(logo) do
        client.color_log(178/6*_, 163/6 * _, 236/6 * _, line)
    end

	colour_console(col.r8_blue, col.r8_white, "Logged in as \0")
	client.color_log(col.r8_blue[1], col.r8_blue[2], col.r8_blue[3], username .. " | " .. build)
	
end
logo()

function HEXtoRGB(hexArg)

	hexArg = hexArg:gsub('#','')

	if(string.len(hexArg) == 3) then
		return tonumber('0x'..hexArg:sub(1,1)) * 17, tonumber('0x'..hexArg:sub(2,2)) * 17, tonumber('0x'..hexArg:sub(3,3)) * 17
	elseif(string.len(hexArg) == 8) then
		return tonumber('0x'..hexArg:sub(1,2)), tonumber('0x'..hexArg:sub(3,4)), tonumber('0x'..hexArg:sub(5,6)), tonumber('0x'..hexArg:sub(7,8))
	else
		return 0 , 0 , 0
	end

end

function RGBtoHEX(redArg, greenArg, blueArg)

	return string.format('%.2x%.2x%.2xFF', redArg, greenArg, blueArg)

end


local function set_lua_menu()
	var.active_i = var.s_to_int[ui.get(aa_init[0].player_state)]
	local is_aa = ui.get(aa_init[0].lua_select) == "Anti-Aim"
	local is_vis = ui.get(aa_init[0].lua_select) == "Visuals"
	local is_misc = ui.get(aa_init[0].lua_select) == "Misc"
	
	local is_fs = table_contains(ui.get(aa_init[0].features),"[Yaw Management]") 

	local legit_aa = table_contains(ui.get(aa_init[0].features),"[Anti-Aim on Use]") 

	local is_knife = ui.get(anti_knife)
	local is_Snapline = ui.get(Snapline)
	local is_indicator = ui.get(indicator)

	if true then
		ui.set_visible(aa_init[0].lua_select, true)
		set_og_menu(false)
	else
		ui.set_visible(aa_init[0].lua_select, false)
		set_og_menu(true)
	end

	if is_misc then
		ui.set_visible(dtimp, true)
		ui.set_visible(master_switch, true)
		ui.set_visible(anti_knife, true)
		if is_knife then
			ui.set_visible(knife_distance, true)
		else
			ui.set_visible(knife_distance, false)
		end
	else
		ui.set_visible(anti_knife, false)
		ui.set_visible(master_switch, false)
		ui.set_visible(knife_distance, false)
		ui.set_visible(dtimp, false)
	end

	if is_aa then
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	else
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	end


	if true then
		ui.set_visible(label1, true)
		ui.set_visible(label2, true)
		ui.set_visible(label3, true)
	else
		ui.set_visible(label1, false)
		ui.set_visible(label2, false)
		ui.set_visible(label3, false)
    end

	if is_aa then
        ui.set_visible(aa_init[0].fs, true)
		ui.set_visible(aa_init[0].manual_left, true)
		ui.set_visible(aa_init[0].manual_right, true)
		ui.set_visible(aa_init[0].manual_forward, true)
		if is_fs then
			ui.set_visible(aa_init[0].fs, true)
			ui.set_visible(aa_init[0].manual_left, true)
			ui.set_visible(aa_init[0].manual_right, true)
			ui.set_visible(aa_init[0].manual_forward, true)
		else
			ui.set_visible(aa_init[0].fs, false)
			ui.set_visible(aa_init[0].manual_left, false)
			ui.set_visible(aa_init[0].manual_right, false)
			ui.set_visible(aa_init[0].manual_forward, false)
		end
	else
		ui.set_visible(aa_init[0].fs, false)
		ui.set_visible(aa_init[0].manual_left, false)
		ui.set_visible(aa_init[0].manual_right, false)
		ui.set_visible(aa_init[0].manual_forward, false)
	end


	if is_aa then
		ui.set_visible(aa_init[0].legit_aa_hotkey, true)
		if legit_aa then
			ui.set_visible(aa_init[0].legit_aa_hotkey, true)
		else
			ui.set_visible(aa_init[0].legit_aa_hotkey, false)
		end
	else
		ui.set_visible(aa_init[0].legit_aa_hotkey, false)
	end


	if is_vis then
		ui.set_visible(main_clr2, true)
		ui.set_visible(main_clr_l2, true)
		ui.set_visible(main_clr3, true)
		ui.set_visible(main_clr_l3, true)
		ui.set_visible(main_clr4, true)
		ui.set_visible(main_clr_l4, true)
		ui.set_visible(indicator, true)
		ui.set_visible(Snapline, true) 
		ui.set_visible(Snaplinecolor, true) 

		if is_Snapline then
			ui.set_visible(Snaplinecolor, true) 
		else
			ui.set_visible(Snaplinecolor, false) 
		end

		if is_indicator then
			ui.set_visible(main_clr2, true)
			ui.set_visible(main_clr_l2, true)
			ui.set_visible(main_clr3, true)
			ui.set_visible(main_clr_l3, true)
			ui.set_visible(main_clr4, true)
			ui.set_visible(main_clr_l4, true)
		else
			ui.set_visible(main_clr2, false)
			ui.set_visible(main_clr_l2, false)
			ui.set_visible(main_clr3, false)
			ui.set_visible(main_clr_l3, false)
			ui.set_visible(main_clr4, false)
			ui.set_visible(main_clr_l4, false)
		end

	else
		ui.set_visible(main_clr2, false)
		ui.set_visible(main_clr_l2, false)
		ui.set_visible(main_clr3, false)
		ui.set_visible(main_clr_l3, false)
		ui.set_visible(main_clr4, false)
		ui.set_visible(main_clr_l4, false)
		ui.set_visible(indicator, false)
		ui.set_visible(Snapline, false) 
		ui.set_visible(Snaplinecolor, false) 
	end

	if is_aa then
		ui.set_visible(aa_init[0].features, true)
	else
		ui.set_visible(aa_init[0].features, false)

	end
	if true then
		for i=1, 7 do
			ui.set_visible(aa_init[0].player_state,is_aa)
			if true then
				ui.set_visible(aa_init[i].yawaddl,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawaddr,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawjitter,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].pitch,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawbase,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawjitteradd,var.active_i == i and ui.get(aa_init[var.active_i].yawjitter) ~= "off" and is_aa)

				ui.set_visible(aa_init[i].bodyyaw, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].additions, var.active_i == i and is_aa)

				ui.set_visible(aa_init[i].aa_static,var.active_i == i and is_aa and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite")

				ui.set_visible(aa_init[i].fakeyawlimit,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimitr,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].roll, var.active_i == i and is_aa)
			else
				ui.set_visible(aa_init[i].yawaddl,false)
				ui.set_visible(aa_init[i].yawaddr,false)
				ui.set_visible(aa_init[i].yawjitter,false)
				ui.set_visible(aa_init[i].pitch,false)
				ui.set_visible(aa_init[i].yawbase,false)
				ui.set_visible(aa_init[i].yawjitteradd,false)

				ui.set_visible(aa_init[i].additions, false)

				ui.set_visible(aa_init[i].bodyyaw,false)
	
				ui.set_visible(aa_init[i].aa_static,false)

				ui.set_visible(aa_init[i].fakeyawlimit,false)
				ui.set_visible(aa_init[i].fakeyawlimitr,false)
				ui.set_visible(aa_init[i].roll,false)
			end
		end
	else
		for i=1, 7 do
			ui.set_visible(aa_init[0].player_state,false)
			ui.set_visible(aa_init[i].yawaddl,false)
			ui.set_visible(aa_init[i].yawaddr,false)
			ui.set_visible(aa_init[i].pitch,false)
			ui.set_visible(aa_init[i].yawbase,false)
			ui.set_visible(aa_init[i].yawjitter,false)
			ui.set_visible(aa_init[i].yawjitteradd,false)

			ui.set_visible(aa_init[i].bodyyaw,false)

			ui.set_visible(aa_init[i].additions, false)

			ui.set_visible(aa_init[i].aa_static,false)

			ui.set_visible(aa_init[i].fakeyawlimit,false)
			ui.set_visible(aa_init[i].fakeyawlimitr,false)
			ui.set_visible(aa_init[i].roll,false)
		end
	end
end

misc = {}
misc.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

misc.anti_knife = function()
    if ui.get(anti_knife) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
        local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = misc.anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(knife_distance) then
                ui.set(yaw_slider,180)
                ui.set(pitch,"Off")
            end
        end
    end
end

client.set_event_callback("setup_command",misc.anti_knife)

local best_enemy = nil

local brute = {
	yaw_status = "default",
	fs_side = 0,
	last_miss = 0,
	best_angle = 0,
	misses = { },
	hp = 0,
	misses_ind = { },
	can_hit_head = 0,
	can_hit = 0,
	hit_reverse = { }
}

local ingore = false
local laa = 0
local raa = 0
local mantimer = 0
local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local function calc_angle(local_x, local_y, enemy_x, enemy_y)
	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math.atan( ydelta / xdelta )
	relativeyaw = normalize_yaw( relativeyaw * 180 / math.pi )
	if xdelta >= 0 then
		relativeyaw = normalize_yaw(relativeyaw + 180)
	end
	return relativeyaw
end

local function ang_on_screen(x, y)
	if x == 0 and y == 0 then return 0 end

	return math.deg(math.atan2(y, x))
end

local function angle_vector(angle_x, angle_y)
	local sy = math.sin(math.rad(angle_y))
	local cy = math.cos(math.rad(angle_y))
	local sp = math.sin(math.rad(angle_x))
	local cp = math.cos(math.rad(angle_x))
	return cp * cy, cp * sy, -sp
end

local function get_damage(me, enemy, x, y,z)
	local ex = { }
	local ey = { }
	local ez = { }
	ex[0], ey[0], ez[0] = entity.hitbox_position(enemy, 1)
	ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
	ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
	ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
	ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
	ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
	ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
	local bestdamage = 0
	local bent = nil
	for i=0, 6 do
		local ent, damage = client.trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
		if damage > bestdamage then
			bent = ent
			bestdamage = damage
		end
	end
	return bent == nil and client.scale_damage(me, 1, bestdamage) or bestdamage
end

local function get_best_enemy()
	best_enemy = nil

	local enemies = entity.get_players(true)
	local best_fov = 180

	local lx, ly, lz = client.eye_position()
	local view_x, view_y, roll = client.camera_angles()
	
	for i=1, #enemies do
		local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
		local cur_fov = math.abs(normalize_yaw(ang_on_screen(lx - cur_x, ly - cur_y) - view_y + 180))
		if cur_fov < best_fov then
			best_fov = cur_fov
			best_enemy = enemies[i]
		end
	end
end

local function extrapolate_position(xpos,ypos,zpos,ticks,player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	for i=0, ticks do
		xpos =  xpos + (x*globals.tickinterval())
		ypos =  ypos + (y*globals.tickinterval())
		zpos =  zpos + (z*globals.tickinterval())
	end
	return xpos,ypos,zpos
end

local function get_velocity(player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	if x == nil then return end
	return math.sqrt(x*x + y*y + z*z)
end

local function get_body_yaw(player)
	local _, model_yaw = entity.get_prop(player, "m_angAbsRotation")
	local _, eye_yaw = entity.get_prop(player, "m_angEyeAngles")
	if model_yaw == nil or eye_yaw ==nil then return 0 end
	return normalize_yaw(model_yaw - eye_yaw)
end

local function get_best_angle()
	local me = entity.get_local_player()

	if best_enemy == nil then return end

	local origin_x, origin_y, origin_z = entity.get_prop(best_enemy, "m_vecOrigin")
	if origin_z == nil then return end
	origin_z = origin_z + 64

	local extrapolated_x, extrapolated_y, extrapolated_z = extrapolate_position(origin_x, origin_y, origin_z, 20, best_enemy)
	
	local lx,ly,lz = client.eye_position()
	local hx,hy,hz = entity.hitbox_position(entity.get_local_player(), 0) 
	local _, head_dmg = client.trace_bullet(best_enemy, origin_x, origin_y, origin_z, hx, hy, hz, true)
			
	if head_dmg ~= nil and head_dmg > 1 then
		brute.can_hit_head = 1
	else
		brute.can_hit_head = 0
	end

	local view_x, view_y, roll = client.camera_angles()
	
	local e_x, e_y, e_z = entity.hitbox_position(best_enemy, 0)

	local yaw = calc_angle(lx, ly, e_x, e_y)
	local rdir_x, rdir_y, rdir_z = angle_vector(0, (yaw + 90))
	local rend_x = lx + rdir_x * 10
	local rend_y = ly + rdir_y * 10
			
	local ldir_x, ldir_y, ldir_z = angle_vector(0, (yaw - 90))
	local lend_x = lx + ldir_x * 10
	local lend_y = ly + ldir_y * 10
			
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

	if l2damage > r2damage or ldamage > rdamage or l2damage > ldamage then
		if table_contains(ui.get(aa_init[var.p_state].additions),"Freestanding") then
			brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 1 or 2)
		else
			brute.best_angle = 1
		end
	elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
		if table_contains(ui.get(aa_init[var.p_state].additions),"Freestanding") then
			brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 2 or 1)
		else
			brute.best_angle = 2
		end
	end
end

function can_enemy_hit_head( ent )
    if ent == nil then return end
    if in_air( ent ) then return false end
    
    local origin_x, origin_y, origin_z = entity_get_prop( ent, "m_vecOrigin" )
    if origin_z == nil then return end
    origin_z = origin_z + 64

    local hx,hy,hz = entity.hitbox_position( entity.get_local_player( ), 0 ) 
    local _, head_dmg = client.trace_bullet( ent, origin_x, origin_y, origin_z, hx, hy, hz, true )
        
    return head_dmg ~= nil and head_dmg > 25
end

local function in_air(player)
	local flags = entity.get_prop(player, "m_fFlags")
	
	if bit.band(flags, 1) == 0 then
		return true
	end
	
	return false
end

local ChokedCommands = 0

local aa = {
	ignore = false,
	manaa = 0,
	input = 0,
}
local lastdt = 0

local function on_setup_command(c)
	--run_shit(c)

	local plocal = entity.get_local_player()

	local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")

	local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
	local lp_vel = get_velocity(entity.get_local_player())
	local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
	local p_slow = ui.get(ref.slow[1]) and ui.get(ref.slow[2])

	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fd = ui.get(ref.fakeduck)
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])

	local wpn = entity.get_player_weapon(plocal)
	local wpn_id = entity.get_prop(wpn, "m_iItemDefinitionIndex")

	local doubletapping = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	local state = "AFK"
	--states [for searching]'
	if not is_dt and not is_os and not p_still then
		var.p_state = 7
	elseif c.in_duck == 1 and on_ground then
		var.p_state = 5
	elseif c.in_duck == 1 and not on_ground then
		var.p_state = 6
	elseif not on_ground then
		var.p_state = 4
	elseif p_slow then
		var.p_state = 3
	elseif p_still then
		var.p_state = 1
	elseif not p_still then
		var.p_state = 2
	end

	if var.p_state == 6 then
		c.roll = ui.get(aa_init[6].roll)
	elseif var.p_state == 1 then
		c.roll = ui.get(aa_init[1].roll)
	elseif var.p_state == 1 then
		c.roll = ui.get(aa_init[7].roll)
	elseif var.p_state == 2 then
		c.roll = ui.get(aa_init[2].roll)
	elseif var.p_state == 3 then
		c.roll = ui.get(aa_init[3].roll)
	elseif var.p_state == 4 then
		c.roll = ui.get(aa_init[4].roll)
	elseif var.p_state == 5 then
		c.roll = ui.get(aa_init[5].roll)
	end

	local weaponn = entity.get_player_weapon()
	if ui.get(aa_init[0].legit_aa_hotkey) and table_contains(ui.get(aa_init[0].features),"[Anti-Aim on Use]") then
		ui.set(ref.pitch, "off")
		ui.set(ref.yawjitter[1], "off")
		ui.set(ref.yawjitter[2], 0)
		ui.set(ref.bodyyaw[1], "jitter")
		ui.set(ref.bodyyaw[2], -45)
		ui.set(ref.yawbase, "local view")
		ui.set(ref.yaw[1], "180")
		ui.set(ref.yaw[2], -180)
		ui.set(ref.fakeyawlimit, 60)
	end

	if ui.get(dtimp) then
		if lastdt < globals.curtime() then
			ui.set(ref.maxprocticks, 17)
			client.set_cvar("cl_clock_correction", "0")
			ui.set(ref.dt_limit, 1)
			ui.set(ref.dtholdaim, true)
		else
			ui.set(ref.maxprocticks, 19)
			client.set_cvar("cl_clock_correction", "0")
			ui.set(ref.dt_limit, 1)
			ui.set(ref.dtholdaim, true)
		end
	else
		ui.set(ref.maxprocticks, 16)
	end
end

local antiaim = {
	leg_movement = ui.reference("AA", "Other", "Leg movement"),
}


client.set_event_callback("setup_command", function(c)

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local localp = entity.get_local_player()

	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fd = ui.get(ref.fakeduck)
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])


	if ui.get(aa_init[0].fs) then
		ui.set(ref.freestand[1], "Default")
		ui.set(ref.freestand[2], "Always on")
	else
		ui.set(ref.freestand[1], "Default")
		ui.set(ref.freestand[2], "On hotkey")
	end

	local l = 1

	if table_contains(ui.get(aa_init[0].features),"[Fix Hideshots]") then
		if is_os and not is_dt and not is_fd then
			ui.set(ref.fakelag[1], math.random(1,3))
		else
			ui.set(ref.fakelag[1], 14)
		end
	end

	if aa.input + 0.22 < globals.curtime() then
		if aa.manaa == 0 then
			if ui.get(aa_init[0].manual_left) then
				aa.manaa = 1
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_right) then
				aa.manaa = 2
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_forward) then
				aa.manaa = 3
				aa.input = globals.curtime()
			end
		elseif aa.manaa == 1 then
			if ui.get(aa_init[0].manual_right) then
				aa.manaa = 2
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_forward) then
				aa.manaa = 3
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_left) then
				aa.manaa = 0
				aa.input = globals.curtime()
			end
		elseif aa.manaa == 2 then
			if ui.get(aa_init[0].manual_left) then
				aa.manaa = 1
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_forward) then
				aa.manaa = 3
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_right) then
				aa.manaa = 0
				aa.input = globals.curtime()
			end
		elseif aa.manaa == 3 then
			if ui.get(aa_init[0].manual_forward) then
				aa.manaa = 0
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_left) then
				aa.manaa = 1
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_right) then
				aa.manaa = 2
				aa.input = globals.curtime()
			end
		end
	end

	if aa.manaa == 1 or aa.manaa == 2 or aa.manaa == 3 then
		aa.ignore = true
		if aa.manaa == 1 then
			ui.set(ref.yawjitter[1], "off")
			ui.set(ref.yawjitter[2], 0)
			ui.set(ref.bodyyaw[1], "static")
			ui.set(ref.bodyyaw[2], -180)
			ui.set(ref.yawbase, "local view")
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], -90)
			ui.set(ref.fakeyawlimit, 60)
		elseif aa.manaa == 2 then
			ui.set(ref.yawjitter[1], "off")
			ui.set(ref.yawjitter[2], 0)
			ui.set(ref.bodyyaw[1], "static")
			ui.set(ref.bodyyaw[2], -180)
			ui.set(ref.yawbase, "local view")
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], 90)
			ui.set(ref.fakeyawlimit, 60)
		elseif aa.manaa == 3 then
			ui.set(ref.yawjitter[1], "off")
			ui.set(ref.yawjitter[2], 0)
			ui.set(ref.bodyyaw[1], "static")
			ui.set(ref.bodyyaw[2], -180)
			ui.set(ref.yawbase, "at targets")
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], 180)
			ui.set(ref.fakeyawlimit, 60)
		end
	else
		aa.ignore = false
		ui.set(ref.yawbase, "at targets")
	end


	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	if aa.ignore == false then
		ui.set(ref.bodyyaw[2], ui.get(aa_init[var.p_state].aa_static))
		ui.set(byaw, ui.get(aa_init[var.p_state].bodyyaw))
		if true then

			ui.set(jyaw, ui.get(aa_init[var.p_state].yawjitter))
			ui.set(ref.pitch, ui.get(aa_init[var.p_state].pitch))
			ui.set(ref.yawbase, ui.get(aa_init[var.p_state].yawbase))
			ui.set(jyaw_val, ui.get(aa_init[var.p_state].yawjitteradd))
			if c.chokedcommands ~= 0 then
			else
				ui.set(yaw_val,(side == 1 and ui.get(aa_init[var.p_state].yawaddl) or ui.get(aa_init[var.p_state].yawaddr)))
			end
			local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60

			if bodyyaw > 0 then
				ui.set(fake_yaw, ui.get(aa_init[var.p_state].fakeyawlimitr))
			elseif bodyyaw < 0 then
				ui.set(fake_yaw,ui.get(aa_init[var.p_state].fakeyawlimit))
			end
		else
			ui.set(ref.pitch, "Minimal")
			if true then
				if var.p_state == 1 then
					ui.set(ref.pitch, "Minimal")
					ui.set(ref.yawjitter[1], "off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "off")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					ui.set(ref.pitch, "Minimal")
					ui.set(ref.yawjitter[1], "off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "off")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 3 then
					ui.set(ref.pitch, "Minimal")
					ui.set(ref.yawjitter[1], "off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "off")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 4 then
					ui.set(ref.pitch, "Minimal")
					ui.set(ref.yawjitter[1], "off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "off")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then
					ui.set(ref.pitch, "Minimal")
					ui.set(ref.yawjitter[1], "off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "off")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then
					ui.set(ref.pitch, "Minimal")
					ui.set(ref.yawjitter[1], "off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "off")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				end
			end
		end
	 end

end)


local function brute_impact(e)

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local shooter_id = e.userid
	local shooter = client.userid_to_entindex(shooter_id)

	if not entity.is_enemy(shooter) or entity.is_dormant(shooter) then return end

	local lx, ly, lz = entity.hitbox_position(me, "head_0")
	
	local ox, oy, oz = entity.get_prop(me, "m_vecOrigin")
	local ex, ey, ez = entity.get_prop(shooter, "m_vecOrigin")

	local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)
	
	if math.abs(dist) <= 35 and globals.curtime() - brute.last_miss > 0.015 then
		if table_contains(ui.get(aa_init[var.p_state].additions),"Anti-Bruteforce") then
		else
		end
		brute.last_miss = globals.curtime()
		if brute.misses[shooter] == nil then
			brute.misses[shooter] = 1 
			brute.misses_ind[shooter] = 1
		elseif brute.misses[shooter] >= 2 then
			brute.misses[shooter] = nil
		else
			brute.misses_ind[shooter] = brute.misses_ind[shooter] + 1
			brute.misses[shooter] = brute.misses[shooter] + 1
		end
	end
end

brute.reset = function()
	brute.fs_side = 0
	brute.last_miss = 0
	brute.best_angle = 0
	brute.misses_ind = { }
	brute.misses = { }
end

local function brute_death(e)
	
	local victim_id = e.userid
	local victim = client.userid_to_entindex(victim_id)

	if victim ~= entity.get_local_player() then return end

	local attacker_id = e.attacker
	local attacker = client.userid_to_entindex(attacker_id)

	if not entity.is_enemy(attacker) then return end

	if not e.headshot then return end

	if brute.misses[attacker] == nil or (globals.curtime() - brute.last_miss < 0.06 and brute.misses[attacker] == 1) then
		if brute.hit_reverse[attacker] == nil then
			brute.hit_reverse[attacker] = true
		else
			brute.hit_reverse[attacker] = nil
		end
	end
end

local value = 0
local once1 = false
local once2 = false
local dt_a = 0
local dt_y = 45
local dt_x = 0
local dt_w = 0
local os_a = 0
local os_y = 45
local os_x = 0
local os_w = 0
local fs_a = 0
local fs_y = 45
local fs_x = 0
local fs_w = 0
local n_x = 0
local n2_x = 0
local n3_x = 0
local n4_x = 0

local round = function(value, multiplier) local multiplier = 10 ^ (multiplier or 0); return math.floor(value * multiplier + 0.5) / multiplier end

local was_on_ground = false


hitler.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

linear_interpolation = function(start, _end, time)
	return (_end - start) * time + start
end

clamp = function(value, minimum, maximum)
	if minimum > maximum then
		return math.min(math.max(value, maximum), minimum)
	else
		return math.min(math.max(value, minimum), maximum)
	end
end

local function clamp2(val, min_val, max_val)
	return math.max(min_val, math.min(max_val, val))
end

lerp2 = function(start, _end, time)
	time = time or 0.005;
	time = clamp(globals.frametime() * time * 175.0, 0.01, 1.0)
	local a = linear_interpolation(start, _end, time)
	if _end == 0.0 and a < 0.01 and a > -0.01 then
		a = 0.0
	elseif _end == 1.0 and a < 1.01 and a > 0.99 then
		a = 1.0
	end
	return a
end

local testx = 0
local aaa = 0
local lele = 0

local function round(num, decimals)
	local mult = 10^(decimals or 0)
	return math_floor(num * mult + 0.5) / mult
end

local leftcolor_r, leftcolor_g, leftcolor_b, rightcolor_r, rightcolor_g, rightcolor_b = 0,0,0,0,0,0
local scope_add = 0

local function draw()
	local _, y2 = client.screen_size()
	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	local mr,mg,mb,ma = ui.get(main_clr2)
	local mr2,mg2,mb2,ma2 = ui.get(main_clr3)
	local mr3,mg3,mb3,ma3 = ui.get(main_clr4)

	local x, y = client.screen_size()

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local is_charged = antiaim_funcs.get_double_tap()
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fs = ui.get(ref.edgeyaw)
	local is_ba = ui.get(ref.forcebaim)
	local is_sp = ui.get(ref.safepoint)
	local is_qp = ui.get(ref.quickpeek[2])

	if is_charged then dr,dg,db,da=255, 255, 255,255 elseif is_os then dr,dg,db,da=255,255,255,255 else dr,dg,db,da=255,0,0,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end
	--sine_in

	value = value + globals.frametime() * 9

	local _, y2 = client.screen_size()

	local state = "MOVE"

	--states [for searching]
	if ui.get(aa_init[0].aa_stc_tillhit) then
		if brute.can_hit == 0 then
			state = "INDEXED"
		end
	else
		if brute.yaw_status == "brute L" and brute.misses[best_enemy] ~= nil then
			state = "BRUTE ["..brute.misses[best_enemy].."] [L]"
		elseif brute.yaw_status == "brute R" and brute.misses[best_enemy] ~= nil then
			state = "BRUTE ["..brute.misses[best_enemy].."] [R]"
		elseif var.p_state == 7 then
			state = "FAKELAG"
		elseif var.p_state == 5 then
			state = "DUCK"
		elseif var.p_state == 6 then
			state = "DUCK+JUMP"
		elseif var.p_state == 4 then
			state = "JUMPING"
		elseif var.p_state == 3 then
			state = "SLOWWALK"
		elseif var.p_state == 1 then
			state = "STAND"
		elseif var.p_state == 2 then
			state = "MOVE"
		end
	end

	local realtime = globals.realtime() % 3
	local alpha = math.floor(math.sin(realtime * 4) * (180 / 2 - 1) + 180 / 2) or 180

	local exp_ind = ""

	if is_dt then
		exp_ind = "DT"
	elseif is_os then
		exp_ind = "ON-SHOT"
	end

	local me = entity.get_local_player()
	local wpn = entity.get_player_weapon(me)

	local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
	local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
	local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1

	local is_valid = entity.is_alive(me) and wpn ~= nil and scope_level ~= nil
	local act = is_valid and scope_level > 0 and scoped and not resume_zoom

	local flag = "c-"
	local ting = 0
	local testting = 0

	--animation shit

	if is_dt or is_os then
		n4_x = hitler.lerp(n4_x, 8, globals.frametime() * 8)
	else
		n4_x = hitler.lerp(n4_x, -1, globals.frametime() * 8)
	end

	if act then
		flag = "-"
		ting = 23
		testting = 11

		testx = hitler.lerp(testx, 30, globals.frametime() * 5)

		n2_x = hitler.lerp(n2_x, 11, globals.frametime() * 5)

		n3_x = hitler.lerp(n3_x, 5, globals.frametime() * 5)

	else
		testx = hitler.lerp(testx, 0, globals.frametime() * 5)

		n2_x = hitler.lerp(n2_x, 0, globals.frametime() * 5)

		n3_x = hitler.lerp(n3_x, 0, globals.frametime() * 5)

		flag = "c-"
		ting = 28
	end

	if is_dt then if dt_a<255 then dt_a=dt_a+5 end;if dt_w<10 then dt_w=dt_w+0.28 end;if dt_y<36 then dt_y=dt_y+1 end;if fs_x<11 then fs_x=fs_x+0.25 end elseif not is_dt then if dt_a>0 then dt_a=dt_a-5 end;if dt_w>0 then dt_w=dt_w-0.2 end;if dt_y>25 then dt_y=dt_y-1 end;if fs_x>0 then fs_x=fs_x-0.25 end end;if is_os and not is_dt then if os_a<255 then os_a=os_a+5 end;if os_w<12 then os_w=os_w+0.28 end;if os_y<36 then os_y=os_y+1 end;if fs_x<12 then fs_x=fs_x+0.5 end elseif not is_os and not is_dt then if os_a>0 then os_a=os_a-5 end;if os_w>0 then os_w=os_w-0.2 end;if os_y>25 then os_y=os_y-1 end;if fs_x>0 then fs_x=fs_x-0.5 end end;if is_fs then if fs_w<10 then fs_w=fs_w+0.35 end;if fs_a<255 then fs_a=fs_a+5 end;if dt_x>-7 then dt_x=dt_x-0.5 end;if os_x>-7 then os_x=os_x-0.5 end;if fs_y<36 then fs_y=fs_y+1 end elseif not is_fs then if fs_a>0 then fs_a=fs_a-5 end;if fs_w>0 then fs_w=fs_w-0.2 end;if dt_x<0 then dt_x=dt_x+0.5 end;if os_x<0 then os_x=os_x+0.5 end;if fs_y>25 then fs_y=fs_y-1 end end
	
	
	if ui.get(indicator) then
		local add_y = 0
		local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
		if(scoped) then
			if(scope_add < 45) then
				scope_add = scope_add + (45 - scope_add) * 0.2
			else
				scope_add = 45
			end
		else
			if(scope_add > 0) then
				scope_add = scope_add - scope_add * 0.2
			else
				scope_add = 0
			end
		end
		local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
		


		local wx, wy = client.screen_size()
		
		--round_rect(wx - 30, wy - wy - 180, 89, 52, 235)

		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)
		local r8tools_size_x, r8tools_size_y = renderer.measure_text("-", "R8-tools")
		local r8sc_x, r8sc_y = renderer.measure_text("-", "R8-")
		local r8tools_x, r8tools_y = renderer.measure_text("-", "R8-tools ")
		if(bodyyaw > 0) then
			if(leftcolor_r < 255) then
				leftcolor_r = leftcolor_r + (255 - leftcolor_r) * 0.4
			else
				leftcolor_r = 0
			end

			if(leftcolor_g < 255) then
				leftcolor_g = leftcolor_g + (255 - leftcolor_g) * 0.4
			else
				leftcolor_g = 0
			end

			if(leftcolor_b < 255) then
				leftcolor_b = leftcolor_b + (255 - leftcolor_b) * 0.4
			else
				leftcolor_b =0
			end


			if(rightcolor_r < mr) then
				rightcolor_r = rightcolor_r + (mr - rightcolor_r) * 0.4
			end
			if(rightcolor_r > mr) then
				rightcolor_r = rightcolor_r - rightcolor_r * 0.4
			end

			if(rightcolor_g < mg) then
				rightcolor_g = rightcolor_g + (mg - rightcolor_g) * 0.4
			end
			if(rightcolor_g > mg) then
				rightcolor_g = rightcolor_g - rightcolor_g * 0.4
			end

			if(rightcolor_b < mb) then
				rightcolor_b = rightcolor_b + (mb - rightcolor_b) * 0.4
			end
			if(rightcolor_b > mb) then
				rightcolor_b = rightcolor_b - rightcolor_b * 0.4
			end


		else
			if(rightcolor_r < 255) then
				rightcolor_r = rightcolor_r + (255 - rightcolor_r) * 0.4
			else
				rightcolor_r = 0
			end

			if(rightcolor_g < 255) then
				rightcolor_g = rightcolor_g + (255 - rightcolor_g) * 0.4
			else
				rightcolor_g = 0
			end

			if(rightcolor_b < 255) then
				rightcolor_b = rightcolor_b + (255 - rightcolor_b) * 0.4
			else
				rightcolor_b =0
			end


			if(leftcolor_r < mr) then
				leftcolor_r = leftcolor_r + (mr - leftcolor_r) * 0.4
			end
			if(leftcolor_r > mr) then
				leftcolor_r = leftcolor_r - leftcolor_r * 0.4
			end

			if(leftcolor_g < mg) then
				leftcolor_g = leftcolor_g + (mg - leftcolor_g) * 0.4
			end
			if(leftcolor_g > mg) then
				leftcolor_g = leftcolor_g - leftcolor_g * 0.4
			end

			if(leftcolor_b < mb) then
				leftcolor_b = leftcolor_b + (mb - leftcolor_b) * 0.4
			end
			if(leftcolor_b > mb) then
				leftcolor_b = leftcolor_b - leftcolor_b * 0.4
			end
		end

		local statement_x, statement_y = renderer.measure_text("-", state)
		renderer.text(wx / 2-r8tools_size_x / 2 + scope_add, y / 2 + 25, leftcolor_r, leftcolor_g, leftcolor_b, ma, "-", 0, 'R8-')
		renderer.text(x / 2-r8tools_size_x / 2 + r8sc_x + scope_add, y / 2 + 25, rightcolor_r, rightcolor_g, rightcolor_b, ma, "-", 0, 'TOOLS')
		renderer.text(wx / 2-1 + scope_add - statement_x / 2, y / 2 + 25 + r8tools_size_y, mr3, mg3, mb3, ma3, "-", 0, state)

		local dtsize_x, dtsize_y = renderer.measure_text("-", "DOUBLE TAP")
		local aaos_x, aaos_y = renderer.measure_text("-", "AA ONSHOT")
		local aa_x, aa_y = renderer.measure_text("-", "AA ON")
		if is_dt then
			add_y = add_y + statement_y
			renderer.text(x / 2 - 0.5 + scope_add - dtsize_x / 2, y2 / 2 + add_y + 25 + statement_y, dr, dg, db, dt_a, "-", 0, "DOUBLE TAP")
		end
		if is_os then
			add_y = add_y + statement_y
			renderer.text(x / 2 - 0.5 + scope_add - aaos_x / 2, y2 / 2 + add_y + 25 + statement_y, 255, 255, 255, 255, "-", 0, "AA ON")
			renderer.text(x / 2 - 0.5 + scope_add - aaos_x / 2 + aa_x, y2 / 2 + add_y + 25 + statement_y, mr2, mg2, mb2, 255, "-", 0, "SHOT")
		end
	end
end

client.set_event_callback("paint", draw)

local alphabet = "base64"

local function export_config()
	local settings = {}
	for key, value in pairs(var.player_states) do
		settings[tostring(value)] = {}
		for k, v in pairs(aa_init[key]) do
			settings[value][k] = ui.get(v)
		end
	end
	
	clipboard.set(base64.encode(json.stringify(settings), alphabet))
end

local export_btn = ui.new_button("AA", "Anti-aimbot angles", "export antiaim settings", export_config)

local function import_config()

	local settings = json.parse(base64.decode(clipboard.get(), alphabet))

	for key, value in pairs(var.player_states) do
		for k, v in pairs(aa_init[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui.set(v, current)
			end
		end
	end
end

local import_btn = ui.new_button("AA", "Anti-aimbot angles", "import antiaim settings", import_config)


local function config_menu()
	local is_aa = ui.get(aa_init[0].lua_select) == "Config"
	if is_aa then
		ui.set_visible(export_btn, true)
		ui.set_visible(import_btn, true)
	else
		ui.set_visible(export_btn, false)
		ui.set_visible(import_btn, false)
	end
end

client.set_event_callback("paint", draw)
client.set_event_callback("paint_ui", set_lua_menu)
client.set_event_callback("paint_ui", set_og_menu)
client.set_event_callback("paint_ui", config_menu)

ffi.cdef[[
	struct cusercmd
	{
		struct cusercmd (*cusercmd)();
		int     command_number;
		int     tick_count;
	};
	typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
]]

local signature_ginput = base64.decode("uczMzMyLQDj/0ITAD4U=")
local match = client.find_signature("client.dll", signature_ginput) or error("sig1 not found")
local g_input = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("match is nil")
local g_inputclass = ffi.cast("void***", g_input)
local g_inputvtbl = g_inputclass[0]
local rawgetusercmd = g_inputvtbl[8]
local get_user_cmd = ffi.cast("get_user_cmd_t", rawgetusercmd)
local lastlocal = 0
local function reduce(e)
	local cmd = get_user_cmd(g_inputclass , 0, e.command_number)
	if lastlocal + 0.9 > globals.curtime() then
		cmd.tick_count = cmd.tick_count + 8
	else
		cmd.tick_count = cmd.tick_count + 1
	end
end

client.set_event_callback("setup_command", reduce)


local function fire(e)
	if client.userid_to_entindex(e.userid) == entity.get_local_player() then
		lastlocal = globals.curtime()
		if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then
			lastdt = globals.curtime() + 1.1
		end
	end
end

client.set_event_callback("weapon_fire", fire)

local function main()
	client.set_event_callback("run_command", function()
		get_best_enemy()
		get_best_angle()
	end)

	client.set_event_callback("bullet_impact", function(e)
		brute_impact(e)
	end)

	client.set_event_callback("shutdown", function()
		set_og_menu(true)
	end)

	client.set_event_callback("player_death", function(e)
		brute_death(e)
		if client.userid_to_entindex(e.userid) == entity.get_local_player() then
			brute.reset()
		end
	end)

	client.set_event_callback("round_start", function()
		aa.input = 0
		aa.ignore = false
		lastlocal = 0
		lastdt = 0
		brute.reset()
		local me = entity.get_local_player()
		if not entity.is_alive(me) then return end
	end)

	client.set_event_callback("client_disconnect", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)

	client.set_event_callback("game_newmap", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)

	client.set_event_callback("cs_game_disconnected", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)
end
client.set_event_callback("setup_command", on_setup_command)
main()