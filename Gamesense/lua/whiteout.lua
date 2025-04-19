--[[
    created by the best
   
]]--

--[[
    To-Do :

]]--

--#region require's
local clipboard = require "gamesense/clipboard" or error('Missing Clipboard library (https://gamesense.pub/forums/viewtopic.php?id=28678)')
local anti_aim = require "gamesense/antiaim_funcs" or error('Missing Anti-aim function library (https://gamesense.pub/forums/viewtopic.php?id=29665)')
local chat = require 'gamesense/chat' or error('Missing Chat api library (https://gamesense.pub/forums/viewtopic.php?id=30625)')
local images = require "gamesense/images" or error('Missing Images Library (https://gamesense.pub/forums/viewtopic.php?id=22917)')
local base64 = require 'gamesense/base64' or error('Missing Base64 Encode/Decode Library (https://gamesense.pub/forums/viewtopic.php?id=22917)')
local js = panorama.open()
local vector = require("vector")
--#endregion

--#region references
local tab, container    = "AA", "Anti-aimbot angles"
local x, y, z           = client.screen_size()

local ui_new_checkbox, ui_new_slider,ui_new_combobox,ui_new_multiselect,ui_new_hotkey,ui_new_button,ui_new_color_picker,ui_reference,ui_set,ui_get,ui_set_callback,ui_set_visible,math_random,me,ui_new_label,color_log,ui_new_textbox,renderer_triangle,enemy,math_floor,math_ceil,entity_get_prop,entity_set_prop,entity_hitbox_position,client_eye_position,client_scale_damage,client_current_threat,entity_get_player_weapon,client_trace_bullet,globals_tickinterval,globals_curtime,userid_to_entindex,get_player_name,is_enemy = ui.new_checkbox,ui.new_slider,ui.new_combobox,ui.new_multiselect,ui.new_hotkey,ui.new_button,ui.new_color_picker,ui.reference,ui.set,ui.get,ui.set_callback,ui.set_visible,math.random,entity.get_local_player,ui.new_label,client.color_log,ui.new_textbox,renderer.triangle,entity.is_enemy(),math.floor,math.ceil,entity.get_prop,entity.set_prop,entity.hitbox_position,client.eye_position,client.scale_damage,client.current_threat,entity.get_player_weapon,client.trace_bullet,globals.tickinterval,globals.curtime,client.userid_to_entindex,entity.get_player_name,entity.is_enemy

local ab                = 0
local default           = {180, -180}
local aggressive        = {95, -95}

local fakeyaw           =  {32, 55}
local fakeyaw_SW        = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,26, 27, 28, 29, 30}
local crouch            = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100}

local shot_log, local_log, hit_log, miss_log, lasthit, storedshots, storedmisses = {}, {}, {}, {}, {}, {}, {}

local plocal = entity.get_local_player()

local shot_info_table   = {}
local go                = false
local alpha             = 0

local enemyclosesttocrosshair = nil
local lowestfov = math.huge
local lowestdmg = math.huge

local non_weapons = { 
    "CKnife", 
    "CSmokeGrenade", 
    "CFlashbang", 
    "CHEGrenade", 
    "CDecoyGrenade", 
    "CIncendiaryGrenade", 
    "CMolotovGrenade", 
    "CC4" 
}

local last_press_t, desyncside, to_return, targets = 0, LEFT, 2, nil

local ref = {
    aa = {
        enabled            = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
        pitch              = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
        yaw_base           = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
        yaw                = {ui_reference("AA", "Anti-aimbot angles", "Yaw")},
        yaw_jitter         = {ui_reference("AA", "Anti-aimbot angles", "Yaw Jitter")},
        body_yaw           = {ui_reference("AA", "Anti-aimbot angles", "Body yaw")},
        freestand_bodyyaw  = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        --fakeyaw            = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
        edgeyaw            = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
        freestanding       = {ui_reference("AA", "Anti-aimbot angles", "Freestanding")},
        roll               = ui_reference("AA", "Anti-aimbot angles", "Roll"),
        slowwalk           = {ui_reference("AA", "Other", "Slow motion")},
    },
    fakelag = {
        master             = {ui_reference("AA", "Fake lag", "Enabled")},
        amount             = ui_reference("AA", "Fake lag", "Amount"),
        variance           = ui_reference("AA", "Fake lag", "Variance"),
        limit              = ui_reference("AA", "Fake lag", "Limit")
    },
    lp = {
        fd                 = ui_reference("Rage", "Other", "Duck peek assist"),
        dt                 = {ui_reference("Rage", "aimbot", "Double tap")},
        sp                 = ui_reference("Rage", "Aimbot", "Force safe point"),
        fb                 = ui_reference("Rage", "aimbot", "Force body aim"),
        os                 = {ui_reference("AA", "Other", "On shot anti-aim")},
        --dtfl               = ui_reference("Rage", "Other", "Double tap fake lag limit"),
        lm                 = ui_reference("AA", "other", "leg movement"),
    },
    misc = {
        max_ticks          = ui_reference("misc", "Settings", "sv_maxusrcmdprocessticks2"),
    }
}
--#endregion

--#region new menu ui stuff
local whiteout = {
    master              = ui_new_checkbox(tab, container, '[Initiate] whiteout'),
    tabtype             = ui_new_combobox(tab, container, '\n', {'Rage', "Anti-aim",  "Visuals", "Miscellaneous", 'Config'}),

    aa = {
        jittercondition = ui_new_multiselect(tab, container, 'Jitter Conditions', {'Always', "Vulnerable", "Enemy Dormant", 'On Playerstate', 'On Exploit'}),
        playerstates    = ui_new_multiselect(tab, container, 'Playerstate Jitter', {'Standing', 'Ducking', 'Slowwalking', 'Moving', 'Jumping'}),
        rollstates      = ui_new_multiselect(tab, container, 'Roll Conditions', {'Standing', 'Ducking', 'Slowwalking', 'Moving', 'Jumping', 'Low Velocity'}),
        antibrute_type  = ui_new_combobox(tab, container, 'Anti brute type', {'Default', 'Aggressive'}),
        bullet_detection= ui_new_slider(tab, container, 'Bullet Detection', 0, 100, 55, true, "%", 1, {[55] = "Default"}),
        extra           = ui_new_multiselect(tab, container, 'Extra AA', {'Legit anti-aim', 'Leg Breaker', 'Roll on key', 'Custom anti-aim'}),
        legit           = ui_new_hotkey(tab, container, 'Legit anti-aim', true, 0x45),
        legs            = ui_new_slider(tab, container,  "Leg Breaker Value", 1, 10, 4),
    
        roll_cb         = ui_new_checkbox(tab, container, 'Roll on Key'),
        roll_ab         = ui_new_hotkey(tab, container, 'Roll', true),
        roll_dd         = ui_new_combobox(tab, container, '\n', {"Normal", "Side Roll"}),
    },

    fakelag = {
        dynamic         = ui_new_checkbox(tab, container, 'Dynamic Fake Lag'),
        dynamic_type    = ui_new_combobox(tab, container, '\nDynamic Fake Lag', {'Default', 'Advanced'}),
    },

    dir = {
        customdir = ui_new_checkbox(tab, container, "Custom Direction"),
        free = ui_new_hotkey(tab, container, "-> Freestanding"),
        edge = ui_new_hotkey(tab, container, "-> Edge yaw"),
        manualback = ui_new_hotkey(tab, container, "-> Manual Back"),
        manualleft = ui_new_hotkey(tab, container, "-> Manual Left"),
        manualright = ui_new_hotkey(tab, container, "-> Manual Right")
    },

    visual = {
        crosshair = {
            master = ui_new_checkbox(tab, container, '[whiteout] Indicators')
        },
        logs           = ui_new_multiselect(tab, container, 'Logs', {"On Screen", "Console", "Chat"}),
        indicatortype = ui_new_multiselect(tab, container, "Indicator Type(s)", {"Debug Panel", "Crosshair"}),
        debug = {
            debug_label = ui_new_label(tab, container, 'Debug Color'),
            debug_color = ui_new_color_picker(tab, container, 'Debug Color', 255, 255, 255, 255),
        },
        colorpicker = {
            desync_label = ui_new_label(tab, container, 'Desync Logs Color'),
            desynclog = ui_new_color_picker(tab, container, 'Desync Logs Color', 255, 255, 255, 255),
            label = ui_new_label(tab, container, ' '),

            name = ui_new_label(tab, container, 'Alpha Color'),
            name_color = ui_new_color_picker(tab, container, 'Alpha Color', 255, 255, 255, 255),

            playerstate = ui_new_label(tab, container, 'Player State'),
            playerstate_color = ui_new_color_picker(tab, container, 'Player State Color', 255, 255, 255, 255),

            exploit = ui_new_label(tab, container, 'Exploit'),
            exploit_color = ui_new_color_picker(tab, container, 'Exploit Color', 160, 202, 43, 255),

            arrow = ui_new_label(tab, container, 'Arrow Color'),
            arrow_color = ui_new_color_picker(tab, container, 'Arrow Color', 255, 255, 255, 255),

        },
    },

    misc = {
        killsay = ui_new_checkbox(tab, container, 'Killsay'),
        sunsetmode = ui_new_checkbox(tab, container, 'Sunset'),
        dt = {
            doubletapboostcheck = ui_new_checkbox(tab, container, "Doubletap Boost"),
            doubletapboostdrop = ui_new_combobox(tab,container,"\n",{"Default", "Safe", "Dangerous", "Adaptive", "Custom"}),
            doubletapboostcustom = ui_new_slider(tab,container,"Doubletap Boost Amount", 6, 18, 16, true, "*", 1, {[6] = "Slowest", [16] = "Default", [18] = "Fastest"}),
        },
    },
}

local custom = {
    player_states = ui_new_combobox(tab, container, 'States', {'Standing', 'Ducking', 'Moving', 'Slow motion', 'Jumping', 'On Use'}),
    thing = {
        standing = {
            pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch [Standing]", { "Off", "Default", "Up", "Down", "Minimal", "Random" }),
            yawbase = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base [Standing]", { "Local view", "At targets" }),
            yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw [Standing]", { "Off", "180", "Spin", "Static", "180 Z", "Crosshair" }),
            yawadd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw add [Standing]", -180, 180, 0),
            yawjitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter [Standing]", { "Off", "Offset", "Center", "Random" }),
            yawjitteradd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw jitter add [Standing]", -180, 180, 0),
            bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw  [Standing]", { "Off", "Opposite", "Static", "Jitter"}),
            fakeyawlimit = ui_new_slider("AA", "Anti-aimbot angles", "Fake yaw limit [Standing]", 0, 60, 60),
        },
        ducking = {
            pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch [Ducking]", { "Off", "Default", "Up", "Down", "Minimal", "Random" }),
            yawbase = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base [Ducking]", { "Local view", "At targets" }),
            yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw [Ducking]", { "Off", "180", "Spin", "Static", "180 Z", "Crosshair" }),
            yawadd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw add [Ducking]", -180, 180, 0),
            yawjitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter [Ducking]", { "Off", "Offset", "Center", "Random" }),
            yawjitteradd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw jitter add [Ducking]", -180, 180, 0),
            bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw  [Ducking]", { "Off", "Opposite", "Static", "Jitter"}),
            fakeyawlimit = ui_new_slider("AA", "Anti-aimbot angles", "Fake yaw limit [Ducking]", 0, 60, 60),
        },
        moving = {
            pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch [Moving]", { "Off", "Default", "Up", "Down", "Minimal", "Random" }),
            yawbase = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base [Moving]", { "Local view", "At targets" }),
            yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw [Moving]", { "Off", "180", "Spin", "Static", "180 Z", "Crosshair" }),
            yawadd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw add [Moving]", -180, 180, 0),
            yawjitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter [Moving]", { "Off", "Offset", "Center", "Random" }),
            yawjitteradd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw jitter add [Moving]", -180, 180, 0),
            bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw  [Moving]", { "Off", "Opposite", "Static", "Jitter"}),
            fakeyawlimit = ui_new_slider("AA", "Anti-aimbot angles", "Fake yaw limit [Moving]", 0, 60, 60),
        },
        slowmotion = {
            pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch [Slow motion]", { "Off", "Default", "Up", "Down", "Minimal", "Random" }),
            yawbase = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base [Slow motion]", { "Local view", "At targets" }),
            yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw [Slow motion]", { "Off", "180", "Spin", "Static", "180 Z", "Crosshair" }),
            yawadd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw add [Slow motion]", -180, 180, 0),
            yawjitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter [Slow motion]", { "Off", "Offset", "Center", "Random" }),
            yawjitteradd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw jitter add [Slow motion]", -180, 180, 0),
            bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw  [Slow motion]", { "Off", "Opposite", "Static", "Jitter"}),
            fakeyawlimit = ui_new_slider("AA", "Anti-aimbot angles", "Fake yaw limit [Slow motion]", 0, 60, 60),
        },
        jumping = {
            pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch [Jumping]", { "Off", "Default", "Up", "Down", "Minimal", "Random" }),
            yawbase = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base [Jumping]", { "Local view", "At targets" }),
            yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw [Jumping]", { "Off", "180", "Spin", "Static", "180 Z", "Crosshair" }),
            yawadd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw add [Jumping]", -180, 180, 0),
            yawjitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter [Jumping]", { "Off", "Offset", "Center", "Random" }),
            yawjitteradd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw jitter add [Jumping]", -180, 180, 0),
            bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw  [Jumping]", { "Off", "Opposite", "Static", "Jitter"}),
            fakeyawlimit = ui_new_slider("AA", "Anti-aimbot angles", "Fake yaw limit [Jumping]", 0, 60, 60),
        },
        on_e = {
            pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch [On Use]", { "Off", "Default", "Up", "Down", "Minimal", "Random" }),
            yawbase = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base [On Use]", { "Local view", "At targets" }),
            yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw [On Use]", { "Off", "180", "Spin", "Static", "180 Z", "Crosshair" }),
            yawadd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw add [On Use]", -180, 180, 0),
            yawjitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter [On Use]", { "Off", "Offset", "Center", "Random" }),
            yawjitteradd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw jitter add [On Use]", -180, 180, 0),
            bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw  [On Use]", { "Off", "Opposite", "Static", "Jitter"}),
            fakeyawlimit = ui_new_slider("AA", "Anti-aimbot angles", "Fake yaw limit [On Use]", 0, 60, 60),
        },
    },
}

