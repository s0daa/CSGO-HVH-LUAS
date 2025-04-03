local checkbox = menu.add_checkbox("Main Switch", "enable")
local checkbox_color = checkbox:add_color_picker("text1 color")
local checkbox_color2 = checkbox:add_color_picker("text2 color")

local text1 = menu.add_text_input("Customizable Watermark", "@user")

local font = render.create_font("Verdana", 12, 24, e_font_flags.ANTIALIAS)

local function watermark()
    if not checkbox:get() then return end
    local screensize = render.get_screen_size()
    local watermark_string = string.format(text1:get())
    local watermark_size = render.get_text_size(font, watermark_string)
    render.text(font, "shoppy.gg/", vec2_t(screensize.x-watermark_size.x-67, 0), checkbox_color2:get())
    render.text(font, "@", vec2_t(screensize.x-watermark_size.x-12, 0), checkbox_color:get())
    render.text(font, watermark_string, vec2_t(screensize.x-watermark_size.x-2, 0), checkbox_color:get())
end

callbacks.add(e_callbacks.PAINT, function()
    watermark()
end)