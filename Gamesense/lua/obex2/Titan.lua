-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local csgo_weapons = require 'gamesense/csgo_weapons'
local ffi = require('ffi')
local clipboard = require 'gamesense/clipboard'
local http = require('gamesense/http')
local vector = require 'vector'
local base64 = require 'gamesense/base64'
local images = require 'gamesense/images'
local lp = entity.get_local_player()
local js = panorama.open()
local persona_api = js.MyPersonaAPI
local GameStateAPI = js.GameStateAPI
local steamid3 = entity.get_steam64(lp)
local name = persona_api.GetName()
local pi, max = math.pi, math.max
local gamerules_ptr = client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")
local gamerules = ffi.cast("intptr_t**", ffi.cast("intptr_t", gamerules_ptr) + 2)[0]
local picurl = "https://github.com/buffles1/titanimages/blob/7548d649bc24ea7e67523818552048e9ae2c8ce4/Titanlogo.png?raw=true"
local newlogo = "https://raw.githubusercontent.com/buffles1/titanimages/main/titan%20full%20logo.png?raw=true"
local dynamic = {}
local builder_menu = {}
local semi_rage = {}
local lp = entity.get_local_player()
local obex_data = obex_fetch and obex_fetch() or {username = 'Admin', build = 'Source'}
local build_get = obex_data.build 
local build = build_get:gsub('User', 'Live')
local username = obex_data.username
local http_data = {
    ['api_key'] = '8bbe04f901c3c9da59b7cdbc6116e13d18dd79bb2a4b75b35c4c601c7faa2681', -- Your api key.
}

function math.round(number, precision)
    local mult = 10 ^ (precision or 0)

    return math.floor(number * mult + 0.5) / mult
end

dynamic.__index = dynamic

function dynamic.new(f, z, r, xi)
   f = max(f, 0.001)
   z = max(z, 0)

   local pif = pi * f
   local twopif = 2 * pif

   local a = z / pif
   local b = 1 / ( twopif * twopif )
   local c = r * z / twopif

   return setmetatable({
      a = a,
      b = b,
      c = c,

      px = xi,
      y = xi,
      dy = 0
   }, dynamic)
end

function dynamic:update(dt, x, dx)
   if dx == nil then
      dx = ( x - self.px ) / dt
      self.px = x
   end

   self.y  = self.y + dt * self.dy
   self.dy = self.dy + dt * ( x + self.c * dx - self.y - self.a * self.dy ) / self.b
   return self
end

function dynamic:get()
   return self.y
end

local function get_velocity(lp)
	local x,y,z = entity.get_prop(lp, "m_vecVelocity")
	if x == nil then return end
	return math.sqrt(x*x + y*y + z*z)
end

client.set_event_callback('setup_command', function (cmd) -- Don't shoot if menu open
	if not ui.is_menu_open() then return end
	cmd.in_attack = false
	cmd.in_attack2 = false
end)

local ref = {
	enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
    fakeyawlimit = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    maxprocticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
    safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
	forcebaim = ui.reference("RAGE", "Other", "Force body aim"),
	fl_limit = ui.reference("AA", "Fake lag", "Limit"),
	variance = ui.reference("AA", "Fake lag", "Variance"),
	fl_amount = ui.reference("AA", "Fake lag", "Amount"),
	dt_limit = ui.reference("RAGE", "Other", "Double tap fake lag limit"),
	enable_fl = ui.reference("AA", "Fake Lag", "Enabled"),
	quickpeek = { ui.reference("RAGE", "Other", "Quick peek assist") },
	yawjitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
	bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
	freestand = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
	os = { ui.reference("AA", "Other", "On shot anti-aim") },
	slow = { ui.reference("AA", "Other", "Slow motion") },
	leg_movement = ui.reference("AA", "Other", "Leg Movement"),
	dt = { ui.reference("RAGE", "Other", "Double tap") },
	fakelag = ui.reference("AA", "Fake lag", "Enabled"),
	pingspike = {ui.reference("MISC", "Miscellaneous", "Ping Spike")},
	roll_angles = ui.reference("AA", "Anti-aimbot angles", "Roll"),
	log_damage = ui.reference("MISC", "Miscellaneous", "Log damage dealt"), 
	min_damage = ui.reference("RAGE", "Aimbot", "Minimum Damage"),
	dpi = ui.reference("MISC", "Settings", "DPI Scale"),
	autofire = ui.reference("RAGE", "Aimbot", "Automatic fire"),
	autowall = ui.reference("RAGE", "Aimbot", "Automatic penetration")
}
ui.set_visible(ref.maxprocticks, false)

local var = {
	state_to_idx = {["Standing"] = 1, ["Crouching"] = 2, ["Air"] = 3, ["Moving"] = 4, ["Slow"] = 5, ["Air-Duck"] = 6,},
	roll_states = {"Standing", "Slow Motion", "Crouching"},
	player_states = {"Standing", "Crouching", "Air", "Moving", "Slow", "Air-Duck"},
	presets = {"Default", "Meta", "Alternate", "Anti-NL"},
	primary = {"-", "AWP", "Scout", "Auto"},
	secondary = {"-", "Heavy", "FiveSeven/Tec9", "Dualies"}, 
	grenades = {"HE Grenade", "Molotov/Incendiary", "Smoke"},
	utility = {"Armor", "Helmet", "Zeus", "Defuser"}, 
	playerstate = "",
	active_i = 1,
	p_state = 0,
	clantag_enbl = false,
	t_clantag = "T i t a n ",
	t_time = 0,
	should_avoid = false,
	debug_x = 50, 
	debug_y = 500,
	angle = 0,
	active_exploits = "",
	ae_spacer = 0,
}

local animated = {
    scope = 0,
    bar = 0,
    height = 0, 
	indic = 0,
}

local titan_menu = {
	enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Titan"),
	vis_select = ui.new_combobox("AA", "Anti-AImbot Angles", "\n", "Anti-Aim", "Visuals", "Miscellaneous", "Hotkeys"),

	aa_label = ui.new_label("AA", "Anti-aimbot angles", "\a4BF7FFFF >> AntiAim"),
	aa_mode_select = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-Aim Mode", "Presets", "Builder"),
	aa_preset_select = ui.new_combobox("AA", "Anti-Aimbot Angles", "Preset Select", var.presets),
	aa_options = ui.new_multiselect("AA", "Anti-Aimbot Angles", "Anti-Aim Options", "Legit AA On E", "Manual Sides"), 
	roll_check = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Enable Roll"), 
	roll_states = ui.new_combobox("AA", "Anti-Aimbot Angles", "Player States", var.roll_states),
	roll_standing = ui.new_slider("AA", "Anti-Aimbot Angles", "Standing Roll Amount", -50, 50, 0, true, "°", 1),
	roll_crouching = ui.new_slider("AA", "Anti-Aimbot Angles", "Crouching Roll Amount", -50, 50, 0, true, "°", 1),
	roll_slowmo = ui.new_slider("AA", "Anti-Aimbot Angles", "Slowwalk Roll Amount", -50, 50, 0, true, "°", 1), 
	roll_force_amt = ui.new_slider("AA", "Anti-Aimbot Angles", "Force Roll Amount", -50, 50, 0, true, "°", 1),

	misc_enhancements = ui.new_multiselect("AA", "Anti-Aimbot Angles", "\a4BF7FFFF >> Misc Enhancements", "Teleport On Peek", "Avoid Backstab"),
	avoid_label = ui.new_label("AA", "Anti-Aimbot Angles", "\a4BF7FFFF >> Avoid Backstab"),
	avoiddist = ui.new_slider("AA", "Anti-Aimbot Angles", "Avoid Backstab Trigger Distance", 0, 300, 150, true, 'u'),

	build_label = ui.new_label("AA", "Anti-Aimbot Angles", "\a4BF7FFFF >> Builder"),
	build_spacer = ui.new_label("AA", "Anti-Aimbot Angles", "Player States"),
	build_options = ui.new_combobox("AA", "Anti-Aimbot Angles", "\n", var.player_states),

    hotkey_label = ui.new_label("AA", "Anti-Aimbot Angles", "\a4BF7FFFF >> Hotkeys"),
	force_roll = ui.new_hotkey("AA", "Anti-Aimbot Angles", "Force Roll", false),
	fskey = ui.new_hotkey("AA", "Anti-Aimbot Angles", "Freestanding", false),
	edge_yaw = ui.new_hotkey("AA", "Anti-Aimbot Angles", "Edge Yaw", false),
	telepeek = ui.new_hotkey("AA", "Anti-Aimbot Angles", "Teleport On Peek", false), 
	manual_left = ui.new_hotkey("AA", "Anti-Aimbot Angles", "Manual Left", false),
	manual_right = ui.new_hotkey("AA", "Anti-Aimbot Angles", "Manual Right", false),

	tele_label = ui.new_label("AA", "Anti-Aimbot Angles", "\a4BF7FFFF >> Teleport On Peek"),
	pred_dist = ui.new_slider('AA', "Anti-Aimbot Angles", 'Predicted Distance', 100, 300, 240, true, 'u', 1, { }),
	pred_ticks = ui.new_slider('AA', "Anti-Aimbot Angles", 'Predicted Ticks', 75, 100, 75, true, 't', 1, {}),

	ind_set = ui.new_multiselect("AA", "Anti-Aimbot Angles", "\a4BF7FFFF >> Visuals", {"Indicators", "Min Damage Indicator"}),
	ind_clr = ui.new_color_picker("AA", "Anti-Aimbot Angles", "Indicator color picker", 0, 255, 255, 255, true),
	ind_style = ui.new_combobox("AA", "Anti-Aimbot Angles", "Indicator Style", "Titan", "Modern", "Alternative"),
	wm_enable = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Enable Watermark"),
	hm_logs = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Enable Logs"),
	debug_panel = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Enable Debug Panel"),
	snap_lines = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Enable Threat Snapline"),

	autobuy_check = ui.new_checkbox("AA", "Anti-Aimbot Angles", "\a4BF7FFFF >> Autobuy"),
	autobuy = ui.new_combobox("AA", "Anti-Aimbot Angles", "Primary", var.primary),
	autobuy_second = ui.new_combobox("AA", "Anti-Aimbot Angles", "Secondary", var.secondary),
	autobuy_grenades = ui.new_multiselect("AA", "Anti-Aimbot Angles", "Grenades", var.grenades),
	autobuy_utility = ui.new_multiselect("AA", "Anti-Aimbot Angles", "Utility", var.utility),
	clantag = ui.new_checkbox("AA", "Anti-Aimbot ANgles", "Enable Clantag"),
	config_label = ui.new_checkbox("AA", "Anti-Aimbot Angles", "\a4BF7FFFF >> Config Import/Export"),
	import_config = ui.new_button("AA", "Anti-Aimbot Angles", "Import Builder Config", function()
		local settings = json.parse(base64.decode(clipboard.get()))

		for key, value in pairs(var.player_states) do 
			for k, v in pairs(builder_menu[key]) do 
				local current = settings[value][k]
				if (current ~= nil) then 
					ui.set(v, current)
				end
			end
		end
		print("[Titan] Successfully imported config!")
	end),
	export_config = ui.new_button("AA", "Anti-Aimbot Angles", "Export Builder Config", function()
		local settings = {}
		
		for key, value in pairs(var.player_states) do
			settings[tostring(value)] = {}
			for k, v in pairs(builder_menu[key]) do
				settings[value][k] = ui.get(v)
			end
		end
		clipboard.set(base64.encode(json.stringify(settings)))
		print("[Titan] Successfully exported config!")
	end),
}

