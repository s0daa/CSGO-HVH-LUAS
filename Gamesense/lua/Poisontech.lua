-- @region LUASETTINGS start
local lua_name = "poisontech"
local lua_color = {r = 255, g = 255, b = 255}
local script_build = "Renewed"

-- @region LUASETTINGS end

-- region USERDATA

local chapter_data = chapter_fetch and chapter_fetch() or {username = 'admin', build = 'nightly', discord=''}
local userdata = {
    username = chapter_data.username == nil or chapter_data.username,
}

-- userdata end

-- @region DEPENDENCIES start
local function try_require(module, msg)
    local success, result = pcall(require, module)
    if success then return result else return error(msg) end
end

local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
local gram_update = function(tab, value, forced) local new_tab = tab; if forced or new_tab[#new_tab] ~= value then table.insert(new_tab, value); table.remove(new_tab, 1); end; tab = new_tab; end
local get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end
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
local steamworks = try_require("gamesense/steamworks") or error('Missing https://gamesense.pub/forums/viewtopic.php?id=26526')
function ui.multiReference(tab, groupbox, name)
    local ref1, ref2, ref3 = ui.reference(tab, groupbox, name)
    return { ref1, ref2, ref3 }
end
-- @region DEPENDENCIES end

-- @region USERDATA start
client.exec("clear")
client.color_log(255, 255, 255, "Welcome to\0")
client.color_log(lua_color.r, lua_color.g, lua_color.b, " poisontech")

local lua = {}
lua.database = {
    configs = ":" .. lua_name .. "::configs:"
}
local presets = {}
-- @region USERDATA end

-- @region REFERENCES start
local refs = {
    slowmotion = ui.reference("AA", "Other", "Slow motion"),
    OSAAA = ui.reference("AA", "Other", "On shot anti-aim"),
    Legmoves = ui.reference("AA", "Other", "Leg movement"),
    legit = ui.reference("LEGIT", "Aimbot", "Enabled"),
    minimum_damage_override = { ui.reference("Rage", "Aimbot", "Minimum damage override") },
    fakeDuck = ui.reference("RAGE", "Other", "Duck peek assist"),
    minimum_damage = ui.reference("Rage", "Aimbot", "Minimum damage"),
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
    flamount = ui.reference("AA", "Fake lag", "Amount"),
    flenabled = ui.reference("AA", "Fake lag", "Enabled"),
    flVariance = ui.reference("AA", "Fake lag", "Variance"),
    AAfake = ui.reference("AA", "Other", "Fake peek"),
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

local ref = {
    aimbot = ui.reference('RAGE', 'Aimbot', 'Enabled'),
    doubletap = {
        main = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
        fakelag_limit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
    }
}

local binds = {
    legMovement = ui.multiReference("AA", "Other", "Leg movement"),
    flenabled = ui.multiReference("AA", "Fake lag", "Enabled"),
    slowmotion = ui.multiReference("AA", "Other", "Slow motion"),
    OSAAA = ui.multiReference("AA", "Other", "On shot anti-aim"),
    AAfake = ui.multiReference("AA", "Other", "Fake peek"),
}

local function traverse_table_on(tbl, prefix)
    prefix = prefix or ""
    local stack = {{tbl, prefix}}

    while #stack > 0 do
        local current = table.remove(stack)
        local current_tbl = current[1]
        local current_prefix = current[2]

        for key, value in pairs(current_tbl) do
            local full_key = current_prefix .. key
            if type(value) == "table" then
                table.insert(stack, {value, full_key .. "."})
            else
                -- Применяем ui.set_visible к каждому элементу
                ui.set_visible(value, true) -- Здесь можно изменить параметр видимости на нужное значение
            end
        end
    end
end

local function traverse_table(tbl, prefix)
    prefix = prefix or ""
    local stack = {{tbl, prefix}}

    while #stack > 0 do
        local current = table.remove(stack)
        local current_tbl = current[1]
        local current_prefix = current[2]

        for key, value in pairs(current_tbl) do
            local full_key = current_prefix .. key
            if type(value) == "table" then
                table.insert(stack, {value, full_key .. "."})
            else
                -- Применяем ui.set_visible к каждому элементу
                ui.set_visible(value, false) -- Здесь можно изменить параметр видимости на нужное значение
            end
        end
    end
end
-- @region REFERENCES end

-- @region VARIABLES start
local vars = {
    localPlayer = 0,
    hitgroup_names = { 'Generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', '?', 'Gear' },
    aaStates = {"Global", "Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Crouch-Moving", "Fakelag"},
    pStates = {"G", "S", "M", "SW", "C", "A", "AC", "CM", "FL"},
	sToInt = {["Global"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["Slowwalking"] = 4, ["Crouching"] = 5, ["Air"] = 6, ["Air-Crouching"] = 7, ["Crouch-Moving"] = 8 , ["Fakelag"] = 9},
    intToS = {[1] = "Global", [2] = "Standing", [3] = "Moving", [4] = "Slowwalking", [5] = "Crouching", [6] = "Air", [7] = "Air-Crouching", [8] = "Crouch-Moving", [9] = "Fakelag"},
    currentTab = 1,
    activeState = 1,
    pState = 1,
    yaw = 0,
    sidemove = 0,
    m1_time = 0,
    choked = 0,
    dt_state = 0,
    doubletap_time = 0,
    breaker = {
        defensive = 0,
        defensive_check = 0,
        cmd = 0,
        last_origin = nil,
        origin = nil,
        tp_dist = 0,
        tp_data = gram_create(0,3)
    },
    mapname = globals.mapname()
}

local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI = js.MyPersonaAPI, js.LobbyAPI, js.PartyListAPI, js.SteamOverlayAPI
-- @region VARIABLES end

-- @region FFI start
local angle3d_struct = ffi.typeof("struct { float pitch; float yaw; float roll; }")
local vec_struct = ffi.typeof("struct { float x; float y; float z; }")

local cUserCmd =
    ffi.typeof(
    [[
    struct
    {
        uintptr_t vfptr;
        int command_number;
        int tick_count;
        $ viewangles;
        $ aimdirection;
        float forwardmove;
        float sidemove;
        float upmove;
        int buttons;
        uint8_t impulse;
        int weaponselect;
        int weaponsubtype;
        int random_seed;
        short mousedx;
        short mousedy;
        bool hasbeenpredicted;
        $ headangles;
        $ headoffset;
        bool send_packet; 
    }
    ]],
    angle3d_struct,
    vec_struct,
    angle3d_struct,
    vec_struct
)

local client_sig = client.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85") or error("client.dll!:input not found.")
local get_cUserCmd = ffi.typeof("$* (__thiscall*)(uintptr_t ecx, int nSlot, int sequence_number)", cUserCmd)
local input_vtbl = ffi.typeof([[struct{uintptr_t padding[8];$ GetUserCmd;}]],get_cUserCmd)
local input = ffi.typeof([[struct{$* vfptr;}*]], input_vtbl)
local get_input = ffi.cast(input,ffi.cast("uintptr_t**",tonumber(ffi.cast("uintptr_t", client_sig)) + 1)[0])
-- @region FFI end

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
        ui.set_visible(refs.slowmotion, ref)
        ui.set_visible(refs.Legmoves, ref)
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
        ui.set_visible(refs.flLimit, ref)
        ui.set_visible(refs.flamount, ref)
        ui.set_visible(refs.flVariance, ref)
        ui.set_visible(refs.flenabled, ref)
        ui.set_visible(refs.AAfake, ref)
        ui.set_visible(refs.OSAAA, ref)
    end,
    findDist = function (x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end,
    resetAATab = function()
        ui.set(refs.OSAAa, false)
        ui.set(refs.enabled, false)
        ui.set(refs.pitch[1], "Off")
        ui.set(refs.pitch[2], 0)
        ui.set(refs.roll, 0)
        ui.set(refs.slowmotion, false)
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
        ui.set(refs.flLimit, false)
        ui.set(refs.flamount, false)
        ui.set(refs.flenabled, false)
        ui.set(refs.flVariance, false)
        ui.set(refs.AAfake, false)
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
    vec_angles = function(angle_x, angle_y)
        local sy = math.sin(math.rad(angle_y))
        local cy = math.cos(math.rad(angle_y))
        local sp = math.sin(math.rad(angle_x))
        local cp = math.cos(math.rad(angle_x))
        return cp * cy, cp * sy, -sp
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
    includes = function(tbl, value)
        for i = 1, #tbl do
            if tbl[i] == value then
                return true
            end
        end
        return false
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

func.in_air = (function(player)
    if player == nil then return end
    local flags = entity.get_prop(player, "m_fFlags")
    if flags == nil then return end
    if bit.band(flags, 1) == 0 then
        return true
    end
    return false
end)

local function get_velocity(player)
    local x,y,z = entity.get_prop(player, "m_vecVelocity")
    if x == nil then return end
    return math.sqrt(x*x + y*y + z*z)
end

local function can_desync(cmd)
    if entity.get_prop(entity.get_local_player(), "m_MoveType") == 9 then
        return false
    end
    local client_weapon = entity.get_player_weapon(entity.get_local_player())
    if client_weapon == nil then
        return false
    end
    local weapon_classname = entity.get_classname(client_weapon)
    local in_use = cmd.in_use == 1
    local in_attack = cmd.in_attack == 1
    local in_attack2 = cmd.in_attack2 == 1
    if in_use then
        return false
    end
    if in_attack or in_attack2 then
        if weapon_classname:find("Grenade") then
            vars.m1_time = globals.curtime() + 0.15
        end
    end
    if vars.m1_time > globals.curtime() then
        return false
    end
    if in_attack then
        if client_weapon == nil then
            return false
        end
        if weapon_classname then
            return false
        end
        return false
    end
    return true
end

local function get_choke(cmd)
    local fl_limit = ui.get(refs.flLimit)
    local fl_p = fl_limit % 2 == 1
    local chokedcommands = cmd.chokedcommands
    local cmd_p = chokedcommands % 2 == 0
    local doubletap_ref = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    local osaa_ref = ui.get(refs.os[1]) and ui.get(refs.os[2])
    local fd_ref = ui.get(refs.fakeDuck)
    local velocity = get_velocity(entity.get_local_player())
    if doubletap_ref then
        if vars.choked > 2 then
            if cmd.chokedcommands >= 0 then
                cmd_p = false
            end
        end
    end
    vars.choked = cmd.chokedcommands
    if vars.dt_state ~= doubletap_ref then
        vars.doubletap_time = globals.curtime() + 0.25
    end
    if not doubletap_ref and not osaa_ref and not cmd.no_choke or fd_ref then
        if not fl_p then
            if vars.doubletap_time > globals.curtime() then
                if cmd.chokedcommands >= 0 and cmd.chokedcommands < fl_limit then
                    cmd_p = chokedcommands % 2 == 0
                else
                    cmd_p = chokedcommands % 2 == 1
                end
            else
                cmd_p = chokedcommands % 2 == 1
            end
        end
    end
    vars.dt_state = doubletap_ref
    return cmd_p
end

local function apply_desync(cmd, fake)
    local usrcmd = get_input.vfptr.GetUserCmd(ffi.cast("uintptr_t", get_input), 0, cmd.command_number)
    cmd.allow_send_packet = false

    local pitch, yaw = client.camera_angles()

    local can_desync = can_desync(cmd)
    local is_choke = get_choke(cmd)

    ui.set(refs.bodyYaw[1], is_choke and "Static" or "Off")
    if cmd.chokedcommands == 0 then
        vars.yaw = (yaw + 180) - fake*2;
    end

    if can_desync then
        if not usrcmd.hasbeenpredicted then
            if is_choke then
                cmd.yaw = vars.yaw;
            end
        end
    end
end

local color_text = function( string, r, g, b, a)
    local white = "\a" .. func.RGBAtoHEX(255, 255, 255, a)

    local str = ""
    for i, s in ipairs(func.split(string, "$")) do
    end

    return str
end

local animate_text = function(time, string, r, g, b, a)
    local t_out, t_out_iter = { }, 1

    local l = string:len( ) - 1

    local r_add = (0 - r)
    local g_add = (0 - g)
    local b_add = (0 - b)
    local a_add = (255 - a)

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

local function remap(val, newmin, newmax, min, max, clamp)
	min = min or 0
	max = max or 1

	local pct = (val-min)/(max-min)

	if clamp ~= false then
		pct = math.min(1, math.max(0, pct))
	end

	return newmin+(newmax-newmin)*pct
end




-- @region FUNCS end

-- @region UI_LAYOUT start
local tab, container = "AA", "Anti-aimbot angles"
local label = ui.new_label("AA", "Fake lag", "\a659F86FFpoisontech")
local tabPicker = ui.new_combobox("AA", "Fake lag", "\nTab", "Main", "Settings", "Anti-aim")
local aaTabs = ui.new_combobox("AA", "Fake lag", "\nAA Tabs", "Builder", "Other")


local menu = {
    aaTab = {
        lableoth = ui.new_label(tab, container, "\a8AECF1FF•  \aFFFFFFFFBinds"),
        label345 = ui.new_label(tab, container, "\aFFFFFF6F━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
        manualsOverFs = ui.new_checkbox(tab, container, "Manuals over freestanding"),
        legitAAHotkey = ui.new_hotkey(tab, container, "Legit AA"),
        freestand = ui.new_combobox(tab, container, "Freestanding", "Default", "Static"),
        freestandHotkey = ui.new_hotkey(tab, container, "Freestand", true),
        manualsenb = ui.new_checkbox(tab, container, "Enable Manuals"),
        manuals = ui.new_combobox(tab, container, "Manuals", "Off", "Default", "Static"),
        manualTab = {
            manualLeft = ui.new_hotkey(tab, container, "• Manual " .. func.hex({200,200,200}) .. "left"),
            manualRight = ui.new_hotkey(tab, container, "• Manual " .. func.hex({200,200,200}) .. "right"),
            manualForward = ui.new_hotkey(tab, container, "• Manual " .. func.hex({200,200,200}) .. "forward"),
        },
    },
    builderTab = {
        lablesaf = ui.new_label("AA", "Other", "\a659F86FF•  \aFFFFFFFFSafe Functions"),
        labelsafa = ui.new_label("AA", "Other", "\aFFFFFF6F━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
        safeKnife = ui.new_checkbox("AA", "Other", "Safe Knife"),
        safeZeus = ui.new_checkbox("AA", "Other", "Safe Zeus"),
        lableb = ui.new_label(tab, container, "\a659F86FF•  \aFFFFFFFFBuilder"),
        labelsafaa = ui.new_label(tab, container, "\aFFFFFF6F━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
        state = ui.new_combobox(tab, container, "Anti-aim state", vars.aaStates)
    },
    visualsTab = {
        lablev = ui.new_label(tab, container, "\a659F86FF•  \aFFFFFFFFVisuals"),
        vovaputin = ui.new_label(tab, container, "\aFFFFFF6F━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
        indicatorsType = ui.new_checkbox(tab, container, "Enable Indicators"),
        indicatorsClr = ui.new_color_picker(tab, container, "Main Color", lua_color.r, lua_color.g, lua_color.b, 255),
        arrowsindenb = ui.new_checkbox(tab, container, "Enable Arrows Indicator"),
        arrowIndicatorStyle = ui.new_combobox(tab, container, "Arrows", "Standart", "Triangle"),
        arrowClr = ui.new_color_picker(tab, container, "Arrow Color", lua_color.r, lua_color.g, lua_color.b, 255),
        hitlogsenb = ui.new_checkbox(tab, container, "Enable Hitlog"),
        hitlogs_krutie = ui.new_multiselect(tab, container, "Hitlogs", "Hit", "Miss"),
        hitlogs_krutieClr = ui.new_color_picker(tab, container, "Hitlogs Color", lua_color.r, lua_color.g, lua_color.b, 255),
        minimum_damageenb = ui.new_checkbox(tab, container, "Enable Min Damage Indicator"),
        minimum_damageIndicator = ui.new_combobox(tab, container, "Minimum Damage Indicator", "Bind", "Constant"),
        sideIndicatorsenb = ui.new_checkbox(tab, container, "Enable Side indicators"),
        sideIndicators = ui.new_combobox(tab, container,  "\n Side Indicators", "Skeet", "Skeet old"),
    },
    miscTab = {
        labledgdfgs = ui.new_label(tab, container, " "),
        lablevr = ui.new_label(tab, container, "\a659F86FF•  \aFFFFFFFFMisc"),
        vovaputin2 = ui.new_label(tab, container, "\aFFFFFF6F━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
        watermark = ui.new_checkbox(tab, container, "Watermark"),
        watermarkClr = ui.new_color_picker(tab, container, "Watermark Color", lua_color.r, lua_color.g, lua_color.b, 255),
        AvoidBack = ui.new_checkbox(tab, container, "Avoid Backstab"),
        othfunc = ui.new_label("AA", "Other", "\a659F86FF• \aFFFFFFFFOther functions"),
        vovaputin3 = ui.new_label("AA", "Other", " \aFFFFFF6F━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
        filtercons = ui.new_checkbox("AA", "Other", "Console Filter"),
        unsafecharhge = ui.new_checkbox("AA", "Other", "Auto discharge exploit \a4f4f4fff[only scout & awp]"),
        clanTag = ui.new_checkbox(tab, container, "Clantag"),
        dtunsafecharge = ui.new_checkbox("AA", "Other", "Unsafe charge on enemy \a4f4f4fffcharg in visibel"),
        trashTalk = ui.new_checkbox(tab, container, "Trashtalk"),
        trashTalk_vibor = ui.new_multiselect(tab, container, "\n trashtalk vibor", "Kill", "Death"),
        fastLadder = ui.new_checkbox(tab, container, "Fast ladder"),
        animationsEnabled = ui.new_checkbox(tab, container, "\aafaf62ffAnim breakers"),
        animations = ui.new_multiselect(tab, container, "\n Anim breakers", "Broken", "Static legs", "Leg fucker", "0 pitch on landing", "Moonwalk"),
    },
    configTab = {
        label345 = ui.new_label("AA", "Fake lag", "\aFFFFFF6F━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
        label1 = ui.new_label("AA", "Fake lag", "Welcome back \a659F86FF again"),
        label2 = ui.new_label("AA", "Fake lag", "Last update was \a659F86FF 25 november."),
        label3 = ui.new_label("AA", "Fake lag", "Your build is \a659F86FFRenewed."),
        lable1234 = ui.new_label("AA", "Fake lag", "\aFFFFFF6F━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
        label1488 = ui.new_label("AA", "Fake lag", "Session time: zov"),
        label4 = ui.new_label ("AA", "Other", "\a659F86FF• \aFFFFFFFFDiscord"),
        lable123 = ui.new_label("AA", "Other", "\aFFFFFF6F━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
        buttonsd = ui.new_button("AA", "Other", "Join us", function() SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/J35jDMtxhj") end),
        labels = ui.new_label(tab, container, "\a659F86FF•  \aFFFFFFFFPreset \a659F86FFlist"),
        list = ui.new_listbox(tab, container, "Configs", ""),
        name = ui.new_textbox(tab, container, "Config name", ""),
        load = ui.new_button(tab, container, "\a659F86FFLoad", function() end),
        save = ui.new_button(tab, container, "\a00FF0AFFSave", function() end),
        delete = ui.new_button(tab, container, "\aFF0000FFDelete", function() end),
        import = ui.new_button(tab, container, "Import", function() end),
        export = ui.new_button(tab, container, "Export", function() end)
    }
}

local start_time = client.unix_time()
local function get_elapsed_time()
    local elapsed_seconds = client.unix_time() - start_time
    local hours = math.floor(elapsed_seconds / 3600)
    local minutes = math.floor((elapsed_seconds - hours * 3600) / 60)
    local seconds = math.floor(elapsed_seconds - hours * 3600 - minutes * 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local aaBuilder = {}
local aaContainer = {}
for i=1, #vars.aaStates do
    aaContainer[i] = func.hex({200,200,200}) .. "(" .. func.hex({222,55,55}) .. "" .. vars.pStates[i] .. "" .. func.hex({200,200,200}) .. ")" .. func.hex({155,155,155}) .. " "
    aaBuilder[i] = {
        enableState = ui.new_checkbox(tab, container, "Enable " .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({200,200,200}) .. " state"),
        forceDefensive = ui.new_checkbox(tab, container, "Force Defensive\n" .. aaContainer[i]),
        stateDisablers = ui.new_multiselect(tab, container, "Disablers\n" .. aaContainer[i], "Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Crouch-Moving"),
        pitch = ui.new_combobox(tab, container, "Pitch\n" .. aaContainer[i], "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitchSlider = ui.new_slider(tab, container, "\nPitch add" .. aaContainer[i], -89, 89, 0, true, "°", 1),
        yawBase = ui.new_combobox(tab, container, "Yaw base\n" .. aaContainer[i], "Local view", "At targets"),
        yaw = ui.new_combobox(tab, container, "Yaw\n" .. aaContainer[i], "Off", "180", "180 Z", "Spin", "Slow Jitter", "Delay Jitter", "L&R"),
        switchTicks = ui.new_slider(tab, container, "\nticks" .. aaContainer[i], 1, 14, 6, 0),
        yawStatic = ui.new_slider(tab, container, "\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawLeft = ui.new_slider(tab, container, "Left\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawRight = ui.new_slider(tab, container, "Right\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitter = ui.new_combobox(tab, container, "Yaw jitter\n" .. aaContainer[i], "Off", "Offset", "Center", "Skitter", "Random", "3-Way", "L&R"),
        wayFirst = ui.new_slider(tab, container, "First\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        waySecond = ui.new_slider(tab, container, "Second\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        wayThird = ui.new_slider(tab, container, "Third\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterStatic = ui.new_slider(tab, container, "\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterLeft = ui.new_slider(tab, container, "Left\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterRight = ui.new_slider(tab, container, "Right\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        bodyYaw = ui.new_combobox(tab, container, "Body yaw\n" .. aaContainer[i], "Off", "Custom Desync", "Opposite", "Jitter", "Static"),
        bodyYawStatic = ui.new_slider(tab, container, "\nbody yaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        fakeYawLimit = ui.new_slider(tab, container, "Fake yaw limit\n" .. aaContainer[i], -59, 59, 0, true, "°", 1),
        defensiveAntiAim = ui.new_checkbox(tab, container, "Defensive Anti-Aim\n" .. aaContainer[i]),
        def_pitch = ui.new_combobox(tab, container, "[Defensive] Pitch\n" .. aaContainer[i], "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        def_pitchSlider = ui.new_slider(tab, container, "[Defensive] \nPitch add" .. aaContainer[i], -89, 89, 0, true, "°", 1),
        def_yawBase = ui.new_combobox(tab, container, "[Defensive] Yaw base\n" .. aaContainer[i], "Local view", "At targets"),
        def_yaw = ui.new_combobox(tab, container, "[Defensive] Yaw\n" .. aaContainer[i], "Off", "180", "180 Z", "Spin", "Slow Jitter", "Delay Jitter", "L&R"),
        def_switchTicks = ui.new_slider(tab, container, "[Defensive] \nticks" .. aaContainer[i], 1, 14, 6, 0),
        def_yawStatic = ui.new_slider(tab, container, "[Defensive] \nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        def_yawLeft = ui.new_slider(tab, container, "[Defensive] Left\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        def_yawRight = ui.new_slider(tab, container, "[Defensive] Right\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        def_yawJitter = ui.new_combobox(tab, container, "[Defensive] Yaw jitter\n" .. aaContainer[i], "Off", "Offset", "Center", "Skitter", "Random", "3-Way", "L&R"),
        def_wayFirst = ui.new_slider(tab, container, "[Defensive] First\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        def_waySecond = ui.new_slider(tab, container, "[Defensive] Second\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        def_wayThird = ui.new_slider(tab, container, "[Defensive] Third\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        def_yawJitterStatic = ui.new_slider(tab, container, "[Defensive] \nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        def_yawJitterLeft = ui.new_slider(tab, container, "[Defensive] Left\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        def_yawJitterRight = ui.new_slider(tab, container, "[Defensive] Right\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        def_bodyYaw = ui.new_combobox(tab, container, "[Defensive] Body yaw\n" .. aaContainer[i], "Off", "Custom Desync", "Opposite", "Jitter", "Static"),
        def_bodyYawStatic = ui.new_slider(tab, container, "[Defensive] \nbody yaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        def_fakeYawLimit = ui.new_slider(tab, container, "[Defensive] Fake yaw limit\n" .. aaContainer[i], -59, 59, 0, true, "°", 1),
    }
end

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
    local config = {}
    for key, value in pairs(vars.pStates) do
        config[value] = {}
        for k, v in pairs(aaBuilder[key]) do
            config[value][k] = ui.get(v)
        end
    end
    
    clipboard.set(json.stringify(config))
end
local function loadConfig(name)
    local config = getConfig(name)
    loadSettings(config.config)
end

local function initDatabase()
    if database.read(lua.database.configs) == nil then
        database.write(lua.database.configs, {})
    end

    local link = "https://pastebin.com/raw/m0ckzbUb"

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

            local data = {rounding = 0, size = 0, glow = 0, time = 0}

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
            --renderer.text(x/2 + strw2/2, y - 100 - Offset, 255, 255, 255, 255 * fraction, "c", 0, string "$poisontech", r, g, b, a) * fraction  
        end

        for i = #to_remove, 1, -1 do
            table.remove(data, to_remove[i])
        end
    end,

    clear = function()
        data = {}
    end
}


client.set_event_callback("client_disconnect", function() notifications.clear() end)
client.set_event_callback("level_init", function()  notifications.clear() end)
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

local counter = 0
local switch = false

distance_knife = {}
distance_knife.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end
    

client.set_event_callback("run_command", function(cmd)
    vars.breaker.cmd = cmd.command_number
    if cmd.chokedcommands == 0 then
        vars.breaker.origin = vector(entity.get_origin(entity.get_local_player()))
        if vars.breaker.last_origin ~= nil then
            vars.breaker.tp_dist = (vars.breaker.origin - vars.breaker.last_origin):length2dsqr()
            gram_update(vars.breaker.tp_data, vars.breaker.tp_dist, true)
        end
        vars.breaker.last_origin = vars.breaker.origin
    end
end)

client.set_event_callback("predict_command", function(cmd)
    if cmd.command_number == vars.breaker.cmd then
        local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
        vars.breaker.defensive = math.abs(tickbase - vars.breaker.defensive_check)
        vars.breaker.defensive_check = math.max(tickbase, vars.breaker.defensive_check)
        vars.breaker.cmd = 0
    end
end)

client.set_event_callback("setup_command", function(cmd)
    vars.localPlayer = entity.get_local_player()

    if not vars.localPlayer  or not entity.is_alive(vars.localPlayer) then return end
	local flags = entity.get_prop(vars.localPlayer, "m_fFlags")
    local onground = bit.band(flags, 1) ~= 0 and cmd.in_jump == 0
	local valve = entity.get_prop(entity.get_game_rules(), "m_bIsValveDS")
	local origin = vector(entity.get_prop(vars.localPlayer, "m_vecOrigin"))
	local camera = vector(client.camera_angles())
	local eye = vector(client.eye_position())
    local velocity = vector(entity.get_prop(vars.localPlayer, "m_vecVelocity"))
    local weapon = entity.get_player_weapon()
	local pStill = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2) < 5
    local bodyYaw = entity.get_prop(vars.localPlayer, "m_flPoseParameter", 11) * 120 - 60
    local tp_amount = get_average(vars.breaker.tp_data)/get_velocity(entity.get_local_player())*100 
    local is_defensive = (vars.breaker.defensive > 1) and not (tp_amount >= 25 and vars.breaker.defensive >= 13)

    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
	local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
	local isFd = ui.get(refs.fakeDuck)
	local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    local isFl = ui.get(ui.reference("AA", "Fake lag", "Enabled"))
    local legitAA = false

    local manualsOverFs = ui.get(menu.aaTab.manualsOverFs) == true and true or false

    -- search for states
    vars.pState = 1
    if pStill then vars.pState = 2 end
    if not pStill then vars.pState = 3 end
    if isSlow then vars.pState = 4 end
    if entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 5 end
    if not pStill and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 8 end
    if not onground then vars.pState = 6 end
    if not onground and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 7 end

    if ui.get(aaBuilder[9].enableState) and not func.table_contains(ui.get(aaBuilder[9].stateDisablers), vars.intToS[vars.pState]) and isDt == false and isOs == false and isFl == true then
		vars.pState = 9
    end

    if ui.get(aaBuilder[vars.pState].enableState) == false and vars.pState ~= 1 then
        vars.pState = 1
    end

    if cmd.chokedcommands == 0 then
        counter = counter + 1
    end

    if counter >= 8 then
        counter = 0
    end

    if globals.tickcount() % ui.get(aaBuilder[vars.pState].switchTicks) == 1 then
        switch = not switch
    end

    local nextAttack = entity.get_prop(vars.localPlayer, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(vars.localPlayer), "m_flNextPrimaryAttack")
    local dtActive = false
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end
    -- apply antiaim set
    local side = bodyYaw > 0 and 1 or -1

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
                    ui.set(refs.bodyYaw[2], 180)
                    ui.set(refs.pitch[1], "Down")

                    if aa.manualAA == 1 then
                        ui.set(refs.yawBase, "local view")
                        ui.set(refs.yaw[1], "180")
                        ui.set(refs.yaw[2], -90)
                        ui.set(refs.pitch[1], "Down")
                    elseif aa.manualAA == 2 then
                        ui.set(refs.yawBase, "local view")
                        ui.set(refs.yaw[1], "180")
                        ui.set(refs.yaw[2], 90)
                        ui.set(refs.pitch[1], "Down")
                    elseif aa.manualAA == 3 then
                        ui.set(refs.yawBase, "local view")
                        ui.set(refs.yaw[1], "180")
                        ui.set(refs.yaw[2], 180)
                        ui.set(refs.pitch[1], "Down")
                    end
                elseif ui.get(menu.aaTab.manuals) == "Default" and ui.get(aaBuilder[vars.pState].enableState) then
                    if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                        ui.set(refs.yawJitter[1], "Center")
                        local ways = {
                            ui.get(aaBuilder[vars.pState].wayFirst),
                            ui.get(aaBuilder[vars.pState].waySecond),
                            ui.get(aaBuilder[vars.pState].wayThird)
                        }
                        ui.set(refs.yawJitter[2], ways[(globals.tickcount() % 3) + 1] )
                    elseif ui.get(aaBuilder[vars.pState].yawJitter) == "L&R" then
                        ui.set(refs.yawJitter[1], "Center")
                        ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
                    else
                        ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
                        ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic))
                    end

                    ui.set(refs.bodyYaw[1], "Opposite")
                    ui.set(refs.bodyYaw[2], -180)

                    if aa.manualAA == 1 then
                        ui.set(refs.yawBase, "local view")
                        ui.set(refs.yaw[1], "180")
                        ui.set(refs.yaw[2], -90)
                        ui.set(refs.pitch[1], "Down")
                    elseif aa.manualAA == 2 then
                        ui.set(refs.yawBase, "local view")
                        ui.set(refs.yaw[1], "180")
                        ui.set(refs.yaw[2], 90)
                        ui.set(refs.pitch[1], "Down")
                    elseif aa.manualAA == 3 then
                        ui.set(refs.yawBase, "local view")
                        ui.set(refs.yaw[1], "180")
                        ui.set(refs.yaw[2], 180)
                        ui.set(refs.pitch[1], "Down")
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

    if not ui.get(menu.aaTab.legitAAHotkey) and aa.ignore == false then
        if ui.get(aaBuilder[vars.pState].enableState) then

            cmd.force_defensive = ui.get(aaBuilder[vars.pState].forceDefensive) 
            if ui.get(aaBuilder[vars.pState].defensiveAntiAim) and is_defensive then
                if ui.get(aaBuilder[vars.pState].def_pitch) ~= "Custom" then
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].def_pitch))
                else
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].def_pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].def_pitchSlider))
                end
    
                ui.set(refs.yawBase, ui.get(aaBuilder[vars.pState].def_yawBase))
    
                if ui.get(aaBuilder[vars.pState].def_yaw) == "Slow Jitter" then
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], switch and ui.get(aaBuilder[vars.pState].def_yawRight) or ui.get(aaBuilder[vars.pState].def_yawLeft))
                elseif ui.get(aaBuilder[vars.pState].def_yaw) == "Delay Jitter" then
                    ui.set(refs.yaw[1], "180")
                    if counter == 0 then
                        --right
                        ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].def_yawRight))
                    elseif counter == 1 then
                        --left
                        ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].def_yawLeft))
                    elseif counter == 2 then
                        --left
                        ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].def_yawLeft))
                    elseif counter == 3 then
                        --left
                        ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].def_yawLeft))
                    elseif counter == 4 then
                        --right
                       ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].def_yawRight))
                    elseif counter == 5 then
                        --left
                        ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].def_yawLeft))
                    elseif counter == 6 then
                        --right
                       ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].def_yawRight))
                    elseif counter == 7 then
                        --right
                       ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].def_yawRight))
                    end
    
                elseif ui.get(aaBuilder[vars.pState].def_yaw) == "L&R" then
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2],(side == 1 and ui.get(aaBuilder[vars.pState].def_yawLeft) or ui.get(aaBuilder[vars.pState].def_yawRight)))
                else
                    ui.set(refs.yaw[1], ui.get(aaBuilder[vars.pState].def_yaw))
                    ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].def_yawStatic))
                end
    
    
                if ui.get(aaBuilder[vars.pState].def_yawJitter) == "3-Way" then
                    ui.set(refs.yawJitter[1], "Center")
                    local ways = {
                        ui.get(aaBuilder[vars.pState].def_wayFirst),
                        ui.get(aaBuilder[vars.pState].def_waySecond),
                        ui.get(aaBuilder[vars.pState].def_wayThird)
                    }
    
                    ui.set(refs.yawJitter[2], ways[(globals.tickcount() % 3) + 1] )
                elseif ui.get(aaBuilder[vars.pState].def_yawJitter) == "L&R" then 
                    ui.set(refs.yawJitter[1], "Center")
                    ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].def_yawJitterLeft) or ui.get(aaBuilder[vars.pState].def_yawJitterRight)))
                else
                    ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].def_yawJitter))
                    ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].def_yawJitterStatic))
                end
    
                
                if ui.get(aaBuilder[vars.pState].def_bodyYaw) == "Custom Desync" then
                    ui.set(refs.bodyYaw[1], "Opposite")
                    apply_desync(cmd, ui.get(aaBuilder[vars.pState].def_fakeYawLimit))
                else
                    ui.set(refs.bodyYaw[1], ui.get(aaBuilder[vars.pState].def_bodyYaw))
                end
           
                ui.set(refs.bodyYaw[2], (ui.get(aaBuilder[vars.pState].def_bodyYawStatic)))
                ui.set(refs.fsBodyYaw, false)
            else
                if ui.get(aaBuilder[vars.pState].pitch) ~= "Custom" then
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                else
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
                end

                ui.set(refs.yawBase, ui.get(aaBuilder[vars.pState].yawBase))

                if ui.get(aaBuilder[vars.pState].yaw) == "Slow Jitter" then
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawRight) or ui.get(aaBuilder[vars.pState].yawLeft))
                elseif ui.get(aaBuilder[vars.pState].yaw) == "Delay Jitter" then
                    ui.set(refs.yaw[1], "180")
                    if counter == 0 then
                        --right
                        ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawRight))
                    elseif counter == 1 then
                        --left
                        ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawLeft))
                    elseif counter == 2 then
                        --left
                        ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawLeft))
                    elseif counter == 3 then
                        --left
                        ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawLeft))
                    elseif counter == 4 then
                        --right
                    ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawRight))
                    elseif counter == 5 then
                        --left
                        ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawLeft))
                    elseif counter == 6 then
                        --right
                    ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawRight))
                    elseif counter == 7 then
                        --right
                    ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawRight))
                    end

                elseif ui.get(aaBuilder[vars.pState].yaw) == "L&R" then
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2],(side == 1 and ui.get(aaBuilder[vars.pState].yawLeft) or ui.get(aaBuilder[vars.pState].yawRight)))
                else
                    ui.set(refs.yaw[1], ui.get(aaBuilder[vars.pState].yaw))
                    ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawStatic))
                end


                if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                    ui.set(refs.yawJitter[1], "Center")
                    local ways = {
                        ui.get(aaBuilder[vars.pState].wayFirst),
                        ui.get(aaBuilder[vars.pState].waySecond),
                        ui.get(aaBuilder[vars.pState].wayThird)
                    }

                    ui.set(refs.yawJitter[2], ways[(globals.tickcount() % 3) + 1] )
                elseif ui.get(aaBuilder[vars.pState].yawJitter) == "L&R" then 
                    ui.set(refs.yawJitter[1], "Center")
                    ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
                else
                    ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
                    ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic))
                end

                
                if ui.get(aaBuilder[vars.pState].bodyYaw) == "Custom Desync" then
                    ui.set(refs.bodyYaw[1], "Opposite")
                    apply_desync(cmd, ui.get(aaBuilder[vars.pState].fakeYawLimit))
                else
                    ui.set(refs.bodyYaw[1], ui.get(aaBuilder[vars.pState].bodyYaw))
                end
        
                ui.set(refs.bodyYaw[2], (ui.get(aaBuilder[vars.pState].bodyYawStatic)))
                ui.set(refs.fsBodyYaw, false)
            end
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
        if entity.get_classname(entity.get_player_weapon(vars.localPlayer)) == "CC4" then 
            return 
        end
    
        local should_disable = false
        local planted_bomb = entity.get_all("CPlantedC4")[1]
    
        if planted_bomb ~= nil then
            bomb_distance = vector(entity.get_origin(vars.localPlayer)):dist(vector(entity.get_origin(planted_bomb)))
            
            if bomb_distance <= 64 and entity.get_prop(vars.localPlayer, "m_iTeamNum") == 3 then
                should_disable = true
            end
        end
    
        local pitch, yaw = client.camera_angles()
        local direct_vec = vector(func.vec_angles(pitch, yaw))
    
        local eye_pos = vector(client.eye_position())
        local fraction, ent = client.trace_line(vars.localPlayer, eye_pos.x, eye_pos.y, eye_pos.z, eye_pos.x + (direct_vec.x * 8192), eye_pos.y + (direct_vec.y * 8192), eye_pos.z + (direct_vec.z * 8192))
    
        if ent ~= nil and ent ~= -1 then
            if entity.get_classname(ent) == "CPropDoorRotating" then
                should_disable = true
            elseif entity.get_classname(ent) == "CHostage" then
                should_disable = true
            end
        end
        
        if should_disable ~= true then
            ui.set(refs.pitch[1], "Off")
            ui.set(refs.yawBase, "Local view")
            ui.set(refs.yaw[1], "Off")
            ui.set(refs.yaw[2], 0)
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            ui.set(refs.bodyYaw[1], "Opposite")
            ui.set(refs.fsBodyYaw, true)
            ui.set(refs.edgeYaw, false)
            ui.set(refs.roll, 0)
    
            cmd.in_use = 0
            cmd.roll = 0
        end
    end

    
   -- Avoid backstab
   local self = entity.get_local_player()

   local players = entity.get_players(true)
   local eye_x, eye_y, eye_z = client.eye_position()
   returnthat = false 
   if ui.get(menu.miscTab.AvoidBack) ~= 0 then
       if players ~= nil then
           for i, enemy in pairs(players) do
               local head_x, head_y, head_z = entity.hitbox_position(players[i], 5)
               local wx, wy = renderer.world_to_screen(head_x, head_y, head_z)
               local fractions, entindex_hit = client.trace_line(self, eye_x, eye_y, eye_z, head_x, head_y, head_z)
   
               if 250 >= vector(entity.get_prop(enemy, 'm_vecOrigin')):dist(vector(entity.get_prop(self, 'm_vecOrigin'))) and entity.is_alive(enemy) and entity.get_player_weapon(enemy) ~= nil and entity.get_classname(entity.get_player_weapon(enemy)) == 'CKnife' and (entindex_hit == players[i] or fractions == 1) and not entity.is_dormant(players[i]) then
                   ui.set(refs.yaw[2], 180)
                   ui.set(refs.yawBase, "At targets")
                   returnthat = true
               end
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
                ui.set(refs.bodyYaw[1], "Off")
                ui.set(refs.pitch[1], "Down")
            end
            ui.set(refs.freeStand[2], "Always on")
            ui.set(refs.freeStand[1], true)
        end
    else
        ui.set(refs.freeStand[1], false)
        ui.set(refs.freeStand[2], "On hotkey")
    end
    
    -- fast ladder
    local pitch, yaw = client.camera_angles()
    if entity.get_prop(vars.localPlayer, "m_MoveType") == 9 then
        cmd.yaw = math.floor(cmd.yaw+0.5)
        cmd.roll = 0

        if ui.get(menu.miscTab.fastLadder) then
            if cmd.forwardmove > 0 then
                if pitch < 45 then
                    cmd.pitch = 89
                    cmd.in_moveright = 1
                    cmd.in_moveleft = 0
                    cmd.in_forward = 0
                    cmd.in_back = 1
                    if cmd.sidemove == 0 then
                        cmd.yaw = cmd.yaw + 90
                    end
                    if cmd.sidemove < 0 then
                        cmd.yaw = cmd.yaw + 150
                    end
                    if cmd.sidemove > 0 then
                        cmd.yaw = cmd.yaw + 30
                    end
                end 
            end
        end
    end


    if ui.get(menu.builderTab.safeKnife) and vars.pState == 7 and entity.get_classname(entity.get_player_weapon(vars.localPlayer)) == "CKnife" then
        ui.set(refs.pitch[1], "Minimal")
        ui.set(refs.yawBase, "At targets")
        ui.set(refs.yaw[1], "180")
        ui.set(refs.yaw[2], 0)
        ui.set(refs.yawJitter[1], "Offset")
        ui.set(refs.yawJitter[2], 0)
        ui.set(refs.bodyYaw[1], "Static")
        ui.set(refs.bodyYaw[2], 0)
        ui.set(refs.fsBodyYaw, false)
        ui.set(refs.edgeYaw, false)
        ui.set(refs.roll, 0)
    end
    
    if ui.get(menu.builderTab.safeZeus) and vars.pState == 7 and entity.get_classname(entity.get_player_weapon(vars.localPlayer)) == "CWeaponTaser" then
        ui.set(refs.pitch[1], "Down")
        ui.set(refs.yawBase, "At targets")
        ui.set(refs.yaw[1], "180")
        ui.set(refs.yaw[2], 0)
        ui.set(refs.yawJitter[1], "Off")
        ui.set(refs.yawJitter[2], 0)
        ui.set(refs.bodyYaw[1], "Static")
        ui.set(refs.bodyYaw[2], 0)
        ui.set(refs.fsBodyYaw, false)
        ui.set(refs.edgeYaw, false)
        ui.set(refs.roll, 0)
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

    if func.table_contains(ui.get(menu.miscTab.animations), "Broken") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 3)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 7)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 6)
    end

    if func.table_contains(ui.get(menu.miscTab.animations), "Leg fucker") then
        if not legsSaved then
            legsSaved = ui.get(refs.legMovement)
        end
        ui.set_visible(refs.legMovement, false)
        if func.table_contains(ui.get(menu.miscTab.animations), "Leg fucker") then
            ui.set(refs.legMovement, legsTypes[math.random(1, 3)])
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 9,  0)
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

    if func.table_contains(ui.get(menu.miscTab.animations), "Moonwalk") then
        if not legsSaved then
            legsSaved = ui.get(refs.legMovement)
        end
        ui.set_visible(refs.legMovement, false)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
        local me = ent.get_local_player()
        local flags = me:get_prop("m_fFlags")
        local onground = bit.band(flags, 1) ~= 0
        if not onground then
            local my_animlayer = me:get_anim_overlay(6) -- MOVEMENT_MOVE
            my_animlayer.weight = 1
        end
        ui.set(refs.legMovement, "Off")
    elseif (legsSaved == "Off" or legsSaved == "Always slide" or legsSaved == "Never slide") then
        ui.set_visible(refs.legMovement, true)
        ui.set(refs.legMovement, legsSaved)
        legsSaved = false
    end

    if not ui.get(menu.miscTab.animationsEnabled) then
        return
    end
    
