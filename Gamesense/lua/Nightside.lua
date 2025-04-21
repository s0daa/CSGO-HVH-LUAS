_DEBUG = true

local clipboard = require("neverlose/clipboard")
local base64 = require("neverlose/base64")
local pui = require("neverlose/pui")

local getUsername = common.get_username
local player = entity.get_local_player

local refs = {
    double_tap = pui.find("Aimbot", "Ragebot", "Main", "Double Tap");
    hide_shots = pui.find("Aimbot", "Ragebot", "Main", "Hide Shots");
    double_tap_lo = pui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options");
    double_tap_fl = pui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit");

    hitchance = pui.find("Aimbot", "Ragebot", "Selection", "Hit Chance");

    pitch = pui.find("Aimbot", "Anti Aim", "Angles", "Pitch");

    yaw = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw");
    yaw_base = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base");
    yaw_offset = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset");
    antiback_stab = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab");

    yaw_modifier = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier");
    modifier_offset = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset");

    body_yaw = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw");
    left_limit = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit");
    right_limit = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit");
    options = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options");
    body_fs = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding");

    fl_limit = pui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit");
    fl_variability = pui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability");

    fake_duck = pui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
    slow_walk = pui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk");

    freestanding = pui.find("Aimbot", "Anti Aim", "Angles", "Freestanding");
    disableModifiers = pui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    bodyFreestanding = pui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),

    airStrafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe")
}

local Functions = { }
local Utility = { }

Utility.color_text = function(...)
    local args = {...}
    local result = ""
    
    for index, value in ipairs(args) do
        local text = value[1]
        local color = value[2] or "255, 255, 255"
    
        if type(color) == "userdata" then
            color = color:to_hex()
        end
    
        result = result .. ("\a%s%s"):format(color, text)
    end
    
    return result
end

Utility.disableRefs = function()
    for _, ref in pairs(refs) do
        ref:override(ref:get())
    end
end

local folderPath = "csgo/nightsideV2"
local filePath = folderPath .. "/configsData.json"

files.create_folder(folderPath)

local configsData = files.read(filePath)
if configsData == nil then
    local defaultConfig = {
        cfgName = {"Default"},
        Default = ""
    }
    files.write(filePath, json.stringify(defaultConfig))
    configsData = defaultConfig
else
    configsData = json.parse(configsData)
end

local groups = {
    info = ui.create("🏠Main", "ℹ</ Information >"),
	config = pui.create("🏠Main", "⚙️</ Config System >", 1),
    nightside = ui.create("🏠Main", "🌃</ Nightside >", 2),
    antiaim = pui.create("✨Anti Aim", "🛡️</ Main >"),
    states = pui.create("✨Anti Aim", "📊</ States >", 1),
    builder = pui.create("✨Anti Aim", "🔨</ Builder >", 2),
    view = pui.create("🌌Utility", "👁️</ View >", 1),
    ragebot = pui.create("🌌Utility", "💥</ Ragebot >", 2),
    misc = pui.create("🌌Utility", "🧰</ Misc >", 2),
}

local menuInfo = {
    [1] = "👋Welcome, ".. common.get_username(),
    [2] = "📜Version: " .. "v1.4",
    [3] = "👷Build: " .. "Live",
    [4] = "🔃Last update: " .. "7/17/2023"
}

local states = {
    {"stand", "🧍 Standing"},
    {"run", "🚶 Moving"},
    {"air", "✈️ Air"},
    {"slow", "🐌 Slow Motion"},
    {"crouch", "🦆 Crouching"},
    {"airCrouch", "🦅 Air Crouching"}
}

local stateNames = {} for i, v in ipairs(states) do stateNames[i] = v[2] end

local logoLink = network.get("https://cdn.discordapp.com/attachments/995763282482835576/1128662826735648819/logoptnl.png")
local logoImage = render.load_image(logoLink, vector(585, 585))

ui.sidebar(Utility.color_text({"NightSide", ui.get_style("Link Active")}), "moon")

