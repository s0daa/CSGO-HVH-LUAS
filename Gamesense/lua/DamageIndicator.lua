local ui_get = ui.get
local ui_set = ui.set
local ui_set_visible = ui.set_visible
local globals_tickcount = globals.tickcount
local globals_tickinterval = globals.tickinterval
local globals_realtime = globals.realtime
local client_world_to_screen = client.world_to_screen
local client_draw_text = client.draw_text
local string_format = string.format
local globals_tickcount = globals.tickcount
local entity_get_prop = entity.get_prop
local table_insert = table.insert
 
local display_duration = 2
local speed = 1
 
local enabled_reference = ui.new_checkbox("VISUALS", "Player ESP", "Damage Indicator")
local duration_reference = ui.new_slider("VISUALS", "Player ESP", "Display Duration", 1, 10, 4)
local speed_reference = ui.new_slider("VISUALS", "Player ESP", "Speed", 1, 8, 2)
local minimum_damage_reference = ui.reference("RAGE", "Aimbot", "Minimum damage")
local aimbot_enabled_reference = ui.reference("RAGE", "Aimbot", "Enabled")
 
local damage_indicator_displays = {}
 
local function on_player_hurt(e)
    if not ui_get(enabled_reference) then
        return
    end
    --local userid, attacker, health, armor, weapon, damage, dmg_armor, hitgroup = e.userid, e.attacker, e.health, e.armor, e.weapon, e.dmg_damage, e.dmg_armor, e.hitgroup
    local userid, attacker, damage, health = e.userid, e.attacker, e.dmg_health, e.health
    if userid == nil or attacker == nil or damage == nil then
        return
    end
 
    local player = client.userid_to_entindex(userid)
    local x, y, z = entity_get_prop(player, "m_vecOrigin")
    if x == nil or y == nil or z == nil then
        return
    end
    local voZ = entity_get_prop(player, "m_vecViewOffset[2]")
 
    table_insert(damage_indicator_displays, {damage, globals_realtime(), x, y, z + voZ, e})
end
 
local function on_enabled_change()
    local enabled = ui_get(enabled_reference)
    ui_set_visible(duration_reference, enabled)
    ui_set_visible(speed_reference, enabled)
end
on_enabled_change()
ui.set_callback(enabled_reference, on_enabled_change)
 
local function on_paint(ctx)
 
    if not ui_get(enabled_reference) then
        return
    end
 
    local damage_indicator_displays_new = {}
    local max_time_delta = ui_get(duration_reference) / 2
    local speed = ui_get(speed_reference) / 3
    local realtime = globals_realtime()
    local max_time = realtime - max_time_delta / 2
    local aimbot_enabled = ui_get(aimbot_enabled_reference)
    local minimum_damage = 0
    if aimbot_enabled then
        minimum_damage = ui_get(minimum_damage_reference)
    end
 
    for i=1, #damage_indicator_displays do
        local damage_indicator_display = damage_indicator_displays[i]
        local damage, time, x, y, z, e = damage_indicator_display[1], damage_indicator_display[2], damage_indicator_display[3], damage_indicator_display[4], damage_indicator_display[5], damage_indicator_display[6]
        local r, g, b, a = 255, 255, 255, 255
        if time > max_time then
            local sx, sy = client_world_to_screen(ctx, x, y, z)
 
            if e.hitgroup == 1 then
                r, g, b = 149, 184, 6
            end
            if damage < minimum_damage and e.health ~= 0 then
                r, g, b = 255, 0, 0
            end
           
            if (time - max_time) < 0.7 then
                a = (time - max_time) / 0.7 * 255
            end
 
            if not (sx == nil or sy == nil) then
                client_draw_text(ctx, sx, sy, r, g, b, a, "c", 0, damage)
            end
            table_insert(damage_indicator_displays_new, {damage, time, x, y, z+0.4*speed, e})
        end
    end
 
    damage_indicator_displays = damage_indicator_displays_new
end
 
client.set_event_callback("player_hurt", on_player_hurt)
client.set_event_callback("paint", on_paint)