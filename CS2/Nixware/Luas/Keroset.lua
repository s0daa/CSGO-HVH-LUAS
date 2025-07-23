-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local ffi = require("ffi")


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
    LineHeight = 20.5,
    LuaName = "KEROSET",
    Base = {
        Indent = 10,
        Tabs = {
            Width = 120,
            Height = 40,
            Names = {
                "Visual",
                "Misc",
				"Antiaim",
				"Kill Feed",
				"Buy Bot",
				
            }
        },
        Color = {
            Accent = color_t(0.6588235294117647, 0.6666666666666666, 1, 1),
            Main = color_t(25 / 255, 25 / 255, 25 / 255, 1),
            Stroke = color_t(140 / 255, 142 / 255, 255 / 255, 1),
            Name = color_t(1, 1, 1, 1),
            Text = color_t(140 / 255, 142 / 255, 255 / 255, 1),
            SubText = color_t(1, 1, 1, 150 / 255),
            Active = color_t(100 / 255, 100 / 255, 100 / 255, 1),
            InActive = color_t(60 / 255, 60 / 255, 60 / 255, 1),
            Prompt = color_t(140 / 255, 142 / 255, 255 / 255, 0.8)
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
--------Custom Sounds----------
local custom_sound_1 = "play sounds/(your custom sound)"
local custom_sound_s1 = "play sounds/ambient/misc/shutter1"
local custom_sound_s2 = "play sounds/ambient/misc/shutter2"
local custom_sound_s3 = "play sounds/ambient/misc/shutter3"
local custom_sound_z1 = "play sounds/ambient/energy/zap1"
local custom_sound_z2 = "play sounds/ambient/energy/zap2"
local custom_sound_z3 = "play sounds/ambient/energy/zap3"
local death_occurred = false
---------------------------------

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
	damagesound = false,
	killsound = false,
	Waterka = true,
    Slider1 = 90,
	SliderLeft = 90,
	SliderRight = 90,
	SliderTL = 90,
	SliderTS = 90,
	SliderTI = 90,
	SliderTR1 = 90,
	SliderTG1 = 90,
	SliderTB1 = 90,
	SliderTR2 = 90,
	SliderTG2 = 90,
	SliderTB2 = 90,
    Dropdown1 = 1,
	Dropdown2 = 1,
	Dropdown3 = 1,
	Dropdown4 = 1,
	Dropdown5 = 1,
	Dropdown6 = 1,
	Dropdown7 = 1,
	Dropdown8 = 1,
    Slider1Input = "",
	SliderLeftInput = "",
	SliderRightInput = "",
	SliderTLInput = "",
	SliderTSInput = "",
	SliderTIInput = "",
	SliderTR1Input = "",
	SliderTG1Input = "",
	SliderTB1Input = "",
	SliderTR2Input = "",
	SliderTG2Input = "",
	SliderTB2Input = "",
    Slider1Editing = false,
	SliderLeftEditing = false,
	SliderRightEditing = false,
	SliderTLEditing = false,
	SliderTSEditing = false,
	SliderTIEditing = false,
	SliderTR1Editing = false,
	SliderTG1Editing = false,
	SliderTB1Editing = false,
	SliderTR2Editing = false,
	SliderTG2Editing = false,
	SliderTB2Editing = false	
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
        engine.execute_client_cmd("-attack") 
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
		
		Checkbox("FOV", "fovchanger", posX, posY)
        posY = posY + 10

        Slider("", "Slider1", posX, posY, 0, 160)
        posY = posY + 43
		
		Checkbox("Bullet Tracers", "Tracers", posX, posY)
        posY = posY + 30
		
		Checkbox("Hitlogs", "HitLogs", posX, posY)
        posY = posY + 30
		
		Checkbox("Hitlogs Centered", "HitLogsCent", posX, posY)
        posY = posY + 30
		
		Checkbox("Binds List", "MenuBinds", posX, posY)
        posY = posY + 30
		
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
        posY = posY + 25

		--Checkbox("Radar Reveal", "RadarR", posX, posY)
		--posY = posY + 30 -- Not currently used, please find a way to make radar not show up all the time
		
		
    end
	
	if ActiveTab == 2 then
	    
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
        posY = posY + 15
		
		Checkbox("Fake Report", "Fakerep", posX, posY)
        posY = posY + 30
		
        Checkbox("Kill Say", "killsay", posX, posY)
        posX = posX + 125
		posY = posY - 20
		
		Dropdown("", "Dropdown1", posX, posY, {"Ru 1", "Skeet", "1", "Toxic", "Ru 2"})
		posY = posY + 80
		posX = posX - 125
		
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
        posY = posY + 25
		
		Checkbox("Damage Sound", "damagesound", posX, posY)
		posX = posX + 125
		posY = posY - 20
		
		Dropdown("", "Dropdown3", posX, posY, {"Shutter1", "Shutter2", "Shutter3", "Zap1", "Zap2", "Zap3", "Custom"})
		posY = posY + 80
		posX = posX - 125
		
		Checkbox("Kill Sound", "killsound", posX, posY)
        posX = posX + 125
		posY = posY - 20
		
		Dropdown("", "Dropdown2", posX, posY, {"Shutter1", "Shutter2", "Shutter3", "Zap1", "Zap2", "Zap3",  "Custom"})
		posY = posY + 80
		posX = posX - 125
		
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
        posY = posY + 25
		
    end
	
	if ActiveTab == 3 then
	    
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
        posY = posY + 15
		

		Checkbox("Manuals", "ManualAA", posX, posY)
        posY = posY + 30
	
		Checkbox("Manuals Jitter", "ManualAAPSALO", posX, posY)
        posY = posY + 30
		
		Slider("Jitter Left", "SliderLeft", posX, posY, 0, 160)
        posY = posY + 43
		
		Slider("Jitter Right", "SliderRight", posX, posY, 0, 160)
        posY = posY + 43
		
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
        posY = posY + 25
		
		Checkbox("Freestanding", "fstand", posX, posY)
        posY = posY + 30
		
    end
	if ActiveTab == 4 then
	    
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
        posY = posY + 15
		
		Checkbox("Preserve Killfeed", "KillFeed", posX, posY)
		posY = posY + 30
		
		Checkbox("Fake Killfeed", "FakeFeed", posX, posY)
		posY = posY + 30
		
		Checkbox("Headshot", "headshot", posX, posY)
		posY = posY + 30
		
		Checkbox("Flash Assist", "assistedflash", posX, posY)
		posY = posY + 30
		
		Checkbox("Noscope", "noscope", posX, posY)
		posY = posY + 30
		
		Checkbox("Wallbang", "wallbang", posX, posY)
		posY = posY + 30
		
		Checkbox("Revenge", "revenge", posX, posY)
		posY = posY + 30
		
		Checkbox("Dominated", "dominated", posX, posY)
		posY = posY + 30
		
		Checkbox("In Air", "inair", posX, posY)
		posY = posY - 180
		posX = posX + 200
		
		Checkbox("Headshot Off", "headshoto", posX, posY)
		posY = posY + 30
		
		Checkbox("Flash Assist Off", "assistedflasho", posX, posY)
		posY = posY + 30
		
		Checkbox("Noscope Off", "noscopeo", posX, posY)
		posY = posY + 30
		
		Checkbox("Wallbang Off", "wallbango", posX, posY)
		posY = posY + 30
		
		Checkbox("Revenge Off", "revengeo", posX, posY)
		posY = posY + 30
		
		Checkbox("Dominated Off", "dominatedo", posX, posY)
		posY = posY + 30
		
		Checkbox("In Air Off", "inairo", posX, posY)
		posX = posX - 200
		posY = posY + 43
		
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
        posY = posY - 25
		
    end
	if ActiveTab == 5 then
	    
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
        posY = posY + 25
		
		Checkbox("Buybot rage", "buybotr", posX, posY)
		posY = posY + 30
		
		Checkbox("Main", "mainweapon", posX, posY)
        posX = posX + 100
		posY = posY - 20
		
		Dropdown("", "Dropdown4", posX, posY, {"Scout", "Auto", "AWP", })
		posY = posY + 50
		posX = posX - 100
		
		Checkbox("Secondary", "secondweapon", posX, posY)
        posX = posX + 100
		posY = posY - 20
		
		Dropdown("", "Dropdown5", posX, posY, {"Deagle", "Revolver", "Dualies"})
		posY = posY + 100
		posX = posX - 100
		
		DrawSeparator(posX - indent , posY, width - tabs.Width - 22 * indent)
        posY = posY + 15
		
		Checkbox("Buybot legit", "buybotlegit", posX, posY)
		posY = posY + 30
		
		Checkbox("Ak", "ak47", posX, posY)
		posY = posY + 30
		
		Checkbox("M4A1", "m4a1", posX, posY)
		posY = posY + 30
		
		Checkbox("M4A4", "m4a4", posX, posY)
		posY = posY - 230
		posX = posX + 260
		
		Checkbox("He Grenade", "heg", posX, posY)
		posY = posY + 30
		
		Checkbox("Smoke", "smoke", posX, posY)
		posY = posY + 30
		
		Checkbox("Molotov", "molotov", posX, posY)
		posY = posY + 30
		
		Checkbox("Flash", "flash", posX, posY)
		posY = posY + 30
		
		Checkbox("Vest", "vestb", posX, posY)
		posY = posY + 10
		posX = posX - 50
		
		Dropdown("", "Dropdown6", posX, posY, {"Vest", "Vest and Helmet"})
		posY = posY + 50
		posX = posX + 50		
		
		Checkbox("Taser", "taser", posX, posY)
        posY = posY + 30
		
		Checkbox("Defuse Kit", "defkit", posX, posY)
        posX = posX - 260
		posY = posY + 50
		
		Checkbox("Pistol", "legitsecond", posX, posY)
        posX = posX + 100
		posY = posY - 20
		
		Dropdown("", "Dropdown7", posX, posY, {"Dual Berreta", "FiveSeven", "CZ", "Tec9", "P250", "Deagle", "Revolver" })
		posY = posY + 50
		posX = posX - 100
				
		DrawSeparator(posX - indent, posY, width - tabs.Width - 6 * indent)
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
	Keroscene()
    Draw()
end)

---------------------------------------Watermark---------------------------------------
local colors = {
    accent = color_t(0.8, 1, 0.2588, 1),
    purple_neon = color_t(140 / 255, 142 / 255, 255 / 255, 0.81),
    glass_color = color_t(0.1, 0.1, 0.1, 0.7),
    border_color = color_t(140 / 255, 142 / 255, 255 / 255, 0.8),
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
    local current_time = os.date("%H:%M:%S")
    local watermark_text = string.format("[ NIXWARE.CC ] | %s | Time: %s | FPS: %d | %s | %s",  
                                         get_user_name(), current_time, current_fps, engine.get_level_name(), script_name())

    local text_size = get_text_dimensions(Verdana, watermark_text, 12)
    local padding = 3 
    local x = screen_size.x - text_size.x - padding  - 20
    local y = screen_size.y * 0.03 - 20 

    drawGlassRectangle(vec2_t(x + 80, y - 20), vec2_t(x + text_size.x + 15 , y + text_size.y + 10), colors.glass_color, 10)
	render.line(vec2_t(x + 80, y - 30), vec2_t(x + text_size.x + 15, y - 30), color_t(140 / 255, 142 / 255, 255 / 255, 0.8) , 50)
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
	end)() 
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
	end)() 
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


function Keroscene()
    local sliderValue = Controls["Slider1"]
	local sliderValueL = Controls["SliderLeft"]
	local sliderValueR = Controls["SliderRight"]
	local sliderValueTL = Controls["SliderTL"]
	local sliderValueTS = Controls["SliderTS"]
	local sliderValueTI = Controls["SliderTI"]
	local sliderValueTR1 = Controls["SliderTR1"]
	local sliderValueTG1 = Controls["SliderTG1"]
	local sliderValueTB1 = Controls["SliderTB1"]
	local sliderValueTR2 = Controls["SliderTR2"]
	local sliderValueTG2 = Controls["SliderTG2"]
	local sliderValueTB2 = Controls["SliderTB2"]
	
    local selectedOption = Controls["Dropdown1"]
    
    if Controls["killsay"] then
		
	end
	if Controls["damagesound"] then
		
	end
	if Controls["killsound"] then
		
	end
	if Controls["Waterka"] then
        drawWatermark()
    end
	
---------------------------------------FOV Changer-----------------------Controls----------------
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
	if Controls["HitLogs2"] then
	
	end
	if Controls["Fakerep"] then
	
	end
	if Controls["RadarR"] then
	
	end
	if Controls["FakeFeed"] then
	
	end
	if Controls["headshot"] then
	
	end
	if Controls["assistedflash"] then
	
	end
	if Controls["noscope"] then
	
	end
	if Controls["wallbang"] then
	
	end
	if Controls["revenge"] then
	
	end
	if Controls["dominated"] then
	
	end
	if Controls["inair"] then
	
	end
	if Controls["headshoto"] then
	
	end
	if Controls["assistedflasho"] then
	
	end
	if Controls["noscopeo"] then
	
	end
	if Controls["wallbango"] then
	
	end
	if Controls["revengeo"] then
	
	end
	if Controls["dominatedo"] then
	
	end
	if Controls["inairo"] then
	
	end
	if Controls["buybotlegit"] then
	
	end
	if Controls["buybotr"] then
	
	end
	if Controls["ak47"] then
	
	end
	if Controls["taser"] then
	
	end
	if Controls["defkit"] then
	
	end
	if Controls["m4a1"] then
	
	end
	if Controls["m4a4"] then
	
	end
	if Controls["mainweapon"] then
	
	end
	if Controls["secondweapon"] then
	
	end
	if Controls["molotov"] then
	
	end
	if Controls["smoke"] then
	
	end
	if Controls["heg"] then
	
	end
	if Controls["flash"] then
	
	end
	if Controls["ManualAA"] then
	
	end
	if Controls["ManualAAPS"] then
	
	end
	if Controls["ManualAAPSALO"] then
	
	end
	if Controls["fstand"] then
	
	end
	if Controls["JitterAA"] then
	
	end
	if Controls["HitLogsCent"] then
	
	end
	if Controls["Tracers"] then
	
	end
	if Controls["legitsecond"] then
	
	end
	if Controls["secondary0"] then
	
	end
	if Controls["secondary1"] then
	
	end
	if Controls["secondary2"] then
	
	end
	if Controls["secondary3"] then
	
	end
	if Controls["MenuBinds"] then
	
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

-----------------------Killsay 1----------------

register_callback("player_death", function(event)
	if Controls["killsay"] then
		if Controls["Dropdown1"] == 3 then
			engine.execute_client_cmd("say 1")
		end
	end
end)

-----------------Killsay Toxic-------------

