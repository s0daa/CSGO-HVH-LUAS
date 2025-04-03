
local vector        = require "vector"
local csgo_weapons  = require "gamesense/csgo_weapons"
local ease          = require "gamesense/easing"
local anti_aim      = require "gamesense/antiaim_funcs"
local trace         = require "gamesense/trace" 
local clipboard     = require "gamesense/clipboard"
local http          = require "gamesense/http"
local images        = require "gamesense/images"
local ffi           = require "ffi"
local base64        = require"gamesense/base64"

local obex = {username = 'scriptleaks', build = 'Boosters', discord=''}


local update_date = "29/10/22"
local version = "V1.0.1"
lastswap = 0
local ecstasy = {}


client.exec('clear')
client.color_log(255, 165, 0,  "Welcome " .. obex.username ..  " to ecstasy.solutions | " .. string.lower(obex.build) .. " build | Last Updated - " .. update_date .. ".    "  )

ecstasy.database = {
    configs = ":configs:",
    locations = ":locations:"
}
ecstasy.presets = {}
ecstasy.locations     = database.read(ecstasy.database.locations) or {}
ecstasy.antiaim       = {
    states          = {"Default", "Standing", "Moving", "Ducking", "Air", "Air Duck", "Slowwalk", "Use", "Freestanding"},
    state           = "Default"
}

ecstasy.visuals       = {
    indicators      = {},
}

ecstasy.ui            = {
    aa              = {
        state       = {},
        states      = {}
    },
    info = {},
    config         = {},
    rage           = {},
    misc           = {},
    visuals        = {},
    colours        = {}
}

ecstasy.handlers      = {
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

ecstasy.refs          = {
    aa              = {},
    fakelag         = {},
    rage            = {},
    misc            = {}
}

local colors = {
	orange = '\aFFA500FF',
	grey = '\a898989FF',
	red = '\aff441fFF',
	normal = '\ac8c8c8FF',
}

local screen = vector(client.screen_size())
local center = vector(screen.x/2, screen.y/2)

ecstasy.refs.aa.master                                            = ui.reference("AA", "Anti-aimbot angles", "Enabled")
ecstasy.refs.aa.yaw_base                                          = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
ecstasy.refs.aa.pitch                                             = ui.reference("AA", "Anti-aimbot angles", "Pitch")
ecstasy.refs.aa.yaw, ecstasy.refs.aa.yaw_offset                     = ui.reference("AA", "Anti-aimbot angles", "Yaw")
ecstasy.refs.aa.yaw_jitter, ecstasy.refs.aa.yaw_jitter_offset       = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
ecstasy.refs.aa.body_yaw, ecstasy.refs.aa.body_yaw_offset           = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
ecstasy.refs.aa.freestanding_body_yaw                             = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
ecstasy.refs.aa.edge_yaw                                          = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
ecstasy.refs.aa.freestanding, ecstasy.refs.aa.freestanding_key      = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
ecstasy.refs.aa.roll_offset                                       = ui.reference("AA", "Anti-aimbot angles", "Roll")

ecstasy.refs.misc.hide_shots, ecstasy.refs.misc.hide_shots_key      = ui.reference("AA", "Other", "On shot anti-aim")
ecstasy.refs.misc.fakeducking                                     = ui.reference("RAGE", "Other", "Duck peek assist")
ecstasy.refs.misc.legs                                            = ui.reference("AA", "Other", "Leg movement")
ecstasy.refs.misc.slow_motion, ecstasy.refs.misc.slow_motion_key    = ui.reference("AA", "Other", "Slow motion")
ecstasy.refs.misc.menu_color                                      = ui.reference("Misc", "Settings", "Menu color")

ecstasy.refs.rage.double_tap, ecstasy.refs.rage.double_tap_key      = ui.reference("RAGE", "Aimbot", "Double tap")
ecstasy.refs.rage.sv_maxusrcmdprocessticks                        = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks2")
ecstasy.refs.rage.force_bodyaim                                   = ui.reference("RAGE", "Aimbot", "Force body aim")
ecstasy.refs.rage.prefer_bodyaim                                  = ui.reference("RAGE", "Aimbot", "Prefer body aim")
ecstasy.refs.rage.prefer_safepoint                                = ui.reference("RAGE", "Aimbot", "Prefer safe point")
ecstasy.refs.rage.force_safepoint                                 = ui.reference("RAGE", "Aimbot", "Force safe point")

ecstasy.refs.fakelag.enable, ecstasy.refs.fakelag.enable_key        = ui.reference("AA", "Fake lag", "Enabled")
ecstasy.refs.fakelag.limit                                        = ui.reference("AA", "Fake lag", "Limit")
ecstasy.refs.fakelag.type                                         = ui.reference("AA", "Fake lag", "Amount")
ecstasy.refs.fakelag.variance                                     = ui.reference("AA", "Fake lag", "Variance")

ui.set_visible(ecstasy.refs.fakelag.limit, true)
ui.set_visible(ecstasy.refs.rage.sv_maxusrcmdprocessticks, true)

local function colour_console(prefix, text, string)
    client.color_log(prefix[1], prefix[2], prefix[3], "[ecstasy] \0")
    client.color_log(text[1], text[2], text[3], string)
end
local col = {
    ecstasy_blue = {
        178, 163, 236
    },
    ecstasy_white = {
        207, 207, 207
    },
    ecstasy_red = {
        255, 100, 100
    },
    ecstasy_darkblue = {
        10, 145, 255
    },
    ecstasy_green = {
        0, 255, 21
    },
    ecstasy_pink = {
        255, 154, 255
    },
    ecstasy_orange = {
        255, 165, 0
    }
}
-- UI handler
ecstasy.handlers.ui.new = function(element, condition, config, callback)
    condition = condition or true
    config = config or false
    callback = callback or function() end

    local update = function()
        for k, v in pairs(ecstasy.handlers.ui.elements) do
            if type(v.condition) == "function" then
                ui.set_visible(v.element, v.condition())
            else
                ui.set_visible(v.element, v.condition)
            end
        end
    end

    table.insert(ecstasy.handlers.ui.elements, { element = element, condition = condition})

    if config then
        table.insert(ecstasy.handlers.ui.config, element)
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

local lerp = function(a, b, t)
    return a + (b - a) * t
end

split = function(string, sep)
    local result = {}
    for str in (string):gmatch("([^"..sep.."]+)") do
        table.insert(result, str)
    end
    return result
end

function set_aa_visibility(visible)
    for k, v in pairs(ecstasy.refs.aa) do
        ui.set_visible(v, visible)
    end
end

function get_config(name)
    local database = database.read(ecstasy.database.configs) or {}

    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    for i, v in pairs(ecstasy.presets) do
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
    local db = database.read(ecstasy.database.configs) or {}
    local config = {}

    if name:match("[^%w]") ~= nil then
        return
    end

    for _, v in pairs(ecstasy.handlers.ui.config) do
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

    database.write(ecstasy.database.configs, db)
end

function delete_config(name)
    local db = database.read(ecstasy.database.configs) or {}

    for i, v in pairs(db) do
        if v.name == name then
            table.remove(db, i)
            break
        end
    end

    for i, v in pairs(ecstasy.presets) do
        if v.name == name then
            return false
        end
    end

    database.write(ecstasy.database.configs, db)
end

function get_config_list()
    local database = database.read(ecstasy.database.configs) or {}
    local config = {}
    local presets = ecstasy.presets

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
    for _, v in pairs(ecstasy.handlers.ui.config) do
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

    for i, v in pairs(ecstasy.handlers.ui.config) do
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
    if name == "" and not build == "" then
        hide_cle = true
    else
        hide_cle = false
    end
    return hide_cle
end

-- Menu Elements

ecstasy.ui.aa.master = ecstasy.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "Enable " .. colors.orange .. "ecstasy.solutions"))

