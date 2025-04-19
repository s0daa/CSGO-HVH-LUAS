-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
client.exec("playvol \"survival/buy_item_01.wav\" 1")

--"Contains" thing for Multi-Selects
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

--Requirements
local require = {
    antiaim_funcs = require "gamesense/antiaim_funcs",
    easing = require "gamesense/easing",
    chat = require "gamesense/chat",
    clipboard = require "gamesense/clipboard",
    vector = require("vector")
}

--References
local ref = {
	Enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	Pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
	YawBase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    Yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    YawJitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    BodyYaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
	FakeYawLimit = ui.reference("AA", "Anti-aimbot angles", "Fake Yaw limit"),
    FreestandingBodyYaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body Yaw"),
    Roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
	EdgeYaw = ui.reference("AA", "Anti-aimbot angles", "Edge Yaw"),
	Freestanding = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
	SlowMotion = { ui.reference("AA", "Other", "Slow motion") },
    FakeDuck = ui.reference("Rage", "Other", "Duck peek assist"),
    FLEnable = { ui.reference("AA", "Fake lag", "Enabled") },
    FL = ui.reference("AA", "Fake lag", "Limit"),
    FLAmmount = ui.reference("AA", "Fake lag", "Amount"),
    FLVariance = ui.reference("AA", "Fake lag", "Variance"),
    FBA = ui.reference("Rage", "Other", "Force body aim"),
    FSP = ui.reference("Rage", "Aimbot", "Force safe point"),
    DT = {ui.reference("Rage", "Other", "Double tap")},
    DTFL = ui.reference("Rage", "Other", "Double tap fake lag limit"),
    OSAA = {ui.reference("AA", "Other", "On shot anti-aim")},
    LegMovement = ui.reference("AA", "Other", "Leg movement"),
    MaxTicks = ui.reference("Misc", "Settings", "sv_maxusrcmdprocessticks"),
    ClanTag = ui.reference("Misc", "Miscellaneous", "Clan tag spammer"),
}

--GUI
local menu = {
    MasterCheck = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFEnable \aDC143CFFAura.Lua"),
    MenuLabel = ui.new_label("AA", "Anti-Aimbot angles", "\aFFFFFFFFWelcome To \aDC143CFFAura.Lua\aFFFFFFFF!"),
    TabSelector = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFTab Selector", {"-", "Anti-Aim", "Visuals", "Misc", "Colors"}),
--Other Tab
    WelcomeLabel1 = ui.new_label("AA", "Anti-Aimbot angles", "\aDC143CFFAura.Lua | \aFFFFFFFFAlpha"),
    WelcomeLabel2 = ui.new_label("AA", "Anti-Aimbot angles", "\aFFFFFFFFDeveloped By DavidDD"),
--Anti-Aim Tab
    EnableAA = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFF[\aDC143CFFAURA\aFFFFFFFF] Enable Anti-Aim"),
    AntiAimSelector = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFAnti-Aim Selector", {"Preset AA", "Legit AA", "Anti-Aim Builder"}),
    AntiBackStab = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFAnti-Backstab"),
    AntiBSRange = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFAnti-Backstab Range", 100, 300, 200),
    StaticRollCheck = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFStatic Roll"),
    StaticRoll = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFRoll Amount", -50,50,0),
    DynamicRoll = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFDynamic Roll"),
    ManualCheck = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFEnable Manual AA"),
    ManualLeft = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFManual Left", false),
    ManualBack = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFManual Back", false),
    ManualRight = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFManual Right", false),
    LegitAA = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFLegit AA on Key", false, 0x45),
    PlayerState = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFBuilder Player State", {"Crouching", "Standing", "Moving", "In-Air", "In-Air Crouch", "Slow Walking", "Fake Lag", "Fake Duck", "Freestanding"}),
--Misc Tab
    EnableMisc = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFF[\aDC143CFFAURA\aFFFFFFFF] Enable Misc"),
    ClanTag = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFClantag Spammer"),
    ShotLogger = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFShot Logger"),
    FLBreaker = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFDynamic Fake Lag"),
    DisableFL = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFDisable Fake Lag on HideShots"),
    Exceptions = ui.new_multiselect("AA", "Anti-aimbot angles", "\aFFFFFFFFExcept When:", {"In-Air", "Moving", "Standing", "Crouching"}),
    IdealTick = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFIdeal Tick"),
    Freestanding = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFFreestanding"),
    EdgeYaw = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFEdge Yaw"),
    ForceRoll = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFForce Roll"),
    DTSpeed = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFIncrease DT Speed", {"Default", "Fast", "Aura"}),
    ClockCorrection = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFDisable Clock Correction"),
--Visuals Tab
    EnableVisuals = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFF[\aDC143CFFAURA\aFFFFFFFF] Enable Visuals"),
    Indicators = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFIndicators"),
    IndicatorSelection = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFCrosshair Indicator Selection", {"Normal", "Alternative", "Ideal Yaw"}),
    AAArrows = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFAnti-Aim Arrows"),
    SlideIndicator = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFMove Indicator on Scope"),
    Watermark = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFWatermark"),
    AnimationStuff = ui.new_multiselect("AA", "Anti-aimbot angles", "\aFFFFFFFFBreak Animations", {"Static Legs", "Zero Pitch on Land", "Leg Breaker"}),
--Colors Tab
    OverrideColors = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFF[\aDC143CFFAURA\aFFFFFFFF] Override Default Colors"),
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
    Color6 = ui.new_color_picker("AA", "Anti-aimbot angles", "\aFFFFFFFFWatermark Color", 220, 20, 60, 255),
}

--PlayerState Function
local flags = {
    FL_ONGROUND = bit.lshift(1, 0);
    FL_DUCKING = bit.lshift(1, 1);
}

