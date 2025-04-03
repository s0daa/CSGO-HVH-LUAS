local clip = require("primordial/clipboard lib.131")
--local notifications = require("primordial/notification pop-up library.58")
local chat = require("primordial/chat printing lib.128")
local json = require("primordial/JSON Library.97")
local base64 = require("primordial/base64.371")

local ref = {}
local vars = {}
local marsmenu = {}


ref = {
    general = {
        pitch = menu.find("antiaim", "main", "angles", "pitch"),
        yawb = menu.find("antiaim", "main", "angles", "yaw base"),
        yawadd = menu.find("antiaim", "main", "angles", "yaw add"),
        sw = menu.find("misc", "main", "movement", "slow walk"),
        dt = menu.find("aimbot", "general", "exploits", "doubletap", "enable"),
        hs = menu.find("aimbot", "general", "exploits", "hideshots", "enable"),
        leg = menu.find("antiaim","main","general","leg slide"),
        fl = menu.find("antiaim", "main", "fakelag", "amount"),
    },
    
    rot = {    
        rotate = menu.find("antiaim", "main", "angles", "rotate"),
        rotate_r = menu.find("antiaim", "main", "angles", "rotate range"),
        rotate_s = menu.find("antiaim", "main", "angles", "rotate speed"),
    },

    --Jitter
    jitter = {
        jit = menu.find("antiaim", "main", "angles", "jitter mode"),
        jit_t = menu.find("antiaim", "main", "angles", "jitter type"),
        jit_add = menu.find("antiaim", "main", "angles", "jitter add"),
    },

    lean = {

        bl = menu.find("antiaim", "main", "angles", "body lean"),
        --static
        bl_val = menu.find("antiaim", "main", "angles", "body lean value"),
        --jitter/random jitter
        bl_jit = menu.find("antiaim", "main", "angles", "body lean jitter"),
        --
        mov_bl = menu.find("antiaim", "main", "angles", "moving body lean"),
    },
    desync = {
        stand = {           
            side = menu.find("antiaim","main", "desync","side#stand"),
            left_Amount = menu.find("antiaim","main", "desync","left amount#stand"),
            right_Amount = menu.find("antiaim","main", "desync","right amount#stand"),
        },
        move = {     
            override = menu.find("antiaim","main", "desync","override stand#move"),      
            side = menu.find("antiaim","main", "desync","side#move"),
            left_Amount = menu.find("antiaim","main", "desync","left amount#move"),
            right_Amount = menu.find("antiaim","main", "desync","right amount#move"),
        },
        sw = {        
            pverride = menu.find("antiaim","main", "desync","override stand#slow walk"),   
            side = menu.find("antiaim","main", "desync","side#slow walk"),
            left_Amount = menu.find("antiaim","main", "desync","left amount#slow walk"),
            right_Amount = menu.find("antiaim","main", "desync","right amount#slow walk"),
        },
        ab = menu.find("antiaim","main", "desync","anti bruteforce"),
        On_Shot = menu.find("antiaim","main", "desync","on shot"),
    },


}
get_velocity = function(entity)
    if entity == nil then return end
    x = entity:get_prop("m_vecVelocity[0]")
    y = entity:get_prop("m_vecVelocity[1]")
    z = entity:get_prop("m_vecVelocity[2]")
    if x == nil then return end
    return math.sqrt(x*x + y*y + z*z)
end
states = function() 
    if entity == nil then return end
    -- localplayer
    entity = entity_list.get_local_player()
    velocity = math.floor(get_velocity(entity))
    crouch_in_air = entity_list.get_local_player():get_prop("m_fFlags") == 262
    jumping = bit.band(entity_list.get_local_player():get_prop("m_fFlags"), 1) == 0

    if ref.general.sw[2]:get() then
        vars.player_state = "slowwalking"
    elseif crouch_in_air then
        vars.player_state = "duck_in_air"
    elseif jumping and not crouch_in_air then
        vars.player_state = "in_air"
    elseif input.is_key_held(input.find_key_bound_to_binding("duck")) then
        vars.player_state = "crouching"
    elseif velocity > 90 and not crouch_in_air then
        vars.player_state = "moving"
    else
        vars.player_state = "Standing"
    end
end

