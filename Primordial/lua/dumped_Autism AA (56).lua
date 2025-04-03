local jittera = menu.find("antiaim","main","angles", "jitter add")
local youngflexa = menu.find("antiaim","main","angles","yaw add")

local autism_jit = menu.add_checkbox("Autism Jitter", "Enable", true)
local autism_jitt = menu.add_slider("Autism Jitter", "range", 1, 40)
local autism_delay = menu.add_slider("Autism Jitter", "delay", 2, 40)

local autism_yaw = menu.add_checkbox("Autism Yaw", "Enable", true)
local autism_mode = menu.add_slider("Autism Yaw", "range", 1, 40)
local autism_delayz = menu.add_slider("Autism Yaw", "delay", 2, 40)


local enable_clantag = menu.add_checkbox("Autism Misc","Change Clantag")


local function on_draw_watermark(watermark_text)
    -- watermark
    return "Autism   |  " .. user.name
end

local function ui_handler()
    autism_mode:set_visible(autism_yaw:get())
    autism_jitt:set_visible(autism_jit:get())
end

local function anti_aim()
    local rdm1 = math.random(1, autism_delayz:get())
    local rdm3 = math.random(1, autism_delay:get())
    if rdm1 == 1 and autism_yaw:get() then
        youngflexa:set(autism_mode:get())
    else
        youngflexa:set(autism_mode:get() * -1)
    end

    if autism_jit:get() and rdm3 == 1 then
        jittera:set(autism_jitt:get())
    else
        jittera:set(autism_jitt:get() * -1) 
    end
end

local _set_clantag = ffi.cast('int(__fastcall*)(const char*, const char*)', memory.find_pattern('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))
local _last_clantag = nil

local set_clantag = function(v)
  if v == _last_clantag then return end
  _set_clantag(v, v)
  _last_clantag = v
end

local tag = {
    'Autism',
    'Autism',
    'Auti5m',
    'Auti5m'
} 

local engine_client_interface = memory.create_interface("engine.dll", "VEngineClient014")
local get_net_channel_info = ffi.cast("void*(__thiscall*)(void*)",memory.get_vfunc(engine_client_interface,78))
local net_channel_info = get_net_channel_info(ffi.cast("void***",engine_client_interface))
local get_latency = ffi.cast("float(__thiscall*)(void*,int)",memory.get_vfunc(tonumber(ffi.cast("unsigned long",net_channel_info)),9))

local function clantag_animation()
    if not engine.is_connected() then return end

    local latency = get_latency(ffi.cast("void***",net_channel_info),1) / global_vars.interval_per_tick()
    local tickcount_pred = global_vars.tick_count() + latency
    local iter = math.floor(math.fmod(tickcount_pred / 16, #tag) + 1)
    if enable_clantag:get() then
        set_clantag(tag[iter])
    else
        set_clantag("")
    end 
end

local function clantag_destroy()
    set_clantag("")
end

callbacks.add(e_callbacks.PAINT, function()
    ui_handler()
    anti_aim()
    clantag_animation()
end)

callbacks.add(e_callbacks.SHUTDOWN, function()
    clantag_destroy()
end)

callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)