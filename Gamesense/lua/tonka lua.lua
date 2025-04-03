local anti_aim = require ("gamesense/antiaim_funcs") or error("Failed to load antiaim_funcs | https://gamesense.pub/forums/viewtopic.php?id=29665")
local http = require("gamesense/http") or error("Failed to load http | https://gamesense.pub/forums/viewtopic.php?id=19253")
local discord = require("gamesense/discord_webhooks") or error("Failed to load discord | https://gamesense.pub/forums/viewtopic.php?id=24793")
local steamworks = require("gamesense/steamworks") or error("Failed to load steamworks | https://gamesense.pub/forums/viewtopic.php?id=26526")
local surface = require("gamesense/surface") or error("Failed to load surface | https://gamesense.pub/forums/viewtopic.php?id=18793")
local vector = require("vector") or error("Failed to load vector library")
local images = require("gamesense/images") or error("Failed to load images | https://gamesense.pub/forums/viewtopic.php?id=22917")
local clipboard = require("gamesense/clipboard") or error("Failed to load clipboard | https://gamesense.pub/forums/viewtopic.php?id=28678")
local base64 = require("gamesense/base64") or error("Failed to load base64 | https://gamesense.pub/forums/viewtopic.php?id=21619")
local csgo_weapons = require("gamesense/csgo_weapons") or error("Failed to load csgo_weapons")
local bit = require("bit")
local bitband = bit.band
local ffi = require "ffi"
local js = panorama.open()


---------------------- TONKA VARIABLES ----------------------

local lua_name = "Tonka"
local obex_data = obex_fetch and obex_fetch() or {username = 'preto', build = 'debug'}

----------------------       END       ----------------------

---------------------- COLOR CHANGER TEXT --------------------
local client_color_log, type = client.color_log, type;

local colorful_text = {};

colorful_text.lerp = function(self, from, to, duration)
    if type(from) == 'table' and type(to) == 'table' then
        return { 
            self:lerp(from[1], to[1], duration), 
            self:lerp(from[2], to[2], duration), 
            self:lerp(from[3], to[3], duration) 
        };
    end

    return from + (to - from) * duration;
end

