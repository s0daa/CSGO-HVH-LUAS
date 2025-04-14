-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local LastUpdated = "11/2/2022"
local obex_data = obex_fetch and obex_fetch() or {username = "DavidDD", build = "Debug"}

--Requirements
local require = {
    antiaim_funcs = require "gamesense/antiaim_funcs",
    easing = require "gamesense/easing",
    chat = require "gamesense/chat",
    clipboard = require "gamesense/clipboard",
    vector = require("vector")
}

--Refs
local ref = {
    ["MainAA"] = {
        Enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
        Pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
        YawBase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
        Yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
        YawJitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
        BodyYaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
        FreestandingBodyYaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body Yaw"),
        FakeYawLimit = ui.reference("AA", "Anti-aimbot angles", "Fake Yaw limit"),
        EdgeYaw = ui.reference("AA", "Anti-aimbot angles", "Edge Yaw"),
        Freestanding = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
        Roll = ui.reference("AA", "Anti-aimbot angles", "Roll")
    },
    ["Fake Lag"] = {
        FLEnable = {ui.reference("AA", "Fake lag", "Enabled")},
        FL = ui.reference("AA", "Fake lag", "Limit"),
        FLAmmount = ui.reference("AA", "Fake lag", "Amount"),
        FLVariance = ui.reference("AA", "Fake lag", "Variance")
    },
    ["Other"] = {
        SlowMotion = { ui.reference("AA", "Other", "Slow motion") },
        LegMovement = ui.reference("AA", "Other", "Leg movement"),
        OSAA = {ui.reference("AA", "Other", "On shot anti-aim")},
        FakeDuck = ui.reference("Rage", "Other", "Duck peek assist"),
        DT = {ui.reference("Rage", "Other", "Double tap")},
        FBA = ui.reference("Rage", "Other", "Force body aim"),
        FSP = ui.reference("Rage", "Aimbot", "Force safe point"),
        PostProccessing = ui.reference("Visuals", "Effects", "Disable post processing")
    },
}

--Menu
local menu = {
    TabSelector = ui.new_combobox("AA", "Anti-aimbot angles", "Aura Tab Selector", {"Information", "Anti-Aimbot", "Visuals", "Colors"}),

    ["Greetings"] = {
        Intro = ui.new_label("AA", "Anti-aimbot angles", "Welcome to Aura V2, " .. obex_data.username .. "!"),
        Build = ui.new_label("AA", "Anti-aimbot angles", "You are currently on " .. obex_data.build .. " Build."),
        LastUpdate = ui.new_label("AA", "Anti-aimbot angles", "Last Updated on " .. LastUpdated .. "!"),
        Developed = ui.new_label("AA", "Anti-aimbot angles", "Developed by DavidDD#1060")
    },
    ["Anti-Aimbot"] = {
        EnableAA = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Anti-Aimbot"),
        Presets = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-Aim Selector", {"Preset", "Builder"}),
        LegitAA = ui.new_hotkey("AA", "Anti-aimbot angles", "Legit AA", false, 0x45),
        EdgeYaw = ui.new_hotkey("AA", "Anti-aimbot angles", "Edge Yaw"),
        Freestanding = ui.new_hotkey("AA", "Anti-aimbot angles", "Freestanding", false),
        FreestandingOptions = ui.new_combobox("AA", "Anti-aimbot angles", "Freestanding Options", {"Default", "Static"}),
        ToggleAntiBrute = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Anti-BruteForce"),
        AntiBackStab = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti-BackStab"),
        BetterHideShots = ui.new_checkbox("AA", "Anti-aimbot angles", "Better Hide Shots"),
        PlayerState = ui.new_combobox("AA", "Anti-aimbot angles", "Player State", {"Fake Lag", "Air + Duck", "Airborne", "Crouching", "Slow Walking", "Running", "Standing"})
    },
    ["Visuals"] = {
        EnableVisuals = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Visuals"),
        Indicators = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Crosshair Indicators"),
        IndicatorSelection = ui.new_combobox("AA", "Anti-aimbot angles", "Indicator Style", {"Default", "Alternate", "Ideal Yaw"}),
        StatusIndicator = ui.new_checkbox("AA", "Anti-aimbot angles", "Status Indicator"),
        EnableDrag = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable to Drag"),
        Watermark = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Watermark"),
        SunSetMode = ui.new_checkbox("AA", "Anti-aimbot angles", "Sunset Mode"),
        BreakAnims = ui.new_multiselect("AA", "Anti-aimbot angles", "Anim Breakers", {"Static Legs in Air", "0 Pitch on Land", "Leg Movement Breaker"})
    },
    ["Colors"] = {
        OverrideColors = ui.new_checkbox("AA", "Anti-aimbot angles", "Override Default Colors"),
        Label1 = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFFFPrimary Color"),
        Color1 = ui.new_color_picker("AA", "Anti-aimbot angles", "\aFFFFFFFFPrimary Color", 255, 255, 255, 255),
        Label2 = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFFFSecondary Color"),
        Color2 = ui.new_color_picker("AA", "Anti-aimbot angles", "\aFFFFFFFFSecondary Color", 220, 20, 60, 255),
        PlayerStateColorLabel = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFFFPlayer State Color"),
        PlayerStateColor = ui.new_color_picker("AA", "Anti-aimbot angles", "\aFFFFFFFFPlayer State Color", 255, 255, 255, 255),
        Label3 = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFFFArrow Color"),
        Color3 = ui.new_color_picker("AA", "Anti-aimbot angles", "\aFFFFFFFFArrow Color", 220, 20, 60, 255),
        Label4 = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFFFActive Hotkey Color"),
        Color4 = ui.new_color_picker("AA", "Anti-aimbot angles", "\aFFFFFFFFActive Hotkey Color", 255, 255, 255, 255),
        Label5 = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFFFInactive Hotkey Color"),
        Color5 = ui.new_color_picker("AA", "Anti-aimbot angles", "\aFFFFFFFFInactive Hotkey Color", 255, 255, 255, 255),
        Label6 = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFFFWatermark Color"),
        Color6 = ui.new_color_picker("AA", "Anti-aimbot angles", "\aFFFFFFFFWatermark Color", 220, 20, 60, 255)
    },
    ["Hide"] = {
        Status_X = ui.new_slider("Lua", "B", "Status_X", -100, 5000),
        Status_Y = ui.new_slider("Lua", "B", "Status_Y", -100, 5000),
        Aura = ui.new_slider("AA", "Anti-aimbot angles", "Aura", -100, 100),
        Alpha = ui.new_slider("AA", "Anti-aimbot angles", "Alpha", -100, 100),
        LeftArrow = ui.new_slider("AA", "Anti-aimbot angles", "Left Arrow", -100, 100),
        RightArrow = ui.new_slider("AA", "Anti-aimbot angles", "Right Arrow", -100, 100),
        DT = ui.new_slider("AA", "Anti-aimbot angles", "DT", -100, 100),
        OSAA = ui.new_slider("AA", "Anti-aimbot angles", "OSAA", -100, 100),
        FBA = ui.new_slider("AA", "Anti-aimbot angles", "Force Baim", -100, 100),
        FS = ui.new_slider("AA", "Anti-aimbot angles", "FS", -100, 100),
        PlayerState = ui.new_slider("AA", "Anti-aimbot angles", "PlayerState", -100, 100)
    }
}

