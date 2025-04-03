-- API函数的局部变量 对以下行的任何更改都将在重新生成时丢失
local ffi = require "ffi"
local bit_band, bit_bnot, bit_bor, bit_lshift = bit.band, bit.bnot, bit.bor, bit.lshift
local menu_add_checkbox, menu_add_slider, menu_add_selection, menu_add_multi_selection, menu_set_group_visibility, menu_is_open, menu_find, Globals_ChokedCommands, render_create_font, render_text, render_get_screen_size, render_rect_fade, render_get_text_size, antiaim_get_max_desync_range, antiaim_get_real_angle, antiaim_get_fake_angle, antiaim_get_manual_override, exploits_get_charge = menu.add_checkbox, menu.add_slider, menu.add_selection, menu.add_multi_selection, menu.set_group_visibility, menu.is_open, menu.find, engine.get_choked_commands, render.create_font, render.text, render.get_screen_size, render.rect_fade, render.get_text_size, antiaim.get_max_desync_range, antiaim.get_real_angle, antiaim.get_fake_angle, antiaim.get_manual_override, exploits.get_charge

local ui_handler = {}
local conditional_hitchance = {}
local handlers = {}
local font = {}
local entity_helpers = {}
local dormant_aimbot = {}
local ffi_handler = {}
local doubletap_controller = {}
local defines = {}
local viewmodel_in_scope = {}
local visual_controller = {}
local bind_system = {}
local antiaim_vars = {}
local roll_antiaim = {}
local default_AntiAims = {}
local conditional_AntiAims = {}
local fakeLag = {}
local primordial_refs = {}
local edge_yaw = {}
local exploit_air = {}
local animation_breaker = {}
local anti_bruteforce = {}
local hitlogs = {}
local console_color = {}
local menu_effects = {}
local custom_scope = {}
local fakelag_indicator = {}
local crosshair_indicator = {}
local manual_arrows = {}
local damage_marker = {}
local configs = {}
local kill_say = {}
local hitlog = {}
local shutdown = {}

kill_say.phrases = {
    "LOL You just like a walk-bot ^^",
    "获得全球最强力的脚本支持,购买Paradise for Primordial赢得游戏 ^^",
    "Hello, you've been killed defeated by Paradise Lua ^^",
    "L Where's ur IQ??? ^^",
    "Paradise脚本将会带您披荆斩棘,支配您的每一位对手 ^^",
    "Code by top author: Cycle1337 ^^",
    "Mom? Dad? ^^",
    "Get the best config&script: Parad1se#1912",
    "感谢你,小臭狗,你好像你妈的发霉骚b在抽动着你的舌头 ^^",
    "Your fucking bitch ^^",
    "你没有女朋友，你他妈的猫，你是一个动物 ^^",
    "Paradise Lua > All script item for primordial. ^^",
    "去你妈的婊子,你像个无力的走路机器人一般可怜 ^^",
    "Want to dominate your enemies? Get Paradise now for the best experience ^^",
}

local screen_size = render_get_screen_size()

local debug = function(...)
    return print(...)
end

local math_desync = function (val)
    local p_desync = (val / 60) * 100
    return p_desync
end

local math_round = function(value)
    value = tonumber(value) or 0
    return math.floor(value + 0.5)
end

-- TODO: 将这些变量移动到一个表中 以避免将来的区块限制为200。
local   IN_ATTACK			= bit_lshift(1, 0) -- Fire weapon
local   IN_JUMP				= bit_lshift(1, 1) -- Jump
local   IN_DUCK				= bit_lshift(1, 2) -- Crouch
local   IN_FORWARD			= bit_lshift(1, 3) -- Walk forward
local   IN_BACK				= bit_lshift(1, 4) -- Walk backwards
local   IN_USE				= bit_lshift(1, 5) -- Use (Defuse bomb, etc...)
local   IN_CANCEL			= bit_lshift(1, 6) -- ¿ ?
local   IN_LEFT				= bit_lshift(1, 7) -- Walk left
local   IN_RIGHT			= bit_lshift(1, 8) -- Walk right
local   IN_MOVELEFT			= bit_lshift(1, 9) -- Alias? (not sure)
local   IN_MOVERIGHT		= bit_lshift(1, 10) -- Alias? (not sure)
local   IN_ATTACK2			= bit_lshift(1, 11) -- Secondary fire (Revolver, Glock change fire mode, Famas change fire mode) (not sure)
local   IN_RUN				= bit_lshift(1, 12)
local   IN_RELOAD			= bit_lshift(1, 13) -- Reload weapon
local   IN_ALT1				= bit_lshift(1, 14)
local   IN_ALT2				= bit_lshift(1, 15)
local   IN_SCORE			= bit_lshift(1, 16)
local   IN_SPEED			= bit_lshift(1, 17)
local   IN_WALK				= bit_lshift(1, 18) -- Shift
local   IN_ZOOM				= bit_lshift(1, 19) -- Zoom weapon (not sure)
local   IN_WEAPON1			= bit_lshift(1, 20)
local   IN_WEAPON2			= bit_lshift(1, 21)
local   IN_BULLRUSH			= bit_lshift(1, 22)

local   FL_ONGROUND	        = bit_lshift(1, 0)
local   FL_DUCKING	        = bit_lshift(1, 1)
local   FL_WATERJUMP        = bit_lshift(1, 3)
local   FL_ONTRAIN	        = bit_lshift(1, 4)
local   FL_INRAIN	        = bit_lshift(1, 5)
local   FL_FROZEN	        = bit_lshift(1, 6)
local   FL_ATCONTROLS       = bit_lshift(1, 7)
local   FL_CLIENT	        = bit_lshift(1, 8)
local   FL_FAKECLIENT       = bit_lshift(1, 9)
local   FL_INWATER	        = bit_lshift(1, 10)

