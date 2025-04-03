local slider = menu.add_slider("Third person fix", "Distance", 30, 150)
local find_og_distance = menu.find("visuals","other","thirdperson","distance")

local function on_run_command(cmd, unpredicted_data)
    local local_player = entity_list:get_local_player()

    cvars.c_mindistance:set_int(slider:get())
    find_og_distance:set(slider:get()-30)
end

callbacks.add(e_callbacks.RUN_COMMAND, on_run_command)