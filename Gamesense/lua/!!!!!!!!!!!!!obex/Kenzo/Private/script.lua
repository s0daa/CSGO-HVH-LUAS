-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- Tab detection
-- CREDIT: arrak39 / Throw

local db_key = 'TAB_DETECTION'
local cur_tab = globals.realtime() < 30 and 1 or database.read(db_key) or 8

local dpi = 1
local size = { default = { w = 75, h = 64, }, w = 75, h = 64, x = 6, y = 20 }

ui.set_callback(ui.reference("MISC", "Settings", "DPI scale"), function(self)
    dpi    = tonumber(ui.get(self):sub(1, 3)) * 0.01
    size.w = size.default.w * dpi
    size.h = size.default.h * dpi
end, true)

local function hitbox_check()
    local pos = { ui.menu_position() }
    local m_pos = { ui.mouse_position() }
    for i = 1, 9 do
        local offset = { size.x, size.y + size.h * (i - 1) }
        if m_pos[1] >= pos[1] + offset[1] and m_pos[1] <= pos[1] + size.w + offset[1] and m_pos[2] >= pos[2] + offset[2] and m_pos[2] <= pos[2] + size.h + offset[2] then
            return i
        end
    end
    return cur_tab
end

local m1_down = false
local function on_paint()
    if not ui.is_menu_open() then return end
    if not m1_down and client.key_state(0x01) then
        m1_down = true
        cur_tab = hitbox_check()
    end

    if not client.key_state(0x01) then m1_down = false end
end

client.set_event_callback("paint_ui", on_paint)
defer(function() database.write(db_key, cur_tab) end)



local function min_dmg_override_func()
    return ui.get(select(1, ui.reference("RAGE", "Aimbot", "Minimum damage override")))
end

local function min_dmg_key_func()
    return ui.get(select(2, ui.reference("RAGE", "Aimbot", "Minimum damage override")))
end

local function min_dmg_slider_func()
    return ui.get(select(3, ui.reference("RAGE", "Aimbot", "Minimum damage override")))
end

-- Rogers's UI Library for gamesense
-- CREDIT: stinkywinky92 / astinaa

local vector = require("vector")

local g_ui = _G.ui

local ui = { elements = {} }

local ui_mt = {
    __index = ui,
    __metatable = "_ui"
}


ui.new = function(elem, uid)
    local element = setmetatable({
        uid = uid or nil,
        ref = elem,
        callback = function() end,
        conditions = {}
    }, ui_mt)

    table.insert(ui.elements, element)

    g_ui.set_callback(elem, function()
        element.callback(element)
    end)

    return element
end

function ui.get_config_elements()
    local config = {}

    for _, element in pairs(ui.elements) do
        if element.uid ~= nil then
            table.insert(config, element)
        end
    end

    return config
end

function ui.get_config()
    local config_elements = ui.get_config_elements()
    local config = {}

    for i, element in pairs(config_elements) do
        config[element.uid] = g_ui.get(element.ref)
    end

    return json.stringify(config)
end

function ui.load_config(settings)
    local config_elements = ui.get_config_elements()

    local parsed = json.parse(settings)

    for i, element in pairs(config_elements) do
        for uid, value in pairs(parsed) do
            if uid == element.uid then
                g_ui.set(element.ref, value)
            end
        end
    end
end


-- UI Element functions
function ui:get_parents()
    local parents, parent = {}, self.parent

    while parent ~= nil do
        table.insert(parents, parent)
        parent = parent.parent
    end

    return parents
end

function ui:add_condition(condition)
    if type(condition) ~= "function" then
        print("Kenzo UI - Condition must be a function!")
        return self
    end

    table.insert(self.conditions, condition)

    return self
end

function ui:set_callback(callback)
    if type(callback) ~= "function" then
        print("Kenzo UI - An error occured while setting callback for element: " .. self.uid .. " - Expected function, got " .. type(callback))
        return self
    end

    self.callback = callback

    return self
end

function ui:get()
    return g_ui.get(self.ref)
end

function ui:set_visible(visible)
    g_ui.set_visible(self.ref, visible)
end

function ui:set(value)
    -- pcall is used to prevent errors when setting values
    -- print the error to the console if it occurs
    local success, err = pcall(g_ui.set, self.ref, value)

    if not success then
        print("Kenzo UI - An error occured while setting value for element: " .. tostring(self.uid) .. " - " .. err)
    end
end

function ui:update(...)
    g_ui.update(self.ref, ...)
end

function ui:name()
    return g_ui.name(self.ref)
end




-- Helper functions
function ui:handle_visibility()
    for _, element in pairs(self.elements) do
        local visible = true
        for _, condition in pairs(element.conditions) do
            if not condition() then
                visible = false
                break
            end
        end

        for _, parent in pairs(element:get_parents()) do
            if not g_ui.get(parent.ref) then
                visible = false
                break
            end
        end
        g_ui.set_visible(element.ref, visible)
    end
end

function ui:init()
    table.insert(self.elements, self)

    self.parent:handle_visibility()
    
    g_ui.set_callback(self.parent.ref, function()
        self.parent:handle_visibility()
        self.parent.callback(self.parent)
    end)

    g_ui.set_callback(self.ref, function()
        self.parent:handle_visibility()
        self.callback(self)
    end)

    if not pcall(function() return g_ui.get(self.parent.ref) end) then
        print("Kenzo UI - An error occured while creating element: " .. uid .. " - Invalid parent element type!")
        return
    end
end




