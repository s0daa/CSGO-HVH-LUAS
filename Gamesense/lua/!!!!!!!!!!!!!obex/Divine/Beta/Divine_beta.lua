-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local ffi = require("ffi")
local pui = require "pui"
local clipboard = require "gamesense/clipboard"
local base64 = require"gamesense/base64"
local c_entity = require("gamesense/entity")
local vector = require "vector"
local csgo_weapons  = require "gamesense/csgo_weapons"
local groups = pui.group("aa", "anti-aimbot angles")
local anti_aim = require "gamesense/antiaim_funcs"
local ease = require "gamesense/easing"
local screen = vector(client.screen_size())
local center = vector(screen.x/2, screen.y/2)
local obex_data = obex_fetch and obex_fetch() or {username = 'guccish', build = 'Source', discord=''}

local images = require "gamesense/images"
local http = require "gamesense/http"
picurl = "https://cdn.discordapp.com/attachments/1092831658010480661/1102313526506311832/rem.png"

local groups = pui.group("aa", "anti-aimbot angles")

local function label_anim(speed, r, g, b, a, ...)
    local text, final_text, curtime = table.concat({...}), '', globals.curtime()
    for i=0, #text do final_text = final_text..'\a'..('%02x%02x%02x%02x'):format(r, g, b, a*math.abs(1*math.cos(2*speed*curtime/4+i*5/30)))..text:sub(i, i) end
    return final_text
end

local function in_air(player)
    local flags = entity.get_prop(player, "m_fFlags")
    
    if bit.band(flags, 1) == 0 then
        return true
    end
    
    return false
end

function contains(t, v)
    for i, vv in pairs(t) do
        if vv == v then
            return true
        end
    end
    return false
end

local rgba_to_hex = function(b, c, d, e)
    return string.format('%02x%02x%02x%02x', b, c, d, e)
end

function clamp(x, minval, maxval)
    if x < minval then
        return minval
    elseif x > maxval then
        return maxval
    else
        return x
    end
end

local function text_fade_animation(x, y, speed, color1, color2, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10  
        local wave = math.cos(2 * speed * curtime / 4 + x / 100)
        local color = rgba_to_hex(
            lerp(color1.r, color2.r, clamp(wave, 0, 1)),
            lerp(color1.g, color2.g, clamp(wave, 0, 1)),
            lerp(color1.b, color2.b, clamp(wave, 0, 1)),
            color1.a
        ) 
        final_text = final_text .. '\a' .. color .. text:sub(i, i) 
    end
    
    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, "c-", nil, final_text .. "°")
end

function renderer.outlined_rounded_rectangle(x, y, w, h, r, g, b, a, radius, thickness)
    y = y + radius
    local data_circle = {
        {x + radius, y, 180},
        {x + w - radius, y, 270},
        {x + radius, y + h - radius * 2, 90},
        {x + w - radius, y + h - radius * 2, 0},
    }

    local data = {
        {x + radius, y - radius, w - radius * 2, thickness},
        {x + radius, y + h - radius - thickness, w - radius * 2, thickness},
        {x, y, thickness, h - radius * 2},
        {x + w - thickness, y, thickness, h - radius * 2},
    }

    for _, data in next, data_circle do
        renderer.circle_outline(data[1], data[2], r, g, b, a, radius, data[3], 0.25, thickness)
    end

    for _, data in next, data do
        renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
    end
end

local function charge(x, y, speed, r, g, b, a, text)
    local final_text = ""
    local curtime = globals.curtime()
    for i=0, #text do
        local color = rgba_to_hex(r, g, b, a*math.abs(1*math.cos(2*speed*curtime/4+i*5/30)))
        final_text = final_text..'\a'..color..text:sub(i, i)
    end

    renderer.text(x, y, r, g, b, a, "-c", nil, final_text)
end

local function animate_alpha(initial) 
    return math.sin(math.abs(math.pi+(globals.realtime())%(-math.pi*2)))*initial
end

function lerp(a, b, t)
    return a + (b - a) * t
end

local animated_text = ui.new_label("aa", "anti-aimbot angles", "xxxx")


local saved, config = nil


local tab = pui.combobox("aa", "anti-aimbot angles", "\vCategories", {"antihit", "generals"})
local m_iGlobals = {}
local m_gMiscellaneous = {}
local m_iAnti_hit = {}
local player_conditions = {[1] = "\aFFFFFFFF[ \a848484BBlowvel \aFFFFFFFF] ", [2] = "\aFFFFFFFF[ \a848484BBwalk \aFFFFFFFF] ", [3] = "\aFFFFFFFF[ \a848484BBaerobic \aFFFFFFFF] ", [4] = "\aFFFFFFFF[ \a848484BBaerial \aFFFFFFFF] ", [5] = "\aFFFFFFFF[ \a848484BBduck \aFFFFFFFF] ", [6] = "\aFFFFFFFF[ \a848484BBturtle \aFFFFFFFF] ", [7] = "\aFFFFFFFF[ \a848484BBfakelag \aFFFFFFFF] ", [8] = "\aFFFFFFFF[ \a848484BBfakecrouch \aFFFFFFFF] "}
local player_states = {[1] = "lowvel", [2] = "walk", [3] = "aerobic", [4] = "aerial", [5] = "duck", [6] = "turtle", [7] = "fakelag", [8] = "fakecrouch" }
local divinestring = "\vdivine "
local ragestring = "\vragebot\r > "
local miscstring = "\vmisc\r > "
local visualsstring = "\vvisuals\r > "

local gamesense = {
        enable = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
        pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
        jittertype = { ui.reference("AA", "Anti-aimbot angles", "yaw jitter")},
        yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
        bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
        yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw")},
        freestand = { ui.reference("AA", "anti-aimbot angles", "freestanding")},
        fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
        edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
        roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
        slow = { ui.reference("AA", "Other", "Slow motion") },
        fd = ui.reference("Rage", "Other", "Duck peek assist"),
        qp = {ui.reference("Rage", "Other", "Quick peek assist")},
        qpm = ui.reference('Rage', 'Other', 'Quick peek assist mode'),
        dt = {ui.reference("Rage", "Aimbot", "Double Tap")},
        baim = {ui.reference("Rage", "Aimbot", "Force body aim")},
        safe = {ui.reference("Rage", "Aimbot", "Force safe point")},
        dt_fl = ui.reference("Rage", "Aimbot", "Double tap fake lag limit"),
        hs = {ui.reference("AA", "Other", "On shot anti-aim")},
        silent = ui.reference("Rage", "Other", "Silent aim"),
        slow_motion = {ui.reference("AA", "Other", "Slow motion")},
        ping = {ui.reference("MISC", "Miscellaneous", "Ping spike")},
        legsref = ui.reference("AA", "Other", "Leg movement"),
        mindmg = ui.reference("rage", "aimbot", "minimum damage override")
    }           

local m_iClasses = {
    antihit = {
        m_iAnti_hit = {
            extras = groups:multiselect("anti-hit extras:", {"fakeland exploit", "break backtrack [logic]", "freestand", "manual yaw", "shorter headup"}),
            legitaaopt = groups:combobox("\vLegit \raa \vty\rpe:", {"\vJit\rter", "\vSta\rtic"}),
            leftbind = groups:label("\vmanual \rleft", 0),
            rightbind = groups:label("\vmanual \rright", 0),
            fsb = groups:label("\vfree\rstand", 0),
            staticfs = groups:checkbox("\vstatic \rfree\vstand\r"),
        },
            m_gConditionals = {
              conditions = groups:combobox("Conditions:", {"lowvel", "walk", "aerobic", "aerial", "duck", "turtle", "fakelag", "fakecrouch"}),
            }
        },
        
    generals = {
     m_iGlobals = {
        m_gIndicators = {
            m_sMasterSwitch = groups:checkbox("~ \bB0CEFFFF\bFFFFFFFF[Visuals]"),
            opts = groups:multiselect("\vIndicator \roptions:", {"center indicators", "min-dmg indicators", "debug panel", "side-watermark", "defensive-state"}),
            select = groups:combobox("\vsty\rle:", {"None", "new", "old", "modern"}),
            cindopt = groups:multiselect("\vindi\rcate:", {"double tap", "hideshots", "ping spike", "freestanding", "fake duck", "body aim", "safe point"}),
            dpselect = groups:multiselect("\vDe\rbug:", {"local data"}),
            col = groups:label("center \vindicators\r color:", {176, 206, 255}),
            syaw = groups:checkbox("Yaw \vside\r indicator", {176, 206, 255}),
            syawanims = groups:checkbox("vertical anims."),
            watermark = groups:label("side-\vwatermark\r color:", {176, 206, 255}),
            def_col = groups:label("\vdefensive\r color:", {176, 206, 255})
        }
      },
      m_bRagebot = {
        m_gRbotSwitch = groups:checkbox("~ \bB0CEFFFF\bFFFFFFFF[Ragebot features]"),
        m_gAutobaim = groups:checkbox(ragestring .. "Automatic Force-Body aim"),
        m_gAutobaimOpts = groups:multiselect("Force-Body aim Conds:", "enemy hp < x", "baim if lethal"),
        m_gAutobaimhp = groups:slider("enemy \vhp \r< \v x\r", 0, 100, 90),
        m_gAutosafe = groups:checkbox(ragestring .. "Automatic Force-Safe point"),
        m_gAutosafehp = groups:slider("enemy \vhp \r< \v x\r", 0, 100, 90),
        m_gAutosafeOpts = groups:multiselect("Force-Safe point Conds:", "enemy hp < x", "local slowwalk", "local duck"),
        m_gIdealpeek = groups:checkbox(ragestring .. "Idealpeek helper", 0),
        m_gIdealpeekOpts = groups:multiselect("\vIdeal\rpeek \vopts\r:", "double tap", "edge yaw", "optimize fake-lag"),
      },
      m_gMiscellaneous = {
        m_gMasterSwitch = groups:checkbox("~ \bB0CEFFFF\bFFFFFFFF[Miscellaneous]"),
        m_iClantag = groups:checkbox("\vClantag"),
        m_iTrashtalk = groups:checkbox("\vKillsay"),

        m_iAnimate = {
            csae = groups:checkbox("~ \bB0CEFFFF\bFFFFFFFF[Anim breakers.]"),
            opts = groups:multiselect("\vgeneral \ranims", {"pitch zero on land", "animate move lean"}),
            ground = groups:combobox("\vground \ranims", {"none", "jackson", "backwards", "jitter legs"}),
            air = groups:combobox("\vaerobic \ranims", {"none", "jackson", "falling"}),
            pzlast = groups:slider("pitch 0 \vlasting \rtime", 0, 10, 5),
            amlamount = groups:slider("\vlean \ramount", 0, 100, 100)
        },
        m_sConfigsLabel = groups:label("~ \bB0CEFFFF\bFFFFFFFF[configs]"),
        m_gExportation = groups:button("~ \bB0CEFFFF\bFFFFFFFF[export]", function ()
            saved = config:save()
        end),
        m_gImportation = groups:button("~ \bB0CEFFFF\bFFFFFFFF[import]", function ()
            config:load(saved)
        end)
    },
  }
}

