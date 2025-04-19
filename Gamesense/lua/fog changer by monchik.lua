local pui = require 'gamesense/pui'

local start_val = 0
local end_val = 0

local fog_enable = cvar.fog_enable
local fog_override = cvar.fog_override
local fog_start = cvar.fog_start
local fog_end = cvar.fog_end
local fog_color = cvar.fog_color

local fenable = ui.new_checkbox("LUA", "B", "Enable")
local fstart = ui.new_slider("LUA", "B", "Start", -100, 100, start_val, true, nil, 1)
local fend = ui.new_slider("LUA", "B", "End", 0, 3500, end_val, true, nil, 1)

local function set_fog()
    if ui.get(fenable) then
        fog_enable:set_raw_float(1)
        fog_override:set_raw_float(1)
        fog_start:set_raw_float(ui.get(fstart))
        fog_end:set_raw_float(ui.get(fend))
        fog_color:set_string("133 133 255")
    else
        fog_enable:set_raw_float(0)
        fog_override:set_raw_float(0)
        fog_start:set_raw_float(-1)
        fog_end:set_raw_float(-1)
    end
end

local function menu()
    local state = ui.get(fenable)
    ui.set_visible(fstart, state)
    ui.set_visible(fend, state)
    if not state then
        set_fog()
    end
end

ui.set_callback(fstart, set_fog)
ui.set_callback(fend, set_fog)

menu()
ui.set_callback(fenable, menu)

local function shutdown()
    fog_enable:set_raw_float(0)
    fog_override:set_raw_float(0)
    fog_start:set_raw_float(-1)
    fog_end:set_raw_float(-1)
end

client.set_event_callback("shutdown", shutdown)

client.log("t.me/raze_club") 