marsmenu = {
    tabs = menu.add_selection("MARS", "Select tab",{"Ragebot","AntiAim","Misc"}),
    build = menu.add_list("Misc","Misc",{"stand", "move", "slowwalk", "Crouch","In Air", "Crouch In Air","Pressets"}),

    aat = {
        stand = {
            yawb = menu.add_selection("Builder","Yaw Base",{"none", "View", "Crosshair", "Distance","Velocity"}),
            yawadd = menu.add_slider("Builder", "Yaw", -180, 180), 

            rotate = menu.add_checkbox("Builder","Rotate",false),
            rotate_r = menu.add_slider("Builder", "Rotate Range", 0, 360), 
            rotate_s = menu.add_slider("Builder", "Rotate speed", 0, 100), 

            jit = menu.add_selection("Builder","Jitter mode",{"None", "Static", "random"}),
            jit_t = menu.add_selection("Builder","Jitter type",{"offset", "center"}),
            jit_add = menu.add_slider("Builder", "Jitter add", -180, 180), 

            side = menu.add_selection("Builder","Side",{"none", "left","right","jitter","peek fake","peek real"}),
            l_fake = menu.add_slider("Builder","L Fake", 0,100),
            r_fake = menu.add_slider("Builder","R Fake", 0,100),
            
            bl = menu.add_selection("Builder","Body Lean",{"none", "static","static jitter","random jitter","sway"}),
            bl_val = menu.add_slider("Builder", "Body Lean Value", -50, 50), 
            bl_jit = menu.add_slider("Builder", "Body Lean Jitter ", 0, 100),

            mov_bl = menu.add_checkbox("Builder","moving body lean",false),

        },

        mov = {
            yawb = menu.add_selection("Builder","Yaw Base",{"none", "View", "Crosshair", "Distance","Velocity"}),
            yawadd = menu.add_slider("Builder", "Yaw", -180, 180), 

            rotate = menu.add_checkbox("Builder","Rotate",false),
            rotate_r = menu.add_slider("Builder", "Rotate Range", 0, 360), 
            rotate_s = menu.add_slider("Builder", "Rotate speed", 0, 100), 

            jit = menu.add_selection("Builder","Jitter mode",{"None", "Static", "random"}),
            jit_t = menu.add_selection("Builder","Jitter type",{"offset", "center"}),
            jit_add = menu.add_slider("Builder", "Jitter add", -180, 180), 

            side = menu.add_selection("Builder","Side",{"none", "left","right","jitter","peek fake","peek real"}),
            l_fake = menu.add_slider("Builder","L Fake", 0,100),
            r_fake = menu.add_slider("Builder","R Fake", 0,100),
            
            bl = menu.add_selection("Builder","Body Lean",{"none", "static","static jitter","random jitter","sway"}),
            bl_val = menu.add_slider("Builder", "Body Lean Value", -50, 50), 
            bl_jit = menu.add_slider("Builder", "Body Lean Jitter ", 0, 100),

            mov_bl = menu.add_checkbox("Builder","moving body lean",false),

        },

        slowwalk = {
            yawb = menu.add_selection("Builder","Yaw Base",{"none", "View", "Crosshair", "Distance","Velocity"}),
            yawadd = menu.add_slider("Builder", "Yaw", -180, 180), 

            rotate = menu.add_checkbox("Builder","Rotate",false),
            rotate_r = menu.add_slider("Builder", "Rotate Range", 0, 360), 
            rotate_s = menu.add_slider("Builder", "Rotate speed", 0, 100), 

            jit = menu.add_selection("Builder","Jitter mode",{"None", "Static", "random"}),
            jit_t = menu.add_selection("Builder","Jitter type",{"offset", "center"}),
            jit_add = menu.add_slider("Builder", "Jitter add", -180, 180), 

            side = menu.add_selection("Builder","Side",{"none", "left","right","jitter","peek fake","peek real"}),
            l_fake = menu.add_slider("Builder","L Fake", 0,100),
            r_fake = menu.add_slider("Builder","R Fake", 0,100),

            bl = menu.add_selection("Builder","Body Lean",{"none", "static","static jitter","random jitter","sway"}),
            bl_val = menu.add_slider("Builder", "Body Lean Value", -50, 50), 
            bl_jit = menu.add_slider("Builder", "Body Lean Jitter ", 0, 100),

            mov_bl = menu.add_checkbox("Builder","moving body lean",false),

        },
        cr = {
            yawb = menu.add_selection("Builder","Yaw Base",{"none", "View", "Crosshair", "Distance","Velocity"}),
            yawadd = menu.add_slider("Builder", "Yaw", -180, 180), 

            rotate = menu.add_checkbox("Builder","Rotate",false),
            rotate_r = menu.add_slider("Builder", "Rotate Range", 0, 360), 
            rotate_s = menu.add_slider("Builder", "Rotate speed", 0, 100), 

            jit = menu.add_selection("Builder","Jitter mode",{"None", "Static", "random"}),
            jit_t = menu.add_selection("Builder","Jitter type",{"offset", "center"}),
            jit_add = menu.add_slider("Builder", "Jitter add", -180, 180), 

            side = menu.add_selection("Builder","Side",{"none", "left","right","jitter","peek fake","peek real"}),
            l_fake = menu.add_slider("Builder","L Fake", 0,100),
            r_fake = menu.add_slider("Builder","R Fake", 0,100),

            bl = menu.add_selection("Builder","Body Lean",{"none", "static","static jitter","random jitter","sway"}),
            bl_val = menu.add_slider("Builder", "Body Lean Value", -50, 50), 
            bl_jit = menu.add_slider("Builder", "Body Lean Jitter ", 0, 100),

            mov_bl = menu.add_checkbox("Builder","moving body lean",false),

        },
        
        in_air = {
            yawb = menu.add_selection("Builder","Yaw Base",{"none", "View", "Crosshair", "Distance","Velocity"}),
            yawadd = menu.add_slider("Builder", "Yaw", -180, 180), 

            rotate = menu.add_checkbox("Builder","Rotate",false),
            rotate_r = menu.add_slider("Builder", "Rotate Range", 0, 360), 
            rotate_s = menu.add_slider("Builder", "Rotate speed", 0, 100), 

            jit = menu.add_selection("Builder","Jitter mode",{"None", "Static", "random"}),
            jit_t = menu.add_selection("Builder","Jitter type",{"offset", "center"}),
            jit_add = menu.add_slider("Builder", "Jitter add", -180, 180), 

            side = menu.add_selection("Builder","Side",{"none", "left","right","jitter","peek fake","peek real"}),
            l_fake = menu.add_slider("Builder","L Fake", 0,100),
            r_fake = menu.add_slider("Builder","R Fake", 0,100),
            
            bl = menu.add_selection("Builder","Body Lean",{"none", "static","static jitter","random jitter","sway"}),
            bl_val = menu.add_slider("Builder", "Body Lean Value", -50, 50), 
            bl_jit = menu.add_slider("Builder", "Body Lean Jitter ", 0, 100),

            mov_bl = menu.add_checkbox("Builder","moving body lean",false),

        },


        cr_in_air = {
            yawb = menu.add_selection("Builder","Yaw Base",{"none", "View", "Crosshair", "Distance","Velocity"}),
            yawadd = menu.add_slider("Builder", "Yaw", -180, 180), 

            rotate = menu.add_checkbox("Builder","Rotate",false),
            rotate_r = menu.add_slider("Builder", "Rotate Range", 0, 360), 
            rotate_s = menu.add_slider("Builder", "Rotate speed", 0, 100), 

            jit = menu.add_selection("Builder","Jitter mode",{"None", "Static", "random"}),
            jit_t = menu.add_selection("Builder","Jitter type",{"offset", "center"}),
            jit_add = menu.add_slider("Builder", "Jitter add", -180, 180), 

            side = menu.add_selection("Builder","Side",{"none", "left","right","jitter","peek fake","peek real"}),
            l_fake = menu.add_slider("Builder","L Fake", 0,100),
            r_fake = menu.add_slider("Builder","R Fake", 0,100),
            
            bl = menu.add_selection("Builder","Body Lean",{"none", "static","static jitter","random jitter","sway"}),
            bl_val = menu.add_slider("Builder", "Body Lean Value", -50, 50), 
            bl_jit = menu.add_slider("Builder", "Body Lean Jitter ", 0, 100),

            mov_bl = menu.add_checkbox("Builder","moving body lean",false),


        },

        pressaa = {
            en_press = menu.add_checkbox("Builder","Enable Pressets",false),
            pressets_aa = menu.add_list("Builder","Pressets",{"Jitter", "JitterV2","Random","Test"}),
        },

    },
    mis = {
        --Visuals
        cros_ind = menu.add_checkbox("Visuals","Indicators",false),
        water_ind = menu.add_checkbox("Visuals","Watermark",false),
        hiders = menu.add_multi_selection("Visuals", "Hiders",{"Name","Username"}),
        --MISC
        killsay = menu.add_checkbox("Misc","Killsay",false),
        tag = menu.add_checkbox("Misc","Clantag",false),
        ml = menu.add_multi_selection("Anim", "Animations", {"0 pitch on land", "Static legs in air", "Moon walk","Lean"}),
    },
    ragebut = {
        legbr = menu.add_checkbox("Rage","Leg Breaker"),
        flos = menu.add_checkbox("Rage","Fake lag on shoot"),
        cs_log = menu.add_checkbox("Rage","Custom Log"),
        cs_log_sel = menu.add_multi_selection("Rage", "Custom Log",{"Chat","Console","Screen (NEED FIX)"}),
        
    },
}
marsmenu.tabs:set(2)
local texto = menu.add_text("Visuals", "Main color")
local colorp = texto:add_color_picker("MainColor",color_t(255, 255, 255, 255), true)