local menu = {
    ["Information"] = {
        groups.info:label(menuInfo[1]),
        groups.info:label(menuInfo[2]),
        groups.info:label(menuInfo[3]),
        groups.info:label(menuInfo[4])
    },
    ["Nightside Image"] = {
        groups.nightside:texture(logoImage, vector(270, 270), 90)
    },
    ["Anti Aim"] = {
        antiAimEnabler = groups.antiaim:switch("🎯 Enable anti-aimbot"),
        freestanding = groups.antiaim:switch("🧭 Freestanding", false, nil, function(gear)
            return {
                DisableModifiers = gear:switch("🚫 Disable Modifiers"),
                BodyFreestand = gear:switch("🕺 Body Freestand")
            }
        end),
        extraFeatures = groups.antiaim:listable("🛡️ Extra Features", {"Anti-backstab", "Force LC in Air", "Disable anti-aim in warmup"}),
        yawBase = groups.antiaim:combo("🧭 Yaw base", {"Off", "Forward", "Backwards", "Left", "Right"})
    },
    ["Anti Aim States"] = {
        selector = groups.states:list("📜 States", stateNames),
        cache = {}
    },
    ["Config"] = {
        configList = groups.config:list("", configsData.cfgName),
        configNameInput = groups.config:input("Enter config name:", "Name here!"),
        createConfigButton = groups.config:button("  🆕 Create config    "),
		deleteConfigButton = groups.config:button("  ❌ Delete config   "),
        saveConfigButton = groups.config:button("    💾 Save config      "),
        loadConfigButton = groups.config:button("    📂 Load config     "),
        exportConfigButton = groups.config:button("  📤 Export config   "),
        importConfigButton = groups.config:button("  📥 Import config   "),
    },
    ["View"] = {
        customViewModel = groups.view:switch("👀 Custom viewmodel", false, nil, function(gear)
            return {
                fieldOfView = gear:slider("Field Of View", 0, 100, 55),
                OffsetX = gear:slider("Offset X", -40, 40, 2),
                OffsetY = gear:slider("Offset Y", -40, 40, 1),
                OffsetZ = gear:slider("Offset Z", -40, 40, 4),
            }
        end),
        aspectRatio = groups.view:switch("📺 Custom aspect ratio", false, nil, function(gear)
            return {
                aspectRatioValue = gear:slider("Aspect Ratio", 0, 300, 0, 0.01),
                aspectRatio4_3Button = gear:button("4:3"),
                aspectRatio16_9Button = gear:button("16:9"),
                aspectRatio16_10Button = gear:button("16:10"),
                aspectRatio21_9Button = gear:button("21:10")
            }
        end)
    },
    ["Ragebot"] = {
        aimbotLogger = groups.ragebot:switch("🎯 Aimbot logger", false, nil, function(gear)
            return {
                hitColor = gear:color_picker("Hit Color", color(0, 255, 0)),
                missColor = gear:color_picker("Miss Color", color(255, 0, 0))
            }
        end),

        customHC = groups.ragebot:switch("🔫 Custom Hitchance", false, nil, function(gear)
            return {
                conditionSelect = gear:listable("Select Condition", {"In air", "No scope"}),
                hcInAir = gear:slider("Air", 0, 100, 0),
                hcInNoScope = gear:slider("No Scope", 0, 100, 0)
            }
        end)
    },
    ["Misc"] = {
        fastLadder = groups.misc:switch("🚀 Enable fast ladder"),
        fixJumpScout = groups.misc:switch("🦘 Fix Jumpscout"),
        fpsBoost = groups.misc:switch("💨 FPS Boost", false, nil, function(gear)
            return {
                fpsBoostOptions = gear:list("Select Option", {"Low", "Medium", "High"})
            }
        end)        
    }
}

Utility.createCtx = function(id, builder)
    local ctx = {
        yawType = builder:combo("Yaw Type", {"Single", "Biform", "Delayed Ticks"}),
        yawOffset = builder:slider("Yaw Offset", -180, 180, 0),
        leftYawOffset = builder:slider("Left Yaw Offset", -180, 180, 0),
        rightYawOffset = builder:slider("Right Yaw Offset", -180, 180, 0),
        delay_ticks = builder:slider("Delay Ticks", 1, 100, 40),
        modifier = builder:combo("Modifier", refs.yaw_modifier:list()),
        modifierOffset = builder:slider("Modifier Offset", -180, 180, 0),
        bodyYaw = builder:switch("Body Yaw", true),
        leftLimit = builder:slider("Left Limit", 0, 60, 60),
        rightLimit = builder:slider("Right Limit", 0, 60, 60),
        options = builder:selectable("Options", refs.options:list()),
        bodyFS = builder:combo("Body Freestanding", refs.body_fs:list())
    }

    ctx.yawOffset:depend({ctx.yawType, function(item) return item:get() == "Single" end})
    ctx.leftYawOffset:depend({ctx.yawType, function(item) return item:get() == "Biform" or item:get() == "Delayed Ticks" end})
    ctx.rightYawOffset:depend({ctx.yawType, function(item) return item:get() == "Biform" or item:get() == "Delayed Ticks" end})
    ctx.delay_ticks:depend({ctx.yawType, function(item) return item:get() == "Delayed Ticks" end})

    ctx.leftLimit:depend(ctx.bodyYaw)
    ctx.rightLimit:depend(ctx.bodyYaw)
    ctx.options:depend(ctx.bodyYaw)
    ctx.bodyFS:depend(ctx.bodyYaw)

    for k, ref in pairs(ctx) do
        ref:depend({menu["Anti Aim States"].selector, function(item) return item:get() == id end})
        ref:depend({menu["Anti Aim"].antiAimEnabler, true})
    end

    return ctx
