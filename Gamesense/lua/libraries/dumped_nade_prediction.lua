slot0 = require("gamesense/csgo_weapons")
slot1 = require("gamesense/trace")
slot2 = require("vector")
slot3 = require("ffi")
slot4 = {
	PZ_CLIP = 20,
	NPC_SCRIPTED = 19,
	NPC_ACTOR = 18,
	PUSHAWAY = 17,
	DISSOLVING = 16,
	PASSABLE_DOOR = 15,
	DOOR_BLOCKER = 14,
	PROJECTILE = 13,
	VEHICLE_CLIP = 12,
	WEAPON = 11,
	IN_VEHICLE = 10,
	NPC = 9,
	PLAYER_MOVEMENT = 8,
	VEHICLE = 7,
	BREAKABLE_GLASS = 6,
	PLAYER = 5,
	INTERACTIVE = 4,
	INTERACTIVE_DEBRIS = 3,
	DEBRIS_TRIGGER = 2,
	DEBRIS = 1,
	NONE = 0
}

function slot5(slot0, slot1, slot2)
	if slot0 <= slot1 then
		return slot1
	elseif slot2 <= slot0 then
		return slot2
	end

	return slot0
end

function slot6(slot0)
	return math.floor(0.5 + slot0 / globals.tickinterval())
end

function slot7(slot0)
	return globals.tickinterval() * slot0
end

function slot8(slot0, slot1, slot2)
	return slot1 + (slot0 - slot1) * slot2
end

function slot9(slot0, slot1, slot2)
	slot3 = uv0()
	slot3.x = uv1(slot0.x, slot1.x, slot2.x)
	slot3.y = uv1(slot0.y, slot1.y, slot2.y)
	slot3.z = uv1(slot0.z, slot1.z, slot2.z)

	return slot3
end

function slot10()
	return 0.4 * cvar.sv_gravity:get_float()
end

function slot11(slot0)
	return entity.get_classname(slot0) == "CCSPlayer"
end

slot12 = {}
slot13 = {
	__metatable = "grenade",
	__index = slot12
}

function slot12.create()
	return setmetatable({
		collision_entity = 0,
		bounce_count = 0,
		cur_time = 0,
		tick_count = 0,
		entity = -1,
		error = "none",
		weapon_idx = 0,
		water_type = 0,
		last_update_tick = 0,
		next_think_tick = 0,
		detonation_time = 0,
		detonated = false,
		velocity = uv0(),
		collision_group = uv1.NONE,
		start_tick_pos = uv0(),
		position = uv0(),
		start_pos = uv0(),
		end_pos = uv0(),
		nade_info = {},
		bounces = {},
		points = {}
	}, uv2)
end

function slot12.get_detenation_time(slot0)
	if slot0.nade_info.idx == uv0.weapon_flashbang.idx or slot1 == uv0.weapon_hegrenade.idx then
		return 1.4
	elseif slot1 == uv0.weapon_molotov.idx or slot1 == uv0.weapon_incgrenade.idx then
		return cvar.molotov_throw_detonate_time:get_float()
	elseif slot1 == uv0.weapon_tagrenade.idx then
		return 5
	end

	return 3
end

function slot12.m_bPinPulled(slot0)
	return entity.get_prop(slot0.weapon_ent, "m_bPinPulled") == 1
end

function slot12.m_fThrowTime(slot0)
	return entity.get_prop(slot0.weapon_ent, "m_fThrowTime")
end

function slot12.m_flThrowStrength(slot0)
	return entity.get_prop(slot0.weapon_ent, "m_flThrowStrength")
end

function slot12.get_throw_velocity(slot0)
	return slot0.nade_info.throw_velocity
end

function slot12.update_path(slot0, slot1)
	table.insert(slot0.points, {
		start_pos = slot0.start_tick_pos == uv0() and slot0.position or slot0.start_tick_pos,
		end_pos = slot0.position,
		bounced = slot1 or false,
		detonated = slot0.detonated
	})

	if slot1 then
		table.insert(slot0.bounces, {
			pos = slot0.position
		})
	end

	slot0.start_tick_pos = slot0.position
	slot0.last_update_tick = slot0.tick_count
