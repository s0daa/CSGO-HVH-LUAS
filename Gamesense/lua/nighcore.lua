--[[
regionlist: -DEPENDENCIES
            -USER_DATA
            -REFERENCES
            -VARIABLES
            -FUNCS
            -UI_LAYOUT
            -AA_CALLBACKS
            -UI_RENDER
]]

-- @region DEPENDENCIES start
local function try_require(module, msg)
    local success, result = pcall(require, module)
    if success then return result else return error(msg) end
end

local images = try_require("gamesense/images", "Download images library: https://gamesense.pub/forums/viewtopic.php?id=22917")
local bit = try_require("bit")
local base64 = try_require("gamesense/base64", "Download base64 encode/decode library: https://gamesense.pub/forums/viewtopic.php?id=21619")
local antiaim_funcs = try_require("gamesense/antiaim_funcs", "Download anti-aim functions library: https://gamesense.pub/forums/viewtopic.php?id=29665")
local ffi = try_require("ffi", "Failed to require FFI, please make sure Allow unsafe scripts is enabled!")
local vector = try_require("vector", "Missing vector")
local http = try_require("gamesense/http", "Download HTTP library: https://gamesense.pub/forums/viewtopic.php?id=21619")
local clipboard = try_require("gamesense/clipboard", "Download Clipboard library: https://gamesense.pub/forums/viewtopic.php?id=28678")
local ent = try_require("gamesense/entity", "Download Entity Object library: https://gamesense.pub/forums/viewtopic.php?id=27529")
local csgo_weapons = try_require("gamesense/csgo_weapons", "Download CS:GO weapon data library: https://gamesense.pub/forums/viewtopic.php?id=18807")
-- @region DEPENDENCIES end

-- @region USERDATA start
local userdata = {
    username = username == nil and 'admin' or username,
    build = build ~= nil and build:gsub("private", "private"):gsub("beta", "beta")("debug", "debug"):gsub("beta", "beta"):gsub("stable", "user") or "source"
}
local lua_color = {r = 195, g =178, b = 195}
local lua_name = "nightcore"
local lua = {}
lua.database = {
    configs = ":" .. lua_name .. "::configs:"
}
local presets = {}
-- @region USERDATA end

-- @region REFERENCES start
local refs = {
    legit = ui.reference("LEGIT", "Aimbot", "Enabled"),
    dmgOverride = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
    fakeDuck = ui.reference("RAGE", "Other", "Duck peek assist"),
    minDmg = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    hitChance = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
    safePoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
    forceBaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    dtLimit = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit"),
    quickPeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
    dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = {ui.reference("AA", "Anti-aimbot angles", "pitch")},
    roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
    yawBase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    flLimit = ui.reference("AA", "Fake lag", "Limit"),
    fsBodyYaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeYaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    yawJitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    bodyYaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    freeStand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    os = {ui.reference("AA", "Other", "On shot anti-aim")},
    slow = {ui.reference("AA", "Other", "Slow motion")},
    fakeLag = {ui.reference("AA", "Fake lag", "Limit")},
    legMovement = ui.reference("AA", "Other", "Leg movement"),
    indicators = {ui.reference("VISUALS", "Other ESP", "Feature indicators")},
    ping = {ui.reference("MISC", "Miscellaneous", "Ping spike")},
}
-- @region REFERENCES end

-- @region VARIABLES start
local vars = {
    localPlayer = 0,
    hitgroup_names = { 'Generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', '?', 'Gear' },
    aaStates = {"Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Crouch-Moving"},
    pStates = {"S", "M", "SW", "C", "A", "AC", "CM"},
	sToInt = {["Standing"] = 1, ["Moving"] = 2, ["Slowwalking"] = 3, ["Crouching"] = 4, ["Air"] = 5, ["Air-Crouching"] = 6, ["Crouch-Moving"] = 7},
    intToS = {[1] = "Standing", [2] = "Moving", [3] = "Slowwalking", [4] = "Crouching", [5] = "Air", [6] = "Air-Crouching", [7] = "Crouch-Moving"},
    activeState = 1,
    pState = 1
}
-- @region VARIABLES end

-- #region FUNCS start
local func = {
    table_contains = function(tbl, value)
        for i = 1, #tbl do
            if tbl[i] == value then
                return true
            end
        end
        return false
    end,
    setAATab = function(ref)
        ui.set_visible(refs.enabled, ref)
        ui.set_visible(refs.pitch[1], ref)
        ui.set_visible(refs.pitch[2], ref)
        ui.set_visible(refs.roll, ref)
        ui.set_visible(refs.yawBase, ref)
        ui.set_visible(refs.yaw[1], ref)
        ui.set_visible(refs.yaw[2], ref)
        ui.set_visible(refs.yawJitter[1], ref)
        ui.set_visible(refs.yawJitter[2], ref)
        ui.set_visible(refs.bodyYaw[1], ref)
        ui.set_visible(refs.bodyYaw[2], ref)
        ui.set_visible(refs.freeStand[1], ref)
        ui.set_visible(refs.freeStand[2], ref)
        ui.set_visible(refs.fsBodyYaw, ref)
        ui.set_visible(refs.edgeYaw, ref)
    end,
    findDist = function (x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end,
    easeInOut = function(t)
        return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
    end,
    rec = function(x, y, w, h, radius, color)
        radius = math.min(x/2, y/2, radius)
        local r, g, b, a = unpack(color)
        renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
        renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
        renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
    end,
    rec_outline = function(x, y, w, h, radius, thickness, color)
        radius = math.min(w/2, h/2, radius)
        local r, g, b, a = unpack(color)
        if radius == 1 then
            renderer.rectangle(x, y, w, thickness, r, g, b, a)
            renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
        else
            renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
            renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
            renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
            renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
            renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
            renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
            renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
            renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
        end
    end,
    clamp = function(x, min, max)
        return x < min and min or x > max and max or x
    end,
    resetAATab = function()
        ui.set(refs.enabled, false)
        ui.set(refs.pitch[1], "Off")
        ui.set(refs.pitch[2], 0)
        ui.set(refs.roll, 0)
        ui.set(refs.yawBase, "local view")
        ui.set(refs.yaw[1], "Off")
        ui.set(refs.yaw[2], 0)
        ui.set(refs.yawJitter[1], "Off")
        ui.set(refs.yawJitter[2], 0)
        ui.set(refs.bodyYaw[1], "Off")
        ui.set(refs.bodyYaw[2], 0)
        ui.set(refs.freeStand[1], false)
        ui.set(refs.freeStand[2], "On hotkey")
        ui.set(refs.fsBodyYaw, false)
        ui.set(refs.edgeYaw, false)
    end,
    type_from_string = function(input)
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
    end,
    lerp = function(start, vend, time)
        return start + (vend - start) * time
    end,
    hex = function(arg)
        local result = "\a"
        for key, value in next, arg do
            local output = ""
            while value > 0 do
                local index = math.fmod(value, 16) + 1
                value = math.floor(value / 16)
                output = string.sub("0123456789ABCDEF", index, index) .. output 
            end
            if #output == 0 then 
                output = "00" 
            elseif #output == 1 then 
                output = "0" .. output 
            end 
            result = result .. output
        end 
        return result .. "FF"
    end,
    split = function( inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
    end,
    time_to_ticks = function(t)
        return math.floor(0.5 + (t / globals.tickinterval()))
    end,
    RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
        return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
    end,
    create_color_array = function(r, g, b, string)
        local colors = {}
        for i = 0, #string do
            local color = {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + i * 5 / 30))}
            table.insert(colors, color)
        end
        return colors
    end
}

