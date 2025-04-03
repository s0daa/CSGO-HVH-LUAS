--Menu Add
AAMenu = menu.add_selection("AntiAim","Main AA select",{"Jitter","Static","Custom","None"})

AA_Jitter_Real = menu.add_selection("AntiAim", "Custom Real Jitter",{"OFF","Static", "Centered"})
AA_jitter_real_center = menu.add_slider("AntiAim", "Custom AA centered jitter", 0, 180)
AA_jitter_real_val = menu.add_slider("AntiAim", "Custom AA add yaw", -180, 180)
AA_jitter_static_val_r = menu.add_slider("AntiAim", "Custom AA add yaw", -180, 180)
AA_jitter_static_val_l = menu.add_slider("AntiAim", "Custom AA add yaw", -180, 180)
AA_Jitter_R = menu.add_slider("AntiAim", "Custom AA add yaw right", -180, 180)
AA_Jitter_L = menu.add_slider("AntiAim", "Custom AA add yaw left", -180, 180)
AA_Jitter__ = menu.add_selection("AntiAim", "Custom Fake Jitter",{"OFF","Static", "Centered"})
AA_Jitter_direction_l = menu.add_slider("AntiAim", "Custom AA jitter add right", -180, 180)
AA_Jitter_direction_r = menu.add_slider("AntiAim", "Custom AA jitter add left", -180, 180)
AA_jitter_center = menu.add_slider("AntiAim", "Custom Fake centered jitter", 0, 180)
Llimit_stand_ = menu.add_slider("AntiAim", "Custom AA left stand limit", 0, 100)
Rlimit_stand_ = menu.add_slider("AntiAim", "Custom AA right stand limit", 0, 100)
Llimit_move_ = menu.add_slider("AntiAim", "Custom AA left move limit", 0, 100)
Rlimit_move_ = menu.add_slider("AntiAim", "Custom AA right move limit", 0, 100)
Llimit_slow_ = menu.add_slider("AntiAim", "Custom AA left slow walk limit", 0, 100)
Rlimit_slow_ = menu.add_slider("AntiAim", "Custom AA right slow walk limit", 0, 100)

AA_jitter_real_val:set_visible(false)
AA_Jitter_Real:set_visible(false)
AA_Jitter_R:set_visible(false)
AA_Jitter_L:set_visible(false)
AA_Jitter__:set_visible(false)
AA_Jitter_direction_l:set_visible(false)
AA_Jitter_direction_r:set_visible(false)
AA_jitter_center:set_visible(false)
Llimit_stand_:set_visible(false)
Rlimit_stand_:set_visible(false)
Llimit_move_:set_visible(false)
Rlimit_move_:set_visible(false)
Llimit_slow_:set_visible(false)
Rlimit_slow_:set_visible(false)
AA_jitter_real_center:set_visible(false)
AA_jitter_static_val_r:set_visible(false)
AA_jitter_static_val_l:set_visible(false)

VisualsMenu = menu.add_selection("Visuals","Main Visuals select",{"1","None"})
--MenuFind (Angles)
AA_Pitch = menu.find("antiaim","main", "angles","pitch")
AA_YawBase = menu.find("antiaim","main", "angles","yaw base")
AA_yawAdd = menu.find("antiaim","main", "angles","yaw add")
AA_Rotate = menu.find("antiaim","main", "angles","rotate")
AA_Jitter = menu.find("antiaim","main", "angles","jitter mode")
AA_Jitter_Add = menu.find("antiaim","main", "angles","jitter add")
AA_Inverter = menu.find("antiaim","main", "manual","invert desync")
AA_BodyLean = menu.find("antiaim","main", "angles","body lead")
AA_BodyLean_value = menu.find("antiaim","main", "angles","body lead value")
AA_BodyLean_Jitter = menu.find("antiaim","main", "angles","body lead jitter")