end)
-- @region AA_CALLBACKS end

-- @region INDICATORS start
local alpha = 0
local scopedFraction = 0
local acatelScoped = 1
local dtModifier = 0
local barMoveY = 0

local activeFraction = 0
local inactiveFraction = 0
local defensiveFraction = 0
local hideFraction = 0
local hideInactiveFraction = 0
local dtPos = {y = 0}
local osPos = {y = 0}

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
local interval = 0

local indicators_table = {}

local zalupa = function(indicator)
    local is_defensive = (vars.breaker.defensive > 1)
    if indicator.text == 'DT' then
        if is_defensive then
            indicator.r = 130
            indicator.g = 195
            indicator.b = 20
        end
    end

    indicators_table[#indicators_table + 1] = indicator
end

client.set_event_callback("paint", function()
    local local_player = entity.get_local_player()
        vars.localPlayer = entity.get_local_player()
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
    
    -- draw arrows

    if ui.get(menu.visualsTab.arrowsindenb) and ui.get(menu.visualsTab.arrowIndicatorStyle) == "Triangle" then
        renderer.triangle(sizeX / 2 + 40, sizeY / 2 + 1, sizeX / 2 + 30, sizeY / 2 - 6, sizeX / 2 + 30, sizeY / 2 + 7, 
        aa.manualAA == 2 and arrowClr.r or 0, 
        aa.manualAA == 2 and arrowClr.g or 0, 
        aa.manualAA == 2 and arrowClr.b or 0, 
        aa.manualAA == 2 and arrowClr.a or 160)

        renderer.triangle(sizeX / 2 - 40, sizeY / 2 + 1, sizeX / 2 - 30, sizeY / 2 - 6, sizeX / 2 - 30, sizeY / 2 + 7, 
        aa.manualAA == 1 and arrowClr.r or 0, 
        aa.manualAA == 1 and arrowClr.g or 0, 
        aa.manualAA == 1 and arrowClr.b or 0, 
        aa.manualAA == 1 and arrowClr.a or 160)
    end

    if ui.get(menu.visualsTab.arrowsindenb) and ui.get(menu.visualsTab.arrowIndicatorStyle)  == "Standart" then
        alpha = (aa.manualAA == 2 or aa.manualAA == 1) and func.lerp(alpha, 255, globals.frametime() * 20) or func.lerp(alpha, 0, globals.frametime() * 20)
        renderer.text(sizeX / 2 + 60, sizeY / 2 - 2.5, aa.manualAA == 2 and arrowClr.r or 0, aa.manualAA == 2 and arrowClr.g or 0, aa.manualAA == 2 and arrowClr.b or 0, aa.manualAA == 2 and arrowClr.a or 160, "c+", 0, '⮞')
        renderer.text(sizeX / 2 - 60, sizeY / 2 - 2.5, aa.manualAA == 1 and arrowClr.r or 0, aa.manualAA == 1 and arrowClr.g or 0, aa.manualAA == 1 and arrowClr.b or 0, aa.manualAA == 1 and arrowClr.a or 160, "c+", 0, '⮜')
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
    local dpi = ui.get(ui.reference("MISC", "Settings", "DPI scale")):gsub('%%', '') - 100
    local globalFlag = "cd-"
    local globalMoveY = 0
    local indX, indY = renderer.measure_text(globalFlag, "DT")
    local yDefault = 16
    local indCount = 0
    indY = globalFlag == "cd-" and indY - 3 or indY - 2

    local nextAttack = entity.get_prop(vars.localPlayer, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(vars.localPlayer), "m_flNextPrimaryAttack")
    local dtActive = false
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end
    local isCharged = dtActive
    local isFs = ui.get(menu.aaTab.freestandHotkey)
    local isBa = ui.get(refs.forceBaim)
    local isSp = ui.get(refs.safePoint)
    local isQp = ui.get(refs.quickPeek[2])
    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
    local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
    local isFd = ui.get(refs.fakeDuck)
    local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])

    local state = vars.intToS[vars.pState]:upper()

    

    if ui.get(menu.visualsTab.indicatorsType) then
        local strike_w, strike_h = renderer.measure_text("cdb", lua_name )
        local logo = animate_text(globals.curtime(), lua_name, mainClr.r, mainClr.g, mainClr.b, 255)

        glow_module(sizeX/2 + ((strike_w)/2) * scopedFraction - strike_w/2 + 2, sizeY/2 + 20 - dpi/10, strike_w - 3, 0, 10, 0, {mainClr.r, mainClr.g, mainClr.b, 100 * math.abs(math.cos(globals.curtime()*2))}, {mainClr.r, mainClr.g, mainClr.b, 100 * math.abs(math.cos(globals.curtime()*2))})
        renderer.text(sizeX/2 + ((strike_w + 2)/2) * scopedFraction, sizeY/2 + 20 - dpi/10, 155, 0, 0, 0, "cdb", nil, unpack(logo))

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

        local globalMarginX, globalMarginY = renderer.measure_text("-cd", "DSAD")
        globalMarginY = globalMarginY - 2
        local dt_size = renderer.measure_text("-cd", "DT ")
        local ready_size = renderer.measure_text("-cd", "READY")
        renderer.text(sizeX/2 + ((dt_size + ready_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + dtPos.y, 255, 255, 255, activeFraction * 255, "-cd", dt_size + activeFraction * ready_size + 1, "DT ", "\a" .. func.RGBAtoHEX(5, 255, 5, 255 * activeFraction) .. "READY")

        local charging_size = renderer.measure_text("-cd", "WAITING")
        local ret = animate_text(globals.curtime(), "WAITING", 255, 0, 0, 255)
        renderer.text(sizeX/2 + ((dt_size + charging_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + dtPos.y, 255, 255, 255, inactiveFraction * 255, "-cd", dt_size + inactiveFraction * charging_size + 1, "DT ", unpack(ret))

        local defensive_size = renderer.measure_text("-cd", "DEFENSIVE")
        local def = animate_text(globals.curtime(), "DEFENSIVE", mainClr.r, mainClr.g, mainClr.b, 255)
        renderer.text(sizeX/2 + ((dt_size + defensive_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + dtPos.y, 255, 255, 255, defensiveFraction * 255, "-cd", dt_size + defensiveFraction * defensive_size + 1, "DT ", unpack(def))

        local hide_size = renderer.measure_text("-cd", "OSAA ")
        local active_size = renderer.measure_text("-cd", "ACTIVE")
        renderer.text(sizeX/2 + ((hide_size + active_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + osPos.y, 255, 255, 255, hideFraction * 255, "-cd", hide_size + hideFraction * active_size + 1, "OSAA ", "\a" .. func.RGBAtoHEX(255, 255, 0, 255 * hideFraction) .. "ACTIVE")
        
        local inactive_size = renderer.measure_text("-cd", "INACTIVE")
        local osin = animate_text(globals.curtime(), "INACTIVE", 255, 0, 0, 255)
        renderer.text(sizeX/2 + ((hide_size + inactive_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + osPos.y, 255, 255, 255, hideInactiveFraction * 255, "-cd", hide_size + hideInactiveFraction * inactive_size + 1, "OSAA ", unpack(osin))
    
        local state_size = renderer.measure_text("-cd", '>' .. string.upper(state) .. '<')
        renderer.text(sizeX/2 + ((state_size + 2)/2) * scopedFraction, sizeY/2 + 30 , 255, 255, 255, 255, "-cd", 0, '>' .. string.upper(state) .. '<')
    end
    
    -- draw dmg indicator
    if ui.get(menu.visualsTab.minimum_damageIndicator) ~= "-" and entity.get_classname(weapon) ~= "CKnife"  then
        if ui.get(menu.visualsTab.minimum_damageenb) and ui.get(menu.visualsTab.minimum_damageIndicator) == "Constant" then
            if ( ui.get(refs.minimum_damage_override[1]) and ui.get(refs.minimum_damage_override[2]) ) == false then
                renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, ui.get(refs.minimum_damage))
            else
                renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, ui.get(refs.minimum_damage_override[3]))
            end
        elseif ui.get(menu.visualsTab.minimum_damageenb) and ui.get(refs.minimum_damage_override[1]) and ui.get(refs.minimum_damage_override[2]) and ui.get(menu.visualsTab.minimum_damageIndicator) == "Bind" then
            dmg = ui.get(refs.minimum_damage_override[3])
            renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, dmg)
        end
    end

    if ui.get(menu.miscTab.watermark) then
            local clr_r, clr_g, clr_b = ui.get(menu.miscTab.watermarkClr)
        
            local watermaro4ka = animate_text(globals.curtime(), lua_name, clr_r, clr_g, clr_b, 255)
            renderer.text(sizeX/2 - renderer.measure_text("db", lua_name)/2, sizeY - 20, 155, 0, 0, 0, "db", nil, unpack(watermaro4ka))
    end

    if ui.get(menu.visualsTab.sideIndicators) == "Skeet old" then
        local h = select(2, client.screen_size())
        local starting = h - 422
    
        for index, indicator in pairs(indicators_table) do index = index - 1
            local width, height = renderer.measure_text('d+', indicator.text)
            local offset = index * (height - 8)
    
            local y = starting + offset
    
            renderer.text(10, y + 2, indicator.r, indicator.g, indicator.b, indicator.a, 'd+', 0, indicator.text)
        end
    
        indicators_table = {}
    end

    notifications.render()
end)
-- @region INDICATORS end

-- @region UI_CALLBACKS start
ui.set_callback(menu.visualsTab.sideIndicators, function(value)
    local callback = ui.get(value) == 'Skeet old' and client.set_event_callback or client.unset_event_callback
    callback('indicator', zalupa)
end)
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
        notifications.new(string.format('Successfully loaded "$%s$"', name), r, g, b)
    else
        notifications.new(string.format('Failed to load "$%s$"', name), 255, 120, 120)
    end
end)

ui.set_callback(menu.configTab.save, function()

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
    if ui.is_menu_open() then
        ui.set(menu.configTab.label1488, "Session time: \a659F86FF"..get_elapsed_time())
    end
    local isEnabled = true
    ui.set_visible(tabPicker, isEnabled)
    ui.set_visible(aaTabs, ui.get(tabPicker) == "Anti-aim" and isEnabled)
    traverse_table(binds)
    local isAATab = ui.get(tabPicker) == "Anti-aim" and ui.get(aaTabs) == "Other"
    local isBuilderTab = ui.get(tabPicker) == "Anti-aim" and ui.get(aaTabs) == "Builder"
    local isVisualsTab = ui.get(tabPicker) == "Settings" 
    local isMiscTab = ui.get(tabPicker) == "Settings" 
    local isCFGTab = ui.get(tabPicker) == "Main"

    ui.set(aaBuilder[1].enableState, true)
    for i = 1, #vars.aaStates do
        local stateEnabled = ui.get(aaBuilder[i].enableState)
        ui.set_visible(aaBuilder[i].enableState, vars.activeState == i and i~=1 and isBuilderTab and isEnabled)
        ui.set_visible(aaBuilder[i].forceDefensive, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].stateDisablers, vars.activeState == 9 and i == 9 and isBuilderTab and ui.get(aaBuilder[9].enableState) and isEnabled)
        ui.set_visible(aaBuilder[i].pitch, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].pitchSlider , vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].pitch) == "Custom" and isEnabled)
        ui.set_visible(aaBuilder[i].yawBase, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].switchTicks, vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].yaw) == "Slow Jitter" and isEnabled)
        ui.set_visible(aaBuilder[i].yawStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yaw) ~= "Slow Jitter" and ui.get(aaBuilder[i].yaw) ~= "L&R" and ui.get(aaBuilder[i].yaw) ~= "Delay Jitter" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and (ui.get(aaBuilder[i].yaw) == "Slow Jitter" or ui.get(aaBuilder[i].yaw) == "L&R" or ui.get(aaBuilder[i].yaw) == "Delay Jitter") and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and (ui.get(aaBuilder[i].yaw) == "Slow Jitter" or ui.get(aaBuilder[i].yaw) == "L&R" or ui.get(aaBuilder[i].yaw) == "Delay Jitter") and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitter, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].wayFirst, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "3-Way"  and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].waySecond, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "3-Way"  and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].wayThird, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "3-Way"  and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitter) ~= "L&R" and ui.get(aaBuilder[i].yawJitter) ~= "3-Way" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "L&R" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "L&R" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawStatic, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and ui.get(aaBuilder[i].bodyYaw) ~= "Custom Desync" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].fakeYawLimit, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) == "Custom Desync" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].defensiveAntiAim, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)

        ui.set_visible(aaBuilder[i].def_pitch, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_pitchSlider , ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].def_pitch) == "Custom" and isEnabled))
        ui.set_visible(aaBuilder[i].def_yawBase, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yaw, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_switchTicks, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].def_yaw) == "Slow Jitter" and isEnabled))
        ui.set_visible(aaBuilder[i].def_yawStatic, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yaw) ~= "Off" and ui.get(aaBuilder[i].def_yaw) ~= "Slow Jitter" and ui.get(aaBuilder[i].def_yaw) ~= "L&R" and ui.get(aaBuilder[i].def_yaw) ~= "Delay Jitter" and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yawLeft, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yaw) ~= "Off" and (ui.get(aaBuilder[i].def_yaw) == "Slow Jitter" or ui.get(aaBuilder[i].def_yaw) == "L&R" or ui.get(aaBuilder[i].def_yaw) == "Delay Jitter") and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yawRight, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yaw) ~= "Off" and (ui.get(aaBuilder[i].def_yaw) == "Slow Jitter" or ui.get(aaBuilder[i].def_yaw) == "L&R" or ui.get(aaBuilder[i].def_yaw) == "Delay Jitter") and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yawJitter, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_wayFirst, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yaw) ~= "Off" and ui.get(aaBuilder[i].def_yawJitter) == "3-Way"  and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_waySecond, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yaw) ~= "Off" and ui.get(aaBuilder[i].def_yawJitter) == "3-Way"  and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_wayThird, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yaw) ~= "Off" and ui.get(aaBuilder[i].def_yawJitter) == "3-Way"  and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yawJitterStatic, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yaw) ~= "Off" and ui.get(aaBuilder[i].def_yawJitter) ~= "Off" and ui.get(aaBuilder[i].def_yawJitter) ~= "L&R" and ui.get(aaBuilder[i].def_yawJitter) ~= "3-Way" and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yawJitterLeft, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yaw) ~= "Off" and ui.get(aaBuilder[i].def_yawJitter) == "L&R" and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yawJitterRight, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yaw) ~= "Off" and ui.get(aaBuilder[i].def_yawJitter) == "L&R" and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_bodyYaw, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_bodyYawStatic, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_bodyYaw) ~= "Off" and ui.get(aaBuilder[i].def_bodyYaw) ~= "Opposite" and ui.get(aaBuilder[i].def_bodyYaw) ~= "Custom Desync" and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_fakeYawLimit, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_bodyYaw) == "Custom Desync" and isBuilderTab and stateEnabled and isEnabled))
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

    for i, feature in pairs(menu.builderTab) do
		ui.set_visible(feature, isBuilderTab and isEnabled)
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

    ui.set_visible(menu.miscTab.animations, ui.get(menu.miscTab.animationsEnabled) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.trashTalk_vibor, ui.get(menu.miscTab.trashTalk) and (isMiscTab and isEnabled))
    ui.set_visible(menu.visualsTab.indicatorsClr, ui.get(menu.visualsTab.indicatorsType) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.arrowIndicatorStyle, ui.get(menu.visualsTab.arrowsindenb) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.arrowClr, ui.get(menu.visualsTab.arrowsindenb) and ui.get(menu.visualsTab.arrowIndicatorStyle) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.hitlogs_krutie, ui.get(menu.visualsTab.hitlogsenb) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.hitlogs_krutieClr, ui.get(menu.visualsTab.hitlogsenb) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.minimum_damageIndicator, ui.get(menu.visualsTab.minimum_damageenb) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.sideIndicators, ui.get(menu.visualsTab.sideIndicatorsenb) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.aaTab.manuals, ui.get(menu.aaTab.manualsenb) and (isAATab and isEnabled))   

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

