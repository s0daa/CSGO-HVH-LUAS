--=======PreviewByAntiOrder======--
 --=======Fonts======--
local menu_color = select(2, unpack(menu.find("misc", "main", "config", "accent color")))
local font = render.create_font("Arial", 13, 20,e_font_flags.OUTLINE)
local pixel = render.create_font("Smallest Pixel-7", 10, 20)

  --=======FontsEnd======--
local function on_paint()
   --====Preview======--

   --======MenuOpen=======--
 if menu.is_open() then
   --======MenuOpenEND=====--

   --======MenuPOS/Size=======--
    local pos = menu.get_pos()
    local size = menu.get_size()
    pos = pos - vec2_t(150, 2)
    --======MenuPOS/SizeEnd=======--

     --====RenderBox======--
    render.rect_filled(pos + vec2_t(-10, 0), vec2_t(150, 180), color_t(41, 41, 41), 10)
    render.rect_filled(pos + vec2_t(-10, 20), vec2_t(150, 140), color_t(34, 34, 34), 0)
    render.rect_filled(pos + vec2_t(-10, 20), vec2_t(150, 1),  menu_color:get(), 0)
    --====RenderBoxEnd======--

     --======RenderText======--
    render.text(font,"Preview", pos+vec2_t(45,5), color_t(255, 255, 255, 150), 13, true)
    render.text(pixel, "LUA", pos+vec2_t(33,50), color_t(255, 255, 255, 255), 10, true)
    render.text(pixel, "NAME", pos+vec2_t(50,50), color_t(255, 130, 130, 255), 10, true)
    render.text(pixel, "DYNAMIC", pos+vec2_t(50,66), color_t(255, 130, 130, 255), true)
    render.text(pixel, "16", pos+vec2_t(76, 60), color_t(255, 255, 255, 255), 10, true)
    render.text(pixel, "FAKE YAW:", pos+vec2_t(33,70), color_t(130, 130, 255, 255), 10, true)
    render.text(pixel, "R", pos+vec2_t(80, 70), color_t(255, 255, 255, 255), 10, true)
    render.text(pixel, "DT", pos+vec2_t(33, 80), color_t(0, 255, 0, 255), 10, true)
    render.text(pixel, "DMG: 15", pos+vec2_t(33,90), color_t(255, 255, 255, 255), 10, true)
    render.text(pixel, "Onshot", pos+vec2_t(33, 100), color_t(250, 173, 181, 255), 10, true)
    render.text(pixel, "BAIM", pos+vec2_t(33,110), color_t(255, 255, 255, 255), 10, true)
    render.text(pixel, "FS", pos+vec2_t(58,110), color_t(255, 255, 255, 255), 10, true)
    render.text(pixel," Anti-Order", pos+vec2_t(80,165),  menu_color:get(), 13, true)
    --====RenderTextEnd======--

    --====PreviewEnd======--
   end
   
end

  --=====Callback=======--
callbacks.add(e_callbacks.PAINT, on_paint)
  --=====CallbackEnd=======--