ecstasy.ui.tab = ecstasy.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", colors.orange ..  "Ecstasy Tab Selection", {"Info","Anti-Aim", "Misc", "Config"}), function()
     return ui.get(ecstasy.ui.aa.master) 
end)


ecstasy.ui.aa.manual_on = ecstasy.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", colors.orange .. "[+] " .. colors.normal .. "\aCCCACAFFManual AA"), function() return ui.get(ecstasy.ui.tab) == "Anti-Aim" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.aa.manual_jitter = ecstasy.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", " > \aFB6D0FFFManual \aCCCACAFFUse jitter"), function() return ui.get(ecstasy.ui.tab) == "Anti-Aim" and ui.get(ecstasy.ui.aa.master) and ui.get(ecstasy.ui.aa.manual_on) end)
ecstasy.ui.aa.manual_forward = ecstasy.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " > \aFB6D0FFFManual \aCCCACAFFForward", false), function() return ui.get(ecstasy.ui.tab) == "Anti-Aim" and ui.get(ecstasy.ui.aa.master) and ui.get(ecstasy.ui.aa.manual_on) end)
ecstasy.ui.aa.manual_back = ecstasy.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " > \aFB6D0FFFManual \aCCCACAFFBack", false), function() return ui.get(ecstasy.ui.tab) == "Anti-Aim" and ui.get(ecstasy.ui.aa.master) and ui.get(ecstasy.ui.aa.manual_on) end)
ecstasy.ui.aa.manual_left = ecstasy.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " > \aFB6D0FFFManual \aCCCACAFFLeft", false), function() return ui.get(ecstasy.ui.tab) == "Anti-Aim" and ui.get(ecstasy.ui.aa.master) and ui.get(ecstasy.ui.aa.manual_on) end)
ecstasy.ui.aa.manual_right = ecstasy.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", " > \aFB6D0FFFManual \aCCCACAFFRight", false), function() return ui.get(ecstasy.ui.tab) == "Anti-Aim" and ui.get(ecstasy.ui.aa.master) and ui.get(ecstasy.ui.aa.manual_on) end)


ecstasy.ui.aa.state = ecstasy.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "Player state", ecstasy.antiaim.states), function() 
    return ui.get(ecstasy.ui.aa.master) and ui.get(ecstasy.ui.tab) == "Anti-Aim"
end)

