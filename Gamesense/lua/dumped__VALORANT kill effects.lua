slot0 = globals.realtime
slot1 = globals.mapname
slot2 = require("ffi")
slot3 = require("gamesense/gif_decoder")
slot4 = require("gamesense/http")
slot6 = {
	ok = 200
}
slot7 = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", ({
	surface = {
		playsound = 82
	}
}).surface.playsound, "void (__thiscall*)(void* ecx, const char* sPath)")
slot9 = "https://aether.moe/gamesense"
slot10 = 6
slot11 = 0
slot12 = 0
slot13 = 0
slot14 = 0
slot15, slot16, slot17 = nil

function on_player_death(slot0)
	if client.userid_to_entindex(slot0.attacker) ~= entity.get_local_player() or slot0.attacker == slot0.userid or uv1 <= uv0 then
		return
	end

	uv0 = uv0 + 1

	uv2(string.format("valorant_%d.wav", uv0))

	uv3 = globals.realtime()
	uv4 = uv3 + uv5[uv0].duration
	uv6, uv7 = client.screen_size()
	uv6 = uv6 / 2
	uv6 = uv6 - uv5[uv0].width / 2
	uv7 = uv7 * 0.9
	uv7 = uv7 - uv5[uv0].height
end

function on_player_spawn(slot0)
	if client.userid_to_entindex(slot0.userid) ~= entity.get_local_player() then
		return
	end

	reset_vars()
end

function on_paint_ui()
	if uv0() < uv1 and uv2() ~= nil then
		slot1 = uv3[uv4]

		slot1:draw(slot0 - uv5, uv6, uv7, slot1.width, slot1.height, 255, 255, 255, 255)
	end
end

function reset_vars()
	uv0 = 0
	uv1 = 0
	uv2 = 0
end

function set_callbacks(slot0)
	slot1 = slot0 and client.set_event_callback or client.unset_event_callback

	slot1("player_death", on_player_death)
	slot1("player_spawn", on_player_spawn)
	slot1("paint_ui", on_paint_ui)

	if slot0 and uv0 == nil then
		if not load_files() then
			uv0 = nil

			ui.set(uv1, false)
			client.error_log("Some assets could not be found. Attempting to retrieve them...")
		else
			client.log("VALORANT assets loaded.")
		end
	end
end

function on_menu_kill_effects_enabled_callback(slot0)
	set_callbacks(ui.get(slot0))
end

function download_file(slot0)
	uv0.get(string.format("%s/%s", uv1, slot0), function (slot0, slot1)
		if not slot0 or slot1.status ~= uv0.ok then
			client.error_log(string.format("Could not retrieve asset \"%s\" from server. Error code: %d", uv1, slot1.status))

			return
		end

		writefile(uv1, slot1.body)

		uv2 = uv2 - 1

		client.log(string.format("Successfully installed asset at path \"%s\".", uv1))

		if uv2 == 0 then
			client.log("VALORANT assets downloaded. Loading them.. this might take a while.")
			client.delay_call(globals.tickinterval(), ui.set, uv3, true)
		end
	end)
end

function check_and_download(slot0)
	if not readfile(slot0) then
		uv0 = uv0 + 1

		download_file(slot0)
	end
end

function load_files()
	uv0 = {}
	uv1 = 0

	for slot3 = 1, uv2 do
		check_and_download(string.format("csgo/sound/valorant_%d.wav", slot3))
		check_and_download(string.format("csgo/materials/valorant_%d.gif", slot3))
	end

	if uv1 == 0 then
		for slot3 = 1, uv2 do
			uv0[slot3] = uv3.load_gif(readfile(string.format("csgo/materials/valorant_%d.gif", slot3)))
		end
	end

	return uv1 == 0
end

ui.set_callback(ui.new_checkbox("VISUALS", "Effects", "VALORANT kill effects"), on_menu_kill_effects_enabled_callback)
