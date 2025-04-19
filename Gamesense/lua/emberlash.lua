local ffi = require('ffi')
local pui = require('gamesense/pui')
local base64 = require('gamesense/base64')
local clipboard = require('gamesense/clipboard')
local c_entity = require ('gamesense/entity')
local http = require ('gamesense/http')
local vector = require "vector"
local steamworks = require('gamesense/steamworks')
local surface = require 'gamesense/surface'

local a = function (...) return ... end

local surface_create_font, surface_get_text_size, surface_draw_text = surface.create_font, surface.get_text_size, surface.draw_text
local verdana = surface_create_font('Verdana', 12, 400, {})

client.exec("Clear")
local b_2, b_1 = {}, {}

local A_1 = {
    A_2 = panorama.open("CSGOHud").MyPersonaAPI.GetName(),
    A_3 = "DEBUG", -- build
    A_4 = "Emberlash"-- Lua
}


local b_3 = {}

b_3.b_4 = function (t, r, k) local result = {} for i, v in ipairs(t) do n = k and v[k] or i result[n] = r == nil and i or v[r] end return result end
b_3.b_5 = function (t, j)  for i = 1, #t do if t[i] == j then return i end end  end
b_3.b_6 = function (t)  local res = {} for i = 1, table.maxn(t) do if t[i] ~= nil then res[#res+1] = t[i] end end return res  end



local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
local gram_update = function(tab, value, forced) local new_tab = tab; if forced or new_tab[#new_tab] ~= value then table.insert(new_tab, value); table.remove(new_tab, 1); end; tab = new_tab; end
local get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end

local function get_velocity(player)
    local x,y,z = entity.get_prop(player, "m_vecVelocity")
    if x == nil then return end
    return math.sqrt(x*x + y*y + z*z)
end

-- @region FFI start
local angle3d_struct = ffi.typeof("struct { float pitch; float yaw; float roll; }")
local vec_struct = ffi.typeof("struct { float x; float y; float z; }")

local cUserCmd =
    ffi.typeof(
    [[
    struct
    {
        uintptr_t vfptr;
        int command_number;
        int tick_count;
        $ viewangles;
        $ aimdirection;
        float forwardmove;
        float sidemove;
        float upmove;
        int buttons;
        uint8_t impulse;
        int weaponselect;
        int weaponsubtype;
        int random_seed;
        short mousedx;
        short mousedy;
        bool hasbeenpredicted;
        $ headangles;
        $ headoffset;
        bool send_packet; 
    }
    ]],
    angle3d_struct,
    vec_struct,
    angle3d_struct,
    vec_struct
)

local client_sig = client.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85") or error("client.dll!:input not found.")
local get_cUserCmd = ffi.typeof("$* (__thiscall*)(uintptr_t ecx, int nSlot, int sequence_number)", cUserCmd)
local input_vtbl = ffi.typeof([[struct{uintptr_t padding[8];$ GetUserCmd;}]],get_cUserCmd)
local input = ffi.typeof([[struct{$* vfptr;}*]], input_vtbl)
local get_input = ffi.cast(input,ffi.cast("uintptr_t**",tonumber(ffi.cast("uintptr_t", client_sig)) + 1)[0])
--#endergion

local s_2 = {
    s_1 = {
        anti_aim = {ui.reference("AA", "Anti-aimbot angles", "Enabled")},
        pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")},
        yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
        yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw Base"),
        yawjitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
        bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
        fs_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
        freeStand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
        edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
        slow = { ui.reference("AA", "Other", "Slow motion") },
        onshotaa = {ui.reference("AA","Other", "On shot anti-aim")},
        fakelaglimit = {ui.reference("AA","Fake lag", "Limit")},
        fakelagvariance = {ui.reference("AA","Fake lag", "Variance")},
        fakelagamount = {ui.reference("AA","Fake lag", "Amount")},
        fakelagenabled = {ui.reference("AA","Fake lag", "Enabled")},
        legmovement = {ui.reference("AA","Other", "Leg movement")},
        fakepeek = {ui.reference("AA","Other", "Fake peek")},
    },
    s_0 = {
        qp = {ui.reference('RAGE', 'Other', 'Quick peek assist')},
        weapon_type = ui.reference('Rage', 'Weapon type', 'Weapon type'),
        rage_cb = { ui.reference("RAGE", "Aimbot", "Enabled") },
        fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
        dt = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
        scope = ui.reference('misc', 'miscellaneous', 'override zoom fov'),
        dmg = { ui.reference('RAGE', "Aimbot", 'Minimum damage override')},
        hit_chance = pui.reference("RAGE", "Aimbot", "Minimum hit chance"),
    }
}

--#region for Tabs // AA



local antiaim = {
    states = {
        {"global", "\vGlobal\r", "\vG\r"},
        {"stand", "\vStand\r", "\vS\r"},
        {"walk", "\vWalking\r", "\vW\r"}, 
        {"run", "\vRunning\r", "\vR\r"},
        {"air", "\vAerobic\r", "\vA\r"}, 
        {"airduck", "\vAerobic+\r", "\vA+C\r"},
        {"crouch", "\vCrouch\r", "\vC\r"},
        {"duckmoving", "\vCrouchMove\r", "\vD+M\r"},
        {"fakelag", "\vFakelag\r", "\vFL\r"}, 
    },
}

local enums = {
    states = b_3.b_4(antiaim.states, nil, 1),
    name_states = b_3.b_4(antiaim.states, 2),
    short_states = b_3.b_4(antiaim.states, 3),
}

--#region :: Traverse

local function traverse_table(tbl, prefix)
    prefix = prefix or ""
    local stack = {{tbl, prefix}}

    while #stack > 0 do
        local current = table.remove(stack)
        local current_tbl = current[1]
        local current_prefix = current[2]

        for key, value in pairs(current_tbl) do
            local full_key = current_prefix .. key
            if type(value) == "table" then
                table.insert(stack, {value, full_key .. "."})
            else
                ui.set_visible(value, false)
            end
        end
    end
end

local function traverse_table_on(tbl, prefix)
    prefix = prefix or ""
    local stack = {{tbl, prefix}}

    while #stack > 0 do
        local current = table.remove(stack)
        local current_tbl = current[1]
        local current_prefix = current[2]

        for key, value in pairs(current_tbl) do
            local full_key = current_prefix .. key
            if type(value) == "table" then
                table.insert(stack, {value, full_key .. "."})
            else
                ui.set_visible(value, true)
            end
        end
    end
end

--#endregion Traverse


client.set_event_callback("paint_ui", function()
    traverse_table(s_2.s_1)
end)

client.set_event_callback("shutdown", function()
    traverse_table_on(s_2.s_1)
    cvar.cl_interp:set_float(0.015625)
    cvar.con_filter_enable:set_int(0)
    cvar.con_filter_text:set_string("")
    client.exec("con_filter_enable 0")
end)


--#region :: Menu elements

lerp = function(a,b,p) 
    return a + (b - a) * globals.frametime() * p
end

local breathe = function(offset, multiplier)
    local m_speed = globals.realtime() * (multiplier or 1.0);
    local m_factor = m_speed % math.pi;
  
    local m_sin = math.sin(m_factor + (offset or 0));
    local m_abs = math.abs(m_sin);
  
    return m_abs
end

calculateGradient = function(color1, color2, color3, color4, text, speed)
    local r1, g1, b1, a1 = color1[1], color1[2], color1[3], color1[4]
    local r2, g2, b2, a2 = color2[1], color2[2], color2[3], color2[4]
    local r3, g3, b3, a3 = color3[1], color3[2], color3[3], color3[4]
    local r4, g4, b4, a4 = color4[1], color4[2], color4[3], color4[4]
    
    local highlight_fraction = (globals.realtime() / 4 % 1.2 * speed) - 1.2
    local output = ''
    
    for idx = 1, #text do
        local character = text:sub(idx, idx)
        local character_fraction = idx / #text
        local r, g, b, a
        
        if character_fraction <= 0.33 then
            local fraction = character_fraction / 0.33
            r = r1 + (r2 - r1) * fraction
            g = g1 + (g2 - g1) * fraction
            b = b1 + (b2 - b1) * fraction
            a = a1 + (a2 - a1) * fraction
        elseif character_fraction <= 0.66 then
            local fraction = (character_fraction - 0.33) / 0.33
            r = r2 + (r3 - r2) * fraction
            g = g2 + (g3 - g2) * fraction
            b = b2 + (b3 - b2) * fraction
            a = a2 + (a3 - a2) * fraction
        else
            local fraction = (character_fraction - 0.66) / 0.34
            r = r3 + (r4 - r3) * fraction
            g = g3 + (g4 - g3) * fraction
            b = b3 + (b4 - b3) * fraction
            a = a3 + (a4 - a3) * fraction
        end
        
        local highlight_delta = (character_fraction - highlight_fraction)
        if highlight_delta >= 0 and highlight_delta <= 1.4 then
            if highlight_delta > 0.7 then
                highlight_delta = 1.4 - highlight_delta
            end
            local r_fraction, g_fraction, b_fraction, a_fraction = r4 - r, g4 - g, b4 - b, a4 - a
            r = r + r_fraction * highlight_delta / 0.8
            g = g + g_fraction * highlight_delta / 0.8
            b = b + b_fraction * highlight_delta / 0.8
            a = a + a_fraction * highlight_delta / 0.8
        end
        
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, a, text:sub(idx, idx))
    end
    
    return output
end

local tabs = {
    angle = pui.group('aa', 'anti-aimbot angles'),
    fake = pui.group('aa', 'fake lag'),
    other = pui.group('aa', 'other')
}

b_2.main = {
    label = tabs.fake:label(calculateGradient({127, 255, 212, 255}, {148, 127, 255, 255}, {255, 127, 170, 255}, {255, 76, 136, 255}, A_1.A_4, 2.5) .. "\r ~ Renewed"),
    space = tabs.fake:label("\n"),
    picklab = tabs.fake:label("Select"),
    space1 = tabs.fake:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    picker = tabs.fake:combobox("\n", {"Home", "Anti-Aim", "Settings"}),
    spaceoth = tabs.fake:label("\n"),
}

local configs = {}

b_2.home = {
    discord = tabs.other:button("Our \vDiscord", function ()
        panorama.loadstring(panorama.open("CSGOHud").SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/RrkzRkKKz8"))
    end),
    configlab = tabs.angle:label("Config System"),
    configl = tabs.angle:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    default = tabs.angle:button("Default", function() configs.import('W3sibWFpbiI6eyJwaWNrZXIiOiJIb21lIn0sInJhZ2UiOnsiZW5hYmxlIjpmYWxzZSwiYWlyc3RvcCI6WzAsMCwifiJdfSwiYWEiOnsiYWFwaWNrIjoiQnVpbGRlciIsImFkdmFuY2VkIjp7ImtleV9sZWZ0IjpbMSw5MCwifiJdLCJrZXlfcmlnaHQiOlsxLDY3LCJ+Il0sImZhc3RsYWRkZXIiOnRydWUsIm9wdGlvbnMiOlsiRWRnZSBvbiBmZCIsIlNhZmUga25pZmUiLCJ+Il0sImtleV9yZXNldCI6WzEsMCwifiJdLCJrZXlfZnJlZXN0YW5kIjpbMSw1LCJ+Il0sImFudGliYWNrc3RhYiI6dHJ1ZSwic2FmZWhlYWQiOnRydWV9LCJtYWluIjp7InN0YXRlIjoiXHUwMDBiQ3JvdWNoXHIifX0sInNldHRpbmdzIjp7InBpbmdwb3MiOiJIaWdoIiwiY2VudGVyX2MiOiIjOEREQUZGRkYiLCJtYW51YWxfYyI6IiM4RERBRkZGRiIsInNsaWRlYXdwIjoiRGlzYWJsZWQiLCJleHBkdCI6dHJ1ZSwic2xpZGVhdXRvIjoiRGlzYWJsZWQiLCJzbGlkZXI4IjoiRGlzYWJsZWQiLCJjZW50ZXIiOnRydWUsInNlbGVjdGd1biI6Ii0iLCJpbmRpY2F0b3JzIjp0cnVlLCJzZWxlY3RmaXgiOlsiTGVnIGZ1Y2tlciIsIlN0YXRpYyBMZWdzIiwifiJdLCJhbmltZml4Ijp0cnVlLCJob3RleHAiOlsxLDg4LCJ+Il0sInNsaWRlc2NvdXQiOiJEaXNhYmxlZCIsIm1hbnVhbCI6dHJ1ZSwicHJlZGljdCI6dHJ1ZSwibG9ncyI6eyJzdHlsZSI6WyJ+Il0sImVuYWJlbCI6ZmFsc2V9LCJ2aWV3bW9kZWxzY29wZSI6ZmFsc2UsInRhbGtpbmdzZWwiOlsia2lsbCIsImRlYXRoIiwifiJdLCJ0YWxraW5nIjp0cnVlLCJmaWx0ZXJjb25zIjp0cnVlfX0sW3siZW5hYmxlIjpmYWxzZSwicGl0Y2giOiJEZWZhdWx0IiwiZGVmYWFfZW5iIjpmYWxzZSwieWF3bW9kaWZlciI6IkNlbnRlciIsInlhd2Jhc2UiOiJBdCB0YXJnZXRzIiwiZGVsYXkiOjEsImRlZl95YXd2YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJib2R5eWF3IjoiU3RhdGljIiwiZGVmX3lhd3NsaWRlcjIiOjE4MCwieWF3dHlwZSI6IkxcL1IiLCJkZWZfY3VzdG9tcGl0Y2gxIjo4OSwiZGVmX3lhdyI6IkN1c3RvbWl6ZSIsImRlZl9jdXN0b21waXRjaCI6LTg5LCJkZWZfcGl0Y2giOiJDdXN0b21pemUiLCJkZWdyZWUiOjI1LCJkZWZfeWF3c2xpZGVyIjotMTgwLCJib2R5c2xpZGUiOjAsImxlZnQiOjAsInJpZ2h0IjowfSx7ImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJEZWZhdWx0IiwiZGVmYWFfZW5iIjpmYWxzZSwieWF3bW9kaWZlciI6IkNlbnRlciIsInlhd2Jhc2UiOiJBdCB0YXJnZXRzIiwiZGVsYXkiOjEsImRlZl95YXd2YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwiYm9keXlhdyI6IkppdHRlciIsImRlZl95YXdzbGlkZXIyIjowLCJ5YXd0eXBlIjoiTFwvUiIsImRlZl9jdXN0b21waXRjaDEiOjAsImRlZl95YXciOiJPZmYiLCJkZWZfY3VzdG9tcGl0Y2giOjAsImRlZl9waXRjaCI6Ik9mZiIsImRlZ3JlZSI6NzAsImRlZl95YXdzbGlkZXIiOjAsImJvZHlzbGlkZSI6MCwibGVmdCI6LTgsInJpZ2h0IjoxMn0seyJlbmFibGUiOnRydWUsInBpdGNoIjoiRGVmYXVsdCIsImRlZmFhX2VuYiI6ZmFsc2UsInlhd21vZGlmZXIiOiJDZW50ZXIiLCJ5YXdiYXNlIjoiQXQgdGFyZ2V0cyIsImRlbGF5IjoxLCJkZWZfeWF3dmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsImJvZHl5YXciOiJKaXR0ZXIiLCJkZWZfeWF3c2xpZGVyMiI6MCwieWF3dHlwZSI6IkxcL1IiLCJkZWZfY3VzdG9tcGl0Y2gxIjowLCJkZWZfeWF3IjoiT2ZmIiwiZGVmX2N1c3RvbXBpdGNoIjowLCJkZWZfcGl0Y2giOiJPZmYiLCJkZWdyZWUiOjcwLCJkZWZfeWF3c2xpZGVyIjowLCJib2R5c2xpZGUiOjAsImxlZnQiOi04LCJyaWdodCI6MTB9LHsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6IkRlZmF1bHQiLCJkZWZhYV9lbmIiOmZhbHNlLCJ5YXdtb2RpZmVyIjoiQ2VudGVyIiwieWF3YmFzZSI6IkF0IHRhcmdldHMiLCJkZWxheSI6MSwiZGVmX3lhd3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJib2R5eWF3IjoiU3RhdGljIiwiZGVmX3lhd3NsaWRlcjIiOjAsInlhd3R5cGUiOiJMXC9SIiwiZGVmX2N1c3RvbXBpdGNoMSI6MCwiZGVmX3lhdyI6Ik9mZiIsImRlZl9jdXN0b21waXRjaCI6MCwiZGVmX3BpdGNoIjoiT2ZmIiwiZGVncmVlIjozNCwiZGVmX3lhd3NsaWRlciI6MCwiYm9keXNsaWRlIjowLCJsZWZ0IjotMTAsInJpZ2h0IjoyM30seyJlbmFibGUiOnRydWUsInBpdGNoIjoiRGVmYXVsdCIsImRlZmFhX2VuYiI6ZmFsc2UsInlhd21vZGlmZXIiOiJDZW50ZXIiLCJ5YXdiYXNlIjoiQXQgdGFyZ2V0cyIsImRlbGF5Ijo1LCJkZWZfeWF3dmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiYm9keXlhdyI6IlN0YXRpYyIsImRlZl95YXdzbGlkZXIyIjowLCJ5YXd0eXBlIjoiRGVsYXkiLCJkZWZfY3VzdG9tcGl0Y2gxIjowLCJkZWZfeWF3IjoiT2ZmIiwiZGVmX2N1c3RvbXBpdGNoIjowLCJkZWZfcGl0Y2giOiJPZmYiLCJkZWdyZWUiOjMyLCJkZWZfeWF3c2xpZGVyIjowLCJib2R5c2xpZGUiOjAsImxlZnQiOi0xMiwicmlnaHQiOjE2fSx7ImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJEZWZhdWx0IiwiZGVmYWFfZW5iIjp0cnVlLCJ5YXdtb2RpZmVyIjoiQ2VudGVyIiwieWF3YmFzZSI6IkF0IHRhcmdldHMiLCJkZWxheSI6MSwiZGVmX3lhd3ZhbHVlIjoxODAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiYm9keXlhdyI6IlN0YXRpYyIsImRlZl95YXdzbGlkZXIyIjowLCJ5YXd0eXBlIjoiTFwvUiIsImRlZl9jdXN0b21waXRjaDEiOjAsImRlZl95YXciOiJTcGluIiwiZGVmX2N1c3RvbXBpdGNoIjowLCJkZWZfcGl0Y2giOiJVcCIsImRlZ3JlZSI6MzcsImRlZl95YXdzbGlkZXIiOjAsImJvZHlzbGlkZSI6MCwibGVmdCI6LTE5LCJyaWdodCI6MzJ9LHsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6IkRlZmF1bHQiLCJkZWZhYV9lbmIiOmZhbHNlLCJ5YXdtb2RpZmVyIjoiQ2VudGVyIiwieWF3YmFzZSI6IkF0IHRhcmdldHMiLCJkZWxheSI6MSwiZGVmX3lhd3ZhbHVlIjoxODAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsImJvZHl5YXciOiJKaXR0ZXIiLCJkZWZfeWF3c2xpZGVyMiI6MTgwLCJ5YXd0eXBlIjoiTFwvUiIsImRlZl9jdXN0b21waXRjaDEiOjAsImRlZl95YXciOiJDdXN0b21pemUiLCJkZWZfY3VzdG9tcGl0Y2giOjAsImRlZl9waXRjaCI6IlVwIiwiZGVncmVlIjo1NiwiZGVmX3lhd3NsaWRlciI6LTE4MCwiYm9keXNsaWRlIjowLCJsZWZ0IjotOCwicmlnaHQiOjE1fSx7ImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJEZWZhdWx0IiwiZGVmYWFfZW5iIjp0cnVlLCJ5YXdtb2RpZmVyIjoiT2ZmIiwieWF3YmFzZSI6IkF0IHRhcmdldHMiLCJkZWxheSI6MSwiZGVmX3lhd3ZhbHVlIjoxODAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiYm9keXlhdyI6IlN0YXRpYyIsImRlZl95YXdzbGlkZXIyIjoxODAsInlhd3R5cGUiOiJMXC9SIiwiZGVmX2N1c3RvbXBpdGNoMSI6MCwiZGVmX3lhdyI6IkN1c3RvbWl6ZSIsImRlZl9jdXN0b21waXRjaCI6MCwiZGVmX3BpdGNoIjoiQ3VzdG9taXplIiwiZGVncmVlIjowLCJkZWZfeWF3c2xpZGVyIjotMTgwLCJib2R5c2xpZGUiOjAsImxlZnQiOjAsInJpZ2h0IjowfSx7ImVuYWJsZSI6ZmFsc2UsInBpdGNoIjoiRGVmYXVsdCIsImRlZmFhX2VuYiI6ZmFsc2UsInlhd21vZGlmZXIiOiJPZmYiLCJ5YXdiYXNlIjoiQXQgdGFyZ2V0cyIsImRlbGF5IjoxLCJkZWZfeWF3dmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsImJvZHl5YXciOiJTdGF0aWMiLCJkZWZfeWF3c2xpZGVyMiI6MCwieWF3dHlwZSI6IkxcL1IiLCJkZWZfY3VzdG9tcGl0Y2gxIjowLCJkZWZfeWF3IjoiT2ZmIiwiZGVmX2N1c3RvbXBpdGNoIjowLCJkZWZfcGl0Y2giOiJPZmYiLCJkZWdyZWUiOjAsImRlZl95YXdzbGlkZXIiOjAsImJvZHlzbGlkZSI6MCwibGVmdCI6MCwicmlnaHQiOjB9XV0=') end),
    import = tabs.angle:button("Import", function() configs.import() end),
    export = tabs.angle:button("Export", function() configs.export() end)
}

local start_time = client.unix_time()
local function get_elapsed_time()
    local elapsed_seconds = client.unix_time() - start_time
    local hours = math.floor(elapsed_seconds / 3600)
    local minutes = math.floor((elapsed_seconds - hours * 3600) / 60)
    local seconds = math.floor(elapsed_seconds - hours * 3600 - minutes * 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local state_aa = enums.name_states

b_2.aa = {
    aapick = tabs.fake:combobox("\n",{"Builder", "Other"} ),
    -- space = tabs.angle:label("\n"),
    main = {
        labpick = tabs.angle:label("Builder"),
        labpickss = tabs.angle:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
        state = tabs.fake:combobox("\n", state_aa),
    },
    advanced = {
        labpick1 = tabs.angle:label("Binds"),
        space = tabs.angle:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
        key_left = tabs.angle:hotkey('Manual Left'),
        key_right = tabs.angle:hotkey('Manual Right'),
        key_reset = tabs.angle:hotkey('Manual Reset'),
        key_freestand = tabs.angle:hotkey('Freestanding'),
        spacee = tabs.angle:label("\n"),
        labpick2 = tabs.angle:label("Other"),
        space3 = tabs.angle:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
        antibackstab = tabs.angle:checkbox("Anti-Backstab"),
        safehead = tabs.angle:checkbox("Safe Head"),
        options = tabs.angle:multiselect("\n",{"Edge On FD", "Safe Knife"}),
        fastladder = tabs.angle:checkbox("Fast Ladder"),
        slowmotion = tabs.other:checkbox("Slow Motion", 0x00),
        hideshots = tabs.other:checkbox("\aC7C76DFFOn Shot Anti-Aim", 0x00),
        fakepeek = tabs.other:checkbox("\aC7C76DFFFake Peek", 0x00)
    }
}

b_2.fakelag = {
    amount = tabs.other:combobox("Amount", "Dynamic", "Maximum", "Fluctuate"),
    variance = tabs.other:slider("Variance", 0, 100, 0, true, "%", 1),
    limit = tabs.other:slider("Limit", 1, 15, 13, true, "t", 1)
}

b_2.settings = {
    labpick = tabs.angle:label("Settings"),
    labpicks = tabs.angle:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    filtercons = tabs.angle:checkbox("Filter Console"),
    animfix = tabs.angle:checkbox("Animation Breaker"),
    selectfix = tabs.angle:multiselect("\n", {"Leg Fucker", "Body Lean", "Broken" ,"Static Legs", "Walk"}),
    talking = tabs.angle:checkbox("Trash Talk"),
    talkingsel = tabs.angle:multiselect("\n", "Kill", "Death"),
    spacex = tabs.angle:label("\n"),
    labs = tabs.angle:label("Visual"),
    ayeshe4ka = tabs.angle:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    viewmodelscope = tabs.angle:checkbox("Viewmodel Scope"),
    watermark = tabs.angle:checkbox("Watermark"),
    indicators = tabs.angle:checkbox("Indicators"),
    center = tabs.angle:checkbox("Center", {75, 35, 155, 255}),
    manual = tabs.angle:checkbox("Manual", {75, 35, 155, 255}),
    logs = {
        enable = tabs.angle:checkbox("Logging"),
        style = tabs.angle:multiselect("\n", {"On-Screen", "Console"}),
    },
}

b_2.rage = {
    lab = tabs.other:label("Rage"),
    space = tabs.other:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    expdt = tabs.other:checkbox("\aFD002FFFMantle Devil Tap"),
    airstop = tabs.other:checkbox("Air Stop", 0x00),
    predict = tabs.other:checkbox("\v⛧\r The Grimoire Of Mephissa \v⛧\r"),
    hotexp = tabs.other:hotkey("\v♯\r Liberate \aFD002FFFme\r, mortal ✟"),
    pingpos = tabs.other:combobox("Ping Variations", {"High", "Low"}),
    selectgun = tabs.other:combobox("\n", {"-", "AWP", "SCOUT", "AUTO", "R8"}),
    slideawp = tabs.other:combobox("\n", {"Disabled", "Medium", "Maximum", "Extreme"}),
    slidescout = tabs.other:combobox("\n",{"Disabled", "Medium", "Maximum", "Extreme"}),
    slideauto = tabs.other:combobox("\n",{"Disabled", "Medium", "Maximum", "Extreme"}),
    slider8 = tabs.other:combobox("\n",{"Disabled", "Medium", "Maximum", "Extreme"})
}

local builder = {}

for i=1, #state_aa do
    builder[i] = {    
        enable = tabs.angle:checkbox('Enable '..state_aa[i]),
        pitch = tabs.angle:combobox("Pitch \v»\r Type", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
        yawbase = tabs.angle:combobox("Yawbase \v»\r Type", {"At targets", "Local View"}),
        yawtype = tabs.angle:combobox("Yaw \v»\r Type", {"L/R", "Delay"}),
        left = tabs.angle:slider("\v~\r Yaw Left", -180, 180, 0, true, "°"),
        right = tabs.angle:slider("\v~\r Yaw Right", -180, 180, 0, true, "°"),
        delay = tabs.angle:slider("\v~\r Delay Ticks", 1, 14, 1, true),
        yawmodifer = tabs.angle:combobox("Yaw \v»\r Modifer", {"Off", "Offset", "Center", "Skitter"}),
        degree = tabs.angle:slider("\v~\r Degree", -180, 180, 0, true,"°"),
        bodyyaw = tabs.angle:combobox("Body Yaw \v»\r Type", {"Static", "Jitter", "Opposite"}),
        bodyslide = tabs.angle:slider("\v~\r Range", -180, 180, 0, true, "°"),
        
        force_defensive = tabs.angle:checkbox("Enable \vForce Defensive"),
        onshotaa = tabs.angle:checkbox("Force On Hide Shots"),
        defaa_enb = tabs.angle:checkbox("Defensive Anti-Aim"),
        def_pitch = tabs.angle:combobox("\vDefensive ·\r Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Customize"}),
        def_custompitch = tabs.angle:slider("Min", -89, 0, 0, true, "°", 1),
        def_custompitch1 = tabs.angle:slider("Max", 0, 89, 0, true, "°", 1),
        def_yaw = tabs.angle:combobox("\vDefensive ·\r Yaw", {"Off", "Spin", "Customize"}),
        def_yawvalue = tabs.angle:slider("Speed", -180, 180, 0, true,"°", 1),
        def_yawslider = tabs.angle:slider("Min", -180, 0, 0, true, "°", 1),
        def_yawslider2 = tabs.angle:slider("Max", 0, 180, 0, true, "°", 1),
    }
end

for i=1, #state_aa do
    -- Request
    cond_check = {b_2.aa.main.state, function() return (i ~= 1) end}
    tab_cond = {b_2.aa.main.state, state_aa[i]}
    check_tab = {b_2.main.picker, "Anti-Aim"}
    menut_tab = {b_2.aa.aapick, "Builder"}
    delay = {builder[i].yawtype, "Delay"}
    lrcheck = {builder[i].yawtype, "L/R" or builder[i].yawtype, "Delay"}
    default = {builder[i].yawmodifer, "Center" or builder[i].yawmodifer, "Offset" or builder[i].yawmodifer, "Skitter"}
    checks = {builder[i].bodyyaw, "Static", "Jitter"}
    
    custompitch = {builder[i].def_pitch, "Customize"}
    yawslid = {builder[i].def_yaw, "Customize"}
    yawslid2 = {builder[i].def_yaw, "Spin"}
    defaa = {builder[i].defaa_enb, function() if (i == 1 ) then return builder[i].defaa_enb:get() else return builder[i].defaa_enb:get() end end}
    defensive = {builder[i].force_defensive, function() if (i == 1) then return builder[i].force_defensive:get() else return builder[i].force_defensive:get() end end}
    cnd_en = {builder[i].enable, function() if (i == 1) then return true else return builder[i].enable:get() end end}
    
    --Default
    
    builder[i].enable:depend(cond_check, tab_cond,check_tab, menut_tab)
    builder[i].pitch:depend( tab_cond, cnd_en,check_tab, menut_tab)
    builder[i].yawbase:depend( tab_cond,cnd_en, check_tab, menut_tab)
    builder[i].yawtype:depend( tab_cond, cnd_en,check_tab, menut_tab)
    builder[i].yawmodifer:depend(tab_cond, cnd_en, check_tab, menut_tab)
    builder[i].degree:depend(tab_cond, cnd_en,check_tab, menut_tab, default)
    builder[i].left:depend( tab_cond, cnd_en,check_tab, menut_tab, lrcheck)
    builder[i].right:depend( tab_cond, cnd_en,check_tab, menut_tab, lrcheck)
    builder[i].delay:depend( tab_cond, cnd_en,check_tab, menut_tab, delay)
    builder[i].bodyyaw:depend( tab_cond, cnd_en,check_tab, menut_tab)
    builder[i].bodyslide:depend(tab_cond, cnd_en, check_tab, menut_tab, checks)
    
    --#defensive
    
    builder[i].force_defensive:depend( tab_cond,check_tab, cnd_en, menut_tab)
    builder[i].onshotaa:depend(tab_cond,check_tab, cnd_en, menut_tab, defensive)
    builder[i].defaa_enb:depend(tab_cond,check_tab, cnd_en, menut_tab, defensive)
    builder[i].def_custompitch:depend(tab_cond,check_tab, cnd_en, menut_tab, defensive, defaa, custompitch)
    builder[i].def_custompitch1:depend(tab_cond,check_tab, cnd_en, menut_tab, defensive,defaa, custompitch)
    builder[i].def_yaw:depend(tab_cond,check_tab, cnd_en, menut_tab, defaa,defensive)
    builder[i].def_yawslider:depend(tab_cond,check_tab, cnd_en, menut_tab, defensive,defaa, yawslid)
    builder[i].def_yawslider2:depend(tab_cond,check_tab, cnd_en, menut_tab, defensive,defaa, yawslid)
    builder[i].def_pitch:depend(tab_cond,check_tab, cnd_en, menut_tab, defaa, defensive)
    builder[i].def_yawvalue:depend(tab_cond, check_tab, cnd_en, menut_tab, defaa, defensive, yawslid2)
end

local breaker = {
    defensive = 0,
    defensive_check = 0,
    cmd = 0,
    last_origin = nil,
    origin = nil,
    tp_dist = 0,
    tp_data = gram_create(0,3),
    mapname = globals.mapname()
}

local last_press_t_dir = 0
local manual_dir = 0

antiknife = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

local run_direction = function()
    ui.set(s_2.s_1.freeStand[1], b_2.aa.advanced.key_freestand:get())
    ui.set(s_2.s_1.freeStand[2], b_2.aa.advanced.key_freestand:get() and 'Always on' or 'On hotkey')

    if manual_dir ~= 0 then
        ui.set(s_2.s_1.freeStand[1], false)
    end

    if b_2.aa.advanced.key_right:get() and last_press_t_dir + 0.2 < globals.curtime() then
        manual_dir = manual_dir == 2 and 0 or 2
        last_press_t_dir = globals.curtime()
    elseif b_2.aa.advanced.key_left:get() and last_press_t_dir + 0.2 < globals.curtime() then
        manual_dir = manual_dir == 1 and 0 or 1
        last_press_t_dir = globals.curtime()
    elseif b_2.aa.advanced.key_reset:get() and last_press_t_dir + 0.2 < globals.curtime() then
        manual_dir = manual_dir == 0
        last_press_t_dir = globals.curtime()
    elseif last_press_t_dir > globals.curtime() then
        last_press_t_dir = globals.curtime()
    end

end

local function animix()
    if not b_2.settings.animfix:get() then return end 
    if not entity.get_local_player() then return end
    local lp = entity.get_local_player()
    local self_index = c_entity.new(lp)

    if b_2.settings.selectfix:get('Body Lean') then
        local lp = entity.get_local_player()
        if not lp or not entity.is_alive(lp) then return end
        local self_index = c_entity.new(lp)
        local anim_layer_tw = self_index:get_anim_overlay(12)
        if not anim_layer_tw then return end
        anim_layer_tw.weight = math.random(1, 15) / 10
    end
    
    if b_2.settings.selectfix:get("Static Legs") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
    end

    if b_2.settings.selectfix:get("Leg Fucker") then
        entity.set_prop(lp, "m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 0.5 or 1)
    end
    
    if b_2.settings.selectfix:get("Broken") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 3)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 7)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 6)
    end

    if b_2.settings.selectfix:get("Walk") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 7)
    end
