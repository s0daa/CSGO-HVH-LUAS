--#region libraries + function cache
local bit, vector = require'bit', require'vector'
local _ui, entity, images = require'gamesense/uilib', require'gamesense/entity', require'gamesense/images'

local render_text =
	renderer.text

local get_local_player, get_player_resource =
	entity.get_local_player, entity.get_player_resource

local maxplayers =
	globals.maxplayers

local camera_angles, register_flag =
	client.camera_angles, client.register_esp_flag

local ui_reference, ui_get = ui.reference, ui.get

local cos, sin, rad, sqrt, acos, max, ceil = math.cos, math.sin, math.rad, math.sqrt, math.acos, math.max, math.ceil
--#endregion

--#region variables
local lethal = {}
local dpi = 1

local image = {
	bullet = images.get_panorama_image('icons/ui/bullet.svg')
}

local lookup_table = { -- stolen from : https://gamesense.pub/forums/viewtopic.php?id=34280
	[1] = "Helmet",
	[2] = "Kevlar",
	[4] = "Helmet + Kevlar",
	[8] = "Zoom",
	[16] = "Blind",
	[32] = "Reload",
	[64] = "Bomb",
	[128] = "Vip",
	[256] = "Defuse",
	[512] = "Fakeduck",
	[1024] = "Pin pulled",
	[2048] = "Hit",
	[4096] = "Occluded",
	[8192] = "Exploiter",
	[131072] = "Defensive dt"
}
--#endregion

--#region references
local ref = {
	min_dmg = _ui.reference('rage', 'aimbot', 'minimum damage', 'slider'),
	min_dmg_ovr = {ui_reference('rage', 'aimbot', 'minimum damage override')},
	dpi = _ui.reference('misc', 'settings', 'dpi scale', 'combobox')
}
local show_nades
if pcall(function() ui_reference('visuals', 'player esp', 'show nades') end) then
	show_nades = ui_reference('visuals', 'player esp', 'show nades')
end
--#endregion

--#region ui init
local ui_white = '\adcdcdcff'
local ui_space = '\a808080c8»'..ui_white
local tab, container = 'visuals', 'player esp'
local feature = {
	enabled = _ui.new_checkbox(tab, container, 'Show lethality'),
	options = _ui.new_multiselect(tab, container, '\nlethality_options', {
		'Lethal flag', 'Force flag', 'Bullet icon', 'Force body aim'
	}),
	only_closest = _ui.new_checkbox(tab, container, 'Lethal '..ui_space..' Limit to closest to crosshair'),
	move_icon = _ui.new_combobox(tab, container, 'Lethal '..ui_space..' Icon position', {
		'Default', 'Above name', 'Below weapons', 'Next to health', 'Top left', 'Top right', 'Bottom left', 'Bottom right'
	}),
	force = _ui.new_slider(tab, container, 'Lethal '..ui_space..' Force body aim shots', 1, 5, 1, true, 'x', 1, {[1]='Lethal'})
}
--#endregion

--#region functions
local normalize = function(vec)
	local len = sqrt(vec.x*vec.x+vec.y*vec.y+vec.z*vec.z)
	if len == 0 then return vector(0, 0, 0) end
	local r = 1/len
	return vector(vec.x*r, vec.y*r, vec.z*r)
end

local calc_fov = function(origin, l_origin, f)
	local delta = normalize(vector(origin.x-l_origin.x, origin.y-l_origin.y, 0))
	local dot = delta:dot(f)
	local cos_inv = acos(dot)

	return (180/math.pi) * cos_inv
end

local player_iterator = function(filters, fn, invalid_fn) -- from @aplhanine
	local player_resource = get_player_resource()

	for iter = 1, maxplayers() do
		if player_resource:get_prop('m_bConnected', iter) then
			local player = entity.new(iter)

			if player and (not filters:find('A') or player:is_alive()) and (not filters:find('D') or not player:is_dormant()) and (not filters:find('E') or player:is_enemy()) then
				fn(player)
				goto continue
			end
		end

		if invalid_fn then
			invalid_fn(iter)
		end

		::continue::
	end
end

