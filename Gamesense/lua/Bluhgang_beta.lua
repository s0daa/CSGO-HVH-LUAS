-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- @region LUASETTINGS start
local lua_name = "bluhgang"
local lua_color = {r = 200, g = 162, b = 200}
-- @region LUASETTINGS end


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
    build = build ~= nil and build:gsub("Private", "nightly"):gsub("Debug", "dev"):gsub("Beta", "beta"):gsub("User", "user") or "nightly"
}
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
    aaStates = {"Global", "Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Crouch-Moving"},
    pStates = {"G", "S", "M", "SW", "C", "A", "AC", "CM"},
	sToInt = {["Global"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["Slowwalking"] = 4, ["Crouching"] = 5, ["Air"] = 6, ["Air-Crouching"] = 7, ["Crouch-Moving"] = 8},
    intToS = {[1] = "Global", [2] = "Standing", [3] = "Moving", [4] = "Slowwalking", [5] = "Crouching", [6] = "Air", [7] = "Air-Crouching", [8] = "Crouch-Moving"},
    currentTab = 1,
    activeState = 1,
    pState = 1
}
local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI = js.MyPersonaAPI, js.LobbyAPI, js.PartyListAPI, js.SteamOverlayAPI
-- @region VARIABLES end

-- @region FUNCS start
local func = {
    render_text = function(x, y, ...)
        local x_Offset = 0
        
        local args = {...}
    
        for i, line in pairs(args) do
            local r, g, b, a, text = unpack(line)
            local size = vector(renderer.measure_text("-d", text))
            renderer.text(x + x_Offset, y, r, g, b, a, "-d", 0, text)
            x_Offset = x_Offset + size.x
        end
    end,
    RGBAtoHEX = function(r, g, b, a)
        return bit.tohex(
          (math.floor(r + 0.5) * 16777216) + 
          (math.floor(g + 0.5) * 65536) + 
          (math.floor(b + 0.5) * 256) + 
          (math.floor(a + 0.5))
        )
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
    end,
    textArray = function(string)
        local result = {}
        for i=1, #string do
            result[i] = string.sub(string, i, i)
        end
        return result
    end,
    gradient_text = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
        local output = ''
    
        local len = #text-1
    
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len
    
        for i=1, len+1 do
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
    
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end
    
        return output
    end
,    
    time_to_ticks = function(t)
        return math.floor(0.5 + (t / globals.tickinterval()))
    end,
    headVisible = function(enemy)
        local_player = entity.get_local_player()
        if local_player == nil then return end
        local ex, ey, ez = entity.hitbox_position(enemy, 1)
    
        local hx, hy, hz = entity.hitbox_position(local_player, 1)
        local head_fraction, head_entindex_hit = client.trace_line(enemy, ex, ey, ez, hx, hy, hz)
        if head_entindex_hit == local_player or head_fraction == 1 then return true else return false end
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

local colorful_text = {
    lerp = function(self, from, to, duration)
        if type(from) == 'table' and type(to) == 'table' then
            return { 
                self:lerp(from[1], to[1], duration), 
                self:lerp(from[2], to[2], duration), 
                self:lerp(from[3], to[3], duration) 
            };
        end
    
        return from + (to - from) * duration;
    end,
    console = function(self, ...)
        for i, v in ipairs({ ... }) do
            if type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                for k = 1, #v[3] do
                    local l = self:lerp(v[1], v[2], k / #v[3]);
                    client.color_log(l[1], l[2], l[3], v[3]:sub(k, k) .. '\0');
                end
            elseif type(v[1]) == 'table' and type(v[2]) == 'string' then
                client.color_log(v[1][1], v[1][2], v[1][3], v[2] .. '\0');
            end
        end
    end,
    text = function(self, ...)
        local menu = false;
        local alpha = 255
        local f = '';
        
        for i, v in ipairs({ ... }) do
            if type(v) == 'boolean' then
                menu = v;
            elseif type(v) == 'number' then
                alpha = v;
            elseif type(v) == 'string' then
                f = f .. v;
            elseif type(v) == 'table' then
                if type(v[1]) == 'table' and type(v[2]) == 'string' then
                    f = f .. ('\a%02x%02x%02x%02x'):format(v[1][1], v[1][2], v[1][3], alpha) .. v[2];
                elseif type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                    for k = 1, #v[3] do
                        local g = self:lerp(v[1], v[2], k / #v[3])
                        f = f .. ('\a%02x%02x%02x%02x'):format(g[1], g[2], g[3], alpha) .. v[3]:sub(k, k)
                    end
                end
            end
        end
    
        return ('%s\a%s%02x'):format(f, (menu) and 'cdcdcd' or 'ffffff', alpha);
    end,
    log = function(self, ...)
        for i, v in ipairs({ ... }) do
            if type(v) == 'table' then
                if type(v[1]) == 'table' then
                    if type(v[2]) == 'string' then
                        self:console({ v[1], v[1], v[2] })
                        if (v[3]) then
                            self:console({ { 255, 255, 255 }, '\n' })
                        end
                    elseif type(v[2]) == 'table' then
                        self:console({ v[1], v[2], v[3] })
                        if v[4] then
                            self:console({ { 255, 255, 255 }, '\n' })
                        end
                    end
                elseif type(v[1]) == 'string' then
                    self:console({ { 205, 205, 205 }, v[1] });
                    if v[2] then
                        self:console({ { 255, 255, 255 }, '\n' })
                    end
                end
            end
        end
    end
}
-- @region FUNCS end

-- @region UI_LAYOUT start
local tab, container = "AA", "Anti-aimbot angles"
-- local label = ui.new_label(tab, container, "BLUHGANG")
local aaBtn = ui.new_button(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Anti-aim"), function() 
    vars.currentTab = 2
end)
local visBtn = ui.new_button(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Visuals"), function() 
    vars.currentTab = 3
end)
local mscBtn = ui.new_button(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Misc"), function() 
    vars.currentTab = 4
end)
local cfgBtn = ui.new_button(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Config"), function() 
    vars.currentTab = 5
end)

local tabPicker = ui.new_combobox(tab, container, "Select tab", "Anti-aim", "Keybinds")

local menu = {
    aaTab = {
        legitAAHotkey = ui.new_hotkey(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Legit AA")),
        freestandHotkey = ui.new_hotkey(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Freestand")),
        manuals = ui.new_combobox(tab, container, "Manuals", "Off", "Default", "Static"),
        manualTab = {
            manualLeft = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "left"),
            manualRight = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "right"),
            manualForward = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "forward"),
        },
    },
    builderTab = {
        state = ui.new_combobox(tab, container, "Anti-aim state", vars.aaStates),
    },
    visualsTab = {
        watermark = ui.new_combobox(tab, container, "Watermark", "Left", "Right"),
        indLabel = ui.new_label(tab, container, "Main Color"),
        indicatorsMainClr = ui.new_color_picker(tab, container, "Main Color", lua_color.r, lua_color.g, lua_color.b, 255),
        indicator = ui.new_checkbox(tab, container, "Indicators"),
        indicatorsStyle = ui.new_combobox(tab, container, "\n indicators style", "-", "Default", "Long"),
        arrow = ui.new_checkbox(tab, container, "Arrows"),
        arrowIndicatorStyle = ui.new_combobox(tab, container, "\n arrows style", "-", "Default", "Small"),
        logs = ui.new_checkbox(tab, container, "Logs"),
    },
    miscTab = {
        animations = ui.new_multiselect(tab, container, "Animations", "Static legs", "Leg fucker", "0 pitch on landing"),
        avoidBackstab = ui.new_checkbox(tab, container, "Avoid backstab"),
        fixHideshots = ui.new_checkbox(tab, container, "Fix hideshots"),
        forceDefensive = ui.new_checkbox(tab, container, "Force Defensive in Air"),
        disableByaw = ui.new_checkbox(tab, container, "Disable body yaw on warmup"),
        manualsOverFs = ui.new_checkbox(tab, container, "Manuals over freestanding"),
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

local aaBuilder = {}
local aaContainer = {}
local buildContainer = "(" .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. "AA" .. func.hex({200,200,200}) .. ") "
for i=1, #vars.aaStates do
    aaContainer[i] = func.hex({200,200,200}) .. "(" .. func.hex({222,55,55}) .. "" .. vars.pStates[i] .. "" .. func.hex({200,200,200}) .. ")" .. func.hex({155,155,155}) .. " "
    aaBuilder[i] = {
        enableState = ui.new_checkbox(tab, container, "Enable " .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({200,200,200}) .. " state"),
        pitch = ui.new_combobox(tab, container, buildContainer .. "Pitch\n" .. aaContainer[i], "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitchSlider = ui.new_slider(tab, container, "\nPitch add" .. aaContainer[i], -89, 89, 0, true, "°", 1),
        yawBase = ui.new_combobox(tab, container, buildContainer .. "Yaw base\n" .. aaContainer[i], "Local view", "At targets"),
        yaw = ui.new_combobox(tab, container, buildContainer .. "Yaw\n" .. aaContainer[i], "Off", "180", "Slow Yaw", "Spin", "Static", "180 Z", "Crosshair"),
        yawLeft = ui.new_slider(tab, container, buildContainer .. "Left\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawRight = ui.new_slider(tab, container, buildContainer .. "Right\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitter = ui.new_combobox(tab, container, buildContainer .. "Yaw jitter\n" .. aaContainer[i], "Off", "Offset", "Center", "3-Way", "Random"),
        yawJitterLeft = ui.new_slider(tab, container, buildContainer .. "Left\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterRight = ui.new_slider(tab, container, buildContainer .. "Right\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        bodyYaw = ui.new_combobox(tab, container, buildContainer .. "Body yaw\n" .. aaContainer[i], "Off", "Opposite", "Jitter", "Static"),
        bodyYawLeft = ui.new_slider(tab, container, buildContainer .. "Left\nbody yaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        bodyYawRight = ui.new_slider(tab, container, buildContainer .. "Right\nbody yaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
    }
end

local backBtn = ui.new_button(tab, container, "Return to menu", function() 
    vars.currentTab = 1
end)

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

    local link = "https://pastebin.com/raw/smAYn3cw"

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
initDatabase()
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

            Offset = Offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction
            glow_module(x/2 - (strw + strw2)/2 - paddingx, y - 100 - strh/2 - paddingy - Offset, strw + strw2 + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {r, g, b, 45 * fraction}, {25,25,25,140 * fraction})
            renderer.text(x/2 + strw2/2, y - 100 - Offset, 255, 255, 255, 255 * fraction, "c", 0, string)
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
	local r, g, b, a = ui.get(menu.visualsTab.indicatorsMainClr)
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

local function onPurchase(e)
    local userid = e.userid
    if userid == nil then return end

    if e.team == entity.get_prop(vars.localPlayer, 'm_iTeamNum') then return end

    local buyer = client.userid_to_entindex(userid)
    if buyer == nil then return end

    if e.weapon == "weapon_unknown" then return end

    local item = e.weapon;
    item = item:gsub('weapon_', '')

    if item == 'item_assaultsuit' then
        item = 'kevlar + helmet'
    elseif item == 'item_kevlar' then
        item = 'kevlar'
    elseif item == 'item_defuser' then
        item = 'defuser'
    else
        item = item:gsub('grenade', ' grenade');
    end
	local r, g, b, a = ui.get(menu.visualsTab.indicatorsMainClr)
    notifications.new(string.format('$%s$ purchased $%s$.', entity.get_player_name(buyer), item), r, g, b)
end
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
local current_tick = func.time_to_ticks(globals.realtime())
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
    ui.set(menu.aaTab.manualTab.manualLeft, "On hotkey")
    ui.set(menu.aaTab.manualTab.manualRight, "On hotkey")
    ui.set(menu.aaTab.manualTab.manualForward, "On hotkey")
 -- manual aa
    if ui.get(menu.aaTab.manuals) ~= "Off" then
        ui.set(menu.aaTab.manualTab.manualLeft, "On hotkey")
        ui.set(menu.aaTab.manualTab.manualRight, "On hotkey")
        ui.set(menu.aaTab.manualTab.manualForward, "On hotkey")
        if aa.input + 0.22 < globals.curtime() then
            if aa.manualAA == 0 then
                if ui.get(menu.aaTab.manualTab.manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()
                elseif ui.get(menu.aaTab.manualTab.manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                elseif ui.get(menu.aaTab.manualTab.manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                end
            elseif aa.manualAA == 1 then
                if ui.get(menu.aaTab.manualTab.manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                elseif ui.get(menu.aaTab.manualTab.manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                elseif ui.get(menu.aaTab.manualTab.manualLeft) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                end
            elseif aa.manualAA == 2 then
                if ui.get(menu.aaTab.manualTab.manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()
                elseif ui.get(menu.aaTab.manualTab.manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                elseif ui.get(menu.aaTab.manualTab.manualRight) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                end
            elseif aa.manualAA == 3 then
                if ui.get(menu.aaTab.manualTab.manualForward) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                elseif ui.get(menu.aaTab.manualTab.manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()
                elseif ui.get(menu.aaTab.manualTab.manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                end
            end
        end
        if aa.manualAA == 1 or aa.manualAA == 2 or aa.manualAA == 3 then
            aa.ignore = true

            if ui.get(menu.aaTab.manuals) == "Static" then
                ui.set(refs.yawJitter[1], "Off")
                ui.set(refs.yawJitter[2], 0)
                ui.set(refs.bodyYaw[1], "Static")
                ui.set(refs.bodyYaw[2], -180)

                if aa.manualAA == 1 then
                    ui.set(refs.yawBase, "local view")
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], -90)
                elseif aa.manualAA == 2 then
                    ui.set(refs.yawBase, "local view")
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], 90)
                elseif aa.manualAA == 3 then
                    ui.set(refs.yawBase, "local view")
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], 180)
                end
            elseif ui.get(menu.aaTab.manuals) == "Default" and ui.get(aaBuilder[vars.pState].enableState) then
                if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                    ui.set(refs.yawJitter[1], "Center")
                    ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft)*math.random(-1, 1)  or ui.get(aaBuilder[vars.pState].yawJitterRight)*math.random(-1, 1) ))
                else
                    ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
                    ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
                end

                ui.set(refs.bodyYaw[1], "Static")
                ui.set(refs.bodyYaw[2], -180)

                if aa.manualAA == 1 then
                    ui.set(refs.yawBase, "local view")
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], -90)
                elseif aa.manualAA == 2 then
                    ui.set(refs.yawBase, "local view")
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], 90)
                elseif aa.manualAA == 3 then
                    ui.set(refs.yawBase, "local view")
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], 180)
                end
            end
        else
            aa.ignore = false
        end
    else
        aa.ignore = false
        aa.manualAA= 0
        aa.input = 0
    end

    -- search for states
    vars.pState = 1
    if pStill then vars.pState = 2 end
    if not pStill then vars.pState = 3 end
    if isSlow then vars.pState = 4 end
    if entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 5 end
    if not pStill and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 8 end
    if not onground then vars.pState = 6 end
    if not onground and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 7 end

    if ui.get(aaBuilder[vars.pState].enableState) == false and vars.pState ~= 1 then
        vars.pState = 1
    end

    local nextAttack = entity.get_prop(vars.localPlayer, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(vars.localPlayer), "m_flNextPrimaryAttack")
    local dtActive = false
    local isFl = ui.get(ui.reference("AA", "Fake lag", "Enabled"))
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end

    -- apply antiaim set
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

            if ui.get(aaBuilder[vars.pState].pitch) ~= "Custom" then
                ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
            else
                ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
            end

            ui.set(refs.yawBase, ui.get(aaBuilder[vars.pState].yawBase))

            local switch = false
            if ui.get(aaBuilder[vars.pState].yaw) == "Slow Yaw" then
                ui.set(refs.yaw[1], "180")
                local switch_ticks = func.time_to_ticks(globals.realtime()) - current_tick
            
                if switch_ticks * 2 >= 3 then
                    switch = true
                else
                    switch = false
                end
                if switch_ticks >= 3 then
                    current_tick = func.time_to_ticks(globals.realtime())
                end
                ui.set(refs.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawRight) or ui.get(aaBuilder[vars.pState].yawLeft))
            else
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

            ui.set(refs.bodyYaw[1], ui.get(aaBuilder[vars.pState].bodyYaw))
            ui.set(refs.bodyYaw[2], (side == 1 and ui.get(aaBuilder[vars.pState].bodyYawLeft) or ui.get(aaBuilder[vars.pState].bodyYawRight)))
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
			ui.set(refs.fakeLag[1], math.random(1,3))
		elseif hsSaved then
			ui.set(refs.fakeLag[1], hsValue)
            hsSaved = false
		end
	end

    -- Avoid backstab
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
    if ( ui.get(menu.aaTab.freestandHotkey)) then
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

    -- force defensive in air
    cmd.force_defensive = (not onground and ui.get(menu.miscTab.forceDefensive)) and true or false
    
end)