for k, v in pairs(ecstasy.antiaim.states) do
    ecstasy.ui.aa.states[v] = {}

    if v ~= "Default" then
        ecstasy.ui.aa.states[v].master = ecstasy.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "Enable \aFB6D0FFF" .. v .. colors.normal .. " AA", false), function()
             return ui.get(ecstasy.ui.aa.state) == v and ui.get(ecstasy.ui.aa.master) and ui.get(ecstasy.ui.tab) == "Anti-Aim"
        end, true)
    end

    local show = function() return ui.get(ecstasy.ui.aa.state) == v and ui.get(ecstasy.ui.aa.master) and ui.get(ecstasy.ui.tab) == "Anti-Aim" and (v == "Default" and true or ui.get(ecstasy.ui.aa.states[v].master)) end
    

    ecstasy.ui.aa.states[v].pitch                 = ecstasy.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aFB6D0FFF" .. v .. " -\aCDCDCDFF" .. " Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}), function() return show() and not hide_cle end, true)
    ecstasy.ui.aa.states[v].yaw_base              = ecstasy.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aFB6D0FFF" .. v .. " -\aCDCDCDFF" .. " Yaw base", {"Local view", "At targets"}), function() return show() and not hide_cle end, true)
    ecstasy.ui.aa.states[v].yaw                   = ecstasy.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aFB6D0FFF" .. v .. " -\aCDCDCDFF" .. " Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}), function() return show() and not hide_cle end, true)
    ecstasy.ui.aa.states[v].yaw_offset_left       = ecstasy.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles", "\aFB6D0FFF" .. v .. " -\aCDCDCDFF" .. " Yaw offset \aFB6D0FFFleft", -180, 180, 0, true, "°"), function() return show() and ui.get(ecstasy.ui.aa.states[v].yaw) ~= "Off" and not hide_cle end, true)
    ecstasy.ui.aa.states[v].yaw_offset_right      = ecstasy.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles", "\aFB6D0FFF" .. v .. " -\aCDCDCDFF" .. " Yaw offset \aFB6D0FFFright", -180, 180, 0, true, "°"), function() return show() and ui.get(ecstasy.ui.aa.states[v].yaw) ~= "Off" and not hide_cle end, true)
    ecstasy.ui.aa.states[v].yaw_jitter            = ecstasy.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aFB6D0FFF" .. v .. " -\aCDCDCDFF" .. " Yaw jitter", {"Off", "Offset", "Center", "Random"}), function() return show() and not hide_cle end, true)
    ecstasy.ui.aa.states[v].yaw_jitter_offset     = ecstasy.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles", "\n" .. v .. " - Yaw jitter", -180, 180, 0, true, "°"), function() return show() and ui.get(ecstasy.ui.aa.states[v].yaw_jitter) ~= "Off" and not hide_cle end, true)
    ecstasy.ui.aa.states[v].body_yaw              = ecstasy.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aFB6D0FFF" .. v .. " -\aCDCDCDFF" .. " Body yaw", {"Off", "Opposite", "Jitter", "Static"}), function() return show() and not hide_cle end, true)
    ecstasy.ui.aa.states[v].body_yaw_offset       = ecstasy.handlers.ui.new  (ui.new_slider("AA", "Anti-aimbot angles", "\n" .. v .. " - Body yaw offset", -180, 180, 0, true, "°"), function() return show() and ui.get(ecstasy.ui.aa.states[v].body_yaw) ~= "Off" and ui.get(ecstasy.ui.aa.states[v].body_yaw) ~= "Opposite" and not hide_cle end, true)
    ecstasy.ui.aa.states[v].freestanding_body_yaw = ecstasy.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFB6D0FFF" .. v .. " -\aCDCDCDFF" .. " Freestanding body yaw", false), function() return show() and ui.get(ecstasy.ui.aa.states[v].body_yaw) ~= "Off" and not hide_cle end, true)
    ecstasy.ui.aa.states[v].roll                  = ecstasy.handlers.ui.new(  ui.new_slider("AA", "Anti-aimbot angles", "\aFB6D0FFF" .. v .. " -\aCDCDCDFF" .. " Roll", -50, 50, 0, true, "°"), function() return show() and ui.get(ecstasy.ui.aa.states[v].body_yaw) ~= "Off" and not hide_cle end, true)
    ecstasy.ui.aa.states[v].bruteforce            = ecstasy.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFB6D0FFF" .. v .. " -\aCDCDCDFF" .. " Anti bruteforce", false), function() return show() and ui.get(ecstasy.ui.aa.states[v].body_yaw) ~= "Off" and not hide_cle end, true)end
ecstasy.ui.aa.freestanding_disablers = ecstasy.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "\aFB6D0FFFAdditional - \aCDCDCDFFFreestand disablers", "Use", "Air", "Moving", "Ducking", "Standing", "Slowwalk"), function() return ui.get(ecstasy.ui.aa.master) and ui.get(ecstasy.ui.tab) == "Anti-Aim" end)
ecstasy.ui.aa.freestanding_key = ecstasy.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", "\aFB6D0FFFAdditional - \aCDCDCDFFFreestanding key", false), function() return ui.get(ecstasy.ui.aa.master) and ui.get(ecstasy.ui.tab) == "Anti-Aim" end)

-- rage
ecstasy.ui.rage.doubletap = ecstasy.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "Doubletap enhancments", "Default", "Fast", "Unstable"), function()  return ui.get(ecstasy.ui.tab) == "Rage" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.rage.force_defensive = ecstasy.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", "Force Defensive", false), function() return ui.get(ecstasy.ui.tab) == "Rage" and ui.get(ecstasy.ui.aa.master) end)

-- misc
--ecstasy.ui.misc.advertise = ecstasy.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", colors.orange .. "[+] " .. colors.normal .. " - \aCCCACAFFWatermark"), function() return ui.get(ecstasy.ui.tab) == "Misc" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.misc.inds = ecstasy.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", colors.orange .. "[+] " .. colors.normal .. " - \aCCCACAFFCrosshair Indicators","-", "Dynamic", "Static"), function() return ui.get(ecstasy.ui.tab) == "Misc" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.misc.panel = ecstasy.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", colors.orange .. "[+] " .. colors.normal .. " - \aCCCACAFFDebug Panel"), function() return ui.get(ecstasy.ui.tab) == "Misc" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.misc.hitlogs = ecstasy.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", colors.orange .. "[+] " .. colors.normal .. " - \aCCCACAFFHit / Miss logs"), function() return ui.get(ecstasy.ui.tab) == "Misc" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.misc.arrows = ecstasy.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", colors.orange .. "[+] " .. colors.normal .. " - \aCCCACAFFManual AA arrows"), function() return ui.get(ecstasy.ui.tab) == "Misc" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.misc.anims = ecstasy.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", colors.orange .. "[+] " .. colors.normal .. " - \aCCCACAFF Animations","Leg breaker", "Slide legs", "0 Pitch on land"), function() return ui.get(ecstasy.ui.tab) == "Misc" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.misc.time = ecstasy.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", colors.orange .. "[+] " .. colors.normal .. " - \aCCCACAFF 0 Pitch time", 65, 180, 160, true, "T", 1, true), function() return ui.get(ecstasy.ui.tab) == "Misc" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.misc.fake_lag_opts = ecstasy.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", colors.orange .. "[+] " .. colors.normal .. " - \aCCCACAFF Fake lag options", "-", "Fluctuate", "Choked", "Max"), function() return ui.get(ecstasy.ui.tab) == "Misc" and ui.get(ecstasy.ui.aa.master) end)

