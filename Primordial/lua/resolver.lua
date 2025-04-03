local overridekey = ui.new_hotkey("rage", "other",  "Anti-aim resolver override")
local correctionmode = ui.new_combobox("rage", "other", "Resolver correction", { "Off", "Lowerbody", "Logic", "Resimulation" })
local correctafterx = ui.new_slider("rage", "other", "Correct after x shots", 1, 4, 2, true)
local selectedplayer = ui.reference("players", "players", "player list")
local forcebody, forcebodyyaw = ui.reference("players", "adjustments", "force body yaw")
local resetlist = ui.reference("players", "players", "reset all")
local antiaimcorrection = ui.reference("players", "adjustments", "Override anti-aim correction")
local enemyidx = 0
local brutedyaw = 0
local overriding = false
local bruteforcing = false
local missedshots = { }
local lasthitmode = { }
local storedshottime = { }
local firedthistick = { }

local function get_max_dsc(entityidx)
	local vx, vy, vz = entity.get_prop(entityidx, "m_vecVelocity")
    local fl_speed = math.sqrt(vx ^ 2 + vy ^ 2 )
	return 58 - 58 * fl_speed / 580
end

local function normalize_yaw(yaw)
    while yaw > 180 do 
		yaw = yaw - 360 
	end
    while yaw < -180 do 
		yaw = yaw + 360 
	end
    return yaw
end

local function world2scren(xdelta, ydelta)
    if xdelta == 0 and ydelta == 0 then
        return 0
    end
    return math.deg(math.atan2(ydelta, xdelta))
end

client.set_event_callback("paint", function (ctx)
	if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then
		return
	end
	local maxplayers = entity.get_players(true)
	if maxplayers == nil then
		return
	end

	ui.set_visible(correctafterx, ui.get(correctionmode) ~= "Off")

	if bruteforcing then
		client.draw_indicator(ctx, 255, 0, 0, 255, "BRUTE")
	else

		if ui.get(overridekey) then
			client.draw_indicator(ctx, 75, 175, 0, 255, "OVERRIDE")
			local closestplayer = nil
			local fov = 180
			local localx, localy, localz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
			overriding = true
			local mousex, mousey, mousez = client.camera_angles()
			for p = 1, #maxplayers, 1 do
				enemyidx = maxplayers[p]
				if entity.is_enemy(enemyidx) then
					local curenemyx, curenemyy, curenemyz = entity.get_prop(enemyidx, "m_vecOrigin")
					local cur_fov = math.abs(normalize_yaw(world2scren(localx - curenemyx, localy - curenemyy) - mousey + 180))
					if cur_fov < fov then
						fov = cur_fov
						closestplayer = enemyidx
					end
				end
			end
			if closestplayer ~= nil then
				local enemyweapon = entity.get_player_weapon(closestplayer)
				local lastshottime = entity.get_prop(enemyweapon, "m_fLastShotTime")
				if firedthistick[closestplayer] == nil then firedthistick[closestplayer] = false end
				if storedshottime[closestplayer] == nil then storedshottime[closestplayer] = lastshottime end

				if lastshottime ~= storedshottime[closestplayer] then
					firedthistick[closestplayer] = true
					storedshottime[closestplayer] = lastshottime
				else
					firedthistick[closestplayer] = false
				end

				local enemyx, enemyy, enemyz = entity.get_prop(closestplayer, "m_vecOrigin")
				if enemyx == nil then return end
				local maxdesync = get_max_dsc(closestplayer)
				local fovtoplayer = normalize_yaw(world2scren(localx - enemyx, localy - enemyy) - mousey)
				if fovtoplayer > 0 then
					brutedyaw = -maxdesync
				else
					brutedyaw = maxdesync
				end

				ui.set(selectedplayer, closestplayer)
				if not firedthistick[closestplayer] then
					ui.set(forcebody, true)
					ui.set(forcebodyyaw, brutedyaw)
				else
					ui.set(forcebody, false)
					ui.set(forcebodyyaw, 0)
				end
			end
		elseif overriding then
			ui.set(resetlist, true)
			overriding = false
		end
	end
end)