local legsSaved = false
local legsTypes = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
local ground_ticks = 0
client.set_event_callback("pre_render", function()
    if not entity.get_local_player() then return end
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)

    if func.table_contains(ui.get(menu.miscTab.animations), "Static legs") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
    end

    if func.table_contains(ui.get(menu.miscTab.animations), "Leg fucker") then
        if not legsSaved then
            legsSaved = ui.get(refs.legMovement)
        end
        ui.set_visible(refs.legMovement, false)
        if func.table_contains(ui.get(menu.miscTab.animations), "Leg fucker") then
            ui.set(refs.legMovement, legsTypes[math.random(1, 3)])
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
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
local value = 0
local once1 = false
local once2 = false
local testx = 0
local dt_a = 0
local dt_y = 0
local dt_x = 0
local dt_w = 0
local os_a = 0
local os_y = 0
local os_x = 0
local os_w = 0
local fs_a = 0
local fs_y = 0
local fs_x = 0
local fs_w = 0
local n_x = 0
local n2_x = 0
local n3_x = 0
local n4_x = 0

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
client.set_event_callback("paint", function()
    local me = entity.get_local_player()
    if me == nil then return end
    local width, height = client.screen_size()
    local r2, g2, b2, a2 = 55,55,55,255
    local highlight_fraction =  (globals.realtime() / 2 % 1.2 * 2) - 1.2
    local output = ""
    local text_to_draw = " G A N G"
    for idx = 1, #text_to_draw do
        local character = text_to_draw:sub(idx, idx)
        local character_fraction = idx / #text_to_draw
        local r1, g1, b1, a1 = 255, 255, 255, 255
        local highlight_delta = (character_fraction - highlight_fraction)
        if highlight_delta >= 0 and highlight_delta <= 1.4 then
            if highlight_delta > 0.7 then
               highlight_delta = 1.4 - highlight_delta
            end
            local r_fraction, g_fraction, b_fraction, a_fraction = r2 - r1, g2 - g1, b2 - b1
            r1 = r1 + r_fraction * highlight_delta / 0.8
            g1 = g1 + g_fraction * highlight_delta / 0.8
            b1 = b1 + b_fraction * highlight_delta / 0.8
        end
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, 255, text_to_draw:sub(idx, idx))
    end
    output = "B L U H" .. output
    output = output:gsub(" ", "")
    local r,g,b,a = ui.get(menu.visualsTab.indicatorsMainClr)
    renderer.text(width - (ui.get(menu.visualsTab.watermark) == "Right" and 55 or (width-55)), height - 555, r,g,b, 255, "c", 0, output)

    local local_player = entity.get_local_player()
    local sizeX, sizeY = client.screen_size()
    local weapon = entity.get_player_weapon(local_player)
    local bodyYaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyYaw > 0 and 1 or -1
    local state = vars.intToS[vars.pState]:upper()
    local mainClr = {}
    mainClr.r, mainClr.g, mainClr.b, mainClr.a = ui.get(menu.visualsTab.indicatorsMainClr)
    local fake = math.floor(antiaim_funcs.get_desync(1))

    local arrowSize = 10

    if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Small" then
        renderer.triangle(sizeX / 2 + 48, sizeY / 2 + 2, sizeX / 2 + 37, sizeY / 2 - 5, sizeX / 2 + 37, sizeY / 2 + 9, 
        aa.manualAA == 2 and mainClr.r or 0, 
        aa.manualAA == 2 and mainClr.g or 0, 
        aa.manualAA == 2 and mainClr.b or 0, 
        aa.manualAA == 2 and math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255 or 0)

        renderer.triangle(sizeX / 2 - 48, sizeY / 2 + 2, sizeX / 2 - 37, sizeY / 2 - 5, sizeX / 2 - 37, sizeY / 2 + 9, 
        aa.manualAA == 1 and mainClr.r or 0, 
        aa.manualAA == 1 and mainClr.g or 0, 
        aa.manualAA == 1 and mainClr.b or 0, 
        aa.manualAA == 1 and math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255 or 0)

        renderer.triangle(sizeX / 2, sizeY / 2 - 30, sizeX / 2 - 7, sizeY / 2 - 20, sizeX / 2 + 7, sizeY / 2 - 20, 
        aa.manualAA == 3 and mainClr.r or 0, 
        aa.manualAA == 3 and mainClr.g or 0, 
        aa.manualAA == 3 and mainClr.b or 0, 
        aa.manualAA == 3 and math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255 or 0)
    end

    if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Default" then
        renderer.triangle(sizeX / 2 + 55, sizeY / 2 + 2, sizeX / 2 + 42, sizeY / 2 - 7, sizeX / 2 + 42, sizeY / 2 + 11, 
        aa.manualAA == 2 and mainClr.r or 25, 
        aa.manualAA == 2 and mainClr.g or 25, 
        aa.manualAA == 2 and mainClr.b or 25, 
        aa.manualAA == 2 and mainClr.a or 160)

        renderer.triangle(sizeX / 2 - 55, sizeY / 2 + 2, sizeX / 2 - 42, sizeY / 2 - 7, sizeX / 2 - 42, sizeY / 2 + 11, 
        aa.manualAA == 1 and mainClr.r or 25, 
        aa.manualAA == 1 and mainClr.g or 25, 
        aa.manualAA == 1 and mainClr.b or 25, 
        aa.manualAA == 1 and mainClr.a or 160)
    
        renderer.rectangle(sizeX / 2 + 38, sizeY / 2 - 7, 2, 18, 
        bodyYaw < -10 and mainClr.r or 25,
        bodyYaw < -10 and mainClr.g or 25,
        bodyYaw < -10 and mainClr.b or 25,
        bodyYaw < -10 and mainClr.a or 160)
        renderer.rectangle(sizeX / 2 - 40, sizeY / 2 - 7, 2, 18,			
        bodyYaw > 10 and mainClr.r or 25,
        bodyYaw > 10 and mainClr.g or 25,
        bodyYaw > 10 and mainClr.b or 25,
        bodyYaw > 10 and mainClr.a or 160)
    end

    if ui.get(menu.visualsTab.indicator) and ui.get(menu.visualsTab.indicatorsStyle) ~= "-" then
        
        if ui.get(menu.visualsTab.indicatorsStyle) == "Default" then
            local realtime = globals.realtime() % 3
            local alpha = math.floor(math.sin(realtime * 4) * (180 / 2 - 1) + 180 / 2) or 180
        
            local exp_ind = ""
        
            if is_dt then
                exp_ind = "DT"
            elseif is_os then
                exp_ind = "HS"
            end
        
            local me = entity.get_local_player()
            local wpn = entity.get_player_weapon(me)
        
            local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
            local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
            local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1
        
            local is_valid = entity.is_alive(me) and wpn ~= nil and scope_level ~= nil
            local act = is_valid and scope_level > 0 and scoped and not resume_zoom
        
            local flag = "c-"
            local ting = 0
            local testting = 0
        
            --animation shit
    
        
            if act then
                flag = "-"
                ting = 23
                testting = 11
        
                testx = func.lerp(testx, 30, globals.frametime() * 5)
        
                n2_x = func.lerp(n2_x, 11, globals.frametime() * 5)
        
                n3_x = func.lerp(n3_x, 5, globals.frametime() * 5)
        
            else
                testx = func.lerp(testx, 0, globals.frametime() * 5)
        
                n2_x = func.lerp(n2_x, 0, globals.frametime() * 5)
        
                n3_x = func.lerp(n3_x, 0, globals.frametime() * 5)
        
                flag = "c-"
                ting = 28
            end
        
            local wx, wy = client.screen_size()
            
            local is_charged = antiaim_funcs.get_double_tap()
            local is_dt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
            local is_os = ui.get(refs.os[1]) and ui.get(refs.os[2])
            local is_fs = ui.get(refs.edgeYaw)
            local is_ba = ui.get(refs.forceBaim)
            local is_sp = ui.get(refs.safePoint)
            local is_qp = ui.get(refs.quickPeek[2])      
            
            if is_dt then
                renderer.text(sizeX / 2 - 0.5, sizeY / 2 + os_y + 10, dr, dg, db, os_a, "c-", os_w, " ")
            else
                renderer.text(sizeX / 2 - 0.5, sizeY / 2 + os_y+ 10, dr, dg, db, os_a, "c-", os_w, "OS ")
            end
            renderer.text(sizeX / 2 - 0.5, sizeY / 2 + dt_y+ 10, dr, dg, db, dt_a, "c-", dt_w, "DT")
        
            local desync_type = antiaim_funcs.get_overlap(float)
            local desync_type2 = antiaim_funcs.get_desync(2)

            if is_charged then dr,dg,db,da=167, 252, 121,255 elseif is_os then dr,dg,db,da=255,255,255,255 else dr,dg,db,da=255,0,0,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end

            if is_dt then if dt_a<255 then dt_a=dt_a+5 end;if dt_w<10 then dt_w=dt_w+0.28 end;if dt_y<36 then dt_y=dt_y+1 end;if fs_x<11 then fs_x=fs_x+0.25 end elseif not is_dt then if dt_a>0 then dt_a=dt_a-5 end;if dt_w>0 then dt_w=dt_w-0.2 end;if dt_y>25 then dt_y=dt_y-1 end;if fs_x>0 then fs_x=fs_x-0.25 end end;if is_os and not is_dt then if os_a<255 then os_a=os_a+5 end;if os_w<12 then os_w=os_w+0.28 end;if os_y<36 then os_y=os_y+1 end;if fs_x<12 then fs_x=fs_x+0.5 end elseif not is_os and not is_dt then if os_a>0 then os_a=os_a-5 end;if os_w>0 then os_w=os_w-0.2 end;if os_y>25 then os_y=os_y-1 end;if fs_x>0 then fs_x=fs_x-0.5 end end;if is_fs then if fs_w<10 then fs_w=fs_w+0.35 end;if fs_a<255 then fs_a=fs_a+5 end;if dt_x>-7 then dt_x=dt_x-0.5 end;if os_x>-7 then os_x=os_x-0.5 end;if fs_y<36 then fs_y=fs_y+1 end elseif not is_fs then if fs_a>0 then fs_a=fs_a-5 end;if fs_w>0 then fs_w=fs_w-0.2 end;if dt_x<0 then dt_x=dt_x+0.5 end;if os_x<0 then os_x=os_x+0.5 end;if fs_y>25 then fs_y=fs_y-1 end end

            if is_dt or is_os then
                n4_x = func.lerp(n4_x, 8, globals.frametime() * 8)
            else
                n4_x = func.lerp(n4_x, -1, globals.frametime() * 8)
            end

            renderer.text(sizeX/2 - 28, sizeY / 2 + 25, mainClr.r, mainClr.g, mainClr.b, 255, "-", 0, 'BLUHGANG')
            renderer.text(sizeX / 2+13, sizeY / 2 + 25, 255, 161, 161, 255, "-", 0, userdata.build:upper())
            renderer.text(wx / 2-1, sizeY / 2 + 38.5 , 255,255,255, 255, "c-", 0, state)
            renderer.text(sizeX / 2-15, sizeY / 2 + 47 + n4_x, br, bg, bb, ba, "c-", 0, "BAIM")
            renderer.text(sizeX / 2, sizeY / 2 + 47 + n4_x, qr,qg,qb,qa, "c-", 0, "QP")
            renderer.text(sizeX / 2+10, sizeY / 2 + 47 + n4_x, sr, sg, sb, sa, "c-", 0, "SP")
            renderer.text(sizeX / 2+20, sizeY / 2 + 47 + n4_x, fr, fg, fb, fa, "c-", 0, "FS")
        end

        if ui.get(menu.visualsTab.indicatorsStyle) == "Long" then
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


            local dpi = ui.get(ui.reference("MISC", "Settings", "DPI scale")):gsub('%%', '') - 100
            local globalFlag = "cd-"
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
        
            local namex, namey = renderer.measure_text(globalFlag, globalFlag == "cd-" and lua_name:upper() or lua_name:lower())
            local logo = animate_text(globals.curtime(), globalFlag == "cd-" and lua_name:upper() or lua_name:lower(), mainClr.r, mainClr.g, mainClr.b, 255)

            renderer.text(sizeX/2 + ((namex + 2)/2) * scopedFraction, sizeY/2 + 20 - dpi/10, 255, 255, 255, 255, globalFlag, nil, unpack(logo))
        
            indCount = indCount + 1
            local namex, namey = renderer.measure_text(globalFlag, globalFlag == "cd-" and lua_name:upper() or lua_name:lower())
            local stateX, stateY = renderer.measure_text(globalFlag, state:upper())
            renderer.text(sizeX/2 + (stateX + 2)/2 * scopedFraction, sizeY/2 + 20 + namey/1.2, 255, 255, 255, globalFlag == "cd-" and 255 or math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255, globalFlag, 0, state:upper())
        
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
    notifications.render()
