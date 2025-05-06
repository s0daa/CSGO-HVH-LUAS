-- Libraries

local vector        = require "vector"
local csgo_weapons  = require "gamesense/csgo_weapons"
local ease          = require "gamesense/easing"
local anti_aim      = require "gamesense/antiaim_funcs"
local trace         = require "gamesense/trace"
--local notify        = require "notify"
local clipboard     = require "gamesense/clipboard"
local http          = require "gamesense/http"
local images        = require "gamesense/images"
local ffi           = require "ffi"
local base64        = require"gamesense/base64"

-- Globals

local username = _G.obex_name == nil and 't0ggle' or _G.obex_name:lower()
local build = _G.obex_build == nil and 'debug' or _G.obex_build:lower()
if build == "User" then
    build = "live"
end
local update_date = "11/07/22"
local version = "1.4"
lastswap = 0


local kenzo = {}

kenzo.database = {
    configs = ":kenzo-yaw::configs:",
    locations = ":kenzo-yaw::locations:"
}

kenzo.presets = {}

kenzo.locations     = database.read(kenzo.database.locations) or {}

kenzo.locations.keybinds = kenzo.locations.keybinds or vector(300, 400)

print(kenzo.locations.keybinds)

kenzo.antiaim       = {
    states          = {"Default", "Standing", "Moving", "Ducking", "Air", "Air Duck", "Slowwalk", "Use", "Freestanding"},
    state           = "Default"
}

kenzo.visuals       = {
    indicators      = {},
    keybinds        = {
        bind_list   = { "Double tap", "Hide shots", "Quick peek assist", "Force body aim", "Force safe point", "Fakeduck", "Freestanding", "Ping spike" },
        ref_list    = {ui.reference("rage", "aimbot", "double tap")},
        pos         = kenzo.locations.keybinds,
        dragging    = false,
        in_drag     = false,
        hovering    = false,
        bind_mode   = { "always on", "holding", "toggled", "off hotkey" },
        width       = 0,
        height      = 20,
        opacity     = 0,
        padding     = 20,
        binds       = {},
        title       = "Keybinds"
    }
}

kenzo.ui            = {
    aa              = {
        state       = {},
        states      = {}
    },
    config         = {},
    rage           = {},
    misc           = {},
    visuals        = {},
    colours        = {}
}

kenzo.handlers      = {
    ui              = {
        elements    = {},
        config      = {}
    },
    aa              = {
        state       = {}
    },
    rage            = {},
    visuals         = {},
    misc            = {}
}

kenzo.refs          = {
    aa              = {},
    fakelag         = {},
    rage            = {},
    misc            = {}
}

local screen = vector(client.screen_size())
local center = vector(screen.x/2, screen.y/2)

-- References

kenzo.refs.aa.master                                            = ui.reference("AA", "Anti-aimbot angles", "Enabled")
kenzo.refs.aa.yaw_base                                          = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
kenzo.refs.aa.pitch                                             = ui.reference("AA", "Anti-aimbot angles", "Pitch")
kenzo.refs.aa.yaw, kenzo.refs.aa.yaw_offset                     = ui.reference("AA", "Anti-aimbot angles", "Yaw")
kenzo.refs.aa.yaw_jitter, kenzo.refs.aa.yaw_jitter_offset       = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
kenzo.refs.aa.body_yaw, kenzo.refs.aa.body_yaw_offset           = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
kenzo.refs.aa.freestanding_body_yaw                             = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
kenzo.refs.aa.edge_yaw                                          = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
kenzo.refs.aa.freestanding, kenzo.refs.aa.freestanding_key      = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
kenzo.refs.aa.roll_offset                                       = ui.reference("AA", "Anti-aimbot angles", "Roll")

kenzo.refs.misc.hide_shots, kenzo.refs.misc.hide_shots_key      = ui.reference("AA", "Other", "On shot anti-aim")
kenzo.refs.misc.fakeducking                                     = ui.reference("RAGE", "Other", "Duck peek assist")
kenzo.refs.misc.legs                                            = ui.reference("AA", "Other", "Leg movement")
kenzo.refs.misc.slow_motion, kenzo.refs.misc.slow_motion_key    = ui.reference("AA", "Other", "Slow motion")
kenzo.refs.misc.menu_color                                      = ui.reference("Misc", "Settings", "Menu color")

kenzo.refs.rage.double_tap, kenzo.refs.rage.double_tap_key      = ui.reference("RAGE", "aimbot", "Double tap")
kenzo.refs.rage.sv_maxusrcmdprocessticks                        = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks2")

kenzo.refs.fakelag.enable, kenzo.refs.fakelag.enable_key        = ui.reference("AA", "Fake lag", "Enabled")
kenzo.refs.fakelag.limit                                        = ui.reference("AA", "Fake lag", "Limit")
kenzo.refs.fakelag.type                                         = ui.reference("AA", "Fake lag", "Amount")
kenzo.refs.fakelag.variance                                     = ui.reference("AA", "Fake lag", "Variance")

ui.set_visible(kenzo.refs.fakelag.limit, true)
ui.set_visible(kenzo.refs.rage.sv_maxusrcmdprocessticks, true)

local function colour_console(prefix, text, string)
    client.color_log(prefix[1], prefix[2], prefix[3], "Kenzo - \0")
    client.color_log(text[1], text[2], text[3], string)
end
local col = {
    kenzo_blue = {
        178, 163, 236
    },
    kenzo_white = {
        207, 207, 207
    },
    kenzo_red = {
        255, 100, 100
    },
    kenzo_darkblue = {
        10, 145, 255
    },
    kenzo_green = {
        0, 255, 21
    },
    kenzo_pink = {
        255, 154, 255
    }
}
-- UI handler
kenzo.handlers.ui.new = function(element, condition, config, callback)
    condition = condition or true
    config = config or false
    callback = callback or function() end

    local update = function()
        for k, v in pairs(kenzo.handlers.ui.elements) do
            if type(v.condition) == "function" then
                ui.set_visible(v.element, v.condition())
            else
                ui.set_visible(v.element, v.condition)
            end
        end
    end

    table.insert(kenzo.handlers.ui.elements, { element = element, condition = condition})

    if config then
        table.insert(kenzo.handlers.ui.config, element)
    end

    ui.set_callback(element, function(value)
        update()
        callback(value)
    end)

    update()

    return element
end

-- Useful Functions
function contains(t, v)
    for i, vv in pairs(t) do
        if vv == v then
            return true
        end
    end
    return false
end

split = function(string, sep)
    local result = {}
    for str in (string):gmatch("([^"..sep.."]+)") do
        table.insert(result, str)
    end
    return result
end

function set_aa_visibility(visible)
    for k, v in pairs(kenzo.refs.aa) do
        ui.set_visible(v, visible)
    end
end

function get_config(name)
    local database = database.read(kenzo.database.configs) or {}

    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    for i, v in pairs(kenzo.presets) do
        if v.name == name then
            return {
                config = base64.decode(v.config),
                index = i
            }
        end
    end

    return false
end

function save_config(name)
    local db = database.read(kenzo.database.configs) or {}
    local config = {}

    if name:match("[^%w]") ~= nil then
        return
    end

    for _, v in pairs(kenzo.handlers.ui.config) do
        local val = ui.get(v)

        if type(val) == "table" then
            if #val > 0 then
                val = table.concat(val, "|")
            else
                val = nil
            end
        end

        table.insert(config, tostring(val))
    end

    local cfg = get_config(name)

    if not cfg then
        table.insert(db, { name = name, config = table.concat(config, ":") })
    else
        db[cfg.index].config = table.concat(config, ":")
    end

    database.write(kenzo.database.configs, db)
end

function delete_config(name)
    local db = database.read(kenzo.database.configs) or {}

    for i, v in pairs(db) do
        if v.name == name then
            table.remove(db, i)
            break
        end
    end

    for i, v in pairs(kenzo.presets) do
        if v.name == name then
            return false
        end
    end

    database.write(kenzo.database.configs, db)
end

function get_config_list()
    local database = database.read(kenzo.database.configs) or {}
    local config = {}
    local presets = kenzo.presets

    for i, v in pairs(presets) do
        table.insert(config, v.name)
    end

    for i, v in pairs(database) do
        table.insert(config, v.name)
    end

    return config
end

function config_tostring()
    local config = {}
    for _, v in pairs(kenzo.handlers.ui.config) do
        local val = ui.get(v)
        if type(val) == "table" then
            if #val > 0 then
                val = table.concat(val, "|")
            else
                val = nil
            end
        end
        table.insert(config, tostring(val))
    end

    return table.concat(config, ":")
end

function load_settings(config)
    local type_from_string = function(input)
        if type(input) ~= "string" then return input end

        local value = input:lower()

        if value == "true" then
            return true
        elseif value == "false" then
            return false
        elseif tonumber(value) ~= nil then
            return tonumber(value)
        else
            return tostring(input)
        end
    end

    config = split(config, ":")

    for i, v in pairs(kenzo.handlers.ui.config) do
        if string.find(config[i], "|") then
            local values = split(config[i], "|")
            ui.set(v, values)
        else
            ui.set(v, type_from_string(config[i]))
        end
    end
end

function export_settings()
    local config = config_tostring()
    local encoded = base64.encode(config)
    clipboard.set(encoded)
end

function import_settings()
    local config = clipboard.get()
    local decoded = base64.decode(config)
    load_settings(decoded)
end

function load_config(name)
    local config = get_config(name)
    load_settings(config.config)
    if name == "*t0ggle" and not build == "Debug" then
        hide_t0g = true
    else
        hide_t0g = false
    end
    return hide_t0g
end

-- Menu Elements

kenzo.ui.aa.master = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "Enable \a9ED8FFFFK E N Z O"))

kenzo.ui.tab = kenzo.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "- \a9ED8FFFFKenzo Menu", {"Anti-Aim", "Rage", "Visuals", "Misc", "Colours", "Config"}), function()
     return ui.get(kenzo.ui.aa.master) 
end)


kenzo.ui.aa.manual_on = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\a9ED8FFFFEnable - \aCCCACAFFManual AA"), function() return ui.get(kenzo.ui.tab) == "Anti-Aim" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.aa.manual_jitter = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", " > \a9ED8FFFFManual - \aCCCACAFFUse jitter"), function() return ui.get(kenzo.ui.tab) == "Anti-Aim" and ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.aa.manual_on) end)
kenzo.ui.aa.manual_forward = kenzo.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " > \a9ED8FFFFManual - \aCCCACAFFForward", false), function() return ui.get(kenzo.ui.tab) == "Anti-Aim" and ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.aa.manual_on) end)
kenzo.ui.aa.manual_back = kenzo.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " > \a9ED8FFFFManual - \aCCCACAFFBack", false), function() return ui.get(kenzo.ui.tab) == "Anti-Aim" and ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.aa.manual_on) end)
kenzo.ui.aa.manual_left = kenzo.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " > \a9ED8FFFFManual - \aCCCACAFFLeft", false), function() return ui.get(kenzo.ui.tab) == "Anti-Aim" and ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.aa.manual_on) end)
kenzo.ui.aa.manual_right = kenzo.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " > \a9ED8FFFFManual - \aCCCACAFFRight", false), function() return ui.get(kenzo.ui.tab) == "Anti-Aim" and ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.aa.manual_on) end)
local lol = ui.new_hotkey("AA", "Fake lag", "aaa")

