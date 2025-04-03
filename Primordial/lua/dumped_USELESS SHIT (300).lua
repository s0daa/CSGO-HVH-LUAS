--| useless shit lua by stars#3787 |--

--| menu |--
local random_pitch        = menu.add_checkbox("retarded shit", "random pitch")
local random_aspect_ratio = menu.add_checkbox("retarded shit", "random aspect ratio")
local random_viewmodel    = menu.add_checkbox("retarded shit", "random viewmodel")
local random_fov          = menu.add_checkbox("retarded shit", "random fov")
local random_walk_speed   = menu.add_checkbox("retarded shit", "random slow walk speed")
local hitchance_fucker    = menu.add_checkbox("retarded shit", "hitchance fucker")
local random_scope_fov    = menu.add_checkbox("retarded shit", "random scope fov")
local random_fog          = menu.add_checkbox("retarded shit", "random fog")
local random_full_bright  = menu.add_checkbox("retarded shit", "random full bright (LAGGY)")
local bullet_tracers      = menu.add_checkbox("retarded shit", "random bullet tracer size")
local random_midget_mode  = menu.add_checkbox("retarded shit", "random midget mode")
local random_thirdperson  = menu.add_checkbox("retarded shit", "random third person distance")



--| menu.find shit |--
local mRandom_aspect_ratio   = menu.find("visuals", "other", "general", "aspect ratio")

local mRandom_viewmodel_x    = menu.find("visuals", "other", "general", "viewmodel offsets", "x add")
local mRandom_viewmodel_y    = menu.find("visuals", "other", "general", "viewmodel offsets", "y add")
local mRandom_viewmodel_z    = menu.find("visuals", "other", "general", "viewmodel offsets", "z add")
local mRandom_viewmodel_roll = menu.find("visuals", "other", "general", "viewmodel offsets", "roll add")

local mRandom_fov            = menu.find("visuals", "other", "general", "render fov add")
local mRandom_walk_speed     = menu.find("misc", "main", "movement", "speed")

local mHitchance_fucker_gen      = menu.find("aimbot", "general", "misc", "zeusbot hitchance")
local mHitchance_fucker_auto     = menu.find("aimbot", "auto", "targeting", "hitchance")
local mHitchance_fucker_scout    = menu.find("aimbot", "scout", "targeting", "hitchance")
local mHitchance_fucker_awp      = menu.find("aimbot", "awp", "targeting", "hitchance")
local mHitchance_fucker_deagle   = menu.find("aimbot", "deagle", "targeting", "hitchance")
local mHitchance_fucker_revolver = menu.find("aimbot", "revolver", "targeting", "hitchance")
local mHitchance_fucker_pistols  = menu.find("aimbot", "pistols", "targeting", "hitchance")
local mHitchance_fucker_other    = menu.find("aimbot", "other", "targeting", "hitchance")

local mRandom_scope_fov      = menu.find("visuals", "other", "general", "zoom fov")
local mFog_enable            = menu.find("visuals", "other", "world", "modulate fog")
local mRandom_fog_dist       = menu.find("visuals", "other", "world", "fog distance")
local mRandom_fog_density    = menu.find("visuals", "other", "world", "fog density")
local mRandom_full_bright    = menu.find("visuals", "other", "world", "full bright")

local mBullet_tracers_width  = menu.find("visuals", "other", "bullet tracers", "width")
local mBullet_tracers_dur    = menu.find("visuals", "other", "bullet tracers", "duration")

local mRandom_midget_mode    = menu.find("visuals", "other", "thirdperson", "midget mode")
local mRandom_thirdperson    = menu.find("visuals", "other", "thirdperson", "distance")
-- finally done

local hitchance = 0

--| Do shit |--
local function on_antiaim(ctx)
    -- random pitch
    if random_pitch:get() then
        ctx:set_pitch(math.random(-89, 89))
    end
end

local function main(cmd)
    local state = math.random(0, 1)

    -- random aspect ratio
    if random_aspect_ratio:get() then
       mRandom_aspect_ratio:set(math.random(1, 500)) 
    end

    -- random viewmodel
    if random_viewmodel:get() then
        mRandom_viewmodel_x:set(math.random(-10, 10))  
        mRandom_viewmodel_y:set(math.random(-10, 10))
        mRandom_viewmodel_z:set(math.random(-10, 10))
        mRandom_viewmodel_roll:set(math.random(-180, 180))
    end

    -- random fov
    if random_fov:get() then
        mRandom_fov:set(math.random(-10, 50))
    end

    -- random slow walk speed
    if random_walk_speed:get() then
        mRandom_walk_speed:set(math.random( 0, 100))
    end

    -- random hitchance / hitchance fucker
    if hitchance_fucker:get() then
    hitchance = math.random(0, 100)

        mHitchance_fucker_gen:set(hitchance)
        mHitchance_fucker_auto:set(hitchance)
        mHitchance_fucker_scout:set(hitchance)
        mHitchance_fucker_awp:set(hitchance)
        mHitchance_fucker_deagle:set(hitchance)
        mHitchance_fucker_revolver:set(hitchance)
        mHitchance_fucker_pistols:set(hitchance)
        mHitchance_fucker_other:set(hitchance)
    end

    -- random scope fov
    if random_scope_fov:get() then
        mRandom_scope_fov:set(math.random(-50, 50))
    end

    -- random fog
    if random_fog:get() then
        mRandom_fog_density:set(math.random(0, 100))
        mRandom_fog_dist:set(math.random(0, 100))
    end

    -- random full bright
    if random_full_bright:get() then
        local state1 = math.random(-40, 40)
    
        if state1 == 0 then
            mRandom_full_bright:set(true)
        elseif state1 == 1 then
            mRandom_full_bright:set(false) 
        end
    end

    -- random bullet tracer size
    if bullet_tracers:get() then    
        mBullet_tracers_width:set(math.random(0, 5))
        mBullet_tracers_dur:set(math.random(0, 10))  
    end

    -- random midget mode
    if random_midget_mode:get() then
        if state == 0 then
            mRandom_midget_mode:set(true)
        elseif state == 1 then
            mRandom_midget_mode:set(false) 
        end
    end

    -- random thirdperson distance
    if random_thirdperson:get() then
        mRandom_thirdperson:set(math.random(1, 200))
    end

end

local function on_shutdown()
    print("why the fuck did you use this lua")
end

callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.SETUP_COMMAND, main) 
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)