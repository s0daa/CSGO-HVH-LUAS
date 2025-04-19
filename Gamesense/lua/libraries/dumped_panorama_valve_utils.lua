slot1 = {}

table.insert(slot1, "<root>")
table.insert(slot1, "\t<scripts>")

for slot5, slot6 in pairs({
	SessionUtil = "file://{resources}/scripts/common/sessionutil.js",
	CharacterAnims = "file://{resources}/scripts/common/characteranims.js",
	FlipPanelAnimation = "file://{resources}/scripts/common/flip_panel_anim.js",
	Scheduler = "file://{resources}/scripts/common/scheduler.js",
	TeamColor = "file://{resources}/scripts/common/teamcolor.js",
	LicenseUtil = "file://{resources}/scripts/common/licenseutil.js",
	OperationUtil = "file://{resources}/scripts/operation/operation_util.js",
	ItemContextEntires = "file://{resources}/scripts/common/item_context_entries.js",
	OperationMissionCard = "file://{resources}/scripts/operation/operation_mission_card.js",
	IconUtil = "file://{resources}/scripts/common/icon.js",
	MockAdapter = "file://{resources}/scripts/mock_adapter.js",
	FormatText = "file://{resources}/scripts/common/formattext.js",
	Avatar = "file://{resources}/scripts/avatar.js",
	EventUtil = "file://{resources}/scripts/common/eventutil.js",
	ItemInfo = "file://{resources}/scripts/common/iteminfo.js"
}) do
	table.insert(slot1, "\t\t<include src=\"" .. slot6 .. "\"/>")
end

table.insert(slot1, "\t</scripts>")
table.insert(slot1, "")
table.insert(slot1, "\t<script>")

for slot5, slot6 in pairs(slot0) do
	table.insert(slot1, string.format("\t\t$.GetContextPanel().%s = %s;", slot5, slot5))
end

table.insert(slot1, "\t</script>")
table.insert(slot1, "")
table.insert(slot1, "\t<Panel>")
table.insert(slot1, "\t</Panel>")
table.insert(slot1, "</root>")

slot1 = table.concat(slot1, "\n")
slot2 = [[
	let global_this = this
	let modified_props = {}

	let _Create = function(layout, utilities) {
		let parent = $.GetContextPanel()
		if(!parent)
			return false

		let panel = $.CreatePanel("Panel", parent, "")
		if(!panel)
			return false

		if(!panel.BLoadLayoutFromString(layout, false, false))
			return false

		for(name in utilities) {
			if(panel[name]) {
				// global_this[name] = panel[name]

				Object.defineProperty(global_this, name, {
					enumerable: false,
					writable: false,
					configurable: true,
					value: panel[name]
				})

				modified_props[name] = true
			}
		}

		panel.RemoveAndDeleteChildren()
		panel.DeleteAsync(0.0)
	}

	let _Destroy = function() {
		for(key in modified_props) {
			delete global_this[key];
		}
		modified_props = {}
	}

	return {
		create: _Create,
		destroy: _Destroy
	}
]]
slot3 = {}

function (slot0)
	if uv0[slot0 or ""] ~= nil then
		return false
	elseif type(slot0) ~= "string" and slot0:gsub(" ", "") ~= "" then
		return error("invalid context, expected a non-empty string")
	end

	slot1 = slot0 == "" and panorama.loadstring(uv1)() or panorama.loadstring(uv1, slot0)()

	slot1.create(uv2, uv3)

	uv0[slot0] = slot1
end()
client.set_event_callback("shutdown", function ()
	for slot3, slot4 in pairs(uv0) do
		slot4.destroy()
	end
end)

for slot9 = 1, #{
	"CSGOJsRegistration",
	"CSGOHud",
	"CSGOMainMenu"
} do
	slot4(slot5[slot9])
end

return {
	register_for_context = slot4
}
