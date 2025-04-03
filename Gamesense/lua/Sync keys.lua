local var_0_0 = false
local var_0_1 = {
	[0] = "Always on",
	"On hotkey",
	"Toggle",
	"Off hotkey"
}
local var_0_2 = {
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
local var_0_3 = ui.new_checkbox("RAGE", "Other", "Sync keys")
local var_0_4 = ui.reference("RAGE", "Weapon type", "Weapon type")

local function var_0_5(arg_1_0)
	if var_0_0 and ui.get(var_0_3) then
		local var_1_0, var_1_1, var_1_2 = ui.get(arg_1_0)

		if var_1_2 == nil then
			var_1_2 = 0
		end

		local var_1_3 = var_0_1[var_1_1]
		local var_1_4 = ui.get(var_0_4)

		for iter_1_0, iter_1_1 in ipairs(var_0_2) do
			ui.set(var_0_4, iter_1_1)
			ui.set(arg_1_0, var_1_3)
			ui.set(arg_1_0, nil, var_1_2)
		end

		ui.set(var_0_4, var_1_4)
	end
end

local function var_0_6()
	var_0_0 = false
end

local function var_0_7()
	var_0_0 = true
end

client.set_event_callback("pre_config_load", var_0_6)
client.set_event_callback("pre_config_save", var_0_6)
client.set_event_callback("post_config_load", var_0_7)
client.set_event_callback("post_config_save", var_0_7)

local var_0_8 = {
	select(2, ui.reference("RAGE", "Aimbot", "Enabled")),
	select(2, ui.reference("RAGE", "Aimbot", "Multi-point")),
	select(2, ui.reference("RAGE", "Aimbot", "Minimum damage override")),
	select(1, ui.reference("RAGE", "Aimbot", "Force safe point")),
	select(1, ui.reference("RAGE", "Aimbot", "Force body aim")),
	select(2, ui.reference("RAGE", "Aimbot", "Quick stop")),
	(select(2, ui.reference("RAGE", "Aimbot", "Double tap")))
}

for iter_0_0, iter_0_1 in ipairs(var_0_8) do
	if ui.type(iter_0_1) == "hotkey" then
		ui.set_callback(iter_0_1, var_0_5)
	else
		print("invalid hotkey: ", iter_0_0, " ", iter_0_1)
	end
end

var_0_0 = true