end
for i, v in ipairs(states) do
    local id = v[1]
    menu["Anti Aim States"].cache[id] = Utility.createCtx(i, groups.builder)
end

local copiedState = nil
Utility.copyState = function()
    local state = states[menu["Anti Aim States"].selector:get()]
    local id = state[1]
    copiedState = menu["Anti Aim States"].cache[id]
end
Utility.pasteState = function()
    if copiedState then
        local state = states[menu["Anti Aim States"].selector:get()]
        local id = state[1]
        local ctx = menu["Anti Aim States"].cache[id]

        for k, v in pairs(copiedState) do
            ctx[k]:set(v:get())
        end
    end
end
menu["Anti Aim States"].copy = groups.builder:button("📄Copy", Utility.copyState)
menu["Anti Aim States"].paste = groups.builder:button("📋Paste", Utility.pasteState)

menu["Anti Aim"].freestanding:depend(menu["Anti Aim"].antiAimEnabler)
menu["Anti Aim"].freestanding.DisableModifiers:depend(menu["Anti Aim"].freestanding)
menu["Anti Aim"].freestanding.BodyFreestand:depend(menu["Anti Aim"].freestanding)
menu["Anti Aim"].extraFeatures:depend(menu["Anti Aim"].antiAimEnabler)
menu["Anti Aim"].yawBase:depend(menu["Anti Aim"].antiAimEnabler)
menu["Anti Aim States"].selector:depend(menu["Anti Aim"].antiAimEnabler)
menu["Anti Aim States"].copy:depend(menu["Anti Aim"].antiAimEnabler)
menu["Anti Aim States"].paste:depend(menu["Anti Aim"].antiAimEnabler)
menu.View.customViewModel.fieldOfView:depend(menu.View.customViewModel)
menu.View.customViewModel.OffsetX:depend(menu.View.customViewModel)
menu.View.customViewModel.OffsetY:depend(menu.View.customViewModel)
menu.View.customViewModel.OffsetZ:depend(menu.View.customViewModel)
menu.View.aspectRatio.aspectRatioValue:depend(menu.View.aspectRatio)
menu.View.aspectRatio.aspectRatioValue:depend(menu.View.aspectRatio)
menu.View.aspectRatio.aspectRatio4_3Button:depend(menu.View.aspectRatio)
menu.View.aspectRatio.aspectRatio16_9Button:depend(menu.View.aspectRatio)
menu.View.aspectRatio.aspectRatio16_10Button:depend(menu.View.aspectRatio)
menu.View.aspectRatio.aspectRatio21_9Button:depend(menu.View.aspectRatio)
menu.Ragebot.aimbotLogger.hitColor:depend(menu.Ragebot.aimbotLogger)
menu.Ragebot.aimbotLogger.missColor:depend(menu.Ragebot.aimbotLogger)
menu.Ragebot.customHC.conditionSelect:depend(menu.Ragebot.customHC)
menu.Ragebot.customHC.hcInAir:depend({menu.Ragebot.customHC.conditionSelect, function(item) return item:get(1) end})
menu.Ragebot.customHC.hcInNoScope:depend({menu.Ragebot.customHC.conditionSelect, function(item) return item:get(2) end})
menu.Misc.fpsBoost.fpsBoostOptions:depend(menu.Misc.fpsBoost)

Utility.getState = function()
    local localPlayer = player()
    if not localPlayer then return end

    local flags = localPlayer.m_fFlags
    local ducking = bit.band(flags, bit.lshift(1, 1)) ~= 0 or refs.fake_duck:get()
    local ground = bit.band(flags, bit.lshift(1, 0)) ~= 0
    local standing = localPlayer.m_vecVelocity:length() < 2
    local slowWalk = refs.slow_walk:get()

    if ducking and not ground then return "Air Crouching" end
    if ducking then return "Crouching" end
    if not ground then return "Air" end
    if slowWalk then return "Slow Motion" end
    if standing then return "Standing" end

    return "Moving"
