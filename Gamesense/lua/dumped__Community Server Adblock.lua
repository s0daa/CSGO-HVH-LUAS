slot0 = require("ffi")
slot2 = require("gamesense/string_tables")
slot4 = vtable_bind("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")
slot5 = vtable_thunk(1, "const char*(__thiscall*)(void*)")

function slot6()
	if uv0() == nil then
		return
	end

	if uv1(slot0) ~= nil then
		return uv2.string(slot1)
	end
end

slot13 = slot0.new("uint64_t[1]")

vtable_thunk(2, "void(__thiscall*)(void*, uint64_t*)")(vtable_bind("steamclient.dll", "SteamClient017", 5, "int*(__thiscall*)(void*, int, int, const char*)")(1, 1, "SteamUser021"), slot13)

slot13 = tostring(slot13[0]):sub(1, 17)
slot14 = slot0.string(vtable_thunk(0, "const char *(__thiscall*)(void*)")(vtable_bind("steamclient.dll", "SteamClient020", 8, "int*(__thiscall*)(void*, int, int, const char *)")(1, 1, "SteamFriends017")))
slot15 = slot0.cast("void***", slot0.cast("char*", client.find_signature("client.dll", "3\\xc0f\\x89\\x87\\xcc\\xcc\\xcc̋\r") or error("ViewRender signature outdated")) + 11)[0][0]
slot16 = vtable_thunk(20, "void(__thiscall*)(void*, void*)")
slot17 = vtable_thunk(21, "void*(__thiscall*)(void*)")
slot20 = slot0.cast("void***(__thiscall*)(void*, const char*)", client.find_signature("client.dll", "U\\x8b\\xecS\\x8b]VW\\x8b\\xf93\\xf69w("))(slot0.cast("void**", slot0.cast("char*", client.find_signature("client.dll", "\\xb9\\xcc\\xcc\\xcc̈F\t") or error("HUD signature outdated")) + 1)[0], "CHudMessage") or error("Couldn't find CHudMessage")
slot23 = slot0.cast("bool*", slot0.cast("void*", slot0.cast("char*", slot20) + 13))
slot0.cast("void**", slot0.cast("char*", slot20) + 60)[0] = slot18
slot0.cast("short*", slot0.cast("char*", slot20) + 4)[0] = 1

client.set_event_callback("paint", function ()
	uv0[0] = true
end)

slot24 = panorama.loadstring([[
	return {
		update: function(enabled) {
			let server_sponsor_logos = $.GetContextPanel().FindChildTraverse("ServerSponserLogos")
			if(server_sponsor_logos) {
				server_sponsor_logos.style.height = enabled ? "0px" : null;
			}
		}
	}
]], "CSGOHud")()
slot25 = {}
slot26 = {}
slot27, slot28, slot29 = nil

function slot30(slot0)
	uv0.update(slot0)

	if uv1 ~= nil then
		uv2[0] = uv1
		uv1 = nil
	end

	uv3[0] = true
end

slot31 = 2

function slot32()
	uv0 = uv1(uv2)

	if uv0 ~= nil then
		uv3(uv2, nil)
	end

	if uv4 ~= nil then
		uv5[0] = uv4
		uv4 = nil
	end

	uv6[0] = true

	if uv7.decalprecache ~= nil then
		if #slot0 ~= uv8 then
			for slot4, slot5 in ipairs(slot0) do
				if readfile("csgo/materials/" .. slot5 .. ".vmt") ~= nil and materialsystem.find_material(slot5) ~= nil then
					slot7:set_material_var_flag(uv9, true)
				end
			end

			uv8 = #slot0
		end
	else
		uv8 = nil
	end
end

function slot33()
	if uv0 ~= nil then
		uv1(uv2, uv0)

		uv0 = nil
	end

	uv3[0] = nil
	uv4[0] = true
end

function slot34()
	uv0(ui.get(uv1))
end

function slot35()
	uv0(false)
end

ui.set_callback(ui.new_checkbox("MISC", "Miscellaneous", "Block server advertisements"), function ()
	slot0 = ui.get(uv0)

	uv1(slot0)

	if slot0 then
		client.set_event_callback("pre_render", uv2)
		client.set_event_callback("post_render", uv3)
		client.set_event_callback("level_init", uv4)
		client.set_event_callback("player_death", uv4)
		client.set_event_callback("shutdown", uv5)
	else
		client.unset_event_callback("pre_render", uv2)
		client.unset_event_callback("post_render", uv3)
		client.unset_event_callback("level_init", uv4)
		client.unset_event_callback("player_death", uv4)
		client.unset_event_callback("shutdown", uv5)
	end
end)

slot36 = require("gamesense/http").get
slot37 = json.null

client.set_event_callback("paint_ui", function ()
	if uv0() ~= uv1 then
		uv1 = slot0

		table.clear(uv2)
		table.clear(uv3)
		uv4("https://sapphyr.us/adblock/v1/server_data", {
			params = {
				server_address = slot0,
				name = uv5,
				id = uv6
			}
		}, function (slot0, slot1)
			if slot0 == 200 and json.parse(slot1) ~= nil then
				uv0 = slot2.chat_patterns
				uv1 = slot2.panorama_ids
			end
		end)
	end
end)
