-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local ffi = require("ffi")
local Meta = {}
local vector = require("vector")
local surface = require("gamesense/surface") or error("failed load surface library, please request")
local c_entity = require("gamesense/entity") or error("zyxorin: error !, failed require gamesense/entity library")
local base64 = require("gamesense/base64") or error("zyxorin: error !, failed require gamesense/base64 library")
local clipboard = require("gamesense/clipboard") or error("zyxorin: error !, failed require gamesense/clipboard library")
local antiaim_funcs = require("gamesense/antiaim_funcs") or error("zyxorin: error !, failed require gamesense/antiaim_functions library")
local old_font = surface.create_font("Verdana", 23, 700, {0x010, 0x080})
Meta.data = {
	Flip = false,
	Notifys = {},
	SpinYaw = 0,
	PrevLag = nil,
	Simulation = {},
	ManualSide = 0,
	CachedLerp = {},
	SyncZOrigin = 0,
	PrevPosition = {},
	CachedWays = {},
	BreakerLC = false,
	BodyYawSeed = 0,
	PtevSimulation = 0,
	ConfigPackage = {},
	CurrentChoked = 0,
	Teams = {"Terrorist", "Counter-Terrorist"},
	Author = "SYR1337",
	UpdateBodyYaw = 0,
	UpdateTickcount = {},
	IsLeanAntiAim = false,
	CachedAnimation = {},
	LastPinPulledTicks = 0,
	CachedTexture = false,
	Side = {"Left", "Right"},
	GrenadeRelease = false,
	DifferentSimulation = 0,
	GrenadeReleaseReset = 0,
	GrenadeReleaseTimer = 0,
	ScriptName = "zyxorin.Lua",
	ScriptName1 = "♞zyxorin+",
	ScriptNameUnicode = "zyxorin+",
	ScriptNameUnicode2 = "zyx",
	KeyDownGround = false,
	LegMichaelData = {0, false},
	CurrentBodyYawAngles = 0,
	JitterSpeedStage = {false, 0},
	LastUpdateManualTimer = 0,
	Panorama = panorama.open(),
	MichaelSwitchState = {false, 0},
	SwitchLegModified = {0, false},
	ConfigsData = database.read("zyxorin configs data") or {},
	Configs = database.read("zyxorin configs") or {"no config"},
	JitterIdealAngles = {- 17, - 60, - 69, - 78, - 136, - 177, 6, 15, 33, 51, 83, 122, 164, 178},
	PlayerState = {"Global", "Stand", "Move", "Slow", "Air", "Duck stand", "Duck move", "Air+crouching", "On shot", "Body lean", "Fakelag"}
}

Meta.rgbatohex = function(r, g, b, a)
	return ("%02x%02x%02x%02x"):format(r, g, b, a)
end

Meta.gradienttext = function(text, r1, g1, b1, a1, r2, g2, b2, a2)
	local output = ""
	local len = #text - 1
	local rinc = (r2 - r1) / len
	local ainc = (a2 - a1) / len
	local ginc = (g2 - g1) / len
	local binc = (b2 - b1) / len
	for i = 1, len + 1 do 
		output = output .. ("\a%s%s"):format(Meta.rgbatohex(r1, g1, b1, a1), text:sub(i, i))
		r1 = r1 + rinc
		a1 = a1 + ainc
		b1 = b1 + binc
		g1 = g1 + ginc
	end

	return output
end

Meta.elements = {
	MasterSwitch = ui.new_checkbox("AA", "Anti-aimbot angles", "\nsb666"),
	MasterSwitchLabel = ui.new_label("AA", "Anti-aimbot angles", "enable zyxorin"),
	Group = ui.new_combobox("AA", "Anti-aimbot angles", "classification", {"anti-aim", "visuals", "misc", "configs"}),
	AntiAim = {
		Enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB9B7F1FFarchit\aFFFFFFCEecture"),
		EdgeYaw = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB9B7F1FF+\aFFFFFFCE/- \aFFFFFFCEEdge yaw"),
		LegitOnKey = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB9B7F1FF+\aFFFFFFCE/- \aFFFFFFCELegit anti aim"),
		ManualLeft = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB9B7F1FF+\aFFFFFFCE/- \aFFFFFFCEManual-left"),
		ManualRight = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB9B7F1FF+\aFFFFFFCE/- \aFFFFFFCEManual-right"),
		ManualForward = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB9B7F1FF+\aFFFFFFCE/- \aFFFFFFCEManual-forward"),
		FreestandYaw = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB9B7F1FF+\aFFFFFFCE/- \aFFFFFFCEFreestanding yaw"),
		DisabledFreestandingInAir = ui.new_checkbox("AA", "Anti-aimbot angles", "Disable freestanding \aB9B7F1FFin-air"),
		OverrideAntiAimBase = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFF0000FFOverride anti-aim base"),
		AAMode = ui.new_combobox("AA", "Anti-aimbot angles", "AA mode", {"Preset", "Conditions"}),
		Team = ui.new_combobox("AA", "Anti-aimbot angles", "Team select", Meta.data.Teams),
		PlayerState = ui.new_combobox("AA", "Anti-aimbot angles", "Player state", Meta.data.PlayerState),
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
							yaw = ui.new_combobox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw\n %s %s L"):format(index, idx), {"Off", "180", "Spin", "Static", "180 Z", "Crosshair", "Random", "Tickcount"}),
							yaw_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Offset L"):format(index, idx), - 180, 180, 0),
							yaw_tickcount_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Jitter Offset L Tick"):format(index, idx), - 180, 180, - 15),
							yaw_tickcount = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCETickcount amount\n %s %s L"):format(index, idx), 0, 2, 0, true, "", 1, {[0] = "Low", [1] = "Medium", [2] = "High"}),
							yaw_tickcount_random = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCETickcount amount random\n %s %s L"):format(index, idx), 0, 2, 0, true, "", 1, {[0] = "Fast", [1] = "Medium", [2] = "Slow"}),
							yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw jitter\n %s %s L"):format(index, idx), {"Off", "Offset", "Center", "Random", "Skitter", "Slow 1X", "Slow 2X"}),
							yaw_jitter_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Jitter Offset L"):format(index, idx), - 180, 180, 0),
							enabled_yawjitter_tickcount = ui.new_checkbox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw jitter tickcount switch\n %s %s L"):format(index, idx), false),
							yaw_jitter_tickcount_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Jitter Offset L Tick Jitter"):format(index, idx), - 180, 180, - 90),
							yaw_jitter_tickcount = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCETickcount amount\n %s %s L Jitter"):format(index, idx), 0, 2, 0, true, "", 1, {[0] = "Fast", [1] = "Medium", [2] = "Slow"}),
							body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", ("\aFFFFFFCEBody yaw\n %s %s L"):format(index, idx), {"Off", "Opposite", "Jitter", "Static"}),
							body_yaw_tick = ui.new_slider("AA", "Anti-aimbot angles", ("Rework speed\n %s %s L"):format(index, idx), 2, 64, 8),
							body_yaw_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Body Offset L"):format(index, idx), - 180, 180, 0),
							fake_yaw_offset = ui.new_slider("AA", "Anti-aimbot angles", ("Fake Yaw Limit\n %s %s L"):format(index, idx), 0, 60, 60),
							freestanding_body = ui.new_checkbox("AA", "Anti-aimbot angles", ("\aFFFFFFCEFreestanding body yaw\n %s %s L"):format(index, idx), false),
							roll = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCERoll\n %s %s L"):format(index, idx), - 45, 45, 0)
						},

						right = {
							yaw = ui.new_combobox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw\n %s %s R"):format(index, idx), {"Off", "180", "Spin", "Static", "180 Z", "Crosshair", "Random", "Tickcount"}),
							yaw_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Offset R"):format(index, idx), - 180, 180, 0),
							yaw_tickcount_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Jitter Offset R Tick"):format(index, idx), - 180, 180, 15),
							yaw_tickcount = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCETickcount amount\n %s %s R"):format(index, idx), 0, 2, 0, true, "", 1, {[0] = "Low", [1] = "Medium", [2] = "High"}),
							yaw_tickcount_random = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCETickcount amount random\n %s %s R"):format(index, idx), 0, 2, 0, true, "", 1, {[0] = "Fast", [1] = "Medium", [2] = "Slow"}),
							yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw jitter\n %s %s R"):format(index, idx), {"Off", "Offset", "Center", "Random", "Skitter", "Slow 1X", "Slow 2X"}),
							yaw_jitter_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Jitter Offset R"):format(index, idx), - 180, 180, 0),
							enabled_yawjitter_tickcount = ui.new_checkbox("AA", "Anti-aimbot angles", ("\aFFFFFFCEYaw jitter tickcount switch\n %s %s R Jitter"):format(index, idx), false),
							yaw_jitter_tickcount_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Yaw Jitter Offset R Tick Jitter"):format(index, idx), - 180, 180, 90),
							yaw_jitter_tickcount = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCETickcount amount\n %s %s R Jitter"):format(index, idx), 0, 2, 0, true, "", 1, {[0] = "Fast", [1] = "Medium", [2] = "Slow"}),
							body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", ("\aFFFFFFCEBody yaw\n %s %s R"):format(index, idx), {"Off", "Opposite", "Jitter", "Static"}),
							body_yaw_tick = ui.new_slider("AA", "Anti-aimbot angles", ("Rework speed\n %s %s R"):format(index, idx), 2, 64, 8),
							body_yaw_offset = ui.new_slider("AA", "Anti-aimbot angles", ("\n %s %s Body Offset R"):format(index, idx), - 180, 180, 0),
							fake_yaw_offset = ui.new_slider("AA", "Anti-aimbot angles", ("Fake Yaw Limit\n %s %s R"):format(index, idx), 0, 60, 60),
							freestanding_body = ui.new_checkbox("AA", "Anti-aimbot angles", ("\aFFFFFFCEFreestanding body yaw\n %s %s R"):format(index, idx), false),
							roll = ui.new_slider("AA", "Anti-aimbot angles", ("\aFFFFFFCERoll\n %s %s R"):format(index, idx), - 45, 45, 0)
						},

						override_fakelag = ui.new_checkbox("AA", "Fake lag", ("❮%s❯\aFFFFFFCEenable fakelag\n %s"):format(index, idx), index == 1),
						fakelag_amount = ui.new_combobox("AA", "Fake lag", ("Amount\n %s %s"):format(index, idx), {"Dynamic", "Maximum", "Fluctuate"}),
						fakelag_variance = ui.new_slider("AA", "Fake lag", ("Variance\n %s %s"):format(index, idx), 0, 100, 0),
						fakelag_limit = ui.new_slider("AA", "Fake lag", ("Limit\n %s %s"):format(index, idx), 1, 15, 14)
					}
				end
			end

			return elements
		end)()
	},

	Visuals = {
		CrosshairStyle = ui.new_combobox("AA", "Anti-aimbot angles", "\aFF81F0FF\aFFFFFFCEUnder crosshair style", {"Off", "Normal", "Modern"}),
		LineStyle = ui.new_combobox("AA", "Anti-aimbot angles", "Line Style", {"Side", "Angle"}),
		AnimationMode = ui.new_combobox("AA", "Anti-aimbot angles", "Animation mode", {"LERP", "STATIC"}),
		versionText = ui.new_label("AA", "Anti-aimbot angles", "version color"),
		versionColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nscript version color", 255, 255, 255, 255),
		OSText = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFCEhide shot color"),
		OSColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nHide shot color", 255, 255, 255, 255),
		NameText = ui.new_label("AA", "Anti-aimbot angles", "name \aFFFFFFCEcolor"),
		NameColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nName color", 255, 255, 255, 255),
		NameText2 = ui.new_label("AA", "Anti-aimbot angles", "name gradient \aFFFFFFCEcolor"),
		NameColor2 = ui.new_color_picker("AA", "Anti-aimbot angles", "\nName gradient color clr", 255, 255, 255, 255),
		FDText = ui.new_label("AA", "Anti-aimbot angles", "fake duck color"),
		FDColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nFake duck color clr", 255, 255, 255, 255),
		SafeText = ui.new_label("AA", "Anti-aimbot angles", "force safe color"),
		SafeColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nForce safe color clr", 255, 255, 255, 255),
		DTText = ui.new_label("AA", "Anti-aimbot angles", "double tap color"),
		DTColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nDouble tap color clr", 255, 255, 255, 255),
		LegitText = ui.new_label("AA", "Anti-aimbot angles", "legit key color"),
		LegitColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nLegit key color clr", 255, 255, 255, 255),
		EdgeText = ui.new_label("AA", "Anti-aimbot angles", "edge yaw color"),
		EdgeColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nEdge yaw color clr", 255, 255, 255, 255),
		BarText = ui.new_label("AA", "Anti-aimbot angles", "desync bar color"),
		BarColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nDesync bar color clr", 255, 255, 255, 255),
		BaimText = ui.new_label("AA", "Anti-aimbot angles", "force body aim color"),
		BaimColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nForce baim color clr", 255, 255, 255, 255),
		HotkeyAlways = ui.new_checkbox("AA", "Anti-aimbot angles", "force draw hotkeys"),
		ManualIndication = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFCEManual arrows style", {"Off", "❮ ❯", "⮜ ⮞", "⯇ ⯈"}),
		ManualText = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFCEManual color"),
		ManualColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nManual color", 255, 255, 255, 255),
		ManualDistance = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFCEManual indication between", 0, 300, 25),
		ManualScopeLowest = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFCEManual scope lowest"),
		ManualLowestSize = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFCEManual lowest size", 0, 300, 25),
		ManualScopeSmooth = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFCEManual lowest smooth", 1, 100, 45),
		Hitlog = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFCEHitlog notify style", {"Off", "1", "2"}),
		HitlogText = ui.new_label("AA", "Anti-aimbot angles", "Hitlog outline color"),
		HitlogColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\nLog color", 255, 255, 255, 255),
		PoseEditar = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB9B7F1FF⚠ \aFFFFFFCEPOSE EDITAR"),
		PoseEditarState = ui.new_combobox("AA", "Anti-aimbot angles", "State", {"Fakelag", "Always"}),
		PoseIndexs = ui.new_multiselect("AA", "Anti-aimbot angles", "Indexs", {"8", "10", "16", "17"}),
		PoseMagnitude = ui.new_slider("AA", "Anti-aimbot angles", "Magnitude", 0, 100, 10, true, nil, 0.01),
		PoseEditarSpeed = ui.new_slider("AA", "Anti-aimbot angles", "Speed", 1, 5, 3),
		water = ui.new_checkbox("AA", "Anti-aimbot angles", "Watermarker"),
		fade_color_l = ui.new_label("AA", "Anti-aimbot angles", "Fade color"),
		fade_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\n", 255, 255, 255, 255),

	},

	Misc = {
		features = ui.new_multiselect("AA", "Anti-aimbot angles", "\aFF81F0FF\aFFFFFFCEFeatures", {"Avoid backstab", "Fix hideshots", "Force defensive", "0 pitch on land", "Static leg in air", "Static leg in slow", "LC Breaker", "Michael jackson", "Defensive aa"}),
		leg_mode = ui.new_combobox("AA", "Anti-aimbot angles", "\aFF81F0FF\aFFFFFFCEMichael \aB9B7F1FFjackson", {"1.0", "2.0", "3.0"}),
		break_lc_key = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFCEBreak Lc:in-air"),
		force_defensive_key = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFCEForce-defensive"),
		defensive_conditions = ui.new_multiselect("AA", "Anti-aimbot angles", "Defensive Conditions", Meta.data.PlayerState),
		defensive_preset = ui.new_combobox("AA", "Anti-aimbot angles", "Defensive Preset", {"Pitch", "Random"}),
		copy_antiaim_states = ui.new_combobox("AA", "Anti-aimbot angles", "Copy AntiAim Vars State", Meta.data.PlayerState),
		copy_source_team = ui.new_combobox("AA", "Anti-aimbot angles", "Copy Source Team", {"T", "CT"}),
		copy_target_team = ui.new_combobox("AA", "Anti-aimbot angles", "Copy Target Team", {"T", "CT"})
	},

	Configs = {
		configs_list = ui.new_listbox("AA", "Anti-aimbot angles", "Configs", Meta.data.Configs),
		join_discord = ui.new_button("AA", "Other", Meta.gradienttext("Join discord", 255, 255, 255, 220, 185, 183, 241, 255), function()
			Meta.data.Panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/KRkYBxxhGh")
		end)
	}
}

