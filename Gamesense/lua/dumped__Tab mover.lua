slot0 = config.load
slot1 = ui.get
slot2 = ui.new_button
slot3 = ui.new_multiselect
slot4 = ui.new_label
slot5 = ui.new_textbox
slot6, slot7, slot8, slot9 = nil

function slot10()
	for slot5 = 1, #uv0(uv1) do
		uv3(uv0(uv2), slot0[slot5])
	end
end

function ()
	uv0 = uv1("CONFIG", "Presets", "Tab mover")
	uv2 = uv3("CONFIG", "Presets", "Config name")
	uv4 = uv5("CONFIG", "Presets", "\nTab", "Rage", "AA", "Legit", "Visuals", "Misc", "Skins")
	uv6 = uv7("CONFIG", "Presets", "Load tab", uv8)
end()
