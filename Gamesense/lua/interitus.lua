local libs = {
    ['gamesense/http'] = 'gamesense / http',
    ['gamesense/pui'] = 'gamesense / pui',
    ['gamesense/base64'] = 'gamesense / base64',
    ['gamesense/entity'] = 'gamesense / entity',
    ['gamesense/images'] = 'gamesense / images',
    ['gamesense/discord_webhooks'] = 'gamesense / discord_webhooks',
    ['gamesense/clipboard'] = 'gamesense / clipboard',
    ['gamesense/antiaim_funcs'] = 'gamesense / antiaim_funcs'
}

local lib_no_sub = {}

for i, v in pairs(libs) do
    if not pcall(require, i) then
        lib_no_sub[#lib_no_sub + 1] = libs[i]
    end
end

for i=1, #lib_no_sub do
    print("\nSubscribe libraries:\n" .. table.concat(lib_no_sub, ", \n"))
end

local ffi = require("ffi")
local http = require('gamesense/http')
local pui = require("gamesense/pui")
local base64 = require("gamesense/base64")
local vector = require("vector")
local ent_lib = require("gamesense/entity")
local images = require("gamesense/images")
local discord = require("gamesense/discord_webhooks")
local clipboard = require("gamesense/clipboard")
local antiaim_funcs = require("gamesense/antiaim_funcs")

X,Y = client.screen_size()

--[[
    LUA: interitus
]]

local euphemia = euphemia_data and euphemia_data() or {
    username = "lby__",
    build = "renewed"
}

local notify_data = {}

pui.accent = "FF7369ff" -- lua main color
pui.macros.heart = '❤'
local group = pui.group("aa","anti-aimbot angles") -- GROUP - ANTIAIM
local group_other = pui.group("aa","Other") -- GROUP - OTHER

local refs = {
    references = {
        minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
        minimum_damage_override = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
        double_tap = {ui.reference('RAGE', 'Aimbot', 'Double tap')},
        ps = { ui.reference("MISC", "Miscellaneous", "Ping spike") },
        duck_peek_assist = ui.reference('RAGE', 'Other', 'Duck peek assist'),
        enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
        pitch = {ui.reference('AA', 'Anti-aimbot angles', 'Pitch')},
        yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
        yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
        yaw_jitter = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
        body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
        freestanding_body_yaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
        edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
        freestanding = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
        roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
        slow_motion = {ui.reference('AA', 'Other', 'Slow motion')},
        leg_movement = ui.reference('AA', 'Other', 'Leg movement'),
        on_shot_anti_aim = {ui.reference('AA', 'Other', 'On shot anti-aim')}
    },  
    ref = {
        aa_enable = ui.reference("AA","anti-aimbot angles","enabled"),
        pitch = ui.reference("AA","anti-aimbot angles","pitch"),
        pitch_value = select(2, ui.reference("AA","anti-aimbot angles","pitch")),
        yaw_base = ui.reference("AA","anti-aimbot angles","yaw base"),
        yaw = ui.reference("AA","anti-aimbot angles","yaw"),
        yaw_value = select(2, ui.reference("AA","anti-aimbot angles","yaw")),
        yaw_jitter = ui.reference("AA","Anti-aimbot angles","Yaw Jitter"),
        yaw_jitter_value = select(2, ui.reference("AA","Anti-aimbot angles","Yaw Jitter")),
        body_yaw = ui.reference("AA","Anti-aimbot angles","Body yaw"),
        body_yaw_value = select(2, ui.reference("AA","Anti-aimbot angles","Body yaw")),
        freestand_body_yaw = ui.reference("AA","Anti-aimbot angles","freestanding body yaw"),
        edgeyaw = ui.reference("AA","anti-aimbot angles","edge yaw"),
        freestand = {ui.reference("AA","anti-aimbot angles","freestanding")},
        roll = ui.reference("AA","anti-aimbot angles","roll"),
        slide = {ui.reference("AA","other","slow motion")},
        fakeduck = ui.reference("rage","other","duck peek assist"),
        quick_peek = {ui.reference("rage", "other", "quick peek assist")},
        doubletap = {ui.reference("rage", "aimbot", "double tap")},
    }
}

local funcs = {
    contains = function(tbl, arg)
        for index, value in next, tbl do 
            if value == arg then 
                return true end 
            end 
        return false
    end,
    lerp = function(a, b, t)
        return a + (b - a) * t
    end,
    rgba_to_hex = function(b,c,d,e)
        return string.format('%02x%02x%02x%02x',b,c,d,e)
    end,
    gradient_text = function(text, speed, r,g,b,a)
        local final_text = ''
        local curtime = globals.curtime()
        local center = math.floor(#text / 2) + 1
        for i=1, #text do
            local distance = math.abs(i - center)
            a = 255 - math.abs(255 * math.sin(speed * curtime / 4 - distance * 4 / 20))
            local col = string.format('%02x%02x%02x%02x',r,g,b,a)
            final_text = final_text .. '\a' .. col .. text:sub(i, i)
        end
        return final_text
    end,
    text_fade_animation = function(speed, r, g, b, a, text)
        local final_text = ''
        local curtime = globals.curtime()
        for i=0, #text do
            local color = string.format('%02x%02x%02x%02x', r, g, b, a*math.abs(1*math.cos(2*speed*curtime/4+i*5/30)))
            final_text = final_text..'\a'..color..text:sub(i, i)
        end
        return final_text
    end,
    hide_skeet_antiaim_def = function(value)
        value = not value
        ui.set_visible(refs.ref.aa_enable, value) ui.set_visible(refs.ref.pitch, value) ui.set_visible(refs.ref.pitch_value, value)
        ui.set_visible(refs.ref.yaw_base, value) ui.set_visible(refs.ref.yaw, value) ui.set_visible(refs.ref.yaw_value, value)
        ui.set_visible(refs.ref.yaw_jitter, value) ui.set_visible(refs.ref.yaw_jitter_value, value) ui.set_visible(refs.ref.body_yaw, value)
        ui.set_visible(refs.ref.body_yaw_value, value) ui.set_visible(refs.ref.edgeyaw, value) ui.set_visible(refs.ref.freestand[1], value)
        ui.set_visible(refs.ref.freestand[2], value) ui.set_visible(refs.ref.roll, value) ui.set_visible(refs.ref.freestand_body_yaw, value)
    end,
    intersect = function(x, y, width, height)
        local cx, cy = ui.mouse_position()
        return cx >= x and cx <= x + width and cy >= y and cy <= y + height
    end,
    convertUnixTime = function(unixTime)
        local hours = math.floor(unixTime / 3600) % 24
        local minutes = math.floor(unixTime / 60) % 60
        local seconds = unixTime % 60
        local timeString = string.format("%02d:%02d:%02d", hours, minutes, seconds)
        return timeString
    end,
    multicolor_console = function(...)
        local texts = {...}
        for i=1, #texts do
            local text = texts[i]
            client.color_log(text[1], text[2], text[3], i ~= #texts and (text[4] .. '\0') or text[4])
        end
    end,
    gradient_text = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
        local output = ''
    
        local len = #text-1
    
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len
    
        for i=1, len+1 do
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
    
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end
    
        return output
    end
}

local x, o = '\x14\x14\x14\xFF', '\x0c\x0c\x0c\xFF'

local pattern = table.concat{
    x,x,o,x,
    o,x,o,x,
    o,x,x,x,
    o,x,o,x
}

local tex_id = renderer.load_rgba(pattern, 4, 4)

function render_ogskeet_border(x,y,w,h,a,text)
    renderer.rectangle(x - 10, y - 48 ,w + 20, h + 16,12,12,12,a)
    renderer.rectangle(x - 9, y - 47 ,w + 18, h + 14,60,60,60,a)
    renderer.rectangle(x - 8, y - 46 ,w + 16, h + 12,40,40,40,a)
    renderer.rectangle(x - 5, y - 43 ,w + 10, h + 6,60,60,60,a)
    renderer.rectangle(x - 4, y - 42 ,w + 8, h + 4,12,12,12,a)
    renderer.texture(tex_id, x - 4, y - 42, w + 8, h + 4, 255, 255, 255, a, "r")
    renderer.gradient(x - 4,y - 42, w /2, 1, 59, 175, 222, a, 202, 70, 205, a,true)               
    renderer.gradient(x - 4 + w / 2 ,y - 42, w /2 + 8.5, 1,202, 70, 205, a,204, 227, 53, a,true)
    renderer.text(x, y - 40, 255,255,255,a, "", nil, text)
end

local cfg_data = {}
cfg_data.database = {
    configs = ":interitus_cfg_beste:"
}
cfg_data.presets = {
    {name = "Default", config = "W3siZW5hYmxlIjp0cnVlLCJ5YXdfYmFzZSI6IkF0IHRhcmdldHMiLCJzdGF0ZSI6Ikp1bXAifSx7ImVuYWJsZSI6dHJ1ZSwic3RhdGUiOiJKdW1wIn0seyJSdW4iOnsiZW5hYmxlIjpmYWxzZSwicGl0Y2giOiJSYW5kb20iLCJmb3JjZSI6dHJ1ZSwibW9kZSI6IkFsd2F5cyBvbiIsImN1c3RvbV9waXRjaCI6MCwieWF3X2ppdHRlcl9zbGlkZXIiOjAsInlhdyI6IlNpZGV3YXlzIiwieWF3X2ppdHRlciI6IlJhbmRvbSIsInlhd19sZWZ0IjotMjEsInlhd19yaWdodCI6MjEsInlhd19zbGlkZXIiOjF9LCJEdWNrLWp1bXAiOnsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6Ilplcm8iLCJmb3JjZSI6ZmFsc2UsIm1vZGUiOiJJbnZhbGlkIHRpY2tzIiwiY3VzdG9tX3BpdGNoIjowLCJ5YXdfaml0dGVyX3NsaWRlciI6LTQzLCJ5YXciOiJTcGluIiwieWF3X2ppdHRlciI6IlJhbmRvbSIsInlhd19sZWZ0IjotMjEsInlhd19yaWdodCI6MjEsInlhd19zbGlkZXIiOjcwfSwiRHVjayI6eyJlbmFibGUiOnRydWUsInBpdGNoIjoiUmFuZG9tIiwiZm9yY2UiOnRydWUsIm1vZGUiOiJBbHdheXMgb24iLCJjdXN0b21fcGl0Y2giOjAsInlhd19qaXR0ZXJfc2xpZGVyIjowLCJ5YXciOiJTaWRld2F5cyIsInlhd19qaXR0ZXIiOiJSYW5kb20iLCJ5YXdfbGVmdCI6LTIxLCJ5YXdfcmlnaHQiOjIxLCJ5YXdfc2xpZGVyIjoxfSwiU3RhbmQiOnsiZW5hYmxlIjpmYWxzZSwicGl0Y2giOiJSYW5kb20iLCJmb3JjZSI6dHJ1ZSwibW9kZSI6IkFsd2F5cyBvbiIsImN1c3RvbV9waXRjaCI6MCwieWF3X2ppdHRlcl9zbGlkZXIiOjAsInlhdyI6IlNpZGV3YXlzIiwieWF3X2ppdHRlciI6IlJhbmRvbSIsInlhd19sZWZ0IjotMjEsInlhd19yaWdodCI6MjEsInlhd19zbGlkZXIiOjF9LCJKdW1wIjp7ImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJJbnRlcml0dXMiLCJmb3JjZSI6ZmFsc2UsIm1vZGUiOiJJbnZhbGlkIHRpY2tzIiwiY3VzdG9tX3BpdGNoIjowLCJ5YXdfaml0dGVyX3NsaWRlciI6MCwieWF3IjoiU3BpbiIsInlhd19qaXR0ZXIiOiJPZmYiLCJ5YXdfbGVmdCI6LTIxLCJ5YXdfcmlnaHQiOjIxLCJ5YXdfc2xpZGVyIjo3MH0sIlNsb3d3YWxrIjp7ImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJSYW5kb20iLCJmb3JjZSI6dHJ1ZSwibW9kZSI6IkFsd2F5cyBvbiIsImN1c3RvbV9waXRjaCI6MCwieWF3X2ppdHRlcl9zbGlkZXIiOjAsInlhdyI6IlNpZGV3YXlzIiwieWF3X2ppdHRlciI6IlJhbmRvbSIsInlhd19sZWZ0IjotMjEsInlhd19yaWdodCI6MjEsInlhd19zbGlkZXIiOjF9LCJEdWNrLW1vdmUiOnsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6IlJhbmRvbSIsImZvcmNlIjp0cnVlLCJtb2RlIjoiQWx3YXlzIG9uIiwiY3VzdG9tX3BpdGNoIjowLCJ5YXdfaml0dGVyX3NsaWRlciI6MCwieWF3IjoiU2lkZXdheXMiLCJ5YXdfaml0dGVyIjoiUmFuZG9tIiwieWF3X2xlZnQiOi0yMSwieWF3X3JpZ2h0IjoyMSwieWF3X3NsaWRlciI6MX19LHsiRHVjayI6eyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiTCAmIFIiLCJwaXRjaCI6IkRvd24iLCJ5YXdfc2xpZGVyX3N0YXRpYyI6MCwiYm9keV95YXciOiJKaXR0ZXIiLCJib2R5X3lhd19zbGlkZXIiOjAsInlhdyI6IjE4MCIsImN1c3RvbV9waXRjaCI6MCwieWF3X3NsaWRlcl9yIjoyMSwieWF3X2ppdHRlcl9zbGlkZXJfbCI6LTIxLCJ5YXdfc2xpZGVyX2RlbGF5IjowLCJ5YXdfaml0dGVyX21vZGUiOiJTdGF0aWMiLCJ5YXdfaml0dGVyIjoiUmFuZG9tIiwieWF3X2ppdHRlcl9zbGlkZXJfc3RhdGljIjowLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjoyMSwieWF3X3NsaWRlcl9sIjotMjF9LCJEdWNrLW1vdmUiOnsiZW5hYmxlIjp0cnVlLCJ5YXdfdHlwZSI6IkwgJiBSIiwicGl0Y2giOiJEb3duIiwieWF3X3NsaWRlcl9zdGF0aWMiOjAsImJvZHlfeWF3IjoiSml0dGVyIiwiYm9keV95YXdfc2xpZGVyIjowLCJ5YXciOiIxODAiLCJjdXN0b21fcGl0Y2giOjAsInlhd19zbGlkZXJfciI6MjEsInlhd19qaXR0ZXJfc2xpZGVyX2wiOi0yMSwieWF3X3NsaWRlcl9kZWxheSI6MCwieWF3X2ppdHRlcl9tb2RlIjoiU3RhdGljIiwieWF3X2ppdHRlciI6IlJhbmRvbSIsInlhd19qaXR0ZXJfc2xpZGVyX3N0YXRpYyI6MCwieWF3X2ppdHRlcl9zbGlkZXJfciI6MjEsInlhd19zbGlkZXJfbCI6LTIxfSwiUnVuIjp7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJMICYgUiIsInBpdGNoIjoiRG93biIsInlhd19zbGlkZXJfc3RhdGljIjowLCJib2R5X3lhdyI6IkppdHRlciIsImJvZHlfeWF3X3NsaWRlciI6MCwieWF3IjoiMTgwIiwiY3VzdG9tX3BpdGNoIjowLCJ5YXdfc2xpZGVyX3IiOjIxLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjotMjEsInlhd19zbGlkZXJfZGVsYXkiOjAsInlhd19qaXR0ZXJfbW9kZSI6IlN0YXRpYyIsInlhd19qaXR0ZXIiOiJSYW5kb20iLCJ5YXdfaml0dGVyX3NsaWRlcl9zdGF0aWMiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjIxLCJ5YXdfc2xpZGVyX2wiOi0yMX0sIkdsb2JhbCI6eyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiTCAmIFIiLCJwaXRjaCI6IkRvd24iLCJ5YXdfc2xpZGVyX3N0YXRpYyI6MCwiYm9keV95YXciOiJKaXR0ZXIiLCJib2R5X3lhd19zbGlkZXIiOjAsInlhdyI6IjE4MCIsImN1c3RvbV9waXRjaCI6MCwieWF3X3NsaWRlcl9yIjoyMSwieWF3X2ppdHRlcl9zbGlkZXJfbCI6LTIxLCJ5YXdfc2xpZGVyX2RlbGF5IjowLCJ5YXdfaml0dGVyX21vZGUiOiJTdGF0aWMiLCJ5YXdfaml0dGVyIjoiUmFuZG9tIiwieWF3X2ppdHRlcl9zbGlkZXJfc3RhdGljIjowLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjoyMSwieWF3X3NsaWRlcl9sIjotMjF9LCJTdGFuZCI6eyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiTCAmIFIiLCJwaXRjaCI6IkRvd24iLCJ5YXdfc2xpZGVyX3N0YXRpYyI6MCwiYm9keV95YXciOiJKaXR0ZXIiLCJib2R5X3lhd19zbGlkZXIiOjAsInlhdyI6IjE4MCIsImN1c3RvbV9waXRjaCI6MCwieWF3X3NsaWRlcl9yIjoyMSwieWF3X2ppdHRlcl9zbGlkZXJfbCI6LTIxLCJ5YXdfc2xpZGVyX2RlbGF5IjowLCJ5YXdfaml0dGVyX21vZGUiOiJTdGF0aWMiLCJ5YXdfaml0dGVyIjoiUmFuZG9tIiwieWF3X2ppdHRlcl9zbGlkZXJfc3RhdGljIjowLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjoyMSwieWF3X3NsaWRlcl9sIjotMjF9LCJGYWtlbGFnIjp7ImVuYWJsZSI6ZmFsc2UsInlhd190eXBlIjoiTCAmIFIiLCJwaXRjaCI6IkRvd24iLCJ5YXdfc2xpZGVyX3N0YXRpYyI6MCwiYm9keV95YXciOiJKaXR0ZXIiLCJib2R5X3lhd19zbGlkZXIiOjAsInlhdyI6IjE4MCIsImN1c3RvbV9waXRjaCI6MCwieWF3X3NsaWRlcl9yIjoyMSwieWF3X2ppdHRlcl9zbGlkZXJfbCI6LTIxLCJ5YXdfc2xpZGVyX2RlbGF5IjowLCJ5YXdfaml0dGVyX21vZGUiOiJTdGF0aWMiLCJ5YXdfaml0dGVyIjoiUmFuZG9tIiwieWF3X2ppdHRlcl9zbGlkZXJfc3RhdGljIjowLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjoyMSwieWF3X3NsaWRlcl9sIjotMjF9LCJKdW1wIjp7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJMICYgUiIsInBpdGNoIjoiRG93biIsInlhd19zbGlkZXJfc3RhdGljIjowLCJib2R5X3lhdyI6IkppdHRlciIsImJvZHlfeWF3X3NsaWRlciI6MCwieWF3IjoiMTgwIiwiY3VzdG9tX3BpdGNoIjowLCJ5YXdfc2xpZGVyX3IiOjIxLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjotMjEsInlhd19zbGlkZXJfZGVsYXkiOjAsInlhd19qaXR0ZXJfbW9kZSI6IlN0YXRpYyIsInlhd19qaXR0ZXIiOiJSYW5kb20iLCJ5YXdfaml0dGVyX3NsaWRlcl9zdGF0aWMiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjIxLCJ5YXdfc2xpZGVyX2wiOi0yMX0sIlNsb3d3YWxrIjp7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJMICYgUiIsInBpdGNoIjoiRG93biIsInlhd19zbGlkZXJfc3RhdGljIjowLCJib2R5X3lhdyI6IkppdHRlciIsImJvZHlfeWF3X3NsaWRlciI6MCwieWF3IjoiMTgwIiwiY3VzdG9tX3BpdGNoIjowLCJ5YXdfc2xpZGVyX3IiOjIxLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjotMjEsInlhd19zbGlkZXJfZGVsYXkiOjAsInlhd19qaXR0ZXJfbW9kZSI6IlN0YXRpYyIsInlhd19qaXR0ZXIiOiJSYW5kb20iLCJ5YXdfaml0dGVyX3NsaWRlcl9zdGF0aWMiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjIxLCJ5YXdfc2xpZGVyX2wiOi0yMX0sIkR1Y2stanVtcCI6eyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiTCAmIFIiLCJwaXRjaCI6IkRvd24iLCJ5YXdfc2xpZGVyX3N0YXRpYyI6MCwiYm9keV95YXciOiJKaXR0ZXIiLCJib2R5X3lhd19zbGlkZXIiOjAsInlhdyI6IjE4MCIsImN1c3RvbV9waXRjaCI6MCwieWF3X3NsaWRlcl9yIjoyMSwieWF3X2ppdHRlcl9zbGlkZXJfbCI6LTIxLCJ5YXdfc2xpZGVyX2RlbGF5IjowLCJ5YXdfaml0dGVyX21vZGUiOiJTdGF0aWMiLCJ5YXdfaml0dGVyIjoiUmFuZG9tIiwieWF3X2ppdHRlcl9zbGlkZXJfc3RhdGljIjowLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjoyMSwieWF3X3NsaWRlcl9sIjotMjF9fSx7ImVuYWJsZSI6ZmFsc2UsInJlc2V0aWYiOlsiVGFyZ2V0IERlYXRoIiwiUmVhY2hlZCBUaW1lIExpbmUiLCJ+Il0sInBoYXNlIjoiMyIsInN0YXRlIjpbIlN0YW5kIiwiRHVjayIsIn4iXX0sW3siYm9keV95YXciOjExMywiaml0dGVyIjozLCJlbmFibGVkIjp0cnVlfSx7ImJvZHlfeWF3IjoxMTMsImppdHRlciI6MywiZW5hYmxlZCI6dHJ1ZX0seyJib2R5X3lhdyI6MTEzLCJqaXR0ZXIiOjMsImVuYWJsZWQiOnRydWV9LHsiYm9keV95YXciOjExMywiaml0dGVyIjozLCJlbmFibGVkIjpmYWxzZX0seyJib2R5X3lhdyI6MTEzLCJqaXR0ZXIiOjMsImVuYWJsZWQiOmZhbHNlfV1d"}
}

local ui_menu = {
    tabs_names = {"","","♻","✨","☰",""},
    selected_tab = 1,
    selected_color = { {20, 20, 20, 255}, {210,210,210,255} },
    menu_alpha = 255,
    is_hovered = false,
    dpi_scaling_y = {{84,149},{100,181},{116,213},{132,245},{148,276}},
    pesadelo_na_cozinha2 = {597,741,885,1030,1173 },
    selected_gs_tab = false,
    mouse_press = false,
    old_mpos = {0,0}
}

function is_aa_tab()
    local menu_size = { ui.menu_size() }
  
    
    local menu_pos = { ui.menu_position() }
    local mouse_pos = { ui.mouse_position() }

   local scale = {0,0}
   local scale_x = 0
   local pesadelo_no_direito = 0

    if ui.get(ui.reference("MISC","Settings","DPI scale")) == "100%" then
        scale = { ui_menu.dpi_scaling_y[1][1],ui_menu.dpi_scaling_y[1][2] }
        scale_x = 76
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[1]
    elseif ui.get(ui.reference("MISC","Settings","DPI scale"))  == "125%" then
        scale = { ui_menu.dpi_scaling_y[2][1],ui_menu.dpi_scaling_y[2][2] }
        scale_x = 95
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[2]
    elseif ui.get(ui.reference("MISC","Settings","DPI scale"))  == "150%" then
        scale = { ui_menu.dpi_scaling_y[3][1],ui_menu.dpi_scaling_y[3][2] }
        scale_x = 113
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[3]
    elseif ui.get(ui.reference("MISC","Settings","DPI scale"))  == "175%" then
        scale = { ui_menu.dpi_scaling_y[4][1],ui_menu.dpi_scaling_y[4][2] }
        scale_x = 132
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[4]
    elseif ui.get(ui.reference("MISC","Settings","DPI scale"))  == "200%" then
        scale = { ui_menu.dpi_scaling_y[5][1],ui_menu.dpi_scaling_y[5][2] }
        scale_x = 151
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[5]
    end

    if ui_menu.mouse_press == false then
        ui_menu.old_mpos = mouse_pos
    end      

    if client.key_state(0x1) then
        if not ui_menu.mouse_press then
            ui_menu.mouse_press = true
            if mouse_pos[1] > menu_pos[1] + 5 and mouse_pos[1] < menu_pos[1] + 5 + scale_x then
                if mouse_pos[2] > menu_pos[2] + scale[1] and mouse_pos[2] < menu_pos[2] + scale[2] then
                    ui_menu.selected_gs_tab = true
                    
                elseif mouse_pos[2] > menu_pos[2] + 19 and (menu_size[2] >= pesadelo_no_direito and mouse_pos[2] < menu_pos[2] + menu_size[2] or mouse_pos[2] < menu_pos[2] + pesadelo_no_direito) and ui_menu.selected_gs_tab == true then
                    ui_menu.selected_gs_tab = false
                end
            end
        end
    else
        ui_menu.mouse_press = false
    end
end


function new_tab()

    ui_menu.is_hovered = false
    if not ui.is_menu_open()  then
        ui_menu.menu_alpha = 0
    else
        ui_menu.menu_alpha = 255
    end

    if ui_menu.menu_alpha < 254 then return end

    local menu_size = { ui.menu_size() }
    local divide_menu = (menu_size[1] - 12) / #ui_menu.tabs_names
    
    local menu_pos = { ui.menu_position() }
    local mouse_pos = { ui.mouse_position() }

    if not ui_menu.selected_gs_tab then return end

    for k,v in ipairs(ui_menu.tabs_names) do

        if ui_menu.selected_tab == k then
            ui_menu.selected_color[1] = {20, 20, 20}
            ui_menu.selected_color[2] = {210, 210, 210}
        else
            ui_menu.selected_color[1] = {12, 12, 12}
            ui_menu.selected_color[2] = {90, 90, 90}
        end
       
        renderer.text(menu_pos[1] + (divide_menu * k) - divide_menu / 2 ,menu_pos[2] - 25,ui_menu.selected_color[2][1], ui_menu.selected_color[2][2], ui_menu.selected_color[2][3],ui_menu.menu_alpha,"cd+",0,v)

        if mouse_pos[1] > menu_pos[1] + (divide_menu * k) -  divide_menu and mouse_pos[1] < menu_pos[1] + (divide_menu * k) and mouse_pos[2] > menu_pos[2] - 50 and mouse_pos[2] < menu_pos[2] then
            ui_menu.is_hovered = true
            if  client.key_state(0x1) then
                ui_menu.selected_tab = k
            end
        end
    end
    renderer.text(menu_pos[1] + (divide_menu * ui_menu.selected_tab) - divide_menu / 2 ,menu_pos[2] - 25,210, 210, 210,ui_menu.menu_alpha,"cd+",0,ui_menu.tabs_names[ui_menu.selected_tab])
end

function render_tabs() 
    if not ui_menu.selected_gs_tab then return end

    if ui_menu.menu_alpha < 254 then return end

    local menu_s = { ui.menu_size() }
    local menu_p = { ui.menu_position() }

    local divide_menu = (menu_s[1] - 12) / #ui_menu.tabs_names
    

    renderer.texture(tex_id, menu_p[1] + 1, menu_p[2]-49, menu_s[1] - 2, 50, 255, 255, 255, ui_menu.menu_alpha, "r")

    renderer.rectangle(menu_p[1] + (divide_menu * ui_menu.selected_tab) - divide_menu + 4, menu_p[2] - 44,divide_menu -1,44,11,11,11,ui_menu.menu_alpha) 
    
    --top bar
    renderer.rectangle(menu_p[1] ,menu_p[2] - 53,menu_s[1] ,1 ,12,12,12,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + 2,menu_p[2] - 52,menu_s[1] - 4,5 ,60,60,60,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + 2,menu_p[2] - 51,menu_s[1] - 4,3 ,40,40,40,ui_menu.menu_alpha) 
    
    --left bar
    renderer.rectangle(menu_p[1] ,menu_p[2] - 53,1,53 ,12,12,12,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + 1,menu_p[2] - 52,4,52 ,60,60,60,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + 2,menu_p[2] - 51,3,51 ,40,40,40,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + 5,menu_p[2] - 48,1,48 ,60,60,60,ui_menu.menu_alpha)
    
    --right bar
    renderer.rectangle(menu_p[1] + menu_s[1] - 1,menu_p[2] - 53,1,53 ,12,12,12,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + menu_s[1] - 3,menu_p[2] - 52,2,52 ,60,60,60,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + menu_s[1] - 5,menu_p[2] - 51,3,51 ,40,40,40,ui_menu.menu_alpha)
    renderer.rectangle(menu_p[1] + menu_s[1] - 6,menu_p[2] - 48,1,48 ,60,60,60,ui_menu.menu_alpha) 

    renderer.gradient(menu_p[1] + 7,menu_p[2] - 46, menu_s[1]/2,1, 59, 175, 222, ui_menu.menu_alpha, 202, 70, 205, ui_menu.menu_alpha,true)
                
    renderer.gradient(menu_p[1] + 7 + menu_s[1]/2 ,menu_p[2] - 46, menu_s[1]/2 - 13.3, 1,203, 70, 205, ui_menu.menu_alpha,204, 227, 53, ui_menu.menu_alpha,true)
end

local aa_table = {
    states = {"Global", "Stand", "Run", "Duck", "Duck-move", "Jump", "Duck-jump", "Slowwalk", "Fakelag"},
    defensive_states = {"Stand", "Run", "Duck", "Duck-move", "Jump", "Duck-jump", "Slowwalk"},
    anti_bf_states = {"Stand", "Run", "Duck", "Duck-move", "Jump", "Duck-jump", "Slowwalk"},
    pitch = {'Off','Default','Up', 'Down', 'Minimal', 'Random', 'Custom'},
    yaw = {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'},
    yaw_base = {"Local view", "At targets"}
}

local anti_bf_table = {
    max_phase = 5,
    phase_to_string = {"1", "2", "3", "4", "5"},
    entity = entity.get_local_player(),
    entity_2 = nil,
    recorded_ent = nil,
    miss_counter = 0,
    timer_brute = 0,
    entity_changed = false
}

local _ui = {
    lua = {
        enable_lua = group:checkbox("\vInte\rritus".." | \v".. euphemia.username),
        text_build = group:label("Build ~ \v"..euphemia.build),
        tab = group:combobox("\n ", "Anti-aim", "Defensive", "Anti-Bruteforce", "Visuals", "Miscellaneous", "Config"),    
    },

    keybinds = {
        freestanding = group_other:hotkey("Freestanding"),
        manual_left = group_other:hotkey("Manual left"),
        manual_right = group_other:hotkey("Manual right"),
        manual_forward = group_other:hotkey("Manual forward"),
        freestanding_disablers = group_other:multiselect("Freestanding disablers", aa_table.states),
        tweaks = group_other:multiselect("Tweaks", "Anti-backstab", "Safe head", "E-Spam")
    },

    antiaim = {
        enable = group:checkbox("Enable ~ \vBuilder"),
        yaw_base = group:combobox("Yaw base", aa_table.yaw_base),
        state = group:combobox("State", aa_table.states)
    },

    defensive = {
        enable = group:checkbox("Enable ~ \vDefensive"),
        state = group:combobox("State", aa_table.defensive_states)
    },

    anti_bf = {
        enable = group:checkbox("Enable ~ \vAnti-Bruteforce"),
        resetif = group:multiselect("Reset when", {"Target Death", "Reached Time Line"}),
        state = group:multiselect("State", aa_table.anti_bf_states),
        phase = group:combobox("Phase", anti_bf_table.phase_to_string)
    },

    visuals = {
        enable = group:checkbox("Enable ~ \vVisuals", {255, 115, 105, 255}),
        hitlogs = group:multiselect("Hitlogs", {"Hit", "Miss", "Naded", "Fired"}),
        notify_style = group:combobox("Notification style", {"Default", "Modern", "OG"}),
        inds_style = group:combobox("Indicators", {"Off", "Pixel", "Minimal", "Modern"}),
        inds_options = group:multiselect("Indicators modification", {"In scope", "Animated", "Alpha"}),
        watermarks = group:combobox("Watermark", {"Off", "Default", "Minimal", "Legacy", "Interitus", "Country-Based"}),
        watermarks_pos = group:combobox("Pos", {"Bottom", "Left"}),
        watermark_options = group:multiselect("Watermark modification", {"Desync", "Alpha"}),
        others = group:multiselect("Other", {"Defensive", "Slow-down"}),
        debug_panel = group:combobox("Debug Panel", {"Off", "Default", "Modern"}),
        antiaim_arrows = group:combobox("Arrows", {"Off", "TeamSkeet"})
    },

    misc = {
        alternative_ui = group:checkbox("Alternative ui"),
        anims = group:multiselect("Anims", "pitch 0","reversed legs","static legs", "leg braker","perfect"),
        clantag = group:checkbox("Clantag"),
        fast_ladder = group:checkbox("Fast ladder")
    },

    cfgs = {
        cfgs_select = group:combobox("\n ", {"Local", "Discord"}),
        --import = group:button("\vImport", function() import_cfg() end),
        --export = group:button("\vExport", function() export_cfg() end),
        --default = group:button("\vDefault", function() default_cfg() end),
        --share = group:button("\vShare on discord", function() share_cfg() end),
        discord_list = group:listbox("Discord", {"No cfgs found."}),
        discord_load = group:button("\vLoad", function() load_discord_cfgs() end),
        discord_refresh = group:button("\vRefresh", function() refresh_discord_cfgs() end)
    }
}

_ui.lua.text_build:depend({_ui.lua.enable_lua, true})
_ui.lua.tab:depend({_ui.lua.enable_lua, true}, {_ui.misc.alternative_ui, false})
_ui.antiaim.enable:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-aim"})
_ui.antiaim.yaw_base:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true})
_ui.antiaim.state:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true})
_ui.defensive.enable:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Defensive"})
_ui.defensive.state:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Defensive"}, {_ui.defensive.enable, true})
_ui.cfgs.cfgs_select:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Config"})
--_ui.cfgs.import:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Config"}, {_ui.cfgs.cfgs_select, "Local"})
--_ui.cfgs.export:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Config"}, {_ui.cfgs.cfgs_select, "Local"})
_ui.cfgs.discord_list:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Config"}, {_ui.cfgs.cfgs_select, "Discord"})
_ui.cfgs.discord_load:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Config"}, {_ui.cfgs.cfgs_select, "Discord"})
_ui.cfgs.discord_refresh:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Config"}, {_ui.cfgs.cfgs_select, "Discord"})
_ui.visuals.enable:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Visuals"})
_ui.keybinds.freestanding:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-aim"})
_ui.keybinds.manual_left:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-aim"})
_ui.keybinds.manual_right:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-aim"})
_ui.keybinds.manual_forward:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-aim"})
_ui.keybinds.tweaks:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-aim"})
_ui.misc.clantag:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Miscellaneous"})
_ui.misc.fast_ladder:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Miscellaneous"})
_ui.misc.alternative_ui:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Miscellaneous"})
_ui.misc.anims:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Miscellaneous"})
_ui.keybinds.freestanding_disablers:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-aim"})
_ui.visuals.notify_style:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.enable, true})
_ui.visuals.antiaim_arrows:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.enable, true})
_ui.visuals.inds_style:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.enable, true})
_ui.visuals.hitlogs:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.enable, true})
_ui.visuals.watermarks:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.enable, true})
_ui.visuals.watermarks_pos:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.enable, true}, {_ui.visuals.watermarks, function() return _ui.visuals.watermarks.value ~= "Off" end })
_ui.visuals.others:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.enable, true})
_ui.visuals.debug_panel:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.enable, true})
_ui.visuals.watermark_options:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.enable, true}, {_ui.visuals.watermarks, function() return _ui.visuals.watermarks.value ~= "Off" end })
_ui.visuals.inds_options:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.inds_style, function() return _ui.visuals.inds_style.value ~= "Off" end }, {_ui.visuals.enable, true})
--_ui.cfgs.default:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Config"}, {_ui.cfgs.cfgs_select, "Local"})
--_ui.cfgs.share:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Config"}, {_ui.cfgs.cfgs_select, "Local"})
_ui.anti_bf.enable:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-Bruteforce"})
_ui.anti_bf.phase:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-Bruteforce"}, {_ui.anti_bf.enable, true})
_ui.anti_bf.resetif:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-Bruteforce"}, {_ui.anti_bf.enable, true})
_ui.anti_bf.state:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-Bruteforce"}, {_ui.anti_bf.enable, true})