local function welcome_message(e) 
    client.exec("clear")
    client.color_log(0, 255, 0, "[Titan] Loaded Successfully!")
    client.color_log(0, 255, 0, "[Titan] Build Version: " .. build)
    client.delay_call(2, client.exec, "Clear")
	client.delay_call(2, client.color_log, 0, 255, 255, "                                                       ")
	client.delay_call(2, client.color_log, 0, 255, 255, " _|_|_|_|_|  _|_|_|  _|_|_|_|_|    _|_|    _|      _|  ")
	client.delay_call(2, client.color_log, 0, 255, 255, "     _|        _|        _|      _|    _|  _|_|    _|  ")
	client.delay_call(2, client.color_log, 0, 255, 255, "     _|        _|        _|      _|_|_|_|  _|  _|  _|  ")
	client.delay_call(2, client.color_log, 0, 255, 255, "     _|        _|        _|      _|    _|  _|    _|_|  ")
	client.delay_call(2, client.color_log, 0, 255, 255, "     _|      _|_|_|      _|      _|    _|  _|      _|  ")
	client.delay_call(2, client.color_log, 0, 255, 255, "                                                       ")
    client.delay_call(2, client.color_log, 0, 255, 255, "[Titan] Welcome " .. username .. "!")
end
welcome_message()

local c_tag = {
	i = 1,
	a = 1,
	c = 0
}

local function animate_string()
	local str = ""
	local cur = 0

	if c_tag.i == 0 then
		str = str .. ""
	end

	for i in string.gmatch(var.t_clantag, "%S+") do
		cur = cur + 1
		str = str .. i

		if c_tag.i == cur then
			str = str .. " -"
		end

		if cur > c_tag.c then
			c_tag.c = cur
		end
	end

	if c_tag.i >= c_tag.c then
		c_tag.a = -1
	elseif c_tag.i <= 0 then
		c_tag.a = 1
	end

	c_tag.i = c_tag.i + c_tag.a
	return str
end

local function rgbToHex(r, g, b)
    r = tostring(r);g = tostring(g);b = tostring(b)
    r = (r:len() == 1) and '0'..r or r;g = (g:len() == 1) and '0'..g or g;b = (b:len() == 1) and '0'..b or b

    local rgb = (r * 0x10000) + (g * 0x100) + b
    return (r == '00' and g == '00' and b == '00') and '000000' or string.format('%x', rgb)
end

local colours = {
	red = '\a'..rgbToHex(255, 0, 0)..'ff',
    titan = '\a4BF7FFFF',
    white = '\a'..rgbToHex(255,255,255)..'ff',
	texp_clr = '\a'..rgbToHex(0, 255, 0)..'ff',
	fexp_clr = '\a'..rgbToHex(255, 0, 0)..'ff',
}

local function get_player_state(c)
    if entity.get_local_player() == nil then return end

    local vx, vy = entity.get_prop(entity.get_local_player(), 'm_vecVelocity')
    local player_standing = math.sqrt(vx ^ 2 + vy ^ 2) < 2
	local player_jumping = bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) == 0
    local player_duck_peek_assist = ui.get(ref.fakeduck)
    local player_crouching = entity.get_prop(entity.get_local_player(), "m_flDuckAmount") > 0.5 and not player_duck_peek_assist
    local player_slow_motion = ui.get(ref.slow[1]) and ui.get(ref.slow[2])

    if player_duck_peek_assist then
        return 'fakeduck'
    elseif player_slow_motion then
        return 'slowmotion'
    elseif player_crouching and not player_jumping then
        return 'crouch'
    elseif player_jumping and not player_crouching then
        return 'jump'
    elseif player_standing then
        return 'stand'
	elseif player_jumping and player_crouching then 
		return 'airduck'
    elseif not player_standing then
        return 'move'
	else 
		return 'global'
    end
end

local ticks_to_time = function(ticks)
    return globals.tickinterval() * ticks
end

local function is_visible() -- credits gamesensical docs
	local local_player = entity.get_local_player()
	local eye_x, eye_y, eye_z = client.eye_position()
	local enemies = entity.get_players(true)

	for i=1, #enemies do
		local entindex = enemies[i]
		local head_x, head_y, head_z = entity.hitbox_position(entindex, 0)

		if head_x and head_y and head_z ~= nil then
			local r, g, b, a = 255, 255, 255, 100

			local fraction, entindex_hit = client.trace_line(local_player, eye_x, eye_y, eye_z, head_x, head_y, head_z)

			if entindex_hit == entindex or fraction == 1 then
				return true 
			end
		end
	end
end

local function get_ent_dist(ent_1, ent_2) 
    local ent1_pos = vector(entity.get_prop(ent_1, 'm_vecOrigin'))
    local ent2_pos = vector(entity.get_prop(ent_2, 'm_vecOrigin'))

    local dist = ent1_pos:dist(ent2_pos)

    return dist
end

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

local function SetTableVisibility(table, state)
    for i = 1, #table do
        ui.set_visible(table[i], state)
    end
end

local function dt_charge_state()
    if not ui.get(ref.dt[2]) or ui.get(ref.fakeduck) then return false end

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

local function antiknife()
	ui.set(ref.pitch, "Default")
	ui.set(ref.yawbase, "At targets")
    ui.set(ref.yaw[1], "Off")
    ui.set(ref.yaw[2], 0)
    ui.set(ref.yawjitter[1], "Center")
    ui.set(ref.yawjitter[2], 5)
    ui.set(ref.bodyyaw[1], "Jitter")
    ui.set(ref.bodyyaw[2], 0)
    ui.set(ref.fakeyawlimit, 60)
end

local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local function round(num, decimals)
	local mult = 10^(decimals or 0)
	return math_floor(num * mult + 0.5) / mult
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

local function legit_aa(c) -- Legit AA on E
	local lp = entity.get_local_player()
	local holding_e = client.key_state(0x45)
	if not entity.is_alive(lp) then return end
	local weaponn = entity.get_player_weapon()
	if contains(titan_menu.aa_options, "Legit AA On E") and holding_e then
		ui.set(ref.pitch, "Off")
		ui.set(ref.yawbase, "Local View")
		ui.set(ref.yaw[1], "Off")
		ui.set(ref.yawjitter[1], "Off")
		ui.set(ref.bodyyaw[1], "Opposite")
		ui.set(ref.fsbodyyaw, true)
		if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
			if c.in_attack == 1 then
				c.in_attack = 0 
				c.in_use = 1
			end
		else
			if c.chokedcommands == 0 then
				c.in_use = 0
			end
		end
	else 
		ui.set(ref.fsbodyyaw, false)
	end
end

local function dragging(x, y, w, h)
	local mouse_pos_x, mouse_pos_y = ui.mouse_position()
	local menu_open = ui.is_menu_open()

	if not menu_open then 
		return false
	end 

	if mouse_pos_x > x and mouse_pos_x < x + w and mouse_pos_y > y and mouse_pos_y < y + h then
		return true
	else
		return false
	end
end

local function printChoked(cmd) 
	local choking = globals.chokedcommands()

	return choking
end

local weapons = {
	primary = {
	["Auto"] = "buy g3sg1;buy scar20;buy deagle;buy vesthelm;buy vest;buy hegrenade;buy incgrenade;buy molotov;buy smokegrenade;buy defuser;buy taser;", 
	["Scout"] = "buy ssg08;buy deagle;buy vesthelm;buy vest;buy hegrenade;buy incgrenade;buy molotov;buy smokegrenade;buy defuser;buy taser;",
	["AWP"] = "buy awp;buy deagle;buy vesthelm;buy vest;buy hegrenade;buy incgrenade;buy molotov;buy smokegrenade;buy defuser;buy taser;", 
	},

	secondary = {
		["Heavy"] = "buy deagle; buy revolver;", 
		["FiveSeven/Tec9"] = "buy tec9;" ,
		["Dualies"] = "buy elite;",
	},

	grenades = {
		["Molotov/Incendiary"] = "buy molotov; buy incgrenade;", 
		["HE Grenade"] = "buy hegrenade", 
		["Smoke"] = "buy smokegrenade",
	}, 

	utility = {
		["Zeus"] = "buy taser", 
		["Defuser"] = "buy defuser", 
		["Helmet"] = "buy vesthelm",
		["Armor"] = "buy vest",
	}
}

