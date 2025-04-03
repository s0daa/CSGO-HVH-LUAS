local jitter_add = menu.find("antiaim", "main", "angles", "jitter add"    )
local Yaw_base            = menu.find("antiaim", "main", "angles", "yaw add"        )
local desync_side         = menu.find("antiaim", "main", "desync", "side"           ) 
local desync_amount_l     = menu.find("antiaim", "main", "desync", "left amount"    )
local desync_amount_r     = menu.find("antiaim", "main", "desync", "right amount"   ) 
local antibrute           = menu.find("antiaim", "main", "desync", "anti bruteforce")
local cheat_jitter        = menu.find("antiaim", "main", "angles", "jitter mode"    )
local jitter_typeL        = menu.find("antiaim", "main", "angles", "jitter type"    )
local slowwalk_key        = menu.find("misc", "main", "movement", "slow walk"       )[2]
local desync_side         = menu.find("antiaim", "main", "desync", "side"           ) 
local desync_defaultside  = menu.find("antiaim", "main", "desync", "default side"           ) 
local body_lean           = menu.find('antiaim', 'main', 'angles', 'body lean')
local body_lean_value           = menu.find('antiaim', 'main', 'angles', 'body lean value')
local body_lean_jitter           = menu.find('antiaim', 'main', 'angles', 'body lean jitter')
local movingblean           = menu.find('antiaim', 'main', 'angles', 'moving body lean')

local text = menu.add_text("Welcome!","Username: "..user.name.."          \n")
local text2 = menu.add_text("Welcome!","UserID: "..user.uid.."          \n")
local text3 = menu.add_text("Welcome!","Resource Is Made By Kolesos 6228, Contact Me If you need any help.")

local menu_condition  = menu.add_selection("Anti-Aim Builder", "Conditions", {"Global", "Stand", "Move", "Slow Walk", "Air", "Crouch"}) 

