local pixelsmall = render.create_font("Smallest Pixel-7", 19, 1000, e_font_flags.OUTLINE)
local csansms = render.create_font("Comic Sans MS", 14, 300, e_font_flags.OUTLINE)
local arielfont = render.create_font("Ariel", 17, 300, e_font_flags.OUTLINE)
local verd = render.create_font("Verdana", 17, 300, e_font_flags.OUTLINE)
local csansms_b = render.create_font("Comic Sans MS", 17, 300, e_font_flags.OUTLINE)
local csansms_wm = render.create_font("Comic Sans MS", 21, 300, e_font_flags.OUTLINE)
--important stuff
screensize = render.get_screen_size()
jitter_ammount = menu.find("antiaim","main","angles","jitter add")
yaw_add = menu.find("antiaim","main","angles","yaw add")
jittermode = menu.find("antiaim","main","angles","jitter mode")
desync_side = menu.find("antiaim","main","desync","stand","side")
d_left = menu.find("antiaim","main","desync","stand","left ammount")
d_right = menu.find("antiaim","main","desync","stand","right ammount")
abf = menu.find("antiaim","main","desync","stand","anti bruteforce")
pitch = menu.find("antiaim","main","angles","pitch")

--menu stuff
local visualstext = menu.add_text("Main","MAIN")
local seperator_vis = menu.add_text("Main","----------------------------------------")
local clantag_box = menu.add_checkbox("Main","Clantag", false)
local clantag_speed = menu.add_slider("Main","Clantag Speed",2, 50)
local visualstext = menu.add_text("Main","VISUALS")
local seperator_vis = menu.add_text("Main","----------------------------------------")
local themetext = menu.add_text("Main","Theme Color")
local visual_ind_check = menu.add_checkbox("Main", "Crosshair Text", true)
local theme_color = themetext:add_color_picker("Indicator Color")
local aa_check_box = menu.add_checkbox("AntiAim","Toggle AA",false)
local speed_delay_box = menu.add_checkbox("AntiAim","Speed = Delay (SOON)",false)
local jitterspeed = menu.add_slider("AntiAim","JitterSpeed (Tick Delay)",2,64)
local jitterspeedr = menu.add_slider("AntiAim","JitterSpeed Randomizer",0,32)
local jitterangle_l = menu.add_slider("AntiAim","Jitter Angle Left",-180,180)
local jitterangle_r = menu.add_slider("AntiAim","Jitter Angle Right",-180,180)
local aa_jitter_angle = menu.add_slider("AntiAim"," Angle Randomizer",-20,20)
local side_indicators = menu.add_checkbox("Main","Side Indicators",false)
local watermark_box = menu.add_checkbox("Main","Watermark",false)
local watermark_box2 = menu.add_checkbox("Main","Watermark 2",false)
local anim_checkbox = menu.add_checkbox("AnimLayers","Enable Anim Layer Customization", false)
local movement_layer = menu.add_slider("AnimLayers","Move",-100,100)
local weapon_a_layer = menu.add_slider("AnimLayers","Weapon Action",-100,100)
local jump_or_fall_layer = menu.add_slider("AnimLayers","Jump Or Fall",-100,100)
local land_oc_layer = menu.add_slider("AnimLayers","Land Or Climb",-100,100)
local strafe_c_layer = menu.add_slider("AnimLayers","StrafeChange",-100,100)
local whole_b_layer = menu.add_slider("AnimLayers","Whole Body",-100,100)
local flashed_layer = menu.add_slider("AnimLayers","Flashed",-100,100)
local flinch_layer = menu.add_slider("AnimLayers","Flinch",-100,100)
local alive_l_layer = menu.add_slider("AnimLayers","Alive Loop",-100,100)
local anim_m_layer = menu.add_slider("AnimLayers","Anim Matrix",-100,100)
local weapon_ar_layer = menu.add_slider("AnimLayers","Weapon Action Recrouch",-100,100)
local adjust_layer = menu.add_slider("AnimLayers","Adjust (??)",-100,100)
local lean_layer = menu.add_slider("AnimLayers","Lean",-100,100)
local run_layer = menu.add_slider("AnimLayers","Run",-100,100)