m_iClasses.generals.m_bRagebot.m_gAutobaim:depend({m_iClasses.generals.m_bRagebot.m_gRbotSwitch, true})
m_iClasses.generals.m_bRagebot.m_gAutosafe:depend({m_iClasses.generals.m_bRagebot.m_gRbotSwitch, true})

m_iClasses.generals.m_bRagebot.m_gAutobaimOpts:depend({m_iClasses.generals.m_bRagebot.m_gRbotSwitch, true}, {m_iClasses.generals.m_bRagebot.m_gAutobaim, true})
m_iClasses.generals.m_bRagebot.m_gAutobaimhp:depend({m_iClasses.generals.m_bRagebot.m_gRbotSwitch, true}, {m_iClasses.generals.m_bRagebot.m_gAutobaim, true}, {m_iClasses.generals.m_bRagebot.m_gAutobaimOpts, "enemy hp < x"})

m_iClasses.generals.m_bRagebot.m_gAutosafe:depend({m_iClasses.generals.m_bRagebot.m_gRbotSwitch, true})
m_iClasses.generals.m_bRagebot.m_gAutosafeOpts:depend({m_iClasses.generals.m_bRagebot.m_gRbotSwitch, true}, {m_iClasses.generals.m_bRagebot.m_gAutosafe, true})
m_iClasses.generals.m_bRagebot.m_gAutosafehp:depend({m_iClasses.generals.m_bRagebot.m_gRbotSwitch, true}, {m_iClasses.generals.m_bRagebot.m_gAutosafe, true}, {m_iClasses.generals.m_bRagebot.m_gAutosafeOpts, "enemy hp < x"})

m_iClasses.generals.m_gMiscellaneous.m_gExportation:depend({m_iClasses.generals.m_gMiscellaneous.m_gMasterSwitch, true})
m_iClasses.generals.m_gMiscellaneous.m_gImportation:depend({m_iClasses.generals.m_gMiscellaneous.m_gMasterSwitch, true})

m_iClasses.generals.m_bRagebot.m_gIdealpeek:depend({m_iClasses.generals.m_bRagebot.m_gRbotSwitch, true})
m_iClasses.generals.m_bRagebot.m_gIdealpeekOpts:depend({m_iClasses.generals.m_bRagebot.m_gRbotSwitch, true}, {m_iClasses.generals.m_bRagebot.m_gIdealpeek, true})

m_iClasses.generals.m_iGlobals.m_gIndicators.syaw:depend({m_iClasses.generals.m_iGlobals.m_gIndicators.m_sMasterSwitch, true})
m_iClasses.generals.m_iGlobals.m_gIndicators.syawanims:depend({m_iClasses.generals.m_iGlobals.m_gIndicators.m_sMasterSwitch, true}, {m_iClasses.generals.m_iGlobals.m_gIndicators.syaw, true})
m_iClasses.generals.m_iGlobals.m_gIndicators.watermark:depend({m_iClasses.generals.m_iGlobals.m_gIndicators.m_sMasterSwitch, true})
m_iClasses.generals.m_iGlobals.m_gIndicators.opts:depend({m_iClasses.generals.m_iGlobals.m_gIndicators.m_sMasterSwitch, true})
m_iClasses.generals.m_iGlobals.m_gIndicators.col:depend({m_iClasses.generals.m_iGlobals.m_gIndicators.opts, "center indicators"}, {m_iClasses.generals.m_iGlobals.m_gIndicators.m_sMasterSwitch, true})
m_iClasses.generals.m_iGlobals.m_gIndicators.select:depend({m_iClasses.generals.m_iGlobals.m_gIndicators.opts, "center indicators"}, {m_iClasses.generals.m_iGlobals.m_gIndicators.m_sMasterSwitch, true})

m_iClasses.generals.m_iGlobals.m_gIndicators.def_col:depend({m_iClasses.generals.m_iGlobals.m_gIndicators.opts, "defensive-state"}, {m_iClasses.generals.m_iGlobals.m_gIndicators.m_sMasterSwitch, true})

m_iAnti_hit_side =  {
    side = 0
}

function m_iAnti_hit.detect_state(cmd)
    local player = entity.get_local_player()
    local velox, veloy = entity.get_prop(player, "m_vecVelocity")
    local standing = math.sqrt(velox ^ 2 + veloy ^ 2) < 2  and cmd.in_duck == 0 and cmd.in_jump == 0
    local aero = cmd.in_jump == 1 and cmd.in_duck == 0
    local crouching = cmd.in_duck == 1 and cmd.in_jump == 0
    local aerial = cmd.in_jump == 1 and cmd.in_duck == 1
    local turtle = ui.get(gamesense.slow_motion[1]) and ui.get(gamesense.slow_motion[2])

    if not standing then
        m_iAnti_hit_side.side = "walk"
    end

    if turtle then
        m_iAnti_hit_side.side = "turtle"
    end

    if aero then
        m_iAnti_hit_side.side = "aerobic"
    end

    if aerial then
        m_iAnti_hit_side.side = "aerial"
    end

    if crouching then
        m_iAnti_hit_side.side = "duck"
    end

    if standing then
        m_iAnti_hit_side.side = "lowvel"
    end

    if not ui.get(gamesense.dt[2]) and not ui.get(gamesense.hs[2]) then
        m_iAnti_hit_side.side = "fakelag"
    end

    if ui.get(gamesense.fd) then
        m_iAnti_hit_side.side = "fakecrouch"
    end
end

local pitchstring = "\a848484BBpitch"
m_iAnti_hit.m_iConditional = {}

