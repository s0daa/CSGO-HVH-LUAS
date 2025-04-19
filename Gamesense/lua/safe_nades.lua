local ui_get = ui.get
local entity_get_all = entity.get_all
local entity_get_prop = entity.get_prop
local entity_get_local_player = entity.get_local_player
local globals_tickcount = globals.tickcount
local globals_tickinterval = globals.tickinterval
local client_world_to_screen = client.world_to_screen
local client_draw_text = client.draw_text
local client_get_cvar = client.get_cvar
local client_userid_to_entindex = client.userid_to_entindex
local string_format = string.format

local molotov_duration = 7
local enabled_reference = ui.reference("VISUALS", "Other ESP", "Grenades")

local projectile_previous = {}
local projectile_current = {}
local projectile_thrown_by_localplayer = {}
local molotovs_team = {}
local molovots_created = {}
local molotov_thrown_at = 0

local function on_grenade_thrown(e)
	userid, grenade = e.userid, e.weapon

	if client_userid_to_entindex(userid) == entity_get_local_player() then
		if grenade == "molotov" or grenade == "incgrenade" then
			molotov_thrown_at = globals_tickcount()
		end
	end
end

local function on_paint(ctx)
	if not ui_get(enabled_reference) then
		return
	end

	local ticks_current = globals_tickcount()
	local seconds_per_tick = globals_tickinterval()
	local molotov_owner = nil

	local projectiles = entity_get_all("CMolotovProjectile")
	local projectile_current = {}
	local existing_projectiles

	if projectiles ~= nil then
		for i=1, #projectiles do
			local projectile = projectiles[i]
			if molotov_thrown_at == ticks_current then
				if projectile_previous[projectile] == nil then
					projectile_thrown_by_localplayer[projectile] = true
				end
			end
			if projectile_thrown_by_localplayer[projectile] then
				projectile_current[projectile] = 0
			else
				projectile_current[projectile] = entity_get_prop(projectile, "m_iTeamNum")
			end
		end
	end

	for key,value in pairs(projectile_previous) do
	  if projectile_current[key] == nil then
	  	--client.log("Projectile with id ", key, " landed at ", ticks_current, ", teamid is ", value)
	  	molotov_owner = value
	  	projectile_previous[key] = nil
	  	projectile_thrown_by_localplayer[key] = nil
	  	molotovs_team[key] = nil
	  	break
	  end
	end

	local molotov_grenades = entity_get_all("CInferno")

	local existing_molotovs = {}

	if molotov_grenades ~= nil then
		local own_team = entity_get_prop(entity_get_local_player(), "m_iTeamNum")
		local friendlyfire = client_get_cvar("mp_friendlyfire")

		for i=1, #molotov_grenades do
			local molotov_grenade = molotov_grenades[i]
			local molotov_team = molotovs_team[molotov_grenade]
			local molotov_created = molovots_created[molotov_grenade]
			if molotov_team == nil then
				molotov_team = molotov_owner
				molotovs_team[molotov_grenade] = molotov_team
				molovots_created[molotov_grenade] = ticks_current
				molotov_created = molovots_created[molotov_grenade]
			end

			local time_since_explosion = seconds_per_tick * (ticks_current - molotov_created)

			--client.log(molotov_created)

			local progress = 1 - time_since_explosion / molotov_duration

			--client.log("molotov ", molotov_grenade, " with teamid ", molotov_team)
			local safe = (molotov_team == own_team)
			if tonumber(friendlyfire) ~= 0 then
				safe = false
			end

			local x, y, z = entity_get_prop(molotov_grenade, "m_vecOrigin")
			local worldX, worldY = client_world_to_screen(ctx, x, y, z)

			if (worldX ~= nil and worldY ~= nil) then

				local message = string_format("%.1fS LEFT", molotov_duration-time_since_explosion)
				client_draw_text(ctx, worldX, worldY+20, 255, 255, 255, 20 + progress * 235, "c-", 150, message)

				local second_string_opacity = 255
				if progress < 0.15 then
					second_string_opacity = (progress)*6.6*255
					if second_string_opacity < 0 then
						second_string_opacity = 0
					end
				end

				if safe then
					client_draw_text(ctx, worldX, worldY-12, 149, 184, 6, second_string_opacity, "c", 150, "SAFE")
				else
					client_draw_text(ctx, worldX, worldY-12, 230, 21, 21, second_string_opacity, "c", 150, "UNSAFE")
				end
			end
			existing_molotovs[molotov_grenade] = true

		end

	end

	for key,value in pairs(molotovs_team) do
		
		if existing_molotovs[key] == nil then
			molotovs_team[key] = nil
			--client.log("Molotov ", key, " disappeared")
		end
	end

	projectile_previous = projectile_current

end

client.set_event_callback("paint", on_paint)
client.set_event_callback("grenade_thrown", on_grenade_thrown)