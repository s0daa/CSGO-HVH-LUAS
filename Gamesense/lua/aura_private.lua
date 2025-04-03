--- @diagnostic disable
local bit_band, bit_bnot, bit_bor, bit_bxor, bit_lshift, bit_tohex = bit.band, bit.bnot, bit.bor, bit.bxor, bit.lshift, bit.tohex;
local absf, ceil, cosf, floor, fmodf, maxf, minf, radf, sinf, sqrtf = math.abs, math.ceil, math.cos, math.floor, math.fmod, math.max, math.min, math.rad, math.sin, math.sqrt;
local string_find, f, string_gmatch, string_gsub, strlen, tolower, string_match, string_sub, toupper = string.find, string.format, string.gmatch, string.gsub, string.len, string.lower, string.match, string.sub, string.upper;
local clear, merge, table_insert, table_remove, table_sort = table.clear, table.concat, table.insert, table.remove, table.sort;

local client_camera_angles, client_color_log, client_create_interface, client_current_threat, client_delay_call, client_error_log, client_exec, client_eye_position, client_find_signature, client_key_state, client_log, client_random_float, client_random_int, client_register_esp_flag, client_scale_damage, client_screen_size, client_set_event_callback, client_system_time, client_timestamp, client_trace_bullet, client_trace_line, client_unix_time, client_unset_event_callback, client_userid_to_entindex = client.camera_angles, client.color_log, client.create_interface, client.current_threat, client.delay_call, client.error_log, client.exec, client.eye_position, client.find_signature, client.key_state, client.log, client.random_float, client.random_int, client.register_esp_flag, client.scale_damage, client.screen_size, client.set_event_callback, client.system_time, client.timestamp, client.trace_bullet, client.trace_line, client.unix_time, client.unset_event_callback, client.userid_to_entindex;
local database_read, database_write = database.read, database.write;
local entity_get_classname, entity_get_esp_data, entity_get_game_rules, entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_player_resource, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_dormant, entity_is_enemy, entity_set_prop = entity.get_classname, entity.get_esp_data, entity.get_game_rules, entity.get_local_player, entity.get_origin, entity.get_player_name, entity.get_player_resource, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_dormant, entity.is_enemy, entity.set_prop;
local globals_chokedcommands, globals_curtime, globals_frametime, globals_realtime, globals_tickcount, globals_tickinterval = globals.chokedcommands, globals.curtime, globals.frametime, globals.realtime, globals.tickcount, globals.tickinterval;
local json_parse, json_stringify = json.parse, json.stringify;
local panorama_loadstring, panorama_open = panorama.loadstring, panorama.open;
local renderer_circle_outline, renderer_indicator, renderer_line, renderer_load_svg, renderer_measure_text, renderer_rectangle, renderer_text, renderer_texture, renderer_triangle, renderer_world_to_screen = renderer.circle_outline, renderer.indicator, renderer.line, renderer.load_svg, renderer.measure_text, renderer.rectangle, renderer.text, renderer.texture, renderer.triangle, renderer.world_to_screen;
local ui_get, ui_is_menu_open, ui_mouse_position, ui_name, ui_new_button, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_hotkey, ui_new_label, ui_new_listbox, ui_new_multiselect, ui_new_slider, ui_new_string, ui_new_textbox, ui_reference, ui_set, ui_set_callback, ui_set_enabled, ui_set_visible, ui_type, ui_update = ui.get, ui.is_menu_open, ui.mouse_position, ui.name, ui.new_button, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_hotkey, ui.new_label, ui.new_listbox, ui.new_multiselect, ui.new_slider, ui.new_string, ui.new_textbox, ui.reference, ui.set, ui.set_callback, ui.set_enabled, ui.set_visible, ui.type, ui.update;

local toticks, vtable_bind, vtable_thunk = toticks, vtable_bind, vtable_thunk;
--- @diagnostic enable

local function LPH_NO_VIRTUALIZE(...)
    return ...;
end

--- packages
local ffi = require "ffi";
local vector = require "vector";

local base64 = require "gamesense/base64";
local clipboard = require "gamesense/clipboard";
local c_entity = require "gamesense/entity";
local c_weapon = require "gamesense/csgo_weapons";

--- defines
local OBEX = obex_fetch ~= nil
    and obex_fetch() or {
        username = "aura",
        build = "[Private]",
        discord = "unknown"
    };

local LUA_NAME = "Aura";
local LUA_UPDATE_WAS = 1694427882;

local USER = OBEX.username;

local BUILD = OBEX.build;
local BUILD_COLOR;

if BUILD == "User" then
    BUILD = "Stable";
end

if BUILD == "Debug" then
    BUILD = "Twilight";
end

if BUILD == "Private" then
    BUILD = "Insiders";
    BUILD_COLOR = "24bfa5ff";
end

--- constants
local PLAYER_FLAGS = {
    FL_ONGROUND = bit_lshift(1, 0),
    FL_FROZEN   = bit_lshift(1, 5)
};

local ESP_FLAGS = {
    HIT = bit_lshift(1, 11)
};

--- enumerations
local e_statement = {
    [0]  = "Main",
    [1]  = "Standing",
    [2]  = "Moving",
    [3]  = "Slow-motion",
    [4]  = "Crouched",
    [5]  = "Move-crouched",
    [6]  = "Airborne",
    [7]  = "Airborne-crouched",
    [8]  = "Defensive",
    [9]  = "Fake Lag"
};

local e_hotkey_mode = {
    [0] = "Always on",
    [1] = "On hotkey",
    [2] = "Toggle",
    [3] = "Off hotkey"
};

--- declarations
local function DUMMY() end

local function u8(s)
    return string_gsub(s, "[\128-\191]", "");
end

local function clamp(x, min, max)
    return maxf(min, minf(x, max));
end

local function lerp(a, b, t)
    return a + t * (b - a);
end

local function sign(x)
    if x > 0 then return 1 end
    if x < 0 then return -1 end

    return 0;
end

local function round(x)
    if x < 0 then
        return ceil(x - 0.5);
    end

    return floor(x + 0.5);
end

local function empty(list)
    return next(list) == nil;
end

local function table_keys(list)
    local keys = { };

    for k, v in pairs(list) do
        keys[v] = k;
    end

    return keys;
end

--- workspace
local assets = { };
local utils = { };

local software = { };
local db = { };

local iinput = { };
local iengineclient = { };
local iclientstate = { };
local ienginesound = { };
local inetchannel = { };

local motion = { };
local decorations = { };
local leg_movement = { };

local exploit = { };
local localplayer = { };
local statement = { };

local menu = { };
local theme = { };
local settings = { };
local override = { };

local home = { };
local profile = { };
local antiaimbot = { };
local visualization = { };

local correction = { };

local angles = { };
local antibruteforce = { };

local yaw_direction = { };
local manual_direction = { };

local avoid_backstab = { };
local safe_head = { };

local break_lc = { };
local defensive = { };

local indicate_state = { };
local connection_info = { };

local drop_grenades = { };
local quick_ladder_move = { };
local hitsound = { };
local animation_breakers = { };

ffi.cdef [[
    typedef struct {
        float x;
        float y;
        float z;
    } vector_t;

    typedef struct {
        void     *vfptr;
        int      command_number;
        int      tickcount;
        vector_t viewangles;
        vector_t aimdirection;
        float    forwardmove;
        float    sidemove;
        float    upmove;
        int      buttons;
        uint8_t  impulse;
        int      weaponselect;
        int      weaponsubtype;
        int      random_seed;
        short    mousedx;
        short    mousedy;
        bool     hasbeenpredicted;
        vector_t headangles;
        vector_t headoffset;
        char	 pad_0x4C[0x18];
    } cusercmd_t;

    typedef struct {
        char   pad_0000[24];                    //0x0000
        int    m_nOutSequenceNr;                //0x0018
        int    m_nInSequenceNr;                 //0x001C
        int    m_nOutSequenceNrAck;             //0x0020
        int    m_nOutReliableState;             //0x0024
        int    m_nInReliableState;              //0x0028
        int    m_nChokedPackets;                //0x002C
        char   pad_0030[108];                   //0x0030
        int    m_Socket;                        //0x009C
        int    m_StreamSocket;                  //0x00A0
        int    m_MaxReliablePayloadSize;        //0x00A4
        char   pad_00A8[100];                   //0x00A8
        float  last_received;                   //0x010C
        float  connect_time;                    //0x0110
        char   pad_0114[4];                     //0x0114
        int    m_Rate;                          //0x0118
        char   pad_011C[4];                     //0x011C
        float  m_fClearTime;                    //0x0120
        char   pad_0124[16688];                 //0x0124
        char   m_Name[32];                      //0x4254
        size_t m_ChallengeNr;                   //0x4274
        float  m_flTimeout;                     //0x4278
        char   pad_427C[32];                    //0x427C
        float  m_flInterpolationAmount;         //0x429C
        float  m_flRemoteFrameTime;             //0x42A0
        float  m_flRemoteFrameTimeStdDeviation; //0x42A4
        int    m_nMaxRoutablePayloadSize;       //0x42A8
        int    m_nSplitPacketSequence;          //0x42AC
        char   pad_42B0[40];                    //0x42B0
        bool   m_bIsValveDS;                    //0x42D8
        char   pad_42D9[65];                    //0x42D9
    } inetchannel_t;

    typedef struct {
        char          pad0[0x9C];                // 0x0000
        inetchannel_t *pNetChannel;              // 0x009C
        int           iChallengeNr;              // 0x00A0
        char          pad1[0x64];                // 0x00A4
        int           iSignonState;              // 0x0108
        char          pad2[0x8];                 // 0x010C
        float         flNextCmdTime;             // 0x0114
        int           nServerCount;              // 0x0118
        int           iCurrentSequence;          // 0x011C
        char          pad3[0x54];                // 0x0120
        int           iDeltaTick;                // 0x0174
        bool          bPaused;                   // 0x0178
        char          pad4[0x7];                 // 0x0179
        int           iViewEntity;               // 0x0180
        int           iPlayerSlot;               // 0x0184
        char          szLevelName[260];          // 0x0188
        char          szLevelNameShort[80];      // 0x028C
        char          szMapGroupName[80];        // 0x02DC
        char          szLastLevelNameShort[80];  // 0x032C
        char          pad5[0xC];                 // 0x037C
        int           nMaxClients;               // 0x0388
        char          pad6[0x498C];              // 0x038C
        float         flLastServerTickTime;      // 0x4D18
        bool          bInSimulation;             // 0x4D1C
        char          pad7[0x3];                 // 0x4D1D
        int           iOldTickcount;             // 0x4D20
        float         flTickRemainder;           // 0x4D24
        float         flFrameTime;               // 0x4D28
        int           iLastOutgoingCommand;      // 0x4D2C
        int           nChokedCommands;           // 0x4D30
        int           iLastCommandAck;           // 0x4D34
        int           iCommandAck;               // 0x4D38
        int           iSoundSequence;            // 0x4D3C
        char          pad8[0x50];                // 0x4D40
        vector_t      angViewPoint;              // 0x4D90
        char          pad9[0xD0];                // 0x4D9C
        void*         pEvents;                   // 0x4E6C
    } iclientstate_t;
]];

--- region assets
do
    assets.svg = {
        icons = {
            alt = [[
                <svg width="192" height="192" viewBox="0 0 192 192" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M77.5767 110.15C77.5767 110.15 72.8588 103.217 73.4445 92.1781C60.0992 97.2436 56.3256 106.995 51.6031 121.745C46.996 131.521 42.7888 133.646 33.3036 133.339C18.2269 132.125 12.8955 124.854 12.0525 108.991C11.9379 106.833 12.0456 104.516 12.0525 102.034C12.3912 99.5634 12.3469 96.8054 12.7959 94.4971C13.4126 91.327 14.171 88.6772 15.0041 85.801C23.775 55.519 45.7954 41.1518 84.6604 34.7842L79.9379 41.741L76.396 51.0168L73.4445 60.2926L71.6736 69.5684V73.6266L72.2639 78.2645L72.8542 79.4239L74.0348 80.0037L75.8057 79.4239L79.9379 75.9455L84.6604 70.1481L89.3828 63.1913L93.515 56.2345L97.0567 49.2776L100.008 40.5816C103.303 24.7712 103.964 15.4004 100.599 0C134.091 15.6 147.316 30.9812 159.629 71.8874C162.865 69.2146 163.82 67.4088 164.351 63.771C177.552 82.0006 181.151 93.8841 179.699 111.889L178.519 124.643C173.045 150.482 165.918 158.987 151.955 171.602C131.352 189.432 116.219 193.929 82.2991 191.313L74.6251 189.574L66.9511 186.675L61.0479 183.777C51.4152 178.589 47.471 157.688 74.6251 156.529C81.7709 156.224 85.769 156.079 87.7811 156.031L93.515 155.369L103.55 152.471L110.634 148.992L115.947 145.514L122.44 140.876C104.819 136.134 96.7006 131.702 91.744 114.208C91.1367 107.615 91.169 103.796 91.744 96.816C84.0114 100.747 77.5767 110.15 77.5767 110.15Z" fill="white"/>
                <path d="M78 132C81.3137 132 84 129.314 84 126C84 122.686 81.3137 120 78 120C74.6863 120 72 122.686 72 126C72 129.314 74.6863 132 78 132Z" fill="white"/>
                </svg>
            ]]
        },

        arrows = {
            renewed = [[
                <svg width="42" height="48" viewBox="0 0 42 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M4.5 46.5L39 27C40.7213 25.9898 40.723 23.507 39 22.5L4.5 1.5C2.08706 0.0899313 0.0631568 2.18039 1.5 4.5L12.3796 23.1798C12.8793 23.9866 12.8803 24.9871 12.3823 25.7948L1.5 43.5C0.0679402 45.8226 2.09 47.915 4.5 46.5Z" fill="white"/>
                </svg>
            ]]
        }
    };

    assets.signatures = {
        iinput = {
            "client.dll",
            "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85",
            1
        }
    };
end

