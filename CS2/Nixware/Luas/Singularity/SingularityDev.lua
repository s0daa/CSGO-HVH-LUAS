-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- Made by @yaw_for_real (AWeirDKiD | UID: 192341)

-- SETTINGS START
local menu_accents_color = color_t(161/255, 110/255, 228/255, 1)

local manuals_distance = 65 -- Default: 65

local Wallbang_Helper_Settings = {
    line_width = 1.5, -- Default: 1.5
    normal_color = color_t(1, 1, 1, 0.4), -- Default: (1, 1, 1, 0.4)
    reverse_color_from = color_t(0, 1, 0, 0.4), -- Default: (0, 1, 0, 0.4)
    reverse_color_to = color_t(1, 0, 0, 0.4), -- Default: (1, 0, 0, 0.4)
    endpoint_radius = 20, -- Size of dot at the end of the line | Default: 20
}

local tracers_color = color_t(221/255, 32/255, 246/255, 1) -- Default: (221/255, 32/255, 246/255, 1) | Color of the bullet tracers
-- Weapon Names: glock, hkp2000, usp_silencer, elite, p250, tec9, fiveseven, cz75a, deagle, revolver, nova, mag7, sawedoff, xm1014, m249, negev, mp5sd, p90, mp7, mac10, mp9, bizon, ump45, galilar, famas, ak47, m4a1, m4a1_silencer, ssg08, aug, sg556, awp, g3sg1, scar20, vest, vesthelm, taser, defuser, flashbang, smokegrenade, hegrenade, molotov, incgrenade, decoy

local killsay_phrases = {
    "Get good, get Singularity.lua",
    "I'd tell you to shoot yourself, but I bet you'd miss",
    "Are you always this slow? I thought it was just server lag!",
    "You should let your chair play, at least it knows how to support.",
    "Don't worry, just a few thousand more hours, and you’ll be almost like me.",
    "Guys, it’s not my fault your screens can’t react as fast as mine!",
    "The only thing lower than your k/d ratio is your I.Q.",
    "Looks like you’ve got a chance! Take a screenshot for the memories.",
    "Trying to play carefully so I don’t make you feel too bad ",
    "Did you know sharks only kill 5 people each year? Looks like you got some competition",
    "My knife is well-worn, just like your mother.",
    "Singularity.lua on top!",
    "Options -> How To Play ",
    "My dead dad has better aim than you, it only took him one bullet",
    "Some babies were dropped on their heads but you were clearly thrown at a wall",
    "Internet Explorer is faster than your reactions.",
    "Oops, sorry, I think I accidentally turned on ‘God mode’!",
    "I'm surprised you've got the brain power to keep your heart beating",
    "You're about as useful as pedals on a wheelchair. ",
    "You define autism",
    "The only thing you carry is an extra chromosome.",
    "Are you doing alright there, or should I slow down?",
    "You don't deserve to play this game. Go back to playing with crayons and shitting yourself",
    "Yo mama so fat when she plays Overpass, you can shoot her on Mirage.",
    "You’ve got a long way to go before you catch up to me.",
    "Singularity.lua is the only thing that can save you now.",
    "Sorry if I’m too fast for you it’s just my reflexes!",
    "Why you miss im not you're girlfriend",
    "The only thing you can throw are rounds.",
    "Why you miss im not your girlfriend",
    "Get good, get Singularity.lua",
    "Are you guys penguins? Moving so slow!",
    "Try to guess where I’ll pop up... or just don’t bother.",
    "I'm not trash talking, I'm talking to trash.",
    "If you were a CSGO match, your mother would have a 7day cooldown all the time, because she kept abandoning you.",
    "Someone here isn’t on my level... and it’s not me.",
    "Seems like you’re on pause the whole time, or is it just me?",
    "You do know this is a match and not just a chat lobby, right?",
    "I could beat you even without chat. Want to test that?",
    "When are you guys going to start trying? I’m waiting!",
    "Even with my eyes closed, I’d still be faster.",
    "Guess I’ll have to lower my difficulty to give you a chance.",
    "Get good, get Singularity.lua",
    "You can surrender now I won’t mind!",
    "If CS2 is too hard for you maybe consider a game that requires less skill, like idk.... solitaire?",
    "Oops, I must have chosen easy bots by accident...",
    "Don't be a loser, buy a rope and hang yourself.",
    "If I were to commit suicide, I would jump from your ego to your elo.",
    "Do you feel special? Please try suicide again... Hopefully you will be successful this time.",
    "Idk if u know but it's mouse1 to shoot.",
    "You are the reason why people say the CS2 community sucks.",
    "Get good, get Singularity.lua",
    "Sell your computer and buy a Wii.",
    "error: ur resolver is trash",
    "Studies show that aiming gives you better chances of hitting your target.",
    "There are about 37 trillion cells working together in your body right now, and you are disappointing every single one of them."
}
-- SETTINGS END
-- Do not modify anything below this line unless you know what you are doing.

local ffi = require("ffi")
local bit = require("bit")

ffi.cdef[[
    short GetAsyncKeyState(int vKey);
]]

local default_yaw_offset = menu.ragebot_anti_aim_base_yaw_offset
local default_auto_strafer = menu.ragebot_auto_strafer

-- GUI CODE BASE BY sigmacord.lua and winter.lua | Heavily Modified
local settingList = {}

local font14 = render.setup_font("C:/Windows/Fonts/verdana.ttf", 12)
local font16 = render.setup_font("C:/Windows/Fonts/verdana.ttf", 13)
local titleFont = render.setup_font("C:/Windows/Fonts/verdana.ttf", 22)

local function newSetting(type, name, value, minValue, maxValue, increment, text, callback, customFont)
    local s = {
        type = type,
        name = name, 
        value = value,
        minValue = minValue,
        maxValue = maxValue,
        increment = increment,
        text = text,
        callback = callback,
        font = customFont
    }
    table.insert(settingList, s)
    return s
end

local function newCheckbox(name, value, has_color_picker, default_color)
    local s = newSetting("checkbox", name, value)
    if has_color_picker then
        s.has_color_picker = true
        s.color_value = default_color or color_t(1, 1, 1, 1)
        s.is_color_open = false
        s.hue = 0
        s.picker_pos = vec2_t(0, 0)
        s.last_selected_color_pos = nil
        s.picker_alpha = 0
    end
    return s
end
local function newSlider(name, value, minValue, maxValue, increment)
    return newSetting("slider", name, value, minValue, maxValue, increment)
end
local function newText(text, font)
    return newSetting("text", nil, nil, nil, nil, nil, text, nil, font)
end
local function newKeybind(name, callback, mode)
    local kb = newSetting("keybind", name, "none", nil, nil, nil, nil, callback)
    kb.mode = mode or 1
    return kb