end

function slot12.physiscs_clip_velocity(slot0, slot1, slot2, slot3)
	slot4 = uv0()
	slot5 = 0

	if slot2.y > 0 then
		slot5 = slot5 == 0 and slot5 or 1
	end

	if slot6 == 0 then
		slot5 = slot5 == 0 and slot5 or 2
	end

	slot10 = uv1.cast("float*", slot4)

	for slot14 = 0, 2 do
		slot10[slot14] = uv1.cast("float*", slot1)[slot14] - uv1.cast("float*", slot2)[slot14] * slot1:dot(slot2) * slot3

		if slot10[slot14] > -0.1 and slot10[slot14] < 0.1 then
			slot10[slot14] = 0
		end
	end

	return slot4, slot5
end

function slot12.set_next_think(slot0, slot1)
	slot0.next_think_tick = uv0(slot1)
end

function slot12.normalized_to_world_space(slot0, slot1)
	return uv1(uv0(-2, -2, -2), uv0(2, 2, 2), slot1) + slot0.position
end

function slot12.update_water_state(slot0)
	slot1 = slot0:normalized_to_world_space(uv0(0.5, 0.5, 0))
	slot0.water_type = 0

	if bit.band(uv1.line(slot1, slot1 + uv0(0.001, 0.001, 0.001), {
		mask = "MASK_WATER"
	}).contents, 16432) == 0 then
		return
	end

	slot0.water_type = slot2.contents
end

function slot12.emit_grenade(slot0, slot1, slot2)
	slot0.cur_time = 0
	slot0.velocity = slot2
	slot0.position = slot1
	slot0.collision_group = uv0.PROJECTILE
	slot0.bounce_count = 0
	slot0.collision_entity = 0

	slot0:update_water_state()

	if slot0.weapon_idx == uv1.weapon_smokegrenade.idx then
		slot0:set_next_think(1.5)
	elseif slot3 == uv1.weapon_decoy.idx then
		slot0:set_next_think(2)
	elseif slot3 == uv1.weapon_flashbang.idx or slot3 == uv1.weapon_hegrenade.idx then
		slot0.detonation_time = 1.4

		slot0:set_next_think(0.02)
	elseif slot3 == uv1.weapon_molotov.idx or slot3 == uv1.weapon_incgrenade.idx then
		slot0.detonation_time = cvar.molotov_throw_detonate_time:get_float()

		slot0:set_next_think(0.02)
	end
end

function slot12.throw_grenade(slot0, slot1, slot2)
	if uv0(entity.get_prop(slot0.entity, "m_vecVelocity")):length2d() < 2 then
		slot3.y = 0
		slot3.x = 0
	end

	slot1 = slot1 + slot3 * uv1(3)

	if slot2.x < -90 then
		slot2.x = slot2.x + 360
	elseif slot2.x > 90 then
		slot2.x = slot2.x - 360
	end

	slot2.x = slot2.x - (90 - math.abs(slot2.x)) * 10 / 90
	slot4 = uv2(slot0:m_flThrowStrength(), 0, 1)
	slot6 = uv0():init_from_angles(slot2.x, slot2.y, slot2.z)
	slot1.z = slot1.z + slot4 * 12 - 12

	slot0:emit_grenade(uv3.hull(slot1, slot1 + slot6 * 22, uv0(-2, -2, -2), uv0(2, 2, 2), {
		conents = "CONTENTS_GRENADECLIP",
		mask = "MASK_SOLID",
		skip = slot0.entity
	}).end_pos - slot6 * 6, slot6 * uv2(slot0:get_throw_velocity() * 0.9, 15, 750) * (slot4 * 0.7 + 0.3) + slot3 * 1.25)
end

function slot12.detonate(slot0, slot1)
	slot0.detonated = true

	slot0:update_path(slot1 or false)