--- region utils
do
    local js = panorama_loadstring [[
        const MONTH_NAMES = [
            "January", "February", "March",
            "April", "May", "June",
            "July", "August", "Moments ago..",
            "October", "November", "December"
        ];

        return {
            new_date(timestamp) {
                return new Date(timestamp);
            },

            get_month_name(month) {
                return MONTH_NAMES[month];
            }
        }
    ]]();

    function utils.is_odd(x)
        return bit_band(x, 1) ~= 0;
    end

    function utils.to_hex(r, g, b, a)
        return f("%02x%02x%02x%02x", r, g, b, a);
    end

    function utils.from_hex(hex)
        hex = string.gsub(hex, "#", "");

        local r = tonumber(string.sub(hex, 1, 2), 16);
        local g = tonumber(string.sub(hex, 3, 4), 16);
        local b = tonumber(string.sub(hex, 5, 6), 16);
        local a = tonumber(string.sub(hex, 7, 8), 16);

        return r, g, b, a or 255;
    end

    function utils.normalize(x, min, max)
        local delta = max - min;

        while x < min do
            x = x + delta;
        end

        while x > max do
            x = x - delta;
        end

        return x;
    end

    function utils.normalize_yaw(x)
        return utils.normalize(x, -180, 180);
    end

    function utils.new_date(timestamp)
        return js.new_date(timestamp);
    end

    function utils.get_month_name(month)
        return js.get_month_name(month);
    end

    function utils.measure_time(time)
        local hours = floor(time / 3600);
        local minutes = floor(time / 60) % 60;
        local seconds = time % 60;

        return hours, minutes, seconds;
    end

    function utils.get_eye_position(ent)
        local x1, y1, z1 = entity_get_origin(ent);
        if x1 == nil then return end

        local x2, y2, z2 = entity_get_prop(ent, "m_vecViewOffset");
        if x2 == nil then return end

        return x1 + x2, y1 + y2, z1 + z2;
    end

    function utils.get_player_weapons(ent)
        local weapons = { };

        for i = 0, 63 do
            local weapon = entity_get_prop(ent, "m_hMyWeapons", i);

            if weapon == nil then
                goto continue;
            end

            weapons[#weapons + 1] = weapon;
            ::continue::
        end

        return weapons;
    end

    function utils.find_signature(module_name, pattern, offset)
        local match = client_find_signature(module_name, pattern);

        if match == nil then
            return nil;
        end

        if offset ~= nil then
            local address = ffi.cast("char*", match);
            address = address + offset;

            return address;
        end

        return match;
    end
end

--- region software
do
    software.rage = {
        weapon = {
            weapon_type = ui_reference("Rage", "Weapon type", "Weapon type")
        },

        aimbot = {
            enabled = { ui_reference("Rage", "Aimbot", "Enabled") },
            target_selection = ui_reference("Rage", "Aimbot", "Target selection"),
            minimum_damage = ui_reference("Rage", "Aimbot", "Minimum damage"),
            minimum_damage_override = { ui_reference("Rage", "Aimbot", "Minimum damage override") },
            prefer_safe_point = ui_reference("Rage", "Aimbot", "Prefer safe point"),
            force_safe_point = ui_reference("Rage", "Aimbot", "Force safe point"),
            force_body_aim = ui_reference("Rage", "Aimbot", "Force body aim"),
            double_tap = { ui_reference("Rage", "Aimbot", "Double tap") }
        },

        other = {
            quick_peek_assist = { ui_reference("Rage", "Other", "Quick peek assist") },
            duck_peek_assist = ui_reference("Rage", "Other", "Duck peek assist")
        }
    };

    software.aa = {
        angles = {
            enabled = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
            pitch = { ui_reference("AA", "Anti-aimbot angles", "Pitch") },
            yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
            yaw = { ui_reference("AA", "Anti-aimbot angles", "Yaw") },
            yaw_jitter = { ui_reference("AA", "Anti-aimbot angles", "Yaw jitter") },
            body_yaw = { ui_reference("AA", "Anti-aimbot angles", "Body yaw") },
            freestanding_body_yaw = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
            edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
            freestanding = { ui_reference("AA", "Anti-aimbot angles", "Freestanding") },
            roll = ui_reference("AA", "Anti-aimbot angles", "Roll")
        },

        fakelag = {
            enabled = { ui_reference("AA", "Fake lag", "Enabled") },
            amount = ui_reference("AA", "Fake lag", "Amount"),
            variance = ui_reference("AA", "Fake lag", "Variance"),
            limit = ui_reference("AA", "Fake lag", "Limit")
        },

        other = {
            slow_motion = { ui_reference("AA", "Other", "Slow motion") },
            leg_movement = ui_reference("AA", "Other", "Leg movement"),
            on_shot_antiaim = { ui_reference("AA", "Other", "On shot anti-aim") },
            fake_peek = { ui_reference("AA", "Other", "Fake peek") }
        }
    };

    software.visuals = {
        colored_models = {
            local_player_transparency =ui_reference("Visuals", "Colored models", "Local player transparency")
        }
    };

    software.misc = {
        miscellaneous = {
            clan_tag_spammer = { ui_reference("Misc", "Miscellaneous", "Clan tag spammer") },
            ping_spike = { ui_reference("Misc", "Miscellaneous", "Ping spike") }
        },

        settings = {
            menu_color = ui_reference("Misc", "Settings", "Menu color"),
            dpi_scale = ui_reference("Misc", "Settings", "DPI scale"),
            sv_maxusrcmdprocessticks = ui_reference("Misc", "Settings", "sv_maxusrcmdprocessticks2")
        }
    };

    function software.is_double_tap()
        return ui_get(software.rage.aimbot.double_tap[1])
            and ui_get(software.rage.aimbot.double_tap[2]);
    end

    function software.is_minimum_damage()
        return ui_get(software.rage.aimbot.minimum_damage_override[1])
            and ui_get(software.rage.aimbot.minimum_damage_override[2]);
    end

    function software.is_quick_peek_assist()
        return ui_get(software.rage.other.quick_peek_assist[1])
            and ui_get(software.rage.other.quick_peek_assist[2]);
    end

    function software.is_on_shot_antiaim()
        return ui_get(software.aa.other.on_shot_antiaim[1])
            and ui_get(software.aa.other.on_shot_antiaim[2]);
    end

    function software.is_slow_motion()
        return ui_get(software.aa.other.slow_motion[1])
            and ui_get(software.aa.other.slow_motion[2]);
    end

    function software.get_color()
        return ui_get(software.misc.settings.menu_color);
    end

    function software.get_dpi_scale()
        local value = ui_get(software.misc.settings.dpi_scale);
        local unit = string_match(value, "(%d+)%%");

        return unit * 0.01;
    end
end

--- region db
do
    local DB_KEY = "me.Aura";

    local data = database_read(DB_KEY) or { };

    function db.get(key)
        return data[key];
    end

    function db.set(key, value)
        data[key] = value;
    end

    function db.save(key)
        if key ~= nil then
            local o_data = database_read(DB_KEY) or { };

            o_data[key] = data[key];
            database_write(DB_KEY, o_data);

            return;
        end

        database_write(DB_KEY, data);
    end

    function db.erase()
        database_write(DB_KEY, nil);
        data = nil;
    end

    function db.shutdown()
        db.save();
    end
end

--- namespace iinput
do
    --- https://gitlab.com/KittenPopo/csgo-2018-source/-/blob/main/game/client/iinput.h

    local address = utils.find_signature(unpack(assets.signatures.iinput));
    local iface = ffi.cast("uintptr_t***", address)[0];

    local native_GetUserCmd = ffi.cast("cusercmd_t*(__thiscall*)(void*, int nSlot, int sequence_number)", iface[0][8]);
    local native_CAM_IsThirdPerson = ffi.cast("bool(__thiscall*)(void*, int nSlot)", iface[0][32]);

    function iinput.get_usercmd(slot, command_number)
        if command_number == 0 then
            return nil;
        end

        return native_GetUserCmd(iface, slot, command_number);
    end

    function iinput.is_third_person(slot)
        slot = slot or -1;

        return native_CAM_IsThirdPerson(iface, slot);
    end
end

--- region ivengineclient
do
    --- https://gitlab.com/KittenPopo/csgo-2018-source/-/blob/main/public/engine/IEngineSound.h

    local native_IsInGame = vtable_bind("engine.dll", "VEngineClient014", 20, "bool(__thiscall*)(void*)");
    local native_IsConnected = vtable_bind("engine.dll", "VEngineClient014", 21, "bool(__thiscall*)(void*)");
    local native_GetTimescale = vtable_bind("engine.dll", "VEngineClient014", 91, "float(__thiscall*)(void*)");

    function iengineclient.is_in_game()
        return native_IsInGame();
    end

    function iengineclient.is_connected()
        return native_IsConnected();
    end

    function iengineclient.get_timescale()
        return native_GetTimescale();
    end
end

--- region iclientstate
do
    local engine = client_create_interface("engine.dll", "VEngineClient014");
    local iface = ffi.cast("void***", engine)[0];

    local address = ffi.cast("uintptr_t", iface[12]) + 0x10;

    function iclientstate.get()
        return ffi.cast("iclientstate_t***", address)[0][0];
    end
end

--- region ienginesound
do
    --- https://gitlab.com/KittenPopo/csgo-2018-source/-/blob/main/public/engine/IEngineSound.h
    local PITCH_NORM = 100;

    local native_EmitAmbientSound = vtable_bind("engine.dll", "IEngineSoundClient003", 12, "int(__thiscall*)(void*, const char *pSample, float flVolume, int iPitch, int flags, float soundtime)");
    local native_IsSoundStillPlaying = vtable_bind("engine.dll", "IEngineSoundClient003", 15, "bool(__thiscall*)(void*, int guid)");
    local native_StopSoundByGuid = vtable_bind("engine.dll", "IEngineSoundClient003", 16, "void(__thiscall*)(void*, int guid, bool bForceSync)");

    local playdata = { };

    function ienginesound.emit_ambient_sound(sample, volume, pitch, flags, soundtime)
        pitch = pitch or PITCH_NORM;
        flags = flags or 0;
        soundtime = soundtime or 0.0;

        return native_EmitAmbientSound(sample, volume, pitch, flags, soundtime);
    end

    function ienginesound.is_sound_still_playing(guid)
        return native_IsSoundStillPlaying(guid);
    end

    function ienginesound.stop_sound_by_guid(guid, force_sync)
        force_sync = force_sync or false;

        return native_StopSoundByGuid(guid, force_sync);
    end

    function ienginesound.playsound(sample, volume, pitch, flags, soundtime)
        local last_guid = playdata[sample] or 0;

        if ienginesound.is_sound_still_playing(last_guid) then
            ienginesound.stop_sound_by_guid(last_guid);
        end

        local guid = ienginesound.emit_ambient_sound(sample, volume, pitch, flags, soundtime);
        playdata[sample] = guid;

        return guid;
    end
end

--- region inetchannel
do
    local native_GetTime = vtable_thunk(2, "float(__thiscall*)(void*)");
    local native_IsLoopBack = vtable_thunk(6, "bool(__thiscall*)(void*)");
    local native_GetLatency = vtable_thunk(9, "float(__thiscall*)(void*, int flow)");
    local native_GetAvgLatency = vtable_thunk(10, "float(__thiscall*)(void*, int flow)");
    local native_GetAvgPackets = vtable_thunk(14, "float(__thiscall*)(void*, int flow)");

    local clientstate = iclientstate.get();

    function inetchannel.get()
        return clientstate.pNetChannel;
    end

    function inetchannel.get_time(netchannel)
        return native_GetTime(netchannel);
    end

    function inetchannel.is_loopback(netchannel)
        return native_IsLoopBack(netchannel);
    end

    function inetchannel.get_latency(netchannel, flow)
        return native_GetLatency(netchannel, flow);
    end

    function inetchannel.get_avg_latency(netchannel, flow)
        return native_GetAvgLatency(netchannel, flow);
    end

    function inetchannel.get_avg_packets(netchannel, flow)
        return native_GetAvgPackets(netchannel, flow);
    end
end

--- region motion
do
    local function linear(t, b, c, d)
        return c * t / d + b;
    end

    local function get_deltatime()
        return globals_frametime() / iengineclient.get_timescale();
    end

    local function solve(easing_fn, prev, new, clock, duration)
        if clock <= 0 then return new end
        if clock >= duration then return new end

        prev = easing_fn(clock, prev, new - prev, duration);

        if type(prev) == "number" then
            if absf(new - prev) < 0.001 then
                return new;
            end

            local remainder = fmodf(prev, 1.0);

            if remainder < 0.001 then
                return floor(prev);
            end

            if remainder > 0.999 then
                return ceil(prev);
            end
        end

        return prev;
    end

    function motion.interp(a, b, t, easing_fn)
        easing_fn = easing_fn or linear;

        if type(b) == "boolean" then
            b = b and 1 or 0;
        end

        return solve(easing_fn, a, b, get_deltatime(), t);
    end
end

--- region decorations
do
    local tohex = utils.to_hex;
    local HALF_PI = math.pi / 2;

    LPH_NO_VIRTUALIZE(function()
        function decorations.wave(s, clock, r1, g1, b1, a1, r2, g2, b2, a2)
            local buffer = { };

            local len = strlen(u8(s));
            local div = 1 / (len - 1);

            local add_r = r2 - r1;
            local add_g = g2 - g1;
            local add_b = b2 - b1;
            local add_a = a2 - a1;

            for char in string_gmatch(s, ".[\128-\191]*") do
                local t = clock; do
                    t = t % 2;

                    if t > 1 then
                        t = 2 - t;
                    end
                end

                local r = r1 + add_r * t;
                local g = g1 + add_g * t;
                local b = b1 + add_b * t;
                local a = a1 + add_a * t;

                buffer[#buffer + 1] = "\a";
                buffer[#buffer + 1] = tohex(r, g, b, a);
                buffer[#buffer + 1] = char;

                clock = clock + div;
            end

            return merge(buffer);
        end

        function decorations.fade(s, pct, r1, g1, b1, a1, r2, g2, b2, a2)
            local buffer = { };

            local len = strlen(u8(s));
            local div = 1 / (len - 1);

            local add_r = r2 - r1;
            local add_g = g2 - g1;
            local add_b = b2 - b1;
            local add_a = a2 - a1;

            local clock = 0;
            local transform = sinf;

            if pct < 0 then
                transform = cosf;
                pct = pct + 1;
            end

            if pct == 0 then
                return merge { "\a", utils.to_hex(r2, g2, b2, a2), s };
            end

            if pct == 1 then
                return merge { "\a", utils.to_hex(r1, g1, b1, a1), s };
            end

            for char in string_gmatch(s, ".[\128-\191]*") do
                local t = transform(HALF_PI * (1 - clock * pct) * (1 - pct * pct));

                local r = r1 + add_r * t;
                local g = g1 + add_g * t;
                local b = b1 + add_b * t;
                local a = a1 + add_a * t;

                buffer[#buffer + 1] = "\a";
                buffer[#buffer + 1] = tohex(r, g, b, a);
                buffer[#buffer + 1] = char;

                clock = clock + div;
            end

            return merge(buffer);
        end
    end)();
end

--- region leg_movement
do
    local IN_FORWARD   = bit_lshift(1, 3);
    local IN_BACK      = bit_lshift(1, 4);
    local IN_MOVELEFT  = bit_lshift(1, 9);
    local IN_MOVERIGHT = bit_lshift(1, 10);

    function leg_movement.always_slide(cmd)
        cmd.buttons = bit_bor(cmd.buttons, cmd.forwardmove > 0 and IN_BACK or IN_FORWARD);
        cmd.buttons = bit_bor(cmd.buttons, cmd.sidemove > 0 and IN_MOVERIGHT or IN_MOVELEFT);
        cmd.buttons = bit_band(cmd.buttons, bit_bnot(cmd.forwardmove > 0 and IN_FORWARD or IN_BACK));
        cmd.buttons = bit_band(cmd.buttons, bit_bnot(cmd.sidemove > 0 and IN_MOVELEFT or IN_MOVERIGHT));
    end

    function leg_movement.never_slide(cmd)
        cmd.buttons = bit_band(cmd.buttons, bit_bnot(IN_FORWARD));
        cmd.buttons = bit_band(cmd.buttons, bit_bnot(IN_BACK));
        cmd.buttons = bit_band(cmd.buttons, bit_bnot(IN_MOVELEFT));
        cmd.buttons = bit_band(cmd.buttons, bit_bnot(IN_MOVERIGHT));
    end
end

--- region exploit
do
    local LAG_COMPENSATION_TELEPORTED_DISTANCE_SQR = 64 * 64;

    local data = {
        old_origin = vector(),
        old_simtime = 0.0,

        shift = false,
        breaking_lc = false,

        defensive = {
            begin = 0,
            duration = 0
        },

        lagcompensation = {
            distance = 0.0,
            teleport = false
        }
    };

    local function update_tickbase(me)
        local net = inetchannel.get();
        if net == nil then return end

        local tickcount = globals.servertickcount();
        local m_nTickBase = entity_get_prop(me, "m_nTickBase");

        local ingoing = inetchannel.get_avg_latency(net, 0);
        tickcount = tickcount + toticks(ingoing * 0.67);

        data.shift = tickcount > m_nTickBase;
    end

    local function update_defensive(tick)
        data.breaking_lc = true;

        data.defensive.begin = globals_tickcount();
        data.defensive.duration = tick;
    end

    local function update_teleport(old_origin, new_origin)
        local delta = new_origin - old_origin;
        local distance = delta:lengthsqr();

        local is_teleport = distance > LAG_COMPENSATION_TELEPORTED_DISTANCE_SQR;

        data.breaking_lc = is_teleport;

        data.lagcompensation.distance = distance;
        data.lagcompensation.teleport = is_teleport;
    end

    local function update_lagcompensation(me)
        local old_origin = data.old_origin;
        local old_simtime = data.old_simtime;

        local origin = vector(entity_get_origin(me));
        local simtime = toticks(entity_get_prop(me, "m_flSimulationTime"));

        if old_simtime ~= nil then
            local delta = simtime - old_simtime;

            if delta < 0 or delta > 0 and delta <= 64 then
                local tick = delta - 1;

                update_teleport(old_origin, origin);

                if delta < 0 then
                    update_defensive(absf(tick));
                end
            end
        end

        data.old_origin = origin;
        data.old_simtime = simtime;
    end

    function exploit.get()
        return data;
    end

    function exploit.setup_command()
        local me = entity_get_local_player();

        update_tickbase(me);
    end

    function exploit.net_update()
        local me = entity_get_local_player();

        if me == nil then
            return;
        end

        update_lagcompensation(me);
    end

    function exploit.frame()
        if not localplayer.is_airborne then
            return;
        end

        local r, g, b, a = 255, 0, 50, 255;

        if data.breaking_lc then
            r, g, b, a = 255, 255, 255, 200;
        end

        renderer_indicator(r, g, b, a, "LC");
    end
end

--- region localplayer
do
    local MOVING_LIMIT = 1.1 * 3.3;
    local DUCK_PEEK_LIMIT = 0.45;

    local pre_flags = 0;
    local post_flags = 0;

    local function get_body_yaw(animstate)
        local body_yaw = animstate.eye_angles_y - animstate.goal_feet_yaw;
        body_yaw = utils.normalize_yaw(body_yaw);

        return body_yaw;
    end

    localplayer.flags = 0;
    localplayer.packets = 0;

    localplayer.body_yaw = 0;
    localplayer.duck_amount = 0;

    localplayer.movetype = 0;
    localplayer.velocity = 0;

    localplayer.is_frozen = false;
    localplayer.is_onground = false;
    localplayer.is_crouched = false;

    localplayer.is_moving = false;
    localplayer.is_landing = false;
    localplayer.is_airborne = false;

    function localplayer.pre_predict_command(e)
        local me = entity_get_local_player();
        pre_flags = entity_get_prop(me, "m_fFlags");
    end

    function localplayer.predict_command(e)
        local me = entity_get_local_player();
        post_flags = entity_get_prop(me, "m_fFlags");
    end

    function localplayer.net_update()
        local me = entity_get_local_player();
        if me == nil then return end

        local my_data = c_entity(me);
        if my_data == nil then return end

        local animstate = c_entity.get_anim_state(my_data);
        if animstate == nil then return end

        local chokedcommands = globals_chokedcommands();

        local m_fFlags = entity_get_prop(me, "m_fFlags");
        local m_movetype = entity_get_prop(me, "m_movetype");
        local m_flDuckAmount = entity_get_prop(me, "m_flDuckAmount");

        localplayer.flags = m_fFlags;
        localplayer.movetype = m_movetype;
        localplayer.velocity = animstate.m_velocity;

        if chokedcommands == 0 then
            localplayer.packets = localplayer.packets + 1;

            localplayer.body_yaw = get_body_yaw(animstate);
            localplayer.duck_amount = m_flDuckAmount;
        end

        localplayer.is_frozen = bit_band(m_fFlags, PLAYER_FLAGS.FL_FROZEN) ~= 0;
        localplayer.is_onground = animstate.on_ground;
        localplayer.is_crouched = localplayer.duck_amount > DUCK_PEEK_LIMIT;

        localplayer.is_moving = localplayer.velocity > MOVING_LIMIT;
        localplayer.is_landing = animstate.hit_in_ground_animation;
        localplayer.is_airborne = bit_band(pre_flags, post_flags, PLAYER_FLAGS.FL_ONGROUND) == 0;
    end
end

--- region statement
do
    local list = { };

    local function add(state)
        list[#list + 1] = state;
    end

    local function update_onground()
        if localplayer.is_moving then
            add "Moving";

            if localplayer.is_crouched then
                return;
            end

            if localplayer.is_airborne then
                return;
            end

            if software.is_slow_motion() then
                add "Slow-motion";
            end

            return;
        end

        add "Standing";
    end

    local function update_crouched()
        if not localplayer.is_crouched then
            return;
        end

        add "Crouched";

        if localplayer.is_moving then
            add "Move-crouched";
        end
    end

    local function update_airborne()
        if not localplayer.is_airborne then
            return;
        end

        add "Airborne";

        if localplayer.is_crouched then
            add "Airborne-crouched";
        end
    end

    local function update_exploit()
        if exploit.get().shift then
            return;
        end

        add "Fake Lag";
    end

    function statement.get()
        return list;
    end

    function statement.add(state)
        add(state);
    end

    function statement.setup_command()
        clear(list);

        update_onground();
        update_crouched();
        update_airborne();
        update_exploit();
    end
end

--- region menu
do
    local items = { };
    local records = { };

    local callbacks = { };

    local function get_value(ref)
        local value = { pcall(ui_get, ref) };
        if not value[1] then return end

        return unpack(value, 2);
    end

    local function get_keys(value)
        if type(value[1]) == "table" then
            return table_keys(value[1]);
        end

        return { };
    end

    local function update_items()
        for i = 1, #callbacks do
            callbacks[i]();
        end

        for i = 1, #items do
            local item = items[i];

            ui_set_visible(item.ref, item.is_visible);
            item.is_visible = false;
        end
    end

    local c_item = { }; do
        function c_item:new()
            return setmetatable({ }, self);
        end

        function c_item:init()
            local function callback(ref)
                self:update_value(ref);
                self:invoke_callback(ref);

                update_items();
            end

            ui_set_callback(self.ref, callback);
        end

        function c_item:get()
            return unpack(self.value);
        end

        function c_item:set(...)
            local ref = self.ref;

            ui_set(ref, ...);
            self:update_value(ref);
        end

        function c_item:have_key(key)
            return self.keys[key] ~= nil;
        end

        function c_item:rawget()
            return ui_get(self.ref);
        end

        function c_item:reset()
            pcall(ui_set, self.ref, unpack(self.default));
        end

        function c_item:record(tab, name)
            if records[tab] == nil then
                records[tab] = { };
            end

            self.is_recorded = true;
            records[tab][name] = self;

            return self;
        end

        function c_item:save()
            if not self.is_recorded then
                client_error_log("Unable to save unrecorded element");
                return;
            end

            self.is_saved = true;
            return self;
        end

        function c_item:display()
            self.is_visible = true;
        end

        function c_item:set_callback(callback)
            self.callbacks[#self.callbacks + 1] = callback;
        end

        function c_item:update_value(ref)
            local value = { get_value(ref) };
            self.keys = get_keys(value);

            self.value = value;
        end

        function c_item:invoke_callback(...)
            for i = 1, #self.callbacks do
                self.callbacks[i](...);
            end
        end

        c_item.__index = c_item;
    end

    function menu.new_item(fn, ...)
        local ref = fn(...);

        local value = { get_value(ref) };
        local typeof = ui_type(ref);

        local item = c_item:new();

        item.ref = ref;
        item.name = select(3, ...);

        item.value = value;
        item.default = value;

        item.keys = get_keys(value);
        item.callbacks = { };

        item.is_saved = false;
        item.is_visible = false;
        item.is_recorded = false;

        if typeof == "button" then
            item.callbacks[#item.callbacks + 1] = select(4, ...);
        end

        item:init();
        items[#items + 1] = item;

        return item;
    end

    function menu.get_items()
        return items;
    end

    function menu.get_records()
        return records;
    end

    function menu.set_callback(callback)
        callbacks[#callbacks + 1] = callback;
    end

    function menu.update()
        update_items();
    end
end

--- region theme
do
    local callbacks = { };

    local function invoke_callback()
        for i = 1, #callbacks do
            callbacks[i]();
        end
    end

    theme.hex = "ffffffc8";
    theme.color = { 255, 255, 255, 200 };

    function theme.rawset(r, g, b, a)
        theme.hex = utils.to_hex(r, g, b, a);
        theme.color = { r, g, b, a };

        invoke_callback();
    end

    function theme.set(ref)
        theme.rawset(ui_get(ref));
    end

    function theme.update()
        invoke_callback();
    end

    function theme.set_event_callback(callback)
        callbacks[#callbacks + 1] = callback;
    end

    function theme.new_label(tab, container, callback)
        local ref = ui_new_label(tab, container, callback());

        theme.set_event_callback(function()
            ui_set(ref, callback());
        end);

        return ref;
    end

    theme.set(software.misc.settings.menu_color);
    ui_set_callback(software.misc.settings.menu_color, theme.set);
end

--- region settings
do
    local DB_LAST_SAVE_KEY = "settings::last_save";

    local items = menu.get_items();
    local records = menu.get_records();

    local last_save = db.get(DB_LAST_SAVE_KEY);

    local function get_value(ref)
        local value = { ui_get(ref) };
        local typeof = ui_type(ref);

        if typeof == "hotkey" then
            local mode = e_hotkey_mode[value[2]];
            local key = value[3] or 0;

            return { mode, key };
        end

        return value;
    end

    local function export(save_all)
        local data = { };

        for k, v in pairs(records) do
            local tab = { };

            for x, y in pairs(v) do
                local item = y;

                if not item.is_saved then
                    if not save_all then
                        goto continue;
                    end
                end

                tab[x] = get_value(y.ref);
                ::continue::
            end

            if not empty(tab) then
                data[k] = tab;
            end
        end

        return data;
    end

    local function load(data, tab)
        if data[tab] == nil then return end
        if records[tab] == nil then return end

        for k, v in pairs(data[tab]) do
            local item = records[tab][k];

            if item == nil then
                goto continue;
            end

            pcall(ui_set, item.ref, unpack(v));
            ::continue::
        end
    end

    local function import(data)
        for k in pairs(data) do
            load(data, k);
        end
    end

    local function reset()
        for i = 1, #items do
            local item = items[i];

            if item.is_saved then
                item:reset();
            end
        end
    end

    function settings.shutdown()
        db.set(DB_LAST_SAVE_KEY, export(true));
    end

    function settings.export(save_all)
        return export(save_all);
    end

    function settings.import(data)
        import(data);
    end

    function settings.load(data, tab)
        load(data, tab);
    end

    function settings.reset()
        reset();
    end

    function settings.load_last_save()
        if last_save == nil then
            return;
        end

        import(last_save);
    end
end

--- region override
do
    local data = { };

    local function get_value(ref)
        local value = { ui_get(ref) };
        local typeof = ui_type(ref);

        if typeof == "hotkey" then
            return { e_hotkey_mode[value[2]] };
        end

        return value;
    end

    function override.get(ref, ...)
        local value = data[ref];

        if value == nil then
            return;
        end

        return unpack(value);
    end

    function override.set(ref, ...)
        if data[ref] == nil then
            data[ref] = get_value(ref);
            ui_set_enabled(ref, false);
        end

        ui_set(ref, ...);
    end

    function override.unset(ref)
        if data[ref] == nil then
            return;
        end

        ui_set(ref, unpack(data[ref]));
        ui_set_enabled(ref, true);

        data[ref] = nil;
    end
end

--- region home
do
    local function display_native_menu(visible)
        -- Anti-aimbot angles
        local pitch_val = ui_get(software.aa.angles.pitch[1]);
        local yaw_val = ui_get(software.aa.angles.yaw[1]);
        local yaw_jitter_val = ui_get(software.aa.angles.yaw_jitter[1]);
        local body_yaw_val = ui_get(software.aa.angles.body_yaw[1]);

        ui_set_visible(software.aa.angles.enabled, visible);
        ui_set_visible(software.aa.angles.pitch[1], visible);
        ui_set_visible(software.aa.angles.yaw_base, visible);
        ui_set_visible(software.aa.angles.yaw[1], visible);
        ui_set_visible(software.aa.angles.body_yaw[1], visible);
        ui_set_visible(software.aa.angles.edge_yaw, visible);
        ui_set_visible(software.aa.angles.freestanding[1], visible);
        ui_set_visible(software.aa.angles.freestanding[2], visible);
        ui_set_visible(software.aa.angles.roll, visible);

        if pitch_val == "Custom" then
            ui_set_visible(software.aa.angles.pitch[2], visible);
        end

        if yaw_val ~= "Off" then
            ui_set_visible(software.aa.angles.yaw[2], visible);
            ui_set_visible(software.aa.angles.yaw_jitter[1], visible);

            if yaw_jitter_val ~= "Off" then
                ui_set_visible(software.aa.angles.yaw_jitter[2], visible);
            end
        end

        if body_yaw_val ~= "Off" then
            if body_yaw_val ~= "Opposite" then
                ui_set_visible(software.aa.angles.body_yaw[2], visible);
            end

            ui_set_visible(software.aa.angles.freestanding_body_yaw, visible);
        end

        -- Fake lag
        ui_set_visible(software.aa.fakelag.enabled[1], visible);
        ui_set_visible(software.aa.fakelag.enabled[2], visible);
        ui_set_visible(software.aa.fakelag.amount, visible);
        ui_set_visible(software.aa.fakelag.variance, visible);
        ui_set_visible(software.aa.fakelag.limit, visible);

        -- Other
        ui_set_visible(software.aa.other.slow_motion[1], visible);
        ui_set_visible(software.aa.other.slow_motion[2], visible);
        ui_set_visible(software.aa.other.leg_movement, visible);
        ui_set_visible(software.aa.other.on_shot_antiaim[1], visible);
        ui_set_visible(software.aa.other.on_shot_antiaim[2], visible);
        ui_set_visible(software.aa.other.fake_peek[1], visible);
        ui_set_visible(software.aa.other.fake_peek[2], visible);
    end

    local function get_month_and_day(timestamp)
        local date = utils.new_date(timestamp * 1000);

        local month_name = utils.get_month_name(date.getMonth());
        local day = date.getDate();

        return merge { month_name, "\x20", day };
    end

    local function get_last_update_time()
        local difference = client_unix_time() - LUA_UPDATE_WAS;
        local hours, minutes, seconds = utils.measure_time(difference);

        if difference < 0 then
            return "in future";
        end

        if hours >= 24 then
            if hours < 48 then
                return "yesterday";
            end

            return get_month_and_day(LUA_UPDATE_WAS);
        end

        if hours > 0 then
            return merge { hours, "\x20", "hours ago" };
        end

        if minutes > 0 then
            return merge { minutes, "\x20", "minutes ago" };
        end

        if seconds > 0 then
            return merge { seconds, "\x20", "seconds ago" };
        end

        return "moment ago";
    end

    home.enabled = menu.new_item(ui_new_checkbox, "AA", "Fake Lag", "Aura°")
    : record("home", "enabled");

    home.new_line_break = menu.new_item(ui_new_label, "AA", "Fake lag", merge { "\a303030ff", "⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯" });

    home.username = menu.new_item(theme.new_label, "AA", "Fake lag", function()
        local username = USER;

        if profile.hide_username and profile.hide_username:get() then
            username = "«hidden»";
        end

        return merge { "Welcome , ", "\a", theme.hex, username, "\a", "ffffffc8", "." };
    end);

    home.last_update = menu.new_item(theme.new_label, "AA", "Fake lag", function()
        return merge { "Last update  ", "\a", theme.hex, get_last_update_time(), "\a", "ffffffc8", "." };
    end);

    home.build = menu.new_item(theme.new_label, "AA", "Fake lag", function()
        return merge { "Your build is ", "\a", BUILD_COLOR or theme.hex, tolower(BUILD), "\a", "ffffffc8", "." };
    end);

    home.end_line_break = menu.new_item(ui_new_label, "AA", "Fake lag", merge { "\a303030ff", "⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯" });

    home.selection = menu.new_item(ui_new_combobox, "AA", "Fake Lag", merge { "\n", "home::selection" }, {
        "- Profile",
        "- Aimbot",
        "- Anti-aimbot",
        "- Visualisation",
        "- Miscellaneous"
    })
    : record("home", "selection");

    function home.shutdown()
        display_native_menu(true);
    end

    function home.frame()
        display_native_menu(not home.enabled:get());
    end
end

--- region profile
do

    local PROFILE_KEY = "SenkoYwO9JAuX47x1RGIKjTVlvEUaMD2mf05WgFbtNCd8crzi6HPyZsQ3LhqpB+/="

    local prefix = merge { "-Aura-", "\x20" };

    local function form(s)
        return merge { prefix, s };
    end

    local function unform(s)
        local pattern = prefix:gsub("%W", "%%%0");
        pattern = merge { pattern, "(.+)" };

        local result = string_match(s, pattern);
        return result;
    end

    local function new_profile_data()
        local data = { };

        data.author = USER;
        data.items = { };

        return data;
    end

    local function playsound_success()
        ienginesound.playsound("ui\\beepclear.wav", 0.75, 250);
    end

    local function playsound_failed()
        ienginesound.playsound("buttons\\weapon_cant_buy.wav", 0.75, 155);
    end

    local function reset()
        profile.reset();
        playsound_success();
    end

    local function import()
        local text = clipboard.get();
        text = unform(text);

        if text == nil then
            print("This profile is not valid");
            playsound_failed();

            return;
        end

        local success, result = pcall(base64.decode, text, PROFILE_KEY);

        if not success then
            print("This profile has a decoding failure");
            playsound_failed();
            return;
        end

        success, result = pcall(json_parse, result);

        if not success then
            print("There was an unpacking failure in this profile");
            playsound_failed();

            return;
        end

        if result.items == nil then
            print("This profile does not have any settings");
            playsound_failed();

            return;
        end

        settings.import(result.items);
        playsound_success();

        print(merge { "Imported profile by ", result.author });
    end

    local function export()
        local data = new_profile_data();
        data.items = settings.export();

        local text = json_stringify(data);

        text = base64.encode(text, PROFILE_KEY);
        text = form(text);

        clipboard.set(text);
        playsound_success();

        print("Your profile has been successfully exported to the clipboard");
    end

    profile.hide_username = menu.new_item(ui_new_checkbox, "AA", "Anti-aimbot angles", "Hide username")
    : record("profile", "hide_username");

    profile.import = menu.new_item(ui_new_button, "AA", "Other", "Import from clipboard", DUMMY);
    profile.export = menu.new_item(ui_new_button, "AA", "Other", "Export to clipboard", DUMMY);
    profile.reset = menu.new_item(ui_new_button, "AA", "Other", "Reset", DUMMY);

    profile.hide_username:set_callback(theme.update);

    profile.export:set_callback(export);
    profile.import:set_callback(import);
    profile.reset:set_callback(reset);
end

--- region antiaimbot
do
    local ctx = { };

    local function modify_pitch()
        if ctx.pitch == "Up & Down" then
            ctx.pitch = "Custom";

            if ctx.pitch_offset == nil then
                ctx.pitch_offset = 89;
            end

            if utils.is_odd(localplayer.packets) then
                ctx.pitch_offset = -ctx.pitch_offset;
            end

            return;
        end

        if ctx.pitch == "Adaptive" then
            ctx.pitch = "Custom";

            if ctx.pitch_offset == nil then
                ctx.pitch_offset = 45;
            end

            if localplayer.duck_amount == 1.0 then
                ctx.pitch_offset = -ctx.pitch_offset;
            end
        end
    end

    local function modify_yaw()
        if ctx.yaw == "180 LR" then
            ctx.yaw = "180";

            if ctx.yaw_left == nil then return end
            if ctx.yaw_right == nil then return end

            if ctx.yaw_offset == nil then
                ctx.yaw_offset = 0;
            end

            local inverted = localplayer.body_yaw < 0;

            if ctx.yaw_180lr_mode == "Switch delay" then
                local delay = ctx.yaw_switch_delay;
                local target = delay * 2;

                inverted = (localplayer.packets % target) >= delay;

                ctx.body_yaw = "Static";
                ctx.body_yaw_offset = inverted and
                    1 or -1;
            end

            local yaw_add = inverted and
                ctx.yaw_right or ctx.yaw_left;

            ctx.yaw_offset = ctx.yaw_offset + yaw_add;
            return;
        end
    end

    local function modify_jitter()
        if ctx.jitter_mode == "Switch" then
            if ctx.jitter_from == nil then return end
            if ctx.jitter_to == nil then return end

            ctx.jitter_offset = utils.is_odd(localplayer.packets) and
                ctx.jitter_to or ctx.jitter_from;

            return;
        end

        if ctx.jitter_mode == "Sway" then
            if ctx.jitter_from == nil then return end
            if ctx.jitter_to == nil then return end

            if ctx.jitter_from == ctx.jitter_to then
                ctx.jitter_offset = ctx.jitter_from;
                return;
            end

            local tick = globals_tickcount();
            local delta = ctx.jitter_to - ctx.jitter_from;

            delta = delta + sign(delta);

            local accelerate = tick * delta * globals_tickinterval();
            accelerate = accelerate * 2.0;

            tick = tick + floor(accelerate);

            local jitter_add = tick % delta;
            ctx.jitter_offset = ctx.jitter_from + jitter_add;

            return;
        end

        if ctx.jitter_randomization ~= nil then
            local offset = ctx.jitter_randomization;
            if offset <= 0 then return end

            local jitter_add = client_random_int(-offset, offset);
            ctx.jitter_offset = ctx.jitter_offset + jitter_add;
        end
    end

    local function shutdown()
        override.unset(software.aa.angles.pitch[1]);
        override.unset(software.aa.angles.pitch[2]);

        override.unset(software.aa.angles.yaw_base);

        override.unset(software.aa.angles.yaw[1]);
        override.unset(software.aa.angles.yaw[2]);

        override.unset(software.aa.angles.yaw_jitter[1]);
        override.unset(software.aa.angles.yaw_jitter[2]);

        override.unset(software.aa.angles.body_yaw[1]);
        override.unset(software.aa.angles.body_yaw[2]);

        override.unset(software.aa.angles.freestanding_body_yaw);

        override.unset(software.aa.angles.edge_yaw);

        override.unset(software.aa.angles.freestanding[1]);
        override.unset(software.aa.angles.freestanding[2]);

        override.unset(software.aa.angles.roll);
    end

    local function setup()
        if ctx.pitch ~= nil then
            override.set(software.aa.angles.pitch[1], ctx.pitch);
        end

        if ctx.yaw_base ~= nil then
            override.set(software.aa.angles.yaw_base, ctx.yaw_base);
        end

        if ctx.yaw ~= nil then
            override.set(software.aa.angles.yaw[1], ctx.yaw);
        end

        if ctx.body_yaw ~= nil then
            override.set(software.aa.angles.body_yaw[1], ctx.body_yaw);
        end

        if ctx.edge_yaw ~= nil then
            override.set(software.aa.angles.edge_yaw, ctx.edge_yaw);
        end

        if ctx.freestanding ~= nil then
            override.set(software.aa.angles.freestanding[1], ctx.freestanding);
            override.set(software.aa.angles.freestanding[2], ctx.freestanding and
                "Always on" or "On hotkey");
        end

        if ctx.roll ~= nil then
            override.set(software.aa.angles.roll, ctx.roll);
        end

        local pitch_value = ui_get(software.aa.angles.pitch[1]);
        local yaw_value = ui_get(software.aa.angles.yaw[1]);
        local body_yaw_value = ui_get(software.aa.angles.body_yaw[1]);

        if pitch_value == "Custom" then
            if ctx.pitch_offset ~= nil then
                override.set(software.aa.angles.pitch[2], clamp(ctx.pitch_offset, -89, 89));
            end
        end

        if yaw_value ~= "Off" then
            if ctx.yaw_offset ~= nil then
                override.set(software.aa.angles.yaw[2], utils.normalize_yaw(ctx.yaw_offset));
            end

            if ctx.yaw_jitter ~= nil then
                override.set(software.aa.angles.yaw_jitter[1], ctx.yaw_jitter);
            end

            local yaw_jitter_val = ui_get(software.aa.angles.yaw_jitter[1]);

            if yaw_jitter_val ~= "Off" then
                if ctx.jitter_offset ~= nil then
                    override.set(software.aa.angles.yaw_jitter[2], utils.normalize_yaw(ctx.jitter_offset));
                end
            end
        end

        if body_yaw_value ~= "Off" then
            if body_yaw_value ~= "Opposite" then
                if ctx.body_yaw_offset ~= nil then
                    override.set(software.aa.angles.body_yaw[2], utils.normalize_yaw(ctx.body_yaw_offset));
                end
            end

            if ctx.freestanding_body_yaw ~= nil then
                override.set(software.aa.angles.freestanding_body_yaw, ctx.freestanding_body_yaw);
            end
        end
    end

    local function think(e)
        break_lc.think(e);
    end

    local function update(e)
        yaw_direction.update(ctx);

        angles.update(ctx);

        if manual_direction.update(ctx) then
            return;
        end

        defensive.update(ctx);

        safe_head.update(ctx);
        avoid_backstab.update(ctx);
    end

    antiaimbot.selection = menu.new_item(ui_new_combobox, "AA", "Fake Lag", merge { "\n", "antiaimbot::selection" }, {
        "- Main",
        "- Angles"
    })
    : record("aa", "antiaimbot::selection");

    function antiaimbot.shutdown()
        shutdown();
    end

    function antiaimbot.setup_command(e)
        clear(ctx);
        shutdown();

        if not home.enabled:get() then
            return;
        end

        think(e);
        update(e);

        modify_pitch();
        modify_yaw();
        modify_jitter();

        setup();
    end
end

--- region visualization
do
    visualization.selection = menu.new_item(ui_new_combobox, "AA", "Fake Lag", merge { "\n", "visualization::selection" }, {
        "- Main"
    })
    : record("aa", "visualization::selection");

    visualization.color_label = menu.new_item(ui_new_label, "AA", "Other", "Color");

    visualization.color_picker = menu.new_item(ui_new_color_picker, "AA", "Other", "Color", software.get_color())
    : record("aa", "visualization::color_picker");
end

--- region correction
do
    local records = { };

    local function get_server_time(player)
        return entity_get_prop(player, "m_nTickBase") * globals_tickinterval();
    end

    local function get_simulation_time(player)
        return entity_get_prop(player, "m_flSimulationTime");
    end

    local function new_record()
        local record = {
            is_simtime_update = false,

            is_jittering = false,
            is_jittering_prev = false,

            server_tick = 0,

            prev_simtime = 0,
            simtime = 0,

            prev_eye_yaw = 0,
            eye_angles = vector(),

            prev_rotation = 0,
            rotation = vector(),

            prev_delta = 0,
            delta = 0,

            fakelag_ticks = 0,
            choked_ticks = 0
        };

        return record;
    end

    local function update_records(player)
        records[player] = records[player]
            or new_record();

        local record = records[player];

        local simtime = get_simulation_time(player);
        local server_tick = get_server_time(player);

        local rotation = vector(entity_get_prop(player, "m_angRotation"));
        local eye_angles = vector(entity_get_prop(player, "m_angEyeAngles"));

        record.server_tick = server_tick;

        record.old_simtime = record.simtime;
        record.simtime = simtime;

        record.is_simtime_update = record.simtime ~= record.old_simtime;

        if record.is_simtime_update then
            record.fakelag_ticks = record.choked_ticks;
            record.choked_ticks = 0;

            record.prev_eye_yaw = record.eye_angles.y;
            record.eye_angles = eye_angles;

            record.prev_rotation = record.rotation.y;
            record.rotation = rotation;

            record.prev_delta = record.delta;
            record.delta = utils.normalize_yaw(record.eye_angles.y - record.prev_eye_yaw);

            record.is_prev_jittering = record.is_jittering;

            record.is_jittering = (record.delta > 0 and record.prev_delta < 0)
                or (record.delta < 0 and record.prev_delta > 0);
        else
            record.choked_ticks = record.choked_ticks + 1;
        end
    end

    local function remove_correction(player)
        plist.set(player, "Force body yaw", false);
        plist.set(player, "Force body yaw value", 0);
    end

    local function update_correction(player)
        local record = records[player];
        if record == nil then return end

        local tickcount = globals_tickcount();

        local jitter_fix = false;
        local jitter_side = -1;

        if record.delta > 0 then
            jitter_side = 1;
        end

        local server_tick = toticks(record.server_tick);
        local latency_tick = toticks(client.real_latency());

        local arrival_tick = server_tick + latency_tick + 1;
        local current_tick = arrival_tick - server_tick - 1;

        local ticks_to_predict_before_arrival = math.min(math.max(arrival_tick - current_tick, 0) + (tickcount - record.server_tick), 8);

        for tick = 1, ticks_to_predict_before_arrival do
            jitter_side = -jitter_side;
        end

        local avg_body_yaw = (utils.normalize_yaw(record.eye_angles.y) - utils.normalize_yaw(record.prev_eye_yaw)) * jitter_side;

        if record.is_prev_jittering and record.is_jittering then
            local abs_body_yaw = math.abs(avg_body_yaw);
            jitter_fix = abs_body_yaw > 8 and abs_body_yaw < 64;
        end

        plist.set(player, "Force body yaw", jitter_fix);
        plist.set(player, "Force body yaw value", clamp(avg_body_yaw, -60, 60));
    end

    local function shutdown()
        local enemies = entity.get_players(true);

        for i = 1, #enemies do
            remove_correction(enemies[i]);
        end
    end

    correction.enabled = menu.new_item(ui_new_checkbox, "AA", "Anti-aimbot angles", "Jitter correction")
    : record("aimbot", "correction::enabled")
    : save();

    function correction.shutdown()
        shutdown();
    end

    function correction.net_update()
        if not correction.enabled:get() then
            return;
        end

        local enemies = entity.get_players(true);

        for i = 1, #enemies do
            local enemy = enemies[i];

            update_records(enemy);
            update_correction(enemy);
        end
    end

    correction.enabled:set_callback(function(item)
        if not ui.get(item) then
            shutdown();
        end
    end);
end

--- region angles
do
    local function set_custom_list(ctx, list)
        if list.pitch ~= nil then
            ctx.pitch = list.pitch:get();
            ctx.pitch_offset = list.pitch_offset:get();
        end

        if list.yaw_base ~= nil then
            ctx.yaw_base = list.yaw_base:get();
        end

        ctx.yaw = list.yaw:get();
        ctx.yaw_offset = list.yaw_offset:get();

        if ctx.yaw == "180 LR" then
            ctx.yaw_offset = 0;
        end

        ctx.yaw_180lr_mode = list.yaw_180lr_mode:get();
        ctx.yaw_left = list.yaw_left:get();
        ctx.yaw_right = list.yaw_right:get();
        ctx.yaw_switch_delay = list.yaw_switch_delay:get();

        ctx.yaw_jitter = list.yaw_jitter:get();
        ctx.jitter_mode = list.jitter_mode:get();
        ctx.jitter_offset = list.jitter_offset:get();
        ctx.jitter_randomization = list.jitter_randomization:get();
        ctx.jitter_from = list.jitter_from:get();
        ctx.jitter_to = list.jitter_to:get();

        ctx.body_yaw = list.body_yaw:get();
        ctx.body_yaw_offset = list.body_yaw_offset:get();
        ctx.freestanding_body_yaw = list.freestanding_body_yaw:get();
    end

    angles.type = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles", "Anti-aimbot type", {
        "Off",
        "Custom",
        "Recommended"
    })
    : record("aa", "angles::type")
    : save();

    angles.custom = { }; do
        angles.custom.state = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles", "State", { unpack(e_statement, 0) })
        : record("aa", "custom::state");

        for i = 0, #e_statement do
            local list = { };
            local state = e_statement[i];

            if i ~= 0 then
                list.enabled = menu.new_item(ui_new_checkbox, "AA", "Anti-aimbot angles", merge { "Enable", "\x20", state })
                : record("aa", merge { "custom", "::", state, "::", "enabled" })
                : save();
            end

            if i ~= 10 then
                local pitch_list = { "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom" };

                if state == "Defensive" then
                    pitch_list = { "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom", "Adaptive", "Up & Down" };
                end

                list.pitch = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles", merge { "Pitch", "\n", "custom_", "pitch_", state }, pitch_list)
                : record("aa", merge { "custom", "::", state, "::", "pitch" })
                : save();

                list.pitch_offset = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { "\n", "custom_", "pitch_offset_", state }, -89, 89, 0, true, "°")
                : record("aa", merge { "custom", "::", state, "::", "pitch_offset" })
                : save();

                list.yaw_base = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles", merge { "Yaw base", "\n", "custom_", "yaw_base_", state }, { "Local view", "At targets" })
                : record("aa", merge { "custom", "::", state, "::", "yaw_base" })
                : save();
            end

            list.yaw = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles", merge { "Yaw", "\n", "custom_", "yaw_", state }, { "Off", "180", "Spin", "Static", "180 Z", "Crosshair", "180 LR" })
            : record("aa", merge { "custom", "::", state, "::", "yaw" })
            : save();

            list.yaw_offset = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { "\n", "custom_", "yaw_offset_", state }, -180, 180, 0, true, "°")
            : record("aa", merge { "custom", "::", state, "::", "yaw_offset" })
            : save();

            list.yaw_180lr_mode = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles", merge { "\n", "custom_", "yaw_180lr_mode_", state }, { "Side based", "Switch delay" })
            : record("aa", merge { "custom", "::", state, "::", "yaw_180lr_mode" })
            : save();

            list.yaw_left = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { "Left offset", "\n", "custom_", "yaw_left_", state }, -180, 180, 0, true, "°")
            : record("aa", merge { "custom", "::", state, "::", "yaw_left" })
            : save();

            list.yaw_right = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { "Right offset", "\n", "custom_", "yaw_right_", state }, -180, 180, 0, true, "°")
            : record("aa", merge { "custom", "::", state, "::", "yaw_right" })
            : save();

            list.yaw_switch_delay = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { "Switch delay", "\n", "custom_", "yaw_switch_delay_", state }, 1, 8, 0, true, "t")
            : record("aa", merge { "custom", "::", state, "::", "yaw_switch_delay" })
            : save();


            list.yaw_jitter = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles", merge { "Yaw jitter", "\n", "custom_", "yaw_jitter_", state }, { "Off", "Offset", "Center", "Random", "Skitter" })
            : record("aa", merge { "custom", "::", state, "::", "yaw_jitter" })
            : save();

            list.jitter_mode = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles", merge { "\n", "custom_", "jitter_mode_", state }, { "Default", "Switch", "Sway" })
            : record("aa", merge { "custom", "::", state, "::", "jitter_mode" })
            : save();

            list.jitter_offset = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { "Jitter offset", "\n", "custom_", "jitter_offset_", state }, -180, 180, 0, true, "°")
            : record("aa", merge { "custom", "::", state, "::", "jitter_offset" })
            : save();

            list.jitter_randomization = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { "Randomization", "\n", "custom_", "jitter_randomization_", state }, 0, 180, 0, true, "°", 1, { [0] = "Off" })
            : record("aa", merge { "custom", "::", state, "::", "jitter_randomization" })
            : save();

            list.jitter_from = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { "From offset", "\n", "custom_", "jitter_from_", state }, -180, 180, 0, true, "°")
            : record("aa", merge { "custom", "::", state, "::", "jitter_from" })
            : save();

            list.jitter_to = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { "To offset", "\n", "custom_", "jitter_to_", state }, -180, 180, 0, true, "°")
            : record("aa", merge { "custom", "::", state, "::", "jitter_to" })
            : save();


            list.body_yaw = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles", merge { "Body yaw", "\n", "custom_", "body_yaw_", state }, { "Off", "Opposite", "Jitter", "Static" })
            : record("aa", merge { "custom", "::", state, "::", "body_yaw" })
            : save();

            list.body_yaw_offset = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { "\n", "custom_", "body_yaw_offset_", state }, -180, 180, 0, true, "°")
            : record("aa", merge { "custom", "::", state, "::", "body_yaw_offset" })
            : save();

            list.freestanding_body_yaw = menu.new_item(ui_new_checkbox, "AA", "Anti-aimbot angles", merge { "Freestanding body yaw", "\n", "custom_", "freestanding_body_yaw_", state })
            : record("aa", merge { "custom", "::", state, "::", "freestanding_body_yaw" })
            : save();

            angles.custom[state] = list;
        end
    end

    angles.recommended = {
        ["Standing"] = function(ctx)
            ctx.pitch = "Down";
            ctx.yaw_base = "At targets";

            ctx.yaw = "180 LR";
            ctx.yaw_180lr_mode = "Switch delay";

            ctx.yaw_left = -21;
            ctx.yaw_right = 39;

            ctx.yaw_switch_delay = 2;

            ctx.yaw_jitter = "Off";

            ctx.body_yaw = "Jitter";
            ctx.body_yaw_offset = -1;

            ctx.freestanding_body_yaw = false;
        end,

        ["Moving"] = function(ctx)
            ctx.pitch = "Down";
            ctx.yaw_base = "At targets";

            ctx.yaw = "180 LR";
            ctx.yaw_180lr_mode = "Switch delay";

            ctx.yaw_left = -32;
            ctx.yaw_right = 37;

            ctx.yaw_switch_delay = 2;

            ctx.yaw_jitter = "Off";

            ctx.body_yaw = "Jitter";
            ctx.body_yaw_offset = -1;

            ctx.freestanding_body_yaw = false;
        end,

        ["Slow-motion"] = function(ctx)
            ctx.pitch = "Down";
            ctx.yaw_base = "At targets";

            ctx.yaw = "180";
            ctx.yaw_offset = -3;

            ctx.yaw_jitter = "Center";
            ctx.jitter_offset = 19;

            ctx.body_yaw = "Jitter";
            ctx.body_yaw_offset = -1;

            ctx.freestanding_body_yaw = false;
        end,

        ["Crouched"] = function(ctx)
            ctx.pitch = "Down";
            ctx.yaw_base = "At targets";

            ctx.yaw = "180 LR";
            ctx.yaw_180lr_mode = "Switch delay";

            ctx.yaw_left = -32;
            ctx.yaw_right = 50;

            ctx.yaw_switch_delay = 2;

            ctx.yaw_jitter = "Off";

            ctx.body_yaw = "Jitter";
            ctx.body_yaw_offset = -1;

            ctx.freestanding_body_yaw = false;
        end,

        ["Airborne"] = function(ctx)
            ctx.pitch = "Down";
            ctx.yaw_base = "At targets";

            ctx.yaw = "180";
            ctx.yaw_offset = 5;

            ctx.yaw_jitter = "Center";
            ctx.jitter_offset = 77;

            ctx.body_yaw = "Jitter";
            ctx.body_yaw_offset = -1;

            ctx.freestanding_body_yaw = false;
        end,

        ["Airborne-crouched"] = function(ctx)
            ctx.pitch = "Down";
            ctx.yaw_base = "At targets";

            ctx.yaw = "180 LR";
            ctx.yaw_180lr_mode = "Switch delay";

            ctx.yaw_left = -35;
            ctx.yaw_right = 47;

            ctx.yaw_switch_delay = 3;

            ctx.yaw_jitter = "Off";

            ctx.body_yaw = "Jitter";
            ctx.body_yaw_offset = -1;

            ctx.freestanding_body_yaw = false;
        end,

        ["Defensive"] = function(ctx)
            ctx.pitch = "Adaptive";
            ctx.pitch_offset = 45;

            ctx.yaw = "Spin";
            ctx.yaw_offset = 77;

            ctx.yaw_jitter = "Offset";
            ctx.jitter_offset = 15;

            ctx.body_yaw = "Static";
            ctx.body_yaw_offset = 120;

            ctx.freestanding_body_yaw = false;
        end
    };

    function angles.set(ctx, state)
        if angles.type:get() == "Custom" then
            local list = angles.custom[state];

            if list ~= nil then
                -- if not enabled in menu
                if list.enabled ~= nil then
                    if not list.enabled:get() then
                        return false;
                    end
                end

                set_custom_list(ctx, list);
                return true;
            end

            return false;
        end

        if angles.type:get() == "Recommended" then
            local fn = angles.recommended[state];

            if fn ~= nil then
                fn(ctx);
                return true;
            end

            return false;
        end

        return false;
    end

    function angles.update(ctx)
        local list = statement.get();

        for i = #list, 1, -1 do
            local state = list[i];

            if angles.set(ctx, state) then
                return;
            end
        end

        angles.set(ctx, "Main");
    end
end

--- region yaw_direction
do
    yaw_direction.enabled = menu.new_item(ui_new_checkbox, "AA", "Other", "Yaw direction")
    : record("aa", "yaw_direction::enabled");

    yaw_direction.edge_yaw = menu.new_item(ui_new_hotkey, "AA", "Other", merge { " » ", "Edge yaw" })
    : record("aa", "yaw_direction::edge_yaw");

    yaw_direction.freestanding = menu.new_item(ui_new_hotkey, "AA", "Other", merge { " » ", "Freestanding" })
    : record("aa", "yaw_direction::freestanding");

    yaw_direction.options = menu.new_item(ui_new_multiselect, "AA", "Other", merge { " » ", "Options" }, { "Freestanding on quick peek" })
    : record("aa", "yaw_direction::options");

    function yaw_direction.update(ctx)
        if not yaw_direction.enabled:get() then
            return;
        end

        ctx.edge_yaw = yaw_direction.edge_yaw:rawget();
        ctx.freestanding = yaw_direction.freestanding:rawget();

        if yaw_direction.options:have_key("Freestanding on quick peek") then
            if software.is_quick_peek_assist() then
                ctx.freestanding = true;
            end
        end
    end
end

--- region manual_yaw
do
    local LEFT    = 0;
    local RIGHT   = 1;
    local FORWARD = 2;

    local idx;
    local data = { };

    local directions = {
        [LEFT]    = -90,
        [RIGHT]   = 90,
        [FORWARD] = 180
    };

    local function get_value(ref)
        local prev_active = data[ref];
        local active, mode, key = ui_get(ref);

        if prev_active == nil then
            data[ref] = active;
            return;
        end

        if mode == 0 then return end
        if mode == 3 then return end
        if key == nil then return end

        if prev_active ~= active then
            data[ref] = active;
            return active, mode, key;
        end
    end

    local function update_hotkey(ref, value)
        local active, mode = get_value(ref);
        if active == nil then return end

        if mode == 1 then
            if not active then
                idx = nil;
                return;
            end

            idx = value;
            return;
        end

        if mode == 2 then
            if idx == value then
                idx = nil;
                return;
            end

            idx = value;
            return;
        end
    end

    local function update_label(item, state)
        local name = item.name;

        if state then
            local r, g, b, a = unpack(theme.color);
            a = a * (globals_realtime() % 1);

            local hex = utils.to_hex(r, g, b, a);
            name = string_gsub(name, "»", merge { "\a", hex, "%1", "\a", "ffffffc8" });
        end

        item:set(name);
    end

    local function think()
        if get_value(manual_direction.reset_manual.hotkey.ref) ~= nil then
            idx = nil;
            return;
        end

        update_hotkey(manual_direction.left_manual.hotkey.ref, LEFT);
        update_hotkey(manual_direction.right_manual.hotkey.ref, RIGHT);
        update_hotkey(manual_direction.forward_manual.hotkey.ref, FORWARD);
    end

    local function draw(old, new)
        if new == old then
            if ui_is_menu_open() then
                if new == LEFT then
                    update_label(manual_direction.left_manual.label, true);
                end

                if new == RIGHT then
                    update_label(manual_direction.right_manual.label, true);
                end

                if new == FORWARD then
                    update_label(manual_direction.forward_manual.label, true);
                end
            end

            return;
        end

        update_label(manual_direction.left_manual.label, false);
        update_label(manual_direction.right_manual.label, false);
        update_label(manual_direction.forward_manual.label, false);
    end

    manual_direction.enabled = menu.new_item(ui_new_checkbox, "AA", "Other", "Manual direction")
    : record("aa", "manual_direction::enabled");

    manual_direction.options = menu.new_item(ui_new_multiselect, "AA", "Other", merge { " » ", "Options", "\n", "manual_direction::options" }, {
        "Disable yaw modifiers",
        "Freestanding body yaw"
    })
    : record("aa", "manual_direction::options")
    : save();

    manual_direction.left_manual = {
        label = menu.new_item(ui_new_label, "AA", "Other", merge { " » ", "Left manual" }),

        hotkey = menu.new_item(ui_new_hotkey, "AA", "Other", merge { "\n", "left_manual::hotkey" }, true)
        : record("aa", "manual_direction::left_manual::hotkey")
    };

    manual_direction.right_manual = {
        label = menu.new_item(ui_new_label, "AA", "Other", merge { " » ", "Right manual" }),

        hotkey = menu.new_item(ui_new_hotkey, "AA", "Other", merge { "\n", "right_manual::hotkey" }, true)
        : record("aa", "manual_direction::right_manual::hotkey")
    };

    manual_direction.reset_manual = {
        label = menu.new_item(ui_new_label, "AA", "Other", merge { " » ", "Reset manual" }),

        hotkey = menu.new_item(ui_new_hotkey, "AA", "Other", merge { "\n", "reset_manual::hotkey" }, true)
        : record("aa", "manual_direction::reset_manual::hotkey")
    };

    manual_direction.forward_manual = {
        label = menu.new_item(ui_new_label, "AA", "Other", merge { " » ", "Forward manual" }),

        hotkey = menu.new_item(ui_new_hotkey, "AA", "Other", merge { "\n", "forward_manual::hotkey" }, true)
        : record("aa", "manual_direction::forward_manual::hotkey")
    };

    function manual_direction.get()
        return idx;
    end

    function manual_direction.frame()
        local old = idx;
        think();

        local new = idx;
        draw(old, new);
    end

    function manual_direction.update(ctx)
        if idx == nil then
            return false;
        end

        local offset = directions[idx];

        if offset == nil then
            return false;
        end

        if ctx.yaw_offset == nil then
            ctx.yaw_offset = 0;
        end

        ctx.yaw_base = "Local view";
        ctx.yaw_offset = ctx.yaw_offset + offset;

        if manual_direction.options:have_key("Disable yaw modifiers") then
            ctx.yaw = "180";
            ctx.yaw_offset = offset;

            ctx.yaw_jitter = "Off";
        end

        if manual_direction.options:have_key("Freestanding body yaw") then
            ctx.body_yaw = "Static";
            ctx.body_yaw_offset = 120;

            ctx.freestanding_body_yaw = true;
        end

        ctx.edge_yaw = false;
        ctx.freestanding = false;

        return true;
    end
end

--- region avoid_backstab
do
    local AVOID_BACKSTAB_MAX_DISTANCE_SQR = 192 * 192;

    local function get_enemies_with_knife()
        local enemies = entity_get_players(true);
        if empty(enemies) then return { } end

        local list = { };

        for i = 1, #enemies do
            local enemy = enemies[i];
            local wpn = entity_get_player_weapon(enemy);

            if wpn == nil then
                goto continue;
            end

            local wpn_class = entity_get_classname(wpn);

            if wpn_class == "CKnife" then
                list[#list + 1] = enemy;
            end

            ::continue::
        end

        return list;
    end

    local function get_closest_target(me)
        local targets = get_enemies_with_knife();
        if empty(targets) then return end

        local best_delta;
        local best_target;

        local my_origin = vector(entity_get_origin(me));
        local best_distance = AVOID_BACKSTAB_MAX_DISTANCE_SQR;

        for i = 1, #targets do
            local target = targets[i];

            local origin = vector(entity_get_origin(target));
            local delta = origin - my_origin;

            local distance = delta:lengthsqr();

            if distance < best_distance then
                best_delta = delta;
                best_target = target;

                best_distance = distance;
            end
        end

        return best_target, best_delta;
    end

    avoid_backstab.enabled = menu.new_item(ui_new_checkbox, "AA", "Anti-aimbot angles", "Avoid backstab")
    : record("aa", "avoid_backstab::enabled")
    : save();

    function avoid_backstab.update(ctx)
        if not avoid_backstab.enabled:get() then
            return;
        end

        local me = entity_get_local_player();
        local target, delta = get_closest_target(me);

        if target == nil then return end
        if delta == nil then return end

        local view = vector(client_camera_angles());
        local angle = vector(delta:angles());

        local yaw = angle.y - view.y + 180;

        if ctx.yaw_offset == nil then
            ctx.yaw_offset = 0;
        end

        ctx.yaw_base = "Local view";
        ctx.yaw_offset = ctx.yaw_offset + yaw;

        ctx.edge_yaw = false;
        ctx.freestanding = false;
    end
end

--- region safe_head
do
    safe_head.enabled = menu.new_item(ui_new_checkbox, "AA", "Anti-aimbot angles", "Safe head")
    : record("aa", "safe_head::enabled")
    : save();

    function safe_head.update(ctx)
        if not safe_head.enabled:get() then
            return;
        end

        local me = entity_get_local_player();
        local thread = client_current_threat();

        if thread == nil then
            return;
        end

        local esp_data = entity_get_esp_data(thread);

        if esp_data == nil then
            return;
        end

        if bit_band(esp_data.flags, ESP_FLAGS.HIT) == 0 then
            return;
        end

        local my_eyes = vector(utils.get_eye_position(me));
        local thread_eyes = vector(utils.get_eye_position(thread));

        local delta = my_eyes - thread_eyes;

        if delta.z < 20 then
            return;
        end

        ctx.pitch = "Default";
        ctx.yaw_base = "At targets";

        ctx.yaw = "180";
        ctx.yaw_offset = 22;

        ctx.yaw_jitter = "Off";

        ctx.body_yaw = "Static";
        ctx.body_yaw_offset = 120;

        ctx.freestanding_body_yaw = false;
    end
end

--- region break_lc
do
    local function get_state()
        if localplayer.is_airborne then
            return "Airborne";
        end

        if localplayer.is_crouched then
            return "Crouched";
        end

        if localplayer.is_moving then
            if software.is_slow_motion() then
                return "Slow-motion";
            end

            return "Moving";
        end

        return "Standing"
    end

    break_lc.enabled = menu.new_item(ui_new_checkbox, "AA", "Anti-aimbot angles", "Break LC")
    : record("aa", "break_lc::enabled")
    : save();

    break_lc.states = menu.new_item(ui_new_multiselect, "AA", "Anti-aimbot angles", merge { " » ", "States", "\n", "break_lc::states" }, {
        "Standing",
        "Moving",
        "Slow-motion",
        "Crouched",
        "Airborne"
    })
    : record("aa", "break_lc::states")
    : save();

    function break_lc.think(e)
        if not break_lc.enabled:get() then
            return;
        end

        if not exploit.get().shift then
            return;
        end

        local state = get_state();

        if not break_lc.states:have_key(state) then
            return;
        end

        e.force_defensive = 1;
    end
end

--- region defensive
do
    local function get_state()
        if localplayer.is_airborne then
            return "Airborne";
        end

        if localplayer.is_crouched then
            return "Crouched";
        end

        if localplayer.is_moving then
            if software.is_slow_motion() then
                return "Slow-motion";
            end

            return "Moving";
        end

        return "Standing"
    end

    local function is_state_active()
        local state = get_state();

        if not defensive.states:have_key(state) then
            return false;
        end

        return true;
    end

    local function is_target_valid()
        local threat = client_current_threat();

        if threat == nil then
            return true;
        end

        local player_resource = entity_get_player_resource();
        local m_iPing = entity_get_prop(player_resource, "m_iPing", threat);

        if m_iPing == 0 then
            return true;
        end

        if m_iPing > defensive.ping_target:get() then
            return true;
        end

        return false;
    end

    local function is_exploit_active()
        if software.is_double_tap() then
            return defensive.exploit:have_key("Double tap");
        end

        if software.is_on_shot_antiaim() then
            return defensive.exploit:have_key("On shot anti-aim");
        end

        return false;
    end

    local function is_defensive_active()
        local data = exploit.get().defensive;

        local tick = globals_tickcount();
        local sensitivity = defensive.sensitivity:get();

        local duration = data.duration;
        duration = duration * (sensitivity * 0.01);

        if tick > (data.begin + duration) then
            return false;
        end

        return true;
    end

    defensive.enabled = menu.new_item(ui_new_checkbox, "AA", "Anti-aimbot angles", "Defensive")
    : record("aa", "defensive::enabled")
    : save();

    defensive.states = menu.new_item(ui_new_multiselect, "AA", "Anti-aimbot angles", merge { " » ", "States", "\n", "defensive::states" }, {
        "Standing",
        "Moving",
        "Slow-motion",
        "Crouched",
        "Airborne",
        "On peek"
    })
    : record("aa", "defensive::states")
    : save();

    defensive.exploit = menu.new_item(ui_new_multiselect, "AA", "Anti-aimbot angles", merge { " » ", "Exploit", "\n", "defensive::exploit" }, {
        "On shot anti-aim",
        "Double tap"
    })
    : record("aa", "defensive::exploit")
    : save();

    defensive.sensitivity = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { " » ", "Sensitivity (duration)", "\n", "defensive::sensitivity" }, 1, 100, 100, true, "%")
    : record("aa", "defensive::sensitivity")
    : save();

    defensive.ping_target = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { " » ", "Ping target (greater than)", "\n", "defensive::ping_target" }, 0, 200, 20, true, "ms")
    : record("aa", "defensive::ping_target")
    : save();

    function defensive.update(ctx)
        if not defensive.enabled:get() then
            return;
        end

        if not is_target_valid() or not is_state_active() then
            return;
        end

        if not is_exploit_active() or not is_defensive_active() then
            return;
        end

        angles.set(ctx, "Defensive");
    end
