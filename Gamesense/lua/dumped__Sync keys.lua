slot0 = false
slot1 = {
	[0] = "Always on",
	"On hotkey",
	"Toggle",
	"Off hotkey"
}
slot2 = {
	"Global",
	"G3SG1 / SCAR-20",
	"SSG 08",
	"AWP",
	"R8 Revolver",
	"Desert Eagle",
	"Pistol",
	"Zeus",
	"Rifle",
	"Shotgun",
	"SMG",
	"Machine gun"
}
slot3 = ui.new_checkbox("RAGE", "Other", "Sync keys")
slot4 = ui.reference("RAGE", "Weapon type", "Weapon type")

function slot6()
	uv0 = false
end

function slot7()
	uv0 = true
end

client.set_event_callback("pre_config_load", slot6)
client.set_event_callback("pre_config_save", slot6)
client.set_event_callback("post_config_load", slot7)
client.set_event_callback("post_config_save", slot7)

slot12 = "RAGE"
slot13 = "Aimbot"

for slot12, slot13 in ipairs({
	select(2, ui.reference("RAGE", "Aimbot", "Enabled")),
	select(2, ui.reference("RAGE", "Aimbot", "Multi-point")),
	select(2, ui.reference("RAGE", "Aimbot", "Minimum damage override")),
	select(1, ui.reference("RAGE", "Aimbot", "Force safe point")),
	select(1, ui.reference("RAGE", "Aimbot", "Force body aim")),
	select(2, ui.reference("RAGE", "Aimbot", "Quick stop")),
	select(2, ui.reference(slot12, slot13, "Double tap"))
}) do
	if ui.type(slot13) == "hotkey" then
		ui.set_callback(slot13, function (slot0)
			if uv0 and ui.get(uv1) then
				slot1, slot2, slot3 = ui.get(slot0)

				if slot3 == nil then
					slot3 = 0
				end

				slot4 = ui.get(uv3)

				for slot8, slot9 in ipairs(uv4) do
					ui.set(uv3, slot9)
					ui.set(slot0, uv2[slot2])
					ui.set(slot0, nil, slot3)
				end

				ui.set(uv3, slot4)
			end
		end)
	else
		print("invalid hotkey: ", slot12, " ", slot13)
	end
end

slot0 = true
