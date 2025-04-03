--thx ducarii, was gonna write this anyways, but you already made the color script <3

local local_glow_color = menu.find("visuals", "esp", "models","glow#local")[2]
local enemy_glow_color = menu.find("visuals", "esp", "models","glow#enemy")[2]
local friendly_glow_color = menu.find("visuals", "esp", "models","glow#friendly")[2]

local local_rainbow = menu.add_checkbox("rainbow glow", "local rainbow")
local enemy_rainbow = menu.add_checkbox("rainbow glow", "enemy rainbow")
local friendly_rainbow = menu.add_checkbox("rainbow glow", "friendly rainbow")
local rainbow_speed = menu.add_slider("rainbow glow", "rainbow speed", 0, 100, 1, 0, "%")
rainbow_speed:set(25)

local function on_paint()
    local current_rainbow = (global_vars.real_time() * rainbow_speed:get()) % 100
    if local_rainbow:get() then
        local_glow_color:set(color_t.from_hsb(current_rainbow / 100, 1, 1))
    end
    if enemy_rainbow:get() then
        enemy_glow_color:set(color_t.from_hsb(current_rainbow / 100, 1, 1))
    end
    if friendly_rainbow:get() then
        friendly_glow_color:set(color_t.from_hsb(current_rainbow / 100, 1, 1))
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)