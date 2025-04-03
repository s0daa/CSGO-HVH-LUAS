-- By: v0ided#3570 / clpz#4466

-- Vars
local vars = {}
vars.desyncleft = menu.find("antiaim", "main", "desync", "left amount")
vars.desyncright = menu.find("antiaim", "main", "desync", "right amount")

vars.dside = menu.find("antiaim", "main", "desync", "side")

vars.yawadd = menu.find("antiaim", "main", "angles", "yaw add")

vars.brotate = menu.find("antiaim", "main", "angles", "rotate")
vars.rotaterange = menu.find("antiaim", "main", "angles", "rotate range")
vars.rotatespeed = menu.find("antiaim", "main", "angles", "rotate speed")

vars.jittermode = menu.find("antiaim", "main", "angles", "jitter mode")
vars.jitteramount = menu.find("antiaim", "main", "angles", "jitter add")

vars.leanmode = menu.find("antiaim", "main", "angles", "body lean")
vars.leanamount = menu.find("antiaim", "main", "angles", "body lean value")
-- Anti Aim
local aa = {}
aa.enable = menu.add_checkbox("Anti Aim Main", "Enable Anti Aim", true)
aa.type = menu.add_selection("Anti Aim Main", "AA Type", {"Conditional"})
aa.type_cond = menu.add_selection("Anti Aim Main", "Condition", {"Shared", "Standing", "Slow Walking", "Running", "In Air", "Ducking"})

-- Shared
aa.typeshared_desyncleft = menu.add_slider("Conditional - Shared", "Desync Left", 0, 100)
aa.typeshared_desyncright = menu.add_slider("Conditional - Shared", "Desync Right", 0, 100)
aa.typeshared_desyncside = menu.add_selection("Conditional - Shared", "Desync Side", {"none", "left", "right", "jitter", "peek fake", "peek real", "body sway"})

aa.typeshared_yawleft = menu.add_slider("Conditional - Shared", "Yaw Left", -180, 180)
aa.typeshared_yawright = menu.add_slider("Conditional - Shared", "Yaw Right", -180, 180)

aa.typeshared_rotate = menu.add_checkbox("Conditional - Shared", "Rotate", true)
aa.typeshared_rotaterange = menu.add_slider("Conditional - Shared", "Rotate Range", 0, 360)
aa.typeshared_rotatespeed = menu.add_slider("Conditional - Shared", "Rotate Speed", 0, 100)

aa.typeshared_jittertype = menu.add_selection("Conditional - Shared", "Jitter Type", {"None", "Static", "Random"})
aa.typeshared_jitteramount = menu.add_slider("Conditional - Shared", "Jitter Amount", -180, 180)

