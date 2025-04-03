local panorama = require 'primordial/panorama-library.248'
local js = panorama.open()

local delay = {
    tick_delay = client.time_to_ticks(1),
    last_tick = globals.tick_count()
}
local menu = {
    enemy_only =  menu.add_checkbox("Mute/Unmute", "Enemy only", false),
    selection = menu.add_selection("Mute/Unmute", "Toggle", {"Mute", "Unmute"})
}

local function mutePlayers()
    local players = entity_list.get_players(menu.enemy_only:get())
    if players then
        for _, player in pairs(players) do 
            local xuid = js.GameStateAPI.GetPlayerXuidStringFromEntIndex(player:get_index())
            if menu.selection:get() == 1 and js.GameStateAPI.IsSelectedPlayerMuted(xuid) == false then 
                js.GameStateAPI.ToggleMute(xuid)
            elseif menu.selection:get() == 2 and js.GameStateAPI.IsSelectedPlayerMuted(xuid) == true then
                js.GameStateAPI.ToggleMute(xuid)
            end
        end
    end
end

callbacks.add(e_callbacks.PAINT, function()
    if not engine.is_connected() then return end
    if globals.tick_count() - delay.last_tick > delay.tick_delay then
        delay.last_tick = globals.tick_count()
        mutePlayers()
    end
end)