kenzo.ui.aa.anti_backstab = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\a9ED8FFFFEnable - \aCCCACAFFAnti backstab"), function() return ui.get(kenzo.ui.tab) == "Anti-Aim" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.aa.anti_backstab_distance = kenzo.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\a9ED8FFFFAnti backstab - \aCCCACAFFDistance", 50, 400, 180, true, "u", 1, true), function() return ui.get(kenzo.ui.tab) == "Anti-Aim" and ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.aa.anti_backstab) end)

kenzo.ui.aa.fixes = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\a9ED8FFFFEnable - \aCCCACAFFFixes"), function() return ui.get(kenzo.ui.tab) == "Anti-Aim" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.aa.hs_fix = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", " > \a9ED8FFFFFixes - \aCCCACAFFHideshots"), function() return ui.get(kenzo.ui.tab) == "Anti-Aim" and ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.aa.fixes) end)


kenzo.ui.aa.state = kenzo.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "Player state", kenzo.antiaim.states), function() 
    return ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.tab) == "Anti-Aim"
end)

for k, v in pairs(kenzo.antiaim.states) do
    kenzo.ui.aa.states[v] = {}

    if v ~= "Default" then
        kenzo.ui.aa.states[v].master = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "Enable \a9ED8FFFF" .. v, false), function()
             return ui.get(kenzo.ui.aa.state) == v and ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.tab) == "Anti-Aim"
        end, true)
    end

    local show = function() return ui.get(kenzo.ui.aa.state) == v and ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.tab) == "Anti-Aim" and (v == "Default" and true or ui.get(kenzo.ui.aa.states[v].master)) end
    

    kenzo.ui.aa.states[v].pitch                 = kenzo.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\a9ED8FFFF" .. v .. " -\aCDCDCDFF" .. " Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}), function() return show() and not hide_t0g end, true)
    kenzo.ui.aa.states[v].yaw_base              = kenzo.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\a9ED8FFFF" .. v .. " -\aCDCDCDFF" .. " Yaw base", {"Local view", "At targets"}), function() return show() and not hide_t0g end, true)
    kenzo.ui.aa.states[v].yaw                   = kenzo.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\a9ED8FFFF" .. v .. " -\aCDCDCDFF" .. " Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}), function() return show() and not hide_t0g end, true)
    kenzo.ui.aa.states[v].yaw_offset_left       = kenzo.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles", "\a9ED8FFFF" .. v .. " -\aCDCDCDFF" .. " Yaw offset \a9ED8FFFFleft", -180, 180, 0, true, "°"), function() return show() and ui.get(kenzo.ui.aa.states[v].yaw) ~= "Off" and not hide_t0g end, true)
    kenzo.ui.aa.states[v].yaw_offset_right      = kenzo.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles", "\a9ED8FFFF" .. v .. " -\aCDCDCDFF" .. " Yaw offset \a9ED8FFFFright", -180, 180, 0, true, "°"), function() return show() and ui.get(kenzo.ui.aa.states[v].yaw) ~= "Off" and not hide_t0g end, true)
    kenzo.ui.aa.states[v].yaw_jitter            = kenzo.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\a9ED8FFFF" .. v .. " -\aCDCDCDFF" .. " Yaw jitter", {"Off", "Offset", "Center", "Random"}), function() return show() and not hide_t0g end, true)
    kenzo.ui.aa.states[v].yaw_jitter_offset     = kenzo.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles", "\n" .. v .. " - Yaw jitter", -180, 180, 0, true, "°"), function() return show() and ui.get(kenzo.ui.aa.states[v].yaw_jitter) ~= "Off" and not hide_t0g end, true)
    kenzo.ui.aa.states[v].body_yaw              = kenzo.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\a9ED8FFFF" .. v .. " -\aCDCDCDFF" .. " Body yaw", {"Off", "Opposite", "Jitter", "Static"}), function() return show() and not hide_t0g end, true)
    kenzo.ui.aa.states[v].body_yaw_offset       = kenzo.handlers.ui.new  (ui.new_slider("AA", "Anti-aimbot angles", "\n" .. v .. " - Body yaw offset", -180, 180, 0, true, "°"), function() return show() and ui.get(kenzo.ui.aa.states[v].body_yaw) ~= "Off" and ui.get(kenzo.ui.aa.states[v].body_yaw) ~= "Opposite" and not hide_t0g end, true)
    kenzo.ui.aa.states[v].freestanding_body_yaw = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\a9ED8FFFF" .. v .. " -\aCDCDCDFF" .. " Freestanding body yaw", false), function() return show() and ui.get(kenzo.ui.aa.states[v].body_yaw) ~= "Off" and not hide_t0g end, true)
    kenzo.ui.aa.states[v].roll                  = kenzo.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles", "\a9ED8FFFF" .. v .. " -\aCDCDCDFF" .. " Roll", -50, 50, 0, true, "°"), function() return show() and ui.get(kenzo.ui.aa.states[v].body_yaw) ~= "Off" and not hide_t0g end, true)
    kenzo.ui.aa.states[v].bruteforce            = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\a9ED8FFFF" .. v .. " -\aCDCDCDFF" .. " Anti bruteforce", false), function() return show() and ui.get(kenzo.ui.aa.states[v].body_yaw) ~= "Off" and not hide_t0g end, true)end
kenzo.ui.aa.config_loaded_lab = kenzo.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", "\a9ED8FFFFConfig - \aCDCDCDFFt0ggles settings are set to hide AA", false), function() return ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.tab) == "Anti-Aim"  and hide_t0g end)

kenzo.ui.aa.freestanding_disablers = kenzo.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "\a9ED8FFFFAdditional - \aCDCDCDFFFreestand disablers", "Use", "Air", "Moving", "Ducking", "Standing", "Slowwalk"), function() return ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.tab) == "Anti-Aim" end)
kenzo.ui.aa.freestanding_key = kenzo.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", "\a9ED8FFFFAdditional - \aCDCDCDFFFreestanding key", false), function() return ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.tab) == "Anti-Aim" end)

-- rage
kenzo.ui.rage.doubletap = kenzo.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "Doubletap enhancments", "Default", "Fast", "Unstable"), function()  return ui.get(kenzo.ui.tab) == "Rage" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.rage.force_defensive = kenzo.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", "Force Defensive", false), function() return ui.get(kenzo.ui.tab) == "Rage" and ui.get(kenzo.ui.aa.master) end)
-- visuals
kenzo.ui.visuals.indicator = kenzo.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "Indicator style", "-", "Main", "Simple", "Ideal yaw", "Clean"), function() return ui.get(kenzo.ui.tab) == "Visuals" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.visuals.logs = kenzo.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "Notification logs", "Hit", "Miss"), function() return ui.get(kenzo.ui.tab) == "Visuals" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.visuals.console_logs = kenzo.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "Console logs", "Hit", "Miss"), function() return ui.get(kenzo.ui.tab) == "Visuals" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.visuals.manual_arrows = kenzo.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "Manual arrows", "Small arrows", "Big arrows", "Ideal yaw", "Teamskeet"), function() return ui.get(kenzo.ui.tab) == "Visuals" and ui.get(kenzo.ui.aa.master) and ui.get(kenzo.ui.aa.manual_on) end)
kenzo.ui.visuals.additionals = kenzo.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "Additional", "Body yaw arrows", "Debug panel"), function() return ui.get(kenzo.ui.tab) == "Visuals" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.visuals.kb_combo = kenzo.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "Show keybinds", kenzo.visuals.keybinds.bind_list), function() return ui.get(kenzo.ui.tab) == "Visuals" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.visuals.animate = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "Animate scope effect"), function() return ui.get(kenzo.ui.tab) == "Visuals" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.visuals.adjust_padding = kenzo.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "Watermark padding", 0, 100, 15, false, "", 1), function() return ui.get(kenzo.ui.tab) == "Visuals" and ui.get(kenzo.ui.aa.master) end)
ui.set(kenzo.ui.visuals.animate, true)
-- misc
kenzo.ui.misc.clantag = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "Clan tag spammer"), function() return ui.get(kenzo.ui.tab) == "Misc" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.misc.advertise = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "Advertise watermark"), function() return ui.get(kenzo.ui.tab) == "Misc" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.misc.anims = kenzo.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "Animations", "0 pitch on land", "Static legs in air", "Leg breaker", "Slide legs"), function() return ui.get(kenzo.ui.tab) == "Misc" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.misc.zero_time = kenzo.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "0 pitch timer", 65, 180, 160, true, "_t", 1, true), function() return ui.get(kenzo.ui.tab) == "Misc" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.misc.fake_lag_opts = kenzo.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "Fake lag options", "-", "Fluctuate", "Choked", "Max"), function() return ui.get(kenzo.ui.tab) == "Misc" and ui.get(kenzo.ui.aa.master) end)


-- CONFIG ELEMENTS
kenzo.ui.config.list = kenzo.handlers.ui.new(ui.new_listbox("AA", "Anti-aimbot angles", "Configs", ""), function() 
    return ui.get(kenzo.ui.tab) == "Config" and ui.get(kenzo.ui.aa.master)
end)

--config name
kenzo.ui.config.name = kenzo.handlers.ui.new(ui.new_textbox("AA", "Anti-aimbot angles", "Config name", ""), function() 
    return ui.get(kenzo.ui.tab) == "Config" and ui.get(kenzo.ui.aa.master)
end)

--load
kenzo.ui.config.load = kenzo.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\a9ED8FFFFLoad", function() end), function() 
    return ui.get(kenzo.ui.tab) == "Config" and ui.get(kenzo.ui.aa.master)
end)

--save
kenzo.ui.config.save = kenzo.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\a9ED8FFFFSave", function() end), function() 
    return ui.get(kenzo.ui.tab) == "Config" and ui.get(kenzo.ui.aa.master)
end)

--delete
kenzo.ui.config.delete = kenzo.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\a9ED8FFFFDelete", function() end), function() 
    return ui.get(kenzo.ui.tab) == "Config" and ui.get(kenzo.ui.aa.master)
end)

--import
kenzo.ui.config.import = kenzo.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\a9ED8FFFFImport settings", function() end), function() 
    return ui.get(kenzo.ui.tab) == "Config" and ui.get(kenzo.ui.aa.master)
end)

-- export
kenzo.ui.config.export = kenzo.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\a9ED8FFFFExport settings", function() end), function() 
    return ui.get(kenzo.ui.tab) == "Config" and ui.get(kenzo.ui.aa.master)
end)
--[[
kenzo.ui.config.default = kenzo.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\a9ED8FFFFLoad Default Settings", function() end), function() 
    return ui.get(kenzo.ui.tab) == "Config" and ui.get(kenzo.ui.aa.master)
end)
]]
kenzo.ui.colours.watermark_lab, kenzo.ui.colours.watermark_highlight = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Highlight debug/watermark"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Highlight debug/watermark", 145, 154, 217, 255, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.colours.middle_build_lab, kenzo.ui.colours.middle_build = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Build indicator"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Build indicator", 145, 154, 217, 255, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.colours.kb_active_lab, kenzo.ui.colours.keybinds_active = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Keybinds active"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Keybinds active", 0, 255, 0, 255, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.colours.kb_inactive_lab, kenzo.ui.colours.keybinds_inactive = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Keybinds in active"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Keybinds inactive", 255, 0, 0, 255, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.colours.manual_lab, kenzo.ui.colours.manual = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Manual arrow active"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Manual arrow active", 145, 154, 217, 255, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.colours.manual_lab_off, kenzo.ui.colours.manual_off = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Manual arrow inactive"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Manual arrow inactive", 98, 98, 98, 100, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.colours.desync_side_lab, kenzo.ui.colours.desync_side = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Active desync side"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Active desync side", 145, 154, 217, 255, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.colours.desync_side_off_lab, kenzo.ui.colours.desync_side_off = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Inactive desync side"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "inactive desync side", 255, 255, 255, 255, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.colours.desync_bar_lab, kenzo.ui.colours.desync_bar = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Desync gradient"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Desync gradient", 198, 191, 224, 205, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.colours.keybindlist_on_lab, kenzo.ui.colours.keybindlist_on = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Keybind list keystate text"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Keybind list keystate text", 198, 191, 224, 255, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.colours.keybindlist_rect_lab, kenzo.ui.colours.keybindlist_rect = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Keybind list bar"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Keybind list bar", 198, 191, 224, 255, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.colours.notif_hit_lab, kenzo.ui.colours.notif_hit = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Notification hit"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Notification hit", 145, 154, 217, 255, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)
kenzo.ui.colours.notif_miss_lab, kenzo.ui.colours.notif_miss = kenzo.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "Notification miss"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end), kenzo.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Notification miss", 255, 0, 0, 255, true), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)