Meta.fakelag_reference = {
	fakelag_limit = ui.reference("AA", "Fake lag", "Limit"),
	fakelag_amount = ui.reference("AA", "Fake lag", "Amount"),
	fakelag_enabled = ui.reference("AA", "Fake lag", "Enabled"),
	fakelag_variance = ui.reference("AA", "Fake lag", "Variance")
}

Meta.reference = {
	fakelag_limit = ui.reference("AA", "Fake lag", "Limit"),
	roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
	enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
	slow_walk = {ui.reference("AA", "Other", "Slow motion")},
	pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")},
	onshot = {ui.reference("AA", "Other", "On shot anti-aim")},
	fakelag_amount = ui.reference("AA", "Fake lag", "Amount"),
	doubletap = {ui.reference("RAGE", "Aimbot", "Double tap")},
	fakelag_variance = ui.reference("AA", "Fake lag", "Variance"),
	ping_spike = {ui.reference("Misc", "Miscellaneous", "Ping spike")},
	fakelag_reference = ui.reference("AA", "Fake lag", "Enabled"),
	fake_duck = ui.reference("RAGE", "Other", "Duck peek assist"),
	force_body = ui.reference("Rage", "Aimbot", "Force body aim"),
	min_damage = ui.reference("Rage", "Aimbot", "Minimum damage"),
	min_damage_override = {ui.reference("Rage", "Aimbot", "Minimum damage override")},
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
		elseif type(data) == "number" and tostring(key):find("copy") == nil then
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

Meta.copyantiaimvars = function()
	local next_copy = {}
	local copy_state = ui.get(Meta.elements.Misc.copy_antiaim_states)
	local copy_target_team = ui.get(Meta.elements.Misc.copy_target_team)
	local copy_source_team = ui.get(Meta.elements.Misc.copy_source_team)
	local custom_target_list = Meta.elements.AntiAim.Custom[copy_target_team == "T" and 1 or 2]
	local custom_source_list = Meta.elements.AntiAim.Custom[copy_source_team == "T" and 1 or 2]
	for index, data in pairs(custom_target_list) do
		if data.pointer == copy_state then
			next_copy.target = data
			break
		end
	end

	for index, data in pairs(custom_source_list) do
		if data.pointer == copy_state then
			next_copy.source = data
			break
		end
	end

	if next_copy.source and next_copy.target then
		local copy_source = {
			left = next_copy.source.left,
			right = next_copy.source.right
		}

		local copy_target = {
			left = next_copy.target.left,
			right = next_copy.target.right
		}
	
		for side, elements in pairs(copy_source) do
			local copy_list = copy_target[side]
			for key, arg in pairs(elements) do
				local copy_ui = copy_list[key]
				if copy_ui then
					pcall(ui.set, copy_ui, ui.get(arg))
				end
			end
		end
	end
end

Meta.elements.Misc.antiaim_copy = ui.new_button("AA", "Anti-aimbot angles", "Copy AntiAim", Meta.copyantiaimvars)
Meta.handlefakelagreference = function(state)
	for key, data in pairs(Meta.fakelag_reference) do
		ui.set_visible(data, not state)
	end
end

Meta.handlereference = function(state)
	for key, data in pairs(Meta.reference) do
		if not Meta.contains({"min_damage_override", "min_damage", "fakelag_limit", "slow_walk", "onshot", "doubletap", "fakelag_amount", "fakelag_variance", "fakelag_reference", "fake_duck", "leg_movement", "force_body", "force_safe", "ping_spike"}, key) then
			if type(data) == "table" then
				ui.set_visible(data[1], state)
				ui.set_visible(data[2], state)
				if data[3] then
					ui.set_visible(data[3], state)
				end
			else
				ui.set_visible(data, state)
			end
		end
	end
end

Meta.handlemain = function()
	ui.set_visible(Meta.elements.Group, ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Misc.features, ui.get(Meta.elements.Group) == "misc" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Misc.leg_mode, ui.get(Meta.elements.Group) == "misc" and Meta.contains(ui.get(Meta.elements.Misc.features), "Michael jackson") and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.Hitlog, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.AntiAim.Enabled, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Configs.configs_list, ui.get(Meta.elements.Group) == "configs" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Configs.config_save, ui.get(Meta.elements.Group) == "configs" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Configs.config_load, ui.get(Meta.elements.Group) == "configs" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.CrosshairStyle, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.PoseEditar, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.water, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Configs.config_name, ui.get(Meta.elements.Group) == "configs" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Configs.config_create, ui.get(Meta.elements.Group) == "configs" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Configs.config_delete, ui.get(Meta.elements.Group) == "configs" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Configs.config_export, ui.get(Meta.elements.Group) == "configs" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Configs.config_import, ui.get(Meta.elements.Group) == "configs" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.ManualIndication, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.AntiAim.AAMode, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.AntiAim.EdgeYaw, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.AntiAim.ManualLeft, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.AntiAim.LegitOnKey, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.AntiAim.ManualRight, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.HitlogText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.Hitlog) ~= "Off" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.AntiAim.FreestandYaw, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.HitlogColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.Hitlog) ~= "Off" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.AntiAim.ManualForward, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.PoseEditarState, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.PoseEditar) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.PoseIndexs, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.PoseEditar) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.PoseMagnitude, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.PoseEditar) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.PoseEditarSpeed, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.PoseEditar) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.BarText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "CrosshairStyle" or ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.SafeText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "CrosshairStyle" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.DTText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.FDText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.LineStyle, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "Normal" or ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.BarColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "Normal" or ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.OSText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.BaimText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "modern" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.SafeColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "modern" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.FDColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.DTColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.OSColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.BaimColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "modern" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.LegitText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.EdgeText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.NameText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.LegitColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.EdgeColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.NameColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.NameText2, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.versionColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.versionText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.HotkeyAlways, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) == "modern" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.NameColor2, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.AntiAim.DisabledFreestandingInAir, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.ManualText, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.ManualIndication) ~= "Off" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.ManualColor, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.ManualIndication) ~= "Off" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.AnimationMode, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Off" and ui.get(Meta.elements.Visuals.CrosshairStyle) ~= "Normal" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.ManualDistance, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.ManualIndication) ~= "Off" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.ManualScopeLowest, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.ManualIndication) ~= "Off" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.ManualLowestSize, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.ManualIndication) ~= "Off" and ui.get(Meta.elements.Visuals.ManualScopeLowest) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.ManualScopeSmooth, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.ManualIndication) ~= "Off" and ui.get(Meta.elements.Visuals.ManualScopeLowest) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.fade_color_l, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.water) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Visuals.fade_color, ui.get(Meta.elements.Group) == "visuals" and ui.get(Meta.elements.Visuals.water) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Misc.break_lc_key, ui.get(Meta.elements.Group) == "misc" and Meta.contains(ui.get(Meta.elements.Misc.features), "LC Breaker") and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Misc.defensive_conditions, ui.get(Meta.elements.Group) == "misc" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.MasterSwitch) and Meta.contains(ui.get(Meta.elements.Misc.features), "Defensive aa"))
	ui.set_visible(Meta.elements.Misc.defensive_preset, ui.get(Meta.elements.Group) == "misc" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.MasterSwitch) and Meta.contains(ui.get(Meta.elements.Misc.features), "Defensive aa"))
	ui.set_visible(Meta.elements.Misc.force_defensive_key, ui.get(Meta.elements.Group) == "misc" and Meta.contains(ui.get(Meta.elements.Misc.features), "Force defensive") and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.AntiAim.OverrideAntiAimBase, false) --ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.AntiAim.Team, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.AntiAim.PlayerState, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Misc.copy_antiaim_states, ui.get(Meta.elements.Group) == "misc" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Misc.copy_source_team, ui.get(Meta.elements.Group) == "misc" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Misc.copy_target_team, ui.get(Meta.elements.Group) == "misc" and ui.get(Meta.elements.MasterSwitch))
	ui.set_visible(Meta.elements.Misc.antiaim_copy, ui.get(Meta.elements.Group) == "misc" and ui.get(Meta.elements.MasterSwitch))
	for team, data in pairs(Meta.elements.AntiAim.Custom) do
		for index, data in pairs(data) do
			if index == 1 then
				ui.set(data.enabled, true)
				ui.set(data.override_fakelag, true)
			end

			local is_left = (ui.get(data.side) == "Left" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH")
			local undraw_bodyyaw_override_left = ui.get(Meta.elements.AntiAim.OverrideAntiAimBase) and ui.get(data.left.body_yaw) == "Jitter"
			local undraw_bodyyaw_override_right = ui.get(Meta.elements.AntiAim.OverrideAntiAimBase) and ui.get(data.right.body_yaw) == "Jitter"
			local draw_left = (ui.get(data.side) == "Left" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH") or ui.get(data.index) == "Single"
			if ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer then
				Meta.handlefakelagreference((ui.get(Meta.elements.MasterSwitch) and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(data.override_fakelag)) or index == 1)
			end

			ui.set_visible(data.enabled, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and index ~= 1 and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.index, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.override_fakelag, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and index ~= 1 and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.fakelag_limit, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.override_fakelag) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.roll, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.yaw, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.fakelag_amount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.override_fakelag) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.fakelag_variance, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.override_fakelag) and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.body_yaw, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.side, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.enabled_hotkey, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and data.pointer == "Body lean" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.yaw_jitter, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(data.left.yaw) ~= "Off" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.yaw_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(data.left.yaw) ~= "Off" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.freestanding_body, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(data.left.body_yaw) ~= "Off" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.roll, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.yaw, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.body_yaw, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.yaw_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and is_left and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw) == "Tickcount" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.yaw_jitter_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw_jitter) ~= "Off" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.yaw_tickcount_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and is_left and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw) == "Tickcount" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.yaw_tickcount_random, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and is_left and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw) == "Tickcount" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.enabled_yawjitter_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and is_left and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw_jitter) ~= "Off" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.yaw_jitter, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.yaw_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.body_yaw_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(data.left.body_yaw) ~= "Off" and ui.get(data.left.body_yaw) ~= "Opposite" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and not undraw_bodyyaw_override_left and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.body_yaw_tick, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(data.left.body_yaw) ~= "Off" and ui.get(data.left.body_yaw) ~= "Opposite" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and undraw_bodyyaw_override_left and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.fake_yaw_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and draw_left and ui.get(data.left.body_yaw) ~= "Off" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.AntiAim.OverrideAntiAimBase) and not undraw_bodyyaw_override_left and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.fake_yaw_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.body_yaw) ~= "Off" and ui.get(data.right.body_yaw) ~= "Opposite" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.AntiAim.OverrideAntiAimBase) and not undraw_bodyyaw_override_right and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.freestanding_body, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.body_yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.yaw_jitter_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw_jitter) ~= "Off" and ui.get(data.left.enabled_yawjitter_tickcount) and is_left and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.left.yaw_jitter_tickcount_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.left.yaw) ~= "Off" and ui.get(data.left.yaw_jitter) ~= "Off" and ui.get(data.left.enabled_yawjitter_tickcount) and is_left and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.yaw_jitter_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.right.yaw_jitter) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.yaw_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(data.right.yaw) == "Tickcount" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.yaw_tickcount_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(data.right.yaw) == "Tickcount" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.yaw_tickcount_random, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(data.right.yaw) == "Tickcount" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.enabled_yawjitter_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.right.yaw_jitter) ~= "Off" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.body_yaw_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.body_yaw) ~= "Off" and ui.get(data.right.body_yaw) ~= "Opposite" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and not undraw_bodyyaw_override_right and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.body_yaw_tick, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.body_yaw) ~= "Off" and ui.get(data.right.body_yaw) ~= "Opposite" and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and undraw_bodyyaw_override_right and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.yaw_jitter_tickcount, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.right.yaw_jitter) ~= "Off" and ui.get(data.right.enabled_yawjitter_tickcount) and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
			ui.set_visible(data.right.yaw_jitter_tickcount_offset, ui.get(Meta.elements.Group) == "anti-aim" and ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.Team) == data.team and ui.get(Meta.elements.AntiAim.PlayerState) == data.pointer and ui.get(data.enabled) and ui.get(data.side) == "Right" and ui.get(data.right.yaw) ~= "Off" and ui.get(data.right.yaw_jitter) ~= "Off" and ui.get(data.right.enabled_yawjitter_tickcount) and ui.get(data.index) == "L&R TICK \aB9B7F1FFSWITCH" and ui.get(Meta.elements.AntiAim.AAMode) == "Conditions" and ui.get(Meta.elements.MasterSwitch))
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
	if math.abs(a - b) < c then
		return b
	end

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

