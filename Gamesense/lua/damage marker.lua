local display_duration = 2
local speed = 1
 
local enabled_reference = ui.new_checkbox("VISUALS", "Player ESP", "Damage Indicator")
local duration_reference = ui.new_slider("VISUALS", "Player ESP", "Display Duration", 1, 10, 4)
local speed_reference = ui.new_slider("VISUALS", "Player ESP", "Speed", 1, 8, 2)
local def = ui.new_label("VISUALS", "Player ESP", "Default color")
local def_color = ui.new_color_picker("VISUALS", "Player ESP", "Default color", 255, 255, 255, 255 )
local head = ui.new_label("VISUALS", "Player ESP", "Head color")
local head_color = ui.new_color_picker("VISUALS", "Player ESP", "Head color", 149, 184, 6, 255 )
local nade = ui.new_label("VISUALS", "Player ESP", "Nade color")
local nade_color = ui.new_color_picker("VISUALS", "Player ESP", "Nade color", 255, 179, 38,255 )
local k = ui.new_label("VISUALS", "Player ESP", "Knife color")
local k_color = ui.new_color_picker("VISUALS", "Player ESP", "Knife color", 255, 255, 255, 255 )
local mind = ui.new_checkbox("VISUALS", "Player ESP", "Enabled (-)")
local minimum_damage_reference = ui.reference("RAGE", "Aimbot", "Minimum damage")
local aimbot_enabled_reference = ui.reference("RAGE", "Aimbot", "Enabled")
 
local damage_indicator_displays = {}

local hitgroup_names = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }
 
local function on_player_hurt(e)
    if not ui.get(enabled_reference) then
        return
    end
    --local userid, attacker, health, armor, weapon, damage, dmg_armor, hitgroup = e.userid, e.attacker, e.health, e.armor, e.weapon, e.dmg_damage, e.dmg_armor, e.hitgroup
    local userid, attacker, damage, health = e.userid, e.attacker, e.dmg_health, e.health
    if userid == nil or attacker == nil or damage == nil then
        return
    end
    if client.userid_to_entindex(attacker) ~= entity.get_local_player() then return end

    local player = client.userid_to_entindex(userid)
    local x, y, z = entity.get_prop(player, "m_vecOrigin")
    if x == nil or y == nil or z == nil then
        return
    end
    local voZ = entity.get_prop(player, "m_vecViewOffset[2]")
 
    table.insert(damage_indicator_displays, {damage, globals.realtime(), x, y, z + voZ, e})
end
 
local function on_enabled_change()
    local enabled = ui.get(enabled_reference)
    ui.set_visible(duration_reference, enabled)
    ui.set_visible(speed_reference, enabled)
    ui.set_visible(def_color, enabled)
    ui.set_visible(nade_color, enabled)
    ui.set_visible(head_color, enabled)
    ui.set_visible(def, enabled)
    ui.set_visible(nade, enabled)
    ui.set_visible(head, enabled)
    ui.set_visible(k, enabled)
    ui.set_visible(k_color, enabled)
    ui.set_visible(mind, enabled)
end
on_enabled_change()
ui.set_callback(enabled_reference, on_enabled_change)
 
local function on_paint(ctx)
 
    if not ui.get(enabled_reference) then
        return
    end
 
    local damage_indicator_displays_new = {}
    local max_time_delta = ui.get(duration_reference) / 2
    local speed = ui.get(speed_reference) / 3
    local realtime = globals.realtime()
    local max_time = realtime - max_time_delta / 2
    local aimbot_enabled = ui.get(aimbot_enabled_reference)
    local minimum_damage = 0
    if aimbot_enabled then
        minimum_damage = ui.get(minimum_damage_reference)
    end
    for i=1, #damage_indicator_displays do
        local damage_indicator_display = damage_indicator_displays[i]
        local damage, time, x, y, z, e = damage_indicator_display[1], damage_indicator_display[2], damage_indicator_display[3], damage_indicator_display[4], damage_indicator_display[5], damage_indicator_display[6]
        local r, g, b, a = ui.get(def_color)

        local group = hitgroup_names[e.hitgroup + 1] or "?"
	
        local wpn = e.weapon

        if time > max_time then
            local sx, sy = client.world_to_screen(ctx, x, y, z)
 
            if e.hitgroup == 1 then
                r, g, b = ui.get(head_color)
            end

            if group == "generic" then
                local wtype = {
                    ["hegrenade"] = "Naded",
                    ["inferno"] = "Burned"
                }
        
                if wtype[wpn] ~= nil then
                    r, g, b = ui.get(nade_color)
                end
                local wtype2 = {
                    ["knife"] = "Knifed"
                }
        
                if wtype2[wpn] ~= nil then
                    r, g, b = ui.get(k_color)
                end
            end
            if ui.get(mind) then
            gay = "-"
            else
            gay = ""
            end
            if (time - max_time) < 0.7 then
                a = (time - max_time) / 0.7 * 255
            end
 
            if not (sx == nil or sy == nil) then
                client.draw_text(ctx, sx, sy, r, g, b, a, "cb", 0, gay .. damage*1)
            end
            table.insert(damage_indicator_displays_new, {damage, time, x, y, z+0.4*speed, e})
        end
    end
 
    damage_indicator_displays = damage_indicator_displays_new
