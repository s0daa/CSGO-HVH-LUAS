-- ported by: Minarut // original author: difj
do
    local script_path = debug.getinfo(1, "S").source:sub(2)
    local script_dir = script_path:match("(.*/)")
    package.path = package.path .. ";" .. script_dir .. "?.lua"
end

local input = require("input")
local render_utils = require("renderer")

local Font = {
    TahomaBold = render.setup_font("C:/windows/fonts/tahomabd.ttf", 14, 0),
    Calibri = render.setup_font("C:/windows/fonts/calibri.ttf", 14, 0),
    Verdana = render.setup_font("C:/windows/fonts/verdana.ttf", 14, 0)
}

local Parameters = {
    Pos = vec2_t(700, 100),
    LineHeight = 18.5,
    LuaName = "PenisHub",
    Base = {
        Indent = 10,
        Tabs = {
            Width = 120,
            Height = 40,
            Names = {
                "Visual",
                "Misc",
            }
        },
        Color = {
            Accent = color_t(0.6588235294117647, 0.6666666666666666, 1, 1),
            Main = color_t(25 / 255, 25 / 255, 25 / 255, 1),
            Stroke = color_t(60 / 255, 60 / 255, 60 / 255, 1),
            Name = color_t(1, 1, 1, 1),
            Text = color_t(1, 1, 1, 1),
            SubText = color_t(1, 1, 1, 150 / 255),
            Active = color_t(100 / 255, 100 / 255, 100 / 255, 1),
            InActive = color_t(60 / 255, 60 / 255, 60 / 255, 1),
            Prompt = color_t(90 / 255, 90 / 255, 90 / 255, 1)
        },
        Font = {
            LuaName = Font.Calibri,
            TabText = Font.Calibri,
            Text = Font.Verdana
        }
    },
    Info = {}
}