end

--- region indicate_state
do
    local traditional = { }; do
        local last_state = "STATE";

        local alpha = 0.0;
        local align = 0.0;

        local statement_alpha = 0.0;
        local statement_value = 0.0;

        local dmg_alpha = 0.0;
        local dmg_value = 0.0;

        local dt_alpha = 0.0;
        local dt_value = 0.0;

        local osaa_alpha = 0.0;
        local osaa_value = 0.0;

        local fs_alpha = 0.0;
        local fs_value = 0.0;

        local function get_state()
            if localplayer.is_frozen then
                return "FROZEN";
            end

            if localplayer.is_airborne then
                return "AIRBORNE";
            end

            if localplayer.is_crouched then
                return "CROUCH";
            end

            if localplayer.is_moving then
                if software.is_slow_motion() then
                    return "SLOW-MO";
                end

                return "MOVING";
            end

            return "STAND";
        end

        local function update_global_animations()
            if indicate_state.selection:get() ~= "Traditional" then
                alpha = motion.interp(alpha, 0.0, 0.05);
                align = motion.interp(align, 1.0, 0.05);

                return;
            end

            local me = entity_get_local_player();
            if me == nil then return end

            local wpn = entity_get_player_weapon(me);
            local m_bIsScoped = entity_get_prop(me, "m_bIsScoped");

            local target_alpha = 0.0;
            local target_align = 0.0;

            if entity_is_alive(me) then
                target_alpha = 1.0;
            end

            -- if weapon is grenade

            if wpn ~= nil then
                local wpn_info = c_weapon(wpn);

                if wpn_info.weapon_type_int == 9 then
                    if indicate_state.transparency:have_key("Grenade") then
                        target_alpha = 0.25;
                        target_align = 0.0;
                    end
                end
            end

            if m_bIsScoped == 1 then
                if indicate_state.transparency:have_key("Scoped") then
                    target_alpha = 0.75;
                    target_align = 1.0;
                end
            end

            alpha = motion.interp(alpha, target_alpha, 0.05);
            align = motion.interp(align, target_align, 0.05);
        end

        local function update_feature_animations()
            if alpha == 0.0 then
                return;
            end

            local shift = exploit.get().shift;
            local state = get_state();

            statement_alpha = motion.interp(statement_alpha, true, 0.05);
            statement_value = motion.interp(statement_value, state == last_state, 0.075);

            dmg_alpha = motion.interp(dmg_alpha, software.is_minimum_damage(), 0.05);
            dmg_value = motion.interp(dmg_value, true, 0.05);

            dt_alpha = motion.interp(dt_alpha, software.is_double_tap(), 0.05);
            dt_value = motion.interp(dt_value, shift, 0.05);

            osaa_alpha = motion.interp(osaa_alpha, software.is_on_shot_antiaim(), 0.05);
            osaa_value = motion.interp(osaa_value, shift or dt_alpha > 0.0, 0.05);

            fs_alpha = motion.interp(fs_alpha, ui_get(software.aa.angles.freestanding[2]), 0.05);
            fs_value = motion.interp(fs_value, ui_get(software.aa.angles.freestanding[1]), 0.05);

            if statement_value < 0.1 then
                last_state = state;
            end
        end

        function traditional.think()
            update_global_animations();
            update_feature_animations();
        end

        function traditional.draw()
            if alpha == 0.0 then
                return;
            end

            local clock = globals_realtime() * 1.25;

            local screen = vector(client_screen_size());
            local position = screen * 0.5;

            local r0, g0, b0, a0 = 71, 71, 71, 255;
            local r1, g1, b1, a1 = visualization.color_picker:get();

            a1 = maxf(a1, 55);
            a0 = a1;

            position.x = position.x + round(10 * align);
            position.y = position.y + 18;

            do
                local text_pos = position:clone();
                local text_alpha = alpha;

                local text = "Aura";
                local flags = "db";

                local r, g, b, a = r1, g1, b1, a1;

                local measure = vector(renderer_measure_text(flags, text));
                local offset = (measure.x * 0.5) * (1 - align);

                text_pos.x = round(text_pos.x - offset);

                text = decorations.wave(text, clock, r1, g1, b1, a1 * text_alpha, r0, g0, b0, a0 * text_alpha);
                renderer_text(text_pos.x, text_pos.y, r, g, b, a * alpha, flags, 0, text);

                position.y = position.y + measure.y;
            end

            if statement_alpha > 0.0 then
                local text_pos = position:clone();
                local text_alpha = alpha * statement_alpha;

                local text = last_state;
                local flags = "-d";

                local r, g, b, a = r1, g1, b1, a1;

                local measure = vector(renderer_measure_text(flags, text));
                local offset = (measure.x * 0.5) * (1 - align);

                text_pos.x = round(text_pos.x - offset) - 1;

                text = decorations.fade(text, statement_value, r1, g1, b1, a1 * text_alpha, r0, g0, b0, a0 * text_alpha);
                renderer_text(text_pos.x, text_pos.y, r, g, b, a * text_alpha, flags, 0, text);

                position.y = position.y + round(measure.y * statement_alpha);
            end

            if dmg_alpha > 0.0 then
                local text_pos = position:clone();
                local text_alpha = alpha * dmg_alpha;

                local text = "DMG";
                local flags = "-d";

                local r, g, b, a = r1, g1, b1, a1;

                local measure = vector(renderer_measure_text(flags, text));
                local offset = (measure.x * 0.5) * (1 - align);

                text_pos.x = round(text_pos.x - offset) - 1;

                text = decorations.fade(text, dmg_value, r1, g1, b1, a1 * text_alpha, r0, g0, b0, a0 * text_alpha);
                renderer_text(text_pos.x, text_pos.y, r, g, b, a * text_alpha, flags, 0, text);

                position.y = position.y + round(measure.y * dmg_alpha);
            end

            if dt_alpha > 0.0 then
                local text_pos = position:clone();
                local text_alpha = alpha * dt_alpha;

                local text = "DT";
                local flags = "-d";

                local r, g, b, a = r1, g1, b1, a1;

                local measure = vector(renderer_measure_text(flags, text));

                local radius = round(measure.y * 0.33);
                local thickness = round(radius * 0.25);

                local gap = 4;
                local margin = radius + gap;

                local offset = (measure.x + margin) * (0.5) * (1 - align);

                text_pos.x = round(text_pos.x - offset) - 1;

                text = decorations.fade(text, dt_value, r1, g1, b1, a1 * text_alpha, r0, g0, b0, a0 * text_alpha);
                renderer_text(text_pos.x, text_pos.y, r, g, b, a * text_alpha, flags, 0, text);

                text_pos.x = text_pos.x + measure.x;
                renderer_circle_outline(text_pos.x + margin, text_pos.y + measure.y * 0.5, r, g, b, a * text_alpha, radius, 180, dt_value, thickness);

                position.y = position.y + round(measure.y * dt_alpha);
            end

            if osaa_alpha > 0.0 then
                local text_pos = position:clone();
                local text_alpha = alpha * osaa_alpha;

                local text = "OSAA";
                local flags = "-d";

                local r, g, b, a = r1, g1, b1, a1;

                local measure = vector(renderer_measure_text(flags, text));
                local offset = (measure.x * 0.5) * (1 - align);

                text_pos.x = round(text_pos.x - offset) - 1;

                text = decorations.fade(text, osaa_value, r1, g1, b1, a1 * text_alpha, r0, g0, b0, a0 * text_alpha);
                renderer_text(text_pos.x, text_pos.y, r, g, b, a * text_alpha, flags, 0, text);

                position.y = position.y + round(measure.y * osaa_alpha);
            end

            if fs_alpha > 0.0 then
                local text_pos = position:clone();
                local text_alpha = alpha * fs_alpha;

                local text = "FS";
                local flags = "-d";

                local r, g, b, a = r1, g1, b1, a1;

                local measure = vector(renderer_measure_text(flags, text));
                local offset = (measure.x * 0.5) * (1 - align);

                text_pos.x = round(text_pos.x - offset) - 1;

                text = decorations.fade(text, fs_value, r1, g1, b1, a1 * text_alpha, r0, g0, b0, a0 * text_alpha);
                renderer_text(text_pos.x, text_pos.y, r, g, b, a * text_alpha, flags, 0, text);

                position.y = position.y + round(measure.y * fs_alpha);
            end
        end
    end

    indicate_state.selection = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles", "Indicate state", {
        "Off",
        "Traditional"
    })
    : record("visuals", "indicate_state::selection")
    : save();

    indicate_state.transparency = menu.new_item(ui_new_multiselect, "AA", "Anti-aimbot angles", merge { " » ", "Transparency" }, {
        "Grenade",
        "Scoped"
    })
    : record("visuals", "indicate_state::transparency")
    : save();

    function indicate_state.frame()
        if not iengineclient.is_in_game() then
            return;
        end

        traditional.think();
        traditional.draw();
    end
