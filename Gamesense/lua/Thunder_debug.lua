-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- @region LUASETTINGS start
local lua_name = "thunder"
local lua_color = {r = 111, g = 143, b = 175}

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
    build = obex_data.build ~= nil and obex_data.build:gsub("Private", "nightly"):gsub("Beta", "beta"):gsub("User", "live")
}
client.exec("clear")
client.color_log(255, 255, 255, "Welcome to\0")
client.color_log(lua_color.r, lua_color.g, lua_color.b, " thunder\0")
client.color_log(255, 255, 255, ", " .. userdata.username)

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
    aaStates = {"Global", "Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching"},
    pStates = {"G", "S", "M", "SW", "C", "A", "AC"},
	sToInt = {["Global"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["Slowwalking"] = 4, ["Crouching"] = 5, ["Air"] = 6, ["Air-Crouching"] = 7},
    intToS = {[1] = "Global", [2] = "Stand", [3] = "Move", [4] = "Slowwalk", [5] = "Crouch", [6] = "Air", [7] = "Air+C"},
    currentTab = 1,
    activeState = 1,
    pState = 1,
    yaw = 0,
    m1_time = 0,
    choked = 0,
    dt_state = 0,
    doubletap_time = 0,
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

local function remap(val, newmin, newmax, min, max, clamp)
	min = min or 0
	max = max or 1

	local pct = (val-min)/(max-min)

	if clamp ~= false then
		pct = math.min(1, math.max(0, pct))
	end

	return newmin+(newmax-newmin)*pct
end


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
local label = ui.new_label(tab, container, lua_name)
local tabPicker = ui.new_combobox(tab, container, "\nTab", "Anti-aim", "Visuals", "Misc", "Config")
local aaTabs = ui.new_combobox(tab, container, "\nAA Tabs", "Builder", "Keybinds")

local menu = {
    aaTab = {
        safeKnife = ui.new_checkbox(tab, container, "Safe Knife"),
        manualsOverFs = ui.new_checkbox(tab, container, "Manuals over freestanding"),
        legitAAHotkey = ui.new_hotkey(tab, container, "Legit AA"),
        freestand = ui.new_combobox(tab, container, "Freestanding", "Default", "Static"),
        freestandHotkey = ui.new_hotkey(tab, container, "Freestand", true),
        manuals = ui.new_combobox(tab, container, "Manuals", "Off", "Default", "Static"),
        manualTab = {
            manualLeft = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "left"),
            manualRight = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "right"),
            manualForward = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "forward"),
        },
    },
    builderTab = {
        state = ui.new_combobox(tab, container, "Anti-aim state", vars.aaStates)
    },
    visualsTab = {
        indicatorsType = ui.new_combobox(tab, container, "Indicators", "-", "1", "2", "3"),
        indicatorsClr = ui.new_color_picker(tab, container, "Main Color", lua_color.r, lua_color.g, lua_color.b, 255),
        indicatorsStyle = ui.new_multiselect(tab, container, "\n indicator elements", "State", "Doubletap", "Hideshots", "Freestand", "Safepoint", "Body aim", "Fakeduck"),
        arrowIndicatorStyle = ui.new_combobox(tab, container, "Arrows", "-", "TeamSkeet", "TeamSkeet Dynamic", "Modern"),
        arrowClr = ui.new_color_picker(tab, container, "Arrow Color", lua_color.r, lua_color.g, lua_color.b, 255),
        logs = ui.new_multiselect(tab, container, "Notifications", "Hit", "Miss", "Purchase"),
        logsClr = ui.new_color_picker(tab, container, "Logs Color", lua_color.r, lua_color.g, lua_color.b, 255),
        screenIndication = ui.new_multiselect(tab, container, "Screen indication", "Defensive Manager", "Slowdown", "Flag"),
        screenClr = ui.new_color_picker(tab, container, "Screen Color", lua_color.r, lua_color.g, lua_color.b, 255),
    },
    miscTab = {
        fixHideshots = ui.new_checkbox(tab, container, "Fix hideshots"),
        avoidBackstab = ui.new_checkbox(tab, container, "Avoid Backstab"),
        fastLadder = ui.new_multiselect(tab, container, "Fast ladder", "Ascending", "Descending"),
        animations = ui.new_multiselect(tab, container, "Anim breakers", "Static legs", "Moonwalk", "Leg fucker", "0 pitch on landing"),
        minDmgIndicator = ui.new_combobox(tab, container, "Minimum Damage Indicator", "-", "Bind", "Constant"),
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
        enableState = ui.new_checkbox(tab, container, "Enable"),
        forceDefensive = ui.new_checkbox(tab, container, "Force Defensive\n" .. aaContainer[i]),
        pitch = ui.new_combobox(tab, container, "Pitch\n" .. aaContainer[i], "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitchSlider = ui.new_slider(tab, container, "\nPitch add" .. aaContainer[i], -89, 89, 0, true, "°", 1),
        yawBase = ui.new_combobox(tab, container, "Yaw base\n" .. aaContainer[i], "Local view", "At targets"),
        yaw = ui.new_combobox(tab, container, "Yaw\n" .. aaContainer[i], "Off", "180", "180 Z", "Spin", "Slow Yaw", "L&R"),
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

    local link = "https://pastebin.com/raw/Xsz8Vd56"

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
local icon = base64.decode("iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAMAAAAp4XiDAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAnxQTFRFAAAA//+9//+9//+9//+9//+9//++///1///////+///g//+9//+9//+9//+9//+9//+9//+9//+9///Y///h//+9//+9//+9//+9//+9//+9//+9///w///6///A//+9//+9//+9///K///////j//+9//+9//+9//+9//+9///l///9///F//+9//+9//+9//+9//+9///B///7///o//+9//+9//+9//+9//+9//+9///b///K//+9//+9//+9//+9//+9//+9///0///u//+9//+9//+9//+9///P///R//+9//+9//+9//+9///r//+9//+9//+9//+9//+9//+9///E///9///Z//+9//+9//+9//+9//+9///g///5//+///+9//+9//+9//+9//++///4///g//+9///W///8///D//+9//+9//+9///v///m//+9///J///+///I//+9//+9///t//+9//+9//+9//+9///B///P//+9//+9//+9///z//+9//+9//+9//+9///0///3///P///4//+9///W//+9///F///o//+9//+9///k///4///C///6///S//+9///3///p//+9//+9//+9//+9//+9///m///5///C//+9///V//+9//+9///q///6///E//+9///X//+9///R///s//+9///F//+9///Z///R//+9///8///I///b///R///x///e///R//++//+9///n///L//+9///h///S///0//++///p///+///N//++///6///k//+9///W///3//+////u///T///7///s///4///5///CMhoXcAAAANR0Uk5TAAEJFStLcOX/+4s6Hw0DBCE/Z7ShRSQPBy5Vhev2eUYMbK/+03JCBhJR4vykZDkZG2ag+uSIVBMlSXzStW9AFjNdlPLrjlgwc7/CdSItiudeGAocPGqq/c57EChOgdv4nGM3NmGa9tl4yfymaVqQ7OKLtP7BUjHpuIdgQ6LNv59+8KyXTzTx2b3nKp1bmdp2SMX3nO7FedzljYKWqL7j96S0yHCd5/mmbcwewOmEq5nQv5P7r9O+7tW5lX/esifVsfCS1v2tffTPV5nthsGa67vP2Fb58F6+AAADNUlEQVR4nI2U918ScRjHhcO6YhxWLK08M1YmYhbDQhFDqCBlmKVQobZdWVBBkSY2zNJ2aWWlLcv2HrRs7/qHumN01HEHz8/f9+t5P9/v5/ukpOCKQgVoqWPGgtEaN57OYLLw52IKYrLTJkwEsZrE4fIgMoLCBwTpGZMxYsrUTC6PtAsLZqRlTcvGkOlCERsmQyhiCU2aMQMjcmbmyvKoFDKEKpflzyrAkNlzFDSlmAShQDyVunAuRmTP0xQxyL34xdoSXSmGzNeXGQA+mReLyRYZF8Tc8MJFHBMTIvMSK83pi8sxolRXobWQDs+y2uyVS6owZOkytYpH2gSqrnE4l2PEipWu2kQ3nFdXv2o1hqxxOmokZDecAvG4mWvXYcT6DQ12m5X8hgFDY1MzhrRsLDNYrBCFuA0aL00rFq9Nm51uj00C8yEWAYSL15at27w+j0ougYnGCcVre0y8dvh3tuUrfFoTYI3fBhevdr/fv6vD2RDoZPDitwnHazeIqz2cGoIos2C2SLgXT4D7AmaCYIolXdKMcjyRvV9K8GEQL0/3gSo8crCnV1UdH0HC4j2EJw4fccls8f8YhWrpbDyKR44dT+1Sxh8FSYs59QSOOHmquzOP6FnE1exad1Zf/+kzfv/ZKDFwrrKITfAqyEtaAa7WJ6036s/7B6LIhUIHTcknyjJFDCvlXDM9MDi0I0pc1JfUyQm0UIQF8a08wGR39Ue9Ll2+IjIRaYUhhILlstyhqNfVtgANINSKFMs6XCS8FiGuN1XUyWFCrUgh+yIwEvEquKHxceO/e6wakmbvzYjXLafUDFATaIW9boeJ5jveWhtMtsP+97p7b5CTWCvs1RH2ut/nFhQn1Ap5DT4IEQ919bJh0v2NefW1oEROqzFTRb4n/3pV6EJej0YUhiS0Ql6axyjR/sRFT0YL9XI8fYYQVc+NvcEktMJbSY96vRhJR3ZxYi3UK63yJUK8eu2yJ6WFeAXVPW9AcPStMDkt5IsBAve79yD4oVDhsRD/q39GsWg/fgLBz1+8dkZSWugi0yq+gqPfcjlBgi2ERywC9XfwR71akJxWaJEF6T9//fYZhplks/8BZpzQJ9sLkSgAAAAASUVORK5CYII=")
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

            local data = {rounding = 1, size = 4, glow = 10, time = 4}

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
            local strw2 = renderer.measure_text("b", "      ")

            local paddingx, paddingy = 7, data.size
            local offsetY = 100

            Offset = Offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction
            glow_module(x/2 - (strw + strw2)/2 - paddingx, y - offsetY - strh/2 - paddingy - Offset, strw + strw2 + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {r, g, b, 45 * fraction}, {25,25,25,140 * fraction})
            renderer.text(x/2 + strw2/2, y - offsetY - Offset, 255, 255, 255, 255 * fraction, "c", 0, string)
            local icon = images.load_png(icon, 10, 10)
            icon:draw(x/2 - strw/2 - 12.5, y - offsetY - Offset - 7, 20, 15, r, g, b, 255 * fraction, "f")
        
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
	local r, g, b, a = ui.get(menu.visualsTab.logsClr)
    notifications.new(string.format('$%s$ purchased $%s$.', entity.get_player_name(buyer), item), r, g, b)
end

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

local current_tick = func.time_to_ticks(globals.realtime())
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

    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
	local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
	local isFd = ui.get(refs.fakeDuck)
	local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    local legitAA = false

    local manualsOverFs = ui.get(menu.aaTab.manualsOverFs) == true and true or false

    -- search for states
    vars.pState = 1
    if pStill then vars.pState = 2 end
    if not pStill then vars.pState = 3 end
    if isSlow then vars.pState = 4 end
    if entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 5 end
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

    if not ui.get(menu.aaTab.legitAAHotkey) and aa.ignore == false then
        if ui.get(aaBuilder[vars.pState].enableState) then

            cmd.force_defensive = ui.get(aaBuilder[vars.pState].forceDefensive)

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

    -- Avoid backstab
    if ui.get(menu.miscTab.avoidBackstab) then
        local players = entity.get_players(true)
        for i=1, #players do
            local distance = vector(entity.get_origin(vars.localPlayer)):dist(vector(entity.get_origin(players[i])))
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 250 then
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
    
    -- fast ladder
    local pitch, yaw = client.camera_angles()
    if entity.get_prop(vars.localPlayer, "m_MoveType") == 9 then
        cmd.yaw = math.floor(cmd.yaw+0.5)
        cmd.roll = 0

        if func.table_contains(ui.get(menu.miscTab.fastLadder), "Ascending") then
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
        if func.table_contains(ui.get(menu.miscTab.fastLadder), "Descending") then
            if cmd.forwardmove < 0 then
                cmd.pitch = 89
                cmd.in_moveleft = 1
                cmd.in_moveright = 0
                cmd.in_forward = 1
                cmd.in_back = 0
                if cmd.sidemove == 0 then
                    cmd.yaw = cmd.yaw + 90
                end
                if cmd.sidemove > 0 then
                    cmd.yaw = cmd.yaw + 150
                end
                if cmd.sidemove < 0 then
                    cmd.yaw = cmd.yaw + 30
                end
            end
        end
    end

    if ui.get(menu.aaTab.safeKnife) and vars.pState == 7 and entity.get_classname(entity.get_player_weapon(vars.localPlayer)) == "CKnife" then
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
    
end)

ui.set_callback(menu.visualsTab.logs, function() 
    local hitCallback = func.table_contains(ui.get(menu.visualsTab.logs), "Hit") and client.set_event_callback or client.unset_event_callback
    local missCallback = func.table_contains(ui.get(menu.visualsTab.logs), "Miss") and client.set_event_callback or client.unset_event_callback
    local purchaseCallback = func.table_contains(ui.get(menu.visualsTab.logs), "Purchase") and client.set_event_callback or client.unset_event_callback
    missCallback("aim_miss", onMiss)
    hitCallback("aim_hit", onHit)
    purchaseCallback("item_purchase", onPurchase)
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
    if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Modern" then
        alpha = (aa.manualAA == 2 or aa.manualAA == 1) and func.lerp(alpha, 255, globals.frametime() * 3) or func.lerp(alpha, 0, globals.frametime() * 11)
        renderer.text(sizeX / 2 + 45, sizeY / 2 - 2.5, aa.manualAA == 2 and arrowClr.r or 200, aa.manualAA == 2 and arrowClr.g or 200, aa.manualAA == 2 and arrowClr.b or 200, alpha, "c+", 0, '>')
        renderer.text(sizeX / 2 - 45, sizeY / 2 - 2.5, aa.manualAA == 1 and arrowClr.r or 200, aa.manualAA == 1 and arrowClr.g or 200, aa.manualAA == 1 and arrowClr.b or 200, alpha, "c+", 0, '<')
    end

    local velocity = vector(entity.get_prop(vars.localPlayer, "m_vecVelocity"))
    local speed = math.sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y) + (velocity.z * velocity.z))
    if ui.get(menu.visualsTab.arrowIndicatorStyle) == "TeamSkeet Dynamic" then
        if speed ~= nil then
            renderer.triangle(sizeX / 2 + 25 - speed/10 + 35, sizeY / 2 + 2, sizeX / 2 + 37 - speed/10 + 35, sizeY / 2 - 7, sizeX / 2 + 37 - speed/10 + 35, sizeY / 2 + 11, 
            aa.manualAA == 2 and arrowClr.r or 25, 
            aa.manualAA == 2 and arrowClr.g or 25, 
            aa.manualAA == 2 and arrowClr.b or 25, 
            aa.manualAA == 2 and arrowClr.a or 160)
    
            renderer.triangle(sizeX / 2 - 25 + speed/10 - 35, sizeY / 2 + 2, sizeX / 2 - 37 + speed/10 - 35, sizeY / 2 - 7, sizeX / 2 - 37 + speed/10 - 35, sizeY / 2 + 11, 
            aa.manualAA == 1 and arrowClr.r or 25, 
            aa.manualAA == 1 and arrowClr.g or 25, 
            aa.manualAA == 1 and arrowClr.b or 25, 
            aa.manualAA == 1 and arrowClr.a or 160)
            
            renderer.rectangle(sizeX / 2 + 38 - speed/10 + 35, sizeY / 2 - 7, 2, 18, 
            bodyYaw < -10 and arrowClr.r or 25,
            bodyYaw < -10 and arrowClr.g or 25,
            bodyYaw < -10 and arrowClr.b or 25,
            bodyYaw < -10 and arrowClr.a or 160)
            renderer.rectangle(sizeX / 2 - 40 + speed/10 - 35, sizeY / 2 - 7, 2, 18,			
            bodyYaw > 10 and arrowClr.r or 25,
            bodyYaw > 10 and arrowClr.g or 25,
            bodyYaw > 10 and arrowClr.b or 25,
            bodyYaw > 10 and arrowClr.a or 160)
        end
    end

    if ui.get(menu.visualsTab.arrowIndicatorStyle) == "TeamSkeet" then
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

    if ui.get(menu.visualsTab.indicatorsType) == "3" then
        local namex, namey = renderer.measure_text(lua_name:upper())
        local logo = animate_text(globals.curtime(), lua_name:upper(), mainClr.r, mainClr.g, mainClr.b, 255)

        renderer.text(sizeX/2 + ((namex + 2)/2) * scopedFraction, sizeY/2 + 20 - dpi/10, 255, 255, 255, 255, ui.get(menu.visualsTab.indicatorsType) == "3" and "cd-" or "cdb", nil, unpack(logo))
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "State") then
            indCount = indCount + 1
            local namex, namey = renderer.measure_text(globalFlag, globalFlag == "cd-" and lua_name:upper() or lua_name:lower())
            local stateX, stateY = renderer.measure_text(globalFlag, state:upper())
            local string = state:upper()
            renderer.text(sizeX/2 + (stateX + 2)/2 * scopedFraction, sizeY/2 + 20 + namey/1.2, 255, 255, 255, 255, globalFlag, 0, string)
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Doubletap") then
           
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

    local safetyAlert = false
    local enemies = entity.get_players(true)
	for i=1, #enemies do
        if entity.is_dormant(enemies[i]) ~= true then
            if ((bodyYaw >= 40 or bodyYaw <= -40) and func.headVisible(enemies[i])) then
                safetyAlert = true
            else
                safetyAlert = false
            end
        end
	end

    if ui.get(menu.visualsTab.indicatorsType) == "1" then
        local strike_w, strike_h = renderer.measure_text("cdb", lua_name)
        local logo = animate_text(globals.curtime(), lua_name, mainClr.r, mainClr.g, mainClr.b, 255)

        glow_module(sizeX/2 + ((strike_w)/2) * scopedFraction - strike_w/2 + 2, sizeY/2 + 20 - dpi/10, strike_w - 3, 0, 10, 0, {mainClr.r, mainClr.g, mainClr.b, 100 * math.abs(math.cos(globals.curtime()*2))}, {mainClr.r, mainClr.g, mainClr.b, 100 * math.abs(math.cos(globals.curtime()*2))})
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

        local globalMarginX, globalMarginY = renderer.measure_text("-cd", "DSAD")
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

    if ui.get(menu.visualsTab.indicatorsType) == "2" then
        local moveY = 30
        local moveX = 30
        local mainFlag = "-"
        local marginX, marginY = renderer.measure_text(mainFlag, lua_name:upper())
        local sMarginX, sMarginY = renderer.measure_text(mainFlag, "DT")
        sMarginX = sMarginX + 2
        marginY = marginY - 2

        if act then
            if acatelScoped > 0 then
                acatelScoped = func.lerp(acatelScoped, 0 - 0.1, globals.frametime() * 15)
            else
                acatelScoped = 0
            end
        else
            if acatelScoped < 1 then
                acatelScoped = func.lerp(acatelScoped, 1 + 0.1, globals.frametime() * 15)
            else
                acatelScoped = 1
            end
        end
    
        renderer.text(sizeX/2 - moveX * acatelScoped, sizeY/2 + moveY, 255,255,255,255, mainFlag, 0, lua_name:upper())
        renderer.text(sizeX/2 + 2 + marginX - moveX * acatelScoped , sizeY/2 + moveY, mainClr.r, mainClr.g, mainClr.b, math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255, mainFlag, 0, userdata.build:upper())
    
        local text = ui.get(menu.aaTab.freestand):upper()

        local text_length = renderer.measure_text(mainFlag, text)

        renderer.text(sizeX/2 - moveX * acatelScoped, sizeY/2 + moveY + marginY,238, 100, 100, 255, mainFlag, 0, text .. ":")
        local dir_text = safetyAlert == false and "SAFE" or "VIS"

        renderer.text(sizeX/2 + text_length + 2 - moveX * acatelScoped, sizeY/2 + moveY + marginY,  171, 174, 255, 255, mainFlag, 0, dir_text)        

        if not isDt then
            renderer.text(sizeX/2 - moveX * acatelScoped, sizeY/2 + moveY + marginY*2, 255,255,255,100, mainFlag, 0, "DT")
        else
            renderer.text(sizeX/2 - moveX * acatelScoped, sizeY/2 + moveY + marginY*2, isCharged and 0 or 255, isCharged and 255 or 0, 0, 255, mainFlag, 0, "DT")
        end
        
        renderer.text(sizeX/2 + ((renderer.measure_text(mainFlag, "DT") + 1)) - moveX * acatelScoped, sizeY/2 + moveY + marginY*2, 255,255,255, isOs and 255 or 100, mainFlag, 0, "HS")
        renderer.text(sizeX/2 + ((renderer.measure_text(mainFlag, "HS") + 0.5))*2 - moveX * acatelScoped, sizeY/2 + moveY + marginY*2, 255,255,255, isFs and 255 or 100, mainFlag, 0, "FS")


        renderer.text(sizeX/2 + ((renderer.measure_text(mainFlag, "FS") + 1.5))*3 - moveX * acatelScoped, sizeY/2 + moveY + marginY*2, 255,255,255, 255, mainFlag, 0, aa.manualAA == 1 and "M:L" or aa.manualAA == 2 and "M:R" or aa.manualAA == 3 and "M:F" or "AT")
    end

    local modifier = entity.get_prop(local_player, "m_flVelocityModifier")
    local a = remap(modifier, 1, 0, 0.85, 1)

    local warning = images.load_png(base64.decode("iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAMAAAAp4XiDAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAnxQTFRFAAAA//+9//+9//+9//+9//+9//++///1///////+///g//+9//+9//+9//+9//+9//+9//+9//+9///Y///h//+9//+9//+9//+9//+9//+9//+9///w///6///A//+9//+9//+9///K///////j//+9//+9//+9//+9//+9///l///9///F//+9//+9//+9//+9//+9///B///7///o//+9//+9//+9//+9//+9//+9///b///K//+9//+9//+9//+9//+9//+9///0///u//+9//+9//+9//+9///P///R//+9//+9//+9//+9///r//+9//+9//+9//+9//+9//+9///E///9///Z//+9//+9//+9//+9//+9///g///5//+///+9//+9//+9//+9//++///4///g//+9///W///8///D//+9//+9//+9///v///m//+9///J///+///I//+9//+9///t//+9//+9//+9//+9///B///P//+9//+9//+9///z//+9//+9//+9//+9///0///3///P///4//+9///W//+9///F///o//+9//+9///k///4///C///6///S//+9///3///p//+9//+9//+9//+9//+9///m///5///C//+9///V//+9//+9///q///6///E//+9///X//+9///R///s//+9///F//+9///Z///R//+9///8///I///b///R///x///e///R//++//+9///n///L//+9///h///S///0//++///p///+///N//++///6///k//+9///W///3//+////u///T///7///s///4///5///CMhoXcAAAANR0Uk5TAAEJFStLcOX/+4s6Hw0DBCE/Z7ShRSQPBy5Vhev2eUYMbK/+03JCBhJR4vykZDkZG2ag+uSIVBMlSXzStW9AFjNdlPLrjlgwc7/CdSItiudeGAocPGqq/c57EChOgdv4nGM3NmGa9tl4yfymaVqQ7OKLtP7BUjHpuIdgQ6LNv59+8KyXTzTx2b3nKp1bmdp2SMX3nO7FedzljYKWqL7j96S0yHCd5/mmbcwewOmEq5nQv5P7r9O+7tW5lX/esifVsfCS1v2tffTPV5nthsGa67vP2Fb58F6+AAADNUlEQVR4nI2U918ScRjHhcO6YhxWLK08M1YmYhbDQhFDqCBlmKVQobZdWVBBkSY2zNJ2aWWlLcv2HrRs7/qHumN01HEHz8/f9+t5P9/v5/ukpOCKQgVoqWPGgtEaN57OYLLw52IKYrLTJkwEsZrE4fIgMoLCBwTpGZMxYsrUTC6PtAsLZqRlTcvGkOlCERsmQyhiCU2aMQMjcmbmyvKoFDKEKpflzyrAkNlzFDSlmAShQDyVunAuRmTP0xQxyL34xdoSXSmGzNeXGQA+mReLyRYZF8Tc8MJFHBMTIvMSK83pi8sxolRXobWQDs+y2uyVS6owZOkytYpH2gSqrnE4l2PEipWu2kQ3nFdXv2o1hqxxOmokZDecAvG4mWvXYcT6DQ12m5X8hgFDY1MzhrRsLDNYrBCFuA0aL00rFq9Nm51uj00C8yEWAYSL15at27w+j0ougYnGCcVre0y8dvh3tuUrfFoTYI3fBhevdr/fv6vD2RDoZPDitwnHazeIqz2cGoIos2C2SLgXT4D7AmaCYIolXdKMcjyRvV9K8GEQL0/3gSo8crCnV1UdH0HC4j2EJw4fccls8f8YhWrpbDyKR44dT+1Sxh8FSYs59QSOOHmquzOP6FnE1exad1Zf/+kzfv/ZKDFwrrKITfAqyEtaAa7WJ6036s/7B6LIhUIHTcknyjJFDCvlXDM9MDi0I0pc1JfUyQm0UIQF8a08wGR39Ue9Ll2+IjIRaYUhhILlstyhqNfVtgANINSKFMs6XCS8FiGuN1XUyWFCrUgh+yIwEvEquKHxceO/e6wakmbvzYjXLafUDFATaIW9boeJ5jveWhtMtsP+97p7b5CTWCvs1RH2ut/nFhQn1Ap5DT4IEQ919bJh0v2NefW1oEROqzFTRb4n/3pV6EJej0YUhiS0Ql6axyjR/sRFT0YL9XI8fYYQVc+NvcEktMJbSY96vRhJR3ZxYi3UK63yJUK8eu2yJ6WFeAXVPW9AcPStMDkt5IsBAve79yD4oVDhsRD/q39GsWg/fgLBz1+8dkZSWugi0yq+gqPfcjlBgi2ERywC9XfwR71akJxWaJEF6T9//fYZhplks/8BZpzQJ9sLkSgAAAAASUVORK5CYII="))
    local iconX, iconY = warning:measure(nil, 35)
    local bars = 0
    if func.table_contains(ui.get(menu.visualsTab.screenIndication), "Slowdown") and entity.get_prop(local_player, "m_flVelocityModifier") ~= 1 then
        local r, g, b = ui.get(menu.visualsTab.screenClr)
        local text = "slowed down"
        interval = interval + (1-modifier) * 0.7 + 0.3
        
        local warning = images.load_png(base64.decode("iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAMAAAAp4XiDAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAnxQTFRFAAAA//+9//+9//+9//+9//+9//++///1///////+///g//+9//+9//+9//+9//+9//+9//+9//+9///Y///h//+9//+9//+9//+9//+9//+9//+9///w///6///A//+9//+9//+9///K///////j//+9//+9//+9//+9//+9///l///9///F//+9//+9//+9//+9//+9///B///7///o//+9//+9//+9//+9//+9//+9///b///K//+9//+9//+9//+9//+9//+9///0///u//+9//+9//+9//+9///P///R//+9//+9//+9//+9///r//+9//+9//+9//+9//+9//+9///E///9///Z//+9//+9//+9//+9//+9///g///5//+///+9//+9//+9//+9//++///4///g//+9///W///8///D//+9//+9//+9///v///m//+9///J///+///I//+9//+9///t//+9//+9//+9//+9///B///P//+9//+9//+9///z//+9//+9//+9//+9///0///3///P///4//+9///W//+9///F///o//+9//+9///k///4///C///6///S//+9///3///p//+9//+9//+9//+9//+9///m///5///C//+9///V//+9//+9///q///6///E//+9///X//+9///R///s//+9///F//+9///Z///R//+9///8///I///b///R///x///e///R//++//+9///n///L//+9///h///S///0//++///p///+///N//++///6///k//+9///W///3//+////u///T///7///s///4///5///CMhoXcAAAANR0Uk5TAAEJFStLcOX/+4s6Hw0DBCE/Z7ShRSQPBy5Vhev2eUYMbK/+03JCBhJR4vykZDkZG2ag+uSIVBMlSXzStW9AFjNdlPLrjlgwc7/CdSItiudeGAocPGqq/c57EChOgdv4nGM3NmGa9tl4yfymaVqQ7OKLtP7BUjHpuIdgQ6LNv59+8KyXTzTx2b3nKp1bmdp2SMX3nO7FedzljYKWqL7j96S0yHCd5/mmbcwewOmEq5nQv5P7r9O+7tW5lX/esifVsfCS1v2tffTPV5nthsGa67vP2Fb58F6+AAADNUlEQVR4nI2U918ScRjHhcO6YhxWLK08M1YmYhbDQhFDqCBlmKVQobZdWVBBkSY2zNJ2aWWlLcv2HrRs7/qHumN01HEHz8/f9+t5P9/v5/ukpOCKQgVoqWPGgtEaN57OYLLw52IKYrLTJkwEsZrE4fIgMoLCBwTpGZMxYsrUTC6PtAsLZqRlTcvGkOlCERsmQyhiCU2aMQMjcmbmyvKoFDKEKpflzyrAkNlzFDSlmAShQDyVunAuRmTP0xQxyL34xdoSXSmGzNeXGQA+mReLyRYZF8Tc8MJFHBMTIvMSK83pi8sxolRXobWQDs+y2uyVS6owZOkytYpH2gSqrnE4l2PEipWu2kQ3nFdXv2o1hqxxOmokZDecAvG4mWvXYcT6DQ12m5X8hgFDY1MzhrRsLDNYrBCFuA0aL00rFq9Nm51uj00C8yEWAYSL15at27w+j0ougYnGCcVre0y8dvh3tuUrfFoTYI3fBhevdr/fv6vD2RDoZPDitwnHazeIqz2cGoIos2C2SLgXT4D7AmaCYIolXdKMcjyRvV9K8GEQL0/3gSo8crCnV1UdH0HC4j2EJw4fccls8f8YhWrpbDyKR44dT+1Sxh8FSYs59QSOOHmquzOP6FnE1exad1Zf/+kzfv/ZKDFwrrKITfAqyEtaAa7WJ6036s/7B6LIhUIHTcknyjJFDCvlXDM9MDi0I0pc1JfUyQm0UIQF8a08wGR39Ue9Ll2+IjIRaYUhhILlstyhqNfVtgANINSKFMs6XCS8FiGuN1XUyWFCrUgh+yIwEvEquKHxceO/e6wakmbvzYjXLafUDFATaIW9boeJ5jveWhtMtsP+97p7b5CTWCvs1RH2ut/nFhQn1Ap5DT4IEQ919bJh0v2NefW1oEROqzFTRb4n/3pV6EJej0YUhiS0Ql6axyjR/sRFT0YL9XI8fYYQVc+NvcEktMJbSY96vRhJR3ZxYi3UK63yJUK8eu2yJ6WFeAXVPW9AcPStMDkt5IsBAve79yD4oVDhsRD/q39GsWg/fgLBz1+8dkZSWugi0yq+gqPfcjlBgi2ERywC9XfwR71akJxWaJEF6T9//fYZhplks/8BZpzQJ9sLkSgAAAAASUVORK5CYII="))
        local iconX, iconY = warning:measure(nil, 35)
        warning:draw(sizeX/2 - iconX/2, sizeY*0.25 - iconY/2 + 5, nil, 35, r,g,b, 255*a)
    
        -- text
        local textX, textY = renderer.measure_text("c", string.format("%s %d%%", text, modifier*100))
        renderer.text(sizeX/2, sizeY*0.25+iconY, 255, 255, 255, 180*a, "c", 0, string.format("%s \a%s%d%%", text, func.RGBAtoHEX(r,g,b,180*a), modifier*100))
    
        -- bar
        local rx, ry, rw, rh = sizeX/2 - textX/2, sizeY*0.25+iconY + textY, textX, 10
        glow_module(rx - math.floor((textX/2)*modifier) + textX/2, ry, math.floor((rw)*modifier), rh * 0.1, 10, 2, {r, g, b, 180*a}, {r, g, b, 180*a})
        bars = bars + 1
    end

    local dtA = remap(dtModifier, 1, 0, 0.85, 1)
    if func.table_contains(ui.get(menu.visualsTab.screenIndication), "Defensive Manager") and ui.get(refs.dt[3]) == "Defensive" then
        if isDt and isCharged == true then
            if dtModifier < 1 then
                dtModifier = func.lerp(dtModifier, 1 + 0.1, globals.frametime() * 20)
            else
                dtModifier = 1
            end
        elseif isDt and isCharged == false then
            if dtModifier > 0 then
                dtModifier = func.lerp(dtModifier, 0 - 0.1, globals.frametime() * 20)
            else
                dtModifier = 0
            end
        else
            dtModifier = 1
        end

        if bars == 1 then
            if barMoveY < 1 then
                barMoveY = func.lerp(barMoveY, 1 + 0.1, globals.frametime() * 20)
            else
                barMoveY = 1
            end
        else
            if barMoveY > 0 then
                barMoveY = func.lerp(barMoveY, 0 - 0.1, globals.frametime() * 20)
            else
                barMoveY = 0
            end
        end

        local r, g, b = ui.get(menu.visualsTab.screenClr)
        local text = "defensive choking"
        interval = interval + (1-dtModifier) * 0.7 + 0.3
        -- local warningAlpha = math.abs(interval*0.01 % 2 - 1) * 255
    
        -- text
        local textX, textY = renderer.measure_text("c", text)
        renderer.text(sizeX/2, sizeY*0.25+iconY + 30 * barMoveY, 255, 255, 255, 180*dtA, "c", 0, text)
    
        -- bar
        local rx, ry, rw, rh = sizeX/2 - textX/2, sizeY*0.25+iconY + textY, textX, 10
        glow_module(rx - math.floor((textX/2)*dtModifier) + textX/2, ry + 30 * barMoveY, math.floor((rw)*dtModifier), rh * 0.1, 10, 2, {r, g, b, 180*dtA}, {r, g, b, 180*dtA})
    end

    local iconA = 0

    if dtA ~= 0 and func.table_contains(ui.get(menu.visualsTab.screenIndication), "Defensive Manager") and ui.get(refs.dt[3]) == "Defensive" then
        iconA = dtA
    end

    if a ~= 0 and func.table_contains(ui.get(menu.visualsTab.screenIndication), "Slowdown") and entity.get_prop(local_player, "m_flVelocityModifier") ~= 1 then
        iconA = a
    end
    local r, g, b = ui.get(menu.visualsTab.screenClr)
    warning:draw(sizeX/2 - iconX/2, sizeY*0.25 - iconY/2 + 5, nil, 35, r,g,b, 255*iconA)

    if func.table_contains(ui.get(menu.visualsTab.screenIndication), "Flag") then
        local flagimg = renderer.load_png(download, 25, 15)
        if flagimg ~= nil and download ~= nil then
            local mainY = 35
            local marginX, marginY = renderer.measure_text("-d", lua_name:upper())
            renderer.texture(flagimg, 5, sizeY/2 + mainY - 3.2, 25, marginY*2.2, 255, 255, 255, 255, "f")
            renderer.text(33, sizeY/2 - 2 + mainY, 255, 255, 255, 255, "-d", nil, lua_name:upper() .. func.hex({mainClr.r, mainClr.g, mainClr.b}) .. " [" .. userdata.build:upper() .. "]")
            renderer.text(33, sizeY/2 - 4 + marginY + mainY, 255, 255, 255, 255, "-d", nil, "USER - " .. func.hex({mainClr.r, mainClr.g, mainClr.b}) .. userdata.username:upper())
        else
            downloadFile()
        end
    end
    
    -- draw dmg indicator
    if ui.get(menu.miscTab.minDmgIndicator) ~= "-" and entity.get_classname(weapon) ~= "CKnife"  then
        if ui.get(menu.miscTab.minDmgIndicator) == "Constant" then
            if ( ui.get(refs.dmgOverride[1]) and ui.get(refs.dmgOverride[2]) ) == false then
                renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, ui.get(refs.minDmg))
            else
                renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, ui.get(refs.dmgOverride[3]))
            end
        elseif ui.get(refs.dmgOverride[1]) and ui.get(refs.dmgOverride[2]) and ui.get(menu.miscTab.minDmgIndicator) == "Bind" then
            dmg = ui.get(refs.dmgOverride[3])
            renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, dmg)
        end
    end

    notifications.render()
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
    local r, g, b = ui.get(menu.visualsTab.logsClr)
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
    local r, g, b = ui.get(menu.visualsTab.logsClr)

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
    local r, g, b = ui.get(menu.visualsTab.logsClr)
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
    local r, g, b = ui.get(menu.visualsTab.logsClr)

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
    local r, g, b = ui.get(menu.visualsTab.logsClr)
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
    ui.set_visible(tabPicker, isEnabled)
    ui.set_visible(aaTabs, ui.get(tabPicker) == "Anti-aim" and isEnabled)
    local isAATab = ui.get(tabPicker) == "Anti-aim" and ui.get(aaTabs) == "Keybinds"
    local isBuilderTab = ui.get(tabPicker) == "Anti-aim" and ui.get(aaTabs) == "Builder"
    local isVisualsTab = ui.get(tabPicker) == "Visuals" 
    local isMiscTab = ui.get(tabPicker) == "Misc" 
    local isCFGTab = ui.get(tabPicker) == "Config" 

    local aA = func.create_color_array(lua_color.r, lua_color.g, lua_color.b, "thunder")
    ui.set(label, string.format("                   \a%st\a%sh\a%su\a%sn\a%sd\a%se\a%sr", func.RGBAtoHEX(unpack(aA[1])), func.RGBAtoHEX(unpack(aA[2])), func.RGBAtoHEX(unpack(aA[3])), func.RGBAtoHEX(unpack(aA[4])), func.RGBAtoHEX(unpack(aA[5])), func.RGBAtoHEX(unpack(aA[6])),  func.RGBAtoHEX(unpack(aA[7])) ) )

    ui.set(aaBuilder[1].enableState, true)
    for i = 1, #vars.aaStates do
        local stateEnabled = ui.get(aaBuilder[i].enableState)
        ui.set_visible(aaBuilder[i].enableState, vars.activeState == i and i~=1 and isBuilderTab and isEnabled)
        ui.set_visible(aaBuilder[i].forceDefensive, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].pitch, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].pitchSlider , vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].pitch) == "Custom" and isEnabled)
        ui.set_visible(aaBuilder[i].yawBase, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yaw) ~= "Slow Yaw" and ui.get(aaBuilder[i].yaw) ~= "L&R" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and (ui.get(aaBuilder[i].yaw) == "Slow Yaw" or ui.get(aaBuilder[i].yaw) == "L&R") and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and (ui.get(aaBuilder[i].yaw) == "Slow Yaw" or ui.get(aaBuilder[i].yaw) == "L&R") and isBuilderTab and stateEnabled and isEnabled)
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

    ui.set_visible(menu.visualsTab.indicatorsStyle, (ui.get(menu.visualsTab.indicatorsType) == "1" or ui.get(menu.visualsTab.indicatorsType) == "3") and isVisualsTab and isEnabled)
    
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
    if clanTag ~= nil then
        client.set_clan_tag("")
    end
    if dtSaved ~= nil then
        ui.set(refs.dt[3], "Defensive")
    end
    func.setAATab(true)
end)