--Builder
local Builder = { }
local States = {"Fake Lag", "Air + Duck", "Airborne", "Crouching", "Slow Walking", "Running", "Standing"}
local ConvertStates = {["Fake Lag"] = 1, ["Air + Duck"] = 2, ["Airborne"] = 3, ["Crouching"] = 4, ["Slow Walking"] = 5, ["Running"] = 6, ["Standing"] = 7}

for i = 1, #States do
    Builder[i] = {
        Enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFEnable " .. States[i] .. " State Override"),
        YawLeft = ui.new_slider("AA", "Anti-aimbot angles", "Yaw Left\n" .. States[i], -180, 180, 0),
        YawRight = ui.new_slider("AA", "Anti-aimbot angles", "Yaw Right\n" .. States[i], -180, 180, 0),
        YawJitterMain = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFYaw Jitter\n" .. States[i], {"Off", "Offset", "Center", "Random"}),
        YawJitterSlider = ui.new_slider("AA", "Anti-aimbot angles", "\nYaw Jitter" .. States[i], -180, 180, 0),
        BodyYawMain = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFBody Yaw\n" .. States[i], {"Off", "Opposite", "Jitter", "Static"}),
        FreestandingBodyYawBuilder = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFFreestanding Body Yaw\n" .. States[i]),
        FakeYawLimitLeft = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFFake Yaw Limit Left\n" .. States[i], 0, 60, 60),
        FakeYawLimitRight = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFFake Yaw Limit Right\n" .. States[i], 0, 60, 60),
    }
end