local function run_autobuy()
	for k, v in pairs(weapons.primary) do 
		if k == ui.get(titan_menu.autobuy) then 
			client.exec(v) 
		end
	end
	for k, v in pairs(weapons.secondary) do 
		if k == ui.get(titan_menu.autobuy_second) then 
			client.exec(v) 
		end
	end

	local grenade_value = ui.get(titan_menu.autobuy_grenades)

	for gindex = 1, table.getn(grenade_value) do 

		local value_at_index = grenade_value[gindex]

		for k, v in pairs(weapons.grenades) do 

			if k == value_at_index then 

				client.exec(v)
			end
		end
	end

	local utility_value = ui.get(titan_menu.autobuy_utility)

	for uindex = 1, table.getn(utility_value) do 

		local value_at_index = utility_value[uindex]

		for k, v in pairs(weapons.utility) do 

			if k == value_at_index then 

				client.exec(v)
			end
		end
	end
end

local function on_round_prestart(e)
	local lp = entity.get_local_player()
	local money = entity.get_prop(lp, "m_iAccount" )
	local pRound = entity.get_prop(entity.get_game_rules(), "m_totalRoundsPlayed")
	if ui.get(titan_menu.autobuy_check) then  
		if pRound ~= 0 or pRound ~= 15 and money > 800 then
			client.delay_call(1.25, run_autobuy)
		elseif pRound == 0 or pRound == 15 and money <= 800 then
			client.log("[Titan] Skipped Autobuy For Pistol Round.")	
		end 
	end
end

local indicatorText = {} -- Indicators begin.
local function process_indicator_table()
	sizeCount = 0
   if ui.get(ref.fakeduck) then
	sizeCount = sizeCount + 10
      indicatorText["FD"] = "FD"
   elseif indicatorText["FD"] then
      indicatorText["FD"] = nil
   end

   if ui.get(ref.pingspike[1]) and ui.get(ref.pingspike[2]) then
	sizeCount = sizeCount + 10
      indicatorText["PING"] = "PING"
   elseif indicatorText["PING"] then
      indicatorText["PING"] = nil
   end

   if ui.get(ref.os[1]) and ui.get(ref.os[2]) then
	sizeCount = sizeCount + 10
      indicatorText["HS"] = "OS"
   elseif indicatorText["HS"] then
      indicatorText["HS"] = nil
   end

   if ui.get(ref.edgeyaw) then
	sizeCount = sizeCount + 10
      indicatorText["EDGE"] = "EDGE"
   elseif indicatorText["EDGE"] then
      indicatorText["EDGE"] = nil
   end

   if ui.get(ref.freestand[1]) and ui.get(ref.freestand[2]) then 
	sizeCount = sizeCount + 10
	indicatorText["FREESTANDING"] = "FS"
   elseif indicatorText["FREESTANDING"] then 
	indicatorText["FREESTANDING"] = nil 
   end

   if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then
	sizeCount = sizeCount + 10
      indicatorText["Double Tap"] = "DT"
   elseif indicatorText["Double Tap"] then 
    indicatorText["Double Tap"] = nil
   end

   if ui.get(ref.quickpeek[1]) and ui.get(ref.quickpeek[2]) then 
	sizeCount = sizeCount + 10
	indicatorText["PEEK"] = "PEEK"
   elseif indicatorText["PEEK"] then 
	indicatorText["PEEK"] = nil
   end

   if ui.get(titan_menu.telepeek) then 
	sizeCount = sizeCount + 10 
	indicatorText["TELEPORT"] = "TELEPORT" 
   elseif indicatorText["TELEPORT"] then 
	indicatorText["TELEPORT"] = nil 
   end
end

client.set_event_callback('setup_command', function(cmd) -- Force roll key
	if not ui.get(titan_menu.roll_check) then 
		return 
	end 
	
	if ui.get(titan_menu.force_roll) then 
		cmd.roll = ui.get(titan_menu.roll_force_amt)
	else 
		cmd.roll = 0
	end
end)

client.set_event_callback('setup_command', function(cmd) -- teleport on peek
	if not contains(titan_menu.misc_enhancements, "Teleport On Peek") then return end
	local lp = entity.get_local_player()
	enemies = entity.get_players(true)
	ticktime = ticks_to_time(ui.get(titan_menu.pred_ticks))
	local has_teleported
	for i, v in ipairs(enemies) do
        lvel = vector(entity.get_prop(lp, 'm_vecVelocity'))
        dist = get_ent_dist(lp, v)
        p_dist = get_ent_dist(lp * ticktime, v * ticktime)
        origin = vector(entity.get_origin(v * ticktime))
        eye_pos = vector(client.eye_position()) + (lvel * ticktime)
        trace_line = client.trace_line(lp, eye_pos.x, eye_pos.y, eye_pos.z, origin.x, origin.y, origin.z)
		if enemies == nil then return end

		if ui.get(titan_menu.telepeek) then
			ui.set(ref.dt[2], "Always On")
			ui.set(ref.dt[1], true)
			has_teleported = false
			ui.set(ref.maxprocticks, 17)
			if (p_dist < ui.get(titan_menu.pred_ticks)) and is_visible() then
				ui.set(ref.dt[1], false)
				has_teleported = true 
			else 
				ui.set(ref.dt[1], true)
			end
			if (p_dist < ui.get(titan_menu.pred_dist)) and is_visible() then
				ui.set(ref.dt[1], false)
				has_teleported = true 
			else 
				ui.set(ref.dt[1], true)
			end
		else
			ui.set(ref.dt[1], true)
			ui.set(ref.dt[2], "Toggle")
		end
    end
end)

misc = {}
misc.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

misc.anti_knife = function()
    if contains(titan_menu.misc_enhancements, "Avoid Backstab") then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
        local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = misc.anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(titan_menu.avoiddist) then
                ui.set(yaw_slider, 180)
                ui.set(pitch, "Off")
            end
        end
    end
end

client.set_event_callback('setup_command', function(cmd)
	local local_player = entity.get_local_player()
	if local_player == nil then return end 
	if not entity.is_alive(local_player) then return end
	if not ui.get(titan_menu.enabled) then return end
	if not ui.get(titan_menu.roll_check) then 
		ui.set(ref.roll_angles, 0)
		return 
	end

	if ui.get(titan_menu.roll_check) and ui.get(titan_menu.aa_mode_select) == "Presets" then 
		if get_player_state() == "stand" then 
			ui.set(ref.roll_angles, ui.get(titan_menu.roll_standing))
		elseif get_player_state() == "slowmotion" then 
			ui.set(ref.roll_angles, ui.get(titan_menu.roll_slowmo))
		elseif  get_player_state() == "crouch" then 
			ui.set(ref.roll_angles, ui.get(titan_menu.roll_crouching))
		end
	end
end)

local function run_clantag()
	if ui.get(titan_menu.clantag) then
		local time = globals.tickcount() * globals.tickinterval()

		if var.t_time + 0.3 < time then
			client.set_clan_tag(animate_string())
			var.t_time = time
		elseif var.t_time > time then
			var.t_time = time
		end
		
		var.clantag_enbl = true
	elseif not ui.get(titan_menu.clantag) and var.clantag_enbl then
		client.set_clan_tag("")
		var.clantag_enbl = false
	end
end

for i = 1, 6 do 
	builder_menu[i] = {
		b_enable = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Enable " .. var.player_states[i] .. " Anti-Aim"), 
		
		b_pitch = ui.new_combobox("AA", "Anti-Aimbot Angles", "Pitch\n" .. var.player_states[i], { "Off", "Default", "Up", "Down", "Minimal", "Random" }), 
		b_yawbase = ui.new_combobox("AA", "Anti-Aimbot Angles", "Yaw Base\n" .. var.player_states[i], { "Local view", "At targets" }), 
		b_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw\n" .. var.player_states[i], { "Off", "180", "Spin", "Static", "180 Z", "Crosshair" }),
		b_yawaddl = ui.new_slider("AA", "Anti-aimbot angles", "Yaw Add Left\n" .. var.player_states[i], -180, 180, 0),
		b_yawaddr = ui.new_slider("AA", "Anti-aimbot angles", "Yaw Add Right\n" .. var.player_states[i], -180, 180, 0),
		b_yawjitter = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw Jitter\n" .. var.player_states[i], { "Off", "Offset", "Center", "Random" }),
		b_yawjitteradd = ui.new_slider("AA", "Anti-aimbot angles", "\nYaw Jitter Add" .. var.player_states[i], -180, 180, 0),
		b_bodyyaw = ui.new_combobox("AA", "Anti-aimbot angles", "Body Yaw\n" .. var.player_states[i], { "Off", "Opposite", "Jitter", "Static" }),
		b_bodyyawadd = ui.new_slider("AA", "Anti-aimbot angles", "\nBody Yaw Add" .. var.player_states[i], -180, 180, 0),
		b_fakeyawlimit = ui.new_slider("AA", "Anti-aimbot angles", "Fake Yaw Limit\n" .. var.player_states[i], 0, 60, 60),
		b_fakeyawmode = ui.new_combobox("AA", "Anti-Aimbot Angles", "Fake Yaw Mode\n" .. var.player_states[i], {"Off", "Static", "Custom Left/Right"}),
		b_fakeleft = ui.new_slider("AA", "Anti-aimbot angles", "Fake Yaw Left\n" .. var.player_states[i], 0, 60, 60), 
		b_fakeright = ui.new_slider("AA", "Anti-aimbot angles", "Fake Yaw Right\n" .. var.player_states[i], 0, 60, 60), 
		b_roll = ui.new_slider("AA", "Anti-aimbot angles", "Roll Amount\n" .. var.player_states[i], -50, 50, 0),
	}
end