function visibilidad()
    
    b1:set_visible(marsmenu.tabs:get() == 2)
    b2:set_visible(marsmenu.tabs:get() == 2)

    --RAGE
    ---marsmenu.ragebut.fastfall:set_visible(marsmenu.tabs:get() == 1)
    marsmenu.ragebut.legbr:set_visible(marsmenu.tabs:get() == 1)
    marsmenu.ragebut.flos:set_visible(marsmenu.tabs:get() == 1)
    marsmenu.ragebut.cs_log:set_visible(marsmenu.tabs:get() == 1)
    marsmenu.ragebut.cs_log_sel:set_visible(marsmenu.tabs:get() == 1 and marsmenu.ragebut.cs_log:get(true))




    --MISC
    marsmenu.mis.hiders:set_visible(marsmenu.mis.water_ind:get() and marsmenu.tabs:get() == 3)
    marsmenu.mis.killsay:set_visible(marsmenu.tabs:get() == 3)
    marsmenu.mis.cros_ind:set_visible(marsmenu.tabs:get() == 3)
    marsmenu.mis.water_ind:set_visible(marsmenu.tabs:get() == 3)
    marsmenu.mis.tag:set_visible(marsmenu.tabs:get() == 3)
    marsmenu.mis.ml:set_visible(marsmenu.tabs:get() == 3)
    
    texto:set_visible(marsmenu.tabs:get() == 3)
    colorp:set_visible(marsmenu.tabs:get() == 3)


    -----------------------
    marsmenu.build:set_visible(marsmenu.tabs:get() == 2)
    -----------
    marsmenu.aat.pressaa.en_press:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 7)
    marsmenu.aat.pressaa.pressets_aa:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 7)
    --
    marsmenu.aat.stand.yawb:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1)
    marsmenu.aat.stand.yawadd:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1)

    marsmenu.aat.stand.rotate:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1)
    marsmenu.aat.stand.rotate_r:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1 and marsmenu.aat.stand.rotate:get() == true)
    marsmenu.aat.stand.rotate_s:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1 and marsmenu.aat.stand.rotate:get() == true)

    marsmenu.aat.stand.jit:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1)
    marsmenu.aat.stand.jit_t:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1)
    marsmenu.aat.stand.jit_add:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1)

    marsmenu.aat.stand.side:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1)
    marsmenu.aat.stand.l_fake:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1)
    marsmenu.aat.stand.r_fake:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1)

    marsmenu.aat.stand.bl:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1)
    marsmenu.aat.stand.bl_val:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1 and marsmenu.aat.stand.bl:get() == 2)
    if marsmenu.aat.stand.bl:get() == 3 or marsmenu.aat.stand.bl:get() == 4 then
        marsmenu.aat.stand.bl_jit:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1)
    else
        marsmenu.aat.stand.bl_jit:set_visible(false)
    end

    marsmenu.aat.stand.mov_bl:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 1)
    -----------
    marsmenu.aat.mov.yawb:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2)
    marsmenu.aat.mov.yawadd:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2)

    marsmenu.aat.mov.rotate:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2)
    marsmenu.aat.mov.rotate_r:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2 and marsmenu.aat.mov.rotate:get() == true)
    marsmenu.aat.mov.rotate_s:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2 and marsmenu.aat.mov.rotate:get() == true)

    marsmenu.aat.mov.jit:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2)
    marsmenu.aat.mov.jit_t:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2)
    marsmenu.aat.mov.jit_add:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2)

    marsmenu.aat.mov.side:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2)
    marsmenu.aat.mov.l_fake:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2)
    marsmenu.aat.mov.r_fake:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2)

    marsmenu.aat.mov.bl:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2)
    marsmenu.aat.mov.bl_val:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2 and marsmenu.aat.mov.bl:get() == 2)
    if marsmenu.aat.mov.bl:get() == 3 or marsmenu.aat.mov.bl:get() == 4 then
        marsmenu.aat.mov.bl_jit:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2)
    else
        marsmenu.aat.mov.bl_jit:set_visible(false)
    end

    marsmenu.aat.mov.mov_bl:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 2)
    ----------
    marsmenu.aat.slowwalk.yawb:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3)
    marsmenu.aat.slowwalk.yawadd:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3)

    marsmenu.aat.slowwalk.rotate:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3)
    marsmenu.aat.slowwalk.rotate_r:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3 and marsmenu.aat.slowwalk.rotate:get() == true)
    marsmenu.aat.slowwalk.rotate_s:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3 and marsmenu.aat.slowwalk.rotate:get() == true)

    marsmenu.aat.slowwalk.jit:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3)
    marsmenu.aat.slowwalk.jit_t:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3)
    marsmenu.aat.slowwalk.jit_add:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3)

    marsmenu.aat.slowwalk.side:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3)
    marsmenu.aat.slowwalk.l_fake:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3)
    marsmenu.aat.slowwalk.r_fake:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3)

    marsmenu.aat.slowwalk.bl:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3)
    marsmenu.aat.slowwalk.bl_val:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3 and marsmenu.aat.slowwalk.bl:get() == 2)
    if marsmenu.aat.slowwalk.bl:get() == 3 or marsmenu.aat.slowwalk.bl:get() == 4 then
        marsmenu.aat.slowwalk.bl_jit:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3)
    else
        marsmenu.aat.slowwalk.bl_jit:set_visible(false)
    end

    marsmenu.aat.slowwalk.mov_bl:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 3)
    ------------
    marsmenu.aat.cr.yawb:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4)
    marsmenu.aat.cr.yawadd:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4)

    marsmenu.aat.cr.rotate:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4)
    marsmenu.aat.cr.rotate_r:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4 and marsmenu.aat.cr.rotate:get() == true)
    marsmenu.aat.cr.rotate_s:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4 and marsmenu.aat.cr.rotate:get() == true)
    
    marsmenu.aat.cr.jit:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4)
    marsmenu.aat.cr.jit_t:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4)
    marsmenu.aat.cr.jit_add:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4)

    marsmenu.aat.cr.side:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4)
    marsmenu.aat.cr.l_fake:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4)
    marsmenu.aat.cr.r_fake:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4)

    marsmenu.aat.cr.bl:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4)
    marsmenu.aat.cr.bl_val:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4 and marsmenu.aat.cr.bl:get() == 2)
    if marsmenu.aat.cr.bl:get() == 3 or marsmenu.aat.cr.bl:get() == 4 then
        marsmenu.aat.cr.bl_jit:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4)
    else
        marsmenu.aat.cr.bl_jit:set_visible(false)
    end

    marsmenu.aat.cr.mov_bl:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 4)
    --
    marsmenu.aat.in_air.yawb:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5)
    marsmenu.aat.in_air.yawadd:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5)

    marsmenu.aat.in_air.rotate:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5)
    marsmenu.aat.in_air.rotate_r:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5 and marsmenu.aat.in_air.rotate:get() == true)
    marsmenu.aat.in_air.rotate_s:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5 and marsmenu.aat.in_air.rotate:get() == true)

    marsmenu.aat.in_air.jit:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5)
    marsmenu.aat.in_air.jit_t:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5)
    marsmenu.aat.in_air.jit_add:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5)

    marsmenu.aat.in_air.side:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5)
    marsmenu.aat.in_air.l_fake:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5)
    marsmenu.aat.in_air.r_fake:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5)

    marsmenu.aat.in_air.bl:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5)
    marsmenu.aat.in_air.bl_val:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5 and marsmenu.aat.in_air.bl:get() == 2)
    if marsmenu.aat.in_air.bl:get() == 3 or marsmenu.aat.in_air.bl:get() == 4 then
        marsmenu.aat.in_air.bl_jit:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5)
    else
        marsmenu.aat.in_air.bl_jit:set_visible(false)
    end
    
    marsmenu.aat.in_air.mov_bl:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 5)
    --
    marsmenu.aat.cr_in_air.yawb:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6)
    marsmenu.aat.cr_in_air.yawadd:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6)

    marsmenu.aat.cr_in_air.rotate:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6)
    marsmenu.aat.cr_in_air.rotate_r:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6 and marsmenu.aat.cr_in_air.rotate:get() == true)
    marsmenu.aat.cr_in_air.rotate_s:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6 and marsmenu.aat.cr_in_air.rotate:get() == true)

    marsmenu.aat.cr_in_air.jit:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6)
    marsmenu.aat.cr_in_air.jit_t:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6)
    marsmenu.aat.cr_in_air.jit_add:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6)

    marsmenu.aat.cr_in_air.side:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6)
    marsmenu.aat.cr_in_air.l_fake:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6)
    marsmenu.aat.cr_in_air.r_fake:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6)

    marsmenu.aat.cr_in_air.bl:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6)
    marsmenu.aat.cr_in_air.bl_val:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6 and marsmenu.aat.cr_in_air.bl:get() == 2)
    if marsmenu.aat.cr_in_air.bl:get() == 3 or marsmenu.aat.cr_in_air.bl:get() == 4 then
        marsmenu.aat.cr_in_air.bl_jit:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6)
    else
        marsmenu.aat.cr_in_air.bl_jit:set_visible(false)
    end

    marsmenu.aat.cr_in_air.mov_bl:set_visible(marsmenu.tabs:get() == 2 and marsmenu.build:get() == 6)
    
    
end

