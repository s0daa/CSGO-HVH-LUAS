local var_0_0 = client.register_esp_flag
local var_0_1 = client.set_event_callback
local var_0_2 = entity.get_players
local var_0_3 = entity.get_prop
local var_0_4 = plist.get
local var_0_5 = plist.set
local var_0_6 = ui.get
local var_0_7 = ui.new_checkbox
local var_0_8 = ui.new_multiselect
local var_0_9 = ui.new_slider
local var_0_10 = ui.set_callback
local var_0_11 = ui.set_visible
local var_0_12 = require("bit")
local var_0_13 = var_0_7("RAGE", "Other", "Force safe point conditions")
local var_0_14 = var_0_8("RAGE", "Other", "\nbox", "Duck", "X > HP", "In air")
local var_0_15 = var_0_9("RAGE", "Other", "X > HP", 1, 100, 70, true, "HP", 1)

local function var_0_16(arg_1_0, arg_1_1)
	for iter_1_0 = 1, #arg_1_0 do
		if arg_1_0[iter_1_0] == arg_1_1 then
			return true
		end
	end

	return false
end

local function var_0_17(arg_2_0)
	local var_2_0 = var_0_6(arg_2_0)
	local var_2_1 = var_0_16(var_2_0, "X > HP")

	var_0_11(var_0_15, var_2_1)
end

local function var_0_18(arg_3_0)
	local var_3_0 = var_0_6(arg_3_0)

	var_0_11(var_0_14, var_3_0)
	var_0_11(var_0_15, var_3_0)
	var_0_17(var_0_14)
end

var_0_1("paint", function()
	if not var_0_6(var_0_13) then
		return
	end

	local var_4_0 = var_0_6(var_0_14)

	if #var_4_0 == 0 then
		return
	end

	local var_4_1 = var_0_16(var_4_0, "Duck")
	local var_4_2 = var_0_16(var_4_0, "X > HP")
	local var_4_3 = var_0_16(var_4_0, "In air")
	local var_4_4 = var_0_2(true)

	for iter_4_0 = 1, #var_4_4 do
		local var_4_5 = var_4_4[iter_4_0]
		local var_4_6 = var_0_3(var_4_5, "m_flDuckAmount") >= 0.7
		local var_4_7 = var_0_3(var_4_5, "m_iHealth") <= var_0_6(var_0_15)
		local var_4_8 = var_0_12.band(var_0_3(var_4_5, "m_fFlags"), 1) == 0

		if var_4_1 and var_4_6 or var_4_2 and var_4_7 or var_4_3 and var_4_8 then
			var_0_5(var_4_5, "Override safe point", "On")
		else
			var_0_5(var_4_5, "Override safe point", "-")
		end
	end
end)
var_0_0("SP", 204, 204, 0, function(arg_5_0)
	return var_0_6(var_0_13) and var_0_4(arg_5_0, "Override safe point") == "On"
end)
var_0_18(var_0_13)
var_0_10(var_0_13, var_0_18)
var_0_17(var_0_14)
var_0_10(var_0_14, var_0_17)
