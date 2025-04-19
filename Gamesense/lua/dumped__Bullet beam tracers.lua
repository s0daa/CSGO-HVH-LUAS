slot0 = bit.band
slot1 = bit.bor
slot2 = client.eye_position
slot4 = client.userid_to_entindex
slot5 = entity.get_local_player
slot6 = entity.get_player_weapon
slot7 = entity.get_prop
slot8 = entity.hitbox_position
slot9 = entity.is_enemy
slot10 = globals.realtime
slot11 = globals.tickcount
slot12 = math.sqrt
slot13 = table.insert
slot14 = table.remove
slot15 = ui.get
slot16 = ui.new_checkbox
slot17 = ui.new_color_picker
slot21 = pairs
slot23 = ui.set_callback
slot24 = ui.set_visible
slot25 = require("ffi")
slot26 = {
	["Light glow"] = "sprites/light_glow02.vmt",
	["Blue glow"] = "sprites/blueglow1.vmt",
	["Purple laser"] = "sprites/purplelaser1.vmt",
	Physbeam = "sprites/physbeam.vmt"
}
slot27, slot28 = ui.reference("VISUALS", "Effects", "Bullet impacts")
slot29 = slot16("VISUALS", "Effects", "Bullet beam tracers")
slot30 = ui.new_slider("VISUALS", "Effects", "\n beam_thickness", 10, 100, 40, true, "sz", 0.1)