end
local function newDropdown(name, values, default_index)
    local s = newSetting("dropdown", name, default_index or 1, 1, #values)
    s.values = values
    return s
end
local function newCombobox(name, values, default_selections)
    local selections = {}
    default_selections = default_selections or {}
    for i = 1, #values do
        selections[i] = default_selections[i] or false
    end
    local s = newSetting("combobox", name, selections, 1, #values)
    s.values = values
    return s
end

local function color_from_hsv(h, s, v, a)
    local r, g, b
    
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    
    i = i % 6
    
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    
    return color_t(r, g, b, a or 1)
end

local gui = {
    x = 320, y = 320,
    width = 260, height = 550,
    isOpen = true,
    isDragging = false,
    dragOffset = {x = 0, y = 0},
    waitingForKey = false,
    activeKeybind = nil,
    currentTab = "Anti-Aim",
    targetWidth = 300,
    targetHeight = 590,
    alpha = 1,
    tabAlpha = 1,
    activeDropdown = nil,
    dropdownOptions = {"Hold", "Toggle"},
    activeInputBox = nil,
    inputBuffer = "",
    isTyping = false,
    originalInputValue = ""
}

local tabSettings = {
    ["Anti-Aim"] = {},
    ["Rage"] = {},
    ["Misc"] = {}
}

local function round(exact, quantum)
    local quant = math.floor(exact/quantum)
    return quantum * (quant + (exact/quantum - quant > 0.5 and 1 or 0))
end

ffi.cdef[[
    typedef struct {
        long x;
        long y;
    } POINT;
    int GetCursorPos(POINT* lpPoint);
    int ScreenToClient(void* hWnd, POINT* lpPoint);
    short GetAsyncKeyState(int vKey);
    void* GetForegroundWindow();
    unsigned long GetTickCount();
    static const int VK_INSERT = 0x2D;
    static const int VK_LBUTTON = 0x01;
    static const int VK_UP = 0x26;
    static const int VK_DOWN = 0x28;
    static const int VK_PRIOR = 0x21;
    static const int VK_NEXT = 0x22;
    typedef struct Vector {
        float x, y, z;
    } Vector;
    unsigned short GetKeyState(int nVirtKey);
]]

local user32 = ffi.load("user32")
-- local kernel32 = ffi.load("kernel32")
local VK = {INSERT = 0x2D, LBUTTON = 0x01, UP = 0x26, DOWN = 0x28, PRIOR = 0x21, NEXT = 0x22}
local prev = {insert = false, mouse = false}
local function get_mouse_pos()
    local point = ffi.new("POINT[1]")
    user32.GetCursorPos(point)
    user32.ScreenToClient(user32.GetForegroundWindow(), point)
    return vec2_t(point[0].x, point[0].y)
end
local function lerp(a, b, t) return a + (b - a) * t end
local function clamp(val, min, max) return math.max(min, math.min(val, max)) end
local function is_key_pressed(key) 
    if type(key) == "string" or key == "none" or not key then
        return false
    end
    return bit.band(user32.GetAsyncKeyState(key), 0x8000) ~= 0 
end
local function get_key_name(vKey)
    local keyNames = {
        [0x01] = "M1", [0x02] = "M2", [0x04] = "M3", [0x05] = "M4", [0x06] = "M5",
        [0x08] = "BACKSPACE", [0x09] = "TAB", [0x0D] = "ENTER", [0x10] = "SHIFT",
        [0x11] = "CTRL", [0x12] = "ALT", [0x14] = "CAPS", [0x1B] = "ESC",
        [0x20] = "SPACE", [0x25] = "LEFT", [0x26] = "UP", [0x27] = "RIGHT",
        [0x28] = "DOWN", [0x2D] = "INS", [0x2E] = "DEL"
    }
    if keyNames[vKey] then return keyNames[vKey] end
    local char = string.char(vKey)
    if char:match("%w") then return char end
    return string.format("0x%02X", vKey)
end
local key_states = {}
local function check_keys()
    if not gui.waitingForKey then return end
    for i = 1, 255 do
        if i ~= VK.LBUTTON and i ~= VK.RBUTTON and is_key_pressed(i) then
            gui.waitingForKey = false
            if gui.activeKeybind then
                gui.activeKeybind.value = i
            end
            return
        end
    end
end

local function find_text_files()
    local scripts_path = get_game_directory() .. "\\nix\\scripts"
    local files = {}
    
    local dir = io.popen('dir "' .. scripts_path .. '" /b')
    if not dir then return {} end
    
    for file in dir:lines() do
        if file:match("%.txt$") then
            table.insert(files, file)
        end
    end
    dir:close()
    
    table.sort(files)
    
    if #files == 0 then
        table.insert(files, "No text files found")
    end
    
    return files
end

-- DEFAULT COLOR (menu_accents_color): color_t(161/255, 110/255, 228/255, 1)

-- Anti-Aim Tab
menu_anti_aim_builder_enabled = newCheckbox("Anti-Aim Builder", true)
menu_conditions_selector = {"Stand", "Run", "In-Air", "Air-Duck", "Duck", "Duck-Walk"}
menu_anti_aim_builder_conditions = newDropdown("Condition", menu_conditions_selector, 1)
menu_anti_aim_yaw_modifier_values = {"None", "Center", "Offset", "Random", "3-Way", "5-Way", "Spin"}
menu_anti_aim_pitch = newDropdown("Pitch [Global]", {"None", "Down", "Fake"}, 2)
menu_random_yaw_enabled = newCheckbox("Random Base Yaw", false)
menu_random_yaw_deviance = newSlider("Randomiser Offset", 25, 1, 180, 1)
menu_randomness_mode = newSlider("Randomiser Mode", 1, 1, 2, 1)
menu_manual_aa_enabled = newCheckbox("Manual AA", true, true, color_t(161/255, 110/255, 228/255, 1))
menu_manual_right_key = newKeybind("Manuals Right Key", function() end, 2)
menu_manual_right_key.value = 0x43
menu_manual_left_key = newKeybind("Manuals Left Key", function() end, 2)
menu_manual_left_key.value = 0x5A
menu_pitch_jitter_enabled = newCheckbox("Pitch Jitter on Manuals", true)
menu_pitch_jitter_chance = newSlider("Pitch Jitter Down %", 90, 1, 100, 1)
menu_0_pitch_on_land_enabled = newCheckbox("0 Pitch on Land", true)
menu_0_pitch_on_land_duration = newSlider("0 Pitch Duration", 3, 1, 64, 1)
menu_air_flick_enabled = newCheckbox("Air Flick", true)
menu_air_flick_trigger_rate = newSlider("Air Flick Rate (Ticks)", 32, 0, 63, 1)

-- Rage Tab
menu_default_min_dmg = newSlider("Min Damage", 100, 1, 120, 1)
menu_default_override_min_dmg_key = newKeybind("Min Damage Override Key", function() end, 2)
menu_default_override_min_dmg_key.value = 0x06
menu_default_override_min_dmg = newSlider("Min Damage Override", 10, 1, 120, 1)

menu_duck_peek_assist_enabled = newCheckbox("Duck Peek Assist", true)
menu_duck_peek_assist_key = newKeybind("Duck Peek Assist Key", function() end, 2)
menu_duck_peek_assist_key.value = 0x58

menu_ai_peek_enabled = newCheckbox("AI Peek", false)
menu_ai_peek_key = newKeybind("AI Peek Key", function() end, 1)
menu_ai_peek_key.value = 0x05
menu_ai_peek_offset = newSlider("AI Peek Offset", 55, 1, 200, 1)
menu_ai_peek_limit = newSlider("AI Peek Limit (M)", 0.5, 0.1, 2, 0.1)

menu_wallbang_helper_enabled = newCheckbox("Wallbang Helper", false)
menu_wallbang_helper_minimum_distance_to_draw = newSlider("Min Draw Distance", 500, 200, 2000, 1)
wallbang_helper_files = find_text_files()
menu_wallbang_helper_file = newDropdown("Wallbang Helper Config", wallbang_helper_files, 1)

menu_disable_ragebot_in_air_enabled = newCheckbox("Disable Ragebot in Air", false)
menu_adaptive_auto_strafer_enabled = newCheckbox("Adaptive Auto Strafer", true)
menu_buybot = newCheckbox("Buybot", true)
menu_buybot_options_gui = {"SSG08", "Auto", "AWP", "Revolver", "Deagle", "VestHelm", "Grenade", "Smoke", "Molotov", "Defuser", "Taser"}
buybot_cmd_names = {"ssg08", "scar20; buy g3sg1", "awp", "revolver", "deagle", "vest; buy vesthelm", "hegrenade", "smokegrenade", "molotov; buy incgrenade", "defuser", "taser"}
menu_buybot_selector = newCombobox("Buybot Settings", menu_buybot_options_gui, {false, false, false, false, false, false, false, false, false, false, false})
menu_killsay_enabled = newCheckbox("Killsay", false) -- off by default because its annoying as hell

-- Misc Tab
menu_custom_menu_color_enabled = newCheckbox("Custom Menu Color", false, true, color_t(161/255, 110/255, 228/255, 1))
menu_thirdperson_distance = newSlider("Thirdperson Distance", 100, 1, 150, 1)
menu_fov_value = newSlider("FOV Changer", 90, 60, 160, 1)
menu_local_player_glow_enabled = newCheckbox("Local Player Glow", false, true, color_t(161/255, 110/255, 228/255, 1))
menu_preserve_killfeed = newCheckbox("Preserve Killfeed", true)
menu_slowdown_indicator = newCheckbox("Slowdown Indicator", true)
menu_hitlogs_enabled = newCheckbox("Hit/Hurt Logs", true)
menu_bullet_tracers_enabled = newCheckbox("Bullet Tracers", true, true, tracers_color)
menu_bullet_tracers_size = newSlider("Tracer Size", 1.5, 0.1, 5, 0.1)
menu_bullet_tracers_time = newSlider("Tracer Duration", 3, 0.1, 10, 0.1)
menu_firstperson_on_utilities = newCheckbox("Auto Firstperson on Utilities", false)
menu_watermark_enabled = newCheckbox("Watermark", true, true, color_t(161/255, 110/255, 228/255, 1))
menu_watermark_styles = {"Basic", "Default", "Modern", "OldSchool"}
menu_watermark_style = newDropdown("Watermark Style", menu_watermark_styles, 2)
menu_custom_scope_enabled = newCheckbox("Custom Scope", true, true, color_t(161/255, 110/255, 228/255, 1))
menu_custom_scope_offset = newSlider("Custom Scope Offset", 20, 10, 100, 1)
menu_custom_scope_length = newSlider("Custom Scope Length", 80, 20, 200, 1)
menu_visuals_combobox = {"Conditions", "Manuals"}
menu_indicators = newCombobox("Indicators", menu_visuals_combobox, {true, true})
menu_auto_thirdperson_spectate_enabled = newCheckbox("Auto Thirdperson on Spectate", true)

if menu_custom_menu_color_enabled.value then
    menu_accents_color = menu_custom_menu_color_enabled.color_value
else
    menu_accents_color = color_t(161/255, 110/255, 228/255, 1)
end

local condition_settings = {}
for i, condition in ipairs(menu_conditions_selector) do
    condition_settings[i] = {
        yaw_modifier = newDropdown(condition .. " Yaw Modifier", menu_anti_aim_yaw_modifier_values, 1),
        yaw_offset = newSlider(condition .. " Yaw Offset", 0, 0, 180, 1)
    }
end

local menu_anti_aim_yaw_modifier = nil
local menu_anti_aim_yaw_modifier_offset = nil

local function updateActiveSettings()
    local condition_idx = menu_anti_aim_builder_conditions.value
    menu_anti_aim_yaw_modifier = condition_settings[condition_idx].yaw_modifier
    menu_anti_aim_yaw_modifier_offset = condition_settings[condition_idx].yaw_offset
end

local settings_path = get_game_directory() .. "\\nix\\scripts\\singularity.settings"

local function saveSettings()
    local file = io.open(settings_path, "w")
    if file then
        for _, setting in ipairs(settingList) do
            if setting.name then
                if setting.type == "slider" then
                    file:write(setting.name .. "=" .. tostring(setting.value) .. "\n")
                elseif setting.type == "checkbox" then
                    file:write(setting.name .. "=" .. tostring(setting.value) .. "\n")
                    if setting.has_color_picker then
                        file:write(setting.name .. "_color_r=" .. tostring(setting.color_value.r) .. "\n")
                        file:write(setting.name .. "_color_g=" .. tostring(setting.color_value.g) .. "\n")
                        file:write(setting.name .. "_color_b=" .. tostring(setting.color_value.b) .. "\n")
                        file:write(setting.name .. "_color_a=" .. tostring(setting.color_value.a) .. "\n")
                    end
                elseif setting.type == "keybind" then
                    file:write(setting.name .. "=" .. tostring(setting.value) .. "\n")
                    if setting.mode then
                        file:write(setting.name .. "_mode=" .. tostring(setting.mode) .. "\n")
                    end
                elseif setting.type == "dropdown" then
                    file:write(setting.name .. "=" .. tostring(setting.value) .. "\n")
                elseif setting.type == "combobox" then
                    for i, selected in ipairs(setting.value) do
                        file:write(setting.name .. "_" .. i .. "=" .. tostring(selected) .. "\n")
                    end
                end
            end
        end
        file:close()
    end
end

local function loadSettings()
    local file = io.open(settings_path, "r")
    if file then
        for line in file:lines() do
            local name, value = line:match("([^=]+)=([^=]+)")
            for _, setting in ipairs(settingList) do
                if setting.name == name then
                    if setting.type == "slider" then
                        setting.value = tonumber(value)
                    elseif setting.type == "checkbox" then
                        setting.value = value == "true"
                    elseif setting.type == "keybind" then
                        setting.value = tonumber(value) or "none"
                    elseif setting.type == "dropdown" then
                        setting.value = tonumber(value) or 1
                    end
                end
                if setting.type == "keybind" and name == setting.name .. "_mode" then
                    setting.mode = tonumber(value) or 1
                end
                if setting.type == "combobox" then
                    local comboIndex = name:match(setting.name .. "_(%d+)")
                    if comboIndex then
                        comboIndex = tonumber(comboIndex)
                        if comboIndex and comboIndex >= 1 and comboIndex <= #setting.value then
                            setting.value[comboIndex] = value == "true"
                        end
                    end
                end
                if setting.type == "checkbox" and setting.has_color_picker then
                    if name:match(setting.name .. "_color_r$") then
                        setting.color_value.r = tonumber(value) or 1
                    elseif name:match(setting.name .. "_color_g$") then
                        setting.color_value.g = tonumber(value) or 1
                    elseif name:match(setting.name .. "_color_b$") then
                        setting.color_value.b = tonumber(value) or 1
                    elseif name:match(setting.name .. "_color_a$") then
                        setting.color_value.a = tonumber(value) or 1
                    end
                end
            end
        end
        file:close()
    end
    
    if menu_wallbang_helper_file.value > #wallbang_helper_files then
        menu_wallbang_helper_file.value = 1
        print("[Singularity] Wallbang helper file index was out of bounds, reset to 1")
    end

    updateActiveSettings()
end

local function categorizeSettings()
    for tab, _ in pairs(tabSettings) do
        tabSettings[tab] = {}
    end

    table.insert(tabSettings["Anti-Aim"], menu_anti_aim_builder_enabled)
    table.insert(tabSettings["Anti-Aim"], menu_anti_aim_builder_conditions)
    local condition_idx = menu_anti_aim_builder_conditions.value
    table.insert(tabSettings["Anti-Aim"], condition_settings[condition_idx].yaw_modifier)
    table.insert(tabSettings["Anti-Aim"], condition_settings[condition_idx].yaw_offset)
    table.insert(tabSettings["Anti-Aim"], menu_anti_aim_pitch)
    table.insert(tabSettings["Anti-Aim"], menu_random_yaw_enabled)
    table.insert(tabSettings["Anti-Aim"], menu_random_yaw_deviance)
    table.insert(tabSettings["Anti-Aim"], menu_manual_aa_enabled)
    table.insert(tabSettings["Anti-Aim"], menu_manual_right_key)
    table.insert(tabSettings["Anti-Aim"], menu_manual_left_key)
    table.insert(tabSettings["Anti-Aim"], menu_pitch_jitter_enabled)
    table.insert(tabSettings["Anti-Aim"], menu_pitch_jitter_chance)
    table.insert(tabSettings["Anti-Aim"], menu_0_pitch_on_land_enabled)
    table.insert(tabSettings["Anti-Aim"], menu_0_pitch_on_land_duration)
    table.insert(tabSettings["Anti-Aim"], menu_air_flick_enabled)
    table.insert(tabSettings["Anti-Aim"], menu_air_flick_trigger_rate)
    
    table.insert(tabSettings["Rage"], menu_default_min_dmg)
    table.insert(tabSettings["Rage"], menu_default_override_min_dmg_key)
    table.insert(tabSettings["Rage"], menu_default_override_min_dmg)

    table.insert(tabSettings["Rage"], menu_ai_peek_enabled)
    table.insert(tabSettings["Rage"], menu_ai_peek_key)
    table.insert(tabSettings["Rage"], menu_ai_peek_offset)
    table.insert(tabSettings["Rage"], menu_ai_peek_limit)

    table.insert(tabSettings["Rage"], menu_duck_peek_assist_enabled)
    table.insert(tabSettings["Rage"], menu_duck_peek_assist_key)

    table.insert(tabSettings["Rage"], menu_wallbang_helper_enabled)
    table.insert(tabSettings["Rage"], menu_wallbang_helper_minimum_distance_to_draw)
    table.insert(tabSettings["Rage"], menu_wallbang_helper_file)
    
    table.insert(tabSettings["Rage"], menu_disable_ragebot_in_air_enabled)
    table.insert(tabSettings["Rage"], menu_adaptive_auto_strafer_enabled)
    table.insert(tabSettings["Rage"], menu_buybot)
    table.insert(tabSettings["Rage"], menu_buybot_selector)
    table.insert(tabSettings["Rage"], menu_killsay_enabled)
    
    table.insert(tabSettings["Misc"], menu_custom_menu_color_enabled)
    table.insert(tabSettings["Misc"], menu_thirdperson_distance)
    table.insert(tabSettings["Misc"], menu_fov_value)
    table.insert(tabSettings["Misc"], menu_local_player_glow_enabled)
    table.insert(tabSettings["Misc"], menu_preserve_killfeed)
    table.insert(tabSettings["Misc"], menu_slowdown_indicator)
    table.insert(tabSettings["Misc"], menu_hitlogs_enabled)
    table.insert(tabSettings["Misc"], menu_bullet_tracers_enabled)
    table.insert(tabSettings["Misc"], menu_bullet_tracers_size)
    table.insert(tabSettings["Misc"], menu_bullet_tracers_time)
    table.insert(tabSettings["Misc"], menu_firstperson_on_utilities)
    table.insert(tabSettings["Misc"], menu_watermark_enabled)
    table.insert(tabSettings["Misc"], menu_watermark_style)
    table.insert(tabSettings["Misc"], menu_custom_scope_enabled)
    table.insert(tabSettings["Misc"], menu_custom_scope_offset)
    table.insert(tabSettings["Misc"], menu_custom_scope_length)
    table.insert(tabSettings["Misc"], menu_indicators)
    table.insert(tabSettings["Misc"], menu_auto_thirdperson_spectate_enabled)
end

local menu_prev_condition = 1
local function handleConditionChange()
    local menu_current_condition = menu_anti_aim_builder_conditions.value
    if menu_current_condition ~= menu_prev_condition then
        categorizeSettings()
        updateActiveSettings()
        menu_prev_condition = menu_current_condition
    end
end

register_callback("paint", function()
    handleConditionChange()
end)

local VK = {INSERT = 0x2D, LBUTTON = 0x01, RBUTTON = 0x02, UP = 0x26, DOWN = 0x28, PRIOR = 0x21, NEXT = 0x22}
local prev = {insert = false, mouse = false, right_mouse = false}

local function renderGui()
    local insert_down = is_key_pressed(VK.INSERT)
    if insert_down and not prev.insert then gui.isOpen = not gui.isOpen end
    prev.insert = insert_down
    
    gui.alpha = lerp(gui.alpha, gui.isOpen and 1 or 0, render.frame_time() * 10)
    
    if gui.alpha <= 0 then 
        engine.execute_client_cmd("bind MOUSE1 +attack") 
        engine.execute_client_cmd("bind MOUSE2 +attack2")
        return 
    end
    
    if not gui.isOpen then 
        engine.execute_client_cmd("bind MOUSE1 +attack") 
        engine.execute_client_cmd("bind MOUSE2 +attack2")
        return 
    end
    
    check_keys()
    
    gui.width = lerp(gui.width, gui.targetWidth, render.frame_time() * 10)
    gui.height = lerp(gui.height, gui.targetHeight, render.frame_time() * 10)
    
    local mouse = {
        pos = get_mouse_pos(), 
        down = is_key_pressed(VK.LBUTTON), 
        click = false,
        right_down = is_key_pressed(VK.RBUTTON),
        right_click = false
    }
    mouse.click = mouse.down and not prev.mouse
    mouse.right_click = mouse.right_down and not prev.right_mouse
    
    local isMouseOverMenu = mouse.pos.x >= gui.x and mouse.pos.x <= gui.x + gui.width and mouse.pos.y >= gui.y and mouse.pos.y <= gui.y + gui.height
    if isMouseOverMenu then engine.execute_client_cmd("unbind mouse1") else engine.execute_client_cmd("bind MOUSE1 +attack") end
    if isMouseOverMenu then 
        engine.execute_client_cmd("unbind mouse1")
        engine.execute_client_cmd("unbind mouse2")
    else 
        engine.execute_client_cmd("bind MOUSE1 +attack") 
        engine.execute_client_cmd("bind MOUSE2 +attack2") 
    end
    
    if mouse.click and isMouseOverMenu and mouse.pos.y <= gui.y + 30 then
        gui.isDragging = true
        gui.dragOffset.x = mouse.pos.x - gui.x
        gui.dragOffset.y = mouse.pos.y - gui.y
    end
    
    if not mouse.down then 
        gui.isDragging = false 
    end
    
    if gui.isDragging then
        gui.x = mouse.pos.x - gui.dragOffset.x
        gui.y = mouse.pos.y - gui.dragOffset.y
    end
    
    prev.mouse = mouse.down
    prev.right_mouse = mouse.right_down
    
    local background_color = color_t(24/255, 24/255, 24/255, gui.alpha)
    local outline_color = menu_accents_color
    
    render.rect_filled(vec2_t(gui.x, gui.y), vec2_t(gui.x + gui.width, gui.y + gui.height), background_color, 8)
    render.rect(vec2_t(gui.x, gui.y), vec2_t(gui.x + gui.width, gui.y + gui.height), outline_color, 8, 0)

    local title_text = "~ Singularity.lua ~"
    local title_size = render.calc_text_size(title_text, titleFont)
    render.text(title_text, titleFont, vec2_t(gui.x + (gui.width - title_size.x) / 2, gui.y + 10), color_t(1, 1, 1, gui.alpha))
    
    local tabWidth = 86.6
    local tabHeight = 25
    local tabX = gui.x + 10
    local tabY = gui.y + 40
    local tabs = {"Anti-Aim", "Rage", "Misc"}
    
    for i, tab in ipairs(tabs) do
        local tab_background_color = gui.currentTab == tab and outline_color or color_t(34/255, 34/255, 34/255, gui.alpha)
        render.rect_filled(
            vec2_t(tabX + (i-1) * (tabWidth + 10), tabY), 
            vec2_t(tabX + (i-1) * (tabWidth + 10) + tabWidth, tabY + tabHeight), 
            tab_background_color, 
            4
        )
        
        render.text(
            tab, 
            font14, 
            vec2_t(tabX + (i-1) * (tabWidth + 10) + tabWidth/2 - render.calc_text_size(tab, font14).x/2, tabY + 5), 
            color_t(1, 1, 1, gui.alpha)
        )
        
        if mouse.click and 
           mouse.pos.x >= tabX + (i-1) * (tabWidth + 10) and 
           mouse.pos.x <= tabX + (i-1) * (tabWidth + 10) + tabWidth and
           mouse.pos.y >= tabY and 
           mouse.pos.y <= tabY + tabHeight then
            gui.currentTab = tab
        end
    end
    
    local activeDropdownInfo = nil
    local y = gui.y + 90
    local isOverControl = false
    local isClickBlockedByDropdown = false

    if gui.activeDropdown then
        local setting = gui.activeDropdown
        local dropX, dropY
        
        if setting.type == "dropdown" then
            dropX = gui.x + gui.width - 80
            local dropWidth = 72
            dropY = 0
            
            local tempY = gui.y + 90
            for _, s in ipairs(tabSettings[gui.currentTab]) do
                if s == setting then
                    dropY = tempY
                    break
                end
                tempY = tempY + 28
            end
            
            if mouse.click and
                mouse.pos.x >= dropX and 
                mouse.pos.x <= dropX + dropWidth and
                mouse.pos.y >= dropY + 18 and
                mouse.pos.y <= dropY + 18 + (#setting.values * 20) then
                isClickBlockedByDropdown = true
            end
        elseif setting.type == "keybind" then
            dropX = gui.x + gui.width - 60 + 20
            local dropWidth = 60
            dropY = 0
            
            local tempY = gui.y + 90
            for _, s in ipairs(tabSettings[gui.currentTab]) do
                if s == setting then
                    dropY = tempY
                    break
                end
                tempY = tempY + 28
            end
            
            if mouse.click and
                mouse.pos.x >= dropX and 
                mouse.pos.x <= dropX + dropWidth and
                mouse.pos.y >= dropY + 18 and
                mouse.pos.y <= dropY + 18 + (#gui.dropdownOptions * 20) then
                isClickBlockedByDropdown = true
            end
        end
    end

    y = gui.y + 90
    
    for _, setting in ipairs(settingList) do
        local is_open_picker = (setting.type == "checkbox" and setting.has_color_picker and setting.is_color_open)

        if is_open_picker then
            local picker_pos = setting.picker_pos
            local picker_size = vec2_t(150, 150)
            local bar_width = 20
            local bar_pos = picker_pos + vec2_t(picker_size.x + 5, 0)
            
            setting.picker_alpha = lerp(setting.picker_alpha, 1, render.frame_time() * 10)
            
            render.rect_filled(picker_pos, picker_pos + picker_size, color_t(0.1, 0.1, 0.1, setting.picker_alpha), 4)
            
            for x = 0, picker_size.x, 2 do
                for y = 0, picker_size.y, 2 do
                    local saturation = x / picker_size.x
                    local value = 1 - (y / picker_size.y)
                    local color = color_from_hsv(setting.hue, saturation, value, setting.picker_alpha)
                    render.rect_filled(picker_pos + vec2_t(x, y), picker_pos + vec2_t(x + 2, y + 2), color, 1)
                end
            end

            local alpha_slider_height = 15
            local alpha_slider_y = picker_pos.y + picker_size.y + 5
            local alpha_slider_width = picker_size.x
            
            render.rect_filled(
                vec2_t(picker_pos.x, alpha_slider_y),
                vec2_t(picker_pos.x + alpha_slider_width, alpha_slider_y + alpha_slider_height),
                color_t(0.1, 0.1, 0.1, setting.picker_alpha),
                2
            )
            
            for x = 0, alpha_slider_width, 2 do
                local alpha_value = x / alpha_slider_width
                local current_color = color_t(
                    setting.color_value.r, 
                    setting.color_value.g, 
                    setting.color_value.b, 
                    alpha_value
                )
                render.rect_filled(
                    vec2_t(picker_pos.x + x, alpha_slider_y),
                    vec2_t(picker_pos.x + x + 2, alpha_slider_y + alpha_slider_height),
                    current_color,
                    0
                )
            end
            
            local alpha_handle_pos = picker_pos.x + (setting.color_value.a * alpha_slider_width)
            render.rect_filled(
                vec2_t(alpha_handle_pos - 2, alpha_slider_y - 2),
                vec2_t(alpha_handle_pos + 2, alpha_slider_y + alpha_slider_height + 2),
                color_t(1, 1, 1, setting.picker_alpha),
                2
            )
            
            if mouse.down then
                if mouse.pos.x >= picker_pos.x and mouse.pos.x <= picker_pos.x + alpha_slider_width and
                   mouse.pos.y >= alpha_slider_y and mouse.pos.y <= alpha_slider_y + alpha_slider_height then
                    local alpha_value = (mouse.pos.x - picker_pos.x) / alpha_slider_width
                    setting.color_value.a = clamp(alpha_value, 0, 1)
                end
            end
            
            render.rect_filled(bar_pos, bar_pos + vec2_t(bar_width, picker_size.y), color_t(0.1, 0.1, 0.1, setting.picker_alpha), 4)
            for y = 0, picker_size.y, 2 do
                local hue = y / picker_size.y
                local color = color_from_hsv(hue, 1, 1, setting.picker_alpha)
                render.rect_filled(bar_pos + vec2_t(0, y), bar_pos + vec2_t(bar_width, y + 2), color, 1)
            end
            
            if mouse.down then
                if mouse.pos.x >= picker_pos.x and mouse.pos.x <= picker_pos.x + picker_size.x and
                  mouse.pos.y >= picker_pos.y and mouse.pos.y <= picker_pos.y + picker_size.y then
                    local x = mouse.pos.x - picker_pos.x
                    local y = mouse.pos.y - picker_pos.y
                    local saturation = x / picker_size.x
                    local value = 1 - (y / picker_size.y)
                    
                    local new_color = color_from_hsv(setting.hue, saturation, value, 1)
                    
                    setting.color_value.r = new_color.r
                    setting.color_value.g = new_color.g
                    setting.color_value.b = new_color.b
                    setting.color_value.a = 1
                    
                    setting.last_selected_color_pos = vec2_t(mouse.pos.x, mouse.pos.y)
                elseif mouse.pos.x >= bar_pos.x and mouse.pos.x <= bar_pos.x + bar_width and
                       mouse.pos.y >= bar_pos.y and mouse.pos.y <= bar_pos.y + picker_size.y then
                    local y = mouse.pos.y - picker_pos.y
                    setting.hue = y / picker_size.y
                end
            end
            
            if setting.last_selected_color_pos then
                local constrained_pos = vec2_t(
                    clamp(setting.last_selected_color_pos.x, picker_pos.x, picker_pos.x + picker_size.x),
                    clamp(setting.last_selected_color_pos.y, picker_pos.y, picker_pos.y + picker_size.y)
                )
                render.circle_filled(constrained_pos, 4, 32, color_t(1, 1, 1, setting.picker_alpha))
                
                local x = setting.last_selected_color_pos.x - picker_pos.x
                local y = setting.last_selected_color_pos.y - picker_pos.y
                local saturation = x / picker_size.x
                local value = 1 - (y / picker_size.y)
                
                local new_color = color_from_hsv(setting.hue, saturation, value, 1)
                setting.color_value.r = new_color.r
                setting.color_value.g = new_color.g
                setting.color_value.b = new_color.b
                --setting.color_value.a = 1
            end
            
            local selected_hue_pos = vec2_t(
                bar_pos.x + bar_width / 2,
                picker_pos.y + (setting.hue * picker_size.y)
            )
            
            render.filled_polygon({
                selected_hue_pos + vec2_t(-5, 0),
                selected_hue_pos + vec2_t(5, 0),
                selected_hue_pos + vec2_t(0, 10)
            }, color_t(1, 1, 1, setting.picker_alpha))
            
            local reset_button_width = picker_size.x + 2
            local reset_button_height = 20
            local reset_button_x = picker_pos.x
            local reset_button_y = picker_pos.y - reset_button_height - 5
            
            render.rect_filled(
                vec2_t(reset_button_x, reset_button_y),
                vec2_t(reset_button_x + reset_button_width, reset_button_y + reset_button_height),
                color_t(1, 1, 1, setting.picker_alpha),
                0
            )
            
            render.rect(
                vec2_t(reset_button_x, reset_button_y),
                vec2_t(reset_button_x + reset_button_width, reset_button_y + reset_button_height),
                color_t(0, 0, 0, setting.picker_alpha),
                0,
                2
            )
            
            local reset_text = "Reset"
            local reset_text_size = render.calc_text_size(reset_text, font14)
            render.text(
                reset_text, 
                font14, 
                vec2_t(
                    reset_button_x + (reset_button_width - reset_text_size.x) / 2, 
                    reset_button_y + (reset_button_height - reset_text_size.y) / 2
                ), 
                color_t(0, 0, 0, setting.picker_alpha)
            )
            
            if mouse.click and
               mouse.pos.x >= reset_button_x and
               mouse.pos.x <= reset_button_x + reset_button_width and
               mouse.pos.y >= reset_button_y and
               mouse.pos.y <= reset_button_y + reset_button_height then
               
                setting.color_value = color_t(161/255, 110/255, 228/255, 1)

                if setting == menu_custom_menu_color_enabled then
                    menu_accents_color = setting.color_value
                end
                
                local r, g, b = menu_accents_color.r, menu_accents_color.g, menu_accents_color.b
                local max = math.max(r, g, b)
                local min = math.min(r, g, b)
                local delta = max - min
                
                local h = 0
                if max == r then
                    h = ((g - b) / delta) % 6
                elseif max == g then
                    h = (b - r) / delta + 2
                elseif max == b then
                    h = (r - g) / delta + 4
                end
                h = h / 6
                
                local s = max == 0 and 0 or delta / max
                local v = max
                
                setting.hue = h
                setting.last_selected_color_pos = vec2_t(
                    picker_pos.x + (s * picker_size.x),
                    picker_pos.y + ((1 - v) * picker_size.y)
                )
                
                isOverControl = true
            end
            
            local isClickingOnResetButton = mouse.click and
            mouse.pos.x >= reset_button_x and
            mouse.pos.x <= reset_button_x + reset_button_width and
            mouse.pos.y >= reset_button_y and
            mouse.pos.y <= reset_button_y + reset_button_height;

            if mouse.click and not isClickingOnResetButton and
                (mouse.pos.x < picker_pos.x - 5 or mouse.pos.x > bar_pos.x + bar_width + 5 or
                 mouse.pos.y < picker_pos.y - reset_button_height - 10 or 
                 mouse.pos.y > alpha_slider_y + alpha_slider_height + 5) then
                setting.is_color_open = false
            end
        end
    end

    for _, setting in ipairs(tabSettings[gui.currentTab]) do
        if setting.type == "text" then
            local usedFont = setting.font or font14
            local textColor = setting.color or color_t(1, 1, 1, gui.alpha)
            local textWidth = render.calc_text_size(setting.text, usedFont).x
            local xPos = gui.x + 8
            
            if setting.align and setting.align == "center" then
                xPos = gui.x + (gui.width - textWidth) / 2
            end
            
            render.text(setting.text, usedFont, vec2_t(xPos, y), textColor)
            
        elseif setting.type == "checkbox" then
            render.text(setting.name, font14, vec2_t(gui.x + 25, y), color_t(1, 1, 1, gui.alpha)) 
            local boxX, boxY = gui.x + 8, y 
            local boxColor = setting.value and outline_color or color_t(34/255, 34/255, 34/255, 1)
            
            render.rect_filled(vec2_t(boxX, boxY), vec2_t(boxX + 12, boxY + 12), boxColor, 0)
            
            if mouse.click and 
               mouse.pos.x >= boxX and 
               mouse.pos.x <= boxX + 12 and 
               mouse.pos.y >= boxY and 
               mouse.pos.y <= boxY + 12 then
                setting.value = not setting.value
                isOverControl = true
            end
            
            if setting.has_color_picker then
                local colorBoxX = gui.x + gui.width - 30
                local colorBoxSize = 15
                
                render.rect_filled(
                    vec2_t(colorBoxX, boxY),
                    vec2_t(colorBoxX + colorBoxSize, boxY + colorBoxSize),
                    setting.color_value,
                    3
                )
                
                render.rect(
                    vec2_t(colorBoxX, boxY),
                    vec2_t(colorBoxX + colorBoxSize, boxY + colorBoxSize),
                    color_t(0, 0, 0, gui.alpha),
                    3,
                    1
                )
                
                if mouse.click and
                   mouse.pos.x >= colorBoxX and
                   mouse.pos.x <= colorBoxX + colorBoxSize and
                   mouse.pos.y >= boxY and
                   mouse.pos.y <= boxY + colorBoxSize then
                   
                    setting.is_color_open = not setting.is_color_open
                    
                    setting.picker_pos = vec2_t(
                        gui.x + gui.width + 10,
                        y
                    )
                    
                    if setting.is_color_open then
                        local picker_size = vec2_t(150, 150)
                        local r, g, b = setting.color_value.r, setting.color_value.g, setting.color_value.b
                        local max = math.max(r, g, b)
                        local min = math.min(r, g, b)
                        local delta = max - min
                        
                        local h = 0
                        if delta > 0 then
                            if max == r then
                                h = ((g - b) / delta) % 6
                            elseif max == g then
                                h = (b - r) / delta + 2
                            elseif max == b then
                                h = (r - g) / delta + 4
                            end
                            h = h / 6
                        end
                        
                        local s = max == 0 and 0 or delta / max
                        local v = max
                        
                        setting.hue = h
                        setting.last_selected_color_pos = vec2_t(
                            setting.picker_pos.x + (s * picker_size.x),
                            setting.picker_pos.y + ((1 - v) * picker_size.y)
                        )
                    end

                    for _, s in ipairs(settingList) do
                        if s ~= setting and ((s.type == "checkbox" and s.has_color_picker) or s.type == "colorpicker") then
                            s.is_color_open = false
                        end
                    end
                    
                    isOverControl = true
                end
            end
            
        elseif setting.type == "keybind" then
            render.text(setting.name, font14, vec2_t(gui.x + 8, y), color_t(1, 1, 1, gui.alpha))
            local bindX, bindY = gui.x + gui.width - 60, y
            
            render.rect_filled(
                vec2_t(bindX, bindY), 
                vec2_t(bindX + 52, bindY + 12),
                color_t(34/255, 34/255, 34/255, 1), 
                0
            )
            
            local text = gui.waitingForKey and setting == gui.activeKeybind and "..." or 
                        (setting.value == "none" and "none" or get_key_name(setting.value))
            
            render.text(
                text, 
                font14, 
                vec2_t(bindX + 26 - render.calc_text_size(text, font14).x/2, y), 
                color_t(1, 1, 1, gui.alpha)
            )
            
            if not isClickBlockedByDropdown and 
                mouse.click and 
                mouse.pos.x >= bindX and 
                mouse.pos.x <= bindX + 52 and 
                mouse.pos.y >= bindY and 
                mouse.pos.y <= bindY + 12 then
                    if mouse.click and 
                        mouse.pos.x >= bindX and 
                        mouse.pos.x <= bindX + 52 and 
                        mouse.pos.y >= bindY and 
                        mouse.pos.y <= bindY + 12 then
                        gui.waitingForKey = true
                        gui.activeKeybind = setting
                        gui.activeDropdown = nil
                        isOverControl = true
                    end
            end

            if not isClickBlockedByDropdown and 
                mouse.right_click and 
                mouse.pos.x >= bindX and 
                mouse.pos.x <= bindX + 52 and 
                mouse.pos.y >= bindY and 
                mouse.pos.y <= bindY + 12 then
                    if mouse.right_click and 
                        mouse.pos.x >= bindX and 
                        mouse.pos.x <= bindX + 52 and 
                        mouse.pos.y >= bindY and 
                        mouse.pos.y <= bindY + 12 then
                    if gui.activeDropdown == setting then
                        gui.activeDropdown = nil
                    else
                        gui.activeDropdown = setting
                        gui.waitingForKey = false
                        gui.activeKeybind = nil
                    end
                    isOverControl = true
                    end
            end
            
            if gui.activeDropdown == setting then
                activeDropdownInfo = {
                    setting = setting,
                    x = bindX,
                    y = bindY
                }
            end
            
        elseif setting.type == "slider" then
            local function round_increment(value, increment)
                return math.floor(value / increment + 0.5) * increment
            end
            
            local function round_display(value, increment)
                if increment >= 1 then
                    return tostring(math.floor(value + 0.5))
                else
                    local decimals = math.abs(math.floor(math.log10(increment)))
                    return string.format("%." .. decimals .. "f", value)
                end
            end
            
            render.text(setting.name, font14, vec2_t(gui.x + 8, y), color_t(1, 1, 1, gui.alpha))
            
            local sliderX, sliderY = gui.x + gui.width - 170, y
            local sliderWidth = 130
            
            render.rect_filled(
                vec2_t(sliderX, sliderY), 
                vec2_t(sliderX + sliderWidth, sliderY + 12), 
                color_t(34/255, 34/255, 34/255, 1), 
                3
            )
            
            local progress = (setting.value - setting.minValue) / (setting.maxValue - setting.minValue)
        
            if progress > 0 then
                local min_width_for_corners = 6
                local fill_width = math.max(min_width_for_corners, sliderWidth * progress)
                
                if progress > 0.97 then
                    fill_width = sliderWidth
                end
                
                render.rect_filled(
                    vec2_t(sliderX, sliderY), 
                    vec2_t(sliderX + fill_width, sliderY + 12), 
                    outline_color, 
                    3
                )
            end
        
            local inputX = sliderX + sliderWidth + 5

            if mouse.down and 
                mouse.pos.x >= sliderX and 
                mouse.pos.x <= sliderX + sliderWidth and
                mouse.pos.y >= sliderY and 
                mouse.pos.y <= sliderY + 12 and
                gui.activeInputBox ~= setting then
                local t = clamp((mouse.pos.x - sliderX) / sliderWidth, 0, 1)
                
                local raw_value = lerp(setting.minValue, setting.maxValue, t)
                
                local increments = (setting.maxValue - setting.minValue) / setting.increment
                local step_index = math.floor(t * increments + 0.5)
                local precise_value = setting.minValue + (step_index * setting.increment)
                
                setting.value = clamp(precise_value, setting.minValue, setting.maxValue)
                
                if t < 0.01 then
                    setting.value = setting.minValue
                elseif t > 0.99 then
                    setting.value = setting.maxValue
            end
    
    isOverControl = true
end
            
            local inputX = sliderX + sliderWidth + 5
            local inputWidth = 30
            local inputColor = gui.activeInputBox == setting and outline_color or color_t(34/255, 34/255, 34/255, 1)
            
            render.rect_filled(
                vec2_t(inputX, sliderY), 
                vec2_t(inputX + inputWidth, sliderY + 12), 
                color_t(20/255, 20/255, 20/255, 1), 
                3
            )
            
            render.rect(
                vec2_t(inputX, sliderY), 
                vec2_t(inputX + inputWidth, sliderY + 12), 
                inputColor, 
                3,
                1
            )
            
            local displayText = gui.activeInputBox == setting and gui.inputBuffer or round_display(setting.value, setting.increment)
            render.text(
                displayText, 
                font14, 
                vec2_t(inputX + inputWidth/2 - render.calc_text_size(displayText, font14).x/2, sliderY), 
                color_t(1, 1, 1, gui.alpha)
            )
            
            if mouse.click and 
                mouse.pos.x >= inputX and 
                mouse.pos.x <= inputX + inputWidth and
                mouse.pos.y >= sliderY and 
                mouse.pos.y <= sliderY + 12 then
                if gui.activeInputBox ~= setting then
                    gui.activeInputBox = setting
                    gui.originalInputValue = tostring(setting.value)
                    gui.inputBuffer = ""
                    gui.isTyping = true
                end
                isOverControl = true
            elseif mouse.click and gui.activeInputBox == setting then
                local number = tonumber(gui.inputBuffer)
                if number then
                    number = round_increment(number, setting.increment)
                    setting.value = clamp(number, setting.minValue, setting.maxValue)
                elseif gui.inputBuffer == "" then
                    setting.value = tonumber(gui.originalInputValue)
                end
                gui.activeInputBox = nil
                gui.isTyping = false
            end
        
            function handle_keyboard_input()
                if not gui.activeInputBox or not gui.isTyping then return end
                
                for key = 0x30, 0x39 do -- Numbers 0-9
                    if is_key_pressed(key) and not key_states[key] then
                        gui.inputBuffer = gui.inputBuffer .. string.char(key)
                        key_states[key] = true
                    elseif not is_key_pressed(key) then
                        key_states[key] = false
                    end
                end
                
                if is_key_pressed(0xBE) and not key_states[0xBE] then
                    if not gui.inputBuffer:find("%.") then
                        gui.inputBuffer = gui.inputBuffer .. "."
                    end
                    key_states[0xBE] = true
                elseif not is_key_pressed(0xBE) then
                    key_states[0xBE] = false
                end
                
                if is_key_pressed(0xBD) and not key_states[0xBD] then
                    if #gui.inputBuffer == 0 then
                        gui.inputBuffer = "-"
                    end
                    key_states[0xBD] = true
                elseif not is_key_pressed(0xBD) then
                    key_states[0xBD] = false
                end
                
                -- Backspace
                if is_key_pressed(0x08) and not key_states[0x08] then
                    gui.inputBuffer = gui.inputBuffer:sub(1, -2)
                    key_states[0x08] = true
                elseif not is_key_pressed(0x08) then
                    key_states[0x08] = false
                end
                
                -- Enter
                if is_key_pressed(0x0D) and not key_states[0x0D] then
                    local number = tonumber(gui.inputBuffer)
                    if number then
                        gui.activeInputBox.value = clamp(number, gui.activeInputBox.minValue, gui.activeInputBox.maxValue)
                    elseif gui.inputBuffer == "" then
                        gui.activeInputBox.value = tonumber(gui.originalInputValue)
                    end
                    gui.activeInputBox = nil
                    gui.isTyping = false
                    key_states[0x0D] = true
                elseif not is_key_pressed(0x0D) then
                    key_states[0x0D] = false
                end
                
                -- Escape
                if is_key_pressed(0x1B) and not key_states[0x1B] then
                    gui.activeInputBox = nil
                    gui.isTyping = false
                    key_states[0x1B] = true
                elseif not is_key_pressed(0x1B) then
                    key_states[0x1B] = false
                end
            end
        elseif setting.type == "combobox" then
            render.text(setting.name, font14, vec2_t(gui.x + 8, y), color_t(1, 1, 1, gui.alpha))
        
            local boxX, boxY = gui.x + gui.width - 108, y
            local boxWidth = 100
        
            render.rect_filled(
                vec2_t(boxX, boxY), 
                vec2_t(boxX + boxWidth, boxY + 18),
                color_t(34/255, 34/255, 34/255, 1), 
                3
            )
        
            local selected_text = ""
            local selected_count = 0
            for i, selected in ipairs(setting.value) do
                if selected then
                    if selected_count > 0 then
                        selected_text = selected_text .. ", "
                    end
                    selected_text = selected_text .. setting.values[i]:sub(1, 3)
                    selected_count = selected_count + 1
                end
            end
            
            if selected_count == 0 then
                selected_text = "None"
            elseif selected_count > 2 then
                selected_text = selected_count .. " selected"
            end
        
            if render.calc_text_size(selected_text, font14).x > boxWidth - 20 then
                selected_text = selected_count .. " selected"
            end
        
            render.text(
                selected_text, 
                font14, 
                vec2_t(boxX + 5, boxY + 3), 
                color_t(1, 1, 1, gui.alpha)
            )
        
            render.text(
                "^", 
                font16, 
                vec2_t(boxX + boxWidth - 15, boxY + 3), 
                color_t(1, 1, 1, gui.alpha)
            )
        
            if not isClickBlockedByDropdown and 
               mouse.click and 
               mouse.pos.x >= boxX and 
               mouse.pos.x <= boxX + boxWidth and
               mouse.pos.y >= boxY and 
               mouse.pos.y <= boxY + 18 then
                if gui.activeDropdown == setting then
                    gui.activeDropdown = nil
                else
                    gui.activeDropdown = setting
                    gui.waitingForKey = false
                    gui.activeKeybind = nil
                end
                isOverControl = true
            end
        
            if gui.activeDropdown == setting then
                activeDropdownInfo = {
                    setting = setting,
                    x = boxX,
                    y = boxY
                }
            end
        elseif setting.type == "dropdown" then
            render.text(setting.name, font14, vec2_t(gui.x + 8, y), color_t(1, 1, 1, gui.alpha))
        
            local dropX, dropY = gui.x + gui.width - 108, y
            local dropWidth = 100
        
            render.rect_filled(
                vec2_t(dropX, dropY), 
                vec2_t(dropX + dropWidth, dropY + 18),
                color_t(34/255, 34/255, 34/255, 1), 
                3
            )
        
            local selectedText = setting.values[setting.value] or "Select"
            render.text(
                selectedText, 
                font14, 
                vec2_t(dropX + 5, dropY + 3), 
                color_t(1, 1, 1, gui.alpha)
            )
        
            render.text(
                "^", 
                font16, 
                vec2_t(dropX + dropWidth - 15, dropY + 3), 
                color_t(1, 1, 1, gui.alpha)
            )

            if not isClickBlockedByDropdown and 
               mouse.click and 
               mouse.pos.x >= dropX and 
               mouse.pos.x <= dropX + dropWidth and
               mouse.pos.y >= dropY and 
               mouse.pos.y <= dropY + 18 then
                if mouse.click and 
               mouse.pos.x >= dropX and 
               mouse.pos.x <= dropX + dropWidth and
               mouse.pos.y >= dropY and 
               mouse.pos.y <= dropY + 18 then
                if gui.activeDropdown == setting then
                    gui.activeDropdown = nil
                else
                    gui.activeDropdown = setting
                    gui.waitingForKey = false
                    gui.activeKeybind = nil
                end
                isOverControl = true
            end
            end

            if gui.activeDropdown == setting then
                activeDropdownInfo = {
                    setting = setting,
                    x = dropX,
                    y = dropY
                }
            end
        end
        y = y + 28
    end
    
    if activeDropdownInfo then
        local dropdownX = activeDropdownInfo.x
        local dropdownY = activeDropdownInfo.y + 18
        local dropdownWidth = 100
        local setting = activeDropdownInfo.setting
        
        if setting.type == "keybind" then
            dropdownX = activeDropdownInfo.x + 20
            dropdownWidth = 80
            local dropdownHeight = #gui.dropdownOptions * 20
            
            render.rect_filled(
                vec2_t(dropdownX, dropdownY),
                vec2_t(dropdownX + dropdownWidth, dropdownY + dropdownHeight),
                color_t(24/255, 24/255, 24/255, 1),
                4
            )
            
            for i, option in ipairs(gui.dropdownOptions) do
                local optionY = dropdownY + (i-1) * 20
                local isSelected = activeDropdownInfo.setting.mode == i
                
                if isSelected then
                    render.rect_filled(
                        vec2_t(dropdownX + 2, optionY + 2),
                        vec2_t(dropdownX + dropdownWidth - 2, optionY + 18),
                        color_t(outline_color.r, outline_color.g, outline_color.b, 0.5),
                        2
                    )
                end
                
                render.text(
                    option,
                    font14,
                    vec2_t(dropdownX + 10, optionY + 4),
                    color_t(1, 1, 1, 1)
                )
                
                if mouse.click and 
                    mouse.pos.x >= dropdownX and
                    mouse.pos.x <= dropdownX + dropdownWidth and
                    mouse.pos.y >= optionY and
                    mouse.pos.y <= optionY + 20 then
                    activeDropdownInfo.setting.mode = i
                    gui.activeDropdown = nil
                end
            end
        else
            local dropdownHeight = #setting.values * 20
            
            render.rect_filled(
                vec2_t(dropdownX, dropdownY),
                vec2_t(dropdownX + dropdownWidth, dropdownY + dropdownHeight),
                color_t(24/255, 24/255, 24/255, 1),
                4
            )
            
            for i, option in ipairs(setting.values) do
                local optionY = dropdownY + (i-1) * 20
                local isSelected = setting.value == i
                
                if setting.type == "dropdown" then
                    isSelected = setting.value == i
                elseif setting.type == "combobox" then
                    isSelected = setting.value[i]
                end

                if isSelected then
                    render.rect_filled(
                        vec2_t(dropdownX + 2, optionY + 2),
                        vec2_t(dropdownX + dropdownWidth - 2, optionY + 18),
                        color_t(outline_color.r, outline_color.g, outline_color.b, 0.5),
                        2
                    )
                end
                
                render.text(
                    option,
                    font14,
                    vec2_t(dropdownX + 10, optionY + 4),
                    color_t(1, 1, 1, 1)
                )
                
                if mouse.click and 
                    mouse.pos.x >= dropdownX and
                    mouse.pos.x <= dropdownX + dropdownWidth and
                    mouse.pos.y >= optionY and
                    mouse.pos.y <= optionY + 20 then
                    if setting.type == "dropdown" then
                        setting.value = i
                        gui.activeDropdown = nil
                    elseif setting.type == "combobox" then
                        setting.value[i] = not setting.value[i]
                    end
                end
            end
        end
    end
end

categorizeSettings()
register_callback("paint", renderGui)

local prev_on_ground = true
local in_air = false
local just_landed = false
local is_crouching = false
local is_walking = false
local is_standing = false

local current_state = "unknown"

local FL_ONGROUND = bit.lshift(1, 0)
local FL_DUCKING = bit.lshift(1, 1)

local state_font = render.setup_font("C:/windows/fonts/verdana.ttf", 18, 600)

local function check_player_state()
    local player_controller = entitylist.get_local_player_controller()
    if not player_controller then return end
    
    local pawn = player_controller.m_hPlayerPawn
    if not pawn then return end
    
    local flags = pawn.m_fFlags
    local velocity = pawn.m_vecAbsVelocity
    local vel_length_2d = math.sqrt(velocity.x * velocity.x + velocity.y * velocity.y)
    
    local on_ground = bit.band(flags, FL_ONGROUND) ~= 0
    in_air = not on_ground
    just_landed = not prev_on_ground and on_ground
    prev_on_ground = on_ground
    
    is_crouching = bit.band(flags, FL_DUCKING) ~= 0
    
    if on_ground then
        is_walking = vel_length_2d > 0
        is_standing = vel_length_2d == 0 and not is_crouching
    else
        is_walking = false
        is_standing = false
    end
    
    if just_landed then
        current_state = "landed"
    elseif in_air then
        current_state = "air"
        if is_crouching then
            current_state = "air_duck"
        end
    elseif is_crouching then
        if is_walking then
            current_state = "crouch_walk"
        else
            current_state = "crouch"
        end
    elseif is_walking then
        current_state = "walk"
    elseif is_standing then
        current_state = "stand"
    else
        current_state = "unknown"
    end
end

local function get_random_yaw()
    if math.random(0, 1) == 0 then
        return math.random(-180, -180+menu_random_yaw_deviance.value)
    else
        return math.random(180-menu_random_yaw_deviance.value, 180)
    end
end

local state_to_condition_map = {
    ["stand"] = 1,
    ["walk"] = 2,
    ["air"] = 3,
    ["crouch"] = 4,
    ["air_duck"] = 5,
    ["crouch_walk"] = 6,
}

local manuals_toggle = nil 
local last_left_state = false
local last_right_state = false

local last_manuals_toggle = nil
local pitch_needs_reset = false

spin_prev_offset = 0

local function anti_aim_handler()
    if menu_anti_aim_builder_enabled.value then
        local condition_idx = state_to_condition_map[current_state] or 1
        
        yaw_modifier = condition_settings[condition_idx].yaw_modifier.value
        yaw_offset = condition_settings[condition_idx].yaw_offset.value
        
        if yaw_modifier == 7 then
            spin_prev_offset = spin_prev_offset + yaw_offset
            if spin_prev_offset > 180 then
                spin_prev_offset = -180
            end
            menu.ragebot_anti_aim_base_yaw_offset = spin_prev_offset
            menu.ragebot_anti_aim_base_yaw_modifier = 0
            menu.ragebot_anti_aim_base_yaw_modifier_offset = 0
        else
            menu.ragebot_anti_aim_base_yaw_modifier = yaw_modifier - 1
            menu.ragebot_anti_aim_base_yaw_modifier_offset = yaw_offset
        end
    end

    if menu_manual_aa_enabled.value then
        local left_state = is_key_pressed(menu_manual_left_key.value)
        local right_state = is_key_pressed(menu_manual_right_key.value)

        if left_state and not last_left_state then
            if manuals_toggle == 90 then
                manuals_toggle = nil
                pitch_needs_reset = true
            else
                manuals_toggle = 90
            end
        end

        if right_state and not last_right_state then
            if manuals_toggle == -90 then
                manuals_toggle = nil
                pitch_needs_reset = true
            else
                manuals_toggle = -90
            end
        end

        last_left_state = left_state
        last_right_state = right_state
    end

    if manuals_toggle ~= last_manuals_toggle then
        if manuals_toggle == nil and last_manuals_toggle ~= nil then
            pitch_needs_reset = true
        end
        last_manuals_toggle = manuals_toggle
    end

    if manuals_toggle then
        menu.ragebot_anti_aim_base_yaw_offset = manuals_toggle
        if menu_pitch_jitter_enabled.value then
            if math.random(1, 100) <= menu_pitch_jitter_chance.value then
                menu.ragebot_anti_aim_pitch = menu_anti_aim_pitch.value - 1
            else
                menu.ragebot_anti_aim_pitch = 0
            end
        end
    else
        if yaw_modifier == 7 then
            return
        else
            if menu_random_yaw_enabled.value then
                menu.ragebot_anti_aim_base_yaw_offset = get_random_yaw()
            else
                menu.ragebot_anti_aim_base_yaw_offset = 180
            end

            if pitch_needs_reset then
                menu.ragebot_anti_aim_pitch = menu_anti_aim_pitch.value - 1
                pitch_needs_reset = false
            end
        end
    end
end

local function disable_ragebot_in_air()
    if current_state == "air" or current_state == "air_duck" then
        menu.ragebot_aimbot = false
    else
        menu.ragebot_aimbot = true
    end
end

local function buybot_run()
    --local player_controller = entitylist.get_local_player_controller()
    --if not player_controller then return end
    local player_pawn = entitylist.get_local_player_pawn()
    if not player_pawn then return end

    for i = 1, #menu_buybot_selector.value do
        if menu_buybot_selector.value[i] then
            engine.execute_client_cmd("buy " .. buybot_cmd_names[i])
        end
    end
end

local function adaptive_autostrafe()
    if menu_adaptive_auto_strafer_enabled.value then
        if is_key_pressed(0x57) or is_key_pressed(0x41) or is_key_pressed(0x53) or is_key_pressed(0x44) then
            menu.ragebot_auto_strafer = true
        else
            menu.ragebot_auto_strafer = false
        end
    end
end

-- SKIDDED PRESERVE KILLFEED CODE BELOW | Skidded from Keroset.lua | credits to @keroscene545 on discord
local fnFindHudElement = ffi.cast("uintptr_t*(__fastcall*)(const char*)", find_pattern("client.dll", "40 55 48 83 EC 20 48 83"));
local fnClearNotices = ffi.cast("void(__fastcall*)(uintptr_t)", find_pattern("client.dll", "48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20 48 8B 71 68"));
local bClear = false;

local ClearNotices = function(hudPtr)
    fnClearNotices(ffi.cast("uintptr_t", hudPtr) - 0x28);
    bClear = false
end

local preserveKillfeed = function(bUnload)
    local hudPtr = fnFindHudElement("CCSGO_HudDeathNotice");
    if not hudPtr or hudPtr == nil then return end;
    ffi.cast("float*", ffi.cast("uintptr_t", hudPtr) + 0x50)[0] = bUnload and 1.5 or 99999999999999999999.0;
    if (bClear) then
        ClearNotices(hudPtr);
    end
end

local preserveKillfeedFuncOnPaint = function() -- 🤍💙💖
    preserveKillfeed(false);
end

-- SKIDDED VELOCITY INDICATOR CODE BELOW | credits to Shinryu (Nix UID: 134794)
function math.lerp(a, b, t) return a + (b - a) * t end

local ColorMod = function(perc)
    local r = (124 * 2 - 124 * perc) / 255
    local g = (195 * perc) / 255 
    local b = 13 / 255
    return color_t(r, g, b, 1)
end
local FixedNumber = function(number)
    return string.format("%d", (1 - number) * 100)
end

local is_connected = function(ply_controller)
    local connected = ply_controller.m_iConnected
    return connected == 1
end

local is_alive = function(ply_controller)
    local alive = ply_controller.m_bPawnIsAlive
    return alive == 1
end

local font = render.setup_font("C:/windows/fonts/verdana.ttf", 12, 400)
local warningfont = render.setup_font("C:/windows/fonts/verdana.ttf", 27, 400)
local animation = {x_add = 0, rectfill = 0, alpha = 0}

function toDraw()

    local player_controller = entitylist.get_local_player_controller()
    if player_controller == nil then return end

    local localpawn = player_controller.m_hPlayerPawn
    if not localpawn then return end

    local game_scene_node = localpawn.m_pGameSceneNode
    if game_scene_node == nil then return end
    
    local sx = render.screen_size().x
    local sy = render.screen_size().y
    local position = {
        x = sx / 2,
        y = sy / 2 - 170
    }

    local velmodifier = localpawn.m_flVelocityModifier
    local text = "Slowed down " .. FixedNumber(velmodifier) .. "%"
    local textsize = render.calc_text_size(text, font, 12)

    local colorrect = ColorMod(velmodifier)

    if animation.rectfill == 0 then 
        animation.rectfill = velmodifier * 105 
    end

    animation.alpha = math.lerp(
        animation.alpha, 
        (velmodifier ~= 1 and is_connected(player_controller) and is_alive(player_controller)) and 1 or 0, 
        10 * render.frame_time()
    )
    animation.rectfill = math.lerp(animation.rectfill, velmodifier * 105, 10 * render.frame_time())

    
    if velmodifier == 1 then
        return
    end

    render.text(text, font, vec2_t(position.x - 50, position.y), 12, color_t(1, 1, 1, animation.alpha))

    render.rect_filled(
        vec2_t(position.x - 50 - 1, position.y + textsize.y + 2),
        vec2_t(position.x - 50 + 105 + 1, position.y + textsize.y + 4 + 9),
        color_t(0, 0, 0, 0.2)
    )

    if animation.rectfill > 0 then
        render.rect_filled(
            vec2_t(position.x - 50, position.y + textsize.y + 3),
            vec2_t(position.x - 50 + animation.rectfill, position.y + textsize.y + 3 + 9),
            color_t(colorrect.r, colorrect.g, colorrect.b, 1)
        )
    end

    local shadowpoints = { 
        vec2_t(position.x - (50 + 55) + 8 + 20, position.y - 4),
        vec2_t(position.x - (50 + 55) + 8 + 40, position.y - 4 + 35),
        vec2_t(position.x - (50 + 55) + 8, position.y - 4 + 35)
    }

    local filledpoints = { 
        vec2_t(position.x - (50 + 55) + 8 + 20, position.y - 4 + 3),
        vec2_t(position.x - (50 + 55) + 8 + 40 - 3, position.y - 4 + 35 - 2),
        vec2_t(position.x - (50 + 55) + 8 + 3, position.y - 4 + 35 - 2)
    }

    local triangle_center = {
        x = (shadowpoints[1].x + shadowpoints[2].x + shadowpoints[3].x) / 3,
        y = (shadowpoints[1].y + shadowpoints[2].y + shadowpoints[3].y) / 3
    }

    local exclamation_size = render.calc_text_size("!", warningfont, 27)

    render.filled_polygon(
        shadowpoints,
        color_t(0, 0, 0, 0.5)
    )

    render.filled_polygon(
        filledpoints,
        color_t(
            colorrect.r, 
            colorrect.g, 
            colorrect.b, 
            0.8
        )
    )

    render.text("!", warningfont, vec2_t(triangle_center.x - (exclamation_size.x / 2), triangle_center.y - (exclamation_size.y / 2)), 
        27, 
        color_t(0, 0, 0, 0.5)
    )
end

-- SKIDDED MANUAL AA INDICATOR CODE BELOW | Heavily Modified
local manualaaind = {}

function manualaaind.draw_indicator()
    if not menu_manual_aa_enabled.value then
        return
    end

    local local_player = entitylist.get_local_player_pawn()
    if not local_player then 
        return 
    end

    local screen_center = vec2_t(
        render.screen_size().x / 2,
        render.screen_size().y / 2
    )

    local current_yaw_offset = manuals_toggle or 0

    local manual = 0
    if current_yaw_offset >= 45 and current_yaw_offset <= 145 then
        manual = 2
    elseif current_yaw_offset <= -75 and current_yaw_offset >= -145 then
        manual = 1
    end

    local arrow_left = {
        vec2_t(screen_center.x - (manuals_distance + 23), screen_center.y),
        vec2_t(screen_center.x - (manuals_distance + 6), screen_center.y - 6),
        vec2_t(screen_center.x - (manuals_distance + 11), screen_center.y),
        vec2_t(screen_center.x - (manuals_distance + 6), screen_center.y + 6)
    }

    local arrow_right = {
        vec2_t(screen_center.x + (manuals_distance + 23), screen_center.y),
        vec2_t(screen_center.x + (manuals_distance + 6), screen_center.y - 6),
        vec2_t(screen_center.x + (manuals_distance + 11), screen_center.y),
        vec2_t(screen_center.x + (manuals_distance + 6), screen_center.y + 6)
    }

    render.filled_polygon(arrow_left, manual == 2 and menu_manual_aa_enabled.color_value or color_t(0, 0, 0, 0.4))
    render.filled_polygon(arrow_right, manual == 1 and menu_manual_aa_enabled.color_value or color_t(0, 0, 0, 0.4))
end

-- SKIDDED HIT/HURT LOGS CODE BELOW | Skidded from Logs.lua | credits to PaveKyz (UID: 1422)
local config = {
    hit_logs = menu_hitlogs_enabled.value,
    harm_logs = menu_hitlogs_enabled.value,
    hit_color = color_t(0.3, 1, 0.3, 1),
    harm_color = color_t(1, 0.3, 0.3, 1),
    other_color = color_t(1, 1, 1, 1),
    y_offset = 100
}

local font = {render.setup_font("C:/windows/fonts/verdana.ttf", 13, 400), 13}

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

local m_sSanitizedPlayerName = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName")
local m_nTickBase = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_nTickBase")

local convert_if_number = function(string)
    if string:match("^%d+$") then
        return tonumber(string)
    else
        return string
    end
end

log.print = function(text, colors, prefix_color)
    color_print("[Singularity.lua] \0", colors[prefix_color])
    local string = text
    local full_text = ""
    local colored_text = {}
    for i = 1, math.calculate_count(string, "{") do
        local start_prefix = string:find("{")
        local end_prefix = string:find("}")
        local color = convert_if_number(string:sub(start_prefix + 1, end_prefix - 1))
        local next_string = string:sub(end_prefix + 1)
        local next_prefix_start = next_string:find("{")
        local new_string = next_prefix_start and next_string:sub(1, next_prefix_start - 1) or next_string
        string = next_string
        color_print(new_string .. "\0", colors[color])
        full_text = full_text .. new_string
        table.insert(colored_text, { text = new_string, color = colors[color] })
    end
    print("")
    table.insert(logs, 1, { alpha = 0, tick_base = ffi.cast("int*", entitylist.get_local_player_controller()[m_nTickBase])[0] + (3 / 0.015625), full_text = full_text, colored_text = colored_text })
end

math.lerp = function(a, b, time)
    return a + (b - a) * time
end

log.render = function()
    local offset = 0
    for i, v in pairs(logs) do
        local local_player = entitylist.get_local_player_controller()
        if not local_player then
            logs = {}
            return
        end
        local tick_base = ffi.cast("int*", local_player[m_nTickBase])[0]
        if tick_base < v.tick_base and i <= 10 then
            v.alpha = math.lerp(v.alpha, 1, 10 * render.frame_time())
        else
            v.alpha = math.lerp(v.alpha, 0, 10 * render.frame_time())
            if v.alpha < 0.1 then
                table.remove(logs, i)
            end
        end
        local text_size = 0
        local screen_size = render.screen_size()
        local pos = vec2_t(screen_size.x / 2 - render.calc_text_size(v.full_text, font[1], font[2]).x / 2, screen_size.y / 2 + config.y_offset)
        for k, f in pairs(v.colored_text) do
            if not f.color then f.color = color_t(1, 1, 1, 1) end
            local color = color_t(f.color.r, f.color.g, f.color.b, f.color.a * v.alpha)
            render.shadow_text(f.text, font[1], vec2_t(pos.x + text_size, pos.y + offset), color, font[2])
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

local weapon_to_verb = {hegrenade = 'Naded', inferno = 'Burned', knife = 'Knifed', taser = 'Zeused'}

log.player_hurt = function(event)
    local local_player = entitylist.get_local_player_controller()
    if not local_player then return end
    local target = event:get_controller("userid")
    if not target then return end
    local target_name = ffi.string(ffi.cast("char**", target[m_sSanitizedPlayerName])[0])
    local attacker = event:get_controller("attacker")
    local attacker_name = "world"
    local self_harm = false
    if attacker == local_player and target == local_player then
        attacker_name = "yourself"
        self_harm = true
    elseif attacker then
        attacker_name = ffi.string(ffi.cast("char**", attacker[m_sSanitizedPlayerName])[0])
    end
    local result = false
    local colors = {}
    colors[1] = config.other_color
    if target == local_player then
        if not config.harm_logs then return end
        colors[2] = config.harm_color
        result = "harm"
    elseif attacker == local_player then
        if not config.hit_logs then return end
        colors[2] = config.hit_color
        result = "hit"
    end
    if not result then return end
    local damage = event:get_int("dmg_health")
    if damage == 0 then return end
    local remaining = event:get_int("health")
    local is_fatal = remaining == 0
    local hitgroup = hitgroups[event:get_int("hitgroup")]
    local weapon = event:get_string("weapon")
    local _result = result == "hit" and "Hit" or "Harmed"
    if is_fatal then
        _result = "Killed"
    elseif weapon_to_verb[weapon] then
        _result = weapon_to_verb[weapon]
    end
    if result == "harm" and not self_harm then
        _result = _result .. " by"
    end
    local _name = result == "hit" and target_name or attacker_name
    if hitgroup == "generic" or hitgroup == "gear" then
        _hitgroup = ""
    else
        if is_fatal or result == "harm" then
            _hitgroup = (" in {2}%s"):format(hitgroup)
        else
            _hitgroup = ("'s {2}%s"):format(hitgroup)
        end
    end
    if is_fatal then
        _damage = ""
    else
        _damage = (" for {2}%s {1}hp"):format(damage)
    end
    log.print(("{1}%s {2}%s{1}%s{1}%s"):format(_result, _name, _hitgroup, _damage), colors, 2)
end

-- SKIDDED BULLET TRACERS LUA BELOW | credits to n1zex (UID: refund)
-- main code: SYR1337
-- extra funcs: qi-ux
-- new signatures + "client impacts" tracers: n1zex
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
            typedef struct VectorBT {
                float x, y, z;
            } VectorBT;

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
                VectorBT* vecPositions;
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
        fnGetGameParticleManager = ffi.cast("void*(__fastcall*)()", Abs(find_pattern("client.dll", "E8 ?? ?? ?? ?? 4C 8D 47 64"), 0x1, 0x0))
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
        pParticleInformation[0].flWidth = menu_bullet_tracers_size.value
        pParticleInformation[0].flTime = menu_bullet_tracers_time.value
        if IGameParticleManager:SetEffectData(pEffectIndex[0], 3, pParticleInformation, 0) == -1337 then return end
        local vecStepPoints = { vecStart, vecCenterLinePoint, vecLinePointToEnd, vecEnd }
        for nIndex = 1, #vecStepPoints do
            pEffectData[0].flTimes = ffi.new(("float[%i]"):format(nIndex))
            pEffectData[0].vecPositions = ffi.new(("struct VectorBT[%i]"):format(nIndex))
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

    fnOnPaint = function ()
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
        for i = math.min(pBulletData:count(), last_count_bullet + maxIterations), last_count_bullet + 1, -1 do
            local element = pBulletData:element(i - 1)
            if element and element.position then
                CreateBeamPoint(vecEyePosition, vec3_t(element.position.x, element.position.y, element.position.z), tracers_color)
            else
                print("😪 >> " .. tostring(i - 1))
            end
        end
    
        if pBulletData:count() ~= last_count_bullet then 
            last_count_bullet = pBulletData:count()
        end
        goto zov_
        last_count_bullet = 0;
        ::zov_::
    end
end,print)

register_callback("paint", log.render)
register_callback("player_hurt", log.player_hurt)

local randomness_modes = {os.time(), os.time() + tonumber(tostring({}):sub(8))}
math.randomseed(randomness_modes[menu_randomness_mode.value])

register_callback("round_start", function()
    if menu_buybot.value then
        buybot_run()
    end
    bClear = true;
    last_count_bullet = 0
end)

local killsay_counter = 0
register_callback("player_death", function(event)
    if menu_killsay_enabled.value then
        if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
            engine.execute_client_cmd("say " .. killsay_phrases[killsay_counter % #killsay_phrases + 1])
            killsay_counter = killsay_counter + 1
        end
    end
end)

local zero_pitch_tick_counter = 0
local is_in_0_pitch = false
local function zero_pitch_on_land()
    if current_state == "landed" then
        is_in_0_pitch = true
    end
    if is_in_0_pitch then
        if zero_pitch_tick_counter >= menu_0_pitch_on_land_duration.value then
            is_in_0_pitch = false
            zero_pitch_tick_counter = 0
            menu.ragebot_anti_aim_pitch = menu_anti_aim_pitch.value - 1
        else
            zero_pitch_tick_counter = zero_pitch_tick_counter + 1
            menu.ragebot_anti_aim_pitch = 0
        end
    end
end

local air_flick_tick_counter = 0
local function air_flick()
    local flick_trigger_rate = menu_air_flick_trigger_rate.value
    if current_state == "air" or current_state == "air_duck" then
        if air_flick_tick_counter >= 64-flick_trigger_rate then
            air_flick_tick_counter = 0
            menu.ragebot_anti_aim_pitch = 0
            local yaw_flick_side = math.random(1, 2)
            if yaw_flick_side == 1 then
                menu.ragebot_anti_aim_base_yaw_offset = math.random(80, 110)
            else
                menu.ragebot_anti_aim_base_yaw_offset = math.random(-110, -80)
            end
        else
            menu.ragebot_anti_aim_pitch = menu_anti_aim_pitch.value - 1
        end
        air_flick_tick_counter = air_flick_tick_counter + 1
    end
end

-- SKIDDED WATERMARK CODE | credits to Frnxx:44440 | !! Code converted by Claude 3.7 Sonnet to not use external libraries && fixed by me !!

local function lerp(a, b, t)
    return a + (b - a) * t
end

local verdana = render.setup_font("C:/Windows/Fonts/verdana.ttf", 12, 0)

local cheat_name = "Singularity.lua" 
local custom_username = false
local custom_username_text = "JuicyChann"

local colors = {
    accent = menu_watermark_enabled.color_value,
    bg = color_t(0.06, 0.06, 0.06, 0.4)
}

local frame_count_for_fps, current_fps = 0, 0
local last_time_for_fps = os.clock()

local anim = {
    x = 0,
    w = 0
}

local function draw_glow(x, y, w, h, color, radius, intensity)
    local alpha_step = color.a / intensity
    for i = 1, intensity do
        local expanded_size = i * radius / intensity
        local alpha = color.a - (i * alpha_step)
        render.rect(
            vec2_t(x - expanded_size, y - expanded_size),
            vec2_t(x + w + expanded_size, y + h + expanded_size),
            color_t(color.r, color.g, color.b, alpha),
            radius,
            0
        )
    end
end

local function draw_arc(x, y, radius, start_angle, end_angle, segments, color, thickness)
    local step = (end_angle - start_angle) / segments
    for i = 0, segments - 1 do
        local angle1 = math.rad(start_angle + i * step)
        local angle2 = math.rad(start_angle + (i + 1) * step)
        local x1, y1 = x + radius * math.cos(angle1), y + radius * math.sin(angle1)
        local x2, y2 = x + radius * math.cos(angle2), y + radius * math.sin(angle2)
        render.line(vec2_t(x1, y1), vec2_t(x2, y2), color, thickness)
    end
end

local function draw_rect_filled_fade(x, y, w, h, color1, color2, color3, color4)
    local steps = 20
    local step_h = h / steps
    
    for i = 0, steps - 1 do
        local t = i / (steps - 1)
        
        local r = color1.r + (color2.r - color1.r) * t
        local g = color1.g + (color2.g - color1.g) * t
        local b = color1.b + (color2.b - color1.b) * t
        local a = color1.a + (color2.a - color1.a) * t
        
        local y_pos = y + (i * step_h)
        render.rect_filled(
            vec2_t(x, y_pos),
            vec2_t(x + w, y_pos + step_h + 1),
            color_t(r, g, b, a),
            0
        )
    end
end

local function create_window(x, y, w, h, bg_clr, accent_clr, watermark_style)
    if watermark_style == 1 then
        render.rect_filled(vec2_t(x, y), vec2_t(x + w, y + h), bg_clr, 0)
        render.rect_filled(vec2_t(x, y), vec2_t(x + w, y + 2), accent_clr, 0)

    elseif watermark_style == 2 then
        render.rect_filled(vec2_t(x, y), vec2_t(x + w, y + h), bg_clr, 5)
        render.rect_filled(vec2_t(x, y + 7), vec2_t(x + 2, y + h - 7), accent_clr, 0)
        render.rect_filled(vec2_t(x + w - 2, y + 7), vec2_t(x + w, y + h - 7), accent_clr, 0)
        draw_glow(x, y + 7, 2, h - 14, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0.25), 3, 30)
        draw_glow(x + w - 2, y + 7, 2, h - 14, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0.25), 3, 30)
    
    elseif watermark_style == 3 then
        draw_glow(x, y, w, h, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0.25), 5, 30)
        render.rect_filled(vec2_t(x, y), vec2_t(x + w, y + h), bg_clr, 6)
        render.rect(vec2_t(x, y), vec2_t(x + w, y + h), color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0.35), 5, 0)
        draw_arc(x + 5, y + 5, 4, 3, 5, 10, accent_clr, 1)
        render.rect_filled(vec2_t(x + 4, y), vec2_t(x + w - 4, y + 1), accent_clr, 0)
        draw_arc(x + w - 5, y + 5, 4, 6, 5, 10, accent_clr, 1)
        draw_rect_filled_fade(x, y + 4, 1, h - 6, accent_clr, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0), accent_clr, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0))
        draw_rect_filled_fade(x + w - 1, y + 4, 1, h - 6, accent_clr, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0), accent_clr, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0))
    
    elseif watermark_style == 4 then
        draw_glow(x - 4, y, w + 8, h, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0.25), 0, 30)
        render.rect_filled(vec2_t(x - 4, y), vec2_t(x - 4 + w + 8, y + h), color_t(bg_clr.r, bg_clr.g, bg_clr.b, 0.5), 0)
        render.rect_filled(vec2_t(x, y + 5), vec2_t(x + w, y + 5 + h - 8), color_t(bg_clr.r, bg_clr.g, bg_clr.b, 0.5), 0)
        render.rect(vec2_t(x - 4, y), vec2_t(x - 4 + w + 8, y + h), color_t(bg_clr.r, bg_clr.g, bg_clr.b, 0.25), 0, 0)
        render.rect_filled(vec2_t(x, y + 4), vec2_t(x + w, y + 5), accent_clr, 0)
    end
