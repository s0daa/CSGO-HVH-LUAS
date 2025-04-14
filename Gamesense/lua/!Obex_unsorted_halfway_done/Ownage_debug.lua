-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local surface = require "gamesense/surface" or error("Missing gamesense/surface https://gamesense.pub/forums/viewtopic.php?id=18793")
local images = require "gamesense/images" or error("Missing gamesense/images https://gamesense.pub/forums/viewtopic.php?id=22917")
local csgo_weapons = require "gamesense/csgo_weapons" or error("Missing gamesense/csgo_weapons https://gamesense.pub/forums/viewtopic.php?id=18807")
local anti_aim = require "gamesense/antiaim_funcs" or error("Missing gamesense/antiaim_funcs https://gamesense.pub/forums/viewtopic.php?id=29665")
local vector = require "vector"
local ffi = require "ffi"

local mx, my = client.screen_size()
local infox, infoy = unpack(database.read("hitlerhud_logger_info_box") or {mx/2 - mx/6, my/16})

local indicators = {}
local indicators_def = {}
local indicators_clr = {}
local indicators_type = {}
local indicatorgap

local loggerdata = {
    text = {},
    offset = {},
    alpha = {},
    time = {},
    aim_fire_table = {},
    main_logger_table = {},
    aim_fire_data = {},
    index = {},
}
local aim_fire_logs = {id = {}, pred_hc = {}, pred_hb = {}, pred_dmg = {}, backtrack = {}, target = {}}
local aim_fire_storage = {
    pred_hc = {},
    pred_hb = {},
    pred_dmg = {},
    backtrack = {},
}
local stats = {
    totalshots = 0,
    totalhits = 0,
    totalmisses = 0,
    hitrate = 0,
    unknownmisses = 0,
    spreadmisses = 0,
    predictionmisses = 0,
    averagebacktrack = 0,
    maxbacktrack = 0,
    belowmindmg = 0,
}
local hitgroup_names = {'generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', '?', 'gear'}
local impacts = {}
local impactiterator = 0
local activeweptype = -1
local weaponwhitelist = {}
local bombinfo = {
    site = "unknown",
    explodetime = 0,
    timetoexplode = 0,
    defusetime = 0,
    timetodefuse = 0,
    alpha = 0,
    alphatext = 0,
    defusing = false,
    defused = false,
    alphadefuse = 0,
    alphatextdefuse = 0,
}

--ffi

pClientEntityList = client.create_interface("client.dll", "VClientEntityList003") or error("invalid interface", 2)
fnGetClientEntity = vtable_thunk(3, "void*(__thiscall*)(void*, int)")

ffi.cdef[[
    typedef void*(__thiscall* get_net_channel_info_t)(void*);
    typedef const char*(__thiscall* get_address_t)(void*);
	typedef const char*(__thiscall* get_name_t)(void*);
	typedef float(__thiscall* get_avg_loss_t)(void*, int);
	typedef float(__thiscall* get_avg_choke_t)(void*, int);
    typedef struct { float x; float y; float z; } bbvec3_t;
        ]]

local veclient = client.create_interface('engine.dll', 'VEngineClient014')
local interface_ptr = ffi.typeof('void***')
local rawivengineclient = client.create_interface("engine.dll", "VEngineClient014") or error("VEngineClient014 wasnt found", 2)
local ivengineclient = ffi.cast(interface_ptr, rawivengineclient) or error("rawivengineclient is nil", 2)
local get_net_channel_info = ffi.cast("get_net_channel_info_t", ivengineclient[0][78]) or error("ivengineclient is nil")

local is_voice_recording = ffi.cast(ffi.typeof('bool(__thiscall*)(void*)'), ivengineclient[0][224])
local fnGetAttachment = vtable_thunk(83, "bool(__thiscall*)(void*, int, bbvec3_t&)")
local fnGetMuzzleAttachmentIndex1stPerson = vtable_thunk(467, "int(__thiscall*)(void*, void*)")
local fnGetMuzzleAttachmentIndex3stPerson = vtable_thunk(468, "int(__thiscall*)(void*)")

local menu = {
    ["menuManager"] = ui.new_combobox("AA", "Anti-aimbot angles", "Settings", {"Anti-aimbot", "Visuals", "Other", "Default"}),

    --AA
    ["aaEnable"]         = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable anti-aim"),
    ["legitAA"]          = ui.new_hotkey("AA", "Anti-aimbot angles", "Legit AA key", false, 0x45),
    ["bodyyaw"]          = ui.new_combobox("AA", "Anti-aimbot angles", "Body yaw", {"Static", "Real jitter", "Anti-bruteforce static", "Anti-bruteforce jitter"}),
    ["jitterslider"]     = ui.new_slider("aa", "Anti-aimbot angles", "Jitter amount", "-180", "180", "20", "o"),
    ["disablenoenemies"] = ui.new_checkbox("AA", "Anti-aimbot angles", "Disable anti-aim if enemies are dead"),
    ["edgeyaw"]          = ui.new_multiselect("AA", "Anti-aimbot angles", "Edge yaw triggers", {"Ground", "Air", "Legit AA"}),
    
    ["roll_force"]      = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB6B665FFForce roll"),
    ["roll_checkbox"]   = ui.new_checkbox("AA", "Anti-aimbot angles", "Roll invert key"),
    ["roll_hotkey"]     = ui.new_hotkey("AA", "Anti-aimbot angles", "Roll invert key  ", true),
    ["disablers"]       = ui.new_multiselect("AA", "Anti-aimbot angles", "Roll disablers", {"Quick peek assist", "Duck peek assist", "Edge yaw", "Velocity", "Jump at edge", "In air"}),
    ["disablers_hk"]    = ui.new_hotkey("AA", "Anti-aimbot angles", "\n", true),
    ["velocity_slider"] = ui.new_slider("AA", "Anti-aimbot angles", "Velocity limit", 2, 135),

    --colors
    ["crosshairIndicators"]      = ui.new_checkbox("AA", "Anti-aimbot angles", "Crosshair indicators"),
    ["crosshairIndicatorsStyle"] = ui.new_combobox("AA", "Anti-aimbot angles", "Style", {"Classic", "Kaleidoscope", "Small text"}),
    ["indicatorsSelect"]         = ui.new_multiselect("AA", "Anti-aimbot angles", "Indicators", "On-shot anti aim"),
    ["deltaIndicator"]           = ui.new_checkbox("AA", "Anti-aimbot angles", "Delta indicator"),
    ["watermarkLabel"]           = ui.new_label("AA", "Anti-Aimbot angles", "Watermark color"),
    ["watermarkcolor"]           = ui.new_color_picker("AA", "Anti-Aimbot angles", "Watermark color", "255", "255", "255"),
    ["activeIndicatorLabel"]     = ui.new_label("AA", "Anti-Aimbot angles", "Active indicator"),
    ["activeIndicator"]          = ui.new_color_picker("AA", "Anti-Aimbot angles", "Active indicator color", "255", "255", "255"),
    ["inactiveIndicatorLabel"]   = ui.new_label("AA", "Anti-Aimbot angles", "Inactive indicator color"),
    ["inactiveIndicator"]        = ui.new_color_picker("AA", "Anti-Aimbot angles", "Inactive indicator color", "0", "213", "255"),
    ["fakeIndicatorLabel"]       = ui.new_label("AA", "Anti-Aimbot angles", "Fake indicator color"),
    ["fakeIndicator"]            = ui.new_color_picker("AA", "Anti-Aimbot angles", "Fake indicator color", "255", "255", "255"),
    ["realIndicatorLabel"]       = ui.new_label("AA", "Anti-Aimbot angles", "Real indicator color"),
    ["realIndicator"]            = ui.new_color_picker("AA", "Anti-Aimbot angles", "Real indicator color", "0", "213", "255"),
    ["triggerIndicatorLabel"]    = ui.new_label("AA", "Anti-Aimbot angles", "Auto fire indicator color"),
    ["triggerIndicator"]         = ui.new_color_picker("AA", "Anti-Aimbot angles", "Auto fire indicator color", "255", "255", "255"),
    ["awallIndicatorLabel"]      = ui.new_label("AA", "Anti-Aimbot angles", "Auto penetration indicator color"),
    ["awallIndicator"]           = ui.new_color_picker("AA", "Anti-Aimbot angles", "Auto penetration indicator color", "255", "173", "49"),
    ["loggerhitlabel"]           = ui.new_label("AA", "Anti-Aimbot angles", "Logger hit color"),
    ["loggerhit"]                = ui.new_color_picker("AA", "Anti-Aimbot angles", "Logger hit color", "0", "213", "255"),
    ["loggermisslabel"]          = ui.new_label("AA", "Anti-Aimbot angles", "Logger miss color"),
    ["loggermiss"]               = ui.new_color_picker("AA", "Anti-Aimbot angles", "Logger miss color", "255", "173", "49"),
    ["loggeraccentlabel"]        = ui.new_label("AA", "Anti-Aimbot angles", "Logger info accent color"),
    ["loggeraccent"]             = ui.new_color_picker("AA", "Anti-Aimbot angles", "Logger info accent color", "255", "255", "255", "100"),
    ["scopematerial"]            = ui.new_checkbox("AA", "Anti-aimbot angles", "Remove scope blur"),
    ["snaplines"]                = ui.new_checkbox("AA", "Anti-aimbot angles", "Snaplines"),
    ["snaplinescolor"]           = ui.new_color_picker("AA", "Anti-Aimbot angles", "Snaplines color", 255, 255, 255, 50),
    ["snaplinesselect"]          = ui.new_combobox("AA", "Anti-aimbot angles", "Style", "Screen", "Crosshair", "Weapon attachment"),
    --["hitlerToggle"]            = ui.new_checkbox("AA", "Anti-aimbot angles", "Toggle hitler mode"),

    --misc
    ["logger"]       = ui.new_checkbox("AA", "Anti-aimbot angles", "Aimbot logger"),
    ["loggerslider"] = ui.new_slider("AA", "Anti-aimbot angles", "Logger visibility time", 10, 90, "25", true, "s"),
    ["loggerinfo"]   = ui.new_hotkey("AA", "Anti-aimbot angles", "Logger info box", false, 0x09),
    ["clantag"]      = ui.new_checkbox("AA", "Anti-aimbot angles", "Clan tag spammer"),
    ["bombtimer"]    = ui.new_checkbox("AA", "Anti-aimbot angles", "Bomb timer"),
    ["chatspammer"]  = ui.new_checkbox("AA", "Anti-aimbot angles", "Chat spammer"),
    ["hudEnable"]    = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable custom hud"),
    ["hudColor"]     = ui.new_color_picker("AA", "Anti-Aimbot angles", "HUD color", 150, 150, 150, 220),
    ["hudOffsetx"]   = ui.new_slider("AA", "Anti-Aimbot angles", "HUD offset x", 20, 320, 20, true, "px", 1),

    --AA/Other
    ["debugVisuals"] = ui.new_multiselect("AA", "Other", "Debug visuals™", "Variables", "getBodyYaw", "nearCover"),

    --Legit/Other
    ["legitbotMaster"]      = ui.new_checkbox("Legit", "Other", "Kaleidoscope legitbot"),
    ["semirageMaster"]      = ui.new_hotkey("Legit", "Other", "Semirage mode B )", false),
    ["afire"]               = ui.new_hotkey("Legit", "Other", "Automatic fire", false),
    ["awall"]               = ui.new_hotkey("Legit", "Other", "Automatic penetration ", false),
    ["preferbody"]          = ui.new_hotkey("Legit", "Other", "Prefer body aim", false),
    ["maxfov"]              = ui.new_slider("Legit", "Other", "Maximum FOV", 1, 60, 6, true, "°"),
    ["fovfactor"]           = ui.new_slider("Legit", "Other", "FOV scale factor", 0, 150, 75, true, "%"),
    ["weaponselect"]        = ui.new_multiselect("Legit", "Other", "Enable ragebot weapons", "Sniper", "Pistol", "Rifle"),
    ["semirageaa"]          = ui.new_checkbox("Legit", "Other", "Anti aim"),
    ["displaycorrected"]    = ui.new_checkbox("Legit", "Other", "Display corrected players"),
    ["noscopeindicator"]    = ui.new_checkbox("Legit", "Other", "Noscope indicator"),
    ["noscopeindicatorclr"] = ui.new_color_picker("Legit", "Other", "Noscope indicator color", "0", "213", "255", "50"),
    ["hitchancerestore"]    = ui.new_slider("Legit", "Other", "Minimum hitchance", 0, 100, 50, true, "%"),
    ["scopeOverlay"]        = ui.new_checkbox("Legit", "Other", "Scope overlay"),
    ["scopeOverlayclr"]     = ui.new_color_picker("Legit", "Other", "Scope overlay color", "255", "255", "255"),
}