end

--- region connection_info
do
    local TIMEOUT_LIMIT = 0.5;

    local function get_timeout()
        local net = inetchannel.get();

        if net == nil then
            return 0.0;
        end

        if inetchannel.is_loopback(net) then
            return 0.0;
        end

        local net_time = inetchannel.get_time(net);
        local timeout = net_time - net.last_received;

        if timeout < TIMEOUT_LIMIT then
            return 0.0;
        end

        return timeout;
    end

    local function draw()
        local time = get_timeout();

        if time == 0.0 then
            return;
        end

        local clock = globals_realtime();

        local screen = vector(client_screen_size());
        local pos = vector(screen.x * 0.5, screen.y * 0.175);

        local r0, g0, b0, a0 = 71, 71, 71, 255;
        local r1, g1, b1, a1 = visualization.color_picker:get();

        a1 = maxf(a1, 55);
        a0 = a1;

        local text = f("Time without connection: %.1fs", time);
        local flags = "d";

        local measure = vector(renderer_measure_text(flags, text));
        pos.x = pos.x - round(measure.x * 0.5);

        text = decorations.wave(text, clock, r1, g1, b1, a1, r0, g0, b0, a0);
        renderer_text(pos.x, pos.y, r1, g1, b1, a1, flags, 0, text);
    end

    function connection_info.frame()
        draw();
    end
