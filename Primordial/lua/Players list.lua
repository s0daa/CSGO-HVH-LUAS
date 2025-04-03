require('UI Callbacks')

local players = {}

local playersList = menu.add_list("Players List", "Players", players)

local function refreshPlayerlist()
    players = {}
    playersList:set_items({})

    if not engine.is_in_game() then
        return
    end

    for _,player in pairs(entity_list.get_players(false)) do

        if  not (player == entity_list.get_local_player()) then
            local infos = {name = player:get_name(), id = player:get_index(), whitelist = false, prioritize = false}
        
            table.insert(players, infos)
            playersList:add_item(infos.name)
        end
    end
end

menu.add_button("Players List", "refresh", refreshPlayerlist)

if engine.is_in_game() then
    refreshPlayerlist()
end


local whitelistCheckbox = menu.add_checkbox("Player Option", "Whitelisted", false)

local prioritizeCheckbox = menu.add_checkbox("Player Option", "Prioritized", false)


local function refreshMenu()
    local target = playersList:get_item_name(playersList:get())
    for _,player in pairs(players) do
        if player.name == target then
            whitelistCheckbox:set(player.whitelist)
            prioritizeCheckbox:set(player.prioritize)
        end
    end
end

refreshMenu()

menu.add_callback(playersList, refreshMenu)

local function setWhitelist()
    local target = playersList:get_item_name(playersList:get())
    for _,player in pairs(players) do
        if player.name == target then
            player.whitelist = whitelistCheckbox:get()
        end
    end
end

menu.add_callback(whitelistCheckbox, setWhitelist)

local function setPriority()
    local target = playersList:get_item_name(playersList:get())
    for _,player in pairs(players) do
        if player.name == target then
            player.prioritize = prioritizeCheckbox:get()
        end
    end
end

menu.add_callback(prioritizeCheckbox, setPriority)


local function on_target_selection(ctx, cmd, unpredicted_data)
    for _,target in ipairs(players) do

        if target.whitelist then
            ctx:ignore_target(target.id)
        end

        if target.prioritize then
            ctx:prioritize_target(target.id)
        end
    end

end

callbacks.add(e_callbacks.TARGET_SELECTION, on_target_selection)