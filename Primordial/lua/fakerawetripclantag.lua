local enable_clantag = menu.add_checkbox("rawetrip fake","on/off")


local function on_draw_watermark(watermark_text)
    -- watermark
    return "Azis.lua   |  " .. user.name
end

local _set_clantag = ffi.cast('int(__fastcall*)(const char*, const char*)', memory.find_pattern('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))
local _last_clantag = nil

local set_clantag = function(v)
  if v == _last_clantag then return end
  _set_clantag(v, v)
  _last_clantag = v
end

local tag = {
    '〄',
    '〄',
    'R >|〄',
    'RA >|〄',
    'R4W >|〄',
    'RAWЭ >|〄',
    'R4W3T >|〄',
    'RAWΣTR >|〄',
    'Я4WETRI >|〄',
    'RAWETRIP <|〄',
    'Я4WETRI <|〄',
    'RAWΣTR <|〄',
    'R4W3T <|〄',
    'RAWЭ <|〄',
    'R4W <|〄',
    'RA <|〄',
    'R <|〄',
    '〄',
    '〄',
} 

local engine_client_interface = memory.create_interface("engine.dll", "VEngineClient014")
local get_net_channel_info = ffi.cast("void*(__thiscall*)(void*)",memory.get_vfunc(engine_client_interface,78))
local net_channel_info = get_net_channel_info(ffi.cast("void***",engine_client_interface))
local get_latency = ffi.cast("float(__thiscall*)(void*,int)",memory.get_vfunc(tonumber(ffi.cast("unsigned long",net_channel_info)),9))

local function clantag_animation()
    if not engine.is_connected() then return end

    local latency = get_latency(ffi.cast("void***",net_channel_info),1) / global_vars.interval_per_tick()
    local tickcount_pred = global_vars.tick_count() + latency
    local iter = math.floor(math.fmod(tickcount_pred / 64, #tag) + 1)
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
    clantag_animation()
end)

callbacks.add(e_callbacks.SHUTDOWN, function()
    clantag_destroy()
end)

callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)