aa_builder = {}
for i, state in ipairs(aa_table.states) do
    aa_builder[state] = {}
    local menu = aa_builder[state]

    menu.enable = group:checkbox("Enable ~ \v ".. aa_table.states[i])
    menu.pitch = group:combobox("Pitch", aa_table.pitch)
    menu.custom_pitch = group:slider("\n ", -89, 89, 0, true, "°")
    menu.yaw = group:combobox("Yaw", aa_table.yaw)
    menu.yaw_type = group:combobox("Yaw type", {"Static", "L & R", "Delay"})
    menu.yaw_slider_static = group:slider("\n ", -180, 180, 0, true, "°", 1)
    menu.yaw_slider_l = group:slider("Left", -180, 180, 0, true, "°", 1)
    menu.yaw_slider_r = group:slider("Right", -180, 180, 0, true, "°", 1)
    menu.yaw_slider_delay = group:slider("Delay", 0, 15, 0, true, "%", 1)
    menu.yaw_jitter = group:combobox("Yaw jitter", {"Off", "Offset", "Center", "Random", "Skitter"})
    menu.yaw_jitter_mode = group:combobox("Jitter type", {"Static", "L & R"})
    menu.yaw_jitter_slider_static = group:slider("\n ", -180, 180, 0, true, "°", 1)
    menu.yaw_jitter_slider_l = group:slider("Left", -180, 180, 0, true, "°", 1)
    menu.yaw_jitter_slider_r = group:slider("Right", -180, 180, 0, true, "°", 1)
    menu.body_yaw = group:combobox("Body yaw", {"Off", "Opposite", "Jitter", "Static"})
    menu.body_yaw_slider = group:slider("\n ", -180, 180, 0, true, "°", 1)
