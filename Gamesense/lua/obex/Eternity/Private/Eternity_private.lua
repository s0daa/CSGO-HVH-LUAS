-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- #region API start
local API = {
    MENU = {
        Get = ui.get,
        Set = ui.set,
        Reference = ui.reference,
        Visible = ui.set_visible,
        Label = ui.new_label,
        Checkbox = ui.new_checkbox,
        Hotkey = ui.new_hotkey,
        Combobox = ui.new_combobox,
        Colorpicker = ui.new_color_picker,
        Multiselect = ui.new_multiselect,
        Slider = ui.new_slider,
        Textbox = ui.new_textbox,
        Button = ui.new_button,
        Callback = ui.set_callback,
        IsOpen = ui.is_menu_open,
        MousePos = ui.mouse_position
    },
    CLIENT = {
        Delay = client.delay_call,
        Interface = client.create_interface,
        Cvar = client.set_cvar,
        Callback = client.set_event_callback,
        UnsetCallback = client.unset_event_callback,
        EyePos = client.eye_position,
        CamAngles = client.camera_angles,
        Trace = client.trace_line,
        UIDtoENT = client.userid_to_entindex,
        Update = client.update_player_list,
        Screen = client.screen_size,
        ESPFlag = client.register_esp_flag,
        Bullet = client.trace_bullet,
        Random = client.random_int,
        Exec = client.exec,
        Log = client.color_log,
        Key = client.key_state,
        Time = client.system_time,
        Latency = client.latency
    },
    TABLE = {
        Sort = table.sort,
        Insert = table.insert,
        GetN = table.getn,
        Remove = table.remove
    },
    ENT = {
        LocalPlayer = entity.get_local_player,
        PlayerWeapon = entity.get_player_weapon,
        Prop = entity.get_prop,
        IsAlive = entity.is_alive,
        GetPlayers = entity.get_players,
        HitboxPos = entity.hitbox_position,
        GameRules = entity.get_game_rules,
        BoundingBox = entity.get_bounding_box,
        IsEnemy = entity.is_enemy,
        PlayerName = entity.get_player_name,
        GetAll = entity.get_all,
        ClassName = entity.get_classname
    },
    RENDER = {
        Text = renderer.text,
        Indicator = renderer.indicator,
        Gradient = renderer.gradient,
        Measure = renderer.measure_text,
        Rectangle = renderer.rectangle,
        CircleOutline = renderer.circle_outline
    },
    GLOBALS = {
        Frametime = globals.absoluteframetime,
        Realtime = globals.realtime,
        Max = globals.maxplayers,
        Curtime = globals.curtime,
        Ticks = globals.tickinterval
    },
    PLIST = {
        Get = plist.get
    },
    BIT = {
        Band = bit.band
    },
    DATA = {
        Write = database.write,
        Read = database.read
    },
    PANORAMA = panorama.open()
}
-- #region API end

-- #region FFI start
local err = false
local requiredLibs = {
    [1] = {
        Module = "gamesense/chat",
        Link = "https://gamesense.pub/forums/viewtopic.php?id=30625"
    },
    [2] = {
        Module = "gamesense/antiaim_funcs",
        Link = "https://gamesense.pub/forums/viewtopic.php?id=29665"
    }
}

for k in ipairs(requiredLibs) do
    if (not pcall(require, requiredLibs[k].Module)) then
        local base = requiredLibs[k]
        if (not err) then
            err = true
        end
        error(string.format("You are missing a module: %s, pls subscribe to it by following the link: %s", base.Module, base.Link))
    end
end

local LIBS = {
    ffi = require("ffi"),
    vector = require("vector"),
    Chat = require("gamesense/chat"),
    AntiAim = require("gamesense/antiaim_funcs")
}

LIBS.ffi.cdef[[
    typedef long(__thiscall* get_file_time_t)(void* this, const char* pFileName, const char* pPathID);
    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
    typedef bool(__thiscall* lgts)(float, float, float, float, float, float, short);
    typedef void*(__thiscall* get_net_channel_info_t)(void*);
    typedef const char*(__thiscall* get_name_t)(void*);
    typedef const char*(__thiscall* get_address_t)(void*);
    typedef float(__thiscall* get_local_time_t)(void*);
    typedef float(__thiscall* get_time_connected_t)(void*);
    typedef float(__thiscall* get_avg_latency_t)(void*, int);
    typedef float(__thiscall* get_avg_loss_t)(void*, int);
    typedef float(__thiscall* get_avg_choke_t)(void*, int);
]]

local interface_ptr = LIBS.ffi.typeof("void***")
local rawivengineclient = API.CLIENT.Interface("engine.dll", "VEngineClient014") or error("VEngineClient014 wasnt found", 2)
local ivengineclient = LIBS.ffi.cast(interface_ptr, rawivengineclient) or error("rawivengineclient is nil", 2)
local get_net_channel_info = LIBS.ffi.cast("get_net_channel_info_t", ivengineclient[0][78]) or error("ivengineclient is nil")
local FLOW_OUTGOING = 0
local FLOW_INCOMING = 1
local MAX_FLOWS = 2
-- #region FFI end

-- #region REFERENCES start
local REFS = {
    RAGE = {
        Ragebot = {
            API.MENU.Reference("RAGE", "Aimbot", "Enabled")
        },
        ForceSafePoint = API.MENU.Reference("RAGE", "Aimbot", "Force safe point"),
        Autowall = API.MENU.Reference("RAGE", "Other", "Automatic penetration"),
        AutoShoot = API.MENU.Reference("RAGE", "Other", "Automatic fire"),
        Hitchance = API.MENU.Reference("RAGE", "Aimbot", "Minimum hit chance"),
        MinDamage = API.MENU.Reference("RAGE", "Aimbot", "Minimum damage"),
        MaxFOV = API.MENU.Reference("RAGE", "Other", "Maximum FOV"),
        SkeetResolv = API.MENU.Reference("RAGE", "Other", "Anti-aim correction"),
        FakeDuck = API.MENU.Reference("RAGE", "Other", "Duck peek assist"),
        --ForceBodyAim = API.MENU.Reference("RAGE", "Other", "Force body aim")
    },
    AntiAim = {
        Master = API.MENU.Reference("AA", "Anti-aimbot angles", "Enabled"),
        Pitch = API.MENU.Reference("AA", "Anti-aimbot angles", "Pitch"),
        YawBase = API.MENU.Reference("AA", "Anti-aimbot angles", "Yaw base"),
        Yaw = {
            API.MENU.Reference("AA", "Anti-aimbot angles", "Yaw")
        },
        YawJitter = API.MENU.Reference("AA", "Anti-aimbot angles", "Yaw jitter"),
        Body = {
            API.MENU.Reference("AA", "Anti-aimbot angles", "Body yaw")
        },
        Freestand = API.MENU.Reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        EdgeYaw = API.MENU.Reference("AA", "Anti-aimbot angles", "Edge yaw"),
        FreestandHide = { 
            API.MENU.Reference("AA", "Anti-aimbot angles", "Freestanding")
        },
        --YawLimit = API.MENU.Reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
        Roll = API.MENU.Reference("AA", "Anti-aimbot angles", "Roll")
    },
    FakeLag = {
        Master = {
            API.MENU.Reference("AA", "Fake lag", "Enabled")
        },
        Slowwalk = {
            API.MENU.Reference("AA", "Other", "Slow motion")
        },
        --SlowwalkType = API.MENU.Reference("AA", "Other", "Slow motion type"),
        OnShot = {
            API.MENU.Reference("AA", "Other", "On shot anti-aim")
        },
        FakePeek = API.MENU.Reference("AA", "Other", "Fake peek"),
    },
    Visuals = {
        ThirdPerson = {
            API.MENU.Reference("VISUALS", "Effects", "Force third person (alive)")
        },
        ThirdPersonDead = API.MENU.Reference("VISUALS", "Effects", "Force third person (dead)")
    },
    Misc = {
        DamageDealt = API.MENU.Reference("MISC", "Miscellaneous", "Log damage dealt"),
        NameSteal = API.MENU.Reference("MISC", "Miscellaneous", "Steal player name"),
        DPIScale = API.MENU.Reference("MISC", "Settings", "DPI scale")
    },
    PlayerList = {
        Players = API.MENU.Reference("PLAYERS", "Players", "Player list"),
        ApplyToAll = API.MENU.Reference("PLAYERS", "Adjustments", "Apply to all"),
        ForceBodyYaw = API.MENU.Reference("PLAYERS", "Adjustments", "Force body yaw"),
        ForceSlider = API.MENU.Reference("PLAYERS", "Adjustments", "Force body yaw value")
    }
}
-- #region REFERENCES end

-- #region VARIABLES start
local VARS = {
    weapons = {
        ["Global"] = { },
        ["Auto"] = { 11, 38 },
        ["Awp"] = { 9 },
        ["Scout"] = { 40 },
        ["Desert Eagle"] = { 1 },
        ["Revolver"] = { 64 },
        ["Pistol"] = { 2, 3, 4, 30, 32, 36, 61, 63 },
        ["Rifle"] = { 7, 8, 10, 13, 16, 39, 60 } 
    },
    HP = {
        [-1] = "Disable",
        [0] = "Auto",
        [101] = "HP+1", 
        [102] = "HP+2", 
        [103] = "HP+3",
        [104] = "HP+4", 
        [105] = "HP+5", 
        [106] = "HP+6", 
        [107] = "HP+7", 
        [108] = "HP+8", 
        [109] = "HP+9", 
        [110] = "HP+10", 
        [111] = "HP+11", 
        [112] = "HP+12", 
        [113] = "HP+13", 
        [114] = "HP+14", 
        [115] = "HP+15", 
        [116] = "HP+16", 
        [117] = "HP+17", 
        [118] = "HP+18", 
        [119] = "HP+19", 
        [120] = "HP+20", 
        [121] = "HP+21", 
        [122] = "HP+22", 
        [123] = "HP+23", 
        [124] = "HP+24", 
        [125] = "HP+25", 
        [126] = "HP+26"
    },
    Hitgroups = {
        "body",
        "head",
        "chest",
        "stomach",
        "left arm",
        "right arm",
        "left leg",
        "right leg",
        "neck",
        "?",
        "gear"
    },
    inds = {
        "Minimum Damage", 
        "Body Aim", 
        "Safe Point", 
        "Hide Shots",
        "Triggermagnet", 
        "Autowall", 
        "Manual Resolver", 
        "FOV", 
        "Anti-aim Direction"
    },
    move_inds = {
        [0] = "Don't Move"
    },
    Votes = {
        IndicesNoteam = {
            [0] = "kick",
            [1] = "changelevel",
            [3] = "scrambleteams",
            [4] = "swapteams"
        },
        IndicesTeam = {
            [1] = "starttimeout",
            [2] = "surrender"
        },
        Descriptions = {
            changelevel = "change the map",
            scrambleteams = "scramble the teams",
            starttimeout = "start a timeout",
            surrender = "surrender",
            kick = "kick"
        },
        OnGoingVotes = { },
        VoteOptions = { }
    },
    RGB = {
        White = {
            r = 255,
            g = 255,
            b = 255
        },
        Orange = {
            r = 110,
            g = 235,
            b = 52
        },
    },
    adaptive = { },
    references = { },
    active_config = "Global",
    side = 0,
    bruteforce_ents = { },
    ind_active = { },
    ind_active_clr = { },
    fix = false,
    frametimes = { },
    fps_prev = 0,
    last_update_time = 0,
    YawValue = 60,
    ReachedLowest = false,
    FPSStop = false,
    PingStop = false,
    LossStop = false,
    ChokeStop = false,
    FakeDuckStop = false,
    Phase = 0,
    DamageNorm = 0,
    DamageOVR = 0,
    Damage2ndOVR = 0,
    IndAnim = 0,
    KeyPhase = 1,
    OVRState = false,
    MinDMG = 0,
    Angle = 0
}
local PI = 3.14159265358979323846
local DEG_TO_RAD = PI / 180
local RAD_TO_DEG = 180 / PI
-- #region VARIABLES end

-- #region HELP_FUNCS start
local FUNCS = { }

