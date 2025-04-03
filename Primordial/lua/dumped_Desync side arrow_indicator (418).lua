local fake_checkbox = menu.add_checkbox("Desync Side Indicator", "Fake Side")
local fake_color = fake_checkbox:add_color_picker("Fake Side color")

local real_checkbox = menu.add_checkbox("Desync Side Indicator", "Real Side")
local real_color = real_checkbox:add_color_picker("Real Side color")

local selectrealarrow = menu.add_selection("Desync Side Indicator", "Real arrow", {"– Thiner line", "➖ Thicker line", "☻ Happy Smile", "♕ Crown", "♥ Heart", "♠ Spades", "♦ Diamonds", "♣ Clubs"})
local selectfakearrow = menu.add_selection("Desync Side Indicator", "Fake arrow", {"– Thiner line", "➖ Thicker line", "☻ Happy Smile", "♕ Crown", "♥ Heart", "♠ Spades", "♦ Diamonds", "♣ Clubs"})

local font = render.create_font('Verdana', 23, 500, e_font_flags.ANTIALIAS)
local screen_size = render.get_screen_size()

local yoffset = menu.add_slider("Desync Side Indicator", "Y offset", -500, 500)
local xoffset = menu.add_slider("Desync Side Indicator", "X offset", -500, 500)

local Rarrows = {
    "–",
    "➖",
    "☻",
    "♕",
    "♥",
    "♠",
    "♦",
    "♣",
}

local Farrows = {
    "–",
    "➖",
    "☻",
    "♕",
    "♥",
    "♠",
    "♦",
    "♣",
}

local on_paint = function()

    local local_player = entity_list.get_local_player()

    if local_player == nil or not local_player:is_alive() then 
        return
    end

    if antiaim.is_inverting_desync() == false then
        
        render.text(font, Farrows[selectfakearrow:get()], vec2_t((screen_size.x/2) - yoffset:get(), (screen_size.y/2) - xoffset:get()), fake_color:get())
        render.text(font, Rarrows[selectrealarrow:get()], vec2_t((screen_size.x/2) + yoffset:get(), (screen_size.y/2) - xoffset:get()), real_color:get())

    else

     render.text(font, Farrows[selectfakearrow:get()], vec2_t((screen_size.x/2) + yoffset:get(), (screen_size.y/2) - xoffset:get()), fake_color:get())
     render.text(font, Rarrows[selectrealarrow:get()], vec2_t((screen_size.x/2) - yoffset:get(), (screen_size.y/2) - xoffset:get()), real_color:get())
        
    end

end

callbacks.add(e_callbacks.PAINT, on_paint)