end

local function draw_watermark()
    local current_time = os.clock()
    frame_count_for_fps = frame_count_for_fps + 1

    if current_time - last_time_for_fps >= 1 then
        current_fps = frame_count_for_fps
        frame_count_for_fps = 0
        last_time_for_fps = current_time
    end

    local controller = entitylist.get_local_player_controller()
    if controller == nil then return end

    local screen_size = render.screen_size()
    local username = custom_username and custom_username_text or get_user_name()

    local text = string.format("%s | %s | ping: %sms | fps: %s | %s", cheat_name, username, controller.m_iPing, current_fps, os.date("%H:%M:%S"))
    local text_size = render.calc_text_size(text, verdana, 12)
    
    anim.x = lerp(anim.x, screen_size.x - text_size.x - 20, 0.1)
    anim.w = lerp(anim.w, text_size.x, 0.25)
    
    local y = 10
    local h = 23

    create_window(anim.x - 6, y, anim.w + 12, h, colors.bg, colors.accent, menu_watermark_style.value)
    render.text(text, verdana, vec2_t(anim.x, y + h/2 - 6), color_t(1, 1, 1, 1), 12)
end

-- SKIDDED DUCK PEEK ASSIST CODE BELOW | credits to PaveKyz (UID: 1422)
local duck_assist_toggle = false
local min_dmg_toggle = false
local last_duck_key_state = false
local last_min_dmg_key_state = false
local visualize = true

