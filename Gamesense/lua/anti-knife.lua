local anti_media = ui.new_checkbox("AA", "Other", "Anti-knife")


local event_handler_functions = {
    [true]  = client.set_event_callback,
    [false] = client.unset_event_callback,
}

local function get_distance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

local function on_run_command()
    local players = entity.get_players(true)
    local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
	local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
    for i=1, #players do
        local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
        local distance = get_distance(lx, ly, lz, x, y, z)
        local weapon = entity.get_player_weapon(players[i])
        if entity.get_classname(weapon) == "CKnife" and distance <= 230 then
            ui.set(yaw_slider,180)
        end
    end
end

local function on_script_toggle_change()
    local state = ui.get(anti_media)
    local handle_event = event_handler_functions[state]
    handle_event("run_command", on_run_command)
end

on_script_toggle_change()
ui.set_callback(anti_media, on_script_toggle_change)