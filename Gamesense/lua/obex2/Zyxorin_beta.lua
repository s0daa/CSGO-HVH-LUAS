-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local Meta = {}
local ffi = require("ffi")
local vector = require("vector")
local c_entity = require("gamesense/entity") or error("zyxorin: error !, failed require gamesense/entity library")
local base64 = require("gamesense/base64") or error("zyxorin: error !, failed require gamesense/base64 library")
local clipboard = require("gamesense/clipboard") or error("zyxorin: error !, failed require gamesense/clipboard library")
local antiaim_funcs = require("gamesense/antiaim_funcs") or error("zyxorin: error !, failed require gamesense/antiaim_functions library")
local a = require "gamesense/antiaim_funcs"
local vector = require('vector')
Meta.data = {
	Flip = false,
	Notifys = {},
	PrevLag = nil,
	Simulation = {},
	ManualSide = 0,
	CachedLerp = {},
	PrevPosition = {},
	BreakerLC = false,
	PtevSimulation = 0,
	ConfigPackage = {},
	Teams = {"T", "CT"},
	Author = "SYR1337",
	UpdateBodyYaw = 0,
	UpdateTickcount = {},
	IsLeanAntiAim = false,
	CachedAnimation = {},
	CachedTexture = false,
	Side = {"Left", "Right"},
	DifferentSimulation = 0,
	ScriptName = "zyxorin.Lua",
	ScriptName1 = "♞zyxorin+",
	ScriptNameUnicode = "zyxorin+",
	ScriptNameUnicode2 = "zyx",
	KeyDownGround = false,
	LegMichaelData = {0, false},
	JitterSpeedStage = {false, 0},
	LastUpdateManualTimer = 0,
	Panorama = panorama.open(),
	MichaelSwitchState = {false, 0},
	SwitchLegModified = {0, false},
	ConfigsData = database.read("zyxorin configs data") or {},
	Configs = database.read("zyxorin configs") or {"no config"},
	PlayerState = {"Global", "Stand", "Move", "Slow", "Air", "Duck Stand", "Duck Move", "Air+C", "On shot", "Body lean", "Fakelag"}
}

Meta.gradienttext = function(text, r1, g1, b1, a1, r2, g2, b2, a2)
	local output = ""
	local len = #text - 1
	local rinc = (r2 - r1) / len
	local ainc = (a2 - a1) / len
	local ginc = (g2 - g1) / len
	local binc = (b2 - b1) / len
	for i = 1, len + 1 do 
		output = output .. ("\a%02x%02x%02x%02x%s"):format(r1, g1, b1, a1, text:sub(i, i))
		r1 = r1 + rinc
		a1 = a1 + ainc
		b1 = b1 + binc
		g1 = g1 + ginc
	end

	return output
end

Meta.elements = {
	Group = ui.new_combobox("AA", "Anti-aimbot angles", "+script groups-", {"anti-aim", "visuals", "misc", "configs"}),
	AntiAim = {
		Enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFCEEnable zyxorin - \aB9B7F1FFtechnology\aFFFFFFCE -"),
		EdgeYaw = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB9B7F1FF+\aFFFFFFCE/-\aFFFFFFCEedge yaw"),
		LegitOnKey = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB9B7F1FF+\aFFFFFFCE/- \aFFFFFFCElegit on key"),
		FreestandYaw = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB9B7F1FF+\aFFFFFFCE/- \aFFFFFFCEfreestanding"),
		ManualLeft = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB9B7F1FF+\aFFFFFFCE/- \aFFFFFFCEmanual-left"),
		ManualRight = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB9B7F1FF+\aFFFFFFCE/- \aFFFFFFCEmanual-right"),
		ManualForward = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB9B7F1FF+\aFFFFFFCE/- \aFFFFFFCEmanual-forward"),
		DisabledFreestandingInAir = ui.new_checkbox("AA", "Anti-aimbot angles", "disable freestanding \aB9B7F1FFin-air"),
		AAMode = ui.new_combobox("AA", "Anti-aimbot angles", "AA mode", {"Preset", "Conditions"}),
		Team = ui.new_combobox("AA", "Anti-aimbot angles", "Team select", Meta.data.Teams),
		PlayerState = ui.new_combobox("AA", "Anti-aimbot angles", "player state", Meta.data.PlayerState),
		Custom = (function()
			local elements = {}
			for idx, team in pairs(Meta.data.Teams) do
				elements[idx] = {}
				for index, data in pairs(Meta.data.PlayerState) do
					elements[idx][index] = {
						team = team,
						pointer = data,
						enabled = ui.new_checkbox("AA", "Anti-aimbot angles", ("❮%s❯\aFFFFFFCEenable states\n %s"):format(index, idx), index == 1),
						enabled_hotkey = ui.new_hotkey("AA", "Anti-aimbot angles", ("❮%s❯\aFFFFFFCEbody lean override hotkey\n %s"):format(index, idx)),
						index = ui.new_combobox("AA", "Anti-aimbot angles", ("\n %s %s Instance"):format(index, idx), {"Preset", "Single", "L&R TICK \aB9B7F1FFSWITCH"}),
						side = ui.new_combobox("AA", "Anti-aimbot angles", ("\n %s %s Side"):format(index, idx), Meta.data.Side),
						left = {
							yaw = ui.new_combobox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw\n %s %s L"):format(index, idx), {"Off", "180", "Spin", "Static", "180 Z", "Crosshair", "Random"}),
							yaw_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Offset L"):format(index, idx), - 180, 180, 0),
							yaw_switch_tickcount = ui.new_checkbox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw tickcount switch\n %s %s L"):format(index, idx), false),
							yaw_tickcount_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Jitter Offset L Tick"):format(index, idx), - 180, 180, - 15),
							yaw_tickcount = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCETickcount amount\n %s %s L"):format(index, idx), 2, 64, 8),
							yaw_tickcount_random = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCETickcount amount random\n %s %s L"):format(index, idx), 2, 64, 14),
							yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw jitter\n %s %s L"):format(index, idx), {"Off", "Offset", "Center", "Random", "Skitter", "Slow 1X", "Slow 2X"}),
							yaw_jitter_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Jitter Offset L"):format(index, idx), - 180, 180, 0),
							enabled_yawjitter_tickcount = ui.new_checkbox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw jitter tickcount switch\n %s %s L"):format(index, idx), false),
							yaw_jitter_tickcount_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Jitter Offset L Tick Jitter"):format(index, idx), - 180, 180, - 90),
							yaw_jitter_tickcount = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCETickcount amount\n %s %s L Jitter"):format(index, idx), 2, 64, 8),
							body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", ("\aFFFFFFCEBody yaw\n %s %s L"):format(index, idx), {"Off", "Opposite", "Jitter", "Static"}),
							body_yaw_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Body Offset L"):format(index, idx), - 180, 180, 0),
							freestanding_body = ui.new_checkbox("AA", "Anti-aimbot angles", ("\aFFFFFFCEFreestanding body yaw\n %s %s L"):format(index, idx), false),
							roll = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCERoll\n %s %s L"):format(index, idx), - 50, 50, 0)
						},

						right = {
							yaw = ui.new_combobox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw\n %s %s R"):format(index, idx), {"Off", "180", "Spin", "Static", "180 Z", "Crosshair", "Random"}),
							yaw_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Offset R"):format(index, idx), - 180, 180, 0),
							yaw_switch_tickcount = ui.new_checkbox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw tickcount switch\n %s %s R"):format(index, idx), false),
							yaw_tickcount_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Jitter Offset R Tick"):format(index, idx), - 180, 180, 15),
							yaw_tickcount = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCETickcount amount\n %s %s R"):format(index, idx), 2, 64, 8),
							yaw_tickcount_random = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCETickcount amount random\n %s %s R"):format(index, idx), 2, 64, 14),
							yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw jitter\n %s %s R"):format(index, idx), {"Off", "Offset", "Center", "Random", "Skitter", "Slow 1X", "Slow 2X"}),
							yaw_jitter_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Jitter Offset R"):format(index, idx), - 180, 180, 0),
							enabled_yawjitter_tickcount = ui.new_checkbox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw jitter tickcount switch\n %s %s R Jitter"):format(index, idx), false),
							yaw_jitter_tickcount_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Jitter Offset R Tick Jitter"):format(index, idx), - 180, 180, 90),
							yaw_jitter_tickcount = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCETickcount amount\n %s %s R Jitter"):format(index, idx), 2, 64, 8),
							body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", ("\aFFFFFFCEBody yaw\n %s %s R"):format(index, idx), {"Off", "Opposite", "Jitter", "Static"}),
							body_yaw_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Body Offset R"):format(index, idx), - 180, 180, 0),
							freestanding_body = ui.new_checkbox("AA", "Anti-aimbot angles", ("\aFFFFFFCEFreestanding body yaw\n %s %s R"):format(index, idx), false),
							roll = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCERoll\n %s %s R"):format(index, idx), - 50, 50, 0)
						},

						override_fakelag = ui.new_checkbox("AA", "Anti-aimbot angles", ("❮%s❯\aFFFFFFCEenable fakelag\n %s"):format(index, idx), index == 1),
						fakelag_amount = ui.new_combobox("AA", "Anti-aimbot angles", ("Fakelag amount\n %s %s"):format(index, idx), {"Dynamic", "Maximum", "Fluctuate"}),
						fakelag_variance = ui.new_slider("AA", "Anti-aimbot angles", ("Fakelag variance\n %s %s"):format(index, idx), 0, 100, 0),
						fakelag_limit = ui.new_slider("AA", "Anti-aimbot angles", ("Fakelag limit\n %s %s"):format(index, idx), 1, 15, 14)
					}
				end
			end

			return elements
		end)()
	},

	Visuals = {
		CrosshairStyle = ui.new_combobox("AA", "Anti-aimbot angles", "\aFF81F0FF\aFFFFFFCEUnder crosshair style", {"Off", "1", "2", "3"}),
		AnimationMode = ui.new_combobox("AA", "Fake lag", "Animation Mode", {"Lerp", "Static"}),
		OSText = ui.new_label("AA", "Fake lag", "\aFFFFFFCEHide color"),
		OSColor = ui.new_color_picker("AA", "Fake lag", "\nHide color", 255, 255, 255, 255),
		NameText = ui.new_label("AA", "Fake lag", "Name \aFFFFFFCEcolor"),
		NameColor = ui.new_color_picker("AA", "Fake lag", "\nName color", 255, 255, 255, 255),
		NameText2 = ui.new_label("AA", "Fake lag", "Name Gradient \aFFFFFFCEcolor"),
		NameColor2 = ui.new_color_picker("AA", "Fake lag", "\nName Gradient color", 255, 255, 255, 255),
		FDText = ui.new_label("AA", "Fake lag", "\aFFFFFFCEFake duck color"),
		FDColor = ui.new_color_picker("AA", "Fake lag", "\nFD color", 255, 255, 255, 255),
		SafeText = ui.new_label("AA", "Fake lag", "\aFFFFFFCEForce safe color"),
		SafeColor = ui.new_color_picker("AA", "Fake lag", "\nForce safe color", 255, 255, 255, 255),
		DTText = ui.new_label("AA", "Fake lag", "\aFFFFFFCEDouble tap color"),
		DTColor = ui.new_color_picker("AA", "Fake lag", "\nDT color", 255, 255, 255, 255),
		LegitText = ui.new_label("AA", "Fake lag", "\aFFFFFFCELegit color"),
		LegitColor = ui.new_color_picker("AA", "Fake lag", "\nLegit color", 255, 255, 255, 255),
		EdgeText = ui.new_label("AA", "Fake lag", "\aFFFFFFCEEdge color"),
		EdgeColor = ui.new_color_picker("AA", "Fake lag", "\nEdge color", 255, 255, 255, 255),
		BarText = ui.new_label("AA", "Fake lag", "\aFFFFFFCEDesync bar color"),
		BarColor = ui.new_color_picker("AA", "Fake lag", "\nBar color", 255, 255, 255, 255),
		BaimText = ui.new_label("AA", "Fake lag", "\aFFFFFFCEForce body aim color"),
		BaimColor = ui.new_color_picker("AA", "Fake lag", "\nForce baim color", 255, 255, 255, 255),
		HotkeyAlways = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFF81F0FF\aFFFFFFCEForce draw hotkeys"),
		ManualIndication = ui.new_combobox("AA", "Anti-aimbot angles", "\aFF81F0FF\aFFFFFFCEManual arrows style", {"Off", "1", "2", "3"}),
		ManualText = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFCEManual color"),
		ManualColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nManual color", 255, 255, 255, 255),
		ManualDistance = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFCEManual indication between", 0, 300, 25),
		Hitlog = ui.new_combobox("AA", "Anti-aimbot angles", "\aFF81F0FF\aFFFFFFCEHitlog notify style", {"Off", "1", "2", "3"}),
		HitlogText = ui.new_label("AA", "Anti-aimbot angles", "Hitlog outline color"),
		HitlogColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nLog color", 255, 255, 255, 255),
		h = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFF2222FF⚠ \aFFFFFFCEPOSE EDITAR"),
		i = ui.new_combobox("AA", "Anti-aimbot angles", "State", {"Fakelag", "Always"}),
		j = ui.new_multiselect("AA", "Anti-aimbot angles", "Indexs", {"8", "10", "16", "17"}),
		k = ui.new_slider("AA", "Anti-aimbot angles", "Magnitude", 0, 100, 10, true, nil, 0.01),
		l = ui.new_slider("AA", "Anti-aimbot angles", "Speed", 1, 5, 3),
		water = ui.new_checkbox("AA", "Anti-aimbot angles", "Watermarker"),
		fade_color_l = ui.new_label("AA", "Anti-aimbot angles", "fade color"),
		fade_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\n", 255, 255, 255, 255)
	},

	Misc = {
		label = ui.new_label("AA", "Anti-aimbot angles", "slingner: Go check the 'Other' panel"),
		features = ui.new_multiselect("AA", "Other", "\aFF81F0FF\aFFFFFFCEFeatures", {"Avoid backstab", "Fix hideshots", "Force defensive", "0 pitch on land", "Static leg in air", "Static leg in slow", "LC Breaker", "Michael jackson"}),
		leg_mode = ui.new_combobox("AA", "Other", "\aFF81F0FF\aFFFFFFCELeg mode", {"1", "2"}),
		break_lc_key = ui.new_hotkey("AA", "Other", "\aFFFFFFCEBreak lc:in-air"),
		force_defensive_key = ui.new_hotkey("AA", "Other", "\aFFFFFFCEForce-defensive")
	},

	Configs = {
		configs_list = ui.new_listbox("AA", "Anti-aimbot angles", "Configs", Meta.data.Configs),
		join_discord = ui.new_button("AA", "Other", Meta.gradienttext("Join discord", 255, 255, 255, 220, 185, 183, 241, 255), function()
			Meta.data.Panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/KRkYBxxhGh")
		end)
	}
}