local function builder_vis()
	if not ui.get(titan_menu.aa_mode_select) == "Builder" then return end 
	var.active_i = var.state_to_idx[ui.get(titan_menu.build_options)] 
	local selected = ui.get(titan_menu.vis_select) == "Anti-Aim"
	local show_item = ui.get(titan_menu.aa_mode_select) == "Builder"
	local script_enabled = ui.get(titan_menu.enabled)

	for i = 1, #var.player_states do 
		local enabled = ui.get(builder_menu[i].b_enable)

		ui.set_visible(builder_menu[i].b_enable, var.active_i == i and selected and show_item and script_enabled)
		ui.set_visible(builder_menu[i].b_pitch, var.active_i == i and selected and show_item and enabled and script_enabled)
		ui.set_visible(builder_menu[i].b_yawbase, var.active_i == i and selected and show_item and enabled and script_enabled)
		ui.set_visible(builder_menu[i].b_yaw, var.active_i == i and selected and show_item and enabled and script_enabled)
		ui.set_visible(builder_menu[i].b_yawaddl, var.active_i == i and selected and show_item and enabled and ui.get(builder_menu[var.active_i].b_yaw) ~= "Off" and script_enabled)
		ui.set_visible(builder_menu[i].b_yawaddr, var.active_i == i and selected and show_item and enabled and ui.get(builder_menu[var.active_i].b_yaw) ~= "Off" and script_enabled)
		ui.set_visible(builder_menu[i].b_yawjitter, var.active_i == i and selected and show_item and enabled and script_enabled)
		ui.set_visible(builder_menu[i].b_yawjitteradd, var.active_i == i and selected and show_item and enabled and ui.get(builder_menu[var.active_i].b_yawjitter) ~= "Off" and script_enabled)
		ui.set_visible(builder_menu[i].b_bodyyaw, var.active_i == i and selected and show_item and enabled and script_enabled)
		ui.set_visible(builder_menu[i].b_bodyyawadd, var.active_i == i and selected and show_item and enabled and ui.get(builder_menu[var.active_i].b_bodyyaw) ~= "Off" and ui.get(builder_menu[var.active_i].b_bodyyaw) ~= "Opposite" and script_enabled)
		ui.set_visible(builder_menu[i].b_fakeyawmode, var.active_i == i and selected and show_item and enabled and script_enabled)
		ui.set_visible(builder_menu[i].b_fakeyawlimit, var.active_i == i and selected and show_item and enabled and ui.get(builder_menu[var.active_i].b_fakeyawmode) == "Static" and script_enabled)
		ui.set_visible(builder_menu[i].b_fakeleft, var.active_i == i and selected and show_item and enabled and ui.get(builder_menu[var.active_i].b_fakeyawmode) == "Custom Left/Right" and script_enabled)
		ui.set_visible(builder_menu[i].b_fakeright, var.active_i == i and selected and show_item and enabled and ui.get(builder_menu[var.active_i].b_fakeyawmode) == "Custom Left/Right" and script_enabled)
		ui.set_visible(builder_menu[i].b_roll, var.active_i == i and selected and show_item and enabled and script_enabled)
	end
end

local function run_aa(c) -- Titan Mode
	local local_player = entity.get_local_player()
	if local_player == nil then return end 
	if not entity.is_alive(local_player) then return end
	if not ui.get(titan_menu.enabled) then return end
	local slowwalk = ui.get(ref.slow[1]) and ui.get(ref.slow[2])
	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1
	local vx, vy, vz = entity.get_prop(local_player, "m_vecVelocity")
	state = get_player_state(c)

	var.p_state = 1
	if state == 'stand'  then 
		var.playerstate = "STAND"
		var.p_state = 1
	elseif state == 'crouch' then 
		var.playerstate = "CROUCH"
		var.p_state = 2 
	elseif state == 'jump' then 
		var.playerstate = 'AIR'
		var.p_state = 3 
	elseif state == 'move'  then 
		var.playerstate = "MOVING" 
		var.p_state = 4
	elseif state == 'slowmotion' then 
		var.playerstate = "SLOWMOTION"
		var.p_state = 5
	elseif state == 'airduck'  then 
		var.playerstate = "AIR-DUCK"
		var.p_state = 6
	elseif state == 'fakeduck' then 
		var.playerstate = "FAKEDUCK"
		var.p_state = 2
	end

	if ui.get(titan_menu.aa_mode_select) == "Presets" then 
		local selected = ui.get(titan_menu.aa_preset_select)
		ui.set(ref.fl_limit, 14)
		ui.set(ref.pitch, "Minimal")
		ui.set(ref.yawbase, "At targets")
		ui.set(ref.yaw[1], 180)
			if selected == "Meta" then 
				if var.p_state == 1 then -- stand
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 36)
					ui.set(ref.bodyyaw[1], "jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then -- crouching
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 48)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -10 or 15))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 3 then -- air
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 63)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 5 or 12))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 4 then -- moving
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 38)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -23 or 20))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then -- slowwalk
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 50)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -13 or 9))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then -- airduck
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 48)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -10 or 15))
					end
					ui.set(ref.fakeyawlimit, 60)
				end
			end
			if selected == "Default" then 
				if var.p_state == 1 then -- stand
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 36)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then -- crouch
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 43)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 3 then -- air
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 50)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -13 or 9))
					end
					ui.set(ref.fakeyawlimit, 59)
				elseif var.p_state == 4 then -- moving
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 53)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -10 or 11))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then -- slowwalk
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 47)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -5 or 14))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then -- airduck
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 47)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -5 or 14))
					end
					ui.set(ref.fakeyawlimit, 60)
				end 
			end
			if selected == "Alternate" then 
				if var.p_state == 1 then -- stand
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 36)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then -- crouch
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 48)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -10 or 5))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 3 then -- air
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 63)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 12 or 5))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 4 then -- moving
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 36)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then -- slowwalk
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 50)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -13 or 9))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then -- airduck
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 53)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				end 
			end
			if selected == "Anti-NL" then 
				if var.p_state == 1 then -- stand
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 18)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -6 or 10))
					end
					ui.set(ref.fakeyawlimit, 30)
				elseif var.p_state == 2 then -- crouch
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 24)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -5 or 2))
					end
					ui.set(ref.fakeyawlimit, 30)
				elseif var.p_state == 3 then -- air
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 31)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 6 or 2))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 4 then -- moving
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 18)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -6 or 9))
					end
					ui.set(ref.fakeyawlimit, 45)
				elseif var.p_state == 5 then -- slowwalk
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 25)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -7 or 4))
					end
					ui.set(ref.fakeyawlimit, 30)
				elseif var.p_state == 6 then -- airduck
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 21)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -6 or 9))
					end
					ui.set(ref.fakeyawlimit, 30)
				end

		elseif var.should_avoid == true and contains(titan_menu.misc_enhancements, "Avoid Backstab") then 
			antiknife()
		end
	elseif ui.get(titan_menu.aa_mode_select) == "Builder" then 	
		ui.set(ref.fl_limit, 14)
		for i = 1, 6 do
			if ui.get(builder_menu[var.active_i].b_enable) == false then return end

			ui.set(ref.pitch, ui.get(builder_menu[var.p_state].b_pitch))
			ui.set(ref.yawbase, ui.get(builder_menu[var.p_state].b_yawbase))
			
			if var.should_avoid == false then -- for anti knife shid
				ui.set(ref.yaw[1], ui.get(builder_menu[var.p_state].b_yaw))
			elseif var.should_avoid == true then 
				ui.set(ref.yaw[1], "Off")
			end
			
			ui.set(ref.yawjitter[1], ui.get(builder_menu[var.p_state].b_yawjitter))
			ui.set(ref.yawjitter[2], ui.get(builder_menu[var.p_state].b_yawjitteradd))
			ui.set(ref.bodyyaw[1], ui.get(builder_menu[var.p_state].b_bodyyaw))
			ui.set(ref.bodyyaw[2], ui.get(builder_menu[var.p_state].b_bodyyawadd))

			ui.set(ref.roll_angles, ui.get(builder_menu[var.p_state].b_roll))

			if c.chokedcommands ~= 0 then
			else
				ui.set(ref.yaw[2],(side == 1 and ui.get(builder_menu[var.p_state].b_yawaddl) or ui.get(builder_menu[var.p_state].b_yawaddr)))
			end

			if ui.get(builder_menu[var.active_i].b_fakeyawmode) == "Static" then 
				ui.set(ref.fakeyawlimit, ui.get(builder_menu[var.p_state].b_fakeyawlimit))
			elseif ui.get(builder_menu[var.active_i].b_fakeyawmode) == "Custom Left/Right" then 
				if bodyyaw > 0 then
					ui.set(ref.fakeyawlimit, ui.get(builder_menu[var.p_state].b_fakeleft))
				elseif bodyyaw < 0 then
					ui.set(ref.fakeyawlimit, ui.get(builder_menu[var.p_state].b_fakeright))
				end
			else 
				ui.set(ref.fakeyawlimit, 0)
			end
		end
	end
	if contains(titan_menu.aa_options, "Manual Sides") then 
		if ui.get(titan_menu.manual_left) then 
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], -90)
		elseif ui.get(titan_menu.manual_right) then 
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], 90)
		end
	end
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
local logs = {}

local function fired(e)
	stored_shot = {
        damage = e.damage,
        hitbox = hitgroup_names[e.hitgroup + 1],
        lagcomp = e.teleported,
        backtrack = globals.tickcount() - e.tick
    }
end

local function hit(e)
    local string = string.format("Hit %s for %s in the %s [hc: %s, bt: %s, lc: %s]", entity.get_player_name(e.target), e.damage, hitgroup_names[e.hitgroup + 1] or '?',  math.floor(e.hit_chance).."%", stored_shot.backtrack, stored_shot.lagcomp)
    table.insert(logs, {
        text = string
    }) 
    if ui.get(titan_menu.hm_logs) then
        r, g, b = ui.get(titan_menu.ind_clr)
        --client.color_log(r, g, b, "[gamesense] \0")
        client.color_log(255, 255, 255, string)
    end
end

local function missed(e)
    local string = string.format("Missed %s's %s due to %s [dmg: %s, bt: %s, lc: %s]", entity.get_player_name(e.target), stored_shot.hitbox, e.reason, stored_shot.damage, stored_shot.lagcomp, stored_shot.backtrack)
    table.insert(logs, {
        text = string
    })
    if ui.get(titan_menu.hm_logs) then
        r,g,b = ui.get(titan_menu.ind_clr)
        --client.color_log(r, g, b, "[gamesense] \0")
        client.color_log(255, 255, 255, string)
    end
end