local function defcfg()
    marsmenu.mis.cros_ind:set(true)
    marsmenu.mis.water_ind:set(true)
    marsmenu.mis.hiders:set(2, true)
    marsmenu.mis.killsay:set(false)
    marsmenu.mis.tag:set(false)
    marsmenu.mis.ml:set(1,false)
    marsmenu.mis.ml:set(2,true)
    marsmenu.mis.ml:set(3,false)
    marsmenu.mis.ml:set(4,false)
    marsmenu.ragebut.cs_log:set(true)
    marsmenu.ragebut.cs_log_sel:set(1,false)
    marsmenu.ragebut.cs_log_sel:set(2,true)
    marsmenu.ragebut.cs_log_sel:set(3,false)
    -----------------------
    marsmenu.build:set(1)
    -----------
    marsmenu.aat.pressaa.en_press(false)
    --
    marsmenu.aat.stand.yawb:set(3)
    marsmenu.aat.stand.yawadd:set(15)

    marsmenu.aat.stand.rotate:set(false)

    marsmenu.aat.stand.jit:set(2)
    marsmenu.aat.stand.jit_t:set(2)
    marsmenu.aat.stand.jit_add:set(16)

    marsmenu.aat.stand.side:set(4)
    marsmenu.aat.stand.l_fake:set(45)
    marsmenu.aat.stand.r_fake:set(46)

    marsmenu.aat.stand.bl:set(4)
    marsmenu.aat.stand.bl_jit:set(100)

    marsmenu.aat.stand.mov_bl:set(true)
    -----------
    marsmenu.aat.mov.yawb:set(3)
    marsmenu.aat.mov.yawadd:set(15)

    marsmenu.aat.mov.rotate:set(false)

    marsmenu.aat.mov.jit:set(2)
    marsmenu.aat.mov.jit_t:set(2)
    marsmenu.aat.mov.jit_add:set(16)

    marsmenu.aat.mov.side:set(4)
    marsmenu.aat.mov.l_fake:set(45)
    marsmenu.aat.mov.r_fake:set(47)

    marsmenu.aat.mov.bl:set(4)
    marsmenu.aat.mov.bl_jit:set(100)

    marsmenu.aat.mov.mov_bl:set(false)
    ----------
    marsmenu.aat.slowwalk.yawb:set(3)
    marsmenu.aat.slowwalk.yawadd:set(16)

    marsmenu.aat.slowwalk.rotate:set(false)

    marsmenu.aat.slowwalk.jit:set(2)
    marsmenu.aat.slowwalk.jit_t:set(2)
    marsmenu.aat.slowwalk.jit_add:set(16)

    marsmenu.aat.slowwalk.side:set(4)
    marsmenu.aat.slowwalk.l_fake:set(46)
    marsmenu.aat.slowwalk.r_fake:set(45)

    marsmenu.aat.slowwalk.bl:set(4)
    marsmenu.aat.slowwalk.bl_jit:set(100)

    marsmenu.aat.slowwalk.mov_bl:set(true)
    ------------
    marsmenu.aat.cr.yawb:set(3)
    marsmenu.aat.cr.yawadd:set(17)

    marsmenu.aat.cr.rotate:set(false)
    
    marsmenu.aat.cr.jit:set(2)
    marsmenu.aat.cr.jit_t:set(2)
    marsmenu.aat.cr.jit_add:set(16)

    marsmenu.aat.cr.side:set(4)
    marsmenu.aat.cr.l_fake:set(56)
    marsmenu.aat.cr.r_fake:set(45)

    marsmenu.aat.cr.bl:set(4)
    marsmenu.aat.cr.bl_jit:set(100)


    marsmenu.aat.cr.mov_bl:set(true)
    --
    marsmenu.aat.in_air.yawb:set(3)
    marsmenu.aat.in_air.yawadd:set(12)

    marsmenu.aat.in_air.rotate:set(false)

    marsmenu.aat.in_air.jit:set(2)
    marsmenu.aat.in_air.jit_t:set(2)
    marsmenu.aat.in_air.jit_add:set(15)

    marsmenu.aat.in_air.side:set(4)
    marsmenu.aat.in_air.l_fake:set(46)
    marsmenu.aat.in_air.r_fake:set(47)

    marsmenu.aat.in_air.bl:set(4)
    marsmenu.aat.in_air.bl_jit:set(100)
    
    marsmenu.aat.in_air.mov_bl:set(false)
    --
    marsmenu.aat.cr_in_air.yawb:set(3)
    marsmenu.aat.cr_in_air.yawadd:set(-17)

    marsmenu.aat.cr_in_air.rotate:set(false)

    marsmenu.aat.cr_in_air.jit:set(2)
    marsmenu.aat.cr_in_air.jit_t:set(2)
    marsmenu.aat.cr_in_air.jit_add:set(17)

    marsmenu.aat.cr_in_air.side:set(4)
    marsmenu.aat.cr_in_air.l_fake:set(50)
    marsmenu.aat.cr_in_air.r_fake:set(60)

    marsmenu.aat.cr_in_air.bl:set(4)
    marsmenu.aat.cr_in_air.bl_jit:set(100)
    marsmenu.aat.cr_in_air.mov_bl:set(true)
    --
    marsmenu.ragebut.legbr:set(true)
    marsmenu.ragebut.flos:set(true)
    
    --
    
    --notifications:add_notification("MARS.UTILITIES", "Default cfg loaded", 3)
end
local button = menu.add_button("MARS", "Default cfg", defcfg)


local function dc()
    clip.set("https://discord.gg/EZcgAgBp4x")
    --notifications:add_notification("MARS.UTILITIES", "Discord link was copied", 3)
end

local button2 = menu.add_button("MARS", "Discord", dc)


