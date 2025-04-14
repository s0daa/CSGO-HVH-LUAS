-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local re_render=(function()local b=renderer.circle;local c={}local d=function(e,f,g,h,i,j,k,l,m)renderer.rectangle(e+i,f,g-i*2,i,j,k,l,m)renderer.rectangle(e,f+i,i,h-i*2,j,k,l,m)renderer.rectangle(e+i,f+h-i,g-i*2,i,j,k,l,m)renderer.rectangle(e+g-i,f+i,i,h-i*2,j,k,l,m)renderer.rectangle(e+i,f+i,g-i*2,h-i*2,j,k,l,m)b(e+i,f+i,j,k,l,m,i,180,0.25)b(e+g-i,f+i,j,k,l,m,i,90,0.25)b(e+i,f+h-i,j,k,l,m,i,270,0.25)b(e+g-i,f+h-i,j,k,l,m,i,0,0.25)end;local n=function(e,f,g,h,i,j,k,l,m)renderer.rectangle(e,f+i,1,h-i*2+2,j,k,l,m)renderer.rectangle(e+g-1,f+i,1,h-i*2+1,j,k,l,m)renderer.rectangle(e+i,f,g-i*2,1,j,k,l,m)renderer.rectangle(e+i,f+h,g-i*2,1,j,k,l,m)renderer.circle_outline(e+i,f+i,j,k,l,m,i,180,0.25,2)renderer.circle_outline(e+g-i,f+i,j,k,l,m,i,270,0.25,2)renderer.circle_outline(e+i,f+h-i+1,j,k,l,m,i,90,0.25,2)renderer.circle_outline(e+g-i,f+h-i+1,j,k,l,m,i,0,0.25,2)end;local o=2;local p=45;local q=15;local r=function(e,f,g,h,i,j,k,l,m,s)renderer.rectangle(e+i,f,g-i*2,2,j,k,l,m)renderer.circle_outline(e+i,f+i,j,k,l,m,i,180,0.25,2)renderer.circle_outline(e+g-i,f+i,j,k,l,m,i,270,0.25,2)renderer.gradient(e,f+i,2,h-i*2,j,k,l,m,j,k,l,p,false)renderer.gradient(e+g-2,f+i,2,h-i*2,j,k,l,m,j,k,l,p,false)renderer.circle_outline(e+i,f+h-i,j,k,l,p+50,i,90,0.25,2)renderer.circle_outline(e+g-i,f+h-i,j,k,l,p+50,i,0,0.25,2)renderer.rectangle(e+i,f+h-2,g-i*2,2,j,k,l,p+50)end;local t,u,v,w=17,17,17,80;c.render_container=function(e,f,g,h,j,k,l,m,x)if g<=1 then return end;renderer.blur(e,f,g,h,100,100)d(e,f,g,h,o,t,u,v,w)r(e,f,g,h,o,j,k,l,m,q)end;c.render_glow_line=function(e,f,y,z,j,k,l,m,A,B,C,s)local D=vector(e,f,0)local E=vector(y,z,0)local F=({D:to(E):angles()})[2]for G=1,s do renderer.circle_outline(e,f,A,B,C,s-G,G,F+90,0.5,1)renderer.circle_outline(y,z,A,B,C,s-G,G,F-90,0.5,1)local H=vector(math_cos(math_rad(F+90)),math_sin(math_rad(F+90)),0):scaled(G*0.95)local I=vector(math_cos(math_rad(F-90)),math_sin(math_rad(F-90)),0):scaled(G*0.95)local J=H+D;local K=H+E;local L=I+D;local M=I+E;renderer.line(J.x,J.y,K.x,K.y,A,B,C,s-G)renderer.line(L.x,L.y,M.x,M.y,A,B,C,s-G)end;renderer.line(e,f,y,z,j,k,l,m)end;return c end)()local N=(function()local O={}local P=function(y,z,Q,R,S,G,i,d,c)renderer.rectangle(y+S,z,Q-S*2,S,G,i,d,c)renderer.rectangle(y,z+S,S,R-S*2,G,i,d,c)renderer.rectangle(y+S,z+R-S,Q-S*2,S,G,i,d,c)renderer.rectangle(y+Q-S,z+S,S,R-S*2,G,i,d,c)renderer.rectangle(y+S,z+S,Q-S*2,R-S*2,G,i,d,c)renderer.circle(y+S,z+S,G,i,d,c,S,180,0.25)renderer.circle(y+Q-S,z+S,G,i,d,c,S,90,0.25)renderer.circle(y+S,z+R-S,G,i,d,c,S,270,0.25)renderer.circle(y+Q-S,z+R-S,G,i,d,c,S,0,0.25)end;local T=4;local U=T+2;local p=45;local q=20;local V=function(y,z,x,j,S,G,i,d,c)renderer.rectangle(y+2,z+S+U,1,j-U*2-S*2,G,i,d,c)renderer.rectangle(y+x-3,z+S+U,1,j-U*2-S*2,G,i,d,c)renderer.rectangle(y+S+U,z+2,x-U*2-S*2,1,G,i,d,c)renderer.rectangle(y+S+U,z+j-3,x-U*2-S*2,1,G,i,d,c)renderer.circle_outline(y+S+U,z+S+U,G,i,d,c,S+T,180,0.25,1)renderer.circle_outline(y+x-S-U,z+S+U,G,i,d,c,S+T,270,0.25,1)renderer.circle_outline(y+S+U,z+j-S-U,G,i,d,c,S+T,90,0.25,1)renderer.circle_outline(y+x-S-U,z+j-S-U,G,i,d,c,S+T,0,0.25,1)end;local W=function(y,z,x,j,S,G,i,d,c,X)local p=c/255*p;renderer.rectangle(y+S,z,x-S*2,1,G,i,d,c)renderer.circle_outline(y+S,z+S,G,i,d,c,S,180,0.25,1)renderer.circle_outline(y+x-S,z+S,G,i,d,c,S,270,0.25,1)renderer.gradient(y,z+S,1,j-S*2,G,i,d,c,G,i,d,p,false)renderer.gradient(y+x-1,z+S,1,j-S*2,G,i,d,c,G,i,d,p,false)renderer.circle_outline(y+S,z+j-S,G,i,d,p,S,90,0.25,1)renderer.circle_outline(y+x-S,z+j-S,G,i,d,p,S,0,0.25,1)renderer.rectangle(y+S,z+j-1,x-S*2,1,G,i,d,p)for S=4,X do local S=S/2;V(y-S,z-S,x+S*2,j+S*2,S,G,i,d,X-S*2)end end;O.linear_interpolation=function(Y,Z,_)return(Z-Y)*_+Y end;O.clamp=function(a0,a1,a2)if a1>a2 then return math.min(math.max(a0,a2),a1)else return math.min(math.max(a0,a1),a2)end end;O.lerp=function(Y,Z,_)_=_ or 0.005;_=O.clamp(globals_frametime.frametime()*_*175.0,0.01,1.0)local c=O.linear_interpolation(Y,Z,_)if Z==0.0 and c<0.01 and c>-0.01 then c=0.0 elseif Z==1.0 and c<1.01 and c>0.99 then c=1.0 end;return c end;O.container=function(y,z,x,j,G,i,d,c,a3,a4)if a3*255>0 then renderer.blur(y,z,x,j)end;P(y,z,x,j,T,17,17,17,c)W(y,z,x,j,T,G,i,d,a3*255,a3*q)if not a4 then return end;a4(y+T,z+T,x-T*2,j-T*2.0)end;return O end)()
local anti_aim, vector, easing, images, lib = require("gamesense/antiaim_funcs"), require("vector"), require("gamesense/easing"), require("gamesense/images"), require("gamesense/entity")
local sub =  function (a, b) return vector(a.x - b.x, a.y - b.y, a.z - b.z) end

local cache_choke = 0
client.set_event_callback("setup_command", function(c)
    cache_choke = c.chokedcommands
end)
local AA_S =  {"Slow-Walk", "In-Move", "Stand", "Crouch", "Air-Crouch", "In-Air"}
local tab, container, builder = "aa", "anti-aimbot angles", {}
local Antiaim_d = {}
local index = { [1] = "Default", [2] = "Exp-slow", [3] = "Slow",  [4] = "Extra"}
local function export_config()
    local settings = {}
    local clipboard = require("gamesense/clipboard")
    local base64 = require("gamesense/base64")
    for key, value in pairs(AA_S) do
        settings[tostring(value)] = {}
        for k, v in pairs(Antiaim_d[key]) do
            settings[value][k] = ui.get(v)
        end
    end
    clipboard.set(json.stringify(settings))
end

local function import_config()
    local clipboard = require("gamesense/clipboard")
    local base64 = require("gamesense/base64")
    local settings = json.parse(clipboard.get())
    for key, value in pairs(AA_S) do
        for k, v in pairs(Antiaim_d[key]) do
            local current = settings[value][k]
            if (current ~= nil) then
                ui.set(v, current)
            end
        end
    end
end

