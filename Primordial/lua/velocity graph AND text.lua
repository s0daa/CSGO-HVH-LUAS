--| all credit goes to @los !!!

--| Menu

checktext = menu.add_checkbox("Main", "Text")
checkline = menu.add_checkbox("Main", "Line")

xaxis = menu.add_slider("Main", "x", 0, 1920, 1, 0)
yaxis = menu.add_slider("Main", "y", 0, 1080, 1, 0)

--| Auto enable all settings & xaxis & yaxis
xaxis:set(955)
yaxis:set(880)
checkline:set(true)
checktext:set(true)

local main_font = render.create_font("Arial", 20, 600, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW, e_font_flags.ITALIC)


--| Variables
local velocity_history = {}

--| math.clamp(n, min, max)
function math.clamp(n, min, max)
    return n < min and n or n > max and max or n
end

--| The setup command callback
local function on_setup_command()

    -- Return if the local player isn't alive
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    -- Get the current velocity
    velocity = local_player:get_prop("m_vecVelocity"):length()

    -- Insert the velocity in the last spot, and remove the first if history > 100
    table.insert(velocity_history, 1, velocity)
    if #velocity_history > 50 then
        table.remove(velocity_history, #velocity_history)
    end
end

--| The paint callback
local function on_paint()

    -- Get the screen size and calculate the base position
    local screen_size = render.get_screen_size()
    local base_position = vec2_t(screen_size.x / 2 + 150, screen_size.y / 1.25)

    -- Draw the velocity lines
    if (checkline:get() == true) then
        local last_position
        for index = #velocity_history, 1, -1 do
            local position = base_position - vec2_t(index * 6, math.clamp(velocity_history[index] / 5, 0, 150))
            if last_position then
                render.line(last_position, position, color_t(255, 255, 255, 255))
            end
            last_position = position
        end
    end

    if (checktext:get() == true) then
        local xaxis = xaxis:get()
        local yaxis = yaxis:get()

        if (velocity == nil) then
            return
        end
        
        if (velocity > 10 and velocity < 100) then
             xaxis = xaxis - 5
        elseif (velocity > 100 and velocity < 1000) then
            xaxis = xaxis - 10
        end

       
        
        render.text(main_font, tostring(math.ceil(velocity)), vec2_t(xaxis , yaxis), color_t(255, 255, 255, 255))
   
    end

end

--| Register the setup command and paint callback
callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)
callbacks.add(e_callbacks.PAINT, on_paint)