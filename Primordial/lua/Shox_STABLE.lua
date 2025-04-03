local version = "debug"
local header = ""
local font = render.create_font("verdana", 13, 50, e_font_flags.DROPSHADOW)
local font2 = render.create_font("verdana", 14, 50, e_font_flags.DROPSHADOW)
local font1 = render.create_font("verdana", 13, 50, e_font_flags.DROPSHADOW)
local username = user.name
function renderWatermark()
local h, m, s = client.get_local_time()
local watermarkValue = string.format("Shox| %s | %02d:%02d:%02d", "One Love", h, m, s)
render.rect_filled(vec2_t(render.get_screen_size()[0] - render.get_text_size(font, watermarkValue)[0] - 15, 5), vec2_t(render.get_text_size(font, watermarkValue)[0] + 10, render.get_text_size(font, watermarkValue)[1] + 10), color_t(0, 0, 0, 191))
render.text(font1, watermarkValue, vec2_t(render.get_screen_size()[0] - render.get_text_size(font, watermarkValue)[0] - 10, 10), color_t(255, 255, 255, 255))
end
local aboutScript = menu.add_text("Shox ", "Welcome back, Cracked EZ")
local enable_aa_tank = menu.add_checkbox("Anti-Aim Settings", "Enable", false)
local disabler = menu.add_multi_selection("Anti-Aim Settings","On Disable",{"on peek","on manual sideways", "on Freestanding"})
local aa_condishion = menu.add_selection("Anti-Aim Settings", "Condition", {"Stand", "Move", "Air", "Slow Walk", "Crouch"})
--stand
local stand_jitter_offset = menu.add_slider("Anti-Aim Settings", "Jitter Offset (Stand)", -180, 180)
local stand_l_yaw_add = menu.add_slider("Anti-Aim Settings", "Yaw Left (Stand)", -50, 50)
local stand_r_yaw_add = menu.add_slider("Anti-Aim Settings", "Yaw Right (Stand)", -50, 50)
local stand_enable_aa_mode_jitter_desync = menu.add_checkbox("Anti-Aim Settings", "Enable Desync jitter (Stand)", false)
local stand_lfake_limit = menu.add_slider("Anti-Aim Settings", "Desync Limit (Stand)", 1, 60)
local stand_jitter_desync_limit1 = menu.add_slider("Anti-Aim Settings", "Desync Jitter Min (Stand)", 1, 60)
local stand_jitter_desync_limit2 = menu.add_slider("Anti-Aim Settings", "Desync Jitter Max (Stand)", 1, 60)
--move
local move_jitter_offset = menu.add_slider("Anti-Aim Settings", "Jitter Offset (Move)", -180, 180)
local move_l_yaw_add = menu.add_slider("Anti-Aim Settings", "Yaw Left (Move)", -50, 50)
local move_r_yaw_add = menu.add_slider("Anti-Aim Settings", "Yaw Right (Move)", -50, 50)
local move_enable_aa_mode_jitter_desync = menu.add_checkbox("Anti-Aim Settings", "Enable Desync jitter (Move)", false)
local move_lfake_limit = menu.add_slider("Anti-Aim Settings", "Desync Limit (Move)", 1, 60)
local move_jitter_desync_limit1 = menu.add_slider("Anti-Aim Settings", "Desync Jitter Min (Move)", 1, 60)
local move_jitter_desync_limit2 = menu.add_slider("Anti-Aim Settings", "Desync Jitter Max (Move)", 1, 60)
--air
local air_jitter_offset = menu.add_slider("Anti-Aim Settings", "Jitter Offset (Air)", -180, 180)
local air_l_yaw_add = menu.add_slider("Anti-Aim Settings", "Yaw Left (Air)", -50, 50)
local air_r_yaw_add = menu.add_slider("Anti-Aim Settings", "Yaw Right (Air)", -50, 50)
local air_enable_aa_mode_jitter_desync = menu.add_checkbox("Anti-Aim Settings", "Enable Desync jitter (Air)", false)
local air_lfake_limit = menu.add_slider("Anti-Aim Settings", "Desync Limit (air)", 1, 60)
local air_jitter_desync_limit1 = menu.add_slider("Anti-Aim Settings", "Desync Jitter Min (Air)", 1, 60)
local air_jitter_desync_limit2 = menu.add_slider("Anti-Aim Settings", "Desync Jitter Max (Air)", 1, 60)
--slow walk
local sw_jitter_offset = menu.add_slider("Anti-Aim Settings", "Jitter Offset (SW)", -180, 180)
local sw_l_yaw_add = menu.add_slider("Anti-Aim Settings", "Yaw Left (SW)", -50, 50)
local sw_r_yaw_add = menu.add_slider("Anti-Aim Settings", "Yaw Right (SW)", -50, 50)
local sw_enable_aa_mode_jitter_desync = menu.add_checkbox("Anti-Aim Settings", "Enable Desync jitter (SW)", false)
local sw_lfake_limit = menu.add_slider("Anti-Aim Settings", "Desync Limit (SW)", 1, 60)
local sw_jitter_desync_limit1 = menu.add_slider("Anti-Aim Settings", "Desync Jitter Min (SW)", 1, 60)
local sw_jitter_desync_limit2 = menu.add_slider("Anti-Aim Settings", "Desync Jitter Max (SW)", 1, 60)
--courch
local courch_jitter_offset = menu.add_slider("Anti-Aim Settings", "Jitter Offset (Crouch)", -180, 180)
local courch_l_yaw_add = menu.add_slider("Anti-Aim Settings", "Yaw Left (Crouch)", -50, 50)
local courch_r_yaw_add = menu.add_slider("Anti-Aim Settings", "Yaw Right (Crouch)", -50, 50)
local courch_enable_aa_mode_jitter_desync = menu.add_checkbox("Anti-Aim Settings", "Enable Desync jitter (Crouch)", false)
local courch_lfake_limit = menu.add_slider("Anti-Aim Settings", "Desync Limit (Crouch)", 1, 60)
local courch_jitter_desync_limit1 = menu.add_slider("Anti-Aim Settings", "Desync Jitter Min (Crouch)", 1, 60)
local courch_jitter_desync_limit2 = menu.add_slider("Anti-Aim Settings", "Desync Jitter Max (Crouch)", 1, 60)
local function aacondition()
    local logsValue = aa_condishion:get()
    
    if logsValue == 1 then
        stand_jitter_offset:set_visible(true)
        stand_l_yaw_add:set_visible(true)
        stand_r_yaw_add:set_visible(true)
        stand_enable_aa_mode_jitter_desync:set_visible(true)
    if stand_enable_aa_mode_jitter_desync:get() then
        stand_jitter_desync_limit1:set_visible(true)
        stand_jitter_desync_limit2:set_visible(true)
        stand_lfake_limit:set_visible(false)
    else
        stand_lfake_limit:set_visible(true)
        stand_jitter_desync_limit1:set_visible(false)
        stand_jitter_desync_limit2:set_visible(false)
    end
        move_jitter_offset:set_visible(false)
        move_l_yaw_add:set_visible(false)
        move_r_yaw_add:set_visible(false)
        move_enable_aa_mode_jitter_desync:set_visible(false)
        move_lfake_limit:set_visible(false)
        move_jitter_desync_limit1:set_visible(false)
        move_jitter_desync_limit2:set_visible(false)
        air_jitter_offset:set_visible(false)
        air_l_yaw_add:set_visible(false)
        air_r_yaw_add:set_visible(false)
        air_enable_aa_mode_jitter_desync:set_visible(false)
        air_lfake_limit:set_visible(false)
        air_jitter_desync_limit1:set_visible(false)
        air_jitter_desync_limit2:set_visible(false)
        sw_jitter_offset:set_visible(false)
        sw_l_yaw_add:set_visible(false)
        sw_r_yaw_add:set_visible(false)
        sw_enable_aa_mode_jitter_desync:set_visible(false)
        sw_lfake_limit:set_visible(false)
        sw_jitter_desync_limit1:set_visible(false)
        sw_jitter_desync_limit2:set_visible(false)
        courch_jitter_offset:set_visible(false)
        courch_l_yaw_add:set_visible(false)
        courch_r_yaw_add:set_visible(false)
        courch_enable_aa_mode_jitter_desync:set_visible(false)
        courch_lfake_limit:set_visible(false)
        courch_jitter_desync_limit1:set_visible(false)
        courch_jitter_desync_limit2:set_visible(false)
    end
    if logsValue == 2 then
        move_jitter_offset:set_visible(true)
        move_l_yaw_add:set_visible(true)
        move_r_yaw_add:set_visible(true)
        move_enable_aa_mode_jitter_desync:set_visible(true)
    if move_enable_aa_mode_jitter_desync:get() then
        move_jitter_desync_limit1:set_visible(true)
        move_jitter_desync_limit2:set_visible(true)
        move_lfake_limit:set_visible(false)
    else
        move_lfake_limit:set_visible(true)
        move_jitter_desync_limit1:set_visible(false)
        move_jitter_desync_limit2:set_visible(false)
    end
        air_jitter_offset:set_visible(false)
        air_l_yaw_add:set_visible(false)
        air_r_yaw_add:set_visible(false)
        air_enable_aa_mode_jitter_desync:set_visible(false)
        air_lfake_limit:set_visible(false)
        air_jitter_desync_limit1:set_visible(false)
        air_jitter_desync_limit2:set_visible(false)
        stand_jitter_offset:set_visible(false)
        stand_l_yaw_add:set_visible(false)
        stand_r_yaw_add:set_visible(false)
        stand_enable_aa_mode_jitter_desync:set_visible(false)
        stand_lfake_limit:set_visible(false)
        stand_jitter_desync_limit1:set_visible(false)
        stand_jitter_desync_limit2:set_visible(false)
        sw_jitter_offset:set_visible(false)
        sw_l_yaw_add:set_visible(false)
        sw_r_yaw_add:set_visible(false)
        sw_enable_aa_mode_jitter_desync:set_visible(false)
        sw_lfake_limit:set_visible(false)
        sw_jitter_desync_limit1:set_visible(false)
        sw_jitter_desync_limit2:set_visible(false)
        courch_jitter_offset:set_visible(false)
        courch_l_yaw_add:set_visible(false)
        courch_r_yaw_add:set_visible(false)
        courch_enable_aa_mode_jitter_desync:set_visible(false)
        courch_lfake_limit:set_visible(false)
        courch_jitter_desync_limit1:set_visible(false)
        courch_jitter_desync_limit2:set_visible(false)
    end
    if logsValue == 3 then
        air_jitter_offset:set_visible(true)
        air_l_yaw_add:set_visible(true)
        air_r_yaw_add:set_visible(true)
        air_enable_aa_mode_jitter_desync:set_visible(true)
    if air_enable_aa_mode_jitter_desync:get() then
        air_jitter_desync_limit1:set_visible(true)
        air_jitter_desync_limit2:set_visible(true)
        air_lfake_limit:set_visible(false)
    else
        air_lfake_limit:set_visible(true)
        air_jitter_desync_limit1:set_visible(false)
        air_jitter_desync_limit2:set_visible(false)
    end
        move_jitter_offset:set_visible(false)
        move_l_yaw_add:set_visible(false)
        move_r_yaw_add:set_visible(false)
        move_enable_aa_mode_jitter_desync:set_visible(false)
        move_lfake_limit:set_visible(false)
        move_jitter_desync_limit1:set_visible(false)
        move_jitter_desync_limit2:set_visible(false)
        stand_jitter_offset:set_visible(false)
        stand_l_yaw_add:set_visible(false)
        stand_r_yaw_add:set_visible(false)
        stand_enable_aa_mode_jitter_desync:set_visible(false)
        stand_lfake_limit:set_visible(false)
        stand_jitter_desync_limit1:set_visible(false)
        stand_jitter_desync_limit2:set_visible(false)
        sw_jitter_offset:set_visible(false)
        sw_l_yaw_add:set_visible(false)
        sw_r_yaw_add:set_visible(false)
        sw_enable_aa_mode_jitter_desync:set_visible(false)
        sw_lfake_limit:set_visible(false)
        sw_jitter_desync_limit1:set_visible(false)
        sw_jitter_desync_limit2:set_visible(false)
        courch_jitter_offset:set_visible(false)
        courch_l_yaw_add:set_visible(false)
        courch_r_yaw_add:set_visible(false)
        courch_enable_aa_mode_jitter_desync:set_visible(false)
        courch_lfake_limit:set_visible(false)
        courch_jitter_desync_limit1:set_visible(false)
        courch_jitter_desync_limit2:set_visible(false)
    end
    if logsValue == 4 then
        sw_jitter_offset:set_visible(true)
        sw_l_yaw_add:set_visible(true)
        sw_r_yaw_add:set_visible(true)
        sw_enable_aa_mode_jitter_desync:set_visible(true)
    if sw_enable_aa_mode_jitter_desync:get() then
        sw_jitter_desync_limit1:set_visible(true)
        sw_jitter_desync_limit2:set_visible(true)
        sw_lfake_limit:set_visible(false)
    else
        sw_lfake_limit:set_visible(true)
        sw_jitter_desync_limit1:set_visible(false)
        sw_jitter_desync_limit2:set_visible(false)
    end
        move_jitter_offset:set_visible(false)
        move_l_yaw_add:set_visible(false)
        move_r_yaw_add:set_visible(false)
        move_enable_aa_mode_jitter_desync:set_visible(false)
        move_lfake_limit:set_visible(false)
        move_jitter_desync_limit1:set_visible(false)
        move_jitter_desync_limit2:set_visible(false)
        stand_jitter_offset:set_visible(false)
        stand_l_yaw_add:set_visible(false)
        stand_r_yaw_add:set_visible(false)
        stand_enable_aa_mode_jitter_desync:set_visible(false)
        stand_lfake_limit:set_visible(false)
        stand_jitter_desync_limit1:set_visible(false)
        stand_jitter_desync_limit2:set_visible(false)
        air_jitter_offset:set_visible(false)
        air_l_yaw_add:set_visible(false)
        air_r_yaw_add:set_visible(false)
        air_enable_aa_mode_jitter_desync:set_visible(false)
        air_lfake_limit:set_visible(false)
        air_jitter_desync_limit1:set_visible(false)
        air_jitter_desync_limit2:set_visible(false)
        courch_jitter_offset:set_visible(false)
        courch_l_yaw_add:set_visible(false)
        courch_r_yaw_add:set_visible(false)
        courch_enable_aa_mode_jitter_desync:set_visible(false)
        courch_lfake_limit:set_visible(false)
        courch_jitter_desync_limit1:set_visible(false)
        courch_jitter_desync_limit2:set_visible(false)
    end
    if logsValue == 5 then
        courch_jitter_offset:set_visible(true)
        courch_l_yaw_add:set_visible(true)
        courch_r_yaw_add:set_visible(true)
        courch_enable_aa_mode_jitter_desync:set_visible(true)
    if courch_enable_aa_mode_jitter_desync:get() then
        courch_jitter_desync_limit1:set_visible(true)
        courch_jitter_desync_limit2:set_visible(true)
        courch_lfake_limit:set_visible(false)
    else
        courch_lfake_limit:set_visible(true)
        courch_jitter_desync_limit1:set_visible(false)
        courch_jitter_desync_limit2:set_visible(false)
    end
        sw_jitter_offset:set_visible(false)
        sw_l_yaw_add:set_visible(false)
        sw_r_yaw_add:set_visible(false)
        sw_enable_aa_mode_jitter_desync:set_visible(false)
        sw_lfake_limit:set_visible(false)
        sw_jitter_desync_limit1:set_visible(false)
        sw_jitter_desync_limit2:set_visible(false)
        move_jitter_offset:set_visible(false)
        move_l_yaw_add:set_visible(false)
        move_r_yaw_add:set_visible(false)
        move_enable_aa_mode_jitter_desync:set_visible(false)
        move_lfake_limit:set_visible(false)
        move_jitter_desync_limit1:set_visible(false)
        move_jitter_desync_limit2:set_visible(false)
        stand_jitter_offset:set_visible(false)
        stand_l_yaw_add:set_visible(false)
        stand_r_yaw_add:set_visible(false)
        stand_enable_aa_mode_jitter_desync:set_visible(false)
        stand_lfake_limit:set_visible(false)
        stand_jitter_desync_limit1:set_visible(false)
        stand_jitter_desync_limit2:set_visible(false)
        air_jitter_offset:set_visible(false)
        air_l_yaw_add:set_visible(false)
        air_r_yaw_add:set_visible(false)
        air_enable_aa_mode_jitter_desync:set_visible(false)
        air_lfake_limit:set_visible(false)
        air_jitter_desync_limit1:set_visible(false)
        air_jitter_desync_limit2:set_visible(false)
    end
