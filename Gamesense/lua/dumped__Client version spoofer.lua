slot0 = require("ffi")
slot1 = require("gamesense/http")
slot3 = panorama.open()
slot4 = slot3.NewsAPI
slot5 = slot3.GameStateAPI
slot6 = 0
slot7 = false
slot8 = slot0.cast("uint32_t**", slot0.cast("char*", client.find_signature("engine.dll", "\\xff5\\xcc\\xcc\\xcc̍L$")) + 2)[0][0]

function slot9()
	if uv0 then
		return
	end

	uv1.get("https://api.steampowered.com/ISteamApps/UpToDateCheck/v1/?appid=730&version=" .. uv2, function (slot0, slot1)
		if not slot0 or slot1.status ~= 200 then
			return
		end

		if json.parse(slot1.body).response.required_version ~= nil then
			uv0.cast("uint32_t**", uv0.cast("char*", client.find_signature("engine.dll", "\\xff5\\xcc\\xcc\\xcc̍L$")) + 2)[0][0] = slot2.response.required_version
		end
	end)
end

function slot10()
	slot1 = 1048576
	slot2 = uv0.typeof("char[$]", slot1)()

	vtable_bind("vstdlib.dll", "VEngineCvar007", 35, "void(__thiscall*)(void*, int, char*, unsigned int)")(0, slot2, slot1)

	return uv0.string(slot2)
end

function slot11()
	client.exec("clear")

	uv0 = true
	slot0 = 0

	client.delay_call(0.5, function ()
		if not uv0():match("server version (.+)") then
			return
		end

		uv1 = slot0:gsub("\n(.+)", "") + 0
		uv2.cast("uint32_t**", uv2.cast("char*", client.find_signature("engine.dll", "\\xff5\\xcc\\xcc\\xcc̍L$")) + 2)[0][0] = uv1

		client.exec("retry")
	end)
	client.delay_call(2, function ()
		if uv0():match("Connected to (.+)") and uv1 ~= 0 then
			uv2 = false
			uv3 = uv1

			uv4()
		end
	end)
end

client.set_event_callback("paint_ui", function ()
	if (globals.mapname() ~= nil or uv0.IsConnectedOrConnectingToServer()) and not entity.get_local_player() then
		if uv1 == 0 then
			uv2()

			uv1 = 1
		end
	else
		uv1 = 0
	end
end)
client.set_event_callback("cs_win_panel_match", slot9)
require("gamesense/panorama_events").register_event("CSGOShowMainMenu", slot9)
slot9()