local wm_r, wm_g, wm_b = ui.get(menu.watermarkcolor)
local ai_r, ai_g, ai_b = ui.get(menu.activeIndicator)
local ii_r, ii_g, ii_b = ui.get(menu.inactiveIndicator)
local fi_r, fi_g, fi_b = ui.get(menu.fakeIndicator)
local ri_r, ri_g, ri_b = ui.get(menu.realIndicator)
local af_r, af_g, af_b = ui.get(menu.triggerIndicator)
local ap_r, ap_g, ap_b = ui.get(menu.awallIndicator)
local lh_r, lh_g, lh_b = ui.get(menu.loggerhit)
local lm_r, lm_g, lm_b = ui.get(menu.loggermiss)
local hr, hg, hb, ha = ui.get(menu.hudColor)
local ns_r, ns_g, ns_b, ns_a = ui.get(menu.noscopeindicatorclr)
local so_r, so_g, so_b = ui.get(menu.scopeOverlayclr)
local sl_r, sl_g, sl_b, sl_a = ui.get(menu.snaplinescolor)
local la_r, la_g, la_b, la_a = ui.get(menu.loggeraccent)

local fonts = {
    ["arrows"]          = surface.create_font("Corbel Bold", 18, 100, {0x010, 0x400}),
    ["watermark"]       = surface.create_font("Verdana", 18, 400, {0x010, 0x400}), --("Corbel Bold", 18, 100, {0x010, 0x400}),
    ["hud"]             = surface.create_font("Helvetica", 24, 900, {0x010, 0x400}),
    ["indicators"]      = surface.create_font("Arial", 14, 200, {0x010, 0x400}),
    ["numindicators"]   = surface.create_font("Verdana", 12, 100, {0x010, 0x400}),
    ["logs"]            = surface.create_font("Verdana", 12, 100, {0x010, 0x400, 0x080}),
    ["logsdata"]        = surface.create_font("Verdana", 12, 100, {0x010, 0x400}),
    ["timeclock"]       = surface.create_font("Verdana bold", 28, 900, {0x010, 0x400}),
    ["ammo"]            = surface.create_font("Helvetica", 40, 400, {0x010, 0x400}),
    ["reserve"]         = surface.create_font("Helvetica", 24, 100, {0x010, 0x400}),
    ["smallfonts"]      = surface.create_font("small fonts", 8, 300, {0x010, 0x200, 0x400}),
    ["smallfonts2"]      = surface.create_font("small fonts", 12, 300, {0x010, 0x200, 0x400}),
}

local fonts2k = {
    ["arrows"]          = surface.create_font("Corbel Bold", 24, 100, {0x010, 0x400}),
    ["watermark"]       = surface.create_font("Verdana", 24, 100, {0x010, 0x400}), --("Corbel Bold", 18, 100, {0x010, 0x400}),
    ["hud"]             = surface.create_font("Helvetica", 24, 900, {0x010, 0x400}),
    ["indicators"]      = surface.create_font("Arial Bold", 18, 400, {0x010, 0x400}),
    ["numindicators"]   = surface.create_font("Verdana", 16, 100, {0x010, 0x400}),
    ["logs"]            = surface.create_font("Verdana", 16, 100, {0x010, 0x400, 0x080}),
}

local refs = {
    --aimbot
    ["ragebotenable"] = {ui.reference("RAGE", "Aimbot", "Enabled")},
    ["safepoint"]     = ui.reference("RAGE", "Aimbot", "Force safe point"),
    ["autofire"]      = ui.reference("RAGE", "Other", "Automatic fire"),
    ["autopen"]       = ui.reference("RAGE", "Other", "Automatic penetration"),
    ["hitchance"]     = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
    ["mindamage"]     = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    ["maxfov"]        = ui.reference("RAGE", "Other", "Maximum FOV"),
    ["preferbodyaim"] = ui.reference("RAGE", "Aimbot", "Prefer body aim"),
    ["bodyaim"]       = ui.reference("RAGE", "Aimbot", "Force body aim"),
    ["dpa"]           = ui.reference("RAGE", "Other", "Duck peek assist"),
    ["doubletap"]     = {ui.reference("RAGE", "Aimbot", "Double tap")},
    ["qps"]           = ui.reference("RAGE", "OTHER", "Quick Peek assist"),

    --antiaim
    ["enabled"]       = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    ["pitch"]         = ui.reference("AA", "Anti-aimbot angles", "pitch"),
    ["yawbase"]       = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    ["yaw"]           = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    ["yawjitter"]     = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    ["bodyyaw"]       = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    ["fsbodyyaw"]     = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    ["edgeyaw"]       = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    ["freestanding"]  = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    ["roll"]          = ui.reference("AA", "Anti-aimbot angles", "Roll"),

    --fakelag
    ["fakelagenable"] = {ui.reference("AA", "Fake lag", "Enabled")},
    ["fakelaglimit"]  = ui.reference("AA", "Fake lag", "Limit"),

    --Other
    ["slowmo"]        = {ui.reference("AA", "Other", "Slow motion")},
    ["legmovement"]   = ui.reference("AA", "Other", "Leg movement"),
    ["onshotaa"]      = {ui.reference("AA", "Other", "On shot anti-aim")},

    --Visual
    ["inaccuracy"]    = {ui.reference("Visuals", "Other ESP", "Inaccuracy overlay")},
    ["scopeOverlay"]  = ui.reference("Visuals", "Effects", "Remove scope overlay"),
    ["force3p"]       = {ui.reference("Visuals", "Effects", "Force third person (alive)")},

    -- Misc
    ["edge_jump"]     = ui.reference("MISC", "Movement", "Jump at edge")
}

local plistcheck = {
	["-"] = false,
	["On"] = true,
	["Off"] = false,
	["Force"] = true,
}

local function containsUI(table, value)
	if table == nil then return false end
    table = ui.get(table)
    for i=1, #table do
        if table[i] == value then
            return true
        end
    end
    return false
end

local function handle_menu()
    --default stuff
    local default_set = ui.get(menu.menuManager) == "Default"
    ui.set_visible(refs.enabled, default_set)
    ui.set_visible(refs.pitch, default_set)
    ui.set_visible(refs.yawbase, default_set)
    ui.set_visible(refs.yaw[1], default_set)
    ui.set_visible(refs.yaw[2], default_set)
    ui.set_visible(refs.fsbodyyaw, default_set)
    ui.set_visible(refs.edgeyaw, default_set)
    ui.set_visible(refs.yawjitter[1], default_set)
    ui.set_visible(refs.yawjitter[2], default_set)
    ui.set_visible(refs.bodyyaw[1], default_set)
    ui.set_visible(refs.bodyyaw[2], default_set)
    ui.set_visible(refs.freestanding[1], default_set)
    ui.set_visible(refs.freestanding[2], default_set)
    ui.set_visible(refs.roll, default_set)
    
    --kaleidoscope stuff
    local kale_set = ui.get(menu.menuManager) == "Anti-aimbot"
    ui.set_visible(menu.aaEnable, kale_set)
    ui.set_visible(menu.legitAA, kale_set)
    ui.set_visible(menu.edgeyaw, kale_set)
    ui.set_visible(menu.bodyyaw, kale_set)

    ui.set_visible(menu.roll_force, kale_set)
    ui.set_visible(menu.roll_checkbox, kale_set)
    ui.set_visible(menu.roll_hotkey, kale_set)
    ui.set_visible(menu.disablers, kale_set)
    ui.set_visible(menu.disablers_hk, kale_set)
    ui.set_visible(menu.velocity_slider, kale_set)

    if ui.get(menu.menuManager) == "Anti-aimbot" and ui.get(menu.bodyyaw) == "Anti-bruteforce jitter" then ui.set_visible(menu.jitterslider, true) else ui.set_visible(menu.jitterslider, false) end
    ui.set_visible(menu.disablenoenemies, ui.get(menu.menuManager) == "Anti-aimbot")

    ui.set_visible(menu.crosshairIndicators, ui.get(menu.menuManager) == "Visuals")
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.crosshairIndicatorsStyle, true) else ui.set_visible(menu.crosshairIndicatorsStyle, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.indicatorsSelect, true) else ui.set_visible(menu.indicatorsSelect, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.deltaIndicator, true) else ui.set_visible(menu.deltaIndicator, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.watermarkLabel, true) else ui.set_visible(menu.watermarkLabel, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.watermarkcolor, true) else ui.set_visible(menu.watermarkcolor, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.activeIndicatorLabel, true) else ui.set_visible(menu.activeIndicatorLabel, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.activeIndicator, true) else ui.set_visible(menu.activeIndicator, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.inactiveIndicatorLabel, true) else ui.set_visible(menu.inactiveIndicatorLabel, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.inactiveIndicator, true) else ui.set_visible(menu.inactiveIndicator, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.realIndicatorLabel, true) else ui.set_visible(menu.realIndicatorLabel, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.realIndicator, true) else ui.set_visible(menu.realIndicator, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.fakeIndicatorLabel, true) else ui.set_visible(menu.fakeIndicatorLabel, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.crosshairIndicators) then ui.set_visible(menu.fakeIndicator, true) else ui.set_visible(menu.fakeIndicator, false) end

    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.legitbotMaster) then ui.set_visible(menu.triggerIndicatorLabel, true) else ui.set_visible(menu.triggerIndicatorLabel, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.legitbotMaster) then ui.set_visible(menu.triggerIndicator, true) else ui.set_visible(menu.triggerIndicator, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.legitbotMaster) then ui.set_visible(menu.awallIndicatorLabel, true) else ui.set_visible(menu.awallIndicatorLabel, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.legitbotMaster) then ui.set_visible(menu.awallIndicator, true) else ui.set_visible(menu.awallIndicator, false) end

    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.logger) then ui.set_visible(menu.loggerhitlabel, true) else ui.set_visible(menu.loggerhitlabel, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.logger) then ui.set_visible(menu.loggerhit, true) else ui.set_visible(menu.loggerhit, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.logger) then ui.set_visible(menu.loggermisslabel, true) else ui.set_visible(menu.loggermisslabel, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.logger) then ui.set_visible(menu.loggermiss, true) else ui.set_visible(menu.loggermiss, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.logger) then ui.set_visible(menu.loggeraccentlabel, true) else ui.set_visible(menu.loggeraccentlabel, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.logger) then ui.set_visible(menu.loggeraccent, true) else ui.set_visible(menu.loggeraccent, false) end

    ui.set_visible(menu.snaplines, ui.get(menu.menuManager) == "Visuals")
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.snaplines) then ui.set_visible(menu.snaplinesselect, true) else ui.set_visible(menu.snaplinesselect, false) end
    if ui.get(menu.menuManager) == "Visuals" and ui.get(menu.snaplines) then ui.set_visible(menu.snaplinescolor, true) else ui.set_visible(menu.snaplinescolor, false) end
    ui.set_visible(menu.scopematerial, ui.get(menu.menuManager) == "Visuals")
    --ui.set_visible(menu.hitlerToggle, ui.get(menu.menuManager) == "Visuals")

    ui.set_visible(menu.logger, ui.get(menu.menuManager) == "Other")
    ui.set_visible(menu.loggerslider, ui.get(menu.menuManager) == "Other")
    ui.set_visible(menu.loggerinfo, ui.get(menu.menuManager) == "Other")
    ui.set_visible(menu.bombtimer, ui.get(menu.menuManager) == "Other")
    ui.set_visible(menu.clantag, ui.get(menu.menuManager) == "Other")
    ui.set_visible(menu.chatspammer, ui.get(menu.menuManager) == "Other")
    ui.set_visible(menu.hudEnable, ui.get(menu.menuManager) == "Other")
    ui.set_visible(menu.hudColor, ui.get(menu.menuManager) == "Other")
    ui.set_visible(menu.hudOffsetx, ui.get(menu.menuManager) == "Other")

    ui.set_visible(menu.semirageMaster, ui.get(menu.legitbotMaster))
    ui.set_visible(menu.afire, ui.get(menu.legitbotMaster))
    ui.set_visible(menu.awall, ui.get(menu.legitbotMaster))
    ui.set_visible(menu.preferbody, ui.get(menu.legitbotMaster))
    ui.set_visible(menu.maxfov, ui.get(menu.legitbotMaster))
    ui.set_visible(menu.fovfactor, ui.get(menu.legitbotMaster))
    ui.set_visible(menu.weaponselect, ui.get(menu.legitbotMaster))
    ui.set_visible(menu.semirageaa, ui.get(menu.legitbotMaster))
    ui.set_visible(menu.displaycorrected, ui.get(menu.legitbotMaster))
    ui.set_visible(menu.noscopeindicator, ui.get(menu.legitbotMaster))
    ui.set_visible(menu.noscopeindicatorclr, ui.get(menu.legitbotMaster))
    if ui.get(menu.legitbotMaster) and ui.get(menu.noscopeindicator) then ui.set_visible(menu.hitchancerestore, true) else ui.set_visible(menu.hitchancerestore, false) end  
    ui.set_visible(menu.scopeOverlay, ui.get(menu.legitbotMaster))
    ui.set_visible(menu.scopeOverlayclr, ui.get(menu.legitbotMaster))

   -- if ui.reference("Rage", "Aimbot", "Dormant indicator") then
   --     ui.set(ui.reference("Rage", "Aimbot", "Dormant indicator"), false)
   --     ui.set_visible(ui.reference("Rage", "Aimbot", "Dormant indicator"), false)
   -- end
