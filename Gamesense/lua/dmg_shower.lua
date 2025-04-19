local vector = require("vector")
local csgo_weapons = require("gamesense/csgo_weapons")
local configure_combobox = ui.new_combobox( "RAGE", "Other", "Hitbox Selection",  
"Stomach",
"Chest",
"Leg/feets"
)
local static_mode_combobox =
    ui.new_multiselect(
    "RAGE", "Other", "Enable Hit Mark on:",  
    "Head",
    "Chest",
    "Stomach",
    "Leg/feets"
)

local function contains(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end
-- Different hitbox's damage display on bounding box
local function hitbox_selection()
    local owo = ui.get(configure_combobox)
    if owo == "Stomach" then return 1.25 end
    if owo == "Chest" then return 1 end
    if owo == "Leg/feets" then return 0.75 end
end
--  Displaying different hitbox
local function hitbox_selection_hitbox()
    local lethal_head = 0
    local lethal_chest = 0
    local lethal_stomach = 0 
    local lethal_pelvis = 0
    if contains(ui.get(static_mode_combobox), "Head") then
        lethal_head = 255
    end
    if contains(ui.get(static_mode_combobox), "Chest") then
        lethal_chest = 255
    end
    if contains(ui.get(static_mode_combobox), "Stomach") then
        lethal_stomach = 255
    end
    if contains(ui.get(static_mode_combobox), "Leg/feets") then
        lethal_pelvis = 255
    end
    return lethal_head, lethal_chest, lethal_stomach, lethal_pelvis
end
-- owo
local function on_paint()
    local players = entity.get_players(true)
    local local_player = entity.get_local_player()
    if local_player == nil or not entity.is_alive(local_player) then return end
    local weapon_ent = entity.get_player_weapon(entity.get_local_player())
	local alpha = {hitbox_selection_hitbox()}
	local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
    for i = 1, #players do
        local player_index = players[i]
        --Actual Damage Calculation
        local weapon = csgo_weapons[weapon_idx]
        local local_origin = vector(entity.get_prop(local_player, "m_vecAbsOrigin"))
        local distance = local_origin:dist(vector(entity.get_prop(player_index, "m_vecOrigin")))	
        local weapon_adjust = weapon.damage
        local dmg_after_range = (weapon_adjust * math.pow(weapon.range_modifier, (distance * 0.002)))
        local armor = entity.get_prop(player_index,"m_ArmorValue")
        local newdmg = dmg_after_range * (weapon.armor_ratio * 0.5)
        if dmg_after_range - (dmg_after_range * (weapon.armor_ratio * 0.5)) * 0.5 > armor then
            newdmg = dmg_after_range - (armor / 0.5)
        end
        --Damage display
        local newdmg_indi = newdmg * hitbox_selection()
        --Stomach array
        local stomach_x, stomach_y, stomach_z = entity.hitbox_position(player_index, 3)
		local wx, wy = renderer.world_to_screen(stomach_x, stomach_y, stomach_z)
        --Chest array
        local chest_x, chest_y, chest_z = entity.hitbox_position(player_index, 5)
		local cx, cy = renderer.world_to_screen(chest_x, chest_y, chest_z)
        --Head array
        local head_x, head_y, head_z = entity.hitbox_position(player_index, 0)
		local hx, hy = renderer.world_to_screen(head_x, head_y, head_z)
        --Leg array
        local pelvis_x, pelvis_y, pelvis_z = entity.hitbox_position(player_index, 8)
		local px, py = renderer.world_to_screen(pelvis_x, pelvis_y, pelvis_z)
        local pelvis_x2, pelvis_y2, pelvis_z2 = entity.hitbox_position(player_index, 7)
		local mx, my = renderer.world_to_screen( pelvis_x2, pelvis_y2, pelvis_z2)
        local enemy_target_idx = client.current_threat()
        --Check is Hitbox lethal
        local enemy_health = entity.get_prop(player_index, "m_iHealth")
        local is_lethal_indi = enemy_health >= newdmg_indi
        local is_lethal_stomach = enemy_health >= (newdmg * 1.25)
        local is_lethal_chest = enemy_health >= newdmg 
        local is_lethal_head = enemy_health >= newdmg * 4
        local is_lethal_pelvis = enemy_health >= newdmg * 0.75
        -- Get enemy bounding box array
        local x1, y1, x2, y2, mult = entity.get_bounding_box(player_index)
        if x1 ~= nil and mult > 0 then
            y1 = y1 - 17
            x1 = x1 + ((x2 - x1) / 2)
            if y1 ~= nil then 
                --Rendering actual damage
                renderer.text(x1, y1, is_lethal_indi and 255 or 253, is_lethal_indi and 255 or 69,  is_lethal_indi and 255 or 106, 255, "cb", 0,  math.floor(newdmg_indi)) 
                --Rendering Legs
                renderer.text(px, py, 253, 69, 106, alpha[4], "cbd", 0, is_lethal_pelvis and " " or "+" )  
                renderer.text(mx, my, 253, 69, 106, alpha[4], "cbd", 0, is_lethal_pelvis and " " or "+" )  
                --Rendering stomachs
                renderer.text(wx, wy, 253, 69, 106, alpha[3], "cbd", 0, is_lethal_stomach and "" or "+" )
                --Rendering chests
                renderer.text(cx, cy, 253, 69, 106, alpha[2], "cbd", 0, is_lethal_chest and " " or "+" )  
                --Redndering Heads
                renderer.text(hx, hy, 253, 69, 106, alpha[1], "cbd", 0, is_lethal_head and " " or "+" )  
                if player_index == enemy_target_idx  then
                    --Display current threat
                    renderer.text(x1 + 12, y1, 255, 255,  255, 255, "cbd", 0, "-") 
                    renderer.text(x1 - 12, y1, 255, 255,  255, 255, "cbd", 0, "-")
                        
                    end
                end
            end
        end
    end

client.set_event_callback('paint', on_paint)