for i = 1, #player_states do

    m_iAnti_hit.m_iConditional[i] = {

                pitch = groups:combobox(divinestring .. player_conditions[i] .. "\a848484BBpitch", {"off", "default", "up", "down", "minimal", "random"}),
                base = groups:combobox(divinestring .. player_conditions[i] .. "\a848484BByaw base", {"at targets", "local view"}),
                offset_style = groups:combobox(divinestring .. player_conditions[i] .. "\a848484BBmanipulation:", {"default", "tick delay"}),
                yaw = groups:combobox(divinestring .. player_conditions[i] .. "\a848484BByaw", {"off", "static", "jitter left/right", "slow-jit meta"}),

                tick_delay = groups:slider(divinestring .. player_conditions[i] .. "\a848484BByaw speed:", 1, 25, 2, true, "tk"),
                tickleft = groups:slider(divinestring .. player_conditions[i] .. "\a848484BBleft", -180, 180, 0),
                tickright = groups:slider(divinestring .. player_conditions[i] .. "\a848484BBright" , -180, 180, 0),

                delay = groups:slider(divinestring .. player_conditions[i] .. "\a848484BByaw jitter delay", 0, 10, 5),
                yawstatic = groups:slider(divinestring .. player_conditions[i] .. "\a848484BBstatic", -180, 180, 0),
                yawleft = groups:slider(divinestring .. player_conditions[i] .. "\a848484BByaw left" , -180, 180, 0),
                yawright = groups:slider(divinestring .. player_conditions[i] .. "\a848484BByaw right" , -180, 180, 0),
                yawslow = groups:slider(divinestring .. player_conditions[i] .. "\a848484BBslow-Jit" , -180, 180, 0),
                yawjitter = groups:combobox(divinestring .. player_conditions[i] .. "\a848484BByaw jitter type", {"off", "offset", "center", "skitter", "5-Ways", "custom left/right" , "offset left/right", "center left/right"}),
                


                delay1 = groups:slider(divinestring .. player_conditions[i] .. "\a848484BBjitter delay", 0, 10, 5),
                yawjitdef = groups:slider(divinestring .. player_conditions[i] .. "\a848484BByaw offset value", -180, 180, 0),
                delay2 = groups:slider(divinestring .. player_conditions[i] .. "\a848484BByaw jitter offset delay", 0, 10, 5),
                yawjitleft = groups:slider(divinestring .. player_conditions[i] .. "\a848484BByaw jitter left" , -180, 180, 0),
                yawjitright = groups:slider(divinestring .. player_conditions[i] .. "\a848484BByaw jitter right" , -180, 180, 0),
                yawjitclrl = groups:slider(divinestring .. player_conditions[i] .. "\a848484BBjitter left" , -180, 180, 0),
                yawjitclrr = groups:slider(divinestring .. player_conditions[i] .. "\a848484BBjitter right" , -180, 180, 0),
                bodyyaw = groups:combobox(divinestring .. player_conditions[i] .. "\a848484BBbody yaw", {"off", "opposite", "jitter", "static", "focus static left/right", "focus jitter/static"}),
                bodyyawdef = groups:slider(divinestring .. player_conditions[i] .. "\a848484BBbody yaw value" , -180, 180, 0),
                bodyyawfsl = groups:slider(divinestring .. player_conditions[i] .. "\a848484BBbody yaw left" , -180, 180, 0),
                bodyyawfsr = groups:slider(divinestring .. player_conditions[i] .. "\a848484BBbody yaw right" , -180, 180, 0),
                defensive = groups:combobox(divinestring .. player_conditions[i] .. "\a848484BBdefensive", {"off", "smart", "on"})
            }

            if i ~= 0 then
                m_iAnti_hit.m_iConditional[i].pitch:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"})
                m_iAnti_hit.m_iConditional[i].base:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"})
                m_iAnti_hit.m_iConditional[i].offset_style:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"})
                m_iAnti_hit.m_iConditional[i].delay:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].offset_style, "default"}, {m_iAnti_hit.m_iConditional[i].yaw, "jitter left/right"})
                m_iAnti_hit.m_iConditional[i].yaw:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].offset_style, "default"})
                m_iAnti_hit.m_iConditional[i].yawstatic:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yaw, "static"}, {m_iAnti_hit.m_iConditional[i].offset_style, "default"})
                m_iAnti_hit.m_iConditional[i].yawleft:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yaw, "jitter left/right"}, {m_iAnti_hit.m_iConditional[i].offset_style, "default"})
                m_iAnti_hit.m_iConditional[i].yawright:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yaw, "jitter left/right"}, {m_iAnti_hit.m_iConditional[i].offset_style, "default"})
                m_iAnti_hit.m_iConditional[i].yawslow:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yaw, "slow-jit meta"}, {m_iAnti_hit.m_iConditional[i].offset_style, "default"})
                m_iAnti_hit.m_iConditional[i].yawjitter:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"})
                m_iAnti_hit.m_iConditional[i].bodyyaw:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {m_iAnti_hit.m_iConditional[i].offset_style, "tick delay", true}, {tab, "antihit"})

                m_iAnti_hit.m_iConditional[i].tick_delay:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].offset_style, "tick delay"})
                m_iAnti_hit.m_iConditional[i].tickleft:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].offset_style, "tick delay"})
                m_iAnti_hit.m_iConditional[i].tickright:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].offset_style, "tick delay"})


                m_iAnti_hit.m_iConditional[i].yawjitright:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yawjitter, "offset left/right"})
                m_iAnti_hit.m_iConditional[i].yawjitleft:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yawjitter, "offset left/right"})
                m_iAnti_hit.m_iConditional[i].delay2:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yawjitter, "offset left/right"})

                m_iAnti_hit.m_iConditional[i].delay1:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yawjitter, "center left/right"})
                m_iAnti_hit.m_iConditional[i].yawjitclrl:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yawjitter, "center left/right"})
                m_iAnti_hit.m_iConditional[i].yawjitclrr:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yawjitter, "center left/right"})

                m_iAnti_hit.m_iConditional[i].yawjitdef:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yawjitter, "center left/right", true}, {m_iAnti_hit.m_iConditional[i].yawjitter, "offset left/right", true}, {m_iAnti_hit.m_iConditional[i].yawjitter, "off", true}, {m_iAnti_hit.m_iConditional[i].yawjitter, "offset/center left/right", true}, {m_iAnti_hit.m_iConditional[i].yawjitter, "7-Ways", true}, {m_iAnti_hit.m_iConditional[i].yawjitter, "5-Ways", true})
                m_iAnti_hit.m_iConditional[i].bodyyawfsl:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {m_iAnti_hit.m_iConditional[i].offset_style, "tick delay", true}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].bodyyaw, "focus static left/right"})
                m_iAnti_hit.m_iConditional[i].bodyyawfsr:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {m_iAnti_hit.m_iConditional[i].offset_style, "tick delay", true}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].bodyyaw, "focus static left/right"})
                m_iAnti_hit.m_iConditional[i].bodyyawdef:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {m_iAnti_hit.m_iConditional[i].offset_style, "tick delay", true}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].bodyyaw, "focus static left/right", true}, {m_iAnti_hit.m_iConditional[i].bodyyaw, "off", true})
                m_iAnti_hit.m_iConditional[i].defensive:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"})


                
            end
end



m_iClasses.generals.m_iGlobals.m_gIndicators.select:depend({m_iClasses.generals.m_iGlobals.m_gIndicators.opts, "center indicators"}, {m_iClasses.generals.m_iGlobals.m_gIndicators.m_sMasterSwitch, true})
m_iClasses.generals.m_iGlobals.m_gIndicators.dpselect:depend({m_iClasses.generals.m_iGlobals.m_gIndicators.opts, "debug panel"}, {m_iClasses.generals.m_iGlobals.m_gIndicators.m_sMasterSwitch, true})
m_iClasses.generals.m_iGlobals.m_gIndicators.watermark:depend({m_iClasses.generals.m_iGlobals.m_gIndicators.opts, "side-watermark"}, {m_iClasses.generals.m_iGlobals.m_gIndicators.m_sMasterSwitch, true})
m_iClasses.generals.m_iGlobals.m_gIndicators.cindopt:depend({m_iClasses.generals.m_iGlobals.m_gIndicators.select, "None", true}, {m_iClasses.generals.m_iGlobals.m_gIndicators.m_sMasterSwitch, true})
m_iClasses.antihit.m_iAnti_hit.legitaaopt:depend({m_iClasses.antihit.m_iAnti_hit.extras, "legit aa on use"})
m_iClasses.antihit.m_iAnti_hit.leftbind:depend({m_iClasses.antihit.m_iAnti_hit.extras, "manual yaw"})
m_iClasses.antihit.m_iAnti_hit.rightbind:depend({m_iClasses.antihit.m_iAnti_hit.extras, "manual yaw"})
m_iClasses.antihit.m_iAnti_hit.fsb:depend({m_iClasses.antihit.m_iAnti_hit.extras, "freestand"})
m_iClasses.antihit.m_iAnti_hit.staticfs:depend({m_iClasses.antihit.m_iAnti_hit.extras, "freestand"})
m_iClasses.generals.m_gMiscellaneous.m_iClantag:depend({m_iClasses.generals.m_gMiscellaneous.m_gMasterSwitch, true})
m_iClasses.generals.m_gMiscellaneous.m_iTrashtalk:depend({m_iClasses.generals.m_gMiscellaneous.m_gMasterSwitch, true})
m_iClasses.generals.m_gMiscellaneous.m_sConfigsLabel:depend({m_iClasses.generals.m_gMiscellaneous.m_gMasterSwitch, true})
m_iClasses.generals.m_gMiscellaneous.m_iAnimate.csae:depend({m_iClasses.generals.m_gMiscellaneous.m_gMasterSwitch, true})
m_iClasses.generals.m_gMiscellaneous.m_iAnimate.opts:depend({m_iClasses.generals.m_gMiscellaneous.m_iAnimate.csae, true}, {m_iClasses.generals.m_gMiscellaneous.m_gMasterSwitch, true})
m_iClasses.generals.m_gMiscellaneous.m_iAnimate.ground:depend({m_iClasses.generals.m_gMiscellaneous.m_iAnimate.csae, true}, {m_iClasses.generals.m_gMiscellaneous.m_gMasterSwitch, true})
m_iClasses.generals.m_gMiscellaneous.m_iAnimate.air:depend({m_iClasses.generals.m_gMiscellaneous.m_iAnimate.csae, true}, {m_iClasses.generals.m_gMiscellaneous.m_gMasterSwitch, true})
m_iClasses.generals.m_gMiscellaneous.m_iAnimate.pzlast:depend({m_iClasses.generals.m_gMiscellaneous.m_iAnimate.opts, "pitch zero on land"}, {m_iClasses.generals.m_gMiscellaneous.m_gMasterSwitch, true})
m_iClasses.generals.m_gMiscellaneous.m_iAnimate.amlamount:depend({m_iClasses.generals.m_gMiscellaneous.m_iAnimate.opts, "animate move lean"}, {m_iClasses.generals.m_gMiscellaneous.m_gMasterSwitch, true})

local get_entities = function(enemy_only, alive_only)
    local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true
    
    local result = {}
    local player_resource = entity.get_player_resource()
    
    for player = 1, globals.maxplayers() do
        local is_enemy, is_alive = true, true
        
        if enemy_only and not entity.is_enemy(player) then is_enemy = false end
        if is_enemy then
            if alive_only and entity.get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
            if is_alive then table.insert(result, player) end
        end
    end

    return result
end

