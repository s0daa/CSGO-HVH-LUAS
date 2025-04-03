local forcesendnextpacket = false
local function on_aimbot_shoot(shot)
    forcesendnextpacket = true
end

callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)
function on_antiaim(ctx)
    if forcesendnextpacket then
    ctx:set_fakelag(false) 
    forcesendnextpacket = false
    end
end

callbacks.add(e_callbacks.ANTIAIM, on_antiaim)