-- info
ecstasy.ui.info.label1 = ecstasy.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " "), function() return ui.get(ecstasy.ui.tab) == "Info" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.info.label2 = ecstasy.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles",colors.orange .. "ecstasy.solutions: " .. colors.normal.. obex.username), function() return ui.get(ecstasy.ui.tab) == "Info" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.info.label3 = ecstasy.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles",colors.orange .. "Build: " .. colors.normal .. obex.build), function() return ui.get(ecstasy.ui.tab) == "Info" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.info.label4 = ecstasy.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles",colors.orange .. "Version: " .. colors.normal .. version), function() return ui.get(ecstasy.ui.tab) == "Info" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.info.label5 = ecstasy.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles",colors.orange .. "Last Update:" .. colors.normal .. update_date), function() return ui.get(ecstasy.ui.tab) == "Info" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.info.label6 = ecstasy.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles"," "), function() return ui.get(ecstasy.ui.tab) == "Info" and ui.get(ecstasy.ui.aa.master) end)
ecstasy.ui.info.label7 = ecstasy.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles","DM" .. colors.orange .. " underscore#0001" .. colors.normal .. " or" .. colors.orange .. " Cleaver#0001" .. colors.normal .. " for support." ), function() return ui.get(ecstasy.ui.tab) == "Info" and ui.get(ecstasy.ui.aa.master) end)
-- CONFIG ELEMENTS
ecstasy.ui.config.list = ecstasy.handlers.ui.new(ui.new_listbox("AA", "Anti-aimbot angles", "Configs", ""), function() 
    return ui.get(ecstasy.ui.tab) == "Config" and ui.get(ecstasy.ui.aa.master)
end)

--config name
ecstasy.ui.config.name = ecstasy.handlers.ui.new(ui.new_textbox("AA", "Anti-aimbot angles", "Config name", ""), function() 
    return ui.get(ecstasy.ui.tab) == "Config" and ui.get(ecstasy.ui.aa.master)
end)

--load
ecstasy.ui.config.load = ecstasy.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\aFB6D0FFFLoad", function() end), function() 
    return ui.get(ecstasy.ui.tab) == "Config" and ui.get(ecstasy.ui.aa.master)
end)

--save
ecstasy.ui.config.save = ecstasy.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\aFB6D0FFFSave", function() end), function() 
    return ui.get(ecstasy.ui.tab) == "Config" and ui.get(ecstasy.ui.aa.master)
end)

--delete
ecstasy.ui.config.delete = ecstasy.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\aFB6D0FFFDelete", function() end), function() 
    return ui.get(ecstasy.ui.tab) == "Config" and ui.get(ecstasy.ui.aa.master)
end)

--import
ecstasy.ui.config.import = ecstasy.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\aFB6D0FFFImport settings", function() end), function() 
    return ui.get(ecstasy.ui.tab) == "Config" and ui.get(ecstasy.ui.aa.master)
end)

-- export
ecstasy.ui.config.export = ecstasy.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\aFB6D0FFFExport settings", function() end), function() 
    return ui.get(ecstasy.ui.tab) == "Config" and ui.get(ecstasy.ui.aa.master)
end)


distance_knife = {}
distance_knife.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end


local swap__yaw = globals.realtime()
local swapyaw = false
local function swap_yaw(val1, val2)
    if swap__yaw < globals.realtime() then
        if swapyaw then
            swapyaw = false
            ui.set(ecstasy.refs.aa.yaw_offset, tonumber(val1)) 
        else
            swapyaw = true
            ui.set(ecstasy.refs.aa.yaw_offset, tonumber(val2))
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

local y = 0
local alpha = 255
client.set_event_callback('paint_ui', function()
    local screen = vector(client.screen_size())
    local size = vector(screen.x, screen.y)

    local sizing = lerp(0.1, 0.9, math.sin(globals.realtime() * 2) * 0.5 + 0.5)
    local rotation = lerp(0, 360, globals.realtime() % 1)
    alpha = lerp(alpha, 0, globals.frametime() * .3)
    alpha2 = lerp(alpha, 0, globals.frametime() * .5)
    y = lerp(y, 20, globals.frametime() * 2 )
    y2 = lerp(y, 20, globals.frametime() * 2 - 30)

    renderer.rectangle(0, 0, size.x, size.y, 0, 0, 0, alpha2)
    renderer.text(screen.x/2, y2 + screen.y/2 - 50, 184, 184, 184, alpha, 'c', 0, 'welcome ' .. string.lower(obex.username) .. ' to ecstasy.solutions\n')
    renderer.text(screen.x/2, y2 + screen.y/2 - 40, 184, 184, 184, alpha, 'c', 0, 'build: ' .. string.lower(obex.build))
    renderer.text(screen.x/2, y2 + screen.y/2 - 30, 184, 184, 184, alpha, 'c', 0, 'version: ' .. version)
    renderer.text(screen.x/2, y2 + screen.y/2 - 15, 184, 184, 184, alpha, 'c', 0, 'last updated: ' .. update_date .. '\n')
    renderer.text(screen.x/2, y2 + screen.y/2, 184, 184, 184, alpha, 'c', 0, 'https://discord.gg/HCvQQa3kMh')
end)

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

-- ANTIAIM

local extend_vector = function(pos,length,angle)
    local rad = angle * math.pi / 180
    if rad == nil then return end
    if angle == nil or pos == nil or length == nil then return end
    return {pos[1] + (math.cos(rad) * length),pos[2] + (math.sin(rad) * length), pos[3]};
