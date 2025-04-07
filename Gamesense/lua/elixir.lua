local libraries = {
	csgo_weapons = require("gamesense/csgo_weapons"),
	ffi = require("ffi"),
	base64 = require("gamesense/base64"),
	clipboard = require("gamesense/clipboard"),
	entity = require("gamesense/entity"),
	vector = require("vector"),
}
local ffi_structs = {
	usercmd = libraries.ffi.typeof([[
		struct {
			void* pVTable; // 0x00
			int iCommandNumber; // 0x04
			int nTickCount; // 0x08
			float angViewPoint[3]; // 0x0C
			float vecAimDirection[3]; // 0x18
			float flForwardMove; // 0x24
			float flSideMove; // 0x28
			float flUpMove; // 0x2C
			int nButtons; // 0x30
			char uImpulse; // 0x34
			int iWeaponSelect; // 0x38
			int iWeaponSubType; // 0x3C
			int iRandomSeed; // 0x40
			short shMouseDeltaX; // 0x44
			short shMouseDeltaY; // 0x46
			bool bHasBeenPredicted; // 0x48
			float angViewPointBackup[3]; // 0x4C // @note: instead of 'QAngle angHeadView' there's backup value of view angles that used to detect their change, changed since ~11.06.22 (version 1.38.3.7, build 1490)
			int nButtonsBackup; // 0x58 // @note: instead of 'Vector vecHeadOffset' there's single backup value of buttons that used to detect their change, 0x5C/0x60 used for something else but still there, changed since ~11.06.22 (version 1.38.3.7, build 1490) // @ida: (WriteUsercmd) client.dll -> U8["FF 76 ? E8 ? ? ? ? 83 C4 1C" + 0x2] @xref: "headoffset"
			int iUnknown0; // 0x5C
			int iUnknown1; // 0x60
		} *
	]]),
}
local utilities = {
	angle_difference = function(alpha, beta)
		local alpha_rad = math.rad(alpha)
		local beta_rad = math.rad(beta)

		local alpha_tan = math.tan(alpha_rad)
		local beta_tan = math.tan(beta_rad)

		local top = alpha_tan - beta_tan
		local bottom = alpha_tan * beta_tan + 1

		local diff_rad = math.atan(top / bottom)
		local diff = math.deg(diff_rad)

		return diff
	end,
	angle_difference_abs = function(alpha, beta)
		local alpha_rad = math.rad(alpha)
		local beta_rad = math.rad(beta)

		local alpha_tan = math.tan(alpha_rad)
		local beta_tan = math.tan(beta_rad)

		local top = alpha_tan - beta_tan
		local bottom = alpha_tan * beta_tan + 1

		local diff_rad = math.atan(top / bottom)
		local diff = math.deg(diff_rad)

		return math.abs(diff)
	end,
	angle_difference_rad = function(alpha, beta)
		local alpha_tan = math.tan(alpha)
		local beta_tan = math.tan(beta)

		local top = alpha_tan - beta_tan
		local bottom = alpha_tan * beta_tan + 1

		local diff = math.atan(top / bottom)

		return math.abs(diff)
	end,
	angle_difference_rad_io = function(alpha, beta)
		local alpha_tan = math.tan(alpha)
		local beta_tan = math.tan(beta)

		local top = alpha_tan - beta_tan
		local bottom = alpha_tan * beta_tan + 1

		local diff_rad = math.atan(top / bottom)
		local diff = math.deg(diff_rad)

		return math.abs(diff)
	end,
	string_contains = function(string, sub)
		return string:find(sub, 1, true) ~= nil
	end,
	string_startswith = function(string, start)
		return string:sub(1, #start) == start
	end,
	string_endswith = function(string, ending)
		return ending == "" or string:sub(-#ending) == ending
	end,
	string_replace = function(string, old, new)
		local s = string
		local search_start_idx = 1

		while true do
			local start_idx, end_idx = s:find(old, search_start_idx, true)
			if not start_idx then
				break
			end

			local postfix = s:sub(end_idx + 1)
			s = s:sub(1, (start_idx - 1)) .. new .. postfix

			search_start_idx = -1 * postfix:len()
		end

		return s
	end,

	string_insert = function(string, pos, text)
		return string:sub(1, pos - 1) .. text .. string:sub(pos)
	end,
	get_item_text = function(item_name)
		return "\a666666FF‹\aCCBBFFFFelixir\a666666FF› \a909090FF" .. item_name
	end,
	get_cond_text = function(cond, item_name)
		return "\a666666FF‹\aCCBBFFFF" .. cond .. "\a666666FF› \a909090FF" .. item_name
	end,
	get_fake_amount = function(player_id)
		return math.max(
			-60,
			math.min(60, math.floor((entity.get_prop(player_id, "m_flPoseParameter", 11) or 0) * 120 - 60 + 0.5))
		)
	end,
	calc_light_color = function(pos, colpos, size, left, col, right)
		if left > 1 then left = left / 255 end
		if col > 1 then col = col / 255 end
		if right > 1 then right = right / 255 end

		pos = pos - 1
		local delta = pos / size
		local light_pos = colpos * size
		local distance = math.abs(light_pos - pos)
		local light_delta = 1 - (distance / size)

		return ((left * (1 - delta)) + (right * delta) + col * light_delta) * 255
	end,
	calc_gradient_color = function(pos, size, left, right)
		if left > 1 then left = left / 255 end
		if right > 1 then right = right / 255 end

		pos = pos - 1
		local delta = pos / size

		return ((left * (1 - delta)) + (right * delta)) * 255
	end,
	clamp = function(v, min, max)
		return math.max(math.min(v, max), min)
	end,
	time_to_ticks = function(time)
		return math.floor(0.5 + (time / globals.tickinterval()))
	end,
	ticks_to_time = function(ticks)
		return ticks * globals.tickinterval()
	end,
	get_entities = function(enemy_only, alive_only)
		local enemy_only = enemy_only ~= nil and enemy_only or false
		local alive_only = alive_only ~= nil and alive_only or true

		local result = {}
		local player_resource = entity.get_player_resource()

		for player = 1, globals.maxplayers() do
			local is_enemy, is_alive = true, true

			if enemy_only and not entity.is_enemy(player) then
				is_enemy = false
			end
			if is_enemy then
				if alive_only and entity.get_prop(player_resource, "m_bAlive", player) ~= 1 then
					is_alive = false
				end
				if is_alive then
					table.insert(result, player)
				end
			end
		end

		return result
	end,
	table_contains = function(t, k)
		for i, v in pairs(t) do
			if k == v then
				return true
			end
		end

		return false
	end,
	copy_table,
	rect_filled = function(x, y, w, h, radius, color)
		radius = math.min(x / 2, y / 2, radius)
		local r, g, b, a = unpack(color)
		renderer.rectangle(x, y + radius, w, h - radius * 2, r, g, b, a)
		renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a)
		renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius, r, g, b, a)
		renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
		renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
		renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
		renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
	end,
	rect = function(x, y, w, h, radius, thickness, color)
		radius = math.min(w / 2, h / 2, radius)
		local r, g, b, a = unpack(color)
		if radius == 1 then
			renderer.rectangle(x, y, w, thickness, r, g, b, a)
			renderer.rectangle(x, y + h - thickness, w, thickness, r, g, b, a)
		else
			renderer.rectangle(x + radius, y, w - radius * 2, thickness, r, g, b, a)
			renderer.rectangle(x + radius, y + h - thickness, w - radius * 2, thickness, r, g, b, a)
			renderer.rectangle(x, y + radius, thickness, h - radius * 2, r, g, b, a)
			renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius * 2, r, g, b, a)
			renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
			renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
			renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
			renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
		end
	end,
	glow,
}

utilities.copy_table = function(obj)
	if type(obj) ~= "table" then
		return obj
	end
	local res = setmetatable({}, getmetatable(obj))
	for k, v in pairs(obj) do
		res[utilities.copy_table(k)] = utilities.copy_table(v)
	end
	return res
end
utilities.glow = function(x, y, w, h, width, rounding, accent, accent_inner)
	local thickness = 1
	local Offset = 1
	local r, g, b, a = unpack(accent)
	if accent_inner then
		utilities.rect_filled(x, y, w, h + 1, rounding, accent_inner)
	end
	for k = 0, width do
		if a * (k / width) ^ 1 > 5 then
			local accent = { r, g, b, a * (k / width) ^ 2 }
			utilities.rect(
				x + (k - width - Offset) * thickness,
				y + (k - width - Offset) * thickness,
				w - (k - width - Offset) * thickness * 2,
				h + 1 - (k - width - Offset) * thickness * 2,
				rounding + thickness * (width - k + Offset),
				thickness,
				accent
			)
		end
	end
end