end
handle_menu()

--math funcs
local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end

local function distance3d(x1, y1, z1, x2, y2, z2)
	return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end

local function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
  
    if seconds <= 0 then
          return "00:00";
    else
          hours = 0
          mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
          secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
          return mins..":"..secs
    end
end

local function clamp(min, max, value)
    return math.max(min < max and min or max, math.min(min < max and max or min, value))
end

function boolToInt(value) return value and 1 or 0 end
  
local function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

local function make_even(x)
	return bit.band(x + 1, bit.bnot(1))
end

local function isDefusing()
    local distance = 100
    local bomb = entity.get_all("CPlantedC4")[1]
    local bomb_x, bomb_y, bomb_z = entity.get_prop(bomb, "m_vecOrigin")

    if bomb_x ~= nil then
        local player_x, player_y, player_z = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        distance = distance3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
    end
    
    local team_num = entity.get_prop(entity.get_local_player(), "m_iTeamNum")
    local defusing = team_num == 3 and distance < 62
    return defusing
end

local function contains(table, value) for i=1,#table do if table[i] == value then return true end end return false end

local function intersect(cx, cy, x, y, w, h) 
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function averageTable(tbl)
	if #tbl == 0 then return 0 end
	local sum = 0
	for i = 1, #tbl do 
		sum = sum + tbl[i]
	end
	return summed / #tbl
end

local function formatTable(tbl, json)
	local mystring = ''
	if json == true then
		for i=1, #tbl do
			if i == #tbl then
				mystring = mystring .. '"' .. tostring(tbl[i]) .. '"'
			else
				mystring = mystring .. '"' .. tostring(tbl[i]) .. '",'
			end
		end
	else
		table.sort(tbl)
		for i = #tbl, 1, -1 do
			if tbl[i] == '' then table.remove(tbl, i) end
		end
		for i=1, #tbl do
			if i == #tbl then
				mystring = mystring .. tbl[i]
			else
				mystring = mystring .. tbl[i] .. ','
			end
		end
	end
	return mystring
end

local function sendToChat(table, delay)
    if delay == nil then delay = 1 end
    for i=1, #table do
        client.delay_call(i * delay, client.exec, "say " .. table[i]) 
    end
end

local function vectorDist(A,B,C)
    local d = (A-B) / A:dist(B)
    local v = C - B
    local t = v:dot(d) 
    local P = B + d:scaled(t)
    
    return P:dist(C)
end

local function sendLogToChat(log)
    local left = {id = 0x01, pressed = false}
    local right = {id = 0x02, pressed = false}

    if client.key_state(left.id) then 
        if not left.pressed then
            if log ~= nil then
                client.exec("Say ", tostring(log))
            end
        end
        left.pressed = true
    else
        left.pressed = false
    end
end

local function drawInfo(posx, posy)
    if stats.totalshots == 0 then
        stats.hitrate = 0
    else
       stats.hitrate = round(stats.totalhits / stats.totalshots * 100, 2)
    end

    local stattable = {
        "Shots: " .. stats.totalshots .. " | Hits: " .. stats.totalhits .. " | Misses: " .. stats.totalmisses .. " | Hitrate: " .. stats.hitrate .. "%",
        "Maximum accuracy boost: " .. stats.maxbacktrack .."ms | " .. " Shots below minimum damage: " .. stats.belowmindmg,
        "Unknown misses: " .. stats.unknownmisses .. " | Spread misses: " .. stats.spreadmisses .. " | Prediction error misses: " .. stats.predictionmisses,
    }

    local items = #stattable - 2
    local guiw, guih = mx / 3, 44 + (items * 12)
    
    la_r, la_g, la_b, la_a = ui.get(menu.loggeraccent)

    renderer.circle(posx + 5, posy + 5, 0, 0, 0, 125, 5, 180, .25) --left
    renderer.circle(posx + guiw - 5, posy + 5, 0, 0, 0, 125, 5, 90, .25)--right
    renderer.circle(posx + 5, posy + guih - 5, 0, 0, 0, 125, 5, 270, .25)--left 
    renderer.circle(posx + guiw - 5, posy + guih - 5, 0, 0, 0, 125, 5, 0, .25)--right

    surface.draw_filled_rect(posx + 5, posy, guiw - 10, 5, 0, 0, 0, 190) --t
    surface.draw_filled_rect(posx + 5, posy + guih - 5, guiw - 10, 5, 0, 0, 0, 190) --b
    surface.draw_filled_rect(posx, posy + 5, 5, guih - 10, 0, 0, 0, 190) --l
    surface.draw_filled_rect(posx + guiw - 5, posy + 5, 5, guih - 10, 0, 0, 0, 190) --r
    renderer.blur(posx, posy, guiw, guih, 0, 0, 0, 155)
    surface.draw_filled_rect(posx + 5, posy + 5, guiw - 10, guih - 10, 0, 0, 0, 190)--bg

    renderer.rectangle(posx + 5, posy, guiw - 10, 2, la_r, la_g, la_b, la_a)
    renderer.circle_outline(posx + 5, posy + 5, la_r, la_g, la_b, la_a, 5, 180, .25, 2) --left
    renderer.circle_outline(posx + guiw - 5, posy + 5, la_r, la_g, la_b, la_a, 5, 270, .25, 2)
    renderer.gradient(posx, posy + 5, 2, guih - 10, la_r, la_g, la_b, la_a, 0, 0, 0, 0, false)--left
    renderer.gradient(posx + guiw - 2, posy + 5, 2, guih - 10, la_r, la_g, la_b, la_a, 0, 0, 0, 0, false)--right

    

    for i=1, #stattable do
        local tw, th = surface.get_text_size(fonts.logsdata, stattable[i])
        surface.draw_text(posx - tw/2 + guiw/2, posy + 10 + ((i-1) * 12), 255, 255, 255, 255, fonts.logsdata, stattable[i])
    end

    if ui.is_menu_open() then 
        local mousex, mousey = ui.mouse_position()
        if client.key_state(0x04) and intersect(mousex, mousey, posx, posy, guiw, guih) then 
            infox = mousex - guiw/2
            infoy = mousey - guih/2
            if infox <= 20 then infox = 20 end
            if infoy <= 20 then infoy = 20 end
            database.write('hitlerhud_logger_info_box', {infox, infoy})
        end
    end
end

local function drawBombtimer()
    if not ui.get(menu.bombtimer) then return end

    local m_c4 = entity.get_all("CPlantedC4")
    if #m_c4 == 0 then 
        bombinfo.planted = false
         if bombinfo.alpha == 0 then return end
    end

    for _, i in ipairs(m_c4) do


        local site = entity.get_prop(i, "m_nBombSite")
        if site == 1 then bombinfo.site = "B" else bombinfo.site = "A" end

        local explodetime = entity.get_prop(i, "m_flC4Blow")
        bombinfo.explodetime = entity.get_prop(i, "m_flTimerLength")
        bombinfo.timetoexplode = explodetime - globals.curtime()
        if bombinfo.timetoexplode < 0 then bombinfo.timetoexplode = 0 end
        
        local defuselength = entity.get_prop(i, "m_flDefuseLength")
        local hasdefuser = entity.get_prop(i, "m_hBombDefuser")
        local defused = entity.get_prop(i, "m_bBombDefused")
        if hasdefuser ~= nil then bombinfo.defusing = true else bombinfo.defusing = false end
        if defused == 1 then bombinfo.defused = true else bombinfo.defused = false end
        -- If no one is defusing then the length is 0
        if defuselength > 0 then
            local defusecountdown = entity.get_prop(i, "m_flDefuseCountDown")
            bombinfo.defusetime = defuselength
            bombinfo.timetodefuse = defusecountdown - globals.curtime()
            if bombinfo.timetodefuse < 0 then bombinfo.timetodefuse = 0 end
        else
            bombinfo.timetodefuse = 0
        end
        
    end
    if bombinfo.timetoexplode > 0 and not bombinfo.defused then
        bombinfo.alpha = bombinfo.alpha + 1
        bombinfo.alphatext = bombinfo.alphatext + 1
    elseif bombinfo.defused or bombinfo.timetoexplode == 0 then
        bombinfo.timeto_explode = 0
        bombinfo.alpha = bombinfo.alpha - 1
        bombinfo.alphatext = bombinfo.alphatext - 1
        bombinfo.alphadefuse = bombinfo.alphadefuse - 1
        bombinfo.alphatextdefuse = bombinfo.alphatextdefuse - 1
    end

    if bombinfo.defusing then
        bombinfo.alphadefuse = bombinfo.alphadefuse + 1
        bombinfo.alphatextdefuse = bombinfo.alphatextdefuse + 1
    else
        bombinfo.alphadefuse = bombinfo.alphadefuse - 1
        bombinfo.alphatextdefuse = bombinfo.alphatextdefuse - 1
    end

    bombinfo.alpha = clamp(bombinfo.alpha, 0, 192)
    bombinfo.alphatext = clamp(bombinfo.alphatext, 0, 255)
    bombinfo.alphadefuse = clamp(bombinfo.alphadefuse, 0, 192)
    bombinfo.alphatextdefuse = clamp(bombinfo.alphatextdefuse, 0, 255)

    lh_r, lh_g, lh_b = ui.get(menu.loggerhit) 
    lm_r, lm_g, lm_b = ui.get(menu.loggermiss)

    local btw, bth = mx / 4, 3
    local posx, posy = mx/2 - mx/8, my/7
    surface.draw_filled_rect(posx, posy, btw, bth, 0, 0, 0, bombinfo.alpha)
    renderer.rectangle(posx, posy, btw * bombinfo.timetoexplode / bombinfo.explodetime, bth, lm_r, lm_g, lm_b, bombinfo.alpha)

    surface.draw_filled_rect(posx, posy+8, btw, bth, 0, 0, 0, bombinfo.alpha)
    renderer.rectangle(posx, posy+8, btw * bombinfo.timetodefuse / bombinfo.defusetime, 4, lh_r, lh_g, lh_b, bombinfo.alphadefuse)

end

local function insertIndicator(text, color, type)
	if text == nil then return end
	if color == nil then color = {ai_r, ai_g, ai_b,255} end
    if type == nil then type = "default" end
    if type == "inactive" then color = {ii_r, ii_g, ii_b, 255} end
    if not contains(indicators, text) then
        table.insert(indicators, text)
        table.insert(indicators_clr, color)
        table.insert(indicators_type, type)
    end
end