end

for i, state in ipairs(aa_table.states) do
    local menu = aa_builder[state]
    local is_tab = {_ui.lua.tab, "Anti-aim"}
    local is_enabled_lua = {_ui.lua.enable_lua, true}
    local is_checkbox_checked = {_ui.antiaim.enable, true}
    local is_enabled = {menu.enable, true}
    local is_state = {_ui.antiaim.state, aa_table.states[i]}
    menu.enable:depend(is_tab, is_state, is_checkbox_checked, is_enabled_lua)
    menu.pitch:depend(is_tab, is_state, is_checkbox_checked, is_enabled, is_enabled_lua)
    menu.custom_pitch:depend(is_tab, is_state, is_checkbox_checked, is_enabled, {menu.pitch, "Custom"}, is_enabled_lua)
    menu.yaw:depend(is_tab, is_state, is_checkbox_checked, is_enabled, is_enabled_lua)
    menu.yaw_type:depend(is_tab, is_state, is_checkbox_checked, is_enabled, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, is_enabled_lua)
    menu.yaw_slider_static:depend(is_tab, is_state, is_checkbox_checked, is_enabled, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, {menu.yaw_type, function() return menu.yaw_type.value == "Static" end}, is_enabled_lua)
    menu.yaw_slider_l:depend(is_tab, is_state, is_checkbox_checked, is_enabled, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, {menu.yaw_type, function() return menu.yaw_type.value ~= "Static" end}, is_enabled_lua)
    menu.yaw_slider_r:depend(is_tab, is_state, is_checkbox_checked, is_enabled, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, {menu.yaw_type, function() return menu.yaw_type.value ~= "Static" end}, is_enabled_lua)
    menu.yaw_slider_delay:depend(is_tab, is_state, is_checkbox_checked, is_enabled, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, {menu.yaw_type, function() return menu.yaw_type.value == "Delay" end}, is_enabled_lua)
    menu.yaw_jitter:depend(is_tab, is_state, is_checkbox_checked, is_enabled, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, is_enabled_lua)
    menu.yaw_jitter_mode:depend(is_tab, is_state, is_checkbox_checked, is_enabled, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, {menu.yaw_jitter, function() return menu.yaw_jitter.value ~= "Off" end}, is_enabled_lua)
    menu.yaw_jitter_slider_static:depend(is_tab, is_state, is_checkbox_checked, is_enabled, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, {menu.yaw_jitter, function() return menu.yaw_jitter.value ~= "Off" end}, {menu.yaw_jitter_mode, function() return menu.yaw_jitter_mode.value == "Static" end}, is_enabled_lua)
    menu.yaw_jitter_slider_l:depend(is_tab, is_state, is_checkbox_checked, is_enabled, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, {menu.yaw_jitter, function() return menu.yaw_jitter.value ~= "Off" end}, {menu.yaw_jitter_mode, function() return menu.yaw_jitter_mode.value == "L & R" end}, is_enabled_lua)
    menu.yaw_jitter_slider_r:depend(is_tab, is_state, is_checkbox_checked, is_enabled, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, {menu.yaw_jitter, function() return menu.yaw_jitter.value ~= "Off" end}, {menu.yaw_jitter_mode, function() return menu.yaw_jitter_mode.value == "L & R" end}, is_enabled_lua)
    menu.body_yaw:depend(is_tab, is_state, is_checkbox_checked, is_enabled, is_enabled_lua)
    menu.body_yaw_slider:depend(is_tab, is_state, is_checkbox_checked, is_enabled, {menu.body_yaw, function() return menu.body_yaw.value ~= "Off" and menu.body_yaw.value ~= "Opposite" end}, is_enabled_lua)
end

defensive_builder = {}
for i, state in ipairs(aa_table.defensive_states) do 
    defensive_builder[state] = {}
    local menu = defensive_builder[state]

    menu.force = group:checkbox("Force \vdefensive")
    menu.enable = group:checkbox("Override ~\v ".. aa_table.defensive_states[i])
    menu.pitch = group:combobox("Pitch", 'Disabled', 'Up', 'Zero', 'Random', 'Interitus', 'Custom')
    menu.custom_pitch = group:slider("\n ", -89, 89, 0, true, "°")
    menu.yaw = group:combobox("Yaw", 'Disabled', 'Sideways', 'Random', 'Spin', "3-Way", "5-Way", "L & R")
    menu.yaw_slider = group:slider("\n ", 1, 100, 70, true, "%")
    menu.yaw_left = group:slider("Left", -100, 100, 0, true, "°")
    menu.yaw_right = group:slider("Right", -100, 100, 0, true, "°")
    menu.yaw_jitter = group:combobox("Yaw jitter", {"Off", "Offset", "Center", "Random", "Skitter"})
    menu.yaw_jitter_slider = group:slider("\n ", -180, 180, 0, true, "°")
    menu.mode = group:combobox("Mode", {"Always on", "Switch", "Invalid ticks"})
end

for i, state in ipairs(aa_table.defensive_states) do 
    local menu = defensive_builder[state]
    local is_tab = {_ui.lua.tab, "Defensive"}
    local is_enabled = {_ui.defensive.enable, true}
    local is_enabled_lua = {_ui.lua.enable_lua, true}
    local is_state = {_ui.defensive.state, aa_table.defensive_states[i]}
    menu.force:depend(is_tab, is_enabled, is_state, {menu.enable, false}, is_enabled_lua)
    menu.enable:depend(is_tab, is_state, is_enabled, {menu.force, false}, is_enabled_lua)
    menu.pitch:depend(is_tab, is_state, is_enabled, {menu.enable, true}, is_enabled_lua)
    menu.custom_pitch:depend(is_tab, is_state, is_enabled, {menu.enable, true}, {menu.pitch, "Custom"}, is_enabled_lua)
    menu.yaw:depend(is_tab, is_state, is_enabled, {menu.enable, true}, is_enabled_lua)
    menu.yaw_slider:depend(is_tab, is_state, is_enabled, {menu.enable, true}, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, is_enabled_lua, {menu.yaw, "Spin"})
    menu.yaw_left:depend(is_tab, is_state, is_enabled, {menu.enable, true}, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, is_enabled_lua, {menu.yaw, "L & R"})
    menu.yaw_right:depend(is_tab, is_state, is_enabled, {menu.enable, true}, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, is_enabled_lua, {menu.yaw, "L & R"})
    menu.yaw_jitter:depend(is_tab, is_state, is_enabled, {menu.enable, true}, {menu.yaw, function() return menu.yaw.value ~= "Off" end}, is_enabled_lua)
    menu.yaw_jitter_slider:depend(is_tab, is_state, is_enabled, {menu.enable, true}, {menu.yaw_jitter, function() return menu.yaw_jitter.value ~= "Off" end}, is_enabled_lua)
    menu.mode:depend(is_tab, is_state, is_enabled, {menu.enable, true}, is_enabled_lua)
end

anti_bf_builder = {}
for i = 1, anti_bf_table.max_phase do 
    anti_bf_builder[i] = {}
    local menu = anti_bf_builder[i]
    
    menu.enabled = group:checkbox("Enable ~ [\v"..i.."\r] phase")
    menu.jitter = group:slider("Yaw jitter", -180, 180, 0, true, "g", 1)
    menu.body_yaw = group:slider("Body yaw limit", -180, 180, 0, true, "proc", 1)
end

for i = 1, anti_bf_table.max_phase do 
    local menu = anti_bf_builder[i]

    menu.enabled:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-Bruteforce"}, {_ui.anti_bf.enable, true}, {_ui.anti_bf.phase, anti_bf_table.phase_to_string[i]})
    menu.jitter:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-Bruteforce"}, {_ui.anti_bf.enable, true}, {_ui.anti_bf.phase, anti_bf_table.phase_to_string[i]}, {menu.enabled, true})
    menu.body_yaw:depend({_ui.lua.enable_lua, true}, {_ui.lua.tab, "Anti-Bruteforce"}, {_ui.anti_bf.enable, true}, {_ui.anti_bf.phase, anti_bf_table.phase_to_string[i]}, {menu.enabled, true})
end

local config_items = {
    _ui.antiaim,
    _ui.defensive,
    defensive_builder,
    aa_builder,
    _ui.anti_bf,
    anti_bf_builder
}

local package = pui.setup(config_items)

-- function import_cfg()
--     local protected = function()
--         decrypted = json.parse(base64.decode(clipboard.get()))
--         package:load(decrypted)
--     end

--     if pcall(protected) then
--         new_notify("Successfully! Imported settings from clipboard", 255, 115, 105)
--     else
--         new_notify("Error", 214, 0, 36,255)
--     end
-- end

-- function export_cfg()
--     local protected = function()
--         data = package:save()
--         local encrypted = base64.encode(json.stringify(data))

--         clipboard.set(encrypted)
--     end

--     if pcall(protected) then
--         new_notify("Successfully! Exported settings to clipboard", 255, 115, 105)
--     else
--         new_notify("Error", 214, 0, 36,255)
--     end
-- end

local cfgs_to_list = {}
function refresh_discord_cfgs()
    http.get("https://wyscigufa9.ct8.pl/get_cfg_list.php", function(r, s)
        if r then
            local data = json.parse(s.body)
            cfgs_to_list = data.cfgs
            _ui.cfgs.discord_list:update(data.cfgs)
        else
            new_notify("Error",214, 0, 36,255)
        end
    end)
end
refresh_discord_cfgs()

function load_discord_cfgs()
    local list_item = (_ui.cfgs.discord_list:get() + 1)
    if list_item == nil then return end
    local selected_item = cfgs_to_list[list_item]

    http.get("https://wyscigufa9.ct8.pl/get_cfg.php?cfgs="..selected_item, function(r, s)
        if r then
            local data = json.parse(s.body)
            decrypted = json.parse(base64.decode(data.cfgs))
            package:load(decrypted)

            new_notify("Successfully! Imported settings from discord", 255, 115, 105)
        else
            new_notify("Error",214, 0, 36,255)
        end
    end)
    --discord_load
end

function default_cfg()
    http.get("https://wyscigufa9.ct8.pl/cfgs/default.txt", function(r,s)
        if r then
            package:load(json.parse(base64.decode(s.body)))
            new_notify("Successfully! Loaded default config",255, 115, 105)
        else
            new_notify("Error",214, 0, 36,255)
        end
    end)
end

local function downloadlogo()
    http.get("https://media.discordapp.net/attachments/882593635638599773/1162054826264367334/inter.png?ex=661806e4&is=660591e4&hm=9f63dc2461754239ac86a03ddb7b24e40f613b38eecd269bedb20e83cfb5dc41&=", function(success, response)
        if not success or response.status ~= 200 then
            return
        end

    writefile("inter.png", response.body)
    end)
