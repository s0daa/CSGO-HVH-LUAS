local var_0_0 = config.load
local var_0_1 = ui.get
local var_0_2 = ui.new_button
local var_0_3 = ui.new_multiselect
local var_0_4 = ui.new_label
local var_0_5 = ui.new_textbox
local var_0_6
local var_0_7
local var_0_8
local var_0_9

local function var_0_10()
	local var_1_0 = var_0_1(var_0_8)
	local var_1_1 = var_0_1(var_0_7)

	for iter_1_0 = 1, #var_1_0 do
		var_0_0(var_1_1, var_1_0[iter_1_0])
	end
end

;(function()
	var_0_6 = var_0_4("CONFIG", "Presets", "Tab mover")
	var_0_7 = var_0_5("CONFIG", "Presets", "Config name")
	var_0_8 = var_0_3("CONFIG", "Presets", "\nTab", "Rage", "AA", "Legit", "Visuals", "Misc", "Skins")
	var_0_9 = var_0_2("CONFIG", "Presets", "Load tab", var_0_10)
end)()
