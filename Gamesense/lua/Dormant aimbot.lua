local var_0_0 = client.visible
local var_0_1 = client.eye_position
local var_0_2 = client.log
local var_0_3 = client.trace_bullet
local var_0_4 = entity.get_bounding_box
local var_0_5 = entity.get_local_player
local var_0_6 = entity.get_origin
local var_0_7 = entity.get_player_name
local var_0_8 = entity.get_player_resource
local var_0_9 = entity.get_player_weapon
local var_0_10 = entity.get_prop
local var_0_11 = entity.is_dormant
local var_0_12 = entity.is_enemy
local var_0_13 = globals.curtime
local var_0_14 = globals.maxplayers
local var_0_15 = globals.tickcount
local var_0_16 = math.max
local var_0_17 = renderer.indicator
local var_0_18 = string.format
local var_0_19 = ui.get
local var_0_20 = ui.new_checkbox
local var_0_21 = ui.new_hotkey
local var_0_22 = ui.reference
local var_0_23 = ui.set_callback
local var_0_24 = sqrt
local var_0_25 = unpack
local var_0_26 = entity.is_alive
local var_0_27 = plist.get
local var_0_28 = entity.hitbox_position
local var_0_29 = require("ffi")
local var_0_30 = require("vector")
local var_0_31 = require("gamesense/csgo_weapons")
local var_0_32 = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*,int)")
local var_0_33 = vtable_thunk(166, "bool(__thiscall*)(void*)")
local var_0_34 = vtable_thunk(483, "float(__thiscall*)(void*)")
local var_0_35 = {
	mindmg = var_0_22("RAGE", "Aimbot", "Minimum damage"),
	dormantEsp = var_0_22("VISUALS", "Player ESP", "Dormant"),
	override_mindmg = {
		ui.reference("RAGE", "Aimbot", "Minimum damage override")
	}
}
local var_0_36 = var_0_20("RAGE", "Aimbot", "Dormant aimbot")
local var_0_37 = {}

var_0_37[0] = "Inherited"

for iter_0_0 = 1, 26 do
	var_0_37[100 + iter_0_0] = "HP + " .. iter_0_0
end

local var_0_38 = {
	dormantKey = var_0_21("RAGE", "Aimbot", "Dormant aimbot", true),
	dormantHitboxes = ui.new_multiselect("RAGE", "Aimbot", "Dormant target hitbox", "Head", "Chest", "Stomach", "Legs"),
	dormantAccuracy = ui.new_slider("RAGE", "Aimbot", "Dormant aimbot accuracy", 50, 100, 90, true, "%", 1),
	dormantMindmg = ui.new_slider("RAGE", "Aimbot", "Dormant minimum damage", 0, 126, 10, true, nil, 1, var_0_37),
	experimental = ui.new_checkbox("RAGE", "Aimbot", "Dormant aimbot accurate history [experimental]"),
	dormantLogs = ui.new_checkbox("RAGE", "Other", "Log dormant shots"),
	dormantIndicator = ui.new_checkbox("RAGE", "Other", "Dormant aimbot indicator"),
	dormantlastseen = ui.new_checkbox("RAGE", "Other", "Draw dormant position"),
	dormantlastseencolor = ui.new_color_picker("RAGE", "Other", "Dormant aimbot indicator", 255, 255, 255, 255)
}
local var_0_39 = {
	"generic",
	"head",
	"chest",
	"stomach",
	"left arm",
	"right arm",
	"left leg",
	"right leg",
	"neck",
	"?",
	"gear"
}
local var_0_40 = {
	"",
	"Head",
	"Chest",
	"Stomach",
	"Chest",
	"Chest",
	"Legs",
	"Legs",
	"Head",
	"",
	""
}