local vecViewOffset = engine.get_netvar_offset("client.dll", "C_BaseModelEntity", "m_vecViewOffset")
local pGameSceneNode = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_pGameSceneNode")
local modelState = engine.get_netvar_offset("client.dll", "CSkeletonInstance", "m_modelState")
local pBoneMatrix = 0x80
local bone_spacing = 0x20

local is_key_held = function(key)
    return bit.band(ffi.C.GetKeyState(key), 0x8000) ~= 0
end

base_entity_t.is_alive = function(entity)
    return entity.m_lifeState == 0 and entity.m_iHealth > 0
end

base_entity_t.is_on_ground = function(entity)
    return bit.band(entity.m_fFlags, 1) == 1
end

base_entity_t.is_teammate = function(entity1, entity2)
    return not cvars.mp_teammates_are_enemies:get_bool() and entity1.m_iTeamNum == entity2.m_iTeamNum
end

base_entity_t.get_eye_position = function(entity, standing)
    local abs_origin = entity:get_abs_origin()
    local view_offset = ffi.cast("struct Vector*", ffi.cast("uintptr_t", entity[0]) + vecViewOffset)[0]
    local position = vec3_t(abs_origin.x + view_offset.x, abs_origin.y + view_offset.y, abs_origin.z + view_offset.z)
    if standing then
        position.z = position.z - entity.m_pMovementServices.m_flDuckOffset
    end
    return position
