slot0 = panorama.open()
slot1 = slot0.GameStateAPI
slot2 = slot0.FriendsListAPI
slot3 = {
	"А",
	"Б",
	"В",
	"Г",
	"Д",
	"Е",
	"Ё",
	"Ж",
	"З",
	"И",
	"Й",
	"К",
	"Л",
	"М",
	"Н",
	"О",
	"П",
	"Р",
	"С",
	"Т",
	"У",
	"Ф",
	"Х",
	"Ц",
	"Ч",
	"Ш",
	"Щ",
	"Ъ",
	"Ы",
	"Ь",
	"Э",
	"Ю",
	"Я",
	"а",
	"б",
	"в",
	"г",
	"д",
	"е",
	"ё",
	"ж",
	"з",
	"и",
	"й",
	"к",
	"л",
	"м",
	"н",
	"о",
	"п",
	"р",
	"с",
	"т",
	"ф",
	"х",
	"ц",
	"ч",
	"ш",
	"щ",
	"ъ",
	"ы",
	"ь",
	"э",
	"ю",
	"я"
}
slot4 = ui.new_multiselect("lua", "a", "If cyrillic is found:", "Mute", "Report")

function slot5(slot0, slot1)
	for slot5 = 1, #slot0 do
		if slot0[slot5] == slot1 then
			return true
		end
	end

	return false
end

function slot6(slot0, slot1)
	if uv0(ui.get(uv1), "Report") then
		uv2.SubmitPlayerReport(slot0, "textabuse, voiceabuse")
		print("Enemy reported, " .. slot1 .. " " .. slot0)
	elseif uv0(ui.get(uv1), "Mute") then
		uv3.ToggleMute(slot0)
		print("Enemy muted, " .. slot1 .. " " .. slot0)
	end
end

client.set_event_callback("player_chat", function (slot0)
	if slot0.entity == entity.get_local_player() then
		return
	end

	for slot4, slot5 in pairs(uv0) do
		if string.find(slot0.text, uv0[slot4]) then
			uv2(uv1.GetPlayerXuidStringFromEntIndex(slot0.entity), slot0.name)
		end
	end
end)
