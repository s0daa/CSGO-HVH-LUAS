-- Menu
local tracer = ui.new_checkbox("VISUALS", "Effects", "Bullet tracers redux")
local color = ui.new_color_picker("VISUALS", "Effects", "Color", 255, 255, 255, 255)

-- Variables and constants
local queue = {}

-- Game event handling
client.set_event_callback("bullet_impact", function(e)
    if not ui.get(tracer) then
        return
    end
    if client.userid_to_entindex(e.userid) ~= entity.get_local_player() then
        return
    end
    local lx, ly, lz = client.eye_position()
    queue[globals.tickcount()] = {lx, ly, lz, e.x, e.y, e.z, globals.curtime() + 2}
end)

client.set_event_callback("paint", function()
    if not ui.get(tracer) then
        return
    end
    for tick, data in pairs(queue) do
        if globals.curtime() <= data[7] then
            local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
            local x2, y2 = renderer.world_to_screen(data[4], data[5], data[6])
            if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
                renderer.line(x1, y1, x2, y2, ui.get(color))
            end
        end
    end
end)

client.set_event_callback("round_prestart", function()
    if not ui.get(tracer) then
        return
    end
    queue = {}
end)