-- clantare

local clantag_anim = function(text, indices)
    local text_anim = "               " .. text ..                       "" 
    local tickinterval = globals.tickinterval()
    local tickcount = globals.tickcount() + func.time_to_ticks(client.latency())
    local i = tickcount / func.time_to_ticks(0.2)
    i = math.floor(i % #indices)
    i = indices[i+1]+1
    return string.sub(text_anim, i, i+15)
end

local clantag = {
    steam = steamworks.ISteamFriends,
    prev_ct = "",
    orig_ct = "",
    enb = false,
}

local function get_original_clantag()
    local clan_id = cvar.cl_clanid.get_int()
    if clan_id == 0 then return "\0" end

    local clan_count = clantag.steam.GetClanCount()
    for i = 0, clan_count do 
        local group_id = clantag.steam.GetClanByIndex(i)
        if group_id == clan_id then
            return clantag.steam.GetClanTag(group_id)
        end
    end
end

local function clantag_set()
    local lua_name = "poisontech.gs"
    if ui.get(menu.miscTab.clanTag) then
        if ui.get(ui.reference("Misc", "Miscellaneous", "Clan tag spammer")) then return end

		local clan_tag = clantag_anim(lua_name, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25})

        if entity.get_prop(entity.get_game_rules(), "m_gamePhase") == 5 then
            clan_tag = clantag_anim('poisontech.gs', {10})
            client.set_clan_tag(clan_tag)
        elseif entity.get_prop(entity.get_game_rules(), "m_timeUntilNextPhaseStarts") ~= 0 then
            clan_tag = clantag_anim('poisontech.gs', {10})
            client.set_clan_tag(clan_tag)
        elseif clan_tag ~= clantag.prev_ct  then
            client.set_clan_tag(clan_tag)
        end

        clantag.prev_ct = clan_tag
        clantag.enb = true
    elseif clantag.enb == true then
        client.set_clan_tag(get_original_clantag())
        clantag.enb = false
    end
