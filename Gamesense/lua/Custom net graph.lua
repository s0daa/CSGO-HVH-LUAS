-- cringe clock syncing thing
-- credits: @estk - ping spike (datagram ind.) calculations

local success, surface = pcall(require, 'gamesense/surface')

if not success then
    error('\n\n - Surface library is required \n - https://gamesense.pub/forums/viewtopic.php?id=18793\n')
end

local ffi = require 'ffi'
local ffi_cast = ffi.cast
local surface_measure_text, surface_draw_text = surface.measure_text, surface.draw_text
local client_create_interface, client_screen_size, client_set_event_callback, entity_get_local_player, globals_tickinterval, math_abs, pcall, error, globals_frametime, globals_realtime, math_floor, math_max, math_min, math_sin, renderer_load_rgba, renderer_texture, string_format, ui_get, ui_reference, print = client.create_interface, client.screen_size, client.set_event_callback, entity.get_local_player, globals.tickinterval, math.abs, pcall, error, globals.frametime, globals.realtime, math.floor, math.max, math.min, math.sin, renderer.load_rgba, renderer.texture, string.format, ui.get, ui.reference, print

-- CONVARS
local cl_interp = cvar.cl_interp -- 0.015625
local cl_interp_ratio = cvar.cl_interp_ratio -- 1
local cl_updaterate = cvar.cl_updaterate

-- FFI STUFF
local pflFrameTime = ffi.new("float[1]")
local pflFrameTimeStdDeviation = ffi.new("float[1]")
local pflFrameStartTimeStdDeviation = ffi.new("float[1]")

local interface_ptr = ffi.typeof('void***')
local netc_bool = ffi.typeof("bool(__thiscall*)(void*)")
local netc_bool2 = ffi.typeof("bool(__thiscall*)(void*, int, int)")
local netc_float = ffi.typeof("float(__thiscall*)(void*, int)")
local netc_int = ffi.typeof("int(__thiscall*)(void*, int)")
local net_fr_to = ffi.typeof("void(__thiscall*)(void*, float*, float*, float*)")

local rawivengineclient = client_create_interface("engine.dll", "VEngineClient014") or error("VEngineClient014 wasnt found", 2)
local ivengineclient = ffi_cast(interface_ptr, rawivengineclient) or error("rawivengineclient is nil", 2)
local get_net_channel_info = ffi_cast("void*(__thiscall*)(void*)", ivengineclient[0][78]) or error("ivengineclient is nil")
local slv_is_ingame_t = ffi_cast("bool(__thiscall*)(void*)", ivengineclient[0][26]) or error("is_in_game is nil")

local ping_spike = { ui_reference('MISC', 'Miscellaneous', 'Ping spike') }