end

client.set_event_callback('pre_render', function()
    animix()
end)

local id = 1 
local function player_state(cmd)
    local lp = entity.get_local_player()
    if lp == nil then return end
    local vecvelocity = { entity.get_prop(lp, 'm_vecVelocity') }
    local flags = entity.get_prop(lp, 'm_fFlags')
    local velocity = math.sqrt(vecvelocity[1]^2+vecvelocity[2]^2)
    local groundcheck = bit.band(flags, 1) == 1
    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
    local ducked = entity.get_prop(lp, 'm_flDuckAmount') > 0.7
    local duckcheck = ducked or ui.get(s_2.s_0.fakeduck)
    local manuals = manual_dir == 1 or manual_dir == 2
    local slowwalk_key = ui.get(s_2.s_1.slow[1]) and ui.get(s_2.s_1.slow[2])
    local lag = not ui.get(s_2.s_1.onshotaa[1]) and not ui.get(s_2.s_1.onshotaa[2]) or ui.get(s_2.s_0.dt[1]) and not ui.get(s_2.s_0.dt[2])

    if jumpcheck and duckcheck then return "Air+C"
    elseif jumpcheck then return "Air"
    elseif duckcheck and velocity > 10 then return "Duck-Moving"
    elseif duckcheck and velocity < 10 then return "Duck"
    elseif groundcheck and slowwalk_key and velocity > 10 then return "Walking"
    elseif groundcheck and velocity > 5 then return "Moving"
    elseif groundcheck and velocity < 5 then return "Stand"
    elseif lag then return "Fakelag"
    else return "Global" end