end

clantag.paint = function()
    if entity.get_local_player() ~= nil then
        if globals.tickcount() % 2 == 0 then
            clantag_set()
        end
    end
end

clantag.run_command = function(e)
    if entity.get_local_player() ~= nil then 
        if e.chokedcommands == 0 then
            clantag_set()
        end
    end
end

clantag.player_connect_full = function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then 
        clantag.orig_ct = get_original_clantag()
    end
end

clantag.shutdown = function()
    client.set_clan_tag(get_original_clantag())
end

client.set_event_callback("paint", clantag.paint)
client.set_event_callback("run_command", clantag.run_command)
client.set_event_callback("player_connect_full", clantag.player_connect_full)
client.set_event_callback("shutdown", clantag.shutdown)

-- clantag close


-- Unsafe charge
local function is_vulnerable()
    for _, v in ipairs(entity.get_players(true)) do
        local flags = (entity.get_esp_data(v)).flags

        if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
            return true
        end
    end

    return false
end

local auto_discharge = function(cmd)
    if not ui.get(menu.miscTab.unsafecharhge) or ui.get(refs.quickPeek[2]) or not ui.get(refs.dt[2]) or 
    (entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponSSG08" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponAWP") then return end

    local vel_2 = math.floor(entity.get_prop(entity.get_local_player(), "m_vecVelocity[2]"))

    if is_vulnerable() and vel_2 > 20 then
        cmd.in_jump = false
        cmd.discharge_pending = true
    end