local function drawIndicators()
    local sw, sh = mx/2, my
    local fonttype = fonts
    if my > 1080 then 
        fonttype = fonts2k 
    end
    local indicfont = fonttype.indicators
    if ui.get(menu.crosshairIndicatorsStyle) == "Small text" then
        indicfont = fonts.smallfonts
    end
	if #indicators > 0 and #indicators_clr > 0 then
		local iterator = 0
		for k, v in pairs(indicators) do
            iterator = iterator + 1
			local tw = surface.get_text_size(indicfont, v)
            surface.draw_text((sw - tw / 2),  6 * (my / 11) + (indicatorgap / 3) + (iterator * indicatorgap), indicators_clr[iterator][1], indicators_clr[iterator][2], indicators_clr[iterator][3], indicators_clr[iterator][4], indicfont, v)
		end
	end
end

local function drawLogger()
    local offset_inc = 110 * globals.frametime()
    local alpha_inc = (225/0.25) * globals.frametime()
    local offset = 0

    local fonttype = fonts
    if my > 1080 then fonttype = fonts2k end

    for i=#loggerdata.text, 1, -1 do
        if loggerdata.text[1] ~=nil then
            local loggeranim = {
                table_text,
                max_alpha,
                old_offset,
                new_offset,
                raw_text,

            }
            loggeranim.table_text = loggerdata.text[i]

            loggeranim.max_alpha = loggerdata.alpha[i]
            loggerdata.alpha[i] = clamp(0, 255, loggerdata.time[i] < globals.realtime() and loggeranim.max_alpha - alpha_inc or loggeranim.max_alpha + alpha_inc)

            loggeranim.old_offset = loggerdata.offset[i]
            if loggeranim.old_offset ~= offset then
                loggerdata.offset[i] = clamp(0, offset, loggeranim.old_offset < offset and loggeranim.old_offset + offset_inc or offset)
            end

            loggeranim.new_offset = loggerdata.offset[i]

            loggeranim.raw_text = ""

            for i2=1, #loggeranim.table_text do
                loggeranim.raw_text = loggeranim.raw_text .. loggeranim.table_text[i2][5]
            end

            local tw, th = surface.get_text_size(fonttype.logs, loggeranim.raw_text)

            local percent = 1-(loggeranim.max_alpha/255)
            local y_offset = loggerdata.time[i] > globals.realtime() and -percent*14 or percent*14

            local text_offset = 0
            for i2=1, #loggeranim.table_text do
                local cur_table_text = loggeranim.table_text[i2]
                local text_size = {surface.get_text_size(fonttype.logs, cur_table_text[5])}
                surface.draw_text(mx/2 - tw/2 + text_offset, 7 * (my/9) + loggeranim.new_offset + y_offset, cur_table_text[1], cur_table_text[2] ,cur_table_text[3], clamp(0, loggeranim.max_alpha, cur_table_text[4]), fonttype.logs, cur_table_text[5])
                text_offset = text_offset + text_size[1]
            --surface.draw_text(mx/2 - tw / 2,7 * (my/9) - th/2 + (i * indicatorgap), 255, 255, 255, loggerdata.loggeralpha[i], fonttype.logs, loggerdata.logger[i+1])
            end
            offset = offset + 14
        end
    end
    --Remove oldest logs if they're more than _ logs
    for i=1, #loggerdata.text do
        local dif_from_newest = #loggerdata.text - i 

        if dif_from_newest > 8 then
            loggerdata.time[i] = 0
        end
    end

    --Remove old logs
    for i=1, #loggerdata.text do
        if loggerdata.alpha[i] == 0 and loggerdata.time[i] < globals.realtime() then
            table.remove(loggerdata.offset, i)
            table.remove(loggerdata.alpha, i)
            table.remove(loggerdata.time, i)
            table.remove(loggerdata.text, i)
        end
    end 
end

local function createLog(time, ...)
    table.insert(loggerdata.text, {...})
    table.insert(loggerdata.offset, 0)
    table.insert(loggerdata.alpha, 0)
    table.insert(loggerdata.time, globals.realtime() + time)
end

local function removeShotData(id)
    for i=1, #aim_fire_logs.id do
        if aim_fire_logs.id[i] == id then
            table.remove(aim_fire_logs.target, i)
            table.remove(aim_fire_logs.backtrack, i)
            table.remove(aim_fire_logs.pred_hc, i)
            table.remove(aim_fire_logs.pred_hb, i)
            table.remove(aim_fire_logs.pred_dmg, i)
            table.remove(aim_fire_logs.id, i)
        end
    end
end




local function drawScopeOutline()
    if entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 0 then return end
    local velocity = 0
    if entity.get_local_player() ~= nil then
        local vx, vy = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
        if vx ~= nil and vy ~= nil then
            velocity = math.floor(math.min(10000, math.sqrt(vx*vx + vy*vy) + .5))
        end
    end
    local radius = my / 2.4
    if velocity > 3 then radius = radius - (velocity / 3) end
    so_r, so_g, so_b = ui.get(menu.scopeOverlayclr)
    surface.draw_outlined_circle(mx/2, my/2, so_r, so_g, so_b, 255, radius, 254)
end

local function getGamephase()
    local gamePhaseIdentifier = entity.get_prop(entity.get_game_rules(), "m_gamePhase")
    gamePhaseList = {
        ("W A R M U P"),
        ("F I R S T   H A L F"),
        ("S E C O N D   H A L F"),
        ("H A L F T I M E"),
        ("G A M E O V E R"),
    }
    return gamePhaseList[gamePhaseIdentifier]
end

local iterator = 0
local lasttime = 0
local function clantag()
    if ui.get(menu.clantag) then
        local tickcount = globals.tickcount() + time_to_ticks(client.latency())
	    local time = tickcount / time_to_ticks(0.9)
        local list = {
            "ϟOWNN@GE",
            "ϟOWNN@GE",
        }
        
        if lasttime + .5 < time then
            client.set_clan_tag(list[iterator%#list + 1])
            lasttime = time
            iterator = iterator + 1
        elseif lasttime > time then
            lasttime = time
        end

    end
end

local function isValid(entity)
	if entity == 0 then return false end
	if not entity.is_alive(entity) then return false end
	if entity.is_dormant(entity) then return false end

	return true
end

local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local function areEnemiesDead()
    for player=1, globals.maxplayers() do
        if entity.get_prop(entity.get_player_resource(), "m_bConnected", player) == 1 and entity.is_enemy(player) and entity.get_prop(entity.get_player_resource(), "m_bAlive", player) == 1 then
            return false
        end
    end
    return true
end

local get_attachment_vector = function(world_model)
    local me = entity.get_local_player()
    local wpn = entity.get_player_weapon(me)

    local model =
        world_model and 
        entity.get_prop(wpn, 'm_hWeaponWorldModel') or
        entity.get_prop(me, 'm_hViewModel[0]')

    if me == nil or wpn == nil then
        return
    end

    local active_weapon = fnGetClientEntity(pClientEntityList, wpn)
    local g_model = fnGetClientEntity(pClientEntityList, model)

    if active_weapon == nil or g_model == nil then
        return
    end

    local attachment_vector = ffi.new("bbvec3_t[1]")
    local att_index = world_model and
        fnGetMuzzleAttachmentIndex3stPerson(active_weapon) or
        fnGetMuzzleAttachmentIndex1stPerson(active_weapon, g_model)
    
    if att_index > 0 and fnGetAttachment(g_model, att_index, attachment_vector[0]) then
        return { attachment_vector[0].x, attachment_vector[0].y, attachment_vector[0].z }
    end
end

local function getServerIp()
	local serverip = ''
	local netchaninfo = ffi.cast("void***", get_net_channel_info(ivengineclient))
    local get_server_address = ffi.cast("get_address_t", netchaninfo[0][1])
    serverip = ffi.string(get_server_address(netchaninfo))
	if (string.find(serverip, "A:")) then
        serverip = "valve"
	elseif serverip == "loopback" then
		serverip = "localhost"
    end
	return serverip
end

local function getNearestEnemy()
    local eye = vector(client.eye_position())
    local target, idealtarget, origin, distance
    for i, player in ipairs(entity.get_players(true)) do
        target = vector(entity.hitbox_position(player, 2))
        if target.x ~= nil then
            local tx, ty = renderer.world_to_screen(target.x, target.y, target.z)
            if tx ~= nil and ty ~= nil then
                local target2d = vector(tx, ty)
                local mouse2d = vector(mx/2, my/2)
                local dist = target2d:dist2d(mouse2d)
                if (distance == nil or dist < distance) then
                    idealtarget = target
                    distance = dist
                end
            end
        end
    end
    if idealtarget ~=nil and distance ~= nil then return idealtarget, distance end
end

local function getBodyYaw()
    local cx, cy, cz = client.eye_position()
    local cpitch, cyaw = client.camera_angles()
    local targetyaw = 180
    local trace_data = {left = 0, right = 0}
    
    for i = cyaw - 90, cyaw + 90, 30 do
        if i ~= cyaw then
            local rad = math.rad(i)
            local px, py, pz = cx + 250 * math.cos(rad), cy + 250 * math.sin(rad), cz - 16

            local frac = client.trace_line(entity.get_local_player(), cx, cy, cz, px, py, pz)
            local side = i < cyaw and "left" or "right"

            trace_data[side] = trace_data[side] + frac
        end
    end
    targetyaw = trace_data.left < trace_data.right and 120 or -120
    return targetyaw
end

local function getFOV()
    if not entity.is_alive(entity.get_local_player()) then return 1 end
    local maxfov, factor = ui.get(menu.maxfov), ui.get(menu.fovfactor)
    local idealtarget = getNearestEnemy()
    local dist, scale
    if idealtarget ~= nil then 
        dist = math.floor(idealtarget:dist(vector(client.eye_position())) / 15)
    else
        dist = 75
    end
    if dist > 100 then dist = 100 end

    scale = math.floor(dist * (factor / 100)) / 100
    
    local fov = maxfov - math.floor(maxfov * scale)
    if fov < 1 then return 1
    elseif fov >= maxfov then return maxfov
    else return fov end
end

local function nearCover()
    local eyepos = vector(entity.get_origin(entity.get_local_player())) + vector(0, 0, 32)
    local cx, cy, cz = client.eye_position() 
    local cpitch, cyaw = client.camera_angles()
    local var, var2 = 40, 1
    for i = cyaw - 120, cyaw + 120, 45 do
        local rad = math.rad(i)
        local px, py, pz = cx + var * math.cos(rad), cy + var * math.sin(rad), cz - 16
        
        local fraction = client.trace_line(entity.get_local_player(), cx, cy, cz, px, py, pz)
        if fraction ~= 1 then return true end
    end
end

local function isUsing()
    classnames = {"CWorld","CCSPlayer","CFuncBrush"}
    local px, py, pz = client.eye_position()
	local pitch, yaw = client.camera_angles()
    local sin_pitch = math.sin(math.rad(pitch))
    local cos_pitch = math.cos(math.rad(pitch))
    local sin_yaw = math.sin(math.rad(yaw))
    local cos_yaw = math.cos(math.rad(yaw))
    local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }
    local fraction, entindex = client.trace_line(entity.get_local_player(), px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))

    if entindex ~= nil then
        for i=0, #classnames do
            if entity.get_classname(entindex) == classnames[i] then
                return false
            end
        end
    end
    return true
end

local function NoScope()
    local eye = vector(client.eye_position())
    local isscoped, weapon_name, m_flNextAttack, m_flNextPrimaryAttack = entity.get_prop(entity.get_local_player(), "m_bIsScoped"),  entity.get_classname(entity.get_player_weapon(entity.get_local_player())), entity.get_prop(entity.get_local_player(), "m_flNextAttack"), entity.get_prop(entity.get_local_player(), "m_flNextPrimaryAttack")
    local readytofire = false
    local fraction = 0
    local idealtarget, distance = getNearestEnemy()
    if not (math.max(0, m_flNextPrimaryAttack or 0, m_flNextAttack or 0) - globals.curtime() > 0) then
		readytofire = true
	end

    if idealtarget ~= nil and distance ~= nil then
        fraction = client.trace_line(entity.get_local_player(), eye.x, eye.y, eye.z, idealtarget.x, idealtarget.y, idealtarget.z)
        if distance <= 160 and readytofire and isscoped == 0 and fraction > 0.9 and (weapon_name == "CWeaponAWP" or weapon_name == 'CWeaponSSG08') then
            insertIndicator("NOSCOPE", {ai_r, ai_g, ai_b, 255})
            ui.set(refs.inaccuracy[1], true)
            ns_r, ns_g, ns_b, ns_a = ui.get(menu.noscopeindicatorclr)
            ui.set(refs.inaccuracy[2], ns_r, ns_g, ns_b, ns_a)
            ui.set(refs.hitchance, 0)
        else
            ui.set(refs.inaccuracy[1], false)
            ui.set(refs.hitchance, ui.get(menu.hitchancerestore))
        end
    else
        ui.set(refs.inaccuracy[1], false)
        ui.set(refs.hitchance, ui.get(menu.hitchancerestore))
    end
