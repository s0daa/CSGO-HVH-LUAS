--| Create the menu element(s)
local should_slide = menu.add_checkbox("los the lua guy", "slide on walk", true)
local should_jump = menu.add_checkbox("los the lua guy", "static legs in air", true)

--| The anti aim callback
local function on_anti_aim(antiaim_context)
    -- Return if the local player isn't alive
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    -- Set the MOVE_BLEND_WALK param if the checkbox is checked
    if should_slide:get() then
        antiaim_context:set_render_pose(e_poses.MOVE_BLEND_WALK, 0)
    end

    -- Set the JUMP_FALL param if the checkbox is checked
    if should_jump:get() then
        antiaim_context:set_render_pose(e_poses.JUMP_FALL, 1)
    end
end

--| Register the callback
callbacks.add(e_callbacks.ANTIAIM, on_anti_aim)