-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
--[[
regionlist: -DEPENDENCIES
            -USER_DATA
            -REFERENCES
            -VARIABLES
            -FUNCS
            -UI_LAYOUT
            -ANTIBF_CALLBACKS
            -AA_CALLBACKS
            -NOTIFICATION_ANIM
            -IND_CALLBACKS
            -UI_RENDER
]]

-- #region DEPENDENCIES start
local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI = js.MyPersonaAPI, js.LobbyAPI, js.PartyListAPI, js.SteamOverlayAPI
local OpenBrowser = SteamOverlayAPI.OpenExternalBrowserURL

local images = require("gamesense/images") or error ("Download images library: https://gamesense.pub/forums/viewtopic.php?id=22917")
local base64 = require("gamesense/base64") or error ("Download base64 encode/decode library: https://gamesense.pub/forums/viewtopic.php?id=21619")
local bit = require("bit")
local antiaim_funcs = require("gamesense/antiaim_funcs") or error("Download anti-aim functions library: https://gamesense.pub/forums/viewtopic.php?id=29665")
local ffi = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)
local vector = require("vector") or error("Missing vector",2)
local http = require("gamesense/http") or error("Download HTTP library: https://gamesense.pub/forums/viewtopic.php?id=21619")
local clipboard = require("gamesense/clipboard") or error("Download clipboard API: https://gamesense.pub/forums/viewtopic.php?id=28678")
local ent = require("gamesense/entity")
-- #region DEPENDENCIES end

-- #region USER_DATA start
local interitus = {}
local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'nightly', discord=''}
local userdata = {
    username = obex_data.username == nil or obex_data.username,
    build = obex_data.build ~= nil and obex_data.build:gsub("Private", "nightly"):gsub("Debug", "dev"):gsub("Beta", "alpha"):gsub("User", "live")
}

interitus.database = {
    configs = ":interitus-red::configs:"
}
local presets = {}
-- #region USER_DATA end

-- #region REFERENCES start
local references = {
    rage = {
        fakeDuck = ui.reference("RAGE", "Other", "Duck peek assist"),
        minDmg = ui.reference("RAGE", "Aimbot", "Minimum damage"),
        hitChance = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
        safePoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
        quickPeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
        dmgOverride = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
        dt = {ui.reference("RAGE", "Aimbot", "Double tap")}
    },
    legit = {
        enabled = ui.reference("LEGIT", "Aimbot", "Enabled"),
    },
    antiaim = {
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
        legMovement = ui.reference("AA", "Other", "Leg movement")
    },
    visuals = {
        indicators = {ui.reference("VISUALS", "Other ESP", "Feature indicators")}
    },
    misc = {
        ping = {ui.reference("MISC", "Miscellaneous", "Ping spike")},
        dtholdaim = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks_holdaim")
    }
}
-- #region REFERENCES end

-- #region VARIABLES start
local vars = {
    localPlayer = 0,
    hitgroup_names = { 'Generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', '?', 'Gear' },
    aaStates = {"Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Crouch-Moving", "Fakelag"},
    pStates = {"S", "M", "SW", "C", "A", "AC", "CM", "FL"},
	sToInt = {["Standing"] = 1, ["Moving"] = 2, ["Slowwalking"] = 3, ["Crouching"] = 4, ["Air"] = 5, ["Air-Crouching"] = 6, ["Crouch-Moving"] = 7, ["Fakelag"] = 8},
    intToS = {[1] = "Standing", [2] = "Moving", [3] = "Slowwalking", [4] = "Crouching", [5] = "Air", [6] = "Air-Crouching", [7] = "Crouch-Moving", [8] = "Fakelag"},
    activeState = 1,
    pState = 1
}
-- #region VARIABLES end