local weapon_is_enabled = function(idx)
	if (idx == 38 or idx == 11) then
		return true
	elseif (idx == 40) then
		return true
	elseif (idx == 9) then
		return true
	elseif (idx == 64) then
		return true
	elseif (idx == 1) then
		return true
	end
	return false
end

local is_lethal = function(player)
    local local_player = entity.get_local_player()
    if local_player == nil or not entity.is_alive(local_player) then return end
    local local_origin = vector(entity.get_prop(local_player, "m_vecAbsOrigin"))
    local distance = local_origin:dist(vector(entity.get_prop(player, "m_vecOrigin")))
    local enemy_health = entity.get_prop(player, "m_iHealth")

	local weapon_ent = entity.get_player_weapon(entity.get_local_player())
	if weapon_ent == nil then return end
	
	local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
	if weapon_idx == nil then return end
	
	local weapon = csgo_weapons[weapon_idx]
	if weapon == nil then return end

	if not weapon_is_enabled(weapon_idx) then return end

	local dmg_after_range = (weapon.damage * math.pow(weapon.range_modifier, (distance * 0.002))) * 1.25
	local armor = entity.get_prop(player,"m_ArmorValue")
	local newdmg = dmg_after_range * (weapon.armor_ratio * 0.5)
	if dmg_after_range - (dmg_after_range * (weapon.armor_ratio * 0.5)) * 0.5 > armor then
		newdmg = dmg_after_range - (armor / 0.5)
	end
	return newdmg >= enemy_health
end

local logicskekw = function()
    local players = get_entities(true, true)
    for i=1, #players do
		local idx = players[i]
        if idx == nil then end
        local m_iHealth = entity.get_prop(idx, 'm_iHealth')
    if m_iClasses.generals.m_bRagebot.m_gAutobaim:get() then
    if (m_iHealth < m_iClasses.generals.m_bRagebot.m_gAutobaimhp:get()) and (m_iClasses.generals.m_bRagebot.m_gAutobaimOpts:get("enemy hp < x")) then
        plist.set(idx, "Override prefer body aim", "Force")
    elseif (m_iHealth > m_iClasses.generals.m_bRagebot.m_gAutobaimhp:get()) or not m_iClasses.generals.m_bRagebot.m_gAutobaimOpts:get("enemy hp < x") then
        plist.set(idx, "Override prefer body aim", "-")
    end
    if is_lethal(idx) and m_iClasses.generals.m_bRagebot.m_gAutobaimOpts:get("baim if lethal") then
        plist.set(idx, "Override prefer body aim", "Force") 
    else
        plist.set(idx, "Override prefer body aim", "-")
    end
end
if m_iClasses.generals.m_bRagebot.m_gAutosafe:get() then
           if (m_iHealth < m_iClasses.generals.m_bRagebot.m_gAutosafehp:get()) and m_iClasses.generals.m_bRagebot.m_gAutosafe:get("enemy hp < x") then
              plist.set(idx, "Override safe point", "On")
            elseif (m_iHealth > m_iClasses.generals.m_bRagebot.m_gAutosafehp:get()) or not m_iClasses.generals.m_bRagebot.m_gAutosafe:get("enemy hp < x") then
              plist.set(idx, "Override safe point", "Off")
          end
    end
end
end

client.set_event_callback("setup_command", logicskekw)

local stat = {
    [0] = "Always on",
    [1] = "On hotkey",
    [2] = "Toggle",
    [3] = "Off hotkey"
}

local dtcache = {ui.get(gamesense.dt[2])}
local cacheddata = false

local function ipeekrun()
    local lp = entity.get_local_player()

    if not entity.is_alive(lp) then return end
      if m_iClasses.generals.m_bRagebot.m_gIdealpeek:get() and m_iClasses.generals.m_bRagebot.m_gIdealpeek:get_hotkey() == true and ui.get(gamesense.qp[2]) then

       local toggled = "Always on"

          if not entity.is_alive(lp) then return end
             if cacheddata then
                dtcache = {ui.get(gamesense.dt[2])}
                cacheddata = false
             end 
            if m_iClasses.generals.m_bRagebot.m_gIdealpeekOpts:get()[1] then
               ui.set(gamesense.dt[2], toggled)
            else 
                return
            end
            if m_iClasses.generals.m_bRagebot.m_gIdealpeekOpts:get()[2] then
                  ui.set(gamesense.edgeyaw, true)
            else 
                return
            end
       else
           if not cacheddata then
               ui.set(gamesense.dt[2], stat[dtcache[2]])
               ui.set(gamesense.edgeyaw, false)
               cacheddata = true
           end
      end
   end

   client.set_event_callback("setup_command", function(cmd)
    ipeekrun()
   end)

local m_gCtP

local m_gCtOrds = {
	'✧ d',
    '✧ di',
    '✧ div',
    '✧ divi',
    '✧ divin',
    '✧ divine',
    '✧ divine.',
    '✧ divine.g',
    '✧ divine.gs ',
    '✧ divine.g ',
    '✧ divine. ',
    '✧ divine ',
    '✧ divin ',
    '✧ divi',
    '✧ div',
    '✧ di',
    '✧ d'
}

function m_fClantag()
    if not m_iClasses.generals.m_gMiscellaneous.m_iClantag:get() then client.set_clan_tag("") return end
    local m_fSwitchDelay = math.floor(globals.tickcount() / 35) % #m_gCtOrds
  	local m_bClantag = m_gCtOrds[m_fSwitchDelay+1]

  	    if m_bClantag ~= m_gCtP then
    	       m_gCtP = m_bClantag
    	      client.set_clan_tag(m_bClantag)
  	    end
end
client.set_event_callback('net_update_end', function()
    m_fClantag()
end)

local ground_ticks  = 180
client.set_event_callback("pre_render", function(cmd)
    local self = entity.get_local_player()
    if not self or not entity.is_alive(self) then
        return
    end

    local self_index = c_entity.new(self)
    local self_anim_state = self_index:get_anim_state()

    local me = entity.get_local_player()
    if not me or not entity.is_alive(me) then return end

    local flags = entity.get_prop(me, "m_fFlags")
    if m_iClasses.generals.m_gMiscellaneous.m_iAnimate.air:get() == "falling" then 
        entity.set_prop(me, "m_flPoseParameter", 1, 6) 
    end
    if m_iClasses.generals.m_gMiscellaneous.m_iAnimate.opts:get("pitch zero on land") then 
    ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0
    if ground_ticks > 20 and ground_ticks < 160 then
        entity.set_prop(me, "m_flPoseParameter", 0.5, 12)
    end
    end

    if m_iClasses.generals.m_gMiscellaneous.m_iAnimate.air:get() == "jackson" and in_air(me) then 
    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 7)
        local my_animlayer = self_index:get_anim_overlay(6);
        my_animlayer.weight = 1;
        entity.set_prop(self_index, "m_flPoseParameter", 1, 6)
    end

    
    if m_iClasses.generals.m_gMiscellaneous.m_iAnimate.opts:get("animate move lean") then 
    local velox, veloy = entity.get_prop(me, "m_vecVelocity")
    local standing = math.sqrt(velox ^ 2 + veloy ^ 2) < 2
    if not standing then
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then
            return
        end

            self_anim_overlay.weight = 1
    end
    end

    if m_iClasses.generals.m_gMiscellaneous.m_iAnimate.ground:get() == "jackson" and not in_air(me) then 
        local me = entity.get_local_player()
        local flags = entity.get_prop(me, "m_fFlags")
        local vel1, vel2, vel3 = entity.get_prop(me, 'm_vecVelocity')
        local speed = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))
        local walking = speed >= 2
        if walking then
        ui.set(gamesense.legsref, "Never slide")
        entity.set_prop(self_index, "m_flPoseParameter", 1, 6)
            local my_animlayer = self_index:get_anim_overlay(6);
            my_animlayer.weight = 1;
            entity.set_prop(self_index, "m_flPoseParameter", 1, 6)
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 7)
        end
    end
    if m_iClasses.generals.m_gMiscellaneous.m_iAnimate.ground:get() == "backwards" and not in_air(me) then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
        ui.set(gamesense.legsref, "Always slide")
    end

end)

client.set_event_callback("setup_command", function(cmd)
    is_on_ground = cmd.in_jump == 0
 
    if m_iClasses.generals.m_gMiscellaneous.m_iAnimate.ground:get() == "jitter legs" then 
        ui.set(gamesense.legsref, cmd.command_number % 3 == 0 and "Off" or "Always slide")
    end
end)

local enemy_death = {
	"why u so dead bro?",
	"imagination is so huge that i can see that i fuck your all holes at the same time",
	"bro u should stop jumpin' on my dick",
	"why u always have to ride me ?",
	"gotta go fast",
	"cia is bussin' on u",
	"imagine dyin'",
	"divine.gs on top",
	"discord.gg/divinelua for unhittable aa",
	"why dont u just delete cs?",
	"you should fuck yourself",
	"i know everything but when your dad comes back",
	"bomba arabia",
	"u are so crazy on fuck",
	"damn bro your ass so deep",
	"gothic' fan dude",
	"kys"
}

