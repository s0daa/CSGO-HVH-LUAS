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
            select = groups:combobox("\vsty\rle:", {"None", "new", "old", "modern", "fancy"}),
            cindopt = groups:multiselect("\vindi\rcate:", {"double tap", "hideshots", "ping spike", "freestanding", "fake duck", "body aim", "safe point"}),
            dpselect = groups:multiselect("\vDe\rbug:", {"local data", "divine resolver data"}),
            col = groups:label("center \vindicators\r color:", {176, 206, 255}),
            syaw = groups:checkbox("Yaw \vside\r indicator", {176, 206, 255}),
            syawanims = groups:checkbox("vertical anims."),
            watermark = groups:label("side-\vwatermark\r color:", {176, 206, 255}),
            def_col = groups:label("\vdefensive\r color:", {176, 206, 255})
        }
      },
      m_bRagebot = {
        m_gRbotSwitch = groups:checkbox("~ \bB0CEFFFF\bFFFFFFFF[Ragebot features]"),
        m_gResolver = groups:checkbox(ragestring .. "divine.lua resolver"),
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

m_iClasses.generals.m_bRagebot.m_gResolver:depend({m_iClasses.generals.m_bRagebot.m_gRbotSwitch, true})
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
                
                fiveway1 = groups:slider(divinestring .. player_conditions[i] .. "\a848484BB5-Ways: 1" , -180, 180, 0),
                fiveway2 = groups:slider(divinestring .. player_conditions[i] .. "\a848484BB5-Ways: 2" , -180, 180, 0),
                fiveway3 = groups:slider(divinestring .. player_conditions[i] .. "\a848484BB5-Ways: 3" , -180, 180, 0),
                fiveway4 = groups:slider(divinestring .. player_conditions[i] .. "\a848484BB5-Ways: 4" , -180, 180, 0),
                fiveway5 = groups:slider(divinestring .. player_conditions[i] .. "\a848484BB5-Ways: 5" , -180, 180, 0),

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
                
                m_iAnti_hit.m_iConditional[i].fiveway1:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yawjitter, "5-Ways"})
                m_iAnti_hit.m_iConditional[i].fiveway2:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yawjitter, "5-Ways"})
                m_iAnti_hit.m_iConditional[i].fiveway3:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yawjitter, "5-Ways"})
                m_iAnti_hit.m_iConditional[i].fiveway4:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yawjitter, "5-Ways"})
                m_iAnti_hit.m_iConditional[i].fiveway5:depend({m_iClasses.antihit.m_gConditionals.conditions, player_states[i]}, {tab, "antihit"}, {m_iAnti_hit.m_iConditional[i].yawjitter, "5-Ways"})

                
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


local ffi = require "ffi"

ffi.cdef[[
    struct c_animstate {
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    };


    typedef struct
    {
        float   m_anim_time;		
        float   m_fade_out_time;	
        int     m_flags;			
        int     m_activity;			
        int     m_priority;			
        int     m_order;			
        int     m_sequence;			
        float   m_prev_cycle;		
        float   m_weight;			
        float   m_weight_delta_rate;
        float   m_playback_rate;	
        float   m_cycle;			
        void* m_owner;			
        int     m_bits;				
    } C_AnimationLayer;

    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);
]]

math.clamp = function(v, min, max)
    if min > max then min, max = max, min end
    if v > max then return max end
    if v < min then return v end
    return v
end

math.angle_diff = function(dest, src)
    local delta = 0.0

    delta = math.fmod(dest - src, 360.0)

    if dest > src then
        if delta >= 180 then delta = delta - 360 end
    else
        if delta <= -180 then delta = delta + 360 end
    end

    return delta
end

math.angle_normalize = function(angle)
    local ang = 0.0
    ang = math.fmod(angle, 360.0)

    if ang < 0.0 then ang = ang + 360 end

    return ang
end

math.anglemod = function(a)
    local num = (360 / 65536) * bit.band(math.floor(a * (65536 / 360.0), 65535))
    return num
end

math.approach_angle = function(target, value, speed)
    target = math.anglemod(target)
    value = math.anglemod(value)

    local delta = target - value

    if speed < 0 then speed = -speed end

    if delta < -180 then
        delta = delta + 360
    elseif delta > 180 then
        delta = delta - 360
    end

    if delta > speed then
        value = value + speed
    elseif delta < -speed then
        value = value - speed
    else
        value = target
    end

    return value