kenzo.ui.colours.manual_pulse = kenzo.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "Pulsate manual aa arrows"), function() return ui.get(kenzo.ui.tab) == "Colours" and ui.get(kenzo.ui.aa.master) end)


distance_knife = {}
distance_knife.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

kenzo.handlers.aa.anti_backstab = function()
    if ui.get(kenzo.ui.aa.anti_backstab) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if players == nil then return end
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = distance_knife.anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(kenzo.ui.aa.anti_backstab_distance) then
                ui.set(kenzo.refs.aa.yaw_offset, 180)
                ui.set(kenzo.refs.aa.pitch, "Off")
                ui.set(kenzo.refs.aa.yaw_base, "At targets")
            end
        end
    end
end

function init_database()
    if database.read(kenzo.database.configs) == nil then
        database.write(kenzo.database.configs, {})
    end

    local user, token = "aston12421", "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"

    http.get("https://raw.githubusercontent.com/aston12421/kenzo/main/presets.json?token=", {authorization = {user, token}}, function(success, response)
        if not success then
            print("Failed to get presets")
            return
        end
    
        presets = json.parse(response.body)
    
        for i, preset in pairs(presets.presets) do
            table.insert(kenzo.presets, { name = "*"..preset.name, config = preset.config})
        end
    
        ui.update(kenzo.ui.config.list, get_config_list())
    end)
end

init_database()

local swap__yaw = globals.realtime()
local swapyaw = false
local function swap_yaw(val1, val2)
    if swap__yaw < globals.realtime() then
        if swapyaw then
            swapyaw = false
            ui.set(kenzo.refs.aa.yaw_offset, tonumber(val1)) 
        else
            swapyaw = true
            ui.set(kenzo.refs.aa.yaw_offset, tonumber(val2))
        end
        swap__yaw = globals.realtime()
    end
end

local notify = {
    notifications = {
        side = {},
        bottom = {}
    },
    max = {
        side = 11,
        bottom = 6
    }
}

notify.__index = notify

local warning = images.get_panorama_image("icons/ui/warning.svg")

local screen_size = function()
    return vector(client.screen_size())
end

local measure_text = function(flags, ...)
    local args = {...}
    local string = table.concat(args, "")

    return vector(renderer.measure_text(flags, string))
end

notify.queue_bottom = function()
    if #notify.notifications.bottom <= notify.max.bottom then
        return 0
    end
    return #notify.notifications.bottom - notify.max.bottom
end

notify.queue_side = function()
    if #notify.notifications.side <= notify.max.side then
        return 0
    end
    return #notify.notifications.side - notify.max.side
end

notify.clear_bottom = function()
    for i=1, notify.queue_bottom() do
        table.remove(notify.notifications.bottom, #notify.notifications.bottom)
    end
end

notify.clear_side = function()
    for i=1, notify.queue_side() do
        table.remove(notify.notifications.side, #notify.notifications.side)
    end
end



notify.new_bottom = function(timeout, color, title, ...)
    table.insert(notify.notifications.bottom, {
        started = false,
        instance = setmetatable({
            ["active"]  = false,
            ["timeout"] = timeout,
            ["color"]   = { r = color[1], g = color[2], b = color[3], a = 0 },
            ["x"]       = screen_size().x/2,
            ["y"]       = screen_size().y,
            ["text"]    = {...},
            ["title"]   = title,
            ["type"]    = "bottom"
        }, notify)
    })
end

notify.new_side = function(timeout, color, title, ...)
    table.insert(notify.notifications.side, {
        started = false,
        instance = setmetatable({
            ["active"]  = false,
            ["timeout"] = timeout,
            ["color"]   = { r = color[1], g = color[2], b = color[3], a = 0 },
            ["x"]       = screen_size().x,
            ["y"]       = screen_size().y / 5,
            ["text"]    = {...},
            ["title"]   = title,
            ["type"]    = "side"
        }, notify)
    })
end

function notify:handler()

    local side_count = 0
    local side_visible_amount = 0

    for index, notification in pairs(notify.notifications.side) do
        if not notification.instance.active and notification.started then
            table.remove(notify.notifications.side, index)
        end
    end

    for i = 1, #notify.notifications.side do
        if notify.notifications.side[i].instance.active then
            side_visible_amount = side_visible_amount + 1
        end
    end

    for index, notification in pairs(notify.notifications.side) do

        if index > notify.max.side then
            goto skip
        end
        
        if notification.instance.active then
            notification.instance:render_side(side_count, side_visible_amount)
            side_count = side_count + 1
        end

        if not notification.started then
            notification.instance:start()
            notification.started = true
        end

    end

    local bottom_count = 0
    local bottom_visible_amount = 0

    for index, notification in pairs(notify.notifications.bottom) do
        if not notification.instance.active and notification.started then
            table.remove(notify.notifications.bottom, index)
        end
    end

    for i = 1, #notify.notifications.bottom do
        if notify.notifications.bottom[i].instance.active then
            bottom_visible_amount = bottom_visible_amount + 1
        end
    end

    for index, notification in pairs(notify.notifications.bottom) do

        if index > notify.max.bottom then
            goto skip
        end
        
        if notification.instance.active then
            notification.instance:render_bottom(bottom_count, bottom_visible_amount)
            bottom_count = bottom_count + 1
        end

        if not notification.started then
            notification.instance:start()
            notification.started = true
        end

    end
    
    

    ::skip::
end

function notify:start()
    self.active = true
    self.delay = globals.realtime() + self.timeout
end

function notify:width()

    local w = 0
    
    local title_width = measure_text("b", self.title).x
    local warning_x, warning_y = warning:measure(nil, 15)

    for _, line in pairs(self.text) do
        local line_width = measure_text("", line).x
        w = w + line_width + 3
    end

    return math.max(w, title_width + warning_x + 5)
end

function notify:render_text(x, y)
    local x_offset = 0
    local padding = 3

    for i, line in pairs(self.text) do
        if i % 2 ~= 0 then
            r, g, b = 200, 200, 210
        else
            r, g, b = self.color.r, self.color.g, self.color.b
        end
        renderer.text(x + x_offset, y, r, g, b, self.color.a, "", 0, line)
        x_offset = x_offset + measure_text("", line).x + padding
    end
end

local renderer_rectangle_rounded = function(x, y, w, h, r, g, b, a, radius)
	y = y + radius
	local datacircle = {
		{x + radius, y, 180},
		{x + w - radius, y, 90},
		{x + radius, y + h - radius * 2, 270},
		{x + w - radius, y + h - radius * 2, 0},
	}

	local data = {
		{x + radius, y, w - radius * 2, h - radius * 2},
		{x + radius, y - radius, w - radius * 2, radius},
		{x + radius, y + h - radius * 2, w - radius * 2, radius},
		{x, y, radius, h - radius * 2},
		{x + w - radius, y, radius, h - radius * 2},
	}

	for _, data in pairs(datacircle) do
		renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
	end

	for _, data in pairs(data) do
	   renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
	end
end


function notify:render_side(index, visible_amount)

    local screen = screen_size()
    local x, y = self.x - 5, self.y
    local padding = 10
    local w, h = self:width() + padding*2, 40 + padding*2

    if globals.realtime() < self.delay then
        self.y = ease.quad_out(0.05, self.y, (( screen.y / 5 ) - ( (index - (visible_amount)) * h*1.2 )) - self.y, 1)
        self.x = ease.quad_out(0.05, self.x, ( screen.x - w - 5 ) - self.x, 1)
        self.color.a = ease.quad_in(0.15, self.color.a, 255 - self.color.a, 1)
    else
        self.x = ease.quad_in(0.1, self.x, screen.x - self.y, 1)
        self.color.a = ease.quad_in(0.3, self.color.a, 0 - self.color.a, 1)

        if self.x >= screen.x - 10 then
            self.active = false
        end
    end


    renderer_rectangle_rounded(x, y, w, h, 25, 25, 32, self.color.a, 5)
    warning:draw(x + padding, y + padding, nil, 15, self.color.r, self.color.g, self.color.b, self.color.a)
    renderer.text(x + padding*1.5 + warning:measure(nil, 15), y + padding, self.color.r, self.color.g, self.color.b, self.color.a, "b", 0, self.title)
    self:render_text(x + padding, y + h - padding*2 - measure_text("", table.concat(self.text, " ")).y/2)
end

function notify:render_bottom(index, visible_amount)
    local screen = screen_size()
    local x, y = self.x - 5, self.y
    local padding = 10
    local w, h = self:width() + padding + 25, 20 + padding

    if globals.realtime() < self.delay then
        self.y = ease.quad_out(0.05, self.y, (( screen.y - 5 ) - ( (visible_amount - index) * h*1.4 )) - self.y, 1)
        self.color.a = ease.quad_in(0.18, self.color.a, 255 - self.color.a, 1)
    else
        self.y = ease.quad_in(0.1, self.y, screen.y - self.y, 1)
        self.color.a = ease.quad_out(0.07, self.color.a, 0 - self.color.a, 1)

        if self.color.a <= 2 then
            self.active = false
        end
    end

    
    local progress = math.max(0, (self.delay - globals.realtime()) / self.timeout)
    local bar_width = (w-10) * progress
    renderer_rectangle_rounded(x - w/2, y, w, h, 25, 25, 32, self.color.a, 5)

    renderer.circle_outline(x + w/2 - 5 - padding, y + padding + 5, 15, 15, 22, self.color.a, 5, 0, 1, 2)
    renderer.circle_outline(x + w/2 - 5 - padding, y + padding + 5, self.color.r, self.color.g, self.color.b, self.color.a, 5, 0, progress, 2)
    self:render_text(x - w/2 + padding, y + h/2 - measure_text("", table.concat(self.text, " ")).y/2)
end

function logo()
    local logo = {
        " ___  ____   ________  ____  _____  ________    ___      ______   ________  ____   ____",
        " |_  ||_  _| |_   __  ||_   \\|_   _||  __   _| .'   `.   |_   _ `.|_   __  ||_  _| |_  _|",
        "   | |_/ /     | |_ \\_|  |   \\ | |  |_/  / /  /  .-.  \\    | | `. \\ | |_ \\_|  \\ \\   / /",
        "   |  __'.     |  _| _   | |\\ \\| |     .'.' _ | |   | |    | |  | | |  _| _    \\ \\ / /",
        "  _| |  \\ \\_  _| |__/ | _| |_\\   |_  _/ /__/ |\\  `-'  /_  _| |_.' /_| |__/ |    \\ ' /",
        " |____||____||________||_____|\\____||________| `.___.'(_)|______.'|________|     \\_/ \n"
                                                                                                 
    }

    client.exec("clear")
    for _, line in pairs(logo) do
        client.color_log(178/6*_, 163/6 * _, 236/6 * _, line)
    end

    colour_console(col.kenzo_blue, col.kenzo_white, "Logged in as \0")
    client.color_log(col.kenzo_blue[1], col.kenzo_blue[2], col.kenzo_blue[3], username .. " | " .. build)
    --colour_console(col.kenzo_blue, col.kenzo_white, "User build \0")
    --client.color_log(col.kenzo_blue[1], col.kenzo_blue[2], col.kenzo_blue[3], build)
    --colour_console(col.kenzo_blue, col.kenzo_white, "Last update \0")
    --client.color_log(col.kenzo_blue[1], col.kenzo_blue[2], col.kenzo_blue[3], update_date )

    notify.new_bottom(5, {ui.get(kenzo.refs.misc.menu_color)}, "KENZO | LOGIN", "Logged in as", username)
    notify.new_bottom(5, {ui.get(kenzo.refs.misc.menu_color)}, "KENZO | LOGIN", "Loaded:", "v" .. version, " | Build:", build)

end
logo()

-- ANTIAIM

local extend_vector = function(pos,length,angle)
    local rad = angle * math.pi / 180
    if rad == nil then return end
    if angle == nil or pos == nil or length == nil then return end
    return {pos[1] + (math.cos(rad) * length),pos[2] + (math.sin(rad) * length), pos[3]};
end

kenzo.handlers.aa.freestand_bodyyaw = function()
    local enemy = client.current_threat()
    local me = entity.get_local_player()
    if me == nil or entity.is_dormant(enemy) or enemy == nil or not entity.is_alive(me) then 
        sides = ""
        by = 0
        return 
    end
    -- Getting my activation arc
    pitch, yaw = client.camera_angles(me)
    left1 = extend_vector({entity.get_origin(me)},50,yaw + 110)
    left2 = extend_vector({entity.get_origin(me)},30,yaw + 60)
    right1 = extend_vector({entity.get_origin(me)},50,yaw - 110)
    right2 = extend_vector({entity.get_origin(me)},30,yaw - 60)

    -- Getting enemys activation arc
    pitch, yaw_e = entity.get_prop(enemy, "m_angEyeAngles")
    enemy_right1 = extend_vector({entity.get_origin(enemy)},40,yaw_e - 115)
    enemy_right2 = extend_vector({entity.get_origin(enemy)},20,yaw_e - 35)
    enemy_left1 = extend_vector({entity.get_origin(enemy)},40,yaw_e + 115)
    enemy_left2 = extend_vector({entity.get_origin(enemy)},20,yaw_e + 35)

    -- Tracing bullets from enemies arc to mine
    _, dmg_left1 =  client.trace_bullet(enemy, enemy_left1[1], enemy_left1[2], enemy_left1[3] + 70, left1[1], left1[2], left1[3] , true)
    _, dmg_right1 = client.trace_bullet(enemy, enemy_right1[1], enemy_right1[2], enemy_right1[3] + 70, right1[1], right1[2], right1[3], true)
    _, dmg_left2 =  client.trace_bullet(enemy, enemy_left2[1], enemy_left2[2], enemy_left2[3] + 30, left2[1], left2[2], left2[3], true)
    _, dmg_right2 = client.trace_bullet(enemy, enemy_right2[1], enemy_right2[2], enemy_right2[3] + 30, right2[1], right2[2], right2[3], true)

    if dmg_left1 > 0 or dmg_left2 > 0 or dmg_right1 > 0 or dmg_right2 > 0 then
        freestand_ = true
    end

    freestand_right = freestand_ and dmg_right1 > 0 or dmg_right2 > 0
    freestand_left = freestand_ and dmg_left1 > 0 or dmg_left2 > 0

    -- Detecting which side is inverted and not
    if freestand_right --[[and ui.get(kenzo.ui.aa.freestand_bodyyaw) == "Peek real"]] then
        freestand = 1
    elseif freestand_right --[[and ui.get(kenzo.ui.aa.freestand_bodyyaw) == "Peek desync"]] then
        freestand = -1
    elseif freestand_left --[[and ui.get(kenzo.ui.aa.freestand_bodyyaw) == "Peek real"]] then
        freestand = -1
    elseif freestand_left --[[and ui.get(kenzo.ui.aa.freestand_bodyyaw) == "Peek desync"]] then
        freestand = 1
    else
        freestand = 0
    end
    -- Gathering additional information for accurate conditions
    if dmg_left2 >= 1 or dmg_right1 >= 1 then
        sides = "peek"
    else
        sides = ""
    end
    if dmg_right2 > 0 then
        by = 2
    elseif dmg_left2 > 0 then
        by = -2
    elseif dmg_left1 > 0 then
        by = -1
    elseif dmg_right1 > 0 then
        by = 1
    elseif dmg_right1 > 0 and dmg_left1 > 0 then
        by = 0
    elseif dmg_right2 > 0 and dmg_left2 > 0 then
        by = 0
    else
        by = 0
    end
    -- Returing all information created
    return freestand, sides, by
end
local ground_ticks = 0
kenzo.handlers.aa.state.update = function(cmd)
    local me    = entity.get_local_player()
    local flags = entity.get_prop(me, "m_fFlags")
    local vel1, vel2, vel3 = entity.get_prop(me, 'm_vecVelocity')
    local speed = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))

    local ducking       = cmd.in_duck == 1
    local air           = ground_ticks < 5
    local walking       = speed >= 2
    local standing      = speed <= 1
    local slow_motion   = ui.get(kenzo.refs.misc.slow_motion) and ui.get(kenzo.refs.misc.slow_motion_key)
    local fakeducking   = ui.get(kenzo.refs.misc.fakeducking)
    local use           = on_use(cmd)
    local freestanding = ui.get(kenzo.ui.aa.freestanding_key) and not contains(ui.get(kenzo.ui.aa.freestanding_disablers), kenzo.antiaim.state)
    ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)

    local state = "Default"
    
    if use then
        state = "Use"
    elseif air and not ducking then
        state = "Air"
    elseif air and ducking then
        state = "Air Duck"
    elseif fakeducking or ducking then
        state = "Ducking"
    elseif slow_motion then
        state = "Slowwalk"
    elseif walking then
        state = "Moving"
    elseif standing then
        state = "Standing"
    elseif freestanding then
        state = "Freestanding"
    else
        state = "Default"
    end

    kenzo.antiaim.state = state
