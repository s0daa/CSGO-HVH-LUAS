local var_0_0 = require("gamesense/csgo_weapons")
local var_0_1 = panorama.open()
local var_0_2 = var_0_1.LoadoutAPI
local var_0_3 = var_0_1.InventoryAPI
local var_0_4 = {
	["Desert Eagle"] = var_0_0.weapon_deagle.idx,
	["R8 Revolver"] = var_0_0.weapon_revolver.idx
}
local var_0_5 = {
	"ct",
	"t"
}

local function var_0_6(arg_1_0, arg_1_1)
	local var_1_0 = var_0_3.GetFauxItemIDFromDefAndPaintIndex(arg_1_0)
	local var_1_1 = var_0_3.GetSlotSubPosition(var_1_0)
	local var_1_2 = var_0_2.GetItemID(arg_1_1, var_1_1)

	return var_0_3.GetItemDefinitionIndex(var_1_2)
end

local function var_0_7(arg_2_0, arg_2_1)
	local var_2_0 = var_0_3.GetFauxItemIDFromDefAndPaintIndex(arg_2_0)
	local var_2_1 = var_0_3.GetSlotSubPosition(var_2_0)

	var_0_2.EquipItemInSlot(arg_2_1, var_2_0, var_2_1)
end

local var_0_8 = ui.new_combobox("MISC", "Miscellaneous", "Auto-equip Heavy Pistol", {
	"Off",
	"Desert Eagle",
	"R8 Revolver"
})

ui.set_callback(var_0_8, function()
	local var_3_0 = var_0_4[ui.get(var_0_8)]

	if var_3_0 ~= nil then
		for iter_3_0, iter_3_1 in ipairs(var_0_5) do
			if var_0_6(var_3_0, iter_3_1) ~= var_3_0 then
				var_0_7(var_3_0, iter_3_1)
			end
		end
	end
end)