local color_text = function( string, r, g, b, a)
    local accent = "\a" .. func.RGBAtoHEX(r, g, b, a)
    local white = "\a" .. func.RGBAtoHEX(255, 255, 255, a)

    local str = ""
    for i, s in ipairs(func.split(string, "$")) do
        str = str .. (i % 2 ==( string:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
    end

    return str
end

local animate_text = function(time, string, r, g, b, a)
    local t_out, t_out_iter = { }, 1

    local l = string:len( ) - 1

    local r_add = (255 - r)
    local g_add = (255 - g)
    local b_add = (255 - b)
    local a_add = (155 - a)

    for i = 1, #string do
        local iter = (i - 1)/(#string - 1) + time
        t_out[t_out_iter] = "\a" .. func.RGBAtoHEX( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )

        t_out[t_out_iter + 1] = string:sub( i, i )

        t_out_iter = t_out_iter + 2
    end

    return t_out
end

local glow_module = function(x, y, w, h, width, rounding, accent, accent_inner)
    local thickness = 1
    local Offset = 1
    local r, g, b, a = unpack(accent)
    if accent_inner then
        func.rec(x, y, w, h + 1, rounding, accent_inner)
    end
    for k = 0, width do
        if a * (k/width)^(1) > 5 then
            local accent = {r, g, b, a * (k/width)^(2)}
            func.rec_outline(x + (k - width - Offset)*thickness, y + (k - width - Offset) * thickness, w - (k - width - Offset)*thickness*2, h + 1 - (k - width - Offset)*thickness*2, rounding + thickness * (width - k + Offset), thickness, accent)
        end
    end
end
-- @region FUNCS end

-- @region UI_LAYOUT start
local tab, container = "AA", "Anti-aimbot angles"
local label = ui.new_label(tab, container, "nightcore")
local empty = ui.new_label(tab, container, " ")
local tabPicker = ui.new_combobox(tab, container, "Tab", "Anti-aim", "Builder", "Visuals", "Misc", "Config")
local aaBuilder = {}
local stateContainer = {}
local statePicker = ui.new_combobox(tab, container, "Anti-aim state", vars.aaStates)
for i=1, #vars.aaStates do
    stateContainer[i] = func.hex({200,200,200}) .. "(" .. func.hex({222,55,55}) .. "" .. vars.pStates[i] .. "" .. func.hex({200,200,200}) .. ")" .. func.hex({155,155,155}) .. " "
    aaBuilder[i] = {
        enableState = ui.new_checkbox(tab, container, "Enable " .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i]:lower() .. func.hex({200,200,200}) .. " state"),
        pitch = ui.new_combobox(tab, container, "Pitch\n" .. stateContainer[i], "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitchSlider = ui.new_slider(tab, container, "\nPitch add" .. stateContainer[i], -89, 89, 0, true, "°", 1),
        yawBase = ui.new_combobox(tab, container, "Yaw base\n" .. stateContainer[i], "Local view", "At targets"),
        yaw = ui.new_combobox(tab, container, "Yaw\n" .. stateContainer[i], "Off", "180", "Spin", "Static", "180 Z", "Crosshair"),
        yawLeft = ui.new_slider(tab, container, "Left\nyaw" .. stateContainer[i], -180, 180, 0, true, "°", 1),
        yawRight = ui.new_slider(tab, container, "Right\nyaw" .. stateContainer[i], -180, 180, 0, true, "°", 1),
        yawJitter = ui.new_combobox(tab, container, "Yaw jitter\n" .. stateContainer[i], "Off", "Offset", "Center", "3-Way", "Random"),
        yawJitterLeft = ui.new_slider(tab, container, "Left\nyaw jitter" .. stateContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterRight = ui.new_slider(tab, container, "Right\nyaw jitter" .. stateContainer[i], -180, 180, 0, true, "°", 1),
        bodyYaw = ui.new_combobox(tab, container, "Body yaw\n" .. stateContainer[i], "Off", "Opposite", "Jitter", "Static"),
        bodyYawLeft = ui.new_slider(tab, container, "Left\nbody yaw" .. stateContainer[i], -180, 180, 0, true, "°", 1),
        bodyYawRight = ui.new_slider(tab, container, "Right\nbody yaw" .. stateContainer[i], -180, 180, 0, true, "°", 1),
        roll = ui.new_slider(tab, container, "Roll\n" .. stateContainer[i], -45, 45, 0, true, "°"),
    }
end

local aaContainer = "(" .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. "AA" .. func.hex({200,200,200}) .. ") "
local mContainer = "(" .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. "M" .. func.hex({200,200,200}) .. ") "
local menu = {
    aaTab = {
        legitAAHotkey = ui.new_hotkey(tab, container, aaContainer .. "Legit aa"),
        freestandHotkey = ui.new_hotkey(tab, container, aaContainer .. "Freestand"),
        exploits = ui.new_multiselect(tab, container, "Exploits", "Pitch flick in air", "Air tick switcher", "Force defensive in air"),
        manualLeft = ui.new_hotkey(tab, container, mContainer .. "Left"),
        manualRight = ui.new_hotkey(tab, container, mContainer .. "Right"),
        manualForward = ui.new_hotkey(tab, container, mContainer .. "Forward"),
    },
    visualsTab = {
        indicators = ui.new_checkbox(tab, container, "Indicators"),
        indicatorsClr = ui.new_color_picker(tab, container, "Main Color", lua_color.r, lua_color.g, lua_color.b, 255),
        indicatorsType = ui.new_combobox(tab, container, "\n indicators type", "-", "Style 1", "Style 2"),
        indicatorsStyle = ui.new_multiselect(tab, container, "Elements", "Name", "State", "Doubletap", "Hideshots", "Freestand", "Safepoint", "Body aim", "Fakeduck"),
        arrows = ui.new_checkbox(tab, container, "Arrows"),
        arrowClr = ui.new_color_picker(tab, container, "Arrow Color", lua_color.r, lua_color.g, lua_color.b, 255),
        arrowIndicatorStyle = ui.new_combobox(tab, container, "\n arrows style", "-", "Teamskeet", "Modern"),
        minDmgIndicator = ui.new_checkbox(tab, container, "Minimum Damage Indicator"),
        logs = ui.new_checkbox(tab, container, "Logs"),
        logsClr = ui.new_color_picker(tab, container, "Logs Color", lua_color.r, lua_color.g, lua_color.b, 255),
        logOffset = ui.new_slider(tab, container, "Offset", 0, 500, 100, true, "px", 1)
    },
    miscTab = {
        avoidBackstab = ui.new_checkbox(tab, container, mContainer .. "Avoid backstab"),
        fixHideshots = ui.new_checkbox(tab, container, mContainer .. "Fix hideshots"),
        manualsOverFs = ui.new_checkbox(tab, container, mContainer .. "Manuals over freestanding"),
        animations = ui.new_multiselect(tab, container, "Animations", "Static legs in air", "Leg fucker", "Moonwalk", "0 pitch on landing"),
    },
    configTab = {
        list = ui.new_listbox(tab, container, "Configs", ""),
        name = ui.new_textbox(tab, container, "Config name", ""),
        load = ui.new_button(tab, container, "Load", function() end),
        save = ui.new_button(tab, container, "Save", function() end),
        delete = ui.new_button(tab, container, "Delete", function() end),
        import = ui.new_button(tab, container, "Import", function() end),
        export = ui.new_button(tab, container, "Export", function() end)
    }
}

local function getConfig(name)
    local database = database.read(lua.database.configs) or {}

    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    for i, v in pairs(presets) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    return false
end
local function saveConfig(name)
    local db = database.read(lua.database.configs) or {}
    local config = {}

    if name:match("[^%w]") ~= nil then
        return
    end

    for key, value in pairs(vars.pStates) do
        config[value] = {}
        for k, v in pairs(aaBuilder[key]) do
            config[value][k] = ui.get(v)
        end
    end

    local cfg = getConfig(name)

    if not cfg then
        table.insert(db, { name = name, config = config })
    else
        db[cfg.index].config = config
    end

    database.write(lua.database.configs, db)
end
local function deleteConfig(name)
    local db = database.read(lua.database.configs) or {}

    for i, v in pairs(db) do
        if v.name == name then
            table.remove(db, i)
            break
        end
    end

    for i, v in pairs(presets) do
        if v.name == name then
            return false
        end
    end

    database.write(lua.database.configs, db)
end
local function getConfigList()
    local database = database.read(lua.database.configs) or {}
    local config = {}

    for i, v in pairs(presets) do
        table.insert(config, v.name)
    end

    for i, v in pairs(database) do
        table.insert(config, v.name)
    end

    return config
end
local function typeFromString(input)
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
local function loadSettings(config)
    for key, value in pairs(vars.pStates) do
        for k, v in pairs(aaBuilder[key]) do
            if (config[value][k] ~= nil) then
                ui.set(v, config[value][k])
            end
        end 
    end
end
local function importSettings()
    loadSettings(json.parse(clipboard.get()))
end
local function exportSettings(name)
    local config = getConfig(name)
    clipboard.set(json.stringify(config.config))
end
local function loadConfig(name)
    local config = getConfig(name)
    loadSettings(config.config)
end

local function initDatabase()
    if database.read(lua.database.configs) == nil then
        database.write(lua.database.configs, {})
    end

    local link = ""

    http.get(link, function(success, response)
        if not success then
            print("Failed to get presets")
            return
        end
    
        data = json.parse(response.body)
    
        for i, preset in pairs(data.presets) do
            table.insert(presets, { name = "*"..preset.name, config = preset.config})
            ui.set(menu.configTab.name, "*"..preset.name)
        end
        ui.update(menu.configTab.list, getConfigList())
    end)
end

-- @region UI_LAYOUT end

-- @region NOTIFICATION_ANIM start
local anim_time = 0.75
local max_notifs = 6
local data = {}
local notifications = {

    new = function( string, r, g, b)
        table.insert(data, {
            time = globals.curtime(),
            string = string,
            color = {r, g, b, 255},
            fraction = 0
        })
        local time = 5
        for i = #data, 1, -1 do
            local notif = data[i]
            if #data - i + 1 > max_notifs and notif.time + time - globals.curtime() > 0 then
                notif.time = globals.curtime() - time
            end
        end
    end,

    render = function()
        local x, y = client.screen_size()
        local to_remove = {}
        local Offset = 0
        for i = 1, #data do
            local notif = data[i]

            local data = {rounding = 4, size = 3, glow = 2, time = 4}

            if notif.time + data.time - globals.curtime() > 0 then
                notif.fraction = func.clamp(notif.fraction + globals.frametime() / anim_time, 0, 1)
            else
                notif.fraction = func.clamp(notif.fraction - globals.frametime() / anim_time, 0, 1)
            end

            if notif.fraction <= 0 and notif.time + data.time - globals.curtime() <= 0 then
                table.insert(to_remove, i)
            end
            local fraction = func.easeInOut(notif.fraction)

            local r, g, b, a = unpack(notif.color)
            local string = color_text(notif.string, r, g, b, a * fraction)

            local strw, strh = renderer.measure_text("", string)
            local strw2 = renderer.measure_text("b", "")

            local paddingx, paddingy = 7, data.size
            local offsetY = ui.get(menu.visualsTab.logOffset)

            Offset = Offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction
            glow_module(x/2 - (strw + strw2)/2 - paddingx, y - offsetY - strh/2 - paddingy - Offset, strw + strw2 + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {r, g, b, 45 * fraction}, {25,25,25,140 * fraction})
            renderer.text(x/2 + strw2/2, y - offsetY - Offset, 255, 255, 255, 255 * fraction, "c", 0, string)
        end

        for i = #to_remove, 1, -1 do
            table.remove(data, to_remove[i])
        end
    end,

    clear = function()
        data = {}
    end
}

local function onHit(e)
    local group = vars.hitgroup_names[e.hitgroup + 1] or '?'
	local r, g, b, a = ui.get(menu.visualsTab.logsClr)
	notifications.new(string.format("Hit %s's $%s$ for $%d$ damage ($%d$ health remaining)", entity.get_player_name(e.target), group:lower(), e.damage, entity.get_prop(e.target, 'm_iHealth')), r, g, b) 

end

local function onMiss(e)
    local group = vars.hitgroup_names[e.hitgroup + 1] or '?'
    local ping = math.min(999, client.real_latency() * 1000)
    local ping_col = (ping >= 100) and { 255, 0, 0 } or { 150, 200, 60 }
    local hc = math.floor(e.hit_chance + 0.5);
    local hc_col = (hc < ui.get(refs.hitChance)) and { 255, 0, 0 } or { 150, 200, 60 };
    e.reason = e.reason == "?" and "resolver" or e.reason
	notifications.new(string.format("Missed %s's $%s$ due to $%s$", entity.get_player_name(e.target), group:lower(), e.reason), 255, 120, 120)
end

client.set_event_callback("client_disconnect", function()  notifications.clear() end)
client.set_event_callback("level_init", function() notifications.clear() end)
client.set_event_callback('player_connect_full', function(e) if client.userid_to_entindex(e.userid) == entity.get_local_player() then notifications.clear() end end)
-- @region NOTIFICATION_ANIM end

-- @region AA_CALLBACKS start
local aa = {
	ignore = false,
	manualAA= 0,
	input = 0,
}
client.set_event_callback("player_connect_full", function() 
	aa.ignore = false
	aa.manualAA= 0
	aa.input = 0
end)
client.set_event_callback("setup_command", function(cmd)
    vars.localPlayer = entity.get_local_player()
    if not vars.localPlayer  or not entity.is_alive(vars.localPlayer) then return end
	local flags = entity.get_prop(vars.localPlayer, "m_fFlags")
    local onground = bit.band(flags, 1) ~= 0 and cmd.in_jump == 0
	local valve = entity.get_prop(entity.get_game_rules(), "m_bIsValveDS")
	local origin = vector(entity.get_prop(vars.localPlayer, "m_vecOrigin"))
	local velocity = vector(entity.get_prop(vars.localPlayer, "m_vecVelocity"))
	local camera = vector(client.camera_angles())
	local eye = vector(client.eye_position())
	local speed = math.sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y) + (velocity.z * velocity.z))
    local weapon = entity.get_player_weapon()
	local pStill = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2) < 5
    local bodyYaw = entity.get_prop(vars.localPlayer, "m_flPoseParameter", 11) * 120 - 60

    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
	local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
	local isFd = ui.get(refs.fakeDuck)
	local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    local isLegitAA = ui.get(menu.aaTab.legitAAHotkey)

    local manualsOverFs = ui.get(menu.miscTab.manualsOverFs) == true and true or false

    -- manual aa
    ui.set(menu.aaTab.manualLeft, "On hotkey")
    ui.set(menu.aaTab.manualRight, "On hotkey")
    ui.set(menu.aaTab.manualForward, "On hotkey")
    if aa.input + 0.22 < globals.curtime() then
        if aa.manualAA == 0 then
            if ui.get(menu.aaTab.manualLeft) then
                aa.manualAA = 1
                aa.input = globals.curtime()
            elseif ui.get(menu.aaTab.manualRight) then
                aa.manualAA = 2
                aa.input = globals.curtime()
            elseif ui.get(menu.aaTab.manualForward) then
                aa.manualAA = 3
                aa.input = globals.curtime()
            end
        elseif aa.manualAA == 1 then
            if ui.get(menu.aaTab.manualRight) then
                aa.manualAA = 2
                aa.input = globals.curtime()
            elseif ui.get(menu.aaTab.manualForward) then
                aa.manualAA = 3
                aa.input = globals.curtime()
            elseif ui.get(menu.aaTab.manualLeft) then
                aa.manualAA = 0
                aa.input = globals.curtime()
            end
        elseif aa.manualAA == 2 then
            if ui.get(menu.aaTab.manualLeft) then
                aa.manualAA = 1
                aa.input = globals.curtime()
            elseif ui.get(menu.aaTab.manualForward) then
                aa.manualAA = 3
                aa.input = globals.curtime()
            elseif ui.get(menu.aaTab.manualRight) then
                aa.manualAA = 0
                aa.input = globals.curtime()
            end
        elseif aa.manualAA == 3 then
            if ui.get(menu.aaTab.manualForward) then
                aa.manualAA = 0
                aa.input = globals.curtime()
            elseif ui.get(menu.aaTab.manualLeft) then
                aa.manualAA = 1
                aa.input = globals.curtime()
            elseif ui.get(menu.aaTab.manualRight) then
                aa.manualAA = 2
                aa.input = globals.curtime()
            end
        end
    end
    if aa.manualAA == 1 or aa.manualAA == 2 or aa.manualAA == 3 then
        aa.ignore = true
        if aa.manualAA == 1 then
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            ui.set(refs.bodyYaw[1], "Static")
            ui.set(refs.bodyYaw[2], -180)
            ui.set(refs.yawBase, "local view")
            ui.set(refs.yaw[1], "180")
            ui.set(refs.yaw[2], -90)
        elseif aa.manualAA == 2 then
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            ui.set(refs.bodyYaw[1], "Static")
            ui.set(refs.bodyYaw[2], -180)
            ui.set(refs.yawBase, "local view")
            ui.set(refs.yaw[1], "180")
            ui.set(refs.yaw[2], 90)
        elseif aa.manualAA == 3 then
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            ui.set(refs.bodyYaw[1], "Static")
            ui.set(refs.bodyYaw[2], -180)
            ui.set(refs.yawBase, "local view")
            ui.set(refs.yaw[1], "180")
            ui.set(refs.yaw[2], 180)
        end
    else
        aa.ignore = false
    end

    local nextAttack = entity.get_prop(vars.localPlayer, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(vars.localPlayer), "m_flNextPrimaryAttack")
    local dtActive = false
    local isFl = ui.get(ui.reference("AA", "Fake lag", "Enabled"))
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end

    if pStill then vars.pState = 1 end
    if not pStill then vars.pState = 2 end
    if isSlow then vars.pState = 3 end
    if entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 4 end
    if not pStill and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 7 end
    if not onground then vars.pState = 5 end
    if not onground and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 6 end

    -- apply antiaim
    local side = bodyYaw > 0 and 1 or -1
    local in_bombzone   = entity.get_prop(vars.localPlayer, "m_bInBombZone") > 0
    local weapon_ent = entity.get_player_weapon(vars.localPlayer)
    local wtype = csgo_weapons(weapon_ent)
    local holding_bomb  = wtype.type == "c4"
    local bomb_table    = entity.get_all("CPlantedC4")
    local bomb_planted  = #bomb_table > 0
    local bomb_distance = 100
    local defusing = bomb_distance < 62 and entity.get_prop(vars.localPlayer, "m_iTeamNum") == 3

    if not ui.get(menu.aaTab.legitAAHotkey) and aa.ignore == false then
        if ui.get(aaBuilder[vars.pState].enableState) then
            local pitchTypes = {[1] = "Up", [2] = ui.get(aaBuilder[vars.pState].pitch)}
            local flick
            if (onground) then
                flick = globals.realtime()
            end

            if func.table_contains(ui.get(menu.aaTab.exploits), "Pitch flick in air") and not onground and flick ~= nil then
                if (globals.realtime() - flick > 0.5) then
                    ui.set(refs.pitch[1], "Up")
                    flick = globals.realtime()
                else
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                end
            elseif ui.get(aaBuilder[vars.pState].pitch) ~= "Custom" then
                ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
            else
                ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
            end

            ui.set(refs.yawBase, ui.get(aaBuilder[vars.pState].yawBase))

            if cmd.chokedcommands == 0 then
                ui.set(refs.yaw[1], ui.get(aaBuilder[vars.pState].yaw))
                ui.set(refs.yaw[2],(side == 1 and ui.get(aaBuilder[vars.pState].yawLeft) or ui.get(aaBuilder[vars.pState].yawRight)))
            end

            if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                ui.set(refs.yawJitter[1], "Center")
                ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft)*math.random(-1, 1)  or ui.get(aaBuilder[vars.pState].yawJitterRight)*math.random(-1, 1) ))
            else
                ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
                ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
            end


            if ui.get(aaBuilder[vars.pState].bodyYaw) == "Jitter" then
                ui.set(refs.bodyYaw[1], "Static")
                ui.set(refs.bodyYaw[2], globals.tickcount() % 2 == 1 and 180 or -180)
            else
                ui.set(refs.bodyYaw[1], ui.get(aaBuilder[vars.pState].bodyYaw))
                ui.set(refs.bodyYaw[2], (side == 1 and ui.get(aaBuilder[vars.pState].bodyYawLeft) or ui.get(aaBuilder[vars.pState].bodyYawRight)))
            end

            ui.set(refs.roll, ui.get(aaBuilder[vars.pState].roll))
        elseif not ui.get(aaBuilder[vars.pState].enableState) then
            ui.set(refs.pitch[1], "Off")
            ui.set(refs.yawBase, "Local view")
            ui.set(refs.yaw[1], "Off")
            ui.set(refs.yaw[2], 0)
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            ui.set(refs.bodyYaw[1], "Off")
            ui.set(refs.bodyYaw[2], 0)
            ui.set(refs.fsBodyYaw, false)
            ui.set(refs.edgeYaw, false)
            ui.set(refs.roll, 0)
        end
    elseif ui.get(menu.aaTab.legitAAHotkey) and aa.ignore == false then
        if weapon ~= nil and entity.get_classname(weapon) == "CC4" or (in_bombzone and holding_bomb or defusing) then
            cmd.in_use = 1
        else
            cmd.in_use = 0
            ui.set(refs.pitch[1], "Off")
            ui.set(refs.yawBase, "Local view")
            ui.set(refs.yaw[1], "Off")
            ui.set(refs.yaw[2], 0)
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            ui.set(refs.bodyYaw[1], "Opposite")
            ui.set(refs.bodyYaw[2], 0)
            ui.set(refs.fsBodyYaw, true)
            ui.set(refs.edgeYaw, false)
            ui.set(refs.roll, 0)
        end
    end

    -- fix hideshots
	if ui.get(menu.miscTab.fixHideshots) then
		if isOs and not isDt and not isFd then
            if not hsSaved then
                hsValue = ui.get(refs.fakeLag[1])
                hsSaved = true
            end
			ui.set(refs.fakeLag[1], 1)
		elseif hsSaved then
			ui.set(refs.fakeLag[1], hsValue)
            hsSaved = false
		end
	end

    -- avoid backstab
    if ui.get(menu.miscTab.avoidBackstab) then
        local players = entity.get_players(true)

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = func.findDist(origin.x, origin.y, origin.z, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 200 then
                ui.set(refs.yaw[2], 180)
                ui.set(refs.pitch[1], "Off")
            end
        end
    end

    -- freestand
    if (ui.get(menu.aaTab.freestandHotkey)) then
        if manualsOverFs == true and aa.ignore == true then
            ui.set(refs.freeStand[2], "On hotkey")
            return
        else
            ui.set(refs.freeStand[2], "Always on")
            ui.set(refs.freeStand[1], true)
        end
    else
        ui.set(refs.freeStand[1], false)
        ui.set(refs.freeStand[2], "On hotkey")
    end

    if func.table_contains(ui.get(menu.aaTab.exploits), "Air tick switcher") and not onground then
        if dtSaved == nil then
            dtSaved = ui.get(refs.dt[3])
        end
        ui.set(refs.dt[3], globals.tickcount() % 2 == 1 and "Offensive" or "Defensive")
    else
        if dtSaved ~= nil then
            ui.set(refs.dt[3], dtSaved)
            dtSaved = nil
        end
    end

    local defensiveKey = ( isDt and not onground and func.table_contains(ui.get(menu.aaTab.exploits), "Force defensive in air") )

    cmd.force_defensive = defensiveKey == true and true or false

    isDefensive = cmd.force_defensive == true and true or false
end)