end

-- [[ Anti brute force ]] --
local lastmiss = 0
local function GetClosestPoint(A, B, P)
    a_to_p = { P[1] - A[1], P[2] - A[2] }
    a_to_b = { B[1] - A[1], B[2] - A[2] }

    atb2 = a_to_b[1]^2 + a_to_b[2]^2

    atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    t = atp_dot_atb / atb2
    
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end
local bruteforce_reset = true
local stage = 0
local shot_time = 0


client.set_event_callback("bullet_impact", function(e)
    state = kenzo.antiaim.state
    if ui.get(kenzo.ui.aa.master) == false and not ui.get(kenzo.ui.aa.states[state].bruteforce) then return end
    
    if not entity.is_alive(entity.get_local_player()) then return end
    local ent = client.userid_to_entindex(e.userid)
    if ent ~= client.current_threat() then return end
    if entity.is_dormant(ent) or not entity.is_enemy(ent) then return end

    local ent_origin = { entity.get_prop(ent, "m_vecOrigin") }
    ent_origin[3] = ent_origin[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
    local local_head = { entity.hitbox_position(entity.get_local_player(), 0) }
    local closest = GetClosestPoint(ent_origin, { e.x, e.y, e.z }, local_head)
    local delta = { local_head[1]-closest[1], local_head[2]-closest[2] }
    local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)

    if bruteforce then return end
    if math.abs(delta_2d) <= 35 and globals.curtime() - lastmiss > 0.015 then
        if ui.get(kenzo.ui.aa.states[state].bruteforce) then
        lastmiss = globals.curtime()
        bruteforce = true
        shot_time = globals.realtime()
        stage = stage >= 5 and 0 or stage + 1
        stage = stage == 0 and 1 or stage
        notify.new_bottom(1, {ui.get(kenzo.refs.misc.menu_color)},"", "Kenzo -", "anti brute due to shot [", tostring(stage), "]")
        end
    end
end)

local function Returner()
    brut3 = true

    return brut3
end

kenzo.handlers.aa.anti_brute = function(cmd)
    if bruteforce and ui.get(kenzo.ui.aa.states[state].bruteforce) then
        client.set_event_callback("paint_ui", Returner)
        bruteforce = false
        bruteforce_reset = false
        stage = stage == 0 and 1 or stage
        set_brute = true
    else
        if shot_time + 3 < globals.realtime() or not ui.get(kenzo.ui.aa.states[state].bruteforce) then
            client.unset_event_callback("paint_ui", Returner)
            set_brute = false
            brut3 = false
            stage = 0
            bruteforce_reset = true
            cmd.roll = 0
            set_brute = false

        end
    end
    return shot_time
end


client.set_event_callback("setup_command", function(cmd)
    
    if set_brute == false then return end
    if stage == 1 then
        --print("STAGE 1")
        ui.set(kenzo.refs.aa.yaw_jitter, "Center")
        ui.set(kenzo.refs.aa.yaw_jitter_offset, 53)
        ui.set(kenzo.refs.aa.body_yaw, "Jitter")
        if cmd.chokedcommands ~= 0 then
        else
            ui.set(kenzo.refs.aa.body_yaw_offset, 0)
            --ui.set(kenzo.refs.aa.yaw_offset, side == 1 and -10 or 11)
            swap_yaw("-10", "11")
        end
    elseif stage == 2 then
        ui.set(kenzo.refs.aa.yaw_jitter, "Center")
        ui.set(kenzo.refs.aa.yaw_jitter_offset, 28)
        ui.set(kenzo.refs.aa.body_yaw, "Jitter")
        if cmd.chokedcommands ~= 0 then
        else
            ui.set(kenzo.refs.aa.body_yaw_offset, 0)
            --ui.set(kenzo.refs.aa.yaw_offset, side == 1 and -23 or 20)
            swap_yaw("-23", "20")
        end
    elseif stage == 3 then
        ui.set(kenzo.refs.aa.yaw_jitter, "Center")
        ui.set(kenzo.refs.aa.yaw_jitter_offset, 36)
        ui.set(kenzo.refs.aa.body_yaw, "Jitter")
        if cmd.chokedcommands ~= 0 then
        else
            ui.set(kenzo.refs.aa.body_yaw_offset, 0)
            --ui.set(kenzo.refs.aa.yaw_offset, side == 1 and -12 or 17)
            swap_yaw("-12", "17")
        end
    elseif stage == 4 then
        ui.set(kenzo.refs.aa.yaw_jitter, "Center")
        ui.set(kenzo.refs.aa.yaw_jitter_offset, 28)
        ui.set(kenzo.refs.aa.body_yaw, "Jitter")
        if cmd.chokedcommands ~= 0 then
        else
            ui.set(kenzo.refs.aa.body_yaw_offset, 0)
            --ui.set(kenzo.refs.aa.yaw_offset, side == 1 and -7 or 10)
            swap_yaw("-7", "10")
        end
    elseif stage == 5 then
        ui.set(kenzo.refs.aa.yaw_jitter, "Center")
        ui.set(kenzo.refs.aa.yaw_jitter_offset, 50)
        ui.set(kenzo.refs.aa.body_yaw, "Jitter")
        if cmd.chokedcommands ~= 0 then
        else
            ui.set(kenzo.refs.aa.body_yaw_offset, 0)
            swap_yaw("-9", "3")
        end
    end
end)