local function logging()
	if not ui.get(titan_menu.hm_logs) then return end
    local screen = {client.screen_size()}
    for i = 1, #logs do
        if not logs[i] then return end
        if not logs[i].init then
            logs[i].y = dynamic.new(2, 1, 1, -30)
            logs[i].time = globals.tickcount() + 256
            logs[i].init = true
        end
        r,g,b,a = ui.get(titan_menu.ind_clr)
        local string_size = renderer.measure_text("c", logs[i].text)
		renderer.rectangle(screen[1]/2-string_size/2-25, screen[2]-logs[i].y:get() - 20, string_size+10, 16, r, g, b, 55, "", 4)
        renderer.text(screen[1]/2-20, screen[2] - logs[i].y:get() + 8 - 20, 255, 255, 255, 255, "c", 0, logs[i].text)

        if tonumber(logs[i].time) < globals.tickcount() then
            if logs[i].y:get() < -10 then
                table.remove(logs, i)
            else
                logs[i].y:update(globals.frametime(), -50, nil)
            end
        else
            logs[i].y:update(globals.frametime(), 20+(i*28), nil)
        end
    end
end

local function get_enemy_name(name)
	if not ui.get(titan_menu.enabled) then return end 
	if not entity.is_alive(entity.get_local_player()) then return end 
	if entity.get_local_player() == nil then return end 
	local enemies = entity.get_players(true)
	local current_threat = client.current_threat()
	local name = entity.get_player_name(current_threat)

	return name
end

function math.clamp(val, min, max)
    return math.min(max, math.max(min, val))
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function alt_ind()
	local dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2]) 
	local os = ui.get(ref.os[1]) and ui.get(ref.os[2]) 
	local fd = ui.get(ref.fakeduck)

	if dt and not os and not fd then 
		var.active_exploits = "DT"
	elseif os and not dt and not fd then 
		var.active_exploits = "OS"
	elseif fd and not dt and not os then 
		var.active_exploits = "FD"
	elseif dt and os and not fd then 
		var.active_exploits = "DT  OS"
	elseif dt and fd and not os then 
		var.active_exploits = "DT  FD"
	elseif os and fd and not dt then 
		var.active_exploits = "OS  FD"
	elseif dt and os and fd then 
		var.active_exploits = "DT  OS  FD" 
	else 
		var.active_exploits = ""
	end
end

local function snaplines()
	if not ui.get(titan_menu.enabled) then return end 
	if not entity.is_alive(entity.get_local_player()) then return end
	if not ui.get(titan_menu.snap_lines) then return end 

	local localP = entity.get_local_player()
	local threat = client.current_threat()
	local color = {ui.get(titan_menu.ind_clr)}

	local render3dline = function(screen, dest, color)
        local start = {screen[1] / 2, screen[2]}
        local ends = {renderer.world_to_screen(dest.x, dest.y, dest.z)}

        renderer.line(start[1], start[2], ends[1], ends[2], color[1], color[2], color[3], color[4])
	end

	if localP ~= nil and threat ~= nil then 
		local origin_pos = {client.screen_size()}
		local end_pos = vector(entity.hitbox_position(threat, 2))

		render3dline(origin_pos, end_pos, color)
	end
end

