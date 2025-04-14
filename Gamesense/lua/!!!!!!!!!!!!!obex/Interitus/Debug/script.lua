-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- @region LUASETTINGS start
local lua_name = "interitus" -- CHANGE THE NAME TO YOUR DESIRED
local lua_color = {r = 222, g = 55, b = 55} -- CHANGE THE COLOR TO YOUR DESIRED
local lua_discord = "https://discord.gg/interitus" -- CHANGE THE LINK TO YOUR DESIRED
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
local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'nightly', discord=''}
local userdata = {
    username = obex_data.username == nil or obex_data.username,
    build = obex_data.build ~= nil and obex_data.build:gsub("Private", "nightly"):gsub("Debug", "dev"):gsub("Beta", "alpha"):gsub("User", "live")
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
    aaStates = {"Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Crouch-Moving", "Fakelag"},
    pStates = {"S", "M", "SW", "C", "A", "AC", "CM", "FL"},
	sToInt = {["Standing"] = 1, ["Moving"] = 2, ["Slowwalking"] = 3, ["Crouching"] = 4, ["Air"] = 5, ["Air-Crouching"] = 6, ["Crouch-Moving"] = 7, ["Fakelag"] = 8},
    intToS = {[1] = "Standing", [2] = "Moving", [3] = "Slowwalking", [4] = "Crouching", [5] = "Air", [6] = "Air-Crouching", [7] = "Crouch-Moving", [8] = "Fakelag"},
    currentTab = 1,
    activeState = 1,
    pState = 1
}
local icon = base64.decode("PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz48IS0tIFVwbG9hZGVkIHRvOiBTVkcgUmVwbywgd3d3LnN2Z3JlcG8uY29tLCBHZW5lcmF0b3I6IFNWRyBSZXBvIE1peGVyIFRvb2xzIC0tPgo8c3ZnIGZpbGw9IiNGRkZGRkYiIHdpZHRoPSI4MDBweCIgaGVpZ2h0PSI4MDBweCIgdmlld0JveD0iMCAwIDMyIDMyIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxwYXRoIGZpbGw9IiNGRkZGRkYiIGQ9Ik0gMTUuNDg2MzI4IDMgQyAxNS40ODYzMjggMyAxNS4xNzM5MjIgMTQuOTQ5NTE2IDE1LjA0NDkyMiAxOS44NTM1MTYgTCAxMy4yOTI5NjkgMTcuMjkyOTY5IEwgMTQuNDE5OTIyIDIwLjM4ODY3MiBMIDEwLjkyNzczNCAyMC44OTY0ODQgTCAxNC40MTk5MjIgMjEuNDA0Mjk3IEwgMTMuMDcwMzEyIDI0LjA0ODgyOCBMIDE0Ljk5NDE0MSAyMi4wMjkyOTcgQyAxNC44OTQxNDEgMjUuODY3Mjk3IDE0Ljg3MTA5NCAyNi44MTA1NDcgMTQuODcxMDk0IDI2LjgxMDU0NyBDIDE0Ljg3MTA5NCAyNi44MTA1NDcgNi4yNTc5MjE5IDIyLjgxMDY1NiAxMS4wNDQ5MjIgMTMuOTcyNjU2IEMgMTEuMDQ0OTIyIDEzLjk3MjY1NiA1LjA3NTQyMTkgNy4zODIwMzEyIDEwLjQ4MjQyMiAzLjMzMjAzMTIgQyAxMC40ODI0MjIgMy4zMzIwMzEyIDEuMjQ5NDIxOSA4LjkwNzQ2ODggNy4xMDc0MjE5IDE4LjQ4MDQ2OSBDIDcuMTA3NDIxOSAxOC40ODA0NjkgMi4yNjM4NzUgMTMuNzQ5NzUgNC43OTY4NzUgOC45Njg3NSBDIDQuNzk2ODc1IDguOTY4NzUgMC40MDY4MTI1IDE1LjE2MDY1NiA1Ljc1NzgxMjUgMjEuOTcyNjU2IEMgNS43NTc4MTI1IDIxLjk3MjY1NiA0LjI5NTk1MzEgMjEuMDc1NjcyIDMuMDAxOTUzMSAxNy42Mzg2NzIgQyAzLjAwMTk1MzEgMTcuNjM4NjcyIDMuOTQzNzE4NyAyNy44NjUwNDcgMTUuMzg2NzE5IDI3Ljk5ODA0NyBMIDE1LjYxNTIzNCAyNy45OTgwNDcgQyAyNy4wNTEyMzQgMjcuODY2MDQ3IDI4IDE3LjY0MDYyNSAyOCAxNy42NDA2MjUgQyAyNi42ODMgMjEuMDcxNjI1IDI1LjIxNjc5NyAyMS45NzQ2MDkgMjUuMjE2Nzk3IDIxLjk3NDYwOSBDIDMwLjU2Njc5NyAxNS4xNjI2MDkgMjYuMTc1NzgxIDguOTcwNzAzMSAyNi4xNzU3ODEgOC45NzA3MDMxIEMgMjguNzA4NzgxIDEzLjc1NzcwMyAyMy44NjUyMzQgMTguNDgyNDIyIDIzLjg2NTIzNCAxOC40ODI0MjIgQyAyOS43MjMyMzQgOC45MTQ0MjE5IDIwLjQ5MDIzNCAzLjMzNTkzNzUgMjAuNDkwMjM0IDMuMzM1OTM3NSBDIDI1Ljg5NjIzNCA3LjM5MTkzNzUgMTkuOTI3NzM0IDEzLjk3NDYwOSAxOS45Mjc3MzQgMTMuOTc0NjA5IEMgMjQuNzE0NzM0IDIyLjgxMTYwOSAxNi4xMDE1NjIgMjYuODEyNSAxNi4xMDE1NjIgMjYuODEyNSBDIDE2LjEwMTU2MiAyNi44MTI1IDE2LjA3OTUxNiAyNS44NjkyNSAxNS45Nzg1MTYgMjIuMDMxMjUgQyAxNi4yMTg1MTYgMjIuMjgyMjUgMTcuOTAyMzQ0IDI0LjA1MDc4MSAxNy45MDIzNDQgMjQuMDUwNzgxIEwgMTYuNTUyNzM0IDIxLjQwNjI1IEwgMjAuMDQ2ODc1IDIwLjg5ODQzOCBMIDE2LjU1MjczNCAyMC4zOTA2MjUgTCAxNy42Nzk2ODggMTcuMjk0OTIyIEwgMTUuOTI3NzM0IDE5Ljg1NTQ2OSBDIDE1LjgwMzczNCAxNC45NjE0NjkgMTUuNDkyMzI4IDMuMSAxNS40ODYzMjggMyB6Ii8+PC9zdmc+")

local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI = js.MyPersonaAPI, js.LobbyAPI, js.PartyListAPI, js.SteamOverlayAPI
local OpenBrowser = SteamOverlayAPI.OpenExternalBrowserURL
-- @region VARIABLES end