FUNCS.HELP = {
    table_contains = function(tbl, value)
        for i = 1, #tbl do
            if tbl[i] == value then
                return true
            end
        end
        return false
    end,
    FPSTable = function()
        local Fps_Table = { }
        Fps_Table[0] = "Off"
        for i = 1, 100 do
            Fps_Table[0+i] = 0+i .. "fps"
        end
        return Fps_Table
    end,
    collect_keys = function(tbl, sort)
        local keys = { }
        sort = sort or true
        for k in pairs(tbl) do
            keys[#keys + 1] = k
        end
        if sort then
            API.TABLE.Sort(keys)
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
    calculate_fov_to_player = function(ent, lx, ly, lz, fx, fy, fz)
        local px, py, pz = API.ENT.Prop(ent, "m_vecOrigin")
        local dx, dy, dz = FUNCS.HELP.vec3_normalize(px - lx, py - ly, lz - lz)
        local dot_product = FUNCS.HELP.vec3_dot(dx, dy, dz, fx, fy, fz)
        local cos_inverse = math.acos(dot_product)
        return RAD_TO_DEG * cos_inverse
    end,
    get_closest_player_to_crosshair = function(lx, ly, lz, pitch, yaw)
        local fx, fy, fz = FUNCS.HELP.angle_to_vec(pitch, yaw)
        local enemy_players = API.ENT.GetPlayers(true)
        local nearest_player = nil
        local nearest_player_fov = math.huge
        for i = 1, #enemy_players do
            local enemy_ent = enemy_players[i]
            local fov_to_player = FUNCS.HELP.calculate_fov_to_player(enemy_ent, lx, ly, lz, fx, fy, fz)
            if fov_to_player <= nearest_player_fov then
                nearest_player = enemy_ent
                nearest_player_fov = fov_to_player
            end
        end
        return nearest_player, nearest_player_fov
    end,
    getNearestEnemy = function()
        local enemy_players = API.ENT.GetPlayers(true)
        if #enemy_players ~= 0 then
            local own_x, own_y, own_z = API.CLIENT.EyePos()
            local own_pitch, own_yaw = API.CLIENT.CamAngles()
            local closest_enemy = nil
            local closest_distance = 999999999       
            for i = 1, #enemy_players do
                local enemy = enemy_players[i]
                local enemy_x, enemy_y, enemy_z = API.ENT.HitboxPos(enemy, 0)        
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
    AccumulateFps = function()
        local ft = API.GLOBALS.Frametime()
        if ft > 0 then
            API.TABLE.Insert(VARS.frametimes, 1, ft)
        end
        local count = #VARS.frametimes
        if count == 0 then
            return 0
        end
        local i, accum = 0, 0
        while accum < 0.5 do
            i = i + 1
            accum = accum + VARS.frametimes[i]
            if i >= count then
                break
            end
        end
        accum = accum / i
        while i < count do
            i = i + 1
            API.TABLE.Remove(VARS.frametimes)
        end
        local fps = 1 / accum
        local rt = API.GLOBALS.Realtime()
        if math.abs(fps - VARS.fps_prev) > 4 or rt - VARS.last_update_time > 2 then
            VARS.fps_prev = fps
            VARS.last_update_time = rt
        else
            fps = VARS.fps_prev
        end
        return math.floor(fps + 0.5)
    end,
    ConsoleColor = function(var, bool, ...)
        local col = VARS.RGB
        local white = col.White
        local orange = col.Orange

        API.CLIENT.Log(white.r, white.g, white.b, "[\0")
        API.CLIENT.Log(orange.r, orange.g, orange.b, "Eternity\0")
        API.CLIENT.Log(white.r, white.g, white.b, "] \0")

        local arg2 = ...

        if arg2 then
            API.CLIENT.Log(white.r, white.g, white.b, var .. " ")
        elseif bool then
            API.CLIENT.Log(white.r, white.g, white.b, var .. " ")
        elseif not bool then
            API.CLIENT.Log(white.r, white.g, white.b, var .. " ")
        end
    end
}
-- #region HELP_FUNCS end

-- #region UI_ADDITIONS start
local COMBOLISTS = {
    AAModes = {
        "Manual",
        "Dynamic"
    },
    TeamCombo = {
        "Terrorist",
        "Counter-Terrorist"
    },
    MoveCombo = {
        "Standing",
        "Slowwalking",
        "Crouching",
        "Moving"
    },
    BreakModes = {
        "OFF",
        "Eye Yaw",
        "Opposite",
        "Quirky"
    },
    AAIndTypes = {
        "OFF",
        "Normal",
        "Triangle",
        "Dashes",
        "Fingers"
    },
    AAIndModes = {
        "Show Real",
        "Show Fake"
    },
    AAIndModesCross = {
        "Show Real",
        "Show Fake",
        "Show Real/Fake"
    },
    DisableModes = {
        "Fake Duck",
        "Low FPS",
        "High Ping",
        "High Packet-Loss",
        "High Choke"
    },
    VisibleA = {
        "Dynamic Weapons",
        "Autowall/Triggermagnet",
        "Manual Resolver"
    },
    VisibleB = {
        "Indicators/Style",
        "Flags",
        "Utilities",
        "Logs"
    },
    IndStyles = {
        "Default",
        "Modern",
        "Crosshair"
    },
    Flags = {
        "Desync",
        "Lethal"
    },
    Utilities = {
        "GLHF",
        "GH",
        "GG"
    },
    Logs = {
        "Hits",
        "Misses",
        "Votes"
    },
    WatermarkModes = {
        "Username Only",
        "Normal"
    },
    MoveModes = {
        "Watermark",
        "Spectator List"
    }
}

local LAYOUT = {
    TAB = {
        "AA",
        "VISUALS",
        "LUA"
    },
    CONTAINER = {
        "Anti-aimbot angles",
        "Fake lag",
        "Effects",
        "A",
        "B"
    }
}

local NEW_UI = {
    AA = {
        LegitAAMaster = {
            Box = API.MENU.Checkbox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Legit Anti-aim"),
            Modes = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "\n Legit Anti-aim Modes", COMBOLISTS.AAModes),
            ManualSwitch = API.MENU.Hotkey(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Anti-aim side switch"),
            Empty1 = API.MENU.Label(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "\n")
        },
        Modes = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Anti-aim Modes", COMBOLISTS.BreakModes),
        TeamAA = {
            Box = API.MENU.Checkbox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Anti aim per Team"),
            Teams = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "\n Anti-aim per Team", COMBOLISTS.TeamCombo),
            Breaker = {
                StandingT = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Terrorist Standing", COMBOLISTS.BreakModes),
                StandingCT = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Counter-Terrorist Standing", COMBOLISTS.BreakModes),

                SlowwalkingT = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Terrorist Slowwalking", COMBOLISTS.BreakModes),
                SlowwalkingCT = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Counter-Terrorist Slowwalking", COMBOLISTS.BreakModes),

                CrouchingT = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Terrorist Crouching", COMBOLISTS.BreakModes),
                CrouchingCT = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Counter-Terrorist Crouching", COMBOLISTS.BreakModes),

                MovingT = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Terrorist Moving", COMBOLISTS.BreakModes),
                MovingCT = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Counter-Terrorist Moving", COMBOLISTS.BreakModes)
            },
            Empty2 = API.MENU.Label(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "\n")
        },
        IndicatorAA = {
            Types = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Anti-aim Indicator", COMBOLISTS.AAIndTypes),
            Modes = API.MENU.Combobox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Anti-aim Indicator Direction", COMBOLISTS.AAIndModesCross),
            Color = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Custom Indicator Color"),
                Picker = API.MENU.Colorpicker(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Custom Indicator Color \n")
            },
            Empty9 = API.MENU.Label(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "\n")
        },
        Disabler = {
            Box = API.MENU.Checkbox(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Anti-aim Disabler"),
            Options = API.MENU.Multiselect(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "\n Anti-aim Disabler", COMBOLISTS.DisableModes),
            FPS = API.MENU.Slider(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "FPS Threshold", 0, 100, 60, true, "", 1, FUNCS.HELP.FPSTable()),
            PING = API.MENU.Slider(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Ping Threshold", 0, 150, 80, true, "ms"),
            LOSS = API.MENU.Slider(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Packet-Loss Threshold", 0, 10, 1, true, "%"),
            CHOKE = API.MENU.Slider(LAYOUT.TAB[1], LAYOUT.CONTAINER[1], "Choke Threshold", 0, 10, 1, true, "%")
        }
    },
    FakeLag = {
        Box = API.MENU.Checkbox(LAYOUT.TAB[1], LAYOUT.CONTAINER[2], "Always On")
    },
    Visual = {
        Box = API.MENU.Checkbox(LAYOUT.TAB[2], LAYOUT.CONTAINER[3], "Force first person on grenade")
    },
    API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "-------------------------[Eternity]-------------------------"),
    HandleA = API.MENU.Multiselect(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Visible Menu Items", COMBOLISTS.VisibleA),
    Empty3 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "\n"),
    DynamicWeapon = {
        Master = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Dynamic Weapons"),
        Weapons = API.MENU.Combobox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "\n Dynamic Weapons", FUNCS.HELP.collect_keys(VARS.weapons)),
        DynamicFOV = {
            Master = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Dynamic FOV"),

            GlobalMin = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Global Min FOV", 1, 180, 3, true, "", 1),
            GlobalMax = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Global Max FOV", 1, 180, 40, true, "", 1),

            AutoMin = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Auto Min FOV", 1, 180, 3, true, "", 1),
            AutoMax = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Auto Max FOV", 1, 180, 40, true, "", 1),

            AWPMin = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "AWP Min FOV", 1, 180, 3, true, "", 1),
            AWPMax = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "AWP Max FOV", 1, 180, 40, true, "", 1),

            DeagleMin = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Deagle Min FOV", 1, 180, 3, true, "", 1),
            DeagleMax = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Deagle Max FOV", 1, 180, 40, true, "", 1),

            PistolMin = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Pistol Min FOV", 1, 180, 3, true, "", 1),
            PistolMax = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Pistol Max FOV", 1, 180, 40, true, "", 1),

            RevoMin = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Revolver Min FOV", 1, 180, 3, true, "", 1),
            RevoMax = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Revolver Max FOV", 1, 180, 40, true, "", 1),

            RifleMin = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Rifle Min FOV", 1, 180, 3, true, "", 1),
            RifleMax = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Rifle Max FOV", 1, 180, 40, true, "", 1),

            ScoutMin = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Scout Min FOV", 1, 180, 3, true, "", 1),
            ScoutMax = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Scout Max FOV ", 1, 180, 40, true, "", 1),

            Factor = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Dynamic FOV Factor", 0, 250, 118, true, "x", 0.01),
            Empty4 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "\n")
        },
        AdaptiveWeapon = {
            Master = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Adaptive Settings"),
            Normal = {
                Damage = {
                    Auto = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Auto Minimum Damage", 0, 126, 22, true, "", 1, VARS.HP),
                    AWP = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "AWP Minimum Damage", 0, 126, 101, true, "", 1, VARS.HP),
                    Deagle = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Deagle Minimum Damage", 0, 126, 37, true, "", 1, VARS.HP),
                    Global = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Global Minimum Damage", 0, 126, 22, true, "", 1, VARS.HP),
                    Pistol = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Pistol Minimum Damage", 0, 126, 22, true, "", 1, VARS.HP),
                    Revolver = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Revolver Minimum Damage", 0, 126, 25, true, "", 1, VARS.HP),
                    Rifle = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Rifle Minimum Damage", 0, 126, 22, true, "", 1, VARS.HP),
                    Scout = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Scout Minimum Damage", 0, 126, 70, true, "", 1, VARS.HP)
                }
            },
            OverrideKey = API.MENU.Hotkey(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "\n Override Settings", true),
            Override = {
                Damage = {
                   Auto = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Auto Minimum Damage Override", -1, 126, -1, true, "", 1, VARS.HP),
                    AWP = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "AWP Minimum Damage Override", -1, 126, -1, true, "", 1, VARS.HP),
                    Deagle = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Deagle Minimum Damage Override", -1, 126, -1, true, "", 1, VARS.HP),
                    Pistol = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Pistol Minimum Damage Override", -1, 126, -1, true, "", 1, VARS.HP),
                    Revolver = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Revolver Minimum Damage Override", -1, 126, -1, true, "", 1, VARS.HP),
                    Rifle = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Rifle Minimum Damage Override", -1, 126, -1, true, "", 1, VARS.HP),
                    Scout = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Scout Minimum Damage Override", -1, 126, -1, true, "", 1, VARS.HP)
                }
            },
            Phase3 = {
                Damage = {
                   Auto = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Auto Minimum Damage 2nd Override", -1, 126, -1, true, "", 1, VARS.HP),
                    AWP = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "AWP Minimum Damage 2nd Override", -1, 126, -1, true, "", 1, VARS.HP),
                    Deagle = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Deagle Minimum Damage 2nd Override", -1, 126, -1, true, "", 1, VARS.HP),
                    Pistol = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Pistol Minimum Damage 2nd Override", -1, 126, -1, true, "", 1, VARS.HP),
                    Revolver = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Revolver Minimum Damage 2nd Override", -1, 126, -1, true, "", 1, VARS.HP),
                    Rifle = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Rifle Minimum Damage 2nd Override", -1, 126, -1, true, "", 1, VARS.HP),
                    Scout = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Scout Minimum Damage 2nd Override", -1, 126, -1, true, "", 1, VARS.HP)
                }
            },
            Empty5 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "\n"),
            LegitAWall = {
                Master = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Legit Autowall"),

                Global = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], " > Global Legit Autowall"),
                Auto = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], " > Auto Legit Autowall"),
                AWP = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], " > Awp Legit Autowall"),
                Deagle = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], " > Deagle Legit Autowall"),
                Pistol = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], " > Pistol Legit Autowall"),
                Revolver = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], " > Revolver Legit Autowall"),
                Rifle = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], " > Rifle Legit Autowall"),
                Scout = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], " > Scout Legit Autowall"),

                Threshold = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Autowall when X Hitboxes Visible", 1, 18, 1, true)
            }
        }
    },
    Empty6 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "\n"),
    Autowall = {
        Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Autowall"),
        Key = API.MENU.Hotkey(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "\n Autowall key", true),
        ThroughGlass = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Autowall through Glass")
    },
    Trigger = {
        Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Triggermagnet"),
        Key = API.MENU.Hotkey(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "\n Triggermagnet key", true),
        AwallBox = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Trigger + Autowall"),
        AwallKey = API.MENU.Hotkey(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "\n Trigger + Autowall key", true)
    },
    Resolver = {
        Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Manual Resolver"),
        Key = API.MENU.Hotkey(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Resolver Key: Left/Right/OFF"),
        FlagBox = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "Resolver Flags"),
        FlagColor = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "\n Resolver Flags")
    },
    API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[4], "-------------------------[Eternity]-------------------------"),

    API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "-------------------------[Eternity]-------------------------"),
    HandleB = API.MENU.Multiselect(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "Visible Menu Items", COMBOLISTS.VisibleB),
    Empty7 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n"),
    Indicators = {
        MainSelect = API.MENU.Multiselect(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "Indicator", VARS.inds),
        CustomBox = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "Custom Indicator"),
        MinDMG = {
            Active = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Minimum Damage Color"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Minimum Damage Color", 255, 255, 255, 255)
            },
            Phase3 = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Phase 3 Indicator"),
            Phase3Radius = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Phase 3 Indicator Radius", 0, 20, 0, true, "px"),
            NameBox = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Minimum Damage Name"),
            NameField = API.MENU.Textbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Minimum Damage Name")
        },
        Empty17 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n"),
        BodyAim = {
            Active = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Body Aim Color"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Body Aim Color", 152, 204, 0, 255)
            },
            Inactive = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Body Aim Color when Inactive"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Body Aim Color Inactive", 255, 0, 0, 255)
            },
            NameBox = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Body Aim Name"),
            NameField = API.MENU.Textbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Body Aim Name")
        },
        Empty10 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n"),
        SafePoint = {
            Active = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Safe Point Color"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Safe Point Color", 152, 204, 0, 255)
            },
            Inactive = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Safe Point Color when Inactive"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Safe Point Color Inactive", 255, 0, 0, 255)
            },
            NameBox = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Safe Point Name"),
            NameField = API.MENU.Textbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Safe Point Name")
        },
        Empty18 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n"),
        HideShots = {
            Active = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Hide Shots Color"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Hide Shots Color", 152, 204, 0, 255)
            },
            Inactive = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Hide Shots Color when Inactive"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Hide Shots Color Inactive", 255, 0, 0, 255)
            },
            NameBox = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Hide Shots Name"),
            NameField = API.MENU.Textbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Hide Shots Name")
        },
        Empty11 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n"),
        Trigger = {
            Active = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Triggermagnet Color"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Triggermagnet Color", 152, 204, 0, 255)
            },
            Inactive = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Triggermagnet Color when Inactive"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Triggermagnet Color Inactive", 255, 0, 0, 255)
            },
            NameBox = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Triggermagnet Name"),
            NameField = API.MENU.Textbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Triggermagnet Name")
        },
        Empty12 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n"),
        AWall = {
            Active = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Autowall Color"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Autowall Color", 152, 204, 0, 255)
            },
            LegitAwall = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Legit Autowall Color"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Legit Autowall Color", 255, 255, 0, 255)
            },
            Inactive = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Autowall Color when Inactive"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Autowall Color Inactive", 255, 0, 0, 255)
            },            
            Crosshair = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Autowall under Crosshair"),
            NameBox = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Autowall Name"),
            NameField = API.MENU.Textbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Autowall Name")
        },
        Empty13 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n"),
        Resolver = {
            Active = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Manual Resolver Color"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Manual Resolver Color", 152, 204, 0, 255)
            },
            NameBox = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Manual Resolver Name"),
            NameField = API.MENU.Textbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Manual Resolver Name")
        },
        Empty14 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n"),
        FOV = {
            Active = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > FOV Color"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n FOV Color", 255, 255, 255, 80)
            },
            NameBox = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > FOV Name"),
            NameField = API.MENU.Textbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n FOV Name")
        },
        Empty15 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n"),
        AADirection = {
            Active = {
                Box = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Anti-aim Direction Color"),
                Color = API.MENU.Colorpicker(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Anti-aim Direction color", 255, 255, 255, 255)
            },
            Combobox = API.MENU.Combobox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "   > Show real/fake", COMBOLISTS.AAIndModes)
        },
        Empty16 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n"),
        SaveButton = API.MENU.Button(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "Save Indicator Names", function() end),
        Empty8 = API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n"),
        IndicatorsStyle = {
            Combo = API.MENU.Combobox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "Indicator Styles", COMBOLISTS.IndStyles),
            MoveBox = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "Move Indicator"),
            MoveSlider = API.MENU.Slider(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "\n Move Indicator", 0, 25, 0, true, "", 1, VARS.move_inds)
        }
    },
    Flags = API.MENU.Multiselect(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "Flags", COMBOLISTS.Flags),
    ChatStuff = API.MENU.Multiselect(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "Chat Utilities", COMBOLISTS.Utilities),
    Disconnect = API.MENU.Checkbox(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "Auto Disconnect"),
    Prints = {
        Console = API.MENU.Multiselect(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "Log in Console", COMBOLISTS.Logs),
        Chat = API.MENU.Multiselect(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "Print into Chat", COMBOLISTS.Logs)
    },
    API.MENU.Label(LAYOUT.TAB[3], LAYOUT.CONTAINER[5], "-------------------------[Eternity]-------------------------")
}
-- #region UI_ADDITIONS end