local refs = {
    ang_on_screen = function(x, y)
        return (x == 0 and y == 0) and 0 or math.deg(math.atan2(y, x))
    end, 
    normalize_yaw = function(yaw)
        while yaw > 180 do yaw = yaw - 360 end
        while yaw < -180 do yaw = yaw + 360 end
        return yaw
    end,
}

local convars = {
    override = cvar.cl_csm_rot_override,
    x = cvar.cl_csm_rot_x, 
    y = cvar.cl_csm_rot_y, 
    z = cvar.cl_csm_rot_z
}
--#endregion

--#region pre-functions
client.set_event_callback("setup_command", function(e)
    if ui.is_menu_open() then
        e.in_attack = 0
    end
end)

local function distance3d(x1, y1, z1, x2, y2, z2)
	return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end

local function get_table_length(data)
    if type(data) ~= 'table' then
        return 0
    end
    local count = 0
    for _ in pairs(data) do
        count = count + 1
    end
    return count
end

local hitbox = {
    "head", 
    "chest", 
    "stomach", 
    "left arm", 
    "right arm", 
    "left leg", 
    "right leg", 
    "neck", 
    "?", 
    "gear"
}  

function round(num, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

local var = {
    best_enemy = nil,
    auto_rage = false,
    p_state = 0,
    last_nn = 0,
    active_i = 1,
    aa_dir   = 0,
    last_press_t = 0,
    classnames = {
        "CWorld", 
        "CCSPlayer", 
        "CFuncBrush"
    },
}

local function multi_exec(func, tab)
    for k, v in pairs(tab) do
        func(k, v)
    end
end

local function SetTableVisibility(table, state)
    for i = 1, #table do
        ui_set_visible(table[i], state)
    end
end

function Veclen(x, y, z)
    return math.sqrt(x * x + y * y + z * z)
end

local function velocity(ent)
    local vec = {entity.get_prop(ent, "m_vecVelocity")}
    return Veclen(vec[1], vec[2], vec[3])
end

local function str_to_sub(input, sep)
    local t = {}
    for str in string.gmatch(input, "([^" .. sep .. "]+)") do
        t[#t + 1] = string.gsub(str, "\n", "")
    end
    return t
end

local function to_boolean(str)
	if str == "true" or str == "false" then
		return (str == "true")
	else
		return str
	end
end

best_target = function()
    var.best_enemy = nil
    local enemies = entity.get_players(true)
    local best_fov = 180
    local eye_pos = vector(client.eye_position())
    local cam = vector(client.camera_angles())
    for i = 1, #enemies do
        local enemy_pos = vector(entity.hitbox_position(enemies[i], 2))
        local cur_fov =
            math.abs(
            refs.normalize_yaw(refs.ang_on_screen(eye_pos.x - enemy_pos.x, eye_pos.y - enemy_pos.y) - cam.y + 180)
        )
        if cur_fov < best_fov then
            best_fov = cur_fov
            var.best_enemy = enemies[i]
        end
    end
end

local iu = {
    x = database.read("ui_x") or 250, 
    y = database.read("ui_y") or 250, 
    w = 140, 
    h = 3, 
    dragging = false
}

client.set_event_callback("pre_config_save", function()
    database.write("ui_x", iu.x)
    database.write("ui_y", iu.y)
end)

local function cycle_table(table)
	if (table["cur"] == nil) or (table["reverse"] == nil) or (table["value"] == nil) then
		table["value"] = #table
		table["cur"] = 1
		table["reverse"] = false
	end
	if (not table["reverse"]) and (table["cur"]+1 > table["value"]) then
		table["reverse"] = true
	end
	if (table["reverse"]) and (table["cur"]-1 == 0) then
		table["reverse"] = false
	end
	table["cur"] = (table["reverse"] and table["cur"]-1 or table["cur"]+1)
	return table[table["cur"]]
end

local function intersect(x, y, w, h, debug)
    local cx, cy = ui.mouse_position()
    return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function contains(b, c)
    for d, e in pairs(b) do
        if e == c then
            return true
        end
    end
    return false
end

local function entity_has_c4(ent)
	local bomb = entity.get_all("CC4")[1]
	return bomb ~= nil and entity.get_prop(bomb, "m_hOwnerEntity") == ent
end

local function aa_on_use(cmd)

	if contains(ui_get(whiteout.aa.extra), 'Legit anti-aim') then 
		local plocal = entity.get_local_player()

        local weaponn = entity.get_player_weapon()
		
		local distance = 100
		local bomb = entity.get_all("CPlantedC4")[1]
		local bomb_x, bomb_y, bomb_z = entity.get_prop(bomb, "m_vecOrigin")

		if bomb_x ~= nil then
			local player_x, player_y, player_z = entity.get_prop(plocal, "m_vecOrigin")
			distance = distance3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
		end
		
		local team_num = entity.get_prop(plocal, "m_iTeamNum")
		local defusing = team_num == 3 and distance < 62

		local on_bombsite = entity.get_prop(plocal, "m_bInBombZone")

		local has_bomb = entity_has_c4(plocal)
		local trynna_plant = on_bombsite ~= 0 and team_num == 2 and has_bomb and not ui_get(whiteout.aa.legit)
		
		local px, py, pz = client.eye_position()
		local pitch, yaw = client.camera_angles()
	
		local sin_pitch = math.sin(math.rad(pitch))
		local cos_pitch = math.cos(math.rad(pitch))
		local sin_yaw = math.sin(math.rad(yaw))
		local cos_yaw = math.cos(math.rad(yaw))

		local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }

		local fraction, entindex = client.trace_line(plocal, px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))

		local using = true

		if entindex ~= nil then
			for i=0, #var.classnames do
				if entity.get_classname(entindex) == var.classnames[i] then
					using = false
				end
			end
		end

		if not using and not trynna_plant and not defusing then
            cmd.in_use = 0
		end
	end
end

local rounding = 4
local o = 20
local rad = rounding + 2
local n = 45

local RoundedRect = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)renderer.rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)renderer.rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)renderer.circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)renderer.circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)renderer.circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25) end
local OutlineGlow = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+2,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+w-3,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+radius+rad,y+2,w-rad*2-radius*2,1,r,g,b,a)renderer.rectangle(x+radius+rad,y+h-3,w-rad*2-radius*2,1,r,g,b,a)renderer.circle_outline(x+radius+rad,y+radius+rad,r,g,b,a,radius+rounding,180,0.25,1)renderer.circle_outline(x+w-radius-rad,y+radius+rad,r,g,b,a,radius+rounding,270,0.25,1)renderer.circle_outline(x+radius+rad,y+h-radius-rad,r,g,b,a,radius+rounding,90,0.25,1)renderer.circle_outline(x+w-radius-rad,y+h-radius-rad,r,g,b,a,radius+rounding,0,0.25,1) end
local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) local n=a/255*n;renderer.rectangle(x+radius,y,w-radius*2,1,r,g,b,n)renderer.circle_outline(x+radius,y+radius,r,g,b,n,radius,180,0.25,1)renderer.circle_outline(x+w-radius,y+radius,r,g,b,n,radius,270,0.25,1)renderer.rectangle(x,y+radius,1,h-radius*2,r,g,b,n)renderer.rectangle(x+w-1,y+radius,1,h-radius*2,r,g,b,n)renderer.circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,n) for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)end end
local container_glow = function(x, y, w, h, r, g, b, a, alpha,r1, g1, b1, fn) if alpha*255>0 then renderer.blur(x,y,w,h)end;RoundedRect(x,y,w,h,rounding,17,17,17,a)FadedRoundedGlow(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o,r1,g1,b1)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end
 
local function rotate_point(x, y, rot, size)
	return math.cos(math.rad(rot)) * size + x, math.sin(math.rad(rot)) * size + y
end

local function renderer_arrow(x, y, r, g, b, a, rotation, size)
	local x0, y0 = rotate_point(x, y, rotation, 45)
	local x1, y1 = rotate_point(x, y, rotation + (size / 3.5), 45 - (size / 4))
	local x2, y2 = rotate_point(x, y, rotation - (size / 3.5), 45 - (size / 4))
	renderer.triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
end

local states = {
    moving = function()
        return velocity(entity.get_local_player()) >= 1.2
    end, 
    air = function()
        return bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 0
    end, 
    crouch = function()
        return bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 4) == 4
    end, 
    standing = function()
        return velocity(entity.get_local_player()) <= 1.2
    end
}

local function get_damage(plocal, enemy, x, y,z)
    if entity.is_alive(entity.get_local_player()) then return end
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
	local ent, dmg = 0
	for i = 0, 6 do
		if dmg == 0 or dmg == nil then
			ent, dmg = client.trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
		end
	end
	return ent == nil and client.scale_damage(plocal, 1, dmg) or dmg
end

local function calc_angle(local_x, local_y, enemy_x, enemy_y)
	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math.atan( ydelta / xdelta )
	relativeyaw = refs.normalize_yaw( relativeyaw * 180 / math.pi )
	if xdelta >= 0 then
		relativeyaw = refs.normalize_yaw(relativeyaw + 180)
	end
	return relativeyaw
end

local function angle_vector(angle_x, angle_y)
	local sy = math.sin(math.rad(angle_y))
	local cy = math.cos(math.rad(angle_y))
	local sp = math.sin(math.rad(angle_x))
	local cp = math.cos(math.rad(angle_x))
	return cp * cy, cp * sy, -sp
end
--#endregion

--#region notify 
local notify = (function()
    local notify = {callback_registered = false, maximum_count = 7, data = {}, svg_texture = [[]]}
    local svg_size = { w = 10, h = 30}
    local svg = renderer.load_svg(notify.svg_texture, svg_size.w, svg_size.h)
    function notify:register_callback()
        if self.callback_registered then return end
        client.set_event_callback('paint_ui', function()
            local mx, my = client.screen_size()
            local screen = {client.screen_size()}
            local color = {27, 27, 27}
            local d = 5;
            local data = self.data;
            for f = #data, 1, -1 do
                data[f].time = data[f].time - globals.frametime()
                local alpha2, h = 255, 0;
                local _data = data[f]
                if _data.time < 0 then
                    table.remove(data, f)
                else
                    local time_diff = _data.def_time - _data.time;
                    local time_diff = time_diff > 1 and 1 or time_diff;
                    if _data.time < 0.5 or time_diff < 0.5 then
                        h = (time_diff < 1 and time_diff or _data.time) / 0.5;
                        alpha2 = h * 255;
                        if h < 0.2 then
                            d = d + 15 * (1.0 - h / 0.2)
                        end
                    end

                    local color = {ui_get(whiteout.visual.colorpicker.desynclog)}

                    local text_left = "[whiteout] "
                    
                    local text_data = {renderer.measure_text("c", _data.draw)}
                    local screen_data = {
                        screen[1] / 2 - text_data[1] / 2 - 7, screen[2] - screen[2] / 200 * 12.4 + d
                    }


                    renderer.circle(screen_data[1] + (text_data[1] + 30), screen_data[2] - 30, 15, 15, 15, 125, 10, 0, 0.5)
                    renderer.circle_outline(screen_data[1] + (text_data[1] + 30), screen_data[2] - 30, color[1], color[2], color[3], 255, 10, -87, 0.5, 2)      

                    renderer.circle(screen_data[1] - 30, screen_data[2] - 30,  15, 15, 15, 125, 10, 180, 0.5)
                    renderer.circle_outline(screen_data[1] - 30, screen_data[2] - 30, color[1], color[2], color[3], 255, 10, 87, 0.5, 2)

                    renderer.rectangle(screen_data[1] - 30, screen_data[2] - 40, text_data[1] + 60, 20, 15, 15, 15, 125)
                    renderer.rectangle(screen_data[1] - 30, screen_data[2] - 40, text_data[1] + 60, 2, color[1], color[2], color[3], 255)
                    renderer.rectangle(screen_data[1] - 30, screen_data[2] - 22, text_data[1] + 60, 2, color[1], color[2], color[3], 255)

                    renderer.text(screen_data[1] + text_data[1] - text_data[1], screen_data[2] - 31, color[1], color[2], color[3], alpha2, 'c', nil, text_left)
                    renderer.text(screen_data[1] + text_data[1] / 2 + renderer.measure_text("c",text_left) / 2, screen_data[2] - 31, 255, 255, 255, alpha2, 'c', nil, _data.draw)

                    renderer.texture(svg, screen_data[1] - svg_size.w/2 - 5, screen_data[2] - svg_size.h/2 + 335, svg_size.w, svg_size.h, 227, 66, 245, alpha2)
                    d = d - 30
                end
            end            
            self.callback_registered = true
        end)
    end
    function notify:paint(time, text)
        local timer = tonumber(time) + 1;
        for f = self.maximum_count, 2, -1 do
            self.data[f] = self.data[f - 1]
        end
        self.data[1] = {time = timer, def_time = timer, draw = text}
        self:register_callback()
    end
    return notify
end)()

