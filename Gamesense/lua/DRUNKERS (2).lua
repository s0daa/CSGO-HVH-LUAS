--made by ivg and swify | loader by odyssey ♡
local pui = require "gamesense/pui"
local msgpack = require "gamesense/msgpack"
local ffi = require "ffi"
local vector = require "vector"
local c_entity = require "gamesense/entity"
local aafunc = require "gamesense/antiaim_funcs"
local base64 = require "gamesense/base64"
local images = require "gamesense/images"
local http = require "gamesense/http"
local lerp = {} lerp.cache = {} lerp.new = function(Name) lerp.cache[Name] = 0 end lerp.lerp = function(Name, LerpTo, Speed) if lerp.cache[Name] == nil then lerp.new(Name); end lerp.cache[Name] = lerp.cache[Name] + (LerpTo - lerp.cache[Name]) * (globals.frametime() * Speed); return lerp.cache[Name]; end; lerp.get = function(Name) if lerp.cache[Name] == nil then return print("Lerp( " .. Name .. " ) does not exisit in function get") end; return lerp.cache[Name]; end lerp.reset = function(Name) if lerp.cache[Name] == nil then return print("Lerp( " .. Name .. " ) does not exisit in function reset") end lerp.cache[Name] = 0; end lerp.delete = function(Name) lerp.cache[Name] = nil; end

local clipboard = (function()
    local ffi = require "ffi" local string_len, tostring, ffi_string = string.len, tostring, ffi.string local M = {} local native_GetClipboardTextCount = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)") local native_SetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)") local native_GetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)") local new_char_arr = ffi.typeof("char[?]") function M.get() local len = native_GetClipboardTextCount() if len > 0 then local char_arr = new_char_arr(len) native_GetClipboardText(0, char_arr, len) return ffi_string(char_arr, len-1) end end M.paste = M.get function M.set(text) text = tostring(text) native_SetClipboardText(text, string_len(text)) end M.copy = M.set return M
end)()

local con_filter = cvar.con_filter_enable
local con_filter_text = cvar.con_filter_text

local originalprint = print

local accent = {}

local print = function(...)
    client.color_log(accent.r, accent.g, accent.b, "[DRUNKERS] \0")
    client.color_log(198, 203, 209, ...)
end

ffi.cdef[[
    typedef struct
    {
        float x;
        float y;
        float z;
    } vec3_t;

    typedef struct
    {
        float   m_anim_time;		
        float   m_fade_out_time;	
        int     m_flags;			
        int     m_activity;			
        int     m_priority;			
        int     m_order;			
        int     m_sequence;			
        float   m_prev_cycle;		
        float   m_weight;			
        float   m_weight_delta_rate;
        float   m_playback_rate;	
        float   m_cycle;			
        void* m_owner;			
        int     m_bits;				
    } C_AnimationLayer;

    typedef struct
    {
        char        pad0[0x60]; // 0x00
        void*       pEntity; // 0x60
        void*       pActiveWeapon; // 0x64
        void*       pLastActiveWeapon; // 0x68
        float        flLastUpdateTime; // 0x6C
        int            iLastUpdateFrame; // 0x70
        float        flLastUpdateIncrement; // 0x74
        float        flEyeYaw; // 0x78
        float        flEyePitch; // 0x7C
        float        flGoalFeetYaw; // 0x80
        float        flLastFeetYaw; // 0x84
        float        flMoveYaw; // 0x88
        float        flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float        flLeanAmount; // 0x90
        char        pad1[0x4]; // 0x94
        float        flFeetCycle; // 0x98 0 to 1
        float        flMoveWeight; // 0x9C 0 to 1
        float        flMoveWeightSmoothed; // 0xA0
        float        flDuckAmount; // 0xA4
        float        flHitGroundCycle; // 0xA8
        float        flRecrouchWeight; // 0xAC
        vec3_t    vecOrigin; // 0xB0
        vec3_t    vecLastOrigin;// 0xBC
        vec3_t    vecVelocity; // 0xC8
        vec3_t    vecVelocityNormalized; // 0xD4
        vec3_t    vecVelocityNormalizedNonZero; // 0xE0
        float        flVelocityLenght2D; // 0xEC
        float        flJumpFallVelocity; // 0xF0
        float        flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1
        float        flRunningSpeed; // 0xF8
        float        flDuckingSpeed; // 0xFC
        float        flDurationMoving; // 0x100
        float        flDurationStill; // 0x104
        bool        bOnGround; // 0x108
        bool        bHitGroundAnimation; // 0x109
        char        pad2[0x2]; // 0x10A
        float        flNextLowerBodyYawUpdateTime; // 0x10C
        float        flDurationInAir; // 0x110
        float        flLeftGroundHeight; // 0x114
        float        flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float        flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char        pad3[0x4]; // 0x120
        float        flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char        pad4[0x208]; // 0x128
        char pad_because_yes[0x4]; // 0x330
        float        flMinBodyYaw; // 0x330 + 0x4
        float        flMaxBodyYaw; // 0x334 + 0x4
        float        flMinPitch; //0x338 + 0x4
        float        flMaxPitch; // 0x33C + 0x4
        int            iAnimsetVersion; // 0x340 + 0x4
    } CCSGOPlayerAnimationState_t;

    
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);
]]

local panorama = panorama.open()

local memory = {} do
    memory.pattern_scan = function(module, signature, add)
        local buff = ffi.new("char[1024]")

        local c = 0

        for char in string.gmatch(signature, "..%s?") do
            if char == "? " or char == "?? " then
                buff[c] = 0xcc
            else
                buff[c] = tonumber("0x" .. char)
            end

            c = c + 1
        end

        local result = ffi.cast("uintptr_t", client.find_signature(module, ffi.string(buff)))

        if add and tonumber(result) ~= 0 then
            result = ffi.cast("uintptr_t", tonumber(result) + add)
        end

        return result
    end
end

local player_info_t = ffi.typeof([[
    struct {
        int64_t         unknown;
        int64_t         steamID64;
        char            szName[128];
        int             userId;
        char            szSteamID[20];
        char            pad_0x00A8[0x10];
        unsigned long   iSteamID;
        char            szFriendsName[128];
        bool            fakeplayer;
        bool            ishltv;
        unsigned int    customfiles[4];
        unsigned char   filesdownloaded;
    }
]])

local native_BaseLocalClient_base = ffi.cast("uintptr_t**", memory.pattern_scan("engine.dll", "A1 ? ? ? ? 0F 28 C1 F3 0F 5C 80 ? ? ? ? F3 0F 11 45 ? A1 ? ? ? ? 56 85 C0 75 04 33 F6 EB 26 80 78 14 00 74 F6 8B 4D 08 33 D2 E8 ? ? ? ? 8B F0 85 F6", 1))
local native_GetStringUserData = vtable_thunk(11, ffi.typeof("$*(__thiscall*)(void*, int, int*)", player_info_t))


local logo = nil
http.get('https://DRUNKERS.nn/assets/images/logoDRUNKERS2.png', function(s, r)
    if s and r.status == 200 then
        logo = images.load(r.body)
    end
end)
--print(logo)
local utilitize = {
    this_call = function(call_function, parameters)
        return function(...)
            return call_function(parameters, ...)
        end
    end;

    entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), client.create_interface("client.dll", "VClientEntityList003"));
}
local get_entity_address = utilitize.this_call(ffi.cast("get_client_entity_t", utilitize.entity_list_003[0][3]), utilitize.entity_list_003);
local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)');

local get_animstate = function(address)
    if not address then return end
    return ffi.cast("CPlayer_Animation_State**", ffi.cast("uintptr_t", address) + 0x9960)[0]
end
local originalmeasure = renderer.measure_text
local measure_text2 = function(flags, ...)
    local shit1, shit2 = originalmeasure(flags, ...)
    return {x = shit1, y = shit2}
end
local clamp = function(n, mn, mx)
    if n > mx then
        return mx;
    elseif n < mn then
        return mn;
    else
        return n;
    end
end


local get_vector_prop = function(idx, prop, array)
    local v1, v2, v3 = entity.get_prop(idx, prop, array)
    return {
        x = v1, y = v2, z = v3
    }
end

local vec_length2d = function(vec)
    root = 0.0
    sqst = vec.x * vec.x + vec.y * vec.y
    root = math.sqrt(sqst)
    return root
end