local menu = {
    enable = ui.new_checkbox(tab, container, "master switch"),
    selection = ui.new_combobox(tab, container, "tab selection", "anti-aim", "visuals", "additives"), 
    anti_aim = {
        enable = ui.new_checkbox(tab, container, "[aa] enable anti-aim"),
        custom = { 

        },
        keys = {
            freestand = ui.new_hotkey(tab, container, "[aa] enable freestanding"),
            edge = ui.new_hotkey(tab, container, "[aa] enable edge-yaw"),

            left = ui.new_hotkey(tab, container, "[aa] left anti-aim hotkey"),
            right = ui.new_hotkey(tab, container, "[aa] right anti-aim hotkey"),
            back = ui.new_hotkey(tab, container, "[aa] back anti-aim hotkey"),
            forward = ui.new_hotkey(tab, container, "[aa] forwards anti-aim hotkey"),
            state = ui.new_slider(tab, container, "dir", 0, 4),

            legit = ui.new_hotkey(tab, container, "[aa] legit anti-aim hotkey"),
        },

        opt = ui.new_combobox(tab, container, "[aa] select anti-aim mode", "preset", "custom", "builder"),
        mode = ui.new_combobox(tab, container, "[aa] preset selection", "smart", "euclid", "keter", "thaumiel", "apollyon", "maksur"),

        builder_menu = ui.new_combobox(tab, container, "[aa] state selection", AA_S),
        config_export = ui.new_button(tab, container, "[aa] Export Preset", export_config),
        config_import = ui.new_button(tab, container, "[aa] Import Preset", import_config),
    },

    visuals = {
        enable = ui.new_checkbox(tab, container, "[vis] enable visuals"),
        opt = ui.new_multiselect(tab, container, "[vis] select visual features", "crosshair", "bruteforce logging", "animations"),
        style = ui.new_combobox(tab, container, "[vis] crosshair indicator style", "standard", "modern", "goofy yaw"),
        x_1 = ui.new_label(tab, container, "[vis] primary accent"),
        pri = ui.new_color_picker(tab, container, "[vis] primary accent", 255, 255, 255),
        x_2 = ui.new_label(tab, container, "[vis] secondary accent"),
        sec = ui.new_color_picker(tab, container, "[vis] secondary accent", 255, 90, 100),
        x_3 = ui.new_label(tab, container, "[vis] speedbar accent"),
        spe = ui.new_color_picker(tab, container, "[vis] speedbar accent", 171, 174, 255),
        x_4 = ui.new_label(tab, container, "[vis] cycle accent"),
        cyc = ui.new_color_picker(tab, container, "[vis] cycle accent", 170, 170, 170),
        debug = ui.new_checkbox(tab, container, "[vis] enable debug panel"),

        com = ui.new_combobox(tab, container, "[vis] custom animations", "-", "stanky leg", "what??!?!")
    },

    additives = {
        enable = ui.new_checkbox(tab, container, "[add] enable additive features"),
        opt = ui.new_multiselect(tab, container, "[add] enable additive features", "height advantage", "anti-backstab", "defensive in-air", "anti-bruteforce"),
        ang = ui.new_slider(tab, container, "[add] height angle",  0, 60, 15, true, "u"),
        expjitter = ui.new_checkbox(tab, container, "[add] experimental jitter"),
        --reduce = ui.new_checkbox(tab, container, "[experimental] reduce onshot")
        redacted = ui.new_checkbox(tab, container, "[add] spaghet"),
        o_1 = ui.new_combobox(tab, container, "[add] spaghet pitch", "up", "down", "off", "haywire", "switch"),
        o_2 =ui.new_combobox(tab, container, "[add] spaghet yaw", "default", "revolve"),
    }
}

local generation = function()
    for i = 1 , #AA_S do
        Antiaim_d[i] = {
            yaw_slider_l = ui.new_slider(tab, container, "Yaw >" ..AA_S[i], -180, 180, 0, true),
            yaw_slider_r = ui.new_slider(tab, container, "\nYaw +/- " ..AA_S[i], -180, 180, 0, true),

            yaw_jitter = ui.new_combobox(tab, container, "Yaw Jitter >"..AA_S[i], "Center", "Skitter", "Sway"),

            yaw_jitter_slider = ui.new_slider( tab, container, "\nYaw Jitter " ..AA_S[i], -180, 180, 40, true),
            yaw_skitter_speed = ui.new_slider(tab, container, "Skitter speed >"..AA_S[i], -180, 180, 40, true),

            yaw_jitter_speed = ui.new_slider(tab, container, "Jitter speed >"..AA_S[i], 1, 4, 1, true, nil, 1, index),
            yaw_sway_speed = ui.new_slider(tab, container, "Sway speed >"..AA_S[i], 1, 10, 1, true, nil, 1),

            body_yaw = ui.new_combobox(tab, container, "Body yaw >"..AA_S[i].."", "Static", "Jitter", "Off"),

            bodyyaw_slider = ui.new_slider( tab, container, "\nBody Yaw slider " ..AA_S[i], -180, 180, 0, true),
            bodyyaw_slider_add = ui.new_slider(tab, container, "\nBody Yaw slider add"..AA_S[i], -180, 180, 0, true)
        }
    end
end
generation()

local ref = {
    antiaim = {
        anti_aim = { ui.reference("AA", "Anti-aimbot angles", "Enabled") },
        pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")},
        yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
        yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw Base"),
        jitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
        body_yaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
        fs_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        roll = ui.reference("aa", "anti-aimbot angles", "roll"),
    },
    fs = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    edge = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    legs = ui.reference("AA", "Other", "Leg movement"),
    fl = ui.reference("AA", "Fake lag", "Enabled"),
    fl_amt = ui.reference("AA", "Fake lag", "Amount"),
    fl_var = ui.reference("AA", "Fake lag", "Variance"),
    fl_limit = ui.reference("AA", "Fake lag", "Limit"),
    menu = ui.reference("MISC", "Settings", "Menu color"),
    rage = { ui.reference("RAGE", "Aimbot", "Enabled") },
    damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    dt = { ui.reference("RAGE", "Aimbot", "Double tap") },
    dt_hc = ui.reference("RAGE", "Aimbot", "Double tap hit chance"),
    dt_fl = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit"),
    fd = ui.reference("RAGE", "Other", "Duck peek assist"),
    qp = { ui.reference("RAGE", "Other", "Quick peek assist") },
    --mupc = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    slow = { ui.reference("AA", "other", "slow motion") },
    third_person = { ui.reference("VISUALS", "Effects", "Force third person (alive)") },
    wall = ui.reference("VISUALS", "Effects", "Transparent walls"),
    prop = ui.reference("VISUALS", "Effects", "Transparent props"),
    skybox = ui.reference("VISUALS", "Effects", "Remove Skybox"),
    hs = { ui.reference("AA", "Other", "On shot anti-aim") },
    baim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    safe = ui.reference("RAGE", "Aimbot", "Force safe point"),
}

local states, presets = { "air", "air fakelag", "accelerate", "move", "move fakelag", "slow walk", "stand", "duck" }, { "smart", "euclid", "keter", "thaumiel", "apollyon", "maksur" }
for i = 1, #states do
    menu.anti_aim.custom[i] = {
        preset = ui.new_combobox(tab, container, "[aa] " .. states[i] .. " preset selection", presets)
    }
end

local storage = {
    anti_aim = {
        yaw = {0, 0}, jitter = {0, 0}, bodyyaw = {0, 0}, fake_limit = {0, 0}, body_yaw = "Jitter", jitter_mode = "Center", state = 0,
        ymca = {
            last_tick = 0,
            jitter_increment = 0,
            switch = false,
        },
    },

    target = nil,
    status = "",
    player = "nil",

    fraction = 0,
    ticks = 0,

    logs = { },

    bruteforce = {
        side = { },
        ang = { },
        miss = { },
        target = nil,
        last = globals.curtime()
    }
}

local util = { }
function util:visible(r, s)
    if type(r) == "table" then
        for i, v in pairs(r) do
            if type(v) == "table" then
                for j = 1, #v do
                    ui.set_visible(v[j], s)
                end
            else
                ui.set_visible(v, s)
            end
        end
    else
        ui.set_visible(r, s)
    end
end

function util:status()
    local air, crouch = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 0 or client.key_state(0x20), bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 4) == 0
    local d, e = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local velocity = math.sqrt(d ^ 2 + e ^ 2)
    return {air, crouch, velocity}
end

function util:contains(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

function util:lerp(start, vend, time)
    return start + (vend - start) * time
end

function util:clr_text(x, y, flags, args, sep)
    local last_length = 0;
    for idx = 1, #args do
        renderer.text(x + last_length, y, args[idx][2], args[idx][3], args[idx][4], args[idx][5], flags, nil, args[idx][1]);
        local sized_txt = { renderer.measure_text(flags, args[idx][1]) };
        last_length = last_length + sized_txt[1] + sep;
    end
end

function util:clr_array(r, g, b)
    local colors = {}
    for i = 0, 13 do
        local color = {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + i * 5 / 30))}
        table.insert(colors, color)
    end
    return colors
end

function util:clamp(value, min, max)
    if (value > max) then
        return max
    end
    if (value < min) then
        return min
    end
    return value
end

function util:anti_aim(yaw_1, yaw_2, jitter_1, jitter_2, body_yaw_1, body_yaw2, fake_1, fake_2, body_yaw_mode, jitter_mode)

    local ymca_aa = ui.get(menu.additives.expjitter)
    local ymca_sets = {
        yaw = (storage.anti_aim.ymca.switch and yaw_1 or yaw_2),
        jitter = (storage.anti_aim.ymca.switch and jitter_1 or jitter_2),
        body_yaw = (storage.anti_aim.ymca.switch and body_yaw_1 or body_yaw2),
        fake_limit = (storage.anti_aim.ymca.switch and fake_1 or fake_2),
    }
    --[[
    storage.anti_aim.yaw[1] = ymca_sets.yaw or yaw_1
    storage.anti_aim.yaw[2] = ymca_sets.yaw or yaw_2
    storage.anti_aim.jitter[1] = ymca_sets.jitter or jitter_1
    storage.anti_aim.jitter[2] = ymca_sets.jitter or jitter_2
    storage.anti_aim.bodyyaw[1] = ymca_sets.body_yaw or body_yaw_1
    storage.anti_aim.bodyyaw[2] = ymca_sets.body_yaw or body_yaw_2
    storage.anti_aim.fake_limit[1] = ymca_sets.fake_limit or fake_1
    storage.anti_aim.fake_limit[2] = ymca_sets.fake_limit or fake_2
    storage.anti_aim.body_yaw = body_yaw_mode
    storage.anti_aim.jitter_mode = jitter_mode
    ]]
    --[[
    storage.anti_aim.yaw[1] = yaw_1 or yaw_2 storage.anti_aim.yaw[2] = storage.anti_aim.ymca.switch and yaw_1 or yaw_2
    storage.anti_aim.jitter[1] = storage.anti_aim.ymca.switch and jitter_1 or jitter_2 storage.anti_aim.jitter[2] = storage.anti_aim.ymca.switch and jitter_1 or jitter_2
    storage.anti_aim.bodyyaw[1] = storage.anti_aim.ymca.switch and body_yaw_1 or body_yaw2 storage.anti_aim.bodyyaw[2] = storage.anti_aim.ymca.switch and body_yaw_1 or body_yaw2
    storage.anti_aim.fake_limit[1] = storage.anti_aim.ymca.switch and fake_1 or fake_2 storage.anti_aim.fake_limit[2] = storage.anti_aim.ymca.switch and fake_1 or fake_2
    storage.anti_aim.body_yaw = body_yaw_mode
    storage.anti_aim.jitter_mode = jitter_mode
    ]]

    storage.anti_aim.yaw[1] = (ymca_aa and ymca_sets.yaw) or yaw_1 
    storage.anti_aim.yaw[2] = (ymca_aa and ymca_sets.yaw) or yaw_2
    storage.anti_aim.jitter[1] = (ymca_aa and ymca_sets.jitter) or jitter_1
    storage.anti_aim.jitter[2] = (ymca_aa and ymca_sets.jitter) or jitter_2
    storage.anti_aim.bodyyaw[1] = (ymca_aa and ymca_sets.body_yaw) or body_yaw_1 
    storage.anti_aim.bodyyaw[2] = (ymca_aa and ymca_sets.body_yaw) or body_yaw2
    storage.anti_aim.fake_limit[1] = (ymca_aa and ymca_sets.fake_limit) or fake_1 
    storage.anti_aim.fake_limit[2] = (ymca_aa and ymca_sets.fake_limit) or fake_2
    storage.anti_aim.body_yaw = body_yaw_mode
    storage.anti_aim.jitter_mode = jitter_mode
