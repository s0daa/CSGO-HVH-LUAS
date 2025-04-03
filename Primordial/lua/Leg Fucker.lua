local enable_leg = menu.add_checkbox("fucker", "enable")
local slidewalk = menu.find("antiaim", "main", "general", "leg slide")

function on_run_command(cmd, unpredicted_data)

    local local_player = entity_list:get_local_player()

    if local_player == nil then return end

    if enable_leg:get() then
        p = client.random_int(1, 3)
        if p == 1 then
            slidewalk:set(1)
        elseif p == 2 then
            slidewalk:set(2)
        elseif p == 3 then
            slidewalk:set(1)
        end
        slidewalk:set_visible(false)
    else
        slidewalk:set_visible(true)
    end
end

callbacks.add(e_callbacks.RUN_COMMAND, on_run_command)