Meta.reference = {
	fakelag_limit = ui.reference("AA", "Fake lag", "Limit"),
	roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
	yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
	slow_walk = {ui.reference("AA", "Other", "Slow motion")},
	pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")},
	onshot = {ui.reference("AA", "Other", "On shot anti-aim")},
	fakelag_amount = ui.reference("AA", "Fake lag", "Amount"),
	doubletap = {ui.reference("RAGE", "Aimbot", "Double tap")},
	fakelag_variance = ui.reference("AA", "Fake lag", "Variance"),
	fakelag_reference = ui.reference("AA", "Fake lag", "Enabled"),
	fake_duck = ui.reference("RAGE", "Other", "Duck peek assist"),
	force_body = ui.reference("Rage", "Aimbot", "Force body aim"),
	leg_movement = ui.reference("AA", "Other", "Leg movement"),
	force_safe = ui.reference("Rage", "Aimbot", "Force safe point"),
	yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
	edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
	yaw_jitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
	body_yaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
	freestanding = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
	freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
}

Meta.contains = function(table, target)
	for _, data in pairs(table) do
		if data == target then
			return true
		end
	end

	return false
end

Meta.multicallback = function(tab, handle, tocall)
	if tocall then
		handle()
	end

	for key, data in pairs(tab) do
		if type(data) == "table" and tostring(key):find("Config") == nil then
			Meta.multicallback(data, handle)
		elseif type(data) == "number" then
			ui.set_callback(data, handle)
		end
	end
end

Meta.getconfigelements = function()
	return {
		Meta.elements.AntiAim,
		Meta.elements.Visuals,
		Meta.elements.Misc
	}
end

Meta.writepackage = function(group, key)
	local current_pre_key = key or ""
	for key, data in pairs(group) do
		local current_key = ("%s%s"):format(current_pre_key, key)
		if type(data) == "table" then
			Meta.writepackage(data, current_key)
		elseif type(data) == "number" then
			Meta.data.ConfigPackage[current_key] = data
		end
	end
end

Meta.is8bit = function(var)
	if type(var) ~= "number" then
		return false
	end

	return var >= 0 and var <= 255
end

Meta.getconfigstring = function()
	local configs = {}
	Meta.data.ConfigPackage = {}
	Meta.writepackage(Meta.getconfigelements())
	for key, data in pairs(Meta.data.ConfigPackage) do
		local val = {ui.get(data)}
		local b_color = Meta.is8bit(val[1]) and Meta.is8bit(val[2]) and Meta.is8bit(val[3]) and Meta.is8bit(val[4])
		configs[key] = b_color and {"Color", val} or val[1]
	end

	return base64.encode(json.stringify(configs))
end

Meta.setconfigstring = function(m_configs)
	local config_data = m_configs or clipboard.get()
	local configs = json.parse(base64.decode(config_data))
	Meta.data.ConfigPackage = {}
	Meta.writepackage(Meta.getconfigelements())
	for key, data in pairs(Meta.data.ConfigPackage) do
		local val = configs[key]
		if type(val) == "table" and val[1] == "Color" then
			pcall(ui.set, data, unpack(val[2]))
		else
			pcall(ui.set, data, val)
		end
	end
end

Meta.configcreate = function()
	local name = ui.get(Meta.elements.Configs.config_name)
	if name:len() <= 0 or name == "no config" then
		return
	end

	if Meta.contains(Meta.data.Configs, name) then
		return
	end

	if Meta.contains(Meta.data.Configs, "no config") then
		for index, data in pairs(Meta.data.Configs) do
			if data == "no config" then
				table.remove(Meta.data.Configs, index)
			end
		end
	end

	table.insert(Meta.data.Configs, name)
	Meta.data.ConfigsData[name] = Meta.getconfigstring()
	ui.update(Meta.elements.Configs.configs_list, Meta.data.Configs)
end

Meta.configload = function()
	local current_index = ui.get(Meta.elements.Configs.configs_list) + 1
	local current = Meta.data.Configs[math.max(1, current_index)]
	if current == "no config" then
		return
	end

	Meta.setconfigstring(Meta.data.ConfigsData[current])
end

Meta.configsave = function()
	local current_index = ui.get(Meta.elements.Configs.configs_list) + 1
	local current = Meta.data.Configs[math.max(1, current_index)]
	if current == "no config" then
		return
	end

	Meta.data.ConfigsData[current] = Meta.getconfigstring()
end

Meta.configdelete = function()
	local current = Meta.data.Configs[math.max(1, ui.get(Meta.elements.Configs.configs_list))]
	if current == "no config" then
		return
	end

	for index, data in pairs(Meta.data.Configs) do
		if data == current then
			table.remove(Meta.data.Configs, index)
		end
	end

	if #Meta.data.Configs <= 0 then
		table.insert(Meta.data.Configs, "no config")
	end

	Meta.data.ConfigsData[current] = nil
	ui.update(Meta.elements.Configs.configs_list, Meta.data.Configs)
end

Meta.configimport = function()
	Meta.setconfigstring()
end

Meta.configexport = function()
	clipboard.set(Meta.getconfigstring())
end

Meta.elements.Configs.config_name = ui.new_textbox("AA", "Anti-aimbot angles", "\n Config name")
Meta.elements.Configs.config_create = ui.new_button("AA", "Anti-aimbot angles", "\aFFFFFFCECreate", Meta.configcreate)
Meta.elements.Configs.config_load = ui.new_button("AA", "Anti-aimbot angles", "\aFFFFFFCELoad", Meta.configload)
Meta.elements.Configs.config_save = ui.new_button("AA", "Anti-aimbot angles", "\aFFFFFFCESave", Meta.configsave)
Meta.elements.Configs.config_delete = ui.new_button("AA", "Anti-aimbot angles", "\aFFFFFFCEDelete", Meta.configdelete)
Meta.elements.Configs.config_import = ui.new_button("AA", "Anti-aimbot angles", "\aFFFFFFCEImport", Meta.configimport)
Meta.elements.Configs.config_export = ui.new_button("AA", "Anti-aimbot angles", "\aFFFFFFCEExport", Meta.configexport)
Meta.handlereference = function(state)
	for key, data in pairs(Meta.reference) do
		if not Meta.contains({"fakelag_limit", "slow_walk", "onshot", "doubletap", "fakelag_amount", "fakelag_variance", "fakelag_reference", "fake_duck", "leg_movement", "force_body", "force_safe"}, key) then
			if type(data) == "table" then
				ui.set_visible(data[1], state)
				ui.set_visible(data[2], state)
			else
				ui.set_visible(data, state)
			end
		end
	end
end