end 

local _vars = {
    default_yaw_left = 0, default_yaw_right = 0,
    jitter_mode = "Center", Jitter_slider = 0,
    Bodyyaw_mode = "Jitter", Bodyyaw_slider = 0,
    Bodyyaw_slider_add = 0, sway_speed = 0, skitter_speed = 0,
    fake_limit = 0, frequency = 0
}

function util:rtd(a)
    return a * 180 / 3.14
end

function util:rgba(redArg, greenArg, blueArg, alphaArg)
    return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
end

function util:height_advantage(angle)
    local entities = {
        me = entity.get_local_player(),
        target = client.current_threat(),
    }
    if entities.me == nil or entities.target == nil then return false end

    local player = vector(client.eye_position())
    local target = vector(entity.hitbox_position(entities.target, 0))

    local distance = {
        vector = sub(player, target),
        range = player:dist(target),
    }
    local enemyAngle = (util:rtd(math.asin(distance.vector.z / distance.range)))
    return ((player.z > target.z) and (enemyAngle > angle) and (distance.range < 750)) -- you do a custom distance here
end

function util:dist(target, ent)
    local x, y, z = entity.hitbox_position(target, 0)
    local x1, y1, z1 = client.eye_position()

    local p = { x1, y1, z1 }

    local a = { x, y, z }
    local b = { ent.x, ent.y, ent.z }

    local ab = { b[1] - a[1], b[2] - a[2], b[3] - a[3] }
    local len = math.sqrt(ab[1] ^ 2 + ab[2] ^ 2 + ab[3] ^ 2)
    local d = { ab[1] / len, ab[2] / len, ab[3] / len }
    local ap = { p[1] - a[1], p[2] - a[2], p[3] - a[3] }
    local d2 = d[1] * ap[1] + d[2] * ap[2] + d[3] * ap[3]

    bp = { a[1] + d2 * d[1], a[2] + d2 * d[2], a[3] + d2 * d[3] }

    return (bp[1] - x1) + (bp[2] - y1) + (bp[3] - z1)
end

function util:charge()
    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if weapon == nil then return false end
    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
	local jewfag = entity.get_prop(weapon, "m_flNextPrimaryAttack")
	if jewfag == nil then return end
    local next_primary_attack = jewfag + 0.5
    if next_attack == nil or next_primary_attack == nil then return false end
    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
end

-- fixed
local y_vars, y_reversed, switcher = 0, 0, false
local desyncwasdwasdwasd = 0

function util:jitter(a, b, cmd)
    local Jitter = (ui.get(ref.antiaim.body_yaw[1]) == "Jitter") or ui.get(menu.additives.expjitter)
    local Static = (ui.get(ref.antiaim.body_yaw[1]) == "Static")

    local localplayer = entity.get_local_player()

    if globals.tickcount() - y_vars > 1  then
        y_reversed = y_reversed == 1 and 0 or 1
        y_vars = globals.tickcount()
    end

    if cmd.chokedcommands == 0 then
        desyncwasdwasdwasd = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    end

    local _return = ((Jitter) and desyncwasdwasdwasd < 0 and b or a) or
                    ((Static) and (y_reversed >= 1 and a or b))
                    --print(_return, "|", y_reversed >= 1)

    if Jitter then
        return desyncwasdwasdwasd < 0 and a or b
    else
        return y_reversed >= 1 and a or b
    end

end

function util:sway(a, b, c)
    local range = a - b
    local ticks = globals.tickcount()
    local progress = (ticks % c) / c

    return a - (range * progress)
end

function util:builder_jitter(a, b)

    if globals.tickcount() - y_vars > 1  then
        y_reversed = y_reversed == 1 and 0 or 1
        y_vars = globals.tickcount()
    end

    return y_reversed >= 1 and a or b
end

function util:round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function util:dist(target, ent)
    local x, y, z = entity.hitbox_position(target, 0)
    local x1, y1, z1 = client.eye_position()

    local p = { x1, y1, z1 }

    local a = { x, y, z }
    local b = { ent.x, ent.y, ent.z }

    local ab = { b[1] - a[1], b[2] - a[2], b[3] - a[3] }
    local len = math.sqrt(ab[1] ^ 2 + ab[2] ^ 2 + ab[3] ^ 2)
    local d = { ab[1] / len, ab[2] / len, ab[3] / len }
    local ap = { p[1] - a[1], p[2] - a[2], p[3] - a[3] }
    local d2 = d[1] * ap[1] + d[2] * ap[2] + d[3] * ap[3]

    bp = { a[1] + d2 * d[1], a[2] + d2 * d[2], a[3] + d2 * d[3] }

    return (bp[1] - x1) + (bp[2] - y1) + (bp[3] - z1)
end

local manual = { left = false, right = false, back = false, forward = false }
local aa = { legit = { cur_cmd = 0, prev_cmd = 0, blocked = false, released = false  } }
function aa:manual()
    ui.get(menu.anti_aim.keys.left, "On hotkey")
    ui.get(menu.anti_aim.keys.right, "On hotkey")
    ui.get(menu.anti_aim.keys.back, "On hotkey")
    ui.get(menu.anti_aim.keys.forward, "On hotkey")

    local m_state = ui.get(menu.anti_aim.keys.state)
    local left_state, right_state, backward_state, forward_state = ui.get(menu.anti_aim.keys.left), ui.get(menu.anti_aim.keys.right), ui.get(menu.anti_aim.keys.back), ui.get(menu.anti_aim.keys.forward)

    if left_state == manual.left and right_state == manual.right and backward_state == manual.back and forward_state == manual.forward then return end

    manual.left, manual.right,  manual.back, manual.forward = left_state, right_state, backward_state, forward_state

    if (left_state and m_state == 1) or (right_state and m_state == 2) or (backward_state and m_state == 3) or (forward_state and m_state == 4) then ui.set(menu.anti_aim.keys.state, 0) return end

    if left_state and m_state ~= 1 then ui.set(menu.anti_aim.keys.state, 1) end

    if right_state and m_state ~= 2 then ui.set(menu.anti_aim.keys.state, 2) end

    if backward_state and m_state ~= 3 then ui.set(menu.anti_aim.keys.state, 3) end

    if forward_state and m_state ~= 4 then ui.set(menu.anti_aim.keys.state, 4) end
end

function aa:backstab()
    local enemies = entity.get_players(true)
    local local_origin = vector(entity.get_origin(entity.get_local_player()))
    local is_near = false
    for i = 1, #enemies do
        local enemy_origin = vector(entity.get_origin(enemies[i]))
        local distance = local_origin:dist(enemy_origin)
        local weapon = entity.get_player_weapon(enemies[i])
        local class = entity.get_classname(weapon) --we get enemy's weapon here
        if distance < 230 and class == "CKnife" then return true end
    end
    return false
end

function aa:use(c)
    local legit_key = ui.get(menu.anti_aim.keys.legit)
    aa.legit.cur_cmd = c.chokedcommands

    if not legit_key then
        aa.legit.released = true
    end

    if not ((legit_key or aa.legit.blocked) and (aa.legit.cur_cmd > 0 or aa.legit.prev_cmd > 0)) then
        choked_commands_prev = choked_commands
        return
    end

    aa.legit.prev_cmd = aa.legit.cur_cmd

    local local_player = entity.get_local_player()
    local vecOrigin = vector(entity.get_prop(local_player, "m_vecOrigin"))

    local planted_bomb = entity.get_all("CPlantedC4")
    if planted_bomb[1] then
        if entity.get_prop(planted_bomb[1], "m_bBombTicking") == 1 and vecOrigin:dist(vector(entity.get_prop(planted_bomb[1], "m_vecOrigin"))) < 100 then
            return
        end
    end

    local hostages = entity.get_all("CHostage")

    for _, v in next, hostages do
        if vecOrigin:dist(vector(entity.get_prop(v, "m_vecOrigin"))) then
            return
        end
    end

    if aa.legit.released and not aa.legit.blocked then
        aa.legit.released, aa.legit.blocked = false, true
    end

    c.in_use = 0
    if aa.legit.blocked and aa.legit.cur_cmd == 0 then
        c.in_use = 1
        aa.legit.blocked = false
    end
end

function aa:manager()
    local status = ui.get(menu.anti_aim.opt)
    local preset = (status == "preset")
    local custom = (status == "custom")
    local builder = (status == "builder")

    if preset then
        storage.status = ui.get(menu.anti_aim.mode)
    end

    local info, choked = util:status(), globals.chokedcommands()

    if (not info[2] or ui.get(ref.fd)) and not info[1] then
        storage.status, storage.player = ui.get(menu.anti_aim.custom[8].preset), "duck"
    elseif info[1] and choked < 2 then
        storage.status, storage.player = ui.get(menu.anti_aim.custom[1].preset), "air"
    elseif info[1] and choked > 2 then
        storage.status, storage.player = ui.get(menu.anti_aim.custom[2].preset), "air f"    
    elseif ui.get(ref.slow[2]) then
        storage.status, storage.player = ui.get(menu.anti_aim.custom[6].preset), "slow walk"
    elseif info[3] >= 190 and choked > 2 then
        storage.status, storage.player = ui.get(menu.anti_aim.custom[5].preset), "full speed f"
    elseif info[3] >= 190 and choked < 2 then
        storage.status, storage.player = ui.get(menu.anti_aim.custom[4].preset), "full speed"
    elseif info[3] >= 120 and info[3] <= 190 then
        storage.status, storage.player = ui.get(menu.anti_aim.custom[4].preset), "running"
    elseif info[3] >= 68 and info[3] <= 120 then
        storage.status, storage.player = ui.get(menu.anti_aim.custom[4].preset), "accel"
    elseif info[3] > 5 and info[3] < 68 then
        storage.status, storage.player = ui.get(menu.anti_aim.custom[3].preset), "accel"
    elseif info[3] < 5 then
        storage.status, storage.player = ui.get(menu.anti_aim.custom[7].preset), "stand"
    end