local LC_ALPHA = 1
local WarningIcon = "\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x02\xFF\xFF\xFF\x00\xFF\xFF\xFF\x6B\xFF\xFF\xFF\xFC\xFF\xFF\xFF\xFD\xFF\xFF\xFF\x6F\xFF\xFF\xFF\x00\xFF\xFF\xFF\x02\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x02\xFF\xFF\xFF\x00\xFF\xFF\xFF\x3C\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x6A\xFF\xFF\xFF\x70\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x40\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\xCA\xFF\xFF\xFF\xA1\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xB6\xFF\xFF\xFF\xCE\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x4D\xFF\xFF\xFF\xFC\xFF\xFF\xFF\x20\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x31\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x50\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xD8\xFF\xFF\xFF\x94\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xAA\xFF\xFF\xFF\xDC\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x5E\xFF\xFF\xFF\xF7\xFF\xFF\xFF\x15\xFF\xFF\xFF\x00\xFF\xFF\xFF\x52\xFF\xFF\xFF\x56\xFF\xFF\xFF\x00\xFF\xFF\xFF\x24\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x61\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\xE5\xFF\xFF\xFF\x83\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xDA\xFF\xFF\xFF\xE3\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x99\xFF\xFF\xFF\xE9\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x70\xFF\xFF\xFF\xF0\xFF\xFF\xFF\x0A\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xD1\xFF\xFF\xFF\xD9\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x17\xFF\xFF\xFF\xFE\xFF\xFF\xFF\x73\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x09\xFF\xFF\xFF\xEF\xFF\xFF\xFF\x72\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\xD2\xFF\xFF\xFF\xDB\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x86\xFF\xFF\xFF\xF4\xFF\xFF\xFF\x0B\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x82\xFF\xFF\xFF\xE7\xFF\xFF\xFF\x02\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xD2\xFF\xFF\xFF\xDB\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x0C\xFF\xFF\xFF\xF5\xFF\xFF\xFF\x84\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x13\xFF\xFF\xFF\xF8\xFF\xFF\xFF\x61\xFF\xFF\xFF\x00\xFF\xFF\xFF\x04\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xD2\xFF\xFF\xFF\xDB\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x04\xFF\xFF\xFF\x00\xFF\xFF\xFF\x73\xFF\xFF\xFF\xFE\xFF\xFF\xFF\x16\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x94\xFF\xFF\xFF\xDB\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xD0\xFF\xFF\xFF\xD8\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\xE9\xFF\xFF\xFF\x97\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x1F\xFF\xFF\xFF\xFE\xFF\xFF\xFF\x51\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xE0\xFF\xFF\xFF\xE9\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x61\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x22\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xA6\xFF\xFF\xFF\xCD\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x6D\xFF\xFF\xFF\x72\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xDC\xFF\xFF\xFF\xA9\xFF\xFF\xFF\x00\xFF\xFF\xFF\x2D\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x41\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x7D\xFF\xFF\xFF\x82\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x03\xFF\xFF\xFF\x00\xFF\xFF\xFF\x4F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x30\xFF\xFF\xFF\xBC\xFF\xFF\xFF\xBC\xFF\xFF\xFF\x00\xFF\xFF\xFF\x02\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x02\xFF\xFF\xFF\x00\xFF\xFF\xFF\xA7\xFF\xFF\xFF\xAE\xFF\xFF\xFF\x00\xFF\xFF\xFF\x02\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\xCC\xFF\xFF\xFF\xBB\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x3E\xFF\xFF\xFF\x00\xFF\xFF\xFF\x01\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x02\xFF\xFF\xFF\x00\xFF\xFF\xFF\x40\xFF\xFF\xFF\xF7\xFF\xFF\xFF\xE0\xFF\xFF\xFF\x7D\xFF\xFF\xFF\x00\xFF\xFF\xFF\x07\xFF\xFF\xFF\x04\xFF\xFF\xFF\x04\xFF\xFF\xFF\x04\xFF\xFF\xFF\x04\xFF\xFF\xFF\x04\xFF\xFF\xFF\x04\xFF\xFF\xFF\x04\xFF\xFF\xFF\x04\xFF\xFF\xFF\x04\xFF\xFF\xFF\x04\xFF\xFF\xFF\x04\xFF\xFF\xFF\x04\xFF\xFF\xFF\x06\xFF\xFF\xFF\x00\xFF\xFF\xFF\x8A\xFF\xFF\xFF\xDC\xFF\xFF\xFF\x3F\xFF\xFF\xFF\xE7\xFF\xFF\xFF\xE4\xFF\xFF\xFF\xE1\xFF\xFF\xFF\xE2\xFF\xFF\xFF\xE2\xFF\xFF\xFF\xE2\xFF\xFF\xFF\xE2\xFF\xFF\xFF\xE2\xFF\xFF\xFF\xE3\xFF\xFF\xFF\xE3\xFF\xFF\xFF\xE2\xFF\xFF\xFF\xE2\xFF\xFF\xFF\xE2\xFF\xFF\xFF\xE2\xFF\xFF\xFF\xE2\xFF\xFF\xFF\xE1\xFF\xFF\xFF\xE5\xFF\xFF\xFF\xF0\xFF\xFF\xFF\x43"

local verdana = surface.create_font('Verdana', 12, 400, { 0x200 --[[ Outline ]] })
local warning_icon = renderer_load_rgba(WarningIcon, 20, 19) or error('couldnt initialize icon', 2)

