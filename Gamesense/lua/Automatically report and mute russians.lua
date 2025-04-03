local var_0_0 = panorama.open()
local var_0_1 = var_0_0.GameStateAPI
local var_0_2 = var_0_0.FriendsListAPI
local var_0_3 = {
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
local var_0_4 = ui.new_multiselect("lua", "a", "If cyrillic is found:", "Mute", "Report")

local function var_0_5(arg_1_0, arg_1_1)
	for iter_1_0 = 1, #arg_1_0 do
		if arg_1_0[iter_1_0] == arg_1_1 then
			return true
		end
	end

	return false
end

local function var_0_6(arg_2_0, arg_2_1)
	if var_0_5(ui.get(var_0_4), "Report") then
		var_0_1.SubmitPlayerReport(arg_2_0, "textabuse, voiceabuse")
		print("Enemy reported, " .. arg_2_1 .. " " .. arg_2_0)
	elseif var_0_5(ui.get(var_0_4), "Mute") then
		var_0_2.ToggleMute(arg_2_0)
		print("Enemy muted, " .. arg_2_1 .. " " .. arg_2_0)
	end
end

client.set_event_callback("player_chat", function(arg_3_0)
	if arg_3_0.entity == entity.get_local_player() then
		return
	end

	for iter_3_0, iter_3_1 in pairs(var_0_3) do
		if string.find(arg_3_0.text, var_0_3[iter_3_0]) then
			local var_3_0 = var_0_1.GetPlayerXuidStringFromEntIndex(arg_3_0.entity)

			var_0_6(var_3_0, arg_3_0.name)
		end
	end
end)