end

client.set_event_callback("setup_command", function(cmd)
    auto_discharge(cmd)
end)

-- end
local chat_spammer = {}

chat_spammer.phrases = {
    kill = {
        {"cjcb [eq ndfhm", "соси хуй тварь"},
        {"𝕤𝕥𝕚𝕝𝕝 𝕥𝕙𝕖 𝕓𝕖𝕤𝕥 𝕨𝕚𝕥𝕙 𝕡𝕠𝕚𝕤𝕠𝕟𝕥𝕖𝕔𝕙"},
        {"как я тебя трахнул", "крутышка", "ливай с позором"},
        {"я опять тебя выебал", "у меня аа ахуенные", "хуй попадешь"},
        {"долбоеб опять мисснул", "poisontech помогла", "с дефолт пресетом бегаю и ебу хахаахах"},
        {" 。✰302？poisontech✰。"},
        {"сорри за зубы", "иди собирай"},
        {"снова убил нуба"},
        {"сундучек в яндекс еду собрал уже?", "а то я жрать хочу"},
        {"f[f[f[f[[f[", "ахахахахахха", "долбоеб найс кфг"},
        {"ТЕСТ РОСПРЫЖЕЧКИ poisontech GAMESENSE"},
        {"членяку пососал", "опять", "ебанат когда уже играть научишься"},
        {"𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖 𝕨𝕚𝕝𝕝 𝕒𝕝𝕨𝕒𝕪𝕤 𝕓𝕖 𝕒𝕙𝕖𝕒𝕕", "𝕡𝕠𝕚𝕤𝕠𝕟𝕥𝕖𝕔𝕙 𝕨𝕚𝕝𝕝 𝕒𝕝𝕨𝕒𝕪𝕤 𝕓𝕖 𝕒𝕙𝕖𝕒𝕕"},
        {"𝕤𝕙𝕚𝕥 𝕝𝕦𝕒 𝕦𝕤𝕖𝕣 𝕗𝕚𝕟𝕕𝕖𝕕"},
        {"АХХААХА","ХАХАХАХА","ебать ты нищий хуесос"},
        {"stay with us - poisontech"},
        {"К Л О П Н Е П Ы Т А Й С Я П О Б Е Д И Т Ь"},
        {"1."},
    },

    death = {
        {"t,kfy rjyxtysq", "еблан конченый", "ты как убил", "я на ванвее был"},
        {"блять опять анрег", "ебучий сервер", "я заебался уже"},
        {"чит миснул снова"},
        {"ты еблан", "как так играть можно", "просто побежать"},
        {"иди корову дои", "тварь сельская", "заебала уже кд портить"},
        {"и это меня убило", "пиздец"},
        {"блять пиздец", "снова далбаёб убил"},
        {"он же", "не понимает", "что ему повезло"},
        {"пиздец", "читуля обосрался"}
    }
}