end

Utility.getCondition = function()
    local state = Utility.getState()
    local stateToCondition = {
        ["Standing"] = 1,
        ["Moving"] = 2,
        ["Air"] = 3,
        ["Slow Motion"] = 4,
        ["Crouching"] = 5,
        ["Air Crouching"] = 6,
    }
    return stateToCondition[state]
end

Utility.getBodyYaw = function()
    local localPlayer = player()
    if not localPlayer or globals.choked_commands ~= 0 then
        return
    end

    return localPlayer.m_flPoseParameter[11] * 120 - 60
end

Utility.getSide = function()
    local bodyYaw = Utility.getBodyYaw()
    return bodyYaw and bodyYaw < 0
end

Utility.getYawOffset = function(antiAimState, side)
    if antiAimState.yawType:get() == "Biform" then
        return side and antiAimState.rightYawOffset:get() or antiAimState.leftYawOffset:get()
    else
        return antiAimState.yawOffset:get()
    end
end

Utility.timeToTicks = function(time)
    return math.floor(time / globals.tickinterval + 0.5)
end

local currentTick = Utility.timeToTicks(globals.realtime)

Functions.antiaim = function()
    if menu["Anti Aim"].extraFeatures:get(3) then
        local gameRules = entity.get_game_rules()
        if gameRules and gameRules.m_bWarmupPeriod then
            return
        end
    end

    local condition = Utility.getCondition()
    local state = states[condition]
    local id = state[1]
    local antiAimState = menu["Anti Aim States"].cache[id]

    local side = Utility.getSide()

    local switchTicks = Utility.timeToTicks(globals.realtime) - currentTick
    local switch = switchTicks * 2 >= antiAimState.delay_ticks:get()

    if switchTicks >= antiAimState.delay_ticks:get() then
        currentTick = Utility.timeToTicks(globals.realtime)
    end

    local yawOffset
    if antiAimState.yawType:get() == "Delayed Ticks" then
        yawOffset = switch and antiAimState.rightYawOffset:get() or antiAimState.leftYawOffset:get()
    else
        yawOffset = Utility.getYawOffset(antiAimState, side)
    end

    refs.yaw_offset:override(yawOffset)
    refs.yaw_modifier:override(antiAimState.modifier:get())
    refs.modifier_offset:override(antiAimState.modifierOffset:get())
    refs.body_yaw:override(antiAimState.bodyYaw:get())
    refs.left_limit:override(antiAimState.leftLimit:get())
    refs.right_limit:override(antiAimState.rightLimit:get())
    refs.options:override(antiAimState.options:get())
    refs.body_fs:override(antiAimState.bodyFS:get())

    if menu["Anti Aim"].yawBase:get() ~= "Off" then
        local yawBaseValues = {
            ["Backwards"] = {0, "Local View", false},
            ["Left"] = {-90, "Local View", false},
            ["Right"] = {90, "Local View", false},
            ["Forward"] = {180, "Local View", false},
            ["Off"] = {nil, refs.yaw_base:get(), nil}
        }
        local values = yawBaseValues[menu["Anti Aim"].yawBase:get()]
        if values then
            refs.yaw_offset:override(values[1])
            refs.yaw_base:override(values[2])
            refs.freestanding:override(values[3])
        end
    end    

    refs.antiback_stab:override(menu["Anti Aim"].extraFeatures:get(1))
    refs.freestanding:override(menu["Anti Aim"].freestanding:get())
    refs.disableModifiers:override(menu["Anti Aim"].freestanding.DisableModifiers:get())
    refs.bodyFreestanding:override(menu["Anti Aim"].freestanding.BodyFreestand:get())
end

Functions.breakLcAir = function()
    local state = Utility.getState()
    if menu["Anti Aim"].extraFeatures:get(2) and (state == "Air" or state == "Air Crouching") then
        refs.double_tap_lo:override("Always On")
    else
        refs.double_tap_lo:override(refs.double_tap_lo:get())
    end
end

Functions.disableBreakLcAir = function()
    refs.double_tap_lo:override(refs.double_tap_lo:get())
end