end

forrealtime = 0
function smoothJitter(switchyaw1, switchyaw2, switchingspeed)
    if globals.curtime() > forrealtime + 1 / (switchingspeed * 2) then
        finalyawgg = switchyaw1
        if globals.curtime() - forrealtime > 2 / (switchingspeed * 2) then
            forrealtime = globals.curtime()
        end
    else
        finalyawgg = switchyaw2
    end
    return finalyawgg
end

function desyncside()
    if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then
        return
    end
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and -1 or 1
    return side
end

client.set_event_callback("predict_command", function(cmd)
    if cmd.command_number == breaker.cmd then
        local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
        breaker.defensive = math.abs(tickbase - breaker.defensive_check)
        breaker.defensive_check = math.max(tickbase, breaker.defensive_check)
        breaker.cmd = 0
    end
end)

client.set_event_callback("run_command", function(cmd)
    breaker.cmd = cmd.command_number
    if cmd.chokedcommands == 0 then
        breaker.origin = vector(entity.get_origin(entity.get_local_player()))
        if breaker.last_origin ~= nil then
            breaker.tp_dist = (breaker.origin - breaker.last_origin):length2dsqr()
            gram_update(breaker.tp_data, breaker.tp_dist, true)
        end
        breaker.last_origin = breaker.origin
    end
end)

local function aa_setup(cmd)
    local lp = entity.get_local_player()
    local tp_amount = get_average(breaker.tp_data)/get_velocity(lp)*100 
    local is_defensive = (breaker.defensive > 1) and not (tp_amount >= 25 and breaker.defensive >= 13) and ui.get(s_2.s_0.dt[1]) and ui.get(s_2.s_0.dt[2]) or b_2.aa.advanced.hideshots.hotkey:get() and builder[id].onshotaa:get()
    local threat = client.current_threat()
    local weapon = entity.get_player_weapon(lp)
    local lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(lp, "m_vecOrigin")
    local flags = entity.get_prop(lp, 'm_fFlags')
    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
    local ducked = entity.get_prop(lp, 'm_flDuckAmount') > 0.7
    

    if lp == nil then return end
    
    if player_state(cmd) == "Duck-Moving" and builder[8].enable:get() then id = 8
    elseif player_state(cmd) == "Fakelag" and builder[10].enable:get() then id = 9
    elseif player_state(cmd) == "Duck" and builder[7].enable:get() then id = 7
    elseif player_state(cmd) == "Air+C" and builder[6].enable:get() then id = 6
    elseif player_state(cmd) == "Air" and builder[5].enable:get() then id = 5
    elseif player_state(cmd) == "Moving" and builder[4].enable:get() then id = 4
    elseif player_state(cmd) == "Walking" and builder[3].enable:get() then id = 3
    elseif player_state(cmd) == "Stand" and builder[2].enable:get() then id = 2
    else id = 1 end


    -- print(id)
    run_direction()


    cmd.force_defensive = builder[id].force_defensive:get()

    ui.set(s_2.s_1.fakelagenabled[1], true)
    ui.set(s_2.s_1.fakelagamount[1], b_2.fakelag.amount:get())
    ui.set(s_2.s_1.fakelagvariance[1], b_2.fakelag.variance:get())
    ui.set(s_2.s_1.fakelaglimit[1], b_2.fakelag.limit:get())
    local settings = {
        {b_2.aa.advanced.slowmotion, s_2.s_1.slow},
        {b_2.aa.advanced.hideshots, s_2.s_1.onshotaa},
        {b_2.aa.advanced.fakepeek, s_2.s_1.fakepeek}
    }
    for _, setting in ipairs(settings) do
        if setting[1]:get() then
            ui.set(setting[2][1], setting[1].hotkey:get())
            ui.set(setting[2][2], 'Always On')
        else
            ui.set(setting[2][2], 'On Hotkey')
        end
    end

    if builder[id].defaa_enb:get() and is_defensive then
        ui.set(s_2.s_1.anti_aim[1], true)
        if builder[id].def_pitch:get() == "Off" then
            ui.set(s_2.s_1.pitch[1], "Off")
        elseif builder[id].def_pitch:get() == "Default" then
            ui.set(s_2.s_1.pitch[1], "Default")
        elseif builder[id].def_pitch:get() == "Up" then
            ui.set(s_2.s_1.pitch[1], "Up")
        elseif builder[id].def_pitch:get() == "Down" then
            ui.set(s_2.s_1.pitch[1], "Down")
        elseif builder[id].def_pitch:get() == "Minimal" then
            ui.set(s_2.s_1.pitch[1], "Minimal")
        elseif builder[id].def_pitch:get() == "Customize" then
            ui.set(s_2.s_1.pitch[1], "Custom")
            ui.set(s_2.s_1.pitch[2], math.random(builder[id].def_custompitch:get(), builder[id].def_custompitch1:get()))
        end

        if builder[id].def_yaw:get() == "Off" then
            ui.set(s_2.s_1.yaw[1], "Off")
            ui.set(s_2.s_1.yaw[2], 0)
        elseif builder[id].def_yaw:get() == "Spin" then
            ui.set(s_2.s_1.yaw[1], "Spin")
            ui.set(s_2.s_1.yaw[2], builder[id].def_yawvalue:get())
        elseif builder[id].def_yaw:get() == "Customize" then
            ui.set(s_2.s_1.yaw[1], "180")
            ui.set(s_2.s_1.yaw[2], math.random(builder[id].def_yawslider:get(), builder[id].def_yawslider2:get()))
        end
    else
        ui.set(s_2.s_1.anti_aim[1], true)
        ui.set(s_2.s_1.pitch[1], builder[id].pitch:get())
        ui.set(s_2.s_1.yawbase, builder[id].yawbase:get())
        ui.set(s_2.s_1.yawjitter[1], builder[id].yawmodifer:get())
        ui.set(s_2.s_1.yawjitter[2], builder[id].degree:get())
        ui.set(s_2.s_1.bodyyaw[1], builder[id].bodyyaw:get())
        ui.set(s_2.s_1.bodyyaw[2], builder[id].bodyslide:get() + 1)
        if builder[id].yawtype:get() == "L/R" and desyncside() == -1 then 
            ui.set(s_2.s_1.yaw[1], "180")
            ui.set(s_2.s_1.yaw[2], builder[id].left:get()) 
        else
            ui.set(s_2.s_1.yaw[1], "180") 
            ui.set(s_2.s_1.yaw[2], builder[id].right:get()) 
        end
        if builder[id].yawtype:get() == "Delay" then 
            ui.set(s_2.s_1.yaw[1], "180")
            ui.set(s_2.s_1.yaw[2], smoothJitter(builder[id].left:get(), builder[id].right:get(), builder[id].delay:get()))  
        end
    end



    if manual_dir == 2 then
        ui.set(s_2.s_1.pitch[1], "Minimal")
        ui.set(s_2.s_1.yawbase, "Local view")
        ui.set(s_2.s_1.yaw[1], "180")
        ui.set(s_2.s_1.yaw[2], 90)
        ui.set(s_2.s_1.yawjitter[1], "Offset")
        ui.set(s_2.s_1.yawjitter[2], 0)
        ui.set(s_2.s_1.bodyyaw[1], "Off")
        ui.set(s_2.s_1.bodyyaw[2], 0)
        ui.set(s_2.s_1.fs_body_yaw, false)
    end

    if manual_dir == 1 then
        ui.set(s_2.s_1.pitch[1], "Minimal")
        ui.set(s_2.s_1.yawbase, "Local view")
        ui.set(s_2.s_1.yaw[1], "180")
        ui.set(s_2.s_1.yaw[2], -90)
        ui.set(s_2.s_1.yawjitter[1], "Offset")
        ui.set(s_2.s_1.yawjitter[2], 0)
        ui.set(s_2.s_1.bodyyaw[1], "Off")
        ui.set(s_2.s_1.bodyyaw[2], 0)
        ui.set(s_2.s_1.fs_body_yaw, false)
    end

    if b_2.aa.advanced.safehead:get() then
        if b_2.aa.advanced.options:get("Edge On FD") then
            if ui.get(s_2.s_0.fakeduck) then
                ui.set(s_2.s_1.edgeyaw, true)
            else
                ui.set(s_2.s_1.edgeyaw, false)
            end
        end
        if b_2.aa.advanced.options:get("Safe Knife") then
            if jumpcheck and ducked and entity.get_classname(weapon) == "CKnife" then
                if not is_defensive then
                    ui.set(s_2.s_1.pitch[1], "Minimal")
                    ui.set(s_2.s_1.yawbase, "At targets")
                    ui.set(s_2.s_1.yaw[1], "180")
                    ui.set(s_2.s_1.yaw[2], 14)
                    ui.set(s_2.s_1.yawjitter[1], "Off")
                    ui.set(s_2.s_1.yawjitter[2], 0)
                    ui.set(s_2.s_1.bodyyaw[1], "Static")
                    ui.set(s_2.s_1.bodyyaw[2], 1)
                    ui.set(s_2.s_1.fs_body_yaw, false)
                else
                    cmd.force_defensive = 1
                    ui.set(s_2.s_1.pitch[1], "Custom")
                    ui.set(s_2.s_1.pitch[2], 0)
                    ui.set(s_2.s_1.yawbase, "At targets")
                    ui.set(s_2.s_1.yaw[1], "Off")
                    ui.set(s_2.s_1.yaw[2], 0)
                    ui.set(s_2.s_1.yawjitter[1], "Off")
                    ui.set(s_2.s_1.yawjitter[2], 0)
                    ui.set(s_2.s_1.bodyyaw[1], "Off")
                    ui.set(s_2.s_1.bodyyaw[2], 0)
                    ui.set(s_2.s_1.fs_body_yaw, false)
                end
            end
        end
    end

    
    local players = entity.get_players(true)
    if b_2.aa.advanced.antibackstab:get() then
        lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(lp, "m_vecOrigin")
        for i=1, #players do
            if players == nil then return end
            enemy_orig_x, enemy_orig_y, enemy_orig_z = entity.get_prop(players[i], "m_vecOrigin")
            distance_to = antiknife(lp_orig_x, lp_orig_y, lp_orig_z, enemy_orig_x, enemy_orig_y, enemy_orig_z)
            weapon = entity.get_player_weapon(players[i])
            if weapon == nil then return end
            if entity.get_classname(weapon) == "CKnife" and distance_to <= 250 then
                ui.set(s_2.s_1.yaw[2], "180")
                ui.set(s_2.s_1.yawbase, "At targets")
            end
        end
    end