chat_spammer.phrase_count = {
    death = 0,
    kill = 0,
}

chat_spammer.handle = function(e)
    if not ui.get(menu.miscTab.trashTalk) then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local victim = client.userid_to_entindex(e.userid)

    if victim == nil then
        return
    end

    local attacker = client.userid_to_entindex(e.attacker)

    if attacker == nil then
        return
    end

    chat_spammer.phrase_count.death = chat_spammer.phrase_count.death + 1
    if chat_spammer.phrase_count.death > #chat_spammer.phrases.death then
        chat_spammer.phrase_count.death = 1
    end

    chat_spammer.phrase_count.kill = chat_spammer.phrase_count.kill + 1
    if chat_spammer.phrase_count.kill > #chat_spammer.phrases.kill then
        chat_spammer.phrase_count.kill = 1
    end

    local phrase = {
        death = chat_spammer.phrases.death[chat_spammer.phrase_count.death],
        kill = chat_spammer.phrases.kill[chat_spammer.phrase_count.kill],
    }

    if func.includes(ui.get(menu.miscTab.trashTalk_vibor), "Kill") then
        if attacker == player and victim ~= player then
            for i = 1, #phrase.kill do
                client.delay_call(i*2, function()
                    client.exec(("say %s"):format(phrase.kill[i]))
                end)
            end
        end
    end

    if func.includes(ui.get(menu.miscTab.trashTalk_vibor), "Death") then
        if attacker ~= player and victim == player then
            for i = 1, #phrase.death do
                client.delay_call(i*2, function()
                    client.exec(("say %s"):format(phrase.death[i]))
                end)
            end
        end
    end