-- ego stuff
local strClantag = "Eternity"
local active = {}
local strPlaceholder = ""
local strPrevious = ""
label = ui.new_label("MISC", "Miscellaneous", "-------------------------[Eternity]-------------------------")
local refEnable = ui.new_checkbox("MISC", "Miscellaneous", "Clan tag spammer")
local function update()
local fltTime = globals.curtime() + client.real_latency()
local intStep = math.floor((fltTime) / 0.25)
local intLength = math.abs(intStep % (#strClantag * 4) - #strClantag * 2)
local intSeed = intStep - (intStep % (#strClantag))
-- renderer.indicator(255, 255, 0, 255, intLength .. " | " .. intSeed)
local strCurrent = strClantag
if intLength > #strClantag * 1.5 then
    if intLength % 2 < 1 then
        strCurrent = "infinity"
    else
        strCurrent = "undying"
    end
elseif intLength < #strClantag then
    math.randomseed(intSeed)
    local tblCurrent = {}
    for i = 1, #strClantag, 1 do
        tblCurrent[i] = strPlaceholder
    end
    local tblLeft = {}
    for i = 1, #strClantag, 1 do
        tblLeft[i] = {strClantag:sub(i, i), i}
    end
    for i = 1, intLength, 1 do
        local strChar, intIndex = unpack(table.remove(tblLeft, math.random(#tblLeft)))
        tblCurrent[intIndex] = strChar
    end
    strCurrent = table.concat(tblCurrent)
end
-- renderer.indicator(255, 255, 0, 255, strCurrent)
if strCurrent ~= strPrevious then
    client.set_clan_tag(strCurrent)
    strPrevious = strCurrent
end
end
local function shutdown()
client.set_clan_tag("")
end
ui.set_callback(refEnable, function()
if ui.get(refEnable) then
    client.set_event_callback("paint", update)
    client.set_event_callback("shutdown", shutdown)
else
    shutdown()
    client.unset_event_callback("paint", update)
    client.unset_event_callback("shutdown", shutdown)
end
end)

namecombo = ui.new_combobox("MISC", "Miscellaneous", "Eternity Name Spammer", "All", "Get Good")
function spammer(name)
client.set_cvar("name", name)
end
namesteal = ui.reference("misc", "miscellaneous", "Steal player name")
ui.new_button("MISC", "Miscellaneous", "spam", function()
oldName = client.get_cvar("name")
if ui.get(namecombo) == "All" then
    ui.set(namesteal, true)
    client.delay_call(0.2, spammer "Eternity > All ")
    client.delay_call(0.4, spammer, "Eternity > All  ")
    client.delay_call(0.6, spammer, "Eternity > All   ")
    client.delay_call(0.8, spammer, "Eternity > All    ")
    client.delay_call(1.0, spammer, oldName)
    
elseif ui.get(namecombo) == "Get Good" then
    ui.set(namesteal, true)
    client.delay_call(0.2, spammer "Get. ")
    client.delay_call(0.4, spammer, "Get Good.  ")
    client.delay_call(0.6, spammer, "Get Good Get.   ")
    client.delay_call(0.8, spammer, "Get Good Get Eternity.    ")
    client.delay_call(1.0, spammer, oldName)
end
end)
ui.new_label("MISC", "Miscellaneous", "-------------------------[Eternity]-------------------------")
--end of egostuff
-- #region VISIBILITY start
local function visibility()

    local A = API.MENU.Get(NEW_UI.AA.LegitAAMaster.Box)

    API.MENU.Visible(REFS.AntiAim.Master, not A)
    API.MENU.Visible(REFS.AntiAim.Pitch, not A)
    API.MENU.Visible(REFS.AntiAim.YawBase, not A)
    API.MENU.Visible(REFS.AntiAim.Yaw[1], not A)
    API.MENU.Visible(REFS.AntiAim.Yaw[2], not A)
    API.MENU.Visible(REFS.AntiAim.YawJitter, not A)
    API.MENU.Visible(REFS.AntiAim.Body[1], not A)
    API.MENU.Visible(REFS.AntiAim.Body[2], not A)
    API.MENU.Visible(REFS.AntiAim.Freestand, not A)
    API.MENU.Visible(REFS.AntiAim.EdgeYaw, not A)
    API.MENU.Visible(REFS.AntiAim.FreestandHide[1], not A)
    API.MENU.Visible(REFS.AntiAim.FreestandHide[2], not A)
    --API.MENU.Visible(REFS.AntiAim.YawLimit, not A)
    API.MENU.Visible(REFS.AntiAim.Roll, not A)
    --API.MENU.Visible(REFS.FakeLag.SlowwalkType, not A)
    API.MENU.Visible(REFS.FakeLag.FakePeek, not A)

    local B = API.MENU.Get(NEW_UI.AA.LegitAAMaster.Modes)

    API.MENU.Visible(NEW_UI.AA.LegitAAMaster.Modes, A)
    API.MENU.Visible(NEW_UI.AA.LegitAAMaster.ManualSwitch, A and B == "Manual")
    API.MENU.Visible(NEW_UI.AA.Modes, A)

    local C = API.MENU.Get(NEW_UI.AA.TeamAA.Box)
    local D = API.MENU.Get(NEW_UI.AA.TeamAA.Teams)

    API.MENU.Visible(NEW_UI.AA.TeamAA.Box, A)
    API.MENU.Visible(NEW_UI.AA.TeamAA.Teams, A and C)
    API.MENU.Visible(NEW_UI.AA.TeamAA.Breaker.StandingT, A and C and D == "Terrorist")
    API.MENU.Visible(NEW_UI.AA.TeamAA.Breaker.StandingCT, A and C and D == "Counter-Terrorist")
    API.MENU.Visible(NEW_UI.AA.TeamAA.Breaker.SlowwalkingT, A and C and D == "Terrorist")
    API.MENU.Visible(NEW_UI.AA.TeamAA.Breaker.SlowwalkingCT, A and C and D == "Counter-Terrorist")
    API.MENU.Visible(NEW_UI.AA.TeamAA.Breaker.CrouchingT, A and C and D == "Terrorist")
    API.MENU.Visible(NEW_UI.AA.TeamAA.Breaker.CrouchingCT, A and C and D == "Counter-Terrorist")
    API.MENU.Visible(NEW_UI.AA.TeamAA.Breaker.MovingT, A and C and D == "Terrorist")
    API.MENU.Visible(NEW_UI.AA.TeamAA.Breaker.MovingCT, A and C and D == "Counter-Terrorist")

    local E = API.MENU.Get(NEW_UI.AA.IndicatorAA.Types)

    API.MENU.Visible(NEW_UI.AA.IndicatorAA.Types, A)
    API.MENU.Visible(NEW_UI.AA.IndicatorAA.Modes, A and E ~= "OFF")
    API.MENU.Visible(NEW_UI.AA.IndicatorAA.Color.Box, A and E ~= "OFF")
    API.MENU.Visible(NEW_UI.AA.IndicatorAA.Color.Picker, A and E ~= "OFF")

    local F = API.MENU.Get(NEW_UI.AA.Disabler.Box)
    local G = API.MENU.Get(NEW_UI.AA.Disabler.Options)

    API.MENU.Visible(NEW_UI.AA.Disabler.Box, A)
    API.MENU.Visible(NEW_UI.AA.Disabler.Options, A and F)
    API.MENU.Visible(NEW_UI.AA.Disabler.FPS, A and F and FUNCS.HELP.table_contains(G, "Low FPS"))
    API.MENU.Visible(NEW_UI.AA.Disabler.PING, A and F and FUNCS.HELP.table_contains(G, "High Ping"))
    API.MENU.Visible(NEW_UI.AA.Disabler.LOSS, A and F and FUNCS.HELP.table_contains(G, "High Packet-Loss"))
    API.MENU.Visible(NEW_UI.AA.Disabler.CHOKE, A and F and FUNCS.HELP.table_contains(G, "High Choke"))

    local H = FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.HandleA), "Dynamic Weapons")

    API.MENU.Visible(NEW_UI.Empty3, H)

    local I = API.MENU.Get(NEW_UI.DynamicWeapon.Master)
    local J = API.MENU.Get(NEW_UI.DynamicWeapon.Weapons)
    local K = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.Master)

    API.MENU.Visible(NEW_UI.DynamicWeapon.Master, H)
    API.MENU.Visible(NEW_UI.DynamicWeapon.Weapons, H and I)
    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.Master, H and I)

    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.GlobalMin, H and I and K and J == "Global")
    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.GlobalMax, H and I and K and J == "Global")

    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.AutoMin, H and I and K and J == "Auto")
    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.AutoMax, H and I and K and J == "Auto")

    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.AWPMin, H and I and K and J == "Awp")
    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.AWPMax, H and I and K and J == "Awp")

    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.DeagleMin, H and I and K and J == "Desert Eagle")
    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.DeagleMax, H and I and K and J == "Desert Eagle")

    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.PistolMin, H and I and K and J == "Pistol")
    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.PistolMax, H and I and K and J == "Pistol")

    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.RevoMin, H and I and K and J == "Revolver")
    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.RevoMax, H and I and K and J == "Revolver")

    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.RifleMin, H and I and K and J == "Rifle")
    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.RifleMax, H and I and K and J == "Rifle")

    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.ScoutMin, H and I and K and J == "Scout")
    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.ScoutMax, H and I and K and J == "Scout")

    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.Factor, H and I and K)
    API.MENU.Visible(NEW_UI.DynamicWeapon.DynamicFOV.Empty4, H and I and K)

    local L = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Master)

    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Master, H and I)
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Auto, H and I and L and J == "Auto")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.AWP, H and I and L and J == "Awp")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Deagle, H and I and L and J == "Desert Eagle")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Global, H and I and L and J == "Global")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Pistol, H and I and L and J == "Pistol")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Revolver, H and I and L and J == "Revolver")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Rifle, H and I and L and J == "Rifle")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Scout, H and I and L and J == "Scout")

    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.OverrideKey, H and I and L)
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.Auto, H and I and L and J == "Auto")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.AWP, H and I and L and J == "Awp")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.Deagle, H and I and L and J == "Desert Eagle")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.Pistol, H and I and L and J == "Pistol")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.Revolver, H and I and L and J == "Revolver")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.Rifle, H and I and L and J == "Rifle")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.Scout, H and I and L and J == "Scout")

    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.Auto, H and I and L and J == "Auto")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.AWP, H and I and L and J == "Awp")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.Deagle, H and I and L and J == "Desert Eagle")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.Pistol, H and I and L and J == "Pistol")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.Revolver, H and I and L and J == "Revolver")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.Rifle, H and I and L and J == "Rifle")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.Scout, H and I and L and J == "Scout")

    local N = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Master)

    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Master, H and I)

    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Global, H and I and N and J == "Global")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Auto, H and I and N and J == "Auto")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.AWP, H and I and N and J == "Awp")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Deagle, H and I and N and J == "Desert Eagle")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Pistol, H and I and N and J == "Pistol")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Revolver, H and I and N and J == "Revolver")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Rifle, H and I and N and J == "Rifle")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Scout, H and I and N and J == "Scout")
    API.MENU.Visible(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Threshold, H and I and N)

    local O = FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.HandleA), "Autowall/Triggermagnet")

    API.MENU.Visible(NEW_UI.Empty6, H and I and O)

    API.MENU.Visible(NEW_UI.Autowall.Box, O)
    API.MENU.Visible(NEW_UI.Autowall.Key, O)
    API.MENU.Visible(NEW_UI.Autowall.ThroughGlass, O)

    API.MENU.Visible(NEW_UI.Trigger.Box, O)
    API.MENU.Visible(NEW_UI.Trigger.Key, O)
    API.MENU.Visible(NEW_UI.Trigger.AwallBox, O)
    API.MENU.Visible(NEW_UI.Trigger.AwallKey, O)

    local P = FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.HandleA), "Manual Resolver")
    local Q = API.MENU.Get(NEW_UI.Resolver.Box)

    API.MENU.Visible(NEW_UI.Resolver.Box, P)
    API.MENU.Visible(NEW_UI.Resolver.Key, P and Q)
    API.MENU.Visible(NEW_UI.Resolver.FlagBox, P and Q)
    API.MENU.Visible(NEW_UI.Resolver.FlagColor, P and Q)

    local R = FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.HandleB), "Indicators/Style")

    API.MENU.Visible(NEW_UI.Indicators.MainSelect, R)
    API.MENU.Visible(NEW_UI.Indicators.CustomBox, R)

    local S = API.MENU.Get(NEW_UI.Indicators.MainSelect)
    local S_ = API.MENU.Get(NEW_UI.Indicators.CustomBox)
    local T = FUNCS.HELP.table_contains(S, "Minimum Damage")
    local T_ = API.MENU.Get(NEW_UI.Indicators.MinDMG.Phase3)

    API.MENU.Visible(NEW_UI.Indicators.MinDMG.Active.Box, R and S_ and T)
    API.MENU.Visible(NEW_UI.Indicators.MinDMG.Active.Color, R and S_ and T)
    API.MENU.Visible(NEW_UI.Indicators.MinDMG.Phase3, R and S_ and T)
    API.MENU.Visible(NEW_UI.Indicators.MinDMG.Phase3Radius, R and S_ and T and T_)
    API.MENU.Visible(NEW_UI.Indicators.MinDMG.NameBox, R and S_ and T)
    API.MENU.Visible(NEW_UI.Indicators.MinDMG.NameField, R and S_ and T)
    API.MENU.Visible(NEW_UI.Indicators.Empty17, R and S_ and T)

    local U = FUNCS.HELP.table_contains(S, "Body Aim")

    API.MENU.Visible(NEW_UI.Indicators.BodyAim.Active.Box, R and S_ and U)
    API.MENU.Visible(NEW_UI.Indicators.BodyAim.Active.Color, R and S_ and U)
    API.MENU.Visible(NEW_UI.Indicators.BodyAim.Inactive.Box, R and S_ and U)
    API.MENU.Visible(NEW_UI.Indicators.BodyAim.Inactive.Color, R and S_ and U)
    API.MENU.Visible(NEW_UI.Indicators.BodyAim.NameBox, R and S_ and U)
    API.MENU.Visible(NEW_UI.Indicators.BodyAim.NameField, R and S_ and U)
    API.MENU.Visible(NEW_UI.Indicators.Empty10, R and S_ and U)

    local V = FUNCS.HELP.table_contains(S, "Safe Point")

    API.MENU.Visible(NEW_UI.Indicators.SafePoint.Active.Box, R and S_ and V)
    API.MENU.Visible(NEW_UI.Indicators.SafePoint.Active.Color, R and S_ and V)
    API.MENU.Visible(NEW_UI.Indicators.SafePoint.Inactive.Box, R and S_ and V)
    API.MENU.Visible(NEW_UI.Indicators.SafePoint.Inactive.Color, R and S_ and V)
    API.MENU.Visible(NEW_UI.Indicators.SafePoint.NameBox, R and S_ and V)
    API.MENU.Visible(NEW_UI.Indicators.SafePoint.NameField, R and S_ and V)
    API.MENU.Visible(NEW_UI.Indicators.Empty18, R and S_ and V)

    local V_ = FUNCS.HELP.table_contains(S, "Hide Shots")

    API.MENU.Visible(NEW_UI.Indicators.HideShots.Active.Box, R and S_ and V_)
    API.MENU.Visible(NEW_UI.Indicators.HideShots.Active.Color, R and S_ and V_)
    API.MENU.Visible(NEW_UI.Indicators.HideShots.Inactive.Box, R and S_ and V_)
    API.MENU.Visible(NEW_UI.Indicators.HideShots.Inactive.Color, R and S_ and V_)
    API.MENU.Visible(NEW_UI.Indicators.HideShots.NameBox, R and S_ and V_)
    API.MENU.Visible(NEW_UI.Indicators.HideShots.NameField, R and S_ and V_)
    API.MENU.Visible(NEW_UI.Indicators.Empty11, R and S_ and V_)

    local W = FUNCS.HELP.table_contains(S, "Triggermagnet")

    API.MENU.Visible(NEW_UI.Indicators.Trigger.Active.Box, R and S_ and W)
    API.MENU.Visible(NEW_UI.Indicators.Trigger.Active.Color, R and S_ and W)
    API.MENU.Visible(NEW_UI.Indicators.Trigger.Inactive.Box, R and S_ and W)
    API.MENU.Visible(NEW_UI.Indicators.Trigger.Inactive.Color, R and S_ and W)
    API.MENU.Visible(NEW_UI.Indicators.Trigger.NameBox, R and S_ and W)
    API.MENU.Visible(NEW_UI.Indicators.Trigger.NameField, R and S_ and W)
    API.MENU.Visible(NEW_UI.Indicators.Empty12, R and S_ and W)

    local X = FUNCS.HELP.table_contains(S, "Autowall")

    API.MENU.Visible(NEW_UI.Indicators.AWall.Active.Box, R and S_ and X)
    API.MENU.Visible(NEW_UI.Indicators.AWall.Active.Color, R and S_ and X)
    API.MENU.Visible(NEW_UI.Indicators.AWall.LegitAwall.Box, R and S_ and X)
    API.MENU.Visible(NEW_UI.Indicators.AWall.LegitAwall.Color, R and S_ and X)
    API.MENU.Visible(NEW_UI.Indicators.AWall.Inactive.Box, R and S_ and X)
    API.MENU.Visible(NEW_UI.Indicators.AWall.Inactive.Color, R and S_ and X)
    API.MENU.Visible(NEW_UI.Indicators.AWall.Crosshair, R and S_ and X)
    API.MENU.Visible(NEW_UI.Indicators.AWall.NameBox, R and S_ and X)
    API.MENU.Visible(NEW_UI.Indicators.AWall.NameField, R and S_ and X)
    API.MENU.Visible(NEW_UI.Indicators.Empty13, R and S_ and X)

    local Y = FUNCS.HELP.table_contains(S, "Manual Resolver")

    API.MENU.Visible(NEW_UI.Indicators.Resolver.Active.Box, R and S_ and Y)
    API.MENU.Visible(NEW_UI.Indicators.Resolver.Active.Color, R and S_ and Y)
    API.MENU.Visible(NEW_UI.Indicators.Resolver.NameBox, R and S_ and Y)
    API.MENU.Visible(NEW_UI.Indicators.Resolver.NameField, R and S_ and Y)
    API.MENU.Visible(NEW_UI.Indicators.Empty14, R and S_ and Y)

    local Z = FUNCS.HELP.table_contains(S, "FOV")

    API.MENU.Visible(NEW_UI.Indicators.FOV.Active.Box, R and S_ and Z)
    API.MENU.Visible(NEW_UI.Indicators.FOV.Active.Color, R and S_ and Z)
    API.MENU.Visible(NEW_UI.Indicators.FOV.NameBox, R and S_ and Z)
    API.MENU.Visible(NEW_UI.Indicators.FOV.NameField, R and S_ and Z)
    API.MENU.Visible(NEW_UI.Indicators.Empty15, R and S_ and Z)

    local AA = FUNCS.HELP.table_contains(S, "Anti-aim Direction")

    API.MENU.Visible(NEW_UI.Indicators.AADirection.Active.Box, R and S_ and AA)
    API.MENU.Visible(NEW_UI.Indicators.AADirection.Active.Color, R and S_ and AA)
    API.MENU.Visible(NEW_UI.Indicators.AADirection.Combobox, R and S_ and AA)
    API.MENU.Visible(NEW_UI.Indicators.Empty16, R and S_ and AA)

    API.MENU.Visible(NEW_UI.Indicators.SaveButton, R and S_)
    API.MENU.Visible(NEW_UI.Indicators.Empty8, R and S_)

    local AB = API.MENU.Get(NEW_UI.Indicators.IndicatorsStyle.MoveBox)
    local AB_ = API.MENU.Get(NEW_UI.Indicators.IndicatorsStyle.Combo)

    API.MENU.Visible(NEW_UI.Indicators.IndicatorsStyle.Combo, R)
    API.MENU.Visible(NEW_UI.Indicators.IndicatorsStyle.MoveBox, R and AB_ ~= "Crosshair")
    API.MENU.Visible(NEW_UI.Indicators.IndicatorsStyle.MoveSlider, R and AB)

    local AC = FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.HandleB), "Flags")

    API.MENU.Visible(NEW_UI.Flags, AC)

    local AD = FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.HandleB), "Utilities")

    API.MENU.Visible(NEW_UI.ChatStuff, AD)
    API.MENU.Visible(NEW_UI.Disconnect, AD)

    local AE = FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.HandleB), "Logs")

    API.MENU.Visible(NEW_UI.Prints.Console, AE)
    API.MENU.Visible(NEW_UI.Prints.Chat, AE)