local getPlayerState = function()
    local getVelocity = math.floor(require.vector(entity.get_prop(entity.get_local_player(), "m_vecVelocity")):length2d() + 0.5)
    local getFlags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    local isSlowWalking = ui.get(ref.SlowMotion[2])
    local isFreeStanding = ui.get(menu.Freestanding)
    local isFakeDucking = ui.get(ref.FakeDuck)
    local isRolling = ui.get(menu.ForceRoll)
    local isExploting = ui.get(ref.DT[2]) or ui.get(ref.OSAA[2])
    if isFreeStanding then
        return "freestand"
    elseif isFakeDucking then
        return "fakeduck"
    elseif isRolling then
        return "force-roll"
    elseif not isExploting then
        return "fakelag"
    elseif (bit.band(getFlags, flags.FL_DUCKING ) ~= 0 and bit.band(getFlags, flags.FL_ONGROUND) == 1) then
        return "crouching"
    elseif (bit.band(getFlags, flags.FL_ONGROUND) == 1 and getVelocity <= 2 and not isSlowWalking) then
        return "standing"
    elseif (bit.band(getFlags, flags.FL_ONGROUND) == 1 and getVelocity >= 2 and not isSlowWalking) then
        return "moving"
    elseif (bit.band(getFlags, flags.FL_ONGROUND) ~= 1) and client.key_state(0x11) then
        return "in-air [c]"
    elseif (bit.band(getFlags, flags.FL_ONGROUND) ~= 1) then
        return "in-air"
    elseif (bit.band(getFlags, flags.FL_ONGROUND) == 1 and isSlowWalking) then
        return "slowwalk"
    end
end