local phrasest = {
    "Guys, keep practicing one day you might catch up to me... Maybe ",
    "Are you always this slow? I thought it was just server lag!",
    "Hey, who’s hosting the newbie lobby here? I think I joined the wrong game ",
    "Don't worry, just a few thousand more hours, and you’ll be almost like me.",
    "Guys, it’s not my fault your screens can’t react as fast as mine!",
    "If that’s your best, I almost feel bad for you...",
    "Looks like you’ve got a chance! Take a screenshot for the memories.",
    "Trying to play carefully so I don’t make you feel too bad ",
    "Where are your highlights? Oh right, in the shadow of my skills!",
    "How about this: you stop whining, and I’ll lower my level... by 0.01%!",
    "Calm down, guys, it’s just natural talent! ",
    "Feels like I'm playing against bots... is anyone even alive here?",
    "Don’t be mad, I'm just giving you a reason to train more!",
    "So, did you take notes on my lesson? Shall we repeat it?",
    "Oops, sorry, I think I accidentally turned on ‘God mode’!",
    "Don't worry, I'm just testing my cheats on you guys!",
    "Honestly, I don’t even know what to say... playing against you is boring ",
    "When you’re at peak form, and the opponents are still warming up.",
    "Easy, like morning coffee . Who’s next?",
    "Are you doing alright there, or should I slow down?",
    "Are you serious? I thought that was just the warm-up round!",
    "Guys, is this a match or newbie practice?",
    "You’ve got a long way to go before you catch up to me.",
    "Sorry if I’m too fast for you it’s just my reflexes!",
    "Feels like I'm playing solo — where is everyone?",
    "Your skills definitely aren’t the priority here.",
    "Oh, this is what you call ‘attack’? Funny!",
    "Are you guys penguins? Moving so slow!",
    "Try to guess where I’ll pop up... or just don’t bother.",
    "Maybe I’m a world champion you’ll never know!",
    "Feels like you’re playing with your eyes closed!",
    "Someone here isn’t on my level... and it’s not me.",
    "Seems like you’re on pause the whole time, or is it just me?",
    "You do know this is a match and not just a chat lobby, right?",
    "I could beat you even without chat. Want to test that?",
    "When are you guys going to start trying? I’m waiting!",
    "Even with my eyes closed, I’d still be faster.",
    "Guess I’ll have to lower my difficulty to give you a chance.",
    "Train harder, or I might just fall asleep here.",
    "You can surrender now I won’t mind!"
}