end


--#region :: Drag another
local vars = {}

local emberlash = {}

vars.drag = {}

local color do

    local helpers = {
		RGBtoHEX = a(function (col, short)
			return string.format(short and "%02X%02X%02X" or "%02X%02X%02X%02X", col.r, col.g, col.b, col.a)
		end),
		HEXtoRGB = a(function (hex)
			hex = string.gsub(hex, "^#", "")
			return tonumber(string.sub(hex, 1, 2), 16), tonumber(string.sub(hex, 3, 4), 16), tonumber(string.sub(hex, 5, 6), 16), tonumber(string.sub(hex, 7, 8), 16) or 255
		end)
	}

    local create

    local mt = {
		__eq = a(function (a, b)
			return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
		end),
		lerp = a(function (f, t, w)
			return create(f.r + (t.r - f.r) * w, f.g + (t.g - f.g) * w, f.b + (t.b - f.b) * w, f.a + (t.a - f.a) * w)
		end),
		to_hex = helpers.RGBtoHEX,
		alphen = a(function (self, a, r)
			return create(self.r, self.g, self.b, r and a * self.a or a)
		end),
	}	mt.__index = mt


    create = ffi.metatype(ffi.typeof("struct { uint8_t r; uint8_t g; uint8_t b; uint8_t a; }"), mt)


    color = setmetatable({
		rgb = a(function (r,g,b,a)
			r = math.min(r or 255, 255)
			return create(r, g and math.min(g, 255) or r, b and math.min(b, 255) or r, a and math.min(a, 255) or 255)
		end),
		hex = a(function (hex)
			local r,g,b,a = helpers.HEXtoRGB(hex)
			return create(r,g,b,a)
		end)
	},{
		__call = a(function (self, r, g, b, a)
			return type(r) == "string" and self.hex(r) or self.rgb(r, g, b, a)
		end),
	})
end

local colors = {
	hex		= "\a74A6A9FF",
	accent	= color.hex("74A6A9"),
	back	= color.rgb(23, 26, 28),
	dark	= color.rgb(5, 6, 8),
	white	= color.rgb(255),
	black	= color.rgb(0),
	null	= color.rgb(0, 0, 0, 0),
	text	= color.rgb(230),
	panel = {
		l1 = color.rgb(5, 6, 8, 180),
		g1 = color.rgb(5, 6, 8, 140),
		l2 = color.rgb(23, 26, 28, 96),
		g2 = color.rgb(23, 26, 28, 140),
	}
}

local DPI, _DPI = 1, {}
local sw, sh = client.screen_size()
local asw, ash = sw, sh
local sc = {x = sw * .5, y = sh * .5}
local asc = {x = asw * .5, y = ash * .5}

-- #region - Callbacks

local callbacks do
	local event_mt = {
		__call = function (self, bool, fn)
			local action = bool and client.set_event_callback or client.unset_event_callback
			action(self[1], fn)
		end,
		set = function (self, fn)
			client.set_event_callback(self[1], fn)
		end,
		unset = function (self, fn)
			client.unset_event_callback(self[1], fn)
		end,
		fire = function (self, ...)
			client.fire_event(self[1], ...)
		end,
	}	event_mt.__index = event_mt

	callbacks = setmetatable({}, {
		__index = function (self, key)
			self[key] = setmetatable({key}, event_mt)
			return self[key]
		end,
	})
end

-- #endregion

local my = {
    valid = false,
}


local render do
	local alpha = 1
	local astack = {}

	local measurements = setmetatable({}, { __mode = "kv" })

	-- #region - dpi

	local dpi_flag = ""
	local dpi_ref = ui.reference("MISC", "Settings", "DPI scale")

	_DPI.scalable = false
	_DPI.callback = function ()
		local old = DPI
		DPI = _DPI.scalable and tonumber(ui.get(dpi_ref):sub(1, -2)) * .01 or 1

		sw, sh = client.screen_size()
		sw, sh = sw / DPI, sh / DPI
		sc.x, sc.y = sw * .5, sh * .5
		dpi_flag = DPI ~= 1 and "d" or ""

		if old ~= DPI then
			callbacks["hysteria::render_dpi"]:fire(DPI)
			old = DPI
		end
	end

	_DPI.callback()
	ui.set_callback(dpi_ref, _DPI.callback)

	-- #endregion

	-- #region - blur

	local blurs = setmetatable({}, {__mode = "kv"})

	do
		local function check_screen ()
			if sw == 0 or sh == 0 then
				_DPI.callback()
				asw, ash = client.screen_size()
				sw, sh = render.screen_size()
			else
				callbacks.paint_ui:unset(check_screen)
			end
		end
		callbacks.paint_ui:set(check_screen)
	end

	callbacks.paint:set(function ()
		for i = 1, #blurs do
			local v = blurs[i]
			if v then renderer.blur(v[1], v[2], v[3], v[4]) end
		end
		table.clear(blurs)
	end)
	callbacks.paint_ui:set(function ()
		table.clear(blurs)
	end)

	-- #endregion

	local F, C, R = math.floor, math.ceil, math.round

	--
	render = setmetatable({
		cheap = false,

		push_alpha = a(function (v)
			local len = #astack
			astack[len+1] = v
			alpha = alpha * astack[len+1] * (astack[len] or 1)
			if len > 255 then error "alpha stack exceeded 255 objects, report to developers" end
		end),
		pop_alpha = a(function ()
			local len = #astack
			astack[len], len = nil, len-1
			alpha = len == 0 and 1 or astack[len] * (astack[len-1] or 1)
		end),
		get_alpha = a(function ()  return alpha  end),

		blur = a(function (x, y, w, h, a, s)
			if not render.cheap and my.valid and (a or 1) * alpha > .25 then
				blurs[#blurs+1] = {F(x * DPI), F(y * DPI), F(w * DPI), F(h * DPI)}
			end
		end),
		gradient = a(function (x, y, w, h, c1, c2, dir)
			renderer.gradient(F(x * DPI), F(y * DPI), F(w * DPI), F(h * DPI), c1.r, c1.g, c1.b, c1.a * alpha, c2.r, c2.g, c2.b, c2.a * alpha, dir or false)
		end),

		line = a(function (xa, ya, xb, yb, c)
			renderer.line(F(xa * DPI), F(ya * DPI), F(xb * DPI), F(yb * DPI), c.r, c.g, c.b, c.a * alpha)
		end),
		rectangle = a(function (x, y, w, h, c, n)
			x, y, w, h, n = F(x * DPI), F(y * DPI), F(w * DPI), F(h * DPI), n and F(n * DPI) or 0
			local r, g, b, a = c.r, c.g, c.b, c.a * alpha

			if n == 0 then
				renderer.rectangle(x, y, w, h, r, g, b, a)
			else
				renderer.circle(x + n, y + n, r, g, b, a, n, 180, 0.25)
				renderer.rectangle(x + n, y, w - n - n, n, r, g, b, a)
				renderer.circle(x + w - n, y + n, r, g, b, a, n, 90, 0.25)
				renderer.rectangle(x, y + n, w, h - n - n, r, g, b, a)
				renderer.circle(x + n, y + h - n, r, g, b, a, n, 270, 0.25)
				renderer.rectangle(x + n, y + h - n, w - n - n, n, r, g, b, a)
				renderer.circle(x + w - n, y + h - n, r, g, b, a, n, 0, 0.25)
			end
		end),
		rect_outline = a(function (x, y, w, h, c, n, t)
			x, y, w, h, n, t = F(x * DPI), F(y * DPI), F(w * DPI), F(h * DPI), n and F(n * DPI) or 0, t and F(t * DPI) or 1
			local r, g, b, a = c.r, c.g, c.b, c.a * alpha

			if n == 0 then
				renderer.rectangle(x, y, w - t, t, r, g, b, a)
				renderer.rectangle(x, y + t, t, h - t, r, g, b, a)
				renderer.rectangle(x + w - t, y, t, h - t, r, g, b, a)
				renderer.rectangle(x + t, y + h - t, w - t, t, r, g, b, a)
			else
				renderer.circle_outline(x + n, y + n, r, g, b, a, n, 180, 0.25, t)
				renderer.rectangle(x + n, y, w - n - n, t, r, g, b, a)
				renderer.circle_outline(x + w - n, y + n, r, g, b, a, n, 270, 0.25, t)
				renderer.rectangle(x, y + n, t, h - n - n, r, g, b, a)
				renderer.circle_outline(x + n, y + h - n, r, g, b, a, n, 90, 0.25, t)
				renderer.rectangle(x + n, y + h - t, w - n - n, t, r, g, b, a)
				renderer.circle_outline(x + w - n, y + h - n, r, g, b, a, n, 0, 0.25, t)
				renderer.rectangle(x + w - t, y + n, t, h - n - n, r, g, b, a)
			end
		end),
		triangle = a(function (x1, y1, x2, y2, x3, y3, c)
			x1, y1, x2, y2, x3, y3 = x1 * DPI, y1 * DPI, x2 * DPI, y2 * DPI, x3 * DPI, y3 * DPI
			renderer.triangle(x1, y1, x2, y2, x3, y3, c.r, c.g, c.b, c.a * alpha)
		end),

		circle = a(function (x, y, c, radius, start, percentage)
			renderer.circle(x * DPI, y * DPI, c.r, c.g, c.b, c.a * alpha, radius * DPI, start or 0, percentage or 1)
		end),
		circle_outline = a(function (x, y, c, radius, start, percentage, thickness)
			renderer.circle(x * DPI, y * DPI, c.r, c.g, c.b, c.a * alpha, radius * DPI, start or 0, percentage or 1, thickness * DPI)
		end),

		screen_size = a(function (raw)
			local w, h = client.screen_size()
			if raw then return w, h else return w / DPI, h / DPI end
		end),

		load_rgba = a(function (c, w, h) return renderer.load_rgba(c, w, h) end),
		load_jpg = a(function (c, w, h) return renderer.load_jpg(c, w, h) end),
		load_png = a(function (c, w, h) return renderer.load_png(c, w, h) end),
		load_svg = a(function (c, w, h) return renderer.load_svg(c, w, h) end),
		texture = a(function (id, x, y, w, h, c, mode)
			if not id then return end
			renderer.texture(id, F(x * DPI), F(y * DPI), F(w * DPI), F(h * DPI), c.r, c.g, c.b, c.a * alpha, mode or "f")
		end),

		text = a(function (x, y, c, flags, width, ...)
			renderer.text(x * DPI, y * DPI, c.r, c.g, c.b, c.a * alpha, (flags or "") .. dpi_flag, width or 0, ...)
		end),
		measure_text = a(function (flags, text)
			if not text or text == "" then return 0, 0 end
			text = text:gsub("\a%x%x%x%x%x%x%x%x", "")

			flags = (flags or "")

			local key = string.format("<%s>%s", flags, text)
			if not measurements[key] or measurements[key][1] == 0 then
				measurements[key] = { renderer.measure_text(flags, text) }
			end
			return measurements[key][1], measurements[key][2]
			-- return renderer.measure_text(flags, text)
		end),
	}, {__index = renderer})
end


textures = {
	corner_h = render.load_svg('<svg width="4" height="5.87" viewBox="0 0 4 6"><path fill="#fff" d="M0 6V4c0-2 2-4 4-4v2C2 2 0 4 0 6Z"/></svg>', 8, 12),
	corner_v = render.load_svg('<svg width="5.87" height="4" viewBox="0 0 6 4"><path fill="#fff" d="M2 0H0c0 2 2 4 4 4h2C4 4 2 2 2 0Z"/></svg>', 12, 8),
    logo = render.load_png("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x20\x00\x00\x00\x20\x08\x06\x00\x00\x00\x73\x7A\x7A\xF4\x00\x00\x00\x06\x62\x4B\x47\x44\x00\x00\x00\x00\x00\x00\xF9\x43\xBB\x7F\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0E\xC3\x00\x00\x0E\xC3\x01\xC7\x6F\xA8\x64\x00\x00\x00\x07\x74\x49\x4D\x45\x07\xE4\x07\x08\x0E\x27\x1E\x21\xA8\x70\xB7\x00\x00\x00\x1D\x69\x54\x58\x74\x43\x6F\x6D\x6D\x65\x6E\x74\x00\x00\x00\x00\x00\x43\x72\x65\x61\x74\x65\x64\x20\x77\x69\x74\x68\x20\x47\x49\x4D\x50\x57\x81\x0E\x17\x00\x00\x00\xDB\x49\x44\x41\x54\x58\x85\xC5\x97\xD1\x0D\x80\x20\x0C\x44\xBF\x9C\xDC\xA0\x4B\x3A\xB7\xE0\x9E\xE0\x4F\x0F\xF5\x30\x88\xC1\xCC\x8D\x30\x31\xC5\x4D\x06\x2B\x9D\xFB\xC2\x9D\x07\x09\x0C\x0C\x8E\x62\x6E\x47\x44\x29\x24\x60\x0B\x40\x06\x4B\xA4\x92\x04\x58\x70\x61\x52\x1B\x5F\xE1\x6A\x69\x09\x2A\x41\x30\x40\x3F\x28\x11\x10\xD3\xCC\x1B\x88\xA8\xD9\xE7\x24\x16\x8A\xA4\xC4\x5C\x80\xB8\xDC\xC1\x3A\x48\x86\x58\xF0\xD6\x92\x95\x95\xD1\x67\xB8\x5A\x4A\x02\xFC\x44\xC4\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", 9, 9)
}

render.edge_v = function (x, y, length, col)
	col = col or colors.accent
	render.texture(textures.corner_v, x, y + 4, 6, -4, col, "f")
	render.rectangle(x, y + 4, 2, length - 8, col)
	render.texture(textures.corner_v, x, y + length - 4, 6, 4, col, "f")
end
render.edge_h = function (x, y, length, col)
	col = col or colors.accent
	render.texture(textures.corner_h, x, y, 4, 6, col, "f")
	render.rectangle(x + 4, y, length - 8, 2, col)
	render.texture(textures.corner_h, x + length, y, -4, 6, col, "f")
end

render.rounded_side_v = function (x, y, w, h, c, n)
	x, y, w, h, n = x * DPI, y * DPI, w * DPI, h * DPI, (n or 0) * DPI
	local r, g, b, a = c.r, c.g, c.b, c.a * render.get_alpha()

	renderer.circle(x + n, y + n, r, g, b, a, n, 180, 0.25)
	renderer.rectangle(x + n, y, w - n, n, r, g, b, a)
	renderer.rectangle(x, y + n, w, h - n - n, r, g, b, a)
	renderer.circle(x + n, y + h - n, r, g, b, a, n, 270, 0.25)
	renderer.rectangle(x + n, y + h - n, w - n, n, r, g, b, a)
end

render.rounded_side_h = function (x, y, w, h, c, n)
	x, y, w, h, n = x * DPI, y * DPI, w * DPI, h * DPI, (n or 0) * DPI
	local r, g, b, a = c.r, c.g, c.b, c.a * render.get_alpha()

	renderer.circle(x + n, y + n, r, g, b, a, n, 180, 0.25)
	renderer.rectangle(x + n, y, w - n - n, n, r, g, b, a)
	renderer.circle(x + w - n, y + n, r, g, b, a, n, 90, 0.25)
	renderer.rectangle(x, y + n, w, h - n, r, g, b, a)
end

--#region: anima
math.clamp = function (x, a, b) if a > x then return a elseif b < x then return b else return x end end


local mouse = { x = 0, y = 0 } do
	local unlock_cursor = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 66, "void(__thiscall*)(void*)")
	local lock_cursor = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 67, "void(__thiscall*)(void*)")

	mouse.lock = function (bool)
		if bool then lock_cursor() else unlock_cursor() end
	end

	mouse.in_bounds = function (x, y, w, h)
		return (mouse.x >= x and mouse.y >= y) and (mouse.x <= (x + w) and mouse.y <= (y + h))
	end

	mouse.pressed = function (key)
		return client.key_state(key or 1)
	end

	callbacks.pre_render:set(function ()
		mouse.x, mouse.y = ui.mouse_position()
		mouse.x, mouse.y = mouse.x / DPI, mouse.y / DPI
	end)
