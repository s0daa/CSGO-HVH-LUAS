local easing = require("primordial/easing library.95")

-- Anti Aim
local type_cond = menu.add_selection("Anti Aim Main", "Condition", {"None", "Standing", "Running", "In Air", "Ducking", "Slowwalking"})


print("°°Loading Taiga°°")
print(".")
print("..")
print("...")
print("Have Fun Using My Lua ^^")




    
    


local ref = {
    slow_motion = menu.find("misc", "main", "movement", "slow walk"),
    yaw_add = menu.find("antiaim", "main", "angles", "yaw add"),
    jitter_mode = menu.find("antiaim", "main", "angles", "jitter mode"),
    jitter = menu.find("antiaim", "main", "angles", "jitter type"),
    jitter_am = menu.find("antiaim", "main", "angles", "jitter add"),
    lean_type = menu.find("antiaim", "main", "angles", "body lean"),
    lean_am = menu.find("antiaim", "main", "angles", "body lean value"),
    moving_lean = menu.find("antiaim", "main", "angles", "moving body lean"),
    D_side = menu.find("antiaim","main", "desync","side"),
    D_left = menu.find("antiaim","main", "desync","left amount"),
    D_right = menu.find("antiaim","main", "desync","right amount"),
    autopeek = menu.find("aimbot","general","misc","autopeek"),
    fakelag_am = menu.find("antiaim", "main", "fakelag", "amount"),
    isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable"),
    isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable"),
    isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable"),
    slowwalk                = menu.find("misc", "main", "movement", "slow walk")[2],
}

