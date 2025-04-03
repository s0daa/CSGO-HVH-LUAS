_DEBUG = false

-- requires
local pui = require 'neverlose/pui'
local clipboard = require 'neverlose/clipboard'
local base64 = require 'neverlose/base64'
local gradient = require 'neverlose/gradient'
local MTools = require 'neverlose/MTools'

luaname = "taobaosync"

local font = {
    verdana_bold = render.load_font("Verdana Bold", 12, "ab"),
    verdana = render.load_font("Verdana", 24, "ab"),
}

local img = {
    cap = render.load_image(network.get("https://i.imgur.com/TcIQO6q.png"), vector(800, 900)),
    sneakers = render.load_image(network.get("https://i.imgur.com/vyypg5B.png"), vector(800, 900)),
}

pui.sidebar("\bFFFFFF\b9CD411FFF["..luaname.."]", "\f<stars>")

local tab = {
    menu = pui.create("Main", "\nMenu", 1),
    main = pui.create("Main", "Main", 2),
    main_other = pui.create("Main", "Config System", 2),
    changelog = pui.create("Main", "Changelog", 1),
    aa_presets = pui.create("Main", "Presets", 2),
    aa_builder = pui.create("Main", "Builder", 1),
    misc_features = pui.create("Main", "Misc", 1),
    rage_features = pui.create("Main", "RageBot", 2),
}

local ref = {
    enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    yaw_modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    disable_yaw_modifiers = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    onshot = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    os_options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    dt_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
    hitchance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
    mindamage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    fakelatency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
}

local menu_tab = {}
local main_tab = {}
local antiaim_tab = {}
local misc_tab = {}
local conds = {"Global", "Standing", "Moving", "Walking", "Crouching", "Air", "Air Crouching", "Fake Lag"}
local antiaims_settings = {}
local antiaim_func = {}
local visuals_func = {}
local ragebob_func = {}

-- MENU
main_tab.select_tab = tab.menu:list("\nSelect", {"Main", "Anti Aims", "Misc"})

-- MAIN
main_tab.info = tab.main:label("Hello, \v"..common.get_username().."\r. You are using \bFFFFFF\b9CD411FFF["..luaname.."]\r, the last update was \v19.05.2024! "):depend({main_tab.select_tab, 1})
main_tab.market_cfg = tab.main:button("             Config               ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=gouT13") end, true):depend({main_tab.select_tab, 1})
main_tab.market_locations = tab.main:button("        Locations          ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=TnLA7f") end, true):depend({main_tab.select_tab, 1})
main_tab.fencai_yt = tab.main:button("    \f<youtube> fencai     ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@fencai6724") end, true):depend({main_tab.select_tab, 1})
main_tab.lua_dc = tab.main:button("        \f<discord>        ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/cSehD3hjHu") end, true):depend({main_tab.select_tab, 1})
main_tab.feedx_yt = tab.main:button("   \f<youtube> feedx     ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@feedx1337") end, true):depend({main_tab.select_tab, 1})

-- CHANGELOG
main_tab.changelog = tab.changelog:label("\v~ Realese"):depend({main_tab.select_tab, 1})

-- MAIN ANTI AIMS
antiaim_tab.enabled = tab.main:switch("\f<badge-check> Enable AA"):depend({main_tab.select_tab, 2})
antiaim_tab.yaw_base = tab.main:combo("\f<child> Yaw Base", {"Local View", "At Target", "Forward", "Left", "Right"}):depend(antiaim_tab.enabled, {main_tab.select_tab, 2})
antiaim_tab.yaw_base_settings = antiaim_tab.yaw_base:create()
antiaim_tab.defensive_spam = antiaim_tab.yaw_base_settings:switch("E-Spam")
antiaim_tab.static_manuals = antiaim_tab.yaw_base_settings:switch("Static Manuals")
antiaim_tab.freestanding = tab.main:switch("\f<person> Freestanding"):depend(antiaim_tab.enabled, {main_tab.select_tab, 2})
antiaim_tab.freestanding_settings = antiaim_tab.freestanding:create()
antiaim_tab.disable_yaw_modifiers_freestanding = antiaim_tab.freestanding_settings:switch("Disable Yaw Modifiers")
antiaim_tab.tweaks = tab.main:selectable("\f<circle-sort> AA Tweaks", {"Safe Head", "Avoid Backstab", "Disable on Warmup"}):depend(antiaim_tab.enabled, {main_tab.select_tab, 2})
antiaim_tab.anim_breakers = tab.main:switch("\f<triangle-exclamation> \b666666FF\b5D6FA8FF[Anim. Breakers]"):depend(antiaim_tab.enabled, {main_tab.select_tab, 2})
antiaim_tab.anim_breakers_settings = antiaim_tab.anim_breakers:create():depend(antiaim_tab.anim_breakers)
antiaim_tab.legs_on_ground = antiaim_tab.anim_breakers_settings:combo("Legs on Ground", {"Disabled", "Static", "Jitter", "Walking"})
antiaim_tab.legs_in_air = antiaim_tab.anim_breakers_settings:combo("Legs in Air", {"Disabled", "Static", "Walking"})
antiaim_tab.other_breakers = antiaim_tab.anim_breakers_settings:selectable("Other", {"Move Lean", "Pitch 0 on Land", "AnimFucker"})
antiaim_tab.presets = tab.aa_presets:combo("\f<fire> Presets", {"Tao", "Bao", "Builder"}):depend(antiaim_tab.enabled, {main_tab.select_tab, 2})
antiaim_tab.states = tab.aa_builder:combo("\f<route-interstate> Current State", conds):depend(antiaim_tab.enabled, {antiaim_tab.presets, "Builder"}, {main_tab.select_tab, 2})

misc_tab.crosshair_inds = tab.main:switch("\f<crosshairs> Crosshair Indicators"):depend({main_tab.select_tab, 3})
misc_tab.crosshair_inds_settings = misc_tab.crosshair_inds:create():depend(misc_tab.crosshair_inds)
misc_tab.crosshair_inds_color = misc_tab.crosshair_inds_settings:color_picker("Color", color(255, 255, 255, 255))
misc_tab.dmg_indicator = tab.main:switch("\f<hundred-points> Damage Indicator"):depend({main_tab.select_tab, 3})
misc_tab.dmg_indicator_settings = misc_tab.dmg_indicator:create():depend(misc_tab.dmg_indicator)
misc_tab.dmg_indicator_styles = misc_tab.dmg_indicator_settings:combo("Style", {"Default", "Pixel", "Modern", "Bold"})
misc_tab.dmg_indicator_color = misc_tab.dmg_indicator_settings:color_picker("Color", color(255, 255, 255, 255))
misc_tab.aimdoglogging = tab.main:switch("\f<list-ol> Aimbot Logging"):depend({main_tab.select_tab, 3})
misc_tab.aimdoglogging_settings = misc_tab.aimdoglogging:create():depend(misc_tab.aimdoglogging)
misc_tab.hit = misc_tab.aimdoglogging_settings:color_picker("Hit", color(255, 255, 255, 255))
misc_tab.miss = misc_tab.aimdoglogging_settings:color_picker("Miss", color(255, 255, 255, 255))
misc_tab.log_select = misc_tab.aimdoglogging_settings:selectable("Select", {"Under Crosshair", "Console/Event"})
misc_tab.manualarrows = tab.main:switch("\f<arrows-up-down-left-right> Manual Arrows"):depend({main_tab.select_tab, 3})
misc_tab.manualarrows_settings = misc_tab.manualarrows:create()
misc_tab.manualarrows_color = misc_tab.manualarrows_settings:color_picker("Color", color(255, 255, 255, 255))