function elaa()
    slowwalking = vars.player_state == "slowwalking"
    aircr = vars.player_state == "duck_in_air"
    air = vars.player_state == "in_air"
    cring = vars.player_state == "crouching"
    moving = vars.player_state == "moving"
    standing = vars.player_state == "Standing"

    if marsmenu.aat.pressaa.en_press:get() == true then
        --{"Jitter", "JitterV2","Test"}),
        if marsmenu.aat.pressaa.pressets_aa:get() == 1 then
            ref.general.yawb:set(3)
            ref.general.yawadd:set(math.random(-6,6))

            ref.rot.rotate:set(false)

            ref.jitter.jit:set(2)
            ref.jitter.jit_t:set(2)
            ref.jitter.jit_add:set(3)

            ref.lean.bl:set(2)
            ref.lean.bl_val:set(50)
            ref.lean.mov_bl:set(false)

            ref.desync.stand.side:set(math.random(2,3))
            ref.desync.stand.left_Amount:set(math.random(100,70))
            ref.desync.stand.right_Amount:set(math.random(100,70))
        elseif marsmenu.aat.pressaa.pressets_aa:get() == 2 then
            ref.general.yawb:set(3)
            ref.general.yawadd:set(-6)

            ref.rot.rotate:set(false)

            ref.jitter.jit:set(2)
            ref.jitter.jit_t:set(2)
            ref.jitter.jit_add:set(3)

            ref.lean.bl:set(3)
            --ref.lean.bl_val:set(50)
            ref.lean.bl_jit:set(20)
            ref.lean.mov_bl:set(false)

            ref.desync.stand.side:set(math.random(2,3))
            ref.desync.stand.left_Amount:set(100)
            ref.desync.stand.right_Amount:set(100)
        elseif marsmenu.aat.pressaa.pressets_aa:get() == 3 then
            local rn = math.random((math.random(math.random(39,-4),math.random(38,43))),(math.random(math.random(6,-26),math.random(33,21)))) - math.random((math.random(math.random(39,-4),math.random(38,43))),(math.random(math.random(6,-26),math.random(33,21)))) + math.random((math.random(math.random(39,-4),math.random(38,43))),(math.random(math.random(6,-26),math.random(33,21))))

            ref.general.yawb:set(3)
            ref.general.yawadd:set(math.random(math.random(1,20),math.random(1,-20)))--6
            --print(math.random(math.random(1,10),math.random(1,-10)))
            ref.rot.rotate:set(false)

            ref.jitter.jit:set(2)
            ref.jitter.jit_t:set(2)
            ref.jitter.jit_add:set(rn)

            ref.lean.bl:set(3)
            --ref.lean.bl_val:set(50)
            ref.lean.bl_jit:set(rn)
            ref.lean.mov_bl:set(true)

            ref.desync.stand.side:set(math.random(2,3))
            ref.desync.stand.left_Amount:set(100)
            ref.desync.stand.right_Amount:set(100)
        elseif marsmenu.aat.pressaa.pressets_aa:get() == 4 then
           -- ref.general.fl
            if globals.tick_count() % 15 == math.random(0,1) and velocity > 20 then
                ref.general.fl:set(1)
                --ref.general.pitch:set(3)
                
                local random_number = math.random() > 0.5 and 104 or -104
                local second_random_number = -random_number
                ref.general.yawadd:set(random_number)
            else
                --ref.general.pitch:set(2)
                ref.general.fl:set(15)
                ref.general.yawadd:set(math.random(9,-37))
            end
            ref.general.yawb:set(3)
            --ref.general.yawadd:set(math.random(9,-58))

            ref.rot.rotate:set(false)

            ref.jitter.jit:set(2)
            ref.jitter.jit_t:set(2)
            ref.jitter.jit_add:set(17)

            ref.lean.bl:set(1)
            --ref.lean.bl_val:set(50)
            ref.lean.bl_jit:set(0)
            ref.lean.mov_bl:set(false)

            ref.desync.stand.side:set(math.random(2,3))
            ref.desync.stand.left_Amount:set(100)
            ref.desync.stand.right_Amount:set(100)
        end
    
    elseif marsmenu.aat.pressaa.en_press:get() == false then
        if standing then
            ref.general.yawb:set(marsmenu.aat.stand.yawb:get())
            ref.general.yawadd:set(marsmenu.aat.stand.yawadd:get())

            ref.rot.rotate:set(marsmenu.aat.stand.rotate:get())
            if marsmenu.aat.stand.rotate:get() == true then
                ref.rot.rotate_r:set(marsmenu.aat.stand.rotate_r:get())
                ref.rot.rotate_s:set(marsmenu.aat.stand.rotate_s:get())
            end

            ref.jitter.jit:set(marsmenu.aat.stand.jit:get())
            ref.jitter.jit_t:set(marsmenu.aat.stand.jit_t:get())
            ref.jitter.jit_add:set(marsmenu.aat.stand.jit_add:get())

            ref.lean.bl:set(marsmenu.aat.stand.bl:get())
            ref.lean.bl_val:set(marsmenu.aat.stand.bl_val:get())
            ref.lean.bl_jit:set(marsmenu.aat.stand.bl_jit:get())
            ref.lean.mov_bl:set(marsmenu.aat.stand.mov_bl:get())

            ref.desync.stand.side:set(marsmenu.aat.stand.side:get())
            ref.desync.stand.left_Amount:set(marsmenu.aat.stand.l_fake:get())
            ref.desync.stand.right_Amount:set(marsmenu.aat.stand.r_fake:get())

        elseif moving then
            ref.general.yawb:set(marsmenu.aat.mov.yawb:get())
            ref.general.yawadd:set(marsmenu.aat.mov.yawadd:get())

            ref.rot.rotate:set(marsmenu.aat.mov.rotate:get())
            if marsmenu.aat.mov.rotate:get() == true then
                ref.rot.rotate_r:set(marsmenu.aat.mov.rotate_r:get())
                ref.rot.rotate_s:set(marsmenu.aat.mov.rotate_s:get())
            end

            ref.jitter.jit:set(marsmenu.aat.mov.jit:get())
            ref.jitter.jit_t:set(marsmenu.aat.mov.jit_t:get())
            ref.jitter.jit_add:set(marsmenu.aat.mov.jit_add:get())

            ref.lean.bl:set(marsmenu.aat.mov.bl:get())
            ref.lean.bl_val:set(marsmenu.aat.mov.bl_val:get())
            ref.lean.bl_jit:set(marsmenu.aat.mov.bl_jit:get())
            ref.lean.mov_bl:set(marsmenu.aat.mov.mov_bl:get())

            ref.desync.move.override:set(true)
            ref.desync.move.side:set(marsmenu.aat.mov.side:get())
            ref.desync.move.left_Amount:set(marsmenu.aat.mov.l_fake:get())
            ref.desync.move.right_Amount:set(marsmenu.aat.mov.r_fake:get())

        elseif slowwalking then
            ref.general.yawb:set(marsmenu.aat.slowwalk.yawb:get())
            ref.general.yawadd:set(marsmenu.aat.slowwalk.yawadd:get())

            ref.rot.rotate:set(marsmenu.aat.slowwalk.rotate:get())
            if marsmenu.aat.slowwalk.rotate:get() == true then
                ref.rot.rotate_r:set(marsmenu.aat.slowwalk.rotate_r:get())
                ref.rot.rotate_s:set(marsmenu.aat.slowwalk.rotate_s:get())
            end

            ref.jitter.jit:set(marsmenu.aat.slowwalk.jit:get())
            ref.jitter.jit_t:set(marsmenu.aat.slowwalk.jit_t:get())
            ref.jitter.jit_add:set(marsmenu.aat.slowwalk.jit_add:get())

            ref.lean.bl:set(marsmenu.aat.slowwalk.bl:get())
            ref.lean.bl_val:set(marsmenu.aat.slowwalk.bl_val:get())
            ref.lean.bl_jit:set(marsmenu.aat.slowwalk.bl_jit:get())
            ref.lean.mov_bl:set(marsmenu.aat.slowwalk.mov_bl:get())

            ref.desync.move.override:set(true)
            ref.desync.move.side:set(marsmenu.aat.slowwalk.side:get())
            ref.desync.move.left_Amount:set(marsmenu.aat.slowwalk.l_fake:get())
            ref.desync.move.right_Amount:set(marsmenu.aat.slowwalk.r_fake:get())

        elseif cring then
            ref.general.yawb:set(marsmenu.aat.cr.yawb:get())
            ref.general.yawadd:set(marsmenu.aat.cr.yawadd:get())

            ref.rot.rotate:set(marsmenu.aat.cr.rotate:get())
            if marsmenu.aat.cr.rotate:get() == true then
                ref.rot.rotate_r:set(marsmenu.aat.cr.rotate_r:get())
                ref.rot.rotate_s:set(marsmenu.aat.cr.rotate_s:get())
            end

            ref.jitter.jit:set(marsmenu.aat.cr.jit:get())
            ref.jitter.jit_t:set(marsmenu.aat.cr.jit_t:get())
            ref.jitter.jit_add:set(marsmenu.aat.cr.jit_add:get())

            ref.lean.bl:set(marsmenu.aat.cr.bl:get())
            ref.lean.bl_val:set(marsmenu.aat.cr.bl_val:get())
            ref.lean.bl_jit:set(marsmenu.aat.cr.bl_jit:get())
            ref.lean.mov_bl:set(marsmenu.aat.cr.mov_bl:get())

            ref.desync.move.override:set(true)
            ref.desync.move.side:set(marsmenu.aat.cr.side:get())
            ref.desync.move.left_Amount:set(marsmenu.aat.cr.l_fake:get())
            ref.desync.move.right_Amount:set(marsmenu.aat.cr.r_fake:get())

        elseif air then
            ref.general.yawb:set(marsmenu.aat.in_air.yawb:get())
            ref.general.yawadd:set(marsmenu.aat.in_air.yawadd:get())

            ref.rot.rotate:set(marsmenu.aat.in_air.rotate:get())
            if marsmenu.aat.in_air.rotate:get() == true then
                ref.rot.rotate_r:set(marsmenu.aat.in_air.rotate_r:get())
                ref.rot.rotate_s:set(marsmenu.aat.in_air.rotate_s:get())
            end

            ref.jitter.jit:set(marsmenu.aat.in_air.jit:get())
            ref.jitter.jit_t:set(marsmenu.aat.in_air.jit_t:get())
            ref.jitter.jit_add:set(marsmenu.aat.in_air.jit_add:get())

            ref.lean.bl:set(marsmenu.aat.in_air.bl:get())
            ref.lean.bl_val:set(marsmenu.aat.in_air.bl_val:get())
            ref.lean.bl_jit:set(marsmenu.aat.in_air.bl_jit:get())
            ref.lean.mov_bl:set(marsmenu.aat.in_air.mov_bl:get())

            ref.desync.move.override:set(true)
            ref.desync.move.side:set(marsmenu.aat.in_air.side:get())
            ref.desync.move.left_Amount:set(marsmenu.aat.in_air.l_fake:get())
            ref.desync.move.right_Amount:set(marsmenu.aat.in_air.r_fake:get())

        elseif aircr then
            ref.general.yawb:set(marsmenu.aat.cr_in_air.yawb:get())
            ref.general.yawadd:set(marsmenu.aat.cr_in_air.yawadd:get())

            ref.rot.rotate:set(marsmenu.aat.cr_in_air.rotate:get())
            if marsmenu.aat.cr_in_air.rotate:get() == true then
                ref.rot.rotate_r:set(marsmenu.aat.cr_in_air.rotate_r:get())
                ref.rot.rotate_s:set(marsmenu.aat.cr_in_air.rotate_s:get())
            end

            ref.jitter.jit:set(marsmenu.aat.cr_in_air.jit:get())
            ref.jitter.jit_t:set(marsmenu.aat.cr_in_air.jit_t:get())
            ref.jitter.jit_add:set(marsmenu.aat.cr_in_air.jit_add:get())

            ref.lean.bl:set(marsmenu.aat.cr_in_air.bl:get())
            ref.lean.bl_val:set(marsmenu.aat.cr_in_air.bl_val:get())
            ref.lean.bl_jit:set(marsmenu.aat.cr_in_air.bl_jit:get())
            ref.lean.mov_bl:set(marsmenu.aat.cr_in_air.mov_bl:get())

            ref.desync.move.override:set(true)
            ref.desync.move.side:set(marsmenu.aat.cr_in_air.side:get())
            ref.desync.move.left_Amount:set(marsmenu.aat.cr_in_air.l_fake:get())
            ref.desync.move.right_Amount:set(marsmenu.aat.cr_in_air.r_fake:get())
        end
    end
