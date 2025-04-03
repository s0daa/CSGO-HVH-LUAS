local var_0_0 = {
	white = string.char(1),
	red = string.char(2),
	purple = string.char(3),
	green = string.char(4),
	lightgreen = string.char(5),
	turquoise = string.char(6),
	lightred = string.char(7),
	gray = string.char(8),
	yellow = string.char(9),
	gray2 = string.char(10),
	lightblue = string.char(11),
	gray3 = string.char(12),
	blue = string.char(13),
	pink = string.char(14),
	darkorange = string.char(15),
	orange = string.char(16)
}
local var_0_1 = {
	"default"
}

for iter_0_0, iter_0_1 in pairs(var_0_0) do
	table.insert(var_0_1, iter_0_0)
end

table.insert(var_0_1, "rainbow")
table.insert(var_0_1, "christmas")

local var_0_2 = "playerchatwheel . \"%s\""
local var_0_3 = "Lua"
local var_0_4 = "A"
local var_0_5 = {
	_ = ui.new_label(var_0_3, var_0_4, "Radio Text"),
	color = ui.new_combobox(var_0_3, var_0_4, "Text Color", var_0_1),
	text = ui.new_textbox(var_0_3, var_0_4, "Text")
}

local function var_0_6(arg_1_0, arg_1_1)
	local var_1_0 = 1
	local var_1_1 = string.char(32, 1, 11)

	for iter_1_0 in arg_1_0:gmatch(string.char(46, 91, 128, 45, 191, 93, 42)) do
		if iter_1_0 ~= nil then
			if var_1_0 > #arg_1_1 then
				var_1_0 = 1
			end

			var_1_1 = var_1_1 .. arg_1_1[var_1_0] .. iter_1_0

			if iter_1_0 ~= " " then
				var_1_0 = var_1_0 + 1
			end
		end
	end

	return var_1_1
end

local function var_0_7(arg_2_0)
	local var_2_0 = arg_2_0 and type(arg_2_0) == "string" and arg_2_0 or ui.get(var_0_5.text)
	local var_2_1 = ui.get(var_0_5.color)
	local var_2_2 = string.char(32, 1, 11)

	if var_2_1 == "rainbow" then
		var_2_2 = var_0_6(var_2_0, {
			var_0_0.red,
			var_0_0.orange,
			var_0_0.yellow,
			var_0_0.green,
			var_0_0.blue
		})
	elseif var_2_1 == "christmas" then
		var_2_2 = var_0_6(var_2_0, {
			var_0_0.red,
			var_0_0.green
		})
	elseif var_2_1 == "default" then
		var_2_2 = var_2_0
	else
		var_2_2 = var_2_2 .. var_0_0[var_2_1] .. var_2_0
	end

	client.exec(string.format(var_0_2, var_2_2))
end

var_0_5.send_message = ui.new_button(var_0_3, var_0_4, "Send", var_0_7)

local var_0_8 = globals.tickcount()

var_0_5.spam = require("gamesense/uix").new_checkbox(var_0_3, var_0_4, "Spam Radio")

var_0_5.spam:on("paint_ui", function()
	if globals.tickcount() - var_0_8 > 32 then
		var_0_7()

		var_0_8 = globals.tickcount()
	end
end)
client.set_event_callback("string_cmd", function(arg_4_0)
	local var_4_0 = arg_4_0.text:match("^say \"(.*)\"") or arg_4_0.text:match("^say_team \"(.*)\"")

	if var_4_0 and var_4_0:find("^!r ") then
		var_0_7(var_4_0:sub(3))

		return true
	end
end)
