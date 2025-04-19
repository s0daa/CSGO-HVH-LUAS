slot0 = client.delay_call
slot2 = globals.realtime
slot4 = error
slot5 = print
slot6 = require("ffi")
slot7 = require("gamesense/uix")
slot8 = panorama.open()
slot9 = 0
slot10, slot11 = nil
slot16 = slot6.cast("uintptr_t***", slot6.cast("uintptr_t", client.find_signature("engine.dll", "\\x8b\r\\xcc\\xcc\\xcc̅\\xc9t\\x8b\\x8b") or slot4("Invalid signature #1")) + 2)[0][0] + 2
slot17 = slot6.cast("int(__stdcall*)(uintptr_t, int)", slot1("gameoverlayrenderer.dll", "U\\x8b\\xec\\x83\\xec\\x8bE\\xf7") or slot4("Invalid signature #2"))
slot18 = slot6.cast("int(__thiscall*)(uintptr_t)", slot1("gameoverlayrenderer.dll", "\\xff\\xe1") or slot4("Invalid signature #3"))
slot19 = slot6.cast("uintptr_t**", slot6.cast("uintptr_t", slot1("gameoverlayrenderer.dll", "\\xff\\xcc\\xcc\\xcc\\xcc;\\xc6t") or slot4("Invalid signature #4")) + 2)[0][0]

function slot20()
	return uv0[0]
end

function slot21()
	return uv0(uv1)
end

function slot22()
	if uv1() ~= uv0() then
		uv2(slot0, 1)

		return true
	end

	return false
end

slot10 = slot7.new_checkbox("LUA", "A", "Notify on match found")

slot10:on("paint_ui", function ()
	if uv1 <= uv0() then
		if uv2.PartyListAPI.GetPartySessionSetting("game/mmqueue") == "reserved" then
			uv3()
		end

		uv1 = uv0() + 1
	end
end)
slot10:set(true)

slot11 = slot7.new_checkbox("LUA", "A", "Notify on round start")

slot11:on("round_start", function ()
	if uv0() then
		uv1(1, uv2)
	end
end)
slot11:set(true)
