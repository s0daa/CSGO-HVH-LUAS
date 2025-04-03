-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
--███████╗███╗░░░███╗░█████╗░████████╗██╗░█████╗░███╗░░██╗░█████╗░██╗░░░░░   
--██╔════╝████╗░████║██╔══██╗╚══██╔══╝██║██╔══██╗████╗░██║██╔══██╗██║░░░░░   
--█████╗░░██╔████╔██║██║░░██║░░░██║░░░██║██║░░██║██╔██╗██║███████║██║░░░░░   
--██╔══╝░░██║╚██╔╝██║██║░░██║░░░██║░░░██║██║░░██║██║╚████║██╔══██║██║░░░░░   
--███████╗██║░╚═╝░██║╚█████╔╝░░░██║░░░██║╚█████╔╝██║░╚███║██║░░██║███████╗   通过罗杰
--╚══════╝╚═╝░░░░░╚═╝░╚════╝░░░░╚═╝░░░╚═╝░╚════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚══════╝   


-- Required Workshop Libraries

local trace, csgo_weapons, ease, anti_aim, clipboard, images = require("gamesense/trace"), require("gamesense/csgo_weapons"), require("gamesense/easing"), require("gamesense/antiaim_funcs"), require("gamesense/clipboard"), require("gamesense/images")

local vector = require("vector")

-- Global Variables

local em = {
    ui = {
        elements = {},
        meta_elements = {},
        aa = {
            states = {}
        },
        visuals = {},
        rage = {}
    },
    util = {},
    aa = {
        states = {"Default", "Standing", "Moving", "Air", "Air Duck", "Ducking", "Slowwalk", "On key"},
        state = "Default",
        ground_ticks = 0,
        use = false,
    },
    visuals = {
        indicators = {
            em = {
                title_pos = vector(select(1, client.screen_size())/2, select(2, client.screen_size())/2),
                state_pos = vector(select(1, client.screen_size())/2, select(2, client.screen_size())/2),
                exploit_pos = vector(select(1, client.screen_size())/2, select(2, client.screen_size())/2),
                binds_pos = vector(select(1, client.screen_size())/2, select(2, client.screen_size())/2),
                dmg_pos = vector(select(1, client.screen_size())/2, select(2, client.screen_size())/2),
            },
            ideal_yaw = {
                title_pos = vector(select(1, client.screen_size())/2, select(2, client.screen_size())/2),
                mode_pos = vector(select(1, client.screen_size())/2, select(2, client.screen_size())/2),
                exploit_pos = vector(select(1, client.screen_size())/2, select(2, client.screen_size())/2),
            },
            chimera = {
                title_pos = vector(select(1, client.screen_size())/2, select(2, client.screen_size())/2),
                desync_pos = vector(select(1, client.screen_size())/2, select(2, client.screen_size())/2),
                exploit_pos = vector(select(1, client.screen_size())/2, select(2, client.screen_size())/2),
                left = { r = 255, g = 255, b = 255, a = 255 },
                right = { r = 255, g = 255, b = 255, a = 255 },
                charge = 0
            },
            charge = { r = 255, g = 255, b = 255, a = 255 }
        },
        panels = {
            keybinds = {
                refs = { ["Doubletap"] = {ui.reference("rage", "other", "double tap")}, ["On shot anti-aim"] = {ui.reference("aa", "other", "on shot anti-aim")}, ["Quick peek assist"] = {ui.reference("rage", "other", "quick peek assist")}, ["Force body aim"] = ui.reference("rage", "other", "force body aim"), ["Force safe point"] = ui.reference("rage", "aimbot", "force safe point"), ["Fakeduck"] = ui.reference("rage", "other", "duck peek assist"), ["Ping spike"] = {ui.reference("misc", "miscellaneous", "ping spike")} },
                list = {},
                modes = {"[always on]", "[holding]", "[toggled]", "[off hotkey]" },
                hovering = false,
                dragging = false,
                in_drag = false,
                drag_pos = vector(0, 0),
                pos = vector(500, 500),
                size = vector(0, 0),
                opacity = 0
            },
            spectators = {
                list = {},
                hovering = false,
                dragging = false,
                in_drag = false,
                drag_pos = vector(0, 0),
                pos = vector(700, 500),
                size = vector(0, 0),
                opacity = 0

            },
            watermark = {
                username = "unknown"
            }
        }
    },
    rage = {
        roll_resolver = { list = {} }
    },
}

function em.visuals.panels:init_from_database()
    local data = database.read("😍emotional🤪") or {}

    if data.loc == nil then
        return
    end

    local keybinds = vector(data.loc.keybinds.x, data.loc.keybinds.y)
    local spectators = vector(data.loc.spectators.x, data.loc.spectators.y)

    self.keybinds.pos = keybinds
    self.spectators.pos = spectators
end



em.ui.meta_elements.__index = em.ui.meta_elements

-- Roger UI Library
em.ui.new = function(uid, item)
    
    if item == nil then print("[EMOTIONAL] Item cannot be nil") return end

    local element = setmetatable({uid = uid, item = item, callback = function() end, conditions = {} }, em.ui.meta_elements)

    table.insert(em.ui.elements, element)

    ui.set_callback(item, function(val)
        element.callback(val)
    end)

    return element
end

function em.ui.meta_elements:get_parents()
    local parents = {}
    local parent = self.parent

    while parent ~= nil do
        table.insert(parents, parent)
        parent = parent.parent
    end

    return parents
end

function em.ui.meta_elements:add_condition(condition)
    if type(condition) ~= "function" then
        print("[EMOTIONAL] Condition must be a function")
        return
    end

    table.insert(self.conditions, condition)

    return self
end

function em.ui.meta_elements:set_callback(callback)
    if type(callback) ~= "function" then
        print("[EMOTIONAL] Callback must be a function")
        return
    end
    self.callback = callback

    return self
end

function em.ui.meta_elements:get()
    return ui.get(self.item)
end

function em.ui.meta_elements:set(value)
    ui.set(self.item, value)
