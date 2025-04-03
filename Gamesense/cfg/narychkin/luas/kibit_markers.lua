
local queue = {}

local function aim_fire(c)
	queue[globals.tickcount()] = {c.x,c.y,c.z, globals.curtime() + 2}
end

local function paint(c)
	for tick, data in pairs(queue) do
        if globals.curtime() <= data[4] then
            local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
            if x1 ~= nil and y1 ~= nil then
               --renderer.circle_outline(x1,y1,255,255,255,255,5,0,1.0,1)
			   renderer.line(x1 - 6,y1,x1 + 6,y1,0,255,255,255)
			   renderer.line(x1,y1 - 6,x1,y1 + 6 ,0,255,0,255)
            end
        end
    end
end

client.set_event_callback("aim_fire",aim_fire)
client.set_event_callback("paint",paint)

client.set_event_callback("round_prestart", function()
    queue = {}
end)