primordial_refs.slow_walk = menu_find("misc", "main", "movement", "slow walk")
primordial_refs.double_tap = menu_find("aimbot", "general", "exploits", "doubletap", "enable")
primordial_refs.enableAA = menu_find("antiaim", "main", "general", "enable")
primordial_refs.fakelagLimit = menu_find("antiaim", "main", "fakelag", "amount")
primordial_refs.BreakLC = menu_find("antiaim", "main", "fakelag", "break lag compensation")
primordial_refs.manualleft = menu_find("antiaim", "main", "manual", "left")
primordial_refs.manualback = menu_find("antiaim", "main", "manual", "back")
primordial_refs.manualright = menu_find("antiaim", "main", "manual", "right")
primordial_refs.freestanding = menu_find("antiaim", "main", "auto direction", "enable")
primordial_refs.inverter = menu_find("antiaim", "main", "manual", "invert desync")
primordial_refs.roll_aa = {menu_find("antiaim", "main", "angles", "body lean"), menu_find("antiaim", "main", "angles", "body lean value")}
primordial_refs.yaw_add = menu_find("antiaim", "main", "angles", "yaw add")
primordial_refs.yaw_modifier = menu_find("antiaim", "main", "angles", "jitter mode")
primordial_refs.modifier_degree = menu_find("antiaim", "main", "angles", "jitter add")
primordial_refs.side = menu_find("antiaim", "main", "desync", "stand", "side")
primordial_refs.fake_limit_left = menu_find("antiaim", "main", "desync", "stand", "left amount")
primordial_refs.fake_limit_right = menu_find("antiaim", "main", "desync", "stand", "right amount")

defines.onShotFire = false

defines.OnFireUpdate_start = function (shot)
    defines.onShotFire = true
end

defines.noscope_weapons = {
    [261] = true, 
    [242] = true, 
    [233] = true, 
    [267] = true
}

defines.miss_reasons = {
    [0] = "hit",
    [1] = "resolver",
    [2] = "spread",
    [3] = "occlusion",
    [4] = "pred. error",
}

defines.hitgroups = {
    [0] = "generic",
    [1] = "head",
    [2] = "chest",
    [3] = "stomach",
    [4] = "left arm",
    [5] = "right arm",
    [6] = "left leg",
    [7] = "right leg",
    [10] = "gear"
}

defines.Nades = {
    "CHEGrenade",
    "CIncendiaryGrenade",
    "CSmokeGrenade",
    "CFlashbang",
    "CDecoyGrenade",
    "CMolotovGrenade"
}

defines.hitgroup_to_hitbox = {0, 5, 2, 13, 14, 7, 8}

defines.playerStates = {
    "Shared",
    "On Use",
    "Standing",
    "Crouching",
    "Slowwalk",
    "Moving",
    "Air"
}

defines.cvars = {}

defines.cvars.sv_maxusrcmdprocessticks = cvars.sv_maxusrcmdprocessticks
defines.cvars.fov_cs_debug = cvars.fov_cs_debug

font.Calibrib = render_create_font("Calibri Bold", 30, 600, e_font_flags.DROPSHADOW)
font.Verdana12 = render_create_font("Verdana", 12, 200, e_font_flags.DROPSHADOW)


ui_handler.tabSelection = menu_add_selection("Welcome to Paradise", "Tab Selection", {"Global", "Visuals", "Anti Aims", "Fake Lag", "Misc", "Configs"})
ui_handler.global_masterSwitch = menu_add_checkbox("Global", "Enable", false)
ui_handler.doubletap_knife = menu_add_checkbox("Global", "Doubletap knife", false)
ui_handler.custom_air_hitchance = menu_add_checkbox("Global", "Custom Air Hitchance", false)
ui_handler.air_hitchance = menu_add_slider("Global", "Air Hitchance", 0, 100)
ui_handler.doubletap_speed = menu_add_checkbox("Global", "Change DT Speed", false)
ui_handler.doubletap_speed_value = menu_add_slider("Global", "DT Speed", 4, 18)
ui_handler.disable_charge = menu_add_checkbox("Global", "Disable Charge On Enemies Visible", false)
ui_handler.anim_breaker = menu_add_multi_selection("Global", "Animation Breaker", {"Ground", "Air", "Zero Pitch on Land"})

ui_handler.visuals_masterSwitch = menu_add_checkbox("Visuals", "Enable", false)
ui_handler.visuals_FakeLag_switch = menu_add_checkbox("Visuals", "FakeLag History", false)
ui_handler.visuals_crosshairIndicator_type = menu_add_selection("Visuals", "Crosshair Indicators", {"Disabled", "Sharp"})
ui_handler.visuals_crosshairIndicator_mainColor = ui_handler.visuals_crosshairIndicator_type:add_color_picker("Main")
ui_handler.visuals_crosshairIndicator_sideColor = ui_handler.visuals_crosshairIndicator_type:add_color_picker("Side")
ui_handler.visuals_crosshairIndicator_desyncColor = ui_handler.visuals_crosshairIndicator_type:add_color_picker("Desync")

ui_handler.antiaims_masterSwitch = menu_add_checkbox("Anti Aims", "Enable", false)
ui_handler.antiaims_inverter = menu_add_checkbox("Anti Aims", "Inverter")
ui_handler.antiaims_inverter_bind = ui_handler.antiaims_inverter:add_keybind("Inverter key")