local legsSaved = false
local legsTypes = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
local ground_ticks = 0
client.set_event_callback("pre_render", function()
    if not entity.get_local_player() then return end
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)

    if func.table_contains(ui.get(menu.miscTab.animations), "Static legs in air") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
    end

   if func.table_contains(ui.get(menu.miscTab.animations), "Leg fucker") or func.table_contains(ui.get(menu.miscTab.animations), "Moonwalk") then
        if not legsSaved then
            legsSaved = ui.get(refs.legMovement)
        end
        ui.set_visible(refs.legMovement, false)
        if func.table_contains(ui.get(menu.miscTab.animations), "Leg fucker") and not func.table_contains(ui.get(menu.miscTab.animations), "Moonwalk") then
            ui.set(refs.legMovement, legsTypes[math.random(1, 3)])
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
        elseif func.table_contains(ui.get(menu.miscTab.animations), "Moonwalk")then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
            local me = ent.get_local_player()
            local flags = me:get_prop("m_fFlags")
            local onground = bit.band(flags, 1) ~= 0
            if not onground then
                local my_animlayer = me:get_anim_overlay(6) -- MOVEMENT_MOVE
                my_animlayer.weight = 1
            end
            ui.set(refs.legMovement, "Off")
        end
    elseif (legsSaved == "Off" or legsSaved == "Always slide" or legsSaved == "Never slide") then
        ui.set_visible(refs.legMovement, true)
        ui.set(refs.legMovement, legsSaved)
        legsSaved = false
    end
    if func.table_contains(ui.get(menu.miscTab.animations), "0 pitch on landing") then
        ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0

        if ground_ticks > 20 and ground_ticks < 150 then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
        end
    end