end
local screensize = render.get_screen_size()
local x = screensize.x / 2
local y = screensize.y / 2
local offset_scope = 0
local ay = 40
local function animation(check, name, value, speed) 
    if check then 
        return name + (value - name) * global_vars.frame_time() * speed 
    else 
        return name - (value + name) * global_vars.frame_time() * speed-- add / 2 if u want goig back effect
        
    end
end

local pixel = render.create_font("Smallest Pixel-7", 9, 20, e_font_flags.OUTLINE)
local water_font = render.create_font("Verdana", 12, 15,e_font_flags.ANTIALIAS)
--local font = render.create_font("Verdana", 15, 300)
function indicator()
    if entity == nil then return end
    local scoped = entity:get_prop("m_bIsScoped") == 1
    local maxdt = exploits.get_max_charge()
    offset_scope = animation(scoped, offset_scope, 25, 10)

    if marsmenu.mis.cros_ind:get() == true then
        --ping = math.floor(1000 * engine.get_latency(e_latency_flows.OUTGOING) + engine.get_latency(e_latency_flows.INCOMING))


        if entity ~= nil then 
            
            --render.text(pixel, "Vendetta", vec2_t(x + offset_scope + 18, y+ay-15), color_t(color_acc:get().r, color_acc:get().g, color_acc:get().b, 255), true, true) 
            render.text(pixel, "MARS.UTILITIES", vec2_t(x + offset_scope + 25, y+ay-10), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), true, true) 
            if slowwalking and marsmenu.aat.pressaa.en_press:get() == false then
                render.text(pixel, "Slowwalk", vec2_t(x + offset_scope + 25, y+ay), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), true, true) 
            elseif aircr and marsmenu.aat.pressaa.en_press:get() == false then
                render.text(pixel, "Crouch In Air", vec2_t(x + offset_scope + 25, y+ay), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), true, true) 
            elseif air and marsmenu.aat.pressaa.en_press:get() == false then
                render.text(pixel, "In Air", vec2_t(x + offset_scope + 25, y+ay), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), true, true) 
            elseif cring and marsmenu.aat.pressaa.en_press:get() == false then
                render.text(pixel, "Crouching", vec2_t(x + offset_scope + 25, y+ay), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), true, true) 
            elseif moving and marsmenu.aat.pressaa.en_press:get() == false then
                render.text(pixel, "Moving", vec2_t(x + offset_scope + 25, y+ay), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), true, true) 
            elseif standing and marsmenu.aat.pressaa.en_press:get() == false then
                render.text(pixel, "Standing", vec2_t(x + offset_scope + 25, y+ay), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), true, true) 
            elseif marsmenu.aat.pressaa.en_press:get() == true then

                if marsmenu.aat.pressaa.pressets_aa:get() == 1 then

                    render.text(pixel, "Jitter", vec2_t(x + offset_scope + 25, y+ay), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), true, true)

                elseif marsmenu.aat.pressaa.pressets_aa:get() == 2 then

                    render.text(pixel, "JitterV2", vec2_t(x + offset_scope + 25, y+ay), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), true, true) 

                elseif marsmenu.aat.pressaa.pressets_aa:get() == 3 then

                    render.text(pixel, "Random", vec2_t(x + offset_scope + 25, y+ay), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), true, true) 
                end
            end
            --marsmenu.aat.pressaa.pressets_aa:get()
            if ref.general.dt[2]:get() then
                --print(exploits.get_charge())
                if ref.general.hs[2]:get() == false then
                    if exploits.get_charge() == maxdt then
                        render.text(pixel, "DT", vec2_t(x + offset_scope + 25, y+ay + 10), color_t(0, 255, 0, 255), true, true) 
         
                    elseif exploits.get_charge() ~= maxdt then
                        render.text(pixel, "DT", vec2_t(x + offset_scope + 25, y+ay + 10), color_t(255, 0, 0, 255), true, true) 
                    end
                else
                    render.text(pixel, "HS", vec2_t(x + offset_scope + 30, y+ay + 10), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), true, true) 
                    if exploits.get_charge() == maxdt then
                        render.text(pixel, "DT", vec2_t(x + offset_scope + 15, y+ay + 10), color_t(0, 255, 0, 255), true, true) 
                        --print(exploits.get_charge())
                    elseif exploits.get_charge() == maxdt then
                        render.text(pixel, "DT", vec2_t(x + offset_scope + 15, y+ay + 10), color_t(255, 0, 0, 255), true, true) 
                    end
                end
            end
            if ref.general.hs[2]:get() == true and ref.general.dt[2]:get() == false then
                render.text(pixel, "HS", vec2_t(x + offset_scope + 25, y+ay + 10), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), true, true) 
            end
        else
            return
        end
    end   
end
--WATERMARK s

callbacks.add(e_callbacks.DRAW_WATERMARK, function(ctx)
    if marsmenu.mis.water_ind:get() then
        --render.text(vec2_t(menu.get_pos().x, menu.get_pos().y), vec2_t(menu.get_pos().x + 11, 11), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), color_t(0, 0, 0), false)
        ping = math.floor(1000 * engine.get_latency(e_latency_flows.OUTGOING) + engine.get_latency(e_latency_flows.INCOMING))
        h, m, s = client.get_local_time()
        if marsmenu.mis.hiders:get(1) and marsmenu.mis.hiders:get(2) == false then
            if ping <= 1 then
                text = string.format(" %s | local | %02d:%02d:%02d", user.name, h, m, s)
            else
                text = string.format(" %s | %s ms | %02d:%02d:%02d", user.name, ping, h, m, s)
            end
        end
        if marsmenu.mis.hiders:get(2) and marsmenu.mis.hiders:get(1) == false then
            if ping < 1 then
                text = string.format("MARS.UTILITIES | local | %02d:%02d:%02d", h, m, s)
            else
                text = string.format("MARS.UTILITIES | %s ms | %02d:%02d:%02d", ping, h, m, s)
            end
        end
        if marsmenu.mis.hiders:get(1) and marsmenu.mis.hiders:get(2) then
            if ping <= 1 then
                text = string.format("local | %02d:%02d:%02d", h, m, s)
            else
                text = string.format("%s ms | %02d:%02d:%02d", ping, h, m, s)
            end
        end
        if marsmenu.mis.hiders:get(1) == false and marsmenu.mis.hiders:get(2) == false then
            if ping <= 1 then
                text = string.format("MARS.UTILITIES | %s | local | %02d:%02d:%02d", user.name, h, m, s)
            else
                text = string.format("MARS.UTILITIES | %s | %s ms | %02d:%02d:%02d", user.name, ping, h, m, s)
            end
        end
        local text_size = render.get_text_size(water_font, text)

        render.rect_filled(vec2_t(screensize.x - text_size.x - 17, 7), vec2_t(text_size.x + 11, text_size.y + 11), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), 3)
        render.rect_filled(vec2_t(screensize.x - text_size.x - 16, 8), vec2_t(text_size.x + 9, text_size.y + 9), color_t(0, 0, 0), 3)        
        render.text(water_font, text, vec2_t(screensize.x - text_size.x - 11, 12), color_t(255, 255, 255, 255))


        --

    end

    return ""
