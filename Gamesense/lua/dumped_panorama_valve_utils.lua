-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = {
	IconUtil = "file://{resources}/scripts/common/icon.js",
	SessionUtil = "file://{resources}/scripts/common/sessionutil.js",
	FormatText = "file://{resources}/scripts/common/formattext.js",
	FlipPanelAnimation = "file://{resources}/scripts/common/flip_panel_anim.js",
	EventUtil = "file://{resources}/scripts/common/eventutil.js",
	TeamColor = "file://{resources}/scripts/common/teamcolor.js",
	ItemInfo = "file://{resources}/scripts/common/iteminfo.js",
	OperationUtil = "file://{resources}/scripts/operation/operation_util.js",
	CharacterAnims = "file://{resources}/scripts/common/characteranims.js",
	OperationMissionCard = "file://{resources}/scripts/operation/operation_mission_card.js",
	Scheduler = "file://{resources}/scripts/common/scheduler.js",
	MockAdapter = "file://{resources}/scripts/mock_adapter.js",
	LicenseUtil = "file://{resources}/scripts/common/licenseutil.js",
	Avatar = "file://{resources}/scripts/avatar.js",
	ItemContextEntires = "file://{resources}/scripts/common/item_context_entries.js"
}
local var_0_1 = {}

table.insert(var_0_1, "<root>")
table.insert(var_0_1, "\t<scripts>")

for iter_0_0, iter_0_1 in pairs(var_0_0) do
	table.insert(var_0_1, "\t\t<include src=\"" .. iter_0_1 .. "\"/>")
end

table.insert(var_0_1, "\t</scripts>")
table.insert(var_0_1, "")
table.insert(var_0_1, "\t<script>")

for iter_0_2, iter_0_3 in pairs(var_0_0) do
	table.insert(var_0_1, string.format("\t\t$.GetContextPanel().%s = %s;", iter_0_2, iter_0_2))
end

table.insert(var_0_1, "\t</script>")
table.insert(var_0_1, "")
table.insert(var_0_1, "\t<Panel>")
table.insert(var_0_1, "\t</Panel>")
table.insert(var_0_1, "</root>")

local var_0_2 = table.concat(var_0_1, "\n")
local var_0_3 = "\tlet global_this = this\n\tlet modified_props = {}\n\n\tlet _Create = function(layout, utilities) {\n\t\tlet parent = $.GetContextPanel()\n\t\tif(!parent)\n\t\t\treturn false\n\n\t\tlet panel = $.CreatePanel(\"Panel\", parent, \"\")\n\t\tif(!panel)\n\t\t\treturn false\n\n\t\tif(!panel.BLoadLayoutFromString(layout, false, false))\n\t\t\treturn false\n\n\t\tfor(name in utilities) {\n\t\t\tif(panel[name]) {\n\t\t\t\t// global_this[name] = panel[name]\n\n\t\t\t\tObject.defineProperty(global_this, name, {\n\t\t\t\t\tenumerable: false,\n\t\t\t\t\twritable: false,\n\t\t\t\t\tconfigurable: true,\n\t\t\t\t\tvalue: panel[name]\n\t\t\t\t})\n\n\t\t\t\tmodified_props[name] = true\n\t\t\t}\n\t\t}\n\n\t\tpanel.RemoveAndDeleteChildren()\n\t\tpanel.DeleteAsync(0.0)\n\t}\n\n\tlet _Destroy = function() {\n\t\tfor(key in modified_props) {\n\t\t\tdelete global_this[key];\n\t\t}\n\t\tmodified_props = {}\n\t}\n\n\treturn {\n\t\tcreate: _Create,\n\t\tdestroy: _Destroy\n\t}\n"
local var_0_4 = {}

local function var_0_5(arg_1_0)
	arg_1_0 = arg_1_0 or ""

	if var_0_4[arg_1_0] ~= nil then
		return false
	elseif type(arg_1_0) ~= "string" and arg_1_0:gsub(" ", "") ~= "" then
		return error("invalid context, expected a non-empty string")
	end

	local var_1_0 = arg_1_0 == "" and panorama.loadstring(var_0_3)() or panorama.loadstring(var_0_3, arg_1_0)()

	var_1_0.create(var_0_2, var_0_0)

	var_0_4[arg_1_0] = var_1_0
end

var_0_5()
client.set_event_callback("shutdown", function()
	for iter_2_0, iter_2_1 in pairs(var_0_4) do
		iter_2_1.destroy()
	end
end)

local var_0_6 = {
	"CSGOJsRegistration",
	"CSGOHud",
	"CSGOMainMenu"
}

for iter_0_4 = 1, #var_0_6 do
	var_0_5(var_0_6[iter_0_4])
end

return {
	register_for_context = var_0_5
}