end

local notify_lol = {}

function notify_render() 
    local X, Y = client.screen_size()
    for i, info_noti in ipairs(notify_lol) do
        if i > 7 then
            table.remove(notify_lol, i)
        end
        if info_noti.text ~= nil and info_noti.text ~= "" then
            local color = info_noti.color
            if info_noti.timer + 3.7 < globals.realtime() then
                info_noti.y = func.lerp(info_noti.y, Y + 150, globals.frametime() * 1.5)
                info_noti.alpha = func.lerp(info_noti.alpha, 0, globals.frametime() * 4.5)
            else
                info_noti.y = func.lerp(info_noti.y, Y - 100, globals.frametime() * 1.5)
                info_noti.alpha = func.lerp(info_noti.alpha, 255, globals.frametime() * 4.5)
            end
        end

        local width = vector(renderer.measure_text("c", info_noti.text))
        local r,g,b,a = ui.get(menu.visualsTab.hitlogs_krutieClr)

        glow_module(X /2 - width.x /2 - 10, info_noti.y - i*35 - 48 ,width.x + 20, width.y + 8, 20, 0, {r,g,b,info_noti.alpha - 165}, {13,13,13,info_noti.alpha})
        renderer.text(X / 2 - width.x /2, info_noti.y - i*35 - 44, 255,255,255,info_noti.alpha, "", nil, info_noti.text)

        if info_noti.timer + 4.3 < globals.realtime() then
            table.remove(notify_lol,i)
        end
    end