--Import/Export
local function import_config()
	local settings = json.parse(require.clipboard.get())
	for key, value in pairs(States) do
		for k, v in pairs(Builder[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui.set(v, current)
			end
		end
	end
	print("[AURA]: Import Successful!")
end

local Import = ui.new_button("AA", "Anti-aimbot angles", "Import Aura Builder Settings", import_config)

local function export_config()
	local settings = {}
	for key, value in pairs(States) do
		settings[tostring(value)] = {}
		for k, v in pairs(Builder[key]) do
			settings[value][k] = ui.get(v)
		end
	end
	
	require.clipboard.set(json.stringify(settings))
	print("[AURA]: Export successful!")
end

local Export = ui.new_button("AA", "Anti-aimbot angles", "Export Aura Builder Settings", export_config)

--GUI Removals
local function SetTableVisibility(table, state)
    for i = 1, #table do
        ui.set_visible(table[i], state)
    end
end

client.set_event_callback("paint_ui", function()
    SetTableVisibility({ref.MainAA.Enabled, ref.MainAA.Pitch, ref.MainAA.YawBase, ref.MainAA.Yaw[1], ref.MainAA.Yaw[2], ref.MainAA.YawJitter[1], ref.MainAA.YawJitter[2], ref.MainAA.BodyYaw[1], ref.MainAA.BodyYaw[2], ref.MainAA.FreestandingBodyYaw, ref.MainAA.FakeYawLimit, ref.MainAA.EdgeYaw, ref.MainAA.Freestanding[1], ref.MainAA.Freestanding[2], ref.MainAA.Roll}, false)
    SetTableVisibility({menu.Hide.Status_X, menu.Hide.Status_Y, menu.Hide.Aura, menu.Hide.Alpha, menu.Hide.LeftArrow, menu.Hide.RightArrow, menu.Hide.DT, menu.Hide.OSAA, menu.Hide.FS, menu.Hide.FBA, menu.Hide.PlayerState}, false)
    if ui.is_menu_open() then
        InformationTabActive =  ui.get(menu.TabSelector) == "Information"
        SetTableVisibility({menu.Greetings.Intro, menu.Greetings.Build, menu.Greetings.LastUpdate, menu.Greetings.Developed}, InformationTabActive)
        AATabActive = ui.get(menu.TabSelector) == "Anti-Aimbot"
        SetTableVisibility({menu["Anti-Aimbot"].EnableAA, menu["Anti-Aimbot"].Presets, menu["Anti-Aimbot"].LegitAA, menu["Anti-Aimbot"].Freestanding, menu["Anti-Aimbot"].FreestandingOptions, menu["Anti-Aimbot"].EdgeYaw, menu["Anti-Aimbot"].FreestandingOptions, menu["Anti-Aimbot"].ToggleAntiBrute, menu["Anti-Aimbot"].AntiBackStab, menu["Anti-Aimbot"].BetterHideShots, menu["Anti-Aimbot"].PlayerState}, AATabActive)
        VisualsTabActive = ui.get(menu.TabSelector) == "Visuals"
        SetTableVisibility({menu.Visuals.EnableVisuals, menu.Visuals.Indicators, menu.Visuals.IndicatorSelection, menu.Visuals.StatusIndicator, menu.Visuals.Watermark, menu.Visuals.SunSetMode, menu.Visuals.BreakAnims}, VisualsTabActive)
        AACheckActive = ui.get(menu["Anti-Aimbot"].EnableAA) and AATabActive
        SetTableVisibility({menu["Anti-Aimbot"].Presets, menu["Anti-Aimbot"].LegitAA, menu["Anti-Aimbot"].Freestanding, menu["Anti-Aimbot"].FreestandingOptions, menu["Anti-Aimbot"].EdgeYaw, menu["Anti-Aimbot"].ToggleAntiBrute, menu["Anti-Aimbot"].AntiBackStab, menu["Anti-Aimbot"].BetterHideShots}, AACheckActive)
        BuilderCheckActive = ui.get(menu["Anti-Aimbot"].Presets) == "Builder" and AATabActive
        ui.set_visible(menu["Anti-Aimbot"].PlayerState, BuilderCheckActive)
        ui.set_visible(Export, BuilderCheckActive)
        ui.set_visible(Import, BuilderCheckActive)
        VisualsCheckActive = ui.get(menu.Visuals.EnableVisuals) and ui.get(menu.TabSelector) == "Visuals"
        SetTableVisibility({menu.Visuals.Indicators, menu.Visuals.IndicatorSelection, menu.Visuals.StatusIndicator, menu.Visuals.EnableDrag, menu.Visuals.Watermark, menu.Visuals.SunSetMode, menu.Visuals.BreakAnims}, VisualsCheckActive)
        CrosshairIndicatorsActive = ui.get(menu.Visuals.Indicators) and VisualsTabActive
        ui.set_visible(menu.Visuals.IndicatorSelection, CrosshairIndicatorsActive)
        StatusIndicatorActive = ui.get(menu.Visuals.StatusIndicator) and ui.get(menu.TabSelector) == "Visuals"
        ui.set_visible(menu.Visuals.EnableDrag, StatusIndicatorActive)
        ColorsTabActive = ui.get(menu.TabSelector) == "Colors"
        ui.set_visible(menu.Colors.OverrideColors, ColorsTabActive)

        if ColorsTabActive and ui.get(menu.Colors.OverrideColors) and ui.get(menu.Visuals.IndicatorSelection) == "Default" then
            SetTableVisibility({menu.Colors.Color1, menu.Colors.Color2, menu.Colors.Color3, menu.Colors.Color4, menu.Colors.Color5, menu.Colors.Color6, menu.Colors.Label1, menu.Colors.Label2, menu.Colors.Label3, menu.Colors.Label4, menu.Colors.Label5, menu.Colors.Label6, menu.Colors.PlayerStateColor, menu.Colors.PlayerStateColorLabel}, true)
        elseif ColorsTabActive and ui.get(menu.Colors.OverrideColors) and ui.get(menu.Visuals.IndicatorSelection) == "Alternate" then
            SetTableVisibility({menu.Colors.Color1, menu.Colors.Color2, menu.Colors.Color4, menu.Colors.Color5, menu.Colors.Label1, menu.Colors.Label2,menu.Colors.Label4, menu.Colors.Label5}, true)
            SetTableVisibility({menu.Colors.Color3, menu.Colors.Color6, menu.Colors.PlayerStateColor, menu.Colors.Label3, menu.Colors.Label6, menu.Colors.PlayerStateColorLabel}, false)
        elseif ColorsTabActive and ui.get(menu.Colors.OverrideColors) and ui.get(menu.Visuals.IndicatorSelection) == "Ideal Yaw" then
            SetTableVisibility({menu.Colors.Color4, menu.Colors.Color5, menu.Label4, menu.Label5}, true)
            SetTableVisibility({menu.Colors.Color1, menu.Colors.Color2, menu.Colors.Color3, menu.Colors.Color6, menu.Colors.Label1, menu.Colors.Label2, menu.Colors.Label3, menu.Colors.Label6, menu.Colors.PlayerStateColor, menu.Colors.PlayerStateColorLabel})
        else
            SetTableVisibility({menu.Colors.Color1, menu.Colors.Color2, menu.Colors.Color3, menu.Colors.Color4, menu.Colors.Color5, menu.Colors.Color6, menu.Colors.Label1, menu.Colors.Label2, menu.Colors.Label3, menu.Colors.Label4, menu.Colors.Label5, menu.Colors.Label6, menu.Colors.PlayerStateColor, menu.Colors.PlayerStateColorLabel}, false)
        end

        if AATabActive and ui.get(menu["Anti-Aimbot"].Presets) == "Builder" then
            ActiveStateVisual = ConvertStates[ui.get(menu["Anti-Aimbot"].PlayerState)]
            for i=1, #States do
                ui.set_visible(Builder[i].Enable, ActiveStateVisual == i and AATabActive)
                if ui.get(Builder[i].Enable) then
                    ui.set_visible(Builder[i].YawLeft, ActiveStateVisual == i and AATabActive)
                    ui.set_visible(Builder[i].YawRight, ActiveStateVisual == i and AATabActive)
                    ui.set_visible(Builder[i].YawJitterMain, ActiveStateVisual == i and AATabActive)
                    ui.set_visible(Builder[i].YawJitterSlider, ActiveStateVisual == i and ui.get(Builder[ActiveStateVisual].YawJitterMain) ~= "Off" and AATabActive)
                    ui.set_visible(Builder[i].BodyYawMain, ActiveStateVisual == i and AATabActive)
                    ui.set_visible(Builder[i].FakeYawLimitLeft, ActiveStateVisual == i and AATabActive)
                    ui.set_visible(Builder[i].FakeYawLimitRight, ActiveStateVisual == i and AATabActive)
                    ui.set_visible(Builder[i].FreestandingBodyYawBuilder, ActiveStateVisual == i and AATabActive)
                else
                    ui.set_visible(Builder[i].YawLeft, false)
                    ui.set_visible(Builder[i].YawRight, false)
                    ui.set_visible(Builder[i].YawJitterMain, false)
                    ui.set_visible(Builder[i].YawJitterSlider, false)
                    ui.set_visible(Builder[i].BodyYawMain, false)
                    ui.set_visible(Builder[i].FakeYawLimitLeft, false)
                    ui.set_visible(Builder[i].FakeYawLimitRight, false)
                    ui.set_visible(Builder[i].FreestandingBodyYawBuilder, false)
                end
            end
        else
            for i=1, 7 do
                ui.set_visible(Builder[i].Enable, false)
                ui.set_visible(Builder[i].YawLeft, false)
                ui.set_visible(Builder[i].YawRight, false)
                ui.set_visible(Builder[i].YawJitterMain, false)
                ui.set_visible(Builder[i].YawJitterSlider, false)
                ui.set_visible(Builder[i].BodyYawMain, false)
                ui.set_visible(Builder[i].FakeYawLimitLeft, false)
                ui.set_visible(Builder[i].FakeYawLimitRight, false)
                ui.set_visible(Builder[i].FreestandingBodyYawBuilder, false)
            end
        end
    end
end)

--Shut Down
client.set_event_callback("shutdown", function()
    SetTableVisibility({ref.MainAA.Enabled, ref.MainAA.Pitch, ref.MainAA.YawBase, ref.MainAA.Yaw[1], ref.MainAA.Yaw[2], ref.MainAA.YawJitter[1], ref.MainAA.YawJitter[2], ref.MainAA.BodyYaw[1], ref.MainAA.BodyYaw[2], ref.MainAA.FakeYawLimit, ref.MainAA.FreestandingBodyYaw, ref.MainAA.EdgeYaw, ref.MainAA.Freestanding[1], ref.MainAA.Freestanding[2], ref.MainAA.Roll}, true)
    ui.set(ref.MainAA.Pitch, "Off")
    ui.set(ref.MainAA.YawBase, "Local View")
    ui.set(ref.MainAA.Yaw[1], "Off")
    ui.set(ref.MainAA.Yaw[2], 0)
    ui.set(ref.MainAA.YawJitter[1], "Off")
    ui.set(ref.MainAA.YawJitter[2], 0)
    ui.set(ref.MainAA.BodyYaw[1], "Off")
    ui.set(ref.MainAA.BodyYaw[2], 0)
    ui.set(ref.MainAA.FakeYawLimit, 60)
end)

--Get Player State
local flags = {
    FL_ONGROUND = bit.lshift(1, 0);
    FL_DUCKING = bit.lshift(1, 1);
}

local getPlayerState = function()
    local getVelocity = math.floor(require.vector(entity.get_prop(entity.get_local_player(), "m_vecVelocity")):length2d() + 0.5)
    local getFlags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    local isSlowWalking = ui.get(ref.Other.SlowMotion[2])
    local isExploting = ui.get(ref.Other.DT[2]) or ui.get(ref.Other.OSAA[2])

    if not isExploting then
        return "Fake Lag"
    end
    if client.key_state(0x20) and client.key_state(0x11) or (bit.band(getFlags, flags.FL_ONGROUND) ~= 1) and client.key_state(0x11) then
        return "Air+Duck"
    end
    if client.key_state(0x20) or (bit.band(getFlags, flags.FL_ONGROUND) ~= 1) then
        return "Airborne"
    end
    if (bit.band(getFlags, flags.FL_DUCKING ) ~= 0 and bit.band(getFlags, flags.FL_ONGROUND) == 1) then
        return "Crouching"
    end
    if isSlowWalking then
        return "Slow Walking"
    end
    if (bit.band(getFlags, flags.FL_ONGROUND) == 1 and getVelocity >= 2) then
        return "Running"
    end
    if (bit.band(getFlags, flags.FL_ONGROUND) == 1 and getVelocity <= 2) then
        return "Standing"
    end
end

client.set_event_callback("run_command", function()
    if getPlayerState() == "Fake Lag" then ActiveStateFunction = 1 
    elseif getPlayerState() == "Air+Duck" then ActiveStateFunction = 2 
    elseif getPlayerState() == "Airborne" then ActiveStateFunction = 3 
    elseif getPlayerState() == "Crouching" then ActiveStateFunction = 4 
    elseif getPlayerState() == "Slow Walking" then ActiveStateFunction = 5 
    elseif getPlayerState() == "Running" then ActiveStateFunction = 6 
    elseif getPlayerState() == "Standing" then ActiveStateFunction = 7
    end
end)

--AB Part 1
local best_enemy = nil

local brute = {
	yaw_status = "default",
	fs_side = 0,
	last_miss = 0,
	best_angle = 0,
	misses = { },
	hp = 0,
	misses_ind = { },
	can_hit_head = 0,
	can_hit = 0,
	hit_reverse = { }
}

local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local function calc_angle(local_x, local_y, enemy_x, enemy_y)
	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math.atan( ydelta / xdelta )
	relativeyaw = normalize_yaw( relativeyaw * 180 / math.pi )
	if xdelta >= 0 then
		relativeyaw = normalize_yaw(relativeyaw + 180)
	end
	return relativeyaw
end

local function ang_on_screen(x, y)
	if x == 0 and y == 0 then return 0 end

	return math.deg(math.atan2(y, x))
end

local function angle_vector(angle_x, angle_y)
	local sy = math.sin(math.rad(angle_y))
	local cy = math.cos(math.rad(angle_y))
	local sp = math.sin(math.rad(angle_x))
	local cp = math.cos(math.rad(angle_x))
	return cp * cy, cp * sy, -sp
end

local function get_damage(me, enemy, x, y,z)
	local ex = { }
	local ey = { }
	local ez = { }
	ex[0], ey[0], ez[0] = entity.hitbox_position(enemy, 1)
	ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
	ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
	ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
	ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
	ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
	ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
	local bestdamage = 0
	local bent = nil
	for i=0, 6 do
		local ent, damage = client.trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
		if damage > bestdamage then
			bent = ent
			bestdamage = damage
		end
	end
	return bent == nil and client.scale_damage(me, 1, bestdamage) or bestdamage
end

local function extrapolate_position(xpos,ypos,zpos,ticks,player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	for i=0, ticks do
		xpos =  xpos + (x*globals.tickinterval())
		ypos =  ypos + (y*globals.tickinterval())
		zpos =  zpos + (z*globals.tickinterval())
	end
	return xpos,ypos,zpos
end

local function get_best_enemy()
	best_enemy = nil

	local enemies = entity.get_players(true)
	local best_fov = 180

	local lx, ly, lz = client.eye_position()
	local view_x, view_y, roll = client.camera_angles()
	
	for i=1, #enemies do
		local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
		local cur_fov = math.abs(normalize_yaw(ang_on_screen(lx - cur_x, ly - cur_y) - view_y + 180))
		if cur_fov < best_fov then
			best_fov = cur_fov
			best_enemy = enemies[i]
		end
	end
end

local function get_best_angle()
	local me = entity.get_local_player()

	if best_enemy == nil then return end

	local origin_x, origin_y, origin_z = entity.get_prop(best_enemy, "m_vecOrigin")
	if origin_z == nil then return end
	origin_z = origin_z + 64

	local extrapolated_x, extrapolated_y, extrapolated_z = extrapolate_position(origin_x, origin_y, origin_z, 20, best_enemy)
	
	local lx,ly,lz = client.eye_position()
	local hx,hy,hz = entity.hitbox_position(entity.get_local_player(), 0) 
	local _, head_dmg = client.trace_bullet(best_enemy, origin_x, origin_y, origin_z, hx, hy, hz, true)
			
	if head_dmg ~= nil and head_dmg > 1 then
		brute.can_hit_head = 1
	else
		brute.can_hit_head = 0
	end

	local view_x, view_y, roll = client.camera_angles()
	
	local e_x, e_y, e_z = entity.hitbox_position(best_enemy, 0)

	local yaw = calc_angle(lx, ly, e_x, e_y)
	local rdir_x, rdir_y, rdir_z = angle_vector(0, (yaw + 90))
	local rend_x = lx + rdir_x * 10
	local rend_y = ly + rdir_y * 10
			
	local ldir_x, ldir_y, ldir_z = angle_vector(0, (yaw - 90))
	local lend_x = lx + ldir_x * 10
	local lend_y = ly + ldir_y * 10
			
	local r2dir_x, r2dir_y, r2dir_z = angle_vector(0, (yaw + 90))
	local r2end_x = lx + r2dir_x * 100
	local r2end_y = ly + r2dir_y * 100

	local l2dir_x, l2dir_y, l2dir_z = angle_vector(0, (yaw - 90))
	local l2end_x = lx + l2dir_x * 100
	local l2end_y = ly + l2dir_y * 100      
			
	local ldamage = get_damage(me, best_enemy, rend_x, rend_y, lz)
	local rdamage = get_damage(me, best_enemy, lend_x, lend_y, lz)

	local l2damage = get_damage(me, best_enemy, r2end_x, r2end_y, lz)
	local r2damage = get_damage(me, best_enemy, l2end_x, l2end_y, lz)

	if l2damage > r2damage or ldamage > rdamage or l2damage > ldamage then
		brute.best_angle = 1
	elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
		brute.best_angle = 2
	end
end

--Presets
client.set_event_callback("run_command", function(c)
    ui.set(ref.MainAA.BodyYaw[2], 0)
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and 1 or -1
    if ui.get(menu["Anti-Aimbot"].Presets) == "Preset" then
        ui.set(ref.MainAA.Pitch, "Default")
        ui.set(ref.MainAA.YawBase, "At targets")
        ui.set(ref.MainAA.Yaw[1], "180")
        ui.set(ref.MainAA.EdgeYaw, false)
        if getPlayerState() == "Running" then
            if c.chokedcommands ~= 0 then
            else
            ui.set(ref.MainAA.Yaw[2], 0)
            end
            ui.set(ref.MainAA.YawJitter[1], "Center")
            ui.set(ref.MainAA.YawJitter[2], 25)
            ui.set(ref.MainAA.FakeYawLimit, 60)
            ui.set(ref.MainAA.FreestandingBodyYaw, false) 
            ui.set(ref.MainAA.BodyYaw[1], "Jitter") 
        end
        if getPlayerState() == "Standing" then
            if c.chokedcommands ~= 0 then
            else
            ui.set(ref.MainAA.Yaw[2], side == 1 and -26 or 33)
            end
            ui.set(ref.MainAA.YawJitter[1], "Center")
            ui.set(ref.MainAA.YawJitter[2], 0)
            ui.set(ref.MainAA.FakeYawLimit, 60)
            ui.set(ref.MainAA.FreestandingBodyYaw, false) 
            ui.set(ref.MainAA.BodyYaw[1], "Jitter")
        end
        if getPlayerState() == "Airborne" then
            if c.chokedcommands ~= 0 then
            else
            ui.set(ref.MainAA.Yaw[2], side == 1 and -12 or 12)
            end
            ui.set(ref.MainAA.YawJitter[1], "Center")
            ui.set(ref.MainAA.YawJitter[2], 42)
            ui.set(ref.MainAA.FakeYawLimit, 60)   
            ui.set(ref.MainAA.FreestandingBodyYaw, false)
            ui.set(ref.MainAA.BodyYaw[1], "Jitter")
        end
        if getPlayerState() == "Slow Walking" then
            if c.chokedcommands ~= 0 then
            else
            ui.set(ref.MainAA.Yaw[2], side == 1 and -13 or 9)
            end
            ui.set(ref.MainAA.YawJitter[1], "Center")
            ui.set(ref.MainAA.YawJitter[2], 50)
            ui.set(ref.MainAA.FakeYawLimit, 60)
            ui.set(ref.MainAA.FreestandingBodyYaw, false) 
        end
        if getPlayerState() == "Crouching" then
            if c.chokedcommands ~= 0 then
            else
            ui.set(ref.MainAA.Yaw[2], side == 1 and -10 or 15)
            end
            ui.set(ref.MainAA.YawJitter[1], "Center")
            ui.set(ref.MainAA.YawJitter[2], 75)
            ui.set(ref.MainAA.FakeYawLimit, 58)
            ui.set(ref.MainAA.FreestandingBodyYaw, false) 
        end 
        if getPlayerState() == "Air+Duck" then    
            if c.chokedcommands ~= 0 then
            else
            ui.set(ref.MainAA.Yaw[2], 0)
            end
            ui.set(ref.MainAA.YawJitter[1], "Center")
            ui.set(ref.MainAA.YawJitter[2], 0)
            ui.set(ref.MainAA.FakeYawLimit, 60)   
            ui.set(ref.MainAA.FreestandingBodyYaw, false)
            ui.set(ref.MainAA.BodyYaw[1], "Jitter")
        end
    end
    if ui.get(menu["Anti-Aimbot"].Presets) == "Builder" then
        ui.set(ref.MainAA.Pitch, "Down")
        ui.set(ref.MainAA.YawBase, "At targets")  
        ui.set(ref.MainAA.Yaw[1], "180")
        ActiveState = ConvertStates[ui.get(menu["Anti-Aimbot"].PlayerState)]
        if ui.get(Builder[ActiveStateFunction].Enable) then
            if c.chokedcommands ~= 0 then
            else
            ui.set(ref.MainAA.Yaw[2], (side == 1 and ui.get(Builder[ActiveStateFunction].YawLeft) or ui.get(Builder[ActiveStateFunction].YawRight)))
            end
            ui.set(ref.MainAA.YawJitter[1], ui.get(Builder[ActiveStateFunction].YawJitterMain))
            ui.set(ref.MainAA.YawJitter[2], ui.get(Builder[ActiveStateFunction].YawJitterSlider))
            ui.set(ref.MainAA.BodyYaw[1], ui.get(Builder[ActiveStateFunction].BodyYawMain))
            ui.set(ref.MainAA.FreestandingBodyYaw, ui.get(Builder[ActiveStateFunction].FreestandingBodyYawBuilder))
            if bodyyaw > 0 then
                ui.set(ref.MainAA.FakeYawLimit, ui.get(Builder[ActiveStateFunction].FakeYawLimitRight))
            elseif bodyyaw < 0 then
                ui.set(ref.MainAA.FakeYawLimit, ui.get(Builder[ActiveStateFunction].FakeYawLimitLeft))
            end
        elseif not ui.get(Builder[ActiveStateFunction].Enable) then
            if getPlayerState() == "Running" then
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.MainAA.Yaw[2], side == 1 and -12 or 20)
                end
                ui.set(ref.MainAA.YawJitter[1], "Center")
                ui.set(ref.MainAA.YawJitter[2], 40)
                ui.set(ref.MainAA.FakeYawLimit, 60)
                ui.set(ref.MainAA.FreestandingBodyYaw, false) 
                ui.set(ref.MainAA.BodyYaw[1], "Jitter") 
            end
            if getPlayerState() == "Standing" then
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.MainAA.Yaw[2], side == 1 and -26 or 33)
                end
                ui.set(ref.MainAA.YawJitter[1], "Center")
                ui.set(ref.MainAA.YawJitter[2], 0)
                ui.set(ref.MainAA.FakeYawLimit, 60)
                ui.set(ref.MainAA.FreestandingBodyYaw, false) 
                ui.set(ref.MainAA.BodyYaw[1], "Jitter")
            end
            if getPlayerState() == "Airborne" then
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.MainAA.Yaw[2], side == 1 and -21 or 33)
                end
                ui.set(ref.MainAA.YawJitter[1], "Center")
                ui.set(ref.MainAA.YawJitter[2], 0)
                ui.set(ref.MainAA.FakeYawLimit, 60)   
                ui.set(ref.MainAA.FreestandingBodyYaw, false)
                ui.set(ref.MainAA.BodyYaw[1], "Jitter")
            end
            if getPlayerState() == "Slow Walking" then
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.MainAA.Yaw[2], side == 1 and -13 or 9)
                end
                ui.set(ref.MainAA.YawJitter[1], "Center")
                ui.set(ref.MainAA.YawJitter[2], 50)
                ui.set(ref.MainAA.FakeYawLimit, 60)
                ui.set(ref.MainAA.FreestandingBodyYaw, false) 
            end
            if getPlayerState() == "Crouching" then
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.MainAA.Yaw[2], side == 1 and -10 or 15)
                end
                ui.set(ref.MainAA.YawJitter[1], "Center")
                ui.set(ref.MainAA.YawJitter[2], 75)
                ui.set(ref.MainAA.FakeYawLimit, 58)
                ui.set(ref.MainAA.FreestandingBodyYaw, false) 
            end 
            if getPlayerState() == "Air+Duck" then    
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.MainAA.Yaw[2], side == 1 and 8 or -3)
                end
                ui.set(ref.MainAA.YawJitter[1], "Center")
                ui.set(ref.MainAA.YawJitter[2], 70)
                ui.set(ref.MainAA.FakeYawLimit, 60)   
                ui.set(ref.MainAA.FreestandingBodyYaw, false)
                ui.set(ref.MainAA.BodyYaw[1], "Jitter")
            end
        end
    end
    --Better HideShots
    if ui.get(menu["Anti-Aimbot"].BetterHideShots) and ui.get(ref.Other.OSAA[2]) and not ui.get(ref.Other.FakeDuck) and not ui.get(ref.Other.DT[2]) then
        ui.set(ref["Fake Lag"].FL, 1)
    else
        ui.set(ref["Fake Lag"].FL, 15)
    end
    --Freestanding
    if ui.get(menu["Anti-Aimbot"].Freestanding) then
        ui.set(ref.MainAA.Freestanding[1], "Default")
        ui.set(ref.MainAA.Freestanding[2], "Always on")
    else
        ui.set(ref.MainAA.Freestanding[1], "Default")
        ui.set(ref.MainAA.Freestanding[2], "On hotkey")
    end
    if ui.get(menu["Anti-Aimbot"].EdgeYaw) then
        ui.set(ref.MainAA.EdgeYaw, true)
        ui.set(ref.MainAA.Yaw[2], 0)
        ui.set(ref.MainAA.YawJitter[1], "Off")
        ui.set(ref.MainAA.YawJitter[2], 0)
        ui.set(ref.MainAA.FakeYawLimit, 60)   
        ui.set(ref.MainAA.FreestandingBodyYaw, true)
        ui.set(ref.MainAA.BodyYaw[1], "Static")
        ui.set(ref.MainAA.BodyYaw[2], 0)
    else
        ui.set(ref.MainAA.EdgeYaw, false)
    end
    --Freestanding Options
    if ui.get(menu["Anti-Aimbot"].FreestandingOptions) == "Static" and ui.get(menu["Anti-Aimbot"].Freestanding) then
        ui.set(ref.MainAA.Yaw[2], 0)
        ui.set(ref.MainAA.YawJitter[1], "Off")
        ui.set(ref.MainAA.YawJitter[2], 0)
        ui.set(ref.MainAA.FakeYawLimit, 60)   
        ui.set(ref.MainAA.FreestandingBodyYaw, true)
        ui.set(ref.MainAA.BodyYaw[1], "Static")
        ui.set(ref.MainAA.BodyYaw[2], 0)
    else
        ::skip::
    end