on_use = function(cmd)

    local in_use = cmd.in_use == 1
    
    local me = entity.get_local_player()
    
    if not me or not entity.is_alive(me) then return end

    local weapon_ent = entity.get_player_weapon(me)

    if weapon_ent == nil then return end

    local weapon = csgo_weapons(weapon_ent)

    if weapon == nil then return end


    local local_pos     = vector(entity.get_origin(me))
    local in_bombzone   = entity.get_prop(me, "m_bInBombZone") > 0
    local holding_bomb  = weapon.type == "c4"

    local bomb_table    = entity.get_all("CPlantedC4")
    local bomb_planted  = #bomb_table > 0
    local bomb_distance = 100

    if bomb_planted then
        local bomb_entity = bomb_table[#bomb_table]
        local bomb_pos = vector(entity.get_origin(bomb_entity))
        bomb_distance = local_pos:dist(bomb_pos)
    end

    local defusing = bomb_distance < 62 and entity.get_prop(me, "m_iTeamNum") == 3

    if in_bombzone and holding_bomb or defusing then return end


	local from = vector(client.eye_position())
	local to = from + vector():init_from_angles(client.camera_angles()) * 1024

	local ray = trace.line(from, to, { skip = me, mask = "MASK_SHOT" })

    if not ray or ray.fraction > 1 or not ray.entindex then return end


    local ray_ent = pcall(function() entity.get_classname(ray.entindex) end) and entity.get_classname(ray.entindex) or nil

    if not ray_ent or ray_ent == nil then return end

    if ray_ent ~= "CWorld" and ray_ent ~= "CFuncBrush" and ray_ent ~= "CCSPlayer" then return end

    if in_use then
        if ui.get(kenzo.ui.aa.states["Use"].master) then
            cmd.in_use = 0
        end
        return true
    end
end

local function map(n, start, stop, new_start, new_stop)
    local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start

    return new_start < new_stop and math.max(math.min(value, new_stop), new_start) or math.max(math.min(value, new_start), new_stop)
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end
    

kenzo.handlers.aa.freestanding = function()
    local freestanding = ui.get(kenzo.ui.aa.freestanding_key) and not contains(ui.get(kenzo.ui.aa.freestanding_disablers), kenzo.antiaim.state)

    ui.set(kenzo.refs.aa.freestanding_key, freestanding and "Always on" or "On hotkey")
    ui.set(kenzo.refs.aa.freestanding, freestanding)
end
local timer_yaw = globals.realtime()

local varyaw = false
--kenzo.handlers.aa.set = function(cmd)

client.set_event_callback("setup_command", function(c)
    local state = kenzo.antiaim.state
    if state ~= "Default" and not ui.get(kenzo.ui.aa.states[state].master) then
        state = "Default"
    end
    ui.set(kenzo.refs.aa.pitch, ui.get(kenzo.ui.aa.states[state].pitch))
    ui.set(kenzo.refs.aa.yaw_base, ui.get(kenzo.ui.aa.states[state].yaw_base))
    ui.set(kenzo.refs.aa.yaw, ui.get(kenzo.ui.aa.states[state].yaw))
    ui.set(kenzo.refs.aa.yaw_jitter, ui.get(kenzo.ui.aa.states[state].yaw_jitter))
    ui.set(kenzo.refs.aa.yaw_jitter_offset, ui.get(kenzo.ui.aa.states[state].yaw_jitter_offset))
    ui.set(kenzo.refs.aa.body_yaw, ui.get(kenzo.ui.aa.states[state].body_yaw))
    ui.set(kenzo.refs.aa.body_yaw_offset, ui.get(kenzo.ui.aa.states[state].body_yaw_offset))
    ui.set(kenzo.refs.aa.freestanding_body_yaw, ui.get(kenzo.ui.aa.states[state].freestanding_body_yaw))
    ui.set(kenzo.refs.aa.roll_offset, ui.get(kenzo.ui.aa.states[state].roll))
--[[
    if cmd.chokedcommands == 0 and timer_yaw < globals.realtime() then
        if varyaw then
            varyaw = false
            ui.set(kenzo.refs.aa.yaw_offset, ui.get(kenzo.ui.aa.states[state].yaw_offset_right)) 
        else
            varyaw = true
            ui.set(kenzo.refs.aa.yaw_offset, ui.get(kenzo.ui.aa.states[state].yaw_offset_left))
        end
        timer_yaw = globals.realtime()
    end]]

    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	if c.chokedcommands ~= 0 then
	else
		ui.set(kenzo.refs.aa.yaw_offset,(side == 1 and ui.get(kenzo.ui.aa.states[state].yaw_offset_left) or ui.get(kenzo.ui.aa.states[state].yaw_offset_right)))
	end

	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
end)

-- Rage

kenzo.handlers.rage.handle = function(cmd)
    cmd.force_defensive = ui.get(kenzo.ui.rage.force_defensive) and 1 or 0
end

-- Visuals

local renderer_rounded_rectangle = function(x, y, w, h, r, g, b, a, radius)
	y = y + radius
	local datacircle = {
		{x + radius, y, 180},
		{x + w - radius, y, 90},
		{x + radius, y + h - radius * 2, 270},
		{x + w - radius, y + h - radius * 2, 0},
	}

	local data = {
		{x + radius, y, w - radius * 2, h - radius * 2},
		{x + radius, y - radius, w - radius * 2, radius},
		{x + radius, y + h - radius * 2, w - radius * 2, radius},
		{x, y, radius, h - radius * 2},
		{x + w - radius, y, radius, h - radius * 2},
	}

	for _, data in pairs(datacircle) do
		renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
	end

	for _, data in pairs(data) do
	   renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
	end
end


local render_glow_rectangle = function(x,y,w,h,r,g,b,a,round,size,g_w)
    for i = 1, size, 0.3 do
        local fixpositon = (i  - 1) * 2	 
        local fixi = i  - 1
        renderer_rounded_rectangle(x - fixi, y - fixi, w + fixpositon , h + fixpositon , r , g ,b , (a -  i * g_w) ,round)	
    end
end

local lerp = function(a, b, t)
    return a + (b - a) * t
end

local screen = vector(client.screen_size())
kenzo.visuals.indicators.pos = vector(screen.x/2, screen.y/2)

local inds = {
    {
        ref = kenzo.refs.rage.double_tap_key,
        name = "DT"
    },
    {
        ref = kenzo.refs.misc.hide_shots_key,
        name = "HS"
    }
}

local render_text = function(x, y, ...)
    local x_offset = 0

    local args = {...}

    for i, line in pairs(args) do
        local r, g, b, a, text = unpack(line)
        local size = vector(renderer.measure_text("", text))
        renderer.text(x + x_offset, y, r, g, b, a, "", 0, text)
        x_offset = x_offset + size.x
    end
end

local h = 0
local opacity = 0

kenzo.handlers.visuals.watermark = function()
    if ui.get(kenzo.ui.aa.master) == false then return end
    --local theme = {ui.get(kenzo.ui.visuals.theme)}
    local screen = vector(client.screen_size())
    local hr, m, s, mill = client.system_time()
    local time = string.format("%02d:%02d:%02d", hr, m, s)
    local watermark = "Kenzo - " .. string.lower(build) .. " / " .. string.lower(username) .. " | " .. time
    local size = vector(renderer.measure_text("", watermark))
    local water_mark = {ui.get(kenzo.ui.colours.watermark_highlight)}

    local player = entity.get_local_player()
    local steamid3 = entity.get_steam64(player)
    local avatar = images.get_steam_avatar(steamid3)

    local margin = 10 
    local padding = 10
    local w = size.x + padding + 20
    h = ease.quad_in(0.3, h, (ui.is_menu_open() and 40 + padding or 20) + padding/2 - h, 1)
    opacity = ease.quad_in(0.3, opacity, (ui.is_menu_open() and 255 or 0) - opacity, 1)

    local pos = vector(screen.x - w - margin, 0 + margin)
    local text_pos = vector(pos.x + padding/2 + 20, pos.y + size.y/2)

    if entity.get_local_player() ~= nil then
        adjust = 0
        renderer_rounded_rectangle(pos.x - ui.get(kenzo.ui.visuals.adjust_padding), pos.y + ui.get(kenzo.ui.visuals.adjust_padding), w - adjust, h, 25, 25, 32, 255, 5)
        avatar:draw(pos.x + padding/2 - ui.get(kenzo.ui.visuals.adjust_padding), text_pos.y + ui.get(kenzo.ui.visuals.adjust_padding), 15, 15)
        render_text(text_pos.x - adjust - ui.get(kenzo.ui.visuals.adjust_padding), text_pos.y + ui.get(kenzo.ui.visuals.adjust_padding), {255, 255, 255, 255, "Kenzo - "}, {water_mark[1], water_mark[2], water_mark[3], 255, build}, {255, 255, 255, 255, " / "}, {255, 255, 255, 255, username}, {255, 255, 255, 255, " | "}, {255, 255, 255, 255, time})

        render_text(pos.x + padding/2 - ui.get(kenzo.ui.visuals.adjust_padding), text_pos.y + size.y*1.5 + ui.get(kenzo.ui.visuals.adjust_padding), {255, 255, 255, opacity, "Current version - "}, {water_mark[1], water_mark[2], water_mark[3], opacity, version})
        render_text(pos.x + padding/2 - ui.get(kenzo.ui.visuals.adjust_padding), text_pos.y + size.y*2.5 + ui.get(kenzo.ui.visuals.adjust_padding), {255, 255, 255, opacity, "Last update - "}, {water_mark[1], water_mark[2], water_mark[3], opacity, update_date})
    else
        adjust = 20
        renderer_rounded_rectangle(pos.x - ui.get(kenzo.ui.visuals.adjust_padding), pos.y + ui.get(kenzo.ui.visuals.adjust_padding), w - adjust, h, 25, 25, 32, 255, 5)
        render_text(text_pos.x - adjust - ui.get(kenzo.ui.visuals.adjust_padding), text_pos.y + ui.get(kenzo.ui.visuals.adjust_padding), {255, 255, 255, 255, "Kenzo - "}, {water_mark[1], water_mark[2], water_mark[3], 255, build}, {255, 255, 255, 255, " / "}, {255, 255, 255, 255, username}, {255, 255, 255, 255, " | "}, {255, 255, 255, 255, time})

        render_text(pos.x + padding/2 - ui.get(kenzo.ui.visuals.adjust_padding), text_pos.y + size.y*1.5 + ui.get(kenzo.ui.visuals.adjust_padding), {255, 255, 255, opacity, "Current version - "}, {water_mark[1], water_mark[2], water_mark[3], opacity, version})
        render_text(pos.x + padding/2 - ui.get(kenzo.ui.visuals.adjust_padding), text_pos.y + size.y*2.5 + ui.get(kenzo.ui.visuals.adjust_padding), {255, 255, 255, opacity, "Last update - "}, {water_mark[1], water_mark[2], water_mark[3], opacity, update_date})
    end
end

-- KEYBINDS

--init bind list
for i, bind in ipairs(kenzo.visuals.keybinds.bind_list) do
    kenzo.visuals.keybinds.binds[bind] = {
        ["pos"] = vector(kenzo.locations.keybinds),
        ["opacity"] = 0,
        ["ref"] = kenzo.visuals.keybinds.ref_list[i]
    }
end

local function ytnderer_rounded_rectangle(x, y, w, h, r, g, b, a, radius)
	y = y + radius
	local datacircle = {
		{x + radius, y + h - radius * 2, 270},
		{x + w - radius, y + h - radius * 2, 0},
	}

	local data = {
		{x + radius, y, w - radius * 2, h - radius * 2},
		{x + radius, y - radius, w - radius * 2, radius},
		{x + radius, y + h - radius * 2, w - radius * 2, radius},
		{x, y - radius, radius, h - radius},
		{x + w - radius, y - radius, radius, h - radius},
	}

	for _, data in pairs(datacircle) do
		renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
	end

	for _, data in pairs(data) do
	   renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
	end
end

local function get_key_mode(ref)

end

local function kb_get_max_width()
    local max = 0

    for name, bind in pairs(kenzo.visuals.keybinds.binds) do
        local ref = type(bind.ref) == "table" and bind.ref[2] or bind.ref
        local mode = get_key_mode(ref)
        local name_w = measure_text("c", name).x
        local mode_w = measure_text("c", mode).x

        if not contains(ui.get(kenzo.ui.visuals.kb_combo), name) then
            goto skip
        end

        max = math.max(max, name_w + mode_w + kenzo.visuals.keybinds.padding)

        ::skip::
    end

    if max == 0 then
        max = measure_text("c", kenzo.visuals.keybinds.title).x + kenzo.visuals.keybinds.padding
    end

    return max
end

-- handle and render keybinds
kenzo.handlers.visuals.keybinds = function()

end

local hits = 0
local miss = 0
kenzo.handlers.visuals.debug_panel = function()
    if not contains(ui.get(kenzo.ui.visuals.additionals), "Debug panel") then
        return end
    local pading = 0
    local cur_threat = tostring(entity.get_player_name(client.current_threat())):lower()
   -- if string.len(cur_threat) > 6 then
   --     adjustforname = renderer.measure_text("", cur_threat) - 35
    --else
   --     adjustforname = 0
   -- end
    local pulse2 = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 1)) % (math.pi * 1))) * 255;

    local bg_col = {25, 25, 32, 210}
   -- local debug_w = 143 + adjustforname
   -- local debug_h = 95
    local _, y_msr = renderer.measure_text("", "kenzo.lua")
	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local pulse = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255;
    local water_mark = {ui.get(kenzo.ui.colours.watermark_highlight)}
    -- Background
    --renderer_rounded_rectangle(center.x / center.x + 15, center.y, debug_w, debug_h, bg_col[1], bg_col[2], bg_col[3], bg_col[4], 20)
    -- text info
    render_text(center.x / center.x + 32, center.y + 14 , {255, 255, 255, 255, "kenzolua.dev - "}, {water_mark[1], water_mark[2], water_mark[3], 255, username})
    render_text(center.x / center.x + 32, center.y + 14 + y_msr * 1.2, {255, 255, 255, 255, "build: "}, {water_mark[1], water_mark[2], water_mark[3], pulse, build})
    render_text(center.x / center.x + 32, center.y + 14 + y_msr * 2.3, {255, 255, 255, 255, "desync delta: "}, {water_mark[1], water_mark[2], water_mark[3], 255, math.floor(bodyyaw)})
    render_text(center.x / center.x + 32, center.y + 14 + y_msr * 3.4, {255, 255, 255, 255, "player state: "}, {water_mark[1], water_mark[2], water_mark[3], 255, kenzo.antiaim.state:lower()})
    render_text(center.x / center.x + 32, center.y + 14 + y_msr * 4.45, {255, 255, 255, 255, "current threat: "}, {water_mark[1], water_mark[2], water_mark[3], 255, cur_threat})

    --render_text(center.x / center.x + 32, center.y + 14 + y_msr * 5, {255, 255, 255, 255, "hit & miss: "}, {water_mark[1], water_mark[2], water_mark[3], 255, hits},{255, 255, 255, 255, " - "}, {water_mark[1], water_mark[2], water_mark[3], 255, miss} )