end

base_entity_t.get_bone_pos = function(entity, bone)
    local game_scene_node = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", entity[0]) + pGameSceneNode)[0]
    local bone_matrix = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", game_scene_node) + (modelState + pBoneMatrix))[0]
    local position = ffi.cast("struct Vector*", ffi.cast("uintptr_t", bone_matrix) + (bone * bone_spacing))[0]
    return vec3_t(position.x, position.y, position.z)
end

render.point = function(pos, bool)
    pos = render.world_to_screen(pos)
    if not pos then return end
    render.circle_fade(pos, 4, color_t(1, bool and 0 or 1, bool and 0 or 1, 0.8), color_t(1, bool and 0 or 1, bool and 0 or 1, 0))
end

engine.trace_bullet_team_check = function(from_entity, from, to) -- :)
    local eye_pos = from_entity:get_eye_position()
    local calc_angle = math.calc_angle(from, to)
    local distance = from:dist_to(to)
    local mate = nil
    local max_distance = 0
    entitylist.get_entities("C_CSPlayerPawn", function(entity)
        if not entity or entity == from_entity or not entity:is_alive() or not from_entity:is_teammate(entity) or entity.m_iTeamNum == 0 then return end
        local ent_eye_pos = entity:get_eye_position()
        local ent_distance = from:dist_to(ent_eye_pos)
        local calc_fov = math.calc_fov(calc_angle, math.calc_angle(eye_pos, ent_eye_pos))
        if ent_distance > max_distance and ent_distance + 35 < distance and calc_fov < 40 then
            max_distance = ent_distance
            mate = entity
        end
    end)
    if not mate then return false end
    local mate_eye_pos = mate:get_eye_position()
    local mate_distance = from:dist_to(mate_eye_pos)
    local forward, right, up = math.angle_vectors(calc_angle)
    local trace = engine.trace_bullet(from_entity, from + forward * (mate_distance + 15), from)
    if trace then return true end
    return false
