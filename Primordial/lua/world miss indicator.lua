local data = {}
local font = render.create_font('Small Fonts', 12, 200, e_font_flags.OUTLINE)
local font_x = render.create_font('Comic Sans MS Bold', 15, 550, e_font_flags.OUTLINE)

local on_miss = function(e)
    for index, value in pairs(data) do
        if data[index].id == e.id then
            data[index].reason = e.reason_string
            data[index].hitbox = client.get_hitbox_name(e.aim_hitbox)
            data[index].world_pos = e.player:get_hitbox_pos(e.aim_hitbox)
        end
    end
end

local on_shoot = function (e)
    table.insert(data, 1, {id=e.id, world_pos=nil, reason='null', hitbox='null', time=client.get_unix_time(), opacity = 255})
end

local on_paint = function()
    for index, value in pairs(data) do
        local world_pos = data[index].world_pos
        local reason = data[index].reason
        local hitbox = data[index].hitbox
        local opacity = data[index].opacity

        if world_pos then
            if client.get_unix_time() > data[index].time + 2 then
                data[index].opacity = data[index].opacity - 10

                if opacity < 1 then
                    table.remove(data, index)
                end
            end

            if opacity > 1 then
                local screen_pos = render.world_to_screen(world_pos)
                if reason and screen_pos then
                    render.text(font_x, 'x ', screen_pos + vec2_t(0, -render.get_text_size(font_x, 'x ').y/2), color_t(255, 0, 0, opacity))
                    render.text(font, reason .. ' ' .. hitbox, screen_pos + vec2_t(0 + render.get_text_size(font_x, 'x ').x, -render.get_text_size(font_x, 'x ').y/2 + 1), color_t(255, 0, 0, opacity))
                end
            end
        end
    end
end

callbacks.add(e_callbacks.AIMBOT_MISS, on_miss)
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_shoot)
callbacks.add(e_callbacks.PAINT, on_paint)