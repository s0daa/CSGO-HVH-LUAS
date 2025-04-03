--]
--[ Made by stars#3787 ]
--]

 --] MENU CONTROLS
local yaw_base        = menu.find("antiaim", "main", "angles", "yaw add"        )
local rotate_enable   = menu.find("antiaim", "main", "angles", "rotate"         )
local mrotate_range   = menu.find("antiaim", "main", "angles", "rotate range"   )
local mrotate_speed   = menu.find("antiaim", "main", "angles", "rotate speed"   )
local desync_side     = menu.find("antiaim", "main", "desync", "side"           ) 
local desync_amount_l = menu.find("antiaim", "main", "desync", "left amount"    )
local desync_amount_r = menu.find("antiaim", "main", "desync", "right amount"   ) 
local antibrute       = menu.find("antiaim", "main", "desync", "anti bruteforce")
local cheat_jitter    = menu.find("antiaim", "main", "angles", "jitter mode"    )
local auto_direct     = menu.find("antiaim", "main", "angles", "yaw base"       )
local pitch           = menu.find("antiaim", "main", "angles", "pitch"          )
local onshot          = menu.find("antiaim", "main", "desync", "on shot"        )
local override_stand  = menu.find("antiaim", "main", "desync", "override stand" )
local leg_slide       = menu.find("antiaim", "main", "general", "leg slide"     )

 ---------------------------------------------------------------------------