end

function slot12.think(slot0)
	if slot0.weapon_idx == uv0.weapon_smokegrenade.idx then
		if slot0.velocity:lengthsqr() <= 0.010000000000000002 then
			slot0:detonate(false)
		end
	elseif slot1 == uv0.weapon_decoy.idx then
		if slot0.velocity:lengthsqr() <= 0.04000000000000001 then
			slot0:detonate(false)
		end
	elseif slot1 == uv0.weapon_molotov.idx or slot1 == uv0.weapon_incgrenade.idx or slot1 == uv0.weapon_flashbang.idx or slot1 == uv0.weapon_hegrenade.idx then
		if slot0.detonation_time <= slot0.cur_time then
			slot0:detonate(false)
		end

		if slot0.water_type ~= 0 then
			slot0.velocity = slot0.velocity * 0.5
		end
	end

	slot0:set_next_think(slot0.cur_time + 0.2)
end

function slot12.physics_run_think(slot0)
	if slot0.tick_count < slot0.next_think_tick then
		return
	end

	slot0:think()
end

function slot12.physics_add_gravity_move(slot0)
	slot1 = uv0()
	slot1.x = slot0.velocity.x * globals.tickinterval()
	slot1.y = slot0.velocity.y * globals.tickinterval()
	slot2 = slot0.velocity.z - uv1() * globals.tickinterval()
	slot1.z = (slot0.velocity.z + slot2) / 2 * globals.tickinterval()
	slot0.velocity.z = slot2

	return slot1
end

function slot12.utils_trace_entity(slot0, slot1, slot2, slot3)
	return uv1.hull(slot1, slot2, uv0(-2, -2, -2), uv0(2, 2, 2), {
		skip = slot0.entity,
		mask = slot3
	})
end

function slot12.physics_trace_entity(slot0, slot1, slot2, slot3)
	if slot0:utils_trace_entity(slot1, slot2, slot3).start_solid and slot4.contents then
		slot4 = slot0:utils_trace_entity(slot1, slot2, slot3 - 80000)
	end

	if (slot4.fraction < 1 or slot4.all_solid or slot4.start_solid) and slot4.entindex ~= -1 and uv0(slot4.entindex) then
		-- Nothing
	end

	return slot4
end

function slot12.physics_check_sweep(slot0, slot1, slot2)
	slot3 = nil

	return slot0:physics_trace_entity(slot1, slot1 + slot2, slot0.collision_group == uv0.DEBRIS and 540683 or 1107845259)
end

function slot12.touch(slot0, slot1, slot2)
	if slot0.weapon_idx == uv0.weapon_molotov.idx or slot3 == uv0.weapon_incgrenade.idx then
		if not uv1(slot1) and math.cos(math.rad(cvar.weapon_molotov_maxdetonateslope:get_float())) <= slot2.plane.normal.z then
			slot0:detonate(true)
		end
	elseif slot3 == uv0.weapon_tagrenade.idx and uv1(slot1) then
		slot0:detonate(true)
	end
end

function slot12.physics_impact(slot0, slot1, slot2)
	slot0:touch(slot1, slot2)
end

function slot12.physics_push_entity(slot0, slot1)
	if slot0:physics_check_sweep(slot0.position, slot1).start_solid then
		slot0.collision_group = uv0.INTERACTIVE_DEBRIS
		slot2 = uv1.line(slot0.position - slot1, slot0.position + slot1, {
			mask = 540683,
			skip = slot0.entity
		})
	end

	if slot2.fraction ~= 0 then
		slot0.position = slot2.end_pos
	end

	if slot2.entindex ~= -1 then
		slot0:physics_impact(slot2.entindex, slot2)
	end

	return slot2
end

