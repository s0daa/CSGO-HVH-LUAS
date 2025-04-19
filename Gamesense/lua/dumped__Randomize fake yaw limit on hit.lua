slot0 = require("gamesense/uix")
slot1 = client
slot2 = entity
slot3 = ui
slot4 = slot1.userid_to_entindex
slot5 = slot1.set_event_callback
slot6 = slot1.random_int
slot7 = slot1.unset_event_callback
slot8 = slot2.get_local_player
slot9 = slot2.is_enemy
slot10 = slot3.set
slot11 = slot3.get
slot12 = slot3.reference
slot13 = slot3.new_checkbox
slot14, slot15 = nil

function slot16(slot0)
	if uv0(slot0.userid) == uv1() and uv2(uv0(slot0.attacker)) then
		uv3(uv4, uv5(0, 60))
	end
end

function ()
	uv0 = uv1.new_checkbox("AA", "Anti-aimbot angles", "Randomize fake yaw limit")
	uv2 = uv3("AA", "Anti-aimbot angles", "Fake yaw limit")

	uv0:on("player_hurt", uv4)
end()