end)

ui.set_callback(menu.visualsTab.logs, function() 
    local call_back = ui.get(menu.visualsTab.logs) and client.set_event_callback or client.unset_event_callback

    call_back("aim_miss", onMiss)
    call_back("aim_hit", onHit)
    call_back("item_purchase", onPurchase)
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
    local r, g, b = ui.get(menu.visualsTab.indicatorsMainClr)
    local name = ui.get(menu.configTab.name)
    if name == "" then return end
    local protected = function()
        loadConfig(name)
    end

    if pcall(protected) then
        name = name:gsub('*', '')
        notifications.new(string.format('Successfully loaded "$%s$"', name), r, g, b)
    else
        notifications.new(string.format('Failed to load "$%s$"', name), 255, 120, 120)
    end
end)

ui.set_callback(menu.configTab.save, function()
    local r, g, b = ui.get(menu.visualsTab.indicatorsMainClr)

        local name = ui.get(menu.configTab.name)
        if name == "" then return end
    
        for i, v in pairs(presets) do
            if v.name == name:gsub('*', '') then
                notifications.new(string.format('You can`t save built-in preset "$%s$"', name:gsub('*', '')), 255, 120, 120)
                return
            end
        end

        if name:match("[^%w]") ~= nil then
            notifications.new(string.format('Failed to save "$%s$" due to invalid characters', name), 255, 120, 120)
            return
        end
    local protected = function()
        saveConfig(name)
        ui.update(menu.configTab.list, getConfigList())
    end
    if pcall(protected) then
        notifications.new(string.format('Successfully saved "$%s$"', name), r, g, b)
    end
end)