--Anti-Aim Builder
local Builder = { }
local States = {"Crouching", "Standing", "Moving", "In-Air", "In-Air Crouch", "Slow Walking", "Fake Lag", "Fake Duck", "Freestanding"}
local ConvertStates = {["Crouching"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["In-Air"] = 4, ["In-Air Crouch"] = 5, ["Slow Walking"] = 6, ["Fake Lag"] = 7,  ["Fake Duck"] = 8, ["Freestanding"] = 9}

local function StatesThing()
    if getPlayerState() == "crouching" then
        ActiveStateFunction = 1
    elseif getPlayerState() == "standing" then
        ActiveStateFunction = 2
    elseif getPlayerState() == "moving" then
        ActiveStateFunction = 3
    elseif getPlayerState() == "in-air [c]" then
        ActiveStateFunction = 5
    elseif getPlayerState() == "in-air" then
        ActiveStateFunction = 4
    elseif getPlayerState() == "slowwalk" then
        ActiveStateFunction = 6
    elseif getPlayerState() == "fakelag" then
        ActiveStateFunction = 7
    elseif getPlayerState() == "fakeduck" then
        ActiveStateFunction = 8
    elseif getPlayerState() == "freestand" then
        ActiveStateFunction = 9
    end
end

for i = 1, 9 do
    Builder[i] = {
        Enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFEnable " .. States[i] .. " State Override"),
        YawLeft = ui.new_slider("AA", "Anti-aimbot angles", "Yaw Left\n" .. States[i], -180, 180, 0),
        YawRight = ui.new_slider("AA", "Anti-aimbot angles", "Yaw Right\n" .. States[i], -180, 180, 0),
        YawJitterMain = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFYaw Jitter\n" .. States[i], {"Off", "Offset", "Center", "Random"}),
        YawJitterSlider = ui.new_slider("AA", "Anti-aimbot angles", "\nYaw Jitter" .. States[i], -180, 180, 0),
        BodyYawMain = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFBody Yaw\n" .. States[i], {"Opposite", "Jitter", "Static"}),
        BodyYawSlider = ui.new_slider("AA", "Anti-aimbot angles", "\nBody Yaw\n".. States[i], -180, 180, 0),
        FreestandingBodyYawBuilder = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFFreestanding Body Yaw\n" .. States[i]),
        FakeYawLimitLeft = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFFake Yaw Limit Left\n" .. States[i], 0, 60, 60),
        FakeYawLimitRight = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFFake Yaw Limit Right\n" .. States[i], 0, 60, 60),
        EnableAntiBrute = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFEnable " .. States[i] .. " Anti-Brute"),
    }
end

--Anti-Aim Preset + Builder
local LeftOff = false
local BackOff = false
local RightOff = false
local Manual = "back"

client.set_event_callback("setup_command", function(c)
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and 1 or -1
    if ui.get(menu.EnableAA) then
        ui.set(ref.Enabled, true)
    else
        ui.set(ref.Enabled, false)
    end
    --Preset
    if ui.get(menu.MasterCheck) and ui.get(menu.EnableAA) then
        if ui.get(menu.AntiAimSelector) == "Preset AA" then
            ui.set(ref.Pitch, "Default")
            ui.set(ref.YawBase, "At targets")
            ui.set(ref.Yaw[1], "180")
            if getPlayerState() == "moving" then
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.Yaw[2], side == 1 and -12 or 20)
                end
                ui.set(ref.YawJitter[1], "Center")
                ui.set(ref.YawJitter[2], 40)
                ui.set(ref.FakeYawLimit, 60)
                ui.set(ref.FreestandingBodyYaw, false) 
                ui.set(ref.BodyYaw[1], "Jitter") 
            end
            if getPlayerState() == "standing" then
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.Yaw[2], side == 1 and -26 or 33)
                end
                ui.set(ref.YawJitter[1], "Center")
                ui.set(ref.YawJitter[2], 0)
                ui.set(ref.FakeYawLimit, 60)
                ui.set(ref.FreestandingBodyYaw, false) 
                ui.set(ref.BodyYaw[1], "Jitter")
            end
            if getPlayerState() == "in-air" then
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.Yaw[2], side == 1 and -21 or 33)
                end
                ui.set(ref.YawJitter[1], "Center")
                ui.set(ref.YawJitter[2], 0)
                ui.set(ref.FakeYawLimit, 60)   
                ui.set(ref.FreestandingBodyYaw, false)
                ui.set(ref.BodyYaw[1], "Jitter")
            end
            if getPlayerState() == "slowwalk" then
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.Yaw[2], side == 1 and -13 or 9)
                end
                ui.set(ref.YawJitter[1], "Center")
                ui.set(ref.YawJitter[2], 50)
                ui.set(ref.FakeYawLimit, 60)
                ui.set(ref.FreestandingBodyYaw, false) 
            end
            if getPlayerState() == "crouching" then
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.Yaw[2], side == 1 and -10 or 15)
                end
                ui.set(ref.YawJitter[1], "Center")
                ui.set(ref.YawJitter[2], 75)
                ui.set(ref.FakeYawLimit, 58)
                ui.set(ref.FreestandingBodyYaw, false) 
            end 
            if getPlayerState() == "in-air [c]" then    
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.Yaw[2], side == 1 and 8 or -3)
                end
                ui.set(ref.YawJitter[1], "Center")
                ui.set(ref.YawJitter[2], 70)
                ui.set(ref.FakeYawLimit, 60)   
                ui.set(ref.FreestandingBodyYaw, false)
                ui.set(ref.BodyYaw[1], "Jitter")
            end
        end
        --AA Builder
        if ui.get(menu.AntiAimSelector) == "Anti-Aim Builder" then
            ui.set(ref.Pitch, "Down")
            ui.set(ref.YawBase, "At targets")  
            ui.set(ref.Yaw[1], "180")
            ActiveState = ConvertStates[ui.get(menu.PlayerState)]
            if ui.get(Builder[ActiveStateFunction].Enable) then
                if c.chokedcommands ~= 0 then
                else
                ui.set(ref.Yaw[2], (side == 1 and ui.get(Builder[ActiveStateFunction].YawLeft) or ui.get(Builder[ActiveStateFunction].YawRight)))
                end
                ui.set(ref.YawJitter[1], ui.get(Builder[ActiveStateFunction].YawJitterMain))
                ui.set(ref.YawJitter[2], ui.get(Builder[ActiveStateFunction].YawJitterSlider))
                ui.set(ref.BodyYaw[1], ui.get(Builder[ActiveStateFunction].BodyYawMain))
                ui.set(ref.BodyYaw[2], ui.get(Builder[ActiveStateFunction].BodyYawSlider))
                ui.set(ref.FreestandingBodyYaw, ui.get(Builder[ActiveStateFunction].FreestandingBodyYawBuilder))
                if bodyyaw > 0 then
                    ui.set(ref.FakeYawLimit, ui.get(Builder[ActiveStateFunction].FakeYawLimitRight))
                elseif bodyyaw < 0 then
                    ui.set(ref.FakeYawLimit, ui.get(Builder[ActiveStateFunction].FakeYawLimitLeft))
                end
            elseif not ui.get(Builder[ActiveStateFunction].Enable) then
                if getPlayerState() == "moving" then
                    if c.chokedcommands ~= 0 then
                    else
                    ui.set(ref.Yaw[2], side == 1 and -12 or 20)
                    end
                    ui.set(ref.YawJitter[1], "Center")
                    ui.set(ref.YawJitter[2], 40)
                    ui.set(ref.FakeYawLimit, 60)
                    ui.set(ref.FreestandingBodyYaw, false) 
                    ui.set(ref.BodyYaw[1], "Jitter") 
                end
                if getPlayerState() == "standing" then
                    if c.chokedcommands ~= 0 then
                    else
                    ui.set(ref.Yaw[2], side == 1 and -26 or 33)
                    end
                    ui.set(ref.YawJitter[1], "Center")
                    ui.set(ref.YawJitter[2], 0)
                    ui.set(ref.FakeYawLimit, 60)
                    ui.set(ref.FreestandingBodyYaw, false) 
                    ui.set(ref.BodyYaw[1], "Jitter")
                end
                if getPlayerState() == "in-air" then
                    if c.chokedcommands ~= 0 then
                    else
                    ui.set(ref.Yaw[2], side == 1 and -21 or 33)
                    end
                    ui.set(ref.YawJitter[1], "Center")
                    ui.set(ref.YawJitter[2], 0)
                    ui.set(ref.FakeYawLimit, 60)   
                    ui.set(ref.FreestandingBodyYaw, false)
                    ui.set(ref.BodyYaw[1], "Jitter")
                end
                if getPlayerState() == "slowwalk" then
                    if c.chokedcommands ~= 0 then
                    else
                    ui.set(ref.Yaw[2], side == 1 and -13 or 9)
                    end
                    ui.set(ref.YawJitter[1], "Center")
                    ui.set(ref.YawJitter[2], 50)
                    ui.set(ref.FakeYawLimit, 60)
                    ui.set(ref.FreestandingBodyYaw, false) 
                end
                if getPlayerState() == "crouching" then
                    if c.chokedcommands ~= 0 then
                    else
                    ui.set(ref.Yaw[2], side == 1 and -10 or 15)
                    end
                    ui.set(ref.YawJitter[1], "Center")
                    ui.set(ref.YawJitter[2], 75)
                    ui.set(ref.FakeYawLimit, 58)
                    ui.set(ref.FreestandingBodyYaw, false) 
                end 
                if getPlayerState() == "in-air [c]" then    
                    if c.chokedcommands ~= 0 then
                    else
                    ui.set(ref.Yaw[2], side == 1 and 8 or -3)
                    end
                    ui.set(ref.YawJitter[1], "Center")
                    ui.set(ref.YawJitter[2], 70)
                    ui.set(ref.FakeYawLimit, 60)   
                    ui.set(ref.FreestandingBodyYaw, false)
                    ui.set(ref.BodyYaw[1], "Jitter")
                end
            end
        end
        --Legit Preset
        if ui.get(menu.AntiAimSelector) == "Legit" then
            ui.set(ref.Pitch, "Off")
            ui.set(ref.YawBase, "Local view")
            ui.set(ref.Yaw[1], "180")
            ui.set(ref.Yaw[2], 180)
            ui.set(ref.YawJitter[1], "Off")
            ui.set(ref.BodyYaw[1], "Opposite")
            ui.set(ref.BodyYaw[2], 180)
            ui.set(ref.FakeYawLimit, 60)
            ui.set(ref.FreestandingBodyYaw, true)
        end
        --Force Roll
        if ui.get(menu.EnableAA) and ui.get(menu.ForceRoll) then
            ui.set(ref.Pitch, "Down")
            ui.set(ref.YawBase, "At targets")
            ui.set(ref.Yaw[1], "180")
            ui.set(ref.Yaw[2], 0)
            ui.set(ref.YawJitter[1], "Center")
            ui.set(ref.YawJitter[2], 0)
            ui.set(ref.BodyYaw[1], "Static")
            ui.set(ref.BodyYaw[2], 141)
            ui.set(ref.FakeYawLimit, 60)   
            ui.set(ref.FreestandingBodyYaw, true)
        end
    end
    --Manual AA
    if ui.get(menu.ManualCheck) then
        if ui.get(menu.ManualBack) then
            Mode = "Back"
        elseif ui.get(menu.ManualLeft) and LeftOff then
            if Mode == "Left" then
                Mode = "Back"
            else
                Mode = "Left"
            end
        elseif ui.get(menu.ManualRight) and RightOff then
            if Mode == "Right" then
                Mode = "Back"
            else
                Mode = "Right"
            end
        end
        if ui.get(menu.ManualLeft) == false then
            LeftOff = true
        end
        if ui.get(menu.ManualRight) == false then
            RightOff = true
        end
        if Mode == "Back" then
            ui.set(ref.Yaw[2], 0)
        elseif Mode == "Left" then
            ui.set(ref.Yaw[2], -90)
        elseif Mode == "Right" then
            ui.set(ref.Yaw[2], 90)
        end
    end
    if ui.get(menu.EnableMisc) and ui.get(menu.Freestanding) then
        ui.set(ref.Freestanding[1], {"Default"})
        ui.set(ref.Freestanding[2], "Always on")
    elseif not ui.get(menu.Freestanding) then
        ui.set(ref.Freestanding[1], {})
        ui.set(ref.Freestanding[2], "On hotkey")
    end 
    if ui.get(menu.IdealTick) then
        ui.set(ref.FL, 1)
        ui.set(ref.DT[2], "Always on")
    else
        ui.set(ref.FL, 15)
        ui.set(ref.DT[2], "Toggle")
    end
    if ui.get(menu.EnableMisc) and ui.get(menu.EdgeYaw) then
        ui.set(ref.EdgeYaw, true)
    else
        ui.set(ref.EdgeYaw, false)
    end
