-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("gamesense/http")
local var_0_1 = require("gamesense/md5")

local function var_0_2(arg_1_0)
	return string.format("%02x%02x%02x%02x", arg_1_0[1], arg_1_0[2], arg_1_0[3], arg_1_0[4] == nil and 255 or arg_1_0[4])
end

local var_0_3 = database.read("iconlib_cache") or {}

client.set_event_callback("shutdown", function()
	database.write("iconlib_cache", var_0_3)
end)

local function var_0_4(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if arg_3_1 ~= "solid" and arg_3_1 ~= "outline" then
		error("icon type must be 'solid' or 'outline'", 2)
	end

	if #arg_3_2 < 3 or #arg_3_2 > 4 then
		error("color must be a table of RGB/RGBA values", 2)
	end

	local var_3_0 = var_0_1.sumhexa(arg_3_0 .. arg_3_1)

	if var_0_3[var_3_0] then
		arg_3_3(var_0_3[var_3_0]:gsub("#0F172A", "#" .. (arg_3_2 and var_0_2(arg_3_2) or "fff")))

		return true
	end

	var_0_0.get(("https://raw.githubusercontent.com/tailwindlabs/heroicons/master/src/24/%s/%s.svg"):format(arg_3_1, arg_3_0), function(arg_4_0, arg_4_1)
		if not arg_4_0 or arg_4_1.status ~= 200 then
			arg_3_3(false)

			return
		end

		var_0_3[var_3_0] = arg_4_1.body

		arg_3_3(arg_4_1.body:gsub("#0F172A", "#" .. (arg_3_2 and var_0_2(arg_3_2) or "fff")))
	end)

	return false
end

local var_0_5 = {}

local function var_0_6(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_1 ~= "solid" and arg_5_1 ~= "outline" then
		error("icon type must be 'solid' or 'outline'", 2)
	end

	if #arg_5_2 < 3 or #arg_5_2 > 4 then
		error("color must be a table of RGB/RGBA values", 2)
	end

	local var_5_0 = arg_5_2 and var_0_2(arg_5_2) or "fff"
	local var_5_1 = arg_5_0 .. arg_5_1 .. var_5_0 .. arg_5_3

	if var_0_5[var_5_1] then
		arg_5_4(var_0_5[var_5_1])

		return true
	end

	var_0_4(arg_5_0, arg_5_1, arg_5_2, function(arg_6_0)
		if not arg_6_0 then
			arg_5_4(false)

			return
		end

		local var_6_0 = renderer.load_svg(arg_6_0, arg_5_3, arg_5_3)

		if not var_6_0 then
			return false
		end

		var_0_5[var_5_1] = var_6_0

		arg_5_4(var_6_0)
	end)

	return false
end

return {
	hero = {
		get_icon = var_0_4,
		get_texture = var_0_6
	}
}