--] Save Initial Settings [--
local sYaw_base        = yaw_base:get()
local sRotate_enable   = rotate_enable:get()
local sMrotate_range   = mrotate_range:get()
local sMrotate_speed   = mrotate_speed:get()
local sDesync_side     = desync_side:get()
local sDesync_amount_l = desync_amount_l:get()
local sDesync_amount_r = desync_amount_r:get()
local sAntibrute       = antibrute:get()
local sCheat_jitter    = cheat_jitter:get()
local sAuto_direct     = auto_direct:get()
local sPitch           = pitch:get()
local sOnshot          = onshot:get()
local sOverride_stand  = override_stand:get()
local sLeg_slide       = leg_slide:get()
-- uses these to revert settings on shutdown

 ---------------------------------------------------------------------------
 --] MENU ELEMENTS [--
 
 --] Welcom message :3 [--
local text = menu.add_text("welcome!", "Thanks for using my lua! \n"                       )
local text = menu.add_text("welcome!", "Made by stars 3787 or stars on forums \n"          )
local text = menu.add_text("welcome!", "Disable override stand in the real AA menu \n"     )
local text = menu.add_text("welcome!", "Anything able to be changed in menu options tab \n")
local text = menu.add_text("welcome!", "-cant be changed in the cheat's antiaim tab. \n"   )
local text = menu.add_text("welcome!", "Reminder: dont play like a bitch (please) \n"      )
local text = menu.add_text("welcome!", "Enjoy!"                                            )




-- global variables
local state = 0

 --] Anti-Aim [--

 -- presets
local presets = menu.add_selection("anti aim", "presets", {"none", "jitter inwards fake", "jitter outwards fake", "aggressive jitter", "small jitter (hs only)", "large fake jitter"})

-- jitter builder 
local jitter_builder  = menu.add_checkbox("anti aim", "jitter builder")
local jitter_angle_1  = menu.add_slider("anti aim", "jitter angle 1", -180, 180)
local jitter_angle_2  = menu.add_slider("anti aim", "jitter angle 2", -180, 180)

local desync_amount_1 = menu.add_slider("anti aim", "desync amount 1", -100, 100)
local desync_amount_2 = menu.add_slider("anti aim", "desync amount 2", -100, 100) 

local mjitter_speed   = menu.add_slider("anti aim", "jitter speed", 1, 3)

local mpitch          = menu.add_selection("menu options", "pitch", {"none", "down", "up", "zero", "jitter"})

local mOnshot         = menu.add_selection("menu options", "onshot", {"off", "opposite", "same side", "random"})

local mleg_slide      = menu.add_selection("menu options", "leg slide", {"neutral", "never", "always", "jitter"})

local rotate          = menu.add_checkbox("anti aim", "rotate")
local rotate_angle    = menu.add_slider("anti aim", "rotate range", 0, 360)
local rotate_speed    = menu.add_slider("anti aim", "rotate speed", 0, 100)

local do_auto_direct  = menu.add_selection("menu options", "auto direction mode", {"none", "viewangle", "at targets (crosshair)", "at targets (distance)", "velocity"})

local do_antibrute    = menu.add_checkbox("menu options", "anti bruteforce")

menu.set_group_column("anti aim", 2)
---------------------------------------------------------------------------

local function main(cmd)

    -- shit to make it so user settings dont mess with it 
    cheat_jitter:set(1) -- Im using yaw offset to do jitter, this would fuck with it
    override_stand:set(false) -- only does jitter for stand so it would fuck with it


    ---------------------------------------------------------------------------
    --] Do AntiAim [--
    local preset = presets:get()

    --] Do presets [--
    if preset == 2 then   -- jitter inwards fake
        jitter_angle_1:set(20)
        jitter_angle_2:set(-20)
        desync_amount_1:set(-91)
        desync_amount_2:set(91)
    end

    if preset == 3 then   -- jitter outwards fake
        jitter_angle_1:set(30)
        jitter_angle_2:set(-30)
        desync_amount_1:set(91)
        desync_amount_2:set(-91)
    end

    if preset == 4 then   -- aggressive jitter
        jitter_angle_1:set(40)
        jitter_angle_2:set(-40)
        desync_amount_1:set(92)
        desync_amount_2:set(-92)

        rotate_enable:set(true)
        mrotate_range:set(2)
        mrotate_speed:set(100)
    end

    if preset == 5 then   -- small jitter (hs only)
        jitter_angle_1:set(8)
        jitter_angle_2:set(5)
        desync_amount_1:set(20)
        desync_amount_2:set(8)

        rotate_enable:set(true)
        mrotate_range:set(1)
        mrotate_speed:set(55)
    end

    if preset == 6 then   -- large fake jitter
        jitter_angle_1:set(13)
        jitter_angle_2:set(-13)
        desync_amount_1:set(100)
        desync_amount_2:set(-100)
    end

    local vjitter_angle_1 = jitter_angle_1:get()
    local vjitter_angle_2 = jitter_angle_2:get()
    local vdesync_amount_1 = desync_amount_1:get()
    local vdesync_amount_2 = desync_amount_2:get()

    --] Jitter Builder [--
    local tick_count = global_vars.tick_count()

    if jitter_builder:get() then
        local jitter_speed = mjitter_speed:get() + 1

        if state > 0 then 
            yaw_base:set(vjitter_angle_1)
            if vdesync_amount_1 < 0 then 
                desync_side:set(2)
                desync_amount_l:set(vdesync_amount_1 * -1)
                desync_amount_r:set(vdesync_amount_1 * -1)
            else
                desync_side:set(3)
                desync_amount_l:set(vdesync_amount_1)
                desync_amount_r:set(vdesync_amount_1)
            end

        else
            yaw_base:set(vjitter_angle_2)
            if vdesync_amount_2 < 0 then 
                desync_side:set(2)
                desync_amount_l:set(vdesync_amount_2 * -1)
                desync_amount_r:set(vdesync_amount_2 * -1)
            else
                desync_side:set(3)
                desync_amount_l:set(vdesync_amount_2)
                desync_amount_r:set(vdesync_amount_2)
            end
        end
        state = state + 1
        if state > jitter_speed then state = jitter_speed * -1 
        end
    end

    --] Do Auto direction [--
    auto_direct:set(do_auto_direct() + 1)

    --] Rotate [--
    local vrotate_speed = rotate_speed:get()
    local vrotate_range = rotate_angle:get()

    if  rotate:get() then
        rotate_enable:set(true)
        mrotate_speed:set(vrotate_speed)
        mrotate_range:set(vrotate_range)
    else 
        rotate_enable:set(false)
    end


    --] Anti Bruteforce [--
    if  do_antibrute:get() then
        antibrute:set(true)
    else
        antibrute:set(false)
    end


    --] Pitch [--
    pitch:set(mpitch() + 1)


    --] Onshot [--
    onshot:set(mOnshot() + 1)

    --] Leg Slide [--
    leg_slide:set(mleg_slide() + 1)

    ---------------------------------------------------------------------------

end

local function on_shutdown()
    --] Restore Initial Settings [--
    yaw_base:set(sYaw_base)       
    rotate_enable:set(sRotate_enable) 
    mrotate_range:set(sMrotate_range)  
    mrotate_speed:set(sMrotate_speed)  
    desync_side:set(sDesync_side)    
    desync_amount_l:set(sDesync_amount_l)
    desync_amount_r:set(sDesync_amount_r)
    antibrute:set(sAntibrute)     
    cheat_jitter:set(sCheat_jitter)   
    auto_direct:set(sAuto_direct)    
    pitch:set(sPitch)          
    onshot:set(sOnshot)         
    override_stand:set(sOverride_stand) 
    leg_slide:set(sLeg_slide)      


    print("Settings restored.")
    print("Bye!")
end

callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.SETUP_COMMAND, main)