ui_handler.antiaims_lc_air = menu_add_checkbox("Anti Aims", "Exploit Teleport In Air", false)
ui_handler.antiaims_rollaa = menu_add_selection("Anti Aims", "Roll AA", {"Default", "Same Side", "Invert"})
ui_handler.antiaims_rollaa_bind = ui_handler.antiaims_rollaa:add_keybind("Roll AA key")

conditional_AntiAims.antiaims_condition = menu_add_checkbox("Anti Aims", "Conditions", false)
conditional_AntiAims.current_condition = menu_add_selection("Anti Aims", "Current Condition", defines.playerStates)


default_AntiAims.yaw_add_left = menu_add_slider("Anti Aim Preset", "Yaw Add Left", -180, 180)
default_AntiAims.yaw_add_right = menu_add_slider("Anti Aim Preset", "Yaw Add Right", -180, 180)
default_AntiAims.yaw_modifier = menu_add_selection("Anti Aim Preset", "Yaw Modifier", {"Disabled", "Center", "Offset", "Random"})
default_AntiAims.modifier_degree = menu_add_slider("Anti Aim Preset", "Modifier Degree", -180, 180)
default_AntiAims.fake_limit_combo = menu_add_selection("Anti Aim Preset", "Fake Limit Mode", {"Static", "Jitter"})
default_AntiAims.fake_limit_left = menu_add_slider("Anti Aim Preset", "Fake Limit Left", 0, 60)
default_AntiAims.fake_limit_right = menu_add_slider("Anti Aim Preset", "Fake Limit Right", 0, 60)
default_AntiAims.slowwalk_custom = menu_add_checkbox("Anti Aim Preset", "Custom Slowwalk Fake Limit", false)
default_AntiAims.slowwalk_limit = menu_add_slider("Anti Aim Preset", "Slowwalk Fake Limit", 5, 45)
default_AntiAims.fake_options = menu_add_multi_selection("Anti Aim Preset", "Fake Options", {"Avoid Overlap", "Jitter", "Randomize Jitter"})

for i in ipairs (defines.playerStates) do
    local name = defines.playerStates[i]
    conditional_AntiAims[name] = {
        is_override = menu_add_checkbox("Anti Aims", "Override ".. name, false),
        yaw_add_left = menu_add_slider(name, "Yaw Add Left", -180, 180),
        yaw_add_right = menu_add_slider(name, "Yaw Add Right", -180, 180),
        yaw_modifier = menu_add_selection(name, "Yaw Modifier", {"Disabled", "Center", "Offset", "Random"}),
        modifier_degree = menu_add_slider(name, "Modifier Degree", -180, 180),
        fake_limit_combo = menu_add_selection(name, "Fake Limit Mode", {"Static", "Jitter"}),
        fake_limit_left = menu_add_slider(name, "Fake Limit Left", 0, 60),
        fake_limit_right = menu_add_slider(name, "Fake Limit Right", 0, 60),
        fake_options = menu_add_multi_selection(name, "Fake Options", {"Avoid Overlap", "Jitter", "Randomize Jitter"}),
    }
end

conditional_AntiAims.is_manual_enabled = function ()
    return antiaim_get_manual_override() ~= 0 or primordial_refs.freestanding[2]:get()
end

ui_handler.fakelag_masterSwitch = menu_add_checkbox("Fake Lag", "Enable", false)
ui_handler.fakelag_standSend = menu_add_checkbox("Fake Lag", "Disable On Standing", false)
ui_handler.fakelag_dormantSend = menu_add_checkbox("Fake Lag", "Disable On Enemies Dormant", false)
ui_handler.fakelag_nadeSend = menu_add_checkbox("Fake Lag", "Disable On Nades", false)
ui_handler.fakelag_mode = menu_add_selection("Fake Lag", "Fake-Lag Mode", {"HVH", "Valve", "Step", "Maximum", "Velocity"})

ui_handler.misc_masterSwitch = menu_add_checkbox("Misc", "Enable", false)
ui_handler.misc_trashTalk = menu_add_checkbox("Misc", "TrashTalk on Kill", false)

ui_handler.global_onDraw = function ()
    if not menu_is_open() then
        return
    end

    local isGlobal = ui_handler.tabSelection:get() == 1 and ui_handler.global_masterSwitch:get()

    ui_handler.global_masterSwitch:set_visible(ui_handler.tabSelection:get() == 1)
    ui_handler.doubletap_knife:set_visible(isGlobal)
    ui_handler.custom_air_hitchance:set_visible(isGlobal)
    ui_handler.air_hitchance:set_visible(isGlobal and ui_handler.custom_air_hitchance:get())
    ui_handler.doubletap_speed:set_visible(isGlobal)
    ui_handler.doubletap_speed_value:set_visible(isGlobal and ui_handler.doubletap_speed:get())
    ui_handler.disable_charge:set_visible(isGlobal)
    ui_handler.anim_breaker:set_visible(isGlobal)
end

ui_handler.visuals_onDraw = function ()
    if not menu_is_open() then
        return
    end

    local isVisuals = ui_handler.tabSelection:get() == 2 and ui_handler.visuals_masterSwitch:get()

    ui_handler.visuals_masterSwitch:set_visible(ui_handler.tabSelection:get() == 2)

    ui_handler.visuals_FakeLag_switch:set_visible(isVisuals)
    ui_handler.visuals_crosshairIndicator_type:set_visible(isVisuals)
end

