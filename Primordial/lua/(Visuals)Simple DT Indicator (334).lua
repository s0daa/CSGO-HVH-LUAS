local screen_size = render.get_screen_size()
local easing = require("easing library")

local x = menu.add_slider("dt indicator", "x", 0, screen_size.x)   
local y = menu.add_slider("dt indicator", "y", 0, screen_size.y)   
x:set(screen_size.x/2)
y:set(screen_size.y/2 + 40)
local font = render.create_font("smallest pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE)
local _ref_dt, ref_dt = unpack(menu.find("aimbot","general","exploits","doubletap","enable"))
local maxcharge = 14

local clamp = function(v, min, max) 
    local num = v;
    num = num < min and min or num;
    num = num > max and max or num; 
    return num 
end

local function on_setup_command(cmd)
    maxcharge = (exploits.get_max_charge() ~= 0 and maxcharge ~= exploits.get_max_charge()) and exploits.get_max_charge() or maxcharge
end

m_alpha = 0
local function on_paint()
    local FT = global_vars.frame_time() * 6
    local alpha = easing.cubic_in_out(m_alpha, 0, 1, 1)

    local vec = vec2_t(x:get(), y:get())
    local progress = ref_dt:get() and exploits.get_charge()/maxcharge or 0.0
    local color = color_t(math.floor(255 - 131 * progress), math.floor(195 * progress), math.floor(13 * progress), math.floor(alpha*255))
    render.progress_circle( vec - vec2_t(6, 0), 2, color_t.new(0,0,0, math.floor(alpha*250)), 3, progress)
    render.progress_circle( vec - vec2_t(6, 0), 3, color, 1, progress)
    render.text(font,"DT",vec2_t(vec.x - 4 + 8*easing.cubic_in_out(progress, 0, 1, 1),vec.y - 5), color)

    m_alpha = clamp(m_alpha + (ref_dt:get() and FT or -FT), 0, 1)
end

callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)
callbacks.add(e_callbacks.PAINT, on_paint)