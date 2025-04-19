local utilities = {
	CharacterAnims = "file://{resources}/scripts/common/characteranims.js",
	ItemInfo = "file://{resources}/scripts/common/iteminfo.js",
	EventUtil = "file://{resources}/scripts/common/eventutil.js",
	FormatText = "file://{resources}/scripts/common/formattext.js",
	IconUtil = "file://{resources}/scripts/common/icon.js",
	ItemContextEntires = "file://{resources}/scripts/common/item_context_entries.js",
	LicenseUtil = "file://{resources}/scripts/common/licenseutil.js",
	Scheduler = "file://{resources}/scripts/common/scheduler.js",
	SessionUtil = "file://{resources}/scripts/common/sessionutil.js",
	FlipPanelAnimation = "file://{resources}/scripts/common/flip_panel_anim.js",
	TeamColor = "file://{resources}/scripts/common/teamcolor.js",
	OperationUtil = "file://{resources}/scripts/operation/operation_util.js",
	OperationMissionCard = "file://{resources}/scripts/operation/operation_mission_card.js",
	MockAdapter = "file://{resources}/scripts/mock_adapter.js",
	Avatar = "file://{resources}/scripts/avatar.js",
}

local layout = {}

table.insert(layout, "<root>")
table.insert(layout, "\t<scripts>")
for name, script in pairs(utilities) do
	table.insert(layout, "\t\t<include src=\"" .. script .. "\"/>")
end
table.insert(layout, "\t</scripts>")
table.insert(layout, "")
table.insert(layout, "\t<script>")
for name, script in pairs(utilities) do
	table.insert(layout, string.format("\t\t$.GetContextPanel().%s = %s;", name, name))
end
table.insert(layout, "\t</script>")
table.insert(layout, "")
table.insert(layout, "\t<Panel>")
table.insert(layout, "\t</Panel>")
table.insert(layout, "</root>")

layout = table.concat(layout, "\n")

local js_code = [[
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

-- save context name -> context here
local js_contexts = {}

local function register_for_context(context_name)
	context_name = context_name or ""

	if js_contexts[context_name] ~= nil then
		return false
	elseif type(context_name) ~= "string" and context_name:gsub(" ", "") ~= "" then
		return error("invalid context, expected a non-empty string")
	end

	local js = context_name == "" and panorama.loadstring(js_code)() or panorama.loadstring(js_code, context_name)()

	js.create(layout, utilities)
	js_contexts[context_name] = js
end
register_for_context()

client.set_event_callback("shutdown", function()
	for name, context in pairs(js_contexts) do
		context.destroy()
	end
end)

-- always register for some contexts
local root_panel_names = {"CSGOJsRegistration", "CSGOHud", "CSGOMainMenu"}

for i=1, #root_panel_names do
	register_for_context(root_panel_names[i])
end

-- give user a function to register it for other contexts
return {
	register_for_context = register_for_context
}