ui_handler.antiaims_onDraw = function ()
    if not menu_is_open() then
        return
    end

    local isAntiAims = ui_handler.tabSelection:get() == 3 and ui_handler.antiaims_masterSwitch:get()

    ui_handler.antiaims_masterSwitch:set_visible(ui_handler.tabSelection:get() == 3)

    ui_handler.antiaims_inverter:set_visible(isAntiAims)
    ui_handler.antiaims_lc_air:set_visible(isAntiAims)
    ui_handler.antiaims_rollaa:set_visible(isAntiAims)

    conditional_AntiAims.antiaims_condition:set_visible(isAntiAims)
    conditional_AntiAims.current_condition:set_visible(isAntiAims and conditional_AntiAims.antiaims_condition:get())

    local shouldDefaultAA = isAntiAims and not conditional_AntiAims.antiaims_condition:get()
    default_AntiAims.yaw_add_left:set_visible(shouldDefaultAA)
    default_AntiAims.yaw_add_right:set_visible(shouldDefaultAA)
    default_AntiAims.yaw_modifier:set_visible(shouldDefaultAA)
    default_AntiAims.modifier_degree:set_visible(shouldDefaultAA)
    default_AntiAims.fake_limit_combo:set_visible(shouldDefaultAA)
    default_AntiAims.fake_limit_left:set_visible(shouldDefaultAA)
    default_AntiAims.fake_limit_right:set_visible(shouldDefaultAA)
    default_AntiAims.slowwalk_custom:set_visible(shouldDefaultAA)
    default_AntiAims.slowwalk_limit:set_visible(shouldDefaultAA)
    default_AntiAims.fake_options:set_visible(shouldDefaultAA)

    conditional_AntiAims["Shared"].is_override:set(true)

    for i in ipairs (defines.playerStates) do
        local name = defines.playerStates[i]

        local enabled_d = isAntiAims and defines.playerStates[conditional_AntiAims.current_condition:get()] == name and conditional_AntiAims.antiaims_condition:get()

        conditional_AntiAims[name].is_override:set_visible(true and name ~= "Shared" and isAntiAims and conditional_AntiAims.antiaims_condition:get() and defines.playerStates[conditional_AntiAims.current_condition:get()] == name)
        conditional_AntiAims[name].yaw_add_left:set_visible(enabled_d and conditional_AntiAims[name].is_override:get())
        conditional_AntiAims[name].yaw_add_right:set_visible(enabled_d and conditional_AntiAims[name].is_override:get())
        conditional_AntiAims[name].yaw_modifier:set_visible(enabled_d and conditional_AntiAims[name].is_override:get())
        conditional_AntiAims[name].modifier_degree:set_visible(enabled_d and conditional_AntiAims[name].is_override:get())
        conditional_AntiAims[name].fake_limit_combo:set_visible(enabled_d and conditional_AntiAims[name].is_override:get())
        conditional_AntiAims[name].fake_limit_left:set_visible(enabled_d and conditional_AntiAims[name].is_override:get())
        conditional_AntiAims[name].fake_limit_right:set_visible(enabled_d and conditional_AntiAims[name].is_override:get())
        conditional_AntiAims[name].fake_options:set_visible(enabled_d and conditional_AntiAims[name].is_override:get())
    end
end

ui_handler.fakelag_onDraw = function ()
    if not menu_is_open() then
        return
    end

    local isFakeLag = ui_handler.tabSelection:get() == 4 and ui_handler.fakelag_masterSwitch:get()

    ui_handler.fakelag_masterSwitch:set_visible(ui_handler.tabSelection:get() == 4)
    ui_handler.fakelag_standSend:set_visible(isFakeLag)
    ui_handler.fakelag_dormantSend:set_visible(isFakeLag)
    ui_handler.fakelag_nadeSend:set_visible(isFakeLag)
    ui_handler.fakelag_mode:set_visible(isFakeLag)
end

ui_handler.misc_onDraw = function ()
    if not menu_is_open() then
        return
    end

    local isMisc = ui_handler.tabSelection:get() == 5 and ui_handler.misc_masterSwitch:get()

    ui_handler.misc_masterSwitch:set_visible(ui_handler.tabSelection:get() == 5)
    ui_handler.misc_trashTalk:set_visible(isMisc)
end

handlers.recharge = 0
handlers.dt = false
handlers.Knife = function ()
    if not ui_handler.global_masterSwitch:get() or not ui_handler.doubletap_knife:get() then
        return
    end

    local localPlayer = entity_list.get_local_player()

    if not localPlayer or not localPlayer:get_active_weapon() then
        return
    end

    if localPlayer:get_active_weapon():get_class_name() ~= "CKnife" then
        return
    end

    if handlers.dt and handlers.recharge + 15 == global_vars.tick_count() then
        exploits.force_uncharge()
        handlers.dt = false
    end
end
handlers.DTknife = function (event)
    if not ui_handler.global_masterSwitch:get() or not ui_handler.doubletap_knife:get() then
        return
    end

    local localPlayer = entity_list.get_local_player()

    if not localPlayer or not localPlayer:get_active_weapon() then
        return
    end

    if localPlayer:get_active_weapon():get_class_name() ~= "CKnife" then
        return
    end

    local userid = entity_list.get_player_from_userid(event.userid)

    if userid ~= localPlayer then
        return
    end

    debug("Knifed!")

    handlers.recharge = global_vars.tick_count()
    
    if primordial_refs.double_tap[2]:get() then
        exploits.force_uncharge()
        handlers.dt = true
    end
end

conditional_hitchance.air = function(ctx, cmd, unpredicted_data)
    if not ui_handler.global_masterSwitch:get() or not ui_handler.custom_air_hitchance:get() then
        return
    end

    local localPlayer = entity_list.get_local_player()

    if not localPlayer then
        return
    end

    local flags = localPlayer:get_prop("m_fFlags")
    local is_in_air = bit_band(flags, FL_ONGROUND) == 0

    if not is_in_air then
        return
    end

    ctx:set_hitchance(ui_handler.air_hitchance:get())
