local screen = render.get_screen_size()
local meff = {}

local Menu_effects = menu.add_checkbox("group", "checkyboxy", true)
local Menu_effects_color = Menu_effects:add_color_picker("bruh color")
local Menu_effects_line_color = Menu_effects:add_color_picker("bruh color")

meff.nod = 275
meff.cde = 175
meff.speed = 29
meff.alpha = vec2_t(0.75, 1)
meff.size = vec2_t(1, 2)
meff.velocity = vec2_t(-2, 2)
meff.dots = ffi.new("float[" .. meff.nod ..  "][6]")

function meff_Generate(value)
    meff.dots = {}
    for i = 0, value-1 do
        local pes = ffi.new("float[?]", 6)
        pes[0] = math.random(0, screen.x)
        pes[1] = math.random(0, screen.y)
        pes[2] = math.random(meff.alpha.x, meff.alpha.y)
        pes[3] = math.random(meff.size.y, meff.size.y)
        pes[4] = math.random(meff.velocity.x, meff.velocity.y) * meff.speed
        pes[5] = math.random(meff.velocity.x, meff.velocity.y) * meff.speed
        meff.dots[i] = pes
    end
end

meff.c_velocity = ffi.new("float[?]", 2)
meff.cos = ffi.new("float[?]", 10)
meff.screen_size = ffi.new("float[?]", 2)

meff.screen_size[0] = screen.x
meff.screen_size[1] = screen.y

function meff_handle()
    if not Menu_effects:get() or not menu.is_open() then
        return
    end
    
    local mouse_pos = input.get_mouse_pos()
    
    meff.cos[0] = mouse_pos.x
    meff.cos[1] = mouse_pos.y
    
    local frame_time = globals.frame_time()
    
    local r = math.floor(math.sin(frame_time * 1) * 127 + 128)
    local g = math.floor(math.sin(frame_time * 1.5 + 2) * 127 + 128)
    local b = math.floor(math.sin(frame_time * 1.5 + 4) * 127 + 128)
    
    local color = Menu_effects_color:get()
    local color_1 = Menu_effects_line_color:get()

    for i = 0, meff.nod-1 do
        local current_element = meff.dots[i]
        meff.c_velocity[0] = current_element[4] * frame_time
        meff.c_velocity[1] = current_element[5] * frame_time
        if current_element[0] + meff.c_velocity[0] > meff.screen_size[0] or current_element[0] + meff.c_velocity[0] < 0 then
            meff.dots[i][4] = -current_element[4]
            meff.c_velocity[0] = -meff.c_velocity[0]
        end
        if current_element[1] + meff.c_velocity[1] > meff.screen_size[1] or current_element[1] + meff.c_velocity[1] < 0 then
            meff.dots[i][5] = -current_element[5]
            meff.c_velocity[1] = -meff.c_velocity[1]
        end
        meff.dots[i][0] = current_element[0] + meff.c_velocity[0]
        meff.dots[i][1] = current_element[1] + meff.c_velocity[1]
        render.circle_filled(vec2_t.new(current_element[0], current_element[1]), current_element[3], color)
        for i = 0, 9, 2 do
            local current_distance = math.abs(current_element[0] - meff.cos[i]) + math.abs(current_element[1] - meff.cos[i+1])
            if current_distance < meff.cde then
                render.line(vec2_t(meff.cos[i], meff.cos[i+1]), vec2_t(current_element[0], current_element[1]), color_1)
                break
            end
        end
    end
end

meff_Generate(meff.nod)

callbacks.add(e_callbacks.PAINT, meff_handle)