function slot12.perform_fly_collision_resolution(slot0, slot1)
	slot2 = 1

	if slot1.entindex ~= -1 then
		if uv0(slot1.entindex) then
			slot2 = 0.3
		end

		if slot1.entindex ~= 0 then
			if slot0.collision_entity == slot1.entindex and uv0(slot1.entindex) then
				slot0.collision_group = uv1.DEBRIS
			end

			slot0.collision_entity = slot1.entindex
		end
	end

	slot4 = slot0:physiscs_clip_velocity(slot0.velocity, slot1.plane.normal, 2) * uv2(0.45 * slot2, 0, 0.9)

	if slot1.plane.normal.z > 0.7 then
		if slot4:dot(slot4) > 96000 and slot4:normalized():dot(slot1.plane.normal) > 0.5 then
			slot4 = slot4 * uv3(1, 1, 1) - uv3(slot6, slot6, slot6) + uv3(0.5, 0.5, 0.5)
		end

		if slot5 < 400 then
			slot0.velocity = uv3(0, 0, 0)
		else
			slot0.velocity = slot4

			slot0:physics_push_entity(slot4 * (1 - slot1.fraction) * globals.tickinterval())
		end
	else
		slot0.velocity = slot4

		slot0:physics_push_entity(slot4 * (1 - slot1.fraction) * globals.tickinterval())
	end

	if slot0.bounce_count > 20 then
		slot0:detonate(true)
	else
		slot0.bounce_count = slot0.bounce_count + 1
	end
end

function slot12.physics_simulate(slot0)
	slot1, slot2 = uv0()

	slot0:physics_run_think()

	if slot0.detonated then
		return
	end

	slot2 = slot0:physics_push_entity(slot0:physics_add_gravity_move())

	if slot0.detonated then
		return
	end

	if slot2.fraction ~= 1 then
		slot0:update_path(true)
		slot0:perform_fly_collision_resolution(slot2)
	end
end

function slot12.do_predict(slot0, slot1, slot2)
	slot0:throw_grenade(slot1, slot2)

	slot0.last_update_tick = -math.floor(1 / 30 / globals.tickinterval())
	slot0.start_pos = slot0.position

	for slot8 = 0, math.huge do
		slot0.tick_count = slot8

		if slot0.cur_time > 10 then
			break
		end

		if slot8 >= slot0.last_update_tick + slot4 then
			slot0:update_path(false)
		end

		slot0:physics_simulate()

		if slot0.detonated then
			break
		end

		slot0.cur_time = slot0.cur_time + globals.tickinterval()
	end
end

function slot12.predict(slot0)
	if not slot0.nade_info.is_grenade then
		return
	end

	slot0.weapon_idx = slot0.nade_info.idx
	slot1 = uv0()
	slot2 = uv0()

	if slot0.entity == entity.get_local_player() then
		slot1 = uv0(client.eye_position())
		slot2 = uv0(client.camera_angles())
	else
		slot1 = uv0(entity.hitbox_position(slot0.entity, 0))
		slot2 = uv0(entity.get_prop(slot0.entity, "m_angEyeAngles"))
	end

	slot0:do_predict(slot1, slot2)

	return {
		points = slot0.points,
		bounces = slot0.bounces,
		end_pos = slot0.position,
		start_pos = slot0.start_pos,
		nade_info = slot0.nade_info,
		tick_count = slot0.tick_count,
		bounce_count = slot0.bounce_count
	}
end

function slot12.init(slot0, slot1)
	if slot1 == nil then
		slot0.error = "entity is nil"

		return false
	end

	if not uv0(slot1) then
		slot0.error = "entity is not a player"

		return false
	end

	if not entity.is_alive(slot1) then
		slot0.error = "entity is not alive"

		return false
	end

	slot0.entity = slot1
	slot0.weapon_ent = entity.get_player_weapon(slot1)

	if slot0.weapon_ent == nil then
		slot0.error = "no weapon (failed entity.get_player_weapon)"

		return false
	end

	slot0.nade_info = uv1(slot0.weapon_ent)

	if not slot0.nade_info.is_grenade then
		slot0.error = "weapon is not a grenade"

		return false
	end
end

return slot12