end
 
client.set_event_callback("player_hurt", on_player_hurt)
client.set_event_callback("paint", on_paint)
---------------------------------------hit marker

local shot_data = {}
local memory = {}

local enable = ui.new_checkbox("VISUALS", "Player ESP", "Hitmarker")
local hitmarker = ui.new_color_picker("VISUALS", "Player ESP",  "Hitmarker color", 255, 225, 225, 255)

local function paint()
    local r, g, b, a = ui.get(hitmarker)
    for tick, data in pairs(shot_data) do
        if data.draw then
            if globals.curtime() >= data.time then
                data.alpha = data.alpha - 3
            end
            
            if data.alpha <= 0 then
                data.alpha = 0
                data.draw = false
            end

            local sx, sy = renderer.world_to_screen(data.x, data.y, data.z)
            local zx, zy = renderer.world_to_screen(data.x1, data.y1, data.z1)
            if sx ~= nil then

                if  ui.get(enable) then 
                renderer.line(sx + 1, sy + 1, sx + 4, sy + 4, r, g, b, data.alpha)
                renderer.line(sx - 1, sy + 1, sx - 4, sy + 4, r, g, b, data.alpha)
                renderer.line(sx + 1, sy - 1, sx + 4, sy - 4, r, g, b, data.alpha)
                renderer.line(sx - 1, sy - 1, sx - 4, sy - 4, r, g, b, data.alpha)
                end
            end
        end
    end
end

local function hitbox_c(hitgroup)
     if hitgroup == 1 then
          return 0
     elseif hitgroup == 2 then
          return 5 
     elseif hitgroup == 3 then
          return 3
     elseif hitgroup == 4 then
          return 14 
     elseif hitgroup == 5 then
          return 15 
     elseif hitgroup == 6 then
          return 8
     elseif hitgroup == 7 then 
          return 9
     elseif hitgroup == 8 then
          return 1 
     end
end

local function aim_fire(e)
   memory[1] = {
    t_x = select(1,entity.hitbox_position(e.target, hitbox_c(e.hitgroup))),
    t_y = select(2,entity.hitbox_position(e.target, hitbox_c(e.hitgroup))),
    t_z = select(3,entity.hitbox_position(e.target, hitbox_c(e.hitgroup))),
    aboba = select(1,client.eye_position()),
    aboba1 = select(2,client.eye_position()),
    aboba2 = select(3,client.eye_position()),
   }
end

local function aim_hit(e)

if entity.is_alive(e.target) then 
h_x, h_y, h_z = entity.hitbox_position(e.target, hitbox_c(e.hitgroup))
else
h_x, h_y, h_z = memory[1].t_x, memory[1].t_y, memory[1].t_z
end
    shot_data[globals.tickcount()] = {
        time = globals.curtime() + 3,
        alpha = 255,
        draw = true,
        damage = e.damage,
        box = e.hitgroup,
        x = h_x,
        y = h_y,
        z = h_z,
        x1 = memory[1].aboba,
        y1 = memory[1].aboba1,
        z1 = memory[1].aboba2
    }
end

local function round_start()
    shot_data = { }
    memory = { }
end

client.set_event_callback("paint", paint)
client.set_event_callback("aim_hit", aim_hit)
client.set_event_callback("aim_fire", aim_fire)
client.set_event_callback("round_start", round_start)