misc_tab.aspect_ratio = tab.misc_features:switch("\f<display> Aspect Ratio"):depend({main_tab.select_tab, 3})
misc_tab.aspect_ratio_settings = misc_tab.aspect_ratio:create():depend(misc_tab.aspect_ratio)
misc_tab.aspect_ratio_offset = misc_tab.aspect_ratio_settings:slider("Offset", 0, 200, 100, 0.01)
misc_tab.viewmodel_changer = tab.misc_features:switch("\f<hand-sparkles> Viewmodel Changer"):depend({main_tab.select_tab, 3})
misc_tab.viewmodel_changer_settings = misc_tab.viewmodel_changer:create():depend(misc_tab.viewmodel_changer)
misc_tab.viewmodel_offset_fov = misc_tab.viewmodel_changer_settings:slider("FOV", -100, 100, 68)
misc_tab.viewmodel_offset_x = misc_tab.viewmodel_changer_settings:slider("X", -10, 10, 2.5)
misc_tab.viewmodel_offset_y = misc_tab.viewmodel_changer_settings:slider("Y", -10, 10, 0)
misc_tab.viewmodel_offset_z = misc_tab.viewmodel_changer_settings:slider("Z", -10, 10, -1.5)
misc_tab.scope_lines = tab.misc_features:switch("\f<location-crosshairs> Scope Lines"):depend({main_tab.select_tab, 3})
misc_tab.scope_lines_settings = misc_tab.scope_lines:create():depend(misc_tab.scope_lines)
misc_tab.scope_lines_color = misc_tab.scope_lines_settings:color_picker("Color", color(255, 255, 255, 255))
misc_tab.invert_lines = misc_tab.scope_lines_settings:switch("Invert Lines")
misc_tab.lenght = misc_tab.scope_lines_settings:slider("Scope Lenght", 5, 200, 15)
misc_tab.offset = misc_tab.scope_lines_settings:slider("Scope Offset", 1, 50, 10)
misc_tab.clantag = tab.misc_features:switch("\f<tag> Clan Tag"):depend({main_tab.select_tab, 3})
misc_tab.watermark2k18 = tab.misc_features:switch("\bFFFFFFFF\b96C83CFF[2k18] \rwatermark"):depend({main_tab.select_tab, 3})
misc_tab.swag = tab.misc_features:switch("\bFFFFFFFF\b96C83CFF[🤙 SWAG 🤙]"):depend({main_tab.select_tab, 3})
misc_tab.swag_settings = misc_tab.swag:create():depend(misc_tab.swag)
misc_tab.select_swag = misc_tab.swag_settings:listable("Select", {"KEPARIK", "KROSSI"})

misc_tab.nvm_dude = tab.rage_features:switch("\f<jet-fighter> Predict"):depend({main_tab.select_tab, 3})
misc_tab.fastladder = tab.rage_features:switch("\f<water-ladder> Fast Ladder"):depend({main_tab.select_tab, 3})
misc_tab.ping_unlocker = tab.rage_features:switch("\f<unlock-keyhole> Ping Unlocker"):depend({main_tab.select_tab, 3})
misc_tab.ping_unlocker_settings = misc_tab.ping_unlocker:create():depend(misc_tab.ping_unlocker)
misc_tab.ping_unlocker_offset = misc_tab.ping_unlocker_settings:slider("Unlock", 0, 200, 100)
misc_tab.last_tick = tab.rage_features:switch("\f<jet-fighter> Last Backtrack Tick"):depend({main_tab.select_tab, 3})
misc_tab.hitchance_manipulation = tab.rage_features:switch("\f<gears> Hitchance Manipulation"):depend({main_tab.select_tab, 3})
misc_tab.hitchance_manipulation_settings = misc_tab.hitchance_manipulation:create():depend(misc_tab.hitchance_manipulation)
misc_tab.select_manipulate = misc_tab.hitchance_manipulation_settings:selectable("Select", {"In Air", "No Scope"})
misc_tab.in_air = misc_tab.hitchance_manipulation_settings:slider("In Air", 0, 100, 35):depend({misc_tab.select_manipulate, "In Air"})
misc_tab.no_scope = misc_tab.hitchance_manipulation_settings:slider("No Scope", 0, 100, 50):depend({misc_tab.select_manipulate, "No Scope"})

