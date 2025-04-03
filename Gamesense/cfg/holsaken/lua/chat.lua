-- local variables for API functions. any changes to the line below will be lost on re-generation
local globals_curtime, require, ipairs, math_abs, table_insert, table_remove, ui_get, ui_new_checkbox, ui_reference, ui_set, ui_set_callback, ui_set_enabled, defer = globals.curtime, require, ipairs, math.abs, table.insert, table.remove, ui.get, ui.new_checkbox, ui.reference, ui.set, ui.set_callback, ui.set_enabled, defer

local surface = require("gamesense/surface")
local console = surface.create_font("Lucida Console", 10, 400, {0x080})

local custom_logs = {} do
    local logs = {}
    function custom_logs.count_lines()
        local count = 0
        for _, log in ipairs(logs) do
            if log.newline then count = count + 1 end
        end
        return count
    end
    
    function custom_logs.remove_line()
        while true do
            local log = table_remove(logs, 1)
            if log.newline then
                break
            end
        end
    end

    function custom_logs.output(e)
        local cur_log = { text = e.text, r = e.r, g = e.g, b = e.b, a = e.a, time = globals_curtime(), newline = (e.text:sub(-1) ~= "\0") }
        table_insert(logs, cur_log)
    
        if custom_logs.count_lines() > 6 then
            custom_logs.remove_line()
        end
    end

    function custom_logs.paint()
        local x = 8
        local y = 5
        local i = 1
    
        while i <= #logs do
            local log = logs[i]
            surface.draw_text(x, y, log.r, log.g, log.b, log.a, console, log.text)
            local text_width, text_height = surface.get_text_size(console, log.text)
    
            if log.newline then
                y = y + text_height
                x = 8
            else
                x = x + text_width
            end
    
            if math_abs(globals_curtime() - log.time) > 8 then
                table_remove(logs, i)
                y = y - text_height
            else
                i = i + 1
            end
        end
    end
end

local draw_output = ui_reference("Misc", "Miscellaneous", "Draw console output")
ui_set_callback(ui_new_checkbox("Misc", "Miscellaneous", "Old output style"), function (self)
    local enabled = ui_get(self)
    local update_callback = enabled and client.set_event_callback or client.unset_event_callback

    update_callback("output", custom_logs.output)
    update_callback("paint", custom_logs.paint)
    
    ui_set(draw_output, not enabled)
    ui_set_enabled(draw_output, not enabled)
end)

defer(function ()
    ui_set(draw_output, true)
    ui_set_enabled(draw_output, true)
end)