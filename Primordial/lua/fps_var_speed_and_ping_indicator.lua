local arial = render.create_font("Arial", 16, 600, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local pixel = render.create_font("Smallest Pixel-7", 10, 50, e_font_flags.OUTLINE)

--credits classy for net chann info
local engine_client_interface = memory.create_interface("engine.dll", "VEngineClient014")
local get_net_channel_info = ffi.cast("void*(__thiscall*)(void*)",memory.get_vfunc(engine_client_interface,78))
local net_channel_info = get_net_channel_info(ffi.cast("void***",engine_client_interface))
local get_remote_frame = ffi.cast("void(__thiscall*)(void*,float*,float*,float*)",memory.get_vfunc(tonumber(ffi.cast("unsigned int",net_channel_info)),25))



local fps_item = menu.add_text("FPS indicator", "color")
local fps_color = fps_item:add_color_picker("color")

function on_paint()
    local screen_size = render.get_screen_size()
    local x = screen_size.x / 2
    local y = screen_size.y - 30
    local fps = client.get_fps()
    local latency = math.floor(engine.get_latency(e_latency_flows.OUTGOING) * 800 + 0.5)
    local lp = entity_list.get_local_player()
    if not lp or lp:get_prop("m_lifeState") ~= 0 then return end
    local lp_vel = lp:get_prop("m_vecVelocity")
    local vel_real = math.floor(lp_vel:length2d())
    local frame_time = ffi.new("float[1]")
    local frame_std_deviation = ffi.new("float[1]")
    local frame_start_deviation = ffi.new("float[1]")
    local server_var = 0
    
    if(get_net_channel_info == nil or net_channel_info == nil or get_remote_frame == nil) then
        return
    end
    get_remote_frame(net_channel_info,frame_time,frame_std_deviation,frame_start_deviation)
    if frame_time ~= nil and frame_std_deviation ~= nil and frame_std_deviation ~= nil then
        server_var = frame_start_deviation[0] * 1000
    end
    local var_rounded = tonumber(string.format("%." .. (1 or 0) .. "f", server_var))
    local ping_size = render.get_text_size(arial, tostring(latency))
    local fps_size = render.get_text_size(arial, tostring(fps))
    local var_size = render.get_text_size(arial, tostring(var_rounded))
    local speed_size = render.get_text_size(arial, tostring(vel_real))

    render.rect_fade(vec2_t(x, y), vec2_t(300, 30), color_t(0, 0, 0, 200), color_t(0, 0, 0, 0), true)
    render.rect_fade(vec2_t(x - 300, y), vec2_t(300, 30), color_t(0, 0, 0, 0), color_t(0, 0, 0, 200), true)

    render.text(arial, ""..latency.."", vec2_t.new(x - 189 , y + 7), fps_color:get())
    render.text(pixel, "ping", vec2_t.new(x - 184 + ping_size.x, y + 10), color_t(255, 255, 255, 255))

    render.text(arial, ""..fps.."", vec2_t.new(x - 90 , y + 7), fps_color:get())
    render.text(pixel, "fps", vec2_t.new(x - 85 + fps_size.x, y + 10), color_t(255, 255, 255, 255))

    render.text(arial, ""..var_rounded.."", vec2_t.new(x + 46 , y + 7), fps_color:get())
    render.text(pixel, "var", vec2_t.new(x + 51 + var_size.x, y + 10), color_t(255, 255, 255, 255))

    render.text(arial, ""..vel_real.."", vec2_t.new(x + 150 , y + 7), fps_color:get())
    render.text(pixel, "speed", vec2_t.new(x + 155 + speed_size.x, y + 10), color_t(255, 255, 255, 255))
end

callbacks.add(e_callbacks.PAINT, on_paint)