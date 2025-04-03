local pState = nil
local iGroundTick = 0
local bStop = false
local RandomInt = math.random
local RandomFloat = client.random_float
local Slowwalk = menu.find("misc", "main", "movement", "slow walk")[2]

local AnimationBreaker =
{
    iInAirLegs = menu.add_selection("Animation Breakers", "Legs In Air",
        { "None", "Static", "Dynamic", "Jitter", "Autistic(fr)" }),
    iLegMovement = menu.add_selection("Animation Breakers", "Leg Movement",
        { "None", "Backward", "Forward", "Jitter", "Random" }),
    iPitchOnLand = menu.add_selection("Animation Breakers", "Pitch On Land", { "None", "Zero", "Up", "Jitter", "Random" }),
    iSlowWalkAnimation = menu.add_selection("Animation Breakers", "Slowwalk Animation",
        { "None", "Slide", "Jitter", "Random" }),
}

local function AnimationBreakerFunction(ctx)
    local pLocal = entity_list.get_local_player()
    if not pLocal then
        return
    end

    local vecVelocity = pLocal:get_prop("m_vecVelocity")
    local Speed = math.sqrt(vecVelocity.x ^ 2 + vecVelocity.y ^ 2)
    local Key_S = input.is_key_held(e_keys.KEY_S)
    local Key_W = input.is_key_held(e_keys.KEY_W)
    local Key_D = input.is_key_held(e_keys.KEY_D)
    local Key_A = input.is_key_held(e_keys.KEY_A)
    local Key_E = input.is_key_held(e_keys.KEY_E)
    local Key_Space = input.is_key_held(e_keys.KEY_SPACE)
    if vecVelocity.z ~= 0 or Key_Space then
        pState = 1
    elseif Speed >= 100 or ((Key_A or Key_D or Key_W or Key_S) and not Slowwalk:get()) then
        pState = 2
    elseif (pLocal:get_prop("m_flDuckAmount") >= 0.69) or (antiaim.is_fakeducking()) then
        pState = 3
    elseif Slowwalk:get() then
        pState = 4
    else
        pState = 5
    end

    if AnimationBreaker.iInAirLegs:get() ~= 1 then
        if AnimationBreaker.iInAirLegs:get() == 2 then
            ctx:set_render_pose(e_poses.JUMP_FALL, 1)
        elseif AnimationBreaker.iInAirLegs:get() == 3 then
            ctx:set_render_pose(e_poses.JUMP_FALL, (global_vars.cur_time()% 0.7)+0.3)
        elseif AnimationBreaker.iInAirLegs:get() == 4 then
            ctx:set_render_pose(e_poses.JUMP_FALL, RandomInt(0, 1))
        elseif AnimationBreaker.iInAirLegs:get() == 5 then
            ctx:set_render_pose(e_poses.JUMP_FALL, RandomInt(0, 1))
            if pState == 1 then
                ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, RandomFloat(0.0, 1.0))
            end
        end
    end

    if AnimationBreaker.iLegMovement:get() ~= 1 then
        if AnimationBreaker.iLegMovement:get() == 2 then
            ctx:set_render_pose(e_poses.RUN, 0)
        elseif AnimationBreaker.iLegMovement:get() == 3 then
            ctx:set_render_pose(e_poses.RUN, 0.5)
        elseif AnimationBreaker.iLegMovement:get() == 4 then
            ctx:set_render_pose(e_poses.RUN, RandomInt(0, 1) * 0.5)
        elseif AnimationBreaker.iLegMovement:get() == 5 then
            ctx:set_render_pose(e_poses.RUN, RandomFloat(0.0, 1.0))
        end
    end

    if AnimationBreaker.iPitchOnLand:get() ~= 1 then
if pState == 1 then
    iGroundTick = 7
    bStop = true
else
    iGroundTick = iGroundTick - 0.1
    bStop = false
end
if iGroundTick <= 0 then
    iGroundTick = 0
end
        if iGroundTick > 0 and not bStop then
            if AnimationBreaker.iPitchOnLand:get() == 2 then
                ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
            elseif AnimationBreaker.iPitchOnLand:get() == 3 then
                ctx:set_render_pose(e_poses.BODY_PITCH, 0)
            elseif AnimationBreaker.iPitchOnLand:get() == 4 then
                ctx:set_render_pose(e_poses.BODY_PITCH, RandomInt(0, 1))
            elseif AnimationBreaker.iPitchOnLand:get() == 5 then
                ctx:set_render_pose(e_poses.BODY_PITCH, RandomFloat(0.0, 1.0))
            end
        end
    end

    if AnimationBreaker.iSlowWalkAnimation:get() ~= 1 and pState == 4 then
        if AnimationBreaker.iSlowWalkAnimation:get() == 2 then
            ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0, 0)
        elseif AnimationBreaker.iSlowWalkAnimation:get() == 3 then
            ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, RandomInt(0, 1), RandomInt(0, 1))
        elseif AnimationBreaker.iSlowWalkAnimation:get() == 4 then
            ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, RandomFloat(0.0, 1.0), RandomFloat(0.0, 1.0))
        end
    end

end

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
    AnimationBreakerFunction(ctx)
end)