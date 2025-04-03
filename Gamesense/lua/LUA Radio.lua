local var_0_0 = 15
local var_0_1 = {
	"Hits",
	"House",
	"Techno",
	"Metal",
	"Rap",
	"Deep House",
	"Pop",
	"8bit",
	"Lo-Fi",
	"Ibiza"
}
local var_0_2 = {
	"http://air.radiorecord.ru:805/dc_320",
	"http://uk7.internet-radio.com:8000/stream",
	"https://www.internet-radio.com/player/?mount=http://uk1.internet-radio.com:8200/live.m3u&title=Phever%20Media%20Live%20Audio%20Stream&website=www.phever.ie",
	"https://www.internet-radio.com/player/?mount=http://uk1.internet-radio.com:8294/live.m3u&title=Radio%20Bloodstream&website=http://www.RadioBloodstream.com",
	"https://www.internet-radio.com/player/?mount=http://us4.internet-radio.com:8107/listen.pls&title=kmjt98.6%20Radio&website=https://www.internet-radio.com",
	"https://www.internet-radio.com/player/?mount=http://uk7.internet-radio.com:8000/listen.pls&title=MoveDaHouse&website=http://www.movedahouse.com",
	"http://air.radiorecord.ru:805/dc_320",
	"https://icecast.z8r.de/radiosven-lofi-ogg",
	"http://playerservices.streamtheworld.com/api/livestream-redirect/TLPSTR19.mp3"
}
local var_0_3 = ui.new_combobox("LUA", "a", "Choose active radio indicator", {
	"No indicator",
	"Static",
	"Breathing",
	"Flashing"
})
local var_0_4 = ui.new_combobox("LUA", "a", "Choose radio", var_0_1)

function OpenMusic()
	local var_1_0

	for iter_1_0, iter_1_1 in next, var_0_1 do
		if iter_1_1 == ui.get(var_0_4) then
			var_1_0 = iter_1_0
		end
	end

	panorama.loadstring("\t\treturn {\n\t\t  open_url: function(url){\n\t\t\tSteamOverlayAPI.OpenURL(url)\n\t\t  }\n\t\t}\n\t\t")().open_url(var_0_2[var_1_0])
end

local function var_0_5(arg_2_0, arg_2_1)
	arg_2_0 = arg_2_0 * var_0_0

	while arg_2_1 < arg_2_0 do
		arg_2_0 = arg_2_1 - arg_2_0
	end

	return arg_2_0
end

function OnDraw()
	local var_3_0 = ui.get(var_0_3)
	local var_3_1 = ui.get(var_0_4)

	if var_3_0 == "No indicator" then
		-- block empty
	elseif var_3_0 == "Static" then
		renderer.indicator(0, 255, 255, 255, var_3_1)
	elseif var_3_0 == "Breathing" then
		R, G, B = math.floor(math.sin((globals.curtime() + 0.7) * 4 + 4) * 127 + 128), 255, math.floor(math.sin((globals.curtime() + 0.7) * 4 + 4) * 127 + 128)

		renderer.indicator(0, R, G, B, var_3_1)
	elseif var_3_0 == "Flashing" then
		local var_3_2 = 510 / var_0_0

		R, G, B = var_0_5(globals.tickcount() % var_3_2, 255), 255, var_0_5(globals.tickcount() % var_3_2, 255)

		renderer.indicator(0, R, G, B, var_3_1)
	end
end

client.set_event_callback("paint", OnDraw)
ui.new_button("LUA", "a", "Start Radio", OpenMusic)