local elixir = {
	killsay = {
		"Gdybyś tylko mógł uderzyć wroga tak mocno, jak twój tata uderza ciebie.",
		"Nazwałbym cię rakiem, ale przynajmniej rak zabija.",
		"Spójrz na to dobrą stroną, przynajmniej ściane obiłeś xD",
		"𝐝𝐨𝐠 𝐭𝐡𝐨𝐮𝐠𝐡𝐭 𝐰𝐚𝐬 𝐤𝐢𝐧𝐠 ♕? 𝐧𝐨",
		"𝕚𝕕𝕚𝕠𝕥 𝕒𝕝𝕨𝕒𝕪𝕤 𝕒𝕤𝕜 𝕞𝕖, 𝕦𝕚𝕕? 𝕒𝕟𝕕 𝕚𝕞 𝕕𝕠𝕟𝕥 𝕒𝕟𝕤𝕨𝕖𝕣, 𝕚 𝕝𝕖𝕥 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖𝕓𝕠𝕒𝕣𝕕 𝕥𝕒𝕝𝕜♛ (◣_◢)",
		"𝕕𝕠𝕟𝕥 𝕓𝕖 𝕞𝕒𝕕 𝕪𝕠𝕦 𝕝𝕠𝕤𝕥, 𝕓𝕖 𝕞𝕒𝕕 𝕪𝕠𝕦 𝕞𝕚𝕤𝕤𝕖𝕕 𝕪𝕠𝕦𝕣 𝕔𝕙𝕒𝕟𝕔𝕖 𝕥𝕠 𝕚𝕞𝕡𝕣𝕖𝕤𝕤 𝕥𝕙𝕖 𝕜𝕚𝕟𝕘 ♛",
		"NN Blasted",
		"найс айкью",
		"лол",
		"найс аа хуесос",
		"ʙᴏᴡ ᴅᴏᴡɴ ɪɴ ꜰʀᴏɴᴛ ᴏꜰ ᴍᴇ",
		"𝕤𝕥𝕠𝕡 𝕥𝕣𝕪𝕚𝕟𝕘",
		"𝕟𝕖𝕖𝕕 𝕒 𝕔𝕠𝕒𝕔𝕙?",
		"𝕕𝕦𝕞𝕓 𝕕𝕠𝕘",
		"The only thing lower than your k/d ratio is your I.Q.",
		"You should let your chair play, at least it knows how to support.",
		"If I jumped from your ego to your intelligence, Id die of starvation half-way down.",
		"Some people get paid to suck, you do it for free.",
		"I bet the last time u felt a breast was in a kfc bucket",
		"Maybe God made you a bit too special.",
		"Does your ass ever get jealous of the amount of shit that comes out of your mouth",
		"My knife is well-worn, just like your mother.",
		"Did you know sharks only kill 5 people each year? Looks like you got some competition",
		"Get the bomb, at least you will carry something this game.",
		"Some babies were dropped on their heads but you were clearly thrown at a wall",
		"I would smack you, but I am against animal abuse",
		"Options -> How To Play",
		"I'd tell you to shoot yourself, but I bet your miss",
		"1",
	},
	clantag = {
		"/ e           /",
		"/ el          /",
		"/ eli         /",
		"/ elix        /",
		"/ elixi       /",
		"/ elixir      /",
		"/ elixir.     /",
		"/ elixir.t    /",
		"/ elixir.te   /",
		"/ elixir.tec  /",
		"/ elixir.tech /",
		"/ elixir.tec  /",
		"/ elixir.te   /",
		"/ elixir.t    /",
		"/ elixir.     /",
		"/ elixir      /",
		"/ elixi       /",
		"/ elix        /",
		"/ eli         /",
		"/ el          /",
		"/ e           /",
		"/             /",
	},
	hitgroup_names = {
		"generic",
		"head",
		"chest",
		"stomach",
		"left arm",
		"right arm",
		"left leg",
		"right leg",
		"neck",
		"unknown",
		"gear",
	},
	weapon_to_verb = { knife = "Knifed", hegrenade = "Naded", inferno = "Burned" },
	variables = {
		menu = {
			enable = ui.new_checkbox("AA", "Anti-aimbot angles", utilities.get_item_text("show menu")),
			tab = ui.new_combobox(
				"AA",
				"Anti-aimbot angles",
				utilities.get_item_text("tab"),
				{ "info", "anti-aim", "visuals", "miscellaneous", "configs" }
			),
			info = {
				text = ui.new_label(
					"AA",
					"Anti-aimbot angles",
					"\aCCBBFFFFelixir\a666666FF.\aCCBBFFFFtech \a909090FF- the best anti-aim lua"
				),
				text2 = ui.new_label("AA", "Anti-aimbot angles", "\aCCBBFFFFyour username \a909090FF- xxalexxddd"),
				text3 = ui.new_label("AA", "Anti-aimbot angles", "\aCCBBFFFFversion \a909090FF- dev"),
			},
			antiaim = {
				enable = ui.new_checkbox("AA", "Anti-aimbot angles", utilities.get_cond_text("anti-aim", "enable")),
				condition_label = ui.new_label("AA", "Fake lag", utilities.get_cond_text("anti-aim", "condition")),
				condition = ui.new_listbox("AA", "Fake lag", "condition", { "default", "+ new" }),
				condition_count = ui.new_slider("AA", "Fake lag", "condition count", 0, 1000),
				update_names,
				delete_condition,

				builder = {
					["default"] = {
						pitch = ui.new_combobox(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "pitch"),
							{ "off", "default", "up", "down", "minimal", "random", "custom" }
						),
						custom_pitch = ui.new_slider(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "custom pitch"),
							-89,
							89,
							0
						),

						yaw_base = ui.new_combobox(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "yaw base"),
							{ "local view", "at targets" }
						),
						yaw = ui.new_combobox(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "yaw"),
							{ "off", "180", "spin", "static", "180 Z", "crosshair" }
						),
						offset_l = ui.new_slider(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "offset left"),
							-180,
							180,
							0
						),
						offset_r = ui.new_slider(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "offset right"),
							-180,
							180,
							0
						),

						yaw_jitter = ui.new_combobox(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "jitter"),
							{ "off", "offset", "center", "random", "skitter" }
						),
						jitter_amount = ui.new_slider(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "jitter amount"),
							-180,
							180,
							0
						),

						body_yaw = ui.new_combobox(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "body yaw"),
							{ "off", "opposite", "jitter", "static" }
						),
						body_yaw_amount = ui.new_slider(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "body yaw amount"),
							-180,
							180,
							0
						),

						freestanding_body_yaw = ui.new_checkbox(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "freestanding body yaw")
						),
						edge_yaw = ui.new_checkbox(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "edge yaw")
						),

						roll = ui.new_slider(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("anti-aim", "roll"),
							-45,
							45,
							0
						),

						fl_enable = ui.new_checkbox(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("fake-lag", "enable")
						),
						fl_amount = ui.new_combobox(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("fake-lag", "amount"),
							{ "dynamic", "maximum", "fluctuate" }
						),
						fl_variance = ui.new_slider(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("fake-lag", "variance"),
							0,
							100,
							0,
							true,
							"%"
						),
						fl_limit = ui.new_slider(
							"AA",
							"Anti-aimbot angles",
							utilities.get_cond_text("fake-lag", "limit"),
							1,
							15,
							1
						),
					},
				},
				keybinds = {
					freestanding = ui.new_checkbox("AA", "Other", utilities.get_cond_text("hotkeys", "freestanding")),
					freestanding_bind = ui.new_hotkey(
						"AA",
						"Other",
						utilities.get_cond_text("hotkeys", "freestanding"),
						true
					),

					man_enable = ui.new_checkbox("AA", "Other", utilities.get_cond_text("hotkeys", "enable manuals")),
					man_forward = ui.new_hotkey("AA", "Other", utilities.get_cond_text("manuals", "forward"), false),
					man_back = ui.new_hotkey("AA", "Other", utilities.get_cond_text("manuals", "back"), false),
					man_left = ui.new_hotkey("AA", "Other", utilities.get_cond_text("manuals", "left"), false),
					man_right = ui.new_hotkey("AA", "Other", utilities.get_cond_text("manuals", "right"), false),
					man_jitter = ui.new_checkbox(
						"AA",
						"Other",
						utilities.get_cond_text("manuals", "enable jitter"),
						true
					),
					man_attargets = ui.new_checkbox(
						"AA",
						"Other",
						utilities.get_cond_text("manuals", "at targets"),
						false
					),
					man_builtinind = ui.new_checkbox(
						"AA",
						"Other",
						utilities.get_cond_text("manuals", "built-in indicators"),
						false
					),
				},
			},
			visuals = {
				enable = ui.new_checkbox("AA", "Anti-aimbot angles", utilities.get_cond_text("visuals", "enable")),

				style = ui.new_combobox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("visuals", "style"),
					{ "old", "new pixel" }
				),
				breath_speed = ui.new_slider(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("visuals", "breath animation speed"),
					1,
					10,
					5
				),

				watermark = ui.new_checkbox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("visuals", "watermark")
				),
				watermark_color = ui.new_color_picker(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("visuals", "watermark"),
					204,
					187,
					255,
					255
				),

				indicators = ui.new_checkbox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("visuals", "crosshair indicators")
				),
				indicators_color = ui.new_color_picker(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("visuals", "crosshair indicators"),
					204,
					187,
					255,
					255
				),
				indicators_elements = ui.new_multiselect(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("crosshair indicators", "elements"),
					{ "anti-aim state", "doubletap", "on-shot", "minimum damage" }
				),

				slowdown = ui.new_checkbox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("visuals", "slowdown indicator")
				),
				slowdown_color = ui.new_color_picker(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("visuals", "slowdown indicator"),
					204,
					187,
					255,
					255
				),

				low_ammo = ui.new_checkbox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("visuals", "low ammo warning")
				),
				low_ammo_color = ui.new_color_picker(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("visuals", "low ammo warning"),
					204,
					187,
					255,
					255
				),
				low_ammo_threshold = ui.new_slider(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("low ammo warning", "threshold"),
					0,
					100,
					30,
					true,
					"%"
				),

				low_hp = ui.new_checkbox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("visuals", "low health warning")
				),
				low_hp_color = ui.new_color_picker(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("visuals", "low health warning"),
					204,
					187,
					255,
					255
				),
				low_hp_threshold = ui.new_slider(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("low health warning", "threshold"),
					0,
					100,
					70,
					true,
					"hp"
				),

				bloom = ui.new_checkbox("AA", "Fake Lag", utilities.get_cond_text("visuals", "bloom")),
				bloom_amount = ui.new_slider("AA", "Fake Lag", utilities.get_cond_text("bloom", "amount"), 0, 150, 0),
				bloom_red_mul = ui.new_slider("AA", "Fake Lag", utilities.get_cond_text("bloom", "red"), 0, 100, 30),
				bloom_green_mul = ui.new_slider(
					"AA",
					"Fake Lag",
					utilities.get_cond_text("bloom", "green"),
					0,
					100,
					59
				),
				bloom_blue_mul = ui.new_slider("AA", "Fake Lag", utilities.get_cond_text("bloom", "blue"), 0, 100, 11),

				aspect_ratio = ui.new_checkbox("AA", "Other", utilities.get_cond_text("visuals", "aspect ratio")),
				ar_mode = ui.new_combobox(
					"AA",
					"Other",
					utilities.get_cond_text("aspect ratio", "mode"),
					{ "float", "display size" }
				),
				ar_float = ui.new_slider("AA", "Other", utilities.get_cond_text("aspect ratio", "float"), 0, 200, 0),
				ar_x = ui.new_slider(
					"AA",
					"Other",
					utilities.get_cond_text("aspect ratio", "size x"),
					0,
					3840,
					0,
					true,
					"px"
				),
				ar_y = ui.new_slider(
					"AA",
					"Other",
					utilities.get_cond_text("aspect ratio", "size y"),
					0,
					2160,
					0,
					true,
					"px"
				),
			},
			miscellaneous = {
				enable = ui.new_checkbox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("miscellaneous", "enable")
				),

				aimbot_logs = ui.new_checkbox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("miscellaneous", "aimbot logs")
				),

				clantag = ui.new_checkbox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("miscellaneous", "clantag")
				),
				killsay = ui.new_checkbox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("miscellaneous", "killsay")
				),
				killsay_delay = ui.new_slider(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("killsay", "delay"),
					0,
					50,
					0.5,
					true,
					"s",
					0.1
				),

				rename_md = ui.new_checkbox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("miscellaneous", "change MD to DMG")
				),

				fast_ladder = ui.new_checkbox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("miscellaneous", "fast ladder")
				),
				anti_backstab = ui.new_checkbox(
					"AA",
					"Anti-aimbot angles",
					utilities.get_cond_text("miscellaneous", "anti backstab")
				),

				resolver = ui.new_checkbox("AA", "Fake lag", utilities.get_cond_text("miscellaneous", "resolver")),
				resolve_only_target = ui.new_checkbox(
					"AA",
					"Fake lag",
					utilities.get_cond_text("resolver", "only the current threat \a666666FF\aFF8A7AFFnot recommended\a666666FF")
				),
				resolve_teammates = ui.new_checkbox(
					"AA",
					"Fake lag",
					utilities.get_cond_text("resolver", "resolve teammates")
				),
				resolver_esp_flag = ui.new_checkbox("AA", "Fake lag", utilities.get_cond_text("resolver", "esp flag")),
				resolver_jitter_detection = ui.new_combobox(
					"AA",
					"Fake lag",
					utilities.get_cond_text("resolver", "jitter detection method"),
					{ "animations", "lby" }
				),
				resolver_version = ui.new_combobox(
					"AA",
					"Fake lag",
					utilities.get_cond_text("resolver", "version"),
					{ "stable", "old", "experimental" }
				),

				exploits = {
					enable = ui.new_checkbox("AA", "Other", utilities.get_cond_text("exploits", "enable")),
					flag = ui.new_checkbox("AA", "Other", utilities.get_cond_text("exploits", "experimental [a]")),
					flag_bind = ui.new_hotkey(
						"AA",
						"Other",
						utilities.get_cond_text("exploits", "experimental [a]"),
						true
					),
				},
			},
			configs = {
				import,
				export,
				default,
			},
		},
		references = {
			ragebot = {
				aimbot = {
					double_tap = { ui.reference("RAGE", "Aimbot", "Double tap") },
					damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") },
					force_safe_point = ui.reference("RAGE", "Aimbot", "Force safe point"),
				},
				other = {
					quick_peek_assist = ui.reference("RAGE", "Other", "Quick peek assist"),
					duck_peek_assist = ui.reference("RAGE", "Other", "Duck peek assist"),
				},
			},
			antiaim = {
				enable = ui.reference("AA", "Anti-aimbot angles", "Enabled"),

				pitch = { ui.reference("AA", "Anti-aimbot angles", "Pitch") },
				yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),

				yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
				yaw_jitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
				body_yaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },

				freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
				freestanding = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },

				edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
				roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
				fake_lag = {
					enable = { ui.reference("AA", "Fake lag", "Enabled") },
					amount = ui.reference("AA", "Fake lag", "Amount"),
					variance = ui.reference("AA", "Fake lag", "Variance"),
					limit = ui.reference("AA", "Fake lag", "Limit"),
				},
				other = {
					slow_motion = { ui.reference("AA", "Other", "Slow motion") },
					leg_movement = ui.reference("AA", "Other", "Leg movement"),
					on_shot_aa = { ui.reference("AA", "Other", "On shot anti-aim") },
					fake_peek = { ui.reference("AA", "Other", "Fake peek") },
				},
			},
			visuals = {
				effects = {
					disable_post_processing = ui.reference("Visuals", "Effects", "Disable post processing"),
				},
			},
			misc = {
				settings = {
					sv_maxusrcmdprocessticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks2"),
					sv_maxunlag = ui.reference("MISC", "Settings", "sv_maxunlag2"),
				},
			},
		},
		cvars = {
			r_aspectratio = cvar.r_aspectratio,
			r_bloomtintexponent = cvar.r_bloomtintexponent,
			r_bloomtintr = cvar.r_bloomtintr,
			r_bloomtintg = cvar.r_bloomtintg,
			r_bloomtintb = cvar.r_bloomtintb,
		},
		features = {
			antiaim = {
				fake = 0,
				states = { "default" },
				max_states = 1,
			},
			visuals = {
				scoped = false,
				anim_breathing = 0.0,
				breath_switch = 1,
				warnings_offset = 0,
				slowdown_indicator = {
					anim = 0.0,
				},
				low_ammo = {
					anim = 0.0,
				},
				low_hp = {
					anim = 0.0,
				},
				crosshair_indicators = {
					light_pos = 0.0,
					fake = 0.0,
					anims = {
						show = 0.0,
						scope = 0.0,
						dt = 0.0,
					},
				},
			},
			miscellaneous = {
				clantag_back = false,
				clantag_last = "",
				aimbot_logs = {
					data = {},
					net_data = {},
					sim_ticks = {},
					hits = 0,
					mismatches = 0,
					misses = {
						spread = 0,
						prediction = 0,
						resolver = 0,
					},
					cl_data = {
						tick_shifted = false,
						tick_base = 0,
					},
				},
				exploits = {
					switch_move = false,
				},
			},
		},
	},
}
ui.set_visible(elixir.variables.references.misc.settings.sv_maxusrcmdprocessticks, true)
ui.set_visible(elixir.variables.references.misc.settings.sv_maxunlag, true)
local functions = {
	menu = {
		main = {
			update = function()
				ui.set_visible(elixir.variables.menu.tab, ui.get(elixir.variables.menu.enable))

				ui.set_visible(
					elixir.variables.menu.info.text,
					ui.get(elixir.variables.menu.enable) and ui.get(elixir.variables.menu.tab) == "info"
				)
				ui.set_visible(
					elixir.variables.menu.info.text2,
					ui.get(elixir.variables.menu.enable) and ui.get(elixir.variables.menu.tab) == "info"
				)
				ui.set_visible(
					elixir.variables.menu.info.text3,
					ui.get(elixir.variables.menu.enable) and ui.get(elixir.variables.menu.tab) == "info"
				)

				ui.set_visible(
					elixir.variables.menu.antiaim.enable,
					ui.get(elixir.variables.menu.enable) and ui.get(elixir.variables.menu.tab) == "anti-aim"
				)

				ui.set_visible(
					elixir.variables.menu.visuals.enable,
					ui.get(elixir.variables.menu.enable) and ui.get(elixir.variables.menu.tab) == "visuals"
				)

				ui.set_visible(
					elixir.variables.menu.miscellaneous.enable,
					ui.get(elixir.variables.menu.enable) and ui.get(elixir.variables.menu.tab) == "miscellaneous"
				)

				ui.set_visible(
					elixir.variables.menu.configs.import,
					ui.get(elixir.variables.menu.enable) and ui.get(elixir.variables.menu.tab) == "configs"
				)
				ui.set_visible(
					elixir.variables.menu.configs.export,
					ui.get(elixir.variables.menu.enable) and ui.get(elixir.variables.menu.tab) == "configs"
				)
				ui.set_visible(
					elixir.variables.menu.configs.default,
					ui.get(elixir.variables.menu.enable) and ui.get(elixir.variables.menu.tab) == "configs"
				)
			end,
		},
		antiaim = {
			update = function()
				local new_visibility = ui.get(elixir.variables.menu.enable)
					and ui.get(elixir.variables.menu.tab) == "anti-aim"
					and ui.get(elixir.variables.menu.antiaim.enable)

				ui.set_visible(elixir.variables.menu.antiaim.keybinds.freestanding, new_visibility)
				ui.set_visible(elixir.variables.menu.antiaim.keybinds.freestanding_bind, new_visibility)

				ui.set_visible(elixir.variables.menu.antiaim.keybinds.man_enable, new_visibility)
				ui.set_visible(
					elixir.variables.menu.antiaim.keybinds.man_forward,
					new_visibility and ui.get(elixir.variables.menu.antiaim.keybinds.man_enable)
				)
				ui.set_visible(
					elixir.variables.menu.antiaim.keybinds.man_back,
					new_visibility and ui.get(elixir.variables.menu.antiaim.keybinds.man_enable)
				)
				ui.set_visible(
					elixir.variables.menu.antiaim.keybinds.man_left,
					new_visibility and ui.get(elixir.variables.menu.antiaim.keybinds.man_enable)
				)
				ui.set_visible(
					elixir.variables.menu.antiaim.keybinds.man_right,
					new_visibility and ui.get(elixir.variables.menu.antiaim.keybinds.man_enable)
				)
				ui.set_visible(
					elixir.variables.menu.antiaim.keybinds.man_jitter,
					new_visibility and ui.get(elixir.variables.menu.antiaim.keybinds.man_enable)
				)
				ui.set_visible(
					elixir.variables.menu.antiaim.keybinds.man_attargets,
					new_visibility and ui.get(elixir.variables.menu.antiaim.keybinds.man_enable)
				)
				ui.set_visible(
					elixir.variables.menu.antiaim.keybinds.man_builtinind,
					new_visibility and ui.get(elixir.variables.menu.antiaim.keybinds.man_enable)
				)

				ui.set_visible(elixir.variables.menu.antiaim.condition_label, new_visibility)
				ui.set_visible(elixir.variables.menu.antiaim.condition, new_visibility)
				ui.set_visible(elixir.variables.menu.antiaim.condition_count, false)
				ui.set_visible(elixir.variables.menu.antiaim.update_names, new_visibility)
				ui.set_visible(elixir.variables.menu.antiaim.delete_condition, new_visibility)
				-- for k, v in pairs(elixir.states) do
				-- 	local default_visibility = new_visibility and ui.get(elixir.variables.menu.antiaim.state) == v
				-- 	local state_visibility = default_visibility
				-- 	if v ~= "default" then
				-- 		state_visibility = state_visibility and ui.get(elixir.variables.menu.antiaim.builder[v].enable)

				-- 		ui.set_visible(elixir.variables.menu.antiaim.builder[v].enable, default_visibility)
				-- 	end

				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].pitch, state_visibility)
				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].custom_pitch,
				-- 		state_visibility and ui.get(elixir.variables.menu.antiaim.builder[v].pitch) == "custom")

				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].yaw_base, state_visibility)
				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].yaw, state_visibility)
				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].offset_l,
				-- 		state_visibility and ui.get(elixir.variables.menu.antiaim.builder[v].yaw) ~= "off")
				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].offset_r,
				-- 		state_visibility and ui.get(elixir.variables.menu.antiaim.builder[v].yaw) ~= "off")

				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].yaw_jitter, state_visibility)
				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].jitter_amount,
				-- 		state_visibility and ui.get(elixir.variables.menu.antiaim.builder[v].yaw_jitter) ~= "off")

				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].body_yaw, state_visibility)
				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].body_yaw_amount,
				-- 		state_visibility and ui.get(elixir.variables.menu.antiaim.builder[v].body_yaw) ~= "off" and
				-- 		ui.get(elixir.variables.menu.antiaim.builder[v].body_yaw) ~= "opposite")

				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].freestanding_body_yaw, state_visibility)
				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].edge_yaw, state_visibility)
				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].roll, state_visibility)

				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].fl_enable, state_visibility)
				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].fl_amount, state_visibility)
				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].fl_variance, state_visibility)
				-- 	ui.set_visible(elixir.variables.menu.antiaim.builder[v].fl_limit, state_visibility)
				-- end
			end,
		},
		visuals = {
			update = function()
				local vis = ui.get(elixir.variables.menu.enable)
					and ui.get(elixir.variables.menu.tab) == "visuals"
					and ui.get(elixir.variables.menu.visuals.enable)

				ui.set_visible(elixir.variables.menu.visuals.style, vis)
				ui.set_visible(
					elixir.variables.menu.visuals.breath_speed,
					vis and ui.get(elixir.variables.menu.visuals.style) == "new pixel"
				)

				ui.set_visible(elixir.variables.menu.visuals.watermark, vis)
				ui.set_visible(
					elixir.variables.menu.visuals.watermark_color,
					vis and ui.get(elixir.variables.menu.visuals.watermark)
				)

				ui.set_visible(
					elixir.variables.menu.visuals.indicators,
					vis and ui.get(elixir.variables.menu.visuals.style) == "new pixel"
				)
				ui.set_visible(
					elixir.variables.menu.visuals.indicators_color,
					vis
						and ui.get(elixir.variables.menu.visuals.indicators)
						and ui.get(elixir.variables.menu.visuals.style) == "new pixel"
				)
				ui.set_visible(
					elixir.variables.menu.visuals.indicators_elements,
					vis
						and ui.get(elixir.variables.menu.visuals.indicators)
						and ui.get(elixir.variables.menu.visuals.style) == "new pixel"
				)

				ui.set_visible(elixir.variables.menu.visuals.slowdown, vis)
				ui.set_visible(
					elixir.variables.menu.visuals.slowdown_color,
					vis and ui.get(elixir.variables.menu.visuals.slowdown)
				)

				ui.set_visible(
					elixir.variables.menu.visuals.low_ammo,
					vis and ui.get(elixir.variables.menu.visuals.style) == "new pixel"
				)
				ui.set_visible(
					elixir.variables.menu.visuals.low_ammo_color,
					vis
						and ui.get(elixir.variables.menu.visuals.low_ammo)
						and ui.get(elixir.variables.menu.visuals.style) == "new pixel"
				)
				ui.set_visible(
					elixir.variables.menu.visuals.low_ammo_threshold,
					vis
						and ui.get(elixir.variables.menu.visuals.low_ammo)
						and ui.get(elixir.variables.menu.visuals.style) == "new pixel"
				)

				ui.set_visible(
					elixir.variables.menu.visuals.low_hp,
					vis and ui.get(elixir.variables.menu.visuals.style) == "new pixel"
				)
				ui.set_visible(
					elixir.variables.menu.visuals.low_hp_color,
					vis
						and ui.get(elixir.variables.menu.visuals.low_hp)
						and ui.get(elixir.variables.menu.visuals.style) == "new pixel"
				)
				ui.set_visible(
					elixir.variables.menu.visuals.low_hp_threshold,
					vis
						and ui.get(elixir.variables.menu.visuals.low_hp)
						and ui.get(elixir.variables.menu.visuals.style) == "new pixel"
				)

				ui.set_visible(elixir.variables.menu.visuals.bloom, vis)
				ui.set_visible(
					elixir.variables.menu.visuals.bloom_amount,
					vis and ui.get(elixir.variables.menu.visuals.bloom)
				)
				ui.set_visible(
					elixir.variables.menu.visuals.bloom_red_mul,
					vis and ui.get(elixir.variables.menu.visuals.bloom)
				)
				ui.set_visible(
					elixir.variables.menu.visuals.bloom_green_mul,
					vis and ui.get(elixir.variables.menu.visuals.bloom)
				)
				ui.set_visible(
					elixir.variables.menu.visuals.bloom_blue_mul,
					vis and ui.get(elixir.variables.menu.visuals.bloom)
				)

				ui.set_visible(elixir.variables.menu.visuals.aspect_ratio, vis)
				ui.set_visible(
					elixir.variables.menu.visuals.ar_mode,
					vis and ui.get(elixir.variables.menu.visuals.aspect_ratio)
				)
				ui.set_visible(
					elixir.variables.menu.visuals.ar_float,
					vis
						and ui.get(elixir.variables.menu.visuals.aspect_ratio)
						and ui.get(elixir.variables.menu.visuals.ar_mode) == "float"
				)
				ui.set_visible(
					elixir.variables.menu.visuals.ar_x,
					vis
						and ui.get(elixir.variables.menu.visuals.aspect_ratio)
						and ui.get(elixir.variables.menu.visuals.ar_mode) == "display size"
				)
				ui.set_visible(
					elixir.variables.menu.visuals.ar_y,
					vis
						and ui.get(elixir.variables.menu.visuals.aspect_ratio)
						and ui.get(elixir.variables.menu.visuals.ar_mode) == "display size"
				)
			end,
		},
		miscellaneous = {
			update = function()
				local vis = ui.get(elixir.variables.menu.enable)
					and ui.get(elixir.variables.menu.tab) == "miscellaneous"
					and ui.get(elixir.variables.menu.miscellaneous.enable)

				ui.set_visible(elixir.variables.menu.miscellaneous.aimbot_logs, vis)

				ui.set_visible(elixir.variables.menu.miscellaneous.clantag, vis)
				ui.set_visible(elixir.variables.menu.miscellaneous.killsay, vis)
				ui.set_visible(
					elixir.variables.menu.miscellaneous.killsay_delay,
					vis and ui.get(elixir.variables.menu.miscellaneous.killsay)
				)

				ui.set_visible(elixir.variables.menu.miscellaneous.rename_md, vis)
				ui.set_visible(elixir.variables.menu.miscellaneous.fast_ladder, vis)
				ui.set_visible(elixir.variables.menu.miscellaneous.anti_backstab, vis)

				ui.set_visible(elixir.variables.menu.miscellaneous.resolver, vis)
				ui.set_visible(
					elixir.variables.menu.miscellaneous.resolve_only_target,
					vis and ui.get(elixir.variables.menu.miscellaneous.resolver)
				)
				ui.set_visible(
					elixir.variables.menu.miscellaneous.resolve_teammates,
					vis
						and ui.get(elixir.variables.menu.miscellaneous.resolver)
						and not ui.get(elixir.variables.menu.miscellaneous.resolve_only_target)
				)
				ui.set_visible(
					elixir.variables.menu.miscellaneous.resolver_esp_flag,
					vis and ui.get(elixir.variables.menu.miscellaneous.resolver)
				)
				ui.set_visible(
					elixir.variables.menu.miscellaneous.resolver_jitter_detection,
					vis and ui.get(elixir.variables.menu.miscellaneous.resolver)
				)
				ui.set_visible(
					elixir.variables.menu.miscellaneous.resolver_version,
					vis and ui.get(elixir.variables.menu.miscellaneous.resolver)
				)

				ui.set_visible(elixir.variables.menu.miscellaneous.exploits.enable, vis)

				ui.set_visible(
					elixir.variables.menu.miscellaneous.exploits.flag,
					vis and ui.get(elixir.variables.menu.miscellaneous.exploits.enable)
				)
				ui.set_visible(
					elixir.variables.menu.miscellaneous.exploits.flag_bind,
					vis
						and ui.get(elixir.variables.menu.miscellaneous.exploits.flag)
						and ui.get(elixir.variables.menu.miscellaneous.exploits.enable)
				)
			end,
		},
	},
	skeet_menu = {
		set_visible = function(val)
			ui.set_visible(elixir.variables.references.antiaim.enable, val)

			ui.set_visible(elixir.variables.references.antiaim.pitch[1], val)
			ui.set_visible(
				elixir.variables.references.antiaim.pitch[2],
				val and elixir.variables.references.antiaim.pitch[1] == "custom"
			)
			ui.set_visible(elixir.variables.references.antiaim.yaw_base, val)

			ui.set_visible(elixir.variables.references.antiaim.yaw[1], val)
			ui.set_visible(elixir.variables.references.antiaim.yaw[2], val)
			ui.set_visible(elixir.variables.references.antiaim.yaw_jitter[1], val)
			ui.set_visible(elixir.variables.references.antiaim.yaw_jitter[2], val)
			ui.set_visible(elixir.variables.references.antiaim.body_yaw[1], val)
			ui.set_visible(elixir.variables.references.antiaim.body_yaw[2], val)

			ui.set_visible(elixir.variables.references.antiaim.freestanding_body_yaw, val)
			ui.set_visible(elixir.variables.references.antiaim.freestanding[1], val)
			ui.set_visible(elixir.variables.references.antiaim.freestanding[2], val)

			ui.set_visible(elixir.variables.references.antiaim.edge_yaw, val)
			ui.set_visible(elixir.variables.references.antiaim.roll, val)

			ui.set_visible(elixir.variables.references.antiaim.fake_lag.enable[1], val)
			ui.set_visible(elixir.variables.references.antiaim.fake_lag.enable[2], val)
			ui.set_visible(elixir.variables.references.antiaim.fake_lag.amount, val)
			ui.set_visible(elixir.variables.references.antiaim.fake_lag.variance, val)
			ui.set_visible(elixir.variables.references.antiaim.fake_lag.limit, val)

			ui.set_visible(elixir.variables.references.antiaim.other.slow_motion[1], val)
			ui.set_visible(elixir.variables.references.antiaim.other.slow_motion[2], val)
			ui.set_visible(elixir.variables.references.antiaim.other.leg_movement, val)
			ui.set_visible(elixir.variables.references.antiaim.other.on_shot_aa[1], val)
			ui.set_visible(elixir.variables.references.antiaim.other.on_shot_aa[2], val)
			ui.set_visible(elixir.variables.references.antiaim.other.fake_peek[1], val)
			ui.set_visible(elixir.variables.references.antiaim.other.fake_peek[2], val)
		end,
	},
	antiaim = {
		update_names = function()
			local new_states = elixir.variables.features.antiaim.states
			for k, v in pairs(new_states) do
				if k ~= 1 then
					new_states[k] = ui.get(elixir.variables.menu.antiaim.builder[k].name) .. " [" .. k - 1 .. "]"
				end
			end
			local menu_conditions = utilities.copy_table(new_states)
			table.insert(menu_conditions, #menu_conditions + 1, "+ new")
			ui.update(elixir.variables.menu.antiaim.condition, menu_conditions)
		end,
		delete_condition = function(cond)
			if cond == 0 then
				return
			end
			if cond == #elixir.variables.features.antiaim.states then
				return
			end

			local new_states = elixir.variables.features.antiaim.states

			table.remove(new_states, cond + 1)
			elixir.variables.features.antiaim.states = new_states

			local menu_conditions = utilities.copy_table(new_states)
			table.insert(menu_conditions, #menu_conditions + 1, "+ new")
			ui.update(elixir.variables.menu.antiaim.condition, menu_conditions)

			ui.set(elixir.variables.menu.antiaim.condition, #menu_conditions - 2)
			ui.set(
				elixir.variables.menu.antiaim.condition_count,
				ui.get(elixir.variables.menu.antiaim.condition_count) - 1
			)
		end,
		create_condition = function()
			local new_states = elixir.variables.features.antiaim.states

			table.insert(new_states, #new_states + 1, "new [" .. #new_states .. "]")
			elixir.variables.features.antiaim.states = new_states
			elixir.variables.features.antiaim.max_states =
				math.max(elixir.variables.features.antiaim.max_states, #new_states)

			local menu_conditions = utilities.copy_table(new_states)
			table.insert(menu_conditions, #menu_conditions + 1, "+ new")
			ui.update(elixir.variables.menu.antiaim.condition, menu_conditions)

			ui.set(elixir.variables.menu.antiaim.condition, #menu_conditions - 2)

			ui.set(
				elixir.variables.menu.antiaim.condition_count,
				ui.get(elixir.variables.menu.antiaim.condition_count) + 1
			)

			local v = #new_states

			elixir.variables.menu.antiaim.builder[v] = {}
			elixir.variables.menu.antiaim.builder[v].when = {}

			elixir.variables.menu.antiaim.builder[v].when.activators =
				ui.new_multiselect("AA", "Fake lag", utilities.get_cond_text("when", "activators"), {
					"velocity",
					"airbourne",
					"crouching",
					"team",
					"warmup",
					"keybind",
					"doubletap",
					"hideshots",
					"slow motion",
					"quick peek assist",
					"duck peek assist",
				})
			elixir.variables.menu.antiaim.builder[v].when.min_velocity =
				ui.new_slider("AA", "Fake lag", utilities.get_cond_text("when", "min velocity"), 0, 400, 0)
			elixir.variables.menu.antiaim.builder[v].when.max_velocity =
				ui.new_slider("AA", "Fake lag", utilities.get_cond_text("when", "max velocity"), 0, 400, 0)
			elixir.variables.menu.antiaim.builder[v].when.airbourne =
				ui.new_checkbox("AA", "Fake lag", utilities.get_cond_text("when", "airbourne"))
			elixir.variables.menu.antiaim.builder[v].when.team = ui.new_combobox(
				"AA",
				"Fake lag",
				utilities.get_cond_text("when", "team"),
				{ "counter-terrorists", "terrorists" }
			)
			elixir.variables.menu.antiaim.builder[v].when.warmup =
				ui.new_checkbox("AA", "Fake lag", utilities.get_cond_text("when", "warmup"))
			elixir.variables.menu.antiaim.builder[v].when.crouching =
				ui.new_checkbox("AA", "Fake lag", utilities.get_cond_text("when", "crouching"))
			elixir.variables.menu.antiaim.builder[v].when.doubletap =
				ui.new_checkbox("AA", "Fake lag", utilities.get_cond_text("when", "doubletap"))
			elixir.variables.menu.antiaim.builder[v].when.hideshots =
				ui.new_checkbox("AA", "Fake lag", utilities.get_cond_text("when", "hideshots"))
			elixir.variables.menu.antiaim.builder[v].when.slow_motion =
				ui.new_checkbox("AA", "Fake lag", utilities.get_cond_text("when", "slow motion"))
			elixir.variables.menu.antiaim.builder[v].when.quick_peek_assist =
				ui.new_checkbox("AA", "Fake lag", utilities.get_cond_text("when", "quick peek assist"))
			elixir.variables.menu.antiaim.builder[v].when.duck_peek_assist =
				ui.new_checkbox("AA", "Fake lag", utilities.get_cond_text("when", "duck peek assist"))
			elixir.variables.menu.antiaim.builder[v].when.keybind =
				ui.new_hotkey("AA", "Fake lag", utilities.get_cond_text("when", "keybind"))

			elixir.variables.menu.antiaim.builder[v].name_label =
				ui.new_label("AA", "Anti-aimbot angles", utilities.get_cond_text("anti-aim", "condition name"))
			elixir.variables.menu.antiaim.builder[v].name = ui.new_textbox("AA", "Anti-aimbot angles", "name")

			elixir.variables.menu.antiaim.builder[v].pitch = ui.new_combobox(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("anti-aim", "pitch"),
				{ "off", "default", "up", "down", "minimal", "random", "custom" }
			)
			elixir.variables.menu.antiaim.builder[v].custom_pitch = ui.new_slider(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("anti-aim", "custom pitch"),
				-89,
				89,
				0
			)

			elixir.variables.menu.antiaim.builder[v].yaw_base = ui.new_combobox(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("anti-aim", "yaw base"),
				{ "local view", "at targets" }
			)
			elixir.variables.menu.antiaim.builder[v].yaw = ui.new_combobox(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("anti-aim", "yaw"),
				{ "off", "180", "spin", "static", "180 Z", "crosshair" }
			)
			elixir.variables.menu.antiaim.builder[v].offset_l = ui.new_slider(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("anti-aim", "offset left"),
				-180,
				180,
				0
			)
			elixir.variables.menu.antiaim.builder[v].offset_r = ui.new_slider(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("anti-aim", "offset right"),
				-180,
				180,
				0
			)

			elixir.variables.menu.antiaim.builder[v].yaw_jitter = ui.new_combobox(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("anti-aim", "jitter"),
				{ "off", "offset", "center", "random", "skitter" }
			)
			elixir.variables.menu.antiaim.builder[v].jitter_amount = ui.new_slider(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("anti-aim", "jitter amount"),
				-180,
				180,
				0
			)

			elixir.variables.menu.antiaim.builder[v].body_yaw = ui.new_combobox(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("anti-aim", "body yaw"),
				{ "off", "opposite", "jitter", "static" }
			)
			elixir.variables.menu.antiaim.builder[v].body_yaw_amount = ui.new_slider(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("anti-aim", "body yaw amount"),
				-180,
				180,
				0
			)

			elixir.variables.menu.antiaim.builder[v].freestanding_body_yaw = ui.new_checkbox(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("anti-aim", "freestanding body yaw")
			)
			elixir.variables.menu.antiaim.builder[v].edge_yaw =
				ui.new_checkbox("AA", "Anti-aimbot angles", utilities.get_cond_text("anti-aim", "edge yaw"))

			elixir.variables.menu.antiaim.builder[v].roll =
				ui.new_slider("AA", "Anti-aimbot angles", utilities.get_cond_text("anti-aim", "roll"), -45, 45, 0)

			elixir.variables.menu.antiaim.builder[v].fl_enable =
				ui.new_checkbox("AA", "Anti-aimbot angles", utilities.get_cond_text("fake-lag", "enable"))
			elixir.variables.menu.antiaim.builder[v].fl_amount = ui.new_combobox(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("fake-lag", "amount"),
				{ "dynamic", "maximum", "fluctuate" }
			)
			elixir.variables.menu.antiaim.builder[v].fl_variance = ui.new_slider(
				"AA",
				"Anti-aimbot angles",
				utilities.get_cond_text("fake-lag", "variance"),
				0,
				100,
				0,
				true,
				"%"
			)
			elixir.variables.menu.antiaim.builder[v].fl_limit =
				ui.new_slider("AA", "Anti-aimbot angles", utilities.get_cond_text("fake-lag", "limit"), 1, 15, 1)
		end,
		get_state_id = function(player_id)
			local flags = entity.get_prop(player_id, "m_fFlags")

			local vel_x, vel_y, vel_z = entity.get_prop(player_id, "m_vecVelocity")
			local velocity = math.sqrt(vel_x * vel_x + vel_y * vel_y + vel_z * vel_z)

			local airbourne = bit.band(flags, 1) == 0
			local crouching = bit.band(bit.rshift(flags, 1), 1) ~= 0

			local doubletap = ui.get(elixir.variables.references.ragebot.aimbot.double_tap[1])
				and ui.get(elixir.variables.references.ragebot.aimbot.double_tap[2])
			local hideshots = ui.get(elixir.variables.references.antiaim.other.on_shot_aa[1])
				and ui.get(elixir.variables.references.antiaim.other.on_shot_aa[2])

			local slow_motion = ui.get(elixir.variables.references.antiaim.other.slow_motion[1])
				and ui.get(elixir.variables.references.antiaim.other.slow_motion[2])

			local quick_peek_assist = ui.get(elixir.variables.references.ragebot.other.quick_peek_assist)
			local duck_peek_assist = ui.get(elixir.variables.references.ragebot.other.duck_peek_assist)

			for k, v in pairs(elixir.variables.features.antiaim.states) do
				if k == 1 then
					goto continue
				end
				local active = false
				local v = elixir.variables.menu.antiaim.builder[k]
				local activators = ui.get(v.when.activators)
				local velocity_a = utilities.table_contains(activators, "velocity")
				local airbourne_a = utilities.table_contains(activators, "airbourne")
				local crouching_a = utilities.table_contains(activators, "crouching")
				local team_a = utilities.table_contains(activators, "team")
				local warmup_a = utilities.table_contains(activators, "warmup")
				local doubletap_a = utilities.table_contains(activators, "doubletap")
				local hideshots_a = utilities.table_contains(activators, "hideshots")
				local slow_motion_a = utilities.table_contains(activators, "slow motion")
				local quick_peek_a = utilities.table_contains(activators, "quick peek assist")
				local duck_assist_a = utilities.table_contains(activators, "duck peek assist")
				local keybind_a = utilities.table_contains(activators, "keybind")

				if velocity_a then
					local min_velocity = ui.get(v.when.min_velocity)
					local max_velocity = ui.get(v.when.max_velocity)
					if max_velocity == 0 then
						max_velocity = 9999999
					end

					if velocity >= min_velocity and velocity <= max_velocity then
						active = true
					else
						goto continue
					end
				end

				if airbourne_a then
					local when_airbourne = ui.get(v.when.airbourne)
					if when_airbourne == airbourne then
						active = true
					else
						goto continue
					end
				end

				if crouching_a then
					local when_crouching = ui.get(v.when.crouching)
					if when_crouching == crouching then
						active = true
					else
						goto continue
					end
				end

				if team_a then
					local when = ui.get(v.when.team)
					if when == crouching then
						active = true
					else
						goto continue
					end
				end

				if warmup_a then
					local when = ui.get(v.when.warmup)
					if when == crouching then
						active = true
					else
						goto continue
					end
				end

				if doubletap_a then
					local when = ui.get(v.when.doubletap)
					if when == doubletap then
						active = true
					else
						goto continue
					end
				end
				if hideshots_a then
					local when = ui.get(v.when.hideshots)
					if when == hideshots then
						active = true
					else
						goto continue
					end
				end

				if slow_motion_a then
					local when = ui.get(v.when.slow_motion)
					if when == slow_motion then
						active = true
					else
						goto continue
					end
				end

				if quick_peek_a then
					local when = ui.get(v.when.quick_peek_assist)
					if when == quick_peek_assist then
						active = true
					else
						goto continue
					end
				end
				if duck_assist_a then
					local when = ui.get(v.when.duck_peek_assist)
					if when == duck_peek_assist then
						active = true
					else
						goto continue
					end
				end

				if keybind_a then
					local when = ui.get(v.when.keybind)
					if when then
						active = true
					else
						goto continue
					end
				end

				if active then
					return k
				end

				::continue::
			end

			return "default"
		end,
		get_state_name = function(player_id)
			local flags = entity.get_prop(player_id, "m_fFlags")

			local vel_x, vel_y, vel_z = entity.get_prop(player_id, "m_vecVelocity")
			local velocity = math.sqrt(vel_x * vel_x + vel_y * vel_y + vel_z * vel_z)

			local airbourne = bit.band(flags, 1) == 0
			local crouching = bit.band(bit.rshift(flags, 1), 1) ~= 0

			local doubletap = ui.get(elixir.variables.references.ragebot.aimbot.double_tap[1])
				and ui.get(elixir.variables.references.ragebot.aimbot.double_tap[2])
			local hideshots = ui.get(elixir.variables.references.antiaim.other.on_shot_aa[1])
				and ui.get(elixir.variables.references.antiaim.other.on_shot_aa[2])

			local slow_motion = ui.get(elixir.variables.references.antiaim.other.slow_motion[1])
				and ui.get(elixir.variables.references.antiaim.other.slow_motion[2])

			local quick_peek_assist = ui.get(elixir.variables.references.ragebot.other.quick_peek_assist)
			local duck_peek_assist = ui.get(elixir.variables.references.ragebot.other.duck_peek_assist)

			for k, v in pairs(elixir.variables.features.antiaim.states) do
				if k == 1 then
					goto continue
				end
				local active = false
				local v = elixir.variables.menu.antiaim.builder[k]
				local activators = ui.get(v.when.activators)
				local velocity_a = utilities.table_contains(activators, "velocity")
				local airbourne_a = utilities.table_contains(activators, "airbourne")
				local crouching_a = utilities.table_contains(activators, "crouching")
				local doubletap_a = utilities.table_contains(activators, "doubletap")
				local hideshots_a = utilities.table_contains(activators, "hideshots")
				local slow_motion_a = utilities.table_contains(activators, "slow motion")
				local quick_peek_a = utilities.table_contains(activators, "quick peek assist")
				local duck_assist_a = utilities.table_contains(activators, "duck peek assist")

				if velocity_a then
					local min_velocity = ui.get(v.when.min_velocity)
					local max_velocity = ui.get(v.when.max_velocity)
					if max_velocity == 0 then
						max_velocity = 9999999
					end

					if velocity >= min_velocity and velocity <= max_velocity then
						active = true
					else
						goto continue
					end
				end

				if airbourne_a then
					local when_airbourne = ui.get(v.when.airbourne)
					if when_airbourne == airbourne then
						active = true
					else
						goto continue
					end
				end

				if crouching_a then
					local when_crouching = ui.get(v.when.crouching)
					if when_crouching == crouching then
						active = true
					else
						goto continue
					end
				end

				if doubletap_a then
					local when = ui.get(v.when.doubletap)
					if when == doubletap then
						active = true
					else
						goto continue
					end
				end
				if hideshots_a then
					local when = ui.get(v.when.hideshots)
					if when == hideshots then
						active = true
					else
						goto continue
					end
				end

				if slow_motion_a then
					local when = ui.get(v.when.slow_motion)
					if when == slow_motion then
						active = true
					else
						goto continue
					end
				end

				if quick_peek_a then
					local when = ui.get(v.when.quick_peek_assist)
					if when == quick_peek_assist then
						active = true
					else
						goto continue
					end
				end
				if duck_assist_a then
					local when = ui.get(v.when.duck_peek_assist)
					if when == duck_peek_assist then
						active = true
					else
						goto continue
					end
				end

				if active then
					return tostring("" .. ui.get(v.name) .. "")
				end

				::continue::
			end

			return "default"
		end,
	},
	config = {
		export = function()
			local export_table
			export_table = function(in_table)
				local table = {}
				for i, val in pairs(in_table) do
					if type(val) == "table" then
						table[i] = export_table(val)
					else
						local type = ui.type(val)
						if type == "button" then
							goto continue
						end
						if type == "label" then
							goto continue
						end

						if utilities.string_endswith(i, "2") or utilities.string_endswith(i, "deprecated") then
							goto continue
						end

						table[i] = ui.get(val)
					end

					::continue::
				end
				return table
			end

			local config_table = export_table(elixir.variables.menu)
			local config = json.stringify(config_table)
			local b64str = libraries.base64.encode(config)
			return b64str
		end,
		import,
	},
	gradient_text = function(str, lr, lg, lb, rr, rg, rb)
		local text = ""
		for i = 1, #str do
			local ch = str:sub(i, i)

			text = text
				.. string.format(
					"\a%02x%02x%02x%02x" .. ch,
					utilities.calc_gradient_color(i, #str, lr, rr),
					utilities.calc_gradient_color(i, #str, lg, rg),
					utilities.calc_gradient_color(i, #str, lb, rb),
					255
				)
		end

		return text
	end,
}
functions.config.import = function(config)
	local jsstr = libraries.base64.decode(config)
	local js = json.parse(jsstr)

	local count = js.antiaim.condition_count
	if count ~= nil then
		while
			ui.get(elixir.variables.menu.antiaim.condition_count) < count
			or #elixir.variables.menu.antiaim.builder < count + 1
		do
			functions.antiaim.create_condition()
		end
	end

	local import_table
	import_table = function(in_table, base_table)
		for i, val in pairs(in_table) do
			if
				type(val) == "table"
				and not utilities.string_endswith(i, "elements")
				and not utilities.string_endswith(i, "multiselect")
				and not utilities.string_endswith(i, "activators")
			then
				local num = tonumber(i)
				if num ~= nil then
					import_table(val, base_table[num])
				else
					if base_table == nil then
						print(
							"failed to import a part of the config. please make sure you have added a few conditions (the config system doesn't do it and im too lazy to fix it)"
						)
					else
						import_table(val, base_table[i])
					end
				end
			else
				if base_table == nil then
					print(
						"failed to import a part of the config. please make sure you have added a few conditions (the config system doesn't do it and im too lazy to fix it)"
					)
				else
					ui.set(base_table[i], val)
				end
			end
		end
	end

	import_table(js, elixir.variables.menu)
	client.delay_call(1, function()
		functions.antiaim.update_names()
	end)
end
elixir.variables.menu.antiaim.update_names = ui.new_button("AA", "Fake lag", "update names", function()
	functions.antiaim.update_names()
end)
elixir.variables.menu.antiaim.delete_condition = ui.new_button("AA", "Fake lag", "delete", function()
	functions.antiaim.delete_condition(ui.get(elixir.variables.menu.antiaim.condition))
end)
elixir.variables.menu.configs.import = ui.new_button("AA", "Anti-aimbot angles", "import from clipboard", function()
	functions.config.import(libraries.clipboard.get())
end)
elixir.variables.menu.configs.export = ui.new_button("AA", "Anti-aimbot angles", "export to clipboard", function()
	libraries.clipboard.set(functions.config.export())
end)
elixir.variables.menu.configs.default = ui.new_button(
	"AA",
	"Anti-aimbot angles",
	"default config (anti-aim only)",
	function()
		functions.config.import(
			"eyJlbmFibGUiOnRydWUsInRhYiI6ImFudGktYWltIiwiYW50aWFpbSI6eyJlbmFibGUiOnRydWUsImNvbmRpdGlvbiI6MSwia2V5YmluZHMiOnsibWFuX2ZvcndhcmQiOmZhbHNlLCJtYW5fYmFjayI6ZmFsc2UsImZyZWVzdGFuZGluZ19iaW5kIjpmYWxzZSwibWFuX2VuYWJsZSI6dHJ1ZSwibWFuX2J1aWx0aW5pbmQiOnRydWUsIm1hbl9qaXR0ZXIiOmZhbHNlLCJtYW5fYXR0YXJnZXRzIjpmYWxzZSwiZnJlZXN0YW5kaW5nIjp0cnVlLCJtYW5fbGVmdCI6ZmFsc2UsIm1hbl9yaWdodCI6ZmFsc2V9LCJjb25kaXRpb25fY291bnQiOjQsImJ1aWxkZXIiOnsiMiI6eyJwaXRjaCI6ImRvd24iLCJvZmZzZXRfbCI6MiwiZmxfYW1vdW50IjoibWF4aW11bSIsImppdHRlcl9hbW91bnQiOjEsInJvbGwiOjAsInlhd19qaXR0ZXIiOiJjZW50ZXIiLCJmcmVlc3RhbmRpbmdfYm9keV95YXciOnRydWUsImJvZHlfeWF3X2Ftb3VudCI6NywieWF3X2Jhc2UiOiJhdCB0YXJnZXRzIiwieWF3IjoiMTgwIiwib2Zmc2V0X3IiOi0yLCJjdXN0b21fcGl0Y2giOjAsImZsX2xpbWl0Ijo4LCJib2R5X3lhdyI6ImppdHRlciIsImZsX3ZhcmlhbmNlIjowLCJmbF9lbmFibGUiOnRydWUsIndoZW4iOnsiaGlkZXNob3RzIjpmYWxzZSwicXVpY2tfcGVla19hc3Npc3QiOmZhbHNlLCJzbG93X21vdGlvbiI6ZmFsc2UsImFjdGl2YXRvcnMiOlsiYWlyYm91cm5lIiwiY3JvdWNoaW5nIiwiZHVjayBwZWVrIGFzc2lzdCJdLCJtaW5fdmVsb2NpdHkiOjAsImRvdWJsZXRhcCI6ZmFsc2UsImNyb3VjaGluZyI6ZmFsc2UsImFpcmJvdXJuZSI6dHJ1ZSwibWF4X3ZlbG9jaXR5IjowLCJkdWNrX3BlZWtfYXNzaXN0IjpmYWxzZX0sIm5hbWUiOiJhaXIiLCJlZGdlX3lhdyI6ZmFsc2V9LCIzIjp7InBpdGNoIjoiZG93biIsIm9mZnNldF9sIjoxLCJmbF9hbW91bnQiOiJmbHVjdHVhdGUiLCJqaXR0ZXJfYW1vdW50IjoyLCJyb2xsIjowLCJ5YXdfaml0dGVyIjoiY2VudGVyIiwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3Ijp0cnVlLCJib2R5X3lhd19hbW91bnQiOi0xNCwieWF3X2Jhc2UiOiJhdCB0YXJnZXRzIiwieWF3IjoiMTgwIiwib2Zmc2V0X3IiOi0xLCJjdXN0b21fcGl0Y2giOjAsImZsX2xpbWl0Ijo2LCJib2R5X3lhdyI6ImppdHRlciIsImZsX3ZhcmlhbmNlIjowLCJmbF9lbmFibGUiOnRydWUsIndoZW4iOnsiaGlkZXNob3RzIjpmYWxzZSwicXVpY2tfcGVla19hc3Npc3QiOmZhbHNlLCJzbG93X21vdGlvbiI6ZmFsc2UsImFjdGl2YXRvcnMiOlsidmVsb2NpdHkiLCJhaXJib3VybmUiLCJjcm91Y2hpbmciLCJkdWNrIHBlZWsgYXNzaXN0Il0sIm1pbl92ZWxvY2l0eSI6MCwiZG91YmxldGFwIjpmYWxzZSwiY3JvdWNoaW5nIjpmYWxzZSwiYWlyYm91cm5lIjpmYWxzZSwibWF4X3ZlbG9jaXR5Ijo1LCJkdWNrX3BlZWtfYXNzaXN0IjpmYWxzZX0sIm5hbWUiOiJzdGFuZCIsImVkZ2VfeWF3IjpmYWxzZX0sIjQiOnsicGl0Y2giOiJkb3duIiwib2Zmc2V0X2wiOjIsImZsX2Ftb3VudCI6ImZsdWN0dWF0ZSIsImppdHRlcl9hbW91bnQiOi0yLCJyb2xsIjowLCJ5YXdfaml0dGVyIjoiY2VudGVyIiwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3Ijp0cnVlLCJib2R5X3lhd19hbW91bnQiOjEzLCJ5YXdfYmFzZSI6ImF0IHRhcmdldHMiLCJ5YXciOiIxODAiLCJvZmZzZXRfciI6LTIsImN1c3RvbV9waXRjaCI6MCwiZmxfbGltaXQiOjExLCJib2R5X3lhdyI6InN0YXRpYyIsImZsX3ZhcmlhbmNlIjo1NSwiZmxfZW5hYmxlIjp0cnVlLCJ3aGVuIjp7ImhpZGVzaG90cyI6ZmFsc2UsInF1aWNrX3BlZWtfYXNzaXN0IjpmYWxzZSwic2xvd19tb3Rpb24iOmZhbHNlLCJhY3RpdmF0b3JzIjpbImFpcmJvdXJuZSIsImNyb3VjaGluZyJdLCJtaW5fdmVsb2NpdHkiOjAsImRvdWJsZXRhcCI6ZmFsc2UsImNyb3VjaGluZyI6dHJ1ZSwiYWlyYm91cm5lIjp0cnVlLCJtYXhfdmVsb2NpdHkiOjAsImR1Y2tfcGVla19hc3Npc3QiOmZhbHNlfSwibmFtZSI6ImFpcisiLCJlZGdlX3lhdyI6ZmFsc2V9LCI1Ijp7InBpdGNoIjoiZG93biIsIm9mZnNldF9sIjoxLCJmbF9hbW91bnQiOiJtYXhpbXVtIiwiaml0dGVyX2Ftb3VudCI6MSwicm9sbCI6MCwieWF3X2ppdHRlciI6InNraXR0ZXIiLCJmcmVlc3RhbmRpbmdfYm9keV95YXciOnRydWUsImJvZHlfeWF3X2Ftb3VudCI6MCwieWF3X2Jhc2UiOiJhdCB0YXJnZXRzIiwieWF3IjoiMTgwIiwib2Zmc2V0X3IiOi0xLCJjdXN0b21fcGl0Y2giOjAsImZsX2xpbWl0IjoxNSwiYm9keV95YXciOiJqaXR0ZXIiLCJmbF92YXJpYW5jZSI6MCwiZmxfZW5hYmxlIjp0cnVlLCJ3aGVuIjp7ImhpZGVzaG90cyI6ZmFsc2UsInF1aWNrX3BlZWtfYXNzaXN0IjpmYWxzZSwic2xvd19tb3Rpb24iOmZhbHNlLCJhY3RpdmF0b3JzIjpbInZlbG9jaXR5IiwiYWlyYm91cm5lIiwiY3JvdWNoaW5nIl0sIm1pbl92ZWxvY2l0eSI6NSwiZG91YmxldGFwIjpmYWxzZSwiY3JvdWNoaW5nIjpmYWxzZSwiYWlyYm91cm5lIjpmYWxzZSwibWF4X3ZlbG9jaXR5IjoxMTAsImR1Y2tfcGVla19hc3Npc3QiOmZhbHNlfSwibmFtZSI6IndhbGsiLCJlZGdlX3lhdyI6ZmFsc2V9LCJkZWZhdWx0Ijp7InBpdGNoIjoiZG93biIsImJvZHlfeWF3Ijoiaml0dGVyIiwiZmxfdmFyaWFuY2UiOjAsImN1c3RvbV9waXRjaCI6MCwicm9sbCI6MCwieWF3X2ppdHRlciI6ImNlbnRlciIsImZyZWVzdGFuZGluZ19ib2R5X3lhdyI6ZmFsc2UsInlhd19iYXNlIjoiYXQgdGFyZ2V0cyIsImVkZ2VfeWF3IjpmYWxzZSwib2Zmc2V0X3IiOi0zLCJmbF9saW1pdCI6MTMsImZsX2Ftb3VudCI6Im1heGltdW0iLCJqaXR0ZXJfYW1vdW50Ijo2LCJmbF9lbmFibGUiOnRydWUsImJvZHlfeWF3X2Ftb3VudCI6NDcsInlhdyI6IjE4MCIsIm9mZnNldF9sIjozfX19fQ=="
		)
	end
)

local features = {
	antiaim = {
		update_builder = function()
			local states = elixir.variables.features.antiaim.states
			if ui.get(elixir.variables.menu.antiaim.condition) > #states then
				ui.set(elixir.variables.menu.antiaim.condition, 0)
			end
			if ui.get(elixir.variables.menu.antiaim.condition) == #states then
				functions.antiaim.create_condition()
			end

			local vis = ui.get(elixir.variables.menu.enable)
				and ui.get(elixir.variables.menu.tab) == "anti-aim"
				and ui.get(elixir.variables.menu.antiaim.enable)
			local cur_state = ui.get(elixir.variables.menu.antiaim.condition) + 1
			for k = 1, elixir.variables.features.antiaim.max_states do
				local state = k == 1 and "default" or k
				local reftable = elixir.variables.menu.antiaim.builder[state]

				if state ~= "default" then
					ui.set_visible(reftable.name_label, vis and k == cur_state)
					ui.set_visible(reftable.name, vis and k == cur_state)

					local activators = ui.get(reftable.when.activators)
					local velocity = utilities.table_contains(activators, "velocity")
					local airbourne = utilities.table_contains(activators, "airbourne")
					local crouching = utilities.table_contains(activators, "crouching")
					local warmup = utilities.table_contains(activators, "warmup")
					local team = utilities.table_contains(activators, "team")
					local doubletap = utilities.table_contains(activators, "doubletap")
					local hideshots = utilities.table_contains(activators, "hideshots")
					local slow_motion = utilities.table_contains(activators, "slow motion")
					local quick_peek_assist = utilities.table_contains(activators, "quick peek assist")
					local duck_assist = utilities.table_contains(activators, "duck peek assist")
					local keybind = utilities.table_contains(activators, "keybind")
					ui.set_visible(reftable.when.activators, vis and k == cur_state)
					ui.set_visible(reftable.when.min_velocity, vis and k == cur_state and velocity)
					ui.set_visible(reftable.when.max_velocity, vis and k == cur_state and velocity)
					ui.set_visible(reftable.when.airbourne, vis and k == cur_state and airbourne)
					ui.set_visible(reftable.when.crouching, vis and k == cur_state and crouching)
					ui.set_visible(reftable.when.warmup, vis and k == cur_state and warmup)
					ui.set_visible(reftable.when.team, vis and k == cur_state and team)
					ui.set_visible(reftable.when.doubletap, vis and k == cur_state and doubletap)
					ui.set_visible(reftable.when.hideshots, vis and k == cur_state and hideshots)
					ui.set_visible(reftable.when.slow_motion, vis and k == cur_state and slow_motion)
					ui.set_visible(reftable.when.quick_peek_assist, vis and k == cur_state and quick_peek_assist)
					ui.set_visible(reftable.when.duck_peek_assist, vis and k == cur_state and duck_assist)
					ui.set_visible(reftable.when.keybind, vis and k == cur_state and keybind)
				end

				ui.set_visible(reftable.pitch, vis and k == cur_state)
				ui.set_visible(reftable.custom_pitch, vis and k == cur_state and ui.get(reftable.pitch) == "custom")

				ui.set_visible(reftable.yaw_base, vis and k == cur_state)
				ui.set_visible(reftable.yaw, vis and k == cur_state)
				ui.set_visible(reftable.offset_l, vis and k == cur_state and ui.get(reftable.yaw) ~= "off")
				ui.set_visible(reftable.offset_r, vis and k == cur_state and ui.get(reftable.yaw) ~= "off")

				ui.set_visible(reftable.yaw_jitter, vis and k == cur_state)
				ui.set_visible(reftable.jitter_amount, vis and k == cur_state and ui.get(reftable.yaw_jitter) ~= "off")

				ui.set_visible(reftable.body_yaw, vis and k == cur_state)
				ui.set_visible(
					reftable.body_yaw_amount,
					vis
						and k == cur_state
						and ui.get(reftable.body_yaw) ~= "off"
						and ui.get(reftable.body_yaw) ~= "opposite"
				)

				ui.set_visible(reftable.freestanding_body_yaw, vis and k == cur_state)
				ui.set_visible(reftable.edge_yaw, vis and k == cur_state)
				ui.set_visible(reftable.roll, vis and k == cur_state)

				ui.set_visible(reftable.fl_enable, vis and k == cur_state)
				ui.set_visible(reftable.fl_amount, vis and k == cur_state and ui.get(reftable.fl_enable))
				ui.set_visible(reftable.fl_variance, vis and k == cur_state and ui.get(reftable.fl_enable))
				ui.set_visible(reftable.fl_limit, vis and k == cur_state and ui.get(reftable.fl_enable))
			end
		end,
		handle_builder = function()
			-- ui.set(elixir.variables.references.antiaim.enable, ui.get(elixir.variables.menu.antiaim.enable))

			if not ui.get(elixir.variables.menu.antiaim.enable) then
				return
			end
			local fake = utilities.get_fake_amount(entity.get_local_player())
			elixir.variables.features.antiaim.fake = fake

			local state = functions.antiaim.get_state_id(entity.get_local_player())

			local manual = -1
			if ui.get(elixir.variables.menu.antiaim.keybinds.man_enable) then
				local forward = ui.get(elixir.variables.menu.antiaim.keybinds.man_forward)
				local back = ui.get(elixir.variables.menu.antiaim.keybinds.man_back)
				local left = ui.get(elixir.variables.menu.antiaim.keybinds.man_left)
				local right = ui.get(elixir.variables.menu.antiaim.keybinds.man_right)

				if forward then
					manual = 180
				elseif back then
					manual = 0
				elseif left then
					manual = -90
				elseif right then
					manual = 90
				end
			end

			local fs = ui.get(elixir.variables.menu.antiaim.keybinds.freestanding)
				and ui.get(elixir.variables.menu.antiaim.keybinds.freestanding_bind)
			ui.set(elixir.variables.references.antiaim.freestanding[1], fs)
			ui.set(elixir.variables.references.antiaim.freestanding[2], fs and "Always On" or "On hotkey")

			ui.set(
				elixir.variables.references.antiaim.pitch[1],
				ui.get(elixir.variables.menu.antiaim.builder[state].pitch)
			)
			ui.set(
				elixir.variables.references.antiaim.pitch[2],
				ui.get(elixir.variables.menu.antiaim.builder[state].custom_pitch)
			)

			if manual == -1 then
				ui.set(
					elixir.variables.references.antiaim.yaw_base,
					ui.get(elixir.variables.menu.antiaim.builder[state].yaw_base)
				)

				ui.set(
					elixir.variables.references.antiaim.yaw[1],
					ui.get(elixir.variables.menu.antiaim.builder[state].yaw)
				)

				local additional_yaw = 0

				if fake > 0 then
					ui.set(
						elixir.variables.references.antiaim.yaw[2],
						ui.get(elixir.variables.menu.antiaim.builder[state].offset_l) + additional_yaw
					)
				else
					ui.set(
						elixir.variables.references.antiaim.yaw[2],
						ui.get(elixir.variables.menu.antiaim.builder[state].offset_r) + additional_yaw
					)
				end
			else
				ui.set(
					elixir.variables.references.antiaim.yaw_base,
					ui.get(elixir.variables.menu.antiaim.keybinds.man_attargets) and "at targets" or "local view"
				)
				ui.set(elixir.variables.references.antiaim.yaw[1], "180")
				ui.set(elixir.variables.references.antiaim.yaw[2], manual)
			end

			if manual == -1 or ui.get(elixir.variables.menu.antiaim.keybinds.man_jitter) then
				ui.set(
					elixir.variables.references.antiaim.yaw_jitter[1],
					ui.get(elixir.variables.menu.antiaim.builder[state].yaw_jitter)
				)
				ui.set(
					elixir.variables.references.antiaim.yaw_jitter[2],
					ui.get(elixir.variables.menu.antiaim.builder[state].jitter_amount)
				)
			end

			ui.set(
				elixir.variables.references.antiaim.body_yaw[1],
				ui.get(elixir.variables.menu.antiaim.builder[state].body_yaw)
			)
			ui.set(
				elixir.variables.references.antiaim.body_yaw[2],
				ui.get(elixir.variables.menu.antiaim.builder[state].body_yaw_amount)
			)

			ui.set(
				elixir.variables.references.antiaim.freestanding_body_yaw,
				ui.get(elixir.variables.menu.antiaim.builder[state].freestanding_body_yaw)
			)
			ui.set(
				elixir.variables.references.antiaim.edge_yaw,
				ui.get(elixir.variables.menu.antiaim.builder[state].edge_yaw) and manual == -1
			)
			ui.set(elixir.variables.references.antiaim.roll, ui.get(elixir.variables.menu.antiaim.builder[state].roll))

			ui.set(
				elixir.variables.references.antiaim.fake_lag.enable[1],
				ui.get(elixir.variables.menu.antiaim.builder[state].fl_enable)
			)
			ui.set(elixir.variables.references.antiaim.fake_lag.enable[2], "Always on")
			ui.set(
				elixir.variables.references.antiaim.fake_lag.amount,
				ui.get(elixir.variables.menu.antiaim.builder[state].fl_amount)
			)
			ui.set(
				elixir.variables.references.antiaim.fake_lag.variance,
				ui.get(elixir.variables.menu.antiaim.builder[state].fl_variance)
			)
			ui.set(
				elixir.variables.references.antiaim.fake_lag.limit,
				ui.get(elixir.variables.menu.antiaim.builder[state].fl_limit)
			)
		end,
	},
	visuals = {
		slowdown_indicator = {
			handle = function()
				if
					not ui.get(elixir.variables.menu.visuals.slowdown)
					or not ui.get(elixir.variables.menu.visuals.enable)
				then
					return
				end
				local modifier = entity.get_prop(entity.get_local_player(), "m_flVelocityModifier")

				local show = modifier ~= 1.0 and entity.is_alive(entity.get_local_player())
				if ui.is_menu_open() then
					show = true
				end

				local anim = elixir.variables.features.visuals.slowdown_indicator.anim
				if show and anim < 1.0 then
					anim = anim + 4.7 * globals.frametime()
				elseif not show and anim > 0.0 then
					anim = anim - 4.7 * globals.frametime()
				end

				anim = utilities.clamp(anim, 0, 1)
				elixir.variables.features.visuals.slowdown_indicator.anim = anim

				if anim == 0.0 then
					return
				end

				local screen_width, screen_height = client.screen_size()

				local anim = utilities.clamp(anim * 1.2, 0, 1)
				local animpos = utilities.clamp(1 - anim, 0, 1) * 16

				local style = ui.get(elixir.variables.menu.visuals.style)
				local r, g, b, a = ui.get(elixir.variables.menu.visuals.slowdown_color)

				local mid_x = screen_width / 2
				local mid_y = screen_height / 2

				if style == "old" then
					local start_pos_x = mid_x - 40
					local end_pos_x = mid_x + 40

					if anim ~= 0 then
						renderer.blur(start_pos_x, mid_y - 258 - animpos, 80, 29, anim * a, 0.5)
					else
						return
					end

					renderer.rectangle(start_pos_x, mid_y - 258 - animpos, 80, 1, r, g, b, anim * a) -- top left <-> top right
					renderer.rectangle(start_pos_x, mid_y - 258 - animpos, 1, 29, r, g, b, anim * a) -- top left <-> bot left
					renderer.rectangle(end_pos_x, mid_y - 258 - animpos, 1, 29, r, g, b, anim * a) -- top right <-> bot right
					renderer.rectangle(start_pos_x, mid_y - 229 - animpos, 81, 1, r, g, b, anim * a) -- bot left <-> bot right

					renderer.text(mid_x, mid_y - 250 - animpos, 255, 255, 255, anim * a, "c", 0, "SLOWED DOWN")
					renderer.text(
						mid_x,
						mid_y - 237 - animpos,
						255,
						255,
						255,
						anim * a,
						"c",
						0,
						math.floor(modifier * 100) .. "%"
					)
				elseif style == "new pixel" then
					if anim == 0 then
						return
					end

					local anim_breathing = elixir.variables.features.visuals.anim_breathing
					local text = "SLOWED  DOWN  #  " .. math.floor(modifier * 100) .. "%"
					local tx, ty = renderer.measure_text("c-", text)

					utilities.glow(
						mid_x - tx / 2 + 1,
						mid_y - 120 - elixir.variables.features.visuals.warnings_offset - animpos - ty / 2 + 2,
						tx + 1,
						ty - 4,
						7,
						2,
						{ r, g, b, a * anim * anim_breathing * 0.05 },
						{ r, g, b, a * anim * anim_breathing * 0.05 }
					)
					renderer.text(
						mid_x,
						mid_y - 120 - elixir.variables.features.visuals.warnings_offset - animpos,
						r,
						g,
						b,
						a * anim * anim_breathing,
						"c-",
						0,
						text
					)
					elixir.variables.features.visuals.warnings_offset = elixir.variables.features.visuals.warnings_offset
						+ 10
				end
			end,
		},
		low_ammo_warning = {
			handle = function()
				if
					not ui.get(elixir.variables.menu.visuals.low_ammo)
					or not ui.get(elixir.variables.menu.visuals.enable)
				then
					return
				end

				local weapon = entity.get_player_weapon(entity.get_local_player())
				local weapondata = libraries.csgo_weapons(weapon)

				local ammo = entity.get_prop(weapon, "m_iClip1")
				if ammo == nil then
					ammo = 0
				end
				local max_ammo = 0
				if weapondata ~= nil then
					max_ammo = weapondata.primary_clip_size
				end
				if ui.is_menu_open() then
					if ammo <= -1 or max_ammo <= 0 then
						ammo = 1
						max_ammo = 1
					end
				end

				if ammo <= -1 or max_ammo <= 0 then
					return
				end

				local show = (ammo / max_ammo * 100.0) <= ui.get(elixir.variables.menu.visuals.low_ammo_threshold)
					and entity.is_alive(entity.get_local_player())
				if ui.is_menu_open() then
					show = true
				end

				local anim = elixir.variables.features.visuals.low_ammo.anim
				if show and anim < 1.0 then
					anim = anim + 4.7 * globals.frametime()
				elseif not show and anim > 0.0 then
					anim = anim - 4.7 * globals.frametime()
				end

				anim = utilities.clamp(anim, 0, 1)
				elixir.variables.features.visuals.low_ammo.anim = anim

				if anim == 0.0 then
					return
				end

				local screen_width, screen_height = client.screen_size()

				local anim = utilities.clamp(anim * 1.2, 0, 1)
				local animpos = utilities.clamp(1 - anim, 0, 1) * 16

				local style = ui.get(elixir.variables.menu.visuals.style)
				local r, g, b, a = ui.get(elixir.variables.menu.visuals.low_ammo_color)

				local mid_x = screen_width / 2
				local mid_y = screen_height / 2

				if style == "new pixel" then
					if anim == 0 then
						return
					end

					local anim_breathing = elixir.variables.features.visuals.anim_breathing
					local text = "LOW  AMMO  #  " .. ammo
					local tx, ty = renderer.measure_text("c-", text)

					utilities.glow(
						mid_x - tx / 2 + 2,
						mid_y - 120 - elixir.variables.features.visuals.warnings_offset - animpos - ty / 2 + 2,
						tx + 1,
						ty - 4,
						7,
						2,
						{ r, g, b, a * anim * anim_breathing * 0.05 },
						{ r, g, b, a * anim * anim_breathing * 0.05 }
					)
					renderer.text(
						mid_x,
						mid_y - 120 - elixir.variables.features.visuals.warnings_offset - animpos,
						r,
						g,
						b,
						a * anim * anim_breathing,
						"c-",
						0,
						text
					)
					elixir.variables.features.visuals.warnings_offset = elixir.variables.features.visuals.warnings_offset
						+ 10
				end
			end,
		},
		low_hp_warning = {
			handle = function()
				if
					not ui.get(elixir.variables.menu.visuals.low_hp) or not ui.get(elixir.variables.menu.visuals.enable)
				then
					return
				end

				local health = entity.get_prop(entity.get_local_player(), "m_iHealth")
				if health == nil then
					health = 0
				end

				if health <= -1 then
					return
				end

				local show = health <= ui.get(elixir.variables.menu.visuals.low_hp_threshold)
					and entity.is_alive(entity.get_local_player())
				if ui.is_menu_open() then
					show = true
				end

				local anim = elixir.variables.features.visuals.low_hp.anim
				if show and anim < 1.0 then
					anim = anim + 4.7 * globals.frametime()
				elseif not show and anim > 0.0 then
					anim = anim - 4.7 * globals.frametime()
				end

				anim = utilities.clamp(anim, 0, 1)
				elixir.variables.features.visuals.low_hp.anim = anim

				if anim == 0.0 then
					return
				end

				local screen_width, screen_height = client.screen_size()

				local anim = utilities.clamp(anim * 1.2, 0, 1)
				local animpos = utilities.clamp(1 - anim, 0, 1) * 16

				local style = ui.get(elixir.variables.menu.visuals.style)
				local r, g, b, a = ui.get(elixir.variables.menu.visuals.low_hp_color)

				local mid_x = screen_width / 2
				local mid_y = screen_height / 2

				if style == "new pixel" then
					if anim == 0 then
						return
					end

					local anim_breathing = elixir.variables.features.visuals.anim_breathing
					local text = "LOW  HEALTH  #  " .. health
					local tx, ty = renderer.measure_text("c-", text)

					utilities.glow(
						mid_x - tx / 2 + 1,
						mid_y - 120 - elixir.variables.features.visuals.warnings_offset - animpos - ty / 2 + 2,
						tx + 1,
						ty - 4,
						7,
						2,
						{ r, g, b, a * anim * anim_breathing * 0.05 },
						{ r, g, b, a * anim * anim_breathing * 0.05 }
					)
					renderer.text(
						mid_x,
						mid_y - 120 - elixir.variables.features.visuals.warnings_offset - animpos,
						r,
						g,
						b,
						a * anim * anim_breathing,
						"c-",
						0,
						text
					)
					elixir.variables.features.visuals.warnings_offset = elixir.variables.features.visuals.warnings_offset
						+ 10
				end
			end,
		},
		watermark = {
			handle = function()
				if
					not ui.get(elixir.variables.menu.visuals.watermark)
					or not ui.get(elixir.variables.menu.visuals.enable)
				then
					return
				end

				local screen_width, screen_height = client.screen_size()

				local style = ui.get(elixir.variables.menu.visuals.style)
				local r, g, b, a = ui.get(elixir.variables.menu.visuals.watermark_color)

				if style == "old" then
					local watermark_text = "elixir.tech"
					local s_x, s_y = renderer.measure_text("", watermark_text)
					local start_pos_x = screen_width - s_x - 12
					local end_pos_x = screen_width - 5
					local width = end_pos_x - start_pos_x
					local height = s_y + 4
					local pos_y = 5

					renderer.blur(start_pos_x, pos_y, width, height, a, 0.5)

					renderer.rectangle(start_pos_x, pos_y, width, 1, r, g, b, a) -- top left <-> top right
					renderer.rectangle(start_pos_x, pos_y, 1, height, r, g, b, a) -- top left <-> bot left
					renderer.rectangle(end_pos_x, pos_y, 1, height, r, g, b, a) -- top right <-> bot right
					renderer.rectangle(start_pos_x, pos_y + height, width + 1, 1, r, g, b, a) -- bot left <-> bot right

					renderer.text(start_pos_x + 4, pos_y + 2, 255, 255, 255, a, "", 0, watermark_text)
				elseif style == "new pixel" then
					local watermark_text = string.format(
						"\a666666FF‹\a%02x%02x%02xFFELIXIR\a666666FF.\a%02x%02x%02xFFTECH \a666666FF›",
						r,
						g,
						b,
						r,
						g,
						b
					)
					--local s_x, s_y = renderer.measure_text("c-", watermark_text)
					local pos_x = screen_width / 2
					local pos_y = screen_height - 10

					renderer.text(pos_x, pos_y, 255, 255, 255, 255, "c-", 0, watermark_text)
				end
			end,
		},
		manual_indicators = {
			handle_skeet = function()
				if
					not ui.get(elixir.variables.menu.antiaim.enable)
					or not ui.get(elixir.variables.menu.antiaim.keybinds.man_enable)
					or not ui.get(elixir.variables.menu.antiaim.keybinds.man_builtinind)
				then
					return
				end
				local forward = ui.get(elixir.variables.menu.antiaim.keybinds.man_forward)
				local back = ui.get(elixir.variables.menu.antiaim.keybinds.man_back)
				local left = ui.get(elixir.variables.menu.antiaim.keybinds.man_left)
				local right = ui.get(elixir.variables.menu.antiaim.keybinds.man_right)

				if forward then
					renderer.indicator(210, 210, 210, 255, "FORWARD")
				elseif back then
					renderer.indicator(210, 210, 210, 255, "BACK")
				elseif left then
					renderer.indicator(210, 210, 210, 255, "LEFT")
				elseif right then
					renderer.indicator(210, 210, 210, 255, "RIGHT")
				end
			end,
		},
		crosshair_indicators = {
			handle = function()
				local frame = globals.frametime()

				local show_anim = elixir.variables.features.visuals.crosshair_indicators.anims.show
				do
					local show = entity.is_alive(entity.get_local_player())
						and ui.get(elixir.variables.menu.visuals.indicators)
					if show and show_anim < 1.0 then
						show_anim = show_anim + (math.sin(utilities.clamp(show_anim, 0.2, 1)) * frame * 5) + frame * 3
					elseif not show and show_anim > 0.0 then
						show_anim = show_anim - (math.cos(utilities.clamp(show_anim, 0.2, 1)) * frame * 5) - frame * 3
					end

					if not show and show_anim <= 0.0 then
						return
					end

					show_anim = utilities.clamp(show_anim, 0, 1)
					elixir.variables.features.visuals.crosshair_indicators.anims.show = show_anim
				end

				local scope_anim = elixir.variables.features.visuals.crosshair_indicators.anims.scope
				do
					local scoped = elixir.variables.features.visuals.crosshair_indicators.scoped
					if not scoped and scope_anim > 0.0 then
						scope_anim = scope_anim
							- (math.cos(utilities.clamp(scope_anim, 0.2, 1)) * frame * 5)
							- frame * 3
					elseif scoped and scope_anim < 1.0 then
						scope_anim = scope_anim
							+ (math.sin(utilities.clamp(scope_anim, 0.2, 1)) * frame * 5)
							+ frame * 3
					end
					scope_anim = utilities.clamp(scope_anim, 0, 1)
					elixir.variables.features.visuals.crosshair_indicators.anims.scope = scope_anim
				end

				local screen_width, screen_height = client.screen_size()
				local mid_x = screen_width / 2
				local mid_y = screen_height / 2

				local style = ui.get(elixir.variables.menu.visuals.style)
				local r, g, b, a = ui.get(elixir.variables.menu.visuals.indicators_color)

				local state = "DEFAULT"
				local show_state = false
				local elements_parsed = {}
				do
					local elements = ui.get(elixir.variables.menu.visuals.indicators_elements)
					for k, v in pairs(elements) do
						local show = false
						local r, g, b, a = 255, 255, 255, 255
						local str = v:upper()
						if v == "anti-aim state" then
							local player = entity.get_local_player()
							if entity.is_alive(player) then
								state = functions.antiaim.get_state_name(player):upper()
								show_state = true
							else
								state = "DEAD"
								show_state = false
							end
						elseif v == "doubletap" then
							str = "DT"
							show = ui.get(elixir.variables.references.ragebot.aimbot.double_tap[1])
								and ui.get(elixir.variables.references.ragebot.aimbot.double_tap[2])
						elseif v == "on-shot" then
							local dt = ui.get(elixir.variables.references.ragebot.aimbot.double_tap[1])
								and ui.get(elixir.variables.references.ragebot.aimbot.double_tap[2])
							local hs = ui.get(elixir.variables.references.antiaim.other.on_shot_aa[1])
								and ui.get(elixir.variables.references.antiaim.other.on_shot_aa[2])
							str = "OS"
							show = not dt and hs
						elseif v == "minimum damage" then
							local dmg = ui.get(elixir.variables.references.ragebot.aimbot.damage_override[3])
							if dmg < 100 then
								str = "DMG (" .. dmg .. ")"
							elseif dmg == 100 then
								str = "DMG (hp)"
							else
								str = "DMG (hp + " .. dmg - 100 .. ")"
							end
							show = ui.get(elixir.variables.references.ragebot.aimbot.damage_override[1])
								and ui.get(elixir.variables.references.ragebot.aimbot.damage_override[2])
						end

						if show then
							table.insert(elements_parsed, #elements_parsed + 1, { str, r, g, b, a })
						end
					end
					table.sort(elements_parsed, function(a, b)
						local s1 = a[1]
						local s2 = b[1]
						return #s1 > #s2
					end)
				end

				if style == "new pixel" then
					local tx, ty = renderer.measure_text("c-", text)
					if show_anim == 0 then
						return
					end

					local show_anim = utilities.clamp(show_anim * 1.2, 0, 1)
					local animpos = utilities.clamp(1 - show_anim, 0, 1) * 16

					local text = ""
					do -- light anim
						local r2, g2, b2 =
							utilities.clamp(r / 2, 0, 255),
							utilities.clamp(g / 2, 0, 255),
							utilities.clamp(b / 2, 0, 255)

						local light_pos = elixir.variables.features.visuals.crosshair_indicators.light_pos
						local fake = elixir.variables.features.visuals.crosshair_indicators.fake
						if fake > 0 and light_pos > 0.0 then
							light_pos = light_pos - frame * 6.7
						elseif fake < 0 and light_pos < 1.0 then
							light_pos = light_pos + frame * 6.7
						else
							elixir.variables.features.visuals.crosshair_indicators.fake =
								elixir.variables.features.antiaim.fake
						end
						light_pos = utilities.clamp(light_pos, 0, 1)
						elixir.variables.features.visuals.crosshair_indicators.light_pos = light_pos

						local chars = "ELIXIR"
						for i = 1, #chars do
							local char = chars:sub(i, i)
							if char == "." then
								text = text .. "\aAAAAAAFF."
							else
								text = text
									.. string.format(
										"\a%02x%02x%02x%02x" .. char,
										utilities.clamp(
											math.floor(utilities.calc_light_color(i, light_pos, #chars, r2, r2, r2)),
											0,
											255
										),
										utilities.clamp(
											math.floor(utilities.calc_light_color(i, light_pos, #chars, g2, g2, g2)),
											0,
											255
										),
										utilities.clamp(
											math.floor(utilities.calc_light_color(i, light_pos, #chars, b2, b2, b2)),
											0,
											255
										),
										a * show_anim
									)
							end
						end
					end

					utilities.glow(
						mid_x + scope_anim * (tx / 2 + 20) - tx,
						mid_y + 22 - ty / 2,
						tx * 2 + 4,
						ty / 2 + 1,
						7,
						2,
						{ r, g, b, a * show_anim * 0.08 },
						{ r, g, b, a * show_anim * 0.08 }
					)
					renderer.text(
						mid_x + scope_anim * (tx / 2 + 20),
						mid_y + 20 - animpos,
						255,
						255,
						255,
						255 * show_anim,
						"c-",
						0,
						text
					)

					local cur_y_offset = ty

					if show_state then
						local r, g, b, a = ui.get(elixir.variables.menu.visuals.indicators_color)
						local stx = renderer.measure_text("c-", state)
						renderer.text(
							mid_x + scope_anim * (stx / 2 + 14),
							mid_y + cur_y_offset - animpos + 20,
							r,
							g,
							b,
							a * show_anim,
							"c-",
							0,
							state
						)

						cur_y_offset = cur_y_offset + ty
					end

					for k, v in pairs(elements_parsed) do
						local stx = renderer.measure_text("c-", v[1])
						renderer.text(
							mid_x + scope_anim * (stx / 2 + 14),
							mid_y + cur_y_offset - animpos + 20,
							v[2],
							v[3],
							v[4],
							v[5] * show_anim,
							"c-",
							0,
							v[1]
						)

						cur_y_offset = cur_y_offset + ty
					end
				end
			end,
		},
	},
	miscellaneous = {
		aimbot_logs = {
			net_update_end = function()
				local me = entity.get_local_player()
				local players = utilities.get_entities(true, true)
				local m_tick_base = entity.get_prop(me, "m_nTickBase")

				elixir.variables.features.miscellaneous.aimbot_logs.cl_data.tick_shifted = false

				if m_tick_base ~= nil then
					if
						elixir.variables.features.miscellaneous.aimbot_logs.cl_data.tick_base ~= 0
						and m_tick_base < elixir.variables.features.miscellaneous.aimbot_logs.cl_data.tick_base
					then
						elixir.variables.features.miscellaneous.aimbot_logs.cl_data.tick_shifted = true
					end

					elixir.variables.features.miscellaneous.aimbot_logs.cl_data.tick_base = m_tick_base
				end

				for i = 1, #players do
					local idx = players[i]
					local prev_tick = elixir.variables.features.miscellaneous.aimbot_logs.sim_ticks[idx]

					if entity.is_dormant(idx) or not entity.is_alive(idx) then
						elixir.variables.features.miscellaneous.aimbot_logs.sim_ticks[idx] = nil
						elixir.variables.features.miscellaneous.aimbot_logs.net_data[idx] = nil
					else
						local player_origin = { entity.get_origin(idx) }
						local simulation_time = utilities.time_to_ticks(entity.get_prop(idx, "m_flSimulationTime"))

						if prev_tick ~= nil then
							local delta = simulation_time - prev_tick.tick

							if delta < 0 or delta > 0 and delta <= 64 then
								local m_fFlags = entity.get_prop(idx, "m_fFlags")

								local diff_origin = libraries.vector(
									player_origin[1],
									player_origin[2],
									player_origin[3]
								) - libraries.vector(
									prev_tick.origin[1],
									prev_tick.origin[2],
									prev_tick.origin[3]
								)
								local teleport_distance = libraries.vector(diff_origin.x, diff_origin.y, 0.0):length()

								elixir.variables.features.miscellaneous.aimbot_logs.net_data[idx] = {
									tick = delta - 1,

									origin = player_origin,
									tickbase = delta < 0,
									lagcomp = teleport_distance > 4096,
								}
							end
						end

						elixir.variables.features.miscellaneous.aimbot_logs.sim_ticks[idx] = {
							tick = simulation_time,
							origin = player_origin,
						}
					end
				end
			end,
			fire = function(event)
				local data = event

				local plist_sp = plist.get(event.target, "Override safe point")
				local force_safe_point = ui.get(elixir.variables.references.ragebot.aimbot.force_safe_point)

				if elixir.variables.features.miscellaneous.aimbot_logs.net_data[event.target] == nil then
					elixir.variables.features.miscellaneous.aimbot_logs.net_data[event.target] = {}
				end

				data.teleported = elixir.variables.features.miscellaneous.aimbot_logs.net_data[event.target].lagcomp
					or false
				data.choke = elixir.variables.features.miscellaneous.aimbot_logs.net_data[event.target].tick or "?"
				data.self_choke = globals.chokedcommands()
				data.safe_point = ({
					["Off"] = "off",
					["On"] = true,
					["-"] = force_safe_point,
				})[plist_sp]

				elixir.variables.features.miscellaneous.aimbot_logs.data[event.id] = data
			end,
			hit = function(event)
				if
					not ui.get(elixir.variables.menu.miscellaneous.aimbot_logs)
					or elixir.variables.features.miscellaneous.aimbot_logs.data[event.id] == nil
				then
					return
				end

				local on_fire_data = elixir.variables.features.miscellaneous.aimbot_logs.data[event.id]
				local name = string.lower(entity.get_player_name(event.target))
				local hgroup = elixir.hitgroup_names[event.hitgroup + 1] or "unknown"
				local aimed_hgroup = elixir.hitgroup_names[on_fire_data.hitgroup + 1] or "unknown"
				local hitchance = math.floor(on_fire_data.hit_chance + 0.5) .. "%"
				local health = entity.get_prop(event.target, "m_iHealth")

				print(
					string.format(
						"Hit %s's %s for %ihp (expected: %ihp) (remaining: %ihp) (aimed at: %s) (hitchance: %s)",
						name,
						hgroup,
						event.damage,
						on_fire_data.damage,
						health,
						aimed_hgroup,
						hitchance
					)
				)
			end,
			miss = function(event)
				if
					not ui.get(elixir.variables.menu.miscellaneous.aimbot_logs)
					or elixir.variables.features.miscellaneous.aimbot_logs.data[event.id] == nil
				then
					return
				end

				local on_fire_data = elixir.variables.features.miscellaneous.aimbot_logs.data[event.id]
				local name = string.lower(entity.get_player_name(event.target))
				local hgroup = elixir.hitgroup_names[event.hitgroup + 1] or "unknown"
				local hitchance = math.floor(on_fire_data.hit_chance + 0.5) .. "%"

				print(
					string.format(
						"Missed %s's %s due to %s (expected: %ihp) (hitchance: %s)",
						name,
						hgroup,
						event.reason == "?" and "resolver" or event.reason,
						on_fire_data.damage,
						hitchance
					)
				)
			end,
		},
		clantag = {
			handle = function()
				if
					ui.get(elixir.variables.menu.miscellaneous.enable)
					and ui.get(elixir.variables.menu.miscellaneous.clantag)
				then
					local tick = math.floor(globals.tickcount() / 75)
					local tag = tick % #elixir.clantag + 1

					local clantag = elixir.clantag[tag]

					if clantag == elixir.variables.features.miscellaneous.clantag_last then
						return
					end
					elixir.variables.features.miscellaneous.clantag_last = clantag
					elixir.variables.features.miscellaneous.clantag_back = true

					client.set_clan_tag(clantag)
				elseif elixir.variables.features.miscellaneous.clantag_back then
					client.set_clan_tag()
				end
			end,
		},
		killsay = {
			handle = function(event)
				if
					ui.get(elixir.variables.menu.miscellaneous.enable)
					and ui.get(elixir.variables.menu.miscellaneous.killsay)
				then
					local victim = event.userid
					local attacker = event.attacker
					if victim == nil or attacker == nil then
						return
					end

					local victim_id = client.userid_to_entindex(victim)
					local attacker_id = client.userid_to_entindex(attacker)
					if
						not entity.is_alive(attacker_id)
						or not entity.is_enemy(victim_id)
						or attacker_id ~= entity.get_local_player()
					then
						return
					end

					client.delay_call(ui.get(elixir.variables.menu.miscellaneous.killsay_delay) / 10, function()
						client.exec("say ", elixir.killsay[math.random(1, #elixir.killsay)])
					end)
				end
			end,
		},
		resolver = {
			Player = {
				success = false,

				player = nil,
				entity = nil,

				anim_state = nil,
				anim_layer = nil,

				weapon_data = nil,
				velocity = nil,

				username = nil,

				origin = nil,
				origin_old = nil,

				old_yaw_delta = nil,
				last_jitter = nil,

				latency = 0,
			},
			Context = {
				players = {},
			},
			Instance = nil,
			Process = nil,
		},
	},
}

local resolver_debug_data = {}

do -- resolver functions
	do -- Player
		function features.miscellaneous.resolver.Player:Begin(player)
			local ent = libraries.entity.new(player)
			if not ent then
				return
			end

			self.player = player
			self.entity = ent

			self.anim_state = ent:get_anim_state()
			self.anim_layer = ent:get_anim_overlay(6)

			self.weapon_data = libraries.csgo_weapons(entity.get_player_weapon(player))

			self.latency = entity.get_prop(entity.get_player_resource(), "m_iPing", self.player) / 1000
			self.velocity = libraries.vector(entity.get_prop(player, "m_vecVelocity"))
				+ (libraries.vector(entity.get_prop(player, "m_vecVelocity")) * self.latency)

			self.username = entity.get_player_name(player)

			self.origin = libraries.vector(entity.get_origin(self.player))

			-- LBY Target
			self.lby_target = entity.get_prop(self.player, "m_flLowerBodyYawTarget")
			if self.lby_target == nil then
				self.lby_target = 0
			end

			-- Eye Angles Y (Prop)
			self.eye_angles_y_prop = entity.get_prop(self.player, "m_angEyeAngles[1]")
			if self.eye_angles_y_prop == nil then
				self.eye_angles_y_prop = 0
			end

			-- Eye Angles Y (Anim)
			self.eye_angles_y = self.anim_state.eye_angles_y
			if self.eye_angles_y == nil then
				self.eye_angles_y = 0
			end

			-- Current Feet Yaw
			self.current_feet_yaw = self.anim_state.current_feet_yaw
			if self.current_feet_yaw == nil then
				self.current_feet_yaw = 0
			end

			-- Goal Feet Yaw
			self.goal_feet_yaw = self.anim_state.goal_feet_yaw
			if self.goal_feet_yaw == nil then
				self.goal_feet_yaw = 0
			end

			-- Torso Yaw
			self.torso_yaw = self.anim_state.torso_yaw
			if self.torso_yaw == nil then
				self.torso_yaw = 0
			end

			-- Yaw PoseParam
			self.yaw_poseparam = entity.get_prop(self.player, "m_flPoseParameter", 11)
			if self.yaw_poseparam == nil then
				self.yaw_poseparam = 0
			end

			self.success = true
		end

		function features.miscellaneous.resolver.Player:End()
			self.origin_old = self.origin
		end

		function features.miscellaneous.resolver.Player:GetMaxWeaponSpeed()
			local flMaxSpeed = entity.get_player_weapon(self.m_pPlayer)
					and math.max(self.m_pWeaponData.max_player_speed, 0.001)
				or 260.0

			return flMaxSpeed
		end

		function features.miscellaneous.resolver.Player:GetRunningSpeed()
			return utilities.clamp(math.max(self.velocity:length2d(), 260) / (self:GetMaxWeaponSpeed() * 0.520), 0, 1)
		end

		function features.miscellaneous.resolver.Player:GetDuckingSpeed()
			return utilities.clamp(math.max(self.velocity:length2d(), 260) / (self:GetMaxWeaponSpeed() * 0.340), 0, 1)
		end

		function features.miscellaneous.resolver.Player:GetYawModifier()
			local yaw_mod = (
				(((self.anim_state.stop_to_full_running_fraction * -0.3) - 0.2) * self:GetRunningSpeed()) + 1
			)
			if self.anim_state.duck_amount > 0 then
				yaw_mod = yaw_mod + (self.anim_state.duck_amount * self:GetDuckingSpeed() * (0.5 - yaw_mod))
			end

			return yaw_mod
		end

		function features.miscellaneous.resolver.Player:GetMaxDesync()
			if self.player == nil then return 0.0 end
			if self.anim_state == nil then return 0.0 end

			local speed_factor = utilities.clamp(self.anim_state.feet_speed_forwards_or_sideways, 0.0, 1.0)
			local avg_speed_factor = (self.anim_state.stop_to_full_running_fraction * -0.3 - 0.2) * speed_factor + 1.0

			local duck_amount = self.anim_state.duck_amount

			if duck_amount > 0 then
				local max_velocity = utilities.clamp(self.anim_state.feet_speed_unknown_forwards_or_sideways, 0.0, 1.0)
				local duck_speed = duck_amount * max_velocity

				avg_speed_factor = avg_speed_factor + duck_speed * (0.5 - avg_speed_factor)
			end

			local desync_adjustment = self:GetDesyncAdjustment()
			--return desync_adjustment * avg_speedfactor
			return avg_speedfactor
		end

		function features.miscellaneous.resolver.Player:GetDesyncAdjustment()
			local anim_state_ptr = libraries.ffi.cast("void***", self.anim_state)
			local desync_adjustment = libraries.ffi.cast("float*", libraries.ffi.cast("char*", anim_state_ptr) + 0x334)[0]

			return desync_adjustment
		end

		function features.miscellaneous.resolver.Player:GetShiftedTicks()
			if not self.origin_old then
				return 0
			end

			local distance = math.abs((self.origin - self.origin_old):length())

			local shift = distance / self.velocity:length()

			shift = shift == math.huge and 1 or shift + 1
			shift = shift ~= shift and 1 or shift

			return shift
		end
		function features.miscellaneous.resolver.Player:GetChokedCommands()
			if entity.is_dormant(self.player) then
				return 1
			end
			local player_sim_time = entity.get_prop(self.player, "m_flSimulationTime")
			if player_sim_time == nil then
				player_sim_time = 0
			end

			local ret = math.max(0.0, globals.curtime() - player_sim_time - client.latency())
			ret = ret / globals.tickinterval()
			ret = ret + 0.5

			return math.ceil(ret)
		end

		function features.miscellaneous.resolver.Player:GetSideA()
			local left_delta = math.abs(self.anim_layer.playback_rate - 0.012082360787823) -- avg from collected data
			local right_delta = math.abs(self.anim_layer.playback_rate - 0.0095022687893469) -- avg from collected data

			if left_delta == right_delta then return 0 end
			return left_delta < right_delta and -1 or 1
		end
		function features.miscellaneous.resolver.Player:GetSideB()
			return self:GetSideA()
		end

		function features.miscellaneous.resolver.Player:GetSide()
			return self:GetSideB()
		end

		function features.miscellaneous.resolver.Player:DetectJitter()
			local jitter = 0

			local method = ui.get(elixir.variables.menu.miscellaneous.resolver_jitter_detection)
			if method == "animations" then
				jitter = utilities.angle_difference_abs(self.eye_angles_y_prop, self.eye_angles_y)
			elseif method == "lby" then
				jitter = utilities.angle_difference_abs(self.lby_target, self.eye_angles_y)
			end
			

			if self.last_jitter == nil then
				self.last_jitter = 0
			end
			if jitter < -0.5 or jitter > 0.5 then
				self.last_jitter = jitter
			else
				jitter = self.last_jitter
			end

			return jitter
		end

		function features.miscellaneous.resolver.Player:GetDesyncUnclamped()
			if ui.get(elixir.variables.menu.miscellaneous.resolver_version) == "old" then
				local delta = math.rad(
					math.abs(self.anim_state.torso_yaw - self.anim_state.goal_feet_yaw - self.anim_state.max_yaw)
				)
				local sin = math.sin(delta)
				local cos = math.cos(delta)
				local tangens = math.atan2(cos, sin)
				local sine = math.deg(math.sin(tangens))
				local cosine = math.deg(math.cos(tangens))
				local asine = math.abs(sine)
				local acosine = math.abs(cosine)

				if acosine > asine then
					return sine
				end
				if acosine < asine then
					return cosine
				end

				return 0
			elseif ui.get(elixir.variables.menu.miscellaneous.resolver_version) == "stable" then
				local delta = math.rad(
					math.floor(
						math.abs(
							self.anim_state.torso_yaw
								- math.abs(self.anim_state.goal_feet_yaw - self.anim_state.current_feet_yaw)
						)
					)
				)
				--math.rad(math.abs(self.anim_state.max_yaw - self.anim_state.goal_feet_yaw))
				local sin = math.sin(delta)
				local cos = math.cos(delta)
				local tangens = math.atan2(sin, cos) --math.atan(delta)
				local sine = math.sin(tangens)
				local cosine = math.cos(tangens)
				-- local asine = math.abs(sine)
				-- local acosine = math.abs(cosine)

				local ret = math.deg(math.atan2(sine, cosine)) / math.pi
				--print("s: " .. sine .. " | c: " .. cosine .. " | t: " .. tangens .. " | desync: " .. ret .. " | ym: " .. self:GetYawModifier())

				return -ret
			elseif ui.get(elixir.variables.menu.miscellaneous.resolver_version) == "experimental" then
				if entity.is_dormant(self.player) then
					return 0
				end
				local desync = 0

				local last_lby_time = self.anim_state.last_lby_time

				if last_lby_time == nil then
					last_lby_time = 0
				end

				local jitter = self:DetectJitter()
				local jitter_desync = 0
				if jitter > 1 then
					jitter_desync = math.log(jitter, 10 - utilities.clamp(self:GetChokedCommands(), 0, 8))
					if jitter_desync > -1 and jitter_desync < 1 then
						jitter_desync = 0
					end
				end

				--local yaw = (math.abs(self.yaw_poseparam * 116) - 58)
				--	* ((self.eye_angles_y_prop - self.yaw_poseparam * 360 + 180) / 360)
				local yaw = utilities.angle_difference_abs(self.eye_angles_y_prop, self.yaw_poseparam * 360 - 180)
				local yaw_radians = math.rad(yaw)

				local sine = math.sin(yaw_radians)
				local cosine = math.cos(yaw_radians)

				local delta = math.atan2(cosine, sine)
				local degrees = math.deg(delta)

				--local desync = math.abs(degrees)
				local desync = degrees
				desync = desync + jitter_desync
				desync = utilities.clamp(desync, -58, 58)
				desync = desync * self:GetSide()
				desync = desync * -1

				local player_data = {}
				player_data.max_desync = self:GetMaxDesync()
				player_data.side = self:GetSide()
				player_data.desync = desync
				player_data.jitter = jitter

				player_data.min_yaw = self.anim_state.min_yaw
				player_data.max_yaw = self.anim_state.max_yaw
				player_data.anim_state = self.anim_state
				player_data.delta = math.deg(delta)
				player_data.choke = self:GetChokedCommands()
				resolver_debug_data[entity.get_player_name(self.player)] = player_data

				self.old_yaw_delta = desync
				return desync
			end
		end

		function features.miscellaneous.resolver.Player:GetDesync()
			return utilities.clamp(
				self:GetDesyncUnclamped(),
				58 * -1,
				58
			)
		end
	end
	do -- Context
		function features.miscellaneous.resolver.Context:ResetData()
			self.players = {}
		end

		function features.miscellaneous.resolver.Context:GetPlayer(player)
			return self.players[entity.get_steam64(player)] and self.players[entity.get_steam64(player)]
				or self:CreatePlayer(player)
		end

		function features.miscellaneous.resolver.Context:CreatePlayer(player)
			local resplayer = features.miscellaneous.resolver.Player
			resplayer:Begin(player)

			self.players[entity.get_steam64(player)] = resplayer

			return self.players[entity.get_steam64(player)]
		end
	end

	features.miscellaneous.resolver.Instance = features.miscellaneous.resolver.Context
	function features.miscellaneous.resolver.Process(player)
		local resplayer = features.miscellaneous.resolver.Instance:GetPlayer(player)

		resplayer:Begin(player)

		plist.set(player, "Correction active", true)
		plist.set(player, "Force body yaw", true)
		plist.set(player, "Force body yaw value", resplayer:GetDesync())

		resplayer:End()
	end
end

client.set_event_callback("paint_ui", function()
	functions.skeet_menu.set_visible(not ui.get(elixir.variables.menu.enable))
	functions.menu.main.update()
	functions.menu.antiaim.update()
	functions.menu.visuals.update()
	functions.menu.miscellaneous.update()

	features.antiaim.update_builder()
end)

client.set_event_callback("paint", function()
	elixir.variables.features.visuals.warnings_offset = 0

	features.visuals.slowdown_indicator.handle()
	features.visuals.low_hp_warning.handle()
	features.visuals.low_ammo_warning.handle()
	features.visuals.watermark.handle()
	features.visuals.crosshair_indicators.handle()
	features.visuals.manual_indicators.handle_skeet()

	features.miscellaneous.clantag.handle()

	do -- resolver data
		if
			ui.get(elixir.variables.menu.miscellaneous.enable)
			and ui.get(elixir.variables.menu.miscellaneous.resolver)
			and ui.get(elixir.variables.menu.miscellaneous.resolver_version) == "experimental"
		then
			local x = 1600
			local y = 10
			renderer.text(x, y, 255, 255, 255, 255, "br", 0, "\aCCBBFFFFRESOLVER")

			local offset = 13
			function render_playerdata(v)
				local name = entity.get_player_name(v)
				local data = resolver_debug_data[name]
				if data == nil then
					return
				end

				local side = "^"
				if data.side == 1 then
					side = ">"
				elseif data.side == -1 then
					side = "<"
				end

				local delta = data.delta
				local deltachar = ""
				if delta >= 0 then
					deltachar = "+"
				else
					deltachar = "–"
				end
				delta = math.abs(delta)

				local jitter = math.abs(data.jitter)
				local desync = math.abs(data.desync)
				-- Δ λ ρ
				-- \aCCBBFFFFΔ\aBBBBBBFF: \aCCBBFFFF%s%03d\aBBBBBBFF;

				renderer.text(
					x,
					y + offset,
					255,
					255,
					255,
					255,
					"r",
					0,
					string.format(
						"\aCCBBFFFF%s \a666666FF› \aCCBBFFFFjitter\a666666FF: \aCCBBFFFF%02d\a666666FF; \aCCBBFFFFdesync\a666666FF: \aCCBBFFFF%02d°\a666666FF; \aCCBBFFFFside\a666666FF: \aCCBBFFFF%s",
						name,
						jitter,
						desync,
						side
					)
				)
				offset = offset + 13
			end
			if not ui.get(elixir.variables.menu.miscellaneous.resolve_only_target) then
				local players = entity.get_players(not ui.get(elixir.variables.menu.miscellaneous.resolve_teammates))
				for k, v in pairs(players) do
					if not entity.is_alive(v) then
						return
					end
					render_playerdata(v)
				end
			else
				local target = client.current_threat()
				if target == nil then return end
				if not entity.is_alive(target) then
					return
				end
				render_playerdata(target)
			end
		end
	end

	do -- breathing anim
		local anim_breathing = elixir.variables.features.visuals.anim_breathing
		local switch = elixir.variables.features.visuals.breath_switch
		local breath_speed = ui.get(elixir.variables.menu.visuals.breath_speed) / 6 + 0.4

		if anim_breathing <= 0.3 or anim_breathing >= 0.95 then
			switch = switch * -1
			elixir.variables.features.visuals.breath_switch = switch
		end

		if switch == 1 then
			anim_breathing = anim_breathing + breath_speed * globals.frametime()
		else
			anim_breathing = anim_breathing - breath_speed * globals.frametime()
		end

		elixir.variables.features.visuals.anim_breathing = utilities.clamp(anim_breathing, 0.3, 1)
	end
end)

client.set_event_callback("pre_render", function()
	do
		local enabled = ui.get(elixir.variables.menu.visuals.bloom) and ui.get(elixir.variables.menu.visuals.enable)
		if enabled then
			ui.set(elixir.variables.references.visuals.effects.disable_post_processing, false)
		end
		local bloom = enabled and (1.0 - ui.get(elixir.variables.menu.visuals.bloom_amount) / 100.0) or 1.0
		local r_mul = enabled and ui.get(elixir.variables.menu.visuals.bloom_red_mul) / 100.0 or 0.3
		local g_mul = enabled and ui.get(elixir.variables.menu.visuals.bloom_green_mul) / 100.0 or 0.59
		local b_mul = enabled and ui.get(elixir.variables.menu.visuals.bloom_blue_mul) / 100.0 or 0.11
		elixir.variables.cvars.r_bloomtintexponent:set_float(bloom)
		elixir.variables.cvars.r_bloomtintr:set_float(r_mul)
		elixir.variables.cvars.r_bloomtintg:set_float(g_mul)
		elixir.variables.cvars.r_bloomtintb:set_float(b_mul)
	end
	do
		local enabled = ui.get(elixir.variables.menu.visuals.aspect_ratio)
			and ui.get(elixir.variables.menu.visuals.enable)
		local mode = ui.get(elixir.variables.menu.visuals.ar_mode)
		local flt = 0

		if mode == "float" then
			flt = ui.get(elixir.variables.menu.visuals.ar_float) / 100
		elseif mode == "display size" then
			local x = ui.get(elixir.variables.menu.visuals.ar_x)
			local y = ui.get(elixir.variables.menu.visuals.ar_y)
			flt = x / (y == 0 and y + 1 or y)
		end

		elixir.variables.cvars.r_aspectratio:set_float(flt)
	end
end)

client.set_event_callback("run_command", function(cmd)
	features.antiaim.handle_builder()

	elixir.variables.features.visuals.crosshair_indicators.scoped = entity.get_prop(
		entity.get_local_player(),
		"m_bIsScoped"
	) == 1

	return cmd
end)

local switch = false
client.set_event_callback("setup_command", function(cmd)
	local native_cmd = libraries.ffi.cast(ffi_structs.usercmd, cmd)

	if
		ui.get(elixir.variables.menu.miscellaneous.enable)
		and ui.get(elixir.variables.menu.miscellaneous.exploits.enable)
		and ui.get(elixir.variables.menu.miscellaneous.exploits.flag)
		and cmd.chokedcommands < 2
	then
		if switch and not cmd.in_attack then
			entity.set_prop(entity.get_local_player(), "m_fFlags", math.random(0, 1) == 0 and bit.lshift(1, 9) or 0)
			entity.set_prop(entity.get_local_player(), "m_bIsScoped", 1)
			entity.set_prop(entity.get_local_player(), "m_flLowerBodyYawTarget", math.random(-180, 180))
			entity.set_prop(entity.get_local_player(), "m_nSequence", 0)
			entity.set_prop(entity.get_local_player(), "m_flPlaybackRate", 0)
			entity.set_prop(entity.get_local_player(), "m_flCycle", 0)

			cmd.allow_send_packet = false
		end

		cmd.force_defensive = switch
		cmd.no_choke = switch
		cmd.quick_stop = switch

		native_cmd.uImpulse = switch and 202 or 100
		native_cmd.iRandomSeed = math.random(100, 1000)

		switch = not switch
	end

	return cmd
end)

client.set_event_callback("player_hurt", function(event) end)

local once = false
client.set_event_callback("net_update_start", function()
	if ui.get(elixir.variables.menu.miscellaneous.enable) and ui.get(elixir.variables.menu.miscellaneous.resolver) then
		if not ui.get(elixir.variables.menu.miscellaneous.resolve_only_target) then
			local players = entity.get_players(not ui.get(elixir.variables.menu.miscellaneous.resolve_teammates))
			for idx, player in pairs(players) do
				features.miscellaneous.resolver.Process(player)
			end
		else
			local target = client.current_threat()
			if target == nil then return end
			features.miscellaneous.resolver.Process(target)
		end
		once = true
	elseif once then
		for idx = 0, 128 do
			plist.set(idx, "Correction active", true)
			plist.set(idx, "Force body yaw", false)
			plist.set(idx, "Force body yaw value", 0)
		end
		once = false
	end
end)

client.set_event_callback("net_update_end", function()
	features.miscellaneous.aimbot_logs.net_update_end()
end)

client.set_event_callback("aim_fire", function(event)
	features.miscellaneous.aimbot_logs.fire(event)
end)
client.set_event_callback("aim_hit", function(event)
	features.miscellaneous.aimbot_logs.hit(event)
end)
client.set_event_callback("aim_miss", function(event)
	features.miscellaneous.aimbot_logs.miss(event)
end)

client.set_event_callback("player_death", function(event)
	features.miscellaneous.killsay.handle(event)
end)

client.set_event_callback("cs_game_disconnected", function()
	features.miscellaneous.resolver.Context:ResetData()
end)

client.set_event_callback("client_disconnect", function()
	features.miscellaneous.resolver.Context:ResetData()
end)

client.register_esp_flag("Desync (resolver)", 255, 255, 255, function(player)
	if player ~= client.current_threat() and ui.get(elixir.variables.menu.miscellaneous.resolve_only_target) then
		return
	end

	if not entity.is_enemy(player) and not ui.get(elixir.variables.menu.miscellaneous.resolve_teammates) then
		return
	end

	local player = features.miscellaneous.resolver.Context:GetPlayer(player)

	if not player.success then
		return false
	end

	return ui.get(elixir.variables.menu.miscellaneous.resolver) and ui.get(
		elixir.variables.menu.miscellaneous.resolver_esp_flag
	),
		math.abs(math.floor(player:GetDesync()))
end)

client.register_esp_flag("Side (resolver)", 255, 255, 255, function(player)
	if player ~= client.current_threat() and ui.get(elixir.variables.menu.miscellaneous.resolve_only_target) then
		return
	end

	if not entity.is_enemy(player) and not ui.get(elixir.variables.menu.miscellaneous.resolve_teammates) then
		return
	end

	local player = features.miscellaneous.resolver.Context:GetPlayer(player)

	if not player.success then
		return false
	end

	local side_int = player:GetSide()
	local side = "M"
	if side_int == 1 then
		side = "R"
	elseif side_int == -1 then
		side = "L"
	end

	return ui.get(elixir.variables.menu.miscellaneous.resolver) and ui.get(
		elixir.variables.menu.miscellaneous.resolver_esp_flag
	),
		side
end)