-- #region FUNCS start
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
local download
local function downloadFile()
	http.get(string.format("https://flagsapi.com/%s/flat/64.png", MyPersonaAPI.GetMyCountryCode()), function(success, response)
		if not success or response.status ~= 200 then
			print("couldnt fetch the flag image")
            return
		end

		download = response.body
	end)
end
downloadFile()
-- @region FUNCS end

-- @region UI_LAYOUT start
local tab, container = "AA", "Anti-aimbot angles"
local empty = ui.new_label(tab, container, " ")
local label = ui.new_label(tab, container, "INTERITUS")
local empty = ui.new_label(tab, container, " ")
local aaBtn = ui.new_button(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Anti-aim"), function() 
    vars.currentTab = 2
end)
local builderBtn = ui.new_button(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Builder"), function() 
    vars.currentTab = 3
end)
local visBtn = ui.new_button(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Visuals"), function() 
    vars.currentTab = 4
end)
local mscBtn = ui.new_button(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Misc"), function() 
    vars.currentTab = 5
end)
local cfgBtn = ui.new_button(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Configs"), function() 
    vars.currentTab = 6
end)
local menu = {
    aaTab = {
        legitAAMode = ui.new_combobox(tab, container, "Legit aa", "Opposite", "Jitter"),
        legitAAHotkey = ui.new_hotkey(tab, container, "Legit aa", true),
        freestand = ui.new_combobox(tab, container, "Freestanding", "Default", "Static"),
        freestandHotkey = ui.new_hotkey(tab, container, "Freestand", true),
        resolverMode = ui.new_combobox(tab, container, "Resolver mode", "Off", "Safe", "Risky"),
        manualLeft = ui.new_hotkey(tab, container, "> " .. func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Manual ") .. func.hex({200,200,200}) .. "left"),
        manualRight = ui.new_hotkey(tab, container, "> " .. func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Manual ") .. func.hex({200,200,200}) .. "right"),
        manualForward = ui.new_hotkey(tab, container, "> " .. func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Manual ") .. func.hex({200,200,200}) .. "forward"),
    },
    builderTab = {
        state = ui.new_combobox(tab, container, "Anti-aim state", vars.aaStates)
    },
    visualsTab = {
        indicatorsStyle = ui.new_combobox(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Ind ") .. func.hex({200,200,200}) .. "style", "-", "Short", "Long"),
        notificationIndicatorsList = ui.new_multiselect(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Logs ") .. func.hex({200,200,200}) .. "list", "Hit", "Miss", "Purchase", "Console"),
        arrowIndicatorStyle = ui.new_combobox(tab, container,  func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Arrow ") .. func.hex({200,200,200}) .. "style", "-", "Default", "Dynamic", "Teamskeet"),
        debugIndicatorsList = ui.new_multiselect(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Debug ") .. func.hex({200,200,200}) .. "indicators", "Debug panel", "Flag"),
        minDmgIndicator = ui.new_checkbox(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Min dmg ") .. func.hex({200,200,200}) .. "indicator"),
        indicatorsMainClrLabl = ui.new_label(tab, container, func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Main ") .. func.hex({200,200,200}) .. "color"),
        indicatorsMainClr = ui.new_color_picker(tab, container, "Main color", 222, 55, 55, 255),
    },
    miscTab = {
        tweaks = ui.new_multiselect(tab, container, "Tweaks", "Avoid backstab", "Fix hideshots", "Pitch flick in air", "Air tick switcher", "Force defensive in air", "Force defensive on key", "Manuals over freestanding", "Tp on low hp"),
        animations = ui.new_multiselect(tab, container, "Animations", "Static legs", "Leg fucker", "Moonwalk on ground", "Moonwalk in air", "Paralyze", "0 pitch on landing"),
        defensiveBind = {
            defensiveKey = ui.new_hotkey(tab, container, "> " .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. "Force defensive " .. func.hex({200,200,200}) .. "key"),
        },
        hpBar = {
            hpHotkey = ui.new_hotkey(tab, container, "> " .. func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Teleport ") .. func.hex({200,200,200}) .. "key"),
            hpSlider = ui.new_slider(tab, container, "> " .. func.gradient_text(lua_color.r, lua_color.g, lua_color.b, 255, lua_color.r, 155, 155, 255, "Teleport ") .. func.hex({200,200,200}) .. "hp", 1, 92, 10, true, "hp", 1),
        }
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
for i=1, #vars.aaStates do
    aaContainer[i] = func.hex({200,200,200}) .. "(" .. func.hex({222,55,55}) .. "" .. vars.pStates[i] .. "" .. func.hex({200,200,200}) .. ")" .. func.hex({155,155,155}) .. " "
    aaBuilder[i] = {
        enableState = ui.new_checkbox(tab, container, "Enable " .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({200,200,200}) .. " state"),
        antiBruteSet = ui.new_checkbox(tab, container, "Anti-Bruteforce\n" .. aaContainer[i]),
        stateDisablers = ui.new_multiselect(tab, container, "Disablers\n" .. aaContainer[i], "Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Crouch-Moving"),
        pitch = ui.new_combobox(tab, container, "Pitch\n" .. aaContainer[i], "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitchSlider = ui.new_slider(tab, container, "\nPitch add" .. aaContainer[i], -89, 89, 0, true, "°", 1),
        yawBase = ui.new_combobox(tab, container, "Yaw base\n" .. aaContainer[i], "Local view", "At targets"),
        yaw = ui.new_combobox(tab, container, "Yaw\n" .. aaContainer[i], "Off", "180", "Slow Jitter", "Spin", "Static", "180 Z", "Crosshair"),
        switchTicks = ui.new_slider(tab, container, "\nticks" .. aaContainer[i], 1, 9, 3, true, "t", 1),
        yawCondition = ui.new_combobox(tab, container, "Yaw condition\n" .. aaContainer[i], "Static", "L & R"),
        yawStatic = ui.new_slider(tab, container, "\nyaw limit" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawLeft = ui.new_slider(tab, container, "Left\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawRight = ui.new_slider(tab, container, "Right\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitter = ui.new_combobox(tab, container, "Yaw jitter\n" .. aaContainer[i], "Off", "Offset", "Center", "3-Way", "Random"),
        yawJitterCondition = ui.new_combobox(tab, container, "Yaw jitter condition\n" .. aaContainer[i], "Static", "L & R"),
        yawJitterStatic = ui.new_slider(tab, container, "\nyaw jitter limit" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterLeft = ui.new_slider(tab, container, "Left\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterRight = ui.new_slider(tab, container, "Right\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterDisablers = ui.new_multiselect(tab, container, "Jitter disablers\n" .. aaContainer[i], "Head safety", "Height advantage"),
        bodyYaw = ui.new_combobox(tab, container, "Body yaw\n" .. aaContainer[i], "Off", "Opposite", "Jitter", "Static"),
        bodyYawCondition = ui.new_combobox(tab, container, "Body yaw condition\n" .. aaContainer[i], "Static", "L & R"),
        bodyYawStatic = ui.new_slider(tab, container, "\nbody yaw limit" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        bodyYawLeft = ui.new_slider(tab, container, "Left\nbody yaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        bodyYawRight = ui.new_slider(tab, container, "Right\nbody yaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        roll = ui.new_slider(tab, container, "Roll\n" .. aaContainer[i], -45, 45, 0, true, "°"),
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

    local link

    if userdata.build == "nightly" then
        link = "https://pastebin.com/raw/smAYn3cw"
    elseif userdata.build == "dev" then
        link = "https://pastebin.com/raw/19SeP0sn"
    elseif userdata.build == "alpha" then
        link = "https://pastebin.com/raw/82Q5Dq3U"
    elseif userdata.build == "live" then
        link = "https://pastebin.com/raw/82Q5Dq3U"
    end

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

            local data = {rounding = 8, size = 4, glow = 8, time = 5}

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
            data.rounding = 0

            Offset = Offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction
            glow_module(x/2 - (strw + strw2)/2 - paddingx, y - 100 - strh/2 - paddingy - Offset, strw + strw2 + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {r, g, b, 45 * fraction}, {25,25,25,140 * fraction})
            renderer.text(x/2 + strw2/2, y - 100 - Offset, 255, 255, 255, 255 * fraction, "c", 0, string)
            renderer.line(x/2 - (strw + strw2)/2 - paddingx - 1, y - 100 + strh/2 + paddingy - Offset, x/2 + (strw + strw2)/2 + paddingx + 1, y - 100 + strh/2 + paddingy - Offset, r, g, b, 255  * fraction)
            -- renderer.text(x/2 - strw/2, y - 100 - Offset, 255, 255, 255, 255 * fraction, "cb", 0,color_text(" $interitus  ", r, g, b, a * fraction))        
        end

        for i = #to_remove, 1, -1 do
            table.remove(data, to_remove[i])
        end
    end,

    clear = function()
        data = {}
    end
}
client.delay_call(1, function()
    local r, g, b = ui.get(menu.visualsTab.indicatorsMainClr)
    notifications.new(string.format("Welcome to $" .. lua_name .. "$, %s", userdata.username), r, g, b)
end)

local function onHit(e)
    local group = vars.hitgroup_names[e.hitgroup + 1] or '?'
	local r, g, b, a = ui.get(menu.visualsTab.indicatorsMainClr)
	notifications.new(string.format("Hit %s's $%s$ for $%d$ damage ($%d$ health remaining)", entity.get_player_name(e.target), group:lower(), e.damage, entity.get_prop(e.target, 'm_iHealth')), r, g, b) 

    if func.table_contains(ui.get(menu.visualsTab.notificationIndicatorsList), "Console") then
        local baimable = (ui.get(refs.minDmg) <= entity.get_prop(e.target, 'm_iHealth') and not ui.get(refs.legit)) and { 150, 200, 60 } or { 255, 0, 0 }
        colorful_text:log(
            { { 200, 200, 200 }, { ui.get(menu.visualsTab.indicatorsMainClr) }, "[" .. lua_name .. "] " },
            { { 205, 205, 205 }, ("hit %s's "):format(entity.get_player_name(e.target)) },
            { { ui.get(menu.visualsTab.indicatorsMainClr) }, ("%s "):format(group:lower() or '?')},
            { { 205, 205, 205 }, "for " },
            { { ui.get(menu.visualsTab.indicatorsMainClr) }, ("%s"):format(e.damage) },
            { { 205, 205, 205 }, ". ( " },
            { baimable, ("%s"):format(entity.get_prop(e.target, 'm_iHealth')) },
            { { 205, 205, 205 }, " health remaining )", true }
        )
    end
end

local function onMiss(e)
    local group = vars.hitgroup_names[e.hitgroup + 1] or '?'
    local ping = math.min(999, client.real_latency() * 1000)
    local ping_col = (ping >= 100) and { 255, 0, 0 } or { 150, 200, 60 }
    local hc = math.floor(e.hit_chance + 0.5);
    local hc_col = (hc < ui.get(refs.hitChance)) and { 255, 0, 0 } or { 150, 200, 60 };
    e.reason = e.reason == "?" and "resolver" or e.reason
	notifications.new(string.format("Missed %s's $%s$ due to $%s$", entity.get_player_name(e.target), group:lower(), e.reason), 255, 120, 120)
    if func.table_contains(ui.get(menu.visualsTab.notificationIndicatorsList), "Console") then
        colorful_text:log(
            { { 200, 200, 200 }, { ui.get(menu.visualsTab.indicatorsMainClr) }, "[" .. lua_name .. "] " },
            { { 205, 205, 205 }, ("missed ") },
            { { 200, 200, 200 }, ("%s's "):format(entity.get_player_name(e.target))},
            { { 255, 0, 0 }, ("%s "):format(group:lower() or '?')},
            { { 205, 205, 205 }, "due to "},
            { { 255, 0, 0 }, ("%s "):format((e.reason)) },
            { { 205, 205, 205 }, ". [ rtt: "},
            { ping_col, ("%dms"):format(ping) },
            { { 205, 205, 205 }, " | ang: " },
            { { 255, 33, 137 }, ("%d"):format(math.floor( entity.get_prop(e.target, 'm_flPoseParameter', 11 ) * 120 - 60 )) },
            { { 205, 205, 205 }, " | hc: "},
            { hc_col, ("%d%%"):format(hc) },
            { { 205, 205, 205 }, " ]", true }
        )
    end
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

    if func.table_contains(ui.get(menu.visualsTab.notificationIndicatorsList), "Console") then

        colorful_text:log(
            { { 200, 200, 200 }, { ui.get(menu.visualsTab.indicatorsMainClr) }, "[" .. lua_name .. "] " },
            { { 205, 205, 205 }, ("%s purchased "):format(entity.get_player_name(buyer)) },
            { { 255, 0, 0 }, ("%s"):format(item) },
            { { 205, 205, 205 }, ".", true }
        )
    end
end
-- @region NOTIFICATION_ANIM end

-- @region AA_CALLBACKS start
local angle
local abftimer = globals.tickcount()
local timer = globals.tickcount()
local last_abftick = 0
local reversed = false

local function resetBrute()
	pct = 1
	start = 720
	reversed = false
end

local function KaysFunction(A,B,C)
    local d = (A-B) / A:dist(B)
    local v = C - B
    local t = v:dot(d) 
    local P = B + d:scaled(t)
    
    return P:dist(C)
end

client.set_event_callback("bullet_impact", function(e)
	local local_player = entity.get_local_player()
	local shooter = client.userid_to_entindex(e.userid)

	if not true then return end

	if not entity.is_enemy(shooter) or not entity.is_alive(local_player) then
		return
	end

	local shot_start_pos 	= vector(entity.get_prop(shooter, "m_vecOrigin"))
	shot_start_pos.z 		= shot_start_pos.z + entity.get_prop(shooter, "m_vecViewOffset[2]")
	local eye_pos			= vector(client.eye_position())
	local shot_end_pos 		= vector(e.x, e.y, e.z)
	local closest			= KaysFunction(shot_start_pos, shot_end_pos, eye_pos)

	if globals.tickcount() - abftimer < 0 then
		abftimer = globals.tickcount()
	end

	if globals.tickcount() - abftimer > 3 and closest < 70 then
        if ui.get(aaBuilder[vars.pState].antiBruteSet) then
            pct = 1
            start = 720
            abftimer = globals.tickcount()
            reversed = not reversed
            angle = client.random_int(-10,10)
            local r, g, b, a = ui.get(menu.visualsTab.indicatorsMainClr)
            notifications.new(string.format("$%s$ triggered $anti-bruteforce$ - [%s]", entity.get_player_name(shooter), angle), r, g, b)
            last_abftick = globals.tickcount()
        end
	end
end)

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
    if globals.tickcount() - last_abftick > 600 and reversed then
		resetBrute()
	end
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

    local manualsOverFs = func.table_contains(ui.get(menu.miscTab.tweaks), "Manuals over freestanding") == true and true or false

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

    -- search for states
    if pStill then vars.pState = 1 end
    if not pStill then vars.pState = 2 end
    if isSlow then vars.pState = 3 end
    if entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 4 end
    if not pStill and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 7 end
    if not onground then vars.pState = 5 end
    if not onground and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 6 end

    local nextAttack = entity.get_prop(vars.localPlayer, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(vars.localPlayer), "m_flNextPrimaryAttack")
    local dtActive = false
    local isFl = ui.get(ui.reference("AA", "Fake lag", "Enabled"))
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end

    if ui.get(aaBuilder[8].enableState) and not func.table_contains(ui.get(aaBuilder[8].stateDisablers), vars.intToS[vars.pState]) and isDt == false and isOs == false and isFl == true then
		vars.pState = 8
    end

    -- check height advantage and head safety
    local heightAdvantage = false
    local safetyAlert = false
    local enemies = entity.get_players(true)
	for i=1, #enemies do
        if entity.is_dormant(enemies[i]) then heightAlert = false sidewaysAlert = false return end
		local playerX, playerY, playerZ  = entity.get_prop(enemies[i], "m_vecOrigin")
		local playerFlags = entity.get_prop(enemies[i], "m_fFlags")
		local playerOnGround = bit.band(playerFlags, 1) ~= 0
		local lengthDistance = math.sqrt((playerX - origin.x)^2 + (playerY - origin.y)^2 + (playerZ - origin.z)^2)
		if ((playerZ + 100 < origin.z) and lengthDistance <= 300) then
			heightAdvantage = true
		else
			heightAdvantage = false
		end

        if ((bodyYaw >= 40 or bodyYaw <= -40) and func.headVisible(enemies[i])) then
			safetyAlert = true
		else
			safetyAlert = false
		end
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

            if (onground) then
                flick = globals.realtime()
            end

            if func.table_contains(ui.get(menu.miscTab.tweaks), "Pitch flick in air") and not onground and flick ~= nil then
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

            if ui.get(aaBuilder[vars.pState].yaw) == "Slow Jitter" then
                local switchTicks = ui.get(aaBuilder[vars.pState].switchTicks) ~= 4 and ui.get(aaBuilder[vars.pState].switchTicks) or 3
                ui.set(refs.yaw[1], "180")
                local switch_ticks = func.time_to_ticks(globals.realtime()) - current_tick
            
                if switch_ticks * 2 >= switchTicks then
                    switch = true

                else
                    switch = false
                end
                if switch_ticks >= switchTicks then
                    current_tick = func.time_to_ticks(globals.realtime())
                end
                if ui.get(aaBuilder[vars.pState].yawJitterCondition) == "L & R" then
                    ui.set(refs.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawRight) or ui.get(aaBuilder[vars.pState].yawLeft))
                else
                    ui.set(refs.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawStatic) or -ui.get(aaBuilder[vars.pState].yawStatic))
                end
            else
                ui.set(refs.yaw[1], ui.get(aaBuilder[vars.pState].yaw))
                if ui.get(aaBuilder[vars.pState].yawCondition) == "L & R" then
                    ui.set(refs.yaw[2],(side == 1 and ui.get(aaBuilder[vars.pState].yawLeft) or ui.get(aaBuilder[vars.pState].yawRight)))
                else
                    ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawStatic))
                end
            end


            local switch = false
            if ((func.table_contains(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "Height advantage" ) and heightAdvantage) or (func.table_contains(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "Head safety") and safetyAlert)) then
                ui.set(refs.yawJitter[1], "Off") 
            elseif ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                ui.set(refs.yawJitter[1], "Center")
            else
                ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
            end
            if ui.get(aaBuilder[vars.pState].yawJitterCondition) == "L & R" then
                if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                    ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft)*math.random(-1, 1)  or ui.get(aaBuilder[vars.pState].yawJitterRight)*math.random(-1, 1) ))
                elseif ui.get(aaBuilder[vars.pState].yawJitter) == "Slow Jitter" then
                    ui.set(refs.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawJitterRight) or ui.get(aaBuilder[vars.pState].yawJitterLeft))
                else
                    ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
                end
                
            else
                if  ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                    ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic)*math.random(-1, 1) )
                elseif ui.get(aaBuilder[vars.pState].yawJitter) == "Slow Jitter" then
                    ui.set(refs.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawJitterStatic) or -ui.get(aaBuilder[vars.pState].yawJitterStatic))
                else
                    ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic) )
                end
            end

            if ui.get(aaBuilder[vars.pState].bodyYaw) == "Jitter" then
                ui.set(refs.bodyYaw[1], "Static")
                ui.set(refs.bodyYaw[2], globals.tickcount() % 2 == 1 and 180 or -180)
            else
                ui.set(refs.bodyYaw[1], ui.get(aaBuilder[vars.pState].bodyYaw))
                if ui.get(aaBuilder[vars.pState].bodyYawCondition) == "L & R" then
                    ui.set(refs.bodyYaw[2], (side == 1 and ui.get(aaBuilder[vars.pState].bodyYawLeft) or ui.get(aaBuilder[vars.pState].bodyYawRight)))
                else
                    ui.set(refs.bodyYaw[2], ui.get(aaBuilder[vars.pState].bodyYawStatic))
                end
            end

            if reversed and ui.get(aaBuilder[vars.pState].antiBruteSet) then
                ui.set(refs.yaw[2], angle)
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
            ui.set(refs.bodyYaw[1], ui.get(menu.aaTab.legitAAMode))
            ui.set(refs.bodyYaw[2], 0)
            ui.set(refs.fsBodyYaw, true)
            ui.set(refs.edgeYaw, false)
            ui.set(refs.roll, 0)
        end
    end

    -- fix hideshots
	if func.table_contains(ui.get(menu.miscTab.tweaks), "Fix hideshots") then
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
    if func.table_contains(ui.get(menu.miscTab.tweaks), "Avoid backstab") then
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
        if ( ui.get(menu.aaTab.freestandHotkey) and ui.get(menu.aaTab.freestand)) then
            if manualsOverFs == true and aa.ignore == true then
                ui.set(refs.freeStand[2], "On hotkey")
                return
            else
                if ui.get(menu.aaTab.freestand) == "Static" then
                    ui.set(refs.yawJitter[2], 0)
                    ui.set(refs.bodyYaw[1], "Off")
                end
                ui.set(refs.freeStand[2], "Always on")
                ui.set(refs.freeStand[1], true)
            end
        else
            ui.set(refs.freeStand[1], false)
            ui.set(refs.freeStand[2], "On hotkey")
        end

    if func.table_contains(ui.get(menu.miscTab.tweaks), "Air tick switcher") then
        if not onground then
            if dtSaved == nil then
                dtSaved = ui.get(refs.dt[3])
            end
            ui.set(refs.dt[3], globals.tickcount() % 2 == 1 and "Offensive" or "Defensive")
        else
            if dtSaved ~= nil then
                ui.set(refs.dt[3], "Defensive")
            end
        end
    end

    local defensiveKey = ( (func.table_contains(ui.get(menu.miscTab.tweaks), "Force Defensive on key") and ui.get(menu.miscTab.defensiveBind.defensiveKey)) or (isDt and not onground and func.table_contains(ui.get(menu.miscTab.tweaks), "Force defensive in air")) )

    cmd.force_defensive = defensiveKey == true and true or false

    isDefensive = cmd.force_defensive == true and true or false

    if func.table_contains(ui.get(menu.miscTab.tweaks), "Tp on low hp") then
        if dtEnabled == nil then
            dtEnabled = true
        end
        local enemies = entity.get_players(true)
        local vis = false
        local health = entity.get_prop(vars.localPlayer, "m_iHealth")
        for i=1, #enemies do
            local entindex = enemies[i]
            local body_x,body_y,body_z = entity.hitbox_position(entindex, 1)
            if client.visible(body_x, body_y, body_z + 20) then
                vis = true
            end
        end	
        if vis and (health <= ui.get(menu.miscTab.hpBar.hpSlider)) and ui.get(menu.miscTab.hpBar.hpHotkey) then
            ui.set(refs.dt[1],false)
        else
            ui.set(refs.dt[1],true)
        end
    else
        if dtEnabled == true then
            ui.set(refs.dt[1], dtEnabled)
            dtEnabled = false
        end
    end
    
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

    if func.table_contains(ui.get(menu.miscTab.animations), "Leg fucker") or func.table_contains(ui.get(menu.miscTab.animations), "Moonwalk on ground") or func.table_contains(ui.get(menu.miscTab.animations), "Moonwalk in air") or func.table_contains(ui.get(menu.miscTab.animations), "Paralyze") then
        if not legsSaved then
            legsSaved = ui.get(refs.legMovement)
        end
        ui.set_visible(refs.legMovement, false)
        if func.table_contains(ui.get(menu.miscTab.animations), "Leg fucker") and not func.table_contains(ui.get(menu.miscTab.animations), "Moonwalk on ground") and not func.table_contains(ui.get(menu.miscTab.animations), "Moonwalk in air") and not func.table_contains(ui.get(menu.miscTab.animations), "Paralyze") then
            ui.set(refs.legMovement, legsTypes[math.random(1, 3)])
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
        elseif func.table_contains(ui.get(menu.miscTab.animations), "Moonwalk on ground") and not func.table_contains(ui.get(menu.miscTab.animations), "Paralyze") then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
            ui.set(refs.legMovement, "Off")
        elseif func.table_contains(ui.get(menu.miscTab.animations), "Paralyze") then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 8)
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 9)
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 10)
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 16)
            ui.set(refs.legMovement, "Off")
        end

        if not onground and func.table_contains(ui.get(menu.miscTab.animations), "Moonwalk in air") then
            local me = ent.get_local_player()
            local flags = me:get_prop("m_fFlags")
            local onground = bit.band(flags, 1) ~= 0
            local my_animlayer = me:get_anim_overlay(6) -- MOVEMENT_MOVE
            my_animlayer.weight = 1
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

client.set_event_callback("round_end", resetBrute)
client.set_event_callback("round_start", resetBrute)
client.set_event_callback("client_disconnect", function() resetBrute() notifications.clear() end)
client.set_event_callback("level_init", function() resetBrute() notifications.clear() end)
client.set_event_callback('player_connect_full', function(e) if client.userid_to_entindex(e.userid) == entity.get_local_player() then resetBrute() notifications.clear() end end)
-- @region AA_CALLBACKS end

-- @region INDICATORS start
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
local alpha = 0
local moveX = 0

local indicators = {}

local alpha = 0
local moveX = 0
local activeFraction = 0
local inactiveFraction = 0
local defensiveFraction = 0
local hideFraction = 0
local hideInactiveFraction = 0
local scopedFraction = 0

local dtPos = {y = 0}
local osPos = {y = 0}
client.set_event_callback("paint", function()
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end
    local sizeX, sizeY = client.screen_size()
    local weapon = entity.get_player_weapon(local_player)
    local bodyYaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyYaw > 0 and 1 or -1
    local state = "MOVING"
    local mainClr = {}
    mainClr.r, mainClr.g, mainClr.b, mainClr.a = ui.get(menu.visualsTab.indicatorsMainClr)
    local fake = math.floor(antiaim_funcs.get_desync(1))

    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
    local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
    local isFd = ui.get(refs.fakeDuck)
    local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    local nextAttack = entity.get_prop(local_player, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(local_player), "m_flNextPrimaryAttack")
    local dtActive = false
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end
    local isCharged = antiaim_funcs.get_double_tap()
    local isFs = ui.get(menu.aaTab.freestandHotkey)
    local isBa = ui.get(refs.forceBaim)
    local isSp = ui.get(refs.safePoint)
    local isQp = ui.get(refs.quickPeek[2])
    local isPing = ui.get(refs.ping[1]) and ui.get(refs.ping[2])

    local time = globals.frametime() * 30
    local dpi = ui.get(ui.reference("MISC", "Settings", "DPI scale")):gsub('%%', '') - 100

    local state = vars.intToS[vars.pState]:upper()

    -- anim
    local textLogo = lua_name

    local stateX, stateY = renderer.measure_text("-", "<" .. state .. ">")
    local mainX, mainY = renderer.measure_text("cdb", textLogo)
    local indX, indY = renderer.measure_text("-cd", "DT")
    local yDefault = 18
    local indCount = 0
    indY = indY - 3
    local scopeLevel = entity.get_prop(weapon, 'm_zoomLevel')
    local scoped = entity.get_prop(local_player, 'm_bIsScoped') == 1
    local resumeZoom = entity.get_prop(local_player, 'm_bResumeZoom') == 1
    local isValid = weapon ~= nil and scopeLevel ~= nil
    local act = isValid and scopeLevel > 0 and scoped and not resumeZoom

    if act then
        if scopedFraction < 1 then
            scopedFraction = func.lerp(scopedFraction, 1 + 0.1, time)
        else
            scopedFraction = 1
        end
    else
        scopedFraction = func.lerp(scopedFraction, 0, time)
    end

    local globalFlag = "cd-"
    local logoFlag = "cd-"

    local globalMoveY = 8

    local stateX, stateY = renderer.measure_text(logoFlag, "<" .. state .. ">")
    local indX, indY = renderer.measure_text(globalFlag, "DT")
    indY = indY - 3
    local yDefault = 18
    local indCount = 0


    if ui.get(menu.visualsTab.indicatorsStyle) == "Short" then
        local mainX, mainY = renderer.measure_text("cd-", lua_name:upper())
        local wmText = animate_text(globals.curtime(), lua_name:upper(), mainClr.r, mainClr.g, mainClr.b, 255)
        
        glow_module(sizeX/2 + ((mainX + 2)/2) * scopedFraction - mainX/2 + 4, sizeY/2 + 20 - dpi/10, mainX - 3, 0, 10, 0, {mainClr.r, mainClr.g, mainClr.b, 100 * math.abs(math.cos(globals.curtime()*2))}, {mainClr.r, mainClr.g, mainClr.b, 100 * math.abs(math.cos(globals.curtime()*2))})
        renderer.text(sizeX/2 + ((mainX + 2)/2) * scopedFraction, sizeY/2 + 20 - dpi/10, 0, 0, 0, 50, "cd-", nil, unpack(wmText))
        renderer.text(sizeX/2 + ((renderer.measure_text("-cd", '<' .. string.upper(state) .. '>') + 2)/2) * scopedFraction, sizeY/2 + 30 , 255, 255, 255, 255, "-cd", 0, '<' .. string.upper(state) .. '>')
    
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
        renderer.text(sizeX / 2 + ((renderer.measure_text("-cd", 'DT') + 2)/2) * scopedFraction , sizeY / 2 + dtInd.y + 13 + globalMoveY, dtClr.r, dtClr.g, dtClr.b, dtClr.a, globalFlag, dtInd.w, "DT")
    
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
        renderer.text(sizeX / 2 + ((renderer.measure_text("-cd", 'OS') + 2)/2) * scopedFraction, sizeY / 2 + osInd.y + 13 + globalMoveY, 255, 255, 255, osInd.a, globalFlag, osInd.w, "OS")

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
        renderer.text(sizeX / 2 + fsInd.x + ((renderer.measure_text("-cd", 'FS') + 2)/2) * scopedFraction, sizeY / 2 + fsInd.y + 13 + globalMoveY, 255, 255, 255, fsInd.a, globalFlag, fsInd.w, "FS")

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
        renderer.text(sizeX / 2 + ((renderer.measure_text("-cd", 'BA') + 2)/2) * scopedFraction, sizeY / 2 + baInd.y + 13 + globalMoveY, 255, 255, 255, baInd.a, globalFlag, 0, "BA")

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
        renderer.text(sizeX / 2 + ((renderer.measure_text("-cd", 'SP') + 2)/2) * scopedFraction, sizeY / 2 + spInd.y + 13 + globalMoveY, 255, 255, 255, spInd.a, globalFlag, 0, "SP")

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
        renderer.text(sizeX / 2 + ((renderer.measure_text("-cd", 'FD') + 2)/2) * scopedFraction, sizeY / 2 + fdInd.y + 13 + globalMoveY, 255, 255, 255, fdInd.a, globalFlag, 0, "FD")

        if isPing then
            psClr.a = func.lerp(psClr.a, 255, time)
            if psInd.y < yDefault + indY * indCount then
                psInd.y = func.lerp(psInd.y, yDefault + indY * indCount + 1, time)
            else
                psInd.y = yDefault + indY * indCount
            end
            indCount = indCount + 1
        elseif not isPing then 
            psClr.a = func.lerp(psClr.a, 0, time)
            psInd.y = func.lerp(psInd.y, yDefault - 5, time)
        end
        renderer.text(sizeX / 2 + ((renderer.measure_text("-cd", 'PS') + 2)/2) * scopedFraction, sizeY / 2 + psInd.y + 13 + globalMoveY, psClr.r, psClr.g, psClr.b, psClr.a, globalFlag, 0, "PS")
    elseif ui.get(menu.visualsTab.indicatorsStyle) == "Long" then
        local strike_w, strike_h = renderer.measure_text("cdb", lua_name)
        local logo = animate_text(globals.curtime(), lua_name, mainClr.r, mainClr.g, mainClr.b, 255)

        glow_module(sizeX/2 + ((strike_w + 2)/2) * scopedFraction - strike_w/2 + 4, sizeY/2 + 20 - dpi/10, strike_w - 3, 0, 10, 0, {mainClr.r, mainClr.g, mainClr.b, 100 * math.abs(math.cos(globals.curtime()*2))}, {mainClr.r, mainClr.g, mainClr.b, 100 * math.abs(math.cos(globals.curtime()*2))})
        renderer.text(sizeX/2 + ((strike_w + 2)/2) * scopedFraction, sizeY/2 + 20 - dpi/10, 255, 255, 255, 255, "cdb", nil, unpack(logo))

        local count = 0

        if isDt and dtActive and isDefensive == false then
            activeFraction = func.clamp(activeFraction + globals.frametime()/0.15, 0, 1)
            if dtPos.y < indY * count then
                dtPos.y = func.lerp(dtPos.y, indY * count + 0.1, time)
            else
                dtPos.y = indY * count
            end
            count = count + 1
        else
            activeFraction = func.clamp(activeFraction - globals.frametime()/0.15, 0, 1)
        end

        if isDt and dtActive and isDefensive then
            defensiveFraction = func.clamp(defensiveFraction + globals.frametime()/0.15, 0, 1)
            if dtPos.y < indY * count then
                dtPos.y = func.lerp(dtPos.y, indY * count + 0.1, time)
            else
                dtPos.y = indY * count
            end
            count = count + 1
        else
            defensiveFraction = func.clamp(defensiveFraction - globals.frametime()/0.15, 0, 1)
            isDefensive = false
        end

        if isDt and not dtActive then
            inactiveFraction = func.clamp(inactiveFraction + globals.frametime()/0.15, 0, 1)
            if dtPos.y < indY * count then
                dtPos.y = func.lerp(dtPos.y, indY * count + 0.1, time)
            else
                dtPos.y = indY * count
            end
            count = count + 1
        else
            inactiveFraction = func.clamp(inactiveFraction - globals.frametime()/0.15, 0, 1)
        end

        if isOs and ui.get(ui.reference("Rage", "Other", "Silent aim")) and isDt then
            hideInactiveFraction = func.clamp(hideInactiveFraction + globals.frametime()/0.15, 0, 1)
            if osPos.y < indY * count then
                osPos.y = func.lerp(osPos.y, indY * count + 0.1, time)
            else
                osPos.y = indY * count
            end
            count = count + 1
        else
            hideInactiveFraction = func.clamp(hideInactiveFraction - globals.frametime()/0.15, 0, 1)
        end

        if isOs and ui.get(ui.reference("Rage", "Other", "Silent aim")) and not isDt then
            hideFraction = func.clamp(hideFraction + globals.frametime()/0.15, 0, 1)
            if osPos.y < indY * count then
                osPos.y = func.lerp(osPos.y, indY * count + 0.1, time)
            else
                osPos.y = indY * count
            end
            count = count + 1
        else
            hideFraction = func.clamp(hideFraction - globals.frametime()/0.15, 0, 1)
        end

        local globalMarginX, globalMarginY = renderer.measure_text("-cd", "INTER")
        globalMarginY = globalMarginY - 2
        local dt_size = renderer.measure_text("-cd", "DT ")
        local ready_size = renderer.measure_text("-cd", "READY")
        renderer.text(sizeX/2 + ((dt_size + ready_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + dtPos.y, 255, 255, 255, activeFraction * 255, "-cd", dt_size + activeFraction * ready_size + 1, "DT ", "\a" .. func.RGBAtoHEX(155, 255, 155, 255 * activeFraction) .. "READY")

        local charging_size = renderer.measure_text("-cd", "CHARGING")
        local ret = animate_text(globals.curtime(), "CHARGING", 255, 100, 100, 255)
        renderer.text(sizeX/2 + ((dt_size + charging_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + dtPos.y, 255, 255, 255, inactiveFraction * 255, "-cd", dt_size + inactiveFraction * charging_size + 1, "DT ", unpack(ret))

        local defensive_size = renderer.measure_text("-cd", "DEFENSIVE")
        local def = animate_text(globals.curtime(), "DEFENSIVE", mainClr.r, mainClr.g, mainClr.b, 255)
        renderer.text(sizeX/2 + ((dt_size + defensive_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + dtPos.y, 255, 255, 255, defensiveFraction * 255, "-cd", dt_size + defensiveFraction * defensive_size + 1, "DT ", unpack(def))

        local hide_size = renderer.measure_text("-cd", "OSAA ")
        local active_size = renderer.measure_text("-cd", "ACTIVE")
        renderer.text(sizeX/2 + ((hide_size + active_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + osPos.y, 255, 255, 255, hideFraction * 255, "-cd", hide_size + hideFraction * active_size + 1, "OSAA ", "\a" .. func.RGBAtoHEX(155, 255, 155, 255 * hideFraction) .. "ACTIVE")
        
        local inactive_size = renderer.measure_text("-cd", "INACTIVE")
        local osin = animate_text(globals.curtime(), "INACTIVE", 255, 100, 100, 255)
        renderer.text(sizeX/2 + ((hide_size + inactive_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + osPos.y, 255, 255, 255, hideInactiveFraction * 255, "-cd", hide_size + hideInactiveFraction * inactive_size + 1, "OSAA ", unpack(osin))
    
        local state_size = renderer.measure_text("-cd", '<' .. string.upper(state) .. '>')
        renderer.text(sizeX/2 + ((state_size + 2)/2) * scopedFraction, sizeY/2 + 30 , 255, 255, 255, 255, "-cd", 0, '<' .. string.upper(state) .. '>')
    end
    
    if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Default" then
        renderer.triangle(sizeX / 2 + 50, sizeY / 2 + 2, sizeX / 2 + 37 , sizeY / 2 - 7, sizeX / 2 + 37, sizeY / 2 + 11, 
        aa.manualAA == 2 and mainClr.r or 0, 
        aa.manualAA == 2 and mainClr.g or 0, 
        aa.manualAA == 2 and mainClr.b or 0, 
        aa.manualAA == 2 and math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255 or 0)

        renderer.triangle(sizeX / 2 - 50 , sizeY / 2 + 2, sizeX / 2 - 37, sizeY / 2 - 7, sizeX / 2 - 37, sizeY / 2 + 11, 
        aa.manualAA == 1 and mainClr.r or 0, 
        aa.manualAA == 1 and mainClr.g or 0, 
        aa.manualAA == 1 and mainClr.b or 0, 
        aa.manualAA == 1 and math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255 or 0)

        renderer.triangle(sizeX / 2 , sizeY / 2 - 35, sizeX / 2 - 10, sizeY / 2 - 20, sizeX / 2 + 10, sizeY / 2 - 20, 
        aa.manualAA == 3 and mainClr.r or 0, 
        aa.manualAA == 3 and mainClr.g or 0, 
        aa.manualAA == 3 and mainClr.b or 0, 
        aa.manualAA == 3 and math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255 or 0)
    end

    if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Dynamic" then
        if speed ~= nil then
            renderer.triangle(sizeX / 2 + 25 - speed/10 + 35, sizeY / 2 + 2, sizeX / 2 + 37 - speed/10 + 35, sizeY / 2 - 7, sizeX / 2 + 37 - speed/10 + 35, sizeY / 2 + 11, 
            aa.manualAA == 2 and mainClr.r or 25, 
            aa.manualAA == 2 and mainClr.g or 25, 
            aa.manualAA == 2 and mainClr.b or 25, 
            aa.manualAA == 2 and mainClr.a or 160)
    
            renderer.triangle(sizeX / 2 - 25 + speed/10 - 35, sizeY / 2 + 2, sizeX / 2 - 37 + speed/10 - 35, sizeY / 2 - 7, sizeX / 2 - 37 + speed/10 - 35, sizeY / 2 + 11, 
            aa.manualAA == 1 and mainClr.r or 25, 
            aa.manualAA == 1 and mainClr.g or 25, 
            aa.manualAA == 1 and mainClr.b or 25, 
            aa.manualAA == 1 and mainClr.a or 160)
            
            renderer.rectangle(sizeX / 2 + 38 - speed/10 + 35, sizeY / 2 - 7, 2, 18, 
            bodyYaw < -10 and mainClr.r or 25,
            bodyYaw < -10 and mainClr.g or 25,
            bodyYaw < -10 and mainClr.b or 25,
            bodyYaw < -10 and mainClr.a or 160)
            renderer.rectangle(sizeX / 2 - 40 + speed/10 - 35, sizeY / 2 - 7, 2, 18,			
            bodyYaw > 10 and mainClr.r or 25,
            bodyYaw > 10 and mainClr.g or 25,
            bodyYaw > 10 and mainClr.b or 25,
            bodyYaw > 10 and mainClr.a or 160)
        end
    end

    if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Teamskeet" then
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

    if func.table_contains(ui.get(menu.visualsTab.debugIndicatorsList), "Debug panel")  then
        local threat = tostring(entity.get_player_name(client.current_threat()))
        local marginX, marginY = renderer.measure_text("-d", "DEBUG")
        local moveY = -30
        
        func.render_text(5, sizeY/2 + moveY, {255, 255, 255, 255, "INTERITUS.RED  -  "}, {mainClr.r, mainClr.g, mainClr.b, 255, userdata.username:upper()})
        func.render_text(5, sizeY/2 + moveY + marginY * 1, {255, 255, 255, 255, "BUILD:  "}, {mainClr.r, mainClr.g, mainClr.b, math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255, userdata.build:upper()})
        func.render_text(5, sizeY/2 + moveY + marginY * 2, {255, 255, 255, 255, "DESYNC DELTA:  "}, {mainClr.r, mainClr.g, mainClr.b, 255, math.floor(antiaim_funcs.get_desync(2)) .. "°"})
        func.render_text(5, sizeY/2 + moveY + marginY * 3, {255, 255, 255, 255, "PLAYER STATE:  "}, {mainClr.r, mainClr.g, mainClr.b, 255, state})
        func.render_text(5, sizeY/2 + moveY + marginY * 4, {255, 255, 255, 255, "CURRENT THREAT:  "}, {mainClr.r, mainClr.g, mainClr.b, 255, threat:upper()})
    end
    
    if func.table_contains(ui.get(menu.visualsTab.debugIndicatorsList), "Flag") and download then
        local flagimg = renderer.load_png(download, 25, 15)
        if flagimg ~= nil and download ~= nil then
            local mainY = 35
            local marginX, marginY = renderer.measure_text("-d", "INTERITUS.RED")
            renderer.gradient(2.5, sizeY/2 + mainY - 2, marginX*2, marginY*2 - 1, mainClr.r, mainClr.g, mainClr.b, 255, mainClr.r, mainClr.g, mainClr.b, 0, true)
            renderer.texture(flagimg, 5, sizeY/2 + mainY - 3.2, 25, marginY*2.2, 255, 255, 255, 255, "f")
            renderer.text(33, sizeY/2 - 2 + mainY, 255, 255, 255, 255, "-d", nil, "INTERITUS" .. func.hex({mainClr.r, mainClr.g, mainClr.b}) .. ".RED")
            renderer.text(33, sizeY/2 - 4 + marginY + mainY, 255, 255, 255, 255, "-d", nil, func.hex({mainClr.r, mainClr.g, mainClr.b}) .. "[" .. userdata.build:upper() .. "]")
        else
            downloadFile()
        end
    end

    if ui.get(menu.visualsTab.minDmgIndicator) and entity.get_classname(weapon) ~= "CKnife" and ui.get(refs.dmgOverride[1]) and ui.get(refs.dmgOverride[2]) then
        local dmg = ui.get(refs.dmgOverride[3])
        renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, dmg)
    end

    notifications.render()
end)

ui.set_callback(menu.visualsTab.notificationIndicatorsList, function() 
    local setHit = func.table_contains(ui.get(menu.visualsTab.notificationIndicatorsList), "Hit") and client.set_event_callback or client.unset_event_callback
    setHit("aim_hit", onHit)

    local setMiss = func.table_contains(ui.get(menu.visualsTab.notificationIndicatorsList), "Miss") and client.set_event_callback or client.unset_event_callback
    setMiss("aim_miss", onMiss)

    local setPurchase = func.table_contains(ui.get(menu.visualsTab.notificationIndicatorsList), "Purchase") and client.set_event_callback or client.unset_event_callback
    setPurchase("item_purchase", onPurchase) 
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
    local isAATab = vars.currentTab == 2
    local isBuilderTab = vars.currentTab == 3
    local isVisualsTab = vars.currentTab == 4
    local isMiscTab = vars.currentTab == 5
    local isCFGTab = vars.currentTab == 6
    ui.set_visible(aaBtn, vars.currentTab == 1 and isEnabled)
    ui.set_visible(builderBtn, vars.currentTab == 1 and isEnabled)
    ui.set_visible(visBtn, vars.currentTab == 1 and isEnabled)
    ui.set_visible(mscBtn, vars.currentTab == 1 and isEnabled)
    ui.set_visible(cfgBtn, vars.currentTab == 1 and isEnabled)
    ui.set_visible(backBtn, vars.currentTab ~= 1 and isEnabled)

    local aA = func.create_color_array(222, 55, 55, "INTERITUS")
    ui.set(label, string.format("\a%sI\a%sN\a%sT\a%sE\a%sR\a%sI\a%sT\a%sU\a%sS", func.RGBAtoHEX(unpack(aA[1])), func.RGBAtoHEX(unpack(aA[2])), func.RGBAtoHEX(unpack(aA[3])), func.RGBAtoHEX(unpack(aA[4])), func.RGBAtoHEX(unpack(aA[5])), func.RGBAtoHEX(unpack(aA[6])),  func.RGBAtoHEX(unpack(aA[7])),  func.RGBAtoHEX(unpack(aA[8])),  func.RGBAtoHEX(unpack(aA[9])) ) )

    for i = 1, #vars.aaStates do
        local stateEnabled = ui.get(aaBuilder[i].enableState)
        ui.set_visible(aaBuilder[i].enableState, vars.activeState == i and isBuilderTab and isEnabled)
        ui.set_visible(aaBuilder[i].stateDisablers, vars.activeState == 8 and i == 8 and isBuilderTab and ui.get(aaBuilder[8].enableState) and isEnabled)
        ui.set_visible(aaBuilder[i].pitch, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].pitchSlider , vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].pitch) == "Custom" and isEnabled)
        ui.set_visible(aaBuilder[i].yawBase, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].switchTicks, vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].yaw) == "Slow Jitter" and isEnabled)
        ui.set_visible(aaBuilder[i].yawCondition, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "Static" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "L & R" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "L & R" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitter, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterCondition, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterStatic, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "Static" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterLeft, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "L & R" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterRight, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "L & R" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterDisablers, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawCondition, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawStatic, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYawCondition) == "Static" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawLeft, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYawCondition) == "L & R" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawRight, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYawCondition  ) == "L & R" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].antiBruteSet, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled )
        ui.set_visible(aaBuilder[i].roll, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
    end

    for i, feature in pairs(menu.builderTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isBuilderTab and isEnabled)
        end
	end 

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

    for i, feature in pairs(menu.miscTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isMiscTab and isEnabled)
        end
	end

    for i, feature in pairs(menu.miscTab.defensiveBind) do
        ui.set_visible(feature, isMiscTab and func.table_contains(ui.get(menu.miscTab.tweaks), "Force defensive on key") and isEnabled)
	end

    for i, feature in pairs(menu.miscTab.hpBar) do
        ui.set_visible(feature, isMiscTab and func.table_contains(ui.get(menu.miscTab.tweaks), "Tp on low hp") and isEnabled)
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
        ui.set(refs.dt[3], "Defensive")
    end
    func.setAATab(true)
end)