Meta.handlemain = function()
	Meta.handlereference(not ui.get(Meta.elements.AntiAim.Enabled))
	ui.set_visible(Meta.elements.Misc.label, ui.get(Meta.elements.Group) == "misc")
	ui.set_visible(Meta.elements.Misc.features, ui.get(Meta.elements.Group) == "misc")
	ui.set_visible(Meta.elements.Misc.leg_mode, ui.get(Meta.elements.Group) == "misc" and Meta.contains(ui.get(Meta.elements.Misc.features), "Michael jackson"))
	ui.set_visible(Meta.elements.Visuals.Hitlog, ui.get(Meta.elements.Group) == "visuals")
	ui.set_visible(Meta.elements.AntiAim.Enabled, ui.get(Meta.elements.Group) == "anti-aim")
	ui.set_visible(Meta.elements.Configs.configs_list, ui.get(Meta.elements.Group) == "configs")
	ui.set_visible(Meta.elements.Configs.config_save, ui.get(Meta.elements.Group) == "configs")
	ui.set_visible(Meta.elements.Configs.config_load, ui.get(Meta.elements.Group) == "configs")
	ui.set_visible(Meta.elements.Visuals.CrosshairStyle, ui.get(Meta.elements.Group) == "visuals")
	ui.set_visible(Meta.elements.Visuals.h, ui.get(Meta.elements.Group) == "visuals")
	ui.set_visible(Meta.elements.Visuals.water, ui.get(Meta.elements.Group) == "visuals")
	ui.set_visible(Meta.elements.Configs.config_name, ui.get(Meta.elements.Group) == "configs")
	ui.set_visible(Meta.elements.Configs.config_create, ui.get(Meta.elements.Group) == "configs")
	ui.set_visible(Meta.elements.Configs.config_delete, ui.get(Meta.elements.Group) == "configs")
	ui.set_visible(Meta.elements.Configs.config_export, ui.get(Meta.elements.Group) == "configs")
	ui.set_visible(Meta.elements.Configs.config_import, ui.get(Meta.elements.Group) == "configs")
	ui.set_visible(Meta.elements.Visuals.ManualIndication, ui.get(Meta.elements.Group) == "visuals")
	ui.set_visible(Meta.elements.AntiAim.AAMode, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled))
	ui.set_visible(Meta.elements.AntiAim.EdgeYaw, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled))
	ui.set_visible(Meta.elements.AntiAim.ManualLeft, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled))
	ui.set_visible(Meta.elements.AntiAim.LegitOnKey, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled))
	ui.set_visible(Meta.elements.AntiAim.ManualRight, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled))
	ui.set_visible(Meta.elements.Visuals.HitlogText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.Hitlog) ~= "Off")
	ui.set_visible(Meta.elements.AntiAim.FreestandYaw, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled))
	ui.set_visible(Meta.elements.Visuals.HitlogColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.Hitlog) ~= "Off")
	ui.set_visible(Meta.elements.AntiAim.ManualForward, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled))
	ui.set_visible(Meta.elements.Visuals.i, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.h))
	ui.set_visible(Meta.elements.Visuals.j, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.h))
	ui.set_visible(Meta.elements.Visuals.k, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.h))
	ui.set_visible(Meta.elements.Visuals.l, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.h))
	ui.set_visible(Meta.elements.Visuals.BarText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "1")
	ui.set_visible(Meta.elements.Visuals.SafeText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "2")
	ui.set_visible(Meta.elements.Visuals.DTText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.FDText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.BarColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "1")
	ui.set_visible(Meta.elements.Visuals.OSText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.BaimText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "2")
	ui.set_visible(Meta.elements.Visuals.SafeColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "2")
	ui.set_visible(Meta.elements.Visuals.FDColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.DTColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.OSColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.BaimColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "2")
	ui.set_visible(Meta.elements.Visuals.LegitText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.EdgeText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.NameText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.LegitColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.EdgeColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.NameColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.NameText2, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.HotkeyAlways, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "2")
	ui.set_visible(Meta.elements.Visuals.NameColor2, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.AntiAim.DisabledFreestandingInAir, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled))
	ui.set_visible(Meta.elements.Visuals.ManualText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.ManualIndication) ~= "Off")
	ui.set_visible(Meta.elements.Visuals.ManualColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.ManualIndication) ~= "Off")
	ui.set_visible(Meta.elements.Visuals.AnimationMode, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "3")
	ui.set_visible(Meta.elements.Visuals.ManualDistance, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.ManualIndication) ~= "Off")
	ui.set_visible(Meta.elements.Visuals.fade_color_l, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.water))
	ui.set_visible(Meta.elements.Visuals.fade_color, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.water))
	ui.set_visible(Meta.elements.Misc.break_lc_key, ui.get(Meta.elements.Group) == "misc" and Meta.contains(ui.get(Meta.elements.Misc.features), "LC Breaker"))
	ui.set_visible(Meta.elements.Misc.force_defensive_key, ui.get(Meta.elements.Group) == "misc" and Meta.contains(ui.get(Meta.elements.Misc.features), "Force defensive"))
	ui.set_visible(Meta.elements.AntiAim.Team, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
	ui.set_visible(Meta.elements.AntiAim.PlayerState, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
	for team, data in pairs(Meta.elements.AntiAim.Custom) do
		for index, data in pairs(data) do
			if index == 1 then
				ui.set(data.enabled, true)
				ui.set(data.override_fakelag, true)
			end

			local is_left = (ui.get(data.side) == "Left" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH")
			local draw_left = (ui.get(data.side) == "Left" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH") or ui.get(data.index) == "Single"
			ui.set_visible(data.enabled, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and index ~= 1 and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.index, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.override_fakelag, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and index ~= 1 and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.fakelag_limit, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.override_fakelag) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.roll, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.yaw, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.fakelag_amount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.override_fakelag) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.fakelag_variance, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.override_fakelag) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.body_yaw, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.side, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.enabled_hotkey, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and data.pointer == "Body lean" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.yaw_jitter, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(data.left.yaw) ~= "Off" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.yaw_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(data.left.yaw) ~= "Off" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.yaw_switch_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and is_left and ui.get(data.left.yaw) ~= "Off" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.freestanding_body, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(data.left.body_yaw) ~= "Off" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.roll, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.yaw, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.body_yaw, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.yaw_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and is_left and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw_switch_tickcount) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.yaw_jitter_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw_jitter) ~= "Off" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.yaw_tickcount_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and is_left and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw_switch_tickcount) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.yaw_tickcount_random, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and is_left and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw_switch_tickcount) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.enabled_yawjitter_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and is_left and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw_jitter) ~= "Off" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.yaw_jitter, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.yaw_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.body_yaw_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(data.left.body_yaw) ~= "Off" and ui.get(data.left.body_yaw) ~= "Opposite" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.yaw_switch_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.freestanding_body, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.body_yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.yaw_jitter_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw_jitter) ~= "Off" and ui.get(data.left.enabled_yawjitter_tickcount) and is_left and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.left.yaw_jitter_tickcount_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw_jitter) ~= "Off" and ui.get(data.left.enabled_yawjitter_tickcount) and is_left and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.yaw_jitter_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.right.yaw_jitter) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.yaw_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(data.right.yaw_switch_tickcount) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.yaw_tickcount_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(data.right.yaw_switch_tickcount) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.yaw_tickcount_random, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(data.right.yaw_switch_tickcount) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.enabled_yawjitter_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.right.yaw_jitter) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.body_yaw_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.body_yaw) ~= "Off" and ui.get(data.right.body_yaw) ~= "Opposite" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.yaw_jitter_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.right.yaw_jitter) ~= "Off" and ui.get(data.right.enabled_yawjitter_tickcount) and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
			ui.set_visible(data.right.yaw_jitter_tickcount_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.right.yaw_jitter) ~= "Off" and ui.get(data.right.enabled_yawjitter_tickcount) and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions")
		end
	end
end

Meta.clamp = function(var, min, max)
	local m_min = math.min(min, max)
	local m_max = math.max(min, max)
	return math.min(math.max(m_min, var), m_max)
end

Meta.time2ticks = function(t)
	return math.floor(0.5 + (t / globals.tickinterval()))
end

Meta.lerp = function(a, b, c)
	return a + (b - a) * c
end

Meta.createlerp = function(cur, key, frame)
	if not Meta.data.CachedLerp[key] then
		Meta.data.CachedLerp[key] = cur
	end

	Meta.data.CachedLerp[key] = Meta.lerp(Meta.data.CachedLerp[key], cur, frame)
	return Meta.data.CachedLerp[key]
end

Meta.createstaticanimation = function(min, max, switch, smooth, key)
	if not Meta.data.CachedAnimation[key] then
		Meta.data.CachedAnimation[key] = min
	end

	Meta.data.CachedAnimation[key] = Meta.clamp(Meta.data.CachedAnimation[key] + (switch and smooth or - smooth), min, max)
	return Meta.data.CachedAnimation[key]
end

Meta.simulationdifferent = function()
	local current_simulation_time = Meta.time2ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
	Meta.data.DifferentSimulation = current_simulation_time - Meta.data.PtevSimulation
	Meta.data.PtevSimulation = current_simulation_time
	return Meta.data.DifferentSimulation
end

Meta.velocity = function(player)
	if not player or not entity.is_alive(player) or entity.is_dormant(player) then
		return 0
	end

	return vector(entity.get_prop(player, "m_vecVelocity")):length2d()
end

Meta.jumping = function(player)
	if not player or not entity.is_alive(player) or entity.is_dormant(player) then
		return false
	end

	return bit.band(entity.get_prop(player, "m_fFlags"), 1) == 0
end

Meta.ducking = function(player)
	if not player or not entity.is_alive(player) or entity.is_dormant(player) then
		return false
	end

	return bit.band(entity.get_prop(player, "m_fFlags"), 2) == 2
end

Meta.normalizedyaw = function(yaw)
	while yaw > 180 do
		yaw = yaw - 360
	end

	while yaw < -180 do
		yaw = yaw + 360
	end

	return yaw
end

Meta.newtexture = function(width, height)
	local svg = [[<svg width="]] .. width .. [[" height="]] .. height .. [[" viewBox="0 0 ]] .. width .. [[ ]] .. height .. [[">
<rect width="]] .. width .. [[" height="]] .. height .. [[" y="0" x="0" fill="#151515"/>#pattern</svg>]]

	for x = 0, width, 4 do
		for y=0, height, 4 do
		local pattern = [[<rect height="3" width="1" x="]] .. x+1 .. [[" y="]] .. y .. [[" fill="#0d0d0d"/><rect height="1" width="1" x="]] .. x+3 .. [[" y="]] .. y .. [[" fill="#0d0d0d"/><rect height="2" width="1" x="]] .. x+3 .. [[" y="]] .. y+2 .. [[" fill="#0d0d0d"/>]]
			svg = svg:gsub("#pattern", pattern .. "#pattern")
		end
	end

	svg = svg:gsub("#pattern\n", "")
	return svg
end

Meta.roundrect = function(x, y, w, h, radius, r, g, b, a)
	local n = 45
	local o = 16
	local rounding = 4
	local rad = rounding + 2
	renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a)
	renderer.rectangle(x, y + radius, radius, h - radius * 2, r, g, b, a)
	renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius, r, g, b, a)
	renderer.rectangle(math.floor(x + w - radius - 1), y + radius, radius, h - radius * 2, r, g, b, a)
	renderer.rectangle(x + radius, y + radius, w - radius * 2, h - radius * 2, r, g, b, a)
	renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
	renderer.circle(math.floor(x + w - radius - 1), y + radius, r, g, b, a, radius, 90, 0.25)
	renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, 270, 0.25)
	renderer.circle(math.floor(x + w - radius - 1), y + h - radius, r, g, b, a, radius, 0, 0.25)
