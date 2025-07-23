-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = {
	[ui.new_button] = "button",
	[ui.new_checkbox] = "checkbox",
	[ui.new_color_picker] = "color_picker",
	[ui.new_combobox] = "combobox",
	[ui.new_hotkey] = "hotkey",
	[ui.new_label] = "label",
	[ui.new_listbox] = "listbox",
	[ui.new_multiselect] = "multiselect",
	[ui.new_slider] = "slider",
	[ui.new_string] = "string",
	[ui.new_textbox] = "textbox"
}
local var_0_1 = {
	[0] = "Always on",
	"On hotkey",
	"Toggle",
	"Off hotkey"
}
local var_0_2 = {}
local var_0_3 = {}
local var_0_4 = {}

local function var_0_5(...)
	client.color_log(224, 54, 54, "[UILIB] \x00")

	local var_1_0 = {
		...
	}

	for iter_1_0 = 1, #var_1_0 - 1 do
		client.color_log(232, 181, 181, var_1_0[iter_1_0], " \x00")
	end

	client.color_log(232, 181, 181, var_1_0[#var_1_0])

	return nil
end

local function var_0_6(...)
	client.color_log(224, 54, 54, "[UILIB] \x00")

	local var_2_0 = {
		...
	}

	for iter_2_0 = 1, #var_2_0 - 1 do
		client.color_log(232, 181, 181, tostring(var_2_0[iter_2_0]), " \x00")
	end

	client.color_log(232, 181, 181, tostring(var_2_0[#var_2_0]))
end

local function var_0_7(arg_3_0, arg_3_1)
	local var_3_0 = var_0_4[arg_3_0]

	if var_0_2[arg_3_0].events then
		if arg_3_1 then
			for iter_3_0, iter_3_1 in pairs(var_0_2[arg_3_0].events) do
				for iter_3_2, iter_3_3 in ipairs(iter_3_1) do
					client.unset_event_callback(iter_3_0, iter_3_3[1])
				end
			end
		else
			for iter_3_4, iter_3_5 in pairs(var_0_2[arg_3_0].events) do
				for iter_3_6, iter_3_7 in ipairs(iter_3_5) do
					client.unset_event_callback(iter_3_4, iter_3_7[1])

					if iter_3_7[2](var_3_0) then
						client.set_event_callback(iter_3_4, iter_3_7[1])
					end
				end
			end
		end
	end
end

local function var_0_8(arg_4_0)
	local var_4_0 = var_0_4[arg_4_0]

	if var_0_2[arg_4_0].change then
		for iter_4_0, iter_4_1 in ipairs(var_0_2[arg_4_0].change) do
			iter_4_1(var_4_0)
		end
	end
end

local function var_0_9(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.state

	if arg_5_1 ~= nil then
		var_5_0 = var_5_0 and arg_5_1
	end

	for iter_5_0, iter_5_1 in ipairs(arg_5_0.children) do
		iter_5_1.visible = var_5_0

		if var_0_2[iter_5_1.reference] then
			var_0_7(iter_5_1.reference, true)
		end

		if iter_5_1.children and #iter_5_1.children > 0 then
			var_0_9(iter_5_1, var_5_0)
		end
	end
end

local function var_0_10(arg_6_0)
	if var_0_2[arg_6_0].childs then
		local var_6_0 = var_0_4[arg_6_0]

		var_0_9(var_6_0)
	end
end

local function var_0_11(arg_7_0)
	if var_0_2[arg_7_0] then
		local var_7_0 = var_0_4[arg_7_0]

		if var_7_0 and var_7_0.parent ~= nil and not var_7_0.parent.state then
			return
		end

		var_0_10(arg_7_0)
		var_0_8(arg_7_0)
		var_0_7(arg_7_0)
	end
end

local var_0_12 = {
	create_ref = function(arg_8_0, arg_8_1)
		var_0_2[arg_8_1] = {
			events = {},
			change = {},
			childs = {}
		}

		ui.set_callback(arg_8_1, var_0_11)
	end,
	add_event = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		if not var_0_2[arg_9_1] then
			arg_9_0:create_ref(arg_9_1)
		end

		if var_0_2[arg_9_1].events[arg_9_2] == nil then
			var_0_2[arg_9_1].events[arg_9_2] = {}
		end

		table.insert(var_0_2[arg_9_1].events[arg_9_2], {
			arg_9_3,
			arg_9_4
		})
	end,
	add_change = function(arg_10_0, arg_10_1, arg_10_2)
		if not var_0_2[arg_10_1] then
			arg_10_0:create_ref(arg_10_1)
		end

		table.insert(var_0_2[arg_10_1].change, arg_10_2)
	end,
	add_child = function(arg_11_0, arg_11_1, arg_11_2)
		if not var_0_2[arg_11_1] then
			arg_11_0:create_ref(arg_11_1)
		end

		table.insert(var_0_2[arg_11_1].childs, arg_11_2)
	end,
	remove_event = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		if var_0_2[arg_12_1] then
			for iter_12_0, iter_12_1 in pairs(var_0_2[arg_12_1].events) do
				if iter_12_0 == arg_12_3 then
					for iter_12_2, iter_12_3 in ipairs(iter_12_1) do
						if iter_12_3[1] == arg_12_2 then
							client.unset_event_callback(iter_12_0, iter_12_3[1])
							table.remove(var_0_2[arg_12_1].events[iter_12_0], iter_12_2)

							return true
						end
					end
				end
			end
		end

		return false
	end,
	remove_change = function(arg_13_0, arg_13_1, arg_13_2)
		if var_0_2[arg_13_1] then
			for iter_13_0, iter_13_1 in ipairs(var_0_2[arg_13_1].change) do
				if iter_13_1 == arg_13_2 then
					table.remove(var_0_2[arg_13_1].change, iter_13_0)

					return true
				end
			end
		end

		return false
	end,
	update_events = function(arg_14_0, arg_14_1)
		var_0_7(arg_14_1)
	end,
	update_callbacks = function(arg_15_0, arg_15_1)
		var_0_8(arg_15_1)
	end
}
local var_0_13 = {}
local var_0_14 = ui.reference("PLAYERS", "Players", "Player list")
local var_0_15 = ui.reference("PLAYERS", "Players", "Reset all")
local var_0_16 = ui.reference("PLAYERS", "Adjustments", "Apply to all")

local function var_0_17(arg_16_0)
	return arg_16_0 and arg_16_0 > 0 and arg_16_0 < 64
end

local var_0_18 = false

local function var_0_19()
	if ui.get(var_0_14) == nil then
		return
	end

	for iter_17_0, iter_17_1 in ipairs(var_0_13) do
		iter_17_1:invoke_change()
	end
end

ui.set_callback(var_0_14, var_0_19)

local function var_0_20(arg_18_0)
	if var_0_18 or ui.get(var_0_14) == nil then
		return
	end

	for iter_18_0, iter_18_1 in ipairs(var_0_13) do
		local var_18_0 = iter_18_1.ref_to_element[arg_18_0]

		if var_18_0 ~= nil then
			local var_18_1 = ui.get(var_0_14)
			local var_18_2 = {
				ui.get(arg_18_0)
			}

			if #var_18_2 == 1 and var_18_2[1] ~= nil then
				iter_18_1.states[var_18_1][var_18_0] = var_18_2[1]
			else
				iter_18_1.states[var_18_1][var_18_0] = var_18_2
			end

			iter_18_1.elements[var_18_0][2](var_18_0, var_18_1)
		end
	end
end

local function var_0_21()
	for iter_19_0, iter_19_1 in ipairs(var_0_13) do
		local var_19_0 = iter_19_1.states[0]

		for iter_19_2 = 0, 64 do
			iter_19_1.states[iter_19_2] = {
				table.unpack(var_19_0)
			}
		end

		iter_19_1:invoke_change()
	end
end

ui.set_callback(var_0_15, var_0_21)

local function var_0_22()
	for iter_20_0, iter_20_1 in ipairs(var_0_13) do
		local var_20_0 = iter_20_1:get_entidx_states()

		for iter_20_2 = 1, 64 do
			iter_20_1.states[iter_20_2] = {
				table.unpack(var_20_0)
			}
		end
	end
end

ui.set_callback(var_0_16, var_0_22)

local function var_0_23()
	local var_21_0 = entity.get_player_resource()

	for iter_21_0, iter_21_1 in ipairs(var_0_13) do
		for iter_21_2 = 1, 64 do
			if entity.get_prop(var_21_0, "m_bConnected", iter_21_2) ~= 1 then
				iter_21_1.states[iter_21_2] = {
					table.unpack(iter_21_1.states[0])
				}
			end
		end
	end
end

client.set_event_callback("player_spawn", var_0_23)
client.set_event_callback("player_team", var_0_23)
client.set_event_callback("player_disconnect", var_0_23)
client.set_event_callback("player_connect_full", var_0_23)

local function var_0_24()
	var_0_18 = true

	for iter_22_0, iter_22_1 in ipairs(var_0_13) do
		for iter_22_2, iter_22_3 in ipairs(iter_22_1.elements) do
			ui.set(iter_22_3[1], iter_22_1.states[0][iter_22_2])
		end
	end

	var_0_18 = false
end

client.set_event_callback("shutdown", var_0_24)

local function var_0_25(arg_23_0)
	if var_0_0[arg_23_0] == "multiselect" or var_0_0[arg_23_0] == "color_picker" then
		return var_0_0[arg_23_0]
	end

	return false
end

local var_0_26 = {
	__metatable = "uilib_plist_handler",
	__index = function()
		return
	end,
	__newindex = function()
		return
	end
}

local function var_0_27(arg_26_0, arg_26_1, arg_26_2, ...)
	if not arg_26_1 or type(arg_26_1) ~= "function" or var_0_0[arg_26_1] == nil or var_0_0[arg_26_1] == "hotkey" then
		return var_0_5("invalid argument #1 to 'plist:add', takes ui.new_* function (excluding ui.new_hotkey)")
	end

	if not arg_26_2 or type(arg_26_2) ~= "string" then
		return var_0_5("invalid argument #2 to 'plist:add', pass the name of the element")
	end

	local var_26_0, var_26_1 = pcall(arg_26_1, "PLAYERS", "Adjustments", arg_26_2, ...)

	if not var_26_0 or not var_26_1 then
		return var_0_5("invalid arguments passed to function in 'plist:add'")
	end

	arg_26_0.elements[#arg_26_0.elements + 1] = {
		var_26_1,
		function()
			return
		end
	}

	local var_26_2 = #arg_26_0.elements

	arg_26_0.special[var_26_2] = var_0_25(arg_26_1)
	arg_26_0.ref_to_element[var_26_1] = var_26_2

	local var_26_3 = {
		ui.get(var_26_1)
	}

	if #var_26_3 == 1 and var_26_3[1] ~= nil then
		local var_26_4 = var_26_3[1]

		for iter_26_0 = 0, 64 do
			arg_26_0.states[iter_26_0][var_26_2] = var_26_4
		end
	else
		for iter_26_1 = 0, 64 do
			arg_26_0.states[iter_26_1][var_26_2] = {
				table.unpack(var_26_3)
			}
		end
	end

	ui.set_callback(var_26_1, var_0_20)

	return var_26_2
end

local function var_0_28(arg_28_0)
	var_0_18 = true

	local var_28_0 = arg_28_0.states[ui.get(var_0_14)]

	for iter_28_0, iter_28_1 in ipairs(var_28_0) do
		if arg_28_0.special[iter_28_0] == "color_picker" then
			ui.set(arg_28_0.elements[iter_28_0][1], table.unpack(iter_28_1))
		else
			ui.set(arg_28_0.elements[iter_28_0][1], iter_28_1)
		end
	end

	var_0_18 = false
end

local function var_0_29(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_2 then
		return ui.get(arg_29_0.elements[arg_29_1][1])
	elseif var_0_17(arg_29_2) then
		local var_29_0 = arg_29_0.states[arg_29_2][arg_29_1]

		if arg_29_0.special[arg_29_1] == "color_picker" then
			return table.unpack(var_29_0)
		else
			return var_29_0
		end
	else
		return var_0_5("invalid entidx")
	end
end

local function var_0_30(arg_30_0, arg_30_1, arg_30_2, ...)
	local var_30_0 = {
		...
	}

	if #var_30_0 == 1 then
		var_30_0 = var_30_0[1]
	end

	if not arg_30_2 then
		ui.set(arg_30_0.elements[arg_30_1][1], var_30_0)
	elseif var_0_17(arg_30_2) then
		arg_30_0.states[arg_30_2][arg_30_1] = var_30_0
	else
		return var_0_5("invalid entidx")
	end
end

local function var_0_31(arg_31_0, arg_31_1, arg_31_2)
	ui.set_visible(arg_31_0.elements[arg_31_1][1], arg_31_2)
end

local function var_0_32(arg_32_0, arg_32_1)
	if not arg_32_1 then
		return arg_32_0.states[ui.get(var_0_14)]
	elseif var_0_17(arg_32_1) then
		return arg_32_0.states[arg_32_1]
	end
end

local function var_0_33(arg_33_0, arg_33_1, ...)
	if var_0_17(arg_33_1) then
		local var_33_0 = {
			...
		}

		if #var_33_0 > 0 and #var_33_0 <= #arg_33_0.elements then
			for iter_33_0, iter_33_1 in ipairs(var_33_0) do
				if iter_33_1 ~= nil then
					arg_33_0.states[arg_33_1][iter_33_0] = iter_33_1
				end
			end
		else
			var_0_5("invalid parameters")
		end
	else
		var_0_5("invalid entidx")
	end
end

local function var_0_34(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0.elements[arg_34_1][2] = arg_34_2
end

local function var_0_35()
	local var_35_0 = {}

	for iter_35_0 = 0, 64 do
		var_35_0[iter_35_0] = {}
	end

	return var_35_0
end

local function var_0_36()
	local var_36_0 = {
		elements = {},
		special = {},
		ref_to_element = {},
		states = var_0_35(),
		vis_states = var_0_35(),
		add = var_0_27,
		invoke_change = var_0_28,
		get_state = var_0_29,
		set_state = var_0_30,
		set_visible = var_0_31,
		get_entidx_states = var_0_32,
		set_entidx_states = var_0_33,
		set_callback = var_0_34
	}

	var_0_13[#var_0_13 + 1] = setmetatable(var_36_0, var_0_26)

	return var_0_13[#var_0_13]
end

local function var_0_37(arg_37_0, arg_37_1)
	if arg_37_1 == "value" or arg_37_1 == "state" then
		return ui.get(arg_37_0.reference)
	elseif arg_37_1 == "visible" or arg_37_1 == "vis" then
		return arg_37_0.is_visible
	else
		return nil
	end
end

local function var_0_38(arg_38_0, arg_38_1, ...)
	local var_38_0 = {
		...
	}

	if #var_38_0 == 1 then
		var_38_0 = var_38_0[1]
	end

	if arg_38_1 == "value" or arg_38_1 == "state" then
		if string.find(arg_38_0.ref_type, "color_picker") then
			ui.set(arg_38_0.reference, ...)
		else
			ui.set(arg_38_0.reference, var_38_0)
		end
	elseif (arg_38_1 == "visible" or arg_38_1 == "vis") and type(var_38_0) == "boolean" then
		ui.set_visible(arg_38_0.reference, var_38_0)

		arg_38_0.is_visible = var_38_0
	end
end

local function var_0_39(arg_39_0, ...)
	local var_39_0 = {
		...
	}

	if #var_39_0 > 0 then
		local var_39_1 = var_0_37(arg_39_0, "value")

		if #var_39_0 == 1 then
			var_0_38(arg_39_0, "value", var_39_0[1])
		else
			var_0_38(arg_39_0, "value", ...)
		end

		return var_39_1
	else
		return var_0_37(arg_39_0, "value")
	end
end

local function var_0_40(arg_40_0, arg_40_1)
	return var_0_37(arg_40_0, arg_40_1)
end

local function var_0_41(arg_41_0, arg_41_1, arg_41_2)
	return var_0_38(arg_41_0, arg_41_1, arg_41_2)
end

local function var_0_42()
	return
end

local function var_0_43(arg_43_0)
	return arg_43_0()
end

local function var_0_44(arg_44_0)
	local var_44_0 = arg_44_0.value

	return var_44_0 and #var_44_0 > 0
end

local function var_0_45(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	if arg_45_1 and type(arg_45_1) == "string" then
		arg_45_1 = {
			arg_45_1
		}
	end

	if not arg_45_1 or type(arg_45_1) ~= "table" then
		return var_0_5("invalid event. must be a string or table of strings")
	end

	if not arg_45_2 or type(arg_45_2) ~= "function" then
		return var_0_5("invalid callback function. must be a function")
	end

	if arg_45_3 and type(arg_45_3) == "function" then
		local var_45_0, var_45_1 = pcall(arg_45_3, arg_45_0)

		if not var_45_0 or type(var_45_1) ~= "boolean" then
			return var_0_5("invalid argument #3. function must take uilib object as the first argument and return a boolean")
		end

		for iter_45_0, iter_45_1 in ipairs(arg_45_1) do
			var_0_12:add_event(arg_45_0.reference, iter_45_1, arg_45_2, arg_45_3)
		end
	elseif string.find(arg_45_0.ref_type, "checkbox") then
		for iter_45_2, iter_45_3 in ipairs(arg_45_1) do
			var_0_12:add_event(arg_45_0.reference, iter_45_3, arg_45_2, var_0_43)
		end
	elseif string.find(arg_45_0.ref_type, "multiselect") then
		for iter_45_4, iter_45_5 in ipairs(arg_45_1) do
			var_0_12:add_event(arg_45_0.reference, iter_45_5, arg_45_2, var_0_44)
		end
	else
		return var_0_5("invalid argument #3. must be a function (if element does not have a template)")
	end

	return true
end

local function var_0_46(arg_46_0, arg_46_1, arg_46_2)
	if not arg_46_1 or type(arg_46_1) ~= "table" then
		return var_0_5("invalid event table. must be a key value table")
	end

	if arg_46_2 and type(arg_46_2) == "function" then
		local var_46_0, var_46_1 = pcall(arg_46_2, arg_46_0)

		if not var_46_0 or type(var_46_1) ~= "boolean" then
			var_0_5("invalid argument #2. function must take uilib object as the first argument and return a boolean")
		end

		for iter_46_0, iter_46_1 in pairs(arg_46_1) do
			if type(iter_46_0) == "string" and type(iter_46_1) == "function" then
				var_0_12:add_event(arg_46_0.reference, iter_46_0, iter_46_1, arg_46_2)
			elseif type(iter_46_0) == "string" then
				var_0_5("invalid event table entry for ", iter_46_0, ", value must be a function (", iter_46_0, " = function() end)")
			else
				var_0_5("invalid event table key")
			end
		end
	elseif string.find(arg_46_0.ref_type, "checkbox") then
		for iter_46_2, iter_46_3 in pairs(arg_46_1) do
			if type(iter_46_2) == "string" and type(iter_46_3) == "function" then
				var_0_12:add_event(arg_46_0.reference, iter_46_2, iter_46_3, var_0_43)
			elseif type(iter_46_2) == "string" then
				var_0_5("invalid event table entry for ", iter_46_2, ", value must be a function (", iter_46_2, " = function() end)")
			else
				var_0_5("invalid event table key")
			end
		end
	elseif string.find(arg_46_0.ref_type, "multiselect") then
		for iter_46_4, iter_46_5 in pairs(arg_46_1) do
			if type(iter_46_4) == "string" and type(iter_46_5) == "function" then
				var_0_12:add_event(arg_46_0.reference, iter_46_4, iter_46_5, var_0_44)
			elseif type(iter_46_4) == "string" then
				var_0_5("invalid event table entry for ", iter_46_4, ", value must be a function (", iter_46_4, " = function() end)")
			else
				var_0_5("invalid event table key")
			end
		end
	else
		return var_0_5("invalid argument #2. must be a function (if element does not have a template)")
	end
end

local function var_0_47(arg_47_0, arg_47_1, arg_47_2)
	return var_0_12:remove_event(arg_47_0.reference, arg_47_1, arg_47_2)
end

local function var_0_48(arg_48_0, arg_48_1)
	return var_0_12:remove_change(arg_48_0.reference, arg_48_1)
end

local function var_0_49(arg_49_0, arg_49_1)
	return var_0_12:add_change(arg_49_0.reference, arg_49_1)
end

local function var_0_50(arg_50_0)
	var_0_11(arg_50_0.reference)
end

local function var_0_51(arg_51_0)
	var_0_12:update_events(arg_51_0.reference)
end

local function var_0_52(arg_52_0)
	var_0_12:update_callbacks(arg_52_0.reference)
end

local function var_0_53(arg_53_0, arg_53_1)
	if not arg_53_1 then
		return var_0_1[select(2, ui.get(arg_53_0.reference))]
	elseif type(arg_53_1) == "string" then
		ui.set(arg_53_0.reference, arg_53_1)
	end
end

local function var_0_54(arg_54_0, arg_54_1)
	if not arg_54_1 then
		return select(3, ui.get(arg_54_0.reference))
	elseif type(arg_54_1) == "number" then
		ui.set(arg_54_0.reference, nil, arg_54_1)
	end
end

local function var_0_55(arg_55_0, arg_55_1)
	for iter_55_0, iter_55_1 in ipairs(ui.get(arg_55_0.reference)) do
		if iter_55_1 == arg_55_1 then
			return true
		end
	end

	return false
end

local function var_0_56(arg_56_0, arg_56_1)
	if not arg_56_0:contains(arg_56_1) then
		local var_56_0 = ui.get(arg_56_0.reference)

		var_56_0[#var_56_0 + 1] = arg_56_1

		ui.set(arg_56_0.reference, var_56_0)
	end
end

local function var_0_57(arg_57_0, arg_57_1)
	if arg_57_0:contains(arg_57_1) then
		local var_57_0 = {}

		for iter_57_0, iter_57_1 in ipairs(ui.get(arg_57_0.reference)) do
			if iter_57_1 ~= arg_57_1 then
				var_57_0[#var_57_0 + 1] = iter_57_1
			end
		end

		ui.set(arg_57_0.reference, var_57_0)
	end
end

local function var_0_58(arg_58_0)
	ui.set(arg_58_0.reference, {})
end

local function var_0_59(arg_59_0)
	return arg_59_0.states[ui.get(arg_59_0.reference) + 1]
end

local function var_0_60(arg_60_0, ...)
	local var_60_0 = {
		...
	}

	ui.update(arg_60_0.reference, var_60_0)

	arg_60_0.states = var_60_0
end

local function var_0_61(arg_61_0, arg_61_1)
	if ui.type(arg_61_1.reference) == "checkbox" then
		var_0_12:add_child(arg_61_1.reference, arg_61_0.reference)

		arg_61_1.children[#arg_61_1.children + 1] = arg_61_0

		rawset(arg_61_0, "parent", arg_61_1)
	else
		var_0_5("invalid parent type, only supports checkboxes")
	end
end

local function var_0_62(arg_62_0, arg_62_1, arg_62_2)
	if arg_62_1 == "multiselect" or arg_62_1 == "multiselect_reference" then
		arg_62_0.contains = var_0_55
		arg_62_0.add = var_0_56
		arg_62_0.remove = var_0_57
		arg_62_0.clear = var_0_58

		if arg_62_1 == "multiselect" then
			arg_62_0.states = arg_62_2
			arg_62_0.update = var_0_60
		end
	elseif arg_62_1 == "listbox" then
		arg_62_0.states = arg_62_2
		arg_62_0.update = var_0_60
		arg_62_0.selected = var_0_59
	elseif arg_62_1 == "combobox" then
		arg_62_0.states = arg_62_2
		arg_62_0.update = var_0_60
	elseif arg_62_1 == "hotkey" or arg_62_1 == "hotkey_reference" then
		arg_62_0.mode = var_0_53
		arg_62_0.key = var_0_54
	elseif arg_62_1 ~= "color_picker" and arg_62_1 == "color_picker_reference" then
		-- block empty
	end
end

local var_0_63 = {
	__metatable = "uilib_object",
	__name = "uilib_object",
	__index = var_0_40,
	__newindex = var_0_41,
	__tostring = getmetatable,
	__call = var_0_39
}

local function var_0_64(arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
	local var_63_0
	local var_63_1

	if type(arg_63_0) == "function" then
		if arg_63_4 and #arg_63_4 > 0 then
			var_63_0 = arg_63_0(arg_63_1, arg_63_2, arg_63_3, table.unpack(arg_63_4))
		else
			var_63_0 = arg_63_0(arg_63_1, arg_63_2, arg_63_3)
		end

		var_63_1 = var_0_0[arg_63_0]
	elseif type(arg_63_0) == "number" and type(arg_63_3) == "string" and type(arg_63_4) == "string" then
		if var_0_4[arg_63_0] then
			return var_0_4[arg_63_0]
		else
			var_63_0 = arg_63_0
			var_63_1 = arg_63_4 .. "_reference"
		end
	else
		return var_0_5("unhandled arguments")
	end

	local var_63_2 = ui.set_visible(var_63_0, true)

	ui.set_visible(var_63_0, var_63_2)

	local var_63_3 = {
		reference = var_63_0,
		is_visible = var_63_2,
		ref_type = var_63_1,
		name = arg_63_3,
		children = {},
		add_callback = var_0_49,
		remove_callback = var_0_48,
		add_event_callback = var_0_45,
		add_event_table = var_0_46,
		remove_event_callback = var_0_47,
		invoke = var_0_50,
		update_events = var_0_51,
		update_callbacks = var_0_52,
		set_parent = var_0_61
	}

	var_0_62(var_63_3, var_63_1, arg_63_4)

	var_0_4[var_63_0] = setmetatable(var_63_3, var_0_63)

	return var_0_4[var_63_0]
end

local function var_0_65(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
	if arg_64_4 then
		return var_0_64(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
	else
		var_0_5("unimplemented method for guessing type of reference, please pass 4th arg as the reference type ('combobox', 'multiselect', 'color_picker')")
		error()
	end
end

return {
	new_button = function(arg_65_0, arg_65_1, arg_65_2, ...)
		return var_0_64(ui.new_button, arg_65_0, arg_65_1, arg_65_2, {
			function()
				return
			end
		})
	end,
	new_checkbox = function(arg_67_0, arg_67_1, arg_67_2, ...)
		return var_0_64(ui.new_checkbox, arg_67_0, arg_67_1, arg_67_2, {
			...
		})
	end,
	new_color_picker = function(arg_68_0, arg_68_1, arg_68_2, ...)
		return var_0_64(ui.new_color_picker, arg_68_0, arg_68_1, arg_68_2, {
			...
		})
	end,
	new_combobox = function(arg_69_0, arg_69_1, arg_69_2, ...)
		return var_0_64(ui.new_combobox, arg_69_0, arg_69_1, arg_69_2, {
			...
		})
	end,
	new_hotkey = function(arg_70_0, arg_70_1, arg_70_2, ...)
		return var_0_64(ui.new_hotkey, arg_70_0, arg_70_1, arg_70_2, {
			...
		})
	end,
	new_label = function(arg_71_0, arg_71_1, arg_71_2, ...)
		return var_0_64(ui.new_label, arg_71_0, arg_71_1, arg_71_2, {
			...
		})
	end,
	new_listbox = function(arg_72_0, arg_72_1, arg_72_2, ...)
		return var_0_64(ui.new_listbox, arg_72_0, arg_72_1, arg_72_2, {
			...
		})
	end,
	new_multiselect = function(arg_73_0, arg_73_1, arg_73_2, ...)
		return var_0_64(ui.new_multiselect, arg_73_0, arg_73_1, arg_73_2, {
			...
		})
	end,
	new_slider = function(arg_74_0, arg_74_1, arg_74_2, ...)
		return var_0_64(ui.new_slider, arg_74_0, arg_74_1, arg_74_2, {
			...
		})
	end,
	new_string = function(arg_75_0, arg_75_1, arg_75_2, ...)
		return var_0_64(ui.new_string, arg_75_0, arg_75_1, arg_75_2, {
			...
		})
	end,
	new_textbox = function(arg_76_0, arg_76_1, arg_76_2, ...)
		return var_0_64(ui.new_textbox, arg_76_0, arg_76_1, arg_76_2, {
			...
		})
	end,
	reference = function(arg_77_0, arg_77_1, arg_77_2)
		local var_77_0 = {
			pcall(ui.reference, arg_77_0, arg_77_1, arg_77_2)
		}

		if var_77_0[1] then
			table.remove(var_77_0, 1)

			local var_77_1 = {}

			for iter_77_0, iter_77_1 in ipairs(var_77_0) do
				var_77_1[iter_77_0] = var_0_65(iter_77_1, arg_77_0, arg_77_1, arg_77_2, ui.type(iter_77_1))
			end

			return table.unpack(var_77_1)
		else
			return var_0_5("invalid object")
		end
	end,
	reference_old = function(arg_78_0, arg_78_1, arg_78_2, arg_78_3)
		local var_78_0, var_78_1 = pcall(ui.reference, arg_78_0, arg_78_1, arg_78_2)

		if var_78_0 and var_78_1 then
			return var_0_65(var_78_1, arg_78_0, arg_78_1, arg_78_2, arg_78_3)
		else
			return var_0_5("invalid object")
		end
	end,
	create_from_reference = function(arg_79_0, arg_79_1, arg_79_2)
		if arg_79_0 and type(arg_79_0) == "number" and arg_79_1 and type(arg_79_1) == "string" and arg_79_2 and type(arg_79_2) == "string" then
			return var_0_65(arg_79_0, nil, nil, arg_79_1, arg_79_2)
		else
			return var_0_5("invalid reference")
		end
	end,
	get_ref = function(arg_80_0)
		if var_0_4[arg_80_0] then
			return var_0_4[arg_80_0]
		else
			return var_0_5("reference is not a uilib object")
		end
	end,
	create_plist = var_0_36
}