Functions.customViewModel = function()
    if menu.View.customViewModel:get() then
        cvar.viewmodel_fov:float(menu.View.customViewModel.fieldOfView:get(), true)
        cvar.viewmodel_offset_x:float(menu.View.customViewModel.OffsetX:get() / 10, true)
        cvar.viewmodel_offset_y:float(menu.View.customViewModel.OffsetY:get() / 10, true)
        cvar.viewmodel_offset_z:float(menu.View.customViewModel.OffsetZ:get() / 10, true)
    else
        cvar.viewmodel_fov:float(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-5)
    end
end

Functions.disableCustomViewModel = function()
    cvar.viewmodel_fov:float(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-5)
end

menu.View.customViewModel.fieldOfView:set_callback(Functions.customViewModel)
menu.View.customViewModel.OffsetX:set_callback(Functions.customViewModel)
menu.View.customViewModel.OffsetY:set_callback(Functions.customViewModel)
menu.View.customViewModel.OffsetZ:set_callback(Functions.customViewModel)

Functions.aspectRatio = function()
    if menu.View.aspectRatio:get() then
        cvar.r_aspectratio:float(menu.View.aspectRatio.aspectRatioValue:get() / 100)
    else
        cvar.r_aspectratio:float(0)
    end
end

Functions.destroy = function()
    cvar.r_aspectratio:float(0)
end

local aspectRatioValues = {
    ["4:3"] = 133,
    ["16:9"] = 178,
    ["16:10"] = 160,
    ["21:9"] = 233
}

local function setAspectRatio(value)
    menu.View.aspectRatio.aspectRatioValue:set(value)
end

local function setAspectRatio4_3()
    setAspectRatio(aspectRatioValues["4:3"])
end

local function setAspectRatio16_9()
    setAspectRatio(aspectRatioValues["16:9"])
end

local function setAspectRatio16_10()
    setAspectRatio(aspectRatioValues["16:10"])
end

local function setAspectRatio21_9()
    setAspectRatio(aspectRatioValues["21:9"])
end

menu.View.aspectRatio.aspectRatio4_3Button:set_callback(setAspectRatio4_3)
menu.View.aspectRatio.aspectRatio16_9Button:set_callback(setAspectRatio16_9)
menu.View.aspectRatio.aspectRatio16_10Button:set_callback(setAspectRatio16_10)
menu.View.aspectRatio.aspectRatio21_9Button:set_callback(setAspectRatio21_9)


Functions.render_watermark = function()
    local textColor = color(52, 57, 202, 255)
    local screensize = render.screen_size()
    local salut_hex = textColor:to_hex()
    local text = "\a"..salut_hex..""..ui.get_icon("moon").."\aDEFAULT nightside ~ \a"..salut_hex..""..string.lower(common.get_username())
    local textSize = render.measure_text(1, "d", text)
    local padding = 10
    local textColor = color(255, 255, 255, 255)
    local textPosition = vector(screensize.x - textSize.x - padding, screensize.y/2 - textSize.y/2)

    render.rect(vector(screensize.x - textSize.x - padding - 8, screensize.y/2 - textSize.y/2 - 2), vector(screensize.x - padding + 8, screensize.y/2 - textSize.y/2 + 17), color(20,20,20,255), 5)
    render.shadow(vector(screensize.x - textSize.x - padding - 8, screensize.y/2 - textSize.y/2 - 2), vector(screensize.x - padding + 8, screensize.y/2 - textSize.y/2 + 17), textColor, 30, 0, 5)
    render.text(1, textPosition, textColor, "d", text)
end

local hitgroups = {"generic","head", "chest", "stomach","left arm", "right arm","left leg", "right leg","neck", "generic", "gear"}
Functions.on_aim_ack = function(e)
    if not menu.Ragebot.aimbotLogger:get() then
        return
    end

    local id = e.id
    local target = e.target
    local damage = e.damage
    local spread = e.spread
    local hitchance = e.hitchance
    local backtrack = e.backtrack
    local aim = e.aim
    local state = e.state

    local hitColor = "\a" ..  menu.Ragebot.aimbotLogger.hitColor:get():to_hex():sub(0, 6)
    local missColor = "\a" ..  menu.Ragebot.aimbotLogger.missColor:get():to_hex():sub(0, 6)

    if state then
        local wanted_damage = e.wanted_damage
        local wanted_hitgroup = hitgroups[e.wanted_hitgroup + 1]
        print_raw((missColor.."\aShot "..missColor.."%d\aFFFFFF missed "..missColor.."%s\aFFFFFF in the "..missColor.."%s\aFFFFFF for "..missColor.."%d\aFFFFFF damage: "..missColor.."%s\aFFFFFF (hitchance: "..missColor.."%.2f\aFFFFFF, backtrack: "..missColor.."%d\aFFFFFF)"):format(id, target:get_name(), wanted_hitgroup, wanted_damage, state, hitchance, backtrack))
    else
        local hitgroup = hitgroups[e.hitgroup + 1]
        print_raw((hitColor.."\aShot "..hitColor.."%d\aFFFFFF hit "..hitColor.."%s\aFFFFFF in the "..hitColor.."%s\aFFFFFF for "..hitColor.."%d\aFFFFFF damage (hitchance: "..hitColor.."%.2f\aFFFFFF, backtrack: "..hitColor.."%d\aFFFFFF)"):format(id, target:get_name(), hitgroup, damage, hitchance, backtrack))
    end
