local ui_set_callback = ui.set_callback
local ui_get = ui.get
local ui_set_visible = ui.set_visible
local ui_new_checkbox = ui.new_checkbox
local ui_new_color_picker = ui.new_color_picker
local ui_new_checkbox = ui.new_checkbox

local hitmark_enable = ui_new_checkbox("VISUALS", "Player ESP", "World Hitmarker")
local hitmark_color = ui_new_color_picker("VISUALS", "Player ESP", "World Hitmarker Color", 105, 200, 255, 255)
local hitmarkenable, r, g, b, a
local queue = {}

local function menu()
	hitmarkenable = ui_get(hitmark_enable)
	r, g, b, a = ui_get(hitmark_color)
	
	ui_set_visible(hitmark_color, hitmarkenable)
end

ui_set_callback(hitmark_enable, menu)
ui_set_callback(hitmark_color, menu)

local function aim_fire(c)
	queue[globals.tickcount()] = {c.x,c.y,c.z, globals.curtime() + 2}
end

local function paint(c)
	if hitmarkenable then
	for tick, data in pairs(queue) do
        if globals.curtime() <= data[4] then
            local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
            if x1 ~= nil and y1 ~= nil then
			   renderer.line(x1 - 6,y1,x1 + 6,y1,r,g,b,a)
			   renderer.line(x1,y1 - 6,x1,y1 + 6 ,r,g,b,a)
            end
        end
    end
end
end

client.set_event_callback("aim_fire",aim_fire)
client.set_event_callback("paint",paint)

client.set_event_callback("round_prestart", function()
    queue = {}
end)