end)

--Legit AA
client.set_event_callback("setup_command", function(e)
	if ui.get(menu["Anti-Aimbot"].LegitAA) then
        local weaponn = entity.get_player_weapon()
		if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
			if e.in_attack == 1 then
				e.in_attack = 0 
				e.in_use = 1
			end
		else
			if e.chokedcommands == 0 then
				e.in_use = 0
			end
		end
	end
end)

--AB Part 2
local function brute_impact(e)
	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local shooter_id = e.userid
	local shooter = client.userid_to_entindex(shooter_id)

	if not entity.is_enemy(shooter) or entity.is_dormant(shooter) then return end

	local lx, ly, lz = entity.hitbox_position(me, "head_0")	
	local ox, oy, oz = entity.get_prop(me, "m_vecOrigin")
	local ex, ey, ez = entity.get_prop(shooter, "m_vecOrigin")
	local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)
	if math.abs(dist) <= 35 and globals.curtime() - brute.last_miss > 0.015 then
		brute.last_miss = globals.curtime()
		if brute.misses[shooter] == nil then
			brute.misses[shooter] = 1 
			brute.misses_ind[shooter] = 1
		elseif brute.misses[shooter] >= 2 then
			brute.misses[shooter] = nil
		else
			brute.misses_ind[shooter] = brute.misses_ind[shooter] + 1
			brute.misses[shooter] = brute.misses[shooter] + 1
		end
	end