end

Meta.outlineglow = function(x, y, w, h, radius, r, g, b, a)
	local n = 45
	local o = 16
	local rounding = 4
	local rad = rounding + 2
	renderer.rectangle(x + 2, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
	renderer.rectangle(x + w - 3, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
	renderer.rectangle(x + radius + rad, y + 2, w - rad * 2 - radius * 2, 1, r, g, b, a)
	renderer.rectangle(x + radius + rad, y + h - 3, w - rad * 2 - radius * 2, 1, r, g, b, a)
	renderer.circle_outline(x + radius + rad, y + radius + rad, r, g, b, a, radius + rounding, 180, 0.25, 1)
	renderer.circle_outline(x + w - radius - rad, y + radius + rad, r, g, b, a, radius + rounding, 270, 0.25, 1)
	renderer.circle_outline(x + radius + rad, y + h - radius - rad, r, g, b, a, radius + rounding, 90, 0.25, 1)
	renderer.circle_outline(x + w - radius - rad, y + h - radius - rad, r, g, b, a, radius + rounding, 0, 0.25, 1)
end

Meta.fadedroundrect = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1)
	local n = 45
	local o = 16
	local rounding = 4
	local n = a / 255 * n
	local rad = rounding + 2
	renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, n)
	renderer.circle_outline(x + radius, y + radius, r, g, b, n, radius, 180, 0.25, 1)
	renderer.circle_outline(x + w - radius, y + radius, r, g, b, n, radius, 270, 0.25, 1)
	renderer.rectangle(x, y + radius, 1, h - radius * 2, r, g, b, n)
	renderer.rectangle(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, n)
	renderer.circle_outline(x + radius, y + h - radius, r, g, b, n, radius, 90, 0.25, 1)
	renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, n, radius, 0, 0.25, 1)
	renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
	for radius = 1, glow do
		local radius = radius / 2
		Meta.outlineglow(x - radius, y - radius, w + radius * 2, h + radius * 2, radius, r1, g1, b1, glow - radius * 2)
	end
end

Meta.fadedroundglow = function(x, y, w, h, radius, r, g, b, a, glow)
	local n = 45
	local o = 16
	local rounding = 4
	local n = a / 255 * n
	local rad = rounding + 2
	renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, a)
	renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, 1)
	renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, 270, 0.25, 1)
	renderer.gradient(x, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b, n, false)
	renderer.gradient(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b, n, false)
	renderer.circle_outline(x + radius, y + h - radius, r, g, b, n, radius, 90, 0.25, 1)
	renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, n, radius, 0, 0.25, 1)
	renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
	for radius = 1, glow do 
		local radius = radius / 2
		Meta.outlineglow(x - radius, y - radius, w + radius * 2, h + radius * 2, radius, r, g, b, glow - radius * 2)
	end
end

Meta.containerglow = function(x, y, w, h, r, g, b, a, alpha, r1, g1, b1)
	if alpha > 0 then
		renderer.blur(x, y, w, h)
	end


	local n = 45
	local o = 16
	local rounding = 4
	local rad = rounding + 2
	Meta.roundrect(x, y, w, h, rounding, 17, 17, 17, a)
	Meta.fadedroundrect(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o, r1, g1, b1)
	Meta.fadedroundglow(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o, r1, g1, b1)
end

Meta.playerstate = function()
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	local playerstate_index = 1
	local velocity = Meta.velocity(local_player)
	local ducking = Meta.ducking(local_player)
	local jumping = Meta.jumping(local_player)
	local os = ui.get(Meta.reference.onshot[1]) and ui.get(Meta.reference.onshot[2])
	local dt = ui.get(Meta.reference.doubletap[1]) and ui.get(Meta.reference.doubletap[2])
	local slow = ui.get(Meta.reference.slow_walk[1]) and ui.get(Meta.reference.slow_walk[2])
	local custom = Meta.elements.AntiAim.Custom[entity.get_prop(local_player, "m_iTeamNum") == 2 and 1 or 2]
	if ui.get(custom[2].enabled) and dt and velocity < 3 then
		playerstate_index = 2
	end

	if ui.get(custom[3].enabled) and dt and velocity > 3 then
		playerstate_index = 3
	end

	if ui.get(custom[4].enabled) and dt and slow and velocity > 3 then
		playerstate_index = 4
	end

	if ui.get(custom[6].enabled) and dt and ducking and velocity < 3 then
		playerstate_index = 6
	end

	if ui.get(custom[7].enabled) and dt and ducking and velocity > 3 then
		playerstate_index = 7
	end

	if ui.get(custom[5].enabled) and dt and jumping then
		playerstate_index = 5
	end

	if ui.get(custom[8].enabled) and dt and jumping and ducking then
		playerstate_index = 8
	end

	if ui.get(custom[9].enabled) and not dt and os then
		playerstate_index = 9
	end

	if ui.get(custom[11].enabled) and not dt and not os then
		playerstate_index = 11
	end

	if ui.get(custom[10].enabled) and ui.get(custom[10].enabled_hotkey) then
		playerstate_index = 10
	end

	return playerstate_index
end

Meta.lagplayerstate = function()
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	local playerstate_index = 1
	local velocity = Meta.velocity(local_player)
	local ducking = Meta.ducking(local_player)
	local jumping = Meta.jumping(local_player)
	local os = ui.get(Meta.reference.onshot[1]) and ui.get(Meta.reference.onshot[2])
	local slow = ui.get(Meta.reference.slow_walk[1]) and ui.get(Meta.reference.slow_walk[2])
	local custom = Meta.elements.AntiAim.Custom[entity.get_prop(local_player, "m_iTeamNum") == 2 and 1 or 2]
	if ui.get(custom[2].override_fakelag) and velocity < 3 then
		playerstate_index = 2
	end

	if ui.get(custom[3].override_fakelag) and velocity > 3 then
		playerstate_index = 3
	end

	if ui.get(custom[4].override_fakelag) and slow and velocity > 3 then
		playerstate_index = 4
	end

	if ui.get(custom[6].override_fakelag) and ducking and velocity < 3 then
		playerstate_index = 6
	end

	if ui.get(custom[7].override_fakelag) and ducking and velocity > 3 then
		playerstate_index = 7
	end

	if ui.get(custom[5].override_fakelag) and jumping then
		playerstate_index = 5
	end

	if ui.get(custom[8].override_fakelag) and jumping and ducking then
		playerstate_index = 8
	end

	if ui.get(custom[9].override_fakelag) and os then
		playerstate_index = 9
	end

	if ui.get(custom[10].override_fakelag) and ui.get(custom[10].enabled_hotkey) then
		playerstate_index = 10
	end

	return playerstate_index
end

Meta.updatetick = function()
	local tickcount = globals.tickcount()
	for index = 2, 64 do
		if tickcount % index == 0 then
			Meta.data.UpdateTickcount[index] = not Meta.data.UpdateTickcount[index]
		end
	end
end

Meta.simulation = function(player)
	if not player then
		return 0
	end

	local m_ticks = entity.get_prop(player, "m_flSimulationTime")
	if not Meta.data.Simulation[player] then
		Meta.data.Simulation[player] = {
			tick = 0,
			prev_tick = m_ticks
		}
	end

	Meta.data.Simulation[player].tick = Meta.time2ticks(m_ticks - Meta.data.Simulation[player].prev_tick)
	Meta.data.Simulation[player].prev_tick = m_ticks
end

Meta.aimhit = function(e)
	local timer = globals.curtime()
	local target_name = entity.get_player_name(e.target)
	local hitlog_style = ui.get(Meta.elements.Visuals.Hitlog)
	local text = ("❮%s❯hit %s 's %s for %i damage"):format(Meta.data.ScriptName, target_name, hitboxes, e.damage)
	local hitboxes = ({"body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"})[e.hitgroup + 1] or "gear"
	if hitlog_style == "1" then
		text = ("%s  registered  shot  %s  's  %s  for  %i damage,  hitchance:  %i,  bt:  %iticks"):format(Meta.data.ScriptName, target_name, hitboxes, e.damage, e.hit_chance, Meta.data.Simulation[e.target].tick)
	elseif hitlog_style == "3" then
		text = ("❮%s❯registered shot %s 's %s for %i damage, hitchance: %i, bt: %iticks"):format(Meta.data.ScriptName, target_name, hitboxes, e.damage, e.hit_chance, Meta.data.Simulation[e.target].tick)
	end

	table.insert(Meta.data.Notifys, {
		stage = 1,
		alpha = 0,
		text = text,
		timer = timer
	})
end

Meta.aimmiss = function(e)
	local timer = globals.curtime()
	local target_name = entity.get_player_name(e.target)
	local hitlog_style = ui.get(Meta.elements.Visuals.Hitlog)
	local text = ("❮%s❯miss shot %s 's due to %s"):format(Meta.data.ScriptName, target_name, e.reason == "?" and "resolver" or e.reason)
	local hitboxes = ({"body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"})[e.hitgroup + 1] or "gear"
	if hitlog_style == "1" then
		text = ("%s  missed  shot %s  's  for  %s  due  to  %s,  hitchance:  %i,  bt:  %iticks"):format(Meta.data.ScriptName, target_name, hitboxes, e.reason == "?" and "resolver" or e.reason, e.hit_chance, Meta.data.Simulation[e.target].tick)
	elseif hitlog_style == "3" then
		text = ("❮%s❯missed shot %s 's for %s due to %s, hitchance: %i, bt: %iticks"):format(Meta.data.ScriptName, target_name, hitboxes, e.reason == "?" and "resolver" or e.reason, e.hit_chance, Meta.data.Simulation[e.target].tick)
	end

	table.insert(Meta.data.Notifys, {
		stage = 1,
		alpha = 0,
		text = text,
		timer = timer
	})
end

Meta.updatemanual = function()
	if ui.get(Meta.elements.AntiAim.ManualLeft) and Meta.data.LastUpdateManualTimer + 0.2 < globals.curtime() then
		Meta.data.LastUpdateManualTimer = globals.curtime()
		Meta.data.ManualSide = Meta.data.ManualSide == 1 and 0 or 1
	elseif ui.get(Meta.elements.AntiAim.ManualRight) and Meta.data.LastUpdateManualTimer + 0.2 < globals.curtime() then
		Meta.data.LastUpdateManualTimer = globals.curtime()
		Meta.data.ManualSide = Meta.data.ManualSide == 2 and 0 or 2
	elseif ui.get(Meta.elements.AntiAim.ManualForward) and Meta.data.LastUpdateManualTimer + 0.2 < globals.curtime() then
		Meta.data.LastUpdateManualTimer = globals.curtime()
		Meta.data.ManualSide = Meta.data.ManualSide == 3 and 0 or 3
	elseif Meta.data.LastUpdateManualTimer > globals.curtime() then
		Meta.data.LastUpdateManualTimer = globals.curtime()
	end