local function killsay(e)
    if not m_iClasses.generals.m_gMiscellaneous.m_iTrashtalk:get() then return end

	local attacker_idx = client.userid_to_entindex(e.attacker)
	local kurban = client.userid_to_entindex(e.userid)
	local lp = entity.get_local_player()

	if attacker_idx ~= lp or kurban == lp then
		return
	end
	
	client.exec("say "..enemy_death[client.random_int(1, #enemy_death)])
end

animation_variables = {};

function animation_variables.lerp(a, b, t)
    return a + (b - a) * t
end

function animation_variables.pulsate(alpha, min, max, speed)
    local threshold = 0.01
    local new_change = true
    if alpha >= max - threshold then
        new_change = false
    elseif alpha <= min + threshold then
        new_change = true
    end

    if new_change == true then
        alpha = animation_variables.lerp(alpha, max, globals.frametime() * speed)
    else
        alpha = animation_variables.lerp(alpha, min, globals.frametime() * speed)
    end

    return alpha 
end

function animation_variables.movement(offset, when, original, new_place, speed)
    if when then
        offset = animation_variables.lerp(offset, new_place, globals.frametime() * speed)
    else
        offset = animation_variables.lerp(offset, original, globals.frametime() * speed)
    end

    return offset 
end

function animation_variables.fade(alpha, fade_bool, f_in, f_away, speed) 
    if fade_bool then
        alpha = animation_variables.lerp(alpha, f_in, globals.frametime() * speed)
    else
        alpha = animation_variables.lerp(alpha, f_away, globals.frametime() * speed)
    end

    return alpha
end


local function create_color_array(r, g, b, length)
	local colors = {}
	for i = 0, length do
		local color = {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + i * 5 / 30))}
		table.insert(colors, color)
	end
	return colors
end

local function modify_text(r, g, b, ...)
	local output = ''
	local str = table.concat({...})
	local aA = create_color_array(r, g, b, #str)

	for i, color in ipairs(aA) do
		output = output .. string.format('\a%s', string.format('%.2x%.2x%.2x%.2x', unpack(color))) .. string.sub(str, i, i)
	end

	return output
end


local m_render = { rec = function(self, x, y, w, h, radius, color) radius = math.min(x/2, y/2, radius) local r, g, b, a = unpack(color) renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a) renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a) renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a) renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25) renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25) renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25) renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25) end, rec_outline = function(self, x, y, w, h, radius, thickness, color) radius = math.min(w/2, h/2, radius) local r, g, b, a = unpack(color) if radius == 1 then renderer.rectangle(x, y, w, thickness, r, g, b, a) renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a) else renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a) renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a) renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a) renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a) renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness) renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness) renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness) renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness) end end, glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner) local thickness = 1 local offset = 1 local r, g, b, a = unpack(accent) if accent_inner then self:rec(x , y, w, h + 1, rounding, accent_inner) end for k = 0, width do if a * (k/width)^(1) > 5 then local accent = {r, g, b, a * (k/width)^(2)} self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent) end end end }


alpha_pulse = 0
offset_move = 0
offset_move_syaw = 0
offset_move2 = 0
dtoffset = 0
duckoffset = 0
alpha_fade = 0
dmgoffset = 0
pingoffset = 0
fsoffset = 0
baimoffset = 0
safeoffset = 0

defensive_anim = 0
non_defensive_anim = 0

local key = ui.reference("rage", "aimbot", "minimum damage override")

local image 
http.get(picurl, function(s, r)
    if s and r.status == 200 then
        image = images.load(r.body)
    else
        error("Failed to load: " .. response.status_message)
    end
end)

client.set_event_callback("paint", function()
    if not m_iClasses.generals.m_iGlobals.m_gIndicators.opts:get("side-watermark") then return end
    local x = center.x 
    local y = center.y
    if image ~= nil then
        image:draw(x/100, y, 60, 55)
    end

    local texts = {
        "USER:",
        "BUILD:"
    }
    local sizes = {}
    for i = 1, #texts do
        sizes[i] = {}
        sizes[i].x, sizes[i].y = renderer.measure_text(nil, texts[i])
    end
    local y_pos = y + 20
    local r,g,b = m_iClasses.generals.m_iGlobals.m_gIndicators.watermark:get_color()
    renderer.text(x/12 - 1,y_pos, 255, 255, 255, 255, "-c", 0, "USER: ")
    renderer.text(x/12 + sizes[1].x,y_pos, 255, 255, 255, 255, "-c", 0, string.upper(obex_data.username))
    renderer.text(x/12 + sizes[1].x,y_pos, 255, 255, 255, 255, "-c", 0, modify_text(r, g, b, string.upper(obex_data.username)))
    y_pos = y_pos + sizes[1].y
    renderer.text(x/12,y_pos, 255, 255, 255, 255, "-c", 0, "BUILD: ")
    renderer.text(x/12 + sizes[2].x,y_pos, r, g, b, animate_alpha(255), "-c", 0, "NIGHTLY")


end)



menu = {
    mouse = ui.new_hotkey("LUA", "B", "Mouse 1", true, 0x0001)
}



local x2,y2 = client.screen_size()
local rec1, rec2 = x2-x2+40, y2-(y2/2)
local dbg_x, dbg_y = (x2-x2)+40, (y2-y2/2)
local x_m, y_m = (x2-x2/1.89)+40, (y2-y2/1.3)

local m_bBackupDmg = ui.reference("Rage", "Aimbot", "Minimum Damage")
local m_iOverride, m_iActivate, m_iDamageVal = ui.reference("Rage", "Aimbot", "Minimum Damage Override")

local m_ftTime_defensive = 0
local m_tDefensive = false

function m_fVisuals()
    local x = center.x 
    local y = center.y
    local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1
    local r,g,b = m_iClasses.generals.m_iGlobals.m_gIndicators.col:get_color()
    local measure = renderer.measure_text("bc", "divine.sys")
    local check = m_iClasses.generals.m_iGlobals.m_gIndicators.opts:get("center indicators")
    local dropbox = m_iClasses.generals.m_iGlobals.m_gIndicators.cindopt
    local offsetttt = 0

    if m_iClasses.generals.m_iGlobals.m_gIndicators.opts:get("min-dmg indicators") then
        if ui.get(m_iActivate) then 
            renderer.text(x + 15, y - 15, 255,255,255,255, "c", nil, ui.get(m_iDamageVal))
        else
            renderer.text(x + 15, y - 15, 255,255,255,255, "c", nil, ui.get(m_bBackupDmg))
        end
    end

    if m_iClasses.generals.m_iGlobals.m_gIndicators.opts:get("debug panel") then
    local cursx, cursy = ui.mouse_position()
    local player = entity.get_local_player()
    local alive = entity.is_alive(player)
    if not player or not alive then return end
    local side = anti_aim.get_desync(1)
    if side >= 0 then side = "right" else side = "left" end
    local me = entity.get_local_player()
  
    if not me or not entity.is_alive(me) then
        return
    end
  
    local idx = client.current_threat()

    if ui.get(menu.mouse) then
        if (cursx < (dbg_x + 150)) and (cursx > (dbg_x-30)) and (cursy < (dbg_y + 90)) and (cursy > (dbg_y-30)) then
            dbg_x, dbg_y = cursx, cursy
        else
            dbg_x , dbg_y = dbg_x, dbg_y
        end
    end
  
        local textl = {
            "Current state:",
            "Current desync:",
            "Current desync side:",
            "Current LBY:",
            "Current overlap:",
            "Current choke:"
        }
        local sizel = {}
        for i = 1, #textl do
            sizel[i] = {}
            sizel[i].x, sizel[i].y = renderer.measure_text(nil, textl[i])
        end
        local y_angs = dbg_y - 15
    if m_iClasses.generals.m_iGlobals.m_gIndicators.dpselect:get("local data") then

    renderer.text(dbg_x -25, y_angs, 255, 255, 255, 255, nil, nil, "Current state:")
    renderer.text(dbg_x+sizel[1].x - 20, y_angs, 255, 255, 255, 255, nil, nil, "~ " .. m_iAnti_hit_side.side .. " ~")
    y_angs = y_angs + sizel[1].y
    renderer.text(dbg_x-25, y_angs, 255, 255, 255, 255, nil, 98, "Current desync:")
    renderer.text(dbg_x+sizel[2].x - 16, y_angs, 255, 255, 255, 255, nil, 19, anti_aim.get_desync(1))
    y_angs = y_angs + sizel[2].y
    renderer.text(dbg_x-25, y_angs, 255, 255, 255, 255, nil, "nil", "Current desync side:")
    renderer.text(dbg_x +sizel[3].x - 20, y_angs, 255, 255, 255, 255, nil, nil, side)
    y_angs = y_angs + sizel[3].y
    renderer.text(dbg_x-25, y_angs, 255, 255, 255, 255, nil, 80, "Current LBY:  ")
    renderer.text(dbg_x+sizel[4].x - 20, y_angs, 255, 255, 255, 255, nil, 80, entity.get_prop(entity.get_local_player(), "m_flLowerBodyYawTarget"))
    y_angs = y_angs + sizel[4].y
    renderer.text(dbg_x-25, y_angs, 255, 255, 255, 255, nil, nil, "Current overlap:")
    renderer.text(dbg_x+sizel[5].x - 20, y_angs, 255, 255, 255, 255, nil, 15, anti_aim.get_overlap() * 100 .. "%")
    y_angs = y_angs + sizel[5].y
    renderer.text(dbg_x-25, y_angs, 255, 255, 255, 255, nil, nil, "Current choke:")
    renderer.text(dbg_x+sizel[6].x - 20, y_angs, 255, 255, 255, 255, nil, nil, globals.chokedcommands())
    y_angs = y_angs + sizel[6].y
    end