end

function aa:bodyyaw()
    if client.current_threat() == nil then
        return { storage.anti_aim.bodyyaw[1], storage.anti_aim.bodyyaw[2] }
    end

    if storage.bruteforce.side[client.current_threat()] ~= nil then
        if storage.bruteforce.last >= globals.curtime() then
            return { -90 * storage.bruteforce.side[client.current_threat()], -90 * storage.bruteforce.side[client.current_threat()] }
        end

        storage.bruteforce.side[client.current_threat()] = 1
        return { storage.anti_aim.bodyyaw[1], storage.anti_aim.bodyyaw[2] }
    else
        storage.bruteforce.side[client.current_threat()] = 1
        return { storage.anti_aim.bodyyaw[1], storage.anti_aim.bodyyaw[2] }
    end
end

local cache = {
    last_tick = 0, jitter_increment = 0, switch = false, counter = 0, last_switch_tick = 0
}

function aa:slow_jitter(speed, frequency)
    local localplayer = entity.get_local_player()
    local tickbase = entity.get_prop(localplayer, "m_nTickbase")
    
    if cache.counter == nil then
        cache.counter = 0
    end

    if cache.last_switch_tick == nil then
        cache.last_switch_tick = globals.tickcount()
    end
    
    if cache.last_tick + speed < tickbase or cache.last_tick > tickbase then
        cache.last_tick = tickbase
        cache.jitter_increment = cache.jitter_increment + speed
        cache.counter = cache.counter + 1

        -- Add frequency control to the switch
        --print("tickcount :"..globals.tickcount().."| frequency :"..frequency.."| switch :"..tostring(cache.switch).."| counter :"..cache.counter)
        if globals.tickcount() - cache.last_switch_tick >= frequency then
            cache.switch = not cache.switch
            cache.last_switch_tick = globals.tickcount()
        end
    end
end

function aa:manualjitter(speed)
    local localplayer = entity.get_local_player()
    if localplayer == nil then
        return
    end

    local jitterspeed = speed
    --[[
        ^^ essentially what this does and the purpose of manually doing our jitter is;
        since the CS:GO riptide update, a bunch of animation & lagcompensation related shit has been broken, ie: eyeangles no longer lagcompensated, new setupbones function to keep shit in bbox, needing to predict a bunch of shit, etc.
        this is why wide jitter has become good, and desync has effectively been limited to like 30 degrees (the new setupbones func),
        because of whats stated above, hacks will have to predict our eyeangles for each tick of client to server latency.
        ex; enemy has 4 ticks of ping, assuming we are dting and also taking choked commands into account, they would expect us to jitter twice, so no prediction would be needed,
        (^^ note 4 % 2 == 0)
        BUT if they had 3 ticks of ping (3 % 2 == 1) our yaw wouldve changed by the time their shot is registered on the server, and since eyeangles are no longer lagcompensated, they would miss
        so to circumvent missing, they "predict" us to the opposite angle of our jitter (previous eyeangles) which should be where our head is at when their shot is registered.
        but of we jitter a different amount to what they expect for prediction, they will miss due to "misprediction" (neverlose log but skeet dont got that shit)
        so basically instead of doing dumbass placebo antiaim (jitter presets lol) we actually make them miss with logic :D
        this aa could be much better tho. (workin on dat)
    ]]

    local tickbase = entity.get_prop(localplayer, "m_nTickbase")
    if storage.anti_aim.ymca.last_tick + jitterspeed < tickbase or storage.anti_aim.ymca.last_tick > tickbase then
        storage.anti_aim.ymca.last_tick = tickbase
        storage.anti_aim.ymca.jitter_increment = storage.anti_aim.ymca.jitter_increment + 1
        storage.anti_aim.ymca.switch = not storage.anti_aim.ymca.switch 
    end

end

-- { yaw L, yaw R, jitter L, jitter R, body L, body R, fake L, fake R, body yaw mode, jitter mode } -- util:antiaim args

--fire handler
local data_condition = {fire = true}
local cache_fire = function()
    data_condition.fire = true
    client.delay_call(0.02, function()
        data_condition.fire = false
    end)
end
client.set_event_callback("aim_fire", cache_fire)
--
local function velocity()
    local me = entity.get_local_player()
    local velocity_x, velocity_y = entity.get_prop(me, "m_vecVelocity")
    return math.sqrt(velocity_x ^ 2 + velocity_y ^ 2)
end

local function inair()
    return (bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 0)
end

local function crouching()
    return (bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 4) == 0)
end

