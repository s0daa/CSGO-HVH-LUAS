local bomb_cb, bomb_color = ui.reference("visuals", "other esp", "bomb")
local dropped_weapons = ui.reference("visuals", "other esp", "dropped weapons")

local function get_bomb_time(bomb)
    local bomb_time = entity.get_prop(bomb, "m_flC4Blow") - globals.curtime()
    return bomb_time or 0
end

local function GetDistanceInFeet(a_x, a_y, a_z, b_x, b_y, b_z)
    return math.ceil(math.sqrt(math.pow(a_x - b_x, 2) + math.pow(a_y - b_y, 2) + math.pow(a_z - b_z, 2)) * 0.0254 / 0.3048)
end

local function round(b, c)
    local d = 10 ^ (c or 0)
    return math.floor(b * d + 0.5) / d
end

local function round_to_fifth(num)
    num = round(num, 0)
    num = num / 5
    num = round(num, 0)
    num = num * 5
    return num
end

client.set_event_callback("paint", function(ctx)
    if not ui.get(bomb_cb) then return end
    
    local c4 = entity.get_all("CC4")[1]
    if c4 ~= nil then
        local r, g, b, a = ui.get(bomb_color)
        local epx, epy, epz = entity.get_prop(c4, "m_vecOrigin")
        local lpx, lpy, lpz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if epx == 0 and epy == 0 and epz == 0 then return end
        local wx, wy = client.world_to_screen(ctx, epx, epy, epz)
      
        if wx ~= nil then
            if ui.get(dropped_weapons) == "Off" then
                client.draw_text(ctx, wx, wy, r, g, b, a, "c-", 0, "BOMB")
            end
            wy = wy - 10
            client.draw_text(ctx, wx, wy, r, g, b, a, "c-", 0, round_to_fifth(GetDistanceInFeet(lpx, lpy, lpz, epx, epy, epz)) .. "FT")
        end
    end
    
    local c4_planted = entity.get_all("CPlantedC4")[1]
    if c4_planted ~= nil and entity.get_prop(c4_planted, "m_bBombDefused") == 0 and get_bomb_time(c4_planted) > 0 then
        local r, g, b, a = ui.get(bomb_color)
        local epx, epy, epz = entity.get_prop(c4_planted, "m_vecOrigin")
        local lpx, lpy, lpz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        epz = epz + 4
        local wx, wy = client.world_to_screen(ctx, epx, epy, epz)
        if wx ~= nil then
            client.draw_text(ctx, wx, wy, r, g, b, a, "c-", 0, "BOMB")
            wy = wy - 10
            client.draw_text(ctx, wx, wy, r, g, b, a, "c-", 0, round_to_fifth(GetDistanceInFeet(lpx, lpy, lpz, epx, epy, epz)) .. "FT")
        end
    end
end)