local counter = 0
register_callback("player_death", function(event)
if Controls["killsay"] then
		if Controls["Dropdown1"] == 4 then
    if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
        engine.execute_client_cmd("say " .. phrasest[counter % #phrasest + 1])
        counter = counter + 1
		end
		end
    end
end)

----------------------Killsay Ru---------------------------------------

local phrasesru = {
     "ты понимаешь что я на чердаке твою бабулю повесил своим хуем",
    "ты понимаешь что я об лобок твоей маамшки своим хуем орехи колю",
    "мать твоя стонет под скрипы гитары от моего хуя",
    "мне твою щеку что ли потереть как люстру?",
    "слышь, твой рот мне же говорил что ты проститутка влиятельной колхозницы",
    "почему ты прячешь мой хуй у себя во рту, любишь чтоле?",
    "когда твоя мамаша моим хуем играет в настольные игры, ты зачем мне хуй сосешь?",
    "я могу ебать твою мать на неведомом отстрове",
    "давай из твоего лица вырежим кусочек кожи и сделаем из него призерватив?",
    "ты заебал мне всасывать, ядобью твой рот до конца ты будешь умолять что бы я тад тебе сосать",
    "твоя мамаша когда сдохла хули ты мне в хуй ныл?",
    "ебал твою мать в жопу пока ты мне хуй сосал",
    "сын собаки слышь долбанутая иди отсюда и мамку свою прихвати",
    "когда твой папа стал раком русский охотник выстрелил ему в анал с ружья приняв его за лося",
    "ты понимаешь что я выбил своим хуем гланды твоей мамашки?",
    "слыш) бревно ты ебаное) мамашу твою на сеновале ебал",
    "я твою мамашу пас своим хуем на майдане",
    "ты понимаешь что я щас своим хуем через пиздак твоей мамашки буду торговые пути проводить",
    "я пиздой твоей матери вкрутил лампочку",
    "я ща через свой хуй пущу электро заряд тебе в мозг",
    "пидор огнедыщащий иди сюда я тебя ебать буду",
    "нахуй ты проводил тест драйв на моем хуе",
    "твоя мать на моем хуе ездит покупать моему хую украшения",
    "твоя мать зачем хвастается моим хуем перед подружками",
    "твоя мать вместо подушки ставит мой хуй себе под голову и так спит",
    "твоя мать моим хуем убила сталина",
    "твоя мать моим хуем умеет останавливать пули",
    "твоя мать когда играет в бадминтон вместо ракетки использует мой хуй",
    "твоя мать когда выпила мою сперму у неё крыша поехала и она начала танцевать русскую чечетку",
    "моя сперма такая дрогоценая что твоя мать её наливает в баночки и начинает ей молится",
    "твоя мать мою сперму пила как водку",
    "твоя мать увидела на витрине мой хуй и каждый раз когда отец твоей матери не давал она брала мой хуй и ебала себя",
    "давай я твою мать поебу на касписком море и буду подпевать песню каспийский груз",
    "твоя мать стирала тебе одежду моей спермой",
    "твоя мать построила одежный завод в виде моего хуя",
    "зачем твоя мать на моем хуе поставила светильник ?",
    "ты когда просил борщ со сметаной твоя мать приносила борщ с моей спермой и ты даже замечал",
    "я на пизде твоей матери устраивал скачки на конях",
    "я тебе ша глаз протикну своим хуем как шампур шашлык",
    "твоя мать когда готовит торт всегда добавляет 10 милиграм моей спермы",
    "мой хуй посадил яблоню на пизде твоей матеи",
    "мой хуй построил кондитерскую фабрику",
    "пизда твоей матери сняла номер на моем хуе",
    "твоя мать готовит на моем хуе овсянку и дает тебе кушать",
    "я на пизде твоей матери построил басейн и там же устроил вечеринку",
    "в пизде твоей матери летают теродактели",
    "в пизде твоей матери появился новая эра и всю землю переселят в пизду твоей матери",
    "мой хуй выиграл первое место по бегу на пизде твоей матери",
    "пизда твоей матери падает на мой хуй со скоростью света",
    "я на пизде твоей матери устраивал уличные гонки",
    "я на пизде твоей матери снимал форсаж 7",
    "твоя мать кот ебаный) который охотится за моим хуем как тигр за мясом",
    "я же ща стану на пизду твоей матери и меня демоны не смогут тронуть",
    "когда настанет конец света останится ток мой хуй и пизда твоей матер",
    "я же туссу хуев устраивал на пизде твоей матери",
    "твоя мать с моего хуя построила легосити",
    "пизда твоей матери помовлена с моим хуем,ты это знал ?",
    "в пизде твоей матери живет тарзан который думает что он попал в черную дыру",
    "пизда твоей матери очень сильно бегала по моем хуе и служба анального подразделения попоросила что бы я оштрафовал её и отправил на пиздоштрафстоянку",
    "твоя мать своим очком умеет дороги строить",
    "я из пизды твоей матери выкачивают тонну нефти",
    "твоя мать когда играла с моим хуем в футбол случайно тронула мой ххуй рукой и я ей начал забивать2 штрафных удара хуем",
    "я ща своим хуем перевешу целку твоей матери тебе на губу",
    "твоя мать поставила на мой хуй пароль что бы другие пиздаки не смогли залазить на мой хуй",
    "я твою мать ебал когда черная дыра засасывала землю",
    "из пизды твоей матери вытащили самого редкого скорпиона",
    "я в пизде твоей матери устраивал звездные войны",
    "твоя мать сделала одиколон по запаху моего хуя",
    "пизда твоей матери это как беговая дорожка для моего хуя",
    "твоя мать колядки читала моему хую а мой хуй вмест денег бил её по губе",
    "твоя мать обнимала мой хуй как свою детскую игрушку",
    "твоя мать прыгает а моем хуе как кингуру",
    "мой хуй в пизде твоей мамки как воробей",
    "с этой провокацией ты глатал кончу матери ,а та ссала тебе в ебло и  что тебе орала?",
    "с этой провокацией ты заглатнул мой член к себе в рот и что  зеркалу крикнул когда отсосал мой член?",
    "с этой провокацией тебя долбил твой же отец раком, а ты что ему орал когда он на тебя кончил?",
    "с этой провокацией тебя ебал табор цыгань, а ты что им орал когда они тебе на рот кончили?",
    "с этой провокацией ты долизвал клитор матери, а отец ебал тебя и что тебе орал?",
    "с этой провокацией ты глотнул кончи отца и что ему сказал?",
    "с этой провокацией ты встал раком перед хачем а тот выебал тебя в анал и что тебе крикнул после как кончил на тебя?",
    "с этой провокацией тебя выебал твой же брат и харнул тебе в ебло и что тебе сказал?",
    "с этой провокацией на тебя кончал твой брат а ты что зеркалу орал?",
    "с этой провокацией твоя мать ебала тебя страпаном в анал ,а ты что ей орал когда хуй отца досасывал?",
    "с этой провокацией тебя добили хачи, а ты слизывал у них с залупы кончу и что отцу орал?",
    "с этой провокацией ты вылизал клитор сестре, а та обоссала твое ебло и что тебе ответила после члена моего?",
    "с этой провокацией я пиздил твою мать членом по губе, а ты сосал хуй пса и что отцу орал с кончей во рту?",
    "с этой провокацией твой отец кончал  на твою сестру а ты слизывал кончу и что зеркалу орал?",
    "с этой провокацией на тебя ссал твой отец, а ты глатал его мочу и что зеркалу орал?",
    "с этой провокацией я тушил сигареты об пизду твоей матери , а после ты ей делал куни и что отцу орал?",
    "с этой провокацией я кидал кирпич в ебло твоей матери, а ты досасывал хуй отца и что зеркалу орал?",
    "с этой провокацией я выебал твою сестру , а та обоссала твое ебло и что тебе ответила после моего члена?",
    "с этой провокацией твоя мать ебала тебя забориной в анал, а ты что отцу орал когда сперму с губ вытер?",
    "с этой провокацией твоя мать заглатывала мой член как питон, а ты что отцу орал когда хуй бомжа  всасывал?",
    "с этой провокацией я бил хуем по губе твоей матери , а она всасывала мой член и что тебе орала?",
    "с этой провокацией я бил хуем по лбу твоей матери ,а ты облизнул мое яйцо и что отцу крикнул?",
    "с этой провокацией я сломал хуем челюсть твоей матери, а та подавилась моей кончей и что тебе крикнула с хуем отца во рту?",
    "с этой провокацией я загинал твою мать раком, а я кончил тебе на ебло и что ты зеркалу крикнул?",
    "с этой провокацией ты грыз залупу отца, а тот дал тебе хуем по лбу, и что тебе крикнул?",
    "с этой провокацией ты откусил клитор своей матери ,а та обоссала тебя и  что тебе крикнула?",
    "с этой провокацией я харкал на ржавое ебло твоей матери, а ты досасывал хуй бомжа и что отцу с хуем во рту орал?",
    "с этой провокацией ты глатал кончу цыганей ,а те ставили тебя раком и что тебе орали когда обкончали тебя?",
    "с этой провокацией твой отец прищимил твой хуй дверью, а ты укусил его за залупу и что ему крикнул?",
    "с этой провокацией твой отец приколотил тебя за яйца к потолку, а ты обоссал его и что зеркалу крикнул?",
    "с этой провокацией я ебал твою мать шампуром, а ты дососал хуй брата и что зеркалу крикнул?",
    "с этой провокацией ты догрыз клитор матери, а та харнула на тебя и что ты зеркалу крикнул?",
    "с этой провокацией тебя твой отец долбил хуем в рот) а ты облизав ему член и че зеркалу крикнул ?",
    "c этой провоцией на тебя ссали друзья,а ты слизавшы мочу че крикнул отцу ?",
    "с этой провокацией твой отец кончал тебе на глаза,а твоя мать когда увидела че она сделала или че она сказала ?",
    "ты понимаешь что твою мать бичи хуем ебали?",
    "ты понимаешь что ты от моего хуя даже не уходишь когда тебя мать орет) атаман ебаный",
    "ты понимаешь что я твоя мать мне сосет через гондон?",
    "ты понимаешь что мой хуй уничтожает пиздак твоей мамаши как угоган",
    "ты понимаешь что ты как истребитель вылетаешь на мой хуй",
    "ты понимаешь что ты бьешься об мой хуй как утка ебаная сука",
    "ты понимаешь что у тебя мой хуй на первом плане ,а потом все остальное?",
    "ты понимаешь что мой хуй тебе въебет по лбу так же сильно как биттой",
    "ты понимаешь что я тебя хуем сделаю инвалидом и буду твою мамашу потом ебать в твоем инвалидном кресле кастылем твоим",
    "ты понимаешь крч ты на моем хую поселился так как в доме родном, ты даже не покидаешь его",
    "помнишь как ты мне сосал как бешенный так что у тебя аж голова задымились",
    "ты понимаешь что я твою мать буду хуем подкидывать как блинчики?",
    "ты понимаешь что ты пытаешься овладеть моим хуем как гладиатор ебаный",
    "ты понимаешь что мой хуй на тебя может поссать ,туалет ты ебаный сука",
    "ты понимаешь что мой хуй разъебал пиздак твоей матери так что у нее кровит вечно, как будто пмс бесконечный",
    "ты понимаешь что ты даже головой не думаешь когда сосешь мне член",
    "помнишь как ты ты абидился из-за того что мой хуй не ценил то как ты хуево сосешь?",
    "ты понимаешь что ты мой хуй не в силах поднять и просишь мамку помочь и засунуть тебе в рот",
    "ты понимаешь что твоя мать моим спермаком таргует , в раз так 1000 пизже спайса?",
    "ты понимаешь что я хуем вырою магилу для твоей матери, и отъебу ее на последок так что она подохнет и закапаю ее потом",
    "ты понимаешь когда ты начинаешь сосать мой член ты не можешь остановится и тебя приходится оттаскивать камазом от моего хуя",
    "ты понимаешь что я твою мать хуем занизил как приору ебаную) она аж мой хуй царапала",
    "ты понимаешь что ты годами будешь щипать волосы с моего лобка",
    "ты понимаешь что ты для моего хуя пытаешься быть лучшим, выебок ебаный сука",
    "ты понимаешь что твоя мать на мой хуй ходит как на работу и ну я ей плачу крч понимаешь да?",
    "ты к моему хую двигаешься к цели, тип как арабы к терактам",
    "ты понимаешь что ты на новый год будешь пить мою мочу думая что это шампанское??? олух ебаный",
    "ты понимаешь что ты так истерил на мой хуй что он тебе десну уебал что ты даже ахрип",
    "ты понимаешь что мой хуй тебе судьбу поменяет, был пидарасом станешь мужиком",
    "ты понимаешь что ты кружишься перед моим хуем как пчела ебаная и только после как раз 20 его облетишь потом запрыгнишь и устраиваешь скачки",
    "ты понимаешь что я тебе ноги переломаю своим хуем) инвалид ебаный",
    "ты понимаешь когда я тебе в манку кончал, и ты хуярил ее за милую душу и думал что ты как крепыш мышцы набираешь",
    "ты понимаешь что твоя мать полирует свой пиздак перед еблей со мной и кидает себе на клитор блестки тип мадель ебаная",
    "ты понимаешь что твоя мать просит ее мочей моей окрестить как святой водой?",
    "ты понимаешь что мой хуй погрузился в клитор твоей матери как в подводную лодку ?",
    "ты понимаешь что я свой хуй положил в очко твоей матери как в без донную лодку ?",
    "ты понимаешь что я своим хуем твою мать подстрелил как из двух колибриного ружья на охоте ?",
    "ты понимаешь что мой хуй разбомбил клитор твоей матери как артиллерийскии войска ?",
    "ты понимаешь что я своим хуем измерял на клиторе твоей матери квадратные метры для своего загородного дома ?",
    "ты понимаешь что я болончиком краски на клиторе твоей матери нарисовал английскую букву \"p\" и посадил туда свой хуй как на вертолётную площадку ?",
    "ты понимаешь что я твоей матери сонную артерию передавил и она упала в обморок облокотившись на мой хуй свои ртом ?",
    "ты понимаешь что твоя мать на моем хую преет как в бане загародом ?",
    "ты понимаешь что я из клитора твоей матери сделал заготовку для урока труда ?",
    "ты понимаешь что я своим хуем в очке твоей матери исправил техническую ошибку ?",
    "ты понимаешь что я своим хуем по клитору твоей матери провёл как кот хвостом по моей ноге ?",
    "ты понимаешь что я свой хуй затачиваю об клитор твоей матери как копьё в средневиковье ?",
    "ты понимаешь что твоя мать от удара моего хуя была подавлина ?",
    "ты понимаешь что я стал рекордсменом по митанию своего хуя в очко твоей матери с дальней дистанции ?",
    "ты понимаешь что мой хуй на лодке проплы по клитору твоей матери как по нейтральным водам ?",
    "ты понимаешь что мой хуй для твоей матери как личная охрана ?",
    "ты понимаешь что мой хуй в клиторе твоей матери как в танке ?",
    "ты понимаешь что мой хуй произносил заклинания что бы открыть анальные ворота твоей матери как грабницу хиопса ?",
    "ты понимаешь что я своим хуем сшил из лобковых волосков твоей матери валенки ?",
    "ты понимаешь что очко твоей матери как пусковая шахта для межконтенентальных ракет ?",
    "ты понимаешь что я своим хуем в очке твоей матери связь ловил ?",
    "ты понимаешь что я своим хуем в клиторе твоей матери фильм снимал в жанре русский кажуал ?",
    "ты понимаешь что я своим хуем в клиторе твоей матери предовратил катострафический разлом империи ?",
    "ты понимаешь что мой хуй пожертвовал в фонд для спасения клитора твоей матери ?",
    "ты понимаешь что я свой хуй пустил через клитор твоей матери как поезде по рельсам ?",
    "ты понимаешь что я свой хуй в очке твоей матери забыл как вещь в гардиробе ?",
    "ты понимаешь что мой хуй из очка твоей матери добывал драгоценные самородки ?",
    "ты понимаешь что я своим хуем по клитору твоей матери пустил цепную риакцию из тока ?",
    "ты понимаешь что я своим хуем на клиторе твоей матери таблицу химических веществ чертил ?",
    "ты понимаешь что мой хуй улёгся на клитор твоей матери и начел считать звёзды и глазами собирать созвездие ориона ?",
    "ты понимаешь что мой хуй в клиторе твоей ведет архиологические расскопки ,скелета динозавра ?",
    "ты понимаешь что мой хуй шагнул в очко твоей матери как в новое измерение ?",
    "ты понимаешь что я в клиторе твоей матери овощами торугю ?",
    "ты понимаешь что я твою мать на прилавке с овощами выебал ?",
    "ты понимаешь что я в очке твоей матери капусту квасил тебе на зиму ?",
    "ты понимаешь что я лобковую кость твоей матери в противоположную сторону сместил своим хуем ?",
    "ты понимаешь что твоя мать ипользует мой хуй как тяпку на огороде которой она окучивает кортошку ?",
    "ты понимаешь что мой хуй использует клиторе твоей матери как спальный мешок в походе ?",
    "ты понимаешь что твоя мать мне всю плеш проела как моль ебаная ?",
    "ты понимаешь что я в клиторе твоей матери построил стоянку и потом порковал свой хуй на элитное место ?",
    "ты понимаешь что я в клиторе твоей матери строил пирамиду хиопса та не устояла и обрушилась прям на половую губу твоей матери из за плохой конструкции и укладки ?",
    "ты понимаешь что мой хуй твою мать шинтажировал как в креминальных фильмах ?",
    "ты понимаешь что я своим хуем лецевую часть лобка твоей матери снёс ?",
    "ты понимаешь что твоя мать доит мой хуй как сиську корове,хуесос ты колхлзный ?",
    "ты понимаешь что я своим хуем прогнул твою мать как хуесоску ссанную и проститутку",
    "ты понимаешь что я клиторе твоей матери сейчас по своему хую пущу как по оси ?",
    "ты понимаешь что твоя мать как в голодных играх пытается перегрызть мой хуй ?",
    "ты понимаешь что я своим хуем клитор твоей матери тягаю как штангу ?",
    "ты понимаешь что я своим хуем твоей матери половую матку ампутировал ?",
    "ты понимаешь что я сейчас очко твоей матери ремонтировать начну как автослесарь в автосервисе ?",
    "ты понимаешь что я твою мать выебал в стойле под её любимым номером ?",
    "ты понимаешь что я своим хуем накрыл клиторе твоей матери как волной цунами ?",
    "ты понимаешь что я клитор твоей матери покрасил в радужный цвет что бы было веселее ебать ?",
    "ты понимаешь что я своим хуем клитор твоей матери изувечел как ножом человека ?",
    "ты понимаешь что мой хуй твою мать мативирует как психолог ?",
    "ты понимаешь что я своим хуем анальное отверстие твоей матери стимулирую как андреналином ?",
    "ты понимаешь что твоя мать без моего хуя не може прожить и дня ?",
    "ты понимаешь что я очко твоей матери своим хуем обустроил как комнату в квартире ?",
    "ты понимаешь что твоя мать катается на моем хую как на маршрутки только за бесплатный проезд ?",
    "ты понимаешь что мой хуй проводил опирацию по удалению точки g из половой матки твоей матери и вроде бы всё прошло отлично ?",
    "ты понимаешь что мой хуй заходит в очко твоей матери как судно на пристань ?",
    "ты понимаешь что я сожал свой хуй на клиторе твоей матери как на аэрофлот истрибителя ?",
    "ты понимаешь что я клиторе твоей матери использую как кулёк для семечек ?",
    "ты понимаешь что я в клиторе твоей матери нашол остатки живой плоти ?",
    "ты понимаешь что я своим хуем клиторе твоей матери вывернул как курту и повешал на вешалку ?",
    "ты понимаешь что я своим хуем пытался на очке выбить твоей матери гравировку как колом на камне ?",
    "ты понимаешь что я свой хуй об край клитора твоей матери точил как об заострёный камень ?",
    "ты понимаешь что твоя мать свалилась на мой хуй как падший ангел с небес ?",
    "ты понимаешь что я своим хуем гидравлику твоей матери посадил и затанировал её очко ?",
    "ты понимаешь что когда мой хуй шлифовал на клиторе твоей матери то он стёр колодки ?",
    "ты понимаешь что мой хуй в клиторе твоей матери на лодке плавает в нейтральны водах ?",
    "ты понимаешь что я своим хуем на клиторе твоей матери колоду карт веером разложил ?",
    "ты понимаешь что я своим хуем в клиторе твоей матери роюсь как гребник в норке в надежеде что там будет ахуеный гриб ?",
    "ты понимаешь что мой хуй совместное видео с твоей матерью мантировал через программу sony vegas 12 ?",
    "ты понимаешь что мой хуй фотал клитор твоей матери как попараций в курорте ?",
    "ты понимаешь что я своим хуем в черепной коробке твоей матери сделал потологию ?",
    "ты понимаешь что я своим хуем клитор твоей матери завёл как полосмасовую игрушку ?",
    "ты понимаешь что я своим хуем очко твоей матери забетонировал ?",
    "ты понимаешь что я своим хуем в очке твоей матери стенку из кирпичей выкладывал ?",
    "ты понимаешь что я свой хуй сложил как полотенце и положил в клитор твоей матери как в кабинку ?",
    "ты понимаешь что я очко твоей матери своим хуем вскрыл как консерву с килькой ?",
    "ты понимаешь что я своим хуем твою мать оглушил как рыбу в воде ?",
    "ты понимаешь что я твою мать анальным сникерсом накормил ?",
    "ты понимаешь что я твою мать при высоких уровнях гравитации ебал ?",
    "ты понимаешь что я в очке твоей матери нашол заброшеные проэкты apple и продал их за акции в найке ?",
    "ты понимаешь что я прежде чем изгонять дьяволо из клитора твоей матери своим хуем чертила пентаграмму ?",
    "ты понимаешь что твоя мать красила своим половые губы моей спермой как помадой ?",
    "ты понимаешь что в клиторе твоей матери стоит опора для моего хуя ?",
    "ты понимаешь что я в гортань твоей матери свой хуй спускал как шланг с лампочкой ?",
    "ты понимаешь что мне нравится когда ты и твоя мать поклоняется моему хую ждя дождя из моей спермы ?",
    "ты понимаешь что твоя мать на грани смерти от выстрела моей спермы в её еблет ?",
    "ты понимаешь что я своим хуем очко твоей матери спресовал как банку железную ?",
    "ты понимаешь что я в очко твоей матери заселил племя юнги ?",
    "ты понимаешь что я своим хуем очко твоей матери окупировал ?",
    "ты понимаешь что я на пизде твоей матери выложил минное поле ?",
    "ты понимаешь что я в очке твоей матери хранил орудия массового уничтожения ?",
    "ты понимаешь что я твоей матери сделал своим хуем открый перелом коленки ?",
    "ты понимаешь что мой хуй нанёс твоей матери увечия и у неё появилась потология на черепной коробке ?",
    "ты понимаешь что я своим хуем завёл клитор твоей матери как полосмасовую игрушку на батарейках ?",
    "ты понимаешь что твоя мать скачит как кенгуру с зародышом ?",
    "ты понимаешь что я очко твоей матер забетонировал ?",
    "ты понимаешь что я своим хуем в клиторе твоей матери укладывал кирпичи а месил бетон в очке ?",
    "ты понимаешь что мой хуй выплачивал клитору твоей матери кампинсацию за нанесёный ущерб внутри его ?",
    "ты понимаешь что я своим хуем свернул клитор твоей матери как полотенце в раздивалке и положил в кабинку ?",
    "ты понимаешь что я своим хуем очко твоей матери вскрыл как консерву с килькой ?",
    "ты понимаешь что я твою мать своим хуем оглушил как рыбу в воде ?",
    "ты понимаешь что мой хуй изучал анальное отверстие твоей матери и нашол там особо редкие артефакты которые он сдал в музей и ему выдали вознаграждение ?",
    "ты понимаешь что я сейчас очко твоей матери своим хуем до линии горизонта расстяну и то мой хуй по габаритам не влезет её в узкый анальный проход ?",
    "ты понимаешь что я своим хуем прожог половую губу твоей матери как бычком солофановый пакетик ?",
    "ты понимаешь что я своим хуем пытался сделать из твоей семьи человеческую многоножку ?",
    "ты понимаешь что твоя мать свалилась на мой хуй с туалетной крышки био туалета ?",
    "ты понимаешь что твоя мать мазает свои половые губы моей кончиной думая что это помада ?",
    "ты понимаешь что я твою мать своим хуем събил как лошадь в ебанную ?",
    "ты понимаешь что твоя мать прела на моем хую как в бане под высокой температурой моего хуя и он её как бы изнутри обогревал ?",
    "ты понимаешь что я в клиторе твоей матери установил радиатор от вездихода чтобы кто то обогревал твою мать в эту холодную зиму ?",
    "ты понимаеш что мой хуй единственый кто будет обогревать твою мать этой зимней стужой ?",
    "ты понимаешь что мой хуй залил клитор твоей матери как ляденую горку в парке и катался с неё на санках ледянках ?",
    "ты понимаешь что твоя мать как одинокий свитильник в кромешной тьме без ведома моего хуя ?",
    "ты понимаешь что мой хуй оставил на клиторе твоей матери раздражение как репейник ?",
    "ты понимаешь что мой хуй побывав в клиторе твоей матери обноружил более тысячи угроз как анти-вирус,nord 32 ?",
    "ты понимаешь что мой хуй поместился в очко твоей матери как в избушку на курьих ножках ?",
    "ты понимаешь что мой хуй подходит к очку твоей матери как золотой ключик к сундуку с сокровищами ?",
    "ты понимаешь что я своим хуем в очко твоей матери матери укладывал стенку из кипрпичей для опоры своего хуя ?",
    "ты понимаешь что я на очке твоей матери катал комки навоза как новозный жук и потом скидывал в нутрь ?",
    "ты понимаешь что я в твоей матери стрелял из своего хуя как из лука а стрелы были в виде кончины ?",
    "ты понимаешь что твоя мать на грани смерти от выстрела моего хуя в её еблет ?",
    "ты понимаешь что мне нравится когда ты и твоя мать поклоняется моему хую ждя дождя из моей спермы ?",
    "ты понимаешь что я у твоего отца спиздил духи набрызгался ими и пошол ебать твою мать что бы родным запахом пахло ?",
    "ты понимаешь что я в очке твоей матери иправил техническую неполадку ?",
    "ты понимаешь что я в килторе твоей матери проводил газовую атаку своим хуем ?",
    "ты понимаешь что мой хуй как дихлофос для твоей матери блох выводить из её лобковых волосов ?",
    "ты понимаешь что твоя мать набрасывается на мой хуй как кавказкая овчарка с горных равнин ?",
    "ты понимаешь, что мировой судья имени моего хуя подал иск против пизды твоей мамаши,он решил взыскать всё имущество с её пизды, лобковые волоса,и литр моей спермы которую она украла",
    "деградант с маленькой писькой? ) понимаешь, что мой хуй ставил критические условия пизде твоей мамаши,ведь ебаться на ледниках эвереста крайне опасно для жизни",
    "деградант с маленькой писькой? ) мой хуй блядь отправит твои зубы в неправильное равенство, то есть,20 зубов у тебя осталось после драки твоей челюсти с моим хуем",
    "деградант с маленькой писькой? ) мой хуй отправлял тебя до чили,чтоб ты мог увидеть все красоты мира на моем хуе",
    "деградант с маленькой писькой? ) тебя троллить мамка учила?",
    "деградант с маленькой писькой? ) масло моего хуя?) я же смажу хуй твоим жиром и поебу твою мать",
    "деградант с маленькой писькой? ) я блядь ебу твою мать,еблан, пиздуй сюда, чмо заядлое",
    "деградант с маленькой писькой? ) ты, как сыр,вонючка ебаная",
    "деградант с маленькой писькой? ) я сука весной хуем летел в пизде твоей мамаши",
    "деградант с маленькой писькой? ) я твою мать за шубу ебал",
    "деградант с маленькой писькой? ) твоя мать, как древнегреческая богиня,очень красива,и сосет хуй только мне",
    "деградант с маленькой писькой? ) я сука перед тем,как поебать твою мать все справки собирал о её здоровье",
    "деградант с маленькой писькой? ) я пизду твоей матери буду звать, как путина,самой честной",
    "деградант с маленькой писькой? ) ты, как доллар, поднимаешься по моему рублю",
    "деградант с маленькой писькой? ) понимаешь, что я твою мать ебал без забот",
    "деградант с маленькой писькой? ) ты гасишь изжогу моим хуем,будто известь?",
    "деградант с маленькой писькой? ) я анализ калла на твой язык сдавал",
    "деградант с маленькой писькой? ) ты мою машонку бреешь языком",
    "деградант с маленькой писькой? ) ты жрешь мой калл,будто пельмени",
    "деградант с маленькой писькой? ) я ебу твою мать на зимние праздники",
    "деградант с маленькой писькой? ) я же нахуй хуем изгоню всю нечесть с твоего очка",
    "деградант с маленькой писькой? ) мой хуй посвятит тебя в ряды его сосателей",
    "деградант с маленькой писькой? ) ты хуи сосешь только зимой?) а то ща,я чёт твой рот ебу",
    "деградант с маленькой писькой? ) пиздец, ебать ты мудрец хуя моего",
    "деградант с маленькой писькой? ) филосовствуй о моем хуе",
    "деградант с маленькой писькой? ) я пизде твоей мамаши подарю носки и бритву",
    "деградант с маленькой писькой? ) не вывозишь чёт мой хуй ты",
    "деградант с маленькой писькой? ) твоя мать прям анджелина джоли моего хуя",
    "деградант с маленькой писькой? ) тебя мой хуй усыновит",
    "деградант с маленькой писькой? ) готовь рот,человек собака",
    "деградант с маленькой писькой? ) ты с моим хуем в обнимку спал на новогоднюю ночь",
    "деградант с маленькой писькой? ) я еду в тот город,где исполняются мечты рта твоей мамаши,я ебу его",
    "деградант с маленькой писькой? ) да я каждый выходной ебу твою мать",
    "деградант с маленькой писькой? ) я тебе пылинку с глаза хуем уберу",
    "деградант с маленькой писькой? ) иди соси мне хуй,пока даю",
    "деградант с маленькой писькой? ) проститутка?) стоишь,торгуешь телом на моем хуе",
    "деградант с маленькой писькой? ) не быдай мне яйца языком, коза",
    "деградант с маленькой писькой? ) ты как осел из шрека,много пиздишь пока лижишь яйца",
    "деградант с маленькой писькой? ) книга 50 оттенков серого о моем хуем и о пизде твоей мамаши",
    "деградант с маленькой писькой? ) мой хуй на твоем лице оставит шрам",
    "деградант с маленькой писькой? ) я сука калашом моего хуя начну бомбить пизду твоей мамаши утром, будто хохлы днр",
    "деградант с маленькой писькой? ) я в пизде твоей мамаши карасей ловил",
    "деградант с маленькой писькой? ) ты пьешь без остановки напитки моего хуя",
    "деградант с маленькой писькой? ) ты сука, как ходячий аркестр,барабанишь моим хуем языком об яйца",
    "деградант с маленькой писькой? ) я твоим языком буду бирки с хуя снимать",
    "деградант с маленькой писькой? ) я сменил позу с твоей мамашей, будто канал на телеке",
    "деградант с маленькой писькой? ) тащился за моим хуем, будто асматик за лекарством?",
    "деградант с маленькой писькой? ) мой хуй влетает в рот твоей мамаши,как камень в стекло",
    "деградант с маленькой писькой? ) я скромно ебу твою мать, понимаешь?",
    "деградант с маленькой писькой? ) почему тебя хуярят толпой?) ты типо оргии любишь?",
    "деградант с маленькой писькой? ) открой свою душу моему хую",
    "деградант с маленькой писькой? ) ты уже на столько не вывозишь,что начинаешь писать не провокации, а хуйню,лучше почитай, как я ебу твою мать",
    "деградант с маленькой писькой? ) ты загараешь на моем хую будто на шезлонге?",
    "деградант с маленькой писькой? ) ты с моего хуя доширак слизывал",
    "деградант с маленькой писькой? ) ты, как ксюша собчак хуя моего",
    "деградант с маленькой писькой? ) очи черные,очи жгучие,в твоем рту хуи вонючие",
    "деградант с маленькой писькой? ) сука,я уже закатываюсь.с того, как ебу твою мать",
    "деградант с маленькой писькой? ) членосос?) твоё очко горит, туши скорее",
    "деградант с маленькой писькой? ) уже кафе открыл на хую,твоя мать самый частый клиент",
    "деградант с маленькой писькой? ) понимаешь, чтоья ебу твою мать на курорте?",
    "деградант с маленькой писькой? ) я вчера хуем спалил очко твоей мамаши в дубаях,20 этажей отеля сгорело",
    "деградант с маленькой писькой? ) ты косячишь на моем хую",
    "деградант с маленькой писькой? ) ты сука таджик ебаный, быстрее мой хуй слюной обклеевай",
    "деградант с маленькой писькой? ) мой хуй вальсирует с пиздой твоей маманьки",
    "деградант с маленькой писькой? ) мой хуй шифруется в пизде твоей мамаши",
    "деградант с маленькой писькой? ) мой хуй покоя не дает пизде твоей мамаши?",
    "деградант с маленькой писькой? ) пизда твоей мамаши катя кляп хуя моего?",
    "мой хуй выбил страйк зубами твоей матери",
    "нахуя твоя мать маскируется за помощью моего хуя ?",
    "ты откуда взял информацию о моем хуе что он ебал твою мать ?",
    "мой хуй твою мать вытиранит своими яйцами когда она моестся",
    "давай запакуем твою мамашку и отправим по адресу прямо на мой хуй,кондуктор ебаный",
    "твоя мать мой хуй замотала изолентой что бы когда я её ебал не поцарапал края пихжы",
    "я твою мать в твоем доме ебал хату разогревал",
    "твоя мать как клещ,своим ртом к моему хую пpисосалась",
    "ты понимаешь что даже крестик господа тебя не поможет против моего хуя",
    "ты понимаешь что пиздак твоей мамашаки это липа которая полна терпения в зале ожидания, мой хуй привознёс ей второе вдохновение",
    "ты понимаешь что мой хуй еще за год вперёд расчитался с пиздой твоей мамашки, ведь её так морозит когда мой хуй проводит по её пизде словно муражки по коже",
    "ты понимаешь то что мой хуй способен залить твое ебало спермой?",
    "ты понимаешь что твоя мамаша на мой хуй нарвалась",
    "ты понимаешь что моя залупа будет целовать твой лоб?",
    "ты кстати сосешь нежно как твоя мать ты понимаешь это?",
    "ты понимаешь что я твою мамашу хуем по пизде ебашу?",
    "ты понимаешь что у тебя после моего хуя началась картавая речь",
    "ты понимаешь что я в пизде твоей матери газовую станцию построил,что бы моему хую было земой тепло",
    "ты понимаешь чтоя своим хуем ща выкопаю минеральные добрива в пизде твоей матери",
    "ты понимаешь что я тебя сейчас хуем разломаю как вафлера ебаного",
    "ты понимаешь что твоя мать раскрыла свою матку что бы почуствавать свежесь хуёв на завтрак, когда поселилась в юридической юношеской столовой",
    "ты понимаешь что даже крестик господа тебя не поможет против моего хуя",
    "ты понимаешь что ты по дну лазил мой хуй искал?",
    "ты понимаешь что мой хуй имеет структуру предназначенной для пизды твоей маманьки",
    "ты понимаешь что я твоей матери сейчас хуем буду делать ампутацию матки ?",
    "ты же понимаешь что твой папаша не позаботился о том , что я буду ебать твою маман) и теперь тебе придеться забивать ей в очке доски чтобы я этого не делал))",
    "почему твоя мамаша свою пизду продает среди детских игрушек?",
    "ты понимаешь что ты перышками мне хуй щекотал и я возбуждался и ебал твою мать",
    "ты кстати нахуя мой хуй так славно сосешь я вот уже восхищаюсь твоему ротику",
    "вот смотри,ведь ты хочешь что бы мой хуй вырабатывал специальную жидкость для твоих морщин ?",
    "ты понимаешь что ты ебаный шизофренник порожденный злом моего хуя?",
    "почему твоя мать делает вид,что не любит мой хуй ??",
    "думаешь если назначить очко твоей мамашки маршалом армии рф то каждый будет ее ебать? как думаешь?",
    "давай погугли а то ты как обиженный пес мне тут скулишь , подзалупная ты обезьяна блять",
    "понимаешь что пизда твоей матери напала на мой хуй и поживала его",
    "ты понимаешь что я сейчас твою мамашу на своём хуе так раскручу ) как на олимпийских играх диск не метают",
    "ты что петух гриву свою на хую моем потерял чтоль?",
    "помнишь как я твою мать ебал с своими друзьями?",
    "помнишь как мы ей порвали ротик своими хуями?",
    "хуеглот ебучий) сын путаны раздолья) подсос моего хуя) суда ползи спидозник) ты хули умолк хуй сосёшь не многоли чести",
    "хуйня из под ног?)) помню помню, недавно тобой пол в параше протер) но уже можешь вылезать",
    "ты понимаешь что ты зонтик держишь когда я твою мать при ливне ебу?",
    "мой хуй выбил страйк зубами твоей матери",
    "пойми) я ща пиздак твоей матери расстяну так что он сможет надеть всю землью",
    "пойми) я тебя буду ебать под песню oxxymiron-детектор лжи",
    "нахуя ты ходил к моему хую и сдавал тест на наркотики?",
    "пойми) мой хуй ща будет ездить по твоей голове как гозоно косилка по траве",
    "пойми) что мой хуй запрыгивает в пиздак твоей матери как тигр",
    "нахуя твоя мать пыталась развести мой хуй на деньги?",
    "ты понимаешь?) что я твою мать бууд ебать под елкой на первая января",
    "ты понимаешь что мой хуй плавает в пиздаку твоей матери как кит в океане",
    "ты зачем написал стих как я твою мать ебал?",
    "я твою мать ща буду ебать на снегу",
    "нахуя твоя мать маскируется за помощью моего хуя ?",
    "ты откуда взял информацию о моем хуе что он ебал твою мать ?",
    "мой хуй твою мать вытиранит своими яйцами когда она моестся",
    "давай запакуем твою мамашку и отправим по адресу прямо на мой хуй,кондуктор ебаный",
    "твоя мать мой хуй замотала изолентой что бы когда я её ебал не поцарапал края пихжы",
    "я твою мать в твоем доме ебал хату разогревал",
    "ты понимаешь что я на пиздаке твоей мамаши могу спермой выписать что никита депутат пидар был слит мной лично",
    "короче когда я твою мать ебал то я в ее пизде теракт устроил да такой силы что ты из утроба вылетел как спичка ёбанная",
    "ёбанная?) почему твоя мамаша стала своей пиздой об мой хуй терется она что магнитая",
    "ты понимаешь что твоя мамаша своими волосами мой хуй чешет блядь",
    "твоя мать как клещ,своим ртом к моему хую пpисосалась",
    "ты понимаешь что даже крестик господа тебя не поможет против моего хуя",
    "ты понимаешь что пиздак твоей мамашаки это липа которая полна терпения в зале ожидания, мой хуй привознёс ей второе вдохновение",
    "ты понимаешь что мой хуй еще за год вперёд расчитался с пиздой твоей мамашки, ведь её так морозит когда мой хуй проводит по её пизде словно муражки по коже",
    "ты понимаешь то что мой хуй способен залить твое ебало спермой?",
    "ты понимаешь что твоя мамаша на мой хуй нарвалась",
    "ты понимаешь что моя залупа будет целовать твой лоб?",
    "ты кстати сосешь нежно как твоя мать ты понимаешь это?",
    "ты понимаешь что я твою мамашу хуем по пизде ебашу?",
    "ты понимаешь что у тебя после моего хуя началась картавая речь",
    "я твою мать ебал а ты мне шмотку стиралoты понимаешь что когда я ебу мать твою она орёт как не знаю кто сука",
    "ты понимаешь что я в пизде твоей матери газовую станцию построил,что бы моему хую было земой тепло",
    "я не понимаю зачем ты будешь мой хуй в 7 утра,что бы отсосать?",
    "ты понимаешь чтоя своим хуем ща выкопаю минеральные добрива в пизде твоей матери",
    "я твою мать ебал а ты мне шмотку стиралoты понимаешь что когда я ебу мать твою она орёт как не знаю кто сука",
    "ты понимаешь что я тебя сейчас хуем разломаю как вафлера ебаного",
    "ты бля, пизда тупая, ты че сука нахуй въебалась по полной? я тебе сейчас пизду твою нахуй скручу,потаскушка ты ебанная) иди бананы воруй,животное ты хуесосное",
    "скажи одно,нахуй ты отсосала мой хуй, и начала перед ним молитву читать? ты блять совсем тупая? хзаузхаузхауауз, в шоке с тебя) зато мой хуй для тебя,как бог,раз ты молишься ему",
    "сосать беги я сказал мандавошка бл ты же послушная шавка поддавайся командам)) 0) 0",
    "твоя мать ебется с правыми но изменяет им с хачами?) какой толк в том,что твоя мать жертва акушерки?",
    "слыш ты тупая курва ты в курсе что меня хотят посадить за изнасилование всей твоей ебучей семейки)) но почему-то твоя мать в востоорге",
    "твоя мамашка овощем стала её губочки устали сосать а половые вообще стерлись… там пол москвы побывало… нерусские все почленно….",
    "будулай утырчатый)) у меня сука спинного мозга больше чем у тебя и твоей мамашки головного,кретины сука",
    "ээ,ты не петушись,ты ж осёл ска тупенький пиздец)) вот поэтому тебя все на секс разводят и твой рот так расширился от кол-ва хуев кото",
    "через тернии к зведздам – так добиваются цели нормальные люди но не ты) твой слоган – сосал и буду сосать)) да вы все сосунки уроды",
    "ты знаешь что я тот самый паренек,член которого суждено было тебе взять в рот?) ну так теперь знай)) ты не жертва моего хуя",
    "слышь,чурокобесс ебаный,ты понимаешь,что я щас полбу твоей матери своим хуем буду хуярить?",
    "они,кто они?) те,которые твою мать ебали,время 20:56:14 пора идти ебать твою мать",
    "твоя мать,при помощи моего хуя,себе зубы чистит ??",
    "ты по моим фразам как блоха по яйцам котаешься!",
    "я зачехлил твой рот,чтоб кроме меня никто не ебал",
    "мы с твоим папашей все обсуждале как бы сунуть член к твоей мамашке жирной чтобы родить уродину как ты) слава богу у нас все получилось",
    "вот зачем ты на свою мать нассал, когда мы ее встретили) я понимаю что у тебя рефлексы собаки, но твоя мать же не дерево) даже не бревно) в постели она хороша) -отпишись",
    "я вводил свою кончу в вены твоей мамы) когда она болела гриппом",
    "почему ты пьешь мою кончу по утрам залпом?",
    "ты сука на моем хуе лежишь как на пляже",
    "в пизду твоей мамы можно поставить колонки и будет пиздатая вибрация по клитору твоей мамы,она аж кончит не от моего ху,а от вибрации",
    "твоя мать любит когда мой хуй играет с ней в садо-мазо",
    "твоя мать когда покурила моим хуем,то ей стало легче на душе",
    "ты сука на моем хуе выебуешься,а потом с него не хочешь слезать",
    "твоя мать сидит на моем хуе как на троне",
    "слышь щавель нахуй?) ты хули ко мне давал свою мать выебать за букет цветов то?",
    "твоя мать работает на моем хуе) как секретный агент моего хуя",
    "если ты будешь боятся спать один,попроси моего хуя он будет вместе с тобой",
    "еще один гудок с твоей платформы, и твой зубной состав двинется",
    "аничё((",
    "пака",
    "1",
    "от пасты упал",
    "who.ru hhh",
    "paypal.com/refund.php",
    "зачем она бирёт мужские письки в рот зачеееем всё это зачеееем",
    "[onetap] missed shot due to retarded resolver",
    "ez 1",
    "пара пара пам",
    "1",
    "bruh",
    "error: ur resolver is trash",
    "отлетаешь сочняра",
    "уёбище как дела",
    "удачи со своей пастой свинья",
    "изи упал",
    "не резольвнул((9",
    "давай досвидания крякоюзер",
    "ты чё, без читов? я тебя выebал прост",
    "1 хуесос",
    "Не скули псина",
    "1.",
    "Нищий долбаёб, ливни нахуй не позорься",
    "Я думал ты не клин, как же я ошибался",
    "Фу воняешь, зачем такие как ты вообще живут",
    "ИЗИ",
}

local counter = 0
register_callback("player_death", function(event)
if Controls["killsay"] then
		if Controls["Dropdown1"] == 5 then
    if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
        engine.execute_client_cmd("say " .. phrasesru[counter % #phrasesru + 1])
        counter = counter + 1
		end
		end
    end
end)

---------------------------------------HitLogs---------------------------------------
local accent = color_t(0.8, 1, 0.2588235294117647,1)
local m_sSanitizedPlayerName = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName");
local m_hOriginalController = engine.get_netvar_offset("client.dll", "C_CSPlayerPawnBase", "m_hOriginalController");
local m_nTickBase = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_nTickBase");
local Verdana = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 12, 16);
local logs = {};

local Lerp = function(a, b, t)
    return a + (b - a) * t
end

local _LOG = function(str)
    print("[nixware] \0", accent);print(str);
end;

local GetHitgroupName = function(nHitgroup)
    if nHitgroup == 1 then 
        return "head";
    elseif nHitgroup == 2 then 
        return "chest";
    elseif nHitgroup == 0 then
        return "generic";
    elseif nHitgroup == 4 or nHitgroup == 5 then 
        return "arms";
    elseif nHitgroup == 8 then
        return "neck";
    elseif nHitgroup == 6 or nHitgroup == 7 then 
        return "legs";
    elseif nHitgroup == 3 then
        return "stomach";
    else
        return "unknown";
    end;
end;

local fnOnPlayerHurt = function(event)
	if Controls["HitLogs"] then
    local pLocalPawn = event:get_pawn("attacker");
    if pLocalPawn ~= entitylist.get_local_player_pawn() then return; end;
    local pLocalController = entitylist.get_local_player_controller();
    if not pLocalController then return; end;
    local pLocalTickBase = ffi.cast("int*", pLocalController[m_nTickBase])[0];
    local pTargetController = event:get_controller("userid");
    if not pTargetController then return end;
    local szName = ffi.string(ffi.cast("char**", pTargetController[m_sSanitizedPlayerName])[0]); -- todo транслит добавить 
    local nHealth = event:get_int("health");
    local nDamage = event:get_int("dmg_health");
    local nHitgroup = event:get_int("hitgroup");
    local szHitgroup = GetHitgroupName(nHitgroup);

	
    local Text = string.format("Hit %s in the %s for %d damage (%d health remaining)", szName, szHitgroup, nDamage, nHealth);
    _LOG(Text);
    table.insert(logs, {szText = Text, nTickBase = pLocalTickBase + (4 / 0.015625), flAlpha = 0});
	end
end;

local fnOnPaint = function()
    local pLocalController = entitylist.get_local_player_controller();
    if not pLocalController then logs = {}; return; end;
    local pLocalTickBase = ffi.cast("int*", pLocalController[m_nTickBase])[0];
    if not pLocalTickBase then return; end;
    local nOffset = 0;
    for i, v in ipairs(logs) do
        local vecRenderPos = vec2_t(5,5 + nOffset);
        local colAccent = accent;
        v.flAlpha = Lerp(v.flAlpha, pLocalTickBase > v.nTickBase and 0 or 1, 20 * render.frame_time()); --62
        colAccent.a = v.flAlpha;
        render.text("[nixware]", Verdana, vecRenderPos + 1, color_t(0, 0, 0, v.flAlpha * 0.25));
        render.text("[nixware]", Verdana, vecRenderPos, colAccent);
        vecRenderPos.x = vecRenderPos.x + 60;
        render.text(v.szText, Verdana, vecRenderPos + 1, color_t(0, 0, 0, v.flAlpha * 0.25));
        render.text(v.szText, Verdana, vecRenderPos, color_t(1,1,1,v.flAlpha));

        nOffset = nOffset + 16 * v.flAlpha;
        if (v.flAlpha < 0.0001) then table.remove(logs, i) end;
    end;
end;
register_callback("paint", fnOnPaint)
register_callback("player_hurt", fnOnPlayerHurt)


---------------------------------------HitLogs Center---------------------------------------
local config = {
    hit_logs = true,
    harm_logs = true,
    hit_color = color_t(140 / 255, 142 / 255, 255 / 255, 0.8),
    harm_color = color_t(140 / 255, 142 / 255, 255 / 255, 0.8),
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
			local harm_result = (is_fatal and "Tapped" or "Hit") .. (self_harm and "" or " by")
			hitgroup = hitgroup == "generic" and "" or (" for {harm}%s{white}"):format(hitgroup)
			damage = is_fatal and "" or (" for {harm}%s"):format(damage)
			log.print(("{white}%s {harm}%s{white}%s%s"):format(harm_result, attacker_name, hitgroup, damage), "harm")
		elseif attacker == local_player and config.hit_logs then
			local hit_result = is_fatal and "Tapped" or "Hit"
			hitgroup = (hitgroup == "generic" or hitgroup == "gear") and "" or (is_fatal and "'s " or "'s ") .. (" {hit}%s{white}"):format(hitgroup)
			damage = is_fatal and "" or (" for {hit}%s"):format(damage)
			target_name = hitgroup == "{white}" and target_name or ("%s{white}"):format(target_name)
			log.print(("{white}%s {hit}%s%s%s"):format(hit_result, target_name, hitgroup, damage), "hit")
		end
	end
end

----------------Manual AA-----------------

local STATES = {
    [0x5A] = 90,
    [0x43] = -90,
	[0x58] = 0, 
	[0x51] = 180,
    default = 180
}

ffi.cdef [[
    unsigned short GetAsyncKeyState(int vKey);
]]

local function is_key_pressed(virtualKey)
    return bit.band(ffi.C.GetAsyncKeyState(virtualKey), 32768) == 32768
end

local held_keys_cache = {}
local current_yaw_offset = STATES["default"]

register_callback("paint", function()
if Controls["ManualAA"] then
    for k, v in pairs(STATES) do
        if k == "default" then
            goto continue
        end

        local is_key_held = is_key_pressed(k)

        if (not held_keys_cache[k]) and is_key_held then
            if current_yaw_offset == v then
                current_yaw_offset = STATES["default"]
            else
                current_yaw_offset = v
            end

            menu.ragebot_anti_aim_base_yaw_offset = current_yaw_offset
        end

        held_keys_cache[k] = is_key_held

        ::continue::
    end
	
	end
end)

register_callback("unload", function()
    menu.ragebot_anti_aim_base_yaw_offset = STATES["default"]
end)



---------------------------------------Jitter ManualAA---------------------------------------
local sliderValueLeft = Controls["SliderLeft"] or 130
local sliderValueRight = Controls["SliderRight"] or 130

local STATES = {
    [0x5A] = sliderValueLeft,    -- Z key (left slider)
    [0x43] = -sliderValueRight,  -- C key (right slider)
    [0x58] = 0,                  -- X key (fixed at 0 for forward)

    default = 180
}

local ENABLE_INDICATORP = true
local INDICATOR_COLORP = color_t(0.72, 0.76, 1, 1)
local INDICATOR_DISTANCEP = 40

ffi.cdef [[
    unsigned short GetAsyncKeyState(int vKey);
]]

local function is_key_pressed(virtualKey)
    return bit.band(ffi.C.GetAsyncKeyState(virtualKey), 32768) == 32768
end

local held_keys_cache = {}


local key_state = {
    [0x5A] = false,  -- Z key
    [0x43] = false,  -- C key
    [0x58] = false,  -- X key
}

local active_arrow = nil  

register_callback("paint", function()
   
    sliderValueLeft = Controls["SliderLeft"] or 130
    sliderValueRight = Controls["SliderRight"] or 130

    
    STATES[0x5A] = sliderValueLeft      
    STATES[0x43] = -sliderValueRight    

    if Controls["ManualAAPSALO"] then
        
        for k, v in pairs(STATES) do
            if k == "default" then
                goto continue
            end

            local is_key_held = is_key_pressed(k)

            
            if is_key_held then
                if key_state[k] == false then
                    
                    key_state[k] = true
                    active_arrow = k
                    menu.ragebot_anti_aim_base_yaw_offset = v
                else
                    
                    key_state[k] = false
                    active_arrow = nil
                    menu.ragebot_anti_aim_base_yaw_offset = STATES["default"]
                end
            end

            held_keys_cache[k] = is_key_held

            ::continue::
        end

      
        if is_key_pressed(0x51) then  -- Q key is pressed
            
            for k, _ in pairs(key_state) do
                key_state[k] = false
            end
            active_arrow = nil
            menu.ragebot_anti_aim_base_yaw_offset = STATES["default"]
        end

      
        if ENABLE_INDICATORP then
            if not entitylist.get_local_player_pawn() then return end

            local screen_center = vec2_t(
                render.screen_size().x / 2,
                render.screen_size().y / 2
            )

            local manual = 0

         
            if active_arrow == 0x5A then  -- Z key pressed
                manual = 1
            elseif active_arrow == 0x43 then  -- C key pressed
                manual = 2
            elseif active_arrow == 0x58 then  -- X key pressed
                manual = 3
            end

         
            render.filled_polygon(
                {
                    vec2_t(screen_center.x + (INDICATOR_DISTANCEP + 15), screen_center.y),
                    vec2_t(screen_center.x + (INDICATOR_DISTANCEP + 2), screen_center.y - 9),
                    vec2_t(screen_center.x + (INDICATOR_DISTANCEP + 2), screen_center.y + 9)
                },
                manual == 2 and INDICATOR_COLORP or color_t(0, 0, 0, 0.4)
            )

           
            render.filled_polygon(
                {
                    vec2_t(screen_center.x - (INDICATOR_DISTANCEP + 15), screen_center.y),
                    vec2_t(screen_center.x - (INDICATOR_DISTANCEP + 2), screen_center.y - 9),
                    vec2_t(screen_center.x - (INDICATOR_DISTANCEP + 2), screen_center.y + 9)
                },
                manual == 1 and INDICATOR_COLORP or color_t(0, 0, 0, 0.4)
            )

          
            render.filled_polygon(
                {
                    vec2_t(screen_center.x, screen_center.y - (INDICATOR_DISTANCEP + 15)),
                    vec2_t(screen_center.x - 9, screen_center.y - (INDICATOR_DISTANCEP + 2)),
                    vec2_t(screen_center.x + 9, screen_center.y - (INDICATOR_DISTANCEP + 2))
                },
                manual == 3 and INDICATOR_COLORP or color_t(0, 0, 0, 0.4)
            )
        end
    end
end)

register_callback("unload", function()
    menu.ragebot_anti_aim_base_yaw_offset = STATES["default"]
end)


----------------Hitsound------------------------

register_callback("player_death", function(event)
    if Controls["killsound"] then
		if Controls["Dropdown2"] == 1 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_s1)
			end
			
		end
    end
end)

register_callback("player_death", function(event)
    if Controls["killsound"] then
		if Controls["Dropdown2"] == 2 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_s2 )
			end
			
		end
    end
end)

register_callback("player_death", function(event)
    if Controls["killsound"] then
		if Controls["Dropdown2"] == 3 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_s3)
			end
			
		end
    end
end)

register_callback("player_death", function(event)
    if Controls["killsound"] then
		if Controls["Dropdown2"] == 4 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_z1)
			end
			
		end
    end
end)