end

brute.reset = function()
	brute.fs_side = 0
	brute.last_miss = 0
	brute.best_angle = 0
	brute.misses_ind = { }
	brute.misses = { }
end

local function brute_death(e)
	local victim_id = e.userid
	local victim = client.userid_to_entindex(victim_id)

	if victim ~= entity.get_local_player() then return end

	local attacker_id = e.attacker
	local attacker = client.userid_to_entindex(attacker_id)

	if not entity.is_enemy(attacker) then return end

	if not e.headshot then return end

	if brute.misses[attacker] == nil or (globals.curtime() - brute.last_miss < 0.06 and brute.misses[attacker] == 1) then
		if brute.hit_reverse[attacker] == nil then
			brute.hit_reverse[attacker] = true
		else
			brute.hit_reverse[attacker] = nil
		end
	end
end

--Anti Knife
local function AntiBackStabDistance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

client.set_event_callback("setup_command", function ()
    if ui.get(menu["Anti-Aimbot"].AntiBackStab) then
        local Players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")

        for i=1, #Players do
            local x, y, z = entity.get_prop(Players[i], "m_vecOrigin")
            local Distance = AntiBackStabDistance(lx, ly, lz, x, y, z)
            local Weapon = entity.get_player_weapon(Players[i])
            if entity.get_classname(Weapon) == "CKnife" and Distance <= 200 then
                ui.set(ref.MainAA.Yaw[2],180)
                ui.set(ref.MainAA.Pitch,"Off")
            end
        end
    end
end)