function aa:main(c)
    if not ui.get(menu.enable) or not ui.get(menu.anti_aim.enable) and not entity.is_alive(entity.get_local_player()) then
        return
    end

    storage.bruteforce.target = client.current_threat()
    aa:manager()

    local status = ui.get(menu.anti_aim.opt)
    local info, choked, cur_preset = util:status(), globals.chokedcommands(), status == "preset" and ui.get(menu.anti_aim.mode) or storage.status
    local last_side = util:contains(ui.get(menu.additives.opt), "anti-bruteforce") and storage.bruteforce.last >= globals.curtime() and storage.bruteforce.side[storage.bruteforce.target] or 1

    --local m_jitter = ui.get(menu.anti_aim.manual)
    aa:manualjitter((storage.anti_aim.ymca.jitter_increment % 3 == 0 and 2 or 1) + c.chokedcommands)
    -- if cur_preset == "maksur" then -- ymca
    --     -- we could do better than just -45 and 45 if we do want to add an element of resolver missing, but yaw L/R is MOSTLY placebo lol
    --     util:anti_aim(
    --         storage.anti_aim.ymca.switch and -45 or 45, storage.anti_aim.ymca.switch and -45 or 45,
    --         0, 0,end
    --         storage.anti_aim.ymca.switch and -90 or 90, storage.anti_aim.ymca.switch and -90 or 90,
    --         60, 60,
    --         "Static",storage.anti_aim
    --         "Off"
    --     )
    if not info[2] and not info[1] then -- duck
        if cur_preset == "smart" then util:anti_aim(15, 15, 0, 0, 0, 0, math.random(20, 50), math.random(20, 50), "Jitter", "Off") end
        if cur_preset == "euclid" then util:anti_aim(8, 8, 55, 55, -90 * last_side, -90 * last_side, 60, 60, "Jitter", "Skitter") end
        if cur_preset == "keter" then util:anti_aim(9, 21, 0, 0, -90, 90, 60, 60, "Static", "Off") end
        if cur_preset == "thaumiel" then util:anti_aim(-6, 14, 0, 0, 90, -90, 60, 60, "Static", "Offset") end
        if cur_preset == "apollyon" then util:anti_aim(-34, 37, 0, 0, -90, 90, 60, 60, "Static", "Off") end
        if cur_preset == "maksur" then util:anti_aim(-34, 37, 0, 0, -90, 90, 60, 60, "Static", "Off") end
    elseif info[1] and choked < 2 then -- air no fl
        if cur_preset == "smart" then util:anti_aim(5, 5, 0, 0, 90 * last_side, -90 * last_side, 60, 60, "Static", "Off") end
        if cur_preset == "euclid" then util:anti_aim(8, 8, 40, 40, 90, 90, 60, 60, "Static", "Skitter") end
        if cur_preset == "keter" then 
            if info[2] then -- standing
                util:anti_aim(-20, 44, 0, 0, 90 * last_side, 90 * last_side, 60, 60, "Static", "Off")
            else
                util:anti_aim(-10, 50, 0, 0, 90 * last_side, 90 * last_side, 60, 60, "Static", "Off")
            end
        end
        if cur_preset == "thaumiel" then 
            if info[2] then
                util:anti_aim(-22, 30, 0, 0, -90 * last_side, -90 * last_side, 60, 60, "Static", "Off")
            else
                util:anti_aim(-25, 35, 0, 0, -90 * last_side, -90 * last_side, 60, 60, "Static", "Off")
            end
        end
        if cur_preset == "apollyon" then 
            if info[2] then
                util:anti_aim(-25, 11, 0, 0, 90, -90, 60, 60, "Static", "Off")
            else
                util:anti_aim(-19, 29, 0, 0, 90, -90, 60, 60, "Static", "Off")
            end
        end
        if cur_preset == "maksur" then 
            if info[2] then
                util:anti_aim(-33, 35, 0, 0, -90, 90, 60, 60, "Static", "Off")
            else
                util:anti_aim(-30, 38, 0, 0, -90, 90, 60, 60, "Static", "Off")
            end
        end
    elseif info[1] and choked > 2 then -- air fl
        if cur_preset == "smart" then util:anti_aim(6, 6, 0, 0, 0, 0, 60, 60, "Jitter", "Off") end
        if cur_preset == "euclid" then util:anti_aim(9, 9, 7, 7, 90 * last_side, -90 * last_side, 60, 60, "Static", "Center") end
        if cur_preset == "keter" then util:anti_aim(6, 6, 28, 28, 0, 0, 60, 60, "Jitter", "Center") end
        if cur_preset == "thaumiel" then util:anti_aim(9, 9, 0, 0, 90, -90, 60, 60, "Static", "Center") end
        if cur_preset == "apollyon" then util:anti_aim(4, 10, 0, 0, 90 * last_side, -90 * last_side, 60, 60, "Static", "Off") end
        if cur_preset == "maksur" then util:anti_aim(-15, 35, 0, 0, -90, 90, 60, 60, "Static", "Off") end
    elseif ui.get(ref.slow[2]) then -- slow
        if cur_preset == "smart" then util:anti_aim(10, 10, 0, 0, 90 * last_side, 90 * last_side, 23, 23, "Static", "Off") end
        if cur_preset == "euclid" then util:anti_aim(-13, -13, 50, 50, 90 * last_side, -90 * last_side, 60, 60, "Jitter", "Skitter") end
        if cur_preset == "keter" then util:anti_aim(-25, 40, 0, 0, -90, 90, 60, 60, "Static", "Off") end
        if cur_preset == "thaumiel" then util:anti_aim(-35, 12, 0, 0, -90 * last_side, -90 * last_side, 60, 60, "Static", "Offset") end
        if cur_preset == "apollyon" then util:anti_aim(-45, 48, 0, 0, -90, 90, 60, 60, "Static", "Off") end
        if cur_preset == "maksur" then util:anti_aim(-40, 50, 0, 0, -90, 90, 60, 60, "Static", "Off") end
    elseif info[3] >= 190 and choked > 2 then -- max fl
        if cur_preset == "smart" then util:anti_aim(5, 5, 0, 0, 90 * last_side, -90 * last_side, 45, 45, "Static", "Off") end
        if cur_preset == "euclid" then util:anti_aim(-27, 42, 0, 0, -90 * last_side, 90 * last_side, 60, 60, "Static", "Offset") end
        if cur_preset == "keter" then util:anti_aim(-40, -40, 60, 60, math.random(90, -90), math.random(90, -90), 60, 60, "Static", "Offset") end
        if cur_preset == "thaumiel" then util:anti_aim(-22, -22, 52, 52, 90 * last_side, 90 * last_side, 60, 60, "Static", "Offset") end
        if cur_preset == "apollyon" then util:anti_aim(-25, 25, 0, 0, 90, -90, 60, 60, "Static", "Off") end
        if cur_preset == "maksur" then util:anti_aim(-45, 45, 0, 0, -90, 90, 60, 60, "Static", "Off") end
    elseif info[3] >= 190 and choked < 2 then -- max no fl
        if cur_preset == "smart" then util:anti_aim(5, 5, 0, 0, 90 * last_side, -90 * last_side, 45, 45, "Static", "Off") end
        if cur_preset == "euclid" then util:anti_aim(-5, -5, 57, 57, -90, 90, 60, 60, "Static", "Skitter") end
        if cur_preset == "keter" then util:anti_aim(-40, 20, 0, 0, math.random(90, -90), math.random(90, -90), 60, 60, "Static", "Off") end
        if cur_preset == "thaumiel" then util:anti_aim(-41, 15, 0, 0, -90 * last_side, -90 * last_side, 60, 60, "Static", "Off") end
        if cur_preset == "apollyon" then util:anti_aim(-15, 18, 0, 0, 90, -90, 58, 58, "Static", "Off") end
        if cur_preset == "maksur" then util:anti_aim(-35, 38, 0, 0, -7, 7, 60, 60, "Static", "Off") end
    elseif info[3] >= 120 and info[3] <= 190 then -- run
        if cur_preset == "smart" then util:anti_aim(5, 5, 0, 0, 90 * last_side, -90 * last_side, 45, 45, "Static", "Off") end
        if cur_preset == "euclid" then util:anti_aim(5, 5, 32, 34, -90, 90, 60, 60, "Static", "Skitter") end
        if cur_preset == "keter" then util:anti_aim(-18, 10, 0, 0, 90, -90, 60, 60, "Static", "Offset") end
        if cur_preset == "thaumiel" then util:anti_aim(-17, 36, 0, 0, 90 * last_side, 90 * last_side, 60, 60, "Static", "Off") end
        if cur_preset == "apollyon" then util:anti_aim(7, 20, 0, 0, 90, -90, 60, 60, "Static", "Offset") end
        if cur_preset == "maksur" then util:anti_aim(-30, 30, 0, 0, -90, 90, 60, 60, "Static", "Off") end
    elseif info[3] >= 68 and info[3] <= 120 then -- accel
        if cur_preset == "smart" then util:anti_aim(5, 5, 0, 0, 90 * last_side, -90 * last_side, 45, 45, "Static", "Off") end
        if cur_preset == "euclid" then util:anti_aim(0, 0, 45, 45, 0, 0, 60, 60, "Jitter", "Skitter") end
        if cur_preset == "keter" then util:anti_aim(-10, 30, 0, 0, 90, 90, 60, 60, "Static", "Offset") end
        if cur_preset == "thaumiel" then util:anti_aim(-25, 25, 0, 0, -90, 90, 60, 60, "Static", "Offset") end
        if cur_preset == "apollyon" then util:anti_aim(7, 20, 0, 0, 90, -90, 60, 60, "Static", "Offset") end
        if cur_preset == "maksur" then util:anti_aim(-25, 25, 0, 0, -90, 90, 60, 60, "Static", "Off") end
    elseif info[3] > 5 and info[3] < 68 then -- accel
        if cur_preset == "smart" then util:anti_aim(8, 8, 0, 0, 0, 0, 60, 60, "Jitter", "Off") end
        if cur_preset == "euclid" then util:anti_aim(12, 12, 37, 37, 180, 180, 38, 60, "Static", "Skitter") end
        if cur_preset == "keter" then util:anti_aim(-15, 24, 0, 0, 90, 90, 60, 60, "Static", "Center") end
        if cur_preset == "thaumiel" then util:anti_aim(-21, 3, 0, 0, -90 * last_side, -90 * last_side, 48, 48, "Static", "Offset") end
        if cur_preset == "apollyon" then util:anti_aim(-12, 16, 0, 0, 90, -90, 48, 48, "Static", "Offset") end
        if cur_preset == "maksur" then util:anti_aim(-25, 25, 0, 0, -90, 90, 60, 60, "Static", "Off") end
    elseif info[3] < 5 then -- stand
        if cur_preset == "smart" then util:anti_aim(7, 7, 0, 0, 90 * last_side, -90 * last_side, 60, 60, "Static", "Off") end
        if cur_preset == "euclid" then util:anti_aim(8, 8, 40, 40, 90 * last_side, 90 * last_side, 60, 60, "Static", "Skitter") end
        if cur_preset == "keter" then util:anti_aim(-22, 43, 0, 0, -90, 90, 60, 60, "Static", "Off") end
        if cur_preset == "thaumiel" then util:anti_aim(5, 29, 0, 0, 90 * last_side, 90 * last_side, 60, 60, "Static", "Off") end
        if cur_preset == "apollyon" then util:anti_aim(-15, 30, 0, 0, -90, 90, 60, 60, "Static", "Off") end
        if cur_preset == "maksur" then util:anti_aim(-23, 34, 0, 0, -90, 90, 60, 60, "Static", "Off") end
    end

    local keys = {
        edge = ui.get(menu.anti_aim.keys.edge),
        freestand = ui.get(menu.anti_aim.keys.freestand),
    }

    ui.set(ref.fs[2], "Always on")
    ui.set(ref.fs[1], keys.freestand)

    -- ui.set(ref.fs[1], "Default")
    ui.set(ref.edge, keys.edge)

    local local_player = entity.get_local_player()

    local status = ui.get(menu.anti_aim.opt)

    local crouch = (crouching() == false)
    local slowwalking = ui.get(ref.slow[2])
    local state = (slowwalking and 1) or ((inair() and (crouch and 5 or 6)) or (crouch and 4)) or (velocity() > 5 and 2 or 3)

    local should = {
        preset = (status == "preset") or (status == "custom"),
        builder = (status == "builder"),
        legit = ui.get(menu.anti_aim.keys.legit),
        manual = ui.get(menu.anti_aim.keys.state) ~= 0,
        --os_trigger = data_condition.fire == true and ui.get(menu.additives.reduce),
        backstab = util:contains(ui.get(menu.additives.opt), "anti-backstab") and aa:backstab(),
        height = util:contains(ui.get(menu.additives.opt), "height advantage") and util:height_advantage(ui.get(menu.additives.ang)),
        defensive = util:contains(ui.get(menu.additives.opt), "defensive in-air") and info[1] and ui.get(ref.dt[1]) and ui.get(ref.dt[2]),
        center = ui.get(Antiaim_d[state].yaw_jitter) == "Center",
        sway = ui.get(Antiaim_d[state].yaw_jitter) == "Sway",
        skitter = ui.get(Antiaim_d[state].yaw_jitter) == "Skitter",
        redact = ui.get(menu.additives.redacted) and info[1] and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CKnife" and info[3] > 220,
    }

    --- starts handling builder
    if should.builder then
        _vars.default_yaw_left = ui.get(Antiaim_d[state].yaw_slider_l)
        _vars.default_yaw_right = ui.get(Antiaim_d[state].yaw_slider_r)
        _vars.jitter_mode = ui.get(Antiaim_d[state].yaw_jitter)
        _vars.Jitter_slider = ui.get(Antiaim_d[state].yaw_jitter_slider)
        _vars.skitter_speed = ui.get(Antiaim_d[state].yaw_skitter_speed)
        _vars.frequency = ui.get(Antiaim_d[state].yaw_jitter_speed)
        _vars.sway_speed = ui.get(Antiaim_d[state].yaw_sway_speed)
        _vars.Bodyyaw_mode = ui.get(Antiaim_d[state].body_yaw)
        _vars.Bodyyaw_slider = ui.get(Antiaim_d[state].bodyyaw_slider)
        _vars.Bodyyaw_slider_add = ui.get(Antiaim_d[state].bodyyaw_slider_add)
    end

    local def_jitter_speed = _vars.frequency
    local def_jitter_yaw = 0
    if def_jitter_speed ~= 1 then
        def_jitter_yaw = ((cache.switch and _vars.default_yaw_left + _vars.Jitter_slider)
                                 or _vars.default_yaw_right -_vars.Jitter_slider)
    elseif def_jitter_speed == 1 then
        def_jitter_yaw = (util:builder_jitter(_vars.default_yaw_left + _vars.Jitter_slider, 
                    _vars.default_yaw_right -_vars.Jitter_slider))
    end
    local slider_1 = _vars.default_yaw_left 
    local slider2 = _vars.default_yaw_right
    local slider3 = _vars.sway_speed

    local def_jitter_mode = should.skitter and "Skitter" or "Off"
    local def_jitter_slider = (def_jitter_speed ~= 1 and cache.switch and _vars.Jitter_slider or -_vars.Jitter_slider) or 
                                (def_jitter_speed == 1 and util:builder_jitter(_vars.Jitter_slider or -_vars.Jitter_slider))
    local def_bodyyaw = _vars.Bodyyaw_mode
    local def_bodyyaw_s = 0
    if def_jitter_speed ~= 1 then
        def_bodyyaw_s = ((cache.switch and _vars.Bodyyaw_slider) or _vars.Bodyyaw_slider_add) 
    elseif def_jitter_speed == 1 then
        def_bodyyaw_s = util:builder_jitter(_vars.Bodyyaw_slider,  _vars.Bodyyaw_slider_add)
    end

    local def_fakelimit = _vars.fake_limit
    --- end


    --local fake_lag_trigger = (ui.get(ref.hs[2]) and not ui.get(ref.fd) and 1) or
    --                    (should.os_trigger and not ui.get(ref.fd) and 1) or 15

    --ui.set(ref.fl_limit, fake_lag_trigger)
    
    aa:manual()

    if not info[1] then
        aa:use(c)
    end

    local m_status = ui.get(menu.anti_aim.keys.state)

    if storage.bruteforce.target ~= nil then
        local e_o = vector(entity.get_origin(storage.bruteforce.target))
        local l_o = vector(entity.get_prop(local_player, "m_vecOrigin"))
        local distance = l_o:dist(e_o)

        if should.defensive and distance > 250 then
            local count = globals.tickcount() % 16 >= 4
    
            c.force_defensive = count
        end
    end

    local body_yaw = aa:bodyyaw()

    local handler = {
        pitch = (should.legit and "off") or
                ((should.manual or should.height) and "down") or
                (should.redact and "custom") and "custom" or
                "down",

        base = ((should.legit or should.manual) and "local view") or
               (should.backstab and "at targets") or
               "at targets",

        yaw = (should.legit and 180) or
              (((c.force_defensive and should.redact and not should.manual) and ui.get(menu.additives.o_2) == "default") and util:jitter(storage.anti_aim.yaw[1], storage.anti_aim.yaw[2], c)) or
              (((c.force_defensive and should.redact and not should.manual) and ui.get(menu.additives.o_2) == "revolve") and -85) or
              (should.manual and m_status == 1 and not ui.get(menu.anti_aim.keys.edge)) and -90 or
              (should.manual and m_status == 2 and not ui.get(menu.anti_aim.keys.edge)) and 90 or
              (should.manual and m_status == 3 and not ui.get(menu.anti_aim.keys.edge)) and 0 or
              (should.manual and m_status == 4 and not ui.get(menu.anti_aim.keys.edge)) and 180 or
              (should.backstab and 180) or
              (should.height and 0) or
              (should.preset and util:jitter(storage.anti_aim.yaw[1], storage.anti_aim.yaw[2], c)) or
              (should.builder and 
                (should.center and def_jitter_yaw) or
                (should.skitter and def_jitter_yaw) or
                (should.sway and util.sway(slider_1, slider_1, slider2, slider3))),

        jitter = ((should.manual or should.legit or should.backstab or should.os_trigger) and "off") or
                 (should.height and "off") or
                 (should.preset and storage.anti_aim.jitter_mode) or
                 (should.builder and def_jitter_mode),

        jitter_slider = (should.skitter and _vars.skitter_speed) or 0,

        body =  (should.os_trigger and "Off") or
                ((should.manual or should.height) and "static") or
                (should.preset and storage.anti_aim.body_yaw) or
                (should.builder and def_bodyyaw),

        body_yaw =  (should.height or should.manual) and 0 or 
                    ((c.force_defensive and should.redact and not should.manual and (ui.get(menu.additives.o_1) == "switch")) and util:jitter(90, -90, c)) or
                    ((c.force_defensive and should.redact and not should.manual and (ui.get(menu.additives.o_1) == "haywire")) and 90) or
                    (should.preset and util:jitter(body_yaw[1], body_yaw[2], c) or
                    (should.builder and def_bodyyaw_s)),

        jitter_speed = (def_jitter_speed),

        redacted = (ui.get(menu.additives.o_2) == "default" and 180) or
                   (ui.get(menu.additives.o_2) == "revolve" and "spin"),

        pitchredact = (ui.get(menu.additives.o_1) == "up" and -89) or
                      (ui.get(menu.additives.o_1) == "haywire" and math.random(-60, 80)) or
                      (ui.get(menu.additives.o_1) == "switch" and util:jitter(-40, 60, c)) or
                      (ui.get(menu.additives.o_1) == "down" and 89) or
                      (ui.get(menu.additives.o_1) == "off" and 0),
    }

    aa:slow_jitter((cache.jitter_increment % 3 == 0 and 2 or 1) + c.chokedcommands, handler.jitter_speed)

    if c.chokedcommands ~= 0 and should.builder then return end -- the extra check is prevent MISFIRES BARKING

    ui.set(ref.antiaim.pitch[1], handler.pitch)
    ui.set(ref.antiaim.pitch[2], (c.force_defensive and should.redact) and handler.pitchredact or 89)
    ui.set(ref.antiaim.yaw_base, handler.base)
    ui.set(ref.antiaim.yaw[1], (c.force_defensive and should.redact and not should.manual) and handler.redacted or "180")
    ui.set(ref.antiaim.jitter[2], util:jitter(storage.anti_aim.jitter[1], storage.anti_aim.jitter[2], c))
    ui.set(ref.antiaim.yaw[2], handler.yaw)
    ui.set(ref.antiaim.jitter[1], handler.jitter)
    ui.set(ref.antiaim.jitter[2], handler.jitter_slider)
    ui.set(ref.antiaim.body_yaw[1], handler.body)
    ui.set(ref.antiaim.body_yaw[2], handler.body_yaw)
    --ui.set(ref.antiaim.fake_limit, util:jitter(storage.anti_aim.fake_limit[1], storage.anti_aim.fake_limit[2], c))
