-- downloaded from dsc.gg/southwestcfgs

--[[
    \\\
    ///    welcome to my shitcode
    \\\    made for fun and bcuz i dont want to buy 20$+ shit luas
    ///    version: 1.0 (21.08.23)
    \\\
]]

-- [ reqs ]
local ffi = require("ffi")
local pui = require("gamesense/pui")
local base64 = require("gamesense/base64")
local vector = require("vector")

-- [ cool things ]
local ref = {
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

function get_velocity()
    if not entity.get_local_player() then return end
    local first_velocity, second_velocity = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))
    
    return speed
end

local ground_tick = 1
function get_state(speed)
    if not entity.is_alive(entity.get_local_player()) then return end
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    local land = bit.band(flags, bit.lshift(1, 0)) ~= 0
    if land == true then ground_tick = ground_tick + 1 else ground_tick = 0 end

    if bit.band(flags, 1) == 1 then
        if ground_tick < 10 then if bit.band(flags, 4) == 4 then return 5 else return 4 end end
        if bit.band(flags, 4) == 4 or ui.get(ref.fakeduck) then 
            return 6 -- crouching
        else
            if speed <= 3 then
                return 2 -- standing
            else
                if ui.get(ref.slide[2]) then
                    return 7 -- slowwalk
                else
                    return 3 -- moving
                end
            end
        end
    elseif bit.band(flags, 1) == 0 then
        if bit.band(flags, 4) == 4 then
            return 5 -- air-c
        else
            return 4 -- air
        end
    end
end

ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local VGUI_System010 =  client.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )
local get_clipboard_text_count = ffi.cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

clipboard_import = function()
    local clipboard_text_length = get_clipboard_text_count(VGUI_System)
   
    if clipboard_text_length > 0 then
        local buffer = ffi.new("char[?]", clipboard_text_length)
        local size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)
   
        get_clipboard_text(VGUI_System, 0, buffer, size )
   
        return ffi.string( buffer, clipboard_text_length-1)
    end

    return ""
end

local function clipboard_export(string)
	if string then
		set_clipboard_text(VGUI_System, string, string:len())
	end
end

local aa_state = {[1] = "G", [2] = "S", [3] = "M", [4] = "A", [5] = "A-C", [6] = "C", [7] = "SW"}
local aa_state_full = {[1] = "Global", [2] = "Stand", [3] = "Move", [4] = "Aero", [5] = "Aero (crouch)", [6] = "Crouch", [7] = "Slowwalk"}

-- (c) Infinity1G's AABuilder 
    local last_sim_time = 0
    local defensive_until = 0
    local function is_defensive_active()
        local tickcount = globals.tickcount()
        local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
        local sim_diff = sim_time - last_sim_time

        if sim_diff < 0 then
            defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
        end

        last_sim_time = sim_time

        return defensive_until > tickcount
    end

    local function is_vulnerable()
        for _, v in ipairs(entity.get_players(true)) do
            local flags = (entity.get_esp_data(v)).flags

            if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
                return true
            end
        end

        return false
    end
--

contains = function(tbl, arg)
    for index, value in next, tbl do 
        if value == arg then 
            return true end 
        end 
    return false
end

pui.accent = "C3C6FFFF"

