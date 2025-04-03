local lib = require("primordial/notification pop-up library.58")
lib:add_notification("Nado", "Don't Forget To Rate My Script", 7)

local main_font = render.create_font("Arial", 14, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local warning_font = render.create_font("Nadofont Regular", 25, 100, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local interval = 0  
local ind = menu.add_text("Indicators", "Icon Color")
local ind3 = menu.add_text("Indicators", "Bar Color")

local ind2 = menu.add_text("Indicators", "Text Color")
local ind_col3 = ind3:add_color_picker("Indicators Color", color_t(52, 143, 235))

local ind_col2 = ind2:add_color_picker("Indicators Color", color_t(52, 143, 235))
local ind_col = ind:add_color_picker("Indicators Color", color_t(52, 143, 235))


local function rgb_health_based(percentage)
    local r = math.floor(124*2 - 124 * percentage)
    local g = math.floor(195 * percentage)
    local b = math.floor(13)
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

local function drawBar(modifier, r, g, b, a, text)
	interval = interval + (1-modifier) * 0.7 + 0.3
	local wa = math.floor(math.abs(interval*0.025 % 2 - 1) * 255)
	
	local screen = render.get_screen_size()
	local x, y = screen.x / 2 - 95, screen.y*0.35
    
   -- render.triangle_filled(vec2_t.new(x + 30, y + 15), 32, color_t(0, 0, 0, 255))
	--render.triangle_filled(vec2_t.new(x + 30, y + 15), 32, color_t(r, g, b, wa))
	render.text(warning_font, "A", vec2_t.new(x + 25, y - 15), ind_col())
    render.text(main_font, string.format("%s %d%%", text, modifier * 100), vec2_t.new(x + 57, y - 15), ind_col2())

	local rx, ry, rw, rh = x + 55, y, 95, 12
	render.rect(vec2_t.new(rx, ry), vec2_t.new(rw + 1, rh), color_t.new(0, 0, 0, 255))
    render.rect_filled(vec2_t.new(rx + 1, ry + 1), vec2_t.new(rw - 1, rh - 2), color_t.new(16, 16, 16, 180 * a))
    render.rect_filled(vec2_t.new(rx + 1, ry + 1), vec2_t.new(math.floor(modifier * 94), rh-2), ind_col3())
end

callbacks.add(e_callbacks.PAINT, function()
	local lp = entity_list.get_local_player()
    if not lp or lp:get_prop("m_lifeState") ~= 0 then return end

	local modifier = lp:get_prop("m_flVelocityModifier")
	if modifier == 1 then return end

    local r, g, b = rgb_health_based(modifier)
    local a = math.floor(remap(modifier, 1, 0, 1, 1))
	drawBar(modifier, r, g, b, a, "Slowed down")
end)