end

local a = { speed_slider = { 0, 0, 0, 0 } }
local vis = { dt = 0, os = 0, velo = 0, baim = 0, sp = 0, speed = 0, shift = 0}
function vis:crosshair()
    if not entity.is_alive(entity.get_local_player()) or not ui.get(menu.visuals.enable) or not util:contains(ui.get(menu.visuals.opt), "crosshair") then
        return
    end

    local style = ui.get(menu.visuals.style)

    local x, y = client.screen_size()
    local mode = ui.get(menu.anti_aim.opt)
    local t_1, t_2 = (not ui.get(menu.anti_aim.enable) and "OFF") or (mode == "builder" and "builder") or (mode == "custom" and "custom") or (mode == "preset" and ui.get(menu.anti_aim.mode) or storage.status), (not ui.get(menu.anti_aim.enable) and "off") or storage.bruteforce.last >= globals.curtime() and "BRUTEFORCE" or storage.player

    local p, s, f, c, pulse = { ui.get(menu.visuals.pri) }, { ui.get(menu.visuals.sec) }, { ui.get(menu.visuals.spe) }, { ui.get(menu.visuals.cyc) }, math.sin(math.abs((math.pi * -1) + (globals.curtime() * (1 / 0.5)) % (math.pi * 2))) * 255
    local info = util:status()

    if info[3] > 30 and info[3] < 250  then
        a.speed_slider[1] = util:lerp(a.speed_slider[1], 255, globals.frametime() * 6)
        a.speed_slider[2] = util:lerp(a.speed_slider[2], 7, globals.frametime() * 6)
        a.speed_slider[3] = util:lerp(a.speed_slider[3], info[3], globals.frametime() * 6)
        a.speed_slider[4] = util:lerp(a.speed_slider[4], 255, globals.frametime() * 6)
        else if info[3] < 30 then
            a.speed_slider[4] = util:lerp(a.speed_slider[4], 0, globals.frametime() * 6)
            a.speed_slider[1] = util:lerp(a.speed_slider[1], 0, globals.frametime() * 6)
            a.speed_slider[2] = util:lerp(a.speed_slider[2], 0, globals.frametime() * 6)
            a.speed_slider[3] = util:lerp(a.speed_slider[3], 0, globals.frametime() * 6)
            else if a.speed_slider[3] > 250 then
                a.speed_slider[3] = 250
            else
                a.speed_slider[1] = 255
                a.speed_slider[2] = 7
            end
        end
    end

    if style == "standard" then
        local aA = util:clr_array(p[1], p[2], p[3])
        local test = string.format("\a%sF\a%sU\a%sM\a%sO\a%sS\a%sI\a%sG\a%sH\a%sT", util:rgba(unpack(aA[1])), util:rgba(unpack(aA[2])), util:rgba(unpack(aA[3])), util:rgba(unpack(aA[4])), util:rgba(unpack(aA[5])), util:rgba(unpack(aA[6])), util:rgba(unpack(aA[7])), util:rgba(unpack(aA[8])), util:rgba(unpack(aA[9])))
        local v_offset = 10

        vis.dt = util:lerp(vis.dt, (ui.get(ref.dt[1]) and ui.get(ref.dt[2])) and 1 or 0.5, globals.frametime() * 8)
        vis.os = util:lerp(vis.os, (ui.get(ref.hs[1]) and ui.get(ref.hs[2])) and 1 or 0.25, globals.frametime() * 8)
        vis.baim = util:lerp(vis.baim, ui.get(ref.baim) and 1 or 0.25, globals.frametime() * 8)
        vis.sp = util:lerp(vis.sp, ui.get(ref.safe) and 1 or 0.25, globals.frametime() * 8)
        vis.velo = util:lerp(vis.velo, info[3] > 100 and 1 or 0, globals.frametime() * 8)

        v_offset = v_offset + ((info[3] > 100) and math.ceil(vis.velo * 10) or math.floor(vis.velo * 10))
        re_render.render_container(x / 2 + 1, y / 2 + 32 + v_offset, a.speed_slider[3] / 6, 5, f[1], f[2], f[3], 255 * vis.velo)

        renderer.text(x / 2 + 1 + a.speed_slider[3] / 6, y / 2 + 29 + v_offset, f[1], f[2], f[3], info[1] and pulse or (255 * vis.velo), "-", nil, info[1] and "AIR" or math.floor(a.speed_slider[3]))

        renderer.text(x / 2, y / 2 + 40 + v_offset + (info[3] > 100 and - 2 or 0), (ui.get(ref.dt[2]) and not util:charge()) and 255 or 255, (ui.get(ref.dt[2]) and not util:charge()) and 0 or 255, (ui.get(ref.dt[2]) and not util:charge()) and 0 or 255, (255 * vis.dt) * (ui.get(ref.dt[2]) and (util:charge()) and 1 or 0.5) or 1, "-", nil, "DT")
        renderer.text(x / 2 + 11, y / 2 + 40 + v_offset + (info[3] > 100 and - 2 or 0), 255, 255, 255, (255 * ((ui.get(ref.dt[2]) and ui.get(ref.hs[2]) ) and (util:charge() and 0.5 or 0.5) or 1) * vis.os), "-", nil, "OS")
        renderer.text(x / 2 + 23, y / 2 + 40 + v_offset + (info[3] > 100 and - 2 or 0), 255, 255, 255, 255 * vis.baim, "-", nil, "BODY")
        renderer.text(x / 2 + 44, y / 2 + 40 + v_offset + (info[3] > 100 and - 2 or 0), 255, 255, 255, 255 * vis.sp, "-", nil, "SP")

        util:clr_text(x / 2, y / 2 + 40, "-", { { string.upper(t_1), s[1], s[2], s[3], 255 }, { " | ", 255, 255, 255, 255 }, { string.upper(t_2), p[1], p[2], p[3], 255 } }, 1)
        util:clr_text(x / 2, y / 2 + 30, "-", { { "FUMOSIGHT", c[1], c[2], c[3], 255 }, { "[ALEPH]", s[1], s[2], s[3], pulse } }, 1)
        util:clr_text(x / 2, y / 2 + 30, "-", { { test, 255, 255, 255, 255 }, { "[ALEPH]", s[1], s[2], s[3], pulse } }, 1)
    elseif style == "modern" then
        local aA = util:clr_array(c[1], c[2], c[3])
        local test = string.format("\a%sF\a%sU\a%sM\a%sO\a%sS\a%sI\a%sG\a%sH\a%sT", util:rgba(unpack(aA[1])), util:rgba(unpack(aA[2])), util:rgba(unpack(aA[3])), util:rgba(unpack(aA[4])), util:rgba(unpack(aA[5])), util:rgba(unpack(aA[6])), util:rgba(unpack(aA[7])), util:rgba(unpack(aA[8])), util:rgba(unpack(aA[9])))

        local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped")
        if scoped == 1 then
            self.shift = easing.bounce_out_in(1, self.shift, -0.15 - self.shift, 25)
        else
            self.shift = easing.bounce_out_in(1, self.shift, 1.00 - self.shift, 25)
        end

        local offset = 10
        local placeholder = string.format("rapid %s", util:clamp(storage.ticks, 0, 16))

        vis.dt = util:lerp(vis.dt, (ui.get(ref.dt[1]) and ui.get(ref.dt[2])) and 1 or 0, globals.frametime() * 8)
        vis.os = util:lerp(vis.os, (ui.get(ref.hs[1]) and ui.get(ref.hs[2])) and 1 or 0, globals.frametime() * 8)
        vis.sp = util:lerp(vis.sp, (ui.get(ref.safe)) and 1 or 0, globals.frametime() * 8)
        vis.baim = util:lerp(vis.baim, (ui.get(ref.baim)) and 1 or 0, globals.frametime() * 8)

        local offset = offset + ((ui.get(ref.dt[1]) and ui.get(ref.dt[2])) and math.ceil(vis.dt * 13) or math.floor(vis.dt * 13))
        renderer.text(x / 2 - renderer.measure_text("", "rapid") / 2 * self.shift - (1.00 - self.shift) / 2, y / 2 + 30 + offset, 255, 255, 255, 255 * vis.dt * (util:charge() and 1 or 0.5), "", nil, "rapid")

        local offset = offset + ((ui.get(ref.hs[1]) and ui.get(ref.hs[2])) and math.ceil(vis.os * 13) or math.floor(vis.os * 13))
        renderer.text(x / 2 - renderer.measure_text("", "onshot") / 2 * self.shift - (1.00 - self.shift), y / 2 + 30 + offset, 255, 255, 255, 255 * vis.os * (ui.get(ref.dt[2]) and (util:charge() and 0.5 or 0.5) or 1), "", nil, "onshot")

        local offset = offset + (ui.get(ref.safe) and math.ceil(vis.sp * 13) or math.floor(vis.sp * 13))
        renderer.text(x / 2 - renderer.measure_text("", "safe") / 2 * self.shift - (1.00 - self.shift), y / 2 + 30 + offset, 255, 255, 255, 255 * vis.sp, "", nil, "safe")

        local offset = offset + (ui.get(ref.baim) and math.ceil(vis.baim * 13) or math.floor(vis.baim * 13))
        renderer.text(x / 2 - renderer.measure_text("", "baim") / 2 * self.shift - (1.00 - self.shift), y / 2 + 30 + offset, 255, 255, 255, 255 * vis.baim, "", nil, "baim")

        renderer.text(x / 2 - (renderer.measure_text("-", "[ALEPH]") / 2 * self.shift) - (1.00 - self.shift), y / 2 + 30, s[1], s[2], s[3], pulse, "-", nil, "[ALEPH]")
        renderer.text(x / 2 - (renderer.measure_text("", "fumosight") / 2 * self.shift) - (1.00 - self.shift), y / 2 + 40, 255, 255, 255, 255, "b", nil, string.lower(test))
    end

    if avatar == nil then
        return
    end