--6w aa
local aa_check_box_6w = menu.add_checkbox("6w","Toggle AA",false)
local jitterspeed_6w = menu.add_slider("6w","Is it working?",0,32)
local sixw_text_1 = menu.add_text("6w","Angle 1")
local jitter_angle_1 = menu.add_slider("6w","Jitter Angle 1",-180, 180)
local desync_side_1 = menu.add_list("6w", "Desync Side 1", {"none","Left", "Right"},3)
local jitter_delay_1 = menu.add_slider("6w","Jitter Delay Until 2",2, 32)
local sixw_text_2 = menu.add_text("6w","Angle 2")
local jitter_angle_2 = menu.add_slider("6w","Jitter Angle 2",-180, 180)
local desync_side_2 = menu.add_list("6w", "Desync Side 2", {"none","Left", "Right"},3)
local jitter_delay_2 = menu.add_slider("6w","Jitter Delay Until 3",2, 32)
local sixw_text_3 = menu.add_text("6w","Angle 3")
local jitter_angle_3 = menu.add_slider("6w","Jitter Angle 3",-180, 180)
local desync_side_3 = menu.add_list("6w", "Desync Side 3", {"none","Left", "Right"},3)
local jitter_delay_3 = menu.add_slider("6w","Jitter Delay Until 4",2, 32)
local sixw_text_4 = menu.add_text("6w","Angle 4")
local jitter_angle_4 = menu.add_slider("6w","Jitter Angle 4",-180, 180)
local desync_side_4 = menu.add_list("6w", "Desync Side 4", {"none","Left", "Right"},3)
local jitter_delay_4 = menu.add_slider("6w","Jitter Delay Until 5",2, 32)
local sixw_text_5 = menu.add_text("6w","Angle 5")
local jitter_angle_5 = menu.add_slider("6w","Jitter Angle 5",-180, 180)
local desync_side_5 = menu.add_list("6w", "Desync Side 5", {"none","Left", "Right"},3)
local jitter_delay_5 = menu.add_slider("6w","Jitter Delay Until 6",2, 32)
local sixw_text_6 = menu.add_text("6w","Angle 6")
local jitter_angle_6 = menu.add_slider("6w","Jitter Angle 6",-180, 180)
local desync_side_6 = menu.add_list("6w", "Desync Side 6", {"none","Left", "Right"},3)
local jitter_delay_6 = menu.add_slider("6w","Jitter Delay Until 1",2, 32)

    function get_velocity(player)
        if(player == nil) then return end
        local vec = player:get_prop("m_vecVelocity")
        local velocity = #vec
        return velocity
    end

--local player

local local_player = entity_list.get_local_player()

