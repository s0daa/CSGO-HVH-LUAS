local launcher_sig = ffi.cast(ffi.typeof("void***"), memory.find_pattern("launcher.dll", "FF 15 ? ? ? ? 68 ? ? ? ? FF 74 24 14") or error("launcher sig not found", 1))
local launch_site_native = ffi.cast("void*(__thiscall*)(int, const char*, const char*, int, int, int)", launcher_sig) or error("launch function is nil", 1)

local function launch_site(url)
    return launch_site_native(0, "open", url, 0, 0, 1)
end

local main_font = render.create_font("Verdana", 100, 100, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local beta_font = render.create_font("Verdana", 30, 50, e_font_flags.ANTIALIAS)
local gggs = render.create_font("Verdana", 30, 50, e_font_flags.ANTIALIAS)
local gen_font = render.create_font("Verdana", 15, 300, e_font_flags.ANTIALIAS)

local function on_paint()
    local text_size = render.get_text_size(main_font, "game")
    
    render.rect_filled(vec2_t(300, 300), vec2_t(800, 400), color_t(30, 30, 30))
    render.rect_fade(vec2_t(300, 300), vec2_t(800, 10), color_t(106, 46, 89, 255), color_t(216, 104, 22, 255), true)
    render.text(main_font, "game", vec2_t(475, 300), color_t(255, 255, 255, 255))
    render.text(main_font, "sense", vec2_t(475 + text_size.x, 300), color_t(149, 184, 6, 255))
    render.text(beta_font, "BETA", vec2_t(885, 390), color_t(70, 70, 70, 255))
    render.text(gggs, "Get good. Get GameSense.", vec2_t(550, 450), color_t(255, 255, 255, 255))
    render.rect_filled(vec2_t(600, 520), vec2_t(200, 20), color_t(255, 255, 255))
    render.rect_filled(vec2_t(670, 550), vec2_t(70, 20), color_t(255, 255, 255), 3)
    render.text(gen_font, "Generate", vec2_t(676, 552), color_t(0, 255, 0, 255))
    render.text(gggs, "click button to generate!", vec2_t(560, 650), color_t(255, 255, 255, 255))


    if input.is_mouse_in_bounds(vec2_t(670, 550), vec2_t(70, 20)) and input.is_key_pressed(e_keys.MOUSE_LEFT) then
        launch_site("https://www.youtube.com/watch?v=DlaLq_BAVGI")
    end
    
end

callbacks.add(e_callbacks.PAINT, on_paint)