notify:paint(15, "AA Tab")
notify:paint(13, "Initialized whiteout...")

local function reset_tables(keep_hit)
    for i = 1, 64 do
		storedshots[i] = 0
		storedmisses[i] = 0
        
        if keep_hit and hit_log[i][4][hit_log[i][5]] == 1 then
            lasthit[i] = hit_log[i][2][hit_log[i][5]]
        else
            lasthit[i] = 0
        end

		for j = 1, 4 do
			for k = 1, hit_log[i][5] do
				hit_log[i][j][k] = 0
			end
        end
		hit_log[i][5] = 0

		for j = 1, 2 do
			for k = 1, shot_log[i][3] do
				shot_log[i][j][k] = 0
			end
        end
		shot_log[i][3] = 0

		for k = 1, miss_log[i][2] do
			miss_log[i][1][k] = 0
        end
		miss_log[i][2] = 0
	end
end

local function setup_tables()
    -- 1- TIME 2- DESYNCSIDE 3- AMOUNT OF SHOTS
    for i = 1, 64 do
        shot_log[i] = {}
        for j = 1, 2 do
            shot_log[i][j] = {}
            for k = 1, 1000 do
                shot_log[i][j][k] = 0
            end
        end
        shot_log[i][3] = 0
    end
    
    for i = 1, 64 do
        local_log[i] = false
    end
    
    -- 1- TIME 2- DESYNCSIDE 3- AMOUNT OF HITS
    for i = 1, 64 do
        hit_log[i] = {}
        hit_log[i][1] = {}
        hit_log[i][2] = {}
        hit_log[i][3] = {}
        hit_log[i][4] = {}
        hit_log[i][5] = 0
        for k = 1, 1000 do
            hit_log[i][1][k] = 0
            hit_log[i][2][k] = 0
            hit_log[i][3][k] = 0
            hit_log[i][4][k] = 0
        end
    end
    
    -- 1- DESYNCSIDE 2- AMOUNT OF MISSES
    for i = 1, 64 do
        miss_log[i] = {}
        miss_log[i][1] = {}
        miss_log[i][2] = 0
        for k = 1, 1000 do
            miss_log[i][1][k] = 0
        end
    end
    
    for i = 1, 64 do
        storedshots[i] = 0
    end
    
    for i = 1, 64 do
        lasthit[i] = 0
    end
    
    for i = 1, 64 do
        storedmisses[i] = 0
    end
end

local function COMMAND_HANDLER(e, cmd)

    local me = entity.get_local_player()
    if not entity.is_alive(me) then return end

    if not ui_get(whiteout.master) then return end


    local enemies = entity.get_players(true)

    for i=1, #enemies do
        local idx = enemies[i]
        local shotamount = shot_log[idx][3]
        local hitsamount = hit_log[idx][5]

        if shotamount ~= storedshots[idx] then
            local missed = true
            
            if shot_log[idx][1][shotamount] == hit_log[idx][1][hitsamount] then
                if hit_log[idx][3][hitsamount] == me then
                    lasthit[idx] = hit_log[idx][2][hitsamount]
                end
                
                missed = false
            end
            
            if missed and shot_log[idx][2][shotamount] ~= 0 then
                lasthit[idx] = 0
                hit_log[idx][2][hitsamount] = 0
                miss_log[idx][2] = miss_log[idx][2] + 1
                miss_log[idx][1][miss_log[idx][2]] = shot_log[idx][2][shotamount]
            end
            storedshots[idx] = shotamount
        end
    end
end

setup_tables()
--#endregion

--#region customaa 
local function custom_aa()
    if not contains(ui_get(whiteout.aa.extra), 'Custom anti-aim') then return end

    if states.crouch() and (not states.air()) then --Crouch
        --ui_set(ref.aa.fakeyaw, ui_get(custom.thing.ducking.fakeyawlimit))                
        ui_set(ref.aa.freestand_bodyyaw, false)               
        ui_set(ref.aa.edgeyaw, false)               
        ui_set(ref.aa.pitch, ui_get(custom.thing.ducking.pitch))                      
        ui_set(ref.aa.yaw_base, ui_get(custom.thing.ducking.yawbase))  
        ui_set(ref.aa.yaw[1], ui_get(custom.thing.ducking.yaw))                
        ui_set(ref.aa.yaw[2], ui_get(custom.thing.ducking.yawadd))                
        ui_set(ref.aa.yaw_jitter[1], ui_get(custom.thing.ducking.yawjitter))               
        ui_set(ref.aa.yaw_jitter[2], ui_get(custom.thing.ducking.yawjitteradd))
        ui_set(ref.aa.body_yaw[1], ui_get(custom.thing.ducking.bodyyaw))
    elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) then -- Slow motion
        --ui_set(ref.aa.fakeyaw, ui_get(custom.thing.slowmotion.fakeyawlimit))                
        ui_set(ref.aa.freestand_bodyyaw, false)               
        ui_set(ref.aa.edgeyaw, false)               
        ui_set(ref.aa.pitch, ui_get(custom.thing.slowmotion.pitch))                      
        ui_set(ref.aa.yaw_base, ui_get(custom.thing.slowmotion.yawbase))  
        ui_set(ref.aa.yaw[1], ui_get(custom.thing.slowmotion.yaw))                
        ui_set(ref.aa.yaw[2], ui_get(custom.thing.slowmotion.yawadd))                
        ui_set(ref.aa.yaw_jitter[1], ui_get(custom.thing.slowmotion.yawjitter))               
        ui_set(ref.aa.yaw_jitter[2], ui_get(custom.thing.slowmotion.yawjitteradd))
        ui_set(ref.aa.body_yaw[1], ui_get(custom.thing.slowmotion.bodyyaw))
    elseif states.air() then
        --ui_set(ref.aa.fakeyaw, ui_get(custom.thing.jumping.fakeyawlimit))                
        ui_set(ref.aa.freestand_bodyyaw, false)               
        ui_set(ref.aa.edgeyaw, false)               
        ui_set(ref.aa.pitch, ui_get(custom.thing.jumping.pitch))                      
        ui_set(ref.aa.yaw_base, ui_get(custom.thing.jumping.yawbase))  
        ui_set(ref.aa.yaw[1], ui_get(custom.thing.jumping.yaw))                
        ui_set(ref.aa.yaw[2], ui_get(custom.thing.jumping.yawadd))                
        ui_set(ref.aa.yaw_jitter[1], ui_get(custom.thing.jumping.yawjitter))               
        ui_set(ref.aa.yaw_jitter[2], ui_get(custom.thing.jumping.yawjitteradd))
        ui_set(ref.aa.body_yaw[1], ui_get(custom.thing.jumping.bodyyaw))
    elseif states.moving() and not states.crouch() then
        --ui_set(ref.aa.fakeyaw, ui_get(custom.thing.moving.fakeyawlimit))                
        ui_set(ref.aa.freestand_bodyyaw, false)               
        ui_set(ref.aa.edgeyaw, false)               
        ui_set(ref.aa.pitch, ui_get(custom.thing.moving.pitch))                      
        ui_set(ref.aa.yaw_base, ui_get(custom.thing.moving.yawbase))  
        ui_set(ref.aa.yaw[1], ui_get(custom.thing.moving.yaw))                
        ui_set(ref.aa.yaw[2], ui_get(custom.thing.moving.yawadd))                
        ui_set(ref.aa.yaw_jitter[1], ui_get(custom.thing.moving.yawjitter))               
        ui_set(ref.aa.yaw_jitter[2], ui_get(custom.thing.moving.yawjitteradd))
        ui_set(ref.aa.body_yaw[1], ui_get(custom.thing.moving.bodyyaw))
    elseif states.standing() then
        --ui_set(ref.aa.fakeyaw, ui_get(custom.thing.standing.fakeyawlimit))                
        ui_set(ref.aa.freestand_bodyyaw, false)               
        ui_set(ref.aa.edgeyaw, false)               
        ui_set(ref.aa.pitch, ui_get(custom.thing.standing.pitch))                      
        ui_set(ref.aa.yaw_base, ui_get(custom.thing.standing.yawbase))  
        ui_set(ref.aa.yaw[1], ui_get(custom.thing.standing.yaw))                
        ui_set(ref.aa.yaw[2], ui_get(custom.thing.standing.yawadd))                
        ui_set(ref.aa.yaw_jitter[1], ui_get(custom.thing.standing.yawjitter))               
        ui_set(ref.aa.yaw_jitter[2], ui_get(custom.thing.standing.yawjitteradd))
        ui_set(ref.aa.body_yaw[1], ui_get(custom.thing.standing.bodyyaw))
    end
    if ui_get(whiteout.aa.legit) then 
        --ui_set(ref.aa.fakeyaw, ui_get(custom.thing.on_e.fakeyawlimit))         
        ui_set(ref.aa.freestand_bodyyaw, false)               
        ui_set(ref.aa.edgeyaw, false)               
        ui_set(ref.aa.pitch, ui_get(custom.thing.on_e.pitch))                 
        ui_set(ref.aa.yaw_base, ui_get(custom.thing.on_e.yawbase))                 
        ui_set(ref.aa.yaw[1], ui_get(custom.thing.on_e.yaw))                 
        ui_set(ref.aa.yaw[2], ui_get(custom.thing.on_e.yawadd))                
        ui_set(ref.aa.yaw_jitter[1], ui_get(custom.thing.on_e.yawjitter))               
        ui_set(ref.aa.yaw_jitter[2], ui_get(custom.thing.on_e.yawjitteradd))
        ui_set(ref.aa.body_yaw[1], ui_get(custom.thing.on_e.bodyyaw))
    end
end
--#endregion

--#region aa-function
local oldtime = globals.realtime()

