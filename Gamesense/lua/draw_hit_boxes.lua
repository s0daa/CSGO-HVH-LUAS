--------------------------------------------------------------------------------
-- Caching common functions
--------------------------------------------------------------------------------
local client_draw_hitboxes, client_set_event_callback, client_userid_to_entindex, entity_get_local_player, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_slider, ui_set_callback, ui_set_visible = client.draw_hitboxes, client.set_event_callback, client.userid_to_entindex, entity.get_local_player, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.set_callback, ui.set_visible

--------------------------------------------------------------------------------
-- Menu
--------------------------------------------------------------------------------
local enabled   = ui_new_checkbox("LUA", "A", "Draw hitbox")
local color     = ui_new_color_picker("LUA", "A", "Color", 255, 255, 255, 255)
local mode      = ui_new_combobox("LUA", "A", "Mode", "Full", "Hitgroup")
local duration  = ui_new_slider("LUA", "A", "\n", 1, 10000, 1000, true, "s", 0.001)

local function handle_menu()
    local state = ui_get(enabled)
    ui_set_visible(mode, state)
    ui_set_visible(duration, state)
end

handle_menu()
ui_set_callback(enabled, handle_menu)

--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local hitgroups = {
    [1] = {0, 1},
    [2] = {4, 5, 6},
    [3] = {2, 3},
    [4] = {13, 15, 16},
    [5] = {14, 17, 18},
    [6] = {7, 9, 11},
    [7] = {8, 10, 12}
}

--------------------------------------------------------------------------------
-- Game event handling
--------------------------------------------------------------------------------
local function player_hurt(e)
    if not ui_get(enabled) then
        return
    end
    local r, g, b, a    = ui_get(color)
    local duration      = ui_get(duration) * 0.001
    local victim_entindex   = client_userid_to_entindex(e.userid)
    local attacker_entindex = client_userid_to_entindex(e.attacker)
    if attacker_entindex ~= entity_get_local_player() then
        return
    end
    if ui_get(mode) == "Hitgroup" then
        client_draw_hitboxes(victim_entindex, duration, hitgroups[e.hitgroup], r, g, b, a)
    else
        client_draw_hitboxes(victim_entindex, duration, 19, r, g, b, a)
    end
end

client_set_event_callback("player_hurt", player_hurt)