end

ecstasy.handlers.aa.freestand_bodyyaw = function()
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
    if freestand_right --[[and ui.get(ecstasy.ui.aa.freestand_bodyyaw) == "Peek real"]] then
        freestand = 1
    elseif freestand_right --[[and ui.get(ecstasy.ui.aa.freestand_bodyyaw) == "Peek desync"]] then
        freestand = -1
    elseif freestand_left --[[and ui.get(ecstasy.ui.aa.freestand_bodyyaw) == "Peek real"]] then
        freestand = -1
    elseif freestand_left --[[and ui.get(ecstasy.ui.aa.freestand_bodyyaw) == "Peek desync"]] then
        freestand = 1
    else
        freestand = 0
    end
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

    return freestand, sides, by
end
local ground_ticks = 0
ecstasy.handlers.aa.state.update = function(cmd)
    local me    = entity.get_local_player()
    local flags = entity.get_prop(me, "m_fFlags")
    local vel1, vel2, vel3 = entity.get_prop(me, 'm_vecVelocity')
    local speed = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))

    local ducking       = cmd.in_duck == 1
    local air           = ground_ticks < 5
    local walking       = speed >= 2
    local standing      = speed <= 1
    local slow_motion   = ui.get(ecstasy.refs.misc.slow_motion) and ui.get(ecstasy.refs.misc.slow_motion_key)
    local fakeducking   = ui.get(ecstasy.refs.misc.fakeducking)
    local use           = on_use(cmd)
    local freestanding = ui.get(ecstasy.ui.aa.freestanding_key) and not contains(ui.get(ecstasy.ui.aa.freestanding_disablers), ecstasy.antiaim.state)
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

    ecstasy.antiaim.state = state
end
local lastmiss = 0
local function GetClosestPoint(A, B, P)
    a_to_p = { P[1] - A[1], P[2] - A[2] }
    a_to_b = { B[1] - A[1], B[2] - A[2] }

    atb2 = a_to_b[1]^2 + a_to_b[2]^2

    atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    t = atp_dot_atb / atb2
    
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end

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
        if ui.get(ecstasy.ui.aa.states["Use"].master) then
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
    

ecstasy.handlers.aa.freestanding = function()
    local freestanding = ui.get(ecstasy.ui.aa.freestanding_key) and not contains(ui.get(ecstasy.ui.aa.freestanding_disablers), ecstasy.antiaim.state)

    ui.set(ecstasy.refs.aa.freestanding_key, freestanding and "Always on" or "On hotkey")
    ui.set(ecstasy.refs.aa.freestanding, freestanding and true or false)
end
local timer_yaw = globals.realtime()

local varyaw = false

client.set_event_callback("setup_command", function(c)
    local state = ecstasy.antiaim.state
    if state ~= "Default" and not ui.get(ecstasy.ui.aa.states[state].master) then
        state = "Default"
    end
    ui.set(ecstasy.refs.aa.pitch, ui.get(ecstasy.ui.aa.states[state].pitch))
    ui.set(ecstasy.refs.aa.yaw_base, ui.get(ecstasy.ui.aa.states[state].yaw_base))
    ui.set(ecstasy.refs.aa.yaw, ui.get(ecstasy.ui.aa.states[state].yaw))
    ui.set(ecstasy.refs.aa.yaw_jitter, ui.get(ecstasy.ui.aa.states[state].yaw_jitter))
    ui.set(ecstasy.refs.aa.yaw_jitter_offset, ui.get(ecstasy.ui.aa.states[state].yaw_jitter_offset))
    ui.set(ecstasy.refs.aa.body_yaw, ui.get(ecstasy.ui.aa.states[state].body_yaw))
    ui.set(ecstasy.refs.aa.body_yaw_offset, ui.get(ecstasy.ui.aa.states[state].body_yaw_offset))
    ui.set(ecstasy.refs.aa.freestanding_body_yaw, ui.get(ecstasy.ui.aa.states[state].freestanding_body_yaw))
    ui.set(ecstasy.refs.aa.roll_offset, ui.get(ecstasy.ui.aa.states[state].roll))


    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	if c.chokedcommands ~= 0 then
	else
		ui.set(ecstasy.refs.aa.yaw_offset,(side == 1 and ui.get(ecstasy.ui.aa.states[state].yaw_offset_left) or ui.get(ecstasy.ui.aa.states[state].yaw_offset_right)))
	end

	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60

end)


ecstasy.handlers.rage.handle = function(cmd)
    cmd.force_defensive = ui.get(ecstasy.ui.rage.force_defensive) and 1 or 0
end


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

local screen = vector(client.screen_size())
ecstasy.visuals.indicators.pos = vector(screen.x/2, screen.y/2)