-- global
local Yawslider  = menu.add_slider("Anti-Aim Builder", "[GLOBAL] Yaw Base", -180, 180)
local blean_tab = menu.add_selection("Anti-Aim Builder", "[GLOBAL] Body Lean Type", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
local blean_value = menu.add_slider("Anti-Aim Builder", "[GLOBAL] Body Lean Value", -50, 50)
local blean_jitter = menu.add_slider("Anti-Aim Builder", "[GLOBAL] Body Lean Jitter", 0, 100)
local aa_tab = menu.add_selection("Anti-Aim Builder", "[GLOBAL] Jitter Type", {"Centered", "Offset"})
local slider  = menu.add_slider("Anti-Aim Builder", "[GLOBAL] Jitter Angle", -180, 180)
local desync_tab = menu.add_selection("Anti-Aim Builder", "[GLOBAL] Desync Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"})
local peekfr_tab = menu.add_selection("Anti-Aim Builder", "[GLOBAL] Default Side", {"Left", "Right"})
local desync_l  = menu.add_slider("Anti-Aim Builder", "[GLOBAL] Left Desync Amount", 0, 100)
local desync_r  = menu.add_slider("Anti-Aim Builder", "[GLOBAL] Right Desync Amount", 0, 100)
-- stand
local Override_stand   = menu.add_checkbox("Anti-Aim Builder", "[STAND] Enable")
local Yawslider_stand  = menu.add_slider("Anti-Aim Builder", "[STAND] Yaw Base", -180, 180)
local blean_tab_stand = menu.add_selection("Anti-Aim Builder", "[STAND] Body Lean Type", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
local blean_value_stand = menu.add_slider("Anti-Aim Builder", "[STAND] Body Lean Value", -50, 50)
local blean_jitter_stand = menu.add_slider("Anti-Aim Builder", "[STAND] Body Lean Jitter", 0, 100)
local aa_tab_stand = menu.add_selection("Anti-Aim Builder", "[STAND] Jitter Type", {"Centered", "Offset"})
local slider_stand  = menu.add_slider("Anti-Aim Builder", "[STAND] Jitter Angle", -180, 180)
local desync_tab_stand = menu.add_selection("Anti-Aim Builder", "[STAND] Desync Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"})
local peekfr_tab_stand = menu.add_selection("Anti-Aim Builder", "[STAND] Default Side", {"Left", "Right"})
local desync_l_stand  = menu.add_slider("Anti-Aim Builder", "[STAND] Left Desync Amount", 0, 100)
local desync_r_stand  = menu.add_slider("Anti-Aim Builder", "[STAND] Right Desync Amount", 0, 100)
-- move
local Override_move   = menu.add_checkbox("Anti-Aim Builder", "[MOVE] Enable")
local Yawslider_move  = menu.add_slider("Anti-Aim Builder", "[MOVE] Yaw Base", -180, 180)
local blean_tab_move = menu.add_selection("Anti-Aim Builder", "[MOVE] Body Lean Type", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
local blean_value_move = menu.add_slider("Anti-Aim Builder", "[MOVE] Body Lean Value", -50, 50)
local blean_jitter_move = menu.add_slider("Anti-Aim Builder", "[MOVE] Body Lean Jitter", 0, 100)
local aa_tab_move = menu.add_selection("Anti-Aim Builder", "[MOVE] Jitter Type", {"Centered", "Offset"})
local slider_move  = menu.add_slider("Anti-Aim Builder", "[MOVE] Jitter Angle", -180, 180)
local desync_tab_move = menu.add_selection("Anti-Aim Builder", "[MOVE] Desync Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"})
local peekfr_tab_move = menu.add_selection("Anti-Aim Builder", "[MOVE] Default Side", {"Left", "Right"})
local desync_l_move  = menu.add_slider("Anti-Aim Builder", "[MOVE] Left Desync Amount", 0, 100)
local desync_r_move  = menu.add_slider("Anti-Aim Builder", "[MOVE] Right Desync Amount", 0, 100)
-- slow
local Override_slow   = menu.add_checkbox("Anti-Aim Builder", "[SLOW-WALK] Enable")
local Yawslider_slow  = menu.add_slider("Anti-Aim Builder", "[SLOW-WALK] Yaw Base", -180, 180)
local blean_tab_slow = menu.add_selection("Anti-Aim Builder", "[SLOW-WALK] Body Lean Type", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
local blean_value_slow = menu.add_slider("Anti-Aim Builder", "[SLOW-WALK] Body Lean Value", -50, 50)
local blean_jitter_slow = menu.add_slider("Anti-Aim Builder", "[SLOW-WALK] Body Lean Jitter", 0, 100)
local aa_tab_slow = menu.add_selection("Anti-Aim Builder", "[SLOW-WALK] Jitter Type", {"Centered", "Offset"})
local slider_slow  = menu.add_slider("Anti-Aim Builder", "[SLOW-WALK] Jitter Angle", -180, 180)
local desync_tab_slow = menu.add_selection("Anti-Aim Builder", "[SLOW-WALK] Desync Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"})
local peekfr_tab_slow = menu.add_selection("Anti-Aim Builder", "[SLOW-WALK] Default Side", {"Left", "Right"})
local desync_l_slow  = menu.add_slider("Anti-Aim Builder", "[SLOW-WALK] Left Desync Amount", 0, 100)
local desync_r_slow  = menu.add_slider("Anti-Aim Builder", "[SLOW-WALK] Right Desync Amount", 0, 100)
-- air
local Override_air    = menu.add_checkbox("Anti-Aim Builder", "[AIR] Enable")
local Yawslider_air  = menu.add_slider("Anti-Aim Builder", "[AIR] Yaw Base", -180, 180)
local blean_tab_air = menu.add_selection("Anti-Aim Builder", "[AIR] Body Lean Type", {"None"})
local aa_tab_air = menu.add_selection("Anti-Aim Builder", "[AIR] Jitter Type", {"Centered", "Offset"})
local slider_air  = menu.add_slider("Anti-Aim Builder", "[AIR] Jitter Angle", -180, 180)
local desync_tab_air = menu.add_selection("Anti-Aim Builder", "[AIR] Desync Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"})
local peekfr_tab_air = menu.add_selection("Anti-Aim Builder", "[AIR] Default Side", {"Left", "Right"})
local desync_l_air  = menu.add_slider("Anti-Aim Builder", "[AIR] Left Desync Amount", 0, 100)
local desync_r_air  = menu.add_slider("Anti-Aim Builder", "[AIR] Right Desync Amount", 0, 100)
-- duck
local Override_duck   = menu.add_checkbox("Anti-Aim Builder", "[CROUCH] Enable")
local Yawslider_duck  = menu.add_slider("Anti-Aim Builder", "[CROUCH] Yaw Base", -180, 180)
local blean_tab_duck = menu.add_selection("Anti-Aim Builder", "[CROUCH] Body Lean Type", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
local blean_value_duck = menu.add_slider("Anti-Aim Builder", "[CROUCH] Body Lean Value", -50, 50)
local blean_jitter_duck = menu.add_slider("Anti-Aim Builder", "[CROUCH] Body Lean Jitter", 0, 100)
local aa_tab_duck = menu.add_selection("Anti-Aim Builder", "[CROUCH] Jitter Type", {"Centered", "Offset"})
local slider_duck  = menu.add_slider("Anti-Aim Builder", "[CROUCH] Jitter Angle", -180, 180)
local desync_tab_duck = menu.add_selection("Anti-Aim Builder", "[CROUCH] Desync Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"})
local peekfr_tab_duck = menu.add_selection("Anti-Aim Builder", "[CROUCH] Default Side", {"Left", "Right"})
local desync_l_duck  = menu.add_slider("Anti-Aim Builder", "[CROUCH] Left Desync Amount", 0, 100)
local desync_r_duck  = menu.add_slider("Anti-Aim Builder", "[CROUCH] Right Desync Amount", 0, 100)


