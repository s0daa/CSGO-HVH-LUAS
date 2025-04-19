--vars
local time = 10
local r_h, g_h, b_h, a_h = 255, 0, 0, 255
local r_m, g_m, b_m, a_m = 255, 255, 255, 10

local hitgroup_data = {
    {0}, --head/neck
    {6, 5}, --chest
    {2, 3, 4}, --stomach/pelvis
    {15, 16}, --left arm
    {17, 18}, --right arm
    {7, 9, 11}, --left leg
    {8, 10, 12}, --right leg
    {1}, --neck
}

--refs
local ui_enabled = ui.new_checkbox("VISUALS", "Other ESP", "Detailed wireframe hit")
local ui_color_hit = ui.new_color_picker("VISUALS", "Other ESP", "Detailed wireframe hit", 255, 0, 0, 255)
local ui_color_miss = ui.new_color_picker("VISUALS", "Other ESP", "Detailed wireframe miss", 255, 255, 255, 10)
local ui_time = ui.new_slider("VISUALS", "Other ESP", "Detailed wireframe time", 5, 300, 10, true, "s", 0.1)

--util funcs
local function draw_hitgroup(entidx, hitgroup, tick)
    local hitboxes = hitgroup
    if hitgroup < 1 or hitgroup > 8 then 
        client.draw_hitboxes(entidx, time, 19, r_h, g_h, b_h, a_h, tick)
    else
        for i = 1, #hitgroup_data do 
            local r, g, b, a = r_m, g_m, b_m, a_m
            if hitgroup == i then 
                r, g, b, a = r_h, g_h, b_h, a_h
            end
            if a ~= 0 then 
                for n = 1, #hitgroup_data[i] do 
                    client.draw_hitboxes(entidx, time, hitgroup_data[i][n], r, g, b, a, tick)
                end
            end
        end
    end
end

--callback funcs
local function hurt_handler(event)
    if client.userid_to_entindex(event.attacker) == entity.get_local_player() or client.userid_to_entindex(event.attacker) == entity.get_prop(entity.get_local_player(), "m_hObserverTarget") then 
        draw_hitgroup(client.userid_to_entindex(event.userid), event.hitgroup, globals.tickcount())
    end
end

--ui callbacks
do  
    ui.set_callback(ui_enabled, function()
        local state = ui.get(ui_enabled)

        local update_callback = state and client.set_event_callback or client.unset_event_callback
        update_callback("player_hurt", hurt_handler)

        ui.set_visible(ui_color_hit, state)
        ui.set_visible(ui_color_miss, state)
        ui.set_visible(ui_time, state)
    end)

    local state = ui.get(ui_enabled)

    local update_callback = state and client.set_event_callback or client.unset_event_callback
    update_callback("player_hurt", hurt_handler)

    ui.set_visible(ui_color_hit, state)
    ui.set_visible(ui_color_miss, state)
    ui.set_visible(ui_time, state)

    ui.set_callback(ui_color_hit, function()
        r_h, g_h, b_h, a_h = ui.get(ui_color_hit)
    end)
    r_h, g_h, b_h, a_h = ui.get(ui_color_hit)

    ui.set_callback(ui_color_miss, function()
        r_m, g_m, b_m, a_m = ui.get(ui_color_miss)
    end)
    r_m, g_m, b_m, a_m = ui.get(ui_color_miss)

    ui.set_callback(ui_time, function()
        time = ui.get(ui_time)*0.1
    end)
    time = ui.get(ui_time)*0.1
end