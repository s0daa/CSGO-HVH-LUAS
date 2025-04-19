local image_size = Vector2.new(20, 19)
local url = "http://cdn.onlinewebfonts.com/svg/img_275352.png"
local bytes = Http.Get(url)
local image_loaded = Render.LoadImage(bytes, image_size)

local showpp = Menu.Switch('Clock Syncing','Show tickrate',false)

local url_red = "https://i.imgur.com/jzdblr7.png"
local bytes_red = Http.Get(url_red)
local image_loaded_red = Render.LoadImage(bytes_red, image_size)

local url_yellow = "https://i.imgur.com/RYDbLFk.png"
local bytes_yellow = Http.Get(url_yellow)
local image_loaded_yellow = Render.LoadImage(bytes_yellow, image_size)




local surface_measure_text, surface_draw_text = Render.CalcTextSize,function(x,y,r,g,b,a,font,text,fontsize) Render.Text(text,Vector2.new(x,y),Color.new(r/255,g/255,b/255,255),fontsize,font,true,false) end

local ping_spike = Menu.FindVar('Miscellaneous','Main','Other','Fake Ping')

local LC_ALPHA = 1
local verdana = Render.InitFont('Verdana', 11, {'r'})


local ping_color = function(ping_value)
    if ping_value < 40 then return { [0] = 255, [1] = 255, [2] = 255 } end
    if ping_value < 100 then return { [0] = 255, [1] = 125, [2] = 95 } end

    return { [0] = 255, [1] = 60, [2] = 80 }
end
local function g_paint()
    local me = EntityList.GetLocalPlayer()

    if not me or not EngineClient.IsInGame() or not EngineClient.GetNetChannelInfo() then
        return
    end

    local server_framerate, server_var = 30,55
    local alpha = 255

    local color = { [1] = 255, [2] = 200, [3] = 95, [4] = 255 }
    local x, y = EngineClient.GetScreenSize().x,EngineClient.GetScreenSize().y

    x,y = x / 2 + 1, y - 155

    local net_state = 0
    local net_data_text = {
        [0] = 'clock syncing',
        [1] = 'packet choke',
        [2] = 'packet loss',
        [3] = 'lost connection'
    }


    if net_state ~= 0 then
        color = { 255, 50, 50, alpha }
    end

    local ccor_text = net_data_text[net_state]
    local ccor_width = surface_measure_text(ccor_text,11,verdana).x

    local sp_x = x - ccor_width - 25
    local sp_y = y

    local cn = 1

    surface_draw_text(sp_x, sp_y, 255, 255, 255, 255, verdana, ccor_text,11)
    Render.Image(color[2] == 200 and image_loaded_yellow or image_loaded_red, Vector2.new(x - 10, sp_y - 8), image_size)
    surface_draw_text(x + 20, sp_y, 255, 255, 255, 255, verdana, '+- 0.2 ms',11)

    local bytes_in_text = 16.08 .. '    '
    local bi_width = surface_measure_text(bytes_in_text,11,verdana).x

    local tickrate = 64
    local lerp_time = 15.4

    local lerp_clr = { [1] = 255,[2] =  125, [3] = 95 }

    surface_draw_text(sp_x, sp_y + 20*cn, 255, 255, 255, LC_ALPHA*255, verdana, bytes_in_text, 11);
    surface_draw_text(sp_x + bi_width, sp_y + 20*cn, lerp_clr[1], lerp_clr[2], lerp_clr[3], LC_ALPHA*255, verdana, string.format('lerp: %.1fms', lerp_time), 11); cn=cn+1
    surface_draw_text(sp_x, sp_y + 20*cn, 255, 255, 255, LC_ALPHA*255, verdana, string.format('out: %.2fk/s', 1024), 11); cn=cn+1

    surface_draw_text(sp_x, sp_y + 20*cn, 255, 255, 255, LC_ALPHA*255, verdana, string.format('sv: %.2f +- %.2fms    var: %.3f ms', server_framerate, server_var, server_var), 11); cn=cn+1

    local outgoing, incoming = 1, 1
    local ping, avg_ping = 1000, 5

    local ping_spike_val = 1
    
    local latency_interval = 123
    local additional_latency = 99

    local pc = ping_color(avg_ping)
    local tr_text = string.format('tick: %dp/s    ', tickrate)
    local tr_width =surface_measure_text(tr_text,11,verdana).x

    local nd_text = string.format('delay: %dms (+- %dms)    ', avg_ping, math.abs(avg_ping-ping))
    local nd_width = surface_measure_text(nd_text,11,verdana).x

    
    local fl_text = string.format('datagram')

    -- Draw line
    if showpp:Get() == (6 > 2) then surface_draw_text(sp_x, sp_y + 20*cn, 255, 255, 255, 255, verdana, tr_text, 11); cn=cn+1 end
    surface_draw_text(sp_x, sp_y + 20*cn, pc[0], pc[1], pc[2], LC_ALPHA*255, verdana, nd_text,11);
    surface_draw_text(sp_x + nd_width, sp_y + 20*cn, 255, 255 / 100 * additional_latency, 255 / 100 * additional_latency, LC_ALPHA*255, verdana, fl_text,11); cn=cn+1
end

Cheat.RegisterCallback('draw',g_paint)

