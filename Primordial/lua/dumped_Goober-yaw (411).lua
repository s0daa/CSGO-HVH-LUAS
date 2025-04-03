--Made by EdwiN
function clamp(x, min, max)
	return x < min and min or x > max and max or x
end

local fl_presets = {
    "Static",
    "Fluctuate",
    "Random",
    "Jitter",
}

local os_presets = {
    "off",
    "opposite",
    "same side",
    "random",
}

local c_cfg = {} c_cfg.__index = c_cfg
c_cfg.table = {
    c_ragebot = {
        ref_auto_peek = menu.add_checkbox("RageBot","Auto peek", false),
    },

    c_antiaim = {
        ref_enable = menu.add_checkbox("Anti-Aim","Enabled"),
        ref_anti_bruteforce = menu.add_checkbox("Anti-Aim","Anti-bruteforce"),
        ref_inverter = menu.add_checkbox("Anti-Aim","Inverter"),
        ref_onshot = menu.add_selection("Anti-Aim","On-shot anti-aim", os_presets),
        ref_use_aa = menu.add_checkbox("Anti-Aim","Legit on use"),
        ref_fake_desync = menu.add_checkbox("Anti-Aim","Fake desync"),
        ref_sway_desync = menu.add_checkbox("Anti-Aim","Sway"),
        ref_sway_desync_both = menu.add_checkbox("Anti-Aim","Sway both"),
        ref_roll = menu.add_checkbox("Anti-Aim","Roll"),
        ref_left_amount = menu.add_slider("Anti-Aim","Left amount", 0, 60),
        ref_right_amount = menu.add_slider("Anti-Aim","Right amount", 0, 60),
        ref_roll_amount = menu.add_slider("Anti-Aim","Roll amount", 0, 50),
        ref_left_yaw = menu.add_slider("Anti-Aim","Left yaw", -90, 90),
        ref_right_yaw = menu.add_slider("Anti-Aim","Right yaw", -90, 90),
        ref_jitter_offset = menu.add_slider("Anti-Aim","Jitter offset", -180, 180),
    },

    c_fakelag = {
        fakelag_enable = menu.add_checkbox("Fake-Lag","Enabled"),
        fakelag_preset = menu.add_selection("Fake-Lag","Mode", fl_presets),
        fakelag_amount1 = menu.add_slider("Fake-Lag","Minimum", 1, 15),
        fakelag_amount2 = menu.add_slider("Fake-Lag","Maximum ", 1, 15),
    },

    c_finds = {
        doubletap = menu.find("aimbot", "general", "exploits", "doubletap", "enable"), --exploits
        hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable"), --exploits
        body_lean_resolver = menu.find("aimbot", "general", "aimbot", "body lean resolver"), --aimbot
        override_resolver = menu.find("aimbot", "general", "aimbot", "override resolver"), --aimbot
        auto_peek = menu.find("aimbot", "general", "misc", "autopeek"), --aimbot
        ping_override = menu.find("aimbot", "general", "fake ping", "enable"), --aimbot
        freestanding_override = menu.find("antiaim", "main", "auto direction", "enable"), --antiaim
        force_prediction = menu.find("aimbot", "general", "exploits", "force prediction"), --aimbot
        extended_angles = menu.find("antiaim", "main", "extended angles", "enable"), --antiaim
        fake_duck = menu.find("antiaim", "main", "general", "fake duck"), --antiaim
        slow_walk = menu.find("misc", "main", "movement", "slow walk"), --misc
        sneak = menu.find("misc", "main", "movement", "sneak"), --misc
        pitch = menu.find("antiaim","main","angles","pitch"), --int, antiaim
        yawbase = menu.find("antiaim","main","angles","yaw base"), --int, antiaim
        yawadd = menu.find("antiaim","main","angles","yaw add"), --int, antiaim
        rotate = menu.find("antiaim","main","angles","rotate"), --bool, antiaim
        rotate_range = menu.find("antiaim","main","angles","rotate range"), --int, antiaim
        rotate_speed = menu.find("antiaim","main","angles","rotate speed"), --int, antiaim
        jitter_mode = menu.find("antiaim","main","angles","jitter mode"), --int, antiaim
        jitter_add = menu.find("antiaim","main","angles","jitter add"), --int, antiaim
        body_lean = menu.find("antiaim","main","angles","body lean"), --int, antiaim
        body_lean_value = menu.find("antiaim","main","angles","body lean value"), --int, antiaim
        body_lean_jitter = menu.find("antiaim","main","angles","body lean jitter"), --int, antiaim
        moving_body_lean = menu.find("antiaim","main","angles","moving body lean"), --bool, antiaim
        stand_side = menu.find("antiaim","main","desync","stand","side"), --int, antiaim
        stand_left_amount = menu.find("antiaim","main","desync","stand","left amount"), --int, antiaim
        stand_right_amount = menu.find("antiaim","main","desync","stand","right amount"), --int, antiaim
        move_overide_stand = menu.find("antiaim","main","desync","move","override stand#move"), --bool, antiaim
        move_side = menu.find("antiaim","main","desync","move","side#move"), --int
        move_left_amount = menu.find("antiaim","main","desync","move","left amount#move"), --int, antiaim
        move_right_amount = menu.find("antiaim","main","desync","move","right amount#move"), --int, antiaim
        slowwalk_overide_stand = menu.find("antiaim","main","desync","slow walk","override stand#slow walk"), --bool, antiaim
        slowwalk_side = menu.find("antiaim","main","desync","slow walk","side#slow walk"), --int, antiaim
        slowwalk_default_side = menu.find("antiaim","main","desync","slow walk","default side"), --int, antiaim
        slowwalk_left_amount = menu.find("antiaim","main","desync","slow walk","left amount#slow walk"), --int, antiaim
        slowwalk_right_amount = menu.find("antiaim","main","desync","slow walk","right amount#slow walk"), --int, antiaim
        anti_bruteforce = menu.find("antiaim","main","desync","anti bruteforce"), --bool, antiaim
        on_shot_side = menu.find("antiaim","main","desync","on shot"), --int, antiaim
        slidewalk = menu.find("antiaim", "main", "general", "leg slide"), --bool, antiaim
        fakelag_limit = menu.find("antiaim", "main", "fakelag", "amount"), --int, fakelag
        break_lag_compensation = menu.find("antiaim", "main", "fakelag", "break lag compensation"), --bool, fakelag
        thirdperson = menu.find("visuals", "other", "thirdperson", "enable"), --key, visuals
        invert_desync = menu.find("antiaim","main","manual","invert desync"), --key, antiaim
    },
}