-- #region FUNCS start
local func = {
    encrypt = function(str, key)
        local encoded = ""
        for i=1, #str do
            encoded = encoded .. string.char((string.byte(str:sub(i,i))+string.byte(key:sub((i-1) % #key + 1,(i-1) % #key + 1)))%256)
        end
        return encoded
    end,
    decrypt = function(str, key)
        local decoded = ""
        for i=1, #str do
            decoded = decoded .. string.char((string.byte(str:sub(i,i))-string.byte(key:sub((i-1) % #key + 1,(i-1) % #key + 1))+256)%256)
        end
        return decoded
    end,
    render_text = function(x, y, ...)
        local x_offset = 0
        
        local args = {...}
    
        for i, line in pairs(args) do
            local r, g, b, a, text = unpack(line)
            local size = vector(renderer.measure_text("-d", text))
            renderer.text(x + x_offset, y, r, g, b, a, "-d", 0, text)
            x_offset = x_offset + size.x
        end
    end,
    FPSTable = function()
        local Fps_Table = { }
        Fps_Table[0] = "Off"
        for i = 1, 100 do
            Fps_Table[0+i] = 0+i .. "fps"
        end
        return Fps_Table
    end,
    collect_keys = function(tbl)
        local keys = {}
        for _,v in next, tbl do
            table.insert(keys, _)
        end
        return keys
    end,
    create_lookup_table = function(tbl)
        local result = { }
        for name, weapon_ids in pairs(tbl) do
            for i = 1, #weapon_ids do
                result[weapon_ids[i]] = name
            end
        end
        return result
    end,
    angle_to_vec = function(pitch, yaw)
        local pitch_rad, yaw_rad = DEG_TO_RAD * pitch, DEG_TO_RAD * yaw
        local sp, cp, sy, cy = math.sin(pitch_rad), math.cos(pitch_rad), math.sin(yaw_rad), math.cos(yaw_rad)
        return cp * cy, cp * sy, -sp
    end,
    vec3_normalize = function(x, y, z)
        local len = math.sqrt(x * x + y * y + z * z)
        if len == 0 then
            return 0, 0, 0
        end
        local r = 1 / len
        return x * r, y * r, z * r
    end,
    vec3_dot = function(ax, ay, az, bx, by, bz)
        return ax * bx + ay * by + az * bz
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
    calculate_fov_to_player = function(ent, lx, ly, lz, fx, fy, fz)
        local px, py, pz = entity.get_prop(ent, "m_vecOrigin")
        local dx, dy, dz = funcs.vec3_normalize(px - lx, py - ly, lz - lz)
        local dot_product = funcs.vec3_dot(dx, dy, dz, fx, fy, fz)
        local cos_inverse = math.acos(dot_product)
        return RAD_TO_DEG * cos_inverse
    end,
    get_closest_player_to_crosshair = function(lx, ly, lz, pitch, yaw)
        local fx, fy, fz = funcs.angle_to_vec(pitch, yaw)
        local enemy_players = entity.get_players(true)
        local nearest_player = nil
        local nearest_player_fov = math.huge
        for i = 1, #enemy_players do
            local enemy_ent = enemy_players[i]
            local fov_to_player = funcs.calculate_fov_to_player(enemy_ent, lx, ly, lz, fx, fy, fz)
            if fov_to_player <= nearest_player_fov then
                nearest_player = enemy_ent
                nearest_player_fov = fov_to_player
            end
        end
        return nearest_player, nearest_player_fov
    end,
    getNearestEnemy = function()
        local enemy_players = entity.get_players(true)
        if #enemy_players ~= 0 then
            local own_x, own_y, own_z = client.eye_position()
            local own_pitch, own_yaw = client.camera_angles()
            local closest_enemy = nil
            local closest_distance = 999999999       
            for i = 1, #enemy_players do
                local enemy = enemy_players[i]
                local enemy_x, enemy_y, enemy_z = entity.hitbox_position(enemy, 0)        
                local x = enemy_x - own_x
                local y = enemy_y - own_y
                local z = enemy_z - own_z 
                local yaw = ((math.atan2(y, x) * 180 / math.pi))
                local pitch = -(math.atan2(z, math.sqrt(math.pow(x, 2) + math.pow(y, 2))) * 180 / math.pi)
                local yaw_dif = math.abs(own_yaw % 360 - yaw % 360) % 360
                local pitch_dif = math.abs(own_pitch - pitch ) % 360
                if yaw_dif > 180 then 
                    yaw_dif = 360 - yaw_dif 
                end
                local real_dif = math.sqrt(math.pow(yaw_dif, 2) + math.pow(pitch_dif, 2))
                if closest_distance > real_dif then
                    closest_distance = real_dif
                    closest_enemy = enemy
                end
            end
            if closest_enemy ~= nil then
                return closest_enemy, closest_distance
            end
        end
        return nil, nil
    end,
    setAATab = function(ref)
        ui.set_visible(references.antiaim.enabled, ref)
        ui.set_visible(references.antiaim.pitch[1], ref)
        ui.set_visible(references.antiaim.pitch[2], ref)
        ui.set_visible(references.antiaim.roll, ref)
        ui.set_visible(references.antiaim.yawBase, ref)
        ui.set_visible(references.antiaim.yaw[1], ref)
        ui.set_visible(references.antiaim.yaw[2], ref)
        ui.set_visible(references.antiaim.yawJitter[1], ref)
        ui.set_visible(references.antiaim.yawJitter[2], ref)
        ui.set_visible(references.antiaim.bodyYaw[1], ref)
        ui.set_visible(references.antiaim.bodyYaw[2], ref)
        ui.set_visible(references.antiaim.freeStand[1], ref)
        ui.set_visible(references.antiaim.freeStand[2], ref)
        ui.set_visible(references.antiaim.fsBodyYaw, ref)
        ui.set_visible(references.antiaim.edgeYaw, ref)
    end,
    findDist = function (x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end,
    resetAATab = function()
        ui.set(references.antiaim.enabled, false)
        ui.set(references.antiaim.pitch[1], "off")
        ui.set(references.antiaim.pitch[2], 0)
        ui.set(references.antiaim.roll, 0)
        ui.set(references.antiaim.yawBase, "local view")
        ui.set(references.antiaim.yaw[1], "off")
        ui.set(references.antiaim.yaw[2], 0)
        ui.set(references.antiaim.yawJitter[1], "off")
        ui.set(references.antiaim.yawJitter[2], 0)
        ui.set(references.antiaim.bodyYaw[1], "off")
        ui.set(references.antiaim.bodyYaw[2], 0)
        ui.set(references.antiaim.freeStand[2], 0)
        ui.set(references.antiaim.fsBodyYaw, false)
        ui.set(references.antiaim.edgeYaw, false)
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
    textArray = function(string)
        local result = {}
        for i=1, #string do
            result[i] = string.sub(string, i, i)
        end
        return result
    end,
    create_color_array = function(r, g, b, string)
        local colors = {}
        for i = 0, #string do
            local color = {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + i * 5 / 30))}
            table.insert(colors, color)
        end
        return colors
    end,
    RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
        return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
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

local color_text = function( string, r, g, b, a)
    local accent = "\a" .. func.RGBAtoHEX(r, g, b, a)
    local white = "\a" .. func.RGBAtoHEX(255, 255, 255, a)

    local str = ""
    for i, s in ipairs(func.split(string, "$")) do
        str = str .. (i % 2 ==( string:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
    end

    return str
end

local glow_module = function(x, y, w, h, width, rounding, accent, accent_inner)
    local thickness = 1
    local offset = 1
    local r, g, b, a = unpack(accent)
    if accent_inner then
        func.rec(x, y, w, h + 1, rounding, accent_inner)
        --renderer.blur(x , y, w, h)
        --m_render.rec_outline(x + width*thickness - width*thickness, y + width*thickness - width*thickness, w - width*thickness*2 + width*thickness*2, h - width*thickness*2 + width*thickness*2, color(r, g, b, 255), rounding, thickness)
    end
    for k = 0, width do
        if a * (k/width)^(1) > 5 then
            local accent = {r, g, b, a * (k/width)^(2)}
            func.rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
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
local icon = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz48IS0tIFVwbG9hZGVkIHRvOiBTVkcgUmVwbywgd3d3LnN2Z3JlcG8uY29tLCBHZW5lcmF0b3I6IFNWRyBSZXBvIE1peGVyIFRvb2xzIC0tPgo8c3ZnIGZpbGw9IiNGRkZGRkYiIHdpZHRoPSI4MDBweCIgaGVpZ2h0PSI4MDBweCIgdmlld0JveD0iMCAwIDMyIDMyIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxwYXRoIGZpbGw9IiNGRkZGRkYiIGQ9Ik0gMTUuNDg2MzI4IDMgQyAxNS40ODYzMjggMyAxNS4xNzM5MjIgMTQuOTQ5NTE2IDE1LjA0NDkyMiAxOS44NTM1MTYgTCAxMy4yOTI5NjkgMTcuMjkyOTY5IEwgMTQuNDE5OTIyIDIwLjM4ODY3MiBMIDEwLjkyNzczNCAyMC44OTY0ODQgTCAxNC40MTk5MjIgMjEuNDA0Mjk3IEwgMTMuMDcwMzEyIDI0LjA0ODgyOCBMIDE0Ljk5NDE0MSAyMi4wMjkyOTcgQyAxNC44OTQxNDEgMjUuODY3Mjk3IDE0Ljg3MTA5NCAyNi44MTA1NDcgMTQuODcxMDk0IDI2LjgxMDU0NyBDIDE0Ljg3MTA5NCAyNi44MTA1NDcgNi4yNTc5MjE5IDIyLjgxMDY1NiAxMS4wNDQ5MjIgMTMuOTcyNjU2IEMgMTEuMDQ0OTIyIDEzLjk3MjY1NiA1LjA3NTQyMTkgNy4zODIwMzEyIDEwLjQ4MjQyMiAzLjMzMjAzMTIgQyAxMC40ODI0MjIgMy4zMzIwMzEyIDEuMjQ5NDIxOSA4LjkwNzQ2ODggNy4xMDc0MjE5IDE4LjQ4MDQ2OSBDIDcuMTA3NDIxOSAxOC40ODA0NjkgMi4yNjM4NzUgMTMuNzQ5NzUgNC43OTY4NzUgOC45Njg3NSBDIDQuNzk2ODc1IDguOTY4NzUgMC40MDY4MTI1IDE1LjE2MDY1NiA1Ljc1NzgxMjUgMjEuOTcyNjU2IEMgNS43NTc4MTI1IDIxLjk3MjY1NiA0LjI5NTk1MzEgMjEuMDc1NjcyIDMuMDAxOTUzMSAxNy42Mzg2NzIgQyAzLjAwMTk1MzEgMTcuNjM4NjcyIDMuOTQzNzE4NyAyNy44NjUwNDcgMTUuMzg2NzE5IDI3Ljk5ODA0NyBMIDE1LjYxNTIzNCAyNy45OTgwNDcgQyAyNy4wNTEyMzQgMjcuODY2MDQ3IDI4IDE3LjY0MDYyNSAyOCAxNy42NDA2MjUgQyAyNi42ODMgMjEuMDcxNjI1IDI1LjIxNjc5NyAyMS45NzQ2MDkgMjUuMjE2Nzk3IDIxLjk3NDYwOSBDIDMwLjU2Njc5NyAxNS4xNjI2MDkgMjYuMTc1NzgxIDguOTcwNzAzMSAyNi4xNzU3ODEgOC45NzA3MDMxIEMgMjguNzA4NzgxIDEzLjc1NzcwMyAyMy44NjUyMzQgMTguNDgyNDIyIDIzLjg2NTIzNCAxOC40ODI0MjIgQyAyOS43MjMyMzQgOC45MTQ0MjE5IDIwLjQ5MDIzNCAzLjMzNTkzNzUgMjAuNDkwMjM0IDMuMzM1OTM3NSBDIDI1Ljg5NjIzNCA3LjM5MTkzNzUgMTkuOTI3NzM0IDEzLjk3NDYwOSAxOS45Mjc3MzQgMTMuOTc0NjA5IEMgMjQuNzE0NzM0IDIyLjgxMTYwOSAxNi4xMDE1NjIgMjYuODEyNSAxNi4xMDE1NjIgMjYuODEyNSBDIDE2LjEwMTU2MiAyNi44MTI1IDE2LjA3OTUxNiAyNS44NjkyNSAxNS45Nzg1MTYgMjIuMDMxMjUgQyAxNi4yMTg1MTYgMjIuMjgyMjUgMTcuOTAyMzQ0IDI0LjA1MDc4MSAxNy45MDIzNDQgMjQuMDUwNzgxIEwgMTYuNTUyNzM0IDIxLjQwNjI1IEwgMjAuMDQ2ODc1IDIwLjg5ODQzOCBMIDE2LjU1MjczNCAyMC4zOTA2MjUgTCAxNy42Nzk2ODggMTcuMjk0OTIyIEwgMTUuOTI3NzM0IDE5Ljg1NTQ2OSBDIDE1LjgwMzczNCAxNC45NjE0NjkgMTUuNDkyMzI4IDMuMSAxNS40ODYzMjggMyB6Ii8+PC9zdmc+"
icon = base64.decode(icon)
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
-- #region FUNCS end

-- #region UI_LAYOUT start
local layout = {
    tab = {
        aa = "AA"
    },
    container = {
        antiaim = "Anti-aimbot angles",
        fakelag = "Fake lag"
    }
}
local prefix = func.hex({55,55,55}) .. "[" .. func.hex({222,55,55}) .. "interitus.red" .. func.hex({55,55,55}) .. "]" .. func.hex({200,200,200}) .. " "
local arrow = func.hex({222,55,55}) .. "» " .. func.hex({200,200,200}) .. " "
local menu = {
    information = {
        discord = ui.new_button(layout.tab.aa, layout.container.fakelag, func.hex({200,200,200}) .. "Join " .. func.hex({222,55,55}) .. "INTERITUS.RED" .. func.hex({200,200,200}) .. " Server", function() OpenBrowser("https://discord.gg/interitus") end)
    },
    masterSwitch = ui.new_checkbox(layout.tab.aa, layout.container.antiaim, "Enable " .. func.hex({222,55,55}) .. "interitus.red"),
    items = {
        tabPicker = ui.new_combobox(layout.tab.aa, layout.container.antiaim, prefix .. "Select tab", "Anti-aim", "Visuals", "Misc", "Config"),
        aaTab = {
            legitAAMode = ui.new_combobox(layout.tab.aa, layout.container.antiaim, arrow .. "Legit AA", "Opposite", "Jitter"),
            legitAAHotkey = ui.new_hotkey(layout.tab.aa, layout.container.antiaim, arrow .. "Legit AA", true),
            freestand = ui.new_combobox(layout.tab.aa, layout.container.antiaim, arrow .. "Freestanding", "Default", "Static"),
            freestandHotkey = ui.new_hotkey(layout.tab.aa, layout.container.antiaim, "Freestand", true),
            state = ui.new_combobox(layout.tab.aa, layout.container.antiaim, arrow .. "Antiaim state", "Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Crouch-Moving", "Fakelag")
        },
        visualsTab = {
            indicatorsMainClrLabl = ui.new_label(layout.tab.aa, layout.container.antiaim, "» " .. func.hex({222,55,55}) .. "Main " .. func.hex({200,200,200}) .. "color"),
            indicatorsMainClr = ui.new_color_picker(layout.tab.aa, layout.container.antiaim, "main color", 222, 55, 55, 255),
            indicatorsStyle = ui.new_combobox(layout.tab.aa, layout.container.antiaim, arrow .. "Indicators", "Off", "New"),
            notificationIndicatorsList = ui.new_multiselect(layout.tab.aa, layout.container.antiaim, arrow .. "Notification list", "Hit", "Miss", "Purchase", "Console"),
            arrowIndicators = ui.new_combobox(layout.tab.aa, layout.container.antiaim, arrow .. "Arrow indicators", "Off", "Default", "Dynamic", "Teamskeet"),
            debugIndicatorsList = ui.new_multiselect(layout.tab.aa, layout.container.antiaim, arrow .. "Debug indicators", "Debug panel", "Flag"),
            minDmgIndicator = ui.new_checkbox(layout.tab.aa, layout.container.antiaim, arrow .. "Minimum damage indicator")
        },
        miscTab = {
            tweaks = ui.new_multiselect(layout.tab.aa, layout.container.antiaim, arrow .. "Tweaks", "Avoid backstab", "Fix hideshots", "Yaw flick in air", "Air tick switcher", "Force Defensive in Air", "Force Defensive on Key", "Manuals over freestanding", "Tp on low hp"),
            animations = ui.new_multiselect(layout.tab.aa, layout.container.antiaim, arrow .. "Animations", "Static legs", "Leg fucker", "Moonwalk", "Paralyze", "0 pitch on landing"),
            manualLeft = ui.new_hotkey(layout.tab.aa, layout.container.antiaim, func.hex({200,200,200}) .. "» " .. func.hex({222,55,55}) .. "Manual " .. func.hex({200,200,200}) .. "left"),
            manualRight = ui.new_hotkey(layout.tab.aa, layout.container.antiaim, func.hex({200,200,200}) .. "» " .. func.hex({222,55,55}) .. "Manual " .. func.hex({200,200,200}) .. "right"),
            manualForward = ui.new_hotkey(layout.tab.aa, layout.container.antiaim, func.hex({200,200,200}) .. "» " .. func.hex({222,55,55}) .. "Manual " .. func.hex({200,200,200}) .. "forward"),
            defensiveBind = {
                defensiveKey = ui.new_hotkey(layout.tab.aa, layout.container.antiaim, func.hex({200,200,200}) .. "» " .. func.hex({222,55,55}) .. "Force defensive " .. func.hex({200,200,200}) .. "key"),
            },
            hpBar = {
                hpHotkey = ui.new_hotkey(layout.tab.aa, layout.container.antiaim, func.hex({200,200,200}) .. "» " .. func.hex({222,55,55}) .. "Teleport " .. func.hex({200,200,200}) .. "key"),
                hpSlider = ui.new_slider(layout.tab.aa, layout.container.antiaim, func.hex({200,200,200}) .. "» " .. func.hex({222,55,55}) .. "Teleport " .. func.hex({200,200,200}) .. "HP", 1, 92, 10, true, "hp", 1),
            }
        },
        configTab = {
            list = ui.new_listbox(layout.tab.aa, layout.container.antiaim, "Configs", ""),
            name = ui.new_textbox(layout.tab.aa, layout.container.antiaim, "Config name", ""),
            load = ui.new_button(layout.tab.aa, layout.container.antiaim, "Load", function() end),
            save = ui.new_button(layout.tab.aa, layout.container.antiaim, "Save", function() end),
            delete = ui.new_button(layout.tab.aa, layout.container.antiaim, "Delete", function() end),
            import = ui.new_button(layout.tab.aa, layout.container.antiaim, "Import", function() end),
            export = ui.new_button(layout.tab.aa, layout.container.antiaim, "Export", function() end)
        }
    }
}

local aaBuilder = {}
local container = {}
for i=1, #vars.aaStates do
    container[i] = func.hex({200,200,200}) .. "(" .. func.hex({222,55,55}) .. "" .. vars.pStates[i] .. "" .. func.hex({200,200,200}) .. ")" .. func.hex({155,155,155}) .. " "
    aaBuilder[i] = {
        enableState = ui.new_checkbox(layout.tab.aa, layout.container.antiaim, "Enable " .. func.hex({222,55,55}) .. "" .. vars.aaStates[i] .. "" .. func.hex({200,200,200}) .. " state"),
        antiBruteSet = ui.new_checkbox(layout.tab.aa, layout.container.antiaim, container[i] .. "Anti-Bruteforce"),
        stateDisablers = ui.new_multiselect(layout.tab.aa, layout.container.antiaim, container[i] .. "Disablers", "Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Crouch-Moving"),
        pitch = ui.new_combobox(layout.tab.aa, layout.container.antiaim, container[i] .. "Pitch", "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitchSlider = ui.new_slider(layout.tab.aa, layout.container.antiaim, container[i] .. "Pitch add", -89, 89, 0, true, "°", 1),
        yawBase = ui.new_combobox(layout.tab.aa, layout.container.antiaim, container[i] .. "Yaw base ", "Local view", "At targets"),
        yaw = ui.new_combobox(layout.tab.aa, layout.container.antiaim, container[i] .. "Yaw", "Off", "180", "Spin", "Static", "180 Z", "Crosshair"),
        yawCondition = ui.new_combobox(layout.tab.aa, layout.container.antiaim, container[i] .. "Yaw condition", "Static", "L & R"),
        yawStatic = ui.new_slider(layout.tab.aa, layout.container.antiaim, container[i] .. "Yaw limit", -180, 180, 0, true, "°", 1),
        yawLeft = ui.new_slider(layout.tab.aa, layout.container.antiaim, container[i] .. "Yaw left", -180, 180, 0, true, "°", 1),
        yawRight = ui.new_slider(layout.tab.aa, layout.container.antiaim, container[i] .. "Yaw right", -180, 180, 0, true, "°", 1),
        yawJitter = ui.new_combobox(layout.tab.aa, layout.container.antiaim, container[i] .. "Yaw jitter", "Off", "Offset", "Center", "3-Way", "Random", "Skitter"),
        yawJitterCondition = ui.new_combobox(layout.tab.aa, layout.container.antiaim, container[i] .. "Yaw jitter condition", "Static", "L & R"),
        yawJitterStatic = ui.new_slider(layout.tab.aa, layout.container.antiaim, container[i] .. "Yaw jitter limit", -180, 180, 0, true, "°", 1),
        yawJitterLeft = ui.new_slider(layout.tab.aa, layout.container.antiaim, container[i] .. "Yaw jitter left", -180, 180, 0, true, "°", 1),
        yawJitterRight = ui.new_slider(layout.tab.aa, layout.container.antiaim, container[i] .. "Yaw jitter right", -180, 180, 0, true, "°", 1),
        yawJitterDisablers = ui.new_multiselect(layout.tab.aa, layout.container.antiaim, container[i] .. "Yaw jitter disablers", "Head safety", "Height advantage"),
        bodyYaw = ui.new_combobox(layout.tab.aa, layout.container.antiaim, container[i] .. "Body yaw", "Off", "Opposite", "Jitter", "Static"),
        bodyYawCondition = ui.new_combobox(layout.tab.aa, layout.container.antiaim, container[i] .. "Body yaw condition", "Static", "L & R"),
        bodyYawStatic = ui.new_slider(layout.tab.aa, layout.container.antiaim, container[i] .. "Body yaw limit", -180, 180, 0, true, "°", 1),
        bodyYawLeft = ui.new_slider(layout.tab.aa, layout.container.antiaim, container[i] .. "Body yaw left", -180, 180, 0, true, "°", 1),
        bodyYawRight = ui.new_slider(layout.tab.aa, layout.container.antiaim, container[i] .. "Body yaw right", -180, 180, 0, true, "°", 1),
        roll = ui.new_slider(layout.tab.aa, layout.container.antiaim, container[i] .. "Roll", -50, 50, 0, true, "°"),
    }
end

local function getConfig(name)
    local database = database.read(interitus.database.configs) or {}

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
    local db = database.read(interitus.database.configs) or {}
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

    database.write(interitus.database.configs, db)
end
local function deleteConfig(name)
    local db = database.read(interitus.database.configs) or {}

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

    database.write(interitus.database.configs, db)
end
local function getConfigList()
    local database = database.read(interitus.database.configs) or {}
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
    if database.read(interitus.database.configs) == nil then
        database.write(interitus.database.configs, {})
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
        end
    
        ui.update(menu.items.configTab.list, getConfigList())
    end)
end
initDatabase()
-- #region UI_LAYOUT end

-- #region NOTIFICATION_ANIM start
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
        local offset = 0
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
            local strw2 = renderer.measure_text("b", "         ")

            local paddingx, paddingy = 7, data.size
            data.rounding = math.ceil(data.rounding/10 * (strh + paddingy*2)/2)

            offset = offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction
            glow_module(x/2 - (strw + strw2)/2 - paddingx, y - 100 - strh/2 - paddingy - offset, strw + strw2 + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {r, g, b, 45 * fraction}, {25,25,25,255 * fraction})
            renderer.text(x/2 + strw2/2, y - 100 - offset, 255, 255, 255, 255 * fraction, "c", 0, string)
            -- renderer.text(x/2 - strw/2, y - 100 - offset, 255, 255, 255, 255 * fraction, "cb", 0,color_text(" $interitus  ", r, g, b, a * fraction))
            local icon = images.load_svg(icon, 10, 10)
            icon:draw(x/2 - strw/2 - 12.5, y - 100 - offset - 10, 20, 20, r, g, b, 255 * fraction, "f")
            
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
    local r, g, b = ui.get(menu.items.visualsTab.indicatorsMainClr)
    notifications.new(string.format("Welcome to $interitus.red$, %s", userdata.username), r, g, b)
end)

local function onHit(e)
    local group = vars.hitgroup_names[e.hitgroup + 1] or '?'
	local r, g, b, a = ui.get(menu.items.visualsTab.indicatorsMainClr)
	notifications.new(string.format("Hit %s's $%s$ for $%d$ damage ($%d$ health remaining)", entity.get_player_name(e.target), group:lower(), e.damage, entity.get_prop(e.target, 'm_iHealth')), r, g, b) 

    if func.table_contains(ui.get(menu.items.visualsTab.notificationIndicatorsList), "Console") then
        local baimable = (ui.get(references.rage.minDmg) <= entity.get_prop(e.target, 'm_iHealth') and not ui.get(references.legit.enabled)) and { 150, 200, 60 } or { 255, 0, 0 }
        colorful_text:log(
            { { 200, 200, 200 }, { ui.get(menu.items.visualsTab.indicatorsMainClr) }, "[interitus.red] " },
            { { 205, 205, 205 }, ("hit %s's "):format(entity.get_player_name(e.target)) },
            { { ui.get(menu.items.visualsTab.indicatorsMainClr) }, ("%s "):format(group:lower() or '?')},
            { { 205, 205, 205 }, "for " },
            { { ui.get(menu.items.visualsTab.indicatorsMainClr) }, ("%s"):format(e.damage) },
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
    local hc_col = (hc < ui.get(references.rage.hitChance)) and { 255, 0, 0 } or { 150, 200, 60 };
    e.reason = e.reason == "?" and "resolver" or e.reason
	notifications.new(string.format("Missed %s's $%s$ due to $%s$", entity.get_player_name(e.target), group:lower(), e.reason), 255, 120, 120)
    if func.table_contains(ui.get(menu.items.visualsTab.notificationIndicatorsList), "Console") then
        colorful_text:log(
            { { 200, 200, 200 }, { ui.get(menu.items.visualsTab.indicatorsMainClr) }, "[interitus.red] " },
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
	local r, g, b, a = ui.get(menu.items.visualsTab.indicatorsMainClr)
    notifications.new(string.format('$%s$ purchased $%s$.', entity.get_player_name(buyer), item), r, g, b)

    if func.table_contains(ui.get(menu.items.visualsTab.notificationIndicatorsList), "Console") then

        colorful_text:log(
            { { 200, 200, 200 }, { ui.get(menu.items.visualsTab.indicatorsMainClr) }, "[interitus.red] " },
            { { 205, 205, 205 }, ("%s purchased "):format(entity.get_player_name(buyer)) },
            { { 255, 0, 0 }, ("%s"):format(item) },
            { { 205, 205, 205 }, ".", true }
        )
    end
end
-- #region NOTIFICATION_ANIM end

-- #region ANTIBF_CALLBACKS start
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
            local r, g, b, a = ui.get(menu.items.visualsTab.indicatorsMainClr)
            notifications.new(string.format("$%s$ triggered $anti-bruteforce$ - [%s]", entity.get_player_name(shooter), angle), r, g, b)
            last_abftick = globals.tickcount()
        end
	end
end)

-- #region ANTIBF_CALLBACKS end

-- #region AA_CALLBACKS start
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

local local_player
local isSlow
local isOs
local isFd
local isDt
local isLegitAA
local isDefensive
local flags
local onground
local valve
local origin
local velocity
local camera
local eye
local speed
local weapon
local pStill
local bodyYaw
local side
local hsSaved
local hsValue
local flick
local dtSaved
local dtEnabled
client.set_event_callback("setup_command", function(cmd)
    vars.localPlayer = entity.get_local_player()
    local_player = entity.get_local_player()
    if globals.tickcount() - last_abftick > 600 and reversed then
		resetBrute()
	end
    if not local_player or not entity.is_alive(local_player) then return end
    if not ui.get(menu.masterSwitch) then return end
	flags = entity.get_prop(local_player, "m_fFlags")
    onground = bit.band(flags, 1) ~= 0 and cmd.in_jump == 0
	valve = entity.get_prop(entity.get_game_rules(), "m_bIsValveDS")
	origin = vector(entity.get_prop(local_player, "m_vecOrigin"))
	velocity = vector(entity.get_prop(local_player, "m_vecVelocity"))
	camera = vector(client.camera_angles())
	eye = vector(client.eye_position())
	speed = math.sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y) + (velocity.z * velocity.z))
    weapon = entity.get_player_weapon()
	pStill = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2) < 5
    bodyYaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    side = bodyYaw > 0 and 1 or -1

    isSlow = ui.get(references.antiaim.slow[1]) and ui.get(references.antiaim.slow[2])
	isOs = ui.get(references.antiaim.os[1]) and ui.get(references.antiaim.os[2])
	isFd = ui.get(references.rage.fakeDuck)
	isDt = ui.get(references.rage.dt[1]) and ui.get(references.rage.dt[2])
    isLegitAA = ui.get(menu.items.aaTab.legitAAHotkey)

    local manualsOverFs = func.table_contains(ui.get(menu.items.miscTab.tweaks), "Manuals over freestanding") == true and true or false

    -- manual aa
    ui.set(menu.items.miscTab.manualLeft, "On hotkey")
    ui.set(menu.items.miscTab.manualRight, "On hotkey")
    ui.set(menu.items.miscTab.manualForward, "On hotkey")
    if aa.input + 0.22 < globals.curtime() then
        if aa.manualAA == 0 then
            if ui.get(menu.items.miscTab.manualLeft) then
                aa.manualAA = 1
                aa.input = globals.curtime()
            elseif ui.get(menu.items.miscTab.manualRight) then
                aa.manualAA = 2
                aa.input = globals.curtime()
            elseif ui.get(menu.items.miscTab.manualForward) then
                aa.manualAA = 3
                aa.input = globals.curtime()
            end
        elseif aa.manualAA == 1 then
            if ui.get(menu.items.miscTab.manualRight) then
                aa.manualAA = 2
                aa.input = globals.curtime()
            elseif ui.get(menu.items.miscTab.manualForward) then
                aa.manualAA = 3
                aa.input = globals.curtime()
            elseif ui.get(menu.items.miscTab.manualLeft) then
                aa.manualAA = 0
                aa.input = globals.curtime()
            end
        elseif aa.manualAA == 2 then
            if ui.get(menu.items.miscTab.manualLeft) then
                aa.manualAA = 1
                aa.input = globals.curtime()
            elseif ui.get(menu.items.miscTab.manualForward) then
                aa.manualAA = 3
                aa.input = globals.curtime()
            elseif ui.get(menu.items.miscTab.manualRight) then
                aa.manualAA = 0
                aa.input = globals.curtime()
            end
        elseif aa.manualAA == 3 then
            if ui.get(menu.items.miscTab.manualForward) then
                aa.manualAA = 0
                aa.input = globals.curtime()
            elseif ui.get(menu.items.miscTab.manualLeft) then
                aa.manualAA = 1
                aa.input = globals.curtime()
            elseif ui.get(menu.items.miscTab.manualRight) then
                aa.manualAA = 2
                aa.input = globals.curtime()
            end
        end
    end
    if aa.manualAA == 1 or aa.manualAA == 2 or aa.manualAA == 3 then
        aa.ignore = true
        if aa.manualAA == 1 then
            ui.set(references.antiaim.yawJitter[1], "off")
            ui.set(references.antiaim.yawJitter[2], 0)
            ui.set(references.antiaim.bodyYaw[1], "static")
            ui.set(references.antiaim.bodyYaw[2], -180)
            ui.set(references.antiaim.yawBase, "local view")
            ui.set(references.antiaim.yaw[1], "180")
            ui.set(references.antiaim.yaw[2], -90)
        elseif aa.manualAA == 2 then
            ui.set(references.antiaim.yawJitter[1], "off")
            ui.set(references.antiaim.yawJitter[2], 0)
            ui.set(references.antiaim.bodyYaw[1], "static")
            ui.set(references.antiaim.bodyYaw[2], -180)
            ui.set(references.antiaim.yawBase, "local view")
            ui.set(references.antiaim.yaw[1], "180")
            ui.set(references.antiaim.yaw[2], 90)
        elseif aa.manualAA == 3 then
            ui.set(references.antiaim.yawJitter[1], "off")
            ui.set(references.antiaim.yawJitter[2], 0)
            ui.set(references.antiaim.bodyYaw[1], "static")
            ui.set(references.antiaim.bodyYaw[2], -180)
            ui.set(references.antiaim.yawBase, "local view")
            ui.set(references.antiaim.yaw[1], "180")
            ui.set(references.antiaim.yaw[2], 180)
        end
    else
        aa.ignore = false
    end

    -- search for states
    if pStill then vars.pState = 1 end
    if not pStill then vars.pState = 2 end
    if isSlow then vars.pState = 3 end
    if entity.get_prop(local_player, "m_flDuckAmount") > 0.1 then vars.pState = 4 end
    if not pStill and entity.get_prop(local_player, "m_flDuckAmount") > 0.1 then vars.pState = 7 end
    if not onground then vars.pState = 5 end
    if not onground and entity.get_prop(local_player, "m_flDuckAmount") > 0.1 then vars.pState = 6 end

    local nextAttack = entity.get_prop(local_player, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(local_player), "m_flNextPrimaryAttack")
    local dtActive = false
    local isFl = ui.get(ui.reference("AA", "Fake lag", "Enabled"))
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end

    if ui.get(aaBuilder[8].enableState) and not func.table_contains(ui.get(aaBuilder[8].stateDisablers), vars.intToS[vars.pState]) and isDt == false and isFl == true then
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

    -- apply antiaim sets
    if not ui.get(menu.items.aaTab.legitAAHotkey) and aa.ignore == false then
        if ui.get(aaBuilder[vars.pState].enableState) then
            local pitchTypes = {[1] = "Up", [2] = ui.get(aaBuilder[vars.pState].pitch)}

            if (onground) then
                flick = globals.realtime()
            end

            if func.table_contains(ui.get(menu.items.miscTab.tweaks), "Yaw flick in air") and not onground and flick ~= nil then
                if (globals.realtime() - flick > 0.5) then
                    ui.set(references.antiaim.pitch[1], "Up")
                    flick = globals.realtime()
                else
                    ui.set(references.antiaim.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                end
            elseif ui.get(aaBuilder[vars.pState].pitch) ~= "Custom" then
                ui.set(references.antiaim.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
            else
                ui.set(references.antiaim.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                ui.set(references.antiaim.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
            end

            ui.set(references.antiaim.yawBase, ui.get(aaBuilder[vars.pState].yawBase))

            ui.set(references.antiaim.yaw[1], ui.get(aaBuilder[vars.pState].yaw))

            if ((func.table_contains(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "Height advantage" ) and heightAdvantage) or (func.table_contains(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "Head safety") and safetyAlert)) then
                ui.set(references.antiaim.yawJitter[1], "Off") 
            elseif ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                ui.set(references.antiaim.yawJitter[1], "Center")
            else
                ui.set(references.antiaim.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
            end
            if ui.get(aaBuilder[vars.pState].yawJitterCondition) == "L & R" then
                if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                    ui.set(references.antiaim.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft)*math.random(-1, 1)  or ui.get(aaBuilder[vars.pState].yawJitterRight)*math.random(-1, 1) ))
                else
                    ui.set(references.antiaim.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
                end
                
            else
                if  ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                    ui.set(references.antiaim.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic)*math.random(-1, 1) )
                else
                    ui.set(references.antiaim.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic) )
                end
            end

            if ui.get(aaBuilder[vars.pState].yawCondition) == "L & R" then
                ui.set(references.antiaim.yaw[2],(side == 1 and ui.get(aaBuilder[vars.pState].yawLeft) or ui.get(aaBuilder[vars.pState].yawRight)))
            else
                ui.set(references.antiaim.yaw[2], ui.get(aaBuilder[vars.pState].yawStatic))
            end

            ui.set(references.antiaim.bodyYaw[1], ui.get(aaBuilder[vars.pState].bodyYaw))
            if ui.get(aaBuilder[vars.pState].bodyYawCondition) == "L & R" then
                ui.set(references.antiaim.bodyYaw[2], (side == 1 and ui.get(aaBuilder[vars.pState].bodyYawLeft) or ui.get(aaBuilder[vars.pState].bodyYawRight)))
            else
                ui.set(references.antiaim.bodyYaw[2], ui.get(aaBuilder[vars.pState].bodyYawStatic))
            end

            if reversed and ui.get(aaBuilder[vars.pState].antiBruteSet) then
                ui.set(references.antiaim.yaw[2], angle)
            end

            ui.set(references.antiaim.roll, ui.get(aaBuilder[vars.pState].roll))
        elseif not ui.get(aaBuilder[vars.pState].enableState) then
            ui.set(references.antiaim.pitch[1], "Off")
            ui.set(references.antiaim.yawBase, "Local view")
            ui.set(references.antiaim.yaw[1], "Off")
            ui.set(references.antiaim.yaw[2], 0)
            ui.set(references.antiaim.yawJitter[1], "Off")
            ui.set(references.antiaim.yawJitter[2], 0)
            ui.set(references.antiaim.bodyYaw[1], "Off")
            ui.set(references.antiaim.bodyYaw[2], 0)
            ui.set(references.antiaim.fsBodyYaw, false)
            ui.set(references.antiaim.edgeYaw, false)
            ui.set(references.antiaim.roll, 0)
        end
    elseif ui.get(menu.items.aaTab.legitAAHotkey) and aa.ignore == false then
        if weapon ~= nil and entity.get_classname(weapon) == "CC4" then
            if cmd.in_attack == 1 then
                cmd.in_attack = 0 
                cmd.in_use = 1
            end
        else
            cmd.in_use = 0
            ui.set(references.antiaim.pitch[1], "Off")
            ui.set(references.antiaim.yawBase, "Local view")
            ui.set(references.antiaim.yaw[1], "Off")
            ui.set(references.antiaim.yaw[2], 0)
            ui.set(references.antiaim.yawJitter[1], "Off")
            ui.set(references.antiaim.yawJitter[2], 0)
            ui.set(references.antiaim.bodyYaw[1], ui.get(menu.items.aaTab.legitAAMode))
            ui.set(references.antiaim.bodyYaw[2], 0)
            ui.set(references.antiaim.fsBodyYaw, true)
            ui.set(references.antiaim.edgeYaw, false)
            ui.set(references.antiaim.roll, 0)
        end
    end

    -- fix hideshots
	if func.table_contains(ui.get(menu.items.miscTab.tweaks), "Fix hideshots") then
		if isOs and not isDt and not isFd then
            if not hsSaved then
                hsValue = ui.get(references.antiaim.fakeLag[1])
                hsSaved = true
            end
			ui.set(references.antiaim.fakeLag[1], math.random(1,3))
		elseif hsSaved then
			ui.set(references.antiaim.fakeLag[1], hsValue)
            hsSaved = false
		end
	end

    -- avoid backstab
    if func.table_contains(ui.get(menu.items.miscTab.tweaks), "Avoid backstab") then
        local players = entity.get_players(true)

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = func.findDist(origin.x, origin.y, origin.z, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 200 then
                ui.set(references.antiaim.yaw[2], 180)
                ui.set(references.antiaim.pitch[1], "Off")
            end
        end
    end

        -- freestand
        if ( ui.get(menu.items.aaTab.freestandHotkey) ) then
            if manualsOverFs == true and aa.ignore == true then
                ui.set(references.antiaim.freeStand[2], "On hotkey")
                return
            else
                if ui.get(menu.items.aaTab.freestand) == "Static" then
                    ui.set(references.antiaim.yawJitter[2], 0)
                    ui.set(references.antiaim.bodyYaw[1], "Off")
                end
                ui.set(references.antiaim.freeStand[2], "Always on")
                ui.set(references.antiaim.freeStand[1], true)
            end
        else
            ui.set(references.antiaim.freeStand[1], false)
            ui.set(references.antiaim.freeStand[2], "On hotkey")
        end

    if func.table_contains(ui.get(menu.items.miscTab.tweaks), "Air tick switcher") and not onground then
        if dtSaved == nil then
            dtSaved = ui.get(references.rage.dt[3])
        end
        ui.set(references.rage.dt[3], globals.tickcount() % 2 == 1 and "Offensive" or "Defensive")
    else
        if dtSaved ~= nil then
            ui.set(references.rage.dt[3], dtSaved)
            dtSaved = nil
        end
    end

    local defensiveKey = ( (func.table_contains(ui.get(menu.items.miscTab.tweaks), "Force Defensive on Key") and ui.get(menu.items.miscTab.defensiveBind.defensiveKey)) or (isDt and not onground and func.table_contains(ui.get(menu.items.miscTab.tweaks), "Force Defensive in Air")) )

    cmd.force_defensive = defensiveKey == true and true or false

    isDefensive = cmd.force_defensive == true and true or false

    if func.table_contains(ui.get(menu.items.miscTab.tweaks), "Tp on low hp") then
        if dtEnabled == nil then
            dtEnabled = true
        end
        local enemies = entity.get_players(true)
        local vis = false
        local health = entity.get_prop(local_player, "m_iHealth")
        for i=1, #enemies do
            local entindex = enemies[i]
            local body_x,body_y,body_z = entity.hitbox_position(entindex, 1)
            if client.visible(body_x, body_y, body_z + 20) then
                vis = true
            end
        end	
        if vis and (health <= ui.get(menu.items.miscTab.hpBar.hpSlider)) and ui.get(menu.items.miscTab.hpBar.hpHotkey) then
            ui.set(references.rage.dt[1],false)
        else
            ui.set(references.rage.dt[1],true)
        end
    else
        if dtEnabled == true then
            ui.set(references.rage.dt[1], dtEnabled)
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

    if func.table_contains(ui.get(menu.items.miscTab.animations), "Static legs") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
    end

    if func.table_contains(ui.get(menu.items.miscTab.animations), "Leg fucker") or func.table_contains(ui.get(menu.items.miscTab.animations), "Moonwalk") or func.table_contains(ui.get(menu.items.miscTab.animations), "Paralyze") then
        if not legsSaved then
            legsSaved = ui.get(references.antiaim.legMovement)
        end
        ui.set_visible(references.antiaim.legMovement, false)
        if func.table_contains(ui.get(menu.items.miscTab.animations), "Leg fucker") and not func.table_contains(ui.get(menu.items.miscTab.animations), "Moonwalk") and not func.table_contains(ui.get(menu.items.miscTab.animations), "Paralyze") then
            ui.set(references.antiaim.legMovement, legsTypes[math.random(1, 3)])
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
        elseif func.table_contains(ui.get(menu.items.miscTab.animations), "Moonwalk") and not func.table_contains(ui.get(menu.items.miscTab.animations), "Paralyze") then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
            local me = ent.get_local_player()
            local flags = me:get_prop("m_fFlags")
            local onground = bit.band(flags, 1) ~= 0
            if not onground then
                local my_animlayer = me:get_anim_overlay(6) -- MOVEMENT_MOVE
                my_animlayer.weight = 1
            end
            ui.set(references.antiaim.legMovement, "Off")
        elseif func.table_contains(ui.get(menu.items.miscTab.animations), "Paralyze") then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 8)
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 9)
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 10)
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 16)
            ui.set(references.antiaim.legMovement, "Off")
        end
    elseif (legsSaved == "Off" or legsSaved == "Always slide" or legsSaved == "Never slide") then
        ui.set_visible(references.antiaim.legMovement, true)
        ui.set(references.antiaim.legMovement, legsSaved)
        legsSaved = false
    end
    if func.table_contains(ui.get(menu.items.miscTab.animations), "0 pitch on landing") then
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
-- #region AA_CALLBACKS end

-- #region IND_CALLBACKS start
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
    if not ui.get(menu.masterSwitch) then return end
    local sizeX, sizeY = client.screen_size()
    local weapon = entity.get_player_weapon(local_player)
    local bodyYaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyYaw > 0 and 1 or -1
    local state = "MOVING"
    local mainClr = {}
    mainClr.r, mainClr.g, mainClr.b, mainClr.a = ui.get(menu.items.visualsTab.indicatorsMainClr)
    local fake = math.floor(antiaim_funcs.get_desync(1))

    local isSlow = ui.get(references.antiaim.slow[1]) and ui.get(references.antiaim.slow[2])
    local isOs = ui.get(references.antiaim.os[1]) and ui.get(references.antiaim.os[2])
    local isFd = ui.get(references.rage.fakeDuck)
    local isDt = ui.get(references.rage.dt[1]) and ui.get(references.rage.dt[2])
    local nextAttack = entity.get_prop(local_player, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(local_player), "m_flNextPrimaryAttack")
    local dtActive = false
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end
    local isCharged = antiaim_funcs.get_double_tap()
    local isFs = ui.get(menu.items.aaTab.freestandHotkey)
    local isSp = ui.get(references.rage.safePoint)
    local isQp = ui.get(references.rage.quickPeek[2])
    local isPing = ui.get(references.misc.ping[1]) and ui.get(references.misc.ping[2])

    local time = globals.frametime() * 30
    local dpi = ui.get(ui.reference("MISC", "Settings", "DPI scale")):gsub('%%', '') - 100

    if vars.pState == 8 then state = "FAKELAG" end
    if vars.pState == 7 then state = "MOVING+C" end
    if vars.pState == 6 then state = "AEROBIC+C" end
    if vars.pState == 5 then state = "AEROBIC" end
    if vars.pState == 4 then state = "CROUCHING" end
    if vars.pState == 3 then state = "SLOWWALKING" end
    if vars.pState == 2 then state = "MOVING" end
    if vars.pState == 1 then state = "STANDING" end

    -- anim
    local textLogo = "interitus.red"

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

    if ui.get(menu.items.visualsTab.indicatorsStyle) == "New" then
        local strike_w, strike_h = renderer.measure_text("cdb", "interitus .red")
        local aA = func.create_color_array(mainClr.r, mainClr.g, mainClr.b, textLogo)
        local textSplit = func.textArray(textLogo)

        glow_module(sizeX/2 + ((strike_w + 2)/2) * scopedFraction - strike_w/2 + 4, sizeY/2 + 20 - dpi/10, strike_w - 3, 0, 10, 0, {mainClr.r, mainClr.g, mainClr.b, 100 * math.abs(math.cos(globals.curtime()*2))}, {mainClr.r, mainClr.g, mainClr.b, 100 * math.abs(math.cos(globals.curtime()*2))})
        renderer.text(sizeX/2 + ((strike_w + 2)/2) * scopedFraction, sizeY/2 + 20 - dpi/10, 0, 0, 0, 50, "cdb", nil, textLogo)
        renderer.text(sizeX/2 + ((strike_w + 2)/2) * scopedFraction, sizeY/2 + 20 - dpi/10, 255, 255, 255, 255, "cdb", nil, string.format("\a%s%s\a%s%s\a%s%s\a%s%s\a%s%s\a%s%s\a%s%s\a%s%s\a%s%s\a%s%s\a%s%s\a%s%s\a%s%s", func.RGBAtoHEX(unpack(aA[1])), textSplit[1], func.RGBAtoHEX(unpack(aA[2])), textSplit[2], func.RGBAtoHEX(unpack(aA[3])), textSplit[3], func.RGBAtoHEX(unpack(aA[4])), textSplit[4], func.RGBAtoHEX(unpack(aA[5])), textSplit[5], func.RGBAtoHEX(unpack(aA[6])), textSplit[6], func.RGBAtoHEX(unpack(aA[7])), textSplit[7], func.RGBAtoHEX(unpack(aA[8])), textSplit[8], func.RGBAtoHEX(unpack(aA[9])), textSplit[9], func.RGBAtoHEX(unpack(aA[10])), textSplit[10], func.RGBAtoHEX(unpack(aA[11])), textSplit[11], func.RGBAtoHEX(unpack(aA[12])), textSplit[12], func.RGBAtoHEX(unpack(aA[13])), textSplit[13] ))

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

    if ui.get(menu.items.visualsTab.arrowIndicators) == "Default" then
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

    if ui.get(menu.items.visualsTab.arrowIndicators) == "Dynamic" then
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

    if ui.get(menu.items.visualsTab.arrowIndicators) == "Teamskeet" then
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

    if func.table_contains(ui.get(menu.items.visualsTab.debugIndicatorsList), "Debug panel")  then
        local threat = tostring(entity.get_player_name(client.current_threat()))
        local marginX, marginY = renderer.measure_text("-d", "DEBUG")
        local moveY = -30
        
        func.render_text(5, sizeY/2 + moveY, {255, 255, 255, 255, "INTERITUS.RED  -  "}, {mainClr.r, mainClr.g, mainClr.b, 255, userdata.username:upper()})
        func.render_text(5, sizeY/2 + moveY + marginY * 1, {255, 255, 255, 255, "BUILD:  "}, {mainClr.r, mainClr.g, mainClr.b, math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255, userdata.build:upper()})
        func.render_text(5, sizeY/2 + moveY + marginY * 2, {255, 255, 255, 255, "DESYNC DELTA:  "}, {mainClr.r, mainClr.g, mainClr.b, 255, math.floor(antiaim_funcs.get_desync(2)) .. "°"})
        func.render_text(5, sizeY/2 + moveY + marginY * 3, {255, 255, 255, 255, "PLAYER STATE:  "}, {mainClr.r, mainClr.g, mainClr.b, 255, state})
        func.render_text(5, sizeY/2 + moveY + marginY * 4, {255, 255, 255, 255, "CURRENT THREAT:  "}, {mainClr.r, mainClr.g, mainClr.b, 255, threat:upper()})
    end
    
    if func.table_contains(ui.get(menu.items.visualsTab.debugIndicatorsList), "Flag") and download then
        local flagimg = renderer.load_png(download, 25, 15)
        if flagimg ~= nil and download ~= nil then
            local mainY = 35
            local marginX, marginY = renderer.measure_text("-d", "INTERITUS.RED")
            renderer.gradient(2.5, sizeY/2 + mainY - 2, marginX*2, marginY*2 - 1, mainClr.r, mainClr.g, mainClr.b, 255, mainClr.r, mainClr.g, mainClr.b, 0, true)
            renderer.texture(flagimg, 5, sizeY/2 + mainY, 25, marginY*1.5, 255, 255, 255, 255, "f")
            renderer.text(33, sizeY/2 - 2 + mainY, 255, 255, 255, 255, "-d", nil, "INTERITUS" .. func.hex({mainClr.r, mainClr.g, mainClr.b}) .. ".RED")
            renderer.text(33, sizeY/2 - 4 + marginY + mainY, 255, 255, 255, 255, "-d", nil, func.hex({mainClr.r, mainClr.g, mainClr.b}) .. "[" .. userdata.build:upper() .. "]")
        else
            downloadFile()
        end
    end

    if ui.get(menu.items.visualsTab.minDmgIndicator) and entity.get_classname(weapon) ~= "CKnife" and ui.get(references.rage.dmgOverride[1]) and ui.get(references.rage.dmgOverride[2]) then
        local dmg = ui.get(references.rage.dmgOverride[3])
        renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, dmg)
    end
    notifications.render()
end)

ui.set_callback(menu.items.visualsTab.notificationIndicatorsList, function() 
    local setHit = func.table_contains(ui.get(menu.items.visualsTab.notificationIndicatorsList), "Hit") and client.set_event_callback or client.unset_event_callback
    setHit("aim_hit", onHit)

    local setMiss = func.table_contains(ui.get(menu.items.visualsTab.notificationIndicatorsList), "Miss") and client.set_event_callback or client.unset_event_callback
    setMiss("aim_miss", onMiss)

    local setPurchase = func.table_contains(ui.get(menu.items.visualsTab.notificationIndicatorsList), "Purchase") and client.set_event_callback or client.unset_event_callback
    setPurchase("item_purchase", onPurchase) 
end)
-- #region IND_CALLBACKS end

-- #region UI_CALLBACKS start
ui.update(menu.items.configTab.list,getConfigList())
if database.read(interitus.database.configs) == nil then
    database.write(interitus.database.configs, {})
end
ui.set(menu.items.configTab.name, #database.read(interitus.database.configs) == 0 and "" or database.read(interitus.database.configs)[ui.get(menu.items.configTab.list)+1].name)
ui.set_callback(menu.items.configTab.list, function(value)
    local protected = function()
        if value == nil then return end
        local name = ""
    
        local configs = getConfigList()
        if configs == nil then return end
    
        name = configs[ui.get(value)+1] or ""
    
        ui.set(menu.items.configTab.name, name)
    end

    if pcall(protected) then

    end
end)

ui.set_callback(menu.items.configTab.load, function()
    local r, g, b = ui.get(menu.items.visualsTab.indicatorsMainClr)
    local name = ui.get(menu.items.configTab.name)
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

ui.set_callback(menu.items.configTab.save, function()
    local r, g, b = ui.get(menu.items.visualsTab.indicatorsMainClr)

        local name = ui.get(menu.items.configTab.name)
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
        ui.update(menu.items.configTab.list, getConfigList())
    end
    if pcall(protected) then
        notifications.new(string.format('Successfully saved "$%s$"', name), r, g, b)
    end
end)

ui.set_callback(menu.items.configTab.delete, function()
    local name = ui.get(menu.items.configTab.name)
    if name == "" then return end
    local r, g, b = ui.get(menu.items.visualsTab.indicatorsMainClr)
    if deleteConfig(name) == false then
        notifications.new(string.format('Failed to delete "$%s$"', name), 255, 120, 120)
        ui.update(menu.items.configTab.list, getConfigList())
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
        ui.update(menu.items.configTab.list, getConfigList())
        ui.set(menu.items.configTab.list, #presets + #database.read(interitus.database.configs) - #database.read(interitus.database.configs))
        ui.set(menu.items.configTab.name, #database.read(interitus.database.configs) == 0 and "" or getConfigList()[#presets + #database.read(interitus.database.configs) - #database.read(interitus.database.configs)+1])
        notifications.new(string.format('Successfully deleted "$%s$"', name), r, g, b)
    end
end)

ui.set_callback(menu.items.configTab.import, function()
    local r, g, b = ui.get(menu.items.visualsTab.indicatorsMainClr)

    local protected = function()
        importSettings()
    end

    if pcall(protected) then
        notifications.new(string.format('Successfully imported settings', name), r, g, b)
    else
        notifications.new(string.format('Failed to import settings', name), 255, 120, 120)
    end
end)

ui.set_callback(menu.items.configTab.export, function()
    local name = ui.get(menu.items.configTab.name)
    if name == "" then return end

    local protected = function()
        exportSettings(name)
    end
    local r, g, b = ui.get(menu.items.visualsTab.indicatorsMainClr)
    if pcall(protected) then
        notifications.new(string.format('Successfully exported settings', name), r, g, b)
    else
        notifications.new(string.format('Failed to export settings', name), 255, 120, 120)
    end
end)
-- #region UI_CALLBACKS end

-- #region UI_RENDER start
client.set_event_callback("paint_ui", function()
    vars.activeState = vars.sToInt[ui.get(menu.items.aaTab.state)]
    local isEnabled = ui.get(menu.masterSwitch)
    local isAATab = ui.get(menu.items.tabPicker) == "Anti-aim"
    local isVisualsTab = ui.get(menu.items.tabPicker) == "Visuals"
    local isMiscTab = ui.get(menu.items.tabPicker) == "Misc"
    local isCFGTab = ui.get(menu.items.tabPicker) == "Config"
    ui.set_visible(menu.items.tabPicker, isEnabled)
    ui.set_visible(menu.items.aaTab.state, isAATab and isEnabled)
    for i=1, #vars.aaStates do
        local stateEnabled = ui.get(aaBuilder[i].enableState)
        ui.set_visible(aaBuilder[i].enableState, vars.activeState == i and isAATab and isEnabled)
        ui.set_visible(aaBuilder[i].stateDisablers, vars.activeState == 8 and i == 8 and isAATab and ui.get(aaBuilder[8].enableState) and isEnabled)
        ui.set_visible(aaBuilder[i].pitch, vars.activeState == i and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].pitchSlider , vars.activeState == i and isAATab and stateEnabled and ui.get(aaBuilder[i].pitch) == "Custom" and isEnabled)
        ui.set_visible(aaBuilder[i].yawBase, vars.activeState == i and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yaw, vars.activeState == i and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawCondition, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "Static" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "L & R" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "L & R" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitter, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterCondition, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterStatic, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "Static" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterLeft, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "L & R" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterRight, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "L & R" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterDisablers, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYaw, vars.activeState == i and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawCondition, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawStatic, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYawCondition) == "Static" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawLeft, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYawCondition) == "L & R" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawRight, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYawCondition  ) == "L & R" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isAATab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].antiBruteSet, vars.activeState == i and isAATab and stateEnabled and isEnabled and (ui.get(aaBuilder[i].yaw) ~= "Off" or ui.get(aaBuilder[i].bodyYaw) ~= "Off") )
        ui.set_visible(aaBuilder[i].roll, vars.activeState == i and isAATab and stateEnabled and isEnabled)
    end
    -- ui.set_visible(exportTab, isAATab and isEnabled and ui.get(aaBuilder[vars.activeState].enableState) and ui.get(menu.items.aaTab.aaBuilderEnable))
    -- ui.set_visible(importTab, isAATab and isEnabled and ui.get(aaBuilder[vars.activeState].enableState) and ui.get(menu.items.aaTab.aaBuilderEnable))
    ui.set_visible(menu.items.aaTab.freestand, isAATab and isEnabled)
    ui.set_visible(menu.items.aaTab.freestandHotkey, isAATab and isEnabled)
    ui.set_visible(menu.items.aaTab.legitAAHotkey, isAATab and isEnabled)
    ui.set_visible(menu.items.aaTab.legitAAMode, isAATab and isEnabled)


    for i, feature in pairs(menu.items.visualsTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isVisualsTab and isEnabled)
        end
	end 
    
    for i, feature in pairs(menu.items.miscTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isMiscTab and isEnabled)
        end
	end

    for i, feature in pairs(menu.items.miscTab.defensiveBind) do
        ui.set_visible(feature, isMiscTab and func.table_contains(ui.get(menu.items.miscTab.tweaks), "Force Defensive on Key") and isEnabled)
	end

    for i, feature in pairs(menu.items.miscTab.hpBar) do
        ui.set_visible(feature, isMiscTab and func.table_contains(ui.get(menu.items.miscTab.tweaks), "Tp on low hp") and isEnabled)
	end

    for i, feature in pairs(menu.items.configTab) do
		ui.set_visible(feature, isCFGTab and isEnabled)
	end


    if not isEnabled and not saved then
        func.resetAATab()
        ui.set(references.antiaim.fsBodyYaw, isEnabled)
        ui.set(references.antiaim.enabled, isEnabled)
        saved = true
    elseif isEnabled and saved then
        ui.set(references.antiaim.fsBodyYaw, not isEnabled)
        ui.set(references.antiaim.enabled, isEnabled)
        saved = false
    end
    func.setAATab(not isEnabled)
end)

client.set_event_callback("shutdown", function()
    if legsSaved ~= false then
        ui.set(references.antiaim.legMovement, legsSaved)
    end
    if hsValue ~= nil then
        ui.set(references.antiaim.fakeLag[1], hsValue)
    end
    if dtSaved ~= nil then
        ui.set(references.rage.dt[3], dtSaved)
    end
    ui.set(references.rage.dt[1], ui.get(references.rage.dt[1]))
    ui.set_visible(references.antiaim.legMovement, true)
    func.setAATab(true)
    download = nil
end)
-- #region UI_RENDER end