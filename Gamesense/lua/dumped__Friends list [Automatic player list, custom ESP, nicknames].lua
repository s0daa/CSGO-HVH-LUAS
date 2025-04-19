slot0 = require("gamesense/steamworks")
slot1 = require("gamesense/images")

require("ffi").cdef([[
	struct FRESPVector {
		float x, y, z;
	};

	typedef struct FRESP_sndinfo_t {
		int	 m_nGuid;
		void*   m_filenameHandle;
		int	 m_nSoundSource;
		int	 m_nChannel;
		int	 m_nSpeakerEntity;
		float   m_flVolume;
		float   m_flLastSpatializedVolume;
		float   m_flRadius;
		int	 m_nPitch;
		struct FRESPVector* m_pOrigin;
		struct FRESPVector* m_pDirection;
		bool	m_bUpdatePositions;
		bool	m_bIsSentence;
		bool	m_bDryMix;
		bool	m_bSpeaker;
		bool	m_bFromServer;
	} FRESPsndinfo_t;

	struct FRESPCUtlMemory_sndinfo_t {
		FRESPsndinfo_t* m_pMemory;
		int m_nAllocationCount;
		int m_nGrowSize;
	};

	typedef struct FRESP_CUtlVector_sndinfo_t {
		struct FRESPCUtlMemory_sndinfo_t m_Memory;
		int m_Size;
		FRESPsndinfo_t* m_pElements;
	} FRESPCUtlVector_sndinfo_t;
]])

slot3 = {}
slot4 = database.read("friend_steamids") or {}
slot5 = database.read("friend_nicknames") or {}
slot6 = {}
slot7 = {}
slot8 = {}
slot9 = {}
slot10 = -1
slot11 = {}
slot12 = {}
slot13 = false
slot14 = {}
slot15 = {}
slot16 = false
slot17 = false
slot18 = 0
slot19 = 0
slot20 = 0
slot21 = 0
slot22 = 0
slot23 = 0
slot24 = 0
slot25 = 0
slot26 = 0
slot27 = 0
slot28 = 0
slot29 = 0
slot30 = 0
slot31 = false
slot32 = false
slot33 = false
slot34 = false
slot35 = false
slot36 = false
slot37 = false
slot38 = nil
slot38 = slot2.new("FRESPCUtlVector_sndinfo_t")
slot38.m_Memory.m_pMemory = slot2.cast("FRESPsndinfo_t*", slot2.new("FRESPsndinfo_t[1000]"))
slot38.m_Memory.m_nAllocationCount = 1000
slot38.m_Memory.m_nGrowSize = 1
slot38.m_Size = 0
slot38.m_pElements = slot38.m_Memory.m_pMemory
slot40 = vtable_bind("engine.dll", "IEngineSoundClient003", 19, "void*(__thiscall*)(void*, FRESPCUtlVector_sndinfo_t*)")
slot41 = false
slot42 = false
slot43 = false
slot44 = false
slot45 = 0.5

for slot51 in pairs({
	{
		"H",
		255,
		255,
		255
	},
	{
		"K",
		255,
		255,
		255
	},
	[4] = {
		"HK",
		255,
		255,
		255
	},
	[8] = {
		"ZOOM",
		55,
		153,
		190
	},
	[16] = {
		"BLIND",
		55,
		153,
		190
	},
	[32] = {
		"RELOAD",
		55,
		153,
		190
	},
	[64] = {
		"C4",
		255,
		0,
		0
	},
	[128] = {
		"VIP",
		255,
		255,
		255
	},
	[256] = {
		"DEFUSE",
		255,
		0,
		0
	},
	[512] = {
		"FD",
		255,
		255,
		255
	},
	[1024] = {
		"PIN",
		255,
		0,
		0
	},
	[2048] = {
		"HIT",
		255,
		255,
		255
	},
	[4096] = {
		"O",
		255,
		255,
		255
	},
	[8192] = {
		"X",
		255,
		255,
		255
	},
	[131072] = {
		"X",
		255,
		0,
		0
	}
}) do
	slot47 = 0 + 1
end

function slot48(slot0, slot1)
	for slot5, slot6 in ipairs(slot0) do
		if slot6 == slot1 then
			return true
		end
	end

	return false