end
downloadlogo()

local function downloadFile()
	http.get(string.format("https://flagcdn.com/w160/%s.png", panorama.open().MyPersonaAPI.GetMyCountryCode():lower()), function(success, response)
		if not success or response.status ~= 200 then
            return
		end

        writefile("flag_"..panorama.open().MyPersonaAPI.GetMyCountryCode():lower()..".png", response.body)
	end)
end
downloadFile()

function share_cfg()
    data = package:save()
    local encrypted = base64.encode(json.stringify(data))

    http.get("https://wyscigufa9.ct8.pl/post_cfg.php?encrypted_data="..encrypted.."&unix_time="..client.unix_time().."&name_cfgs="..euphemia.username.."", function(r, s)
        if r then

            local Webhook = discord.new("https://discord.com/api/webhooks/1224815076641476609/ba7c1JAV2Pv9ezdu9iHlxuuaV90lg97hr3xHmKaklnasuK2xbdZy1fzlVOJk6Jy08vCi")
            local RichEmbed = discord.newEmbed()

            Webhook:setUsername("Interitus cfg")
            RichEmbed:setTitle(euphemia.username .. " ~ " .. euphemia.build)
            RichEmbed:setDescription("Cfg uploaded successfully\nyou can download it [here]("..s.body..")")
            RichEmbed:setColor(16741225)
            Webhook:send(RichEmbed)

            new_notify("Successfully! Shared cfg",255, 115, 105)
        else
            new_notify("Error",214, 0, 36,255)
        end

    end)
end

local prev_simulation_time = 0

local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end

local diff_sim = 0

function sim_diff() 
    local current_simulation_time = time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
end

function normalize_yaw(yaw) yaw = (yaw % 360 + 360) % 360 return yaw > 180 and yaw - 360 or yaw end

local ground_tick = 1
local end_time = 0
local ground_ticks = 1
local last_sim_time = 0
local defensive_until = 0
current_tickcount = 0
ind_anim_scope = 0
ind_anim_scope_alpha = 1
watermark_alpha = 1
to_jitter = false
alpha_anim = 0
local notify_hover = false
local ind_hover = false
local debug_hover = false
local ft_prev = 0
to_draw = "no"
to_up = "no"
local checker = 0
local aguwno = 0
to_draw_ticks = 0
local clantags = {
    '',
    'i',
    'in',
    'int',
    'inte',
    'inter',
    'interi',
    'interit',
    'interitu',
    'interitus.',
    'interitus.r',
    'interitus.re',
    'interitus.red',
    'interitus.red',
    'interitus.red',
    'interitus.red',
    'nteritus.red',
    'eritus.red',
    'ritus.red',
    'itus.red',
    'tus.red',
    'us.red',
    's.red',
    'red',
    'ed',
    'd',
    ''
}
local clantag_prev

local hitlogs_pos = {
    pos_x = X / 2 - 180,
    pos_y = Y - 280,
    size_w = 370,
    size_h = 235
}

local indicator_pos = {
    pos_x = X / 2 - 30,
    pos_y = Y /2 + 25,
    size_w = 60,
    size_h = 70
}

local debug_pos = {
    pos_x = 40,
    pos_y = Y /2 + 25,
    size_w = 140,
    size_h = 90
}

