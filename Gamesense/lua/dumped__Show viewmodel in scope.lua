slot0 = require("gamesense/csgo_weapons")
slot1 = require("table.clear")
slot2 = ui.get
slot3 = {}

function slot4()
	for slot3, slot4 in pairs(uv0) do
		if slot4.raw.hide_view_model_zoomed then
			table.insert(uv1, slot3)

			slot4.raw.hide_view_model_zoomed = false
		end
	end
end

ui.set_callback(ui.new_checkbox("VISUALS", "Effects", "Show viewmodel in scope"), function ()
	if uv0(uv1) then
		uv2()
	else
		uv3()
	end
end)
client.set_event_callback("shutdown", function ()
	for slot3 = 1, #uv0 do
		uv1[uv0[slot3]].raw.hide_view_model_zoomed = true
	end

	uv2(uv0)
end)
