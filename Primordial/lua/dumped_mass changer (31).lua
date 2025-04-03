--| Create the menu element(s)
local mass_slider = menu.add_slider("los the lua man", "mass slider", 0, 200, 1, 1, "kg")
if mass_slider:get() == 0 then mass_slider:set(100) end

--| The setup command callback
local function on_setup_command()
    -- Return if the local player isn't alive
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    -- Set the model scale ^-^
    local_player:set_prop("m_flModelScale", mass_slider:get() / 100)
    local_player:set_prop("m_ScaleType", 1)
end

--| The shutdown callback
local function on_shutdown()
    -- Return if the local player isn't alive
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    -- Set the model scale ^-^
    local_player:set_prop("m_flModelScale", 1)
    local_player:set_prop("m_ScaleType", 0)
end

--| Register the setup command & shutdown callbacks
callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)