end
callbacks.add(e_callbacks.PAINT, aacondition)
local yaw_base = menu.add_selection("Anti-Aim Settings", "yaw base", {"viewangle", "at target(crosshair)", "at target(distance)"})
local animationbreakersaa = menu.add_multi_selection("Anti-Aim Settings", "Animation Breakers", {"Static Legs In Air", "Zero Pitch On Land", "Reverse Slide", "Body Lean"})
local enableTeleportInAir = menu.add_checkbox("Ragebot", "Teleport in air")
local logsCheckbox = menu.add_checkbox("Ragebot", "Chat Logs")
local logsSelection = menu.add_multi_selection("Ragebot", "Chat Logs Selection", {"Miss", "Hit" --[[, "Hurt", "Purchase"]]})
local molotovparticals_enable = menu.add_checkbox("World", "Molotov Particles", false)
local world_miss_indicator_enable = menu.add_checkbox("World", "World Miss Indicator", false)
local world_miss_indicator_enableColor = world_miss_indicator_enable:add_color_picker("World Miss Indicator color")
local enableCrosshairIndicators = menu.add_checkbox("World", "Crosshair indicators")
local crosshairIndicatorsColor = enableCrosshairIndicators:add_color_picker("Crosshair indicators color")
local headerColor = menu.find("misc","main","config","accent color")
local fontCrosshairIndic = render.create_font("smallest_pixel-7.ttf", 10, 500, e_font_flags.DROPSHADOW)
local warning = menu.add_text("World", "unscrew the transparency of the autopeek by 0")
local enable = menu.add_checkbox("World", "Autopeek", false)
local colour = enable:add_color_picker("color")
local render_granade = menu.add_checkbox("World", "Transparency on nade", false)
local render_granade_color = render_granade:add_color_picker("Transparency color")
local dt_tog = menu.add_checkbox("Ragebot", "Doubletap Fast", false)
local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local function dt_fast()
    if dt_tog:get() and dt_ref[2]:get() then
        cvars.sv_maxusrcmdprocessticks:set_int(19)
        cvars.cl_clock_correction:set_int(0)
        cvars.cl_clock_correction_adjustment_max_amount:set_int(500)
        cvars.sv_maxusrcmdprocessticks_holdaim:set_int(1)
    else
        cvars.sv_maxusrcmdprocessticks:set_int(16)
        cvars.cl_clock_correction:set_int(1)
        cvars.sv_maxusrcmdprocessticks_holdaim:set_int(0)
    end
end
callbacks.add(e_callbacks.SETUP_COMMAND, dt_fast)
render_granade_color:set(color_t(255, 255, 255, 55))
local function on_draw_model_granade(ctx)
if render_granade:get() then
    if not ctx.entity:is_valid() then return end
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    
    if ctx.entity:get_index() ~= local_player:get_index() then return end
    
    local weapon = local_player:get_active_weapon()
    if weapon == nil then return end
    
    local class_name = weapon:get_class_name()
    if class_name ~= "CHEGrenade" and
    class_name ~= "CIncendiaryGrenade" and
    class_name ~= "CSmokeGrenade" and
    class_name ~= "CFlashbang" and
    class_name ~= "CDecoyGrenade" and
    class_name ~= "CMolotovGrenade" then return end
    
    ctx.override_original = true
    ctx:draw_original(render_granade_color:get())
end
end
callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model_granade)
local function callback_fn()
yaw_base:set(2)
enable_aa_tank:set(true)
stand_jitter_offset:set(36)
stand_l_yaw_add:set(-3)
stand_r_yaw_add:set(3)
stand_lfake_limit:set(60)
stand_jitter_desync_limit2:set(51)
stand_jitter_desync_limit1:set(41)
stand_enable_aa_mode_jitter_desync:set(false)
move_jitter_offset:set(51)
move_l_yaw_add:set(-5)
move_r_yaw_add:set(5)
move_lfake_limit:set(60)
move_jitter_desync_limit2:set(34)
move_jitter_desync_limit1:set(34)
move_enable_aa_mode_jitter_desync:set(true)
air_jitter_offset:set(28)
air_l_yaw_add:set(-10)
air_r_yaw_add:set(10)
air_lfake_limit:set(60)
air_jitter_desync_limit2:set(60)
air_jitter_desync_limit1:set(60)
air_enable_aa_mode_jitter_desync:set(true)
sw_jitter_offset:set(50)
sw_l_yaw_add:set(-13)
sw_r_yaw_add:set(9)
sw_lfake_limit:set(60)
sw_jitter_desync_limit2:set(60)
sw_jitter_desync_limit1:set(60)
sw_enable_aa_mode_jitter_desync:set(true)
courch_jitter_offset:set(43)
courch_l_yaw_add:set(-12)
courch_r_yaw_add:set(17)
courch_lfake_limit:set(60)
courch_jitter_desync_limit2:set(60)
courch_jitter_desync_limit1:set(60)
courch_enable_aa_mode_jitter_desync:set(true)
end
local button = menu.add_button("Anti-Aim Settings", "Preset Anti-Aim", callback_fn)
local function callback_fn2()
yaw_base:set(2)
enable_aa_tank:set(true)
stand_jitter_offset:set(28)
stand_l_yaw_add:set(-3)
stand_r_yaw_add:set(3)
stand_lfake_limit:set(60)
stand_jitter_desync_limit2:set(51)
stand_jitter_desync_limit1:set(41)
stand_enable_aa_mode_jitter_desync:set(true)
move_jitter_offset:set(51)
move_l_yaw_add:set(-5)
move_r_yaw_add:set(5)
move_lfake_limit:set(60)
move_jitter_desync_limit2:set(34)
move_jitter_desync_limit1:set(34)
move_enable_aa_mode_jitter_desync:set(true)
air_jitter_offset:set(28)
air_l_yaw_add:set(-10)
air_r_yaw_add:set(10)
air_lfake_limit:set(60)
air_jitter_desync_limit2:set(60)
air_jitter_desync_limit1:set(60)
air_enable_aa_mode_jitter_desync:set(true)
sw_jitter_offset:set(28)
sw_l_yaw_add:set(-10)
sw_r_yaw_add:set(10)
sw_lfake_limit:set(60)
sw_jitter_desync_limit2:set(60)
sw_jitter_desync_limit1:set(60)
sw_enable_aa_mode_jitter_desync:set(true)
courch_jitter_offset:set(28)
courch_l_yaw_add:set(-10)
courch_r_yaw_add:set(10)
courch_lfake_limit:set(60)
courch_jitter_desync_limit2:set(60)
courch_jitter_desync_limit1:set(60)
courch_enable_aa_mode_jitter_desync:set(true)
end
local button2 = menu.add_button("Anti-Aim Settings", "Alt Preset Anti-Aim", callback_fn2)
local warning = menu.add_text("Anti-Aim Settings", "Recommend Don't use (doesn't work on all servers)")
local aa_mega_lean_enable = menu.add_checkbox("Anti-Aim Settings", "Enable Mega Lean", false)
local aa_mega_lean_mode = menu.add_selection("Anti-Aim Settings", "Settings", {"Static", "Jitter"})
local mega_lean_slider = menu.add_slider("Anti-Aim Settings", "Mega Lean",-35,35)
local mega_lean_jitter1 = menu.add_slider("Anti-Aim Settings", "Mega Lean Jitter 1",-35,35)
local mega_lean_jitter2 = menu.add_slider("Anti-Aim Settings", "Mega Lean Jitter 2",-35,35)
local function callback_fn()
mega_lean_jitter2:set(33)
mega_lean_jitter1:set(-35)
mega_lean_slider:set(33)
aa_mega_lean_mode:set(2)
aa_mega_lean_enable:set(true)
end
local button = menu.add_button("Anti-Aim Settings", "Preset Mega Lean", callback_fn)
local flick = menu.add_checkbox("Anti-Aim Settings", "Enable Fake Flick")
local flickspeed = menu.add_slider("Anti-Aim Settings", "Speed Fake Flick", 8, 64)
local function fakeflick(ctx)
   if (global_vars.tick_count() % flickspeed:get()) < 2 and flick:get() then
      ctx:set_yaw(90 * (antiaim.is_inverting_desync() and -1 or 1))
   end
end
callbacks.add(e_callbacks.ANTIAIM, fakeflick)
local function aa_mega_lean(cmd)
   if aa_mega_lean_enable:get() then
   local choice = aa_mega_lean_mode:get()
      if choice == 2 then
      local jitter_true = client.random_int(1, 2)
         if jitter_true == 1 then
            cmd.viewangles.z = mega_lean_jitter1:get()
         end
         if jitter_true == 2 then
            cmd.viewangles.z = mega_lean_jitter2:get()
         end
      end
      if choice == 1 then
         cmd.viewangles.z = mega_lean_slider:get()
      end
   end
end
callbacks.add(e_callbacks.SETUP_COMMAND, aa_mega_lean)
function world_circle(origin, radius, color)
	local previous_screen_pos, screen
    for i = 0, radius*2 do
		local pos = vec3_t(radius * math.cos(i/3) + origin.x, radius * math.sin(i/3) + origin.y, origin.z);
        local screen = render.world_to_screen(pos)
        if not screen then return end
		if screen.x ~= nil and previous_screen_pos then
            render.line(previous_screen_pos, screen, color)
			previous_screen_pos = screen
        elseif screen.x ~= nil then
            previous_screen_pos = screen
		end
	end
end
function draw()
    if ragebot.get_autopeek_pos() and enable:get() then
        world_circle(ragebot.get_autopeek_pos(), 20, colour:get())
    end