Meta.CalculateYaw = function(local_angle, enemy_angle)
	if not local_angle or not enemy_angle then
		return 0
	end

	local xdelta = local_angle.x - enemy_angle.x
	local ydelta = local_angle.y - enemy_angle.y
	local relativeyaw = Meta.normalizedyaw(math.atan(ydelta / xdelta) * 180 / math.pi)
	if xdelta >= 0 then
		relativeyaw = Meta.normalizedyaw(relativeyaw + 180)
	end

	return relativeyaw
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

Meta.createways = function(angles, ways, key)
	if not Meta.data.CachedWays[key] then
		Meta.data.CachedWays[key] = {
			angles = {},
			choked = 1
		}
	end

	local angles_between = math.abs(angles) / ways
	if ways % 2 == 0 then
		for index = - (ways / 2), (ways / 2) do
			Meta.data.CachedWays[key].angles[index] = angles_between * index
		end
	else
		for index = 1, ways do
			if index > (ways / 2) and index < math.floor((ways / 2) + 0.5) then
				Meta.data.CachedWays[key].angles[index] = angles / 2
			else
				local different = (index < (ways / 2) and (((ways / 2) + 1) - index) or index) * angles_between
				Meta.data.CachedWays[key].angles[index] = (index < ways / 2) and - different or different
			end
		end
	end

	if Meta.data.CurrentChoked == 0 then
		Meta.data.CachedWays[key].choked = Meta.data.CachedWays[key].choked + 1
		if Meta.data.CachedWays[key].choked > ways then
			Meta.data.CachedWays[key].choked = 1
		end
	end

	return Meta.data.CachedWays[key].angles[Meta.data.CachedWays[key].choked]
end