register_callback("player_death", function(event)
    if Controls["killsound"] then
		if Controls["Dropdown2"] == 5 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_z2)
			end
			
		end
    end
end)

register_callback("player_death", function(event)
    if Controls["killsound"] then
		if Controls["Dropdown2"] == 6 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_z3)
			end
			
		end
    end
end)

register_callback("player_death", function(event)
    if Controls["killsound"] then
		if Controls["Dropdown2"] == 7 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_1)
			end
			
		end
    end
end)


register_callback("player_hurt", function(event)
    if Controls["damagesound"] then
		if Controls["Dropdown3"] == 1 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_s1)
			end
			
		end
    end
end)

register_callback("player_hurt", function(event)
    if Controls["damagesound"] then
		if Controls["Dropdown3"] == 2 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_s2)
			end
			
		end
    end
end)

register_callback("player_hurt", function(event)
    if Controls["damagesound"] then
		if Controls["Dropdown3"] == 3 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_s3)
			end
			
		end
    end
end)

register_callback("player_hurt", function(event)
    if Controls["damagesound"] then
		if Controls["Dropdown3"] == 4 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_z1)
			end
			
		end
    end
end)

register_callback("player_hurt", function(event)
    if Controls["damagesound"] then
		if Controls["Dropdown3"] == 5 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_z2)
			end
			
		end
    end
