-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- @region LUASETTINGS start
local lua_name = "overstar"
local lua_color = {r = 144, g = 170, b = 212}

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
local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'beta', discord=''}
local userdata = {
    username = obex_data.username == nil or obex_data.username,
    build = obex_data.build ~= nil and obex_data.build:gsub("Private", "nightly"):gsub("Beta", "beta"):gsub("User", "live")
}
client.exec("clear")
client.color_log(144, 170, 212,[[

            
_____   _____ _ __ ___| |_ __ _ _ __ 
/ _ \ \ / / _ \ '__/ __| __/ _` | '__|
| (_) \ V /  __/ |  \__ \ || (_| | |   
\___/ \_/ \___|_|  |___/\__\__,_|_|   
                                     
                                     

]])

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
    aaStates = {"Global", "Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Crouch-Moving", "Fakelag"},
    pStates = {"G", "S", "M", "SW", "C", "A", "AC", "CM", "FL"},
	sToInt = {["Global"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["Slowwalking"] = 4, ["Crouching"] = 5, ["Air"] = 6, ["Air-Crouching"] = 7, ["Crouch-Moving"] = 8 , ["Fakelag"] = 9},
    intToS = {[1] = "Global", [2] = "Standing", [3] = "Moving", [4] = "Slowwalking", [5] = "Crouching", [6] = "Air", [7] = "Air-Crouching", [8] = "Crouch-Moving", [9] = "Fakelag"},
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
	http.get(string.format("https://flagcdn.com/w160/%s.png", MyPersonaAPI.GetMyCountryCode():lower()), function(success, response)
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
    aaContainer[i] = func.hex({144, 170, 212}) .. "(" .. func.hex({222,55,55}) .. "" .. vars.pStates[i] .. "" .. func.hex({144, 170, 212}) .. ")" .. func.hex({144, 170, 212}) .. " "
    aaBuilder[i] = {
        enableState = ui.new_checkbox(tab, container, "\a869BC0FF[OverStar] \aFFFFFFFF" .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({144, 170, 212}) .. " Override"),
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
	notifications.new(string.format("Hit %s's $%s$ for $%d$ damage", entity.get_player_name(e.target), group:lower(), e.damage, entity.get_prop(e.target, 'm_iHealth')), r, g, b) 

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

local counter = 0
local switch = false
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

    local warning = images.load_png(base64.decode("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"))
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
            renderer.gradient(3.5, sizeY/2 + mainY - 3, marginX*2.5, marginY*2 - 1, mainClr.r, mainClr.g, mainClr.b, 255, mainClr.r, mainClr.g, mainClr.b, 0, true)
            renderer.texture(flagimg, 5, sizeY/2 + mainY, 25, marginY*1.4, 255, 255, 255, 255, "f")
            renderer.text(33, sizeY/2 - 2 + mainY, 255, 255, 255, 255, "-d", nil, "OVERSTAR" .. func.hex({mainClr.r, mainClr.g, mainClr.b}) .. ".DEV")
            
            -- renderer.text(33, sizeY/2 - 3 + mainY, 255, 255, 255, 255, "-d", nil, "aa" .. func.hex({mainClr.r, mainClr.g, mainClr.b}) .. ".dev")
       
            renderer.text(33, sizeY/2 - 4 + marginY + mainY, 255, 255, 255, 255, "-d", nil, func.hex({mainClr.r, mainClr.g, mainClr.b}) .. "[" .. userdata.build:upper() .. "]")
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
    
    local aA = func.create_color_array(lua_color.r, lua_color.g, lua_color.b, "O V ER S T A R")
    ui.set(label, string.format("\a%so\a%sv\a%se\a%sr\a%ss\a%st\a%sa\a%sr", func.RGBAtoHEX(unpack(aA[1])), func.RGBAtoHEX(unpack(aA[2])), func.RGBAtoHEX(unpack(aA[3])), func.RGBAtoHEX(unpack(aA[4])), func.RGBAtoHEX(unpack(aA[5])), func.RGBAtoHEX(unpack(aA[6])),  func.RGBAtoHEX(unpack(aA[7])),  func.RGBAtoHEX(unpack(aA[8])),  func.RGBAtoHEX(unpack(aA[9])) ) .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. " - live")
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

    ui.set_visible(menu.visualsTab.indicatorsStyle, ui.get(menu.visualsTab.indicatorsType) == "3" and isVisualsTab and isEnabled)
    
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