end)

--Import/Export
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

local export_btn = ui.new_button("AA", "Anti-aimbot angles", "Export \aDC143CFFAura Builder \aFFFFFFC9Settings", export_config)

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

local import_btn = ui.new_button("AA", "Anti-aimbot angles", "Import \aDC143CFFAura Builder \aFFFFFFC9Settings", import_config)

--Legit AA
client.set_event_callback("setup_command",function(e)
    local weaponn = entity.get_player_weapon()
    
    if not ui.get(menu.EnableAA) and not ui.get(menu.LegitAA) then
        return
    end

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
end)

--Leg Breaker 
local LegMovement = {
    [1] = "Off",
    [2] = "Always slide",
    [3] = "Never slide"
}

client.set_event_callback("run_command", function()
    if ui.get(menu.EnableVisuals) and contains(menu.AnimationStuff, "Leg Breaker") then
        ui.set(ref.LegMovement, LegMovement[client.random_int(2,3)] or "Off")
    end
end)

--Random Roll 
client.set_event_callback("run_command", function ()
    if ui.get(menu.EnableAA) and ui.get(menu.DynamicRoll) then
        ui.set(menu.StaticRollCheck, false)
        ui.set(ref.Roll, math.random(-50, 50))
    end
end)

--Roll Angle
local function StaticRoll()
    if ui.get(menu.EnableAA) and ui.get(menu.StaticRollCheck) then
        ui.set(ref.Roll, ui.get(menu.StaticRoll))
        ui.set(menu.DynamicRoll, false)
    end
    if not ui.get(menu.StaticRollCheck) or ui.get(menu.DynamicRoll) then
        ui.set(ref.Roll, 0)
    end
end

--Force Roll
local function Roll(cmd)
    if ui.get(menu.EnableMisc) and ui.get(menu.ForceRoll) then
        cmd.roll = 50
        ui.set(ref.Roll, 0)
    end
end

--Disable FL
local function DisableFL()
    if ui.get(menu.DisableFL) and ui.get(ref.OSAA[2]) and not ui.get(ref.FakeDuck) and not ui.get(ref.DT[2]) then
        ui.set(ref.FL, 1)
    else
        ui.set(ref.FL, 15)
    end
    if contains(menu.Exceptions, "In-Air") and getPlayerState() == "in-air" then
        ui.set(ref.FL, 15)
    end
    if contains(menu.Exceptions, "Moving") and getPlayerState() == "moving" then
        ui.set(ref.FL, 15)
    end
    if contains(menu.Exceptions, "Standing") and getPlayerState() == "standing" then
        ui.set(ref.FL, 15)
    end
    if contains(menu.Exceptions, "Crouching") and getPlayerState() == "crouching" then
        ui.set(ref.FL, 15)
    end
end

--DT Speed
local function UpdateDT()
    if ui.get(menu.EnableMisc) then
        if ui.get(menu.DTSpeed) == "Default" then
            ui.set(ref.MaxTicks, 16)
            cvar.cl_clock_correction:set_int(0)
        elseif ui.get(menu.DTSpeed) == "Fast" then
            ui.set(ref.MaxTicks, 17)
            cvar.cl_clock_correction:set_int(1)
        elseif ui.get(menu.DTSpeed) == "Aura" then
            ui.set(ref.MaxTicks, 18)
            cvar.cl_clock_correction:set_int(1)
        end
    end
end

--Anti-BackStab
local function AntiBackStabDistance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

