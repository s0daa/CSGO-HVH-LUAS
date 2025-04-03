local checkbox = ui.add_check_box("Enable Clantag", "enable_input", false)
local textinput = ui.add_text_input("Static", "input", "NixerHook.cc")

client.register_callback("create_move", function()
    if checkbox:get_value() then
        local str = textinput:get_value()
        se.set_clantag(str)
    else
        se.set_clantag("")
    end
end)

client.register_callback("unload", function()
    checkbox:set_value(false)
    se.set_clantag("")
end)