end

local leftReady = false
local rightReady = false
local forwardReady = false
local manual_mode = "back"
kenzo.handlers.aa.manual = function()
    if ui.get(kenzo.ui.aa.manual_on) == false then
        return 
    end
    if ui.get(kenzo.ui.aa.manual_back) then
        manual_mode = "back"
    elseif ui.get(kenzo.ui.aa.manual_left) and leftReady then
        if manual_mode == "left" then
            manual_mode = "back"
        else
            manual_mode = "left"
        end
        leftReady = false
    elseif ui.get(kenzo.ui.aa.manual_right) and rightReady then
        if manual_mode == "right" then
            manual_mode = "back"
        else
            manual_mode = "right"
        end
        rightReady = false
    elseif ui.get(kenzo.ui.aa.manual_forward) and forwardReady then
        if manual_mode == "forward" then
            manual_mode = "back"
        else
            manual_mode = "forward"
        end
        forwardReady = false
    end
    if ui.get(kenzo.ui.aa.manual_left) == false then
        leftReady = true
    end
    if ui.get(kenzo.ui.aa.manual_right) == false then
        rightReady = true
    end
    if ui.get(kenzo.ui.aa.manual_forward) == false then
        forwardReady = true
    end 
    if manual_mode == "back" then
        
    elseif manual_mode == "left" then
        ui.set(kenzo.refs.aa.yaw_offset, -90)
        ui.set(kenzo.refs.aa.yaw_base, "Local view")
    elseif manual_mode == "right" then
        ui.set(kenzo.refs.aa.yaw_offset, 90)
        ui.set(kenzo.refs.aa.yaw_base, "Local view")
    elseif manual_mode == "forward" then
        ui.set(kenzo.refs.aa.yaw_offset, -180)
        ui.set(kenzo.refs.aa.yaw_base, "Local view")
    end
    if manual_mode == "left" or manual_mode == "right" or manual_mode == "forward" then
        if ui.get(kenzo.ui.aa.manual_jitter) then
        else
            ui.set(kenzo.refs.aa.yaw_jitter, 'Off')
            ui.set(kenzo.refs.aa.body_yaw, "Static")
        end
    else
    end
    return manual_mode
end


local indicator = {}
local indicators = {}
local kb = {}
local dths = {}

indicator.pos = vector(center.x, center.y)
kb = vector(center.x, center.y)
dths = vector(center.x,center.y)