end)

register_callback("player_hurt", function(event)
    if Controls["damagesound"] then
		if Controls["Dropdown3"] == 6 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_z3)
			end
			
		end
    end
end)

register_callback("player_hurt", function(event)
    if Controls["damagesound"] then
		if Controls["Dropdown3"] == 7 then
			if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
				engine.execute_client_cmd(custom_sound_1)
			end
			
		end
    end
end)
----------Fake Kill Feed----------------

register_callback("player_death", function(event)
    if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
        if Controls["FakeFeed"] then
			if Controls["headshot"] then
				event:set_int("headshot", 1)
			end
			if Controls["assistedflash"] then
				event:set_int("assistedflash", 1)
			end
			if Controls["noscope"] then
				event:set_int("noscope", 1)
			end
			if Controls["wallbang"] then
				event:set_int("penetrated", 4)
			end
			if Controls["revenge"] then
				event:set_int("revenge", 1)
			end
			if Controls["dominated"] then
			event:set_int("dominated", 1)
				end
			if Controls["inair"] then
				event:set_int("attackerinair", 1)
			end
			if Controls["headshoto"] then
				event:set_int("headshot", 0)
			end
			if Controls["assistedflasho"] then
				event:set_int("assistedflash", 0)
			end
			if Controls["noscopeo"] then
				event:set_int("noscope", 0)
			end
			if Controls["wallbango"] then
				event:set_int("penetrated", 0)
			end
			if Controls["revengeo"] then
				event:set_int("revenge", 0)
			end
			if Controls["dominatedo"] then
			event:set_int("dominated", 0)
				end
			if Controls["inairo"] then
				event:set_int("attackerinair", 0)
			end
		end
    end;
end);

