local jump_key = input.find_key_bound_to_binding("jump")

local function on_run_command(cmd, unpredicted_data)
    local local_player = entity_list:get_local_player()
	
	--This could be improved with some basic checks.
	--example 1: check if event round_poststart. 
	--example 2: check if we are in chat. 
	--example 3: check if we are in the cheat menu etc.

    if input.is_key_held(jump_key) then
        cmd:add_button(e_cmd_buttons.DUCK)
    end
end

callbacks.add(e_callbacks.RUN_COMMAND, on_run_command)