end
callbacks.add(e_callbacks.PAINT, draw)
local bindsState = {
["DOUBLETAP"] = menu.find("aimbot","general","exploits","doubletap","enable"),
}
local bindsState2 = {
["DMG"] = menu.find("aimbot", "scout", "target overrides", "force min. damage"),
}
local bindsState3 = {
["AUTO PEEK"] = menu.find("aimbot","general","misc","autopeek"),
}
local bindsState4 = {
["FAKE DUCK"] = menu.find("antiaim","general","fake duck"),
}
local bindsState8 = {
["HIDESHOTS"] = menu.find("aimbot","general","exploits","hideshots","enable"),
}
local bindsState1 = {
["ROLL"] = menu.find("aimbot","general","aimbot","body lean resolver"),
}
moveToggled = false
moveOffset = 0
local interval = 0
local fontCrosshairIndic1 = render.create_font("Arial", 10, 150, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
function renderIndicators()
if enableCrosshairIndicators:get() and entity_list.get_local_player() ~= nil and entity_list.get_local_player():is_alive() and engine.is_in_game() then
    offset = 1
    moveToggled = entity_list.get_local_player():get_prop("m_bIsScoped")
    if moveToggled == 1 and moveOffset <= 50 then
        moveOffset = moveOffset + global_vars.frame_time() * 200
    end
    if moveToggled == 0 and moveOffset > 0 then
        moveOffset = moveOffset - global_vars.frame_time() * 200
    end
    local lp = entity_list.get_local_player()
    local modifier = lp:get_prop("m_flVelocityModifier")
    interval = interval + (1-modifier) * 0.7 + 0.3
    local wa = math.floor(math.abs(interval*0.025 % 2 - 1) * 255)
    render.text(font, "RotN", vec2_t(render.get_screen_size()[0] / 2 + moveOffset, render.get_screen_size()[1] / 1.89), color_t(255,255, 255, wa), true)
    render.text(fontCrosshairIndic1, "BETA", vec2_t(render.get_screen_size()[0] / 2 + moveOffset, render.get_screen_size()[1] / 1.85), color_t(255,255, 255, 255), true)
    for i, v in pairs(bindsState) do
        local active = v[2]
        local active_dt = unpack(menu.find("aimbot","general","exploits","doubletap","enable"))
        local active_roll = unpack(menu.find("aimbot","general","aimbot","body lean resolver"))
        local position = vec2_t(render.get_screen_size()[0] / 2 + moveOffset, render.get_screen_size()[1] / 1.85 + 10 * offset)
        if active:get() then
            if exploits.get_charge() == 0 then
            render.text(fontCrosshairIndic, i, position, color_t(255, 0, 0, 255), true)
            else
            render.text(fontCrosshairIndic, i, position, color_t(3, 255, 0, 255), true)
            end
            offset = offset + 1
        end
    end
    for i, v in pairs(bindsState2) do
        local active = v[2]
        local position = vec2_t(render.get_screen_size()[0] / 2 + moveOffset, render.get_screen_size()[1] / 1.85 + 10 * offset)
        if active:get() then
            render.text(fontCrosshairIndic, i, position, crosshairIndicatorsColor:get(), true)
            offset = offset + 1
        end
    end
    for i, v in pairs(bindsState3) do
        local active = v[2]
        local position = vec2_t(render.get_screen_size()[0] / 2 + moveOffset, render.get_screen_size()[1] / 1.85 + 10 * offset)
        if active:get() then
            render.text(fontCrosshairIndic, i, position, crosshairIndicatorsColor:get(), true)
            offset = offset + 1
        end
    end
    for i, v in pairs(bindsState8) do
        local active = v[2]
        local position = vec2_t(render.get_screen_size()[0] / 2 + moveOffset, render.get_screen_size()[1] / 1.85 + 10 * offset)
        if active:get() then
            render.text(fontCrosshairIndic, i, position, crosshairIndicatorsColor:get(), true)
            offset = offset + 1
        end
    end
    for i, v in pairs(bindsState1) do
        local active = v[2]
        local active_dt = unpack(menu.find("aimbot","general","exploits","doubletap","enable"))
        local active_roll = unpack(menu.find("aimbot","general","aimbot","body lean resolver"))
        local position = vec2_t(render.get_screen_size()[0] / 2 + moveOffset, render.get_screen_size()[1] / 1.85 + 10 * offset)
        if active:get() then
            render.text(fontCrosshairIndic, i, position, crosshairIndicatorsColor:get(), true)
            offset = offset + 1
        end
    end
    for i, v in pairs(bindsState4) do
        local active = v[2]
        local active_dt = unpack(menu.find("aimbot","general","exploits","doubletap","enable"))
        local active_roll = unpack(menu.find("aimbot","general","aimbot","body lean resolver"))
        local position = vec2_t(render.get_screen_size()[0] / 2 + moveOffset, render.get_screen_size()[1] / 1.85 + 10 * offset)
        if active:get() then
            render.text(fontCrosshairIndic, i, position, crosshairIndicatorsColor:get(), true)
            offset = offset + 1
        end
    end
end
end
callbacks.add(e_callbacks.PAINT, renderIndicators)
local ffi = require("ffi")
ffi.cdef[[
    typedef struct {
        unsigned short wYear;
        unsigned short wMonth;
        unsigned short wDayOfWeek;
        unsigned short wDay;
        unsigned short wHour;
        unsigned short wMinute;
        unsigned short wSecond;
        unsigned short wMilliseconds;
    } SYSTEMTIME, *LPSYSTEMTIME;
    
    void GetSystemTime(LPSYSTEMTIME lpSystemTime);
    void GetLocalTime(LPSYSTEMTIME lpSystemTime);
]]
local FindElement = ffi.cast("unsigned long(__thiscall*)(void*, const char*)", memory.find_pattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))
local CHudChat = FindElement(ffi.cast("unsigned long**", ffi.cast("uintptr_t", memory.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 8B 5D 08")) + 1)[0], "CHudChat")
local FFI_ChatPrint = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", CHudChat)[0][27])
local function PrintInChat(text)
    FFI_ChatPrint(CHudChat, 0, 0, string.format("%s ", text))
end
local function logFunction()
    local logsValue = logsCheckbox:get()
    
    if logsValue == true then
        logsSelection:set_visible(true)
    else
        logsSelection:set_visible(false)
        logsSelection:set(1, false)
        logsSelection:set(2, false)
        -- logsSelection:set(3, false)
        -- logsSelection:set(4, false)
    end
end
local function missLogs(shot)
    local missValue = logsSelection:get("Miss")
    if missValue == true then
        PrintInChat('\x01[\x07Shox\x01] \x08Missed \x07' ..shot.player:get_name().. '\x08 due to \x03' ..shot.reason_string.. '\x08 with \x10' ..shot.backtrack_ticks.. '\x08 ms backtrack. Predicted damage \x0B' ..shot.aim_damage.. '\x08 and hitchance \x05' ..shot.aim_hitchance.. '\x08.')
	    print('\x01[\x07Logs\x01] \x08Missed \x07' ..shot.player:get_name().. '\x08 due to \x03' ..shot.reason_string.. '\x08 with \x10' ..shot.backtrack_ticks.. '\x08 ms backtrack. Predicted damage \x0B' ..shot.aim_damage.. 'and hitchance' ..shot.aim_hitchance.. '\x08.')
    end
end
local function hitLogs(shot)
    local hitValue = logsSelection:get("Hit")
    if hitValue == true then
        PrintInChat('\x01[\x10Shox\x01] \x08Hit \x07'..shot.player:get_name()..'\x08 in the \x10'..shot.hitgroup..'\x08 for \x0B'..shot.damage..'\08 damage with \x05'..shot.aim_hitchance..'\x08 hitchance while predicted damage \x03' ..shot.aim_damage.. ' \x08 and \x04'..shot.backtrack_ticks..'\x08 ms backtrack.')
	    print('\x01[\x10Shox\x01] \x08Hit \x07'..shot.player:get_name()..'\x08 in the \x10'..shot.hitgroup..'\x08 for \x0B'..shot.damage..'\08 damage with \x05'..shot.aim_hitchance..'\x08 hitchance while predicted damage \x03' ..shot.aim_damage.. ' \x08 and \x04'..shot.backtrack_ticks..'\x08 ms backtrack.')
    end
end
callbacks.add(e_callbacks.PAINT, logFunction)
callbacks.add(e_callbacks.AIMBOT_MISS, missLogs)
callbacks.add(e_callbacks.AIMBOT_HIT, hitLogs)
local data = {}
local font = render.create_font('Small Fonts', 12, 200, e_font_flags.OUTLINE)
local font_x = render.create_font('Comic Sans MS Bold', 15, 550, e_font_flags.OUTLINE)
local on_miss = function(e)
    for index, value in pairs(data) do
        if data[index].id == e.id then
            data[index].reason = e.reason_string
            data[index].hitbox = client.get_hitbox_name(e.aim_hitbox)
            data[index].world_pos = e.player:get_hitbox_pos(e.aim_hitbox)
        end
    end
end
local on_shoot = function (e)
    table.insert(data, 1, {id=e.id, world_pos=nil, reason='null', hitbox='null', time=client.get_unix_time(), opacity = 255})
end
local on_paint = function()
if world_miss_indicator_enable:get() then
    for index, value in pairs(data) do
        local world_pos = data[index].world_pos
        local reason = data[index].reason
        local hitbox = data[index].hitbox
        local opacity = data[index].opacity
        if world_pos then
            if client.get_unix_time() > data[index].time + 2 then
                data[index].opacity = data[index].opacity - 10
                if opacity < 1 then
                    table.remove(data, index)
                end
            end
            if opacity > 1 then
                local screen_pos = render.world_to_screen(world_pos)
                if reason and screen_pos then
                    render.text(font_x, 'x ', screen_pos + vec2_t(0, -render.get_text_size(font_x, 'x ').y/2), world_miss_indicator_enableColor:get())
                    render.text(font, reason .. ' ' .. hitbox, screen_pos + vec2_t(0 + render.get_text_size(font_x, 'x ').x, -render.get_text_size(font_x, 'x ').y/2 + 1), world_miss_indicator_enableColor:get())
                end
            end
        end
    end
end
end
callbacks.add(e_callbacks.AIMBOT_MISS, on_miss)
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_shoot)
callbacks.add(e_callbacks.PAINT, on_paint)
local find_material = materials.find
local materials = {
    "particle/fire_burning_character/fire_env_fire_depthblend_oriented",
    "particle/fire_burning_character/fire_burning_character",
    "particle/fire_explosion_1/fire_explosion_1_oriented",
    "particle/fire_explosion_1/fire_explosion_1_bright",
    "particle/fire_burning_character/fire_burning_character_depthblend",
    "particle/fire_burning_character/fire_env_fire_depthblend",
}
 
local function on_event(e)
if molotovparticals_enable:get() then
    if e.name == "molotov_detonate" then
        for _, v in pairs(materials) do
            local molotov = find_material(v)
            if molotov ~= nil then
                molotov:set_flag(e_material_flags.NO_DRAW, false)
                molotov:set_flag(e_material_flags.WIREFRAME, true)
            end
        end
    end
end
end
callbacks.add(e_callbacks.EVENT, on_event)
local key_name, key_bind = unpack(menu.find("antiaim","main","manual","invert desync"))
local ref_hide_shot, ref_onshot_key = unpack(menu.find("aimbot", "general", "exploits", "hideshots", "enable"))
local ref_auto_peek, ref_peek_key = unpack(menu.find("aimbot","general","misc","autopeek"))
local ref_freestand, ref_frees_key = unpack(menu.find("antiaim","main","auto direction","enable"))
local side_stand = menu.find("antiaim","main", "desync","side#stand")
local llimit_stand = menu.find("antiaim","main", "desync","left amount#stand")
local rlimit_stand = menu.find("antiaim","main", "desync","right amount#stand")
local side_move = menu.find("antiaim","main", "desync","side#move")
local llimit_move = menu.find("antiaim","main", "desync","left amount#move")
local rlimit_move = menu.find("antiaim","main", "desync","right amount#move")
local side_slowm = menu.find("antiaim","main", "desync","side#slow walk")
local llimit_slowm = menu.find("antiaim","main", "desync","left amount#slow walk")
local rlimit_slowm = menu.find("antiaim","main", "desync","right amount#slow walk")
local backup_cache = {
    side_stand = side_stand:get(),
    side_move = side_move:get(),
    side_slowm = side_slowm:get(),
    llimit_stand = llimit_stand:get(),
    rlimit_stand = rlimit_stand:get(),
    llimit_move = llimit_move:get(),
    rlimit_move = rlimit_move:get(),
    llimit_slowm = llimit_slowm:get(),
    rlimit_slowm = rlimit_slowm:get()
}
local vars = {
    yaw_base = 0,
    _jitter = 0,
    _yaw_add = 0,
    l_limit = 0,
    r_limit = 0,
    val_n = 0,
    desync_val = 0,
    yaw_offset = 0,
    temp_vars = 0,
    revs = 1,
    last_time = 0
}
local handle_yaw = 0
local function on_shutdown()
    side_stand:set(backup_cache.side_stand)
    side_move:set(backup_cache.side_move)
    side_slowm:set(backup_cache.side_slowm)
    llimit_stand:set(backup_cache.llimit_stand)
    rlimit_stand:set(backup_cache.rlimit_stand)
    llimit_move:set(backup_cache.llimit_move)
    rlimit_move:set(backup_cache.rlimit_move)
    llimit_slowm:set(backup_cache.llimit_slowm)
    rlimit_slowm:set(backup_cache.rlimit_slowm)
end
local normalize_yaw = function(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end
local function calc_shit(xdelta, ydelta)
    if xdelta == 0 and ydelta == 0 then
        return 0
    end
    
    return math.deg(math.atan2(ydelta, xdelta))
end
local function calc_angle(src, dst)
    local vecdelta = vec3_t(dst.x - src.x, dst.y - src.y, dst.z - src.z)
    local angles = angle_t(math.atan2(-vecdelta.z, math.sqrt(vecdelta.x^2 + vecdelta.y^2)) * 180.0 / math.pi, (math.atan2(vecdelta.y, vecdelta.x) * 180.0 / math.pi), 0.0)
    return angles
end
local function calc_distance(src, dst)
    return math.sqrt(math.pow(src.x - dst.x, 2) + math.pow(src.y - dst.y, 2) + math.pow(src.z - dst.z, 2) )
end
local function get_distance_closest_enemy()
    local enemies_only = entity_list.get_players(true) 
    if enemies_only == nil then return end
    local local_player = entity_list.get_local_player()
    local local_origin = local_player:get_render_origin()
    local bestenemy = nil
    local dis = 10000
    for _, enemy in pairs(enemies_only) do 
        local enemy_origin = enemy:get_render_origin()
        local cur_distance = calc_distance(enemy_origin, local_origin)
        if cur_distance < dis then
            dis = cur_distance
            bestenemy = enemy
        end
    end
    return bestenemy
end
local function get_crosshair_closet_enemy()
    local enemies_only = entity_list.get_players(true) 
    if enemies_only == nil then return end
    local local_player = entity_list.get_local_player()
    local local_eyepos = local_player:get_eye_position()
    local local_angles = engine.get_view_angles()
    local bestenemy = nil
    local fov = 180
    for _, enemy in pairs(enemies_only) do 
        local enemy_origin = enemy:get_render_origin()
        local cur_fov = math.abs(normalize_yaw(calc_shit(local_eyepos.x - enemy_origin.x, local_eyepos.y - enemy_origin.y) - local_angles.y + 180))
        if cur_fov < fov then
            fov = cur_fov
            bestenemy = enemy
        end
    end
    return bestenemy
end
function on_paint()
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    local local_eyepos = local_player:get_eye_position()
    local view_angle = engine.get_view_angles()
    if yaw_base:get() == 1 then
        vars.yaw_base = view_angle.y
    elseif yaw_base:get() == 2 then
        vars.yaw_base = get_crosshair_closet_enemy() == nil and view_angle.y or calc_angle(local_eyepos, get_crosshair_closet_enemy():get_render_origin()).y
    elseif yaw_base:get() == 3 then  
        vars.yaw_base = get_distance_closest_enemy() == nil and view_angle.y or calc_angle(local_eyepos, get_distance_closest_enemy():get_render_origin()).y
    end
end
local positionState = {
    "STANDING",
    "MOTION DETECTED",
    "SLOW WALK",
    "CROUCHING",
    "IN AIR"
}
function positionInTheWorld(cmd)
    local localPlayer = entity_list:get_local_player()
    if localPlayer ~= nil and localPlayer:is_alive() then
        if localPlayer:get_prop("m_fFlags") == 256 or localPlayer:get_prop("m_fFlags") == 262 then
            positionState = 5
        else
            if localPlayer:get_prop("m_fFlags") == 263 then
                positionState = 4
            else
                if menu.find("misc", "main", "movement", "slow walk")[2]:get() then
                    positionState = 3
                else
                    if math.pow(localPlayer:get_prop("m_vecVelocity")[0], 2) + math.pow( localPlayer:get_prop("m_vecVelocity")[1], 2 ) > 15 then
                        positionState = 2
                    else
                        positionState = 1
                    end
                end
            end
        end
    end
end
function on_antiaim(ctx)
if enable_aa_tank:get() then
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    if disabler:get(1) then 
        if ref_peek_key:get() == true then 
            on_shutdown()
            return
        end
    end
    if disabler:get(2) then
        if antiaim.get_manual_override() == 1 or antiaim.get_manual_override() == 3 then 
            on_shutdown()
            return
        end
    end
    if disabler:get(3) then
        if ref_frees_key:get() then
            on_shutdown()
            return
        end
    end
--stand
if positionState == 1 then
    
    if math.abs(global_vars.tick_count() - vars.temp_vars) > 1 then
       vars.revs = vars.revs == 1 and 0 or 1
       vars.temp_vars = global_vars.tick_count()
    end
    local is_invert = vars.revs == 1 and key_bind:get() and false or true
    vars._jitter = stand_jitter_offset:get()
    vars.l_limit = stand_lfake_limit:get()
    --vars.r_limit = stand_rfake_limit:get()
    
    _l_yaw_add = stand_l_yaw_add:get()
    _r_yaw_add = stand_r_yaw_add:get()
    vars.val_n = vars.revs == 1 and vars._jitter or -(vars._jitter)
    vars.desync_val = vars.val_n > 0 and -(vars.l_limit/120) or vars.l_limit/60
    vars._yaw_add = vars.val_n > 0 and _l_yaw_add or _r_yaw_add
    handle_yaw = normalize_yaw(vars.val_n + vars._yaw_add + vars.yaw_base + 180)
    ctx:set_invert_desync(is_invert)
    ctx:set_desync(vars.desync_val)
    ctx:set_yaw(handle_yaw)
    
    side_stand:set(4)
    side_move:set(4)
    side_slowm:set(4)
    if stand_enable_aa_mode_jitter_desync:get() then
    llimit_stand:set(vars.val_n < 0 and stand_jitter_desync_limit1:get() * 10/6 or stand_jitter_desync_limit2:get() * 10/6)
    rlimit_stand:set(vars.val_n < 0 and stand_jitter_desync_limit1:get() * 10/6 or stand_jitter_desync_limit2:get() * 10/6)
    llimit_move:set(vars.val_n < 0 and stand_jitter_desync_limit1:get() * 10/6 or stand_jitter_desync_limit2:get() * 10/6)
    rlimit_move:set(vars.val_n < 0 and stand_jitter_desync_limit1:get() * 10/6 or stand_jitter_desync_limit2:get() * 10/6)
    llimit_slowm:set(vars.val_n < 0 and stand_jitter_desync_limit1:get() * 10/6 or stand_jitter_desync_limit2:get() * 10/6)
    rlimit_slowm:set(vars.val_n < 0 and stand_jitter_desync_limit1:get() * 10/6 or stand_jitter_desync_limit2:get() * 10/6)
    else
    llimit_stand:set(vars.l_limit/2 * 10/6)
    rlimit_stand:set(vars.l_limit * 10/6)
    llimit_move:set(vars.l_limit/2 * 10/6)
    rlimit_move:set(vars.l_limit * 10/6)
    llimit_slowm:set(vars.l_limit/2 * 10/6)
    rlimit_slowm:set(vars.l_limit * 10/6)
    end
    end
-- move
    if positionState == 2 then
    
    if math.abs(global_vars.tick_count() - vars.temp_vars) > 1 then
       vars.revs = vars.revs == 1 and 0 or 1
       vars.temp_vars = global_vars.tick_count()
    end
    local is_invert = vars.revs == 1 and key_bind:get() and false or true
    vars._jitter = move_jitter_offset:get()
    vars.l_limit = move_lfake_limit:get()
    --vars.r_limit = move_rfake_limit:get()
    
    _l_yaw_add = move_l_yaw_add:get()
    _r_yaw_add = move_r_yaw_add:get()
    vars.val_n = vars.revs == 1 and vars._jitter or -(vars._jitter)
    vars.desync_val = vars.val_n > 0 and -(vars.l_limit/120) or vars.l_limit/60
    vars._yaw_add = vars.val_n > 0 and _l_yaw_add or _r_yaw_add
    handle_yaw = normalize_yaw(vars.val_n + vars._yaw_add + vars.yaw_base + 180)
    ctx:set_invert_desync(is_invert)
    ctx:set_desync(vars.desync_val)
    ctx:set_yaw(handle_yaw)
    
    side_stand:set(4)
    side_move:set(4)
    side_slowm:set(4)
    if move_enable_aa_mode_jitter_desync:get() then
    llimit_stand:set(vars.val_n < 0 and move_jitter_desync_limit1:get() * 10/6 or move_jitter_desync_limit2:get() * 10/6)
    rlimit_stand:set(vars.val_n < 0 and move_jitter_desync_limit1:get() * 10/6 or move_jitter_desync_limit2:get() * 10/6)
    llimit_move:set(vars.val_n < 0 and move_jitter_desync_limit1:get() * 10/6 or move_jitter_desync_limit2:get() * 10/6)
    rlimit_move:set(vars.val_n < 0 and move_jitter_desync_limit1:get() * 10/6 or move_jitter_desync_limit2:get() * 10/6)
    llimit_slowm:set(vars.val_n < 0 and move_jitter_desync_limit1:get() * 10/6 or move_jitter_desync_limit2:get() * 10/6)
    rlimit_slowm:set(vars.val_n < 0 and move_jitter_desync_limit1:get() * 10/6 or move_jitter_desync_limit2:get() * 10/6)
    else
    llimit_stand:set(vars.l_limit/2 * 10/6)
    rlimit_stand:set(vars.l_limit * 10/6)
    llimit_move:set(vars.l_limit/2 * 10/6)
    rlimit_move:set(vars.l_limit * 10/6)
    llimit_slowm:set(vars.l_limit/2 * 10/6)
    rlimit_slowm:set(vars.l_limit * 10/6)
    end
    end
-- air
    if positionState == 5 then
    
    if math.abs(global_vars.tick_count() - vars.temp_vars) > 1 then
       vars.revs = vars.revs == 1 and 0 or 1
       vars.temp_vars = global_vars.tick_count()
    end
    local is_invert = vars.revs == 1 and key_bind:get() and false or true
    vars._jitter = air_jitter_offset:get()
    vars.l_limit = air_lfake_limit:get()
    --vars.r_limit = air_rfake_limit:get()
    
    _l_yaw_add = air_l_yaw_add:get()
    _r_yaw_add = air_r_yaw_add:get()
    vars.val_n = vars.revs == 1 and vars._jitter or -(vars._jitter)
    vars.desync_val = vars.val_n > 0 and -(vars.l_limit/120) or vars.l_limit/60
    vars._yaw_add = vars.val_n > 0 and _l_yaw_add or _r_yaw_add
    handle_yaw = normalize_yaw(vars.val_n + vars._yaw_add + vars.yaw_base + 180)
    ctx:set_invert_desync(is_invert)
    ctx:set_desync(vars.desync_val)
    ctx:set_yaw(handle_yaw)
    
    side_stand:set(4)
    side_move:set(4)
    side_slowm:set(4)
    if air_enable_aa_mode_jitter_desync:get() then
    llimit_stand:set(vars.val_n < 0 and air_jitter_desync_limit1:get() * 10/6 or air_jitter_desync_limit2:get() * 10/6)
    rlimit_stand:set(vars.val_n < 0 and air_jitter_desync_limit1:get() * 10/6 or air_jitter_desync_limit2:get() * 10/6)
    llimit_move:set(vars.val_n < 0 and air_jitter_desync_limit1:get() * 10/6 or air_jitter_desync_limit2:get() * 10/6)
    rlimit_move:set(vars.val_n < 0 and air_jitter_desync_limit1:get() * 10/6 or air_jitter_desync_limit2:get() * 10/6)
    llimit_slowm:set(vars.val_n < 0 and air_jitter_desync_limit1:get() * 10/6 or air_jitter_desync_limit2:get() * 10/6)
    rlimit_slowm:set(vars.val_n < 0 and air_jitter_desync_limit1:get() * 10/6 or air_jitter_desync_limit2:get() * 10/6)
    else
    llimit_stand:set(vars.l_limit/2 * 10/6)
    rlimit_stand:set(vars.l_limit * 10/6)
    llimit_move:set(vars.l_limit/2 * 10/6)
    rlimit_move:set(vars.l_limit * 10/6)
    llimit_slowm:set(vars.l_limit/2 * 10/6)
    rlimit_slowm:set(vars.l_limit * 10/6)
    end
    end
--slow walk
    if positionState == 3 then
    
    if math.abs(global_vars.tick_count() - vars.temp_vars) > 1 then
       vars.revs = vars.revs == 1 and 0 or 1
       vars.temp_vars = global_vars.tick_count()
    end
    local is_invert = vars.revs == 1 and key_bind:get() and false or true
    vars._jitter = sw_jitter_offset:get()
    vars.l_limit = sw_lfake_limit:get()
    --vars.r_limit = sw_rfake_limit:get()
    
    _l_yaw_add = sw_l_yaw_add:get()
    _r_yaw_add = sw_r_yaw_add:get()
    vars.val_n = vars.revs == 1 and vars._jitter or -(vars._jitter)
    vars.desync_val = vars.val_n > 0 and -(vars.l_limit/120) or vars.l_limit/60
    vars._yaw_add = vars.val_n > 0 and _l_yaw_add or _r_yaw_add
    handle_yaw = normalize_yaw(vars.val_n + vars._yaw_add + vars.yaw_base + 180)
    ctx:set_invert_desync(is_invert)
    ctx:set_desync(vars.desync_val)
    ctx:set_yaw(handle_yaw)
    
    side_stand:set(4)
    side_move:set(4)
    side_slowm:set(4)
    if sw_enable_aa_mode_jitter_desync:get() then
    llimit_stand:set(vars.val_n < 0 and sw_jitter_desync_limit1:get() * 10/6 or sw_jitter_desync_limit2:get() * 10/6)
    rlimit_stand:set(vars.val_n < 0 and sw_jitter_desync_limit1:get() * 10/6 or sw_jitter_desync_limit2:get() * 10/6)
    llimit_move:set(vars.val_n < 0 and sw_jitter_desync_limit1:get() * 10/6 or sw_jitter_desync_limit2:get() * 10/6)
    rlimit_move:set(vars.val_n < 0 and sw_jitter_desync_limit1:get() * 10/6 or sw_jitter_desync_limit2:get() * 10/6)
    llimit_slowm:set(vars.val_n < 0 and sw_jitter_desync_limit1:get() * 10/6 or sw_jitter_desync_limit2:get() * 10/6)
    rlimit_slowm:set(vars.val_n < 0 and sw_jitter_desync_limit1:get() * 10/6 or sw_jitter_desync_limit2:get() * 10/6)
    else
    llimit_stand:set(vars.l_limit/2 * 10/6)
    rlimit_stand:set(vars.l_limit * 10/6)
    llimit_move:set(vars.l_limit/2 * 10/6)
    rlimit_move:set(vars.l_limit * 10/6)
    llimit_slowm:set(vars.l_limit/2 * 10/6)
    rlimit_slowm:set(vars.l_limit * 10/6)
    end
    end
--courch
    if positionState == 4 then
    
    if math.abs(global_vars.tick_count() - vars.temp_vars) > 1 then
       vars.revs = vars.revs == 1 and 0 or 1
       vars.temp_vars = global_vars.tick_count()
    end
    local is_invert = vars.revs == 1 and key_bind:get() and false or true
    vars._jitter = courch_jitter_offset:get()
    vars.l_limit = courch_lfake_limit:get()
    --vars.r_limit = courch_rfake_limit:get()
    
    _l_yaw_add = courch_l_yaw_add:get()
    _r_yaw_add = courch_r_yaw_add:get()
    vars.val_n = vars.revs == 1 and vars._jitter or -(vars._jitter)
    vars.desync_val = vars.val_n > 0 and -(vars.l_limit/120) or vars.l_limit/60
    vars._yaw_add = vars.val_n > 0 and _l_yaw_add or _r_yaw_add
    handle_yaw = normalize_yaw(vars.val_n + vars._yaw_add + vars.yaw_base + 180)
    ctx:set_invert_desync(is_invert)
    ctx:set_desync(vars.desync_val)
    ctx:set_yaw(handle_yaw)
    
    side_stand:set(4)
    side_move:set(4)
    side_slowm:set(4)
    if air_enable_aa_mode_jitter_desync:get() then
    llimit_stand:set(vars.val_n < 0 and courch_jitter_desync_limit1:get() * 10/6 or courch_jitter_desync_limit2:get() * 10/6)
    rlimit_stand:set(vars.val_n < 0 and courch_jitter_desync_limit1:get() * 10/6 or courch_jitter_desync_limit2:get() * 10/6)
    llimit_move:set(vars.val_n < 0 and courch_jitter_desync_limit1:get() * 10/6 or courch_jitter_desync_limit2:get() * 10/6)
    rlimit_move:set(vars.val_n < 0 and courch_jitter_desync_limit1:get() * 10/6 or courch_jitter_desync_limit2:get() * 10/6)
    llimit_slowm:set(vars.val_n < 0 and courch_jitter_desync_limit1:get() * 10/6 or courch_jitter_desync_limit2:get() * 10/6)
    rlimit_slowm:set(vars.val_n < 0 and courch_jitter_desync_limit1:get() * 10/6 or courch_jitter_desync_limit2:get() * 10/6)
    else
    llimit_stand:set(vars.l_limit/2 * 10/6)
    rlimit_stand:set(vars.l_limit * 10/6)
    llimit_move:set(vars.l_limit/2 * 10/6)
    rlimit_move:set(vars.l_limit * 10/6)
    llimit_slowm:set(vars.l_limit/2 * 10/6)
    rlimit_slowm:set(vars.l_limit * 10/6)
    end
    end
end
end
callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
ffi.cdef[[
    typedef struct 
	{
		float x;
		float y;
		float z;
    } Vector_t;
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
    typedef struct
    {
        char	pad0[0x60]; // 0x00
        void* pEntity; // 0x60
        void* pActiveWeapon; // 0x64
        void* pLastActiveWeapon; // 0x68
        float		flLastUpdateTime; // 0x6C
        int			iLastUpdateFrame; // 0x70
        float		flLastUpdateIncrement; // 0x74
        float		flEyeYaw; // 0x78
        float		flEyePitch; // 0x7C
        float		flGoalFeetYaw; // 0x80
        float		flLastFeetYaw; // 0x84
        float		flMoveYaw; // 0x88
        float		flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float		flLeanAmount; // 0x90
        char	pad1[0x4]; // 0x94
        float		flFeetCycle; // 0x98 0 to 1
        float		flMoveWeight; // 0x9C 0 to 1
        float		flMoveWeightSmoothed; // 0xA0
        float		flDuckAmount; // 0xA4
        float		flHitGroundCycle; // 0xA8
        float		flRecrouchWeight; // 0xAC
        Vector_t		vecOrigin; // 0xB0
        Vector_t		vecLastOrigin;// 0xBC
        Vector_t		vecVelocity; // 0xC8
        Vector_t		vecVelocityNormalized; // 0xD4
        Vector_t		vecVelocityNormalizedNonZero; // 0xE0
        float		flVelocityLenght2D; // 0xEC
        float		flJumpFallVelocity; // 0xF0
        float		flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1 
        float		flRunningSpeed; // 0xF8
        float		flDuckingSpeed; // 0xFC
        float		flDurationMoving; // 0x100
        float		flDurationStill; // 0x104
        bool		bOnGround; // 0x108
        bool		bHitGroundAnimation; // 0x109
        char	pad2[0x2]; // 0x10A
        float		flNextLowerBodyYawUpdateTime; // 0x10C
        float		flDurationInAir; // 0x110
        float		flLeftGroundHeight; // 0x114
        float		flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float		flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char	pad3[0x4]; // 0x120
        float		flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char	pad4[0x208]; // 0x128
        float		flMinBodyYaw; // 0x330
        float		flMaxBodyYaw; // 0x334
        float		flMinPitch; //0x338
        float		flMaxPitch; // 0x33C
        int			iAnimsetVersion; // 0x340
    } CCSGOPlayerAnimationState_534535_t;
]]
local entityList = ffi.cast( "void***", memory.create_interface( "client.dll", "VClientEntityList003" ) )
local getEntityFN = ffi.cast( "GetClientEntity_4242425_t", entityList[ 0 ][ 3 ] ) 
local function getEntityAddress( idx ) return getEntityFN( entityList, idx ) end
local function getAnimstate( pPlayer ) return ffi.cast( "CCSGOPlayerAnimationState_534535_t**", ffi.cast( "uintptr_t", pPlayer ) + 0x9960 )[ 0 ] end
local fakelagamout_ticks = menu.find("antiaim", "main", "fakelag", "amount")
local ref_slow_walk_key = unpack(menu.find("misc", "main", "movement", "slow walk"))
function anim_breaker(ctx)
local ground_ticks = 1
local end_time = 0
	local player = entity_list.get_local_player()
    local lpPtr = getEntityAddress( player:get_index( ) )
    if not lpPtr or lpPtr == 0x0 then
        return
    end
	if (player == nil or not player:is_alive()) then
		return
	end
	local on_ground = player:has_player_flag(e_player_flags.ON_GROUND)
	if (animationbreakersaa:get(1)) then
		if (not on_ground) then
			ctx:set_render_pose(e_poses.JUMP_FALL, 1)
		end
	end
	if (animationbreakersaa:get(2)) then
		if on_ground and getAnimstate( lpPtr ).bHitGroundAnimation then
			ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
		end
	end
	if (animationbreakersaa:get(3)) then
		ctx:set_render_pose(e_poses.RUN, 0)
	end
	if (animationbreakersaa:get(4)) then
		ctx:set_render_animlayer(e_animlayers.LEAN, 0.75, 1)
	end
end
callbacks.add(e_callbacks.ANTIAIM,  anim_breaker)
local vtable = {}
local __thiscall = function(func, this)
    return function(...) return func(this, ...) end
end
local interface_ptr = ffi.typeof("void***")
vtable.bind = function(module, interface, index, typedef)
    local addr = ffi.cast("void***", memory.create_interface(module, interface)) or error(interface .. " was not found")
    return __thiscall(ffi.cast(typedef, addr[0][index]), addr)
end
vtable.entry = function(instance, i, ct)
    return ffi.cast(ct, ffi.cast(interface_ptr, instance)[0][i])
end
vtable.thunk = function(i, ct)
    local t = ffi.typeof(ct)
    return function(instance, ...)
        return vtable.entry(instance, i, t)(instance, ...)
    end
end
local get_class_name = vtable.thunk(143, "const char*(__thiscall*)(void*)")
local set_model_index = vtable.thunk(75, "void(__thiscall*)(void*,int)")
local get_client_entity_from_handle = vtable.bind("client.dll", "VClientEntityList003", 4, "void*(__thiscall*)(void*,void*)")
local get_model_index = vtable.bind("engine.dll", "VModelInfoClient004", 2, "int(__thiscall*)(void*, const char*)")
local rawientitylist = memory.create_interface('client.dll', 'VClientEntityList003') or error('VClientEntityList003 was not found', 2)
local ientitylist = ffi.cast(interface_ptr, rawientitylist) or error('rawientitylist is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity was not found', 2)
local client_string_table_container = ffi.cast(interface_ptr, memory.create_interface('engine.dll', 'VEngineClientStringTable001')) or error('VEngineClientStringTable001 was not found', 2)
local find_table = vtable.thunk(3, 'void*(__thiscall*)(void*, const char*)')
local model_info = ffi.cast(interface_ptr, memory.create_interface('engine.dll', 'VModelInfoClient004')) or error('VModelInfoClient004 wasnt found', 2)
ffi.cdef [[
    typedef void(__thiscall* find_or_load_model_t)(void*, const char*);
]]
local add_string = vtable.thunk(8, "int*(__thiscall*)(void*, bool, const char*, int length, const void* userdata)")
local find_or_load_model = ffi.cast("find_or_load_model_t", model_info[0][43]) -- vtable thunk crashes (?)
local function _precache(szModelName)
    if szModelName == "" then return end -- don't precache empty strings (crash)
    if szModelName == nil then return end
    szModelName = string.gsub(szModelName, [[\]], [[/]])
    local m_pModelPrecacheTable = find_table(client_string_table_container, "modelprecache")
    if m_pModelPrecacheTable ~= nil then
        find_or_load_model(model_info, szModelName)
        add_string(m_pModelPrecacheTable, false, szModelName, -1, nil)
    end
end
local list_names =
{
    'None',
    'Evil Clown',
    'Anaglyph',
    'Boar',
    'Bunny',
    'Bunny Gold',
    'Chains',
    'Chicken',
    'Dallas',
    'Devil Plastic',
    'Hoxton',
    'Doll Kabuki',
    'Pumpkin',
    'Samurai',
    'Sheep Bloody',
    'Sheep Gold',
    'Sheep Model',
    'Skull',
    'Skull Gold',
    'Template',
    'TF2 Demo',
    'TF2 Engi',
    'TF2 Heavy',
    'TF2 Medic',
    'TF2 Pyro',
    'TF2 Scout',
    'TF2 Sniper',
    'TF2 Soldier',
    'TF2 Spy',
    'Tiki',
    'Wolf',
    'Zombie Fortune Plastic',
    'Doll'
}
local masks = menu.add_selection("Mask Changer", "Mask Changer", list_names)
local models = {
    '',
    'models\\player\\holiday\\facemasks\\evil_clown.mdl',
    'models\\player\\holiday\\facemasks\\facemask_anaglyph.mdl',
    'models\\player\\holiday\\facemasks\\facemask_boar.mdl',
    'models\\player\\holiday\\facemasks\\facemask_bunny.mdl',
    'models\\player\\holiday\\facemasks\\facemask_bunny_gold.mdl',
    'models\\player\\holiday\\facemasks\\facemask_chains.mdl',
    'models\\player\\holiday\\facemasks\\facemask_chicken.mdl',
    'models\\player\\holiday\\facemasks\\facemask_dallas.mdl',
    'models\\player\\holiday\\facemasks\\facemask_devil_plastic.mdl',
    'models\\player\\holiday\\facemasks\\facemask_hoxton.mdl',
    'models\\player\\holiday\\facemasks\\facemask_porcelain_doll_kabuki.mdl',
    'models\\player\\holiday\\facemasks\\facemask_pumpkin.mdl',
    'models\\player\\holiday\\facemasks\\facemask_samurai.mdl',
    'models\\player\\holiday\\facemasks\\facemask_sheep_bloody.mdl',
    'models\\player\\holiday\\facemasks\\facemask_sheep_gold.mdl',
    'models\\player\\holiday\\facemasks\\facemask_sheep_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_skull.mdl',
    'models\\player\\holiday\\facemasks\\facemask_skull_gold.mdl',
    'models\\player\\holiday\\facemasks\\facemask_template.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_demo_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_engi_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_heavy_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_medic_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_pyro_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_scout_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_sniper_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_soldier_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tf2_spy_model.mdl',
    'models\\player\\holiday\\facemasks\\facemask_tiki.mdl',
    'models\\player\\holiday\\facemasks\\facemask_wolf.mdl',
    'models\\player\\holiday\\facemasks\\facemask_zombie_fortune_plastic.mdl',
    'models\\player\\holiday\\facemasks\\porcelain_doll.mdl'
}
local last_model = 0
local model_index = -1
local enabled = false
local function precache(modelPath)
    if modelPath == "" then return -1 end -- don't crash.
    local local_model_index = get_model_index(modelPath)
    if local_model_index == -1 then
        _precache(modelPath)
    end
    return get_model_index(modelPath)
end
local function on_paint()
    if not engine.is_in_game() then
        last_model = 0
        return
    end
    if last_model ~= masks:get() - 1 then
        last_model = masks:get() - 1
        if last_model == 0 then
            enabled = false
        else
            enabled = true
            model_index = precache(models[last_model + 1])
        end
    end
end
callbacks.add(e_callbacks.PAINT, on_paint)
local function get_player_address(lp)
    return get_client_entity(ientitylist, lp:get_index())
end
local function on_setup_command(cmd)
    if model_index == -1 then return precache(models[last_model + 1]) end
    local local_player = entity_list.get_local_player()
    if enabled then
        local lp_addr = ffi.cast("intptr_t*", get_player_address(local_player))
        local m_AddonModelsHead = ffi.cast("intptr_t*", lp_addr + 0x462F) -- E8 ? ? ? ? A1 ? ? ? ? 8B CE 8B 40 10
        local i, next_model = m_AddonModelsHead[0], -1
        while i ~= -1 do
            next_model = ffi.cast("intptr_t*", lp_addr + 0x462C)[0] + 0x18 * i -- this is the pModel (CAddonModel) afaik
            i = ffi.cast("intptr_t*", next_model + 0x14)[0]
            local m_pEnt = ffi.cast("intptr_t**", next_model)[0] -- CHandle<C_BaseAnimating> m_hEnt -> Get()
            local m_iAddon = ffi.cast("intptr_t*", next_model + 0x4)[0]
            if tonumber(m_iAddon) == 16 then -- face mask addon bits knife = 10
                local entity = get_client_entity_from_handle(m_pEnt)
                set_model_index(entity, model_index)
            end
        end
    end
end
callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)
callbacks.add(e_callbacks.NET_UPDATE, function()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    if enabled then
        if bit.band(local_player:get_prop("m_iAddonBits"), 0x10000) ~= 0x10000 then
            local_player:set_prop("m_iAddonBits", 0x10000 + local_player:get_prop("m_iAddonBits"))
        end
    else
        if bit.band(local_player:get_prop("m_iAddonBits"), 0x10000) == 0x10000 then
            local_player:set_prop("m_iAddonBits", local_player:get_prop("m_iAddonBits") - 0x10000)
        end
    end
end)
callbacks.add(e_callbacks.SHUTDOWN, function()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    if bit.band(local_player:get_prop("m_iAddonBits"), 0x10000) == 0x10000 then
        local_player:set_prop("m_iAddonBits", local_player:get_prop("m_iAddonBits") - 0x10000)
    end
end)
local function are_have_weapon(ent)
    if not ent:is_alive() or not ent:get_active_weapon() then return end
    local t_cur_wep = ent:get_active_weapon():get_class_name()
    return t_cur_wep ~= "CKnife" and t_cur_wep ~= "CWeaponTaser"
end
local function are_them_visibles(ent)
    local local_p = entity_list:get_local_player()
    local generic_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    local left_arm_pos = ent:get_hitbox_pos(e_hitgroups.LEFT_ARM)
    local right_arm_pos = ent:get_hitbox_pos(e_hitgroups.RIGHT_ARM)
    if local_p:is_point_visible(generic_pos) or local_p:is_point_visible(left_arm_pos) or local_p:is_point_visible(right_arm_pos) then return true else return false end
end
function teleport(cmd)
    local localPlayer = entity_list:get_local_player()
    if not enableTeleportInAir:get() then return end
    if ragebot.get_autopeek_pos() then return end
    local enemies = entity_list.get_players(true)
    for i,v in ipairs(enemies) do
        if are_them_visibles(v) and are_have_weapon(v) and positionState == 5 then
            exploits.force_uncharge()
            exploits.block_recharge()
        else
            exploits.allow_recharge()
        end
    end
end
local player_models = {
	{"T Model", "models/player/custom_player/legacy/tm_phoenix.mdl", true},
	{"CT Model", "models/player/custom_player/legacy/ctm_sas.mdl", true},
	{"Silent | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf1.mdl", true},
 	{"Vypa Sista of the Revolution | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variante.mdl", true},
	{"'Medium Rare' Crasswater | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantb2.mdl", true},
	{"Crasswater The Forgotten | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantb.mdl", true},
	{"Skullhead | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf2.mdl", true},
	{"Chef d'Escadron Rouchard | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_variantc.mdl", true},
	{"Cmdr. Frank 'Wet Sox' Baroud | SEAL Frogman", "models/player/custom_player/legacy/ctm_diver_variantb.mdl", true},
	{"Cmdr. Davida 'Goggles' Fernandez | SEAL Frogman", "models/player/custom_player/legacy/ctm_diver_varianta.mdl", true},
	{"Royale | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf3.mdl", true},
	{"Loudmouth | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf4.mdl", true},
	{"Miami | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf.mdl", true},
	{"Getaway Sally | Professional", "models/player/custom_player/legacy/tm_professional_varj.mdl", true},
	{"Elite Trapper Solman | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_varianta.mdl", true},
	{"Bloody Darryl The Strapped | The Professionals", "models/player/custom_player/legacy/tm_professional_varf5.mdl", true},
	{"Chem-Haz Capitaine | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_variantb.mdl", true},
	{"Lieutenant Rex Krikey | SEAL Frogman", "models/player/custom_player/legacy/ctm_diver_variantc.mdl", true},
	{"Arno The Overgrown | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantс.mdl", true},
	{"Col. Mangos Dabisi | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantd.mdl", true},
	{"Officer Jacques Beltram | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_variante.mdl", true},
	{"Trapper | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantf2.mdl", true},
	{"Lieutenant 'Tree Hugger' Farlow | SWAT", "models/player/custom_player/legacy/ctm_swat_variantk.mdl", true},
	{"Sous-Lieutenant Medic | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_varianta.mdl", true},
	{"Primeiro Tenente | Brazilian 1st Battalion", "models/player/custom_player/legacy/ctm_st6_variantn.mdl", true},
	{"D Squadron Officer | NZSAS", "models/player/custom_player/legacy/ctm_sas_variantg.mdl", true},
	{"Trapper Aggressor | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantf.mdl", true},
	{"Aspirant | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_variantd.mdl", true},
	{"AGENT Gandon | Professional", "models/player/custom_player/legacy/tm_professional_vari.mdl", true},
	{"Safecracker Voltzmann | Professional", "models/player/custom_player/legacy/tm_professional_varg.mdl", true},
	{"Little Kev | Professional", "models/player/custom_player/legacy/tm_professional_varh.mdl", true},
	{"Blackwolf | Sabre", "models/player/custom_player/legacy/tm_balkan_variantj.mdl", true},
	{"Rezan the Redshirt | Sabre", "models/player/custom_player/legacy/tm_balkan_variantk.mdl", true},
	{"Rezan The Ready | Sabre", "models/player/custom_player/legacy/tm_balkan_variantg.mdl", true},
	{"Maximus | Sabre", "models/player/custom_player/legacy/tm_balkan_varianti.mdl", true},
	{"Dragomir | Sabre", "models/player/custom_player/legacy/tm_balkan_variantf.mdl", true},
	{"Dragomir | Sabre Footsoldier", "models/player/custom_player/legacy/tm_balkan_variantl.mdl", true},
	{"Lt. Commander Ricksaw | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_varianti.mdl", true},
	{"'Two Times' McCoy | USAF TACP", "models/player/custom_player/legacy/ctm_st6_variantm.mdl", true},
	{"'Two Times' McCoy | USAF Cavalry", "models/player/custom_player/legacy/ctm_st6_variantl.mdl", true},
	{"Buckshot | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variantg.mdl", true},
	{"'Blueberries' Buckshot | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variantj.mdl", true},
	{"Seal Team 6 Soldier | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variante.mdl", true},
	{"3rd Commando Company | KSK", "models/player/custom_player/legacy/ctm_st6_variantk.mdl", true},
	{"'The Doctor' Romanov | Sabre", "models/player/custom_player/legacy/tm_balkan_varianth.mdl", true},
	{"Michael Syfers| FBI Sniper", "models/player/custom_player/legacy/ctm_fbi_varianth.mdl", true},
	{"Markus Delrow | FBI HRT", "models/player/custom_player/legacy/ctm_fbi_variantg.mdl", true},
	{"Cmdr. Mae | SWAT", "models/player/custom_player/legacy/ctm_swat_variante.mdl", true},
	{"1st Lieutenant Farlow | SWAT", "models/player/custom_player/legacy/ctm_swat_variantf.mdl", true},
	{"John 'Van Healen' Kask | SWAT", "models/player/custom_player/legacy/ctm_swat_variantg.mdl", true},
	{"Bio-Haz Specialist | SWAT", "models/player/custom_player/legacy/ctm_swat_varianth.mdl", true},
	{"Chem-Haz Specialist | SWAT", "models/player/custom_player/legacy/ctm_swat_variantj.mdl", true},
	{"Sergeant Bombson | SWAT", "models/player/custom_player/legacy/ctm_swat_varianti.mdl", true},
	{"Operator | FBI SWAT", "models/player/custom_player/legacy/ctm_fbi_variantf.mdl", true},
	{"Street Soldier | Phoenix", "models/player/custom_player/legacy/tm_phoenix_varianti.mdl", true},
	{"Slingshot | Phoenix", "models/player/custom_player/legacy/tm_phoenix_variantg.mdl", true},
	{"Enforcer | Phoenix", "models/player/custom_player/legacy/tm_phoenix_variantf.mdl", true},
	{"Soldier | Phoenix", "models/player/custom_player/legacy/tm_phoenix_varianth.mdl", true},
	{"The Elite Mr. Muhlik | Elite Crew", "models/player/custom_player/legacy/tm_leet_variantf.mdl", true},
	{"Prof. Shahmat | Elite Crew", "models/player/custom_player/legacy/tm_leet_varianti.mdl", true},
	{"Osiris | Elite Crew", "models/player/custom_player/legacy/tm_leet_varianth.mdl", true},
	{"Ground Rebel| Elite Crew", "models/player/custom_player/legacy/tm_leet_variantg.mdl", true},
	{"Special Agent Ava | FBI", "models/player/custom_player/legacy/ctm_fbi_variantb.mdl", true},
	{"B Squadron Officer | SAS", "models/player/custom_player/legacy/ctm_sas_variantf.mdl", true},
	{"Jumpsuit Variant A","models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl",true},
	{"Jumpsuit Variant B","models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl",true},
	{"Jumpsuit Variant C","models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl",true},
	{"Jumpsuit Variant A","models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl",true},
	{"Jumpsuit Variant B","models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl",true},
	{"Jumpsuit Variant C","models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl",true},
        {"Anarchist A", "models/player/custom_player/legacy/tm_anarchist_varianta.mdl", true},
        {"Anarchist B", "models/player/custom_player/legacy/tm_anarchist_variantb.mdl", true},
        {"Anarchist C", "models/player/custom_player/legacy/tm_anarchist_variantc.mdl", true},
        {"Anarchist A", "models/player/custom_player/legacy/tm_anarchist_varianta.mdl", true},
        {"Anarchist B", "models/player/custom_player/legacy/tm_anarchist_variantb.mdl", true},
        {"Anarchist C", "models/player/custom_player/legacy/tm_anarchist_variantc.mdl", true},
        {"Separatist A", "models/player/custom_player/legacy/tm_separatist_varianta.mdl", true},
        {"Separatist B", "models/player/custom_player/legacy/tm_separatist_variantb.mdl", true},
        {"Separatist C", "models/player/custom_player/legacy/tm_separatist_variantc.mdl", true},
        {"Separatist D", "models/player/custom_player/legacy/tm_separatist_variantd.mdl", true},
	{"CTM. FBI", "models/player/custom_player/legacy/ctm_fbi.mdl", true},
	{"CTM. FBI A", "models/player/custom_player/legacy/ctm_fbi_varianta.mdl", true},
	{"CTM. FBI B", "models/player/custom_player/legacy/ctm_fbi_variantc.mdl", true},
	{"CTM. FBI C", "models/player/custom_player/legacy/ctm_fbi_variantd.mdl", true},
	{"CTM. FBI E", "models/player/custom_player/legacy/ctm_fbi_variante.mdl", true},
        {"Gign Model A", "models/player/custom_player/legacy/ctm_gign_varianta.mdl", true},
        {"Gign Model B", "models/player/custom_player/legacy/ctm_gign_variantb.mdl", true},
        {"Gign Model C", "models/player/custom_player/legacy/ctm_gign_variantc.mdl", true},
	{"CTM. ST6", "models/player/custom_player/legacy/ctm_st6.mdl", true},
	{"CTM. ST6 A", "models/player/custom_player/legacy/ctm_st6_varianta.mdl",true},
	{"CTM. ST6 B", "models/player/custom_player/legacy/ctm_st6_variantb.mdl", true},
	{"CTM. ST6 C", "models/player/custom_player/legacy/ctm_st6_variantc.mdl",true},
	{"CTM. ST6 D", "models/player/custom_player/legacy/ctm_st6_variantd.mdl", true},
	{"CTM. IDF B", "models/player/custom_player/legacy/ctm_idf_variantb.mdl", true},
	{"CTM. IDF C", "models/player/custom_player/legacy/ctm_idf_variantc.mdl", true},
	{"CTM. IDF D", "models/player/custom_player/legacy/ctm_idf_variantd.mdl", true},
	{"CTM. IDF E", "models/player/custom_player/legacy/ctm_idf_variante.mdl",true},
	{"CTM. IDF F", "models/player/custom_player/legacy/ctm_idf_variantf.mdl",true},
        {"CTM. Swat", "models/player/custom_player/legacy/ctm_swat.mdl",true},
        {"CTM. Swat A", "models/player/custom_player/legacy/ctm_swat_varianta.mdl", true},
        {"CTM. Swat B", "models/player/custom_player/legacy/ctm_swat_variantb.mdl", true},
        {"CTM. Swat C", "models/player/custom_player/legacy/ctm_swat_variantc.mdl", true},
        {"CTM. Swat D", "models/player/custom_player/legacy/ctm_swat_variantd.mdl", true},
        {"CTM. Sas", "models/player/custom_player/legacy/ctm_sas.mdl", true},
        {"CTM. Gsg9", "models/player/custom_player/legacy/ctm_gsg9.mdl", true},
	{"CTM. Gsg9 A", "models/player/custom_player/legacy/ctm_gsg9_varianta.mdl", true},
	{"CTM. Gsg9 B", "models/player/custom_player/legacy/ctm_gsg9_variantb.mdl", true},
	{"CTM. Gsg9 C", "models/player/custom_player/legacy/ctm_gsg9_variantc.mdl", true},
	{"CTM. Gsg9 D", "models/player/custom_player/legacy/ctm_gsg9_variantd.mdl", true},
        {"Professional A", "models/player/custom_player/legacy/tm_professional_var1.mdl", true},
        {"Professional B", "models/player/custom_player/legacy/tm_professional_var2.mdl", true},
        {"Professional C", "models/player/custom_player/legacy/tm_professional_var3.mdl", true},
        {"Professional D", "models/player/custom_player/legacy/tm_professional_var4.mdl", true},
        {"Leet A", "models/player/custom_player/legacy/tm_leet_varianta.mdl", true},
        {"Leet B", "models/player/custom_player/legacy/tm_leet_variantb.mdl",true},
        {"Leet C", "models/player/custom_player/legacy/tm_leet_variantc.mdl", true},
        {"Leet D", "models/player/custom_player/legacy/tm_leet_variantd.mdl", true},
        {"Balkan A", "models/player/custom_player/legacy/tm_Balkan_varianta.mdl", true},
        {"Balkan B", "models/player/custom_player/legacy/tm_Balkan_variantb.mdl", true},
        {"Balkan C", "models/player/custom_player/legacy/tm_Balkan_variantc.mdl", true},
        {"Balkan D", "models/player/custom_player/legacy/tm_Balkan_variantd.mdl", true},
        {"Pirate A", "models/player/custom_player/legacy/tm_pirate_varianta.mdl", true},
        {"Pirate B", "models/player/custom_player/legacy/tm_pirate_variantb.mdl", true},
        {"Pirate C", "models/player/custom_player/legacy/tm_pirate_variantc.mdl", true},
        {"Separatist A", "models/player/custom_player/legacy/tm_separatist_varianta.mdl", true},
        {"Separatist B", "models/player/custom_player/legacy/tm_separatist_variantb.mdl", true},
        {"Separatist C", "models/player/custom_player/legacy/tm_separatist_variantc.mdl", true},
        {"Separatist D", "models/player/custom_player/legacy/tm_separatist_variantd.mdl", true},
        {"CTM. FBI", "models/player/custom_player/legacy/ctm_fbi.mdl", true},
	{"CTM. FBI A", "models/player/custom_player/legacy/ctm_fbi_varianta.mdl", true},
	{"CTM. FBI B", "models/player/custom_player/legacy/ctm_fbi_variantc.mdl", true},
	{"CTM. FBI C", "models/player/custom_player/legacy/ctm_fbi_variantd.mdl", true},
	{"CTM. FBI E", "models/player/custom_player/legacy/ctm_fbi_variante.mdl", true},
        {"Gign Model A", "models/player/custom_player/legacy/ctm_gign_varianta.mdl", true},
        {"Gign Model B", "models/player/custom_player/legacy/ctm_gign_variantb.mdl", true},
        {"Gign Model C", "models/player/custom_player/legacy/ctm_gign_variantc.mdl", true},
	{"CTM. ST6", "models/player/custom_player/legacy/ctm_st6.mdl", true},
	{"CTM. ST6 A", "models/player/custom_player/legacy/ctm_st6_varianta.mdl", true},
	{"CTM. ST6 B", "models/player/custom_player/legacy/ctm_st6_variantb.mdl", true},
	{"CTM. ST6 C", "models/player/custom_player/legacy/ctm_st6_variantc.mdl", true},
	{"CTM. ST6 D", "models/player/custom_player/legacy/ctm_st6_variantd.mdl", true},
        {"IDF", "models/player/custom_player/legacy/ctm_idf.mdl", true},
        {"CTM. IDF B", "models/player/custom_player/legacy/ctm_idf_variantb.mdl", true},
	{"CTM. IDF C", "models/player/custom_player/legacy/ctm_idf_variantc.mdl", true},
	{"CTM. IDF D", "models/player/custom_player/legacy/ctm_idf_variantd.mdl", true},
	{"CTM. IDF E", "models/player/custom_player/legacy/ctm_idf_variante.mdl", true},
	{"CTM. IDF F", "models/player/custom_player/legacy/ctm_idf_variantf.mdl", true},
        {"CTM. Swat", "models/player/custom_player/legacy/ctm_swat.mdl", true},
        {"CTM. Swat A", "models/player/custom_player/legacy/ctm_swat_varianta.mdl", true},
        {"CTM. Swat B", "models/player/custom_player/legacy/ctm_swat_variantb.mdl", true},
        {"CTM. Swat C", "models/player/custom_player/legacy/ctm_swat_variantc.mdl", true},
        {"CTM. Swat D", "models/player/custom_player/legacy/ctm_swat_variantd.mdl", true},
        {"CTM. Sas", "models/player/custom_player/legacy/ctm_sas.mdl", true},
        {"CTM. Gsg9", "models/player/custom_player/legacy/ctm_gsg9.mdl", true},
	{"CTM. Gsg9 A", "models/player/custom_player/legacy/ctm_gsg9_varianta.mdl", true},
	{"CTM. Gsg9 B", "models/player/custom_player/legacy/ctm_gsg9_variantb.mdl", true},
	{"CTM. Gsg9 C", "models/player/custom_player/legacy/ctm_gsg9_variantc.mdl", true},
	{"CTM. Gsg9 D", "models/player/custom_player/legacy/ctm_gsg9_variantd.mdl", true},
        {"Professional A", "models/player/custom_player/legacy/tm_professional_var1.mdl", true},
        {"Professional B", "models/player/custom_player/legacy/tm_professional_var2.mdl", true},
        {"Professional C", "models/player/custom_player/legacy/tm_professional_var3.mdl", true},
        {"Professional D", "models/player/custom_player/legacy/tm_professional_var4.mdl", true},
        {"Leet A", "models/player/custom_player/legacy/tm_leet_varianta.mdl", true},
        {"Leet B", "models/player/custom_player/legacy/tm_leet_variantb.mdl", true},
        {"Leet C", "models/player/custom_player/legacy/tm_leet_variantc.mdl", true},
        {"Leet D", "models/player/custom_player/legacy/tm_leet_variantD.mdl", true},
        {"Balkan A", "models/player/custom_player/legacy/tm_Balkan_varianta.mdl", true},
        {"Balkan B", "models/player/custom_player/legacy/tm_Balkan_variantb.mdl", true},
        {"Balkan C", "models/player/custom_player/legacy/tm_Balkan_variantc.mdl", true},
        {"Balkan D", "models/player/custom_player/legacy/tm_Balkan_variantd.mdl", true},
        {"Pirate A", "models/player/custom_player/legacy/tm_pirate_varianta.mdl", true},
        {"Pirate B", "models/player/custom_player/legacy/tm_pirate_variantb.mdl", true},
        {"Pirate C", "models/player/custom_player/legacy/tm_pirate_variantc.mdl", true},
	{"T Model", "models/player/custom_player/legacy/tm_phoenix.mdl", false},
	{"CT Model", "models/player/custom_player/legacy/ctm_sas.mdl", false},
	{"Silent | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf1.mdl", false},
 	{"Vypa Sista of the Revolution | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variante.mdl",false},
	{"'Medium Rare' Crasswater | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantb2.mdl", false},
	{"Crasswater The Forgotten | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantb.mdl", false},
	{"Skullhead | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf2.mdl", false},
	{"Chef d'Escadron Rouchard | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_variantc.mdl", false},
	{"Cmdr. Frank 'Wet Sox' Baroud | SEAL Frogman", "models/player/custom_player/legacy/ctm_diver_variantb.mdl", false},
    {"Cmdr. Davida 'Goggles' Fernandez | SEAL Frogman", "models/player/custom_player/legacy/ctm_diver_varianta.mdl", false},
	{"Royale | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf3.mdl", false},
	{"Loudmouth | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf4.mdl", false},
	{"Miami | Sir Bloody Darryl", "models/player/custom_player/legacy/tm_professional_varf.mdl", false},
	{"Getaway Sally | Professional", "models/player/custom_player/legacy/tm_professional_varj.mdl", false},
	{"Elite Trapper Solman | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_varianta.mdl", false},
	{"Bloody Darryl The Strapped | The Professionals", "models/player/custom_player/legacy/tm_professional_varf5.mdl", false},
	{"Chem-Haz Capitaine | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_variantb.mdl", false},
	{"Lieutenant Rex Krikey | SEAL Frogman", "models/player/custom_player/legacy/ctm_diver_variantc.mdl", false},
	{"Arno The Overgrown | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantс.mdl", false},
	{"Col. Mangos Dabisi | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantd.mdl", false},
	{"Officer Jacques Beltram | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_variante.mdl", false},
	{"Trapper | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantf2.mdl", false},
	{"Lieutenant 'Tree Hugger' Farlow | SWAT", "models/player/custom_player/legacy/ctm_swat_variantk.mdl", false},
	{"Sous-Lieutenant Medic | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_varianta.mdl", false},
	{"Primeiro Tenente | Brazilian 1st Battalion", "models/player/custom_player/legacy/ctm_st6_variantn.mdl", false},
	{"D Squadron Officer | NZSAS", "models/player/custom_player/legacy/ctm_sas_variantg.mdl", false},
	{"Trapper Aggressor | Guerrilla Warfare", "models/player/custom_player/legacy/tm_jungle_raider_variantf.mdl", false},
	{"Aspirant | Gendarmerie Nationale", "models/player/custom_player/legacy/ctm_gendarmerie_variantd.mdl", false},
	{"AGENT Gandon | Professional", "models/player/custom_player/legacy/tm_professional_vari.mdl", false},
	{"Safecracker Voltzmann | Professional", "models/player/custom_player/legacy/tm_professional_varg.mdl", false},
	{"Little Kev | Professional", "models/player/custom_player/legacy/tm_professional_varh.mdl", false},
	{"Blackwolf | Sabre", "models/player/custom_player/legacy/tm_balkan_variantj.mdl", false},
	{"Rezan the Redshirt | Sabre", "models/player/custom_player/legacy/tm_balkan_variantk.mdl", false},
	{"Rezan The Ready | Sabre", "models/player/custom_player/legacy/tm_balkan_variantg.mdl", false},
	{"Maximus | Sabre", "models/player/custom_player/legacy/tm_balkan_varianti.mdl", false},
	{"Dragomir | Sabre", "models/player/custom_player/legacy/tm_balkan_variantf.mdl", false},
	{"Dragomir | Sabre Footsoldier", "models/player/custom_player/legacy/tm_balkan_variantl.mdl", false},
	{"Lt. Commander Ricksaw | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_varianti.mdl", false},
	{"'Two Times' McCoy | USAF TACP", "models/player/custom_player/legacy/ctm_st6_variantm.mdl", false},
	{"'Two Times' McCoy | USAF Cavalry", "models/player/custom_player/legacy/ctm_st6_variantl.mdl", false},
	{"Buckshot | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variantg.mdl", false},
	{"'Blueberries' Buckshot | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variantj.mdl", false},
	{"Seal Team 6 Soldier | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variante.mdl", false},
	{"3rd Commando Company | KSK", "models/player/custom_player/legacy/ctm_st6_variantk.mdl", false},
	{"'The Doctor' Romanov | Sabre", "models/player/custom_player/legacy/tm_balkan_varianth.mdl", false},
	{"Michael Syfers| FBI Sniper", "models/player/custom_player/legacy/ctm_fbi_varianth.mdl", false},
	{"Markus Delrow | FBI HRT", "models/player/custom_player/legacy/ctm_fbi_variantg.mdl", false},
	{"Cmdr. Mae | SWAT", "models/player/custom_player/legacy/ctm_swat_variante.mdl", false},
	{"1st Lieutenant Farlow | SWAT", "models/player/custom_player/legacy/ctm_swat_variantf.mdl", false},
	{"John 'Van Healen' Kask | SWAT", "models/player/custom_player/legacy/ctm_swat_variantg.mdl", false},
	{"Bio-Haz Specialist | SWAT", "models/player/custom_player/legacy/ctm_swat_varianth.mdl", false},
	{"Chem-Haz Specialist | SWAT", "models/player/custom_player/legacy/ctm_swat_variantj.mdl", false},
	{"Sergeant Bombson | SWAT", "models/player/custom_player/legacy/ctm_swat_varianti.mdl", false},
	{"Operator | FBI SWAT", "models/player/custom_player/legacy/ctm_fbi_variantf.mdl", false},
	{"Street Soldier | Phoenix", "models/player/custom_player/legacy/tm_phoenix_varianti.mdl", false},
	{"Slingshot | Phoenix", "models/player/custom_player/legacy/tm_phoenix_variantg.mdl", false},
	{"Enforcer | Phoenix", "models/player/custom_player/legacy/tm_phoenix_variantf.mdl", false},
	{"Soldier | Phoenix", "models/player/custom_player/legacy/tm_phoenix_varianth.mdl", false},
	{"The Elite Mr. Muhlik | Elite Crew", "models/player/custom_player/legacy/tm_leet_variantf.mdl", false},
	{"Prof. Shahmat | Elite Crew", "models/player/custom_player/legacy/tm_leet_varianti.mdl", false},
	{"Osiris | Elite Crew", "models/player/custom_player/legacy/tm_leet_varianth.mdl", false},
	{"Ground Rebel| Elite Crew", "models/player/custom_player/legacy/tm_leet_variantg.mdl", false},
	{"Special Agent Ava | FBI", "models/player/custom_player/legacy/ctm_fbi_variantb.mdl", false},
	{"B Squadron Officer | SAS", "models/player/custom_player/legacy/ctm_sas_variantf.mdl", false},
	{"Jumpsuit Variant A","models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl",false},
	{"Jumpsuit Variant B","models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl",false},
	{"Jumpsuit Variant C","models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl",false},
	{"Jumpsuit Variant A","models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl",false},
	{"Jumpsuit Variant B","models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl",false},
	{"Jumpsuit Variant C","models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl",false},
        {"Anarchist A", "models/player/custom_player/legacy/tm_anarchist_varianta.mdl", false},
        {"Anarchist B", "models/player/custom_player/legacy/tm_anarchist_variantb.mdl", false},
        {"Anarchist C", "models/player/custom_player/legacy/tm_anarchist_variantc.mdl", false},
        {"Anarchist A", "models/player/custom_player/legacy/tm_anarchist_varianta.mdl", false},
        {"Anarchist B", "models/player/custom_player/legacy/tm_anarchist_variantb.mdl", false},
        {"Anarchist C", "models/player/custom_player/legacy/tm_anarchist_variantc.mdl", false},
        {"Separatist A", "models/player/custom_player/legacy/tm_separatist_varianta.mdl", false},
        {"Separatist B", "models/player/custom_player/legacy/tm_separatist_variantb.mdl", false},
        {"Separatist C", "models/player/custom_player/legacy/tm_separatist_variantc.mdl", false},
        {"Separatist D", "models/player/custom_player/legacy/tm_separatist_variantd.mdl", false},
	{"CTM. FBI", "models/player/custom_player/legacy/ctm_fbi.mdl", false},
	{"CTM. FBI A", "models/player/custom_player/legacy/ctm_fbi_varianta.mdl", false},
	{"CTM. FBI B", "models/player/custom_player/legacy/ctm_fbi_variantc.mdl", false},
	{"CTM. FBI C", "models/player/custom_player/legacy/ctm_fbi_variantd.mdl", false},
	{"CTM. FBI E", "models/player/custom_player/legacy/ctm_fbi_variante.mdl", false},
        {"Gign Model A", "models/player/custom_player/legacy/ctm_gign_varianta.mdl", false},
        {"Gign Model B", "models/player/custom_player/legacy/ctm_gign_variantb.mdl", false},
        {"Gign Model C", "models/player/custom_player/legacy/ctm_gign_variantc.mdl", false},
	{"CTM. ST6", "models/player/custom_player/legacy/ctm_st6.mdl", false},
	{"CTM. ST6 A", "models/player/custom_player/legacy/ctm_st6_varianta.mdl", false},
	{"CTM. ST6 B", "models/player/custom_player/legacy/ctm_st6_variantb.mdl", false},
	{"CTM. ST6 C", "models/player/custom_player/legacy/ctm_st6_variantc.mdl", false},
	{"CTM. ST6 D", "models/player/custom_player/legacy/ctm_st6_variantd.mdl", false},
	{"CTM. IDF B", "models/player/custom_player/legacy/ctm_idf_variantb.mdl", false},
	{"CTM. IDF C", "models/player/custom_player/legacy/ctm_idf_variantc.mdl", false},
	{"CTM. IDF D", "models/player/custom_player/legacy/ctm_idf_variantd.mdl", false},
	{"CTM. IDF E", "models/player/custom_player/legacy/ctm_idf_variante.mdl", false},
	{"CTM. IDF F", "models/player/custom_player/legacy/ctm_idf_variantf.mdl", false},
        {"CTM. Swat", "models/player/custom_player/legacy/ctm_swat.mdl", false},
        {"CTM. Swat A", "models/player/custom_player/legacy/ctm_swat_varianta.mdl", false},
        {"CTM. Swat B", "models/player/custom_player/legacy/ctm_swat_variantb.mdl", false},
        {"CTM. Swat C", "models/player/custom_player/legacy/ctm_swat_variantc.mdl", false},
        {"CTM. Swat D", "models/player/custom_player/legacy/ctm_swat_variantd.mdl", false},
        {"CTM. Sas", "models/player/custom_player/legacy/ctm_sas.mdl", false},
        {"CTM. Gsg9", "models/player/custom_player/legacy/ctm_gsg9.mdl", false},
	{"CTM. Gsg9 A", "models/player/custom_player/legacy/ctm_gsg9_varianta.mdl", false},
	{"CTM. Gsg9 B", "models/player/custom_player/legacy/ctm_gsg9_variantb.mdl", false},
	{"CTM. Gsg9 C", "models/player/custom_player/legacy/ctm_gsg9_variantc.mdl", false},
	{"CTM. Gsg9 D", "models/player/custom_player/legacy/ctm_gsg9_variantd.mdl", false},
        {"Professional A", "models/player/custom_player/legacy/tm_professional_var1.mdl", false},
        {"Professional B", "models/player/custom_player/legacy/tm_professional_var2.mdl", false},
        {"Professional C", "models/player/custom_player/legacy/tm_professional_var3.mdl", false},
        {"Professional D", "models/player/custom_player/legacy/tm_professional_var4.mdl", false},
        {"Leet A", "models/player/custom_player/legacy/tm_leet_varianta.mdl", false},
        {"Leet B", "models/player/custom_player/legacy/tm_leet_variantb.mdl", false},
        {"Leet C", "models/player/custom_player/legacy/tm_leet_variantc.mdl", false},
        {"Leet D", "models/player/custom_player/legacy/tm_leet_variantd.mdl", false},
        {"Balkan A", "models/player/custom_player/legacy/tm_Balkan_varianta.mdl", false},
        {"Balkan B", "models/player/custom_player/legacy/tm_Balkan_variantb.mdl", false},
        {"Balkan C", "models/player/custom_player/legacy/tm_Balkan_variantc.mdl", false},
        {"Balkan D", "models/player/custom_player/legacy/tm_Balkan_variantd.mdl", false},
        {"Pirate A", "models/player/custom_player/legacy/tm_pirate_varianta.mdl", false},
        {"Pirate B", "models/player/custom_player/legacy/tm_pirate_variantb.mdl", false},
        {"Pirate C", "models/player/custom_player/legacy/tm_pirate_variantc.mdl", false},
        {"Separatist A", "models/player/custom_player/legacy/tm_separatist_varianta.mdl", false},
        {"Separatist B", "models/player/custom_player/legacy/tm_separatist_variantb.mdl", false},
        {"Separatist C", "models/player/custom_player/legacy/tm_separatist_variantc.mdl", false},
        {"Separatist D", "models/player/custom_player/legacy/tm_separatist_variantd.mdl", false},
        {"CTM. FBI", "models/player/custom_player/legacy/ctm_fbi.mdl", false},
	{"CTM. FBI A", "models/player/custom_player/legacy/ctm_fbi_varianta.mdl", false},
	{"CTM. FBI B", "models/player/custom_player/legacy/ctm_fbi_variantc.mdl", false},
	{"CTM. FBI C", "models/player/custom_player/legacy/ctm_fbi_variantd.mdl", false},
	{"CTM. FBI E", "models/player/custom_player/legacy/ctm_fbi_variante.mdl", false},
        {"Gign Model A", "models/player/custom_player/legacy/ctm_gign_varianta.mdl", false},
        {"Gign Model B", "models/player/custom_player/legacy/ctm_gign_variantb.mdl", false},
        {"Gign Model C", "models/player/custom_player/legacy/ctm_gign_variantc.mdl", false},
	{"CTM. ST6", "models/player/custom_player/legacy/ctm_st6.mdl", false},
	{"CTM. ST6 A", "models/player/custom_player/legacy/ctm_st6_varianta.mdl", false},
	{"CTM. ST6 B", "models/player/custom_player/legacy/ctm_st6_variantb.mdl", false},
	{"CTM. ST6 C", "models/player/custom_player/legacy/ctm_st6_variantc.mdl", false},
	{"CTM. ST6 D", "models/player/custom_player/legacy/ctm_st6_variantd.mdl", false},
        {"IDF", "models/player/custom_player/legacy/ctm_idf.mdl", false},
        {"CTM. IDF B", "models/player/custom_player/legacy/ctm_idf_variantb.mdl", false},
	{"CTM. IDF C", "models/player/custom_player/legacy/ctm_idf_variantc.mdl", false},
	{"CTM. IDF D", "models/player/custom_player/legacy/ctm_idf_variantd.mdl", false},
	{"CTM. IDF E", "models/player/custom_player/legacy/ctm_idf_variante.mdl", false},
	{"CTM. IDF F", "models/player/custom_player/legacy/ctm_idf_variantf.mdl", false},
        {"CTM. Swat", "models/player/custom_player/legacy/ctm_swat.mdl", false},
        {"CTM. Swat A", "models/player/custom_player/legacy/ctm_swat_varianta.mdl", false},
        {"CTM. Swat B", "models/player/custom_player/legacy/ctm_swat_variantb.mdl", false},
        {"CTM. Swat C", "models/player/custom_player/legacy/ctm_swat_variantc.mdl", false},
        {"CTM. Swat D", "models/player/custom_player/legacy/ctm_swat_variantd.mdl", false},
        {"CTM. Sas", "models/player/custom_player/legacy/ctm_sas.mdl", false},
        {"CTM. Gsg9", "models/player/custom_player/legacy/ctm_gsg9.mdl", false},
	{"CTM. Gsg9 A", "models/player/custom_player/legacy/ctm_gsg9_varianta.mdl", false},
	{"CTM. Gsg9 B", "models/player/custom_player/legacy/ctm_gsg9_variantb.mdl", false},
	{"CTM. Gsg9 C", "models/player/custom_player/legacy/ctm_gsg9_variantc.mdl", false},
	{"CTM. Gsg9 D", "models/player/custom_player/legacy/ctm_gsg9_variantd.mdl", false},
        {"Professional A", "models/player/custom_player/legacy/tm_professional_var1.mdl", false},
        {"Professional B", "models/player/custom_player/legacy/tm_professional_var2.mdl", false},
        {"Professional C", "models/player/custom_player/legacy/tm_professional_var3.mdl", false},
        {"Professional D", "models/player/custom_player/legacy/tm_professional_var4.mdl", false},
        {"Leet A", "models/player/custom_player/legacy/tm_leet_varianta.mdl", false},
        {"Leet B", "models/player/custom_player/legacy/tm_leet_variantb.mdl", false},
        {"Leet C", "models/player/custom_player/legacy/tm_leet_variantc.mdl", false},
        {"Leet D", "models/player/custom_player/legacy/tm_leet_variantD.mdl", false},
        {"Balkan A", "models/player/custom_player/legacy/tm_Balkan_varianta.mdl", false},
        {"Balkan B", "models/player/custom_player/legacy/tm_Balkan_variantb.mdl", false},
        {"Balkan C", "models/player/custom_player/legacy/tm_Balkan_variantc.mdl", false},
        {"Balkan D", "models/player/custom_player/legacy/tm_Balkan_variantd.mdl", false},
        {"Pirate A", "models/player/custom_player/legacy/tm_pirate_varianta.mdl", false},
        {"Pirate B", "models/player/custom_player/legacy/tm_pirate_variantb.mdl", false},
        {"Pirate C", "models/player/custom_player/legacy/tm_pirate_variantc.mdl", false},
}
local cs_teams = {
	{"Counter-Terrorist", false},
	{"Terrorist", true}
}
client.log_screen(color_t(255, 0, 0), "Welcome back, " .. "Cracked Ez")
local ent_list = memory.create_interface("client.dll", "VClientEntityList003")
local entity_list_raw = ffi.cast("void***",ent_list)
local get_client_entity = ffi.cast("void*(__thiscall*)(void*,int)",memory.get_vfunc(ent_list,3))
local model_info_interface = memory.create_interface("engine.dll","VModelInfoClient004")
local raw_model_info = ffi.cast("void***",model_info_interface)
local get_model_index = ffi.cast("int(__thiscall*)(void*, const char*)",memory.get_vfunc(tonumber(ffi.cast("unsigned int",raw_model_info)),2))
local set_model_index_t = ffi.typeof("void(__thiscall*)(void*,int)")
--reversed for no reason cuz ducarii n i thought modelindex no worky
local set_model_index = ffi.cast(set_model_index_t, memory.find_pattern("client.dll","55 8B EC 8B 45 08 56 8B F1 8B 0D ?? ?? ?? ??"))
local team_references, team_model_paths = {}, {}
local model_index_prev
for i=1, #cs_teams do
	local teamname, is_t = unpack(cs_teams[i])
	team_model_paths[is_t] = {}
	local model_names = {}
	local l_i = 0
	for i=1, #player_models do
		local model_name, model_path, model_is_t = unpack(player_models[i])
		if model_is_t == nil or model_is_t == is_t then
			table.insert(model_names, model_name)
			l_i = l_i + 1
			team_model_paths[is_t][l_i] = model_path
		end
	end
	team_references[is_t] = {
		enabled_reference = menu.add_checkbox("Agent Changer",string.format("Enable changer",teamname)),
		model_reference = menu.add_list("Agent Changer","Player Models",model_names,20)
	}
	for _, v in pairs(team_references[is_t]) do
		v:set_visible(false)
	end
end
local function do_model_change()
	local local_player = entity_list.get_local_player()
	if local_player == nil then
		return
	end
	if not local_player:is_alive() then
		return
	end
	local player_ptr = ffi.cast("void***",get_client_entity(entity_list_raw,local_player:get_index()))
	local set_model_idx  = ffi.cast(set_model_index_t,memory.get_vfunc(tonumber(ffi.cast("unsigned int",player_ptr)),75))
	if(player_ptr == nil) then
		return
	end
	if(set_model_idx == nil) then
		return
	end
	local model_path, model_index
	local teamnum = local_player:get_prop("m_iTeamNum")
	local is_t = teamnum == 2 and true or false
	for references_is_t, references in pairs(team_references) do
		references.enabled_reference:set_visible(references_is_t == is_t)
		if references_is_t == is_t and references.enabled_reference:get() then
			references.model_reference:set_visible(true)
			model_path = team_model_paths[is_t][tonumber(references.model_reference:get())]
		else
			references.model_reference:set_visible(false)
		end
	end
	local model_index
	if model_path ~= nil then
		model_index = get_model_index(raw_model_info,model_path)
		if model_index == -1 then
			model_index = nil
		end
	end
	if(model_index == nil and model_path ~= nil) then
		client.precache_model(model_path)
	end
	model_index_prev = model_index
	if model_index ~= nil then
		set_model_idx(player_ptr,model_index)
	end
end
callbacks.add(e_callbacks.NET_UPDATE,do_model_change)
callbacks.add(e_callbacks.SETUP_COMMAND, teleport)
callbacks.add(e_callbacks.PAINT, positionInTheWorld)
callbacks.add(e_callbacks.DRAW_WATERMARK, function() return "" end)
callbacks.add(e_callbacks.PAINT, renderWatermark)
local warning2 = menu.add_text("World", "if it starts writing heavily on the server, turn it off")
local backtrack_e = menu.add_checkbox("Ragebot", "Backtrack Fix", false)
local function backtarck()
   if backtrack_e:get() then
      cvars.sv_maxunlag:set_int(60)
   end
end
callbacks.add(e_callbacks.SETUP_COMMAND, backtarck)