--Indicators
local convars = {
    override = cvar.cl_csm_rot_override,
    x = cvar.cl_csm_rot_x, 
    y = cvar.cl_csm_rot_y, 
    z = cvar.cl_csm_rot_z
}

--The original values of the indicators before sliding them.
local x1 = -14 -- Aura
local x2 = 11 -- Alpha
local x3 = 35 -- Left Arrow
local x4 = 30 -- Right Arrow
local x5 = 20 -- DT
local x6 = 6 -- OSAA
local x7 = 18 --Freestand
local x8 = 6 --FBA
local x9 = 0 --PlayerState

--Animation
client.set_event_callback("paint", function()
    if ui.get(menu.Visuals.IndicatorSelection) == "Default" then
        local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped")
        ui.set(menu.Hide.Aura, 14)
        ui.set(menu.Hide.Alpha, 11)
        ui.set(menu.Hide.LeftArrow, 35)
        ui.set(menu.Hide.RightArrow, 30)
        ui.set(menu.Hide.DT, 20)
        ui.set(menu.Hide.OSAA, 6)
        ui.set(menu.Hide.FS, 18)
        ui.set(menu.Hide.FBA, 6)
        ui.set(menu.Hide.PlayerState, 0)
        if scoped ~= 0 then
            ui.set(menu.Hide.Aura, x1)
            ui.set(menu.Hide.Alpha, x2)
            ui.set(menu.Hide.LeftArrow, x3)
            ui.set(menu.Hide.RightArrow, x4)
            ui.set(menu.Hide.DT, x5)
            ui.set(menu.Hide.OSAA, x6)
            ui.set(menu.Hide.FS, x7)
            ui.set(menu.Hide.FBA, x8)
            ui.set(menu.Hide.PlayerState, x9)
            x1 = require.easing.quad_in(3, x1, -22 - x1, 15) 
            x2 = require.easing.quad_in(3, x2, 47 - x2, 15)
            x3 = require.easing.quad_in(3, x3, -3 - x3, 15)
            x4 = require.easing.quad_in(3, x4, 65 - x4, 15)
            x5 = require.easing.quad_in(3, x5, -16 - x5, 15)
            x6 = require.easing.quad_in(3, x6, -30 - x6, 15)
            x7 = require.easing.quad_in(3, x7, 54 - x7, 15)
            x8 = require.easing.quad_in(3, x8, 42 - x8, 15)
            x9 = require.easing.quad_in(3, x9, -36 - x9, 15)
        elseif scoped ~= 1 then
            ui.set(menu.Hide.Aura, x1)
            ui.set(menu.Hide.Alpha, x2)
            ui.set(menu.Hide.LeftArrow, x3)
            ui.set(menu.Hide.RightArrow, x4)
            ui.set(menu.Hide.DT, x5)
            ui.set(menu.Hide.OSAA, x6)
            ui.set(menu.Hide.FS, x7)
            ui.set(menu.Hide.FBA, x8)
            ui.set(menu.Hide.PlayerState, x9)
            x1 = require.easing.quad_in(3, x1, 15 - x1, 15)
            x2 = require.easing.quad_in(3, x2, 12 - x2, 15)
            x3 = require.easing.quad_in(3, x3, 36 - x3, 15)
            x4 = require.easing.quad_in(3, x4, 31 - x4, 15)
            x5 = require.easing.quad_in(3, x5, 20 - x5, 15)
            x6 = require.easing.quad_in(3, x6, 6 - x6, 15)
            x7 = require.easing.quad_in(3, x7, 19 - x7, 15)
            x8 = require.easing.quad_in(3, x8, 7 - x8, 15)
            x9 = require.easing.quad_in(3, x9, 0 - x9, 15)
        end
    end
end)