--------Buybot--------------

register_callback("round_start", function ()
	if Controls["buybotr"] then
		if Controls["mainweapon"] then
			if Controls["Dropdown4"] == 1 then
				engine.execute_client_cmd("buy ssg08");
			end
		end
	end
end);
register_callback("round_start", function ()
	if Controls["buybotr"] then
		if Controls["mainweapon"] then
			if Controls["Dropdown4"] == 2 then
			engine.execute_client_cmd("buy scar20");
			end
		end
	end
end);
register_callback("round_start", function ()
	if Controls["buybotr"] then
		if Controls["mainweapon"] then
			if Controls["Dropdown4"] == 3 then
				engine.execute_client_cmd("buy awp");
			end
		end
	end
end);
register_callback("round_start", function ()
	if Controls["buybotr"] then
		if Controls["secondweapon"] then
			if Controls["Dropdown5"] == 1 then
				engine.execute_client_cmd("buy deagle");
			end
		end
	end
end);
register_callback("round_start", function ()
	if Controls["buybotr"] then
		if Controls["secondweapon"] then
			if Controls["Dropdown5"] == 2 then
				engine.execute_client_cmd("buy revolver");
			end
		end
	end
end);
register_callback("round_start", function ()
	if Controls["buybotr"] then
		if Controls["secondweapon"] then
			if Controls["Dropdown5"] == 3 then
				engine.execute_client_cmd("buy elite");
			end
		end
	end
end);
register_callback("round_start", function ()
	if Controls["heg"] then
        engine.execute_client_cmd("buy hegrenade");
	end
end);
register_callback("round_start", function ()
	if Controls["smoke"] then
        engine.execute_client_cmd("buy smokegrenade");
	end
end);
register_callback("round_start", function ()
	if Controls["molotov"] then
        engine.execute_client_cmd("buy molotov; buy incgrenade");
	end
end);
register_callback("round_start", function ()
	if Controls["flash"] then
        engine.execute_client_cmd("buy flashbang");
	end
end);
register_callback("round_start", function ()
	if Controls["taser"] then
        engine.execute_client_cmd("buy taser");
	end
end);
register_callback("round_start", function ()
	if Controls["defkit"] then
        engine.execute_client_cmd("buy defuser");
	end
end);
register_callback("round_start", function ()
	if Controls["vestb"] then
		if Controls["Dropdown6"] == 1 then
        engine.execute_client_cmd("buy vest");
		end
	end
end);
register_callback("round_start", function ()
	if Controls["vestb"] then
		if Controls["Dropdown6"] == 2 then
        engine.execute_client_cmd("buy vest;buy vesthelm");
		end
	end
end);
register_callback("round_start", function ()
	if Controls["buybotlegit"] then
		if Controls["ak47"] then
				engine.execute_client_cmd("buy ak47");
		end
		if Controls["m4a1"] then
				engine.execute_client_cmd("buy m4a1_silencer");
		end
		if Controls["m4a4"] then
				engine.execute_client_cmd("buy m4a1");
		end
	end
end);
-----------------Report--------------

local report_for = "Report for" 
local subbmited_report_id = "submitted, report id" 

local frequency = 1 -- 1 = Always, 2 = Often, 4 = Rarely, 6 = Really Rare, 10 = Almost Impossible


local team_message = false 

local custom_report_id = "" 

local playerNameOffset = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName");
local origControllerOffset = engine.get_netvar_offset("client.dll", "C_CSPlayerPawnBase", "m_hOriginalController");
local teamString = "_team"
if not team_message then teamString = "" end

register_callback("player_death", function(event)
    if event:get_pawn("userid") == entitylist.get_local_player_pawn() then
        if math.random(1,frequency)==1 then
		if Controls["Fakerep"] then
            local attackerPawn = event:get_pawn("attacker");
            local attackerControllerHandle = ffi.cast("int*", attackerPawn[origControllerOffset])[0];
            if not attackerControllerHandle then return; end;
                local attackerMainController = entitylist.get_entity_from_handle(attackerControllerHandle);
                if not attackerMainController then return; end;
                    local attackerName = ffi.string(ffi.cast("char**", attackerMainController[playerNameOffset])[0])
                    if custom_report_id ~= "" then
                        engine.execute_client_cmd(string.format("say%s %s %s %s %s",teamString, report_for, attackerName, subbmited_report_id, custom_report_id))
                    else
                        engine.execute_client_cmd(string.format("say%s %s %s %s %s%s",teamString, report_for, attackerName, subbmited_report_id, tostring(math.random(1000000000,9999999999)), tostring(math.random(100000000,999999999))))
                    end
				end
        end
    end
end)

-----------------Antiaim----------------------------------
local Anti_aim_Key = 0x54  -- Default value

local Verdana = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 16, bit.bor(16, 32));


ffi.cdef([[
    unsigned short GetAsyncKeyState(int key); 

    typedef struct Thread32Entry {
        uint32_t dwSize;
        uint32_t cntUsage;
        uint32_t th32ThreadID;
        uint32_t th32OwnerProcessID;
        long tpBasePri;
        long tpDeltaPri;
        uint32_t dwFlags;
    } Thread32Entry;

    typedef struct Color {
        uint8_t r, g, b, a;
    } Color;

    typedef struct Vector2D {
        float x, y;
    } Vector2D;


    typedef struct Vector4D {
        float x, y, z, w;
    } Vector4D;

    typedef struct RepeatedPtrField {
        void* pArena;
        int nCurrentSize;
        int nTotalSize;
	    void* pRep;
    } RepeatedPtrField;

    typedef struct CMsgVector {
        char pad_0x0[0x8];
        uint32_t nHasBits;
        uint64_t nCachedBits;
        Vector vecValue;
    } CMsgVector;

    typedef struct CInButtonStatePB {
        char pad_0x0[0x8];
        uint32_t nHasBits;
        uint64_t nCachedBits;
        uint64_t nValue;
        uint64_t nValueChanged;
        uint64_t nValueScroll;
    } CInButtonStatePB;

    typedef struct CInButtonState {
        char pad_0x0[0x8];
        uint64_t nValue;
        uint64_t nValueChanged;
        uint64_t nValueScroll;
    } CInButtonState;

    typedef struct CBaseUserCmdPB {
        char pad_0x0[0x8];
        uint32_t nHasBits;
        uint64_t nCachedBits;
        RepeatedPtrField subtickMovesField;
        const char* strMoveCrc;
        CInButtonStatePB* pInButtonState;
        CMsgVector* pViewAngles;
        int32_t nLegacyCommandNumber;
        int32_t nClientTick;
        float flForwardMove;
        float flSideMove;
        float flUpMove;
        int32_t nImpulse;
        int32_t nWeaponSelect;
        int32_t nRandomSeed;
        int32_t nMousedX;
        int32_t nMousedY;
        uint32_t nConsumedServerAngleChanges;
        int32_t nCmdFlags;
        uint32_t nPawnEntityHandle;
    } CBaseUserCmdPB;

    typedef struct CUserCmd {
        char pad_0x0[0x18];
        uint32_t nHasBits;
        uint64_t nCachedBits;
        RepeatedPtrField inputHistoryField;
        CBaseUserCmdPB* pBaseCmd;
        bool bLeftHandDesired;
        bool bIsPredictingBodyShotFX;
        bool bIsPredictingHeadShotFX;
        bool bIsPredictingKillRagdolls;
        int32_t nAttack3StartHistoryIndex;
        int32_t nAttack1StartHistoryIndex;
        int32_t nAttack2StartHistoryIndex;
        CInButtonState nButtons;
        char pad_0x58[0x20];
    } CUserCmd;

    typedef struct CConVar {
        const char* szName;
        struct CConVar* pNext;
        char pad_01[0x10];
        const char* szDescription;
        uint32_t nType;
        uint32_t nRegistered;
        uint32_t nFlags;
        uint32_t m_unk3;
        uint32_t m_nCallbacks;
        uint32_t m_unk4;
        union {
            bool Bool;
            short Int16;
            uint16_t Uint16;
            int Int;
            uint32_t Uint32;
            int64_t Int64;
            uint64_t Uint64;
            float Float;
            double Double;
            const char* String;
            struct Color Color;
            struct Vector2D Vector2D;
            struct Vector Vector3D;
            struct Vector4D Vector4D;
            struct Vector Angles;
        } Value;

        union {
            bool Bool;
            short Int16;
            uint16_t Uint16;
            int Int;
            uint32_t Uint32;
            int64_t Int64;
            uint64_t Uint64;
            float Float;
            double Double;
            const char* String;
            struct Color Color;
            struct Vector2D Vector2D;
            struct Vector Vector3D;
            struct Vector4D Vector4D;
            struct Vector Angles;
        } OldValue;
    } CConVar;
        
    typedef struct CUtlLinkedListElement {
        struct CConVar* element;
        uint16_t iPrevious;
        uint16_t iNext;
    } CUtlLinkedListElement;

    typedef struct CUtlMemory {
        struct CUtlLinkedListElement* pMemory;
        int nAllocationCount;
        int nGrowSize;
    } CUtlMemory;
        
    typedef struct CUtlLinkedList {
        struct CUtlMemory memory;
        uint16_t iHead;
        uint16_t iTail;
        uint16_t iFirstFree;
        uint16_t nElementCount;
        uint16_t nAllocated;
        struct CUtlLinkedListElement* pElements;
    } CUtlLinkedList;

    typedef struct IEngineCvar {
        char pad_01[0x40];
        struct CUtlLinkedList listCvars;
    } IEngineCvar;
    
    typedef struct CTraceRay {
        struct Vector vecStart;
        struct Vector vecEnd;
        struct Vector vecMins;
        struct Vector vecMaxs;
        char pad_01[0x5];
    } CTraceRay;

    typedef struct CTraceFilter {
        char pad_01[0x8];
        int64_t nTraceMask;
        int64_t arrUnknown[2];
        int32_t arrSkipHandles[4];
        int16_t arrCollisions[2];
        int16_t nUnknown2;
        uint8_t nUnknown3;
        uint8_t nUnknown4;
        uint8_t nUnknown5;
    } CTraceFilter;
    
    typedef struct CGameTrace {
        void* pSurface;
        void* pHitEntity;
        void* pHitboxData;
        char pad_01[0x38];
        uint32_t nContents;
        char pad_02[0x24];
        struct Vector vecStart;
        struct Vector vecEnd;
        struct Vector vecNormal;
        struct Vector vecPosition;
        char pad_03[0x4];
        float flFraction;
        char pad_04[0x6];
        bool bStartSolid;
        char pad_05[0x4D];
    } CGameTrace;
        
    int CloseHandle(void*);
    void* GetActiveWindow();
    void* GetCurrentProcess();
    uint32_t ResumeThread(void*);
    uint32_t GetCurrentThreadId();
    uint32_t SuspendThread(void*);
    uint32_t GetCurrentProcessId();
    void* GetModuleHandleA(const char*);
    void* GetProcAddress(void*, const char*);
    void* OpenThread(uint32_t, int, uint32_t);
    void* SetWindowLongPtrW(void*, int, void*);
    int Thread32Next(void*, struct Thread32Entry*);
    int Thread32First(void*, struct Thread32Entry*);
    int FlushInstructionCache(void*, void*, uint64_t);
    void* CreateToolhelp32Snapshot(uint32_t, uint32_t);
    typedef void*(*fnCreateInterface)(const char*, void*);
    int VirtualProtect(void*, uint64_t, uint32_t, uint32_t*);
    int64_t CallWindowProcW(void*, void*, uint32_t, uint64_t, int64_t);
]])

local function IsPressed(key)
    return bit.band(ffi.C.GetAsyncKeyState(key), 0x8000) == 0x8000;
end;

local arrHooks = {}
local arrThreads = {}
local arrConvars = {}
local nManualSide = 0
local arrVirtualKeys = {}
local NULLPTR = ffi.cast("void*", 0)
local INVALID_HANDLE = ffi.cast("void*", - 1)
local pOriginalWndProc = ffi.cast("void*", 0)
local arrManualStatus = {
    bLeft = false,
    bRight = false,
    bBackWard = false
}

local arrSettings = {
    
    nLeftKey = 0x5A, 
    nRightKey = 0x43, 
    nBackwardKey = 0x58, 
	
	

	bEnabled = true,
    bDisableInAir = false, 
    bForceAirStrafe = true, 
   
    bEnableArrow = true, 
    flCenterOffset = 40, 
    clrArrowColor = color_t(0, 255, 255, 255), 
   
    arrManualOffsets = { - 90, 90, 0 } 
}

local arrSchema = {
    nFlags = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_fFlags"),
    nHeatlh = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_iHealth"),
    nMoveType = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_MoveType"),
    nLifeState = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_lifeState"),
    vecVelocity = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_vecVelocity"),
    flWaterLevel = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_flWaterLevel")
}

local function FindSignature(szModule, szPattern)
    local pBase = find_pattern(szModule, szPattern)
    if ffi.cast("void*", pBase) == NULLPTR then
        return nil
    end

    return ffi.cast("uintptr_t", pBase)
end

local fnCreateFilter = ffi.cast("void(__fastcall*)(struct CTraceFilter&, void*, uint64_t, uint8_t, uint16_t)", assert(FindSignature("client.dll", "48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20 0F B6 41 37 33"), "custom viewmodel error: outdated signature"))
local fnTraceShape = ffi.cast("bool(__fastcall*)(void*, struct CTraceRay*, struct Vector*, struct Vector*, struct CTraceFilter*, struct CGameTrace*)", assert(FindSignature("client.dll", "48 89 5C 24 20 48 89 4C 24 08 55 56 41 55 41 56"), "custom viewmodel error: invalidate signature"))
local fnCreateMove = assert(FindSignature("client.dll", "E9 ?? ?? ?? ?? 0F ?? ?? 48 8B C4 44 88 40"), "antiaim error: outdated signature")
local fnGetUserCmd = ffi.cast("CUserCmd*(__fastcall*)(void*, int)", assert(FindSignature("client.dll", "40 53 48 83 EC 20 8B DA 85 D2 78 3C E8 7F"), "antiaim error: outdated signature"))
local fnGetUserCmdArray = ffi.cast("void*(__fastcall*)(void*, int)", assert(FindSignature("client.dll", "48 89 4C 24 08 41 54 41 57 48 83 EC 48 4C 63 E2"), "antiaim error: outdated signature"))
local fnGetCommandIndex = ffi.cast("void*(__fastcall*)(void*, int*)", assert(FindSignature("client.dll", "40 53 48 83 EC 20 4C 8B 41 10 48 8B DA 48 8B 0D"), "antiaim error: outdated signature"))
local fnGetViewAngles = ffi.cast("struct Vector*(__fastcall*)(void*, int)", assert(FindSignature("client.dll", "4C 8B C1 85 D2 74 08 48 8D 05 ?? ?? ?? ?? C3"), "antiaim error: outdated signature"))
ffi.metatype("struct CConVar", {
    __index = {
        int = function(this, nValue)
            if nValue then
                local nPrevValue = this.Value.Int
                this.Value.Int = nValue
                return nPrevValue
            end

            return this.Value.Int
        end,

        bool = function(this, bValue)
            if bValue ~= nil then
                local bPrevValue = this.Value.Bool
                this.Value.Bool = bValue
                return bPrevValue
            end

            return this.Value.bValue
        end,

        float = function(this, flValue)
            if flValue then
                local flPrevValue = this.Value.Float
                this.Value.Float = flValue
                return flPrevValue
            end

            return this.Value.Float
        end,

        string = function(this, szValue)
            if szValue then
                local szPrevValue = this.Value.String
                this.Value.String = szValue
                return ffi.string(szPrevValue)
            end

            return ffi.string(this.Value.String)
        end
    }
})

