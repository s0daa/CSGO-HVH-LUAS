--| Create the menu element(s)
local show_text = menu.add_checkbox("los the lua man", "show velocity", true)

--| Variables
local velocity_history = {}

--| math.clamp(n, min, max)
function math.clamp(n, min, max)
    return n < min and n or n > max and max or n
end

--
local function modulate_color(delta)
    local color = color_t(0, 0, 0, 255)
    if delta < 0 then color.r = 255 end
    if delta > 0 then color.r = 80 color.g = 200 color.b = 60 end
    if delta == 0 then color.r = 255 color.g = 159 end

    return color
end

--| The setup command callback
local function on_setup_command()
    -- Return if the local player isn't alive
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    -- Get the current velocity
    local velocity = local_player:get_prop("m_vecVelocity"):length()
    velocity = math.floor(velocity + 0.5)

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
    local last_position
    for index = #velocity_history, 1, -1 do
        local position = base_position - vec2_t(index * 6, math.clamp(velocity_history[index] / 5, 0, 150))
        if last_position then
            render.line(last_position, position, color_t(255, 255, 255, 255))
        end
        last_position = position
    end

    -- Return if the text should not draw
    if not show_text:get() then
        return
    end

    -- Obtain the last velocity values and subtract them
    local last_velocity = velocity_history[1] or 0
    local last_delta = last_velocity - (velocity_history[2] or 0)

    -- Calculate the Y offset and the text size
    local text_size = render.get_text_size(render.get_default_font(), tostring(last_delta))
    local last_y = math.clamp(last_velocity / 5, 0, 150)
    base_position = base_position - vec2_t(0, last_y + text_size.y / 2)

    render.text(render.get_default_font(), tostring(last_velocity), base_position, modulate_color(last_delta))
end

--| Register the setup command and paint callback
callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)
callbacks.add(e_callbacks.PAINT, on_paint)