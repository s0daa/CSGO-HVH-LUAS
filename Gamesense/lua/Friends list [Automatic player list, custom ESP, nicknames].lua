local var_0_0 = require("gamesense/steamworks")
local var_0_1 = require("gamesense/images")
local var_0_2 = require("ffi")

var_0_2.cdef("\tstruct FRESPVector {\n\t\tfloat x, y, z;\n\t};\n\n\ttypedef struct FRESP_sndinfo_t {\n\t\tint\t m_nGuid;\n\t\tvoid*   m_filenameHandle;\n\t\tint\t m_nSoundSource;\n\t\tint\t m_nChannel;\n\t\tint\t m_nSpeakerEntity;\n\t\tfloat   m_flVolume;\n\t\tfloat   m_flLastSpatializedVolume;\n\t\tfloat   m_flRadius;\n\t\tint\t m_nPitch;\n\t\tstruct FRESPVector* m_pOrigin;\n\t\tstruct FRESPVector* m_pDirection;\n\t\tbool\tm_bUpdatePositions;\n\t\tbool\tm_bIsSentence;\n\t\tbool\tm_bDryMix;\n\t\tbool\tm_bSpeaker;\n\t\tbool\tm_bFromServer;\n\t} FRESPsndinfo_t;\n\n\tstruct FRESPCUtlMemory_sndinfo_t {\n\t\tFRESPsndinfo_t* m_pMemory;\n\t\tint m_nAllocationCount;\n\t\tint m_nGrowSize;\n\t};\n\n\ttypedef struct FRESP_CUtlVector_sndinfo_t {\n\t\tstruct FRESPCUtlMemory_sndinfo_t m_Memory;\n\t\tint m_Size;\n\t\tFRESPsndinfo_t* m_pElements;\n\t} FRESPCUtlVector_sndinfo_t;\n")

local var_0_3 = {}
local var_0_4 = database.read("friend_steamids") or {}
local var_0_5 = database.read("friend_nicknames") or {}
local var_0_6 = {}
local var_0_7 = {}
local var_0_8 = {}
local var_0_9 = {}
local var_0_10 = -1
local var_0_11 = {}
local var_0_12 = {}
local var_0_13 = false
local var_0_14 = {}
local var_0_15 = {}
local var_0_16 = false
local var_0_17 = false
local var_0_18 = 0
local var_0_19 = 0
local var_0_20 = 0
local var_0_21 = 0
local var_0_22 = 0
local var_0_23 = 0
local var_0_24 = 0
local var_0_25 = 0
local var_0_26 = 0
local var_0_27 = 0
local var_0_28 = 0
local var_0_29 = 0
local var_0_30 = 0
local var_0_31 = false
local var_0_32 = false
local var_0_33 = false
local var_0_34 = false
local var_0_35 = false
local var_0_36 = false
local var_0_37 = false
local var_0_38
local var_0_39 = var_0_2.new("FRESPsndinfo_t[1000]")
local var_0_40 = var_0_2.new("FRESPCUtlVector_sndinfo_t")

var_0_40.m_Memory.m_pMemory = var_0_2.cast("FRESPsndinfo_t*", var_0_39)
var_0_40.m_Memory.m_nAllocationCount = 1000
var_0_40.m_Memory.m_nGrowSize = 1
var_0_40.m_Size = 0
var_0_40.m_pElements = var_0_40.m_Memory.m_pMemory

local var_0_41 = vtable_bind("engine.dll", "IEngineSoundClient003", 19, "void*(__thiscall*)(void*, FRESPCUtlVector_sndinfo_t*)")
local var_0_42 = false
local var_0_43 = false
local var_0_44 = false
local var_0_45 = false
local var_0_46 = 0.5
local var_0_47 = {
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
}
local var_0_48 = 0

for iter_0_0 in pairs(var_0_47) do
	var_0_48 = var_0_48 + 1
end

