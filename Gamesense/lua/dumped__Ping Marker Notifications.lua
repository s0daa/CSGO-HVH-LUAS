slot0 = require("gamesense/images")
slot1 = {
	client = {
		cb = client.set_event_callback,
		unsetCb = client.unset_event_callback,
		useridToEnt = client.userid_to_entindex,
		exec = client.exec
	},
	ui = {
		cb = ui.set_callback,
		get = ui.get,
		checkbox = ui.new_checkbox,
		label = ui.new_label,
		colorPicker = ui.new_color_picker,
		slider = ui.new_slider,
		setVisible = ui.set_visible
	},
	entity = {
		isEnemy = entity.is_enemy,
		getName = entity.get_player_name
	},
	draw = {
		w2s = renderer.world_to_screen,
		text = renderer.text,
		textSize = renderer.measure_text,
		circleOutline = renderer.circle_outline,
		rectangle = renderer.rectangle
	},
	curtime = globals.curtime
}

function slot4()
	uv0.pings = {}
end

function slot5(slot0)
	if uv0.client.useridToEnt(slot0.userid) == 0 then
		return
	end

	if not uv0.entity.isEnemy(slot1) then
		return
	end

	slot2 = uv0.entity.getName(slot1)
	slot3 = uv0.curtime()

	for slot7, slot8 in ipairs(uv1.pings) do
		if slot3 - slot8[6] <= 2 and slot8[5] == slot2 then
			table.remove(uv1.pings, slot7)
		end
	end

	table.insert(uv1.pings, {
		slot0.x,
		slot0.y,
		slot0.z,
		slot0.urgent,
		slot2,
		slot3
	})

	if uv0.ui.get(uv1.menu.playSound) then
		uv0.client.exec("play ", uv1.sounds[slot0.urgent])
	end
end

function slot6()
	for slot5, slot6 in pairs(uv1.pings) do
		if uv0.curtime() > slot6[6] + uv0.ui.get(uv1.menu.pingDelay) then
			table.remove(uv1.pings, slot5)
		else
			slot8, slot9 = uv0.draw.w2s(slot6[1], slot6[2], slot6[3])

			if slot8 ~= nil and slot9 ~= nil then
				slot11, slot12, slot13, slot14 = uv0.ui.get(uv1.menu.color1)

				if slot6[4] then
					if (slot7 - slot1) * 32 % 16 < 8 then
						slot11, slot12, slot13, slot14 = uv0.ui.get(uv1.menu.color2)
					end
				else
					uv0.draw.circleOutline(slot8, slot9, slot11, slot12, slot13, 155 - 2 * slot10, 24 - slot10, 0, 1, 4)
				end

				uv1.images[slot6[4]][2]:draw(slot8 - 16, slot9 - 16, 32, 32, 0, 0, 0, 225)
				uv1.images[slot6[4]][1]:draw(slot8 - 15, slot9 - 15, 30, 30, slot11, slot12, slot13, math.min(slot14, 200))

				if uv0.ui.get(uv1.menu.showName) then
					slot15, slot16 = uv0.draw.textSize("cb", slot6[5])

					if slot15 > 360 then
						slot15 = 360
					end

					uv0.draw.rectangle(math.ceil(slot8 - 4 - slot15 / 2), slot9 + 22, slot15 + 7, 18, 0, 0, 0, 100)
					uv0.draw.text(slot8, slot9 + 30, 255, 255, 255, 255, "cb", 360, slot6[5])
				end
			end
		end
	end
end

slot1.ui.cb(({
	menu = {
		enabled = slot1.ui.checkbox("VISUALS", "Other ESP", "Enemy Ping Marker"),
		label0 = slot1.ui.label("LUA", "B", "Ping Marker Settings:"),
		showName = slot1.ui.checkbox("LUA", "B", "Show Name"),
		playSound = slot1.ui.checkbox("LUA", "B", "Ping Sound"),
		pingDelay = slot1.ui.slider("LUA", "B", "Ping Duration", 1, 30, 10, true, "s"),
		label1 = slot1.ui.label("LUA", "B", "Normal Ping Color"),
		color1 = slot1.ui.colorPicker("LUA", "B", "Normal Ping Color", 93, 167, 254, 200),
		label2 = slot1.ui.label("LUA", "B", "Urgent Ping Color"),
		color2 = slot1.ui.colorPicker("LUA", "B", "Urgent Ping Color", 255, 30, 30, 200),
		spacer = slot1.ui.label("LUA", "B", " ")
	},
	sounds = {
		[true] = "ui/panorama/ping_alert_01",
		[false] = "player/playerping"
	},
	images = {
		[false] = {
			slot0.get_panorama_image("icons/ui/info.svg"),
			slot0.load("<?xml version=\"1.0\" ?><svg width=\"32px\" height=\"32px\"><circle cx=\"16\" cy=\"16\" r=\"15\" fill=\"#fff\" /></svg>")
		},
		[true] = {
			slot0.get_panorama_image("icons/ui/alert.svg"),
			slot0.load("<?xml version=\"1.0\" ?><svg width=\"32px\" height=\"32px\"><polygon points=\"16,3 31,29 1,29\" style=\"fill:#fff\" /></svg>")
		}
	},
	pings = {}
}).menu.enabled, function (slot0)
	slot2 = uv0.ui.get(slot0) and "cb" or "unsetCb"

	uv1(slot1)
	uv0.client[slot2]("round_start", uv2)
	uv0.client[slot2]("player_ping", uv3)
	uv0.client[slot2]("paint", uv4)
end)
function (slot0)
	for slot4, slot5 in pairs(uv0.menu) do
		if slot4 ~= "enabled" then
			uv1.ui.setVisible(uv0.menu[slot4], slot0)
		end
	end
end(false)