function antiaim(cmd)
    if not ui_get(whiteout.master) then return end

    aa_on_use(cmd)

    local double_tap = ui_get(ref.lp.dt[1]) and ui_get(ref.lp.dt[2])
    local on_shot_aa = ui_get(ref.lp.os[1]) and ui_get(ref.lp.os[2])

    if not contains(ui_get(whiteout.aa.extra), "Custom anti-aim") then 

    else
        custom_aa()
        return 
    end

    ui_set(ref.aa.enabled, true)

    local rand = math.random(0,1)
    if var.best_enemy ~= nil then 
        local target = entity.get_players(true)
        local me = entity.get_local_player()
        if #target > 0 then
            local entindex = target[i]
            if ui_get(whiteout.aa.roll_dd) == 'Side Roll' then
                local e_x, e_y, e_z = entity.hitbox_position(var.best_enemy, 0)
                local lx, ly, lz = client.eye_position()

                local yaw = calc_angle(lx, ly, e_x, e_y)
                local r2dir_x, r2dir_y, r2dir_z = angle_vector(0, (yaw + 90))
                local r2end_x = lx + r2dir_x * 100
                local r2end_y = ly + r2dir_y * 100

                local l2dir_x, l2dir_y, l2dir_z = angle_vector(0, (yaw - 90))
                local l2end_x = lx + l2dir_x * 100
                local l2end_y = ly + l2dir_y * 100

                local l2damage = get_damage(plocal, var.best_enemy, r2end_x, r2end_y, lz)
                local r2damage = get_damage(plocal, var.best_enemy, l2end_x, l2end_y, lz) 

                if ui_get(whiteout.aa.roll_ab) and ui_get(whiteout.aa.roll_cb) then 
                    cmd.roll = l2damage > r2damage and 42 or -42
                    ui_set(ref.aa.yaw[2], l2damage > r2damage and -90 or 90)  

                    --ui_set(ref.aa.fakeyaw, 60)                
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")  
                    ui_set(ref.aa.yaw[1], 180)                               
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 65)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                else
                    cmd.roll = 0
                end
            elseif ui_get(whiteout.aa.roll_dd) == 'Normal' then 
                if ui_get(whiteout.aa.roll_ab) and ui_get(whiteout.aa.roll_cb) then 
                    cmd.roll = 42
                    --ui_set(ref.aa.fakeyaw, 60)                
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")  
                    ui_set(ref.aa.yaw[1], 180)  
                    ui_set(ref.aa.yaw[2], -5)                              
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 65)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                else
                    cmd.roll = 0
                end
            end
        end
        
        if states.crouch() then 
            cmd.roll = contains(ui_get(whiteout.aa.rollstates), 'Ducking') and 42 or 0
        elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) then 
            cmd.roll = contains(ui_get(whiteout.aa.rollstates), 'Slowwalking') and 42 or 0
        elseif states.air() then 
            cmd.roll = contains(ui_get(whiteout.aa.rollstates), 'Jumping') and 42 or 0
        elseif states.moving() then 
            cmd.roll = contains(ui_get(whiteout.aa.rollstates), 'Moving') and 42 or 0
        elseif states.standing() then 
            cmd.roll = contains(ui_get(whiteout.aa.rollstates), 'Standing') and 42 or 0
        end

        if contains(ui_get(whiteout.aa.rollstates), 'Low Velocity') then 
            cmd.roll = velocity(entity.get_local_player()) <= 200 and not (ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2])) and not states.standing() and not states.crouch() and not states.air() and 42 or 0
        end

        ui_set(ref.aa.roll, cmd.roll)

        if (ui_get(whiteout.aa.roll_ab)) then return end

        if entity.get_prop(entity.get_local_player(), "m_bWarmupPeriod") then 
            --ui_set(ref.aa.fakeyaw, 60)                
            ui_set(ref.aa.freestand_bodyyaw, false)               
            ui_set(ref.aa.edgeyaw, false)               
            ui_set(ref.aa.pitch, 'Default')                
            ui_set(ref.aa.yaw_base, "At targets")  
            ui_set(ref.aa.yaw[1], 180)                
            ui_set(ref.aa.yaw[2], 10)                
            ui_set(ref.aa.yaw_jitter[1], "Off")               
            ui_set(ref.aa.yaw_jitter[2], 65)
            ui_set(ref.aa.body_yaw[1], 'Static')
        else
            if not (contains(ui_get(whiteout.aa.jittercondition), "Always") or contains(ui_get(whiteout.aa.jittercondition), "Vulnerable")) then
                if states.crouch() and (not states.air()) then --Crouch
                    --ui_set(ref.aa.fakeyaw, 60)                
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")  
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 10)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 65)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) then -- Slow motion
                    --ui_set(ref.aa.fakeyaw, 60)                
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 10)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 67)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                elseif states.air() then
                    if rand == 0 then 
                        --ui_set(ref.aa.fakeyaw, 60)  
                    elseif rand == 1 then    
                        --ui_set(ref.aa.fakeyaw, 42)  
                    end       
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 5)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 65)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                elseif states.moving() and not states.crouch() then
                    --ui_set(ref.aa.fakeyaw, 60)       
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -14)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 69)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                elseif states.standing() then
                    --ui_set(ref.aa.fakeyaw, 60)        
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false) 
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -5)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 8)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                end
                    --[[
                    LP Above ({entity.get_origin(entity.get_local_player())})[3] - ({entity.get_origin(var.best_enemy)})[3] > 85
                    Below/same ({entity.get_origin(var.best_enemy)})[3] - ({entity.get_origin(entity.get_local_player())})[3] >= 85
                    ]]--
            elseif contains(ui_get(whiteout.aa.jittercondition), "Always") then
                if states.crouch() and (not states.air()) then
                    --ui_set(ref.aa.fakeyaw, 60)                
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 13)                
                    ui_set(ref.aa.yaw_jitter[1], "Center")               
                    ui_set(ref.aa.yaw_jitter[2], 91)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) and not ui_get(ref.lp.dt[2]) then -- Slow motion
                    --ui_set(ref.aa.fakeyaw, 60)                
                    ui_set(ref.aa.freestand_bodyyaw, false)
                    ui_set(ref.aa.edgeyaw, false)
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -44)                
                    ui_set(ref.aa.yaw_jitter[1], "Offset")               
                    ui_set(ref.aa.yaw_jitter[2], 91)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) and ui_get(ref.lp.dt[2]) then -- Slow motion
                    --ui_set(ref.aa.fakeyaw, 60)              
                    ui_set(ref.aa.freestand_bodyyaw, false)
                    ui_set(ref.aa.edgeyaw, false)
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -10)                
                    ui_set(ref.aa.yaw_jitter[1], "Center")               
                    ui_set(ref.aa.yaw_jitter[2], 67)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif states.air() then
                    if rand == 0 then 
                        --ui_set(ref.aa.fakeyaw, 60)     
                    elseif rand == 1 then 
                        --ui_set(ref.aa.fakeyaw, 42) 
                    end
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -28)                
                    ui_set(ref.aa.yaw_jitter[1], "Offset")               
                    ui_set(ref.aa.yaw_jitter[2], 65)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif states.moving() and not states.crouch() and not ui_get(ref.lp.dt[2]) then    
                    --ui_set(ref.aa.fakeyaw, 45)     
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 0)                
                    ui_set(ref.aa.yaw_jitter[1], "Center")               
                    ui_set(ref.aa.yaw_jitter[2], 58)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif states.moving() and not states.crouch() and ui_get(ref.lp.dt[2]) then
                    if (oldtime+0 <= globals.realtime()) then
                        --ui_set(ref.aa.fakeyaw, cycle_table(fakeyaw)) 
                        oldtime = globals.realtime()
                    end   
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -32)                
                    ui_set(ref.aa.yaw_jitter[1], "Offset")               
                    ui_set(ref.aa.yaw_jitter[2], 82)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif states.standing() then
                    --ui_set(ref.aa.fakeyaw, 60)        
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false) 
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -5)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 8)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                end
            end
        end
        if contains(ui_get(whiteout.aa.jittercondition), "Vulnerable") then
            local ex, ey, ez = client.eye_position()
            local target = entity.get_players(true)
            local me = entity.get_local_player()
            for i = 1, #target do
                local entindex = target[i]
                local hx, hy, hz = entity.hitbox_position(entindex, 0)
                local fraction, entindex_hit = client.trace_line(me, ex, ey, ez, hx, hy, hz)

                if entindex_hit == entindex or fraction == 1 then
                    if states.crouch() and (not states.air()) then
                        --ui_set(ref.aa.fakeyaw, 60)                
                        ui_set(ref.aa.freestand_bodyyaw, false)               
                        ui_set(ref.aa.edgeyaw, false)               
                        ui_set(ref.aa.pitch, 'Default')                
                        ui_set(ref.aa.yaw_base, "At targets")                
                        ui_set(ref.aa.yaw[1], 180)                
                        ui_set(ref.aa.yaw[2], 13)                
                        ui_set(ref.aa.yaw_jitter[1], "Center")               
                        ui_set(ref.aa.yaw_jitter[2], 91)
                        ui_set(ref.aa.body_yaw[1], 'Jitter')
                    elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) and not ui_get(ref.lp.dt[2]) then -- Slow motion
                        --ui_set(ref.aa.fakeyaw, 60)                
                        ui_set(ref.aa.freestand_bodyyaw, false)
                        ui_set(ref.aa.edgeyaw, false)
                        ui_set(ref.aa.pitch, 'Default')                
                        ui_set(ref.aa.yaw_base, "At targets")                
                        ui_set(ref.aa.yaw[1], 180)                
                        ui_set(ref.aa.yaw[2], -44)                
                        ui_set(ref.aa.yaw_jitter[1], "Offset")               
                        ui_set(ref.aa.yaw_jitter[2], 91)
                        ui_set(ref.aa.body_yaw[1], 'Jitter')
                    elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) and ui_get(ref.lp.dt[2]) then -- Slow motion
                        --ui_set(ref.aa.fakeyaw, 60)              
                        ui_set(ref.aa.freestand_bodyyaw, false)
                        ui_set(ref.aa.edgeyaw, false)
                        ui_set(ref.aa.pitch, 'Default')                
                        ui_set(ref.aa.yaw_base, "At targets")                
                        ui_set(ref.aa.yaw[1], 180)                
                        ui_set(ref.aa.yaw[2], -10)                
                        ui_set(ref.aa.yaw_jitter[1], "Center")               
                        ui_set(ref.aa.yaw_jitter[2], 67)
                        ui_set(ref.aa.body_yaw[1], 'Jitter')
                    elseif states.air() then
                        if rand == 0 then 
                            --ui_set(ref.aa.fakeyaw, 60)     
                        elseif rand == 1 then 
                            --ui_set(ref.aa.fakeyaw, 42) 
                        end
                        ui_set(ref.aa.freestand_bodyyaw, false)               
                        ui_set(ref.aa.edgeyaw, false)               
                        ui_set(ref.aa.pitch, 'Default')                
                        ui_set(ref.aa.yaw_base, "At targets")
                        ui_set(ref.aa.yaw[1], 180)                
                        ui_set(ref.aa.yaw[2], -28)                
                        ui_set(ref.aa.yaw_jitter[1], "Offset")               
                        ui_set(ref.aa.yaw_jitter[2], 65)
                        ui_set(ref.aa.body_yaw[1], 'Jitter')
                    elseif states.moving() and not states.crouch() and not ui_get(ref.lp.dt[2]) then    
                        --ui_set(ref.aa.fakeyaw, 45)     
                        ui_set(ref.aa.freestand_bodyyaw, false)               
                        ui_set(ref.aa.edgeyaw, false)               
                        ui_set(ref.aa.pitch, 'Default')                
                        ui_set(ref.aa.yaw_base, "At targets")                
                        ui_set(ref.aa.yaw[1], 180)                
                        ui_set(ref.aa.yaw[2], 0)                
                        ui_set(ref.aa.yaw_jitter[1], "Center")               
                        ui_set(ref.aa.yaw_jitter[2], 58)
                        ui_set(ref.aa.body_yaw[1], 'Jitter')
                    elseif states.moving() and not states.crouch() and ui_get(ref.lp.dt[2]) then
                        if (oldtime+0 <= globals.realtime()) then
                            --ui_set(ref.aa.fakeyaw, cycle_table(fakeyaw)) 
                            oldtime = globals.realtime()
                        end   
                        ui_set(ref.aa.freestand_bodyyaw, false)               
                        ui_set(ref.aa.edgeyaw, false)               
                        ui_set(ref.aa.pitch, 'Default')                
                        ui_set(ref.aa.yaw_base, "At targets")                
                        ui_set(ref.aa.yaw[1], 180)                
                        ui_set(ref.aa.yaw[2], -32)                
                        ui_set(ref.aa.yaw_jitter[1], "Offset")               
                        ui_set(ref.aa.yaw_jitter[2], 82)
                        ui_set(ref.aa.body_yaw[1], 'Jitter')
                    elseif states.standing() then
                        --ui_set(ref.aa.fakeyaw, 60)        
                        ui_set(ref.aa.freestand_bodyyaw, false)               
                        ui_set(ref.aa.edgeyaw, false) 
                        ui_set(ref.aa.pitch, 'Default')                
                        ui_set(ref.aa.yaw_base, "At targets")                
                        ui_set(ref.aa.yaw[1], 180)                
                        ui_set(ref.aa.yaw[2], -5)                
                        ui_set(ref.aa.yaw_jitter[1], "Off")               
                        ui_set(ref.aa.yaw_jitter[2], 8)
                        ui_set(ref.aa.body_yaw[1], 'Static')
                    end
                elseif entindex_hit ~= entindex and fraction ~= 1 then 
                    if states.crouch() and (not states.air()) then 
                        --ui_set(ref.aa.fakeyaw, 60)                
                        ui_set(ref.aa.freestand_bodyyaw, false)               
                        ui_set(ref.aa.edgeyaw, false)               
                        ui_set(ref.aa.pitch, 'Default')                
                        ui_set(ref.aa.yaw_base, "At targets")                
                        ui_set(ref.aa.yaw[1], 180)                
                        ui_set(ref.aa.yaw[2], 5)                
                        ui_set(ref.aa.yaw_jitter[1], "Off")               
                        ui_set(ref.aa.yaw_jitter[2], 65)
                        ui_set(ref.aa.body_yaw[1], 'Static')
                    elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) then
                        --ui_set(ref.aa.fakeyaw, 60)                
                        ui_set(ref.aa.freestand_bodyyaw, false)               
                        ui_set(ref.aa.edgeyaw, false)               
                        ui_set(ref.aa.pitch, 'Default')                
                        ui_set(ref.aa.yaw_base, "At targets")                
                        ui_set(ref.aa.yaw[1], 180)                
                        ui_set(ref.aa.yaw[2], -6)                
                        ui_set(ref.aa.yaw_jitter[1], "Off")               
                        ui_set(ref.aa.yaw_jitter[2], 67)
                        ui_set(ref.aa.body_yaw[1], 'Static')
                    elseif states.air() then
                        if rand == 0 then 
                            --ui_set(ref.aa.fakeyaw, 60)  
                        elseif rand == 1 then    
                            --ui_set(ref.aa.fakeyaw, 42)  
                        end       
                        ui_set(ref.aa.freestand_bodyyaw, false)               
                        ui_set(ref.aa.edgeyaw, false)               
                        ui_set(ref.aa.pitch, 'Default')                
                        ui_set(ref.aa.yaw_base, "At targets")                
                        ui_set(ref.aa.yaw[1], 180)                
                        ui_set(ref.aa.yaw[2], 5)                
                        ui_set(ref.aa.yaw_jitter[1], "Off")               
                        ui_set(ref.aa.yaw_jitter[2], 65)
                        ui_set(ref.aa.body_yaw[1], 'Static')
                    elseif states.moving() and not states.crouch() then
                        --ui_set(ref.aa.fakeyaw, 60)       
                        ui_set(ref.aa.freestand_bodyyaw, false)               
                        ui_set(ref.aa.edgeyaw, false)               
                        ui_set(ref.aa.pitch, 'Default')                
                        ui_set(ref.aa.yaw_base, "At targets")                
                        ui_set(ref.aa.yaw[1], 180)                
                        ui_set(ref.aa.yaw[2], 4)                
                        ui_set(ref.aa.yaw_jitter[1], "Off")               
                        ui_set(ref.aa.yaw_jitter[2], 69)
                        ui_set(ref.aa.body_yaw[1], 'Static')
                    elseif states.standing() then
                        --ui_set(ref.aa.fakeyaw, 60)        
                        ui_set(ref.aa.freestand_bodyyaw, false)               
                        ui_set(ref.aa.edgeyaw, false) 
                        ui_set(ref.aa.pitch, 'Default')                
                        ui_set(ref.aa.yaw_base, "At targets")                
                        ui_set(ref.aa.yaw[1], 180)                
                        ui_set(ref.aa.yaw[2], -5)                
                        ui_set(ref.aa.yaw_jitter[1], "Offset")               
                        ui_set(ref.aa.yaw_jitter[2], 8)
                        ui_set(ref.aa.body_yaw[1], 'Static')
                    end
                end
            end
        end
    end
    if contains(ui_get(whiteout.aa.jittercondition), "On Playerstate") then
            if states.crouch() and (not states.air()) then 
                if contains(ui_get(whiteout.aa.playerstates), 'Ducking') then 
                    --ui_set(ref.aa.fakeyaw, 60)                
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 20)                
                    ui_set(ref.aa.yaw_jitter[1], "Center")               
                    ui_set(ref.aa.yaw_jitter[2], 40)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                    if (oldtime+0 <= globals.realtime()) then
                        ui_set(ref.aa.body_yaw[2], cycle_table(crouch)) 
                        oldtime = globals.realtime()
                    end 
                else 
                    --ui_set(ref.aa.fakeyaw, 60)                
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 5)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 65)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                end
            elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) then
                if contains(ui_get(whiteout.aa.playerstates), 'Slowwalking') then
                    --ui_set(ref.aa.fakeyaw, 60)              
                    ui_set(ref.aa.freestand_bodyyaw, false)
                    ui_set(ref.aa.edgeyaw, false)
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -10)                
                    ui_set(ref.aa.yaw_jitter[1], "Center")               
                    ui_set(ref.aa.yaw_jitter[2], 67)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif not contains(ui_get(whiteout.aa.playerstates), 'Slowwalking') then
                    --ui_set(ref.aa.fakeyaw, 60)                
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -6)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 67)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                end
            elseif states.air() then
                if contains(ui_get(whiteout.aa.playerstates), 'Jumping') then
                    if rand == 0 then 
                        --ui_set(ref.aa.fakeyaw, 60)     
                    elseif rand == 1 then 
                        --ui_set(ref.aa.fakeyaw, 42) 
                    end
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -29)                
                    ui_set(ref.aa.yaw_jitter[1], "Offset")               
                    ui_set(ref.aa.yaw_jitter[2], 79)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif not contains(ui_get(whiteout.aa.playerstates), 'Jumping') then
                    --ui_set(ref.aa.fakeyaw, 60)         
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 0)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 65)
                    ui_set(ref.aa.body_yaw[1], 'Opposite')
                end
            elseif states.moving() and not states.crouch() then
                if contains(ui_get(whiteout.aa.playerstates), 'Moving') then
                    if (oldtime+0 <= globals.realtime()) then
                        --ui_set(ref.aa.fakeyaw, cycle_table(fakeyaw)) 
                        oldtime = globals.realtime()
                    end   
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -31)                
                    ui_set(ref.aa.yaw_jitter[1], "Offset")               
                    ui_set(ref.aa.yaw_jitter[2], 82)    
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif not contains(ui_get(whiteout.aa.playerstates), 'Moving') then
                    --ui_set(ref.aa.fakeyaw, 60)       
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 4)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 69)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                end
            elseif states.standing() then
                if contains(ui_get(whiteout.aa.playerstates), 'Standing') then
                    --ui_set(ref.aa.fakeyaw, 60)        
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false) 
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -5)                
                    ui_set(ref.aa.yaw_jitter[1], "Offset")               
                    ui_set(ref.aa.yaw_jitter[2], 8)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif not contains(ui_get(whiteout.aa.playerstates), 'Standing') then
                    --ui_set(ref.aa.fakeyaw, 60)        
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false) 
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -5)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 8)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                end
            end
        end
        if contains(ui_get(whiteout.aa.jittercondition), "On Exploit") then 
            if double_tap or on_shot_aa then 
                if states.crouch() and (not states.air()) then 
                    --ui_set(ref.aa.fakeyaw, 60)                
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 13)                
                    ui_set(ref.aa.yaw_jitter[1], "Center")               
                    ui_set(ref.aa.yaw_jitter[2], 59)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) then
                    --ui_set(ref.aa.fakeyaw, 60)              
                    ui_set(ref.aa.freestand_bodyyaw, false)
                    ui_set(ref.aa.edgeyaw, false)
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -10)                
                    ui_set(ref.aa.yaw_jitter[1], "Center")               
                    ui_set(ref.aa.yaw_jitter[2], 67)
                    ui_set(ref.aa.body_yaw[1], 'Jitter') 
                elseif states.air() then
                    if rand == 0 then 
                        --ui_set(ref.aa.fakeyaw, 60)     
                    elseif rand == 1 then 
                        --ui_set(ref.aa.fakeyaw, 42) 
                    end
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -29)                
                    ui_set(ref.aa.yaw_jitter[1], "Offset")               
                    ui_set(ref.aa.yaw_jitter[2], 65)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif states.moving() and not states.crouch() then
                    if (oldtime+0 <= globals.realtime()) then
                        --ui_set(ref.aa.fakeyaw, cycle_table(fakeyaw)) 
                        oldtime = globals.realtime()
                    end   
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -32)                
                    ui_set(ref.aa.yaw_jitter[1], "Offset")               
                    ui_set(ref.aa.yaw_jitter[2], 82)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                elseif states.standing() then
                    --ui_set(ref.aa.fakeyaw, 60)        
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false) 
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -5)                
                    ui_set(ref.aa.yaw_jitter[1], "Offset")               
                    ui_set(ref.aa.yaw_jitter[2], 8)
                    ui_set(ref.aa.body_yaw[1], 'Jitter')
                end
            elseif not double_tap or not on_shot_aa then 
                if states.crouch() and (not states.air()) then 
                    --ui_set(ref.aa.fakeyaw, 60)                
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 5)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 65)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) then
                    --ui_set(ref.aa.fakeyaw, 60)                
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -6)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 67)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                elseif states.air() then
                    --ui_set(ref.aa.fakeyaw, 60)         
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 0)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 65)
                    ui_set(ref.aa.body_yaw[1], 'Opposite')
                elseif states.moving() and not states.crouch() then
                    --ui_set(ref.aa.fakeyaw, 60)       
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false)               
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], 4)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 69)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                elseif states.standing() then
                    --ui_set(ref.aa.fakeyaw, 60)        
                    ui_set(ref.aa.freestand_bodyyaw, false)               
                    ui_set(ref.aa.edgeyaw, false) 
                    ui_set(ref.aa.pitch, 'Default')                
                    ui_set(ref.aa.yaw_base, "At targets")                
                    ui_set(ref.aa.yaw[1], 180)                
                    ui_set(ref.aa.yaw[2], -5)                
                    ui_set(ref.aa.yaw_jitter[1], "Off")               
                    ui_set(ref.aa.yaw_jitter[2], 8)
                    ui_set(ref.aa.body_yaw[1], 'Static')
                end
            end
        end
    if contains(ui_get(whiteout.aa.jittercondition), "Enemy Dormant") and var.best_enemy == nil then
        --ui_set(ref.aa.fakeyaw, 60) 
        ui_set(ref.aa.pitch, 'Default') 
        ui_set(ref.aa.yaw[1], 180)                
        ui_set(ref.aa.yaw[2], -17) 
        ui_set(ref.aa.yaw_jitter[1], "Center")               
        ui_set(ref.aa.yaw_jitter[2], 65)
        ui_set(ref.aa.body_yaw[1], 'Jitter')
    elseif not contains(ui_get(whiteout.aa.jittercondition), "Enemy Dormant") and var.best_enemy == nil then
        --ui_set(ref.aa.fakeyaw, 60)         
        ui_set(ref.aa.freestand_bodyyaw, false)               
        ui_set(ref.aa.edgeyaw, false)               
        ui_set(ref.aa.pitch, 'Default')                
        ui_set(ref.aa.yaw_base, "At targets")                
        ui_set(ref.aa.yaw[1], 180)                
        ui_set(ref.aa.yaw[2], 0)                
        ui_set(ref.aa.yaw_jitter[1], "Off")               
        ui_set(ref.aa.yaw_jitter[2], 65)
        ui_set(ref.aa.body_yaw[1], 'Opposite')
    end
    if ui_get(whiteout.aa.legit) and contains(ui_get(whiteout.aa.extra), 'Legit anti-aim') then 
        --ui_set(ref.aa.fakeyaw, 60)         
        ui_set(ref.aa.freestand_bodyyaw, false)               
        ui_set(ref.aa.edgeyaw, false)               
        ui_set(ref.aa.pitch, 'Off')                
        ui_set(ref.aa.yaw_base, "Local view")                
        ui_set(ref.aa.yaw[1], '180')                
        ui_set(ref.aa.yaw[2], 180)                
        ui_set(ref.aa.yaw_jitter[1], "Off")               
        ui_set(ref.aa.yaw_jitter[2], 65)
        ui_set(ref.aa.body_yaw[1], 'Opposite')
    end
