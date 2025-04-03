--[[

    #Auther: skxrh
    #Date: 02/07/22

]]--

local font = render.create_font("Tahoma", 16, 300)

local desire = {
    notification_array = {}
}

local accent_color = select(2, unpack(menu.find("misc", "main", "config", "accent color")))

local function draw()
    table.foreach(desire.notification_array, function(i, notification_array_pointer)
        local text = notification_array_pointer.text
        local screen_size = render.get_screen_size()
        local text_size = render.get_text_size(font, text)
        local centered = screen_size.x / 2 - text_size.x * 0.5

        notification_array_pointer.duration = notification_array_pointer.duration + 0.5

        if notification_array_pointer.duration > text_size.x then 
            notification_array_pointer.alpha = notification_array_pointer.alpha - 3

            if notification_array_pointer.alpha == 0 then
                table.remove(desire.notification_array, i)
            end
        end

        render.rect_filled(vec2_t(centered - 1, 0 + (i * 22)), vec2_t(text_size.x + 1, 20), color_t(23,23,23,notification_array_pointer.alpha - 100))
        render.rect_filled(vec2_t(centered - 1, 0 + (i * 22)), vec2_t(text_size.x + 1 - notification_array_pointer.duration, 2), accent_color:get())
        render.text(font, text, vec2_t(centered, 2 + (i * 22)), color_t(255, 255, 255, notification_array_pointer.alpha))
    end)
end

function desire:add_notify(text, color)  
    local duration = 0
    local alpha = 255

    table.insert(self.notification_array, {
        duration = duration,
        text = text,
        alpha = alpha
    })
end

callbacks.add(e_callbacks.PAINT, draw)

return desire