end)
--Trash talk
local mensajesdelks = {
    '1','imagine','*dead*',
    'bot','get 1','tapped',
    'hhh','eins','lol so bad',
    'get good','one tap','effortless',
    'Obliterating the competition','MARS on top','get fucked',
    'eat shit','fuck a baboon','suck my dingleberries','choke on steaming cum',
    'die in a fire','gas yourself','sit on garden shears','choke on scrotum',
    'shove a brick up your ass','swallow barbed wire','move to sweden','fuck a pig',
    'bow to me','suck my ball sweat','come back when you aren\'t garbage','i will piss on everything you love',
    'kill yourself','livestream suicide','neck yourself','go be black somewhere else',
    'rotate on it','choke on it','blow it out your ass',
    'go browse tumblr','go back to casual','sit on horse cock','drive off a cliff',
    'rape yourself','get raped by niggers','fuck right off','you mother is a whore',
    'come at me','go work the corner', 'you are literal cancer', 'get fucked',
    'eat shit', 'fuck a baboon','suck my dingleberries', 'choke on steaming cum', 'die in a fire',
    'gas yourself', 'sit on garden shears', 'choke on scrotum', 'shove a brick up your ass',
    'swallow barbed wire','fuck a pig', 'bow to me',
    'suck my ball sweat', 'come back when you aren\'t garbage','i will piss on everything you love',
    'kill yourself','livestream suicide','neck yourself','go be black somewhere else',
    'rotate on it','choke on it', 'blow it out your ass','go browse tumblr','go back to casual', 'sit on horse cock',
    'drive off a cliff','rape yourself', 'get raped by niggers','fuck right off',
    'you mother is a whore','come at me','go work the corner',
    'you are literal cancer',"dead?","Mars is above",
    "miss?","no shoot?","get good get Mars","axaxax"

}
local function on_event(event)
    if marsmenu.mis.killsay:get() then
        local lp = entity_list.get_local_player()
        if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end
        engine.execute_cmd("say ".. mensajesdelks[math.random(1, #mensajesdelks)])
    end
end


function legbrr()
    if marsmenu.ragebut.legbr:get() == true then
        if globals.tick_count() % 4 == 2 then
            ref.general.leg:set(math.random(2,3))
        end
    end
end
--print(marsmenu.ragebut.cs_log_sel)

--CFGS
local cfg_data = {
    bools = {
        marsmenu.ragebut.legbr,
        marsmenu.ragebut.flos,
        marsmenu.ragebut.cs_log,


        marsmenu.mis.cros_ind,
        marsmenu.mis.water_ind,
        marsmenu.mis.killsay,
        marsmenu.mis.tag,
        --marsmenu.ragebut.cs_log_sel,

        --marsmenu.mis.hiders,

        marsmenu.aat.stand.rotate,
        marsmenu.aat.stand.mov_bl,
      
        marsmenu.aat.mov.rotate,
        marsmenu.aat.mov.mov_bl,
      
        marsmenu.aat.slowwalk.rotate,
        marsmenu.aat.slowwalk.mov_bl,
      
        marsmenu.aat.cr.rotate,
        marsmenu.aat.cr.mov_bl,
      
        marsmenu.aat.in_air.rotate,
        marsmenu.aat.in_air.mov_bl,
        
        marsmenu.aat.cr_in_air.rotate,
        marsmenu.aat.cr_in_air.mov_bl,
    },
    
    ints = {
        marsmenu.tabs,
        marsmenu.build,



        marsmenu.aat.stand.yawb,
        marsmenu.aat.stand.yawadd,
        marsmenu.aat.stand.rotate_r,
        marsmenu.aat.stand.rotate_s,
        marsmenu.aat.stand.jit,
        marsmenu.aat.stand.jit_t,
        marsmenu.aat.stand.jit_add,
        marsmenu.aat.stand.side,
        marsmenu.aat.stand.l_fake,
        marsmenu.aat.stand.r_fake,
        marsmenu.aat.stand.bl,
        marsmenu.aat.stand.bl_val,
        marsmenu.aat.stand.bl_jit,

        marsmenu.aat.mov.yawb,
        marsmenu.aat.mov.yawadd,
        marsmenu.aat.mov.rotate_r,
        marsmenu.aat.mov.rotate_s,
        marsmenu.aat.mov.jit,
        marsmenu.aat.mov.jit_t,
        marsmenu.aat.mov.jit_add,
        marsmenu.aat.mov.side,
        marsmenu.aat.mov.l_fake,
        marsmenu.aat.mov.r_fake,
        marsmenu.aat.mov.bl,
        marsmenu.aat.mov.bl_val,
        marsmenu.aat.mov.bl_jit,

        marsmenu.aat.slowwalk.yawb,
        marsmenu.aat.slowwalk.yawadd,
        marsmenu.aat.slowwalk.rotate_r,
        marsmenu.aat.slowwalk.rotate_s,
        marsmenu.aat.slowwalk.jit,
        marsmenu.aat.slowwalk.jit_t,
        marsmenu.aat.slowwalk.jit_add,
        marsmenu.aat.slowwalk.side,
        marsmenu.aat.slowwalk.l_fake,
        marsmenu.aat.slowwalk.r_fake,
        marsmenu.aat.slowwalk.bl,
        marsmenu.aat.slowwalk.bl_val,
        marsmenu.aat.slowwalk.bl_jit,

        marsmenu.aat.cr.yawb,
        marsmenu.aat.cr.yawadd,
        marsmenu.aat.cr.rotate_r,
        marsmenu.aat.cr.rotate_s,
        marsmenu.aat.cr.jit,
        marsmenu.aat.cr.jit_t,
        marsmenu.aat.cr.jit_add,
        marsmenu.aat.cr.side,
        marsmenu.aat.cr.l_fake,
        marsmenu.aat.cr.r_fake,
        marsmenu.aat.cr.bl,
        marsmenu.aat.cr.bl_val,
        marsmenu.aat.cr.bl_jit,

        marsmenu.aat.in_air.yawb,
        marsmenu.aat.in_air.yawadd,
        marsmenu.aat.in_air.rotate_r,
        marsmenu.aat.in_air.rotate_s,
        marsmenu.aat.in_air.jit,
        marsmenu.aat.in_air.jit_t,
        marsmenu.aat.in_air.jit_add,
        marsmenu.aat.in_air.side,
        marsmenu.aat.in_air.l_fake,
        marsmenu.aat.in_air.r_fake,
        marsmenu.aat.in_air.bl,
        marsmenu.aat.in_air.bl_val,
        marsmenu.aat.in_air.bl_jit,

        marsmenu.aat.cr_in_air.yawb,
        marsmenu.aat.cr_in_air.yawadd,
        marsmenu.aat.cr_in_air.rotate_r,
        marsmenu.aat.cr_in_air.rotate_s,
        marsmenu.aat.cr_in_air.jit,
        marsmenu.aat.cr_in_air.jit_t,
        marsmenu.aat.cr_in_air.jit_add,
        marsmenu.aat.cr_in_air.side,
        marsmenu.aat.cr_in_air.l_fake,
        marsmenu.aat.cr_in_air.r_fake,
        marsmenu.aat.cr_in_air.bl,
        marsmenu.aat.cr_in_air.bl_val,
        marsmenu.aat.cr_in_air.bl_jit,
        
    },

    floats = {
        --Ints con Decimales


    },

    strings = {
        -- textos
    }
}

b2 = menu.add_button("Misc", "Export", function()
    --common.add_notify("Exported","Successful exported cfg")
    local Code = {{}, {}, {}, {}, {}}

    for _, bools in pairs(cfg_data.bools) do
        table.insert(Code[1], bools:get())
    end

    for _, ints in pairs(cfg_data.ints) do
        table.insert(Code[2], ints:get())
    end

    for _, floats in pairs(cfg_data.floats) do
        table.insert(Code[3], floats:get())
    end

    for _, strings in pairs(cfg_data.strings) do
        table.insert(Code[4], strings:get())
    end
    local encoded = base64.encode(json.encode(Code))
    clip.set(encoded)
    --notifications:add_notification("MARS.UTILITIES", "Exported Cfg", 4)
end)
b1 = menu.add_button("Misc", "Import", function()
    local status, result = pcall(function()
        local decoded = base64.decode(clip.get())
        local data = json.parse(decoded)
        for k, v in pairs(data) do
            k = ({[1] = "bools", [2] = "ints", [3] = "floats", [4] = "strings", [5] = "colors"})[k]
            for k2, v2 in pairs(v) do
                if (k == "bools") then
                    cfg_data[k][k2]:set(v2)
                end
                if (k == "ints") then
                    cfg_data[k][k2]:set(v2)
                end
                if (k == "floats") then
                    cfg_data[k][k2]:set(v2)
                end
                if (k == "strings") then
                    cfg_data[k][k2]:set(v2)
                end
            end
        end
        --notifications:add_notification("MARS.UTILITIES", "Imported Cfg", 4)
    end)
    if not status then
        print("ERROR: " .. result)
        print("Export your CFG again")
        --notifications:add_notification("MARS.UTILITIES", "ERROR, Check console", 4)
    end
end)







local change_clantag = memory.find_pattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15")
local _set_clantag = ffi.cast("int(__fastcall*)(const char*, const char*)", change_clantag)
local _last_clantag = nil
local set_clantag = function(v)
  if v == _last_clantag then return end
  _set_clantag(v, v)
  _last_clantag = v
end

local build_tag = function(tag)
    local ret = {
"⌛ ",
"⌛ M",
"⌛ Ma",
"⌛ Mar",
"⌛ Mars",
"⌛ Mars",
"⌛ Mar",
"⌛ Ma",
"⌛ Ma",
"⌛ M",
"⌛ ",
"⌛",
}
  
  
    return ret
end

local tag = build_tag('⌛ Mars')

local clantag_animation = function()
    if engine.is_in_game() == false then return end
    local tickcount_pred = globals.tick_count()
    local iter = math.floor(math.fmod(tickcount_pred / 45, #tag + 1) + 1)
    if marsmenu.mis.tag:get() then
        set_clantag(tag[iter])
    else
        set_clantag(" ", " ")
    end

end
---
local hit_counter = 0
local text_to_show = ""
local show_text = false
local start_time = 0
local duration = 5 -- Duración en segundos
local last_shot_type = 0
local def_color = color_t(255, 255, 255, 255)

local groups = {
    "head", 
    "chest", 
    "stomach", 
    "left arm", 
    "right arm", 
    "left leg", 
    "right leg", 
    "neck", 
    "gear"
}
--marsmenu.ragebut.cs_log
--marsmenu.ragebut.cs_log_sel

local function on_aimbot_hit(shot)
    if marsmenu.ragebut.cs_log:get() then
        bt = math.floor(client.ticks_to_time(shot.backtrack_ticks) * 1000)
        if bt == nil then
            bt = 1
        else
            bt = bt
        end
        
        if marsmenu.ragebut.cs_log_sel:get(1) then
            chat.print("\x01Hit \x04", shot.player:get_name(), "\x01 in \x04", groups[shot.hitgroup] or "?","\x01 for \x04", shot.damage, "\x01 with \x04", bt, " ms " ,"\x01 remaining \x04" ,"(", shot.player:get_prop("m_iHealth"),")" )     
        end
        if marsmenu.ragebut.cs_log_sel:get(2) then
            client.log_screen(color_t(255, 255, 255),"Hit", color_t(0, 255, 0) ,shot.player:get_name(),color_t(255, 255, 255),"in", color_t(0, 255, 0) ,groups[shot.hitgroup] or "?",color_t(255, 255, 255),"for", color_t(0, 255, 0) ,shot.damage,color_t(255, 255, 255),"with", color_t(0, 255, 0) ,bt, "ms",color_t(255, 255, 255),"remaining", color_t(0, 255, 0) ,"(", shot.player:get_prop("m_iHealth"),")" )
        end
        if marsmenu.ragebut.cs_log_sel:get(3) then
            bt = math.floor(client.ticks_to_time(shot.backtrack_ticks) * 1000)
            if bt == nil then
                bt = 1
            else
                bt = bt
            end
            def_color = color_t(0, 175, 32, 255)
            hit_counter = hit_counter + 1
        
            text_to_show = "Hit ".. shot.player:get_name() .. " in " .. (groups[shot.hitgroup] or "?") .. " for ".. shot.damage.. " with "..bt.."ms" .. " remaining".." ("..shot.player:get_prop("m_iHealth")..")"
            show_text = true
            last_shot_type = 1
            start_time = globals.real_time()
        end
    end
end

local function on_aimbot_miss(miss)
    if marsmenu.ragebut.cs_log:get() then
        if marsmenu.ragebut.cs_log_sel:get(1) then
            chat.print("\x01Missed \x07", miss.player:get_name(),"\x01 in \x07", groups[miss.aim_hitgroup], "\x01 due to \x07", miss.reason_string)
        end
        if marsmenu.ragebut.cs_log_sel:get(2) then
            client.log_screen(color_t(255, 255, 255),"Missed", color_t(255, 0, 0),miss.player:get_name(),color_t(255, 255, 255),"in", color_t(255, 0, 0) , groups[miss.aim_hitgroup], color_t(255, 255, 255) ,"due to", color_t(255, 0, 0) ,miss.reason_string)
        end
        if marsmenu.ragebut.cs_log_sel:get(3) then
            def_color = color_t(255, 54, 54, 255)
            text_to_show = "Missed " .. miss.player:get_name().. " in ".. (groups[miss.aim_hitgroup]) .. " due to "..miss.reason_string
            --text_to_show = "Missed " .. miss.player:get_name().. " in ".. (groups[miss.aim_hitgroup]) .. " due to prediction error"
            show_text = true
            last_shot_type = 0
            start_time = globals.real_time()
        end
    end
end
callbacks.add(e_callbacks.PAINT, function()
    if show_text and start_time + 3 > globals.real_time() then
        local font1 = render.create_font("Smallest Pixel-7", 11, 20)
        local screensize = render.get_screen_size()
        local text_size = render.get_text_size(font1, tostring("["..hit_counter.."] " .. text_to_show))
        if last_shot_type == 1 then
            render.rect_filled(vec2_t(screensize.x/2 - text_size.x/2 - 2, screensize.y/2 + 390), vec2_t(text_size.x + 54  -24 , text_size.y + 11), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), 3)
            render.rect_filled(vec2_t(screensize.x/2 - text_size.x/2, screensize.y/2 + 390), vec2_t(text_size.x + 50 -24 , text_size.y + 11), color_t(0, 0, 0), 3)  
            def_color = color_t(0, 175, 32, 255)
            
        else
            render.rect_filled(vec2_t(screensize.x/2 - text_size.x/2 - 2, screensize.y/2 + 390), vec2_t(text_size.x + 54  -24 , text_size.y + 11), color_t(colorp:get().r, colorp:get().g, colorp:get().b, 255), 3)
            render.rect_filled(vec2_t(screensize.x/2 - text_size.x/2, screensize.y/2 + 390), vec2_t(text_size.x + 50 -24 , text_size.y + 11), color_t(0, 0, 0), 3)
            def_color = color_t(255, 54, 54, 255)
            
        end
        
        render.text(font1, "["..hit_counter.."] " .. text_to_show, vec2_t(screensize.x/2 - text_size.x/2 + 10, screensize.y/2 + 395), def_color)


    end
end)



local ground_tick = 1
local end_time = 0
local forcesendnextpacket = false

local function animbreakers(ctx)
    if not engine.is_connected() then return end
    if not entity_list.get_local_player():is_alive() then return end
    --if not aa_f.aa_animbreaker_check:get(true) then return end
    --local state = get_state(get_velocity())

    local flags = entity_list.get_local_player():get_prop("m_fFlags")
    local on_land = bit.band(flags, bit.lshift(1, 0)) ~= 0

    if on_land == true then
        ground_tick = ground_tick + 1
    else
        ground_tick = 0
        end_time = global_vars.cur_time() + 0.7
    end

    if marsmenu.mis.ml:get(1) and ground_tick > 1 and end_time > global_vars.cur_time() then
      ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
    end
    if bit.band(flags, 1) == 0  then --IN AIR
      if marsmenu.mis.ml:get(2) then
        ctx:set_render_pose(e_poses.JUMP_FALL, 1) -- STATIC LEGS
      end
      if marsmenu.mis.ml:get(3) then
        ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 1) 
      end
      if marsmenu.mis.ml:get(4) then
        ctx:set_render_animlayer(e_animlayers.LEAN, 1) -- Lean
      end

    end

    if marsmenu.ragebut.flos:get() then
        if forcesendnextpacket then
            ctx:set_fakelag(false) 
            forcesendnextpacket = false
        end
    end


end

callbacks.add(e_callbacks.AIMBOT_SHOOT, function(shot)
    forcesendnextpacket = true
end)

--print(forcesendnextpacket)

callbacks.add(e_callbacks.PAINT, function()
    entity = entity_list.get_local_player()
    visibilidad()
    elaa()  
    indicator()
    legbrr()
    clantag_animation()
end)
callbacks.add(e_callbacks.RUN_COMMAND, function(cmd)
    states()
end)
callbacks.add(e_callbacks.EVENT, on_event, "player_death")

callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)
callbacks.add(e_callbacks.AIMBOT_HIT, on_aimbot_hit)
callbacks.add(e_callbacks.SETUP_COMMAND)
callbacks.add(e_callbacks.ANTIAIM, animbreakers)