end

Meta.legitonkey = function(e)
	local local_player = entity.get_local_player()
	if not ui.get(Meta.elements.AntiAim.Enabled) or not local_player or not entity.is_alive(local_player) then
		Meta.data.ManualSide = 0
		return
	end

	local weapon = entity.get_player_weapon(local_player)
	if not weapon then
		return
	end

	if ui.get(Meta.elements.AntiAim.LegitOnKey) then
		if entity.get_classname(weapon) == "CC4" then
			if e.in_attack == 1 then
				e.in_attack = 0 
				e.in_use = 1
			end

			ui.set(Meta.reference.freestanding_body_yaw, true)
		else
			if e.chokedcommands == 0 then
				e.in_use = 0
			end
		end
	end
end

Meta.lagcomp = function(e)
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) or not Meta.contains(ui.get(Meta.elements.Misc.features), "LC Breaker") or not ui.get(Meta.elements.Misc.break_lc_key) then
		return
	end

	local time = 1 / globals.tickinterval()
	local origin = vector(entity.get_origin(local_player))
	if e.chokedcommands == 0 then
		Meta.data.PrevPosition[#Meta.data.PrevPosition + 1] = origin
		if #Meta.data.PrevPosition >= time then
			local record = Meta.data.PrevPosition[time]
			Meta.data.BreakerLC = (origin - record):lengthsqr() > 4096
		end
	end

	if #Meta.data.PrevPosition > time then
		table.remove(Meta.data.PrevPosition, 1)
	end

	if Meta.data.BreakerLC and Meta.jumping(local_player) then
		if not Meta.data.PrevLag then
			Meta.data.PrevLag = ui.get(Meta.reference.fakelag_limit)
		end

		ui.set(Meta.reference.fakelag_limit, 1)
	else
		if Meta.data.PrevLag then
			ui.set(Meta.reference.fakelag_limit, Meta.data.PrevLag)
			Meta.data.PrevLag = nil
		end
	end
end

Meta.command = function(e)
	local ent = require "gamesense/entity"
	local me = ent.get_local_player()
	local m_fFlags = me:get_prop("m_fFlags")
	local local_player = entity.get_local_player()
	Meta.data.KeyDownGround = bit.band(m_fFlags, 1) ~= 0
	if not ui.get(Meta.elements.AntiAim.Enabled) or not local_player or not entity.is_alive(local_player) then
		Meta.data.IsLeanAntiAim = false
		return
	end

	Meta.legitonkey(e)
	Meta.updatemanual(e)
	if e.chokedcommands == 0 then
		Meta.data.Flip = not Meta.data.Flip
		return
	end

	local slow_1x_speed = 4
	local slow_2x_speed = 3
	local playerstate = Meta.playerstate()
	local self_index = c_entity.new(local_player)
	local lag_playerstate = Meta.lagplayerstate()
	Meta.data.IsLeanAntiAim = playerstate == 10
	local self_anim_state = self_index:get_anim_state()
	local bodyyaw = Meta.normalizedyaw(self_anim_state.goal_feet_yaw - self_anim_state.eye_angles_y)
	local custom = Meta.elements.AntiAim.Custom[entity.get_prop(local_player, "m_iTeamNum") == 2 and 1 or 2]
	local bindarg = custom[playerstate]
	local lag_bindarg = custom[lag_playerstate]
	if ui.get(Meta.elements.AntiAim.AAMode) == "Preset" then
		local velocity = Meta.velocity(local_player)
		local jumping = Meta.jumping(local_player)
		local player_condition = jumping and 4 or slow and 3 or velocity > 2 and 2 or 1
		local slow = ui.get(Meta.reference.slow_walk[1]) and ui.get(Meta.reference.slow_walk[2])
		local AntiAimVars = {
			{
				roll = 0,
				yaw = "180",
				yaw_offset = 5,
				fakelag_limit = 15,
				body_yaw = "Jitter",
				fakelag_variance = 0,
				body_yaw_offset = 1,
				yaw_jitter_offset = 64,
				yaw_jitter = "Slow 1X",
				fakelag_enabled = true,
				freestanding_body = false,
				fakelag_amount = "Dynamic"
			},

			{
				roll = 0,
				yaw = "180",
				yaw_offset = 6,
				fakelag_limit = 15,
				body_yaw = "Jitter",
				yaw_jitter_offset = 72,
				fakelag_variance = 22,
				yaw_jitter = "Slow 1X",
				body_yaw_offset = - 1,
				fakelag_enabled = true,
				freestanding_body = false,
				fakelag_amount = "Maximum"
			},


			{
				roll = 0,
				yaw = "180",
				yaw_offset = 3,
				fakelag_limit = 15,
				body_yaw = "Jitter",
				fakelag_variance = 0,
				yaw_jitter_offset = 74,
				yaw_jitter = "Slow 1X",
				body_yaw_offset = - 1,
				fakelag_enabled = true,
				freestanding_body = false,
				fakelag_amount = "Dynamic"
			},

			{
				roll = 0,
				yaw = "180",
				yaw_offset = 8,
				fakelag_limit = 15,
				body_yaw = "Jitter",
				fakelag_variance = 0,
				body_yaw_offset = 1,
				yaw_jitter_offset = 78,
				yaw_jitter = "Slow 1X",
				fakelag_enabled = false,
				freestanding_body = false,
				fakelag_amount = "Dynamic"
			},


			{
				roll = 0,
				yaw = "180",
				yaw_offset = 8,
				fakelag_limit = 15,
				body_yaw = "Jitter",
				fakelag_variance = 0,
				yaw_jitter_offset = 69,
				yaw_jitter = "Slow 1X",
				body_yaw_offset = - 1,
				fakelag_enabled = false,
				freestanding_body = false,
				fakelag_amount = "Dynamic"
			}
		}

		ui.set(Meta.reference.pitch[1], "Down")
		ui.set(Meta.reference.yaw_base, "At targets")
		local data = AntiAimVars[player_condition]
		ui.set(Meta.reference.roll, data.roll)
		ui.set(Meta.reference.yaw[1], data.yaw)
		ui.set(Meta.reference.body_yaw[1], data.body_yaw)
		ui.set(Meta.reference.body_yaw[2], data.body_yaw_offset)
		ui.set(Meta.reference.freestanding_body_yaw, data.freestanding_body)
		if data.yaw_jitter == "Slow 1X" then
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.reference.body_yaw[1], "Off")
			local current_offset = (math.abs(data.yaw_jitter_offset) / 2)
			ui.set(Meta.reference.yaw[2], data.yaw_offset + (Meta.data.UpdateTickcount[slow_1x_speed] and current_offset or - current_offset))
		elseif data.yaw_jitter == "Slow 2X" then
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.reference.body_yaw[1], "Off")
			local current_offset = (math.abs(data.yaw_jitter_offset) / 2)
			ui.set(Meta.reference.body_yaw[2], 40) --Meta.data.UpdateTickcount[slow_2x_speed] and - 1 or 1)
			ui.set(Meta.reference.yaw[2], data.yaw_offset + (Meta.data.UpdateTickcount[slow_2x_speed] and current_offset or - current_offset))
		else
			ui.set(Meta.reference.yaw[2], data.yaw_offset)
			ui.set(Meta.reference.yaw_jitter[1], yaw_jitter)
			ui.set(Meta.reference.yaw_jitter[2], data.yaw_jitter_offset)
		end

	elseif ui.get(bindarg.index) == "Single" then
		local data = bindarg["left"]
		local yaw_jitter = ui.get(data.yaw_jitter)
		ui.set(Meta.reference.pitch[1], "Down")
		local yaw_offset = ui.get(data.yaw_offset)
		ui.set(Meta.reference.roll, ui.get(data.roll))
		ui.set(Meta.reference.yaw_base, "At targets")
		ui.set(Meta.reference.yaw[1], ui.get(data.yaw))
		ui.set(Meta.reference.body_yaw[1], ui.get(data.body_yaw))
		ui.set(Meta.reference.body_yaw[2], ui.get(data.body_yaw_offset))
		ui.set(Meta.reference.freestanding_body_yaw, ui.get(data.freestanding_body))
		if yaw_jitter == "Slow 1X" then
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.reference.body_yaw[1], "Off")
			local current_offset = (math.abs(ui.get(data.yaw_jitter_offset)) / 2)
			ui.set(Meta.reference.yaw[2], yaw_offset + (Meta.data.UpdateTickcount[slow_1x_speed] and current_offset or - current_offset))
		elseif yaw_jitter == "Slow 2X" then
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.reference.body_yaw[1], "Off")
			local current_offset = (math.abs(ui.get(data.yaw_jitter_offset)) / 2)
			ui.set(Meta.reference.body_yaw[2], 40) --Meta.data.UpdateTickcount[slow_2x_speed] and - 1 or 1)
			ui.set(Meta.reference.yaw[2], yaw_offset + (Meta.data.UpdateTickcount[slow_2x_speed] and current_offset or - current_offset))
		else
			ui.set(Meta.reference.yaw[2], yaw_offset)
			ui.set(Meta.reference.yaw_jitter[1], yaw_jitter)
			ui.set(Meta.reference.yaw_jitter[2], ui.get(data.yaw_jitter_offset))
		end
	else
		local data = bindarg[bodyyaw > 0 and "right" or "left"]
		local yaw_jitter = ui.get(data.yaw_jitter)
		local yaw_offset = ui.get(data.yaw_offset)
		ui.set(Meta.reference.pitch[1], "Down")
		ui.set(Meta.reference.yaw_base, "At targets")
		if ui.get(data.yaw) == "Random" then
			ui.set(Meta.reference.yaw[1], "180")
			ui.set(Meta.reference.yaw[2], math.random(0, yaw_offset))
		else
			ui.set(Meta.reference.yaw[1], ui.get(data.yaw))
			if ui.get(data.yaw_switch_tickcount) then
				ui.set(Meta.reference.yaw[2], Meta.data.UpdateTickcount[math.random(ui.get(data.yaw_tickcount), ui.get(data.yaw_tickcount_random))] and ui.get(data.yaw_tickcount_offset) or yaw_offset)
			else
				ui.set(Meta.reference.yaw[2], yaw_offset)
			end
		end

		if yaw_jitter == "Slow 1X" then
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.reference.body_yaw[1], "Off")
			local current_offset = math.abs(ui.get(data.yaw_jitter_offset)) / 2
			ui.set(Meta.reference.yaw[2], (Meta.data.UpdateTickcount[slow_1x_speed] and current_offset or - current_offset) + yaw_offset)
		elseif yaw_jitter == "Slow 2X" then
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.reference.body_yaw[1], "Off")
			local current_offset = math.abs(ui.get(data.yaw_jitter_offset)) / 2
			ui.set(Meta.reference.body_yaw[2], 40) --Meta.data.UpdateTickcount[slow_2x_speed] and - 1 or 1)
			ui.set(Meta.reference.yaw[2], (Meta.data.UpdateTickcount[slow_2x_speed] and current_offset or - current_offset) + yaw_offset)
		else
			ui.set(Meta.reference.yaw_jitter[1], yaw_jitter)
			ui.set(Meta.reference.body_yaw[1], ui.get(data.body_yaw))
			ui.set(Meta.reference.body_yaw[2], ui.get(data.body_yaw_offset))
			if ui.get(data.enabled_yawjitter_tickcount) then
				ui.set(Meta.reference.yaw_jitter[2], ui.get(Meta.data.UpdateTickcount[ui.get(data.yaw_jitter_tickcount)] and data.yaw_jitter_tickcount_offset or data.yaw_jitter_offset))
			else
				ui.set(Meta.reference.yaw_jitter[2], ui.get(data.yaw_jitter_offset))
			end
		end

		ui.set(Meta.reference.freestanding_body_yaw, ui.get(data.freestanding_body))
		ui.set(Meta.reference.roll, ui.get(data.roll))
	end

	if Meta.data.ManualSide ~= 0 then
		ui.set(Meta.reference.yaw_jitter[2], 0)
		ui.set(Meta.reference.edge_yaw, false)
		ui.set(Meta.reference.body_yaw[2], 90)
		ui.set(Meta.reference.freestanding[1], false)
		ui.set(Meta.reference.body_yaw[1], "Static")
		ui.set(Meta.reference.yaw_base, "Local view")
		ui.set(Meta.reference.yaw[2], ({- 90, 90, 180})[Meta.data.ManualSide])
	else
		ui.set(Meta.reference.freestanding[1], ui.get(Meta.elements.AntiAim.FreestandYaw))
		ui.set(Meta.reference.edge_yaw, ui.get(Meta.elements.AntiAim.EdgeYaw))
		if ui.get(Meta.elements.AntiAim.DisabledFreestandingInAir) then
			if Meta.jumping(local_player) then
				ui.set(Meta.reference.freestanding[1], false)
			end
		end
	end

	ui.set(Meta.reference.fakelag_limit, ui.get(lag_bindarg.fakelag_limit))
	ui.set(Meta.reference.fakelag_amount, ui.get(lag_bindarg.fakelag_amount))
	ui.set(Meta.reference.fakelag_variance, ui.get(lag_bindarg.fakelag_variance))
