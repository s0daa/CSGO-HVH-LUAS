slot1 = entity.is_enemy
slot2 = plist.get

client.register_esp_flag("FAKE", 255, 255, 255, function (slot0)
	if uv0(slot0) then
		return uv1(slot0, "Correction active")
	end
end)