kenzo.handlers.visuals.indicators = function()
    if ui.get(kenzo.ui.aa.master) == false then return end
    --local theme = {ui.get(kenzo.ui.visuals.theme)}
    local col_desync = {ui.get(kenzo.ui.colours.desync_side)}
    local col_desyncoff = {ui.get(kenzo.ui.colours.desync_side_off)}
    local pos = kenzo.visuals.indicators.pos
    local side = anti_aim.get_desync(2) > 0 and "left" or "right"
    angle = math.min(60, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60))
    local col, col2 = side == "left" and {col_desync[1], col_desync[2], col_desync[3]} or {col_desyncoff[1], col_desyncoff[2], col_desyncoff[3]}, side == "right" and {col_desync[1], col_desync[2], col_desync[3]} or {col_desyncoff[1], col_desyncoff[2], col_desyncoff[3]}
    local size = vector(renderer.measure_text("b", "kenzo" .. build))
    local glow_size = lerp(0.5, 1, math.abs(math.sin(globals.realtime() * 2))) * 5
    local r, g, b = ui.get(kenzo.refs.misc.menu_color)
    local desync_bar = {ui.get(kenzo.ui.colours.desync_bar)}
    local pulse = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255;
    local pulse2 = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 115;
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local sside = bodyyaw > 0 and 1 or -1

    local build_col = {ui.get(kenzo.ui.colours.middle_build)}
    local active_kb = {ui.get(kenzo.ui.colours.keybinds_active)}
    local inactive_kb = {ui.get(kenzo.ui.colours.keybinds_inactive)}
    local manual_col = {ui.get(kenzo.ui.colours.manual)}
    local manual_off = {ui.get(kenzo.ui.colours.manual_off)}




    if ui.get(kenzo.refs.rage.double_tap_key) or ui.get(kenzo.refs.misc.hide_shots_key) then
        kb = ease.quad_in(0.2, kb, vector(indicator.pos.x, indicator.pos.y + 25) - kb, 1)
    else
        kb = ease.quad_in(0.2, kb, vector(indicator.pos.x, indicator.pos.y + 17) - kb, 1)
    end

    local freestanding = ui.get(kenzo.ui.aa.freestanding_key) and not contains(ui.get(kenzo.ui.aa.freestanding_disablers), kenzo.antiaim.state)
    -- title
    if ui.get(kenzo.ui.visuals.indicator) == "Simple" then
        renderer.text(center.x - 10, center.y + 22, col[1], col[2], col[3], 255, "c", 0, "kenzo")
        renderer.text(center.x + 12, center.y + 22, col2[1], col2[2], col2[3], 255, "c", 0, ".lua")
        renderer.gradient(center.x, center.y + 27, 0 - angle / 1.8 - 1, 2, desync_bar[1], desync_bar[2], desync_bar[3], desync_bar[4], desync_bar[1], desync_bar[2], desync_bar[3], 0, true)
        renderer.gradient(center.x, center.y + 27 ,    angle / 1.8 + 1, 2, desync_bar[1], desync_bar[2], desync_bar[3], desync_bar[4], desync_bar[1], desync_bar[2], desync_bar[3], 0, true)
        --renderer.text(pos.x - size.x/2 + renderer.measure_text("b", "kenzo"), pos.y, col2[1], col2[2], col2[3], 255, "b", 0, build)
        --renderer.text(pos.x, pos.y + 17, 255, 255, 255, 255, "-c", 0, ui.is_menu_open() and ui.get(kenzo.ui.aa.state):upper() or kenzo.antiaim.state:upper())
        --render_glow_rectangle(pos.x - size.x/2, pos.y + 5, size.x, 5, 136, 146, 217, 10, 3, glow_size, 2)
    elseif ui.get(kenzo.ui.visuals.indicator) == "Main" then

        y_state, x_state = 5, 0
        flags = "-c"
        indicator.pos = ease.quad_in(0.2, indicator.pos, vector(center.x - 1, center.y + 10) - indicator.pos, 1)
        dths = ease.quad_in(0.2, dths, vector(center.x - 1, center.y) - dths, 1)


        if entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1 and ui.get(kenzo.ui.visuals.animate) then

            y_state, x_state = 0, 23
            flags = "-"
            indicator.pos = ease.quad_in(0.1, indicator.pos, vector(center.x + 127, center.y + 10) - indicator.pos, 1)
            dths = ease.quad_in(0.2, dths, vector(center.x + 12, center.y) - dths, 1)

        end
        local which_side = side == 1 and "R" or "L"
        if ui.get(kenzo.refs.rage.double_tap_key) and anti_aim.get_double_tap() then dt_r, dt_g, dt_b = active_kb[1], active_kb[2], active_kb[3], 255 elseif anti_aim.get_double_tap() == false and ui.get(kenzo.refs.rage.double_tap_key) then dt_r, dt_g, dt_b, dt_a = inactive_kb[1], inactive_kb[2], inactive_kb[3], 255 else dt_r, dt_g, dt_b, dt_a = 0, 0, 0, 0 end 
        if ui.get(kenzo.refs.misc.hide_shots_key) and anti_aim.get_double_tap() == false and not ui.get(kenzo.refs.rage.double_tap_key) then hs_r, hs_g, hs_b, hs_a =active_kb[1], active_kb[2], active_kb[3], 255 else hs_r, hs_g, hs_b, hs_a = 0, 255, 0, 0 end

        -- 1st line,
        renderer.text(indicator.pos.x - renderer.measure_text("-", "KENZO"), center.y + 10, 255, 255, 255, 255, "-", 0, "KENZO")
        renderer.text(indicator.pos.x + 1, center.y + 10, build_col[1], build_col[2], build_col[3], pulse, "-", 0, string.upper(build))

        if bruteforce_reset then
            renderer.text(indicator.pos.x - x_state, center.y + 18 + y_state, 255, 255, 255, 255, flags, 0, kenzo.antiaim.state:upper())
        elseif brut3 then
            renderer.text(indicator.pos.x - x_state, center.y + 18 + y_state, 255, 255, 255, 255, flags, 0, "BRUTE [  " .. tostring(which_side) .. "  /  " .. tostring(stage) .."  ]")
        end
        renderer.text(dths.x - 4, indicator.pos.y + 17, dt_r, dt_g, dt_b, dt_a, "-", 0, "DT")
        renderer.text(dths.x - 4, indicator.pos.y + 17, hs_r, hs_g, hs_b, hs_a, "-", 0, "OS")

        renderer.text(indicator.pos.x - 23, kb.y, 255, 255, 255, ui.get(kenzo.refs.rage.force_bodyaim) and 255 or 80, "-", 0, "BAIM")
        renderer.text(indicator.pos.x + 17, kb.y, 255, 255, 255, freestanding and 255 or 80, "-", 0, "FS")
    elseif ui.get(kenzo.ui.visuals.indicator) == "Ideal yaw" then
        _, y_name = renderer.measure_text("", "KENZOLUA.DEV")
        charge = anti_aim.get_tickbase_shifting() + 1
        local color = {235 / charge, 17 * charge, 0}
        if ui.get(kenzo.refs.misc.fakeducking) then alphaa = pulse else alphaa = 255 end
        renderer.text(center.x+2, center.y + 10, 218, 118, 0, 255, "", 0, "KENZOLUA.DEV")
        renderer.text(center.x+2, center.y+ 10 + y_name - 2, 209, 139, 230, 255, "", 0, "DYNAMIC")
        renderer.text(center.x+2, center.y+ 10 + y_name * 2 - 4, color[1], color[2], color[3], alphaa, "", 0, "DT")
        --renderer.text(center.x+5, center.y + y_name * 2 - 4, 255, 0, 0, 255, "", 0, "DT")
    elseif ui.get(kenzo.ui.visuals.indicator) == "Clean" then
        renderer.text(center.x + 5, center.y + 10, col[1], col[2], col[3], 255, "", 0, "K E N Z O")
        renderer.text(center.x + 5 + renderer.measure_text("", "K E N Z O "), center.y + 10, col2[1], col2[2], col2[3], 255, "", 0, ". D E V")
        renderer.gradient(center.x + 5, center.y + 22, angle, 3, desync_bar[1], desync_bar[2], desync_bar[3], desync_bar[4], desync_bar[1], desync_bar[2], desync_bar[3], 0, true)
    end
    if ui.get(kenzo.ui.misc.advertise) then
        renderer.text(center.x, center.y * 1.989, 255, 255, 255, 255, "c", 0, "> kenzolua.dev | ".. build .. " v" .. version .. " <" )
    end
    if ui.get(kenzo.ui.aa.manual_on) then
        col_pulseorno = ui.get(kenzo.ui.colours.manual_pulse) and pulse or 245

        if ui.get(kenzo.ui.visuals.manual_arrows) == "Small arrows" then
            if manual_mode == "back" then

            elseif manual_mode == "left" then
                renderer.text(center.x - 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], pulse2, "+c", 0, "‹")
                renderer.text(center.x + 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], manual_off[4], "+c", 0, "›")
                renderer.text(center.x - 65, center.y - 3, manual_col[1], manual_col[2], manual_col[3], col_pulseorno, "+c", 0, "‹")
            elseif manual_mode == "right" then 
                renderer.text(center.x - 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], manual_off[4], "+c", 0, "‹")
                renderer.text(center.x + 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], pulse2, "+c", 0, "›")
                renderer.text(center.x + 65, center.y - 3, manual_col[1], manual_col[2], manual_col[3], col_pulseorno, "+c", 0, "›")
            end
        elseif ui.get(kenzo.ui.visuals.manual_arrows) == "Big arrows" then
            -- ⯇ ⯈ ⯅ ⯆
            if manual_mode == "back" then

            elseif manual_mode == "left" then
                renderer.text(center.x - 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], pulse2, "+c", 0, "⯇")
                renderer.text(center.x + 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], manual_off[4], "+c", 0, "⯈")
                renderer.text(center.x - 65, center.y - 3, manual_col[1], manual_col[2], manual_col[3], col_pulseorno, "+c", 0, "⯇")
            elseif manual_mode == "right" then 
                renderer.text(center.x - 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], manual_off[4], "+c", 0, "⯇")
                renderer.text(center.x + 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], pulse2, "+c", 0, "⯈")
                renderer.text(center.x + 65, center.y - 3, manual_col[1], manual_col[2], manual_col[3], col_pulseorno, "+c", 0, "⯈")
            end
        elseif ui.get(kenzo.ui.visuals.manual_arrows) == "Ideal yaw" then
            if manual_mode == "back" then

            elseif manual_mode == "left" then
                renderer.text(center.x - 60, center.y - 3, manual_off[1], manual_off[2], manual_off[3], 255, "+c", 0, "<")
                renderer.text(center.x + 60, center.y - 3, manual_off[1], manual_off[2], manual_off[3], manual_off[4], "+c", 0, ">")
                renderer.text(center.x - 60, center.y - 3, manual_col[1], manual_col[2], manual_col[3], 255, "+c", 0, "<")
            elseif manual_mode == "right" then 
                renderer.text(center.x - 60, center.y - 3, manual_off[1], manual_off[2], manual_off[3], manual_off[4], "+c", 0, "<")
                renderer.text(center.x + 60, center.y - 3, manual_off[1], manual_off[2], manual_off[3], 255, "+c", 0, ">")
                renderer.text(center.x + 60, center.y - 3, manual_col[1], manual_col[2], manual_col[3], 255, "+c", 0, ">")
            end
        end
    end
    if ui.get(kenzo.ui.visuals.manual_arrows) == "Teamskeet" then
        renderer.triangle(center.x + 55, center.y - 2 + 2, center.x + 42, center.y - 2 - 7, center.x + 42, center.y - 2 + 11, 
        manual_mode == "right" and 175 or 35, 
        manual_mode == "right" and 255 or 35, 
        manual_mode == "right" and 0 or 35, 
        manual_mode == "right" and 255 or 150)

        renderer.triangle(center.x - 55, center.y - 2 + 2, center.x - 42, center.y - 2 - 7, center.x - 42, center.y - 2 + 11, 
        manual_mode == "left" and 175 or 35, 
        manual_mode == "left" and 255 or 35, 
        manual_mode == "left" and 0 or 35, 
        manual_mode == "left" and 255 or 150)
        
        renderer.rectangle(center.x + 38, center.y - 2 - 7, 2, 18, 
        sside < 0 and col_desync[1] or 35,
        sside < 0 and col_desync[2] or 35,
        sside < 0 and col_desync[3] or 35,
        sside < 0 and 255 or 150)
        renderer.rectangle(center.x - 40, center.y - 2 - 7, 2, 18,			
        sside > 0 and col_desync[1] or 35,
        sside > 0 and col_desync[2] or 35,
        sside > 0 and col_desync[3] or 35,
        sside > 0 and 255 or 150)

    end
    if contains(ui.get(kenzo.ui.visuals.additionals), "Body yaw arrows") then
        if manual_mode == "left" or manual_mode == "right" or manual_mode == "forward" then

        else
        if by == -1 then
            renderer.text(center.x + 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], manual_off[4], "+c", 0, ">")
            renderer.text(center.x - 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], 255, "+c", 0, "<")
            renderer.text(center.x - 65, center.y - 3, manual_col[1], manual_col[2], manual_col[3], 255, "+c", 0, "<")
        elseif by == 1 then
            renderer.text(center.x - 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], manual_off[4], "+c", 0, "<")
            renderer.text(center.x + 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], 255, "+c", 0, ">")
            renderer.text(center.x + 65, center.y - 3, manual_col[1], manual_col[2], manual_col[3], 255, "+c", 0, ">")
        elseif by == 2 then
            renderer.text(center.x - 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], manual_off[4], "+c", 0, "<")
            renderer.text(center.x + 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], 255, "+c", 0, "   >>")
            renderer.text(center.x + 65, center.y - 3, manual_col[1], manual_col[2], manual_col[3], 255, "+c", 0, "   >>")
        elseif by == -2 then
            renderer.text(center.x + 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], manual_off[4], "+c", 0, ">")
            renderer.text(center.x - 65, center.y - 3, manual_off[1], manual_off[2], manual_off[3], 255, "+c", 0, "<<   ")
            renderer.text(center.x - 65, center.y - 3, manual_col[1], manual_col[2], manual_col[3], 255, "+c", 0, "<<   ")
        end
    end
    end
end


kenzo.handlers.rage.doubletap = function()
    client.set_cvar("cl_clock_correction", "0")
    if ui.get(kenzo.ui.rage.doubletap) == "Default" then
        ui.set(kenzo.refs.rage.sv_maxusrcmdprocessticks, 16)
    elseif ui.get(kenzo.ui.rage.doubletap) == "Fast" then
        ui.set(kenzo.refs.rage.sv_maxusrcmdprocessticks, 18)
    elseif ui.get(kenzo.ui.rage.doubletap) == "Unstable" then
        ui.set(kenzo.refs.rage.sv_maxusrcmdprocessticks, 21)
    else
        ui.set(kenzo.refs.rage.sv_maxusrcmdprocessticks, 16)
    end
end

kenzo.handlers.misc.clantag = function()
    if ui.get(kenzo.ui.misc.clantag) then
        client.set_clan_tag(".gg/kenzolua")
    else
        client.set_clan_tag("")
    end
end


client.set_event_callback("player_death", function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
    lastmiss = 0
    stage = 0
    bruteforce_reset = true
    notify.new_bottom(3, {ui.get(kenzo.refs.misc.menu_color)},"", "Kenzo -", "Reset stored information due to", "death")
    end
end)

client.set_event_callback("round_start", function()
    lastmiss = 0
    stage = 0
    bruteforce_reset = true
    hits = 0
    miss = 0
    notify.new_bottom(3, {ui.get(kenzo.refs.misc.menu_color)},"", "Kenzo -", "Reset stored information due to", "new round")
end)
local ground_ticks  = 180

