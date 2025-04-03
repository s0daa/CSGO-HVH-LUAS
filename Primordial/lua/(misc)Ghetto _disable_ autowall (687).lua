local autofire = menu.find("aimbot","general","aimbot", "autofire")
local awall = menu.add_checkbox("Ghetto-Awall", "A-WAll", false)
local awallbind = awall:add_keybind("A-Wall keybind")

local is_point_visible = function(ent)
    local e_pos_L = ent:get_hitbox_pos(e_hitgroups.LEFT_ARM)
    local e_pos_R = ent:get_hitbox_pos(e_hitgroups.RIGHT_ARM)
    if entity_list.get_local_player():is_point_visible(e_pos_L or e_pos_R) then
        return true
    else
        return false
    end
end

local function ghettoawall()
    local enemies = entity_list.get_players(true)
    local can_see = false

    for _, enemy in pairs(enemies) do
        if is_point_visible(enemy) then
            can_see = true
        end
    end

    if awallbind:get() then
        awall:set(true)
    else
        awall:set(false)
    end

    if awall:get() then
        autofire:set(true)
    end

    if not awall:get() and can_see then
        autofire:set(true)
    elseif not awall:get() then
        autofire:set(false)
    end
end

callbacks.add(e_callbacks.RUN_COMMAND, ghettoawall)