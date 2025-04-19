local math_ceil, math_tan, math_correctRadians, math_fact, math_log10, math_randomseed, math_cos, math_sinh, math_random, math_huge, math_pi, math_max, math_atan2, math_ldexp, math_floor, math_sqrt, math_deg, math_atan = math.ceil, math.tan, math.correctRadians, math.fact, math.log10, math.randomseed, math.cos, math.sinh, math.random, math.huge, math.pi, math.max, math.atan2, math.ldexp, math.floor, math.sqrt, math.deg, math.atan 
local math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_frexp, math_log, math_tanh, math_exp, math_modf, math_cosh, math_asin, math_rad = math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.frexp, math.log, math.tanh, math.exp, math.modf, math.cosh, math.asin, math.rad 

local function DEG2RAD(x) return x * math_pi / 180 end
local function RAD2DEG(x) return x * 180 / math_pi end

local function hsv2rgb(h, s, v, a)
    local r, g, b
  
    local i = math_floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);
  
    i = i % 6
  
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
  
    return r * 255, g * 255, b * 255, a * 255
end

local rainbow = 0.00
local rotationdegree = 0.000;

local function draw_svaston(x, y, size)
    local frametime = globals.frametime()
    local a = size / 60
    local gamma = math_atan(a / a)
    rainbow = rainbow + (frametime * 0.5)
    if rainbow > 1.0 then rainbow = 0.0 end
    if rotationdegree > 89 then rotationdegree = 0 end

    for i = 0, 4 do  
        local p_0 = (a * math_sin(DEG2RAD(rotationdegree + (i * 90))))
        local p_1 = (a * math_cos(DEG2RAD(rotationdegree + (i * 90))))
        local p_2 =((a / math_cos(gamma)) * math_sin(DEG2RAD(rotationdegree + (i * 90) + RAD2DEG(gamma))))
        local p_3 =((a / math_cos(gamma)) * math_cos(DEG2RAD(rotationdegree + (i * 90) + RAD2DEG(gamma))))

        local a, r, g, b = hsv2rgb(rainbow, 1, 1, 1)
        renderer.line(x, y, x + p_0, y - p_1, a, r, g, b)
        renderer.line(x + p_0, y - p_1, x + p_2, y - p_3, a, r, g, b)
    end
    rotationdegree = rotationdegree + (frametime * 150)
end

local function on_paint()
    local screenW, screenH = client.screen_size()
    draw_svaston(screenW / 2, screenH / 2, screenH /2) 
end

client.set_event_callback('paint', on_paint)