ffi.metatype("struct IEngineCvar", {
    __index = function(self, szName)
        if arrConvars[szName] then
            return arrConvars[szName]
        end

        local listCvar = self.listCvars
        for nIndex = 0, listCvar.memory.nAllocationCount - 1 do
            local pConVar = listCvar.memory.pMemory[nIndex].element
            if not pConVar then
                goto continue
            end

            if szName == ffi.string(pConVar.szName) then
                arrConvars[szName] = pConVar
                return pConVar
            end

            ::continue::
        end

        return false
    end
})

local IEngineCvar = ffi.cast("struct IEngineCvar*", ffi.cast("fnCreateInterface",
    ffi.C.GetProcAddress(ffi.C.GetModuleHandleA("tier0.dll"), "CreateInterface")
)("VEngineCvar007", nil))

local pInstance = (function()
    local pBase = assert(FindSignature("client.dll", "48 8B 0D ?? ?? ?? ?? E8 ?? ?? ?? ?? 48 8B CF 4C 8B E8"), "anti-aim: outdated signature")
    return ffi.cast("void**", pBase + 7 + ffi.cast("int*", pBase + 3)[0])[0]
end)()

local pUnknownInstance = (function()
    -- #xref "tracer_player.vpcf"
    local pBase = assert(FindSignature("client.dll", "48 8B 0D ?? ?? ?? ?? 8B D3 E8 ?? ?? ?? ?? 44 8B 86 48 12"), "anti-aim: outdated signature")
    return ffi.cast("void**", pBase + 7 + ffi.cast("int*", pBase + 3)[0])[0]
end)()

local function DegToRad(flDegree)
    return flDegree * math.pi / 180
end

local function Clamp(flValue, flMin, flMax)
    return math.max(flMin, math.min(flValue, flMax))
end

local function GetXButtonWParam(wParam)
    return bit.band(ffi.cast("uint16_t", bit.rshift(ffi.cast("uint64_t", wParam), 16)), 0xFFFF)
end

local function IsKeyDown(nVirtualKey)
    if arrVirtualKeys[nVirtualKey] == nil then
        arrVirtualKeys[nVirtualKey] = false
    end

    return arrVirtualKeys[nVirtualKey]
end

local function GetViewAngles()
    local vecViewAngles = fnGetViewAngles(pUnknownInstance, 0)
    return vec3_t(vecViewAngles.x, vecViewAngles.y, vecViewAngles.z)
end

local function Forward(vecAngles)
    local vecSin = vec3_t(math.sin(DegToRad(vecAngles.x)), math.sin(DegToRad(vecAngles.y)), 0)
    local vecCos = vec3_t(math.cos(DegToRad(vecAngles.x)), math.cos(DegToRad(vecAngles.y)), 0)
    return vec3_t(vecCos.x * vecCos.y, vecCos.x * vecSin.y, - vecSin.x)
end

local function Right(vecAngles)
    local vecSin = vec3_t(math.sin(DegToRad(vecAngles.x)), math.sin(DegToRad(vecAngles.y)), math.sin(DegToRad(vecAngles.z)))
    local vecCos = vec3_t(math.cos(DegToRad(vecAngles.x)), math.cos(DegToRad(vecAngles.y)), math.cos(DegToRad(vecAngles.z)))
    return vec3_t(vecSin.z * vecSin.x * vecCos.y * - 1 + vecCos.z * vecSin.y, vecSin.z * vecSin.x * vecSin.y * - 1 + - 1 * vecCos.z * vecCos.y, - 1 * vecSin.z * vecCos.x)
end

local function Up(vecAngles)
    local vecSin = vec3_t(math.sin(DegToRad(vecAngles.x)), math.sin(DegToRad(vecAngles.y)), math.sin(DegToRad(vecAngles.z)))
    local vecCos = vec3_t(math.cos(DegToRad(vecAngles.x)), math.cos(DegToRad(vecAngles.y)), math.cos(DegToRad(vecAngles.z)))
    return vec3_t(vecCos.z * vecSin.x * vecCos.y + vecSin.z * vecSin.y, vecCos.z * vecSin.x * vecSin.y + vecSin.z * vecCos.y * - 1, vecCos.z * vecCos.x)
end

local function GetField(pEntity, szName, szType)
    if not pEntity or pEntity == NULLPTR then
        return false
    end

    if not arrSchema[szName] then
        return false
    end

    return ffi.cast(("%s*"):format(szType), ffi.cast("uintptr_t", pEntity) + arrSchema[szName])[0]
end

local function IsAlive(pEntity)
    if not pEntity or pEntity == NULLPTR then
        return false
    end

    local nHealth = GetField(pEntity, "nHeatlh", "int")
    local nLifeState = GetField(pEntity, "nLifeState", "uint8_t")
    return nLifeState == 0 and nHealth > 0
end

local function Thread(nTheardID)
    local hThread = ffi.C.OpenThread(0x0002, 0, nTheardID)
    if hThread == NULLPTR or hThread == INVALID_HANDLE then
        return false
    end

    return setmetatable({
        bValid = true,
        nId = nTheardID,
        hThread = hThread,
        bIsSuspended = false
    }, {
        __index = {
            Suspend = function(self)
                if self.bIsSuspended or not self.bValid then
                    return false
                end

                if ffi.C.SuspendThread(self.hThread) ~= - 1 then
                    self.bIsSuspended = true
                    return true
                end

                return false
            end,

            Resume = function(self)
                if not self.bIsSuspended or not self.bValid then
                    return false
                end

                if ffi.C.ResumeThread(self.hThread) ~= - 1 then
                    self.bIsSuspended = false
                    return true
                end

                return false
            end,

            Close = function(self)
                if not self.bValid then
                    return
                end

                self:Resume()
                self.bValid = false
                ffi.C.CloseHandle(self.hThread)
            end
        }
    })
end

local function UpdateThreadList()
    arrThreads = {}
    local hSnapShot = ffi.C.CreateToolhelp32Snapshot(0x00000004, 0)
    if hSnapShot == INVALID_HANDLE then
        return false
    end

    local pThreadEntry = ffi.new("struct Thread32Entry[1]")
    pThreadEntry[0].dwSize = ffi.sizeof("struct Thread32Entry")
    if ffi.C.Thread32First(hSnapShot, pThreadEntry) == 0 then
        ffi.C.CloseHandle(hSnapShot)
        return false
    end

    local nCurrentThreadID = ffi.C.GetCurrentThreadId()
    local nCurrentProcessID = ffi.C.GetCurrentProcessId()
    while ffi.C.Thread32Next(hSnapShot, pThreadEntry) > 0 do
        if pThreadEntry[0].dwSize >= 20 and pThreadEntry[0].th32OwnerProcessID == nCurrentProcessID and pThreadEntry[0].th32ThreadID ~= nCurrentThreadID then
            local hThread = Thread(pThreadEntry[0].th32ThreadID)
            if not hThread then
                for _, pThread in pairs(arrThreads) do
                    pThread:Close()
                end

                arrThreads = {}
                ffi.C.CloseHandle(hSnapShot)
                return false
            end

            table.insert(arrThreads, hThread)
        end
    end

    ffi.C.CloseHandle(hSnapShot)
    return true
end

local function SuspendThreads()
    if not UpdateThreadList() then
        return false
    end

    for _, hThread in pairs(arrThreads) do
        hThread:Suspend()
    end

    return true
end

local function ResumeThreads()
    for _, hThread in pairs(arrThreads) do
        hThread:Resume()
        hThread:Close()
    end
end

local function CreateHook(pTarget, pDetour, szType)
    assert(type(pDetour) == "function", "antiaim error: invalid detour function")
    assert(type(pTarget) == "cdata" or type(pTarget) == "userdata" or type(pTarget) == "number" or type(pTarget) == "function", "antiaim error: invalid target function")
    if not SuspendThreads() then
        ResumeThreads()
        print("antiaim error: failed suspend threads")
        return false
    end

    local arrBackUp = ffi.new("uint8_t[14]")
    local pTargetFn = ffi.cast(szType, pTarget)
    local arrShellCode = ffi.new("uint8_t[14]", {
        0xFF, 0x25, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    })

    local __Object = {
        bValid = true,
        bAttached = false,
        pBackup = arrBackUp,
        pTarget = pTargetFn,
        pOldProtect = ffi.new("uint32_t[1]"),
        hCurrentProcess = ffi.C.GetCurrentProcess()
    }

    ffi.copy(arrBackUp, pTargetFn, ffi.sizeof(arrBackUp))
    ffi.cast("uintptr_t*", arrShellCode + 0x6)[0] = ffi.cast("uintptr_t", ffi.cast(szType, function(...)
        local bSuccessfully, pResult = pcall(pDetour, __Object, ...)
        if not bSuccessfully then
            __Object:Remove()
            print(("[antiaim]: unexception runtime error -> %s"):format(pResult))
            return pTargetFn(...)
        end

        return pResult
    end))

    __Object.__index = setmetatable(__Object, {
        __call = function(self, ...)
            if not self.bValid then
                return nil
            end

            self:Detach()
            local bSuccessfully, pResult = pcall(self.pTarget, ...)
            if not bSuccessfully then
                self.bValid = false
                print(("[antiaim]: runtime error -> %s"):format(pResult))
                return nil
            end

            self:Attach()
            return pResult
        end,

        __index = {
            Attach = function(self)
                if self.bAttached or not self.bValid then
                    return false
                end

                self.bAttached = true
                ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), 0x40, self.pOldProtect)
                ffi.copy(self.pTarget, arrShellCode, ffi.sizeof(arrBackUp))
                -- ffi.C.FlushInstructionCache(self.hCurrentProcess, self.pTarget, ffi.sizeof(arrBackUp))
                ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), self.pOldProtect[0], self.pOldProtect)
                return true
            end,

            Detach = function(self)
                if not self.bAttached or not self.bValid then
                    return false
                end

                self.bAttached = false
                ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), 0x40, self.pOldProtect)
                ffi.copy(self.pTarget, self.pBackup, ffi.sizeof(arrBackUp))
                -- ffi.C.FlushInstructionCache(self.hCurrentProcess, self.pTarget, ffi.sizeof(arrBackUp))
                ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), self.pOldProtect[0], self.pOldProtect)
                return true
            end,

            Remove = function(self)
                if not self.bValid then
                    return false
                end

                SuspendThreads()
                self:Detach()
                ResumeThreads()
                self.bValid = false
            end
        }
    })

    __Object:Attach()
    table.insert(arrHooks, __Object)
    ResumeThreads()
    return __Object
end

local function NormalizePitch(flPitch)
	while flPitch > 89 do
		flPitch = flPitch - 180
	end

	while flPitch < - 89 do
		flPitch = flPitch + 180
	end

	return flPitch
end

local function NormalizeYaw(flYaw)
	while flYaw > 180 do
		flYaw = flYaw - 360
	end

	while flYaw < - 180 do
		flYaw = flYaw + 360
	end

	return flYaw
end

local function NormalizeAngles(vecAngles)
    vecAngles.x = NormalizePitch(vecAngles.x)
    vecAngles.y = NormalizeYaw(vecAngles.y)
    vecAngles.z = 0
    return vecAngles
end

local function CalculateDelta(flSpeed)
    local flMaxSpeed = 300
    local flAirAccelerate = IEngineCvar["sv_airaccelerate"]:float()
    local flAccelerate = 50 / flAirAccelerate / flMaxSpeed * 100 / flSpeed
    if flAccelerate < 1 and flAccelerate > - 1 then
        return math.acos(flAccelerate)
    end

    return 0
end

local function CalculateAngleDelta(flAngles, flTarget)
    local flDelta = flAngles - flTarget
    local flRadius = math.fmod(flDelta, math.pi * 2)
    if flAngles > flTarget then
        if flRadius >= math.pi then
            flRadius = flRadius - math.pi * 2
        end
    else
        if flRadius <= - math.pi then
            flRadius = flRadius + math.pi * 2
        end
    end

    return flRadius
end

local function ProcessManualStatus()
	local nPrevManualStatus = nManualSide
	local bPressLeft, bPressRight, bPressBack = IsKeyDown(arrSettings.nLeftKey), IsKeyDown(arrSettings.nRightKey), IsKeyDown(arrSettings.nBackwardKey)
	if bPressLeft == arrManualStatus.bLeft and bPressRight == arrManualStatus.bRight and bPressBack == arrManualStatus.bBackWard then
		return
	end

	arrManualStatus.bLeft, arrManualStatus.bRight, arrManualStatus.bBackWard = bPressLeft, bPressRight, bPressBack
	if (bPressLeft and nPrevManualStatus == 1) or (bPressRight and nPrevManualStatus == 2) or (bPressBack and nPrevManualStatus == 3) then
		nManualSide = 0
		return
	end

	if bPressLeft and nPrevManualStatus ~= 1 then
		nManualSide = 1
	end

	if bPressRight and nPrevManualStatus ~= 2 then
		nManualSide = 2
	end

	if bPressBack and nPrevManualStatus ~= 3 then
		nManualSide = 3
	end
end

local function GetUserCmd()
    local pLocalPlayer = entitylist.get_local_player_controller()
    if not pLocalPlayer then
        return false
    end

    local pCommandIndex = ffi.new("int[1]")
    fnGetCommandIndex(pLocalPlayer[0], pCommandIndex)
    if pCommandIndex[0] == 0 then
        return false
    end

    local nCurrentCommand = pCommandIndex[0] - 1
    local pUserCmdBase = fnGetUserCmdArray(pInstance, nCurrentCommand)
    if pUserCmdBase == NULLPTR then
        return false
    end

    local nSequenceNumber = ffi.cast("int*", ffi.cast("uintptr_t", pUserCmdBase) + 0x5C00)[0]
    if nSequenceNumber <= 0 then
        return false
    end

    local pUserCmd = fnGetUserCmd(pLocalPlayer[0], nSequenceNumber)
    if pUserCmd == NULLPTR then
        return false
    end

    return pUserCmd
end

local function MovementButtonCorrection(pUserCmd)
    local pBaseCmd = pUserCmd.pBaseCmd
    pUserCmd.nButtons.nValue = bit.bxor(pUserCmd.nButtons.nValue, bit.lshift(1, 3))
	pUserCmd.nButtons.nValue = bit.bxor(pUserCmd.nButtons.nValue, bit.lshift(1, 4))
	pUserCmd.nButtons.nValue = bit.bxor(pUserCmd.nButtons.nValue, bit.lshift(1, 9))
	pUserCmd.nButtons.nValue = bit.bxor(pUserCmd.nButtons.nValue, bit.lshift(1, 10))
    if pBaseCmd.flForwardMove > 0 then
        pUserCmd.nButtons.nValue = bit.bor(pUserCmd.nButtons.nValue, bit.lshift(1, 3))
    elseif pBaseCmd.flForwardMove < 0 then
        pUserCmd.nButtons.nValue = bit.bor(pUserCmd.nButtons.nValue, bit.lshift(1, 4))
    end

    if pBaseCmd.flSideMove > 0 then
        pUserCmd.nButtons.nValue = bit.bor(pUserCmd.nButtons.nValue, bit.lshift(1, 9))
    elseif pBaseCmd.flSideMove < 0 then
        pUserCmd.nButtons.nValue = bit.bor(pUserCmd.nButtons.nValue, bit.lshift(1, 10))
    end