end

local function drawHud()
    local fonttype = fonts
    if my > 1080 then fonttype = fonts2k end

    if not ui.get(menu.hudEnable) then return end
    hr, hg, hb, ha = ui.get(menu.hudColor)
    local menuhudoffsetx = ui.get(menu.hudOffsetx)
    --time clock
    local start_time        = entity.get_prop(entity.get_game_rules(), "m_fRoundStartTime")
    local round_time        = entity.get_prop(entity.get_game_rules(), "m_iRoundTime")
    local round_calc         = SecondsToClock(round(start_time+round_time-globals.curtime()+1, 0))
    local textsizex, textsizey = surface.get_text_size(fonts.timeclock, round_calc)
    surface.draw_text(mx / 2 - (textsizex / 2), 12, hr, hg, hb, 255, fonts.timeclock, round_calc)
    textsizex, textsizey = surface.get_text_size(fonts.indicators, getGamephase())
    surface.draw_text(mx / 2 - (textsizex / 2), 42, hr, hg, hb, 255, fonts.indicators, getGamephase())

    --if local player isnt dead
    if not entity.is_alive(entity.get_local_player()) then return end

    --health
    local health, armor = entity.get_prop(entity.get_local_player(), "m_iHealth"), entity.get_prop(entity.get_local_player(), "m_ArmorValue")
    local hax, hay = surface.get_text_size(fonts.hud, health .. " HP   " .. armor .. " KEV")
    surface.draw_text(40 + menuhudoffsetx, my-70, hr, hg, hb, 255, fonts.hud, health .. " HP   " .. armor .. " KEV")

    --money
    local money = "$" ..  069
    local monx, mony = surface.get_text_size(fonts.hud, money)
    surface.draw_text(40 + menuhudoffsetx, my/7 * 3, hr, hg, hb, 255, fonts.hud, money)
    --weapon info
    local weapon_entindex = entity.get_player_weapon(entity.get_local_player())
    local weapon = csgo_weapons[entity.get_prop(weapon_entindex, "m_iItemDefinitionIndex")]
    local weapon_icon = images.get_weapon_icon(weapon)
    local weapon_name = weapon.name
    

    local weaponx, weapony = weapon_icon:measure()
    weapon_icon:draw(mx-140-menuhudoffsetx, my-100 - weapony/2, weaponx, weapony, hr, hg, hb, 255, true, "r")
        
    local weaponnamex, weaponnamey = surface.get_text_size(fonts.hud, string.upper(weapon_name))
    surface.draw_text(mx-160-menuhudoffsetx - weaponnamex, my-100 - weaponnamey/2, hr, hg, hb, 255, fonts.hud, string.upper(weapon_name))

    local weapon = entity.get_player_weapon(entity.get_local_player())
    local ammo = entity.get_prop(weapon, 'm_iClip1') or -1
    if ammo <= 0 then ammo = 0 end
    local reserve = entity.get_prop(weapon, 'm_iPrimaryReserveAmmoCount') or 0
    local ammox, ammoy = surface.get_text_size(fonts.ammo, "" .. ammo)
    local reservex, reservey = surface.get_text_size(fonts.reserve, "" .. reserve)

    if ammo ~= -1 then
        surface.draw_text(mx-150-menuhudoffsetx - (ammox), my-55 - (ammoy / 2), hr, hg, hb, 255, fonts.ammo, "" .. ammo)
        surface.draw_text(mx-140-menuhudoffsetx, my-57 - (reservey / 2), hr, hg, hb, 255, fonts.reserve, "/ " .. reserve)
    end
    
end

local function removeScope()
    materialsystem.find_material("dev/scope_bluroverlay"):set_material_var_flag(2, ui.get(menu.scopematerial))
    materialsystem.find_material("dev/engine_post"):set_material_var_flag(2, ui.get(menu.scopematerial))
end

local function snaplines()
    sl_r, sl_g, sl_b, sl_a = ui.get(menu.snaplinescolor)
    if ui.get(menu.snaplinesselect) == "Weapon attachment" then
        for _, v in pairs(entity.get_players(true)) do
            local origin = { entity.get_prop(v, "m_vecOrigin") }
            local screen_pos = { renderer.world_to_screen(origin[1], origin[2], origin[3]) }
            local pos = get_attachment_vector(ui.get(refs.force3p[2])) or 0
            if #screen_pos == 2 and pos ~= 0 then
                local x, y = renderer.world_to_screen(pos[1], pos[2], pos[3])
                renderer.line(x, y, screen_pos[1], screen_pos[2], sl_r, sl_g, sl_b, sl_a)
            end
        end
    elseif ui.get(menu.snaplinesselect) == "Screen" then
        for _, v in pairs(entity.get_players(true)) do
            local origin = { entity.get_prop(v, "m_vecOrigin") }
            local screen_pos = { renderer.world_to_screen(origin[1], origin[2], origin[3]) }
            if #screen_pos == 2 then
                renderer.line(mx/2, my, screen_pos[1], screen_pos[2], sl_r, sl_g, sl_b, sl_a)
            end
        end
    elseif ui.get(menu.snaplinesselect) == "Crosshair" then
        for _, v in pairs(entity.get_players(true)) do
            local origin = { entity.get_prop(v, "m_vecOrigin") }
            local screen_pos = { renderer.world_to_screen(origin[1], origin[2], origin[3]) }
            if #screen_pos == 2 then
                renderer.line(mx/2, my/2, screen_pos[1], screen_pos[2], sl_r, sl_g, sl_b, sl_a)
            end
        end
    end
end

local function debugVisuals()
    if containsUI(menu.debugVisuals, "Variables") then
        local eye = vector(client.eye_position())
        local fraction = 0
        local idealtarget = getNearestEnemy()
        if idealtarget ~= nil then
            fraction = client.trace_line(entity.get_local_player(), eye.x, eye.y, eye.z, idealtarget.x, idealtarget.y, idealtarget.z)
            local wx, wy = renderer.world_to_screen(idealtarget.x, idealtarget.y, idealtarget.z)
            renderer.text(wx, wy, ai_r, ai_g, ai_b, 255, "c", 0, "idealtarget")
            renderer.text(mx/3, my/2 - 140, 255, 255, 255, 255, c, 0, "fraction: " .. fraction)
        end

        local eyeangle = entity.get_prop(entity.get_local_player(), "m_angEyeAngles", 1)
        
        renderer.text(mx/3, my/2 - 100, 255, 255, 255, 255, c, 0, "Delta: " .. anti_aim.get_desync(1))
        renderer.text(mx/3, my/2 - 110, 255, 255, 255, 255, c, 0, "Body yaw: " .. ui.get(refs.bodyyaw[1]) .. " | " .. ui.get(refs.bodyyaw[2]))
        renderer.text(mx/3, my/2 - 120, 255, 255, 255, 255, c, 0, "Yaw jitter: " .. ui.get(refs.yawjitter[1]) .. " | " .. ui.get(refs.yawjitter[2]))
        renderer.text(mx/3, my/2 - 130, 255, 255, 255, 255, c, 0, "bIsScoped: " .. entity.get_prop(entity.get_local_player(), "m_bIsScoped"))
        
        renderer.text(mx/3, my/2 - 150, 255, 255, 255, 255, c, 0, "activeweptype: " .. activeweptype)
        renderer.text(mx/3, my/2 - 170, 255, 255, 255, 255, c, 0, "eye angle: " .. eyeangle) -- 
        renderer.text(mx/3, my/2 - 180, 255, 255, 255, 255, c, 0, "Weapon Class: " .. entity.get_classname(entity.get_player_weapon(entity.get_local_player())))
    end
    if containsUI(menu.debugVisuals, "getBodyYaw") then
        --wall detection
        local cx, cy, cz = client.eye_position() 
        local cpitch, cyaw = client.camera_angles()
        for i = cyaw - 90, cyaw + 90, 30 do
            local rad = math.rad(i)
            local px, py, pz = cx + 250 * math.cos(rad), cy + 250 * math.sin(rad), cz
            local bx, by = renderer.world_to_screen(cx, cy, cz - 50)
            local ex, ey = renderer.world_to_screen(px, py, pz - 50)
            if bx ~= nil and ex ~= nil then
                renderer.line(bx, by, ex, ey, fi_r, fi_b, fi_g, 50)
                renderer.circle(ex, ey, ri_r, ri_b, ri_g, 150, 3, 1, 1)
            end
        end
    end
    if containsUI(menu.debugVisuals, "nearCover") then
        --Legit Jitter
        local eyepos = vector(entity.get_origin(entity.get_local_player())) + vector(0, 0, 32)
        local cx, cy, cz = client.eye_position() 
        local cpitch, cyaw = client.camera_angles()
        local var, var2 = 40, 1
        for i = cyaw - 120, cyaw + 120, 45 do
            local rad = math.rad(i)
            local px, py, pz = cx + var * math.cos(rad), cy + var * math.sin(rad), cz - 16
            
            local orbx, orby = renderer.world_to_screen(px, py, pz)
            if orbx ~= nil and orby ~= nil then
                renderer.circle(orbx, orby, ii_r, ii_g, ii_b, 150, 3, 0, 1)
                renderer.text(orbx, orby-15, ai_r, ai_g, ai_b, 255, "c", 0, "heavenly saint " .. math.floor(rad + 1.5))
            end
        end
    end
end