end

local anima do
	local mt, animators = {}, setmetatable({}, {__mode = "kv"})
	local frametime, g_speed = globals.absoluteframetime(), 1

	--


	anima = {
		pulse = 0,

		easings = {
			pow = {
				function (x, p) return 1 - ((1 - x) ^ (p or 3)) end,
				function (x, p) return x ^ (p or 3) end,
				function (x, p) return x < 0.5 and 4 * math.pow(x, p or 3) or 1 - math.pow(-2 * x + 2, p or 3) * 0.5 end,
			}
		},

		lerp = a(function (a, b, s, t)
			local c = a + (b - a) * frametime * (s or 8) * g_speed
			return math.abs(b - c) < (t or .005) and b or c
		end),

		condition = a(function (id, c, s, e)
			local ctx = id[1] and id or animators[id]
			if not ctx then animators[id] = { c and 1 or 0, c }; ctx = animators[id] end

			s = s or 4
			local cur_s = s
			if type(s) == "table" then cur_s = c and s[1] or s[2] end

			ctx[1] = math.clamp(ctx[1] + ( frametime * math.abs(cur_s) * g_speed * (c and 1 or -1) ), 0, 1)

			return (ctx[1] % 1 == 0 or cur_s < 0) and ctx[1] or
			anima.easings.pow[e and (c and e[1][1] or e[2][1]) or (c and 1 or 3)](ctx[1], e and (c and e[1][2] or e[2][2]) or 3)
		end)
	}

	--

	mt = {
		__call = anima.condition
	}

	--
	callbacks.paint_ui:set(function ()
		anima.pulse = math.abs(globals.realtime() * 1 % 2 - 1)
		frametime = globals.absoluteframetime()
	end)
end

--#endregion

local menu = {}

callbacks.paint_ui:set(function ()
	menu.x, menu.y = ui.menu_position()
	menu.w, menu.h = ui.menu_size()
end)

local drag do
	local current

	local in_bounds = a(function (x, y, xa, ya, xb, yb)
		return (x >= xa and y >= ya) and (x <= xb and y <= yb)
	end)

	--
	local progress = { menu = {0}, bg = {0}, }

	callbacks.paint_ui:set(function ()
		local p1 = anima.condition(progress.bg, current ~= nil, 2)
		if p1 == 0 then return end

		render.push_alpha(p1)
		-- render.blur(0, 0, sw, sh, p1)
		render.rectangle(0, 0, sw, sh, colors.panel.l1)
		-- render.text(fonts.regular, vector(screen.x - 24, screen.y - 40), colors.text, "r", "Hold Shift to drag elements vertically or horizontally.\nHold Ctrl to disable grid aligning.")
		render.pop_alpha()
	end)

	--
	local process = a(function (self)
		local ctx = self.__drag
		if ctx.locked or not pui.menu_open then return end

		local held = mouse.pressed()
		local hovered = mouse.in_bounds(self.x, self.y, self.w, self.h) and not mouse.in_bounds(menu.x, menu.y, menu.w, menu.h)

		--
		if held and ctx.ready == nil then
			ctx.ready = hovered
			ctx.ix, ctx.iy = self.x, self.y
			ctx.px, ctx.py = self.x - mouse.x, self.y - mouse.y
		end

		if held and ctx.ready then
			if current == nil and ctx.on_held then ctx.on_held(self, ctx) end
			current = (ctx.ready and current == nil) and self.id or current
			ctx.active = current == self.id
		elseif not held then
			if ctx.active and ctx.on_release then ctx.on_release(self, ctx) end
			ctx.active = false
			current, ctx.ready, ctx.aligning, ctx.px, ctx.py, ctx.ix, ctx.iy = nil, nil, nil, nil, nil, nil, nil
		end

		ctx.hovered = hovered or ctx.active

		--
		local prefer = { nil, nil }

		local dx, dy, dw, dh = self.x * DPI, self.y * DPI, self.w * DPI, self.h * DPI
		local wx, wy = ctx.px and (ctx.px + mouse.x) * DPI or dx, ctx.py and (ctx.py + mouse.y) * DPI or dy
		local cx, cy = dx + dw * .5, dy + dh * .5

		--

		local p1 = anima.condition(ctx.progress[1], ctx.hovered, 4)
		local p2 = anima.condition(ctx.progress[2], ctx.active, 4)

		render.rectangle(self.x - 3, self.y - 3, self.w + 6, self.h + 6, colors.white:alphen(12 + 24 * p1), 6)

		render.push_alpha(p2)

		if not client.key_state(0xA2) then
			local wcx, wcy = (wx + dw * .5) / DPI, (wy + dh * .5) / DPI
			for i, v in ipairs(ctx.rulers) do
				local spx, spy = v[2] / DPI, v[3] / DPI

				local dist = math.abs(v[1] and wcx - spx or wcy - spy)
				local allowed = dist < (10 * DPI)

				local pxy = v[1] and 1 or 2
				if not prefer[pxy] then
					prefer[pxy] = allowed and (v[1] and spx - self.w * .5 or spy - self.h * .5) or nil
				end

				v.p = v.p or {0}

				local adist = math.abs(v[1] and cx - spx or cy - spy)
				local pp = anima.condition(v.p, allowed or adist < (10 * DPI), -8) * .35 + 0.1
				render.rectangle(spx, spy, v[1] and 1 or v[4], v[1] and v[4] or 1, colors.white:alphen(pp, true))
			end
			if ctx.border[5] then
				local xa, ya, xb, yb = ctx.border[1], ctx.border[2], ctx.border[3], ctx.border[4]

				local inside = in_bounds(self.x, self.y, xa, ya, xb - self.w * .5 - 1, yb - self.h * .5 - 1)
				local p3 = anima.condition(ctx.progress[3], not inside)
				render.rect_outline(xa, ya, xb - xa, yb - ya, colors.white:alphen(p3 * .75 + .25, true), 4)
			end
		end

		render.pop_alpha()

		--
		if ctx.active then
			local fx, fy = prefer[1] or wx / DPI, prefer[2] or wy / DPI

			--
			local min_x, min_y = (ctx.border[1] - dw * .5) / DPI, (ctx.border[2] - dh * .5) / DPI
			local max_x, max_y = (ctx.border[3] - dw * .5) / DPI, (ctx.border[4] - dh * .5) / DPI

			local x, y = math.clamp(fx, math.max(min_x, 0), math.min(max_x, sw - self.w)), math.clamp(fy, math.max(min_y, 0), math.min(max_y, sh - self.h))
			self:set_position(x, y)

			if ctx.on_active then ctx.on_active(self, ctx, fin) end
		end
	end)


	--
	drag = {
		new = a(function (widget, props)
			vars.drag[widget.id] = {
				x = pui.slider("MISC", "Settings", widget.id ..":x", 0, 10000, (widget.x / sw) * 10000),
				y = pui.slider("MISC", "Settings", widget.id ..":y", 0, 10000, (widget.y / sh) * 10000),
			}

			vars.drag[widget.id].x:set_visible(false)
			vars.drag[widget.id].y:set_visible(false)
			vars.drag[widget.id].x:set_callback(function (this) widget.x = math.round(this.value * .0001 * sw) end, true)
			vars.drag[widget.id].y:set_callback(function (this) widget.y = math.round(this.value * .0001 * sh) end, true)

			--
			props = type(props) == "table" and props or {}

			widget.__drag = {
				locked = false, active = false, hovered = nil, aligning = nil,
				progress = {{0}, {0}, {0}},

				ix, iy = widget.x, widget.y,
				px, py = nil, nil,

				border = props.border or {0, 0, asw, ash},
				rulers = props.rulers or {},

				on_release = props.on_release, on_held = props.on_held, on_active = props.on_active,

				config = vars.drag[widget.id],
				work = process,
			}

			--
			callbacks["emberlash::render_dpi"]:set(function (new)
				vars.drag[widget.id].x:set(vars.drag[widget.id].x.value)
				vars.drag[widget.id].y:set(vars.drag[widget.id].y.value)
			end)

			callbacks.setup_command:set(function (cmd)
				if pui.menu_open and (widget.__drag.hovered or widget.__drag.active) then cmd.in_attack = 0 end
			end)
		end)
	}
end



local widget do
	local mt; mt = {
		update = function (self) return 1 end,
		paint = function (self, x, y, w, h) end,

		set_position = function (self, x, y)
			if self.__drag then
				if x then
					self.__drag.config.x:set( x / sw * 10000 )
					self.x = x
				end
				if y then
					self.__drag.config.y:set( y / sh * 10000 )
					self.y = y
				end
			else
				self.x, self.y = x or self.x, y or self.y
			end
		end,
		get_position = function (self)
			local ctx = self.__drag and self.__drag.config
			if not ctx then return self.x, self.y end

			return ctx.x.value * .0001 * sw, ctx.y.value * .0001 * sh
		end,

		__call = a(function (self)
			local __list, __drag = self.__list, self.__drag
			if __list then
				__list.items, __list.active = __list.collect(), 0
				for i = 1, #__list.items do
					if __list.items[i].active then __list.active = __list.active + 1 end
				end
			end
			self.alpha = self:update()

			render.push_alpha(self.alpha)

			if self.alpha > 0 then
				if __drag then __drag.work(self) end
				if __list then mt.traverse(self) end
				self:paint(self.x, self.y, self.w, self.h)
			end

			render.pop_alpha()
		end),

		enlist = function (self, collector, painter)
			self.__list = {
				items = {}, progress = setmetatable({}, { __mode = "k" }),
				longest = 0, active = 0, minwidth = self.w,
				collect = collector, paint = painter,
			}
		end,
		traverse = function (self)
			local ctx, offset = self.__list, 0
			local lx, ly = 0, 0
			ctx.active, ctx.longest = 0, 0

			for i = 1, #ctx.items do
				local v = ctx.items[i]
				local id = v.name or i
				ctx.progress[id] = ctx.progress[id] or {0}
				local p = anima.condition(ctx.progress[id], v.active)

				if p > 0 then
					render.push_alpha(p)
					lx, ly = ctx.paint(self, v, offset, p)
					render.pop_alpha()

					ctx.active, offset = ctx.active + 1, offset + (ly * p)
					ctx.longest = math.max(ctx.longest, lx)
				end
			end

			self.w = anima.lerp(self.w, math.max(ctx.longest, ctx.minwidth), 10, .5)
		end,

		lock = function (self, b)
			if not self.__drag then return end
			self.__drag.locked = b and true or false
		end,
	}	mt.__index = mt


	widget = {
		new = function (id, x, y, w, h, draggable)
			local self = {
				id = id, type = 0,
				x = x or 0, y = y or 0, w = w or 0, h = h or 0,
				alpha = 0, progress = {0}
			}

			if draggable then drag.new(self, draggable) end

			return setmetatable(self, mt)
		end,
	}
