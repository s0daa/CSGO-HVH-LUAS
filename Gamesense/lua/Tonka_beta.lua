-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local anti_aim = require 'gamesense/antiaim_funcs' or error("Failed to load antiaim_funcs | https://gamesense.pub/forums/viewtopic.php?id=29665")
local http = require "gamesense/http" or error("Failed to load http | https://gamesense.pub/forums/viewtopic.php?id=19253")
--local discord = require("gamesense/discord_webhooks") or error("Failed to load discord | https://gamesense.pub/forums/viewtopic.php?id=24793")
local steamworks = require("gamesense/steamworks") or error("Failed to load steamworks | https://gamesense.pub/forums/viewtopic.php?id=26526")
local surface = require("gamesense/surface") or error("Failed to load surface | https://gamesense.pub/forums/viewtopic.php?id=18793")
local bit = require("bit")
local bitband = bit.band
local ffi = require 'ffi'
local vector = require ('vector') or error("Failed to load vector library")
local images = require("gamesense/images") or error("Failed to load images | https://gamesense.pub/forums/viewtopic.php?id=22917")
local clipboard = require("gamesense/clipboard") or error("Failed to load clipboard | https://gamesense.pub/forums/viewtopic.php?id=28678")
local base64 = require("gamesense/base64") or error("Failed to load base64 | https://gamesense.pub/forums/viewtopic.php?id=21619")


lua_name = "TONKA"
--lua_version = "DEV"
lua_enable = ui.new_checkbox("AA","Anti-aimbot angles","Enable \aB4711BFFTonka.lua\aFFFFFFB6")
lua_tab = ui.new_combobox("AA","Anti-aimbot angles","Lua tab",{"Anti-aimbot angles","Aimbot","Indicators","Misc","Settings"})
local obex_data = obex_fetch and obex_fetch() or {username = 'preto', build = 'dev'}

-----------------------------------------------------
local main = {}
local gui = {}
local funcs = {}

funcs.ui = {}