end)
-- @region AA_CALLBACKS end

-- @region INDICATORS start
local alpha = 0
local scopedFraction = 0

local mainIndClr = {r = 0, g = 0, b = 0, a = 0}
local dtClr = {r = 0, g = 0, b = 0, a = 0}
local chargeClr = {r = 0, g = 0, b = 0, a = 0}
local chargeInd = {w = 0, x = 0, y = 25}
local psClr = {r = 0, g = 0, b = 0, a = 0}
local dtInd = {w = 0, x = 0, y = 25}
local qpInd = {w = 0, x = 0, y = 25, a = 0}
local fdInd = {w = 0, x = 0, y = 25, a = 0}
local spInd = {w = 0, x = 0, y = 25, a = 0}
local baInd = {w = 0, x = 0, y = 25, a = 0}
local fsInd = {w = 0, x = 0, y = 25, a = 0}
local osInd = {w = 0, x = 0, y = 25, a = 0}
local psInd = {w = 0, x = 0, y = 25}
local wAlpha = 0
client.set_event_callback("paint", function()
    local local_player = entity.get_local_player()
    if local_player == nil or entity.is_alive(local_player) == false then return end
    local sizeX, sizeY = client.screen_size()
    local weapon = entity.get_player_weapon(local_player)
    local bodyYaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyYaw > 0 and 1 or -1
    local state = "MOVING"
    local mainClr = {}
    mainClr.r, mainClr.g, mainClr.b, mainClr.a = ui.get(menu.visualsTab.indicatorsClr)
    local arrowClr = {}
    arrowClr.r, arrowClr.g, arrowClr.b, arrowClr.a = ui.get(menu.visualsTab.arrowClr)
    local fake = math.floor(antiaim_funcs.get_desync(1))

    local indicators = 0
    
    -- draw arrows
    if ui.get(menu.visualsTab.arrows) then
        if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Modern" then
            alpha = (aa.manualAA == 2 or aa.manualAA == 1) and func.lerp(alpha, 255, globals.frametime() * 3) or func.lerp(alpha, 0, globals.frametime() * 11)
            renderer.text(sizeX / 2 + 45, sizeY / 2 - 2.5, aa.manualAA == 2 and arrowClr.r or 200, aa.manualAA == 2 and arrowClr.g or 200, aa.manualAA == 2 and arrowClr.b or 200, alpha, "c+", 0, '⮞')
            renderer.text(sizeX / 2 - 45, sizeY / 2 - 2.5, aa.manualAA == 1 and arrowClr.r or 200, aa.manualAA == 1 and arrowClr.g or 200, aa.manualAA == 1 and arrowClr.b or 200, alpha, "c+", 0, '⮜')
        end
    
        if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Teamskeet" then
            renderer.triangle(sizeX / 2 + 55, sizeY / 2 + 2, sizeX / 2 + 42, sizeY / 2 - 7, sizeX / 2 + 42, sizeY / 2 + 11, 
            aa.manualAA == 2 and arrowClr.r or 25, 
            aa.manualAA == 2 and arrowClr.g or 25, 
            aa.manualAA == 2 and arrowClr.b or 25, 
            aa.manualAA == 2 and arrowClr.a or 160)
    
            renderer.triangle(sizeX / 2 - 55, sizeY / 2 + 2, sizeX / 2 - 42, sizeY / 2 - 7, sizeX / 2 - 42, sizeY / 2 + 11, 
            aa.manualAA == 1 and arrowClr.r or 25, 
            aa.manualAA == 1 and arrowClr.g or 25, 
            aa.manualAA == 1 and arrowClr.b or 25, 
            aa.manualAA == 1 and arrowClr.a or 160)
        
            renderer.rectangle(sizeX / 2 + 38, sizeY / 2 - 7, 2, 18, 
            bodyYaw < -10 and arrowClr.r or 25,
            bodyYaw < -10 and arrowClr.g or 25,
            bodyYaw < -10 and arrowClr.b or 25,
            bodyYaw < -10 and arrowClr.a or 160)
            renderer.rectangle(sizeX / 2 - 40, sizeY / 2 - 7, 2, 18,			
            bodyYaw > 10 and arrowClr.r or 25,
            bodyYaw > 10 and arrowClr.g or 25,
            bodyYaw > 10 and arrowClr.b or 25,
            bodyYaw > 10 and arrowClr.a or 160)
        end
    end

    -- move on scope
    local scopeLevel = entity.get_prop(weapon, 'm_zoomLevel')
    local scoped = entity.get_prop(local_player, 'm_bIsScoped') == 1
    local resumeZoom = entity.get_prop(local_player, 'm_bResumeZoom') == 1
    local isValid = weapon ~= nil and scopeLevel ~= nil
    local act = isValid and scopeLevel > 0 and scoped and not resumeZoom
    local time = globals.frametime() * 30

    if act then
        if scopedFraction < 1 then
            scopedFraction = func.lerp(scopedFraction, 1 + 0.1, time)
        else
            scopedFraction = 1
        end
    else
        scopedFraction = func.lerp(scopedFraction, 0, time)
    end

    -- draw indicators
    if ui.get(menu.visualsTab.indicators) and ui.get(menu.visualsTab.indicatorsType) ~= "-" then
        local dpi = ui.get(ui.reference("MISC", "Settings", "DPI scale")):gsub('%%', '') - 100
        local globalFlag = ui.get(menu.visualsTab.indicatorsType) == "Style 1" and "cd-" or "cd"
        local globalMoveY = 0
        local indX, indY = renderer.measure_text(globalFlag, "DT")
        local yDefault = 16
        local indCount = 0
        indY = globalFlag == "cd-" and indY - 3 or indY - 2
    
        local isCharged = antiaim_funcs.get_double_tap()
        local isFs = ui.get(menu.aaTab.freestandHotkey)
        local isBa = ui.get(refs.forceBaim)
        local isSp = ui.get(refs.safePoint)
        local isQp = ui.get(refs.quickPeek[2])
        local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
        local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
        local isFd = ui.get(refs.fakeDuck)
        local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    
        local state = vars.intToS[vars.pState]:upper()
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Name") then
            indicators = indicators + 1
            local namex, namey = renderer.measure_text(globalFlag, globalFlag == "cd-" and lua_name:upper() or lua_name:lower())
            local logo = animate_text(globals.curtime(), globalFlag == "cd-" and lua_name:upper() or lua_name:lower(), mainClr.r, mainClr.g, mainClr.b, 255)
    
            renderer.text(sizeX/2 + ((namex + 2)/2) * scopedFraction, sizeY/2 + 20 - dpi/10, 255, 255, 255, 255, globalFlag, nil, unpack(logo))
        end 
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "State") then
            indicators = indicators + 1
            indCount = indCount + 1
            local namex, namey = renderer.measure_text(globalFlag, globalFlag == "cd-" and lua_name:upper() or lua_name:lower())
            local stateX, stateY = renderer.measure_text(globalFlag, globalFlag == "cd-" and state:upper() or userdata.build:lower())
            local string = globalFlag == "cd-" and state:upper() or userdata.build:lower()
            renderer.text(sizeX/2 + (stateX + 2)/2 * scopedFraction, sizeY/2 + 20 + namey/1.2, 255, 255, 255, globalFlag == "cd-" and 255 or math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255, globalFlag, 0, string)
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Doubletap") then
            indicators = indicators + 1
            if isDt then 
                dtClr.a = func.lerp(dtClr.a, 255, time)
                if dtInd.y < yDefault + indY * indCount then
                    dtInd.y = func.lerp(dtInd.y, yDefault + indY * indCount + 1, time)
                else
                    dtInd.y = yDefault + indY * indCount
                end
                chargeInd.w = 0.1
                if not isCharged then
                    dtClr.r = func.lerp(dtClr.r, 222, time)
                    dtClr.g = func.lerp(dtClr.g, 55, time)
                    dtClr.b = func.lerp(dtClr.b, 55, time)
                else
                    dtClr.r = func.lerp(dtClr.r, 144, time)
                    dtClr.g = func.lerp(dtClr.g, 238, time)
                    dtClr.b = func.lerp(dtClr.b, 144, time)
                end
                indCount = indCount + 1
            elseif not isDt then 
                dtClr.a = func.lerp(dtClr.a, 0, time)
                dtInd.y = func.lerp(dtInd.y, yDefault - 5, time)
            end
    
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "DT" or "dt") + 2)/2) * scopedFraction , sizeY / 2 + dtInd.y + 13 + globalMoveY, dtClr.r, dtClr.g, dtClr.b, dtClr.a, globalFlag, dtInd.w, globalFlag == "cd-" and "DT" or "dt")
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Hideshots") then
            indicators = indicators + 1
            if isOs then 
                osInd.a = func.lerp(osInd.a, 255, time)
                if osInd.y < yDefault + indY * indCount then
                    osInd.y = func.lerp(osInd.y, yDefault + indY * indCount + 1, time)
                else
                    osInd.y = yDefault + indY * indCount
                end
        
                indCount = indCount + 1
            elseif not isOs then
                osInd.a = func.lerp(osInd.a, 0, time)
                osInd.y = func.lerp(osInd.y, yDefault - 5, time)
            end
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "HS" or "hs") + 2)/2) * scopedFraction, sizeY / 2 + osInd.y + 13 + globalMoveY, 255, 255, 255, osInd.a, globalFlag, osInd.w, globalFlag == "cd-" and "HS" or "hs")
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Freestand") then
            indicators = indicators + 1
            if isFs then 
                fsInd.a = func.lerp(fsInd.a, 255, time)
                if fsInd.y < yDefault + indY * indCount then
                    fsInd.y = func.lerp(fsInd.y, yDefault + indY * indCount + 1, time)
                else
                    fsInd.y = yDefault + indY * indCount
                end
                indCount = indCount + 1
            elseif not isFs then 
                fsInd.a = func.lerp(fsInd.a, 0, time)
                fsInd.y = func.lerp(fsInd.y, yDefault - 5, time)
            end
            renderer.text(sizeX / 2 + fsInd.x + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "FS" or "fs") + 2)/2) * scopedFraction, sizeY / 2 + fsInd.y + 13 + globalMoveY, 255, 255, 255, fsInd.a, globalFlag, fsInd.w, globalFlag == "cd-" and "FS" or "fs")
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Safepoint") then
            indicators = indicators + 1
            if isSp then 
                spInd.a = func.lerp(spInd.a, 255, time)
                if spInd.y < yDefault + indY * indCount then
                    spInd.y = func.lerp(spInd.y, yDefault + indY * indCount + 1, time)
                else
                    spInd.y = yDefault + indY * indCount
                end
                indCount = indCount + 1
            elseif not isSp then 
                spInd.a = func.lerp(spInd.a, 0, time)
                spInd.y = func.lerp(spInd.y, yDefault - 5, time)
            end
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "SP" or "sp") + 2)/2) * scopedFraction, sizeY / 2 + spInd.y + 13 + globalMoveY, 255, 255, 255, spInd.a, globalFlag, 0, globalFlag == "cd-" and "SP" or "sp")
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Body aim") then
            indicators = indicators + 1
            if isBa then
                baInd.a = func.lerp(baInd.a, 255, time)
                if baInd.y < yDefault + indY * indCount then
                    baInd.y = func.lerp(baInd.y, yDefault + indY * indCount + 1, time)
                else
                    baInd.y = yDefault + indY * indCount
                end
                indCount = indCount + 1
            elseif not isBa then 
                baInd.a = func.lerp(baInd.a, 0, time)
                baInd.y = func.lerp(baInd.y, yDefault - 5, time)
            end
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "BA" or "ba") + 2)/2) * scopedFraction, sizeY / 2 + baInd.y + 13 + globalMoveY, 255, 255, 255, baInd.a, globalFlag, 0, globalFlag == "cd-" and "BA" or "ba")
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Fakeduck") then
            indicators = indicators + 1
            if isFd then
                fdInd.a = func.lerp(fdInd.a, 255, time)
                if fdInd.y < yDefault + indY * indCount then
                    fdInd.y = func.lerp(fdInd.y, yDefault + indY * indCount + 1, time)
                else
                    fdInd.y = yDefault + indY * indCount
                end
                indCount = indCount + 1
            elseif not isFd then 
                fdInd.a = func.lerp(fdInd.a, 0, time)
                fdInd.y = func.lerp(fdInd.y, yDefault - 5, time)
            end
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "FD" or "fd") + 2)/2) * scopedFraction, sizeY / 2 + fdInd.y + 13 + globalMoveY, 255, 255, 255, fdInd.a, globalFlag, 0, globalFlag == "cd-" and "FD" or "fd")
        end
    end

    -- draw dmg indicator
    if ui.get(menu.visualsTab.minDmgIndicator) and entity.get_classname(weapon) ~= "CKnife" and ui.get(refs.dmgOverride[1]) and ui.get(refs.dmgOverride[2]) then
        local dmg = ui.get(refs.dmgOverride[3])
        renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, dmg)
    end

    notifications.render()