local function var_0_49(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in ipairs(arg_1_0) do
		if iter_1_1 == arg_1_1 then
			return true
		end
	end

	return false
end

local function var_0_50()
	if var_0_40 then
		var_0_40.m_Size = 0
	end
end

local function var_0_51()
	if var_0_40 then
		var_0_50()
		var_0_41(var_0_40)
		assert(var_0_40.m_Memory.m_nAllocationCount == 1000, "Too many sounds played at once! >>> Reload Friend ESP!")
		assert(var_0_2.cast("intptr_t", var_0_40.m_Memory.m_pMemory) == var_0_2.cast("intptr_t", var_0_39), "Active sound overflow, raise pre-allocated sound limit from 1000! >>> Reload Friend ESP!")

		for iter_3_0 = 0, var_0_40.m_Size - 1 do
			local var_3_0 = var_0_40.m_pElements[iter_3_0]
			local var_3_1 = tonumber(var_3_0.m_nSoundSource)

			if var_3_1 ~= nil and var_3_1 > 0 and var_3_1 <= 64 and entity.is_dormant(var_3_1) then
				local var_3_2 = tonumber(var_3_0.m_pOrigin.x)
				local var_3_3 = tonumber(var_3_0.m_pOrigin.y)
				local var_3_4 = tonumber(var_3_0.m_pOrigin.z)

				if var_3_2 and var_3_3 and var_3_4 then
					if var_0_8[var_3_1] then
						if var_0_8[var_3_1][1] then
							var_0_8[var_3_1][1][1] = var_3_2
							var_0_8[var_3_1][1][2] = var_3_3
							var_0_8[var_3_1][1][3] = var_3_4
						end
					elseif var_0_49(var_0_6, var_3_1) then
						var_0_8[var_3_1] = {
							{
								var_3_2,
								var_3_3,
								var_3_4,
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

local function var_0_52()
	for iter_4_0, iter_4_1 in ipairs(var_0_9) do
		var_0_0.ISteamFriends.RequestUserInformation(var_0_0.SteamID("[U:1:" .. iter_4_1 .. "]"), true)
	end

	var_0_9 = {}
end

local function var_0_53()
	var_0_15 = {}
	var_0_14 = {}

	for iter_5_0 = 1, 64 do
		local var_5_0 = entity.get_steam64(iter_5_0)

		if var_5_0 and var_5_0 ~= 0 then
			var_0_15[#var_0_15 + 1] = var_5_0
			var_0_14[#var_0_14 + 1] = entity.get_player_name(iter_5_0)
		end
	end
end

local function var_0_54()
	var_0_6 = {}
	var_0_7 = {}

	local var_6_0 = entity.get_local_player()

	for iter_6_0 = 1, 64 do
		if iter_6_0 ~= var_6_0 then
			local var_6_1 = tostring(entity.get_steam64(iter_6_0))

			if var_0_49(var_0_4, var_6_1) then
				var_0_6[#var_0_6 + 1] = iter_6_0

				if var_0_5[var_6_1] then
					var_0_7[iter_6_0] = var_0_5[var_6_1]
				end
			end
		end
	end
end

local function var_0_55(arg_7_0)
	ui.set_visible(var_0_11.nickname_edit, false)

	var_0_3 = {}

	for iter_7_0, iter_7_1 in ipairs(var_0_4) do
		if iter_7_1 and iter_7_1 ~= 0 then
			local var_7_0 = var_0_0.SteamID("[U:1:" .. iter_7_1 .. "]")

			if var_7_0 and var_7_0:is_valid() then
				local var_7_1 = var_0_0.ISteamFriends.GetFriendPersonaName(var_7_0)

				if var_7_1 == "[unknown]" or arg_7_0 then
					var_0_9[#var_0_9 + 1] = iter_7_1

					if var_0_10 == -1 then
						var_0_10 = 0
					end
				end

				local var_7_2 = var_0_5[tostring(iter_7_1)]

				if var_7_2 then
					var_7_1 = var_7_1 .. " (" .. var_7_2 .. ")"
				end

				var_0_3[iter_7_0] = var_7_1
			else
				error("Parsed invalid friend record at idx " .. iter_7_0 .. " and steamid " .. iter_7_1)
			end
		end
	end

	if #var_0_9 > 0 and var_0_10 < 5 then
		var_0_52()
		client.delay_call(1, var_0_55)

		var_0_10 = var_0_10 + 1
	elseif var_0_10 >= 5 then
		var_0_10 = -1

		client.delay_call(1, function()
			local var_8_0 = {}

			for iter_8_0 = 1, #var_0_9 do
				local var_8_1 = var_0_9[iter_8_0]
				local var_8_2 = false

				for iter_8_1, iter_8_2 in ipairs(var_0_4) do
					if iter_8_2 == var_8_1 then
						var_0_4[iter_8_1] = nil
						var_8_2 = true

						break
					end
				end

				if not var_8_2 then
					error("Fatal error: Could not find added SteamID in Friends database. " .. var_8_1)
				end

				var_8_0[#var_8_0 + 1] = var_8_1
			end

			var_0_9 = {}

			var_0_55()

			for iter_8_3 = 1, #var_8_0 do
				print("Failed to fetch SteamID ", var_8_0[iter_8_3])
			end

			error("Failed to fetch above SteamID's")
		end)
	end

	var_0_54()
	ui.update(var_0_11.friend_list, var_0_3)
end

local function var_0_56()
	ui.set_visible(var_0_11.add_friend, not var_0_16)
	ui.set_visible(var_0_11.remove_friend, not var_0_16)
	ui.set_visible(var_0_11.nickname_edit, not var_0_16)
	ui.set_visible(var_0_11.remove_confirm, var_0_16)
	ui.set_visible(var_0_11.cancel, var_0_16)
end

local function var_0_57()
	var_0_16 = true

	var_0_56()
end

local function var_0_58()
	var_0_16 = false

	var_0_56()

	local var_11_0 = ui.get(var_0_11.friend_list) + 1
	local var_11_1 = var_0_4[var_11_0]

	if var_0_5[tostring(var_11_1)] then
		var_0_5[tostring(var_11_1)] = nil
	end

	table.remove(var_0_4, var_11_0)
	var_0_55()
end

local function var_0_59()
	ui.set_visible(var_0_11.add_friend, not var_0_13)
	ui.set_visible(var_0_11.remove_friend, not var_0_13)
	ui.set_visible(var_0_11.nickname_edit, not var_0_13)
	ui.set_visible(var_0_11.add_final, var_0_13)
	ui.set_visible(var_0_11.add_label, var_0_13)
	ui.set_visible(var_0_11.add_friend_list, var_0_13)
	ui.set_visible(var_0_11.add_steamid, var_0_13)
	ui.set_visible(var_0_11.cancel, var_0_13)
end

local function var_0_60()
	var_0_13 = true

	var_0_59()
	var_0_53()
	ui.update(var_0_11.add_friend_list, var_0_14)
end

local function var_0_61()
	local var_14_0 = ui.get(var_0_11.add_steamid)

	if var_14_0 and var_14_0 ~= 0 then
		local var_14_1 = var_0_0.SteamID("[U:1:" .. var_14_0 .. "]")

		if var_14_1 and var_14_1:is_valid() then
			if not var_0_49(var_0_4, var_14_0) then
				var_0_4[#var_0_4 + 1] = var_14_0

				var_0_55()

				var_0_13 = false

				var_0_59()

				var_0_14 = {}

				ui.update(var_0_11.add_friend_list, var_0_14)
				ui.set(var_0_11.add_steamid, "")
			else
				error("Player is already a friend.")
			end
		else
			error("Invalid SteamID (needs to be Steam3 ID, without brackets and U:1:).")
		end
	end
end

local function var_0_62()
	ui.set_visible(var_0_11.nickname_edit, not var_0_17)
	ui.set_visible(var_0_11.add_friend, not var_0_17)
	ui.set_visible(var_0_11.remove_friend, not var_0_17)
	ui.set_visible(var_0_11.nickname_done, var_0_17)
	ui.set_visible(var_0_11.nickname_textbox, var_0_17)
end

local function var_0_63()
	var_0_17 = true
	var_0_18 = var_0_4[ui.get(var_0_11.friend_list) + 1]

	if var_0_5[tostring(var_0_18)] then
		ui.set(var_0_11.nickname_textbox, var_0_5[tostring(var_0_18)])
	end

	var_0_62()
end

local function var_0_64()
	local var_17_0 = ui.get(var_0_11.nickname_textbox)

	if var_17_0 ~= nil and var_0_18 ~= 0 then
		var_0_17 = false

		var_0_62()
		ui.set(var_0_11.nickname_textbox, "")

		if var_17_0 == "" then
			var_0_5[tostring(var_0_18)] = nil
		else
			var_0_5[tostring(var_0_18)] = var_17_0
		end

		var_0_18 = 0

		var_0_55()
	end
end

local function var_0_65(arg_18_0)
	if var_0_7[arg_18_0] then
		return var_0_7[arg_18_0]
	else
		return entity.get_player_name(arg_18_0)
	end
end

local function var_0_66(arg_19_0)
	local var_19_0 = client.userid_to_entindex(arg_19_0.userid)

	if var_0_8[var_19_0] then
		var_0_8[var_19_0] = {
			{},
			{}
		}
	end
end

local function var_0_67(arg_20_0, arg_20_1)
	local var_20_0
	local var_20_1
	local var_20_2
	local var_20_3
	local var_20_4
	local var_20_5
	local var_20_6
	local var_20_7
	local var_20_8

	if arg_20_1 then
		if var_0_8[arg_20_0] then
			local var_20_9 = var_0_8[arg_20_0]

			if var_20_9[1] then
				local var_20_10 = var_20_9[1]

				var_20_0, var_20_1, var_20_2 = var_20_10[1], var_20_10[2], var_20_10[3]
				var_20_3, var_20_4, var_20_5 = var_20_10[4], var_20_10[5], var_20_10[6]
				var_20_6, var_20_7, var_20_8 = var_20_10[7], var_20_10[8], var_20_10[9]

				if var_20_0 == nil or var_20_3 == nil or var_20_6 == nil then
					return 0, 0, 0, 0, 0
				end
			end
		else
			return 0, 0, 0, 0, 0
		end
	else
		var_20_0, var_20_1, var_20_2 = entity.get_origin(arg_20_0)
		var_20_3, var_20_4, var_20_5 = entity.get_prop(arg_20_0, "m_vecMins")
		var_20_6, var_20_7, var_20_8 = entity.get_prop(arg_20_0, "m_vecMaxs")

		if var_20_0 == nil or var_20_3 == nil or var_20_6 == nil then
			return 0, 0, 0, 0, 0
		end

		if var_0_8[arg_20_0] then
			var_0_8[arg_20_0][1] = {
				var_20_0,
				var_20_1,
				var_20_2,
				var_20_3,
				var_20_4,
				var_20_5,
				var_20_6,
				var_20_7,
				var_20_8
			}
		else
			var_0_8[arg_20_0] = {
				{
					var_20_0,
					var_20_1,
					var_20_2,
					var_20_3,
					var_20_4,
					var_20_5,
					var_20_6,
					var_20_7,
					var_20_8
				},
				{}
			}
		end
	end

	local var_20_11, var_20_12, var_20_13 = var_20_3 + var_20_0, var_20_4 + var_20_1, var_20_5 + var_20_2
	local var_20_14, var_20_15, var_20_16 = var_20_6 + var_20_0, var_20_7 + var_20_1, var_20_8 + var_20_2
	local var_20_17 = {
		{
			renderer.world_to_screen(var_20_11, var_20_12, var_20_13)
		},
		{
			renderer.world_to_screen(var_20_14, var_20_12, var_20_13)
		},
		{
			renderer.world_to_screen(var_20_14, var_20_15, var_20_13)
		},
		{
			renderer.world_to_screen(var_20_11, var_20_15, var_20_13)
		},
		{
			renderer.world_to_screen(var_20_11, var_20_12, var_20_16)
		},
		{
			renderer.world_to_screen(var_20_14, var_20_12, var_20_16)
		},
		{
			renderer.world_to_screen(var_20_14, var_20_15, var_20_16)
		},
		{
			renderer.world_to_screen(var_20_11, var_20_15, var_20_16)
		}
	}

	for iter_20_0 = 1, #var_20_17 do
		if var_20_17[iter_20_0][1] == nil or var_20_17[iter_20_0][2] == nil then
			return 0, 0, 0, 0, 0
		end
	end

	local var_20_18 = math.min(var_20_17[1][1], var_20_17[2][1], var_20_17[3][1], var_20_17[4][1], var_20_17[5][1], var_20_17[6][1], var_20_17[7][1], var_20_17[8][1])
	local var_20_19 = math.min(var_20_17[1][2], var_20_17[2][2], var_20_17[3][2], var_20_17[4][2], var_20_17[5][2], var_20_17[6][2], var_20_17[7][2], var_20_17[8][2])
	local var_20_20 = math.max(var_20_17[1][1], var_20_17[2][1], var_20_17[3][1], var_20_17[4][1], var_20_17[5][1], var_20_17[6][1], var_20_17[7][1], var_20_17[8][1])
	local var_20_21 = math.max(var_20_17[1][2], var_20_17[2][2], var_20_17[3][2], var_20_17[4][2], var_20_17[5][2], var_20_17[6][2], var_20_17[7][2], var_20_17[8][2])
	local var_20_22 = (var_20_18 and var_20_19 and var_20_20 and var_20_21 and 1 or 0) * (arg_20_1 and 0.2 or 1)

	return var_20_18, var_20_19, var_20_20, var_20_21, var_20_22
end

local function var_0_68()
	for iter_21_0, iter_21_1 in ipairs(var_0_6) do
		if entity.is_alive(iter_21_1) then
			local var_21_0
			local var_21_1
			local var_21_2
			local var_21_3
			local var_21_4
			local var_21_5
			local var_21_6
			local var_21_7
			local var_21_8
			local var_21_9

			if var_0_37 and entity.is_dormant(iter_21_1) then
				if var_0_8[iter_21_1] then
					local var_21_10 = var_0_8[iter_21_1]

					if var_21_10[1] then
						var_21_0, var_21_1, var_21_2, var_21_3, var_21_4 = var_0_67(iter_21_1, true)
					end

					if var_21_10[2] then
						var_21_5 = var_21_10[2][1]
						var_21_6 = var_21_10[2][2]
						var_21_7 = var_21_10[2][3]
						var_21_8 = var_21_10[2][4]
						var_21_9 = var_21_10[2][5]
					end
				end
			else
				var_21_0, var_21_1, var_21_2, var_21_3, var_21_4 = var_0_67(iter_21_1)
				var_21_5 = entity.get_prop(iter_21_1, "m_iHealth")
				var_21_6 = entity.get_esp_data(iter_21_1)
				var_21_7 = entity.get_player_weapon(iter_21_1)
				var_21_8 = entity.get_prop(var_21_7, "m_iItemDefinitionIndex")
				var_21_9 = var_0_36 and entity.get_prop(var_21_7, "m_iClip1") or nil

				if var_0_37 and var_0_8[iter_21_1] then
					var_0_8[iter_21_1] = {
						var_0_8[iter_21_1][1],
						{
							var_21_5,
							var_21_6,
							var_21_7,
							var_21_8,
							var_21_9
						}
					}
				end
			end

			if var_21_4 ~= nil and var_21_4 ~= 0 then
				local var_21_11 = entity.is_enemy(iter_21_1)
				local var_21_12
				local var_21_13
				local var_21_14
				local var_21_15

				if var_21_11 then
					var_21_12, var_21_13, var_21_14, var_21_15 = var_0_23, var_0_24, var_0_25, var_0_26 * var_21_4
				else
					var_21_12, var_21_13, var_21_14, var_21_15 = var_0_19, var_0_20, var_0_21, var_0_22 * var_21_4
				end

				local var_21_16 = (var_21_2 - var_21_0) / 2

				if var_0_31 then
					renderer.text(var_21_0 + var_21_16, var_21_1 - 7, var_21_12, var_21_13, var_21_14, var_21_15, "dc", 0, var_0_65(iter_21_1))
				end

				if var_0_32 then
					local var_21_17 = 125 * var_21_4

					renderer.rectangle(var_21_0 - 1, var_21_1, var_21_2 - var_21_0 + 2, 1, 0, 0, 0, var_21_17)
					renderer.rectangle(var_21_0, var_21_1 + 1, var_21_2 - var_21_0, 1, var_21_12, var_21_13, var_21_14, var_21_15)
					renderer.rectangle(var_21_0 + 1, var_21_1 + 2, var_21_2 - var_21_0 - 2, 1, 0, 0, 0, var_21_17)
					renderer.rectangle(var_21_0 - 1, var_21_1 + 1, 1, var_21_3 - var_21_1 - 1, 0, 0, 0, var_21_17)
					renderer.rectangle(var_21_0, var_21_1 + 2, 1, var_21_3 - var_21_1 - 3, var_21_12, var_21_13, var_21_14, var_21_15)
					renderer.rectangle(var_21_0 + 1, var_21_1 + 3, 1, var_21_3 - var_21_1 - 5, 0, 0, 0, var_21_17)
					renderer.rectangle(var_21_0, var_21_3 - 1, var_21_2 - var_21_0 + 2, 1, 0, 0, 0, var_21_17)
					renderer.rectangle(var_21_0 + 1, var_21_3 - 2, var_21_2 - var_21_0, 1, var_21_12, var_21_13, var_21_14, var_21_15)
					renderer.rectangle(var_21_0 + 2, var_21_3 - 3, var_21_2 - var_21_0 - 2, 1, 0, 0, 0, var_21_17)
					renderer.rectangle(var_21_2 - 1, var_21_1 + 2, 1, var_21_3 - var_21_1 - 5, 0, 0, 0, var_21_17)
					renderer.rectangle(var_21_2, var_21_1 + 1, 1, var_21_3 - var_21_1 - 3, var_21_12, var_21_13, var_21_14, var_21_15)
					renderer.rectangle(var_21_2 + 1, var_21_1, 1, var_21_3 - var_21_1 - 1, 0, 0, 0, var_21_17)
				end

				if var_0_33 and var_21_5 then
					local var_21_18 = var_21_1 - var_21_3
					local var_21_19 = math.max(0, math.min(1, var_21_5 / 100))
					local var_21_20 = 248 - 124 * var_21_19
					local var_21_21 = 195 * var_21_19
					local var_21_22 = 13

					renderer.rectangle(var_21_0 - 6, var_21_3, 4, var_21_18, 0, 0, 0, 255 * var_21_4)
					renderer.rectangle(var_21_0 - 5, var_21_3 - 1, 2, (var_21_18 + 2) * (var_21_5 / 100), var_21_20, var_21_21, var_21_22, 255 * var_21_4)

					if var_21_5 ~= 100 then
						renderer.text(var_21_0 - 6, var_21_3 + var_21_18 * (var_21_5 / 100), 255, 255, 255, 255 * var_21_4, "c", 0, var_21_5)
					end
				end

				if var_21_11 and var_0_34 and var_21_6 then
					local var_21_23 = 0

					for iter_21_2 = 1, var_0_48 do
						local var_21_24 = bit.band(var_21_6.flags, bit.lshift(1, iter_21_2 - 1))

						if var_21_24 ~= 0 then
							local var_21_25 = var_0_47[var_21_24]

							if var_21_25 then
								renderer.text(var_21_2 + 3, var_21_1 + var_21_23 * 12, var_21_25[2], var_21_25[3], var_21_25[4], var_21_15, nil, 0, var_21_25[1])

								var_21_23 = var_21_23 + 1
							end
						end
					end
				end

				if var_0_35 and var_21_7 ~= nil then
					local var_21_26 = var_0_1.get_weapon_icon(var_21_8)

					if var_21_26 ~= nil then
						local var_21_27, var_21_28 = var_21_26:measure()

						if var_21_9 ~= nil and var_21_9 ~= -1 then
							var_21_26:draw(var_21_0 + var_21_16 - var_21_27 * var_0_46 / 2 - 10, var_21_3 + 7, var_21_27 * var_0_46, var_21_28 * var_0_46, var_0_27, var_0_28, var_0_29, var_0_30, false)
							renderer.text(var_21_0 + var_21_16 + var_21_27 * var_0_46 / 2, var_21_3 + var_21_28 / 2 - 6, var_0_27, var_0_28, var_0_29, var_0_30, nil, 0, var_21_9)
						else
							var_21_26:draw(var_21_0 + var_21_16 - var_21_27 * var_0_46 / 2, var_21_3 + 7, var_21_27 * var_0_46, var_21_28 * var_0_46, var_0_27, var_0_28, var_0_29, var_0_30, false)
						end
					elseif var_21_7 ~= nil then
						renderer.text(var_21_0 + var_21_16, var_21_3 + 6, var_0_27, var_0_28, var_0_29, var_0_30, nil, 0, entity.get_classname(var_21_7))
					end
				elseif var_0_36 and var_21_9 ~= nil and var_21_9 ~= -1 then
					renderer.text(var_21_0 + var_21_16, var_21_3 + 8, var_0_27, var_0_28, var_0_29, var_0_30, "c", 0, var_21_9)
				end
			end
		end
	end
end

local function var_0_69()
	for iter_22_0, iter_22_1 in ipairs(var_0_6) do
		if var_0_42 then
			plist.set(iter_22_1, "Add to whitelist", var_0_42)
		end

		if var_0_43 then
			plist.set(iter_22_1, "Allow shared ESP updates", var_0_44)
		end

		if var_0_44 then
			plist.set(iter_22_1, "Disable visuals", var_0_44)
		end

		if var_0_45 then
			plist.set(iter_22_1, "High priority", var_0_45)
		end
	end
end

var_0_11 = {
	show = ui.new_checkbox("LUA", "A", "Show Friend Options"),
	friend_esp = ui.new_multiselect("LUA", "A", "Friend ESP", "Name", "Box", "Health", "Flags", "Weapon", "Ammo", "Dormant"),
	friend_team_label = ui.new_label("LUA", "A", "Friend team ESP color"),
	friend_esp_color = ui.new_color_picker("LUA", "A", "Friend ESP color", 0, 255, 0, 255),
	friend_enemy_label = ui.new_label("LUA", "A", "Friend enemy ESP color"),
	friend_enemy_esp_color = ui.new_color_picker("LUA", "A", "Friend enemy ESP color2", 255, 0, 0, 255),
	friend_options = ui.new_multiselect("LUA", "A", "Friend options", "Add to whitelist", "Allow shared ESP updates", "Disable visuals", "High priority"),
	friend_list_label = ui.new_label("LUA", "A", "Friend list"),
	friend_list = ui.new_listbox("LUA", "A", "Friends", nil),
	add_friend = ui.new_button("LUA", "A", "Add friend", var_0_60),
	remove_friend = ui.new_button("LUA", "A", "Remove friend", var_0_57),
	add_final = ui.new_button("LUA", "A", "Add to friends", var_0_61),
	nickname_edit = ui.new_button("LUA", "A", "Edit nickname", var_0_63),
	nickname_done = ui.new_button("LUA", "A", "Save", var_0_64),
	nickname_textbox = ui.new_textbox("LUA", "A", "Friend nickname"),
	remove_confirm = ui.new_button("LUA", "A", "Confirm remove", var_0_58),
	cancel = ui.new_button("LUA", "A", "Cancel", function()
		if var_0_13 then
			var_0_13 = false

			ui.set_visible(var_0_11.add_friend, not var_0_13)
			ui.set_visible(var_0_11.remove_friend, not var_0_13)
			ui.set_visible(var_0_11.add_final, var_0_13)
			ui.set_visible(var_0_11.add_label, var_0_13)
			ui.set_visible(var_0_11.add_friend_list, var_0_13)
			ui.set_visible(var_0_11.add_steamid, var_0_13)
			ui.set_visible(var_0_11.cancel, var_0_13)

			var_0_14 = {}

			ui.update(var_0_11.add_friend_list, var_0_14)
			ui.set(var_0_11.add_steamid, "")
		elseif var_0_16 then
			var_0_16 = false

			ui.set_visible(var_0_11.add_friend, not var_0_16)
			ui.set_visible(var_0_11.remove_friend, not var_0_16)
			ui.set_visible(var_0_11.remove_confirm, var_0_16)
			ui.set_visible(var_0_11.cancel, var_0_16)
		elseif var_0_17 then
			var_0_17 = false

			ui.set_visible(var_0_11.nickname_edit, not var_0_17)
			ui.set_visible(var_0_11.nickname_done, var_0_17)
			ui.set_visible(var_0_11.nickname_textbox, var_0_17)
			ui.set(var_0_11.nickname_textbox, "")
		end

		ui.set_visible(var_0_11.cancel, false)
	end),
	add_label = ui.new_label("LUA", "A", "Friend Steam3 ID"),
	add_steamid = ui.new_textbox("LUA", "A", "SteamID"),
	add_friend_list = ui.new_listbox("LUA", "A", "In-game players", nil)
}

local var_0_70 = {
	flags = ui.reference("VISUALS", "Player ESP", "Flags"),
	wep_icons = ui.reference("VISUALS", "Player ESP", "Weapon icon"),
	wep_color = select(2, ui.reference("VISUALS", "Player ESP", "Weapon icon"))
}

local function var_0_71()
	local var_24_0 = ui.get(var_0_11.show)

	ui.set(var_0_11.cancel, true)
	ui.set_visible(var_0_11.friend_esp, var_24_0)
	ui.set_visible(var_0_11.friend_team_label, var_24_0)
	ui.set_visible(var_0_11.friend_esp_color, var_24_0)
	ui.set_visible(var_0_11.friend_enemy_label, var_24_0)
	ui.set_visible(var_0_11.friend_enemy_esp_color, var_24_0)
	ui.set_visible(var_0_11.friend_options, var_24_0)
	ui.set_visible(var_0_11.friend_list_label, var_24_0)
	ui.set_visible(var_0_11.friend_list, var_24_0)
	ui.set_visible(var_0_11.add_friend, var_24_0)
	ui.set_visible(var_0_11.remove_friend, var_24_0)
	ui.set_visible(var_0_11.nickname_edit, false)
end

ui.set_callback(var_0_11.show, var_0_71)
var_0_71()

local function var_0_72()
	if ui.get(var_0_11.friend_list) ~= nil and not var_0_13 and not var_0_16 then
		ui.set_visible(var_0_11.nickname_edit, true)
	else
		ui.set_visible(var_0_11.nickname_edit, false)
	end
end

ui.set_callback(var_0_11.friend_list, var_0_72)
ui.set_callback(var_0_11.add_friend_list, function()
	if var_0_13 then
		local var_26_0 = ui.get(var_0_11.add_friend_list) + 1

		ui.set(var_0_11.add_steamid, var_0_15[var_26_0])
	end
end)

local function var_0_73()
	local var_27_0 = ui.get(var_0_11.friend_esp)
	local var_27_1 = ui.get(var_0_11.friend_options)

	if #var_27_1 ~= 0 or #var_27_0 ~= 0 then
		var_0_54()
		client.set_event_callback("player_connect_full", var_0_54)
		client.set_event_callback("level_init", var_0_54)
	else
		client.unset_event_callback("player_connect_full", var_0_54)
		client.unset_event_callback("level_init", var_0_54)
	end

	if #var_27_0 ~= 0 then
		client.set_event_callback("paint", var_0_68)
	else
		client.unset_event_callback("paint", var_0_68)
	end

	if #var_27_1 ~= 0 then
		client.set_event_callback("net_update_end", var_0_69)
	else
		client.unset_event_callback("net_update_end", var_0_69)
	end

	var_0_31 = var_0_49(var_27_0, "Name")
	var_0_32 = var_0_49(var_27_0, "Box")
	var_0_33 = var_0_49(var_27_0, "Health")
	var_0_34 = var_0_49(var_27_0, "Flags")
	var_0_35 = var_0_49(var_27_0, "Weapon")
	var_0_36 = var_0_49(var_27_0, "Ammo")
	var_0_37 = var_0_49(var_27_0, "Dormant")

	if var_0_37 then
		client.set_event_callback("player_spawn", var_0_66)
		client.set_event_callback("net_update_end", var_0_51)
	else
		client.unset_event_callback("player_spawn", var_0_66)
		client.unset_event_callback("net_update_end", var_0_51)
		var_0_50()

		var_0_8 = {}
	end

	var_0_42 = var_0_49(var_27_1, "Add to whitelist")
	var_0_43 = var_0_49(var_27_1, "Allow shared ESP updates")
	var_0_44 = var_0_49(var_27_1, "Disable visuals")
	var_0_45 = var_0_49(var_27_1, "High priority")

	for iter_27_0, iter_27_1 in ipairs(var_0_6) do
		plist.set(iter_27_1, "Add to whitelist", var_0_42)
		plist.set(iter_27_1, "Allow shared ESP updates", var_0_44)
		plist.set(iter_27_1, "Disable visuals", var_0_44)
		plist.set(iter_27_1, "High priority", var_0_45)
	end
end

ui.set_callback(var_0_11.friend_esp, var_0_73)
ui.set_callback(var_0_11.friend_options, var_0_73)
ui.set_callback(var_0_11.friend_esp_color, function()
	var_0_19, var_0_20, var_0_21, var_0_22 = ui.get(var_0_11.friend_esp_color)
end)

var_0_19, var_0_20, var_0_21, var_0_22 = ui.get(var_0_11.friend_esp_color)

ui.set_callback(var_0_11.friend_enemy_esp_color, function()
	var_0_23, var_0_24, var_0_25, var_0_26 = ui.get(var_0_11.friend_enemy_esp_color)
end)

var_0_23, var_0_24, var_0_25, var_0_26 = ui.get(var_0_11.friend_enemy_esp_color)

ui.set_callback(var_0_70.wep_color, function()
	var_0_27, var_0_28, var_0_29, var_0_30 = ui.get(var_0_70.wep_color)
end)

var_0_27, var_0_28, var_0_29, var_0_30 = ui.get(var_0_70.wep_color)

ui.set_visible(var_0_11.add_final, false)
ui.set_visible(var_0_11.add_label, false)
ui.set_visible(var_0_11.add_friend_list, false)
ui.set_visible(var_0_11.add_steamid, false)
ui.set_visible(var_0_11.nickname_edit, false)
ui.set_visible(var_0_11.nickname_done, false)
ui.set_visible(var_0_11.nickname_textbox, false)
ui.set_visible(var_0_11.remove_confirm, false)
ui.set_visible(var_0_11.cancel, false)
var_0_55(true)
client.set_event_callback("shutdown", function()
	for iter_31_0, iter_31_1 in ipairs(var_0_6) do
		plist.set(iter_31_1, "Add to whitelist", false)
		plist.set(iter_31_1, "Allow shared ESP updates", false)
		plist.set(iter_31_1, "Disable visuals", false)
		plist.set(iter_31_1, "High priority", false)
	end

	database.write("friend_steamids", var_0_4)
	database.write("friend_nicknames", var_0_5)
end)