end

    if m_iClasses.generals.m_iGlobals.m_gIndicators.syaw:get() then 
        if m_iClasses.generals.m_iGlobals.m_gIndicators.syawanims:get() then
        offset_move_syaw = animation_variables.movement(offset_move_syaw, scoped, 0, 20, 6)
        else
        offset_move_syaw = 0
        end
        renderer.triangle(x - 60, y - 10 - offset_move_syaw, x - 75, y - offset_move_syaw, x - 60, y + 10 - offset_move_syaw, 0, 0, 0, 100)
        renderer.triangle(x + 60, y - 10 - offset_move_syaw, x + 75, y - offset_move_syaw, x + 60, y + 10  - offset_move_syaw, 0, 0, 0, 100)
        renderer.gradient(x + 56, y - 10 - offset_move_syaw, 2, 20, 0, 0, 0, 100, 0, 0, 0, 100, false)
        renderer.gradient(x - 56, y - 10 - offset_move_syaw, 2, 20, 0, 0, 0, 100, 0, 0, 0, 100, false)
        if anti_aim.get_desync(2) > 0 then
            renderer.gradient(x + 56, y - 10 - offset_move_syaw, 2, 20, r, g, b, 200, r, g, b, 200, false)
        elseif anti_aim.get_desync(2) <= 0 then
            renderer.gradient(x - 56, y - 10 - offset_move_syaw, 2, 20, r, g, b, 200, r, g, b, 200, false)
        end
        if m_iClasses.antihit.m_iAnti_hit.leftbind:get_hotkey() then
            renderer.triangle(x - 60, y - 10 - offset_move_syaw, x - 75, y, x - 60, y + 10, r, g, b, 220)
        elseif m_iClasses.antihit.m_iAnti_hit.rightbind:get_hotkey() then
            renderer.triangle(x + 60, y - 10 - offset_move_syaw, x + 75, y, x + 60, y + 10, r, g, b, 220)
        end
      end

    if not check then return end

    offset_move2 = animation_variables.movement(offset_move2, scoped, 0, 16, 4)
    fsoffset = animation_variables.movement(fsoffset, m_iClasses.antihit.m_iAnti_hit.fsb:get_hotkey(), 0, 20, 8)
    dmgoffset = animation_variables.movement(dmgoffset, ui.get(gamesense.mindmg), 0, 20, 8)
    pingoffset = animation_variables.movement(pingoffset, ui.get(gamesense.ping[2]), 0, 20, 8)
    dtoffset = animation_variables.movement(dtoffset, ui.get(gamesense.dt[2]) or ui.get(gamesense.hs[2]), 0, 20, 8)
    duckoffset = animation_variables.movement(duckoffset, ui.get(gamesense.fd), 0, 20, 8)
    baimoffset = animation_variables.movement(baimoffset, ui.get(gamesense.baim[1]), 0, 20, 8)
    safeoffset = animation_variables.movement(safeoffset, ui.get(gamesense.safe[1]), 0, 20, 8)

    if  m_iClasses.generals.m_iGlobals.m_gIndicators.select:get() == "old" then
        renderer.text(x, y + 10, 255,255,255,255, "-", 0, "DIVINE")
        renderer.text(x + 25, y + 10, r, g, b, animate_alpha(255), "-", 0, "BETA")
        renderer.text(x, y + 18, 150, 177, 255, 255, "-", 0, 'FAKE  YAW: ')
        renderer.text(x + 44, y + 23, 255,255,255, 255, "-c", 9, anti_aim.get_desync())
    
    
        if ui.get(gamesense.dt[2]) and ui.get(gamesense.hs[2]) then
    
            renderer.text(x, y + 26, 50, 205, 50, animate_alpha(255), "-", 0, "DT")
    
        elseif ui.get(gamesense.dt[2]) and not ui.get(gamesense.hs[2]) then
            if anti_aim.get_double_tap() == true then
            renderer.text(x, y + 26, 50, 205, 50, 255, "-", 0, "DT")
            elseif anti_aim.get_double_tap() == false then
            renderer.text(x, y + 26, 200, 0, 0, 255, "-", 0, "DT")
            end
        end
    
        if ui.get(gamesense.hs[2]) and not ui.get(gamesense.dt[2]) then
            renderer.text(x, y + 26, 255, 194, 179, 255, "-", 0, 'ONSHOT')
        end
    
        if not ui.get(gamesense.hs[2]) and not ui.get(gamesense.dt[2]) then
            renderer.text(x, y + 26, 255, 255, 255, ui.get(gamesense.baim[1]) and 255 or 100, "-", 0, 'BAIM')
            renderer.text(x + 20, y + 26, 255, 255, 255, ui.get(gamesense.safe[1]) and 255 or 100, "-", 0, 'SP')
            renderer.text(x + 32, y + 26, 255, 255, 255, m_iClasses.antihit.m_iAnti_hit.fsb:get_hotkey() and 255 or 100, "-", 0, 'FS')
        
        else 
            renderer.text(x, y + 26 + 8, 255, 255, 255, ui.get(gamesense.baim[1]) and 255 or 100, "-", 0, 'BAIM')
            renderer.text(x + 20, y + 26 + 8, 255, 255, 255, ui.get(gamesense.safe[1]) and 255 or 100, "-", 0, 'SP')
            renderer.text(x + 32, y + 26 + 8, 255, 255, 255, m_iClasses.antihit.m_iAnti_hit.fsb:get_hotkey() and 255 or 100, "-", 0, 'FS')
        end
        
        offsetttt = offsetttt + 10

    elseif m_iClasses.generals.m_iGlobals.m_gIndicators.select:get() == "new" then
    offset_move = animation_variables.movement(offset_move, scoped, 0, 25, 5)
    renderer.text(x + offset_move * 1.1, y + 25, 0, 0, 0, 255, 'bc', nil, 'divine.lua')
    renderer.text(x + offset_move * 1.1, y + 25, 255, 255, 255, 255, 'bc', nil, modify_text(r, g, b, 'divine.lua'))
    m_render:glow_module(x - measure/2 + offset_move * 1.1 , y + 25, measure, 0, 10 , 0, {r, g, b, animate_alpha(90)}, {r, g, b, animate_alpha(90)})
    renderer.text(x + offset_move * 1.1, y + 15, 255, 255, 255, animate_alpha(255), '-c', nil, 'NIGHTLY')

    renderer.text(x + offset_move * 0.9,  y + 34 + offsetttt, 255, 255, 255, 255, "-c", nil, "{-" .. string.upper(m_iAnti_hit_side.side) .. "-}")
    offsetttt = offsetttt + 10
    if ui.get(gamesense.dt[2]) and anti_aim.get_double_tap() and not ui.get(gamesense.qp[2]) and dropbox:get("double tap") then
        renderer.text(x + offset_move2 * 1.3, y + 13.5 + offsetttt + dtoffset, 255, 255, 255, 220, "-c", nil, "RAPID")
        offsetttt = offsetttt + 10
    elseif ui.get(gamesense.dt[2]) and not anti_aim.get_double_tap() and not ui.get(gamesense.qp[2]) and dropbox:get("double tap") then
        renderer.text(x + offset_move2 * 1.3, y + 13.5 + offsetttt + dtoffset, 200, 0, 0, 255, "-c", nil, "RAPID")
        offsetttt = offsetttt + 10
    elseif ui.get(gamesense.qp[2]) and ui.get(gamesense.dt[2]) and anti_aim.get_double_tap() and dropbox:get("double tap") then
        renderer.text(x + offset_move2 * 1.8, y + 13.5 + offsetttt + dtoffset, 255, 255, 255, 255, "-c", nil, "~READY TICK")
        offsetttt = offsetttt + 10
    elseif ui.get(gamesense.qp[2]) and ui.get(gamesense.dt[2]) and not anti_aim.get_double_tap() and dropbox:get("double tap") then
        renderer.text(x + offset_move2 * 1.8, y + 13.5 + offsetttt + dtoffset, 200, 0, 0, 255, "-c", nil, "~WAITING TICK")
        offsetttt = offsetttt + 10
    elseif ui.get(gamesense.hs[2]) and not ui.get(gamesense.dt[2]) and dropbox:get(hideshots) then
        renderer.text(x + offset_move2 * 1.2, y + 13.5 + offsetttt + dtoffset, 136,207,52, 220, "-c", 0, "OSAA")
        offsetttt = offsetttt + 10
    end
    if ui.get(gamesense.fd) and dropbox:get("fake duck") then
        renderer.text(x + offset_move2 * 1.2, y + 13.5 + offsetttt + duckoffset, 150, 150, 150, 255, "-c", 0, "DUCK")
        offsetttt = offsetttt + 10
    end
    if m_iClasses.antihit.m_iAnti_hit.fsb:get_hotkey() and dropbox:get("freestanding") then
        renderer.text(x + offset_move2 * 0.9, y + 13.5 + offsetttt + fsoffset, 240, 255, 71, 255, "-c", 0, "FS")
        offsetttt = offsetttt + 10
    end
    if ui.get(gamesense.ping[2]) and dropbox:get("ping spike") then
        renderer.text(x + offset_move2 * 1.1, y + 13.5 + offsetttt + pingoffset, 132, 195, 16, 255, "-c", 0, "PING")
        offsetttt = offsetttt + 10
    end

    if ui.get(gamesense.baim[1]) and dropbox:get("body aim") then 
        renderer.text(x + offset_move2 * 1.1, y + 13.5 + offsetttt + baimoffset, 225, 230, 235, 240, "-c", 0, "BAIM")
        offsetttt = offsetttt + 10
    end
    if ui.get(gamesense.safe[1]) and dropbox:get("safe point") then 
        renderer.text(x + offset_move2 * 1.1, y + 13.5 + offsetttt + safeoffset, 225, 230, 235, 240, "-c", 0, "SAFE")
        offsetttt = offsetttt + 10
    end

    if ui.get(gamesense.dt[2]) and not ui.get(gamesense.qp[2]) and dropbox:get("double tap") then
        renderer.text(x - 3 + offset_move, y + 15 + offsetttt + dtoffset, 255, 255, 255, dtoffset * 12.75, "-c", nil, "DT")
        offsetttt = offsetttt + 10
    elseif ui.get(gamesense.qp[2]) and ui.get(gamesense.dt[2]) and anti_aim.get_double_tap() and dropbox:get("double tap") then
        renderer.text(x + offset_move, y + 15 + offsetttt + dtoffset, 255, 255, 255, dtoffset * 12.75, "-c", nil, "IDEALPEEK")
        offsetttt = offsetttt + 10
    elseif ui.get(gamesense.qp[2]) and ui.get(gamesense.dt[2]) and not anti_aim.get_double_tap() and dropbox:get("double tap") then
        renderer.text(x + offset_move, y + 15 + offsetttt + dtoffset, 200, 0, 0, dtoffset * 12.75, "-c", nil, "IDEALPEEK")
        offsetttt = offsetttt + 10
    elseif ui.get(gamesense.hs[2]) and not ui.get(gamesense.dt[2]) and dropbox:get(hideshots) then
        renderer.text(x + offset_move, y + 15 + offsetttt + dtoffset, 255, 255, 255, dtoffset * 21, "-c", 0, "OS-AA")
        offsetttt = offsetttt + 10
    end

    if ui.get(gamesense.fd) and dropbox:get("fake duck") then
        renderer.text(x + offset_move, y + 15 + offsetttt + duckoffset, 255, 255, 255, duckoffset * 12.75, "-c", 0, "FAKEDUCK")
        offsetttt = offsetttt + 10
    end
    if m_iClasses.antihit.m_iAnti_hit.fsb:get_hotkey() and dropbox:get("freestanding") then
        renderer.text(x + offset_move, y + 15 + offsetttt + fsoffset, 255, 255, 255, fsoffset * 12.75, "-c", 0, "FREESTAND")
        offsetttt = offsetttt + 10
    end
    if ui.get(gamesense.ping[2]) and dropbox:get("ping spike") then
        renderer.text(x + offset_move, y + 15 + offsetttt + pingoffset, 255, 255, 255, pingoffset * 12.75, "-c", 0, "PING-SPIKE")
        offsetttt = offsetttt + 10
    end

    if ui.get(gamesense.baim[1]) and dropbox:get("body aim") then 
        renderer.text(x + offset_move, y + 15 + offsetttt + baimoffset, 255,255,255, baimoffset * 12.75, "-c", 0, "BODY-AIM")
        offsetttt = offsetttt + 10
    end
    if ui.get(gamesense.safe[1]) and dropbox:get("safe point") then 
        renderer.text(x + offset_move, y + 15 + offsetttt + safeoffset, 255,255,255, safeoffset * 12.75, "-c", 0, "SAFE-POINTS")
        offsetttt = offsetttt + 10
    end