end

-- thx to rave
local function PointToPoint(A, B, P)
    local a_to_p = { P[1] - A[1], P[2] - A[2] }
    local a_to_b = { B[1] - A[1], B[2] - A[2] }
    
    local atb2 = a_to_b[1]^2 + a_to_b[2]^2
    
    local atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    local t = atp_dot_atb / atb2
    
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end
    

-- 3d line distance detection from ts
local function Headshort(shooter, e)
    local x, y, z = entity.hitbox_position(shooter, 0)
    local x1, y1, z1 = client.eye_position()
    
    local p = {x1,y1,z1}
    
    local a = {x,y,z}
    local b = {e.x,e.y,e.z}
    
    local ab = {b[1] - a[1], b[2] - a[2], b[3] - a[3]}
    local len = math.sqrt(ab[1]^2 + ab[2]^2 + ab[3]^2)
    local d  = {ab[1] / len, ab[2] / len, ab[3] / len}
    local ap = {p[1] - a[1], p[2] - a[2], p[3] - a[3]}
    local d2 = d[1]*ap[1] + d[2]*ap[2] + d[3]*ap[3]
    
    bp = {a[1] + d2 * d[1], a[2] + d2 * d[2], a[3] + d2 * d[3]}
    
    return (bp[1]-x1) + (bp[2]-y1) + (bp[3]-z1)
end

local skip = false
client.set_event_callback('bullet_impact', function(c)
    if not ui_get(whiteout.master) then return end
    
    if entity.is_alive(entity.get_local_player()) and not skip then
        local ent = client.userid_to_entindex(c.userid)
        if not entity.is_dormant(ent) and entity.is_enemy(ent) then
            local ent_pos = { entity.get_prop(ent, 'm_vecOrigin') }
            local loc_pos = { entity.get_prop(ent, 'm_vecOrigin') }
            local delta = Headshort(ent, c)
            if math.abs(delta) < ui_get(whiteout.aa.bullet_detection) / 1.6666667 then
                ab = ab + 1
                flip = true
            end
        end
    end
    if flip then
        if ui_get(whiteout.aa.antibrute_type) == 'Default' then
            ui_set(ref.aa.body_yaw[2], default[(ab % 2) + 1])
        elseif ui_get(whiteout.aa.antibrute_type) == 'Aggressive' then
            ui_set(ref.aa.body_yaw[2], aggressive[(ab % 2) + 1])
        end
        flip = false
    end
    skip = false
end)