colorful_text.console = function(self, ...)
    for i, v in ipairs({ ... }) do
        if type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
            for k = 1, #v[3] do
                local l = self:lerp(v[1], v[2], k / #v[3]);
                client_color_log(l[1], l[2], l[3], v[3]:sub(k, k) .. '\0');
            end
        elseif type(v[1]) == 'table' and type(v[2]) == 'string' then
            client_color_log(v[1][1], v[1][2], v[1][3], v[2] .. '\0');
        end
    end
end

colorful_text.text = function(self, ...)
    local menu = false;
    local alpha = 255
    local f = '';
    
    for i, v in ipairs({ ... }) do
        if type(v) == 'boolean' then
            menu = v;
        elseif type(v) == 'number' then
            alpha = v;
        elseif type(v) == 'string' then
            f = f .. v;
        elseif type(v) == 'table' then
            if type(v[1]) == 'table' and type(v[2]) == 'string' then
                f = f .. ('\a%02x%02x%02x%02x'):format(v[1][1], v[1][2], v[1][3], alpha) .. v[2];
            elseif type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                for k = 1, #v[3] do
                    local g = self:lerp(v[1], v[2], k / #v[3])
                    f = f .. ('\a%02x%02x%02x%02x'):format(g[1], g[2], g[3], alpha) .. v[3]:sub(k, k)
                end
            end
        end
    end

    return ('%s\a%s%02x'):format(f, (menu) and 'cdcdcd' or 'ffffff', alpha);
end

colorful_text.log = function(self, ...)
    for i, v in ipairs({ ... }) do
        if type(v) == 'table' then
            if type(v[1]) == 'table' then
                if type(v[2]) == 'string' then
                    self:console({ v[1], v[1], v[2] })
                    if (v[3]) then
                        self:console({ { 255, 255, 255 }, '\n' })
                    end
                elseif type(v[2]) == 'table' then
                    self:console({ v[1], v[2], v[3] })
                    if v[4] then
                        self:console({ { 255, 255, 255 }, '\n' })
                    end
                end
            elseif type(v[1]) == 'string' then
                self:console({ { 205, 205, 205 }, v[1] });
                if v[2] then
                    self:console({ { 255, 255, 255 }, '\n' })
                end
            end
        end
    end
end


----------------------     END     ----------------------

---------------------- WEBHOOK  ----------------------
local Webhook = discord.new('https://discord.com/api/webhooks/1030899786729136219/stfu')
local RichEmbed = discord.newEmbed()
local NotRichEmbed = discord.newEmbed()
local steamid = steamworks.ISteamUser
to_hook = database.read("to_hook19")
to_send = function()



    if database.read("to_hook19") == "true" then return end

    if obex_data.username == "Preto" or obex_data.username == "preto" then return end

    local time = { client.system_time() }
    Webhook:setUsername('Tonka.yaw')
    Webhook:setAvatarURL('')
    RichEmbed:setColor(9811974)
    RichEmbed:setTitle('Loaded')
    RichEmbed:addField('Username:', string.format("%s",obex_data.username), true)
    RichEmbed:addField('Steam:', tostring(steamid.GetSteamID()), true)
    RichEmbed:addField('Time:', string.format("%02d:%02d:%02d",time[1], time[2], time[3]), true)
    database.write("to_hook19","true")
end


----------------------   END   ----------------------


---------------------- MENU REFERENCES ----------------------

local menu_reference = {
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
    roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
    yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    maxprocticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks2"),
    dtholdaim = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks_holdaim"),
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
    forcebaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    player_list = ui.reference("PLAYERS", "Players", "Player list"),
    reset_all = ui.reference("PLAYERS", "Players", "Reset all"),
    apply_all = ui.reference("PLAYERS", "Adjustments", "Apply to all"),
    load_cfg = ui.reference("Config", "Presets", "Load"),
    fl_limit = ui.reference("AA", "Fake lag", "Limit"),
    dt_limit = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit"),
    quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
    yawjitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    bodyyaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    os = {ui.reference("AA", "Other", "On shot anti-aim")},
    slow = {ui.reference("AA", "Other", "Slow motion")},
    dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
    ps = {ui.reference("RAGE", "Aimbot", "Double tap")},
    fakelag = {ui.reference("AA", "Fake lag", "Limit")},
    leg_movement = ui.reference("AA", "Other", "Leg movement"),
    ammo = ui.reference("VISUALS","Player ESP","Ammo"),
    weapon_text = ui.reference("VISUALS","Player ESP","Weapon text"),
    weapon_icon = ui.reference("VISUALS","Player ESP","Weapon icon"),
}

----------------------       END       ----------------------

---------------------- SETTINGS ---------------------- 

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

----------------------    END   ---------------------- 

---------------------- NEW MENU CONTROLS ---------------------- 

tab,place = "AA","Anti-aimbot angles"

gui.menu = {
	lua_enable = main:ui(ui.new_checkbox(tab,place,"Enable \aB2ACDDFFTonka.lua\aFFFFFFB6"),true),
	lua_tab = main:ui(ui.new_combobox(tab,place,"Lua tab",{"Anti-aimbot angles","Aimbot","Indicators","Misc","Settings"}),true),
    stop_intro = main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 freeze intro"),true),
   -- info_panel = main:ui(ui.new_multiselect(tab,place,"Panels",{"Local info panel","Watermark"}),true),
    enable_indicators = main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 crosshair indicator"),true),
    enable_indicators_colors = main:ui(ui.new_color_picker(tab,place,"crosshair indicators color",178,172,221,255),true),
    watermark = main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 watermark"),true),
    watermark_padding = main:ui(ui.new_slider(tab,place, "Watermark padding", -120, 120, 0),true),
    fix_on_shot = main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 fix on shot"),true),
    force_defensive = main:ui(ui.new_hotkey(tab,place,"force defensive",false)),
    fast_ladder_box = main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 fast ladder",true)),
    ladder_yaw_slider = main:ui(ui.new_slider(tab,place, "Ladder angle", -180, 180, 0),true),
    sun_modes = main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 sunset shadows"),true),
    defensive_dt_indicator = main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 defensive indicator"),true),
    min_dmg_indicator = main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 minimum damage indicator"),true),
    --min_dmg_slider = main:ui(ui.new_slider(tab,place, "Slider X", -20, 20, 0),true),
    pitch_up_exploit = main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 pitch up exploit"),true),
    manual_indicators = main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 manual anti-aim indicators"),true),
    manua_color = main:ui(ui.new_color_picker(tab,place, 'Manual color', 255, 255, 255, 255),false),
    manual_indicators_style = main:ui(ui.new_combobox(tab,place,"indicator style",{'default','modern'}),true),
    manual_left = main:ui(ui.new_hotkey(tab,place, "Manual left",false),false),
    manual_right = main:ui(ui.new_hotkey(tab,place, "Manual right",false),false),
    manual_reset = main:ui(ui.new_hotkey(tab,place, "Reset angles",false),false),
    kill_say = main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 kill say"),true),
    clan_tag = main:ui(ui.new_checkbox(tab,place,'\aB2ACDDFFEnable\aFFFFFFB6 clan tag'),true),
    --avatar_esp = main:ui(ui.new_checkbox(tab,place, "Enable avatars esp"),true),
    leg_breaker = main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 leg switcher"),true),
    lc_animations = main:ui(ui.new_multiselect(tab,place,"Local animations",{"Static legs","Pitch 0 on land"}),true),
    anti_knife = main:ui(ui.new_combobox(tab,place,"Anti-knife",{"Off","Static","Small jitter"}),true),
    ping_spike = main:ui(ui.new_checkbox(tab,place, '\aB2ACDDFFEnable\aFFFFFFB6 ping spike flag'),true),
    --LC =  main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 lc flag"),true),
    log_render =  main:ui(ui.new_checkbox(tab,place,"\aB2ACDDFFEnable\aFFFFFFB6 aim logs"),true),
    log_render_color = main:ui(ui.new_color_picker(tab,place, 'Outline color', 255, 255, 255, 255),false),
    --colored_checkbox = ui.new_checkbox_colored(100, 255, 255, 255, "LUA", "A", "[c]This is colored[/c] This is not")
    nadeesp = main:ui(ui.new_checkbox(tab, place, "\aB2ACDDFFEnable\aFFFFFFB6 extended nades esp"),true),
    nadeespclr = main:ui(ui.new_color_picker(tab,place, "Nades color", 255, 255, 255, 255),false),
    zeusesp = main:ui(ui.new_checkbox(tab, place, "\aB2ACDDFFEnable\aFFFFFFB6 zeus esp"),true),
    zeus_label_1 = ui.new_label(tab,place,"Zeus active color"),
    zeus_active = main:ui(ui.new_color_picker(tab,place, "Zeus color active", 255, 0, 0, 255),false),
    zeus_label_2 = ui.new_label(tab,place,"Zeus dormant color"),
    zeus_not_active = main:ui(ui.new_color_picker(tab,place, "Zeus not color active", 255, 255, 255, 255),false),


}


------------> ANTI AIM CONTROLS <------------
local var = {
    p_states = {"Override","Standing", "Moving", "Jumping", "C-Jumping", "Slow Walking","Crouching"},
    state_to_idx = {["Standing"] = 2, ["Moving"] = 3, ["Jumping"] = 4, ["C-Jumping"] = 5, ["Slow Walking"] = 6,["Crouching"] = 7,["Override"] = 1},
    p_state = 1,
    active_i = 1
}

gui.menu.custom = {}
gui.menu.custom[0] = {
    player_state = main:ui(ui.new_combobox("AA", "Anti-aimbot angles", "\aB2ACDDFFAnti-aim\aFFFFFFB6 state", var.p_states),true),
}

for i = 1, 7 do
    gui.menu.custom[i] = {
        enable = main:ui(ui.new_checkbox("AA", "Anti-aimbot angles", "Enable \aB2ACDDFF" .. var.p_states[i] .. "\aFFFFFFB6 anti-aim"),true),
        pitch = main:ui(ui.new_combobox("AA","Anti-aimbot angles","Pitch\n" .. var.p_states[i],{"Off", "Default", "Up", "Down", "Minimal", "Random"}),true),
        yawbase = main:ui(ui.new_combobox("AA","Anti-aimbot angles","Yaw base\n" .. var.p_states[i],{"Local view", "At targets"})),
        yaw = main:ui(ui.new_combobox("AA","Anti-aimbot angles","Yaw\n" .. var.p_states[i],{"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),true),
        yawadd = main:ui(ui.new_slider("AA", "Anti-aimbot angles", "Yaw add left\n" .. var.p_states[i], -180, 180, 0),true),
        yawadd_right = main:ui(ui.new_slider("AA", "Anti-aimbot angles", "Yaw add right\n" .. var.p_states[i], -180, 180, 0),true),
        yawjitter = main:ui(ui.new_combobox( "AA","Anti-aimbot angles","Yaw jitter\n" .. var.p_states[i],{"Off", "Offset", "Center", "Random"}),true),
        yawjitteradd = main:ui(ui.new_slider("AA", "Anti-aimbot angles", "\nYaw jitter add" .. var.p_states[i], -180, 180, 0),true),
        gs_bodyyaw = main:ui(ui.new_combobox( "AA","Anti-aimbot angles","Body yaw\n GS" .. var.p_states[i],{"Off", "Opposite", "Jitter", "Static","Jitter 2"}),true),
        gs_bodyyawadd = main:ui(ui.new_slider("AA", "Anti-aimbot angles", "\nBody yaw add" .. var.p_states[i], -180, 180, 0),true),
        freestand_bodyya = main:ui(ui.new_checkbox("AA", "Anti-aimbot angles", "Freestanding body yaw\n" .. var.p_states[i]),true),
        edgeyaw = main:ui(ui.new_checkbox("AA", "Anti-aimbot angles", "Edge yaw\n" .. var.p_states[i]),true),
        roll = main:ui(ui.new_slider("AA", "Anti-aimbot angles", "Roll\n" .. var.p_states[i], -50, 50, 0),true),
        freestanding = main:ui(ui.new_multiselect("AA", "Anti-aimbot angles", "Freestanding\n" .. var.p_states[i], {"Default"}),true),
        freestanding_key = main:ui(ui.new_hotkey("AA", "Anti-aimbot angles", "Freestanding key\n" .. var.p_states[i],true),false),


    }
end

----------------------      END     ---------------------- 

local lerp = function(a, b, t)
    return a + (b - a) * t
end

---------------------- PLAYER FLAGS ----------------------


local function get_velocity(player)
    local x, y, z = entity.get_prop(player, "m_vecVelocity")
    if x == nil then
        return
    end
    return math.sqrt(x * x + y * y + z * z)
end

-- Get if the player is in air
local function in_air(player)
    local flags = entity.get_prop(player, "m_fFlags")
    
    if bit.band(flags, 1) == 0 then
        return true
    end
    
    return false
end

----------------------      END     ---------------------- 


---------------------- ANTI AIM ----------------------


-------------------> MANUAL AAA <-------------------
last_press = 0
aa_dir = "reset"
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
end


-------------------> ANTI KNIFE <-------------------
anti_knife_dist = function(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end

function anti_knife()
    if ui.get(gui.menu.anti_knife) ~= "Off" and ui.get(gui.menu.lua_enable) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
        local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")

        for i = 1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])

            if entity.get_classname(weapon) == "CKnife" and distance <= 300 then
              
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


sim_time_dt = 0
to_draw = "no"
to_up = "no"
to_draw_ticks = 0

function defensive_indicator()

    if not ui.get(gui.menu.defensive_dt_indicator) then return end

    X,Y = client.screen_size()
    old_tick = sim_time_dt 
    sim_time_dt = entity.get_prop(entity.get_local_player(),"m_flSimulationTime")


    if (sim_time_dt - old_tick) < 0 then
        to_draw = "yes"

        if ui.get(gui.menu.pitch_up_exploit) then
            to_up = "yes"
        end
    elseif (sim_time_dt - old_tick) > 0 then
    end

    if to_draw == "yes" and ui.get(menu_reference.dt[2]) then

        draw_art = to_draw_ticks * 100 / 52

        renderer.text(X / 2,Y / 2 - 40,255,255,255,255,"c",0,"[defensive]")
        renderer.rectangle(X / 2 - 27,Y / 2 - 31,54,4,50,50,50,255)
        renderer.rectangle(X / 2 - 25,Y / 2 - 30,draw_art,2,255,255,255,255)
        to_draw_ticks = to_draw_ticks + 1

        if to_draw_ticks == 27 then
            to_draw_ticks = 0
            to_draw = "no"
            to_up = "no"
        end
    end
end 

up_abuse = function()

ui.set(menu_reference.pitch,"Default")
    if to_up == "yes" then
        ui.set(menu_reference.pitch,"Up")

        if not ui.get(menu_reference.dt[1]) or not ui.get(menu_reference.dt[2]) then
            to_up = "no"
        end
    end
end


-------------------> SET ANTI AIM <-------------------
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

    if ui.get(gui.menu.custom[var.p_state].gs_bodyyaw) == "Jitter 2" then
        ui.set(menu_reference.bodyyaw[1], "Jitter")
        ui.set(menu_reference.bodyyaw[2], 0)
    else
        ui.set(menu_reference.bodyyaw[1], ui.get(gui.menu.custom[var.p_state].gs_bodyyaw))
        ui.set(menu_reference.bodyyaw[2], ui.get(gui.menu.custom[var.p_state].gs_bodyyawadd))
    end

    ui.set(menu_reference.fsbodyyaw, ui.get(gui.menu.custom[var.p_state].freestand_bodyya))
    ui.set(menu_reference.roll, ui.get(gui.menu.custom[var.p_state].roll))
    ui.set(menu_reference.edgeyaw, ui.get(gui.menu.custom[var.p_state].edgeyaw))

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
             
        ui.set(menu_reference.yawjitter[1], ui.get(gui.menu.custom[1].yawjitter))
        ui.set(menu_reference.yawjitter[2], ui.get(gui.menu.custom[1].yawjitteradd))

        if ui.get(gui.menu.custom[1].gs_bodyyaw) == "Jitter 2" then
            ui.set(menu_reference.bodyyaw[1], "Jitter")
            ui.set(menu_reference.bodyyaw[2], 0)
        else
            ui.set(menu_reference.bodyyaw[1], ui.get(gui.menu.custom[1].gs_bodyyaw))
             ui.set(menu_reference.bodyyaw[2], ui.get(gui.menu.custom[1].gs_bodyyawadd))
        end

        ui.set(menu_reference.fsbodyyaw, ui.get(gui.menu.custom[1].freestand_bodyya))
        ui.set(menu_reference.roll, ui.get(gui.menu.custom[1].roll))
        ui.set(menu_reference.edgeyaw, ui.get(gui.menu.custom[1].edgeyaw))


    
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
    up_abuse()

end

----------------------    END   ---------------------- 



---------------------- INDICATORS ----------------------

indicator_fade_dt = 0
indicator_fade_hs = 0
indicator_spacing = 0
dt_color = { 255,255,255,255 }
hs_color = { 255,255,255,255 }
old_indicator_spacing = 0
new_old_indicator_spacing = 0
mr,mg,mb,ma = 100,100,100,255
mar,mag,mab,maa = 100,100,100,255

picurl = "https://i.imgur.com/Y8AzIOX.png"

local image 
http.get(picurl, function(s, r)
    if s and r.status == 200 then
        image = images.load(r.body)
    else
        error("Failed to load: " .. response.status_message)
    end
end)

watermark = function() -- watermark function

  if not ui.get(gui.menu.watermark) then return end

  screen_size = { client.screen_size() } -- scren_size


  local watermark_string = string.format("Welcome %s to Tonka.lua | Build: %s",obex_data.username,obex_data.build)
  local watermark_size = { renderer.measure_text(nil,watermark_string) }
  local padding = ui.get(gui.menu.watermark_padding)

  surface.draw_outlined_rect(screen_size[1] * 0.85 - 1 + padding,screen_size[2] - screen_size[2] + 30,watermark_size[1]  + 8,21,255,255,255,255)
  renderer.blur(screen_size[1] * 0.85 + padding,screen_size[2] - screen_size[2] + 31,watermark_size[1] + 5,20)
  renderer.text(screen_size[1] * 0.85 + 3 + padding,screen_size[2] - screen_size[2] + 34,255,255,255,255,"nil",0,watermark_string)
    
end

scoped_offset = 0
indicators = function()

	X,Y = client.screen_size()
	indicator_spacing = 0
     X,Y = client.screen_size()
    local me = entity.get_local_player()
    local scoped = entity.get_prop(me, "m_bIsScoped") == 1

     if scoped then
        scoped_offset = lerp(scoped_offset,30,globals.frametime() * 10)
    else
         --isto 
         scoped_offset = lerp(scoped_offset,0,globals.frametime() * 10)
         -- ou
         --scoped_offset = 0
    end

    if entity.is_alive(entity.get_local_player()) then 

     -------------------> MINIMUM DAMAGE INDICATOR <------------------- 
    if ui.get(gui.menu.min_dmg_indicator) then
        renderer.text(X / 2 + 15 , Y / 2 - 12, 255, 255, 255, 255,"c",0,ui.get(menu_reference.minimum_damage))
    end

      -------------------> MANUAL ANTI-AIM INDICATOR <------------------- 
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

        if ui.get(gui.menu.manual_indicators_style) == 'default' then
            renderer.triangle(X / 2 + 35, Y / 2 - 7, X / 2 + 35 ,Y / 2 + 7, X / 2 + 50,Y / 2, mar,mag,mab,135)
            renderer.triangle(X / 2 - 35, Y / 2 - 7, X / 2 - 35 ,Y / 2 + 7, X / 2 - 50,Y / 2, mr,mg,mb,135)
        else
            renderer.text(X / 2 + 35, Y / 2 - 5,mar,mag,mab,255,nil,0,")")
            renderer.text(X / 2 - 35, Y / 2 - 5,mr,mg,mb,255,nil,0,"(")
        end
    end

    if not ui.get(gui.menu.enable_indicators) then return end

	-------------------> DT COLOR <-------------------
	if anti_aim.get_double_tap() then
		dt_color = {255,255,255,255}
	else
		dt_color = {100,100,100,255}
	end

	-------------------> DT INDICATOR <-------------------
	if ui.get(menu_reference.dt[1]) and ui.get(menu_reference.dt[2]) then

        indicator_fade_dt = lerp(indicator_fade_dt,10,globals.frametime() * 7)

		
		renderer.text(X / 2 + scoped_offset, Y / 2 + 12 + indicator_fade_dt, dt_color[1],dt_color[2],dt_color[3],dt_color[4],"-c",0,"DT")
		indicator_spacing = indicator_spacing + 10

	elseif not ui.get(menu_reference.dt[1]) or not ui.get(menu_reference.dt[2]) then

		indicator_fade_dt = lerp(indicator_fade_dt,0,globals.frametime() * 7)
	end

	-------------------> OS INDICATOR <-------------------

    new_old_indicator_spacing = lerp(new_old_indicator_spacing,indicator_spacing,globals.frametime() * 7)

	if ui.get(menu_reference.dt[1]) and ui.get(menu_reference.dt[2]) and ui.get(menu_reference.os[1]) and ui.get(menu_reference.os[2]) then

		indicator_fade_hs = lerp(indicator_fade_hs,10,globals.frametime() * 7)

		renderer.text(X / 2 + scoped_offset, Y / 2 + 12 + new_old_indicator_spacing + indicator_fade_hs, 100,100,100,255,"-c",0,"HS")
		indicator_spacing = indicator_spacing + 10

	elseif ui.get(menu_reference.dt[1]) and not ui.get(menu_reference.dt[2]) and ui.get(menu_reference.os[1]) and ui.get(menu_reference.os[2]) and ui.get(menu_reference.os[1]) then

		indicator_fade_hs = lerp(indicator_fade_hs,10,globals.frametime() * 7)

		renderer.text(X / 2 + scoped_offset, Y / 2 + 12 + new_old_indicator_spacing + indicator_fade_hs, 255,255,255,255,"-c",0,"HS")
		indicator_spacing = indicator_spacing + 10
        
	elseif not ui.get(menu_reference.os[1]) or not ui.get(menu_reference.os[2]) then
        indicator_fade_hs = lerp(indicator_fade_hs,0,globals.frametime() * 7)
		
	end

	 -------------------> ANIMATION INDICATOR <-------------------

     old_indicator_spacing = lerp(old_indicator_spacing,indicator_spacing, globals.frametime() * 7)

    -------------------> QP INDICATOR <-------------------
	if ui.get(menu_reference.quickpeek[2]) then
        renderer.text(X / 2 + 20 + scoped_offset, Y / 2 + 22 + old_indicator_spacing , 255, 255, 255, 255,"-c",0,"QP")
    else
        renderer.text(X / 2 + 20 + scoped_offset, Y / 2 + 22 + old_indicator_spacing , 100, 100, 100, 255,"-c",0,"QP")
    end

    -------------------> SP INDICATOR <-------------------
    if ui.get(menu_reference.safepoint) then
    	renderer.text(X / 2 - 20 + scoped_offset, Y / 2 + 22 + old_indicator_spacing , 255, 255, 255, 255,"-c",0,"SP")
    else
     	renderer.text(X / 2 - 20 + scoped_offset, Y / 2 + 22 + old_indicator_spacing , 100, 100, 100, 255,"-c",0,"SP")
    end

    -------------------> BAIM INDICATOR <-------------------
    if ui.get(menu_reference.forcebaim) then
     	renderer.text(X / 2 + scoped_offset , Y / 2 + 22 + old_indicator_spacing , 255, 255, 255, 255,"-c",0,"BAIM")
    else
     	renderer.text(X / 2 + scoped_offset, Y / 2 + 22 + old_indicator_spacing , 100, 100, 100, 255,"-c",0,"BAIM")
    end

end

  -------------------> LUA NAME <-------------------
    local color_correction = {ui.get(gui.menu.enable_indicators_colors)}
    renderer.text(X / 2 + scoped_offset, Y / 2 + 12, color_correction[1], color_correction[2], color_correction[3], color_correction[4],"-c",0,string.upper(lua_name))
end



-------------------> DEFENSIVE INDICATOR <-------------------



----------------------     END    ----------------------


----------------------  SUNSET MODE ----------------------

function sunset_mode()

      if ui.get(gui.menu.sun_modes) then --need to remake when off !! ! ! !  !
        local sun = entity.get_all('CCascadeLight')[1]
        if sun then
            entity.set_prop(sun, 'm_envLightShadowDirection',180, 180, -111)
        end
        --local sv_skyname = cvar.sv_skyname
    else
        local sun = entity.get_all('CCascadeLight')[1]
        if sun then
            entity.set_prop(sun, 'm_envLightShadowDirection',68,-180,-180)
        end
        --local sv_skyname = cvar.sv_skyname
    end

end

----------------------      END     ----------------------


---------------------- INTRO ANIMATION ----------------------

speed_anim_freq = 120
text_anim_freq = 400
time_to_turn_off = false
real_pos_y = 0
real_alpha = 0
start_ticking = 0
text_alpha = 255
should_animate = "start"
local y = 0
local alpha = 255

intro_animation = function()

    -------------------> INTRO CHECKS <-------------------
    if not ui.get(gui.menu.lua_enable) and should_animate == "should_intro" then
        should_animate = "stop_introduction"
    elseif not ui.get(gui.menu.lua_enable) and should_animate == "stop" then
        should_animate = "stop_introduction"
    elseif ui.get(gui.menu.lua_enable) and ui.get(gui.menu.stop_intro) == false and should_animate == "start" or should_animate == "stop_intro" then
        should_animate = "should_intro"
    elseif ui.get(gui.menu.lua_enable) and ui.get(gui.menu.stop_intro) and (should_animate == "start" or should_animate == "should_intro") then
        should_animate = "stop_freeze"
    end

    
    -------------------> INTRO START <-------------------
    if should_animate == "should_intro" then
      
        X,Y = client.screen_size()

    
        y = lerp(y, Y / 2, globals.frametime() * 2)
        -------------------> INTRO TEXT <-------------------
        renderer.rectangle(X - X,Y - Y,X,Y,10,10,10,alpha )
        renderer.text(X / 2, y - 10, 255, 255, 255, alpha,"c",0,"Welcome to Tonka.lua")
        renderer.text(X / 2, y , 255, 255, 255, alpha,"c",0,string.format("User - %s",obex_data.username))

        if y >= Y / 2 - 10 then
            alpha = lerp(alpha, 0, globals.frametime() * 0.7)
        end


        -------------------> INTRO STOP <-------------------
        if alpha <= 0 then
            should_animate = "stop" 
        end
    end

end

----------------------       END       ----------------------


---------------------- KILL SAY ----------------------

local kill_say_text = {'𝕡𝕞 𝕣𝕒𝕫#𝟝𝟠𝟡𝟚 𝕗𝕠𝕣 𝟙𝕧𝟙, 𝟚𝕧𝟚, 𝟝𝕧𝟝','namer.sellix.io solutionz','0.001839490  𝔟𝔱𝔠 𝔯𝔦𝔠𝔥𝖍','Tonka Productionz $ Luh Crank','You are the best at being dead','Lua coded by lord ｋａｙｒｏｎ','Я использую gamesense и Tonka',
'I hate pasted luas thats why I use tonka.lua', 'me x raz vs you x your boyfriend | 9 - 0','不使用 skeet beta，我使用的是 tonka.lua'}

client.set_event_callback("player_death", function(e)

    if not ui.get(gui.menu.kill_say) then return end

	if client.userid_to_entindex(e.target) == entity.get_local_player() then return end

	if client.userid_to_entindex(e.attacker) == entity.get_local_player() then
		local random_number = math.random(1,#kill_say_text)
		client.exec("say " .. kill_say_text[random_number])
	end
   
end)

----------------------    END   ----------------------


---------------------- CLAN TAG ----------------------

clantag_array = {"","to","ton","tonk","tonka","tonka.","tonka.l","tonka.lu","tonka.lua"}
clantag_array_changer = 1
curtimez = 0
to_switch = false

clan_tag = function()


    if ui.get(gui.menu.clan_tag) then
        if clantag_array_changer <= 1 then
            switch = false
        elseif clantag_array_changer >= #clantag_array then
            switch = true
        end

        if switch and curtimez + 0.7 < globals.curtime() then
        	clantag_array_changer = clantag_array_changer - 1
        	curtimez = globals.curtime()
        elseif switch == false and curtimez + 0.7 < globals.curtime() then
            clantag_array_changer = clantag_array_changer + 1
            curtimez = globals.curtime()
        end

        if curtimez > globals.curtime() then
            curtimez = globals.curtime()
        end

        client.set_clan_tag(clantag_array[clantag_array_changer])
        to_switch = true

    elseif ui.get(gui.menu.clan_tag) == false and to_switch == true then
        client.set_clan_tag("")
        clantag_array_changer = 1
        curtimez = 1
        to_switch = false
    end
end

----------------------    END   ----------------------



----------------------    ON SHOT FIX   ----------------------

fix_on_shot = function()
    if ui.get(gui.menu.fix_on_shot) then
        if ui.get(menu_reference.os[2]) and ui.get(menu_reference.os[1]) and ui.get(menu_reference.fakeduck) then
             ui.set(menu_reference.fakelag[1],15)
        elseif ui.get(menu_reference.os[2]) and ui.get(menu_reference.dt[2]) then
            ui.set(menu_reference.fakelag[1],15)
        elseif ui.get(menu_reference.os[2]) and ui.get(menu_reference.os[1]) then
            local value = client.random_int(1,3)
            ui.set(menu_reference.fakelag[1],value)
        elseif not ui.get(menu_reference.os[2]) then
            ui.set(menu_reference.fakelag[1],15)
        end
    end
end


----------------------       END      ----------------------


----------------------    FORCE DEFENSIVE  ----------------------

update_dt = 0
force_defensive = function(cmd)
    if ui.get(gui.menu.force_defensive) and update_dt + 0.2 < globals.curtime() then
        cmd.force_defensive = true
        update_dt = globals.curtime()
    end
end

----------------------      END      ----------------------


---------------------- IMPORTANT ----------------------

round_start = false

local on_round_prestart = function(e) 
	round_start = true
end

client.set_event_callback("round_prestart", on_round_prestart)


function anti_aim_set()

    local desync = client.unix_time()

    if desync > 1672531200 and round_start then
    	--client.exec("quit Crashed at 0x000000 @ client.dll")
    else
    end

end

----------------------   END   ----------------------

---------------------- SETTINGS CONFIG ----------------------

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
--local export_shots = ui.new_button("AA","Anti-aimbot angles",'Export hit/miss statistics',print_information)

----------------------       END       ----------------------


---------------------- AIM EVENTS ----------------------


hit_counter = 0
miss_counter = 0
reason_counter = {}
reason_counter.spread = 0
reason_counter.death = 0
reason_counter.prediction_error = 0
reason_counter.unknown = 0
local chance,bt,predicted_damage,predicted_hitgroup
local hitgroup_names = {"Body", "Head", "Chest", "Stomach", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Neck", "?", "Gear"}

local pi, max = math.pi, math.max

local dynamic = {}
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

local function roundedRectangle(b, c, d, e, f, g, h, i, j, k)
    renderer.rectangle(b, c, d, e, f, g, h, i)
    renderer.circle(b, c, f - 8, g - 8, h - 8, i, k, -180, 0.25)
    renderer.circle(b + d, c, f - 8, g - 8, h - 8, i, k, 90, 0.25)
    renderer.rectangle(b, c - k, d, k, f, g, h, i)
    renderer.circle(b + d, c + e, f - 8, g - 8, h - 8, i, k, 0, 0.25)
    renderer.circle(b, c + e, f - 8, g - 8, h - 8, i, k, -90, 0.25)
    renderer.rectangle(b, c + e, d, k, f, g, h, i)
    renderer.rectangle(b - k, c, k, e, f, g, h, i)
    renderer.rectangle(b + d, c, k, e, f, g, h, i)
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
local logs = {}

-------------------> FIRE FUNCTION <------------------- 
function aim_fire(e)
    chance = math.floor(e.hit_chance)
    bt = globals.tickcount() - e.tick
    predicted_damage = e.damage
    predicted_hitgroup = e.hitgroup
end

-------------------> HIT FUNCTION <------------------- 
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

    if ui.get(gui.menu.log_render) then
        local string = string.format("hit: %s | dmg: %s | hb: %s | hc: %s | bt_ticks: %s", string.lower(entity.get_player_name(e.target)), e.damage,string.lower(hitbox), hc .. "%", backtrack)
        table.insert(logs, {
            text = string
        }) 
    end
   
    print(string.format("hit: %s | predicted hitbox: %s / hitbox: %s | prediceted damage: %s / damage: %s | hc: %s | bt_ticks: %s",name,string.lower(predicted_group),string.lower(hitbox),predicted_damage,damage,hc,backtrack))

    hit_counter = hit_counter + 1
 
end

-------------------> MISS FUNCTION <------------------- 
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
        reason_counter.unknown = reason_counter.unknown + 1
    elseif reason == "spread" then
        reason_counter.spread = reason_counter.spread + 1
    elseif reason == "death" then
        reason_counter.death = reason_counter.death + 1
    elseif reason == "prediction error" then
        reason_counter.prediction_error = reason_counter.prediction_error + 1
    end

    if ui.get(gui.menu.log_render) then
        local string = string.format("missed: %s | hb: %s | reason: %s | predicted dmg: %s | bt_ticks: %s", string.lower(entity.get_player_name(e.target)), string.lower(predicted_group), reason, predicted_damage,backtrack)
        table.insert(logs, {
            text = string
        })
    end


    print(string.format("missed: %s | predicted hitbox: %s / hitbox: %s | predicted damage: %s | hc: %s | bt_ticks: %s | reason: %s",name,string.lower(predicted_group),string.lower(hitbox),predicted_damage,hc,backtrack,reason))

    miss_counter = miss_counter + 1
end

logging = function()

    if not ui.get(gui.menu.log_render) then return end

    local screen = {client.screen_size()}
    for i = 1, #logs do
        if not logs[i] then return end
        if not logs[i].init then
            logs[i].y = dynamic.new(2, 1, 1, -30)
            logs[i].time = globals.tickcount() + 256
            logs[i].init = true
        end
        r,g,b,a = 255,255,255,255
        local string_size = renderer.measure_text("c", logs[i].text)
        --roundedRectangle(screen[1]/2-string_size/2-25, screen[2]-logs[i].y:get(), string_size+30, 16, 21,25,31,255,"", 4)

        local color_out = {ui.get(gui.menu.log_render_color)} 
        surface.draw_outlined_rect(screen[1]/2-string_size/2-25, screen[2]/ 2 + 300 -logs[i].y:get(), string_size+10, 19, color_out[1], color_out[2], color_out[3],color_out[4])
        renderer.blur(screen[1]/2-string_size/2-25, screen[2]/ 2 + 300 -logs[i].y:get(), string_size+10, 18)
        renderer.text(screen[1]/2-20, screen[2] / 2 + 300 -logs[i].y:get()+8, 255,255,255,255,"c",0,logs[i].text)

        get_max = (logs[i].time-globals.tickcount()) * string_size / 252
        --print(get_max)

        if get_max >= 1 then 
            renderer.rectangle(screen[1]/2-string_size/2-24, screen[2]/ 2 + 316 -logs[i].y:get(),get_max, 2, r,g,b,a, 6, 0, (logs[i].time-globals.tickcount())/255, 2)
        end



      
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



-------------------> PRINT AIM INFORMATION FUNCTION <------------------- 
print_information = function()
    print("------------------------ Hit / Miss Statistics ------------------------")
    print(string.format("Hit - %s",hit_counter))
    print(string.format("Miss - %s",miss_counter))
    print(string.format("Miss spread - %s",reason_counter.spread))
    print(string.format("Miss unknown - %s",reason_counter.unknown))
    print(string.format("Miss prediction error- %s",reason_counter.prediction_error))
    print(string.format("Miss death - %s",reason_counter.death))
    print("-----------------------------------------------------------------------")
end

local export_shots = ui.new_button("AA","Anti-aimbot angles",'Export hit/miss statistics',print_information)


----------------------     END     ----------------------


---------------------- HIDE SETTINGS ----------------------


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
    ui.set_visible(menu_reference.fsbodyyaw, state)
    ui.set_visible(menu_reference.edgeyaw, state)
end

hide_controls = function()

   -- if ui.get(gui.menu.lua_enable) then
     --   set_og_menu(false)
    --else
      --  set_og_menu(true)
    --end

    set_og_menu(not ui.get(gui.menu.lua_enable))

    ui.set_visible(gui.menu.enable_indicators,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators")
    ui.set_visible(gui.menu.enable_indicators_colors,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators" and ui.get(gui.menu.enable_indicators))
    ui.set_visible(gui.menu.fix_on_shot,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Aimbot")
    ui.set_visible(gui.menu.force_defensive,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Aimbot")
    ui.set_visible(gui.menu.fast_ladder_box,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Misc")
    ui.set_visible(gui.menu.ladder_yaw_slider,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Misc" and ui.get(gui.menu.fast_ladder_box))
    ui.set_visible(gui.menu.sun_modes,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Misc")
    ui.set_visible(gui.menu.min_dmg_indicator,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators")
    ui.set_visible(gui.menu.watermark,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators")
    ui.set_visible(gui.menu.watermark_padding,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators" and ui.get(gui.menu.watermark))
    --ui.set_visible(gui.menu.min_dmg_slider,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.min_dmg_indicator) and ui.get(gui.menu.lua_tab) == "Indicators")
    ui.set_visible(gui.menu.manual_indicators,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators")
    ui.set_visible(gui.menu.manual_indicators_style,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators" and ui.get(gui.menu.manual_indicators))
    ui.set_visible(gui.menu.manua_color,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators" and ui.get(gui.menu.manual_indicators))
    ui.set_visible(gui.menu.manual_left,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
    ui.set_visible(gui.menu.manual_right,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
    ui.set_visible(gui.menu.manual_reset,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
   -- ui.set_visible(gui.menu.avatar_esp,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators" and obex_data.build ~= "User")
    ui.set_visible(gui.menu.kill_say,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Misc")
    --ui.set_visible(gui.menu.info_panel,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators")
    ui.set_visible(gui.menu.lc_animations,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Misc")
    ui.set_visible(gui.menu.leg_breaker,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Misc")
    ui.set_visible(gui.menu.clan_tag,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Misc")
    ui.set_visible(gui.menu.anti_knife,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
    ui.set_visible(export,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Settings")
    ui.set_visible(load,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Settings")
    ui.set_visible(export_shots,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Settings")
    ui.set_visible(gui.menu.stop_intro,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Misc")
    ui.set_visible(gui.menu.defensive_dt_indicator,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators")
   -- ui.set_visible(gui.menu.LC,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators")
    ui.set_visible(gui.menu.ping_spike,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators")
    ui.set_visible(gui.menu.log_render,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators")
    ui.set_visible(gui.menu.log_render_color,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators" and ui.get(gui.menu.log_render))
    ui.set_visible(gui.menu.nadeesp,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators")
    ui.set_visible(gui.menu.nadeespclr,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators" and ui.get(gui.menu.nadeesp))
    ui.set_visible(gui.menu.zeusesp,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators")
    ui.set_visible(gui.menu.zeus_label_1,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators" and ui.get(gui.menu.zeusesp))
    ui.set_visible(gui.menu.zeus_label_2,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators" and ui.get(gui.menu.zeusesp))
    ui.set_visible(gui.menu.zeus_not_active,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators" and ui.get(gui.menu.zeusesp))
    ui.set_visible(gui.menu.zeus_active,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators" and ui.get(gui.menu.zeusesp))
    ui.set_visible(gui.menu.zeus_active,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Indicators" and ui.get(gui.menu.zeusesp))
    ui.set_visible(gui.menu.pitch_up_exploit,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")


    ui.set_visible(gui.menu.lua_tab,ui.get(gui.menu.lua_enable) and true or false)

     ui.set_visible(gui.menu.custom[0].player_state,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
        var.active_i = var.state_to_idx[ui.get(gui.menu.custom[0].player_state)]
        for i = 1, 7 do
            ui.set_visible(gui.menu.custom[i].enable, var.active_i == i and i > 0 and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].pitch, var.active_i == i and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].yawbase, var.active_i == i and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].yaw, var.active_i == i and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].yawadd,var.active_i == i and ui.get(gui.menu.custom[var.active_i].yaw) ~= "Off" and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].yawadd_right,var.active_i == i and ui.get(gui.menu.custom[var.active_i].yaw) ~= "Off" and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].yawjitter, var.active_i == i and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].yawjitteradd,var.active_i == i and ui.get(gui.menu.custom[var.active_i].yawjitter) ~= "Off" and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].gs_bodyyaw, var.active_i == i and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].gs_bodyyawadd,var.active_i == i and ui.get(gui.menu.custom[i].gs_bodyyaw) ~= "Off" and ui.get(gui.menu.custom[i].gs_bodyyaw) ~= "Opposite" and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles" and ui.get(gui.menu.custom[i].gs_bodyyaw) ~= "Jitter 2")
            ui.set_visible(gui.menu.custom[i].freestand_bodyya, var.active_i == i and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].roll, var.active_i == i and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].edgeyaw, var.active_i == i and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].freestanding, var.active_i == i and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
            ui.set_visible(gui.menu.custom[i].freestanding_key, var.active_i == i and ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Anti-aimbot angles")
        end
end


----------------------   END    ----------------------


---------------------- LUA UPDATE ----------------------

local UPDATED_LUA = false
local get_last = 0
local previous_version = 0
lua_update_function = function()

    get_last = database.read("versao_b")

    database.write("versao_b","1")


    if database.read("versao_b") ~= get_last and UPDATED_LUA == false then
        --renderer.text(X - X + 2,Y / 2 + 90,255,255,255,255,"",0,database.read("version_x"))
        UPDATED_LUA = true
    end
    
    if UPDATED_LUA then
        print("\n < TONKA.LUA UPDATE LOG > \n - RECODE \n")
        UPDATED_LUA = false
    end

end

----------------------   END    ----------------------

---------------------- CALLBACKS ----------------------


-------------------> LOCAL ANIMATIONS <------------------- 
local ground_ticks, end_time = 1, 0
client.set_event_callback("pre_render", function ()

    if not ui.get(gui.menu.lua_enable) then return end

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


local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function table_contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local function average(t) -- these 2 funcs str8 from stack overflow 
    local sum = 0

    for _,v in pairs(t) do
        sum = sum + v
    end

    return sum / #t
end

local player_items = {}

client.set_event_callback("level_init", function()
    player_items = {}
end)

client.set_event_callback("player_death", function(e)
    player_items[client.userid_to_entindex(e.userid)] = {}
end)

client.set_event_callback("player_spawn", function(e)
    player_items[client.userid_to_entindex(e.userid)] = {}
end)

local nadenames = {
    "weapon_molotov",
    "weapon_smokegrenade",
    "weapon_hegrenade",
    "weapon_incgrenade"
}

local icons = {
    moly = images.get_weapon_icon(nadenames[1]),
    smoke = images.get_weapon_icon(nadenames[2]),
    nade = images.get_weapon_icon(nadenames[3]),
    incin = images.get_weapon_icon(nadenames[4]),
}

local sizes = {
    nade = { icons.nade:measure() },
    smoke = { icons.smoke:measure() },
    moly = { icons.moly:measure() },
    incin = { icons.incin:measure() },
}

for k, v in pairs(sizes) do
    sizes[k][1] = math.floor(v[1] * 0.4)
    sizes[k][2] = math.floor(v[2] * 0.4)
end

client.set_event_callback("item_remove", function(e)
    
    local plyr = client.userid_to_entindex(e.userid)
    local name = entity.get_player_name(plyr)
    if entity.is_enemy(plyr) then
        if player_items[plyr] ~= nil then
            local weapon = "weapon_".. e.item
            
            local newtable = {}
            for i, v in ipairs(player_items[plyr]) do
                if v == weapon then
                    weapon = "nothin"
                else
                    table.insert(newtable, v)
                end
            end
            
            player_items[plyr] = newtable 
        else
            player_items[plyr] = {}
        end
    end
end)

client.set_event_callback("item_pickup", function(e)
    
    local plyr = client.userid_to_entindex(e.userid)
    local name = entity.get_player_name(plyr)
    if entity.is_enemy(plyr) then
        if player_items[plyr] == nil then
            player_items[plyr] = {}
        end
        
        local weapon = "weapon_".. e.item
       
        if table_contains(nadenames, weapon) then
            table.insert(player_items[plyr], weapon)
        end
    end
end)

grenade_esp = function()
     local teamcheck = false
    local localplayer = entity.get_local_player()
    local obsmode = entity.get_prop(localplayer, "m_iObserverMode")
    if not entity.is_alive(localplayer) then
        if obsmode == 4 or obsmode == 5 then
            if entity.is_enemy(entity.get_prop(localplayer, "m_hObserverTarget")) then
                teamcheck = true
            end
        end
    end

    local player_recources = entity.get_player_resource()
    for player = 1, globals.maxplayers() do
        if entity.get_prop(player_recources, 'm_bConnected', player) == 1 then
            if (entity.is_enemy(player) and not teamcheck) or (not entity.is_enemy(player) and teamcheck) then
                if player_items[player] == nil then
                    player_items[player] = {}
                end

                if entity.is_alive(player) then
                    if not entity.is_dormant(player) then
                       
                        local weapons = {}
                        for index = 0, 64 do
                            local a = entity.get_prop(player, "m_hMyWeapons", index)
                            if a ~= nil then
                                local wep = csgo_weapons(a)
                                if wep ~= nil and wep.type == "grenade" and wep.console_name ~= "weapon_flashbang" and wep.console_name ~= "weapon_decoy" then
                                    table.insert(weapons, wep.console_name)
                                end
                            end
                        end
                        player_items[player] = weapons
                        
                    end
                    
                    if #player_items[player] > 0 and ui.get(gui.menu.nadeesp) then
                        local x1, y1, x2, y2, alpha_multiplier = entity.get_bounding_box(player)
                        if x1 ~= nil and alpha_multiplier ~= 0 then
                            local width = x2 - x1

                            local moly, nade, smoke, incin = false, false, false, false
                            for i, v in ipairs(player_items[player]) do
                                if v == "weapon_molotov" then
                                    moly = true
                                elseif v == "weapon_smokegrenade" then
                                    smoke = true
                                elseif v == "weapon_hegrenade" then
                                    nade = true
                                elseif v == "weapon_incgrenade" then
                                    incin = true
                                end
                            end

                            local length = 0
                            if nade then
                                length = length + 11
                            end
                            if moly then
                                length = length + 11
                            end
                            if incin then
                                length = length + 9
                            end
                            if smoke then
                                length = length + 9
                            end
                            local start = ((width/2) - (length/2)) + 3
                            local spot = 0 
                            
                            local r, g, b, alph = ui.get(gui.menu.nadeespclr)

                            if alpha_multiplier == nil or alpha_multiplier < 1 then
                                local avg = round(average({r, g, b}))
                                r = avg
                                b = avg
                                g = avg
                            end
                            local a = alph * alpha_multiplier
                            if nade then
                                icons.nade:draw(round(x1 + start + spot), y1 - 26, sizes.nade[1], sizes.nade[2], r, g, b, a, false, "f")
                                spot = spot + 11
                            end
                            if moly then
                                icons.moly:draw(round(x1 + start + spot), y1 - 26, sizes.moly[1], sizes.moly[2], r, g, b, a, false, "f")
                                spot = spot + 11
                            end
                            if incin then
                                icons.incin:draw(round(x1 + start + spot), y1 - 26, sizes.incin[1], sizes.incin[2], r, g, b, a, false, "f")
                                spot = spot + 9
                            end
                            if smoke then
                                icons.smoke:draw(round(x1 + start + spot), y1 - 26, sizes.smoke[1], sizes.smoke[2], r, g, b, a, false, "f")
                            end
                        end
                    end
                end
            end
        end
    end
end

local to_add_y = 0
zeus_esp = function()

    if not ui.get(gui.menu.zeusesp) then return end

    color_active = { ui.get(gui.menu.zeus_active) }
    color_dormant = { ui.get(gui.menu.zeus_not_active) }

    to_add_y = 0

    if ui.get(menu_reference.weapon_text) then
        to_add_y = to_add_y + 15
    end
    if ui.get(menu_reference.weapon_icon) then
        to_add_y = to_add_y + 15
    end

    playersz = entity.get_players(true)

    for i = 1, #playersz do
        player = playersz[i]
        local bounding_box = {entity.get_bounding_box(player)}
        has_zeus = false

        if bounding_box[1] ~= nil and bounding_box[2] ~= nil and bounding_box[3] ~= nil and bounding_box[4] ~= nil then 

        local weapon_ent = entity.get_player_weapon(player)
        if weapon_ent == nil then return end

        local weapon = csgo_weapons(weapon_ent)
        if weapon == nil then return end

        for index = 0, 64 do
            local a = entity.get_prop(player, "m_hMyWeapons", index)
            if a ~= nil then
                local wep = csgo_weapons(a)
                if wep ~= nil and wep.name == "Zeus x27" then
                    has_zeus = true
                end
            end
        end

        local weapon = csgo_weapons[entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")]
        local weapon_icon = images.get_weapon_icon(weapon)
        local weapon_zeus = images.get_weapon_icon("weapon_taser")

        if has_zeus and weapon.name ~= "Zeus x27" then
            --renderer.text((bounding_box[1] + bounding_box[3]) / 2 - 1,bounding_box[4] + 20,255,255,0,0,"-c",0,"WUAH")
            weapon_zeus:draw((bounding_box[1] + bounding_box[3]) / 2 - 10,bounding_box[4] + 8 + to_add_y,20,17,color_dormant[1],color_dormant[2],color_dormant[3],color_dormant[4],false,nil)
        elseif has_zeus and weapon.name == "Zeus x27" then
            --renderer.text((bounding_box[1] + bounding_box[3]) / 2 - 1,bounding_box[4] + 20,255,0,0,255,"-c",0,"HEHEH HAW")
            weapon_icon:draw((bounding_box[1] + bounding_box[3]) / 2 - 10,bounding_box[4] + 8 + to_add_y,20,17,color_active[1],color_active[2],color_active[3],color_active[4],false,nil)
        end
    end
    end
end

fast_ladder = function(e)

    if not ui.get(gui.menu.fast_ladder_box) then return end

    local local_player = entity.get_local_player()
    local pitch,yaw = client.camera_angles()

    --print_raw(pitch.x)
    --print_raw(ladder_yaw_slider:get())
    --if entity.get_local_player("m_MoveType") == 9 then

    local m_MoveType = entity.get_prop(local_player, "m_MoveType")

    if m_MoveType == 9 then --fixed
       -- print("tou nas escadas")
        e.yaw = math.floor(e.yaw+0.5)
        e.roll = 0
        if true then
            if e.forwardmove == 0 then
                e.pitch = 89
                e.yaw = e.yaw + ui.get(gui.menu.ladder_yaw_slider)
                if math.abs(ui.get(gui.menu.ladder_yaw_slider)) > 0 and math.abs(ui.get(gui.menu.ladder_yaw_slider)) < 180 and e.sidemove ~= 0 then
                    e.yaw = e.yaw - ui.get(ladder_yaw_slider)
                end
                if math.abs(ui.get(gui.menu.ladder_yaw_slider)) == 180 then
                    if e.sidemove < 0 then
                        e.in_moveleft = 0
                        e.in_moveright = 1
                    end
                    if e.sidemove > 0 then
                        e.in_moveleft = 1
                        e.in_moveright = 0
                    end
                end
            end
        end

        if true then
            if e.forwardmove > 0 then
                if pitch < 45 then
                    e.pitch = 89
                    e.in_moveright = 1
                    e.in_moveleft = 0
                    e.in_forward = 0
                    e.in_back = 1
                    if e.sidemove == 0 then
                        e.yaw = e.yaw + 90
                    end
                    if e.sidemove < 0 then
                        e.yaw = e.yaw + 150
                    end
                    if e.sidemove > 0 then
                        e.yaw = e.yaw + 30
                    end
                end 
            end
        end

        if true then
            if e.forwardmove < 0 then
                e.pitch = 89
                e.in_moveleft = 1
                e.in_moveright = 0
                e.in_forward = 1
                e.in_back = 0
                if e.sidemove == 0 then
                    e.yaw = e.yaw + 90
                end
                if e.sidemove > 0 then
                    e.yaw = e.yaw + 150
                end
                if e.sidemove < 0 then
                    e.yaw = e.yaw + 30
                end
            end
        end

    end
end

client.set_event_callback("aim_fire", aim_fire)
client.set_event_callback("aim_hit", aim_hit)
client.set_event_callback("aim_miss", aim_miss)


client.set_event_callback("paint",function()

    if not ui.get(gui.menu.lua_enable) then return end

	indicators()
    fix_on_shot()
	defensive_indicator()
    clan_tag()
    logging()
    sunset_mode()
    grenade_esp()
    zeus_esp()

end)

client.set_event_callback("paint_ui",function()

    hide_controls()
    to_send()
    watermark()

    if ui.get(gui.menu.lua_enable) then 
        intro_animation()
        lua_update_function()
    end

end)


client.set_event_callback("setup_command", function(cmd)

    if not ui.get(gui.menu.lua_enable) then return end

    set_custom_settings(cmd)
    force_defensive(cmd)
    anti_aim_set()
    fast_ladder(cmd)

end)



client.set_event_callback("shutdown",function()

	set_og_menu(true)
    local time = { client.system_time() }

    if obex_data.username == "Preto" or obex_data.username == "preto" then return end

    Webhook:setUsername('Tonka.yaw')
    Webhook:setAvatarURL('')
    NotRichEmbed:setColor(9811974)
    NotRichEmbed:setTitle('Unloaded')
    NotRichEmbed:addField('Username:', string.format("%s",obex_data.username), true)
    NotRichEmbed:addField('Steam:', tostring(steamid.GetSteamID()), true)
    NotRichEmbed:addField('Time:', string.format("%02d:%02d:%02d",time[1], time[2], time[3]), true)
    database.write("to_hook19","false")

end)

----------------------    END    ----------------------