-- [ script ui ]
local group = pui.group("aa","anti-aimbot angles")
local _ui = {
    lua = {
        enable = group:checkbox("\vAllurium"),
        tab = group:combobox("\n ", "Anti-aim", "Miscellaneous"),
    },

    antiaim = {
        enable = group:checkbox("Enable"),
        tab = group:combobox("\aFFFFFFFFAnti-aim tab", "Builder", "Settings"),

        condition = group:combobox("Player state", aa_state_full),

        tweaks = group:multiselect("Tweaks", "Anti-backstab", "Safe head"),
        freestanding = group:hotkey("Freestanding"),
        edge_yaw = group:hotkey("Edge yaw"),
        cfg_export = group:button("Export anti-aim settings", function() config.export() end),
        cfg_import = group:button("Import anti-aim settings", function() config.import() end),
        cfg_reset = group:button("\aFF8282FFReset anti-aim settings", function() config.import("W3siZW5hYmxlIjp0cnVlLCJ0YWIiOiJTZXR0aW5ncyIsImZyZWVzdGFuZGluZyI6WzEsMCwifiJdLCJjb25kaXRpb24iOiJHbG9iYWwiLCJlZGdlX3lhdyI6WzEsMCwifiJdLCJ0d2Vha3MiOlsifiJdfSxbeyJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJ5YXdfdmFsdWUiOjAsIm92ZXJyaWRlIjp0cnVlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfV0sW3siZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOmZhbHNlLCJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOmZhbHNlLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6Ik9mZiIsInlhd192YWx1ZSI6MCwieWF3X2ppdHRlcl92YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsImJvZHlfeWF3X3ZhbHVlIjowLCJwaXRjaF92YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjpmYWxzZSwieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJPZmYiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJ5YXdfdmFsdWUiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOmZhbHNlLCJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOmZhbHNlLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6Ik9mZiIsInlhd192YWx1ZSI6MCwieWF3X2ppdHRlcl92YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsImJvZHlfeWF3X3ZhbHVlIjowLCJwaXRjaF92YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjpmYWxzZSwieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJPZmYiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJ5YXdfdmFsdWUiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfV1d") end),
        cfg_default = group:button("\vLoad default settings", function() config.import("W3siZW5hYmxlIjp0cnVlLCJ0YWIiOiJTZXR0aW5ncyIsImZyZWVzdGFuZGluZyI6WzEsNCwifiJdLCJjb25kaXRpb24iOiJTbG93d2FsayIsImVkZ2VfeWF3IjpbMSw0LCJ+Il0sInR3ZWFrcyI6WyJBbnRpLWJhY2tzdGFiIiwiU2FmZSBoZWFkIiwifiJdfSxbeyJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJ5YXdfdmFsdWUiOjAsIm92ZXJyaWRlIjp0cnVlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImJvZHlfeWF3IjoiSml0dGVyIiwieWF3IjoiMTgwIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfdmFsdWUiOjgsIm92ZXJyaWRlIjp0cnVlLCJ5YXdfaml0dGVyX3ZhbHVlIjotMTR9LHsieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXciOiIxODAiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6LTczLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X3ZhbHVlIjozLCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6NjZ9LHsieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXciOiIxODAiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MSwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOnRydWUsInlhd19qaXR0ZXJfdmFsdWUiOjI4fSx7Inlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImJvZHlfeWF3IjoiSml0dGVyIiwieWF3IjoiMTgwIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfdmFsdWUiOjEyLCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6NjN9LHsieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXciOiIxODAiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOnRydWUsInlhd19qaXR0ZXJfdmFsdWUiOjI4fSx7Inlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImJvZHlfeWF3IjoiSml0dGVyIiwieWF3IjoiMTgwIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJTa2l0dGVyIiwieWF3X3ZhbHVlIjo4LCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6LTE2fV0sW3siZGVmZW5zaXZlX21vZGlmaWVycyI6dHJ1ZSwieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJPZmYiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJ5YXdfdmFsdWUiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6dHJ1ZSwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6dHJ1ZSwiYm9keV95YXciOiJPcHBvc2l0ZSIsInlhdyI6IjE4MCIsInlhd192YWx1ZSI6LTEyNiwieWF3X2ppdHRlcl92YWx1ZSI6ODIsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJib2R5X3lhd192YWx1ZSI6LTMwLCJwaXRjaF92YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOnRydWUsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOnRydWUsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiU3BpbiIsInlhd192YWx1ZSI6NTcsInlhd19qaXR0ZXJfdmFsdWUiOjE4MCwieWF3X2ppdHRlciI6IlNraXR0ZXIiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjg5LCJmb3JjZV9kZWZlbnNpdmUiOnRydWV9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6dHJ1ZSwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJDdXN0b20iLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjp0cnVlLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6IlNwaW4iLCJ5YXdfdmFsdWUiOjM5LCJ5YXdfaml0dGVyX3ZhbHVlIjoxODAsInlhd19qaXR0ZXIiOiJTa2l0dGVyIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjo2MCwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOnRydWUsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiQ3VzdG9tIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6dHJ1ZSwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXciOiJTcGluIiwieWF3X3ZhbHVlIjotMTU0LCJ5YXdfaml0dGVyX3ZhbHVlIjotOTEsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOi03OCwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOnRydWUsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiVXAiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjp0cnVlLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6IjE4MCIsInlhd192YWx1ZSI6LTE2MiwieWF3X2ppdHRlcl92YWx1ZSI6NDMsInlhd19qaXR0ZXIiOiJTa2l0dGVyIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOnRydWV9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6dHJ1ZSwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJSYW5kb20iLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjp0cnVlLCJib2R5X3lhdyI6Ik9wcG9zaXRlIiwieWF3IjoiU3BpbiIsInlhd192YWx1ZSI6MzksInlhd19qaXR0ZXJfdmFsdWUiOi0xNDQsInlhd19qaXR0ZXIiOiJTa2l0dGVyIiwiYm9keV95YXdfdmFsdWUiOjE4MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZX1dXQ==") end)
    },

    misc = {
        console_filter = group:checkbox("Console filter"),
        discharge = group:checkbox("Auto discharge exploit (only scout & awp)"),
        d_mode = group:combobox("Mode", "Instant", "Ideal")
    }
}