--MenuFind (Desync/Stand)
side_stand = menu.find("antiaim","main", "desync","side#stand")
llimit_stand = menu.find("antiaim","main", "desync","left amount#stand")
rlimit_stand = menu.find("antiaim","main", "desync","right amount#stand")
--MenuFind (Desync/Move)
Ovveride_move = menu.find("antiaim","main", "desync","override stand#move")
side_move = menu.find("antiaim","main", "desync","side#move")
llimit_move = menu.find("antiaim","main", "desync","left amount#move")
rlimit_move = menu.find("antiaim","main", "desync","right amount#move")
--MenuFind (Desync/Slowwalk)
Ovveride_SlowWalk = menu.find("antiaim","main", "desync","override stand#slow walk")
side_SlowWalk = menu.find("antiaim","main", "desync","side#slow walk")
llimit_SlowWalk = menu.find("antiaim","main", "desync","left amount#slow walk")
rlimit_SlowWalk = menu.find("antiaim","main", "desync","right amount#slow walk")
--MenuFind (Anti Bruteforce)
AntiBrute = menu.find("antiaim","main", "desync","anti bruteforce")
AntiBruteVel = menu.find("antiaim","main", "desync","on shot")
--MenuFind (Ragebot)
dt_on = menu.find("aimbot","general","exploits","doubletap","enable")
hs_on = menu.find("aimbot","general","exploits","hideshots","enable")
Visuals_ScoutDMG = menu.find("aimbot","scout","target overrides","force min. damage")
Visuals_AutoDMG = menu.find("aimbot","auto","target overrides","force min. damage")
Visuals_AWPDMG = menu.find("aimbot","awp","target overrides","force min. damage")
Visuals_DeagleDMG = menu.find("aimbot","deagle","target overrides","force min. damage")
Visuals_RevolverDMG = menu.find("aimbot","revolver","target overrides","force min. damage")
Visuals_pistolDMG = menu.find("aimbot","pistols","target overrides","force min. damage")
Visuals_otherDMG = menu.find("aimbot","other","target overrides","force min. damage")

local default_font = render.get_default_font()
if engine.is_connected() then local local_player = entity_list.get_local_player() end
local local_player = entity_list.get_local_player()
local screen_size = render.get_screen_size()
local player_states = {
    crouching          = false,
    standing           = false,
    jumping            = false,
    running            = false,
    pressing_move_keys = false
}

local font_inds      = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE) -- font
local x, y           = screen_size.x / 2, screen_size.y / 2
local text_size      = render.get_text_size(font_inds, "primordial")
local text_size2     = render.get_text_size(font_inds, "lethal")
local current_state  = "primordial"
local ind_offset     = 0



