local var_0_0 = require("vector")
local var_0_1 = require("gamesense/entity")
local var_0_2 = require("gamesense/uilib")
local var_0_3 = client.userid_to_entindex
local var_0_4 = client.color_log
local var_0_5 = client.error_log
local var_0_6 = client.eye_position
local var_0_7 = client.set_event_callback
local var_0_8 = globals.tickcount
local var_0_9 = {
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
local var_0_10 = {
	hit = {
		"/c[gamesense]/r Hit /c$target_name/r in the /c$hitgroup_name/r for /c$dmg/r damage (/c$target_hp/r health remaining)",
		"/c[gamesense]/r Hit /c$target_name$wanted_target/r in the /c$hitgroup_name$wanted_hitgroup/r for /c$dmg$wanted_dmg/r damage (/c$target_hp/r health remaining) /c($flags, $hit_chance%, $spread°, $bt_tickt)"
	},
	miss = {
		"/c[gamesense]/r Missed /c$target_name/r's /c$hitgroup_name/r due to /c$reason/r",
		"/c[gamesense]/r Missed /c$target_name/r's /c$hitgroup_name/r due to /c$reason/r /c($flags, $hit_chance%, $spread°, $bt_tickt)"
	},
	dormant = {
		"/c[gamesense/dormant]/r Hit /c$target_name/r's /c$hitgroup_name/r for /c$dmg/r damage (/c$target_hp/r health remaining)",
		"/c[gamesense/dormant]/r Hit /c$target_name/r's /c$hitgroup_name$wanted_hitgroup/r for /c$dmg/r damage (/c$target_hp/r health remaining) /c($hit_chance%)",
		"/c[gamesense/dormant]/r Missed /c$target_name/r's /c$hitgroup_name",
		"/c[gamesense/dormant]/r Missed /c$target_name/r's /c$hitgroup_name /c($hit_chance%, $aim_point)"
	}
}
local var_0_11 = {}
local var_0_12 = {}
local var_0_13 = "rage"
local var_0_14 = "other"
local var_0_15 = {
	enabled = var_0_2.new_checkbox(var_0_13, var_0_14, "Aimbot logs"),
	options = var_0_2.new_multiselect(var_0_13, var_0_14, "\naimbot_logs_opts", {
		"Hit",
		"Miss",
		"Advanced",
		"Dormant hit",
		"Dormant miss"
	}),
	hit_clr = {
		var_0_2.new_label(var_0_13, var_0_14, "Hit color"),
		var_0_2.new_color_picker(var_0_13, var_0_14, "aimbot_logs_hit", 165, 220, 15, 255)
	},
	miss_clr = {
		var_0_2.new_label(var_0_13, var_0_14, "Miss color"),
		var_0_2.new_color_picker(var_0_13, var_0_14, "aimbot_logs_miss", 220, 0, 0, 255)
	}
}
local var_0_16 = var_0_2.reference("misc", "settings", "menu color")
local var_0_17 = (function()
	local function var_1_0(arg_2_0)
		return arg_2_0:gsub("\"", "\\\"")
	end

	local var_1_1 = {}
	local var_1_2

	local function var_1_3(arg_3_0, arg_3_1)
		var_1_1[arg_3_0] = true
		arg_3_1 = arg_3_1 or ""

		local var_3_0 = ""

		for iter_3_0, iter_3_1 in pairs(arg_3_0) do
			var_3_0 = var_3_0 .. arg_3_1

			if type(iter_3_0) == "string" then
				var_3_0 = var_3_0 .. "[\"" .. var_1_0(iter_3_0) .. "\"] = "
			else
				var_3_0 = var_3_0 .. "[" .. tostring(iter_3_0) .. "] = "
			end

			if type(iter_3_1) == "table" then
				var_3_0 = var_3_0 .. "{\n" .. var_1_3(iter_3_1, arg_3_1 .. "\t") .. arg_3_1 .. "}"
			elseif type(iter_3_1) == "string" then
				var_3_0 = var_3_0 .. "\"" .. var_1_0(iter_3_1) .. "\""
			else
				var_3_0 = var_3_0 .. tostring(iter_3_1)
			end

			var_3_0 = var_3_0 .. ",\n"
		end

		return var_3_0
	end

	return function(arg_4_0)
		return "return {\n" .. var_1_3(arg_4_0, "\t") .. "}"
	end
end)()
local var_0_18 = var_0_2.new_string("aim_logs", var_0_17(var_0_10))
local var_0_19 = loadstring(var_0_18())()

local function var_0_20(...)
	for iter_5_0, iter_5_1 in pairs({
		...
	}) do
		local var_5_0 = 255
		local var_5_1 = 255
		local var_5_2 = 255
		local var_5_3 = iter_5_1

		if type(iter_5_1) == "table" then
			var_5_0, var_5_1, var_5_2, var_5_3 = unpack(iter_5_1)
		end

		var_0_4(var_5_0, var_5_1, var_5_2, var_5_3 .. "\x00")
	end

	var_0_4(220, 220, 220, " ")
end

local function var_0_21()
	local var_6_0 = var_0_10

	if loadstring(var_0_18())().dormant == nil then
		var_0_19.dormant = var_6_0.dormant
		var_0_18.value = var_0_17(var_0_19)
		var_6_0 = var_0_19
	end

	return var_6_0
end

var_0_19 = var_0_21()

local var_0_22 = {
	bullet_impact = function(arg_7_0)
		local var_7_0 = var_0_3(arg_7_0.userid)
		local var_7_1 = var_0_1.get_local_player():get_entindex()
		local var_7_2 = var_0_8()

		if var_7_0 == var_7_1 then
			if #var_0_12 > 150 and var_0_12[#var_0_12].tick ~= var_7_2 then
				var_0_12 = {}
			end

			var_0_12[#var_0_12 + 1] = {
				tick = var_7_2,
				origin = var_0_0(var_0_6()),
				shot = var_0_0(arg_7_0.x, arg_7_0.y, arg_7_0.z)
			}
		end
	end,
	aim_fire = function(arg_8_0)
		local var_8_0 = var_0_8()

		arg_8_0.backtrack = var_8_0 - arg_8_0.tick > 0 and var_8_0 - arg_8_0.tick or 0
		arg_8_0.target = var_0_1(arg_8_0.target)
		var_0_11[arg_8_0.id] = {
			spread = 0,
			fired = arg_8_0
		}
	end,
	aim_hit = function(arg_9_0)
		if not var_0_15.options:contains("Hit") then
			return
		end

		local var_9_0 = var_0_11[arg_9_0.id]
		local var_9_1 = var_0_12[#var_0_12]
		local var_9_2 = var_9_0.fired
		local var_9_3 = var_0_8()
		local var_9_4 = var_0_19.hit[var_0_15.options:contains("Advanced") and 2 or 1]
		local var_9_5 = var_0_1(arg_9_0.target)
		local var_9_6 = var_0_9[arg_9_0.hitgroup + 1] or "?"
		local var_9_7 = var_0_9[var_9_2.hitgroup + 1] or "?"
		local var_9_8 = arg_9_0.damage ~= var_9_2.damage and " (" .. var_9_2.damage .. ")" or ""
		local var_9_9 = var_9_2.target:get_player_name()

		var_9_9 = var_9_5:get_player_name() == var_9_9 and "" or " (" .. var_9_9 .. ")"

		local var_9_10

		var_9_10 = var_9_6 ~= var_9_7 and " (" .. var_9_7 .. ")" or ""

		local var_9_11 = table.concat({
			var_9_2.teleported and "T" or "",
			var_9_2.interpolated and "I" or "",
			var_9_2.extrapolated and "E" or "",
			var_9_2.boosted and "B" or "",
			var_9_2.high_priority and "H" or "",
			arg_9_0.refined and "R" or "",
			arg_9_0.expired and "X" or "",
			arg_9_0.noaccept and "N" or ""
		})

		var_9_11 = var_9_11 ~= "" and var_9_11 or "-"

		if var_9_1 and var_9_1.tick == var_9_3 then
			local var_9_12 = (var_9_1.origin - var_0_0(var_9_2.x, var_9_2.y, var_9_2.z)):angles()
			local var_9_13 = (var_9_1.origin - var_9_1.shot):angles()

			var_9_0.spread = var_0_0(var_9_12 - var_9_13):length2d()
		end

		local var_9_14 = {
			target_name = var_9_5:get_player_name(),
			target_hp = var_9_5:get_prop("m_iHealth"),
			wanted_target = var_9_9,
			wanted_hitgroup = var_9_10,
			wanted_dmg = var_9_8,
			hitgroup_name = var_9_6,
			hit_chance = ("%.1f"):format(arg_9_0.hit_chance),
			dmg = arg_9_0.damage,
			spread = ("%.3f"):format(var_9_0.spread),
			bt_tick = var_9_2.backtrack,
			bt_time = totime(var_9_2.backtrack),
			flags = var_9_11
		}
		local var_9_15 = {}
		local var_9_16 = 220
		local var_9_17 = 220
		local var_9_18 = 220

		for iter_9_0 in var_9_4:gmatch("%S+") do
			if iter_9_0:match("/c") then
				var_9_16, var_9_17, var_9_18 = var_0_15.hit_clr[2]()
			end

			if iter_9_0:match("/a") then
				var_9_16, var_9_17, var_9_18 = var_0_16()
			end

			for iter_9_1, iter_9_2 in pairs(var_9_14) do
				iter_9_1 = "$" .. iter_9_1
				iter_9_0 = iter_9_0:gsub(iter_9_1, iter_9_2)

				if iter_9_0 == iter_9_2 then
					break
				end
			end

			var_9_15[#var_9_15 + 1] = {
				var_9_16,
				var_9_17,
				var_9_18,
				iter_9_0:gsub("/r", ""):gsub("/c", ""):gsub("/a", "") .. " "
			}

			if iter_9_0:match("/r") then
				var_9_16, var_9_17, var_9_18 = 220, 220, 220
			end
		end

		var_0_20(unpack(var_9_15))
	end,
	aim_miss = function(arg_10_0)
		if not var_0_15.options:contains("Miss") then
			return
		end

		local var_10_0 = var_0_11[arg_10_0.id]
		local var_10_1 = var_0_12[#var_0_12]
		local var_10_2 = var_10_0.fired
		local var_10_3 = var_0_8()
		local var_10_4 = var_0_19.miss[var_0_15.options:contains("Advanced") and 2 or 1]
		local var_10_5 = var_0_1(arg_10_0.target)
		local var_10_6 = var_0_9[arg_10_0.hitgroup + 1] or "?"
		local var_10_7 = var_0_9[var_10_2.hitgroup + 1] or "?"
		local var_10_8 = var_10_2.target:get_player_name()

		var_10_8 = var_10_5:get_player_name() == var_10_8 and "" or " (" .. var_10_8 .. ")"

		local var_10_9

		var_10_9 = var_10_6 ~= var_10_7 and " (" .. var_10_7 .. ")" or ""

		local var_10_10 = table.concat({
			var_10_2.teleported and "T" or "",
			var_10_2.interpolated and "I" or "",
			var_10_2.extrapolated and "E" or "",
			var_10_2.boosted and "B" or "",
			var_10_2.high_priority and "H" or "",
			arg_10_0.refined and "R" or "",
			arg_10_0.expired and "X" or "",
			arg_10_0.noaccept and "N" or ""
		})

		var_10_10 = var_10_10 ~= "" and var_10_10 or "-"

		if var_10_1 and var_10_1.tick == var_10_3 then
			local var_10_11 = (var_10_1.origin - var_0_0(var_10_2.x, var_10_2.y, var_10_2.z)):angles()
			local var_10_12 = (var_10_1.origin - var_10_1.shot):angles()

			var_10_0.spread = var_0_0(var_10_11 - var_10_12):length2d()
		end

		local var_10_13 = {
			target_name = var_10_5:get_player_name(),
			target_hp = var_10_5:get_prop("m_iHealth"),
			wanted_target = var_10_8,
			wanted_hitgroup = var_10_9,
			wanted_dmg = var_10_2.damage,
			hitgroup_name = var_10_6,
			hit_chance = ("%.1f"):format(arg_10_0.hit_chance),
			reason = arg_10_0.reason,
			spread = ("%.3f"):format(var_10_0.spread),
			bt_tick = var_10_2.backtrack,
			bt_time = totime(var_10_2.backtrack),
			flags = var_10_10
		}
		local var_10_14 = {}
		local var_10_15 = 220
		local var_10_16 = 220
		local var_10_17 = 220

		for iter_10_0 in var_10_4:gmatch("%S+") do
			if iter_10_0:match("/c") then
				var_10_15, var_10_16, var_10_17 = var_0_15.miss_clr[2]()
			end

			if iter_10_0:match("/a") then
				var_10_15, var_10_16, var_10_17 = var_0_16()
			end

			for iter_10_1, iter_10_2 in pairs(var_10_13) do
				iter_10_1 = "$" .. iter_10_1
				iter_10_0 = iter_10_0:gsub(iter_10_1, iter_10_2)

				if iter_10_0 == iter_10_2 then
					break
				end
			end

			var_10_14[#var_10_14 + 1] = {
				var_10_15,
				var_10_16,
				var_10_17,
				iter_10_0:gsub("/r", ""):gsub("/c", ""):gsub("/a", "") .. " "
			}

			if iter_10_0:match("/r") then
				var_10_15, var_10_16, var_10_17 = 220, 220, 220
			end
		end

		var_0_20(unpack(var_10_14))
	end,
	dormant_hit = function(arg_11_0)
		if not var_0_15.options:contains("Dormant hit") then
			return
		end

		local var_11_0 = var_0_19.dormant[var_0_15.options:contains("Advanced") and 2 or 1]
		local var_11_1 = var_0_1(arg_11_0.userid)
		local var_11_2 = var_0_9[arg_11_0.hitgroup + 1] or "?"
		local var_11_3 = arg_11_0.aim_hitbox:lower()
		local var_11_4

		var_11_4 = var_11_2 ~= var_11_3 and " (" .. var_11_3 .. ")" or ""

		local var_11_5 = {
			target_name = var_11_1:get_player_name(),
			target_hp = arg_11_0.health,
			wanted_hitgroup = var_11_4,
			hitgroup_name = var_11_2,
			dmg = arg_11_0.dmg_health,
			hit_chance = ("%.1f"):format(arg_11_0.accuracy * 100)
		}
		local var_11_6 = {}
		local var_11_7 = 220
		local var_11_8 = 220
		local var_11_9 = 220

		for iter_11_0 in var_11_0:gmatch("%S+") do
			if iter_11_0:match("/c") then
				var_11_7, var_11_8, var_11_9 = var_0_15.hit_clr[2]()
			end

			if iter_11_0:match("/a") then
				var_11_7, var_11_8, var_11_9 = var_0_16()
			end

			for iter_11_1, iter_11_2 in pairs(var_11_5) do
				iter_11_1 = "$" .. iter_11_1
				iter_11_0 = iter_11_0:gsub(iter_11_1, iter_11_2)

				if iter_11_0 == iter_11_2 then
					break
				end
			end

			var_11_6[#var_11_6 + 1] = {
				var_11_7,
				var_11_8,
				var_11_9,
				iter_11_0:gsub("/r", ""):gsub("/c", ""):gsub("/a", "") .. " "
			}

			if iter_11_0:match("/r") then
				var_11_7, var_11_8, var_11_9 = 220, 220, 220
			end
		end

		var_0_20(unpack(var_11_6))
	end,
	dormant_miss = function(arg_12_0)
		if not var_0_15.options:contains("Dormant miss") then
			return
		end

		local var_12_0 = var_0_19.dormant[var_0_15.options:contains("Advanced") and 4 or 3]
		local var_12_1 = var_0_1(arg_12_0.userid)
		local var_12_2 = {
			target_name = var_12_1:get_player_name(),
			target_hp = arg_12_0.health,
			hitgroup_name = arg_12_0.aim_hitbox:lower(),
			aim_point = arg_12_0.aim_point:lower(),
			hit_chance = ("%.1f"):format(arg_12_0.accuracy * 100)
		}
		local var_12_3 = {}
		local var_12_4 = 220
		local var_12_5 = 220
		local var_12_6 = 220

		for iter_12_0 in var_12_0:gmatch("%S+") do
			if iter_12_0:match("/c") then
				var_12_4, var_12_5, var_12_6 = var_0_15.miss_clr[2]()
			end

			if iter_12_0:match("/a") then
				var_12_4, var_12_5, var_12_6 = var_0_16()
			end

			for iter_12_1, iter_12_2 in pairs(var_12_2) do
				iter_12_1 = "$" .. iter_12_1
				iter_12_0 = iter_12_0:gsub(iter_12_1, iter_12_2)

				if iter_12_0 == iter_12_2 then
					break
				end
			end

			var_12_3[#var_12_3 + 1] = {
				var_12_4,
				var_12_5,
				var_12_6,
				iter_12_0:gsub("/r", ""):gsub("/c", ""):gsub("/a", "") .. " "
			}

			if iter_12_0:match("/r") then
				var_12_4, var_12_5, var_12_6 = 220, 220, 220
			end
		end

		var_0_20(unpack(var_12_3))
	end,
	round_start = function()
		var_0_11, var_0_12 = {}, {}
	end,
	post_config_load = function()
		var_0_19 = var_0_21()
	end
}

var_0_7("console_input", function(arg_15_0)
	if arg_15_0:sub(0, 12) == "aim_logs.set" then
		arg_15_0 = arg_15_0:sub(14)

		local var_15_0 = {
			hit = function(arg_16_0)
				var_0_19.hit[1] = arg_16_0

				return true
			end,
			hit_adv = function(arg_17_0)
				var_0_19.hit[2] = arg_17_0

				return true
			end,
			miss = function(arg_18_0)
				var_0_19.miss[1] = arg_18_0

				return true
			end,
			miss_adv = function(arg_19_0)
				var_0_19.miss[2] = arg_19_0

				return true
			end,
			dorm_hit = function(arg_20_0)
				var_0_19.dormant[1] = arg_20_0

				return true
			end,
			dorm_hit_adv = function(arg_21_0)
				var_0_19.dormant[2] = arg_21_0

				return true
			end,
			dorm_miss = function(arg_22_0)
				var_0_19.dormant[3] = arg_22_0

				return true
			end,
			dorm_miss_adv = function(arg_23_0)
				var_0_19.dormant[4] = arg_23_0

				return true
			end
		}
		local var_15_1 = {}

		for iter_15_0 in arg_15_0:gmatch("%S+") do
			var_15_1[#var_15_1 + 1] = iter_15_0
		end

		if var_15_1[1] == nil then
			return false
		end

		local var_15_2 = {
			arg_15_0:find(var_15_1[1])
		}
		local var_15_3 = arg_15_0:sub(var_15_2[2] + 1)
		local var_15_4 = var_15_0[var_15_1[1]] and var_15_0[var_15_1[1]](var_15_3) or nil

		if var_15_3:match("$default") then
			local var_15_5 = var_15_1[1] == "hit" and var_0_10.hit[1] or var_15_1[1] == "hit_adv" and var_0_10.hit[2] or var_15_1[1] == "miss" and var_0_10.miss[1] or var_15_1[1] == "miss_adv" and var_0_10.miss[2] or var_15_1[1] == "dorm_hit" and var_0_10.dormant[1] or var_15_1[1] == "dorm_hit_adv" and var_0_10.dormant[2] or var_15_1[1] == "dorm_miss" and var_0_10.dormant[3] or var_15_1[1] == "dorm_miss_adv" and var_0_10.dormant[4]

			var_15_4 = var_15_0[var_15_1[1]] and var_15_0[var_15_1[1]](var_15_5) or nil
		end

		if var_15_4 ~= nil then
			var_0_20({
				165,
				220,
				15,
				"[aim_logs]"
			}, " Successfully set ", var_15_1[1], " logs")

			var_0_18.value = var_0_17(var_0_19)

			return true
		else
			var_0_5("Invalid log type")

			return true
		end
	elseif arg_15_0:sub(0, 13) == "aim_logs.tags" then
		local var_15_6 = {
			"target_name",
			"target_hp",
			"wanted_hitgroup",
			"wanted_dmg",
			"wanted_target",
			"dmg",
			"hitgroup_name",
			"hit_chance",
			"reason",
			"spread",
			"bt_tick",
			"bt_time",
			"flags"
		}

		for iter_15_1, iter_15_2 in ipairs(var_15_6) do
			var_0_20({
				165,
				220,
				15,
				iter_15_2
			})
		end
	end
end)

local function var_0_23()
	local var_24_0 = var_0_15.enabled()

	var_0_15.options.vis = var_24_0
	var_0_15.hit_clr[1].vis, var_0_15.hit_clr[2].vis = var_24_0 and var_0_15.options:contains("Hit"), var_24_0 and var_0_15.options:contains("Hit")
	var_0_15.miss_clr[1].vis, var_0_15.miss_clr[2].vis = var_24_0 and var_0_15.options:contains("Miss"), var_24_0 and var_0_15.options:contains("Miss")
end

var_0_15.enabled:add_callback(var_0_23)

for iter_0_0, iter_0_1 in pairs(var_0_22) do
	var_0_15.enabled:add_event_callback(iter_0_0, iter_0_1)
end

var_0_15.enabled:invoke()
var_0_15.options:add_callback(var_0_23)