Meta.oncustompose = function()
	local local_player = entity.get_local_player()
	if not ui.get(Meta.elements.Visuals.PoseEditar) or not local_player or not entity.is_alive(local_player) then
		return
	end

 	local velocity = Meta.velocity(local_player)
                local fake_duck = ui.get(Meta.reference.fake_duck)
                local onshot_aa = ui.get(Meta.reference.onshot[1]) and ui.get(Meta.reference.onshot[2])
                local switch_timer = math.floor(globals.curtime() * ui.get(Meta.elements.Visuals.PoseEditarSpeed) * 8) % 2 == 0
                if (not antiaim_funcs.get_double_tap() and not onshot_aa and not fake_duck and velocity > 3 or ui.get(Meta.elements.Visuals.PoseEditarState) == "Always") and entity.get_prop(m, "m_flDuckAmount") < 0.5 then
		local custom_list = ui.get(Meta.elements.Visuals.PoseIndexs)
		local custom_value = ui.get(Meta.elements.Visuals.PoseMagnitude)
		for _, index in ipairs(custom_list) do
			entity.set_prop(m, "m_flPoseParameter", switch_timer and custom_value * 0.01 or 0, tonumber(index))
		end
	end
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
		text = ("%s  \a9FC377FFregistered  \aB8C0FBFFshot  \aFFFFFFFF%s  's  \aB8C0FBFF%s  \aFFFFFFFFfor  \aB8C0FBFF%i \aFFFFFFFFdamage,  hitchance:  \aB8C0FBFF%i\aFFFFFFFF,  bt:  \aB8C0FBFF%iticks"):format(Meta.data.ScriptName, target_name, hitboxes, e.damage, e.hit_chance, Meta.data.Simulation[e.target].tick)
	elseif hitlog_style == "2" then
		text = ("❮%s❯registered \aB8C0FBFFshot \aFFFFFFFF%s 's \aB8C0FBFF%s \aFFFFFFFFfor \aB8C0FBFF%i \aFFFFFFFFdamage, hitchance: \aB8C0FBFF%i\aFFFFFFFF, bt: \aB8C0FBFF%iticks"):format(Meta.data.ScriptName, target_name, hitboxes, e.damage, e.hit_chance, Meta.data.Simulation[e.target].tick)
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
		text = ("%s  \aF65858FFmissed  \aB8C0FBFFshot \aFFFFFFFF%s  's  for  \aB8C0FBFF%s  \aFFFFFFFFdue  to  \aF65858FF%s\aFFFFFFFF,  hitchance:  \aB8C0FBFF%i\aFFFFFFFF,  bt:  \aB8C0FBFF%iticks"):format(Meta.data.ScriptName, target_name, hitboxes, e.reason == "?" and "resolver" or e.reason, e.hit_chance, Meta.data.Simulation[e.target].tick)
	elseif hitlog_style == "2" then
		text = ("❮%s❯\aF65858FFmissed \aB8C0FBFFshot \aFFFFFFFF%s 's for \aB8C0FBFF%s \aFFFFFFFFdue to \aF65858FF%s\aFFFFFFFF, hitchance: \aB8C0FBFF%i\aFFFFFFFF, bt: \aB8C0FBFF%iticks"):format(Meta.data.ScriptName, target_name, hitboxes, e.reason == "?" and "resolver" or e.reason, e.hit_chance, Meta.data.Simulation[e.target].tick)
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

Meta.GetBombTimer = function(ent)
	local c4_time = entity.get_prop(ent, "m_flC4Blow") - globals.curtime()
	return c4_time ~= nil and c4_time > 0 and c4_time or 0
end

Meta.GetEyePosition = function(player)
	if not player then
		return false
	end

	local origin = vector(entity.get_origin(player))
	return vector(origin.x, origin.y, origin.z + 64)
end

Meta.Extrapolate = function(position, ticks, player)
	local x, y, z = entity.get_prop(player, "m_vecVelocity")
	for i = 0, ticks do
		position.x = position.x + (x * globals.tickinterval())
		position.y = position.y + (y * globals.tickinterval())
		position.z = position.z + (z * globals.tickinterval())
	end

	return position
end

Meta.SharedSeed = function(randomseed, maximum, bodyyaw)
	local cached_bodyyaw = {}
	if bodyyaw == - 180 then
		cached_bodyyaw[1] = 0.0
	else
		if bodyyaw ~= 0 then
			if bodyyaw == 180 then
				cached_bodyyaw[0] = 0.0
				cached_bodyyaw[1] = maximum
			else
				math.randomseed(bodyyaw)
				cached_bodyyaw[0] = math.random(- maximum, maximum)
				cached_bodyyaw[1] = math.random(- maximum, maximum)
			end

			return cached_bodyyaw[randomseed % 2]
		end

		cached_bodyyaw[1] = maximum
	end

	cached_bodyyaw[0] = - maximum
	return cached_bodyyaw[randomseed % 2]
end

Meta.JitterBodyYaw = function(bodyyaw, fakeyaw)
	if Meta.data.CurrentChoked == 1 then
		Meta.data.BodyYawSeed = Meta.data.BodyYawSeed + 1
	end

	local make_bodyyaw = Meta.SharedSeed(Meta.data.BodyYawSeed, 60, bodyyaw)
	return {make_bodyyaw, math.min(math.abs(make_bodyyaw), fakeyaw)}
end

Meta.ShouldAntiAim = function(cmd)
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return false
	end

	local weapon = entity.get_player_weapon(local_player)
	if not weapon or entity.get_prop(local_player, "m_MoveType") == 9 then
		return false
	end

	local curtime = globals.curtime()
	local game_rules = entity.get_game_rules()
	local m_nTickBase = entity.get_prop(local_player, "m_nTickBase")
	local m_MoveType = entity.get_prop(local_player, "m_MoveType")
	local m_bIsDefuse = entity.get_prop(local_player, "m_bIsDefusing")
	local m_iTeamNum = entity.get_prop(local_player, "m_iTeamNum")
	local m_flNextAttack = entity.get_prop(local_player, "m_flNextAttack")
	local weapon_index = entity.get_prop(weapon, "m_iItemDefinitionIndex")
	local m_flNextPrimaryAttack = entity.get_prop(weapon, "m_flNextPrimaryAttack")
	local m_bIsGrabbingHostage = entity.get_prop(local_player, "m_bIsGrabbingHostage")
	if m_bIsDefuse and m_bIsDefuse == 1 then
		return false
	end

	if m_MoveType == 9 or m_MoveType == 8 then
		return false
	end

	if m_bIsGrabbingHostage and m_bIsGrabbingHostage == 1 then
		return false
	end

	if game_rules ~= nil then
		local m_bFreezePeriod = entity.get_prop(game_rules, "m_bFreezePeriod")
		if m_bFreezePeriod ~= nil and m_bFreezePeriod == 1 then
			return false
		end
	end

	if m_iTeamNum and m_iTeamNum == 3 then
		local bombs = entity.get_all("CPlantedC4")
		local origin = vector(entity.get_origin(local_player))
		for _, bomb in pairs(bombs) do
			if bomb ~= nil and entity.get_prop(bomb, "m_bBombDefused") == 0 and Meta.GetBombTimer(bomb) > 0 then
				local bomb_origin = vector(entity.get_origin(bomb))
				if bomb_origin ~= nil and bomb_origin.x ~= nil then
					local dist = origin:dist(bomb_origin)
					if dist <= 75 then
						return false
					end
				end
			end
		end
	end

	local current_grenade = Meta.contains({
		"CSnowball",
		"CFlashbang",
		"CHEGrenade",
		"CDecoyGrenade",
		"CSensorGrenade",
		"CSmokeGrenade",
		"CMolotovGrenade",
		"CIncendiaryGrenade"
	}, entity.get_classname(weapon))
	if Meta.data.GrenadeReleaseTimer > curtime then
		return false
	else
		Meta.data.GrenadeRelease = false
	end

	if Meta.data.GrenadeReleaseReset then
		if Meta.data.CurrentChoked == 0 then
			Meta.data.GrenadeReleaseReset = false
		end

		return false
	end

	if Meta.data.LastPinPulledTicks > globals.tickcount() then
		return false
	end

	if current_grenade then
		local m_bPinPulled = entity.get_prop(weapon, "m_bPinPulled")
		local m_fThrowTime = entity.get_prop(weapon, "m_fThrowTime")
		if m_bPinPulled == 1 then
			Meta.data.GrenadeReleaseReset = true
			Meta.data.LastPinPulledTicks = globals.tickcount() + 24
			if m_bPinPulled == 1 or cmd.in_attack == 1 or cmd.in_attack2 == 1 then
				return false
			end

			if m_fThrowTime and m_fThrowTime > 0 and not Meta.data.GrenadeRelease then
				Meta.data.GrenadeRelease = true
				Meta.data.GrenadeReleaseTimer = curtime + Meta.time2ticks(2)
				return false
			end
		end
	else
		if m_flNextAttack > curtime then
			return true
		else
			local m_iClip1 = entity.get_prop(weapon, "m_iClip1")
			if m_iClip1 == 0 then
				return true
			end

			if m_flNextPrimaryAttack <= curtime and (weapon_index== 64 and (cmd.in_attack == 1 or cmd.in_attack2 == 1) or cmd.in_attack == 1) then
				if weapon_index == 64 then
					local m_flPostponeFireReadyTime = entity.get_prop(weapon, "m_flPostponeFireReadyTime")
					if m_flPostponeFireReadyTime then
						local delta = m_flPostponeFireReadyTime - curtime
						if cmd.in_attack == 1 and delta < 0.01 then
							return false
						elseif cmd.in_attack == 0 and cmd.in_attack2 == 1 and delta >= 3.4028234663853 then
							return false
						end
					else
						return false
					end
				else
					return false 
				end
			else
				local m_iBurstShotsRemaining = entity.get_prop(weapon, "m_iBurstShotsRemaining")
				if m_iBurstShotsRemaining ~= nil and m_iBurstShotsRemaining > 0 then
					return false
				end
			end 
		end
	end

	return true
end

Meta.CHelpers = {
	GetClientLanguege = vtable_bind("vgui2.dll", "VGUI_Scheme010", 18, "const char *(__thiscall*)(void*)"),
	SetClientLanguege = vtable_bind("vgui2.dll", "VGUI_Scheme010", 17, "void(__thiscall*)(void*, const char*)"),
	GetClientEntity = (function()
		local GetClientEntityPointer = vtable_bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
		return function(entindex, typedef)
			if not entindex then
				return false
			end

			local m_Type = typedef or "void*"
			return ffi.cast(m_Type, GetClientEntityPointer(
				entindex or entity.get_local_player()
			))
		end
	end)()
}

Meta.GetAnimState = function(player)
	if not player or not entity.is_alive(player) then
		return false
	end

	local address = Meta.CHelpers.GetClientEntity(player)
	if not address then
		return false
	end

	return ffi.cast("AnimationState**", 
		ffi.cast("char*" , address) + 0x9960
	)[0]
end

Meta.GetMaxDesync = function(player)
	if not player or not entity.is_alive(player) then
		return 0
	end

	local anim_state = Meta.GetAnimState(player)
	if not anim_state then
		return 58
	end

	local duck_amount = anim_state.duck_amount
	local speed_fraction = math.max(0, math.min(anim_state.feet_speed_forwards_or_sideways, 1))
	local speed_factor = math.max(0, math.min(1, anim_state.feet_speed_unknown_forwards_or_sideways))
	local unknown_factor = ((anim_state.stop_to_full_running_fraction * - 0.30000001) - 0.19999999) * speed_fraction
	local unkown_factor_secondary = unknown_factor + 1
	if (duck_amount > 0) then
		unkown_factor_secondary = unkown_factor_secondary + ((duck_amount * speed_factor) * (0.5 - unkown_factor_secondary))
	end

	return anim_state.max_yaw * unkown_factor_secondary
end

Meta.RunDesync = function(e, start, bodyyaw)
	e.pitch = 89
	e.yaw = start or (e.yaw - 180)
	if e.chokedcommands == 0 then
		e.yaw = e.yaw - (Meta.clamp(bodyyaw, - 60, 60) * 2)
		e.allow_send_packet = false
	end
