slot0 = require("gamesense/uix")
slot1 = client.exec
slot2 = client.system_time
slot3 = client.userid_to_entindex
slot4 = entity.get_local_player
slot5 = entity.get_player_name
slot6 = entity.get_prop
slot7 = string.format
slot8 = ui.get
slot9 = ui.new_checkbox
slot10 = ui.new_textbox
slot11 = ui.set_callback
slot12 = ui.set_visible
slot13, slot14 = nil
slot15 = {}

function slot16(slot0)
	if uv0(slot0.attacker) == uv1() then
		slot1 = uv2(uv3)

		for slot5, slot6 in pairs(uv4) do
			if slot1:find(slot5) then
				slot1 = slot1:gsub(slot5, slot6(slot0))
			end
		end

		uv5("say ", slot1)
	end
end

function slot17(slot0)
	uv1(uv2, uv0(slot0))
end

function slot18(slot0, slot1)
	uv0[slot0] = slot1
end

function ()
	uv0("$victim", function (slot0)
		return uv0(uv1(slot0.userid))
	end)
	uv0("$attacker", function (slot0)
		return uv0(uv1(slot0.attacker))
	end)
	uv0("$weapon", function (slot0)
		return slot0.weapon
	end)
	uv0("$location", function (slot0)
		return uv0(uv1(slot0.userid), "m_szLastPlaceName")
	end)
	uv0("$time", function ()
		return uv0("%d:%02d:%02d", uv1())
	end)

	uv6 = uv7.new_checkbox("LUA", "B", "Kill message")
	uv8 = uv9("LUA", "B", "Message text")

	uv6:on("change", uv10)
	uv6:on("player_death", uv11)
end()
