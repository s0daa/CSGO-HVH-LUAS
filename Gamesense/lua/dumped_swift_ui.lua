-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = _G.ui
local var_0_1 = {}

var_0_1.__index = var_0_1

function var_0_1.add_callback(arg_1_0, arg_1_1)
	if type(arg_1_1) == "function" then
		arg_1_0.callbacks[#arg_1_0.callbacks + 1] = arg_1_1

		arg_1_0:process_callbacks()
	end

	return arg_1_0
end

function var_0_1.add_children(arg_2_0, arg_2_1, arg_2_2)
	if getmetatable(arg_2_1) == var_0_1 then
		arg_2_1 = {
			arg_2_1
		}
	end

	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		arg_2_0.children[#arg_2_0.children + 1] = {
			obj = iter_2_1,
			value = arg_2_2 or true
		}
	end

	table.sort(arg_2_0.children, function(arg_3_0, arg_3_1)
		return arg_3_0.obj:ref() > arg_3_1.obj:ref()
	end)
	arg_2_0:process_callbacks()
end

function var_0_1.process_callbacks(arg_4_0, arg_4_1)
	local function var_4_0()
		local var_5_0 = arg_4_0:get()

		for iter_5_0 = 1, #arg_4_0.children do
			local var_5_1 = arg_4_0.children[iter_5_0]
			local var_5_2 = type(var_5_1.value) == "function" and var_5_1.value(arg_4_0) or var_5_0 == var_5_1.value

			var_5_1.obj:set_visible(var_5_2)

			if arg_4_1 ~= nil then
				var_5_1.obj:set_visible(arg_4_1 and var_5_2)
			end

			if arg_4_1 ~= nil then
				var_5_1.obj:process_callbacks(arg_4_1 and var_5_2)
			else
				var_5_1.obj:process_callbacks(var_5_2)
			end
		end

		for iter_5_1 = 1, #arg_4_0.callbacks do
			arg_4_0.callbacks[iter_5_1]()
		end

		for iter_5_2 = 1, #arg_4_0.events do
			local var_5_3 = arg_4_0.events[iter_5_2]
			local var_5_4 = type(var_5_3.value) == "function" and var_5_3.value(arg_4_0) or var_5_0 == var_5_3.value

			if var_5_3.registered ~= var_5_4 then
				client[(var_5_4 and "" or "un") .. "set_event_callback"](var_5_3.name, var_5_3.func)

				var_5_3.registered = var_5_4
			end
		end
	end

	local var_4_1, var_4_2 = pcall(function()
		var_0_0.get(arg_4_0:ref())
	end)

	if not var_4_2 then
		arg_4_0:set_callback(var_4_0)
		var_4_0()
	end
end

function var_0_1.get(arg_7_0, arg_7_1)
	if arg_7_0 == nil then
		return
	end

	if arg_7_1 then
		return var_0_0.get(arg_7_0.objs[arg_7_1] or arg_7_0)
	end

	local var_7_0 = {}

	for iter_7_0 = 1, #arg_7_0.objs do
		local var_7_1 = {}

		pcall(function()
			var_7_1 = {
				var_0_0.get(arg_7_0.objs[iter_7_0] or arg_7_0)
			}
		end)

		for iter_7_1 = 1, #var_7_1 do
			var_7_0[#var_7_0 + 1] = var_7_1[iter_7_1]
		end
	end

	return unpack(var_7_0)
end

function var_0_1.register(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = #arg_9_0.events + 1

	arg_9_0.events[var_9_0] = {
		registered = false,
		name = arg_9_1,
		func = arg_9_2,
		value = arg_9_3 or true
	}

	return var_9_0
end

function var_0_1.unregister(arg_10_0, arg_10_1)
	table.remove(arg_10_0.events, arg_10_1)

	return arg_10_0
end

function var_0_1.compare(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0:get()

	return (arg_11_2 and var_11_0:lower() or var_11_0) == arg_11_1
end

function var_0_1.lower(arg_12_0)
	return arg_12_0:get():lower()
end

function var_0_1.set(arg_13_0, ...)
	if not arg_13_0 then
		return
	end

	local var_13_0 = type(arg_13_0) ~= "number" and arg_13_0.objs[1] or arg_13_0

	if var_13_0 then
		var_0_0.set(var_13_0, ...)
	end

	return arg_13_0
end

function var_0_1.set_index(arg_14_0, arg_14_1, ...)
	if not arg_14_0 then
		return
	end

	local var_14_0 = type(arg_14_0) ~= "number" and arg_14_0.objs[arg_14_1] or arg_14_0

	if var_14_0 then
		var_0_0.set(var_14_0, ...)
	end

	return arg_14_0
end

function var_0_1.update(arg_15_0, ...)
	local var_15_0 = {}

	for iter_15_0 = 1, #arg_15_0.objs do
		local var_15_1 = {
			...
		}

		if var_15_1[iter_15_0] ~= nil then
			var_15_0[#var_15_0 + 1] = var_0_0.update(arg_15_0.objs[iter_15_0] or arg_15_0, var_15_1[iter_15_0])
		end
	end

	return arg_15_0
end

function var_0_1.ref(arg_16_0, arg_16_1)
	return arg_16_1 and arg_16_0.objs[arg_16_1] or unpack(arg_16_0.objs)
end

function var_0_1.set_callback(arg_17_0, ...)
	local var_17_0 = {}

	for iter_17_0 = 1, #arg_17_0.objs do
		local var_17_1 = {
			...
		}

		if var_17_1[iter_17_0] ~= nil then
			var_17_0[#var_17_0 + 1] = var_0_0.set_callback(arg_17_0.objs[iter_17_0] or arg_17_0, var_17_1[iter_17_0])
		end
	end

	return arg_17_0
end

function var_0_1.set_visible(arg_18_0, ...)
	local var_18_0 = {}

	for iter_18_0 = 1, #arg_18_0.objs do
		local var_18_1 = {
			...
		}

		if var_18_1[iter_18_0] ~= nil then
			var_18_0[#var_18_0 + 1] = var_0_0.set_visible(arg_18_0.objs[iter_18_0] or arg_18_0, var_18_1[iter_18_0])
		end
	end

	return arg_18_0
end

function var_0_1.name(arg_19_0, arg_19_1)
	if arg_19_1 then
		return var_0_0.name(arg_19_0.objs[arg_19_1] or arg_19_0)
	end

	local var_19_0 = {}

	if type(arg_19_0) == "number" then
		return var_0_0.name(arg_19_0)
	end

	for iter_19_0 = 1, #arg_19_0.objs do
		var_19_0[#var_19_0 + 1] = var_0_0.name(arg_19_0.objs[iter_19_0] or arg_19_0)
	end

	return unpack(var_19_0)
end

local var_0_2 = {
	"new_button",
	"new_checkbox",
	"new_color_picker",
	"new_combobox",
	"new_hotkey",
	"new_label",
	"new_listbox",
	"new_multiselect",
	"new_slider",
	"new_string",
	"new_textbox",
	"reference"
}

function var_0_1.new(...)
	return setmetatable({
		objs = {
			...
		},
		children = {},
		callbacks = {},
		events = {}
	}, var_0_1)
end

for iter_0_0 = 1, #var_0_2 do
	local var_0_3 = var_0_2[iter_0_0]

	var_0_1[var_0_3] = function(...)
		local var_21_0 = {
			...
		}
		local var_21_1 = var_21_0[1]

		if getmetatable(var_21_1) == var_0_1 then
			table.remove(var_21_0, 1)
		else
			var_21_1 = nil
		end

		local var_21_2 = {}

		if var_0_3 == var_0_2[3] and var_21_0[8] then
			var_21_2[#var_21_2 + 1] = var_0_1.new(var_0_0.new_label(unpack(var_21_0)))
		end

		local var_21_3 = #var_21_2 + 1

		var_21_2[var_21_3] = var_0_1.new(var_0_0[var_0_3](unpack(var_21_0)))

		if var_21_1 then
			var_21_1:add_children(var_21_2)
		end

		return var_21_2[var_21_3]
	end
end

local var_0_4 = {
	"is_menu_open",
	"menu_position",
	"menu_size",
	"mouse_position"
}

for iter_0_1 = 1, #var_0_4 do
	local var_0_5 = var_0_4[iter_0_1]

	var_0_1[var_0_5] = function(...)
		return var_0_0[var_0_5](...)
	end
end

setmetatable(var_0_1, {
	__call = function(arg_23_0, ...)
		return var_0_1.new(...)
	end
})

return var_0_1
