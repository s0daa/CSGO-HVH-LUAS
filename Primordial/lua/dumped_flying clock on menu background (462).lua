local background_alpha = 0
local snowflake_alpha = 0
local imgscale = menu.add_slider("main", "image scale", 1, 30)
local rainbow_mode = menu.add_checkbox("main", "rainbow")
local rainbow_speed = menu.add_slider("main", "rainbow speed", 0, 100, 1, 0, "%")
local background_toggle = menu.add_checkbox("main", "background")
local imgcolor = imgscale:add_color_picker("lol")
local background_color = background_toggle:add_color_picker("bkg")



local function clamp(min, max, val)
    if val > max then return max end
    if val < min then return min end
    return val
end

imgscale:set(18)
imgcolor:set(color_t(255, 255, 255, 200))
background_color:set(color_t(0, 0, 0, 200))
background_toggle:set(true)
rainbow_mode:set(true)
rainbow_speed:set(25)

local img = render.load_image("primordial/scripts/include/__image.png")

local function draw_line(x, y, x1, y1, r, g, b, a)
    local current_rainbow = (global_vars.real_time() * rainbow_speed:get()) % 100

    if rainbow_mode:get() == false then

        render.texture(img.id, vec2_t(x, y), vec2_t(imgscale:get(), imgscale:get()), imgcolor:get())
    else
        imgcolor:set(color_t.from_hsb(current_rainbow / 100, 1, 1))
        render.texture(img.id, vec2_t(x, y), vec2_t(imgscale:get(), imgscale:get()), imgcolor:get())
        imgcolor:set(color_t(255, 255, 255, 200))
    end
end

local function draw_snowflake(x, y, size)
    local base = 4 + size
    draw_line(x - base, y - base, x + base + 100, y + base + 1, 255, 255, 255, snowflake_alpha - 75)
    base = 5 + size
end

local snowflakes = {}
local time = 0
local stored_time = 0

local function on_render()
    if menu.is_open() then
        screen = render.get_screen_size()
        if background_toggle:get() then
            render.rect_filled(vec2_t(0, 0), vec2_t(screen.x, screen.y), background_color:get())
        end
        background_alpha = clamp(0, 255, background_alpha + 10)
        snowflake_alpha = clamp(0, 255, snowflake_alpha + 10)
        background_alpha = clamp(0, 255, background_alpha - 10)
        snowflake_alpha = clamp(0, 255, snowflake_alpha - 10)
        snowflake_alpha = 255
        local frametime = global_vars.frame_time()
        time = time + frametime
        if #snowflakes < 128 then
            if time > stored_time then
                stored_time = time
                table.insert(snowflakes, {math.random(10, screen.x - 10),1, math.random(1, 3), math.random(-60, 60) / 100,math.random(-3, 0)})
            end
        end
        local fps = 1 / frametime
        for i = 1, #snowflakes do
            local snowflake = snowflakes[i]
            local x, y, vspeed, hspeed, size = snowflake[1], snowflake[2], snowflake[3], snowflake[4], snowflake[5]
            if screen.y <= y then
                snowflake[1] = math.random(10, screen.x - 10)
                snowflake[2] = 1
                snowflake[3] = math.random(1, 3)
                snowflake[4] = math.random(-60, 60) / 100
                snowflake[5] = math.random(-3, 0)
            end
            draw_snowflake(x, y, size)
            snowflake[2] = snowflake[2] + vspeed / fps * 100
            snowflake[1] = snowflake[1] + hspeed / fps * 100
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_render)