end

doubletap_controller.handle = function (cmd)
    if not ui_handler.global_masterSwitch:get() or not ui_handler.doubletap_speed:get() then
        return
    end

    defines.cvars.sv_maxusrcmdprocessticks:set_int(ui_handler.doubletap_speed_value:get())
end

local function are_have_weapon(ent)
    if not ent:is_alive() or not ent:get_active_weapon() then return end
    local t_cur_wep = ent:get_active_weapon():get_class_name()
    return t_cur_wep ~= "CKnife" and t_cur_wep ~= "CC4" and t_cur_wep ~= "CMolotovGrenade" and t_cur_wep ~= "CSmokeGrenade" and t_cur_wep ~= "CHEGrenade" and t_cur_wep ~= "CWeaponTaser"
end
local function are_them_visibles(ent)
    local local_p = entity_list:get_local_player()
    local generic_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    local left_arm_pos = ent:get_hitbox_pos(e_hitgroups.LEFT_ARM)
    local right_arm_pos = ent:get_hitbox_pos(e_hitgroups.RIGHT_ARM)
    if local_p:is_point_visible(generic_pos) or local_p:is_point_visible(left_arm_pos) or local_p:is_point_visible(right_arm_pos) then return true else return false end
end

doubletap_controller.charge = function (cmd)
    if not ui_handler.global_masterSwitch:get() or not ui_handler.disable_charge:get() then
        exploits.allow_recharge()
        return
    end

    if not primordial_refs.double_tap[2]:get() then
        exploits.allow_recharge()
        return
    end

    local enemies = entity_list.get_players(true)

    for i, v in ipairs(enemies) do
        if are_them_visibles(v) and are_have_weapon(v) then
            exploits.block_recharge()
        else
            exploits.allow_recharge()
        end
    end
end

animation_breaker.ground_tick = 1
animation_breaker.end_time = 0
animation_breaker.handle = function (poseparam)
    if not ui_handler.global_masterSwitch:get() then
        return
    end

    local localPlayer = entity_list.get_local_player()

    if not localPlayer then
        return
    end

    local flags = localPlayer:get_prop("m_fFlags")
    local on_land = bit_band(flags, FL_ONGROUND) ~= 0
    local is_in_air = bit_band(flags, FL_ONGROUND) == 0

    local m_vecVelocity = localPlayer:get_prop("m_vecVelocity")
    local p_still = math.sqrt(m_vecVelocity[0] ^ 2 + m_vecVelocity[1] ^ 2)

	local curtime = global_vars.cur_time() 

	if on_land == true then
		animation_breaker.ground_tick = animation_breaker.ground_tick + 1
	else
		animation_breaker.ground_tick = 0
		animation_breaker.end_time = curtime + 1
	end

    if p_still > 1 then
        poseparam:set_render_animlayer(e_animlayers.LEAN, 1)
    end

    if ui_handler.anim_breaker:get(1) then
        poseparam:set_render_pose(e_poses.RUN, 1)
    end

	if ui_handler.anim_breaker:get(2) and is_in_air then
		poseparam:set_render_pose(e_poses.JUMP_FALL, 1)
	end

    if ui_handler.anim_breaker:get(3) and animation_breaker.ground_tick > 1 and animation_breaker.end_time > curtime then
		poseparam:set_render_pose(e_poses.BODY_PITCH, 0.5)
	end
end

fakeLag.OldChoke, fakeLag.Choked0, fakeLag.Choked1, fakeLag.Choked2, fakeLag.Choked3, fakeLag.Choked4 = 0,0,0,0,0,0
fakelag_indicator.Draw = function ()
    if not ui_handler.visuals_FakeLag_switch:get() or not ui_handler.visuals_masterSwitch:get() then
        return
    end

    local localPlayer = entity_list.get_local_player()

    if not localPlayer or not localPlayer:is_alive() then
        return
    end

    local x, y = screen_size.x / 2 - 72, screen_size.y - 150

    local Choking = Globals_ChokedCommands()

    if Choking < fakeLag.OldChoke then
        fakeLag.Choked0 = fakeLag.Choked1
        fakeLag.Choked1 = fakeLag.Choked2
        fakeLag.Choked2 = fakeLag.Choked3
        fakeLag.Choked3 = fakeLag.Choked4
        fakeLag.Choked4 = fakeLag.OldChoke
    end

    fakeLag.OldChoke = Choking

    render_text(font.Calibrib, string.format('%i - %i - %i - %i - %i',fakeLag.Choked4,fakeLag.Choked3,fakeLag.Choked2,fakeLag.Choked1,fakeLag.Choked0), vec2_t(x, y), color_t(255, 255, 255, 255))
end