end

local view_angles = angle_t(0, 0, 0)

register_callback("override_view", function(view_setup)
    view_angles = view_setup.angles
end)

local can_shoot = false
local is_ducking = false
local bones = {6, 4, 0}

local function update_min_dmg_toggle()
    local min_dmg_key_pressed = is_key_pressed(menu_default_override_min_dmg_key.value)

    if menu_default_override_min_dmg_key.mode == 2 then -- Toggle mode
        if min_dmg_key_pressed and not last_min_dmg_key_state then
            min_dmg_toggle = not min_dmg_toggle
        end
    else
        min_dmg_toggle = is_key_held(menu_default_override_min_dmg_key.value)
    end

    last_min_dmg_key_state = min_dmg_key_pressed
end

local function update_duck_assist_toggles()
    local duck_key_pressed = is_key_pressed(menu_duck_peek_assist_key.value)
    
    if menu_duck_peek_assist_key.mode == 2 then -- Toggle mode
        if duck_key_pressed and not last_duck_key_state then
            duck_assist_toggle = not duck_assist_toggle
        end
    else
        duck_assist_toggle = is_key_held(menu_duck_peek_assist_key.value)
    end
    
    last_duck_key_state = duck_key_pressed
end

local function handle_duck_assist()
    update_duck_assist_toggles()
    
    can_shoot = false
    local local_player_pawn = entitylist.get_local_player_pawn()
    if not local_player_pawn then
        return
    end
    local local_player_controller = entitylist.get_local_player_controller()
    if not local_player_controller then
        return
    end
    local health = local_player_pawn.m_iHealth
    if not health or health <= 0 then return end;
    
    if not duck_assist_toggle or not local_player_pawn or not local_player_controller or not local_player_pawn:is_alive() or not local_player_pawn:is_on_ground() then
        if is_ducking then
            engine.execute_client_cmd("-duck")
            is_ducking = false
        end
        return
    end
    
    local eye_pos = local_player_pawn:get_eye_position(true)
    local target = nil
    local min_fov = math.huge
    entitylist.get_entities("C_CSPlayerPawn", function(entity)
        if not entity or entity == local_player_pawn or not entity:is_alive() or local_player_pawn:is_teammate(entity) or entity.m_iTeamNum == 0 then return end
        local enemy_eye_pos = entity:get_eye_position()
        local fov = math.calc_fov(view_angles, math.calc_angle(eye_pos, enemy_eye_pos))
        if fov < min_fov then
            min_fov = fov
            target = entity
        end
    end)
    if target then
        local min_damage = math.min(min_dmg_toggle and menu_default_override_min_dmg.value or menu_default_min_dmg.value, target.m_iHealth)
        for _, bone in pairs(bones) do
            local bone_pos = target:get_bone_pos(bone)
            if bone == 6 then bone_pos.z = bone_pos.z + 4 end
            local trace = engine.trace_bullet(local_player_pawn, eye_pos, bone_pos)
            local team_check = engine.trace_bullet_team_check(local_player_pawn, eye_pos, bone_pos)
            if visualize then render.point(bone_pos, (trace and trace >= min_damage) and not team_check) end
            if (trace and trace >= min_damage) and not team_check then
                can_shoot = true
            end
        end
    end
    local duck_offset = local_player_pawn.m_pMovementServices.m_flDuckOffset
    local duck_speed = local_player_pawn.m_pMovementServices.m_flDuckSpeed
    local tick_base = local_player_controller.m_nTickBase
    
    local weapon_entity = local_player_pawn.m_pWeaponServices.m_hActiveWeapon
    if not weapon_entity then return end
    local next_attack_tick = local_player_pawn.m_pWeaponServices.m_hActiveWeapon.m_nNextPrimaryAttackTick
    if can_shoot and tick_base > next_attack_tick then
        if is_ducking and duck_speed >= 8 then
            engine.execute_client_cmd("-duck")
            is_ducking = false
        end
    elseif not is_ducking and (duck_offset >= 0 or duck_offset == -18 or tick_base < next_attack_tick) then
        engine.execute_client_cmd("+duck")
        is_ducking = true
    end
