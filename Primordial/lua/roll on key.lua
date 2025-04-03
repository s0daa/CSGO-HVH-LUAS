--| Create the menu element(s)
local should_roll = menu.add_text("los the lua guy", "roll on key"):add_keybind("roll on key")
local roll_amount = menu.add_slider("los the lua guy", "roll amount", -60, 60)

--| The anti aim callback
local function on_anti_aim(antiaim_context)
    -- Set the body lean to the roll amount on the key
    if should_roll:get() then
        antiaim_context:set_body_lean(roll_amount:get() / 60)
    end
end

--| The draw watermark callback
local function on_draw_watermark(text)
    -- Append ": rolling" to the watermark if the checkbox is checked
    if should_roll:get() then
        text = text .. ": rolling"
    end

    return text
end

--| Register the callbacks
callbacks.add(e_callbacks.ANTIAIM, on_anti_aim)
callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)