client.set_event_callback("player_hurt", function(e)
    local attacker_entindex = client.userid_to_entindex(e.attacker)
    local victim_entindex = client.userid_to_entindex(e.userid)
    if entity.is_alive(entity.get_local_player()) then
        if victim_entindex == entity.get_local_player() and entity.is_enemy(attacker_entindex) then
            local by = ui_get(ref.aa.body_yaw[2])
            ui_set(ref.aa.body_yaw[2], by * -1)
            skip = true
        end
    end
end)

client.set_event_callback('round_start', function()
    ui_set(ref.aa.body_yaw[2], 0)
    notify:paint(15, "Reset angles due to round start")
end)
--#endregion

--#region fakelag & Leg breaker
client.set_event_callback('setup_command', function()
    if not ui_get(whiteout.master) then return end
    if not ui_get(whiteout.fakelag.dynamic) then return end

    local double_tap = ui_get(ref.lp.dt[1]) and ui_get(ref.lp.dt[2])
    local on_shot_aa = ui_get(ref.lp.os[1]) and ui_get(ref.lp.os[2])

    local random = client.random_int(0, 10)
    local neither = (double_tap or on_shot_aa)

    if ui_get(whiteout.fakelag.dynamic_type) == 'Advanced' then 

        if on_shot_aa then 
            ui_set(ref.fakelag.limit, 6)
        elseif double_tap then 
            ui_set(ref.fakelag.limit, 15)
        elseif not (on_shot_aa or double_tap) then 
            ui_set(ref.fakelag.limit, 15)
        end
        ui_set(ref.fakelag.variance, 20)
    elseif ui_get(whiteout.fakelag.dynamic_type) == 'Default' then 
        ui_set(ref.fakelag.variance, 20)
        ui_set(ref.fakelag.amount, 'Maximum')
    end
end)

local randome = 0
client.set_event_callback("pre_render", function()
    
    if contains(ui_get(whiteout.aa.extra), 'Leg Breaker') then
        ui_set(ref.lp.lm, "always slide")
    else
        ui_set(ref.lp.lm, "never slide")
    end
    if contains(ui_get(whiteout.aa.extra), 'Leg Breaker') then
        randome = math.random(1,10)
        if randome > ui_get(whiteout.aa.legs) then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
        end
    else
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
    end
end)
--#endregion

--#region hotkey-function
local leftoff = false
local rightoff = false
local mode = "back"

local function hotkey_setup()
    if not ui_get(whiteout.master) then return end
        ui_set(ref.aa.freestanding[2], "Always on")
        ui_set(whiteout.dir.manualleft, "On hotkey")
        ui_set(whiteout.dir.manualright, "On hotkey")

    if ui_get(whiteout.dir.free) and ui_get(whiteout.dir.customdir) then
        ui_set(ref.aa.freestanding[1], true)
    else
        ui_set(ref.aa.freestanding[1], false)
    end

    if states.air() then
        ui_set(ref.aa.freestanding[1], false)
    end
    
    if ui_get(whiteout.dir.edge) and ui_get(whiteout.dir.customdir) then
        ui_set(ref.aa.edgeyaw, true)
    else
        ui_set(ref.aa.edgeyaw, false)
    end

    if ui_get(whiteout.dir.customdir) then
        if ui_get(whiteout.dir.manualback) then
            mode = "back"
        elseif ui_get(whiteout.dir.manualleft) and leftoff then
            if mode == "left" then
                mode = "back"
            else
                mode = "left"
            end
            leftoff = false
        elseif ui_get(whiteout.dir.manualright) and rightoff then
            if mode == "right" then
                mode = "back"
            else
                mode = "right"
            end
            rightoff = false
        end
        if ui_get(whiteout.dir.manualleft) == false then
            leftoff = true
        end
        if ui_get(whiteout.dir.manualright) == false then
            rightoff = true
        end
        if mode == "back" then
            var.aa_dir = ui_get(ref.aa.yaw[2])
        elseif mode == "left" then
            var.aa_dir = -90
            ui_set(ref.aa.yaw[2], -90)
        elseif mode == "right" then
            var.aa_dir = 90
            ui_set(ref.aa.yaw[2], 90)
        elseif not (mode == "right" or mode == "left") then 
            var.aa_dir = ui_get(ref.aa.yaw[2])
            ui_set(ref.aa.yaw[2], ui_get(ref.aa.yaw[2]))
        end
    end
    ui_set(ref.aa.yaw[2], var.aa_dir)
end
--#endregion

--#region misc
local function misc_features()
    if ui_get(whiteout.master) and ui_get(whiteout.misc.dt.doubletapboostcheck) then
        local ping = math.floor(client.latency() * 1000)
        if ui_get(whiteout.misc.dt.doubletapboostdrop) == "Default" then
            ui_set(ref.misc.max_ticks, 16)
        elseif ui_get(whiteout.misc.dt.doubletapboostdrop) == "Safe" then
            ui_set(ref.misc.max_ticks, 15)
        elseif ui_get(whiteout.misc.dt.doubletapboostdrop) == "Dangerous" then
            ui_set(ref.misc.max_ticks, 17)
        end
        if ping <= 55 and ui_get(whiteout.misc.dt.doubletapboostdrop) == "Adaptive" then
            ui_set(ref.misc.max_ticks, 17)
        elseif ping >= 55 and ui_get(whiteout.misc.dt.doubletapboostdrop) == "Adaptive" then
            ui_set(ref.misc.max_ticks, 15)
        end
        if ui_get(whiteout.misc.dt.doubletapboostdrop) == "Custom" then
            ui_set(ref.misc.max_ticks, ui_get(whiteout.misc.dt.doubletapboostcustom))
        end
    end
end

client.set_event_callback('paint', function()
    local pprocessing = ui_reference("Visuals", "Effects", "Disable post processing")
    if ui_get(whiteout.misc.sunsetmode) then
        ui_set(pprocessing, false)
        convars.override:set_int(1)
        convars.x:set_int(170)
        convars.y:set_int(0)
        convars.z:set_int(0)
    else
        ui_set(pprocessing, true)
        convars.override:set_int(0)
    end
end)
--#endregion

--#region killsay
local deathtable = {
    "you are lucky king forgot to turn on antiaim",
    "you are lucky u rip os",
    "never think u are good vs king",
    "my ragebot was off",
    "giving bots like you a chance",
}

local killtable = {
    "sent to hell and back (shoppy.gg/@rite)",
    "I have come to exterminate weak dogs *trental, zyfe, alex, cartier, warped* with (shoppy.gg/@rite)",
    "for you this 1's. for me these heads, by whiteout (shoppy.gg/@rite)",
    "Sent to hell, by whiteout (shoppy.gg/@rite)",
    "a weak trental has sent me to H$ kyoto.japan (shoppy.gg/@rite)",
    "Loading.... LOADING THIS HEADSHOT (shoppy.gg/@rite)",
    "𝔼𝕊𝕆𝕋𝔼ℝ𝕀𝕂 ℍ𝔸𝕊 𝕊𝔼ℕ𝕋 𝕄𝔼 𝕋𝕆 𝔻𝔼𝕃𝕀𝕍𝔼ℝ 𝕋ℍ𝕀𝕊 ℍ$ (shoppy.gg/@rite)",
    "I have come to send u back to hell (shoppy.gg/@rite)",
    "Loading... 10%.... Loading 30% ..... Loading 70% .... Load- ERROR ENEMY HAS BEEN ELIMINATED BEFORE COMPLETION (shoppy.gg/@rite)",
}
  
local num_quotes_kill = get_table_length(killtable)
local num_quotes_death = get_table_length(deathtable)
  
local function on_player_death(e)
	if not ui_get(whiteout.misc.killsay) then return	end
	local victim_userid, attacker_userid = e.userid, e.attacker
	if victim_userid == nil or attacker_userid == nil then return end

	local victim_entindex   = client.userid_to_entindex(victim_userid)
	local attacker_entindex = client.userid_to_entindex(attacker_userid)
	if attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) then
	local commandbaim = 'say ' .. killtable[math.random(num_quotes_kill)]
        client.exec(commandbaim)
	end

	if victim_entindex == entity.get_local_player() and attacker_entindex ~= entity.get_local_player() then
        local commandbaim = 'say ' .. deathtable[math.random(num_quotes_death)]
        client.exec(commandbaim)
        
	end
end
--#endregion

--#region import / export
local export_settings = function(settings)
    pcall(function()
        local settings = {}

        for key, value in pairs(custom.thing) do
            if value then
                settings[key] = {}
                if type(value) == 'table' then
                    for k, v in pairs(value) do
                        settings[key][k] = ui.get(v)
                    end
                end
            end
        end
        clipboard.set(json.stringify(settings))
    end)
end

local lua_import_export_export = ui.new_button( tab, container, "Export Custom Settings", function()
    export_settings(custom.thing)
    notify:paint(15, 'Exported Settings Successfully')
end)

local function import_settings(settings)
    pcall(function()
        local settings = json.parse(clipboard.get())
        for key, value in pairs(settings) do
            if type(value) == 'table' then
                for k, v in pairs(value) do
                    ui.set(custom.thing[key][k], v)
                end
            end
        end
    end)
end

local lua_import_export_import = ui.new_button( tab, container, "Import Custom Settings", function()
    import_settings(custom.thing)
    notify:paint(15, 'Imported Settings Successfully')
end)
--#endregion