end

--- region drop_grenades
do
    local grenade_list = {
        "Smoke",
        "High explosive",
        "Molotov/Incendiary"
    };

    local queue = { };
    local prev_wpn;

    local prev_value = { unpack(grenade_list) };

    local function is_allowed_class(item_class)
        if item_class == "weapon_smokegrenade" then
            return drop_grenades.selection:have_key("Smoke");
        end

        if item_class == "weapon_hegrenade" then
            return drop_grenades.selection:have_key("High explosive");
        end

        if item_class == "weapon_incgrenade" or item_class == "weapon_molotov" then
            return drop_grenades.selection:have_key("Molotov/Incendiary");
        end

        return false;
    end

    local function is_weapon_allowed(weapon)
        local info = c_weapon(weapon);

        if info.weapon_type_int ~= 9 then
            return false;
        end

        if not is_allowed_class(info.item_class) then
            return false;
        end

        return true;
    end

    local function update_queue(ent)
        local weapons = utils.get_player_weapons(ent);

        for i = 1, #weapons do
            local weapon = weapons[i];

            if not is_weapon_allowed(weapon) then
                goto continue;
            end

            queue[#queue + 1] = weapon;
            ::continue::
        end
    end

    local function selection_callback(item)
        local new_value = ui_get(item);

        if empty(new_value) then
            ui_set(item, prev_value);
            drop_grenades.selection:update_value(item);

            return;
        end

        prev_value = new_value;
    end

    drop_grenades.enabled = menu.new_item(ui_new_checkbox, "AA", "Other", "Drop grenades")
    : record("misc", "drop_grenades::enabled");

    drop_grenades.hotkey = menu.new_item(ui_new_hotkey, "AA", "Other", merge { "\n", "drop_grenades::hotkey" }, true)
    : record("misc", "drop_grenades::hotkey");

    drop_grenades.selection = menu.new_item(ui_new_multiselect, "AA", "Other", merge { " » ", "Selection", "\n", "drop_grenades::selection" }, grenade_list)
    : record("misc", "drop_grenades::selection");

    function drop_grenades.setup_command(e)
        if not drop_grenades.enabled:get() then
            clear(queue);
            return;
        end

        local me = entity_get_local_player();

        local wpn = entity_get_player_weapon(me);
        if wpn == nil then return end

        if drop_grenades.hotkey:rawget() then
            clear(queue);
            update_queue(me);
        end

        if empty(queue) then
            return;
        end

        local wanted_weapon = queue[1];

        if wanted_weapon == nil then
            return;
        end

        if wpn == wanted_weapon then
            local pitch, yaw = client_camera_angles();

            -- 0.0001 is for making a difference in pitch for skeet
            -- otherwise it will not disable antiaim and will not setup our angles
            local offset = 0.0001;

            if pitch > 0 then
                offset = -offset;
            end

            e.yaw = yaw;
            e.pitch = pitch + offset;

            if wpn == prev_wpn then
                e.no_choke = true;
                e.allow_send_packet = true;

                if e.chokedcommands == 0 then
                    client_exec("drop");
                    table_remove(queue, 1);
                end
            end
        end

        e.weaponselect = wanted_weapon;
        prev_wpn = wpn;
    end

    drop_grenades.selection:set(prev_value);
    drop_grenades.selection:set_callback(selection_callback);
end

--- region quick_ladder_move
do
    local function is_on_ladder()
        if localplayer.movetype ~= 9 then
            return false;
        end

        if localplayer.is_onground then
            return false;
        end

        return true;
    end

    local function is_throwing_grenade(wpn)
        local wpn_info = c_weapon(wpn);

        if wpn_info.weapon_type_int ~= 9 then
            return false;
        end

        local m_fThrowTime = entity_get_prop(wpn, "m_fThrowTime");

        if m_fThrowTime == 0 then
            return false;
        end

        return true;
    end

    quick_ladder_move.enabled = menu.new_item(ui_new_checkbox, "AA", "Other", "Quick ladder move")
    : record("misc", "quick_ladder_move::enabled");

    function quick_ladder_move.setup_command(e)
        if not quick_ladder_move.enabled:get() then
            return;
        end

        local me = entity_get_local_player();

        if not is_on_ladder() then
            return;
        end

        local wpn = entity_get_player_weapon(me);
        if wpn == nil then return end

        if is_throwing_grenade(wpn) then
            return;
        end

        local forward = vector(entity_get_prop(me, "m_vecLadderNormal"));
        if forward:lengthsqr() == 0 then return end

        local view = vector(client_camera_angles());
        local angle = vector(forward:angles());

        local delta_yaw = angle.y - view.y + 180;
        local delta_pitch = angle.x - view.x;

        delta_yaw = utils.normalize_yaw(delta_yaw);
        delta_pitch = clamp(delta_pitch, -89, 89);

        local abs_yaw = absf(delta_yaw);

        local pitch = 89;
        local yaw_offset = -90;

        local is_looking_down = delta_pitch < -45;
        local is_looking_to_right = delta_yaw > 0;

        local is_sidemove = e.sidemove > 0;
        local is_forwardmove = e.forwardmove > 0;

        -- sideways
        if abs_yaw > 70 and abs_yaw < 135 then
            if e.forwardmove ~= 0 or e.sidemove == 0 then
                return;
            end

            if not is_looking_to_right then
                yaw_offset = -yaw_offset;
            end

            if is_looking_to_right then
                is_sidemove = not is_sidemove;
            end

            e.in_back = is_sidemove and 1 or 0;
            e.in_forward = is_sidemove and 0 or 1;

            if is_looking_to_right then
                is_sidemove = not is_sidemove;
            end

            e.in_moveleft = is_sidemove and 1 or 0;
            e.in_moveright = is_sidemove and 0 or 1;

            e.pitch = pitch;
            e.yaw = utils.normalize_yaw(angle.y + yaw_offset);

            return;
        end

        -- straight
        if e.sidemove ~= 0 or e.forwardmove == 0 then
            return;
        end

        if not is_looking_to_right then
            yaw_offset = -yaw_offset;
        end

        if not is_looking_down then
            is_forwardmove = not is_forwardmove;
        end

        e.in_back = is_forwardmove and 0 or 1;
        e.in_forward = is_forwardmove and 1 or 0;

        if not is_looking_to_right then
            is_forwardmove = not is_forwardmove;
        end

        e.in_moveleft = is_forwardmove and 1 or 0;
        e.in_moveright = is_forwardmove and 0 or 1;

        e.pitch = pitch;
        e.yaw = utils.normalize_yaw(angle.y + yaw_offset);
    end
end

--- region hitsound
do
    local sound = "survival\\paradrop_idle_01.wav";

    local function playsound()
        local volume = hitsound.volume:get() * 0.01;
        local pitch = hitsound.pitch:get();

        ienginesound.playsound(sound, volume, pitch);
    end

    hitsound.enabled = menu.new_item(ui_new_checkbox, "AA", "Anti-aimbot angles", "Hit sound")
    : record("misc", "hitsound::enabled");

    hitsound.volume = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { " » ", "Volume", "\n", "hitsound::volume" }, 1, 100, 50, true, "%")
    : record("misc", "hitsound::volume::volume");

    hitsound.pitch = menu.new_item(ui_new_slider, "AA", "Anti-aimbot angles", merge { " » ", "Pitch", "\n", "hitsound::pitch" }, 50, 250, 100, true, "%")
    : record("misc", "hitsound::pitch");

    function hitsound.player_hurt(e)
        if not hitsound.enabled:get() then
            return;
        end

        local me = entity_get_local_player();

        local userid = client_userid_to_entindex(e.userid);
        if me == userid then return end

        local attacker = client_userid_to_entindex(e.attacker);
        if me ~= attacker then return end

        playsound();
    end