c_cfg.table.c_binds = {
    ref_inverter_key = c_cfg.table.c_antiaim.ref_inverter:add_keybind("invert key"),
    ref_auto_peek_key = c_cfg.table.c_ragebot.ref_auto_peek:add_keybind("autopeek key"),
}


local switched = false
local yaw_add, yaw, invert, jittered, flucuated = 0, 0, false, false, false
local flucuate_amt = c_cfg.table.c_fakelag.fakelag_amount1:get() - 1
local jitter_flip, tickbase_shifting, fl, f, micromove_flip = false, false, 0, false, false;
local sway_time, sway_flip, real_flip, stopper = 0, false, false, false;

function adjustAngle(angle)
    if angle < 0 then
        angle = (90 + angle * (-1))
    elseif angle > 0 then
        angle = (90 - angle)
    end

    return angle
end

function handle_auto_peek(cmd, origin, pos, speed)
    if pos == nil or origin == nil then
        return
    end
    local vec2pos_x, vec2pos_y = pos.x - origin.x, pos.y - origin.y
    local angle2pos = math.atan2(vec2pos_y, vec2pos_x) * (180 / math.pi)
    local view = engine.get_view_angles()
    local viewyaw = view.y - 180
    local moveangle = (adjustAngle(angle2pos - viewyaw) + 90) * (math.pi / 180)
    cmd.move.x = math.cos(moveangle) * speed
    cmd.move.y = math.sin(moveangle) * speed
end

local auto_peek_enabled=false
local auto_peek_origin = nil
local auto_peek_shot = false
callbacks.add(e_callbacks.AIMBOT_SHOOT, function()
    if not auto_peek_enabled then return end
    auto_peek_shot=true
end)

callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    if not c_cfg.table.c_antiaim.ref_enable:get() then return end

    local local_player = entity_list.get_local_player()
    tickbase_shifting = c_cfg.table.c_finds.doubletap[2]:get() or c_cfg.table.c_finds.hideshots[2]:get()
    if cmd:has_button(e_cmd_buttons.ATTACK) then return end
    if cmd:has_button(e_cmd_buttons.USE) and not c_cfg.table.c_antiaim.ref_use_aa:get() then return end

    local velocity = local_player:get_prop("m_vecVelocity"):length()
    local inverted = c_cfg.table.c_antiaim.ref_inverter:get() and c_cfg.table.c_binds.ref_inverter_key:get()
    local movement_keys = not (cmd:has_button(e_cmd_buttons.MOVELEFT) or cmd:has_button(e_cmd_buttons.MOVERIGHT) or cmd:has_button(e_cmd_buttons.FORWARD) or cmd:has_button(e_cmd_buttons.BACK)) or c_cfg.table.c_finds.slow_walk[2]:get()
    if not cmd:has_button(e_cmd_buttons.USE) then
        cmd.viewangles.y = cmd.viewangles.y + 180 + (inverted and c_cfg.table.c_antiaim.ref_right_yaw:get() or -c_cfg.table.c_antiaim.ref_left_yaw:get())
        cmd.viewangles.y = cmd.viewangles.y + c_cfg.table.c_antiaim.ref_jitter_offset:get()*(jitter_flip and 1 or -1)
        cmd.viewangles.x = 89
    end
    local ticks = 14
    local should_invert = (not fake_desync and c_cfg.table.c_antiaim.ref_sway_desync:get()) and real_flip or (not inverted)
    if engine.get_choked_commands() == (tickbase_shifting and 1 or ticks+1) and c_cfg.table.c_antiaim.ref_roll:get() and movement_keys and not auto_peek_enabled then
        cmd.viewangles.z = c_cfg.table.c_antiaim.ref_roll_amount:get() * (should_invert and 1 or -1)
    end
    if engine.get_choked_commands() == (tickbase_shifting and 0 or ticks-1) then
        --// desync real feet
        if not fake_desync and c_cfg.table.c_antiaim.ref_sway_desync:get() then
            cmd.viewangles.y = cmd.viewangles.y - (c_cfg.table.c_antiaim.ref_left_amount:get() * 2)*(real_flip and 1 or -1)
        else
            cmd.viewangles.y = cmd.viewangles.y - (c_cfg.table.c_antiaim.ref_left_amount:get() * 2)*(inverted and -1 or 1)
        end
        jitter_flip = not jitter_flip
    end
    if engine.get_choked_commands() < ticks-1 or tickbase_shifting  then
        if not tickbase_shifting then
            --// opposite aa
            local fake_desync = c_cfg.table.c_antiaim.ref_fake_desync:get()
            if not fake_desync and c_cfg.table.c_antiaim.ref_sway_desync:get() then
                --ref_sway_desync_both
                if (global_vars.cur_time()-sway_time) > .55 and not stopper then
                    real_flip = not real_flip
                    stopper=true
                end
                if (global_vars.cur_time()-sway_time) > 1.1 then
                    sway_flip = not sway_flip
                    stopper = false
                    sway_time=global_vars.cur_time()
                end
                cmd.viewangles.y = cmd.viewangles.y + 120*(sway_flip and -1 or 1)
            else
                cmd.viewangles.y = cmd.viewangles.y + ((c_cfg.table.c_antiaim.ref_right_amount:get() * 2)*(inverted and -1 or 1))*(fake_desync and -1 or 1)
            end
        end
        if cmd.move.y == 0 and cmd.move.x == 0 then
            micromove_flip = not micromove_flip
            cmd.move.y = micromove_flip and -1.25 or 1.25
        end
    end
    if c_cfg.table.c_ragebot.ref_auto_peek:get() and c_cfg.table.c_binds.ref_auto_peek_key:get() and not auto_peek_enabled then
        auto_peek_origin = local_player:get_eye_position()
        auto_peek_origin.z = local_player:get_hitbox_pos(e_hitboxes.LEFT_FOOT).z - 4
        auto_peek_enabled=true
    end
    if not auto_peek_enabled then
        auto_peek_shot=false
        auto_peek_origin=nil
    end
    local pos = local_player:get_eye_position()
    if auto_peek_origin and  c_cfg.table.c_ragebot.ref_auto_peek:get() and c_cfg.table.c_binds.ref_auto_peek_key:get() and ((math.abs(cmd.move.x) < 3 and (math.abs(cmd.move.y) < 3) or auto_peek_shot))  then
        if math.abs(auto_peek_origin.x - pos.x) < 1 and math.abs(auto_peek_origin.y - pos.y) < 1 then auto_peek_shot = false end
        handle_auto_peek(cmd,auto_peek_origin,local_player:get_prop("m_vecOrigin"),-800)
        auto_peek_move = true
    end
    auto_peek_enabled =  c_cfg.table.c_ragebot.ref_auto_peek:get() and c_cfg.table.c_binds.ref_auto_peek_key:get() 