ui.set_callback(menu.configTab.delete, function()
    local name = ui.get(menu.configTab.name)
    if name == "" then return end
    local r, g, b = ui.get(menu.visualsTab.indicatorsMainClr)
    if deleteConfig(name) == false then
        notifications.new(string.format('Failed to delete "$%s$"', name), 255, 120, 120)
        ui.update(menu.configTab.list, getConfigList())
        return
    end

    for i, v in pairs(presets) do
        if v.name == name:gsub('*', '') then
            notifications.new(string.format('You can`t delete built-in preset "$%s$"', name:gsub('*', '')), 255, 120, 120)
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
        notifications.new(string.format('Successfully deleted "$%s$"', name), r, g, b)
    end
end)

ui.set_callback(menu.configTab.import, function()
    local r, g, b = ui.get(menu.visualsTab.indicatorsMainClr)

    local protected = function()
        importSettings()
    end

    if pcall(protected) then
        notifications.new(string.format('Successfully imported settings', name), r, g, b)
    else
        notifications.new(string.format('Failed to import settings', name), 255, 120, 120)
    end
end)

ui.set_callback(menu.configTab.export, function()
    local name = ui.get(menu.configTab.name)
    if name == "" then return end

    local protected = function()
        exportSettings(name)
    end
    local r, g, b = ui.get(menu.visualsTab.indicatorsMainClr)
    if pcall(protected) then
        notifications.new(string.format('Successfully exported settings', name), r, g, b)
    else
        notifications.new(string.format('Failed to export settings', name), 255, 120, 120)
    end
end)
-- @region UI_CALLBACKS end