end
-- #region VISIBILITY end

-- #region UI_FUNCS start
API.MENU.Callback(NEW_UI.Indicators.SaveButton, function()
    local A = API.MENU.Get(NEW_UI.Indicators.MinDMG.NameField)
    local B = API.MENU.Get(NEW_UI.Indicators.SafePoint.NameField)
    local C = API.MENU.Get(NEW_UI.Indicators.BodyAim.NameField)
    local D = API.MENU.Get(NEW_UI.Indicators.HideShots.NameField)
    local E = API.MENU.Get(NEW_UI.Indicators.Trigger.NameField)
    local F = API.MENU.Get(NEW_UI.Indicators.AWall.NameField)
    local G = API.MENU.Get(NEW_UI.Indicators.Resolver.NameField)
    local H = API.MENU.Get(NEW_UI.Indicators.FOV.NameField)
    API.DATA.Write("mindmg_base", A)
    API.DATA.Write("safe_point", B)
    API.DATA.Write("baim_base", C)
    API.DATA.Write("hide_shots", D)
    API.DATA.Write("trigger_base", E)
    API.DATA.Write("awall_base", F)
    API.DATA.Write("reso_base", G)
    API.DATA.Write("FOV_base", H)
end)
-- #region UI_FUNCS end

-- #region LUA_FUNCS start
local function stop_micromove(cmd)
    if (math.abs(cmd.forwardmove) > 1) or (math.abs(cmd.sidemove) > 1) or cmd.in_jump == 1 then
        return
    end
    if (API.ENT.Prop(API.ENT.LocalPlayer(), "m_MoveType") or 0) == 9 then
        return
    end
    cmd.forwardmove = 0.000000000000000000000000000000001
    cmd.in_forward = 1
end

local function anti_aim_main(cmd)
    local LocalPlayer = API.ENT.LocalPlayer()
    local Alive = API.ENT.IsAlive(LocalPlayer)
    if not LocalPlayer or not Alive then
        return
    end
    local A = API.MENU.Get(NEW_UI.AA.LegitAAMaster.Modes)
    API.MENU.Set(REFS.AntiAim.Master, true)
    API.MENU.Set(REFS.AntiAim.Pitch, "Off")
    API.MENU.Set(REFS.AntiAim.YawBase, "Local view")
    API.MENU.Set(REFS.AntiAim.Yaw[1], "180")
    API.MENU.Set(REFS.AntiAim.Yaw[2], 180)
    API.MENU.Set(REFS.AntiAim.YawJitter, "Off")
    API.MENU.Set(REFS.AntiAim.Body[1], A == "Dynamic" and "Opposite" or A == "Manual" and "Static")
    API.MENU.Set(REFS.AntiAim.Body[2], (A == "Manual" and (API.MENU.Get(NEW_UI.AA.LegitAAMaster.ManualSwitch) and -180 or 180)) or 0)
    API.MENU.Set(REFS.AntiAim.Freestand, A == "Dynamic")
    API.MENU.Set(REFS.AntiAim.EdgeYaw, false)
    --API.MENU.Set(REFS.AntiAim.FreestandHide[1], "")
    local B = API.MENU.Get(NEW_UI.AA.Modes)
    if B == "Eye Yaw" then
        return
    end
    local desync_amount = LIBS.AntiAim.get_desync(2)
    if desync_amount == nil then
        return
    end
    if B == "OFF" then
        API.MENU.Set(REFS.AntiAim.Master, false)
    elseif B == "Opposite" then
        --API.MENU.Set(REFS.AntiAim.YawLimit, 60)
        if math.abs(desync_amount) < 15 or cmd.chokedcommands == 0 then
            return
        end
        --stop_micromove(cmd)
    elseif B == "Quirky" then
        if API.GLOBALS.Realtime() - 0.001 > 0 then
            --API.MENU.Set(REFS.AntiAim.YawLimit, VARS.YawValue)
            if VARS.ReachedLowest == false then
                VARS.YawValue = VARS.YawValue - 1
                if VARS.YawValue == 25 then
                    VARS.ReachedLowest = true
                end
            elseif VARS.ReachedLowest == true then
                VARS.YawValue = VARS.YawValue + 1
                if VARS.YawValue == 60 then
                    VARS.ReachedLowest = false
                end
            end
        end
    end
end

local function team_anti_aim()
    local LocalPlayer = API.ENT.LocalPlayer()
    if not LocalPlayer then
        return
    end
    local Team = API.ENT.Prop(LocalPlayer, "m_iTeamNum")
    if not API.MENU.IsOpen() then
        API.MENU.Set(NEW_UI.AA.TeamAA.Teams, Team == 2 and "Terrorist" or "Counter-Terrorist")
    end
    local speedX, speedY = API.ENT.Prop(LocalPlayer, "m_vecVelocity")
    local Speed = math.sqrt(speedX^2 + speedY^2)
    local DuckAmount = API.ENT.Prop(LocalPlayer, "m_flDuckAmount")
    if Team == 2 then
        if Speed < 3 and DuckAmount == 0 then
            API.MENU.Set(NEW_UI.AA.Modes, API.MENU.Get(NEW_UI.AA.TeamAA.Breaker.StandingT))
        elseif Speed > 3 and DuckAmount == 0  and API.MENU.Get(REFS.FakeLag.Slowwalk[2]) then
            API.MENU.Set(NEW_UI.AA.Modes, API.MENU.Get(NEW_UI.AA.TeamAA.Breaker.SlowwalkingT))
        elseif Speed > 3 and DuckAmount == 0 then
            API.MENU.Set(NEW_UI.AA.Modes, API.MENU.Get(NEW_UI.AA.TeamAA.Breaker.MovingT))
        elseif DuckAmount ~= 0 then
            API.MENU.Set(NEW_UI.AA.Modes, API.MENU.Get(NEW_UI.AA.TeamAA.Breaker.CrouchingT))
        end
    elseif Team == 3 then
        if Speed < 3 and DuckAmount == 0 then
            API.MENU.Set(NEW_UI.AA.Modes, API.MENU.Get(NEW_UI.AA.TeamAA.Breaker.StandingCT))
        elseif Speed > 3 and DuckAmount == 0  and API.MENU.Get(REFS.FakeLag.Slowwalk[2]) then
            API.MENU.Set(NEW_UI.AA.Modes, API.MENU.Get(NEW_UI.AA.TeamAA.Breaker.SlowwalkingCT))
        elseif Speed > 3 and DuckAmount == 0 then
            API.MENU.Set(NEW_UI.AA.Modes, API.MENU.Get(NEW_UI.AA.TeamAA.Breaker.MovingCT))
        elseif DuckAmount ~= 0 then
            API.MENU.Set(NEW_UI.AA.Modes, API.MENU.Get(NEW_UI.AA.TeamAA.Breaker.CrouchingCT))
        end
    end
end

local function anti_aim_inds()
    local LocalPlayer = API.ENT.LocalPlayer()
    local Alive = API.ENT.IsAlive(LocalPlayer)
    local Freeze = API.ENT.Prop(API.ENT.GameRules(), "m_bFreezePeriod") == 1
    if not LocalPlayer or not Alive or Freeze then
        return
    end
    local ScreenX, ScreenY = API.CLIENT.Screen()
    local centerX, centerY = ScreenX / 2, ScreenY / 2.015
    local selected = API.MENU.Get(NEW_UI.AA.IndicatorAA.Types)
    local Ind1, Ind2
    if selected == "Normal" then
        Ind1 = "⮞"
        Ind2 = "⮜"
    elseif selected == "Triangle" then
        Ind1 = "▶"
        Ind2 = "◀"
    elseif selected == "Dashes" then
        Ind1 = "‒"
        Ind2 = "‒"
    elseif selected == "Fingers" then
        Ind1 = "☛"
        Ind2 = "☚"
    end
    local color = { }
    if API.MENU.Get(NEW_UI.AA.IndicatorAA.Color.Box) then
        local r, g, b = API.MENU.Get(NEW_UI.AA.IndicatorAA.Color.Picker)
        color = { r, g, b }
    else
        color = { 255-(VARS.Angle*2.29824561404), VARS.Angle*3.42105263158, VARS.Angle*0.22807017543 }
    end
    if API.MENU.Get(NEW_UI.AA.LegitAAMaster.Box) then
        local BodyYaw = API.MENU.Get(REFS.AntiAim.Body[2])
        if API.MENU.Get(NEW_UI.AA.IndicatorAA.Modes) == "Show Real" then
            if BodyYaw == 180 then
                API.RENDER.Text(centerX + 60, centerY, color[1], color[2], color[3], 255, "c+", 0, Ind1)
            elseif BodyYaw == -180 then
                API.RENDER.Text(centerX - 60, centerY, color[1], color[2], color[3], 255, "c+", 0, Ind2)
            end
        elseif API.MENU.Get(NEW_UI.AA.IndicatorAA.Modes) == "Show Fake" then
            if BodyYaw == 180 then
                API.RENDER.Text(centerX - 60, centerY, color[1], color[2], color[3], 255, "c+", 0, Ind2)
            elseif BodyYaw == -180 then
                API.RENDER.Text(centerX + 60, centerY, color[1], color[2], color[3], 255, "c+", 0, Ind1)
            end 
        elseif API.MENU.Get(NEW_UI.AA.IndicatorAA.Modes) == "Show Real/Fake" then
            if BodyYaw == 180 then
                API.RENDER.Text(centerX + 60, centerY, color[1], color[2], color[3], 80, "c+", 0, Ind1)
                API.RENDER.Text(centerX - 60, centerY, color[1], color[2], color[3], 255, "c+", 0, Ind2)
            elseif BodyYaw == -180 then
                API.RENDER.Text(centerX + 60, centerY, color[1], color[2], color[3], 255, "c+", 0, Ind1)
                API.RENDER.Text(centerX - 60, centerY, color[1], color[2], color[3], 80, "c+", 0, Ind2)
            end 
        end
    end
end