elseif  m_iClasses.generals.m_iGlobals.m_gIndicators.select:get() == "modern" then
    local offset = 0
    renderer.text(x-10, y+25, 255, 255, 255, 255, "-c", nil, "DIVINE")
    renderer.text(x+10, y+25, 255, 255, 255, animate_alpha(255), "-c", nil, "YAW")
    if ui.get(gamesense.dt[2]) and anti_aim.get_double_tap() then
        renderer.text(x+3, y+35, 191, 227, 180, 255, "-c", nil, "READY")
        renderer.text(x-15, y+35, 255, 255, 255, 255, "-c", nil, "DT")
        offset = offset + 10
    elseif ui.get(gamesense.dt[2]) and not anti_aim.get_double_tap() then
        renderer.text(x-21, y+35, 255, 255, 255, 255, "-c", nil, "DT")
        renderer.text(x+3, y+35, 255, 255, 255, 155, "-c", nil, "CHARGING")
        charge(x+3, y+35, 2, 175, 0, 0, 255, "CHARGING")
        offset = offset + 10
    end

    if ui.get(gamesense.hs[2]) and not ui.get(gamesense.dt[2]) then
        renderer.text(x-3, y+35, 255, 194, 179, 255, "-c", 0, 'ONSHOT')
        offset = offset + 10
    end
    renderer.text(x-2, y+35 + offset, 255, 255, 255, 255, "c-", 100, "- " .. string.upper(m_iAnti_hit_side.side).. " -")

  end
end

local timer = 0
client.set_event_callback("setup_command", function(cmd)
    if globals.realtime() > timer then
        if valuesjit == true then
            valuesjit = false
        else
            valuesjit = true
        end
        timer = globals.realtime() + 0.1
    end
end)

yaw_apply = 0
yaw_offset_apply = 0
desync_apply = 0

m_iJitterTick_dsy = 0
m_iJitterTick_yaw = 0
m_iJitterTick_jit = 0

m_iTick_delay = 0
m_bJitterSide = false

m_mfCounterVal = 0
m_Way_counter = 0

local m_ftOldtime1 = 0
local m_ftOldtime2 = 0
local m_ftOldtime3 = 0


last_jitter_tick = 0
m_bChoking = false
m_bChokedCommands = 0
m_flLastJitterUpdate = globals.tickcount() 
m_iJitterUpdateCount = 0

local m_mftOffset_counter = false
local m_mftCenter_counter = false
local m_mftYaw_counter = false

local m_bJitterSide_dsy = false
local m_bJitterSide_yaw = false
local m_bJitterSide_jit = false

ground_pos = 0, 0, 0
cur_feet_pos = 0, 0, 0 
cur_distance = 0
sending = false
debug = false
local m_tDefensives = false


function m_iAnti_hit.call(cmd)


    for i = 1, #player_states do
        if m_iAnti_hit_side.side == player_states[i] then




    ui.set(gamesense.pitch, m_iAnti_hit.m_iConditional[i].pitch:get())


    ui.set(gamesense.yawbase, m_iAnti_hit.m_iConditional[i].base:get())

    if m_iClasses.generals.m_iGlobals.m_gIndicators.opts:get("defensive-state") then


    if globals.realtime() > m_ftTime_defensive then
        m_tDefensive = not m_tDefensive
        m_ftTime_defensive = globals.realtime() + 0.8
      end


        local mousex, mousey = ui.mouse_position()
        
        if ui.get(menu.mouse) then
            if (mousex < (x_m + 150)) and (mousex > (x_m-30)) and (mousey < (y_m + 150)) and (mousey > (y_m - 50)) then
                x_m, y_m = mousex, mousey
            else
                x_m , y_m = x_m, y_m
            end
        end

        local r,g,b = m_iClasses.generals.m_iGlobals.m_gIndicators.def_col:get_color()
        defensive_anim = animation_variables.movement(defensive_anim, m_tDefensive, 0, 90, 8)
        non_defensive_anim = animation_variables.movement(non_defensive_anim, m_tDefensive, 90, 0, 12)
        if ui.is_menu_open() then
            m_render:glow_module(x_m - 37, y_m + 100 , 96, 6, 8 , 1, {r, g, b, 90}, {r, g, b, 90})
            renderer.text(x_m - 36, y_m + 85 , 255, 255, 255, 225, nil, nil, "defensive:")
            renderer.text(x_m + 2 + defensive_anim * 0.15, y_m + 85 , r, g, b, 225, nil, nil, "charged")
            renderer.rectangle(x_m - 38, y_m + 100 , 96, 8, 0, 0, 0, 180)
            renderer.rectangle(x_m - 35, y_m + 102 , defensive_anim, 4, r, g, b, 255)
        else
        if m_tDefensive then
            m_render:glow_module(x_m - 37, y_m + 100 , 96, 6, 8 , 1, {r, g, b, defensive_anim}, {r, g, b, defensive_anim})
            renderer.text(x_m - 36, y_m + 85 , 255, 255, 255, 225, nil, nil, "defensive:")
            renderer.text(x_m + 2 + defensive_anim * 0.15, y_m + 85 , r, g, b, 225, nil, nil, "charged")
            renderer.rectangle(x_m - 38, y_m + 100 , 96, 8, 0, 0, 0, 180)
            renderer.rectangle(x_m - 35, y_m + 102 , defensive_anim, 4, r, g, b, 255)
        end

    end