--#region indicators 
local anim = 0
local function crosshair_indicators()
    local me = entity.get_local_player()

    if not entity.is_alive(me) then return end 

    local alpha = math.sin(math.abs((math.pi * -1) + (globals.curtime() * 1) % (math.pi * 2))) * 255
    local ping = math_floor(client.latency() * 1000)
    local delta = math.max(-60, math.min(60, round((entity.get_prop(me, "m_flPoseParameter", 11) or 0) * 120 - 60 + 0.5, 1)))
    local is_scoped = entity.get_prop(entity.get_local_player(), 'm_bIsScoped')	== 1
    screen = {client.screen_size()}

    local username = _G.obex_name == nil and 'Poison' or _G.obex_name
    local build = _G.obex_build == nil and 'Debug' or _G.obex_build

    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60

    local h, m, s, ms = client.system_time()

    local double_tap = ui.get(ref.lp.dt[1]) and ui.get(ref.lp.dt[2])
    local on_shot_aa = ui.get(ref.lp.os[1]) and ui.get(ref.lp.os[2])
    local exploit = double_tap or on_shot_aa

    local offset = 11
    local bindstoggled = 0

    local hotkeyc = { ui_get(whiteout.visual.debug.debug_color)  }

    if is_scoped then
        if anim < 85 then
        anim = anim + 1.8
        end
    else
        if anim > 0 then
        anim = anim - 3.6
        end
    end
    screen[1] = screen[1] + anim
    x , y = screen[1], screen[2]

    if ui.is_menu_open() then
        local cx, cy = ui.mouse_position()
        --1
        if iu.dragging and not client.key_state(1) then
            iu.dragging = false
        end 

        --1
        if iu.dragging and client.key_state(1) then
            iu.x = cx - iu.drag_x
            iu.y = cy - iu.drag_y
        end

         --1
         if intersect(iu.x, iu.y, iu.w, iu.h + 30) and client.key_state(1) then
            iu.dragging = true
            iu.drag_x = cx - iu.x
            iu.drag_y = cy - iu.y
        end
    end

    --color pickers
    local namec = {ui_get(whiteout.visual.colorpicker.name_color)}
    local state = {ui_get(whiteout.visual.colorpicker.playerstate_color)}
    local exploitc = {ui_get(whiteout.visual.colorpicker.exploit_color)}
    local arrowc   = {ui_get(whiteout.visual.colorpicker.arrow_color)}

    local sx, sy = client.screen_size()
    
    renderer.triangle(sx/2 + 55, sy/2 + 2, sx/2 + 42, sy/2 - 7, sx/2 + 42, sy/2 + 11, var.aa_dir == 90 and arrowc[1] or 35, var.aa_dir == 90 and arrowc[2] or 35, var.aa_dir == 90 and arrowc[3] or 35, var.aa_dir == 90 and arrowc[4] or 150)
    renderer.triangle(sx/2 - 55, sy/2 + 2, sx/2 - 42, sy/2 - 7, sx/2 - 42, sy/2 + 11, var.aa_dir == -90 and arrowc[1] or 35, var.aa_dir == -90 and arrowc[2] or 35, var.aa_dir == -90 and arrowc[3] or 35, var.aa_dir == -90 and arrowc[4] or 150)
    renderer.rectangle(sx/2 + 38, sy/2 - 7, 2, 18, bodyyaw < -10 and arrowc[1] or 35,bodyyaw < -10 and arrowc[2] or 35,bodyyaw < -10 and arrowc[3] or 35,bodyyaw < -10 and arrowc[4] or 150)
    renderer.rectangle(sx/2 - 40, sy/2 - 7, 2, 18, bodyyaw > 10 and arrowc[1] or 35,bodyyaw > 10 and arrowc[2] or 35,bodyyaw > 10 and arrowc[3] or 35,bodyyaw > 10 and arrowc[4] or 150)

    if ui_get(whiteout.visual.crosshair.master) and contains(ui_get(whiteout.visual.indicatortype), "Crosshair") and not is_scoped then
        renderer.text(x/2, y/2 + 30, namec[1], namec[2], namec[3], 255, 'c-', nil, 'WHITEOUT')
        if states.crouch() and (not states.air()) then --Crouch
            renderer.text(x/2, y/2 + 40, state[1], state[2], state[3], 255, 'c-', nil, 'DUCKING')
        elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) then -- Slow motion
            renderer.text(x/2, y/2 + 40, state[1], state[2], state[3], 255, 'c-', nil, 'SLOWMOTION')
        elseif states.air() then
            renderer.text(x/2, y/2 + 40, state[1], state[2], state[3], 255, 'c-', nil, 'JUMPING')
        elseif states.moving() and not states.crouch() then
            renderer.text(x/2, y/2 + 40, state[1], state[2], state[3], 255, 'c-', nil, 'MOVING')
        elseif states.standing() then
            renderer.text(x/2, y/2 + 40, state[1], state[2], state[3], 255, 'c-', nil, 'STANDING')
        end

        if ui_get(ref.lp.fb) then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "BAIM")
            renderer.text(((x/2)), ((y/2)+50)+(offset*bindstoggled), exploitc[1], exploitc[2], exploitc[3], 255, "c-", 0, "BAIM")
            bindstoggled = bindstoggled +1
        end

        if ui_get(ref.lp.sp) then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "SPOINT")
            renderer.text(((x/2)), ((y/2)+50)+(offset*bindstoggled), exploitc[1], exploitc[2], exploitc[3], 255, "c-", 0, "SPOINT")
            bindstoggled = bindstoggled +1
        end

        if double_tap and anti_aim.get_double_tap() then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "DT")
            renderer.text(((x/2) - 13), ((y/2)+50)+(offset*bindstoggled),  exploitc[1], exploitc[2], exploitc[3], 255, "c-", 0, "DT")
            bindstoggled = bindstoggled +1
        elseif double_tap and not anti_aim.get_double_tap() then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "DT")
            renderer.text(((x/2) - 13), ((y/2)+50)+(offset*bindstoggled),  255, 15, 15, 255, "c-", 0, "DT")
            bindstoggled = bindstoggled +1
        elseif not double_tap then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "DT")
            renderer.text(((x/2) - 13), ((y/2)+50)+(offset*bindstoggled), 255, 255, 255, 55, "c-", 0, "DT")
            bindstoggled = bindstoggled +1
        end
        if on_shot_aa then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "AA")
            renderer.text(((x/2)), ((y/2)+39)+(offset*bindstoggled), exploitc[1], exploitc[2], exploitc[3], 255, "c-", 0, "AA")
            bindstoggled = bindstoggled +1
        elseif not on_shot_aa then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "AA")
            renderer.text(((x/2)), ((y/2)+39)+(offset*bindstoggled), 255, 255, 255, 55, "c-", 0, "AA")
            bindstoggled = bindstoggled +1
        end
        if contains(ui_get(ref.aa.freestanding[1]), 'Default') then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "FS")
            renderer.text(((x/2) + 12), ((y/2)+28)+(offset*bindstoggled), exploitc[1], exploitc[2], exploitc[3], 255, "c-", 0, "FS")
            bindstoggled = bindstoggled +1
        else
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "FS")
            renderer.text(((x/2) + 12), ((y/2)+28)+(offset*bindstoggled), 255, 255, 255, 55, "c-", 0, "FS")
            bindstoggled = bindstoggled +1
        end
    elseif ui_get(whiteout.visual.crosshair.master) and contains(ui_get(whiteout.visual.indicatortype), "Crosshair") and is_scoped then 
        renderer.text(x/2, y/2 + 30, namec[1], namec[2], namec[3], 255, 'c-', nil, 'WHITEOUT')
        if states.crouch() and (not states.air()) then --Crouch
            renderer.text(x/2, y/2 + 40, state[1], state[2], state[3], 255, 'c-', nil, 'DUCKING')
        elseif ui_get(ref.aa.slowwalk[1]) and ui_get(ref.aa.slowwalk[2]) and (not states.air()) then -- Slow motion
            renderer.text(x/2, y/2 + 40, state[1], state[2], state[3], 255, 'c-', nil, 'SLOWMOTION')
        elseif states.air() then
            renderer.text(x/2, y/2 + 40, state[1], state[2], state[3], 255, 'c-', nil, 'JUMPING')
        elseif states.moving() and not states.crouch() then
            renderer.text(x/2, y/2 + 40, state[1], state[2], state[3], 255, 'c-', nil, 'MOVING')
        elseif states.standing() then
            renderer.text(x/2, y/2 + 40, state[1], state[2], state[3], 255, 'c-', nil, 'STANDING')
        end

        if ui_get(ref.lp.fb) then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "BAIM")
            renderer.text(((x/2)), ((y/2)+50)+(offset*bindstoggled), exploitc[1], exploitc[2], exploitc[3], 255, "c-", 0, "BAIM")
            bindstoggled = bindstoggled +1
        end

        if ui_get(ref.lp.sp) then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "SPOINT")
            renderer.text(((x/2)), ((y/2)+50)+(offset*bindstoggled), exploitc[1], exploitc[2], exploitc[3], 255, "c-", 0, "SPOINT")
            bindstoggled = bindstoggled +1
        end

        if double_tap and anti_aim.get_double_tap() then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "DT")
            renderer.text(((x/2) - 13), ((y/2)+50)+(offset*bindstoggled),  exploitc[1], exploitc[2], exploitc[3], 255, "c-", 0, "DT")
            bindstoggled = bindstoggled +1
        elseif double_tap and not anti_aim.get_double_tap() then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "DT")
            renderer.text(((x/2) - 13), ((y/2)+50)+(offset*bindstoggled),  255, 15, 15, 255, "c-", 0, "DT")
            bindstoggled = bindstoggled +1
        elseif not double_tap then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "DT")
            renderer.text(((x/2) - 13), ((y/2)+50)+(offset*bindstoggled), 255, 255, 255, 55, "c-", 0, "DT")
            bindstoggled = bindstoggled +1
        end
        if on_shot_aa then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "AA")
            renderer.text(((x/2)), ((y/2)+39)+(offset*bindstoggled), exploitc[1], exploitc[2], exploitc[3], 255, "c-", 0, "AA")
            bindstoggled = bindstoggled +1
        elseif not on_shot_aa then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "AA")
            renderer.text(((x/2)), ((y/2)+39)+(offset*bindstoggled), 255, 255, 255, 55, "c-", 0, "AA")
            bindstoggled = bindstoggled +1
        end
        if contains(ui_get(ref.aa.freestanding[1]), 'Default') then 
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "FS")
            renderer.text(((x/2) + 12), ((y/2)+28)+(offset*bindstoggled), exploitc[1], exploitc[2], exploitc[3], 255, "c-", 0, "FS")
            bindstoggled = bindstoggled +1
        else
            renderer.text(((x/2))+1, ((y/2)+50)+(offset*bindstoggled)+1, 0, 0, 0, a1, "c-", 0, "FS")
            renderer.text(((x/2) + 12), ((y/2)+28)+(offset*bindstoggled), 255, 255, 255, 55, "c-", 0, "FS")
            bindstoggled = bindstoggled +1
        end
    end

    if contains(ui_get(whiteout.visual.indicatortype), "Debug Panel") then
        container_glow(x/200,  y/2 + 15, 165, 50, hotkeyc[1], hotkeyc[2], hotkeyc[3], hotkeyc[4], 1.2, hotkeyc[1], hotkeyc[2], hotkeyc[3])
        renderer.text(x/200 + 5,  y/2 + 20, 255, 255, 255, 255, "Light", 0, ">> whiteout")
        renderer.text(x/200 + 70,  y/2 + 20, hotkeyc[1], hotkeyc[2], hotkeyc[3], 255, "Light", 0, "technology")
        renderer.text(x/200 + 5,  y/2 + 32.5, 255, 255, 255, 255, "Light", 0, ">> user:")
        renderer.text(x/200 + 50,  y/2 + 32.5, hotkeyc[1], hotkeyc[2], hotkeyc[3], 255, "Light", 0, username)
        renderer.text(x/200 + 5,  y/2 + 45, 255, 255, 255, 255, "Light", 0, ">> build:")
        renderer.text(x/200 + 52,  y/2 + 45, hotkeyc[1], hotkeyc[2], hotkeyc[3], 255, "Light", 0, build)
    end
end
--#endregion

--#region hitlogs 
local function add_shot_info(text)
    local shot_info = {}
    shot_info.time = globals.curtime() 
    shot_info.text = text
    table.insert(shot_info_table, shot_info)
end

client.set_event_callback("aim_hit", function (e)

    if not contains(ui_get(whiteout.visual.logs), 'On Screen') then return end

    bt = globals.tickcount() - e.tick -- e.backtrack
    backtrack = bt
    local group = hitbox [e.hitgroup]
    local previous_health = entity.get_prop(e.target, "m_iHealth")
    local empty_string = string.format('Hit %s in the %s (%d health remaining, BT: %s)', entity.get_player_name(e.target), group, previous_health, backtrack)
    add_shot_info(empty_string)
    notify:paint(15, empty_string)
end)

client.set_event_callback("aim_miss", function (e)
    if not contains(ui_get(whiteout.visual.logs), 'On Screen') then return end
    local group = hitbox [e.hitgroup]
    local empty_string = (string.format('Missed %s in the %s due to %s', entity.get_player_name(e.target), group, e.reason)) 
    add_shot_info(empty_string)
    notify:paint(15, empty_string)
end)

client.set_event_callback("aim_hit", function(e)
    if not contains(ui_get(whiteout.visual.logs), 'Chat') then return end
    bt = globals.tickcount() - e.tick -- e.backtrack
    backtrack = bt
    local group = hitbox [e.hitgroup]
    local previous_health = entity.get_prop(e.target, "m_iHealth")

    chat.print(string.format('{red}[whiteout]{white} Hit {red}%s{white} in the {red}%s{white} ({red}%d{white} health remaining, BT: {red}%s{white})', entity.get_player_name(e.target), group, previous_health, backtrack))
end)

client.set_event_callback("aim_miss", function (e)
    if not contains(ui_get(whiteout.visual.logs), 'Chat') then return end
    local group = hitbox [e.hitgroup]
    chat.print(string.format('{red}[whiteout]{white} Missed {red}%s{white} in the {red}%s{white} due to {red}%s{white}', entity.get_player_name(e.target), group, e.reason))
end)

local function ON_BULLET_IMPACT(e)
    if not entity.is_alive(me) then return end 

    if not ui_get(whiteout.master) then return end

    if not contains(ui_get(whiteout.visual.logs), 'On Screen') then return end

    local lx, ly, lz = entity.hitbox_position(me, "head_0")
	local ox, oy, oz = entity.get_prop(me, "m_vecOrigin")

    local dist = 0

    local shooter_id = e.userid
	local shooter_idx = client.userid_to_entindex(shooter_id)

	local ex, ey, ez = entity.get_prop(shooter_idx, "m_vecOrigin")

    if entity.is_enemy(shooter_idx) and not entity.is_dormant(shooter_idx) then
		local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)
		local distance_origin = ((e.y - ey)*ox - (e.x - ex)*oy + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)

		if math.abs(dist) <= ui_get(whiteout.aa.bullet_detection) then
			local s = shot_log[shooter_idx][3]
			s = s + 1
			shot_log[shooter_idx][1][s] = round(globals.curtime(), 1)
			local shot_eye = false

			if shot_log[shooter_idx][1][s] == shot_log[shooter_idx][1][s - 1] then
				return 
			else								
				if math.abs(distance_origin) <= 0.5 then
					shot_eye = true

				end
				shot_log[shooter_idx][3] = s
			end
			
            if dist > 0 then
                shot_log[shooter_idx][2][s] = shot_eye and 0 or 1
                notify:paint(15, "Swapped angle side due to miss [".. math.floor(dist).. "]")
            else
                shot_log[shooter_idx][2][s] = shot_eye and 0 or 2
                
            end
            shot_log[shooter_idx][2][s] = desyncside == 1 and 2 or 1
		end
	end
end

local function ON_PLAYER_HURT(e)
    if not entity.is_alive(me) then return end 

    if not contains(ui_get(whiteout.visual.logs), 'On Screen') then return end

	local victim_entindex, attacker_entindex = client.userid_to_entindex(e.userid), client.userid_to_entindex(e.attacker)

    if entity.is_enemy(attacker_entindex) and victim_entindex == entity.get_local_player() then
        for i=1, #non_weapons do 
            if (e.weapon == non_weapons[i]) then return end
        end

        local s = hit_log[attacker_entindex][5]
        s = s + 1

        hit_log[attacker_entindex][1][s] = round(globals.curtime(), 1)
		hit_log[attacker_entindex][2][s] = desyncside
		hit_log[attacker_entindex][3][s] = victim_entindex
		hit_log[attacker_entindex][4][s] = e.hitgroup
        hit_log[attacker_entindex][5] = s
        notify:paint(15, "Switched angle due to hit")
    end