aa_builder = {}
aa_builder_defensive = {}

for i = 1, 7 do
    aa_builder[i] = {}
    aa_builder[i].override = group:checkbox("Override \v"..aa_state_full[i].."\r player state")
    aa_builder[i].pitch = group:combobox("\v"..aa_state_full[i].."\r  Pitch", "Off", "Down", "Up")
    aa_builder[i].yaw_base = group:combobox("\v"..aa_state_full[i].."\r  Yaw base", "Local view", "At targets")
    aa_builder[i].yaw = group:combobox("\v"..aa_state_full[i].."\r  Yaw", "Off", "180", "Spin")
    aa_builder[i].yaw_value = group:slider("\v"..aa_state_full[i].."\r  yaw offset", -180, 180, 0)
    aa_builder[i].yaw_jitter = group:combobox("\v"..aa_state_full[i].."\r  Yaw jitter", "Off", "Offset", "Center", "Random", "Skitter")
    aa_builder[i].yaw_jitter_value = group:slider("\v"..aa_state_full[i].."\r  Yaw jitter  ", -180, 180, 0)
    aa_builder[i].body_yaw = group:combobox("\v"..aa_state_full[i].."\r  Body yaw", "Off", "Opposite", "Jitter", "Static")
    aa_builder[i].body_yaw_value = group:slider("\v"..aa_state_full[i].."\r  Body yaw value ", -180, 180, 0)
    aa_builder[i].freestand_body_yaw = group:checkbox("\v"..aa_state_full[i].."\r  Freestanding body yaw")

    aa_builder_defensive[i] = {}
    aa_builder_defensive[i].defensive_modifiers = group:checkbox("\v"..aa_state_full[i].."\r  Defensive modifiers")
    aa_builder_defensive[i].force_defensive = group:checkbox("\v"..aa_state_full[i].."\r  Force defensive")
    aa_builder_defensive[i].defensive_aa_enable = group:checkbox("\v"..aa_state_full[i].."\r  Defensive anti-aim")
    aa_builder_defensive[i].pitch = group:combobox("\v"..aa_state_full[i].."\r  Defensive pitch", "Off", "Down", "Up", "Random", "Custom")
    aa_builder_defensive[i].pitch_value = group:slider("\v"..aa_state_full[i].."\r  Defensive pitch value", -89, 89, 0)
    aa_builder_defensive[i].yaw_base = group:combobox("\v"..aa_state_full[i].."\r  Defensive yaw base", "Local view", "At targets")
    aa_builder_defensive[i].yaw = group:combobox("\v"..aa_state_full[i].."\r  Defensive yaw", "Off", "180", "Spin")
    aa_builder_defensive[i].yaw_value = group:slider("\v"..aa_state_full[i].."\r  Defensive yaw offset", -180, 180, 0)
    aa_builder_defensive[i].yaw_jitter = group:combobox("\v"..aa_state_full[i].."\r  Defensive yaw jitter", "Off", "Offset", "Center", "Random", "Skitter")
    aa_builder_defensive[i].yaw_jitter_value = group:slider("\v"..aa_state_full[i].."\r  Defensive yaw jitter  ", -180, 180, 0)
    aa_builder_defensive[i].body_yaw = group:combobox("\v"..aa_state_full[i].."\r  Defensive body yaw", "Off", "Opposite", "Jitter", "Static")
    aa_builder_defensive[i].body_yaw_value = group:slider("\v"..aa_state_full[i].."\r  Defensive body yaw value ", -180, 180, 0)