end

--- region animation_breakers
do
    animation_breakers.selection = menu.new_item(ui_new_multiselect, "AA", "Anti-aimbot angles", "Animation breakers", { "Onground", "Airborne", "Quick peek assist", "Pitch zero on land", "Remove lean animation" })
    : record("misc", "animation_breakers::selection");

    animation_breakers.onground = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles", merge { " » ", "Onground animations" }, { "Static", "Jitter", "Walking" })
    : record("misc", "animation_breakers::onground");

    animation_breakers.airborne = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles",merge { " » ", "Airborne animations" }, { "Static", "Walking" })
    : record("misc", "animation_breakers::airborne");

    animation_breakers.quick_peek_assist = menu.new_item(ui_new_combobox, "AA", "Anti-aimbot angles", merge { " » ", "Quick peek assist" }, { "Off", "Always slide", "Never slide" })
    : record("misc", "animation_breakers::quick_peek_assist");

    local function shutdown()
        override.unset(software.aa.other.leg_movement);
    end

    local function update_onground_animations(me)
        if not animation_breakers.selection:have_key("Onground") then
            return;
        end

        if not localplayer.is_onground then
            return;
        end

        local value = animation_breakers.onground:get();

        if value == "Static" then
            entity_set_prop(me, "m_flPoseParameter", 1, 0);
            override.set(software.aa.other.leg_movement, "Always slide");

            return;
        end

        if value == "Jitter" then
            local tick = globals_tickcount();
            local choke = globals_chokedcommands();

            local delay = 5;

            if (tick % delay * 2) > delay then
                if choke > 0 then
                    entity_set_prop(me, "m_flPoseParameter", 1, 0);
                end

                override.set(software.aa.other.leg_movement, "Always slide");
                return;
            end

            override.set(software.aa.other.leg_movement, "Never slide");
            return;
        end

        if value == "Walking" then
            entity_set_prop(me, "m_flPoseParameter", 0, 7);
            override.set(software.aa.other.leg_movement, "Never slide");

            return;
        end
    end

    local function update_airborne_animations(me)
        if not animation_breakers.selection:have_key("Airborne") then
            return;
        end

        if localplayer.is_onground then
            return;
        end

        local value = animation_breakers.airborne:get();

        if value == "Static" then
            entity_set_prop(me, "m_flPoseParameter", 1, 6);
            return;
        end

        if value == "Walking" then
            local my_info = c_entity(me);
            if my_info == nil then return end

            local anim_overlay = my_info:get_anim_overlay(6);
            if anim_overlay == nil then return end

            local mult = 0.50;
            local cycle = globals_realtime() * mult;

            anim_overlay.weight = 1.0;
            anim_overlay.cycle = cycle % 1.0;

            return;
        end
    end

    local function update_quick_peek_animations(me, cmd)
        if not animation_breakers.selection:have_key("Quick peek assist") then
            return;
        end

        if not software.is_quick_peek_assist() then
            return;
        end

        local value = animation_breakers.quick_peek_assist:get();

        if value == "Off" then
            local target = ui_get(software.aa.other.leg_movement);

            if target == "Never slide" then
                leg_movement.never_slide(cmd);
                return;
            end

            return;
        end

        if value == "Always slide" then
            leg_movement.always_slide(cmd);
            return;
        end

        if value == "Never slide" then
            leg_movement.never_slide(cmd);
            return;
        end
    end

    local function update_land_animations(me)
        if not animation_breakers.selection:have_key("Pitch zero on land") then
            return;
        end

        if localplayer.is_airborne then
            return;
        end

        if not localplayer.is_landing then
            return;
        end

        entity_set_prop(me, "m_flPoseParameter", 0.5, 12);
    end

    local function update_lean_animations(me)
        if not animation_breakers.selection:have_key("Remove lean animation") then
            return;
        end

        entity_set_prop(me, "m_flPoseParameter", 0, 2);
    end

    function animation_breakers.shutdown()
        shutdown();
    end

    function animation_breakers.pre_render()
        if not home.enabled:get() then
            shutdown();
            return;
        end

        if localplayer.movetype ~= 2 then
            return;
        end

        local me = entity_get_local_player();
        shutdown();

        update_onground_animations(me);
        update_airborne_animations(me);
        update_land_animations(me);
        update_lean_animations(me);
    end

    function animation_breakers.finish_command(e)
        if localplayer.movetype ~= 2 then
            return;
        end

        local me = entity_get_local_player();
        local cmd = iinput.get_usercmd(0, e.command_number);

        update_quick_peek_animations(me, cmd);
    end
