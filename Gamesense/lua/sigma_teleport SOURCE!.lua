slot0 = bit.lshift(1, 11)
slot1 = 0.3
slot2 = require("gamesense/csgo_weapons")
slot3 = client.screen_size
slot4 = renderer.text
slot5 = {
    client.screen_size()
}
slot6 = {
    slot5[1] / 2,
    slot5[2] / 2
}
slot7 = ui.new_hotkey("AA", "Other", "Far Teleport")
slot8 = ui.new_hotkey("AA", "Other", "Far Teleport When Hittable")
slot9, slot10, slot11 = ui.reference("RAGE", "Aimbot", "Double tap")
slot12, slot13 = ui.reference("RAGE", "Other", "Quick peek assist")
slot14, slot15 = nil

function slot16()
    uv1 = nil
    uv0 = nil
end

slot16()

slot17 = nil

client.set_event_callback("run_command", function (slot0)
    uv0 = slot0.command_number
end)
client.set_event_callback("predict_command", function (slot0)
    if slot0.command_number == uv0 then
        uv0 = nil
        slot1 = entity.get_prop(entity.get_local_player(), "m_nTickBase")

        if uv1 ~= nil then
            uv2 = slot1 - uv1
        end

        uv1 = math.max(slot1, uv1 or 0)
    end
end)
client.set_event_callback("level_init", slot16)

slot18 = false
slot19 = nil

client.set_event_callback("setup_command", function (slot0)
    if not ui.get(uv0) or not ui.get(uv1) or ui.get(uv2) ~= "Defensive" then
        uv4 = false
        uv3 = false

        return
    end

    if not uv3 and (slot0.in_forward == 1 or slot0.in_back == 1 or slot0.in_moveleft == 1 or slot0.in_moveright == 1 or slot0.in_jump == 1) then
        uv3 = ui.get(uv5)

        if not uv3 and ui.get(uv6) then
            for slot4, slot5 in ipairs(entity.get_players(true)) do
                if bit.band(entity.get_esp_data(slot5).flags or 0, uv7) ~= 0 then
                    uv3 = true

                    break
                end
            end
        end
    end

    if uv3 then
        slot0.force_defensive = true

        if uv8 >= 14 then
            uv4 = true
        end

        if uv4 and uv8 == 0 or uv9(entity.get_player_weapon(entity.get_local_player())).type == "grenade" then
            ui.set(uv0, false)
            client.delay_call(uv10, ui.set, uv0, true)

            uv3 = false
            uv4 = false
        end

        return
    end
end)
client.set_event_callback("paint", function ()
    if uv0 then
        renderer.indicator(143, 194, 21, 255, "+/- MAXIMIZING TELEPORT DISTANCE")
        renderer.text(uv1[1] - 1206, 772, 143, 207, 219, 255, "-c", 0, "+/- MAXIMIZING TELEPORT DISTANCE")
    elseif ui.get(uv2) or ui.get(uv3) then
        if uv4 then
            renderer.indicator(255, 0, 50, 255, slot0)
        else
            renderer.indicator(255, 255, 255, 255, slot0)
        end
    end
end)
client.set_event_callback("setup_command", function (slot0)
    if slot0.weaponselect ~= 0 then
        slot0.force_defensive = 1
    end
end)