local function antiAimShit(c)
    if ui.get(menu.aaEnable) then 
        handle_menu()

        --setting values
        c.allow_send_packet = true
        if ui.get(menu.disablenoenemies) then
            ui.set(refs.enabled, not areEnemiesDead())
        else
            ui.set(refs.enabled, true)
        end
        
        ui.set(refs.yaw[2], 0)
        ui.set(refs.freestanding[2], "-")
        ui.set(refs.yawjitter[1], "Off")

        --legit aa
        if ui.get(menu.legitAA) then
            ui.set(refs.pitch, "OFF")
            ui.set(refs.yaw[1], "OFF")
            ui.set(refs.bodyyaw[2], getBodyYaw())
            cvar.engine_no_focus_sleep:set_int(1)
            if not isUsing() and not isDefusing() then c.in_use = 0 end
        else
            ui.set(refs.yaw[1], "180")
            ui.set(refs.pitch, "Down")
        end

        if ui.get(menu.bodyyaw) == "Real jitter" and not nearCover() then
            ui.set(refs.bodyyaw[1], "Jitter")
            ui.set(refs.bodyyaw[2], getBodyYaw())
        end

        if ui.get(menu.bodyyaw) == "Static" then
            ui.set(refs.bodyyaw[1], "Static")
            ui.set(refs.bodyyaw[2], getBodyYaw())
        end

        if ui.get(menu.bodyyaw) == "Anti-bruteforce static" and nearCover() then
            ui.set(refs.bodyyaw[1], "Static")
            ui.set(refs.bodyyaw[2], getBodyYaw())
        end

        if ui.get(menu.bodyyaw) == "Anti-bruteforce jitter" then
            ui.set(refs.bodyyaw[1], "Static")
            ui.set(refs.bodyyaw[2], getBodyYaw())
            ui.set(refs.yawjitter[1], "Center")
            ui.set(refs.yawjitter[2], ui.get(menu.jitterslider))
        end

        local vx, vy, vz = entity.get_prop(entity.get_local_player(), "m_vecVelocity")

        local player_still = math.sqrt(vx ^ 2 + vy ^ 2) < 2
        local player_slowmo = ui.get(refs.slowmo[1]) and ui.get(refs.slowmo[2])
        local player_on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 1 and c.in_jump == 0

        local e_osaa = false
        local e_edgeyaw = false

        --Player state conditions
        if not player_on_ground then
            if containsUI(menu.edgeyaw, "Air") then 
                e_edgeyaw = true 
            end
        else
            if not ui.get(menu.legitAA) and containsUI(menu.edgeyaw, "Ground") then 
                e_edgeyaw = true 
            end
            if ui.get(menu.legitAA) and containsUI(menu.edgeyaw, "Legit AA") then 
                e_edgeyaw = true 
            end
        end

        if ui.get(refs.doubletap[2]) then 
            e_osaa = false 
        end

        ui.set(refs.edgeyaw, e_edgeyaw)
    else
        ui.set(refs.enabled, false)
    end
    
    if ui.get(menu.legitbotMaster) then
        if not ui.get(menu.semirageMaster) then 
            ui.set(menu.aaEnable, false) 
            ui.set(refs.ragebotenable[1], false)
            ui.set(refs.fakelagenable[1], false)
        end
        if ui.get(menu.semirageMaster) then
            if ui.get(menu.semirageaa) then
                ui.set(menu.aaEnable, true) 
                ui.set(menu.legitAA, "Always on")
                ui.set(refs.fakelagenable[1], true)
            else
                ui.set(menu.aaEnable, false) 
                ui.set(refs.fakelagenable[1], false)
            end
            ui.set(refs.ragebotenable[1], true)
            ui.set(refs.mindamage, 0)
            ui.set(refs.autofire, true)
            ui.set(refs.autopen, false)
            if ui.get(refs.fakelagenable[1]) and is_voice_recording(ivengineclient) then 
                c.allow_send_packet = c.chokedcommands >= 3
            elseif ui.get(refs.fakelagenable[1]) then
                c.allow_send_packet = c.chokedcommands >= ui.get(refs.fakelaglimit)
            end
            if ui.get(menu.afire) or ui.get(menu.awall) then
                
                ui.set(refs.ragebotenable[2], "Always on")
            else
                
                ui.set(refs.ragebotenable[2], "On hotkey")
            end
            if ui.get(menu.awall) then
                ui.set(refs.autopen, true)
                ui.set(refs.mindamage, 100)
            end
            --weptype
            activeweptype = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))
            
            if containsUI(menu.weaponselect, "Sniper") then
                table.insert(weaponwhitelist, "CWeaponAWP")
                table.insert(weaponwhitelist, "CWeaponSSG08")
                table.insert(weaponwhitelist, "CWeaponG3SG1")
                table.insert(weaponwhitelist, "CWeaponSCAR20") 
            end
            if containsUI(menu.weaponselect, "Pistol") then
                table.insert(weaponwhitelist, "CDEagle")
                table.insert(weaponwhitelist, "CWeaponGlock")
                table.insert(weaponwhitelist, "CWeaponHKP2000")
                table.insert(weaponwhitelist, "CWeaponElite")
                table.insert(weaponwhitelist, "CWeaponTec9")
                table.insert(weaponwhitelist, "CWeaponP250")
                table.insert(weaponwhitelist, "CWeaponFiveSeven")
            end
            if containsUI(menu.weaponselect, "Rifle") then
                table.insert(weaponwhitelist, "CAK47")
                table.insert(weaponwhitelist, "CWeaponM4A1")
                table.insert(weaponwhitelist, "CWeaponM4A1")
                table.insert(weaponwhitelist, "CWeaponSG556")
                table.insert(weaponwhitelist, "CWeaponGalilAR")
                table.insert(weaponwhitelist, "CWeaponFamas")
                table.insert(weaponwhitelist, "CWeaponAug")
                table.insert(weaponwhitelist, "CWeaponM249")
                table.insert(weaponwhitelist, "CWeaponNegev")
            end
            if not contains(weaponwhitelist, activeweptype) then 
                ui.set(refs.ragebotenable[1], false)
            end
        end
        
        if not ui.get(menu.noscopeindicator) then 
            ui.set(refs.inaccuracy[1], false) 
        end

        ui.set(refs.scopeOverlay, ui.get(menu.scopeOverlay))
        ui.set(refs.preferbodyaim, ui.get(menu.preferbody))
    end
end

local function crosshairIndicators()
    local fonttype = fonts
    indicatorgap = 14
    if my > 1080 then 
        fonttype = fonts2k 
        indicatorgap = 18
    end
    local wmfont = fonttype.watermark
    local deltafont = fonttype.numindicators
    local arrowfont = fonttype.arrows
    local wmtxt = ""
    local itxt = {">", "<"}

    if ui.get(menu.crosshairIndicatorsStyle) == "Classic" then
        wmtxt = "OWNN@GE"
    elseif ui.get(menu.crosshairIndicatorsStyle) == "Kaleidoscope" then
        wmtxt = "OWNN@GE"
    elseif ui.get(menu.crosshairIndicatorsStyle) == "Small text" then
        wmtxt = "OWNN@GE"
        wmfont = fonts.smallfonts2
        arrowfont = fonts.smallfonts2
        deltafont = fonts.smallfonts
        indicatorgap = 10
    end
    
    if entity.is_alive(entity.get_local_player()) then
        if ui.get(menu.crosshairIndicators) then 
            if containsUI(menu.indicatorsSelect, "On-shot anti aim") and ui.get(refs.onshotaa[1]) then 
                insertIndicator("ONSHOT AA")
            end
            drawIndicators()
            
            local wmx, wmy = surface.get_text_size(wmfont, wmtxt)
            local fi = surface.get_text_size(arrowfont, itxt[1])
            
            if ui.get(menu.deltaIndicator) and ui.get(menu.aaEnable) then
                local delta = round(anti_aim.get_desync(1), 2)
                local td = surface.get_text_size(deltafont, string.format(delta))
                surface.draw_text(mx / 2 - td / 2, 6 * (my / 11) - 4*(indicatorgap/5), ai_r, ai_g, ai_b, 255, deltafont, string.format(delta)) 
            end
            surface.draw_text(mx / 2 - wmx / 2, 6 * (my / 11), wm_r, wm_g, wm_b, 255, wmfont, wmtxt)

            if ui.get(refs.enabled) then
                if ui.get(menu.legitAA) then
                    if ui.get(refs.bodyyaw[2]) > 0 then
                        surface.draw_text(mx / 2 - fi / 2 + 2*(wmx/3),6 * (my / 11), ri_r, ri_g, ri_b, 255, arrowfont, itxt[1])
                        surface.draw_text(mx / 2 - fi / 2 - 2*(wmx/3),6 * (my / 11), fi_r, fi_g, fi_b, 255, arrowfont, itxt[2])
                    elseif ui.get(refs.bodyyaw[2]) < 0 then
                        surface.draw_text(mx / 2 - fi / 2 + 2*(wmx/3),6 * (my / 11), fi_r, fi_g, fi_b, 255, arrowfont, itxt[1])
                        surface.draw_text(mx / 2 - fi / 2 - 2*(wmx/3),6 * (my / 11), ri_r, ri_g, ri_b, 255, arrowfont, itxt[2])
                    end
                else 
                    if ui.get(refs.bodyyaw[2]) > 0 then
                        surface.draw_text(mx / 2 - fi / 2 + 2*(wmx/3),6 * (my / 11), fi_r, fi_g, fi_b, 255, arrowfont, itxt[1])
                        surface.draw_text(mx / 2 - fi / 2 - 2*(wmx/3),6 * (my / 11), ri_r, ri_g, ri_b, 255, arrowfont, itxt[2])
                    elseif ui.get(refs.bodyyaw[2]) < 0 then
                        surface.draw_text(mx / 2 - fi / 2 + 2*(wmx/3),6 * (my / 11), ri_r, ri_g, ri_b, 255, arrowfont, itxt[1])
                        surface.draw_text(mx / 2 - fi / 2 - 2*(wmx/3),6 * (my / 11), fi_r, fi_g, fi_b, 255, arrowfont, itxt[2])
                    end
                end
            end
            indicators = {}
            indicators_clr = {}
            indicators_type = {}
        end
        
        if ui.get(menu.snaplines) then snaplines() end
    end
end

local function setup_command(c)
    removeScope()
    
    --hud stuff
    cvar.cl_draw_only_deathnotices:set_int(boolToInt(ui.get(menu.hudEnable)))

end

local function indicator(e)
    if not contains(indicators, e) and ui.get(menu.crosshairIndicators) then 
        local etext = e.text
        if etext == "DT" then 
            if e.b < 255 and e.g < 255 then
                insertIndicator("DOUBLE TAP", {ii_r, ii_g, ii_b, 255})
            else
                insertIndicator("DOUBLE TAP", {ai_r, ai_g, ai_b, 255})
            end
        else 
            if string.find(etext, "A - ") or string.find(etext, "B - ") or string.find(etext, "Bombsite")  then 
                --nothing 
            else
                insertIndicator(etext:upper(), {ai_r, ai_g, ai_b, 255})
            end
        end
	end
end

local function bullet_impact(e)
    local shooter = client.userid_to_entindex(e.userid)
    if not ui.get(menu.bodyyaw) == "Anti-bruteforce jitter" or nearCover() then return end
    if not entity.is_enemy(shooter) or not entity.is_alive(entity.get_local_player()) then return end

    local shot_start_pos 	= vector(entity.get_prop(shooter, "m_vecOrigin"))
	shot_start_pos.z 		= shot_start_pos.z + entity.get_prop(shooter, "m_vecViewOffset[2]")
	local eye_pos			= vector(client.eye_position())
	local shot_end_pos 		= vector(e.x, e.y, e.z)
	local closest			= vectorDist(shot_start_pos, shot_end_pos, eye_pos)

    if closest < 32 then 
        local bruteforcetable = {120, 120, -120, 180, -180}
        local bruteforcetableroll = {45, 45, -45, 45, -45}
        ui.set(refs.bodyyaw[2], bruteforcetable[(impactiterator % #bruteforcetable) + 1])
        --ui.set(refs.roll, bruteforcetableroll[(impactiterator % #bruteforcetableroll) + 1])
        impactiterator = impactiterator + 1
    end
end

local function aim_fire(e)
    if not ui.get(menu.logger) then return end
    local tickcount, tickinterval = globals.tickcount(), globals.tickinterval()
    local backtrack = math.floor(((tickcount - e.tick) * tickinterval) * 1000) or 0
    backtrack = math.max(0, backtrack)
    if not contains(aim_fire_logs.id, e.id) then
        table.insert(aim_fire_logs.id, e.id)
        table.insert(aim_fire_logs.pred_hc, e.hit_chance)
        table.insert(aim_fire_logs.pred_hb, e.hitgroup)
        table.insert(aim_fire_logs.pred_dmg, e.damage)
        table.insert(aim_fire_logs.backtrack, backtrack)
        table.insert(aim_fire_logs.target, string.sub(entity.get_player_name(e.target), 1, 16))

        aim_fire_storage[e.id] = {
            pred_hc = math.floor(e.hit_chance * 100 + .5) / 100,
            pred_hb = e.hitgroup,
            pred_dmg = e.damage,
            backtrack = backtrack,
        }
    end
    stats.totalshots = stats.totalshots + 1
end

local function aim_hit(e)
    if not ui.get(menu.logger) then return end
    
    if contains(aim_fire_logs.id, e.id) then
        local pred_hc, pred_hb, pred_dmg = aim_fire_storage[e.id].pred_hc, aim_fire_storage[e.id].pred_hb, aim_fire_storage[e.id].pred_dmg
        pred_hb = hitgroup_names[pred_hb + 1]
        local target = entity.get_player_name(e.target)
        for char in target:gmatch("[%z\128-\255\128-\255][\128-\255]*") do
            target = target:gsub(char, '')
        end
        local hitbox, damage, health, backtrack = hitgroup_names[e.hitgroup + 1], e.damage, string.format(entity.get_prop(e.target, "m_iHealth")) or "0", aim_fire_storage[e.id].backtrack
        local tc1, tc2 = {255, 255, 255, 255}, {lh_r, lh_g, lh_b, 255}
        print("Hit " .. target .. " in the " .. hitbox .. " for " .. damage .. " damage (Target: " .. pred_hb .. " " .. pred_hc .. "% health: " .. health .. " backtrack: " .. backtrack .. "ms )")
        createLog(ui.get(menu.loggerslider),
            {tc1[1],tc1[1],tc1[1],tc1[1], " Hit "},
            {tc2[1],tc2[2],tc2[3],tc2[4], target},
            {tc1[1],tc1[1],tc1[1],tc1[1], " in the "},
            {tc2[1],tc2[2],tc2[3],tc2[4], hitbox},
            {tc1[1],tc1[1],tc1[1],tc1[1], " for "},
            {tc2[1],tc2[2],tc2[3],tc2[4], ""..damage},
            {tc1[1],tc1[1],tc1[1],tc1[1], " damage ( "},
            {tc2[1],tc2[2],tc2[3],tc2[4], ""..health},
            {tc1[1],tc1[1],tc1[1],tc1[1], " health remaining )"}
            --{tc1[1],tc1[1],tc1[1],tc1[1], " Hit "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], target},
            --{tc1[1],tc1[1],tc1[1],tc1[1], " in the "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], hitbox},
            --{tc1[1],tc1[1],tc1[1],tc1[1], " for "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], ""..damage},
            --{tc1[1],tc1[1],tc1[1],tc1[1], " damage ( HB: "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], ""..pred_hb},
            --{tc1[1],tc1[1],tc1[1],tc1[1], " HC: "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], "".. pred_hc},
            --{tc1[1],tc1[1],tc1[1],tc1[1], " HP: "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], health},
            --{tc1[1],tc1[1],tc1[1],tc1[1], " BT: "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], backtrack.."ms"},
            --{tc1[1],tc1[1],tc1[1],tc1[1], " )"}
        )
        stats.totalhits = stats.totalhits + 1
        if stats.maxbacktrack < backtrack then stats.maxbacktrack = backtrack end
        if damage < pred_dmg then stats.belowmindmg = stats.belowmindmg + 1 end
        removeShotData(e.id)
    end