-- @region UI_RENDER start
client.set_event_callback("paint_ui", function()
    vars.activeState = vars.sToInt[ui.get(menu.builderTab.state)]
    local isEnabled = true
    local isAATab = vars.currentTab == 2 and ui.get(tabPicker) == "Keybinds"
    local isBuilderTab = vars.currentTab == 2 and ui.get(tabPicker) == "Anti-aim"
    local isVisualsTab = vars.currentTab == 3
    local isMiscTab = vars.currentTab == 4
    local isCFGTab = vars.currentTab == 5
    ui.set_visible(aaBtn, vars.currentTab == 1 and isEnabled)
    ui.set_visible(visBtn, vars.currentTab == 1 and isEnabled)
    ui.set_visible(mscBtn, vars.currentTab == 1 and isEnabled)
    ui.set_visible(cfgBtn, vars.currentTab == 1 and isEnabled)
    ui.set_visible(backBtn, vars.currentTab ~= 1 and isEnabled)

    -- local aA = func.create_color_array(lua_color.r, lua_color.g, lua_color.b, "[$] bluhgang.lua")
    -- ui.set(label, string.format("           \a%s[\a%s$\a%s]\a%s \a%sb\a%sl\a%su\a%sh\a%sg\a%sa\a%sn\a%sg\a%s.\a%sl\a%su\a%sa", func.RGBAtoHEX(unpack(aA[1])), func.RGBAtoHEX(unpack(aA[2])), func.RGBAtoHEX(unpack(aA[3])), func.RGBAtoHEX(unpack(aA[4])), func.RGBAtoHEX(unpack(aA[5])), func.RGBAtoHEX(unpack(aA[6])),  func.RGBAtoHEX(unpack(aA[7])),  func.RGBAtoHEX(unpack(aA[8])),  func.RGBAtoHEX(unpack(aA[9])) , func.RGBAtoHEX(unpack(aA[10])) ,  func.RGBAtoHEX(unpack(aA[11])) ,  func.RGBAtoHEX(unpack(aA[12])) ,  func.RGBAtoHEX(unpack(aA[13])) ,  func.RGBAtoHEX(unpack(aA[14])) ,  func.RGBAtoHEX(unpack(aA[15])) ,  func.RGBAtoHEX(unpack(aA[16])) ) )

    for i = 1, #vars.aaStates do
        local stateEnabled = ui.get(aaBuilder[i].enableState)
        ui.set_visible(aaBuilder[i].enableState, vars.activeState == i and i ~= 1 and isBuilderTab and isEnabled)
        ui.set(aaBuilder[1].enableState, true)
        ui.set_visible(aaBuilder[i].pitch, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].pitchSlider , vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].pitch) == "Custom" and isEnabled)
        ui.set_visible(aaBuilder[i].yawBase, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off"and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitter, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterLeft, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterRight, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawLeft, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawRight, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isBuilderTab and stateEnabled and isEnabled)
    end

    for i, feature in pairs(menu.aaTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isAATab and isEnabled)
        end
	end 

    for i, feature in pairs(menu.aaTab.manualTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isAATab and isEnabled and ui.get(menu.aaTab.manuals) ~= "Off")
        end
	end 
    ui.set_visible(tabPicker, vars.currentTab == 2)
    ui.set_visible(menu.builderTab.state, isBuilderTab)

    for i, feature in pairs(menu.visualsTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isVisualsTab and isEnabled)
        end
	end 
    ui.set_visible(menu.visualsTab.indicatorsStyle, isVisualsTab and isEnabled and ui.get(menu.visualsTab.indicator))
    ui.set_visible(menu.visualsTab.arrowIndicatorStyle, isVisualsTab and isEnabled and ui.get(menu.visualsTab.arrow))

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
        ui.set(references.antiaim.legMovement, legsSaved)
    end
    func.setAATab(true)
end)