local tools = {} do 
    tools.check_tickbase = function()
        local local_player = entity.get_local_player()
        local sim_time = entity.get_prop(local_player, "m_flSimulationTime")
        if local_player == nil or sim_time == nil then
            return
        end
        local tick_count = globals.tickcount()
        local shifted = math.max(unpack(list_shift))
        shift_int = shifted < 0 and math.abs(shifted) or 0
        list_shift[#list_shift+1] = sim_time/globals.tickinterval() - tick_count
        table.remove(list_shift, 1)
    end
    tools.rgba_to_hex = function(b,c,d,e)
        return string.format('%02x%02x%02x%02x',b,c,d,e)
    end
    tools.lerp = function(start, end_pos, time)
        if start == end_pos then
            return end_pos
        end
        local frametime = globals.frametime() * 170
        time = time * frametime
        local val = start + (end_pos - start) * time
        if math.abs(val - end_pos) < 0.01 then
            return end_pos
        end
        return val
    end
    tools.distance = function(x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
    end
    tools.dump = function(self, o)
        if type(o) == "table" then
            local s = "{ "
            for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = "\"" .. k .. "\""
            end
            s = s .. "[" .. k .. "] = " .. self.dump(v) .. ","
            end
            return s .. "} "
        else
            return tostring(o)
        end
    end
    tools.gradient = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
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
    tools.gradient_text = function(base_r, base_g, base_b, base_a, r2, g2, b2, a2, text_to_draw, speed)
        local highlight_fraction =  (globals.realtime() / 2 % 1.2 * speed) - 1.2
        local output = ""
        for idx = 1, #text_to_draw do
            local character = text_to_draw:sub(idx, idx)
            local character_fraction = idx / #text_to_draw
            
            local r, g, b, a = base_r, base_g, base_b, base_a
            local highlight_delta = math.abs(character_fraction - 0.5 - highlight_fraction) * 1
            if highlight_delta <= 1 then
                local r_fraction, g_fraction, b_fraction, a_fraction = r2 - r, g2 - g, b2 - b, a2 - a
                r = r + r_fraction * (1 - highlight_delta)
                g = g + g_fraction * (1 - highlight_delta)
                b = b + b_fraction * (1 - highlight_delta)
                a = a + a_fraction * (1 - highlight_delta)
            end
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, a, text_to_draw:sub(idx, idx))
        end
        return output
    end
    tools.text_fade = function(self, speed, r, g, b, a, text)
        local final_text = ''
        local curtime = globals.curtime()
        for i=0, #text do
            local color = self.rgba_to_hex(r, g, b, a*math.abs(1*math.cos(2*speed*curtime/4+i*5/30)))
            final_text = final_text..'\a'..color..text:sub(i, i)
        end
        return final_text
    end
    tools.text_gradient = function(self, speed, r, g, b, a, text)
        local final_text = ''
        local curtime = globals.curtime()
        for i=0, #text do
            local color = self.rgba_to_hex(r*math.abs(1*math.cos(2*speed*curtime/4+i*5/30)), g*math.abs(1*math.cos(2*speed*curtime/4+i*5/30)), b*math.abs(1*math.cos(2*speed*curtime/4+i*5/30)), a)
            final_text = final_text..'\a'..color..text:sub(i, i)
        end
        return final_text
    end
    tools.animation = {
        database = {},
        speed = 0.07,
        lerp = function(start, end_pos, time)
            local val = start + (end_pos - start) * (globals.frametime() * time)
            return val
        end,
        new = function(self, name, new_value, speed, init)
            speed = speed or self.speed
    
            if self.database[name] == nil then
                self.database[name] = (init and init) or 0
            end
    
            self.database[name] = self.lerp(self.database[name], new_value, speed)
            return self.database[name]
        end,
        fade = function(self, r1, g1, b1, r2, g2, b2, percentage, screwme)
            local r3 = r1 * (100 - percentage) / 100.0 + r2 * (percentage) / 100.0
            local g3 = g1 * (100 - percentage) / 100.0 + g2 * (percentage) / 100.0
            local b3 = b1 * (100 - percentage) / 100.0 + b2 * (percentage) / 100.0
            local r = math.floor(r3)
            local g = math.floor(g3)
            local b = math.floor(b3)
            local returnclr = r
            if screwme == "r" then
                returnclr = r
            elseif screwme == "g" then
                returnclr = g
            elseif screwme == "b" then
                returnclr = b
            end
            return returnclr
        end,
        text = function(self, font, text, flags, color2, textOffset, speed)
            if speed == 0 then
                speed = 1
            else
                speed = speed
            end
            
            local data, totalWidth = {}, 0
            local len, two_pi = #text, math.pi * 1.5

        
            for idx = 1, len do
                local modifier = two_pi / len * idx
                local char = text:sub(idx, idx)
                local charWidth =
                    font == 2 and renderer.measure_text(font, flags, char).x - 2 or renderer.measure_text(font, flags, char).x
                data[idx] = {totalWidth, char, modifier}
                totalWidth = totalWidth + charWidth
            end
        
            totalWidth = totalWidth * 0.5
        
            return function()
                local time = -globals.curtime * math.pi * speed
                local headerOffset = textOffset - vector(totalWidth, 0)
        
                for _, char in pairs(data) do
                    local charPosition = headerOffset + vector(char[1], 0)
                    local fadeValue = math.sin(time + char[3]) * 0.5 + 0.5
                    local colorr = self:fade(255, 255, 255, color2.r, color2.g, color2.b, fadeValue * 100, "r")
                    local colorg = self:fade(255, 255, 255, color2.r, color2.g, color2.b, fadeValue * 100, "g")
                    local colorb = self:fade(255, 255, 255, color2.r, color2.g, color2.b, fadeValue * 100, "b")
                    renderer.text(font, charPosition, color(colorr, colorg, colorb), flags, char[2])
                end
            end
        end
    }
end
local temp = {}
local config = {}
local states = {"global", "stand", "slow walk", "move", "duck", "duck move", "air", "air duck"}
local phase = {"phase 1", "phase 2", "phase 3", "phase 4", "phase 5"}

local database_key = "DRUNKERS_best_lua_OnG_for_real:configs"
local E_POSE_PARAMETERS = {
    STRAFE_YAW = 0,
    STAND = 1,
    LEAN_YAW = 2,
    SPEED = 3,
    LADDER_YAW = 4,
    LADDER_SPEED = 5,
    JUMP_FALL = 6,
    MOVE_YAW = 7,
    MOVE_BLEND_CROUCH = 8,
    MOVE_BLEND_WALK = 9,
    MOVE_BLEND_RUN = 10,
    BODY_YAW = 11,
    BODY_PITCH = 12,
    AIM_BLEND_STAND_IDLE = 13,
    AIM_BLEND_STAND_WALK = 14,
    AIM_BLEND_STAND_RUN = 14,
    AIM_BLEND_CROUCH_IDLE = 16,
    AIM_BLEND_CROUCH_WALK = 17,
    DEATH_YAW = 18
}

local ref = {
    aa_enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = { ui.reference("AA", "Anti-aimbot angles", "Pitch") },
    yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
    yaw_jitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") } ,
    body_yaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
    freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    freestanding = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
    roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
    

    fakelag_enable = { ui.reference("AA", "Fake Lag", "Enabled") },
    fakelag_mode = ui.reference("AA", "Fake Lag", "Amount"),
    fakelag_variance = ui.reference("AA", "Fake Lag", "Variance"),
    fakelag_limit = ui.reference("AA", "Fake Lag", "Limit"),

    leg_movement = ui.reference("AA", "Other", "Leg movement"),
    fake_peek = { ui.reference("AA", "Other", "Fake peek") },

    double_tap = { ui.reference("Rage", "Aimbot", "Double tap") },
    double_tap_fake_lag_limit = ui.reference("Rage", "Aimbot", "Double tap fake lag limit"),

    onshot_aa = { ui.reference("AA", "Other", "On shot anti-aim") },

    quick_peek_assist = { ui.reference("Rage", "Other", "Quick peek assist") },
    duck_peek_assist = ui.reference("Rage", "Other", "Duck peek assist"),

    slow_motion = { ui.reference("AA", "Other", "Slow motion") },

    mindamage = ui.reference("Rage", "Aimbot", "Minimum damage"),
    mindamage_override = { ui.reference("Rage", "Aimbot", "Minimum damage override") },


    ui_color = ui.reference("MISC", "Settings", "Menu color"),

    ping_spike = {ui.reference("MISC", "Miscellaneous", "Ping spike")},

    weapon = ui.reference("Rage", "Weapon Type", "Weapon Type"),

    console = ui.reference("MISC", "Miscellaneous", "Draw console output"),

    weapon_type = ui.reference("Rage", "Weapon type", "Weapon type"),
    hitchance = ui.reference("Rage", "Aimbot", "Minimum hit chance"),

} 

ui.set(ref.aa_enabled, true)
ui.set(ref.yaw_base, "At targets")
local user = _USER_NAME and _USER_NAME or "DRUNK"
local groups = {
    main = pui.group("aa", "anti-aimbot angles"),
    fakelag = pui.group("aa", "fake lag"),
    other = pui.group("aa", "other"),
    debug = pui.group("Lua", "A")
}
pui.accent = tools.rgba_to_hex(ui.get(ref.ui_color))
local menu = {
    enable = groups.main:checkbox("\vDRUNKERS.nn", {ui.get(ref.ui_color)}),
    tab = (user == "violentkilla" and groups.main:slider("\n", 1, 6, 0, 1,"",1, {[0] = "hidden", [1] = "home", [2] = "antiaim", [3] = "rage", [4] = "visuals", [5] = "main", [6] = "premium"}, false) or groups.main:slider("\n", 1, 5, 0, 1,"",1, {[0] = "hidden", [1] = "home", [2] = "antiaim", [3] = "rage", [4] = "visuals", [5] = "main", [6] = "premium"}, false)),
    sliderspacing = groups.main:label("\n\n"), --use in tabs that dont have sub-tabs @swify
    home = {
        air1 = groups.main:label("                  "),
        welcome = groups.main:label("Welcome to \vDRUNKERS.nn"), --done
        user = groups.main:label("User : \v".. tostring(user)), --done
        --config
        air = groups.main:label("       "),
        list   = groups.main:listbox("Configs", {}, false), --done
        name   = groups.main:textbox("Config name"), --done

        load   = groups.main:button("\vLoad", function() end), --done
        save   = groups.main:button("\vSave", function() end), --done
        delete = groups.main:button("\vDelete", function() end), --done
        export = groups.main:button("\vExport", function() end), --done
        import = groups.main:button("\vImport", function() end), --done
    },
    antiaim = {
        tab = groups.main:slider("\n\n\n", 0, 2, 0, 1,"",1, {[0] = "builder", [1] = "antibruteforce", [2] = "hotkeys"}, false),
        -- air1 = groups.main:label("        "),
        condition = groups.main:combobox("condition : ",states, false),
        builder = {},
        hotkeys = {
            freestand = groups.main:checkbox("freestand", 0x00), --done
            edge_yaw = groups.main:checkbox("edge yaw", 0x00), --done
            left = groups.main:checkbox("left ", 0x00), --done
            right = groups.main:checkbox("right", 0x00), --done
            forward = groups.main:checkbox("forward", 0x00), --done
            reset = groups.main:checkbox("reset", 0x00), --done
        }, 
    },
    rage = {
        resolver = groups.main:checkbox("resolver \v ⚠", false), --done
        label2 = groups.main:label("          - - -  \vantiaim stealer \r - - - "),  
        player = groups.main:slider("enemy index", 0, 16, 0, 1,"",1, {[0] = "off"}),
        playername = groups.main:label("selected player: \vnone"),
        disclaimer = groups.main:label("\aFF0F05FF⚠ PLAYER MUST NOT DORMANT ⚠"),
        update = groups.main:button("\vupdate players"),
        condition = groups.main:combobox("steal condition : ", {"standing", "moving", "duck", "air", "air duck"}, false),
        steal = groups.main:button("\vsteal"),
        status = groups.main:slider("status debug", 0, 16, 0, 1),
        label3 = groups.main:label(" "),
        confirm = groups.main:button("\a00FF00FFconfirm"),
        cancel = groups.main:button("\aFF0F05FFcancel"),
        --status = 0

    },
    visuals = {
        tab = groups.main:slider("\n\n\n\n", 0, 1, 0, 1,"",1, {[0] = "screen", [1] = "local"}, false),
        --screen
        crosshair = groups.main:combobox("crosshair indicators", {"none", "pixel", "DRUNKERS"}), -- done
        desync = groups.main:combobox("desync style", {"none", "static", "jitter"}), -- done
        modifiers = groups.main:multiselect("modifiers", {"scope", "nade"}), --done
        watermark = groups.main:combobox("watermark", {"default", "discord", "bottom"}), -- done
        arrows = groups.main:combobox("Arrows", {"none", "team skeet"}),
        -- spacing2 = groups.main:label("\n\n\n\n\n"), --done
        dmg = groups.main:checkbox("mindmg indicator"), --done
        dmg_m = groups.main:multiselect("\n\n\n\n\n", {"show always", "animate", "low transparency"}), -- done
        velocity = groups.main:checkbox("velocity warning"),
        defensive = groups.main:checkbox("defensive indicator"),
        --player
        on_ground = groups.main:combobox("legs on ground", {"off", "break", "static", "slow"}), --done
        in_air = groups.main:combobox("legs in air", {"off", "break", "static"}), --done
        movelean = groups.main:checkbox("move lean"), --done
        moveleanslider = groups.main:slider("move lean amount", 0, 100, 0, 1, "%"), --done
        perfect = groups.main:checkbox("perfect animation breaker"),
        perfect_slider = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", 0, 10, 1, 1), --done
        always90 = groups.main:checkbox("always down pitch"),
        pitch0 = groups.main:checkbox("0 pitch on land"), --done
        spacing = groups.main:label("\n\n\n\n\n\n"), --done
        person = groups.main:slider("third person distance", 0, 150, 60, 1), --done
        aspect = groups.main:slider("aspect ratio", 0, 200, 0, 1), --done

    },
    main = {
        tab = groups.main:slider("\n\n\n\n\n\n\n", 0, 1, 0, 1,"",1, {[0] = "misc", [1] = "helpers"}, false),
        logs = groups.main:multiselect("logs", {"hit", "miss" , "debug"}), -- done
        clantag = groups.main:checkbox("clantag"), -- done
        killsay = groups.main:checkbox("trashtalk"), -- done
        console = groups.main:checkbox("console filter"), -- done
        safehead = groups.main:multiselect("safehead", {"knife", "zeus", "above enemy"}), -- done
        ladder = groups.main:checkbox("fast ladder"), -- done
        ladder_pitch = groups.main:slider("pitch", -89, 89, 0, 1), -- done
        ladder_yaw = groups.main:slider("yaw ", -180, 180, 0, 1), -- done
        antistab = groups.main:checkbox("anti backstab"),
        bombfix =  groups.main:checkbox("bombside e fix", 0x45),

    },
    premium = {
        killsay = groups.main:checkbox("meduza special (use killsay)"),
        clientlabel = groups.main:label("    --- client-side username ---"),
        user = groups.main:textbox("client-side username"), --done
        set = groups.main:button("set name", function() end), --done
        debuglabel = groups.main:label("    ---      debug panel      ---"),
        debugtoggle = groups.main:checkbox("debug panel"), --done
    },
}

accent.r, accent.g, accent.b = 0,0,0

local callbacks = {} do
    callbacks.thirdperson = function(LPH_NO_VIRTUALIZE)
        cvar.cam_idealdist:set_int(menu.visuals.person:get())
    end
    callbacks.aspect = function(LPH_NO_VIRTUALIZE)
        cvar.r_aspectratio:set_float(menu.visuals.aspect:get() / 100)
    end
    callbacks.console_filter = function(LPH_NO_VIRTUALIZE) 
        if menu.main.console:get() then
            cvar.developer:set_int(0) 
            cvar.con_filter_enable:set_int(1) 
            cvar.con_filter_text:set_string("abcd") 
            client.exec("con_filter_enable 1") 
        else
            cvar.con_filter_enable:set_int(0) 
            cvar.con_filter_text:set_string("") 
            client.exec("con_filter_enable 0")
        end
    end
end

local update_callbacks = function()
    for k, v in pairs(callbacks) do
        v()
    end
end

local defaultconfig = "iaZlbmFibGXDo3RhYgGndmlzdWFsc94AEah2ZWxvY2l0ecOjdGFiAaZkZXN5bmOmc3RhdGljqG1vdmVsZWFuw65tb3ZlbGVhbnNsaWRlchSpb25fZ3JvdW5kpWJyZWFrp3BlcmZlY3TCqWRlZmVuc2l2ZcOlZG1nX22Tq3Nob3cgYWx3YXlzp2FuaW1hdGWhfqljcm9zc2hhaXKkbm9uZaZwaXRjaDDCpnBlcnNvbjujZG1nw6Zpbl9haXKjb2ZmpmFzcGVjdH2pd2F0ZXJtYXJrp2Rpc2NvcmSpbW9kaWZpZXJzk6VzY29wZaRuYWRloX6oZW5hYmxlX2OpIzk4QTdGM0ZGp2FudGlhaW2Ep2J1aWxkZXKY3gAUpXBpdGNopGRvd260ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZlqWFsd2F5cyBvbqhvdmVycmlkZcOuZGVmZW5zaXZlX3NwaW4JrWRlZmVuc2l2ZV95YXeoZGlzYWJsZWSzZGVmZW5zaXZlX3BpdGNoX3ZhbACqYnJ1dGVmb3JjZadwaGFzZSAxo3lhd6psZWZ0L3JpZ2h0smRlZmVuc2l2ZV95YXdfdmFsMgCnYm9keXlhd6ZqaXR0ZXKqbW9kX3NsaWRlcgCoY2xhc3NpYzHpsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzI1pWJydXRlld4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZKl5YXdfdmFsdWUA3gAUpXBpdGNopGRvd260ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheRypZGVmZW5zaXZlqWFsd2F5cyBvbqhvdmVycmlkZcOuZGVmZW5zaXZlX3NwaW4JrWRlZmVuc2l2ZV95YXeoZGlzYWJsZWSzZGVmZW5zaXZlX3BpdGNoX3ZhbACqYnJ1dGVmb3JjZadwaGFzZSAxo3lhd6psZWZ0L3JpZ2h0smRlZmVuc2l2ZV95YXdfdmFsMgCnYm9keXlhd6VicmVha6ptb2Rfc2xpZGVyAKhjbGFzc2ljMeGxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMjWlYnJ1dGWV3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVk3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVk3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVk3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVk3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVkqXlhd192YWx1ZQDeABSlcGl0Y2ikZG93brRkZWZlbnNpdmVfcGl0Y2hfdmFsMgCvZGVmZW5zaXZlX3BpdGNoqGRpc2FibGVkpWRlbGF5AqlkZWZlbnNpdmWpYWx3YXlzIG9uqG92ZXJyaWRlw65kZWZlbnNpdmVfc3BpbgmtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZLNkZWZlbnNpdmVfcGl0Y2hfdmFsAKpicnV0ZWZvcmNlp3BoYXNlIDGjeWF3qmxlZnQvcmlnaHSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3pmppdHRlcqptb2Rfc2xpZGVyAKhjbGFzc2ljMdDfsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzItpWJydXRlld4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZKl5YXdfdmFsdWUA3gAUpXBpdGNopGRvd260ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheRCpZGVmZW5zaXZlqWFsd2F5cyBvbqhvdmVycmlkZcOuZGVmZW5zaXZlX3NwaW4JrWRlZmVuc2l2ZV95YXeoZGlzYWJsZWSzZGVmZW5zaXZlX3BpdGNoX3ZhbACqYnJ1dGVmb3JjZadwaGFzZSAxo3lhd6hiYWNrd2FyZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXelYnJlYWuqbW9kX3NsaWRlcj2oY2xhc3NpYzHjsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqZjZW50ZXKoY2xhc3NpYzI1pWJydXRlld4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZKl5YXdfdmFsdWUD3gAUpXBpdGNopGRvd260ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZlqWFsd2F5cyBvbqhvdmVycmlkZcOuZGVmZW5zaXZlX3NwaW4JrWRlZmVuc2l2ZV95YXeoZGlzYWJsZWSzZGVmZW5zaXZlX3BpdGNoX3ZhbACqYnJ1dGVmb3JjZadwaGFzZSAxo3lhd6hiYWNrd2FyZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXemaml0dGVyqm1vZF9zbGlkZXJTqGNsYXNzaWMx0N+xZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVypmNlbnRlcqhjbGFzc2ljMiWlYnJ1dGWV3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVk3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVk3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVk3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVk3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVkqXlhd192YWx1ZQfeABSlcGl0Y2ioZGlzYWJsZWS0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluCa1kZWZlbnNpdmVfeWF3qGRpc2FibGVks2RlZmVuc2l2ZV9waXRjaF92YWwAqmJydXRlZm9yY2WncGhhc2UgMaN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKhjbGFzc2ljMQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMjWlYnJ1dGWV3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVk3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVk3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVk3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVk3gATs2RlZmVuc2l2ZV9waXRjaF92YWwAqXRlc3RfdGltZQC0ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheQKpZGVmZW5zaXZloS2ob3ZlcnJpZGXCrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6hkaXNhYmxlZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXejb2Zmqm1vZF9zbGlkZXIAqXlhd192YWx1ZQCxZGVmZW5zaXZlX3lhd192YWwAqG1vZGlmaWVyo29mZqhjbGFzc2ljMgCoY2xhc3NpYzEApXBpdGNoqGRpc2FibGVkqXlhd192YWx1ZQDeABSlcGl0Y2ikZG93brRkZWZlbnNpdmVfcGl0Y2hfdmFsMgCvZGVmZW5zaXZlX3BpdGNoqGRpc2FibGVkpWRlbGF5AqlkZWZlbnNpdmWpYWx3YXlzIG9uqG92ZXJyaWRlw65kZWZlbnNpdmVfc3BpbgmtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZLNkZWZlbnNpdmVfcGl0Y2hfdmFsAKpicnV0ZWZvcmNlp3BoYXNlIDGjeWF3qGJhY2t3YXJksmRlZmVuc2l2ZV95YXdfdmFsMgCnYm9keXlhd6ZqaXR0ZXKqbW9kX3NsaWRlcneoY2xhc3NpYzEBsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqZvZmZzZXSoY2xhc3NpYzIApWJydXRlld4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZKl5YXdfdmFsdWXn3gAUpXBpdGNopGRvd260ZGVmZW5zaXZlX3BpdGNoX3ZhbDIAr2RlZmVuc2l2ZV9waXRjaKhkaXNhYmxlZKVkZWxheRSpZGVmZW5zaXZlqWFsd2F5cyBvbqhvdmVycmlkZcOuZGVmZW5zaXZlX3NwaW4JrWRlZmVuc2l2ZV95YXeoZGlzYWJsZWSzZGVmZW5zaXZlX3BpdGNoX3ZhbACqYnJ1dGVmb3JjZadwaGFzZSAxo3lhd6hiYWNrd2FyZLJkZWZlbnNpdmVfeWF3X3ZhbDIAp2JvZHl5YXelYnJlYWuqbW9kX3NsaWRlckeoY2xhc3NpYzHnsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqZjZW50ZXKoY2xhc3NpYzIlpWJydXRlld4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUFtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkRqWRlZmVuc2l2ZalhbHdheXMgb26ob3ZlcnJpZGXDrmRlZmVuc2l2ZV9zcGluAK1kZWZlbnNpdmVfeWF3qGRpc2FibGVko3lhd6psZWZ0L3JpZ2h0smRlZmVuc2l2ZV95YXdfdmFsMgCnYm9keXlhd6VicmVha6ptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzInqGNsYXNzaWMx0N+lcGl0Y2ikZG93bt4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZN4AE7NkZWZlbnNpdmVfcGl0Y2hfdmFsAKl0ZXN0X3RpbWUAtGRlZmVuc2l2ZV9waXRjaF92YWwyAK9kZWZlbnNpdmVfcGl0Y2ioZGlzYWJsZWSlZGVsYXkCqWRlZmVuc2l2ZaEtqG92ZXJyaWRlwq5kZWZlbnNpdmVfc3BpbgCtZGVmZW5zaXZlX3lhd6hkaXNhYmxlZKN5YXeoZGlzYWJsZWSyZGVmZW5zaXZlX3lhd192YWwyAKdib2R5eWF3o29mZqptb2Rfc2xpZGVyAKl5YXdfdmFsdWUAsWRlZmVuc2l2ZV95YXdfdmFsAKhtb2RpZmllcqNvZmaoY2xhc3NpYzIAqGNsYXNzaWMxAKVwaXRjaKhkaXNhYmxlZKl5YXdfdmFsdWUAqWNvbmRpdGlvbqhhaXIgZHVja6dob3RrZXlzjKVyaWdodMKlcmVzZXTCp3Jlc2V0X2iTAQChfqlmb3J3YXJkX2iTAQChfqdyaWdodF9okwEyoX6pZnJlZXN0YW5kw6tmcmVlc3RhbmRfaJMBBaF+qGVkZ2VfeWF3wqdmb3J3YXJkwqplZGdlX3lhd19okwEAoX6kbGVmdMKmbGVmdF9okwExoX6jdGFiAKRob21lgqRsaXN0AqRuYW1lp2FudGlhaW2kbWFpboyjdGFiAKdjbGFudGFnw6hhbnRpc3RhYsOpYm9tYmZpeF9okwFFoX6kbG9nc5SjaGl0pG1pc3OlZGVidWehfqhzYWZlaGVhZJOla25pZmWkemV1c6F+p2JvbWJmaXjDpmxhZGRlcsOna2lsbHNhecKnY29uc29sZcOqbGFkZGVyX3lhd9H/TKxsYWRkZXJfcGl0Y2hZp3ByZW1pdW2DpHVzZXKgp2tpbGxzYXnCq2RlYnVndG9nZ2xlwqRyYWdlhKZzdGF0dXMAqWNvbmRpdGlvbqhzdGFuZGluZ6ZwbGF5ZXIAqHJlc29sdmVyww=="

local home = {} do
    home.update_default = function()
        local db = database.read(database_key) or {}
        for i, v in ipairs(db) do
            if v.name == "default" then
                if v.config ~= defaultconfig then
                    table.remove(db, i)
                    table.insert(db, { name = "default", config = defaultconfig })
                    break
                end
            end
        end
        database.write(database_key, db)
        ui.update(menu.home.list.ref, home.get_configs())
        ui.set(menu.home.list.ref, 0)
    end
    home.load_settings = function(string)
        local msg = base64.decode(string)
        local setts = msgpack.unpack(msg)
        --print(setts)
        config.cfg:load(setts)
        update_callbacks()
    end
    home.save_config = function(name)
        local db = database.read(database_key) or {}

        local data = config.cfg:save()

        --print(config.cfg:save()

        local new_data = msgpack.pack(data)
        local encrypted = base64.encode(new_data)
        --print(encrypted)
        -- print(config_string)

        local config_index = nil
        if name == "default" then print("nuh uh") return end
        for i, v in ipairs(db) do
            if v.name == name then
                config_index = i
                break
            end
        end
        if config_index then
            db[config_index].config = encrypted
        else 
            table.insert(db, { name = name, config = encrypted })
        end
        database.write(database_key, db)
    end
    home.get_configs = function()
        local db = database.read(database_key) or {}
        local configs = {}
        for i = 1, #db do
            table.insert(configs, db[i].name)
        end
        return configs
    end
    home.delete_config = function(name)
        local db = database.read(database_key) or {}
        if name == "default" then print("nuh uh") return end
        for i, v in ipairs(db) do
            if v.name == name then
                table.remove(db, i)
                break
            end
        end
        database.write(database_key, db)
        ui.update(menu.home.list.ref, home.get_configs())
        ui.set(menu.home.list.ref, 0)
    end
    local tempdb = database.read(database_key) or {}
    local founddefault = false
    for i, v in ipairs(tempdb) do
        if v.name == "default" then 
            founddefault = true
            break
        end
    end
    if not founddefault then
        table.insert(tempdb, { name = "default", config = defaultconfig })
    end
    database.write(database_key, tempdb)
    menu.home.export:set_callback(function()
        local data = config.cfg:save()
        local new_data = msgpack.pack(data)
        local encrypted = base64.encode(new_data)
        clipboard.set(encrypted)
    end)  
    menu.home.import:set_callback(function()
        local data = clipboard.get()
        local decrypted = base64.decode(data)
        local new_data = msgpack.unpack(decrypted)
        config.cfg:load(new_data)
        update_callbacks()
    end)
    menu.home.list:set_callback(function(self)
        ui.update(menu.home.list.ref, home.get_configs())

        local selected = menu.home.list:get()
        if selected == nil then return end
        local configs = home.get_configs()
        local name = configs[selected + 1]
        ui.set(menu.home.name.ref, name)
    end)
    menu.home.load:set_callback(function()
        --print("1")
        local configs = home.get_configs()
        local name = menu.home.name:get()
        if name == "" then return end
        local db = database.read(database_key) or {}
        for i = 1, #db do
            if db[i].name == name then
                home.load_settings(db[i].config)
                break
            end
        end
        
    end)
    menu.home.save:set_callback(function()
        local name = menu.home.name:get()
        if name == "" then return end
        home.save_config(name)
        ui.update(menu.home.list.ref, home.get_configs())
    end)
    menu.home.delete:set_callback(function()
        local configs = home.get_configs()
        local selected = menu.home.list:get()
        if selected == nil then return end
        local name = configs[selected + 1]
        home.delete_config(name)
    end)
    menu.enable:set(true)
    ui.update(menu.home.list.ref, home.get_configs())
end
home.update_default()

local handles = {} do
    handles.setupmenu = function(LPH_NO_VIRTUALIZE)
        for i = 1, #states do
            menu.antiaim.builder[i] = {}
            menu.antiaim.builder[i].brute = {}
            if i == 1 then
                menu.antiaim.builder[i].override = groups.main:checkbox("\v" .. states[i] .. " · \rOverride ")
                menu.antiaim.builder[i].override:set(true)
            else
                menu.antiaim.builder[i].override = groups.main:checkbox("\v" .. states[i] .. " · \rOverride ")
            end 
            menu.antiaim.builder[i].pitch = groups.main:combobox("\v" .. states[i] .. " · \rpitch \v" , {"disabled", "down", "up", "zero"})
            menu.antiaim.builder[i].yaw = groups.main:combobox("\v" .. states[i] .. " · \ryaw \v ", {"disabled", "backward", "left/right"})
            menu.antiaim.builder[i].yaw_value = groups.main:slider("\n\n\n\n\n\n\n\n",-180, 180, 0)
            menu.antiaim.builder[i].classic1 = groups.main:slider("\v" .. states[i] .. " · \r[l|r] \v ",-180, 180, 0)
            menu.antiaim.builder[i].classic2 = groups.main:slider("\n\n\n\n\n\n\n\n\n",-180, 180, 0)
            menu.antiaim.builder[i].modifier = groups.main:combobox("\v" .. states[i] .. " · \rmodifier \v ", {"off", "offset", "center", "random", "skitter", "center (skeet)", "offset (skeet)"})
            menu.antiaim.builder[i].mod_slider = groups.main:slider("\n\n\n\n\n\n\n\n\n\n", -180, 180, 0)
            menu.antiaim.builder[i].bodyyaw = groups.main:combobox("\v" .. states[i] .. " · \rbodyyaw \v ", {"off", "jitter", "left", "right", "delayed", "break", "jitter (skeet)"})
            menu.antiaim.builder[i].delay = groups.main:slider("\v" .. states[i] .. " · \rdelay \v ", 2, 64, 0, true, "t", 1)
            menu.antiaim.builder[i].defensive = groups.main:combobox("\v" .. states[i] .. " · \rdefensive \v ", {"-", "on peek", "always on"})
            menu.antiaim.builder[i].defensive_pitch = groups.main:combobox("\v" .. states[i] .. " · \rdefensive pitch \v ", {"disabled", "off", "up", "zero", "random", "custom", "switch"})
            menu.antiaim.builder[i].defensive_pitch_val = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n", -89, 89, 0, true, "°", 1)
            menu.antiaim.builder[i].defensive_pitch_val2 = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n\n", -89, 89, 0, true, "°", 1)
            menu.antiaim.builder[i].defensive_yaw = groups.main:combobox("\v" .. states[i] .. " · \rdefensive yaw \v ", {"disabled", "static","jitter","sideways", "random", "spin", "move-based"})
            menu.antiaim.builder[i].defensive_spin = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n\n\n", -60, 60, 0, true, "°", 1)
            menu.antiaim.builder[i].defensive_yaw_val = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n\n\n\n", -180, 180, 0, true, "°", 1)
            menu.antiaim.builder[i].defensive_yaw_val2 = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n\n\n\n", -180, 180, 0, true, "°", 1)
            menu.antiaim.builder[i].bruteforce = groups.main:combobox("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", phase)
            for j = 1, #phase do
                menu.antiaim.builder[i].brute[j] = {}
                menu.antiaim.builder[i].brute[j].label = groups.main:label("\venable current condition")
                menu.antiaim.builder[i].brute[j].override = groups.main:checkbox("\v" .. states[i] .. " · \renable\v".. " · " .. phase[j])
                menu.antiaim.builder[i].brute[j].pitch = groups.main:combobox("\v" .. states[i] .. " · \rpitch\v".. " · " .. phase[j], {"disabled", "down", "up", "zero"})
                menu.antiaim.builder[i].brute[j].yaw = groups.main:combobox("\v" .. states[i] .. " · \ryaw\v".. " · " .. phase[j], {"disabled", "backward", "left/right"})
                menu.antiaim.builder[i].brute[j].yaw_value = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",-180, 180, 0)
                menu.antiaim.builder[i].brute[j].classic1 = groups.main:slider("\v" .. states[i] .. " · \r[l|r]\v".. " · " .. phase[j],-180, 180, 0)
                menu.antiaim.builder[i].brute[j].classic2 = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",-180, 180, 0)
                menu.antiaim.builder[i].brute[j].modifier = groups.main:combobox("\v" .. states[i] .. " · \rmodifier\v".. " · " .. phase[j], {"off", "offset", "center", "random", "skitter"})
                menu.antiaim.builder[i].brute[j].mod_slider = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", -180, 180, 0)
                menu.antiaim.builder[i].brute[j].bodyyaw = groups.main:combobox("\v" .. states[i] .. " · \rbodyyaw\v".. " · " .. phase[j], {"off", "jitter", "left", "right", "delayed", "break"})
                menu.antiaim.builder[i].brute[j].delay = groups.main:slider("\v" .. states[i] .. " · \rdelay\v".. " · " .. phase[j], 2, 64, 0, true, "t", 1)
                menu.antiaim.builder[i].brute[j].defensive = groups.main:combobox("\v" .. states[i] .. " · \rdefensive\v".. " · " .. phase[j], {"-", "on peek", "always on"})
                menu.antiaim.builder[i].brute[j].defensive_pitch = groups.main:combobox("\v" .. states[i] .. " · \rdefensive pitch\v".. " · " .. phase[j], {"disabled", "off", "up", "zero", "random", "custom", "switch"})
                menu.antiaim.builder[i].brute[j].defensive_pitch_val = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", -89, 89, 0, true, "°", 1)
                menu.antiaim.builder[i].brute[j].defensive_pitch_val2 = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n", -89, 89, 0, true, "°", 1)
                menu.antiaim.builder[i].brute[j].defensive_yaw = groups.main:combobox("\v" .. states[i] .. " · \rdefensive yaw\v".. " · " .. phase[j], {"disabled", "static","jitter","sideways", "random", "spin", "move-based"})
                menu.antiaim.builder[i].brute[j].defensive_spin = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", -60, 60, 0, true, "°", 1)
                menu.antiaim.builder[i].brute[j].defensive_yaw_val = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", -180, 180, 0, true, "°", 1)
                menu.antiaim.builder[i].brute[j].defensive_yaw_val2 = groups.main:slider("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", -180, 180, 0, true, "°", 1)
                
                menu.antiaim.builder[i].brute[j].test_time = groups.main:slider("testing time", 0, 10, 0, true, "s", 1)
                menu.antiaim.builder[i].brute[j].test_settings = groups.main:button("Test current Settings", function() temp.brutetime = globals.tickcount() + menu.antiaim.builder[i].brute[j].test_time:get() * 64 temp.brutephase = j temp.state = i end)
            end
        end
        for i = 1, #states do
            if i == 1 then
                menu.antiaim.builder[i].override:depend({menu.tab, 7})
            else
                menu.antiaim.builder[i].override:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.tab, 0})
            end
            menu.antiaim.builder[i].pitch:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].yaw:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].yaw_value:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].yaw, "backward"}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].classic1:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].yaw, "left/right", "experimental"}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].classic2:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].yaw, "left/right", "experimental"}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
    
            menu.antiaim.builder[i].modifier:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].mod_slider:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].modifier, "off", true}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].bodyyaw:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].delay:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0}, {menu.antiaim.builder[i].bodyyaw, "delayed", "break"})
            --menu.antiaim.builder[i].bod_slider:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].bodyyaw, "jitter", "static"}, {menu.antiaim.builder[i].override, true})
            menu.antiaim.builder[i].defensive:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].defensive_pitch:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.builder[i].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].defensive_pitch_val:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.builder[i].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].defensive_pitch, "custom", "switch"}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].defensive_pitch_val2:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true},  {menu.antiaim.builder[i].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].defensive_pitch, "switch"}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].defensive_yaw:depend({menu.enable, true}, {menu.tab, 2},{menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true},  {menu.antiaim.builder[i].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].override, true},{menu.antiaim.tab, 0})
            menu.antiaim.builder[i].defensive_yaw_val:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true},  {menu.antiaim.builder[i].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].defensive_yaw, "static", "sideways","jitter"}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].defensive_yaw_val2:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.builder[i].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].defensive_yaw, "jitter"}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].defensive_spin:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true},  {menu.antiaim.builder[i].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].defensive_yaw, "spin"}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 0})
            menu.antiaim.builder[i].bruteforce:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 1})
            for j = 1, #phase do
                menu.antiaim.builder[i].brute[j].label:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, false}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].override:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].pitch:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].yaw:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].yaw_value:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].yaw, "backward"}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].classic1:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].yaw, "left/right", "experimental"}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].classic2:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].yaw, "left/right", "experimental"}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
    
                menu.antiaim.builder[i].brute[j].modifier:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].mod_slider:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].modifier, "off", true}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].bodyyaw:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].delay:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].brute[j].bodyyaw, "delayed", "break"}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                --menu.antiaim.builder[i].bod_slider:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].bodyyaw, "jitter", "static"}, {menu.antiaim.builder[i].override, true})
                menu.antiaim.builder[i].brute[j].defensive:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].defensive_pitch:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.builder[i].brute[j].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].defensive_pitch_val:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.builder[i].brute[j].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].brute[j].defensive_pitch, "custom", "switch"}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].defensive_pitch_val2:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true},  {menu.antiaim.builder[i].brute[j].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].brute[j].defensive_pitch, "switch"}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].defensive_yaw:depend({menu.enable, true}, {menu.tab, 2},{menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true},  {menu.antiaim.builder[i].brute[j].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].brute[j].override, true},{menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].defensive_spin:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true},  {menu.antiaim.builder[i].brute[j].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].brute[j].defensive_yaw, "spin"}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].defensive_yaw_val2:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.builder[i].brute[j].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].brute[j].defensive_yaw, "jitter"}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].defensive_yaw_val:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true},  {menu.antiaim.builder[i].brute[j].defensive, "on peek", "always on"}, {menu.antiaim.builder[i].brute[j].defensive_yaw, "static", "sideways","jitter"}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].test_settings:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
                menu.antiaim.builder[i].brute[j].test_time:depend({menu.enable, true}, {menu.tab, 2}, {menu.antiaim.condition, states[i]}, {menu.antiaim.builder[i].brute[j].override, true}, {menu.antiaim.tab, 1}, {menu.antiaim.builder[i].bruteforce , phase[j]})
            end
        end
        menu.tab:depend({menu.enable, true})
        menu.sliderspacing:depend({menu.enable, true}, {menu.tab, function()
            return menu.tab.value == 3 or menu.tab.value == 6
        end})

        --home
        menu.home.air1:depend({menu.enable, true}, {menu.tab, 1})
        menu.home.welcome:depend({menu.enable, true}, {menu.tab, 1})
        menu.home.user:depend({menu.enable, true}, {menu.tab, 1})
        menu.home.air:depend({menu.enable, true}, {menu.tab, 1})
        menu.home.list:depend({menu.enable, true}, {menu.tab, 1})
        menu.home.name:depend({menu.enable, true}, {menu.tab, 1})
        menu.home.load:depend({menu.enable, true}, {menu.tab, 1})
        menu.home.save:depend({menu.enable, true}, {menu.tab, 1})
        menu.home.delete:depend({menu.enable, true}, {menu.tab, 1})
        menu.home.export:depend({menu.enable, true}, {menu.tab, 1})
        menu.home.import:depend({menu.enable, true}, {menu.tab, 1})
        --antiaim
        menu.antiaim.tab:depend({menu.enable, true}, {menu.tab, 2})
        menu.main.tab:depend({menu.enable, true}, {menu.tab, 5})
        -- menu.antiaim.air1:depend({menu.enable, true}, {menu.tab, 2})
        menu.antiaim.condition:depend({menu.enable, true}, {menu.tab, 2},{menu.antiaim.tab, function()
            return menu.antiaim.tab.value == 0 or menu.antiaim.tab.value == 1
        end})
        --keys
        menu.antiaim.hotkeys.freestand:depend({menu.enable, true}, {menu.tab, 2},{menu.antiaim.tab, 2})
        menu.antiaim.hotkeys.edge_yaw:depend({menu.enable, true}, {menu.tab, 2},{menu.antiaim.tab, 2})
        menu.antiaim.hotkeys.left:depend({menu.enable, true}, {menu.tab, 2},{menu.antiaim.tab, 2})
        menu.antiaim.hotkeys.right:depend({menu.enable, true}, {menu.tab, 2},{menu.antiaim.tab, 2})
        menu.antiaim.hotkeys.forward:depend({menu.enable, true}, {menu.tab, 2},{menu.antiaim.tab, 2})
        menu.antiaim.hotkeys.reset:depend({menu.enable, true}, {menu.tab, 2},{menu.antiaim.tab, 2})
        --rage
        menu.rage.resolver:depend({menu.enable, true}, {menu.tab, 3})
        menu.rage.label2:depend({menu.enable, true}, {menu.tab, 7}, {menu.rage.resolver, true})
        menu.rage.player:depend({menu.enable, true}, {menu.tab, 7}, {menu.rage.status, 0}, {menu.rage.resolver, true})
        menu.rage.playername:depend({menu.enable, true}, {menu.tab, 7}, {menu.rage.resolver, true})
        menu.rage.disclaimer:depend({menu.enable, true}, {menu.tab, 7}, {menu.rage.status, 0}, {menu.rage.resolver, true})
        menu.rage.update:depend({menu.enable, true}, {menu.tab, 7}, {menu.rage.status, 0}, {menu.rage.resolver, true})
        menu.rage.condition:depend({menu.enable, true}, {menu.tab, 7}, {menu.rage.status, 0}, {menu.rage.resolver, true})
        menu.rage.steal:depend({menu.enable, true}, {menu.tab, 7}, {menu.rage.status, 0}, {menu.rage.resolver, true})
        menu.rage.status:depend({menu.enable, true}, {menu.tab, 7})
        menu.rage.label3:depend({menu.enable, true}, {menu.tab, 7})
        menu.rage.confirm:depend({menu.enable, true}, {menu.tab, 7}, {menu.rage.status, 1}, {menu.rage.resolver, true})
        menu.rage.cancel:depend({menu.enable, true}, {menu.tab, 7}, {menu.rage.status, 1}, {menu.rage.resolver, true})
        --menu.rage.status:set(0)

        --screen
        menu.visuals.tab:depend({menu.enable, true}, {menu.tab, 4})
        menu.visuals.crosshair:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 0})
        menu.visuals.desync:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.crosshair, "pixel"}, {menu.visuals.tab, 0})
        menu.visuals.modifiers:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.crosshair, "none", true}, {menu.visuals.tab, 0})
        menu.visuals.watermark:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 0})
        menu.visuals.arrows:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 0})
        -- menu.visuals.spacing2:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 0})
        menu.visuals.velocity:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 0})
        menu.visuals.defensive:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 0})
        menu.visuals.dmg:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 0})
        menu.visuals.dmg_m:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.dmg, true}, {menu.visuals.tab, 0})
        menu.visuals.spacing:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 1})
        menu.visuals.person:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 1}) menu.visuals.person:set_callback(callbacks.thirdperson)
        menu.visuals.aspect:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 1}) menu.visuals.aspect:set_callback(callbacks.aspect)
        --player
        menu.visuals.on_ground:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 1})
        menu.visuals.in_air:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 1})
        menu.visuals.movelean:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 1})
        menu.visuals.moveleanslider:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 1}, {menu.visuals.movelean, true})
        menu.visuals.perfect:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 1})
        menu.visuals.perfect_slider:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 1}, {menu.visuals.perfect, true})
        menu.visuals.always90:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 1})
        menu.visuals.pitch0:depend({menu.enable, true}, {menu.tab, 4}, {menu.visuals.tab, 1})

        menu.main.clantag:depend({menu.enable, true}, {menu.tab, 5}, {menu.main.tab, 0})
        menu.main.killsay:depend({menu.enable, true}, {menu.tab, 5}, {menu.main.tab, 0})
        menu.main.logs:depend({menu.enable, true}, {menu.tab, 5}, {menu.main.tab, 0})
        menu.main.console:depend({menu.enable, true}, {menu.tab, 5}, {menu.main.tab, 0}) menu.visuals.aspect:set_callback(callbacks.console_filter)
        -- menu.main.air:depend({menu.enable, true}, {menu.tab, 5})
        menu.main.ladder:depend({menu.enable, true}, {menu.tab, 5}, {menu.main.tab, 1})
        menu.main.ladder_pitch:depend({menu.enable, true}, {menu.tab, 5}, {menu.main.tab, 1}, {menu.main.ladder, true})
        menu.main.ladder_yaw:depend({menu.enable, true}, {menu.tab, 5}, {menu.main.tab, 1}, {menu.main.ladder, true})
        menu.main.safehead:depend({menu.enable, true}, {menu.tab, 5}, {menu.main.tab, 1})
        menu.main.antistab:depend({menu.enable, true}, {menu.tab, 5}, {menu.main.tab, 1})
        menu.main.bombfix:depend({menu.enable, true}, {menu.tab, 5}, {menu.main.tab, 1})
        -- menu.main.air2:depend({menu.enable, true}, {menu.tab, 5})


        
        menu.premium.killsay:depend({menu.enable, true}, {menu.tab, 6})
        menu.premium.user:depend({menu.enable, true}, {menu.tab, 6})
        menu.premium.set:depend({menu.enable, true}, {menu.tab, 6})
        menu.premium.clientlabel:depend({menu.enable, true}, {menu.tab, 6})
        menu.premium.debuglabel:depend({menu.enable, true}, {menu.tab, 6})
        menu.premium.debugtoggle:depend({menu.enable, true}, {menu.tab, 6})

    end

    handles.gmb = function(active, item)
        if not ui.is_menu_open() then return end
        local trigger = false
        if item == true then
            trigger = false
        else
            trigger = true
        end
        if active == true then
            ui.set_visible(ref.aa_enabled, trigger)
            ui.set_visible(ref.pitch[1], trigger)
            ui.set_visible(ref.pitch[2], trigger and ui.get(ref.pitch[1]) == "custom" or false)
            ui.set_visible(ref.yaw_base, trigger)
            ui.set_visible(ref.yaw[1], trigger)
            ui.set_visible(ref.yaw[2], trigger and ui.get(ref.yaw[1]) ~= "off" or false)
            ui.set_visible(ref.yaw_jitter[1], trigger)
            ui.set_visible(ref.yaw_jitter[2], trigger and ui.get(ref.yaw_jitter[1]) ~= "off" or false)
            ui.set_visible(ref.body_yaw[1], trigger)
            ui.set_visible(ref.body_yaw[2], trigger and (ui.get(ref.body_yaw[1]) ~= "off" and ui.get(ref.body_yaw[1]) ~= "opposite") or false)
            ui.set_visible(ref.freestanding_body_yaw, trigger)
            ui.set_visible(ref.edge_yaw, trigger)
            ui.set_visible(ref.freestanding[1], trigger)
            ui.set_visible(ref.freestanding[2], trigger)
            ui.set_visible(ref.roll, trigger)
        else
            ui.set_visible(ref.aa_enabled, true)
            ui.set_visible(ref.pitch[1], true)
            ui.set_visible(ref.pitch[2], true)
            ui.set_visible(ref.yaw_base, true)
            ui.set_visible(ref.yaw[1], true)
            ui.set_visible(ref.yaw[2], true)
            ui.set_visible(ref.yaw_jitter[1], true)
            ui.set_visible(ref.yaw_jitter[2], true)
            ui.set_visible(ref.body_yaw[1], true)
            ui.set_visible(ref.body_yaw[2], true)
            ui.set_visible(ref.freestanding_body_yaw, true)
            ui.set_visible(ref.edge_yaw, true)
            ui.set_visible(ref.freestanding[1], true)
            ui.set_visible(ref.freestanding[2], true)
            ui.set_visible(ref.roll, true)
        end
    end
