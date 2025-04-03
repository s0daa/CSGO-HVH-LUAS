local easing = require("primordial/easing library.95")

-- Anti Aim
local type_cond = menu.add_selection("Anti Aim Main", "Condition", {"None", "Standing", "Running", "In Air", "Ducking"})


print("°°Loading Taiga°°")
print(".")
print("..")
print("...")
print("Have Fun Using My Lua ^^")



ragebot = {
    hs_tp_check = menu.add_checkbox("Ragebot","Safer DT",false),
    }
    
    
    local hs_tp_key = ragebot.hs_tp_check:add_keybind("enable")

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
    
}

standing = {

    yaw_mode = menu.add_selection("Anti-Aim", "[Standing] Yaw Mode", {"Static", "Jitter", "Sway",}),
yaw_Ammount = menu.add_slider("Anti-Aim", "[Standing] Yaw Add", -180, 180, 1),
jitter_mode = menu.add_selection("Anti-Aim", "[Standing] Jitter Type", {"None","Static", "Random",}),
jitter_type = menu.add_selection("Anti-Aim", "[Standing] Jitter Type", {"Center", "Offset","Alternative"}),
jitter_amount = menu.add_slider("Anti-Aim", "[Standing] Jitter Amount", -180, 180, 1),
dsy_mode = menu.add_selection("Anti-Aim", "[Standing] Desync Side", {"None","Left", "Right","Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
dsy_left_am = menu.add_slider("Anti-Aim", "[Standing] Desync Left", 0, 100, 1),
dsy_right_am = menu.add_slider("Anti-Aim", "[Standing] Desync Right", 0, 100, 1),
DSY_Jitter = menu.add_checkbox("Anti-Aim", "[Standing] Desync Jitter", false),

distort_slider = menu.add_slider("Anti-Aim", "[Standing] Sway Speed", 1, 15, 1),
Fakelag_mode = menu.add_selection("Fakelag","[Standing] Fakelag Mode", {"None","Static","Switch", "Fluctuate"}),
Fakelag_amount = menu.add_slider("Fakelag", "[Standing] Lag Amount", 0, 15, 1),
}

running = {

yaw_mode = menu.add_selection("Anti-Aim", "[Running] Yaw Mode", {"Static", "Jitter", "Sway",}),
yaw_Ammount = menu.add_slider("Anti-Aim", "[Running] Yaw Add", -180, 180, 1),
jitter_mode = menu.add_selection("Anti-Aim", "[Running] Jitter Type", {"None","Static", "Random",}),
jitter_type = menu.add_selection("Anti-Aim", "[Running] Jitter Type", {"Center", "Offset","Alternative"}),
jitter_amount = menu.add_slider("Anti-Aim", "[Running] Jitter Amount", -180, 180, 1),
dsy_mode = menu.add_selection("Anti-Aim", "[Running] Desync Side", {"None","Left", "Right","Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
dsy_left_am = menu.add_slider("Anti-Aim", "[Running] Desync Left", 0, 100, 1),
dsy_right_am = menu.add_slider("Anti-Aim", "[Running] Desync Right", 0, 100, 1),
DSY_Jitter = menu.add_checkbox("Anti-Aim", "[Running] Desync Jitter", false),

distort_slider = menu.add_slider("Anti-Aim", "[Running] Sway Speed", 1, 15, 1),
Fakelag_mode = menu.add_selection("Fakelag","[Running] Fakelag Mode", {"None","Static","Switch", "Fluctuate"}),
Fakelag_amount = menu.add_slider("Fakelag", "[Running] Lag Amount", 0, 15, 1),
}

inAir = {

    yaw_mode = menu.add_selection("Anti-Aim", "[In Air] Yaw Mode", {"Static", "Jitter", "Sway",}),
    yaw_Ammount = menu.add_slider("Anti-Aim", "[In Air] Yaw Add", -180, 180, 1),
    jitter_mode = menu.add_selection("Anti-Aim", "[In Air] Jitter Type", {"None","Static", "Random",}),
    jitter_type = menu.add_selection("Anti-Aim", "[In Air] Jitter Type", {"Center", "Offset","Alternative"}),
    jitter_amount = menu.add_slider("Anti-Aim", "[In Air] Jitter Amount", -180, 180, 1),
    dsy_mode = menu.add_selection("Anti-Aim", "[In Air] Desync Side", {"None","Left", "Right","Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
    dsy_left_am = menu.add_slider("Anti-Aim", "[In Air] Desync Left", 0, 100, 1),
    dsy_right_am = menu.add_slider("Anti-Aim", "[In Air] Desync Right", 0, 100, 1),
    DSY_Jitter = menu.add_checkbox("Anti-Aim", "[In Air] Desync Jitter", false),

    distort_slider = menu.add_slider("Anti-Aim", "[In Air] Sway Speed", 1, 15, 1),
    Fakelag_mode = menu.add_selection("Fakelag","[In Air] Fakelag Mode", {"None","Static","Switch", "Fluctuate"}),
    Fakelag_amount = menu.add_slider("Fakelag", "[In Air] Lag Amount", 0, 15, 1),

}

Duck = {

    yaw_mode = menu.add_selection("Anti-Aim", "[Duck] Yaw Mode", {"Static", "Jitter", "Sway",}),
    yaw_Ammount = menu.add_slider("Anti-Aim", "[Duck] Yaw Add", -180, 180, 1),
    jitter_mode = menu.add_selection("Anti-Aim", "[Duck] Jitter Type", {"None","Static", "Random",}),
    jitter_type = menu.add_selection("Anti-Aim", "[Duck] Jitter Type", {"Center", "Offset","Alternative"}),
    jitter_amount = menu.add_slider("Anti-Aim", "[Duck] Jitter Amount", -180, 180, 1),
    dsy_mode = menu.add_selection("Anti-Aim", "[Duck] Desync Side", {"None","Left", "Right","Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
    dsy_left_am = menu.add_slider("Anti-Aim", "[Duck] Desync Left", 0, 100, 1),
    dsy_right_am = menu.add_slider("Anti-Aim", "[Duck] Desync Right", 0, 100, 1),
    DSY_Jitter = menu.add_checkbox("Anti-Aim", "[Duck] Desync Jitter", false),

    distort_slider = menu.add_slider("Anti-Aim", "[Duck] Sway Speed", 1, 15, 1),
    Fakelag_mode = menu.add_selection("Fakelag","[Duck] Fakelag Mode", {"None","Static","Switch", "Fluctuate"}),
    Fakelag_amount = menu.add_slider("Fakelag", "[Duck] Lag Amount", 0, 15, 1),

}

function menu_handler()
if type_cond:get() == 1 then



    standing.yaw_mode:set_visible(false)
    standing.yaw_Ammount:set_visible(false)
    standing.jitter_mode:set_visible(false)
    standing.jitter_type:set_visible(false)
    standing.jitter_amount:set_visible(false)
    standing.dsy_mode:set_visible(false)
    standing.dsy_left_am:set_visible(false)
    standing.dsy_right_am:set_visible(false)
    standing.DSY_Jitter:set_visible(false)

    standing.distort_slider:set_visible(false)
    standing.Fakelag_mode:set_visible(false)
    standing.Fakelag_amount:set_visible(false)
    

    running.yaw_mode:set_visible(false)
    running.yaw_Ammount:set_visible(false)
    running.jitter_mode:set_visible(false)
    running.jitter_type:set_visible(false)
    running.jitter_amount:set_visible(false)
    running.dsy_mode:set_visible(false)
    running.dsy_left_am:set_visible(false)
    running.dsy_right_am:set_visible(false)
    running.DSY_Jitter:set_visible(false)

    running.distort_slider:set_visible(false)
    running.Fakelag_mode:set_visible(false)
    running.Fakelag_amount:set_visible(false)

    inAir.yaw_mode:set_visible(false)
    inAir.yaw_Ammount:set_visible(false)
    inAir.jitter_mode:set_visible(false)
    inAir.jitter_type:set_visible(false)
    inAir.jitter_amount:set_visible(false)
    inAir.dsy_mode:set_visible(false)
    inAir.dsy_left_am:set_visible(false)
    inAir.dsy_right_am:set_visible(false)
    inAir.DSY_Jitter:set_visible(false)

    inAir.distort_slider:set_visible(false)
    inAir.Fakelag_mode:set_visible(false)
    inAir.Fakelag_amount:set_visible(false)


    Duck.yaw_mode:set_visible(false)
    Duck.yaw_Ammount:set_visible(false)
    Duck.jitter_mode:set_visible(false)
    Duck.jitter_type:set_visible(false)
    Duck.jitter_amount:set_visible(false)
    Duck.dsy_mode:set_visible(false)
    Duck.dsy_left_am:set_visible(false)
    Duck.dsy_right_am:set_visible(false)
    Duck.DSY_Jitter:set_visible(false)

    Duck.distort_slider:set_visible(false)
    Duck.Fakelag_mode:set_visible(false)
    Duck.Fakelag_amount:set_visible(false)
end
 
if type_cond:get() == 2 then



    
    standing.yaw_mode:set_visible(true)
    standing.yaw_Ammount:set_visible(true)
    standing.jitter_mode:set_visible(true)
    standing.jitter_type:set_visible(true)
    standing.jitter_amount:set_visible(true)
    standing.dsy_mode:set_visible(true)
    standing.dsy_left_am:set_visible(true)
    standing.dsy_right_am:set_visible(true)
    standing.DSY_Jitter:set_visible(true)

    standing.distort_slider:set_visible(true)
    standing.Fakelag_mode:set_visible(true)
    standing.Fakelag_amount:set_visible(true)
    

    running.yaw_mode:set_visible(false)
    running.yaw_Ammount:set_visible(false)
    running.jitter_mode:set_visible(false)
    running.jitter_type:set_visible(false)
    running.jitter_amount:set_visible(false)
    running.dsy_mode:set_visible(false)
    running.dsy_left_am:set_visible(false)
    running.dsy_right_am:set_visible(false)
    running.DSY_Jitter:set_visible(false)

    running.distort_slider:set_visible(false)
    running.Fakelag_mode:set_visible(false)
    running.Fakelag_amount:set_visible(false)


    inAir.yaw_mode:set_visible(false)
    inAir.yaw_Ammount:set_visible(false)
    inAir.jitter_mode:set_visible(false)
    inAir.jitter_type:set_visible(false)
    inAir.jitter_amount:set_visible(false)
    inAir.dsy_mode:set_visible(false)
    inAir.dsy_left_am:set_visible(false)
    inAir.dsy_right_am:set_visible(false)
    inAir.DSY_Jitter:set_visible(false)

    inAir.distort_slider:set_visible(false)
    inAir.Fakelag_mode:set_visible(false)
    inAir.Fakelag_amount:set_visible(false)


    Duck.yaw_mode:set_visible(false)
    Duck.yaw_Ammount:set_visible(false)
    Duck.jitter_mode:set_visible(false)
    Duck.jitter_type:set_visible(false)
    Duck.jitter_amount:set_visible(false)
    Duck.dsy_mode:set_visible(false)
    Duck.dsy_left_am:set_visible(false)
    Duck.dsy_right_am:set_visible(false)
    Duck.DSY_Jitter:set_visible(false)

    Duck.distort_slider:set_visible(false)
    Duck.Fakelag_mode:set_visible(false)
    Duck.Fakelag_amount:set_visible(false)

end

if type_cond:get() == 3 then



    standing.yaw_mode:set_visible(false)
    standing.yaw_Ammount:set_visible(false)
    standing.jitter_mode:set_visible(false)
    standing.jitter_type:set_visible(false)
    standing.jitter_amount:set_visible(false)
    standing.dsy_mode:set_visible(false)
    standing.dsy_left_am:set_visible(false)
    standing.dsy_right_am:set_visible(false)
    standing.DSY_Jitter:set_visible(false)

    standing.distort_slider:set_visible(false)
    standing.Fakelag_mode:set_visible(false)
    standing.Fakelag_amount:set_visible(false)
    

    running.yaw_mode:set_visible(true)
    running.yaw_Ammount:set_visible(true)
    running.jitter_mode:set_visible(true)
    running.jitter_type:set_visible(true)
    running.jitter_amount:set_visible(true)
    running.dsy_mode:set_visible(true)
    running.dsy_left_am:set_visible(true)
    running.dsy_right_am:set_visible(true)
    running.DSY_Jitter:set_visible(true)

    running.distort_slider:set_visible(true)
    running.Fakelag_mode:set_visible(true)
    running.Fakelag_amount:set_visible(true)

    inAir.yaw_mode:set_visible(false)
    inAir.yaw_Ammount:set_visible(false)
    inAir.jitter_mode:set_visible(false)
    inAir.jitter_type:set_visible(false)
    inAir.jitter_amount:set_visible(false)
    inAir.dsy_mode:set_visible(false)
    inAir.dsy_left_am:set_visible(false)
    inAir.dsy_right_am:set_visible(false)
    inAir.DSY_Jitter:set_visible(false)

    inAir.distort_slider:set_visible(false)
    inAir.Fakelag_mode:set_visible(false)
    inAir.Fakelag_amount:set_visible(false)


    Duck.yaw_mode:set_visible(false)
    Duck.yaw_Ammount:set_visible(false)
    Duck.jitter_mode:set_visible(false)
    Duck.jitter_type:set_visible(false)
    Duck.jitter_amount:set_visible(false)
    Duck.dsy_mode:set_visible(false)
    Duck.dsy_left_am:set_visible(false)
    Duck.dsy_right_am:set_visible(false)
    Duck.DSY_Jitter:set_visible(false)

    Duck.distort_slider:set_visible(false)
    Duck.Fakelag_mode:set_visible(false)
    Duck.Fakelag_amount:set_visible(false)

end

if type_cond:get() == 3 then



    standing.yaw_mode:set_visible(false)
    standing.yaw_Ammount:set_visible(false)
    standing.jitter_mode:set_visible(false)
    standing.jitter_type:set_visible(false)
    standing.jitter_amount:set_visible(false)
    standing.dsy_mode:set_visible(false)
    standing.dsy_left_am:set_visible(false)
    standing.dsy_right_am:set_visible(false)
    standing.DSY_Jitter:set_visible(false)

    standing.distort_slider:set_visible(false)
    standing.Fakelag_mode:set_visible(false)
    standing.Fakelag_amount:set_visible(false)
    

    running.yaw_mode:set_visible(true)
    running.yaw_Ammount:set_visible(true)
    running.jitter_mode:set_visible(true)
    running.jitter_type:set_visible(true)
    running.jitter_amount:set_visible(true)
    running.dsy_mode:set_visible(true)
    running.dsy_left_am:set_visible(true)
    running.dsy_right_am:set_visible(true)
    running.DSY_Jitter:set_visible(true)

    running.distort_slider:set_visible(true)
    running.Fakelag_mode:set_visible(true)
    running.Fakelag_amount:set_visible(true)

    inAir.yaw_mode:set_visible(false)
    inAir.yaw_Ammount:set_visible(false)
    inAir.jitter_mode:set_visible(false)
    inAir.jitter_type:set_visible(false)
    inAir.jitter_amount:set_visible(false)
    inAir.dsy_mode:set_visible(false)
    inAir.dsy_left_am:set_visible(false)
    inAir.dsy_right_am:set_visible(false)
    inAir.DSY_Jitter:set_visible(false)

    inAir.distort_slider:set_visible(false)
    inAir.Fakelag_mode:set_visible(false)
    inAir.Fakelag_amount:set_visible(false)


    Duck.yaw_mode:set_visible(false)
    Duck.yaw_Ammount:set_visible(false)
    Duck.jitter_mode:set_visible(false)
    Duck.jitter_type:set_visible(false)
    Duck.jitter_amount:set_visible(false)
    Duck.dsy_mode:set_visible(false)
    Duck.dsy_left_am:set_visible(false)
    Duck.dsy_right_am:set_visible(false)
    Duck.DSY_Jitter:set_visible(false)

    Duck.distort_slider:set_visible(false)
    Duck.Fakelag_mode:set_visible(false)
    Duck.Fakelag_amount:set_visible(false)

end

if type_cond:get() == 4 then


    standing.yaw_mode:set_visible(false)
    standing.yaw_Ammount:set_visible(false)
    standing.jitter_mode:set_visible(false)
    standing.jitter_type:set_visible(false)
    standing.jitter_amount:set_visible(false)
    standing.dsy_mode:set_visible(false)
    standing.dsy_left_am:set_visible(false)
    standing.dsy_right_am:set_visible(false)
    standing.DSY_Jitter:set_visible(false)

    standing.distort_slider:set_visible(false)
    standing.Fakelag_mode:set_visible(false)
    standing.Fakelag_amount:set_visible(false)
    

    running.yaw_mode:set_visible(false)
    running.yaw_Ammount:set_visible(false)
    running.jitter_mode:set_visible(false)
    running.jitter_type:set_visible(false)
    running.jitter_amount:set_visible(false)
    running.dsy_mode:set_visible(false)
    running.dsy_left_am:set_visible(false)
    running.dsy_right_am:set_visible(false)
    running.DSY_Jitter:set_visible(false)

    running.distort_slider:set_visible(false)
    running.Fakelag_mode:set_visible(false)
    running.Fakelag_amount:set_visible(false)

    inAir.yaw_mode:set_visible(true)
    inAir.yaw_Ammount:set_visible(true)
    inAir.jitter_mode:set_visible(true)
    inAir.jitter_type:set_visible(true)
    inAir.jitter_amount:set_visible(true)
    inAir.dsy_mode:set_visible(true)
    inAir.dsy_left_am:set_visible(true)
    inAir.dsy_right_am:set_visible(true)
    inAir.DSY_Jitter:set_visible(true)

    inAir.distort_slider:set_visible(true)
    inAir.Fakelag_mode:set_visible(true)
    inAir.Fakelag_amount:set_visible(true)


    Duck.yaw_mode:set_visible(false)
    Duck.yaw_Ammount:set_visible(false)
    Duck.jitter_mode:set_visible(false)
    Duck.jitter_type:set_visible(false)
    Duck.jitter_amount:set_visible(false)
    Duck.dsy_mode:set_visible(false)
    Duck.dsy_left_am:set_visible(false)
    Duck.dsy_right_am:set_visible(false)
    Duck.DSY_Jitter:set_visible(false)

    Duck.distort_slider:set_visible(false)
    Duck.Fakelag_mode:set_visible(false)
    Duck.Fakelag_amount:set_visible(false)

end

if type_cond:get() == 5 then


    standing.yaw_mode:set_visible(false)
    standing.yaw_Ammount:set_visible(false)
    standing.jitter_mode:set_visible(false)
    standing.jitter_type:set_visible(false)
    standing.jitter_amount:set_visible(false)
    standing.dsy_mode:set_visible(false)
    standing.dsy_left_am:set_visible(false)
    standing.dsy_right_am:set_visible(false)
    standing.DSY_Jitter:set_visible(false)

    standing.distort_slider:set_visible(false)
    standing.Fakelag_mode:set_visible(false)
    standing.Fakelag_amount:set_visible(false)
    

    running.yaw_mode:set_visible(false)
    running.yaw_Ammount:set_visible(false)
    running.jitter_mode:set_visible(false)
    running.jitter_type:set_visible(false)
    running.jitter_amount:set_visible(false)
    running.dsy_mode:set_visible(false)
    running.dsy_left_am:set_visible(false)
    running.dsy_right_am:set_visible(false)
    running.DSY_Jitter:set_visible(false)

    running.distort_slider:set_visible(false)
    running.Fakelag_mode:set_visible(false)
    running.Fakelag_amount:set_visible(false)

    inAir.yaw_mode:set_visible(false)
    inAir.yaw_Ammount:set_visible(false)
    inAir.jitter_mode:set_visible(false)
    inAir.jitter_type:set_visible(false)
    inAir.jitter_amount:set_visible(false)
    inAir.dsy_mode:set_visible(false)
    inAir.dsy_left_am:set_visible(false)
    inAir.dsy_right_am:set_visible(false)
    inAir.DSY_Jitter:set_visible(false)

    inAir.distort_slider:set_visible(false)
    inAir.Fakelag_mode:set_visible(false)
    inAir.Fakelag_amount:set_visible(false)


    Duck.yaw_mode:set_visible(true)
    Duck.yaw_Ammount:set_visible(true)
    Duck.jitter_mode:set_visible(true)
    Duck.jitter_type:set_visible(true)
    Duck.jitter_amount:set_visible(true)
    Duck.dsy_mode:set_visible(true)
    Duck.dsy_left_am:set_visible(true)
    Duck.dsy_right_am:set_visible(true)
    Duck.DSY_Jitter:set_visible(true)

    Duck.distort_slider:set_visible(true)
    Duck.Fakelag_mode:set_visible(true)
    Duck.Fakelag_amount:set_visible(true)

end

end

callbacks.add(e_callbacks.PAINT, menu_handler)

local sin = math.sin
math.sin = function (x) 
    return sin(rad(x)) 
end


--timer

 --timer func
 local old_time = globals.cur_time()
 local shift = false
 local do_init = false
 local function timer(time, func)
 
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
 local function timer1(time, func)
 
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
 local function timer2(time, func)
 
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
 local function timer3(time, func)
 
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
 local function timer5(time, func)
 
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
  local function timer6(time, func)
  
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

local function get_velocity(player) 
    x = player:get_prop("m_vecVelocity[0]")
    y = player:get_prop("m_vecVelocity[1]")
    z = player:get_prop("m_vecVelocity[2]")
    if x == nil then return end
    return math.sqrt(x*x + y*y + z*z)
    end

function aa_handler()
  
local lp = entity_list.get_local_player()
local speed = math.floor(get_velocity(lp))
local ducked = lp:get_prop("m_bDucked") == 1
local air = lp:get_prop("m_vecVelocity[2]") ~= 0

--standing
if speed < 10 and not air and not ducked then

    

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
    ref.D_side:set(3)
    timer1(0.1, function()
        ref.D_side:set(2)

    end)
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

    ref.yaw_add:set(standing.yaw_Ammount:get())
end

if standing.yaw_mode:get() == 2 then

    ref.yaw_add:set(standing.yaw_Ammount:get())
    timer(0.016, function()
        ref.yaw_add:set(-standing.yaw_Ammount:get())

    end)
    

end

if standing.DSY_Jitter:get() then

    ref.D_left:set(standing.dsy_left_am:get())
    timer2(0.016, function()
        ref.D_left:set(standing.dsy_right_am:get())

    end)

end

if standing.DSY_Jitter:get() then

    ref.D_right:set(standing.dsy_left_am:get())
    timer3(0.04, function()
        ref.D_right:set(standing.dsy_right_am:get())

    end)

end

if standing.yaw_mode:get() == 3 then

    ref.yaw_add:set(sin(global_vars.cur_time() * standing.distort_slider:get()) * standing.yaw_Ammount:get())
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

if standing.Fakelag_mode:get() == 4 then

    ref.fakelag_am:set(sin(global_vars.cur_time() * 11 ) * standing.Fakelag_amount:get())

end

end

--running
if speed > 100 and not air and not ducked then 

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
    ref.D_side:set(3)
    timer1(0.1, function()
        ref.D_side:set(2)

    end)
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

    ref.yaw_add:set(running.yaw_Ammount:get())
end

if running.yaw_mode:get() == 2 then

    ref.yaw_add:set(running.yaw_Ammount:get())
    timer(0.016, function()
        ref.yaw_add:set(-running.yaw_Ammount:get())

    end)
    

end

if running.DSY_Jitter:get() then

    ref.D_left:set(running.dsy_left_am:get())
    timer2(0.016, function()
        ref.D_left:set(running.dsy_right_am:get())

    end)

end

if running.DSY_Jitter:get() then

    ref.D_right:set(running.dsy_left_am:get())
    timer3(0.04, function()
        ref.D_right:set(running.dsy_right_am:get())

    end)

end

if running.yaw_mode:get() == 3 then

    ref.yaw_add:set(sin(global_vars.cur_time() * running.distort_slider:get()) * running.yaw_Ammount:get())
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

if running.Fakelag_mode:get() == 4 then

    ref.fakelag_am:set(sin(global_vars.cur_time() * 11 ) * running.Fakelag_amount:get())

end

end


if air then

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
    ref.D_side:set(3)
    timer1(0.1, function()
        ref.D_side:set(2)

    end)
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

    ref.yaw_add:set(inAir.yaw_Ammount:get())
end

if inAir.yaw_mode:get() == 2 then

    ref.yaw_add:set(inAir.yaw_Ammount:get())
    timer(0.016, function()
        ref.yaw_add:set(-inAir.yaw_Ammount:get())

    end)
    

end

if inAir.DSY_Jitter:get() then

    ref.D_left:set(inAir.dsy_left_am:get())
    timer2(0.016, function()
        ref.D_left:set(inAir.dsy_right_am:get())

    end)

end

if inAir.DSY_Jitter:get() then

    ref.D_right:set(inAir.dsy_left_am:get())
    timer3(0.04, function()
        ref.D_right:set(inAir.dsy_right_am:get())

    end)

end

if inAir.yaw_mode:get() == 3 then

    ref.yaw_add:set(sin(global_vars.cur_time() * inAir.distort_slider:get()) * inAir.yaw_Ammount:get())
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

if inAir.Fakelag_mode:get() == 4 then

    ref.fakelag_am:set(sin(global_vars.cur_time() * 11 ) * inAir.Fakelag_amount:get())

end


end

if ducked and not air then

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
    ref.D_side:set(3)
    timer1(0.1, function()
        ref.D_side:set(2)

    end)
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

    ref.yaw_add:set(Duck.yaw_Ammount:get())
end

if Duck.yaw_mode:get() == 2 then

    ref.yaw_add:set(Duck.yaw_Ammount:get())
    timer(0.016, function()
        ref.yaw_add:set(-Duck.yaw_Ammount:get())

    end)
    

end

if Duck.DSY_Jitter:get() then

    ref.D_left:set(Duck.dsy_left_am:get())
    timer2(0.016, function()
        ref.D_left:set(Duck.dsy_right_am:get())

    end)

end

if Duck.DSY_Jitter:get() then

    ref.D_right:set(Duck.dsy_left_am:get())
    timer3(0.04, function()
        ref.D_right:set(Duck.dsy_right_am:get())

    end)

end

if Duck.yaw_mode:get() == 3 then

    ref.yaw_add:set(sin(global_vars.cur_time() * Duck.distort_slider:get()) * Duck.yaw_Ammount:get())
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

if Duck.Fakelag_mode:get() == 4 then

    ref.fakelag_am:set(sin(global_vars.cur_time() * 11 ) * Duck.Fakelag_amount:get())

end
end
end
callbacks.add(e_callbacks.ANTIAIM, aa_handler)

local function on_aimbot_shoot(shot)
    



    if hs_tp_key:get() then
    
    
           exploits.force_uncharge()
            
    
    
    end
    
    end
    callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)
    
    local screen_size = render.get_screen_size()
    
    
    local x = menu.add_slider("Safer DT Indicator", "x Offset", 0, screen_size.x)   
    local y = menu.add_slider("Safer DT Indicator", "y Offset", 0, screen_size.y)   
    x:set(screen_size.x/2)
    y:set(screen_size.y/2 + 40)
    local font = render.create_font("Arial", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE)
    
    local maxcharge = 14
    
    local clamp = function(v, min, max) 
        local num = v;
        num = num < min and min or num;
        num = num > max and max or num; 
        return num 
    end
    
    local function on_setup_command(cmd)
        maxcharge = (exploits.get_max_charge() ~= 0 and maxcharge ~= exploits.get_max_charge()) and exploits.get_max_charge() or maxcharge
    end
    
    cvars.sv_maxusrcmdprocessticks:set_int(17)
    cvars.cl_clock_correction:set_int(0)
    cvars.cl_clock_correction_adjustment_max_amount:set_int(450)
    
    m_alpha = 0
    local function on_paint()
        local FT = global_vars.frame_time() * 6
        local alpha = easing.cubic_in_out(m_alpha, 0, 1, 1)
    
        local vec = vec2_t(x:get(), y:get())
        local progress = hs_tp_key:get() and exploits.get_charge()/maxcharge or 0.0
        local color = color_t(math.floor(255 - 131 * progress), math.floor(195 * progress), math.floor(13 * progress), math.floor(alpha*255))
        render.progress_circle( vec - vec2_t(6, 0), 2, color_t.new(0,0,0, math.floor(alpha*250)), 3, progress)
        render.progress_circle( vec - vec2_t(6, 0), 3, color, 1, progress)
        render.text(font,"Safer DT",vec2_t(vec.x - 4 + 8*easing.cubic_in_out(progress, 0, 1, 1),vec.y - 5), color)
    
        m_alpha = clamp(m_alpha + (hs_tp_key:get() and FT or -FT), 0, 1)
    end
    
    callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)
    callbacks.add(e_callbacks.PAINT, on_paint)