end

math.vec_length2d = function(vec)
    root = 0.0
    sqst = vec.x * vec.x + vec.y * vec.y
    root = math.sqrt(sqst)
    return root
end

function samdadn(ent, tbl, array)
    local x, y, z = entity.get_prop(ent, tbl, (array or nil))
    return {x = x, y = y, z = z}
end

function globals.is_connected()
    local lp = entity.get_local_player()

    if lp ~= nil and lp > 0 then return false
        else return true end
end

local entity_list_ptr = ffi.cast("void***", client.create_interface("client.dll",
                                                                 "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntityHandle_4242425_t",
                                      entity_list_ptr[0][3])
local get_client_entity_by_handle_fn = ffi.cast(
                                           "GetClientEntityHandle_4242425_t",
                                           entity_list_ptr[0][4])

entity.get_address = function(idx)
    return get_client_entity_fn(entity_list_ptr, idx)
end

entity.get_animstate = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("struct c_animstate**", addr + 0x9960)[0]
end

entity.get_animlayer = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end

    return ffi.cast("C_AnimationLayer**", ffi.cast('uintptr_t', addr) + 0x9960)[0]
end

local RESOLVER = {
    ORIGINAL = 0,
    NEGATIVE = -1,
    POSITIVE = 1,
    HALF_NEGATIVE = -0.5,
    HALF_POSITIVE = 0.5
}

local ANIMLAYERS = {
    AIMMATRIX = 0 ,
	WEAPON_ACTION = 1 ,
	WEAPON_ACTION_RECROUCH = 2 ,
	ADJUST = 3 ,
	JUMP_OR_FALL = 4 ,
	LAND_OR_CLIMB = 5 ,
	MOVE = 6 ,
	STRAFECHANGE = 7 ,
	WHOLE_BODY = 8 ,
	FLASHED = 9 ,
	FLINCH = 10 ,
	ALIVELOOP = 11 ,
	LEAN = 12 ,
}

local m_iMaxRecords = 26

local loopsaid = {}
 function loopsaid.deepcopy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end

    local s = seen or {}
    local res = {}
    s[obj] = res
    for k, v in next, obj do res[loopsaid.deepcopy(k, s)] = loopsaid.deepcopy(v, s) end
    return setmetatable(res, getmetatable(obj))
end

 function loopsaid.push_back(tbl, push, max)
    local ret_tbl = loopsaid.deepcopy(tbl)
    if not max then max = #ret_tbl end
    for i = max - 1, 1, -1 do
        if ret_tbl[i] ~= nil then
            ret_tbl[i + 1] = ret_tbl[i] 
        end
        if i == 1 then
            ret_tbl[i] = push
        end
    end
    return ret_tbl
end

local resolver = {}
local records = {}
resolver.get_layers = function(idx)
    local layers = {}
    local get_layers = entity.get_animlayer(idx)
    for i = 1, 12 do
        local layer = get_layers[i]
        if not layer then goto continue end

        if not layers[i] then
            layers[i] = {}
        end

        layers[i].m_playback_rate = layer.m_playback_rate
        layers[i].m_sequence = layer.m_sequence
        
        ::continue::
    end
    return layers
end

records.layers = {}
resolver.update_layers = function(idx)
    if not records.layers[idx] then
        records.layers[idx] = {}
    end
    local current_layer = entity.get_animlayer(idx)
    records.layers[idx] = loopsaid.push_back(records.layers[idx], current_layer, m_iMaxRecords)
end

resolver.get_data = function(idx)
    local animstate = entity.get_animstate(idx)
    if not animstate then return end

    local ent = idx
    local ret = {}
    ret.m_flGoalFeetYaw = animstate.m_flGoalFeetYaw
    ret.m_flEyeYaw = animstate.m_flEyeYaw
    ret.m_iEntity = ent > 0 and ent or nil
    ret.m_vecVelocity = ret.m_iEntity and samdadn(ent, 'm_vecVelocity') or {x = 0, y = 0, z = 0}
    ret.m_flDifference = math.angle_diff(animstate.m_flEyeYaw, animstate.m_flGoalFeetYaw)
    ret.m_flFeetSpeedForwardsOrSideWays = animstate.m_flFeetSpeedForwardsOrSideWays
    ret.m_flStopToFullRunningFraction = animstate.m_flStopToFullRunningFraction
    ret.m_fDuckAmount = animstate.m_fDuckAmount
    ret.m_flPitch = animstate.m_flPitch

    return ret
end

records.angles = {}
resolver.update_angles = function(idx)
    if not records.angles[idx] then
        records.angles[idx] = {}
    end
    local current_angles = resolver.get_data(idx)
    records.angles[idx] = loopsaid.push_back(records.angles[idx], current_angles, m_iMaxRecords)
end

local ROTATION = {
    SERVER = 1,
    CENTER = 2,
    LEFT = 3,
    RIGHT = 4
}

records.safepoints_container = {}
resolver.get_safepoints = function(idx, side, desync)
    if not records.safepoints_container[idx] then
        records.safepoints_container[idx] = {}
    end
    for i = 1, 4 do
        if not records.safepoints_container[idx][i] then
            records.safepoints_container[idx][i] = {}
            records.safepoints_container[idx][i].m_playback_rate = 0
        end
        
    end
    records.safepoints_container[idx][1].m_playback_rate = records.layers[idx][1][6].m_playback_rate

    local m_flDesync = side * desync
    if side < 0 then
        if m_flDesync <= -44 then
            records.safepoints_container[idx][4].m_playback_rate = records.safepoints_container[idx][1].m_playback_rate
        end
    elseif side > 0 then
        if m_flDesync >= 44 then
            records.safepoints_container[idx][3].m_playback_rate = records.safepoints_container[idx][1].m_playback_rate
        end
    else
        if desync <= 29 then
            records.safepoints_container[idx][2].m_playback_rate = records.safepoints_container[idx][1].m_playback_rate
        end
    end

    return records.safepoints_container[idx]
end

resolver.safepoints = {}
resolver.update_safepoints = function(idx, side, desync)
    if not resolver.safepoints[idx] then
        resolver.safepoints[idx] = {}
    end
    
    local current_safepoints = resolver.get_safepoints(idx, side, desync)
    resolver.safepoints[idx] = loopsaid.push_back(resolver.safepoints[idx], current_safepoints, m_iMaxRecords)
end

resolver.get_layer_side = function(idx, record)
    local m_iVelocity = math.vec_length2d(records.angles[idx][record].m_vecVelocity)
    if m_iVelocity < 2 then return end
    local layer = resolver.safepoints[idx][record]

    local m_center_layer = math.abs(layer[1].m_playback_rate - layer[2].m_playback_rate)
    local m_left_layer = math.abs(layer[1].m_playback_rate - layer[3].m_playback_rate)
    local m_right_layer = math.abs(layer[1].m_playback_rate - layer[4].m_playback_rate)

    if m_center_layer < m_left_layer or m_right_layer <= m_left_layer then
        if m_center_layer >= m_right_layer or m_left_layer > m_right_layer then
            return 1
        end
    end
    return -1
end

function m_flMaxDesyncDelta(record)
    local speedfactor = math.clamp(record.m_flFeetSpeedForwardsOrSideWays, 0, 1)
    local avg_speedfactor = (record.m_flStopToFullRunningFraction * -0.3 - 0.2) * speedfactor + 1

    local duck_amount = record.m_fDuckAmount

    if duck_amount > 0 then
        local max_velocity = math.clamp(record.m_flFeetSpeedForwardsOrSideWays, 0, 1)
        local duck_speed = duck_amount * max_velocity

        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return avg_speedfactor
end

resolver.run = function(idx, record, force)
    if not records.angles[idx] or not records.angles[idx][record] or not records.angles[idx][record + 1] then return end

    local animstate = records.angles[idx][record]
    local previous = records.angles[idx][record + 1]

    if not animstate.m_iEntity or not previous.m_iEntity then return false end

    local m_flMaxDesyncFloat = m_flMaxDesyncDelta(animstate)
    local m_flDesync = m_flMaxDesyncFloat * 58

    local m_flAbsDiff = animstate.m_flDifference
    local m_flPrevAbsDiff = previous.m_flDifference

    local m_iVelocity = math.vec_length2d(animstate.m_vecVelocity)
    local m_iPrevVelocity = math.vec_length2d(previous.m_vecVelocity)

    local side = RESOLVER.ORIGINAL
    if animstate.m_flDifference <= 1 then
        side = RESOLVER.POSITIVE
    elseif animstate.m_flDifference >= 1 then
        side = RESOLVER.NEGATIVE
    end

    local m_bShouldResolve = true

    if m_flAbsDiff > 0 or m_flPrevAbsDiff > 0 then
        if m_flAbsDiff < m_flPrevAbsDiff then
            m_bShouldResolve = false

            if m_iVelocity >= m_iPrevVelocity then
                m_bShouldResolve = true
            end
        end

        if m_bShouldResolve then
            local m_flCurrentAngle = math.max(m_flAbsDiff, m_flPrevAbsDiff)
            if m_flAbsDiff <= 10.0 and m_flPrevAbsDiff <= 10.0 then
                m_flDesync = m_flCurrentAngle
            elseif m_flAbsDiff <= 35.0 and m_flPrevAbsDiff <= 35.0 then
                m_flDesync = math.max(29.0, m_flCurrentAngle)
            else
                m_flDesync = math.clamp(m_flCurrentAngle, 29.0, 58)
            end
        end
    end

    if (m_flAbsDiff < 1 or m_flPrevAbsDiff < 1 or side == 0) and not force then
        return
    end

    return {
        angle = m_flDesync,
        side = side,
        record = record,
        pitch = animstate.m_flPitch
    }
end

resolver.init = function()
    local lp = entity.get_local_player()

    if not globals.is_connected() then
        resolver.hkResetBruteforce()
    elseif globals.is_connected() and entity.get_prop(lp, 'm_iHealth') < 1 then
        resolver.hkResetBruteforce()
    elseif m_iClasses.generals.m_bRagebot.m_gResolver:get() then
        resolver.hkResetBruteforce()
    end
    if globals.is_connected() or not m_iClasses.generals.m_bRagebot.m_gResolver:get() then return end

    local available_clients = entity.get_players(true) 

    if entity.get_prop(lp, 'm_iHealth') >= 1 then
        resolver.reset_bruteforce = true
    end

    for array = 1, #available_clients do
        local idx = available_clients[array]

        if idx == lp then goto continue end

        if not m_iClasses.generals.m_bRagebot.m_gResolver:get() then 
            plist.set(idx, 'Force body yaw', false)
            goto continue 
        end

        resolver.update_angles(idx)

        local info = nil
        local forced = false
        for record = 1, m_iMaxRecords - 1 do
            info = resolver.run(idx, record)
            if info then
                goto set_angle
            elseif record == (m_iMaxRecords - 1) then
                forced = true
                info = resolver.run(idx, 1, true)
            end
        end

        ::set_angle::
        if not info then goto continue end


        resolver.apply(idx, info.angle, info.side, info.pitch)

        ::continue::
    end
end

resolver.apply = function(m_iEntityIndex, m_flDesync, m_iSide, m_flPitch)
    local m_flFinalAngle = m_flDesync * m_iSide
    if m_flFinalAngle < 0 then
        m_flFinalAngle = math.ceil(m_flFinalAngle - 0.5)
    else
        m_flFinalAngle = math.floor(m_flFinalAngle + 0.5)
    end
    if m_iSide == 0 then
        plist.set(m_iEntityIndex, 'Force body yaw', false)
        return
    end
    plist.set(m_iEntityIndex, 'Force body yaw', true)
    plist.set(m_iEntityIndex, 'Force body yaw value', m_flFinalAngle)
end

resolver.bruteforce = {}
resolver.reset_bruteforce = false

resolver.hkResetBruteforce = function()
    for i = 1, 64 do
        resolver.bruteforce[i] = 0
        if i == 64 then
            resolver.reset_bruteforce = false
        end
    end
end

client.set_event_callback('net_update_end', function()
    resolver.init()
end)

client.set_event_callback("aim_miss", function(e)
    if e.reason == '?' then

        if not resolver.bruteforce[e.target] then
            resolver.bruteforce[e.target] = 0
        end

        resolver.bruteforce[e.target] = resolver.bruteforce[e.target] + 1

        if resolver.bruteforce[e.target] > 2 then
            resolver.bruteforce[e.target] = 0
        end
    end
end)

client.set_event_callback("aim_hit", function(e)
    if resolver.bruteforce[e.target] and resolver.bruteforce[e.target] > 0 and entity.get_prop(e.target, 'm_iHealth') < 1 then
        resolver.bruteforce[e.target] = 0
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

    if m_iClasses.generals.m_iGlobals.m_gIndicators.select:get() == "new" then
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
elseif  m_iClasses.generals.m_iGlobals.m_gIndicators.select:get() == "old" then
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
elseif  m_iClasses.generals.m_iGlobals.m_gIndicators.select:get() == "fancy" then
    offset_move = animation_variables.movement(offset_move, scoped, 0, 45, 5)
    m_render:glow_module(x - 37 + offset_move , y + 30, 74, 6, 8 , 1, {r, g, b, 90}, {r, g, b, 90})
    renderer.rectangle(x - 37 + offset_move, y + 30, 74, 8, 0, 0, 0, 180)

    renderer.text(x + offset_move, y + 23, 0, 0, 0, 255, 'bc', nil, 'divine.systems')
    renderer.text(x + offset_move, y + 23, 255, 255, 255, 255, 'bc', nil, modify_text(r, g, b, 'divine.systems'))
    if m_iAnti_hit_side.side == "lowvel" then
    renderer.gradient(x - 35 + offset_move, y + 30, 12, 6, r, g, b, 255, r, g, b, 255, true)
    elseif m_iAnti_hit_side.side == "turtle" then
    renderer.gradient(x - 23 + offset_move, y + 30, 12, 6, r, g, b, 255, r, g, b, 255, true)
    elseif m_iAnti_hit_side.side == "fakelag" then
    renderer.gradient(x - 11 + offset_move, y + 30, 12, 6, r, g, b, 255, r, g, b, 255, true)
    elseif m_iAnti_hit_side.side == "walk" then
    renderer.gradient(x + 1 + offset_move, y + 30, 12, 6, r, g, b, 255, r, g, b, 255, true)
    elseif m_iAnti_hit_side.side == "aerobic" then
    renderer.gradient(x + 13 + offset_move, y + 30, 12, 6, r, g, b, 255, r, g, b, 255, true) 
    elseif m_iAnti_hit_side.side == "aerial" then
    renderer.gradient(x + 13 + offset_move, y + 30, 12, 6, r, g, b, 255, r, g, b, 255, true) 
    elseif m_iAnti_hit_side.side == "fakecrouch" then
    renderer.gradient(x + 25 + offset_move, y + 30, 12, 6, r, g, b, 255, r, g, b, 255, true)
    elseif m_iAnti_hit_side.side == "duck" then
    renderer.gradient(x + 25 + offset_move, y + 30, 12, 6, r, g, b, 255, r, g, b, 255, true)
    end

    renderer.outlined_rounded_rectangle(x - 37 + offset_move, y + 30, 74, 8, 0, 0, 0, 255, 0, 2)
    
    offsetttt = offsetttt + 10
    

    

    if ui.get(gamesense.dt[2]) and not ui.get(gamesense.qp[2]) and dropbox:get("double tap") then
        renderer.text(x - 3 + offset_move, y + 15 + offsetttt + dtoffset, 255, 255, 255, dtoffset * 12.75, "-c", nil, "DT")
        renderer.circle_outline(x + 9 + offset_move, y + 25 + dtoffset, r, g, b, dtoffset * 12.75, 3, 0, 1,1)
        renderer.circle_outline(x + 9 + offset_move, y + 25 + dtoffset, r, g, b, dtoffset * 12.75, 3, -90, anti_aim.get_tickbase_shifting() / 14, 1)
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
        elseif m_iAnti_hit.m_iConditional[i].yawjitter:get() == "5-Ways" then
            
            if m_Way_counter > 5 then
                m_Way_counter = 0
                return
            end
            if m_Way_counter == 1 then
                   yaw_apply = m_iAnti_hit.m_iConditional[i].fiveway1:get()
            elseif m_Way_counter == 2 then
                   yaw_apply = m_iAnti_hit.m_iConditional[i].fiveway2:get()
            elseif m_Way_counter == 3 then
                   yaw_apply = m_iAnti_hit.m_iConditional[i].fiveway3:get()
            elseif m_Way_counter == 4 then
                   yaw_apply = m_iAnti_hit.m_iConditional[i].fiveway4:get()
            elseif m_Way_counter == 5 then
                   yaw_apply = m_iAnti_hit.m_iConditional[i].fiveway5:get()
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