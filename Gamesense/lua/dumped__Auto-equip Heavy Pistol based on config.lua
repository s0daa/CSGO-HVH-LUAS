slot0 = require("gamesense/csgo_weapons")
slot1 = panorama.open()
slot2 = slot1.LoadoutAPI
slot3 = slot1.InventoryAPI
slot4 = {
	["Desert Eagle"] = slot0.weapon_deagle.idx,
	["R8 Revolver"] = slot0.weapon_revolver.idx
}
slot5 = {
	"ct",
	"t"
}

function slot6(slot0, slot1)
	return uv0.GetItemDefinitionIndex(uv1.GetItemID(slot1, uv0.GetSlotSubPosition(uv0.GetFauxItemIDFromDefAndPaintIndex(slot0))))
end

function slot7(slot0, slot1)
	slot2 = uv0.GetFauxItemIDFromDefAndPaintIndex(slot0)

	uv1.EquipItemInSlot(slot1, slot2, uv0.GetSlotSubPosition(slot2))
end

ui.set_callback(ui.new_combobox("MISC", "Miscellaneous", "Auto-equip Heavy Pistol", {
	"Off",
	"Desert Eagle",
	"R8 Revolver"
}), function ()
	if uv0[ui.get(uv1)] ~= nil then
		for slot4, slot5 in ipairs(uv2) do
			if uv3(slot0, slot5) ~= slot0 then
				uv4(slot0, slot5)
			end
		end
	end
end)