end

Functions.customHC = function()
    if not menu.Ragebot.customHC:get() then return end

    local local_player = player()
    if not local_player or not local_player:is_alive() then return end

    local weapon = local_player:get_player_weapon()
    if not weapon then return end
    local weapon_name = weapon:get_name()
    local is_ssg = weapon_name == "SSG 08"
    local is_scar_or_g3sg1 = weapon_name == "SCAR-20" or weapon_name == "G3SG1"
    
    if menu.Ragebot.customHC.conditionSelect:get(1) and is_ssg then
        if local_player["m_fFlags"] == 256 then
            refs.hitchance:override(menu.Ragebot.customHC.hcInAir:get())
        else
            refs.hitchance:override(refs.hitchance:get())
        end
    end
    
    if menu.Ragebot.customHC.conditionSelect:get(2) and not local_player["m_bIsScoped"] then
        if is_ssg or is_scar_or_g3sg1 then
            refs.hitchance:override(menu.Ragebot.customHC.hcInNoScope:get())
        else
            refs.hitchance:override(refs.hitchance:get())
        end
    end
end

Functions.disableCustomHC = function()
    refs.hitchance:override(refs.hitchance:get())
end

Functions.fastLadder = function(cmd)
    if not menu["Misc"].fastLadder:get() then
        return
    end

    local currentPlayer = player()
    if not currentPlayer then
        return
    end

    if currentPlayer.m_MoveType ~= 9 then
        return
    end

    local weaponIndex = currentPlayer:get_player_weapon():get_weapon_index()
    for k, v in pairs({43, 44, 45, 46, 47, 48}) do
        if weaponIndex == v then
            return
        end
    end

    if cmd.sidemove == 0 then
        cmd.view_angles.y = cmd.view_angles.y + 45
    end

    if cmd.in_forward and cmd.sidemove < 0 then
        cmd.view_angles.y = cmd.view_angles.y + 90
    end

    if cmd.in_back and cmd.sidemove > 0 then
        cmd.view_angles.y = cmd.view_angles.y + 90
    end

    cmd.in_moveleft = cmd.in_back
    cmd.in_moveright = cmd.in_forward

    if cmd.view_angles.x < 0 then
        cmd.view_angles.x = -45
    end
end

Functions.fixJumpScout = function()
    if not menu.Misc.fixJumpScout:get() then return end

    local local_player = player()
    if not local_player then return end

    local velocity = local_player.m_vecVelocity
    local speed = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2)
    refs.airStrafe:set(speed > 2)
end

Functions.disableFixJumpScout = function()
    refs.airStrafe:set(true)
end

local cvarSettings = {
    {cvar = {cvar.r_shadows, cvar.cl_csm_static_prop_shadows, cvar.cl_csm_shadows, cvar.cl_csm_world_shadows, cvar.cl_foot_contact_shadows, cvar.cl_csm_viewmodel_shadows, cvar.cl_csm_rope_shadows, cvar.cl_csm_sprite_shadows, cvar.cl_foot_contact_shadows}},
    {cvar = {cvar.r_drawparticles, cvar.cl_detail_multiplier}},
    {cvar = {cvar.r_eyesize, cvar.r_eyeshift_z, cvar.r_eyeshift_y, cvar.r_eyeshift_x, cvar.r_eyemove, cvar.r_eyegloss}},
    {cvar = {cvar.r_drawtracers_firstperson, cvar.r_drawtracers}},
    {cvar = {cvar.mat_postprocess_enable}},
    {cvar = {cvar.fog_enable_water_fog}},
    {cvar = {cvar.m_rawinput, cvar.cl_bob_lower_amt}},
    {cvar = {cvar.cl_disablefreezecam, cvar.cl_freezecampanel_position_dynamic, cvar.cl_freezecameffects_showholiday}},
    {cvar = {cvar.r_drawropes, cvar.r_drawsprites, cvar.func_break_max_pieces, cvar.mat_drawwater}},
    {cvar = {cvar.cl_disablehtmlmotd, cvar.r_dynamic, cvar.cl_autohelp, cvar.r_drawdecals, cvar.muzzleflash_light}}
}

