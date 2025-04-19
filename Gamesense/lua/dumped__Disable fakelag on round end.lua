slot0 = ui.get
slot1 = ui.set
slot2 = ui.new_checkbox("aa", "fake lag", "Disable fake lag on round end")
slot3 = ui.reference("aa", "fake lag", "enabled")

client.set_event_callback("round_start", function (slot0)
	if uv0(uv1) then
		uv2(uv3, true)
	end
end)
client.set_event_callback("round_end", function (slot0)
	if uv0(uv1) then
		uv2(uv3, false)
	end
end)
