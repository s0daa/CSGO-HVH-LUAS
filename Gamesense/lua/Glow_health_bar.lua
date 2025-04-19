local hpbar = {
    customhealthbars = ui.new_checkbox("Visuals", "Player ESP", "Custom Health bar"),
    gradient = ui.new_checkbox("Visuals", "Player ESP", "Enable Gradient"),
    label = ui.new_label("Visuals", "Player ESP", "Full Health"),
    colorpicker = ui.new_color_picker("Visuals", "Player ESP", "Full Health", 142, 214, 77, 255),
    label2 = ui.new_label("Visuals", "Player ESP", "Empty Health"),
    colorpicker2 = ui.new_color_picker("Visuals", "Player ESP", "Empty Health", 244, 48, 87, 255),
	label3 = ui.new_label("Visuals", "Player ESP", "Glow"),
    colorpicker3 = ui.new_color_picker("Visuals", "Player ESP", "Glow", 100, 48, 200, 255),
}

ui.set_visible(hpbar.gradient, ui.get(hpbar.customhealthbars))
ui.set_visible(hpbar.label, ui.get(hpbar.customhealthbars))
ui.set_visible(hpbar.label2, ui.get(hpbar.customhealthbars))
ui.set_visible(hpbar.colorpicker, ui.get(hpbar.customhealthbars))
ui.set_visible(hpbar.colorpicker2, ui.get(hpbar.customhealthbars))

local players = {

}

local render_shadow = function(x, y, w, h, width, rounding, accent, accent_inner)
    local rec = function(x, y, w, h, radius, color)
        radius = math.min(x/2, y/2, radius)
        local r, g, b, a = unpack(color)
        renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
        renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
        renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
    end
    
    local rec_outline = function(x, y, w, h, radius, thickness, color)
        radius = math.min(w/2, h/2, radius)
        local r, g, b, a = unpack(color)
        if radius == 1 then
            renderer.rectangle(x, y, w, thickness, r, g, b, a)
            renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
        else
            renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
            renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
            renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
            renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
            renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
            renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
            renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
            renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
        end
    end

    local thickness = 1
    local offset = 1
    local r, g, b, a = unpack(accent)

    if accent_inner then
        rec(x, y, w, h + 1, 50, accent_inner)
    end

    for k = 0, width do
        if a * (k/width)^(1) > 5 then
            local accent = {r, g, b, a * (k/width)^(2)}
            rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
        end
    end
end

local function lerp(a, b, percentage)
    return a + (b - a) * percentage
end

local function handle_checkbox()
    local enabled = ui.get(hpbar.customhealthbars)
    if enabled then
        ui.set(ui.reference("Visuals", "Player ESP", "Health bar"), false)
    end
    ui.set_visible(hpbar.gradient, enabled)
    ui.set_visible(hpbar.label, enabled)
    ui.set_visible(hpbar.label2, enabled)
    ui.set_visible(hpbar.colorpicker, enabled)
    ui.set_visible(hpbar.colorpicker2, enabled)
end

ui.set_callback(hpbar.customhealthbars, handle_checkbox)

client.set_event_callback("round_end", function (info)
    players = {}
end)

client.set_event_callback("paint", function()
    if ui.get(hpbar.customhealthbars) then
        local r, g, b, a = ui.get(hpbar.colorpicker)
        local r2, g2, b2, a2 = ui.get(hpbar.colorpicker2)
        local local_player = entity.get_local_player()
        local force_teammates = false or ui.get(ui.reference("Visuals", "Player ESP", "Teammates"))
        if not entity.is_alive(local_player) then
            local m_iObserverMode = entity.get_prop(local_player, "m_iObserverMode")
            if m_iObserverMode == 4 or m_iObserverMode == 5 then
                local spectated_ent = entity.get_prop(local_player, "m_hObserverTarget")
                if entity.is_enemy(spectated_ent) then
                    force_teammates = true
                end
            end
        end
        local enemy_players = entity.get_players(not force_teammates)
        for i=1,#enemy_players do
            local e = enemy_players[i]
            if entity.is_alive(local_player) or not force_teammates or force_teammates and (not entity.is_alive(local_player) and not entity.is_enemy(e)) then
                local x1, y1, x2, y2, a = entity.get_bounding_box(e)
                if x1 ~= nil and y1 ~= nil and not entity.is_dormant(e) then
                    local hp = entity.get_prop(e, "m_iHealth")
                    local height = y2 - y1 + 2
                    y1 = y1 - 1
                    local width = x2 - x1
                    local leftside = x1 - 5
                    if hp ~= nil then
                        local percentage = hp/100
                        local name = entity.get_player_name(e)
                        players[name] = {}
                        renderer.rectangle(leftside-1, y1, 4, height, 20, 20, 20, 150)
                        local new_r, new_g, new_b = lerp(r2, r, percentage), lerp(g2, g, percentage), lerp(b2, b, percentage)
						local r3,g3,b3 = ui.get(hpbar.colorpicker3)
                        if ui.get(hpbar.gradient) then
                            renderer.gradient(leftside, math.ceil(y2-(height*percentage))+2, 2, math.floor(height*percentage) - 2,  new_r, new_g, new_b, 255, r2, g2, b2, 255, false)
							render_shadow(leftside,math.ceil(y2-(height*percentage))+2,2, math.floor(height*percentage)-2,15,0,{r3,g3,b3,125}, {0,0,0,0})
                        else
                            renderer.rectangle(leftside, math.ceil(y2-(height*percentage))+2, 2, math.floor(height*percentage) - 2,  new_r, new_g, new_b, 255)
                        end
                        if hp < 100 then
                            renderer.text(leftside-2, y2-(height*percentage)+2, 255, 255, 255, 255, "-cd", 0, hp )
                        end
                        players[name] = {
                            ent = e,
                            teammate = entity.is_enemy(e),
                            health = hp,
                            health_percentage = percentage,
                            active = false,
                            alpha = 255,
                        }
                    end
                end
            end
        end
        if entity.is_alive(local_player) then
            for k,v in pairs(players) do
                if not v.active and entity.is_alive(v.ent) then
                    local x1, y1, x2, y2, a = entity.get_bounding_box(v.ent)
                    if x1 ~= nil and y1 ~= nil then
                        local height = y2 - y1 + 2
                        y1 = y1 - 1
                        local width = x2 - x1
                        local leftside = x1 - 5
                        local percentage = v.health_percentage
                        local hp = v.health
                        renderer.rectangle(leftside-1, y1, 4, height, 20, 20, 20, 150 * (players[k].alpha/255))
                        players[k].alpha = players[k].alpha - 0.25
                        local new_r, new_g, new_b = lerp(r2, r, percentage), lerp(g2, g, percentage), lerp(b2, b, percentage)
                        if ui.get(hpbar.gradient) then
                            renderer.gradient(leftside, math.ceil(y2-(height*percentage))+2, 2, math.floor(height*percentage) - 2,  new_r, new_g, new_b, players[k].alpha, r2, g2, b2, players[k].alpha, false)
                        else
                            renderer.rectangle(leftside, math.ceil(y2-(height*percentage))+2, 2, math.floor(height*percentage) - 2,  new_r, new_g, new_b, players[k].alpha)
                        end
                        if hp < 100 then
                            renderer.text(leftside-2, y2-(height*percentage)+2, 255, 255, 255, players[k].alpha, "-cd", 0, hp )
                        end
                    end
                end
                if v.alpha < 0 then
                    players[k] = nil
                end
            end
        end
    end
end)