Functions.fpsBoost = function()
    if not menu.Misc.fpsBoost:get() then
        for _, group in ipairs(cvarSettings) do
            for _, c in ipairs(group.cvar) do
                c:int(1)
            end
        end
        return
    end

    local fpsBoostOption = menu.Misc.fpsBoost.fpsBoostOptions:get()
    if fpsBoostOption == 1 then
        cvar.r_shadows:int(0)
        cvar.cl_csm_static_prop_shadows:int(0)
        cvar.cl_csm_shadows:int(0)
        cvar.cl_csm_world_shadows:int(0)
        cvar.cl_foot_contact_shadows:int(0)
        cvar.cl_csm_viewmodel_shadows:int(0)
        cvar.cl_csm_rope_shadows:int(0)
        cvar.cl_csm_sprite_shadows:int(0)
        cvar.cl_foot_contact_shadows:int(0)
    else
        cvar.r_shadows:int(1)
        cvar.cl_csm_static_prop_shadows:int(1)
        cvar.cl_csm_shadows:int(1)
        cvar.cl_csm_world_shadows:int(1)
        cvar.cl_foot_contact_shadows:int(1)
        cvar.cl_csm_viewmodel_shadows:int(1)
        cvar.cl_csm_rope_shadows:int(1)
        cvar.cl_csm_sprite_shadows:int(1)
        cvar.cl_foot_contact_shadows:int(1)
    end

    if fpsBoostOption == 2 then
        cvar.r_drawparticles:int(0)
        cvar.cl_detail_multiplier:int(0)

        cvar.r_eyesize:int(0)
        cvar.r_eyeshift_z:int(0)
        cvar.r_eyeshift_y:int(0)
        cvar.r_eyeshift_x:int(0)
        cvar.r_eyemove:int(0)
        cvar.r_eyegloss:int(0)

        cvar.r_drawtracers_firstperson:int(0)
        cvar.r_drawtracers:int(0)

    elseif fpsBoostOption == 3 then
        for _, group in ipairs(cvarSettings) do
            for _, c in ipairs(group.cvar) do
                c:int(0)
            end
        end
    else
        for _, group in ipairs(cvarSettings) do
            for _, c in ipairs(group.cvar) do
                c:int(1)
            end
        end
    end
end

Functions.disableFpsBoost = function()
    for _, group in ipairs(cvarSettings) do
        for _, c in ipairs(group.cvar) do
            c:int(1)
        end
    end
end    

menu.Misc.fpsBoost:set_callback(Functions.fpsBoost)
menu.Misc.fpsBoost.fpsBoostOptions:set_callback(Functions.fpsBoost)

pui.setup(menu)

local defaultConfigName = "Default"

local function saveCurrentConfig()
    local selectedConfigIndex = menu["Config"].configList:get()
    
    if selectedConfigIndex == nil then
       print('No config selected')
       return
    end
    
    local status, configsDataJsonString = pcall(files.read,"csgo/nightsideV2/configsData.json")
    
    if not status then
       print(configsDataJsonString)
       return
    end
    
    local configsDataJsonTable = json.parse(configsDataJsonString)
    
    local selectedConfigName = configsDataJsonTable.cfgName[selectedConfigIndex]
    
    if selectedConfigName == defaultConfigName then
        print("Cannot modify the default config")
        return
    end
    
    local currentConfig = pui.save()
    local encryptedCurrentConfig = base64.encode(json.stringify(currentConfig))
    
    configsDataJsonTable[selectedConfigName] = encryptedCurrentConfig
    
    files.write('csgo/nightsideV2/configsData.json',json.stringify(configsDataJsonTable))
end