crosshair_indicator.Draw = function ()
    if ui_handler.visuals_crosshairIndicator_type:get() == 0 or not ui_handler.visuals_masterSwitch:get() then
        return
    end

    local localPlayer = entity_list.get_local_player()

    if not localPlayer or not localPlayer:is_alive() then
        return
    end

    local x,y = screen_size.x / 2, screen_size.y / 2

    local indicators_logo_color   = ui_handler.visuals_crosshairIndicator_mainColor:get()
    local indicators_desync_color = ui_handler.visuals_crosshairIndicator_sideColor:get()
    local indicators_bar_color    = ui_handler.visuals_crosshairIndicator_desyncColor:get()

    local paradise_text = conditional_AntiAims.is_manual_enabled() and "MANUAL AA" or "PARADISE LUA"

    local active_color, non_active_color = indicators_desync_color, indicators_logo_color

    if antiaim_vars.side then
        left_color = active_color
        right_color = non_active_color
    else
        left_color = non_active_color
        right_color = active_color
    end

    if math.abs(antiaim_get_real_angle() - antiaim_get_fake_angle()) > 60 then
        desync_angle = 60
    else
        desync_angle = math.abs(antiaim_get_real_angle() - antiaim_get_fake_angle())
    end

    if ui_handler.visuals_crosshairIndicator_type:get() == 2 then
        local paradise_sz = render_get_text_size(font.Verdana12 ,"PARADISE LUA")

        render_text(font.Verdana12, math_round(desync_angle).."°",  vec2_t(x - 10, y + 22),color_t(0, 0, 0, 255))
        render_text(font.Verdana12, math_round(desync_angle).."°", vec2_t(x - 9, y + 22),color_t(255, 255, 255, 255))

        render_rect_fade(vec2_t(x,y + 40), vec2_t(desync_angle, 1), indicators_bar_color, color_t(0, 0, 0, 0), true)
        render_rect_fade(vec2_t(x-desync_angle,y + 40), vec2_t(desync_angle + 1, 1), color_t(0, 0, 0, 0), indicators_bar_color, true)

        if paradise_text == "PARADISE LUA" then
            render_text(font.Verdana12, "PARADISE",  vec2_t(x - 41, y + 45), color_t(0, 0, 0, 255))
            render_text(font.Verdana12, "PARADISE",  vec2_t(x - 42, y + 45), left_color)

            render_text(font.Verdana12, "LUA",  vec2_t(x + 19, y + 45), color_t(0, 0, 0, 255))
            render_text(font.Verdana12, "LUA",  vec2_t(x + 18, y + 45), right_color)
        else
            render_text(font.Verdana12, paradise_text,  vec2_t(x - 32, y + 45), color_t(0, 0, 0, 255))
            render_text(font.Verdana12, paradise_text,  vec2_t(x - 33, y + 45), color_t(255, 255, 255, 255))
        end
    end
end

antiaim_vars.side = false

roll_antiaim.handle = function ()
    local localPlayer = entity_list.get_local_player()

    if not localPlayer then
        return
    end

    if ui_handler.antiaims_rollaa:get() == 1 then
        return
    end

    if not ui_handler.antiaims_rollaa_bind:get() then
        return
    end

    primordial_refs.roll_aa[1]:set(2)

    if ui_handler.antiaims_rollaa:get() == 2 then
        primordial_refs.roll_aa[2]:set(antiaim_vars.side and 50 or -50)
    elseif ui_handler.antiaims_rollaa:get() == 3 then
        primordial_refs.roll_aa[2]:set(antiaim_vars.side and -50 or 50)
    end
end

default_AntiAims.handle = function (ctx)
    if not ui_handler.antiaims_masterSwitch:get() or conditional_AntiAims.antiaims_condition:get() then
        return
    end

    local localPlayer = entity_list.get_local_player()

    if not localPlayer then
        return
    end

    if default_AntiAims.yaw_modifier:get() == 1 then
        primordial_refs.yaw_modifier:set(1)
        primordial_refs.modifier_degree:set(0)
    elseif default_AntiAims.yaw_modifier:get() == 2 then
        primordial_refs.yaw_modifier:set(2)
        primordial_refs.modifier_degree:set(default_AntiAims.modifier_degree:get())
    elseif default_AntiAims.yaw_modifier:get() == 3 then
        primordial_refs.yaw_modifier:set(2)
        primordial_refs.modifier_degree:set(default_AntiAims.modifier_degree:get())
    elseif default_AntiAims.yaw_modifier:get() == 4 then
        primordial_refs.yaw_modifier:set(3)
        primordial_refs.modifier_degree:set(default_AntiAims.modifier_degree:get())
    end

    if default_AntiAims.fake_options:get(1) then
        if math_round(antiaim_get_real_angle() - antiaim_get_fake_angle()) == 0 then
            antiaim_vars.side = not side
        end
    end

    if default_AntiAims.fake_options:get(2) then
        if default_AntiAims.fake_options:get(3) then
            antiaim_vars.side = math.floor(math.random() * 10) > 5
        else
            antiaim_vars.side = global_vars.tick_count() % 4 > 1
        end
    else
        antiaim_vars.side = ui_handler.antiaims_inverter_bind:get()
    end

    if primordial_refs.slow_walk[2]:get() and default_AntiAims.slowwalk_custom:get() then

        local limit_tmp = default_AntiAims.slowwalk_limit:get()
        local random = math.abs(math.random(limit_tmp - 5, limit_tmp + 5))

        primordial_refs.fake_limit_left:set(math_desync(random))
        primordial_refs.fake_limit_right:set(math_desync(random))

    else

        if default_AntiAims.fake_limit_combo:get() == 1 then

            primordial_refs.fake_limit_left:set(math_desync(default_AntiAims.fake_limit_left:get()))
            primordial_refs.fake_limit_right:set(math_desync(default_AntiAims.fake_limit_right:get()))

        else

            primordial_refs.fake_limit_left:set(math_desync(global_vars.tick_count() % 4 > 1 and 18 or default_AntiAims.fake_limit_left:get()))
            primordial_refs.fake_limit_right:set(math_desync(global_vars.tick_count() % 4 > 1 and 18 or default_AntiAims.fake_limit_right:get()))

        end

    end

    primordial_refs.side:set(antiaim_vars.side and 2 or 3)
    primordial_refs.yaw_add:set(antiaim_vars.side and default_AntiAims.yaw_add_left:get() or default_AntiAims.yaw_add_right:get())

    if conditional_AntiAims.is_manual_enabled() then
        ctx:set_desync(0.97)
    end