for q, w in pairs(conds) do
    antiaims_settings[q] = {}
    antiaims_settings[q].override_state = tab.aa_builder:switch("Override "..conds[q]..""):depend(antiaim_tab.enabled, {antiaim_tab.presets, "Builder"}, {main_tab.select_tab, 2})
    antiaims_settings[q].pitch_select = tab.aa_builder:combo("\f<head-side> Pitch", {"Disabled", "Down", "Fake Up", "Fake Down"}):depend(antiaim_tab.enabled, {antiaim_tab.presets, "Builder"}, {main_tab.select_tab, 2})
    antiaims_settings[q].yaw_select = tab.aa_builder:combo("\f<arrow-down> Yaw", {"Disabled", "Static", "Backward"}):depend(antiaim_tab.enabled, {antiaim_tab.presets, "Builder"}, {main_tab.select_tab, 2})
    antiaims_settings[q].yaw_select_settings = antiaims_settings[q].yaw_select:create()
    antiaims_settings[q].l_yaw = antiaims_settings[q].yaw_select_settings:slider("Left", -180, 180, 0)
    antiaims_settings[q].r_yaw = antiaims_settings[q].yaw_select_settings :slider("Right", -180, 180, 0)
    antiaims_settings[q].slow_jitter = antiaims_settings[q].yaw_select_settings:switch("Slow Jitter")
    antiaims_settings[q].slow_ticks = antiaims_settings[q].yaw_select_settings:slider("Speed", 1, 12, 1)
    antiaims_settings[q].yaw_modifier_select = tab.aa_builder:combo("\f<gitter> Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"}):depend(antiaim_tab.enabled, {antiaim_tab.presets, "Builder"}, {main_tab.select_tab, 2})
    antiaims_settings[q].yaw_modifier_settigs = antiaims_settings[q].yaw_modifier_select:create()
    antiaims_settings[q].yaw_modifier_offset_select = antiaims_settings[q].yaw_modifier_settigs:slider("Offset", -180, 180, 0)
    antiaims_settings[q].body_yaw_select = tab.aa_builder:switch("\f<skeleton> Body Yaw"):depend(antiaim_tab.enabled, {antiaim_tab.presets, "Builder"}, {main_tab.select_tab, 2})
    antiaims_settings[q].body_yaw_settings = antiaims_settings[q].body_yaw_select:create()
    antiaims_settings[q].l_body_yaw = antiaims_settings[q].body_yaw_settings:slider("Left Limit", 0, 60, 58)
    antiaims_settings[q].r_body_yaw = antiaims_settings[q].body_yaw_settings:slider("Right Limit", 0, 60, 58)
    antiaims_settings[q].body_yaw_options = antiaims_settings[q].body_yaw_settings:selectable("Options", {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"})
    antiaims_settings[q].hidden_aa = tab.aa_builder:switch("\f<meta> Hidden"):depend(antiaim_tab.enabled, {antiaim_tab.presets, "Builder"}, {main_tab.select_tab, 2})
    antiaims_settings[q].hidden_aa_settings = antiaims_settings[q].hidden_aa:create()
    antiaims_settings[q].hidden_pitch = antiaims_settings[q].hidden_aa_settings:combo("Hidden Pitch", {"Disabled", "Up", "Down", "Zero", "Semi-Up", "Semi-Down", "Jitter", "Custom"})
    antiaims_settings[q].custom_pitch = antiaims_settings[q].hidden_aa_settings:slider("Custom", -89, 89, 0)
    antiaims_settings[q].hidden_yaw = antiaims_settings[q].hidden_aa_settings:combo("Hidden Yaw", {"Disabled", "Opposite", "Spin", "Random", "Sideways"})
    antiaims_settings[q].hidden_options = antiaims_settings[q].hidden_aa_settings:combo("Options", {"Always On", "On Peek"})
end

for q, w in pairs (conds) do
	active = {antiaims_settings[q].override_state, function() if(q == 1) then return true else return antiaims_settings[q].override_state:get() end end}
	selection = {antiaim_tab.states, conds[q]}
	antiaims_settings[q].override_state:depend(antiaim_tab.enable, antiaim_tab.enabled, selection, {antiaim_tab.states, function() return (q ~= 1) end})
    antiaims_settings[q].pitch_select:depend(active, antiaim_tab.enabled, selection)
    antiaims_settings[q].yaw_select:depend(active, antiaim_tab.enabled, selection)
    antiaims_settings[q].l_yaw:depend(active, antiaim_tab.enabled, selection, {antiaims_settings[q].yaw_select, function() if antiaims_settings[q].yaw_select:get() == "Disabled" then return false else return true end end})
    antiaims_settings[q].r_yaw:depend(active ,antiaim_tab.enabled, selection, {antiaims_settings[q].yaw_select, function() if antiaims_settings[q].yaw_select:get() == "Disabled" then return false else return true end end})
    antiaims_settings[q].slow_jitter:depend(active, antiaim_tab.enabled, selection, {antiaims_settings[q].yaw_select, function() if antiaims_settings[q].yaw_select:get() == "Disabled" then return false else return true end end})
    antiaims_settings[q].slow_ticks:depend(active, antiaim_tab.enabled, selection, antiaims_settings[q].slow_jitter, {antiaims_settings[q].yaw_select, function() if antiaims_settings[q].yaw_select:get() == "Disabled" then return false else return true end end})
    antiaims_settings[q].yaw_modifier_select:depend(active, antiaim_tab.enabled, selection)
    antiaims_settings[q].yaw_modifier_offset_select:depend(active, antiaim_tab.enabled, selection, {antiaims_settings[q].yaw_modifier_select, function() if antiaims_settings[q].yaw_modifier_select:get() == "Disabled" then return false else return true end end})
    antiaims_settings[q].body_yaw_select:depend(active, antiaim_tab.enabled, selection)
    antiaims_settings[q].l_body_yaw:depend(active, antiaim_tab.enabled, selection)
    antiaims_settings[q].r_body_yaw:depend(active, antiaim_tab.enabled, selection)
    antiaims_settings[q].body_yaw_options:depend(active, antiaim_tab.enabled, selection)
    antiaims_settings[q].hidden_aa:depend(active, antiaim_tab.enabled, selection)
    antiaims_settings[q].hidden_pitch:depend(active, antiaim_tab.enabled, selection)
    antiaims_settings[q].custom_pitch:depend(active, antiaim_tab.enabled, selection, antiaims_settings[q].hidden_aa, {antiaims_settings[q].hidden_pitch, "Custom"})
    antiaims_settings[q].hidden_yaw:depend(active, antiaim_tab.enabled, selection)
    antiaims_settings[q].hidden_options:depend(active, antiaim_tab.enabled, selection)
end

antiaim_func.get_player_state = function()
    local lp = entity.get_local_player()
    if not lp then return "Not connected" end
    
    on_ground = bit.band(lp.m_fFlags, 1) == 1
    jump = bit.band(lp.m_fFlags, 1) == 0
    crouch = lp.m_flDuckAmount > 0.7 or ref.fake_duck:get()
    vx, vy, vz = lp.m_vecVelocity.x, lp.m_vecVelocity.y, lp.m_vecVelocity.z
    math_velocity = math.sqrt(vx ^ 2 + vy ^ 2)
    move = math_velocity > 5

    if jump and crouch then return "AIR CROUCHING" end
    if jump then return "AIR" end
    if crouch then return "DUCKING" end
    if on_ground and ref.slow_walk:get() and move then return "SLOW WALKING" end
    if on_ground and not move then return "STANDING" end
    if on_ground and move then return "RUNNING" end
end

antiaim_func.antiaims = function(cmd)
    ref.enabled:override(antiaim_tab.enabled:get())
    local lp = entity.get_local_player()
    if not lp then return end
    if not antiaim_tab.enabled:get() then return end

    if antiaims_settings[2].override_state:get() and antiaim_func.get_player_state() == "STANDING" and rage.exploit:get() > 0 then id = 2
    elseif antiaims_settings[3].override_state:get() and antiaim_func.get_player_state() == "RUNNING" and rage.exploit:get() > 0 then id = 3
    elseif antiaims_settings[4].override_state:get() and antiaim_func.get_player_state() == "SLOW WALKING" and rage.exploit:get() > 0 then id = 4
    elseif antiaims_settings[5].override_state:get() and antiaim_func.get_player_state() == "DUCKING" and rage.exploit:get() > 0 then id = 5
    elseif antiaims_settings[6].override_state:get() and antiaim_func.get_player_state() == "AIR" and rage.exploit:get() > 0 then id = 6
    elseif antiaims_settings[7].override_state:get() and antiaim_func.get_player_state() == "AIR CROUCHING" and rage.exploit:get() > 0 then id = 7 
    elseif antiaims_settings[8].override_state:get() and rage.exploit:get() <= 0 then id = 8
    else
        id = 1
    end

    ref.pitch:override(antiaims_settings[id].pitch_select:get())
    ref.yaw:override(antiaims_settings[id].yaw_select:get())
    ref.yaw_offset:override(rage.antiaim:inverter() == true and antiaims_settings[id].l_yaw:get() or antiaims_settings[id].r_yaw:get())
    ref.yaw_modifier:override(antiaims_settings[id].yaw_modifier_select:get())
    ref.yaw_modifier_offset:override(antiaims_settings[id].yaw_modifier_offset_select:get())
    ref.body_yaw:override(antiaims_settings[id].body_yaw_select:get())
    ref.left_limit:override(antiaims_settings[id].l_body_yaw:get())
    ref.right_limit:override(antiaims_settings[id].r_body_yaw:get())
    ref.options:override(antiaims_settings[id].body_yaw_options:get())

    if antiaims_settings[id].hidden_aa:get() then
        ref.hidden:override(true)
    else
        ref.hidden:override(false)
    end

    if antiaims_settings[id].hidden_aa:get() then
        if antiaims_settings[id].hidden_pitch:get() == "Up" then
            rage.antiaim:override_hidden_pitch(-89)
        elseif antiaims_settings[id].hidden_pitch:get() == "Down" then
            rage.antiaim:override_hidden_pitch(89)
        elseif antiaims_settings[id].hidden_pitch:get() == "Zero" then    
            rage.antiaim:override_hidden_pitch(0)
        elseif antiaims_settings[id].hidden_pitch:get() == "Semi-Up" then
            rage.antiaim:override_hidden_pitch(-45)
        elseif antiaims_settings[id].hidden_pitch:get() == "Semi-Down" then
            rage.antiaim:override_hidden_pitch(45)
        elseif antiaims_settings[id].hidden_pitch:get() == "Jitter" then
            rage.antiaim:override_hidden_pitch(rage.antiaim:inverter() == true and -89 or 89)
        elseif antiaims_settings[id].hidden_pitch:get() == "Custom" then
            rage.antiaim:override_hidden_pitch(antiaims_settings[id].custom_pitch:get())
        end

        if antiaims_settings[id].hidden_yaw:get() == "Opposite" then
            rage.antiaim:override_hidden_yaw_offset(180)
        elseif antiaims_settings[id].hidden_yaw:get() == "Spin" then
            rage.antiaim:override_hidden_yaw_offset(math.normalize_yaw(globals.curtime * 360))
        elseif antiaims_settings[id].hidden_yaw:get() == "Random" then
            rage.antiaim:override_hidden_yaw_offset(math.random(-180, 180))
        elseif antiaims_settings[id].hidden_yaw:get() == "Sideways" then
            if globals.tickcount % 3 == 0 then 
                rage.antiaim:override_hidden_yaw_offset(-111)
            elseif globals.tickcount % 3 == 1 then 
                rage.antiaim:override_hidden_yaw_offset(111)
            end
        end

        if antiaims_settings[id].hidden_options:get() == "Always On" then
            ref.dt_options:override("Always On")
            ref.os_options:override("Break LC")
        elseif antiaims_settings[id].hidden_options:get() == "On Peek" then
            ref.dt_options:override("On Peek")
            ref.os_options:override("Favor Fire Rate")
        end
    end

	if antiaims_settings[id].slow_jitter:get() then
		delay_calc = (globals.tickcount % (8 + antiaims_settings[id].slow_ticks:get()/2) > 4 + antiaims_settings[id].slow_ticks:get()/2/2)
		if cmd.send_packet == true and cmd.choked_commands < 1 then
			ref.yaw_modifier_offset:override(delay_calc and antiaims_settings[id].l_yaw:get() or antiaims_settings[id].r_yaw:get())
            ref.inverter:override(delay_calc)
		end
	end

    -- PRESETS PART
    if antiaim_tab.presets:get() == "Tao" then
        if antiaim_func.get_player_state() == "STANDING" then
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.yaw_offset:override(-5)
            ref.yaw_modifier:override("Center")
            ref.yaw_modifier_offset:override(-60)
            ref.body_yaw:override(true)
            ref.left_limit:override(60)
            ref.right_limit:override(60)
            ref.options:override("Jitter")
        elseif antiaim_func.get_player_state() == "RUNNING" then
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.yaw_offset:override(rage.antiaim:inverter() == true and -30 or 40)
            ref.yaw_modifier:override("Center")
            ref.body_yaw:override(true)
            ref.left_limit:override(58)
            ref.right_limit:override(58)
            ref.options:override({})
            delay_calc = (globals.tickcount % (8 + 8/2) > 4 + 8/4) -- 8/2 and 8/4 is ticks
            if cmd.send_packet == true and cmd.choked_commands < 1 then
                ref.yaw_modifier_offset:override(delay_calc and -30 or 40)
                ref.inverter:override(delay_calc)
            end
        elseif antiaim_func.get_player_state() == "SLOW WALKING" then
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.yaw_offset:override(0)
            ref.yaw_modifier:override("Center")
            ref.yaw_modifier_offset:override(-39)
            ref.body_yaw:override(true)
            ref.left_limit:override(55)
            ref.right_limit:override(55)
            ref.options:override("Jitter")
            ref.hidden:override(true)
            rage.antiaim:override_hidden_pitch(utils.random_int(-52, 38))
            rage.antiaim:override_hidden_yaw_offset(math.random(-110, 99))
            ref.dt_options:override("Always On")
            ref.os_options:override("Break LC")
        elseif antiaim_func.get_player_state() == "DUCKING" then
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.yaw_offset:override(0)
            ref.yaw_modifier:override("Center")
            ref.yaw_modifier_offset:override(-45)
            ref.body_yaw:override(true)
            ref.left_limit:override(60)
            ref.right_limit:override(60)
            ref.options:override("Jitter")
            ref.hidden:override(true)
            rage.antiaim:override_hidden_pitch(math.random(-43, 67))
            rage.antiaim:override_hidden_yaw_offset(rage.antiaim:inverter() == true and math.normalize_yaw(globals.realtime * 360) or globals.tickcount % 3 and -111 or 111)
            ref.dt_options:override("Always On")
            ref.os_options:override("Break LC")
        elseif antiaim_func.get_player_state() == "AIR" then
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.yaw_offset:override(0)
            ref.yaw_modifier:override("Center")
            ref.yaw_modifier_offset:override(-86)
            ref.body_yaw:override(true)
            ref.left_limit:override(60)
            ref.right_limit:override(60)
            ref.options:override("Jitter")
            ref.hidden:override(true)
            rage.antiaim:override_hidden_pitch(-12)
            rage.antiaim:override_hidden_yaw_offset(math.random(147, 177))
            ref.dt_options:override("Always On")
            ref.os_options:override("Break LC")
        elseif antiaim_func.get_player_state() == "AIR CROUCHING" then
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.yaw_offset:override(0)
            ref.yaw_modifier:override("Center")
            ref.yaw_modifier_offset:override(-22)
            ref.body_yaw:override(true)
            ref.left_limit:override(55)
            ref.right_limit:override(60)
            ref.options:override("Jitter", "Anti Bruteforce")
            ref.hidden:override(true)
            rage.antiaim:override_hidden_pitch(math.random(-47, 24))
            rage.antiaim:override_hidden_yaw_offset(utils.random_int(-155, 111))
            ref.dt_options:override("Always On")
            ref.os_options:override("Break LC")
        end

    elseif antiaim_tab.presets:get() == "Bao" then
        if antiaim_func.get_player_state() == "STANDING" then
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.yaw_offset:override(-5)
            ref.yaw_modifier:override("Center")
            ref.yaw_modifier_offset:override(-8)
            ref.body_yaw:override(true)
            ref.left_limit:override(50)
            ref.right_limit:override(50)
            ref.options:override({})
            ref.hidden:override(true)
            rage.antiaim:override_hidden_pitch(math.random(-76 , 64))
			rage.antiaim:override_hidden_yaw_offset(math.random(-95 , 124))
            ref.dt_options:override("Always On")
            ref.os_options:override("Break LC")
        elseif antiaim_func.get_player_state() == "RUNNING" then
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.yaw_offset:override(rage.antiaim:inverter() == true and -20 or 28)
            ref.yaw_modifier:override("Center")
            ref.body_yaw:override(true)
            ref.left_limit:override(60)
            ref.right_limit:override(60)
            ref.options:override({})
            ref.hidden:override(true)
            rage.antiaim:override_hidden_pitch(math.random(-6 , 10))
            rage.antiaim:override_hidden_yaw_offset(math.random(-155 , 123))
            ref.dt_options:override("Always On")
            ref.os_options:override("Break LC")
            delay_calc = (globals.tickcount % (8 + 8/2) > 4 + 8/4) -- 8/2 and 8/4 is ticks
            if cmd.send_packet == true and cmd.choked_commands < 1 then
                ref.yaw_modifier_offset:override(delay_calc and -20 or 28)
                ref.inverter:override(delay_calc)
            end
        elseif antiaim_func.get_player_state() == "SLOW WALKING" then
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.yaw_offset:override(0)
            ref.yaw_modifier:override("Center")
            ref.yaw_modifier_offset:override(10)
            ref.body_yaw:override(true)
            ref.left_limit:override(60)
            ref.right_limit:override(60)
            ref.options:override({})
            ref.hidden:override(true)
            rage.antiaim:override_hidden_pitch(math.random(87, -78))
            rage.antiaim:override_hidden_yaw_offset(math.random(-120 , 122))
            ref.dt_options:override("Always On")
            ref.os_options:override("Break LC")
        elseif antiaim_func.get_player_state() == "DUCKING" then
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.yaw_offset:override(0)
            ref.yaw_modifier:override("Center")
            ref.yaw_modifier_offset:override(20)
            ref.body_yaw:override(true)
            ref.left_limit:override(60)
            ref.right_limit:override(60)
            ref.options:override("Jitter")
            ref.hidden:override(true)
            rage.antiaim:override_hidden_pitch(math.random(-40 ,20))
            rage.antiaim:override_hidden_yaw_offset(utils.random_int(-53, 33))
            ref.dt_options:override("Always On")
            ref.os_options:override("Break LC")
        elseif antiaim_func.get_player_state() == "AIR" then
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.yaw_offset:override(0)
            ref.yaw_modifier:override("Center")
            ref.yaw_modifier_offset:override(-46)
            ref.body_yaw:override(true)
            ref.left_limit:override(60)
            ref.right_limit:override(60)
            ref.options:override("Jitter")
            ref.hidden:override(true)
            rage.antiaim:override_hidden_pitch(80)
            rage.antiaim:override_hidden_yaw_offset(math.random(-90, 180))
            ref.dt_options:override("Always On")
            ref.os_options:override("Break LC")
        elseif antiaim_func.get_player_state() == "AIR CROUCHING" then
            ref.pitch:override("Down")
            ref.yaw:override("Backward")
            ref.yaw_offset:override(0)
            ref.yaw_modifier:override("Center")
            ref.yaw_modifier_offset:override(0)
            ref.body_yaw:override(true)
            ref.left_limit:override(60)
            ref.right_limit:override(60)
            ref.options:override("Jitter", "Anti Bruteforce")
            ref.hidden:override(true)
            rage.antiaim:override_hidden_pitch(math.random(-75, 80))
            rage.antiaim:override_hidden_yaw_offset(utils.random_int(-153, 91))
            ref.dt_options:override("Always On")
            ref.os_options:override("Break LC")
        end
    end

    local yawbase = antiaim_tab.yaw_base:get()
    if yawbase == "Local View" then
        ref.yaw_base:override("Local View")
    elseif yawbase == "At Target" then
        ref.yaw_base:override("At Target")
    elseif yawbase == "Forward" then
        ref.yaw_offset:override(180)
        ref.yaw_base:override("Local View")
        ref.hidden:set(false)
    elseif yawbase == "Left" then
        ref.yaw_offset:override(-90)
        ref.yaw_base:override("Local View")
        ref.hidden:set(false)
    elseif yawbase == "Right" then
        ref.yaw_offset:override(90)
        ref.yaw_base:override("Local View")
        ref.hidden:set(false)
    end

    if (yawbase == "Left" or yawbase == "Right") then
        if antiaim_tab.defensive_spam:get() then
            ref.yaw_base:override("Local View")
            ref.hidden:override(true)
            rage.antiaim:override_hidden_pitch(0)
			rage.antiaim:override_hidden_yaw_offset(180)
            ref.dt_options:override("Always On")
			ref.os_options:override("Break LC")
        end
    end

    if (yawbase == "Forward" or yawbase == "Left" or yawbase == "Right") then
        if antiaim_tab.static_manuals:get() then
            ref.yaw_modifier:override('Disabled')
			ref.options:override({})
			ref.yaw_base:override('Local View')
            ref.inverter:override(false)
        end
    end

    if antiaim_tab.freestanding:get() then
        ref.freestanding:override(true)
    else
        ref.freestanding:override(false)
    end

    if antiaim_tab.freestanding:get() then
        if antiaim_tab.disable_yaw_modifiers_freestanding:get() then
            ref.yaw_modifier:override('Disabled')
            ref.options:override({})
			ref.yaw_base:override('Local View')
            ref.inverter:override(false)
            ref.hidden:override(false)
        end
    end

    -- AA TWEAKS PART
    local lp = entity.get_local_player()
    local get_player_weapon = lp:get_player_weapon()
    if get_player_weapon == nil then return end
    local weapon = get_player_weapon:get_classname()
    local safe_head = false
    if antiaim_tab.tweaks:get("Safe Head") and (string.match(weapon, "Knife") or string.match(weapon, "Taser")) then 
		safe_head = true
	end
    if (jump and crouch and safe_head == true) then
		ref.yaw_base:override("At Target")
        ref.hidden:override(false)
		ref.yaw_modifier:override("Disabled")
		ref.body_yaw:override(false)
		ref.yaw_offset:override(0)
    end

    if antiaim_tab.tweaks:get("Avoid Backstab") then
        ref.avoid_backstab:override(true)
    else
        ref.avoid_backstab:override(false)
    end

    if (antiaim_tab.tweaks:get("Disable on Warmup") and entity.get_game_rules()["m_bWarmupPeriod"] == true) then
		ref.pitch:override("Disabled")
        ref.yaw:override("Disabled")
        ref.body_yaw:override(false)
    end
end

-- ANIM. BREAKER
antiaim_func.in_air = function()
	local lp = entity.get_local_player()
	if not lp == nil then return end
    if bit.band(lp["m_fFlags"], 1) == 1 then
        ground_ticks = ground_ticks + 1
    else
        ground_ticks = 0
        end_time = globals.curtime + 1
    end
    return ground_ticks > 1 and end_time > globals.curtime
end

ffi.cdef[[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef struct {
        char  pad_0000[20];
        int m_nOrder; //0x0014
        int m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030
        char  pad_0038[4]; //0x0034
    } animstate_layer_t;
]]

local uintptr_t = ffi.typeof("uintptr_t**")
local get_entity_address = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local animslsg = nil
local animbreak = function(lp)
	lp = entity.get_local_player()
    if lp == nil then return end
    if not lp:is_alive() then return end
    if lp:get_index() == nil then return end
    animslsg = get_entity_address(lp:get_index())
    move = math.sqrt(lp.m_vecVelocity.x ^ 2 + lp.m_vecVelocity.y ^ 2) > 5
    jump = bit.band(lp.m_fFlags, 1) == 0
	if antiaim_tab.legs_on_ground:get() == "Static" and antiaim_tab.anim_breakers:get() then
        lp.m_flPoseParameter[6] = 1
        ref.leg_movement:override("Sliding")
	end
	if antiaim_tab.legs_on_ground:get() == "Jitter" and antiaim_tab.anim_breakers:get() then
        lp.m_flPoseParameter[0] = globals.tickcount %4 > 1 and 0.5 or 1
        ref.leg_movement:override("Sliding")
    end
	if antiaim_tab.legs_on_ground:get() == "Walking" and antiaim_tab.anim_breakers:get() then
        lp.m_flPoseParameter[7] = 1
        ref.leg_movement:override("Walking")
    end
	if antiaim_tab.legs_in_air:get() == "Static" and antiaim_tab.anim_breakers:get() then
        lp.m_flPoseParameter[6] = 1
    end
	if antiaim_tab.legs_in_air:get() == "Walking" and antiaim_tab.anim_breakers:get() then
        if jump and move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][6].m_flWeight = 1
        end
    end
	if antiaim_tab.other_breakers:get("Pitch 0 on Land") and antiaim_tab.anim_breakers:get() then
        if antiaim_func.in_air() then
            lp.m_flPoseParameter[12] = 0.5
        end
    end
	if antiaim_tab.other_breakers:get("Move Lean") and antiaim_tab.anim_breakers:get() then
        if move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][12].m_flWeight = 1
        end
    end
    if antiaim_tab.other_breakers:get("AnimFucker") and antiaim_tab.anim_breakers:get() then
        if jump and crouch and move then
            lp.m_flPoseParameter[math.random(0, 10)] = 3
            lp.m_flPoseParameter[math.random(0, 10)] = 7
            lp.m_flPoseParameter[math.random(0, 10)] = 6
        end
    end