end

Meta.RunAntiAim = function(cmd_context, override_antiaim_vars)
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) or not Meta.ShouldAntiAim(cmd_context) then
		return
	end

	local threat_target = client.current_threat()
	local self_entity = c_entity.new(local_player)
	local self_anim_state = self_entity:get_anim_state()
	local m_eye_position = vector(client.eye_position())
	local camera_angles = vector(client.camera_angles())
	local yaw_offset = Meta.normalizedyaw(camera_angles.y + 180)
	local antiaim_cached = {
		pitch = 0,
		desync_limit = 0,
		yaw = yaw_offset
	}

	override_antiaim_vars.fake_yaw_limit = Meta.clamp(override_antiaim_vars.fake_yaw_limit, 0, 60)
	if override_antiaim_vars.pitch == "Down" then
		antiaim_cached.pitch =  89.9
	elseif override_antiaim_vars.pitch == "Minimal" then
		antiaim_cached.pitch =  89
	elseif override_antiaim_vars.pitch == "Up" then
		antiaim_cached.pitch = - 89
	elseif override_antiaim_vars.pitch == "Custom" then
		antiaim_cached.pitch = override_antiaim_vars.pitch_angles
	elseif override_antiaim_vars.pitch == "Off" then
		antiaim_cached.pitch = camera_angles.x - 0.00001
	end

	if override_antiaim_vars.yaw_base == "At targets" and threat_target then
		local target_eye_position = Meta.GetEyePosition(threat_target)
		if m_eye_position and target_eye_position then
			local angle = Meta.CalculateYaw(m_eye_position, target_eye_position)
			antiaim_cached.yaw = Meta.normalizedyaw(angle + 180)
		end
	end

	antiaim_cached.yaw = Meta.normalizedyaw(antiaim_cached.yaw + override_antiaim_vars.yaw_offset)
	if override_antiaim_vars.yaw_jitter == "Offset" then
		if Meta.data.Flip then
			antiaim_cached.yaw = Meta.normalizedyaw(antiaim_cached.yaw + override_antiaim_vars.yaw_jitter_offset)
		end

	elseif override_antiaim_vars.yaw_jitter == "Center" then
		local jitter_offset = override_antiaim_vars.yaw_jitter_offset / 2
		antiaim_cached.yaw = Meta.normalizedyaw(antiaim_cached.yaw + (Meta.data.Flip and jitter_offset or - jitter_offset))
	elseif override_antiaim_vars.yaw_jitter == "Random" then
		local jitter_offset = override_antiaim_vars.yaw_jitter_offset / 2
		antiaim_cached.yaw = Meta.normalizedyaw(antiaim_cached.yaw + math.random(- jitter_offset, jitter_offset))
	end

	if override_antiaim_vars.body_yaw == "Opposite" then
		local fake_real_delta = 60
		antiaim_cached.desync_limit = fake_real_delta > 0 and override_antiaim_vars.fake_yaw_limit or - override_antiaim_vars.fake_yaw_limit
		override_antiaim_vars.body_yaw_offset = Meta.clamp(override_antiaim_vars.body_yaw_offset, - 60, 60)
	elseif override_antiaim_vars.body_yaw == "Static" then
		antiaim_cached.desync_limit = override_antiaim_vars.fake_yaw_limit
		override_antiaim_vars.body_yaw_offset = Meta.clamp(override_antiaim_vars.body_yaw_offset, - 60, 60)
	elseif override_antiaim_vars.body_yaw == "Jitter" then
		local jitter_data = Meta.JitterBodyYaw(override_antiaim_vars.body_yaw_offset, override_antiaim_vars.fake_yaw_limit)
		antiaim_cached.desync_limit = jitter_data[2]
		override_antiaim_vars.body_yaw_offset = jitter_data[1]
	end

	if override_antiaim_vars.body_yaw ~= "Off" then
		local abs_limitation = override_antiaim_vars.body_yaw_offset > 0 and math.abs(antiaim_cached.desync_limit) or - math.abs(antiaim_cached.desync_limit)
		local abs_desync = (override_antiaim_vars.body_yaw_offset + abs_limitation) / 2
		Meta.RunDesync(cmd_context, antiaim_cached.yaw, abs_desync)
	else
		cmd_context.yaw = antiaim_cached.yaw
	end

	cmd_context.pitch = antiaim_cached.pitch
	cmd_context.roll = override_antiaim_vars.extended_roll
end