end

conditional_AntiAims.states = "Shared"

conditional_AntiAims.handle = function (ctx)
    if not conditional_AntiAims.antiaims_condition:get() or not ui_handler.antiaims_masterSwitch:get() then
        return
    end

    local localPlayer = entity_list.get_local_player()

    if not localPlayer then
        return
    end

    if not localPlayer:is_alive() or not localPlayer:get_active_weapon() then
        return
    end

    local flags = localPlayer:get_prop("m_fFlags")
    local is_in_air = bit_band(flags, FL_ONGROUND) == 0
    local p_duck = localPlayer:get_prop("m_flDuckAmount")
    local m_vecVelocity = localPlayer:get_prop("m_vecVelocity")
    local p_still = math.sqrt(m_vecVelocity[0] ^ 2 + m_vecVelocity[1] ^ 2)
    local p_slow = primordial_refs.slow_walk[2]:get()

    if input.is_key_held(e_keys.KEY_E) and conditional_AntiAims["On Use"].is_override:get() then
        conditional_AntiAims.states = "On Use"
    elseif is_in_air and conditional_AntiAims["Air"].is_override:get() then
        conditional_AntiAims.states =  "Air"
    elseif p_slow and conditional_AntiAims["Slowwalk"].is_override:get()then
        conditional_AntiAims.states =  "Slowwalk"
    elseif p_duck > 0.8 and conditional_AntiAims["Crouching"].is_override:get()then
        conditional_AntiAims.states =  "Crouching"
    elseif p_still > 5 and conditional_AntiAims["Moving"].is_override:get()then
        conditional_AntiAims.states =  "Moving"
    elseif p_still < 5 and conditional_AntiAims["Standing"].is_override:get()then
        conditional_AntiAims.states =  "Standing"
    else
        conditional_AntiAims.states =  "Shared"
    end

    if conditional_AntiAims[conditional_AntiAims.states].yaw_modifier:get() == 1 then
        primordial_refs.yaw_modifier:set(1)
        primordial_refs.modifier_degree:set(0)
    elseif conditional_AntiAims[conditional_AntiAims.states].yaw_modifier:get() == 2 then
        primordial_refs.yaw_modifier:set(2)
        primordial_refs.modifier_degree:set(conditional_AntiAims[conditional_AntiAims.states].modifier_degree:get())
    elseif conditional_AntiAims[conditional_AntiAims.states].yaw_modifier:get() == 3 then
        primordial_refs.yaw_modifier:set(2)
        primordial_refs.modifier_degree:set(conditional_AntiAims[conditional_AntiAims.states].modifier_degree:get())
    elseif conditional_AntiAims[conditional_AntiAims.states].yaw_modifier:get() == 4 then
        primordial_refs.yaw_modifier:set(3)
        primordial_refs.modifier_degree:set(conditional_AntiAims[conditional_AntiAims.states].modifier_degree:get())
    end

    if conditional_AntiAims[conditional_AntiAims.states].fake_options:get(1) then
        if math_round(antiaim_get_real_angle() - antiaim_get_fake_angle()) == 0 then
            antiaim_vars.side = not side
        end
    end

    if conditional_AntiAims[conditional_AntiAims.states].fake_options:get(2) then
        if conditional_AntiAims[conditional_AntiAims.states].fake_options:get(3) then
            antiaim_vars.side = math.floor(math.random() * 10) > 5
        else
            antiaim_vars.side = global_vars.tick_count() % 4 > 1
        end
    else
        antiaim_vars.side = ui_handler.antiaims_inverter_bind:get()
    end

    if conditional_AntiAims[conditional_AntiAims.states].fake_limit_combo:get() == 1 then

        primordial_refs.fake_limit_left:set(math_desync(conditional_AntiAims[conditional_AntiAims.states].fake_limit_left:get()))
        primordial_refs.fake_limit_right:set(math_desync(conditional_AntiAims[conditional_AntiAims.states].fake_limit_right:get()))

    else

        primordial_refs.fake_limit_left:set(math_desync(global_vars.tick_count() % 4 > 1 and 18 or conditional_AntiAims[conditional_AntiAims.states].fake_limit_left:get()))
        primordial_refs.fake_limit_right:set(math_desync(global_vars.tick_count() % 4 > 1 and 18 or conditional_AntiAims[conditional_AntiAims.states].fake_limit_right:get()))

    end

    primordial_refs.side:set(antiaim_vars.side and 2 or 3)
    primordial_refs.yaw_add:set(antiaim_vars.side and conditional_AntiAims[conditional_AntiAims.states].yaw_add_left:get() or conditional_AntiAims[conditional_AntiAims.states].yaw_add_right:get())

    if conditional_AntiAims.is_manual_enabled() then
        ctx:set_desync(0.97)
    end
end

local UserCMD_Choke = function (ctx)
    ctx:set_fakelag(true)
end

local UserCMD_Send = function (ctx)
    ctx:set_fakelag(false)
end