local inds = {
    {
        ref = ecstasy.refs.rage.double_tap_key,
        name = "DT"
    },
    {
        ref = ecstasy.refs.misc.hide_shots_key,
        name = "HS"
    },
    {
        ref = ecstasy.refs.rage.force_bodyaim,
        name = "BAIM"
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

ecstasy.handlers.visuals.watermark = function()
    if ui.get(ecstasy.ui.aa.master) == false then return end
end




local hits = 0
local miss = 0


local leftReady = false
local rightReady = false
local forwardReady = false
local manual_mode = "back"
ecstasy.handlers.aa.manual = function()
    if ui.get(ecstasy.ui.aa.manual_on) == false then
        return 
    end
    if ui.get(ecstasy.ui.aa.manual_back) then
        manual_mode = "back"
    elseif ui.get(ecstasy.ui.aa.manual_left) and leftReady then
        if manual_mode == "left" then
            manual_mode = "back"
        else
            manual_mode = "left"
        end
        leftReady = false
    elseif ui.get(ecstasy.ui.aa.manual_right) and rightReady then
        if manual_mode == "right" then
            manual_mode = "back"
        else
            manual_mode = "right"
        end
        rightReady = false
    elseif ui.get(ecstasy.ui.aa.manual_forward) and forwardReady then
        if manual_mode == "forward" then
            manual_mode = "back"
        else
            manual_mode = "forward"
        end
        forwardReady = false
    end
    if ui.get(ecstasy.ui.aa.manual_left) == false then
        leftReady = true
    end
    if ui.get(ecstasy.ui.aa.manual_right) == false then
        rightReady = true
    end
    if ui.get(ecstasy.ui.aa.manual_forward) == false then
        forwardReady = true
    end 
    if manual_mode == "back" then
        
    elseif manual_mode == "left" then
        ui.set(ecstasy.refs.aa.yaw_offset, -90)
        ui.set(ecstasy.refs.aa.yaw_base, "Local view")
    elseif manual_mode == "right" then
        ui.set(ecstasy.refs.aa.yaw_offset, 90)
        ui.set(ecstasy.refs.aa.yaw_base, "Local view")
    elseif manual_mode == "forward" then
        ui.set(ecstasy.refs.aa.yaw_offset, -180)
        ui.set(ecstasy.refs.aa.yaw_base, "Local view")
    end
    if manual_mode == "left" or manual_mode == "right" or manual_mode == "forward" then
        if ui.get(ecstasy.ui.aa.manual_jitter) then
        else
            ui.set(ecstasy.refs.aa.yaw_jitter, 'Off')
            ui.set(ecstasy.refs.aa.body_yaw, "Static")
        end
    else
    end
    return manual_mode
end



local kb = {}
local dths = {}

local indicator = {}
local indicators = {}

indicator.pos = vector(center.x, center.y)
kb = vector(center.x, center.y)
dths = vector(center.x,center.y)

ecstasy.handlers.visuals.indicators = function()
    local opts_inds = ui.get(ecstasy.ui.misc.inds)
    if entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1 and opts_inds == "Dynamic" then
		indicator.pos = ease.quad_in(0.1, indicator.pos, vector(center.x + 200, center.y + 10) - indicator.pos, 1)
	end

    if entity.get_local_player() ~= nil and opts_inds == "Dynamic" then
        local pulse = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255;
        angle = math.min(60, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60))
        indicator.pos = ease.quad_in(0.2, indicator.pos, vector(center.x - 1, center.y + 10) - indicator.pos, 1)
        renderer.text(indicator.pos.x - renderer.measure_text("-", "ECSTASY"), center.y + 10, 255, 255, 255, 255, "-", 0, "ECSTASY")
		renderer.text(indicator.pos.x + 1, center.y + 10, 255, 165, 0, pulse, "-", 0, string.upper(obex.build))

		renderer.gradient(indicator.pos.x, center.y + 20, 0 - angle / 1.8 - 1, 2, 255, 165, 0, 255, 255, 165, 0, 0, true)
        renderer.gradient(indicator.pos.x, center.y + 20 ,    angle / 1.8 + 1, 2, 255, 165, 0, 255, 255, 165, 0, 0, true)
        if ui.get(ecstasy.refs.rage.double_tap_key) then
            renderer.text(indicator.pos.x - renderer.measure_text("-", "DOUBLETAP")/2, center.y + 21, 255, 165, 0, 255, "-", 0, "DOUBLETAP")
        else
            renderer.text(indicator.pos.x - renderer.measure_text("-", "DOUBLETAP")/2, center.y + 21, 200, 200, 200, 200, "-", 0, "DOUBLETAP")
        end
    end

    if entity.get_local_player() ~= nil and opts_inds == "Static" then
        local pulse = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255;
        angle = math.min(60, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60))
        indicator.pos = ease.quad_in(0.2, indicator.pos, vector(center.x - 1, center.y + 10) - indicator.pos, 1)
        renderer.text(indicator.pos.x - renderer.measure_text("-", "ECSTASY") / 2 + 20, center.y + 10, 255, 255, 255, 255, "-", 0, "ECSTASY")
        renderer.text(indicator.pos.x + 5 + renderer.measure_text("-", "ECSTASY") , center.y + 10, 255, 165, 0, pulse, "-", 0, string.upper(obex.build))
        if ui.get(ecstasy.refs.rage.double_tap_key) then
            renderer.text(indicator.pos.x - renderer.measure_text("-", "DOUBLETAP")/2 + 25, center.y + 18, 255, 165, 0, 255, "-", 0, "DOUBLETAP")
        else
            renderer.text(indicator.pos.x - renderer.measure_text("-", "DOUBLETAP")/2 + 25, center.y + 18, 200, 200, 200, 200, "-", 0, "DOUBLETAP")
        end
        if ui.get(ecstasy.refs.misc.hide_shots_key) then
            renderer.text(indicator.pos.x - renderer.measure_text("-", "HIDESHOTS")/2 + 24, center.y + 26, 255, 165, 0, 255, "-", 0, "HIDESHOTS")
        else
            renderer.text(indicator.pos.x - renderer.measure_text("-", "HIDESHOTS")/2 + 24, center.y + 26, 200, 200, 200, 200, "-", 0, "HIDESHOTS")
        end
        if ui.get(ecstasy.refs.rage.force_bodyaim) then
            renderer.text(indicator.pos.x - renderer.measure_text("-", "BAIM")/2 + 13, center.y + 34, 255, 165, 0, 255, "-", 0, "BAIM")
        else
            renderer.text(indicator.pos.x - renderer.measure_text("-", "BAIM")/2 + 13, center.y + 34, 200, 200, 200, 200, "-", 0, "BAIM")
        end
        if ui.get(ecstasy.refs.aa.freestanding_key) then
            renderer.text(indicator.pos.x - renderer.measure_text("-", "FS")/2 + 30, center.y + 34, 255, 165, 0, 255, "-", 0, "FS")
        else
            renderer.text(indicator.pos.x - renderer.measure_text("-", "FS")/2 + 30, center.y + 34, 200, 200, 200, 200, "-", 0, "FS")
        end
    end


    if entity.get_local_player() ~= nil and ui.get(ecstasy.ui.misc.panel) then
        local currentThreat = tostring(entity.get_player_name(client.current_threat())):lower()
	    if currentThreat == "unknown" then currentThreat = "n/a" end
        local pulse2 = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 1)) % (math.pi * 1))) * 255;
        local bg_col = {25, 25, 32, 210}
        local _, y_msr = renderer.measure_text("", "ecstasy.solutions")
        local pulse = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255;
        local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60

        render_text(center.x / center.x + 32, center.y + 14 , {255, 255, 255, 255,  "ecstasy.solutions: "}, { 255, 165, 0, 255, string.lower(obex.username)})
    	render_text(center.x / center.x + 32, center.y + 14 + y_msr * 1.2, {255, 255, 255, 255, "build: "}, { 255, 165, 0, pulse, string.lower(obex.build)})
        render_text(center.x / center.x + 32, center.y + 14 + y_msr * 2.3, {255, 255, 255, 255, "version: "}, { 255, 165, 0, 255, string.lower(version)})
    	render_text(center.x / center.x + 32, center.y + 14 + y_msr * 3.4, {255, 255, 255, 255, "desync angle: "}, { 255, 165, 0, 255, math.floor(bodyyaw)})
    	render_text(center.x / center.x + 32, center.y + 14 + y_msr * 4.5, {255, 255, 255, 255, "aimbot target: "}, { 255, 165, 0, 255, currentThreat})
    end
    