standing = {
    
yaw_mode = menu.add_selection("Anti-Aim", "[Standing] Yaw Mode", {"Static", "Sway",}),
yaw_add = menu.add_slider("Anti-Aim", "[Standing] Yaw Add", -180, 180,1),
yaw_left = menu.add_slider("Anti-Aim", "[Standing] Yaw Left", -180, 180, 1),
yaw_right = menu.add_slider("Anti-Aim", "[Standing] Yaw Right", -180, 180, 1),
jitter_mode = menu.add_selection("Anti-Aim", "[Standing] Jitter Type", {"None","Static", "Random",}),
jitter_type = menu.add_selection("Anti-Aim", "[Standing] Jitter Type", {"Center", "Offset","Alternative"}),
jitter_amount = menu.add_slider("Anti-Aim", "[Standing] Jitter Amount", -180, 180, 1),
dsy_mode = menu.add_selection("Anti-Aim", "[Standing] Desync Side", {"None","Left", "Right","Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
dsy_left_am = menu.add_slider("Anti-Aim", "[Standing] Desync Left", 0, 100, 1),
dsy_right_am = menu.add_slider("Anti-Aim", "[Standing] Desync Right", 0, 100, 1),


distort_slider = menu.add_slider("Anti-Aim", "[Standing] Sway Speed", 1, 15, 1),
Fakelag_mode = menu.add_selection("Fakelag","[Standing] Fakelag Mode", {"None","Static","Switch"}),
Fakelag_amount = menu.add_slider("Fakelag", "[Standing] Lag Amount", 0, 15, 1),
}

running = {

yaw_mode = menu.add_selection("Anti-Aim", "[Running] Yaw Mode", {"Static", "Sway",}),
yaw_add = menu.add_slider("Anti-Aim", "[Running] Yaw Add", -180, 180,1),
yaw_left = menu.add_slider("Anti-Aim", "[Running] Yaw Left", -180, 180, 1),
yaw_right = menu.add_slider("Anti-Aim", "[Running] Yaw Right", -180, 180, 1),
jitter_mode = menu.add_selection("Anti-Aim", "[Running] Jitter Type", {"None","Static", "Random",}),
jitter_type = menu.add_selection("Anti-Aim", "[Running] Jitter Type", {"Center", "Offset","Alternative"}),
jitter_amount = menu.add_slider("Anti-Aim", "[Running] Jitter Amount", -180, 180, 1),
dsy_mode = menu.add_selection("Anti-Aim", "[Running] Desync Side", {"None","Left", "Right","Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
dsy_left_am = menu.add_slider("Anti-Aim", "[Running] Desync Left", 0, 100, 1),
dsy_right_am = menu.add_slider("Anti-Aim", "[Running] Desync Right", 0, 100, 1),


distort_slider = menu.add_slider("Anti-Aim", "[Running] Sway Speed", 1, 15, 1),
Fakelag_mode = menu.add_selection("Fakelag","[Running] Fakelag Mode", {"None","Static","Switch", "Fluctuate"}),
Fakelag_amount = menu.add_slider("Fakelag", "[Running] Lag Amount", 0, 15, 1),
}

Slowwalk = {

    yaw_mode = menu.add_selection("Anti-Aim", "[Slowwalk] Yaw Mode", {"Static", "Sway",}),
    yaw_add = menu.add_slider("Anti-Aim", "[Slowwalk] Yaw Add", -180, 180,1),
    yaw_left = menu.add_slider("Anti-Aim", "[Slowwalk] Yaw Left", -180, 180, 1),
    yaw_right = menu.add_slider("Anti-Aim", "[Slowwalk] Yaw Right", -180, 180, 1),
    jitter_mode = menu.add_selection("Anti-Aim", "[Slowwalk] Jitter Type", {"None","Static", "Random",}),
    jitter_type = menu.add_selection("Anti-Aim", "[Slowwalk] Jitter Type", {"Center", "Offset","Alternative"}),
    jitter_amount = menu.add_slider("Anti-Aim", "[Slowwalk] Jitter Amount", -180, 180, 1),
    dsy_mode = menu.add_selection("Anti-Aim", "[Slowwalk] Desync Side", {"None","Left", "Right","Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
    dsy_left_am = menu.add_slider("Anti-Aim", "[Slowwalk] Desync Left", 0, 100, 1),
    dsy_right_am = menu.add_slider("Anti-Aim", "[Slowwalk] Desync Right", 0, 100, 1),


    distort_slider = menu.add_slider("Anti-Aim", "[Slowwalk] Sway Speed", 1, 15, 1),
    Fakelag_mode = menu.add_selection("Fakelag","[Slowwalk] Fakelag Mode", {"None","Static","Switch", "Fluctuate"}),
    Fakelag_amount = menu.add_slider("Fakelag", "[Slowwalk] Lag Amount", 0, 15, 1),

}

inAir = {

    yaw_mode = menu.add_selection("Anti-Aim", "[In Air] Yaw Mode", {"Static", "Sway",}),
    yaw_add = menu.add_slider("Anti-Aim", "[In Air] Yaw Add", -180, 180,1),
    yaw_left = menu.add_slider("Anti-Aim", "[In Air] Yaw Left", -180, 180, 1),
    yaw_right = menu.add_slider("Anti-Aim", "[In Air] Yaw Right", -180, 180, 1),
    jitter_mode = menu.add_selection("Anti-Aim", "[In Air] Jitter Type", {"None","Static", "Random",}),
    jitter_type = menu.add_selection("Anti-Aim", "[In Air] Jitter Type", {"Center", "Offset","Alternative"}),
    jitter_amount = menu.add_slider("Anti-Aim", "[In Air] Jitter Amount", -180, 180, 1),
    dsy_mode = menu.add_selection("Anti-Aim", "[In Air] Desync Side", {"None","Left", "Right","Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
    dsy_left_am = menu.add_slider("Anti-Aim", "[In Air] Desync Left", 0, 100, 1),
    dsy_right_am = menu.add_slider("Anti-Aim", "[In Air] Desync Right", 0, 100, 1),


    distort_slider = menu.add_slider("Anti-Aim", "[In Air] Sway Speed", 1, 15, 1),
    Fakelag_mode = menu.add_selection("Fakelag","[In Air] Fakelag Mode", {"None","Static","Switch", "Fluctuate"}),
    Fakelag_amount = menu.add_slider("Fakelag", "[In Air] Lag Amount", 0, 15, 1),

}


Duck = {

    yaw_mode = menu.add_selection("Anti-Aim", "[Duck] Yaw Mode", {"Static", "Sway",}),
    yaw_add = menu.add_slider("Anti-Aim", "[Duck] Yaw Add", -180, 180,1),
    yaw_left = menu.add_slider("Anti-Aim", "[Duck] Yaw Left", -180, 180, 1),
    yaw_right = menu.add_slider("Anti-Aim", "[Duck] Yaw Right", -180, 180, 1),
    jitter_mode = menu.add_selection("Anti-Aim", "[Duck] Jitter Type", {"None","Static", "Random",}),
    jitter_type = menu.add_selection("Anti-Aim", "[Duck] Jitter Type", {"Center", "Offset","Alternative"}),
    jitter_amount = menu.add_slider("Anti-Aim", "[Duck] Jitter Amount", -180, 180, 1),
    dsy_mode = menu.add_selection("Anti-Aim", "[Duck] Desync Side", {"None","Left", "Right","Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
    dsy_left_am = menu.add_slider("Anti-Aim", "[Duck] Desync Left", 0, 100, 1),
    dsy_right_am = menu.add_slider("Anti-Aim", "[Duck] Desync Right", 0, 100, 1),


    distort_slider = menu.add_slider("Anti-Aim", "[Duck] Sway Speed", 1, 15, 1),
    Fakelag_mode = menu.add_selection("Fakelag","[Duck] Fakelag Mode", {"None","Static","Switch", "Fluctuate"}),
    Fakelag_amount = menu.add_slider("Fakelag", "[Duck] Lag Amount", 0, 15, 1),

}


function menu_handler()
if type_cond:get() == 1 then


    standing.yaw_add:set_visible(false)
    standing.yaw_mode:set_visible(false)
    standing.yaw_left:set_visible(false)
    standing.yaw_right:set_visible(false)
    standing.jitter_mode:set_visible(false)
    standing.jitter_type:set_visible(false)
    standing.jitter_amount:set_visible(false)
    standing.dsy_mode:set_visible(false)
    standing.dsy_left_am:set_visible(false)
    standing.dsy_right_am:set_visible(false)


    standing.distort_slider:set_visible(false)
    standing.Fakelag_mode:set_visible(false)
    standing.Fakelag_amount:set_visible(false)
    
    running.yaw_add:set_visible(false)
    running.yaw_mode:set_visible(false)
    running.yaw_left:set_visible(false)
    running.yaw_right:set_visible(false)
    running.jitter_mode:set_visible(false)
    running.jitter_type:set_visible(false)
    running.jitter_amount:set_visible(false)
    running.dsy_mode:set_visible(false)
    running.dsy_left_am:set_visible(false)
    running.dsy_right_am:set_visible(false)


    running.distort_slider:set_visible(false)
    running.Fakelag_mode:set_visible(false)
    running.Fakelag_amount:set_visible(false)

    Slowwalk.yaw_add:set_visible(false)
    Slowwalk.yaw_mode:set_visible(false)
    Slowwalk.yaw_left:set_visible(false)
    Slowwalk.yaw_right:set_visible(false)
    Slowwalk.jitter_mode:set_visible(false)
    Slowwalk.jitter_type:set_visible(false)
    Slowwalk.jitter_amount:set_visible(false)
    Slowwalk.dsy_mode:set_visible(false)
    Slowwalk.dsy_left_am:set_visible(false)
    Slowwalk.dsy_right_am:set_visible(false)


    Slowwalk.distort_slider:set_visible(false)
    Slowwalk.Fakelag_mode:set_visible(false)
    Slowwalk.Fakelag_amount:set_visible(false)

    inAir.yaw_add:set_visible(false)
    inAir.yaw_mode:set_visible(false)
    inAir.yaw_left:set_visible(false)
    inAir.yaw_right:set_visible(false)
    inAir.jitter_mode:set_visible(false)
    inAir.jitter_type:set_visible(false)
    inAir.jitter_amount:set_visible(false)
    inAir.dsy_mode:set_visible(false)
    inAir.dsy_left_am:set_visible(false)
    inAir.dsy_right_am:set_visible(false)


    inAir.distort_slider:set_visible(false)
    inAir.Fakelag_mode:set_visible(false)
    inAir.Fakelag_amount:set_visible(false)

    Duck.yaw_add:set_visible(false)
    Duck.yaw_mode:set_visible(false)
    Duck.yaw_left:set_visible(false)
    Duck.yaw_right:set_visible(false)
    Duck.jitter_mode:set_visible(false)
    Duck.jitter_type:set_visible(false)
    Duck.jitter_amount:set_visible(false)
    Duck.dsy_mode:set_visible(false)
    Duck.dsy_left_am:set_visible(false)
    Duck.dsy_right_am:set_visible(false)


    Duck.distort_slider:set_visible(false)
    Duck.Fakelag_mode:set_visible(false)
    Duck.Fakelag_amount:set_visible(false)
end
 
if type_cond:get() == 2 then



    standing.yaw_add:set_visible(true)
    standing.yaw_mode:set_visible(true)
    if standing.dsy_mode:get() == 4 then 
    standing.yaw_left:set_visible(true)
    standing.yaw_right:set_visible(true)
    else
        standing.yaw_left:set_visible(false)
        standing.yaw_right:set_visible(false)
    end
    standing.jitter_mode:set_visible(true)
    standing.jitter_type:set_visible(true)
    standing.jitter_amount:set_visible(true)
    standing.dsy_mode:set_visible(true)
    standing.dsy_left_am:set_visible(true)
    standing.dsy_right_am:set_visible(true)


    standing.distort_slider:set_visible(true)
    standing.Fakelag_mode:set_visible(true)
    standing.Fakelag_amount:set_visible(true)
    
    running.yaw_add:set_visible(false)
    running.yaw_mode:set_visible(false)
    running.yaw_left:set_visible(false)
    running.yaw_right:set_visible(false)
    running.jitter_mode:set_visible(false)
    running.jitter_type:set_visible(false)
    running.jitter_amount:set_visible(false)
    running.dsy_mode:set_visible(false)
    running.dsy_left_am:set_visible(false)
    running.dsy_right_am:set_visible(false)


    running.distort_slider:set_visible(false)
    running.Fakelag_mode:set_visible(false)
    running.Fakelag_amount:set_visible(false)

    inAir.yaw_add:set_visible(false)
    inAir.yaw_mode:set_visible(false)
    inAir.yaw_left:set_visible(false)
    inAir.yaw_right:set_visible(false)
    inAir.jitter_mode:set_visible(false)
    inAir.jitter_type:set_visible(false)
    inAir.jitter_amount:set_visible(false)
    inAir.dsy_mode:set_visible(false)
    inAir.dsy_left_am:set_visible(false)
    inAir.dsy_right_am:set_visible(false)

    Slowwalk.yaw_add:set_visible(false)
    Slowwalk.yaw_mode:set_visible(false)
    Slowwalk.yaw_left:set_visible(false)
    Slowwalk.yaw_right:set_visible(false)
    Slowwalk.jitter_mode:set_visible(false)
    Slowwalk.jitter_type:set_visible(false)
    Slowwalk.jitter_amount:set_visible(false)
    Slowwalk.dsy_mode:set_visible(false)
    Slowwalk.dsy_left_am:set_visible(false)
    Slowwalk.dsy_right_am:set_visible(false)


    Slowwalk.distort_slider:set_visible(false)
    Slowwalk.Fakelag_mode:set_visible(false)
    Slowwalk.Fakelag_amount:set_visible(false)
    inAir.distort_slider:set_visible(false)
    inAir.Fakelag_mode:set_visible(false)
    inAir.Fakelag_amount:set_visible(false)

    Duck.yaw_add:set_visible(false)
    Duck.yaw_mode:set_visible(false)
    Duck.yaw_left:set_visible(false)
    Duck.yaw_right:set_visible(false)
    Duck.jitter_mode:set_visible(false)
    Duck.jitter_type:set_visible(false)
    Duck.jitter_amount:set_visible(false)
    Duck.dsy_mode:set_visible(false)
    Duck.dsy_left_am:set_visible(false)
    Duck.dsy_right_am:set_visible(false)


    Duck.distort_slider:set_visible(false)
    Duck.Fakelag_mode:set_visible(false)
    Duck.Fakelag_amount:set_visible(false)

end

if type_cond:get() == 3 then

    Slowwalk.yaw_add:set_visible(false)
    Slowwalk.yaw_mode:set_visible(false)
    Slowwalk.yaw_left:set_visible(false)
    Slowwalk.yaw_right:set_visible(false)
    Slowwalk.jitter_mode:set_visible(false)
    Slowwalk.jitter_type:set_visible(false)
    Slowwalk.jitter_amount:set_visible(false)
    Slowwalk.dsy_mode:set_visible(false)
    Slowwalk.dsy_left_am:set_visible(false)
    Slowwalk.dsy_right_am:set_visible(false)


    Slowwalk.distort_slider:set_visible(false)
    Slowwalk.Fakelag_mode:set_visible(false)
    Slowwalk.Fakelag_amount:set_visible(false)

    standing.yaw_add:set_visible(false)
    standing.yaw_mode:set_visible(false)
    standing.yaw_left:set_visible(false)
    standing.yaw_right:set_visible(false)
    standing.jitter_mode:set_visible(false)
    standing.jitter_type:set_visible(false)
    standing.jitter_amount:set_visible(false)
    standing.dsy_mode:set_visible(false)
    standing.dsy_left_am:set_visible(false)
    standing.dsy_right_am:set_visible(false)


    standing.distort_slider:set_visible(false)
    standing.Fakelag_mode:set_visible(false)
    standing.Fakelag_amount:set_visible(false)
    
    running.yaw_add:set_visible(true)
    running.yaw_mode:set_visible(true)
    if running.dsy_mode:get() == 4 then 
    running.yaw_left:set_visible(true)
    running.yaw_right:set_visible(true)
    else

        running.yaw_left:set_visible(false)
        running.yaw_right:set_visible(false)
    end
    running.jitter_mode:set_visible(true)
    running.jitter_type:set_visible(true)
    running.jitter_amount:set_visible(true)
    running.dsy_mode:set_visible(true)
    running.dsy_left_am:set_visible(true)
    running.dsy_right_am:set_visible(true)


    running.distort_slider:set_visible(true)
    running.Fakelag_mode:set_visible(true)
    running.Fakelag_amount:set_visible(true)

    inAir.yaw_add:set_visible(false)
    inAir.yaw_mode:set_visible(false)
    inAir.yaw_left:set_visible(false)
    inAir.yaw_right:set_visible(false)
    inAir.jitter_mode:set_visible(false)
    inAir.jitter_type:set_visible(false)
    inAir.jitter_amount:set_visible(false)
    inAir.dsy_mode:set_visible(false)
    inAir.dsy_left_am:set_visible(false)
    inAir.dsy_right_am:set_visible(false)


    inAir.distort_slider:set_visible(false)
    inAir.Fakelag_mode:set_visible(false)
    inAir.Fakelag_amount:set_visible(false)

    Duck.yaw_add:set_visible(false)
    Duck.yaw_mode:set_visible(false)
    Duck.yaw_left:set_visible(false)
    Duck.yaw_right:set_visible(false)
    Duck.jitter_mode:set_visible(false)
    Duck.jitter_type:set_visible(false)
    Duck.jitter_amount:set_visible(false)
    Duck.dsy_mode:set_visible(false)
    Duck.dsy_left_am:set_visible(false)
    Duck.dsy_right_am:set_visible(false)


    Duck.distort_slider:set_visible(false)
    Duck.Fakelag_mode:set_visible(false)
    Duck.Fakelag_amount:set_visible(false)

end

if type_cond:get() == 3 then

    Slowwalk.yaw_add:set_visible(false)
    Slowwalk.yaw_mode:set_visible(false)
    Slowwalk.yaw_left:set_visible(false)
    Slowwalk.yaw_right:set_visible(false)
    Slowwalk.jitter_mode:set_visible(false)
    Slowwalk.jitter_type:set_visible(false)
    Slowwalk.jitter_amount:set_visible(false)
    Slowwalk.dsy_mode:set_visible(false)
    Slowwalk.dsy_left_am:set_visible(false)
    Slowwalk.dsy_right_am:set_visible(false)


    Slowwalk.distort_slider:set_visible(false)
    Slowwalk.Fakelag_mode:set_visible(false)
    Slowwalk.Fakelag_amount:set_visible(false)

    standing.yaw_add:set_visible(false)
    standing.yaw_mode:set_visible(false)
    standing.yaw_left:set_visible(false)
    standing.yaw_right:set_visible(false)
    standing.jitter_mode:set_visible(false)
    standing.jitter_type:set_visible(false)
    standing.jitter_amount:set_visible(false)
    standing.dsy_mode:set_visible(false)
    standing.dsy_left_am:set_visible(false)
    standing.dsy_right_am:set_visible(false)


    standing.distort_slider:set_visible(false)
    standing.Fakelag_mode:set_visible(false)
    standing.Fakelag_amount:set_visible(false)
    
    running.yaw_add:set_visible(true)
    running.yaw_mode:set_visible(true)
    if  running.dsy_mode:get() == 4 then
    running.yaw_left:set_visible(true)
    running.yaw_right:set_visible(true)
    else
        running.yaw_left:set_visible(false)
        running.yaw_right:set_visible(false)
    end
    running.jitter_mode:set_visible(true)
    running.jitter_type:set_visible(true)
    running.jitter_amount:set_visible(true)
    running.dsy_mode:set_visible(true)
    running.dsy_left_am:set_visible(true)
    running.dsy_right_am:set_visible(true)


    running.distort_slider:set_visible(true)
    running.Fakelag_mode:set_visible(true)
    running.Fakelag_amount:set_visible(true)

    inAir.yaw_add:set_visible(false)
    inAir.yaw_mode:set_visible(false)
    inAir.yaw_left:set_visible(false)
    inAir.yaw_right:set_visible(false)
    inAir.jitter_mode:set_visible(false)
    inAir.jitter_type:set_visible(false)
    inAir.jitter_amount:set_visible(false)
    inAir.dsy_mode:set_visible(false)
    inAir.dsy_left_am:set_visible(false)
    inAir.dsy_right_am:set_visible(false)


    inAir.distort_slider:set_visible(false)
    inAir.Fakelag_mode:set_visible(false)
    inAir.Fakelag_amount:set_visible(false)

    Duck.yaw_add:set_visible(false)
    Duck.yaw_mode:set_visible(false)
    Duck.yaw_left:set_visible(false)
    Duck.yaw_right:set_visible(false)
    Duck.jitter_mode:set_visible(false)
    Duck.jitter_type:set_visible(false)
    Duck.jitter_amount:set_visible(false)
    Duck.dsy_mode:set_visible(false)
    Duck.dsy_left_am:set_visible(false)
    Duck.dsy_right_am:set_visible(false)


    Duck.distort_slider:set_visible(false)
    Duck.Fakelag_mode:set_visible(false)
    Duck.Fakelag_amount:set_visible(false)

end

if type_cond:get() == 4 then

    Slowwalk.yaw_add:set_visible(false)
    Slowwalk.yaw_mode:set_visible(false)
    Slowwalk.yaw_left:set_visible(false)
    Slowwalk.yaw_right:set_visible(false)
    Slowwalk.jitter_mode:set_visible(false)
    Slowwalk.jitter_type:set_visible(false)
    Slowwalk.jitter_amount:set_visible(false)
    Slowwalk.dsy_mode:set_visible(false)
    Slowwalk.dsy_left_am:set_visible(false)
    Slowwalk.dsy_right_am:set_visible(false)


    Slowwalk.distort_slider:set_visible(false)
    Slowwalk.Fakelag_mode:set_visible(false)
    Slowwalk.Fakelag_amount:set_visible(false)

    standing.yaw_add:set_visible(false)
    standing.yaw_mode:set_visible(false)
    standing.yaw_left:set_visible(false)
    standing.yaw_right:set_visible(false)
    standing.jitter_mode:set_visible(false)
    standing.jitter_type:set_visible(false)
    standing.jitter_amount:set_visible(false)
    standing.dsy_mode:set_visible(false)
    standing.dsy_left_am:set_visible(false)
    standing.dsy_right_am:set_visible(false)

    standing.distort_slider:set_visible(false)
    standing.Fakelag_mode:set_visible(false)
    standing.Fakelag_amount:set_visible(false)
    
    running.yaw_add:set_visible(false)
    running.yaw_mode:set_visible(false)
    running.yaw_left:set_visible(false)
    running.yaw_right:set_visible(false)
    running.jitter_mode:set_visible(false)
    running.jitter_type:set_visible(false)
    running.jitter_amount:set_visible(false)
    running.dsy_mode:set_visible(false)
    running.dsy_left_am:set_visible(false)
    running.dsy_right_am:set_visible(false)


    running.distort_slider:set_visible(false)
    running.Fakelag_mode:set_visible(false)
    running.Fakelag_amount:set_visible(false)

    inAir.yaw_add:set_visible(true)
    inAir.yaw_mode:set_visible(true)
    if inAir.dsy_mode:get() == 4 then
    inAir.yaw_left:set_visible(true)
    inAir.yaw_right:set_visible(true)
    else
        inAir.yaw_left:set_visible(false)
        inAir.yaw_right:set_visible(false)
    end
    inAir.jitter_mode:set_visible(true)
    inAir.jitter_type:set_visible(true)
    inAir.jitter_amount:set_visible(true)
    inAir.dsy_mode:set_visible(true)
    inAir.dsy_left_am:set_visible(true)
    inAir.dsy_right_am:set_visible(true)


    inAir.distort_slider:set_visible(true)
    inAir.Fakelag_mode:set_visible(true)
    inAir.Fakelag_amount:set_visible(true)

    Duck.yaw_add:set_visible(false)
    Duck.yaw_mode:set_visible(false)
    Duck.yaw_left:set_visible(false)
    Duck.yaw_right:set_visible(false)
    Duck.jitter_mode:set_visible(false)
    Duck.jitter_type:set_visible(false)
    Duck.jitter_amount:set_visible(false)
    Duck.dsy_mode:set_visible(false)
    Duck.dsy_left_am:set_visible(false)
    Duck.dsy_right_am:set_visible(false)


    Duck.distort_slider:set_visible(false)
    Duck.Fakelag_mode:set_visible(false)
    Duck.Fakelag_amount:set_visible(false)

end

if type_cond:get() == 5 then

    Slowwalk.yaw_add:set_visible(false)
    Slowwalk.yaw_mode:set_visible(false)
    Slowwalk.yaw_left:set_visible(false)
    Slowwalk.yaw_right:set_visible(false)
    Slowwalk.jitter_mode:set_visible(false)
    Slowwalk.jitter_type:set_visible(false)
    Slowwalk.jitter_amount:set_visible(false)
    Slowwalk.dsy_mode:set_visible(false)
    Slowwalk.dsy_left_am:set_visible(false)
    Slowwalk.dsy_right_am:set_visible(false)


    Slowwalk.distort_slider:set_visible(false)
    Slowwalk.Fakelag_mode:set_visible(false)
    Slowwalk.Fakelag_amount:set_visible(false)

    standing.yaw_add:set_visible(false)
    standing.yaw_mode:set_visible(false)
    standing.yaw_left:set_visible(false)
    standing.yaw_right:set_visible(false)
    standing.jitter_mode:set_visible(false)
    standing.jitter_type:set_visible(false)
    standing.jitter_amount:set_visible(false)
    standing.dsy_mode:set_visible(false)
    standing.dsy_left_am:set_visible(false)
    standing.dsy_right_am:set_visible(false)


    standing.distort_slider:set_visible(false)
    standing.Fakelag_mode:set_visible(false)
    standing.Fakelag_amount:set_visible(false)
    
    running.yaw_add:set_visible(false)
    running.yaw_mode:set_visible(false)
    running.yaw_left:set_visible(false)
    running.yaw_right:set_visible(false)
    running.jitter_mode:set_visible(false)
    running.jitter_type:set_visible(false)
    running.jitter_amount:set_visible(false)
    running.dsy_mode:set_visible(false)
    running.dsy_left_am:set_visible(false)
    running.dsy_right_am:set_visible(false)


    running.distort_slider:set_visible(false)
    running.Fakelag_mode:set_visible(false)
    running.Fakelag_amount:set_visible(false)

    inAir.yaw_add:set_visible(false)
    inAir.yaw_mode:set_visible(false)
    inAir.yaw_left:set_visible(false)
    inAir.yaw_right:set_visible(false)
    inAir.jitter_mode:set_visible(false)
    inAir.jitter_type:set_visible(false)
    inAir.jitter_amount:set_visible(false)
    inAir.dsy_mode:set_visible(false)
    inAir.dsy_left_am:set_visible(false)
    inAir.dsy_right_am:set_visible(false)


    inAir.distort_slider:set_visible(false)
    inAir.Fakelag_mode:set_visible(false)
    inAir.Fakelag_amount:set_visible(false)

    Duck.yaw_add:set_visible(true)
    Duck.yaw_mode:set_visible(true)
    if Duck.dsy_mode:get() == 4 then
    Duck.yaw_left:set_visible(true)
    Duck.yaw_right:set_visible(true)

else
    Duck.yaw_left:set_visible(false)
    Duck.yaw_right:set_visible(false)
end
    Duck.jitter_mode:set_visible(true)
    Duck.jitter_type:set_visible(true)
    Duck.jitter_amount:set_visible(true)
    Duck.dsy_mode:set_visible(true)
    Duck.dsy_left_am:set_visible(true)
    Duck.dsy_right_am:set_visible(true)


    Duck.distort_slider:set_visible(true)
    Duck.Fakelag_mode:set_visible(true)
    Duck.Fakelag_amount:set_visible(true)

end


if type_cond:get() == 6 then


    Slowwalk.yaw_add:set_visible(true)
    Slowwalk.yaw_mode:set_visible(true)
    if Slowwalk.dsy_mode:get() == 4 then
        Slowwalk.yaw_left:set_visible(true)
        Slowwalk.yaw_right:set_visible(true)
    
    else
        Slowwalk.yaw_left:set_visible(false)
        Slowwalk.yaw_right:set_visible(false)
    end
    Slowwalk.jitter_mode:set_visible(true)
    Slowwalk.jitter_type:set_visible(true)
    Slowwalk.jitter_amount:set_visible(true)
    Slowwalk.dsy_mode:set_visible(true)
    Slowwalk.dsy_left_am:set_visible(true)
    Slowwalk.dsy_right_am:set_visible(true)


    Slowwalk.distort_slider:set_visible(true)
    Slowwalk.Fakelag_mode:set_visible(true)
    Slowwalk.Fakelag_amount:set_visible(true)

    standing.yaw_add:set_visible(false)
    standing.yaw_mode:set_visible(false)
    standing.yaw_left:set_visible(false)
    standing.yaw_right:set_visible(false)
    standing.jitter_mode:set_visible(false)
    standing.jitter_type:set_visible(false)
    standing.jitter_amount:set_visible(false)
    standing.dsy_mode:set_visible(false)
    standing.dsy_left_am:set_visible(false)
    standing.dsy_right_am:set_visible(false)


    standing.distort_slider:set_visible(false)
    standing.Fakelag_mode:set_visible(false)
    standing.Fakelag_amount:set_visible(false)
    
    running.yaw_add:set_visible(false)
    running.yaw_mode:set_visible(false)
    running.yaw_left:set_visible(false)
    running.yaw_right:set_visible(false)
    running.jitter_mode:set_visible(false)
    running.jitter_type:set_visible(false)
    running.jitter_amount:set_visible(false)
    running.dsy_mode:set_visible(false)
    running.dsy_left_am:set_visible(false)
    running.dsy_right_am:set_visible(false)


    running.distort_slider:set_visible(false)
    running.Fakelag_mode:set_visible(false)
    running.Fakelag_amount:set_visible(false)

    inAir.yaw_add:set_visible(false)
    inAir.yaw_mode:set_visible(false)
    inAir.yaw_left:set_visible(false)
    inAir.yaw_right:set_visible(false)
    inAir.jitter_mode:set_visible(false)
    inAir.jitter_type:set_visible(false)
    inAir.jitter_amount:set_visible(false)
    inAir.dsy_mode:set_visible(false)
    inAir.dsy_left_am:set_visible(false)
    inAir.dsy_right_am:set_visible(false)


    inAir.distort_slider:set_visible(false)
    inAir.Fakelag_mode:set_visible(false)
    inAir.Fakelag_amount:set_visible(false)

    Duck.yaw_add:set_visible(false)
    Duck.yaw_mode:set_visible(false)
    Duck.yaw_left:set_visible(false)
    Duck.yaw_right:set_visible(false)
    Duck.jitter_mode:set_visible(false)
    Duck.jitter_type:set_visible(false)
    Duck.jitter_amount:set_visible(false)
    Duck.dsy_mode:set_visible(false)
    Duck.dsy_left_am:set_visible(false)
    Duck.dsy_right_am:set_visible(false)


    Duck.distort_slider:set_visible(false)
    Duck.Fakelag_mode:set_visible(false)
    Duck.Fakelag_amount:set_visible(false)

end

end

callbacks.add(e_callbacks.PAINT, menu_handler)




local sin = math.sin
math.sin = function (x) 
    return sin(rad(x)) 
end


  --timer func
  local old_time = globals.cur_time()
  local shift = false
  local do_init = false
  local function timer4(time, func)
  
      if not do_init then
          old_time = old_time + time
          do_init = true
      end
  
      if (shift) then
          old_time = globals.cur_time() + time
          shift = false
      end
  
      if globals.cur_time() > old_time then
          if not func then
              shift = true
              return true
          else
              func()
              shift = true
  
          end
      end
  
      if not func then
          return false
      end
  end


 --timer func
 local old_time = globals.cur_time()
 local shift = false
 local do_init = false
 local function timer7(time, func)
 
     if not do_init then
         old_time = old_time + time
         do_init = true
     end
 
     if (shift) then
         old_time = globals.cur_time() + time
         shift = false
     end
 
     if globals.cur_time() > old_time then
         if not func then
             shift = true
             return true
         else
             func()
             shift = true
 
         end
     end
 
     if not func then
         return false
     end
 end


 function get_state(speed)
    if not engine.is_connected() then return end
    if not entity_list.get_local_player():is_alive() then return end

    local flags = entity_list.get_local_player():get_prop("m_fFlags")
    if bit.band(flags, 1) == 1 then
        if bit.band(flags, 4) == 4 or antiaim.is_fakeducking() then 
            return 4 -- Crouching
        else
            if speed <= 3 then
                return 1 -- Standing
            else
                if ref.slowwalk:get() then
                    return 3 -- Slowwalk
                else
                    return 2 -- Moving
                end
            end
        end
    elseif bit.band(flags, 1) == 0 then
        if bit.band(flags, 4) == 4 then
            return 6 -- Air Crouch
        else
            return 5 -- Air
        end
    end
end

function get_velocity()
    local first_velocity = entity_list.get_local_player():get_prop("m_vecVelocity[0]")
    local second_velocity = entity_list.get_local_player():get_prop("m_vecVelocity[1]")
    local speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))
    
    return speed
end




    


function aa_handler(ctx)

local state = get_state(get_velocity())
local lp = entity_list.get_local_player()
local speed = math.floor(get_velocity(lp))
local ducked = lp:get_prop("m_bDucked") == 1
local air = lp:get_prop("m_vecVelocity[2]") ~= 0
local dsy_side = antiaim.get_desync_side()


    if not engine.is_connected() then return end
    if not lp:is_alive() then return end
--standing
if state == 1 then

    

    if not engine.is_in_game() then return end
    if standing.jitter_mode:get() == 1 then
        ref.jitter_mode:set(1)
    end

 if standing.jitter_mode:get() == 2 then
    ref.jitter_mode:set(2)
end
 
if standing.jitter_mode:get() == 3 then
    ref.jitter_mode:set(3)
end



if standing.jitter_type:get() == 1 then
    ref.jitter:set(2)
    ref.jitter_am:set(standing.jitter_amount:get())
end

if standing.jitter_type:get() == 2 then
    ref.jitter:set(1)
    ref.jitter_am:set(standing.jitter_amount:get())
end

if standing.jitter_type:get() == 3 then

    
    ref.jitter_am:set(standing.jitter_amount:get())
    timer4(0.016, function()
        ref.jitter_am:set(-standing.jitter_amount:get())
    
    end)
    
    ref.jitter:set(1)
end

if standing.dsy_mode:get() == 1 then
    ref.D_side:set(1)
    ref.D_right:set(standing.dsy_right_am:get())
ref.D_left:set(standing.dsy_left_am:get())
end

if standing.dsy_mode:get() == 2 then
    ref.D_side:set(2)
    ref.D_right:set(standing.dsy_right_am:get())
ref.D_left:set(standing.dsy_left_am:get())
end

if standing.dsy_mode:get() == 3 then
    ref.D_side:set(3)
    ref.D_right:set(standing.dsy_right_am:get())
ref.D_left:set(standing.dsy_left_am:get())
end

if standing.dsy_mode:get() == 4 then
    ref.D_right:set(standing.dsy_right_am:get())
ref.D_left:set(standing.dsy_left_am:get())
    ref.D_side:set(4)

end

if standing.dsy_mode:get() == 5 then
    ref.D_side:set(5)
    ref.D_right:set(standing.dsy_right_am:get())
ref.D_left:set(standing.dsy_left_am:get())
end

if standing.dsy_mode:get() == 6 then
    ref.D_side:set(6)
    ref.D_right:set(standing.dsy_right_am:get())
    ref.D_left:set(standing.dsy_left_am:get())
end

if standing.dsy_mode:get() == 7 then
    ref.D_side:set(7)
    ref.D_right:set(standing.dsy_right_am:get())
ref.D_left:set(standing.dsy_left_am:get())
end



if standing.yaw_mode:get() == 1 then

    ref.yaw_add:set(standing.yaw_add:get())
end

if standing.dsy_mode:get() == 4 then
 
    if dsy_side == 1 then
        ref.yaw_add:set(standing.yaw_right:get() + standing.yaw_add:get())
    else 
        ref.yaw_add:set(standing.yaw_left:get() + standing.yaw_add:get())
    end



    

end




if standing.yaw_mode:get() == 2 then

    ref.yaw_add:set(sin(global_vars.cur_time() * standing.distort_slider:get()) * standing.yaw_add:get())
end



if standing.Fakelag_mode:get() == 1 then

    return end

    if standing.Fakelag_mode:get() == 2 then

    ref.fakelag_am:set(standing.Fakelag_amount:get())
end

if standing.Fakelag_mode:get() == 3 then

ref.fakelag_am:set(standing.Fakelag_amount:get())
timer7 (0.08, function()
    ref.fakelag_am:set(1)
end)

end


end

--running
if state == 2 then

    if not engine.is_in_game() then return end
    if running.jitter_mode:get() == 1 then
        ref.jitter_mode:set(1)
    end

 if running.jitter_mode:get() == 2 then
    ref.jitter_mode:set(2)
end
 
if running.jitter_mode:get() == 3 then
    ref.jitter_mode:set(3)
end



if running.jitter_type:get() == 1 then
    ref.jitter:set(2)
    ref.jitter_am:set(running.jitter_amount:get())
end

if running.jitter_type:get() == 2 then
    ref.jitter:set(1)
    ref.jitter_am:set(running.jitter_amount:get())
end

if running.jitter_type:get() == 3 then

    
    ref.jitter_am:set(running.jitter_amount:get())
    timer4(0.016, function()
        ref.jitter_am:set(-running.jitter_amount:get())
    
    end)
    
    ref.jitter:set(1)
end

if running.dsy_mode:get() == 1 then
    ref.D_side:set(1)
    ref.D_right:set(running.dsy_right_am:get())
ref.D_left:set(running.dsy_left_am:get())
end

if running.dsy_mode:get() == 2 then
    ref.D_side:set(2)
    ref.D_right:set(running.dsy_right_am:get())
ref.D_left:set(running.dsy_left_am:get())
end

if running.dsy_mode:get() == 3 then
    ref.D_side:set(3)
    ref.D_right:set(running.dsy_right_am:get())
ref.D_left:set(running.dsy_left_am:get())
end

if running.dsy_mode:get() == 4 then
    ref.D_right:set(running.dsy_right_am:get())
ref.D_left:set(running.dsy_left_am:get())

ref.D_side:set(4)
end

if running.dsy_mode:get() == 5 then
    ref.D_side:set(5)
    ref.D_right:set(running.dsy_right_am:get())
ref.D_left:set(running.dsy_left_am:get())
end

if running.dsy_mode:get() == 6 then
    ref.D_side:set(6)
    ref.D_right:set(running.dsy_right_am:get())
    ref.D_left:set(running.dsy_left_am:get())
end

if running.dsy_mode:get() == 7 then
    ref.D_side:set(7)
    ref.D_right:set(running.dsy_right_am:get())
ref.D_left:set(running.dsy_left_am:get())
end



if running.yaw_mode:get() == 1 then

    ref.yaw_add:set(running.yaw_add:get())
end

 if running.dsy_mode:get() == 4 then 

    if dsy_side == 1 then
        ref.yaw_add:set(running.yaw_right:get() + running.yaw_add:get())
    else 
        ref.yaw_add:set(running.yaw_left:get() + running.yaw_add:get())
    end
    

end


if running.yaw_mode:get() == 2 then

    ref.yaw_add:set(sin(global_vars.cur_time() * running.distort_slider:get()) * running.yaw_add:get())
end



if running.Fakelag_mode:get() == 1 then

    return end

    if running.Fakelag_mode:get() == 2 then

    ref.fakelag_am:set(running.Fakelag_amount:get())
end

if running.Fakelag_mode:get() == 3 then

ref.fakelag_am:set(running.Fakelag_amount:get())
timer7 (0.08, function()
    ref.fakelag_am:set(1)
end)

end


end


if state == 5 then

    if not engine.is_in_game() then return end
    if inAir.jitter_mode:get() == 1 then
        ref.jitter_mode:set(1)
    end

 if inAir.jitter_mode:get() == 2 then
    ref.jitter_mode:set(2)
end
 
if inAir.jitter_mode:get() == 3 then
    ref.jitter_mode:set(3)
end



if inAir.jitter_type:get() == 1 then
    ref.jitter:set(2)
    ref.jitter_am:set(inAir.jitter_amount:get())
end

if inAir.jitter_type:get() == 2 then
    ref.jitter:set(1)
    ref.jitter_am:set(inAir.jitter_amount:get())
end

if inAir.jitter_type:get() == 3 then

    
    ref.jitter_am:set(inAir.jitter_amount:get())
    timer4(0.016, function()
        ref.jitter_am:set(-inAir.jitter_amount:get())
    
    end)
    
    ref.jitter:set(1)
end

if inAir.dsy_mode:get() == 1 then
    ref.D_side:set(1)
    ref.D_right:set(inAir.dsy_right_am:get())
ref.D_left:set(inAir.dsy_left_am:get())
end

if inAir.dsy_mode:get() == 2 then
    ref.D_side:set(2)
    ref.D_right:set(inAir.dsy_right_am:get())
ref.D_left:set(inAir.dsy_left_am:get())
end

if inAir.dsy_mode:get() == 3 then
    ref.D_side:set(3)
    ref.D_right:set(inAir.dsy_right_am:get())
ref.D_left:set(inAir.dsy_left_am:get())
end

if inAir.dsy_mode:get() == 4 then
    ref.D_right:set(inAir.dsy_right_am:get())
ref.D_left:set(inAir.dsy_left_am:get())

ref.D_side:set(4)
end

if inAir.dsy_mode:get() == 5 then
    ref.D_side:set(5)
    ref.D_right:set(inAir.dsy_right_am:get())
ref.D_left:set(inAir.dsy_left_am:get())
end

if inAir.dsy_mode:get() == 6 then
    ref.D_side:set(6)
    ref.D_right:set(inAir.dsy_right_am:get())
    ref.D_left:set(inAir.dsy_left_am:get())
end

if inAir.dsy_mode:get() == 7 then
    ref.D_side:set(7)
    ref.D_right:set(inAir.dsy_right_am:get())
ref.D_left:set(inAir.dsy_left_am:get())
end



if inAir.yaw_mode:get() == 1 then

    ref.yaw_add:set(inAir.yaw_add:get())
end

if inAir.dsy_mode:get() == 4 then


    if dsy_side == 1 then
        ref.yaw_add:set(inAir.yaw_left:get() + inAir.yaw_add:get())
    else 
        ref.yaw_add:set(inAir.yaw_right:get() + inAir.yaw_add:get())
    end
    

end



if inAir.yaw_mode:get() == 2 then

    ref.yaw_add:set(sin(global_vars.cur_time() * inAir.distort_slider:get()) * inAir.yaw_add:get())
end



if inAir.Fakelag_mode:get() == 1 then

    return end

    if inAir.Fakelag_mode:get() == 2 then

    ref.fakelag_am:set(inAir.Fakelag_amount:get())
end

if inAir.Fakelag_mode:get() == 3 then

ref.fakelag_am:set(inAir.Fakelag_amount:get())
timer7 (0.08, function()
    ref.fakelag_am:set(1)
end)

end



end
 
if state == 3 then

if not engine.is_in_game() then return end
if Slowwalk.jitter_mode:get() == 1 then
    ref.jitter_mode:set(1)
end

if Slowwalk.jitter_mode:get() == 2 then
ref.jitter_mode:set(2)
end

if Slowwalk.jitter_mode:get() == 3 then
ref.jitter_mode:set(3)
end



if Slowwalk.jitter_type:get() == 1 then
ref.jitter:set(2)
ref.jitter_am:set(Slowwalk.jitter_amount:get())
end

if Slowwalk.jitter_type:get() == 2 then
ref.jitter:set(1)
ref.jitter_am:set(Slowwalk.jitter_amount:get())
end

if Slowwalk.jitter_type:get() == 3 then


ref.jitter_am:set(Slowwalk.jitter_amount:get())
timer4(0.016, function()
    ref.jitter_am:set(-Slowwalk.jitter_amount:get())

end)

ref.jitter:set(1)
end

if Slowwalk.dsy_mode:get() == 1 then
ref.D_side:set(1)
ref.D_right:set(Slowwalk.dsy_right_am:get())
ref.D_left:set(Slowwalk.dsy_left_am:get())
end

if Slowwalk.dsy_mode:get() == 2 then
ref.D_side:set(2)
ref.D_right:set(Slowwalk.dsy_right_am:get())
ref.D_left:set(Slowwalk.dsy_left_am:get())
end

if Slowwalk.dsy_mode:get() == 3 then
ref.D_side:set(3)
ref.D_right:set(Slowwalk.dsy_right_am:get())
ref.D_left:set(Slowwalk.dsy_left_am:get())
end

if Slowwalk.dsy_mode:get() == 4 then
ref.D_right:set(Slowwalk.dsy_right_am:get())
ref.D_left:set(Slowwalk.dsy_left_am:get())

ref.D_side:set(4)
end

if Slowwalk.dsy_mode:get() == 5 then
ref.D_side:set(5)
ref.D_right:set(Slowwalk.dsy_right_am:get())
ref.D_left:set(Slowwalk.dsy_left_am:get())
end

if Slowwalk.dsy_mode:get() == 6 then
ref.D_side:set(6)
ref.D_right:set(Slowwalk.dsy_right_am:get())
ref.D_left:set(Slowwalk.dsy_left_am:get())
end

if Slowwalk.dsy_mode:get() == 7 then
ref.D_side:set(7)
ref.D_right:set(Slowwalk.dsy_right_am:get())
ref.D_left:set(Slowwalk.dsy_left_am:get())
end



if Slowwalk.yaw_mode:get() == 1 then

ref.yaw_add:set(Slowwalk.yaw_add:get())
end

if Slowwalk.dsy_mode:get() == 4 then


if dsy_side == 1 then
    ref.yaw_add:set(Slowwalk.yaw_left:get() + Slowwalk.yaw_add:get())
else 
    ref.yaw_add:set(Slowwalk.yaw_right:get() + Slowwalk.yaw_add:get())
end


end



if Slowwalk.yaw_mode:get() == 2 then

ref.yaw_add:set(sin(global_vars.cur_time() * Slowwalk.distort_slider:get()) * Slowwalk.yaw_add:get())
end



if Slowwalk.Fakelag_mode:get() == 1 then

return end

if Slowwalk.Fakelag_mode:get() == 2 then

ref.fakelag_am:set(Slowwalk.Fakelag_amount:get())
end

if Slowwalk.Fakelag_mode:get() == 3 then

ref.fakelag_am:set(Slowwalk.Fakelag_amount:get())
timer7 (0.08, function()
ref.fakelag_am:set(1)
end)

end




end

if ducked then

    if not engine.is_in_game() then return end
    if Duck.jitter_mode:get() == 1 then
        ref.jitter_mode:set(1)
    end

 if Duck.jitter_mode:get() == 2 then
    ref.jitter_mode:set(2)
end
 
if Duck.jitter_mode:get() == 3 then
    ref.jitter_mode:set(3)
end



if Duck.jitter_type:get() == 1 then
    ref.jitter:set(2)
    ref.jitter_am:set(Duck.jitter_amount:get())
end

if Duck.jitter_type:get() == 2 then
    ref.jitter:set(1)
    ref.jitter_am:set(Duck.jitter_amount:get())
end

if Duck.jitter_type:get() == 3 then

    
    ref.jitter_am:set(Duck.jitter_amount:get())
    timer4(0.016, function()
        ref.jitter_am:set(-Duck.jitter_amount:get())
    
    end)
    
    ref.jitter:set(1)
end

if Duck.dsy_mode:get() == 1 then
    ref.D_side:set(1)
    ref.D_right:set(Duck.dsy_right_am:get())
ref.D_left:set(Duck.dsy_left_am:get())
end

if Duck.dsy_mode:get() == 2 then
    ref.D_side:set(2)
    ref.D_right:set(Duck.dsy_right_am:get())
ref.D_left:set(Duck.dsy_left_am:get())
end

if Duck.dsy_mode:get() == 3 then
    ref.D_side:set(3)
    ref.D_right:set(Duck.dsy_right_am:get())
ref.D_left:set(Duck.dsy_left_am:get())
end

if Duck.dsy_mode:get() == 4 then
    ref.D_right:set(Duck.dsy_right_am:get())
ref.D_left:set(Duck.dsy_left_am:get())
    ref.D_side:set(4)

end

if Duck.dsy_mode:get() == 5 then
    ref.D_side:set(5)
    ref.D_right:set(Duck.dsy_right_am:get())
ref.D_left:set(Duck.dsy_left_am:get())
end

if Duck.dsy_mode:get() == 6 then
    ref.D_side:set(6)
    ref.D_right:set(Duck.dsy_right_am:get())
    ref.D_left:set(Duck.dsy_left_am:get())
end

if Duck.dsy_mode:get() == 7 then
    ref.D_side:set(7)
    ref.D_right:set(Duck.dsy_right_am:get())
ref.D_left:set(Duck.dsy_left_am:get())
end



if Duck.yaw_mode:get() == 1 then

    ref.yaw_add:set(Duck.yaw_add:get())
end

if Duck.dsy_mode:get() == 4 then

    if dsy_side == 1 then
        ref.yaw_add:set(Duck.yaw_left:get() + Duck.yaw_add:get())
    else 
        ref.yaw_add:set(Duck.yaw_right:get() + Duck.yaw_add:get())
    end
    

end


if Duck.yaw_mode:get() == 2 then

    ref.yaw_add:set(sin(global_vars.cur_time() * Duck.distort_slider:get()) * Duck.yaw_add:get())
end



if Duck.Fakelag_mode:get() == 1 then

    return end

    if Duck.Fakelag_mode:get() == 2 then

    ref.fakelag_am:set(Duck.Fakelag_amount:get())
end

if Duck.Fakelag_mode:get() == 3 then

ref.fakelag_am:set(Duck.Fakelag_amount:get())
timer7 (0.08, function()
    ref.fakelag_am:set(1)
end)

end


end
end
callbacks.add(e_callbacks.ANTIAIM, aa_handler)