local function conditions() -- got the upvalues error so i made conditions in a seperate function
    local local_player          = entity_list.get_local_player()
    local velocity              = local_player:get_prop("m_vecVelocity"):length()   
    if velocity == 0 then  
        condition = 1 -- stand
    end
    if velocity > 0 then
        condition = 2 -- move
    end
    if Override_slow:get() then
        if slowwalk_key:get() then
            condition = 3 -- slow walk
        end
    end
    local crouch_key = input.find_key_bound_to_binding("duck")
    if local_player:get_prop("m_vecVelocity[2]") ~= 0 then 
        condition = 4  -- air
    end 
    if  input.is_key_held(crouch_key) then 
      condition = 5 --crouch
    end
    if input.is_key_held(crouch_key) and local_player:get_prop("m_vecVelocity[2]") ~= 0 then  -- did this so crouching in air doesn't count as crouching condition
        condition = 4 -- air 
    end
    cheat_jitter:set(2) 
        if aa_tab:get() == 1 then
            jitter_typeL:set(2)
        elseif aa_tab:get() == 2 then
            jitter_typeL:set(1)
        end

end

local function secondmain(cmd)
    local bodyleanT = blean_tab:get()
    local bodyleanV = blean_value:get()
    local bodyleanJ = blean_jitter:get()
    movingblean:set(true)
    if Override_stand:get() then
        if condition == 1 then 
            bodyleanT = blean_tab_stand:get()
            bodyleanV = blean_value_stand:get()
            bodyleanJ = blean_jitter_stand:get()
            movingblean:set(false)
        end
    end
    if Override_move:get() then
        if condition == 2 then 
            bodyleanT = blean_tab_move:get()
            bodyleanV = blean_value_move:get()
            bodyleanJ = blean_jitter_move:get()
            movingblean:set(true)
        end
    end
    if Override_slow:get() then
        if condition == 3 then 
            bodyleanT = blean_tab_slow:get()
            bodyleanV = blean_value_slow:get()
            bodyleanJ = blean_jitter_slow:get()
            movingblean:set(false)
        end
    end
    if Override_air:get() then
        if condition == 4 then 
            bodyleanT = blean_tab_air:get()
            movingblean:set(false)
        end
    end
    if Override_duck:get() then
        if condition == 5 then 
            bodyleanT = blean_tab_duck:get()
            bodyleanV = blean_value_duck:get()
            bodyleanJ = blean_jitter_duck:get()
            movingblean:set(true)
        end
    end
    body_lean:set(bodyleanT)
    body_lean_value:set(bodyleanV)
    body_lean_jitter:set(bodyleanJ)





end

