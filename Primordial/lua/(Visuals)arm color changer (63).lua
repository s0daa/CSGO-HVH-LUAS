--| Create the menu element(s)
local skin_color = menu.add_selection("los the lua guy", "skin color", {"default", "black", "mixed", "white", "tan"})

--| r_skin cvar
local r_skin = cvars.r_skin

--| The paint callback
local function on_paint()
    r_skin:set_int(skin_color:get() - 1)
end

--| Register the paint callback
callbacks.add(e_callbacks.PAINT, on_paint)