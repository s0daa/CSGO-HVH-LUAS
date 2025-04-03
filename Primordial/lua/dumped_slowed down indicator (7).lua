local main_font = render.create_font("Arial", 14, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local warning_font = render.create_font("tables", 50, 100, e_font_flags.ANTIALIAS)
local interval = 0

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
    
    render.triangle_filled(vec2_t.new(x + 30, y + 15), 32, color_t(0, 0, 0, 255))
	render.triangle_filled(vec2_t.new(x + 30, y + 15), 32, color_t(r, g, b, wa))
	render.text(warning_font, "I", vec2_t.new(x + 10, y - 25), color_t(0, 0, 0, 255))
    render.text(main_font, string.format("%s %d%%", text, modifier * 100), vec2_t.new(x + 57, y - 15), color_t.new(255, 255, 255, 255 * a))

	local rx, ry, rw, rh = x + 55, y, 95, 12
	render.rect(vec2_t.new(rx, ry), vec2_t.new(rw + 1, rh), color_t.new(0, 0, 0, 255))
    render.rect_filled(vec2_t.new(rx + 1, ry + 1), vec2_t.new(rw - 1, rh - 2), color_t.new(16, 16, 16, 180 * a))
    render.rect_filled(vec2_t.new(rx + 1, ry + 1), vec2_t.new(math.floor(modifier * 94), rh-2), color_t.new(r, g, b, 180 * a))
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