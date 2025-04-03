local penetration = ui.new_checkbox('LUA', 'B', 'Penetration indicator')
local color = ui.new_color_picker('LUA', 'B', '\nPenetration indicator color', 124, 195, 13, 255)
local position = ui.new_slider('LUA', 'B', 'Position indicator', -50, 50, -25, true, 'px')
local rainbow = ui.new_checkbox('LUA', 'B', 'Rainbow mode')
local speed = ui.new_slider('LUA', 'B', '\nSpeed rainbow', 1, 100, 50, true, '%', 1)

local wpn_ignored = { -- weapon blacklist
	'CKnife',
	'CWeaponTaser',
	'CC4',
	'CHEGrenade',
	'CSmokeGrenade',
	'CMolotovGrenade',
	'CSensorGrenade',
	'CFlashbang',
	'CDecoyGrenade',
	'CIncendiaryGrenade'
}

local function contains(tbl, val) 
    for i=1,#tbl do 
        if tbl[i] == val then 
            return true 
        end
    end 
    return false 
end

local function angle_forward(angle) 
    local sin_pitch = math.sin(math.rad(angle[1]))
    local cos_pitch = math.cos(math.rad(angle[1]))
    local sin_yaw = math.sin(math.rad(angle[2]))
    local cos_yaw = math.cos(math.rad(angle[2]))

    return {        
        cos_pitch * cos_yaw,
        cos_pitch * sin_yaw,
        -sin_pitch
    }
end

local function hsv_to_rgb(h, s, v)
	local r, g, b

	local i = math.floor(h * 6);
	local f = h * 6 - i;
	local p = v * (1 - s);
	local q = v * (1 - f * s);
	local t = v * (1 - (1 - f) * s);

	i = i % 6

	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end

	return r * 255, g * 255, b * 255
end

local function rgb_rainbow(frequency, rgb_split_ratio)
    local r, g, b, a = hsv_to_rgb(globals.realtime() * frequency, 1, 1, 1)

    r = r * rgb_split_ratio
    g = g * rgb_split_ratio
    b = b * rgb_split_ratio
    return r, g, b
end

client.set_event_callback('paint', function()
    local penetration = ui.get(penetration)

    if not penetration then
        return
    end

    local local_player = entity.get_local_player()
    local position = ui.get(position)
    local rainbow = ui.get(rainbow)
    local weapon = entity.get_player_weapon(local_player)
    local r, g, b, a = ui.get(color)

    local w, h = client.screen_size()

    if weapon == nil or contains(wpn_ignored, entity.get_classname(weapon)) then
        return
    end

    local pitch, yaw = client.camera_angles()
    local fwd = angle_forward({ pitch, yaw, 0 })
    local start_pos = { client.eye_position() }
    
    local fraction = client.trace_line(local_player, start_pos[1], start_pos[2], start_pos[3], start_pos[1] + (fwd[1] * 8192), start_pos[2] + (fwd[2] * 8192), start_pos[3] + (fwd[3] * 8192))

    if fraction < 1 then
        local end_pos = {
            start_pos[1] + (fwd[1] * (8192 * fraction + 128)),
            start_pos[2] + (fwd[2] * (8192 * fraction + 128)),
            start_pos[3] + (fwd[3] * (8192 * fraction + 128)),
        }

        local ent, dmg = client.trace_bullet(local_player, start_pos[1], start_pos[2], start_pos[3], end_pos[1], end_pos[2], end_pos[3])

        if ent == nil then
            ent = -1
        end

        if dmg > 0 and not rainbow then
            renderer.text((w / 2), (h / 2 + position), r, g, b, a, 'cbd', 0, dmg)
        elseif dmg > 0 and rainbow then
            local r2, g2, b2 = rgb_rainbow(ui.get(speed) / 100, 1)  
            renderer.text((w / 2), (h / 2 + position), r2, g2, b2, a, 'cbd', 0, dmg)
        end
    end
end)