aa.typeshared_leantype = menu.add_selection("Conditional - Shared", "Body Lean", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
aa.typeshared_leanamount = menu.add_slider("Conditional - Shared", "Lean Amount", -50, 50)
aa.typestand = menu.add_checkbox("Anti Aim Main", "Override Standing", true)
aa.typestanding_desyncleft = menu.add_slider("Conditional - Standing", "Desync Left", 0, 100)
aa.typestanding_desyncright = menu.add_slider("Conditional - Standing", "Desync Right", 0, 100)
aa.typestanding_desyncside = menu.add_selection("Conditional - Standing", "Desync Side", {"none", "left", "right", "jitter", "peek fake", "peek real", "body sway"})


aa.typestanding_yawleft = menu.add_slider("Conditional - Standing", "Yaw Left", -180, 180)
aa.typestanding_yawright = menu.add_slider("Conditional - Standing", "Yaw Right", -180, 180)

aa.typestanding_rotate = menu.add_checkbox("Conditional - Standing", "Rotate", true)
aa.typestanding_rotaterange = menu.add_slider("Conditional - Standing", "Rotate Range", 0, 360)
aa.typestanding_rotatespeed = menu.add_slider("Conditional - Standing", "Rotate Speed", 0, 100)

aa.typestanding_jittertype = menu.add_selection("Conditional - Standing", "Jitter Type", {"None", "Static", "Random"})
aa.typestanding_jitteramount = menu.add_slider("Conditional - Standing", "Jitter Amount", -180, 180)

aa.typestanding_leantype = menu.add_selection("Conditional - Standing", "Body Lean", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
aa.typestanding_leanamount = menu.add_slider("Conditional - Standing", "Lean Amount", -50, 50)

aa.typeslow = menu.add_checkbox("Anti Aim Main", "Override Slow Walking", true)
aa.typeslow_desyncleft = menu.add_slider("Conditional - Slowalking", "Desync Left", 0, 100)
aa.typeslow_desyncright = menu.add_slider("Conditional - Slowalking", "Desync Right", 0, 100)
aa.typeslow_desyncside = menu.add_selection("Conditional - Slowalking", "Desync Side", {"none", "left", "right", "jitter", "peek fake", "peek real", "body sway"})


aa.typeslow_yawleft = menu.add_slider("Conditional - Slowalking", "Yaw Left", -180, 180)
aa.typeslow_yawright = menu.add_slider("Conditional - Slowalking", "Yaw Right", -180, 180)

aa.typeslow_rotate = menu.add_checkbox("Conditional - Slowalking", "Rotate", true)
aa.typeslow_rotaterange = menu.add_slider("Conditional - Slowalking", "Rotate Range", 0, 360)
aa.typeslow_rotatespeed = menu.add_slider("Conditional - Slowalking", "Rotate Speed", 0, 100)

aa.typeslow_jittertype = menu.add_selection("Conditional - Slowalking", "Jitter Type", {"None", "Static", "Random"})
aa.typeslow_jitteramount = menu.add_slider("Conditional - Slowalking", "Jitter Amount", -180, 180)

aa.typeslow_leantype = menu.add_selection("Conditional - Slowalking", "Body Lean", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
aa.typeslow_leanamount = menu.add_slider("Conditional - Slowalking", "Lean Amount", -50, 50)


aa.typerun = menu.add_checkbox("Anti Aim Main", "Override Running", true)
aa.typerun_desyncleft = menu.add_slider("Conditional - Running", "Desync Left", 0, 100)
aa.typerun_desyncright = menu.add_slider("Conditional - Running", "Desync Right", 0, 100)
aa.typerun_desyncside = menu.add_selection("Conditional - Running", "Desync Side", {"none", "left", "right", "jitter", "peek fake", "peek real", "body sway"})

aa.typerun_yawleft = menu.add_slider("Conditional - Running", "Yaw Left", -180, 180)
aa.typerun_yawright = menu.add_slider("Conditional - Running", "Yaw Right", -180, 180)

aa.typerun_rotate = menu.add_checkbox("Conditional - Running", "Rotate", true)
aa.typerun_rotaterange = menu.add_slider("Conditional - Running", "Rotate Range", 0, 360)
aa.typerun_rotatespeed = menu.add_slider("Conditional - Running", "Rotate Speed", 0, 100)

aa.typerun_jittertype = menu.add_selection("Conditional - Running", "Jitter Type", {"None", "Static", "Random"})
aa.typerun_jitteramount = menu.add_slider("Conditional - Running", "Jitter Amount", -180, 180)

aa.typerun_leantype = menu.add_selection("Conditional - Running", "Body Lean", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
aa.typerun_leanamount = menu.add_slider("Conditional - Running", "Lean Amount", -50, 50)

aa.typeair = menu.add_checkbox("Anti Aim Main", "Override In Air", true)
aa.typeair_desyncleft = menu.add_slider("Conditional - In Air", "Desync Left", 0, 100)
aa.typeair_desyncright = menu.add_slider("Conditional - In Air", "Desync Right", 0, 100)
aa.typeair_desyncside = menu.add_selection("Conditional - In Air", "Desync Side", {"none", "left", "right", "jitter", "peek fake", "peek real", "body sway"})

aa.typeair_yawleft = menu.add_slider("Conditional - In Air", "Yaw Left", -180, 180)
aa.typeair_yawright = menu.add_slider("Conditional - In Air", "Yaw Right", -180, 180)

aa.typeair_rotate = menu.add_checkbox("Conditional - In Air", "Rotate", true)
aa.typeair_rotaterange = menu.add_slider("Conditional - In Air", "Rotate Range", 0, 360)
aa.typeair_rotatespeed = menu.add_slider("Conditional - In Air", "Rotate Speed", 0, 100)

aa.typeair_jittertype = menu.add_selection("Conditional - In Air", "Jitter Type", {"None", "Static", "Random"})
aa.typeair_jitteramount = menu.add_slider("Conditional - In Air", "Jitter Amount", -180, 180)

aa.typeair_leantype = menu.add_selection("Conditional - In Air", "Body Lean", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
aa.typeair_leanamount = menu.add_slider("Conditional - In Air", "Lean Amount", -50, 50)

aa.typeduck = menu.add_checkbox("Anti Aim Main", "Override Ducking", true)
aa.typeduck_desyncleft = menu.add_slider("Conditional - Ducking", "Desync Left", 0, 100)
aa.typeduck_desyncright = menu.add_slider("Conditional - Ducking", "Desync Right", 0, 100)
aa.typeduck_desyncside = menu.add_selection("Conditional - Ducking", "Desync Side", {"none", "left", "right", "jitter", "peek fake", "peek real", "body sway"})

aa.typeduck_yawleft = menu.add_slider("Conditional - Ducking", "Yaw Left", -180, 180)
aa.typeduck_yawright = menu.add_slider("Conditional - Ducking", "Yaw Right", -180, 180)

aa.typeduck_rotate = menu.add_checkbox("Conditional - Ducking", "Rotate", true)
aa.typeduck_rotaterange = menu.add_slider("Conditional - Ducking", "Rotate Range", 0, 360)
aa.typeduck_rotatespeed = menu.add_slider("Conditional - Ducking", "Rotate Speed", 0, 100)

aa.typeduck_jittertype = menu.add_selection("Conditional - Ducking", "Jitter Type", {"None", "Static", "Random"})
aa.typeduck_jitteramount = menu.add_slider("Conditional - Ducking", "Jitter Amount", -180, 180)

aa.typeduck_leantype = menu.add_selection("Conditional - Ducking", "Body Lean", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
aa.typeduck_leanamount = menu.add_slider("Conditional - Ducking", "Lean Amount", -50, 50)

function aa_condvis()
var = aa.enable:get()
    aa.type:set_visible(var)

var2 = var and aa.type:get() == 0 -- Conditional
    aa.type_cond:set_visible(var2)

varshared = var2 and aa.type_cond:get() == 0
    aa.typeshared_desyncleft:set_visible(varshared)
    aa.typeshared_desyncright:set_visible(varshared)
    aa.typeshared_desyncside:set_visible(varshared)

    aa.typeshared_yawleft:set_visible(varshared)
    aa.typeshared_yawright:set_visible(varshared)

    aa.typeshared_rotate:set_visible(varshared)
    aa.typeshared_rotaterange:set_visible(varshared and aa.typeshared_rotate:get())
    aa.typeshared_rotatespeed:set_visible(varshared and aa.typeshared_rotate:get())

    aa.typeshared_jittertype:set_visible(varshared)
    aa.typeshared_jitteramount:set_visible(varshared and aa.typeshared_jittertype:get() ~= 0)

    aa.typeshared_leantype:set_visible(varshared)
    aa.typeshared_leanamount:set_visible(varshared and aa.typeshared_leantype:get() ~= 0)

varstand = var2 and aa.type_cond:get() == 1
    aa.typestand:set_visible(varstand)
    varstand2 = varstand and aa.typestand:get()
    aa.typestanding_desyncleft:set_visible(varstand2)
    aa.typestanding_desyncright:set_visible(varstand2)
    aa.typestanding_desyncside:set_visible(varstand2)
    
    aa.typestanding_yawleft:set_visible(varstand2)
    aa.typestanding_yawright:set_visible(varstand2)
    
    aa.typestanding_rotate:set_visible(varstand2)
    aa.typestanding_rotaterange:set_visible(varstand2 and aa.typestanding_rotate:get())
    aa.typestanding_rotatespeed:set_visible(varstand2 and aa.typestanding_rotate:get())
    
    aa.typestanding_jittertype:set_visible(varstand2)
    aa.typestanding_jitteramount:set_visible(varstand2 and aa.typestanding_jittertype:get() ~= 0)
    
    aa.typestanding_leantype:set_visible(varstand2)
    aa.typestanding_leanamount:set_visible(varstand2 and aa.typestanding_leantype:get() ~= 0)

varslow = var2 and aa.type_cond:get() == 2
    aa.typeslow:set_visible(varslow)
    varslow2 = varslow and aa.typeslow:get()
    aa.typeslow_desyncleft:set_visible(varslow2)
    aa.typeslow_desyncright:set_visible(varslow2)
    aa.typeslow_desyncside:set_visible(varslow2)
    
    aa.typeslow_yawleft:set_visible(varslow2)
    aa.typeslow_yawright:set_visible(varslow2)
    
    aa.typeslow_rotate:set_visible(varslow2)
    aa.typeslow_rotaterange:set_visible(varslow2 and aa.typeslow_rotate:get())
    aa.typeslow_rotatespeed:set_visible(varslow2 and aa.typeslow_rotate:get())
    
    aa.typeslow_jittertype:set_visible(varslow2)
    aa.typeslow_jitteramount:set_visible(varslow2 and aa.typeslow_jittertype:get() ~= 0)
    
    aa.typeslow_leantype:set_visible(varslow2)
    aa.typeslow_leanamount:set_visible(varslow2 and aa.typeslow_leantype:get() ~= 0)

varrun = var2 and aa.type_cond:get() == 3
    aa.typerun:set_visible(varrun)
    varrun2 = varrun and aa.typerun:get()
    aa.typerun_desyncleft:set_visible(varrun2)
    aa.typerun_desyncright:set_visible(varrun2)
    aa.typerun_desyncside:set_visible(varrun2)
    
    aa.typerun_yawleft:set_visible(varrun2)
    aa.typerun_yawright:set_visible(varrun2)
    
    aa.typerun_rotate:set_visible(varrun2)
    aa.typerun_rotaterange:set_visible(varrun2 and aa.typerun_rotate:get())
    aa.typerun_rotatespeed:set_visible(varrun2 and aa.typerun_rotate:get())
    
    aa.typerun_jittertype:set_visible(varrun2)
    aa.typerun_jitteramount:set_visible(varrun2 and aa.typerun_jittertype:get() ~= 0)
    
    aa.typerun_leantype:set_visible(varrun2)
    aa.typerun_leanamount:set_visible(varrun2 and aa.typerun_leantype:get() ~= 0)

varair = var2 and aa.type_cond:get() == 4
    aa.typeair:set_visible(varair)
    varair2 = varair and aa.typeair:get()
    aa.typeair_desyncleft:set_visible(varair2)
    aa.typeair_desyncright:set_visible(varair2)
    aa.typeair_desyncside:set_visible(varair2)

    aa.typeair_yawleft:set_visible(varair2)
    aa.typeair_yawright:set_visible(varair2)

    aa.typeair_rotate:set_visible(varair2)
    aa.typeair_rotaterange:set_visible(varair2 and aa.typeair_rotate:get())
    aa.typeair_rotatespeed:set_visible(varair2 and aa.typeair_rotate:get())

    aa.typeair_jittertype:set_visible(varair2)
    aa.typeair_jitteramount:set_visible(varair2 and aa.typeair_jittertype:get() ~= 0)

    aa.typeair_leantype:set_visible(varair2)
    aa.typeair_leanamount:set_visible(varair2 and aa.typeair_leantype:get() ~= 0)

varduck = var2 and aa.type_cond:get() == 5
    aa.typeduck:set_visible(varduck)
    varduck2 = varduck and aa.typeduck:get()
    aa.typeduck_desyncleft:set_visible(varduck2)
    aa.typeduck_desyncright:set_visible(varduck2)
    aa.typeduck_desyncside:set_visible(varduck2)

    aa.typeduck_yawleft:set_visible(varduck2)
    aa.typeduck_yawright:set_visible(varduck2)

    aa.typeduck_rotate:set_visible(varduck2)
    aa.typeduck_rotaterange:set_visible(varduck2 and aa.typeduck_rotate:get())
    aa.typeduck_rotatespeed:set_visible(varduck2 and aa.typeduck_rotate:get())

    aa.typeduck_jittertype:set_visible(varduck2)
    aa.typeduck_jitteramount:set_visible(varduck2 and aa.typeduck_jittertype:get() ~= 0)

    aa.typeduck_leantype:set_visible(varduck2)
    aa.typeduck_leanamount:set_visible(varduck2 and aa.typeduck_leantype:get() ~= 0)
end

local function get_velocity(player) 
x = player:get_prop("m_vecVelocity[0]")
y = player:get_prop("m_vecVelocity[1]")
z = player:get_prop("m_vecVelocity[2]")
if x == nil then return end
return math.sqrt(x*x + y*y + z*z)
end

function desync_delta() 
local faked = antiaim.get_fake_angle()
local real = antiaim.get_real_angle()

desync = real - faked
if desync <= -302 then
    desync = desync + 360
elseif desync >= 302 then
    desync = desync - 360
end
--print(desync, real, faked)
return -desync
end

function docondition(dleft, dright, yleft, yright, rotate, rotater, rotates, jittertype, jitteramount, leantype, leanamount, fakeopts)
local invert = desync_delta() < 0
--print(invert)
--print(invert, desync_delta())
vars.desyncleft:set(dleft)
vars.desyncright:set(dright)
vars.dside:set(fakeopts)

if invert then
    vars.yawadd:set(yleft)
else
    vars.yawadd:set(yright)
end 

vars.brotate:set(rotate)
vars.rotaterange:set(rotater)
vars.rotatespeed:set(rotates)

vars.jittermode:set(jittertype)
vars.jitteramount:set(jitteramount)

vars.leanmode:set(leantype)
vars.leanamount:set(leanamount)
end

function conditionalmain()
if not aa.enable:get() then return end
local lp = entity_list.get_local_player()
local speed = math.floor(get_velocity(lp))
local ducked = lp:get_prop("m_bDucked") == 1
local air = lp:get_prop("m_vecVelocity[2]") ~= 0
if aa.type:get() == 0 then -- checking if its conditional mode
    if speed < 10 and not air and not ducked and aa.typestand:get() then -- standing
        docondition(aa.typestanding_desyncleft:get(), aa.typestanding_desyncright:get(), aa.typestanding_yawleft:get(), aa.typestanding_yawright:get(), aa.typestanding_rotate:get(), aa.typestanding_rotaterange:get(), aa.typestanding_rotatespeed:get(), aa.typestanding_jittertype:get() + 1, aa.typestanding_jitteramount:get(), aa.typestanding_leantype:get() + 1, aa.typestanding_leanamount:get(), aa.typestanding_desyncside:get() + 1)
    elseif speed > 10 and speed <= 101 and not air and not ducked and aa.typeslow:get() then -- slowalking
        docondition(aa.typeslow_desyncleft:get(), aa.typeslow_desyncright:get(), aa.typeslow_yawleft:get(), aa.typeslow_yawright:get(), aa.typeslow_rotate:get(), aa.typeslow_rotaterange:get(), aa.typeslow_rotatespeed:get(), aa.typeslow_jittertype:get() + 1, aa.typeslow_jitteramount:get(), aa.typeslow_leantype:get() + 1, aa.typeslow_leanamount:get(), aa.typeslow_desyncside:get() + 1)
    elseif speed > 100 and not air and not ducked and aa.typerun:get() then -- running
        docondition(aa.typerun_desyncleft:get(), aa.typerun_desyncright:get(), aa.typerun_yawleft:get(), aa.typerun_yawright:get(), aa.typerun_rotate:get(), aa.typerun_rotaterange:get(), aa.typerun_rotatespeed:get(), aa.typerun_jittertype:get() + 1, aa.typerun_jitteramount:get(), aa.typerun_leantype:get() + 1, aa.typerun_leanamount:get(), aa.typerun_desyncside:get() + 1)
    elseif air and aa.typeair:get() then -- in air
        docondition(aa.typeair_desyncleft:get(), aa.typeair_desyncright:get(), aa.typeair_yawleft:get(), aa.typeair_yawright:get(), aa.typeair_rotate:get(), aa.typeair_rotaterange:get(), aa.typeair_rotatespeed:get(), aa.typeair_jittertype:get() + 1, aa.typeair_jitteramount:get(), aa.typeair_leantype:get() + 1, aa.typeair_leanamount:get(), aa.typeair_desyncside:get() + 1)
    elseif ducked and not air and aa.typeduck:get() then -- ducking
        docondition(aa.typeduck_desyncleft:get(), aa.typeduck_desyncright:get(), aa.typeduck_yawleft:get(), aa.typeduck_yawright:get(), aa.typeduck_rotate:get(), aa.typeduck_rotaterange:get(), aa.typeduck_rotatespeed:get(), aa.typeduck_jittertype:get() + 1, aa.typeduck_jitteramount:get(), aa.typeduck_leantype:get() + 1, aa.typeduck_leanamount:get(), aa.typeduck_desyncside:get() + 1)
    else -- shared
        docondition(aa.typeshared_desyncleft:get(), aa.typeshared_desyncright:get(), aa.typeshared_yawleft:get(), aa.typeshared_yawright:get(), aa.typeshared_rotate:get(), aa.typeshared_rotaterange:get(), aa.typeshared_rotatespeed:get(), aa.typeshared_jittertype:get() + 1, aa.typeshared_jitteramount:get(), aa.typeshared_leantype:get() + 1, aa.typeshared_leanamount:get(), aa.typeshared_desyncside:get() + 1)
    end
end
end

-- Callbacks
local function on_antiaim()
conditionalmain()
end

local function on_paint()
aa_condvis()
end

callbacks.add(e_callbacks.RUN_COMMAND, on_antiaim)
callbacks.add(e_callbacks.PAINT, on_paint)