end
--

--AIMBOT LOGGING
local hitgroup_str = {
    [0] = 'generic',
    'head', 'chest', 'stomach',
    'left arm', 'right arm',
    'left leg', 'right leg',
    'neck', 'generic', 'gear'
}
events.aim_ack:set(function(e)
    if misc_tab.log_select:get("Console/Event") then
        local userid = entity.get(e.userid, true)
        local hit_color = misc_tab.hit:get()
        local miss_color = misc_tab.miss:get()
        local lp = entity.get_local_player()
        local target = entity.get(e.target)
        local damage = e.damage
        local wanted_damage = e.wanted_damage
        local wanted_hitgroup = hitgroup_str[e.wanted_hitgroup]
        local hitchance = e.hitchance
        local state = e.state
        local state1 = e.state
        local bt = e.backtrack
        if not target then return end
        if target == nil then return end
        local health = target["m_iHealth"]
    
        if state1 == "spread" then
            state1 = "\a"..miss_color:to_hex().."spread"
        end
        if state1 == "prediction error" then
            state1 = "\a"..miss_color:to_hex().."pred. error"
        end
        if state1 == "correction" then
            state1 = "\a"..miss_color:to_hex().."resolver"
        end
        if state1 == "misprediction" then
            state1 = "\a"..miss_color:to_hex().."misprediction"
        end
        if state1 == "lagcomp failure" then
            state1 = "\a"..miss_color:to_hex().."lagcomp failure"
        end
        if state == "correction" then
            state = "resolver"
        end
    
        local hitgroup = hitgroup_str[e.hitgroup]
        
        if state == nil then
            print_dev(("\aFFFFFFFFRegistred \a"..hit_color:to_hex().."%s \aFFFFFFFFin the \a"..hit_color:to_hex().."%s \aFFFFFFFFfor \a"..hit_color:to_hex().."%d\aFFFFFFFF(\a"..hit_color:to_hex()..""..string.format("%.f", wanted_damage).."\aFFFFFFFF) \aFFFFFFFFdamage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
            print_raw(("\a"..hit_color:to_hex().."taobao | \aFFFFFFFFRegistred \a"..hit_color:to_hex().."%s \aFFFFFFFFin the \a"..hit_color:to_hex().."%s \aFFFFFFFFfor \a"..hit_color:to_hex().."%d\aFFFFFFFF(\a"..hit_color:to_hex()..""..string.format("%.f", wanted_damage).."\aFFFFFFFF) \aFFFFFFFFdamage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
        else
            print_dev(('\aFFFFFFFFMissed shot in \a'..miss_color:to_hex()..'%s \aFFFFFFFFin the %s due to \a'..miss_color:to_hex()..''..state1..'\aFFFFFFFF (hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup))
            print_raw(('\a'..miss_color:to_hex()..'taobao | \aFFFFFFFFMissed shot in \a'..miss_color:to_hex()..'%s \aFFFFFFFFin the %s due to \a'..miss_color:to_hex()..''..state1..'\aFFFFFFFF (hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup))
        end
    end
    end)

    events.player_hurt:set(function(e)
        if misc_tab.log_select:get("Console/Event") then
            local hit_color = misc_tab.hit:get()
            local lp = entity.get_local_player()
            local attacker = entity.get(e.attacker, true)
            local weapon = e.weapon
            local type_hit = 'Hit'
        
            if weapon == 'hegrenade' then 
                type_hit = 'Naded'
            end
        
            if weapon == 'inferno' then
                type_hit = 'Burned'
            end
        
            if weapon == 'knife' then 
                type_hit = 'Knifed'
            end
        
            if weapon == 'hegrenade' or weapon == 'inferno' or weapon == 'knife' then
        
            if lp == attacker then
                local user = entity.get(e.userid, true)
                print_raw(('\a'..hit_color:to_hex()..'taobao | \aFFFFFFFF'..type_hit..' \a'..hit_color:to_hex()..'%s \aFFFFFFFFfor \a'..hit_color:to_hex()..'%d \aFFFFFFFFdamage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
                print_dev((''..type_hit..' %s for %d damage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
            end
            end
            end
        end)

local screen = render.screen_size()
local hitgroup_str = {[0] = 'generic','head', 'chest', 'stomach','left arm', 'right arm','left leg', 'right leg','neck', 'generic', 'gear'}
local hitlog = {}
local id = 1
local weapon_to_verb = {knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned'}
events.player_hurt:set(function(e)
    if misc_tab.log_select:get("Under Crosshair") then
        local hit_color = misc_tab.hit:get()
		local lp = entity.get_local_player()
		local attacker = entity.get(e.attacker, true)
        if lp == attacker then
		local damage = e.dmg_health
		local user = entity.get(e.userid, true)
		local hitgroup = hitgroup_str[e.hitgroup]
		local weapon_name = e.weapon
		local remaining_health = e.health
		if weapon_name == 'hegrenade' or weapon_name == 'inferno' or weapon_name == 'knife' then return end
		if result == nil then
			hitlog[#hitlog+1] = {("\aFFFFFFFFRegistred \a"..hit_color:to_hex()..""..user:get_name().." \aFFFFFFC8in the \a"..hit_color:to_hex()..""..hitgroup.." \aFFFFFFC8for \a"..hit_color:to_hex()..""..damage.." \aFFFFFFC8damage ("..remaining_health.." \aFFFFFFC8health remaining)"), globals.tickcount + 250, 0}
		end
		id = id == 999 and 1 or id + 1 
	end
end
end)

events.player_hurt:set(function(e)
    if misc_tab.log_select:get("Under Crosshair") then
        local hit_color = misc_tab.hit:get()
        local lp = entity.get_local_player()
        local attacker = entity.get(e.attacker, true)
        local weapon = e.weapon
        local type_hit = 'Hit'
    
        if weapon == 'hegrenade' then 
            type_hit = 'Naded'
        end
    
        if weapon == 'inferno' then
            type_hit = 'Burned'
        end
    
        if weapon == 'knife' then 
            type_hit = 'Knifed'
        end
    
        if weapon == 'hegrenade' or weapon == 'inferno' or weapon == 'knife' then
    
        if lp == attacker then
            local user = entity.get(e.userid, true)
			hitlog[#hitlog+1] = {("\aFFFFFFFF"..type_hit.." \a"..hit_color:to_hex().."%s \aFFFFFFC8for \a"..hit_color:to_hex().."%s \aFFFFFFC8damage (%s \aFFFFFFC8health remaining)"):format(user:get_name(), e.dmg_health, e.health), globals.tickcount + 250, 0}
        end
        end
        end
    end)

events.aim_ack:set(function(shot)
	if misc_tab.log_select:get("Under Crosshair") then
    local miss_color = misc_tab.miss:get()
	player_name = shot.target:get_name()
    damage = shot.damage
    hitchance = shot.hitchance
    hitgroup = hitgroup_str[shot.hitgroup]
    backtrack = shot.backtrack
    wanted_damage = shot.wanted_damage
    hitchance = shot.hitchance
    wanted_hitgroup = hitgroup_str[shot.wanted_hitgroup]
    state = shot.state
    local text = "%"
	if not (state == nil) then
        hitlog[#hitlog+1] = {("\aFFFFFFFFMissed shot in \a"..miss_color:to_hex()..""..player_name.." \aFFFFFFC8in the \a"..miss_color:to_hex()..""..wanted_hitgroup.." \aFFFFFFC8due to \a"..miss_color:to_hex()..""..state.." \aFFFFFFC8("..hitchance..""..text.."\aFFFFFFC8 HC)"), globals.tickcount + 250, 0}
    end
	id = id == 999 and 1 or id + 1 
end
end)

events.render:set(function()
	if #hitlog > 0 then
        if globals.tickcount >= hitlog[1][2] then
            if hitlog[1][3] > 0 then
                hitlog[1][3] = hitlog[1][3] - 20
            elseif hitlog[1][3] <= 0 then
                table.remove(hitlog, 1)
            end
        end
        if #hitlog > 6 then
            table.remove(hitlog, 1)
        end
        if globals.is_connected == false then
            table.remove(hitlog, #hitlog)
        end
        for i = 1, #hitlog do
            text_size = render.measure_text(1, nil, hitlog[i][1]).x
           if hitlog[i][3] < 255 then 
                hitlog[i][3] = hitlog[i][3] + 10 
            end
            if misc_tab.log_select:get("Under Crosshair") then
            render.text(1, vector(screen.x/2 - text_size/2 + (hitlog[i][3]/35), screen.y/1.3 + 13 * i), color(255, 255, 255, hitlog[i][3]), nil, hitlog[i][1])
            end
		end
    end
end)

visuals_func.indicators = function()
    local lp = entity.get_local_player()
    if not lp then return end
    if not lp:is_alive() then return end
    local x = render.screen_size().x
    local y = render.screen_size().y
    MTools.Animation:Register("crosshair_inds");
	MTools.Animation:Update("crosshair_inds", 6);
	animation_on_scope = MTools.Animation:Lerp("crosshair_inds", "taobao", (lp.m_bIsScoped), vector(x, y), vector(x+65, y), 20);
    local crosshair_text = gradient.text_animate("taobao", -1.5, {color(255, 255, 255, 255), misc_tab.crosshair_inds_color:get()})

    if misc_tab.crosshair_inds:get() then
        render.shadow(vector(animation_on_scope.x/2 - 21, y/2+21), vector(animation_on_scope.x/2 + 19, y/2+21), misc_tab.crosshair_inds_color:get(), 30, 0, 0)
        render.text(font.verdana_bold, vector(animation_on_scope.x/2+1, y/2+20), color(0, 0, 0, 255), "c", "taobao")
        render.text(font.verdana_bold, vector(animation_on_scope.x/2, y/2+20), color(), "c", crosshair_text:get_animated_text())
        render.text(2, vector(animation_on_scope.x/2, y/2+30), color(255, 255, 255, 255), "c", antiaim_func.get_player_state())
        if ref.doubletap:get() then render.text(2, vector(animation_on_scope.x/2, y/2+40), color(255, rage.exploit:get()*255, rage.exploit:get()*255, 255), "c", "DT") end
        if ref.onshot:get() and not ref.doubletap:get() then render.text(2, vector(animation_on_scope.x/2, y/2+40), color(255, 255, 255, 255), "c", "OS") end
    end

    local gradient_wm = gradient.text_animate("B A N S Y N C", -1.5, {color(255, 255, 255, 255), color(135, 135, 135, 255)})
	gradient_wm:animate()

    if not misc_tab.crosshair_inds() then
        render.text(font.verdana_bold, vector(x/2+1, y/2+y/2.05), color(0, 0, 0, 255), "c", "B A N S Y N C")
        render.text(font.verdana_bold, vector(x/2, y/2+y/2.05), color(255, 255, 255, 255), "c", gradient_wm:get_animated_text())
    end
end

function wm_window(x, y, w, h, name, alpha) 
    local lp = entity.get_local_player()
    if not lp then return end
	local name_size = render.measure_text(1, "", name) 

    render.rect(vector(x, y-1), vector(x + w + 3, y + 19), color(207, 106, 128, alpha/1.5), 0)
    render.text(1, vector(x+3 + w / 2 + 1 - name_size.x / 2, y + h / 2 - name_size.y/2), color(255, 255, 255, alpha), "", name)
end

visuals_func.wm2k18 = function()
    local time = ""
    local ping = ""
    local tickrate = ""
    local text = ""
    local time = common.get_date("%H:%M:%S")

    if not globals.is_in_game then
        ping = ""
    else
        ping = ""..MTools.Client.GetPing().."ms"
    end

	text = ("taobao | rtt: "..ping.." | rate: 64 | "..time.." ")

	local text_size = render.measure_text(1, "", text).x
    wm_window(render.screen_size().x - text_size-19, 10, text_size + 4, 16, text, 255)
end

visuals_func.swag = function()
    local lp = entity.get_local_player()
    if not lp then return end
    local thirdperson = common.is_in_thirdperson()
    if not thirdperson then return end

    -- head
    local pos = lp:get_hitbox_position(0)
    pos.z = pos.z + 10
    local wts = render.world_to_screen(pos)
    if not wts then return end 
    wts.x = wts.x - 55

    -- left leg
    local pos1 = lp:get_hitbox_position(11)
    pos1.z = pos1.z + 10
    local wts1 = render.world_to_screen(pos1)
    if not wts1 then return end 
    wts1.x = wts1.x - 55
    
    -- right leg
    local pos2 = lp:get_hitbox_position(12)
    pos2.z = pos2.z + 10
    local wts2 = render.world_to_screen(pos2)
    if not wts2 then return end 
    wts2.x = wts2.x - 55

    if misc_tab.select_swag:get("KEPARIK") then
        render.texture(img.cap, wts, vector(120, 120), color(), f)
    end

    if misc_tab.select_swag:get("KROSSI") then
        render.texture(img.sneakers, wts1, vector(120, 150), color(), f)
        render.texture(img.sneakers, wts2, vector(120, 150), color(), f)
    end
end

visuals_func.dmg_ind = function()
    local lp = entity.get_local_player()
    if not lp then return end
    if not lp:is_alive() then return end
    local x = render.screen_size().x
	local y = render.screen_size().y
    local color = misc_tab.dmg_indicator_color:get()

    if misc_tab.dmg_indicator_styles:get() == "Default" then
        render.text(1, vector(x/2+15, y/2-25), color, "c", ref.mindamage:get())
    elseif misc_tab.dmg_indicator_styles:get() == "Pixel" then
        render.text(2, vector(x/2+15, y/2-25), color, "c", ref.mindamage:get())
    elseif misc_tab.dmg_indicator_styles:get() == "Modern" then
        render.text(3, vector(x/2+15, y/2-25), color, "c", ref.mindamage:get())
    elseif misc_tab.dmg_indicator_styles:get() == "Bold" then
        render.text(4, vector(x/2+15, y/2-25), color, "c", ref.mindamage:get())
    end
end

visuals_func.scp_lns = function()
    local lp = entity.get_local_player()
    if not lp then return end
    if not lp:is_alive() then return end
    local is_scoped = lp.m_bIsScoped
    local x = render.screen_size().x
	local y = render.screen_size().y
    local r, g, b = math.floor(misc_tab.scope_lines_color:get().r, misc_tab.scope_lines_color:get().g, misc_tab.scope_lines_color:get().b)
    local scope_color = misc_tab.scope_lines_color:get()
    local color = color(scope_color.r, scope_color.g, scope_color.b, 1)
    local a_color = (function(a, b) if not misc_tab.invert_lines:get() then return b else return a end end)(scope_color, color)
    local b_color = (function(a, b) if not misc_tab.invert_lines:get() then return a else return b end end)(scope_color, color)
    if is_scoped then
        render.gradient(vector(x/2, y/2 + (misc_tab.offset:get() - 1) + 1), vector(x/2 + 1, y/2 + misc_tab.lenght:get() + (misc_tab.offset:get() - 1) + 1), b_color, b_color, a_color, a_color)
        render.gradient(vector((x/2 + 1 + (misc_tab.lenght:get())) + (misc_tab.offset:get() - 1), y/2), vector(x/2 + 1 + (misc_tab.offset:get() - 1), y/2 + 1), a_color, b_color, a_color, b_color)
        render.gradient(vector(x/2, y/2 - (misc_tab.offset:get() - 1) - misc_tab.lenght:get()), vector(x/2 + 1, y/2 - (misc_tab.offset:get() - 1)), a_color, a_color, b_color, b_color)
        render.gradient(vector((x/2 - misc_tab.lenght:get()) - (misc_tab.offset:get() - 1), y/2), vector(x/2 - (misc_tab.offset:get() - 1), y/2 + 1), a_color, b_color, a_color, b_color)
    end
end

visuals_func.manual_arrows = function()
	local lp = entity.get_local_player()
	if not lp then return end
    if not lp:is_alive() then return end
	local x = render.screen_size().x 
	local y = render.screen_size().y
    MTools.Animation:Register("manualarrows");
	MTools.Animation:Update("manualarrows", 6);
	arrows_anim = MTools.Animation:Lerp("manualarrows", "yaw_base", (lp.m_bIsScoped), vector(x, y), vector(x, y-30), 20);

    render.text(font.verdana, vector(x/2-55, arrows_anim.y/2), antiaim_tab.yaw_base:get() == "Left" and misc_tab.manualarrows_color:get() or color(0, 0, 0, 0), "c", "⮜")
    render.text(font.verdana, vector(x/2+55, arrows_anim.y/2), antiaim_tab.yaw_base:get() == "Right" and misc_tab.manualarrows_color:get() or color(0, 0, 0, 0), "c", "⮞")
end

local ct_anim = {
    " ",
    "t ",
    "ta ",
    "tao ",
    "taob ",
    "taoba ",
    "taobao ",
    "taobao ",
    "taobao ",
    "taoba ",
    "taob ",
    "tao ",
    "ta ",
    "t ",
    " "
}

visuals_func.ct_animation = function()
    if utils.net_channel() == nil then return end
    local set_clan_tag = math.floor(math.fmod((globals.tickcount + (utils.net_channel().latency[0] / globals.tickinterval)) / 22, #ct_anim + 1) + 1)
    return ct_anim[set_clan_tag]
end

visuals_func.ct_check = nil
visuals_func.clan_tag = function(ct_anim)
    if ct_anim == visuals_func.ct_check then return end
    if ct_anim == nil then return end

    common.set_clan_tag(ct_anim)
    visuals_func.ct_check = ct_anim
end

ragebob_func.nvm = function()
    if misc_tab.nvm_dude:get() then
        cvar.sv_maxunlag:float(0.15)
    else
        cvar.sv_maxunlag:float(0.2)
    end
end

ragebob_func.fast_ladder = function(cmd)
    local lp = entity.get_local_player()
    if not lp then return end
    if lp["m_MoveType"] == 9 then
        if cmd.sidemove == 0 then
            cmd.view_angles.y = cmd.view_angles.y + 45
        end
        if cmd.sidemove < 0 and cmd.in_forward then
            cmd.view_angles.y = cmd.view_angles.y + 90
        end
        if cmd.sidemove > 0 and cmd.in_back then
            cmd.view_angles.y = cmd.view_angles.y + 90
        end
        cmd.in_moveleft = cmd.in_back
        cmd.in_moveright = cmd.in_forward
        if cmd.view_angles.x < 0 then
            cmd.view_angles.x = -45
        end
    end
end

ragebob_func.hitchance_modify = function(cmd)
    if not misc_tab.hitchance_manipulation:get() then return end

    local lp = entity.get_local_player()
    if not lp then
        return
    end

    local weapon = lp:get_player_weapon()
    if weapon == nil then return end
    local weapons = weapon:get_weapon_index() == 38 or weapon:get_weapon_index() == 11 or weapon:get_weapon_index() == 9 or weapon:get_weapon_index() == 40

    if misc_tab.select_manipulate:get("No Scope") and not lp.m_bIsScoped and weapons then
        ref.hitchance:override(misc_tab.no_scope:get())
    end

    if misc_tab.select_manipulate:get("In Air") and cmd.in_jump and weapons then
        ref.hitchance:override(misc_tab.in_air:get())
    end

    if not (misc_tab.select_manipulate:get("No Scope") and not cmd.in_jump and not lp.m_bIsScoped and weapons) and not (misc_tab.select_manipulate:get("In Air") and cmd.in_jump and weapons) then
        ref.hitchance:override()
    end
end

events.createmove:set(function(cmd)
    local lp = entity.get_local_player()
    if not lp then return end
    if not lp:is_alive() then return end
    antiaim_func.antiaims(cmd)
    ragebob_func.nvm()
    ragebob_func.hitchance_modify(cmd)

    if misc_tab.last_tick:get() then
        cvar.cl_interp_ratio:float(1)
        cvar.sv_max_allowed_net_graph:float(2)
        cvar.cl_interpolate:float(0)
    else
        cvar.cl_interp_ratio:float(2)
        cvar.cl_interpolate:float(1)
    end

    if misc_tab.fastladder:get() then
        ragebob_func.fast_ladder(cmd)
    end

    if misc_tab.aspect_ratio:get() then
		cvar.r_aspectratio:float(misc_tab.aspect_ratio_offset:get()/100)
	else
		cvar.r_aspectratio:float(0)
	end

    if misc_tab.viewmodel_changer:get() then
		cvar.viewmodel_fov:int(misc_tab.viewmodel_offset_fov:get(), true)
		cvar.viewmodel_offset_x:float(misc_tab.viewmodel_offset_x:get(), true)
		cvar.viewmodel_offset_y:float(misc_tab.viewmodel_offset_y:get(), true)
		cvar.viewmodel_offset_z:float(misc_tab.viewmodel_offset_z:get(), true)
	else
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
	end	

    if misc_tab.ping_unlocker:get() then
        ref.fakelatency:override(misc_tab.ping_unlocker_offset:get())
    else
        ref.fakelatency:override()
    end

end)

events.render:set(function()
    visuals_func.indicators()

    if misc_tab.scope_lines:get() then
        ref.scope_overlay:override("Remove all")
    else
        ref.scope_overlay:override()
    end
    if misc_tab.scope_lines:get() then
        visuals_func.scp_lns()
    end

    if misc_tab.dmg_indicator:get() then
        visuals_func.dmg_ind()
    end

    if misc_tab.swag:get() then
        visuals_func.swag()
    end

    if misc_tab.manualarrows:get() then
        visuals_func.manual_arrows()
    end

    if misc_tab.clantag:get() then
        visuals_func.clan_tag(visuals_func.ct_animation())
    else
        visuals_func.clan_tag(" ")
    end

    if misc_tab.watermark2k18:get() then 
		visuals_func.wm2k18()
	end
end)

events.post_update_clientside_animation:set(animbreak)

local config_all = pui.setup({antiaim_tab, antiaims_settings}, true)
main_tab.default = tab.main_other:button("Default Config" , function()
    config_all:load(json.parse(base64.decode("W3siYW5pbV9icmVha2VycyI6ZmFsc2UsImRlZmVuc2l2ZV9zcGFtIjpmYWxzZSwiZGlzYWJsZV95YXdfbW9kaWZpZXJzX2ZyZWVzdGFuZGluZyI6ZmFsc2UsImVuYWJsZWQiOnRydWUsImZyZWVzdGFuZGluZyI6ZmFsc2UsInByZXNldHMiOiJCdWlsZGVyIiwic3RhdGVzIjoiQ3JvdWNoaW5nIiwic3RhdGljX21hbnVhbHMiOmZhbHNlLCJ0d2Vha3MiOlsiU2FmZSBIZWFkIiwiQXZvaWQgQmFja3N0YWIiLCJEaXNhYmxlIG9uIFJvdW5kIEVuZCIsIkRpc2FibGUgb24gV2FybXVwIiwifiJdLCJ5YXdfYmFzZSI6IkF0IFRhcmdldCJ9LFt7ImJvZHlfeWF3X29wdGlvbnMiOlsifiJdLCJib2R5X3lhd19zZWxlY3QiOmZhbHNlLCJoaWRkZW5fYWEiOmZhbHNlLCJoaWRkZW5fb3B0aW9ucyI6IkFsd2F5cyBPbiIsImhpZGRlbl9waXRjaCI6IkRpc2FibGVkIiwiaGlkZGVuX3lhdyI6IkRpc2FibGVkIiwibF9ib2R5X3lhdyI6NTguMCwibF95YXciOjAuMCwib3ZlcnJpZGVfc3RhdGUiOmZhbHNlLCJwaXRjaF9zZWxlY3QiOiJEaXNhYmxlZCIsInJfYm9keV95YXciOjU4LjAsInJfeWF3IjowLjAsInNsb3dfaml0dGVyIjpmYWxzZSwic2xvd190aWNrcyI6MS4wLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0X3NlbGVjdCI6MC4wLCJ5YXdfbW9kaWZpZXJfc2VsZWN0IjoiRGlzYWJsZWQiLCJ5YXdfc2VsZWN0IjoiRGlzYWJsZWQifSx7ImJvZHlfeWF3X29wdGlvbnMiOlsifiJdLCJib2R5X3lhd19zZWxlY3QiOnRydWUsImhpZGRlbl9hYSI6ZmFsc2UsImhpZGRlbl9vcHRpb25zIjoiQWx3YXlzIE9uIiwiaGlkZGVuX3BpdGNoIjoiRGlzYWJsZWQiLCJoaWRkZW5feWF3IjoiRGlzYWJsZWQiLCJsX2JvZHlfeWF3Ijo1OC4wLCJsX3lhdyI6LTI4LjAsIm92ZXJyaWRlX3N0YXRlIjp0cnVlLCJwaXRjaF9zZWxlY3QiOiJEb3duIiwicl9ib2R5X3lhdyI6NTguMCwicl95YXciOjQwLjAsInNsb3dfaml0dGVyIjp0cnVlLCJzbG93X3RpY2tzIjo0LjAsInlhd19tb2RpZmllcl9vZmZzZXRfc2VsZWN0IjowLjAsInlhd19tb2RpZmllcl9zZWxlY3QiOiJEaXNhYmxlZCIsInlhd19zZWxlY3QiOiJCYWNrd2FyZCJ9LHsiYm9keV95YXdfb3B0aW9ucyI6WyJ+Il0sImJvZHlfeWF3X3NlbGVjdCI6dHJ1ZSwiaGlkZGVuX2FhIjpmYWxzZSwiaGlkZGVuX29wdGlvbnMiOiJBbHdheXMgT24iLCJoaWRkZW5fcGl0Y2giOiJEaXNhYmxlZCIsImhpZGRlbl95YXciOiJEaXNhYmxlZCIsImxfYm9keV95YXciOjU4LjAsImxfeWF3IjotMjguMCwib3ZlcnJpZGVfc3RhdGUiOnRydWUsInBpdGNoX3NlbGVjdCI6IkRvd24iLCJyX2JvZHlfeWF3Ijo1OC4wLCJyX3lhdyI6MzQuMCwic2xvd19qaXR0ZXIiOnRydWUsInNsb3dfdGlja3MiOjguMCwieWF3X21vZGlmaWVyX29mZnNldF9zZWxlY3QiOjAuMCwieWF3X21vZGlmaWVyX3NlbGVjdCI6IkRpc2FibGVkIiwieWF3X3NlbGVjdCI6IkJhY2t3YXJkIn0seyJib2R5X3lhd19vcHRpb25zIjpbIn4iXSwiYm9keV95YXdfc2VsZWN0Ijp0cnVlLCJoaWRkZW5fYWEiOnRydWUsImhpZGRlbl9vcHRpb25zIjoiQWx3YXlzIE9uIiwiaGlkZGVuX3BpdGNoIjoiWmVybyIsImhpZGRlbl95YXciOiJTcGluIiwibF9ib2R5X3lhdyI6NTguMCwibF95YXciOi0xOC4wLCJvdmVycmlkZV9zdGF0ZSI6dHJ1ZSwicGl0Y2hfc2VsZWN0IjoiRG93biIsInJfYm9keV95YXciOjU4LjAsInJfeWF3Ijo0Ny4wLCJzbG93X2ppdHRlciI6dHJ1ZSwic2xvd190aWNrcyI6MS4wLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0X3NlbGVjdCI6MC4wLCJ5YXdfbW9kaWZpZXJfc2VsZWN0IjoiRGlzYWJsZWQiLCJ5YXdfc2VsZWN0IjoiQmFja3dhcmQifSx7ImJvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19zZWxlY3QiOnRydWUsImhpZGRlbl9hYSI6ZmFsc2UsImhpZGRlbl9vcHRpb25zIjoiQWx3YXlzIE9uIiwiaGlkZGVuX3BpdGNoIjoiRGlzYWJsZWQiLCJoaWRkZW5feWF3IjoiRGlzYWJsZWQiLCJsX2JvZHlfeWF3Ijo1OC4wLCJsX3lhdyI6LTIwLjAsIm92ZXJyaWRlX3N0YXRlIjp0cnVlLCJwaXRjaF9zZWxlY3QiOiJEb3duIiwicl9ib2R5X3lhdyI6NTguMCwicl95YXciOjE2LjAsInNsb3dfaml0dGVyIjpmYWxzZSwic2xvd190aWNrcyI6MS4wLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0X3NlbGVjdCI6LTMwLjAsInlhd19tb2RpZmllcl9zZWxlY3QiOiJDZW50ZXIiLCJ5YXdfc2VsZWN0IjoiQmFja3dhcmQifSx7ImJvZHlfeWF3X29wdGlvbnMiOlsifiJdLCJib2R5X3lhd19zZWxlY3QiOnRydWUsImhpZGRlbl9hYSI6dHJ1ZSwiaGlkZGVuX29wdGlvbnMiOiJBbHdheXMgT24iLCJoaWRkZW5fcGl0Y2giOiJEb3duIiwiaGlkZGVuX3lhdyI6Ik9wcG9zaXRlIiwibF9ib2R5X3lhdyI6NTguMCwibF95YXciOi0yMC4wLCJvdmVycmlkZV9zdGF0ZSI6dHJ1ZSwicGl0Y2hfc2VsZWN0IjoiRG93biIsInJfYm9keV95YXciOjU4LjAsInJfeWF3IjoyOC4wLCJzbG93X2ppdHRlciI6dHJ1ZSwic2xvd190aWNrcyI6OS4wLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0X3NlbGVjdCI6MC4wLCJ5YXdfbW9kaWZpZXJfc2VsZWN0IjoiRGlzYWJsZWQiLCJ5YXdfc2VsZWN0IjoiQmFja3dhcmQifSx7ImJvZHlfeWF3X29wdGlvbnMiOlsifiJdLCJib2R5X3lhd19zZWxlY3QiOnRydWUsImhpZGRlbl9hYSI6ZmFsc2UsImhpZGRlbl9vcHRpb25zIjoiQWx3YXlzIE9uIiwiaGlkZGVuX3BpdGNoIjoiRGlzYWJsZWQiLCJoaWRkZW5feWF3IjoiRGlzYWJsZWQiLCJsX2JvZHlfeWF3Ijo1OC4wLCJsX3lhdyI6LTE2LjAsIm92ZXJyaWRlX3N0YXRlIjp0cnVlLCJwaXRjaF9zZWxlY3QiOiJEb3duIiwicl9ib2R5X3lhdyI6NTguMCwicl95YXciOjM5LjAsInNsb3dfaml0dGVyIjp0cnVlLCJzbG93X3RpY2tzIjoxLjAsInlhd19tb2RpZmllcl9vZmZzZXRfc2VsZWN0IjowLjAsInlhd19tb2RpZmllcl9zZWxlY3QiOiJEaXNhYmxlZCIsInlhd19zZWxlY3QiOiJCYWNrd2FyZCJ9LHsiYm9keV95YXdfb3B0aW9ucyI6WyJBdm9pZCBPdmVybGFwIiwiQW50aSBCcnV0ZWZvcmNlIiwifiJdLCJib2R5X3lhd19zZWxlY3QiOnRydWUsImhpZGRlbl9hYSI6ZmFsc2UsImhpZGRlbl9vcHRpb25zIjoiQWx3YXlzIE9uIiwiaGlkZGVuX3BpdGNoIjoiRGlzYWJsZWQiLCJoaWRkZW5feWF3IjoiRGlzYWJsZWQiLCJsX2JvZHlfeWF3Ijo1OC4wLCJsX3lhdyI6MC4wLCJvdmVycmlkZV9zdGF0ZSI6dHJ1ZSwicGl0Y2hfc2VsZWN0IjoiRG93biIsInJfYm9keV95YXciOjU4LjAsInJfeWF3IjowLjAsInNsb3dfaml0dGVyIjpmYWxzZSwic2xvd190aWNrcyI6MS4wLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0X3NlbGVjdCI6MC4wLCJ5YXdfbW9kaWZpZXJfc2VsZWN0IjoiRGlzYWJsZWQiLCJ5YXdfc2VsZWN0IjoiQmFja3dhcmQifV1d")))
    cvar.play:call("ambient\\tones\\elev1")
end, true):depend({main_tab.select_tab, 1})
main_tab.export = tab.main_other:button("\f<file-export> Export ", function()
    clipboard.set(base64.encode(json.stringify(config_all:save())))
    cvar.play:call("ambient\\tones\\elev1")
end, true):depend({main_tab.select_tab, 1})
main_tab.import = tab.main_other:button("\f<file-import> Import ", function()
    config_all:load(json.parse(base64.decode(clipboard.get())))
    cvar.play:call("ambient\\tones\\elev1")
end, true):depend({main_tab.select_tab, 1})