end


ecstasy.handlers.rage.doubletap = function()
    client.set_cvar("cl_clock_correction", "0")
    if ui.get(ecstasy.ui.rage.doubletap) == "Default" then
        ui.set(ecstasy.refs.rage.sv_maxusrcmdprocessticks, 16)
    elseif ui.get(ecstasy.ui.rage.doubletap) == "Fast" then
        ui.set(ecstasy.refs.rage.sv_maxusrcmdprocessticks, 18)
    elseif ui.get(ecstasy.ui.rage.doubletap) == "Unstable" then
        ui.set(ecstasy.refs.rage.sv_maxusrcmdprocessticks, 21)
    else
        ui.set(ecstasy.refs.rage.sv_maxusrcmdprocessticks, 16)
    end
end

ecstasy.handlers.misc.clantag = function()
    if ui.get(ecstasy.ui.misc.clantag) then
        client.set_clan_tag("ecstasy")
    else
        client.set_clan_tag("")
    end
end


client.set_event_callback("player_death", function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
    lastmiss = 0
    stage = 0
    bruteforce_reset = true

    end
end)

client.set_event_callback("round_start", function()
    lastmiss = 0
    stage = 0
    bruteforce_reset = true
    hits = 0
    miss = 0
end)
local ground_ticks  = 180

client.set_event_callback("pre_render", function()

    local me = entity.get_local_player()
    local opts_anim = ui.get(ecstasy.ui.misc.anims)

    if not me or not entity.is_alive(me) then return end

    local flags = entity.get_prop(me, "m_fFlags")

    if contains(opts_anim, "Static legs in air") then 
        entity.set_prop(me, "m_flPoseParameter", 1, 6) 
    end

    if contains(opts_anim, "0 Pitch on land") then
        ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0

        if ground_ticks > 20 and ground_ticks < ui.get(ecstasy.ui.misc.time) then
            entity.set_prop(me, "m_flPoseParameter", 0.5, 12)
        end
    end
end)

local var_legs = true
local timer_legs = globals.realtime()
ecstasy.handlers.misc.anims = function(cmd)
    if ui.get(ecstasy.ui.aa.master) == false then
        return 
    end
    local opts_anim = ui.get(ecstasy.ui.misc.anims)
    if contains(opts_anim, "Leg breaker") and not contains(opts_anim, "Slide legs") then
        if cmd.chokedcommands == 0 and timer_legs < globals.realtime() then
            if varlegs then
                varlegs = false
                ui.set(ecstasy.refs.misc.legs, "Always slide")
            else
                varlegs = true
                ui.set(ecstasy.refs.misc.legs, "Never slide")
            end
            timer_legs = globals.realtime()
        end
    end
end
client.set_event_callback("predict_command", function()
    if ui.get(ecstasy.ui.aa.master) == false then
        return 
    end
    local opts_anim = ui.get(ecstasy.ui.misc.anims)

    if contains(opts_anim, "Slide legs") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
        ui.set(ecstasy.refs.misc.legs, "Always slide")
    end
end)
ecstasy.handlers.misc.fake_lag = function(cmd)
    if ui.get(ecstasy.ui.aa.master) == false then
        return
    end
    local rand = math.random(1,2)
    local com = cmd.chokedcommands
    if ui.get(ecstasy.ui.misc.fake_lag_opts) == "Fluctuate" then
        ui.set(ecstasy.refs.fakelag.type, "Maximum")
        ui.set(ecstasy.refs.fakelag.variance, 23)
        if cmd.chokedcommands == 1 and rand == 1 then
            ui.set(ecstasy.refs.fakelag.limit, math.random(12,13))
        elseif cmd.chokedcommands == 0 and rand == 2 then
            ui.set(ecstasy.refs.fakelag.limit, 14)
        end
    elseif ui.get(ecstasy.ui.misc.fake_lag_opts) == "Choked" then
        ui.set(ecstasy.refs.fakelag.type, "Dynamic")
        ui.set(ecstasy.refs.fakelag.variance, 13)
        if cmd.chokedcommands == 1 and rand == 1 then
            ui.set(ecstasy.refs.fakelag.limit, 13)
        elseif cmd.chokedcommands == 0 and rand == 2 then
            ui.set(ecstasy.refs.fakelag.limit, 15)
        end
    elseif ui.get(ecstasy.ui.misc.fake_lag_opts) == "Max" then
        ui.set(ecstasy.refs.fakelag.type, "Maximum")
        ui.set(ecstasy.refs.fakelag.variance, 17)
        ui.set(ecstasy.refs.fakelag.limit, 14)
    end
