_DEBUG = true

ui.sidebar("\aE5BFECFWWraith Indicators", "dog" )

ffi.cdef[[
    
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
    void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);
    int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);

    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);

]]

local urlmon = ffi.load 'UrlMon'
local wininet = ffi.load 'WinInet'




local Download = function(from, to)
    wininet.DeleteUrlCacheEntryA(from)
    urlmon.URLDownloadToFileA(nil, from, to, 0,0)
end

files.create_folder('nl\\wraithindicators')
    Download("https://cdn.discordapp.com/attachments/839906710507880541/1019654524169900163/pixel.ttf", "nl\\wraithindicators\\Smallest Pixel-7.ttf")



local group = ui.create("Wraith Indicators", ui.get_icon("ghost").." Wraith Indicators")
local switch = group:switch("\aE5BFECFFEnable Wraith Indicators", false)

local font = render.load_font('nl\\wraithindicators\\Smallest Pixel-7.ttf', 10, "o")
local x = render.screen_size().x
local y = render.screen_size().y
local isMD = ui.find("Aimbot", "Ragebot", "Selection", "Global", "Min. Damage")
local isBA = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim")
local isSP = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points")
local isDT = ui.find("Aimbot", "Ragebot", "Main", "Double Tap")
local isAP = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist")
local isSW = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk")
local isHS = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
local isFS = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
local isFD = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")

function desync_delta()
    local desync_rotation = rage.antiaim:get_rotation(true)
    local real_rotation = rage.antiaim:get_rotation()
    local delta_to_draw = math.min(math.abs(real_rotation - desync_rotation) / 2, 60)
    return string.format("%.1f", delta_to_draw)
end
local fake = desync_delta()
local currentTime = globals.curtime

local acatel_indicators = function()

    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    if not switch:get() then return end

    if switch:get() then


        

        if globals.is_connected then
            aa_inv_state = lp.m_flPoseParameter[11] * 120 - 60 <= 0 and true or false
        else
            return
        end

        if aa_inv_state == false then
            invert =""
        else
            invert =""
        end

        local minDmg = false
        local binds = ui.get_binds()
        for i, v in pairs(binds) do
            local bind = binds[i]
            if v.name == 'Minimum Damage' then
                minDmg = true
            end
        end

        if currentTime + 0.38 < globals.curtime then
            currentTime = globals.curtime
            fake = desync_delta()
        end

        local ay = 13
        local alpha = math.min(math.floor(math.sin((globals.curtime%3) * 4) * 175 + 50), 255)

        local eternal_ts = render.measure_text(font, nil, "Wraith ")
        render.text(font, vector(x/2-15, y/2+ay), color(255,255,255,255), nil, "Wraith")
        render.text(font, vector(x/2+eternal_ts.x-2, y/2+ay), color(255, 130, 130, alpha), nil, "")
        print(y/2)
        ay = ay + 9

        local text_ =""
        local clr0 = color(0, 0, 0, 0)
        if isSW:get() then
            text_ =""
            clr0 = color(255, 50, 50, 255)
        else
            text_ =" "
            clr0 = color(255, 117, 107, 255)
        end

        local d_ts = render.measure_text(font, nil, text_)
        render.text(font, vector(x/2, y/2+ay), clr0, nil, text_)
        render.text(font, vector(x/2-5, y/2+ay), color(255,255,255,255), nil, math.floor(fake).."%")
        ay = ay + 9

        local fake_ts = render.measure_text(font, nil, " ")
        render.text(font, vector(x/2, y/2+ay), color(130, 130, 255, 255), nil, "")
        render.text(font, vector(x/2+fake_ts.x, y/2+ay), color(255, 255, 255, 255), nil, invert)
        ay = ay + 9

        local asadsa = math.min(math.floor(math.sin((rage.exploit:get()%2) *1) * 122), 100)
        
        if isAP:get() and isDT:get() then
            local ts_tick = render.measure_text(1, nil, "IDEALTICK")
            render.text(font, vector(x/2-20, y/2-9+ay), color(255, 255, 255, 255), nil, "IDEALTICK")
            render.text(font, vector(x/2+ts_tick.x, y/2+ay), rage.exploit:get() and color(0, 255, 0, 255) or color(255, 0, 0, 255), nil, "")
            ay = ay + 9
        else
            if isAP:get() then
                render.text(font, vector(x/2-8, y/2-9+ay), color(255, 255, 255, 255), nil, "PEEK")
                ay = ay + 9
            end
            if isDT:get() then
                render.text(font, vector(x/2-4, y/2-9+ay), rage.exploit:get() == 1 and color(255, 255, 255, 255) or color(125, 125, 125, 255), nil, "DT")
                ay = ay + 9
            end
        end

        local ax = 0
        if isHS:get() then
            render.text(font, vector(x/2-12, y/2-9+ay), color(255, 255, 255, 255), nil, "OS-AA")
			                ay = ay + 9
        end

        render.text(font, vector(x/2-10, y/2-9+ay), isBA:get() == "Force" and color(255, 255, 255, 255) or color(255, 255, 255, 128), nil, "BAIM")
        ax = ax + render.measure_text(font, nil, "BAIM ").x

        render.text(font, vector(x/2-21, y/2-9+ay), isSP:get() == "Force" and color(255, 255, 255, 255) or color(255, 255, 255, 128), nil, "SP")
        ax = ax + render.measure_text(font, nil, "SP ").x

        render.text(font, vector(x/2+12, y/2-9+ay), isFS:get() and color(255, 255, 255, 255) or color(255, 255, 255, 128), nil, "FS")
        ax = ax + render.measure_text(font, nil, "FS ").x
    end
end

events.render:set(acatel_indicators)