local function main(cmd)
    local yawcondition = Yawslider:get()
    local ldesync_condition = desync_l:get()
    local rdesync_condition = desync_r:get()
    local desyncside = desync_tab:get()
    local defaultside = peekfr_tab:get()
    local jittercondition = slider:get()
    conditions() -- calling conditions



    if Override_stand:get() then
        if condition == 1 then 
           yawcondition = Yawslider_stand:get()
           ldesync_condition = desync_l_stand:get() 
           rdesync_condition = desync_r_stand:get() 
           desyncside = desync_tab_stand:get()
           defaultside = peekfr_tab_stand:get()
           jittercondition = slider_stand:get()
           if aa_tab_stand:get() == 1 then
           jitter_typeL:set(2)
           elseif aa_tab_stand:get() == 2 then
            jitter_typeL:set(1)
           end                 
        end
    end

    if Override_move:get() then
        if condition == 2 then 
           yawcondition = Yawslider_move:get()
           ldesync_condition = desync_l_move:get()
           rdesync_condition = desync_r_move:get()
           desyncside = desync_tab_move:get()
           defaultside = peekfr_tab_move:get()
           jittercondition = slider_move:get()
           if aa_tab_move:get() == 1 then
            jitter_typeL:set(2)
            elseif aa_tab_move:get() == 2 then
             jitter_typeL:set(1)
            end 
        end
    end
    if Override_slow:get() then
        if condition == 3 then 
           yawcondition = Yawslider_slow:get()
           ldesync_condition = desync_l_slow:get()
           rdesync_condition = desync_r_slow:get()
           desyncside = desync_tab_slow:get()
           defaultside = peekfr_tab_slow:get()
           jittercondition = slider_slow:get()
            if aa_tab_slow:get() == 1 then
            jitter_typeL:set(2)
            elseif aa_tab_slow:get() == 2 then
             jitter_typeL:set(1)
            end 
        end
    end
    if Override_air:get() then
        if condition == 4 then 
           yawcondition = Yawslider_air:get()
           ldesync_condition = desync_l_air:get()
           rdesync_condition = desync_r_air:get()
           desyncside = desync_tab_air:get()
           defaultside = peekfr_tab_air:get()
           jittercondition = slider_air:get()
           if aa_tab_air:get() == 1 then
            jitter_typeL:set(2)
            elseif aa_tab_air:get() == 2 then
             jitter_typeL:set(1)
            end 
        end
    end
    if Override_duck:get() then
        if condition == 5 then 
           yawcondition = Yawslider_duck:get()
           ldesync_condition = desync_l_duck:get()
           rdesync_condition = desync_r_duck:get()
           desyncside = desync_tab_duck:get()
           defaultside = peekfr_tab_duck:get()
           jittercondition = slider_duck:get()
           if aa_tab_duck:get() == 1 then
            jitter_typeL:set(2)
            elseif aa_tab_duck:get() == 2 then
             jitter_typeL:set(1)
            end 
        end
    end
    secondmain() -- another upvalues fucking fix
    Yaw_base:set(yawcondition)
    jitter_add:set(jittercondition)
    desync_amount_l:set(ldesync_condition)
    desync_amount_r:set(rdesync_condition)
    desync_side:set(desyncside)
    desync_defaultside:set(defaultside)

end

local function menu_shit()
        menu_condition:set_visible(true)

        Yawslider:set_visible(false)
        blean_tab:set_visible(false)
        blean_jitter:set_visible(false)
        blean_value:set_visible(false)
        aa_tab:set_visible(false)
        slider:set_visible(false)
        desync_l:set_visible(false)
        desync_r:set_visible(false)
        desync_tab:set_visible(false)
        peekfr_tab:set_visible(false)

        Yawslider_air:set_visible(false)
        blean_tab_air:set_visible(false)
        aa_tab_air:set_visible(false)
        slider_air:set_visible(false)
        desync_l_air:set_visible(false)
        desync_r_air:set_visible(false)
        desync_tab_air:set_visible(false)
        peekfr_tab_air:set_visible(false)

        Yawslider_duck:set_visible(false)
        blean_tab_duck:set_visible(false)
        blean_jitter_duck:set_visible(false)
        blean_value_duck:set_visible(false)
        aa_tab_duck:set_visible(false)
        slider_duck:set_visible(false)
        desync_l_duck:set_visible(false)
        desync_r_duck:set_visible(false)
        desync_tab_duck:set_visible(false)
        peekfr_tab_duck:set_visible(false)

        Yawslider_move:set_visible(false)
        blean_tab_move:set_visible(false)
        blean_jitter_move:set_visible(false)
        blean_value_move:set_visible(false)
        aa_tab_move:set_visible(false)
        slider_move:set_visible(false)
        desync_l_move:set_visible(false)
        desync_r_move:set_visible(false)
        desync_tab_move:set_visible(false)
        peekfr_tab_move:set_visible(false)





    -- making sure visible shit doesnt fuck up, I cant do smart code im high af rn

