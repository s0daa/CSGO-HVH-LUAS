local var_0_0 = require("ffi")
local var_0_1 = client.create_interface("vguimatsurface.dll", "VGUI_Surface031")
local var_0_2 = vtable_thunk(71, "unsigned int(__thiscall*)(void*)")
local var_0_3 = vtable_thunk(72, "void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)")

local function var_0_4(arg_1_0, arg_1_1)
	local var_1_0 = var_0_2(var_0_1)

	var_0_3(var_0_1, var_1_0, arg_1_0, arg_1_1, 400, 0, 0, 16, 0, 65535)

	return var_1_0
end

local var_0_5 = {
	"Tahoma",
	"Consolas",
	"Verdana",
	"Segoe UI",
	"Segoe Print"
}
local var_0_6 = database.read("Console_UserDefinedFonts") or {}
local var_0_7 = {}
local var_0_8

ui.new_label("LUA", "B", "\t~ Console font ~\t")

local var_0_9 = ui.new_listbox("LUA", "B", "Cosole Font", var_0_5)
local var_0_10 = ui.new_slider("LUA", "B", "Cosole Font Size", 12, 40, 18, true, "pt", 1)
local var_0_11 = ui.new_textbox("LUA", "B", "Font Name")

local function var_0_12()
	table.clear(var_0_7)

	for iter_2_0, iter_2_1 in pairs(var_0_5) do
		table.insert(var_0_7, iter_2_1)
	end

	for iter_2_2, iter_2_3 in pairs(var_0_6) do
		table.insert(var_0_7, iter_2_3)
	end

	table.insert(var_0_7, "[+] Add New")
	ui.update(var_0_9, var_0_7)
end

local var_0_13 = ui.new_button("LUA", "B", "Add font", function()
	table.insert(var_0_6, ui.get(var_0_11))
	ui.set(var_0_11, "")
	var_0_12()
	var_0_8()
	database.write("Console_UserDefinedFonts", var_0_6)
end)
local var_0_14 = ui.new_button("LUA", "B", "Delete font", function()
	table.remove(var_0_6, ui.get(var_0_9) - #var_0_5 + 1)
	var_0_12()
	var_0_8()
	database.write("Console_UserDefinedFonts", var_0_6)
end)

ui.new_label("LUA", "B", "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~")
ui.set_visible(var_0_13, false)
ui.set_visible(var_0_14, false)
ui.set_visible(var_0_11, false)
var_0_12()

local var_0_15 = var_0_0.cast("uint32_t***", var_0_0.cast("uint32_t", client.find_signature("engine.dll", "\x8B\x1D\xCC\xCC\xCC̉]\xF0")) + 2)[0][0]
local var_0_16 = var_0_0.cast("uint32_t*****", var_0_0.cast("uint32_t", client.find_signature("client.dll", "\x8B\r\xCC\xCC\xCC̋\x89")) + 2)[0][0][136]
local var_0_17 = var_0_16[100]
local var_0_18 = var_0_16[101]
local var_0_19 = {
	m_pHistory = {
		font = var_0_17[114]
	},
	m_pEntry = {
		font = var_0_18[117]
	},
	g_pConPanel = {
		font = var_0_15[86]
	}
}

local function var_0_20(arg_5_0)
	var_0_17[114] = arg_5_0
	var_0_18[117] = arg_5_0
	var_0_15[86] = arg_5_0
end

client.set_event_callback("shutdown", function()
	var_0_17[114] = var_0_19.m_pHistory.font
	var_0_18[117] = var_0_19.m_pEntry.font
	var_0_15[86] = var_0_19.g_pConPanel.font
end)

local var_0_21 = {}

function var_0_8(arg_7_0)
	local var_7_0 = var_0_7[ui.get(var_0_9) + 1]
	local var_7_1 = ui.get(var_0_10)

	if var_7_0 == nil then
		return
	end

	local var_7_2 = var_7_0 == "[+] Add New"

	ui.set_visible(var_0_13, var_7_2)
	ui.set_visible(var_0_11, var_7_2)
	ui.set_visible(var_0_10, not var_7_2)

	local var_7_3 = false

	for iter_7_0, iter_7_1 in pairs(var_0_6) do
		if var_7_0 == iter_7_1 then
			var_7_3 = true

			break
		end
	end

	ui.set_visible(var_0_14, var_7_3)

	if var_7_2 then
		return
	end

	if var_0_21[var_7_0] ~= nil and var_0_21[var_7_0][var_7_1] ~= nil then
		var_0_20(var_0_21[var_7_0][var_7_1])

		return
	end

	if var_0_21[var_7_0] == nil then
		var_0_21[var_7_0] = {}
	end

	var_0_21[var_7_0][var_7_1] = var_0_4(var_7_0, var_7_1)

	var_0_20(var_0_21[var_7_0][var_7_1])
	database.write("Console_Font", {
		family = var_7_0,
		size = var_7_1
	})
end

ui.set_callback(var_0_9, var_0_8)
ui.set_callback(var_0_10, var_0_8)

local var_0_22 = database.read("Console_Font")

if type(var_0_22) == "table" and not pcall(function()
	for iter_8_0, iter_8_1 in pairs(var_0_7) do
		if var_0_22.family == iter_8_1 then
			ui.set(var_0_9, iter_8_0 - 1)
		end
	end

	ui.set(var_0_10, var_0_22.size)
end) then
	ui.set(var_0_9, 1)
	ui.set(var_0_10, 18)
end

var_0_8()