local function anti_aim_disabler()
    local LocalPlayer = API.ENT.LocalPlayer()
    local Alive = API.ENT.IsAlive(LocalPlayer)
    if not LocalPlayer or not Alive then
        return
    end
    local A = API.MENU.Get(NEW_UI.AA.Disabler.Options)
    local FPS = FUNCS.HELP.table_contains(A, "Low FPS")
    local Ping = FUNCS.HELP.table_contains(A, "High Ping")
    local Loss = FUNCS.HELP.table_contains(A, "High Packet-Loss")
    local Choke = FUNCS.HELP.table_contains(A, "High Choke")
    local FakeDuck = FUNCS.HELP.table_contains(A, "Fake Duck")
    if VARS.FPSStop or VARS.PingStop or VARS.LossStop or VARS.ChokeStop or VARS.FakeDuckStop then
        API.MENU.Set(REFS.AntiAim.Master, false)
    end
    local netchaninfo = LIBS.ffi.cast("void***", get_net_channel_info(ivengineclient))
    local get_avg_loss = LIBS.ffi.cast("get_avg_loss_t", netchaninfo[0][11])
    local get_avg_choke = LIBS.ffi.cast("get_avg_choke_t", netchaninfo[0][12])
    local Tickrate = 1 / API.GLOBALS.Ticks()
    local ping = math.floor(API.CLIENT.Latency()*1000)
    local loss = get_avg_loss(netchaninfo, FLOW_INCOMING)
    local choke = get_avg_choke(netchaninfo, FLOW_INCOMING)
    local FPSslider = API.MENU.Get(NEW_UI.AA.Disabler.FPS)
    local PINGslider = API.MENU.Get(NEW_UI.AA.Disabler.PING)
    local LOSSslider = API.MENU.Get(NEW_UI.AA.Disabler.LOSS)
    local CHOKEslider = API.MENU.Get(NEW_UI.AA.Disabler.CHOKE)
    if FPS then
        if FUNCS.HELP.AccumulateFps() < FPSslider then
            if API.MENU.Get(REFS.AntiAim.Master) then
                API.CLIENT.Log(255, 0, 0, "Disabled Anti-aim due to low FPS")
                local message = string.format("{white}[{red}Eternity{white}] {darkred}Disabled Anti-aim due to low FPS{darkred}")
                LIBS.Chat.print(message)
            end
            VARS.FPSStop = true
        else
            VARS.FPSStop = false
        end
    else
        VARS.FPSStop = false
    end
    if Ping then
        if ping > PINGslider then
            if API.MENU.Get(REFS.AntiAim.Master) then
                API.CLIENT.Log(255, 0, 0, "Disabled Anti-aim due to high ping")
                local message = string.format("{white}[{red}Eternity{white}] {darkred}Disabled Anti-aim due to high ping{darkred}")
                LIBS.Chat.print(message)
            end
            VARS.PingStop = true
        else
            VARS.PingStop = false
        end
    else
        VARS.PingStop = false
    end
    if Loss then 
        if loss > LOSSslider then
            if API.MENU.Get(REFS.AntiAim.Master) then
                API.CLIENT.Log(255, 0, 0, "Disabled Anti-aim due to high packet loss")
                local message = string.format("{white}[{red}Eternity{white}] {darkred}Disabled Anti-aim due to high packet loss{darkred}")
                LIBS.Chat.print(message)
            end
            VARS.LossStop = true
        else
            VARS.LossStop = false
        end
    else
        VARS.LossStop = false
    end
    if Choke then 
        if choke > CHOKEslider then
            if API.MENU.Get(REFS.AntiAim.Master) then
                API.CLIENT.Log(255, 0, 0, "Disabled Anti-aim due to high choke")
                local message = string.format("{white}[{red}Eternity{white}] {darkred}Disabled Anti-aim due to high choke{darkred}")
                LIBS.Chat.print(message)
            end
            VARS.ChokeStop = true
        else
            VARS.ChokeStop = false
        end
    else
        VARS.ChokeStop = false
    end
    if FakeDuck then
        if API.MENU.Get(REFS.RAGE.FakeDuck) then
            VARS.FakeDuckStop = true
        else
            VARS.FakeDuckStop = false
        end
    else
        VARS.FakeDuckStop = false
    end
end

local function DoUpdates()
    local weapon_id_lookup_table = FUNCS.HELP.create_lookup_table(VARS.weapons)
    local local_player = API.ENT.LocalPlayer()
    local weapon_entindex = API.ENT.PlayerWeapon(local_player)
    local item_definition_index = API.BIT.Band(65535, API.ENT.Prop(weapon_entindex, "m_iItemDefinitionIndex"))
    local config_name = weapon_id_lookup_table[item_definition_index] or "Global"
    if config_name ~= VARS.active_config then
        VARS.active_config = config_name
        API.MENU.Set(NEW_UI.DynamicWeapon.Weapons, VARS.active_config)
    end
end

local function dynamic_fov()
    local LocalPlayer = API.ENT.LocalPlayer()
    local Alive = API.ENT.IsAlive(LocalPlayer)
    if not LocalPlayer or not Alive then
        return
    end
    local A = API.MENU.Get(NEW_UI.DynamicWeapon.Weapons)
    if A == "Global" then
        MinFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.GlobalMin)
        MaxFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.GlobalMax)
    elseif A == "Desert Eagle" then
        MinFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.DeagleMin)
        MaxFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.DeagleMax)
    elseif A == "Pistol" then
        MinFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.PistolMin)
        MaxFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.PistolMax)
    elseif A == "Revolver" then
        MinFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.RevoMin)
        MaxFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.RevoMax)
    elseif A == "Rifle" then
        MinFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.RifleMin)
        MaxFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.RifleMax)
    elseif A == "Auto" then
        MinFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.AutoMin)
        MaxFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.AutoMax)
    elseif A == "Awp" then
        MinFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.AWPMin)
        MaxFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.AWPMax)
    elseif A == "Scout" then
        MinFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.ScoutMin)
        MaxFOV = API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.ScoutMax)
    end
    local OldFOV = API.MENU.Get(REFS.RAGE.MaxFOV)
    local NewFOV = OldFOV
    local InFov = false
    local Enemies = API.ENT.GetPlayers(true)
    if MinFOV > MaxFOV then
        local StoreFOV = MinFOV
        MinFOV = MaxFOV
        MaxFOV = StoreFOV
    end
    if #Enemies ~= 0 then
        local own_x, own_y, own_z = API.CLIENT.EyePos()
        local own_pitch, own_yaw = API.CLIENT.CamAngles()
        local ClosestEnemy = nil
        local ClosestDistance = 999999999
        for i = 1, #Enemies do
            local Enemy = Enemies[i]
            local enemy_x, enemy_y, enemy_z = API.ENT.HitboxPos(Enemy, 0)
            local x = enemy_x - own_x
            local y = enemy_y - own_y
            local z = enemy_z - own_z
            local yaw = ((math.atan2(y, x) * 180 / math.pi))
            local pitch = -(math.atan2(z, math.sqrt(math.pow(x, 2) + math.pow(y, 2))) * 180 / math.pi)
            local yaw_dif = math.abs(own_yaw % 360 - yaw % 360) % 360
            local pitch_dif = math.abs(own_pitch - pitch) % 360
            if yaw_dif > 180 then
                yaw_dif = 360 - yaw_dif
            end
            local real_dif = math.sqrt(math.pow(yaw_dif, 2) + math.pow(pitch_dif, 2))
            if ClosestDistance > real_dif then
                ClosestDistance = real_dif
                ClosestEnemy = Enemy
            end
        end
        if ClosestEnemy ~= nil then
            local closest_enemy_x, closest_enemy_y, closest_enemy_z = API.ENT.HitboxPos(ClosestEnemy, 0)
            local real_distance = math.sqrt(math.pow(own_x - closest_enemy_x, 2) + math.pow(own_y - closest_enemy_y, 2) + math.pow(own_z - closest_enemy_z, 2))
            NewFOV = (3800 / real_distance) * (API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.Factor) * 0.01)
            if NewFOV > MaxFOV then
                NewFOV = MaxFOV
            elseif NewFOV < MinFOV then
                NewFOV = MinFOV
            end
        end
        NewFOV = math.floor(NewFOV + 0.5)
        if NewFOV > ClosestDistance then
            InFov = true
        else
            InFov = false
        end
    else
        NewFOV = MinFOV
        InFov = false
    end
    if NewFOV ~= OldFOV then
        API.MENU.Set(REFS.RAGE.MaxFOV, NewFOV)
    end
end

local function keyrotation()
    local PhaseCheck = VARS.Damage2ndOVR ~= -1 and 3 or 2
    if VARS.DamageOVR ~= -1 or VARS.Damage2ndOVR ~= -1 then
        if API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.OverrideKey) then
            if not VARS.OVRState then
                VARS.KeyPhase = VARS.KeyPhase < PhaseCheck and VARS.KeyPhase + 1 or 1
            end
            VARS.OVRState = true
        else
            VARS.OVRState = false
        end
    elseif VARS.DamageOVR == -1 and VARS.Damage2ndOVR == -1 then
        VARS.KeyPhase = 1
    end
end

local function dynamic_settings()
    local LocalPlayer = API.ENT.LocalPlayer()
    local Alive = API.ENT.IsAlive(LocalPlayer)
    if not LocalPlayer or not Alive then
        return
    end
    keyrotation()
    local A = API.MENU.Get(NEW_UI.DynamicWeapon.Weapons)
    if A == "Auto" then
        VARS.DamageNorm = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Auto)
        VARS.DamageOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.Auto)
        VARS.Damage2ndOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.Auto)
    elseif A == "Awp" then
        VARS.DamageNorm = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.AWP)
        VARS.DamageOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.AWP)
        VARS.Damage2ndOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.AWP)
    elseif A == "Desert Eagle" then
        VARS.DamageNorm = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Deagle)
        VARS.DamageOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.Deagle)
        VARS.Damage2ndOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.Deagle)
    elseif A == "Global" then
        VARS.DamageNorm = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Global)
        VARS.DamageOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Global)
        VARS.Damage2ndOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Global)
    elseif A == "Pistol" then
        VARS.DamageNorm = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Pistol)
        VARS.DamageOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.Pistol)
        VARS.Damage2ndOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.Pistol)
    elseif A == "Revolver" then
        VARS.DamageNorm = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Revolver)
        VARS.DamageOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.Revolver)
        VARS.Damage2ndOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.Revolver)
    elseif A == "Rifle" then
        VARS.DamageNorm = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Rifle)
        VARS.DamageOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.Rifle)
        VARS.Damage2ndOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.Rifle)
    elseif A == "Scout" then
        VARS.DamageNorm = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Normal.Damage.Scout)
        VARS.DamageOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Override.Damage.Scout)
        VARS.Damage2ndOVR = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Phase3.Damage.Scout)
    end
    API.MENU.Set(NEW_UI.DynamicWeapon.AdaptiveWeapon.OverrideKey, "On hotkey")
    if VARS.KeyPhase == 1 then
        VARS.MinDMG = VARS.DamageNorm
    elseif VARS.KeyPhase == 2 and VARS.DamageOVR ~= -1 then
        VARS.MinDMG = VARS.DamageOVR
    elseif VARS.KeyPhase == 3 and VARS.Damage2ndOVR ~= -1 then
        VARS.MinDMG = VARS.Damage2ndOVR
    end
    API.MENU.Set(REFS.RAGE.MinDamage, VARS.MinDMG)
end

local function is_player_visible(local_player, lx, ly, lz, ent)
    local visible_hitboxes = 0
    local visible_hitbox_threshold = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Threshold) or 1
    for i = 0, 18 do
        local ex, ey, ez = API.ENT.HitboxPos(ent, i)
        local _, entindex = API.CLIENT.Trace(local_player, lx, ly, lz, ex, ey, ez)
        if entindex == ent then
            visible_hitboxes = visible_hitboxes + 1
        end
    end
    return visible_hitboxes >= visible_hitbox_threshold
end

local function dynamic_awall()
    local LocalPlayer = API.ENT.LocalPlayer()
    local Alive = API.ENT.IsAlive(LocalPlayer)
    if not LocalPlayer or not Alive then
        return
    end
    local A = API.MENU.Get(NEW_UI.DynamicWeapon.Weapons)
    local MaxFOV = API.MENU.Get(REFS.RAGE.MaxFOV)
    local pitch, yaw = API.CLIENT.CamAngles()
    local lx, ly, lz = API.ENT.Prop(LocalPlayer, "m_vecOrigin")
    local nearest_player, nearest_player_fov = FUNCS.HELP.get_closest_player_to_crosshair(lx, ly, lz, pitch, yaw)
    local view_offset = API.ENT.Prop(LocalPlayer, "m_vecViewOffset[2]")
    local lz = lz + view_offset
    local B = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Global) and A == "Global"
    local C = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Auto) and A == "Auto"
    local D = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.AWP) and A == "Awp"
    local E = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Deagle) and A == "Desert Eagle"
    local F = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Pistol) and A == "Pistol"
    local G = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Revolver) and A == "Revolver"
    local H = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Rifle) and A == "Rifle"
    local I = API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Scout) and A == "Scout"
    if B or C or D or E or F or G or H or I then
        if nearest_player ~= nil and nearest_player_fov <= MaxFOV then
            Legitawall_var = is_player_visible(LocalPlayer, lx, ly, lz, nearest_player)
        else
            Legitawall_var = false
        end
    else
        Legitawall_var = false
    end
end

local function glass_awall()
    local LocalPlayer = API.ENT.LocalPlayer()
    local Alive = API.ENT.IsAlive(LocalPlayer)
    if not LocalPlayer or not Alive then
        return
    end
    local nearest_enemy = FUNCS.HELP.getNearestEnemy()
    local eye_pos = LIBS.vector(API.CLIENT.EyePos())
    if nearest_enemy ~= nil then
        for i = 0, 18 do
            local hitbox_pos = LIBS.vector(API.ENT.HitboxPos(nearest_enemy, i))
            local _, entindex = API.CLIENT.Trace(LocalPlayer, eye_pos.x, eye_pos.y, eye_pos.z, hitbox_pos.x, hitbox_pos.y, hitbox_pos.z)
            if (entindex ~= 0 and entindex ~= -1) and API.ENT.ClassName(entindex) == "CBaseEntity" then
                Glassawall_var = true
            else
                Glassawall_var = false
            end
        end
    end
end

local function AwallHandle()
    if API.MENU.Get(NEW_UI.Autowall.Box) then
        if API.MENU.Get(NEW_UI.Autowall.Key) then
            Awall_var = true
        else
            Awall_var = false
        end
    end
    if Legitawall_var or Awall_var or Glassawall_var or Triggerawall_var then
        API.MENU.Set(REFS.RAGE.Autowall, true)
    else
        API.MENU.Set(REFS.RAGE.Autowall, false)
    end
end

local function trigger()
    API.MENU.Set(REFS.RAGE.Ragebot[1], true)
    if API.MENU.Get(NEW_UI.Trigger.Key) or Triggerawall_var then
        API.MENU.Set(REFS.RAGE.Ragebot[2], "Always on")
        API.MENU.Set(REFS.RAGE.AutoShoot, true)
    elseif not API.MENU.Get(NEW_UI.Trigger.Key) and not Triggerawall_var then
        API.MENU.Set(REFS.RAGE.Ragebot[2], "On hotkey")
        API.MENU.Set(REFS.RAGE.AutoShoot, false)
    end
end

local function triggerawall()
    API.MENU.Set(REFS.RAGE.Ragebot[1], true)
    if API.MENU.Get(NEW_UI.Trigger.AwallKey) then
        Triggerawall_var = true
    else
        Triggerawall_var = false
    end
end

local function manual_reso_byaw()
    if VARS.side == 0 and canManual == true then
        API.MENU.Set(REFS.PlayerList.ForceBodyYaw, true)
        API.MENU.Set(REFS.PlayerList.ForceSlider, 60)
        API.MENU.Set(REFS.PlayerList.ApplyToAll, true)
        canManual = false
        VARS.side = 1
    elseif VARS.side == 1 and canManual == true then
        API.MENU.Set(REFS.PlayerList.ForceBodyYaw, true)
        API.MENU.Set(REFS.PlayerList.ForceSlider, -60)
        API.MENU.Set(REFS.PlayerList.ApplyToAll, true)
        canManual = false
        VARS.side = 2
    elseif VARS.side == 2 and canManual == true then
        API.MENU.Set(REFS.PlayerList.ForceBodyYaw, false)
        API.MENU.Set(REFS.PlayerList.ForceSlider, 0)
        API.MENU.Set(REFS.PlayerList.ApplyToAll, true)
        canManual = false
        VARS.side = 0
    end
end

local function do_manual_reso()
    if API.MENU.Get(NEW_UI.Resolver.Key) then
        if canManual == true then
            manual_reso_byaw()
            canManual = false
        end
    else
        canManual = true
    end
end

local function manual_reso_roundreset()
    API.MENU.Set(REFS.PlayerList.ForceBodyYaw, false)
    API.MENU.Set(REFS.PlayerList.ForceSlider, 0)
    API.MENU.Set(REFS.PlayerList.ApplyToAll, true)
    VARS.side = 0
end

local function manual_reso_deathreset()
    API.MENU.Set(REFS.PlayerList.ForceBodyYaw, false)
    API.MENU.Set(REFS.PlayerList.ForceSlider, 0)
    API.MENU.Set(REFS.PlayerList.ApplyToAll, true)
    VARS.side = 0
end

local function manual_reso_flags()
    API.CLIENT.Update()
    if not API.MENU.IsOpen() then
        VARS.bruteforce_ents = { }
        for _, v in pairs(API.ENT.GetPlayers(true)) do
            if VARS.side == 1 or VARS.side == 2 then
                API.TABLE.Insert(VARS.bruteforce_ents, v)
                API.ENT.Prop(v, "m_flDetectedByEnemySensorTime")
            else
                API.ENT.Prop(v, "m_flDetectedByEnemySensorTime", 0)
            end
        end
    end
