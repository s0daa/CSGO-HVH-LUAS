local service = {
    components = {},
}

function service:on_paint()
    for index, component in next, self.components do
        component.func(component)
    end
end

function service:handle_drag()
    local screen_size = render.get_screen_size()
    local mouse_pos = input.get_mouse_pos()
    for index, component in next, self.components do
        if component.dragging then
            component.pos_x = mouse_pos.x + component.drag_x
            component.pos_y = mouse_pos.y + component.drag_y
        end

        if input.is_mouse_in_bounds(vec2_t(component.pos_x, component.pos_y), vec2_t(component.width, component.height)) then
            if input.is_key_pressed(e_keys.MOUSE_LEFT) then
                component.dragging = true
                component.drag_x = component.pos_x - mouse_pos.x
                component.drag_y = component.pos_y - mouse_pos.y
            end
        end

        if input.is_key_released(e_keys.MOUSE_LEFT) then
            component.dragging = false
        end
    end
end

function service:create_component(name, x, y, width, height, func)
    table.insert(self.components, {
        title = name,
        pos_x = x,
        pos_y = y,
        width = width,
        height = height,
        dragging = false,
        drag_x = -1,
        drag_y = -1,
        func = func
    })

    local count = 0
    for k, v in pairs(self.components) do
        count = count + 1
    end
    local comp = self.components[count]
    return comp
end

return service