local ping_color = function(ping_value)
    if ping_value < 40 then return { 255, 255, 255 } end
    if ping_value < 100 then return { 255, 125, 95 } end

    return { 255, 60, 80 }
end

local GetNetChannel = function(INetChannelInfo)
    if INetChannelInfo == nil then
        return
    end

    local seqNr_out = ffi_cast(netc_int, INetChannelInfo[0][17])(INetChannelInfo, 1)

    return {
        seqNr_out = seqNr_out,

        is_loopback = ffi_cast(netc_bool, INetChannelInfo[0][6])(INetChannelInfo),
        is_timing_out = ffi_cast(netc_bool, INetChannelInfo[0][7])(INetChannelInfo),

        latency = {
            crn = function(flow) return ffi_cast(netc_float, INetChannelInfo[0][9])(INetChannelInfo, flow) end,
            average = function(flow) return ffi_cast(netc_float, INetChannelInfo[0][10])(INetChannelInfo, flow) end,
        },

        loss = ffi_cast(netc_float, INetChannelInfo[0][11])(INetChannelInfo, 1),
        choke = ffi_cast(netc_float, INetChannelInfo[0][12])(INetChannelInfo, 1),
        got_bytes = ffi_cast(netc_float, INetChannelInfo[0][13])(INetChannelInfo, 1),
        sent_bytes = ffi_cast(netc_float, INetChannelInfo[0][13])(INetChannelInfo, 0),

        is_valid_packet = ffi_cast(netc_bool2, INetChannelInfo[0][18])(INetChannelInfo, 1, seqNr_out-1),
    }
end

local GetNetFramerate = function(INetChannelInfo)
    if INetChannelInfo == nil then
        return 0, 0
    end

    local server_var = 0
    local server_framerate = 0

    ffi_cast(net_fr_to, INetChannelInfo[0][25])(INetChannelInfo, pflFrameTime, pflFrameTimeStdDeviation, pflFrameStartTimeStdDeviation)

    if pflFrameTime ~= nil and pflFrameTimeStdDeviation ~= nil and pflFrameStartTimeStdDeviation ~= nil then
        if pflFrameTime[0] > 0 then
            server_var = pflFrameStartTimeStdDeviation[0] * 1000
            server_framerate = pflFrameTime[0] * 1000
        end
    end

    return server_framerate, server_var
end