end)

ui.set_callback(menu.visualsTab.logs, function() 
    local callback = ui.get(menu.visualsTab.logs) and client.set_event_callback or client.unset_event_callback
    callback("aim_miss", onMiss)
    callback("aim_hit", onHit)
end)
-- @region INDICATORS end

-- @region UI_CALLBACKS start
ui.update(menu.configTab.list,getConfigList())
if database.read(lua.database.configs) == nil then
    database.write(lua.database.configs, {})
end
ui.set(menu.configTab.name, #database.read(lua.database.configs) == 0 and "" or database.read(lua.database.configs)[ui.get(menu.configTab.list)+1].name)
ui.set_callback(menu.configTab.list, function(value)
    local protected = function()
        if value == nil then return end
        local name = ""
    
        local configs = getConfigList()
        if configs == nil then return end
    
        name = configs[ui.get(value)+1] or ""
    
        ui.set(menu.configTab.name, name)
    end

    if pcall(protected) then

    end
end)

ui.set_callback(menu.configTab.load, function()

    local name = ui.get(menu.configTab.name)
    if name == "" then return end
    local protected = function()
        loadConfig(name)
    end

    if pcall(protected) then
        name = name:gsub('*', '')
    else
    end
end)

ui.set_callback(menu.configTab.save, function()


        local name = ui.get(menu.configTab.name)
        if name == "" then return end
    
        for i, v in pairs(presets) do
            if v.name == name:gsub('*', '') then
                return
            end
        end

        if name:match("[^%w]") ~= nil then
            return
        end
    local protected = function()
        saveConfig(name)
        ui.update(menu.configTab.list, getConfigList())
    end
    if pcall(protected) then

    end
end)

ui.set_callback(menu.configTab.delete, function()
    local name = ui.get(menu.configTab.name)
    if name == "" then return end

    if deleteConfig(name) == false then
        ui.update(menu.configTab.list, getConfigList())
        return
    end

    for i, v in pairs(presets) do
        if v.name == name:gsub('*', '') then

            return
        end
    end

    local protected = function()
        deleteConfig(name)
    end

    if pcall(protected) then
        ui.update(menu.configTab.list, getConfigList())
        ui.set(menu.configTab.list, #presets + #database.read(lua.database.configs) - #database.read(lua.database.configs))
        ui.set(menu.configTab.name, #database.read(lua.database.configs) == 0 and "" or getConfigList()[#presets + #database.read(lua.database.configs) - #database.read(lua.database.configs)+1])
    end
end)

ui.set_callback(menu.configTab.import, function()


    local protected = function()
        importSettings()
    end

    if pcall(protected) then
    end
end)

ui.set_callback(menu.configTab.export, function()
    local name = ui.get(menu.configTab.name)
    if name == "" then return end

    local protected = function()
        exportSettings(name)
    end

    if pcall(protected) then

    end
end)
-- @region UI_CALLBACKS end

-- @region UI_RENDER start
client.set_event_callback("paint_ui", function()
    vars.activeState = vars.sToInt[ui.get(statePicker)]
    local isEnabled = true
    local isAATab = ui.get(tabPicker) == "Anti-aim"
    local isBuilderTab = ui.get(tabPicker) == "Builder"
    local isVisualsTab = ui.get(tabPicker) == "Visuals"
    local isMiscTab = ui.get(tabPicker) == "Misc"
    local isCFGTab = ui.get(tabPicker) == "Config"

    local aA = func.create_color_array(lua_color.r, lua_color.g, lua_color.b, "nightcore")
    ui.set(label, string.format("\a%sni\a%sgh\a%sr\a%sc\a%so\a%sr\a%se", func.RGBAtoHEX(unpack(aA[1])), func.RGBAtoHEX(unpack(aA[2])), func.RGBAtoHEX(unpack(aA[3])), func.RGBAtoHEX(unpack(aA[4])), func.RGBAtoHEX(unpack(aA[5])), func.RGBAtoHEX(unpack(aA[6])),  func.RGBAtoHEX(unpack(aA[7])) ) )

    for i = 1, #vars.aaStates do
        local stateEnabled = ui.get(aaBuilder[i].enableState)
        ui.set_visible(aaBuilder[i].enableState, vars.activeState == i and isBuilderTab and isEnabled)
        ui.set_visible(aaBuilder[i].pitch, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].pitchSlider , vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].pitch) == "Custom" and isEnabled)
        ui.set_visible(aaBuilder[i].yawBase, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitter, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterLeft, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterRight, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawLeft, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawRight, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].roll, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
    end

    ui.set_visible(statePicker, isBuilderTab and isEnabled)

    for i, feature in pairs(menu.aaTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isAATab and isEnabled)
        end
	end 

    for i, feature in pairs(menu.visualsTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isVisualsTab and isEnabled)
        end
	end 
    ui.set_visible(menu.visualsTab.logOffset, ui.get(menu.visualsTab.logs) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.logsClr, ui.get(menu.visualsTab.logs) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.indicatorsStyle, ui.get(menu.visualsTab.indicatorsType) ~= "-" and ui.get(menu.visualsTab.indicators) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.indicatorsClr, ui.get(menu.visualsTab.indicators) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.indicatorsType, ui.get(menu.visualsTab.indicators) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.arrowIndicatorStyle, ui.get(menu.visualsTab.arrows) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.arrowClr, ui.get(menu.visualsTab.arrows) and isVisualsTab and isEnabled)

    for i, feature in pairs(menu.miscTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isMiscTab and isEnabled)
        end
	end

    for i, feature in pairs(menu.configTab) do
		ui.set_visible(feature, isCFGTab and isEnabled)
	end

    if not isEnabled and not saved then
        func.resetAATab()
        ui.set(refs.fsBodyYaw, isEnabled)
        ui.set(refs.enabled, isEnabled)
        saved = true
    elseif isEnabled and saved then
        ui.set(refs.fsBodyYaw, not isEnabled)
        ui.set(refs.enabled, isEnabled)
        saved = false
    end
    func.setAATab(not isEnabled)

end)
-- @region UI_RENDER end

client.set_event_callback("shutdown", function()
    if legsSaved ~= false then
        ui.set(refs.legMovement, legsSaved)
    end
    if hsValue ~= nil then
        ui.set(refs.fakeLag[1], hsValue)
    end
    if dtSaved ~= nil then
        ui.set(refs.dt[3], dtSaved)
    end
    func.setAATab(true)
end)