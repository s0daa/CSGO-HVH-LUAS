local var_0_0 = client.delay_call
local var_0_1 = client.set_event_callback
local var_0_2 = client.userid_to_entindex
local var_0_3 = entity.get_local_player
local var_0_4 = materialsystem.find_materials
local var_0_5 = pairs
local var_0_6 = table.insert
local var_0_7 = table.sort
local var_0_8 = ui.get
local var_0_9 = ui.new_checkbox
local var_0_10 = ui.new_color_picker
local var_0_11 = ui.new_listbox
local var_0_12 = ui.set_callback
local var_0_13 = ui.set_visible
local var_0_14 = type
local var_0_15 = package.searchpath

local function var_0_16(arg_1_0)
	return var_0_15("", arg_1_0) == arg_1_0
end

local function var_0_17(arg_2_0)
	return var_0_16("./csgo/materials/skybox/" .. arg_2_0 .. "up.vmt")
end

local var_0_18 = cvar.sv_skyname
local var_0_19 = {
	["Custom: Ocean"] = "dreamyocean",
	["Custom: Galaxy (2)"] = "clear_night_sky",
	Italy = "italy",
	["Custom: Galaxy"] = "sky_descent",
	Monastery = "embassy",
	["Custom: Sunrise"] = "amethyst",
	Baggage = "cs_baggage_skybox_",
	Rainy = "vietnam",
	Dusty = "sky_dust",
	["Night (Flat)"] = "sky_csgo_night_flat",
	["Night (2)"] = "sky_csgo_night02b",
	Night = "sky_csgo_night02",
	["Clouds (Dark)"] = "sky_csgo_cloudy01",
	Assault = "sky_cs15_daylight04_hdr",
	Cobblestone = "sky_cs15_daylight03_hdr",
	Canals = "sky_venice",
	Clear = "nukeblank",
	Gray = "sky_day02_05_hdr",
	["Clouds (2)"] = "vertigo",
	Clouds = "sky_cs15_daylight02_hdr",
	["Daylight (2)"] = "vertigoblue_hdr",
	Daylight = "sky_cs15_daylight01_hdr",
	Vertigo = "office",
	Aztec = "jungle",
	["Custom: Night (Blue)"] = "sky561",
	["Custom: Clouds"] = "sky091",
	["Custom: Heaven (2)"] = "sky081",
	["Custom: Heaven"] = "sky051",
	["Custom: Grimm Night"] = "grimmnight",
	Tibet = "cs_tibet",
	["Custom: Clouds (Night)"] = "cloudynight",
	["Custom: Galaxy (4)"] = "mpa112",
	["Custom: Galaxy (3)"] = "otherworld"
}
local var_0_20 = {}

for iter_0_0, iter_0_1 in var_0_5(var_0_19) do
	if iter_0_0:sub(0, 8) ~= "Custom: " or var_0_17(iter_0_1) then
		var_0_6(var_0_20, iter_0_0)
	end
end

var_0_7(var_0_20)

local var_0_21 = var_0_9("VISUALS", "Effects", "Override skybox")
local var_0_22 = var_0_10("VISUALS", "Effects", "Override skybox", 255, 255, 255, 255)
local var_0_23 = var_0_11("VISUALS", "Effects", "Override skybox name", var_0_20)
local var_0_24 = false
local var_0_25

local function var_0_26()
	local var_3_0 = var_0_8(var_0_21)

	if var_3_0 or var_0_24 then
		local var_3_1, var_3_2, var_3_3, var_3_4 = var_0_8(var_0_22)

		if not var_3_0 then
			var_3_1, var_3_2, var_3_3, var_3_4 = 255, 255, 255, 255
		end

		local var_3_5 = var_0_4("skybox/")

		for iter_3_0 = 1, #var_3_5 do
			var_3_5[iter_3_0]:color_modulate(var_3_1, var_3_2, var_3_3)
			var_3_5[iter_3_0]:alpha_modulate(var_3_4)
		end
	end
end

var_0_12(var_0_22, var_0_26)

local function var_0_27()
	local var_4_0 = var_0_8(var_0_21)

	var_0_13(var_0_23, var_4_0)

	if var_4_0 then
		local var_4_1 = var_0_8(var_0_23)

		if var_0_14(var_4_1) == "number" then
			var_4_1 = var_0_20[var_4_1 + 1]
		end

		if var_0_25 == nil then
			var_0_25 = var_0_18:get_string()
		end

		var_0_18:set_string(var_0_19[var_4_1])

		if #var_0_4("skybox/" .. var_4_1) == 0 then
			var_0_0(0.2, var_0_26)
		else
			var_0_26()
		end
	elseif var_0_24 and var_0_25 ~= nil then
		var_0_18:set_string(var_0_25)
	end

	var_0_26()

	var_0_24 = var_4_0
end

var_0_12(var_0_21, var_0_27)
var_0_12(var_0_23, var_0_27)
var_0_27()

local function var_0_28(arg_5_0)
	if var_0_2(arg_5_0.userid) == var_0_3() then
		var_0_25 = nil

		var_0_27()
		var_0_26()
	end
end

var_0_1("player_connect_full", var_0_28)

local function var_0_29()
	if var_0_25 ~= nil and var_0_8(var_0_21) then
		var_0_18:set_string(var_0_25)
	end
end

var_0_1("shutdown", var_0_29)