Meta.command = function(e)
	local me = c_entity.get_local_player()
	local m_fFlags = me:get_prop("m_fFlags")
	local local_player = entity.get_local_player()
	Meta.data.KeyDownGround = bit.band(m_fFlags, 1) ~= 0
	if not ui.get(Meta.elements.AntiAim.Enabled) or not local_player or not entity.is_alive(local_player) then
		Meta.data.IsLeanAntiAim = false
		return
	end

	Meta.legitonkey(e)
	Meta.updatemanual(e)
	Meta.data.CurrentChoked = e.chokedcommands
	if e.chokedcommands == 0 then
		Meta.data.Flip = not Meta.data.Flip
	end

	local slow_1x_speed = 5
	local slow_2x_speed = 7	
	local playerstate = Meta.playerstate()
	local self_index = c_entity.new(local_player)
	local lag_playerstate = Meta.lagplayerstate()
	Meta.data.IsLeanAntiAim = playerstate == 10
	local self_anim_state = self_index:get_anim_state()
	local legit_on_key = ui.get(Meta.elements.AntiAim.LegitOnKey)
	local bodyyaw = Meta.normalizedyaw(self_anim_state.goal_feet_yaw - self_anim_state.eye_angles_y)
	local custom = Meta.elements.AntiAim.Custom[entity.get_prop(local_player, "m_iTeamNum") == 2 and 1 or 2]
	local bindarg = custom[playerstate]
	local lag_bindarg = custom[lag_playerstate]
	local override_base_antiaim = ui.get(Meta.elements.AntiAim.OverrideAntiAimBase) and not legit_on_key and not ui.get(Meta.reference.freestanding[1]) and not ui.get(Meta.reference.edge_yaw)
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
				pitch_angles = 0,
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
				pitch_angles = 0,
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
				pitch_angles = 0,
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
				pitch_angles = 0,
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
				pitch_angles = 0,
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
		ui.set(Meta.reference.freestanding_body_yaw, data.freestanding_body)
		if data.yaw_jitter == "Slow 1X" then
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.elements.AntiAim.OverrideAntiAimBase, true)
			local current_offset = (math.abs(data.yaw_jitter_offset) / 2)
			ui.set(Meta.reference.yaw[2], data.yaw_offset + (Meta.data.UpdateTickcount[slow_1x_speed] and current_offset or - current_offset))
		elseif data.yaw_jitter == "Slow 2X" then
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.elements.AntiAim.OverrideAntiAimBase, true)
			local current_offset = (math.abs(data.yaw_jitter_offset) / 2)
			ui.set(Meta.reference.yaw[2], data.yaw_offset + (Meta.data.UpdateTickcount[slow_2x_speed] and current_offset or - current_offset))
		else
			ui.set(Meta.reference.yaw[2], data.yaw_offset)
			ui.set(Meta.reference.yaw_jitter[1], yaw_jitter)
			ui.set(Meta.elements.AntiAim.OverrideAntiAimBase, false)
			ui.set(Meta.reference.yaw_jitter[2], data.yaw_jitter_offset)
		end

		ui.set(Meta.reference.body_yaw[1], data.body_yaw)
		ui.set(Meta.reference.body_yaw[2], data.body_yaw_offset)
		if Meta.data.ManualSide ~= 0 then
			ui.set(Meta.reference.yaw_jitter[2], 0)
			ui.set(Meta.reference.edge_yaw, false)
			ui.set(Meta.reference.body_yaw[2], 90)
			ui.set(Meta.reference.freestanding[1], false)
			ui.set(Meta.reference.body_yaw[1], "Static")
			ui.set(Meta.reference.yaw_base, "Local view")
			ui.set(Meta.reference.yaw[2], ({- 90, 90, 180})[Meta.data.ManualSide])
		else
			ui.set(Meta.reference.freestanding[2], "Always on")
			ui.set(Meta.reference.edge_yaw, ui.get(Meta.elements.AntiAim.EdgeYaw))
			ui.set(Meta.reference.freestanding[1], ui.get(Meta.elements.AntiAim.FreestandYaw))
			if ui.get(Meta.elements.AntiAim.DisabledFreestandingInAir) then
				if Meta.jumping(local_player) then
					ui.set(Meta.reference.freestanding[1], false)
				end
			end
		end

	elseif ui.get(bindarg.index) == "Single" then
		local data = bindarg["left"]
		local yaw_jitter = ui.get(data.yaw_jitter)
		ui.set(Meta.reference.pitch[1], "Down")
		local yaw_offset = ui.get(data.yaw_offset)
		ui.set(Meta.reference.yaw_base, "At targets")
		ui.set(Meta.reference.body_yaw[1], ui.get(data.body_yaw))
		ui.set(Meta.reference.body_yaw[2], ui.get(data.body_yaw_offset))
		ui.set(Meta.reference.yaw[1], ui.get(data.yaw) == "Tickcount" and "180" or ui.get(data.yaw))
		if yaw_jitter == "Slow 1X" then
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.elements.AntiAim.OverrideAntiAimBase, true)
			local current_offset = (math.abs(ui.get(data.yaw_jitter_offset)) / 2)
			ui.set(Meta.reference.yaw[2], yaw_offset + (Meta.data.UpdateTickcount[slow_1x_speed] and current_offset or - current_offset))
		elseif yaw_jitter == "Slow 2X" then
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.elements.AntiAim.OverrideAntiAimBase, true)
			local current_offset = (math.abs(ui.get(data.yaw_jitter_offset)) / 2)
			ui.set(Meta.reference.yaw[2], yaw_offset + (Meta.data.UpdateTickcount[slow_2x_speed] and current_offset or - current_offset))
		else
			ui.set(Meta.reference.yaw[2], yaw_offset)
			ui.set(Meta.reference.yaw_jitter[1], yaw_jitter)
			ui.set(Meta.elements.AntiAim.OverrideAntiAimBase, false)
			ui.set(Meta.reference.yaw_jitter[2], ui.get(data.yaw_jitter_offset))
		end

		ui.set(Meta.reference.roll, ui.get(data.roll))
		local bodyyaw_mode = ui.get(data.body_yaw)
		local fakeyawlimit = ui.get(data.fake_yaw_offset)
		local bodyyaw_angles = ui.get(data.body_yaw_offset)
		ui.set(Meta.reference.freestanding_body_yaw, ui.get(data.freestanding_body))
		if not override_base_antiaim then
			ui.set(Meta.reference.body_yaw[1], bodyyaw_mode)
			ui.set(Meta.reference.body_yaw[2], bodyyaw_angles)
		else
			ui.set(Meta.reference.body_yaw[1], "Static")
			ui.set(Meta.reference.body_yaw[2], 0)
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
			ui.set(Meta.reference.freestanding[2], "Always on")
			ui.set(Meta.reference.freestanding[1], ui.get(Meta.elements.AntiAim.FreestandYaw))
			ui.set(Meta.reference.edge_yaw, ui.get(Meta.elements.AntiAim.EdgeYaw))
			if ui.get(Meta.elements.AntiAim.DisabledFreestandingInAir) then
				if Meta.jumping(local_player) then
					ui.set(Meta.reference.freestanding[1], false)
				end
			end
		end

		if ui.get(Meta.elements.AntiAim.FreestandYaw) then
			fakeyawlimit = 60
			bodyyaw_angles = 60
			ui.set(Meta.reference.yaw[2], 0)
			ui.set(Meta.reference.body_yaw[2], 90)
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.reference.body_yaw[1], "Static")
		elseif bodyyaw_mode == "Jitter" and override_base_antiaim then
			if Meta.data.UpdateTickcount[ui.get(data.body_yaw_tick)] then
				Meta.data.CurrentBodyYawAngles = Meta.data.JitterIdealAngles[client.random_int(1, #Meta.data.JitterIdealAngles)]
			end

			fakeyawlimit = 0
			bodyyaw_angles = Meta.data.CurrentBodyYawAngles
		end

		local antiaim_vars = {
			body_yaw = bodyyaw_mode,
			fake_yaw_limit = fakeyawlimit,
			yaw = ui.get(Meta.reference.yaw[1]),
			body_yaw_offset = bodyyaw_angles,
			pitch = ui.get(Meta.reference.pitch[1]),
			extended_roll = ui.get(Meta.reference.roll),
			yaw_offset = ui.get(Meta.reference.yaw[2]),
			yaw_base = ui.get(Meta.reference.yaw_base),
			pitch_angles = ui.get(Meta.reference.pitch[2]),
			yaw_jitter = ui.get(Meta.reference.yaw_jitter[1]),
			yaw_jitter_offset = ui.get(Meta.reference.yaw_jitter[2])
		}

		if override_base_antiaim then
			Meta.RunAntiAim(e, antiaim_vars)
		end
	else
		local data = bindarg[bodyyaw > 0 and "right" or "left"]
		local yaw_jitter = ui.get(data.yaw_jitter)
		local yaw_offset = ui.get(data.yaw_offset)
		ui.set(Meta.reference.pitch[1], "Down")
		ui.set(Meta.reference.yaw_base, "At targets")
		local yaw_tickcount_amount = {
			[0] = 8,
			[1] = 12,
			[2] = 16
		}

		if ui.get(data.yaw) == "Random" then
			ui.set(Meta.reference.yaw[1], "180")
			ui.set(Meta.reference.yaw[2], math.random(0, yaw_offset))
		else
			local yaw_modifier = ui.get(data.yaw)
			if yaw_modifier == "Tickcount" then
				ui.set(Meta.reference.yaw[1], "180")
				ui.set(Meta.reference.yaw[2], Meta.data.UpdateTickcount[math.random(yaw_tickcount_amount[ui.get(data.yaw_tickcount)], yaw_tickcount_amount[ui.get(data.yaw_tickcount_random)])] and ui.get(data.yaw_tickcount_offset) or yaw_offset)
			else
				ui.set(Meta.reference.yaw[2], yaw_offset)
				ui.set(Meta.reference.yaw[1], ui.get(data.yaw))
			end
		end

		if yaw_jitter == "Slow 1X" then
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.elements.AntiAim.OverrideAntiAimBase, true)
			local current_offset = math.abs(ui.get(data.yaw_jitter_offset)) / 2
			ui.set(Meta.reference.yaw[2], (Meta.data.UpdateTickcount[slow_1x_speed] and current_offset or - current_offset) + yaw_offset)
		elseif yaw_jitter == "Slow 2X" then
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.elements.AntiAim.OverrideAntiAimBase, true)
			local current_offset = math.abs(ui.get(data.yaw_jitter_offset)) / 2
			ui.set(Meta.reference.yaw[2], (Meta.data.UpdateTickcount[slow_2x_speed] and current_offset or - current_offset) + yaw_offset)
		else
			ui.set(Meta.reference.yaw_jitter[1], yaw_jitter)
			ui.set(Meta.elements.AntiAim.OverrideAntiAimBase, false)
			if ui.get(data.enabled_yawjitter_tickcount) then
				local yawjitter_tickcount_amount = {
					[0] = 5,
					[1] = 7,
					[2] = 13
				}

				ui.set(Meta.reference.yaw_jitter[2], ui.get(Meta.data.UpdateTickcount[yawjitter_tickcount_amount[ui.get(data.yaw_jitter_tickcount)]] and data.yaw_jitter_tickcount_offset or data.yaw_jitter_offset))
			else
				ui.set(Meta.reference.yaw_jitter[2], ui.get(data.yaw_jitter_offset))
			end
		end

		ui.set(Meta.reference.roll, ui.get(data.roll))
		local bodyyaw_mode = ui.get(data.body_yaw)
		local fakeyawlimit = ui.get(data.fake_yaw_offset)
		local bodyyaw_angles = ui.get(data.body_yaw_offset)
		ui.set(Meta.reference.freestanding_body_yaw, ui.get(data.freestanding_body))
		if not override_base_antiaim then
			ui.set(Meta.reference.body_yaw[1], bodyyaw_mode)
			ui.set(Meta.reference.body_yaw[2], bodyyaw_angles)
		else
			ui.set(Meta.reference.body_yaw[1], "Static")
			ui.set(Meta.reference.body_yaw[2], 0)
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

		if Meta.contains(ui.get(Meta.elements.Misc.features), "Defensive aa") then
			local should_defensive = false
			local origin = vector(entity.get_origin(local_player))
			local defensive_conditions = ui.get(Meta.elements.Misc.defensive_conditions)
			if Meta.contains(defensive_conditions, bindarg.pointer) then
				should_defensive = true
			end

			if should_defensive then
				ui.set(Meta.reference.pitch[1], "Custom")
				local preset = ({
					["Pitch"] = {
						pitch_mode = "Tickcount", -- {"Off", "Tickcount", "Random", "3-Way", "5-Way"}
						defensive_pitch_ticks = 4, -- 2 -> 64
						defensive_pitch_min = 25, -- -89 -> 89
						defensive_pitch_max = - 89, -- -89 -> 89
						defensive_yaw_mode = "Off", --{"Off", "Tickcount", "Random", "Spin", "3-Way", "5-Way"}),
						defensive_yaw_ticks = 6, -- 2 -> 64
						defensive_yaw_min = - 60, -- -180 -> 180
						defensive_yaw_max = 60, -- -180 -> 180
					},

					["Random"] = {
						pitch_mode = "Random", -- {"Off", "Tickcount", "Random", "3-Way", "5-Way"}
						defensive_pitch_ticks = 4, -- 2 -> 64
						defensive_pitch_min = 25, -- -89 -> 89
						defensive_pitch_max = - 89, -- -89 -> 89
						defensive_yaw_mode = "Random", --{"Off", "Tickcount", "Random", "Spin", "3-Way", "5-Way"}),
						defensive_yaw_ticks = 6, -- 2 -> 64
						defensive_yaw_min = - 60, -- -180 -> 180
						defensive_yaw_max = 60, -- -180 -> 180
					}

				})[ui.get(Meta.elements.Misc.defensive_preset)]
				local defensive_pitch_mode = preset.defensive_pitch_mode
				local defensive_pitch_ticks = preset.defensive_pitch_ticks
				local defensive_pitch_min = preset.defensive_pitch_min
				local defensive_pitch_max = preset.defensive_pitch_max
				local defensive_yaw_mode = preset.defensive_yaw_mode
				local defensive_yaw_ticks = preset.defensive_yaw_ticks
				local defensive_yaw_min = preset.defensive_yaw_min
				local defensive_yaw_max = preset.defensive_yaw_max
				if defensive_pitch_mode == "Tickcount" then
					ui.set(Meta.reference.pitch[2], Meta.data.UpdateTickcount[defensive_pitch_ticks] and defensive_pitch_min or defensive_pitch_max)
				elseif defensive_pitch_mode == "Random" then
					ui.set(Meta.reference.pitch[2], math.random(defensive_pitch_min, defensive_pitch_max))
				elseif defensive_pitch_mode == "3-Way" then
					ui.set(Meta.reference.pitch[2], Meta.createways(defensive_pitch_min, 3, "Pitch 3Ways"))
				elseif defensive_pitch_mode == "5-Way" then
					ui.set(Meta.reference.pitch[2], Meta.createways(defensive_pitch_min, 5, "Pitch 3Ways"))
				end

				if defensive_yaw_mode == "Tickcount" then
					ui.set(Meta.reference.yaw[2], Meta.data.UpdateTickcount[defensive_yaw_ticks] and defensive_yaw_min or defensive_yaw_max)
				elseif defensive_yaw_mode == "Random" then
					ui.set(Meta.reference.yaw[2], math.random(defensive_yaw_min, defensive_yaw_max))
				elseif defensive_yaw_mode == "Spin" then
					Meta.data.SpinYaw = Meta.data.SpinYaw + 5
					if Meta.data.SpinYaw > defensive_yaw_min then
						Meta.data.SpinYaw = - defensive_yaw_min
					end

					ui.set(Meta.reference.yaw[2], Meta.normalizedyaw(Meta.data.SpinYaw))
				elseif defensive_yaw_mode == "3-Way" then
					ui.set(Meta.reference.yaw[2], Meta.createways(defensive_yaw_min, 3, "Yaw 3Ways"))
				elseif defensive_yaw_mode == "5-Way" then
					ui.set(Meta.reference.yaw[2], Meta.createways(defensive_yaw_min, 5, "Yaw 5Ways"))
				end
			end
		end

		if ui.get(Meta.elements.AntiAim.FreestandYaw) then
			fakeyawlimit = 60
			bodyyaw_angles = 60
			ui.set(Meta.reference.yaw[2], 0)
			ui.set(Meta.reference.body_yaw[2], 90)
			ui.set(Meta.reference.yaw_jitter[1], "Off")
			ui.set(Meta.reference.body_yaw[1], "Static")
		elseif bodyyaw_mode == "Jitter" and override_base_antiaim then
			if Meta.data.UpdateTickcount[ui.get(data.body_yaw_tick)] then
				Meta.data.CurrentBodyYawAngles = Meta.data.JitterIdealAngles[client.random_int(1, #Meta.data.JitterIdealAngles)]
			end

			fakeyawlimit = 0
			bodyyaw_angles = Meta.data.CurrentBodyYawAngles
		end

		local antiaim_vars = {
			body_yaw = bodyyaw_mode,
			fake_yaw_limit = fakeyawlimit,
			yaw = ui.get(Meta.reference.yaw[1]),
			body_yaw_offset = bodyyaw_angles,
			pitch = ui.get(Meta.reference.pitch[1]),
			extended_roll = ui.get(Meta.reference.roll),
			yaw_offset = ui.get(Meta.reference.yaw[2]),
			yaw_base = ui.get(Meta.reference.yaw_base),
			pitch_angles = ui.get(Meta.reference.pitch[2]),
			yaw_jitter = ui.get(Meta.reference.yaw_jitter[1]),
			yaw_jitter_offset = ui.get(Meta.reference.yaw_jitter[2])
		}

		if override_base_antiaim then
			Meta.RunAntiAim(e, antiaim_vars)
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
	local leg_mode = ui.get(Meta.elements.Misc.leg_mode)
	if Meta.contains(features, "Static leg in air") and not Meta.data.KeyDownGround then
		--entity.set_prop(local_player, "m_flPoseParameter", 1, 6)
	end

	if Meta.contains(features, "Static leg in slow") then
		entity.set_prop(local_player, "m_flPoseParameter", 0, 9)
	end

	if not Meta.data.SwitchLegModified[2] then
		if globals.tickcount() > Meta.data.SwitchLegModified[1] then
			Meta.data.SwitchLegModified[2] = true
			Meta.data.SwitchLegModified[1] = globals.tickcount() + 2.7
		end
	else
		if globals.tickcount() > Meta.data.SwitchLegModified[1] then
			Meta.data.SwitchLegModified[2] = false
			Meta.data.SwitchLegModified[1] = globals.tickcount() + 24
		end
	end

	if Meta.contains(features, "Michael jackson") and not Meta.data.KeyDownGround then
		local my_animlayer = self_index:get_anim_overlay(6)
		if leg_mode == "3.0" then
			if globals.tickcount() % 32 < 4 then
				entity.set_prop(local_player, "m_flPoseParameter", 1.1, 6)
			else
				my_animlayer.weight = 1
				ui.set(Meta.reference.leg_movement, "Always slide")
				entity.set_prop(local_player, "m_flPoseParameter", 0, 7)
			end
		else
			my_animlayer.weight = 1
			if leg_mode == "2.0" then
				ui.set(Meta.reference.leg_movement, "Always slide")
				entity.set_prop(local_player, "m_flPoseParameter", 0, 7)
			end
		end
	end

	if Meta.contains(features, "Michael jackson") and Meta.data.KeyDownGround then
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

		if leg_mode == "1.0" then
			ui.set(Meta.reference.leg_movement, "Never slide")
			entity.set_prop(local_player, "m_flPoseParameter", 0, 7)
			entity.set_prop(local_player, "m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 0.5 or 1)
		elseif leg_mode == "2.0" then
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

	if ui.get(Meta.elements.AntiAim.Enabled) and ui.get(Meta.elements.AntiAim.FreestandYaw) then
		ui.set(Meta.reference.leg_movement, "Always slide")
		entity.set_prop(local_player, "m_flPoseParameter", 1, 0)
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

Meta.animationlabel = function()
	local color1 = {
		r = 255,
		g = 255,
		b = 255,
		a = 255
	}

	local color2 = {
		r = 185,
		g = 183,
		b = 241,
		a = 255
	}

	local text = "master-switch zyxorin"
	local speed = 10
	local final_text =  ''
	local start_final_text = adder or ""
	local curtime = globals.curtime()
	for i = 0, #text do
		local x = (#text * 10) - (i * 10  )
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

	ui.set(Meta.elements.MasterSwitchLabel, final_text)
end

Meta.animated = function()
	if not ui.get(Meta.elements.Visuals.water) then
		return
	end

	local screen = {client.screen_size()}
	local x_offset, y_offset = screen[1], screen[2]
	local x, y =  x_offset / 2,y_offset / 2 
	local r, g, b = ui.get(Meta.elements.Visuals.fade_color)
	local alpha_percentage = {
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 60 / 30))},
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 55 / 30))},
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 50 / 30))},
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 45 / 30))},
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 40 / 30))},
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 35 / 30))},
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 30 / 30))},
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 25 / 30))},
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 20 / 30))},
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 15 / 30))},
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 10 / 30))},
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 5 / 30))},
		{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 0 / 30))}
	}

	renderer.text(x, y + 700, 0, 0, 0, 50, "-c", nil, "ZYXORIN.LUA")
	renderer.text(x, y + 700, 255, 255, 255, 255, "- c", nil, string.format("\a%sZ\a%sY\a%sX\a%sO\a%sR\a%sI\a%sN ", Meta.rgbatohex(unpack(alpha_percentage[1])), Meta.rgbatohex(unpack(alpha_percentage[2])), Meta.rgbatohex(unpack(alpha_percentage[3])), Meta.rgbatohex(unpack(alpha_percentage[4])), Meta.rgbatohex(unpack(alpha_percentage[5])), Meta.rgbatohex(unpack(alpha_percentage[6])), Meta.rgbatohex(unpack(alpha_percentage[7]))))
	renderer.text(x, y + 708, 255, 255, 255, 255, "- c", nil, string.format("\a%s-\a%sT\a%sE\a%sC\a%sH\a%sN\a%sO\a%sL\a%sO\a%sG\a%sY\a%s-", Meta.rgbatohex(unpack(alpha_percentage[1])), Meta.rgbatohex(unpack(alpha_percentage[2])), Meta.rgbatohex(unpack(alpha_percentage[3])), Meta.rgbatohex(unpack(alpha_percentage[4])), Meta.rgbatohex(unpack(alpha_percentage[5])), Meta.rgbatohex(unpack(alpha_percentage[6])), Meta.rgbatohex(unpack(alpha_percentage[7])), Meta.rgbatohex(unpack(alpha_percentage[8])), Meta.rgbatohex(unpack(alpha_percentage[9])), Meta.rgbatohex(unpack(alpha_percentage[10])), Meta.rgbatohex(unpack(alpha_percentage[11])), Meta.rgbatohex(unpack(alpha_percentage[12]))))