local function on_paint()
	run_clantag()
	builder_vis()

	local local_player = entity.get_local_player()

	if not ui.get(titan_menu.enabled) then 
		return 
	end

	if not entity.is_alive(local_player) then
		return
	end

	local dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	local os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local fd = ui.get(ref.fakeduck) 
	local freestand = ui.get(ref.freestand[1]) and ui.get(ref.freestand[2])
	local ps = ui.get(ref.pingspike[1]) and ui.get(ref.pingspike[2])
	local baim = forcebaim
	local pulse = math.floor(math.sin(globals.realtime()) * (255/2-1) + 255/2) or 255 -- Pulse alpha calc
	local spacer = 28
	local sx, sy = client.screen_size()
	local cx, cy = sx / 2, sy / 2 - 2
	local r, g, b, a = ui.get(titan_menu.ind_clr)
	local r1, g1, b1, a1 = ui.get(titan_menu.ind_clr)
	local scoped = entity.get_prop(entity.get_local_player(), 'm_bIsScoped')
	local screen_width, screen_height = client.screen_size()
	local h, m, s = client.system_time()
	local meridian = nil
	local alt_padding
	var.angle = math.max(-60, math.min(60, round((entity.get_prop(local_player, "m_flPoseParameter", 11) or 0)*120-60+0.5, 1)))

	if ui.get(titan_menu.fskey) then --FS edgeyaw shidd
		ui.set(ref.freestand[1], "Default")
		ui.set(ref.freestand[2], "Always On")
	else 
		ui.set(ref.freestand[1], "-")
		ui.set(ref.freestand[2], "On Hotkey")
	end

	if ui.get(titan_menu.edge_yaw) then 
		ui.set(ref.edgeyaw, true)
	else 
		ui.set(ref.edgeyaw, false)
	end

	if scoped ~= 0 then
		alt_padding = 25
		if animated.scope < 20 then
			animated.scope = animated.scope + 1
		end
		if animated.indic < 20 then 
			animated.indic = animated.indic + 1 
		end
	else
		alt_padding = 0
		if animated.scope > 0 then
			animated.scope = animated.scope - 1
		end
		if animated.indic > 0 then 
			animated.indic = animated.indic - 1 
		end
	end

	if ui.get(titan_menu.ind_style) == "Titan" and ui.get(titan_menu.enabled) and contains(titan_menu.ind_set, "Indicators") then
		local cam = vector(client.camera_angles())

		local h = vector(entity.hitbox_position(local_player, "head_0"))
		local p = vector(entity.hitbox_position(local_player, "pelvis"))
	
		local yaw = normalize_yaw(calc_angle(p.x, p.y, h.x, h.y) - cam.y + 120)
		local bodyyaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
	
		local fakeangle = normalize_yaw(yaw + bodyyaw)
		
		renderer.rectangle(cx + 41, cy + 20, 2, 15, --right
		bodyyaw < -10 and r1 or 35,
		bodyyaw < -10 and g1 or 35,
		bodyyaw < -10 and b1 or 35,
		bodyyaw < -10 and a1 or 150)

		renderer.rectangle(cx - 42, cy + 20, 2, 15,		-- left	
		bodyyaw > 10 and r1 or 35,
		bodyyaw > 10 and g1 or 35,
		bodyyaw > 10 and b1 or 35,
		bodyyaw > 10 and a1 or 150)
	end

	if contains(titan_menu.ind_set, "Min Damage Indicator") and ui.get(titan_menu.ind_style) == "Titan" then
		renderer.text(cx + 15, cy - 50 + spacer, r, g, b, a, 'c-', 0, ui.get(ref.min_damage))
	elseif contains(titan_menu.ind_set, "Min Damage Indicator") and ui.get(titan_menu.ind_style) == "Modern" then
		renderer.text(cx + 15, cy - 50 + spacer, r, g, b, a, 'c-', 0, ui.get(ref.min_damage))
	elseif contains(titan_menu.ind_set, "Min Damage Indicator") and ui.get(titan_menu.ind_style) == "Alternative" then
		renderer.text(cx + 15, cy - 50 + spacer, r, g, b, a, 'c-', 0, ui.get(ref.min_damage))
	end

	if h <= 12 then 
		meridian = "AM"
	elseif h > 12 then 
		meridian = "PM"
	end

	if m < 10 then -- Adding zero if minutes is less than 10 due to aesthetic reasons.
		m = "0" .. m
	end

	local watermark_name = persona_api.GetName():sub(1, 25)

	local latency = math.floor(math.min(1000, client.latency() * 1000) + 0.5)

	if latency == 0 then 
		latency = "Local Server"
	else 
		latency = latency .. " " .. "ms"
	end

	local text = string.format("TITAN LUA  |  "..colours.titan.."%s"..colours.white.."  |  Build Version: "..colours.titan.."%s"..colours.white.."  |  %s:%s  %s  |  %s", username, build, h, m, meridian, latency)
	local margin, padding, flags = 18, 4, nil
	flags, text = "-", (text:upper():gsub(" ", "   "))
	local text_width, text_height = renderer.measure_text(flags, text)

	if ui.get(titan_menu.wm_enable) then 
		renderer.rectangle(screen_width-text_width-margin-padding, margin-padding, text_width+padding*2, 1, r, g, b, pulse) -- Top Bar
		renderer.rectangle(screen_width-text_width-margin-padding, margin-padding + 15, text_width+padding*2, 1, r, g, b, pulse) -- Bottom Bar
		renderer.blur(screen_width-text_width-margin-padding, margin-padding, text_width+padding*2, 15) -- Blur
		renderer.text(screen_width-text_width-margin, margin - 1, 255, 255, 255, 255, flags, 0, text ) -- Text
	end

	if ui.get(titan_menu.debug_panel) then -- Debug shid
		local os, dt, fd = ui.get(ref.os[1]) and ui.get(ref.os[2]), ui.get(ref.dt[1]) and ui.get(ref.dt[2]), ui.get(ref.fakeduck)
		local target_text = string.format(colours.white .. "TARGET :    " .. colours.red .. string.upper(get_enemy_name()))
		local rec_len = renderer.measure_text("-", target_text)
		local fake_yaw = ui.get(ref.fakeyawlimit)
		local fake_amt_r = string.format(colours.white .. "DESYNC :    " .. colours.titan .. math.floor(var.angle))
		local choked = printChoked(choking)
		local exploit_state = " "
		local autopadding = 0
		local x, y = var.debug_x, var.debug_y

		if os or dt or fd then 
			exploit_state = "TRUE"
		else
			exploit_state = "FALSE"
		end

		local p_choke = string.format(colours.white .. "EXPLOITING :" )
		
		--renderer.rectangle(cx / 4 - 250, cy + 180, 100, 50, r, g, b, a) -- dragging rectangle
		renderer.text(x, y + autopadding, 255, 255, 255, 255, "c-", 0, "~ DEBUG ~")
		autopadding = autopadding + 10
		renderer.text(x, y + autopadding, 255, 0, 0, 255, "c-", 0, string.upper(target_text)) 
		autopadding = autopadding + 10
		renderer.text(x, y + autopadding, 255, 0, 0, 255, "c-", 0,  fake_amt_r .. "°")
		autopadding = autopadding + 10

		if exploit_state == "TRUE" then 
			renderer.text(x, y + autopadding, 0, 255, 0, 255, "c-", 0, p_choke .. "   " .. "\a00FF28C8TRUE")
			autopadding = autopadding + 10
		elseif exploit_state == "FALSE" then 
			renderer.text(x, y + autopadding, 255, 0, 0, 255, "c-", 0, p_choke .."   " .. "\aFF0000FFFALSE")
			autopadding = autopadding + 10
		end

		if dragging(x, y, 100, 50) then 
			if client.key_state(0x01) then 
				local mousepos_x, mousepos_y = ui.mouse_position()
				var.debug_x = mousepos_x - 50
				var.debug_y = mousepos_y - 25
			end
		end
	end

	if contains(titan_menu.ind_set, "Indicators") and ui.get(titan_menu.ind_style) == "Titan" then 
		renderer.gradient(cx - 37, cy + 20, 75, 15 + sizeCount, r, g, b, 55, 255, 255, 255, 5, false)
		renderer.rectangle(cx - 37, cy + 20, 75, 1, r, g, b, a) -- top
		renderer.rectangle(cx - 37, cy + 20, 1, 15 + sizeCount, r, g, b, a) --l
		renderer.rectangle(cx + 37, cy + 20, 1, 15 + sizeCount, r, g, b, a) -- r
		renderer.text(cx, cy + 28, r, g, b, a, 'c-', 0, "T        I        T        A        N")
		for k, v in pairs(indicatorText) do
			spacer = spacer + 10
			if k == "DT" then
				renderer.text(cx, cy + spacer + 2, 255, 0, 0, 255, "c-", 0, v)
			elseif k == "DT-charged" then
				renderer.text(cx, cy + spacer + 2, r, g, b, 255, "c-", 0, v)
			else
				renderer.text(cx, cy + spacer + 2, r, g, b, a, "c-", 0, v)
			end
		end
	elseif contains(titan_menu.ind_set, "Indicators") and ui.get(titan_menu.ind_style) == "Modern" then  
		renderer.text(cx + animated.scope + 10, cy + 15, r, g, b, 255, 'c-', 0, "TITAN")
		renderer.text(cx + animated.scope + 22, cy + 10, 255, 255, 255, pulse, '-', 0, string.upper(build))
		renderer.text(cx + animated.scope, cy + 20, 255, 255, 255, 255, 'l-', 0, var.playerstate)

		local threat = client.current_threat()
		bodyyaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
		if entity.is_dormant(threat) or threat == nil then 
			renderer.text(cx + animated.scope, cy + 30, 255, 255, 255, 255, "l-", 0, "FAKE:  DORMANT")
		elseif bodyyaw >= 0 then 
			renderer.text(cx + animated.scope, cy + 30, 255, 255, 255, 255, "l-", 0, "FAKE:  R")
		elseif bodyyaw <= 0 then 
			renderer.text(cx + animated.scope, cy + 30, 255, 255, 255, 255, "l-", 0, "FAKE:  L")
		end

		if contains(titan_menu.aa_options, "Manual Sides") then 
			if ui.get(titan_menu.manual_left) then 
				renderer.text(cx + animated.scope, cy + 50 , 255, 255, 255, 255, "l-", 0, "MANUAL:  LEFT")
			elseif ui.get(titan_menu.manual_right) then 
				renderer.text(cx + animated.scope, cy + 50 , 255, 255, 255, 255, "l-", 0, "MANUAL:  RIGHT")
			end
		end

		if ui.get(ref.safepoint) then 
			renderer.text(cx + 12 + animated.scope, cy + 40, 255, 255, 255, 255, "l-", 0, "SP")
		else 
			renderer.text(cx + 12 + animated.scope, cy + 40, 255, 255, 255, 125, "l-", 0, "SP")
		end
		if freestand then 
			renderer.text(cx + 24 + animated.scope, cy + 40, 255, 255, 255, 255, "l-", 0, "FS")
		else 
			renderer.text(cx + 24 + animated.scope, cy + 40, 255, 255, 255, 125, "l-", 0, "FS")
		end
		if os then 
			renderer.text(cx + 36 + animated.scope, cy + 40, 255, 255, 255, 255, "l-", 0, "OS")
		else 
			renderer.text(cx + 36 + animated.scope, cy + 40, 255, 255, 255, 125, "l-", 0, "OS")
		end

		if ui.get(ref.quickpeek[1]) and ui.get(ref.quickpeek[2]) then 
			renderer.text(cx + 48 + animated.scope, cy + 40, 255, 255, 255, 255, "l-", 0, "QP")
		else 
			renderer.text(cx + 48 + animated.scope, cy + 40, 255, 255, 255, 125, "l-", 0, "QP")
		end

		if ui.get(titan_menu.telepeek) and contains(titan_menu.misc_enhancements, "Teleport On Peek") and dt_charge_state() then 
			renderer.text(cx + animated.scope, cy + 50, 162, 235, 5, 255, "l-", 0, "TELEPORT")
		elseif ui.get(titan_menu.telepeek) and contains(titan_menu.misc_enhancements, "Teleport On Peek") and not dt_charge_state() then 
			renderer.text(cx + animated.scope, cy + 50, 222, 0, 0, 255, "l-", 0, "TELEPORT")
		end

		if ui.get(ref.dt[2]) then 
			if dt_charge_state() then 
				renderer.text(cx + animated.scope, cy + 40, 162, 235, 5, 255, "l-", 0, "DT") 
			else 
				renderer.text(cx + animated.scope, cy + 40, 222, 0, 0, 255, "l-", 0, "DT") 
			end
		else 
			renderer.text(cx + animated.scope, cy + 40, 255, 255, 255, 125, "l-", 0, "DT")
		end
	elseif contains(titan_menu.ind_set, "Indicators") and ui.get(titan_menu.ind_style) == "Alternative" then

		local a_indicator = string.format(colours.white .. "ACTIVE EXPLOITS :"  .. colours.titan .. var.active_exploits)
		if ui.get(ref.dpi) == "100%" then
			renderer.text(cx + animated.scope + animated.indic, cy + 20, r, g, b, 255, 'cd-', 0, "TITAN")

			renderer.gradient(cx + animated.scope + animated.indic, cy + 28, -var.angle / 2, 2, r, g, b, a, 0, 0, 0, 0, true)
			renderer.gradient(cx + animated.scope + animated.indic, cy + 28, var.angle / 2, 2, r, g, b, a, 0, 0, 0, 0, true)
			renderer.text(cx + animated.scope + animated.indic, cy + 35, 255, 255, 255, 255, "cd-", 0, round(var.angle, 0) .. "°")

			if var.active_exploits ~= "" then
				renderer.text(cx + animated.scope + animated.indic, cy + 45, 255, 255, 255, 255, "cd-", 0, a_indicator) 
			end

			if ui.get(titan_menu.telepeek) and contains(titan_menu.misc_enhancements, "Teleport On Peek") and dt_charge_state() then 
				renderer.text(cx + animated.scope + animated.indic, cy + 55, 162, 235, 5, 255, "cd-", 0, "TELEPORT")
			elseif ui.get(titan_menu.telepeek) and contains(titan_menu.misc_enhancements, "Teleport On Peek") and not dt_charge_state() then 
				renderer.text(cx + animated.scope + animated.indic, cy + 55, 222, 0, 0, 255, "cd-", 0, "TELEPORT")
			end
		elseif ui.get(ref.dpi) == "125%" then
			renderer.text(cx + animated.scope + animated.indic, cy + 20, r, g, b, 255, 'cd-', 0, "TITAN")

			renderer.gradient(cx + animated.scope + animated.indic, cy + 28, -var.angle / 2, 2, r, g, b, a, 0, 0, 0, 0, true)
			renderer.gradient(cx + animated.scope + animated.indic, cy + 28, var.angle / 2, 2, r, g, b, a, 0, 0, 0, 0, true)
			renderer.text(cx + animated.scope + animated.indic, cy + 36, 255, 255, 255, 255, "cd-", 0, round(var.angle, 0) .. "°")

			if var.active_exploits ~= "" then
				renderer.text(cx + animated.scope + animated.indic, cy + 47, 255, 255, 255, 255, "cd-", 0, a_indicator)
			end 

			if ui.get(titan_menu.telepeek) and contains(titan_menu.misc_enhancements, "Teleport On Peek") and dt_charge_state() then 
				renderer.text(cx + animated.scope + animated.indic, cy + 58, 162, 235, 5, 255, "cd-", 0, "TELEPORT")
			elseif ui.get(titan_menu.telepeek) and contains(titan_menu.misc_enhancements, "Teleport On Peek") and not dt_charge_state() then 
				renderer.text(cx + animated.scope + animated.indic, cy + 58, 222, 0, 0, 255, "cd-", 0, "TELEPORT")
			end
		elseif ui.get(ref.dpi) == "150%" then 
			renderer.text(cx + animated.scope + animated.indic, cy + 20, r, g, b, 255, 'bcd-', 0, "TITAN")

			renderer.gradient(cx + animated.scope + animated.indic, cy + 32, -var.angle, 3, r, g, b, a, 0, 0, 0, 0, true)
			renderer.gradient(cx + animated.scope + animated.indic, cy + 32, var.angle, 3, r, g, b, a, 0, 0, 0, 0, true)
			renderer.text(cx + animated.scope + animated.indic, cy + 42, 255, 255, 255, 255, "bcd-", 0, round(var.angle, 0) .. "°")

			if var.active_exploits ~= "" then
				renderer.text(cx + animated.scope + animated.indic, cy + 53, 255, 255, 255, 255, "cd-", 0, a_indicator)
			end 

			if ui.get(titan_menu.telepeek) and contains(titan_menu.misc_enhancements, "Teleport On Peek") and dt_charge_state() then 
				renderer.text(cx + animated.scope, cy + 64, 162, 235, 5, 255, "cd-", 0, "TELEPORT")
			elseif ui.get(titan_menu.telepeek) and contains(titan_menu.misc_enhancements, "Teleport On Peek") and not dt_charge_state() then 
				renderer.text(cx + animated.scope, cy + 64, 222, 0, 0, 255, "cd-", 0, "TELEPORT")
			end
		elseif ui.get(ref.dpi) == "175%" then 
			renderer.text(cx + animated.scope + alt_padding, cy + 20, r, g, b, 255, 'bcd-', 0, "TITAN")

			renderer.gradient(cx + animated.scope + alt_padding, cy + 32, -var.angle, 3, r, g, b, a, 0, 0, 0, 0, true)
			renderer.gradient(cx + animated.scope + alt_padding, cy + 32, var.angle, 3, r, g, b, a, 0, 0, 0, 0, true)
			renderer.text(cx + animated.scope + alt_padding, cy + 42, 255, 255, 255, 255, "bcd-", 0, round(var.angle, 0) .. "°")

			if var.active_exploits ~= "" then
				renderer.text(cx + animated.scope, cy + 54, 255, 255, 255, 255, "cd-", 0, a_indicator)
			end 

			if ui.get(titan_menu.telepeek) and contains(titan_menu.misc_enhancements, "Teleport On Peek") and dt_charge_state() then 
				renderer.text(cx + animated.scope, cy + 66, 162, 235, 5, 255, "cd-", 0, "TELEPORT")
			elseif ui.get(titan_menu.telepeek) and contains(titan_menu.misc_enhancements, "Teleport On Peek") and not dt_charge_state() then 
				renderer.text(cx + animated.scope, cy + 66, 222, 0, 0, 255, "cd-", 0, "TELEPORT")
			end
		elseif ui.get(ref.dpi) == "200%" then 
			renderer.text(cx + animated.scope + alt_padding, cy + 20, r, g, b, 255, 'bcd-', 0, "TITAN")

			renderer.gradient(cx + animated.scope + alt_padding, cy + 32, -var.angle, 3, r, g, b, a, 0, 0, 0, 0, true)
			renderer.gradient(cx + animated.scope + alt_padding, cy + 32, var.angle, 3, r, g, b, a, 0, 0, 0, 0, true)
			renderer.text(cx + animated.scope + alt_padding, cy + 44, 255, 255, 255, 255, "bcd-", 0, round(var.angle, 0) .. "°")

			if var.active_exploits ~= "" then
				renderer.text(cx + animated.scope + animated.indic, cy + 58, 255, 255, 255, 255, "cd-", 0, a_indicator)
			end 
			
			if ui.get(titan_menu.telepeek) and contains(titan_menu.misc_enhancements, "Teleport On Peek") and dt_charge_state() then 
				renderer.text(cx + animated.scope, cy + 70, 162, 235, 5, 255, "cd-", 0, "TELEPORT")
			elseif ui.get(titan_menu.telepeek) and contains(titan_menu.misc_enhancements, "Teleport On Peek") and not dt_charge_state() then 
				renderer.text(cx + animated.scope, cy + 70, 222, 0, 0, 255, "cd-", 0, "TELEPORT")
			end
		end
	end
