slot1 = {
	"default"
}

for slot5, slot6 in pairs({
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
}) do
	table.insert(slot1, slot5)
end

table.insert(slot1, "rainbow")
table.insert(slot1, "christmas")

slot2 = "playerchatwheel . \"%s\""
slot3 = "Lua"
slot4 = "A"

function slot6(slot0, slot1)
	slot3 = string.char(32, 1, 11)
	slot7 = 46

	for slot7 in slot0:gmatch(string.char(slot7, 91, 128, 45, 191, 93, 42)) do
		if slot7 ~= nil then
			if 1 > #slot1 then
				slot2 = 1
			end

			slot3 = slot3 .. slot1[slot2] .. slot7

			if slot7 ~= " " then
				slot2 = slot2 + 1
			end
		end
	end

	return slot3
end

slot8 = globals.tickcount()

({
	_ = ui.new_label(slot3, slot4, "Radio Text"),
	color = ui.new_combobox(slot3, slot4, "Text Color", slot1),
	text = ui.new_textbox(slot3, slot4, "Text"),
	send_message = ui.new_button(slot3, slot4, "Send", function (slot0)
		slot1 = slot0 and type(slot0) == "string" and slot0 or ui.get(uv0.text)

		client.exec(string.format(uv3, (ui.get(uv0.color) ~= "rainbow" or uv1(slot1, {
			uv2.red,
			uv2.orange,
			uv2.yellow,
			uv2.green,
			uv2.blue
		})) and (slot2 ~= "christmas" or uv1(slot1, {
			uv2.red,
			uv2.green
		})) and (slot2 == "default" and slot1 or string.char(32, 1, 11) .. uv2[slot2] .. slot1)))
	end),
	spam = require("gamesense/uix").new_checkbox(slot3, slot4, "Spam Radio")
}).spam:on("paint_ui", function ()
	if globals.tickcount() - uv0 > 32 then
		uv1()

		uv0 = globals.tickcount()
	end
end)
client.set_event_callback("string_cmd", function (slot0)
	if (slot0.text:match("^say \"(.*)\"") or slot0.text:match("^say_team \"(.*)\"")) and slot1:find("^!r ") then
		uv0(slot1:sub(3))

		return true
	end
end)
