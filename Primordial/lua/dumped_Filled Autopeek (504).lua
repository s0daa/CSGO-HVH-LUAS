local checkbox = menu.add_checkbox("Autopeek", "Enable")
local colly = checkbox:add_color_picker("Autopeek color")

local fraction = 0
local speed = 0.2 --seconds
local height = 16 --indicator offset

local autopeek_pos_save = nil

function clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

function render_sphere2(origin, radius, steps, color, color_out)
    local last_point = nil
    local world_origin = render.world_to_screen(origin)
    if world_origin == nil then
        return
    end

    for ang = 0, 360, 360/steps do
        local point = vec3_t(
            origin.x + (radius * math.cos(math.rad(ang))),
            origin.y + (radius * math.sin(math.rad(ang))),
            origin.z
        )


        local world_point = render.world_to_screen(point)
        if last_point ~= nil and world_point ~= nil and last_point ~= nil then
            render.polygon({world_origin, last_point, world_point}, color)
            render.line(last_point, world_point,  color_out)
            render.line(vec2_t(last_point.x + 1, last_point.y), vec2_t(world_point.x + 1, world_point.y), color_out)
            render.line(vec2_t(last_point.x, last_point.y + 1), vec2_t(world_point.x,  world_point.y + 1), color_out)
        end
        last_point = world_point
    end
end

local function on_paint()
    if checkbox:get() then

        local cls_g = colly:get()
        local mambo_auto = ragebot.get_autopeek_pos()
        local cls1 = color_t(cls_g.r, cls_g.g, cls_g.b, 255)
        local cls2 = color_t(cls_g.r, cls_g.g, cls_g.b, 100)



        if mambo_auto ~= nil or fraction ~= 0 then

                if mambo_auto ~= nil then
                    autopeek_pos_save = mambo_auto
                    fraction = clamp(fraction + global_vars.absolute_frame_time() * (1/speed), 0, 1)
                else
                    fraction = clamp(fraction - global_vars.absolute_frame_time() * (1/speed), 0, 1)
                end

            render_sphere2(autopeek_pos_save, 18*fraction^2, 60, cls2, cls1)
        else

        end

    end
end

callbacks.add(e_callbacks.PAINT, on_paint)