end
local function menu_shit2()
        --upvalues error fix 
    Yawslider_slow:set_visible(false)
    blean_tab_slow:set_visible(false)
    blean_jitter_slow:set_visible(false)
    blean_value_slow:set_visible(false)
    aa_tab_slow:set_visible(false)
    slider_slow:set_visible(false)
    desync_l_slow:set_visible(false)
    desync_r_slow:set_visible(false)
    desync_tab_slow:set_visible(false)
    peekfr_tab_slow:set_visible(false)

    Yawslider_stand:set_visible(false)
    blean_tab_stand:set_visible(false)
    blean_jitter_stand:set_visible(false)
    blean_value_stand:set_visible(false)
    aa_tab_stand:set_visible(false)
    slider_stand:set_visible(false)
    desync_l_stand:set_visible(false)
    desync_r_stand:set_visible(false)
    desync_tab_stand:set_visible(false)
    peekfr_tab_stand:set_visible(false)

    Override_air:set_visible(false)
    Override_duck:set_visible(false)
    Override_move:set_visible(false)
    Override_slow:set_visible(false)
    Override_stand:set_visible(false)
        --upvalues error fix v2
    if menu_condition:get() == 1 then
        Yawslider:set_visible(true)
        desync_l:set_visible(true)
        desync_r:set_visible(true)
        desync_tab:set_visible(true)
        aa_tab:set_visible(true)
        blean_tab:set_visible(true)
    
        if blean_tab:get() == 1 or blean_tab:get() == 5 then
            blean_value:set_visible(false)
            blean_jitter:set_visible(false)
        elseif blean_tab:get() == 2 then
                    blean_value:set_visible(true)
        elseif blean_tab:get() == 3  or blean_tab:get() == 4 then
                    blean_jitter:set_visible(true)
        end
        
        if aa_tab:get() == 1 or aa_tab:get() == 2 then
            slider:set_visible(true)
        end
        
        if desync_tab:get() == 5 or desync_tab:get() == 6 then 
            peekfr_tab:set_visible(true)
        end          
    end
        
    if menu_condition:get() == 2 then
        Override_stand:set_visible(true)
        Yawslider_stand:set_visible(true)
        desync_l_stand:set_visible(true)
        desync_r_stand:set_visible(true)
        desync_tab_stand:set_visible(true)
        aa_tab_stand:set_visible(true)
        blean_tab_stand:set_visible(true)
        
        if blean_tab_stand:get() == 1 or blean_tab_stand:get() == 5 then
            blean_value_stand:set_visible(false)
            blean_jitter_stand:set_visible(false)
        elseif blean_tab_stand:get() == 2 then
            blean_value_stand:set_visible(true)
        elseif blean_tab_stand:get() == 3  or blean_tab_stand:get() == 4 then
            blean_jitter_stand:set_visible(true)
        end
        
        if aa_tab_stand:get() == 1  or aa_tab_stand:get() == 2 then
            slider_stand:set_visible(true)
        end
        
        if desync_tab_stand:get() == 5 or desync_tab_stand:get() == 6 then 
            peekfr_tab_stand:set_visible(true)
        end
        
        if not Override_stand:get() then
            Yawslider_stand:set_visible(false)
            slider_stand:set_visible(false)
            desync_l_stand:set_visible(false)
            desync_r_stand:set_visible(false)
            desync_tab_stand:set_visible(false)
            peekfr_tab_stand:set_visible(false)
            aa_tab_stand:set_visible(false)
            blean_tab_stand:set_visible(false)
            blean_jitter_stand:set_visible(false)
            blean_value_stand:set_visible(false)
        end
    end
end
    