end




local printc do
	local native_print = vtable_bind("vstdlib.dll", "VEngineCvar007", 25, "void(__cdecl*)(void*, const void*, const char*, ...)")

	printc = function (...)
		for i, v in ipairs{...} do
			local r = "\aD9D9D9" .. string.gsub(tostring(v), "[\r\v]", {["\r"] = "\aD9D9D9", ["\v"] = "\a".. (colors.hex:sub(1, 7))})
			for col, text in r:gmatch("\a(%x%x%x%x%x%x)([^\a]*)") do
				native_print(color.hex(col), text)
			end
		end
		native_print(color.rgb(217, 217, 217), "\n")
	end
end

emberlash.print = function (...)
	printc("\vemberlash\r ", ...)
end

local logger = {
	data = {
		fear = 0,
	},
	list = {},
	stack = {},
	generic_weapons = {"knife", "c4", "decoy", "flashbang", "hegrenade", "incgrenade", "molotov", "inferno", "smokegrenade"},
	colors = {
		["fear"]		= {"\a000000", "\a000000\x01", "\x01", color.hex("000000")},
		["mismatch"]	= {"\aD59A4D", "\aD59A4D\x01", "\x07", color.hex("D59A4D")},
		["hit"]			= {"\aA3D350", "\aA3D350\x01", "\x06", color.hex("A3D350")},
		["miss"]		= {"\aA67CCF", "\aA67CCF\x01", "\x03", color.hex("A67CCF")},
		["harm"]		= {"\ad35050", "\ad35050\x01", "\x07", color.hex("d35050")},
		["brute"]		= {"\aBFBFBF", "\aBFBFBF\x01", "\x01", color.hex("BFBFBF")},
		["evaded"]		= {"\aB0C6FF", "\aB0C6FF\x01", "\x01", color.hex("AB0C6F")},
	},
}

--#region: events

math.round = function (v)  return math.floor(v + 0.5)  end

local enums = {
	hitgroups = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'},
}

logger.events = {
	fear = function (chance, delay)
		if math.random() < chance and globals.realtime() - logger.data.fear > 240 then
			client.delay_call(delay or 7, function ()
				logger.invent("fear", {
					{"You are ", {"afraid"}},
				})
			end)
			logger.data.fear = globals.realtime()
		end
	end,
	evade = function (event)
		if event.damaged then return end

		logger.invent("evaded", {
			{"Evaded ", {entity.get_player_name(event.attacker)}, "'s shot"}
		}, {
			{"d: ", {math.round(event.dist)}}
		})
	end,

	--
	receive = function (event, target, attacker)
		local self_harm, is_fatal = target == attacker or attacker == 0, event.health == 0
		local weapon, damage, hitbox = event.weapon, event.dmg_health, enums.hitgroups[(event.hitgroup or 0) + 1] or "generic"
		local result = is_fatal and "Killed by" or "Harmed by"

		attacker = attacker ~= 0 and entity.get_player_name(attacker) or "world"

		local main = {
			self_harm and {{"You"}, is_fatal and " killed " or " harmed "} or {result, " "},
			{true, self_harm and {"yourself"} or {attacker}},
			{false, self_harm and {"yourself"} or {attacker}},

			(not self_harm and hitbox ~= "generic") and {" in ", {hitbox}} or nil,
			-- #weapon > 0 and {" with ", {weapon}} or nil,
			not is_fatal and {" for ", {damage, " hp"}} or nil
		}

		logger.invent("harm", main)
		if not is_fatal then
			logger.events.fear(0.03, 9)
		end
	end,
	harm = function (event, target, attacker)
		if not b_3.b_5(logger.generic_weapons, event.weapon) and event.weapon ~= "knife" then return end
		local is_fatal = event.health == 0

		local weapon = "a ".. event.weapon
		if event.weapon == "hegrenade" then  weapon = "an HE grenade"  end

		local name = entity.get_player_name(target)

		local result = is_fatal and "Killed" or "Harmed"
		if is_fatal and event.weapon == "hegrenade" then  result = "Exploded"
		elseif is_fatal and event.weapon == "knife" then  result = "Stabbed"
		elseif event.weapon == "inferno" then  result = "Burnt"  end

		local main = {
			{result, " "},
			{true, {name}},
			{false, {name}},
			not is_fatal and {" for ", {event.dmg_health, " hp"}} or nil,
			is_fatal and result == "Burnt" and {" to ", {"death"}} or nil,
			(result == "Killed" or result == "Harmed") and {true, " with ", {weapon}} or nil
		}

		logger.invent("hit", main)
	end,
	damage = function (event)
		local target, attacker = client.userid_to_entindex(event.userid), event.attacker ~= 0 and client.userid_to_entindex(event.attacker) or 0

		if target == entity.get_local_player() and b_2.settings.logs.enable:get() then
			logger.events.receive(event, target, attacker)
		elseif attacker == entity.get_local_player() and target ~= entity.get_local_player() and b_2.settings.logs.enable:get() then
			logger.events.harm(event, target, attacker)
		end
	end,

	--
	miss = function (shot)
		if not b_2.settings.logs.enable:get() then return end
		local pre = logger.stack[shot.id] or {}
		--

		local result = "Missed"
		local target = entity.get_player_name(shot.target)

		local reason = shot.reason

		local hitgroup = enums.hitgroups[shot.hitgroup + 1]

		--
		local main, add = {
			{result, " "},
			{true, {target}},
			{false, {target}},
			hitgroup and {"'s ", {hitgroup}},
			reason ~= "?" and {" due to ", {reason}} or nil
		}, {
			pre.damage and {"dmg: ", {pre.damage}},
			{"hc: ", {math.round(shot.hit_chance), "%%"}, (s_2.s_0.hit_chance.value - shot.hit_chance > 3) and "⮟" or ""} or nil,
			pre.difference and pre.difference ~= 0 and {"Δ: ", {pre.difference, "t"}, pre.difference < 0 and "⮟" or ""} or nil,
			pre.teleport and { {"LC"} } or nil,
			(pre.interpolated or pre.extrapolated) and { {pre.interpolated and "IN" or "", pre.extrapolated and "EP" or ""} } or nil,
		}

		logger.invent("miss", main, add)
		logger.stack[shot.id] = nil
	end,
	hit = function (shot)
		if not b_2.settings.logs.enable:get() then return end
		local pre = logger.stack[shot.id] or {}
		--

		local result = "Hit"
		if not entity.is_alive(shot.target) then
			result = "Killed"
		end

		local target = entity.get_player_name(shot.target)
		local hitgroup, exp_hitgroup = enums.hitgroups[shot.hitgroup + 1], enums.hitgroups[(pre.hitgroup or 0) + 1]

		local dmg_mismatch, hg_mismatch = result == "Hit" and shot.hitgroup ~= pre.hitgroup, result == "Hit" and (pre.damage or 0) - (shot.damage or 0) > 10
		-- dmg_mismatch, hg_mismatch = true, true

		local expected if dmg_mismatch and hg_mismatch and exp_hitgroup then
			expected = {exp_hitgroup, "-", pre.damage}
		elseif dmg_mismatch then expected = {pre.damage, " hp"} end

		--
		local main, add = {
			{result, " ", {target}},
			(hitgroup and hitgroup ~= "generic") and { result == "Hit" and "'s " or " in ", {hitgroup}, hg_mismatch and "\aD59A4D!\r" or "" } or nil,
			result == "Hit" and {" for ", {shot.damage, " hp"}, dmg_mismatch and "\aD59A4D!\r" or "" } or nil
		}, {
			expected and {"exp: ", expected},
			pre.difference ~= 0 and {"Δ: ", {pre.difference, "t"}} or nil,
			(s_2.s_0.hit_chance.value - shot.hit_chance > 5) and {"hc: ", {math.floor(shot.hit_chance), "%%"}, "⮟"} or nil,
		}

		--
		logger.invent("hit", main, add)
		logger.stack[shot.id] = nil
	end,
	aim = function (shot)
		shot.difference = globals.tickcount() - shot.tick
		logger.stack[shot.id] = shot
	end,
}

--#endregion

--#region: main