end

local function do_manual_reso_flags()
    local LocalPlayer = API.ENT.LocalPlayer()
    local Alive = API.ENT.IsAlive(LocalPlayer)
    if not LocalPlayer or not Alive then
        return
    end
    manual_reso_flags()
    local r, g, b, a = API.MENU.Get(NEW_UI.Resolver.FlagColor)
    for _, v in pairs(VARS.bruteforce_ents) do
        local bounding_box = { API.ENT.BoundingBox(v) }
        if #bounding_box == 5 and bounding_box[5] ~= 0 then
            local center = bounding_box[1] + (bounding_box[3] - bounding_box[1]) / 2
            if VARS.side == 1 then
                API.RENDER.Text(center, bounding_box[2] - 18, r, g, b, a * bounding_box[5], "dbc", 0, "LEFT")
            elseif VARS.side == 2 then
                API.RENDER.Text(center, bounding_box[2] - 18, r, g, b, a * bounding_box[5], "dbc", 0, "RIGHT")
            end
        end
    end
end

local function default_inds()
    local LocalPlayer = API.ENT.LocalPlayer()
    local Alive = API.ENT.IsAlive(LocalPlayer)
    if not LocalPlayer or not Alive then
        return
    end
    local A = API.MENU.Get(NEW_UI.Indicators.MainSelect)
    local Modern = API.MENU.Get(NEW_UI.Indicators.IndicatorsStyle.Combo) == "Modern"
    if API.MENU.Get(NEW_UI.Indicators.IndicatorsStyle.MoveBox) then
        for i = 1, API.MENU.Get(NEW_UI.Indicators.IndicatorsStyle.MoveSlider) do
            API.RENDER.Indicator(0, 0, 0, 0, "<3")
        end
    else
        for i = 0, 2 do
            API.RENDER.Indicator(0, 0, 0, 0, "<3")
        end
    end
    if FUNCS.HELP.table_contains(A, "Anti-aim Direction") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(REFS.AntiAim.Master) then
            if API.MENU.Get(NEW_UI.Indicators.AADirection.Active.Box) then
                r, g, b, a = API.MENU.Get(NEW_UI.Indicators.AADirection.Active.Color)
            else
                r, g, b, a = 255, 255, 255, 255
            end
            if API.MENU.Get(NEW_UI.Indicators.AADirection.Combobox) == "Show Real" then
                Indicator = (API.MENU.Get(REFS.AntiAim.Body[2]) < 0 and "LEFT") or "RIGHT"
            elseif API.MENU.Get(NEW_UI.Indicators.AADirection.Combobox) == "Show Fake" then
                Indicator = (API.MENU.Get(REFS.AntiAim.Body[2]) < 0 and "RIGHT") or "LEFT"
            end
            local y = API.RENDER.Indicator(r, g, b, a, Indicator)
            if Modern then
                local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
                API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
            end
        end
    end
    if FUNCS.HELP.table_contains(A, "FOV") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(NEW_UI.Indicators.FOV.Active.Box) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.FOV.Active.Color)
        else
            r, g, b, a = 152, 204, 0, 255
        end
        if API.MENU.Get(NEW_UI.Indicators.FOV.NameBox) and API.MENU.Get(NEW_UI.Indicators.FOV.NameField) ~= "" then
            Indicator = string.format("%s: %s", API.MENU.Get(NEW_UI.Indicators.FOV.NameField), API.MENU.Get(REFS.RAGE.MaxFOV))
        else
            Indicator = string.format("FOV: %s", API.MENU.Get(REFS.RAGE.MaxFOV))
        end
        local y = API.RENDER.Indicator(r, g, b, a, Indicator)
        if Modern then
            local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
            API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
            API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
        end
    end
    if FUNCS.HELP.table_contains(A, "Manual Resolver") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(NEW_UI.Resolver.Box) then
            if API.MENU.Get(NEW_UI.Indicators.Resolver.Active.Box) then
                r, g, b, a = API.MENU.Get(NEW_UI.Indicators.Resolver.Active.Color)
            else
                r, g, b, a = 152, 204, 0, 255
            end
            if VARS.side == 0 then
                direc = "OFF"
            elseif VARS.side == 1 then
                direc = "LEFT"
            elseif VARS.side == 2 then
                direc = "RIGHT"
            end
            if API.MENU.Get(NEW_UI.Indicators.Resolver.NameBox) and API.MENU.Get(NEW_UI.Indicators.Resolver.NameField) ~= "" then
                Indicator = string.format("%s:%s", API.MENU.Get(NEW_UI.Indicators.Resolver.NameField), direc)
            else
                Indicator = string.format("R:%s", direc)
            end
            local y = API.RENDER.Indicator(r, g, b, a, Indicator)
            if Modern then
                local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
                API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
            end
        end
    end
    if FUNCS.HELP.table_contains(A, "Autowall") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(REFS.RAGE.Autowall) and API.MENU.Get(NEW_UI.Indicators.AWall.Active.Box) and Awall_var or (API.MENU.Get(NEW_UI.Trigger.AwallBox) and API.MENU.Get(NEW_UI.Trigger.AwallKey)) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.AWall.Active.Color)
        elseif API.MENU.Get(REFS.RAGE.Autowall) and not API.MENU.Get(NEW_UI.Indicators.AWall.Active.Box) then
            r, g, b, a = 152, 204, 0, 255
        end
        if API.MENU.Get(NEW_UI.Indicators.AWall.LegitAwall.Box) and Legitawall_var then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.AWall.LegitAwall.Color)
        end
        if API.MENU.Get(NEW_UI.Indicators.AWall.Inactive.Box) and not API.MENU.Get(REFS.RAGE.Autowall) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.AWall.Inactive.Color)
        end
        if API.MENU.Get(NEW_UI.Indicators.AWall.NameBox) and API.MENU.Get(NEW_UI.Indicators.AWall.NameField) ~= "" then
            Indicator = API.MENU.Get(NEW_UI.Indicators.AWall.NameField)
        else
            Indicator = "AW"
        end
        if Awall_var or (Legitawall_var and S_ and API.MENU.Get(NEW_UI.Indicators.AWall.LegitAwall.Box)) or API.MENU.Get(NEW_UI.Indicators.AWall.Inactive.Box) or (API.MENU.Get(NEW_UI.Trigger.AwallBox) and API.MENU.Get(NEW_UI.Trigger.AwallKey)) then
            if API.MENU.Get(NEW_UI.Indicators.AWall.Crosshair) then
                local w, h = API.CLIENT.Screen()
                local center = { w / 2, h / 2 }
                local y = (-1 >= 0) and (center[2] - -1) or (center[2] - -15)
                renderer.text(center[1], y, r, g, b, a, "-cb", 0, Indicator)
            else
                local y = API.RENDER.Indicator(r, g, b, a, Indicator)
                if Modern then
                    local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
                    API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                    API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                end
            end
        end
    end
    if FUNCS.HELP.table_contains(A, "Triggermagnet") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(NEW_UI.Indicators.Trigger.Active.Box) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.Trigger.Active.Color)
        elseif not API.MENU.Get(NEW_UI.Indicators.Trigger.Active.Box) then
            r, g, b, a = 152, 204, 0, 255
        end
        if API.MENU.Get(NEW_UI.Indicators.Trigger.NameBox) and API.MENU.Get(NEW_UI.Indicators.Trigger.NameField) ~= "" then
            Indicator = API.MENU.Get(NEW_UI.Indicators.Trigger.NameField)
        else
            Indicator = "TM"
        end
        if API.MENU.Get(NEW_UI.Trigger.Key) then
            local y = API.RENDER.Indicator(r, g, b, a, Indicator)
            if Modern then
                local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
                API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
            end
        elseif API.MENU.Get(NEW_UI.Indicators.Trigger.Inactive.Box) and not API.MENU.Get(NEW_UI.Trigger.Key) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.Trigger.Inactive.Color)
            local y = API.RENDER.Indicator(r, g, b, a, Indicator)
            if Modern then
                local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
                API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
            end
        end
    end
    if FUNCS.HELP.table_contains(A, "Hide Shots") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(NEW_UI.Indicators.HideShots.Active.Box) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.HideShots.Active.Color)
        elseif not API.MENU.Get(NEW_UI.Indicators.HideShots.Active.Box) then
            r, g, b, a = 152, 204, 0, 255
        end
        if API.MENU.Get(NEW_UI.Indicators.HideShots.NameBox) and API.MENU.Get(NEW_UI.Indicators.HideShots.NameField) ~= "" then
            Indicator = API.MENU.Get(NEW_UI.Indicators.HideShots.NameField)
        else
            Indicator = "HIDE"
        end
        if API.MENU.Get(REFS.FakeLag.OnShot[1]) then
            if API.MENU.Get(REFS.FakeLag.OnShot[2]) then
                local y = API.RENDER.Indicator(r, g, b, a, Indicator)
                if Modern then
                    local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
                    API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                    API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                end
            elseif API.MENU.Get(NEW_UI.Indicators.HideShots.Inactive.Box) and not API.MENU.Get(REFS.FakeLag.OnShot[2]) then
                local r, g, b, a = API.MENU.Get(NEW_UI.Indicators.HideShots.Inactive.Color)
                local y = API.RENDER.Indicator(r, g, b, a, Indicator)
                if Modern then
                    local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
                    API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                    API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                end
            end
        end
    end
    if FUNCS.HELP.table_contains(A, "Safe Point") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(NEW_UI.Indicators.SafePoint.Active.Box) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.SafePoint.Active.Color)
        elseif not API.MENU.Get(NEW_UI.Indicators.SafePoint.Active.Box) then
            r, g, b, a = 152, 204, 0, 255
        end
        if API.MENU.Get(NEW_UI.Indicators.SafePoint.NameBox) and API.MENU.Get(NEW_UI.Indicators.SafePoint.NameField) ~= "" then
            Indicator = API.MENU.Get(NEW_UI.Indicators.SafePoint.NameField)
        else
            Indicator = "SAFE"
        end
        if API.MENU.Get(REFS.RAGE.ForceSafePoint) then
            local y = API.RENDER.Indicator(r, g, b, a, Indicator)
            if Modern then
                local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
                API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
            end
        elseif API.MENU.Get(NEW_UI.Indicators.SafePoint.Inactive.Box) and not API.MENU.Get(REFS.RAGE.ForceSafePoint) then
            local r, g, b, a = API.MENU.Get(NEW_UI.Indicators.SafePoint.Inactive.Color)
            local y = API.RENDER.Indicator(r, g, b, a, Indicator)
            if Modern then
                local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
                API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
            end
        end
    end
    if FUNCS.HELP.table_contains(A, "Body Aim") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(NEW_UI.Indicators.BodyAim.Active.Box) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.BodyAim.Active.Color)
        elseif not API.MENU.Get(NEW_UI.Indicators.BodyAim.Active.Box) then
            r, g, b, a = 152, 204, 0, 255
        end
        if API.MENU.Get(NEW_UI.Indicators.BodyAim.NameBox) and API.MENU.Get(NEW_UI.Indicators.BodyAim.NameField) ~= "" then
            Indicator = API.MENU.Get(NEW_UI.Indicators.BodyAim.NameField)
        else
            Indicator = "BAIM"
        end
        -- if API.MENU.Get(REFS.RAGE.ForceBodyAim) then
        --     local y = API.RENDER.Indicator(r, g, b, a, Indicator)
        --     if Modern then
        --         local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
        --         API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
        --         API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
        --         end
        -- elseif API.MENU.Get(NEW_UI.Indicators.BodyAim.Inactive.Box) and not API.MENU.Get(REFS.RAGE.ForceBodyAim) then
        --     local r, g, b, a = API.MENU.Get(NEW_UI.Indicators.BodyAim.Inactive.Color)
        --     local y = API.RENDER.Indicator(r, g, b, a, Indicator)
        --     if Modern then
        --         local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
        --         API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
        --         API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
        --     end
        -- end
    end
    if FUNCS.HELP.table_contains(A, "Minimum Damage") then
        local r, g, b, a
        local Indicator
        local Suffix
        local A = VARS.KeyPhase == 1
        local B = VARS.KeyPhase == 2
        local C = VARS.KeyPhase == 3
        local Alpha0 = A and 255 or 80
        local Alpha1 = B and 255 or 80
        local Alpha2 = C and 255 or 80
        if A then
            current_damage = VARS.DamageNorm
            Suffix = ""
        elseif B then
            current_damage = VARS.DamageOVR
            Suffix = VARS.DamageOVR ~= -1 and "²" or ""
        elseif C then
            current_damage = VARS.Damage2ndOVR
            Suffix = "³"
        end
        if API.MENU.Get(NEW_UI.Indicators.MinDMG.Active.Box) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.MinDMG.Active.Color)
        else
            r, g, b, a = 255, 255, 255, 255
        end
        if API.MENU.Get(REFS.RAGE.MinDamage) == 0 then
            DMGvar = "Auto"
        else
            DMGvar = API.MENU.Get(REFS.RAGE.MinDamage)
        end
        if API.MENU.Get(NEW_UI.Indicators.MinDMG.NameBox) and API.MENU.Get(NEW_UI.Indicators.MinDMG.NameField) ~= "" then
            Indicator = string.format("%s: %s%s", API.MENU.Get(NEW_UI.Indicators.MinDMG.NameField), DMGvar, Suffix)
        else
            Indicator = string.format("%s%s", DMGvar, Suffix)
        end
        if API.MENU.Get(NEW_UI.DynamicWeapon.Weapons) ~= "Global" then
            if VARS.DamageOVR ~= -1 and VARS.Damage2ndOVR ~= -1 and API.MENU.Get(NEW_UI.Indicators.MinDMG.Phase3) then
                local screenX, screenY = API.CLIENT.Screen()
                local Percentage = VARS.IndAnim * (0.5 / 100)
                if Percentage > 0.5 then
                    Percentage = 0.5
                end
                local OutValue = API.MENU.Get(NEW_UI.Indicators.MinDMG.Phase3Radius)
                API.RENDER.CircleOutline(screenX / 2, screenY / 2 + 10, r, g, b, 80, 40 + OutValue, 180, Percentage, 10)
                API.RENDER.Text(screenX / 2 + (15 + OutValue), screenY / 2.015 + 5, r, g, b, Alpha2, "c", 0, VARS.Damage2ndOVR)
                API.RENDER.Text(screenX / 2, screenY / 2.015 - (5 + OutValue), r, g, b, Alpha1, "c", 0, VARS.DamageOVR)
                API.RENDER.Text(screenX / 2 - (15 + OutValue), screenY / 2.015 + 5, r, g, b, Alpha0, "c", 0, VARS.DamageNorm)
                if current_damage > VARS.IndAnim then
                    VARS.IndAnim = math.min(VARS.IndAnim + (126 / 0.2) * API.GLOBALS.Frametime(), current_damage)
                elseif current_damage < VARS.IndAnim then
                    VARS.IndAnim = math.max(VARS.IndAnim - (126 / 0.2) * API.GLOBALS.Frametime(), current_damage)
                end
            else
                local y = API.RENDER.Indicator(r, g, b, a, Indicator)
                if Modern then
                    local IndicatorTextW, IndicatorTextH = API.RENDER.Measure("+d", Indicator)
                    API.RENDER.Gradient(0, y + 1, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                    API.RENDER.Gradient(0, y + IndicatorTextH + 6, IndicatorTextW + 60, 1, r, g, b, a, r, g, b, 0, true)
                end
            end
        end
    end
end

local function crosshair_inds()
    local LocalPlayer = API.ENT.LocalPlayer()
    local Alive = API.ENT.IsAlive(LocalPlayer)
    if not LocalPlayer or not Alive then
        return
    end
    local A = API.MENU.Get(NEW_UI.Indicators.MainSelect)
    if FUNCS.HELP.table_contains(A, "Minimum Damage") then
        local r, g, b, a
        local Indicator
        local Suffix
        local A = VARS.KeyPhase == 1
        local B = VARS.KeyPhase == 2
        local C = VARS.KeyPhase == 3
        local Alpha0 = A and 255 or 80
        local Alpha1 = B and 255 or 80
        local Alpha2 = C and 255 or 80
        if A then
            current_damage = VARS.DamageNorm
            Suffix = ""
        elseif B and VARS.DamageOVR ~= -1 then
            current_damage = VARS.DamageOVR
            Suffix = "²"
        elseif C then
            current_damage = VARS.Damage2ndOVR
            Suffix = "³"
        end
        if API.MENU.Get(NEW_UI.Indicators.MinDMG.Active.Box) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.MinDMG.Active.Color)
        else
            r, g, b, a = 255, 255, 255, 255
        end
        if API.MENU.Get(REFS.RAGE.MinDamage) == 0 then
            DMGvar = "Auto"
        else
            DMGvar = API.MENU.Get(REFS.RAGE.MinDamage)
        end
        if API.MENU.Get(NEW_UI.Indicators.MinDMG.NameBox) and API.MENU.Get(NEW_UI.Indicators.MinDMG.NameField) ~= "" then
            Indicator = string.format("%s: %s%s", API.MENU.Get(NEW_UI.Indicators.MinDMG.NameField), DMGvar, Suffix)
        else
            Indicator = string.format("%s%s", DMGvar, Suffix)
        end
        if API.MENU.Get(NEW_UI.DynamicWeapon.Weapons) ~= "Global" then
            if VARS.DamageOVR ~= -1 and VARS.Damage2ndOVR ~= -1 and API.MENU.Get(NEW_UI.Indicators.MinDMG.Phase3) then
                local screenX, screenY = API.CLIENT.Screen()
                local Percentage = VARS.IndAnim * (0.5 / 100)
                if Percentage > 0.5 then
                    Percentage = 0.5
                end
                local OutValue = API.MENU.Get(NEW_UI.Indicators.MinDMG.Phase3Radius)
                API.RENDER.CircleOutline(screenX / 2, screenY / 2 + 10, r, g, b, 80, 40 + OutValue, 180, Percentage, 10)
                API.RENDER.Text(screenX / 2 + (15 + OutValue), screenY / 2.015 + 5, r, g, b, Alpha2, "c", 0, VARS.Damage2ndOVR)
                API.RENDER.Text(screenX / 2, screenY / 2.015 - (5 + OutValue), r, g, b, Alpha1, "c", 0, VARS.DamageOVR)
                API.RENDER.Text(screenX / 2 - (15 + OutValue), screenY / 2.015 + 5, r, g, b, Alpha0, "c", 0, VARS.DamageNorm)
                if current_damage > VARS.IndAnim then
                    VARS.IndAnim = math.min(VARS.IndAnim + (126 / 0.2) * API.GLOBALS.Frametime(), current_damage)
                elseif current_damage < VARS.IndAnim then
                    VARS.IndAnim = math.max(VARS.IndAnim - (126 / 0.2) * API.GLOBALS.Frametime(), current_damage)
                end
            else
                API.TABLE.Insert( VARS.ind_active, Indicator )
                API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
            end
        end
    end
    if FUNCS.HELP.table_contains(A, "Body Aim") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(NEW_UI.Indicators.BodyAim.Active.Box) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.BodyAim.Active.Color)
        elseif not API.MENU.Get(NEW_UI.Indicators.BodyAim.Active.Box) then
            r, g, b, a = 152, 204, 0, 255
        end
        if API.MENU.Get(NEW_UI.Indicators.BodyAim.NameBox) and API.MENU.Get(NEW_UI.Indicators.BodyAim.NameField) ~= "" then
            Indicator = API.MENU.Get(NEW_UI.Indicators.BodyAim.NameField)
        else
            Indicator = "BAIM"
        end
        -- if API.MENU.Get(REFS.RAGE.ForceBodyAim) then
        --     API.TABLE.Insert( VARS.ind_active, Indicator )
        --     API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
        -- elseif API.MENU.Get(NEW_UI.Indicators.BodyAim.Inactive.Box) and not API.MENU.Get(REFS.RAGE.ForceBodyAim) then
        --     local r, g, b, a = API.MENU.Get(NEW_UI.Indicators.BodyAim.Inactive.Color)
        --     API.TABLE.Insert( VARS.ind_active, Indicator )
        --     API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
        -- end
    end
    if FUNCS.HELP.table_contains(A, "Safe Point") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(NEW_UI.Indicators.SafePoint.Active.Box) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.SafePoint.Active.Color)
        elseif not API.MENU.Get(NEW_UI.Indicators.SafePoint.Active.Box) then
            r, g, b, a = 152, 204, 0, 255
        end
        if API.MENU.Get(NEW_UI.Indicators.SafePoint.NameBox) and API.MENU.Get(NEW_UI.Indicators.SafePoint.NameField) ~= "" then
            Indicator = API.MENU.Get(NEW_UI.Indicators.SafePoint.NameField)
        else
            Indicator = "SAFE"
        end
        if API.MENU.Get(REFS.RAGE.ForceSafePoint) then
            API.TABLE.Insert( VARS.ind_active, Indicator )
            API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
        elseif API.MENU.Get(NEW_UI.Indicators.SafePoint.Inactive.Box) and not API.MENU.Get(REFS.RAGE.ForceSafePoint) then
            local r6, g6, b6, a6 = API.MENU.Get(NEW_UI.Indicators.SafePoint.Inactive.Color)
            API.TABLE.Insert( VARS.ind_active, Indicator )
            API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
        end
    end
    if FUNCS.HELP.table_contains(A, "Hide Shots") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(NEW_UI.Indicators.HideShots.Active.Box) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.HideShots.Active.Color)
        elseif not API.MENU.Get(NEW_UI.Indicators.HideShots.Active.Box) then
            r, g, b, a = 152, 204, 0, 255
        end
        if API.MENU.Get(NEW_UI.Indicators.HideShots.NameBox) and API.MENU.Get(NEW_UI.Indicators.HideShots.NameField) ~= "" then
            Indicator = API.MENU.Get(NEW_UI.Indicators.HideShots.NameField)
        else
            Indicator = "HIDE"
        end
        if API.MENU.Get(REFS.FakeLag.OnShot[1]) then
            if API.MENU.Get(REFS.FakeLag.OnShot[2]) then
                API.TABLE.Insert( VARS.ind_active, Indicator )
                API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
            elseif API.MENU.Get(NEW_UI.Indicators.HideShots.Inactive.Box) and not API.MENU.Get(REFS.FakeLag.OnShot[2]) then
                local r, g, b, a = API.MENU.Get(NEW_UI.Indicators.HideShots.Inactive.Color)
                API.TABLE.Insert( VARS.ind_active, Indicator )
                API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
            end
        end
    end
    if FUNCS.HELP.table_contains(A, "Triggermagnet") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(NEW_UI.Indicators.Trigger.Active.Box) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.Trigger.Active.Color)
        elseif not API.MENU.Get(NEW_UI.Indicators.Trigger.Active.Box) then
            r, g, b, a = 152, 204, 0, 255
        end
        if API.MENU.Get(NEW_UI.Indicators.Trigger.NameBox) and API.MENU.Get(NEW_UI.Indicators.Trigger.NameField) ~= "" then
            Indicator = API.MENU.Get(NEW_UI.Indicators.Trigger.NameField)
        else
            Indicator = "TM"
        end
        if API.MENU.Get(NEW_UI.Trigger.Key) then
            API.TABLE.Insert( VARS.ind_active, Indicator )
            API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
        elseif API.MENU.Get(NEW_UI.Indicators.Trigger.Inactive.Box) and not API.MENU.Get(NEW_UI.Trigger.Key) then
            local r, g, b, a = API.MENU.Get(NEW_UI.Indicators.Trigger.Inactive.Color)
            API.TABLE.Insert( VARS.ind_active, Indicator )
            API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
        end
    end
    if FUNCS.HELP.table_contains(A, "Autowall") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(REFS.RAGE.Autowall) and API.MENU.Get(NEW_UI.Indicators.AWall.Active.Box) and Awall_var or (API.MENU.Get(NEW_UI.Trigger.AwallBox) and API.MENU.Get(NEW_UI.Trigger.AwallKey)) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.AWall.Active.Color)
        elseif API.MENU.Get(REFS.RAGE.Autowall) and not API.MENU.Get(NEW_UI.Indicators.AWall.Active.Box) then
            r, g, b, a = 152, 204, 0, 255
        end
        if API.MENU.Get(NEW_UI.Indicators.AWall.LegitAwall.Box) and Legitawall_var then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.AWall.LegitAwall.Color)
        end
        if API.MENU.Get(NEW_UI.Indicators.AWall.Inactive.Box) and not API.MENU.Get(REFS.RAGE.Autowall) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.AWall.Inactive.Color)
        end
        if API.MENU.Get(NEW_UI.Indicators.AWall.NameBox) and API.MENU.Get(NEW_UI.Indicators.AWall.NameField) ~= "" then
            Indicator = API.MENU.Get(NEW_UI.Indicators.AWall.NameField)
        else
            Indicator = "AW"
        end
        if Awall_var or (Legitawall_var and S_ and API.MENU.Get(NEW_UI.Indicators.AWall.LegitAwall.Box)) or API.MENU.Get(NEW_UI.Indicators.AWall.Inactive.Box) or (API.MENU.Get(NEW_UI.Trigger.AwallBox) and API.MENU.Get(NEW_UI.Trigger.AwallKey)) then
            API.TABLE.Insert( VARS.ind_active, Indicator )
            API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
        end
    end
    if FUNCS.HELP.table_contains(A, "Manual Resolver") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(NEW_UI.Resolver.Box) then
            if API.MENU.Get(NEW_UI.Indicators.Resolver.Active.Box) then
                r, g, b, a = API.MENU.Get(NEW_UI.Indicators.Resolver.Active.Color)
            else
                r, g, b, a = 152, 204, 0, 255
            end
            if VARS.side == 0 then
                direc = "OFF"
            elseif VARS.side == 1 then
                direc = "LEFT"
            elseif VARS.side == 2 then
                direc = "RIGHT"
            end
            if API.MENU.Get(NEW_UI.Indicators.Resolver.NameBox) and API.MENU.Get(NEW_UI.Indicators.Resolver.NameField) ~= "" then
                Indicator = string.format("%s:%s", API.MENU.Get(NEW_UI.Indicators.Resolver.NameField), direc)
            else
                Indicator = string.format("R:%s", direc)
            end
            API.TABLE.Insert( VARS.ind_active, Indicator )
            API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
        end
    end
    if FUNCS.HELP.table_contains(A, "FOV") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(NEW_UI.Indicators.FOV.Active.Box) then
            r, g, b, a = API.MENU.Get(NEW_UI.Indicators.FOV.Active.Color)
        else
            r, g, b, a = 152, 204, 0, 255
        end
        if API.MENU.Get(NEW_UI.Indicators.FOV.NameBox) and API.MENU.Get(NEW_UI.Indicators.FOV.NameField) ~= "" then
            Indicator = string.format("%s: %s", API.MENU.Get(NEW_UI.Indicators.FOV.NameField), API.MENU.Get(REFS.RAGE.MaxFOV))
        else
            Indicator = string.format("FOV: %s", API.MENU.Get(REFS.RAGE.MaxFOV))
        end
        API.TABLE.Insert( VARS.ind_active, Indicator )
        API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
    end
    if FUNCS.HELP.table_contains(A, "Anti-aim Direction") then
        local r, g, b, a
        local Indicator
        if API.MENU.Get(REFS.AntiAim.Master) then
            if API.MENU.Get(NEW_UI.Indicators.AADirection.Active.Box) then
                r, g, b, a = API.MENU.Get(NEW_UI.Indicators.AADirection.Active.Color)
            else
                r, g, b, a = 255, 255, 255, 255
            end
            if API.MENU.Get(NEW_UI.Indicators.AADirection.Combobox) == "Show Real" then
                Indicator = (API.MENU.Get(REFS.AntiAim.Body[2]) < 0 and "LEFT") or "RIGHT"
            elseif API.MENU.Get(NEW_UI.Indicators.AADirection.Combobox) == "Show Fake" then
                Indicator = (API.MENU.Get(REFS.AntiAim.Body[2]) < 0 and "RIGHT") or "LEFT"
            end
            API.TABLE.Insert( VARS.ind_active, Indicator )
            API.TABLE.Insert( VARS.ind_active_clr, { r, g, b, a } )
        end
    end
    if API.TABLE.GetN( VARS.ind_active ) > 0 and API.TABLE.GetN( VARS.ind_active_clr ) > 0 then
        local dpis = API.MENU.Get(REFS.Misc.DPIScale):sub(1, #API.MENU.Get(REFS.Misc.DPIScale) -1)/100
        local iterator = 0
        for k, v in pairs( VARS.ind_active ) do
            iterator = iterator + 1
            local screen_width, screen_height = API.CLIENT.Screen()
            API.RENDER.Text( screen_width / 2, ((screen_height / 2)) + (12 * (iterator) * dpis ), VARS.ind_active_clr[iterator][1], VARS.ind_active_clr[iterator][2], VARS.ind_active_clr[iterator][3], VARS.ind_active_clr[iterator][4], "dcb", 0, v )
        end
    end
    iterator = 0
    for k in pairs( VARS.ind_active ) do
        VARS.ind_active[ k ] = nil
    end
    for k in pairs( VARS.ind_active_clr ) do
        VARS.ind_active_clr[ k ] = nil
    end
end

API.CLIENT.ESPFlag("DESYNC", 255, 0, 0, function(player)
    if not FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.Flags), "Desync") then
        return
    end
    if API.ENT.IsEnemy(player) then
        if API.PLIST.Get(player, "Correction active") == true then
            return true
        end
    end
    return false
