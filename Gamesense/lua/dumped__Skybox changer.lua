slot0 = client.delay_call
slot1 = client.set_event_callback
slot2 = client.userid_to_entindex
slot3 = entity.get_local_player
slot4 = materialsystem.find_materials
slot7 = table.sort
slot8 = ui.get
slot9 = ui.new_checkbox
slot10 = ui.new_color_picker
slot11 = ui.new_listbox
slot12 = ui.set_callback
slot13 = ui.set_visible
slot14 = type
slot15 = package.searchpath

function slot16(slot0)
	return uv0("", slot0) == slot0
end

slot18 = cvar.sv_skyname
slot20 = {}

for slot24, slot25 in pairs({
	["Custom: Night (Blue)"] = "sky561",
	["Custom: Galaxy"] = "sky_descent",
	["Custom: Sunrise"] = "amethyst",
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
	Italy = "italy",
	Monastery = "embassy",
	Baggage = "cs_baggage_skybox_",
	Tibet = "cs_tibet",
	["Custom: Clouds"] = "sky091",
	["Custom: Heaven (2)"] = "sky081",
	["Custom: Heaven"] = "sky051",
	["Custom: Grimm Night"] = "grimmnight",
	["Custom: Ocean"] = "dreamyocean",
	["Custom: Clouds (Night)"] = "cloudynight",
	["Custom: Galaxy (4)"] = "mpa112",
	["Custom: Galaxy (3)"] = "otherworld",
	["Custom: Galaxy (2)"] = "clear_night_sky"
}) do
	if slot24:sub(0, 8) ~= "Custom: " or function (slot0)
		return uv0("./csgo/materials/skybox/" .. slot0 .. "up.vmt")
	end(slot25) then
		table.insert(slot20, slot24)
	end
end

slot7(slot20)

slot24 = false
slot25 = nil

slot12(slot10("VISUALS", "Effects", "Override skybox", 255, 255, 255, 255), function ()
	if uv0(uv1) or uv2 then
		slot1, slot2, slot3, slot4 = uv0(uv3)

		if not slot0 then
			slot4 = 255
			slot3 = 255
			slot2 = 255
			slot1 = 255
		end

		for slot9 = 1, #uv4("skybox/") do
			slot5[slot9]:color_modulate(slot1, slot2, slot3)
			slot5[slot9]:alpha_modulate(slot4)
		end
	end
end)

function slot27()
	slot0 = uv0(uv1)

	uv2(uv3, slot0)

	if slot0 then
		if uv4(uv0(uv3)) == "number" then
			slot1 = uv5[slot1 + 1]
		end

		if uv6 == nil then
			uv6 = uv7:get_string()
		end

		uv7:set_string(uv8[slot1])

		if #uv9("skybox/" .. slot1) == 0 then
			uv10(0.2, uv11)
		else
			uv11()
		end
	elseif uv12 and uv6 ~= nil then
		uv7:set_string(uv6)
	end

	uv11()

	uv12 = slot0
end

slot12(slot9("VISUALS", "Effects", "Override skybox"), slot27)
slot12(slot11("VISUALS", "Effects", "Override skybox name", slot20), slot27)
slot27()
slot1("player_connect_full", function (slot0)
	if uv0(slot0.userid) == uv1() then
		uv2 = nil

		uv3()
		uv4()
	end
end)
slot1("shutdown", function ()
	if uv0 ~= nil and uv1(uv2) then
		uv3:set_string(uv0)
	end
end)