end

--- threads
local function main()
    settings.load_last_save();
    menu.update();
end

local function menu_update()
    home.enabled:display();

    if not home.enabled:get() then
        return;
    end

    home.new_line_break:display();

    home.username:display();
    home.build:display();
    home.last_update:display();

    home.end_line_break:display();

    home.selection:display();

    if home.selection:get() == "- Profile" then
        profile.hide_username:display();

        profile.import:display();
        profile.export:display();
        profile.reset:display();
    end

    if home.selection:get() == "- Aimbot" then
        correction.enabled:display();
    end

    if home.selection:get() == "- Anti-aimbot" then
        -- Main
        antiaimbot.selection:display();

        -- Functional
        if antiaimbot.selection:get() == "- Main" then
            avoid_backstab.enabled:display();
            safe_head.enabled:display();

            break_lc.enabled:display();
            defensive.enabled:display();

            if break_lc.enabled:get() then
                break_lc.states:display();
            end

            if defensive.enabled:get() then
                defensive.states:display();
                defensive.exploit:display();
                defensive.sensitivity:display();
                defensive.ping_target:display();
            end
        end

        if antiaimbot.selection:get() == "- Angles" then
            angles.type:display();

            if angles.type:get() == "Custom" then
                angles.custom.state:display();

                local state = angles.custom.state:get();
                local list = angles.custom[state];

                if list.enabled ~= nil then
                    list.enabled:display();

                    if not list.enabled:get() then
                        goto continue;
                    end
                end

                if list.pitch ~= nil then
                    local pitch = list.pitch:get();
                    list.pitch:display();

                    if pitch == "Custom" or pitch == "Adaptive" or pitch == "Up & Down" then
                        list.pitch_offset:display();
                    end
                end

                if list.yaw_base ~= nil then
                    list.yaw_base:display();
                end

                local yaw_value = list.yaw:get();
                list.yaw:display();

                if yaw_value ~= "Off" then
                    if yaw_value == "180 LR" then
                        list.yaw_180lr_mode:display();

                        list.yaw_left:display();
                        list.yaw_right:display();

                        if list.yaw_180lr_mode:get() == "Switch delay" then
                            list.yaw_switch_delay:display();
                        end
                    else
                        list.yaw_offset:display();
                    end

                    list.yaw_jitter:display();

                    if list.yaw_jitter:get() ~= "Off" then
                        list.jitter_mode:display();

                        if list.jitter_mode:get() == "Default" then
                            list.jitter_offset:display();
                            list.jitter_randomization:display();
                        else
                            list.jitter_from:display();
                            list.jitter_to:display();
                        end
                    end
                end

                local body_yaw = list.body_yaw:get();
                list.body_yaw:display();

                if body_yaw ~= "Off" then
                    if body_yaw ~= "Opposite" then
                        list.body_yaw_offset:display();
                    end

                    list.freestanding_body_yaw:display();
                end

                ::continue::
            end
        end

        -- Important
        yaw_direction.enabled:display();
        manual_direction.enabled:display();

        if yaw_direction.enabled:get() then
            yaw_direction.edge_yaw:display();
            yaw_direction.freestanding:display();
            yaw_direction.options:display();
        end

        if manual_direction.enabled:get() then
            manual_direction.left_manual.label:display();
            manual_direction.left_manual.hotkey:display();

            manual_direction.right_manual.label:display();
            manual_direction.right_manual.hotkey:display();

            manual_direction.reset_manual.label:display();
            manual_direction.reset_manual.hotkey:display();

            manual_direction.forward_manual.label:display();
            manual_direction.forward_manual.hotkey:display();

            manual_direction.options:display();
        end
    end

    if home.selection:get() == "- Visualisation" then
        visualization.selection:display();

        if visualization.selection:get() == "- Main" then
            indicate_state.selection:display();

            if indicate_state.selection:get() ~= "Off" then
                indicate_state.transparency:display();
            end
        end

        visualization.color_label:display();
        visualization.color_picker:display();
    end

    if home.selection:get() == "- Miscellaneous" then
        -- Main
        animation_breakers.selection:display();
        hitsound.enabled:display();

        -- Functional
        if animation_breakers.selection:have_key("Onground") then
            animation_breakers.onground:display();
        end

        if animation_breakers.selection:have_key("Airborne") then
            animation_breakers.airborne:display();
        end

        if animation_breakers.selection:have_key("Quick peek assist") then
            animation_breakers.quick_peek_assist:display();
        end

        if hitsound.enabled:get() then
            hitsound.volume:display();
            hitsound.pitch:display();
        end

        -- Important
        drop_grenades.enabled:display();
        drop_grenades.hotkey:display();

        quick_ladder_move.enabled:display();

        if drop_grenades.enabled:get() then
            drop_grenades.selection:display();
        end
    end