end

Meta.commandmisc = function(e)
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	local features = ui.get(Meta.elements.Misc.features)
	if Meta.contains(features, "Avoid backstab") then
		local m_origin = vector(entity.get_origin(local_player))
		for _, ptr in pairs(entity.get_players(true)) do
			if entity.is_alive(ptr) then
				local origin = vector(entity.get_origin(ptr))
				local weapon = entity.get_player_weapon(ptr)
				if weapon and entity.get_classname(weapon) == "CKnife" and (m_origin:dist(origin)) < 100 then
					ui.set(Meta.reference.yaw[2], 180)
				end
			end
		end
	end

	local os = ui.get(Meta.reference.onshot[1]) and ui.get(Meta.reference.onshot[2])
	if Meta.contains(features, "Fix hideshots") and os then
		e.allow_send_packet = true
	end

	if Meta.contains(features, "Force defensive") and Meta.simulationdifferent() < 0 and ui.get(Meta.elements.Misc.force_defensive_key) then
		e.force_defensive = true
	end
end

Meta.animation = function()
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	local self_index = c_entity.new(local_player)
	local self_anim_state = self_index:get_anim_state()
	local features = ui.get(Meta.elements.Misc.features)
	if Meta.contains(features, "Static leg in air") and not Meta.data.KeyDownGround then
		entity.set_prop(local_player, "m_flPoseParameter", 1, 6)
	end

	if Meta.contains(features, "Static leg in slow") then
		entity.set_prop(local_player, "m_flPoseParameter", 0, 9)
	end

	if Meta.contains(features, "Michael jackson") and not Meta.data.KeyDownGround then
		local my_animlayer = self_index:get_anim_overlay(6)
		my_animlayer.weight = 1
	end

	if Meta.contains(features, "Michael jackson") and Meta.data.KeyDownGround then
		local leg_mode = ui.get(Meta.elements.Misc.leg_mode)
		local smooth = globals.frametime() * 2
		if not Meta.data.LegMichaelData[2] then
			Meta.data.LegMichaelData[1] = Meta.clamp(Meta.data.LegMichaelData[1] + smooth, 0, 1)
			if Meta.data.LegMichaelData[1] >= 1 then
				Meta.data.LegMichaelData[1] = 1
				Meta.data.LegMichaelData[2] = true
			end
		else
			Meta.data.LegMichaelData[1] = Meta.clamp(Meta.data.LegMichaelData[1] - smooth, 0, 1)
			if Meta.data.LegMichaelData[1] <= 0 then
				Meta.data.LegMichaelData[1] = 0
				Meta.data.LegMichaelData[2] = false
			end
		end

		if not Meta.data.MichaelSwitchState[1] then
			if math.abs(Meta.data.MichaelSwitchState[2] - globals.tickcount()) > 30 then
				Meta.data.MichaelSwitchState[1] = true
				Meta.data.MichaelSwitchState[2] = globals.tickcount()
			end
		else
			if math.abs(Meta.data.MichaelSwitchState[2] - globals.tickcount()) > 18 then
				Meta.data.MichaelSwitchState[1] = false
				Meta.data.MichaelSwitchState[2] = globals.tickcount()
			end
		end

		if not Meta.data.SwitchLegModified[2] then
			if globals.tickcount() > Meta.data.SwitchLegModified[1] then
				Meta.data.SwitchLegModified[2] = true
				Meta.data.SwitchLegModified[1] = globals.tickcount() + 4
			end
		else
			if globals.tickcount() > Meta.data.SwitchLegModified[1] then
				Meta.data.SwitchLegModified[2] = false
				Meta.data.SwitchLegModified[1] = globals.tickcount() + 32
			end
		end

		if leg_mode == "1" then
			ui.set(Meta.reference.leg_movement, "Never slide")
			entity.set_prop(local_player, "m_flPoseParameter", 0, 7)
			entity.set_prop(local_player, "m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 0.5 or 1)
		elseif leg_mode == "2" then
			ui.set(Meta.reference.leg_movement, Meta.data.SwitchLegModified[2] and "Always slide" or "Never slide")
			entity.set_prop(local_player, "m_flPoseParameter", 0, 7)
		end

		if Meta.data.ManualSide == 1 or Meta.data.ManualSide == 2 then
			ui.set(Meta.reference.leg_movement, "Always slide")
			entity.set_prop(local_player, "m_flPoseParameter", 0.45, 0)
		end
	end

	if Meta.contains(features, "0 pitch on land") and self_anim_state.hit_in_ground_animation and Meta.data.KeyDownGround then
		entity.set_prop(local_player, "m_flPoseParameter", 0.5, 12)
	end
end

Meta.renderglowtext = function(x, y, r, g, b, a, flags, idx, text, glow_radius, ref_text)
	for index = 1, 8 do
		local vec = vector(x, y)
		local text = ref_text or text
		local this_color = {r, g, b, a * (Meta.clamp(index * glow_radius, 0, 255) / 255)}
		if this_color[4] > 0 then
			renderer.text(vec.x - index / 3, vec.y, this_color[1], this_color[2], this_color[3], this_color[4], flags, idx, text)
			renderer.text(vec.x, vec.y - index / 3, this_color[1], this_color[2], this_color[3], this_color[4], flags, idx, text)
			renderer.text(vec.x, vec.y + index / 3, this_color[1], this_color[2], this_color[3], this_color[4], flags, idx, text)
			renderer.text(vec.x + index / 3, vec.y, this_color[1], this_color[2], this_color[3], this_color[4], flags, idx, text)
			renderer.text(vec.x - index / 3, vec.y - index / 3, this_color[1], this_color[2], this_color[3], this_color[4], flags, idx, text)
			renderer.text(vec.x - index / 3, vec.y + index / 3, this_color[1], this_color[2], this_color[3], this_color[4], flags, idx, text)
			renderer.text(vec.x + index / 3, vec.y - index / 3, this_color[1], this_color[2], this_color[3], this_color[4], flags, idx, text)
			renderer.text(vec.x + index / 3, vec.y  + index / 3, this_color[1], this_color[2], this_color[3], this_color[4], flags, idx, text)
		end
	end

	renderer.text(x, y, r, g, b, a, flags, idx, text)
end

Meta.tabletocolor = function(tab)
	return {
		r = tab[1],
		g = tab[2],
		b = tab[3],
		a = tab[4]
	}
end

Meta.rgbatohex = function(r, g, b, a)
	return ("%02x%02x%02x%02x"):format(r, g, b, a)
end

Meta.textfadeanimation = function(x, y, speed, color1, color2, text, glow, adder, flags)
	local final_text =  ''
	local start_final_text = adder or ""
	local curtime = globals.curtime()
	for i = 0, #text do
		local x = i * 10  
		local wave = math.cos(2 * speed * curtime / 4 + x / 30)
		local color = Meta.rgbatohex(
			Meta.lerp(color1.r, color2.r, Meta.clamp(wave, 0, 1)),
			Meta.lerp(color1.g, color2.g, Meta.clamp(wave, 0, 1)),
			Meta.lerp(color1.b, color2.b, Meta.clamp(wave, 0, 1)),
			color1.a
		) 

		final_text = final_text .. '\a' .. color .. text:sub(i, i) .. start_final_text
		start_final_text = ""
	end

	if glow then
		Meta.renderglowtext(x, y, color1.r, color1.g, color1.b, color1.a, flags, 0, final_text, 1, adder .. text)
	else
		renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, flags, nil, final_text)
	end
end