end

function vis:add_log(i_1, i_2, i_3)
    local this = {
        alpha = -1,
        time = globals.realtime() + 5,
        attacker = i_1,
        side = i_2,
        ang = i_3
    }

    table.insert(storage.logs, 1, this)
    return this
end

function vis:bruteforce()
    local screen = { client.screen_size() }
    local pos = {screen[1] * 0.5, screen[2] * 0.88};
    local limit = 8;
    local smooth = 6 * 0.6;

    local flags = "-c";

    local logs_size = #storage.logs;
    for key = logs_size, 1, -1 do
        local value = storage.logs[ key ];

        if value.alpha == 1 then
            table.remove(storage.logs, key);
            goto skip
        end

        local p = { ui.get(menu.visuals.sec) }

        local alpha = 1 - math.abs(value.alpha);
        local x, y = pos[1] + 100 * value.alpha, pos[2];

        local string = string.format("FUMOSIGHT - BRUTEFORCE TRIGGERED BY %s | [SIDE: %s | ANGLE: %s]", string.upper(entity.get_player_name(value.attacker)), value.side, math.floor(value.ang))
        local text_sz = {renderer.measure_text(flags, string)};
        
        renderer.rectangle(x - text_sz[1] / 2 - 4, y - 1 - text_sz[2] / 2 - 4, text_sz[1] + 10, 24, 0, 0, 0, 125 * alpha)
        renderer.rectangle(x - text_sz[1] / 2 - 2, y - 1 - text_sz[2] / 2 - 2, text_sz[1] + 6, 20, 25, 25, 25, 75 * alpha)
        renderer.rectangle(x - text_sz[1] / 2 - 2, y - 1 - text_sz[2] / 2 - 2, util:clamp(((text_sz[1] + 6) * (math.abs(globals.realtime() - value.time - 5) / 5)) - text_sz[1], 0, ((text_sz[1] + 6) * (math.abs(globals.realtime() - value.time - 5) / 5)) - text_sz[1] ), 2, p[1], p[2], p[3], 255 * alpha)
        
        if value.alpha >= 1 then
            renderer.blur(x - text_sz[1] / 2 - 4, y - 1 - text_sz[2] / 2 - 4, text_sz[1] + 10, 24)
        end

        renderer.text(x, y + 2, 255, 255, 255, 200 * alpha, flags, 0, string);

        local height = text_sz[2] + 20;

        height = height * alpha;

        pos[2] = pos[2] - height;
        

        if (globals.realtime() - value.time > 0) or (key > limit) then
            value.alpha = util:lerp(value.alpha, 1, globals.frametime() * smooth);
        else
            value.alpha = util:lerp(value.alpha, 0, globals.frametime() * smooth);
        end

        ::skip::
    end
end 

function vis:debug()
    if not entity.is_alive(entity.get_local_player()) or not ui.get(menu.visuals.enable) or not ui.get(menu.visuals.debug) then
        return
    end

    local x, y = client.screen_size()
    local mode = ui.get(menu.anti_aim.opt)
    local t_1, t_2 = (not ui.get(menu.anti_aim.enable) and "OFF") or (mode == "builder" and "builder") or (mode == "custom" and "custom") or (mode == "preset" and ui.get(menu.anti_aim.mode) or storage.status), (not ui.get(menu.anti_aim.enable) and "off") or storage.bruteforce.last >= globals.curtime() and "BRUTEFORCE" or storage.player
    local p, s, f, c, pulse = { ui.get(menu.visuals.pri) }, { ui.get(menu.visuals.sec) }, { ui.get(menu.visuals.spe) }, { ui.get(menu.visuals.cyc) }, math.sin(math.abs((math.pi * -1) + (globals.curtime() * (1 / 0.5)) % (math.pi * 2))) * 255

    renderer.rectangle(13, y / 2 - 92, 154, 104, 0, 0, 0, 125)
    renderer.rectangle(15, y / 2 - 90, 150, 100, 25, 25, 25, 50)
    renderer.blur(15, y / 2 - 90, 150, 100)

    renderer.rectangle(90 - renderer.measure_text("-", "FUMOSIGHT | DEBUG PANEL") / 2, y / 2 - 70, (100 - renderer.measure_text("-", "FUMOSIGHT | DEBUG PANEL") / 2) * 1.8, 2, s[1], s[2], s[3], 255)
    renderer.rectangle(90 - renderer.measure_text("-", "FUMOSIGHT | DEBUG PANEL") / 2, y / 2 - 24, (100 - renderer.measure_text("-", "FUMOSIGHT | DEBUG PANEL") / 2) * 1.8, 1, s[1], s[2], s[3], 255)

    renderer.text(90 - renderer.measure_text("-", "FUMOSIGHT | DEBUG PANEL") / 2, y / 2 - 80, 255, 255, 255, 255, "-", nil, "FUMOSIGHT | DEBUG PANEL")
    renderer.text(90 - renderer.measure_text("-", string.format("TARGET: %s", storage.bruteforce.target == nil and "NONE" or string.upper(entity.get_player_name(storage.bruteforce.target)))) / 2, y / 2 - 60, 255, 255, 255, 255, "-", nil, string.format("TARGET: %s", storage.bruteforce.target == nil and "NONE" or string.upper(entity.get_player_name(storage.bruteforce.target))))
    renderer.text(90 - renderer.measure_text("-", string.format("PRESET: %s | %s", string.upper(t_1), string.upper(t_2))) / 2, y / 2 - 50, 255, 255, 255, 255, "-", nil, string.format("PRESET: %s | %s", string.upper(t_1), string.upper(t_2)))
    renderer.text(90 - renderer.measure_text("-", string.format("BRUTEFORCE: %s | %s", storage.bruteforce.last <= globals.curtime() and "INACTIVE" or (storage.bruteforce.side[storage.bruteforce.target] > 0 and "RIGHT" or "LEFT"), storage.bruteforce.last >= globals.curtime() and math.floor(storage.bruteforce.last - globals.curtime()) .. "s" or "0s")) / 2, y / 2 - 40, 255, 255, 255, 255, "-", nil, string.format("BRUTEFORCE: %s | %s", storage.bruteforce.last <= globals.curtime() and "INACTIVE" or (storage.bruteforce.side[storage.bruteforce.target] > 0 and "RIGHT" or "LEFT"), storage.bruteforce.last >= globals.curtime() and math.floor(storage.bruteforce.last - globals.curtime()) .. "s" or "0s"))
    renderer.text(90 - renderer.measure_text("-", "SHOPPY.GG/@MISFIRES") / 2, y / 2 - 15, 255, 255, 255, 255, "-", nil, "SHOPPY.GG/@MISFIRES")
