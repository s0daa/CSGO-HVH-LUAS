-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_screen_size, entity_get_local_player, entity_get_prop, entity_is_alive, globals_curtime, math_abs, math_floor, renderer_indicator, renderer_rectangle, renderer_text, string_format, ui_get, ui_new_combobox, ui_reference, ui_set_callback = client.screen_size, entity.get_local_player, entity.get_prop, entity.is_alive, globals.curtime, math.abs, math.floor, renderer.indicator, renderer.rectangle, renderer.text, string.format, ui.get, ui.new_combobox, ui.reference, ui.set_callback

local images = require "gamesense/images"
local warning = images.get_panorama_image("icons/ui/warning.svg")

local displayMaxSpeed = ui_new_combobox("VISUALS", "Other ESP", "Display maximum speed", "Off", "Bar", "Indicator")
local interval = 0

local function rgb_health_based(percentage)
	local r = 124*2 - 124 * percentage
	local g = 195 * percentage
	local b = 13
	return r, g, b
end

local function remap(val, newmin, newmax, min, max, clamp)
	min = min or 0
	max = max or 1

	local pct = (val-min)/(max-min)

	if clamp ~= false then
		pct = math.min(1, math.max(0, pct))
	end

	return newmin+(newmax-newmin)*pct
end

local function rectangle_outline(x, y, w, h, r, g, b, a, s)
	s = s or 1
	renderer_rectangle(x, y, w, s, r, g, b, a) -- top
	renderer_rectangle(x, y+h-s, w, s, r, g, b, a) -- bottom
	renderer_rectangle(x, y+s, s, h-s*2, r, g, b, a) -- left
	renderer_rectangle(x+w-s, y+s, s, h-s*2, r, g, b, a) -- right
end

local function drawBar(modifier, r, g, b, a, text)
	interval = interval + (1-modifier) * 0.7 + 0.3
	local warningAlpha = math_abs(interval*0.01 % 2 - 1) * 255
	
	local text_width = 95
	local sw, sh = client_screen_size()
	local x, y = sw/2-text_width, sh*0.35
	local iw, ih = warning:measure(nil, 35)

	-- icon
	warning:draw(x-3, y-4, iw+6, ih+6, 16, 16, 16, 255*a)
	if a > 0.7 then
		renderer_rectangle(x+13, y+11, 8, 20, 16, 16, 16, 255*a)
	end
	warning:draw(x, y, nil, 35, r,g,b, warningAlpha*a)

	-- text
	renderer_text(x+iw+8, y+3, 255, 255, 255, 255*a, "b", 0, string_format("%s %d%%", text, modifier*100))

	-- bar
	local rx, ry, rw, rh = x+iw+8, y+3+17, text_width, 12
	rectangle_outline(rx, ry, rw, rh, 0, 0, 0, 255*a, 1)
	renderer_rectangle(rx+1, ry+1, rw-2, rh-2, 16, 16, 16, 180*a)
	renderer_rectangle(rx+1, ry+1, math_floor((rw-2)*modifier), rh-2, r, g, b, 180*a)
end

local function maxSpeed()
	local lp = entity_get_local_player()
	if not entity_is_alive(lp) then return end

	local modifier = entity_get_prop(lp, "m_flVelocityModifier")
	if modifier == 1 then return end

	local r, g, b = rgb_health_based(modifier)
	local a = remap(modifier, 1, 0, 0.85, 1)

	if ui_get(displayMaxSpeed) == "Bar" then
		drawBar(modifier, r, g, b, a, "Slowed down")
	else 
		renderer_indicator(r, g, b, a*255, "SLOW")
	end
end

ui_set_callback(displayMaxSpeed, function()
	local update_callback = ui_get(displayMaxSpeed) ~= "Off" and client.set_event_callback or client.unset_event_callback 
	update_callback("paint", maxSpeed)
end)

-- peace
-- love
-- unity
-- respect