end

local function aim_miss(e)
    if not ui.get(menu.logger) then return end
    
    local pred_hc, pred_hb, pred_dmg = aim_fire_storage[e.id].pred_hc, aim_fire_storage[e.id].pred_hb, aim_fire_storage[e.id].pred_dmg
    pred_hb = hitgroup_names[pred_hb + 1]
    local target = entity.get_player_name(e.target)
    for char in target:gmatch("[%z\128-\255\128-\255][\128-\255]*") do
        target = target:gsub(char, '')
    end
    local hitbox, damage, health, reason = hitgroup_names[e.hitgroup + 1], e.damage, entity.get_prop(target, "m_iHealth") or "0", e.reason
    local tc1, tc2 = {255, 255, 255, 255}, {lm_r, lm_g, lm_b, 255}
    if reason == '?' then reason = "unknown" end
    if reason == 'death' and entity.get_prop(entity.get_local_player(), "m_iHealth") == 0 then reason = "ping" end

    if contains(aim_fire_logs.id, e.id) then
        print("Missed " .. target .. " in the " .. hitbox .. " due to " .. reason .. " ( DMG: " .. pred_dmg .. "  HB: " .. pred_hb .. " HC: " .. pred_hc .. " )")
        createLog(ui.get(menu.loggerslider),

            {tc1[1],tc1[1],tc1[1],tc1[1], "Missed "},
            {tc2[1],tc2[2],tc2[3],tc2[4], target},
            {tc1[1],tc1[1],tc1[1],tc1[1], " in the "},
            {tc2[1],tc2[2],tc2[3],tc2[4], hitbox},
            {tc1[1],tc1[1],tc1[1],tc1[1], " due to "},
            {tc2[1],tc2[2],tc2[3],tc2[4], reason},
            {tc1[1],tc1[1],tc1[1],tc1[1], "."}

            --{tc1[1],tc1[1],tc1[1],tc1[1], "Missed "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], target},
            --{tc1[1],tc1[1],tc1[1],tc1[1], " in the "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], hitbox},
            --{tc1[1],tc1[1],tc1[1],tc1[1], " due to "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], reason},
            --{tc1[1],tc1[1],tc1[1],tc1[1], " ( DMG: "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], ""..pred_dmg},
            --{tc1[1],tc1[1],tc1[1],tc1[1], "  HB: "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], ""..pred_hb},
            --{tc1[1],tc1[1],tc1[1],tc1[1], " HC: "},
            --{tc2[1],tc2[2],tc2[3],tc2[4], ""..pred_hc},
            --{tc1[1],tc1[1],tc1[1],tc1[1], " )"}
        )
        stats.totalmisses = stats.totalmisses + 1
        if reason == "unknown" then stats.unknownmisses = stats.unknownmisses + 1 end
        if reason == "spread" then stats.spreadmisses = stats.spreadmisses + 1 end
        if reason == "prediction error" then stats.predictionmisses = stats.predictionmisses + 1 end
        removeShotData(e.id)
    end
end

