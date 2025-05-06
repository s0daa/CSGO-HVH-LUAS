-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_eye_position, client_register_esp_flag, client_trace_bullet, entity_get_local_player, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, plist_get, plist_set, require, ui_new_checkbox, pairs, ui_get, ui_set_callback, client_set_event_callback, client_unset_event_callback = client.eye_position, client.register_esp_flag, client.trace_bullet, entity.get_local_player, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, plist.get, plist.set, require, ui.new_checkbox, pairs, ui.get, ui.set_callback, client.set_event_callback, client.unset_event_callback

local vector = require('vector')

local master_switch = ui_new_checkbox("LUA", "A", "Force Baim if Lethal")

local baim_hitboxes = {3,4,5,6}

function extrapolate_position(xpos,ypos,zpos,ticks,player)
	local x,y,z = entity_get_prop(player, "m_vecVelocity")
	for i = 0, ticks do
		xpos =  xpos + (x * globals.tickinterval())
		ypos =  ypos + (y * globals.tickinterval())
		zpos =  zpos + (z * globals.tickinterval())
	end
	return xpos,ypos,zpos
end

local function is_baimable(ent, localplayer)	
    local final_damage  = 0

    local eyepos_x, eyepos_y, eyepos_z = client_eye_position()
    local  fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z

    eyepos_x, eyepos_y, eyepos_z = extrapolate_position(eyepos_x, eyepos_y, eyepos_z, 20, localplayer)

    fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z = eyepos_x, eyepos_y, eyepos_z
    for k,v in pairs(baim_hitboxes) do
        local hitbox    = vector(entity_hitbox_position(ent, v))
	    local ___, dmg  = client_trace_bullet(localplayer, fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z, hitbox.x, hitbox.y, hitbox.z, true)
	
	    if ( dmg > final_damage) then
            final_damage = dmg
        end
	end
    
    return final_damage
end

local function on_run_command()
    local me        = entity_get_local_player()
    local weapon    = entity_get_player_weapon(me)
    local players   = entity_get_players()

    if weapon == nil then return end

    for i=1, #players do
        local player        = players[i]
        local target_health = entity_get_prop(player, "m_iHealth") 
        local is_lethal     = is_baimable(player, me) >= target_health

        if ( target_health <= 0 ) then return end

        if (is_lethal) then 
            plist_set(player, "Override prefer body aim", "Force")
            --print("lethal")
        else 
            plist_set(player, "Override prefer body aim", "-")
        end
    end
end

client_register_esp_flag("BAIM", 255, 0, 0, function(player)
    if not ui_get(master_switch) then return false end

    return plist_get(player, "Override prefer body aim") == "Force"
end)

ui_set_callback(master_switch, function()
    local enabled            = ui_get(master_switch)
    local update_callback    = enabled and client_set_event_callback or client_unset_event_callback

    update_callback("run_command", on_run_command)
end)