local generate_orb = function(c, from, len, divide, distance)
	local all = {}
	for i=from+1, len+from, divide do
		local rot = rad(i)
		all[#all+1] = vector(distance*cos(rot)+c.x, distance*sin(rot)+c.y, c.z)
	end
	return all
end

local get_table_len = function(table)
	local c = 0
	for i, n in pairs(table) do c=c+1 end
	return c
end

entity.has_nade = function(ent)
	if ent == nil then return false end

	local weapon = ent:get_player_weapon()
	if weapon == nil then return false end

	local class = weapon:get_classname()

	if class == 'CSmokeGrenade' or class == 'CHEGrenade' or class == 'CMolotovGrenade' or class == 'CFlashGrenade' or class == 'CDecoyGrenade' or class == 'CIncendiaryGrenade' then
		return true
	end
	return false
end

entity.has_short_range_weapon = function(ent)
	if ent == nil then return false end

	local weapon = ent:get_player_weapon()
	if weapon == nil then return false end

	local class = weapon:get_classname()

	if class == 'CKnife' or class == 'CWeaponTaser' or ent:has_nade() then
		return true
	end
	return false
end
--#endregion

--#region callbacks
local callbacks = {
	setup_command = function(cmd)
		local lp = get_local_player(); if not lp or (lp:has_short_range_weapon() or not lp:is_alive()) then lethal.targets = {} return end
		if cmd.chokedcommands > 0 then return end

		lethal.targets = {}
		
		local min_dmg = ref.min_dmg()
		if ui_get(ref.min_dmg_ovr[1]) and ui_get(ref.min_dmg_ovr[2]) then min_dmg = ui_get(ref.min_dmg_ovr[3]) end
		local view_angles = {camera_angles()}
		local lp_origin = vector(lp:get_origin())

		local closest = { entity, fov=math.huge }
		local f = vector():init_from_angles(unpack(view_angles))
		local orbs = generate_orb(lp_origin+vector(0, 0, 56), view_angles[2]+90, 180, 40, 40)

		if feature.only_closest() then
			player_iterator('ADE', function(ent)
				local fov = calc_fov(vector(ent:get_origin()), lp_origin, f)
				if fov < closest.fov then closest = { entity = ent, fov = fov } end
			end)
		end

		player_iterator('ADE', function(ent)
			if ent == nil then return end
			if closest.entity ~= nil and closest.entity ~= ent then goto continue end

			local idx = ent:get_entindex()
			if not lethal.targets[idx] then lethal.targets[idx] = { is=false,dmg=0,bullets=0,entity=ent } end

			local ent_origin = vector(ent:hitbox_position(5))
			local hp = ent:get_prop'm_iHealth'

			for orb, origin in ipairs(orbs) do
				local _, c_dmg = lp:trace_bullet(origin.x, origin.y, origin.z, ent_origin.x, ent_origin.y, ent_origin.z)
				if c_dmg ~= nil and c_dmg > min_dmg then lethal.targets[idx].dmg = c_dmg end
			end

			lethal.targets[idx].is, lethal.targets[idx].bullets =
				lethal.targets[idx].dmg > hp, max(1, ceil(hp/lethal.targets[idx].dmg, 0))

			if feature.options:contains('Force body aim') then
				local do_baim = lethal.targets[idx].bullets <= feature.force() and 'Force' or '-'
				ent:plist_set('Override prefer body aim', do_baim)
			end

			::continue::
		end)
	end,
	paint = function()
		local lp = get_local_player(); if not lp or (not lp:is_alive()) or lethal.targets == nil then return end

		dpi = tonumber( ref.dpi():gsub('%%', ''):sub(1, 3) ) * .01

		if feature.options:contains('Bullet icon') then
			for _, i in pairs(lethal.targets) do
				if i.entity == nil or i.entity:is_alive() == false or i.dmg <= 0 then goto continue end

				local bb = {i.entity:get_bounding_box()}
				local pos = vector(0, 0)
				
				if feature.move_icon() == 'Default' then
					local esp_data = i.entity:get_esp_data()
					local stack = 0

					for j=0, get_table_len(lookup_table), 1 do if bit.band(esp_data.flags, bit.lshift(1, j)) ~= 0 then stack=stack+1 end end

					pos = vector(bb[3], bb[2]) + vector(2, stack*8)
				else
					local positions = {
						['Above name'] = { (bb[1]+bb[3])*.5-8*dpi, show_nades and ui_get(show_nades) and bb[2]-34*dpi or bb[2]-24*dpi },
						['Below weapons'] = { (bb[1]+bb[3])*.5-8*dpi, bb[4]+14*dpi },
						['Next to health'] = { bb[1]-24, (bb[2]+bb[4])*.5-8*dpi },
						['Top left'] = { bb[1]-24*dpi, bb[2]-14*dpi },
						['Top right'] = { bb[3]+6*dpi, bb[2]-14*dpi },
						['Bottom left'] = { bb[1]-16*dpi, bb[4] },
						['Bottom right'] = { bb[3], bb[4] }
					}
					pos.x, pos.y = unpack(positions[feature.move_icon()])
				end

				render_text(pos.x+6*dpi, pos.y+5*dpi, 220, 220, 220, 255*bb[5], 'd-', 0, 'x'..i.bullets)
				image.bullet:draw(pos.x+1, pos.y+4, 12*dpi, 10*dpi, 0, 0, 0, 255*bb[5])
				image.bullet:draw(pos.x, pos.y+3, 12*dpi, 10*dpi, 220, 220, 220, 255*bb[5])

				::continue::
			end
		end
	end
}

register_flag('-', 255, 0, 0, function(e)
	if (not feature.enabled()) or not feature.options:contains('Lethal flag') then return false end
	if lethal.targets == nil then return false end

	local target = lethal.targets[e]
	if target == nil then return false end

	return tostring(target.bullets) ~= 'inf', target.bullets <= 1 and 'L' or 'x'..target.bullets
end)

register_flag('B', 255, 255, 255, function(e)
	if (not feature.enabled()) or not feature.options:contains('Force flag') then return false end

	return plist.get(e, 'Override prefer body aim') == 'Force'
end)
--#endregion

--#region ui visibility
local ui_vis = function()
	local update = feature.enabled()

	feature.options['vis'] = update
	feature.only_closest['vis'] = update
	feature.move_icon['vis'] = update and feature.options:contains('Bullet icon')
	feature.force['vis'] = update and feature.options:contains('Force body aim')
end

feature.enabled:add_callback(ui_vis); feature.options:add_callback(ui_vis)
feature.enabled:add_event_callback('paint', callbacks.paint); feature.enabled:add_event_callback('setup_command', callbacks.setup_command)
feature.enabled:invoke()
--#endregion

local api = {
	get_data = function()
		return lethal.targets
	end
}

package.preload['gamesense/lethality'] = function() return api end