local function player_death(e)
        local victim = client.userid_to_entindex(e.userid)
    local attacker = client.userid_to_entindex(e.attacker)
    if victim == entity.get_local_player() then
        local target_hp = entity.get_prop(attacker, "m_iHealth")
        local target_name = entity.get_player_name(attacker)
        local tc1, tc2 = {255, 255, 255, 255}, {lm_r, lm_g, lm_b, 255}
        createLog(ui.get(menu.loggerslider),
        {tc1[1],tc1[1],tc1[1],tc1[1], "You died to "},
        {tc2[1],tc2[2],tc2[3],tc2[4], target_name}
        )
    end

    if not ui.get(menu.chatspammer) then return end
    if victim ~= entity.get_local_player() and attacker == entity.get_local_player() then
        local eyeangle = entity.get_prop(entity.get_local_player(), "m_angEyeAngles", 1)
        if eyeangle <= -85 and plist.get(victim, "Correction active") then
            local spamlist = {
                "cheats won't save you from skill",
                "Hey sometimes your opponent is just having a really good day",
                "Please dont surrender, we need the XP",
                "Maybe playing at a lower rank will be more fun for you?",
                "hands up if you queued with a cheater and thought you would get an easy win",
                "Cheaters like you ruin  the game. Is it fun to hack??",
                "Choose your excuse: 1.Lags | 2.New mouse | 3.Low FPS | 4.Russian team | 5.Hacker | 6.Lucker | 7.Smurf | 8.Hitbox | 9.Tickrate.",
                "So annoying, did we select easy bots by accident? ",
                "your pc time in the orphanage is nearly over buddy",
                "When I fucked your sister, I heard your father masturbating in the closet.",
                "NO HACK ACCOUNT CERTIFIED ✔",
                
            }
            sendToChat({"HACKER DOWN!", spamlist[client.random_int(1, #spamlist)]})
        end
    end
end

local function player_hurt(e)
    if e.weapon == 'taser' then return end
    local victim = client.userid_to_entindex(e.userid)
    local attacker = client.userid_to_entindex(e.attacker)
    
    local hitbox = hitgroup_names[e.hitgroup + 1]
    if attacker == entity.get_local_player() then
        local health = e.health
        local target = entity.get_player_name(victim)
        for char in target:gmatch("[%z\128-\255\128-\255][\128-\255]*") do
            target = target:gsub(char, '')
        end
        local damage = e.dmg_health
        local weapon
        if e.weapon == 'hegrenade' then weapon = 'Grenaded'
        elseif e.weapon == 'inferno' then weapon = 'Mollied' 
        elseif e.weapon == 'knife' then weapon = 'Knifed'
        elseif not ui.get(refs.ragebotenable[1]) then weapon = 'Hit' 
        else return end

        local tc1, tc2 = {255, 255, 255, 255}, {lh_r, lh_g, lh_b, 255}
        print(weapon .. " " .. target .. " in the " .. hitbox .. " for " .. damage .. " ( " .. health .. " health remaining )")
        createLog(ui.get(menu.loggerslider),
            {tc1[1],tc1[1],tc1[1],tc1[1], weapon .. " "},
            {tc2[1],tc2[2],tc2[3],tc2[4], target},
            {tc1[1],tc1[1],tc1[1],tc1[1], " in the "},
            {tc2[1],tc2[2],tc2[3],tc2[4], hitbox},
            {tc1[1],tc1[1],tc1[1],tc1[1], " for "},
            {tc2[1],tc2[2],tc2[3],tc2[4], ""..damage},
            {tc1[1],tc1[1],tc1[1],tc1[1], " damage ( "},
            {tc2[1],tc2[2],tc2[3],tc2[4], ""..health},
            {tc1[1],tc1[1],tc1[1],tc1[1], " health remaining )"}
        )
    end
    if victim == entity.get_local_player() and attacker ~= victim then
        local localplayer_health = e.health
        local target = entity.get_player_name(attacker)
        for char in target:gmatch("[%z\128-\255\128-\255][\128-\255]*") do
            target = target:gsub(char, '')
        end
        local tc1, tc2 = {255, 255, 255, 255}, {lm_r, lm_g, lm_b, 255}
        createLog(ui.get(menu.loggerslider),
            {tc1[1],tc1[1],tc1[1],tc1[1], "Hit by "},
            {tc2[1],tc2[2],tc2[3],tc2[4], target},
            {tc1[1],tc1[1],tc1[1],tc1[1], " for "},
            {tc2[1],tc2[2],tc2[3],tc2[4], "".. e.dmg_health},
            {tc1[1],tc1[1],tc1[1],tc1[1], " damage ( "},
            {tc2[1],tc2[2],tc2[3],tc2[4], ""..localplayer_health},
            {tc1[1],tc1[1],tc1[1],tc1[1], " health remaining ) "}
        )

        if not ui.get(menu.bodyyaw) == "Anti-bruteforce static" then return end
        local flip = ui.get(refs.bodyyaw[2]) * -1
        ui.set(refs.bodyyaw[2], flip)
        --local fliproll = ui.get(refs.roll) * -1
        --ui.set(refs.roll, fliproll)
        impactiterator = impactiterator + 1
    end
end

local function round_start()
    bombinfo.alpha = 0
    if not ui.get(menu.chatspammer) then return end
    local spamlist = {
        "NONE THE LESS GODBLESS GAMESENSE.PUB GAMESENSE.PRO ESTK WISH SKEET.CC GODBLESS EVERYONE EXCEPT SIGMA FUCK SIGMA EVERYONE HATES SIGMA",
        "OK... The gorilla I get... BUT FEMBOY!?!?!?!?! WHY IS HE A FEMBOY!!!!!????? I have truly lost all respect to the known and well beloved gorilla and I will no longer remain anywhere near 5 meters of range close to that gorilla...",
        "Hitler was very epic... R.I.P",
        "Reminder that this worthless heavenly saint was a woman beating, sexual assaulting, porn acting, animal abusing, drug dealing piece of shit who brought nothing positive to the world and only pain/misery to those around him.",
        "@Sigma#9999 Your Jordans... are FAKE",
        "i really feel like all these hoes keep bitching about gamerustsense not being back but they should really be bitching about esoterik not having a default profile picture anymore....",
        "KILL HER KILL HER KILL HER KILL HER KILL HER KILL HER KILL HER KILL HER KILL HER KILL HER KILL HER KILL HER KILL HER ",
        "cry here -> |__| <- africa needs water",
        "there is more guns than people in this country which is kinda based but then again around blacks never relax",
        "GARY I NEED SKEET RUST",
        "i was afk minimized, ragebot on, no anti aim, revolver in hand, reolver shot on its own, headshot teammate, 30 min cooldown",
        "I think you misunderstood me there a little, bud. I know exactly how Source Engine works and I'm familiar with c++/ffi in general, hence why I gave him the link to the post.",
        "I'm actually a musician and have famous friends on the billboards",
        "I am a musician and i have famous friends, so i think that makes me worth more than anyone here",
        "honestly about to make a lua to log every one of my shots so I can 'ironically' say that I have over 50'000 shot logs ",
        "any more femboy/femdom hvhers here? :sunglasses:",
        "I like to gym a lot so I am definitely stronger and more handsome than you.",
        "i have recntly learened th at... peopele like simga are threa.t to gamesustsense socity... ple ase.. ban ...... him.",
        "GOD BLESS COUNTER-STRIKE: GLOBAL OFFENSIVE SENSE AND RUST + HWID SPOOFER SENSE",
        "GET OUT OF MY HEAD GET OUT OF MY HEAD GET OUT OF MY HEAD GET OUT OF MY HEAD GET OUT OF MY HEAD GET OUT OF MY HEAD GET OUT OF MY HEAD GET OUT OF MY HEAD GET OUT OF MY HEAD ",
        "It's clearly not the top of the bubble when every single heavenly saint is talking about it. Watch any stream and they talk about Cryptos",
        "This new age, is a fucking nightmare, The only way out is through ethnic warfare, We need to find our solidarity, And a return to clarity",
        "I'm a lot smarter than you, just check my github",
        "idk what happened to the cheet, i feel like it doesnt need that much update as everyone says, maybe it's beacuse i have for month, i really don't know.",
        "I love skeet rust. Where is skeet rust.",
        "Revolver will shoot on it‘s own when you got low fps. I‘m not sure if that‘s fixable",
        "I think I will buy groceries for my mom $$$ rich boy in da house",
        "mr w&sh told me gaem ruster sense.. come back..... TOMRORROW!!!! instead..",
        "I think I'm a lot richer than you, check my robinhood portfolio",
        "SKEET RUST JUST CAME BACK! ESOTERIK TAKE MY CASH!",
        "estk is not a person, it is a multi dimensional entity",
        "WHY IS HE FUCKING BLACK??? LIKE HELLO? GAMERUSTSENSE WAKE UP AND BAN THIS AFRICAN KID...",
        "so u can right click a color picker and press 'Gay' to make it rainbow",
        "looks kinda like gamesense, makes my dick hard",
        "Thank fuck I made it from crypto and quit my job last week. How the fuck do normies manage to endure this for 50 years, how do they not kill themselves?",
        "FUCK BOOMERS ! FUCK NORMIES ! FUCK NPCS ! FUCK BANKS !! crypto all day every day",
        "WE WILL BE RICH $$$ AND WE WILL HAVE SKEET RUST :DDD",
        "WHEN I GET BACKTRACKED >:DDD",
        "Time to post another ??????????? feedback thread",
        "Send me his server's IP I will port scan him and send some nice icmp packets his way :D",
        "There are more women than BTC on the planet its simple economics",
        "Now I have skeet... and spend my time coding features for skeet :D",
        "I have no money man I have no bread all money goes to skeet sub this fkn esoterick",
        "clearshadowz: Welcome to the club bristopher NmChris: been in the club for a hot minute",
        "pimP — Today at 5:49 PM sigma you are a heavenly saint immigrant that can hardly speak english"
    }
    local string = {spamlist[client.random_int(1, #spamlist)]}
    sendToChat(string, 5)
end

local function paint()
    mx, my = client.screen_size()
    wm_r, wm_g, wm_b = ui.get(menu.watermarkcolor)
    ai_r, ai_g, ai_b = ui.get(menu.activeIndicator)
    ii_r, ii_g, ii_b = ui.get(menu.inactiveIndicator)
    fi_r, fi_g, fi_b = ui.get(menu.fakeIndicator)
    ri_r, ri_g, ri_b = ui.get(menu.realIndicator)
    lh_r, lh_g, lh_b = ui.get(menu.loggerhit)
    lm_r, lm_g, lm_b = ui.get(menu.loggermiss)
    
    crosshairIndicators()
    --legit
    if ui.get(menu.legitbotMaster) then
        if ui.get(menu.semirageMaster) then
            if ui.get(menu.awall) then
                insertIndicator("AWALL", {ap_r, ap_g, ap_b, 255})
            elseif ui.get(menu.afire) then
                insertIndicator("TRIGGER", {af_r, af_g, af_b, 255})
            else
                insertIndicator("HVH MODE", nil, "inactive")
            end
            if ui.get(refs.ragebotenable[1]) then
                ui.set(refs.maxfov, getFOV())
                insertIndicator("FOV: " .. ui.get(refs.maxfov))
            end
        end
        if ui.get(menu.noscopeindicator) then NoScope() end 
        if ui.get(menu.scopeOverlay) then drawScopeOutline() end
    end
    --Logger 
   

    if ui.get(menu.logger) then 
        drawLogger() 
        if ui.get(menu.loggerinfo) then
            drawInfo(infox, infoy)
        end
    end
    
    if entity.get_local_player() ~= nil and (not entity.is_alive(entity.get_local_player())) and globals.tickcount() % 2 == 0 then
        clantag()
    end

    --debug
    
    debugVisuals()
    --hud stuff
    drawBombtimer()
    drawHud()
end

local function shutdown()
    cvar.cl_draw_only_deathnotices:set_int(0)

    ui.set_visible(refs.enabled, true)
    ui.set_visible(refs.pitch, true)
    ui.set_visible(refs.yawbase, true)
    ui.set_visible(refs.yaw[1], true)
    ui.set_visible(refs.yaw[2], true)
    ui.set_visible(refs.fsbodyyaw, true)
    ui.set_visible(refs.edgeyaw, true)
    ui.set_visible(refs.yawjitter[1], true)
    ui.set_visible(refs.yawjitter[2], true)
    ui.set_visible(refs.bodyyaw[1], true)
    ui.set_visible(refs.bodyyaw[2], true)
    ui.set_visible(refs.freestanding[1], true)
    ui.set_visible(refs.freestanding[2], true)

    ui.set_visible(refs.legmovement, true)
    client.set_clan_tag("\0")
end

local function console_input(input)
    if string.find(input, "hh reset") then
		infox, infoy = mx/2 - mx/6, my/16
        database.write('hitlerhud_logger_info_box', {infox, infoy})
        print("Positions reset")
    end
end

local function run_command(e)
    if e.chokedcommands == 0 then 
        clantag() 
    end
end

local return_fl = return_fl
local sv_maxusrcmdprocessticks = cvar.sv_maxusrcmdprocessticks

local gamerules_ptr = client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")
local gamerules = ffi.cast("intptr_t**", ffi.cast("intptr_t", gamerules_ptr) + 2)[0]

local is_valve_ds_spoofed = 0

client.set_event_callback("setup_command", function(cmd)
    antiAimShit(cmd)

    local weapon = csgo_weapons[entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex")]

    local xv, yv, zv = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
	local velocity = math.sqrt(xv^2 + yv^2)
    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), bit.lshift(1, 0))

    local disabler_tbl = {
        {
            Name = "Quick peek assist",
            Variable = (ui.get(refs.qps + 1))
        },
        {
            Name = "Duck peek assist",
            Variable = (({ui.get(refs.dpa)})[1])
        },
        {
            Name = "Edge yaw",
            Variable = (ui.get(refs.edgeyaw))
        },
        {
            Name = "Velocity",
            Variable = (on_ground == 1 and velocity >= ui.get(menu.velocity_slider))
        },
        {
            Name = "Jump at edge",
            Variable = (({ui.get(refs.edge_jump + 1)})[1])
        },
        {
            Name = "In air",
            Variable = (on_ground == 0)
        },
    }
    
    if is_valve_ds_spoofed == 1 then
        if sv_maxusrcmdprocessticks:get_int() ~= 7 then
            if ui.get(refs.fakelaglimit) > 6 then
                return_fl = ui.get(refs.fakelaglimit)
                ui.set(refs.fakelaglimit, 6)
            end
            client.set_cvar("sv_maxusrcmdprocessticks", "7")
        end
    else
        if return_fl ~= nil then
            if ui.get(refs.fakelaglimit) ~= return_fl then
                ui.set(refs.fakelaglimit, return_fl)
                return_fl = nil
            end
        end
        if sv_maxusrcmdprocessticks:get_int() < 16 then
            client.set_cvar("sv_maxusrcmdprocessticks", "16")
        end
    end

    local roll_amount = 0
    if ui.get(menu.roll_checkbox) then  
        local max_roll = 45 - (is_valve_ds_spoofed * 6)
        roll_amount = ui.get(menu.roll_hotkey) and max_roll or -max_roll
        ui.set(refs.bodyyaw[2], ui.get(menu.roll_hotkey) and 180 or -180)
    end

    if weapon == nil then goto skip end

    if entity.get_prop(entity.get_local_player(), "m_MoveType") == 9 or weapon.type == "grenade" and velocity >= 1.01001 and on_ground == 1 or not ui.get(refs.enabled) then
        roll_amount = 0
    end
    
    for _, v in ipairs(disabler_tbl) do
        if contains(ui.get(menu.disablers), v.Name) and ui.get(menu.disablers_hk) then
            if v.Variable then
                roll_amount = 0
            end
        end
    end

    ::skip::

    local is_valve_ds = ffi.cast('bool*', gamerules[0] + 124)
    if is_valve_ds ~= nil then
        if cmd.roll ~= 0 and ui.get(menu.roll_force) then
            if is_valve_ds[0] == true then
                is_valve_ds[0] = 0
                is_valve_ds_spoofed = 1
            end
        else
            if is_valve_ds[0] == false and is_valve_ds_spoofed == 1 then
                --is_valve_ds[0] = 1
                --is_valve_ds_spoofed = 0
                roll_amount = 0
            end
        end
    end

    cmd.roll = roll_amount
    ui.set(refs.roll, roll_amount)
end)

client.set_event_callback("paint_ui", function()
    if contains(ui.get(menu.disablers), "Velocity") then
        ui.set_visible(menu.velocity_slider, true)
    else
        ui.set_visible(menu.velocity_slider, false)
    end
    if globals.mapname() == nil and entity.get_local_player() == nil then
        is_valve_ds_spoofed = 0
        if sv_maxusrcmdprocessticks:get_int() < 16 then
            client.set_cvar("sv_maxusrcmdprocessticks", 16)
        end
        if return_fl ~= nil then
            if ui.get(refs.fakelaglimit) ~= return_fl then
                ui.set(refs.fakelaglimit, return_fl)
                return_fl = nil
            end
        end
    end
    if ui.is_menu_open() then
        if sv_maxusrcmdprocessticks:get_int() < 16 then
            client.set_cvar("sv_maxusrcmdprocessticks", 16)
        end
    end
end)

client.set_event_callback("shutdown", function()
    if sv_maxusrcmdprocessticks:get_int() < 16 then
        client.set_cvar("sv_maxusrcmdprocessticks", 16)
    end
    if return_fl ~= nil then
        if ui.get(refs.fakelaglimit) ~= return_fl then
            ui.set(refs.fakelaglimit, return_fl)
        end
    end
    if globals.mapname() == nil then 
        is_valve_ds_spoofed = 0
        return
    end
    local is_valve_ds = ffi.cast('bool*', gamerules[0] + 124)
    if is_valve_ds ~= nil then
        if is_valve_ds[0] == false and is_valve_ds_spoofed == 1 then
            is_valve_ds[0] = 1
            is_valve_ds_spoofed = 0
        end
    end
end)

client.set_event_callback("pre_config_load", function()
    return_fl = nil
end)

client.set_event_callback("pre_config_save", function()
    if return_fl ~= nil then
        ui.set(refs.fakelaglimit, return_fl)
    end
end)

-- Callbacks

client.register_esp_flag("HACKER", 255, 0, 0, function(player) 
    if not ui.get(menu.displaycorrected) then return false end
    return plist.get(player, "Correction active")
end)

ui.set_callback(menu.menuManager, handle_menu)
ui.set_callback(menu.bodyyaw, handle_menu)
ui.set_callback(menu.crosshairIndicators, handle_menu)
ui.set_callback(menu.snaplines, handle_menu)
ui.set_callback(menu.logger, handle_menu)
ui.set_callback(menu.legitbotMaster, handle_menu)
ui.set_callback(menu.noscopeindicator, handle_menu)


local function callbackHandle()
    client.set_event_callback('setup_command', setup_command)
    client.set_event_callback('run_command', run_command)
    client.set_event_callback('bullet_impact', bullet_impact)
    client.set_event_callback('indicator', indicator)
    client.set_event_callback('aim_fire', aim_fire)
	client.set_event_callback('aim_hit', aim_hit)
	client.set_event_callback('aim_miss', aim_miss)
    client.set_event_callback('player_death', player_death)
    client.set_event_callback('player_hurt', player_hurt)
    client.set_event_callback('round_start', round_start)
    client.set_event_callback('paint', paint)
    client.set_event_callback('shutdown', shutdown)
    client.set_event_callback('console_input', console_input)
end
callbackHandle()