end
local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
client.set_event_callback("aim_hit", function(e)
    hits = hits + 1
    if not ui.get(ecstasy.ui.misc.hitlogs) then return end
	local group = hitgroup_names[e.hitgroup + 1] or '?'
    colour_console(col.ecstasy_orange, col.ecstasy_white, 'Hit ' .. entity.get_player_name(e.target) .. ' in the ' .. group .. ' for ' .. e.damage .. ' damage (' .. entity.get_prop(e.target, 'm_iHealth') .. ' health remaining)')
end)

client.set_event_callback("aim_miss", function(e)
    miss = miss + 1
    if not ui.get(ecstasy.ui.misc.hitlogs) then return end
	local group = hitgroup_names[e.hitgroup + 1] or '?'
    colour_console(col.ecstasy_orange, col.ecstasy_white, 'Missed ' .. entity.get_player_name(e.target) .. " in the " .. group .. " due to " .. e.reason .. " (" .. math.floor(e.hit_chance) .. "%)")
end)

ui.update(ecstasy.ui.config.list, get_config_list())
--ui.set(ecstasy.ui.config.name, #database.read(ecstasy.database.configs) == 0 and "" or database.read(ecstasy.database.configs)[ui.get(ecstasy.ui.config.list)+1].name)
ui.set_callback(ecstasy.ui.config.list, function(value)
    local name = ""

    local configs = get_config_list()

    name = configs[ui.get(value)+1] or ""

    ui.set(ecstasy.ui.config.name, name)
end)
ui.set_callback(ecstasy.ui.config.load, function()
    local name = ui.get(ecstasy.ui.config.name)
    if name == "" then return end

    local protected = function()
        load_config(name)
    end

    if pcall(protected) then
        print("[ecstasy.solutions] Successfully loaded config ",  name)
    else
        print("[ecstasy.solutions] Failed to load config ", name)
    end
end)

ui.set_callback(ecstasy.ui.config.save, function()
    local name = ui.get(ecstasy.ui.config.name)
    if name == "" then return end

    if name:match("[^%w]") ~= nil then
        print("[ecstasy.solutions] Failed to save the config because it contains Invalid characters")
        return
    end

    local protected = function()
        save_config(name)
    end

    if pcall(protected) then
        ui.update(ecstasy.ui.config.list, get_config_list())
        print("[ecstasy.solutions] Successfully saved config ", name)
    else
        print("[ecstasy.solutions] Failed to save config ", name)
    end
end)

ui.set_callback(ecstasy.ui.config.delete, function()
    local name = ui.get(ecstasy.ui.config.name)
    if name == "" then return end

    if delete_config(name) == false then
        print("[ecstasy.solutions] Failed to delete the config ", name)
        ui.update(ecstasy.ui.config.list, get_config_list())
        return
    end
    
    local protected = function()
        delete_config(name)
    end

    if pcall(protected) then
        ui.update(ecstasy.ui.config.list, get_config_list())
        ui.set(ecstasy.ui.config.list, #ecstasy.presets + #database.read(ecstasy.database.configs) - #database.read(ecstasy.database.configs))
        ui.set(ecstasy.ui.config.name, #database.read(ecstasy.database.configs) == 0 and "" or get_config_list()[#ecstasy.presets + #database.read(ecstasy.database.configs) - #database.read(ecstasy.database.configs)+1])
        print("[ecstasy.solutions] Successfully deleted the config ", name)
    else
        print("[ecstasy.solutions] Failed to delete the config ", name)
    end
end)

ui.set_callback(ecstasy.ui.config.import, function()
    local protected = function()
       import_settings()
    end

    if pcall(protected) then
        print("[ecstasy.solutions] Successfully imported settings ")
    else
        print("[ecstasy.solutions] Failed to import settings")
    end
end)

ui.set_callback(ecstasy.ui.config.export, function()
    local protected = function()
        export_settings(name)
    end

    if pcall(protected) then
        print("[ecstasy.solutions] Successfully exported settings ")
    else
        print("[ecstasy.solutions] Failed to export settings ")
    end
end)

client.set_event_callback("paint_ui", function()
    set_aa_visibility(false)
    notify:handler()

    ecstasy.handlers.visuals.watermark()
    if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) and ui.get(ecstasy.ui.aa.master) then return end
    ecstasy.handlers.visuals.indicators()
end)

client.set_event_callback("shutdown", function()
    set_aa_visibility(true)
end)

client.set_event_callback("setup_command", function(cmd)
    if not ui.get(ecstasy.ui.aa.master) then return end


    ecstasy.handlers.aa.state.update(cmd)
    ecstasy.handlers.aa.freestanding()
    ecstasy.handlers.aa.freestand_bodyyaw()

    ecstasy.handlers.aa.manual()
    ecstasy.handlers.rage.handle(cmd)
    ecstasy.handlers.misc.anims(cmd)
    ecstasy.handlers.misc.fake_lag(cmd)
end)




ui.set_callback(ecstasy.ui.rage.doubletap, ecstasy.handlers.rage.doubletap)


client.set_event_callback("shutdown", function()
    local locations = database.read(ecstasy.database.locations) or {}
	database.write(ecstasy.database.locations, locations)
end)