end

-- [ visiblity ]
_ui.lua.tab:depend({_ui.lua.enable, true})

-- antiaim
_ui.antiaim.enable:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"})
_ui.antiaim.tab:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true})
_ui.antiaim.condition:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"})
for i = 1, 7 do
    aa_builder[i].override:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]})
    aa_builder[i].pitch:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].yaw_base:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].yaw_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].yaw, "180", "Spin"})
    aa_builder[i].yaw_jitter:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].yaw_jitter_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].yaw_jitter, "Offset", "Center", "Random", "Skitter"})
    aa_builder[i].body_yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].body_yaw_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].body_yaw, "Jitter", "Static"})
    aa_builder[i].freestand_body_yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].body_yaw, "Opposite", "Jitter", "Static"})

    aa_builder_defensive[i].defensive_modifiers:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder_defensive[i].force_defensive:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true})
    aa_builder_defensive[i].defensive_aa_enable:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true})
    aa_builder_defensive[i].pitch:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].pitch_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].pitch, "Custom"}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw_base:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder_defensive[i].yaw, "180", "Spin"}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw_jitter:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw_jitter_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder_defensive[i].yaw_jitter, "Offset", "Center", "Random", "Skitter"}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].body_yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].body_yaw_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder_defensive[i].body_yaw, "Jitter", "Static"}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
end
for k,v in pairs({_ui.antiaim.tweaks, _ui.antiaim.freestanding, _ui.antiaim.edge_yaw, _ui.antiaim.cfg_export, _ui.antiaim.cfg_import, _ui.antiaim.cfg_reset, _ui.antiaim.cfg_default}) do v:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Settings"}) end

-- misc
for k,v in pairs({_ui.misc.console_filter, _ui.misc.discharge}) do v:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Miscellaneous"}) end
_ui.misc.d_mode:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Miscellaneous"}, {_ui.misc.discharge, true})

-- hide refs
local hide_refs = function(value)
    value = not value
    ui.set_visible(ref.aa_enable, value) ui.set_visible(ref.pitch, value) ui.set_visible(ref.pitch_value, value)
    ui.set_visible(ref.yaw_base, value) ui.set_visible(ref.yaw, value) ui.set_visible(ref.yaw_value, value)
    ui.set_visible(ref.yaw_jitter, value) ui.set_visible(ref.yaw_jitter_value, value) ui.set_visible(ref.body_yaw, value)
    ui.set_visible(ref.body_yaw_value, value) ui.set_visible(ref.edgeyaw, value) ui.set_visible(ref.freestand[1], value)
    ui.set_visible(ref.freestand[2], value) ui.set_visible(ref.roll, value) ui.set_visible(ref.freestand_body_yaw, value)
end

-- [ config system ]
local config_items = {
    _ui.antiaim,
    aa_builder,
    aa_builder_defensive
}

local package, data, encrypted, decrypted = pui.setup(config_items), "", "", ""
config = {}

config.export = function()
    data = package:save()
    encrypted = base64.encode(json.stringify(data))
    clipboard_export(encrypted)
end

config.import = function(input)
    decrypted = json.parse(base64.decode(input ~= nil and input or clipboard_import()))
    package:load(decrypted)
end

-- [ antiaim features ]
local function choking(cmd)
    local choke = false

    if cmd.allow_send_packet == false or cmd.chokedcommands > 1 then
        choke = true
    else
        choke = false
    end

    return choke