local materials = { "dev/blurfiltery_nohdr", "dev/engine_post", "overlays/scope_lens" }

client.set_event_callback("paint", function ()
    --ScreenSize
    local screen = {client.screen_size()}
    local center = {screen[1]/2, screen[2]/2}
    --Colors
    local CLR1 = {ui.get(menu.Colors.Color1)}
    local CLR2 = {ui.get(menu.Colors.Color2)}
    local CLR3 = {ui.get(menu.Colors.Color3)}
    local CLR4 = {ui.get(menu.Colors.Color4)}
    local CLR5 = {ui.get(menu.Colors.Color5)}
    local CLR6 = {ui.get(menu.Colors.Color6)}
    local CLR7 = {ui.get(menu.Colors.PlayerStateColor)}
    --Body Yaw
    local body_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    --Desync Angle 
    local DetermineDesync = math.floor(math.min(58, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60)))
    --Alpha Fade
    local alpha = math.sin(math.abs((math.pi * -1) + (globals.curtime() * 1.5) % (math.pi * 2))) * 255

    if ui.get(menu.Visuals.Indicators) and ui.get(menu.Visuals.IndicatorSelection) == "Default" then
        if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
        renderer.text(center[1] - ui.get(menu.Hide.Aura), center[2] + 40, CLR1[1], CLR1[2], CLR1[3], 255, "-c", nil, "AURA")
        renderer.text(center[1] + ui.get(menu.Hide.Alpha), center[2] + 40, CLR2[1], CLR2[2], CLR2[3], alpha, "-c", nil, obex_data.build:upper())
        renderer.text(center[1] - ui.get(menu.Hide.PlayerState), center[2] + 50,  CLR7[1], CLR7[2], CLR7[3], 255, "-c", nil, getPlayerState():upper())
        renderer.text(center[1] - ui.get(menu.Hide.LeftArrow), center[2] + 33, CLR3[1], CLR3[2], CLR3[3], 100, "b", nil, "<")
        renderer.text(center[1] + ui.get(menu.Hide.RightArrow), center[2] + 33, CLR3[1], CLR3[2], CLR3[3], 100, "b", nil, ">")
        if body_yaw > 0 then
            renderer.text(center[1] - ui.get(menu.Hide.LeftArrow), center[2] + 33, CLR3[1], CLR3[2], CLR3[3], 255, "b", nil, "<")
        else
            renderer.text(center[1] + ui.get(menu.Hide.RightArrow), center[2] + 33, CLR3[1], CLR3[2], CLR3[3], 255, "b", nil, ">")
        end
        if ui.get(ref.Other.DT[2]) then
            renderer.text(center[1] - ui.get(menu.Hide.DT), center[2] + 60, CLR4[1], CLR4[2], CLR4[3], 255, "-c", nil, "DT")
        else
            renderer.text(center[1] - ui.get(menu.Hide.DT), center[2] + 60, CLR5[1], CLR5[2], CLR5[3], 140, "-c", nil, "DT")
        end
        if ui.get(ref.Other.OSAA[2]) then
            renderer.text(center[1] - ui.get(menu.Hide.OSAA), center[2] + 60, CLR4[1], CLR4[2], CLR4[3], 255, "-c", nil, "HS")
        else
            renderer.text(center[1] - ui.get(menu.Hide.OSAA), center[2] + 60, CLR5[1], CLR5[2], CLR5[3], 140, "-c", nil, "HS")
        end
        if ui.get(menu["Anti-Aimbot"].Freestanding) then
            renderer.text(center[1] + ui.get(menu.Hide.FS), center[2] + 60, CLR4[1], CLR4[2], CLR4[3], 255, "-c", nil, "FS")
        else
            renderer.text(center[1] + ui.get(menu.Hide.FS), center[2] + 60, CLR5[1], CLR5[2], CLR5[3], 140, "-c", nil, "FS")
        end
        if ui.get(ref.Other.FBA) then
            renderer.text(center[1] + ui.get(menu.Hide.FBA), center[2] + 60, CLR4[1], CLR4[2], CLR4[3], 255, "-c", nil, "FB")
        else
            renderer.text(center[1] + ui.get(menu.Hide.FBA), center[2] + 60, CLR5[1], CLR5[2], CLR5[3], 140, "-c", nil, "FB")
        end
    elseif ui.get(menu.Visuals.Indicators) and ui.get(menu.Visuals.IndicatorSelection) == "Alternate" then
        if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
        renderer.text(center[1] - 11, center[2] + 30, CLR1[1], CLR1[2], CLR1[3], 255,  "-c", nil, "AURA")
        renderer.text(center[1] + 15, center[2] + 30, CLR2[1], CLR2[2], CLR2[3], alpha, "-c", nil, obex_data.build:upper())
        renderer.text(center[1] - 2, center[2] + 39, 120, 169, 255, 255, "-c", nil, "FAKE   YAW:")
        if body_yaw > 0 then
            renderer.text(center[1] + 22, center[2] + 39, CLR1[1], CLR1[2], CLR1[3], CLR1[4], "-c", 0, "L")
        else
            renderer.text(center[1] + 22, center[2] + 39, CLR1[1], CLR1[2], CLR1[3], CLR1[4], "-c", 0, "R")
        end
        if ui.get(ref.Other.FBA) then
            renderer.text(center[1] - 12, center[2] + 48, CLR4[1], CLR4[2], CLR4[3], alpha, "-c", nil, "BAIM")
        else
            renderer.text(center[1] - 12, center[2] + 48, CLR5[1], CLR5[2], CLR5[3], 170, "-c", nil, "BAIM")
        end
        if ui.get(ref.Other.FSP) then
            renderer.text(center[1] + 4, center[2] + 48, CLR4[1], CLR4[2], CLR4[3], alpha, "-c", nil, "SP")
        else
            renderer.text(center[1] + 4, center[2] + 48, CLR5[1], CLR5[2], CLR5[3], 170, "-c", nil, "SP")
        end
        if ui.get(menu["Anti-Aimbot"].Freestanding) then
            renderer.text(center[1] + 15, center[2] + 48, CLR4[1], CLR4[2], CLR4[3], alpha, "-c", nil, "FS")
        else
            renderer.text(center[1] + 15, center[2] + 48, CLR5[1], CLR5[2], CLR5[3], 170, "-c", nil, "FS")
        end  
    elseif ui.get(menu.Visuals.Indicators) and ui.get(menu.Visuals.IndicatorSelection) == "Ideal Yaw" then
        if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
        renderer.text(center[1] - 25, center[2] + 30, 215, 114, 44, 255, nil, 0, "AURA " .. obex_data.build:upper())
        renderer.text(center[1] - 25, center[2] + 40, 209, 139, 230, 255, nil, 0, "DYNAMIC")
        if ui.get(ref.Other.DT[2]) then
            renderer.text(center[1] - 25, center[2] + 50, CLR4[1], CLR4[2], CLR4[3], 255, nil, 0, "DT")
        else
            renderer.text(center[1] - 25, center[2] + 50, CLR5[1], CLR5[2], CLR5[3], 140, nil, 0, "DT")
        end
        if ui.get(ref.Other.OSAA[2]) then
            renderer.text(center[1] - 10, center[2] + 50, CLR4[1], CLR4[2], CLR4[3], 255, nil, 0, "HS")
        else
            renderer.text(center[1] - 10, center[2] + 50, CLR5[1], CLR5[2], CLR5[3], 140, nil, 0, "HS")
        end
        if ui.get(menu["Anti-Aimbot"].Freestanding) then
            renderer.text(center[1] + 5, center[2] + 50, CLR4[1], CLR4[2], CLR4[3], 255, nil, 0, "FS")
        else
            renderer.text(center[1] + 5, center[2] + 50, CLR5[1], CLR5[2], CLR5[3], 140, nil, 0, "FS")
        end
    end
    --Watermark
    if ui.get(menu.Visuals.EnableVisuals) and ui.get(menu.Visuals.Watermark) then
        --Determine Latency and Time and Final Result
        local Latency = math.floor(client.latency()*1000+0.5)
        local Hours, Minutes = client.system_time()
        local Text = string.format("%02d:%02d", Hours, Minutes)
        local render = string.format("aura ~ " .. obex_data.build .. " | user: " .. obex_data.username .. " | latency: " .. Latency .. " | "  .. Text .. "")

        renderer.text(center[1] + 830, center[2] - 510, 255, 255, 255, 255, "c", nil, render)
    end
    --Status Indicator
    if ui.get(menu.Visuals.StatusIndicator) then
        if ui.is_menu_open() and client.key_state(0x01) and ui.get(menu.Visuals.EnableDrag) then
            Pos = {ui.mouse_position()}
            ui.set(menu.Hide.Status_X, Pos[1])
            ui.set(menu.Hide.Status_Y, Pos[2])
        elseif not ui.is_menu_open() then
            ui.set(menu.Visuals.EnableDrag, false)
        end
        --Current Threat
        local threat = client.current_threat()
        local threat_name = entity.get_player_name(threat)

        renderer.text(ui.get(menu.Hide.Status_X), ui.get(menu.Hide.Status_Y), 255, 255, 255, 255,  "d", nil, "> aura.lua - antiaim script")
        renderer.text(ui.get(menu.Hide.Status_X), ui.get(menu.Hide.Status_Y) + 10, 255, 255, 255, 255,  "d", nil, "> user: " .. obex_data.username)
        renderer.text(ui.get(menu.Hide.Status_X), ui.get(menu.Hide.Status_Y) + 20, 255, 255, 255, 255,  "d", nil, "> build ver: " .. obex_data.build)
        renderer.text(ui.get(menu.Hide.Status_X), ui.get(menu.Hide.Status_Y) + 30, 255, 255, 255, 255,  "d", nil, "> player state: " .. getPlayerState())
        renderer.text(ui.get(menu.Hide.Status_X), ui.get(menu.Hide.Status_Y) + 40, 255, 255, 255, 255,  "d", nil, "> current enemy: " .. threat_name)
        renderer.text(ui.get(menu.Hide.Status_X), ui.get(menu.Hide.Status_Y) + 50, 255, 255, 255, 255,  "d", nil, "> current desync: " .. DetermineDesync)
    end
    --Sunset Mode
    if ui.get(menu.Visuals.SunSetMode) then
        local localplayer = entity.get_local_player()
        local weapon = entity.get_player_weapon(localplayer)
    
        if weapon == nil then return end
    
        for i, v in pairs(materials) do
            local material = materialsystem.find_material(v)
            if material ~= nil then material:set_material_var_flag(2, ui.get(menu.Visuals.SunSetMode) and entity.get_prop(localplayer, "m_bIsScoped") ~= 0 and entity.get_prop(weapon, "m_zoomLevel") ~= 0) end
        end

        ui.set(ref.Other.PostProccessing, false)
        convars.override:set_int(1)
        convars.x:set_int(ui.get(170))
        convars.y:set_int(ui.get(0))
        convars.z:set_int(ui.get(0))
    else
        for i, v in pairs(materials) do
            local material = materialsystem.find_material(v)
            if material ~= nil then material:reload() end
        end

        ui.set(ref.Other.PostProccessing, true)
        convars.override:set_int(0)
    end
    if ui.get(ref.Other.OSAA[2]) and not ui.get(ref.Other.DT[2]) then
        renderer.indicator(255, 255, 255, 255, "OSAA")
    end