end)

API.CLIENT.ESPFlag("LETHAL", 255, 0, 0, function(player)
    if not FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.Flags), "Lethal") then
        return
    end
    local LocalPlayer = API.ENT.LocalPlayer()
    if API.ENT.IsAlive(LocalPlayer) and API.ENT.IsEnemy(player) then
        local pelvis = { API.ENT.HitboxPos(player, "pelvis") }
        if #pelvis == 3 then
            local _, dmg = API.CLIENT.Bullet(LocalPlayer, pelvis[1] - 1, pelvis[2] - 1, pelvis[3] - 1, pelvis[1], pelvis[2], pelvis[3], true)
            return (API.ENT.Prop(player, "m_iHealth") <= dmg)
        end
    end
end)

local function GLHF()
    API.CLIENT.Delay(API.CLIENT.Random(2, 10), API.CLIENT.Exec, "say gl hf")
end

local function GH()
    if VARS.fix == false then
        API.CLIENT.Delay(API.CLIENT.Random(2, 10), API.CLIENT.Exec, "say gh")
    end
end

local function GG()
    if FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.ChatStuff), "GG") then
        if VARS.fix == true then
            API.CLIENT.Exec("say gg")
        end
        API.CLIENT.Delay(1, API.CLIENT.Exec, "disconnect")
    else
        API.CLIENT.Exec("disconnect")
    end
end

local function RoundCheck()
    local rounds = API.ENT.Prop(API.ENT.GameRules(), "m_totalRoundsPlayed")
    if rounds >= 1 and rounds <= 7 then
        VARS.fix = false
    else
        VARS.fix = true
    end
end

