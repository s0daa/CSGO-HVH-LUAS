slot0 = require("ffi")
slot1 = client.create_interface("vguimatsurface.dll", "VGUI_Surface031")
slot2 = vtable_thunk(71, "unsigned int(__thiscall*)(void*)")
slot3 = vtable_thunk(72, "void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)")

function slot4(slot0, slot1)
	slot2 = uv0(uv1)

	uv2(uv1, slot2, slot0, slot1, 400, 0, 0, 16, 0, 65535)

	return slot2
end

slot6 = database.read("Console_UserDefinedFonts") or {}
slot7 = {}
slot8 = nil

ui.new_label("LUA", "B", "\t~ Console font ~\t")
ui.new_label("LUA", "B", "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~")
ui.set_visible(ui.new_button("LUA", "B", "Add font", function ()
	table.insert(uv0, ui.get(uv1))
	ui.set(uv1, "")
	uv2()
	uv3()
	database.write("Console_UserDefinedFonts", uv0)
end), false)
ui.set_visible(ui.new_button("LUA", "B", "Delete font", function ()
	table.remove(uv0, ui.get(uv1) - #uv2 + 1)
	uv3()
	uv4()
	database.write("Console_UserDefinedFonts", uv0)
end), false)
ui.set_visible(ui.new_textbox("LUA", "B", "Font Name"), false)
function ()
	table.clear(uv0)

	for slot3, slot4 in pairs(uv1) do
		table.insert(uv0, slot4)
	end

	for slot3, slot4 in pairs(uv2) do
		table.insert(uv0, slot4)
	end

	table.insert(uv0, "[+] Add New")
	ui.update(uv3, uv0)
end()

slot16 = slot0.cast("uint32_t*****", slot0.cast("uint32_t", client.find_signature("client.dll", "\\x8b\r\\xcc\\xcc\\xcc̋\\x89")) + 2)[0][0][136]
slot19 = {
	m_pHistory = {
		font = slot16[100][114]
	},
	m_pEntry = {
		font = slot16[101][117]
	},
	g_pConPanel = {
		font = slot0.cast("uint32_t***", slot0.cast("uint32_t", client.find_signature("engine.dll", "\\x8b\\xcc\\xcc\\xcc̉]\\xf0")) + 2)[0][0][86]
	}
}

function slot20(slot0)
	uv0[114] = slot0
	uv1[117] = slot0
	uv2[86] = slot0
end

client.set_event_callback("shutdown", function ()
	uv0[114] = uv1.m_pHistory.font
	uv2[117] = uv1.m_pEntry.font
	uv3[86] = uv1.g_pConPanel.font
end)

slot21 = {}

function slot8(slot0)
	slot2 = ui.get(uv2)

	if uv0[ui.get(uv1) + 1] == nil then
		return
	end

	slot3 = slot1 == "[+] Add New"

	ui.set_visible(uv3, slot3)
	ui.set_visible(uv4, slot3)
	ui.set_visible(uv2, not slot3)

	slot4 = false

	for slot8, slot9 in pairs(uv5) do
		if slot1 == slot9 then
			slot4 = true

			break
		end
	end

	ui.set_visible(uv6, slot4)

	if slot3 then
		return
	end

	if uv7[slot1] ~= nil and uv7[slot1][slot2] ~= nil then
		uv8(uv7[slot1][slot2])

		return
	end

	if uv7[slot1] == nil then
		uv7[slot1] = {}
	end

	uv7[slot1][slot2] = uv9(slot1, slot2)

	uv8(uv7[slot1][slot2])
	database.write("Console_Font", {
		family = slot1,
		size = slot2
	})
end

ui.set_callback(ui.new_listbox("LUA", "B", "Cosole Font", {
	"Tahoma",
	"Consolas",
	"Verdana",
	"Segoe UI",
	"Segoe Print"
}), slot8)
ui.set_callback(ui.new_slider("LUA", "B", "Cosole Font Size", 12, 40, 18, true, "pt", 1), slot8)

if type(database.read("Console_Font")) == "table" and not pcall(function ()
	for slot3, slot4 in pairs(uv0) do
		if uv1.family == slot4 then
			ui.set(uv2, slot3 - 1)
		end
	end

	ui.set(uv3, uv1.size)
end) then
	ui.set(slot9, 1)
	ui.set(slot10, 18)
end

slot8()