function AintiAim_AAMain()
    MainAASet = AAMenu:get()

    if MainAASet == (1) then
        AA_Rotate:set(false)
        AA_Jitter:set(2)
        AntiBruteVel:set(4)
        AA_Pitch:set(2)

        AA_jitter_real_center:set_visible(false)
        AA_Jitter_Real:set_visible(false)
        AA_Jitter_R:set_visible(false)
        AA_Jitter_L:set_visible(false)
        AA_Jitter__:set_visible(false)
        AA_Jitter_direction_l:set_visible(false)
        AA_Jitter_direction_r:set_visible(false)
        AA_jitter_center:set_visible(false)
        Llimit_stand_:set_visible(false)
        Rlimit_stand_:set_visible(false)
        Llimit_move_:set_visible(false)
        Rlimit_move_:set_visible(false)
        Llimit_slow_:set_visible(false)
        Rlimit_slow_:set_visible(false)
        AA_jitter_static_val_r:set_visible(false)
        AA_jitter_static_val_l:set_visible(false)

        --move
        Ovveride_move:set(true)
        --slowwalk
        Ovveride_SlowWalk:set(true)

        if math.random(0,1) == 0 then
            --left
            side_stand:set(2)
            AA_yawAdd:set(3)
            llimit_stand:set(40)
            AA_Jitter_Add:set(-23)

            --move
            side_move:set(2)
            llimit_move:set(30)

            --slowwalk
            side_SlowWalk:set(2)
            llimit_SlowWalk:set(50)
            else --right
            side_stand:set(3)
            AA_yawAdd:set(-5)
            rlimit_stand:set(50)  
            AA_Jitter_Add:set(8)

            --move
            side_move:set(3)   
            rlimit_move:set(30)

            --slowwalk
            side_SlowWalk:set(3)
            rlimit_SlowWalk:set(50)
            end
    elseif MainAASet == (2) then
        AA_Rotate:set(false)
        AA_Jitter:set(0)
        AA_Pitch:set(2)
        AA_Jitter_Add:set(0)

        AA_jitter_real_center:set_visible(false)
        AA_Jitter_Real:set_visible(false)
        AA_Jitter_R:set_visible(false)
        AA_Jitter_L:set_visible(false)
        AA_Jitter__:set_visible(false)
        AA_Jitter_direction_l:set_visible(false)
        AA_Jitter_direction_r:set_visible(false)
        AA_jitter_center:set_visible(false)
        Llimit_stand_:set_visible(false)
        Rlimit_stand_:set_visible(false)
        Llimit_move_:set_visible(false)
        Rlimit_move_:set_visible(false)
        Llimit_slow_:set_visible(false)
        Rlimit_slow_:set_visible(false)

        if math.random(0,1) == 0 then
            AA_yawAdd:set(11)
            side_stand:set(2)
            side_move:set(2)
            side_SlowWalk:set(2)
            llimit_stand:set(40)
            llimit_move:set(30)
            llimit_SlowWalk:set(50)
        else
            AA_yawAdd:set(-11)
            side_stand:set(3)
            side_move:set(3)   
            side_SlowWalk:set(3)
            rlimit_stand:set(50)  
            rlimit_move:set(30)
            rlimit_SlowWalk:set(50)
        end
    elseif MainAASet == (3) then
        AA_Rotate:set(false)
        AA_Pitch:set(2)
        
        AA_jitter_real_center:set_visible(false)
        AA_Jitter_Real:set_visible(true)
        AA_Jitter_R:set_visible(false)
        AA_Jitter_L:set_visible(false)
        AA_Jitter__:set_visible(true)        
        Llimit_stand_:set_visible(true)
        Rlimit_stand_:set_visible(true)
        Llimit_move_:set_visible(true)
        Rlimit_move_:set_visible(true)
        Llimit_slow_:set_visible(true)
        Rlimit_slow_:set_visible(true)

        local test_jitter_r = AA_Jitter_R:get()
        local test_jitter_l = AA_Jitter_L:get()
        local test_Llimit_move_ = Llimit_move_:get()
        local test_Rlimit_move_ = Rlimit_move_:get()
        local test_Llimit_slow_ = Llimit_slow_:get()
        local test_Rlimit_slow_ = Rlimit_slow_:get()
        local test_Llimit_stand_ = Llimit_stand_:get()
        local test_Rlimit_stand_ = Rlimit_stand_:get()
        local test_jitter = AA_Jitter__:get()
        local test_AA_Jitter_direction_l = AA_Jitter_direction_l:get()
        local test_AA_Jitter_direction_r = AA_Jitter_direction_r:get()
        local test_aa_center = AA_jitter_center:get()
        local test_aa_jitter_real = AA_Jitter_Real:get()
        local test_aa_jitter_real_val = AA_jitter_real_val:get()
        local test_aa_jitter_center_real = AA_jitter_real_center:get()
        local test_AA_jitter_static_val_r = AA_jitter_static_val_r:get()
        local test_AA_jitter_static_val_l = AA_jitter_static_val_l:get()

        if test_aa_jitter_real == (1) then
            AA_jitter_real_val:set_visible(true)
            AA_jitter_real_center:set_visible(false)
            AA_jitter_static_val_r:set_visible(false)
            AA_jitter_static_val_l:set_visible(false)
            AA_yawAdd:set(test_aa_jitter_real_val)
        elseif test_aa_jitter_real == (2) then
            AA_jitter_static_val_r:set_visible(true)
            AA_jitter_static_val_l:set_visible(true)
            AA_jitter_real_val:set_visible(false)
            if math.random(0,1) == 0 then
                AA_yawAdd:set(test_AA_jitter_static_val_r)
            else
                AA_yawAdd:set(test_AA_jitter_static_val_l)
            end
        elseif test_aa_jitter_real == (3) then
            AA_jitter_real_val:set_visible(false)
            AA_jitter_real_center:set_visible(true)
            AA_jitter_static_val_r:set_visible(false)
            AA_jitter_static_val_l:set_visible(false)
            if math.random(0,1) == 0 then
                AA_yawAdd:set(test_aa_jitter_center_real)
            else
                AA_yawAdd:set(test_aa_jitter_center_real *-1)
            end
        end


        if test_jitter == (1) then
            AA_Jitter:set(0)
            AA_Jitter_direction_l:set_visible(false)
            AA_Jitter_direction_r:set_visible(false)  
            AA_jitter_center:set_visible(false)  
            
            if math.random(0,1) == 0 then
                AA_Jitter_Add:set(test_jitter_r)
                side_stand:set(1)
                side_move:set(1)
                side_SlowWalk:set(1)
                rlimit_move:set(test_Rlimit_move_)
                rlimit_SlowWalk:set(test_Rlimit_slow_)
                rlimit_stand:set(test_Rlimit_stand_)   
                else
                AA_Jitter_Add:set(test_jitter_l)
                side_stand:set(2)
                side_move:set(2)
                side_SlowWalk:set(2)
                llimit_move:set(test_Llimit_move_)
                llimit_SlowWalk:set(test_Llimit_slow_)
                llimit_stand:set(test_Llimit_stand_)
                end
        elseif test_jitter == (2) then
            AA_Jitter:set(2)
            AA_Jitter_direction_l:set_visible(true)
            AA_Jitter_direction_r:set_visible(true)  
            AA_jitter_center:set_visible(false)
            rlimit_move:set(test_Rlimit_move_)
            rlimit_SlowWalk:set(test_Rlimit_slow_)
            rlimit_stand:set(test_Rlimit_stand_)   
            llimit_move:set(test_Llimit_move_)
            llimit_SlowWalk:set(test_Llimit_slow_)
            llimit_stand:set(test_Llimit_stand_)
            if math.random(0,1) == 0 then
                AA_Jitter_Add:set(test_jitter_r)
                AA_Jitter_Add:set(test_AA_Jitter_direction_r)
            else
                AA_Jitter_Add:set(test_jitter_l)
                AA_Jitter_Add:set(test_AA_Jitter_direction_l)
            end 
        elseif test_jitter == (3) then
            AA_Jitter_direction_l:set_visible(false)
            AA_Jitter_R:set_visible(false)
            AA_Jitter_L:set_visible(false)
            AA_Jitter_direction_r:set_visible(false)  
            AA_jitter_center:set_visible(true)
            rlimit_move:set(test_Rlimit_move_)
            rlimit_SlowWalk:set(test_Rlimit_slow_)
            rlimit_stand:set(test_Rlimit_stand_)   
            llimit_move:set(test_Llimit_move_)
            llimit_SlowWalk:set(test_Llimit_slow_)
            llimit_stand:set(test_Llimit_stand_)
            AA_Jitter_Add:set(0)
            AA_Jitter:set(0)
            if math.random(0,1) == 0 then 
            AA_Jitter_Add:set(test_aa_center)
            side_move:set(1)
            side_SlowWalk:set(1)
            side_stand:set(1)
            else
            AA_Jitter_Add:set(test_aa_center *-1)
            side_move:set(2)
            side_SlowWalk:set(2)
            side_stand:set(2)
            end
               
        end

    else
        AA_jitter_real_val:set_visible(false)
        AA_Jitter_Real:set_visible(false)
        AA_Jitter_R:set_visible(false)
        AA_Jitter_L:set_visible(false)
        AA_Jitter__:set_visible(false)
        AA_Jitter_direction_l:set_visible(false)
        AA_Jitter_direction_r:set_visible(false)
        AA_jitter_center:set_visible(false)
        Llimit_stand_:set_visible(false)
        Rlimit_stand_:set_visible(false)
        Llimit_move_:set_visible(false)
        Rlimit_move_:set_visible(false)
        Llimit_slow_:set_visible(false)
        Rlimit_slow_:set_visible(false)
        AA_jitter_real_center:set_visible(false)
        AA_jitter_static_val_r:set_visible(false)
        AA_jitter_static_val_l:set_visible(false)

        AA_Rotate:set(false)
        AA_Jitter:set(0)
        AntiBruteVel:set(0)
        AA_yawAdd:set(0)
        side_stand:set(0)
        side_move:set(0)   
        side_SlowWalk:set(0)   
        llimit_stand:set(0)
        llimit_move:set(0)
        llimit_SlowWalk:set(0)
        rlimit_stand:set(0)  
        rlimit_move:set(0)
        rlimit_SlowWalk:set(0)
        AA_Jitter_Add:set(0) 
    end
