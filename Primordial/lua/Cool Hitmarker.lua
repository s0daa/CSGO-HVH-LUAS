--[[
    icedancer for the primordial.dev community
    13th april 2022

    to do list :
        add fade to the damage hitmarker while it slowly goes up.

    update log 14th april 2022 :
    - reduced maximum width
    - increased maximum height and made it only increment by 2 as it would draw a shorter line if the value was uneven
    - removed useless checks ( thanks @Classy )
]]

-- font variable used on line 49
local pixel = render.create_font("Smallest Pixel-7", 14, 25, e_font_flags.DROPSHADOW)

-- hitmarker variables
local enableHitmarker = menu.add_checkbox("Made by icedancer", "better hitmarker", true)
local hitmarkerColor = enableHitmarker:add_color_picker("hitmarker color")

-- damage hitmarker variables
local damageHitmarker = menu.add_checkbox("Made by icedancer", "show damage", true)
local damageColor = damageHitmarker:add_color_picker("damage color")

-- hitmarker height / width
local hitmarkerHeight = menu.add_slider("Made by icedancer", "hitmarker width", 1, 4)
local hitmarkerWidth = menu.add_slider("Made by icedancer", "hitmarker height", 1, 20, 2)


-- called whenever primordial would call a world hitmarker
local function on_world_hitmarker(screen_pos, world_pos, alpha_factor, damage, is_lethal, is_headshot)

    -- checks if the checkbox is ticked
    if enableHitmarker:get() then

        -- draws the vertical line
        render.rect_filled(vec2_t(screen_pos.x-hitmarkerHeight:get()/2, screen_pos.y-hitmarkerWidth:get()/2), vec2_t(hitmarkerHeight:get(), hitmarkerWidth:get()), hitmarkerColor:get())
        
        -- draws the horizontal line
        render.rect_filled(vec2_t(screen_pos.x-hitmarkerWidth:get()/2, screen_pos.y-hitmarkerHeight:get()/2), vec2_t(hitmarkerWidth:get(), hitmarkerHeight:get()), hitmarkerColor:get())
        
        -- checks if the second checkbox is ticked
        if damageHitmarker:get() then

            -- converts the damage variable called by the function from integer to string as render.text requires the second parameter to be a string
            local damageString = tostring(damage)
            
            -- render damage text
            render.text(pixel, damageString, vec2_t(screen_pos.x-hitmarkerWidth:get()/2, screen_pos.y-25), damageColor(damageColor.x, damageColor.y, damageColor.z, damageColor.alpha))
        end
    end
    return true
end

callbacks.add(e_callbacks.WORLD_HITMARKER, on_world_hitmarker)