end



local defensive = {} do 
    defensive.defensive_active = false 
    defensive.currently_active = false
    defensive.db = {}
    defensive.is_active = function(self, player, mode)
        if not mode then
            mode = false
        end
        
        if not player then return end

        local idx = entity.get_steam64(player)
        local tickcount = globals.tickcount()
        local sim_time = toticks(entity.get_prop(player, "m_flSimulationTime"))

        self.db[idx] = self.db[idx] and self.db[idx] or {last_sim_time = 0, defensive_until = 0}

        if self.db[idx].last_sim_time == 0 then
            self.db[idx].last_sim_time = sim_time
            return false
        end

        local sim_diff = sim_time - self.db[idx].last_sim_time

        if sim_diff < 0 then
            self.db[idx].defensive_until = globals.tickcount() + math.abs(sim_diff) - toticks(client.latency())
        end
        
        self.db[idx].last_sim_time = sim_time

        local ret = {
            tick = self.db[idx].defensive_until,
            active = self.db[idx].defensive_until > globals.tickcount(),
        }

        return mode and ret or self.db[idx].defensive_until > globals.tickcount()
    end
end

local antiaim = {} do 
    antiaim.current_state = ""
    antiaim.current_state_number = 0
    antiaim.current_phase = 0
    antiaim.allow_defensive = false
    antiaim.defensive_yaw = 0
    antiaim.is_on_ground = false
    antiaim.delay = 0
    antiaim.delayside = false
    antiaim.delaysideold = false
    antiaim.current_tickcount = 0
    antiaim.spin_angle = 0
    antiaim.olddt = false
    antiaim.forceupdate = false
    antiaim.brute = {}
    antiaim.brute_trigger = false
    antiaim.brute_test = 0
    antiaim.brute_activetime = 0
    antiaim.oldstate = 0
    antiaim.command_number_delta = 0
    antiaim.command_number_delta_old = 0
    antiaim.side1 = "reset"
    antiaim.oldside = false
    antiaim.closest_point_on_ray = function(ray_from, ray_to, desired_point)
        local to = desired_point - ray_from
        local direction = ray_to - ray_from
        local ray_length = #direction
        direction.x = direction.x / ray_length
        direction.y = direction.y / ray_length
        direction.z = direction.z / ray_length
        local direction_along = direction.x * to.x + direction.y * to.y + direction.z * to.z
        if direction_along < 0 then
            return ray_from
        end
        if direction_along > ray_length then
            return ray_to
        end
        return vector(
            ray_from.x + direction.x * direction_along,
            ray_from.y + direction.y * direction_along,
            ray_from.z + direction.z * direction_along
        )
    end
    antiaim.update = function(self, ctx)
        local local_player = entity.get_local_player()
        if not entity.is_alive(local_player) or not local_player then return end
        local xv, yv = entity.get_prop(local_player, "m_vecVelocity")
        local flags = entity.get_prop(local_player, "m_fFlags")
        local slow_walk = ui.get(ref.slow_motion[1]) and ui.get(ref.slow_motion[2])
        local ducking = bit.lshift(1, 1)
        local ground = bit.lshift(1, 0)
        local velocity = math.sqrt(xv*xv + yv*yv)
        local fakeduck =  ui.get(ref.duck_peek_assist)
        local doubletap = ui.get(ref.double_tap[1]) and ui.get(ref.double_tap[2])
        local hideshots = ui.get(ref.onshot_aa[1]) and ui.get(ref.onshot_aa[2])
        local fs_active, key = menu.antiaim.hotkeys.freestand:get_hotkey()
        antiaim.is_on_ground = (ctx.in_jump == 0)
        local state = function()
            if bit.band(flags, ground) == 1 and velocity < 3 and bit.band(flags, ducking) == 0 then
                self.current_state = "Stand"
                self.current_state_number = 2
            else
                if  bit.band(flags, ground) == 1 and velocity > 3 and bit.band(flags, ducking)  == 0 and slow_walk then
                    self.current_state = "Slow-Walk"
                    self.current_state_number = 3
                end
            end
            if bit.band(flags, ground) == 1 and velocity > 3 and bit.band(flags, ducking) == 0 and not slow_walk and (ctx.in_jump == 0) then
                self.current_state = "Moving"
                self.current_state_number = 4
            end
            if bit.band(flags, ground) == 1 and bit.band(flags, ducking) > 0.9 and menu.antiaim.builder[6].override:get() and velocity > 10 and (ctx.in_jump == 0 )then
                self.current_state = "Duck-Move"
                self.current_state_number = 6
            elseif bit.band(flags, ground) == 1 and bit.band(flags, ducking) > 0.9 and (ctx.in_jump == 0 ) then
                self.current_state = "DUCK"
                self.current_state_number = 5
            end
            if bit.band(flags, ground) == 0 and bit.band(flags, ducking) == 0 then
                self.current_state = "Air"
                self.current_state_number = 7
            end
            if bit.band(flags, ground) == 0 and bit.band(flags, ducking) > 0.9 then
                self.current_state = "Air+D"
                self.current_state_number = 8
            end
        end
        state()
    end
    antiaim.bullet = function(self,e)
        local lplr = entity.get_local_player()
        if not lplr or not entity.is_alive(lplr) then return end
        local owner = client.userid_to_entindex(e.userid)
        if owner == lplr then return end
        if owner ~= nil and entity.is_dormant(owner) then return end
        local currentstate = menu.antiaim.builder[antiaim.current_state_number].override:get() and self.current_state_number or 1

        local x, y, z = entity.get_prop(owner, "m_vecAbsOrigin")
        

        local shotstart = vector(x, y, z + 64)
        local shotend = vector(e.x, e.y, e.z)
        local eyepos = vector(client.eye_position())


        local closestpoint = antiaim.closest_point_on_ray(shotstart, shotend, eyepos)
        if closestpoint == nil then return end

        if eyepos:dist(closestpoint) < 40 then
            antiaim.brute[currentstate].phase = antiaim.brute[currentstate].phase + 1
            if antiaim.brute[currentstate].phase > 5 then antiaim.brute[currentstate].phase = 0 end
            if menu.main.logs:get("debug") and menu.antiaim.builder[currentstate].brute[antiaim.brute[currentstate].phase > 6 and antiaim.brute[currentstate].phase or 1 ].override:get() then
                print("Updated State " .. self.current_state .. " to " .. self.current_state .. " " .. phase[antiaim.brute[currentstate].phase])
            end
        end
    end
    antiaim.handler = function(self, ctx)
        local local_player = entity.get_local_player()
        if not entity.is_alive(local_player) or not local_player then 
            return 
        end
        self.command_number_delta = ctx.command_number - globals.tickcount()
        --state
        local currentstate = menu.antiaim.builder[antiaim.current_state_number].override:get() and (self.current_state_number and self.current_state_number or 1) or 1

        antiaim.brute[currentstate] = antiaim.brute[currentstate] and antiaim.brute[currentstate] or {}
        antiaim.brute[currentstate].phase = antiaim.brute[currentstate].phase and antiaim.brute[currentstate].phase or 0
        if antiaim.brute[currentstate].phase > 5 then 
            antiaim.brute[currentstate].phase = 0
            antiaim.trigger_brute = false
        end

        if antiaim.brute[currentstate].phase ~= 0 and antiaim.brute[currentstate].phase < 6 then
            if not menu.antiaim.builder[currentstate].brute[antiaim.brute[currentstate].phase].override:get() then
                antiaim.brute[currentstate].phase = antiaim.brute[currentstate].phase + 1
                antiaim.trigger_brute = false
            else 
                antiaim.trigger_brute = true
            end
        end
        local state = antiaim.trigger_brute and menu.antiaim.builder[currentstate].brute[antiaim.brute[currentstate].phase] or menu.antiaim.builder[currentstate]

        if temp.brutetime and temp.brutetime > globals.tickcount() and temp.state == currentstate then
            state = menu.antiaim.builder[currentstate].brute[temp.brutephase]
        end

        --builder
        local yaw = 0
        local bodyyaw = math.max(-60,math.min(60, math.floor((entity.get_prop(local_player,"m_flPoseParameter", 11) or 0)*120-60)))
        local side = bodyyaw >= 0 and true or false
        --binds
        local fakeduck = ui.get(ref.duck_peek_assist)
        local fs_active, key = menu.antiaim.hotkeys.freestand:get_hotkey()
        local tmp = 0x00
        local doubletap = ui.get(ref.double_tap[1]) and ui.get(ref.double_tap[2])
        local hideshots = ui.get(ref.onshot_aa[1]) and ui.get(ref.onshot_aa[2])
        local tickbase = (doubletap or hideshots) and not fakeduck
        local lc = tickbase ~= self.olddt and tickbase == false
        --rest
        local number = entity.get_player_weapon(local_player)
        local my_weapon = entity.get_classname(number)


        self.forceupdate = false

        
        if state.pitch:get() == "off" then
            ui.set(ref.pitch[1], "off")
        elseif state.pitch:get() == "down" then
            ui.set(ref.pitch[1], "minimal")
        elseif state.pitch:get() == "up" then
            ui.set(ref.pitch[1], "up")
        elseif state.pitch:get() == "zero" then
            ui.set(ref.pitch[1], "custom")
            ui.set(ref.pitch[2], 0)
        end
        if state.bodyyaw:get() == "jitter" then
            if lc then
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], side and -1 or 1)
                self.forceupdate = true
            elseif ctx.chokedcommands == 0 then
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], side and -1 or 1)
                self.forceupdate = true
            end
        elseif state.bodyyaw:get() == "break" then
            if lc or (defensiveold == true and defensive.currently_active == false) then
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], bodyyaw >= 0 and -1 or 1)
                self.forceupdate = true
            elseif globals.tickcount() % state.delay:get() * 2 < state.delay:get() then
                if ctx.chokedcommands == 0 then
                    ui.set(ref.body_yaw[1], "static")
                    ui.set(ref.body_yaw[2], bodyyaw >= 0 and -1 or 1)
                    self.forceupdate = true
                end
            end
        elseif state.bodyyaw:get() == "delayed" then
            if lc or (defensiveold == true and defensive.currently_active == false) then
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], bodyyaw >= 0 and -1 or 1)
                self.forceupdate = true
            elseif tickbase then
                if globals.tickcount() > antiaim.current_tickcount + state.delay:get() then
                    if ctx.chokedcommands == 0 then
                        antiaim.delayside = not antiaim.delayside
                        antiaim.current_tickcount = globals.tickcount()
                    end
                elseif globals.tickcount() < antiaim.current_tickcount then
                    antiaim.current_tickcount = globals.tickcount()
                end
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], antiaim.delayside and -1 or 1)
                self.forceupdate = true
            else
                if ctx.chokedcommands == 0 then
                    ui.set(ref.body_yaw[1], "static")
                    ui.set(ref.body_yaw[2], bodyyaw >= 0 and -1 or 1)
                    self.forceupdate = true
                end
            end
        elseif state.bodyyaw:get() == "jitter (skeet)" then
            ui.set(ref.body_yaw[1], "jitter")
            ui.set(ref.body_yaw[2], -1)
            self.forceupdate = true
        elseif state.bodyyaw:get() == "left" then
            ui.set(ref.body_yaw[1], "static")
            ui.set(ref.body_yaw[2], -1)
            self.forceupdate = true
        elseif state.bodyyaw:get() == "right" then
            ui.set(ref.body_yaw[1], "static")
            ui.set(ref.body_yaw[2], 1)
            self.forceupdate = true
        else
            ui.set(ref.body_yaw[1], "static")
            ui.set(ref.body_yaw[2], 0)
            self.forceupdate = true
        end
        
        -- if antiaim.oldstate ~= currentstate then
        --     self.forceupdate = true
        -- end

        

        if state.yaw:get() == "off" then
            ui.set(ref.yaw[1], "off")
        elseif state.yaw:get() == "backward" then
            yaw = state.yaw_value:get()
            ui.set(ref.yaw[1], "180")
        elseif state.yaw:get() == "left/right" then
            yaw = (side and state.classic1:get() or state.classic2:get())
            ui.set(ref.yaw[1], "180")
        end

        local jitterstate = globals.tickcount() % 4 < 2

        ui.set(ref.yaw_jitter[1], "off")
        ui.set(ref.yaw_jitter[2], 0)

        if state.modifier:get() == "center" then
            if side then
                yaw = yaw - state.mod_slider:get() / 2
            else
                yaw = yaw + state.mod_slider:get() / 2
            end
        elseif state.modifier:get() == "offset" then
            if not side then
                yaw = yaw + state.mod_slider:get()
            end
        elseif state.modifier:get() == "center (skeet)" then
            ui.set(ref.yaw_jitter[1], "Center")
            ui.set(ref.yaw_jitter[2], state.mod_slider:get())
        elseif state.modifier:get() == "offset (skeet)" then
            ui.set(ref.yaw_jitter[1], "Offset")
            ui.set(ref.yaw_jitter[2], state.mod_slider:get())
        else
            ui.set(ref.yaw_jitter[1], state.modifier:get())
            ui.set(ref.yaw_jitter[2], state.mod_slider:get())
        end


        ui.set(ref.freestanding[1], menu.antiaim.hotkeys.freestand:get()) 
        ui.set(ref.freestanding[2], fs_active and "Always on" or "On hotkey")
        ui.set(ref.edge_yaw, menu.antiaim.hotkeys.edge_yaw:get_hotkey() and menu.antiaim.hotkeys.edge_yaw:get())


        if ctx.chokedcommands > 1 then return end
        
        if state.defensive:get() == "always on" and not (side1 == "forward" or side1 == "left" or side1 == "right") then
            ctx.force_defensive = true
        end
        local defensive_active = (defensive.currently_active) and not (state.defensive:get() == "-") and ((hideshots or doubletap) and not fakeduck)
        if defensive_active ~= defensiveold and defensive_active then
            pitchswitch = not pitchswitch
        end
        if defensive_active then
            
            if state.defensive_pitch:get() == "custom" then
                ui.set(ref.pitch[1], "custom")
                ui.set(ref.pitch[2], state.defensive_pitch_val:get())
            elseif state.defensive_pitch:get() == "zero" then
                ui.set(ref.pitch[1], "custom")
                ui.set(ref.pitch[2], 0)
            elseif state.defensive_pitch:get() == "switch" then
                ui.set(ref.pitch[1], "custom")
                ui.set(ref.pitch[2], pitchswitch and state.defensive_pitch_val:get() or state.defensive_pitch_val2:get())
            elseif state.defensive_pitch:get() ~= "disabled" then
                ui.set(ref.pitch[1], state.defensive_pitch:get())
            end
            if state.defensive_yaw:get() == "static" then
                ui.set(ref.yaw_jitter[1], "off")
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], 0)
                ctx.no_choke = true
                self.defensive_yaw = state.defensive_yaw_val:get()
            elseif state.defensive_yaw:get() == "sideways" then
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], 0)
                self.defensive_yaw = globals.tickcount() % 6 > 3 and state.defensive_yaw_val:get() or -state.defensive_yaw_val:get()
                ctx.no_choke = true
            elseif state.defensive_yaw:get() == "random" then
                ui.set(ref.yaw[2], 0)
                ui.set(ref.yaw_jitter[1], "random")
                ui.set(ref.yaw_jitter[2], -180)
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], 0)
                ctx.no_choke = true
            elseif state.defensive_yaw:get() == "move-based" then
                self.defensive_yaw = ctx.sidemove == 0 and 180 or (ctx.sidemove > 0 and 90 or -90)
                ui.set(ref.yaw_jitter[1], "random")
                ui.set(ref.yaw_jitter[2], -90)
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], 0)
                ctx.no_choke = true
            elseif state.defensive_yaw:get() == "spin" then
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], 0)
                self.defensive_yaw = self.defensive_yaw + state.defensive_spin:get()
                if self.defensive_yaw > 180 then
                    self.defensive_yaw = -180
                end
                if self.defensive_yaw < -180 then
                    self.defensive_yaw = 180
                end
                -- print(bodyyaw)
                -- if bodyyaw < 5 and bodyyaw > -5 then
                --     self.defensive_yaw =  self.defensive_yaw + state.defensive_spin:get()
                -- end
                -- if self.defensive_yaw > 180 then
                --     self.defensive_yaw = -180
                -- end
                -- if self.defensive_yaw < -180 then
                --     self.defensive_yaw = 180
                -- end
                ui.set(ref.yaw_jitter[1], "off")
                ctx.no_choke = true
            elseif state.defensive_yaw:get() == "jitter" then
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2],0)
                ui.set(ref.yaw_jitter[1], "off")
                self.defensive_yaw = globals.tickcount() % 6 > 3 and state.defensive_yaw_val:get() or state.defensive_yaw_val2:get()
                ctx.no_choke = true
            else
                self.defensive_yaw = yaw
            end
        end
        if defensive_active then
            if state.defensive_yaw:get() ~= "disabled" then
                ui.set(ref.yaw[2], clamp(self.defensive_yaw, -180, 180))
            else
                if self.forceupdate == true then
                    ui.set(ref.yaw[2], clamp(self.defensive_yaw, -180, 180))
                end
            end
        elseif tickbase then
            if self.forceupdate == true then
                ui.set(ref.yaw[2], clamp(yaw, -180, 180))
            end
        elseif not tickbase then
            if self.forceupdate == true then
                ui.set(ref.yaw[2], clamp(yaw, -180, 180))
            end
        end
        

        antiaim.oldstate = currentstate
        self.olddt = tickbase
        defensiveold = defensive.currently_active
    end
    antiaim.bombsite_fix = function(cmd)
        local lplr = entity.get_local_player()
        if lplr == nil and not entity.is_alive(lplr) then return end    
        local bombsite, tmp4 = menu.main.bombfix:get_hotkey()
        local number = entity.get_player_weapon(lplr)
        local my_weapon = entity.get_classname(number) --we fix this shitcode later :D -- yes -Swify
        local inbombzone = entity.get_prop(lplr, "m_bInBombZone")
        local team_num = entity.get_prop(lplr, "m_iTeamNum")
        
        local holdbomb = my_weapon == "CC4"
        if menu.main.bombfix:get() and team_num == 2 and inbombzone == 1 and not holdbomb then
            cmd.in_use = false
            if bombsite then
                ui.set(ref.aa_enabled, false)
            else
                ui.set(ref.aa_enabled, true)
            end
        else
            ui.set(ref.aa_enabled, true)
        end
    end
    antiaim.manuals = function(self, LPH_NO_VIRTUALIZE)
        local local_player = entity.get_local_player()
        if not entity.is_alive(local_player) or not local_player then return end
        if menu.antiaim.hotkeys.left:get_hotkey() and menu.antiaim.hotkeys.left:get() then 
            local bind, key = menu.antiaim.hotkeys.left:get_hotkey()
            if self.oldside ~= bind then
                if self.side1 == "left" then 
                    self.side1 = "reset"
                else
                    self.side1 = "left"
                end
            end
            self.oldside = menu.antiaim.hotkeys.left:get()
        elseif menu.antiaim.hotkeys.right:get_hotkey() and menu.antiaim.hotkeys.right:get() then 
            local bind, key = menu.antiaim.hotkeys.right:get_hotkey()
            if self.oldside ~= bind then
                if self.side1 == "right" then 
                    self.side1 = "reset"
                else
                    self.side1 = "right"
                end
            end
            self.oldside = menu.antiaim.hotkeys.right:get()
        elseif menu.antiaim.hotkeys.forward:get_hotkey() and menu.antiaim.hotkeys.forward:get() then 
            local bind, key = menu.antiaim.hotkeys.forward:get_hotkey()
            if self.oldside ~= bind then
                if self.side1 == "forward" then 
                    self.side1 = "reset"
                else
                    self.side1 = "forward"
                end
            end
            antiaim.oldside = menu.antiaim.hotkeys.forward:get()
        elseif menu.antiaim.hotkeys.reset:get_hotkey() and menu.antiaim.hotkeys.reset:get() then 
            self.side1 = "reset"
        else
            self.oldside = false
        end
        if self.side1 == "left" then 
            ui.set(ref.yaw[1], "180")
            ui.set(ref.yaw[2], -90)
            ui.set(ref.body_yaw[1], "static")
            ui.set(ref.body_yaw[2], 0)
            ui.set(ref.yaw_jitter[1], "off")
        elseif self.side1 == "right" then
            ui.set(ref.yaw[1], "180")
            ui.set(ref.yaw[2], 90)
            ui.set(ref.body_yaw[1], "static")
            ui.set(ref.body_yaw[2], 0)
            ui.set(ref.yaw_jitter[1], "off")
        elseif self.side1 == "forward" then
            ui.set(ref.yaw[1], "180")
            ui.set(ref.yaw[2], 180)
            ui.set(ref.body_yaw[1], "static")
            ui.set(ref.body_yaw[2], 0)
            ui.set(ref.yaw_jitter[1], "off")
        elseif self.side1 == "reset" then end
    end
    antiaim.safe_head = function(self, LPH_NO_VIRTUALIZE)
        local local_player = entity.get_local_player()
        if not entity.is_alive(local_player) or not local_player then return end
        local enemy = client.current_threat()
        local lp_x, lp_y, lp_z = entity.hitbox_position(local_player, 7)
        local number = entity.get_player_weapon(local_player)
        local number2 = entity.get_player_weapon(enemy)
        local t_x, t_y, t_z = 0,0,0
        local my_weapon = entity.get_classname(number)
        local his_weapon = entity.get_classname(number2)
        local distance = 0
        if enemy ~= nil then
            t_x, t_y, t_z = entity.hitbox_position(enemy, 7)
    
            distance = tools.distance(lp_x, lp_y, lp_z, t_x, t_y, t_z)
        else
            distance = 301
            t_x, t_y, t_z = t_x, t_y, t_z
        end
        
        if (antiaim.current_state_number == 8) then
            if menu.main.safehead:get("knife") and my_weapon == "CKnife" then
                ui.set(ref.pitch[1], "Minimal")
                ui.set(ref.yaw[1], "180")
                ui.set(ref.yaw[2], 0)
                ui.set(ref.yaw_jitter[1], "off")
                ui.set(ref.yaw_jitter[2], 0)
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], 0)
            end
            if menu.main.safehead:get("zeus") and  my_weapon == "CWeaponTaser" then
                ui.set(ref.pitch[1], "Minimal")
                ui.set(ref.yaw[1], "180")
                ui.set(ref.yaw[2], 0)
                ui.set(ref.yaw_jitter[1], "off")
                ui.set(ref.yaw_jitter[2], 0)
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], 0)
            end
        end
        if (antiaim.current_state_number == 5 or antiaim.current_state_number == 6) then
            if menu.main.safehead:get("above enemy") and lp_z - t_z > 50 and enemy ~= nil then
                ui.set(ref.pitch[1], "Minimal")
                ui.set(ref.yaw[1], "180")
                ui.set(ref.yaw[2], 5)
                ui.set(ref.yaw_jitter[1], "off")
                ui.set(ref.yaw_jitter[2], 0)    
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], 0)
            end
        elseif (antiaim.current_state_number == 7 or antiaim.current_state_number == 8) then
            if menu.main.safehead:get("above enemy") and lp_z - t_z > 130 and enemy ~= nil then
                ui.set(ref.pitch[1], "Minimal")
                ui.set(ref.yaw[1], "180")
                ui.set(ref.yaw[2], 0)
                ui.set(ref.yaw_jitter[1], "off")
                ui.set(ref.yaw_jitter[2], 0)
                ui.set(ref.body_yaw[1], "static")
                ui.set(ref.body_yaw[2], 0)
            end
        end
    end
    antiaim.get_vector_origin = function(idx)
        local v1, v2, v3 = entity.get_origin(idx)
        return {
            x = v1, y = v2, z = v3
        }
    end
    antiaim.yawto360 = function(yawbruto)
        if yawbruto < 0 then
            return 360 + yawbruto;
        end
    
        return yawbruto;
    end
    antiaim.yawto180 = function(yawbruto)
        if yawbruto > 180 then
            return yawbruto - 360;
        end
    
        return yawbruto;
    end
    antiaim.yaw_to_player = function(player, forward)
        local LocalPlayer = entity.get_local_player()
        if not LocalPlayer or not player then return 0 end
    
        local lOrigin = antiaim.get_vector_origin(LocalPlayer)
        local ViewAngles = client.camera_angles()
        local pOrigin = antiaim.get_vector_origin(player)
        --local vel = get_vector_prop(idx, "")
        local Yaw = (-math.atan2(pOrigin.x - lOrigin.x, pOrigin.y - lOrigin.y) / 3.14 * 180 + 180) - (forward and 90 or -90)-- - ViewAngles.y +(forward and 0 or -180)
        if Yaw >= 180 then
            Yaw = 360 - Yaw
            Yaw = -Yaw
        end
        Yaw = antiaim.yawto180(Yaw)
        return Yaw
    end
    antiaim.anti_backstab = function(self, cmd, LPH_NO_VIRTUALIZE)
        if not menu.main.antistab:get() then return end
        local local_player = entity.get_local_player()
        if not entity.is_alive(local_player) or not local_player then return end
        local enemy = client.current_threat()
        if not enemy then return end
        local cache = {dist = math.huge, ent = nil}

        for _, enemy in pairs(entity.get_players(true)) do
            local lp_x, lp_y, lp_z = entity.hitbox_position(local_player, 7)
            local number = entity.get_player_weapon(local_player)
            local number2 = entity.get_player_weapon(enemy)
            local t_x, t_y, t_z = 0,0,0
            local my_weapon = entity.get_classname(number)
            local his_weapon = entity.get_classname(number2)
            local distance = 0
            if enemy ~= nil then
                t_x, t_y, t_z = entity.hitbox_position(enemy, 7)
        
                distance = tools.distance(lp_x, lp_y, lp_z, t_x, t_y, t_z)
            end

            if distance < cache.dist then
                cache.dist = distance
                cache.ent = enemy
            end
        end
        if cache.dist < 250 and (cache.ent ~= nil) then
            local enemywep = entity.get_player_weapon(enemy)
            if not enemywep then return end
            local wepname = entity.get_classname(enemywep)

            if wepname == "CKnife" then
                cmd.yaw = self.yaw_to_player(cache.ent, true)
            end
        end
    end