end)
callbacks.add(e_callbacks.ANTIAIM, function(ctx, cmd)
    local ticks = 15
    if cmd:has_button(e_cmd_buttons.ATTACK) then ctx:set_fakelag(false) return end
    if not tickbase_shifting then
    ctx:set_fakelag(fl < ticks)
    if fl < ticks then fl = fl + 1 else fl = 0 end
    end
    if c_cfg.table.c_antiaim.ref_enable:get() then
        local choked = engine.get_choked_commands()
        local offset = c_cfg.table.c_antiaim.ref_jitter_offset:get()
        local side = c_cfg.table.c_finds.invert_desync[2]:get() and (invert and -1 or 1) or (invert and 1 or -1)
        local jitter = offset/2 * side


        c_cfg.table.c_finds.anti_bruteforce:set(c_cfg.table.c_antiaim.ref_anti_bruteforce:get())
        c_cfg.table.c_finds.on_shot_side:set(c_cfg.table.c_antiaim.ref_onshot:get())
    end

    if c_cfg.table.c_fakelag.fakelag_enable:get() then
        if c_cfg.table.c_fakelag.fakelag_preset:get() == 1 then --Static
            c_cfg.table.c_finds.fakelag_limit:set(c_cfg.table.c_fakelag.fakelag_amount1:get())
        end

        if c_cfg.table.c_fakelag.fakelag_preset:get() == 2 then --Fluctuate
            if flucuated == false then
                flucuate_amt = flucuate_amt + 1
            else
                flucuate_amt = flucuate_amt - 1
            end

            if flucuate_amt < c_cfg.table.c_fakelag.fakelag_amount1:get() then
                flucuated = false
            end

            if flucuate_amt > c_cfg.table.c_fakelag.fakelag_amount2:get() then
                flucuated = true
            end

            c_cfg.table.c_finds.fakelag_limit:set(clamp(flucuate_amt, c_cfg.table.c_fakelag.fakelag_amount1:get(), c_cfg.table.c_fakelag.fakelag_amount2:get()))
        end

        if c_cfg.table.c_fakelag.fakelag_preset:get() == 3 then --Random
            c_cfg.table.c_finds.fakelag_limit:set(client.random_int(c_cfg.table.c_fakelag.fakelag_amount1:get(), c_cfg.table.c_fakelag.fakelag_amount2:get()))
        end

        if c_cfg.table.c_fakelag.fakelag_preset:get() == 4 then --Jitter
            if not jittered then
                c_cfg.table.c_finds.fakelag_limit:set(c_cfg.table.c_fakelag.fakelag_amount1:get())
                jittered = true
            else
                c_cfg.table.c_finds.fakelag_limit:set(c_cfg.table.c_fakelag.fakelag_amount2:get())
                jittered = false
            end
        end
    end
end)

local enable = menu.add_checkbox("auto peek", "enable autopeek circle", false)
local colour = enable:add_color_picker("color")

callbacks.add(e_callbacks.PAINT, function()
    if not enable:get() or not engine.is_in_game() then 
    return
end

if auto_peek_origin ~= nil then
    local ap_origin = ragebot.get_autopeek_pos()

    debug_overlay.add_sphere(auto_peek_origin, 10, 6, 3, colour:get(), 0.02)
end
end)