--indicator stuff
local function crosshairind()
    if not local_player then
        return
    end
    local dt = menu.find("aimbot", "general", "exploits", "doubletap", "enable")[2]
    local hs = menu.find("aimbot", "general", "exploits", "hideshots", "enable")[2]
    --min dmg override ammount
    local minovr_auto_a = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
    local minovr_scout_a = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
    local minovr_awp_a = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
    local minovr_r8_a = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
    local minovr_deag_a = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
    local minovr_pistol_a = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))
    --min dmg ammount
    local min_auto = menu.find("aimbot", "auto", "targeting", "min. damage")
    local min_scout = menu.find("aimbot", "scout", "targeting", "min. damage")
    local min_awp = menu.find("aimbot", "awp", "targeting", "min. damage")
    local min_r8 = menu.find("aimbot", "revolver", "targeting", "min. damage")
    local min_deag = menu.find("aimbot", "deagle", "targeting", "min. damage")
    local min_pistol = menu.find("aimbot", "pistols", "targeting", "min. damage")
    --is min dmg override on?
    local minovr_auto = menu.find("aimbot", "auto", "target overrides", "force min. damage")[2]
    local minovr_scout = menu.find("aimbot", "scout", "target overrides", "force min. damage")[2]
    local minovr_r8 = menu.find("aimbot", "revolver", "target overrides", "force min. damage")[2]
    local minovr_deag = menu.find("aimbot", "deagle", "target overrides", "force min. damage")[2]
    local minovr_pistol = menu.find("aimbot", "pistols", "target overrides", "force min. damage")[2]
    local minovr_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")[2]
    
    local current_weapon = local_player:get_active_weapon()
    
    if not current_weapon then return end
    
    local local_weapon = current_weapon:get_name()
    
    if visual_ind_check:get() == false then
        return
    end
        render.text(csansms_b, ("Team-Shlerp.lua"), vec2_t(screensize.x/2, screensize.y/2+screensize.y/90), theme_color:get(),true)
    if dt:get() then
         render.text(csansms, ("DT"), vec2_t(screensize.x/2, screensize.y/2+screensize.y/40), color_t(0,255,0), true)
    else   
        render.text(csansms, ("DT"), vec2_t(screensize.x/2, screensize.y/2+screensize.y/40), color_t(255,0,0), true)
    end
    if hs:get() then
        render.text(csansms, ("HS"), vec2_t(screensize.x/2, screensize.y/2+screensize.y/27), color_t(0,255,0), true)
    else   
       render.text(csansms, ("HS"), vec2_t(screensize.x/2, screensize.y/2+screensize.y/27), color_t(255,0,0), true)
    end
    if antiaim.is_fakeducking() == true then
    render.text(csansms, ("FD"), vec2_t(screensize.x/2-screensize.y/90, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
    end
    
    if local_weapon == "ssg08" and minovr_scout:get() == false then
        
        render.text(csansms, (tostring(min_scout:get())), vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
    
    else if local_weapon == "ssg08" and minovr_scout:get() == true then
      
        render.text(csansms, (tostring(minovr_scout_a:get())), vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
    
            end
        end
    
    if local_weapon == "revolver" and minovr_r8:get() == false then
    
        render.text(csansms, (tostring(min_r8:get())), vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
    
    else if local_weapon == "revolver" and minovr_r8:get() == true then
      
        render.text(csansms, (tostring(minovr_r8_a:get())), vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
    
            end
        end
    
        if local_weapon == "deagle" and minovr_deag:get() == false then
    
            render.text(csansms, (tostring(min_deag:get())), vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
        
        else if local_weapon == "deagle" and minovr_deag:get() == true then
          
            render.text(csansms, (tostring(minovr_deag_a:get())), vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
        
                end
            end    
    
            if local_weapon == "scar20" and minovr_auto:get() == false or local_weapon == "g3sg1" and minovr_auto:get() == false then
    
                render.text(csansms, (tostring(min_auto:get())), vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
            
            else if local_weapon == "scar20" and minovr_auto:get() == true or local_weapon == "g3sg1" and minovr_auto:get() == true then
              
                render.text(csansms, (tostring(minovr_auto_a:get())), vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
            
                    end
                end   
    
                if local_weapon == "awp" and minovr_awp:get() == false then
    
                    render.text(csansms, (tostring(min_awp:get())), vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
                
                else if local_weapon == "awp" and minovr_awp:get() == true then
                  
                    render.text(csansms, (tostring(minovr_awp_a:get())), vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
                
                        end
                    end    
    
                    if local_weapon == "usp-s" and minovr_pistol:get() == false or local_weapon == "elite" and minovr_pistol:get() == false or local_weapon == "p250" and minovr_pistol:get() == false or local_weapon == "fiveseven" and minovr_pistol:get() == false or local_weapon == "glock" and minovr_pistol:get() == false or local_weapon == "tec9" and minovr_pistol:get() == false then
    
                        render.text(csansms, (tostring(min_pistol:get())), vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
                    
                    else if local_weapon == "usp-s" and minovr_pistol:get() == true or local_weapon == "elite" and minovr_pistol:get() == true or local_weapon == "p250" and minovr_pistol:get() == true or local_weapon == "fiveseven" and minovr_pistol:get() == true or local_weapon == "glock" and minovr_pistol:get() == true or local_weapon == "tec9" and minovr_pistol:get() == true then
                      
                        render.text(csansms, (tostring(minovr_pistol_a:get())), vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
                    
                            end
                        end  
                        
                        if local_weapon == "knife" then
                            render.text(csansms, "0", vec2_t(screensize.x/2+screensize.x/130, screensize.y/2-screensize.y/130), color_t(220,220,220), true)
    
                            end   
    
    
    
    --end of function
    end
    callbacks.add(e_callbacks.PAINT, crosshairind)


--antiaim stuff

function random_angle()
 if aa_check_box:get() == false then
   return
 end
 
    jittermode:set(3)
    jitter_ammount:set(aa_jitter_angle:get())
end

callbacks.add(e_callbacks.ANTIAIM, random_angle)


--side indicators




function side_ind_func()
    if side_indicators:get() == false then
        return
    end
desync = antiaim.get_max_desync_range()
    render.rect_fade(vec2_t(-20, screensize.y/2-20), vec2_t(150, 35), color_t(100,100,100,100), color_t(0,0,0,0),true)
    render.text(csansms_b, ">> Shlerp.lua", vec2_t(0+5, screensize.y/2-20) ,theme_color:get())
    render.text(csansms_b, ">>     desync", vec2_t(0+5, screensize.y/2-3) ,theme_color:get())
    render.text(csansms_b, tostring(desync), vec2_t(0+17, screensize.y/2-3) ,theme_color:get())
end

callbacks.add(e_callbacks.PAINT,side_ind_func)
--top g aa stuff


local oldtick = globals.tick_count() + 20

local side = true
--jitter speed
function jitterspeed_func()
if aa_check_box:get() == false then
    return
end

if oldtick <= globals.tick_count() then

    --jitter angle
if side == true then
    yaw_add:set(jitterangle_l:get())
    desync_side:set(3)
    side = false
elseif side == false then
    yaw_add:set(jitterangle_r:get())
    desync_side:set(2)
    side = true
end

local local_player = entity_list.get_local_player()

if speed_delay_box:get() == false then
    oldtick = globals.tick_count() + jitterspeed:get() + math.random(jitterspeed:get()-jitterspeedr:get(),jitterspeed:get()+jitterspeedr:get())
else
    oldtick = globals.tick_count() + get_velocity(local_player)+2
end
end
end

callbacks.add(e_callbacks.NET_UPDATE,jitterspeed_func)


local one = true
local two = false
local three = false
local four = false
local five = false
local six = false

--jitter speed
function jitterspeed_func6w()
if aa_check_box_6w:get() == false then
    return
end

if oldtick <= globals.tick_count() then

    --jitter angle
if one == true then
    yaw_add:set(jitter_angle_1:get())
    desync_side:set(desync_side_1:get())
    one = false
    jitterspeed_6w:set(jitter_delay_1:get())
    two = true
else if two == true then
    yaw_add:set(jitter_angle_2:get())
    desync_side:set(desync_side_2:get())
    two = false
    jitterspeed_6w:set(jitter_delay_2:get())
    three = true
else if three == true then
    yaw_add:set(jitter_angle_3:get())
    desync_side:set(desync_side_3:get())
    three = false
    jitterspeed_6w:set(jitter_delay_3:get())
    four = true
else if four == true then
    yaw_add:set(jitter_angle_4:get())
    desync_side:set(desync_side_4:get())
    four = false
    jitterspeed_6w:set(jitter_delay_4:get())
    five = true
else if five == true then
    yaw_add:set(jitter_angle_5:get())
    desync_side:set(desync_side_5:get())
    five = false
    jitterspeed_6w:set(jitter_delay_5:get())
    six = true
else if six == true then
    yaw_add:set(jitter_angle_6:get())
    desync_side:set(desync_side_6:get())
    six = false
    jitterspeed_6w:set(jitter_delay_6:get())
    one = true
                    end
                end
            end
        end
    end
end

    oldtick = globals.tick_count() + jitterspeed_6w:get()

end
end

callbacks.add(e_callbacks.NET_UPDATE,jitterspeed_func6w)
--watermark

function watermark_func()
    fps = tostring(client.get_fps())
    if watermark_box:get() == true then
        render.rect_filled(vec2_t(screensize.x-screensize.x/4.9, screensize.y/150), vec2_t(screensize.x/5.1, screensize.y/40), color_t(5,5,5,255))
        render.rect_filled(vec2_t(screensize.x-screensize.x/4.95, screensize.y/100), vec2_t(screensize.x/5.2, screensize.y/50), color_t(35,35,35,255))
        render.rect(vec2_t(screensize.x-screensize.x/4.9, screensize.y/150), vec2_t(screensize.x/5.1, screensize.y/40), (theme_color:get()))
        render.text(csansms_wm, "Primordial.dev ", vec2_t(screensize.x-screensize.x/4.95, screensize.y/99), (theme_color:get()))
        render.text(csansms_wm, "| Team-Shlerp", vec2_t(screensize.x-screensize.x/15.8, screensize.y/99), (theme_color:get()))
        render.text(csansms_wm, fps, vec2_t(screensize.x-screensize.x/12.7, screensize.y/99), (theme_color:get()))
        render.text(csansms_wm,"| Fps ", vec2_t(screensize.x-screensize.x/10, screensize.y/99), (theme_color:get()))
        tickrate = tostring(client.get_tickrate())
        if tickrate == "0" then
            render.text(csansms_wm,"| Tickrate Na", vec2_t(screensize.x-screensize.x/6.65, screensize.y/99), (theme_color:get()))
        else
         render.text(csansms_wm,tickrate, vec2_t(screensize.x-screensize.x/9.05, screensize.y/99), (theme_color:get()))
         render.text(csansms_wm,"| Tickrate", vec2_t(screensize.x-screensize.x/6.75, screensize.y/99), (theme_color:get()))
        end
       
    
    else
        return
    end
 end

callbacks.add(e_callbacks.PAINT,watermark_func)


function watermark_func2()
    fps = tostring(client.get_fps())
    if watermark_box2:get() == true then
        render.rect_filled(vec2_t(screensize.x-screensize.x/4.9, screensize.y/150), vec2_t(screensize.x/5.1, screensize.y/40), color_t(5,5,5,255))
        render.rect_filled(vec2_t(screensize.x-screensize.x/4.95, screensize.y/100), vec2_t(screensize.x/5.2, screensize.y/50), color_t(35,35,35,255))
        render.text(verd, "Primordial.dev ", vec2_t(screensize.x-screensize.x/4.95, screensize.y/81), color_t(255,255,255,255))
        render.text(verd, "| Team-Shlerp", vec2_t(screensize.x-screensize.x/15.8, screensize.y/81), color_t(255,255,255,255))
        render.text(verd, fps, vec2_t(screensize.x-screensize.x/12.7, screensize.y/81), (theme_color:get()))
        render.text(verd,"| Fps ", vec2_t(screensize.x-screensize.x/10, screensize.y/81), color_t(255,255,255,255))
        render.rect_fade(vec2_t(screensize.x-screensize.x/4.9, screensize.y/150), vec2_t(screensize.x/5.1, screensize.y/220), (theme_color:get()), color_t(0,0,0,0), true)
        render.rect(vec2_t(screensize.x-screensize.x/4.9, screensize.y/150), vec2_t(screensize.x/5.1, screensize.y/40), (theme_color:get()))

        tickrate = tostring(client.get_tickrate())
        if tickrate == "0" then
            render.text(verd,"| Tickrate Na", vec2_t(screensize.x-screensize.x/6.65, screensize.y/81), color_t(255,255,255,255))
        else
         render.text(verd,tickrate, vec2_t(screensize.x-screensize.x/9.05, screensize.y/81), (theme_color:get()))
         render.text(verd,"| Tickrate", vec2_t(screensize.x-screensize.x/6.75, screensize.y/81), color_t(255,255,255,255))
        end
       
    
    else
        return
    end
 end

callbacks.add(e_callbacks.PAINT,watermark_func2)




function anim_stuff(ctx)
    if (anim_checkbox:get()) then
    ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE,movement_layer:get()/100,movement_layer:get()/100) 
    ctx:set_render_animlayer(e_animlayers.WEAPON_ACTION, weapon_a_layer:get()/100, weapon_a_layer:get()/100) 
    ctx:set_render_animlayer(e_animlayers.MOVEMENT_JUMP_OR_FALL, jump_or_fall_layer:get()/10, jump_or_fall_layer:get()/100) 
    ctx:set_render_animlayer(e_animlayers.MOVEMENT_LAND_OR_CLIMB, land_oc_layer:get()/100, land_oc_layer:get()/100) 
    ctx:set_render_animlayer(e_animlayers.MOVEMENT_STRAFECHANGE, strafe_c_layer:get()/100, strafe_c_layer:get()/100) 
    ctx:set_render_animlayer(e_animlayers.WHOLE_BODY, whole_b_layer:get()/100, whole_b_layer:get()/100) 
    ctx:set_render_animlayer(e_animlayers.FLASHED, flashed_layer:get()/100, flashed_layer:get()/100) 
    ctx:set_render_animlayer(e_animlayers.FLINCH, flinch_layer:get()/100, flinch_layer:get()/100) 
    ctx:set_render_animlayer(e_animlayers.ALIVELOOP, alive_l_layer:get()/100, alive_l_layer:get()/100) 
    ctx:set_render_animlayer(e_animlayers.AIMMATRIX, anim_m_layer:get()/100, anim_m_layer:get()/100) 
    ctx:set_render_animlayer(e_animlayers.WEAPON_ACTION_RECROUCH, weapon_ar_layer:get()/100, weapon_ar_layer:get()/100) 
    ctx:set_render_animlayer(e_animlayers.ADJUST, adjust_layer:get()/100, adjust_layer:get()/100) 
    ctx:set_render_animlayer(e_animlayers.LEAN, lean_layer:get()/100) 
    ctx:set_render_pose(e_poses.RUN, run_layer:get()/100)

    end
end
callbacks.add(e_callbacks.ANTIAIM,anim_stuff)

--clantag


local clantag = {

    "Ⓣ",
    "TⒺ",
    "TEⒶ",
    "TEAⓜ",
    "TEAM ",
    "TEAM -",
    "TEAM - ",
    "TEAM - Ⓢ",
    "TEAM - SⒽ",
    "TEAM - SHⓁ",
    "TEAM - SHLⒺ",
    "TEAM - SHLEⓇ",
    "TEAM - SHLERⓅ︎",
    "TEAM - SHLERP",
    "TEAM - SHLERP",
    "TEAM - SHLERP",
    "TEAM - SHLERP",
    "TEAM - SHLERP",
    "TEAM - SHLERP",
    "TEAM - SHLERP",
    "TEAM - SHLERP",
    "TEAM - SHLERP",
    "TEAM - SHLERP",
    "/EAM - SHLER/",
    "//AM - SHLE//",
    "///M - SHL///",
    "//// - SH////",
    "/////- S/////",
    "////// //////",
    "/////   /////",
    "////     ////",
    "///       ///",
    "//         //",
    "/           /",
    "       ",
    "  ",
    "",
}


a = 1
local lasttick = globals.server_tick() + 1

function clantag_func()
        if not clantag_box:get() then
            client.set_clantag("")
        else
        if (a == #clantag+1) then a = 1 end
        if(lasttick <= globals.server_tick()) then
        client.set_clantag(clantag[a])
        a = a+1
        lasttick = globals.server_tick()+clantag_speed:get()
        end
    end
end

callbacks.add(e_callbacks.NET_UPDATE,clantag_func)