-- Child elements
function ui:checkbox(uid, ...)
    local ref = g_ui.new_checkbox(...)
    local element = setmetatable({uid = uid, ref = ref, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, ui_mt)

    element:init()

    return element
end

function ui:slider(uid, ...)
    local ref = g_ui.new_slider(...)
    local element = setmetatable({uid = uid, ref = ref, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, ui_mt)

    element:init()

    return element
end

function ui:color_picker(uid, ...)
    local ref = g_ui.new_color_picker(...)
    local element = setmetatable({uid = uid, ref = ref, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, ui_mt)

    element:init()

    return element
end

function ui:combo(uid, ...)
    local ref = g_ui.new_combobox(...)
    local element = setmetatable({uid = uid, ref = ref, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, ui_mt)

    element:init()

    return element
end

function ui:hotkey(uid, ...)
    local ref = g_ui.new_hotkey(...)
    local element = setmetatable({uid = uid, ref = ref, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, ui_mt)

    element:init()

    return element
end

function ui:label(uid, ...)
    local ref = g_ui.new_label(...)
    local element = setmetatable({uid = uid, ref = ref, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, ui_mt)

    element:init()

    return element
end

function ui:listbox(uid, ...)
    local ref = g_ui.new_listbox(...)
    local element = setmetatable({uid = uid, ref = ref, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, ui_mt)

    element:init()

    return element
end

function ui:multiselect(uid, ...)
    local ref = g_ui.new_multiselect(...)
    local element = setmetatable({uid = uid, ref = ref, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, ui_mt)

    element:init()

    return element
end

function ui:textbox(uid, ...)
    local ref = g_ui.new_textbox(...)
    local element = setmetatable({uid = uid, ref = ref, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, ui_mt)

    element:init()

    return element
end

function ui:button(...)
    local ref = g_ui.new_button(...)
    local element = setmetatable({uid = nil, ref = ref, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, ui_mt)

    element:init()

    return element
end




-- Native functions
function ui.new_string(uid, ...)
    return ui.new(g_ui.new_string(...), uid)
end

function ui.new_checkbox(uid, ...)
    return ui.new(g_ui.new_checkbox(...), uid)
end

function ui.new_slider(uid, ...)
    return ui.new(g_ui.new_slider(...), uid)
end

function ui.new_color_picker(uid, ...)
    return ui.new(g_ui.new_color_picker(...), uid)
end

function ui.new_combobox(uid, ...)
    return ui.new(g_ui.new_combobox(...), uid)
end

function ui.new_hotkey(uid, ...)
    return ui.new(g_ui.new_hotkey(...), uid)
end

function ui.new_label(uid, ...)
    return ui.new(g_ui.new_label(...), uid)
end

function ui.new_listbox(uid, ...)
    return ui.new(g_ui.new_listbox(...), uid)
end

function ui.new_multiselect(uid, ...)
    return ui.new(g_ui.new_multiselect(...), uid)
end

function ui.new_textbox(uid, ...)
    return ui.new(g_ui.new_textbox(...), uid)
end

function ui.new_button(uid, ...)
    return ui.new(g_ui.new_button(...), uid)
end

function ui.reference(...)
    local ref = g_ui.reference(...)

    if select(2, g_ui.reference(...)) then
        return ui.new(select(1, g_ui.reference(...))), ui.new(select(2, g_ui.reference(...)))
    end
    return ui.new(g_ui.reference(...))
end

function ui.is_menu_open()
    return g_ui.is_menu_open()
end

function ui.menu_position()
    return vector(g_ui.menu_position())
end

function ui.menu_size()
    return vector(g_ui.menu_size())
end

function ui.mouse_position()
    return vector(g_ui.mouse_position())
end

-- LPH Macro
LPH_NO_VIRTUALIZE = function(...) return ... end
LPH_JIT = function(...) return ... end

-- Library Error
local missing_libraries = {}
local links = {}

lib_error = function(library, link)
    table.insert(missing_libraries, library)
    if link then
        links[library] = link
    end
end

-- Libraries
local _A, csgo_weapons = pcall(require, "gamesense/csgo_weapons"); if not _A then lib_error("csgo_weapons", "https://gamesense.pub/forums/viewtopic.php?id=18807") end
local _B, ease         = pcall(require, "gamesense/easing"); if not _B then lib_error("easing", "https://gamesense.pub/forums/viewtopic.php?id=22920") end
local _C, anti_aim     = pcall(require, "gamesense/antiaim_funcs"); if not _C then lib_error("antiaim_funcs", "https://gamesense.pub/forums/viewtopic.php?id=29665") end
local _D, trace        = pcall(require, "gamesense/trace"); if not _D then lib_error("trace", "https://gamesense.pub/forums/viewtopic.php?id=32949") end
local _E, clipboard    = pcall(require, "gamesense/clipboard"); if not _E then lib_error("clipboard", "https://gamesense.pub/forums/viewtopic.php?id=28678") end
local _F, http         = pcall(require, "gamesense/http"); if not _F then lib_error("http", "https://gamesense.pub/forums/viewtopic.php?id=19253") end
local _H, images       = pcall(require, "gamesense/images"); if not _H then lib_error("images", "https://gamesense.pub/forums/viewtopic.php?id=22917") end
local _I, base64       = pcall(require, "gamesense/base64"); if not _I then lib_error("base64", "https://gamesense.pub/forums/viewtopic.php?id=21619") end
local _J, discord      = pcall(require, "gamesense/discord_webhooks"); if not _J then lib_error("discord_webhooks", "https://gamesense.pub/forums/viewtopic.php?id=24793") end
local _K, ent          = pcall(require, "gamesense/entity"); if not _K then lib_error("entity", "https://gamesense.pub/forums/viewtopic.php?id=27529") end
local ffi              = require "ffi"

if #missing_libraries > 0 then
    local missing_libraries_str = table.concat(missing_libraries, ", ")
    local links_str = ""
    for _, library in ipairs(missing_libraries) do
        local link = links[library]
        if link then
            links_str = links_str .. string.format("\n%s: %s \n", library, link)
        end
    end
    error(string.format("\nKenzo - failed to retrieve the following libraries: %s. Copy the links, subscribe and reinject. \n %s", missing_libraries_str, links_str))
end

local gs = {
    aa = {
        master = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
        yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
        pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
        pitch_offset = select(2, ui.reference("AA", "Anti-aimbot angles", "Pitch")),
        yaw = select(1, ui.reference("AA", "Anti-aimbot angles", "Yaw")),
        yaw_offset = select(2, ui.reference("AA", "Anti-aimbot angles", "Yaw")),
        yaw_jitter = select(1, ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")),
        yaw_jitter_offset = select(2, ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")),
        body_yaw = select(1, ui.reference("AA", "Anti-aimbot angles", "Body yaw")),
        body_yaw_offset = select(2, ui.reference("AA", "Anti-aimbot angles", "Body yaw")),
        freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
        freestanding = select(1, ui.reference("AA", "Anti-aimbot angles", "Freestanding")),
        freestanding_key = select(2, ui.reference("AA", "Anti-aimbot angles", "Freestanding")),
        roll = ui.reference("AA", "Anti-aimbot angles", "Roll")
    },
    misc = {
        hide_shots = select(1, ui.reference("AA", "Other", "On shot anti-aim")),
        hide_shots_key = select(2, ui.reference("AA", "Other", "On shot anti-aim")),
        fakeducking = ui.reference("RAGE", "Other", "Duck peek assist"),
        legs = ui.reference("AA", "Other", "Leg movement"),
        slow_motion = select(1, ui.reference("AA", "Other", "Slow motion")),
        slow_motion_key = select(2, ui.reference("AA", "Other", "Slow motion")),
        menu_color = ui.reference("Misc", "Settings", "Menu color"),
        thirdperson = select(1, ui.reference("Visuals", "Effects", "Force third person (alive)")),
        thirdperson_key = select(2, ui.reference("Visuals", "Effects", "Force third person (alive)")),
        clantag = ui.reference("MISC", "Miscellaneous", "Clan tag spammer"),
        menu_key = ui.reference("MISC", "settings", "menu key"),
    },
    rage = {
        double_tap = select(1, ui.reference("RAGE", "Aimbot", "Double tap")),
        double_tap_key = select(2, ui.reference("RAGE", "Aimbot", "Double tap")),
        baim = ui.reference("RAGE", "Aimbot", "Force body aim"),
        minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
        min_dmg_override = ui.reference("RAGE", "Aimbot", "Minimum damage override"),
        min_dmg_key = select(2, ui.reference("RAGE", "Aimbot", "Minimum damage override")),
        prefer_bodyaim = ui.reference("RAGE", "Aimbot", "Prefer body aim"),
        prefer_safepoint = ui.reference("RAGE", "Aimbot", "Prefer safe point"),
        sp = ui.reference("RAGE", "Aimbot", "Force safe point")
    },
    fakelag = {
        enable = select(1, ui.reference("AA", "Fake lag", "Enabled")),
        enable_key = select(2, ui.reference("AA", "Fake lag", "Enabled")),
        limit = ui.reference("AA", "Fake lag", "Limit"),
        type = ui.reference("AA", "Fake lag", "Amount"),
        variance = ui.reference("AA", "Fake lag", "Variance")
    },
    menu = {
        dpi_scale = ui.reference("MISC","Settings","DPI scale")
    }
}


local kenzo = {}

local screen = vector(client.screen_size())

gs.misc.menu_key:set("Toggle")

kenzo.ui = {
    tab = {
        tabs = {"Antiaim", "Visuals", "Misc", "Config"},
        icons = {
            ["Antiaim"] = "iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAAsTAAALEwEAmpwYAAAFp0lEQVR4nO2ZC2iWZRTHP3UtcOkqMy9TiW5api1ZaZMumEnXpRFlJVJpN7CMiojItrKoNMIy6WaKBIFmRrUsxa5Twm5kRRkjMrtt05rWUmutX5z5f+r07v2+vd82Vh98f3jZ95znec/znvOcc57/8yyVyiOPPPLI4/8A4DhgNfAL8DPwMlCayiUAI4BfaQuTDU/lCoBV+vDlwAA99tvwXCpXADToowc62SDJ6lM5aMigXDdklQutgXpyMrSGA00xyd7U3ckOXAn0Aw4BHgc+BT4CHgQOTqKgFKhW6bXnJeDYbvl6B2Ai8C2wLcaxW4D9U10J8w7wPvGoceM2JG0D1wEtTs8a4HhgPPCuZPMyfVRP4FIp3enCqgZYAEwDjgLGADdp5cK4OLztdNdk2b7Z6Rnm5OMk+yCTEc/QOczPfk1jv+VyMYuAg1zfaMk+SffyjRrwIzAV6AuUyOuG74GVwFdALbAYuETluVxj6rrCkABRJcMSywmgP/CiZE/EvdAL+EYDJkX6hkq+s82L/4yx2DV8l+oAgCHAuVqJCqtWkpcBe2JW3sJ5aJyisRpQm2aiAFN8gFbhYpXFza7/7iwNOFFe94lt+EPy0zXmDeA3YJciZGQ6hbe3vg6LnGEWo5dFDEmHn8wIW9mEBhwOPAv86UipsWwL17XAbqd7k0K4RxLFb+mlyWo/oHZlxBDbkLaLypjHbpHRBe3oL1AezZF3f3cV8a7onsDeVb/VQtXNvd5zwHQT2bIZitUOtXqiNySJt2NyrxLYEVnBZnm/pJ33C5U3W/XeFxk3wuiHaiJDUScNuc19/GfAI8AU87gb0weYJQqyMS6ERFU+lJ6l2RiSsZ2FIaEQnBrTd4w2Wb+hbsmg61BFjhWCw7rbkBASF6iMG2t4SlwpDjPa0bc048ab1JAQalkYYvmRDlYwHtUTQq9X5P3ztEFXqG18CxWc4kyes8pyTlDs+gMpXJalIVat7gC+VAWqFoMoFSUqEmMwnB9TKDZHeZUrRD8AM/9lPDA3xmO2/H3Vf7Q7p1yRjTEJi0GbJGcvTfIol/xIleKAmsAEgufu1JKFGm94NewRwHS3eY3qAiMOBBqlc0Kkr4eRQhdyaCVKXP+FLpIWx01goeCxyPVZoho+B/brpCHzpWtNTF+F+r7WTU744CblXW+NG5mW42mpDPc6qjBbfb2BjyVb2Akjhog3GUUZE9N/lcuDwXqM0gQYwb1GrMCwKaqgj0KrWTQ+xKnV7rM1ZpRkjYn4T7whT0rHcpfYdkR4WmFu7XUaY4e8Qo07CXgvEjHmjGnRCYxKG9ZHlg7RjKLItVFJB28zm+WwIyQz7wa07hF2mFJoRcO7pxz8vIw/M26Sh/VildrXR6wvk9y8ZDilA4bY5IbHHEEMFwwt8vBF6itz4T09m0lChRivdjiNBWVTJV+m9swsjThLH2qVb7BkD0nX6+JcIalbK6Pt9pLtSnSbowRE3KdAT+BBFruGOZHzy31ZsmDLNcNctz81Sz464qTaUBntWCvZuiSTGV02vKB2uSu1M/zO7orAygR6B7jEtQ+uCruxDlHRHJjiQvkEyYapvT2JIeEGZZbadggyLARO1u8NLnbblr22OsephKK/p7kVshMl4lL9XOjtcfPaxrcv8Ipkq5MYUqfBrVejwJtqT1YdNzS4XdnQmEFff3egei2c7mJWKBBCY8eBBi2QEYUuT+vtiJzEkLB7TlLs7hb/L5ZSoy/oQuAM/d6aQd/VLolDKE1wK1QXVkh9N0i+Qu197OJcsm2JaVEayr3E9d8f01+VQd+1GrNWJ7wql+x/r5AbP1t91bqGXeFCL/m//lSlKrUJNShGWzmN89A8edJW555Mtya63Itep7b4ZI+Mt9CKnu13hL3rP4XupDZq33gn7sgbGT9WNzr1Yt4juu9r88gjj1Qu4C8z6XMWmy9NqgAAAABJRU5ErkJggg==",
            ["Visuals"] = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAACbUlEQVR4nO2Zz04UQRDGZ7njjVUgeJGD+Ar+CRK8wQsIF5QHWJXEkGjC0dN6xN3AS+gLGB4DOKGIiA+gweRnKtQkRdvu9ozds4yZL6nLbFfX9/Xfqt4sa9CgQRIAY8CqWiurG7ggnmMlqxuALSNgK6sbaAREBnANmEu9hIA7Eqs00QHkPymZvpwwAT6bRsBm4KnV1/YSazymABkVi91hIoBZ4ADYB24FkN91YgTPdqiIflERgf2Oecj347AeHqgbod+3KQYmVMQXT5vrwLrO2Ae1HvAUaHvaf62EvCOiK+SBjvk+DewAv/g7zlXYlPF7pn11k5MfIOoucEo4vgMPs6sAYB746RD8KLMDLKl19JuF+NwfNflpHc0cnweNLLAAHJv234DJallfJrTjkJ8J8JlxRPSqYes/beyGnS/gu+hs7HZatn4S63bNl/DfM/5PUlRSLx3bkPTAtJOzPUenRJznxv+dk4JseOKHVXZOJeVi37STCyrHUgkBy8b/vfl+OCD+Sh0EHPyrgJY0BN449spmlYmX0GtP/MdRHwc0t4m1ideiEStAoK1HYI6FAr6PjN85MJGWbViNcBx4kd3U5C3HdjVs/WSmgDNHxOKQkbfkT4Eb1bL+k9QDTzK3p5t0We2Fs+YFP4B72VWAptO2MBmGsyKpR1ToTS1l4IkUI+b7pB6tdmO7kN+27bLhYqZOKiloAkvKCclt5GyXC0pNSK/5ThuqKikTFvVdp880Imr9rEL5h61DtdmRPmxx+WmxV8HT4lHUp0UNMA7cruBxdy46+TJo/h8YNf6HGVit+598La3s4lZSDRo0yCx+A9vty1OEtAO/AAAAAElFTkSuQmCC",
            ["Misc"] = "iVBORw0KGgoAAAANSUhEUgAAADwAAAA8CAYAAAA6/NlyAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEhUlEQVR4nO2aS4wWRRDHGwyyC7tCNBhAeWs8+wAfEDZRl2A4LMRwNVxAk0XgYjTqzYT14k3Fozw0ZgmPg8YjkICoYDjgYVeWRRc0QaKJCj4w8tNaamFsZnq6Z6a/HcL8jt9013R9011d9e82pqGhoSEAYBVwDjgLPGNudoB7gE7Hc3F0jBFHu06xZeoM8J468ivwdMrzKdxIe0q7FcBv+vwdU0eAeZYjp4DJVpsXUxzeaLVpA4asNveaugFMAy5bA/0M6AW2AgeBKykOX9Fn0mYj8Ln1/C/gDlNHgONUz5emjgAdwIUIDv8ITB0vp5YDA8BpYHXi94XAEeJxGFiQeN8a4AwwCHTFdHjQWnv7gF3AJeJzEdgJ7LdiwUBMh09TP4ZiOrw6I9K6kD35Q2A9sBiYAUySdQncByzVSP5JgZkiY+mJ5rCgUypkGs4wnmhisgn43tP+HhMbYEfgV3ijwDsk+XgV+DvH9vtxvPx/NHZNu+80iCX5HZhvCgA8oTZdM+ha9C4NMHcsy9E159p6TgIzdT+2p2R/iTGIzW9ytqypiWyv0J9rgG2J1O64JgBZSPSelej7XEqbrpJ5+ojj/TK2rxKp7bYiJZ4vfwAPWv0nAF9Y7U4At5Vw+mGPNZ1kdojxjkR5lscrGTYeS9nCNhR1WG32eY7pl+B0FOhOKdNshuwSMCeinweml3C4TVNKF1KWPln0BZOBow7jz3ssDXumvFXUYbX5kmM8R1wfwAtgi2PaTPHo/5rVT4LgA35vT7V3p251aWwqavcaWpin0R8wDYetvh/79C2Q7W0tY3cU4FCGce8ABDyb0v9nYDewyNdOwt7LGWM6EGrLzms3O4qFJSYAGUyGnZ8kgwu01ZVh6x+VidqL6MZ53B04SPmarcRP97Z0YxdB0VCncKsZaRy2kWng+ZVDp3Q/rUVy75UhA2zXAJAVtB4NdFi056ygtajCoNUbFLQComvItrQ2w9H+irelg6G2QhKP3QEz5UyLEo++MnZH0b04S5zzSS1frzi1vMuRWm4uajeZFrqKhxeMAzkEUxmmVcWDnEu1FTXcraVWmfJwV4Ty8NucMYn6siLUcGcFAsDjEQSANz3HJGPviCXx/Ak8ZPWfKKd+FUs8jwRKPGG3B4B3taMIY8dyRLzhpIYErKtYxJufkwydVw1NAqLwdtEXzbFkWpFEs/halEtdDj9ULNOeylE5RncLfbe/eJeHiN4pUddO5z6oUIhfmiPEXwotLYMBthP/qKVd9+/xPWoR9EzYl4shRYYumy0pSyKL/SYmQE/B49KPROGUgkP+AOB2de5+YJmeGH7qyKCykLGsudUOxIdjOjxg/bt7VWxv1ZUHiR97rFk2GNPhLr3nMZycSuNwqaVH01r5AMujOexC12SMa0sXfKqycYEb08kqOGbqCFeznLHUboyjKhP1qaCfdfXwgAoNvXpdMcnlWl495Grt6ywd1Xmb3pQDPDuVnGPqCNcLDinPuktcH35K9+/6Xh+2SsuOCi6ISxCcaW52uK57h+nGDQ0NDf/9A/8CAzCLhvIZtIsAAAAASUVORK5CYII=",
            ["Config"] = "iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAAsTAAALEwEAmpwYAAAA7klEQVR4nO2aQQ6CMBBFuzF6CDyxGo/Byh3qiYRb+EwTTExMpKUtjvW/JYuZecxPZgHOCSGiATbAERj4Hi2wShXxEhY4JclMbSLpLYX1f6UD1jkKvZF98un+3SwZgyLzZJgg96AR/bsoGcMicTLYFgmXwb6Ip61F5F6LCBJ5oo0EQiA5CjWuEMB2SZGLb1hI4rqkiAmcRIzhtBFjOG2kwo2cCx/FZrxVxUWKScRceDdFcoFMIJERbSQzKFojilZmULRGFK3MoGjVHC334VlpSJ2jJpHhB6J1CylwwD670B8GvEyPPXpgP/uTtRB/ygNEAWB0E6AAoQAAAABJRU5ErkJggg=="
        },
        active = "Antiaim"
    }
}

kenzo.aa = {
    state = "Default",
    states = { "Default", "Standing", "Moving", "Air", "Air Duck", "Ducking", "Duck Moving", "Slow Walk", "Use"}
}

local obex_data = obex_fetch and obex_fetch() or {username = "royalty", build = "Private", discord = "royalty"}

kenzo.info = {
    username = obex_data.username,
    build = obex_data.build,
    version = "0.1"
}

kenzo.visuals = {}

kenzo.rage = {}

kenzo.misc = {}

kenzo.config = {}

kenzo.util = {}


kenzo.var = {
    chokereversed = false,
    yaw_val = 0,
    tick_var = 0,
    yaw_jitter_val = 0,
    ground_ticks = 0,
    delayed_eq = 0,
    body_yaw_val = 0,
    yaw_jitter_type = "",
    body_yaw_type = "",
    last_sim_time = 0,
    defensive_until = 0
}

local visuals = {
    md = vector(screen.x / 2, screen.y / 2),
    wm = vector(screen.x, screen.y / screen.y)
}

print("Welcome to Kenzo, " .. kenzo.info.username .. " [Build: " .. kenzo.info.build .. " ~ Version: " .. kenzo.info.version .. "]")


function kenzo.util:hide_aa(bool)
    for _, v in pairs(gs.aa) do
        v:set_visible(not bool)
    end
end

local root = {
    rgba_to_hex = LPH_NO_VIRTUALIZE(function(r, g, b, a)
        return bit.tohex(
          (math.floor(r + 0.5) * 16777216) + 
          (math.floor(g + 0.5) * 65536) + 
          (math.floor(b + 0.5) * 256) + 
          (math.floor(a + 0.5))
        )
    end),
    extend_vector = LPH_NO_VIRTUALIZE(function(posx, posy, posz, length, angle)
        local rad = math.rad(angle)
        return posx + math.cos(rad) * length, posy + math.sin(rad)* length, posz
    end)
}

local helpers = {
    colour_text_menu = LPH_JIT(function(string_to_colour)
        local r, g, b, a = 145, 154, 217, 255
        return "\a" .. unpack({root.rgba_to_hex(r, g, b, a)}) .. string_to_colour .. "\aCDCDCDFF "
    end),
    chokerev = LPH_NO_VIRTUALIZE(function(a, b)
        return kenzo.var.chokereversed and a or b
    end),
    normalise_angle = LPH_NO_VIRTUALIZE(function(angle)
	    angle =  angle % 360 
	    angle = (angle + 360) % 360
	    if (angle > 180)  then
	    	angle = angle - 360
	    end
	    return angle
    end),
    -- Credit: XO-YAW SRC LEAK
    defensive_active = LPH_JIT(function()
    if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
        local tickcount = globals.tickcount()
        local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
        local sim_diff = sim_time - kenzo.var.last_sim_time

        if sim_diff < 0 then
            kenzo.var.defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
        end

        kenzo.var.last_sim_time = sim_time

        return kenzo.var.defensive_until > tickcount
    end),
    contains = LPH_NO_VIRTUALIZE(function(t, v)
        for i, vv in pairs(t) do
            if vv == v then
                return true
            end
        end
        return false
    end),
    freestanding_side = LPH_NO_VIRTUALIZE(function(reversed_traces, dormant)

        if kenzo.current_target == nil and not dormant then
            return nil
        end
    
        local me = entity.get_local_player()
    
        local lx, ly, lz = entity.get_origin(me)
        lz = lz + 64
    
        local ex, ey, ez
    
        if not dormant then
    
            ex, ey, ez = entity.get_origin(kenzo.current_target)
            ez = ez + 64
    
        end
    
        local data = {left = 0, right = 0}
        local angles = {-45, -30, 30, 45}
        local _, yaw = client.camera_angles()
    
        for i, angle in ipairs(angles) do
            local damage = 0
            if dormant then
                local headx, heady, headz = root.extend_vector(lx, ly, lz, 8000, yaw + angle)
                local fraction = client.trace_line(me, lx, ly, lz, headx, heady, headz)
                data[angle > 0 and "right" or "left"] = data[angle > 0 and "right" or "left"] + fraction
            else
                if not reversed_traces then
                    local headx, heady, headz = root.extend_vector(lx, ly, lz, 200, kenzo.current_target_angle + angle)
                    _, damage = client.trace_bullet(kenzo.current_target, ex, ey, ez, headx, heady, headz, kenzo.current_target)
                    data[angle > 0 and "right" or "left"] = data[angle > 0 and "right" or "left"] + damage
                else
                    local headx, heady, headz = root.extend_vector(ex, ey, ez, 200, kenzo.current_target_angle - angle)
                    _, damage = client.trace_bullet(me, lx, ly, lz, headx, heady, headz, me)
                    data[angle < 0 and "right" or "left"] = data[angle > 0 and "right" or "left"] + damage
                end
            end
        end
    
        if data.left > data.right then
            return 1
    
        elseif data.right > data.left then
            return 0
    
        else
           return 2
    
        end
    end)
}


-- UI
kenzo.ui.main_aa_label = ui.new_label(nil, "AA", "Anti-aimbot angles", "\a9F9F9F6B ›› Anti-aim Tab"):add_condition(function() return kenzo.ui.tab.active == "Antiaim" end)

kenzo.ui.master = ui.new_checkbox(":mstr", "AA", "Anti-aimbot angles", "Enable anti-aim"):add_condition(function()
    return kenzo.ui.tab.active == "Antiaim" end):set_callback(function(val)
    if val:get() then
        gs.aa.master:set(true)
    end
end)

kenzo.ui.state = kenzo.ui.master:combo(nil, "AA", "Anti-aimbot angles", "State", kenzo.aa.states):add_condition(function()
    return kenzo.ui.tab.active == "Antiaim"
end)


for i = 1, #kenzo.aa.states do
    local state = kenzo.aa.states[i]
    kenzo.ui.state[state] = {}

    if state ~= "Default" then
        kenzo.ui.state[state].master = kenzo.ui.master:checkbox(state..":e", "AA", "Anti-aimbot angles", "Enable " .. state, false):add_condition(function() return kenzo.ui.tab.active == "Antiaim" and kenzo.ui.state:get() == state end)
    end

    local x = state == "Default" and kenzo.ui.master or kenzo.ui.state[state].master

    local con = function() return kenzo.ui.state:get() == state and kenzo.ui.master:get() and kenzo.ui.tab.active == "Antiaim" and (state == "Default" and true or kenzo.ui.state[state].master:get()) end
    kenzo.ui.state[state].state_type            = ui.new_label(nil, "AA", "Anti-aimbot angles", " > State: " .. state):add_condition(function() return con() end)
    kenzo.ui.state[state].pitch                 = x:combo(state..":p", "AA", "Anti-aimbot angles", "Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}):add_condition(function() return con() end)
    kenzo.ui.state[state].yaw_base              = x:combo(state..":yb", "AA", "Anti-aimbot angles", "Yaw base", {"Local view", "At targets"}):add_condition(function() return con() end)
    kenzo.ui.state[state].yaw                   = x:combo(state..":y", "AA", "Anti-aimbot angles", "Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}):add_condition(function() return con() end)
    kenzo.ui.state[state].yaw_type              = kenzo.ui.state[state].yaw:combo(state..":yt", "AA", "Anti-aimbot angles", "Yaw type", {"Jitter", "Delayed", "Sway"}):add_condition(function() return con() and kenzo.ui.state[state].yaw:get() ~= "Off" end)
    kenzo.ui.state[state].yaw_delayed           = kenzo.ui.state[state].yaw_type:slider(state..":ytd", "AA", "Anti-aimbot angles", "Delay", 2, 20, 2, true, "t"):add_condition(function() return con() and kenzo.ui.state[state].yaw:get() and kenzo.ui.state[state].yaw_type:get() == "Delayed" and kenzo.ui.state[state].yaw:get() ~= "Off" end)
    kenzo.ui.state[state].yaw_offset_left       = kenzo.ui.state[state].yaw:slider(state..":yol", "AA", "Anti-aimbot angles", "Yaw offset left", -180, 180, 0, true, "°"):add_condition(function() return con() and kenzo.ui.state[state].yaw:get() and kenzo.ui.state[state].yaw_type:get() ~= "Sway" and kenzo.ui.state[state].yaw:get() ~= "Off" end)
    kenzo.ui.state[state].yaw_offset_right      = kenzo.ui.state[state].yaw:slider(state..":yor", "AA", "Anti-aimbot angles", "Yaw offset right", -180, 180, 0, true, "°"):add_condition(function() return con() and kenzo.ui.state[state].yaw:get() and kenzo.ui.state[state].yaw_type:get() ~= "Sway" and kenzo.ui.state[state].yaw:get() ~= "Off" end)
    kenzo.ui.state[state].yaw_jitter            = x:combo(state..":yj", "AA", "Anti-aimbot angles", "Yaw jitter", {"Off", "Offset", "Center", "Random"}):add_condition(function() return con() and kenzo.ui.state[state].yaw_type:get() ~= "Delayed" end)
    kenzo.ui.state[state].yaw_jitter_d          = x:combo(state..":yjd", "AA", "Anti-aimbot angles", "Yaw jitter", {"Off", "Offset", "Center"}):add_condition(function() return con() and kenzo.ui.state[state].yaw_type:get() == "Delayed" end)
    kenzo.ui.state[state].yaw_jitter_offset     = kenzo.ui.state[state].yaw_jitter:slider(state..":yjo", "AA", "Anti-aimbot angles", "Yaw jitter", -180, 180, 0, true, "°"):add_condition(function() return con() and (kenzo.ui.state[state].yaw_jitter:get() ~= "Off" or kenzo.ui.state[state].yaw_jitter_d:get() ~= "Off") end)
    kenzo.ui.state[state].body_yaw              = x:combo(state..":by", "AA", "Anti-aimbot angles", "Body yaw", {"Off", "Opposite", "Jitter", "Static"}):add_condition(function() return con() and kenzo.ui.state[state].yaw_type:get() ~= "Delayed" end)
    kenzo.ui.state[state].body_yaw_offset       = kenzo.ui.state[state].body_yaw:slider(state..":byo", "AA", "Anti-aimbot angles", "Body yaw offset", -180, 180, 0, true, "°"):add_condition(function() return con() and kenzo.ui.state[state].body_yaw:get() ~= "Opposite" and kenzo.ui.state[state].body_yaw:get() ~= "Off" and kenzo.ui.state[state].yaw_type:get() ~= "Delayed" end)
    kenzo.ui.state[state].defensive_label       = x:label(nil, "AA", "Anti-aimbot angles", "\a9F9F9F6B › Inherits above settings"):add_condition(function() return con()end)
    kenzo.ui.state[state].defensive_pitch       = x:combo(state.."dfp", "AA", "Anti-aimbot angles", "Defensive pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}):add_condition(function() return con()end)
    kenzo.ui.state[state].defensive_yaw         = x:combo(state.."dfy", "AA", "Anti-aimbot angles", "Defensive yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}):add_condition(function() return con()end)
    kenzo.ui.state[state].defensive_yaw_offset  = kenzo.ui.state[state].defensive_yaw:slider(state.."dfyo", "AA", "Anti-aimbot angles", "Defensive yaw offset", -180, 180, 0, true, "°"):add_condition(function() return con() and kenzo.ui.state[state].defensive_yaw:get() ~= "Off" end)



end
kenzo.ui.misc_aa_label = ui.new_label(nil, "AA", "Anti-aimbot angles", "\a9F9F9F6B › Miscellaneous settings"):add_condition(function() return kenzo.ui.tab.active == "Antiaim" and kenzo.ui.master:get() end)
kenzo.ui.freestanding_disablers = ui.new_multiselect(nil, "AA", "Anti-aimbot angles", "Freestanding disablers", "Default", "Standing", "Moving", "Air", "Air Duck", "Ducking", "Duck Moving", "Slow Walk", "Use"):add_condition(function() return kenzo.ui.tab.active == "Antiaim" and kenzo.ui.master:get() end)
kenzo.ui.freestanding_key = ui.new_hotkey(nil, "AA", "Anti-aimbot angles", "Freestanding key", false, 0):add_condition(function() return kenzo.ui.tab.active == "Antiaim" and kenzo.ui.master:get() end)
kenzo.ui.freestanding_jitter = ui.new_checkbox(nil, "AA", "Anti-aimbot angles", "Freestanding jitter", false):add_condition(function() return kenzo.ui.tab.active == "Antiaim" and kenzo.ui.master:get() end)

kenzo.visuals.main_misc_label = ui.new_label(nil, "AA", "Anti-aimbot angles", "\a9F9F9F6B ›› Miscellaneous tab"):add_condition(function() return kenzo.ui.tab.active == "Misc" end)

kenzo.visuals.main_visual_label = ui.new_label(nil, "AA", "Anti-aimbot angles", "\a9F9F9F6B ›› Visuals tab"):add_condition(function() return kenzo.ui.tab.active == "Visuals" end)

kenzo.visuals.mindmg_indicator = ui.new_checkbox(nil, "AA", "Anti-aimbot angles", "Minimum damage indicator"):add_condition(function() return kenzo.ui.tab.active == "Visuals" end)
kenzo.visuals.mindmg_indicator_colour = ui.new_color_picker(nil, "AA", "Anti-aimbot angles", "inline minimum damage", 255, 255, 255, 255):add_condition(function() return kenzo.ui.tab.active == "Visuals" end)


kenzo.config.main_config_label = ui.new_label(nil, "AA", "Anti-aimbot angles", "\a9F9F9F6B ›› Config tab"):add_condition(function() return kenzo.ui.tab.active == "Config" end)

kenzo.config.export = ui.new_button(nil, "AA", "Anti-aimbot angles", "Export to clipboard", function() end):add_condition(function() return kenzo.ui.tab.active == "Config" end)
kenzo.config.import = ui.new_button(nil, "AA", "Anti-aimbot angles", "Import from clipboard", function() end):add_condition(function() return kenzo.ui.tab.active == "Config" end)
kenzo.config.save_root = ui.new_button(nil, "AA", "Anti-aimbot angles", "Save to computer", function() end):add_condition(function() return kenzo.ui.tab.active == "Config" end)
kenzo.config.load_button = ui.new_button(nil, "AA", "Anti-aimbot angles", "Load from file", function() end):add_condition(function() return kenzo.ui.tab.active == "Config" end)

function kenzo.ui.tab:handle()
    if not ui.is_menu_open() then return end

    local mouse = ui.mouse_position()
    local menu = ui.menu_position()
    local menu_size = ui.menu_size()
    local mouse_down = client.key_state(0x01)

    local h = 50

    renderer.rectangle(menu.x, menu.y - (h+6), menu_size.x, (h+6), 0, 0, 0, 255)

    renderer.rectangle(menu.x + 1, menu.y - ((h+6)-1), menu_size.x - 2, ((h+6)-1), 57, 57, 57, 255)
    renderer.rectangle(menu.x + 2, menu.y - ((h+6)-2), menu_size.x - 4, ((h+6)-2), 40, 40, 40, 255)
    renderer.rectangle(menu.x + 5, menu.y - ((h+6)-5), menu_size.x - 10, ((h+6)-5), 57, 57, 57, 255)
    renderer.gradient(menu.x + 7, menu.y - (h + 1), menu_size.x - 14, 2, 145, 154, 217, 255, 25, 25, 32, 255, true)


    for i, tab in pairs(self.tabs) do
        local tab_size = vector((menu_size.x - 12) / #self.tabs, h)
        local tab_pos = vector(menu.x + 6 + (tab_size.x * (i - 1)), menu.y - h)
        local hovering = mouse.x >= tab_pos.x and mouse.x <= tab_pos.x + tab_size.x and mouse.y >= tab_pos.y and mouse.y <= tab_pos.y + tab_size.y
        local active = self.active == tab

        if hovering then
            if mouse_down then
                self.active = tab
                kenzo.ui.master:handle_visibility()
            end
        end

        local c = active and 255 or hovering and 200 or 150

        renderer.rectangle(tab_pos.x - 1, tab_pos.y, tab_size.x + 2, tab_size.y, active and 22 or 12, active and 22 or 12, active and 22 or 12, 255)

        if self.icons[tab] then
            local icon = images.load(base64.decode(self.icons[tab]))
            local icon_size = vector(icon:measure())
            icon:draw(tab_pos.x + (tab_size.x / 2) - 15, tab_pos.y + (tab_size.y / 2) - 15, 30, 30, c, c, c, 255)
        else
            renderer.text(tab_pos.x + tab_size.x / 2, tab_pos.y + tab_size.y / 2, 255, 255, 255, 255, "c", 0, tab)
        end
    end
end

on_use = function(cmd)

    local in_use = cmd.in_use == 1
    local me = entity.get_local_player()
    
    if not me or not entity.is_alive(me) then 
        return 
    end

    local weapon_ent = entity.get_player_weapon(me)

    if weapon_ent == nil then 
        return 
    end

    local weapon = csgo_weapons(weapon_ent)

    if weapon == nil then 
        return 
    end

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
        cmd.in_use = 0
        return true
    end
end

kenzo.ui.get_state = function(cmd)
    local me = entity.get_local_player()
    local flags = entity.get_prop(me, "m_fFlags")
    local vel1, vel2, vel3 = entity.get_prop(me, 'm_vecVelocity')
    local speed = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))
    local ducking       = cmd.in_duck == 1
    local air           = kenzo.var.ground_ticks < 5
    local walking       = speed > 5
    local standing      = speed <= 5
    local slow_motion   = ui.get(gs.misc.slow_motion) and ui.get(gs.misc.slow_motion_key)
    local fakeducking   = ui.get(gs.misc.fakeducking)
    local use           = on_use(cmd)
    kenzo.var.ground_ticks = bit.band(flags, 1) == 0 and 0 or (kenzo.var.ground_ticks < 5 and kenzo.var.ground_ticks + 1 or kenzo.var.ground_ticks)

    if use then
        state = "Use"
    elseif air and not ducking then
        state = "Air"
    elseif air and ducking then
        state = "Air Duck"
    elseif (fakeducking or ducking) and walking then
        state = "Duck Moving"
    elseif fakeducking or ducking then
        state = "Ducking"
    elseif slow_motion then
        state = "Slow Walk"
    elseif standing then
        state = "Standing"
    elseif walking then
        state = "Moving"
    end

    kenzo.aa.state = state
    -- { "Default", "Standing", "Moving", "Air", "Air Duck", "Ducking", "Duck Moving", "Slow Walk"}
    return state
end

kenzo.ui.handle_freestanding_disablers = function()
    local freestanding = kenzo.ui.freestanding_key:get() and not helpers.contains(kenzo.ui.freestanding_disablers:get(), kenzo.aa.state)
    if kenzo.ui.freestanding_jitter:get() == false and freestanding and kenzo.ui.freestanding_key:get() then
        gs.aa.yaw_jitter:set("Off")
        gs.aa.yaw_offset:set(0)
        gs.aa.body_yaw:set("Static")
        gs.aa.body_yaw_offset:set(180)
    else
    end
    gs.aa.freestanding_key:set(freestanding and "Always on" or "On hotkey")
    gs.aa.freestanding:set(freestanding and true or false)
end

kenzo.ui.handle_antiaim = function(cmd)

    local state = kenzo.aa.state

    if not kenzo.ui.master:get() then
        return end
    
    if state ~= "Default" and not ui.get(kenzo.ui.state[state].master) then
        state = "Default"
    end

    local defensive_master = kenzo.ui.state[state].defensive_pitch:get() == "Off" and kenzo.ui.state[state].defensive_yaw:get() == "Off"
    local defensive = defensive_master == false and helpers.defensive_active()

    if globals.tickcount() - kenzo.var.tick_var > 0 and cmd.chokedcommands == 0 then
        kenzo.var.chokereversed = not kenzo.var.chokereversed
        kenzo.var.tick_var = globals.tickcount()
    end
    if not defensive then
        gs.aa.pitch:set(kenzo.ui.state[state].pitch:get())
    end
    gs.aa.yaw_base:set(kenzo.ui.state[state].yaw_base:get())
    gs.aa.yaw:set(kenzo.ui.state[state].yaw:get())
    gs.aa.body_yaw_offset:set(kenzo.ui.state[state].body_yaw_offset:get())

    if kenzo.ui.state[state].yaw_type:get() == "Jitter" then
        kenzo.var.yaw_val = helpers.chokerev(kenzo.ui.state[state].yaw_offset_left:get(), kenzo.ui.state[state].yaw_offset_right:get())
        kenzo.var.yaw_jitter_val = kenzo.ui.state[state].yaw_jitter_offset:get()
        kenzo.var.body_yaw_val = kenzo.ui.state[state].body_yaw_offset:get()
        kenzo.var.yaw_jitter_type = kenzo.ui.state[state].yaw_jitter:get()
        kenzo.var.body_yaw_type = kenzo.ui.state[state].body_yaw:get()

    elseif kenzo.ui.state[state].yaw_type:get() == "Delayed" then
        if cmd.chokedcommands == 0 then
            local ticks = ui.get(kenzo.ui.state[state].yaw_delayed) * 2

            inversion = cmd.command_number % ticks >= ticks / 2
        end

        kenzo.var.delayed_eq = inversion and kenzo.ui.state[state].yaw_offset_left:get() or kenzo.ui.state[state].yaw_offset_right:get()
        if ui.get(kenzo.ui.state[state].yaw_jitter_d) == "Center" then
            local yaw_offset_c = kenzo.var.delayed_eq + helpers.normalise_angle(inversion and -kenzo.ui.state[state].yaw_jitter_offset:get() or kenzo.ui.state[state].yaw_jitter_offset:get())

            yaw_offset_c = yaw_offset_c % 360

            if yaw_offset_c > 180 then
                yaw_offset_c = yaw_offset_c - 360
            end

            kenzo.var.yaw_val = yaw_offset_c
            
            kenzo.var.body_yaw_val = yaw_offset_c
            kenzo.var.yaw_jitter_type = "Off"
            kenzo.var.body_yaw_type = "Static"
        elseif ui.get(kenzo.ui.state[state].yaw_jitter_d) == "Offset" then

            local yaw_offset_o = kenzo.var.delayed_eq + helpers.normalise_angle(inversion and 0 or kenzo.ui.state[state].yaw_jitter_offset:get())

            yaw_offset_o = yaw_offset_o % 360

            if yaw_offset_o > 180 then
                yaw_offset_o = yaw_offset_o - 360
            end

            kenzo.var.yaw_val = yaw_offset_o

            kenzo.var.yaw_jitter_type = "Off"
            kenzo.var.body_yaw_type = "Static"
           
            kenzo.var.body_yaw_val = yaw_offset_o
            
        end
    end

    if not defensive then
        gs.aa.yaw_offset:set(kenzo.var.yaw_val)
    end
    gs.aa.yaw_jitter_offset:set(kenzo.var.yaw_jitter_val)
    gs.aa.yaw_jitter:set(kenzo.var.yaw_jitter_type)
    gs.aa.body_yaw_offset:set(kenzo.var.body_yaw_val)
    gs.aa.body_yaw:set(kenzo.var.body_yaw_type)

    if defensive then
        gs.aa.pitch:set(kenzo.ui.state[state].defensive_pitch:get())
        gs.aa.yaw:set(kenzo.ui.state[state].defensive_yaw:get())
        gs.aa.yaw_offset:set(kenzo.ui.state[state].defensive_yaw_offset:get())
    end


    --yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    --pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
    --pitch_offset = select(2, ui.reference("AA", "Anti-aimbot angles", "Pitch")),
    --yaw = select(1, ui.reference("AA", "Anti-aimbot angles", "Yaw")),
    --yaw_offset = select(2, ui.reference("AA", "Anti-aimbot angles", "Yaw")),
    --yaw_jitter = select(1, ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")),
    --yaw_jitter_offset = select(2, ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")),
    --body_yaw = select(1, ui.reference("AA", "Anti-aimbot angles", "Body yaw")),
    --body_yaw_offset = select(2, ui.reference("AA", "Anti-aimbot angles", "Body yaw")),
    --freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    --edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    --freestanding = select(1, ui.reference("AA", "Anti-aimbot angles", "Freestanding")),
    --freestanding_key = select(2, ui.reference("AA", "Anti-aimbot angles", "Freestanding")),


end

-- Config Handler

ui.set_callback(kenzo.config.export, function()
    print("Succesfully Exported Config to 'Clipboard'.")
    clipboard.set(ui.get_config())
end)

ui.set_callback(kenzo.config.import, function()
    print("Succesfully Imported Config from 'Clipboard' to 'Settings'.")
    ui.load_config(clipboard.get())
end)

ui.set_callback(kenzo.config.save_root, function()
    if readfile("kenzo_cfg.txt") == nil then
        writefile("kenzo_cfg.txt", ui.get_config())
        print("Saved config to CS:GO directory 'kenzo_cfg.txt'.")
    else
        print("Overwritten saved config.")
        writefile("kenzo_cfg.txt", ui.get_config())
    end
end)

ui.set_callback(kenzo.config.load_button, function()
    if readfile("kenzo_cfg.txt") == nil then
        print("Save a config file first then retry.")
    else
        ui.load_config(readfile("kenzo_cfg.txt"))
        print("Succesfully loaded saved config.")
    end
end)


kenzo.ui.minimum_damage_indicator_handle = function()

    if entity.is_alive(entity.get_local_player()) == nil then
        return end

    local min_slider = min_dmg_slider_func()
    local min_dmg = min_dmg_override_func()
    local min_key = min_dmg_key_func()

    if not kenzo.visuals.mindmg_indicator:get() then
        return end

    local colour = {kenzo.visuals.mindmg_indicator_colour:get()}

    if min_dmg and min_key then
        renderer.text(visuals.md.x + 15, visuals.md.y - 35, colour[1], colour[2], colour[3], 255, "", 0, min_slider)
    end

end


kenzo.ui.watermark = function()

    local text = vector(renderer.measure_text("", "Kenzo " .. kenzo.info.build))
    
    renderer.text(visuals.wm.x - text.x - 30, visuals.wm.y + 15, 255, 255, 255, 255, "", nil, "Kenzo " .. kenzo.info.build)

end

client.set_event_callback("setup_command", function(cmd)

    kenzo.ui.get_state(cmd)

    kenzo.ui.handle_antiaim(cmd)

    kenzo.ui.handle_freestanding_disablers()

end)

client.set_event_callback("paint_ui", function()

    if cur_tab == 2 then
        kenzo.ui.tab:handle()
    end

    kenzo.util:hide_aa(true)

    kenzo.ui.watermark()

end)

client.set_event_callback("paint", function()

    kenzo.ui.minimum_damage_indicator_handle()

end)

client.set_event_callback("shutdown", function()

    kenzo.util:hide_aa(false)

end)