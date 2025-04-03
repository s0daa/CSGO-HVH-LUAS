-- ported this form my lua inferno lua cuz why not :)

local c_func = {}

local e_hitboxes = {
    [0] = 'generic',
    'head', 
    'chest', 
    'stomach',
    'left arm', 
    'right arm',
    'left leg', 
    'right leg',
    'neck', 
    'generic', 
    'gear',
    '?',
}

c_func.get_distance = function(vec_1, vec_2)
    return math.sqrt(math.pow(vec_1.x - vec_2.x, 2) + math.pow(vec_1.y - vec_2.y, 2) + math.pow(vec_1.z - vec_2.z, 2))
end

c_func.get_closest_target = function()
    local lp = entity_list.get_local_player()
    if not lp or lp:get_prop("m_lifeState") ~= 0 then return end

    local target = nil
    local distance = math.huge
    for i=1, 64 do
        local entity = entity_list.get_entity(i)
        if not entity then goto skip end
        if not entity:is_enemy() then goto skip end
        if (entity:get_prop("m_lifeState") ~= 0) then goto skip end

        local origin = entity:get_render_origin()
        local cur_distance = c_func.get_distance(origin, lp:get_render_origin())

        if (cur_distance < distance) then
            distance = cur_distance
            target = entity
        end

        ::skip::
    end

    return target
end

c_func.get_visible_state = function(p_entity)
    local lp = entity_list.get_local_player()
    if not lp or not p_entity then return false end 

    for i, v in pairs(e_hitboxes) do 
        local h_pos = p_entity:get_hitbox_pos(i) 
        if (lp:is_point_visible(h_pos)) then return true end 
    end

    return false
end

local c_rage = {}

c_rage.knife_dt = function()
    if not engine.is_connected() or not engine.is_in_game() then return end

    local enemies_only = entity_list.get_players(true)
    if not enemies_only then return end

    local chrage_max = exploits.get_max_charge()
    local charge_cur = exploits.get_charge()

    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_player() or not local_player:is_alive() then return end

    local weapon = local_player:get_active_weapon()
    if not weapon then return end

    local weapon_name = weapon:get_name()
    if not weapon_name then return end
            
    for _, enemy in pairs(enemies_only) do
        if not enemy or not enemy:is_player() then return end
        if not c_func.get_closest_target() or c_func.get_closest_target():is_dormant() then return end

        local distance = math.floor(c_func.get_closest_target():get_render_origin():dist(entity_list.get_local_player():get_render_origin()) / 17)
        if not c_func.get_closest_target():is_alive() or c_func.get_closest_target():is_dormant() then 
            if distance > 2 then
                exploits.allow_recharge()
            end
        end
        
        local enemy_visible = false

        if c_func.get_visible_state(c_func.get_closest_target()) then
            enemy_visible = true
        end

        if distance <= 8 then
            if weapon_name == "knife" then
                if charge_cur == tonumber(chrage_max) and enemy_visible then
                    exploits.force_uncharge()
                elseif charge_cur == 0 then
                     exploits.block_recharge()
                end
            end
        elseif distance > 2 then
            exploits.allow_recharge()
        end
    end
end

callbacks.add(e_callbacks.SETUP_COMMAND, c_rage.knife_dt)