Parameters.Base.Height = (#Parameters.Base.Tabs.Names + 30) * Parameters.Base.Indent + #Parameters.Base.Tabs.Names * Parameters.Base.Tabs.Height
Parameters.Base.Width = 8 * Parameters.Base.Indent + Parameters.Base.Tabs.Width + 2 * 170

local ActiveTab = 1
local MenuVisible = true

local KeyClicked, KeyPressed, change = {}, {}, {}
local prevKeyState = {}
local h, s, v, set, edit

local Keys = {
    [4] = "M3",
    [5] = "M4",
    [6] = "M5",
    [8] = "backspace",
    [13] = "enter",
    [27] = "esc",
    [20] = "caps",
    [32] = "space",
    [33] = "pgup",
    [34] = "pgdn",
    [36] = "home",
    [37] = "left",
    [38] = "up",
    [39] = "right",
    [40] = "down",
    [48] = "0",
    [49] = "1",
    [50] = "2",
    [51] = "3",
    [52] = "4",
    [53] = "5",
    [54] = "6",
    [55] = "7",
    [56] = "8",
    [57] = "9",
    [65] = "A",
    [66] = "B",
    [67] = "C",
    [68] = "D",
    [69] = "E",
    [70] = "F",
    [71] = "G",
    [72] = "H",
    [73] = "I",
    [74] = "J",
    [75] = "K",
    [76] = "L",
    [77] = "M",
    [78] = "N",
    [79] = "O",
    [80] = "P",
    [81] = "Q",
    [82] = "R",
    [83] = "S",
    [84] = "T",
    [85] = "U",
    [86] = "V",
    [87] = "W",
    [88] = "X",
    [89] = "Y",
    [90] = "Z",
    [96] = "0",
    [97] = "1",
    [98] = "2",
    [99] = "3",
    [100] = "4",
    [101] = "5",
    [102] = "6",
    [103] = "7",
    [104] = "8",
    [105] = "9",
    [106] = "*",
    [107] = "+",
    [109] = "-",
    [110] = ".",
    [111] = "/",
    [112] = "F1",
    [113] = "F2",
    [114] = "F3",
    [115] = "F4",
    [116] = "F5",
    [117] = "F6",
    [118] = "F7",
    [119] = "F8",
    [120] = "F9",
    [121] = "F10",
    [122] = "F11",
    [123] = "F12",
    [160] = "shift",
    [161] = "shift",
    [162] = "ctrl",
    [163] = "ctrl",
    [164] = "alt",
    [165] = "alt",
    [108] = "enter"
}

local Controls = {
    killsay = false,
	Waterka = true,
    Slider1 = 90,
    Dropdown1 = 1,
    Slider1Input = "",
    Slider1Editing = false
}

----------- examples of functions
local function Checkbox(name, varname, x, y) -- checkbox drawing
    local checked = Controls[varname]
    local boxSize = 15
    local DrawRect = render_utils.DrawRect
    local MouseInRect = render_utils.MouseInRect

    DrawRect(x, y, boxSize, boxSize, Parameters.Base.Color.Stroke, false)
    if checked then
        DrawRect(x + 2, y + 2, boxSize - 4, boxSize - 4, Parameters.Base.Color.Accent, true)
    end
	
    local textsize = 14
    local font = Parameters.Base.Font.Text
    render.text(name, font, vec2_t(x + boxSize + 5, y + (boxSize - textsize) / 2), Parameters.Base.Color.Text, textsize)

    if MouseInRect(x, y, boxSize + render.calc_text_size(name, font, textsize).x + 5, boxSize) then
        interacting = true
        if M1Clicked and not M1ClickedConsumed then
            M1ClickedConsumed = true
            Controls[varname] = not Controls[varname]
        end
    end
end

local function Slider(name, varname, x, y, min, max) -- slider drawing
    local value = Controls[varname] or min
    local sliderWidth = 150
    local sliderHeight = 10
    local textsize = 14
    local font = Parameters.Base.Font.Text
    local DrawRect = render_utils.DrawRect
    local MouseInRect = render_utils.MouseInRect

    render.text(name, font, vec2_t(x, y), Parameters.Base.Color.Text, textsize)
    y = y + textsize + 4
	
    DrawRect(x, y, sliderWidth, sliderHeight, Parameters.Base.Color.Stroke, true)
    local fillWidth = ((value - min) / (max - min)) * sliderWidth
    DrawRect(x, y, fillWidth, sliderHeight, Parameters.Base.Color.Accent, true)

    local valueText
    if Controls[varname .. "Editing"] then
        valueText = Controls[varname .. "Input"]
    else
        valueText = tostring(math.floor(value + 0.5))
    end
    
    local valueWidth = 40
    local valueHeight = textsize + 4

    local valueX = x + sliderWidth + 10
    local valueY = y - (textsize - sliderHeight) / 2 - 2

    DrawRect(valueX, valueY, valueWidth, valueHeight, Parameters.Base.Color.Stroke, false)
    render.text(valueText, font, vec2_t(valueX + 5, valueY + 2), Parameters.Base.Color.Text, textsize)

    if MouseInRect(x, y, sliderWidth, sliderHeight) then
        interacting = true
        if M1Pressed and not Controls[varname .. "Editing"] then
            local mouseX = input.get_mouse_pos().x
            local newWidth = math.max(0, math.min(sliderWidth, mouseX - x))
            local newValue = min + (newWidth / sliderWidth) * (max - min)
            Controls[varname] = math.floor(newValue + 0.5)
        end
    end

    if MouseInRect(valueX, valueY, valueWidth, valueHeight) then
        interacting = true
        if M1Clicked and not M1ClickedConsumed then
            M1ClickedConsumed = true
            Controls[varname .. "Editing"] = true
            Controls[varname .. "Input"] = ""
        end
    end
	
    if Controls[varname .. "Editing"] then
        interacting = true
        for key, value in pairs(Keys) do
            if KeyClicked[key] then
                if value >= "0" and value <= "9" then
                    Controls[varname .. "Input"] = Controls[varname .. "Input"] .. value
                elseif value == "backspace" then
                    Controls[varname .. "Input"] = Controls[varname .. "Input"]:sub(1, -2)
                elseif value == "enter" then
                    local inputValue = tonumber(Controls[varname .. "Input"])
                    if inputValue then
                        Controls[varname] = math.max(min, math.min(max, inputValue))
                    end
                    Controls[varname .. "Editing"] = false
                elseif value == "esc" then
                    Controls[varname .. "Editing"] = false
                end
            end
        end
    end
end

local function Dropdown(name, varname, x, y, options) -- dropbox drawing
    local current = Controls[varname] or 1
    local textsize = 14
    local font = Parameters.Base.Font.Text
    local dropdownWidth = 150
    local dropdownHeight = textsize + 4
    local optionHeight = textsize + 4
    local DrawRect = render_utils.DrawRect
    local MouseInRect = render_utils.MouseInRect

    render.text(name, font, vec2_t(x, y), Parameters.Base.Color.Text, textsize)
    y = y + textsize + 4

    DrawRect(x, y, dropdownWidth, dropdownHeight, Parameters.Base.Color.Stroke, false)
    render.text(options[current], font, vec2_t(x + 5, y + 2), Parameters.Base.Color.Text, textsize)

    if MouseInRect(x, y, dropdownWidth, dropdownHeight) then
        interacting = true
        if M1Clicked and not M1ClickedConsumed then
            M1ClickedConsumed = true
            Controls[varname .. "_open"] = not Controls[varname .. "_open"]
        end
    end

    if Controls[varname .. "_open"] then
        for i, option in ipairs(options) do
            local optionY = y + dropdownHeight * i
            DrawRect(x, optionY, dropdownWidth, dropdownHeight, Parameters.Base.Color.Stroke, false)
            render.text(option, font, vec2_t(x + 5, optionY + 2), Parameters.Base.Color.Text, textsize)
            if MouseInRect(x, optionY, dropdownWidth, dropdownHeight) then
                interacting = true
                if M1Clicked and not M1ClickedConsumed then
                    M1ClickedConsumed = true
                    Controls[varname] = i
                    Controls[varname .. "_open"] = false
                end
            end
        end
    end
end

local function DrawSeparator(x, y, width) -- separator drawing
    local DrawRect = render_utils.DrawRect
    DrawRect(x, y, width, 1, Parameters.Base.Color.Stroke, true)
end
----------- examples of functions


local function Draw()
    local Mouse = input.get_mouse_pos()
    M1Clicked = input.is_key_clicked(input.VK_LBUTTON)
    M1Pressed = input.is_key_pressed(input.VK_LBUTTON)
    local M2Clicked = input.is_key_clicked(input.VK_RBUTTON)
    M1ClickedConsumed = false
    interacting = false

    if input.is_key_clicked(input.VK_INSERT) then
        MenuVisible = not MenuVisible
    end

    if not MenuVisible then
        return
    end

    local param = Parameters
    local startpos = param.Pos
    local line = param.LineHeight
    local luaname = param.LuaName
    local info = param.Info
    local param = param.Base
    local width = param.Width
    local height = param.Height
    local color = param.Color
    local fonts = param.Font
    local indent = param.Indent
    local minrect = render_utils.MouseInRect
    local Rect = render_utils.DrawRect

    local mouse_over_ui = minrect(startpos.x, startpos.y, width, height + line)

    if mouse_over_ui then
        engine.execute_client_cmd("-attack") -- i know this is a bad way but im too lazy to deal with it
    end

    if M1Clicked and minrect(startpos.x, startpos.y, width, line) and not interacting then
        change = {"startpos", 0}
        dx, dy = Mouse.x - startpos.x, Mouse.y - startpos.y
    end
    if change[1] == "startpos" and not interacting then
        if not M1Pressed then change = {} end
        startpos.x, startpos.y = Mouse.x - dx, Mouse.y - dy
    end

    Rect(startpos.x, startpos.y, width, line, color.Main, true)
    Rect(startpos.x, startpos.y, width, -3, color.Accent, true)
    local textsize = 17
    local font = fonts.LuaName
    local size = render.calc_text_size(luaname, font, textsize)
    render.text(luaname, font, vec2_t(startpos.x + (width - size.x) / 2, startpos.y + (line - size.y) / 2), color.Text, textsize)
    local pos = { x = startpos.x, y = startpos.y + 25 }
    Rect(pos.x, pos.y, width, height, color.Main, true)
    pos.x, pos.y = pos.x + indent, pos.y + indent
    local tabs = param.Tabs
    Rect(pos.x, pos.y, tabs.Width + 2 * indent, height - 2 * indent, color.Stroke)
    pos.x, pos.y = pos.x + indent, pos.y - tabs.Height
    local font = fonts.TabText
    for key, value in ipairs(tabs.Names) do
        pos.y = pos.y + tabs.Height + indent
        local prompt = false
        if minrect(pos.x, pos.y, tabs.Width, tabs.Height) then prompt = true end
        if prompt and M1Clicked and not M1ClickedConsumed then
            M1ClickedConsumed = true
            ActiveTab = key
        end
        Rect(pos.x, pos.y, tabs.Width, tabs.Height, ActiveTab == key and color.Name or prompt and color.Prompt or color.Stroke)
        local size = render.calc_text_size(value, font, textsize)
        render.text(value, font, vec2_t(pos.x + (tabs.Width - size.x) / 2, pos.y + (tabs.Height - size.y) / 2), color.Text, textsize)
    end

    local contentX = startpos.x + tabs.Width + 4 * indent
    local contentY = startpos.y + 25 + indent

    local posX = contentX
    local posY = contentY

    if ActiveTab == 1 then
	    
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
        posY = posY + 15
		
        Checkbox("Watermark", "Waterka", posX, posY)
        posY = posY + 30
		
		Checkbox("Third Person FOV", "fovchanger", posX, posY)
        posY = posY + 10

        Slider("", "Slider1", posX, posY, 0, 160)
        posY = posY + 43
		
		Checkbox("Bullet Tracers", "Tracers", posX, posY)
        posY = posY + 30
		
		Checkbox("Hitlogs", "HitLogs", posX, posY)
        posY = posY + 30
		
		Checkbox("Hitlogs Centered", "HitLogsCent", posX, posY)
        posY = posY + 30
		
		Checkbox("Preserve Killfeed", "KillFeed", posX, posY)
		posY = posY + 30
    end
	
	if ActiveTab == 2 then
	    
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
        posY = posY + 15
		
        Checkbox("Kill Say", "killsay", posX, posY)
        posY = posY + 10
		
		Dropdown("", "Dropdown1", posX, posY, {"Ru Kill Say", "Skeet Kill Say"})
		posY = posY + 75
		
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
        posY = posY + 15

		Checkbox("Manuals", "ManualAA", posX, posY)
        posY = posY + 30
		
		Checkbox("Manuals PSilent", "ManualAAPSALO", posX, posY)
        posY = posY + 30
    end

end


register_callback("paint", function()
    for key, value in pairs(Keys) do
        local pressed = input.is_key_pressed(key)
        if pressed and not prevKeyState[key] then
            KeyClicked[key] = true
        else
            KeyClicked[key] = false
        end
        prevKeyState[key] = pressed
    end
	stoyaK()
    Draw()
end)


---------------------------------------Watermark---------------------------------------
local colors = {
    accent = color_t(0.8, 1, 0.2588, 1),
    purple_neon = color_t(0.7, 0.2, 1, 1),
    glass_color = color_t(0.1, 0.1, 0.1, 0.7),
    border_color = color_t(1, 1, 1, 0.2),
    shadow_color = color_t(0, 0, 0, 0.5),
}

local Verdana = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 12, 16)
local logs = {}
local last_update_time, watermark_length = 0, 0
local full_text = "KerosceneHvH"
local frame_count_for_fps, current_fps = 0, 0
local last_time_for_fps = os.clock()

local netvars = {
    m_sSanitizedPlayerName = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName") or 0,
    m_hOriginalController = engine.get_netvar_offset("client.dll", "C_CSPlayerPawnBase", "m_hOriginalController") or 0,
    m_nTickBase = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_nTickBase") or 0,
    m_iPing = engine.get_netvar_offset("client.dll", "CBasePlayer", "m_iPing") or 0,
	m_hPlayerPing = engine.get_netvar_offset("client.dll", "CCSPlayer_PingServices", "m_hPlayerPing") or 0,
}

local function script_name()
    local name = get_script_name()
    return name:match("(.+)%..+$") or name
end

