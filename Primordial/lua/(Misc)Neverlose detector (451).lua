-- Neverlose detector by trail and voidzero B)

--[[
    You might be wondering, how does this script work?
    Well neverlose is using a specific pitch value while antiaiming which is 84
    We have no clue why they chose this value but yea this is it
]]--

local function on_esp( ctx )
    if ctx.dormant then return end
    if ctx.player == entity_list.get_local_player( ) then return end
    if not ctx.player:is_enemy( ) then return end
    
    local ent = ctx.player
    local ang = ent:get_prop( "m_angEyeAngles" )
    if ang[ 0 ] > 83 and ang[ 0 ] < 85 then
        ctx:add_flag("NL", color_t(0, 255, 255))
    end
end

callbacks.add( e_callbacks.PLAYER_ESP, on_esp )