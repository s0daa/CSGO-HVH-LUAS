local function var_0_0(arg_1_0)
	local var_1_0 = {}

	for iter_1_0 in pairs(arg_1_0) do
		var_1_0[#var_1_0 + 1] = iter_1_0
	end

	return var_1_0
end

local var_0_1 = 0
local var_0_2 = 0
local var_0_3 = {
	Static = function(arg_2_0)
		return arg_2_0.text
	end,
	Default = function(arg_3_0)
		return var_0_1 == 0 and "\x00" or arg_3_0.text:sub(1, var_0_1)
	end,
	Reverse = function(arg_4_0)
		local var_4_0 = arg_4_0.text
		local var_4_1 = arg_4_0.text:len()

		return var_4_1 >= var_0_2 and var_4_0:sub(1, var_0_1) or var_4_1 - var_0_1 == 0 and "\x00" or var_4_0:sub(1, var_4_1 - var_0_1)
	end,
	Loop = function(arg_5_0)
		local var_5_0 = arg_5_0.text

		for iter_5_0 = 1, var_0_1 do
			var_5_0 = var_5_0 .. var_5_0:sub(1, 1)
			var_5_0 = var_5_0:sub(2, var_5_0:len())
		end

		return var_5_0
	end
}
local var_0_4 = require("gamesense/swift_ui")
local var_0_5 = "LUA"
local var_0_6 = "A"
local var_0_7 = database.read("sam_clantags") or {}
local var_0_8 = var_0_4.new_combobox(var_0_5, var_0_6, "Clantag Changer", "Create new", table.unpack(var_0_0(var_0_7)))
local var_0_9 = {
	var_0_4.new_label(var_0_5, var_0_6, "Create new clantag:"),
	var_0_4.new_label(var_0_5, var_0_6, "Name"),
	name = var_0_4.new_textbox(var_0_5, var_0_6, "Name"),
	var_0_4.new_label(var_0_5, var_0_6, "Text"),
	text = var_0_4.new_textbox(var_0_5, var_0_6, "Text"),
	animation = var_0_4.new_combobox(var_0_5, var_0_6, "Animation", var_0_0(var_0_3)),
	speed = var_0_4.new_slider(var_0_5, var_0_6, "Speed", 0, 100, 30, true, "%")
}

var_0_9.create = var_0_4.new_button(var_0_5, var_0_6, "Create", function()
	local var_6_0 = var_0_9.name:get()
	local var_6_1 = var_0_9.text:get()

	if var_6_0 == "" or var_6_1 == "" then
		error("Clantag name/text cannot be empty!")
	end

	var_0_7[var_0_9.name:get()] = {
		text = var_6_1,
		animation = var_0_9.animation:get(),
		speed = var_0_9.speed:get()
	}

	client.reload_active_scripts()
end)

var_0_8:add_children(var_0_9, function(arg_7_0)
	return arg_7_0:compare("Create new")
end)
var_0_8:add_children(var_0_4.new_button(var_0_5, var_0_6, "Remove", function()
	var_0_7[var_0_8:get()] = nil

	client.reload_active_scripts()
end), function(arg_9_0)
	return not arg_9_0:compare("Create new")
end)
client.set_event_callback("shutdown", function()
	database.write("sam_clantags", var_0_7)
end)

local var_0_10

client.set_event_callback("net_update_end", function()
	local var_11_0 = var_0_8:get()
	local var_11_1 = var_0_7[var_11_0]

	if var_11_0 == "Create new" then
		var_11_1 = {
			text = var_0_9.text:get(),
			animation = var_0_9.animation:get(),
			speed = var_0_9.speed:get()
		}
	end

	local var_11_2 = var_0_3[var_11_1.animation]
	local var_11_3 = var_11_1.text:len()

	var_0_1 = math.floor(globals.curtime() * var_11_1.speed / 10 % var_11_3 + 1)
	var_0_2 = math.floor(globals.curtime() * var_11_1.speed / 10 % (var_11_3 * 2) + 1)

	local var_11_4 = var_11_2(var_11_1)

	if var_0_10 ~= var_11_4 then
		client.set_clan_tag(var_11_4)

		var_0_10 = var_11_4
	end
end)