end

function vis:stanky()
    if entity.is_alive(entity.get_local_player()) then
        local ent = lib.new(entity.get_local_player())
        ent:get_anim_overlay(6).weight = 1
        ent:get_anim_overlay(4).weight = 1
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
    end
end

function vis:static()
    if entity.is_alive(entity.get_local_player()) then
        local ent = lib.new(entity.get_local_player())
        ent:get_anim_overlay(4).weight = 0
        ent:get_anim_overlay(6).weight = 0
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 7)
    end
end

function aa:bruteforce(c)
    if not util:contains(ui.get(menu.additives.opt), "anti-bruteforce") then
        return
    end

    local ent = client.userid_to_entindex(c.userid);
    if not entity.is_dormant(ent) and entity.is_enemy(ent) then
        local enemy_pos = vector(entity.hitbox_position(ent, 0))
        local local_pos = vector(entity.hitbox_position(entity.get_local_player(), 0))
        local dist = ((c.y - enemy_pos.y)*local_pos.x - (c.x - enemy_pos.x)*local_pos.y + c.x*enemy_pos.y - c.y*enemy_pos.x) / math.sqrt((c.y-enemy_pos.y)^2 + (c.x - enemy_pos.x)^2)

        if math.abs(dist) <= 20 and entity.is_alive(entity.get_local_player()) and storage.bruteforce.last > 1e-7 and math.abs(dist) > 10 then
            storage.bruteforce.last = globals.curtime() + 5
            storage.bruteforce.ang[ent] = dist * storage.bruteforce.side[ent] * -1
            storage.bruteforce.side[ent] = storage.bruteforce.side[ent] * -1
    
            if util:contains(ui.get(menu.visuals.opt), "bruteforce logging") then
                vis:add_log(ent, storage.bruteforce.side[ent], storage.bruteforce.ang[ent])
            end
        end
    end
end

client.set_event_callback("paint_ui", function()
    local enable, selection = ui.get(menu.enable), ui.get(menu.selection)

    ui.set_visible(menu.selection, enable)

    ui.set_visible(menu.anti_aim.enable, enable and selection == "anti-aim")
    ui.set_visible(menu.anti_aim.opt, enable and selection == "anti-aim" and ui.get(menu.anti_aim.enable))
    ui.set_visible(menu.anti_aim.mode, enable and selection == "anti-aim" and ui.get(menu.anti_aim.opt) == "preset" and ui.get(menu.anti_aim.enable))
    for i = 1, 8 do
        util:visible(menu.anti_aim.custom[i], enable and selection == "anti-aim" and ui.get(menu.anti_aim.opt) == "custom" and ui.get(menu.anti_aim.enable))
    end
    util:visible(menu.anti_aim.keys, enable and selection == "anti-aim" and ui.get(menu.anti_aim.enable))

    ui.set_visible(menu.visuals.enable, enable and selection == "visuals")
    ui.set_visible(menu.visuals.opt, enable and selection == "visuals" and ui.get(menu.visuals.enable))
    ui.set_visible(menu.visuals.style, enable and selection == "visuals" and ui.get(menu.visuals.enable) and util:contains(ui.get(menu.visuals.opt), "crosshair") )
    ui.set_visible(menu.visuals.x_1, enable and selection == "visuals" and ui.get(menu.visuals.enable))
    ui.set_visible(menu.visuals.pri, enable and selection == "visuals" and ui.get(menu.visuals.enable))
    ui.set_visible(menu.visuals.x_2, enable and selection == "visuals" and ui.get(menu.visuals.enable))
    ui.set_visible(menu.visuals.sec, enable and selection == "visuals" and ui.get(menu.visuals.enable))
    ui.set_visible(menu.visuals.x_3, enable and selection == "visuals" and ui.get(menu.visuals.enable))
    ui.set_visible(menu.visuals.spe, enable and selection == "visuals" and ui.get(menu.visuals.enable))
    ui.set_visible(menu.visuals.x_4, enable and selection == "visuals" and ui.get(menu.visuals.enable))
    ui.set_visible(menu.visuals.debug, enable and selection == "visuals" and ui.get(menu.visuals.enable))
    ui.set_visible(menu.visuals.cyc, enable and selection == "visuals" and ui.get(menu.visuals.enable))
    ui.set_visible(menu.visuals.com, enable and selection == "visuals" and ui.get(menu.visuals.enable) and util:contains(ui.get(menu.visuals.opt), "animations"))

    ui.set_visible(menu.additives.enable, enable and selection == "additives")
    ui.set_visible(menu.additives.opt, enable and selection == "additives" and ui.get(menu.additives.enable))
    --ui.set_visible(menu.additives.reduce, enable and selection == "additives" and ui.get(menu.additives.enable))
    ui.set_visible(menu.additives.ang, enable and selection == "additives" and ui.get(menu.additives.enable) and util:contains(ui.get(menu.additives.opt), "height advantage"))
    ui.set_visible(menu.additives.expjitter, enable and selection == "additives")
    ui.set_visible(menu.additives.redacted, enable and selection == "additives" and ui.get(menu.additives.enable) and util:contains(ui.get(menu.additives.opt), "defensive in-air"))
    ui.set_visible(menu.additives.o_1, enable and selection == "additives" and ui.get(menu.additives.enable) and util:contains(ui.get(menu.additives.opt), "defensive in-air") and ui.get(menu.additives.redacted))
    ui.set_visible(menu.additives.o_2, enable and selection == "additives" and ui.get(menu.additives.enable) and util:contains(ui.get(menu.additives.opt), "defensive in-air") and ui.get(menu.additives.redacted))
    ui.set_visible(menu.anti_aim.keys.state, false)
    --ui.set_visible(menu.anti_aim.manual, selection == "anti-aim" and ui.get(menu.anti_aim.enable))

    util:visible(ref.antiaim, not enable)

    ui.set_visible(ref.edge, not enable)
    ui.set_visible(ref.fs[1], not enable)
    ui.set_visible(ref.fs[2], not enable)

    -- BUILDER
    local status = ui.get(menu.anti_aim.opt)
    local builder = (status == "builder") and enable and selection == "anti-aim"

    ui.set_visible(menu.anti_aim.builder_menu, builder)
    ui.set_visible(menu.anti_aim.config_export, builder)
    ui.set_visible(menu.anti_aim.config_import, builder)
    
    for i=1 , #AA_S do
        local set_visible = ui.get(menu.anti_aim.builder_menu) == AA_S[i]
        local visible = builder and set_visible and enable and selection == "anti-aim"
        local center = visible and ui.get(Antiaim_d[i].yaw_jitter) == "Center"
        local sway = visible and ui.get(Antiaim_d[i].yaw_jitter) == "Sway"
        local skitter = visible and ui.get(Antiaim_d[i].yaw_jitter) == "Skitter"
        ui.set_visible(Antiaim_d[i].yaw_slider_l, visible)
        ui.set_visible(Antiaim_d[i].yaw_slider_r, visible)
        ui.set_visible(Antiaim_d[i].yaw_jitter, visible)
        ui.set_visible(Antiaim_d[i].yaw_jitter_slider, center)
        ui.set_visible(Antiaim_d[i].yaw_skitter_speed, skitter)
        ui.set_visible(Antiaim_d[i].yaw_jitter_speed, center)
        ui.set_visible(Antiaim_d[i].yaw_sway_speed, sway)
        ui.set_visible(Antiaim_d[i].body_yaw, visible)
        ui.set_visible(Antiaim_d[i].bodyyaw_slider, visible)
        ui.set_visible(Antiaim_d[i].bodyyaw_slider_add, visible)
    end
end)

client.set_event_callback("round_start", function()
    y_vars = 0
    y_reversed = 0
    -- switcher = false
    -- cache.last_tick = 0
    -- cache.jitter_increment = 0
    -- cache.counter = 0
    cache.last_switch_tick = 0
    -- tickbase = 0
end)

client.set_event_callback("setup_command", function(c)
    aa:main(c)
end)

client.set_event_callback("paint", function()
    vis:debug()
    vis:crosshair()
    vis:bruteforce()
end)

client.set_event_callback("pre_render", function()
    if not util:contains(ui.get(menu.visuals.opt), "animations") then
        return
    end

    local opt = ui.get(menu.visuals.com)
    if opt == "stanky leg" then
        vis:stanky()
    elseif opt == "what??!?!" then
        vis:static()
    else
        return
    end
end)

client.set_event_callback("bullet_impact", function(c)
    aa:bruteforce(c)
end)

client.set_event_callback("shutdown", function()
    util:visible(ref.antiaim, true)
    ui.set_visible(ref.edge, true)
    ui.set_visible(ref.fs[2], true)

    if ent == nil then
        return
    end

    local ent = lib.new(entity.get_local_player())

    ent:get_anim_overlay(6).weight = 0
    ent:get_anim_overlay(4).weight = 1
    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 7)
end)

client.set_event_callback("round_start", function()
    storage.bruteforce.last = globals.curtime()
end)
