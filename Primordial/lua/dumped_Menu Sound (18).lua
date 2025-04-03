local menus = {
    enable = menu.add_checkbox("Menu Sound", "Enable", false),
    textbox = menu.add_text_input("Menu Sound", "File Name"),
    ran = false
}

callbacks.add(e_callbacks.PAINT, function() 
    if not (menus.enable:get()) then return end
    if (menu.is_open()) then
        if not (menus.ran) then
            engine.play_sound(menus.textbox:get("File Name"), 1.0, 100)
            menus.ran = true 
        end
    else 
        menus.ran = false
    end
end)