ui.set(ui.new_combobox("VISUALS", "Effects", "\n beam_sprite", function ()
	slot0 = {}

	for slot4, slot5 in uv0(uv1) do
		slot0[#slot0 + 1] = slot4
	end

	return slot0
end()), "Purple laser")

slot32 = slot16("VISUALS", "Effects", "Local player tracers")
slot33 = slot17("VISUALS", "Effects", "\n beam_local_clr", 37, 96, 142, 145)
slot34 = slot16("VISUALS", "Effects", "Local player tracers hit")
slot35 = slot17("VISUALS", "Effects", "\n beam_local_hit_clr", 249, 0, 59, 145)
slot36 = slot16("VISUALS", "Effects", "Enemy tracers")
slot37 = slot17("VISUALS", "Effects", "\n beam_enemy_clr", 155, 54, 187, 255)

slot25.cdef([[
    typedef struct { 
        float x; 
        float y; 
        float z;
    } bbvec3_t;

    struct bbeam_t
    {
        int m_nType;
        void* m_pStartEnt;
        int m_nStartAttachment;
        void* m_pEndEnt;
        int m_nEndAttachment;
        bbvec3_t m_vecStart;
        bbvec3_t m_vecEnd;
        int m_nModelIndex;
        const char* m_pszModelName;
        int m_nHaloIndex;
        const char* m_pszHaloName;
        float m_flHaloScale;
        float m_flLife;
        float m_flWidth;
        float m_flEndWidth;
        float m_flFadeLength;
        float m_flAmplitude;
        float m_flBrightness;
        float m_flSpeed;
        int m_nStartFrame;
        float m_flFrameRate;
        float m_flRed;
        float m_flGreen;
        float m_flBlue;
        bool m_bRenderable;
        int m_nSegments;
        int m_nFlags;
        bbvec3_t m_vecCenter;
        float m_flStartRadius;
        float m_flEndRadius;
    };
]])

slot40 = slot25.cast("void***", slot25.cast("void**", slot25.cast("char*", client.find_signature("client.dll", "\\xb9\\xcc\\xcc\\xcc̡\\xcc\\xcc\\xcc\\xcc\\xff\\xa1\\xcc\\xcc\\xcc̹")) + 1)[0])
slot41 = slot25.cast("void (__thiscall*)(void*, void*)", slot40[0][6])
slot42 = slot25.cast("void*(__thiscall*)(void*, struct bbeam_t&)", slot40[0][12])

function slot43(slot0)
	slot1 = uv0.new("bbvec3_t")
	slot1.z = slot0[3]
	slot1.y = slot0[2]
	slot1.x = slot0[1]

	return slot1
end

function slot44(slot0, slot1, slot2)
	slot3 = uv0.new("struct bbeam_t")
	slot4 = uv1(uv2) * 0.1
	slot3.m_vecStart = uv3(slot0)
	slot3.m_vecEnd = uv3(slot1)
	slot3.m_nSegments = 2
	slot3.m_nType = 0
	slot3.m_bRenderable = true
	slot3.m_nFlags = uv4(33544)
	slot3.m_pszModelName = uv5[uv1(uv6)]
	slot3.m_nModelIndex = -1
	slot3.m_flHaloScale = 0
	slot3.m_nStartAttachment = 0
	slot3.m_nEndAttachment = 0
	slot3.m_flLife = uv1(uv7)
	slot3.m_flWidth = slot4
	slot3.m_flEndWidth = slot4
	slot3.m_flFadeLength = 0
	slot3.m_flAmplitude = 0
	slot3.m_flSpeed = 0
	slot3.m_flFrameRate = 0
	slot3.m_nHaloIndex = 0
	slot3.m_nStartFrame = 0
	slot3.m_flBrightness = slot2[4]
	slot3.m_flRed = slot2[1]
	slot3.m_flGreen = slot2[2]
	slot3.m_flBlue = slot2[3]

	if uv8(uv9, slot3) ~= nil then
		uv10(uv11, slot5)
	end
end

function slot45(slot0, slot1)
	if not (uv0() == slot0) and not (uv1(uv2) and uv3(slot0)) then
		return
	end

	slot5, slot6, slot7, slot8 = uv1(slot1.is_enemy and uv4 or uv5)

	if not uv1(uv6) and slot3 and not slot1.projected then
		return
	end

	if uv1(uv7) and not slot1.is_enemy and slot1.projected then
		slot5, slot6, slot7, slot8 = uv1(uv8)
	end

	uv9(slot1.origin, slot1.list[#slot1.list], {
		slot5,
		slot6,
		slot7,
		slot8
	})
end

slot46 = false
slot47 = -1
slot48 = -1
slot49 = -1
slot50 = {}
slot51 = {}
slot52 = {
	{
		0,
		1
	},
	{
		4,
		5,
		6
	},
	{
		2,
		3
	},
	{
		13,
		15,
		16
	},
	{
		14,
		17,
		18
	},
	{
		7,
		9,
		11
	},
	{
		8,
		10,
		12
	}
}

function slot53()
	if uv0(uv1) and (uv0(uv2) or uv0(uv3)) then
		uv4[#uv4 + 1] = {
			m_bPassed = false,
			m_flLife = uv5() + 0.5,
			m_vecStart = {
				uv6()
			}
		}
	end
end

slot54 = {
	aim_fire = function (slot0)
		uv0 = true

		uv1()
	end,
	setup_command = function ()
		slot0 = uv0()
		slot1 = uv1(slot0)

		if slot0 == nil or slot1 == nil then
			return
		end

		slot2 = uv2(slot1, "m_flNextPrimaryAttack")
		slot3 = uv3(uv2(slot1, "m_iItemDefinitionIndex") or 0, 65535)

		if uv4 == false and uv5 ~= -1 and slot2 ~= uv5 and slot3 == uv6 then
			uv7()
		end

		uv4 = false
		uv5 = slot2
		uv6 = slot3
	end,
	round_start = function ()
		uv0 = {}
		uv1 = {}
	end,
	weapon_fire = function (slot0)
		slot1 = uv0()
		slot2 = uv1()

		if uv3[uv2(slot0.userid)] == nil then
			uv3[slot3] = {}
		end

		if uv3[slot3][slot1] == nil then
			uv3[slot3][slot1] = {}
		end

		slot4 = uv3[slot3][slot1]
		slot5 = {
			uv4(slot3, 0)
		}
		slot6 = slot3 ~= slot2 and uv5(slot3)

		if slot3 == slot2 then
			slot7 = false

			for slot11 = 1, #uv6 do
				if uv6[slot11] ~= nil and not slot12.m_bPassed then
					uv6[slot11].m_bPassed = true
					slot7 = true
					slot5 = slot12.m_vecStart

					break
				end
			end

			if not slot7 then
				slot5 = nil
			end
		end

		uv3[slot3][slot1][#slot4 + 1] = {
			projected = false,
			list = {},
			origin = slot5,
			is_enemy = slot6,
			dead_time = uv7() + 0.5
		}
	end,
	bullet_impact = function (slot0)
		slot1 = uv0()
		slot3 = uv2()

		if uv3[uv1(slot0.userid)] == nil or uv3[slot2][slot3] == nil or #uv3[slot2][slot3] <= 0 then
			return
		end

		uv4(uv3[slot2][slot3][#uv3[slot2][slot3]].list, {
			slot0.x,
			slot0.y,
			slot0.z
		})
	end,
	player_hurt = function (slot0)
		slot1 = uv0()
		slot2 = uv1()

		if uv3[uv2(slot0.attacker)] == nil or uv3[slot3][slot1] == nil then
			return
		end

		slot4 = math.huge
		slot5 = uv4[slot0.hitgroup]

		if #uv3[slot3][slot1][#uv3[slot3][slot1]].list <= 0 then
			return
		end

		for slot10 = 1, #slot6.list do
			slot11 = slot6.list[slot10]

			if slot5 ~= nil then
				for slot15 = 1, #slot5 do
					slot16, slot17, slot18 = uv5(slot3, slot5[slot15])

					if slot16 ~= nil and uv6((slot11[1] - slot16)^2 + (slot11[2] - slot17)^2 + (slot11[3] - slot18)^2) < slot4 then
						slot4 = slot19
						slot6.projected = true
					end
				end
			end
		end
	end,
	paint = function ()
		slot0 = uv0()
		slot1 = uv1()

		for slot5, slot6 in uv2(uv3) do
			for slot10, slot11 in uv2(slot6) do
				if #slot11 <= 0 or slot11 == {} then
					uv3[slot5][slot10] = nil
				end

				for slot15, slot16 in uv2(slot11) do
					slot17 = uv3[slot5][slot10][slot15]

					if slot16.dead_time < slot0 or slot17.origin == nil or #slot17.list <= 0 then
						uv3[slot5][slot10][slot15] = nil
					else
						uv4(slot5, slot17)

						uv3[slot5][slot10][slot15] = nil
					end
				end
			end
		end

		for slot5 = 1, #uv5 do
			if uv5[slot5] == nil or uv5[slot5].m_bPassed or uv5[slot5].m_flLife < slot0 then
				uv6(uv5, slot5)

				break
			end
		end
	end
}

function slot55(slot0)
	slot2 = ""

	if not uv0(slot0) then
		slot2 = "un"
		uv1 = false
		uv2 = -1
		uv3 = -1
		uv4 = -1
		uv5 = {}
		uv6 = {}
	end

	uv7(uv8, slot1 or uv0(uv9))
	uv7(uv10, slot1)
	uv7(uv11, slot1)
	uv7(uv12, slot1)
	uv7(uv13, slot1)
	uv7(uv14, slot1)
	uv7(uv15, slot1)
	uv7(uv16, slot1)
	uv7(uv17, slot1)

	for slot7, slot8 in uv18(uv19) do
		client[slot2 .. "set_event_callback"](slot7, slot8)
	end
end

slot55(slot29)
slot23(slot29, slot55)
slot23(slot27, slot55)