function funcs.ui:str_to_sub(input, sep)
    local t = {}
    for str in string.gmatch(input, "([^"..sep.."]+)") do
        t[#t + 1] = string.gsub(str, "\n", "")
    end
    return t
end


function funcs.ui:arr_to_string(arr)
	arr = ui.get(arr)
	local str = ""
	for i=1, #arr do
		str = str .. arr[i] .. (i == #arr and "" or ",")
	end

	if str == "" then
		str = "-"
	end

	return str
end


function funcs.ui:to_boolean(str)
    if str == "true" or str == "false" then
        return (str == "true")
    else
        return str
    end
end

function funcs.ui:table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
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

function main:ui(register,need_export,... )
    local number_ = register
    if type(number_) == 'number' then
        table.insert(gui.callback,number_)
    end

    if need_export then
        if type(number_) == 'number' then
            table.insert(gui.export[type(ui.get(number_))],number_)
        end
    end

    return number_
end

gui.callback = {}
gui.export = {
    ['number'] = {},
    ['boolean'] = {},
    ['table'] = {},
    ['string'] = {}
}

-----------------------------------------------------

--local create_database = database.read("version_z") or {}

local var = {
    p_states = {"Override","Standing", "Moving", "Jumping", "C-Jumping", "Slow Walking","Crouching"},
    state_to_idx = {["Standing"] = 2, ["Moving"] = 3, ["Jumping"] = 4, ["C-Jumping"] = 5, ["Slow Walking"] = 6,["Crouching"] = 7,["Override"] = 1},
    p_state = 1,
    active_i = 1
}


gui.menu = 
{
    stop_intro = main:ui(ui.new_checkbox("AA","Anti-aimbot angles","Freeze intro"),true),
    info_panel = main:ui(ui.new_multiselect("AA","Anti-aimbot angles","Panels",{"Local info panel","Watermark"}),true),
    enable_indicators = main:ui(ui.new_checkbox("AA","Anti-aimbot angles","Enable indicators \aFF000092(DEFAULT)\aFFFFFFB6"),true),
    fix_on_shot = main:ui(ui.new_checkbox("AA","Anti-aimbot angles","Fix \aFFAD00FFon shot\aFFFFFFB6"),true),
    force_defensive = main:ui(ui.new_hotkey("AA","Anti-aimbot angles","Force \a96C83CFFdefensive\aFFFFFFB6",false)),
    sun_modes = main:ui(ui.new_checkbox("AA","Anti-aimbot angles","\aFFAD00FFSunset shadows\aFFFFFFB6"),true),
    defensive_dt_indicator = main:ui(ui.new_checkbox("AA","Anti-aimbot angles","\a96C83CFFDefensive\aFFFFFFB6 indicator"),true),
    min_dmg_indicator = main:ui(ui.new_checkbox("AA","Anti-aimbot angles","Minimum damage indicator"),true),
    min_dmg_slider = main:ui(ui.new_slider("AA", "Anti-aimbot angles", "Slider X", -20, 20, 0),true),
    manual_indicators = main:ui(ui.new_checkbox("AA","Anti-aimbot angles","Manual anti-aim indicators"),true),
    manua_color = main:ui(ui.new_color_picker("AA","Anti-aimbot angles", 'Manual color', 255, 255, 255, 255),true),
    manual_left = main:ui(ui.new_hotkey("AA", "Anti-aimbot angles", "Manual left",false),false),
    manual_right = main:ui(ui.new_hotkey("AA", "Anti-aimbot angles", "Manual right",false),false),
    manual_reset = main:ui(ui.new_hotkey("AA", "Anti-aimbot angles", "Reset angles",false),false),
    kill_say = main:ui(ui.new_checkbox("AA","Anti-aimbot angles","Kill say"),true),
    avatar_esp = main:ui(ui.new_checkbox("AA", "Anti-aimbot angles", "Avatars"),true),
    leg_breaker = main:ui(ui.new_checkbox("AA","Anti-aimbot angles","Leg switcher"),true),
    lc_animations = main:ui(ui.new_multiselect("AA","Anti-aimbot angles","Local animations",{"Static legs","Pitch 0 on land"}),true),
    anti_knife = main:ui(ui.new_combobox("AA","Anti-aimbot angles","Anti-knife",{"Off","Static","Small jitter"}),true),
    filled_box_enable = main:ui(ui.new_checkbox("AA","Anti-aimbot angles","Filled box esp"),true),
    fil = ui.new_label("AA","Anti-aimbot angles","Fill color"),
    filled_color = main:ui(ui.new_color_picker("AA","Anti-aimbot angles", 'Filled color', 50, 50, 50, 170,false),true),
    out = ui.new_label("AA","Anti-aimbot angles","Outline color"),
    outline = main:ui(ui.new_color_picker("AA","Anti-aimbot angles", 'Outline color', 255, 255, 255, 255,false),true),
}

gui.menu.custom = {}
gui.menu.custom[0] = {
    player_state = main:ui(ui.new_combobox("AA", "Anti-aimbot angles", "\aB4711BFFAnti-aim\aFFFFFFB6 state", var.p_states),true),
}

for i = 1, 7 do
    gui.menu.custom[i] = {
        enable = main:ui(ui.new_checkbox("AA", "Anti-aimbot angles", "Enable \aB4711BFF" .. var.p_states[i] .. "\aFFFFFFB6 anti-aim"),true),
        pitch = main:ui(ui.new_combobox("AA","Anti-aimbot angles","Pitch\n" .. var.p_states[i],{"Off", "Default", "Up", "Down", "Minimal", "Random"}),true),
        yawbase = main:ui(ui.new_combobox("AA","Anti-aimbot angles","Yaw base\n" .. var.p_states[i],{"Local view", "At targets"})),
        yaw = main:ui(ui.new_combobox("AA","Anti-aimbot angles","Yaw\n" .. var.p_states[i],{"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),true),
        yawadd = main:ui(ui.new_slider("AA", "Anti-aimbot angles", "Yaw add left\n" .. var.p_states[i], -180, 180, 0),true),
        yawadd_right = main:ui(ui.new_slider("AA", "Anti-aimbot angles", "Yaw add right\n" .. var.p_states[i], -180, 180, 0),true),
        yawjitter = main:ui(ui.new_combobox( "AA","Anti-aimbot angles","Yaw jitter\n" .. var.p_states[i],{"Off", "Offset", "Center", "Random"}),true),
        yawjitteradd = main:ui(ui.new_slider("AA", "Anti-aimbot angles", "\nYaw jitter add" .. var.p_states[i], -180, 180, 0),true),
        gs_bodyyaw = main:ui(ui.new_combobox( "AA","Anti-aimbot angles","Body yaw\n GS" .. var.p_states[i],{"Off", "Opposite", "Jitter", "Static","Jitter 2","Anti-bruteforce"}),true),
        gs_bodyyawadd = main:ui(ui.new_slider("AA", "Anti-aimbot angles", "\nBody yaw add" .. var.p_states[i], -180, 180, 0),true),
        freestand_bodyya = main:ui(ui.new_checkbox("AA", "Anti-aimbot angles", "Freestanding body yaw\n" .. var.p_states[i]),true),
        fakeyawlimit = main:ui(ui.new_slider("AA", "Anti-aimbot angles","Fake yaw limit left\n" .. var.p_states[i], 0, 60, 60,true,"°"),true),
		fakeyawlimitr = main:ui(ui.new_slider("AA", "Anti-aimbot angles","Fake yaw limit right\n" .. var.p_states[i], 0, 60, 60,true,"°"),true),
        --fakeyawlimit = ui.new_slider("AA", "Anti-aimbot angles", "Fake yaw limit\n" .. var.p_states[i], 0, 60, 60),
        edgeyaw = main:ui(ui.new_checkbox("AA", "Anti-aimbot angles", "Edge yaw\n" .. var.p_states[i]),true),
        roll = main:ui(ui.new_slider("AA", "Anti-aimbot angles", "Roll\n" .. var.p_states[i], -50, 50, 0),true),
        freestanding = main:ui(ui.new_multiselect("AA", "Anti-aimbot angles", "Freestanding\n" .. var.p_states[i], {"Default"}),true),
        freestanding_key = main:ui(ui.new_hotkey("AA", "Anti-aimbot angles", "Freestanding key\n" .. var.p_states[i],true),false),

    
    }
end

local menu_reference =
{
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
    roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
    yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    fakeyawlimit = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    maxprocticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    dtholdaim = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks_holdaim"),
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
    forcebaim = ui.reference("RAGE", "Other", "Force body aim"),
    player_list = ui.reference("PLAYERS", "Players", "Player list"),
    reset_all = ui.reference("PLAYERS", "Players", "Reset all"),
    apply_all = ui.reference("PLAYERS", "Adjustments", "Apply to all"),
    load_cfg = ui.reference("Config", "Presets", "Load"),
    fl_limit = ui.reference("AA", "Fake lag", "Limit"),
    dt_limit = ui.reference("RAGE", "Other", "Double tap fake lag limit"),
    quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
    yawjitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    bodyyaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    os = {ui.reference("AA", "Other", "On shot anti-aim")},
    slow = {ui.reference("AA", "Other", "Slow motion")},
    dt = {ui.reference("RAGE", "Other", "Double tap")},
    ps = {ui.reference("RAGE", "Other", "Double tap")},
    fakelag = {ui.reference("AA", "Fake lag", "Limit")},
    leg_movement = ui.reference("AA", "Other", "Leg movement"),
}

local function get_velocity(player)
    local x, y, z = entity.get_prop(player, "m_vecVelocity")
    if x == nil then
        return
    end
    return math.sqrt(x * x + y * y + z * z)
end

local aa_value = 0

change = false

local function change_values(side_a,side_b)

    change = not change

    if change == true then
        return side_a
    else
        return side_b
    end
end

local miss_stage = 0
brute = {
    missed_shots = {},
    last_miss = 0,
} 

brute.reset = function()
	brute.last_miss = 0
	brute.missed_shots = { }
    miss_stage = 0
end

stages_bf = ui.new_slider("AA","Anti-aimbot angles","Anti \aB4711BFFbruteforce\aFFFFFFB6 stages amout",1,10,5)

brute_force_menu = {}
for b = 1,10 do
   -- local get_slider = ui.get(stages_bf)
    brute_force_menu[b] = {bf_angle = ui.new_slider("AA","Anti-aimbot angles","Anti \aB4711BFFbruteforce\aFFFFFFB6 stages [\aB4711BFF" .. b .. "\aFFFFFFB6]",-60,60,0),} 
end


to_work = "default"
local function brute_impact(e)


    if to_work == "no_work" then return end

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local shooter_id = e.userid
	local shooter = client.userid_to_entindex(shooter_id)

	if not entity.is_enemy(shooter) or entity.is_dormant(shooter) then return end

	local lx, ly, lz = entity.hitbox_position(me, "head_0")
	
	local ox, oy, oz = entity.get_prop(me, "m_vecOrigin")
	local ex, ey, ez = entity.get_prop(shooter, "m_vecOrigin")

	local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)
    --print("xd")
	
	if math.abs(dist) <= 35 and globals.curtime() - brute.last_miss > 0.015 then
        brute.last_miss = globals.curtime()
    
        if brute.missed_shots[shooter] == nil then
            brute.missed_shots[shooter] = 1
            miss_stage = 1
        elseif brute.missed_shots[shooter] >= 0 and brute.missed_shots[shooter] < ui.get(stages_bf) then
                brute.missed_shots[shooter] = brute.missed_shots[shooter] + 1
                miss_stage =  miss_stage + 1
        elseif brute.missed_shots[shooter] >= ui.get(stages_bf) then
            brute.missed_shots[shooter] = 1
           miss_stage = 1
        end
        print("anti bruteforce changed angle | will reset on the end of this round")
	end
end

client.set_event_callback("bullet_impact", function(e)
    brute_impact(e)
end)

last_press = 0
local aa_dir = "reset"
function manual_aa()

    local plocal = entity.get_local_player()
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and 1 or -1
       
        if ui.get(gui.menu.manual_right) and last_press + 0.2 < globals.curtime() then
            aa_dir = aa_dir == "right" and "reset" or "right"
            last_press = globals.curtime()
        elseif ui.get(gui.menu.manual_left) and last_press + 0.2 < globals.curtime() then
            aa_dir = aa_dir == "left" and "reset" or "left"
            last_press = globals.curtime()
        elseif ui.get(gui.menu.manual_reset) and last_press + 0.2 < globals.curtime() then
            aa_dir = "reset"
            last_press = globals.curtime()
        elseif last_press > globals.curtime() then
            last_press = globals.curtime()
        end
       -- ui.set(menu_reference.yaw[2], aa_dir)
       
end

anti_knife_dist = function(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end

function anti_knife()
    if ui.get(gui.menu.anti_knife) ~= "Off" and ui.get(lua_enable) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
        local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")

        for i = 1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])

            if entity.get_classname(weapon) == "CKnife" and distance <= 220 then
               -- local eye_x, eye_y, eye_z = client.eye_position()
               local lx, ly, lz = entity.hitbox_position(entity.get_local_player(), 0)
               local hitbox_x, hitbox_y, hitbox_z = entity.hitbox_position(players[i], 0)
               local fraction, entindex_hit = client.trace_line(players[i], lx, ly, lz, hitbox_x, hitbox_y, hitbox_z)

                if entindex_hit == entity.get_local_player() then
                    if ui.get(gui.menu.anti_knife) == "Small jitter" then
                        ui.set(menu_reference.yawbase,"At targets")
                        ui.set(yaw_slider,180)
                        ui.set(menu_reference.yawjitter[1],"Off")
                        ui.set(menu_reference.yawjitter[2],60)
                        ui.set(menu_reference.bodyyaw[1],"Jitter")
                        ui.set(menu_reference.bodyyaw[2],0)
                        ui.set(pitch, "Default")
                    end
    
                    if ui.get(gui.menu.anti_knife) == "Static" then
                        ui.set(menu_reference.yawbase,"At targets")
                        ui.set(yaw_slider,180)
                        ui.set(pitch, "Off")
                        ui.set(menu_reference.yawjitter[1],"Off")
                        ui.set(menu_reference.yawjitter[2],0)
                        ui.set(menu_reference.bodyyaw[1],"Off")
                        ui.set(menu_reference.bodyyaw[2],0)
                    end
                end
            end
        end
    end
end


-- remove code from here and fix 
function set_custom_settings(c)
            
            local plocal = entity.get_local_player()
            local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
            local side = bodyyaw > 0 and 1 or -1
        
            local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")
        
            local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
            local lp_vel = get_velocity(entity.get_local_player())
            local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
            local p_slow = ui.get(menu_reference.slow[1]) and ui.get(menu_reference.slow[2])

            manual_aa()
        
           
            if c.in_duck == 1 and on_ground then
                var.p_state = 7
            elseif c.in_duck == 1 and not on_ground then
                var.p_state = 5
            elseif not on_ground then
                var.p_state = 4
            elseif p_slow then
                var.p_state = 6
            elseif p_still then
                var.p_state = 2
            elseif not p_still then
                var.p_state = 3
            end

                ui.set(menu_reference.enabled, ui.get(gui.menu.custom[var.p_state].enable))
                ui.set(menu_reference.pitch, ui.get(gui.menu.custom[var.p_state].pitch))
                ui.set(menu_reference.yawbase, ui.get(gui.menu.custom[var.p_state].yawbase))
                ui.set(menu_reference.yaw[1], ui.get(gui.menu.custom[var.p_state].yaw))
                --ui.set(menu_reference.yaw[2], (side == 1 and ui.get(gui.menu.custom[var.p_state].yawadd) or ui.get(gui.menu.custom[var.p_state].yawadd_right)))
                ui.set(menu_reference.yawjitter[1], ui.get(gui.menu.custom[var.p_state].yawjitter))
                ui.set(menu_reference.yawjitter[2], ui.get(gui.menu.custom[var.p_state].yawjitteradd))

                if ui.get(gui.menu.custom[var.p_state].gs_bodyyaw) == "Anti-bruteforce" then
                    to_work = "work"
                    if miss_stage <= 0 then
                        ui.set(menu_reference.bodyyaw[1], "Jitter")
                        ui.set(menu_reference.bodyyaw[2], 0)
                       -- print(string.format("stage 2: %s",miss_stage))
                    elseif miss_stage > 0 then
                        ui.set(menu_reference.bodyyaw[1], "Static")
                        ui.set(menu_reference.bodyyaw[2], ui.get(brute_force_menu[miss_stage].bf_angle))
                       -- print(string.format("stage 2: %s",miss_stage))
                    end
                elseif ui.get(gui.menu.custom[var.p_state].gs_bodyyaw) == "Jitter 2" then
                    to_work = "no_work"
                     ui.set(menu_reference.bodyyaw[1], "Jitter")
                        ui.set(menu_reference.bodyyaw[2], 0)
                else
                    to_work = "no_work"
                    ui.set(menu_reference.bodyyaw[1], ui.get(gui.menu.custom[var.p_state].gs_bodyyaw))
                    ui.set(menu_reference.bodyyaw[2], ui.get(gui.menu.custom[var.p_state].gs_bodyyawadd))
                end

                ui.set(menu_reference.fakeyawlimit, ui.get(gui.menu.custom[var.p_state].fakeyawlimit))
                ui.set(menu_reference.fsbodyyaw, ui.get(gui.menu.custom[var.p_state].freestand_bodyya))
                ui.set(menu_reference.roll, ui.get(gui.menu.custom[var.p_state].roll))
                ui.set(menu_reference.edgeyaw, ui.get(gui.menu.custom[var.p_state].edgeyaw))
                ui.set(menu_reference.freestand[1], ui.get(gui.menu.custom[var.p_state].freestanding))

                if bodyyaw > 0 then
                    ui.set(menu_reference.fakeyawlimit, ui.get(gui.menu.custom[var.p_state].fakeyawlimitr))
                elseif bodyyaw < 0 then
                    ui.set(menu_reference.fakeyawlimit,ui.get(gui.menu.custom[var.p_state].fakeyawlimit))
                end
            

                if ui.get(gui.menu.custom[var.p_state].freestanding_key) then
                    ui.set(menu_reference.freestand[2],"Always On")
                else
                    ui.set(menu_reference.freestand[2],"Toggle")
                end

                if aa_dir == "right" then
                    ui.set(menu_reference.yaw[2],90)
                elseif aa_dir == "left" then
                    ui.set(menu_reference.yaw[2],-90)
                elseif aa_dir == "reset" then
                    ui.set(menu_reference.yaw[2], (side == 1 and ui.get(gui.menu.custom[var.p_state].yawadd) or ui.get(gui.menu.custom[var.p_state].yawadd_right)))
                end

            if not ui.get(gui.menu.custom[var.p_state].enable) then
                ui.set(menu_reference.enabled, ui.get(gui.menu.custom[1].enable))
                ui.set(menu_reference.pitch, ui.get(gui.menu.custom[1].pitch))
                ui.set(menu_reference.yawbase, ui.get(gui.menu.custom[1].yawbase))
                ui.set(menu_reference.yaw[1], ui.get(gui.menu.custom[1].yaw))
              --  ui.set(menu_reference.yaw[2], (side == 1 and ui.get(gui.menu.custom[1].yawadd) or ui.get(gui.menu.custom[1].yawadd_right)))
                ui.set(menu_reference.yawjitter[1], ui.get(gui.menu.custom[1].yawjitter))
                ui.set(menu_reference.yawjitter[2], ui.get(gui.menu.custom[1].yawjitteradd))

                if ui.get(gui.menu.custom[1].gs_bodyyaw) == "Anti-bruteforce" then
                    to_work = "work"
                    if miss_stage <= 0 then
                        ui.set(menu_reference.bodyyaw[1], "Jitter")
                        ui.set(menu_reference.bodyyaw[2], 0)
                       -- print(string.format("stage 2: %s",miss_stage))
                    elseif miss_stage > 0 then
                        ui.set(menu_reference.bodyyaw[1], "Static")
                        ui.set(menu_reference.bodyyaw[2], ui.get(brute_force_menu[miss_stage].bf_angle))
                       -- print(string.format("stage 2: %s",miss_stage))
                    end
                elseif ui.get(gui.menu.custom[1].gs_bodyyaw) == "Jitter 2" then
                    to_work = "no_work"
                     ui.set(menu_reference.bodyyaw[1], "Jitter")
                        ui.set(menu_reference.bodyyaw[2], 0)
                else
                    to_work = "no_work"
                    ui.set(menu_reference.bodyyaw[1], ui.get(gui.menu.custom[1].gs_bodyyaw))
                    ui.set(menu_reference.bodyyaw[2], ui.get(gui.menu.custom[1].gs_bodyyawadd))
                end

                ui.set(menu_reference.fakeyawlimit, ui.get(gui.menu.custom[1].fakeyawlimit))
                ui.set(menu_reference.fsbodyyaw, ui.get(gui.menu.custom[1].freestand_bodyya))
                ui.set(menu_reference.roll, ui.get(gui.menu.custom[1].roll))
                ui.set(menu_reference.edgeyaw, ui.get(gui.menu.custom[1].edgeyaw))
                ui.set(menu_reference.freestand[1], ui.get(gui.menu.custom[1].freestanding))

                if bodyyaw > 0 then
                    ui.set(menu_reference.fakeyawlimit, ui.get(gui.menu.custom[1].fakeyawlimitr))
                elseif bodyyaw < 0 then
                    ui.set(menu_reference.fakeyawlimit,ui.get(gui.menu.custom[1].fakeyawlimit))
                end
             

               if ui.get(gui.menu.custom[1].freestanding_key) then
                ui.set(menu_reference.freestand[2],"Always On")
               else
                ui.set(menu_reference.freestand[2],"Toggle")
               end

               if aa_dir == "right" then
                ui.set(menu_reference.yaw[2],90)
               elseif aa_dir == "left" then
                ui.set(menu_reference.yaw[2],-90)
               elseif aa_dir == "reset" then
                ui.set(menu_reference.yaw[2], (side == 1 and ui.get(gui.menu.custom[1].yawadd) or ui.get(gui.menu.custom[1].yawadd_right)))
               end
            end

            anti_knife()
end

local mr,mg,mb,ma = 100,100,100,255
local mar,mag,mab,maa = 100,100,100,255

function set_og_menu(state)
    ui.set_visible(menu_reference.enabled,state)
    ui.set_visible(menu_reference.pitch, state)
    ui.set_visible(menu_reference.roll, state)
    ui.set_visible(menu_reference.yawbase, state)
    ui.set_visible(menu_reference.yaw[1], state)
    ui.set_visible(menu_reference.yaw[2], state)
    ui.set_visible(menu_reference.yawjitter[1], state)
    ui.set_visible(menu_reference.yawjitter[2], state)
    ui.set_visible(menu_reference.bodyyaw[1], state)
    ui.set_visible(menu_reference.bodyyaw[2], state)
    ui.set_visible(menu_reference.freestand[1], state)
    ui.set_visible(menu_reference.freestand[2], state)
    ui.set_visible(menu_reference.fakeyawlimit, state)
    ui.set_visible(menu_reference.fsbodyyaw, state)
    ui.set_visible(menu_reference.edgeyaw, state)
end

indicators_spacing = 0

-- fix defensive indicator (featuring simtime and tickcount)

function indicators()
    X,Y = client.screen_size()
    indicators_spacing = 0

    if not ui.get(lua_enable) then return end

    if ui.get(gui.menu.min_dmg_indicator) then
        damage = menu_reference.minimum_damage
        renderer.text(X / 2 + ui.get(gui.menu.min_dmg_slider), Y / 2 - 12, 255, 255, 255, 255,"c",0,ui.get(damage))
    end
    
    if ui.get(gui.menu.enable_indicators) then

        if not entity.is_alive(entity.get_local_player()) then return end

        renderer.text(X / 2, Y / 2 + 12, 225, 198, 153, 255,"-c",0,lua_name)

        state_in_upper = string.upper(var.p_states[var.p_state])
        renderer.text(X / 2, Y / 2 + 20, 255, 255, 255, 255,"-c",0,"-" .. state_in_upper .. "-")
        indicators_spacing = indicators_spacing + 8

        if to_work == "work" and miss_stage > 0 then    
            renderer.text(X / 2, Y / 2 + 20 + indicators_spacing, 255, 255, 255, 255,"-c",0,"BRUTE [" .. miss_stage .. "]")
            indicators_spacing = indicators_spacing + 8
        end

        if ui.get(menu_reference.dt[1]) and ui.get(menu_reference.dt[2]) and anti_aim.get_double_tap() then
            renderer.text(X / 2, Y / 2 + 20 + indicators_spacing, 255, 255, 255, 255,"-c",0,"DT")
            indicators_spacing = indicators_spacing + 8
        elseif ui.get(menu_reference.dt[1]) and ui.get(menu_reference.dt[2]) and not anti_aim.get_double_tap() then
            renderer.text(X / 2, Y / 2 + 20 + indicators_spacing, 150, 150, 150, 255,"-c",0,"DT")
            indicators_spacing = indicators_spacing + 8
        end
    
        if ui.get(menu_reference.dt[1]) and ui.get(menu_reference.dt[2]) and ui.get(menu_reference.os[2]) and ui.get(menu_reference.os[1]) then
            renderer.text(X / 2, Y / 2 + 20 + indicators_spacing, 150, 150, 150, 255,"-c",0,"HS")
            --renderer.text(X / 2 + 1, Y / 2 + 8 + indicators_spacing , 0, 0, 0, 255,"+c",0,"_")
            indicators_spacing = indicators_spacing + 8
        elseif ui.get(menu_reference.dt[1]) and not ui.get(menu_reference.dt[2]) and ui.get(menu_reference.os[1]) and ui.get(menu_reference.os[2]) and ui.get(menu_reference.os[1]) then
            renderer.text(X / 2, Y / 2 + 20 + indicators_spacing , 255, 255, 255, 255,"-c",0,"HS")
            indicators_spacing = indicators_spacing + 8
        end
    end

    if ui.get(gui.menu.manual_indicators) then

        local nr,ng,nb,na = ui.get(gui.menu.manua_color)

        if aa_dir == "right" then
            mar,mag,mab,maa = nr,ng,nb,na
            mr,mg,mb,ma = 50,50,50,135
        elseif aa_dir == "left" then
            mar,mag,mab,maa = 50,50,50,135
            mr,mg,mb,ma = nr,ng,nb,na
        elseif aa_dir == "reset" then
            mr,mg,mb,ma = 50,50,50,135
            mar,mag,mab,maa = 50,50,50,135
        end
    
        renderer.triangle(X / 2 + 35, Y / 2 - 5, X / 2 + 35 ,Y / 2 + 5, X / 2 + 50,Y / 2, mar,mag,mab,135)
        renderer.triangle(X / 2 - 35, Y / 2 - 5, X / 2 - 35 ,Y / 2 + 5, X / 2 - 50,Y / 2, mr,mg,mb,135)
    end

    if ui.get(gui.menu.sun_modes) then --need to remake when off !! ! ! !  !
        local sun = entity.get_all('CCascadeLight')[1]
        if sun then
            entity.set_prop(sun, 'm_envLightShadowDirection',180, 180, -111)
        end
        local sv_skyname = cvar.sv_skyname

    
       -- sv_skyname:set_string("sky_csgo_night02")
    else
        local sun = entity.get_all('CCascadeLight')[1]
        if sun then
            entity.set_prop(sun, 'm_envLightShadowDirection',68,-180,-180)
        end
        local sv_skyname = cvar.sv_skyname

    
       -- sv_skyname:set_string("sky_dust")
    end

    if ui.get(gui.menu.avatar_esp) then  
        

        if obex_data.build == "User" then return end

        local player = entity.get_players(true)
        for i = 1, #player do
            local players = player[i]
            local bounding_box = {entity.get_bounding_box(players)}
           
            if bounding_box[1] == nil or bounding_box[2] == nil or bounding_box[3] == nil or bounding_box[4] == nil then return end
    
            local steamidplayers = entity.get_steam64(players)
            local avatar = images.get_steam_avatar(steamidplayers)
    
            local player_name = entity.get_player_name(players)
    
            local w,y = renderer.measure_text(nil,player_name)

            local get_w = 0
    
            if avatar == nil then return end

            

            avatar:draw(w > 130 and bounding_box[1] - (60) or  bounding_box[1] - (w / 1.5), bounding_box[2] - 16 ,nil,15)
        end
    end
end

function fix_on_shot()
    if ui.get(gui.menu.fix_on_shot) then
        if ui.get(menu_reference.os[2]) and ui.get(menu_reference.os[1]) and ui.get(menu_reference.fakeduck) then
             ui.set(menu_reference.fakelag[1],15)
        elseif ui.get(menu_reference.os[2]) and ui.get(menu_reference.os[1]) then
            ui.set(menu_reference.fakelag[1],1)
        elseif not ui.get(menu_reference.os[2]) then
            ui.set(menu_reference.fakelag[1],15)
        end
    end
end

update_dt = 0
function force_defensive(cmd)
    if ui.get(gui.menu.force_defensive) and update_dt + 0.2 < globals.curtime() then
        cmd.force_defensive = true
        update_dt = globals.curtime()
    end
end

local function normalize_yaw(yaw)
    while yaw > 180 do
        yaw = yaw - 360
    end
    while yaw < -180 do
        yaw = yaw + 360
    end
    return yaw
end


local function calc_shit(xdelta, ydelta)
    if xdelta == 0 and ydelta == 0 then
        return 0
    end

    return math.deg(math.atan2(ydelta, xdelta))
end

bestenemy = 0
local function get_nearest_enemy(plocal)
    local lx, ly, lz = client.eye_position()
    local view_x, view_y, roll = client.camera_angles()

    local bestenemy = nil
    local enemies = entity.get_players(true)
    local fov = 180
    for i = 1, #enemies do
        local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
        local cur_fov = math.abs(normalize_yaw(calc_shit(lx - cur_x, ly - cur_y) - view_y + 180))
        if cur_fov < fov then
            fov = cur_fov
            bestenemy = enemies[i]
        end
    end

    return bestenemy
end

local function clamp(min, max, value)
    if value > max then
        return max
    elseif value < min then
        return min
    else
        return value
    end
end


local previous_desync = 0
local animation_freq = 35 

--if previous_desync > real_desync_delta then
           
   -- previous_desync = previous_desync - (animation_freq * globals.absoluteframetime())
--else
    --previous_desync = previous_desync + (animation_freq * globals.absoluteframetime())
--end

function info_panel()

    if not ui.get(lua_enable) then return end

    X,Y = client.screen_size()

    if table_contains(ui.get(gui.menu.info_panel),"Local info panel") then

        local target_name = entity.get_player_name(get_nearest_enemy(entity.get_local_player()))

        local by = 0
        if get_nearest_enemy(entity.get_local_player()) ~= nil then
            by = math.floor(entity.get_prop(get_nearest_enemy(entity.get_local_player()), "m_flPoseParameter", 11 ) * 120 - 60)
        else
            by = 0
        end

        renderer.gradient(X - X ,Y / 2 - 15, 120,86, 0, 0, 0, 140, 0, 0, 0, 0, true)
        renderer.text(X - X + 2,Y / 2 - 11,255,255,255,255,"",0,"-> " .. lua_name .. " <-")
        renderer.text(X - X + 2,Y / 2 + 2,255,255,255,255,"",0,string.format("-> target (%s) (%sº)",target_name,by))

    
        local who_knows =  math.floor(math.min(60, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60)))

        
        --previous_desync = 0

        local real_desync_delta = 0
        if who_knows < 0 then
            real_desync_delta = -who_knows
        else
            real_desync_delta = who_knows
        end

        if not entity.is_alive(entity.get_local_player()) then
            real_desync_delta = 0
        end

        if previous_desync > real_desync_delta then
             previous_desync = previous_desync - (animation_freq * globals.frametime())
         else
             previous_desync = previous_desync + (animation_freq * globals.frametime())
         end
    
        desync_bar = previous_desync * 60 / 60
        renderer.text(X - X + 2,Y / 2 + 16,255,255,255,255,"",0,"-> desync (" .. string.format("%02dº", previous_desync) .. ")")
    
       
        renderer.rectangle(X - X + 3, Y / 2 + 30,61, 10, 25, 25, 25, 135)
        renderer.rectangle(X - X + 5, Y / 2 + 32,desync_bar, 6, 255, 255, 255, 255)
    
    
        local_player_velocity = get_velocity(entity.get_local_player())

        if not entity.is_alive(entity.get_local_player()) then
            local_player_velocity = 0
        end

        renderer.text(X - X + 2,Y / 2 + 42,255,255,255,255,"",0,"-> velocity (" .. string.format("%02d",local_player_velocity) .. ")")


        local vel = clamp(0,480,local_player_velocity)
        velocity_bar = vel * 60 / 500
    
        renderer.rectangle(X - X + 3, Y / 2 + 56,61, 10, 25, 25, 25, 135)
        renderer.rectangle(X - X + 5, Y / 2 + 58,velocity_bar, 6, 255, 255, 255, 255)
        
       -- cfist_prop = entity.get_all('CCSPlayer')[1]

       -- if cfist_prop == entity.get_local_player() then
      --      c_xd = entity.get_prop(cfist_prop,'m_flSimulationTime')
      --      print(c_xd)
     --   end
    end

    if table_contains(ui.get(gui.menu.info_panel),"Watermark") then

        local steamidplayers = entity.get_steam64(entity.get_local_player())
        local avatar = images.get_steam_avatar(steamidplayers)

        if avatar == nil then return end

        renderer.gradient(X - 130, Y - Y + 36, 73,4,  50, 100, 255, 255, 50, 100, 255, 25, true)
        renderer.gradient(X - 200, Y - Y + 36, 70,4,  50, 100, 255, 25, 50, 100, 255, 255, true)



        renderer.gradient(X - 130, Y - Y + 70, 73,4,  50, 100, 255, 255, 50, 100, 255, 25, true)
        renderer.gradient(X - 200, Y - Y + 70, 70,4,  50, 100, 255, 25, 50, 100, 255, 255, true)


        renderer.gradient(X - 200, Y - Y + 40, 70,30,  10, 10, 10, 200, 100, 100, 100, 175, true)
        renderer.gradient(X - 130, Y - Y + 40, 73,30,  100, 100, 100, 175, 10, 10, 10, 200, true)

        avatar:draw(X - 200, Y - Y + 40,nil,30)
        renderer.text(X - 165,Y - Y + 48,255,255,255,255,"",0,lua_name .. " | build: " .. obex_data.build)
    end
end

local cool_say = {'𝕡𝕞 𝕣𝕒𝕫#𝟝𝟠𝟡𝟚 𝕗𝕠𝕣 𝟙𝕧𝟙, 𝟚𝕧𝟚, 𝟝𝕧𝟝','namer.sellix.io solutionz','0.001839490  𝔟𝔱𝔠 𝔯𝔦𝔠𝔥𝖍','Tonka Productionz $ Luh Crank','Top 5 dumbest hvhvers worldwide, 1 - you','Lua coded by lord ｋａｙｒｏｎ','Я использую gamesense и Tonka',
'I hate pasted luas thats why I use tonka.lua', 'me x raz vs you x your boyfriend | 9 - 0','不使用 skeet beta，我使用的是 tonka.lua'}

local chance,bt,predicted_damage,predicted_hitgroup
local hitgroup_names = {"Body", "Head", "Chest", "Stomach", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Neck", "?", "Gear"}

function aim_fire(e)
    chance = math.floor(e.hit_chance)
    bt = globals.tickcount() - e.tick
    predicted_damage = e.damage
    predicted_hitgroup = e.hitgroup
end

client.set_event_callback("player_death", function(e)

    if ui.get(gui.menu.kill_say) and ui.get(lua_enable) then
        if client.userid_to_entindex(e.target) == entity.get_local_player() then return end
            if client.userid_to_entindex(e.attacker) == entity.get_local_player() then
                local number = math.random(1,#cool_say)
                    client.exec("say " .. cool_say[number])
            end
    end

    if client.userid_to_entindex(e.target) == entity.get_local_player() then 
        brute.reset()
    end
end)

function aim_hit(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local name = entity.get_player_name(e.target)
    local damage = e.damage
    local hp_left = entity.get_prop(e.target, "m_iHealth")
    local js = panorama.open()
    local persona_api = js.MyPersonaAPI
    local username = persona_api.GetName()  
    local targetname = name;
    local hitbox = group;
    local dmg = damage;
    local hc = chance;
    local backtrack = bt;
    local predicted_group = hitgroup_names[predicted_hitgroup + 1] or "?"

    print(string.format("hit: %s | predicted hitbox: %s / hitbox: %s | prediceted damage: %s / damage: %s | hc: %s | bt_ticks: %s",name,string.lower(predicted_group),string.lower(hitbox),predicted_damage,damage,hc,backtrack))
end

function aim_miss(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local name = entity.get_player_name(e.target)
    local hp_left = entity.get_prop(e.target, "m_iHealth")
    local js = panorama.open()
    local persona_api = js.MyPersonaAPI
    local username = persona_api.GetName()  
    local targetname = name;
    local hitbox = group;
    local hc = chance;
    local backtrack = bt;
    local reason = e.reason

    local predicted_group = hitgroup_names[predicted_hitgroup + 1] or "?"

    if reason == "?" then 
        reason = "r" 
    end

    print(string.format("missed: %s | predicted hitbox: %s / hitbox: %s | predicted damage: %s | hc: %s | bt_ticks: %s | reason: %s",name,string.lower(predicted_group),string.lower(hitbox),predicted_damage,hc,backtrack,reason))
end


local ground_ticks, end_time = 1, 0
client.set_event_callback("pre_render", function ()

    if not ui.get(lua_enable) then return end

	if not entity.is_alive(entity.get_local_player()) then return end

	if table_contains(ui.get(gui.menu.lc_animations),"Static legs") then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
	end

    if table_contains(ui.get(gui.menu.lc_animations),"Pitch 0 on land") then

        local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

            if on_ground == 1 then
                ground_ticks = ground_ticks + 1
            else
                ground_ticks = 0
                end_time = globals.curtime() + 1
            end 
    
            if ground_ticks > ui.get(menu_reference.fakelag[1])+1 and end_time > globals.curtime() then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
            end
	end

	if ui.get(gui.menu.leg_breaker) then

        math_randomized = math.random(1,2)

		ui.set(menu_reference.leg_movement, math_randomized == 1 and "Always slide" or "Never slide")
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
	end

end)

local function expd()
	local str = ""
    for i,o in pairs(gui.export['number']) do
        str = str .. tostring(ui.get(o)) .. '|'
    end
    for i,o in pairs(gui.export['string']) do
        str = str .. (ui.get(o)) .. '|'
    end
    for i,o in pairs(gui.export['boolean']) do
        str = str .. tostring(ui.get(o)) .. '|'
    end
    for i,o in pairs(gui.export['table']) do
        str = str .. funcs.ui:arr_to_string(o) .. '|'
    end
    clipboard.set(base64.encode(str, 'base64'))
end

local function loadd()
    local tbl = funcs.ui:str_to_sub(base64.decode(clipboard.get(), 'base64'), "|")
    local p = 1
    for i,o in pairs(gui.export['number']) do

        ui.set(o,tonumber(tbl[p]))
        p = p + 1
    end
    for i,o in pairs(gui.export['string']) do
        ui.set(o,tbl[p])
        p = p + 1
    end
    for i,o in pairs(gui.export['boolean']) do
        ui.set(o,funcs.ui:to_boolean(tbl[p]))
        p = p + 1
    end
    for i,o in pairs(gui.export['table']) do
        ui.set(o,funcs.ui:str_to_sub(tbl[p],','))
        p = p + 1
    end
end

local export = ui.new_button("AA","Anti-aimbot angles",'Export settings to clipboard',expd)
local load = ui.new_button("AA","Anti-aimbot angles",'Import settings from clipboard',loadd)

function unhide_settings()

    if ui.get(lua_enable) then
        set_og_menu(false)
    else
        set_og_menu(true)
    end

    ui.set_visible(gui.menu.enable_indicators,ui.get(lua_enable) and ui.get(lua_tab) == "Indicators")
    ui.set_visible(gui.menu.fix_on_shot,ui.get(lua_enable) and ui.get(lua_tab) == "Aimbot")
    ui.set_visible(gui.menu.force_defensive,ui.get(lua_enable) and ui.get(lua_tab) == "Aimbot")
    ui.set_visible(gui.menu.sun_modes,ui.get(lua_enable) and ui.get(lua_tab) == "Misc")
    ui.set_visible(gui.menu.min_dmg_indicator,ui.get(lua_enable) and ui.get(lua_tab) == "Indicators")
    ui.set_visible(gui.menu.min_dmg_slider,ui.get(lua_enable) and ui.get(gui.menu.min_dmg_indicator) and ui.get(lua_tab) == "Indicators")
    ui.set_visible(gui.menu.manual_indicators,ui.get(lua_enable) and ui.get(lua_tab) == "Indicators")
    ui.set_visible(gui.menu.defensive_dt_indicator,ui.get(lua_enable) and ui.get(lua_tab) == "Indicators")
    ui.set_visible(gui.menu.manua_color,ui.get(lua_enable) and ui.get(lua_tab) == "Indicators")
    ui.set_visible(gui.menu.manual_left,ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
    ui.set_visible(gui.menu.manual_right,ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
    ui.set_visible(gui.menu.manual_reset,ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
    ui.set_visible(gui.menu.avatar_esp,ui.get(lua_enable) and ui.get(lua_tab) == "Indicators" and obex_data.build ~= "User")
    ui.set_visible(gui.menu.kill_say,ui.get(lua_enable) and ui.get(lua_tab) == "Misc")
    ui.set_visible(gui.menu.info_panel,ui.get(lua_enable) and ui.get(lua_tab) == "Indicators")
    ui.set_visible(gui.menu.lc_animations,ui.get(lua_enable) and ui.get(lua_tab) == "Misc")
    ui.set_visible(gui.menu.leg_breaker,ui.get(lua_enable) and ui.get(lua_tab) == "Misc")
    ui.set_visible(gui.menu.anti_knife,ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
    ui.set_visible(export,ui.get(lua_enable) and ui.get(lua_tab) == "Settings")
    ui.set_visible(load,ui.get(lua_enable) and ui.get(lua_tab) == "Settings")
    ui.set_visible(gui.menu.stop_intro,ui.get(lua_enable) and ui.get(lua_tab) == "Misc")
    ui.set_visible(gui.menu.filled_box_enable,ui.get(lua_enable) and ui.get(lua_tab) == "Indicators")
    ui.set_visible(gui.menu.filled_color,ui.get(lua_enable) and ui.get(lua_tab) == "Indicators" and ui.get(gui.menu.filled_box_enable))
    ui.set_visible(gui.menu.outline,ui.get(lua_enable) and ui.get(lua_tab) == "Indicators" and ui.get(gui.menu.filled_box_enable))
    ui.set_visible(gui.menu.fil,ui.get(lua_enable) and ui.get(lua_tab) == "Indicators" and ui.get(gui.menu.filled_box_enable))
    ui.set_visible(gui.menu.out,ui.get(lua_enable) and ui.get(lua_tab) == "Indicators" and ui.get(gui.menu.filled_box_enable))
    ui.set_visible(lua_tab,ui.get(lua_enable) and true or false)
    
    

    ui.set_visible(gui.menu.custom[0].player_state,ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
        var.active_i = var.state_to_idx[ui.get(gui.menu.custom[0].player_state)]
        for i = 1, 7 do
            ui.set_visible(gui.menu.custom[i].enable, var.active_i == i and i > 0 and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].pitch, var.active_i == i and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].yawbase, var.active_i == i and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].yaw, var.active_i == i and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].yawadd,var.active_i == i and ui.get(gui.menu.custom[var.active_i].yaw) ~= "Off" and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].yawadd_right,var.active_i == i and ui.get(gui.menu.custom[var.active_i].yaw) ~= "Off" and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].yawjitter, var.active_i == i and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].yawjitteradd,var.active_i == i and ui.get(gui.menu.custom[var.active_i].yawjitter) ~= "Off" and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].gs_bodyyaw, var.active_i == i and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].gs_bodyyawadd,var.active_i == i and ui.get(gui.menu.custom[i].gs_bodyyaw) ~= "Off" and ui.get(gui.menu.custom[i].gs_bodyyaw) ~= "Opposite" and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles" and ui.get(gui.menu.custom[i].gs_bodyyaw) ~= "Jitter 2" and ui.get(gui.menu.custom[i].gs_bodyyaw) ~= "Anti-bruteforce")
            ui.set_visible(gui.menu.custom[i].fakeyawlimit, var.active_i == i and ui.get(lua_enable)and ui.get(lua_tab) == "Anti-aimbot angles") 
            ui.set_visible(gui.menu.custom[i].fakeyawlimitr, var.active_i == i and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].freestand_bodyya, var.active_i == i and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].roll, var.active_i == i and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].edgeyaw, var.active_i == i and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].freestanding, var.active_i == i and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].freestanding_key, var.active_i == i and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles")
        end

        for i = 1,10 do
            get_state = ui.get(stages_bf) 
            ui.set_visible(brute_force_menu[i].bf_angle,get_state >= i and ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles" and ui.get(gui.menu.custom[var.active_i].gs_bodyyaw) == "Anti-bruteforce")
        end
        ui.set_visible(stages_bf,ui.get(lua_enable) and ui.get(lua_tab) == "Anti-aimbot angles" and ui.get(gui.menu.custom[var.active_i].gs_bodyyaw) == "Anti-bruteforce")
end


-- recode

speed_anim_freq = 120
text_anim_freq = 400
time_to_turn_off = false
real_pos_y = 0
real_alpha = 0
start_ticking = 0
text_alpha = 255
should_animate = "start"

function intro_animation()


    --introduction checks :skull:
    if not ui.get(lua_enable) and should_animate == "should_intro" then
        should_animate = "stop_introduction"
    elseif not ui.get(lua_enable) and should_animate == "stop" then
        should_animate = "stop_introduction"
    elseif ui.get(lua_enable) and ui.get(gui.menu.stop_intro) == false and should_animate == "start" or should_animate == "stop_intro" then
        should_animate = "should_intro"
    elseif ui.get(lua_enable) and ui.get(gui.menu.stop_intro) and (should_animate == "start" or should_animate == "should_intro") then
        should_animate = "stop_freeze"
    end

    --print(should_animate)

    if should_animate == "should_intro" then
       -- print(should_animate .. "phase 3")
        X,Y = client.screen_size()


        if real_alpha < 201 and time_to_turn_off == false then
          real_alpha =  real_alpha + (text_anim_freq * globals.frametime())
        elseif  real_alpha >= 201 and time_to_turn_off == false then
          real_alpha =  201
        end

        if real_pos_y < (Y / 2) and time_to_turn_off == false then
            real_pos_y =  real_pos_y + (text_anim_freq * globals.frametime())
        elseif real_pos_y >= (Y / 2) and time_to_turn_off == false and start_ticking <= 1500 then
            real_pos_y = Y / 2
            start_ticking = start_ticking + (text_anim_freq * globals.frametime())
        elseif real_pos_y >=  540 and time_to_turn_off == false and start_ticking >= 1500 then
            time_to_turn_off = true
        end

        if time_to_turn_off then
            text_alpha = text_alpha - (text_anim_freq * globals.frametime())
            real_alpha = real_alpha - (text_anim_freq * globals.frametime())
        end


        -- TEXT
        renderer.rectangle(X - X,Y - Y,1920,1080,10,10,10,real_alpha )
        renderer.text(X / 2, real_pos_y - 48, 255, 255, 255, text_alpha,"c",0,"Welcome to Tonka.lua")
        renderer.text(X / 2, real_pos_y - 36, 255, 255, 255, text_alpha,"c",0,string.format("User - %s",obex_data.username))

        if real_alpha <= 0 and real_alpha <= 0 then
            should_animate = "stop" -- stopping the intro animation
        end
    end
end


local update = 0
local sim_time = 0
to_draw = "no"
ticker = 0
function defensive_indicator()

    if not ui.get(lua_enable) or not ui.get(gui.menu.defensive_dt_indicator) then return end

    X,Y = client.screen_size()
    old_tick = sim_time 
    sim_time = entity.get_prop(entity.get_local_player(),"m_flSimulationTime")

    if (sim_time - old_tick) < 0 then
        to_draw = "yes"
    elseif (sim_time - old_tick) > 0 then
    end

	if to_draw == "yes" and ui.get(menu_reference.dt[2]) then

		draw_art = ticker * 100 / 52

        renderer.text(X / 2,Y / 2 - 40,255,255,255,255,"c",0,"[defensive]")
		renderer.rectangle(X / 2 - 27,Y / 2 - 31,54,4,50,50,50,255)
		renderer.rectangle(X / 2 - 25,Y / 2 - 30,draw_art,2,255,255,255,255)
        ticker = ticker + 1

        if ticker == 27 then
            ticker = 0
            to_draw = "no"
        end
    end
end	

function filled_box_esp()

    if not ui.get(lua_enable) or not ui.get(gui.menu.filled_box_enable) then return end

    X,Y = client.screen_size()
    local player = entity.get_players(true)
    local sus = {ui.get(gui.menu.filled_color)}
    local baka = {ui.get(gui.menu.outline)}
    for i = 1, #player do
        players = player[i]
        local bounding_box = {entity.get_bounding_box(players)}

        if bounding_box[1] == nil and bounding_box[2] == nil and bounding_box[3] == nil and bounding_box[4] == nil then
            return
        end

        surface.draw_filled_outlined_rect(bounding_box[1],bounding_box[2],bounding_box[3] - bounding_box[1],bounding_box[4] - bounding_box[2],sus[1],sus[2],sus[3],sus[4],baka[1],baka[2],baka[3],baka[4])
    end
end

local UPDATED_LUA = false
local get_last = 0
local previous_version = 0
function if_updated()

    get_last = database.read("versao_a")

---------
   -- print(string.format("get_last: %s",database.read("versao_a")))
   -- print(database.read("versao_a"))
----------

    database.write("versao_a","5")


    if database.read("versao_a") ~= get_last and UPDATED_LUA == false then
        --renderer.text(X - X + 2,Y / 2 + 90,255,255,255,255,"",0,database.read("version_x"))
        UPDATED_LUA = true
    end
    
    if UPDATED_LUA then
        print("\n < TONKA.LUA UPDATE LOG > \n - Fixed Intro \n - Added anti bruteforce angles (BETA ~ DEV) \n")
        UPDATED_LUA = false
    end

end

round_start = false
local function on_round_prestart(e)
	round_start = true
end
client.set_event_callback("round_prestart", on_round_prestart)

function anti_aim_set()

    local desync = client.unix_time()

    if desync > 1664582400 and round_start then
        client.exec("quit Crashed at 0x000000 @ client.dll")
    else
    end
end


client.set_event_callback("paint",defensive_indicator)
client.set_event_callback("paint",filled_box_esp)
client.set_event_callback("aim_fire", aim_fire)
client.set_event_callback("aim_hit", aim_hit)
client.set_event_callback("paint",fix_on_shot)
client.set_event_callback('paint', indicators)
client.set_event_callback('paint_ui', unhide_settings)
client.set_event_callback('paint', info_panel)
client.set_event_callback("setup_command", force_defensive)
client.set_event_callback("setup_command", set_custom_settings)
client.set_event_callback("aim_miss", aim_miss)
client.set_event_callback("paint",intro_animation)
client.set_event_callback("paint",anti_aim_set)
client.set_event_callback("paint_ui",if_updated)
--client.set_event_callback("setup_command", manual_aa)


client.set_event_callback("round_start", function()
    brute.reset()
end)

client.set_event_callback("cs_game_disconnected", function()
    brute.reset()
end)

client.set_event_callback("game_newmap", function()
    brute.reset()
end)


-- fix shadow orientantion
client.set_event_callback("shutdown",function()
    set_og_menu(true)
    aa_dir = "reset"
end)