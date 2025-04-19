local tab, container = 'AA', 'Other'

local loaded = pcall(function()
    ui.reference(tab, container, 'sigma_teleport_key')
end)



local interface = {
    _ = ui.new_label(tab, container, 'sigma_customize_indicator'),
    text = ui.new_textbox(tab, container, 'sigma_text_indiator'),
}

local renderer_indicator = renderer.indicator
renderer.indicator = function(r, g, b, a, ...)
    local arguments = table.concat({...})

    local text = ui.get(interface.text)

    if arguments:find('+/-') then
        return renderer_indicator(r, g, b, a, text)
    end
    
    return renderer_indicator(r, g, b, a, arguments)
end