local ctx = (function()
    local ctx = {}

    ctx.cfgs = {
        delete_config = function(name)
            local db = database.read(cfg_data.database.configs) or {}
        
            for i, v in pairs(db) do
                if v.name == name then
                    table.remove(db, i)
                    break
                end
            end
        
            for i, v in pairs(cfg_data.presets) do
                if v.name == name then
                    return false
                end
            end
        
            database.write(cfg_data.database.configs, db)
        end,
        if_preset = function(name)
            for i, v in pairs(cfg_data.presets) do
                if v.name == name then
                    return true
                end
            end
            return false
        end,
        get_config = function(name)
            local database = database.read(cfg_data.database.configs)

            for i, v in pairs(database) do
                if v.name == name then
                    return {
                        config = v.config,
                        index = i
                    }
                end
            end
        
            for i, v in pairs(cfg_data.presets) do
                if v.name == name then
                    return {
                        config = v.config,
                        index = i
                    }
                end
            end
        
            return false
        end,
        save_config = function(name)
            local db = database.read(cfg_data.database.configs) or {}
            local config = {}

            if name:match("[^%w]") ~= nil then
                return
            end

            data = package:save()
            local encrypted = base64.encode(json.stringify(data))
            table.insert(config, encrypted)

            local cfg = ctx.cfgs.get_config(name)

            if not cfg then
                table.insert(db, {name = name, config = config})
            else
                db[cfg.index].config = config
            end

            database.write(cfg_data.database.configs, db)
        end,
        load_config = function(name)
            local cfg = ctx.cfgs.get_config(name)

            local load_cfg
            if ctx.cfgs.if_preset(name) then
                load_cfg = json.parse(base64.decode(cfg.config))
            else
                load_cfg = json.parse(base64.decode(unpack(cfg.config)))
            end

            package:load(load_cfg)
        end,
        getconfig_list = function()
            local database = database.read(cfg_data.database.configs) or {}
            local config = {}
            local presets = cfg_data.presets
        
            for i, v in pairs(presets) do
                table.insert(config, v.name)
            end
        
            for i, v in pairs(database) do
                table.insert(config, v.name)
            end

            return config
        end,
        export_config = function()
            data = package:save()
            encrypted = base64.encode(json.stringify(data))
            clipboard.set(encrypted)
        end,
        import_config = function()
            decrypted = json.parse(base64.decode(clipboard.get()))
            package:load(decrypted)
        end,
    }

    ctx.m_render = {
        rec = function(self, x, y, w, h, radius, color)
            radius = math.min(x/2, y/2, radius)
            local r, g, b, a = unpack(color)
            renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
            renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
            renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
            renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
            renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
            renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
            renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
        end,

        rec_outline = function(self, x, y, w, h, radius, thickness, color)
            radius = math.min(w/2, h/2, radius)
            local r, g, b, a = unpack(color)
            if radius == 1 then
                renderer.rectangle(x, y, w, thickness, r, g, b, a)
                renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
            else
                renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
                renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
            end
        end,

        glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
            local thickness = 1
            local offset = 1
            local r, g, b, a = unpack(accent)
            if accent_inner then
                self:rec(x , y, w, h + 1, rounding, accent_inner)
            end
            for k = 0, width do
                if a * (k/width)^(1) > 5 then
                    local accent = {r, g, b, a * (k/width)^(2)}
                    self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
                end
            end
        end,

        pandora_og = function(self, x,y,w,h,r,g,b,a, text)
            self:rec(x,y,w,h,3, {0,0,0,a})
            self:rec_outline(x + 1, y + 1, w - 2, h - 2, 3, 1, {45,45,45,a})
            self:rec(x + 3, y + 3, w - 6, h - 6, 2, {15,15,15,a})
            renderer.text(x + 5, y + 6, r,g,b,a, '', nil, text)
        end
    }

    ctx.helps = {
        speed = function()
            if not entity.get_local_player() then return end
            local first_velocity, second_velocity = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
            local speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))
            
            return speed
        end,
        get_state = function(speed, cmd)
            if not entity.is_alive(entity.get_local_player()) then return end
            local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
            local land = bit.band(flags, bit.lshift(1, 0)) ~= 0
            if land == true then ground_tick = ground_tick + 1 else ground_tick = 0 end
        
            if bit.band(flags, 1) == 1 then
                if cmd.allow_send_packet == false or cmd.chokedcommands > 1 then return "Fakelag" end
                if ground_tick < 10 then if bit.band(flags, 4) == 4 then return "Duck-jump" else return "Jump" end end
                if bit.band(flags, 4) == 4 and speed > 9 then 
                    return "Duck-move"
                end
                if bit.band(flags, 4) == 4 or ui.get(refs.ref.fakeduck) then 
                    return "Duck" -- crouching
                else
                    if speed <= 3 then
                        return "Stand" -- standing
                    else
                        if ui.get(refs.ref.slide[2]) then
                            return "Slowwalk" -- slowwalk
                        else
                            return "Run" -- moving
                        end
                    end
                end
            elseif bit.band(flags, 1) == 0 then
                if bit.band(flags, 4) == 4 then
                    return "Duck-jump" -- air-c
                else
                    return "Jump" -- air
                end
            end
        end,
        get_state_defensive = function(speed)
            if not entity.is_alive(entity.get_local_player()) then return end
            local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
            local land = bit.band(flags, bit.lshift(1, 0)) ~= 0
            if land == true then ground_tick = ground_tick + 1 else ground_tick = 0 end
            local next_attack = entity.get_prop(entity.get_local_player(), 'm_flNextAttack') - globals.curtime()

            if bit.band(flags, 1) == 1 then
                if ground_tick < 10 then if bit.band(flags, 4) == 4 then return "Duck-jump" else return "Jump" end end
                if bit.band(flags, 4) == 4 and speed > 9 then 
                    return "Duck-move"
                end
                if bit.band(flags, 4) == 4 or ui.get(refs.ref.fakeduck) then 
                    return "Duck" -- crouching
                else
                    if speed <= 3 then
                        return "Stand" -- standing
                    else
                        if ui.get(refs.ref.slide[2]) then
                            return "Slowwalk" -- slowwalk
                        else
                            return "Run" -- moving
                        end
                    end
                end
            elseif bit.band(flags, 1) == 0 then
                if bit.band(flags, 4) == 4 then
                    return "Duck-jump" -- air-c
                else
                    return "Jump" -- air
                end
            end
        end,
        gen_table_from_number = function(num)
            local sequence = {}
            for i = 1, num do
                table.insert(sequence, tostring(i))
            end
            return table.concat(sequence, ', ')
        end
        
    }

    ctx.defensive_checks = {
        is_defensive_active = function()
            local tickcount = globals.tickcount()
            local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
            local sim_diff = sim_time - last_sim_time

            if sim_diff < 0 then
                defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
            end

            last_sim_time = sim_time

            return defensive_until > tickcount
        end,
        choking = function(cmd)
            local choke = false
        
            if cmd.allow_send_packet == false or cmd.chokedcommands > 1 then
                choke = true
            else
                choke = false
            end
        
            return choke
        end
    }

    ctx.antiaim = {
        run = function(cmd)
            local me = entity.get_local_player()
            if not entity.is_alive(me) then return end
            desync_type = entity.get_prop(me, "m_flPoseParameter", 11) * 120 - 60
            desync_side = desync_type > 0 and 1 or -1

            local state = ctx.helps.get_state(ctx.helps.speed(), cmd)
            if aa_builder[ctx.helps.get_state(ctx.helps.speed(), cmd)].enable.value == false then state = "Global" end 
            local aa_values = aa_builder[state]
            local aa_defensive = defensive_builder[ctx.helps.get_state_defensive(ctx.helps.speed())]

            local pitch_tbl = {
                ['Disabled'] = 89,
                ['Up'] = -89,
                ['Zero'] = 0,
                ['Random'] = math.random(-89, 89),
                ['Interitus'] = aguwno > 2 and aguwno < 14 and -89 or 89,
                ['Custom'] = aa_defensive.custom_pitch.value
            }
            
            local yaw_tbl = {
                ['Disabled'] = 0,
                ['Sideways'] = globals.tickcount() % 3 == 0 and client.random_int(-100, -90) or globals.tickcount() % 3 == 1 and 180 or globals.tickcount() % 3 == 2 and client.random_int(90, 100) or 0,
                ['Random'] = math.random(-180, 180),
                ['Spin'] = normalize_yaw(globals.curtime() * 1000 * (aa_defensive.yaw_slider.value / 100)),
                ['3-Way'] = globals.tickcount() % 3 == 0 and client.random_int(-110, -90) or globals.tickcount() % 3 == 1 and client.random_int(90, 120) or globals.tickcount() % 3 == 2 and client.random_int(-180, -150) or 0,
                ['5-Way'] = globals.tickcount() % 5 == 0 and client.random_int(-90, -75) or globals.tickcount() % 5 == 1 and client.random_int(-45, -30) or globals.tickcount() % 5 == 2 and client.random_int(-180, -160) or globals.tickcount() % 5 == 3 and client.random_int(45, 60) or globals.tickcount() % 5 == 3 and client.random_int(90, 110) or 0,
                ['L & R'] = desync_side == 1 and aa_defensive.yaw_left.value or aa_defensive.yaw_right.value
            }

            if aa_defensive.force.value and not aa_defensive.enable.value then
                cmd.force_defensive = true
            elseif aa_defensive.enable.value and not aa_defensive.force.value then
                if aa_defensive.mode.value == "Always on" then
                    cmd.force_defensive = true
                elseif aa_defensive.mode.value == "Switch" then
                    cmd.force_defensive = cmd.command_number % client.random_int(3,6) == 1
                elseif aa_defensive.mode.value == "Invalid ticks" then
                    cmd.force_defensive = cmd.chokedcommands % 2 == 1 and not cmd.no_choke
                end
            end

            if funcs.contains(_ui.keybinds.freestanding_disablers.value, state) then
                ui.set(refs.ref.freestand[1], false)
            else
                if _ui.keybinds.freestanding:get() == true then
                    ui.set(refs.ref.freestand[1], true)
                    ui.set(refs.ref.freestand[2], "Always on")
                else
                    ui.set(refs.ref.freestand[1], false)
                    ui.set(refs.ref.freestand[2], "On hotkey")
                end
            end

            if aa_defensive.enable.value and ctx.defensive_checks.is_defensive_active() and not ctx.defensive_checks.choking(cmd) and not aa_defensive.force.value and _ui.defensive.enable.value then
                ui.set(refs.ref.yaw, "180")
                ui.set(refs.ref.yaw_value, yaw_tbl[aa_defensive.yaw.value])
                ui.set(refs.ref.pitch, "Custom") 
                ui.set(refs.ref.pitch_value, pitch_tbl[aa_defensive.pitch.value])
                ui.set(refs.ref.yaw_jitter, aa_defensive.yaw_jitter.value)
                ui.set(refs.ref.yaw_jitter_value, aa_defensive.yaw_jitter_slider.value)
            else
                ui.set(refs.ref.aa_enable, _ui.antiaim.enable.value)
                if aa_values.enable.value and _ui.antiaim.enable.value then
                    if globals.tickcount() > current_tickcount + aa_values.yaw_slider_delay.value then
                        if cmd.chokedcommands == 0 then
                           to_jitter = not to_jitter
                           current_tickcount = globals.tickcount()
                        end
                    elseif globals.tickcount() <  current_tickcount then
                        current_tickcount = globals.tickcount()
                    end

                    ui.set(refs.ref.pitch,aa_values.pitch.value)
                    ui.set(refs.ref.pitch_value, aa_values.custom_pitch.value)
                    ui.set(refs.ref.yaw_base, _ui.antiaim.yaw_base.value)
                    ui.set(refs.ref.yaw, aa_values.yaw.value)
                    ui.set(refs.ref.body_yaw, aa_values.body_yaw.value)
                    ui.set(refs.ref.yaw_jitter, aa_values.yaw_jitter.value)
                    ui.set(refs.ref.body_yaw_value, aa_values.body_yaw_slider.value)
                    if aa_values.yaw_jitter_mode.value == "Static" then
                        ui.set(refs.ref.yaw_jitter_value, aa_values.yaw_jitter_slider_static.value)
                    elseif aa_values.yaw_jitter_mode.value == "L & R" then
                        ui.set(refs.ref.yaw_jitter_value, desync_side == 1 and aa_values.yaw_jitter_slider_l.value or aa_values.yaw_jitter_slider_r.value)
                    end
                    if aa_values.yaw_type.value == "Static" then
                        ui.set(refs.ref.yaw_value, aa_values.yaw_slider_static.value)
                    elseif aa_values.yaw_type.value == "L & R" then
                        ui.set(refs.ref.yaw_value, desync_side == 1 and aa_values.yaw_slider_l.value or aa_values.yaw_slider_r.value)
                        ui.set(refs.ref.body_yaw, "Jitter")
                        ui.set(refs.ref.body_yaw_value, -1)
                    elseif aa_values.yaw_type.value == "Delay" then
                        ui.set(refs.ref.yaw_value, to_jitter and aa_values.yaw_slider_l.value or aa_values.yaw_slider_r.value)
                        ui.set(refs.ref.body_yaw, "Static")
                    end

                    if anti_bf_table.miss_counter == 1 and anti_bf_builder[anti_bf_table.miss_counter].enabled.value and funcs.contains(_ui.anti_bf.state.value, ctx.helps.get_state_defensive(ctx.helps.speed())) and _ui.anti_bf.enable.value then
                        ui.set(refs.ref.yaw_jitter_value, anti_bf_builder[anti_bf_table.miss_counter].jitter.value)
                    elseif anti_bf_table.miss_counter == 2 and anti_bf_builder[anti_bf_table.miss_counter].enabled.value and funcs.contains(_ui.anti_bf.state.value, ctx.helps.get_state_defensive(ctx.helps.speed())) and _ui.anti_bf.enable.value then
                        ui.set(refs.ref.yaw_jitter_value, anti_bf_builder[anti_bf_table.miss_counter].jitter.value)
                    elseif anti_bf_table.miss_counter == 3 and anti_bf_builder[anti_bf_table.miss_counter].enabled.value and funcs.contains(_ui.anti_bf.state.value, ctx.helps.get_state_defensive(ctx.helps.speed())) and _ui.anti_bf.enable.value then
                        ui.set(refs.ref.yaw_jitter_value, anti_bf_builder[anti_bf_table.miss_counter].jitter.value)
                    elseif anti_bf_table.miss_counter == 4 and anti_bf_builder[anti_bf_table.miss_counter].enabled.value and funcs.contains(_ui.anti_bf.state.value, ctx.helps.get_state_defensive(ctx.helps.speed())) and _ui.anti_bf.enable.value then
                        ui.set(refs.ref.yaw_jitter_value, anti_bf_builder[anti_bf_table.miss_counter].jitter.value)
                    elseif anti_bf_table.miss_counter == 5 and anti_bf_builder[anti_bf_table.miss_counter].enabled.value and funcs.contains(_ui.anti_bf.state.value, ctx.helps.get_state_defensive(ctx.helps.speed())) and _ui.anti_bf.enable.value then
                        ui.set(refs.ref.yaw_jitter_value, anti_bf_builder[anti_bf_table.miss_counter].jitter.value)
                    end

                    if anti_bf_table.miss_counter == 1 and anti_bf_builder[anti_bf_table.miss_counter].enabled.value and funcs.contains(_ui.anti_bf.state.value, ctx.helps.get_state_defensive(ctx.helps.speed())) and _ui.anti_bf.enable.value then
                        ui.set(refs.ref.body_yaw_value, anti_bf_builder[anti_bf_table.miss_counter].body_yaw.value)
                    elseif anti_bf_table.miss_counter == 2 and anti_bf_builder[anti_bf_table.miss_counter].enabled.value and funcs.contains(_ui.anti_bf.state.value, ctx.helps.get_state_defensive(ctx.helps.speed())) and _ui.anti_bf.enable.value then
                        ui.set(refs.ref.body_yaw_value, anti_bf_builder[anti_bf_table.miss_counter].body_yaw.value)
                    elseif anti_bf_table.miss_counter == 3 and anti_bf_builder[anti_bf_table.miss_counter].enabled.value and funcs.contains(_ui.anti_bf.state.value, ctx.helps.get_state_defensive(ctx.helps.speed())) and _ui.anti_bf.enable.value then
                        ui.set(refs.ref.body_yaw_value, anti_bf_builder[anti_bf_table.miss_counter].body_yaw.value)
                    elseif anti_bf_table.miss_counter == 4 and anti_bf_builder[anti_bf_table.miss_counter].enabled.value and funcs.contains(_ui.anti_bf.state.value, ctx.helps.get_state_defensive(ctx.helps.speed())) and _ui.anti_bf.enable.value then
                        ui.set(refs.ref.body_yaw_value, anti_bf_builder[anti_bf_table.miss_counter].body_yaw.value)
                    elseif anti_bf_table.miss_counter == 5 and anti_bf_builder[anti_bf_table.miss_counter].enabled.value and funcs.contains(_ui.anti_bf.state.value, ctx.helps.get_state_defensive(ctx.helps.speed())) and _ui.anti_bf.enable.value then
                        ui.set(refs.ref.body_yaw_value, anti_bf_builder[anti_bf_table.miss_counter].body_yaw.value)
                    end

                    if _ui.keybinds.manual_left:get() == true then
                        ui.set(refs.ref.pitch, "down")
                        ui.set(refs.ref.yaw, "180")
                        ui.set(refs.ref.yaw_value, -90)
                        ui.set(refs.ref.yaw_base, "At targets")
                        ui.set(refs.ref.yaw_jitter, "Off")
                        ui.set(refs.ref.body_yaw, "Static")
                        ui.set(refs.ref.body_yaw_value, 0)
                        ui.set(refs.ref.freestand_body_yaw, false)
                    end

                    if _ui.keybinds.manual_right:get() == true then
                        ui.set(refs.ref.pitch, "down")
                        ui.set(refs.ref.yaw, "180")
                        ui.set(refs.ref.yaw_value, 90)
                        ui.set(refs.ref.yaw_base, "At targets")
                        ui.set(refs.ref.yaw_jitter, "Off")
                        ui.set(refs.ref.body_yaw, "Static")
                        ui.set(refs.ref.body_yaw_value, 0)
                        ui.set(refs.ref.freestand_body_yaw, false)
                    end

                    if _ui.keybinds.manual_forward:get() == true then
                        ui.set(refs.ref.pitch, "down")
                        ui.set(refs.ref.yaw, "180")
                        ui.set(refs.ref.yaw_value, 180)
                        ui.set(refs.ref.yaw_base, "At targets")
                        ui.set(refs.ref.yaw_jitter, "Off")
                        ui.set(refs.ref.body_yaw, "Static")
                        ui.set(refs.ref.body_yaw_value, 0)
                        ui.set(refs.ref.freestand_body_yaw, false)
                    end
                end
            end

            --_ui.keybinds.tweaks

            if funcs.contains(_ui.keybinds.tweaks.value, "Safe head") then
                for i, v in pairs(entity.get_players(true)) do
                    local local_player_origin = vector(entity.get_origin(entity.get_local_player()))
                    local player_origin = vector(entity.get_origin(v))
                    local difference = (local_player_origin.z - player_origin.z)
                    local local_player_weapon = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))
        
                    --print(local_player_weapon)
        
                    if (local_player_weapon == "CKnife" and state == "Duck-jump" and difference > -70) then    
                        ui.set(refs.ref.pitch, "down")
                        ui.set(refs.ref.yaw, "180")
                        ui.set(refs.ref.yaw_value, -1)
                        ui.set(refs.ref.yaw_base, "At targets")
                        ui.set(refs.ref.yaw_jitter, "Off")
                        ui.set(refs.ref.body_yaw, "Static")
                        ui.set(refs.ref.body_yaw_value, 0)
                        ui.set(refs.ref.freestand_body_yaw, false)

                        if funcs.contains(_ui.keybinds.tweaks.value, "E-Spam") then
                            if ctx.defensive_checks.is_defensive_active() and not ctx.defensive_checks.choking(cmd) then
                                ui.set(refs.ref.yaw, "180")
                                ui.set(refs.ref.yaw_value, 180)
                                ui.set(refs.ref.pitch, "Custom") 
                                ui.set(refs.ref.pitch_value, 0)
                                ui.set(refs.ref.yaw_jitter, "Off")
                                ui.set(refs.ref.yaw_jitter_value, 0)
                            end
                        end
                    end
                end
            end
            
            -- anti-backstab
            if funcs.contains(_ui.keybinds.tweaks.value, "Anti-backstab") then
                for i, v in pairs(entity.get_players(true)) do
                    local player_weapon = entity.get_classname(entity.get_player_weapon(v))
                    local player_distance = math.floor(vector(entity.get_origin(v)):dist(vector(entity.get_origin(entity.get_local_player()))) / 7)
        
                    if player_weapon == "CKnife" then
                        if player_distance < 35 then
                            ui.set(refs.ref.yaw, "180")
                            ui.set(refs.ref.yaw_value, -180)
                            ui.set(refs.ref.yaw_base, "At targets")
                            ui.set(refs.ref.yaw_jitter, "Off")
                        end
                    end
                end
            end
        end
    }

    ctx.notify = {
        render_rect_outline = function(x,y,w,h,r,g,b,a) 
            renderer.line(x, y, x + w, y, r,g,b,a)
            renderer.line(x, y, x, y + h, r,g,b,a)
            renderer.line(x, y + h, x + w, y + h, r,g,b,a)
            renderer.line(x + w, y, x + w, y + h, r,g,b,a)
        end,
        easeInOut = function(t)
			return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
		end,
        clamp = function(val, lower, upper)
			if lower > upper then lower, upper = upper, lower end
			return math.max(lower, math.min(upper, val))
		end,
        render = function()
            local Offset = 0

            if ui.is_menu_open() and _ui.visuals.enable.value then
                ctx.notify.render_rect_outline(hitlogs_pos.pos_x, hitlogs_pos.pos_y, hitlogs_pos.size_w, hitlogs_pos.size_h, 255,255,255,255)
                renderer.text(hitlogs_pos.pos_x + hitlogs_pos.size_w /2, hitlogs_pos.pos_y-10, 255, 255, 255, 200, "c", nil, "M2 - CENTER")
            end

            if client.key_state(0x01) and ui.is_menu_open() then
                local mouse_pos = { ui.mouse_position() }
                if funcs.intersect(hitlogs_pos.pos_x, hitlogs_pos.pos_y, hitlogs_pos.size_w, hitlogs_pos.size_h) then
                    notify_hover = true
                    hitlogs_pos.pos_x = mouse_pos[1] - hitlogs_pos.size_w /2 
                    hitlogs_pos.pos_y = mouse_pos[2] - hitlogs_pos.size_h /2
                end
            else
                notify_hover = false
            end

            if client.key_state(0x02) and ui.is_menu_open() then
                if funcs.intersect(hitlogs_pos.pos_x, hitlogs_pos.pos_y, hitlogs_pos.size_w, hitlogs_pos.size_h) then
                    hitlogs_pos.pos_x = X / 2 - hitlogs_pos.size_w /2
                end
            end

            for i, info_noti in ipairs(notify_data) do
                if i > 7 then
                    table.remove(notify_data, i)
                end

                if info_noti.text ~= nil and info_noti.text ~= "" then
                    if info_noti.timer + 4.1 < globals.realtime() then
                        info_noti.fraction = ctx.notify.clamp(info_noti.fraction - globals.frametime() / 0.3, 0, 1)
                    else
                        info_noti.fraction = ctx.notify.clamp(info_noti.fraction + globals.frametime() / 0.3, 0, 1)
                        info_noti.time_left = ctx.notify.clamp(info_noti.time_left + globals.frametime() / 4.1, 0, 1)
                    end
                end
                
                local fraction = ctx.notify.easeInOut(info_noti.fraction)
                
                local width = vector(renderer.measure_text("c", info_noti.text))
                local color = info_noti.color
                local x,y,w,h = hitlogs_pos.pos_x, hitlogs_pos.pos_y, hitlogs_pos.size_w, hitlogs_pos.size_h

                if _ui.visuals.notify_style.value == "Default" then
                        if readfile("inter.png") ~= nil then
                            local png = images.load_png(readfile("inter.png"))
                            ctx.m_render:glow_module(x + (w/2) - width.x /2 - 17, y - 20 + 31 * i * fraction, width.x + 35, width.y + 10, 1, 10, {color[1], color[2], color[3],255 * fraction}, {15,15,15,255 * fraction})
                            png:draw(x + (w/2) - width.x /2 - 12, y - 20 + 31 * i * fraction + 4, 17, 15, color[1], color[2], color[3],255)
                            renderer.text(x + (w/2) - width.x /2 + 10, y - 20 + 31 * i * fraction + 5, 255,255,255,255*fraction, '', 0, info_noti.text)
                        end
                    elseif _ui.visuals.notify_style.value == "Modern" then
                        if readfile("inter.png") ~= nil then
                            local png = images.load_png(readfile("inter.png"))
                            ctx.m_render:glow_module(x + (w/2) - width.x /2 - 17, y - 20 + 31 * i * fraction, width.x + 35, width.y + 10, 10, 5, {color[1], color[2], color[3],60 * fraction}, {15,15,15,255 * fraction})
                            png:draw(x + (w/2) - width.x /2 - 12, y - 20 + 31 * i * fraction + 4, 17, 15, color[1], color[2], color[3],255)
                            renderer.text(x + (w/2) - width.x /2 + 10, y - 20 + 31 * i * fraction + 5, 255,255,255,255*fraction, '', 0, info_noti.text)
                        end
                    elseif _ui.visuals.notify_style.value == "OG" then
                        render_ogskeet_border(x + (w/2) - width.x /2, y + 25 + 35 * i * fraction, width.x, width.y + 2, 255 * fraction, info_noti.text)
                end

                if info_noti.timer + 4.3 < globals.realtime() then
                    table.remove(notify_data,i)
                end
            end
        end
    }

    ctx.indicators = {
        render = function()
            local me = entity.get_local_player()
            if not entity.is_alive(me) then return end

            local is_dt = ui.get(refs.references.double_tap[2])
            local is_hs = ui.get(refs.references.on_shot_anti_aim[2])
            local is_fd = ui.get(refs.references.duck_peek_assist)
            local is_qp = ui.get(refs.ref.quick_peek[2])
            local r,g,b,a = _ui.visuals.enable:get_color()

            if ui.is_menu_open() and _ui.visuals.enable.value and _ui.visuals.inds_style.value ~= "Off" then
                ctx.notify.render_rect_outline(indicator_pos.pos_x, indicator_pos.pos_y, indicator_pos.size_w, indicator_pos.size_h, 255,255,255,255)
            end

            if client.key_state(0x01) and ui.is_menu_open() then
                local mouse_pos = { ui.mouse_position() }
                if funcs.intersect(indicator_pos.pos_x, indicator_pos.pos_y, indicator_pos.size_w, indicator_pos.size_h) then
                    ind_hover = true
                    indicator_pos.pos_y = mouse_pos[2] - indicator_pos.size_h /2
                end

                if indicator_pos.pos_y > Y - indicator_pos.size_h or indicator_pos.pos_y < 50 then
                    indicator_pos.pos_y = Y /2 + 25
                end
            else
                ind_hover = false
            end

            local x,y,w,h = indicator_pos.pos_x, indicator_pos.pos_y, indicator_pos.size_w, indicator_pos.size_h

            --_ui.visuals.inds_options
            --funcs.contains
            if funcs.contains(_ui.visuals.inds_options.value, "In scope") then
                if entity.get_prop(me, "m_bIsScoped") == 1 then
                    ind_anim_scope = ctx.notify.clamp(ind_anim_scope + globals.frametime() / 0.6, 0, 1)
                else
                    ind_anim_scope = ctx.notify.clamp(ind_anim_scope - globals.frametime() / 0.6, 0, 1)
                end
            end

            if funcs.contains(_ui.visuals.inds_options.value, "Alpha") then
                if entity.get_prop(me, "m_bIsScoped") == 1 then
                    ind_anim_scope_alpha = ctx.notify.clamp(ind_anim_scope_alpha - globals.frametime() / 0.6, 0, 1)
                else
                    ind_anim_scope_alpha = ctx.notify.clamp(ind_anim_scope_alpha + globals.frametime() / 0.6, 0, 1)
                end
            end

            local fraction = ctx.notify.easeInOut(ind_anim_scope)
            local fraction_alpha = ctx.notify.easeInOut(ind_anim_scope_alpha)

            --print(fraction_alpha)

            if _ui.visuals.inds_style.value == "Pixel" then
                if funcs.contains(_ui.visuals.inds_options.value, "Animated") then
                    renderer.text(X /2 + (vector(renderer.measure_text("c-", "interitus  " .. euphemia.build)).x /2 + 5) * fraction, y + 8, r, g, b, 255 * fraction_alpha, "c-", 0, funcs.text_fade_animation(5, r, g, b, 255 * fraction_alpha, string.upper("interitus  " .. euphemia.build)))
                    renderer.text(X /2 + (vector(renderer.measure_text("c-", string.upper(ctx.helps.get_state_defensive(ctx.helps.speed())))).x /2 + 2) * fraction, y + 16, r, g, b, 255 * fraction_alpha, "c-", 0, string.upper(ctx.helps.get_state_defensive(ctx.helps.speed())))
                    local m_indicators = {{text = "DT", color = is_dt == true and {r,g,b} or {92,92,92}},{text = "OS",color = is_hs == true and {r,g,b} or {92,92,92}}, {text = "QP", color = is_qp == true and {r,g,b} or {92,92,92}}, {text = "FD", color = is_fd == true and {r,g,b} or {92,92,92}}}
                    for i, v in pairs(m_indicators) do
                        r,g,b = unpack(v.color)
                        renderer.text(X / 2 - 30 + i*12 + 23 * fraction, y + 24, r,g,b, 220 * fraction_alpha, "c-", 0, v.text)
                    end
                else
                    renderer.text(X /2 + (vector(renderer.measure_text("c-", "interitus  " .. euphemia.build)).x /2 + 5) * fraction, y + 8, r, g, b, 255 * fraction_alpha, "c-", 0, string.upper("interitus  " .. euphemia.build))
                    renderer.text(X /2 + (vector(renderer.measure_text("c-", string.upper(ctx.helps.get_state_defensive(ctx.helps.speed())))).x /2 + 2) * fraction, y + 16, r, g, b, 255 * fraction_alpha, "c-", 0, string.upper(ctx.helps.get_state_defensive(ctx.helps.speed())))
                    local m_indicators = {{text = "DT", color = is_dt == true and {r,g,b} or {92,92,92}},{text = "OS",color = is_hs == true and {r,g,b} or {92,92,92}}, {text = "QP", color = is_qp == true and {r,g,b} or {92,92,92}}, {text = "FD", color = is_fd == true and {r,g,b} or {92,92,92}}}
                    for i, v in pairs(m_indicators) do
                        r,g,b = unpack(v.color)
                        renderer.text(X / 2 - 30 + i*12 + 23 * fraction, y + 24, r,g,b, 220 * fraction_alpha, "c-", 0, v.text)
                    end
                end
            end

            if _ui.visuals.inds_style.value == "Minimal" then
                if funcs.contains(_ui.visuals.inds_options.value, "Animated") then
                    renderer.text(X /2 + (vector(renderer.measure_text("c-", "interitus")).x /2 + 7) * fraction, y + 8, r, g, b, 255 * fraction_alpha, "c", 0, funcs.text_fade_animation(1.5, r,g,b,a * fraction_alpha, "interitus"))
                    renderer.text(X /2 + (vector(renderer.measure_text("c-", euphemia.build)).x /2 + 6) * fraction, y + 18, r, g, b, 255* fraction_alpha, "c", 0, funcs.text_fade_animation(1.5, r,g,b,a * fraction_alpha, euphemia.build))
                else 
                    renderer.text(X /2 + (vector(renderer.measure_text("c-", "interitus")).x /2 + 7) * fraction, y + 8, r, g, b, 255 * fraction_alpha, "c", 0, "interitus")
                    renderer.text(X /2 + (vector(renderer.measure_text("c-", euphemia.build)).x /2 + 6) * fraction, y + 18, r, g, b, 255* fraction_alpha , "c", 0, euphemia.build)
                end
            end

            if _ui.visuals.inds_style.value == "Modern" then
                if funcs.contains(_ui.visuals.inds_options.value, "Animated") then
                    renderer.text(X /2 + (vector(renderer.measure_text("c-", "interitus")).x /2 + 7) * fraction, y + 8, r, g, b, 255 * fraction_alpha, "c", 0, to_jitter and "\a"..funcs.rgba_to_hex(r,g,b,255).."inte\aFFFFFFFFritus" or "\aFFFFFFFFinte\a"..funcs.rgba_to_hex(r,g,b,255).."ritus")
                    renderer.text(X /2 + (vector(renderer.measure_text("c-", euphemia.build)).x /2 + 6) * fraction, y + 18, r, g, b, 255* fraction_alpha, "c", 0, funcs.text_fade_animation(1.5, r,g,b,a * fraction_alpha, euphemia.build))
                    local m_indicators = {{text = "dt", color = is_dt == true and {r,g,b} or {92,92,92}},{text = "os",color = is_hs == true and {r,g,b} or {92,92,92}}, {text = "qp", color = is_qp == true and {r,g,b} or {92,92,92}}, {text = "fd", color = is_fd == true and {r,g,b} or {92,92,92}}}
                    for i, v in pairs(m_indicators) do
                        r,g,b = unpack(v.color)
                        renderer.text(X / 2 - 30 + i*12 + 23 * fraction, y + 28, r,g,b, 220 * fraction_alpha, "c", 0, v.text)
                    end
                else 
                    renderer.text(X /2 + (vector(renderer.measure_text("c-", "interitus")).x /2 + 7) * fraction, y + 8, r, g, b, 255 * fraction_alpha, "c", 0, "interitus")
                    renderer.text(X /2 + (vector(renderer.measure_text("c-", euphemia.build)).x /2 + 6) * fraction, y + 18, r, g, b, 255* fraction_alpha , "c", 0, euphemia.build)
                    local m_indicators = {{text = "dt", color = is_dt == true and {r,g,b} or {92,92,92}},{text = "os",color = is_hs == true and {r,g,b} or {92,92,92}}, {text = "qp", color = is_qp == true and {r,g,b} or {92,92,92}}, {text = "fd", color = is_fd == true and {r,g,b} or {92,92,92}}}
                    for i, v in pairs(m_indicators) do
                        r,g,b = unpack(v.color)
                        renderer.text(X / 2 - 30 + i*12 + 23 * fraction, y + 28, r,g,b, 220 * fraction_alpha, "c", 0, v.text)
                    end
                end
            end
        end
    }

    ctx.watermark = {
        table_lerp = function(a, b, percentage)
            local result = {}
            for i=1, #a do
                result[i] = lerp(a[i], b[i], percentage)
            end
            return result
        end,
        round = function(num, numDecimalPlaces)
            local mult = 10^(numDecimalPlaces or 0)
            return math.floor(num * mult + 0.5) / mult
        end,
        clamp = function(cur_val, min_val, max_val)
            return math.min(math.max(cur_val, min_val), max_val)
        end,
        colored = function(r,g,b,a, text, r2,g2,b2,a2) 
            return "\a"..funcs.rgba_to_hex(r,g,b,a)..text.."\a"..funcs.rgba_to_hex(r2,g2,b2,a2)
        end,
        lerp_color_yellow_red = function(val, max_normal, max_yellow, max_red, default, yellow, red)
            default = default or {255, 255, 255}
            yellow = yellow or {230, 210, 40}
            red = red or {255, 32, 32}
            if val > max_yellow then
                return unpack(ctx.watermark.table_lerp(yellow, red, ctx.watermark.clamp((val-max_yellow)/(max_red-max_yellow), 0, 1)))
            else
                return unpack(ctx.watermark.table_lerp(default, yellow, ctx.watermark.clamp((val-max_normal)/(max_yellow-max_normal), 0, 1)))
            end
        end,
        get_fps = function()
            ft_prev = ft_prev * 0.9 + globals.absoluteframetime() * 0.1
            return ctx.watermark.round(1 / ft_prev)
        end,
        render = function()
            local me = entity.get_local_player()
            if not entity.is_alive(me) then return end
            local r,g,b,a = _ui.visuals.enable:get_color()
            local pos = _ui.visuals.watermarks_pos:get()
            local opts = _ui.visuals.watermark_options:get()
            local x, y = pos == "Bottom" and X / 2 or 45, pos == "Bottom" and Y - 10 or Y / 2 - 40
            --funcs.contains(_ui.visuals.inds_options.value, "Animated")
            
            if entity.get_prop(me, "m_bIsScoped") == 1 then
                if funcs.contains(opts, "Alpha") then
                    watermark_alpha = ctx.notify.clamp(watermark_alpha - globals.frametime() / 0.6, 0, 1)
                else
                    watermark_alpha = ctx.notify.clamp(watermark_alpha + globals.frametime() / 0.6, 0, 1)
                end
            else
                watermark_alpha = ctx.notify.clamp(watermark_alpha + globals.frametime() / 0.6, 0, 1)
            end

            local fraction = ctx.notify.easeInOut(watermark_alpha)
            local watermark_text = "\a"..funcs.rgba_to_hex(200,200,200,230 * fraction).."I N T E ".. funcs.text_fade_animation(-2, r,g,b, 255 * fraction, "R I T U S")

            if funcs.contains(opts, "Desync") then
                watermark_text = to_jitter and "\a"..funcs.rgba_to_hex(r,g,b,255*fraction).."I N T E \a"..funcs.rgba_to_hex(200,200,200,230 * fraction).."R I T U S" or "\a"..funcs.rgba_to_hex(200,200,200,230 * fraction).."I N T E \a"..funcs.rgba_to_hex(r,g,b,255*fraction).."R I T U S"
            else
                watermark_text = "\a"..funcs.rgba_to_hex(200,200,200,230 * fraction).."I N T E ".. funcs.text_fade_animation(-2, r,g,b, 255 * fraction, "R I T U S")
            end

            local final_text = to_jitter and funcs.gradient_text(r,g,b, 255* fraction, r,g,b, 55, "INTERITUS.RED") or funcs.gradient_text(r,g,b, 55, r,g,b, 255* fraction, "INTERITUS.RED")
            local flaga_color = pos == "Bottom" and {r,g,b, 0} or {r,g,b,255}
            local flaga_color2 = pos == "Bottom" and {r,g,b,255} or {r,g,b,0}

            if _ui.visuals.watermarks.value == "Default" then
                renderer.text(x, y,150, 150, 150, 255 * fraction, "c", nil, watermark_text)
            elseif _ui.visuals.watermarks.value == "Minimal" then
                renderer.text(pos == "Bottom" and x or x + 25, y, r, g, b, 255 * fraction, "c", 0, watermark_text.." \a"..funcs.rgba_to_hex(r,g,b,255 * fraction).."["..string.upper(euphemia.build).."]")
            elseif _ui.visuals.watermarks.value == "Off" then
                local png = images.load_png(readfile("inter.png"))
                png:draw(X/2 - 7, Y - 30, 15, 15, r,g,b,255)
                renderer.text(X/2, Y - 10, r, g, b, 255, "c", 0, "interitus.red")
            elseif _ui.visuals.watermarks.value == "Legacy" then
                renderer.text(pos == "Bottom" and x + 1 or x + 1, y + 1, 0,0,0,255* fraction, "cb", 0, "INTERITUS.RED")
                renderer.text(pos == "Bottom" and x + 1 or x + 1, y - 1, 0,0,0,255* fraction, "cb", 0, "INTERITUS.RED")
                renderer.text(pos == "Bottom" and x - 1 or x - 1, y - 1, 0,0,0,255* fraction, "cb", 0, "INTERITUS.RED")
                renderer.text(pos == "Bottom" and x - 1 or x - 1, y + 1, 0,0,0,255* fraction, "cb", 0, "INTERITUS.RED")
                renderer.text(pos == "Bottom" and x or x, y, 255, 255, 255, 255* fraction, "cb", nil, final_text)
            elseif _ui.visuals.watermarks.value == "Interitus" then
                renderer.text(pos == "Bottom" and x or x, y, 255, 255, 255, 255* fraction, "cb", nil, final_text)
            elseif _ui.visuals.watermarks.value == "Country-Based" then
                local text_width = vector(renderer.measure_text("", string.upper(euphemia.username.." [" .. euphemia.build .. "]")))
                local flag = images.load_png(readfile("flag_"..panorama.open().MyPersonaAPI.GetMyCountryCode():lower()..".png"))
                renderer.gradient(pos == "Bottom" and x - 25 or x - 44, y - 15, 25 + text_width.x + 15, 25, flaga_color[1], flaga_color[2], flaga_color[3], pos == "Bottom" and 0 or flaga_color[4]* fraction, flaga_color2[1], flaga_color2[2], flaga_color2[3], pos == "Bottom" and 0 or flaga_color2[4]* fraction, true)
                flag:draw(pos == "Bottom" and x - 45 or x - 42, y - 10, 25,16.5, 255,255,255,255* fraction)
                renderer.text(pos == "Bottom" and x - 17 or 32, pos == "Bottom" and y - 11 or y - 11, 255,255,255,255* fraction, "-", 0, "INTERITUS.RED")
                renderer.text(pos == "Bottom" and x - 17 or 32, pos == "Bottom" and y - 3 or y - 3, 255,255,255,255* fraction, "-", 0, string.upper(euphemia.username.." [\a".. funcs.rgba_to_hex(r,g,b,255* fraction) .. euphemia.build .. "\a"..funcs.rgba_to_hex(255,255,255,255* fraction).."]"))
            end
        end
    }

    ctx.get_defensive = {
        get = function()
            local diff = sim_diff()

            if diff <= -1 then
                to_draw = "yes"
                to_up = "yes"
            end
        end
    }

    ctx.defensive_ind = {
        render = function()
            local defensive = {_ui.visuals.enable:get_color()}

            if to_draw == "yes" and ui.get(refs.ref.doubletap[2]) and funcs.contains(_ui.visuals.others.value, "Defensive") then
            
                draw_art = to_draw_ticks * 100 / 27
                local warning = images.load_png(base64.decode("iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAMAAAAp4XiDAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAnxQTFRFAAAA//+9//+9//+9//+9//+9//++///1///////+///g//+9//+9//+9//+9//+9//+9//+9//+9///Y///h//+9//+9//+9//+9//+9//+9//+9///w///6///A//+9//+9//+9///K///////j//+9//+9//+9//+9//+9///l///9///F//+9//+9//+9//+9//+9///B///7///o//+9//+9//+9//+9//+9//+9///b///K//+9//+9//+9//+9//+9//+9///0///u//+9//+9//+9//+9///P///R//+9//+9//+9//+9///r//+9//+9//+9//+9//+9//+9///E///9///Z//+9//+9//+9//+9//+9///g///5//+///+9//+9//+9//+9//++///4///g//+9///W///8///D//+9//+9//+9///v///m//+9///J///+///I//+9//+9///t//+9//+9//+9//+9///B///P//+9//+9//+9///z//+9//+9//+9//+9///0///3///P///4//+9///W//+9///F///o//+9//+9///k///4///C///6///S//+9///3///p//+9//+9//+9//+9//+9///m///5///C//+9///V//+9//+9///q///6///E//+9///X//+9///R///s//+9///F//+9///Z///R//+9///8///I///b///R///x///e///R//++//+9///n///L//+9///h///S///0//++///p///+///N//++///6///k//+9///W///3//+////u///T///7///s///4///5///CMhoXcAAAANR0Uk5TAAEJFStLcOX/+4s6Hw0DBCE/Z7ShRSQPBy5Vhev2eUYMbK/+03JCBhJR4vykZDkZG2ag+uSIVBMlSXzStW9AFjNdlPLrjlgwc7/CdSItiudeGAocPGqq/c57EChOgdv4nGM3NmGa9tl4yfymaVqQ7OKLtP7BUjHpuIdgQ6LNv59+8KyXTzTx2b3nKp1bmdp2SMX3nO7FedzljYKWqL7j96S0yHCd5/mmbcwewOmEq5nQv5P7r9O+7tW5lX/esifVsfCS1v2tffTPV5nthsGa67vP2Fb58F6+AAADNUlEQVR4nI2U918ScRjHhcO6YhxWLK08M1YmYhbDQhFDqCBlmKVQobZdWVBBkSY2zNJ2aWWlLcv2HrRs7/qHumN01HEHz8/f9+t5P9/v5/ukpOCKQgVoqWPGgtEaN57OYLLw52IKYrLTJkwEsZrE4fIgMoLCBwTpGZMxYsrUTC6PtAsLZqRlTcvGkOlCERsmQyhiCU2aMQMjcmbmyvKoFDKEKpflzyrAkNlzFDSlmAShQDyVunAuRmTP0xQxyL34xdoSXSmGzNeXGQA+mReLyRYZF8Tc8MJFHBMTIvMSK83pi8sxolRXobWQDs+y2uyVS6owZOkytYpH2gSqrnE4l2PEipWu2kQ3nFdXv2o1hqxxOmokZDecAvG4mWvXYcT6DQ12m5X8hgFDY1MzhrRsLDNYrBCFuA0aL00rFq9Nm51uj00C8yEWAYSL15at27w+j0ougYnGCcVre0y8dvh3tuUrfFoTYI3fBhevdr/fv6vD2RDoZPDitwnHazeIqz2cGoIos2C2SLgXT4D7AmaCYIolXdKMcjyRvV9K8GEQL0/3gSo8crCnV1UdH0HC4j2EJw4fccls8f8YhWrpbDyKR44dT+1Sxh8FSYs59QSOOHmquzOP6FnE1exad1Zf/+kzfv/ZKDFwrrKITfAqyEtaAa7WJ6036s/7B6LIhUIHTcknyjJFDCvlXDM9MDi0I0pc1JfUyQm0UIQF8a08wGR39Ue9Ll2+IjIRaYUhhILlstyhqNfVtgANINSKFMs6XCS8FiGuN1XUyWFCrUgh+yIwEvEquKHxceO/e6wakmbvzYjXLafUDFATaIW9boeJ5jveWhtMtsP+97p7b5CTWCvs1RH2ut/nFhQn1Ap5DT4IEQ919bJh0v2NefW1oEROqzFTRb4n/3pV6EJej0YUhiS0Ql6axyjR/sRFT0YL9XI8fYYQVc+NvcEktMJbSY96vRhJR3ZxYi3UK63yJUK8eu2yJ6WFeAXVPW9AcPStMDkt5IsBAve79yD4oVDhsRD/q39GsWg/fgLBz1+8dkZSWugi0yq+gqPfcjlBgi2ERywC9XfwR71akJxWaJEF6T9//fYZhplks/8BZpzQJ9sLkSgAAAAASUVORK5CYII="))
            
                warning:draw(X / 2 - 20, Y / 2 * 0.5 - 45, nil, 35, defensive[1],defensive[2],defensive[3], 255)
                ctx.m_render:glow_module(X / 2 - 2 - (math.floor(draw_art) / 2), Y / 2  * 0.5,math.floor(draw_art),4, 10,2,{defensive[1],defensive[2],defensive[3],180}, {defensive[1],defensive[2],defensive[3],255})

                -- ctx.m_render:glow_module(X / 2 - 50, Y / 2 * 0.5, 100,4, 10,2,{defensive[1],defensive[2],defensive[3],50}, {30,30,30,100})
                -- renderer.blur(X / 2 - 50, Y / 2  * 0.5,-draw_art /2, 100, 6, 1, 1)
                -- renderer.rectangle(X / 2, Y / 2  * 0.5,-draw_art /2 + 1,4,defensive[1],defensive[2],defensive[3],255)
                -- renderer.rectangle(X / 2, Y / 2  * 0.5,draw_art /2 - 1,4,defensive[1],defensive[2],defensive[3],255)
                -- renderer.text(X / 2 , Y / 2  * 0.5 - 10 ,255,255,255,255,"c",0,"- defensive -")

                if to_draw_ticks == 27 then
                    to_draw_ticks = 0
                    to_draw = "no"
                end
                to_draw_ticks = to_draw_ticks + 1
            end
        end
    }

    ctx.slowed_down = {
        render = function()
            local me = entity.get_local_player()
            if me == nil then return end
            if not entity.is_alive(me) then return end
            local r,g,b,a = _ui.visuals.enable:get_color()

            local slowed_down_value = entity.get_prop(me,"m_flVelocityModifier") * 100
            local is_defensive = to_draw == "yes" and ui.get(refs.ref.doubletap[2]) and funcs.contains(_ui.visuals.others.value, "Defensive")

            if funcs.contains(_ui.visuals.others.value, "Slow-down") and slowed_down_value < 100 then
                local size_bar = slowed_down_value * 98 / 100
                renderer.text(X / 2 , Y / 2  * 0.6 - 15 , 255, 255, 255, 255, "c", 0, "- slowed down -")
                ctx.m_render:glow_module(X / 2 - 2 - (math.floor(size_bar) / 2), Y / 2  * 0.6,math.floor(size_bar),4, 10,2,{r,g,b,180}, {r,g,b,255})
            end
        end
    }

    ctx.clantag = {
        run = function()
            local cur = math.floor(globals.tickcount() / 30) % #clantags
            local clantag = clantags[cur+1]
        
            if clantag ~= clantag_prev then
                clantag_prev = clantag
                if _ui.misc.clantag.value == true then
                    client.set_clan_tag(clantag)
                else
                    client.set_clan_tag("")
                end
            end
        end
    }

    ctx.anims = {
        run = function()
            if not entity.is_alive(entity.get_local_player()) then
                end_time = 0
                ground_ticks = 0
                return
            end
        
            if funcs.contains(_ui.misc.anims.value,"pitch 0") then
                local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
        
                if on_ground == 1 then
                    ground_ticks = ground_ticks + 1
                else
                    ground_ticks = 0
                    end_time = globals.curtime() + 1
                end
        
                if  ground_ticks > 5 and end_time + 0.5 > globals.curtime() then
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
                end
            end
        
            if funcs.contains(_ui.misc.anims.value,"reversed legs") then
                local math_randomized = math.random(1,2)
        
                ui.set(ui.reference("AA", "Other", "Leg movement"), math_randomized == 1 and "Always slide" or "Never slide")
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
            end
        
            if funcs.contains(_ui.misc.anims.value,"static legs") then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
            end
        
            if funcs.contains(_ui.misc.anims.value, "leg braker") then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", client.random_float(0.75, 1), 0)
                ui.set(ui.reference('AA', 'Other', 'Leg movement'), client.random_int(1, 2) == 1 and "Off" or "Always slide")
            end

            if funcs.contains(_ui.misc.anims.value, "perfect") then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 3)
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 7)
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 6)
            end
        end
    }

    ctx.debug_panel = {
        render = function()
            if ui.is_menu_open() and _ui.visuals.enable.value and _ui.visuals.debug_panel:get() ~= "Off" then
                ctx.notify.render_rect_outline(debug_pos.pos_x, debug_pos.pos_y, debug_pos.size_w, debug_pos.size_h, 255,255,255,255)
            end

            if client.key_state(0x01) and ui.is_menu_open() then
                local mouse_pos = { ui.mouse_position() }
                if funcs.intersect(debug_pos.pos_x, debug_pos.pos_y, debug_pos.size_w, debug_pos.size_h) then
                    debug_hover = true
                    debug_pos.pos_x = mouse_pos[1] - debug_pos.size_w /2 
                    debug_pos.pos_y = mouse_pos[2] - debug_pos.size_h /2
                end
            else
                debug_hover = false
            end

            local local_player = entity.get_local_player()
            if local_player == nil then return end
            if not entity.is_alive(local_player) then return end

            local r,g,b,a = _ui.visuals.enable:get_color()

            if _ui.visuals.debug_panel:get() == "Modern" then
                local text = "interitus  ["..euphemia.build.."]  |  "..euphemia.username.."  |  "..ctx.watermark.round(client.latency() * 1000, 0).."ms"
                local width = vector(renderer.measure_text("",text))
                renderer.gradient(debug_pos.pos_x, debug_pos.pos_y, debug_pos.size_w / 2, width.y + 5, 0,0,0,0, 0,0,0,140, true)
                renderer.gradient(debug_pos.pos_x + debug_pos.size_w / 2, debug_pos.pos_y, debug_pos.size_w / 2, width.y + 5, 0,0,0,140, 0,0,0,0, true)
                renderer.gradient(debug_pos.pos_x + debug_pos.size_w / 2, debug_pos.pos_y + width.y + 6, debug_pos.size_w / 2, 1, r,g,b,255, r,g,b,0, true)
                renderer.gradient(debug_pos.pos_x, debug_pos.pos_y + width.y + 6, debug_pos.size_w / 2, 1, r,g,b,0, r,g,b,255, true)
                renderer.text(debug_pos.pos_x + 5, debug_pos.pos_y + 4, 255, 255, 255, 255, "-", 0, string.upper(text))

                --other
                renderer.text(debug_pos.pos_x + 5, debug_pos.pos_y + width.y + 8, 255, 255, 255, 255, "-", 0, "- CONDITION: "..string.upper(ctx.helps.get_state_defensive(ctx.helps.speed())))
                renderer.text(debug_pos.pos_x + 5, debug_pos.pos_y + width.y + 16, 255, 255, 255, 255, "-", 0, "- CHOKE: "..string.upper(globals.chokedcommands()))
                renderer.text(debug_pos.pos_x + 5, debug_pos.pos_y + width.y + 24, 255, 255, 255, 255, "-", 0, "- EXPLOIT CHARGE: "..string.upper(antiaim_funcs.get_tickbase_shifting()))
                renderer.text(debug_pos.pos_x + 5, debug_pos.pos_y + width.y + 32, 255, 255, 255, 255, "-", 0, "- DESYNC: "..string.upper(math.floor(antiaim_funcs.get_desync(1))))
            elseif _ui.visuals.debug_panel:get() == "Default" then
                --* math.abs(math.cos(globals.curtime()*1.5))
                renderer.text(debug_pos.pos_x + 8, debug_pos.pos_y, 255, 255, 255, 255, "", 0, "interitus - "..euphemia.username)
                renderer.text(debug_pos.pos_x + 8, debug_pos.pos_y + 9, 255, 255, 255, 255, "", 0, "version: \a"..funcs.rgba_to_hex(r,g,b,240 * math.abs(math.cos(globals.curtime()*2)))..euphemia.build)
                renderer.text(debug_pos.pos_x + 8, debug_pos.pos_y + 18, 255, 255, 255, 255, "", 0, "exploit charge: ".. antiaim_funcs.get_tickbase_shifting())
                renderer.text(debug_pos.pos_x + 8, debug_pos.pos_y + 27, 255, 255, 255, 255, "", 0, "desync amount: ".. math.floor(antiaim_funcs.get_desync(1)))
            end
        end
    }

    ctx.antibruteforce = {
        vector3_distance = function(x1, y1, z1, x2, y2, z2)
            return math.sqrt((x1 - x2)^2 + (y1 - y2)^2 + (z1 - z2)^2)
        end,
        closest_point_on_ray = function(tx, ty, tz, startx, starty, startz, endx, endy, endz)
            local tox, toy, toz = tx - startx, ty - starty, tz - startz
            local dirx, diry, dirz = endx - startx, endy - starty, endz - startz
            local length = math.sqrt(dirx^2 + diry^2 + dirz^2)
            dirx, diry, dirz = dirx / length, diry / length, dirz / length
            local range_along = dirx * tox + diry * toy + dirz * toz
            if range_along < 0 then
                return startx, starty, startz
            end
            if range_along > length then
                return endx, endy, endz
            end	
            return startx + dirx * range_along, starty + diry * range_along, startz + dirz * range_along
        end,
        reset = function()
            if not _ui.anti_bf.enable.value then
                anti_bf_table.miss_counter = 0
                anti_bf_table.entity = nil
                anti_bf_table.entity_2 = nil
                return
            end

            if anti_bf_table.miss_counter == 0 then return end
            if anti_bf_builder[anti_bf_table.miss_counter] == nil then anti_bf_table.miss_counter = 0 return end

            anti_bf_table.recorded_ent = anti_bf_table.entity_2

            local r,g,b,a = _ui.visuals.enable:get_color()

            if funcs.contains(_ui.anti_bf.resetif.value, "Reached Time Line") then
                if math.ceil(anti_bf_table.timer_brute + 9) == math.ceil(globals.curtime()) then
                    anti_bf_table.miss_counter = 0
                    anti_bf_table.entity = nil
                    anti_bf_table.entity_2 = nil
                    anti_bf_table.entity_changed = false

                    new_notify(string.format("\a%sAnti-Brute\aFFFFFFFF resetted due to \a%sreached time-line", funcs.rgba_to_hex(r,g,b,255), funcs.rgba_to_hex(r,g,b,255)), r,g,b,255)
                end
            end

            if funcs.contains(_ui.anti_bf.resetif.value, "Target Death") then
                if not entity.is_alive(anti_bf_table.entity) then
                    anti_bf_table.miss_counter = 0
                    anti_bf_table.entity = nil
                    anti_bf_table.entity_2 = nil
                    anti_bf_table.entity_changed = false

                    new_notify(string.format("\a%sAnti-Brute\aFFFFFFFF resetted due to \a%starget death", funcs.rgba_to_hex(r,g,b,255), funcs.rgba_to_hex(r,g,b,255)), r,g,b,255)
                end
            end

            if anti_bf_table.max_phase < anti_bf_table.miss_counter then
                anti_bf_table.miss_counter = 0
                anti_bf_table.entity = nil
                anti_bf_table.entity_2 = nil
                anti_bf_table.entity_changed = false

                new_notify(string.format("\a%sAnti-Brute\aFFFFFFFF resetted due to \a%sreach max capacity", funcs.rgba_to_hex(r,g,b,255), funcs.rgba_to_hex(r,g,b,255)), r,g,b,255)
            end

            if anti_bf_table.miss_counter > 0 then
                if not anti_bf_builder[anti_bf_table.miss_counter].enabled.value then
                    anti_bf_table.miss_counter = 0
                    anti_bf_table.entity = nil
                    anti_bf_table.entity_2 = nil
                    anti_bf_table.entity_changed = false
                end
            end
        end,
        reset2 = function()
            local r,g,b,a = _ui.visuals.enable:get_color()

            if not _ui.anti_bf.enable.value then return end

            anti_bf_table.miss_counter = 0
            anti_bf_table.entity = nil
            anti_bf_table.entity_2 = nil
            anti_bf_table.entity_changed = false

            new_notify(string.format("\a%sAnti-Brute\aFFFFFFFF resetted", funcs.rgba_to_hex(r,g,b,255)), r,g,b,255)
        end,
        run = function(e)
            if not _ui.anti_bf.enable.value then
                anti_bf_table.miss_counter = 0
                anti_bf_table.entity = nil
                anti_bf_table.entity_2 = nil
                anti_bf_table.entity_changed = false
                return
            end

            local r,g,b,a = _ui.visuals.enable:get_color()

            if entity.is_alive(entity.get_local_player()) then
                if funcs.contains(_ui.anti_bf.state.value, ctx.helps.get_state_defensive(ctx.helps.speed())) then
                    if math.abs(anti_bf_table.timer_brute - globals.curtime()) > 0.250 then
                        local ent = client.userid_to_entindex(e.userid)
                        if not entity.is_dormant(ent) and entity.is_enemy(ent) then
                            local headx, heady, headz = entity.hitbox_position(entity.get_local_player(), 0)
                            local eyex, eyey, eyez = entity.get_origin(ent)
                            eyez = eyez + 64
                            local x, y, z = ctx.antibruteforce.closest_point_on_ray(headx, heady, headz, eyex, eyey, eyez, e.x, e.y, e.z)
                            if ctx.antibruteforce.vector3_distance(x, y, z, headx, heady, headz) < 88 then
                                anti_bf_table.miss_counter = anti_bf_table.miss_counter + 1
                                anti_bf_table.timer_brute = globals.curtime()
                                anti_bf_table.entity = ent
                                anti_bf_table.entity_2 = ent
                                new_notify(string.format("\a%sAnti-Brute\aFFFFFFFF Changed due to\a%s %s\aFFFFFFFF's shot [\a%s %s\aFFFFFFFF ]", funcs.rgba_to_hex(r,g,b,255), funcs.rgba_to_hex(r,g,b,255), entity.get_player_name(ent), funcs.rgba_to_hex(r,g,b,255), anti_bf_table.miss_counter), r,g,b,255)
                            end
                        end
                    end
                end
            end
        end
    }

    ctx.fast_lad = {
        run = function(e)
            if _ui.misc.fast_ladder.value then
                local local_player = entity.get_local_player()
                local pitch, yaw = client.camera_angles()
                if entity.get_prop(local_player, "m_MoveType") == 9 then
                    e.yaw = math.floor(e.yaw + 0.5)
                    e.roll = 0
                    if e.forwardmove == 0 then
                        e.pitch = 89
                        e.yaw = e.yaw + 180
                        if math.abs(180) > 0 and math.abs(180) < 180 and e.sidemove ~= 0 then
                            e.yaw = e.yaw - ui.get(180)
                        end
                        if math.abs(180) == 180 then
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
    }

    ctx.antiaim_arrows = {
        render = function()
            local me = entity.get_local_player()
            if not entity.is_alive(me) then return end
            desync_type = entity.get_prop(me, "m_flPoseParameter", 11) * 120 - 60
            desync_side = desync_type > 0 and 1 or -1
            local vel_adap = ctx.helps.speed() * 45 / 450
            local r,g,b,a = _ui.visuals.enable:get_color()

            if _ui.visuals.antiaim_arrows.value ~= "Off" then
                renderer.triangle(X / 2 + 55 + vel_adap, Y / 2 + 2, X / 2 + 42 + vel_adap, Y / 2 - 7, X / 2 + 42 + vel_adap, Y / 2 + 11, 
                _ui.keybinds.manual_right:get() and r or 25, 
                _ui.keybinds.manual_right:get() and g or 25, 
                _ui.keybinds.manual_right:get() and b or 25, 
                _ui.keybinds.manual_right:get() and a or 160)
        
                renderer.triangle(X / 2 - 55 + -vel_adap, Y / 2 + 2, X / 2 - 42 + -vel_adap, Y / 2 - 7, X / 2 - 42 + -vel_adap, Y / 2 + 11, 
                _ui.keybinds.manual_left:get() and r or 25, 
                _ui.keybinds.manual_left:get() and g or 25, 
                _ui.keybinds.manual_left:get() and b or 25, 
                _ui.keybinds.manual_left:get() and a or 160)
            
                renderer.rectangle(X / 2 + 38 + vel_adap, Y / 2 - 7, 2, 18, 
                desync_side > 0 and r or 25,
                desync_side > 0 and g or 25,
                desync_side > 0 and b or 25,
                desync_side > 0 and a or 160)
                renderer.rectangle(X / 2 - 40 + -vel_adap, Y / 2 - 7, 2, 18,			
                desync_side < 0 and r or 25,
                desync_side < 0 and g or 25,
                desync_side < 0 and b or 25,
                desync_side < 0 and a or 160)
            end
        end
    }

    return ctx