client.set_event_callback("aim_miss", function (e)
	if ui.get(correctionmode) == "Off" then return end
	if e.reason ~= "?" then return end
	local initializedshotcount = false
	local target_idx = e.target

    if target_idx ~= nil then
		if missedshots[target_idx] == nil then 
			missedshots[target_idx] = 1
			initializedshotcount = true
		end

		ui.set(selectedplayer, target_idx)
		if missedshots[target_idx] >= ui.get(correctafterx) then
			bruteforcing = true
			if ui.get(correctionmode) == "Lowerbody" then
				if missedshots[target_idx] - ui.get(correctafterx) == 0 then
					ui.set(antiaimcorrection, "Basic")
				else
					ui.set(forcebody, false)
					ui.set(forcebodyyaw, 0)
					ui.set(antiaimcorrection, "-")
					missedshots[target_idx] = 0
					bruteforcing = false
				end
			elseif ui.get(correctionmode) == "Logic" then
				if missedshots[target_idx] - ui.get(correctafterx) == 0 then
					ui.set(antiaimcorrection, "Default")
				else
					ui.set(forcebody, false)
					ui.set(forcebodyyaw, 0)
					ui.set(antiaimcorrection, "-")
					missedshots[target_idx] = 0
					bruteforcing = false
				end
			elseif ui.get(correctionmode) == "Resimulation" then
				if missedshots[target_idx] - ui.get(correctafterx) == 0 then
					if lasthitmode[target_idx] ~= nil then
						ui.set(antiaimcorrection, lasthitmode[target_idx])
					else
						ui.set(antiaimcorrection, "Default")
					end
				elseif missedshots[target_idx] - ui.get(correctafterx) == 1 then
					ui.set(antiaimcorrection, "Basic")
				else
					ui.set(forcebody, false)
					ui.set(forcebodyyaw, 0)
					ui.set(antiaimcorrection, "-")
					missedshots[target_idx] = 0
					bruteforcing = false
				end
			end
		else
			ui.set(forcebody, false)
			ui.set(forcebodyyaw, 0)
			ui.set(antiaimcorrection, "-")
			bruteforcing = false
		end
		if not initializedshotcount then
			missedshots[target_idx] = missedshots[target_idx] + 1
		end
	end
end)

client.set_event_callback("player_death", function (e)
	if ui.get(correctionmode) == "Off" then return end
	local victim_id, attacker_id = e.userid, e.attacker
	local victim_idx, attacker_idx = client.userid_to_entindex(victim_id), client.userid_to_entindex(attacker_id)
	local local_idx = entity.get_local_player()
    if attacker_idx == local_idx and entity.is_enemy(victim_idx) then
		bruteforcing = false
	end
end)

client.set_event_callback("player_hurt", function (e)
	if ui.get(correctionmode) ~= "Resimulation" then return end
	local victim_id, attacker_id = e.userid, e.attacker
	local victim_idx, attacker_idx = client.userid_to_entindex(victim_id), client.userid_to_entindex(attacker_id)
	local local_idx = entity.get_local_player()
    if attacker_idx == local_idx and entity.is_enemy(victim_idx) then
		if e.hitgroup == 1 then
			ui.set(selectedplayer, victim_idx)
			lasthitmode[victim_idx] = ui.get(antiaimcorrection)
		end
	end
end)

client.set_event_callback("round_start", function (e)
	ui.set(resetlist, true)
	bruteforcing = false
	missedshots = { }
end)

client.set_event_callback("cs_game_disconnected", function (e)
	ui.set(resetlist, true)
	bruteforcing = false
	missedshots = { }
	storedshottime = { }
	lasthitmode = { }
	firedthistick = { }
end)

client.set_event_callback("game_newmap", function (e)
	ui.set(resetlist, true)
	bruteforcing = false
	missedshots = { }
	lasthitmode = { }
	storedshottime = { }
	firedthistick = { }
end)

ui.set_callback(correctionmode, ui.set, resetlist, true)