end

-- shutdown
client_set_event_callback("shutdown", animation_breakers.shutdown);
client_set_event_callback("shutdown", correction.shutdown);
client_set_event_callback("shutdown", antiaimbot.shutdown);
client_set_event_callback("shutdown", settings.shutdown);
client_set_event_callback("shutdown", home.shutdown);
client_set_event_callback("shutdown", db.shutdown);

-- configs
client_set_event_callback("pre_config_save", antiaimbot.shutdown);
client_set_event_callback("pre_config_save", settings.shutdown);
client_set_event_callback("pre_config_save", db.shutdown);

-- fire events
client_set_event_callback("player_hurt", hitsound.player_hurt);

-- createmove
client_set_event_callback("pre_predict_command", localplayer.pre_predict_command);
client_set_event_callback("predict_command", localplayer.predict_command);

client_set_event_callback("setup_command", exploit.setup_command);
client_set_event_callback("setup_command", statement.setup_command);
client_set_event_callback("setup_command", antiaimbot.setup_command);
client_set_event_callback("setup_command", quick_ladder_move.setup_command);
client_set_event_callback("setup_command", drop_grenades.setup_command);

client_set_event_callback("finish_command", animation_breakers.finish_command);

-- frame stage notify
client_set_event_callback("net_update_end", exploit.net_update);
client_set_event_callback("net_update_end", localplayer.net_update);
client_set_event_callback("net_update_end", correction.net_update);

client_set_event_callback("pre_render", animation_breakers.pre_render);

-- drawing
client_set_event_callback("paint_ui", home.frame);
client_set_event_callback("paint_ui", manual_direction.frame);
client_set_event_callback("paint_ui", indicate_state.frame);

client_set_event_callback("paint", exploit.frame);
client_set_event_callback("paint", connection_info.frame);

-- menu
menu.set_callback(menu_update);

-- main
client_delay_call(0, main);