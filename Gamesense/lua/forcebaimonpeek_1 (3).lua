local vector = require "vector"
local entity = require "gamesense/entity"

local antiaim_funcs = require 'gamesense/antiaim_funcs'
local csgo_weapons = require "gamesense/csgo_weapons"

local enable_checkbox = ui.new_checkbox("RAGE", "Other", "Force baim on lethal")
local settings = ui.new_multiselect("RAGE", "Other", "\n", "Extrapolate local player", "Double tap")

local double_tap, double_tap_hotkey = ui.reference("Rage", "Other", "Double tap")

local esp_callback_enabled = false

local hitbox_indices = {
    2, 3, 4, 5, 7, 8
}

local last_target = nil

local function contains(table, val)
	for i=1,#table do
		if table[i] == val then
			return true
		end
	end
	return false
end

local function extrapolate_pos (player, position, ticks)
    local velocity = vector(player:get_prop("m_vecVelocity"))

    return position + velocity * ticks * globals.tickinterval()
end

--cleaning up old records
local function restore_all_plist (enemies)
    for _, enemy in ipairs(enemies) do
        plist.set(enemy:get_entindex(), "Override prefer body aim", "-")
    end
end

local function get_highest_baim_damage (local_player, trace_position, enemy)
    local highest_damage = 0

    for i = 1, #hitbox_indices do
        local enemy_hitbox_pos = vector(enemy:hitbox_position(hitbox_indices[i]))
        local _, damage = local_player:trace_bullet(trace_position.x, trace_position.y, trace_position.z, 
        enemy_hitbox_pos.x, enemy_hitbox_pos.y, enemy_hitbox_pos.z, false)
        
        if damage > highest_damage then
            highest_damage = damage
        end
    end

    return highest_damage
end

-- so that it only works for a bunch of weapons where it would make sense to apply this feature
local function valid_dt_weapon (weapon)
    return weapon and weapon.cycletime and weapon.cycletime >= 0.2 and weapon.cycletime <= 0.3
end

local function should_enable_fbaim (weapon, threat_health, highest_baim_damage)
    -- if we can hit a lethal shot on the player's body
    if highest_baim_damage >= threat_health then
        return true
    end

    local dt_active = ui.get(double_tap) and ui.get(double_tap_hotkey) and antiaim_funcs.get_tickbase_shifting() > 2

    if dt_active and contains(ui.get(settings), "Double tap") then
        return valid_dt_weapon(weapon) and (highest_baim_damage * 2 >= threat_health)
    end

    return false
end


local function on_setup_command (c)
	local threat = entity.new(client.current_threat())

    if threat == nil then
        return
    end

    local local_player = entity.get_local_player()
    local threat_idx = threat:get_entindex()
    
    local eye_pos_local = vector(client.eye_position())
    local trace_pos = contains(ui.get(settings), "Extrapolate local player") and 
        extrapolate_pos(local_player, eye_pos_local, 10) or eye_pos_local

    local highest_baim_damage = get_highest_baim_damage(local_player, trace_pos, threat)
    local threat_health = threat:get_prop("m_iHealth")

	local weapon_ent = local_player:get_player_weapon()
    local weapon_data = csgo_weapons(weapon_ent:get_entindex())

    local should_enable = should_enable_fbaim(weapon_data, threat_health, highest_baim_damage)

    if last_target ~= nil and last_target:get_entindex() ~= threat_idx then
        plist.set(last_target:get_entindex(), "Override prefer body aim", "-")
    end

    last_target = threat

    plist.set(threat_idx, "Override prefer body aim", 
        should_enable and "Force" or "-") 
end

local function handle_esp_callback (idx)
    return ui.get(enable_checkbox) and plist.get(idx, "Override prefer body aim") == "Force"
end


ui.set_callback(enable_checkbox, function ()
    local enabled = ui.get(enable_checkbox)
    local handler_func = enabled and client.set_event_callback or client.unset_event_callback

    handler_func("setup_command", on_setup_command)
    handler_func("round_prestart", function ()
        restore_all_plist(entity.get_players(true))
    end)
    
    if not esp_callback_enabled then
        client.register_esp_flag("FORCE", 255, 255, 255, handle_esp_callback)
        esp_callback_enabled = true
    end
end)