end

function em.ui.meta_elements:handle_visibility()
    for _, element in pairs(em.ui.elements) do
        local visible = true
        for _, condition in pairs(element.conditions) do
            if not condition() then
                visible = false
                break
            end
        end

        for _, parent in pairs(element:get_parents()) do
            if not ui.get(parent.item) then
                visible = false
                break
            end
        end
        ui.set_visible(element.item, visible)
    end
end

function em.ui.meta_elements:init()
    table.insert(em.ui.elements, self)

    self.parent:handle_visibility()
    
    ui.set_callback(self.parent.item, function(val)
        self.parent:handle_visibility()
        self.parent.callback(val)
    end)

    ui.set_callback(self.item, function(val)
        self.parent:handle_visibility()
        self.callback(val)
    end)
end

function em.ui.meta_elements:checkbox(uid, tab, container, name)
    local item = ui.new_checkbox(tab, container, name)
    local element = setmetatable({uid = uid, item = item, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, em.ui.meta_elements)

    element:init()

    return element
end

function em.ui.meta_elements:slider(uid, ...)
    local item = ui.new_slider(...)
    local element = setmetatable({uid = uid, item = item, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, em.ui.meta_elements)

    element:init()

    return element
end

function em.ui.meta_elements:color_picker(uid, ...)
    local item = ui.new_color_picker(...)
    local element = setmetatable({uid = uid, item = item, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, em.ui.meta_elements)

    element:init()

    return element
end

function em.ui.meta_elements:combo(uid, ...)
    local item = ui.new_combobox(...)
    local element = setmetatable({uid = uid, item = item, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, em.ui.meta_elements)

    element:init()

    return element
end

function em.ui.meta_elements:hotkey(uid, ...)
    local item = ui.new_hotkey(...)
    local element = setmetatable({uid = uid, item = item, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, em.ui.meta_elements)

    element:init()

    return element
end

function em.ui.meta_elements:label(uid, ...)
    local item = ui.new_label(...)
    local element = setmetatable({uid = uid, item = item, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, em.ui.meta_elements)

    element:init()

    return element
end

function em.ui.meta_elements:listbox(uid, ...)
    local item = ui.new_listbox(...)
    local element = setmetatable({uid = uid, item = item, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, em.ui.meta_elements)

    element:init()

    return element
end

function em.ui.meta_elements:multiselect(uid, ...)
    local item = ui.new_multiselect(...)
    local element = setmetatable({uid = uid, item = item, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, em.ui.meta_elements)

    element:init()

    return element
end

function em.ui.meta_elements:textbox(uid, ...)
    local item = ui.new_textbox(...)
    local element = setmetatable({uid = uid, item = item, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, em.ui.meta_elements)

    element:init()

    return element
end

function em.ui.meta_elements:button(...)
    local item = ui.new_button(...)
    local element = setmetatable({uid = nil, item = item, parent = self, callback = function() end, conditions = {}, config = uid ~= nil }, em.ui.meta_elements)

    element:init()

    return element
end

-- Gamesense References

local refs = {
    aa = {
        master = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
        yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
        pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
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
        fake_yaw_limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
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
        thirdperson_key = select(2, ui.reference("Visuals", "Effects", "Force third person (alive)"))
    },
    rage = {
        double_tap = select(1, ui.reference("RAGE", "Other", "Double tap")),
        double_tap_key = select(2, ui.reference("RAGE", "Other", "Double tap")),
        sv_maxusrcmdprocessticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
        holdaim = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks_holdaim"),
        baim = ui.reference("RAGE", "Other", "Force body aim"),
        prefer_bodyaim = ui.reference("RAGE", "Other", "Prefer body aim"),
        prefer_safepoint = ui.reference("RAGE", "Aimbot", "Prefer safe point"),
        sp = ui.reference("RAGE", "Aimbot", "Force safe point")
    },
    fakelag = {
        enable = select(1, ui.reference("AA", "Fake lag", "Enabled")),
        enable_key = select(2, ui.reference("AA", "Fake lag", "Enabled")),
        limit = ui.reference("AA", "Fake lag", "Limit"),
        type = ui.reference("AA", "Fake lag", "Amount"),
        variance = ui.reference("AA", "Fake lag", "Variance")
    }
}

function em:save_database()
    local data = database.read("😍emotional🤪") or {}

    if data.loc == nil then
        data.loc = {}
    end

    local keybinds, spectators = self.visuals.panels.keybinds.pos, self.visuals.panels.spectators.pos

    data.loc.keybinds = { x = keybinds.x, y = keybinds.y }
    data.loc.spectators = { x = spectators.x, y = spectators.y }

    database.write("😍emotional🤪", data)
end

-- Emotional Utils
function em.util:hide_aa(bool)
    for _, v in pairs(refs.aa) do
        ui.set_visible(v, not bool)
    end
end

function em.util:to_hex(r, g, b, a)
    return string.format("%02x%02x%02x%02x", r, g, b, a)
end

function contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function color(r, g, b, a)
    return {r = r, g = g, b = b, a = a}
end

function em.util:pulsate(speed)
    return math.sin(math.abs(-math.pi + (globals.curtime() * speed) % (math.pi * 2))) * 255
end

function em.util:handle_state(cmd)
    local me = entity.get_local_player()

    if not me or not entity.is_alive(me) then
        return
    end

    local flags = entity.get_prop(me, "m_fFlags")
    local vel1, vel2, vel3 = entity.get_prop(me, 'm_vecVelocity')
    local speed = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))

    local ducking       = cmd.in_duck == 1
    local air           = em.aa.ground_ticks < 5
    local walking       = speed >= 2
    local standing      = speed <= 1
    local slow_motion   = ui.get(refs.misc.slow_motion) and ui.get(refs.misc.slow_motion_key)
    local fakeducking   = ui.get(refs.misc.fakeducking)
    local on_key = em.ui.aa.on_key_key:get()
    em.aa.ground_ticks = bit.band(flags, 1) == 0 and 0 or (em.aa.ground_ticks < 5 and em.aa.ground_ticks + 1 or em.aa.ground_ticks)

    local state = "Default"
    
    if on_key then
        state = "On key"
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
    else
        state = "Default"
    end

    if state ~= "Default" and state ~= "On key" then
        if not em.ui.aa.states[state].master:get() then
            state = "Default"
        end
    end

    

    em.aa.state = state
end

-- Emotional Menu Items
em.ui.master = em.ui.new(nil, ui.new_checkbox("aa", "anti-aimbot angles", "[\ac685ffffEmotional\aCDCDCDFF] Enabled")):set_callback(function(val)
    if ui.get(val) then
        ui.set(refs.aa.master, true)
    end
end)

em.ui.tab = em.ui.master:combo(nil, "aa", "anti-aimbot angles", "\n[\ac685ffffEmotional\aCDCDCDFF] Tab", {"\ac685ffffAntiaim", "\ac685ffffVisuals", "\ac685ffffRage"})

em.ui.aa.state = em.ui.master:combo(nil, "aa", "anti-aimbot angles", "[\ac685ffffAntiaim\aCDCDCDFF] State", em.aa.states):add_condition(function()
    return em.ui.tab:get():find("Antiaim")
end)


for _, state in pairs(em.aa.states) do
    em.ui.aa.states[state] = {}

    if state ~= "Default" then
        em.ui.aa.states[state].master = em.ui.master:checkbox(state..":e", "AA", "Anti-aimbot angles", "Enable \ac685ffff" .. state, false):add_condition(function() return em.ui.tab:get():find("Antiaim") and em.ui.aa.state:get() == state end)
    end

    local x = state == "Default" and em.ui.master or em.ui.aa.states[state].master

    local con = function() return em.ui.aa.state:get() == state and em.ui.master:get() and em.ui.tab:get():find("Antiaim") and (state == "Default" and true or em.ui.aa.states[state].master:get()) end

    em.ui.aa.states[state].pitch                 = x:combo      (state..":p", "AA", "Anti-aimbot angles", "[\ac685ffff" .. state .. "\aCDCDCDFF] Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}):add_condition(function() return con() end)
    em.ui.aa.states[state].yaw_base              = x:combo      (state..":yb", "AA", "Anti-aimbot angles", "[\ac685ffff" .. state .. "\aCDCDCDFF] Yaw base", {"Local view", "At targets"}):add_condition(function() return con() end)
    em.ui.aa.states[state].yaw                   = x:combo      (state..":y", "AA", "Anti-aimbot angles", "[\ac685ffff" .. state .. "\aCDCDCDFF] Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}):add_condition(function() return con() end)
    em.ui.aa.states[state].yaw_offset_left       = x:slider     (state..":yol", "AA", "Anti-aimbot angles", "\n[\ac685ffff" .. state .. "\aCDCDCDFF] Yaw offset left", -180, 180, 0, true, "°L"):add_condition(function() return con() and em.ui.aa.states[state].yaw:get() ~= "Off" end)
    em.ui.aa.states[state].yaw_offset_right      = x:slider     (state..":yor", "AA", "Anti-aimbot angles", "\n[\ac685ffff" .. state .. "\aCDCDCDFF] Yaw offset right", -180, 180, 0, true, "°R"):add_condition(function() return con() and em.ui.aa.states[state].yaw:get() ~= "Off" end)
    em.ui.aa.states[state].yaw_jitter            = x:combo      (state..":yj", "AA", "Anti-aimbot angles", "[\ac685ffff" .. state .. "\aCDCDCDFF] Yaw jitter", {"Off", "Offset", "Center", "Random"}):add_condition(function() return con() end)
    em.ui.aa.states[state].yaw_jitter_offset     = x:slider     (state..":yjo", "AA", "Anti-aimbot angles", "\n" .. state .. "\aCDCDCDFF] Yaw jitter", -180, 180, 0, true, "°"):add_condition(function() return con() and em.ui.aa.states[state].yaw_jitter:get() ~= "Off" end)
    em.ui.aa.states[state].body_yaw              = x:combo      (state..":by", "AA", "Anti-aimbot angles", "[\ac685ffff" .. state .. "\aCDCDCDFF] Body yaw", {"Off", "Opposite", "Jitter", "Static"}):add_condition(function() return con() end)
    em.ui.aa.states[state].body_yaw_offset       = x:slider     (state..":byo", "AA", "Anti-aimbot angles", "\n" .. state .. "\aCDCDCDFF] Body yaw offset", -180, 180, 0, true, "°"):add_condition(function() return con() and em.ui.aa.states[state].body_yaw:get() ~= "Off" and em.ui.aa.states[state].body_yaw:get() ~= "Opposite" end)
    em.ui.aa.states[state].fake_yaw_limit_l      = x:slider     (state..":fll", "AA", "Anti-aimbot angles", "[\ac685ffff" .. state .. "\aCDCDCDFF] Fake yaw limit", 0, 60, 60, true, "°L"):add_condition(function() return con() and em.ui.aa.states[state].body_yaw:get() ~= "Off" end)
    em.ui.aa.states[state].fake_yaw_limit_r      = x:slider     (state..":flr", "AA", "Anti-aimbot angles", "\n[\ac685ffff" .. state .. "\aCDCDCDFF] Fake yaw limit right", 0, 60, 60, true, "°R"):add_condition(function() return con() and em.ui.aa.states[state].body_yaw:get() ~= "Off" end)
    em.ui.aa.states[state].freestanding_body_yaw = x:checkbox   (state..":fby", "AA", "Anti-aimbot angles", "[\ac685ffff" .. state .. "\aCDCDCDFF] Freestanding body yaw", false):add_condition(function() return con() and em.ui.aa.states[state].body_yaw:get() ~= "Off" end)
end

em.ui.aa.roll = em.ui.master:slider("roll", "AA", "Anti-aimbot angles", "[\ac685ffffAntiaim\aCDCDCDFF] Roll", -50, 50, 0, true, "°"):add_condition(function()
    return em.ui.tab:get():find("Antiaim")
end)

em.ui.aa.freestand_key = em.ui.master:hotkey(nil, "aa", "anti-aimbot angles", "[\ac685ffffAntiaim\aCDCDCDFF] Freestanding"):add_condition(function()
    return em.ui.tab:get():find("Antiaim")
end)

em.ui.aa.on_key_key = em.ui.master:hotkey(nil, "aa", "anti-aimbot angles", "[\ac685ffffAntiaim\aCDCDCDFF] On key"):add_condition(function()
    return em.ui.tab:get():find("Antiaim")
end)

em.ui.aa.break_nl = em.ui.master:hotkey(nil, "aa", "anti-aimbot angles", "[\ac685ffffAntiaim\aCDCDCDFF] Break NL"):add_condition(function()
    return em.ui.tab:get():find("Antiaim")
end)

em.ui.aa.import = em.ui.master:button("aa", "anti-aimbot angles", "\ac685ffffImport", function() end):add_condition(function()
    return em.ui.tab:get():find("Antiaim")
end)

em.ui.aa.export = em.ui.master:button("aa", "anti-aimbot angles", "\ac685ffffExport", function() end):add_condition(function()
    return em.ui.tab:get():find("Antiaim")
end)

em.ui.visuals.indicators = em.ui.master:checkbox(nil, "aa", "anti-aimbot angles", "[\ac685ffffVisuals\aCDCDCDFF] Indicators", true):add_condition(function()
    return em.ui.tab:get():find("Visuals")
end)

em.ui.visuals.indicator_type = em.ui.visuals.indicators:combo(nil, "aa", "anti-aimbot angles", "[\ac685ffffIndicators\aCDCDCDFF] Type", {"Emotional", "Ideal Yaw", "Old Chimera"}):add_condition(function()
    return em.ui.tab:get():find("Visuals") and em.ui.visuals.indicators:get()
end)

em.ui.visuals.indicators_color = em.ui.visuals.indicators:color_picker(nil, "aa", "anti-aimbot angles", "[\ac685ffffVisuals\aCDCDCDFF] Indicators", 255, 255, 255, 255):add_condition(function()
    return em.ui.tab:get():find("Visuals") and em.ui.visuals.indicators:get()
end)

em.ui.visuals.indicators_scoped = em.ui.visuals.indicators:checkbox(nil, "aa", "anti-aimbot angles", "[\ac685ffffIndicators\aCDCDCDFF] Move while scoped", true):add_condition(function()
    return em.ui.tab:get():find("Visuals") and em.ui.visuals.indicators:get()
end)

em.ui.visuals.panels = em.ui.master:multiselect(nil, "aa", "anti-aimbot angles", "[\ac685ffffVisuals\aCDCDCDFF] Panels", {"Watermark", "Keybinds", "Spectators"}):add_condition(function()
    return em.ui.tab:get():find("Visuals")
end)

em.ui.visuals.panel_color = em.ui.master:color_picker(nil, "aa", "anti-aimbot angles", "[\ac685ffffVisuals\aCDCDCDFF] Panel color", 255, 255, 255, 255):add_condition(function()
    return em.ui.tab:get():find("Visuals")
end)

em.ui.rage.resolver = em.ui.master:hotkey(nil, "aa", "anti-aimbot angles", "[\ac685ffffRage\aCDCDCDFF] Resolver"):add_condition(function()
    return em.ui.tab:get():find("Rage")
end)

em.ui.rage.roll_resolver = em.ui.master:hotkey(nil, "aa", "anti-aimbot angles", "[\ac685ffffRage\aCDCDCDFF] Roll Resolver"):add_condition(function()
    return em.ui.tab:get():find("Rage")
end)


function em.ui:get_config_elements()
    local config = {}

    for _, element in pairs(em.ui.elements) do
        if element.uid ~= nil then
            table.insert(config, element)
        end
    end

    return config
end

function em.ui:generate_settings()
    local config_elements = em.ui:get_config_elements()
    local settings = {}

    for i, element in pairs(config_elements) do
        settings[element.uid] = element:get()
    end

    return json.stringify(settings)
end

function em.ui:load_settings(settings)
    local config_elements = em.ui:get_config_elements()

    local parsed = json.parse(settings)

    for i, element in pairs(config_elements) do
        for uid, value in pairs(parsed) do
            if uid == element.uid then
                ui.set(element.item, value)
            end
        end
    end
end

function em.ui:import()
    local protected = function()
        local settings = clipboard.get()
        em.ui:load_settings(settings)
    end

    if not pcall(protected) then
        print("Failed to import settings")
        return
    end

    print("Imported settings")
end

function em.ui:export()
    local protected = function()
        local settings = em.ui:generate_settings()
        clipboard.set(settings)
    end

    if not pcall(protected) then
        print("Failed to export settings")
        return
    end

    print("Exported settings")
end

-- Use Fix On key
function em.aa:handle_use(cmd)
    if not em.ui.aa.on_key_key:get() then return end

    local in_use = cmd.in_use == 1

    em.aa.use = false
    
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
        if em.ui.aa.states["On key"].master:get() then
            cmd.in_use = 0
        end
        em.aa.use = true
    end
end


-- Setting antiaim
function em.aa:set(cmd)
    if not em.ui.master:get() then return end

    local state = em.aa.state
    local break_nl = em.ui.aa.break_nl:get()

    ui.set(refs.aa.pitch, em.ui.aa.states[state].pitch:get())
    ui.set(refs.aa.yaw_base, em.ui.aa.states[state].yaw_base:get())
    ui.set(refs.aa.yaw, em.ui.aa.states[state].yaw:get())
    ui.set(refs.aa.yaw_jitter, break_nl and "Off" or em.ui.aa.states[state].yaw_jitter:get())
    ui.set(refs.aa.yaw_jitter_offset, em.ui.aa.states[state].yaw_jitter_offset:get())
    ui.set(refs.aa.body_yaw, break_nl and "Static" or em.ui.aa.states[state].body_yaw:get())
    ui.set(refs.aa.body_yaw_offset, em.ui.aa.states[state].body_yaw_offset:get())
    ui.set(refs.aa.freestanding_body_yaw, em.ui.aa.states[state].freestanding_body_yaw:get())

    ui.set(refs.aa.roll, em.ui.aa.roll:get())

    inverted = (math.floor(math.min(60, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60)))) > 0
    if cmd.chokedcommands == 0 then
        ui.set(refs.aa.yaw_offset, break_nl and 0 or (inverted and em.ui.aa.states[state].yaw_offset_left:get() or em.ui.aa.states[state].yaw_offset_right:get()))
        ui.set(refs.aa.fake_yaw_limit, inverted and em.ui.aa.states[state].fake_yaw_limit_l:get() or em.ui.aa.states[state].fake_yaw_limit_r:get())
    end

    local freestanding = em.ui.aa.freestand_key:get()

    ui.set(refs.aa.freestanding_key, freestanding and "Always on" or "On hotkey")
    ui.set(refs.aa.freestanding, freestanding and "Default" or "-")
end

function em.util:fade_col(col1, col2, speed)
    local r = math.floor(col1.r + (col2.r - col1.r) * speed)
    local g = math.floor(col1.g + (col2.g - col1.g) * speed)
    local b = math.floor(col1.b + (col2.b - col1.b) * speed)
    local a = math.floor(col1.a + (col2.a - col1.a) * speed)

    return { r = r, g = g, b = b, a = a }
end


-- Render Indicators
function em.visuals.indicators:render()
    if not em.ui.master:get() or not em.ui.visuals.indicators:get() then return end

    if em.ui.rage.roll_resolver:get() then
        renderer.indicator(255, 50, 255, 255, "ROLL RESOLVER")
    end

    local me = entity.get_local_player()

    if not me or not entity.is_alive(me) then return end

    local scoped = entity.get_prop(me, "m_bIsScoped") == 1 and em.ui.visuals.indicators_scoped:get()
    local screen = vector(client.screen_size())
    local r, g, b, a = em.ui.visuals.indicators_color:get()
    local alpha = em.util:pulsate(4)
    local charge = anti_aim.get_double_tap() and not ui.get(refs.misc.hide_shots_key)
    local exploiting = (ui.get(refs.rage.double_tap) and ui.get(refs.rage.double_tap_key)) or (ui.get(refs.misc.hide_shots) and ui.get(refs.misc.hide_shots_key))
    local inverted = (math.floor(math.min(60, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60)))) > 0
    local delta = math.floor(anti_aim.get_desync(1))

    self.chimera.charge = ease.linear(globals.frametime() * 12, self.chimera.charge, (charge and 1 or 0) - self.chimera.charge, 1)
    self.chimera.left = em.util:fade_col(self.chimera.left, inverted and {r = r, g = g, b = b, a = a} or {r = 255, g = 255, b = 255, a = 255}, globals.frametime() * 12)
    self.chimera.right = em.util:fade_col(self.chimera.right, inverted and {r = 255, g = 255, b = 255, a = 255} or {r = r, g = g, b = b, a = a}, globals.frametime() * 12)
    self.charge = em.util:fade_col(self.charge, charge and {r = 50, g = 255, b = 50, a = 255} or {r = 255, g = 50, b = 50, a = em.util:pulsate(8)}, globals.frametime() * 12)

    local col = {
        on = { r = 50, g = 255, b = 50, a = 255 },
        off = { r = 255, g = 255, b = 255, a = 100 },
        main = { r = r, g = g, b = b, a = alpha },
    }

    local hex = {
        on = "\a" .. em.util:to_hex(r, g, b, a),
        off = "\a" .. em.util:to_hex(col.off.r, col.off.g, col.off.b, col.off.a),
        main = "\a" .. em.util:to_hex(col.main.r, col.main.g, col.main.b, col.main.a),
        charge = "\a" .. em.util:to_hex(self.charge.r, self.charge.g, self.charge.b, self.charge.a),
        left = "\a" .. em.util:to_hex(self.chimera.left.r, self.chimera.left.g, self.chimera.left.b, self.chimera.left.a),
        right = "\a" .. em.util:to_hex(self.chimera.right.r, self.chimera.right.g, self.chimera.right.b, self.chimera.right.a),
    }

    if em.ui.visuals.indicator_type:get() == "Emotional" then
        local baim, sp, fs = ui.get(refs.rage.baim) and hex.on .. "BAIM  " or hex.off .. "BAIM  ", ui.get(refs.rage.sp) and hex.on .."SAFE" or hex.off .."SAFE", em.ui.aa.freestand_key:get() and hex.on .."  FS" or hex.off .."  FS"
        local title, binds, exploit = "EMOTIONAL " .. hex.main .. "YAW", baim .. sp .. fs, ((ui.get(refs.rage.double_tap_key) and ui.get(refs.misc.hide_shots_key)) and hex.charge .."DT" or (ui.get(refs.rage.double_tap_key) and hex.charge .."DT") or (ui.get(refs.misc.hide_shots_key) and "OS") or hex.charge .."DT")
        local title_size = vector(renderer.measure_text("-c", title))
        local state_size = vector(renderer.measure_text("-c", em.aa.state:upper()))
        local exploit_size = vector(renderer.measure_text("-c", exploit))
        local binds_size = vector(renderer.measure_text("-c", binds))

        self.em.title_pos = ease.linear(globals.frametime()*12, self.em.title_pos, vector(screen.x/2 + (scoped and title_size.x/2 + 5 or 0), screen.y/2 + 20) - self.em.title_pos, 1)
        self.em.state_pos = ease.linear(globals.frametime()*12, self.em.state_pos, vector(screen.x/2 + (scoped and state_size.x/2 + 5 or 0), screen.y/2 + 30) - self.em.state_pos, 1)
        self.em.exploit_pos = ease.linear(globals.frametime()*12, self.em.exploit_pos, vector(screen.x/2 + (scoped and exploit_size.x/2 + 5 or 0), screen.y/2 + 40) - self.em.exploit_pos, 1)
        self.em.binds_pos = ease.linear(globals.frametime()*12, self.em.binds_pos, vector(screen.x/2 + (scoped and binds_size.x/2 + 5 or 0), screen.y/2 + (exploiting and 50 or 40)) - self.em.binds_pos, 1)

        renderer.text(self.em.title_pos.x, self.em.title_pos.y, 255, 255, 255, 255, "-c", 0, title)
        renderer.text(self.em.state_pos.x, self.em.state_pos.y, 255, 255, 255, 255, "-c", 0, em.aa.state:upper())
        if exploiting then
            renderer.text(self.em.exploit_pos.x, self.em.exploit_pos.y, 50, 255, 50, 255, "-c", 0, exploit)
        end
        renderer.text(self.em.binds_pos.x, self.em.binds_pos.y, 255, 255, 255, 255, "-c", 0, binds)
    end
    
    if em.ui.visuals.indicator_type:get() == "Ideal Yaw" then
        local title, mode, exploit = "EMOTIONAL YAW", em.ui.aa.freestand_key:get() and "FREESTAND" or "DYNAMIC", "DT"
        local title_size = vector(renderer.measure_text("", title))
        local mode_size = vector(renderer.measure_text("", mode))
        local exploit_size = vector(renderer.measure_text("", exploit))

        self.ideal_yaw.title_pos = ease.linear(globals.frametime()*12, self.ideal_yaw.title_pos, vector(screen.x/2 + 5, screen.y/2 + 20) - self.ideal_yaw.title_pos, 1)
        self.ideal_yaw.mode_pos = ease.linear(globals.frametime()*12, self.ideal_yaw.mode_pos, vector(screen.x/2 + 5, screen.y/2 + 30) - self.ideal_yaw.mode_pos, 1)
        self.ideal_yaw.exploit_pos = ease.linear(globals.frametime()*12, self.ideal_yaw.exploit_pos, vector(screen.x/2 + 5, screen.y/2 + 40) - self.ideal_yaw.exploit_pos, 1)

        renderer.text(self.ideal_yaw.title_pos.x, self.ideal_yaw.title_pos.y, 218, 118, 0, 255, "", 0, title)
        renderer.text(self.ideal_yaw.mode_pos.x, self.ideal_yaw.mode_pos.y, 209, 139, 230, 255, "", 0, mode)
        renderer.text(self.ideal_yaw.exploit_pos.x, self.ideal_yaw.exploit_pos.y, charge and 50 or 255, charge and 255 or 50, 50, 255, "", 0, exploit)
    end

    if em.ui.visuals.indicator_type:get() == "Old Chimera" then
        local title, desync, exploit = hex.left .. "EMOTIONAL " .. hex.right .. "YAW", tostring(delta) .. "°", ((ui.get(refs.rage.double_tap_key) and ui.get(refs.misc.hide_shots_key)) and hex.charge .."DT" or (ui.get(refs.rage.double_tap_key) and hex.charge .."DT") or (ui.get(refs.misc.hide_shots_key) and "OS") or hex.charge .."DT")
        local title_size = vector(renderer.measure_text("c", title))
        local desync_size = vector(renderer.measure_text("c", desync))
        local exploit_size = vector(renderer.measure_text("c", exploit))
        
        self.chimera.desync_pos = ease.linear(globals.frametime()*12, self.chimera.desync_pos, vector(screen.x/2, screen.y/2 + 20) - self.chimera.desync_pos, 1)
        self.chimera.title_pos = ease.linear(globals.frametime()*12, self.chimera.title_pos, vector(screen.x/2, screen.y/2 + 40) - self.chimera.title_pos, 1)
        self.chimera.exploit_pos = ease.linear(globals.frametime()*12, self.chimera.exploit_pos, vector(screen.x/2, screen.y/2 + 50) - self.chimera.exploit_pos, 1)

        renderer.text(self.chimera.desync_pos.x, self.chimera.desync_pos.y, 255, 255, 255, 255, "c", 0, desync)
        renderer.gradient(self.chimera.desync_pos.x, self.chimera.desync_pos.y + 10, delta, 1, r, g, b, 255, r, g, b, 0, true)
        renderer.gradient(self.chimera.desync_pos.x - delta, self.chimera.desync_pos.y + 10, delta, 1, r, g, b, 0, r, g, b, 255, true)
        renderer.text(self.chimera.title_pos.x, self.chimera.title_pos.y, 255, 255, 255, 255, "c", 0, title)
        
        if ui.get(refs.rage.double_tap_key) and ui.get(refs.rage.double_tap) then
            renderer.text(self.chimera.exploit_pos.x, self.chimera.exploit_pos.y, 50, 255, 50, 255, "c", 0, exploit)
            renderer.circle_outline(self.chimera.exploit_pos.x - exploit_size.x, self.chimera.exploit_pos.y, self.charge.r, self.charge.g, self.charge.b, 255, 4, 0, self.chimera.charge, 1.5)
        end

    end
end

-- Keybinds

em.visuals.panels.keybinds.refs["Freestanding"] = em.ui.aa.freestand_key.item
for bind, ref in pairs(em.visuals.panels.keybinds.refs) do
    em.visuals.panels.keybinds.list[bind] = {
        ["pos"] = vector(em.visuals.panels.keybinds.pos),
        ["opacity"] = 0,
        ["ref"] = type(ref) == "table" and ref[2] or ref
    }
end

function em.visuals.panels.keybinds:get_width()
    local size = vector(0, 0)
    for name, bind in pairs(self.list) do
        local mode = self:get_mode(bind.ref)
        local text_size = vector(renderer.measure_text("", name))
        local mode_size = vector(renderer.measure_text("", mode))
        if not ui.get(bind.ref) and not ui.is_menu_open() then goto skip end
        size.x = math.max(size.x, text_size.x + mode_size.x + 10)
        size.y = size.y + text_size.y
        ::skip::
    end

    return size.x == 0 and vector(renderer.measure_text("c", "Keybinds"), size.y) or size
end

function em.visuals.panels.keybinds:get_mode(ref)
    local key = { ui.get(ref) }
    local mode = key[2]
    
    if mode == nil then
        return "nil"
    end
    
    return self.modes[mode + 1]
end

function em.visuals.panels.keybinds:active()
    for name, bind in pairs(self.list) do
        if ui.get(bind.ref) or ui.is_menu_open() then
            return true
        end
    end

    return false
end

function em.visuals.panels.keybinds:render()
    if not contains(em.ui.visuals.panels:get(), "Keybinds") then
        return
    end

    local screen = vector(client.screen_size())
    local col = color(em.ui.visuals.panel_color:get())
    local mouse = vector(ui.mouse_position())
    local mouse_down = client.key_state(0x01)
    local menu_open = ui.is_menu_open()
    local max_width = self:get_width()
    local padding = 10
    
    self.hovering = mouse.x >= self.pos.x and mouse.x <= self.pos.x + self.size.x and mouse.y >= self.pos.y and mouse.y <= self.pos.y + self.size.y

    self.size = ease.linear(globals.frametime()*30, self.size, vector(max_width.x + padding, 20) - self.size, 1)

    --drag
    if self.hovering then
        self.dragging = mouse_down
    end

    if self.dragging then
        if not self.in_drag then
            self.drag_pos = vector(self.pos.x - mouse.x, self.pos.y - mouse.y)
            self.in_drag = true
        end
        self.pos = vector(math.max(0, math.min(screen.x - self.size.x, mouse.x + self.drag_pos.x)), math.max(0, math.min(screen.y - self.size.y, mouse.y + self.drag_pos.y)))
    else
        self.in_drag = false
    end

    self.opacity = ease.linear(globals.frametime()*30, self.opacity, ((self:active() or menu_open) and 255 or 0) - self.opacity, 1)
    
    renderer.gradient(self.pos.x, self.pos.y, self.size.x, 4, col.r, col.g, col.b, self.opacity, col.r, col.g, col.b, 0, false)
    renderer.rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, 15, 12, 15, math.min(150, self.opacity))
    renderer.rectangle(self.pos.x, self.pos.y, self.size.x, 1, col.r, col.g, col.b, self.opacity)
    renderer.text(self.pos.x + self.size.x/2, self.pos.y + self.size.y/2, 255, 255, 255, self.opacity, "c", 0, "Keybinds")

    local count = 0
    for name, bind in pairs(self.list) do
        local ref = bind.ref
        local state = menu_open and true or ui.get(ref)
        local mode = self:get_mode(ref)

        if not menu_open then
            bind.pos = ease.linear(globals.frametime()*22, bind.pos, vector(self.pos.x, self.pos.y + 25 + (count*15)) - bind.pos, 1)
        else
            bind.pos = vector(self.pos.x, self.pos.y + 25 + (count*15))
        end

        bind.opacity = ease.linear(globals.frametime()*30, bind.opacity, (state and 255 or 0) - bind.opacity, 1)
        
        if bind.opacity <= 5 then
            goto skip
        end

        renderer.text(bind.pos.x, bind.pos.y, 255, 255, 255, bind.opacity, "", 0, name)
        renderer.text(bind.pos.x + self.size.x - renderer.measure_text("", mode), bind.pos.y, 255, 255, 255, bind.opacity, "", 0, mode)
        count = count + 1

        ::skip::
    end

end

-- Spectators
function em.visuals.panels.spectators:active()
    for i, opts in pairs(self.list) do
        if opts.spec or ui.is_menu_open() then
            if entity.get_prop(i, "m_hObserverTarget") == entity.get_local_player() then
                return true
            end
        end
    end

    return false
end

function em.visuals.panels.spectators:get_width()
    local size = vector(0, 0)
    for i, opts in pairs(self.list) do
        if not opts.spec then goto skip end
        if entity.get_prop(i, "m_hObserverTarget") ~= entity.get_local_player() then goto skip end
        local text_size = vector(renderer.measure_text("", entity.get_player_name(i)))
        size.x = math.max(size.x, text_size.x + 15 + 20)
        size.y = size.y + text_size.y
        ::skip::
    end

    return size.x == 0 and vector(renderer.measure_text("c", "Spectators") + 80, size.y) or vector(math.max(renderer.measure_text("c", "Spectators")+80, size.x), size.y)
end

function em.visuals.panels.spectators:render()
    if not contains(em.ui.visuals.panels:get(), "Spectators") then
        return
    end

    local screen = vector(client.screen_size())
    local col = color(em.ui.visuals.panel_color:get())
    local mouse = vector(ui.mouse_position())
    local mouse_down = client.key_state(0x01)
    local menu_open = ui.is_menu_open()
    local max_width = self:get_width()
    local padding = 10

    self.hovering = mouse.x >= self.pos.x and mouse.x <= self.pos.x + self.size.x and mouse.y >= self.pos.y and mouse.y <= self.pos.y + self.size.y

    self.size = ease.linear(globals.frametime()*30, self.size, vector(max_width.x, 20) - self.size, 1)

    --drag
    if self.hovering then
        self.dragging = mouse_down
    end

    if self.dragging then
        if not self.in_drag then
            self.drag_pos = vector(self.pos.x - mouse.x, self.pos.y - mouse.y)
            self.in_drag = true
        end
        self.pos = vector(math.max(0, math.min(screen.x - self.size.x, mouse.x + self.drag_pos.x)), math.max(0, math.min(screen.y - self.size.y, mouse.y + self.drag_pos.y)))
    else
        self.in_drag = false
    end

    self.opacity = ease.linear(globals.frametime()*30, self.opacity, ((self:active() or menu_open) and 255 or 0) - self.opacity, 1)

    renderer.gradient(self.pos.x, self.pos.y, self.size.x, 4, col.r, col.g, col.b, self.opacity, col.r, col.g, col.b, 0, false)
    renderer.rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, 15, 12, 15, math.min(150, self.opacity))
    renderer.rectangle(self.pos.x, self.pos.y, self.size.x, 1, col.r, col.g, col.b, self.opacity)
    renderer.text(self.pos.x + self.size.x/2, self.pos.y + self.size.y/2, 255, 255, 255, self.opacity, "c", 0, "Spectators")

    local players = globals.maxplayers()

    for i = 1, players do
        if self.list[i] == nil then
            self.list[i] = {
                spec = entity.get_prop(i, "m_hObserverTarget") ~= nil and not entity.is_alive(i),
                pos = em.visuals.panels.spectators.pos,
                opacity = 0
            }
        else
            self.list[i].spec = entity.get_prop(i, "m_hObserverTarget") ~= nil and not entity.is_alive(i)
        end
    end

    local count = 0
    for player, opts in pairs(self.list) do
        local target = entity.get_prop(player, "m_hObserverTarget")

        local name = entity.get_player_name(player)

        local steam = entity.get_steam64(player)
        local avatar = images.get_steam_avatar(steam)

        opts.pos = menu_open and vector(self.pos.x, self.pos.y + 25 + (count*20)) or ease.linear(globals.frametime()*22, opts.pos, vector(self.pos.x, self.pos.y + 25 + (count*20)) - opts.pos, 1)

        opts.opacity = ease.linear(globals.frametime()*30, opts.opacity, ((opts.spec and target == entity.get_local_player() and self:active()) and 255 or 0) - opts.opacity, 1)

        if opts.opacity <= 5 then
            goto skip
        end

        if avatar ~= nil then
            avatar:draw(opts.pos.x + self.size.x - 15, opts.pos.y, 15, 15, 255, 255, 255, opts.opacity)
        end
        renderer.text(opts.pos.x, opts.pos.y, 255, 255, 255, opts.opacity, "", 0, name)
        count = count + 1
        ::skip::
    end
end

-- Watermark
function em.visuals.panels.watermark:render()
    if not contains(em.ui.visuals.panels:get(), "Watermark") then
        return
    end

    local col = color(em.ui.visuals.panel_color:get())
	local screen = vector(client.screen_size())
	local latency = math.floor(client.latency()*1000+0.5)
	local tickrate = 1/globals.tickinterval()
	local hours, minutes, seconds = client.system_time()
    local hex = em.util:to_hex(col.r, col.g, col.b, 255)
    self.username = self.username == "unknown" and entity.get_player_name(entity.get_local_player()) or self.username

	local text = string.format("\a" .. hex .. "emotional\aebebebff | %s | %dms | %dtick | %02d:%02d:%02d", self.username, latency, tickrate, hours, minutes, seconds)

	local margin, padding = 20, 5

	local text_size = vector(renderer.measure_text(nil, text))

    renderer.gradient(screen.x-text_size.x-margin-padding, margin-padding, text_size.x+padding*2, 4, col.r, col.g, col.b, 255, col.r, col.g, col.b, 0, false)
    renderer.blur(screen.x-text_size.x-margin-padding, margin-padding, text_size.x+padding*2, text_size.y+padding*2)
    renderer.rectangle(screen.x-text_size.x-margin-padding, margin-padding, text_size.x+padding*2, text_size.y+padding*2, 15, 12, 15, 150)
    renderer.rectangle(screen.x-text_size.x-margin-padding, margin-padding, text_size.x+padding*2, 1, col.r, col.g, col.b, 255)
	renderer.text(screen.x-text_size.x-margin, margin, 235, 235, 235, 255, nil, 0, text)
end

function em.visuals.panels:drag_fix(cmd)
    if self.keybinds.dragging or self.spectators.dragging or self.keybinds.hovering or self.spectators.hovering then
        cmd.in_attack = 0
    end
end




function em.rage.roll_resolver:handle()
    local players = globals.maxplayers()

    for ent = 1, players do
        if not entity.is_alive(ent) or ent == entity.get_local_player() then
            goto skip
        end

        

        if self.list[ent] == nil then
            self.list[ent] = {
                side = 50
            }
        end

        local pitch = 89 * ((2*entity.get_prop(ent, "m_flPoseParameter",12))-1)
        local yaw = select(2, entity.get_prop(ent, "m_angRotation"))
        local roll = em.ui.rage.roll_resolver:get() and self.list[ent].side or 0

        entity.set_prop(ent, "m_angEyeAngles", pitch, yaw, roll)
        ::skip::
    end
end

function em.rage.roll_resolver:on_missed_shot(ent)
    if not em.ui.rage.roll_resolver:get() then
        return
    end

    if not entity.is_alive(ent) or ent == entity.get_local_player() then
        return
    end

    self.list[ent].side = self.list[ent].side == 50 and -50 or 50
end


-- Callbacks



em.visuals.panels:init_from_database()

em.ui.aa.import:set_callback(function()
    em.ui:import()
end)

em.ui.aa.export:set_callback(function()
    em.ui:export()
end)

client.set_event_callback("aim_miss", function(e)
    if not em.ui.rage.roll_resolver:get() then
        return
    end

    if e.reason == "?" then
        em.rage.roll_resolver:on_missed_shot(e.target)
    end
end)

client.set_event_callback("paint_ui", function()
    em.util:hide_aa(em.ui.master:get())
end)

client.set_event_callback("paint", function()
    em.visuals.indicators:render()
    em.visuals.panels.keybinds:render()
    em.visuals.panels.spectators:render()
    em.visuals.panels.watermark:render()
    em.rage.roll_resolver:handle()
end)

client.set_event_callback("setup_command", function(cmd)
    em.aa:handle_use(cmd)
    em.util:handle_state(cmd)
    em.aa:set(cmd)
    em.visuals.panels:drag_fix(cmd)
end)

client.set_event_callback("shutdown", function()
    em.util:hide_aa(false)

    em:save_database()
end)