end

function slot49()
	if uv0 then
		uv0.m_Size = 0
	end
end

function slot50()
	if uv0 then
		uv1()
		uv2(uv0)
		assert(uv0.m_Memory.m_nAllocationCount == 1000, "Too many sounds played at once! >>> Reload Friend ESP!")
		assert(uv3.cast("intptr_t", uv0.m_Memory.m_pMemory) == uv3.cast("intptr_t", uv4), "Active sound overflow, raise pre-allocated sound limit from 1000! >>> Reload Friend ESP!")

		for slot3 = 0, uv0.m_Size - 1 do
			if tonumber(uv0.m_pElements[slot3].m_nSoundSource) ~= nil and slot5 > 0 and slot5 <= 64 and entity.is_dormant(slot5) then
				slot7 = tonumber(slot4.m_pOrigin.y)
				slot8 = tonumber(slot4.m_pOrigin.z)

				if tonumber(slot4.m_pOrigin.x) and slot7 and slot8 then
					if uv5[slot5] then
						if uv5[slot5][1] then
							uv5[slot5][1][1] = slot6
							uv5[slot5][1][2] = slot7
							uv5[slot5][1][3] = slot8
						end
					elseif uv6(uv7, slot5) then
						uv5[slot5] = {
							{
								slot6,
								slot7,
								slot8,
								-16,
								-16,
								0,
								16,
								16,
								72
							},
							{}
						}
					end
				end
			end
		end
	end
end

function slot51()
	for slot3, slot4 in ipairs(uv0) do
		uv1.ISteamFriends.RequestUserInformation(uv1.SteamID("[U:1:" .. slot4 .. "]"), true)
	end

	uv0 = {}
end