end




    m_lfL_R_check_byaw = not m_lfL_R_check_byaw


    
         
    
        



      if globals.realtime() > m_ftOldtime1 then
        m_mftYaw_counter = not m_mftYaw_counter
        m_ftOldtime1 = globals.realtime() + m_iAnti_hit.m_iConditional[i].delay:get() / 9.5
      end

      if globals.realtime() > m_ftOldtime2 then
        m_mftCenter_counter = not m_mftCenter_counter
        m_ftOldtime2 = globals.realtime() + m_iAnti_hit.m_iConditional[i].delay1:get() / 9.5
      end

      if globals.realtime() > m_ftOldtime3 then
        m_mftOffset_counter = not m_mftOffset_counter
        m_ftOldtime3 = globals.realtime() + m_iAnti_hit.m_iConditional[i].delay2:get() / 9.5

      end

      if globals.realtime() > m_ftTime_defensive then
        m_tDefensives = not m_tDefensives
        m_ftTime_defensive = globals.realtime() + 0.8
      end

            m_bChoking = cmd.chokedcommands == 0


            if m_bChoking then
                m_iJitterUpdateCount = m_iJitterUpdateCount + 1
    
                if m_iJitterUpdateCount % m_iAnti_hit.m_iConditional[i].tick_delay:get() == 0 then
                    m_bJitterSide = not m_bJitterSide
                end
            end

    m_Way_counter = m_Way_counter + 1




        if m_iClasses.antihit.m_iAnti_hit.extras:get("freestand") then
        ui.set(gamesense.freestand[1], m_iClasses.antihit.m_iAnti_hit.fsb:get_hotkey())
        ui.set(gamesense.freestand[2], "Always on")
        end

      if m_iClasses.antihit.m_iAnti_hit.staticfs:get() and m_iClasses.antihit.m_iAnti_hit.extras:get("freestand") and m_iClasses.antihit.m_iAnti_hit.fsb:get_hotkey() then
        ui.set(gamesense.enable, true)
        ui.set(gamesense.pitch, "Down")
        ui.set(gamesense.yawbase, "At Targets")
        ui.set(gamesense.yaw[1], "180")
        ui.set(gamesense.yaw[2], "0")
        ui.set(gamesense.jittertype[1], "center")
        ui.set(gamesense.jittertype[2], "0")
        ui.set(gamesense.bodyyaw[1], "Static")
        ui.set(gamesense.bodyyaw[2], "180")

      else

        local slow = m_iAnti_hit.m_iConditional[i].yawslow:get()

        if m_iClasses.antihit.m_iAnti_hit.leftbind:get_hotkey() then
            yaw_offset_apply = - 90
        elseif m_iClasses.antihit.m_iAnti_hit.rightbind:get_hotkey() then
            yaw_offset_apply = 90
        else

        if m_iAnti_hit.m_iConditional[i].offset_style:get() == "default" then
        if m_iAnti_hit.m_iConditional[i].yaw:get() == "static" then
            yaw_offset_apply = m_iAnti_hit.m_iConditional[i].yawstatic:get()
        elseif m_iAnti_hit.m_iConditional[i].yaw:get() == "slow-jit meta" then
            yaw_offset_apply = valuesjit == true and slow or -slow
        elseif m_iAnti_hit.m_iConditional[i].yaw:get() == "jitter left/right" then

            if m_mftYaw_counter then
                yaw_offset_apply = m_iAnti_hit.m_iConditional[i].yawleft:get()
            else
                yaw_offset_apply = m_iAnti_hit.m_iConditional[i].yawright:get()
            end
        end
        
    elseif m_iAnti_hit.m_iConditional[i].offset_style:get() == "tick delay" then
        if m_bJitterSide then
            yaw_offset_apply = m_iAnti_hit.m_iConditional[i].tickleft:get()
        else
            yaw_offset_apply = m_iAnti_hit.m_iConditional[i].tickright:get()
        end
    end
    end


        if (m_iAnti_hit.m_iConditional[i].yawjitter:get() == "offset") or (m_iAnti_hit.m_iConditional[i].yawjitter:get() == "center") or (m_iAnti_hit.m_iConditional[i].yawjitter:get() == "skitter") then
        yaw_apply = m_iAnti_hit.m_iConditional[i].yawjitdef:get()

        elseif m_iAnti_hit.m_iConditional[i].yawjitter:get() == "offset left/right" then
            if m_mftOffset_counter then
                yaw_apply = m_iAnti_hit.m_iConditional[i].yawjitright:get()
            else
                yaw_apply = m_iAnti_hit.m_iConditional[i].yawjitleft:get()
            end

        elseif m_iAnti_hit.m_iConditional[i].yawjitter:get() == "center left/right" then

            if m_mftCenter_counter then
                yaw_apply = m_iAnti_hit.m_iConditional[i].yawjitclrl:get()
            else
                yaw_apply = m_iAnti_hit.m_iConditional[i].yawjitclrr:get()
            end
        end


    if m_iAnti_hit.m_iConditional[i].offset_style:get() == "tick delay" then

        if m_bJitterSide then
            desync_apply = ((m_iAnti_hit.m_iConditional[i].tickleft:get() >= 0) and 180 or -180)
        else
            desync_apply = ((m_iAnti_hit.m_iConditional[i].tickright:get() < 0) and -180 or 180)
        end

    elseif m_iAnti_hit.m_iConditional[i].offset_style:get() == "default" then

        if (m_iAnti_hit.m_iConditional[i].bodyyaw:get() == "jitter") or (m_iAnti_hit.m_iConditional[i].bodyyaw:get() == "static") or (m_iAnti_hit.m_iConditional[i].bodyyaw:get() == "focus jitter/static") then

        elseif m_iAnti_hit.m_iConditional[i].bodyyaw:get() == "focus static left/right" then
                if m_lfL_R_check_byaw then
                    desync_apply = m_iAnti_hit.m_iConditional[i].bodyyawfsl:get()
                else
                    desync_apply = m_iAnti_hit.m_iConditional[i].bodyyawfsr:get()
                end
        end
    end
    ui.set(gamesense.jittertype[1], (m_iAnti_hit.m_iConditional[i].yawjitter:get() == "off" and "off") or (m_iAnti_hit.m_iConditional[i].yawjitter:get() == "offset" and "offset") or (m_iAnti_hit.m_iConditional[i].yawjitter:get() == "center" and "center") or (m_iAnti_hit.m_iConditional[i].yawjitter:get() == "skitter" and "skitter") or (m_iAnti_hit.m_iConditional[i].yawjitter:get() == "center left/right" and "center") or (m_iAnti_hit.m_iConditional[i].yawjitter:get() == "offset left/right" and "offset") or "center")
    ui.set(gamesense.jittertype[2], yaw_apply)
    ui.set(gamesense.yaw[1], "180")
    ui.set(gamesense.yaw[2], yaw_offset_apply)
        ui.set(gamesense.bodyyaw[1], (m_iAnti_hit.m_iConditional[i].bodyyaw:get() == "jitter" and "jitter") or (m_iAnti_hit.m_iConditional[i].bodyyaw:get() == "static" and "static") or (m_iAnti_hit.m_iConditional[i].bodyyaw:get() == "focus jitter/static" and m_bJitterSide_dsy == true and "jitter" or "static") or m_iAnti_hit.m_iConditional[i].offset_style:get() == "tick delay" and "static")
        ui.set(gamesense.bodyyaw[2], desync_apply)
    end
  end



    end
end

client.set_event_callback("setup_command", function(cmd)
    m_iAnti_hit.detect_state(cmd)
    m_iAnti_hit.call(cmd)
end)

client.set_event_callback("paint", function(cmd)
    m_fVisuals()
end)

config = pui.setup({m_iClasses, m_iAnti_hit.m_iConditional})

saved = config()

client.set_event_callback("player_death", killsay)

m_iClasses.generals.m_gMiscellaneous.m_gExportation:set_callback(function()
    local to_save = base64.encode(json.stringify(config:save()))
    
    clipboard.set(to_save)
end)

m_iClasses.generals.m_gMiscellaneous.m_gImportation:set_callback(function()
    local subtract = base64.decode(clipboard.get())

    config:load(json.parse(subtract))
end)

pui.traverse(m_iClasses, function (element, path)
    element:depend({tab, path[1]})
end)

client.set_event_callback("paint_ui", function()


    ui.set(animated_text, ('=＾● ⋏ ●＾='..label_anim(-2,176, 206, 255, 255,' divine.lua systems')))

    ui.set_visible(gamesense.enable, false)
    ui.set_visible(gamesense.yaw[1], false)
    ui.set_visible(gamesense.yaw[2], false)
    ui.set_visible(gamesense.bodyyaw[1], false)
    ui.set_visible(gamesense.bodyyaw[2], false)
    ui.set_visible(gamesense.roll, false)
    ui.set_visible(gamesense.jittertype[1], false)
    ui.set_visible(gamesense.jittertype[2], false)
    ui.set_visible(gamesense.pitch, false)
    ui.set_visible(gamesense.yawbase, false)
    ui.set_visible(gamesense.fsbodyyaw, false)
    ui.set_visible(gamesense.edgeyaw, false)
    ui.set_visible(gamesense.freestand[1], false)
    ui.set_visible(gamesense.freestand[2], false)
end)

client.set_event_callback("shutdown", function()
    ui.set_visible(gamesense.enable, true)
    ui.set_visible(gamesense.yaw[1], true)
    ui.set_visible(gamesense.yaw[2], true)
    ui.set_visible(gamesense.bodyyaw[1], true)
    ui.set_visible(gamesense.bodyyaw[2], true)
    ui.set_visible(gamesense.roll, true)
    ui.set_visible(gamesense.jittertype[1], true)
    ui.set_visible(gamesense.jittertype[2], true)
    ui.set_visible(gamesense.pitch, true)
    ui.set_visible(gamesense.yawbase, true)
    ui.set_visible(gamesense.fsbodyyaw, true)
    ui.set_visible(gamesense.edgeyaw, true)
    ui.set_visible(gamesense.freestand[1], true)
    ui.set_visible(gamesense.freestand[2], true)



    client.set_clan_tag("")
end)