end


local function on_paint()
    if not engine.is_connected() then return end if not engine.is_in_game() then return end if local_player:get_prop("m_iHealth") < 1 then return end

    MainVisualsSet = VisualsMenu:get()
    if MainVisualsSet == (1) then
            render.text(font_inds,"SALAZAR.LUA",vec2_t(x - 32,y + 15),color_t(255,255,255))
            render.line(vec2_t(x - 35, y + 28), vec2_t(x + 35, y + 28), color_t(255,255,255))
            if player_states.jumping then
                current_state = "*jump"
            elseif player_states.standing then
                current_state = "*standing"        
            elseif not player_states.standing and not player_states.jumping and not player_states.crouching then
                current_state = "*walk"        
            elseif player_states.crouching then
                current_state = "*duck"
            end                  
            render.text(font_inds, current_state, vec2_t(x + 1, y + 38),color_t(255,255,255), true)

            render.line(vec2_t(x - 35, y + 43), vec2_t(x + 35, y + 43), color_t(255,255,255))

            if dt_on[2]:get() then
                if exploits.get_charge() < 1 then
                    render.text(default_font, "DT", vec2_t(x - 20, y + 53), color_t(255, 0, 0), true)
                    ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
                else
                    render.text(default_font, "DT", vec2_t(x - 20, y + 53), color_t(255,255,255), true)
                    ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
                end
            end
            
            if hs_on[2]:get() and not dt_on[2]:get() then
                if exploits.get_charge() < 1 then
                    render.text(default_font, "HS", vec2_t(x - 19, y + 53), color_t(255, 0, 0), true)
                    ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 5
                else
                    render.text(default_font, "HS", vec2_t(x - 19, y + 53), color_t(255,255,255), true)
                    ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 5
                end             
            end
            if Visuals_otherDMG[2]:get() or Visuals_pistolDMG[2]:get() or Visuals_RevolverDMG[2]:get() or Visuals_ScoutDMG[2]:get() or Visuals_AutoDMG[2]:get() or Visuals_DeagleDMG[2]:get() or Visuals_AWPDMG[2]:get() then
            render.text(default_font, "DMG", vec2_t(x + 4, y + 53), color_t(255,255,255), true)
            end
    end

