local function world_point_visible(origin)
    local screen_size = render.get_screen_size()
    local w2s = render.world_to_screen(origin)

    if w2s == nil then return false end

    if w2s.x < 0 or w2s.x > screen_size.x or w2s.y < 0 or w2s.y > screen_size.y then
        return false
    else
        return true
    end
end

local counter = {}

local function counter_up(var)
    if counter[var] == nil then counter[var] = 0 end
    counter[var] = counter[var] + 1
end

callbacks.add(e_callbacks.EVENT, function(event)
    local ded_user = entity_list.get_player_from_userid(event.userid)
    if ded_user ~= nil then
        local d_steamID3, d_steamID64 = ded_user:get_steamids()
        counter[d_steamID64] = 0
    end

    local attacker = entity_list.get_player_from_userid(event.attacker)
    if attacker ~= nil then
        local a_steamID3, a_steamID64 = attacker:get_steamids()
        counter_up(a_steamID64)
    end
end, "player_death")

callbacks.add(e_callbacks.EVENT, function(event)
    counter = {}
end, "round_start")

local main_font = render.create_font("seguibl.ttf", 10, 800, e_font_flags.OUTLINE)

callbacks.add(e_callbacks.PLAYER_ESP, function(ctx)
    local player = ctx.player
    local steamID3, steamID64 = player:get_steamids()

    if counter[steamID64] == nil then return end
    if counter[steamID64] < 1 then return end
    if not world_point_visible(ctx.render_origin) then return end

    local box_start = ctx.bbox_start
    local box_size = ctx.bbox_size

    local alpha = math.floor(ctx.alpha_modifier * 255)
    local color = counter[steamID64] > 4 and color_t(125, 235, 125, alpha) or color_t(235, 125, 125, alpha)

    render.text(main_font, counter[steamID64] .. "k", vec2_t(box_start.x + box_size.x, box_start.y - 22), color, true)
end)