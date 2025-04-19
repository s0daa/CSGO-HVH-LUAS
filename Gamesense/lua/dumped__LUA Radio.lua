slot0 = 15
slot2 = {
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
slot3 = ui.new_combobox("LUA", "a", "Choose active radio indicator", {
	"No indicator",
	"Static",
	"Breathing",
	"Flashing"
})
slot4 = ui.new_combobox("LUA", "a", "Choose radio", {
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
})

function OpenMusic()
	slot0 = nil

	for slot4, slot5 in next, uv0, nil do
		if slot5 == ui.get(uv1) then
			slot0 = slot4
		end
	end

	panorama.loadstring([[
		return {
		  open_url: function(url){
			SteamOverlayAPI.OpenURL(url)
		  }
		}
		]])().open_url(uv2[slot0])
end

function slot5(slot0, slot1)
	slot0 = slot0 * uv0

	while slot1 < slot0 do
		slot0 = slot1 - slot0
	end

	return slot0
end

function OnDraw()
	slot1 = ui.get(uv1)

	if ui.get(uv0) == "No indicator" then
		-- Nothing
	elseif slot0 == "Static" then
		renderer.indicator(0, 255, 255, 255, slot1)
	elseif slot0 == "Breathing" then
		B = math.floor(math.sin((globals.curtime() + 0.7) * 4 + 4) * 127 + 128)
		G = 255
		R = math.floor(math.sin((globals.curtime() + 0.7) * 4 + 4) * 127 + 128)

		renderer.indicator(0, R, G, B, slot1)
	elseif slot0 == "Flashing" then
		slot2 = 510 / uv2
		B = uv3(globals.tickcount() % slot2, 255)
		G = 255
		R = uv3(globals.tickcount() % slot2, 255)

		renderer.indicator(0, R, G, B, slot1)
	end
end

client.set_event_callback("paint", OnDraw)
ui.new_button("LUA", "a", "Start Radio", OpenMusic)