local function AntiBackStab()
    if ui.get(menu.AntiBackStab) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = AntiBackStabDistance(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(menu.AntiBSRange) then
                ui.set(ref.Yaw[2],180)
                ui.set(ref.Pitch,"Off")
            end
        end
    end
end

--Static Legs + Zero Pitch 
local ground_ticks, end_time = 1, 0
client.set_event_callback("pre_render", function()
    if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
    
    if ui.get(menu.EnableVisuals) then
        if contains(menu.AnimationStuff, "Static Legs") then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
        end
        if contains(menu.AnimationStuff, "Zero Pitch on Land") then
            if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
            local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
            if on_ground == 1 then
                ground_ticks = ground_ticks + 1
            else
                ground_ticks = 0
                end_time = globals.curtime() + 1
            end
            if ground_ticks > ui.get(ref.FL)+1 and end_time > globals.curtime() then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
            end
        end
    end
end)

--Shot Logger
local hitgroup_names = {"Generic", "Head", "Chest", "Stomach", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Neck", "?", "Gear"}

client.set_event_callback("player_hurt", function(e)
    if ui.get(menu.ShotLogger) then
        if e.userid ~= e.attacker and client.userid_to_entindex(e.attacker) == entity.get_local_player() then
            local dmg, hp = e.dmg_health, e.health
            local name = entity.get_player_name(client.userid_to_entindex(e.userid))
            local hitgroup = hitgroup_names[e.hitgroup+1] or "gear"
    
            require.chat.print("{darkred}[Aura] {white}Hit {darkred}", name, "{white} in the {darkred}", hitgroup, "{white} for {darkred}", dmg, "{white} damage (", hp, " health remaining)")
        end
    end
end)

client.set_event_callback("aim_miss", function(e)
    if ui.get(menu.ShotLogger) then
        local hitgroup = hitgroup_names[e.hitgroup+1] or "gear"
        local reason = e.reason
        local name = entity.get_player_name(e.target)

        if reason == "?" then
            reason = "resolver"
        end

        require.chat.print("{darkred}[Aura] {white}Missed {darkred}", name,"'s ", hitgroup, "{white} due to {darkred}", reason)
    end
end)

--ClanTag
local duration = 25
local clantags = {
    "",
    "A",
    "Au",
    "Aur",
    "Aura",
    "Aura.",
    "Aura.l",
    "Aura.lu",
    "Aura.lua",
    "Aura.lu",
    "Aura.l",
    "Aura.",
    "Aura",
    "Aur",
    "Au",
    "A",
    ""
}
local clantag_prev

client.set_event_callback("paint", function()
    if ui.get(menu.ClanTag) then
        ui.set(ref.ClanTag, false)
        local cur = math.floor(globals.tickcount() / duration) % #clantags
        local clantag = clantags[cur+1]

        if clantag ~= clantag_prev then
          clantag_prev = clantag
          client.set_clan_tag(clantag)
        end
	end
end)

ui.set_callback(menu.ClanTag, function()
    if not ui.get(menu.ClanTag) then
        client.delay_call(0.2, function()
            client.set_clan_tag("")
        end)
    end
end)

--Dynamic Fake Lag
local FLBreaker = {
    [1] = "Dynamic",
    [2] = "Maximum",
    [3] = "Fluctuate"
}

client.set_event_callback("run_command", function ()
    if ui.get(menu.FLBreaker)then
        if not ui.get(ref.DT[2]) and not ui.get(ref.OSAA[2]) and not ui.get(ref.FakeDuck) then
            ui.set(ref.FLAmmount, FLBreaker[client.random_int(1,2)])
            if getPlayerState() == "standing" then
                ui.set(ref.FLVariance, 10)
            elseif getPlayerState() == "moving" then
                ui.set(ref.FLVariance, 20)
            elseif getPlayerState() == "in-air" then
                ui.set(ref.FLVariance, 25)
            end
        else
            ui.set(ref.FLAmmount, FLBreaker[1])
            ui.set(ref.FLVariance, 0)
        end
    end
end)

--Animation
local indicator  = {
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

local function Antimation()
    if ui.get(menu.IndicatorSelection) == "Normal" then
        local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped")
        ui.set(indicator.Aura, 14)
        ui.set(indicator.Alpha, 11)
        ui.set(indicator.LeftArrow, 35)
        ui.set(indicator.RightArrow, 30)
        ui.set(indicator.DT, 20)
        ui.set(indicator.OSAA, 6)
        ui.set(indicator.FS, 18)
        ui.set(indicator.FBA, 6)
        ui.set(indicator.PlayerState, 0)
    if ui.get(menu.SlideIndicator) and scoped ~= 0 then
        ui.set(indicator.Aura, x1)
        ui.set(indicator.Alpha, x2)
        ui.set(indicator.LeftArrow, x3)
        ui.set(indicator.RightArrow, x4)
        ui.set(indicator.DT, x5)
        ui.set(indicator.OSAA, x6)
        ui.set(indicator.FS, x7)
        ui.set(indicator.FBA, x8)
        ui.set(indicator.PlayerState, x9)
        x1 = require.easing.quad_in(3, x1, -22 - x1, 15) 
        x2 = require.easing.quad_in(3, x2, 47 - x2, 15)
        x3 = require.easing.quad_in(3, x3, -3 - x3, 15)
        x4 = require.easing.quad_in(3, x4, 65 - x4, 15)
        x5 = require.easing.quad_in(3, x5, -16 - x5, 15)
        x6 = require.easing.quad_in(3, x6, -30 - x6, 15)
        x7 = require.easing.quad_in(3, x7, 54 - x7, 15)
        x8 = require.easing.quad_in(3, x8, 42 - x8, 15)
        x9 = require.easing.quad_in(3, x9, -36 - x9, 15)
    elseif ui.get(menu.SlideIndicator) and scoped ~= 1 then
        ui.set(indicator.Aura, x1)
        ui.set(indicator.Alpha, x2)
        ui.set(indicator.LeftArrow, x3)
        ui.set(indicator.RightArrow, x4)
        ui.set(indicator.DT, x5)
        ui.set(indicator.OSAA, x6)
        ui.set(indicator.FS, x7)
        ui.set(indicator.FBA, x8)
        ui.set(indicator.PlayerState, x9)
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
end

--Indicators
local obex_data = obex_fetch and obex_fetch() or {username = "DavidDD", build = "Debug"}

local function Indicators()
    --ScreenSize
    local screen = {client.screen_size()}
    local center = {screen[1]/2, screen[2]/2}
    --Colors
    local CLR1 = {ui.get(menu.Color1)}
    local CLR2 = {ui.get(menu.Color2)}
    local CLR3 = {ui.get(menu.Color3)}
    local CLR4 = {ui.get(menu.Color4)}
    local CLR5 = {ui.get(menu.Color5)}
    local CLR6 = {ui.get(menu.Color6)}
    local CLR7 = {ui.get(menu.PlayerStateColor)}
    --Determine Latency and Time
    local latency = math.floor(client.latency()*1000+0.5)
    local hours, minutes = client.system_time()
    local text = string.format("%02d:%02d", hours, minutes)
    --Final Result
    local render = string.format("aura ~ " .. obex_data.build .. " | user: " .. obex_data.username .. " | latency: " .. latency .. " | "  .. text .. "")
    --Alpha Flash, Body Yaw, and Determine Desync
    local alpha = math.sin(math.abs((math.pi * -1) + (globals.curtime() * 1.5) % (math.pi * 2))) * 255
    local DetermineDesync = math.floor(math.min(58, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60)))
    function round(num, numDecimalPlaces)
        local mult = 10 ^ (numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end
    local body_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    --Crosshair Indicators
    if ui.get(menu.EnableVisuals) then
        if ui.get(menu.Indicators) and ui.get(menu.IndicatorSelection) == "Normal" then
            local threat = client.current_threat()
            if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
                renderer.text(center[1] - ui.get(indicator.Aura), center[2] + 40, CLR1[1], CLR1[2], CLR1[3], 255, "-c", nil, "AURA")
                renderer.text(center[1] + ui.get(indicator.Alpha), center[2] + 40, CLR2[1], CLR2[2], CLR2[3], alpha, "-c", nil, obex_data.build:upper())
                renderer.text(center[1] - ui.get(indicator.PlayerState), center[2] + 50,  CLR7[1], CLR7[2], CLR7[3], 255, "-c", nil, getPlayerState():upper())
                if ui.get(menu.AAArrows) then
                    renderer.text(center[1] - ui.get(indicator.LeftArrow), center[2] + 33, CLR3[1], CLR3[2], CLR3[3], 100, "b", nil, "<")
                    renderer.text(center[1] + ui.get(indicator.RightArrow), center[2] + 33, CLR3[1], CLR3[2], CLR3[3], 100, "b", nil, ">")
                    if body_yaw > 0 then
                        renderer.text(center[1] - ui.get(indicator.LeftArrow), center[2] + 33, CLR3[1], CLR3[2], CLR3[3], 255, "b", nil, "<")
                    else
                        renderer.text(center[1] + ui.get(indicator.RightArrow), center[2] + 33, CLR3[1], CLR3[2], CLR3[3], 255, "b", nil, ">")
                    end
                end
                if ui.get(ref.DT[2]) then
                    renderer.text(center[1] - ui.get(indicator.DT), center[2] + 60, CLR4[1], CLR4[2], CLR4[3], 255, "-c", nil, "DT")
                else
                    renderer.text(center[1] - ui.get(indicator.DT), center[2] + 60, CLR5[1], CLR5[2], CLR5[3], 140, "-c", nil, "DT")
                end
                if ui.get(ref.OSAA[2]) then
                    renderer.text(center[1] - ui.get(indicator.OSAA), center[2] + 60, CLR4[1], CLR4[2], CLR4[3], 255, "-c", nil, "HS")
                else
                    renderer.text(center[1] - ui.get(indicator.OSAA), center[2] + 60, CLR5[1], CLR5[2], CLR5[3], 140, "-c", nil, "HS")
                end
                if ui.get(menu.Freestanding) then
                    renderer.text(center[1] + ui.get(indicator.FS), center[2] + 60, CLR4[1], CLR4[2], CLR4[3], 255, "-c", nil, "FS")
                else
                    renderer.text(center[1] + ui.get(indicator.FS), center[2] + 60, CLR5[1], CLR5[2], CLR5[3], 140, "-c", nil, "FS")
                end
                if ui.get(ref.FBA) then
                    renderer.text(center[1] + ui.get(indicator.FBA), center[2] + 60, CLR4[1], CLR4[2], CLR4[3], 255, "-c", nil, "FB")
                else
                    renderer.text(center[1] + ui.get(indicator.FBA), center[2] + 60, CLR5[1], CLR5[2], CLR5[3], 140, "-c", nil, "FB")
                end
            end
            if ui.get(menu.Indicators) and ui.get(menu.IndicatorSelection) == "Ideal Yaw" then
                if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
                renderer.text(center[1] - 25, center[2] + 30, 215, 114, 44, 255, nil, 0, "AURA " .. obex_data.build:upper())
                renderer.text(center[1] - 25, center[2] + 40, 209, 139, 230, 255, nil, 0, "DYNAMIC")
                if ui.get(ref.DT[2]) then
                    renderer.text(center[1] - 25, center[2] + 50, CLR4[1], CLR4[2], CLR4[3], 255, nil, 0, "DT")
                else
                    renderer.text(center[1] - 25, center[2] + 50, CLR5[1], CLR5[2], CLR5[3], 140, nil, 0, "DT")
                end
                if ui.get(ref.OSAA[2]) then
                    renderer.text(center[1] - 10, center[2] + 50, CLR4[1], CLR4[2], CLR4[3], 255, nil, 0, "HS")
                else
                    renderer.text(center[1] - 10, center[2] + 50, CLR5[1], CLR5[2], CLR5[3], 140, nil, 0, "HS")
                end
                if ui.get(menu.Freestanding) then
                    renderer.text(center[1] + 5, center[2] + 50, CLR4[1], CLR4[2], CLR4[3], 255, nil, 0, "FS")
                else
                    renderer.text(center[1] + 5, center[2] + 50, CLR5[1], CLR5[2], CLR5[3], 140, nil, 0, "FS")
                end
            end
            if ui.get(menu.Indicators) and ui.get(menu.IndicatorSelection) == "Alternative" then
                if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
                renderer.text(center[1] - 3, center[2] + 50, CLR1[1], CLR1[2], CLR1[3], 255,  "-c", nil, "AURA")
                renderer.text(center[1] + 24, center[2] + 50, CLR2[1], CLR2[2], CLR2[3], alpha, "-c", nil, obex_data.build:upper())
                renderer.text(center[1] + 6, center[2] + 59, 120, 169, 255, 255, "-c", nil, "FAKE   YAW:")
                if body_yaw > 0 then
                    renderer.text(center[1] + 30, center[2] + 59, CLR1[1], CLR1[2], CLR1[3], CLR1[4], "-c", 0, "L")
                else
                    renderer.text(center[1] + 30, center[2] + 59, CLR1[1], CLR1[2], CLR1[3], CLR1[4], "-c", 0, "R")
                end
                if ui.get(ref.FBA) then
                    renderer.text(center[1] - 4, center[2] + 68, CLR4[1], CLR4[2], CLR4[3], alpha, "-c", nil, "BAIM")
                else
                    renderer.text(center[1] - 4, center[2] + 68, CLR5[1], CLR5[2], CLR5[3], 170, "-c", nil, "BAIM")
                end
                if ui.get(ref.FSP) then
                    renderer.text(center[1] + 12, center[2] + 68, CLR4[1], CLR4[2], CLR4[3], alpha, "-c", nil, "SP")
                else
                    renderer.text(center[1] + 12, center[2] + 68, CLR5[1], CLR5[2], CLR5[3], 170, "-c", nil, "SP")
                end
                if ui.get(menu.Freestanding) then
                    renderer.text(center[1] + 24, center[2] + 68, CLR4[1], CLR4[2], CLR4[3], alpha, "-c", nil, "FS")
                else
                    renderer.text(center[1] + 24, center[2] + 68, CLR5[1], CLR5[2], CLR5[3], 170, "-c", nil, "FS")
                end  
            end
        --Watermark
        if ui.get(menu.EnableVisuals) and ui.get(menu.Watermark) then
            renderer.text(center[1] + 810, center[2] - 518, 255, 255, 255, 255, "c", nil, render)
        end
    end
end

--GUI Removals
local function SetTableVisibility(table, state)
    for i = 1, #table do
        ui.set_visible(table[i], state)
    end
end

client.set_event_callback("paint_ui", function()
    if ui.is_menu_open() then
        SetTableVisibility({ref.Enabled, ref.Pitch, ref.YawBase, ref.Yaw[1], ref.Yaw[2], ref.YawJitter[1], ref.YawJitter[2], ref.BodyYaw[1], ref.BodyYaw[2], ref.FakeYawLimit, ref.FreestandingBodyYaw, ref.EdgeYaw, ref.Freestanding[1], ref.Freestanding[2], ref.Roll}, false)
        SetTableVisibility({indicator.Aura, indicator.Alpha, indicator.LeftArrow, indicator.RightArrow, indicator.DT, indicator.OSAA, indicator.FS, indicator.FBA, indicator.PlayerState}, false)
        
        if ui.get(menu.MasterCheck, true) then
            ui.set_visible(menu.MasterCheck, false)
        end

        MasterActive = ui.get(menu.MasterCheck)
            SetTableVisibility({menu.MenuLabel, menu.TabSelector, menu.AntiAimSelector, menu.LegitAA, menu.AntiBackStab, menu.StaticRollCheck, menu.StaticRoll, menu.DynamicRoll, menu.Freestanding, menu.EdgeYaw, menu.ForceRoll, menu.DTSpeed, menu.Indicators, menu.IndicatorSelection, menu.AAArrows, menu.SlideIndicator, menu.AnimationStuff, menu.Color1, menu.Color2, menu.Color3, menu.Color4, menu.Color5, menu.Color6, menu.Label1, menu.Label2, menu.Label3, menu.Label4, menu.Label5, menu.Label6, menu.PlayerStateColor, menu.PlayerStateColorLabel, menu.ManualCheck, menu.ManualBack, menu.ManualLeft, menu.ManualRight, menu.AntiBSRange, menu.WelcomeLabel1, menu.WelcomeLabel2, menu.ShotLogger, menu.DisableFL, menu.Label7}, MasterActive)
        BlankActive = MasterActive and ui.get(menu.TabSelector) == "-"
            SetTableVisibility({menu.WelcomeLabel1, menu.WelcomeLabel2}, BlankActive)
        AA_Active = ui.get(menu.TabSelector) == "Anti-Aim" and MasterActive and ui.get(menu.EnableAA)
            SetTableVisibility({menu.AntiAimSelector, menu.LegitAA, menu.AntiBackStab, menu.StaticRollCheck, menu.StaticRoll, menu.DynamicRoll, menu.ManualCheck, menu.ManualBack, menu.ManualLeft, menu.ManualRight, menu.AntiBSRange}, AA_Active)
        StaticRollActive = ui.get(menu.TabSelector) == "Anti-Aim" and MasterActive and ui.get(menu.EnableAA) and ui.get(menu.StaticRollCheck)
            ui.set_visible(menu.StaticRoll, StaticRollActive)
        ManualActive = ui.get(menu.TabSelector) == "Anti-Aim" and MasterActive and ui.get(menu.EnableAA) and ui.get(menu.ManualCheck)
            SetTableVisibility({menu.ManualBack, menu.ManualLeft, menu.ManualRight}, ManualActive)
        AntiBackStabActive = ui.get(menu.TabSelector) == "Anti-Aim" and MasterActive and ui.get(menu.EnableAA) and ui.get(menu.AntiBackStab)
            ui.set_visible(menu.AntiBSRange, AntiBackStabActive)
        BuilderActive = ui.get(menu.TabSelector) == "Anti-Aim" and MasterActive and ui.get(menu.EnableAA) and ui.get(menu.AntiAimSelector) == "Anti-Aim Builder"
            ui.set_visible(menu.PlayerState, BuilderActive)
            ui.set_visible(export_btn, BuilderActive)
            ui.set_visible(import_btn, BuilderActive)
        MiscActive = ui.get(menu.TabSelector) == "Misc" and MasterActive and ui.get(menu.EnableMisc)
            SetTableVisibility({menu.Freestanding, menu.EdgeYaw, menu.ForceRoll, menu.DTSpeed, menu.ShotLogger, menu.DisableFL, menu.Exceptions, menu.IdealTick, menu.ClockCorrection, menu.ClanTag, menu.FLBreaker}, MiscActive and ui.get(menu.TabSelector) == "Misc")
        DisableFLActive = ui.get(menu.TabSelector) == "Misc" and MasterActive and ui.get(menu.EnableMisc) and ui.get(menu.DisableFL)
            ui.set_visible(menu.Exceptions, DisableFLActive)
        DTBoostActive = ui.get(menu.TabSelector) == "Misc" and ui.get(menu.DTSpeed) == "Fast" or ui.get(menu.TabSelector) == "Misc" and ui.get(menu.DTSpeed) == "Aura"
            ui.set_visible(menu.ClockCorrection, DTBoostActive)
        VisualsActive = ui.get(menu.TabSelector) == "Visuals" and MasterActive and ui.get(menu.EnableVisuals)
            SetTableVisibility({menu.Indicators, menu.IndicatorSelection, menu.AAArrows, menu.SlideIndicator, menu.Watermark, menu.AnimationStuff}, VisualsActive)
        IndicatorSelectionActive = ui.get(menu.TabSelector) == "Visuals" and MasterActive and VisualsActive and ui.get(menu.Indicators) 
            ui.set_visible(menu.IndicatorSelection, IndicatorSelectionActive)
        MainIndicatorsActive = ui.get(menu.TabSelector) == "Visuals" and VisualsActive and MasterActive and ui.get(menu.IndicatorSelection) == "Normal"
            SetTableVisibility({menu.AAArrows, menu.SlideIndicator}, MainIndicatorsActive)

        if ui.get(menu.TabSelector) == "Colors" and ui.get(menu.OverrideColors) and ui.get(menu.IndicatorSelection) == "Normal" then
            SetTableVisibility({menu.Color1, menu.Color2, menu.Color3, menu.Color4, menu.Color5, menu.Color6, menu.Label1, menu.Label2, menu.Label3, menu.Label4, menu.Label5, menu.Label6, menu.PlayerStateColor, menu.PlayerStateColorLabel}, true)
        elseif ui.get(menu.TabSelector) == "Colors" and ui.get(menu.OverrideColors) and ui.get(menu.IndicatorSelection) == "Alternative" then
            SetTableVisibility({menu.Color1, menu.Color2, menu.Color4, menu.Color5, menu.Label1, menu.Label2, menu.Label4, menu.Label5}, true)
            SetTableVisibility({menu.Color3, menu.Color6, menu.PlayerStateColor, menu.Label3, menu.Label6, menu.PlayerStateColorLabel}, false)
        elseif ui.get(menu.TabSelector) == "Colors" and ui.get(menu.OverrideColors) and ui.get(menu.IndicatorSelection) == "Ideal Yaw" then
            SetTableVisibility({menu.Color4, menu.Color5, menu.Label4, menu.Label5}, true)
            SetTableVisibility({menu.Color1, menu.Color2, menu.Color3, menu.Color6, menu.Label1, menu.Label2, menu.Label3, menu.Label6, menu.PlayerStateColor, menu.PlayerStateColorLabel})
        else
            SetTableVisibility({menu.Color1, menu.Color2, menu.Color3, menu.Color4, menu.Color5, menu.Color6, menu.Label1, menu.Label2, menu.Label3, menu.Label4, menu.Label5, menu.Label6, menu.PlayerStateColor, menu.PlayerStateColorLabel}, false)
        end

        if MasterActive and AA_Active and ui.get(menu.AntiAimSelector) == "Anti-Aim Builder" then
            ActiveStateVisual = ConvertStates[ui.get(menu.PlayerState)]
            for i=1, 9 do
                ui.set_visible(Builder[i].Enable, ActiveStateVisual == i and AA_Active)
                if ui.get(Builder[i].Enable) then
                    ui.set_visible(Builder[i].YawLeft, ActiveStateVisual == i and AA_Active)
                    ui.set_visible(Builder[i].YawRight, ActiveStateVisual == i and AA_Active)
                    ui.set_visible(Builder[i].YawJitterMain, ActiveStateVisual == i and AA_Active)
                    ui.set_visible(Builder[i].YawJitterSlider, ActiveStateVisual == i and ui.get(Builder[ActiveStateVisual].YawJitterMain) ~= "Off" and AA_Active)
                    ui.set_visible(Builder[i].BodyYawMain, ActiveStateVisual == i and AA_Active)
                    ui.set_visible(Builder[i].BodyYawSlider, ActiveStateVisual == i and ui.get(Builder[i].BodyYawMain) ~= "Off" and ui.get(Builder[i].BodyYawMain) ~= "Opposite" and AA_Active)
                    ui.set_visible(Builder[i].EnableAntiBrute, ActiveStateVisual == i and AA_Active)
                    ui.set_visible(Builder[i].FakeYawLimitLeft, ActiveStateVisual == i and AA_Active)
                    ui.set_visible(Builder[i].FakeYawLimitRight, ActiveStateVisual == i and AA_Active)
                    ui.set_visible(Builder[i].FreestandingBodyYawBuilder, ActiveStateVisual == i and AA_Active)
                else
                    ui.set_visible(Builder[i].YawLeft, false)
                    ui.set_visible(Builder[i].YawRight, false)
                    ui.set_visible(Builder[i].YawJitterMain, false)
                    ui.set_visible(Builder[i].YawJitterSlider, false)
                    ui.set_visible(Builder[i].BodyYawMain, false)
                    ui.set_visible(Builder[i].BodyYawSlider, false)
                    ui.set_visible(Builder[i].EnableAntiBrute, false)
                    ui.set_visible(Builder[i].FakeYawLimitLeft, false)
                    ui.set_visible(Builder[i].FakeYawLimitRight, false)
                    ui.set_visible(Builder[i].FreestandingBodyYawBuilder, false)
                end
            end
        else
            for i=1, 9 do
                ui.set_visible(Builder[i].Enable, false)
                ui.set_visible(Builder[i].YawLeft, false)
                ui.set_visible(Builder[i].YawRight, false)
                ui.set_visible(Builder[i].YawJitterMain, false)
                ui.set_visible(Builder[i].YawJitterSlider, false)
                ui.set_visible(Builder[i].BodyYawMain, false)
                ui.set_visible(Builder[i].EnableAntiBrute, false)
                ui.set_visible(Builder[i].BodyYawSlider, false)
                ui.set_visible(Builder[i].FakeYawLimitLeft, false)
                ui.set_visible(Builder[i].FakeYawLimitRight, false)
                ui.set_visible(Builder[i].FreestandingBodyYawBuilder, false)
            end
        end
        ui.set_visible(menu.EnableAA, ui.get(menu.TabSelector) == "Anti-Aim")
        ui.set_visible(menu.EnableMisc, ui.get(menu.TabSelector) == "Misc")
        ui.set_visible(menu.EnableVisuals, ui.get(menu.TabSelector) == "Visuals")
        ui.set_visible(menu.OverrideColors, ui.get(menu.TabSelector) == "Colors")
    end
end)

--Shut Down
client.set_event_callback("shutdown", function()
    SetTableVisibility({ref.Enabled, ref.Pitch, ref.YawBase, ref.Yaw[1], ref.Yaw[2], ref.YawJitter[1], ref.YawJitter[2], ref.BodyYaw[1], ref.BodyYaw[2], ref.FakeYawLimit, ref.FreestandingBodyYaw, ref.EdgeYaw, ref.Freestanding[1], ref.Freestanding[2], ref.Roll}, true)
    ui.set(ref.Pitch, "Off")
    ui.set(ref.YawBase, "Local View")
    ui.set(ref.Yaw[1], "Off")
    ui.set(ref.Yaw[2], 0)
    ui.set(ref.YawJitter[1], "Off")
    ui.set(ref.YawJitter[2], 0)
    ui.set(ref.BodyYaw[1], "Off")
    ui.set(ref.BodyYaw[2], 0)
    ui.set(ref.FakeYawLimit, 60)
end)

--CallBacks
client.set_event_callback("paint", function()
    Antimation()
    Indicators()
    StatesThing()
end)
client.set_event_callback("setup_command", function(e)
    StaticRoll()
    DisableFL()
    AntiBackStab()
end)

client.set_event_callback("setup_command", Roll)
ui.set_callback(menu.DTSpeed, UpdateDT)