end

local function draw_player_state()
    local display_states = {
        ["landed"] = "landed",
        ["air"] = "~in-air~",
        ["air_duck"] = "~air-ducking~",
        ["crouch_walk"] = "~duck-walking~",
        ["crouch"] = "~ducking~",
        ["walk"] = "~walking~",
        ["stand"] = "~standing~",
        ["unknown"] = "~unknown~"
    }
    
    if current_state ~= "unknown" then
        local screen_size = render.screen_size()
        local screen_center_x = screen_size.x / 2
        local screen_center_y = screen_size.y / 2
        
        local state_text = display_states[current_state] or current_state
        local text_size = render.calc_text_size(state_text, state_font, 12)

        render.text(state_text, state_font, vec2_t(screen_center_x - text_size.x / 2 + 1, screen_center_y + 45 + 1), color_t(0, 0, 0, 1), 12)
        render.text(state_text, state_font, vec2_t(screen_center_x - text_size.x / 2, screen_center_y + 45), color_t(1, 1, 1, 1), 12)

        if menu_ai_peek_enabled.value and key then
            local ai_status = "ai peek"
            
            local ai_text_size = render.calc_text_size(ai_status, state_font, 11)
            
            render.text(ai_status, state_font, 
                vec2_t(screen_center_x - ai_text_size.x / 2 + 1, screen_center_y + 65 + 1), 
                color_t(0, 0, 0, 1), 11)
            
            render.text(ai_status, state_font, 
                vec2_t(screen_center_x - ai_text_size.x / 2, screen_center_y + 65), 
                color_t(1, 1, 1, 1), 11)
        end

        if menu_duck_peek_assist_enabled.value and duck_assist_toggle then
            local duck_status = "duck assist"
            if min_dmg_toggle then
                duck_status = duck_status .. " (min dmg)"
            end
            
            local duck_text_size = render.calc_text_size(duck_status, state_font, 11)
            
            render.text(duck_status, state_font, 
                vec2_t(screen_center_x - duck_text_size.x / 2 + 1, screen_center_y + 77 + 1), 
                color_t(0, 0, 0, 1), 11)
            
            render.text(duck_status, state_font, 
                vec2_t(screen_center_x - duck_text_size.x / 2, screen_center_y + 77), 
                color_t(1, 1, 1, 1), 11)
        end
    end
end

-- SKIDDED CUSTOM SCOPE CODE BELOW | credits to n1zex (UID: refund) && SYR (UID: 335676)
local Abs = function(addr, pre, post)
    addr = addr + (pre or 1)
    addr = addr + ffi.sizeof("int") + ffi.cast("int64_t", ffi.cast("int*", addr)[0])
    addr = addr + (post or 0)
    return addr
end;
assert(ffi, "syr1337 hook lib error: ffi is not open, please open ffi");
if not pcall(ffi.sizeof, "struct Thread32Entry") then
        ffi.cdef([[
            typedef struct Thread32Entry {
                uint32_t dwSize;
                uint32_t cntUsage;
                uint32_t th32ThreadID;
                uint32_t th32OwnerProcessID;
                long tpBasePri;
                long tpDeltaPri;
                uint32_t dwFlags;
            } Thread32Entry;
            
            int CloseHandle(void*);
            uint32_t ResumeThread(void*);
            uint32_t GetCurrentThreadId();
            uint32_t SuspendThread(void*);
            uint32_t GetCurrentProcessId();
            void* OpenThread(uint32_t, int, uint32_t);
            void* GetProcAddress(uintptr_t, const char*);
            int Thread32Next(void*, struct Thread32Entry*);
            int Thread32First(void*, struct Thread32Entry*);
            void* CreateToolhelp32Snapshot(uint32_t, uint32_t);
            int VirtualProtect(void*, uint64_t, uint32_t, uint32_t*);
        ]])
end
local vecScreenSize = render.screen_size() * 0.5
local flAnim = 0.1;
local m_bIsScoped = engine.get_netvar_offset("client.dll", "C_CSPlayerPawn", "m_bIsScoped");
local arrHooks = {}
local arrThreads = {}
local NULLPTR = ffi.cast("void*", 0)
local INVALID_HANDLE = ffi.cast("void*", - 1)
local colMain_ = menu_custom_scope_enabled.color_value
local colAlpha = color_t(colMain_.r, colMain_.g, colMain_.b, 0);
local fnDrawScope = Abs(ffi.cast("uintptr_t", find_pattern("client.dll", "E8 ? ? ? ? 80 7C 24 ? ? 74 25")), 1, 0);
local Lerp = function(a, b, t)
    return a + (b - a) * t;
