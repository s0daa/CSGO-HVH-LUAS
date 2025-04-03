-- Clantag

local ffi = require("ffi")

local clantag = ffi.cast("int(__fastcall*)(const char*, const char*)", memory.find_pattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15"))
local last_clantag = nil

local function set_clantag(value)
    if value ~= last_clantag then
        clantag(value, value)
        last_clantag = value
    end
end

-- Menu

local selected_player = menu.add_selection("Clantag", "Stealer", {})

local function on_update_players()
    selected_player:set_items({"Off"})
    selected_player:set(1)

    if not entity_list.get_local_player() then
        return
    end

    for k, v in pairs(entity_list.get_players()) do
        if v:get_index() ~= engine.get_local_player_index() then
            selected_player:add_item(v:get_name())
        end
    end
end

local update_players = menu.add_button("Clantag", "Update players", on_update_players)

-- Callbacks

local function on_paint()
    if selected_player:get() == 1 or not entity_list.get_local_player() then
        set_clantag("")
        return
    end

    for k, v in pairs(entity_list.get_players()) do
        if selected_player:get_item_name(selected_player:get()) == v:get_name() then
            set_clantag(player_resource.get_prop("m_szClan", v:get_index()))
        end
    end
end

local function on_shutdown()
    set_clantag("")
end

callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)

on_update_players()