fakeLag.Update = function (ctx)
    if not ui_handler.fakelag_masterSwitch:get() or not primordial_refs.enableAA[2]:get() then
        return
    end

    local localPlayer = entity_list.get_local_player()

    if not localPlayer then
        return
    end

    if not localPlayer:is_alive() or not localPlayer:get_active_weapon() then
        return
    end

    local localWeapon = localPlayer:get_active_weapon()

    if localWeapon == nil then
        return
    end

    local localClassname = localWeapon:get_class_name()

    primordial_refs.fakelagLimit:set(defines.onShotFire and 0 or 14)
    primordial_refs.BreakLC:set(defines.onShotFire and false or true)    -- 修复LC以防止开枪缓慢

    local switchER = ui_handler.fakelag_mode:get()

    local enemies = entity_list.get_players(true)
    local m_vecVelocity = localPlayer:get_prop("m_vecVelocity")
    local p_still = math.sqrt(m_vecVelocity[0] ^ 2 + m_vecVelocity[1] ^ 2)

    if defines.onShotFire then
        UserCMD_Send(ctx)
        defines.onShotFire = false
        return
    end

    if ui_handler.fakelag_dormantSend:get() then
        for i, v in ipairs(enemies) do
            if enemies[i]:is_dormant() then

                if Globals_ChokedCommands() < 1 then
                    UserCMD_Choke(ctx)
                else
                    UserCMD_Send(ctx)
                end

                return
            end
        end
    end

    if ui_handler.fakelag_standSend:get() then
        if p_still < 60 then

            if Globals_ChokedCommands() < 1 then
                UserCMD_Choke(ctx)
            else
                UserCMD_Send(ctx)
            end

            return
        end
    end

    if ui_handler.fakelag_nadeSend:get() then
        for i in ipairs (defines.Nades) do
            local isNades = defines.Nades[i]

            if localClassname == isNades then

                if Globals_ChokedCommands() < 1 then
                    UserCMD_Choke(ctx)
                else
                    UserCMD_Send(ctx)
                end

                return
            end
        end
    end

    -- Switch FakeLag Modes
    -- switch (switchER) {
    -- }

    if switchER == 1 then

        if (math.random() < 0.7) then
            if Globals_ChokedCommands() > 14 then
                UserCMD_Send(ctx)
            else
                UserCMD_Choke(ctx)
            end
        else
            if Globals_ChokedCommands() > 7 then
                UserCMD_Send(ctx)
            else
                UserCMD_Choke(ctx)
            end
        end

    elseif switchER == 2 then

        if (math.random() < 0.6) then
            if Globals_ChokedCommands() > 6 then
                UserCMD_Send(ctx)
            else
                UserCMD_Choke(ctx)
            end
        else
            if Globals_ChokedCommands() > 2 then
                UserCMD_Send(ctx)
            else
                UserCMD_Choke(ctx)
            end
        end

    elseif switchER == 3 then

    elseif switchER == 4 then

        UserCMD_Choke(ctx)

    elseif switchER == 5 then

        if p_still < 40 then
            if Globals_ChokedCommands() < 1 then
                UserCMD_Choke(ctx)
            else
                UserCMD_Send(ctx)
            end
        elseif p_still < 100 then
            if (math.random() < 0.6) then
                UserCMD_Choke(ctx)
            else
                UserCMD_Send(ctx)
            end
        elseif p_still < 200 then
            if (math.random() < 0.8) then
                UserCMD_Choke(ctx)
            else
                UserCMD_Send(ctx)
            end
        else
            UserCMD_Choke(ctx)
        end
    end

end

kill_say.handle = function (event)
    if not ui_handler.misc_trashTalk:get() then
        return
    end

    if event.attacker == event.userid then
        return
    end

    local attacker = entity_list.get_player_from_userid(event.attacker)
    local localPlayer = entity_list.get_local_player()

    if attacker ~= localPlayer then
        return
    end

    local current_phrase = kill_say.phrases[client.random_int(1, #kill_say.phrases)]:gsub('\"', '')
    
    engine.execute_cmd(('say "%s"'):format(current_phrase))
end

shutdown.handle = function ()
    exploits.allow_recharge()
end

local function watermarkDraw()
	return "Paradise [Owner] (0.1.0)"
end

callbacks.add(e_callbacks.DRAW_WATERMARK, watermarkDraw)
callbacks.add(e_callbacks.PAINT, ui_handler.global_onDraw)
callbacks.add(e_callbacks.PAINT, ui_handler.visuals_onDraw)
callbacks.add(e_callbacks.PAINT, ui_handler.antiaims_onDraw)
callbacks.add(e_callbacks.PAINT, ui_handler.fakelag_onDraw)
callbacks.add(e_callbacks.PAINT, ui_handler.misc_onDraw)
callbacks.add(e_callbacks.PAINT, fakelag_indicator.Draw)
callbacks.add(e_callbacks.PAINT, crosshair_indicator.Draw)
callbacks.add(e_callbacks.SETUP_COMMAND, handlers.Knife)
callbacks.add(e_callbacks.SETUP_COMMAND, doubletap_controller.handle)
callbacks.add(e_callbacks.SETUP_COMMAND, doubletap_controller.charge)
callbacks.add(e_callbacks.AIMBOT_SHOOT, defines.OnFireUpdate_start)
callbacks.add(e_callbacks.EVENT, handlers.DTknife, "weapon_fire")
callbacks.add(e_callbacks.HITSCAN, conditional_hitchance.air)
callbacks.add(e_callbacks.ANTIAIM, animation_breaker.handle)
callbacks.add(e_callbacks.ANTIAIM, roll_antiaim.handle)
callbacks.add(e_callbacks.ANTIAIM, default_AntiAims.handle)
callbacks.add(e_callbacks.ANTIAIM, conditional_AntiAims.handle)
callbacks.add(e_callbacks.ANTIAIM, fakeLag.Update)
callbacks.add(e_callbacks.EVENT, kill_say.handle, "player_death")
callbacks.add(e_callbacks.SHUTDOWN, shutdown.handle)