end

local function on_shutdown()
    AA_Rotate:set(false)
    AA_Jitter:set(0)
    AntiBruteVel:set(0)
    AA_yawAdd:set(0)
    side_stand:set(0)
    side_move:set(0)   
    side_SlowWalk:set(0)   
    llimit_stand:set(0)
    llimit_move:set(0)
    llimit_SlowWalk:set(0)
    rlimit_stand:set(0)  
    rlimit_move:set(0)
    rlimit_SlowWalk:set(0)
    AA_Jitter_Add:set(0) 
end


callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.ANTIAIM, AintiAim_AAMain)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)



callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    local local_player = entity_list.get_local_player()
    player_states.pressing_move_keys = (cmd:has_button(e_cmd_buttons.MOVELEFT) or cmd:has_button(e_cmd_buttons.MOVERIGHT) or cmd:has_button(e_cmd_buttons.FORWARD) or cmd:has_button(e_cmd_buttons.BACK))

    if (not local_player:has_player_flag(e_player_flags.ON_GROUND)) or (local_player:has_player_flag(e_player_flags.ON_GROUND) and cmd:has_button(e_cmd_buttons.JUMP)) then
        player_states.jumping = true
    else
        player_states.jumping = false
    end
    if player_states.pressing_move_keys then
        if not player_states.jumping then
            if cmd:has_button(e_cmd_buttons.DUCK) then
                player_states.crouching = true
                player_states.running = false
            else
                player_states.running = true
                player_states.crouching = false
            end
        elseif player_states.jumping and not cmd:has_button(e_cmd_buttons.JUMP) then
            player_states.running = false
            player_states.crouching = false
        end

        player_states.standing = false
    elseif not player_states.pressing_move_keys then
        if not player_states.jumping then
            if cmd:has_button(e_cmd_buttons.DUCK) then
                player_states.crouching = true
                player_states.standing = false
            else
                player_states.standing = true
                player_states.crouching = false
            end
        else
            player_states.standing = false
            player_states.crouching = false
        end        
        player_states.running = false
    end
end)