local function loadSelectedConfig()
    local selectedConfigIndex = menu["Config"].configList:get()
    
    if selectedConfigIndex == nil then
       print('No config selected')
       return
    end
    
    local status, configsDataJsonString = pcall(files.read,"csgo/nightsideV2/configsData.json")
    
    if not status then
       print(configsDataJsonString)
       return
    end
    
    local configsDataJsonTable = json.parse(configsDataJsonString)
    
    local selectedConfigName = configsDataJsonTable.cfgName[selectedConfigIndex]
    
    local encryptedSelectedConfig = configsDataJsonTable[selectedConfigName]
    local decryptedSelectedConfig = json.parse(base64.decode(encryptedSelectedConfig))
    
    pui.load(decryptedSelectedConfig)
end

local function createNewConfig()
    local newConfigName = menu["Config"].configNameInput:get()
    
    if newConfigName == nil or newConfigName == '' then
       print('No config name entered')
       return
    end
    
    local status, configsDataJsonString = pcall(files.read,"csgo/nightsideV2/configsData.json")
    
    if not status then
        print(configsDataJsonString)
        return
    end
    
    if configsDataJsonString == nil then
        print("Error: Failed to read csgo/nightsideV2/configsData.json")
        return
    end
    
    local configsDataJsonTable = json.parse(configsDataJsonString)
    
    if configsDataJsonTable[newConfigName] ~= nil then
        print("A config with that name already exists")
        return
    end
    
    local currentConfig = pui.save()
    local encryptedCurrentConfig = base64.encode(json.stringify(currentConfig))
    
    configsDataJsonTable[newConfigName] = encryptedCurrentConfig
    
    table.insert(configsDataJsonTable.cfgName, newConfigName)
    
    files.write('csgo/nightsideV2/configsData.json',json.stringify(configsDataJsonTable))
    
    menu["Config"].configList:update(configsDataJsonTable.cfgName)
end

local function deleteSelectedConfig()
    local selectedConfigIndex = menu["Config"].configList:get()
    
    if selectedConfigIndex == nil then
       print('No config selected')
       return
    end
    
    local status, configsDataJsonString = pcall(files.read,"csgo/nightsideV2/configsData.json")
    
    if not status then
      print(configsDataJsonString)
      return
    end
    
    local configsDataJsonTable = json.parse(configsDataJsonString)
    
    local selectedConfigName = configsDataJsonTable.cfgName[selectedConfigIndex]
    
    if selectedConfigName == defaultConfigName then
        print("Cannot delete the default config")
        return
    end
    
    configsDataJsonTable[selectedConfigName] = nil

    table.remove(configsDataJsonTable.cfgName, selectedConfigIndex)
    
    files.write('csgo/nightsideV2/configsData.json',json.stringify(configsDataJsonTable))
    
    menu["Config"].configList:update(configsDataJsonTable.cfgName)
end

menu["Config"].createConfigButton:set_callback(createNewConfig)
menu["Config"].saveConfigButton:set_callback(saveCurrentConfig)
menu["Config"].loadConfigButton:set_callback(loadSelectedConfig)
menu["Config"].deleteConfigButton:set_callback(deleteSelectedConfig)

menu["Config"].exportConfigButton:set_callback(function()
    local config = pui.save()

    local configJsonString = json.stringify(config)
    local encryptedConfig = base64.encode(configJsonString)
    
    clipboard.set(encryptedConfig)
end)

menu["Config"].importConfigButton:set_callback(function()
    local encrypted = clipboard.get()
    
    local status, decrypted = pcall(base64.decode, encrypted)
    if not status then
        print('Invalid data in clipboard')
        return
    end
    
    status, decrypted = pcall(json.parse, decrypted)
    if not status then
        print('Invalid data in clipboard')
        return
    end
    
    pui.load(decrypted)
end)

local eventsFunctions = {
    createmove = {
        function(cmd)
            Functions.antiaim()
            Functions.breakLcAir()
            Functions.fastLadder(cmd)
            Functions.fixJumpScout()
            Functions.customHC()
        end
    },
    shutdown = {
        function()
            Functions.destroy()
            Functions.disableBreakLcAir() 
            Functions.disableCustomViewModel()
            Functions.disableCustomHC()
            Functions.disableFixJumpScout()
            Functions.disableFpsBoost()
            Utility.disableRefs()
        end
    },
    aim_ack = {
        function(e)
            Functions.on_aim_ack(e)
        end
    },
    render = {
        function()
            Functions.render_watermark()
        end
    }
}

for eventName, eventFunctions in pairs(eventsFunctions) do
    events[eventName]:set(function(...)
        for _, func in ipairs(eventFunctions) do
            func(...)
        end
    end)
end