end;
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
        assert(type(pDetour) == "function", "syr1337 hook lib error: invalid detour function")
        assert(type(pTarget) == "cdata" or type(pTarget) == "number" or type(pTarget) == "function", "syr1337 hook lib error: invalid target function")
        if not SuspendThreads() then
            ResumeThreads()
            print("syr1337 hook lib error: failed suspend threads")
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
            pOldProtect = ffi.new("uint32_t[1]")
        }

        ffi.copy(arrBackUp, pTargetFn, ffi.sizeof(arrBackUp))
        ffi.cast("uintptr_t*", arrShellCode + 0x6)[0] = ffi.cast("uintptr_t", ffi.cast(szType, function(...)
            local bSuccessfully, pResult = pcall(pDetour, __Object, ...)
            if not bSuccessfully then
                __Object:Remove()
                print(("[syr1337 hook lib]: unexception runtime error -> %s"):format(pResult))
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
                    print(("[syr1337 hook lib]: runtime error -> %s"):format(pResult))
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
local function customeScope()
    local pLocalPawn = entitylist.get_local_player_pawn();
    if not pLocalPawn then return end;

    local health = pLocalPawn.m_iHealth
    if not health or health <= 0 then return end;

    menu.misc_removals = bit32.band(menu.misc_removals, bit32.bnot(bit32.lshift(1, 3)))

    local bIsScoped = ffi.cast("bool*", pLocalPawn[m_bIsScoped])[0];
    local colMain = colMain_;
    flAnim = Lerp(flAnim, bIsScoped and 1 or 0, 20 * render.frame_time());
    local flOffset = menu_custom_scope_offset.value * flAnim;
    local flLength = menu_custom_scope_length.value * flAnim;
    local sum = (flOffset + flLength);
    if flAnim > 0.001 then
        render.rect_filled_fade(vec2_t(vecScreenSize.x - sum, vecScreenSize.y), vec2_t(vecScreenSize.x - flOffset, vecScreenSize.y + 1), colAlpha, colMain, colMain, colAlpha);
        render.rect_filled_fade(vec2_t(vecScreenSize.x + flOffset, vecScreenSize.y), vec2_t(vecScreenSize.x + sum, vecScreenSize.y + 1), colMain, colAlpha, colAlpha, colMain);
        render.rect_filled_fade(vec2_t(vecScreenSize.x, vecScreenSize.y + flOffset), vec2_t(vecScreenSize.x + 1, vecScreenSize.y + sum), colMain, colMain, colAlpha, colAlpha);
        render.rect_filled_fade(vec2_t(vecScreenSize.x, vecScreenSize.y - sum), vec2_t(vecScreenSize.x + 1, vecScreenSize.y - flOffset), colAlpha, colAlpha, colMain, colMain);
    end
end

CreateHook(fnDrawScope, function(pObject, pRcx, pUnk) end, "void(__fastcall*)(void*, void*)")
register_callback("unload", function() for _, pObject in pairs(arrHooks) do pObject:Remove() end end)

local function auto_thirdperson_spectate()
    local local_player_controller = entitylist.get_local_player_controller()
    if not local_player_controller then return end
    
    local local_pawn = entitylist.get_local_player_pawn()
    local is_spectating = not local_pawn or (local_pawn and local_pawn.m_iHealth and local_pawn.m_iHealth <= 0)
    if is_spectating then
        engine.execute_client_cmd("spec_mode 3")
    end
end

local function apply_custom_fov()
    local m_iDesiredFOV = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_iDesiredFOV")
    local local_player_controller = entitylist.get_local_player_controller()
    if local_player_controller then
        ffi.cast("int*", local_player_controller[m_iDesiredFOV])[0] = menu_fov_value.value
    end
end

local font = render.setup_font("C:/Windows/Fonts/verdana.ttf", 25)
local small_font = render.setup_font("C:/Windows/Fonts/verdana.ttf", 12)

minimum_distance_to_draw = menu_wallbang_helper_minimum_distance_to_draw.value

local state = {
    locations = {},
    current_map = "",
    menu_open = false,
    loaded = false
}

local function load_locations()
    wallbangs_file_path = "nix\\scripts\\" .. wallbang_helper_files[menu_wallbang_helper_file.value]
    local file = io.open(wallbangs_file_path, "r")
    if not file then
        print("[Singularity:WallbangHelper] Failed to load config file (" .. wallbang_helper_files[menu_wallbang_helper_file.value] .. "). Please select a different one from the dropdown!")
        return false
    end
    
    local content = file:read("*all")
    file:close()
    
    -- Simple JSON parsing function (Thanks Claude, god bless AI!)
    local function parse_json_value(str, pos)
        -- Skip whitespace
        pos = str:find("[^%s]", pos) or pos
        
        local first = str:sub(pos, pos)
        if first == "{" then -- Object
            local obj = {}
            local key, value
            pos = pos + 1
            
            -- Skip initial whitespace
            pos = str:find("[^%s]", pos) or pos
            
            -- Check for empty object
            if str:sub(pos, pos) == "}" then
                return obj, pos + 1
            end
            
            while true do
                -- Parse key (should be a string)
                key, pos = parse_json_value(str, pos)
                
                -- Skip whitespace to colon
                pos = str:find("[^%s]", pos) or pos
                
                -- Expect colon
                if str:sub(pos, pos) ~= ":" then
                    error("Expected colon at position " .. pos)
                end
                pos = pos + 1
                
                -- Parse value
                value, pos = parse_json_value(str, pos)
                
                -- Store key-value pair
                obj[key] = value
                
                -- Skip whitespace to comma or closing brace
                pos = str:find("[^%s]", pos) or pos
                
                local c = str:sub(pos, pos)
                if c == "}" then
                    return obj, pos + 1
                elseif c == "," then
                    pos = pos + 1
                else
                    error("Expected comma or closing brace at position " .. pos)
                end
                
                -- Skip whitespace after comma
                pos = str:find("[^%s]", pos) or pos
                
                -- Check for closing brace after comma (trailing comma case)
                if str:sub(pos, pos) == "}" then
                    return obj, pos + 1
                end
            end
        elseif first == "[" then -- Array
            local arr = {}
            local value
            pos = pos + 1
            
            -- Skip initial whitespace
            pos = str:find("[^%s]", pos) or pos
            
            -- Check for empty array
            if str:sub(pos, pos) == "]" then
                return arr, pos + 1
            end
            
            while true do
                -- Parse value
                value, pos = parse_json_value(str, pos)
                
                -- Add to array
                table.insert(arr, value)
                
                -- Skip whitespace to comma or closing bracket
                pos = str:find("[^%s]", pos) or pos
                
                local c = str:sub(pos, pos)
                if c == "]" then
                    return arr, pos + 1
                elseif c == "," then
                    pos = pos + 1
                else
                    error("Expected comma or closing bracket at position " .. pos)
                end
                
                -- Skip whitespace after comma
                pos = str:find("[^%s]", pos) or pos
                
                -- Check for closing bracket after comma (trailing comma case)
                if str:sub(pos, pos) == "]" then
                    return arr, pos + 1
                end
            end
        elseif first == '"' then -- String
            local endPos = pos + 1
            local escaped = false
            
            while true do
                local c = str:sub(endPos, endPos)
                if c == "" then
                    error("Unterminated string at position " .. pos)
                elseif c == "\\" then
                    escaped = not escaped
                elseif c == '"' and not escaped then
                    break
                else
                    escaped = false
                end
                endPos = endPos + 1
            end
            
            -- Extract string and handle escape sequences
            local strValue = str:sub(pos + 1, endPos - 1)
            strValue = strValue:gsub('\\"', '"'):gsub("\\\\", "\\"):gsub("\\n", "\n"):gsub("\\t", "\t")
            
            return strValue, endPos + 1
        elseif first:match("[%-%d]") then -- Number
            local endPos = str:find("[^%d%-%+%.eE]", pos) or #str + 1
            local numStr = str:sub(pos, endPos - 1)
            return tonumber(numStr), endPos
        elseif str:sub(pos, pos + 3) == "true" then -- Boolean true
            return true, pos + 4
        elseif str:sub(pos, pos + 4) == "false" then -- Boolean false
            return false, pos + 5
        elseif str:sub(pos, pos + 3) == "null" then -- Null
            return nil, pos + 4
        else
            error("Unexpected character at position " .. pos .. ": " .. first)
        end
    end
    
    local function parse_json(jsonStr)
        local result, _ = parse_json_value(jsonStr, 1)
        return result
    end
    
    local success, parsed
    success, parsed = pcall(function()
        return parse_json(content)
    end)
    
    if not success or not parsed then
        print("[Singularity:WallbangHelper] Failed to parse config file: " .. (parsed or "unknown error"))
        return false
    end
    
    local locations_array = {}
    for id, location in pairs(parsed) do
        location.id = id
        table.insert(locations_array, location)
    end
    
    state.locations = locations_array
    state.loaded = true
    print("[Singularity:WallbangHelper] Loaded " .. #state.locations .. " locations")
    return true
end

local function draw_wallbangs()
    local local_player = entitylist.get_local_player_pawn()
    if not local_player then return end

    local health = local_player.m_iHealth
    if not health or health <= 0 then return end;
    
    local current_map = engine.get_level_name()
    if current_map ~= state.current_map then
        state.current_map = current_map
        print("[Singularity:WallbangHelper] Current Map: " .. current_map)
    end
    
    local local_pos = local_player.m_pGameSceneNode.m_vecAbsOrigin
    
    local weapon_entity = local_player.m_pWeaponServices.m_hActiveWeapon
    if not weapon_entity then return end
    
    local weapon_entity_str = tostring(weapon_entity)
    local weapon_name = ""
    
    if weapon_entity_str then
        -- Extract just the first part before any comma (thanks AI, regex is annoying)
        weapon_name = weapon_entity_str:match("^C_Weapon([^,]+)") or 
                        weapon_entity_str:match("^C_([^,]+)") or
                        weapon_entity_str
        
        weapon_name = weapon_name:gsub("^C_Weapon", ""):gsub("^C_", "")
    end
    
    local weapon_type = ""
    weapon_name = weapon_name:lower()
    
    if weapon_name:find("awp") then
        weapon_type = "awp"
    elseif weapon_name:find("ssg08") or weapon_name:find("scout") then
        weapon_type = "scout"
    elseif weapon_name:find("scar20") or weapon_name:find("g3sg1") then
        weapon_type = "auto"
    elseif weapon_name:find("revolver") then
        weapon_type = "revolver"
    end
    
    if weapon_type == "" then
        return
    end
    
    for _, location in ipairs(state.locations) do
        if location.map == current_map then
            if not location.from or not location.from.position or not location.to or not location.to.position then
                goto continue
            end
            
            if #location.from.position < 3 or #location.to.position < 3 then
                goto continue
            end
            
            local weapon_supported = false
            if location.weapon then
                for _, supported_weapon in ipairs(location.weapon) do
                    if supported_weapon == weapon_type then
                        weapon_supported = true
                        break
                    end
                end
                
                if not weapon_supported then
                    goto continue
                end
            end
            
            local from_pos = vec3_t(
                location.from.position[1], 
                location.from.position[2], 
                location.from.position[3]
            )
            
            local to_pos = vec3_t(
                location.to.position[1], 
                location.to.position[2], 
                location.to.position[3]
            )
            
            local reference_point_1
            local reference_point_2
            if location.reverse == true then
                reference_point_1 = from_pos
                reference_point_2 = to_pos
            else
                reference_point_1 = from_pos
                reference_point_2 = to_pos
            end
            
            local distance_1 = local_pos:dist_to(reference_point_1)
            local distance_2 = local_pos:dist_to(reference_point_2)
            
            if (distance_1 <= minimum_distance_to_draw) or (distance_2 <= minimum_distance_to_draw) then
                local line_color
                if location.reverse == true then
                    local distance_from = local_pos:dist_to(from_pos)
                    local distance_to = local_pos:dist_to(to_pos)
                    
                    if distance_to < distance_from then
                        line_color = Wallbang_Helper_Settings.reverse_color_to
                    else
                        line_color = Wallbang_Helper_Settings.reverse_color_from
                    end
                else
                    line_color = Wallbang_Helper_Settings.normal_color
                end
                
                local screen_from = render.world_to_screen(from_pos)
                local screen_to = render.world_to_screen(to_pos)
                
                if screen_from and screen_to then
                    render.line(screen_from, screen_to, line_color, Wallbang_Helper_Settings.line_width)
                    
                    if location.reverse then
                        local tick_size = 9
                        render.line(
                            vec2_t(screen_from.x - tick_size, screen_from.y), 
                            vec2_t(screen_from.x, screen_from.y + tick_size), 
                            line_color, 
                            2
                        )
                        render.line(
                            vec2_t(screen_from.x, screen_from.y + tick_size), 
                            vec2_t(screen_from.x + tick_size, screen_from.y - tick_size), 
                            line_color, 
                            2
                        )
                        
                        local cross_size = 6
                        render.line(
                            vec2_t(screen_to.x - cross_size, screen_to.y - cross_size), 
                            vec2_t(screen_to.x + cross_size, screen_to.y + cross_size), 
                            line_color, 
                            2
                        )
                        render.line(
                            vec2_t(screen_to.x - cross_size, screen_to.y + cross_size), 
                            vec2_t(screen_to.x + cross_size, screen_to.y - cross_size), 
                            line_color, 
                            2
                        )
                    else
                        render.circle_fade(screen_from, Wallbang_Helper_Settings.endpoint_radius, line_color, color_t(0, 0, 0, 0))
                        render.circle_fade(screen_to, Wallbang_Helper_Settings.endpoint_radius, line_color, color_t(0, 0, 0, 0))
                    end
                end
                
                if location.to.radius and type(location.to.radius) == "number" then
                    local radius = location.to.radius
                    local segments = 30
                    local prev_point = nil
                    
                    for i = 0, segments do
                        local angle = (i / segments) * 2 * math.pi
                        local x = to_pos.x + radius * math.cos(angle)
                        local y = to_pos.y + radius * math.sin(angle)
                        
                        local point_pos = vec3_t(x, y, to_pos.z)
                        local screen_point = render.world_to_screen(point_pos)
                        
                        if screen_point and prev_point then
                            render.line(prev_point, screen_point, line_color, Wallbang_Helper_Settings.line_width)
                        end
                        
                        prev_point = screen_point
                    end
                end
                
                local segment_count = 20
                local prev_screen = nil
                
                for i = 0, segment_count do
                    local fraction = i / segment_count
                    local segment_pos = vec3_t(
                        from_pos.x + (to_pos.x - from_pos.x) * fraction,
                        from_pos.y + (to_pos.y - from_pos.y) * fraction,
                        from_pos.z + (to_pos.z - from_pos.z) * fraction
                    )
                    
                    local segment_screen = render.world_to_screen(segment_pos)
                    if segment_screen and prev_screen then
                        render.line(prev_screen, segment_screen, line_color, Wallbang_Helper_Settings.line_width)
                    end
                    prev_screen = segment_screen
                end
            end
            
            ::continue::
        end
    end
end

local function wallbang_helper()
    if not state.loaded then
        load_locations()
    end
    
    draw_wallbangs()
end

local function apply_glow_to_local_player()
    local local_pawn = entitylist.get_local_player_pawn()

    if local_pawn == nil then
        return
    end

    local glow_property = local_pawn.m_Glow

    if glow_property == nil then
        return
    end

    glow_property.m_bGlowing = true
    glow_property.m_glowColorOverride = menu_local_player_glow_enabled.color_value
    glow_property.m_bEligibleForScreenHighlight = true
end

local function is_utility(weapon_name)
    if not weapon_name then return false end
    
    weapon_name = weapon_name:lower()
    return weapon_name:find("flash") or 
            weapon_name:find("smoke") or 
            weapon_name:find("grenade") or 
            weapon_name:find("molotov") or 
            weapon_name:find("decoy") or 
            weapon_name:find("incendiary")
end

local prev_thirdperson_state = false
local was_holding_utility = false

local function firstperson_on_utilities()
    local local_player = entitylist.get_local_player_pawn()
    if not local_player then return end

    local health = local_player.m_iHealth
    if not health or health <= 0 then return end;
    
    local weapon_entity = local_player.m_pWeaponServices.m_hActiveWeapon
    if not weapon_entity then return end
    
    local weapon_entity_str = tostring(weapon_entity)
    local is_holding_utility = is_utility(weapon_entity_str)
    
    if is_holding_utility and not was_holding_utility then
        prev_thirdperson_state = menu.misc_thirdperson
        menu.misc_thirdperson = false
    elseif not is_holding_utility and was_holding_utility then
        menu.misc_thirdperson = prev_thirdperson_state
    end
    
    was_holding_utility = is_holding_utility
end

-- SKIDDED AI PEEK CODE BELOW | credits to @spinning3 on Discord
visualize = true
peek_state = "idle"
peek_dir   = 0
peek_time  = 0
units_per_meter = 1 / 0.0254

local vecViewOffset   = engine.get_netvar_offset("client.dll", "C_BaseModelEntity",   "m_vecViewOffset")
local pGameSceneNode  = engine.get_netvar_offset("client.dll", "C_BaseEntity",       "m_pGameSceneNode")
local modelState      = engine.get_netvar_offset("client.dll", "CSkeletonInstance",  "m_modelState")
local pBoneMatrix     = 0x80
local bone_spacing    = 0x20

local function vec_sub(a,b) return vec3_t(a.x-b.x, a.y-b.y, a.z-b.z) end
local function vec_length(v) return math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z) end
local function is_key_held(k) return bit.band(ffi.C.GetKeyState(k), 0x8000) ~= 0 end

base_entity_t.is_alive       = function(self) return self.m_lifeState == 0 and self.m_iHealth > 0 end
base_entity_t.is_dormant     = function(self) return self.m_bDormant end
base_entity_t.is_on_ground   = function(self) return bit.band(self.m_fFlags,1)==1 end
base_entity_t.is_teammate    = function(a,b)
    return not cvars.mp_teammates_are_enemies:get_bool()
       and a.m_iTeamNum == b.m_iTeamNum
end
base_entity_t.get_eye_position = function(self,stand)
    local abs = self:get_abs_origin()
    local vo  = ffi.cast("struct Vector*", ffi.cast("uintptr_t", self[0]) + vecViewOffset)[0]
    local pos = vec3_t(abs.x+vo.x, abs.y+vo.y, abs.z+vo.z)
    if stand then pos.z = pos.z - self.m_pMovementServices.m_flDuckOffset end
    return pos
end
base_entity_t.get_bone_pos = function(self,bone)
    local node = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", self[0]) + pGameSceneNode)[0]
    local bm   = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", node) + (modelState + pBoneMatrix))[0]
    local p    = ffi.cast("struct Vector*", ffi.cast("uintptr_t", bm) + (bone * bone_spacing))[0]
    return vec3_t(p.x,p.y,p.z)
end

render.point = function(pos,highlight)
    local sp = render.world_to_screen(pos)
    if not sp then return end
    render.circle_fade(sp, 4,
        color_t(1, highlight and 0 or 1, highlight and 0 or 1, 0.8),
        color_t(1, highlight and 0 or 1, highlight and 0 or 1, 0))
end

local view_angles = angle_t(0,0,0)
register_callback("override_view", function(vs) view_angles = vs.angles end)

local bones = {6,4,0}

local last_ai_peek_key_state = false
local function handle_ai_key_state()
    local ai_peek_key_pressed = is_key_pressed(menu_ai_peek_key.value)

    if menu_ai_peek_key.mode == 2 then
        if ai_peek_key_pressed and not last_ai_peek_key_state then
            key = not key
        end
    else
        key = is_key_held(menu_ai_peek_key.value)
    end

    last_ai_peek_key_state = ai_peek_key_pressed
end

local function ai_peek_on_paint()
    handle_ai_key_state()
    if min_dmg_toggle then
        default_min_damage = menu_default_override_min_dmg.value
    else
        default_min_damage = menu_default_min_dmg.value
    end
    peek_key = menu_ai_peek_key.value
    peek_offset = menu_ai_peek_offset.value
    peek_limit_meters = menu_ai_peek_limit.value
    peek_limit_units = peek_limit_meters * units_per_meter

        local ply = entitylist.get_local_player_pawn()
    local ctrl= entitylist.get_local_player_controller()
    if not ply or not ctrl or not ply:is_alive() or not ply:is_on_ground() then
        if peek_state~="idle" then engine.execute_client_cmd("-left") engine.execute_client_cmd("-right") peek_state,peek_start_pos="idle",nil end
        return
    end

    local wep = ply.m_pWeaponServices.m_hActiveWeapon
    if wep and (wep.m_bInReload or (wep.m_nNextPrimaryAttackTick and ctrl.m_nTickBase < wep.m_nNextPrimaryAttackTick)) then
        if peek_state~="idle" then engine.execute_client_cmd("-left") engine.execute_client_cmd("-right") peek_state,peek_start_pos="idle",nil end
        return
    end

    local eye_pos = ply:get_eye_position(true)
    local _, rvec = math.angle_vectors(view_angles)
    local left_org = eye_pos - rvec * peek_offset
    local right_org= eye_pos + rvec * peek_offset

    if peek_state=="peeking" and peek_start_pos then
        if vec_length(vec_sub(ply:get_abs_origin(), peek_start_pos)) >= peek_limit_units then
            engine.execute_client_cmd("-left") engine.execute_client_cmd("-right") peek_state,peek_start_pos="idle",nil
            return
        end
    end

    local candidates = {}
    entitylist.get_entities("C_CSPlayerPawn", function(ent)
        if not ent or ent==ply or ent:is_dormant() or not ent:is_alive() or ply:is_teammate(ent) then return end
        if not ent.m_bTakesDamage then return end
        local fov = math.calc_fov(view_angles, math.calc_angle(eye_pos, ent:get_eye_position(true)))
        table.insert(candidates, {ent=ent, fov=fov})
    end)
    table.sort(candidates, function(a,b) return a.fov < b.fov end)

    local left_ok, right_ok = false,false
    for i=1, math.min(4,#candidates) do
        local t = candidates[i].ent
        local need= math.min(default_min_damage, t.m_iHealth)
        for _,b in ipairs(bones) do
            local p = t:get_bone_pos(b)
            if b==6 then p.z = p.z + 4 end
            local hl = engine.trace_bullet(ply, left_org, p)
            local hr = engine.trace_bullet(ply, right_org,p)
            if visualize then render.point(p, (hl and hl>=need) or (hr and hr>=need)) end
            if hl and hl>=need then left_ok=true end
            if hr and hr>=need then right_ok=true end
        end
    end

    local key = is_key_held(peek_key)
    if peek_state=="idle" then
        if key and (left_ok or right_ok) then
            peek_state="peeking"
            peek_dir  = left_ok and -1 or 1
            peek_start_pos = ply:get_abs_origin()
            engine.execute_client_cmd(peek_dir==-1 and "+left" or "+right")
        end
    else
        if not key or not (left_ok or right_ok) then
            engine.execute_client_cmd("-left") engine.execute_client_cmd("-right")
            peek_state,peek_start_pos = "idle",nil
        end
    end
end

local prev_preserve_killfeed = menu_preserve_killfeed.value
local last_pitch_value = nil

print("[Singularity] Script loaded!")

register_callback("paint", function()
    if menu_anti_aim_pitch.value ~= last_pitch_value then
        menu.ragebot_anti_aim_pitch = menu_anti_aim_pitch.value - 1
    end
    last_pitch_value = menu_anti_aim_pitch.value

    update_min_dmg_toggle()

    check_player_state()

    if menu_indicators.value[1] then
        draw_player_state()
    end

    anti_aim_handler()

    if menu_ai_peek_enabled.value then
        ai_peek_on_paint()
    end

    if menu_duck_peek_assist_enabled then
        handle_duck_assist()
    end

    if menu_preserve_killfeed.value then
        preserveKillfeedFuncOnPaint()
    else
        preserveKillfeed(true);
        if prev_preserve_killfeed then
            bClear = true;
        end
    end
    prev_preserve_killfeed = menu_preserve_killfeed.value

    if menu_slowdown_indicator.value then
        toDraw()
    end

    if menu_adaptive_auto_strafer_enabled.value then
        adaptive_autostrafe()
    end

    if menu_firstperson_on_utilities.value then
        firstperson_on_utilities()
    end

    prev_wallbangs_file_path = wallbangs_file_path
    if prev_wallbangs_file_path ~= "nix\\scripts\\" .. wallbang_helper_files[menu_wallbang_helper_file.value] then
        load_locations()
        wallbangs_file_path = "nix\\scripts\\" .. wallbang_helper_files[menu_wallbang_helper_file.value]
    end
    if menu_wallbang_helper_enabled.value then
        wallbang_helper()
    end

    if menu_bullet_tracers_enabled.value then
        fnOnPaint()
    end

    if menu_0_pitch_on_land_enabled.value then
        zero_pitch_on_land()
    end

    if menu_air_flick_enabled.value then
        air_flick()
    end

    if menu_watermark_enabled.value then
        draw_watermark()
    end

    if menu_disable_ragebot_in_air_enabled.value then
        disable_ragebot_in_air()
    end

    if menu_custom_scope_enabled.value then
        customeScope()
    end

    if menu_local_player_glow_enabled.value then
        apply_glow_to_local_player()
    end

    if menu_thirdperson_distance then
        engine.execute_client_cmd("cam_idealdist " .. menu_thirdperson_distance.value)
    end

    if menu_indicators.value[2] then
        manualaaind.draw_indicator()
    end

    if menu_auto_thirdperson_spectate_enabled.value then
        auto_thirdperson_spectate()
    end

    if menu_custom_menu_color_enabled.value then
        menu_accents_color = menu_custom_menu_color_enabled.color_value
    else
        menu_accents_color = color_t(161/255, 110/255, 228/255, 1)
    end

    apply_custom_fov()
    handle_keyboard_input()
end)

loadSettings()

register_callback("unload", function()
    saveSettings()
    bClear = true;
    preserveKillfeed(true);
    if is_ducking then engine.execute_client_cmd("-duck") end
    menu.ragebot_anti_aim_base_yaw_offset = default_yaw_offset
    menu.ragebot_auto_strafer = default_auto_strafer

    if left_active  then engine.execute_client_cmd("-left")  end
    if right_active then engine.execute_client_cmd("-right") end

    local m_iDesiredFOV = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_iDesiredFOV")
    local local_player_controller = entitylist.get_local_player_controller()
    if local_player_controller then
        ffi.cast("int*", local_player_controller[m_iDesiredFOV])[0] = 90
    end

    logs = {}

    print("[Singularity] Script unloaded!")
end)