end

local visuals = {} do
    visuals.bodyyaw = 0
    visuals.bodyyaw2 = 0
    visuals.jitteryaw = 0
    visuals.height = 0
    visuals.discharged = false
    visuals.dt_charged = false
    visuals.positions = {
        [1] = 18,
        [2] = 28,
        [3] = 32,
    }
    visuals.transparentclasses = {
        "CHEGrenade",
        "CMolotovGrenade",
        "CSmokeGrenade",
        "CDecoyGrenade",
        "CIncendiaryGrenade",
        "CFlashbang",
    }
    visuals.vw_anim = {appearing = 0, appearing_alpha = 0}
    visuals.anim = {}
    visuals.anim.db = {}
    visuals.indicators = function(self, LPH_NO_VIRTUALIZE)
        local lplr = entity.get_local_player()
        if not lplr or not entity.is_alive(lplr)  then return end
        local scoped = menu.visuals.modifiers:get("scope") and (entity.get_prop(lplr, "m_bIsScoped") ~= 0)
        local offset = 1
        local dt = ui.get(ref.double_tap[1]) and ui.get(ref.double_tap[2])
        local hs = ui.get(ref.onshot_aa[1]) and ui.get(ref.onshot_aa[2])
        local dmg_key, tmp = ui.get(ref.mindamage_override[2])
        local dmg_value = ui.get(ref.mindamage_override[3])
        local fs = menu.antiaim.hotkeys.freestand:get()
        local fs_key, tmp2 = menu.antiaim.hotkeys.freestand:get_hotkey()
        -- local hc = menu.rage.hc:get()
        -- local hc_key, tmp3 = menu.rage.hc:get_hotkey()
        -- local hc_active = hc and hc_key 
        -- local hc_value = menu.rage.hc_s:get()
        local ping_key = ui.get(ref.ping_spike[2]) and ui.get(ref.ping_spike[1])
        local ping_value = ui.get(ref.ping_spike[3])

        local transparency = 1

        local weapon = entity.get_player_weapon(lplr)
        if weapon then
            for i = 1, #visuals.transparentclasses do
                if entity.get_classname(weapon) == visuals.transparentclasses[i] then
                    transparency = 0.3
                    break
                end
            end
        end
        
        local transparency = tools.animation:new("actualtrans", transparency, 10)
        
        local defensive2 = false
        local is_dt = false
        if defensive.currently_active then
            defensive2 = true
        elseif dt then
            is_dt = true
        end
        local screensize = {} screensize.x, screensize.y = client.screen_size()
        visuals.height = 0
        visuals.list = {
            {"DT", dt, defensive.currently_active and {r = 118, g = 181, b = 197, a = 255} or is_dt and {r = 0, g = 255, b = 0, a = 255} or {r = 255, g =  80, b = 80, a = 255}},
            {"HIDE", hs, {r = accent.r, g = accent.g, b = accent.b, a = 255}},
            {"DMG: ".. tostring(dmg_value), dmg_key, {r = accent.r, g = accent.g, b = accent.b, a = 255}},
            --{"HC: ".. tostring(hc_value),(not ui.is_menu_open() and hc_active and menu.visuals.hotkeys:get("hitchance")), {r = accent.r, g = accent.g, b = accent.b, a = 255}},
            {"FS", (fs and fs_key), {r = accent.r, g = accent.g, b = accent.b, a = 255}},
            {"PING", ping_key, {r = 0, g = 255, b = 0, a = 255}},
        }

        if globals.chokedcommands() == 0 then
            self.bodyyaw = entity.get_prop(lplr, "m_flPoseParameter", 11) * 120 - 60
            self.jitteryaw = self.bodyyaw / 60 * (menu.visuals.desync:get() == "static" and 33 or 16)
        end
        local lerpyaw = tools.animation:new("bodyyaw", math.abs(self.bodyyaw), 15)

        local indicator_x = math.min(lerp.lerp("scope_x", (menu.visuals.modifiers:get("scope") and scoped) and 18 or -1, 15))
        local movebinds = math.floor(lerp.lerp("offset_ind_binds",(menu.visuals.modifiers:get("scope") and scoped) and 4 or 0, 8))
        
        local indx = renderer.measure_text("-", "DRUNKERS")

        if menu.visuals.crosshair:get() == "pixel" then
            renderer.text(screensize.x / 2 + indicator_x - indx / 2, screensize.y / 2 + visuals.positions[offset], 255, 255, 255, 255, "-", 0, tools.gradient_text(accent.r, accent.g, accent.b, 255 * transparency, 0, 0, 0, 255 * transparency, 'DRUNKERS', 2))
            offset = offset + 1

            if menu.visuals.desync:get() ~= "none" then
                renderer.rectangle(screensize.x / 2 + indicator_x - 15, screensize.y / 2 + visuals.positions[offset] - 1, 32, 5, 0, 0, 0, 255 * transparency)
                if menu.visuals.desync:get() == "static" then
                    renderer.rectangle(screensize.x / 2 + indicator_x - 14, screensize.y / 2 + visuals.positions[offset], clamp(32 * (lerpyaw / 58), 0, 30), 3, accent.r, accent.g, accent.b, 255 * transparency)
                elseif menu.visuals.desync:get() == "jitter" then
                    renderer.rectangle(screensize.x / 2 + indicator_x + 2, screensize.y / 2 + visuals.positions[offset], self.jitteryaw - 1, 3, accent.r, accent.g, accent.b, 255 * transparency)
                end
                offset = offset + 1
            end
            for k, v in pairs(visuals.list) do
                visuals.anim.db[v[1]] = {}
                visuals.anim.db[v[1]].alpha = math.floor(tools.animation:new('binds_alpha_'..v[1], v[2] and 254 or 0, 20)+0.9)
                if visuals.anim.db[v[1]].alpha > 1 then 
                    -- renderer.text(fonts.pixel, v[1], vec2_t(screen_size_x / 2 + binds.movebinds - (is_scoped and 0 or renderer.get_text_size(fonts.pixel, v[1]).x / 2), screen_size_y / 2 + self.positions[menu.visuals.crosshair:get()][binds.offset] + binds.height), color_t(v[3].r, v[3].g, v[3].b, math.floor(binds.anim.db[v[1]].alpha > 50 and binds.anim.db[v[1]].alpha / 255 * v[3].a or 0)))
                    renderer.text(screensize.x / 2 - 1 + movebinds - (scoped and 0 or measure_text2("-", v[1]).x / 2), screensize.y / 2 + visuals.positions[offset] + visuals.height - 2, v[3].r, v[3].g, v[3].b, math.floor(visuals.anim.db[v[1]].alpha > 50 and visuals.anim.db[v[1]].alpha / 255 * v[3].a * transparency or 0), "-", 0, v[1])
                    visuals.height = visuals.height + visuals.anim.db[v[1]].alpha / 255 * 8
                end
            end
        end
        if menu.visuals.crosshair:get() == "DRUNKERS" then
            local offset2 = 0
            local active_manual = antiaim.side1
            local r = accent.r
            local g = accent.g
            local b = accent.b
            local a = 255
            local shift = entity.get_prop(lplr, "m_nTickBase") - (globals.tickcount()+4)
            --print(shift)
            local charge = self.dt_charged and 1 or math.abs(math.floor(shift*100/14)/100) 
            if antiaim.command_number_delta ~= antiaim.command_number_delta_old then
                self.discharged = true
                self.dt_charged = false
                antiaim.command_number_delta_old = antiaim.command_number_delta
            end
            if self.discharged == true then
                if math.abs(shift) >= 11 then
                    self.dt_charged = true
                    self.discharged = false
                end
            end
            scoped_offset = math.floor(lerp.lerp("scope_offset",scoped and 40 or 0, 12))
            desync = lerp.lerp("desync", math.abs(self.bodyyaw) ,4)
            if (fs and fs_key) or antiaim.side1 ~= "reset" then
                renderer.text(screensize.x/2+scoped_offset, screensize.y/2+37, 255,255,255,200 * transparency, "c",nil, "MANUAL AA")
            else
                renderer.text(screensize.x/2+scoped_offset, screensize.y/2+37, 255,255,255 ,255 * transparency, "c",nil, tools.gradient_text(accent.r, accent.g, accent.b, 255 * transparency, 255, 255, 255, 255 * transparency, 'DRUNKERS', 0.1))
            end
            renderer.text(screensize.x/2+scoped_offset, screensize.y/2+25, 255,255,255,200 * transparency, "c",nil, math.floor(desync) .. "°")
            renderer.gradient(screensize.x/2+scoped_offset, screensize.y/2+30, math.abs(self.bodyyaw/1.5), 1, r, g, b, a * transparency, r, g, b, 0, true)
            renderer.gradient(screensize.x/2+scoped_offset, screensize.y/2+30, -math.abs(self.bodyyaw/1.5), 1, r, g, b, a * transparency, r, g, b, 0, true)
            
            if dt then
                renderer.text(screensize.x/2+scoped_offset + offset2, screensize.y/2+46, 255-charge*255,charge*255,0,a * transparency, "c",nil, "DT")
                renderer.circle_outline(screensize.x/2-11+scoped_offset, screensize.y/2+46 + offset2, 255-charge*255,charge*255,0,a * transparency, 3.5, 270, charge, 1.5)
                offset2 = offset2 + 10
            end
            if hs then
                renderer.text(screensize.x/2+scoped_offset, screensize.y/2+46 + offset2, 255-charge*255,charge*255,0,a * transparency, "c",nil, "ONSHOT")
                offset2 = offset2 + 10
            end
            if dmg_key then
                renderer.text(screensize.x/2+scoped_offset, screensize.y/2+46 + offset2, 0,255,0,255 * transparency, "c",nil, "DMG")
            end
        end
    end
    visuals.watermark = function(self, LPH_NO_VIRTUALIZE)
        local local_player = entity.get_local_player()
        if not local_player then return end
        local screen_size_x, screen_size_y = client.screen_size()
        local r, g, b, a = accent.r, accent.g, accent.b, 255
        if menu.visuals.watermark:get() == "bottom" then
            renderer.text(screen_size_x/2, screen_size_y - 11, 255, 255, 255, 0, "c", nil, tools:text_fade(2, r, g, b, a, "M E T A S E T . C C"))
        elseif menu.visuals.watermark:get() == "discord" then
            renderer.text(screen_size_x - 55, 10, 255, 255, 255, 0, "c", nil, tools:text_fade(2, r, g, b, a, "discord.gg/DRUNKERS"))
        elseif menu.visuals.watermark:get() == "default" then
            if not logo then return end
            logo:draw(screen_size_x/2 - 34  , screen_size_y - 50, 66, 51, 255,255,255,255)
            -- renderer.text(screen_size_x/2 + 900, screen_size_y/2 - 530, 255, 255, 255, 0, "c", nil, tools:text_fade(2, r, g, b, a, "M E T A S E T . C C"))
        end
        if not logo then return end
        if menu.premium.debugtoggle:get() then
        
            logo:draw(-10 , screen_size_y / 2, 66, 51, 255,255,255,255)
            renderer.text(45 , screen_size_y / 2 + 12, 255, 255, 255, 255, "-", nil, "VERSION:  ".. tools:text_fade(2, r, g, b, a, "EARLY ACCESS"))
            renderer.text(45 , screen_size_y / 2 + 27, 255, 255, 255, 255, "-", nil, "USER:  " .. tools:text_fade(2, r, g, b, a, string.upper(tostring(user))) )
        end
    end
    visuals.velocity = function(self)
        if not menu.visuals.velocity:get() then return end
        local lplr = entity.get_local_player()
        if not lplr or not entity.is_alive(lplr) then return end
        local screen_size_x, screen_size_y = client.screen_size()
    
        local modifier = entity.get_prop(lplr, "m_flVelocityModifier")
        local frametime = globals.frametime()
        visuals.vw_anim.appearing = tools.animation:new("screen.vw_anim.appearing", (modifier < 1 or ui.is_menu_open()) and 230 or 180, 10)
        visuals.vw_anim.appearing_alpha = tools.animation:new("screen.vw_anim.appearing_alpha", (modifier < 1 or ui.is_menu_open()) and 255 or 0, 10)
    
        -- renderer.rectangle(screensize.x / 2 + indicator_x + 2, screensize.y / 2 + visuals.positions[offset], self.jitteryaw - 1, 3, accent.r, accent.g, accent.b, 255 * transparency)
        renderer.rectangle(screen_size_x / 2 - 60, math.floor(visuals.vw_anim.appearing), 120, 6, 0, 0, 0, math.min(math.floor(visuals.vw_anim.appearing_alpha), 200))
        renderer.rectangle(screen_size_x / 2 - 58, math.floor(visuals.vw_anim.appearing + 2), 116 * modifier, 2, 255,255,255, math.floor(visuals.vw_anim.appearing_alpha))

        renderer.text(screen_size_x / 2, math.floor(visuals.vw_anim.appearing) - 7, 255, 255, 255, math.floor(visuals.vw_anim.appearing_alpha), "c", nil, string.format("- slow: %i%s -", math.abs(modifier * 100 + 100 * -1), "%"))

        -- render.rect_filled(vec2_t(screen_size_x / 2 - 60, math.floor(screen.vw_anim.appearing)), vec2_t(120, 6), color_t(0,0,0, math.min(math.floor(screen.vw_anim.appearing_alpha), 200)))
        -- render.rect_filled(vec2_t(screen_size_x / 2 - 58, math.floor(screen.vw_anim.appearing + 2)), vec2_t(116 * modifier, 2), color_t(255,255,255, math.floor(screen.vw_anim.appearing_alpha)))
    
        -- render.text(fonts.verdana, string.format("- slow: %i%s -", math.abs(modifier * 100 + 100 * -1), "%"), vec2_t(screen_size_x / 2, math.floor(screen.vw_anim.appearing) - 7), color_t(255, 255, 255, math.floor(screen.vw_anim.appearing_alpha)), true)
    end
    visuals.def_anim = {appearing_alpha = 0}
    visuals.defensive = function(self)
        if not menu.visuals.defensive:get() then return end
        local lplr = entity.get_local_player()
        local screen_size_x, screen_size_y = client.screen_size()
        if not lplr or not entity.is_alive(lplr) then return end

        local defensivetable = defensive:is_active(lplr, true)
        if not defensivetable then return end
        local frametime = globals.frametime()

        local offset = 260

        visuals.def_anim.appearing_alpha = tools.lerp(visuals.def_anim.appearing_alpha, (defensive:is_active(lplr) or ui.is_menu_open()) and 255 or 0, 0.05 + math.min(frametime/10.1, 0.25))

        -- render.rect_filled(vec2_t(screen.size.x / 2 - 60, 249), vec2_t(120, 6), color_t(0,0,0, math.min(math.floor(screen.def_anim.appearing_alpha), 200)))
        -- render.rect_filled(vec2_t(screen.size.x / 2 - 58, 251), vec2_t(116 - math.clamp(116 * math.abs((defensivetable.tick - globals.tick_count() > 0 and defensivetable.tick - globals.tick_count() or 0) / 12), 0, 116), 2), color_t(255,255,255, math.floor(screen.def_anim.appearing_alpha)))

        -- render.text(fonts.verdana, "- defensive -", vec2_t(screen.size.x / 2, 249 - 7), color_t(255, 255, 255, math.floor(screen.def_anim.appearing_alpha)), true)
        renderer.rectangle(screen_size_x / 2 - 60, offset, 120, 6, 0, 0, 0, math.min(math.floor(visuals.def_anim.appearing_alpha), 200))
        renderer.rectangle(screen_size_x / 2 - 58, offset + 2, 116 - clamp(116 * math.abs((defensivetable.tick - globals.tickcount() > 0 and defensivetable.tick - globals.tickcount() or 0) / 12), 0, 116), 2, 255,255,255, math.floor(visuals.def_anim.appearing_alpha))

        renderer.text(screen_size_x / 2, offset - 7, 255, 255, 255, math.floor(visuals.def_anim.appearing_alpha), "c", nil, "- defensive -")
    end
    visuals.manual_arrows = function(self)
        local lplr = entity.get_local_player()
        if not lplr or not entity.is_alive(lplr) then return end
        local screensize = {} screensize.x, screensize.y = client.screen_size()
        local r = antiaim.side1 == "left" and accent.r or 0
        local g = antiaim.side1 == "left" and accent.g or 0
        local b = antiaim.side1 == "left" and accent.b or 0
        local a = antiaim.side1 == "left" and    200   or 100
        local r2 = antiaim.side1 == "right" and accent.r or 0
        local g2 = antiaim.side1 == "right" and accent.g or 0
        local b2 = antiaim.side1 == "right" and accent.b or 0
        local a2 = antiaim.side1 == "right" and    200   or 100
        local r3 = self.bodyyaw < 0 and accent.r or 0
        local g3 = self.bodyyaw < 0 and accent.g or 0
        local b3 = self.bodyyaw < 0 and accent.b or 0
        local a3 = self.bodyyaw < 0 and    200   or 100
        local r4 = self.bodyyaw > 0 and accent.r or 0
        local g4 = self.bodyyaw > 0 and accent.g or 0
        local b4 = self.bodyyaw > 0 and accent.b or 0
        local a4 = self.bodyyaw > 0 and    200   or 100
        if menu.visuals.arrows:get() == "team skeet" then
            renderer.triangle(screensize.x/2 - 40 ,screensize.y/2 - 10, screensize.x/2 - 40,screensize.y/2 + 10, screensize.x/2 - 55,screensize.y/2 , r,g,b,a)
            renderer.triangle(screensize.x/2 + 40 ,screensize.y/2 - 10, screensize.x/2 + 40,screensize.y/2 + 10, screensize.x/2 + 55,screensize.y/2 , r2,g2,b2,a2)
            renderer.rectangle(screensize.x/2 - 37, screensize.y/2 - 10, -2, 20, r3,g3,b3,a3)
            renderer.rectangle(screensize.x/2 + 37, screensize.y/2 - 10, 2, 20, r4,g4,b4,a4)
        end
    end
    visuals.animation = function(self, LPH_NO_VIRTUALIZE)
        local self = entity.get_local_player()
        if not self or not entity.is_alive(self) then
            return
        end
        local self_index = c_entity.new(self)
        local self_anim_state = self_index:get_anim_state()
        local legs = self_index:get_anim_overlay(6)
        if not self_anim_state then
            return
        end
        if menu.visuals.in_air:get() == "static" and not antiaim.is_on_ground then
            entity.set_prop(self, "m_flPoseParameter", 1, 6)
        end
        if menu.visuals.in_air:get() == "break" then
            entity.set_prop(self, "m_flPoseParameter", math.random(0, 10)/10, 6)
        end
        if menu.visuals.on_ground:get() == "static" then
            entity.set_prop(self, "m_flPoseParameter", 0, 0)
        end
        if menu.visuals.on_ground:get()  == "break" then
            entity.set_prop(self, "m_flPoseParameter", client.random_float(0.8, 1), 0)
        end    
        if menu.visuals.on_ground:get()  == "slow" then
            legs.cycle = 0.5
        end

        if menu.visuals.always90:get() then 
            entity.set_prop(self, "m_flPoseParameter", 0, E_POSE_PARAMETERS.MOVE_BLEND_RUN)
        end
        
        if menu.visuals.movelean:get() then
            local self_anim_overlay = self_index:get_anim_overlay(12)
            if not self_anim_overlay then
                return
            end
    
            local x_velocity = entity.get_prop(self, "m_vecVelocity[0]")
            if math.abs(x_velocity) >= 3 then
                --ffi.cast('C_AnimationLayer**', ffi.cast('uintptr_t', get_entity_address(self)) + 0x2990)[0][12].m_weight = menu.visuals.moveleanslider:get()/100
                self_anim_overlay.weight = menu.visuals.moveleanslider:get()/100
                --entity.set_prop(self, "m_flPoseParameter", client.random_float(0,1), 2)
            end
        end
        if menu.visuals.pitch0:get() then
            if self_anim_state.hit_in_ground_animation and antiaim.is_on_ground then
                entity.set_prop(self, "m_flPoseParameter", 0.5, E_POSE_PARAMETERS.BODY_PITCH)
            end
            
        end 
        if menu.visuals.perfect:get() then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(menu.visuals.perfect_slider:get(), 10)/10, 3)
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(menu.visuals.perfect_slider:get(), 10)/10, 7)
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(menu.visuals.perfect_slider:get(), 10)/10, 6)
        end
        if menu.visuals.on_ground:get() == "static" and antiaim.is_on_ground then
            ui.set(ref.leg_movement, "Always slide")
        end
        if menu.visuals.on_ground:get() == "slow" and antiaim.is_on_ground then
            ui.set(ref.leg_movement, "Never slide")
        end
        if menu.visuals.on_ground:get() == "break" and antiaim.is_on_ground then
            ui.set(ref.leg_movement, "Always slide")
        end
    end
    visuals.mindmg = function(self, LPH_NO_VIRTUALIZE)
        if not (menu.visuals.dmg:get()) then return end
        local screen_size_x, screen_size_y  = client.screen_size()
        local local_player = entity.get_local_player()
        if not entity.is_alive(local_player) or not local_player then return end
        local norm_dmg = ui.get(ref.mindamage)
        local dmg_key, tmp = ui.get(ref.mindamage_override[2])
        local dmg_value = ui.get(ref.mindamage_override[3])
        local local_player = entity.get_local_player()
        if not local_player then return end
        local value = (not menu.visuals.dmg_m:get("show always") and dmg_key and dmg_value or dmg_key) and dmg_value or dmg_value
        local lerp = menu.visuals.dmg_m:get("animate") and math.floor(tools.animation:new("dmg",dmg_key and dmg_value or norm_dmg , 16) + 0.5) or norm_dmg
        if dmg_key then
            renderer.text(screen_size_x / 2 + 2, screen_size_y / 2 - 12, 255, 255, 255, 255, "-", nil , not menu.visuals.dmg_m:get("animate") and tostring(value) or lerp)
        else
            if not menu.visuals.dmg_m:get("show always") then return end
            renderer.text(screen_size_x / 2 + 2, screen_size_y / 2 - 12, 255, 255, 255, menu.visuals.dmg_m:get("low transparency") and 100 or 255, "-" , nil, tostring(lerp))
        end
    end

