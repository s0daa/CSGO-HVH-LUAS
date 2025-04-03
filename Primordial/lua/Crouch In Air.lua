--[[
    icedancer for the primordial.dev community
    14th april 2022

    NOTE : this will make your strafes slower, because of how strafing in CS:GO works.

    to do list :

    update log (date) :
]]

-- checkbox and variable
local enableDuckInAir = menu.add_checkbox("Made by icedancer", "duck in air", false)

-- called whenever CS:GO runs input
local function on_run_command(cmd, unpredicted_data)
    -- local player variable, used to get the player flag (the onGround variable)
    local localPlayer = entity_list.get_local_player()
    
    -- "onGround" and "wasOnGround" variables, self explanatory.
    local onGround = localPlayer:has_player_flag(e_player_flags.ON_GROUND)
    local wasOnGround = unpredicted_data:has_player_flag(e_player_flags.ON_GROUND)

    -- check if the checkbox is ticked or not
    if not enableDuckInAir:get() then return end

    -- check if local player exists
    if localPlayer then

        -- check if we are in air
        if not onGround then

            -- crouch
            cmd:add_button(e_cmd_buttons.DUCK)
            
        end
    end
end

callbacks.add(e_callbacks.RUN_COMMAND, on_run_command)