local function get_text_dimensions(font, text, size)
    return vec2_t(size * 0.6 * #text, size)
end

local function drawRoundedRectangle(from, to, color, rounding)
    render.rect(from, to, color, rounding)
end

local function drawGlassRectangle(from, to, color, rounding)
    render.rect_filled(from, to, color, rounding)
    render.rect(from, to, colors.border_color, rounding, 0)
end

local function drawBorderedBox(text, position, padding)
    local text_size = get_text_dimensions(Verdana, text, 6)
    local box_position = vec2_t(position.x - padding, position.y - padding * 2)
    local box_size = vec2_t(text_size.x + padding + 10 , text_size.y + padding )

    drawRoundedRectangle(box_position, box_position + box_size, colors.border_color, 5)
    render.text(text, Verdana, position, color_t(0.600, 0.600, 1, 0.5))
end

local function updateDisplayText()
    if os.clock() - last_update_time >= 0.1 then
        watermark_length = math.min(watermark_length + 1, #full_text)
        last_update_time = os.clock()
    end
end

local function drawWatermark() 
    local screen_size = render.screen_size()
    local current_time = os.date("%H:%M")
    local watermark_text = string.format("[ NIXWARE.CC ] | %s | Time: %s | FPS: %d | %s | %s",  
                                         get_user_name(), current_time, current_fps, engine.get_level_name(), script_name())

    local text_size = get_text_dimensions(Verdana, watermark_text, 12)
    local padding = 3 
    local x = screen_size.x - text_size.x - padding  - 20
    local y = screen_size.y * 0.03 - 20 

    drawGlassRectangle(vec2_t(x + 80, y - 20), vec2_t(x + text_size.x + 15 , y + text_size.y + 10), colors.glass_color, 10)
	render.line(vec2_t(x + 80, y - 30), vec2_t(x + text_size.x + 15, y - 30), color_t(0.6588235294117647, 0.6666666666666666, 1, 1) , 50)
    local centered_x, centered_y = x + 90 + padding, y + padding
    render.text(watermark_text, Verdana, vec2_t(centered_x + 2, centered_y + 2), colors.shadow_color) 
    render.text(watermark_text, Verdana, vec2_t(centered_x, centered_y), color_t(1, 1, 1, 1)) 
	
end

local function fnOnPaint()
    local current_time = os.clock()
    frame_count_for_fps = frame_count_for_fps + 1

    if current_time - last_time_for_fps >= 1 then
        current_fps = frame_count_for_fps
        frame_count_for_fps = 0
        last_time_for_fps = current_time
    end

    local pLocalController = entitylist.get_local_player_controller()
    if not pLocalController then
        logs = {}
        return
    end

    local pLocalTickBase = ffi.cast("int*", pLocalController[netvars.m_nTickBase])[0]
    if not pLocalTickBase then return end

    local nOffset = 0
    for i = #logs, 1, -1 do
        local v = logs[i]
        local vecRenderPos = vec2_t(5, 350 + nOffset)
        v.flAlpha = Lerp(v.flAlpha, pLocalTickBase > v.nTickBase and 0 or 1, 20 * render.frame_time())
        
        render.text("[NIXWARE]", Verdana, vecRenderPos + 1, color_t(0, 0, 0, v.flAlpha * 0.25))
        render.text("[NIXWARE]", Verdana, vecRenderPos, colors.accent)

        vecRenderPos.x = vecRenderPos.x + 80
        render.text(v.szText, Verdana, vecRenderPos + 1, color_t(0, 0, 0, v.flAlpha * 0.25))
        render.text(v.szText, Verdana, vecRenderPos, color_t(1, 1, 1, v.flAlpha))

        nOffset = nOffset + 10 * v.flAlpha
        if v.flAlpha < 0.0001 then
            table.remove(logs, i)
        end
    end

    updateDisplayText()
end

register_callback("paint", fnOnPaint)


---------------------------------------Tracers---------------------------------------
local COLOR_RIGHT_HERE = color_t(140 / 255, 142 / 255, 255 / 255, 0.8)

xpcall(function()
    local print = function(...)

    end;
    local find_pattern_og = find_pattern
    find_pattern = function(a, b)
        local c = find_pattern_og(a, b)
        if not c then print(tostring(b) .. "  инвалид конкретный") end
        return c
    end

    if not pcall(ffi.sizeof, "struct CParticleInformation") then
        ffi.cdef([[
            typedef struct Vector {
                float x, y, z;
            } Vector;

            typedef struct CBindingData {
                void* pData;
                uint64_t nUnknown;
                uint64_t nUnknown2;
                uint32_t* pRefCount;
            } CBindingData;

            typedef struct CStrongHandle {
                struct CBindingData* pBinding;
            } CStrongHandle;

            typedef struct ZV {
                float r, g, b;
            } ZV;

            typedef struct CParticleEffect {
                const char* szName;
                char pad_01[0x30];
            } CParticleEffect;

            typedef struct CParticleData {
                Vector* vecPositions;
                char n1zex[0x74];
                float* flTimes;
                char niz3x[0x28];
                float* flTimes2;
                char nizex[0x98];
            } CParticleData;

            typedef struct CParticleInformation {
                float flTime;
                float flWidth;
                float flUnknown;
            } CParticleInformation;

            typedef struct vec3_t {
                float x, y, z;
            } vec3_t;

            typedef struct bullet_data {
                vec3_t position;
                float time_stamp;
                float expire_time;
            } bullet_data;
        ]])
    end

    local Abs = function(addr, pre, post)
        addr = ffi.cast("uintptr_t", addr);
        addr = addr + (pre or 1)
        addr = addr + ffi.sizeof("int") + ffi.cast("int64_t", ffi.cast("int*", addr)[0])
        addr = addr + (post or 0)
        return addr
    end;
    local anton_vfunc_CreateSnapshot = function (...) end
    local anton_vfunc_Draw = function (...) end
    local IParticleManager = setmetatable({
        pPatricleManager = nil,
        ppPatricleManager = (function()
            local ppParticleManager = assert(find_pattern("client.dll", "48 8B 05 ?? ?? ?? ?? 48 8B 08 48 8B 59 68"), "bullet tracer: not found patricle manager")
            ppParticleManager = ffi.cast("uintptr_t", ppParticleManager);
            return ffi.cast("void**", ppParticleManager + 7 + ffi.cast("int*", ppParticleManager + 3)[0])
        end)()
    }, {
        __index = {
            Get = function(this)
                return this.pPatricleManager
            end,

            Update = function(this)
                this.pPatricleManager = this.ppPatricleManager[0]
                anton_vfunc_CreateSnapshot = this:GetVFunc(42, "void(__thiscall*)(void*, struct CStrongHandle*, int64_t*)")
                anton_vfunc_Draw = this:GetVFunc(43, "void(__thiscall*)(void*, struct CStrongHandle*, int, void*)")
            end,

            IsValid = function(this)
                return this.pPatricleManager and this.ppPatricleManager and this.pPatricleManager ~= ffi.NULL and this.ppPatricleManager ~= ffi.NULL
            end,

            CallVFunc = function(this, nIndex, szType, ...)
                if not this:IsValid() then
                    return nil
                end

                local pVtable = ffi.cast("void***", this:Get())
                local func = ffi.cast(szType, pVtable[0][nIndex])

                if (not func or func == 0 or func == ffi.NULL) then
                    return nil; end;

                return func(this:Get(), ...)
            end,

            GetVFunc = function(this, nIndex, szType)
                if not this:IsValid() then
                    return nil
                end

                local pVtable = ffi.cast("void***", this:Get())
                local func = ffi.cast(szType, pVtable[0][nIndex])

                if (not func or func == 0 or func == ffi.NULL) then
                    return nil; end;

                return func
            end,

            CreateSnapshot = function(this, pSnapShotHandle)
                if not this:IsValid() then
                    return false
                end

                local pUtlStringData = ffi.new("int64_t[1]")
                this:CallVFunc(42, "void(__thiscall*)(void*, struct CStrongHandle*, int64_t*)", pSnapShotHandle, pUtlStringData)
                return true
            end,

            Draw = function(this, pSnapShotHandle, nCount, pEffectData)
                if not this:IsValid() then
                    return false
                end

                this:CallVFunc(43, "void(__thiscall*)(void*, struct CStrongHandle*, int, void*)", pSnapShotHandle, nCount, pEffectData)
                return true
            end
        }
    })

    local IGameParticleManager = setmetatable({
        pGameParticleManager = nil,
        fnSetEffectData = ffi.cast("void(__fastcall*)(void*, uint32_t, int, void*, int)", Abs(find_pattern("client.dll", "E8 ? ? ? ? 4C 39 A7 ? ? ? ?"), 1, 0)),
        fnCreateEffectIndex = ffi.cast("void(__fastcall*)(void*, uint32_t*, struct CParticleEffect*)", find_pattern("client.dll", "40 57 48 83 EC 20 49 8B ?? 48 8B")),
        fnCreateEffect2 = ffi.cast("void(__fastcall*)(void*, uint32_t*, const char*, int, int64_t, int64_t, int64_t, int)", Abs(find_pattern("client.dll", "E8 ? ? ? ? 33 D2 8B 08 89 4E 44"), 0x1, 0x0)),
        fnInitEffect = ffi.cast("bool(__fastcall*)(void*, int, uint32_t, struct CStrongHandle*)", find_pattern("client.dll", "48 89 74 24 10 57 48 83 EC 30 4C 8B D9 49 8B F9 33 C9 41 8B F0 83 FA FF 0F")),
        fnGetGameParticleManager = ffi.cast("void*(__fastcall*)()", find_pattern("client.dll", "48 8B ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? 48 89 5C 24 10 57 48 81 EC 70 06 ?? ?? 48 8B 1D"))
    }, {
        __index = {
            Get = function(this)
                return this.pGameParticleManager
            end,

            Update = function(this)
                this.pGameParticleManager = this.fnGetGameParticleManager()
            end,

            IsValid = function(this)
                return this.pGameParticleManager and this.pGameParticleManager ~= ffi.NULL
            end,

            CallVFunc = function(this, nIndex, szType, ...)
                if not this:IsValid() then
                    return -1337
                end

                local pVtable = ffi.cast("void***", this:Get())
                return ffi.cast(szType, pVtable[0][nIndex])(...)
            end,

            CreateEffectIndex = function(this, pEffectIndex, pEffectData)
                if not this:IsValid() then
                    return -1337
                end

                this.fnCreateEffectIndex(this:Get(), pEffectIndex, pEffectData)
            end,

            SetEffectData = function(this, nEffectIndex, nDataIndex, pData, nArg4)
                if not this:IsValid() then
                    return -1337
                end

                this.fnSetEffectData(this:Get(), nEffectIndex, nDataIndex, pData, nArg4)
            end,

            CreateEffect = function(this, pEffectIndex, szName)
                if not this:IsValid() then
                    return -1337
                end

                this.fnCreateEffect2(this:Get(), pEffectIndex, szName, 8, 0, 0, 0, 0)
            end,

            InitEffect = function(this, nEffectIndex, nUnknown, pSnapShotHandle)
                if not this:IsValid() then
                    return false
                end

                return this.fnInitEffect(this:Get(), nEffectIndex, nUnknown, pSnapShotHandle)
            end
        }
    })

    local szBeamMaterial = "particles/entity/spectator_utility_trail.vpcf"
    local function CreateBeamPoint(vecStart, vecEnd, clrColor)
        local pEffectIndex = ffi.new("uint32_t[1]")
        local pBeamColor = ffi.new("struct ZV[1]")
        for nIndex, szKey in pairs({ "r", "g", "b" }) do
            pBeamColor[0][szKey] = clrColor[szKey] * 255 or clrColor[nIndex] * 255 or 255
        end

        IParticleManager:Update()
        if ( not IParticleManager:IsValid() ) then return; end;
        IGameParticleManager:Update()
        if ( not IGameParticleManager:IsValid() ) then return; end;
        local vecDirection = (vecEnd - vecStart)
        local pEffectData = ffi.new("struct CParticleData[1]")
        local vecLinePointToEnd = vecStart + (vecDirection * 0.5)
        local vecCenterLinePoint = vecStart + (vecDirection * 0.3)
        local pSnapShotHandle = ffi.new("struct CStrongHandle[1]")
        if IGameParticleManager:CreateEffect(pEffectIndex, szBeamMaterial)  == -1337 then return end
        if IGameParticleManager:SetEffectData(pEffectIndex[0], 16, pBeamColor, 0) == -1337 then return end
        local pParticleInformation = ffi.new("struct CParticleInformation[1]")
        pParticleInformation[0].flUnknown = 1
        pParticleInformation[0].flWidth = 1
        pParticleInformation[0].flTime = 4
        if IGameParticleManager:SetEffectData(pEffectIndex[0], 3, pParticleInformation, 0) == -1337 then return end
        local vecStepPoints = { vecStart, vecCenterLinePoint, vecLinePointToEnd, vecEnd }
        for nIndex = 1, #vecStepPoints do
            pEffectData[0].flTimes = ffi.new(("float[%i]"):format(nIndex))
            pEffectData[0].vecPositions = ffi.new(("struct Vector[%i]"):format(nIndex))
            for nPointIndex = 1, nIndex do
                pEffectData[0].flTimes[nPointIndex - 1] = 0.015625 * nPointIndex
                for _, szKey in pairs({ "x", "y", "z" }) do
                    pEffectData[0].vecPositions[nPointIndex - 1][szKey] = vecStepPoints[nPointIndex][szKey]
                end
            end
            local pUtlStringData = ffi.new("int64_t[1]")
            if anton_vfunc_CreateSnapshot == nil then IParticleManager:Update() return; end;
            anton_vfunc_CreateSnapshot(IParticleManager:Get(), pSnapShotHandle, pUtlStringData)
            pEffectData[0].flTimes2 = pEffectData[0].flTimes
            if not IGameParticleManager:InitEffect(pEffectIndex[0], 0, pSnapShotHandle) then return; end
            if anton_vfunc_Draw == nil then IParticleManager:Update() return; end;
            anton_vfunc_Draw(IParticleManager:Get(), pSnapShotHandle, nIndex, pEffectData)
        end
    end

    local m_pGameSceneNode = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_pGameSceneNode");
	local m_pBulletServices = engine.get_netvar_offset("client.dll", "C_CSPlayerPawn", "m_pBulletServices");
	local m_vecAbsOrigin = engine.get_netvar_offset("client.dll", "CGameSceneNode", "m_vecAbsOrigin");
	local m_vecViewOffset = engine.get_netvar_offset("client.dll", "C_BaseModelEntity", "m_vecViewOffset");
	local m_iHealth = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_iHealth");

	local CUtlMemory = (function()
		return function(T, I)
			I = ffi.typeof(I or "int")
			local MT = {}

			local INVALID_INDEX = -1
			function MT:invalid_index()
				return INVALID_INDEX
			end

			function MT:is_idx_valid(i)
				local x = ffi.cast("long", i)
				return x >= 0 and x < self.m_allocation_count
			end

			MT.iterator_t = ffi.metatype(
				ffi.typeof([[ 
					struct {
						$ index; 
					}
				]], I),
				{
					__eq = function(self, it)
						if ffi.istype(self, it) then
							return self.index == it.index
						end
					end
				}
			)

			function MT:invalid_iterator()
				return MT.iterator_t(self:invalid_index())
			end

			return ffi.metatype(ffi.typeof([[ 
					struct {
						$* m_memory; 
						int m_allocation_count; 
						int m_grow_size; 
					} 
				]], ffi.typeof(T)), {
				__index = function(self, key)
					print(tostring("max: " ..tostring(#MT)))
					print(tostring("access: " ..tostring(key)))
					print(tostring("self.m_memory: " ..tostring(self.m_allocation_count)))
					if MT[key] then return MT[key] end
					if type(key) == "number" then
						if self:is_idx_valid(key) then
							return self.m_memory[key]
						else
							return nil
						end
					end
					return nil
				end
			})
		end
	end)() -- god bless china
	local anton_1 = ffi.typeof("struct {int m_size; $ m_memory;}", CUtlMemory("bullet_data"));
	local CUtlVector = (function()
		local MT = {}

		function MT:count()
			return self.m_size
		end

		function MT:element(i)
			print(tostring("max: " ..tostring(self.m_size)))
			print(tostring("access: " ..tostring(i)))
			if i > -1 and i < self.m_size then 
				return self.m_memory[i] 
			else
				return nil
			end
		end

		return function(T, A)
			return ffi.metatype(anton_1, {
				__index = function(self, key)
					if MT[key] then return MT[key] end
					if type(key) == "number" then 
						return self:element(key) 
					end
					return nil
				end,
				__ipairs = function(self)
					return function(t, i)
						i = i + 1
						local v = t[i]
						if v then return i, v end
					end, self, -1
				end
			})
		end
	end)() -- qi-ux
	local pBulletData_type = ffi.typeof("$*", CUtlVector("bullet_data"))
		local GetEyePos = function(pLocalPawn)
			local GameSceneNode = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_pGameSceneNode)[0];
			if not GameSceneNode or GameSceneNode == 0 then return vec3_t(0,0,0) end;
			local vecAbsOrigin = ffi.cast("struct vec3_t*", ffi.cast("uintptr_t", GameSceneNode) + m_vecAbsOrigin)[0];
			local vecViewOffset = ffi.cast("struct vec3_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_vecViewOffset)[0];
			
			return vec3_t(vecAbsOrigin.x + vecViewOffset.x, vecAbsOrigin.y + vecViewOffset.y, vecAbsOrigin.z + vecViewOffset.z);
		end;
		local last_count_bullet = 0;

		local fnOnPaint = function ()
			local pLocalPawn = entitylist.get_local_player_pawn()
			if not pLocalPawn or pLocalPawn == 0 or ffi.cast("int*", pLocalPawn[m_iHealth])[0] <= 0 then
				return
			end
		
			local vecEyePosition = GetEyePos(pLocalPawn)
			local pBulletServices = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_pBulletServices)[0]
			if not pBulletServices or pBulletServices == 0 then return end
		
			-- local pBulletData_type = ffi.typeof("$*", CUtlVector("bullet_data"))
			if not pBulletData_type then return end
			local pBulletData = ffi.cast(pBulletData_type, ffi.cast("uintptr_t", pBulletServices) + 0x48)[0]
			if not pBulletData then return end
		
			local maxIterations = 100
			if Controls["Tracers"] then
				for i = math.min(pBulletData:count(), last_count_bullet + maxIterations), last_count_bullet + 1, -1 do
					local element = pBulletData:element(i - 1)
					if element and element.position then
						CreateBeamPoint(vecEyePosition, vec3_t(element.position.x, element.position.y, element.position.z), COLOR_RIGHT_HERE)
					else
						print("😪 >> " .. tostring(i - 1))
					end
				end
			end
		
			if pBulletData:count() ~= last_count_bullet then 
				last_count_bullet = pBulletData:count()
			end
			goto zoov_
			last_count_bullet = 0;
			::zoov_::
		end
    register_callback("paint", fnOnPaint)
end,print)


---------------------------------------Preserve Killfeed---------------------------------------

local fnFindHudElement = ffi.cast("uintptr_t*(__fastcall*)(const char*)", find_pattern("client.dll", "40 55 48 83 EC 20 48 83"));
local fnClearNotices = ffi.cast("void(__fastcall*)(uintptr_t)", find_pattern("client.dll", "48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20 48 8B 71 68"));
local bClear = false;

local ClearNotices = function(hudPtr)
    fnClearNotices(ffi.cast("uintptr_t", hudPtr) - 0x28);
    bClear = false
end

local fnMain = function(bUnload)
    local hudPtr = fnFindHudElement("CCSGO_HudDeathNotice");
    if not hudPtr or hudPtr == nil then return end;
    ffi.cast("float*", ffi.cast("uintptr_t", hudPtr) + 0x50)[0] = bUnload and 1.5 or 99999999999999999999.0;
    if (bClear) then
        ClearNotices(hudPtr);
    end
end

local fnOnPaint = function()
    if Controls["KillFeed"] then
        fnMain(false);
    else
        fnMain(true);
    end
end

register_callback("paint", fnOnPaint)
register_callback("round_start", function(event)
    if Controls["KillFeed"] then
        bClear = true;
    end
end)
register_callback("unload", function()
    bClear = true;
    fnMain(true);
end)


function stoyaK()
    local sliderValue = Controls["Slider1"]
    local selectedOption = Controls["Dropdown1"]
    
    if Controls["killsay"] then
		
	end
	if Controls["Waterka"] then
        drawWatermark()
    end
---------------------------------------FOV Changer---------------------------------------
    if Controls["fovchanger"] then
        local sliderValue = Controls["Slider1"] or 130
        local m_iDesiredFOV = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_iDesiredFOV")
        local pLocalController = entitylist.get_local_player_controller()
        if pLocalController then
            ffi.cast("int*", pLocalController[m_iDesiredFOV])[0] = sliderValue
        end
	else
        local m_iDesiredFOV = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_iDesiredFOV")
        local pLocalController = entitylist.get_local_player_controller()
        if pLocalController then
            ffi.cast("int*", pLocalController[m_iDesiredFOV])[0] = 90
		end
    end
	if Controls["BulletImpacts"] then
		
	end
	if Controls["HitLogs"] then
	
	end
	if Controls["ManualAA"] then
	
	end
	if Controls["ManualAAPSALO"] then
	
	end
	if Controls["HitLogsCent"] then
	
	end
	if Controls["Tracers"] then
	
	end
    if Controls["KillFeed"] ~= prevKillFeedState then
        if not Controls["KillFeed"] then
            bClear = true;
            fnMain(true)
        end
        prevKillFeedState = Controls["KillFeed"]
    end
end




---------------------------------------Killsay Ru---------------------------------------
local phrases = {
    "Ребят, ну тренируйтесь, когда-нибудь и вы меня догоните... Может быть ",
    "А что, вы всегда такие медленные? Я думал, это просто задержка сервера!",
    "Эй, у кого тут лобби для новичков? Кажется, я ошибся игрой ",
    "Не переживайте, ещё пару тысяч часов, и вы почти как я.",
    "Ребят, я же не виноват, что ваши экраны не так быстро реагируют, как мой!",
    "Если это ваше лучшее, мне даже как-то неловко...",
    "Кажется, у вас появился шанс! Ловите скриншот на память.",
    "Стараюсь играть аккуратно, чтобы не расстраивать вас слишком сильно ",
    "Где же ваши хайлайты? А, точно, вы в тени моего мастерства!",
    "Давайте так: вы не будете ныть, а я немного снизил уровень... на 0.01%!",
    "Успокойтесь, ребят, это просто естественный талант! ",
    "Ощущение, что играю против ботов... кто-нибудь ещё здесь живой?",
    "Не обижайтесь, я просто даю вам повод для тренировок!",
    "Ну что, записали мой урок? Повторим ещё раз?",
    "Ой, простите, кажется, я случайно включил ‘режим бога’!",
    "Не переживайте, я на вас свои читы и тестирую!",
    "Даже и не знаю, что сказать... против вас скучно ",
    "Когда ты на пике формы, а противник всё ещё на разминке.",
    "Легко, как утренний кофе ☕️. Кто следующий?",
    "Вам там нормально, или мне сбавить обороты?",
    "Вы серьёзно? Я думал, это был разминочный раунд!",
    "Ребят, это матч или тренировка для новичков?",
    "Вам до меня ещё как до луны пешком.",
    "Сори, если слишком быстро для вас, это просто реакция!",
    "Мне кажется, что играю в соло — где вы все?",
    "Ваши скиллы тут точно не в приоритете.",
    "Ого, это вы так ‘атака’ называете? Забавно!",
    "Вы что, пингвинчики? Так медленно двигаетесь!",
    "Попробуйте угадать, где я появлюсь... или даже не пытайтесь.",
    "А может, я просто экс-чемпион мира? Вам не узнать!",
    "Такое чувство, что вы с завязанными глазами играете!",
    "Кто-то тут не на моём уровне... и это не я.",
    "Кажется, вы всё время на паузе, или это только кажется?",
    "Вы точно знали, что зашли в матч, а не в лобби для болтовни?",
    "А я могу даже без чата вас обыграть. Проверим?",
    "Когда вы уже начнете пытаться? Я вас жду!",
    "Даже с закрытыми глазами можно быть быстрее.",
    "Придётся снизить свою сложность, чтобы вам шансы дать.",
    "Тренируйтесь больше, а то я заскучаю.",
    "Можете сразу сдаться, я не обижусь!"
}

local counter = 0

register_callback("player_death", function(event)
    if Controls["killsay"] then
		if Controls["Dropdown1"] == 1 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd("say " .. phrases[counter % #phrases + 1])
				counter = counter + 1
			end
		end
    end
end)


---------------------------------------Killsay Skeet---------------------------------------
local phrasessk = {
    "𝕝𝕚𝕗𝕖 𝕚𝕤 𝕒 𝕘𝕒𝕞𝕖, 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕚𝕤 𝕙𝕠𝕨 𝕨𝕖 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖 ♛ 𝕞𝕒𝕜𝕖 𝕣𝕚𝕔𝕙 𝕞𝕒𝕚𝕟𝕤, 𝕟𝕠𝕥 𝕗𝕣𝕚𝕖𝕟𝕕𝕤",
    "𝙒𝙝𝙚𝙣 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙈𝙈 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙛𝙤𝙧 𝙬𝙞𝙣, 𝙙𝙤𝙣'𝙩 𝙨𝙘𝙖𝙧𝙚 𝙛𝙤𝙧 𝙨𝙥𝙞𝙣, 𝙞 𝙞𝙣𝙟𝙚𝙘𝙩 𝙧𝙖𝙜𝙚 ♕",
    "𝒯𝒽𝑒 𝓅𝓇𝑜𝒷𝓁𝑒𝓂 𝒾𝓈 𝓉𝒽𝒶𝓉 𝒾 𝑜𝓃𝓁𝓎 𝒾𝓃𝒿𝑒𝒸𝓉 𝒸𝒽𝑒𝒶𝓉𝓈 𝑜𝓃 𝓂𝓎 𝓂𝒶𝒾𝓃 𝓉𝒽𝒶𝓉 𝒽𝒶𝓋𝑒 𝓃𝒶𝓂𝑒𝓈 𝓉𝒽𝒶𝓉 𝓈𝓉𝒶𝓇𝓉 𝓌𝒾𝓉𝒽 𝓰 𝒶𝓃𝒹 𝑒𝓃𝒹 𝓌𝒾𝓉𝒽 𝓪𝓶𝓮𝓼𝓮𝓷𝓼𝓮",
    "(◣_◢) 𝕐𝕠𝕦 𝕒𝕨𝕒𝕝𝕝 𝕗𝕚𝕣𝕤𝕥? 𝕆𝕜 𝕝𝕖𝕥𝕤 𝕗𝕦𝕟 slightsmile (◣_◢)",
    "ｉ ｃａｎｔ ｌｏｓｅ ｏｎ ｏｆｆｉｃｅ ｉｔ ｍｙ ｈｏｍｅ",
    "𝕞𝕒𝕚𝕟 𝕟𝕖𝕨= 𝕔𝕒𝕟 𝕓𝕦𝕪.. 𝕙𝕧𝕙 𝕨𝕚𝕟? 𝕕𝕠𝕟𝕥 𝕥𝕙𝕚𝕟𝕜 𝕚𝕞 𝕔𝕒𝕟, 𝕚𝕞 𝕝𝕠𝕒𝕕 𝕣𝕒𝕘𝕖 ♕",
    "♛Ａｌｌ   Ｆａｍｉｌｙ   ｉｎ   ｇｓ♛",
    "u will 𝕣𝕖𝕘𝕣𝕖𝕥 rage vs me when i go on ｌｏｌｚ．ｇｕｒｕ acc.",
    "𝔻𝕠𝕟𝕥 𝕒𝕕𝕕 𝕞𝕖 𝕥𝕠 𝕨𝕒𝕣 𝕠𝕟 𝕞𝕪 𝕤𝕞𝕦𝕣𝕗 (◣_◢) 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖 𝕒𝕝𝕨𝕒𝕪𝕤 𝕣𝕖𝕒𝕕𝕪 ♛",
    "♛ 𝓽𝓾𝓻𝓴𝓲𝓼𝓱 𝓽𝓻𝓾𝓼𝓽 𝓯𝓪𝓬𝓽𝓸𝓻 ♛",
    "𝕕𝕦𝕞𝕓 𝕕𝕠𝕘, 𝕪𝕠𝕦 𝕒𝕨𝕒𝕜𝕖 𝕥𝕙𝕖 ᴅʀᴀɢᴏɴ ʜᴠʜ ᴍᴀᴄʜɪɴᴇ, 𝕟𝕠𝕨 𝕪𝕠𝕦 𝕝𝕠𝕤𝕖 𝙖𝙘𝙘 𝕒𝕟𝕕 𝚐𝚊𝚖𝚎 ♕",
    "♛ 𝕞𝕪 𝕙𝕧𝕙 𝕥𝕖𝕒𝕞 𝕚𝕤 𝕣𝕖𝕒𝕕𝕪 𝕘𝕠 𝟙𝕩𝟙 𝟚𝕩𝟚 𝟛𝕩𝟛 𝟜𝕩𝟜 𝟝𝕩𝟝 (◣_◢)",
    "ᴀɢᴀɪɴ ɴᴏɴᴀᴍᴇ ᴏɴ ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ. ɪ ꜱᴇᴇ ᴀɢᴀɪɴ ᴀᴄᴛɪᴠɪᴛʏ.",
    "ɴᴏɴᴀᴍᴇ ʟɪꜱᴛᴇɴ ᴛᴏ ᴍᴇ ! ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ ɪꜱ ɴᴏᴛ ʏᴏᴜʀ ᴘʀᴏᴘᴇʀᴛʏ.",
    "𝙋𝙤𝙤𝙧 𝙖𝙘𝙘 𝙙𝙤𝙣’𝙩 𝙘𝙤𝙢𝙢𝙚𝙣𝙩 𝙥𝙡𝙚𝙖𝙨𝙚 ♛",
    "𝕥𝕣𝕪 𝕥𝕠 𝕥𝕖𝕤𝕥 𝕞𝕖? (◣_◢) 𝕞𝕪 𝕞𝕚𝕕𝕕𝕝𝕖 𝕟𝕒𝕞𝕖 𝕚𝕤 𝕘𝕖𝕟𝕦𝕚𝕟𝕖 𝕡𝕚𝕟 ♛",
    "𝓭𝓸𝓷𝓽 𝓝𝓝",
    "ℕ𝕠 𝕆𝔾 𝕀𝔻? 𝔻𝕠𝕟'𝕥 𝕒𝕕𝕕 𝕞𝕖 𝓷𝓲𝓰𝓰𝓪",
    "𝐻𝒱𝐻 𝐿𝑒𝑔𝑒𝓃𝒹𝑒𝓃 𝟤𝟢𝟤𝟤 𝑅𝐼𝒫 𝐿𝒾𝓁 𝒫𝑒𝑒𝓅 & 𝒳𝓍𝓍𝓉𝑒𝒶𝓃𝒸𝒾𝑜𝓃 & 𝒥𝓊𝒾𝒸𝑒 𝒲𝓇𝓁𝒹",
    "𝕚 𝕘𝕤 𝕦𝕤𝕖𝕣, 𝕟𝕠 𝕘𝕤 𝕟𝕠 𝕥𝕒𝕝𝕜",
    "𝐨𝐮𝐫 𝐥𝐢𝐟𝐞 𝐦𝐨𝐭𝐨 𝐢𝐬 𝐖𝐈𝐍 > 𝐀𝐂𝐂",
    "𝕗𝕦𝕔𝕜 𝕪𝕠𝕦𝕣 𝕗𝕒𝕞𝕚𝕝𝕪 𝕒𝕟𝕕 𝕗𝕣𝕚𝕖𝕟𝕕𝕤, 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕦𝕡 ♚",
    "𝚜𝚎𝚖𝚒𝚛𝚊𝚐𝚎 𝚝𝚒𝚕𝚕 𝚢𝚘𝚞 𝚍𝚒𝚎, 𝚋𝚞𝚝 𝚠𝚎 𝚕𝚒𝚟𝚎 𝚏𝚘𝚛𝚎𝚟𝚎𝚛 (◣_◢)",
    "𝔂𝓸𝓾 𝓭𝓸𝓷𝓽 𝓷𝓮𝓮𝓭 𝓯𝓻𝓲𝓮𝓷𝓭𝓼 𝔀𝓱𝓮𝓷 𝔂𝓸𝓾 𝓱𝓪𝓿𝓮 𝓰𝓪𝓶𝓮𝓼𝓮𝓷𝓼𝓮",
    "-ᴀᴄᴄ? ᴡʜᴏ ᴄᴀʀꜱ ɪᴍ ʀɪᴄʜ ʜʜʜʜʜʜ",
    "𝚢𝚘𝚞 𝚊𝚠𝚊𝚕𝚕 𝚏𝚒𝚛𝚜𝚝? 𝚘𝚔 𝚕𝚎𝚝𝚜 𝚏𝚞𝚗 :)",
    "𝕤𝕠𝕣𝕣𝕪 𝕔𝕒𝕟𝕥 𝕙𝕖𝕒𝕣 𝕤𝕜𝕖𝕖𝕥𝕝𝕖𝕤𝕤",
    "𝔂𝓸𝓾 𝓬𝓪𝓶𝓽 𝓺𝓾𝓲𝓬𝓴 𝓹𝓮𝓪𝓴 𝓱𝓿𝓱 𝓴𝓲𝓷𝓰",
    "ｎｉｃｅ ｔｒｙ ｐｏｏｒ ｄｏｇ",
    "𝔸𝕃𝕃 𝔻𝕆𝔾𝕊 𝕃𝕆𝕊𝔼 𝕋𝕆 𝔾𝕊",
    "𝙼𝚈 𝙱𝙾𝚃𝙽𝙴𝚃 𝙳𝙾𝙴𝚂𝙽𝚃 𝙲𝙰𝚁𝙴 𝙰𝙱𝙾𝚄𝚃 𝚈𝙾𝚄𝚁 𝙵𝙴𝙴𝙻𝙸𝙽𝙶𝚂",
    "𝕚𝕟 𝟝𝕧𝕤𝟝 𝕚𝕞 𝕒𝕝𝕨𝕒𝕪𝕤 𝕤𝕡𝕖𝕒𝕜 𝕗𝕠𝕣 𝕥𝕖𝕒𝕞, 𝔻𝕆ℕ𝕋 𝕘𝕠𝕚𝕟𝕘 𝕗𝕠𝕣 𝕙𝕖𝕒𝕕𝕤, 𝔹𝕆𝔻𝕐𝔸𝕀𝕄𝕊, 𝕓𝕦𝕥 𝕕𝕠𝕘𝕤 𝕟𝕖𝕧𝕖𝕣 𝕨𝕒𝕟𝕥 𝕝𝕚𝕤𝕥𝕖𝕟",
    'Ｙｏｕｒ ｃｈｅａｔ ｉｓ ｎｏｔ ｔｈｅ ｐｒｏｂｌｅｍ， ｂｕｔ ｔｈａｔ ｙｏｕ ｗｅｒｅ ｂｏｒｎ．',
    '𝐓𝐡𝐞 𝐨𝐧𝐥𝐲 𝐭𝐡𝐢𝐧𝐠 𝐥𝐨𝐰𝐞𝐫 𝐭𝐡𝐚𝐧 𝐲𝐨𝐮𝐫 𝐤/𝐝 𝐫𝐚𝐭𝐢𝐨 𝐢𝐬 𝐲𝐨𝐮𝐫 𝐩𝐞𝐧𝐢𝐬 𝐬𝐢𝐳𝐞.',
    '˜”*°•.˜”*°• ʏᴏᴜʀ ᴍᴏᴛʜᴇʀ ᴡᴏᴜʟᴅ ʜᴀᴠᴇ ᴅᴏɴᴇ ʙᴇᴛᴛᴇʀ ᴛᴏ ꜱᴡᴀʟʟᴏᴡ ʏᴏᴜ. •°*”˜.•°*”˜',
    '𝓘 𝓯𝓾𝓬𝓴𝓮𝓭 𝔂𝓸𝓾 𝓾𝓹.',}

local counter = 0
register_callback("player_death", function(event)
    if Controls["killsay"] then
		if Controls["Dropdown1"] == 2 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd("say " .. phrasessk[counter % #phrasessk + 1])
				counter = counter + 1
			end
		end
	end
end)


---------------------------------------HitLogs---------------------------------------
local font = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 16, 12)
local bodoniFont = render.setup_font("C:/Windows/Fonts/BellMT/BELL.ttf", 16, 12)
local whiteColor = color_t(1, 1, 1, 1)
local blackColor = color_t(0, 0, 0, 0.75)
local m_sSanitizedPlayerName = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName")
local m_hOriginalController = engine.get_netvar_offset("client.dll", "C_CSPlayerPawnBase", "m_hOriginalController")
local m_nTickBase = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_nTickBase")
local accent = color_t(0.8, 1, 0.2588235294117647, 1)
local logs = {}
local frameCount = 0
local lastTime = os.clock()
local currentFPS = 0
local notificationDuration = 4
local fadeDuration = 1
local maxLogs = 10
local function GetHitgroupName(nHitgroup)
    if nHitgroup == 1 then
        return "head"
    elseif nHitgroup == 2 then
        return "chest"
    elseif nHitgroup == 0 then
        return "generic"
    elseif nHitgroup == 4 or nHitgroup == 5 then
        return "arms"
    elseif nHitgroup == 8 then
        return "neck"
    elseif nHitgroup == 6 or nHitgroup == 7 then
        return "legs"
    elseif nHitgroup == 3 then
        return "stomach"
    else
        return "unknown"
    end
end
local function fnOnPlayerHurt(event)
	if Controls["HitLogs"] then
		local pLocalPawn = event:get_pawn("attacker")
		if pLocalPawn ~= entitylist.get_local_player_pawn() then return end
		local pLocalController = entitylist.get_local_player_controller()
		if not pLocalController then return end
	   
		local pLocalTickBase = ffi.cast("int*", pLocalController[m_nTickBase])[0]
	 
		local pTargetController = event:get_controller("userid")
		if not pTargetController then return end
	   
		local szName = ffi.string(ffi.cast("char**", pTargetController[m_sSanitizedPlayerName])[0])
	   
		local nHealth = event:get_int("health")
		local nDamage = event:get_int("dmg_health")
		local nHitgroup = event:get_int("hitgroup")
		local szHitgroup = GetHitgroupName(nHitgroup)
		local Text = string.format("Hit %s in the %s for %d damage (%d health remaining)", szName, szHitgroup, nDamage, nHealth)
		print(Text)
		if #logs < maxLogs then
			table.insert(logs, {text = Text, alpha = 1.0, startTime = os.clock(), isFading = false})
		end
	end
end
local function fnOnPaint()
	frameCount = frameCount + 1
	local currentTime = os.clock()
	if currentTime - lastTime >= 1 then
		currentFPS = frameCount
		lastTime = currentTime
		frameCount = 0
	end
	local screenWidth = 1920
	local screenHeight = 1080
	local fpsPos = vec2_t(screenWidth / 2, screenHeight - 20)
	render.text(string.format("FPS: %d", currentFPS), font, fpsPos - vec2_t(30, 0), whiteColor)
	local offset = 10
	for i = 1, #logs do
		local log = logs[i]
	   
		if not log.isFading and currentTime - log.startTime > notificationDuration then
			log.isFading = true
			log.fadeStartTime = currentTime
		end
		if log.isFading then
			local fadeProgress = currentTime - log.fadeStartTime
			if fadeProgress < fadeDuration then
				log.alpha = 1 - (fadeProgress / fadeDuration)
			else
				log.alpha = 0
			end
		end
		if log.alpha > 0 then
			local logPos = vec2_t(10 - (1 - log.alpha) * 100, offset)
			render.text("Hit", font, logPos, color_t(0.8, 1, 0.2588235294117647, log.alpha))
			render.text(log.text:sub(5), font, logPos + vec2_t(40, 0), color_t(1, 1, 1, log.alpha))
			offset = offset + 25
		end
	end
	for i = #logs, 1, -1 do
		if logs[i].alpha <= 0 then
			table.remove(logs, i)
		end
	end
end
register_callback("paint", fnOnPaint)
register_callback("player_hurt", fnOnPlayerHurt)



---------------------------------------ManualAA---------------------------------------
local STATES = {
    [0x5A] = 90,  -- Z key
    [0x43] = -90, -- C key

    default = 180
}

local ENABLE_INDICATOR = true
local INDICATOR_COLOR = color_t(0.72, 0.76, 1, 1)
local INDICATOR_DISTANCE = 40

--

ffi.cdef [[
    unsigned short GetAsyncKeyState(int vKey);
]]

local function is_key_pressed(virtualKey)
    return bit.band(ffi.C.GetAsyncKeyState(virtualKey), 32768) == 32768
end

local held_keys_cache = {}

register_callback("paint", function()
	if Controls["ManualAA"] then
		for k, v in pairs(STATES) do
			if k == "default" then
				goto continue
			end

			local is_key_held = is_key_pressed(k)

			if (not held_keys_cache[k]) and is_key_held then
				if menu.ragebot_anti_aim_base_yaw_offset == v then
					menu.ragebot_anti_aim_base_yaw_offset = STATES["default"]
				else
					menu.ragebot_anti_aim_base_yaw_offset = v
				end
			end

			held_keys_cache[k] = is_key_held

			::continue::
		end

		if ENABLE_INDICATOR then
			if not entitylist.get_local_player_pawn() then return end

			local screen_center = vec2_t(
				render.screen_size().x / 2,
				render.screen_size().y / 2
			)

			local offset = menu.ragebot_anti_aim_base_yaw_offset

			local manual =
				(offset >= 45 and offset <= 145) and 2 or
				(offset <= -75 and offset >= -145) and 1 or
				0

			render.filled_polygon(
				{
					vec2_t(screen_center.x + (INDICATOR_DISTANCE + 15), screen_center.y),
					vec2_t(screen_center.x + (INDICATOR_DISTANCE + 2), screen_center.y - 9),
					vec2_t(screen_center.x + (INDICATOR_DISTANCE + 2), screen_center.y + 9)
				},
				manual == 1 and INDICATOR_COLOR or color_t(0, 0, 0, 0.4)
			)

			render.filled_polygon(
				{
					vec2_t(screen_center.x - (INDICATOR_DISTANCE + 15), screen_center.y),
					vec2_t(screen_center.x - (INDICATOR_DISTANCE + 2), screen_center.y - 9),
					vec2_t(screen_center.x - (INDICATOR_DISTANCE + 2), screen_center.y + 9)
				},
				manual == 2 and INDICATOR_COLOR or color_t(0, 0, 0, 0.4)
			)
		end
	end
end)
register_callback("unload", function()
	menu.ragebot_anti_aim_base_yaw_offset = STATES["default"]
end)


---------------------------------------PSilent ManualAA---------------------------------------
local STATES = {
    [0x5A] = 147,  -- Z key
    [0x43] = -142, -- C key

    default = 180
}

local ENABLE_INDICATORP = true
local INDICATOR_COLORP = color_t(0.72, 0.76, 1, 1)
local INDICATOR_DISTANCEP = 40

--

ffi.cdef [[
    unsigned short GetAsyncKeyState(int vKey);
]]

local function is_key_pressed(virtualKey)
    return bit.band(ffi.C.GetAsyncKeyState(virtualKey), 32768) == 32768
end

local held_keys_cache = {}

register_callback("paint", function()
	if Controls["ManualAAPSALO"] then
		for k, v in pairs(STATES) do
			if k == "default" then
				goto continue
			end

			local is_key_held = is_key_pressed(k)

			if (not held_keys_cache[k]) and is_key_held then
				if menu.ragebot_anti_aim_base_yaw_offset == v then
					menu.ragebot_anti_aim_base_yaw_offset = STATES["default"]
				else
					menu.ragebot_anti_aim_base_yaw_offset = v
				end
			end

			held_keys_cache[k] = is_key_held

			::continue::
		end

		if ENABLE_INDICATORP then
			if not entitylist.get_local_player_pawn() then return end

			local screen_center = vec2_t(
				render.screen_size().x / 2,
				render.screen_size().y / 2
			)

			local offset = menu.ragebot_anti_aim_base_yaw_offset

			local manual =
				(offset >= 45 and offset <= 148) and 2 or
				(offset <= -75 and offset >= -148) and 1 or
				0

			render.filled_polygon(
				{
					vec2_t(screen_center.x + (INDICATOR_DISTANCEP + 15), screen_center.y),
					vec2_t(screen_center.x + (INDICATOR_DISTANCEP + 2), screen_center.y - 9),
					vec2_t(screen_center.x + (INDICATOR_DISTANCEP + 2), screen_center.y + 9)
				},
				manual == 1 and INDICATOR_COLORP or color_t(0, 0, 0, 0.4)
			)

			render.filled_polygon(
				{
					vec2_t(screen_center.x - (INDICATOR_DISTANCEP + 15), screen_center.y),
					vec2_t(screen_center.x - (INDICATOR_DISTANCEP + 2), screen_center.y - 9),
					vec2_t(screen_center.x - (INDICATOR_DISTANCEP + 2), screen_center.y + 9)
				},
				manual == 2 and INDICATOR_COLORP or color_t(0, 0, 0, 0.4)
			)
		end
	end
end)
register_callback("unload", function()
	menu.ragebot_anti_aim_base_yaw_offset = STATES["default"]
end)


---------------------------------------HitLogs Center---------------------------------------
local config = {
    hit_logs = true,
    harm_logs = true,
    hit_color = color_t(0.3, 1, 0.3, 1),
    harm_color = color_t(1, 0.3, 0.3, 1),
    y_offset = 100
}

local log = {}
local logs = {}

math.calculate_count = function(text, search)
    local count = 0
    for i = 1, #text do
        if text:sub(i, i) == search then
            count = count + 1
        end
    end
    return count
end

render.shadow_text = function(text, font, pos, color, size)
    pos.y = pos.y + 0.5
    render.text(text, font, pos + 1, color_t(0, 0, 0, color.a), size)
    render.text(text, font, pos, color, size)
end

local string_to_color = {
    ["white"] = color_t(1, 1, 1, 1),
    ["black"] = color_t(0, 0, 0, 1),
    ["hit"] = config.hit_color,
    ["harm"] = config.harm_color,
}

local m_sSanitizedPlayerName = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName");
local m_nTickBase = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_nTickBase");

log.print = function(text, prefix_color)
    print("[nixware] \0", string_to_color[prefix_color])
    local string = text
    local full_text = ""
    local colored_text = {}
    for i = 1, math.calculate_count(string, "{") do
        local start_prefix = string:find("{")
        local end_prefix = string:find("}")
        local color = string:sub(start_prefix + 1, end_prefix - 1)
        local next_string = string:sub(end_prefix + 1)
        local next_prefix_start = next_string:find("{")
        local new_string = next_prefix_start and next_string:sub(1, next_prefix_start - 1) or next_string
        string = next_string
        print(new_string .. "\0", string_to_color[color])
        full_text = full_text .. new_string
        table.insert(colored_text, { text = new_string, color = string_to_color[color] })
    end
    print("")
    table.insert(logs, 1, { alpha = 0, tick_base = ffi.cast("int*", entitylist.get_local_player_controller()[m_nTickBase])[0] + (3 / 0.015625), full_text = full_text, colored_text = colored_text })
end

math.lerp = function(a, b, time)
    return a + (b - a) * time
end

local font = {render.setup_font("C:/windows/fonts/verdana.ttf", 11, 400), 11}

log.render = function()
    local offset = 0
    for i, v in pairs(logs) do
        local tick_base = ffi.cast("int*", entitylist.get_local_player_controller()[m_nTickBase])[0]
        if tick_base < v.tick_base and i <= 10 then
            v.alpha = math.lerp(v.alpha, 1, 0.13)
        else
            v.alpha = math.lerp(v.alpha, 0, 0.13)
            if v.alpha < 0.1 then
                table.remove(logs, i)
            end
        end
        local text_size = 0
        local screen_size = render.screen_size()
        local pos = vec2_t(screen_size.x / 2 - render.calc_text_size(v.full_text, font[1], font[2]).x / 2, screen_size.y / 2 + config.y_offset)
        for k, f in pairs(v.colored_text) do
            f.color.a = v.alpha
            render.shadow_text(f.text, font[1], vec2_t(pos.x + text_size, pos.y + offset), f.color, font[2])
            text_size = text_size + render.calc_text_size(f.text, font[1], font[2]).x
        end
        offset = offset + 16 * v.alpha
    end
end

local hitgroups = {
    [0] = "generic",
    [1] = "head",
    [2] = "chest",
    [3] = "stomach",
    [4] = "left arm",
    [5] = "right arm",
    [6] = "left leg",
    [7] = "right leg",
    [8] = "neck"
}

log.player_hurt = function(event)
	if Controls["HitLogsCent"] then
		local local_player = entitylist.get_local_player_controller()
		if not local_player then return end
		local attacker = event:get_controller("attacker")
		local attacker_name = "World"
		if attacker then
			attacker_name = ffi.string(ffi.cast("char**", attacker[m_sSanitizedPlayerName])[0])
		end
		local target = event:get_controller("userid")
		if not target then return end
		local target_name = ffi.string(ffi.cast("char**", target[m_sSanitizedPlayerName])[0])
		local remaining = event:get_int("health")
		local damage = event:get_int("dmg_health")
		local hitgroup = hitgroups[event:get_int("hitgroup")]
		local self_harm = false
		if attacker == local_player and target == local_player then
			self_harm = true
			attacker_name = "yourself"
		end
		local is_fatal = remaining == 0
		if target == local_player and config.harm_logs then
			local harm_result = (is_fatal and "Killed" or "Harmed") .. (self_harm and "" or " by")
			hitgroup = hitgroup == "generic" and "" or (" in {harm}%s{white}"):format(hitgroup)
			damage = is_fatal and "" or (" for {harm}%s"):format(damage)
			log.print(("{white}%s {harm}%s{white}%s%s"):format(harm_result, attacker_name, hitgroup, damage), "harm")
		elseif attacker == local_player and config.hit_logs then
			local hit_result = is_fatal and "Killed" or "Hit"
			hitgroup = (hitgroup == "generic" or hitgroup == "gear") and "" or (is_fatal and " in" or "'s") .. (" {hit}%s{white}"):format(hitgroup)
			damage = is_fatal and "" or (" for {hit}%s"):format(damage)
			target_name = hitgroup == "{white}" and target_name or ("%s{white}"):format(target_name)
			log.print(("{white}%s {hit}%s%s%s"):format(hit_result, target_name, hitgroup, damage), "hit")
		end
	end
end

register_callback("paint", log.render)
register_callback("player_hurt", log.player_hurt)