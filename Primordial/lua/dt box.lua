--[[
   _____                         ____                                 _   _______ _____  
  / ____|                       |  _ \                               | | |__   __|  __ \ 
 | (___  _   _ ___  __ _ _ __   | |_) | __ _ _ __ _ __ _____      __ | |    | |  | |  | |
  \___ \| | | / __|/ _` | '_ \  |  _ < / _` | '__| '__/ _ \ \ /\ / / | |    | |  | |  | |
  ____) | |_| \__ \ (_| | | | | | |_) | (_| | |  | | | (_) \ V  V /  | |____| |  | |__| |
 |_____/ \__,_|___/\__,_|_| |_| |____/ \__,_|_|  |_|  \___/ \_/\_/   |______|_|  |_____/ 
                                                                                         
                                                                                         
    DT BOX INSPIRED BY https://primordial.dev/resources/simple-dt-indiactor-and-speed-changer.138/ BUT CLEANER IMO
]]--

local enable = menu.add_checkbox("susan barrow ltd | dt box", "enable dt box")
local colour = enable:add_color_picker("dt bar colour")

local font = render.create_font("Verdana", 12, 24, e_font_flags.ANTIALIAS)
local x, y = 200, 100

local function doubletap()
    if not enable:get() then return end
    local mousepos = input.get_mouse_pos()
    local charge = exploits.get_charge()
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(x-10,y-10),vec2_t(x+130,y+24)) then
        if not hasoffset then
            offsetx = x-mousepos.x
            offsety = y-mousepos.y
            hasoffset = true
        end
        x = mousepos.x + offsetx
        y = mousepos.y + offsety
    else
        hasoffset = false
    end
    
    render.rect_filled(vec2_t(x, y-1), vec2_t(charge*8.92, 1), colour:get())
    render.rect_filled(vec2_t(x, y), vec2_t(125, 16), color_t(13,13,13,110))
    render.text(font, "doubletap | charge: "..charge, vec2_t(x+5, y+1), color_t(255,255,255,255))
end

callbacks.add(e_callbacks.PAINT, doubletap)