end)

--Contains Function
local function contains(table, value)
	if table == nil then
		return false
	end
	
    table = ui.get(table)
    for i=0, #table do
        if table[i] == value then
            return true
        end
    end
    return false
end

--Animation Breakers
local ground_ticks, end_time = 1, 0
client.set_event_callback("pre_render", function()
    if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
    
    if ui.get(menu.Visuals.EnableVisuals) then
        if contains(menu.Visuals.BreakAnims, "Static Legs in Air") then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
        end
        if contains(menu.Visuals.BreakAnims, "0 Pitch on Land") then
            if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
            local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
            if on_ground == 1 then
                ground_ticks = ground_ticks + 1
            else
                ground_ticks = 0
                end_time = globals.curtime() + 1
            end
            if ground_ticks > ui.get(ref["Fake Lag"].FL)+1 and end_time > globals.curtime() then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
            end
        end
    end
end)

local LegMovement = {
    [1] = "Off",
    [2] = "Always slide",
    [3] = "Never slide"
}

client.set_event_callback("run_command", function()
    if ui.get(menu.Visuals.EnableVisuals) and contains(menu.Visuals.BreakAnims, "Leg Movement Breaker") then
        ui.set(ref.Other.LegMovement, LegMovement[client.random_int(2,3)] or "Off")
    end
end)

--Callbacks
client.set_event_callback("bullet_impact", function(e)
    brute_impact(e)
end)

client.set_event_callback("player_death", function(e)
    brute_death(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        brute.reset()
    end
end)

client.set_event_callback("round_start", function()
    brute.reset()
    local me = entity.get_local_player()
    if not entity.is_alive(me) then return end
end)

client.set_event_callback("client_disconnect", function()
    brute.reset()
end)

client.set_event_callback("game_newmap", function()
    brute.reset()
end)

client.set_event_callback("cs_game_disconnected", function()
    brute.reset()
end)