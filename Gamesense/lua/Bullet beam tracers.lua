local var_0_0 = bit.band
local var_0_1 = bit.bor
local var_0_2 = client.eye_position
local var_0_3 = client.find_signature
local var_0_4 = client.userid_to_entindex
local var_0_5 = entity.get_local_player
local var_0_6 = entity.get_player_weapon
local var_0_7 = entity.get_prop
local var_0_8 = entity.hitbox_position
local var_0_9 = entity.is_enemy
local var_0_10 = globals.realtime
local var_0_11 = globals.tickcount
local var_0_12 = math.sqrt
local var_0_13 = table.insert
local var_0_14 = table.remove
local var_0_15 = ui.get
local var_0_16 = ui.new_checkbox
local var_0_17 = ui.new_color_picker
local var_0_18 = ui.new_combobox
local var_0_19 = ui.new_slider
local var_0_20 = ui.reference
local var_0_21 = pairs
local var_0_22 = ui.set
local var_0_23 = ui.set_callback
local var_0_24 = ui.set_visible
local var_0_25 = require("ffi")
local var_0_26 = {
	["Blue glow"] = "sprites/blueglow1.vmt",
	["Light glow"] = "sprites/light_glow02.vmt",
	Physbeam = "sprites/physbeam.vmt",
	["Purple laser"] = "sprites/purplelaser1.vmt"
}
local var_0_27, var_0_28 = var_0_20("VISUALS", "Effects", "Bullet impacts")
local var_0_29 = var_0_16("VISUALS", "Effects", "Bullet beam tracers")
local var_0_30 = var_0_19("VISUALS", "Effects", "\n beam_thickness", 10, 100, 40, true, "sz", 0.1)
local var_0_31 = var_0_18("VISUALS", "Effects", "\n beam_sprite", (function()
	local var_1_0 = {}

	for iter_1_0, iter_1_1 in var_0_21(var_0_26) do
		var_1_0[#var_1_0 + 1] = iter_1_0
	end

	return var_1_0
end)())

var_0_22(var_0_31, "Purple laser")

local var_0_32 = var_0_16("VISUALS", "Effects", "Local player tracers")
local var_0_33 = var_0_17("VISUALS", "Effects", "\n beam_local_clr", 37, 96, 142, 145)
local var_0_34 = var_0_16("VISUALS", "Effects", "Local player tracers hit")
local var_0_35 = var_0_17("VISUALS", "Effects", "\n beam_local_hit_clr", 249, 0, 59, 145)
local var_0_36 = var_0_16("VISUALS", "Effects", "Enemy tracers")
local var_0_37 = var_0_17("VISUALS", "Effects", "\n beam_enemy_clr", 155, 54, 187, 255)

var_0_25.cdef("    typedef struct { \n        float x; \n        float y; \n        float z;\n    } bbvec3_t;\n\n    struct bbeam_t\n    {\n        int m_nType;\n        void* m_pStartEnt;\n        int m_nStartAttachment;\n        void* m_pEndEnt;\n        int m_nEndAttachment;\n        bbvec3_t m_vecStart;\n        bbvec3_t m_vecEnd;\n        int m_nModelIndex;\n        const char* m_pszModelName;\n        int m_nHaloIndex;\n        const char* m_pszHaloName;\n        float m_flHaloScale;\n        float m_flLife;\n        float m_flWidth;\n        float m_flEndWidth;\n        float m_flFadeLength;\n        float m_flAmplitude;\n        float m_flBrightness;\n        float m_flSpeed;\n        int m_nStartFrame;\n        float m_flFrameRate;\n        float m_flRed;\n        float m_flGreen;\n        float m_flBlue;\n        bool m_bRenderable;\n        int m_nSegments;\n        int m_nFlags;\n        bbvec3_t m_vecCenter;\n        float m_flStartRadius;\n        float m_flEndRadius;\n    };\n")

local var_0_38 = var_0_3("client.dll", "\xB9\xCC\xCC\xCC̡\xCC\xCC\xCC\xCC\xFF\x10\xA1\xCC\xCC\xCC̹")
local var_0_39 = var_0_25.cast("void**", var_0_25.cast("char*", var_0_38) + 1)[0]
local var_0_40 = var_0_25.cast("void***", var_0_39)
local var_0_41 = var_0_25.cast("void (__thiscall*)(void*, void*)", var_0_40[0][6])
local var_0_42 = var_0_25.cast("void*(__thiscall*)(void*, struct bbeam_t&)", var_0_40[0][12])

local function var_0_43(arg_2_0)
	local var_2_0 = var_0_25.new("bbvec3_t")

	var_2_0.x, var_2_0.y, var_2_0.z = arg_2_0[1], arg_2_0[2], arg_2_0[3]

	return var_2_0
end

local function var_0_44(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = var_0_25.new("struct bbeam_t")
	local var_3_1 = var_0_15(var_0_30) * 0.1

	var_3_0.m_vecStart = var_0_43(arg_3_0)
	var_3_0.m_vecEnd = var_0_43(arg_3_1)
	var_3_0.m_nSegments = 2
	var_3_0.m_nType = 0
	var_3_0.m_bRenderable = true
	var_3_0.m_nFlags = var_0_1(33544)
	var_3_0.m_pszModelName = var_0_26[var_0_15(var_0_31)]
	var_3_0.m_nModelIndex = -1
	var_3_0.m_flHaloScale = 0
	var_3_0.m_nStartAttachment = 0
	var_3_0.m_nEndAttachment = 0
	var_3_0.m_flLife = var_0_15(var_0_28)
	var_3_0.m_flWidth = var_3_1
	var_3_0.m_flEndWidth = var_3_1
	var_3_0.m_flFadeLength = 0
	var_3_0.m_flAmplitude = 0
	var_3_0.m_flSpeed = 0
	var_3_0.m_flFrameRate = 0
	var_3_0.m_nHaloIndex = 0
	var_3_0.m_nStartFrame = 0
	var_3_0.m_flBrightness = arg_3_2[4]
	var_3_0.m_flRed = arg_3_2[1]
	var_3_0.m_flGreen = arg_3_2[2]
	var_3_0.m_flBlue = arg_3_2[3]

	local var_3_2 = var_0_42(var_0_40, var_3_0)

	if var_3_2 ~= nil then
		var_0_41(var_0_39, var_3_2)
	end
end

local function var_0_45(arg_4_0, arg_4_1)
	local var_4_0 = var_0_5() == arg_4_0
	local var_4_1 = var_0_15(var_0_36) and var_0_9(arg_4_0)

	if not var_4_0 and not var_4_1 then
		return
	end

	local var_4_2, var_4_3, var_4_4, var_4_5 = var_0_15(arg_4_1.is_enemy and var_0_37 or var_0_33)

	if not var_0_15(var_0_32) and var_4_0 and not arg_4_1.projected then
		return
	end

	if var_0_15(var_0_34) and not arg_4_1.is_enemy and arg_4_1.projected then
		var_4_2, var_4_3, var_4_4, var_4_5 = var_0_15(var_0_35)
	end

	var_0_44(arg_4_1.origin, arg_4_1.list[#arg_4_1.list], {
		var_4_2,
		var_4_3,
		var_4_4,
		var_4_5
	})
end

local var_0_46 = false
local var_0_47 = -1
local var_0_48 = -1
local var_0_49 = -1
local var_0_50 = {}
local var_0_51 = {}
local var_0_52 = {
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

local function var_0_53()
	if var_0_15(var_0_29) and (var_0_15(var_0_32) or var_0_15(var_0_34)) then
		var_0_50[#var_0_50 + 1] = {
			m_bPassed = false,
			m_flLife = var_0_10() + 0.5,
			m_vecStart = {
				var_0_2()
			}
		}
	end
end

local var_0_54 = {
	aim_fire = function(arg_6_0)
		var_0_46 = true

		var_0_53()
	end,
	setup_command = function()
		local var_7_0 = var_0_5()
		local var_7_1 = var_0_6(var_7_0)

		if var_7_0 == nil or var_7_1 == nil then
			return
		end

		local var_7_2 = var_0_7(var_7_1, "m_flNextPrimaryAttack")
		local var_7_3 = var_0_0(var_0_7(var_7_1, "m_iItemDefinitionIndex") or 0, 65535)

		if var_0_46 == false and var_0_47 ~= -1 and var_7_2 ~= var_0_47 and var_7_3 == var_0_48 then
			var_0_53()
		end

		var_0_46 = false
		var_0_47 = var_7_2
		var_0_48 = var_7_3
	end,
	round_start = function()
		var_0_51 = {}
		var_0_50 = {}
	end,
	weapon_fire = function(arg_9_0)
		local var_9_0 = var_0_11()
		local var_9_1 = var_0_5()
		local var_9_2 = var_0_4(arg_9_0.userid)

		if var_0_51[var_9_2] == nil then
			var_0_51[var_9_2] = {}
		end

		if var_0_51[var_9_2][var_9_0] == nil then
			var_0_51[var_9_2][var_9_0] = {}
		end

		local var_9_3 = var_0_51[var_9_2][var_9_0]
		local var_9_4 = {
			var_0_8(var_9_2, 0)
		}
		local var_9_5 = var_9_2 ~= var_9_1 and var_0_9(var_9_2)

		if var_9_2 == var_9_1 then
			local var_9_6 = false

			for iter_9_0 = 1, #var_0_50 do
				local var_9_7 = var_0_50[iter_9_0]

				if var_9_7 ~= nil and not var_9_7.m_bPassed then
					var_0_50[iter_9_0].m_bPassed = true
					var_9_4, var_9_6 = var_9_7.m_vecStart, true

					break
				end
			end

			if not var_9_6 then
				var_9_4 = nil
			end
		end

		var_0_51[var_9_2][var_9_0][#var_9_3 + 1] = {
			projected = false,
			list = {},
			origin = var_9_4,
			is_enemy = var_9_5,
			dead_time = var_0_10() + 0.5
		}
	end,
	bullet_impact = function(arg_10_0)
		local var_10_0 = var_0_5()
		local var_10_1 = var_0_4(arg_10_0.userid)
		local var_10_2 = var_0_11()

		if var_0_51[var_10_1] == nil or var_0_51[var_10_1][var_10_2] == nil or #var_0_51[var_10_1][var_10_2] <= 0 then
			return
		end

		local var_10_3 = var_0_51[var_10_1][var_10_2]

		var_0_13(var_0_51[var_10_1][var_10_2][#var_10_3].list, {
			arg_10_0.x,
			arg_10_0.y,
			arg_10_0.z
		})
	end,
	player_hurt = function(arg_11_0)
		local var_11_0 = var_0_11()
		local var_11_1 = var_0_5()
		local var_11_2 = var_0_4(arg_11_0.attacker)

		if var_0_51[var_11_2] == nil or var_0_51[var_11_2][var_11_0] == nil then
			return
		end

		local var_11_3 = math.huge
		local var_11_4 = var_0_52[arg_11_0.hitgroup]
		local var_11_5 = var_0_51[var_11_2][var_11_0][#var_0_51[var_11_2][var_11_0]]

		if #var_11_5.list <= 0 then
			return
		end

		for iter_11_0 = 1, #var_11_5.list do
			local var_11_6 = var_11_5.list[iter_11_0]

			if var_11_4 ~= nil then
				for iter_11_1 = 1, #var_11_4 do
					local var_11_7, var_11_8, var_11_9 = var_0_8(var_11_2, var_11_4[iter_11_1])

					if var_11_7 ~= nil then
						local var_11_10 = var_0_12((var_11_6[1] - var_11_7)^2 + (var_11_6[2] - var_11_8)^2 + (var_11_6[3] - var_11_9)^2)

						if var_11_10 < var_11_3 then
							var_11_3 = var_11_10
							var_11_5.projected = true
						end
					end
				end
			end
		end
	end,
	paint = function()
		local var_12_0 = var_0_10()
		local var_12_1 = var_0_5()

		for iter_12_0, iter_12_1 in var_0_21(var_0_51) do
			for iter_12_2, iter_12_3 in var_0_21(iter_12_1) do
				if #iter_12_3 <= 0 or iter_12_3 == {} then
					var_0_51[iter_12_0][iter_12_2] = nil
				end

				for iter_12_4, iter_12_5 in var_0_21(iter_12_3) do
					local var_12_2 = var_0_51[iter_12_0][iter_12_2][iter_12_4]

					if var_12_0 > iter_12_5.dead_time or var_12_2.origin == nil or #var_12_2.list <= 0 then
						var_0_51[iter_12_0][iter_12_2][iter_12_4] = nil
					else
						var_0_45(iter_12_0, var_12_2)

						var_0_51[iter_12_0][iter_12_2][iter_12_4] = nil
					end
				end
			end
		end

		for iter_12_6 = 1, #var_0_50 do
			if var_0_50[iter_12_6] == nil or var_0_50[iter_12_6].m_bPassed or var_12_0 > var_0_50[iter_12_6].m_flLife then
				var_0_14(var_0_50, iter_12_6)

				break
			end
		end
	end
}

local function var_0_55(arg_13_0)
	local var_13_0 = var_0_15(arg_13_0)
	local var_13_1 = ""

	if not var_13_0 then
		var_13_1 = "un"
		var_0_46 = false
		var_0_47 = -1
		var_0_48 = -1
		var_0_49 = -1
		var_0_50 = {}
		var_0_51 = {}
	end

	local var_13_2 = client[var_13_1 .. "set_event_callback"]

	var_0_24(var_0_28, var_13_0 or var_0_15(var_0_27))
	var_0_24(var_0_30, var_13_0)
	var_0_24(var_0_31, var_13_0)
	var_0_24(var_0_32, var_13_0)
	var_0_24(var_0_33, var_13_0)
	var_0_24(var_0_34, var_13_0)
	var_0_24(var_0_35, var_13_0)
	var_0_24(var_0_36, var_13_0)
	var_0_24(var_0_37, var_13_0)

	for iter_13_0, iter_13_1 in var_0_21(var_0_54) do
		var_13_2(iter_13_0, iter_13_1)
	end
end

var_0_55(var_0_29)
var_0_23(var_0_29, var_0_55)
var_0_23(var_0_27, var_0_55)
