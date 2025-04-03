local ffi = require("ffi");

--region JSON Library
local function requireJSON()
    local json = {}

    -- Internal functions.
    local function kind_of(obj)
        if type(obj) ~= 'table' then
            return type(obj)
        end
        local i = 1
        for _ in pairs(obj) do
            if obj[i] ~= nil then
                i = i + 1
            else
                return 'table'
            end
        end
        if i == 1 then
            return 'table'
        else
            return 'array'
        end
    end

    local function escape_str(s)
        local in_char = { '\\', '"', '/', '\b', '\f', '\n', '\r', '\t' }
        local out_char = { '\\', '"', '/', 'b', 'f', 'n', 'r', 't' }
        for i, c in ipairs(in_char) do
            s = s:gsub(c, '\\' .. out_char[i])
        end
        return s
    end

    -- Expects the given pos to be the first character after the opening quote.
    -- Returns val, pos; the returned pos is after the closing quote character.
    local function parse_str_val(str, pos, val)
        val = val or ''
        local early_end_error = 'End of input found while parsing string.'
        if pos > #str then
            error(early_end_error)
        end
        local c = str:sub(pos, pos)
        if c == '"' then
            return val, pos + 1
        end
        if c ~= '\\' then
            return parse_str_val(str, pos + 1, val .. c)
        end
        -- We must have a \ character.
        local esc_map = { b = '\b', f = '\f', n = '\n', r = '\r', t = '\t' }
        local nextc = str:sub(pos + 1, pos + 1)
        if not nextc then
            error(early_end_error)
        end
        return parse_str_val(str, pos + 2, val .. (esc_map[nextc] or nextc))
    end

    -- Public values and functions.
    function json.stringify(obj, as_key)
        local s = {}  -- We'll build the string as an array of strings to be concatenated.
        local kind = kind_of(obj)  -- This is 'array' if it's an array or type(obj) otherwise.
        if kind == 'array' then
            if as_key then
                error('Can\'t encode array as key.')
            end
            s[#s + 1] = '['
            for i, val in ipairs(obj) do
                if i > 1 then
                    s[#s + 1] = ', '
                end
                s[#s + 1] = json.stringify(val)
            end
            s[#s + 1] = ']'
        elseif kind == 'table' then
            if as_key then
                error('Can\'t encode table as key.')
            end
            s[#s + 1] = '{'
            for k, v in pairs(obj) do
                if #s > 1 then
                    s[#s + 1] = ', '
                end
                s[#s + 1] = json.stringify(k, true)
                s[#s + 1] = ':'
                s[#s + 1] = json.stringify(v)
            end
            s[#s + 1] = '}'
        elseif kind == 'string' then
            return '"' .. escape_str(obj) .. '"'
        elseif kind == 'number' then
            if as_key then
                return '"' .. tostring(obj) .. '"'
            end
            return tostring(obj)
        elseif kind == 'boolean' then
            return tostring(obj)
        elseif kind == 'nil' then
            return 'null'
        else
            error('Unjsonifiable type: ' .. kind .. '.')
        end
        return table.concat(s)
    end
    return json;
end
--endregion

--region UDP library by SamHoque
ffi.cdef([[
struct sockaddr {
    uint16_t sa_family;
    char sa_data[14];
};

struct addrinfo {
    int ai_flags;
    int ai_family;
    int ai_socktype;
    int ai_protocol;
    size_t ai_addrlen;
    char* ai_canonname;
    struct sockaddr* ai_addr;
    struct addrinfo* ai_next;
};

int getaddrinfo(const char* node, const char* service, const struct addrinfo* hints, struct addrinfo** res);
int sendto(size_t s, const char* buf, int len, int flags, const struct sockaddr* to, int tolen);
size_t socket(int af, int type, int protocol);
]]);
local function getFFIExtension()
    local get_module_handle_sig = memory.find_pattern("engine.dll", " FF 15 ? ? ? ? 85 C0 74 0B") or
            error("couldn't find GetModuleHandle signature")
    local get_proc_address_sig = memory.find_pattern("engine.dll", " FF 15 ? ? ? ? A3 ? ? ? ? EB 05") or
            error("Couldn't find GetProcAddress signature")

    local get_proc_address_addr = ffi.cast("uint32_t**", ffi.cast("uint32_t", get_proc_address_sig) + 2)[0][0]
    local get_proc_address = ffi.cast("void*(__stdcall*)(void*, const char*)", get_proc_address_addr)

    local get_module_handle_addr = ffi.cast("uint32_t**", ffi.cast("uint32_t", get_module_handle_sig) + 2)[0][0]
    local get_module_handle = ffi.cast("void*(__stdcall*)(const char*)", get_module_handle_addr)

    return {
        GetProcAddress = get_proc_address,
        GetModuleHandleA = get_module_handle,
    }
end

local FFIExtension = getFFIExtension();
local ws2_32_dll = FFIExtension.GetModuleHandleA("ws2_32.dll");

local ws2_32 = {
    socket = ffi.cast("size_t(__stdcall*)(int, int, int)",
            FFIExtension.GetProcAddress(ws2_32_dll, "socket")),
    sendto = ffi.cast("int(__stdcall*)(size_t, const char*, int, int, const struct sockaddr*, int)",
            FFIExtension.GetProcAddress(ws2_32_dll, "sendto")),
    getaddrinfo = ffi.cast("int(__stdcall*)(const char*, const char*, const struct addrinfo*, struct addrinfo**)",
            FFIExtension.GetProcAddress(ws2_32_dll, "getaddrinfo")),
}
--[[local ws2_32 = assert(ffi.load("ws2_32"))]]
local AF_INET, IPPROTO_UDP, SOCK_DGRAM = 2, 17, 2

local function udp(host, port)
    local out = ffi.new("struct addrinfo*[1]");
    ws2_32.getaddrinfo(host, tostring(port), ffi.new("struct addrinfo", {
        ai_family = AF_INET,
        ai_socktype = SOCK_DGRAM,
        ai_protocol = IPPROTO_UDP,
        ai_flags = nil,
    }), out)

    --- deref to get the address info
    local addrinfo = out[0]
    local socket = ws2_32.socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
    return {
        send = function(data)
            ws2_32.sendto(socket, data, #data, 0, addrinfo.ai_addr, addrinfo.ai_addrlen)
        end
    }
end
--endregion

--region FFI Extension
local function vtable_entry(instance, index, typ)
    assert(instance ~= nil)
    assert(ffi.cast("void***", instance)[0] ~= nil)
    return ffi.cast(typ, (ffi.cast("void***", instance)[0])[index])
end

local function vtable_bind(module, interface, index, typestring)
    local instance = ffi.cast("void*", memory.create_interface(module, interface) or error("invalid interface"));
    local fnptr = vtable_entry(instance, index, typestring);
    return function(...)
        return fnptr(instance, ...)
    end
end

local function vtable_thunk(i, ct)
    local t = ffi.typeof(ct)
    return function(instance, ...)
        return vtable_entry(instance, i, t)(instance, ...)
    end
end

local GetClientNetworkable = vtable_bind('client.dll', 'VClientEntityList003', 0, 'void*(__thiscall*)(void*, int)')
local GetClientUnknown = vtable_thunk(0, 'void*(__thiscall*)(void*)')
local GetClientRenderable = vtable_thunk(5, 'void*(__thiscall*)(void*)')
local GetModel = vtable_thunk(8, 'const void*(__thiscall*)(void*)')
local NativeGetModelName = vtable_bind("engine.dll", "VModelInfoClient004", 3, "const char*(__thiscall*)(void*, const void*)")

local function GetModelName(ent)
    return ffi.string(NativeGetModelName(GetModel(GetClientRenderable(GetClientUnknown(GetClientNetworkable(ent:get_index()))))));
end

--endregion
--[[math.randomseed(os.time())]]
local function generateRoomID(cheat)
    local res = cheat .. "-"
    for _ = 1, 32 do
        res = res .. string.char(math.random(97, 122))
    end
    return res;
end

local roomID = generateRoomID("prim");

print(roomID);


--region Get Players
local weapon_data_call = ffi.cast("int*(__thiscall*)(void*)", memory.find_pattern("client.dll", "55 8B EC 81 EC 0C 01 ? ? 53 8B D9 56 57 8D 8B"));

--- Sets a structure value using the structure offset pointer
--- @author Sam Hoque
local function modifyStructPointer(struct, index, newValue)
    local address = ffi.cast('uintptr_t*', (ffi.cast('uintptr_t', struct) + index));
    if (newValue) then
        address[0] = newValue;
        return newValue;
    end
    return address[0];
end

local weapons = {};
local function getPlayerWeapon(player)
    if (player:get_active_weapon()) then
        weapons[player:get_index()] = player:get_active_weapon():get_name();
    end
    return weapons[player:get_index()];
end

local cachedWeapons = {};

local function getPlayerWeapons(player)
    if (player:is_dormant()) then
        return cachedWeapons[player:get_index()] or {};
    end

    local weapons = {};

    local m_hMyWeapons = "DT_BaseCombatCharacter", "m_hMyWeapons";
    for i = 0, 48 do
        local handleInt = player:get_prop("m_hMyWeapons", i);
        if (handleInt and handleInt ~= -1) then
            local weapon = entity_list.get_entity(handleInt);
            if (weapon) then
                local weaponName = weapon:get_name();
                if (weaponName) then
                    weapons[#weapons + 1] = weaponName;
                end
            end
        end
    end

    cachedWeapons[player:get_index()] = weapons;
    return weapons;
end

local function getAddress(player_resource, netvar, index, cast)
    return ffi.cast(ffi.typeof(cast), player_resource:get_address() + netvar + index)
end

local getPlayerMoney = function(player)
    return player:get_prop("m_iAccount")
end

local function getPlayers()
    local arr = {};

    local ents = entity_list.get_entities_by_name("CCSPlayer")

    if (not ents) then
        return arr;
    end

    for idx = 1, #ents do
        local player = ents[idx];

        local playerInfo = {
            angle = player:get_prop("m_angEyeAngles[1]"),
            team = player:get_prop("m_iTeamNum"),
            alive = player:is_alive(),
            dormant = player:is_dormant(),
            health = player:get_prop("m_iHealth"),
            weapon = getPlayerWeapon(player),
            weapons = getPlayerWeapons(player),
            money = getPlayerMoney(player),
        }

        playerInfo.name = player:get_name();
        local steamID3, steamID64 = player:get_steamids()
        playerInfo.steamid = steamID64

        if (playerInfo.name ~= "GOTV") then
            local pos = player:get_render_origin();
            playerInfo.pos = {
                x = pos.x,
                y = pos.y,
                z = pos.z,
            }
            table.insert(arr, playerInfo);
        end
    end
    return arr;
end
--endregion


local function getTeamScore(team)
    local CTeam = entity_list.get_entities_by_name("CCSTeam");

    if (not CTeam or #CTeam < 4) then
        return 0
    end

    return CTeam[team == 3 and 4 or 3]:get_prop("m_scoreTotal");
end

local function getC4()
    local CPlantedC4 = entity_list.get_entities_by_name("CPlantedC4");
    if(not CPlantedC4) then
        return;
    end

    if (#CPlantedC4 < 1) then
        return {}
    end

    local plantedC4 = CPlantedC4[1];
    local origin = plantedC4:get_render_origin()
    local m_flC4Blow = plantedC4:get_prop("m_flC4Blow");
    return {
        pos = {
            x = origin.x,
            y = origin.y,
            z = origin.z,
        },
        m_flTimeToExplode = m_flC4Blow - global_vars.cur_time(),
        m_flDefuseCountDown = plantedC4:get_prop("m_flDefuseCountDown") - global_vars.cur_time(),
        m_bBombTicking = plantedC4:get_prop("m_bBombTicking"),
    };
end

local function getRoundTime()
    local is_in_game = engine.is_in_game();
    if (not is_in_game) then
        return 0;
    end

    local m_iRoundTime = game_rules.get_prop("m_iRoundTime");
    local m_fRoundStartTime = game_rules.get_prop("m_fRoundStartTime");
    return math.floor((m_fRoundStartTime + m_iRoundTime) - global_vars.cur_time());
end

local function getGrenades()
    local grenades = {};
    local classes = { "CSmokeGrenadeProjectile", "CDecoyProjectile", "CMolotovProjectile", "CSensorGrenadeProjectile", "CSnowballProjectile", "CBaseCSGrenadeProjectile", "CBreachChargeProjectile", "CBumpMineProjectile", "CInferno" };
    local is_in_game = engine.is_in_game();
    if (not is_in_game) then
        return grenades;
    end
    for i = 1, #classes do
        local class = classes[i];
        --- Remove the first character of the class name, and replace Projectile with nothing.
        local grenadeName = class:gsub("Projectile", ""):sub(2);
        local grenadeClass = entity_list.get_entities_by_name(class);
        for j = 1, #grenadeClass do
            local grenade = grenadeClass[j];
            local velocity = grenade:get_prop("m_vecVelocity");

            if (class == "CBaseCSGrenadeProjectile") then
                local modelName = GetModelName(grenade);
                if (modelName:find("w_eq_flashbang_dropped")) then
                    grenadeName = "FlashBang";
                elseif (modelName:find("w_eq_fraggrenade_dropped")) then
                    if (velocity.x == 0 and velocity.y == 0 and velocity.z == 0) then
                        grenadeName = "Explosion";
                    else
                        grenadeName = "HEGrenade"
                    end
                else
                    goto skip;
                end
            end

            local origin = grenade:get_prop("m_vecOrigin")

            local object = {
                type = grenadeName,
                pos = {
                    x = origin.x,
                    y = origin.y,
                    z = origin.z,
                },
            };

            if (class == "CSmokeGrenadeProjectile") then
                if (velocity.x == 0 and velocity.y == 0 and velocity.z == 0) then
                    object.type = "Smoke";
                end
                local smokeTick = grenade:get_prop("m_nSmokeEffectTickBegin");
                object.time = math.floor((global_vars.tick_count() - smokeTick) * global_vars.interval_per_tick());
            end

            grenades[#grenades + 1] = object;
            :: skip ::
        end
    end
    return grenades;
end

--region Menu

--endregion

--region Cloud Radar
local json = requireJSON();
local isDebug = false;
local IP_ADDRESS, PORT = isDebug and "127.0.0.1" or "139.99.91.208", 3002;
local udpClient = udp(IP_ADDRESS, PORT)
local lastSent = 0;
local radarLink = (isDebug and "http://localhost:3000" or "https://cr.samhoque.dev") .. "/radar/" .. roomID;


local Shell32_dll = FFIExtension.GetModuleHandleA("Shell32.dll");
local ShellExecuteA = ffi.cast("int(__stdcall*)(void*, const char*, const char*, const char*, const char*, int)", FFIExtension.GetProcAddress(Shell32_dll, "ShellExecuteA"));

local native_SetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")

local enable_radar = menu.add_checkbox("Cloud Radar", "Enable", true)
local radar_update_rate = menu.add_slider("Cloud Radar", "Update Rate", 0, 15)

if(radar_update_rate:get() == 0) then
    radar_update_rate:set(5)
end

menu.add_button("Cloud Radar", "Open Radar Link", function()
    ShellExecuteA(nil, "open", radarLink, nil, nil, 1)
end)

menu.add_button("Cloud Radar", "Copy Radar Link", function()
    native_SetClipboardText(radarLink)
end)

menu.add_button("Cloud Radar", "Send Link in Team Chat", function()
    engine.execute_cmd("say_team " .. radarLink:gsub("//", "/\x05/"));
end)

callbacks.add(e_callbacks.PAINT, function()
    if(not enable_radar:get()) then
        return;
    end

    --- Handle Buttons
    local status, error = pcall(function()
        if ((global_vars.real_time() - lastSent) > radar_update_rate:get() * 0.01) then
            lastSent = global_vars.real_time();
            udpClient.send(json.stringify({
                software = "Primordial",
                type = "heartbeat",
                username = user.name,
                map = engine.get_level_name_short(),
                room = roomID,
                players = getPlayers(),
                score = {
                    t = getTeamScore(2),
                    ct = getTeamScore(3),
                },
                c4 = getC4(),
                roundTime = getRoundTime(),
                grenades = getGrenades(),
            }))
        end
    end)

    if (not status) then
        print(error);
    end
end);

callbacks.add(e_callbacks.EVENT, function(event)
    if(not enable_radar:get()) then
        return;
    end

    local status, error = pcall(function()
        local attacker = entity_list.get_player_from_userid(event.userid);
        if (attacker == nil) then
            return
        end
        local pos = attacker:get_render_origin()
        udpClient.send(json.stringify({
            software = "Primordial",
            type = "bullet_impact",
            room = roomID,
            username = user.name,
            map = engine.get_level_name_short(),
            bulletPos = {
                x = event.x,
                y = event.y,
                z = event.z,
            },
            attacker = {
                pos = {
                    x = pos.x,
                    y = pos.y,
                    z = pos.z,
                },
                team = attacker:get_prop("m_iTeamNum"),
            },
        }));
    end)

    if (not status) then
        print(error);
    end
end, "bullet_impact")

callbacks.add(e_callbacks.SHUTDOWN, function()
    if(not enable_radar:get()) then
        return;
    end

    udpClient.send(json.stringify({ software = "Primordial", room = roomID, type = "unload", username = user.name }));
end)
--endregion