end

client.set_event_callback('aim_miss', function(e)
    if not contains(ui_get(whiteout.visual.logs), "Console") then return end
    local group = hitbox [e.hitgroup]
    local empty_string = (string.format('Missed %s in the %s due to %s', entity.get_player_name(e.target), group, e.reason)) 

    client.color_log(255, 55, 55, empty_string)
end)

client.set_event_callback("aim_hit", function (e)

    if not contains(ui_get(whiteout.visual.logs), "Console") then return end

    local color = {ui_get(whiteout.visual.colorpicker.desynclog)}

    bt = globals.tickcount() - e.tick -- e.backtrack
    backtrack = bt
    local group = hitbox[e.hitgroup]
    local previous_health = entity.get_prop(e.target, "m_iHealth")
    local empty_string = string.format('Hit %s in the %s (%d health remaining, BT: %s)', entity.get_player_name(e.target), group, previous_health, backtrack)

    client.color_log(color[1], color[2], color[3], empty_string)
end)
--#endregion

--#region menu-visibility
local function menu_callback(e, menu_call)
    local setup = function(list, element, visible)
        for k, v in pairs(list) do
            local active = k == element
            local mode = list[k]

            if type(mode) == "table" then
                for j in pairs(mode) do
                    local set_element = true

                    local yaw = ui.get(mode.yaw)
                    local yaw_jitter = ui.get(mode.yaw_jitter)
                    local body_yaw = ui.get(mode.body_yaw)

                    if yaw == "Off" and (active and j == "yaw_num") then 
                        set_element = false 
                    end
                    if yaw_jitter == "Off" and (active and j == "yaw_jitter_num") then 
                        set_element = false 
                    end

                    ui.set_visible(mode[j], active and visible and set_element and ui_get(whiteout.tabtype) == "Anti-aim" )
                end
            end
        end
    end
    
    local state = ui_get(whiteout.master)
    local region = ui_get(whiteout.tabtype)
    local customaa, roll = contains(ui_get(whiteout.aa.extra), 'Custom anti-aim'), contains(ui_get(whiteout.aa.extra), 'Roll on key')

    multi_exec(ui.set_visible, {
        [whiteout.tabtype] = state,

        [whiteout.aa.jittercondition]                      = state and region == "Anti-aim" and not customaa,
        [whiteout.aa.roll_ab]                              = state and region == "Anti-aim" and roll,
        [whiteout.aa.roll_cb]                              = state and region == "Anti-aim" and roll,
        [whiteout.aa.antibrute_type]                       = state and region == "Anti-aim" and not customaa,
        [whiteout.aa.bullet_detection]                     = state and region == "Anti-aim",
        [whiteout.aa.roll_dd]                              = state and region == "Anti-aim" and ui_get(whiteout.aa.roll_cb) and roll,
        [whiteout.aa.playerstates]                         = state and region == "Anti-aim" and contains(ui_get(whiteout.aa.jittercondition), 'On Playerstate') and not customaa,
        [whiteout.aa.extra]                                = state and region == "Anti-aim",
        [whiteout.aa.rollstates]                           = state and region == "Anti-aim",
        [whiteout.aa.legit]                                = state and region == 'Anti-aim' and contains(ui_get(whiteout.aa.extra), 'Legit anti-aim'),
        [whiteout.aa.legs]                                 = state and region == 'Anti-aim' and contains(ui_get(whiteout.aa.extra), 'Leg Breaker'),

        [lua_import_export_import]                        = state and region == "Anti-aim" and customaa ,
        [lua_import_export_export]                        = state and region == "Anti-aim" and customaa,

        [whiteout.fakelag.dynamic]                         = state and region == 'Rage',
        [whiteout.fakelag.dynamic_type]                    = state and region == 'Rage' and ui_get(whiteout.fakelag.dynamic),
        [whiteout.misc.dt.doubletapboostcheck]             = state and region == "Rage",
        [whiteout.misc.dt.doubletapboostdrop]              = state and region == "Rage" and ui_get(whiteout.misc.dt.doubletapboostcheck),
        [whiteout.misc.dt.doubletapboostcustom]            = state and region == "Rage" and ui_get(whiteout.misc.dt.doubletapboostcheck) and ui_get(whiteout.misc.dt.doubletapboostdrop) == 'Custom', 
        [whiteout.visual.logs]                             = state and region == "Rage",                         

        [whiteout.visual.crosshair.master]                 = state and region == "Visuals",
        [whiteout.visual.indicatortype]                    = state and region == "Visuals" and ui_get(whiteout.visual.crosshair.master),
        [whiteout.visual.debug.debug_label]                = state and region == "Visuals" and contains(ui_get(whiteout.visual.indicatortype), "Debug Panel") and ui_get(whiteout.visual.crosshair.master),
        [whiteout.visual.debug.debug_color]                = state and region == "Visuals" and contains(ui_get(whiteout.visual.indicatortype), "Debug Panel") and ui_get(whiteout.visual.crosshair.master),
        [whiteout.visual.colorpicker.desynclog]            = state and region == "Visuals",
        [whiteout.visual.colorpicker.desync_label]         = state and region == "Visuals", 
        [whiteout.visual.colorpicker.label]                = state and region == "Visuals" and contains(ui_get(whiteout.visual.indicatortype), "Crosshair") and ui_get(whiteout.visual.crosshair.master),
        [whiteout.visual.colorpicker.playerstate]          = state and region == "Visuals" and contains(ui_get(whiteout.visual.indicatortype), "Crosshair") and ui_get(whiteout.visual.crosshair.master),
        [whiteout.visual.colorpicker.name]                 = state and region == "Visuals" and contains(ui_get(whiteout.visual.indicatortype), "Crosshair") and ui_get(whiteout.visual.crosshair.master),
        [whiteout.visual.colorpicker.playerstate_color]    = state and region == "Visuals" and contains(ui_get(whiteout.visual.indicatortype), "Crosshair") and ui_get(whiteout.visual.crosshair.master),
        [whiteout.visual.colorpicker.name_color]           = state and region == "Visuals" and contains(ui_get(whiteout.visual.indicatortype), "Crosshair") and ui_get(whiteout.visual.crosshair.master),
        [whiteout.visual.colorpicker.exploit]              = state and region == "Visuals" and contains(ui_get(whiteout.visual.indicatortype), "Crosshair") and ui_get(whiteout.visual.crosshair.master),
        [whiteout.visual.colorpicker.exploit_color]        = state and region == "Visuals" and contains(ui_get(whiteout.visual.indicatortype), "Crosshair") and ui_get(whiteout.visual.crosshair.master),
        [whiteout.misc.sunsetmode]                         = state and region == "Visuals",
        [whiteout.visual.colorpicker.arrow_color]          = state and region == "Visuals",
        [whiteout.visual.colorpicker.arrow]                = state and region == "Visuals",

        [whiteout.dir.customdir]                           = state and region == "Miscellaneous",
        [whiteout.dir.free]                                = state and region == "Miscellaneous" and ui_get(whiteout.dir.customdir),
        [whiteout.dir.edge]                                = state and region == "Miscellaneous" and ui_get(whiteout.dir.customdir),
        [whiteout.dir.manualback]                          = state and region == "Miscellaneous" and ui_get(whiteout.dir.customdir),
        [whiteout.dir.manualleft]                          = state and region == "Miscellaneous" and ui_get(whiteout.dir.customdir),
        [whiteout.dir.manualright]                         = state and region == "Miscellaneous" and ui_get(whiteout.dir.customdir),
        [whiteout.misc.killsay]                            = state and region == "Miscellaneous",

        [custom.player_states]                            = state and region == "Anti-aim" and customaa,

        --Standing 
        [custom.thing.standing.pitch]                           = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Standing',
        [custom.thing.standing.yawbase]                         = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Standing',
        [custom.thing.standing.yaw]                             = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Standing',
        [custom.thing.standing.yawadd]                          = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Standing',
        [custom.thing.standing.yawjitter]                       = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Standing',
        [custom.thing.standing.yawjitteradd]                    = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Standing',
        [custom.thing.standing.bodyyaw]                         = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Standing',
        [custom.thing.standing.fakeyawlimit]                    = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Standing',
        --Ducking
        [custom.thing.ducking.pitch]                           = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Ducking',
        [custom.thing.ducking.yawbase]                         = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Ducking',
        [custom.thing.ducking.yaw]                             = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Ducking',
        [custom.thing.ducking.yawadd]                          = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Ducking',
        [custom.thing.ducking.yawjitter]                       = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Ducking',
        [custom.thing.ducking.yawjitteradd]                    = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Ducking',
        [custom.thing.ducking.bodyyaw]                         = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Ducking',
        [custom.thing.ducking.fakeyawlimit]                    = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Ducking',
        --Moving
        [custom.thing.moving.pitch]                           = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Moving',
        [custom.thing.moving.yawbase]                         = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Moving',
        [custom.thing.moving.yaw]                             = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Moving',
        [custom.thing.moving.yawadd]                          = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Moving',
        [custom.thing.moving.yawjitter]                       = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Moving',
        [custom.thing.moving.yawjitteradd]                    = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Moving',
        [custom.thing.moving.bodyyaw]                         = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Moving',
        [custom.thing.moving.fakeyawlimit]                    = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Moving',
        --Slow motion
        [custom.thing.slowmotion.pitch]                           = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Slow motion',
        [custom.thing.slowmotion.yawbase]                         = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Slow motion',
        [custom.thing.slowmotion.yaw]                             = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Slow motion',
        [custom.thing.slowmotion.yawadd]                          = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Slow motion',
        [custom.thing.slowmotion.yawjitter]                       = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Slow motion',
        [custom.thing.slowmotion.yawjitteradd]                    = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Slow motion',
        [custom.thing.slowmotion.bodyyaw]                         = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Slow motion',
        [custom.thing.slowmotion.fakeyawlimit]                    = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Slow motion',
        --Jumping
        [custom.thing.jumping.pitch]                           = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Jumping',
        [custom.thing.jumping.yawbase]                         = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Jumping',
        [custom.thing.jumping.yaw]                             = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Jumping',
        [custom.thing.jumping.yawadd]                          = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Jumping',
        [custom.thing.jumping.yawjitter]                       = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Jumping',
        [custom.thing.jumping.yawjitteradd]                    = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Jumping',
        [custom.thing.jumping.bodyyaw]                         = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Jumping',
        [custom.thing.jumping.fakeyawlimit]                    = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'Jumping',
        --on use
        [custom.thing.on_e.pitch]                           = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'On Use',
        [custom.thing.on_e.yawbase]                         = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'On Use',
        [custom.thing.on_e.yaw]                             = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'On Use',
        [custom.thing.on_e.yawadd]                          = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'On Use',
        [custom.thing.on_e.yawjitter]                       = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'On Use',
        [custom.thing.on_e.yawjitteradd]                    = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'On Use',
        [custom.thing.on_e.bodyyaw]                         = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'On Use',
        [custom.thing.on_e.fakeyawlimit]                    = state and region == "Anti-aim" and customaa and ui_get(custom.player_states) == 'On Use',

    })
end

local function menu_visibility()
    menu_callback()
    SetTableVisibility({ref.aa.enabled, ref.aa.pitch, ref.aa.yaw_base, ref.aa.yaw[1], ref.aa.yaw[2], ref.aa.yaw_jitter[1], ref.aa.yaw_jitter[2], ref.aa.body_yaw[1], ref.aa.body_yaw[2], ref.aa.freestand_bodyyaw, ref.aa.edgeyaw, ref.aa.freestanding[1], ref.aa.freestanding[2], ref.aa.roll}, not ui_get(whiteout.master))
end

local function shutdown()
    --SetTableVisibility({aa.enabled, aa.pitch, aa.yawbase, aa.yaw[1], aa.yaw[2], aa.yawjitter[1], aa.yawjitter[2], aa.byaw[1], aa.byaw[2], aa.freestanding_byaw, aa.fakeyaw, aa.edgeyaw, aa.freestanding[1], aa.roll, aa.freestanding[2]}, true)
    SetTableVisibility({ref.aa.enabled, ref.aa.pitch, ref.aa.yaw_base, ref.aa.yaw[1], ref.aa.yaw[2], ref.aa.yaw_jitter[1], ref.aa.yaw_jitter[2], ref.aa.body_yaw[1], ref.aa.body_yaw[2], ref.aa.freestand_bodyyaw, ref.aa.edgeyaw, ref.aa.freestanding[1], ref.aa.freestanding[2], ref.aa.roll}, true)
end
--#endregion

--#region callback
local callback = client.set_event_callback

callback("run_command", best_target)
callback('run_command', hotkey_setup)
callback('run_command', misc_features)

callback('setup_command', antiaim)
callback("setup_command", COMMAND_HANDLER)

callback("paint_ui", menu_visibility)
callback("shutdown", shutdown)
callback('paint', crosshair_indicators)

callback('bullet_impact', ON_BULLET_IMPACT)
callback("player_hurt", ON_PLAYER_HURT)
callback("player_death", on_player_death)
--#endregion