end

Meta.indication = function()
	Meta.handlereference(not ui.get(Meta.elements.AntiAim.Enabled) or not ui.get(Meta.elements.MasterSwitch))
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	local smooth = globals.frametime() * 11.5
	local smooth2 = globals.frametime() * 18
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
	local pingspike = ui.get(Meta.reference.ping_spike[1]) and ui.get(Meta.reference.ping_spike[2])
	if not Meta.data.CachedTexture then
		Meta.data.CachedTexture = renderer.load_svg(Meta.newtexture(500, 25), 0, 25)
	end

	if ui.get(Meta.elements.Visuals.CrosshairStyle) == "Normal" then
		local line_style = ui.get(Meta.elements.Visuals.LineStyle)
		local velocity_modifier = entity.get_prop(local_player, "m_flVelocityModifier")
		local size_list = {
			vector(renderer.measure_text("c-", "ZYXORIN")),
			vector(renderer.measure_text("c-", "safe")),
			vector(renderer.measure_text("c-", "baim")),
			vector(renderer.measure_text("cb", "fd")),
			vector(renderer.measure_text("c-", "debug")),
			vector(renderer.measure_text("c-", ("slow: %i"):format(velocity_modifier * 100) .. "%"))
		}

		local scope_size = {
			Meta.createlerp(b_zoom and math.floor(size_list[1].x / 2) + 12 or 0, "Size 1 X", smooth2),
			Meta.createlerp(b_zoom and math.floor(size_list[2].x / 2) + 19 or 0, "Size 2 X", smooth2),
			Meta.createlerp(b_zoom and math.floor(size_list[3].x / 2) + 18 or 0, "Size 3 X", smooth2),
			Meta.createlerp(b_zoom and math.floor(size_list[4].x / 2) + 21 or 0, "Size 4 X", smooth2),
			Meta.createlerp(b_zoom and math.floor(size_list[5].x / 2) + 15 or -1, "Size 5 X", smooth2),
		}

		local tickbase_amount = Meta.clamp(tickbase, 0, 11) / 11
		local pingspike_ratio = Meta.clamp(ui.get(Meta.reference.ping_spike[3]), 0, 150) / 150
		local hotkeys = {
			["hide"] = {"hide", onshot, {255, 255, 255, 255}},
			["dt"] = {"dt", doubletap, {255 - (tickbase_amount * 255), tickbase_amount * 255, 0, 255}},
			["duck"] = {"duck", fakeduck, {255, 255, 255, 255}},
			["legit"] = {"legit", ui.get(Meta.elements.AntiAim.LegitOnKey), {255, 255, 255, 255}},
			["edge"] = {"edge", ui.get(Meta.elements.AntiAim.EdgeYaw), {255, 255, 255, 255}},
			["safe"] = {"safe", force_safe, {255, 255, 255, 255}},
			["baim"] = {"baim", force_body, {255, 255, 255, 255}},
			["ping"] = {"ping", pingspike, {255 - (pingspike_ratio * 255), pingspike_ratio * 255, 0, 255}}
		}

		local different = 0
		if globals.chokedcommands() == 0 then
			local self_index = c_entity.new(local_player)
			local self_anim_state = self_index:get_anim_state()
			Meta.data.UpdateBodyYaw = Meta.clamp(Meta.normalizedyaw(self_anim_state.goal_feet_yaw - self_anim_state.eye_angles_y), - 60, 60)
		end

		local version_Color = {ui.get(Meta.elements.Visuals.versionColor)}
		different2 = different + 1
		local debug呼吸速度 = 2 -- 越高越快
		local time_pulse = math.sin(math.abs(- math.pi + (globals.curtime() * (5/ 6 - debug呼吸速度)) % (math.pi * 2))) * 255
		renderer.text(center.x + scope_size[5], center.y + 22, version_Color[1], version_Color[2], version_Color[3], Meta.clamp(time_pulse, 0, version_Color[4]), "c-", 0, "NIGHTLY")
		local tickbase_amount = Meta.clamp(tickbase, 0, 11) / 11
		local desync_amount = math.abs(Meta.data.UpdateBodyYaw / 60)
		Meta.textfadeanimation(center.x -1 + scope_size[1], center.y + 19 + (different2 * 17), 1, Meta.tabletocolor(name_color), Meta.tabletocolor(name_color2), "ZYXORIN", true, "", "c-")
		if line_style == "Side" then
			Meta.roundrect(center.x - 14 + scope_size[2], center.y + 27, 32, 5, 2, 0, 0, 0, 115)
			if Meta.data.UpdateBodyYaw > 0 then
				Meta.roundrect(center.x - 14 + scope_size[3], center.y + 28, 16, 3, 2, bar_color[1], bar_color[2], bar_color[3], bar_color[4])
			else
				Meta.roundrect(center.x + 1 + scope_size[4], center.y + 28, 16, 3, 2, bar_color[1], bar_color[2], bar_color[3], bar_color[4])
			end
		else
			local bar_animation = Meta.clamp(math.abs(Meta.createlerp(math.abs(Meta.data.UpdateBodyYaw), "Lerp bar angles", globals.frametime() * 7) / 60), 0.2, 1)
			renderer.rectangle(center.x - 20 + scope_size[2], center.y + 27, 42, 4, 0, 0, 0, 115)
			renderer.rectangle((center.x - 19) + scope_size[2], center.y + 28, bar_animation * 41, 2, bar_color[1], bar_color[2], bar_color[3], bar_color[4])
		end

		local hotkeys_update = 0
		local hotkeys_smooth = globals.frametime() * 5
		for key, data in pairs(hotkeys) do
			local animation = Meta.createstaticanimation(0, 1, data[2], hotkeys_smooth, key .. "#1 Style")
			hotkeys_update = hotkeys_update + (animation * 9)
			renderer.text(center.x -1 + scope_size[1], center.y + 19 + (different2 * 17) + hotkeys_update, data[3][1], data[3][2], data[3][3], data[3][4] * animation, "c-", 0, key:upper())
		end

	elseif ui.get(Meta.elements.Visuals.CrosshairStyle) == "Modern" then
		local different = 0
		local velocity_modifier = entity.get_prop(local_player, "m_flVelocityModifier")
		local size_list = {
			vector(renderer.measure_text("cb", "hide")),
			vector(renderer.measure_text("cb", "dt")),
			vector(renderer.measure_text("cb", "duck")),
			vector(renderer.measure_text("cb", "safe")),
			vector(renderer.measure_text("cb", "baim")),
			vector(renderer.measure_text("cb", Meta.data.ScriptName)),
			vector(renderer.measure_text("cb", "debug")),
			vector(renderer.measure_text("cb", ("slow: %i"):format(velocity_modifier * 100) .. "%")),
			vector(renderer.measure_text("cb", "edge")),
			vector(renderer.measure_text("cb", "legit"))
		}

		local scope_size = {
			Meta.createlerp(b_zoom and math.floor(size_list[1].x / 2) + 5 or 0, "Size 1 X", smooth),
			Meta.createlerp(b_zoom and math.floor(size_list[2].x / 2) + 5 or 0, "Size 2 X", smooth),
			Meta.createlerp(b_zoom and math.floor(size_list[3].x / 2) + 5 or 0, "Size 3 X", smooth),
			Meta.createlerp(b_zoom and math.floor(size_list[4].x / 2) + 5 or 0, "Size 4 X", smooth),
			Meta.createlerp(b_zoom and math.floor(size_list[5].x / 2) + 5 or 0, "Size 5 X", smooth),
			Meta.createlerp(b_zoom and math.floor(size_list[6].x / 2) + -2 or 0, "Size 6 X", smooth),
			Meta.createlerp(b_zoom and math.floor(size_list[7].x / 2) + 5 or 0, "Size 7 X", smooth),
			Meta.createlerp(b_zoom and math.floor(size_list[8].x / 2) + 5 or 0, "Size 8 X", smooth),
			Meta.createlerp(b_zoom and math.floor(size_list[9].x / 2) + 5 or 0, "Size 9 X", smooth),
			Meta.createlerp(b_zoom and math.floor(size_list[10].x / 2) + 5 or 0, "Size 10 X", smooth)
		}

		local version_Color = {ui.get(Meta.elements.Visuals.versionColor)}
		local debug呼吸速度 = 2 -- 越高越快
		local time_pulse = math.sin(math.abs(- math.pi + (globals.curtime() * (5/ 6 - debug呼吸速度)) % (math.pi * 2))) * 255
		Meta.textfadeanimation(center.x + scope_size[6], center.y + 27, 1, Meta.tabletocolor(name_color), Meta.tabletocolor(name_color2), "+zyxorin-", true, "", "c")
		different = different + 1
		renderer.text(center.x + scope_size[7], center.y + 22 + (different * 17), version_Color[1], version_Color[2], version_Color[3], Meta.clamp(time_pulse, 0, version_Color[4]), "c", 0, "nightly")
		local hotkeys = {
			["hide"] = {"hide", onshot or force_draw_hotkey, oscolor, scope_size[1]},
			["velocity"] = {("slow: %i"):format(velocity_modifier * 100) .. "%", velocity_modifier ~= 1, {255, 255, 255, 255}, scope_size[8]},
			["dt"] = {"dt", doubletap or force_draw_hotkey, dtcolor, scope_size[2]},
			["fd"] = {"duck", fakeduck or force_draw_hotkey, fdcolor, scope_size[3]},
			["legit"] = {"legit", ui.get(Meta.elements.AntiAim.LegitOnKey), edge_color, scope_size[10]},
			["edge"] = {"edge", ui.get(Meta.elements.AntiAim.EdgeYaw), legit_color, scope_size[9]},
			["safe"] = {"safe", force_safe or force_draw_hotkey, safe_color, scope_size[4]},
			["baim"] = {"baim", force_body or force_draw_hotkey, baim_color, scope_size[5]}
		}

		local hotkeys_update = 0
		local hotkeys_smooth = globals.frametime() * (animation_mode == "Lerp" and 8 or 10)
		for key, data in pairs(hotkeys) do
			local animation = animation_mode == "Lerp" and Meta.createlerp(data[2] and 1 or 0, key .. "#2", hotkeys_smooth) or Meta.createstaticanimation(0, 1, data[2], hotkeys_smooth, key .. "#2")
			Meta.renderglowtext(center.x + data[4], center.y + 52 + hotkeys_update, data[3][1], data[3][2], data[3][3], data[3][4] * animation, "c", 0, data[1], 1, data[1])
			hotkeys_update = hotkeys_update + (animation * 13)
		end
	end

	local manual_dist = ui.get(Meta.elements.Visuals.ManualDistance)
	local manual_color = {ui.get(Meta.elements.Visuals.ManualColor)}
	local scope_arrow_smooth = (ui.get(Meta.elements.Visuals.ManualScopeSmooth) / 10) * globals.frametime()
	local debug呼吸速度 = 2 -- 越高越快
	local arrows_lowest = Meta.createlerp((ui.get(Meta.elements.Visuals.ManualScopeLowest) and b_zoom) and ui.get(Meta.elements.Visuals.ManualLowestSize) or 0, "Scope Arrow", scope_arrow_smooth)
	local time_pulse = math.sin(math.abs(- math.pi + (globals.curtime() * (5/ 6 - debug呼吸速度)) % (math.pi * 2))) * 255
	if ui.get(Meta.elements.Visuals.ManualIndication) == "❮ ❯" then
		local between = 40
		if Meta.data.ManualSide == 1 then
			surface.draw_text(center.x - manual_dist, center.y - 13.5 + arrows_lowest, manual_color[1], manual_color[2], manual_color[3], Meta.clamp(time_pulse, 0, manual_color[4]), old_font, "❮")
		elseif Meta.data.ManualSide == 2 then
			surface.draw_text(center.x + manual_dist - 10, center.y - 13.5 + arrows_lowest, manual_color[1], manual_color[2], manual_color[3], Meta.clamp(time_pulse, 0, manual_color[4]), old_font, "❯")
		end

	elseif ui.get(Meta.elements.Visuals.ManualIndication) == "⮜ ⮞" then
		if Meta.data.ManualSide == 1 then
			renderer.text(center.x - manual_dist, center.y - 1 + arrows_lowest, manual_color[1], manual_color[2], manual_color[3], Meta.clamp(time_pulse, 0, manual_color[4]), "cb", 0, "⮜")
		elseif Meta.data.ManualSide == 2 then
			renderer.text(center.x + manual_dist, center.y - 1 + arrows_lowest, manual_color[1], manual_color[2], manual_color[3], Meta.clamp(time_pulse, 0, manual_color[4]), "cb", 0, "⮞")
		end

	elseif ui.get(Meta.elements.Visuals.ManualIndication) == "⯇ ⯈" then
		if Meta.data.ManualSide == 1 then
			renderer.text(center.x - manual_dist, center.y - 3 + arrows_lowest, manual_color[1], manual_color[2], manual_color[3], Meta.clamp(time_pulse, 0, manual_color[4]), "c+", 0, "⯇")
		elseif Meta.data.ManualSide == 2 then
			renderer.text(center.x + manual_dist, center.y - 3 + arrows_lowest, manual_color[1], manual_color[2], manual_color[3], Meta.clamp(time_pulse, 0, manual_color[4]), "c+", 0, "⯈")
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
		Meta.animated()
	end,

	["aim_hit"] = function(e)
		Meta.aimhit(e)
	end,

	["aim_miss"] = function(e)
		Meta.aimmiss(e)
	end,

	["pre_render"] = function(e)
		Meta.animation(e)
		Meta.oncustompose(e)
	end,

	["net_update_end"] = function(e)
		for _, ptr in pairs(entity.get_players(true)) do
			Meta.simulation(ptr)
		end
	end,

	["setup_command"] = function(e)
		Meta.lagcomp(e)
		Meta.command(e)
		Meta.updatetick(e)
		Meta.commandmisc(e)
	end,

	["shutdown"] = function()
		Meta.handlereference(true)
		Meta.handlefakelagreference(false)
		database.write("zyxorin configs", Meta.data.Configs)
		database.write("zyxorin configs data", Meta.data.ConfigsData)
	end
}

Meta.main = function()
	client.exec("cl_bobamt_lat 0")
	client.exec("cl_bobamt_vert 0")
	client.exec("cl_bob_lower_amt 0")
	Meta.CHelpers.SetClientLanguege("tchinese")
	Meta.multicallback(Meta.elements, Meta.handlemain, true)
	ui.set_callback(Meta.elements.AntiAim.OverrideAntiAimBase, function()
		Meta.handlemain()
	end)

	ui.set_callback(Meta.elements.MasterSwitch, function()
		Meta.handlemain()
		local callback = ui.get(Meta.elements.MasterSwitch) and client.set_event_callback or client.unset_event_callback
		for Key, Handle in pairs(Meta.callbacks) do
			local succes, data = pcall(callback, Key, Handle)
			if not success and data then
				error(("[ %s ]error: failed set callback: %s, result: %s"):format(Meta.data.ScriptName, Key, data))
			end
		end
	end, true)

	client.set_event_callback("paint_ui", Meta.animationlabel)
end

Meta.main()