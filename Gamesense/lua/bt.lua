

local backtrack_enabled = ui.new_checkbox("Lua", "A", "bt exploit made by RAZE")
local backtrack_ticks = ui.new_slider("Lua", "A", "backtrack ticks", 1, 32, 12)


local backtrack_data = {}


client.set_event_callback("setup_command", function(cmd)
    if not ui.get(backtrack_enabled) then return end
    
    local local_player = entity.get_local_player()
    if not entity.is_alive(local_player) then return end

    local enemies = entity.get_players(true)
    local current_tick = globals.tickcount()

    for _, enemy in ipairs(enemies) do
        if not entity.is_alive(enemy) then goto continue end

        local x, y, z = entity.hitbox_position(enemy, "head")
        if x and y and z then
            backtrack_data[enemy] = backtrack_data[enemy] or {}
            table.insert(backtrack_data[enemy], {tick = current_tick, pos = {x, y, z}})

            if #backtrack_data[enemy] > ui.get(backtrack_ticks) then
                table.remove(backtrack_data[enemy], 1)
            end
        end
        ::continue::
    end
end)

client.set_event_callback("create_move", function(cmd)
    if not ui.get(backtrack_enabled) then return end

    local local_player = entity.get_local_player()
    if not entity.is_alive(local_player) then return end

    for enemy, data in pairs(backtrack_data) do
        if not data or #data == 0 then goto continue end

        local best_tick = data[1]
        if best_tick and globals.tickcount() - best_tick.tick <= ui.get(backtrack_ticks) then
            cmd.tickcount = best_tick.tick
        end

        ::continue::
    end
end)



client.color_log(0, 255, 0, "successfully loaded!")
client.color_log(0, 255, 0, "by pabianicki x sticzus")
client.color_log(0, 255, 0, "discord.gg/cTnK7NUjmY")
client.color_log(0, 255, 0, "discord.gg/cTnK7NUjmY")
client.color_log(0, 255, 0, "discord.gg/cTnK7NUjmY")
client.color_log(0, 255, 0, "discord.gg/cTnK7NUjmY")
client.color_log(0, 255, 0, "discord.gg/cTnK7NUjmY")
client.color_log(0, 255, 0, "discord.gg/cTnK7NUjmY")
client.color_log(0, 255, 0, "discord.gg/cTnK7NUjmY")