client.set_event_callback("pre_render", function()

    local me = entity.get_local_player()
    local opts_anim = ui.get(kenzo.ui.misc.anims)

    if not me or not entity.is_alive(me) then return end

    local flags = entity.get_prop(me, "m_fFlags")

    if contains(opts_anim, "Static legs in air") then 
        entity.set_prop(me, "m_flPoseParameter", 1, 6) 
    end

    if contains(opts_anim, "0 pitch on land") then
        ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0

        if ground_ticks > 20 and ground_ticks < ui.get(kenzo.ui.misc.zero_time) then
            entity.set_prop(me, "m_flPoseParameter", 0.5, 12)
        end
    end
end)
--[[
kenzo.handlers.aa.exploit = function(cmd)
    if ui.get(kenzo.ui.aa.exploit_key) then
        cmd.pitch = 120
        cmd.roll = 75
    else
        cmd.pitch = 0
        cmd.roll = 0
    end
end]]
kenzo.handlers.aa.fixes = function()
    if ui.get(kenzo.ui.aa.master) == false then 
        return 
    end
    if ui.get(kenzo.ui.aa.hs_fix) and ui.get(kenzo.ui.aa.fixes) then
        if ui.get(kenzo.refs.misc.hide_shots_key) and not ui.get(kenzo.refs.rage.double_tap_key) and not ui.get(kenzo.refs.misc.fakeducking) then
            ui.set(kenzo.refs.fakelag.enable, false)
        else
            ui.set(kenzo.refs.fakelag.enable, true)
        end
    else
        ui.set(kenzo.refs.fakelag.enable, true)
    end
end
local var_legs = true
local timer_legs = globals.realtime()
kenzo.handlers.misc.anims = function(cmd)
    if ui.get(kenzo.ui.aa.master) == false then
        return 
    end
    local opts_anim = ui.get(kenzo.ui.misc.anims)
    if contains(opts_anim, "Leg breaker") and not contains(opts_anim, "Slide legs") then
        if cmd.chokedcommands == 0 and timer_legs < globals.realtime() then
            if varlegs then
                varlegs = false
                ui.set(kenzo.refs.misc.legs, "Always slide")
            else
                varlegs = true
                ui.set(kenzo.refs.misc.legs, "Never slide")
            end
            timer_legs = globals.realtime()
        end
    end
end

client.set_event_callback("predict_command", function()
    if ui.get(kenzo.ui.aa.master) == false then
        return 
    end
    local opts_anim = ui.get(kenzo.ui.misc.anims)

    if contains(opts_anim, "Slide legs") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
        ui.set(kenzo.refs.misc.legs, "Always slide")
    end
end)

kenzo.handlers.misc.fake_lag = function(cmd)
    if ui.get(kenzo.ui.aa.master) == false then
        return
    end
    local rand = math.random(1,2)
    local com = cmd.chokedcommands
    if ui.get(kenzo.ui.misc.fake_lag_opts) == "Fluctuate" then
        ui.set(kenzo.refs.fakelag.type, "Maximum")
        ui.set(kenzo.refs.fakelag.variance, 23)
        if cmd.chokedcommands == 1 and rand == 1 then
            ui.set(kenzo.refs.fakelag.limit, math.random(12,13))
        elseif cmd.chokedcommands == 0 and rand == 2 then
            ui.set(kenzo.refs.fakelag.limit, 14)
        end
    elseif ui.get(kenzo.ui.misc.fake_lag_opts) == "Choked" then
        ui.set(kenzo.refs.fakelag.type, "Dynamic")
        ui.set(kenzo.refs.fakelag.variance, 13)
        if cmd.chokedcommands == 1 and rand == 1 then
            ui.set(kenzo.refs.fakelag.limit, 13)
        elseif cmd.chokedcommands == 0 and rand == 2 then
            ui.set(kenzo.refs.fakelag.limit, 15)
        end
    elseif ui.get(kenzo.ui.misc.fake_lag_opts) == "Max" then
        ui.set(kenzo.refs.fakelag.type, "Maximum")
        ui.set(kenzo.refs.fakelag.variance, 17)
        ui.set(kenzo.refs.fakelag.limit, 14)
    end
end

-- Callbacks

ui.update(kenzo.ui.config.list, get_config_list())
ui.set(kenzo.ui.config.name, #database.read(kenzo.database.configs) == 0 and "" or database.read(kenzo.database.configs)[ui.get(kenzo.ui.config.list)+1].name)
ui.set_callback(kenzo.ui.config.list, function(value)
    local name = ""

    local configs = get_config_list()

    name = configs[ui.get(value)+1] or ""

    ui.set(kenzo.ui.config.name, name)
end)


ui.set_callback(kenzo.ui.config.load, function()
    local name = ui.get(kenzo.ui.config.name)
    if name == "" then return end

    local protected = function()
        load_config(name)
    end

    if pcall(protected) then
        notify.new_side(5, {ui.get(kenzo.refs.misc.menu_color)}, "KENZO | CONFIG", "Successfully", "loaded", "the config", name)
    else
        notify.new_side(5, {255, 50, 50}, "KENZO | CONFIG", "Failed to", "load", "the config", name)
    end
end)

ui.set_callback(kenzo.ui.config.save, function()
    local name = ui.get(kenzo.ui.config.name)
    if name == "" then return end

    if name:match("[^%w]") ~= nil then
        notify.new_side(5, {255, 50, 50}, "KENZO | CONFIG", "Failed to", "save", "config because it contains", "invalid characters")
        return
    end

    local protected = function()
        save_config(name)
    end

    if pcall(protected) then
        ui.update(kenzo.ui.config.list, get_config_list())
        notify.new_side(5, {ui.get(kenzo.refs.misc.menu_color)}, "KENZO | CONFIG", "Successfully", "saved", "the config", name)
    else
        notify.new_side(5, {255, 50, 50}, "KENZO | CONFIG", "Failed to", "save", "the config", name)
    end
end)

ui.set_callback(kenzo.ui.config.delete, function()
    local name = ui.get(kenzo.ui.config.name)
    if name == "" then return end

    if delete_config(name) == false then
        notify.new_side(5, {255, 50, 50}, "KENZO | CONFIG", "Failed to", "delete", "the config", name)
        ui.update(kenzo.ui.config.list, get_config_list())
        return
    end
    
    local protected = function()
        delete_config(name)
    end

    if pcall(protected) then
        ui.update(kenzo.ui.config.list, get_config_list())
        ui.set(kenzo.ui.config.list, #kenzo.presets + #database.read(kenzo.database.configs) - #database.read(kenzo.database.configs))
        ui.set(kenzo.ui.config.name, #database.read(kenzo.database.configs) == 0 and "" or get_config_list()[#kenzo.presets + #database.read(kenzo.database.configs) - #database.read(kenzo.database.configs)+1])
        notify.new_side(5, {ui.get(kenzo.refs.misc.menu_color)}, "KENZO | CONFIG", "Successfully", "deleted", "the config", name)
    else
        notify.new_side(5, {255, 50, 50}, "KENZO | CONFIG", "Failed to", "delete", "the config", name)
    end
end)

ui.set_callback(kenzo.ui.config.import, function()
    local protected = function()
       import_settings()
    end

    if pcall(protected) then
        notify.new_side(5, {ui.get(kenzo.refs.misc.menu_color)}, "KENZO | CONFIG", "Successfully", "imported", "settings")
    else
        notify.new_side(5, {255, 50, 50}, "KENZO | CONFIG", "Failed to", "import", "settings")
    end
end)

ui.set_callback(kenzo.ui.config.export, function()
    local protected = function()
        export_settings(name)
    end

    if pcall(protected) then
        notify.new_side(5, {ui.get(kenzo.refs.misc.menu_color)}, "KENZO | CONFIG", "Successfully", "exported", "settings")
    else
        notify.new_side(5, {255, 50, 50}, "KENZO | CONFIG", "Failed to", "export", "settings")
    end
end)


client.set_event_callback("paint", function()
    if ui.get(lol) then
        ui.set(kenzo.refs.fakelag.limit, 58)
        renderer.indicator(255, 255, 255, 255, ui.get(kenzo.refs.fakelag.limit))
    else
        ui.set(kenzo.refs.fakelag.limit, 14)
        renderer.indicator(255, 255, 255, 255, ui.get(kenzo.refs.fakelag.limit))
    end
    kenzo.handlers.visuals.keybinds()
end)

client.set_event_callback("paint_ui", function()
    set_aa_visibility(false)
    notify:handler()

    kenzo.handlers.visuals.watermark()
    if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) and ui.get(kenzo.ui.aa.master) then return end
    kenzo.handlers.visuals.indicators()
    kenzo.handlers.visuals.debug_panel()
end)

client.set_event_callback("shutdown", function()
    set_aa_visibility(true)
end)

ui.set_callback(kenzo.ui.misc.clantag, kenzo.handlers.misc.clantag)

client.set_event_callback("setup_command", function(cmd)
    if not ui.get(kenzo.ui.aa.master) then return end
    --kenzo.handlers.aa.exploit(cmd)
    if bruteforce_reset then
    --kenzo.handlers.aa.set(cmd)
    kenzo.handlers.aa.state.update(cmd)
    kenzo.handlers.aa.freestanding()
    end
    kenzo.handlers.aa.freestand_bodyyaw()

    kenzo.handlers.aa.manual()
    kenzo.handlers.aa.anti_brute(cmd)
    kenzo.handlers.rage.handle(cmd)
    kenzo.handlers.aa.anti_backstab()
    kenzo.handlers.aa.fixes()
    kenzo.handlers.misc.anims(cmd)
    kenzo.handlers.misc.fake_lag(cmd)
end)

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
client.set_event_callback("aim_hit", function(e)
    hits = hits + 1
    if not contains(ui.get(kenzo.ui.visuals.console_logs), "Hit") then return end
	local group = hitgroup_names[e.hitgroup + 1] or '?'
    colour_console(col.kenzo_blue, col.kenzo_white, 'Hit ' .. entity.get_player_name(e.target) .. ' in the ' .. group .. ' for ' .. e.damage .. ' damage (' .. entity.get_prop(e.target, 'm_iHealth') .. ' health remaining)')
end)

client.set_event_callback("aim_miss", function(e)
    miss = miss + 1
    if not contains(ui.get(kenzo.ui.visuals.console_logs), "Miss") then return end
	local group = hitgroup_names[e.hitgroup + 1] or '?'
    colour_console(col.kenzo_blue, col.kenzo_white, 'Missed ' .. entity.get_player_name(e.target) .. " in the " .. group .. " due to " .. e.reason .. "(" .. math.floor(e.hit_chance) .. "%)")
end)

client.set_event_callback("aim_hit", function(e)
    if not contains(ui.get(kenzo.ui.visuals.logs), "Hit") then return end
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local r, g, b = ui.get(kenzo.ui.colours.notif_hit)
    --client.color_log(r, g, b, string.format("hit %s in the %s for %d damage (%d health remaining)", entity.get_player_name(e.target), group, e.damage, entity.get_prop(e.target, 'm_iHealth')))
    notify.new_bottom(3, {r, g, b}, "HIT", "Hit", entity.get_player_name(e.target), "in the", group, "for", e.damage, "damage", "(" .. entity.get_prop(e.target, 'm_iHealth') .. " health remaining)")
end)

client.set_event_callback("aim_miss", function(e)
    if not contains(ui.get(kenzo.ui.visuals.logs), "Miss") then return end
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local r, g, b = ui.get(kenzo.ui.colours.notif_miss)
    --client.color_log(r, g, b, string.format("missed %s in the %s due to %s (%d%%)", entity.get_player_name(e.target), group, e.reason, e.hit_chance))
    notify.new_bottom(3, {r, g, b}, "MISS", "Missed", entity.get_player_name(e.target), "in the", group, "due to", e.reason, "("..math.floor(e.hit_chance).."%)")
end)

ui.set_callback(kenzo.ui.rage.doubletap, kenzo.handlers.rage.doubletap)

--save database
client.set_event_callback("shutdown", function()
    local locations = database.read(kenzo.database.locations) or {}
    locations.keybinds = { x = kenzo.visuals.keybinds.pos.x, y = kenzo.visuals.keybinds.pos.y }
	database.write(kenzo.database.locations, locations)
end)