local function MissLogs(miss)
    if FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.Prints.Console), "Misses") or FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.Prints.Chat), "Misses") then
        local LocalPlayer = API.ENT.LocalPlayer()
        local Alive = API.ENT.IsAlive(LocalPlayer)
        if not LocalPlayer or not Alive then
            return
        end
        local A = API.MENU.Get(NEW_UI.Prints.Console)
        local B = API.MENU.Get(NEW_UI.Prints.Chat)
        local target = API.ENT.PlayerName(miss.target)
        local group = VARS.Hitgroups[miss.hitgroup + 1] or "?"
        local health = API.ENT.Prop(miss.target, "m_iHealth")
        local messagestart = "{white}[{red}Eternity{white}]"
        if health == nil or health <= 0 then
            if FUNCS.HELP.table_contains(A, "Misses") then
                local message = "- MISS - Target was already dead"
                FUNCS.HELP.ConsoleColor(message)
            end
            if FUNCS.HELP.table_contains(B, "Misses") then
                local message = string.format("%s Missed shot because your {darkred}target {white}is {darkred}already dead", messagestart)
                LIBS.Chat.print(message)
            end
        else
            if miss.reason == "?" then
                reason = "resolver"
            else
                reason = miss.reason
            end
            if FUNCS.HELP.table_contains(A, "Misses") then
                local message = string.format("- MISS - Missed %s's %s due to %s", target, group, reason)
                FUNCS.HELP.ConsoleColor(message)
            end
            if FUNCS.HELP.table_contains(B, "Misses") then
                local message = string.format("%s Missed {darkred}%s{white}'s {green}%s {white}due to {darkred}%s", messagestart, target, group, reason)
                LIBS.Chat.print(message)
            end
        end
    end
end

local function HitLogs(hit)
    if FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.Prints.Console), "Hits") or FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.Prints.Chat), "Hits") then
        local LocalPlayer = API.ENT.LocalPlayer()
        local Alive = API.ENT.IsAlive(LocalPlayer)
        if not LocalPlayer or not Alive then
            return
        end
        local A = API.MENU.Get(NEW_UI.Prints.Console)
        local B = API.MENU.Get(NEW_UI.Prints.Chat)
        local target = API.ENT.PlayerName(hit.target)
        local group = VARS.Hitgroups[hit.hitgroup + 1] or "?"
        local damage = hit.damage
        local hitchance = hit.hit_chance
        local health = API.ENT.Prop(hit.target, "m_iHealth")
        local messagestart = "{white}[{lime}Eternity{white}]"
        local Awall
        if Awall_var then
            Awall = "Full"
        elseif not Awall_var and Legitawall_var and not Glassawall_var and not Triggerawall_var then
            Awall = "Legit"
        elseif not Awall_var and Glassawall_var and not Triggerawall_var then
            Awall = "Glass"
        elseif not Awall_var and Triggerawall_var then
            Awall = "Trigger"
        else
            Awall = "OFF"
        end
        if FUNCS.HELP.table_contains(A, "Hits") then
            local message = string.format("- HIT - Target - %s | HB - %s | DMG - %s | HC - %s | AW - %s", target, group, damage, hitchance, Awall)
            FUNCS.HELP.ConsoleColor(message)
        end
        if FUNCS.HELP.table_contains(B, "Hits") then
            local message = string.format("%s Hit {darkred}%s {white} in the {green}%s {white} for {darkred}%s {white}damage [{green}%s {white}HP]", messagestart, target, group, damage, health)
            LIBS.Chat.print(message)
        end
    end
end

local function VoteOps(e)
    VARS.Votes.VoteOptions = { e.option1, e.option2, e.option3, e.option4, e.option5 }
    for i = #VARS.Votes.VoteOptions, 1, -1 do
        if VARS.Votes.VoteOptions[i] == "" then
            API.TABLE.Remove(VARS.Votes.VoteOptions, i)
        end
    end
end

local function VoteCast(e)
    API.CLIENT.Delay(0.3, function()
        local team = e.team
        if VARS.Votes.VoteOptions then
            local controller
            local voteControllers = API.ENT.GetAll("CVoteController")
            for i = 1, #voteControllers do
                if API.ENT.Prop(voteControllers[i], "m_iOnlyTeamToVote") == team then
                    controller = voteControllers[i]
                    break
                end
            end
            if controller then
                local ongoingVote = {
                    team = team,
                    options = VARS.Votes.VoteOptions,
                    controller = controller,
                    IssueIndex = API.ENT.Prop(controller, "m_iActiveIssueIndex"),
                    votes = { }
                }
                for i = 1, #VARS.Votes.VoteOptions do
                    ongoingVote.votes[VARS.Votes.VoteOptions[i]] = { }
                end
                ongoingVote.type = VARS.Votes.IndicesNoteam[ongoingVote.IssueIndex]
                if team ~= -1 and VARS.Votes.IndicesTeam[ongoingVote.IssueIndex] then
                    ongoingVote.type = VARS.Votes.IndicesTeam[ongoingVote.IssueIndex]
                end
                VARS.Votes.OnGoingVotes.team = ongoingVote
            end
            VARS.Votes.VoteOptions = nil
        end
        local ongoingVote = VARS.Votes.OnGoingVotes.team
        if FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.Prints.Console), "Votes") or FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.Prints.Chat), "Votes") then
            if ongoingVote then
                local A = API.MENU.Get(NEW_UI.Prints.Console)
                local B = API.MENU.Get(NEW_UI.Prints.Chat)
                local caller = e.entityid
                local callerName = API.ENT.PlayerName(caller)
                local messagestart = "{white}[{lime}Eternity{white}]"
                local voteText = ongoingVote.options[e.vote_option + 1]
                local voteTextColor = (voteText == "Yes" and "{green}Yes" or "{darkred}No")
                API.TABLE.Insert(ongoingVote.votes[voteText], player)
                local TeamColor = (team == 3 and "{bluegrey}" or "{yellow}")
                if voteText == "Yes" and ongoingVote.caller == nil then
                    ongoingVote.caller = caller
                    if ongoingVote.type ~= "kick" then
                        if FUNCS.HELP.table_contains(A, "Votes") then
                            local message = string.format("- VOTE - %s called a vote to %s", callerName, VARS.Votes.Descriptions[ongoingVote.type])
                            FUNCS.HELP.ConsoleColor(message)
                        end
                        if FUNCS.HELP.table_contains(B, "Votes") then
                            local message = string.format("%s %s%s {white}called a vote to {purple}%s", messagestart, TeamColor, callerName, VARS.Votes.Descriptions[ongoingVote.type])
                            LIBS.Chat.print(message)
                        end
                    end
                end
                if ongoingVote.type == "kick" then
                    if voteText == "No" then
                        if ongoingVote.target == nil then
                            ongoingVote.target = caller
                            local teamName = string.format("The %s", team == 3 and "CT's" or "T's")
                            if FUNCS.HELP.table_contains(A, "Votes") then
                                local message = string.format("- VOTE - %s called a vote to %s %s", teamName, VARS.Votes.Descriptions[ongoingVote.type], API.ENT.PlayerName(ongoingVote.target))
                                FUNCS.HELP.ConsoleColor(message)
                            end
                            if FUNCS.HELP.table_contains(B, "Votes") then
                                local message = string.format("%s %s%s {white}called a vote to {purple}%s %s%s", messagestart, TeamColor, callerName, VARS.Votes.Descriptions[ongoingVote.type], TeamColor, API.ENT.PlayerName(ongoingVote.target))
                                LIBS.Chat.print(message)
                            end
                        end
                    end
                end
                if FUNCS.HELP.table_contains(A, "Votes") then
                    local message = string.format("- VOTE - %s voted %s", callerName, voteText)
                    FUNCS.HELP.ConsoleColor(message)
                end
                if FUNCS.HELP.table_contains(B, "Votes") then
                    local message = string.format("%s %s%s {white}voted %s", messagestart, TeamColor, callerName, voteTextColor)
                    LIBS.Chat.print(message)
                end
            end
        end
    end)
end

local function DeadThirdPerson()
    API.MENU.Set(REFS.Visuals.ThirdPersonDead, API.MENU.Get(REFS.Visuals.ThirdPerson[2]))
end
-- #region LUA_FUNCS end

-- #region CALLBACK_FUNCS start
local function on_paint_ui()
    visibility()
    if API.MENU.Get(NEW_UI.Indicators.IndicatorsStyle.Combo) == "Crosshair" then
        crosshair_inds()
    end
end

local function on_paint()
    if API.MENU.Get(NEW_UI.AA.IndicatorAA.Types) ~= "OFF" then
        anti_aim_inds()
    end
    if API.MENU.Get(NEW_UI.Resolver.Box) and API.MENU.Get(NEW_UI.Resolver.FlagBox) then
        do_manual_reso_flags()
    end
    if API.MENU.Get(NEW_UI.Indicators.IndicatorsStyle.Combo) == "Default" or API.MENU.Get(NEW_UI.Indicators.IndicatorsStyle.Combo) == "Modern" then
        default_inds()
    end
    DeadThirdPerson()
end

local function on_run_command()
    if API.MENU.Get(NEW_UI.DynamicWeapon.Master) then
        if API.MENU.Get(NEW_UI.DynamicWeapon.DynamicFOV.Master) then
            dynamic_fov()
        end
        if API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.Master) then
            dynamic_settings()
        end
        if API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Master) then
            dynamic_awall()
        end
        DoUpdates()
    end
    if API.MENU.Get(NEW_UI.Autowall.ThroughGlass) then
        glass_awall()
    end
    if API.MENU.Get(NEW_UI.DynamicWeapon.AdaptiveWeapon.LegitAWall.Master) or API.MENU.Get(NEW_UI.Autowall.Box) or API.MENU.Get(NEW_UI.Autowall.ThroughGlass) or API.MENU.Get(NEW_UI.Trigger.AwallBox) then
        AwallHandle()
    end
    if API.MENU.Get(NEW_UI.Trigger.Box) or API.MENU.Get(NEW_UI.Trigger.AwallBox) then
        trigger()
    end
    if API.MENU.Get(NEW_UI.Trigger.AwallBox) then
        triggerawall()
    end
    if API.MENU.Get(NEW_UI.Resolver.Box) then
        if API.ENT.Prop(API.ENT.GameRules(), "m_bFreezePeriod") == 0 then
            do_manual_reso()
        end
    end
    if API.MENU.Get(NEW_UI.AA.LegitAAMaster.Box) then
        if API.MENU.Get(NEW_UI.AA.TeamAA.Box) then
            team_anti_aim()
        end
        if API.MENU.Get(NEW_UI.AA.Disabler.Box) then
            anti_aim_disabler()
        end
    end
end

local function on_setup_command(cmd)
    if cmd.chokedcommands == 0 then
        if cmd.in_use == 1 then
            VARS.Angle = 0
        else
            VARS.Angle = math.min(57, math.abs(API.ENT.Prop(API.ENT.LocalPlayer(), "m_flPoseParameter", 11) * 120 - 60))
        end
    end
    if API.MENU.IsOpen() then 
        cmd.in_attack = false
        cmd.in_attack2 = false
    end
    if API.MENU.Get(REFS.FakeLag.Master[1]) then
        cmd.allow_send_packet = not API.MENU.Get(NEW_UI.FakeLag.Box)
    end
    if API.MENU.Get(NEW_UI.AA.LegitAAMaster.Box) then
        anti_aim_main(cmd)
    end
end

local function on_round_start()
    if API.MENU.Get(NEW_UI.Resolver.Box) then
        manual_reso_roundreset()
    end
    if FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.ChatStuff), "GG") or FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.ChatStuff), "GH") then
        RoundCheck()
    end
end

local function on_round_announce_match_start()
    if FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.ChatStuff), "GLHF") then
        GLHF()
    end
end

local function on_announce_phase_end()
    if FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.ChatStuff), "GH") then
        GH()
    end
end

local function on_cs_win_panel_match()
    if FUNCS.HELP.table_contains(API.MENU.Get(NEW_UI.ChatStuff), "GG") then
        GG()
    end
end

local function on_death(e)
    local victim = API.CLIENT.UIDtoENT(e.userid)
    local killer = API.CLIENT.UIDtoENT(e.attacker)
    local LocalPlayer = API.ENT.LocalPlayer()
    if API.MENU.Get(NEW_UI.Resolver.Box) then
        if victim == LocalPlayer then
            manual_reso_deathreset()
        end
    end
end

local function on_item_equip(e)
    local user = API.CLIENT.UIDtoENT(e.userid)
    local weptype = e.weptype
    local LocalPlayer = API.ENT.LocalPlayer()
    if API.MENU.Get(NEW_UI.Visual.Box) then
        if user == LocalPlayer then
            if weptype == 9 then
                API.MENU.Set(REFS.Visuals.ThirdPerson[1], false)
            else
                API.MENU.Set(REFS.Visuals.ThirdPerson[1], true)
            end
        end
    end
end

local function on_shutdown()
    API.MENU.Visible(REFS.AntiAim.Pitch, true)
    API.MENU.Visible(REFS.AntiAim.YawBase, true)
    API.MENU.Visible(REFS.AntiAim.Yaw[1], true)
    API.MENU.Visible(REFS.AntiAim.Yaw[2], true)
    API.MENU.Visible(REFS.AntiAim.YawJitter, true)
    API.MENU.Visible(REFS.AntiAim.Body[1], true)
    API.MENU.Visible(REFS.AntiAim.Body[2], true)
    API.MENU.Visible(REFS.AntiAim.Freestand, true)
    API.MENU.Visible(REFS.AntiAim.EdgeYaw, true)
    API.MENU.Visible(REFS.AntiAim.FreestandHide[1], true)
    API.MENU.Visible(REFS.AntiAim.FreestandHide[2], true)
    --API.MENU.Visible(REFS.AntiAim.YawLimit, true)
    --API.MENU.Visible(REFS.FakeLag.SlowwalkType, true)
    API.MENU.Visible(REFS.FakeLag.FakePeek, true)
end

local function IndicatorINIT()
    local MinDMG = API.DATA.Read("mindmg_base")
    local SafePoint = API.DATA.Read("safe_point")
    local BodyAim = API.DATA.Read("baim_base")
    local HideShots = API.DATA.Read("hide_shots")
    local Trigger = API.DATA.Read("trigger_base")
    local Autowall = API.DATA.Read("awall_base")
    local Resolver = API.DATA.Read("reso_base")
    local FOV = API.DATA.Read("FOV_base")
    API.MENU.Set(NEW_UI.Indicators.MinDMG.NameField, (MinDMG == nil and "") or MinDMG)
    API.MENU.Set(NEW_UI.Indicators.SafePoint.NameField, (SafePoint == nil and "SAFE") or SafePoint)
    API.MENU.Set(NEW_UI.Indicators.BodyAim.NameField, (BodyAim == nil and "BAIM") or BodyAim)
    API.MENU.Set(NEW_UI.Indicators.BodyAim.NameField, (HideShots == nil and "HIDE") or HideShots)
    API.MENU.Set(NEW_UI.Indicators.Trigger.NameField, (Trigger == nil and "TM") or Trigger)
    API.MENU.Set(NEW_UI.Indicators.AWall.NameField, (Autowall == nil and "AW") or Autowall)
    API.MENU.Set(NEW_UI.Indicators.Resolver.NameField, (Resolver == nil and "R:") or Resolver)
    API.MENU.Set(NEW_UI.Indicators.FOV.NameField, (FOV == nil and "FOV: ") or FOV)
end
IndicatorINIT()
-- #region CALLBACK_FUNCS end

-- #region CALLBACKS start
API.CLIENT.Callback("paint_ui", on_paint_ui)
API.CLIENT.Callback("paint", on_paint)
API.CLIENT.Callback("run_command", on_run_command)
API.CLIENT.Callback("setup_command", on_setup_command)
API.CLIENT.Callback("round_start", on_round_start)
API.CLIENT.Callback("round_announce_match_start", on_round_announce_match_start)
API.CLIENT.Callback("announce_phase_end", on_announce_phase_end)
API.CLIENT.Callback("cs_win_panel_match", on_cs_win_panel_match)
API.CLIENT.Callback("player_death", on_death)
API.CLIENT.Callback("aim_miss", MissLogs)
API.CLIENT.Callback("aim_hit", HitLogs)
API.CLIENT.Callback("vote_options", VoteOps)
API.CLIENT.Callback("vote_cast", VoteCast)
API.CLIENT.Callback("item_equip", on_item_equip)
API.CLIENT.Callback("shutdown", on_shutdown)
-- #region CALLBACKS end