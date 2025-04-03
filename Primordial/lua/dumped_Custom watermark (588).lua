local function on_draw_watermark(watermark_text)
    return "Your custom watermark <3 here"
end

callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)