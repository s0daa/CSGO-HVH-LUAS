local watermark = menu.add_checkbox("Hide Watermark", "enabled")


local function on_draw_watermark(watermark_text)

if watermark:get() then
    return ""
else

    return 'primordial' .. ' - '..user.name

end

end

callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)