function slot52()
	uv0 = {}
	uv1 = {}

	for slot3 = 1, 64 do
		if entity.get_steam64(slot3) and slot4 ~= 0 then
			uv0[#uv0 + 1] = slot4
			uv1[#uv1 + 1] = entity.get_player_name(slot3)
		end
	end
end

function slot53()
	uv0 = {}
	uv1 = {}

	for slot4 = 1, 64 do
		if slot4 ~= entity.get_local_player() and uv2(uv3, tostring(entity.get_steam64(slot4))) then
			uv0[#uv0 + 1] = slot4

			if uv4[slot5] then
				uv1[slot4] = uv4[slot5]
			end
		end
	end
end

function slot55()
	ui.set_visible(uv0.add_friend, not uv1)
	ui.set_visible(uv0.remove_friend, not uv1)
	ui.set_visible(uv0.nickname_edit, not uv1)
	ui.set_visible(uv0.remove_confirm, uv1)
	ui.set_visible(uv0.cancel, uv1)
end

function slot58()
	ui.set_visible(uv0.add_friend, not uv1)
	ui.set_visible(uv0.remove_friend, not uv1)
	ui.set_visible(uv0.nickname_edit, not uv1)
	ui.set_visible(uv0.add_final, uv1)
	ui.set_visible(uv0.add_label, uv1)
	ui.set_visible(uv0.add_friend_list, uv1)
	ui.set_visible(uv0.add_steamid, uv1)
	ui.set_visible(uv0.cancel, uv1)
end

function slot61()
	ui.set_visible(uv0.nickname_edit, not uv1)
	ui.set_visible(uv0.add_friend, not uv1)
	ui.set_visible(uv0.remove_friend, not uv1)
	ui.set_visible(uv0.nickname_done, uv1)
	ui.set_visible(uv0.nickname_textbox, uv1)
end

function slot64(slot0)
	if uv0[slot0] then
		return uv0[slot0]
	else
		return entity.get_player_name(slot0)
	end
end

function slot65(slot0)
	if uv0[client.userid_to_entindex(slot0.userid)] then
		uv0[slot1] = {
			{},
			{}
		}
	end
end

function slot66(slot0, slot1)
	slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10 = nil

	if slot1 then
		if uv0[slot0] then
			if uv0[slot0][1] then
				slot12 = slot11[1]
				slot4 = slot12[3]
				slot3 = slot12[2]
				slot7 = slot12[6]
				slot6 = slot12[5]
				slot10 = slot12[9]
				slot9 = slot12[8]

				if slot12[1] == nil or slot12[4] == nil or slot12[7] == nil then
					return 0, 0, 0, 0, 0
				end
			end
		else
			return 0, 0, 0, 0, 0
		end
	else
		slot11, slot3, slot4 = entity.get_origin(slot0)
		slot5, slot6, slot7 = entity.get_prop(slot0, "m_vecMins")
		slot8, slot9, slot10 = entity.get_prop(slot0, "m_vecMaxs")

		if slot11 == nil or slot5 == nil or slot8 == nil then
			return 0, 0, 0, 0, 0
		end

		if uv0[slot0] then
			uv0[slot0][1] = {
				slot2,
				slot3,
				slot4,
				slot5,
				slot6,
				slot7,
				slot8,
				slot9,
				slot10
			}
		else
			uv0[slot0] = {
				{
					slot2,
					slot3,
					slot4,
					slot5,
					slot6,
					slot7,
					slot8,
					slot9,
					slot10
				},
				{}
			}
		end
	end

	slot7 = slot7 + slot4
	slot6 = slot6 + slot3
	slot5 = slot5 + slot2
	slot10 = slot10 + slot4
	slot9 = slot9 + slot3
	slot8 = slot8 + slot2
	slot15 = slot9

	for slot15 = 1, #{
		{
			renderer.world_to_screen(slot5, slot6, slot7)
		},
		{
			renderer.world_to_screen(slot8, slot6, slot7)
		},
		{
			renderer.world_to_screen(slot8, slot9, slot7)
		},
		{
			renderer.world_to_screen(slot5, slot9, slot7)
		},
		{
			renderer.world_to_screen(slot5, slot6, slot10)
		},
		{
			renderer.world_to_screen(slot8, slot6, slot10)
		},
		{
			renderer.world_to_screen(slot8, slot9, slot10)
		},
		{
			renderer.world_to_screen(slot5, slot15, slot10)
		}
	} do
		if slot11[slot15][1] == nil or slot11[slot15][2] == nil then
			return 0, 0, 0, 0, 0
		end
	end

	slot13 = math.min(slot11[1][2], slot11[2][2], slot11[3][2], slot11[4][2], slot11[5][2], slot11[6][2], slot11[7][2], slot11[8][2])
	slot14 = math.max(slot11[1][1], slot11[2][1], slot11[3][1], slot11[4][1], slot11[5][1], slot11[6][1], slot11[7][1], slot11[8][1])
	slot15 = math.max(slot11[1][2], slot11[2][2], slot11[3][2], slot11[4][2], slot11[5][2], slot11[6][2], slot11[7][2], slot11[8][2])

	return slot12, slot13, slot14, slot15, (math.min(slot11[1][1], slot11[2][1], slot11[3][1], slot11[4][1], slot11[5][1], slot11[6][1], slot11[7][1], slot11[8][1]) and slot13 and slot14 and slot15 and 1 or 0) * (slot1 and 0.2 or 1)
end

function slot67()
	for slot3, slot4 in ipairs(uv0) do
		if entity.is_alive(slot4) then
			slot5, slot6, slot7, slot8, slot9, slot10, slot11, slot12, slot13, slot14 = nil

			if uv1 and entity.is_dormant(slot4) then
				if uv2[slot4] then
					if uv2[slot4][1] then
						slot5, slot6, slot7, slot8, slot9 = uv3(slot4, true)
					end

					if slot15[2] then
						slot10 = slot15[2][1]
						slot11 = slot15[2][2]
						slot12 = slot15[2][3]
						slot13 = slot15[2][4]
						slot14 = slot15[2][5]
					end
				end
			else
				slot5, slot6, slot7, slot8, slot9 = uv3(slot4)

				if uv1 and uv2[slot4] then
					uv2[slot4] = {
						uv2[slot4][1],
						{
							entity.get_prop(slot4, "m_iHealth"),
							entity.get_esp_data(slot4),
							slot12,
							entity.get_prop(entity.get_player_weapon(slot4), "m_iItemDefinitionIndex"),
							uv4 and entity.get_prop(slot12, "m_iClip1") or nil
						}
					}
				end
			end

			if slot9 ~= nil and slot9 ~= 0 then
				slot16, slot17, slot18, slot19 = nil

				if entity.is_enemy(slot4) then
					slot19 = uv8 * slot9
					slot18 = uv7
					slot17 = uv6
					slot16 = uv5
				else
					slot19 = uv12 * slot9
					slot18 = uv11
					slot17 = uv10
					slot16 = uv9
				end

				if uv13 then
					renderer.text(slot5 + (slot7 - slot5) / 2, slot6 - 7, slot16, slot17, slot18, slot19, "dc", 0, uv14(slot4))
				end

				if uv15 then
					slot21 = 125 * slot9

					renderer.rectangle(slot5 - 1, slot6, slot7 - slot5 + 2, 1, 0, 0, 0, slot21)
					renderer.rectangle(slot5, slot6 + 1, slot7 - slot5, 1, slot16, slot17, slot18, slot19)
					renderer.rectangle(slot5 + 1, slot6 + 2, slot7 - slot5 - 2, 1, 0, 0, 0, slot21)
					renderer.rectangle(slot5 - 1, slot6 + 1, 1, slot8 - slot6 - 1, 0, 0, 0, slot21)
					renderer.rectangle(slot5, slot6 + 2, 1, slot8 - slot6 - 3, slot16, slot17, slot18, slot19)
					renderer.rectangle(slot5 + 1, slot6 + 3, 1, slot8 - slot6 - 5, 0, 0, 0, slot21)
					renderer.rectangle(slot5, slot8 - 1, slot7 - slot5 + 2, 1, 0, 0, 0, slot21)
					renderer.rectangle(slot5 + 1, slot8 - 2, slot7 - slot5, 1, slot16, slot17, slot18, slot19)
					renderer.rectangle(slot5 + 2, slot8 - 3, slot7 - slot5 - 2, 1, 0, 0, 0, slot21)
					renderer.rectangle(slot7 - 1, slot6 + 2, 1, slot8 - slot6 - 5, 0, 0, 0, slot21)
					renderer.rectangle(slot7, slot6 + 1, 1, slot8 - slot6 - 3, slot16, slot17, slot18, slot19)
					renderer.rectangle(slot7 + 1, slot6, 1, slot8 - slot6 - 1, 0, 0, 0, slot21)
				end

				if uv16 and slot10 then
					slot21 = slot6 - slot8
					slot22 = math.max(0, math.min(1, slot10 / 100))

					renderer.rectangle(slot5 - 6, slot8, 4, slot21, 0, 0, 0, 255 * slot9)
					renderer.rectangle(slot5 - 5, slot8 - 1, 2, (slot21 + 2) * slot10 / 100, 248 - 124 * slot22, 195 * slot22, 13, 255 * slot9)

					if slot10 ~= 100 then
						renderer.text(slot5 - 6, slot8 + slot21 * slot10 / 100, 255, 255, 255, 255 * slot9, "c", 0, slot10)
					end
				end

				if slot15 and uv17 and slot11 then
					slot21 = 0

					for slot25 = 1, uv18 do
						if bit.band(slot11.flags, bit.lshift(1, slot25 - 1)) ~= 0 and uv19[slot26] then
							renderer.text(slot7 + 3, slot6 + slot21 * 12, slot27[2], slot27[3], slot27[4], slot19, nil, 0, slot27[1])

							slot21 = slot21 + 1
						end
					end
				end

				if uv20 and slot12 ~= nil then
					if uv21.get_weapon_icon(slot13) ~= nil then
						slot22, slot23 = slot21:measure()

						if slot14 ~= nil and slot14 ~= -1 then
							slot21:draw(slot5 + slot20 - slot22 * uv22 / 2 - 10, slot8 + 7, slot22 * uv22, slot23 * uv22, uv23, uv24, uv25, uv26, false)
							renderer.text(slot5 + slot20 + slot22 * uv22 / 2, slot8 + slot23 / 2 - 6, uv23, uv24, uv25, uv26, nil, 0, slot14)
						else
							slot21:draw(slot5 + slot20 - slot22 * uv22 / 2, slot8 + 7, slot22 * uv22, slot23 * uv22, uv23, uv24, uv25, uv26, false)
						end
					elseif slot12 ~= nil then
						renderer.text(slot5 + slot20, slot8 + 6, uv23, uv24, uv25, uv26, nil, 0, entity.get_classname(slot12))
					end
				elseif uv4 and slot14 ~= nil and slot14 ~= -1 then
					renderer.text(slot5 + slot20, slot8 + 8, uv23, uv24, uv25, uv26, "c", 0, slot14)
				end
			end
		end
	end
end

function slot68()
	for slot3, slot4 in ipairs(uv0) do
		if uv1 then
			plist.set(slot4, "Add to whitelist", uv1)
		end

		if uv2 then
			plist.set(slot4, "Allow shared ESP updates", uv3)
		end

		if uv3 then
			plist.set(slot4, "Disable visuals", uv3)
		end

		if uv4 then
			plist.set(slot4, "High priority", uv4)
		end
	end
end

slot11 = {
	show = ui.new_checkbox("LUA", "A", "Show Friend Options"),
	friend_esp = ui.new_multiselect("LUA", "A", "Friend ESP", "Name", "Box", "Health", "Flags", "Weapon", "Ammo", "Dormant"),
	friend_team_label = ui.new_label("LUA", "A", "Friend team ESP color"),
	friend_esp_color = ui.new_color_picker("LUA", "A", "Friend ESP color", 0, 255, 0, 255),
	friend_enemy_label = ui.new_label("LUA", "A", "Friend enemy ESP color"),
	friend_enemy_esp_color = ui.new_color_picker("LUA", "A", "Friend enemy ESP color2", 255, 0, 0, 255),
	friend_options = ui.new_multiselect("LUA", "A", "Friend options", "Add to whitelist", "Allow shared ESP updates", "Disable visuals", "High priority"),
	friend_list_label = ui.new_label("LUA", "A", "Friend list"),
	friend_list = ui.new_listbox("LUA", "A", "Friends", nil),
	add_friend = ui.new_button("LUA", "A", "Add friend", function ()
		uv0 = true

		uv1()
		uv2()
		ui.update(uv3.add_friend_list, uv4)
	end),
	remove_friend = ui.new_button("LUA", "A", "Remove friend", function ()
		uv0 = true

		uv1()
	end),
	add_final = ui.new_button("LUA", "A", "Add to friends", function ()
		if ui.get(uv0.add_steamid) and slot0 ~= 0 then
			if uv1.SteamID("[U:1:" .. slot0 .. "]") and slot1:is_valid() then
				if not uv2(uv3, slot0) then
					uv3[#uv3 + 1] = slot0

					uv4()

					uv5 = false

					uv6()

					uv7 = {}

					ui.update(uv0.add_friend_list, uv7)
					ui.set(uv0.add_steamid, "")
				else
					error("Player is already a friend.")
				end
			else
				error("Invalid SteamID (needs to be Steam3 ID, without brackets and U:1:).")
			end
		end
	end),
	nickname_edit = ui.new_button("LUA", "A", "Edit nickname", function ()
		uv0 = true
		uv1 = uv2[ui.get(uv3.friend_list) + 1]

		if uv4[tostring(uv1)] then
			ui.set(uv3.nickname_textbox, uv4[tostring(uv1)])
		end

		uv5()
	end),
	nickname_done = ui.new_button("LUA", "A", "Save", function ()
		if ui.get(uv0.nickname_textbox) ~= nil and uv1 ~= 0 then
			uv2 = false

			uv3()
			ui.set(uv0.nickname_textbox, "")

			if slot0 == "" then
				uv4[tostring(uv1)] = nil
			else
				uv4[tostring(uv1)] = slot0
			end

			uv1 = 0

			uv5()
		end
	end),
	nickname_textbox = ui.new_textbox("LUA", "A", "Friend nickname"),
	remove_confirm = ui.new_button("LUA", "A", "Confirm remove", function ()
		uv0 = false

		uv1()

		if uv4[tostring(uv3[ui.get(uv2.friend_list) + 1])] then
			uv4[tostring(slot1)] = nil
		end

		table.remove(uv3, slot0)
		uv5()
	end),
	cancel = ui.new_button("LUA", "A", "Cancel", function ()
		if uv0 then
			uv0 = false

			ui.set_visible(uv1.add_friend, not uv0)
			ui.set_visible(uv1.remove_friend, not uv0)
			ui.set_visible(uv1.add_final, uv0)
			ui.set_visible(uv1.add_label, uv0)
			ui.set_visible(uv1.add_friend_list, uv0)
			ui.set_visible(uv1.add_steamid, uv0)
			ui.set_visible(uv1.cancel, uv0)

			uv2 = {}

			ui.update(uv1.add_friend_list, uv2)
			ui.set(uv1.add_steamid, "")
		elseif uv3 then
			uv3 = false

			ui.set_visible(uv1.add_friend, not uv3)
			ui.set_visible(uv1.remove_friend, not uv3)
			ui.set_visible(uv1.remove_confirm, uv3)
			ui.set_visible(uv1.cancel, uv3)
		elseif uv4 then
			uv4 = false

			ui.set_visible(uv1.nickname_edit, not uv4)
			ui.set_visible(uv1.nickname_done, uv4)
			ui.set_visible(uv1.nickname_textbox, uv4)
			ui.set(uv1.nickname_textbox, "")
		end

		ui.set_visible(uv1.cancel, false)
	end),
	add_label = ui.new_label("LUA", "A", "Friend Steam3 ID"),
	add_steamid = ui.new_textbox("LUA", "A", "SteamID"),
	add_friend_list = ui.new_listbox("LUA", "A", "In-game players", nil)
}
slot12 = {
	flags = ui.reference("VISUALS", "Player ESP", "Flags"),
	wep_icons = ui.reference("VISUALS", "Player ESP", "Weapon icon"),
	wep_color = select(2, ui.reference("VISUALS", "Player ESP", "Weapon icon"))
}

function slot69()
	slot0 = ui.get(uv0.show)

	ui.set(uv0.cancel, true)
	ui.set_visible(uv0.friend_esp, slot0)
	ui.set_visible(uv0.friend_team_label, slot0)
	ui.set_visible(uv0.friend_esp_color, slot0)
	ui.set_visible(uv0.friend_enemy_label, slot0)
	ui.set_visible(uv0.friend_enemy_esp_color, slot0)
	ui.set_visible(uv0.friend_options, slot0)
	ui.set_visible(uv0.friend_list_label, slot0)
	ui.set_visible(uv0.friend_list, slot0)
	ui.set_visible(uv0.add_friend, slot0)
	ui.set_visible(uv0.remove_friend, slot0)
	ui.set_visible(uv0.nickname_edit, false)
end

ui.set_callback(slot11.show, slot69)
slot69()
ui.set_callback(slot11.friend_list, function ()
	if ui.get(uv0.friend_list) ~= nil and not uv1 and not uv2 then
		ui.set_visible(uv0.nickname_edit, true)
	else
		ui.set_visible(uv0.nickname_edit, false)
	end
end)
ui.set_callback(slot11.add_friend_list, function ()
	if uv0 then
		ui.set(uv1.add_steamid, uv2[ui.get(uv1.add_friend_list) + 1])
	end
end)

function slot71()
	if #ui.get(uv0.friend_options) ~= 0 or #ui.get(uv0.friend_esp) ~= 0 then
		uv1()
		client.set_event_callback("player_connect_full", uv1)
		client.set_event_callback("level_init", uv1)
	else
		client.unset_event_callback("player_connect_full", uv1)
		client.unset_event_callback("level_init", uv1)
	end

	if #slot0 ~= 0 then
		client.set_event_callback("paint", uv2)
	else
		client.unset_event_callback("paint", uv2)
	end

	if #slot1 ~= 0 then
		client.set_event_callback("net_update_end", uv3)
	else
		client.unset_event_callback("net_update_end", uv3)
	end

	uv4 = uv5(slot0, "Name")
	uv6 = uv5(slot0, "Box")
	uv7 = uv5(slot0, "Health")
	uv8 = uv5(slot0, "Flags")
	uv9 = uv5(slot0, "Weapon")
	uv10 = uv5(slot0, "Ammo")
	uv11 = uv5(slot0, "Dormant")

	if uv11 then
		client.set_event_callback("player_spawn", uv12)
		client.set_event_callback("net_update_end", uv13)
	else
		client.unset_event_callback("player_spawn", uv12)
		client.unset_event_callback("net_update_end", uv13)
		uv14()

		uv15 = {}
	end

	uv16 = uv5(slot1, "Add to whitelist")
	uv17 = uv5(slot1, "Allow shared ESP updates")
	uv18 = uv5(slot1, "Disable visuals")
	uv19 = uv5(slot1, "High priority")

	for slot5, slot6 in ipairs(uv20) do
		plist.set(slot6, "Add to whitelist", uv16)
		plist.set(slot6, "Allow shared ESP updates", uv18)
		plist.set(slot6, "Disable visuals", uv18)
		plist.set(slot6, "High priority", uv19)
	end
end

ui.set_callback(slot11.friend_esp, slot71)
ui.set_callback(slot11.friend_options, slot71)
ui.set_callback(slot11.friend_esp_color, function ()
	uv0, uv1, uv2, uv3 = ui.get(uv4.friend_esp_color)
end)

slot19, slot20, slot21, slot22 = ui.get(slot11.friend_esp_color)

ui.set_callback(slot11.friend_enemy_esp_color, function ()
	uv0, uv1, uv2, uv3 = ui.get(uv4.friend_enemy_esp_color)
end)

slot23, slot24, slot25, slot26 = ui.get(slot11.friend_enemy_esp_color)

ui.set_callback(slot12.wep_color, function ()
	uv0, uv1, uv2, uv3 = ui.get(uv4.wep_color)
end)

slot27, slot28, slot29, slot30 = ui.get(slot12.wep_color)

ui.set_visible(slot11.add_final, false)
ui.set_visible(slot11.add_label, false)
ui.set_visible(slot11.add_friend_list, false)
ui.set_visible(slot11.add_steamid, false)
ui.set_visible(slot11.nickname_edit, false)
ui.set_visible(slot11.nickname_done, false)
ui.set_visible(slot11.nickname_textbox, false)
ui.set_visible(slot11.remove_confirm, false)
ui.set_visible(slot11.cancel, false)
function (slot0)
	ui.set_visible(uv0.nickname_edit, false)

	uv1 = {}

	for slot4, slot5 in ipairs(uv2) do
		if slot5 and slot5 ~= 0 then
			if uv3.SteamID("[U:1:" .. slot5 .. "]") and slot6:is_valid() then
				if uv3.ISteamFriends.GetFriendPersonaName(slot6) == "[unknown]" or slot0 then
					uv4[#uv4 + 1] = slot5

					if uv5 == -1 then
						uv5 = 0
					end
				end

				if uv6[tostring(slot5)] then
					slot7 = slot7 .. " (" .. slot8 .. ")"
				end

				uv1[slot4] = slot7
			else
				error("Parsed invalid friend record at idx " .. slot4 .. " and steamid " .. slot5)
			end
		end
	end

	if #uv4 > 0 and uv5 < 5 then
		uv7()
		client.delay_call(1, uv8)

		uv5 = uv5 + 1
	elseif uv5 >= 5 then
		uv5 = -1

		client.delay_call(1, function ()
			slot0 = {}

			for slot4 = 1, #uv0 do
				slot6 = false

				for slot10, slot11 in ipairs(uv1) do
					if slot11 == uv0[slot4] then
						uv1[slot10] = nil
						slot6 = true

						break
					end
				end

				if not slot6 then
					error("Fatal error: Could not find added SteamID in Friends database. " .. slot5)
				end

				slot0[#slot0 + 1] = slot5
			end

			uv0 = {}

			uv2()

			for slot4 = 1, #slot0 do
				print("Failed to fetch SteamID ", slot0[slot4])
			end

			error("Failed to fetch above SteamID's")
		end)
	end

	uv9()
	ui.update(uv0.friend_list, uv1)
end(true)
client.set_event_callback("shutdown", function ()
	for slot3, slot4 in ipairs(uv0) do
		plist.set(slot4, "Add to whitelist", false)
		plist.set(slot4, "Allow shared ESP updates", false)
		plist.set(slot4, "Disable visuals", false)
		plist.set(slot4, "High priority", false)
	end

	database.write("friend_steamids", uv1)
	database.write("friend_nicknames", uv2)
end)