end

local antiaim_features = function(cmd)
    if not _ui.antiaim.enable.value or not _ui.lua.enable.value or not entity.get_local_player() then return end

    local state = get_state(get_velocity())
    local players = entity.get_players(true)
    local get_override = aa_builder[state].override.value and state or 1

    ui.set(ref.roll, 0)
    ui.set(ref.freestand[2], "always on")

    -- antiaim builder
    for k, v in pairs(ref) do
        local key = (is_defensive_active() and not choking(cmd) and aa_builder_defensive[get_override].defensive_modifiers.value and aa_builder_defensive[get_override].defensive_aa_enable.value) and aa_builder_defensive[get_override][k] or aa_builder[get_override][k]
        
        if key then
            ui.set(v, key.value)
        end
    end

    -- safe head
    if contains(_ui.antiaim.tweaks.value, "Safe head") then
        for i, v in pairs(players) do
            local local_player_origin = vector(entity.get_origin(entity.get_local_player()))
            local player_origin = vector(entity.get_origin(v))
            local difference = (local_player_origin.z - player_origin.z)
            local local_player_weapon = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))

            if ((local_player_weapon == "CKnife" and state == 5 and difference > -70) or difference > 65) and not is_defensive_active() then    
                ui.set(ref.pitch, "down")
                ui.set(ref.yaw, "180")
                ui.set(ref.yaw_value, -1)
                ui.set(ref.yaw_base, "At targets")
                ui.set(ref.yaw_jitter, "Off")
                ui.set(ref.body_yaw, "Static")
                ui.set(ref.body_yaw_value, 0)
                ui.set(ref.freestand_body_yaw, false)
            end
        end
    end
    
    -- anti-backstab
    if contains(_ui.antiaim.tweaks.value, "Anti-backstab") then
        for i, v in pairs(players) do
            local player_weapon = entity.get_classname(entity.get_player_weapon(v))
            local player_distance = math.floor(vector(entity.get_origin(v)):dist(vector(entity.get_origin(entity.get_local_player()))) / 7)

            if player_weapon == "CKnife" then
                if player_distance < 25 then
                    ui.set(ref.yaw, "180")
                    ui.set(ref.yaw_value, -180)
                    ui.set(ref.yaw_base, "At targets")
                    ui.set(ref.yaw_jitter, "Off")
                end
            end
        end
    end

    -- force defensive
    cmd.force_defensive = aa_builder_defensive[get_override].force_defensive.value and true

    -- binds
    ui.set(ref.freestand[1], ui.get(_ui.antiaim.freestanding.ref) and true or false)
    ui.set(ref.edgeyaw, ui.get(_ui.antiaim.edge_yaw.ref) and true or false)
end

-- [ console filter ]
ui.set_callback(_ui.misc.console_filter.ref, function()
    cvar.con_filter_text:set_string("cool text")
    cvar.con_filter_enable:set_int(1)
end)

-- [ auto discharge exploit ]
local auto_discharge = function(cmd)
    if not _ui.misc.discharge.value or not _ui.lua.enable.value or ui.get(ref.quick_peek[2]) or not ui.get(ref.doubletap[2]) or 
    (entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponSSG08" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponAWP") then return end

    local vel_2 = math.floor(entity.get_prop(entity.get_local_player(), "m_vecVelocity[2]"))

    if is_vulnerable() then
        if _ui.misc.d_mode.value == "Ideal" then if vel_2 > 20 then return end end
        cmd.in_jump = false
        cmd.discharge_pending = true
    end
end

-- [ callbacks ]
client.set_event_callback("paint_ui", function()
    if ui.is_menu_open() then
        hide_refs(_ui.lua.enable.value)
        ui.set_visible(aa_builder[1].override.ref, false) ui.set(aa_builder[1].override.ref, true)
    end
end)

client.set_event_callback("setup_command", function(cmd)
    antiaim_features(cmd)
    auto_discharge(cmd)
end)

client.set_event_callback("shutdown", function()
    hide_refs(false)
end)