end

http.get(picurl, function(s, r)
	if s and r.status == 200 then
		image = images.load(r.body)
	else 
		error("Failed to load: " .. response.status_message)
	end
end)

http.get(newlogo, function(s, r)
	if s and r.status == 200 then
		logo = images.load(r.body)
	else 
		error("Failed to load: " .. response.status_message)
	end
end)

client.set_event_callback("paint", function()
	if not ui.get(titan_menu.enabled) then return end
	local sx, sy = client.screen_size()
	local cx, cy = sx / 2, sy / 2 - 2
	local r, g, b, a = ui.get(titan_menu.ind_clr)
	local r1, g1, b1, a1 = ui.get(titan_menu.ind_clr)
	local avatar = images.get_steam_avatar(steamid3, large)


	--renderer.gradient(cx - 75, cy + 488, 156, 56, r1, g1, b1, 55, r, g, b, 55, false) -- Mandatory Watermark
	--avatar:draw(cx - 75, cy + 490, 50, 50, 255,255,255,255, true)
	renderer.text(cx - 25, cy + 492, 255, 255, 255, 255, 'l-', 0, "\a4BF7FFFFTITAN")
	renderer.text(cx - 25, cy + 502, 255, 255, 255, 255, 'l-', 0, "USERNAME: " .. " " .. string.upper("\a4BF7FFFF"..username))
	renderer.text(cx - 25, cy + 512, 255, 255, 255, 255, 'l-', 0, "BUILD  VERSION: " .. " " .. string.upper("\a4BF7FFFF"..build))
	renderer.text(cx - 25, cy + 522, 255, 255, 255, 255, 'l-', 0, "LAST  UPDATE: " .. " " .. string.upper("\a4BF7FFFF25/11/2022"))
	if image ~= nil then
        image:draw(cx - 75, cy + 490, 50, 50)
    end
end)

set_steezy_config = ui.new_button("AA", "Anti-Aimbot Angles", "Load Steezy's Config", function()
	if globals.mapname() == nil then 
		print("[Titan] Failed to load config while not connected to a server.")
		return 
	end

	local steezyfig = json.parse(base64.decode("eyJBaXIiOnsiYl9ib2R5eWF3IjoiSml0dGVyIiwiYl9lbmFibGUiOnRydWUsImJfeWF3YWRkbCI6LTM0LCJiX3lhd2Jhc2UiOiJBdCB0YXJnZXRzIiwiYl95YXdqaXR0ZXJhZGQiOjQ1LCJiX3lhd2ppdHRlciI6IkNlbnRlciIsImJfeWF3IjoiMTgwIiwiYl9ib2R5eWF3YWRkIjowLCJiX2Zha2VyaWdodCI6NjAsImJfcGl0Y2giOiJEb3duIiwiYl9mYWtlbGVmdCI6NjAsImJfZmFrZXlhd21vZGUiOiJTdGF0aWMiLCJiX3JvbGwiOjAsImJfeWF3YWRkciI6MzQsImJfZmFrZXlhd2xpbWl0Ijo2MH0sIkNyb3VjaGluZyI6eyJiX2JvZHl5YXciOiJPcHBvc2l0ZSIsImJfZW5hYmxlIjp0cnVlLCJiX3lhd2FkZGwiOi04LCJiX3lhd2Jhc2UiOiJBdCB0YXJnZXRzIiwiYl95YXdqaXR0ZXJhZGQiOjI3LCJiX3lhd2ppdHRlciI6IkNlbnRlciIsImJfeWF3IjoiMTgwIiwiYl9ib2R5eWF3YWRkIjowLCJiX2Zha2VyaWdodCI6NjAsImJfcGl0Y2giOiJEb3duIiwiYl9mYWtlbGVmdCI6NjAsImJfZmFrZXlhd21vZGUiOiJTdGF0aWMiLCJiX3JvbGwiOjAsImJfeWF3YWRkciI6OCwiYl9mYWtleWF3bGltaXQiOjU5fSwiU2xvdyI6eyJiX2JvZHl5YXciOiJKaXR0ZXIiLCJiX2VuYWJsZSI6dHJ1ZSwiYl95YXdhZGRsIjotMzcsImJfeWF3YmFzZSI6IkF0IHRhcmdldHMiLCJiX3lhd2ppdHRlcmFkZCI6MjgsImJfeWF3aml0dGVyIjoiQ2VudGVyIiwiYl95YXciOiIxODAiLCJiX2JvZHl5YXdhZGQiOi0xMCwiYl9mYWtlcmlnaHQiOjYwLCJiX3BpdGNoIjoiRG93biIsImJfZmFrZWxlZnQiOjYwLCJiX2Zha2V5YXdtb2RlIjoiU3RhdGljIiwiYl9yb2xsIjowLCJiX3lhd2FkZHIiOjM2LCJiX2Zha2V5YXdsaW1pdCI6NjB9LCJBaXItRHVjayI6eyJiX2JvZHl5YXciOiJKaXR0ZXIiLCJiX2VuYWJsZSI6dHJ1ZSwiYl95YXdhZGRsIjotMzQsImJfeWF3YmFzZSI6IkF0IHRhcmdldHMiLCJiX3lhd2ppdHRlcmFkZCI6NDMsImJfeWF3aml0dGVyIjoiQ2VudGVyIiwiYl95YXciOiIxODAiLCJiX2JvZHl5YXdhZGQiOjAsImJfZmFrZXJpZ2h0Ijo2MCwiYl9waXRjaCI6IkRvd24iLCJiX2Zha2VsZWZ0Ijo2MCwiYl9mYWtleWF3bW9kZSI6IlN0YXRpYyIsImJfcm9sbCI6MCwiYl95YXdhZGRyIjozNCwiYl9mYWtleWF3bGltaXQiOjYwfSwiU3RhbmRpbmciOnsiYl9ib2R5eWF3IjoiSml0dGVyIiwiYl9lbmFibGUiOnRydWUsImJfeWF3YWRkbCI6LTI0LCJiX3lhd2Jhc2UiOiJBdCB0YXJnZXRzIiwiYl95YXdqaXR0ZXJhZGQiOjEyLCJiX3lhd2ppdHRlciI6IkNlbnRlciIsImJfeWF3IjoiMTgwIiwiYl9ib2R5eWF3YWRkIjotMTksImJfZmFrZXJpZ2h0Ijo2MCwiYl9waXRjaCI6IkRvd24iLCJiX2Zha2VsZWZ0Ijo2MCwiYl9mYWtleWF3bW9kZSI6IlN0YXRpYyIsImJfcm9sbCI6MCwiYl95YXdhZGRyIjoyNCwiYl9mYWtleWF3bGltaXQiOjYwfSwiTW92aW5nIjp7ImJfYm9keXlhdyI6IkppdHRlciIsImJfZW5hYmxlIjp0cnVlLCJiX3lhd2FkZGwiOi0zNywiYl95YXdiYXNlIjoiQXQgdGFyZ2V0cyIsImJfeWF3aml0dGVyYWRkIjozMywiYl95YXdqaXR0ZXIiOiJDZW50ZXIiLCJiX3lhdyI6IjE4MCIsImJfYm9keXlhd2FkZCI6MCwiYl9mYWtlcmlnaHQiOjYwLCJiX3BpdGNoIjoiRG93biIsImJfZmFrZWxlZnQiOjYwLCJiX2Zha2V5YXdtb2RlIjoiU3RhdGljIiwiYl9yb2xsIjowLCJiX3lhd2FkZHIiOjM2LCJiX2Zha2V5YXdsaW1pdCI6NjB9fQ=="))
	for key, value in pairs(var.player_states) do 
		for k, v in pairs(builder_menu[key]) do 
			local current = steezyfig[value][k]
			if (current ~= nil) then 
				ui.set(v, current)
			end
		end
	end

	ui.set(titan_menu.aa_mode_select, "Builder")
	ui.set(titan_menu.aa_options, "Legit AA On E")
	ui.set(titan_menu.ind_set, {"Indicators","Min Damage Indicator"})
	ui.set(titan_menu.wm_enable, true)
	ui.set(titan_menu.ind_style, "Modern")
	ui.set(titan_menu.misc_enhancements, {"Teleport On Peek", "Avoid Backstab"})
	ui.set(titan_menu.autobuy_check, true)
	ui.set(titan_menu.autobuy, "Scout")
	ui.set(titan_menu.autobuy_second, "FiveSeven/Tec9")
	ui.set(titan_menu.autobuy_grenades, {"HE Grenade", "Molotov/Incendiary", "Smoke"})
	ui.set(titan_menu.autobuy_utility, {"Armor", "Helmet", "Zeus", "Defuser"})
	ui.set(titan_menu.clantag, true)

	local fig = panorama.loadstring('$.AsyncWebRequest("https://github.com/buffles1/steezyconfig/blob/b6e0d85911673348ceb25ae60263be678d28bfb7/steezyfig?raw=true",{type:"GET",complete:function(e){body=e.responseText}}); return body;')()

	config.import(fig)

	print("[Titan] Loaded Steezy's Config!")
end)