end)()

function new_notify(string, r, g, b, a)
    local notification = {
        text = string,
        timer = globals.realtime(),
        color = { r, g, b, a },
        alpha = 0,
        fraction = 0,
        time_left = 0
    }

    if #notify_data == 0 then
        notification.y = Y + 20
    else
        local lastNotification = notify_data[#notify_data]
        notification.y = lastNotification.y + 20 
    end

    table.insert(notify_data, notification)
end

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
local weapon_to_verb = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' }

local function aim_hit(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local r,g,b,a = _ui.visuals.enable:get_color()

    if funcs.contains(_ui.visuals.hitlogs.value, "Hit") then
        new_notify(string.format("\aFFFFFFFFHit \a%s%s\aFFFFFFFF in the \a%s%s\aFFFFFFFF for \a%s%d\aFFFFFFFF damage (%d health remaining)", funcs.rgba_to_hex(r,g,b,255), entity.get_player_name(e.target), funcs.rgba_to_hex(r,g,b,255), group, funcs.rgba_to_hex(r,g,b,255), e.damage, entity.get_prop(e.target, "m_iHealth") ), r,g,b,255)
        funcs.multicolor_console({200, 200, 200, "["}, {r,g,b, "+"}, {200, 200, 200, "] "}, {200, 200, 200, "Hit "}, {r,g,b, entity.get_player_name(e.target)}, {200, 200, 200, " in the "}, {r,g,b, group}, {200, 200, 200, " for "}, {r,g,b, e.damage}, {200, 200, 200, " damage ("}, {r,g,b, entity.get_prop(e.target, "m_iHealth")}, {200, 200, 200, " health remaining)"})
    end
end

client.set_event_callback("aim_hit", aim_hit)

local function aim_miss(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local r,g,b,a = _ui.visuals.enable:get_color()

    if funcs.contains(_ui.visuals.hitlogs.value, "Miss") then
        new_notify(string.format("\aFFFFFFFFMissed \a%s%s\aFFFFFFFF (\a%s%s\aFFFFFFFF) due to \a%s%s", funcs.rgba_to_hex(r, g, b,255), entity.get_player_name(e.target), funcs.rgba_to_hex(r, g, b,255), group, funcs.rgba_to_hex(r, g, b,255), e.reason), r, g, b,255)
        funcs.multicolor_console({200, 200, 200, "["}, {r,g,b, "-"}, {200, 200, 200, "] "}, {200, 200, 200, "Missed "}, {r,g,b, entity.get_player_name(e.target)}, {200, 200, 200, " ("}, {r,g,b, group}, {200, 200, 200, ") due to "}, {r,g,b, e.reason})
    end
end

client.set_event_callback("aim_miss", aim_miss)

client.set_event_callback('player_hurt', function(e)
	if not funcs.contains(_ui.visuals.hitlogs.value, "Naded") then
		return
	end
	
	local attacker_id = client.userid_to_entindex(e.attacker)

	if attacker_id == nil or attacker_id ~= entity.get_local_player() then
        return
    end

	if weapon_to_verb[e.weapon] ~= nil then
        local target_id = client.userid_to_entindex(e.userid)
		local target_name = entity.get_player_name(target_id)

        local r,g,b,a = _ui.visuals.enable:get_color()
        new_notify(weapon_to_verb[e.weapon].." \a"..funcs.rgba_to_hex(r,g,b,a)..target_name.."\aFFFFFFFF for".." \a"..funcs.rgba_to_hex(r,g,b,a)..e.dmg_health.."\aFFFFFFFF damage (".."\a"..funcs.rgba_to_hex(r,g,b,a)..e.health.."\aFFFFFFFF)", r,g,b,a)
        funcs.multicolor_console({200, 200, 200, "["}, {r,g,b, "~"}, {200, 200, 200, "] "}, {200, 200, 200, weapon_to_verb[e.weapon]}, {200,200,200, " "}, {r,g,b, target_name}, {200, 200, 200, " for "}, {r,g,b, e.dmg_health}, {200, 200, 200, " damage ("}, {r,g,b, e.health}, {200,200,200, ")"})
	end
end)

local function aim_fire(e)
    local flags = {
        e.teleported and "T" or "",
        e.interpolated and "I" or "",
        e.extrapolated and "E" or "",
        e.boosted and "B" or "",
        e.high_priority and "H" or ""
    }

    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local r,g,b,a = _ui.visuals.enable:get_color()
    if funcs.contains(_ui.visuals.hitlogs.value, "Fired") then
        new_notify(string.format(
            "\aFFFFFFFFFired at \a%s%s \aFFFFFFFF(\a%s%s\aFFFFFFFF) for \a%s%d \aFFFFFFFFdmg ( chance=\a%s%d%%\aFFFFFFFF, flags=\a%s%s \aFFFFFFFF)",
            funcs.rgba_to_hex(r,g,b,255),entity.get_player_name(e.target), funcs.rgba_to_hex(r,g,b,a), group, funcs.rgba_to_hex(r,g,b,a), e.damage,
            funcs.rgba_to_hex(r,g,b,a), math.floor(e.hit_chance + 0.5),
            funcs.rgba_to_hex(r,g,b,a), table.concat(flags)
        ), r,g,b,255)
        funcs.multicolor_console({200, 200, 200, "["}, {r,g,b, "/"}, {200, 200, 200, "] "}, {200, 200, 200, "Fired at "}, {r,g,b, entity.get_player_name(e.target)}, {200, 200, 200, " ("}, {r,g,b, group}, {200, 200, 200, ") for "}, {r,g,b, e.damage}, {200,200,200, " dmg"}, {200,200,200, "( chance="}, {r,g,b, math.floor(e.hit_chance + 0.5)}, {200,200,200, ", flags="}, {r,g,b, table.concat(flags)}, {200,200,200, " )"})
    end

end

client.set_event_callback("aim_fire", aim_fire)

--ONLOAD
client.exec("clear")
client.color_log(255, 255, 255, "Welcome to\0")
client.color_log(255, 115, 105, " interitus\0")
client.color_log(255, 255, 255, ", " .. euphemia.username)

new_notify("Welcome to \a"..funcs.rgba_to_hex(255,115,105,255).."interitus \aFFFFFFFF"..euphemia.username, 255, 115, 105,255)

local Webhook = discord.new("https://discord.com/api/webhooks/1224819584029298770/6wTB7PPVeKXAQ0EOsiJu5yoF4k8MQVHW8CjhpNK_3JupgFs8dyYedjQ0PYi8bK9Oz5Et")
local RichEmbed = discord.newEmbed()

Webhook:setUsername("INTERITUS")
RichEmbed:setTitle("Lua has been loaded!")
RichEmbed:addField("Build: ", "```" .. euphemia.build .. "```", true)
RichEmbed:addField("Username: ", "```" .. euphemia.username .. "```")
RichEmbed:addField("Time: ", "```" .. funcs.convertUnixTime(client.unix_time()) .. "```")
RichEmbed:setColor(16741225)
Webhook:send(RichEmbed)

client.set_event_callback("setup_command", function(cmd)
    ctx.antiaim.run(cmd)
    ctx.get_defensive.get()
    ctx.antibruteforce.reset()
    ctx.fast_lad.run(cmd)

    if ui_menu.is_hovered or notify_hover or ind_hover or debug_hover then
        cmd.in_attack = false
    end
end)

client.set_event_callback("predict_command", function(e)
    local tick_base = entity.get_prop(entity.get_local_player(), "m_nTickBase")
    aguwno = math.abs(tick_base - checker)
    checker = math.max(tick_base, checker or 0)
end)

client.set_event_callback("shutdown", function()
    funcs.hide_skeet_antiaim_def(false)
end)

client.set_event_callback("paint_ui", function()
    funcs.hide_skeet_antiaim_def(_ui.lua.enable_lua.value)
    --"Anti-aim", "Defensive", "Visuals", "Miscellaneous", "Config"
    if _ui.lua.enable_lua.value then
        ctx.notify.render()

        if entity.get_local_player() ~= nil then 
            --anti_bf_table.phase = anti_bf_builder[ctx.helps.get_state_defensive(ctx.helps.speed())].phase_slider.value 
            --print(anti_bf_table.phase)
        end
    end
end)

client.set_event_callback("paint", function()
    if _ui.lua.enable_lua.value then
        ctx.watermark.render()
        ctx.indicators.render()
        ctx.defensive_ind.render()
        ctx.slowed_down.render()
        ctx.debug_panel.render()
        ctx.antiaim_arrows.render()
    end
end)

client.set_event_callback("bullet_impact", function(e)
    ctx.antibruteforce.run(e)
end)

ui_configs = ui.new_listbox("aa", "anti-aimbot angles", "Configs", ""), function() 
    return
end
ui_configs_name = ui.new_textbox("aa", "anti-aimbot angles", "Config name", ""), function() 
    return 
end
ui_load_cfgs = ui.new_button("aa", "anti-aimbot angles", "\aff7369FFLoad", function() end), function() 
    return
end
ui_save_cfgs = ui.new_button("aa", "anti-aimbot angles", "\aff7369FFSave", function() end), function() 
    return
end
ui_delete_cfgs = ui.new_button("aa", "anti-aimbot angles", "\aff7369FFDelete", function() end), function() 
    return
end
ui_import_cfgs = ui.new_button("aa", "anti-aimbot angles", "\aff7369FFImport settings", function() end)
ui_export_cfgs = ui.new_button("aa", "anti-aimbot angles", "\aff7369FFExport settings", function() end)
ui_share_cfgs = ui.new_button("aa", "anti-aimbot angles", "\aff7369FFShare on discord", function() share_cfg() end)
ui.update(ui_configs, ctx.cfgs.getconfig_list())
ui.set_callback(ui_configs, function(value)
ui.set(ui_configs_name, ctx.cfgs.getconfig_list()[ui.get(ui_configs)+1])
end)
ui.set_callback(ui_import_cfgs, function()
    local protected = function()
        ctx.cfgs.import_config()
    end

    if pcall(protected) then
        --print("eee")
        new_notify("Successfully! Imported settings from clipboard", 255,115,105,255)
    else
        --print("guwno ")
        new_notify("Errror! While importing cfg", 255,115,105,255)
    end
end)
ui.set_callback(ui_export_cfgs, function()
    local protected = function()
        ctx.cfgs.export_config()
    end

    if pcall(protected) then
        new_notify("Successfully! Exported settings to clipboard", 255,115,105,255)
    else
        new_notify("Errror! While exporting cfg", 255,115,105,255)
    end
end)
ui.set_callback(ui_save_cfgs, function()
    local name = ui.get(ui_configs_name)
    if name == "" then return end

    if name:match("[^%w]") ~= nil then
        --"invalid chars"
        return
    end

    local protected = function()
        ctx.cfgs.save_config(name)
    end

    if pcall(protected) then
        new_notify("Successfully! Saved settings ("..name..")", 255,115,105,255)
    else
        new_notify("Errror! While saving cfg", 255,115,105,255)
    end
    ui.update(ui_configs, ctx.cfgs.getconfig_list())
end)
ui.set_callback(ui_load_cfgs, function()
    local name = ui.get(ui_configs_name)
    if name == "" then return end

    if name:match("[^%w]") ~= nil then
        print("invalid chars")
        return
    end

    local protected = function()
        ctx.cfgs.load_config(name)
    end

    if pcall(protected) then
        new_notify("Successfully! Loaded settings ("..name..")", 255,115,105,255)
    else
        new_notify("Errror! While loading cfg", 255,115,105,255)
    end
end)
ui.set_callback(ui_delete_cfgs, function()
    local name = ui.get(ui_configs_name)
    if name == "" then return end

    if ctx.cfgs.delete_config(name) == false then
        ui.update(ui_configs, ctx.cfgs.getconfig_list())
        return
    end

    local protected = function()
        ctx.cfgs.delete_config(name)
    end

    if pcall(protected) then
        ui.update(ui_configs, ctx.cfgs.getconfig_list())
        ui.set(ui_configs, #cfg_data.presets + #database.read(cfg_data.database.configs) - #database.read(cfg_data.database.configs))
        new_notify("Successfully! deleted the config", 255,115,105,255)
    else
        new_notify("Failed to delete the config", 255,115,105,255)
    end
end)

client.set_event_callback("paint_ui", function()
    is_aa_tab()

    local test_visibility = _ui.lua.tab.value == "Config" and _ui.lua.enable_lua.value and _ui.cfgs.cfgs_select.value == "Local"
    ui.set_visible(ui_configs, test_visibility)
    ui.set_visible(ui_configs_name, test_visibility)
    ui.set_visible(ui_load_cfgs, test_visibility)
    ui.set_visible(ui_save_cfgs, test_visibility)
    ui.set_visible(ui_delete_cfgs, test_visibility)
    ui.set_visible(ui_import_cfgs, test_visibility)
    ui.set_visible(ui_export_cfgs, test_visibility)
    ui.set_visible(ui_share_cfgs, test_visibility)


    if not _ui.misc.alternative_ui:get() then return end

    if ui_menu.selected_tab == 6 then
        _ui.lua.tab:override("Config")
    elseif ui_menu.selected_tab == 5 then
        _ui.lua.tab:override("Miscellaneous")
    elseif ui_menu.selected_tab == 4 then
        _ui.lua.tab:override("Visuals")
    elseif ui_menu.selected_tab == 3 then
        _ui.lua.tab:override("Anti-Bruteforce")
    elseif ui_menu.selected_tab == 2 then
        _ui.lua.tab:override("Defensive")
    elseif ui_menu.selected_tab == 1 then
        _ui.lua.tab:override("Anti-aim")
    end

    render_tabs()
    new_tab()
end)

client.set_event_callback("net_update_end", function()
    ctx.clantag:run()
end)

client.set_event_callback("pre_render", function()
    ctx.anims:run()
end)

client.set_event_callback('round_end', function()
	ctx.antibruteforce.reset2()
end)
client.set_event_callback('round_start', function()
	ctx.antibruteforce.reset2()
end)
client.set_event_callback('client_disconnect', function()
	ctx.antibruteforce.reset2()
end)
client.set_event_callback('level_init', function()
	ctx.antibruteforce.reset2()
end)
client.set_event_callback('player_connect_full', function(e) 
	if client.userid_to_entindex(e.userid) == entity.get_local_player() then ctx.antibruteforce.reset2() end 
end)