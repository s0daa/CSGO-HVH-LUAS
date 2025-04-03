local var_0_0 = require("gamesense/images")
local var_0_1 = {
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
local var_0_2 = {
	menu = {
		enabled = var_0_1.ui.checkbox("VISUALS", "Other ESP", "Enemy Ping Marker"),
		label0 = var_0_1.ui.label("LUA", "B", "Ping Marker Settings:"),
		showName = var_0_1.ui.checkbox("LUA", "B", "Show Name"),
		playSound = var_0_1.ui.checkbox("LUA", "B", "Ping Sound"),
		pingDelay = var_0_1.ui.slider("LUA", "B", "Ping Duration", 1, 30, 10, true, "s"),
		label1 = var_0_1.ui.label("LUA", "B", "Normal Ping Color"),
		color1 = var_0_1.ui.colorPicker("LUA", "B", "Normal Ping Color", 93, 167, 254, 200),
		label2 = var_0_1.ui.label("LUA", "B", "Urgent Ping Color"),
		color2 = var_0_1.ui.colorPicker("LUA", "B", "Urgent Ping Color", 255, 30, 30, 200),
		spacer = var_0_1.ui.label("LUA", "B", " ")
	},
	sounds = {
		[true] = "ui/panorama/ping_alert_01",
		[false] = "player/playerping"
	},
	images = {
		[false] = {
			var_0_0.get_panorama_image("icons/ui/info.svg"),
			var_0_0.load("<?xml version=\"1.0\" ?><svg width=\"32px\" height=\"32px\"><circle cx=\"16\" cy=\"16\" r=\"15\" fill=\"#fff\" /></svg>")
		},
		[true] = {
			var_0_0.get_panorama_image("icons/ui/alert.svg"),
			var_0_0.load("<?xml version=\"1.0\" ?><svg width=\"32px\" height=\"32px\"><polygon points=\"16,3 31,29 1,29\" style=\"fill:#fff\" /></svg>")
		}
	},
	pings = {}
}

local function var_0_3(arg_1_0)
	for iter_1_0, iter_1_1 in pairs(var_0_2.menu) do
		if iter_1_0 ~= "enabled" then
			var_0_1.ui.setVisible(var_0_2.menu[iter_1_0], arg_1_0)
		end
	end
end

local function var_0_4()
	var_0_2.pings = {}
end

local function var_0_5(arg_3_0)
	local var_3_0 = var_0_1.client.useridToEnt(arg_3_0.userid)

	if var_3_0 == 0 then
		return
	end

	if not var_0_1.entity.isEnemy(var_3_0) then
		return
	end

	local var_3_1 = var_0_1.entity.getName(var_3_0)
	local var_3_2 = var_0_1.curtime()

	for iter_3_0, iter_3_1 in ipairs(var_0_2.pings) do
		if var_3_2 - iter_3_1[6] <= 2 and iter_3_1[5] == var_3_1 then
			table.remove(var_0_2.pings, iter_3_0)
		end
	end

	table.insert(var_0_2.pings, {
		arg_3_0.x,
		arg_3_0.y,
		arg_3_0.z,
		arg_3_0.urgent,
		var_3_1,
		var_3_2
	})

	if var_0_1.ui.get(var_0_2.menu.playSound) then
		var_0_1.client.exec("play ", var_0_2.sounds[arg_3_0.urgent])
	end
end

local function var_0_6()
	local var_4_0 = var_0_1.ui.get(var_0_2.menu.pingDelay)
	local var_4_1 = var_0_1.curtime()

	for iter_4_0, iter_4_1 in pairs(var_0_2.pings) do
		local var_4_2 = iter_4_1[6] + var_4_0

		if var_4_2 < var_4_1 then
			table.remove(var_0_2.pings, iter_4_0)
		else
			local var_4_3, var_4_4 = var_0_1.draw.w2s(iter_4_1[1], iter_4_1[2], iter_4_1[3])

			if var_4_3 ~= nil and var_4_4 ~= nil then
				local var_4_5 = (var_4_2 - var_4_1) * 32 % 16
				local var_4_6, var_4_7, var_4_8, var_4_9 = var_0_1.ui.get(var_0_2.menu.color1)

				if iter_4_1[4] then
					if var_4_5 < 8 then
						var_4_6, var_4_7, var_4_8, var_4_9 = var_0_1.ui.get(var_0_2.menu.color2)
					end
				else
					var_0_1.draw.circleOutline(var_4_3, var_4_4, var_4_6, var_4_7, var_4_8, 155 - 2 * var_4_5, 24 - var_4_5, 0, 1, 4)
				end

				var_0_2.images[iter_4_1[4]][2]:draw(var_4_3 - 16, var_4_4 - 16, 32, 32, 0, 0, 0, 225)
				var_0_2.images[iter_4_1[4]][1]:draw(var_4_3 - 15, var_4_4 - 15, 30, 30, var_4_6, var_4_7, var_4_8, math.min(var_4_9, 200))

				if var_0_1.ui.get(var_0_2.menu.showName) then
					local var_4_10, var_4_11 = var_0_1.draw.textSize("cb", iter_4_1[5])

					if var_4_10 > 360 then
						var_4_10 = 360
					end

					var_0_1.draw.rectangle(math.ceil(var_4_3 - 4 - var_4_10 / 2), var_4_4 + 22, var_4_10 + 7, 18, 0, 0, 0, 100)
					var_0_1.draw.text(var_4_3, var_4_4 + 30, 255, 255, 255, 255, "cb", 360, iter_4_1[5])
				end
			end
		end
	end
end

var_0_1.ui.cb(var_0_2.menu.enabled, function(arg_5_0)
	local var_5_0 = var_0_1.ui.get(arg_5_0)
	local var_5_1 = var_5_0 and "cb" or "unsetCb"

	var_0_3(var_5_0)
	var_0_1.client[var_5_1]("round_start", var_0_4)
	var_0_1.client[var_5_1]("player_ping", var_0_5)
	var_0_1.client[var_5_1]("paint", var_0_6)
end)
var_0_3(false)