local function menu_vis()
	--@heartbeat
    if not ui.get(titan_menu.enabled) then 
		SetTableVisibility({ref.pitch, ref.yawbase, ref.yaw[1], ref.yaw[2], ref.yawjitter[1], ref.yawjitter[2], ref.bodyyaw[1], ref.bodyyaw[2], ref.fakeyawlimit, ref.fsbodyyaw, ref.edgeyaw, ref.freestand[1], ref.freestand[2], ref.roll_angles}, true)
		SetTableVisibility({titan_menu.roll_force_amt, titan_menu.force_roll, titan_menu.aa_options, titan_menu.ind_style, titan_menu.autobuy_second, titan_menu.autobuy_utility, titan_menu.autobuy_check, titan_menu.roll_standing, titan_menu.roll_slowmo, titan_menu.roll_crouching,  titan_menu.roll_states, titan_menu.ind_clr, titan_menu.hotkey_label, titan_menu.autobuy, titan_menu.aa_label, titan_menu.aa_mode_select, titan_menu.ind_set, titan_menu.fskey, titan_menu.edge_yaw}, false)
		SetTableVisibility({titan_menu.wm_enable, titan_menu.hm_logs, titan_menu.snap_lines, titan_menu.debug_panel, set_steezy_config, titan_menu.config_label, titan_menu.export_config, titan_menu.import_config, titan_menu.manual_left, titan_menu.manual_right, titan_menu.autobuy_grenades, titan_menu.clantag, titan_menu.build_label, titan_menu.vis_select, titan_menu.roll_check, titan_menu.avoid_label, titan_menu.ind_set, titan_menu.tele_label, titan_menu.avoiddist, titan_menu.telepeek, titan_menu.pred_ticks, titan_menu.pred_dist, titan_menu.aa_preset_select, titan_menu.misc_enhancements, titan_menu.build_spacer, titan_menu.build_options, titan_menu.fskey, titan_menu.edge_yaw}, false)
	else 
		SetTableVisibility({ref.pitch, ref.yawbase, ref.yaw[1], ref.yaw[2], ref.yawjitter[1], ref.yawjitter[2], ref.bodyyaw[1], ref.bodyyaw[2], ref.fakeyawlimit, ref.fsbodyyaw, ref.edgeyaw, ref.freestand[1], ref.freestand[2], ref.roll_angles}, false)
        SetTableVisibility({titan_menu.vis_select}, titan_menu.enabled)
		SetTableVisibility({titan_menu.config_label}, ui.get(titan_menu.enabled) and ui.get(titan_menu.vis_select) == "Miscellaneous")
		SetTableVisibility({titan_menu.aa_label, titan_menu.aa_mode_select}, ui.get(titan_menu.vis_select) == "Anti-Aim")
		SetTableVisibility({titan_menu.misc_enhancements, titan_menu.autobuy_check, titan_menu.autobuy, titan_menu.clantag}, ui.get(titan_menu.vis_select) == "Miscellaneous")
		SetTableVisibility({titan_menu.aa_preset_select, titan_menu.roll_check}, ui.get(titan_menu.vis_select) ==  "Anti-Aim" and ui.get(titan_menu.aa_mode_select) == "Presets")
		SetTableVisibility({titan_menu.roll_states, titan_menu.force_roll, titan_menu.roll_force_amt}, ui.get(titan_menu.vis_select)  == "Anti-Aim" and ui.get(titan_menu.roll_check) and ui.get(titan_menu.aa_mode_select) == "Presets")
		SetTableVisibility({titan_menu.roll_standing}, ui.get(titan_menu.vis_select)  == "Anti-Aim" and ui.get(titan_menu.roll_states) == "Standing" and ui.get(titan_menu.roll_check) and ui.get(titan_menu.aa_mode_select) == "Presets")
		SetTableVisibility({titan_menu.roll_slowmo}, ui.get(titan_menu.vis_select)  == "Anti-Aim" and ui.get(titan_menu.roll_states) == "Slow Motion" and ui.get(titan_menu.roll_check) and ui.get(titan_menu.aa_mode_select) == "Presets")
		SetTableVisibility({titan_menu.roll_crouching}, ui.get(titan_menu.vis_select)  == "Anti-Aim" and ui.get(titan_menu.roll_states) == "Crouching" and ui.get(titan_menu.roll_check) and ui.get(titan_menu.aa_mode_select) == "Presets")
		SetTableVisibility({titan_menu.autobuy, titan_menu.autobuy_second, titan_menu.autobuy_grenades, titan_menu.autobuy_utility}, ui.get(titan_menu.vis_select) == "Miscellaneous" and ui.get(titan_menu.autobuy_check))
		SetTableVisibility({titan_menu.hotkey_label, titan_menu.telepeek, titan_menu.force_roll, titan_menu.fskey, titan_menu.edge_yaw}, ui.get(titan_menu.vis_select) == "Hotkeys")
		SetTableVisibility({titan_menu.ind_style}, ui.get(titan_menu.vis_select) == "Visuals" and contains(titan_menu.ind_set, "Indicators"))
		SetTableVisibility({titan_menu.ind_set, titan_menu.ind_clr, titan_menu.debug_panel, titan_menu.snap_lines, titan_menu.wm_enable, titan_menu.hm_logs}, ui.get(titan_menu.vis_select) == "Visuals")
		SetTableVisibility({titan_menu.tele_label, titan_menu.pred_ticks, titan_menu.pred_dist}, ui.get(titan_menu.vis_select) == "Miscellaneous" and contains(titan_menu.misc_enhancements, "Teleport On Peek"))
		SetTableVisibility({titan_menu.avoid_label, titan_menu.avoiddist}, ui.get(titan_menu.vis_select) == "Miscellaneous" and contains(titan_menu.misc_enhancements,  "Avoid Backstab"))
		SetTableVisibility({titan_menu.build_label, titan_menu.build_spacer, titan_menu.build_options}, ui.get(titan_menu.vis_select) == "Anti-Aim" and ui.get(titan_menu.aa_mode_select) == "Builder")
		SetTableVisibility({titan_menu.manual_left, titan_menu.manual_right}, contains(titan_menu.aa_options, "Manual Sides") and ui.get(titan_menu.vis_select) == "Hotkeys")
		SetTableVisibility({titan_menu.aa_options}, ui.get(titan_menu.vis_select) == "Anti-Aim")
		SetTableVisibility({set_steezy_config, titan_menu.export_config, titan_menu.import_config}, ui.get(titan_menu.vis_select) == "Miscellaneous" and ui.get(titan_menu.config_label))
	end
end

local function unload_menu()
	ui.set_visible(ref.pitch, true)
	ui.set_visible(ref.yawbase, true)
	ui.set_visible(ref.yaw[1], true)
	ui.set_visible(ref.yaw[2], true)
	ui.set_visible(ref.yawjitter[1], true)
	ui.set_visible(ref.yawjitter[2], true)
	ui.set_visible(ref.bodyyaw[1], true)
	ui.set_visible(ref.bodyyaw[2], true)
	ui.set_visible(ref.fakeyawlimit, true)
	ui.set_visible(ref.fsbodyyaw, true)
	ui.set_visible(ref.edgeyaw, true)
	ui.set_visible(ref.freestand[1], true)
	ui.set_visible(ref.freestand[2], true)
	ui.set_visible(ref.roll_angles, true)
end

local function handle_callbacks()
    client.set_event_callback('shutdown', function()
		unload_menu()
	end)

    client.set_event_callback('paint_ui', menu_vis)
	client.set_event_callback('paint', logging)
	client.set_event_callback('paint', snaplines)

	client.set_event_callback('round_prestart', on_round_prestart)

	client.set_event_callback('setup_command', run_aa)
	client.set_event_callback('setup_command', misc.anti_knife)
	client.set_event_callback('setup_command', legit_aa)

	client.set_event_callback('paint', process_indicator_table)
	client.set_event_callback('paint', alt_ind)
	client.set_event_callback('paint_ui', on_paint)

	client.set_event_callback('aim_fire', fired)
	client.set_event_callback('aim_hit', hit)
	client.set_event_callback("aim_miss", missed)

end
handle_callbacks()