local function var_0_41(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0, var_1_1 = arg_1_0:to(arg_1_1):angles()
	local var_1_2 = math.rad(var_1_1 + 90)
	local var_1_3 = var_0_30(math.cos(var_1_2), math.sin(var_1_2), 0) * arg_1_2
	local var_1_4 = var_0_30(0, 0, arg_1_2)

	return {
		{
			text = "Middle",
			vec = arg_1_1
		},
		{
			text = "Left",
			vec = arg_1_1 + var_1_3
		},
		{
			text = "Right",
			vec = arg_1_1 - var_1_3
		}
	}
end

local function var_0_42(arg_2_0, arg_2_1)
	for iter_2_0 = 1, #arg_2_0 do
		if arg_2_0[iter_2_0] == arg_2_1 then
			return true
		end
	end

	return false
end

local function var_0_43(arg_3_0, arg_3_1)
	local var_3_0 = math.sqrt(arg_3_0.forwardmove * arg_3_0.forwardmove + arg_3_0.sidemove * arg_3_0.sidemove)

	if arg_3_1 <= 0 or var_3_0 <= 0 then
		return
	end

	if arg_3_0.in_duck == 1 then
		arg_3_1 = arg_3_1 * 2.94117647
	end

	if var_3_0 <= arg_3_1 then
		return
	end

	local var_3_1 = arg_3_1 / var_3_0

	arg_3_0.forwardmove = arg_3_0.forwardmove * var_3_1
	arg_3_0.sidemove = arg_3_0.sidemove * var_3_1
end

local function var_0_44()
	local var_4_0 = {}
	local var_4_1 = entity.get_player_resource()

	for iter_4_0 = 1, globals.maxplayers() do
		if entity.get_prop(var_4_1, "m_bConnected", iter_4_0) == 1 and iter_4_0 ~= entity.get_local_player() and entity.is_enemy(iter_4_0) then
			var_4_0[#var_4_0 + 1] = iter_4_0
		end
	end

	return var_4_0
end

local function var_0_45()
	local var_5_0 = {}
	local var_5_1 = var_0_8()

	for iter_5_0 = 1, globals.maxplayers() do
		if var_0_10(var_5_1, "m_bConnected", iter_5_0) ~= 1 or var_0_27(iter_5_0, "Add to whitelist") then
			-- block empty
		elseif entity.is_dormant(iter_5_0) and entity.is_enemy(iter_5_0) then
			var_5_0[#var_5_0 + 1] = iter_5_0
		end
	end

	return var_5_0
end

local function var_0_46(arg_6_0, arg_6_1)
	for iter_6_0, iter_6_1 in ipairs(arg_6_0) do
		if iter_6_1[1] == arg_6_1 then
			return true
		end
	end

	return false
end

local var_0_47 = 0
local var_0_48 = {}
local var_0_49 = {}
local var_0_50 = {
	{
		scale = 5,
		hitbox = "Stomach",
		vec = var_0_30(0, 0, 40)
	},
	{
		scale = 6,
		hitbox = "Chest",
		vec = var_0_30(0, 0, 50)
	},
	{
		scale = 3,
		hitbox = "Head",
		vec = var_0_30(0, 0, 58)
	},
	{
		scale = 4,
		hitbox = "Legs",
		vec = var_0_30(0, 0, 20)
	}
}
local var_0_51 = {
	[0] = "Head",
	nil,
	"Stomach",
	nil,
	"Stomach",
	"Chest",
	"Chest",
	"Legs",
	"Legs"
}
local var_0_52 = 1
local var_0_53
local var_0_54
local var_0_55
local var_0_56
local var_0_57
local var_0_58 = false

local function var_0_59(arg_7_0)
	local var_7_0 = var_0_19(var_0_38.dormantHitboxes)
	local var_7_1 = {}

	for iter_7_0, iter_7_1 in ipairs(var_0_44()) do
		local var_7_2, var_7_3, var_7_4, var_7_5, var_7_6 = entity.get_bounding_box(iter_7_1)

		if var_7_6 < 1 then
			if not var_0_46(var_0_49, iter_7_1) then
				table.insert(var_0_49, {
					iter_7_1,
					globals.tickcount()
				})
			end
		elseif var_0_46(var_0_49, iter_7_1) then
			for iter_7_2, iter_7_3 in ipairs(var_0_49) do
				if iter_7_3[1] == iter_7_1 then
					table.remove(var_0_49, iter_7_2)
				end
			end
		end
	end

	if not var_0_19(var_0_36) then
		return
	end

	if not var_0_19(var_0_38.dormantKey) then
		return
	end

	local var_7_7 = var_0_5()
	local var_7_8 = var_0_9(var_7_7)

	if not var_7_8 then
		return
	end

	local var_7_9 = var_0_32(var_7_8)

	if not var_7_9 or not var_0_33(var_7_9) then
		return
	end

	local var_7_10 = var_0_34(var_7_9)

	if not var_7_10 then
		return
	end

	local var_7_11 = var_0_30(var_0_1())
	local var_7_12 = var_0_10(var_7_7, "m_flSimulationTime")
	local var_7_13 = globals.tickcount()
	local var_7_14 = var_0_31(var_7_8)
	local var_7_15 = var_0_10(var_7_7, "m_bIsScoped") == 1
	local var_7_16 = bit.band(var_0_10(var_7_7, "m_fFlags"), bit.lshift(1, 0))
	local var_7_17 = var_0_45()

	if var_7_13 % #var_7_17 ~= 0 then
		var_0_52 = var_0_52 + 1
	else
		var_0_52 = 1
	end

	local var_7_18 = var_7_17[var_0_52]

	if not var_7_18 then
		var_0_48 = {}

		return
	end

	if var_7_13 < var_0_47 then
		var_0_48 = {}

		return
	end

	if var_7_14.type == "grenade" or var_7_14.type == "knife" then
		var_0_48 = {}

		return
	end

	if arg_7_0.in_jump == 1 and var_7_16 == 0 then
		var_0_48 = {}

		return
	end

	local var_7_19 = {}
	local var_7_20 = var_0_19(var_0_38.dormantAccuracy)
	local var_7_21 = entity.get_esp_data(var_7_18).health
	local var_7_22 = var_0_19(var_0_35.override_mindmg[1]) and var_0_19(var_0_35.override_mindmg[2])
	local var_7_23 = var_0_19(var_0_38.dormantMindmg) == 0 and not var_7_22 and var_0_19(var_0_35.mindmg) or var_0_19(var_0_38.dormantMindmg) == 0 and var_7_22 and var_0_19(var_0_35.override_mindmg[3]) or var_0_19(var_0_38.dormantMindmg)

	if var_7_23 > 100 then
		var_7_23 = var_7_23 - 100 + var_7_21
	end

	local var_7_24 = entity.get_prop(var_7_18, "m_flDuckAmount")

	for iter_7_4, iter_7_5 in ipairs(var_0_50) do
		if #var_7_0 ~= 0 then
			if var_0_42(var_7_0, iter_7_5.hitbox) then
				if iter_7_5.hitbox == "Head" then
					table.insert(var_7_19, {
						vec = iter_7_5.vec - var_0_30(0, 0, var_7_24 * 10),
						scale = iter_7_5.scale,
						hitbox = iter_7_5.hitbox
					})
				elseif iter_7_5.hitbox == "Chest" then
					table.insert(var_7_19, {
						vec = iter_7_5.vec - var_0_30(0, 0, var_7_24 * 4),
						scale = iter_7_5.scale,
						hitbox = iter_7_5.hitbox
					})
				else
					table.insert(var_7_19, {
						vec = iter_7_5.vec,
						scale = iter_7_5.scale,
						hitbox = iter_7_5.hitbox
					})
				end
			end
		else
			table.insert(var_7_19, 1, {
				vec = iter_7_5.vec,
				scale = iter_7_5.scale,
				hitbox = iter_7_5.hitbox
			})
		end
	end

	local var_7_25

	if var_7_14.is_revolver then
		var_7_25 = var_7_12 > var_0_10(var_7_8, "m_flNextPrimaryAttack")
	else
		var_7_25 = var_7_12 > var_0_16(var_0_10(var_7_7, "m_flNextAttack"), var_0_10(var_7_8, "m_flNextPrimaryAttack"), var_0_10(var_7_8, "m_flNextSecondaryAttack"))
	end

	if not var_7_25 then
		return
	end

	local var_7_26 = var_0_30(entity.get_origin(var_7_18))
	local var_7_27 = var_0_30(var_0_28(var_7_18, 4))
	local var_7_28, var_7_29, var_7_30, var_7_31, var_7_32 = entity.get_bounding_box(var_7_18)

	var_0_48[var_7_18] = nil

	for iter_7_6 = 1, 7 do
		if #var_7_0 ~= 0 and var_0_42(var_7_0, var_0_51[iter_7_6 - 1]) and var_0_26(var_7_18) and var_7_32 > 0 and math.abs(var_7_26.x - var_7_27.x) < 7 then
			table.insert(var_7_1, {
				scale = 3,
				hitbox = var_0_51[iter_7_6 - 1],
				vec = var_0_30(var_0_28(var_7_18, iter_7_6 - 1))
			})
		end
	end

	if var_7_26.x and var_7_32 > 0 then
		local var_7_33
		local var_7_34
		local var_7_35

		if var_0_19(var_0_38.experimental) then
			for iter_7_7, iter_7_8 in ipairs(var_7_1) do
				local var_7_36 = var_0_41(var_7_11, iter_7_8.vec, 3)
				local var_7_37
				local var_7_38
				local var_7_39
				local var_7_40

				for iter_7_9, iter_7_10 in ipairs(var_7_36) do
					local var_7_41 = iter_7_10.vec
					local var_7_42, var_7_43 = client.trace_bullet(var_7_7, var_7_11.x, var_7_11.y, var_7_11.z, var_7_41.x, var_7_41.y, var_7_41.z, true)

					if iter_7_8.hitbox == "Head" then
						var_7_43 = var_7_43 * 4
					end

					if var_7_43 ~= 0 and var_7_23 < var_7_43 then
						var_7_33 = var_7_41
						var_7_34 = var_7_43
						var_7_35 = iter_7_8.hitbox

						break
					end
				end
			end
		end

		if not (var_7_20 < math.floor(var_7_32 * 100) + 5) then
			return
		end

		local var_7_44
		local var_7_45
		local var_7_46

		if var_7_34 ~= nil then
			var_7_44 = var_7_33
			var_7_45 = var_7_34
			var_0_54 = var_7_35
			var_0_55 = nil
			var_0_56 = var_7_18
			var_0_57 = var_7_32
		else
			for iter_7_11, iter_7_12 in ipairs(var_7_19) do
				local var_7_47 = var_7_26 + iter_7_12.vec
				local var_7_48 = var_0_41(var_7_11, var_7_47, iter_7_12.scale)

				for iter_7_13, iter_7_14 in ipairs(var_7_48) do
					local var_7_49 = iter_7_14.vec
					local var_7_50, var_7_51 = var_0_3(var_7_7, var_7_11.x, var_7_11.y, var_7_11.z, var_7_49.x, var_7_49.y, var_7_49.z, true)

					if var_7_51 ~= 0 and var_7_23 < var_7_51 then
						var_7_44 = var_7_49
						var_7_45 = var_7_51
						var_0_54 = iter_7_12.hitbox
						var_0_55 = iter_7_14.text
						var_0_56 = var_7_18
						var_0_57 = var_7_32

						break
					end
				end

				if var_7_44 and var_7_45 then
					break
				end
			end
		end

		if not var_7_45 then
			return
		end

		if not var_7_44 then
			return
		end

		if var_0_0(var_7_44.x, var_7_44.y, var_7_44.z) then
			return
		end

		var_0_43(arg_7_0, (var_7_15 and var_7_14.max_player_speed_alt or var_7_14.max_player_speed) * 0.33)

		local var_7_52, var_7_53 = var_7_11:to(var_7_44):angles()

		if not var_7_15 and var_7_14.type == "sniperrifle" and arg_7_0.in_jump == 0 and var_7_16 == 1 then
			arg_7_0.in_attack2 = 1
		end

		var_0_48[var_7_18] = true

		if var_7_10 < 0.01 then
			arg_7_0.pitch = var_7_52
			arg_7_0.yaw = var_7_53
			arg_7_0.in_attack = 1
			var_0_53 = true
		end
	end
end

client.register_esp_flag("DA", 255, 255, 255, function(arg_8_0)
	if ui.get(var_0_36) and entity.is_alive(var_0_5()) then
		return var_0_48[arg_8_0]
	end
end)
client.set_event_callback("weapon_fire", function(arg_9_0)
	client.delay_call(0.03, function()
		local var_10_0 = entity.get_local_player()

		if client.userid_to_entindex(arg_9_0.userid) == var_10_0 then
			if var_0_53 and not var_0_58 then
				client.fire_event("dormant_miss", {
					userid = var_0_56,
					aim_hitbox = var_0_54,
					aim_point = var_0_55,
					accuracy = var_0_57
				})
			end

			var_0_58 = false
			var_0_53 = false
			var_0_54 = nil
			var_0_55 = nil
			var_0_56 = nil
			var_0_57 = nil
		end
	end)
end)

local function var_0_60(arg_11_0)
	local var_11_0 = client.userid_to_entindex(arg_11_0.userid)
	local var_11_1 = client.userid_to_entindex(arg_11_0.attacker)
	local var_11_2, var_11_3, var_11_4, var_11_5, var_11_6 = entity.get_bounding_box(client.userid_to_entindex(arg_11_0.userid))

	if var_11_1 == entity.get_local_player() and var_11_0 ~= nil and var_0_53 == true then
		var_0_58 = true

		client.fire_event("dormant_hit", {
			userid = var_11_0,
			attacker = var_11_1,
			health = arg_11_0.health,
			armor = arg_11_0.armor,
			weapon = arg_11_0.weapon,
			dmg_health = arg_11_0.dmg_health,
			dmg_armor = arg_11_0.dmg_armor,
			hitgroup = arg_11_0.hitgroup,
			accuracy = var_11_6,
			aim_hitbox = var_0_54
		})
	end
end

local function var_0_61()
	local var_12_0 = (cvar.mp_freezetime:get_float() + 1) / globals.tickinterval()

	var_0_47 = var_0_15() + var_12_0
end

local function var_0_62()
	local var_13_0 = ui.get(var_0_36)

	for iter_13_0, iter_13_1 in pairs(var_0_38) do
		ui.set_visible(iter_13_1, var_13_0)
	end
end

var_0_23(var_0_36, function()
	local var_14_0 = var_0_19(var_0_36)
	local var_14_1 = var_14_0 and client.set_event_callback or client.unset_event_callback

	if var_14_0 then
		ui.set(var_0_35.dormantEsp, var_14_0)
	end

	var_14_1("setup_command", var_0_59)
	var_14_1("round_prestart", var_0_61)
	var_14_1("player_hurt", var_0_60)
	var_0_62()
end)
var_0_62()

local var_0_63 = 255
local var_0_64 = 0
local var_0_65 = 0
local var_0_66 = 255
local var_0_67 = 255
local var_0_68 = 255
local var_0_69 = 255
local var_0_70 = 10
local var_0_71 = {
	0,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	15,
	16,
	17,
	18
}

client.set_event_callback("paint", function()
	local var_15_0 = ({
		var_0_19(var_0_38.dormantKey)
	})[2]

	if not var_0_26(var_0_5()) then
		return
	end

	if var_0_19(var_0_36) and var_0_19(var_0_38.dormantKey) and var_0_19(var_0_38.dormantIndicator) then
		local var_15_1 = {
			255,
			255,
			255,
			200
		}

		for iter_15_0, iter_15_1 in pairs(var_0_48) do
			if iter_15_1 then
				var_15_1 = {
					143,
					194,
					21,
					255
				}

				break
			end
		end

		if #var_0_45() == 0 then
			var_15_1 = {
				255,
				0,
				50,
				255
			}
		end

		var_0_17(var_15_1[1], var_15_1[2], var_15_1[3], var_15_1[4], "DA")
	end

	if var_0_19(var_0_38.dormantlastseen) then
		for iter_15_2, iter_15_3 in ipairs(var_0_49) do
			local var_15_2 = var_0_30(entity.get_origin(iter_15_3[1]))
			local var_15_3 = var_0_30(var_0_28(iter_15_3[1], 4))
			local var_15_4, var_15_5, var_15_6, var_15_7, var_15_8 = entity.get_bounding_box(iter_15_3[1])
			local var_15_9, var_15_10, var_15_11, var_15_12 = var_0_19(var_0_38.dormantlastseencolor)

			if var_15_8 > 0 and entity.is_dormant(iter_15_3[1]) and math.abs(var_15_2.x - var_15_3.x) < 7 then
				client.draw_hitboxes(iter_15_3[1], 0.06, var_0_71, var_15_9, var_15_10, var_15_11, math.min(var_15_12, var_15_8 / 10 * var_15_12), globals.tickcount())
			end
		end
	end
end)
client.set_event_callback("dormant_hit", function(arg_16_0)
	if var_0_19(var_0_38.dormantLogs) then
		local var_16_0 = entity.get_player_name(arg_16_0.userid)

		if var_0_40[arg_16_0.hitgroup + 1] == arg_16_0.aim_hitbox or var_0_54 == "Head" then
			print(string.format("[DA] Hit %s in the %s for %i damage (%i health remaining) (%s accuracy)", var_16_0, var_0_39[arg_16_0.hitgroup + 1], arg_16_0.dmg_health, arg_16_0.health, string.format("%.0f", arg_16_0.accuracy * 100) .. "%"))
		else
			print(string.format("[DA] Hit %s in the %s for %i damage (%i health remaining) aimed=%s (%s accuracy)", var_16_0, var_0_39[arg_16_0.hitgroup + 1], arg_16_0.dmg_health, arg_16_0.health, arg_16_0.aim_hitbox, string.format("%.0f", arg_16_0.accuracy * 100) .. "%"))
		end
	end
end)
client.set_event_callback("dormant_miss", function(arg_17_0)
	if var_0_19(var_0_38.dormantLogs) then
		local var_17_0 = entity.get_player_name(arg_17_0.userid)

		if var_0_55 ~= nil then
			print(string.format("[DA] Missed %s's %s (mp=%s) (%s accuracy)", var_17_0, var_0_54, var_0_55, string.format("%.0f", arg_17_0.accuracy * 100) .. "%"))
		else
			print(string.format("[DA] Missed %s's %s (%s accuracy)", var_17_0, var_0_54, string.format("%.0f", arg_17_0.accuracy * 100) .. "%"))
		end
	end
end)