Meta.outlineleftglow = function(x, y, w, h, radius, r, g, b, a)
	local n = 45
	local o = 16
	local rounding = 4
	local rad = rounding + 2
	renderer.rectangle(x + 2, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
	renderer.circle_outline(x + radius + rad, y + radius + rad, r, g, b, a, radius + rounding, 180, 0.25, 1)
	renderer.circle_outline(x + radius + rad, y + h - radius - rad, r, g, b, a, radius + rounding, 90, 0.25, 1)
end

Meta.outlinerightglow = function(x, y, w, h, radius, r, g, b, a)
	local n = 45
	local o = 16
	local rounding = 4
	local rad = rounding + 2
	renderer.rectangle(x + w - 3, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
	renderer.circle_outline(x + w - radius - rad, y + radius + rad, r, g, b, a, radius + rounding, 270, 0.25, 1)
	renderer.circle_outline(x + w - radius - rad, y + h - radius - rad, r, g, b, a, radius + rounding, 0, 0.25, 1)
end

Meta.renderbackground = function(x, y, w, h, r, g, b, a)
	if not Meta.data.CachedTexture then
		return
	end

	local glow = (a / 255) * 22
	local glow_center = vector(20, (h / 2))
	for radius = 1, glow do
		local radius = radius / 2
		Meta.outlineleftglow(x - radius - 3, y - radius + (h / 4), glow_center.x + radius * 2, glow_center.y + radius * 2, radius, r, g, b, (glow - radius * 2))
	end

	for radius = 1, glow do
		local radius = radius / 2
		Meta.outlinerightglow(x - radius + w - 16, y - radius + (h / 4), glow_center.x + radius * 2, glow_center.y + radius * 2, radius, r, g, b, (glow - radius * 2))
	end

	Meta.roundrect(x, y, w, h, 5, 35, 35, 35, 255)
	renderer.rectangle(x + w - 1, y + (h / 4) + 1, 2, (h / 2) - 3, r, g, b, a)
	renderer.rectangle(x - 1, y + (h / 4) + 1, 2, (h / 2) - 3, r, g, b, a)
end

Meta.indication = function()
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	local smooth = globals.frametime() * 11.5
	local screen = vector(client.screen_size())
	local center = screen / 2
	local default_color = {255, 255, 255, 255}
	local fakeduck = ui.get(Meta.reference.fake_duck)
	local force_safe = ui.get(Meta.reference.force_safe)
	local tickbase = antiaim_funcs.get_tickbase_shifting()
	local force_body = ui.get(Meta.reference.force_body)
	local bar_color = {ui.get(Meta.elements.Visuals.BarColor)}
	local legit_color = {ui.get(Meta.elements.Visuals.LegitColor)}
	local edge_color = {ui.get(Meta.elements.Visuals.EdgeColor)}
	local name_color = {ui.get(Meta.elements.Visuals.NameColor)}
	local name_color2 = {ui.get(Meta.elements.Visuals.NameColor2)}
	local b_zoom = entity.get_prop(local_player, "m_bIsScoped") == 1
	local force_draw_hotkey = ui.get(Meta.elements.Visuals.HotkeyAlways)
	local animation_mode = ui.get(Meta.elements.Visuals.AnimationMode)
	local onshot = ui.get(Meta.reference.onshot[1]) and ui.get(Meta.reference.onshot[2])
	local doubletap = ui.get(Meta.reference.doubletap[1]) and ui.get(Meta.reference.doubletap[2])
	local oscolor = onshot and {ui.get(Meta.elements.Visuals.OSColor)} or default_color
	local fdcolor = fakeduck and {ui.get(Meta.elements.Visuals.FDColor)} or default_color
	local dtcolor = doubletap and {ui.get(Meta.elements.Visuals.DTColor)} or default_color
	local safe_color = force_safe and {ui.get(Meta.elements.Visuals.SafeColor)} or default_color
	local baim_color = force_body and {ui.get(Meta.elements.Visuals.BaimColor)} or default_color
	if not Meta.data.CachedTexture then
		Meta.data.CachedTexture = renderer.load_svg(Meta.newtexture(500, 25), 0, 25)
	end

	if ui.get(Meta.elements.Visuals.CrosshairStyle) == "1" then
		local different = 0
		local medium_smooth = globals.frametime() * 5
		local hotkeys_smooth = globals.frametime() * (animation_mode == "Lerp" and 8 or 10)
		if globals.chokedcommands() == 0 then
			local self_index = c_entity.new(local_player)
			local self_anim_state = self_index:get_anim_state()
			Meta.data.UpdateBodyYaw = math.abs(Meta.normalizedyaw(self_anim_state.goal_feet_yaw - self_anim_state.eye_angles_y))
		end

		local tickbase_amount = Meta.clamp(tickbase, 0, 11) / 11
		local body_amount = Meta.createlerp(Meta.data.UpdateBodyYaw, "Body Amount", medium_smooth)
		Meta.textfadeanimation(center.x, center.y + 20, 1, Meta.tabletocolor(name_color), Meta.tabletocolor(name_color2), "ZYXORIN", true, "", "b")
		for radius = 1, 17 do
			local radius = radius / 2
		end

		renderer.rectangle(center.x, center.y + 34, math.max(0, math.min(body_amount / 58, 1)) * 56, 3, bar_color[1], bar_color[2], bar_color[3], bar_color[4])
		local hotkeys = {
			["DT"] = {doubletap, dtcolor, {255, (tickbase_amount * 255), (tickbase_amount * 255), dtcolor[4]}},
			["HS"] = {onshot, oscolor},
			["SAFE"] = {force_safe, safe_color},
			["BAIM"] = {force_body, baim_color},
			["DUCK"] = {fakeduck, fdcolor}
		}

		local start_offset = 60
		local animation_process = {
			["DT"] = Meta.createstaticanimation(0, 1, hotkeys["DT"][1], hotkeys_smooth, "DT Modified"),
			["HS"] = Meta.createstaticanimation(0, 1, hotkeys["HS"][1], hotkeys_smooth, "HS Modified"),
			["SAFE"] = Meta.createstaticanimation(0, 1, hotkeys["SAFE"][1], hotkeys_smooth, "SAFE Modified"),
			["BAIM"] = Meta.createstaticanimation(0, 1, hotkeys["BAIM"][1], hotkeys_smooth, "BAIM Modified"),
			["DUCK"] = Meta.createstaticanimation(0, 1, hotkeys["DUCK"][1], hotkeys_smooth, "DUCK Modified")
		}

		for text, data in pairs(hotkeys) do
			local modified = animation_process[text]
			local text_size = vector(renderer.measure_text("b", text))
			local animation = animation_mode == "Lerp" and Meta.createlerp(data[1] and 1 or 0, text, hotkeys_smooth) or Meta.createstaticanimation(0, 1, data[1], hotkeys_smooth, text)
			Meta.renderglowtext(center.x + (start_offset - (modified * start_offset)), center.y + 39 + different, data[2][1], data[2][2], data[2][3], data[2][4] * animation, "", 0, text, 1, text)
			if text == "DT" and tickbase_amount > 0 then
				renderer.circle_outline(center.x + 18 + (start_offset - (modified * start_offset)), center.y + 45 + different, data[3][1], data[3][2], data[3][3], data[3][4] * animation, 4, 45, tickbase_amount, 1.5)
			end

			different = different + (animation * (text_size.y + 1))
		end

	elseif ui.get(Meta.elements.Visuals.CrosshairStyle) == "2" then
		local different = 0
		if globals.chokedcommands() == 0 then
			local self_index = c_entity.new(local_player)
			local self_anim_state = self_index:get_anim_state()
			Meta.data.UpdateBodyYaw = math.abs(Meta.normalizedyaw(self_anim_state.goal_feet_yaw - self_anim_state.eye_angles_y))
		end

		local tickbase_amount = Meta.clamp(tickbase, 0, 11) / 11
		local size = vector(renderer.measure_text("b", Meta.data.ScriptName1))
		Meta.textfadeanimation(center.x, center.y + 20, 1, Meta.tabletocolor(name_color), Meta.tabletocolor(name_color2), Meta.data.ScriptNameUnicode, true, "♞", "b")
		renderer.rectangle(center.x - 1, center.y + 33, 71, 5, 25, 25, 25, 150)
		renderer.gradient(center.x, center.y + 34, math.max(0, math.min(Meta.data.UpdateBodyYaw / 58, 1)) * 69, 3, bar_color[1], bar_color[2], bar_color[3], bar_color[4], bar_color[1], bar_color[2], bar_color[3], 0, true)
		--Meta.containerglow(center.x, center.y + 34, math.max(0, math.min(Meta.data.UpdateBodyYaw / 58, 1)) * 69, 5, bar_color[1], bar_color[2], bar_color[3], bar_color[4], 1, bar_color[1], bar_color[2], bar_color[3])
		local hotkeys = {
			["Hide"] = {onshot, oscolor},
			["Duck"] = {fakeduck, fdcolor},
			["Edge"] = {ui.get(Meta.elements.AntiAim.EdgeYaw), legit_color},
			["Legit"] = {ui.get(Meta.elements.AntiAim.LegitOnKey), edge_color},
			["DT"] = {doubletap, dtcolor, {255, (tickbase_amount * 255), (tickbase_amount * 255), dtcolor[4]}}
		}

		local start_offset = 60
		local hotkeys_smooth = globals.frametime() * (animation_mode == "Lerp" and 8 or 10)
		local animation_process = Meta.createstaticanimation(0, 1, hotkeys["Hide"][1] or hotkeys["Duck"][1] or hotkeys["Edge"][1] or hotkeys["Legit"][1] or hotkeys["DT"][1], hotkeys_smooth, "Hotkeys Process")
		for text, data in pairs(hotkeys) do
			local text_size = vector(renderer.measure_text("b", text))
			local animation = animation_mode == "Lerp" and Meta.createlerp(data[1] and 1 or 0, text, hotkeys_smooth) or Meta.createstaticanimation(0, 1, data[1], hotkeys_smooth, text)
			Meta.renderglowtext(center.x + different + (start_offset - (animation_process * start_offset)), center.y + 40, data[2][1], data[2][2], data[2][3], data[2][4] * animation, "b", 0, text, 1, text)
			if text == "DT" and tickbase_amount > 0 then
				renderer.circle_outline(center.x + different + 22 + (start_offset - (animation_process * start_offset)), center.y + 46, data[3][1], data[3][2], data[3][3], data[3][4] * animation, 5, 45, tickbase_amount, 2)
				different = different + 13
			end

			different = different + (animation * (text_size.x + 5))
		end

	elseif ui.get(Meta.elements.Visuals.CrosshairStyle) == "3" then
		local different = 0
		if globals.chokedcommands() == 0 then
			local self_index = c_entity.new(local_player)
			local self_anim_state = self_index:get_anim_state()
			Meta.data.UpdateBodyYaw = Meta.normalizedyaw(self_anim_state.goal_feet_yaw - self_anim_state.eye_angles_y)
		end

		local tickbase_amount = Meta.clamp(tickbase, 0, 11) / 11
		local desync_amount = math.abs(Meta.data.UpdateBodyYaw / 60)
		renderer.text(center.x, center.y + 15, 255, 255, 255, 255, "c-", 0, "ZYXORIN")
		Meta.roundrect(center.x - 13, center.y + 21, 31, 5, 2, 0, 0, 0, 115)
		print(Meta.data.UpdateBodyYaw)
		if Meta.data.UpdateBodyYaw > 0 then
			Meta.roundrect(center.x - 12, center.y + 22, math.abs(desync_amount * 15), 3, 2, 255, 255, 255, 255)
		else
			Meta.roundrect(center.x + 14, center.y + 22, - math.abs(desync_amount * 10), 3, 2, 255, 255, 255, 255)
		end

		if doubletap then
			renderer.text(center.x, center.y + 31, 255 - (tickbase_amount * 255), tickbase_amount * 255, 0, 255, "c-", 0, "DT")
			different = different + 1
		end

		if onshot then
			renderer.text(center.x, center.y + 31 + (different * 10), 255, 255, 255, 255, "c-", 0, "OS")
			different = different + 1
		end

		if ui.get(Meta.reference.freestanding[1]) then
			renderer.text(center.x, center.y + 31 + (different * 10), 255, 255, 255, 255, "c-", 0, "FS")
			different = different + 1
		end

		if ui.get(Meta.elements.AntiAim.EdgeYaw) then
			renderer.text(center.x, center.y + 31 + (different * 10), 255, 255, 255, 255, "c-", 0, "EDGE")
			different = different + 1
		end

		if force_body then
			renderer.text(center.x, center.y + 31 + (different * 10), 255, 255, 255, 255, "c-", 0, "BAIM")
			different = different + 1
		end

		if fakeduck then
			renderer.text(center.x, center.y + 31 + (different * 10), 255, 255, 255, 255, "c-", 0, "DUCK")
			different = different + 1
		end

		renderer.text(center.x, center.y + 31 + (different * 10), 255, 255, 255, 255, "c-", 0, "DMG: 11")
		if Meta.data.IsLeanAntiAim then
			renderer.text(center.x, center.y + 31 + (different * 10), 255, 255, 255, 255, "c-", 0, "LEAN")
			different = different + 1
		end
	end

	local manual_dist = ui.get(Meta.elements.Visuals.ManualDistance)
	local manual_color = {ui.get(Meta.elements.Visuals.ManualColor)}
	if ui.get(Meta.elements.Visuals.ManualIndication) == "1" then
		if Meta.data.ManualSide == 1 then
			renderer.text(center.x - manual_dist, center.y - 1, manual_color[1], manual_color[2], manual_color[3], manual_color[4], "cb", 0, "❮")
		elseif Meta.data.ManualSide == 2 then
			renderer.text(center.x + manual_dist, center.y - 1, manual_color[1], manual_color[2], manual_color[3], manual_color[4], "cb", 0, "❯")
		end

	elseif ui.get(Meta.elements.Visuals.ManualIndication) == "2" then
		if Meta.data.ManualSide == 1 then
			renderer.text(center.x - manual_dist, center.y - 1, manual_color[1], manual_color[2], manual_color[3], manual_color[4], "cb", 0, "⮜")
		elseif Meta.data.ManualSide == 2 then
			renderer.text(center.x + manual_dist, center.y - 1, manual_color[1], manual_color[2], manual_color[3], manual_color[4], "cb", 0, "⮞")
		end

	elseif ui.get(Meta.elements.Visuals.ManualIndication) == "3" then
		if Meta.data.ManualSide == 1 then
			renderer.text(center.x - manual_dist, center.y - 3, manual_color[1], manual_color[2], manual_color[3], manual_color[4], "c+", 0, "⯇")
		elseif Meta.data.ManualSide == 2 then
			renderer.text(center.x + manual_dist, center.y - 3, manual_color[1], manual_color[2], manual_color[3], manual_color[4], "c+", 0, "⯈")
		end
	end

	if ui.get(Meta.elements.Visuals.Hitlog) ~= "Off" then
		local curtime = globals.curtime()
		local smooth = globals.frametime() * 5
		local hitlog_style = ui.get(Meta.elements.Visuals.Hitlog)
		local log_color = {ui.get(Meta.elements.Visuals.HitlogColor)}
		for index, data in pairs(Meta.data.Notifys) do
			local time_different = math.abs(curtime - data.timer)
			if hitlog_style == "1" then
				local different = 40
				local weight = 200 * data.alpha
				local size = vector(renderer.measure_text("-", data.text:upper())) + vector(10)
				local glow_start = vector(center.x - (size.x / 2) - 5, screen.y - weight - 10 - (index * different))
				Meta.renderbackground(glow_start.x + (size.x / 300), glow_start.y + (size.y / 1), size.x + (size.x / 18), 24, log_color[1], log_color[2], log_color[3], log_color[4] * data.alpha)
				renderer.text(center.x - (size.x / 2.12), screen.y + (size.y / 1) - weight - 3.85 - (index * different), 255, 255, 255, 255 * data.alpha, "-", 0, data.text:upper())
				if data.stage == 1 then
					data.alpha = math.min(1, data.alpha + smooth)
					if time_different > 7 then
						data.stage = 2
					end
				else
					data.alpha = math.max(0, data.alpha - smooth)
					if data.alpha <= 0 then
						table.remove(Meta.data.Notifys, index)
					end
				end

			elseif hitlog_style == "2" then
				local different = 40
				local weight = 200 * data.alpha
				local size = vector(renderer.measure_text(nil, data.text)) + vector(10)
				local glow_start = vector(center.x - (size.x / 2) - 5, screen.y - weight - 10 - (index * different))
				Meta.containerglow(glow_start.x, glow_start.y, size.x, 24, log_color[1], log_color[2], log_color[3], log_color[4] * data.alpha, data.alpha, log_color[1], log_color[2], log_color[3])
				renderer.text(center.x - (size.x / 2), screen.y - weight - 4 - (index * different), 255, 255, 255, 255 * data.alpha, "nil", 0, data.text)
				if data.stage == 1 then
					data.alpha = math.min(1, data.alpha + smooth)
					if time_different > 2 then
						data.stage = 2
					end
				else
					data.alpha = math.max(0, data.alpha - smooth)
					if data.alpha <= 0 then
						table.remove(Meta.data.Notifys, index)
					end
				end

			elseif hitlog_style == "3" then
				local different = 40
				local weight = 200 * data.alpha
				local size = vector(renderer.measure_text("", data.text)) + vector(10)
				local glow_start = vector(center.x - (size.x / 2) - 5, screen.y - weight - 10 - (index * different))
				Meta.renderbackground(glow_start.x + (size.x / 300), glow_start.y + (size.y / 1), size.x + (size.x / 18), 24, log_color[1], log_color[2], log_color[3], log_color[4] * data.alpha)
				renderer.text(center.x - (size.x / 2.14), screen.y + (size.y / 1) - weight - 4 - (index * different), 255, 255, 255, 255 * data.alpha, "", 0, data.text)
				if data.stage == 1 then
					data.alpha = math.min(1, data.alpha + smooth)
					if time_different > 7 then
						data.stage = 2
					end
				else
					data.alpha = math.max(0, data.alpha - smooth)
					if data.alpha <= 0 then
						table.remove(Meta.data.Notifys, index)
					end
				end
			end
		end
	end
end

Meta.callbacks = {
	["paint"] = function(e)
		Meta.indication(e)
	end,

	["paint_ui"] = function(e)
		Meta.handlereference(not ui.get(Meta.elements.AntiAim.Enabled))
	end,

	["aim_hit"] = function(e)
		Meta.aimhit(e)
	end,

	["aim_miss"] = function(e)
		Meta.aimmiss(e)
	end,

	["pre_render"] = function(e)
		Meta.animation(e)
	end,

	["setup_command"] = function(e)
		Meta.lagcomp(e)
		Meta.command(e)
		Meta.updatetick(e)
		Meta.commandmisc(e)
	end,

	["shutdown"] = function()
		database.write("zyxorin configs", Meta.data.Configs)
		database.write("zyxorin configs data", Meta.data.ConfigsData)
	end
}

Meta.main = function()
	Meta.multicallback(Meta.elements, Meta.handlemain, true)
	for Key, Handle in pairs(Meta.callbacks) do
		local succes, data = pcall(client.set_event_callback, Key, Handle)
		if not success and data then
			error(("[ %s ]error: failed set callback: %s, result: %s"):format(Meta.data.ScriptName, Key, data))
		end
	end
end
--add

local b = function(c, d)
    for e = 1, #c do
        if c[e] == d then
            return true
        end
    end
    return false
end
local f = {ui.reference("AA", "Other", "On shot anti-aim")}
local g = ui.reference("Rage", "Other", "Duck peek assist")
client.set_event_callback(
    "pre_render",
    function()
        if ui.get(Meta.elements.Visuals.h) then
            local m = entity.get_local_player()
            if m and entity.is_alive(m) then
                local n = math.floor(globals.curtime() * ui.get(Meta.elements.Visuals.l) * 8) % 2 == 0
                local o = {entity.get_prop(m, "m_vecVelocity")}
                local p = math.abs(o[1]) > 5 or math.abs(o[2]) > 5 or math.abs(o[3]) > 5
                local q = ui.get(f[1]) and ui.get(f[2])
                local r = ui.get(g)
                local s = entity.get_prop(m, "m_flDuckAmount") > 0.5
                if (not a.get_double_tap() and not q and not r and p or ui.get(Meta.elements.Visuals.i) == "Always") and not s then
                    local t = ui.get(Meta.elements.Visuals.k)
                    local u = ui.get(Meta.elements.Visuals.j)
                    for v, w in ipairs(u) do
                        entity.set_prop(m, "m_flPoseParameter", n and t * 0.01 or 0, tonumber(w))
                    end
                end
            end
		end
    end
)
--add 2
	RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
    	return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
	end
	local screen = {client.screen_size()}
	local x_offset, y_offset = screen[1], screen[2]
	local x, y =  x_offset/2,y_offset/2 

animated = function()
if ui.get(Meta.elements.Visuals.water) then
    local r,g,b = ui.get(Meta.elements.Visuals.fade_color)
    local aA = {
        {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 60 / 30))},
       	{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 55 / 30))},
        {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 50 / 30))},
        {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 45 / 30))},
        {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 40 / 30))},
        {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 35 / 30))},
        {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 30 / 30))},
        {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 25 / 30))},
        {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 20 / 30))},
        {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 15 / 30))},
        {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 10 / 30))},
        {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 5 / 30))},
        {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 0 / 30))}
    }
    
    renderer.text(x, y + 700, 0, 0, 0, 50, "-c", nil, "ZYXORIN.LUA")
    renderer.text(x, y + 700, 255, 255, 255, 255, "-c", nil, string.format("\a%sZ\a%sY\a%sX\a%sO\a%sR\a%sI\a%sN ", RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5])), RGBAtoHEX(unpack(aA[6])), RGBAtoHEX(unpack(aA[7]))))
	renderer.text(x, y + 708, 255, 255, 255, 255, "-c", nil, string.format("\a%s-\a%sT\a%sE\a%sC\a%sH\a%sN\a%sO\a%sL\a%sO\a%sG\a%sY\a%s-", RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5])), RGBAtoHEX(unpack(aA[6])), RGBAtoHEX(unpack(aA[7])), RGBAtoHEX(unpack(aA[8])), RGBAtoHEX(unpack(aA[9])), RGBAtoHEX(unpack(aA[10])), RGBAtoHEX(unpack(aA[11])), RGBAtoHEX(unpack(aA[12]))))
	end
end

client.set_event_callback("paint", animated)
client.set_event_callback("net_update_end", function()
	for _, ptr in pairs(entity.get_players(true)) do
		Meta.simulation(ptr)
	end
end)

client.exec("cl_bob_lower_amt 0")
client.exec("cl_bobamt_lat 0")
client.exec("cl_bobamt_vert 0")
Meta.main()