local function on_paint()
    menu_shit()
    menu_shit2()
    if menu_condition:get() == 3 then
        Override_move:set_visible(true)
        Yawslider_move:set_visible(true)
        desync_l_move:set_visible(true)
        desync_r_move:set_visible(true)
        desync_tab_move:set_visible(true)
        aa_tab_move:set_visible(true)
        blean_tab_move:set_visible(true)

        if blean_tab_move:get() == 1 or blean_tab_move:get() == 5 then
            blean_value_move:set_visible(false)
            blean_jitter_move:set_visible(false)
        elseif blean_tab_move:get() == 2 then
            blean_value_move:set_visible(true)
        elseif blean_tab_move:get() == 3  or blean_tab_move:get() == 4 then
            blean_jitter_move:set_visible(true)
        end

        if aa_tab_move:get() == 1 or aa_tab_move:get() == 2 then
            slider_move:set_visible(true)
        end

        if desync_tab_move:get() == 5 or desync_tab_move:get() == 6 then 
            peekfr_tab_move:set_visible(true)
        end

        if not Override_move:get() then
            blean_tab_move:set_visible(false)
            Yawslider_move:set_visible(false)
            slider_move:set_visible(false)
            desync_l_move:set_visible(false)
            desync_r_move:set_visible(false)
            desync_tab_move:set_visible(false)
            peekfr_tab_move:set_visible(false)
            aa_tab_move:set_visible(false)
            blean_jitter_move:set_visible(false)
            blean_value_move:set_visible(false)

        end
    end

    if menu_condition:get() == 4 then
        Override_slow:set_visible(true)
        Yawslider_slow:set_visible(true)
        desync_l_slow:set_visible(true)
        desync_r_slow:set_visible(true)
        desync_tab_slow:set_visible(true)
        aa_tab_slow:set_visible(true)
        blean_tab_slow:set_visible(true)

        if blean_tab_slow:get() == 1 or blean_tab_slow:get() == 5 then
            blean_value_slow:set_visible(false)
            blean_jitter_slow:set_visible(false)
        elseif blean_tab_slow:get() == 2 then
            blean_value_slow:set_visible(true)
        elseif blean_tab_slow:get() == 3  or blean_tab_slow:get() == 4 then
            blean_jitter_slow:set_visible(true)
        end

        if aa_tab_slow:get() == 1 or aa_tab_slow:get() == 2 then
            slider_slow:set_visible(true)
        end

        if desync_tab_slow:get() == 5 or desync_tab_slow:get() == 6 then 
            peekfr_tab_slow:set_visible(true)
        end

        if not Override_slow:get() then
            Yawslider_slow:set_visible(false)
            slider_slow:set_visible(false)
            desync_l_slow:set_visible(false)
            desync_r_slow:set_visible(false)
            desync_tab_slow:set_visible(false)
            peekfr_tab_slow:set_visible(false)
            aa_tab_slow:set_visible(false)
            blean_tab_slow:set_visible(false)
            blean_jitter_slow:set_visible(false)
            blean_value_slow:set_visible(false)
        end
    end

    if menu_condition:get() == 5 then
        Override_air:set_visible(true)
        Yawslider_air:set_visible(true)
        slider_air:set_visible(true)
        desync_l_air:set_visible(true)
        desync_r_air:set_visible(true)
        desync_tab_air:set_visible(true)
        aa_tab_air:set_visible(true)
        blean_tab_air:set_visible(true)
    

        if aa_tab_air:get() == 1 or aa_tab_air:get() == 2 then
            slider_air:set_visible(true)
        end

        if desync_tab_air:get() == 5 or desync_tab_air:get() == 6 then 
            peekfr_tab_air:set_visible(true)
        end

        if not Override_air:get() then 
            Yawslider_air:set_visible(false)
            slider_air:set_visible(false)
            desync_l_air:set_visible(false)
            desync_r_air:set_visible(false)
            desync_tab_air:set_visible(false)
            peekfr_tab_air:set_visible(false)
            aa_tab_air:set_visible(false)
            blean_tab_air:set_visible(false)
        end

    end

    if menu_condition:get() == 6 then
        Override_duck:set_visible(true)
        Yawslider_duck:set_visible(true)
        slider_duck:set_visible(true)
        desync_l_duck:set_visible(true)
        desync_r_duck:set_visible(true)
        desync_tab_duck:set_visible(true)
        aa_tab_duck:set_visible(true)
        blean_tab_duck:set_visible(true)

        if blean_tab_duck:get() == 1 or blean_tab_duck:get() == 5 then
            blean_value_duck:set_visible(false)
            blean_jitter_duck:set_visible(false)
        elseif blean_tab_duck:get() == 2 then
            blean_value_duck:set_visible(true)
        elseif blean_tab_duck:get() == 3  or blean_tab_duck:get() == 4 then
            blean_jitter_duck:set_visible(true)
        end

        if aa_tab_duck:get() == 1 or aa_tab_duck:get() == 2 then
            slider_duck:set_visible(true)
        end

        if desync_tab_duck:get() == 5 or desync_tab_duck:get() == 6 then 
             peekfr_tab_duck:set_visible(true)
        end
        
        if not Override_duck:get() then
            Yawslider_duck:set_visible(false)
            slider_duck:set_visible(false)
            desync_l_duck:set_visible(false)
            desync_r_duck:set_visible(false)
            desync_tab_duck:set_visible(false)
            peekfr_tab_duck:set_visible(false)
            aa_tab_duck:set_visible(false)
            blean_tab_duck:set_visible(false)
            blean_jitter_duck:set_visible(false)
            blean_value_duck:set_visible(false)
        end
    end
end
callbacks.add(e_callbacks.SETUP_COMMAND, main) 
callbacks.add(e_callbacks.PAINT, on_paint)