end

local function MovementCorrection(pUserCmd, vecAngles)
    local pBaseCmd = pUserCmd.pBaseCmd
    if pBaseCmd == NULLPTR or pBaseCmd.pViewAngles == NULLPTR then
        return
    end

    local vecTarget = vec3_t(0, vecAngles.y, 0)
    local vecCorrection = vec3_t(0, pBaseCmd.pViewAngles.vecValue.y, 0)

    local vecOldUp = Up(vecTarget)
    local vecOldRight = Right(vecTarget)
    local vecOldForward = Forward(vecTarget)

    local vecUp = Up(vecCorrection)
    local vecRight = Right(vecCorrection)
    local vecForward = Forward(vecCorrection)

    vecUp.x = 0
    vecUp.y = 0
    vecRight.z = 0
    vecOldUp.x = 0
    vecOldUp.y = 0
    vecForward.z = 0
    vecOldRight.z = 0
    vecOldForward.z = 0

    local flRollUp = vecUp.z * pBaseCmd.flUpMove
    local flYawSide = vecRight.y * pBaseCmd.flSideMove
    local flPitchSide = vecRight.x * pBaseCmd.flSideMove
    local flYawForward = vecForward.y * pBaseCmd.flForwardMove
    local flPitchForward = vecForward.x * pBaseCmd.flForwardMove

    pBaseCmd.flUpMove = Clamp(vecOldUp.x * flYawSide + vecOldUp.y * flPitchSide + vecOldUp.x * flYawForward + vecOldUp.y * flPitchForward + vecOldUp.z * flRollUp, - 1, 1)
    pBaseCmd.flSideMove = Clamp(vecOldRight.x * flPitchSide + vecOldRight.y * flYawSide + vecOldRight.x * flPitchForward + vecOldRight.y * flYawForward + vecOldRight.z * flRollUp, - 1, 1)
    pBaseCmd.flForwardMove = Clamp(vecOldForward.x * flPitchSide + vecOldForward.y * flYawSide + vecOldForward.x * flPitchForward + vecOldForward.y * flYawForward + vecOldForward.z * flRollUp, - 1, 1)

    MovementButtonCorrection(pUserCmd)
end

local function AutoStrafe(pBaseCmd, flMoveYaw, vecVelocity)
    local flSpeed = vecVelocity:length_2d()
    local flDeltaAir = CalculateDelta(flSpeed)
    if flDeltaAir == 0 then
        return
    end

    local flBestAngle = math.atan2(pBaseCmd.flSideMove, pBaseCmd.flForwardMove)
    local flVelocityAngle = math.atan2(vecVelocity.y, vecVelocity.x) - math.rad(flMoveYaw)

    local flDeltaAngle = CalculateAngleDelta(flVelocityAngle, flBestAngle)
    local flFinalMove = flDeltaAngle < 0 and flVelocityAngle + flDeltaAir or flVelocityAngle - flDeltaAir

    pBaseCmd.flSideMove = math.sin(flFinalMove)
    pBaseCmd.flForwardMove = math.cos(flFinalMove)
end

local function ProcessKey(nMsg, wParam)
    if nMsg == 0x100 then
        arrVirtualKeys[tonumber(wParam)] = true
    elseif nMsg == 0x101 then
        arrVirtualKeys[tonumber(wParam)] = false
    elseif nMsg == 0x201 then
        arrVirtualKeys[0x1] = true
    elseif nMsg == 0x202 then
        arrVirtualKeys[0x1] = false
    elseif nMsg == 0x204 then
        arrVirtualKeys[0x2] = true
    elseif nMsg == 0x205 then
        arrVirtualKeys[0x2] = false
    elseif nMsg == 0x207 then
        arrVirtualKeys[0x4] = true
    elseif nMsg == 0x208 then
        arrVirtualKeys[0x4] = false
    elseif nMsg == 0x20B then
        local nParam = GetXButtonWParam(wParam)
        if nParam == 0x1 then
            arrVirtualKeys[0x5] = true
        elseif nParam == 0x2 then
            arrVirtualKeys[0x6] = true
        end

    elseif nMsg == 0x20C then
        local nParam = GetXButtonWParam(wParam)
        if nParam == 0x1 then
            arrVirtualKeys[0x5] = false
        elseif nParam == 0x2 then
            arrVirtualKeys[0x6] = false
        end
    end
end

local m_pGameSceneNode = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_pGameSceneNode");
local m_pBulletServices = engine.get_netvar_offset("client.dll", "C_CSPlayerPawn", "m_pBulletServices");
local m_vecAbsOrigin = engine.get_netvar_offset("client.dll", "CGameSceneNode", "m_vecAbsOrigin");
local m_vecViewOffset = engine.get_netvar_offset("client.dll", "C_BaseModelEntity", "m_vecViewOffset");

local GetEyePos = function(pLocalPawn)
    local GameSceneNode = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_pGameSceneNode)[0];
    if not GameSceneNode or GameSceneNode == 0 then return vec3_t(0,0,0) end;
    local vecAbsOrigin = ffi.cast("struct Vector*", ffi.cast("uintptr_t", GameSceneNode) + m_vecAbsOrigin)[0];
    local vecViewOffset = ffi.cast("struct Vector*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_vecViewOffset)[0];
    
    return vec3_t(vecAbsOrigin.x + vecViewOffset.x, vecAbsOrigin.y + vecViewOffset.y, vecAbsOrigin.z + vecViewOffset.z);
end;

local IEngineTrace = (function()
    -- #xref "const CTraceFilter::`vftable'"
    local pEngineTrace = assert(FindSignature("client.dll", "48 8B 0D ?? ?? ?? ?? 4C 8B C3 66 89 44 24"), "custom viewmodel error: outdated signature")
    return ffi.cast("void**", pEngineTrace + 7 + ffi.cast("int*", pEngineTrace + 3)[0])[0]
end)()

local function TraceShape(vecStart, vecEnd, pSkip)
    local vecFrom = ffi.new("struct Vector[1]")
    local vecFinal = ffi.new("struct Vector[1]")
    local pTraceRay = ffi.new("struct CTraceRay[1]")
    local pFilter = ffi.new("struct CTraceFilter[1]")
    local pGameTrace = ffi.cast("struct CGameTrace*", ffi.new("struct CGameTrace[1]"))
    fnCreateFilter(pFilter[0], pSkip, 0x1C3003, 4, 7)
    for _, szKey in pairs({ "x", "y", "z" }) do
        vecFinal[0][szKey] = vecEnd[szKey]
        vecFrom[0][szKey] = vecStart[szKey]
    end
    fnTraceShape(IEngineTrace, pTraceRay, vecFrom, vecFinal, pFilter, pGameTrace)
    return pGameTrace
end

local a = "0"
local function AntiAim()
    a = "0"
    local pLocalPawn = entitylist.get_local_player_pawn()
	if not Controls["fstand"] then
	if arrSettings.bEnabled then
    if not pLocalPawn or not IsPressed(Anti_aim_Key) or IsPressed(0x01) or not IsAlive(pLocalPawn[0]) then
        return
    end
	end
end
    local pUserCmd = GetUserCmd()
    if not pUserCmd then
        return
    end

    local pBaseCmd = pUserCmd.pBaseCmd
    if pBaseCmd == NULLPTR or pBaseCmd.pViewAngles == NULLPTR then
        return
    end

    local nFlags = GetField(pLocalPawn[0], "nFlags", "uint32_t")
    local nMoveType = GetField(pLocalPawn[0], "nMoveType", "uint8_t")
    local flWaterLevel = GetField(pLocalPawn[0], "flWaterLevel", "float")
    local vecVelocity = GetField(pLocalPawn[0], "vecVelocity", "struct Vector")
    if not nFlags or not nMoveType or not vecVelocity then
        return
    end

    if bit.band(pUserCmd.nButtons.nValue, bit.lshift(1, 5)) ~= 0 then
        return
    end

    local bOnGround = bit.band(nFlags, bit.lshift(1, 0)) ~= 0
    if arrSettings.bDisableInAir and not bOnGround then
        return
    end

    ProcessManualStatus()
    local vecCameraAnlges = GetViewAngles();
    local vecEyePos = GetEyePos(pLocalPawn);
    local flAngleDiff = pBaseCmd.pViewAngles.vecValue.y - vecCameraAnlges.y
    local bInSpeed = bit.band(pUserCmd.nButtons.nValue, bit.lshift(1, 16)) ~= 0

    local arrFractions = {
        ["_l"] = 0,
        ["_r"] = 0
    }
    
    for i = vecCameraAnlges.y - 90, vecCameraAnlges.y + 90, 30 do
        if i ~= vecCameraAnlges.y then
            local vecDest = vec3_t(vecEyePos.x + 256 * math.cos(math.rad(i)), vecEyePos.y + 256 * math.sin(math.rad(i)), vecEyePos.z);
            local pTrace = TraceShape(vecEyePos, vecDest, pLocalPawn[0]);
            local side = i < vecCameraAnlges.y and "_l" or "_r"
            arrFractions[side] = arrFractions[side] + pTrace.flFraction
        end
    end

    a = arrFractions._l > arrFractions._r and "<" or ">";
    local flAdd = arrFractions._l > arrFractions._r and -90 or 90;
    pBaseCmd.pViewAngles.vecValue.y = pBaseCmd.pViewAngles.vecValue.y + flAdd;

    local flMoveYaw = NormalizeYaw(vecCameraAnlges.y + flAngleDiff);
    if not bOnGround and not bInSpeed and arrSettings.bForceAirStrafe and nMoveType ~= 8 and nMoveType ~= 9 and flWaterLevel < 2 then
        AutoStrafe(pBaseCmd, flMoveYaw, vec3_t(vecVelocity.x, vecVelocity.y, vecVelocity.z))
    end

    NormalizeAngles(pBaseCmd.pViewAngles.vecValue)
    MovementCorrection(pUserCmd, vec3_t(0, flMoveYaw, 0))
end

local function hkWndProc(hWnd, nMsg, wParam, lParam)
    ProcessKey(nMsg, wParam)
    return ffi.C.CallWindowProcW(pOriginalWndProc, hWnd, nMsg, wParam, lParam)
end

local function hkCreateMove(pObject, pCCSGOInput, nSlot, nActive)
    pObject(pCCSGOInput, nSlot, nActive)
    pcall(function()
        AntiAim()
    end)
end

local function hkUnLoad()
    for _, pObject in pairs(arrHooks) do
        pObject:Remove()
    end

    if pOriginalWndProc ~= NULLPTR then
        local hWnd = ffi.C.GetActiveWindow()
		ffi.C.SetWindowLongPtrW(hWnd, - 4, ffi.cast("void*", pOriginalWndProc))
		pOriginalWndProc = NULLPTR
	end
end

local function hkPresent()
    local pLocalPawn = entitylist.get_local_player_pawn()
	if not Controls["fstand"] then
    if not pLocalPawn or not IsPressed(Anti_aim_Key) or not IsAlive(pLocalPawn[0]) or a == "0" then
        return
    end
end
    local vecScreenSize = render.screen_size() / 2
    render.text(a, Verdana, vec2_t((vecScreenSize.x) + (a == ">" and 90 or -90), vecScreenSize.y - 8), color_t(1,1,1,1))
end

local function SetupWndProc()
    if pOriginalWndProc ~= NULLPTR then
        return
    end

    local hWnd = ffi.C.GetActiveWindow()
    local pWndProcProxy = ffi.cast("int64_t(__stdcall*)(void*, uint32_t, uint64_t, int64_t)", hkWndProc)
    pOriginalWndProc = ffi.C.SetWindowLongPtrW(hWnd, - 4, ffi.cast("void*", pWndProcProxy))
end

local function Setup()
    -- SetupWndProc()
    register_callback("unload", hkUnLoad)
    register_callback("paint", hkPresent)
    CreateHook(fnCreateMove, hkCreateMove, "void(__fastcall*)(void*, int, uint8_t)")
end


Setup()

-----------------Keybinds--------------

local CoordX = 100 
local CoordY = 300 

local ColorOutline = color_t(140 / 255, 142 / 255, 255 / 255, 255)


local ffi = require("ffi")

ffi.cdef[[
    unsigned short GetKeyState(int nVirtKey);
]]

local Input = {}
Input.GetCursorPos = function()
    local pointer = ffi.new("POINT[1]")
    ffi.C.GetCursorPos(pointer)
    return pointer[0]
end

Input.IsKey = function(virtualKey)
    local state = ffi.C.GetKeyState(virtualKey)
    return bit.band(state, 0x8000) ~= 0, bit.band(state, 1) ~= 0
end
Input.GetKeyState = function(virtualKey)
    local hold, toggle = Input.IsKey(virtualKey)
    return hold, toggle
end


local bindslist = {
    {name = "Left Manual",     key = 0x5A, type = "toggle"},
    {name = "Right Manual",       key = 0x43, type = "toggle"},
    {name = "Forward Manual",   key = 0x58, type = "toggle"},
   
 
}

local Verdana = render.setup_font("C:/Windows/Fonts/verdana.ttf", 12, 400)

register_callback("paint", function()
    local x, y = CoordX, CoordY
    local Add = 0
    local RenderOther = false

    for _, bind in ipairs(bindslist) do
        local hold, toggle = Input.GetKeyState(bind.key)
		if Controls["MenuBinds"] then
	
		
        if bind["type"] == "hold" then
            if hold then
                RenderOther = true
                render.text(bind["name"], Verdana, vec2_t(x + 3, y + 24 + Add), color_t(255, 255, 255, 255))
                render.text("[on]", Verdana, vec2_t(x + 154, y + 24 + Add), color_t(255, 255, 255, 255))

                Add = Add + 15
            end
        elseif bind["type"] == "toggle" then
            if toggle then
                RenderOther = true
                render.text(bind["name"], Verdana, vec2_t(x + 3, y + 24 + Add), color_t(255, 255, 255, 255))
                render.text("[on]", Verdana, vec2_t(x + 154, y + 24 + Add), color_t(255, 255, 255, 255))
                Add = Add + 15

            end
        end
    end

    if RenderOther == true then

        render.rect_filled(vec2_t(x - 1, y - 1), vec2_t(x + 181, y + 18), color_t(140 / 255, 142 / 255, 255 / 255, 255), 5)
        render.rect_filled(vec2_t(x, y), vec2_t(x + 180, y + 20), color_t(140 / 255, 142 / 255, 255 / 255, 255), 5)
        render.text("keybinds", Verdana, vec2_t(x + 68, y + 3), color_t(255, 255, 255, 255))
    end
	end
	
	--if is_key_pressed(0x51) then  -- Q key is pressed
            
            
end)