logger.invent = function (event, main, add)
	local log = { console = {}, screen = {}, chat = {} }

	if event then
		local lc, ls = 0, 0
		local col = logger.colors[event]
		log.console[lc+1], log.console[lc+2] = col and col[1] or "", "•\r "
		log.screen[ls+1], log.screen[ls+2] = col and col[2] or "", "•\aE6E6E6\x02 "
	end

	for i = 1, table.maxn(main) do
		local item = main[i]
		if not item then goto continue end

		if type(item) == "table" then
			local exclude = (main[i][1] == true and 1) or (main[i][1] == false and 2) or 0;
			for j, v in ipairs(item) do
				local kind = type(v)

				if not ( kind == "boolean" and j == 1 ) then
					if exclude ~= 2 then
						if kind == "table" then
							table.move(v, 1, #v, #log.console + 1, log.console)
							table.move(v, 1, #v, #log.chat + 1, log.chat)
						else
							local lc, lh = #log.console, #log.chat
							log.console[lc+1], log.console[lc+2], log.console[lc+3] = "\a909090", kind == "string" and v or tostring(v), "\r"
							log.chat[lh+1], log.chat[lh+2], log.chat[lh+3] = "\x08", kind == "string" and string.gsub(v, "\a%x%x%x%x%x%x", "") or tostring(v), "\x01"
						end
					end
					if exclude ~= 1 then
						if kind == "table" then
							local ls = #log.screen
							for ii = 1, #v, 3 do
								log.screen[ls+ii], log.screen[ls+ii+1], log.screen[ls+ii+2] = "\aE6E6E6\x01", v[ii], "\aE6E6E6\x02"
							end
						else
							local ls = #log.screen
							log.screen[ls+1], log.screen[ls+2] = kind == "string" and string.gsub(v, "\a%x%x%x%x%x%x", function (raw)
								return raw .. "\x01"
							end) or tostring(v), "\aE6E6E6\x02"
						end
					end
				end
			end
		else
			local lc = #log.console
			log.console[lc+1], log.console[lc+2], log.console[lc+3] = "\a808080", tostring(item), "\r"

			log.screen[#log.screen+1] = type(item) == "string" and string.gsub(item, "\a%x%x%x%x%x%x", function (raw)
				return raw .. "\x02"
			end) or tostring(item)
		end

		::continue::
	end

	add = type(add) == "table" and b_3.b_6(add) or nil
	if add and #add > 0 then
		log.console[#log.console+1] = "  \v~\r  "

		for i = 1, #add do
			if type(add[i]) == "table" then
				for _, v in ipairs(add[i]) do
					local kind = type(v)
					if kind == "table" then
						log.console[#log.console+1] = "\aAAAAAA"
						table.move(v, 1, #v, #log.console + 1, log.console)
					else
						local l = #log.console
						log.console[l+1], log.console[l+2] = "\a707070", kind == "string" and v or tostring(v)
					end
					log.console[#log.console+1] = "\r"
				end
			else
				local lc = #log.console
				log.console[lc+1], log.console[lc+2], log.console[lc+3] = "\a707070", tostring(main[i]), "\r"
			end
			if i < #add then  log.console[#log.console+1] = "\a707070, \r"  end
		end
	end

	logger.push(event, table.concat(log.console), table.concat(log.screen), table.concat(log.chat))
end

logger.push = function (event, console, screen, chat)
	if console and b_2.settings.logs.style:get("Console") then
		emberlash.print(console)
	end
	if screen and b_2.settings.logs.style:get("On-Screen") then
		table.insert(logger.list, 1, {
			event = event, text = screen,
			time = globals.realtime(), progress = {0},
		})
	end
end

logger.clear_stack = function () logger.stack = {} end

local ternary = function (c, a, b)  if c then return a else return b end  end

logger.run = function (self)
	b_2.settings.logs.enable:set_callback(function (this)
		callbacks.aim_fire(this.value, self.events.aim)
		callbacks.aim_hit(this.value, self.events.hit)
		callbacks.aim_miss(this.value, self.events.miss)
		callbacks.player_hurt(this.value, self.events.damage)
		callbacks.me_spawned(this.value, self.clear_stack)
		callbacks["emberlash::enemy_shot"](this.value, self.events.evade)

		local switch = ternary(this.value, false, nil)
	end, true)

end

--

logger:run()

-- #region - Logs

local hud = {}



hud.logs = widget.new("logs", sc.x - 150, sc.y + 160, 300, 90, {
	rulers = {
		{ true, asc.x, 0, ash },
	}
})

hud.logs.preview, hud.logs.dummy = false, {
	{
		event = "hit",
		text = "\aA3D350\x01•\aE6E6E6\x02 Killed\aE6E6E6\x02 \aE6E6E6\x02\aE6E6E6\x01pawrot\aE6E6E6\x02 in \aE6E6E6\x02\aE6E6E6\x01head\aE6E6E6\x02\aE6E6E6\x02",
		time = math.huge,
		progress = {0},
	},
	{
		event = "miss",
		text = "\aA67CCF\x01•\aE6E6E6\x02 Missed\aE6E6E6\x02 \aE6E6E6\x01pawrot\aE6E6E6\x02's\aE6E6E6\x01 head\aE6E6E6\x02 due to \aE6E6E6\x01unpredicted occasion",
		time = math.huge,
		progress = {0},
	},
	{
		event = "harm",
		text = "\ad35050\x01•\aE6E6E6\x02 Harmed by\aE6E6E6\x02 \aE6E6E6\x01pawrot\aE6E6E6\x02 in \aE6E6E6\x01head\aE6E6E6\x02 for \aE6E6E6\x0172",
		time = math.huge,
		progress = {0},
	},
}

hud.logs.update = function (self)
	return anima.condition(self.progress, b_2.settings.logs.enable.value and b_2.settings.logs.style:get("On-Screen"))
end

hud.logs.part = function (self, log, offset, progress, condition, i)
	local text = string.gsub(log.text, "[\x01\x02]", {
		["\x01"] = string.format("%02x", progress * render.get_alpha() * 255),
		["\x02"] = string.format("%02x", progress * render.get_alpha() * 128),
	})

	local tw, th = render.measure_text("", text)

	local x, y = lerp(self.x + self.w * 0.5 - tw * 0.5 - 18, self.x, self.align), offset
	if not condition then
		x = x + (1 - progress) * (tw * 0.5) * (i % 2 == 0 and -1 or 1)
	end

	render.blur(x, y, 24, 24)

	render.blur(x + 15, y + 1, tw + 14, 22)
	render.rectangle(x + 12, y + 1, tw + 14, 22, colors.panel.l1, 4)

	render.text(x + 19, y + 5, colors.text:alphen(128), nil, nil, text)
end

hud.logs.paint = function (self, x, y, w, h)
	if not b_2.settings.logs.enable.value then return end
	local continue
	self.align = anima.condition("hud::logs.align", self.x < sw / 3)
	self.preview = anima.condition("hud::logs.preview", pui.menu_open and b_2.settings.logs.style:get("On-Screen") and #logger.list == 0)
	y = y + 4

	local ctx = self.preview > 0 and self.dummy or logger.list
	for i = 1, #ctx do
		local v = ctx[i]
		local ascend = (globals.realtime() - v.time) < 4 and i < 10

		local progress = anima.condition(v.progress, ternary(self.preview > 0, self.preview == 1, ascend))
		if progress == 0 then continue = i end

		render.push_alpha(progress)
		self:part(v, y, progress, ascend, i)
		render.pop_alpha()

		y = y + 28 * (ascend and progress or 1)
	end

	if continue then
		table.remove(logger.list, continue)
	end
end

--#region :: Watermark

hud.watermark = widget.new("watermark", sw - 24, 24, 160, 24, {
	rulers = {
		{ true, asc.x, 0, ash },
		{ false, 0, ash - 32, asw },
		{ false, 0, 32, asw },
	},
	on_release = function (self, ctx)
		local partition = sw / 3
		local pos = self.x + self.w * .5

		local align = math.floor(pos / partition)
		if align == self.align then return end
		self.align = align

		if self.align == 1 then
			self:set_position(pos)
			self.x = self.x - self.w * .5
		elseif self.align == 2 then
			self:set_position(self.x + self.w)
			self.x = self.x - self.w
		end

		ctx.config.a:set(align)
	end,
	on_held = function (self, ctx)
		self.align = 0
		ctx.config.a:set(0)
	end,
})

hud.watermark.align, hud.watermark.logop, hud.watermark.logo = 2, {0}, 0
hud.watermark.__drag.config.a = pui.slider("MISC", "Settings", "watermark:align", 0, 2, hud.watermark.align)
hud.watermark.__drag.config.a:set_visible(false)
hud.watermark.__drag.config.a:set_callback(function (this)
	hud.watermark.align = this.value
end, true)

hud.watermark.items = {
	{
		0, function (self, x, y)
			local cname = A_1.A_1
			local t = string.format(A_1.A_3 == "DEBUG" and "%s" or "%s %s%02x— %s",
				cname ~= "" and cname or A_1.A_2, colors.hexs, render.get_alpha() * self[1] * 255, A_1.A_3)
			local tw, th = render.measure_text("", t)

			if self[1] > 0 then
				render.blur(x, y + 1, tw + 16, 22, 1, 8)
				render.rectangle(x, y + 1, tw + 16, 22, colors.panel.l1, 4)
				render.text(x + 8, y + 6, colors.text, nil, nil, t)
			end

			return true, tw + 16
		end, {}
	},
	{
		0, function (self, x, y)
			local hours, minutes = client.system_time()
			local text = string.format("%02d:%02d", hours, minutes)
			local tw, th = render.measure_text("", text)

			if self[1] > 0 then
				render.blur(x, y + 1, tw + 16, 22, 1, 8)
				render.rectangle(x, y + 1, tw + 16, 22, colors.panel.l1, 4)
				render.text(x + 8, y + 6, colors.text, nil, nil, text)
			end

			return true, tw + 16
		end, {}
	},
	{
		0, function (self, x, y)
			local ping = client.latency() * 1000
			local text = string.format("%dms", ping)
			local tw, th = render.measure_text("", text)

			if self[1] > 0 then
				render.blur(x, y + 1, tw + 16, 22, 1, 8)
				render.rectangle(x, y + 1, tw + 16, 22, colors.panel.l1, 4)
				render.text(x + 8, y + 6, colors.text, nil, nil, text)
			end

			return ping > 5, tw + 16
		end, {}
	},
}

hud.watermark.enumerate = function (self)
	local total = self.logo * (( 86 or 64) + 4)
	for i, v in ipairs(self.items) do
		render.push_alpha(v[1])
		local state, length = v[2](v, self.x + total, self.y)
		render.pop_alpha()

		v[1] = anima.condition(v[3], state)

		total = total + (length + 2) * v[1]
	end
	self.w = anima.lerp(self.w, total, nil, .5)
end

hud.watermark.update = function (self)
	local cx, cy = self:get_position()

	if self.align == 2 then
		self.x = cx - self.w * self.alpha
	elseif self.align == 1 then
		self.x = cx - self.w * .5
	end

	return anima.condition(self.progress, b_2.settings.watermark.value, 3)
end

hud.watermark.paint = function (self, x, y, w, h)
	self.logo = anima.condition(self.logop)

	if self.logo > 0 then
		local wl =  86 or 64
		render.push_alpha(self.logo)
		render.blur(x, y, wl, h, 1, 8)
		render.rounded_side_v(x, y, wl, h, colors.panel.g1, 4)
		render.rectangle(x + wl, y, 2, h, colors.panel.g1)
		render.logo(x + 8, y + 5)
		render.edge_v(x + wl, y, 24)
		render.pop_alpha()
	end

	self:enumerate()
end


--#endregion


do
    local fn = a(function ()
        if (b_2.settings.logs.enable.value and b_2.settings.logs.style:get("On-Screen")) or hud.logs.alpha > 0 then
            hud.logs()
        end

        if b_2.settings.watermark:get() then
            hud.watermark()
        end
    end)

    callbacks.paint_ui:set(fn)
end

-- #endregion


--#region :: Rage

local varsrage = {
    dt_charged = false,
}

local function rage(cmd)
    local lp = entity.get_local_player()
    if not lp then return end
    if b_2.rage.expdt:get() then
        local tickbase = entity.get_prop(lp, "m_nTickBase") - globals.tickcount()
        local doubletap_ref = ui.get(s_2.s_0.dt[1]) and ui.get(s_2.s_0.dt[2]) and not ui.get(s_2.s_0.fakeduck)
        local active_weapon = entity.get_prop(lp, "m_hActiveWeapon")
        if active_weapon == nil then return end
        local weapon_idx = entity.get_prop(active_weapon, "m_iItemDefinitionIndex")
        if weapon_idx == nil or weapon_idx == 64 then return end
        local LastShot = entity.get_prop(active_weapon, "m_fLastShotTime")
        if LastShot == nil then return end
        local single_fire_weapon = weapon_idx == 40 or weapon_idx == 9 or weapon_idx == 64 or weapon_idx == 27 or weapon_idx == 29 or weapon_idx == 35
        local value = single_fire_weapon and 1.50 or 0.50
        local in_attack = globals.curtime() - LastShot <= value

        if tickbase > 0 and doubletap_ref then
            if in_attack then
                ui.set(s_2.s_0.rage_cb[2], "Always on")
            else
                ui.set(s_2.s_0.rage_cb[2], "On hotkey")
            end
        else
            ui.set(s_2.s_0.rage_cb[2], "Always on")
        end
    end
end

local ticks = 0

local function airstop(cmd)
    local lp = entity.get_local_player()
    if not lp then return end
    
    if b_2.rage.airstop:get() then
        if b_2.rage.airstop.hotkey:get() then
            if cmd.quick_stop then
                if (globals.tickcount() - ticks) > 3 then
                    cmd.in_speed = 1
                end
            else
                ticks = globals.tickcount()
            end
        end
    end

end

client.set_event_callback("setup_command", function(cmd)
    if b_2.rage.airstop:get() then
        airstop(cmd)
    end

    if b_2.settings.selectfix:get("Leg Fucker") then
        ui.set(s_2.s_1.legmovement[1], cmd.command_number % 3 == 0 and "Off" or "Always slide")
    else
        ui.set(s_2.s_1.legmovement[1], "Off")
    end
end)

--#region :: GREMOARE

predict = function()
    local lp = entity.get_local_player()
    if not lp then return end
    local gun = entity.get_player_weapon(lp)
    local skeetweapon = ui.get(s_2.s_0.weapon_type)
    local weapon = b_2.rage.selectgun:get()
    local classname = entity.get_classname(gun)
    -- if not b_2.rage.predict:get() then return end
    if gun == nil then
        return
    end
    if b_2.rage.predict:get() and b_2.rage.hotexp:get() then
        if b_2.rage.pingpos:get() == "Low" then
            cvar.cl_interpolate:set_int(0)
            cvar.cl_interp_ratio:set_int(1)
            -- print(classname)

            if classname == "CWeaponSSG08" then
                if b_2.rage.slidescout:get() == "Disabled"  then
                    cvar.cl_interp:set_float(0.015625)
                end
                if b_2.rage.slidescout:get() == "Medium"  then
                    cvar.cl_interp:set_float(0.028000)
                end
                if b_2.rage.slidescout:get() == "Maximum"  then
                    cvar.cl_interp:set_float(0.029125)
                end
                if b_2.rage.slidescout:get() == "Extreme" then
                    cvar.cl_interp:set_float(0.031000)
                end
            end

            if classname == "CWeaponAWP" then
                if b_2.rage.slideawp:get() == "Disabled" then
                    cvar.cl_interp:set_float(0.015625)
                elseif b_2.rage.slideawp:get() == "Medium" then
                    cvar.cl_interp:set_float(0.028000)
                elseif b_2.rage.slideawp:get() == "Maximum"  then
                    cvar.cl_interp:set_float(0.029125)
                elseif b_2.rage.slideawp:get() == "Extreme"  then
                    cvar.cl_interp:set_float(0.031000)
                end
            end

            if classname == "CWeaponSCAR20" or  classname == "CWeaponG3SG1" then
                if b_2.rage.slideauto:get() == "Disabled" then
                    cvar.cl_interp:set_float(0.015625)
                elseif b_2.rage.slideauto:get() == "Medium" then
                    cvar.cl_interp:set_float(0.028000)
                elseif b_2.rage.slideauto:get() == "Maximum"  then
                    cvar.cl_interp:set_float(0.029125)
                elseif b_2.rage.slideauto:get() == "Extreme"  then
                    cvar.cl_interp:set_float(0.031000)
                end
            end

            if classname == "CDEagle" then
                if b_2.rage.slider8:get() == "Disabled" then
                    cvar.cl_interp:set_float(0.015625)
                elseif b_2.rage.slider8:get() == "Medium" then
                    cvar.cl_interp:set_float(0.028000)
                elseif b_2.rage.slider8:get() == "Maximum" then
                    cvar.cl_interp:set_float(0.029125)
                elseif b_2.rage.slider8:get() == "Extreme" then
                    cvar.cl_interp:set_float(0.031000)
                end
            end
        elseif b_2.rage.pingpos:get() == "High" then
            cvar.cl_interp:set_float(0.020000)
            cvar.cl_interp_ratio:set_int(0)
            cvar.cl_interpolate:set_int(0)
        end
    else
        cvar.cl_interp:set_float(0.015625)
        cvar.cl_interp_ratio:set_int(2)
        cvar.cl_interpolate:set_int(1)
    end
end
--#endregion


--#region filter :: Console(menu)

b_2.settings.filtercons:set_callback(function()
    if b_2.settings.filtercons:get() then
        cvar.developer:set_int(0)
        cvar.con_filter_enable:set_int(1)
        cvar.con_filter_text:set_string("IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN")
        client.exec("con_filter_enable 1")
    else
        cvar.con_filter_enable:set_int(0)
        cvar.con_filter_text:set_string("")
        client.exec("con_filter_enable 0")
    end
end)

--#endregion

--#region logs

lerp = function(start, vend, time)
    return start + (vend - start) * globals.frametime() * time
end

--#endregion logs

--#region :: Indicators

local scoped = 0
local a = 0

local RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
    return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
end

local animate_text = function(time, string, r, g, b, a)
    local t_out, t_out_iter = {}, 1

    local r_add = (0 - r)
    local g_add = (0 - g)
    local b_add = (0 - b)
    local a_add = (255 - a)

    for i = 1, #string do
        local iter = (i - 1)/(#string - 1) + time
        t_out[t_out_iter] = "\a" .. RGBAtoHEX(r + r_add * math.abs(math.cos(iter)), g + g_add * math.abs(math.cos(iter)), b + b_add * math.abs(math.cos(iter)), a + a_add * math.abs(math.cos(iter)))

        t_out[t_out_iter + 1] = string:sub(i, i)

        t_out_iter = t_out_iter + 2
    end

    return table.concat(t_out)
end

local function doubletap_charged()
    if not ui.get(s_2.s_0.dt[1]) or  not ui.get(s_2.s_0.dt[2]) or ui.get(s_2.s_0.fakeduck) then return false end
    if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then return end
    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if weapon == nil then return false end
    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.01
    local checkcheck = entity.get_prop(weapon, "m_flNextPrimaryAttack")
    if checkcheck == nil then return end
    local next_primary_attack = checkcheck + 0.01
    if next_attack == nil or next_primary_attack == nil then return false end
    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
end

-- < Center Ind >

local circle = 0.0
local a1 = 0
local a2 = 0
local dist = 0



local function indicators()
    local lp = entity.get_local_player()
    if not lp then return end
    local screen = vector(client.screen_size())
    local position = screen*0.5
    local scope = entity.get_prop(lp, "m_bIsScoped")
    local space = 20
    local r, g, b, a = b_2.settings.center:get_color()

    local exploit = {
        is_dt = ui.get(s_2.s_0.dt[1]) and ui.get(s_2.s_0.dt[2]),
        is_os = ui.get(s_2.s_1.onshotaa[1]) and ui.get(s_2.s_1.onshotaa[2]),
    }

    col1 = { r, g, b, a }
    col2 = { 255, 255, 255, a }

    local leftdir = desyncside() == -1 and col1 or col2
    local rightdir = desyncside() == 1 and col1 or col2

    if scope ~= 0 then
        scoped = lerp(scoped, 40, 10)
    else
        scoped = lerp(scoped, 0, 10)
    end

    if ui.get(s_2.s_0.dmg[2]) then
        a1 = lerp(a1, 255, 10)
    else
        a1 = lerp(a1,0, 10)
    end

    if ui.get(s_2.s_0.qp[2]) then
        a2 = lerp(a2, 255, 10)
    else
        a2 = lerp(a2, 0, 10)
    end

    if ui.get(s_2.s_0.dt[2]) and doubletap_charged() then
        dist = lerp(dist, 7, 10)
    else
        dist = lerp(dist, 0, 10)
    end
     
    local time = globals.realtime() * -2

    local state = "unknown"
    if id == 1 then
        state = "Global"
    elseif id == 2 then
        state = "stand"
    elseif id == 3 then
        state = "walk"
    elseif id == 4 then
        state = "run"
    elseif id == 5 then
        state = "air"
    elseif id == 6 then
        state = "airc"
    elseif id == 7 then
        state = "duck"
    elseif id == 8 then
        state = "duckm"
    elseif id == 9 then
        state = "Fakelag"
    end


    if b_2.settings.center:get() and b_2.settings.indicators:get() then
        renderer.text(position.x + scoped, position.y + space, r,g,b,a, "cb", 0, "emberlash")
        renderer.rectangle(position.x + scoped , position.y + space + 7, 30, 2, leftdir[1], leftdir[2], leftdir[3], leftdir[4])
        renderer.rectangle(position.x + scoped - 30, position.y + space + 7, 30, 2, rightdir[1], rightdir[2], rightdir[3], rightdir[4])
        renderer.gradient(position.x + scoped - 29, position.y + space + 7, 60, 13, 0, 0, 0, 30, 0, 0, 0, 30, false)
        space = space + 15

        renderer.text(position.x + scoped, position.y + space, 255, 255, 255, 255, "-c", 0, "/".. string.upper(state) .. "/")
        space = space + 8

        if doubletap_charged() then
            circle = lerp(circle, 1.0, 10)
        else
            circle = lerp(circle, 0.0, 10)
        end

        if ui.get(s_2.s_0.dt[2]) then
            renderer.circle_outline(position.x + scoped + 10, position.y + space, r, g, b, a,  3, 90 , circle, 1)
            if doubletap_charged() then
                renderer.text(position.x + scoped, position.y +space, 255, 255, 255, 255, "-c", 0, "DT")
            else
                renderer.text(position.x + scoped, position.y + space, 255, 75, 75, 255, "-c", 0, "DT")
            end
        else
            renderer.text(position.x + scoped, position.y + space, 200, 200, 200, 200, "-c", 0, "DT")
        end

        space = space + 8

        renderer.text(position.x + scoped -13, position.y + space, r, g, b, a1, "-c", 0, 'MD')

        renderer.text(position.x + scoped + 13, position.y + space, r, g,b, a2, "-c", 0, "QP")

        if b_2.aa.advanced.hideshots.hotkey:get() then
            renderer.text(position.x + scoped, position.y + space, r, g, b, 255, "-c", 0, "OS")
        else
            renderer.text(position.x + scoped, position.y + space, 200, 200, 200, 200, "-c", 0, "OS")
        end
    end
end

-- < MANUAL IND >

local a = 0
local function manual()
    local lp = entity.get_local_player()
    if not lp then return end
    local screen = vector(client.screen_size())
    local position = screen * 0.5
    local scope = entity.get_prop(lp, "m_bIsScoped")
    local r, g, b = b_2.settings.manual:get_color()
    if not b_2.settings.indicators:get() or not b_2.settings.manual:get() then return end
    act = { r, g, b, a }
    off = { 255, 255, 255, a }

    if scope ~= 0 then
        a = lerp(a, 0, 12)
    else
        a = lerp(a, 255, 12)
    end

    local gt_colright = manual_dir == 2 and act or off
    local gt_colleft = manual_dir == 1 and act or off

    if b_2.settings.manual:get() then
        renderer.text(position.x + 56, position.y - 2, gt_colright[1], gt_colright[2], gt_colright[3], gt_colright[4],'c', nil, '⮞' )
        renderer.text(position.x - 55, position.y - 2, gt_colleft[1], gt_colleft[2], gt_colleft[3], gt_colleft[4],'c', nil, '⮜' )
    end
end

local match = client.find_signature("client_panorama.dll", "\x8B\x35\xCC\xCC\xCC\xCC\xFF\x10\x0F\xB7\xC0")
local weaponsystem_raw = ffi.cast("void****", ffi.cast("char*", match) + 2)[0]

local ccsweaponinfo_t = [[
    struct {
        char         __pad_0x0000[0x1cd];                   // 0x0000
        bool         hide_vm_scope;                // 0x01d1
    }
]]


local get_weapon_info = vtable_thunk(2, ccsweaponinfo_t .. "*(__thiscall*)(void*, unsigned int)")

--#region :: Trash Talk

local chat_spammer = {}

chat_spammer.phrases = {
    kill = {
        {"БОМЖИК ЕБУ ТЯ НЕ ПУКАЙ"},
        {"СОСЕШЬ МНЕ КАК РАК В ТЕЛЯЧЬЮ ПОРУ ЛОЛИК(("},
        {"ТЫ ЧО КОНФИГ УЖЕ У ПОВРОТИКА КУПИТЬ НА ПРЕДИКТ НЕ МОЖЕШЬ", "САСАЛ?"},
        {"разбомбил тебе ебасосину как бомбят spacex"},
        {"ЧЕ замкдышь без emberlash в 2024?"},
        {"АЛо бомж да тебе даже sm_metan не поможет лол"},
        {"пока ты сосешь хуй мы чилим на острове genesisleague"},
        {"ХВАТИТь пукать говно тупое иди убейся нахуй", "иди зайди в мой лучший дискорд - clck.ru/3Bg3tw"},
        {"переиграна 12 летка ебучая"},
        {"лолик братанчик тебе сверхразуму только vs xoxain и играть"},
        {"че то ты мои грязные яички облизал сын ёбаной пизд"},
        {"сын шлюхи ты думал мой бигги джон-он by powrotic сравнится с твоей?"},
        {"ЛОЛ ИДИ РЯЛКА РОЗОВЫЕ ВИЗУАЛЫ купи фембойчик", "clck.ru/3Bg3tw"},
        {"тк ну и не открывай ротик", "хуесос", "лучше иди луашку мою купи clck.ru/3Bg3tw"},
        {"лол да даже пз тебя переиглает лолек","иди луашку (emberlash) прикупи"},
        {"лол ты че как танару веселый клоун++("},
        {"щас шаха нюхнет и пизда тебе твоим антипападаикам"},
        {"лол чел кринж ", "щас моя братва с Blãssēd залетит"},
        {"Убили?", "Значит переиграли"},
        {"мой emberlash отчинчанчонил тебя придурок"},
        {"говоришь чит миссает иди купи sm_metan #emberlash"},
        {"чо запредиктили тебя лошпед?", "иди вгетай гримуары повротика"},
        {"соси хуйца плакса жалкая", "че ты там вякаешь мой emberlash те в ротик надавал"},
        {"что что убище скаред все карты изи", "щас протапаю тебя как тапаю хамстеркоин", "лол убил купи emberlash"},
        {"рандерандерандеву твоя мать шлюха сосала наяву"},
    },

    death = {
        {"он же", "не понимает", "что ему повезло"},
    }
}

chat_spammer.phrase_count = {
    death = 0,
    kill = 0,
}

chat_spammer.handle = function(e)
    if not b_2.settings.talking then return end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local victim = client.userid_to_entindex(e.userid)

    if victim == nil then
        return
    end

    local attacker = client.userid_to_entindex(e.attacker)

    if attacker == nil then
        return
    end

    chat_spammer.phrase_count.death = chat_spammer.phrase_count.death + 1
    if chat_spammer.phrase_count.death > #chat_spammer.phrases.death then
        chat_spammer.phrase_count.death = 1
    end

    chat_spammer.phrase_count.kill = chat_spammer.phrase_count.kill + 1
    if chat_spammer.phrase_count.kill > #chat_spammer.phrases.kill then
        chat_spammer.phrase_count.kill = 1
    end

    local phrase = {
        death = chat_spammer.phrases.death[chat_spammer.phrase_count.death],
        kill = chat_spammer.phrases.kill[chat_spammer.phrase_count.kill],
    }

    if b_2.settings.talkingsel:get("Kill") then
        if attacker == player and victim ~= player then
            for i = 1, #phrase.kill do
                client.delay_call(i*2, function()
                    client.exec(("say %s"):format(phrase.kill[i]))
                end)
            end
        end
    end

    if b_2.settings.talkingsel:get("Death") then
        if attacker ~= player and victim == player then
            for i = 1, #phrase.death do
                client.delay_call(i*2, function()
                    client.exec(("say %s"):format(phrase.death[i]))
                end)
            end
        end
    end
end
--#region fastladder

local function fastladder(e)
    local local_player = entity.get_local_player()
    local pitch, yaw = client.camera_angles()
    if entity.get_prop(local_player, "m_MoveType") == 9 then
        e.yaw = math.floor(e.yaw+0.5)
        e.roll = 0
        if e.forwardmove == 0 then
            if e.sidemove ~= 0 then
                e.pitch = 89
                e.yaw = e.yaw + 180
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

--#endregion

--#region :: dependencies

local dependencies = {    
    {menu = b_2.home, depend = {{b_2.main.picker, "Home"}}},
    {menu = b_2.rage, depend = {{b_2.main.picker, "Settings"}}},
    {menu = b_2.rage.hotexp, depend = {{b_2.rage.predict, true}}},
    {menu = b_2.rage.pingpos, depend = {{b_2.rage.predict, true}}},
    {menu = b_2.rage.selectgun, depend = {{b_2.rage.predict, true}, {b_2.rage.pingpos, "Low"}}},
    {menu = b_2.rage.slideauto, depend = {{b_2.rage.selectgun, "AUTO"}, {b_2.rage.predict, true}, {b_2.rage.pingpos, "Low"}}},
    {menu = b_2.rage.slidescout, depend = {{b_2.rage.selectgun, "SCOUT"}, {b_2.rage.predict, true}, {b_2.rage.pingpos, "Low"}}},
    {menu = b_2.rage.slider8, depend = {{b_2.rage.selectgun, "R8"}, {b_2.rage.predict, true}, {b_2.rage.pingpos, "Low"}}},
    {menu = b_2.rage.slideawp, depend = {{b_2.rage.selectgun, "AWP"}, {b_2.rage.predict, true},{b_2.rage.pingpos, "Low"}}},
    {menu = b_2.aa, depend = {{b_2.main.picker, "Anti-Aim"}}},
    {menu = b_2.aa.main, depend = {{b_2.aa.aapick, "Builder"}}},
    {menu = b_2.aa.advanced, depend = {{b_2.aa.aapick, "Other"}}},
    {menu = b_2.aa.advanced.options, depend = {{b_2.aa.advanced.safehead, true}}},
    {menu = b_2.fakelag, depend = {{b_2.main.picker, "Anti-Aim"}, {b_2.aa.aapick, "Builder"}}},
    {menu = b_2.settings, depend = {{b_2.main.picker, "Settings"}}},
    {menu = b_2.settings.center, depend = {{b_2.settings.indicators, true}}},
    {menu = b_2.settings.manual, depend = {{b_2.settings.indicators, true}}},
    {menu = b_2.settings.selectfix, depend = {{b_2.settings.animfix, true}}},
    {menu = b_2.settings.talkingsel, depend = {{b_2.settings.talking, true}}},
    {menu = b_2.settings.logs.style, depend = {{b_2.settings.logs.enable, true}}}
}

for _, dep in ipairs(dependencies) do
    pui.traverse(dep.menu, function(ref, path)
        ref:depend(unpack(dep.depend))
    end)
end

client.set_event_callback("setup_command", function(cmd)
    aa_setup(cmd)
    if b_2.aa.advanced.fastladder:get() then
        fastladder(cmd)
    end
    rage(cmd)
    predict()
end)

client.set_event_callback('player_death', chat_spammer.handle)

client.set_event_callback("run_command", function(cmd)
    local w_id = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex")
    local res = get_weapon_info(weaponsystem_raw, w_id)
    res.hide_vm_scope = not b_2.settings.viewmodelscope:get()
end)

client.set_event_callback("paint", function()
    if not entity.is_alive(entity.get_local_player()) then return end
    local lp = entity.get_local_player()
    local scope = entity.get_prop(lp, "m_bIsScoped")
    indicators()
    manual()
    
    if b_2.rage.airstop:get() and b_2.rage.airstop.hotkey:get() then
        renderer.indicator(215,211,213,255, "AIR-QS")
    end
    
    if b_2.rage.predict:get() and b_2.rage.hotexp:get() then
        render.indicator(215,211,213,255, "☯")
    end
end)

client.set_event_callback("paint_ui", function()
    b_2.main.label:set(calculateGradient({127, 255, 212, 255}, {148, 127, 255, 255}, {255, 127, 170, 255}, {255, 76, 136, 255}, A_1.A_4, 2.5) .. "\r ~ Renewed")
    
    if (globals.mapname() ~= breaker.mapname) then
        breaker.cmd = 0
        breaker.defensive = 0
        breaker.defensive_check = 0
        breaker.mapname = globals.mapname()
    end
end)

client.set_event_callback("round_start", function()
    breaker.cmd = 0
    breaker.defensive = 0
    breaker.defensive_check = 0
end)


client.set_event_callback("player_connect_full", function(e)
    local ent = client.userid_to_entindex(e.userid)
    if ent == entity.get_local_player() then
        breaker.cmd = 0
        breaker.defensive = 0
        breaker.defensive_check = 0
    end
end)

---# < CONFIG  SYSTEM > 

local config_items = {b_2, builder}
local package, data, encrypted, decrypted = pui.setup(config_items), "", "", ""

configs.export = function()
    data = package:save()
    encrypted = base64.encode(json.stringify(data))
    clipboard.set(encrypted)
    client.exec("Play ".. "ambient/tones/elev1")
end

configs.import = function(input)
    decrypted = json.parse(base64.decode(input ~= nil and input or clipboard.get()))
    package:load(decrypted)
    client.exec("Play ".. "ambient/tones/elev1")
end
--#endregion