local function g_paint()
    local me = entity_get_local_player()

    if not me or not slv_is_ingame_t(ivengineclient) then
        return
    end

    local INetChannelInfo = ffi_cast("void***", get_net_channel_info(ivengineclient)) or error("netchaninfo is nil")

    local net_channel = GetNetChannel(INetChannelInfo)
    local server_framerate, server_var = GetNetFramerate(INetChannelInfo)
    local alpha = math_min(math_floor(math_sin((globals_realtime()%3) * 4) * 125 + 200), 255)

    local color = { 255, 200, 95, 255 }
    local x, y = client_screen_size()

    x,y = x / 2 + 1, y - 155

    local net_state = 0
    local net_data_text = {
        [0] = 'clock syncing',
        [1] = 'packet choke',
        [2] = 'packet loss',
        [3] = 'lost connection'
    }

    if net_channel.choke > 0.00 then net_state = 1 end
    if net_channel.loss > 0.00 then net_state = 2 end

    if net_channel.is_timing_out then 
        net_state = 3
        net_channel.loss = 1

        LC_ALPHA = LC_ALPHA-globals_frametime()
        LC_ALPHA = LC_ALPHA < 0.05 and 0.05 or LC_ALPHA 
    else
        LC_ALPHA = LC_ALPHA+(globals_frametime()*2)
        LC_ALPHA = LC_ALPHA > 1 and 1 or LC_ALPHA 
    end

    local right_text = net_state ~= 0 and 
        string_format('%.1f%% (%.1f%%)', net_channel.loss*100, net_channel.choke*100) or 
        string_format('%.1fms', server_var/2)

    if net_state ~= 0 then
        color = { 255, 50, 50, alpha }
    end

    local ccor_text = net_data_text[net_state]
    local ccor_width = surface_measure_text(nil, ccor_text)

    local sp_x = x - ccor_width - 25
    local sp_y = y

    local cn = 1

    surface_draw_text(sp_x, sp_y, 255, 255, 255, net_state ~= 0 and 255 or alpha, verdana, ccor_text)
    renderer_texture(warning_icon, x - 10, sp_y - 8, 20, 19, --[[ colors ]] color[1], color[2], color[3], color[4])
    surface_draw_text(x + 20, sp_y, 255, 255, 255, 255, verdana, string_format('+- %s', right_text))

    local bytes_in_text = string_format('in: %.2fk/s    ', net_channel.got_bytes/1024)
    local bi_width = surface_measure_text(nil, bytes_in_text)

    local tickrate = 1/globals_tickinterval()
    local lerp_time = cl_interp_ratio:get_float() * (1000 / tickrate)

    local lerp_clr = { 255, 255, 255 }

    if lerp_time/1000 < 2/cl_updaterate:get_int() then
        lerp_clr = { 255, 125, 95 }
    end

    surface_draw_text(sp_x, sp_y + 20*cn, 255, 255, 255, LC_ALPHA*255, verdana, bytes_in_text);
    surface_draw_text(sp_x + bi_width, sp_y + 20*cn, lerp_clr[1], lerp_clr[2], lerp_clr[3], LC_ALPHA*255, verdana, string_format('lerp: %.1fms', lerp_time)); cn=cn+1
    surface_draw_text(sp_x, sp_y + 20*cn, 255, 255, 255, LC_ALPHA*255, verdana, string_format('out: %.2fk/s', net_channel.sent_bytes/1024)); cn=cn+1

    surface_draw_text(sp_x, sp_y + 20*cn, 255, 255, 255, LC_ALPHA*255, verdana, string_format('sv: %.2f +- %.2fms    var: %.3f ms', server_framerate, server_var, server_var)); cn=cn+1

    local outgoing, incoming = net_channel.latency.crn(0), net_channel.latency.crn(1)
    local ping, avg_ping = outgoing*1000, net_channel.latency.average(0)*1000

    local ping_spike_val = (ui_get(ping_spike[1]) and ui_get(ping_spike[2])) and ui_get(ping_spike[3]) or 1
    
    local latency_interval = (outgoing + incoming) / (ping_spike_val - globals_tickinterval())
    local additional_latency = math_min(latency_interval*1000, 1) * 100 -- 100 = green 0 = red

    local pc = ping_color(avg_ping)
    local tr_text = string_format('tick: %dp/s    ', tickrate)
    local tr_width = surface_measure_text(nil, tr_text)

    local nd_text = string_format('delay: %dms (+- %dms)    ', avg_ping, math_abs(avg_ping-ping))
    local nd_width = surface_measure_text(nil, nd_text)

    local incoming_latency = math_max(0, (incoming-outgoing)*1000)
    
    local fl_pre_text = (ping_spike_val ~= 1 and incoming_latency > 1) and string_format(': %dms', incoming_latency) or ''
    local fl_text = string_format('datagram%s', fl_pre_text)

    -- Draw line
    -- surface_draw_text(sp_x, sp_y + 20*cn, 255, 255, 255, 255, verdana, tr_text);
    surface_draw_text(sp_x, sp_y + 20*cn, pc[1], pc[2], pc[3], LC_ALPHA*255, verdana, nd_text);
    surface_draw_text(sp_x + nd_width, sp_y + 20*cn, 255, 255 / 100 * additional_latency, 255 / 100 * additional_latency, LC_ALPHA*255, verdana, fl_text); cn=cn+1
end

client_set_event_callback('paint', g_paint)

--[[
    client_set_event_callback('_net_update_start', function()
        local INetChannelInfo = ffi_cast("void***", get_net_channel_info(ivengineclient)) or error("netchaninfo is nil")
        local net_channel = GetNetChannel(INetChannelInfo)

        if not net_channel.is_valid_packet then
            print('dropped packet: ', net_channel.seqNr_out)
        end

        cvar.net_showdrop:set_int(1)
    end)
]]