end

local logs = {} do
    logs.data = {}
    logs.hitgroup_names = {[0] = "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
    logs.shot = function(shot)
        local enemy = shot.target
        local targetwep = entity.get_player_weapon(enemy)
        
        local onshot = false
        if not targetwep then
            onshot = false
        else
            onshot = entity.get_prop(targetwep, 'm_fLastShotTime') and globals.curtime() - entity.get_prop(targetwep, 'm_fLastShotTime') < 0.5 or false
        end


        logs.data = {
            hitgroup = shot.hitgroup,
            alive = entity.is_alive(enemy),
            damage = shot.damage,
            onshot = onshot,
            history = globals.tickcount() - shot.tick,
        }
    end
    logs.hit = function(hit)
        local logstring = ("Hit %s(%i%%) in %s(%s) for %i(%i) damage | history %i%s"):format(
            entity.get_player_name(hit.target),
            math.floor(hit.hit_chance),
            logs.hitgroup_names[hit.hitgroup],
            logs.hitgroup_names[logs.data.hitgroup],
            hit.damage,
            logs.data.damage,
            logs.data.history,
            logs.data.onshot and " | onshot" or ""
        )
        if menu.main.logs:get("hit") then
            print(logstring)
        end
    end
    logs.miss = function(miss)
        local logstring = ("Missed %s(%i%%) in %s for %i damage due to %s | history %i%s"):format(
            entity.get_player_name(miss.target),
            math.floor(miss.hit_chance),
            logs.hitgroup_names[miss.hitgroup],
            logs.data.damage,
            miss.reason,
            logs.data.history,
            logs.data.onshot and " | onshot" or ""
        )
        if menu.main.logs:get("miss") then
            print(logstring)
        end
    end
end

local main = {} do
    main.previous_name = ""
    main.was_applied = false
    main.last = nil
    main.reset = 0
    main._last_clantag = nil
    main.clanreset = 0
    main.tag = {
        "",
        "D",
        "DR",
        "DRU",
        "DRUN",
        "DRUNK",
        "DRUNKE",
        "DRUNKERS",
        "DRUNKERS.",
        "DRUNKERS.n",
        "DRUNKERS.nn",
        "DRUNKERS.nn",
        "DRUNKERS.nn",
        "DRUNKERS.n",
        "DRUNKERS.",
        "DRUNKERS",
        "DRUNKE",
        "DRUNK",
        "DRUN",
        "DRU",
        "DR",
        "D",
        "",
    }
    main.disableladder = {
        "CHEGrenade",
        "CMolotovGrenade",
        "CSmokeGrenade",
        "CDecoyGrenade",
        "CIncendiaryGrenade",
        "CFlashbang",
    }
    main.apply_nickname = function(name)
        local local_player = entity.get_local_player()
        if not local_player then
            return
        end

        local native_BaseLocalClient = native_BaseLocalClient_base[0][0]
        if not native_BaseLocalClient then
            return
        end

        local native_UserInfoTable = ffi.cast("void***", native_BaseLocalClient + 0x52C0)[0]
        if not native_UserInfoTable then
            return
        end

        local data = native_GetStringUserData(native_UserInfoTable, local_player - 1, nil)
        if not data then
            return
        end

        local this_name = ffi.string(data[0].szName)
        if name ~= this_name and main.previous_name == nil then
            main.previous_name = this_name
        end

        data[0].szName = ffi.new("char[128]", name)
    end
    main.callback = function(self)
        local chosen_nick = menu.premium.user:get():sub(0, 32)

        if not  menu.premium.user:get() or #chosen_nick == 0 then
            if main.was_applied then
                main.was_applied = false
                apply_nickname(main.previous_name or panorama["MyPersonaAPI"]["GetName"]())
                main.previous_name = nil
            end

            return
        end

        main.was_applied = true

        main.apply_nickname(chosen_nick)
    end
    main.ladder = function(self, cmd)
        if not menu.main.ladder:get() then return end
        local lplr = entity.get_local_player()
        if not lplr or not entity.is_alive(lplr) then return end
        if not (entity.get_prop(lplr, "m_MoveType") == 9) then return end
        local pitch, yaw = client.camera_angles()
        local ladderval = 0
        local abs_ladderval = math.abs(ladderval)
        local weapon = entity.get_player_weapon(lplr)
        local nade = false
        if weapon then
            for i = 1, #main.disableladder do
                if entity.get_classname(weapon) == main.disableladder[i] then
                    nade = true
                    break
                end
            end
        end
        if cmd.forwardmove == 0 then
            ui.set(ref.pitch[1],"custom")
            ui.set(ref.pitch[2],menu.main.ladder_pitch:get())
            ui.set(ref.yaw[2], "180")
            ui.set(ref.yaw[2], menu.main.ladder_yaw:get())
        elseif cmd.forwardmove > 0 and not nade then
            if pitch < 45 then
                cmd.pitch = 89
                cmd.in_moveright = true
                cmd.in_moveleft = false
                cmd.in_forward = false
                cmd.in_back = true
                if cmd.sidemove == 0 then
                    cmd.yaw = cmd.yaw + 90
                elseif cmd.sidemove < 0 then
                    cmd.yaw = cmd.yaw + 150
                elseif cmd.sidemove > 0 then
                    cmd.yaw = cmd.yaw + 30
                end
            end
        elseif cmd.forwardmove < 0 and not nade then
            cmd.pitch = 89
            cmd.in_moveright = false
            cmd.in_moveleft = true
            cmd.in_forward = true
            cmd.in_back = false
            if cmd.sidemove == 0 then
                cmd.yaw = cmd.yaw + 90
            elseif cmd.sidemove > 0 then
                cmd.yaw = cmd.yaw + 150
            elseif cmd.sidemove < 0 then
                cmd.yaw = cmd.yaw + 30 
            end
        end

    end
    main.getClantag = function()
        local latency = client.latency() / globals.tickinterval()
        local tickcount_pred = globals.tickcount() + latency
        local iter = math.floor(math.fmod(tickcount_pred / 40, #main.tag + 1) + 1)
        return main.tag[iter]
    end   
    main.set_tag = function(tag)
        if tag == main._last_clantag then return end
        if tag == nil then return end
        client.set_clan_tag(tag)
        main._last_clantag = tag
    end 
    main.clantag = function()
        local lplr = entity.get_local_player()
        if not lplr then return end
        if menu.main.clantag:get() then
            main.set_tag(main.getClantag())
            main.clanreset = 0
        else
            if main.clanreset < 1 then
                main.set_tag(" ")
                main.clanreset = main.clanreset + 1
            end
        end
    end

    main.phrases = {
        "1",
        "sit down",
        "nn down",
        "kys faggot",
        "bombed like the kremlin",
        "know your place you fucking troglodyte",
        "200",
        "1 nn",
        "1 fucking fag",
        "hdf hurensohn",
        "1 hurensohn",
        "cf?",
        "dead by DRUNKERS nn",
        "why u *dead*?",
        "what happened?",
        "raped",
        "Banned: posted cp (Ends: Jan 07, 2025)",
        "no DRUNKERS?",
        "ur shit",
        "ur shit faggot",
        "stfu",
        "deepfried by DRUNKERS",
        "fantastic steeringwheel assistance",
        "crazy 1",
        "insane computer",
        "send selly link for that sick imaginary girlfriend",
        "interesting uid issue",
        "LOL that 1","LOL that antiaim",
        "send selly link for that sick osiris",
        "u pay for that kd?","nice fucking gamesense",
        "nice visuals",
        "cant tell if you are serious about that negative iq",
        "laughing my ass off that death",
        "breathtaking skeet",
        "crazy visuals",
        "insane resolver",
        "cool lagswitch",
        "awesome gaming carpet",
        "refund that gaming chair",
        "u pay for that resolver?",
        "ahaha that gaming carpet",
        "insane imaginary girlfriend",
        "you pay for that antiaim?",
        "lidl uid issue",
        "cough cough",
        "LOL that cheat",
        "good knifechanger",
        "haahahah that keybind",
        "-1 iq"
    }
    main.killsay_nade = {
        "bombed like the kremlin",
        "bomboclat",
        "kobe",
        "get icbmd",
        "you talking mad shit for someone in icmbing distance",
        "BOMBOCLAAAT",
        "airstriked",
        "get arabed"
    }
    main.killsay_burned = {
        "deepfried",
        "fried by DRUNKERS",
        "burn jew",
        "burned jew",
        "Murr hurr mphuphurrur, hurr mph phrr.",
        "go burn"
    }
    main.player_blind = {
        "Think fast chucklenuts",
        "HE'S PULLING HIS COCK OUT, HE'S PULLING HIS COCK OUT"
    }
    main.killsay_friendly = {
        "IT WAS A MISINPUT, MISINPUT, CALM DOWN, YOU CALM THE FUCK DOWN",
        "missclick"
    }
    main.random_phrase = function(mode)
        if not mode then
            mode = 0
        end
        local temptable = main.phrases
        return temptable[client.random_int(1, #temptable)]:gsub('"', "")
    end
    
    main.killsay = function(e)
        local lp = entity.get_local_player()
        if lp == nil then
            return
        end
        
        local victim = client.userid_to_entindex(e.userid)
        local me =  entity.get_local_player()
        local attacker = client.userid_to_entindex(e.attacker)
    
        if menu.main.killsay:get() then
            if (me == attacker) and not (me == victim) then

                if e.weapon == "inferno" then
                    client.exec('say "' .. main.killsay_burned[math.random(1, #main.killsay_burned)] .. '"')
                elseif e.weapon == "hegrenade" then
                    client.exec('say "' .. main.killsay_nade[math.random(1, #main.killsay_nade)] .. '"')
                else
                    client.exec('say "' .. main.phrases[math.random(1, #main.phrases)] .. '"')
                end


                --client.exec('say "' .. main.random_phrase() .. '"')
            end
        end
    end
    main.flashsay = function(e)
        local lp = entity.get_local_player()
        if lp == nil then
            return
        end
        
        local owner = client.userid_to_entindex(e.userid)
        local me = entity.get_local_player()
    
        if menu.main.killsay:get() then
            if (me == owner) and (e.weapon == "flashbang") then
                client.exec('say "' .. main.player_blind[math.random(1, #main.player_blind)] .. '"')
            end
        end
    end
end


-- @param: Custom API Calls
local Utils = {}
local Engine = {}
local Entity = {}
local Hooks = {}
local LagRecord = {}
local LogRecord = {}
local ResRecord = {}

function InitUtils()
    Utils.SafeError = function(m_szFunction, m_szError, ret)
        print('[DRUNKERS](' .. m_szFunction .. ') ' .. m_szError)
        return ret
    end
    
    Utils.GetVFunc = function(vtable, index)
        return ffi.cast("uintptr_t**", vtable)[0][index]
    end
    
    Utils.CreateInterface = function(module, interface)
        return client.create_interface(module, interface)
    end
    
    Utils.FindSignature = function(module, sequence)
        return client.find_signature(module, sequence)   
    end
end
InitUtils()

function InitEngine()
    Engine.Connected = function()
        return entity.get_local_player() and entity.is_alive(entity.get_local_player())
    end
    
    Engine.GetTickcount = function()
        return globals.tickcount()
    end

    Engine.m_MaxUserCommandProcessTicks = function()
        return cvar.sv_maxusrcmdprocessticks:get_int()
    end
end
InitEngine()

function InitMath()
    math.lerp = function(a, b, t)
        return a + (b - a) * t 
    end

    math.TICK_INTERVAL = function()
        return globals.tickinterval()
    end
    
    math.TIME_TO_TICKS = function(dt)
        return math.floor(0.5 + dt) / math.TICK_INTERVAL()
    end
    
    math.TICKS_TO_TIME = function(t)
        return math.TICK_INTERVAL() * t
    end
    
    math.angle_diff = function(dest, src)
        local delta = 0.0
    
        delta = math.fmod(dest - src, 360.0)
    
        if dest > src then
            if delta >= 180 then delta = delta - 360 end
        else
            if delta <= -180 then delta = delta + 360 end
        end
    
        return delta
    end
    
    math.clamp = function(v, min, max)
        if min > max then min, max = max, min end
        if v > max then return max end
        if v < min then return min end
        return v
    end
    
    math.lerp = function(a, b, t)
        return a + (b - a) * t
    end
    
    math.angle_normalize = function(angle)
        local ang = 0.0
        ang = math.fmod(angle, 360.0)
    
        if ang < 0.0 then ang = ang + 360 end
    
        return ang
    end
    
    math.anglemod = function(a)
        local num = (360 / 65536) * bit.band(math.floor(a * (65536 / 360.0), 65535))
        return num
    end
    
    math.ApproachAngle = function(target, value, speed)
        target = math.anglemod(target)
        value = math.anglemod(value)
    
        local delta = target - value
    
        if speed < 0 then speed = -speed end
    
        if delta < -180 then
            delta = delta + 360
        elseif delta > 180 then
            delta = delta - 360
        end
    
        if delta > speed then
            value = value + speed
        elseif delta < -speed then
            value = value - speed
        else
            value = target
        end
    
        return value
    end

    entity.get_vector_prop = function(idx, prop, array)
        local v1, v2, v3 = entity.get_prop(idx, prop, array)
        return {
            x = v1, y = v2, z = v3
        }
    end
    
    math.VectorLength2d = function(vec3d)
        if not vec3d.x or not vec3d.y then return Utils.SafeError("math.VectorLength2d", 'unable to get ' .. (vec3d.x and "vec3d.y" or "vec3d.x"), 0) end
        root = 0.0
        sqst = vec3d.x * vec3d.x + vec3d.y * vec3d.y
        root = math.sqrt(sqst)
        return root
    end
end
InitMath()


function INT(var)
    return ffi.cast('int', var)
end

function UINTPTR_T(var)
    return ffi.cast('uintptr_t', var)
end

local utilitize = {
    this_call = function(call_function, parameters)
        return function(...)
            return call_function(parameters, ...)
        end
    end;

    entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), client.create_interface("client.dll", "VClientEntityList003"));
}
local get_entity_address = utilitize.this_call(ffi.cast("get_client_entity_t", utilitize.entity_list_003[0][3]), utilitize.entity_list_003);

function InitEntity()
    local engine_client = Utils.CreateInterface( "engine.dll", "VEngineClient014" )
    local VClientEntityList003 = Utils.CreateInterface( "client.dll", "VClientEntityList003" )

    local engine_client_vftable = ffi.cast( "void***", engine_client )
    local entity_list_vftable = ffi.cast( "void***", VClientEntityList003 )

    local get_local_player = ffi.cast( "int( __thiscall* )( void* )", Utils.GetVFunc( engine_client, 12 ) )
    local get_client_entity = ffi.cast( "void*( __thiscall* )( void*, int )", Utils.GetVFunc( VClientEntityList003, 3 ) )
    local get_handle_entity = ffi.cast( "void*( __thiscall* )( void*, int )", Utils.GetVFunc( VClientEntityList003, 4 ) )

    Entity.Registered = {
        m_iIndex = -1,
        m_szType = 'Entity',
        m_hAddress = nil
    }

    function Entity.Registered:new(o)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
        return o
    end

    function Entity.Registered:m_iHealth()
        return ffi.cast('int*', ffi.cast('unsigned int', self.m_hAddress) + 0x100)[0]
    end

    function Entity.Registered:m_iTeamNum()
        return ffi.cast('int*', ffi.cast('unsigned int', self.m_hAddress) + 0xF4)[0]
    end

    function Entity.Registered:m_nAnimationLayers()
        return ffi.cast("C_AnimationLayer**", ffi.cast("uintptr_t", self.m_hAddress) + 0x2990)[0]
    end

    -- local m_PlayerAnimState = ffi.cast("uintptr_t*", Utils.FindSignature("client.dll", "\x8B\x8E\xCC\xCC\xCC\xCC\xF3\x0F\x10\x48\x04\xE8\xCC\xCC\xCC\xCC\xE9") + 2)[0]
    function Entity.Registered:m_nAnimationState(index)
        local player_ptr = get_entity_address(index)
        return ffi.cast("CCSGOPlayerAnimationState_t**", ffi.cast("uintptr_t", player_ptr) + 0x9960)[0]
    end

    function Entity.Registered:m_nPoses()
        return ffi.cast("float*", ffi.cast("uintptr_t", self.m_hAddress) + 10104)
    end

    function Entity.Registered:m_bDormant()
        return ffi.cast("bool*", ffi.cast("uintptr_t", self.m_hAddress) + 0xED)[0]
    end

    function Entity.Registered:m_fFlags()
        return ffi.cast("float*", ffi.cast("uintptr_t", self.m_hAddress) + 0x104)[0]
    end

    function Entity.Registered:m_vecVelocity()
        return ffi.cast('vec3_t*', ffi.cast('unsigned int', self.m_hAddress) + 0x114)[0]
    end

    function Entity.Registered:m_flVelocityLength()
        return math.VectorLength2d(self:m_vecVelocity())
    end

    function Entity.Registered:m_flSimulationTime()
        return ffi.cast('float*', ffi.cast('uintptr_t', self.m_hAddress) + 0x268)[0]
    end

    function Entity.Registered:m_flOldSimulationTime()
        return ffi.cast('float*', ffi.cast('uintptr_t', self.m_hAddress) + 0x268 + ffi.sizeof('float'))[0]
    end

    function Entity.Registered:m_flLowerBodyYawTarget()
        return ffi.cast('float*', ffi.cast('uintptr_t', self.m_hAddress) + 0x9ADC)[0]
    end

    Entity.GetLocalPlayer = function()
        return get_local_player(engine_client_vftable)
    end

    Entity.Get = function(m_iIndex, m_bHandle, m_nEntity, m_nGetCheatEntity)
        if m_iIndex < 0 then return end
        if not Engine.Connected() then return end
        local addr = m_nEntity -- as void*
        if not addr then
            if m_bHandle then
                addr = get_handle_entity(entity_list_vftable, m_iIndex)
            else
                addr = get_client_entity(entity_list_vftable, m_iIndex)
            end
        end
        return Entity.Registered:new({
            m_iIndex = m_iIndex,
            m_szType = m_bHandle and 'Handle' or 'Entity',
            m_hAddress = addr
        })
    end

    Entity.GetProp = function(_type, address, offset)
        return ffi.cast(_type .. '*', ffi.cast('unsigned int', address) + offset)[0]
    end
end
InitEntity()

-- @param: Function Call Tables
local LagRecordHelpers = {}
local Resolver = {}
local PlayerList = {
    flDurationStill = {},
    iSide = {},
    iStandingSide = {},
    iCountStaticSwitch = {},
    flWalkToRunTransition = {},
    bWalkToRunTransitionState = {}
}

LagRecordHelpers.Init = function(m_iIndex, m_nAnimationLayers, m_nAnimationState, m_ChokedCommands, flLowerBodyYawTarget)
    if not LagRecord[m_iIndex] then LagRecord[m_iIndex] = {} end

    LagRecord[m_iIndex][3] = LagRecord[m_iIndex][2]
    LagRecord[m_iIndex][2] = LagRecord[m_iIndex][1]

    LagRecord[m_iIndex][1] = {
        m_nAnimationLayers = {
            [3] = {
                m_weight = m_nAnimationLayers[3].m_weight,
                m_cycle = m_nAnimationLayers[3].m_cycle,
                m_playback_rate = m_nAnimationLayers[3].m_playback_rate
            },
            [6] = {
                m_weight = m_nAnimationLayers[6].m_weight,
                m_cycle = m_nAnimationLayers[6].m_cycle,
                m_playback_rate = m_nAnimationLayers[6].m_playback_rate,
                m_sequence = m_nAnimationLayers[6].m_sequence
            }
        },
        m_nAnimationState = {
            flEyeYaw = m_nAnimationState.flEyeYaw,
            flGoalFeetYaw = m_nAnimationState.flGoalFeetYaw,
            flLastUpdateIncrement = m_nAnimationState.flLastUpdateIncrement,
            flVelocityLenght2D = m_nAnimationState.flVelocityLenght2D,
            flMoveYaw = m_nAnimationState.flMoveYaw,
            flWalkToRunTransition = m_nAnimationState.flWalkToRunTransition
        },
        m_ChokedCommands = m_ChokedCommands,
        flLowerBodyYawTarget = flLowerBodyYawTarget
    }
end

Resolver.UpdateAnimationState = function(m_player, m_nAnimationState)
    return {
        flEyeYaw = m_nAnimationState.flEyeYaw,
        flGoalFeetYaw = m_nAnimationState.flGoalFeetYaw,
        flLastUpdateIncrement = m_nAnimationState.flLastUpdateIncrement,
        flVelocityLenght2D = m_nAnimationState.flVelocityLenght2D,
        flMoveYaw = m_nAnimationState.flMoveYaw,
        flWalkToRunTransition = m_nAnimationState.flWalkToRunTransition
    }
end

Resolver.UpdateAnimationLayers = function(m_player)
    local m_nAnimationLayers = m_player:m_nAnimationLayers()
    return {
        [3] = {
            m_weight = m_nAnimationLayers[3].m_weight,
            m_cycle = m_nAnimationLayers[3].m_cycle,
            m_playback_rate = m_nAnimationLayers[3].m_playback_rate
        },
        [6] = {
            m_weight = m_nAnimationLayers[6].m_weight,
            m_cycle = m_nAnimationLayers[6].m_cycle,
            m_playback_rate = m_nAnimationLayers[6].m_playback_rate,
            m_sequence = m_nAnimationLayers[6].m_sequence
        }
    }
end

Resolver.DetectMicroMovement = function(m_player, m_record)
    if not m_player then return Utils.SafeError("DetectMicroMovement", 'Unable to get m_player', false) end
    if not m_record then return Utils.SafeError("DetectMicroMovement", 'Unable to get m_record', false) end

    return m_player:m_flVelocityLength() < 1 and m_record.m_nAnimationState.flVelocityLenght2D > 0
end

Resolver.IsSideChanged = function(m_player, m_record)
    if not m_player then return Utils.SafeError("IsSideChanged", 'Unable to get m_player', 0) end
    if not m_record then return Utils.SafeError("IsSideChanged", 'Unable to get m_record', 0) end

    local flVelocity = m_player:m_flVelocityLength()
    if flVelocity >= 1.1 and flVelocity <= 1.4 then
		flVelocity = 1.0
    end

    if Resolver.DetectMicroMovement(m_player, m_record) then
        return (m_record.m_nAnimationLayers[6].m_playback_rate / flVelocity * 100000 > 5.9 and 1 or -1)
    end

    local flMoveYaw = m_record.m_nAnimationState.flMoveYaw
    local bBackwards = flMoveYaw > 175 or flMoveYaw < -175
    local bForward = flMoveYaw == 0
    local bLeft = flMoveYaw >= -180 and flMoveYaw < -0
    local bLeftBack = flMoveYaw >= -140 and flMoveYaw <= -120
    local bRight = flMoveYaw > 0 and flMoveYaw <= 180

    if bRight then return -1 end
    if bBackwards then return -1 end
    return 1
end

Resolver.UpdateStandingTimer = function(m_player, m_record)
    if not m_player then return Utils.SafeError("UpdateStandingTimer", 'Unable to get m_player') end
    if not m_record then return Utils.SafeError("UpdateStandingTimer", 'Unable to get m_record') end

    if not PlayerList.flDurationStill then PlayerList.flDurationStill = {} end
    if not PlayerList.flDurationStill[m_player.m_iIndex] then PlayerList.flDurationStill[m_player.m_iIndex] = 0 end

    if m_player:m_flVelocityLength() > 1 then
        PlayerList.flDurationStill[m_player.m_iIndex] = 0
    else
        PlayerList.flDurationStill[m_player.m_iIndex] = (PlayerList.flDurationStill[m_player.m_iIndex] or 0) + m_record.m_nAnimationState.flLastUpdateIncrement * 20
    end
end

Resolver.DetectSwitchSide = function(m_player, m_record, m_oldrecord, m_evenolderrecord) 
    if not m_player then return Utils.SafeError("DetectSwitchSide", 'Unable to get m_player', false) end
    if not m_record then return Utils.SafeError("DetectSwitchSide", 'Unable to get m_record', false) end
    if not m_oldrecord then return Utils.SafeError("DetectSwitchSide", 'Unable to get m_oldrecord', false) end
    if not m_evenolderrecord then return Utils.SafeError("DetectSwitchSide", 'Unable to get m_evenolderrecord', false) end

    Resolver.UpdateStandingTimer(m_player, m_record)

    local flWeight = m_record.m_nAnimationLayers[6].m_weight
    local flPrevWeight = m_oldrecord.m_nAnimationLayers[6].m_weight

    local flOlderPrevPlaybackrate = m_evenolderrecord.m_nAnimationLayers[6].m_playback_rate * 100000
    local flPrevPlaybackrate = m_oldrecord.m_nAnimationLayers[6].m_playback_rate * 100000
    local flPlaybackrate = m_record.m_nAnimationLayers[6].m_playback_rate * 100000

    local flPreviousPlaybackrateDiff = (flOlderPrevPlaybackrate - flPrevPlaybackrate)
    local flPlaybackrateDiff = (flPlaybackrate - flPrevPlaybackrate)

    if Resolver.DetectMicroMovement(m_player, m_record) then
        if PlayerList.flDurationStill[m_player.m_iIndex] > 0 and PlayerList.flDurationStill[m_player.m_iIndex] <= (m_record.m_nAnimationState.flLastUpdateIncrement * 20) then
            return false
        end

        if flWeight > 0.0 then return true end

        return flPreviousPlaybackrateDiff == 0 and math.abs(flPlaybackrateDiff) > 1
    end

    if m_record.m_nAnimationState.flWalkToRunTransition < 1 then
        if flWeight ~= 1 then
            if flWeight ~= flPrevWeight then return true end
        else
            return math.floor(flPreviousPlaybackrateDiff + 0.5) == 0 and math.abs(flPlaybackrateDiff) > 1
        end
    end

    return false
end

Resolver.OnDirectionChange = function(m_player, bMicroMovement, m_record, m_oldrecord)
    if not m_player then return Utils.SafeError("OnDirectionChange", 'Unable to get m_player', 0) end
    if not m_record then return Utils.SafeError("OnDirectionChange", 'Unable to get m_record', 0) end
    if not m_oldrecord then return Utils.SafeError("OnDirectionChange", 'Unable to get m_oldrecord', 0) end

    if m_player:m_bDormant() then return false end
    if not bMicroMovement and not Resolver.DetectMicroMovement(m_player, m_record) then return false end

    return m_record.m_nAnimationState.flMoveYaw ~= m_oldrecord.m_nAnimationState.flMoveYaw
end

Resolver.UpdatePlayerDesyncSideMove = function(m_player, m_record, m_oldrecord, m_evenolderrecord, m_diff)
    if not m_player then return Utils.SafeError("UpdatePlayerDesyncSideMove", 'Unable to get m_player', 0) end
    local m_iIndex = m_player.m_iIndex
    if not PlayerList.iSide then PlayerList.iSide = {} end
    if not PlayerList.iSide[m_iIndex] then PlayerList.iSide[m_iIndex] = -1 end
    if not m_record then return Utils.SafeError("UpdatePlayerDesyncSideMove", 'Unable to get m_record', PlayerList.iSide[m_iIndex] or 0) end
    if not m_oldrecord then return Utils.SafeError("UpdatePlayerDesyncSideMove", 'Unable to get m_oldrecord', PlayerList.iSide[m_iIndex] or 0) end
    if not m_evenolderrecord then return Utils.SafeError("UpdatePlayerDesyncSideMove", 'Unable to get m_evenolderrecord', PlayerList.iSide[m_iIndex] or 0) end

    local flWeight = m_record.m_nAnimationLayers[6].m_weight
    local flPrevWeight = m_oldrecord.m_nAnimationLayers[6].m_weight

    local flOlderPrevPlaybackrate = m_evenolderrecord.m_nAnimationLayers[6].m_playback_rate * 100000
    local flPrevPlaybackrate = m_oldrecord.m_nAnimationLayers[6].m_playback_rate * 100000
    local flPlaybackrate = m_record.m_nAnimationLayers[6].m_playback_rate * 100000

    local flPreviousPlaybackrateDiff = (flOlderPrevPlaybackrate - flPrevPlaybackrate)
    local flPlaybackrateDiff = (flPlaybackrate - flPrevPlaybackrate)

    local bIsMoving = m_player:m_flVelocityLength() > 1
    local bIsMicromovement = Resolver.DetectMicroMovement(m_player, m_record)

    local bMovingCursor = bIsMicromovement and Resolver.OnDirectionChange(m_player, true, m_record, m_oldrecord)
    local flMinimalizer = bMovingCursor and 0.1 or 1

    if math.abs(flPlaybackrateDiff) > 0.1 / flMinimalizer and math.abs(flPreviousPlaybackrateDiff) > 0.1 / flMinimalizer then
        if math.abs(flPlaybackrateDiff - flPreviousPlaybackrateDiff) < 0.1  / flMinimalizer then
            return PlayerList.iSide[m_iIndex]
        end
    end

    local flJitteryDifference = math.abs(flPlaybackrate - flOlderPrevPlaybackrate)
    local bJitteryMicromovement = false

    if flPrevPlaybackrate <= 1 then
        if flOlderPrevPlaybackrate > 0 then
            if math.abs(flPlaybackrate - flPrevPlaybackrate) > 0.0 then
                if flJitteryDifference > 0 then
                    bJitteryMicromovement = true
                end
            end
        end
    end

    local bDetectSwitchKey = Resolver.DetectSwitchSide(m_player, m_record, m_oldrecord, m_evenolderrecord)
    if bDetectSwitchKey then
        --if PlayerList.iSide[m_iIndex] == 0 then client.log_screen('sex') end
        if not bJitteryMicromovement then
            -- m_diff
            --if m_player:m_flVelocityLength() >= 250 then
            --    PlayerList.iSide[m_iIndex] = Resolver.IsSideChanged(m_player, m_record)
            --else
            PlayerList.iSide[m_iIndex] = (m_diff < 0) and 1 or -1
            --end
        else
            PlayerList.iSide[m_iIndex] = (flJitteryDifference > 0.1 * flMinimalizer) and 1 or -1

            if bit.band(m_player:m_fFlags(), bit.lshift(1, 1)) ~= 0 then -- FL_DUCKING
                PlayerList.iSide[m_iIndex] = PlayerList.iSide[m_iIndex] * -1
            end
        end
    end

    return PlayerList.iSide[m_iIndex]
end

Resolver.GetMaxDesync = function(m_nAnimationState)
    local speedfactor = m_nAnimationState.flSpeedNormalized
    local avg_speedfactor = (m_nAnimationState.flAffectedFraction * -0.3 - 0.2) * speedfactor + 1

    local duck_amount = m_nAnimationState.flDuckAmount
    if duck_amount > 0 then
        local duck_speed = duck_amount * speedfactor

        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return avg_speedfactor
end

Resolver.CalculatePredictedWalkToRunTransition = function(m_flWalkToRunTransition, m_bWalkToRunTransitionState, m_flLastUpdateIncrement, m_flVelocityLengthXY)
    ANIM_TRANSITION_WALK_TO_RUN = false
    ANIM_TRANSITION_RUN_TO_WALK = true
    CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED = 2.0
    CS_PLAYER_SPEED_RUN = 260.0
    CS_PLAYER_SPEED_DUCK_MODIFIER = 0.34
    CS_PLAYER_SPEED_WALK_MODIFIER = 0.52

    if m_flWalkToRunTransition > 0 and m_flWalkToRunTransition < 1 then
        if m_bWalkToRunTransitionState == ANIM_TRANSITION_WALK_TO_RUN then
            m_flWalkToRunTransition = m_flWalkToRunTransition +  m_flLastUpdateIncrement * CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED
        else
            m_flWalkToRunTransition = m_flWalkToRunTransition - m_flLastUpdateIncrement * CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED
        end

        m_flWalkToRunTransition = math.clamp(m_flWalkToRunTransition, 0, 1)
    end

    if m_flVelocityLengthXY > (CS_PLAYER_SPEED_RUN * CS_PLAYER_SPEED_WALK_MODIFIER) and
        m_bWalkToRunTransitionState == ANIM_TRANSITION_RUN_TO_WALK then
        m_bWalkToRunTransitionState = ANIM_TRANSITION_WALK_TO_RUN
        m_flWalkToRunTransition = math.max(0.01, m_flWalkToRunTransition)
    elseif m_flVelocityLengthXY < (CS_PLAYER_SPEED_RUN * CS_PLAYER_SPEED_WALK_MODIFIER) and
        m_bWalkToRunTransitionState == ANIM_TRANSITION_WALK_TO_RUN then
        m_bWalkToRunTransitionState = ANIM_TRANSITION_RUN_TO_WALK
        m_flWalkToRunTransition = math.min(0.99, m_flWalkToRunTransition)
    end

    return m_flWalkToRunTransition, m_bWalkToRunTransitionState
end

Resolver.CalculatePredictedFootYaw = function(m_flFootYawLast, m_flEyeYaw, m_flLowerBodyYawTarget, m_flWalkToRunTransition, m_vecVelocity, m_flMinBodyYaw, m_flMaxBodyYaw)
    local m_flVelocityLengthXY = math.min(math.VectorLength2d(m_vecVelocity), 260.0)

    local m_flFootYaw = math.clamp(m_flFootYawLast, -360, 360)
    local flEyeFootDelta = math.angle_diff(m_flEyeYaw, m_flFootYaw)

    if flEyeFootDelta > m_flMaxBodyYaw then
        m_flFootYaw = m_flEyeYaw - math.abs(m_flMaxBodyYaw)
    elseif flEyeFootDelta < m_flMinBodyYaw then
        m_flFootYaw = m_flEyeYaw + math.abs(m_flMinBodyYaw)
    end

    m_flFootYaw = math.angle_normalize(m_flFootYaw)

    local m_flLastUpdateIncrement = math.TICK_INTERVAL()

    if m_flVelocityLengthXY > 0.1 or m_vecVelocity.z > 100 then
        m_flFootYaw = math.ApproachAngle(m_flEyeYaw, m_flFootYaw, m_flLastUpdateIncrement * (30.0 + 20.0 * m_flWalkToRunTransition))
    else
        m_flFootYaw = math.ApproachAngle(m_flLowerBodyYawTarget, m_flFootYaw, m_flLastUpdateIncrement * 100)
    end

    return m_flFootYaw
end

Resolver.Init = function(bShouldResolveYaw, m_player, m_iIndex, m_local, m_nAnimationState, m_record, m_oldrecord, m_olderrecord)
    if not bShouldResolveYaw then return end

    local m_nPrevAnimationState = m_oldrecord.m_nAnimationState
    local flLowerBodyYawDiff = math.angle_diff(m_record.flLowerBodyYawTarget, m_record.m_nAnimationState.flGoalFeetYaw)

    local flEyeFeetYawDiff = math.angle_diff(m_nAnimationState.flEyeYaw, m_nAnimationState.flGoalFeetYaw)
    local flPositiveAngleDiff = math.abs(flEyeFeetYawDiff)
    local flPrevEyeFeetYawDiff = math.angle_diff(m_nPrevAnimationState.flEyeYaw, m_nPrevAnimationState.flGoalFeetYaw)
    local flPositivePreviousAngleDiff = math.abs(flPrevEyeFeetYawDiff)

    local flServerVelocity2D = m_player:m_flVelocityLength()
    local bUpdatingAnimations = (((m_record.m_nAnimationState.flVelocityLenght2D > 0 and flServerVelocity2D <= 1) or flServerVelocity2D > 1 ) and true or false)

    local flMaxAllowedDesyncDeltaAngle = 57.295779513082
    local flDesyncDelta = Resolver.GetMaxDesync(m_nAnimationState) * flMaxAllowedDesyncDeltaAngle

    if flPositiveAngleDiff > 0 and flPositivePreviousAngleDiff > 0 then
        local bSafeToUseAngleDiff = true

        if flPositiveAngleDiff < flPositivePreviousAngleDiff then
            bSafeToUseAngleDiff = false

            if m_nAnimationState.flVelocityLenght2D > m_nPrevAnimationState.flVelocityLenght2D then
                bSafeToUseAngleDiff = true
            end
        end

        if m_record.m_nAnimationLayers[6].m_sequence == 979 then -- ACT_CSGO_IDLE_TURN_BALANCEADJUST
            bSafeToUseAngleDiff = true
        end

        if bSafeToUseAngleDiff then
            if flPositiveAngleDiff <= 10.0 and flPositivePreviousAngleDiff <= 10.0 then
                flDesyncDelta = math.max(flPositiveAngleDiff, flPositivePreviousAngleDiff)
            elseif flPositiveAngleDiff <= 35.0 and flPositivePreviousAngleDiff <= 35.0 then
                flDesyncDelta = math.max(29.0, math.max(flPositiveAngleDiff, flPositivePreviousAngleDiff))
            else
                flDesyncDelta = math.clamp(math.max(flPositiveAngleDiff, flPositivePreviousAngleDiff), 29.0, 58.0)
            end
        end
    end

    --[[
    if not PlayerList.iStandingSide[m_iIndex] then PlayerList.iStandingSide[m_iIndex] = 0 end
    if not PlayerList.iCountStaticSwitch[m_iIndex] then PlayerList.iCountStaticSwitch[m_iIndex] = 0 end

    if not bUpdatingAnimations then
        local weight = m_record.m_nAnimationLayers[6].m_weight * 1000
        if math.abs(weight) > 0 then
            PlayerList.iCountStaticSwitch[m_iIndex] = PlayerList.iCountStaticSwitch[m_iIndex] + 1
            if PlayerList.iCountStaticSwitch[m_iIndex] >= 2 then
                PlayerList.iStandingSide[m_iIndex] = PlayerList.iStandingSide[m_iIndex] * -1
                PlayerList.iCountStaticSwitch[m_iIndex] = 0
            end
        end
    end

    if bUpdatingAnimations then
        if flLowerBodyYawDiff > 1 then
            PlayerList.iStandingSide[m_iIndex] = -1
        elseif flLowerBodyYawDiff < -1 then
            PlayerList.iStandingSide[m_iIndex] = 1
        else
            PlayerList.iStandingSide[m_iIndex] = 0
        end
        PlayerList.iCountStaticSwitch[m_iIndex] = 0
    end]]
    

    --if not PlayerList.iSide[m_iIndex] then PlayerList.iSide[m_iIndex] = 0 end

    local m_iCurrentSide = Resolver.UpdatePlayerDesyncSideMove(m_player, m_record, m_oldrecord, m_olderrecord, flLowerBodyYawDiff, flServerVelocity2D < 20 and flLowerBodyYawDiff or flEyeFeetYawDiff)

    --if flPositiveAngleDiff > 2 and flPositivePreviousAngleDiff > 2 then
        --if flServerVelocity2D > 1 then
            --m_iCurrentSide = Resolver.UpdatePlayerDesyncSideMove(m_player, m_record, m_oldrecord, m_olderrecord)
        --else
        --    m_iCurrentSide = PlayerList.iStandingSide[m_iIndex] or 0
        --end
    --end

    flDesyncDelta = flDesyncDelta * m_iCurrentSide *-1

    ResRecord[m_iIndex] = flDesyncDelta


   
    
    -- client.log_screen(tostring(flDesyncDelta))

    PlayerList.flWalkToRunTransition[m_iIndex], PlayerList.bWalkToRunTransitionState[m_iIndex] = Resolver.CalculatePredictedWalkToRunTransition(
        (PlayerList.flWalkToRunTransition[m_iIndex] or 0), 
        (PlayerList.bWalkToRunTransitionState[m_iIndex] or false),
        math.TICK_INTERVAL(),
        m_nAnimationState.flVelocityLenght2D
    )
    

    return Resolver.CalculatePredictedFootYaw(
        m_nAnimationState.flGoalFeetYaw,
        m_nAnimationState.flEyeYaw + flDesyncDelta,
        m_record.flLowerBodyYawTarget,
        PlayerList.flWalkToRunTransition[m_iIndex],
        m_player:m_vecVelocity(),
        -flMaxAllowedDesyncDeltaAngle, flMaxAllowedDesyncDeltaAngle
    )
    --local pr = Resolver.UpdatePlayerDesyncSideMove(m_player, m_record, m_oldrecord, m_olderrecord)
end

Resolver.yawto180 = function(yawbruto)
    if yawbruto > 180 then
        return yawbruto - 360;
    end

    return yawbruto;
end

Resolver.Create = function()
    local get_players = entity.get_players(true)
    if not get_players then return end

    local m_local = Entity.Get(Entity.GetLocalPlayer())
    if not m_local or not m_local.m_hAddress then return end

    for _, m_cheat_player in pairs(get_players) do
        if not m_cheat_player then goto next_player end
        if entity.get_prop(m_cheat_player, "m_iHealth") < 1 then goto next_player end
        local m_iTeamNum = entity.get_prop(m_cheat_player, "m_iTeamNum")
        if m_iTeamNum ~= 2 and m_iTeamNum ~= 3 then goto next_player end
        -- if m_cheat_player:has_player_flag(e_player_flags.FAKE_CLIENT) then goto next_player end

        local m_iIndex = m_cheat_player

        local m_player = Entity.Get(m_iIndex)
        if not m_player or not m_player.m_hAddress then goto next_player end

        local m_nCurrentAnimationState = m_player:m_nAnimationState(m_cheat_player)
        local m_nAnimationState = Resolver.UpdateAnimationState(m_player, m_nCurrentAnimationState)
        local m_nAnimationLayers = Resolver.UpdateAnimationLayers(m_player)

        local flSimulationTime = m_player:m_flSimulationTime() --ffi.cast('float*', ffi.cast('uintptr_t', m_nEntity) + 0x268)[0]
        local flOldSimulationTime = m_player:m_flOldSimulationTime()--ffi.cast('float*', ffi.cast('uintptr_t', m_nEntity) + 0x268 + ffi.sizeof('float'))[0]

        local m_ChokedCommands = math.TIME_TO_TICKS(flSimulationTime - flOldSimulationTime)

        LagRecordHelpers.Init(m_iIndex, m_nAnimationLayers, m_nAnimationState, m_ChokedCommands, m_player:m_flLowerBodyYawTarget())

        local m_record = LagRecord[m_iIndex][1]
        local m_oldrecord = LagRecord[m_iIndex][2] or LagRecord[m_iIndex][1]
        local m_olderrecord = LagRecord[m_iIndex][3] or LagRecord[m_iIndex][2] or LagRecord[m_iIndex][1]
        --print(Resolver.Init(true, m_player, m_iIndex, m_local, m_nCurrentAnimationState, m_record, m_oldrecord, m_olderrecord))
        local m_flLastAngle, desync = Resolver.Init(true, m_player, m_iIndex, m_local, m_nCurrentAnimationState, m_record, m_oldrecord, m_olderrecord) or {m_nAnimationState.flEyeYaw , 0}

        --local desync = m_nAnimationState.flEyeYaw - Resolver.yawto180(m_flLastAngle)
        plist.set(m_iIndex, "Force body yaw", true)
        plist.set(m_iIndex, "Force body yaw value", ResRecord[m_iIndex])

        ::next_player::
    end
end

client.register_esp_flag("D", 255, 255 , 255 , function(self) 
    if ResRecord[self] == nil then ResRecord[self] = 0 end
    return (not entity.is_dormant(self) and entity.is_alive(self) and (menu.rage.resolver:get() and menu.enable:get())) and true, tostring(math.floor(-ResRecord[self]))
end)




-- @param: Gamesense NET_UPDATE_START callback
client.set_event_callback("net_update_end", function()
    defensive.currently_active = defensive:is_active(entity.get_local_player())
    if not menu.rage.resolver:get() then 
        return 
    end
    Resolver.Create()
end)

-- @param: Gamesense SETUP_COMMAND callback
client.set_event_callback("setup_command", function(cmd)
    if menu.rage.resolver:get() then 
        local tickcount = globals.tickcount()

        local get_players = entity.get_players(true)
        if not get_players then return end
        for _, enemy in pairs(get_players) do
            local index = enemy
            if not LogRecord[index] then LogRecord[index] = {} end
            LogRecord[index][tickcount] = ResRecord[index]
            if LogRecord[index][tickcount - 40] then LogRecord[index][tickcount - 40] = nil end
        end
    else
        local get_players = entity.get_players(true)
        for _, enemy in pairs(get_players) do
            plist.set(enemy, "Force body yaw", false)
        end
    end
end)

-- @param: Gamesense AIMBOT_SHOOT callback
client.set_event_callback("aim_fire", function(ctx)
    if not menu.rage.resolver:get() then return end
    if not ResRecord[ctx.target] then return end
    print(string.format("aim_fire: %s desync delta %0.2f backtrack: %i", entity.get_player_name(ctx.target), LogRecord[ctx.target][ctx.tick] or 0, globals.tickcount() - ctx.tick))
end)

client.set_event_callback("net_update_end", function()
    
    if not menu.rage.resolver:get() then 
        return 
    end
    Resolver.Create()
end)

menu.premium.set:set_callback(main.callback)

client.set_event_callback("round_start",function()
    for i = 1, 11 do
        antiaim.brute[i] = antiaim.brute[i] and antiaim.brute[i] or {}
        antiaim.brute[i].phase = antiaim.brute[i].phase and antiaim.brute[i].phase or 0
        antiaim.brute[i].phase = 0
    end
end)

client.set_event_callback("player_death", function(e)
    main.killsay(e)
end)

client.set_event_callback("grenade_thrown", function(e)
    main.flashsay(e)
end)

client.set_event_callback("bullet_impact", function(e)
    antiaim:bullet(e)
end)


client.set_event_callback("setup_command", function(cmd)
    antiaim:update(cmd)
    antiaim:handler(cmd)
    antiaim:manuals()
    main:ladder(cmd)
    antiaim.bombsite_fix(cmd)
    antiaim:safe_head()
    antiaim:anti_backstab(cmd)
end)
client.set_event_callback("paint_ui", function()
    local update = menu.enable:get()
    handles.gmb(true, update)
    accent.r, accent.g, accent.b = menu.enable:get_color()
end)
client.set_event_callback("paint", function()
    visuals:indicators()
    visuals:watermark()
    visuals:mindmg()
    visuals:velocity()
    visuals:defensive()
    visuals:manual_arrows()
    main.clantag()
end)
client.set_event_callback("pre_render", function()
    visuals:animation()
end)
client.set_event_callback("shutdown", function()
    handles.gmb(false)
end)
client.set_event_callback("aim_fire", function(...)
    logs.shot(...)
end)
client.set_event_callback("aim_hit", function(...)
    logs.hit(...)
end)
client.set_event_callback("aim_miss", function(...)
    logs.miss(...)
end)
client.set_event_callback("player_connect_full", function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        update_callbacks()
    end
    for i = 1, 11 do
        antiaim.brute[i] = antiaim.brute[i] and antiaim.brute[i] or {}
        antiaim.brute[i].phase = antiaim.brute[i].phase and antiaim.brute[i].phase or 0
        antiaim.brute[i].phase = 0
    end
end)

handles.setupmenu()
config.cfg = pui.setup(menu)

local item_crash_fix do
    local CS_UM_SendPlayerItemFound = 63

    local DispatchUserMessage_t = ffi.typeof [[
        bool(__thiscall*)(void*, int msg_type, int nFlags, int size, const void* msg)
    ]]

    local VClient018 = client.create_interface("client.dll", "VClient018")

    local pointer = ffi.cast("uintptr_t**", VClient018)
    local vtable = ffi.cast("uintptr_t*", pointer[0])

    local size = 0

    while vtable[size] ~= 0x0 do
       size = size + 1
    end

    local hooked_vtable = ffi.new("uintptr_t[?]", size)

    for i = 0, size - 1 do
        hooked_vtable[i] = vtable[i]
    end

    pointer[0] = hooked_vtable

    local oDispatch = ffi.cast(DispatchUserMessage_t, vtable[38])

    local function hkDispatch(thisptr, msg_type, nFlags, size, msg)
        if msg_type == CS_UM_SendPlayerItemFound then
            return false
        end

        return oDispatch(thisptr, msg_type, nFlags, size, msg)
    end

    client.set_event_callback("shutdown", function()
        hooked_vtable[38] = vtable[38]
        pointer[0] = vtable
    end)

    hooked_vtable[38] = ffi.cast("uintptr_t", ffi.cast(DispatchUserMessage_t, hkDispatch))
end

update_callbacks()