end

function new_notify(string, r, g, b, a)
    local notification = {
        text = string,
        timer = globals.realtime(),
        color = { r, g, b, a },
        alpha = 0
    }

    local Y = select(2, client.screen_size())

    if #notify_lol == 0 then
        notification.y = Y + 20
    else
        local lastNotification = notify_lol[#notify_lol]
        notification.y = lastNotification.y + 20 
    end

    table.insert(notify_lol, notification)
end

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}

local function aim_hit(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"

    --https://docs.gamesense.gs/docs/events/aim_hit
    if func.includes(ui.get(menu.visualsTab.hitlogs_krutie), "Hit") then
        new_notify(string.format("✨ |  \a75DB67FFHit \aFFFFFFFF%s in the %s for \a75DB67FF%d \aFFFFFFFFdamage (%d health remaining)", entity.get_player_name(e.target), group, e.damage, entity.get_prop(e.target, "m_iHealth") ), 255,255,255,255) 
    end
end

client.set_event_callback("aim_hit", aim_hit)

local function aim_miss(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"

    if func.includes(ui.get(menu.visualsTab.hitlogs_krutie), "Miss") then
        new_notify(string.format("♡ |  \aE05C5CFFMissed \aFFFFFFFF%s (%s) due to \aE05C5CFF%s", entity.get_player_name(e.target), group, e.reason), 255,255,255,255)
    end
end

client.set_event_callback("aim_miss", aim_miss)

client.set_event_callback('player_death', chat_spammer.handle)

client.set_event_callback('shutdown', function ()
    client.set_clan_tag("\0")
    traverse_table_on(refs)
end)

client.set_event_callback('paint_ui', function ()
    local isAATab = ui.get(tabPicker) == "Anti-aim" and ui.get(aaTabs) == "Other"
    if isAATab then
        traverse_table_on(binds)
        else
            traverse_table(binds)
    end 
    notify_render()
    if (globals.mapname() ~= vars.mapname) then
        vars.breaker.cmd = 0
        vars.breaker.defensive = 0
        vars.breaker.defensive_check = 0
        vars.mapname = globals.mapname()
    end
end)

client.set_event_callback("round_start", function()
    vars.breaker.cmd = 0
    vars.breaker.defensive = 0
    vars.breaker.defensive_check = 0
end)

client.set_event_callback("player_connect_full", function(e)
    local ent = client.userid_to_entindex(e.userid)
    if ent == entity.get_local_player() then
        vars.breaker.cmd = 0
        vars.breaker.defensive = 0
        vars.breaker.defensive_check = 0
    end
end)
-- close trash

-- @console filter
ui.set_callback(menu.miscTab.filtercons, function()
    if menu.miscTab.filtercons then
        cvar.developer:set_int(0)
        cvar.con_filter_enable:set_int(1)
        cvar.con_filter_text:set_string("IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN")
        client.exec("con_filter_enable 1")
    else
        cvar.con_filter_enable:set_int(0)
        cvar.con_filter_text:set_string("")
        client.exec("con_filter_enable 0")
    end
end)

client.set_event_callback("shutdown", function()
    cvar.con_filter_enable:set_int(0)
    cvar.con_filter_text:set_string("")
    client.exec("con_filter_enable 0")
end)


---@ Unsafe charge in visible enemy