local base64 = {}
local ffi = require('ffi')
if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
    LPH_JIT = function(...) return ... end
end
base64.encode = function(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '--', '-' })[#data%3+1])
end
 
base64.decode = function(data)
    data = data:gsub('-', '=')
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

do
    local libraries = {
        { req_name = 'gamesense/csgo_weapons', link = 'https://gamesense.pub/forums/viewtopic.php?id=18807' },
        { req_name = 'gamesense/websockets', link = 'https://gamesense.pub/forums/viewtopic.php?id=23653' },
        { req_name = 'gamesense/easing', link = 'https://gamesense.pub/forums/viewtopic.php?id=22920' },
        { req_name = 'gamesense/trace', link = 'https://gamesense.pub/forums/viewtopic.php?id=32949' },
        { req_name = 'gamesense/antiaim_funcs', link = 'https://gamesense.pub/forums/viewtopic.php?id=29665' }
    }

    for i, key in pairs(libraries) do
        local status, error = pcall(require, key.req_name)

        if not status then
            log(('Missing library: %s, subscribe to it and reinject. [url: %s]'):format(key.req_name, key.link))
        end
    end
end

local clipboard_safety = 'LMNOPQRXYZabcdefgSTUVWhijklmnopqCDEFGHIJrstuvwxyz0123ABK456789+/-'
local build_data = { ['User'] = 'Stable', ['Beta'] = 'Beta', ['Debug'] = 'Alpha', ['Private'] = 'Nightly' }
local obex_data = obex_fetch and obex_fetch() or {username = 'fucktheniggers', build = 'Private'}
obex_data.build = build_data[obex_data.build]

local cloud = {
    settings = {},
}

return(function(eternal)
    eternal.colorful_text = {
        lerp = function(self, a, b, c)
            if type(a) == 'table' and type(b) == 'table' then
                return {self:lerp(a[1], b[1], c), self:lerp(a[2], b[2], c), self:lerp(a[3], b[3], c)}
            end
            return a + (b - a) * c
        end,
        console = function(self, ...)
            for d, e in ipairs({...}) do
                if type(e[1]) == 'table' and type(e[2]) == 'table' and type(e[3]) == 'string' then
                    for f = 1, #e[3] do
                        local g = self:lerp(e[1], e[2], f / #e[3])
                        client.color_log(g[1], g[2], g[3], e[3]:sub(f, f) .. '\0')
                    end
                elseif type(e[1]) == 'table' and type(e[2]) == 'string' then
                    client.color_log(e[1][1], e[1][2], e[1][3], e[2] .. '\0')
                end
            end
        end,
        text = function(self, ...)
            local h = false
            local i = 255
            local j = ''
            for d, e in ipairs({...}) do
                if type(e) == 'boolean' then
                    h = e
                elseif type(e) == 'number' then
                    i = e
                elseif type(e) == 'string' then
                    j = j .. e
                elseif type(e) == 'table' then
                    if type(e[1]) == 'table' and type(e[2]) == 'string' then
                        j = j .. ('\a%02x%02x%02x%02x'):format(e[1][1], e[1][2], e[1][3], i) .. e[2]
                    elseif type(e[1]) == 'table' and type(e[2]) == 'table' and type(e[3]) == 'string' then
                        for f = 1, #e[3] do
                            local k = self:lerp(e[1], e[2], f / #e[3])
                            j = j .. ('\a%02x%02x%02x%02x'):format(k[1], k[2], k[3], i) .. e[3]:sub(f, f)
                        end
                    end
                end
            end
            return ('%s\a%s%02x'):format(j, 'cdcdcd', i)
        end,
        log = function(self, ...)
            for d, e in ipairs({...}) do
                if type(e) == 'table' then
                    if type(e[1]) == 'table' then
                        if type(e[2]) == 'string' then
                            self:console({e[1], e[1], e[2]})
                            if e[3] then
                                self:console({{255, 255, 255}, '\n'})
                            end
                        elseif type(e[2]) == 'table' then
                            self:console({e[1], e[2], e[3]})
                            if e[4] then
                                self:console({{255, 255, 255}, '\n'})
                            end
                        end
                    elseif type(e[1]) == 'string' then
                        self:console({{205, 205, 205}, e[1]})
                        if e[2] then
                            self:console({{255, 255, 255}, '\n'})
                        end
                    end
                end
            end
        end
    }

    eternal.includes = {
        csgo_weapons = require('gamesense/csgo_weapons'),
        aa_funcs = require('gamesense/antiaim_funcs'),
        websockets = require('gamesense/websockets'),
        easing = require('gamesense/easing'),
        trace = require('gamesense/trace'),
        vector = require('vector')
    }

    ffi.cdef[[
        typedef int(__thiscall* get_clipboard_text_count)(void*);
        typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
        typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
    ]]

    eternal.ref = {
        rage = {
            enabled = { ui.reference('rage', 'Aimbot', 'Enabled') },
            target_selection = ui.reference('rage', 'Aimbot', 'Target selection'),
            target_hitbox = ui.reference('rage', 'Aimbot', 'Target hitbox'),
            multi_point = ui.reference('rage', 'Aimbot', 'Multi-point'),
            multi_point_scale = ui.reference('rage', 'Aimbot', 'Multi-point scale'),
            prefer_safe_point = ui.reference('rage', 'Aimbot', 'Prefer safe point'),
            force_safe_point = ui.reference('rage', 'Aimbot', 'Force safe point'),
            avoid_unsafe_hitboxes = ui.reference('rage', 'Aimbot', 'Avoid unsafe hitboxes'),
            automatic_fire = ui.reference('rage', 'Other', 'Automatic fire'),
            automatic_penetration = ui.reference('rage', 'Other', 'Automatic penetration'),
            silent_aim = ui.reference('rage', 'Other', 'Silent aim'),
            hit_chance = ui.reference('rage', 'Aimbot', 'Minimum hit chance'),
            minimum_damage = ui.reference('rage', 'Aimbot', 'Minimum damage'),
            minimum_damage_override = { ui.reference('rage', 'Aimbot', 'Minimum damage override') },
            automatic_scope = ui.reference('rage', 'Aimbot', 'Automatic scope'),
            fov = ui.reference('rage', 'Other', 'Maximum FOV'),
        
            accuracy_boost = ui.reference('rage', 'Other', 'Accuracy boost'),
            delay_shot = ui.reference('rage', 'Other', 'Delay shot'),
            quick_stop = ui.reference('rage', 'Aimbot', 'Quick stop'),
            quick_peek_assist = { ui.reference('rage', 'Other', 'Quick peek assist') },
            quick_peek_assist_mode = ui.reference('rage', 'Other', 'Quick peek assist mode'),
            anti_aim_correction = ui.reference('rage', 'Other', 'Anti-aim correction'),
            prefer_baim = ui.reference('rage', 'Aimbot', 'Prefer body aim'),
            prefer_baim_disablers = ui.reference('rage', 'Aimbot', 'Prefer body aim disablers'),
            force_baim = ui.reference('rage', 'Aimbot', 'Force body aim'),
            force_baim_peek = ui.reference('rage', 'Aimbot', 'Force body aim on peek'),
            fake_duck = ui.reference('rage', 'Other', 'Duck peek assist'),
            double_tap = { ui.reference('rage', 'Aimbot', 'Double tap') },
            double_tap_hc = ui.reference('rage', 'Aimbot', 'Double tap hit chance'),
            double_tap_limit = ui.reference('rage', 'Aimbot', 'Double tap fake lag limit'),
            double_tap_quick_stop = ui.reference('rage', 'Aimbot', 'Double tap quick stop'),
        },
    
        aa = {
            main = {
                enabled = ui.reference('aa', 'Anti-aimbot angles', 'Enabled'),
                pitch = { ui.reference('aa', 'Anti-aimbot angles', 'Pitch') },
                yawbase = ui.reference('aa', 'Anti-aimbot angles', 'Yaw base'),
                yaw = { ui.reference('aa', 'Anti-aimbot angles', 'Yaw') },
                yaw_jitter = { ui.reference('aa', 'Anti-aimbot angles', 'Yaw jitter') },
                body_yaw = { ui.reference('aa', 'Anti-aimbot angles', 'Body yaw') },
                fs_body_yaw = ui.reference('aa', 'Anti-aimbot angles', 'Freestanding body yaw'),
                roll = ui.reference('aa', 'Anti-aimbot angles', 'Roll'),
                freestanding = { ui.reference('aa', 'Anti-aimbot angles', 'Freestanding') },
                edge_yaw = ui.reference('aa', 'Anti-aimbot angles', 'Edge yaw'),
            },

            other = {
                slow_motion = { ui.reference('aa', 'Other', 'Slow motion') },
                on_shot = { ui.reference('aa', 'Other', 'On shot anti-aim') },
                leg_movement = ui.reference('aa', 'Other', 'Leg movement'),
                fake_peek = { ui.reference('aa', 'Other', 'Fake peek') }
            },

            fl = {
                amount = ui.reference('aa', 'Fake lag', 'Amount'),
                limit = ui.reference('aa', 'Fake lag', 'Limit'),
                var = ui.reference('aa', 'Fake lag', 'Variance')
            }
        },
    
        misc = {
            bunny_hop = ui.reference('misc', 'Movement', 'Bunny hop'),
            infinite_duck = ui.reference('misc', 'Movement', 'Infinite duck'),
            clan_tag = ui.reference('misc', 'Miscellaneous', 'Clan tag spammer'),
            ping_spike = { ui.reference('misc', 'Miscellaneous', 'Ping Spike') },
            anti_untrusted = ui.reference('misc', 'Settings', 'Anti-untrusted')
        },
    
        visuals = {
            remove_scope = ui.reference('visuals', 'Effects', 'Remove scope overlay')
        },
        
        playerlist = {
            reset_all = ui.reference('players', 'Players', 'Reset all'),
            player = ui.reference('players', 'Players', 'Player list')
        }
    }

    eternal.cache = {
        cfg_database = readfile('csgo/eternal/eternal_rage_semi_cfg.json'),
        bomb_time = 0,

        roll_players = {},

        ct_menu = '[' .. eternal.colorful_text:text({{111, 168, 214}, 'CT'}) .. '] - ',
        t_menu = '[' .. eternal.colorful_text:text({{240, 146, 53}, 'T'}) .. '] - ',

        on_ladder = false,
        in_air = false,

        swap = false,
        exploit_count = 0,

        hitgroups_to_hitboxes = {
            ['Head'] = { 0 },
            ['Chest'] = { 4, 5, 6 },
            ['Stomach'] = { 2, 3 },
            ['Arms'] = { 13, 14, 15, 16, 17, 18 },
            ['Legs'] = { 7, 8, 9, 10 },
            ['Feet'] = { 11, 12 }
        },

        allowed_hitboxes = {
            0, 4, 5, 6, 2, 3, 15, 17
        },

        side_angle = 0,
        side_peek = { 90, 270 },

        slow = {
            last_tick = 0,
            jitter = false
        },

        def_slow = {
            last_tick = 0,
        },

        is_defusing = false,
        last_movement = 0,

        current_choke = 0,
        game_state_api = panorama.open().GameStateAPI, spaced_string = '', values = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }, is_menu_open = false, cfg_string = '',
        smoke_hitboxes = { 0, 11, 12, 13, 14 }, visibility_directions = { { 0.0, 0.0 }, { 30.0, 0.0 }, { -30.0, 0.0 }, { 0.0, 30.0 }, { 0.0, -30.0 } }, whitelist = {}, smoke_exists = false,
        hitscan = { ['Head'] = { 0, 1 }, ['Chest'] = { 5, 6 }, ['Stomach'] = { 2, 3, 4 }, ['Arms'] = { 13, 14, 15, 16, 17, 18 }, ['Legs'] = { 7, 8, 9, 10 }, ['Feet'] = { 11, 12 } },

        player_states = { 'Global', 'Stand', 'Duck', 'Duck walk', 'Slow', 'Walk', 'In-Air', 'Lean', 'Dormant', 'Sideways', 'Warmup' },
        fake_lag_states = { 'Global', 'Jitter', 'Walk', 'Slow', 'Peek' },

        awall_data = 'None',
        l_auto_wall = false,
        auto_wall = false,

        active_preset = 'Global',
        fl_preset = 'Global',
        player_state = 'Stand',

        hitgroup_names = {'body', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'},
        hitbox_table = { 'Head', 'Chest', 'Stomach', 'Arms', 'Legs', 'Feet' },
        clan_tag_reset = false,
        
        hittable_ticks = 0,
        enemies = {},
        roll_data = {},

        lp_velocity = 0,
        lp_team = 'Counter-Terrorists',

        contains = {
            lean_sideways = false,
            lean_hotkey = false,

            shots = {
                hits = false,
                misses = false,
                panel = false,
                on_screen = false,
                console = false
            },

            indicator_options = {
                keybinds = false,
                body_yaw_amount = false,
                body_yaw_side = false,
                arrows = false
            },

            crosshair_keybinds = {
                fov = false,
                on_shot = false,
                freestand = false,
                safe_point = false,
                force_baim = false,
                fake_duck = false,
                ping_spike = false,
                pitch_override = false,
                damage_override = false,
                body_lean = false
            },

            panel_options = {
                watermark = false,
                debug_panel = false,
                pulsate = false
            },

            watermark_options = {
                build = false,
                latency = false,
                time = false
            },

            ab_disablers = {
                flashed = false,
                in_smoke = false
            },

            animation_select = {
                static_legs_air = false,
                static_legs_slow = false,
                moonwalk = false
            },

            peek = {
                include_dormant = false,
                exclude_limbs = false,
                prediction = false,
                crosshair = false
            },

            tabs = {
                aa = false,
                visual = false,
                misc = false
            },

            anti_flicker = {
                unstable_internet = false,
                holding_grenade = false,
                fake_duck = false
            }
        },

        should_optimize = false,
        safety = false,

        master_switch = false,
        navigator = false,

        local_player = nil,
        fs_disabled = false,

        threat = nil,
        threat_ping = 0,
        threat_dist = 0,
        threat_name = 'Unknown',

        last_press_t_dir = 0,
        yaw_direction = 0,
        
        peek_threat = nil,
        ground_ticks = 0,
        end_time = 0,

        last_flash_update = 0,

        fs_ticks_ran = 0,
        side = 0,
        peeked = false,
        vulnerable = false,

        desync = 0,
        desync_side == 'Left',
        desync_amount = 0,
        
        lean_anim = 0,
        scope_width = 0,
        is_scoped = false,
        
        watermark_width = 0,
        watermark_textwidth = 0,
        watermark_adder = 0,

        debug_panel = { w = 100, h = 55, dragging = false },
        screen_size = eternal.includes.vector(0, 0),

        socket = nil,
        eternal_users = {}
    }
    
    eternal.socket = {
        open = function(ws)
            client.delay_call(1, function()
                if entity.get_steam64(eternal.cache.local_player) ~= nil then
                    ws:send(json.stringify({
                        ['steam_id'] = entity.get_steam64(eternal.cache.local_player),
                        ['platform'] = 'GS',
                    }))
                end
            end)
    
            eternal.cache.socket = ws
        end,
    
        message = function(ws, data)
            if globals.mapname() ~= nil and eternal.cache.local_player then
                local player_resource = entity.get_player_resource()
                eternal.cache.eternal_users = json.parse(data)
    
                for ent = 1, globals.maxplayers() do
                    if entity.get_classname(ent) == 'CCSPlayer' then
                        for i = 1, #eternal.cache.eternal_users do
                            if eternal.cache.eternal_users[i].steam_id == entity.get_steam64(ent) then
                                entity.set_prop(player_resource, 'm_nPersonaDataPublicLevel', eternal.cache.eternal_users[i].platform == 'GS' and '8863621' or '8863622', ent)
                            end
                        end
                    end
                end
            end
        end,
    
        close = function(ws, code, reason, was_clean)
            eternal.cache.socket = nil
        end,
        
        error = function(ws, err)
            eternal.cache.socket = nil
        end
    }

    eternal.memory = {
        line_goes_through_smoke = ffi.cast(ffi.typeof('bool(__cdecl*)(float flFromX, float flFromY, float flFromZ, float flToX, float flToY, float flToZ)'), client.find_signature('client.dll', '\x55\x8B\xEC\x83\xEC\x08\x8B\x15\xCC\xCC\xCC\xCC\x0F')),
        gamerules = ffi.cast('intptr_t**', ffi.cast('intptr_t', client.find_signature('client.dll', '\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1')) + 2)[0],
        vgui_system = ffi.cast(ffi.typeof('void***'), client.create_interface('vgui2.dll', 'VGUI_System010')),
        get_client_entity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)'),
        animation_layer_t = ffi.typeof([[
            struct {										char pad_0x0000[0x18];
                uint32_t	sequence;
                float		prev_cycle;
                float		m_flWeight;
                float		m_flWeightDeltaRate;
                float		m_flPlaybackRate;
                float		m_flCycle;
                void		*entity;						char pad_0x0038[0x4];
            } **
        ]]),

        native_netchaninfo = vtable_bind('engine.dll', 'VEngineClient014', 78, 'void*(__thiscall*)(void*)'),
        native_get_avg_loss = vtable_thunk(11, 'float(__thiscall*)(void*, int)'),
        native_get_avg_choke = vtable_thunk(12, 'float(__thiscall*)(void*, int)'),
        native_get_address = vtable_thunk(1, 'const char*(__thiscall*)(void*)')
    }

    eternal.func = {
        file_sys = function()
            local a=ffi.cast(ffi.typeof('void***'),client.create_interface('filesystem_stdio.dll','VBaseFileSystem011'))local b=ffi.cast(ffi.typeof('void***'),client.create_interface('filesystem_stdio.dll','VFileSystem017'))local c=ffi.cast('int(__thiscall*)(void*, void const*, int, void*)',a[0][1])local d=ffi.cast('void*(__thiscall*)(void*, const char*, const char*, const char*)',a[0][2])local e=ffi.cast('void(__thiscall*)(void*, void*)',a[0][3])local f=ffi.cast('bool(__thiscall*)(void*, const char*, const char*)',a[0][10])local g=ffi.cast('void(__thiscall*)(void*, const char*, const char*, int)',b[0][11])local h=ffi.cast('void(__thiscall*)(void*, const char*, const char*)',b[0][22])local i=ffi.cast('bool(__thiscall*)(void*, const char*, const char*)',b[0][23])local j=ffi.cast('bool(__thiscall*)(void*, char*, int)',client.find_signature('filesystem_stdio.dll','\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C'))local k=ffi.cast(ffi.typeof('void***'),client.create_interface('vgui2.dll','VGUI_System010'))local l=ffi.cast('int(__thiscall*)(void*)',k[0][7])local m=ffi.cast('int(__thiscall*)(void*, int,  char*, int)',k[0][11])local n=l(k)local o=ffi.new('char[?]',n)m(k,0,o,n*ffi.sizeof('char[?]',n))local p=ffi.typeof('char[?]')(128)j(b,p,ffi.sizeof(p))p=ffi.string(p)g(b,p,'MOD',0)local q={}q.__index=q;function q.exists(r,s)return f(a,r,s)end;function q.create_dir(p,s)h(b,p,s)end;function q.is_dir(p,s)return i(b,p,s)end;local t={['r']='r',['w']='w',['a']='a',['r+']='r+',['w+']='w+',['a+']='a+',['rb']='rb',['wb']='wb',['ab']='ab',['rb+']='rb+',['wb+']='wb+',['ab+']='ab+'}function q.open(r,u,s)if not t[u]then error('invalid mode #2',2)end;local self=setmetatable({file=r,mode=u,path_id=s,handle=d(a,r,u,s)},q)if self.handle==-1 then error('wrong file error #1',2)end;return self end;function q:write(v)c(a,v,#v,self.handle)end;function q:close()e(a,self.handle)end

            if not q.is_dir('/eternal') then
                q.create_dir('/eternal')
            end

            --> GS icon
            if not readfile('csgo/materials/panorama/images/icons/xp/level8863621.png') then
                http.get('https://i.imgur.com/W5hnEVf.png', function(w, x)
                    if not w or x.status ~= 200 then
                        return
                    end

                    local y = q.is_dir('/materials/panorama/images/icons/xp')

                    if not y then
                        q.create_dir('/materials/panorama/images/icons/xp')
                    end

                    local z = q.open('/materials/panorama/images/icons/xp/level8863621.png', 'wb+')
                    z:write(x.body)
                    z:close()
                end)
            end

            --> NL icon
            if not readfile('csgo/materials/panorama/images/icons/xp/level8863622.png') then
                http.get('https://i.imgur.com/HEVMZM8.png', function(w, x)
                    if not w or x.status ~= 200 then
                        return
                    end

                    local y = q.is_dir('/materials/panorama/images/icons/xp')

                    if not y then
                        q.create_dir('/materials/panorama/images/icons/xp')
                    end

                    local z = q.open('/materials/panorama/images/icons/xp/level8863622.png', 'wb+')
                    z:write(x.body)
                    z:close()
                end)
            end
        end,

        fetch_server = function()
            if not globals.mapname() then
                return nil
            end
        
            local net_channel_info = eternal.memory.native_netchaninfo()
            local server_address = ffi.string(eternal.memory.native_get_address(net_channel_info))
        
            return server_address
        end,

        teamskeet_arrow = LPH_JIT_MAX(function(x, y, r1, g1, b1, a1, r2, g2, b2, a2)
            renderer.rectangle(x + 38, y - 7, 2, 18, eternal.cache.desync_side == 'Right' and r1 or 35, eternal.cache.desync_side == 'Right' and g1 or 35, eternal.cache.desync_side == 'Right' and b1 or 35, eternal.cache.desync_side == 'Right' and a1 or 150)
            renderer.rectangle(x - 40, y - 7, 2, 18, eternal.cache.desync_side == 'Left' and r1 or 35, eternal.cache.desync_side == 'Left' and g1 or 35, eternal.cache.desync_side == 'Left' and b1 or 35, eternal.cache.desync_side == 'Left' and a1 or 150)
        
            renderer.triangle(x + 55, y + 2, x + 42, y - 7, x + 42, y + 11, eternal.cache.yaw_direction == 90 and r2 or 35, eternal.cache.yaw_direction == 90 and g2 or 35, eternal.cache.yaw_direction == 90 and b2 or 35, eternal.cache.yaw_direction == 90 and a2 or 150)
            renderer.triangle(x - 55, y + 2, x - 42, y - 7, x - 42, y + 11, eternal.cache.yaw_direction == -90 and r2 or 35, eternal.cache.yaw_direction == -90 and g2 or 35, eternal.cache.yaw_direction == -90 and b2 or 35, eternal.cache.yaw_direction == -90 and a2 or 150)
        end),

        eq = function(a, b)
            local function c()return a end;local function d()return b end;return rawequal(a,b)and a==b and b==a and not b~=a and not a~=b and rawequal(d(),c())and c()==d()and not c()~=d()
        end,

        lerp = LPH_NO_VIRTUALIZE(function(b,c,d)
            if type(b)=='table' and type(c)=='table'then 
                return{eternal.func.lerp(b[1],c[1],d),eternal.func.lerp(b[2],c[2],d),eternal.func.lerp(b[3],c[3],d)}
            end
            
            return b+(c-b)*d
        end),

        contains = LPH_NO_VIRTUALIZE(function(tbl, item)
            for i, v in next, tbl do
                if v == item then
                    return true
                end
            end

            return false
        end),

        intersect = LPH_NO_VIRTUALIZE(function(x, y, w, h, debug) 
            local cx, cy = ui.mouse_position()
            
            return cx >= x and cx <= x + w and cy >= y and cy <= y + h
        end),

        renderer_multi_text = LPH_JIT_MAX(function(x, y, flags, space, data)
            local width = 0
        
            for i in ipairs(data) do
                local text, color = data[i].text, data[i].color
        
                if i == 1 then
                    renderer.text(x + width + space*i, y, color[1], color[2], color[3], color[4], flags, nil, text)
                else
                    renderer.text(x + width + space*i, y, color[1], color[2], color[3], color[4], flags, nil, text)
                end
        
                width = width + renderer.measure_text(flags, text)
            end
        end),

        round = LPH_NO_VIRTUALIZE(function(num)
            return math.floor(num + 0.5)
        end),

        blend_console_log = LPH_NO_VIRTUALIZE(function(b,c,d)
            local e,f,g=b[1],b[2],b[3]local h,i,j=c[1],c[2],c[3]
            
            for k=1,#d do 
                local l=eternal.func.lerp(b,c,k/#d)client.color_log(l[1],l[2],l[3],d:sub(k,k)..'\0')
            end
        end),

        clamp = LPH_NO_VIRTUALIZE(function(v, mn, mx)
            return v < mn and mn or v > mx and mx or v
        end),

        between = LPH_NO_VIRTUALIZE(function(v, min, max)
            return v > min and v < max
        end),

        pulsate = LPH_NO_VIRTUALIZE(function(initial)
            return eternal.func.clamp(math.sin(math.abs(math.pi+(globals.realtime())%(-math.pi*2)))*initial, 75, initial)
        end),

        exec = LPH_JIT_MAX(function(func, tab)
            for k, v in pairs(tab) do
                func(k, v)
            end
        end),

        normalize = LPH_NO_VIRTUALIZE(function(yaw)
            yaw = (yaw % 360 + 360) % 360
            return yaw > 180 and yaw - 360 or yaw
        end),

        entity_has_c4 = LPH_JIT(function(ent)
            local bomb = entity.get_all('CC4')[1]
        
            return bomb ~= nil and entity.get_prop(bomb, 'm_hOwnerEntity') == ent
        end),

        distance_3d = LPH_NO_VIRTUALIZE(function(x1, y1, z1, x2, y2, z2)
            return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
        end),

        set_clipboard = function(string)
            local set_clipboard_text = ffi.cast('set_clipboard_text', eternal.memory.vgui_system[0][9])
            set_clipboard_text(eternal.memory.vgui_system, string, #string)
        end,

        fetch_clipboard = function()
            local get_clipboard_text_count = ffi.cast('get_clipboard_text_count', eternal.memory.vgui_system[0][7])
            local get_clipboard_text = ffi.cast('get_clipboard_text', eternal.memory.vgui_system[0][11])

            local clipboard_text_length = get_clipboard_text_count(eternal.memory.vgui_system)
            local clipboard_data = ''
        
            if clipboard_text_length > 0 then
                buffer = ffi.new('char[?]', clipboard_text_length)
                size = clipboard_text_length * ffi.sizeof('char[?]', clipboard_text_length)
        
                get_clipboard_text(eternal.memory.vgui_system, 0, buffer, size)
                clipboard_data = ffi.string(buffer, clipboard_text_length - 1)
            end
        
            return clipboard_data
        end,

        xorstr = LPH_JIT(function(str, key)
            local strlen, keylen = #str, #key
        
            local strbuf = ffi.new('char[?]', strlen+1)
            local keybuf = ffi.new('char[?]', keylen+1)
        
            ffi.copy(strbuf, str)
            ffi.copy(keybuf, key)
        
            for i=0, strlen-1 do
                strbuf[i] = bit.bxor(strbuf[i], keybuf[i % keylen])
            end
        
            return ffi.string(strbuf, strlen)
        end),

        default_visibility = LPH_JIT_MAX(function(visible)
            ui.set_visible(eternal.ref.aa.main.enabled, visible)
            ui.set_visible(eternal.ref.aa.main.pitch[1], visible)
            ui.set_visible(eternal.ref.aa.main.pitch[2], visible and ui.get(eternal.ref.aa.main.yaw[1]) == 'Custom')
            ui.set_visible(eternal.ref.aa.main.yawbase, visible)
            ui.set_visible(eternal.ref.aa.main.yaw[1], visible)
            ui.set_visible(eternal.ref.aa.main.yaw[2], visible and ui.get(eternal.ref.aa.main.yaw[1]) ~= 'Off')
            ui.set_visible(eternal.ref.aa.main.yaw_jitter[1], visible and ui.get(eternal.ref.aa.main.yaw[1]) ~= 'Off')
            ui.set_visible(eternal.ref.aa.main.yaw_jitter[2], visible and ui.get(eternal.ref.aa.main.yaw[1]) ~= 'Off' and ui.get(eternal.ref.aa.main.yaw_jitter[1]) ~= 'Off')
            ui.set_visible(eternal.ref.aa.main.edge_yaw, visible)
            ui.set_visible(eternal.ref.aa.main.freestanding[1], visible)
            ui.set_visible(eternal.ref.aa.main.freestanding[2], visible)
            ui.set_visible(eternal.ref.aa.main.body_yaw[1], visible)
            ui.set_visible(eternal.ref.aa.main.body_yaw[2], visible and (ui.get(eternal.ref.aa.main.body_yaw[1]) == 'Static' or ui.get(eternal.ref.aa.main.body_yaw[1]) == 'Jitter'))
            ui.set_visible(eternal.ref.aa.main.fs_body_yaw, visible and ui.get(eternal.ref.aa.main.body_yaw[1]) ~= 'Off')
            ui.set_visible(eternal.ref.aa.main.roll, visible)
        
            ui.set_visible(eternal.ref.aa.fl.limit, visible)
            ui.set_visible(eternal.ref.aa.fl.var, visible)
            ui.set_visible(eternal.ref.aa.fl.amount, visible)

            ui.set_visible(eternal.ref.misc.clan_tag, visible)

            ui.set_visible(eternal.ref.aa.other.fake_peek[1], visible)
            ui.set_visible(eternal.ref.aa.other.fake_peek[2], visible)

            local hitbox_selection = ui.get(eternal.menu.misc.hitbox_selection)

            if visible then
                ui.set_visible(eternal.ref.rage.target_hitbox, true)
            else
                ui.set_visible(eternal.ref.rage.target_hitbox, hitbox_selection == 'Default')
            end
        end),

        eternal_visibility = LPH_JIT_MAX(function(visible, navigator)
            local anti_aim_master = ui.get(eternal.menu.anti_aim.aa_master)
            local dynamic_fov = ui.get(eternal.menu.misc.dynamic_fov)

            local current_team = ui.get(eternal.menu.anti_aim.current_team)
            local current_state = ui.get(eternal.menu.anti_aim.current_state)
            local tab_selection = ui.get(eternal.menu.anti_aim.tab_selection)
            local peek_switch = ui.get(eternal.menu.misc.peek_switch)

            local manual_enable = ui.get(eternal.menu.misc.manual_enable)
            local alpha_feature = (obex_data.build == 'Alpha' or obex_data.build == 'Nightly' or obex_data.build == 'Source')
            local beta_feature = obex_data.build ~= 'Stable'

            eternal.func.exec(ui.set_visible, {
                [eternal.menu.main.resolver] = visible and obex_data.build ~= 'Stable',

                [eternal.menu.anti_aim.aa_master] = visible and navigator == 'Anti-aim',
                [eternal.menu.anti_aim.tab_selection] = visible and navigator == 'Anti-aim' and anti_aim_master,

                [eternal.menu.anti_aim.current_team] = visible and navigator == 'Anti-aim' and anti_aim_master and tab_selection == 'Constructor',
                [eternal.menu.anti_aim.current_state] = visible and navigator == 'Anti-aim' and anti_aim_master and tab_selection == 'Constructor',

                [eternal.menu.anti_aim.lean_enablers] = visible and navigator == 'Anti-aim' and anti_aim_master and tab_selection == 'Additional',
                [eternal.menu.anti_aim.lean_hotkey] = visible and navigator == 'Anti-aim' and anti_aim_master and eternal.cache.contains.lean_hotkey and tab_selection == 'Additional',

                [eternal.menu.anti_aim.pitch_hotkey] = visible and navigator == 'Anti-aim' and anti_aim_master and tab_selection == 'Additional',
                [eternal.menu.anti_aim.anti_flicker] = visible and navigator == 'Anti-aim' and anti_aim_master and tab_selection == 'Additional',

                [eternal.menu.anti_aim.at_targets] = visible and navigator == 'Anti-aim' and anti_aim_master and tab_selection == 'Additional',
                [eternal.menu.anti_aim.lower_body_yaw] = visible and navigator == 'Anti-aim' and anti_aim_master and tab_selection == 'Additional',

                [eternal.menu.anti_aim.current_fl_state] = visible,
                [eternal.menu.anti_aim.on_shot_aa_settings] = visible,
                [eternal.menu.anti_aim.on_shot_aa_hotkey] = visible,

                [eternal.ref.aa.other.on_shot[1]] = not visible,
                [eternal.ref.aa.other.on_shot[2]] = not visible,

                [eternal.menu.visual.indicator_options] = visible and navigator == 'Visual',
                [eternal.menu.visual.crosshair_keybinds] = visible and navigator == 'Visual' and eternal.cache.contains.indicator_options.keybinds,
                [eternal.menu.visual.arrow_options] = visible and navigator == 'Visual' and eternal.cache.contains.indicator_options.arrows,

                [eternal.menu.visual.main_color_label] = visible and navigator == 'Visual',
                [eternal.menu.visual.main_indicator_color]= visible and navigator == 'Visual',
                [eternal.menu.visual.secondary_indicator_color] = visible and navigator == 'Visual',
                [eternal.menu.visual.secondary_color_label] = visible and navigator == 'Visual',
                
                [eternal.menu.visual.custom_logs] = visible and navigator == 'Visual',
                [eternal.menu.visual.custom_log_additive] = visible and navigator == 'Visual' and eternal.cache.contains.shots.on_screen,

                [eternal.menu.visual.panel_options] = visible and navigator == 'Visual',
                [eternal.menu.visual.watermark_options] = visible and navigator == 'Visual' and eternal.cache.contains.panel_options.watermark,  

                [eternal.menu.visual.debug_panel_x] = false,
                [eternal.menu.visual.debug_panel_y] = false,

                [eternal.menu.misc.minimum_fov] = dynamic_fov,
                [eternal.menu.misc.maximum_fov] = dynamic_fov,
                [eternal.menu.misc.fov_scale] = dynamic_fov,

                [eternal.menu.misc.aimbot_disablers] = visible and navigator == 'Misc',

                [eternal.menu.misc.auto_fire_master] = visible and navigator == 'Misc',
                [eternal.menu.misc.auto_fire_key] = visible and navigator == 'Misc',

                [eternal.menu.misc.auto_wall_master] = visible and navigator == 'Misc',
                [eternal.menu.misc.auto_wall_key] = visible and navigator == 'Misc',

                [eternal.menu.misc.visible_hitbox] = visible and navigator == 'Misc',
                [eternal.menu.misc.animation_select] = visible and navigator == 'Misc',

                [eternal.menu.misc.fs_hotkey] = visible and navigator == 'Misc',
                [eternal.menu.misc.fs_disablers] = visible and navigator == 'Misc',
                [eternal.menu.misc.fs_exclude] = visible and navigator == 'Misc',

                [eternal.menu.misc.peek_switch] = visible and navigator == 'Misc' and alpha_feature,
                [eternal.menu.misc.peek_default_hotkey] = visible and navigator == 'Misc' and peek_switch and alpha_feature,
                [eternal.menu.misc.peek_return] = visible and navigator == 'Misc' and peek_switch and alpha_feature,
                [eternal.menu.misc.quick_peek_return] = visible and navigator == 'Misc' and peek_switch and alpha_feature,
                [eternal.menu.misc.peek_options] = visible and navigator == 'Misc' and peek_switch and alpha_feature,

                [eternal.menu.misc.manual_enable] = visible and navigator == 'Misc',
                [eternal.menu.misc.manual_left_hotkey] = visible and navigator == 'Misc' and manual_enable,
                [eternal.menu.misc.manual_right_hotkey] = visible and navigator == 'Misc' and manual_enable,
                [eternal.menu.misc.manual_forward_hotkey] = visible and navigator == 'Misc' and manual_enable,

                [eternal.menu.misc.console_filtering] = visible and navigator == 'Misc',
                [eternal.menu.misc.clan_tag] = visible,

                [eternal.menu.cfg.storage] = visible and navigator == 'Cfg',
                [eternal.menu.cfg.list] = visible and navigator == 'Cfg',
                [eternal.menu.cfg.tabs] = visible and navigator == 'Cfg',
                [eternal.menu.cfg.load] = visible and navigator == 'Cfg',
                [eternal.menu.cfg.delete] = visible and navigator == 'Cfg',
                [eternal.menu.cfg.save] = visible and navigator == 'Cfg',
                [eternal.menu.cfg.import] = visible and navigator == 'Cfg',
                [eternal.menu.cfg.export] = visible and navigator == 'Cfg'
            })

            if navigator == 'Anti-aim' and visible then
                for a, b in pairs(eternal.menu.anti_aim.states[current_team]) do
                    if a == current_state then
                        local should_show = ui.get(eternal.menu.anti_aim.aa_master) and tab_selection == 'Constructor' and (ui.get(b.enable_state) or a == 'Global' or a == 'Sideways')
                        local state_type = ui.get(b.state_type)
                        local chosen_type = ui.get(b.chosen_type)
                        
                        local side = state_type == 'Binary' and chosen_type or 'Left'
                        ui.set_visible(b.enable_state, ui.get(eternal.menu.anti_aim.aa_master) and tab_selection == 'Constructor' and a ~= 'Global' and a ~= 'Legit' and a ~= 'Sideways')
                        ui.set_visible(eternal.menu.misc.transport, should_show and state_type ~= 'Preset' or (state_type ~= 'Preset' and a == 'Legit'))
                    end
                end
            else
                ui.set_visible(eternal.menu.misc.transport, false)
            end

            if visible then
                for a, b in pairs(eternal.menu.anti_aim.fl_states) do
                    if a == ui.get(eternal.menu.anti_aim.current_fl_state) then
                        ui.set_visible(b.enable_state, a ~= 'Global')
                    end
                end
            end
        end),

        setup = LPH_JIT_MAX(function(list, element, visible)
            for k, v in pairs(list) do
                local active = k == element
                local mode = list[k]

                if type(mode) == 'table' then
                    for j in pairs(mode) do
                        ui.set_visible(mode[j], active and visible)
                    end
                end
            end
        end),

        vis = LPH_JIT_MAX(function(list, element, visible)
            for k, v in pairs(list) do
                local active = k == element
                local mode = list[k]

                if type(v) == 'table' then
                    for i, j in pairs(mode) do
                        local state_type = ui.get(mode.state_type)
                        local enable_state = ui.get(mode.enable_state) or k == 'Global' or k == 'Legit' or k == 'Sideways'
                        
                        if i == 'Left' or i == 'Right' then
                            for x, y in pairs(j) do
                                if type(y) == 'table' then
                                    for xx, yy in pairs(y) do
                                        if type(yy) == 'table' then
                                            for xxx, yyy in pairs(yy) do
                                                if state_type == 'Binary' then
                                                    ui.set_visible(yyy, ui.get(mode.chosen_type) == i and active and visible and enable_state and state_type ~= 'Preset')
                                                else
                                                    ui.set_visible(yyy, i == 'Left' and active and visible and enable_state and state_type ~= 'Preset')
                                                end
                                            end
                                        else
                                            if state_type == 'Binary' then
                                                ui.set_visible(yy, ui.get(mode.chosen_type) == i and active and visible and enable_state and state_type ~= 'Preset')
                                            else
                                                ui.set_visible(yy, i == 'Left' and active and visible and enable_state and state_type ~= 'Preset')
                                            end
                                        end
                                    end
                                else
                                    if state_type == 'Binary' then
                                        ui.set_visible(y, ui.get(mode.chosen_type) == i and active and visible and enable_state and state_type ~= 'Preset')
                                    else
                                        ui.set_visible(y, i == 'Left' and active and visible and enable_state and state_type ~= 'Preset')
                                    end
                                end
                            end
                        else
                            if i == 'enable_state' then
                                ui.set_visible(j, active and visible)
                            elseif i == 'state_type' then
                                ui.set_visible(j, active and visible and enable_state)
                            elseif i == 'chosen_type' then
                                ui.set_visible(j, active and visible and enable_state and state_type == 'Binary')
                            else
                                ui.set_visible(j, active and visible and enable_state and state_type ~= 'Preset')
                            end
                        end
                    end
                end
            end
        end),

        get_ping = LPH_JIT(function(player_resource, player)
            return player == nil and 0 or entity.get_prop(player_resource, string.format('%03d', player))
        end),
        
        run_direction = LPH_JIT(function()
            ui.set(eternal.ref.aa.main.edge_yaw, false)
            eternal.cache.fs_disabled = eternal.func.contains(ui.get(eternal.menu.misc.fs_disablers), eternal.cache.player_state)
        
            if ui.get(eternal.menu.misc.fs_hotkey) and not eternal.cache.fs_disabled then
                ui.set(eternal.ref.aa.main.freestanding[1], true)
                ui.set(eternal.ref.aa.main.freestanding[2], 'Always on')
            else
                ui.set(eternal.ref.aa.main.freestanding[1], false)
                ui.set(eternal.ref.aa.main.freestanding[2], 'On hotkey')
            end
        
            if ui.get(eternal.menu.misc.fs_hotkey) or not ui.get(eternal.menu.misc.manual_enable) then
                eternal.cache.yaw_direction = 0
                eternal.cache.last_press_t_dir = globals.curtime()
            else
                if ui.get(eternal.menu.misc.manual_forward_hotkey) then
                    eternal.cache.yaw_direction = 0
                elseif ui.get(eternal.menu.misc.manual_right_hotkey) and eternal.cache.last_press_t_dir + 0.2 < globals.curtime() then
                    eternal.cache.yaw_direction = eternal.cache.yaw_direction == 90 and 0 or 90
                    eternal.cache.last_press_t_dir = globals.curtime()
                elseif ui.get(eternal.menu.misc.manual_left_hotkey) and eternal.cache.last_press_t_dir + 0.2 < globals.curtime() then
                    eternal.cache.yaw_direction = eternal.cache.yaw_direction == -90 and 0 or -90
                    eternal.cache.last_press_t_dir = globals.curtime()
                elseif eternal.cache.last_press_t_dir > globals.curtime() then
                    eternal.cache.last_press_t_dir = globals.curtime()
                end
            end
        end),

        gamesense_animation = LPH_JIT_MAX(function(text, indices)
            local text_anim = '               ' .. text .. '                      ' 
            local tickinterval = globals.tickinterval()
            local tickcount = globals.tickcount() + toticks(client.real_latency())
            local i = tickcount / toticks(0.3)
        
            i = math.floor(i % #indices)
            i = indices[i+1]+1
        
            return string.sub(text_anim, i, i + 15)
        end),

        run_tag_animation = LPH_JIT_MAX(function()    
            local clan_tag = eternal.func.gamesense_animation('eternal.codes', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 14, 14, 14, 14, 14, 14, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27})
        
            if clan_tag ~= clan_tag_prev then
                client.set_clan_tag(clan_tag)
            end
        
            clan_tag_prev = clan_tag
        end),

        is_hittable = LPH_JIT_MAX(function(weapon)      
            if not weapon or eternal.cache.threat == nil or weapon.type == 'knife' then 
                return false 
            end
        
            local esp_data = entity.get_esp_data(eternal.cache.threat)
        
            if esp_data == nil then 
                return false 
            end

            local flag = bit.band(esp_data.flags, 2048)

            if flag == 2048 then
                return true
            end
        
            return false
        end),

        fix_bots = LPH_JIT(function(ent)            
            if eternal.cache.game_state_api.IsFakePlayer(eternal.cache.game_state_api.GetPlayerXuidStringFromEntIndex(ent)) then
                plist.set(ent, 'Correction active', false)
            end
        end),

        get_angle = LPH_JIT(function(ent)
            if (not plist.get(ent, 'Correction active') and eternal.cache.local_player ~= ent) and ent then
                return 0
            end
        
            return eternal.func.clamp(entity.get_prop(ent, 'm_flPoseParameter', 11) * 120 - 60, -58, 58)
        end),

        anti_backstab = LPH_JIT_MAX(function(weapon)
            if eternal.cache.threat == nil or weapon == nil then 
                return false 
            end
        
            if weapon.type == 'knife' then
                local lp_origin = eternal.includes.vector(entity.get_origin(eternal.cache.local_player))
                local enemy_origin = eternal.includes.vector(entity.get_origin(eternal.cache.threat))
                            
                return eternal.func.distance_3d(enemy_origin.x, enemy_origin.y, enemy_origin.z, lp_origin.x, lp_origin.y, lp_origin.z) < 225
            end

            return false
        end),

        outline = LPH_JIT(function(x, y, w, h, r, g, b, a)
            renderer.rectangle(x - 1, y - 1, w + 2, 1, r, g, b, a) renderer.rectangle(x - 1, y + h, w + 2, 1, r, g, b, a) renderer.rectangle(x - 1, y, 1, h, r, g, b, a) renderer.rectangle(x + w, y, 1, h, r, g, b, a)
        end),

        notify = {
            add = LPH_JIT_MAX(function(self, type, ...)
                table.insert(self.items, {
                    ['text'] = table.concat({...}, ''),
                    ['time'] = self.time,
                    ['type'] = type or 'info',
                    ['a'] = 255.0,
                });
            end),
            setup = LPH_JIT_MAX(function(self, data)
                self.max_logs = data.max_logs or 10
                self.position = data.position or { 8, 5 }
                self.time = data.time or 6.0
                self.images = data.images or false
                self.center_additive = data.center_additive or 0
                self.simple = data.simple or false
                self.items = self.items or {}
            end),
            think = LPH_JIT_MAX(function(self)
                if #self.items <= 0 then 
                    return 
                end
        
                if #self.items > self.max_logs then
                    table.remove(self.items, 1);
                end
        
                for i, v in ipairs(self.items) do
                    v.time = v.time - globals.frametime();
                    if v.time <= 0 then
                        table.remove(self.items, i);
                    end
                end
        
                local s_w, s_h = client.screen_size();
                local c_w, c_h = s_w * 0.5, s_h * 0.5;
        
                local x, y, w, h, offset = 0, 0, 0, 0, { 5, 2 }
                local text = ''
                local f = 0.0
        
                if self.simple then
                    offset = { 0, 0 }
                end
        
                local scale = 0.65
                local r1, g1, b1, a1 = ui.get(eternal.menu.visual.main_indicator_color)
                local r2, g2, b2, a1 = ui.get(eternal.menu.visual.secondary_indicator_color)
        
                x, y = c_w, c_h + 35 + self.center_additive;
                for i = #self.items, 1, -1 do
                    local v = self.items[i]

                    if #v.text == 0 then
                        return
                    end
        
                    local text = string.gsub(v.text, '(%x%x%x%x%x%x%x%x)', function(hex) 
                        return ('%s%02x'):format(string.sub(hex, 1, -3), v.a); 
                    end):gsub(' ', '  '):upper();
        
                    local w, h = renderer.measure_text('cd-', text)
                    h = h + 2
            
                    local f = v.time;
                    if (f < 0.5) then
                        eternal.func.clamp(f, 0.0, 0.5);
        
                        f = f / 0.5;
            
                        v.a = 255.0 * f;
            
                        if (i == 1 and f < 0.3) then
                            y = y + (h * (1.0 - f / 0.3));
                        end
                    end
        
                    if not self.simple then
                        renderer.rectangle(x - (w * 0.5), y, w + offset[1] * 2, h + offset[2] * 2, 20, 20, 20, v.a);
                        eternal.func.outline(x - (w * 0.5), y, w + offset[1] * 2, h + offset[2] * 2, 0, 0, 0, v.a);
                        renderer.rectangle(x - (w * 0.5), y + 1, w + offset[1] * 2, 1, 0, 0, 0, v.a);
                        renderer.gradient(x - (w * 0.5), y, math.min(w, w * (v.time / self.time)) + offset[1] * 2, 1, r1, g1, b1, v.a, r2, g2, b2, v.a, true);
                        if self.images then
                            icons[v.type]:draw(x - (w * 0.5) + offset[1], y + offset[2] * 0.5, sizes[v.type].w * scale, sizes[v.type].h * scale, 255, 255, 255, math.abs(math.cos(globals.realtime()))*v.a);
                        end
                    end
        
                    local text_pos = { x + offset[1], y + (h * 0.5) +  offset[2] }
                    if self.simple then
                        text_pos = { x, y }
                    end
        
                    renderer.text(text_pos[1], text_pos[2], 255, 255, 255, v.a, 'cd-', 0, text);
        
                    y = y + h + ((self.simple) and 0 or offset[2] * 2 + 5);
                end
            end)
        },

        manage_database = function(tbl)
            local return_tbl = {}
            local configs = 0

            for index, value in next, tbl do
                configs = configs + 1
                return_tbl[#return_tbl+1] = index
            end

            if configs == 0 then 
                return_tbl = {'-'} 
            end

            return return_tbl
        end,

        export_tab = function(tbl)
            local settings = {}

            for count = 1, #tbl do
                settings[tbl[count][1]] = {}

                for key, value in pairs(tbl[count][2]) do
                    if value and key ~= 'current_state' and key ~= 'weapon_state' then
                        if type(value) == 'table' then
                            for k, v in pairs(value) do
                                for i, j in pairs(v) do
                                    if not settings[tbl[count][1]][key] then
                                        settings[tbl[count][1]][key] = {}
                                    end
                                    
                                    if not settings[tbl[count][1]][key][k] then 
                                        settings[tbl[count][1]][key][k] = {}
                                    end

                                    if type(j) == 'table' then
                                        for x, y in pairs(j) do
                                            if type(y) == 'table' then
                                                for xx, yy in pairs(y) do
                                                    if type(yy) == 'table' then
                                                        for xxx, yyy in pairs(yy) do
                                                            if not settings[tbl[count][1]][key][k][i] then
                                                                settings[tbl[count][1]][key][k][i] = {}
                                                            end

                                                            if not settings[tbl[count][1]][key][k][i][x] then
                                                                settings[tbl[count][1]][key][k][i][x] = {}
                                                            end

                                                            if not settings[tbl[count][1]][key][k][i][x][xx] then
                                                                settings[tbl[count][1]][key][k][i][x][xx] = {}
                                                            end

                                                            if type(yyy) == 'table' then
                                                                for xxxx, yyyy in pairs(yyy) do
                                                                    if not settings[tbl[count][1]][key][k][i][x][xx][xxx] then
                                                                        settings[tbl[count][1]][key][k][i][x][xx][xxx] = {}
                                                                    end

                                                                    settings[tbl[count][1]][key][k][i][x][xx][xxx][xxxx] = ui.get(yyyy)
                                                                end
                                                            else
                                                                settings[tbl[count][1]][key][k][i][x][xx][xxx] = ui.get(yyy)
                                                            end
                                                        end
                                                    else
                                                        if not settings[tbl[count][1]][key][k][i] then
                                                            settings[tbl[count][1]][key][k][i] = {}
                                                        end
                                                        
                                                        if not settings[tbl[count][1]][key][k][i][x] then
                                                            settings[tbl[count][1]][key][k][i][x] = {}
                                                        end
    
                                                        settings[tbl[count][1]][key][k][i][x][xx] = ui.get(yy)
                                                    end
                                                end
                                            else
                                                if not settings[tbl[count][1]][key][k][i] then
                                                    settings[tbl[count][1]][key][k][i] = {}
                                                end

                                                settings[tbl[count][1]][key][k][i][x] = ui.get(y)
                                            end
                                        end
                                    else
                                        settings[tbl[count][1]][key][k][i] = ui.get(j)
                                    end
                                end
                            end
                        elseif not key:find('label') then
                            if key == 'main_indicator_color' or key == 'secondary_indicator_color' then
                                settings[tbl[count][1]][key] = { ui.get(value) }
                            elseif not key:find('hotkey') and not key:find('transport') then
                                settings[tbl[count][1]][key] = ui.get(value)
                            end
                        end
                    end
                end
            end

            return settings
        end,

        import_tab = function(data, to_import, str)
            local tab_list = { [1] = 'aa', [2] = 'visual', [3] = 'misc' }
            local tab_import = ''

            local temp_hi = {}
            local temporary = {}

            for i = 1, #to_import do
                if #to_import[i] > 0 then
                    if data[tab_list[i]] ~= nil then
                        for k, v in pairs(data[tab_list[i]]) do
                            if type(v) == 'table' then
                                for kk, vv in pairs(v) do
                                    if type(kk) == 'number' then
                                        if kk == 1 then
                                            temporary = {}
                                        end
                                        table.insert(temporary, vv)

                                        ui.set(to_import[i][2][k], temporary)
                                    else
                                        for kkk, vvv in pairs(vv) do
                                            if type(vvv) == 'table' then
                                                for kkkk, vvvv in pairs(vvv) do
                                                    if type(vvvv) == 'table' then
                                                        for kkkkk, vvvvv in pairs(vvvv) do
                                                            if type(vvvvv) == 'table' then
                                                                for kkkkkk, vvvvvv in pairs(vvvvv) do
                                                                    if type(vvvvvv) == 'table' then
                                                                        for kkkkkkk, vvvvvvv in pairs(vvvvvv) do
                                                                            ui.set(to_import[i][2][k][kk][kkk][kkkk][kkkkk][kkkkkk][kkkkkkk], vvvvvvv)
                                                                        end
                                                                    else
                                                                        ui.set(to_import[i][2][k][kk][kkk][kkkk][kkkkk][kkkkkk], vvvvvv)
                                                                    end
                                                                end
                                                            else
                                                                ui.set(to_import[i][2][k][kk][kkk][kkkk][kkkkk], vvvvv)
                                                            end
                                                        end
                                                    else
                                                        if type(kkkk) ~= 'number' then
                                                            ui.set(to_import[i][2][k][kk][kkk][kkkk], vvvv)
                                                        else
                                                            if kkkk == 1 then
                                                                temp_hi = {}
                                                            end

                                                            table.insert(temp_hi, vvvv)
                                                            ui.set(to_import[i][2][k][kk][kkk], temp_hi)
                                                        end
                                                    end
                                                end
                                            elseif to_import[i][2][k][kk][kkk] and vvv then
                                                ui.set(to_import[i][2][k][kk][kkk], vvv)
                                            end
                                        end
                                    end
                                end
                            else
                                if to_import[i][2][k] and v then
                                    ui.set(to_import[i][2][k], v)
                                end
                            end
                        end

                        tab_import = tab_import..tab_list[i]..', '
                    else
                        log(string.format('Failed to %s: %s.', str:sub(1, -3), tab_list[i]))
                    end
                end
            end

            log(string.format('Successfully %s: %s', str, tab_import:sub(1, -3)..'.'))
        end,

        preset = function(should, value)
            if should then
                return value
            end

            return ui.get(value)
        end,

        lower_body_yaw = LPH_JIT(function(cmd, lby)
            if not lby or cmd.in_jump == 1 or cmd.in_attack == 1 or eternal.cache.lp_velocity > 3 then
                return
            end

            local desync_amount = eternal.cache.desync_amount

            if cmd.forwardmove < 1 and cmd.sidemove < 1 and desync_amount > 30 and cmd.chokedcommands ~= 0 then
                cmd.forwardmove = 0.1
                cmd.in_forward = 1
            end
        end),

        angle_vector = LPH_JIT_MAX(function(angle)
            local p, y = math.rad(angle[1]), math.rad(angle[2])
            local sp, cp, sy, cy = math.sin(p), math.cos(p), math.sin(y), math.cos(y)
            return {cp*cy, cp*sy, -sp}
        end),

        calc_angle = LPH_JIT_MAX(function(start_pos, end_pos)
            if start_pos[1] == nil or end_pos[1] == nil then
                return {0, 0}
            end
        
            local delta_x, delta_y, delta_z = end_pos[1] - start_pos[1], end_pos[2] - start_pos[2], end_pos[3] - start_pos[3]
        
            if delta_x == 0 and delta_y == 0 then
                return {(delta_z > 0 and 270 or 90), 0}
            else
                local hyp = math.sqrt(delta_x*delta_x + delta_y*delta_y)
        
                local pitch = math.deg(math.atan2(-delta_z, hyp))
                local yaw = math.deg(math.atan2(delta_y, delta_x))
        
                return {pitch, yaw}
            end
        end),

        extrapolate_player_position = LPH_JIT_MAX(function(player, origin, ticks)
            local vel = {entity.get_prop(player, 'm_vecVelocity')}
        
            if vel[1] == nil then
                return nil
            end
        
            local pred_tick = globals.tickinterval() * ticks
        
            return {
                origin[1] + (vel[1] * pred_tick),
                origin[2] + (vel[2] * pred_tick),
                origin[3] + (vel[3] * pred_tick)
            }
        end),
        
        extrapolate_origin_wall = LPH_JIT_MAX(function(ignore, origin, yaw, units)
            local forward = eternal.func.angle_vector({0, yaw})
            local trace = {client.trace_line(ignore, origin[1], origin[2], origin[3], origin[1] + (forward[1] * units), origin[2] + (forward[2] * units), origin[3] + (forward[3] * units))}
            return {
                origin[1] + (forward[1] * (units * trace[1])),
                origin[2] + (forward[2] * (units * trace[1])),
                origin[3] + (forward[3] * (units * trace[1]))
            }, trace[1]
        end),

        freestand = function()    
            if eternal.cache.fs_ticks_ran < 16 then
                eternal.cache.fs_ticks_ran = eternal.cache.fs_ticks_ran + 1
                return
            end
        
            eternal.cache.peeked = false
            eternal.cache.vulnerable = false
        
            if eternal.cache.local_player == nil or entity.is_alive(eternal.cache.local_player) == false or eternal.cache.threat == nil or entity.is_dormant(eternal.cache.threat) then
                return
            end
        
            local lp_origin = {entity.get_origin(eternal.cache.local_player)}
            local origin = {entity.get_origin(eternal.cache.threat)}
        
            if lp_origin[1] == nil or origin[1] == nil then
                return
            end
        
            local lp_eye_position = {lp_origin[1], lp_origin[2], lp_origin[3] + 64}
            origin[3] = origin[3] + 64
        
            local predict_origin = {}
            local predict_lp_position = {}
        
            local damage = {left = 0, right = 0}
            local predict_damage = {left = 0, right = 0}
        
            for i = 1, 2 do
                local new_origin = eternal.func.extrapolate_player_position(eternal.cache.threat, origin, toticks(0.600 * (i / 2)))
                predict_origin[i] = new_origin
            end
        
            for p = 1, #predict_origin do 
                local target_origin = predict_origin[p]

                for i = 0, 2 do
                    local lp_predict_origin = eternal.func.extrapolate_player_position(eternal.cache.local_player, lp_eye_position, toticks(0.300 * (i / 2)))
                    local angle = eternal.func.calc_angle(lp_predict_origin, target_origin)
        
                    local left_angle = eternal.func.normalize(angle[2] + 90)
                    local right_angle = eternal.func.normalize(angle[2] - 90)
        
                    local last_left_trace = 1
                    local last_right_trace = 1
        
                    local pred_left = eternal.func.extrapolate_origin_wall(eternal.cache.threat, target_origin, left_angle, (i * 12))
                    local pred_right = eternal.func.extrapolate_origin_wall(eternal.cache.threat, target_origin, right_angle, (i * 12))
        
                    for j = 1, 3 do
                        lp_predict_origin[3] = lp_origin[3] + ((lp_eye_position[3] - lp_origin[3]) * (j/2))
        
                        local left, right
                        local left_trace, right_trace = 0,0
                        local left_damage, right_damage = 0, 0
        
                        if last_left_trace >= 0.97 then
                            left, left_trace = eternal.func.extrapolate_origin_wall(eternal.cache.local_player, lp_predict_origin, left_angle, 15 + (i * 12)^1.4)
                        end
        
                        if last_right_trace >= 0.97 then
                            right, right_trace = eternal.func.extrapolate_origin_wall(eternal.cache.local_player, lp_predict_origin, right_angle, 15 + (i * 12)^1.4)
                        end
                        
                        if left and left[1] then
                            _, left_damage = client.trace_bullet(eternal.cache.threat, pred_left[1], pred_left[2], pred_left[3], left[1], left[2], left[3], true)
                        end 
        
                        if right and right[1] then
                            _, right_damage = client.trace_bullet(eternal.cache.threat, pred_right[1], pred_right[2], pred_right[3], right[1], right[2], right[3], true)
                        end
                    
                        if i <= 2 then
                            damage.left = damage.left + left_damage
                            damage.right = damage.right + right_damage
                        end
        
                        predict_damage.left = predict_damage.left + left_damage
                        predict_damage.right = predict_damage.right + right_damage
        
                        last_left_trace = left_trace
                        last_right_trace = right_trace
                    end
        
                    if (damage.left > 0 and damage.right == 0) or (damage.left == 0 and damage.right > 0) then
                        break
                    end
                end
            end

            eternal.cache.peeked = damage.left > 0 and damage.right > 0
            eternal.cache.vulnerable = (damage.left + damage.right) > 0
            eternal.cache.fs_ticks_ran = 0
        
            if predict_damage.left + predict_damage.right <= 0 then
                eternal.cache.side = 0
                return
            end
        
            if predict_damage.left ~= predict_damage.right then
                eternal.cache.side = predict_damage.left < predict_damage.right and 1 or 2
                return
            end
        end,

        rad2deg = function(rad) 
            return (rad * 180 / math.pi) 
        end,

        edge = function()
            local vector_add = function(vector1, vector2)
                return { 
                    x = vector1.x + vector2.x, 
                    y = vector1.y + vector2.y, 
                    z = vector1.z + vector2.z
                }
            end
        
            local trace_line = function(entity, start, _end)
                return client.trace_line(entity, start.x, start.y, start.z, _end.x, _end.y, _end.z)
            end

            local m_vecOrigin = eternal.includes.vector(entity.get_prop(eternal.cache.local_player, 'm_vecOrigin'))
            local m_vecViewOffset = eternal.includes.vector(entity.get_prop(eternal.cache.local_player, 'm_vecViewOffset'))

            local m_vecOrigin = vector_add(m_vecOrigin, m_vecViewOffset)

            local radius = 50 + 0.1
            local step = math.pi * 2.0 / 15

            local camera = eternal.includes.vector(client.camera_angles())
            local central = math.floor(camera.y + 0.5) * math.pi / 180

            local data = {
                fraction = 1,
                surpassed = false,
                angle = eternal.includes.vector(0, 0, 0),
                var = 0,
                side = 'LAST KNOWN'
            }

            for a = central, math.pi * 3.0, step do
                if a == central then
                    central = eternal.func.normalize(eternal.func.rad2deg(a))
                end

                local clm = eternal.func.normalize(central - eternal.func.rad2deg(a))
                local abs = math.abs(clm)

                if abs < 90 and abs > 1 then
                    local side = 0

                    local location = eternal.includes.vector(
                        radius * math.cos(a) + m_vecOrigin.x, 
                        radius * math.sin(a) + m_vecOrigin.y, 
                        m_vecOrigin.z
                    )

                    local _fr, entindex = trace_line(eternal.cache.local_player, m_vecOrigin, location)

                    if math.floor(clm + 0.5) < -21 then 
                        side = 1
                    end

                    if math.floor(clm + 0.5) > 21 then 
                        side = 2
                    end

                    local fr_info = {
                        fraction = _fr,
                        surpassed = (_fr < 1),
                        angle = eternal.includes.vector(0, eternal.func.normalize(eternal.func.rad2deg(a)), 0),
                        var = math.floor(clm + 0.5),
                        side = side --[ 0 - center / 1 - left / 2 - right ]
                    }

                    if type(data.fraction) == 'number' then
                        if data.fraction > _fr then
                            eternal.cache.side = side
                            data.fraction = fr_info
                        else
                            eternal.cache.side = 0
                        end
                    end
                end
            end
        end,

        default_aa = LPH_JIT(function(v, cmd, at_targets, lby)
            ui.set(eternal.ref.aa.main.pitch[1], ui.get(eternal.menu.anti_aim.pitch_hotkey) and 'Down' or 'Off')
            ui.set(eternal.ref.aa.main.yawbase, (not at_targets or eternal.cache.yaw_direction ~= 0) and 'Local view' or 'At targets')
            ui.set(eternal.ref.aa.main.roll, 0)

            ui.set(eternal.ref.aa.main.yaw[1], '180')
            ui.set(eternal.ref.aa.main.yaw[2], 180)

            ui.set(eternal.ref.aa.main.yaw_jitter[1], 'Off')
            ui.set(eternal.ref.aa.main.yaw_jitter[2], 0)
            
            ui.set(eternal.ref.aa.main.fs_body_yaw, false)

            local state_type = ui.get(v.state_type)
            local aa_side = state_type == 'Single' and 'Left' or eternal.cache.desync_side
            local settings = (state_type == 'Preset' and cloud.settings['aa']) and cloud.settings['aa']['states'][eternal.cache.lp_team][eternal.cache.active_preset] or v

            if state_type == 'Preset' and cloud.settings['aa'] then
                aa_side = settings.state_type == 'Single' and 'Left' or eternal.cache.desync_side
            end

            local value = settings[aa_side]

            if value then
                local should = (state_type == 'Preset' and cloud.settings['aa'])

                local body_yaw_type = eternal.func.preset(should, value['body_yaw'][1])
                local body_yaw = eternal.func.preset(should, value['body_yaw'][2])
                
                ui.set(eternal.ref.aa.main.body_yaw[1], (body_yaw_type == 'Static' and body_yaw == 0) and 'Opposite' or eternal.func.preset(should, value['body_yaw'][1]))
                ui.set(eternal.ref.aa.main.body_yaw[2], body_yaw > 0 and 180 or (body_yaw < 0 and -180 or 0))

                local fs_body_yaw = eternal.func.preset(should, value['fs_body_yaw'])
                local fs_reverse = eternal.func.preset(should, value['fs_reverse'])
                
                if fs_body_yaw ~= 'Off' then
                    if fs_body_yaw == 'Edge' then
                        eternal.func.edge()
                    else
                        eternal.func.freestand()
                    end

                    if eternal.cache.side > 0 then
                        ui.set(eternal.ref.aa.main.body_yaw[1], 'Static')
                        ui.set(eternal.ref.aa.main.body_yaw[2], eternal.cache.side == 1 and (fs_reverse and 180 or -180) or (fs_reverse and -180 or 180))
                    end
                end
            end

            if eternal.cache.yaw_direction ~= 0 then
                local body_yaw = state_type == 'Preset' and settings[aa_side].body_yaw[1] or ui.get(settings[aa_side].body_yaw[1])
                ui.set(eternal.ref.aa.main.yaw[2], eternal.cache.yaw_direction)

                if body_yaw == 'Static' and eternal.func.preset(should, value['body_yaw'][2]) == 0 then
                    ui.set(eternal.ref.aa.main.body_yaw[1], 'Static')
                    ui.set(eternal.ref.aa.main.body_yaw[2], (ui.get(eternal.ref.aa.main.yaw[2]) == 90 and (eternal.cache.force_lean and 65 or 180) or (eternal.cache.force_lean and -75 or 180)))
                end
            end

            if ui.get(eternal.ref.aa.main.body_yaw[1]) == 'Static' and eternal.cache.yaw_direction == 0 then
                eternal.func.lower_body_yaw(cmd, lby)
            end
        end),

        can_desync = function(cmd, weapon)
            if eternal.cache.on_ladder then
                return false
            end

            if cmd.in_attack == 1 then
                local weapon_name = entity.get_classname(weapon)

                if not string.find(weapon_name, 'Grenade') then
                    if math.max(entity.get_prop(weapon, 'm_flNextPrimaryAttack') or 0, entity.get_prop(eternal.cache.local_player, 'm_flNextAttack') or 0) <= globals.curtime() then
                        return false
                    end
                end
            end

            local throw_time = entity.get_prop(weapon, 'm_fThrowTime')

            if throw_time ~= nil and throw_time ~= 0 then
                return false
            end

            return true
        end,

        at_targets = function(enemy)
            if not enemy then
                return eternal.includes.vector(client.camera_angles()).y - 180
            end

            local enemy_position = eternal.includes.vector(entity.get_origin(eternal.cache.threat))
            return eternal.includes.vector(eternal.includes.vector(entity.get_origin(eternal.cache.local_player)):to(enemy_position):angles()).y - 180
        end,

        micromovements = function(cmd, weapon)
            local weapon_name = entity.get_classname(weapon)

            if eternal.cache.in_air or string.find(weapon_name, 'Grenade') then 
                return 
            end

            local w, a, s, d = cmd.in_forward == 1, cmd.in_moveleft == 1, cmd.in_moveright == 1, cmd.in_back == 1
            local tickcount = globals.tickcount()

            if w or a or s or d then 
                eternal.cache.last_movement = tickcount
                return 
            end

            if eternal.cache.last_movement <= tickcount then
                eternal.cache.last_movement = tickcount + 1
            else
                local amount = eternal.cache.player_state == 'Duck' and 3.3 or 1.1
                local micro = globals.tickcount() % 2 == 0

                cmd.sidemove = micro and amount or -amount
            end
        end,

        plant_amount = LPH_JIT_MAX(function()
            local timeElapsed = (globals.curtime() + 3) - eternal.cache.bomb_time
            local timeElapsedInPerc = (timeElapsed / 3 * 100) + 0.5
            return timeElapsedInPerc * 0.01
        end),

        to_angles = LPH_NO_VIRTUALIZE(function(forward, angles)
            if forward[1] == 0 and forward[2] == 0 then
                if forward[3] > 0 then
                    angles[1] = -90
                else
                    angles[1] = 90
                end
                angles[2] = 0
            else
                angles[1] = math.atan2( -forward[3], math.sqrt( forward[1] * forward[1] + forward[2] * forward[2] ) ) * ( 180 / math.pi )
                angles[2] = math.atan2( forward[2], forward[1] ) * ( 180 / math.pi )
            end
        
            angles[3] = 0
            return angles
        end),

        get_move_dir = LPH_JIT_MAX(function(ent)
            local velocity_prop = { entity.get_prop( ent, 'm_vecVelocity' ) }
            local yaw = entity.get_prop(ent, 'm_angEyeAngles[1]')

            if not velocity_prop[1] or not velocity_prop[2] then
                return { 0, 0, 0 }
            end

            local velocity = math.sqrt( velocity_prop[1] * velocity_prop[1] + velocity_prop[2] * velocity_prop[2])
            local direction = { 0, 0, 0 }
        
            direction = eternal.func.to_angles(velocity_prop, direction)
            direction[2] = eternal.func.normalize(yaw - direction[2])
        
            return direction
        end),
        
        move_dir_text = LPH_JIT_MAX(function(ent)
            local m_flags = entity.get_prop(ent, 'm_fFlags')
            local m_dir = eternal.func.get_move_dir(ent)[2]
            local abs_m_dir = math.abs(m_dir)

            if not m_flags then
                return 'forwards'
            end

            if bit.band(m_flags, 1) == 0 then
                return 'in-air'
            end

            return eternal.func.between(abs_m_dir, 0, 45) and 'forwards' or (eternal.func.between(abs_m_dir, 135, 180) and 'backwards' or (m_dir < 0 and 'right' or 'left'))
        end),

        override_roll = LPH_JIT_MAX(function(ent, roll)
            local _,yaw = entity.get_prop(ent, 'm_angRotation')
            local pitch = 89*((2*entity.get_prop(ent, 'm_flPoseParameter',12))-1)
            entity.set_prop(ent, 'm_angEyeAngles', pitch, yaw, roll)
        end),

        clan_tag = LPH_JIT(function()
            if not eternal.cache.master_switch or not eternal.cache.local_player then 
                return
            end

            local tag_type = ui.get(eternal.menu.misc.clan_tag)

            if tag_type ~= '-' then
                eternal.cache.clan_tag_reset = true
            end

            if tag_type == 'Eternal' then
                eternal.func.run_tag_animation()
                eternal.cache.clan_tag_reset = true
            end
            
            if tag_type == '-' and eternal.cache.clan_tag_reset then
                client.set_clan_tag('\0')
                eternal.cache.clan_tag_reset = false
            end

            ui.set(eternal.ref.misc.clan_tag, tag_type == 'GameSense')
        end),

        gradient_text_anim = LPH_JIT_MAX(function(text, color1, color2, speed, delay)
            local r1, g1, b1, a1 = unpack(color1)
            local r2, g2, b2, a2 = unpack(color2)
        
            speed = speed or 1
            delay = delay or 0
        
            delay = delay + 3
        
            local return_text = ''
            local text_len = #text

            local realtime = globals.curtime()
            local highlight_fraction = (realtime * speed) % delay - 2
        
            for i = 1, text_len do
                local character = text:sub(i, i)
                local character_fraction = (i - 1) / (text_len - 1)
        
                local highlight_delta = character_fraction - highlight_fraction
        
                if highlight_delta > 1 then
                    highlight_delta = 1 * 2 - highlight_delta
                end
        
                local r, g, b, a = r1, g1, b1, a1
        
                local r_fraction = r2 - r
                local g_fraction = g2 - g
                local b_fraction = b2 - b
                local a_fraction = a2 - a
        
                if highlight_delta >= 0 and highlight_delta <= 1 then
                    r = r + r_fraction * highlight_delta
                    g = g + g_fraction * highlight_delta
                    b = b + b_fraction * highlight_delta
                    a = a + a_fraction * highlight_delta
                end
        
                return_text = return_text .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, a, character)
            end
        
            return return_text
        end),

        default_style = LPH_JIT_MAX(function()
            local r1, g1, b1, a1 = ui.get(eternal.menu.visual.main_indicator_color)
            local r2, g2, b2, a2 = ui.get(eternal.menu.visual.secondary_indicator_color)

            local ind_offset = 0
            local anim_speed = 5
            local ind_separator = 8

            local scope_animation = globals.frametime() * 150
            eternal.cache.is_scoped = entity.get_prop(eternal.cache.local_player, 'm_bIsScoped') == 1
            eternal.cache.scope_width = eternal.func.clamp(eternal.cache.scope_width + (eternal.cache.is_scoped and scope_animation or -scope_animation), 0, 25)
            eternal.cache.lean_anim = eternal.cache.desync_amount >= 40 and eternal.func.lerp(eternal.cache.lean_anim, 170, globals.frametime() * 6) or eternal.func.lerp(eternal.cache.lean_anim, 0, globals.frametime() * 6)

            if eternal.cache.contains.indicator_options.keybinds then
                local min_dmg = ui.get(eternal.ref.rage.minimum_damage_override[3])
                local fov = ui.get(eternal.ref.rage.fov)
                local dmg_string = min_dmg < 10 and '  DMG: ' or 'DMG: '
                local fov_string = fov < 10 and '  FOV: ' or 'FOV: '

                local aimbot_text = eternal.colorful_text:text({(ui.get(eternal.menu.misc.auto_fire_master) and ui.get(eternal.menu.misc.auto_fire_key)) and {178, 237, 0} or {255, 255, 255}, 'AF'})..eternal.colorful_text:text({{255, 255, 255}, '  -  '})..eternal.colorful_text:text({(not eternal.cache.l_auto_wall and not eternal.cache.auto_wall) and {255, 255, 255} or (eternal.cache.l_auto_wall and {178, 237, 0} or {237, 91, 0}), 'AW'})
                
                local items = {
                    [1] = { true, eternal.func.gradient_text_anim('ETERNAL', { r2, g2, b2, 150 }, { r1, g1, b1, 255 }, 2, 1), { 255, 255, 255, 255 } },
                    [2] = { (ui.get(eternal.menu.misc.auto_fire_master) and ui.get(eternal.menu.misc.auto_fire_key)) or (eternal.cache.l_auto_wall or eternal.cache.auto_wall), aimbot_text, { 255, 255, 255, 255 } },
                    [3] = { eternal.cache.contains.crosshair_keybinds.fov, fov_string..eternal.colorful_text:text({{r1, g1, b1}, tostring(fov)}), { 255, 255, 255, 255 } },
                    [4] = { eternal.cache.contains.crosshair_keybinds.on_shot and ui.get(eternal.ref.aa.other.on_shot[1]) and ui.get(eternal.ref.aa.other.on_shot[2]), 'OS', { r2, g2, b2, 255 } },
                    [5] = { eternal.cache.contains.crosshair_keybinds.freestand and ui.get(eternal.menu.misc.fs_hotkey) and not eternal.cache.fs_disabled, 'FS', { 255, 255, 255, 255 } },
                    [6] = { eternal.cache.contains.crosshair_keybinds.safe_point and ui.get(eternal.ref.rage.force_safe_point), 'SAFE', { 178, 237, 0, 255 } },
                    [7] = { eternal.cache.contains.crosshair_keybinds.force_baim and ui.get(eternal.ref.rage.force_baim), 'BAIM', { 250, 95, 95, 255 } },
                    [8] = { eternal.cache.contains.crosshair_keybinds.ping_spike and ui.get(eternal.ref.misc.ping_spike[1]) and ui.get(eternal.ref.misc.ping_spike[2]), 'PING', { 175, 235, 50, 255 } },
                    [9] = { eternal.cache.contains.crosshair_keybinds.fake_duck and ui.get(eternal.ref.rage.fake_duck), 'DUCK', { 220, 220, 220, 255 } },
                    [10] = { eternal.cache.contains.crosshair_keybinds.pitch_override and ui.get(eternal.menu.anti_aim.pitch_hotkey), 'PITCH', { r2, g2, b2, 255 } },
                    [11] = { eternal.cache.contains.crosshair_keybinds.damage_override and ui.get(eternal.ref.rage.minimum_damage_override[1]) and ui.get(eternal.ref.rage.minimum_damage_override[2]), dmg_string..eternal.colorful_text:text({{r1, g1, b1}, tostring(min_dmg)}), { 255, 255, 255, 255 } },
                    [12] = { eternal.cache.contains.crosshair_keybinds.body_lean and eternal.cache.force_lean, 'LEAN', { r2, g2, b2, 80 + eternal.cache.lean_anim } },
                }

                for i, ref in ipairs(items) do
                    local text_width, text_height = renderer.measure_text('-', ref[2])
                    text_width = i == 9 and text_width - 2 or text_width;text_width = i == 8 and text_width - 2 or text_width;text_width = i == 2 and text_width - 2 or text_width
                    local key = ref[1] and 1.1 or 0

                    if i == 2 then
                        ind_offset = ind_offset + 1
                    end

                    if i == 2 and (eternal.cache.contains.indicator_options.body_yaw_amount or eternal.cache.contains.indicator_options.body_yaw_side) then
                        ind_offset = ind_offset + 5
                    end
                    
                    eternal.cache.values[i] = eternal.func.clamp(eternal.func.lerp(eternal.cache.values[i], key, globals.frametime() * 5 * 1.5), 0, 1)

                    if eternal.cache.values[i] > 0.35 then
                        renderer.text(eternal.cache.screen_size.x / 2 + eternal.cache.scope_width, (eternal.cache.screen_size.y / 2) + 20 + ind_offset * eternal.cache.values[i], ref[3][1], ref[3][2], ref[3][3], ref[3][4] * eternal.cache.values[i], 'c-', 0, ref[2])
                    end

                    ind_offset = ind_offset + ind_separator * eternal.cache.values[i]
                end
            end

            if eternal.cache.contains.indicator_options.body_yaw_amount or eternal.cache.contains.indicator_options.body_yaw_side then
                local extra_height = eternal.cache.contains.indicator_options.keybinds and 25 or 15
                max_width = renderer.measure_text('-', 'ETERNAL') + 1

                if eternal.cache.contains.indicator_options.body_yaw_side and not eternal.cache.contains.indicator_options.body_yaw_amount then
                    if eternal.cache.desync_side == 'Left' then
                        renderer.rectangle(eternal.cache.screen_size.x / 2 - (max_width / 2) + eternal.cache.scope_width + 1, eternal.cache.screen_size.y / 2 + extra_height, max_width+2, 4, 0, 0, 0, math.max(0, 255*1-90))
                        renderer.rectangle(eternal.cache.screen_size.x / 2 - (max_width / 2) + eternal.cache.scope_width + 1 + (max_width / 2), eternal.cache.screen_size.y / 2 + extra_height + 1, (max_width*(57*-1) / 114), 2, r1, g1, b1, 255)
                    else
                        renderer.rectangle(eternal.cache.screen_size.x / 2 - (max_width / 2) + eternal.cache.scope_width + 1, eternal.cache.screen_size.y / 2 + extra_height, max_width+2, 4, 0, 0, 0, math.max(0, 255*1-90))
                        renderer.rectangle(eternal.cache.screen_size.x / 2 - (max_width / 2) + eternal.cache.scope_width + 1 + ((max_width / 2) + 1), eternal.cache.screen_size.y / 2 + extra_height + 1, max_width*(57 / 114), 2, r1, g1, b1, 255)
                    end
                elseif eternal.cache.contains.indicator_options.body_yaw_side and eternal.cache.contains.indicator_options.body_yaw_amount then
                    if eternal.cache.desync_side == 'Left' then
                        renderer.rectangle(eternal.cache.screen_size.x / 2 - (max_width / 2) + eternal.cache.scope_width + 1, eternal.cache.screen_size.y / 2 + extra_height, max_width+2, 4, 0, 0, 0, math.max(0, 255*1-90))
                        renderer.rectangle(eternal.cache.screen_size.x / 2 - (max_width / 2) + eternal.cache.scope_width + 1 + (max_width / 2), eternal.cache.screen_size.y / 2 + extra_height + 1, (max_width*(eternal.cache.desync_amount*-1) / 114), 2, r1, g1, b1, 255)
                    else
                        renderer.rectangle(eternal.cache.screen_size.x / 2 - (max_width / 2) + eternal.cache.scope_width + 1, eternal.cache.screen_size.y / 2 + extra_height, max_width+2, 4, 0, 0, 0, math.max(0, 255*1-90))
                        renderer.rectangle(eternal.cache.screen_size.x / 2 - (max_width / 2) + eternal.cache.scope_width + 1 + ((max_width / 2) + 1), eternal.cache.screen_size.y / 2 + extra_height + 1, max_width*(eternal.cache.desync_amount / 114), 2, r1, g1, b1, 255)
                    end
                else
                    renderer.rectangle(eternal.cache.screen_size.x / 2 - (max_width / 2) + eternal.cache.scope_width + 1, eternal.cache.screen_size.y / 2 + extra_height, max_width+2, 4, 0, 0, 0, math.max(0, 255*1-90))
                    renderer.rectangle(eternal.cache.screen_size.x / 2 - (max_width / 2) + eternal.cache.scope_width + 2, eternal.cache.screen_size.y / 2 + extra_height + 1, max_width*eternal.func.clamp(eternal.cache.desync_amount, 0, 57)/57, 2, r1, g1, b1, 255)
                end
            end
        end),

        d2r = LPH_JIT_MAX(function(value)
            return value * (math.pi / 180)
        end),

        vectorangle = LPH_JIT_MAX(function(x,y,z)
            local fwd_x, fwd_y, fwd_z
            local sp, sy, cp, cy
            
            sy = math.sin(eternal.func.d2r(y))
            cy = math.cos(eternal.func.d2r(y))
            sp = math.sin(eternal.func.d2r(x))
            cp = math.cos(eternal.func.d2r(x))
            fwd_x = cp * cy
            fwd_y = cp * sy
            fwd_z = -sp

            return eternal.includes.vector(fwd_x, fwd_y, fwd_z)
        end),

        mult_vec = LPH_JIT_MAX(function(vec, val)
            return eternal.includes.vector(vec.x * val, vec.y * val, vec.z * val)
        end),

        crosshair_threat = LPH_NO_VIRTUALIZE(function()
            local loop_amount = #eternal.cache.enemies

            if loop_amount == 0 then
                if eternal.cache.contains.peek.include_dormant then
                    return eternal.cache.threat
                end

                return nil
            end

            local lp_eyepos = eternal.includes.vector(client.eye_position())
            local lp_camera_angles = eternal.includes.vector(client.camera_angles())

            local calc = function(xdelta, ydelta)
                if xdelta == 0 and ydelta == 0 then
                    return 0
                end

                return math.deg(math.atan2(ydelta, xdelta))
            end

            local bestenemy = nil
            local fov = 180

            for i = 1, loop_amount do
                local player = eternal.cache.enemies[i]
                local player_origin = eternal.includes.vector(entity.get_origin(player))

                local cur_fov = math.abs(eternal.func.normalize(calc(lp_eyepos.x - player_origin.x, lp_eyepos.y - player_origin.y) - lp_camera_angles.y + 180))

                if cur_fov < fov then
                    fov = cur_fov
                    bestenemy = player
                end
            end

            return bestenemy
        end),

        target_hitboxes = LPH_JIT_MAX(function()
            local new_hitboxes = {}
            local target_hitboxes = ui.get(eternal.ref.rage.target_hitbox)
            local force_baim = ui.get(eternal.ref.rage.force_baim)

            local force_baim_disabled_hitgroups = {
                'Head', 'Arms', 'Legs', 'Feet'
            }

            local limb_hitboxes = {
                'Arms', 'Legs', 'Feet'
            }

            for i = 1, #target_hitboxes do
                if force_baim and eternal.func.contains(force_baim_disabled_hitgroups, target_hitboxes[i]) then
                    goto skip
                end

                if eternal.cache.contains.peek.exclude_limbs and eternal.func.contains(limb_hitboxes, target_hitboxes[i]) then
                    goto skip
                end

                local curr_hitgroup = eternal.cache.hitgroups_to_hitboxes[target_hitboxes[i]]

                for j = 1, #curr_hitgroup do
                    local hitbox = curr_hitgroup[j]

                    if eternal.func.contains(eternal.cache.allowed_hitboxes, hitbox) then
                        table.insert(new_hitboxes, hitbox)
                    end
                end

                ::skip::
            end

            return new_hitboxes
        end),

        damage_detection = LPH_JIT_MAX(function(camera_pos, enemy_pos)
            local entindex, dmg = client.trace_bullet(eternal.cache.local_player, camera_pos.x, camera_pos.y, camera_pos.z, enemy_pos.x, enemy_pos.y, enemy_pos.z) 

            return dmg
        end),

        extrapolate = LPH_JIT_MAX(function(min_dmg, velocity, camera_pos, hitbox_pos)
            local is_whitelist = plist.get(eternal.cache.peek_threat, 'Add to whitelist')

            if is_whitelist then
                return 0
            end

            if not eternal.cache.contains.peek.prediction then
                local damage, status = eternal.func.damage_detection(camera_pos, hitbox_pos)
                return damage
            end

            local tick_interval = globals.tickinterval()

            for i = -2, 0 do
                hitbox_pos.x, hitbox_pos.y, hitbox_pos.z = hitbox_pos.x + (velocity.x * tick_interval * i), hitbox_pos.y + (velocity.y * tick_interval * i), hitbox_pos.z + (velocity.z * tick_interval * i)
                local damage, status = eternal.func.damage_detection(camera_pos, hitbox_pos)

                if damage >= min_dmg or damage >= entity.get_prop(eternal.cache.peek_threat, 'm_iHealth') then
                    return damage
                end
            end

            return 0
        end),

        predict = LPH_JIT_MAX(function(min_dmg, camera_pos, hitscan)
            local predicted_damage = 0
            local velocity = eternal.includes.vector(entity.get_prop(eternal.cache.peek_threat, 'm_vecVelocity'))

            for i = 1, #hitscan do
                local hitbox_pos = eternal.includes.vector(entity.hitbox_position(eternal.cache.peek_threat, hitscan[i]))
                local data = eternal.func.extrapolate(min_dmg, velocity, camera_pos, hitbox_pos)

                if data > predicted_damage then
                    predicted_damage = data
                end
            end
        
            return predicted_damage
        end),

        target_ready = LPH_JIT_MAX(function(weapon, double_tap)
            if not eternal.cache.peek_threat then
                return false
            end

            local scope_check = true

            if weapon.type == 'sniperrifle' then
                scope_check = eternal.cache.is_scoped
            end

            local esp_data = eternal.cache.contains.peek.include_dormant and entity.get_esp_data(eternal.cache.peek_threat) or (entity.is_dormant(eternal.cache.peek_threat) and 0 or 1)
            local esp_alpha = type(esp_data) == 'table' and esp_data.alpha or esp_data

            return scope_check and not eternal.cache.in_air and esp_alpha >= 0.75 and weapon.type ~= 'grenade'
        end),

        set_movement = LPH_JIT_MAX(function(cmd, destination)
            local move_yaw = eternal.includes.vector(eternal.includes.vector(entity.get_origin(eternal.cache.local_player)):to(destination):angles()).y

            cmd.in_forward = 1
            cmd.in_back = 0
            cmd.in_moveleft = 0
            cmd.in_moveright = 0
            cmd.in_speed = 0
            cmd.forwardmove = 800
            cmd.sidemove = 0
            cmd.move_yaw = move_yaw
        end),

        camera = LPH_JIT_MAX(function(eyepos, radius, range)
            local offset = eternal.includes.vector(entity.get_prop(eternal.cache.local_player, 'm_vecViewOffset'))
            local camera_angles = eternal.includes.vector(client.camera_angles())

            local angle = eternal.func.vectorangle(0, camera_angles.y + radius, 0)
            local ranged_angle = eternal.func.mult_vec(angle, range)

            return eternal.includes.vector(eyepos.x + ranged_angle.x, eyepos.y + ranged_angle.y , eyepos.z + ranged_angle.z)
        end),

        endpos = LPH_JIT_MAX(function(origin, dest)
            local trace = eternal.includes.trace.line(origin, dest, { skip = eternal.cache.local_player })            
            return trace.end_pos
        end),

        peek_assist = LPH_JIT_MAX(function(cmd, weapon, double_tap)
            local master_switch = ui.get(eternal.menu.misc.peek_switch)

            if (obex_data.build ~= 'Alpha' and obex_data.build ~= 'Nightly') or not master_switch then
                return
            end

            eternal.cache.peek_threat = eternal.cache.contains.peek.crosshair and eternal.func.crosshair_threat() or eternal.cache.threat

            local fix_return = ui.get(eternal.menu.misc.peek_return)
            fix_return = #fix_return > 0 and fix_return or ui.set(eternal.menu.misc.peek_return, 'Retreat on shot')
            local peek_return = ui.get(eternal.menu.misc.peek_return)
            local quick_peek_return = ui.get(eternal.menu.misc.quick_peek_return)
            local active_hotkey = ui.get(eternal.menu.misc.peek_default_hotkey)

            if master_switch and not active_hotkey then
                ui.set(eternal.ref.rage.quick_peek_assist_mode, peek_return)
                ui.set(eternal.ref.rage.quick_peek_assist[2], quick_peek_return)
                return
            end

            ui.set(eternal.ref.rage.quick_peek_assist[2], 'Always on')

            if not master_switch or not eternal.cache.peek_threat then
                return
            end

            if not eternal.func.target_ready(weapon, double_tap) then
                ui.set(eternal.ref.rage.quick_peek_assist_mode, peek_return)
                return
            end

            local min_dmg = (ui.get(eternal.ref.rage.minimum_damage_override[1]) and ui.get(eternal.ref.rage.minimum_damage_override[2])) and ui.get(eternal.ref.rage.minimum_damage_override[3]) or ui.get(eternal.ref.rage.minimum_damage)
            ui.set(eternal.ref.rage.quick_peek_assist_mode, 'Retreat on shot', 'Retreat on key release')

            local hitboxes = eternal.func.target_hitboxes()
            local eyepos = eternal.includes.vector(client.eye_position())

            for s = 1, #eternal.cache.side_peek do
                eternal.cache.side_angle = eternal.func.lerp(eternal.cache.side_angle, 0, globals.frametime() * 6)
                eternal.cache.side_angle = s == 1 and eternal.cache.side_angle or -eternal.cache.side_angle

                for i = 60, 1, -35 do
                    local camera = eternal.func.camera(eyepos, eternal.cache.side_peek[s] + eternal.cache.side_angle, i)
                    local camera_endpos = eternal.func.endpos(eyepos, camera)
                    local data = eternal.func.predict(min_dmg, camera_endpos, hitboxes)
        
                    if data >= min_dmg or data >= entity.get_prop(eternal.cache.peek_threat, 'm_iHealth') then        
                        eternal.func.set_movement(cmd, camera_endpos)
                    end
                end
            end
        end),

        aimbot_disablers = function(target)
            if eternal.cache.contains.ab_disablers.flashed then
                local flash_duration = entity.get_prop(eternal.cache.local_player, 'm_flFlashDuration')
                local blindness_threshold = 44.0 * 0.05
        
                if flash_duration > 0.0 then
                    if flash_duration_cache == 0.0 then
                        eternal.cache.last_flash_update = globals.curtime()
                    end
        
                    if globals.curtime() - eternal.cache.last_flash_update < flash_duration - blindness_threshold then
                        eternal.cache.whitelist[target] = true
                    end
                end
        
                flash_duration_cache = flash_duration
            end

            if eternal.cache.contains.ab_disablers.in_smoke then
                local smoke_grenade_projectiles = entity.get_all('CSmokeGrenadeProjectile')
                local tick_count = globals.tickcount()
                local tick_interval = globals.tickinterval()
        
                for i = 1, #smoke_grenade_projectiles do
                    eternal.cache.smoke_exists = entity.get_prop(smoke_grenade_projectiles[i], 'm_bDidSmokeEffect') == 1 and tick_count < entity.get_prop(smoke_grenade_projectiles[i], 'm_nSmokeEffectTickBegin') + 17.25 / tick_interval
                end
        
                if eternal.cache.smoke_exists then
                    local local_eye_pos = eternal.includes.vector(client.eye_position())
        
                    if eternal.cache.whitelist[target] then
                        return
                    end
        
                    local white_listed = true
        
                    for i = 1, #eternal.cache.smoke_hitboxes do
                        if not white_listed then
                            break
                        end
        
                        local enemy_hitbox = eternal.includes.vector(entity.hitbox_position(target, eternal.cache.smoke_hitboxes[i]))
        
                        for j = 1, #eternal.cache.visibility_directions do
                            if not eternal.memory.line_goes_through_smoke(local_eye_pos.x, local_eye_pos.y, local_eye_pos.z, enemy_hitbox.x + eternal.cache.visibility_directions[j][1], enemy_hitbox.y + eternal.cache.visibility_directions[j][2], enemy_hitbox.z) then
                                white_listed = false
                                break
                            end
                        end
                    end
        
                    if white_listed then
                        eternal.cache.whitelist[target] = true
                    end
                end
            end

            plist.set(target, 'Add to whitelist', eternal.cache.whitelist[target])
            eternal.cache.whitelist = {}
        end,

        find_cmd = LPH_NO_VIRTUALIZE(function(tab, value)
            for k, v in pairs(tab) do
                if eternal.func.contains(v, value) then
                    return k
                end
            end
        
            return nil
        end),

        vector_substract = function(vector1, vector2)
            return { x = vector1.x - vector2.x, y = vector1.y - vector2.y, z = vector1.z - vector2.z }
        end,

        get_atan = LPH_NO_VIRTUALIZE(function(ent, eye_pos, camera)
            local data = { id = nil, dst = 2147483647 }
        
            for i = 0, 19 do
                local hitbox = eternal.includes.vector(entity.hitbox_position(ent, i))
                local ext = eternal.func.vector_substract(hitbox, eye_pos)
        
                local yaw = (math.atan2(ext.y, ext.x) * 180 / math.pi)
                local pitch = -(math.atan2(ext.z, math.sqrt(ext.x^2 + ext.y^2)) * 180 / math.pi)
            
                local yaw_dif = math.abs(camera.y % 360 - yaw % 360) % 360
                local pitch_dif = math.abs(camera.x - pitch) % 360
                    
                if yaw_dif > 180 then 
                    yaw_dif = 360 - yaw_dif
                end
        
                local dst = math.sqrt(yaw_dif^2 + pitch_dif^2)
        
                if dst < data.dst then
                    data.dst = dst
                    data.id = i
                end
            end
        
            return data.id
        end),

        get_closest_hitbox = function()    
            if eternal.cache.threat == nil then
                return
            end
        
            local eye_pos = eternal.includes.vector(client.eye_position())
            local camera = eternal.includes.vector(client.camera_angles())
        
            if ui.get(eternal.ref.rage.fake_duck) then 
                camera.z = 64 
            end
            
            return eternal.func.find_cmd(eternal.cache.hitscan, eternal.func.get_atan(eternal.cache.threat, eye_pos, camera))
        end,

        penetration_scan = function(local_player, target, scan_amount)
            local origin = eternal.includes.vector(entity.get_prop(local_player, 'm_vecOrigin'))
            
            for i = 1, scan_amount do
                local target_hitbox = eternal.includes.vector(entity.hitbox_position(target, i))
                local _, entindex = client.trace_line(local_player, origin.x, origin.y, origin.z, target_hitbox.x, target_hitbox.y, target_hitbox.z)
        
                if entindex == target then
                    eternal.cache.awall_data = 'Hitbox'
                    return true
                elseif (entindex ~= 0 and entindex ~= -1) then
                    if entity.get_classname(entindex) == 'CBaseEntity' then
                        eternal.cache.awall_data = 'Glass'
                        return true
                    end
                end
            end
        
            eternal.cache.awall_data = 'None'
            return false
        end
    }

    if eternal.cache.cfg_database == nil then
        eternal.cache.cfg_database = {}
    else
        eternal.cache.cfg_database = json.parse(eternal.cache.cfg_database)
    end

    eternal.menu = {
        main = {
            master_switch = ui.new_checkbox('aa', 'Anti-aimbot angles', eternal.colorful_text:text({{160, 146, 255}, 'Eter'})..eternal.colorful_text:text({{200, 200, 200}, 'nal'})),
            menu_navigator = ui.new_combobox('aa', 'Anti-aimbot angles', 'Menu navigator', 'Anti-aim', 'Visual', 'Misc', 'Cfg'),
            resolver = ui.new_checkbox('Players', 'Adjustments', 'Resolve roll')
        },
    
        anti_aim = {
            aa_master = ui.new_checkbox('aa', 'Anti-aimbot angles', 'Enable anti-aim'),
            tab_selection = ui.new_combobox('aa', 'Anti-aimbot angles', 'Tab selector', 'Constructor', 'Additional'),

            pitch_hotkey = ui.new_hotkey('aa', 'Anti-aimbot angles', 'Override pitch'),

            lean_enablers = ui.new_multiselect('aa', 'Anti-aimbot angles', 'Body lean '..eternal.colorful_text:text({{200, 200, 200}, '['})..eternal.colorful_text:text({{255, 75, 40}, 'exploit'})..eternal.colorful_text:text({{200, 200, 200}, ']'}), 'Hotkey', 'Stand', 'Duck', 'Duck walk', 'Slow', 'Walk', 'In-Air', 'Sideways'),
            lean_hotkey = ui.new_hotkey('aa', 'Anti-aimbot angles', 'Lean hotkey', true),

            anti_flicker = ui.new_multiselect('aa', 'Anti-aimbot angles', 'Anti flicker '..eternal.colorful_text:text({{200, 200, 200}, '['})..eternal.colorful_text:text({{178, 255, 122}, 'safety'})..eternal.colorful_text:text({{200, 200, 200}, ']'}), 'Unstable internet', 'Holding grenade', 'On fake duck'),
            at_targets = ui.new_checkbox('aa', 'Anti-aimbot angles', 'At targets'),
            lower_body_yaw = ui.new_checkbox('aa', 'Anti-aimbot angles', 'Lower body yaw'),


            current_team = ui.new_combobox('aa', 'Anti-aimbot angles', 'Team force', 'Counter-Terrorists', 'Terrorists'),
            current_state = ui.new_combobox('aa', 'Anti-aimbot angles', 'Player states', eternal.cache.player_states),
            current_fl_state = ui.new_combobox('aa', 'Fake lag', 'Lag states', eternal.cache.fake_lag_states),

            states = { ['Counter-Terrorists'] = {}, ['Terrorists'] = {} },
            fl_states = {},
    
            on_shot_aa_settings = ui.new_multiselect('aa', 'Other', 'On shot anti-aim '..eternal.colorful_text:text({{200, 200, 200}, '['})..eternal.colorful_text:text({{255, 75, 40}, 'disablers'})..eternal.colorful_text:text({{200, 200, 200}, ']'}), 'Stand', 'Duck', 'Slow', 'Walk', 'In-Air'),
            on_shot_aa_hotkey = ui.new_hotkey('aa', 'Other', 'On shot anti-aim key', true)
        },
    
        visual = {
            custom_logs = ui.new_multiselect('aa', 'Anti-aimbot angles', 'Event logs', 'Hits', 'Misses', 'Panel', 'Console', 'On-screen'),
            custom_log_additive = ui.new_slider('aa', 'Anti-aimbot angles', '\nAdditive', 0, 200, 50),
            
            indicator_options = ui.new_multiselect('aa', 'Anti-aimbot angles', 'Indicator options', 'Crosshair keybinds', 'Body yaw amount', 'Body yaw side', 'Arrows'),
            crosshair_keybinds = ui.new_multiselect('aa', 'Anti-aimbot angles', 'Crosshair keybinds', 'Field of view', 'On-shot aa', 'Freestanding', 'Safe point', 'Force baim', 'Fake duck', 'Ping spike', 'Damage override', 'Pitch override', 'Body lean'),
            arrow_options = ui.new_combobox('aa', 'Anti-aimbot angles', 'Arrow options', '‹ ›', '⯇⯈', 'Teamskeet'),
            
            panel_options = ui.new_multiselect('aa', 'Anti-aimbot angles', 'Panel options', 'Watermark', 'Debug panel', 'Pulsate'),
            watermark_options = ui.new_multiselect('aa', 'Anti-aimbot angles', 'Watermark options', 'Build', 'Latency', 'Time'),
            
            main_color_label = ui.new_label('aa', 'Anti-aimbot angles', 'Main crosshair color'),
            main_indicator_color = ui.new_color_picker('aa', 'Anti-aimbot angles', 'eternal_color_picker_main', 215, 255, 165, 255),
            
            secondary_color_label = ui.new_label('aa', 'Anti-aimbot angles', 'Secondary crosshair color'),
            secondary_indicator_color = ui.new_color_picker('aa', 'Anti-aimbot angles', 'eternal_color_picker_secondary', 175, 175, 175, 255),

            debug_panel_x = ui.new_slider('aa', 'Anti-aimbot angles', 'debug_panel_x', 0, 10000, 600),
            debug_panel_y = ui.new_slider('aa', 'Anti-aimbot angles', 'debug_panel_y', 0, 10000, 450),
        },
        
        misc = {
            hitbox_selection = ui.new_combobox('rage', 'Aimbot', 'Hitbox selection', 'Default', 'Closest to crosshair'),

            dynamic_fov = ui.new_checkbox('rage', 'Aimbot', 'Dynamic field of view'),
            minimum_fov = ui.new_slider('rage', 'Aimbot', 'Minimum\n fov', 1, 180, 2, true, '°', 1),
            maximum_fov = ui.new_slider('rage', 'Aimbot', 'Maximum\n fov', 1, 180, 6, true, '°', 1),
            fov_scale = ui.new_slider('rage', 'Aimbot', 'Scale\n fov', 75, 200, 125, true, 'x', 0.01),

            aimbot_disablers = ui.new_multiselect('aa', 'Anti-aimbot angles', 'Aimbot ['..eternal.colorful_text:text({{255, 75, 40}, 'disablers'})..eternal.colorful_text:text({{255, 255, 255}, ']'}), 'Local player flashed', 'Enemy in smoke'),
            animation_select = ui.new_multiselect('aa', 'Anti-aimbot angles', 'Animations '..eternal.colorful_text:text({{200, 200, 200}, '['})..eternal.colorful_text:text({{107, 154, 255}, 'client'})..eternal.colorful_text:text({{200, 200, 200}, ']'}), 'Static legs: in-air', 'Static legs: slow', 'Michael Jackson'),
            
            fs_hotkey = ui.new_hotkey('aa', 'Anti-aimbot angles', 'Freestanding '..eternal.colorful_text:text({{200, 200, 200}, '['})..eternal.colorful_text:text({{255, 75, 40}, 'disablers'})..eternal.colorful_text:text({{200, 200, 200}, ']'})),
            fs_disablers = ui.new_multiselect('aa', 'Anti-aimbot angles', '\nFS disablers', 'In-Air', 'Duck', 'Slow'),
            fs_exclude = ui.new_checkbox('aa', 'Anti-aimbot angles', 'Exclude state'),

            auto_fire_master = ui.new_checkbox('aa', 'Anti-aimbot angles', 'Automatic fire'),
            auto_fire_key = ui.new_hotkey('aa', 'Anti-aimbot angles', 'Automatic fire key', true),
            
            auto_wall_master = ui.new_checkbox('aa', 'Anti-aimbot angles', 'Automatic penetration'),
            auto_wall_key = ui.new_hotkey('aa', 'Anti-aimbot angles', 'Auto wall key', true),
            
            visible_hitbox = ui.new_checkbox('aa', 'Anti-aimbot angles', 'Legit automatic penetration'),

            peek_switch = ui.new_checkbox('aa', 'Anti-aimbot angles', 'Peek assist'),
            peek_default_hotkey = ui.new_hotkey('aa', 'Anti-aimbot angles', 'Default', true),
            peek_options = ui.new_multiselect('aa', 'Anti-aimbot angles', '\nPeek selectables', 'Include dormant', 'Exclude limbs', 'Prediction', 'Crosshair'),
            peek_return = ui.new_multiselect('aa', 'Anti-aimbot angles', '\nPeek return', 'Retreat on shot', 'Retreat on key release'),
            quick_peek_return = ui.new_combobox('aa', 'Anti-aimbot angles', '\nQuick peek assist return', 'Toggle', 'On hotkey', 'Off hotkey'),
        
            manual_enable = ui.new_checkbox('aa', 'Anti-aimbot angles', 'Manual anti-aim'),
            manual_left_hotkey = ui.new_hotkey('aa', 'Anti-aimbot angles', 'Left'),
            manual_right_hotkey = ui.new_hotkey('aa', 'Anti-aimbot angles', 'Right'),
            manual_forward_hotkey = ui.new_hotkey('aa', 'Anti-aimbot angles', 'Forward'),

            console_filtering = ui.new_checkbox('aa', 'Anti-aimbot angles', 'Filter console'),
            clan_tag = ui.new_combobox('misc', 'Miscellaneous', 'Clan tag', '-', 'Eternal', 'GameSense')
        },

        cfg = {
            storage = ui.new_textbox('aa', 'anti-aimbot angles', 'config name'),

            list = ui.new_listbox('aa', 'Anti-aimbot angles', '\neternal rage list', eternal.func.manage_database(eternal.cache.cfg_database)),
            
            tabs = ui.new_multiselect('AA', 'Anti-aimbot angles', 'Selected tabs', 'Anti-aim', 'Visual', 'Misc'),

            load = ui.new_button('aa', 'Anti-aimbot angles', 'Load', function()
                if #ui.get(eternal.menu.cfg.storage) == 0 then
                    return log('Please select a config to load.')
                end
                
                if #ui.get(eternal.menu.cfg.tabs) == 0 then
                    return log('Selected tabs cannot be empty.')
                end

                local settings = json.parse(base64.decode(eternal.cache.cfg_database[ui.get(eternal.menu.cfg.storage)]))
                local to_import = {}

                table.insert(to_import, eternal.cache.contains.tabs.aa and {'aa', eternal.menu.anti_aim} or {})
                table.insert(to_import, eternal.cache.contains.tabs.visual and {'visual', eternal.menu.visual} or {})
                table.insert(to_import, eternal.cache.contains.tabs.misc and {'misc', eternal.menu.misc} or {})

                eternal.func.import_tab(settings, to_import, 'loaded')
            end),

            delete = ui.new_button('aa', 'Anti-aimbot angles', 'Delete', function() end),

            save = ui.new_button('aa', 'Anti-aimbot angles', 'Save', function() end),

            import = ui.new_button('aa', 'Anti-aimbot angles', 'Import', function()
                if #ui.get(eternal.menu.cfg.tabs) == 0 then
                    return log('Selected tabs cannot be empty.')
                end  

                local settings = json.parse(eternal.func.xorstr(base64.decode(eternal.func.fetch_clipboard()), 'ddd8f12d0e7170833896e8c1a1eab749a506cc3efd86e5c3c21235eab81f746f'))
                local to_import = {}

                table.insert(to_import, eternal.cache.contains.tabs.aa and {'aa', eternal.menu.anti_aim} or {})
                table.insert(to_import, eternal.cache.contains.tabs.visual and {'visual', eternal.menu.visual} or {})
                table.insert(to_import, eternal.cache.contains.tabs.misc and {'misc', eternal.menu.misc} or {})

                eternal.func.import_tab(settings, to_import, 'imported')
            end),

            export = ui.new_button('aa', 'Anti-aimbot angles', 'Export', function()
                if #ui.get(eternal.menu.cfg.tabs) == 0 then
                    return log('Selected tabs cannot be empty.')
                end

                local to_export = {}
        
                if eternal.cache.contains.tabs.aa then
                    table.insert(to_export, {'aa', eternal.menu.anti_aim})
                end
        
                if eternal.cache.contains.tabs.visual then
                    table.insert(to_export, {'visual', eternal.menu.visual})
                end
        
                if eternal.cache.contains.tabs.misc then
                    table.insert(to_export, {'misc', eternal.menu.misc})
                end

                local settings = eternal.func.export_tab(to_export)
                local config_data = base64.encode(eternal.func.xorstr(json.stringify(settings), 'ddd8f12d0e7170833896e8c1a1eab749a506cc3efd86e5c3c21235eab81f746f'))

                eternal.func.set_clipboard(config_data)
                log('Exported config to clipboard.')
            end)
        }
    }

    ui.set_callback(eternal.menu.cfg.delete, function()
        eternal.cache.cfg_database[ui.get(eternal.menu.cfg.storage)] = nil
        ui.update(eternal.menu.cfg.list, eternal.func.manage_database(eternal.cache.cfg_database))
        writefile('csgo/eternal/eternal_rage_semi_cfg.json', json.stringify(eternal.cache.cfg_database))

        ui.set(eternal.menu.cfg.storage, '')
    end)

    ui.set_callback(eternal.menu.cfg.save, function()
        if #ui.get(eternal.menu.cfg.storage) == 0 then
            return log('Config name can\'t be empty.')
        end

        local to_export = {}
        local settings = {}

        table.insert(to_export, {'aa', eternal.menu.anti_aim})
        table.insert(to_export, {'visual', eternal.menu.visual})
        table.insert(to_export, {'misc', eternal.menu.misc})

        for count = 1, #to_export do
            eternal.cache.cfg_string = count == #to_export and eternal.cache.cfg_string .. to_export[count][1] .. '' or eternal.cache.cfg_string .. to_export[count][1] .. ', '
        end

        local settings = eternal.func.export_tab(to_export)
        local cfg_value = ui.get(eternal.menu.cfg.storage)

        eternal.cache.cfg_database[cfg_value] = base64.encode(json.stringify(settings))
        ui.update(eternal.menu.cfg.list, eternal.func.manage_database(eternal.cache.cfg_database))
        writefile('csgo/eternal/eternal_rage_semi_cfg.json', json.stringify(eternal.cache.cfg_database))

        log(string.format('Saved %s config.', cfg_value))
        ui.set(eternal.menu.cfg.storage, cfg_value)
        eternal.cache.cfg_string = ''
    end)

    ui.set_callback(eternal.menu.cfg.list, function(item)
        local errorcheck, returnget = pcall(function() return eternal.func.manage_database(eternal.cache.cfg_database)[ui.get(eternal.menu.cfg.list)+1] end)
        ui.set(eternal.menu.cfg.storage, returnget == nil and '' or returnget)
    end)
    
    for i=1, #eternal.cache.player_states do
        eternal.menu.anti_aim.states['Counter-Terrorists'][eternal.cache.player_states[i]] = {
            enable_state = ui.new_checkbox('aa', 'Anti-aimbot angles', string.format('Enable state\n [%s - %s] semi', 'Counter-Terrorists', eternal.cache.player_states[i])),

            state_type = ui.new_combobox('aa', 'Anti-aimbot angles', string.format(eternal.cache.ct_menu..'State type\n [%s - %s] semi', 'Counter-Terrorists', eternal.cache.player_states[i]), 'Preset', 'Single', 'Binary'),
            chosen_type = ui.new_combobox('aa', 'Anti-aimbot angles', string.format('\nSide settings [%s - %s] semi', 'Counter-Terrorists', eternal.cache.player_states[i]), 'Left', 'Right'),

            ['Left'] = {
                body_yaw = {
                    ui.new_combobox('aa', 'Anti-aimbot angles', string.format('Body yaw\n [%s - %s - %s] semi', 'Counter-Terrorists', 'Left', eternal.cache.player_states[i]), 'Static', 'Jitter'),
                    ui.new_slider('aa', 'Anti-aimbot angles', string.format('\n Body yaw slider [%s - %s - %s] semi', 'Counter-Terrorists', 'Left', eternal.cache.player_states[i]), -1, 1, 0, true, '°', 1, { [-1] = 'Left', [0] = 'Middle', [1] = 'Right' })
                },
    
                fs_body_yaw = ui.new_combobox('aa', 'Anti-aimbot angles', string.format('Freestanding\n [%s - %s - %s] semi', 'Counter-Terrorists', 'Left', eternal.cache.player_states[i]), 'Off', 'Edge', 'Damage'),
                fs_reverse = ui.new_checkbox('aa', 'Anti-aimbot angles', string.format('Reverse\n [%s - %s - %s] semi', 'Counter-Terrorists', 'Left', eternal.cache.player_states[i]))
            },

            ['Right'] = {
                body_yaw = {
                    ui.new_combobox('aa', 'Anti-aimbot angles', string.format('Body yaw\n [%s - %s - %s] semi', 'Counter-Terrorists', 'Right', eternal.cache.player_states[i]), 'Static', 'Jitter'),
                    ui.new_slider('aa', 'Anti-aimbot angles', string.format('\n Body yaw slider [%s - %s - %s] semi', 'Counter-Terrorists', 'Right', eternal.cache.player_states[i]), -1, 1, 0, true, '°', 1, { [-1] = 'Left', [0] = 'Middle', [1] = 'Right' })
                },
    
                fs_body_yaw = ui.new_combobox('aa', 'Anti-aimbot angles', string.format('Freestanding\n [%s - %s - %s] semi', 'Counter-Terrorists', 'Right', eternal.cache.player_states[i]), 'Off', 'Edge', 'Damage'),
                fs_reverse = ui.new_checkbox('aa', 'Anti-aimbot angles', string.format('Reverse\n [%s - %s - %s] semi', 'Counter-Terrorists', 'Right', eternal.cache.player_states[i]))
            }
        }
        
        eternal.menu.anti_aim.states['Terrorists'][eternal.cache.player_states[i]] = {
            enable_state = ui.new_checkbox('aa', 'Anti-aimbot angles', string.format('Enable state\n [%s - %s] semi', 'Terrorists', eternal.cache.player_states[i])),

            state_type = ui.new_combobox('aa', 'Anti-aimbot angles', string.format(eternal.cache.t_menu..'State type\n [%s - %s] semi', 'Terrorists', eternal.cache.player_states[i]), 'Preset', 'Single', 'Binary'),
            chosen_type = ui.new_combobox('aa', 'Anti-aimbot angles', string.format('\nSide settings [%s - %s] semi', 'Terrorists', eternal.cache.player_states[i]), 'Left', 'Right'),

            ['Left'] = {
                body_yaw = {
                    ui.new_combobox('aa', 'Anti-aimbot angles', string.format('Body yaw\n [%s - %s - %s] semi', 'Terrorists', 'Left', eternal.cache.player_states[i]), 'Static', 'Jitter'),
                    ui.new_slider('aa', 'Anti-aimbot angles', string.format('\n Body yaw slider [%s - %s - %s] semi', 'Terrorists', 'Left', eternal.cache.player_states[i]), -1, 1, 0, true, '°', 1, { [-1] = 'Left', [0] = 'Middle', [1] = 'Right' })
                },
    
                fs_body_yaw = ui.new_combobox('aa', 'Anti-aimbot angles', string.format('Freestanding\n [%s - %s - %s] semi', 'Terrorists', 'Left', eternal.cache.player_states[i]), 'Off', 'Edge', 'Damage'),
                fs_reverse = ui.new_checkbox('aa', 'Anti-aimbot angles', string.format('Reverse\n [%s - %s - %s] semi', 'Terrorists', 'Left', eternal.cache.player_states[i]))
            },

            ['Right'] = {
                body_yaw = {
                    ui.new_combobox('aa', 'Anti-aimbot angles', string.format('Body yaw\n [%s - %s - %s] semi', 'Terrorists', 'Right', eternal.cache.player_states[i]), 'Static', 'Jitter'),
                    ui.new_slider('aa', 'Anti-aimbot angles', string.format('\n Body yaw slider [%s - %s - %s] semi', 'Terrorists', 'Right', eternal.cache.player_states[i]), -1, 1, 0, true, '°', 1, { [-1] = 'Left', [0] = 'Middle', [1] = 'Right' })
                },
    
                fs_body_yaw = ui.new_combobox('aa', 'Anti-aimbot angles', string.format('Freestanding\n [%s - %s - %s] semi', 'Terrorists', 'Right', eternal.cache.player_states[i]), 'Off', 'Edge', 'Damage'),
                fs_reverse = ui.new_checkbox('aa', 'Anti-aimbot angles', string.format('Reverse\n [%s - %s - %s] semi', 'Terrorists', 'Right', eternal.cache.player_states[i]))
            }
        }
    end

    eternal.menu.misc.transport = ui.new_button('aa', 'Anti-aimbot angles', 'Copy state to opposite team', function()
        local current_team = ui.get(eternal.menu.anti_aim.current_team)
        local current_state = ui.get(eternal.menu.anti_aim.current_state)

        local opposite_team = current_team == 'Counter-Terrorists' and 'Terrorists' or 'Counter-Terrorists'
        local to_swap = eternal.menu.anti_aim.states[current_team][current_state]

        for i, v in pairs(to_swap) do
            if type(v) == 'table' then
                for ii, vv in pairs(v) do
                    if type(vv) == 'table' then
                        for iii, vvv in pairs(vv) do
                            if type(vvv) == 'table' then
                                for iiii, vvvv in pairs(vvv) do
                                    ui.set(eternal.menu.anti_aim.states[opposite_team][current_state][i][ii][iii][iiii], ui.get(vvvv))
                                end
                            else
                                ui.set(eternal.menu.anti_aim.states[opposite_team][current_state][i][ii][iii], ui.get(vvv))
                            end
                        end
                    else
                        ui.set(eternal.menu.anti_aim.states[opposite_team][current_state][i][ii], ui.get(vv))
                    end
                end
            else
                ui.set(eternal.menu.anti_aim.states[opposite_team][current_state][i], ui.get(v))
            end
        end
    end)

    for i=1, #eternal.cache.fake_lag_states do
        eternal.menu.anti_aim.fl_states[eternal.cache.fake_lag_states[i]] = {
            fl_amount = ui.new_combobox('aa', 'Fake lag', string.format('Amount\n [%s]', eternal.cache.fake_lag_states[i]), 'Optimal', 'Dynamic', 'Maximum', 'Fluctuate'),
            fl_var = ui.new_slider('aa', 'Fake lag', string.format('Variance\n [%s]', eternal.cache.fake_lag_states[i]), 0, 101, 0, true, '%', 1, { [101] = 'Velocity' }),
            fl_limit = ui.new_slider('aa', 'Fake lag', string.format('Limit\n [%s]', eternal.cache.fake_lag_states[i]), 1, 6, 1),
            enable_state = ui.new_checkbox('aa', 'Fake lag', string.format('Enable state\n [%s]', eternal.cache.fake_lag_states[i]))
        }
    end

    eternal.handler = {
        optimization = function()
            eternal.cache.is_menu_open = ui.is_menu_open()

            --> This code only checks whether ui elements contain certain values when the ui is open
            if not eternal.cache.is_menu_open and not eternal.cache.should_optimize then
                return
            end

            --> Screen size
            eternal.cache.screen_size = eternal.includes.vector(client.screen_size())

            --> Menu controls
            eternal.cache.master_switch = ui.get(eternal.menu.main.master_switch)
            eternal.cache.navigator = ui.get(eternal.menu.main.menu_navigator)

            --> Anti-aim
            eternal.cache.contains.lean_sideways = eternal.func.contains(ui.get(eternal.menu.anti_aim.lean_enablers), 'Sideways')
            eternal.cache.contains.lean_hotkey = eternal.func.contains(ui.get(eternal.menu.anti_aim.lean_enablers), 'Hotkey')

            eternal.cache.contains.anti_flicker.unstable_internet = eternal.func.contains(ui.get(eternal.menu.anti_aim.anti_flicker), 'Unstable internet')
            eternal.cache.contains.anti_flicker.holding_grenade = eternal.func.contains(ui.get(eternal.menu.anti_aim.anti_flicker), 'Holding grenade')
            eternal.cache.contains.anti_flicker.fake_duck = eternal.func.contains(ui.get(eternal.menu.anti_aim.anti_flicker), 'On fake duck')

            --> Visual
            eternal.cache.contains.indicator_options.keybinds = eternal.func.contains(ui.get(eternal.menu.visual.indicator_options), 'Crosshair keybinds')
            eternal.cache.contains.indicator_options.body_yaw_amount = eternal.func.contains(ui.get(eternal.menu.visual.indicator_options), 'Body yaw amount')
            eternal.cache.contains.indicator_options.body_yaw_side = eternal.func.contains(ui.get(eternal.menu.visual.indicator_options), 'Body yaw side')
            eternal.cache.contains.indicator_options.arrows = eternal.func.contains(ui.get(eternal.menu.visual.indicator_options), 'Arrows')

            eternal.cache.contains.crosshair_keybinds.fov = eternal.func.contains(ui.get(eternal.menu.visual.crosshair_keybinds), 'Field of view')
            eternal.cache.contains.crosshair_keybinds.on_shot = eternal.func.contains(ui.get(eternal.menu.visual.crosshair_keybinds), 'On-shot aa')
            eternal.cache.contains.crosshair_keybinds.freestand = eternal.func.contains(ui.get(eternal.menu.visual.crosshair_keybinds), 'Freestanding')
            eternal.cache.contains.crosshair_keybinds.safe_point = eternal.func.contains(ui.get(eternal.menu.visual.crosshair_keybinds), 'Safe point')
            eternal.cache.contains.crosshair_keybinds.force_baim = eternal.func.contains(ui.get(eternal.menu.visual.crosshair_keybinds), 'Force baim')
            eternal.cache.contains.crosshair_keybinds.fake_duck = eternal.func.contains(ui.get(eternal.menu.visual.crosshair_keybinds), 'Fake duck')
            eternal.cache.contains.crosshair_keybinds.ping_spike = eternal.func.contains(ui.get(eternal.menu.visual.crosshair_keybinds), 'Ping spike')
            eternal.cache.contains.crosshair_keybinds.pitch_override = eternal.func.contains(ui.get(eternal.menu.visual.crosshair_keybinds), 'Pitch override')
            eternal.cache.contains.crosshair_keybinds.damage_override = eternal.func.contains(ui.get(eternal.menu.visual.crosshair_keybinds), 'Damage override')
            eternal.cache.contains.crosshair_keybinds.body_lean = eternal.func.contains(ui.get(eternal.menu.visual.crosshair_keybinds), 'Body lean')

            eternal.cache.contains.panel_options.watermark = eternal.func.contains(ui.get(eternal.menu.visual.panel_options), 'Watermark')
            eternal.cache.contains.panel_options.debug_panel = eternal.func.contains(ui.get(eternal.menu.visual.panel_options), 'Debug panel')
            eternal.cache.contains.panel_options.pulsate = eternal.func.contains(ui.get(eternal.menu.visual.panel_options), 'Pulsate')

            eternal.cache.contains.watermark_options.build = eternal.func.contains(ui.get(eternal.menu.visual.watermark_options), 'Build')
            eternal.cache.contains.watermark_options.latency = eternal.func.contains(ui.get(eternal.menu.visual.watermark_options), 'Latency')
            eternal.cache.contains.watermark_options.time = eternal.func.contains(ui.get(eternal.menu.visual.watermark_options), 'Time')

            eternal.cache.contains.shots.hits = eternal.func.contains(ui.get(eternal.menu.visual.custom_logs), 'Hits')
            eternal.cache.contains.shots.misses = eternal.func.contains(ui.get(eternal.menu.visual.custom_logs), 'Misses')
            eternal.cache.contains.shots.panel = eternal.func.contains(ui.get(eternal.menu.visual.custom_logs), 'Panel')
            eternal.cache.contains.shots.on_screen = eternal.func.contains(ui.get(eternal.menu.visual.custom_logs), 'On-screen')
            eternal.cache.contains.shots.console = eternal.func.contains(ui.get(eternal.menu.visual.custom_logs), 'Console')

            --> Miscellaneous
            eternal.cache.contains.animation_select.static_legs_air = eternal.func.contains(ui.get(eternal.menu.misc.animation_select), 'Static legs: in-air')
            eternal.cache.contains.animation_select.static_legs_slow = eternal.func.contains(ui.get(eternal.menu.misc.animation_select), 'Static legs: slow')
            eternal.cache.contains.animation_select.moonwalk = eternal.func.contains(ui.get(eternal.menu.misc.animation_select), 'Michael Jackson')

            eternal.cache.contains.ab_disablers.flashed = eternal.func.contains(ui.get(eternal.menu.misc.aimbot_disablers), 'Local player flashed')
            eternal.cache.contains.ab_disablers.in_smoke = eternal.func.contains(ui.get(eternal.menu.misc.aimbot_disablers), 'Enemy in smoke')

            eternal.cache.contains.peek.include_dormant = eternal.func.contains(ui.get(eternal.menu.misc.peek_options), 'Include dormant')
            eternal.cache.contains.peek.exclude_limbs = eternal.func.contains(ui.get(eternal.menu.misc.peek_options), 'Exclude limbs')
            eternal.cache.contains.peek.prediction = eternal.func.contains(ui.get(eternal.menu.misc.peek_options), 'Prediction')
            eternal.cache.contains.peek.crosshair = eternal.func.contains(ui.get(eternal.menu.misc.peek_options), 'Crosshair')

            --> Config
            eternal.cache.contains.tabs.aa = eternal.func.contains(ui.get(eternal.menu.cfg.tabs), 'Anti-aim')
            eternal.cache.contains.tabs.visual = eternal.func.contains(ui.get(eternal.menu.cfg.tabs), 'Visual')
            eternal.cache.contains.tabs.misc = eternal.func.contains(ui.get(eternal.menu.cfg.tabs), 'Misc')

            --> Reset on round start
            eternal.cache.should_optimize = false
        end,

        menu = LPH_JIT_MAX(function()
            if not eternal.cache.is_menu_open then
                return
            end

            local anti_aim_tab = ui.get(eternal.menu.anti_aim.tab_selection)
            local current_team = ui.get(eternal.menu.anti_aim.current_team)
            local current_state = ui.get(eternal.menu.anti_aim.current_state)
            
            eternal.func.setup(eternal.menu.anti_aim.fl_states, ui.get(eternal.menu.anti_aim.current_fl_state), eternal.cache.master_switch)
            eternal.func.vis(eternal.menu.anti_aim.states['Counter-Terrorists'], current_state, eternal.cache.master_switch and eternal.cache.navigator == 'Anti-aim' and ui.get(eternal.menu.anti_aim.aa_master) and anti_aim_tab == 'Constructor' and current_team == 'Counter-Terrorists')
            eternal.func.vis(eternal.menu.anti_aim.states['Terrorists'], current_state, eternal.cache.master_switch and eternal.cache.navigator == 'Anti-aim' and ui.get(eternal.menu.anti_aim.aa_master) and anti_aim_tab == 'Constructor' and current_team == 'Terrorists')

            eternal.func.default_visibility(not eternal.cache.master_switch)
            eternal.func.eternal_visibility(eternal.cache.master_switch, eternal.cache.navigator)
        end),

        indicators = LPH_JIT_MAX(function()
            --> Grab local player
            eternal.cache.local_player = entity.get_local_player()

            if not eternal.cache.master_switch then
                return
            end

            --> On-screen logs
            if eternal.cache.contains.shots.on_screen then
                eternal.func.notify:setup({ max_logs = 10, simple = not eternal.cache.contains.shots.panel, center_additive = ui.get(eternal.menu.visual.custom_log_additive) + 50})
                eternal.func.notify:think()
            end

            --> Eternal icon
            eternal.func.clan_tag()

            if entity.is_alive(eternal.cache.local_player) then
                eternal.func.default_style()

                if eternal.cache.contains.indicator_options.arrows then
                    local r1, g1, b1, a1 = ui.get(eternal.menu.visual.main_indicator_color)
                    local r2, g2, b2, a2 = ui.get(eternal.menu.visual.secondary_indicator_color)
                    
                    if ui.get(eternal.menu.visual.arrow_options) == 'Teamskeet' then
                        eternal.func.teamskeet_arrow(eternal.cache.screen_size.x / 2, eternal.cache.screen_size.y / 2, r1 , g1, b1, a1, r2, g2, b2, a2)
                    elseif eternal.cache.yaw_direction ~= 0 then
                        if eternal.cache.yaw_direction == 180 then
                            renderer.text(eternal.cache.screen_size.x / 2, eternal.cache.screen_size.y / 2 - 60,  r1, g1, b1, eternal.func.pulsate(215), 'cb+', 0, ui.get(eternal.menu.visual.arrow_options) == '⯇⯈' and '⯅' or '‸')
                        else
                            renderer.text(eternal.cache.screen_size.x / 2 + (eternal.cache.yaw_direction == -90 and -60 or 60), eternal.cache.screen_size.y / 2 - 3,  r1, g1, b1, eternal.func.pulsate(215), 'cb+', 0, eternal.cache.yaw_direction == -90 and (ui.get(eternal.menu.visual.arrow_options) == '⯇⯈' and '⯇' or '‹') or (ui.get(eternal.menu.visual.arrow_options) == '⯇⯈' and '⯈' or '›'))
                        end
                    end
                end
            end
        end),

        watermark = LPH_JIT_MAX(function()
            if not eternal.cache.master_switch or not eternal.cache.contains.panel_options.watermark then 
                return 
            end

            local r1, g1, b1, a1 = ui.get(eternal.menu.visual.main_indicator_color)
            local r2, g2, b2, a1 = ui.get(eternal.menu.visual.secondary_indicator_color)
            local pulsate = eternal.cache.contains.panel_options.pulsate and eternal.func.pulsate(255) or 255
        
            local easing_speed = 5
        
            local line_thickness = 1
            local lowerline_alpha = 45
        
            local build_selected = eternal.cache.contains.watermark_options.build
            local latency_selected = eternal.cache.contains.watermark_options.latency
            local time_selected = eternal.cache.contains.watermark_options.time
        
            local nickname = obex_data.username:lower()
            local text = ''
        
            local sys_time = { client.system_time() }
            local actual_time = time_selected and eternal.colorful_text:text({{255, 255, 255}, string.format('%02d:%02d:%02d', sys_time[1], sys_time[2], sys_time[3])}) or ''
                
            local name_txt = eternal.colorful_text:text({{r1, g1, b1}, 'eter'})
            local name2_txt = eternal.colorful_text:text({{255, 255, 255}, 'nal'})
            local nickname_txt = eternal.colorful_text:text({{255, 255, 255}, (build_selected or latency_selected or time_selected) and nickname..'  ' or nickname})
            
            local build = eternal.colorful_text:text({{r1, g1, b1}, obex_data.build:lower()});local left_bracket = eternal.colorful_text:text({{255, 255, 255}, '['});local right_bracket = eternal.colorful_text:text({{255, 255, 255}, ']'})
            local build_txt = (latency_selected or time_selected) and left_bracket..build..right_bracket..'  ' or left_bracket..build..right_bracket or ''
            build_txt = build_selected and build_txt or ''
        
            local latency = client.latency() * 1000
            local latency_text = latency_selected and eternal.colorful_text:text({{255, 255, 255}, time_selected and string.format('delay: %dms  ', latency) or string.format('delay: %dms', latency)}) or ''
            text = ('%s%s  %s%s%s%s'):format(name_txt, name2_txt, nickname_txt, build_txt, latency_text, actual_time)
        
            local textw, textheight = renderer.measure_text('', text)
        
            eternal.cache.watermark_width = eternal.func.lerp(eternal.cache.watermark_width, textw + 15, globals.frametime() * easing_speed)
            eternal.cache.watermark_adder = eternal.func.lerp(eternal.cache.watermark_adder, 0, globals.frametime() * easing_speed)
            eternal.cache.watermark_textwidth = eternal.func.lerp(eternal.cache.watermark_textwidth, textw + 5, globals.frametime() * easing_speed)
        
            local width_anim = math.floor(eternal.cache.watermark_width)
            local textwidth_anim = math.floor(eternal.cache.watermark_textwidth)
        
            renderer.blur(eternal.cache.screen_size.x - width_anim - 10, 12, textwidth_anim + 6, 20)
            renderer.rectangle(eternal.cache.screen_size.x - width_anim - 10, 12, textwidth_anim + 6, 20, 20, 20, 20, 255)
            eternal.func.outline(eternal.cache.screen_size.x - width_anim - 10, 12, textwidth_anim + 6, 20, 0, 0, 0, 255)
            renderer.rectangle(eternal.cache.screen_size.x - width_anim - 10, 12, textwidth_anim + 6, 1, 0, 0, 0, 255)
            renderer.gradient(eternal.cache.screen_size.x - width_anim - 10, 12, textwidth_anim + 6, 1, r1, g1, b1, pulsate, r2, g2, b2, pulsate, true)
        
            renderer.text(eternal.cache.screen_size.x - width_anim - 5, 12 + 20 / 5, 255, 255, 255, 255, '', textwidth_anim, text)
        end),

        debug_panel = LPH_JIT_MAX(function()
            if not eternal.cache.master_switch or not eternal.cache.contains.panel_options.debug_panel then 
                return 
            end
            
            local debug_x = ui.get(eternal.menu.visual.debug_panel_x);local debug_y = ui.get(eternal.menu.visual.debug_panel_y)
            if eternal.cache.is_menu_open then local a,b=ui.mouse_position()if eternal.cache.debug_panel.dragging and not client.key_state(0x01)then eternal.cache.debug_panel.dragging=false end;if eternal.cache.debug_panel.dragging and client.key_state(0x01)then debug_x=a-eternal.cache.debug_panel.drag_x;debug_y=b-eternal.cache.debug_panel.drag_y end;if eternal.func.intersect(debug_x,debug_y,eternal.cache.debug_panel.w,eternal.cache.debug_panel.h)and client.key_state(0x01)then if debug_x<=0 then debug_x=0 end;if debug_y<=0 then debug_y=0 end;if debug_x+eternal.cache.debug_panel.w>=eternal.cache.screen_size.x then debug_x=eternal.cache.screen_size.x-eternal.cache.debug_panel.w end;if debug_y+eternal.cache.debug_panel.h>=eternal.cache.screen_size.y then debug_y=eternal.cache.screen_size.y-eternal.cache.debug_panel.h end;eternal.cache.debug_panel.dragging=true;eternal.cache.debug_panel.drag_x=a-debug_x;eternal.cache.debug_panel.drag_y=b-debug_y;ui.set(eternal.menu.visual.debug_panel_x,debug_x)ui.set(eternal.menu.visual.debug_panel_y,debug_y)end end
            
            local r1, g1, b1, a1 = ui.get(eternal.menu.visual.main_indicator_color)
            local r2, g2, b2, a1 = ui.get(eternal.menu.visual.secondary_indicator_color)
            local pulsate = eternal.cache.contains.panel_options.pulsate and eternal.func.pulsate(255) or 255
            local double_tap = ui.get(eternal.ref.rage.double_tap[1]) and ui.get(eternal.ref.rage.double_tap[2])
            
            renderer.blur(debug_x, debug_y, eternal.cache.debug_panel.w, eternal.cache.debug_panel.h)
            renderer.rectangle(debug_x, debug_y, eternal.cache.debug_panel.w, eternal.cache.debug_panel.h, 20, 20, 20, 255)
            eternal.func.outline(debug_x, debug_y, eternal.cache.debug_panel.w, eternal.cache.debug_panel.h, 0, 0, 0, 255)
            renderer.rectangle(debug_x, debug_y, eternal.cache.debug_panel.w, 1, 0, 0, 0, 255)
            renderer.gradient(debug_x, debug_y, eternal.cache.debug_panel.w, 1, r1, g1, b1, pulsate, r2, g2, b2, pulsate, true)
        
            local debug_panel_text = renderer.measure_text('-', '   DEBUG   |   PANEL     ')
            eternal.func.renderer_multi_text(debug_x + (eternal.cache.debug_panel.w / 2) - (debug_panel_text / 2), debug_y - 12, '-', 3, {
                { text = 'DEBUG', color = { 255, 255, 255, 255 } }, 
                { text = '|', color = { 255, 255, 255, 255 } },
                { text = 'PANEL', color = { r1, g1, b1, 255 } }
            })
        
            local panel_name = string.upper(string.sub(eternal.cache.threat_name, 1, 20))
            local measured_text = renderer.measure_text('-', panel_name)
            local size_limit = measured_text >= 50 and math.floor(measured_text / (panel_name:len() / 2) ^ 1.05) or panel_name:len()
        
            eternal.func.renderer_multi_text(debug_x, debug_y + 2, '-', 3, {
                { text = 'THREAT', color = { r1, g1, b1, 255 } }, 
                { text = '|', color = { 255, 255, 255, 255 } },
                { text = string.sub(panel_name, 1, size_limit), color = { 255, 255, 255, 255 } }
            })
        
            eternal.func.renderer_multi_text(debug_x, debug_y + 12, '-', 3, {
                { text = 'PING', color = { 255, 255, 255, 255 } }, 
                { text = '|', color = { 255, 255, 255, 255 } },
                { text = string.upper(tostring(eternal.cache.threat_ping)), color = { r1, g1, b1, 255 } }
            })

            local is_cheating = eternal.cache.threat and plist.get(eternal.cache.threat, 'Correction active') or false
        
            eternal.func.renderer_multi_text(debug_x, debug_y + 22, '-', 3, {
                { text = 'CHEATER', color = { r1, g1, b1, 255 } }, 
                { text = '|', color = { 255, 255, 255, 255 } },
                { text = is_cheating and 'TRUE' or 'FALSE', color = { 255, 255, 255, 255 } }
            })

            eternal.func.renderer_multi_text(debug_x, debug_y + 32, '-', 3, {
                { text = 'AUTOWALL', color = { 255, 255, 255, 255 } }, 
                { text = '|', color = { 255, 255, 255, 255 } },
                { text = string.upper(eternal.cache.awall_data), color = { r1, g1, b1, 255 } }
            })
        
            local team_txt = eternal.cache.lp_team == 'Terrorists' and 'T' or 'CT'

            eternal.func.renderer_multi_text(debug_x, debug_y + 42, '-', 3, {
                { text = 'PRESET', color = { r1, g1, b1, 255 } }, 
                { text = '|', color = { 255, 255, 255, 255 } },
                { text = string.upper((eternal.cache.active_preset == 'Fake lag' and eternal.cache.player_state or eternal.cache.active_preset))..'  '..eternal.colorful_text:text({{255, 255, 255}, '['})..eternal.colorful_text:text({{r1, g1, b1}, team_txt})..eternal.colorful_text:text({{255, 255, 255}, ']'}), color = { 255, 255, 255, 255 } }
            })
        end),

        main = LPH_JIT_MAX(function(cmd)
            if eternal.cache.is_menu_open then 
                cmd.in_attack = false
                cmd.in_attack2 = false 
            end
        
            if not eternal.cache.master_switch or not entity.is_alive(eternal.cache.local_player) then 
                return
            end

            local weapon_ent = entity.get_player_weapon(eternal.cache.local_player)

            if not weapon_ent then
                return
            end

            --> Save local weapon
            local weapon = eternal.includes.csgo_weapons(weapon_ent)

            --> Store data about anti-aim target
            eternal.cache.threat = client.current_threat()
            eternal.cache.threat_name = entity.get_player_name(eternal.cache.threat)

            --> Game rules
            local game_rules = entity.get_game_rules()
            local freeze_time = entity.get_prop(game_rules, 'm_bFreezePeriod') == 1

            --> Store enemy weapon and enemy loop
            local enemy_weapon = eternal.includes.csgo_weapons(entity.get_player_weapon(eternal.cache.threat))
            eternal.cache.enemies = entity.get_players(true)

            --> Exploit features
            local double_tap = ui.get(eternal.ref.rage.double_tap[1]) and ui.get(eternal.ref.rage.double_tap[2])
            local on_shot_aa = ui.get(eternal.ref.aa.other.on_shot[1]) and ui.get(eternal.ref.aa.other.on_shot[2])
            local fake_duck = ui.get(eternal.ref.rage.fake_duck)

            eternal.func.peek_assist(cmd, weapon, double_tap)

            if cmd.chokedcommands == 0 then
                eternal.cache.desync_side = (eternal.cache.desync * (ui.get(eternal.ref.aa.main.yaw[1]) == '180' and -1 or 1)) < 0 and 'Left' or 'Right'
                eternal.cache.desync = freeze_time and 0 or eternal.func.get_angle(eternal.cache.local_player)

                if eternal.cache.desync > 0 then
                    eternal.cache.desync = math.ceil(eternal.cache.desync)
                else
                    eternal.cache.desync = math.floor(eternal.cache.desync)
                end

                eternal.cache.desync_amount = eternal.func.clamp(math.abs(eternal.cache.desync), 0, 57)
            end

            local vecvelocity = eternal.includes.vector(entity.get_prop(eternal.cache.local_player, 'm_vecVelocity'))
            eternal.cache.lp_velocity = math.sqrt(vecvelocity.x ^ 2 + vecvelocity.y ^ 2)
            eternal.cache.lp_team = entity.get_prop(entity.get_player_resource(), 'm_iTeam', eternal.cache.local_player) == 2 and 'Terrorists' or 'Counter-Terrorists'

            local on_ground = bit.band(entity.get_prop(eternal.cache.local_player, 'm_fFlags'), 1) == 1 and cmd.in_jump == 0
            local not_moving = eternal.cache.lp_velocity < 2
        
            if not ui.get(eternal.ref.misc.bunny_hop) then
                on_ground = bit.band(entity.get_prop(eternal.cache.local_player, 'm_fFlags'), 1) == 1
            end
            
            if not on_ground then
                eternal.cache.player_state = 'In-Air'
            else
                if fake_duck or (entity.get_prop(eternal.cache.local_player, 'm_flDuckAmount') > 0.7) then
                    eternal.cache.player_state = not_moving and 'Duck' or 'Duck walk'
                elseif not_moving then
                    eternal.cache.player_state = 'Stand'
                elseif not not_moving then
                    if ui.get(eternal.ref.aa.other.slow_motion[1]) and ui.get(eternal.ref.aa.other.slow_motion[2]) then
                        eternal.cache.player_state = 'Slow'
                    else
                        eternal.cache.player_state = 'Walk'
                    end
                end
            end

            local peeking = eternal.func.is_hittable(enemy_weapon)
            eternal.cache.hittable_ticks = peeking and eternal.cache.hittable_ticks + 1 or 0

            if (eternal.cache.hittable_ticks > 0 and eternal.cache.hittable_ticks < 16) and ui.get(eternal.menu.anti_aim.fl_states['Peek'].enable_state) then
                eternal.cache.fl_preset = 'Peek'
            elseif ui.get(eternal.ref.aa.main.body_yaw[1]) == 'Jitter' and ui.get(eternal.menu.anti_aim.fl_states['Jitter'].enable_state) then
                eternal.cache.fl_preset = 'Jitter'
            elseif eternal.cache.player_state == 'Walk' and ui.get(eternal.menu.anti_aim.fl_states['Walk'].enable_state) then
                eternal.cache.fl_preset = 'Walk'
            elseif eternal.cache.player_state == 'Slow' and ui.get(eternal.menu.anti_aim.fl_states['Slow'].enable_state) then
                eternal.cache.fl_preset = 'Slow'
            else
                eternal.cache.fl_preset = 'Global'
            end

            eternal.cache.active_preset = ui.get(eternal.menu.anti_aim.states[eternal.cache.lp_team][eternal.cache.player_state].enable_state) and eternal.cache.player_state or 'Global'
            eternal.cache.in_air = eternal.cache.player_state:find('Air')

            --> Custom on-shot
            ui.set(eternal.ref.aa.other.on_shot[1], not eternal.func.contains(ui.get(eternal.menu.anti_aim.on_shot_aa_settings), eternal.cache.player_state) and ui.get(eternal.menu.anti_aim.on_shot_aa_hotkey))
            ui.set(eternal.ref.aa.other.on_shot[2], ui.get(eternal.menu.anti_aim.on_shot_aa_hotkey) and 'Always on' or 'On hotkey')

            eternal.cache.threat_ping = (#eternal.cache.enemies == 0) and 0 or eternal.func.get_ping(entity.get_all('CCSPlayerResource')[1], eternal.cache.threat)
            local on_shot = ui.get(eternal.ref.aa.other.on_shot[1]) and ui.get(eternal.ref.aa.other.on_shot[2])

            for k, v in pairs(eternal.menu.anti_aim.fl_states) do
                if (k == eternal.cache.fl_preset) then
                    local amount = ui.get(v.fl_amount)
                    local var = ui.get(v.fl_var)
                    local limit = fake_duck and 14 or ui.get(v.fl_limit)
                    local optimal = ui.get(v.fl_amount) == 'Optimal'

                    var = var > 100 and eternal.func.clamp(eternal.cache.lp_velocity / 5, 0, 100) or var

                    ui.set(eternal.ref.aa.fl.amount, optimal and (eternal.cache.threat_ping >= 150 and 'Maximum' or 'Dynamic') or amount)
                    ui.set(eternal.ref.aa.fl.var, var)
                    ui.set(eternal.ref.aa.fl.limit, limit)
                end
            end

            eternal.cache.current_choke = cmd.chokedcommands > 0 and 1 or 0

            if ui.get(eternal.menu.anti_aim.aa_master) then                
                local net_channel_info = eternal.memory.native_netchaninfo()
                local avg_loss = eternal.memory.native_get_avg_loss(net_channel_info, 1) * 10
                local avg_choke = eternal.memory.native_get_avg_choke(net_channel_info, 1) * 10
        
                if eternal.cache.contains.anti_flicker.fake_duck and ui.get(eternal.ref.rage.fake_duck) then
                    ui.set(eternal.ref.aa.main.enabled, false)
                elseif eternal.cache.contains.anti_flicker.grenade and weapon.type == 'grenade' then
                    ui.set(eternal.ref.aa.main.enabled, false)
                elseif eternal.cache.contains.anti_flicker.unstable and avg_loss ~= 0 and avg_choke ~= 0 then
                    ui.set(eternal.ref.aa.main.enabled, false)
                else
                    ui.set(eternal.ref.aa.main.enabled, true)
                end

                local is_freestanding = (ui.get(eternal.menu.misc.fs_hotkey) and not eternal.cache.fs_disabled)
                local at_targets = ui.get(eternal.menu.anti_aim.at_targets)
                local lby = ui.get(eternal.menu.anti_aim.lower_body_yaw)

                eternal.func.run_direction()

                if eternal.cache.yaw_direction ~= 0 or (not ui.get(eternal.menu.misc.fs_exclude) and is_freestanding) then 
                    eternal.cache.active_preset = 'Sideways'
                elseif ui.get(eternal.menu.anti_aim.states[eternal.cache.lp_team]['Warmup'].enable_state) and entity.get_prop(game_rules, 'm_bWarmupPeriod') == 1 then 
                    eternal.cache.active_preset = 'Warmup'
                elseif eternal.cache.force_lean and ui.get(eternal.menu.anti_aim.states[eternal.cache.lp_team]['Lean'].enable_state) then 
                    eternal.cache.active_preset = 'Lean'
                elseif #eternal.cache.enemies == 0 and ui.get(eternal.menu.anti_aim.states[eternal.cache.lp_team]['Dormant'].enable_state) then 
                    eternal.cache.active_preset = 'Dormant'
                end

                for k, v in pairs(eternal.menu.anti_aim.states[eternal.cache.lp_team]) do
                    if (k == eternal.cache.active_preset) then
                        eternal.func.default_aa(v, cmd, at_targets, lby)
                    end
                end
                
                eternal.cache.force_lean = (ui.get(eternal.menu.anti_aim.lean_hotkey) and eternal.cache.contains.lean_hotkey) or (eternal.cache.yaw_direction ~= 0 and eternal.cache.contains.lean_sideways) or eternal.func.contains(ui.get(eternal.menu.anti_aim.lean_enablers), eternal.cache.player_state)
        
                if eternal.cache.force_lean and not eternal.cache.on_ladder and weapon.type ~= 'grenade' then
                    local is_valve_ds = ffi.cast('bool*', eternal.memory.gamerules[0] + 124)

                    if is_valve_ds ~= nil and globals.mapname() ~= nil then
                        is_valve_ds[0] = 0
                    end

                    local roll_degree = ui.get(eternal.ref.misc.anti_untrusted) and 44 or (eternal.cache.lp_velocity > 2 and 44 or 89)
                    cmd.roll = eternal.cache.desync_side == 'Left' and -roll_degree or roll_degree
                    cmd.roll = eternal.cache.yaw_direction ~= 0 and cmd.roll *-1 or cmd.roll
                end
            end

            ui.set(eternal.ref.rage.automatic_fire, (ui.get(eternal.menu.misc.auto_fire_master) and ui.get(eternal.menu.misc.auto_fire_key)) and true or false)
            ui.set(eternal.ref.rage.enabled[2], (ui.get(eternal.menu.misc.auto_fire_master) and ui.get(eternal.menu.misc.auto_fire_key)) and 'Always on' or 'On hotkey')

            if ui.get(eternal.menu.misc.auto_wall_master) and ui.get(eternal.menu.misc.auto_wall_key) then
                eternal.cache.auto_wall = true
                eternal.cache.l_auto_wall = false
                eternal.cache.awall_data = 'Force'

                ui.set(eternal.ref.rage.automatic_penetration, true)
            elseif ui.get(eternal.menu.misc.visible_hitbox) and eternal.cache.threat ~= nil then
                eternal.cache.auto_wall = false
                eternal.cache.l_auto_wall = eternal.func.penetration_scan(eternal.cache.local_player, eternal.cache.threat, 18)
                
                ui.set(eternal.ref.rage.automatic_penetration, eternal.cache.l_auto_wall)
            else
                eternal.cache.auto_wall = false
                eternal.cache.l_auto_wall = false
                eternal.cache.awall_data = 'None'

                ui.set(eternal.ref.rage.automatic_penetration, false)
            end

            --> Aimbot disablers
            for i = 1, #eternal.cache.enemies do
                eternal.func.aimbot_disablers(eternal.cache.enemies[i])
            end

            --> Dynamic fov
            if ui.get(eternal.menu.misc.dynamic_fov) then
                local max_fov = ui.get(eternal.menu.misc.maximum_fov)
                local min_fov = ui.get(eternal.menu.misc.minimum_fov)
                local min_dist = ui.get(eternal.menu.misc.fov_scale) * 4000
        
                if min_fov > max_fov then
                    ui.set(eternal.menu.misc.maximum_fov, min_fov)
                end
        
                if eternal.cache.threat_dist < min_dist then
                    min_dist = eternal.cache.threat_dist
                    ui.set(eternal.ref.rage.fov, eternal.func.clamp(math.min(max_fov, math.max(min_fov, ui.get(eternal.menu.misc.fov_scale)*40 / min_dist)), 1, 180))
                end
            end

            --> Closest hitbox to crosshair
            if ui.get(eternal.menu.misc.hitbox_selection) ~= 'Default' then
                local nearest_hitbox = eternal.func.get_closest_hitbox()

                if nearest_hitbox ~= nil then
                    ui.set(eternal.ref.rage.target_hitbox, nearest_hitbox)
                end
            end
        end),

        processor = function()
            if not eternal.cache.master_switch or not entity.is_alive(eternal.cache.local_player) or not eternal.cache.threat then
                eternal.cache.threat_dist = 0
                return 
            end
        
            local local_pos = eternal.includes.vector(entity.get_origin(eternal.cache.local_player))
            local target_pos = eternal.includes.vector(entity.get_origin(eternal.cache.threat))

            eternal.cache.threat_dist = math.sqrt(math.pow(local_pos.x - target_pos.x, 2) + math.pow(local_pos.y - target_pos.y, 2) + math.pow(local_pos.z - target_pos.z, 2))
        end,

        resolver = function(ent)
            if obex_data.build == 'Stable' or #eternal.cache.roll_players == 0 then
                return
            end

            if type(ent) == 'number' then
                if not eternal.func.contains(eternal.cache.roll_players, ent) then
                    return
                end

                local r, g, b = ui.get(eternal.menu.visual.main_indicator_color)

                if entity.is_dormant(ent) then 
                    r, g, b = 220, 220, 220
                end

                if eternal.cache.roll_data[ent] then
                    if not eternal.cache.roll_data[ent]['can_roll'] then
                        return true, eternal.colorful_text:text({{200, 200, 200}, 'ROLL'})
                    end
                end
                
                if eternal.cache.master_switch and plist.get(ent, 'Correction active') then
                    return true, eternal.colorful_text:text({{r, g, b}, 'ROLL'})
                end
            else
                local roll_overlap = 50

                for i = 1, #eternal.cache.enemies do
                    eternal.func.fix_bots(eternal.cache.enemies[i])

                    if not eternal.func.contains(eternal.cache.roll_players, eternal.cache.enemies[i]) then
                        return
                    end

                    if not eternal.cache.roll_data[eternal.cache.enemies[i]] then
                        eternal.cache.roll_data[eternal.cache.enemies[i]] = { ['velocity'] = 0, ['can_roll'] = false, ['desync'] = 0, ['last_hit'] = 0, ['brute'] = false, ['misses'] = { ['left'] = { [roll_overlap] = false, [-roll_overlap] = false }, ['right'] = { [roll_overlap] = false, [-roll_overlap] = false } }, ['angle'] = 0 }
                    end

                    local t_velocity = eternal.includes.vector(entity.get_prop(eternal.cache.enemies[i], 'm_vecVelocity'))
    
                    eternal.cache.roll_data[eternal.cache.enemies[i]]['velocity'] = math.sqrt(t_velocity.x ^ 2 + t_velocity.y ^ 2)
                    eternal.cache.roll_data[eternal.cache.enemies[i]]['desync'] = eternal.func.get_angle(eternal.cache.enemies[i])

                    if eternal.cache.roll_data[eternal.cache.enemies[i]] and plist.get(eternal.cache.enemies[i], 'Correction active') then
                        local move_dir = eternal.func.move_dir_text(eternal.cache.enemies[i])

                        if eternal.cache.roll_data[eternal.cache.enemies[i]]['velocity'] >= 200 and move_dir ~= 'in-air' then
                            eternal.cache.roll_data[eternal.cache.enemies[i]]['can_roll'] = false
                        elseif move_dir == 'right' or move_dir == 'left' then
                            eternal.cache.roll_data[eternal.cache.enemies[i]]['can_roll'] = eternal.cache.roll_data[eternal.cache.enemies[i]]['velocity'] <= 155
                        elseif move_dir == 'in-air' then
                            eternal.cache.roll_data[eternal.cache.enemies[i]]['can_roll'] = true
                        end

                        if eternal.cache.master_switch and entity.is_alive(eternal.cache.local_player) and eternal.cache.roll_data[eternal.cache.enemies[i]]['can_roll'] then
                            local brute_side = eternal.cache.roll_data[eternal.cache.enemies[i]]['desync'] >= 0 and 'left' or 'right'
                            local roll_angle = 0

                            if not eternal.cache.roll_data[eternal.cache.enemies[i]]['brute'] then
                                roll_angle = eternal.cache.roll_data[eternal.cache.enemies[i]]['desync'] >= 0 and -roll_overlap or roll_overlap
                            else
                                if eternal.cache.roll_data[eternal.cache.enemies[i]]['last_hit'] ~= 0 then
                                    roll_angle = eternal.cache.roll_data[eternal.cache.enemies[i]]['last_hit']
                                else
                                    local roll_brute = eternal.cache.roll_data[eternal.cache.enemies[i]]['angle']
                                    roll_angle = eternal.cache.roll_data[eternal.cache.enemies[i]]['misses'][brute_side][eternal.cache.roll_data[eternal.cache.enemies[i]]['angle']] and -roll_brute or roll_brute
                                end
                            end

                            eternal.cache.roll_data[eternal.cache.enemies[i]]['angle'] = roll_angle
                            eternal.func.override_roll(eternal.cache.enemies[i], roll_angle)
                        end
                    end
                end
            end
        end,

        peek = function(ent)
            if (obex_data.build ~= 'Alpha' and obex_data.build ~= 'Nightly') or not ui.get(eternal.menu.misc.peek_switch) or not eternal.cache.peek_threat then
                return
            end

            local r, g, b = 220, 220, 220

            if ui.get(eternal.menu.misc.peek_default_hotkey) then 
                r, g, b = 175, 255, 65
            end

            if ent == eternal.cache.peek_threat then
                return true, eternal.colorful_text:text({{r, g, b}, 'QP'})
            end
        end,

        animations = LPH_JIT(function()
            if not eternal.cache.master_switch or not entity.is_alive(eternal.cache.local_player) then
                return
            end
        
            --> Static legs on slow walk
            if eternal.cache.player_state == 'Slow' and eternal.cache.contains.animation_select.static_legs_slow then
                entity.set_prop(eternal.cache.local_player, 'm_flPoseParameter', 0, 9)
            end
        
            --> Static legs in air
            if eternal.cache.in_air and eternal.cache.contains.animation_select.static_legs_air then
                entity.set_prop(eternal.cache.local_player, 'm_flPoseParameter', 1, 6)
            end

            --> Michael Jackson
            if eternal.cache.contains.animation_select.moonwalk then
                entity.set_prop(eternal.cache.local_player, 'm_flPoseParameter', 1, 7)

                if eternal.cache.in_air and not eternal.cache.on_ladder then
                    ffi.cast(eternal.memory.animation_layer_t, ffi.cast('uintptr_t', eternal.memory.get_client_entity(eternal.cache.local_player)) + 0x2990)[0][6].m_flWeight = 1
                    entity.set_prop(eternal.cache.local_player, 'm_flPoseParameter', 1, 6)
                end
            end
        end),

        clean_scope = function()
            local materials = { 'dev/blurfiltery_nohdr', 'dev/engine_post', 'overlays/scope_lens' }

            for i, v in pairs(materials) do
                local material = materialsystem.find_material(v)

                if material ~= nil then
                    material:set_material_var_flag(2, true)
                end
            end
        end,

        hit = function(e)
            if not eternal.cache.master_switch or not eternal.cache.contains.shots.hits then 
                return 
            end
        
            local r1, g1, b1, a1 = ui.get(eternal.menu.visual.main_indicator_color)
            local r2, g2, b2, a1 = ui.get(eternal.menu.visual.secondary_indicator_color)
            local health = entity.get_esp_data(e.target).health
    
            local ping = math.min(999, client.latency() * 1000)
            local ping_col = { 175, 235, 50, 255 }
            local backtrack = globals.tickcount() - e.tick

            local min_dmg = (ui.get(eternal.ref.rage.minimum_damage_override[1]) and ui.get(eternal.ref.rage.minimum_damage_override[2])) and ui.get(eternal.ref.rage.minimum_damage_override[3]) or ui.get(eternal.ref.rage.minimum_damage)
    
            local dmg_color = (min_dmg <= e.damage or health == 0) and { 150, 200, 60 } or { 255, 75, 75 }
            local baimable = (min_dmg <= health) and { 150, 200, 60 } or { 255, 75, 75 }
            local desync_angle = eternal.func.get_angle(e.target)

            if eternal.cache.roll_data[e.target] and eternal.cache.hitgroup_names[e.hitgroup + 1] == 'head' then
                eternal.cache.roll_data[e.target]['last_hit'] = eternal.cache.roll_data[e.target]['angle']
            end

            if eternal.cache.contains.shots.console then
                eternal.colorful_text:log(
                    { { 205, 205, 205 }, '[' },
                    { { r1, g1, b1 }, { r2, g2, b2 }, 'Eternal' },
                    { { 205, 205, 205 }, '] ' },
                    { { 205, 205, 205 }, 'hit ' },
                    { { r1, g1, b1 }, ('%s'):format(string.sub(entity.get_player_name(e.target), 1, 12)) },
                    { { 205, 205, 205 }, '\'' },
                    { { r1, g1, b1 }, 's ' },
                    { { 205, 205, 205 }, ('%s for '):format(eternal.cache.hitgroup_names[e.hitgroup + 1] or '?') },
                    { dmg_color, ('%s'):format(e.damage) },
                    { { 205, 205, 205 }, ' [bt: '},
                    { ping_col, ('%d'):format(backtrack) },
                    { { 205, 205, 205 }, ' | ang: ' },
                    { plist.get(e.target, 'Force body yaw') and { r2, g2, b2 } or { r1, g1, b1 }, ('%d'):format(math.floor(desync_angle)) },
                    { { 205, 205, 205 }, ' | z: '},
                    { plist.get(e.target, 'Force body yaw') and { r1, g1, b1 } or { r2, g2, b2 }, ('%d'):format(eternal.cache.roll_data[e.target] and eternal.cache.roll_data[e.target]['angle'] or 0) },
                    { { 205, 205, 205 }, ' | hp: '},
                    { baimable, ('%d'):format(health) },
                    { { 205, 205, 205 }, ']', true }
                )
            end

            if eternal.cache.contains.shots.on_screen then
                eternal.func.notify:add(
                    'hit',
                    eternal.colorful_text:text({ { 255, 255, 255 }, 'hit ' }),
                    eternal.colorful_text:text({ { r1, g1, b1 }, ('%s'):format(string.sub(entity.get_player_name(e.target), 1, 12)) }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, '\'' }),
                    eternal.colorful_text:text({ { r1, g1, b1 }, 's ' }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, ('%s for '):format(eternal.cache.hitgroup_names[e.hitgroup + 1] or '?') }),
                    eternal.colorful_text:text({ dmg_color, ('%s'):format(e.damage) }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, ' [bt: ' }),
                    eternal.colorful_text:text({ ping_col, ('%d'):format(backtrack) }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, ' | ang: ' }),
                    eternal.colorful_text:text({ plist.get(e.target, 'Force body yaw') and { r2, g2, b2 } or { r1, g1, b1 }, ('%d'):format(math.floor(desync_angle)) }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, ' | z: ' }),
                    eternal.colorful_text:text({ plist.get(e.target, 'Force body yaw') and { r1, g1, b1 } or { r2, g2, b2 }, ('%s'):format(eternal.cache.roll_data[e.target] and eternal.cache.roll_data[e.target]['angle'] or 0) }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, ' | hp: ' }),
                    eternal.colorful_text:text({ baimable, ('%s'):format(health) }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, ']' })
                )
            end
        end,

        miss = function(e)
            if not eternal.cache.master_switch or not eternal.cache.contains.shots.misses then 
                return 
            end

            local r1, g1, b1, a1 = ui.get(eternal.menu.visual.main_indicator_color)
            local r2, g2, b2, a1 = ui.get(eternal.menu.visual.secondary_indicator_color)
    
            local group = eternal.cache.hitgroup_names[e.hitgroup + 1] or '?'
            e.hit_chance = ui.get(eternal.ref.rage.hit_chance) == 0 and 'OFF' or math.floor(e.hit_chance)
        
            local ping = math.min(999, client.latency() * 1000)
            local ping_col = { 175, 235, 50, 255 }
            local backtrack = globals.tickcount() - e.tick
        
            local hc = ui.get(eternal.ref.rage.hit_chance) == 0 and 0 or math.floor(e.hit_chance + 0.5)
            local hc_col = (hc < ui.get(eternal.ref.rage.hit_chance)) and { 255, 75, 75 } or { 150, 200, 60 }
            local desync_angle = eternal.func.get_angle(e.target)
    
            if e.reason == 'death' then
                if entity.is_alive(eternal.cache.local_player) then
                    e.reason = 'player death'
                else
                    e.reason = 'local death'
                end
            end
        
            if e.reason == 'prediction error' then
                e.reason = 'prediction'
            end
        
            if e.reason == '?' then
                e.reason = 'correction'
                
                if eternal.cache.roll_data[e.target] then
                    if eternal.cache.roll_data[e.target]['angle'] then
                        if eternal.cache.roll_data[e.target]['desync'] >= 0 then
                            eternal.cache.roll_data[e.target]['misses']['left'][eternal.cache.roll_data[e.target]['angle']] = true
                        else
                            eternal.cache.roll_data[e.target]['misses']['right'][eternal.cache.roll_data[e.target]['angle']] = true
                        end

                        eternal.cache.roll_data[e.target]['brute'] = true
                        eternal.cache.roll_data[e.target]['last_hit'] = 0
                    end
                end
            end

            if eternal.cache.contains.shots.console then
                eternal.colorful_text:log(
                    { { 205, 205, 205 }, '[' },
                    { { r1, g1, b1 }, { r2, g2, b2 }, 'Eternal' },
                    { { 205, 205, 205 }, '] ' },
                    { { 205, 205, 205 }, 'missed ' },
                    { { r1, g1, b1 }, ('%s'):format(string.sub(entity.get_player_name(e.target), 1, 12)) },
                    { { 205, 205, 205 }, '\'' },
                    { { r1, g1, b1 }, 's ' },
                    { { 205, 205, 205 }, ('%s due to '):format(eternal.cache.hitgroup_names[e.hitgroup + 1] or '?') },
                    { { 255, 75, 75 }, ('%s'):format(e.reason) },
                    { { 205, 205, 205 }, ' [bt: '},
                    { ping_col, ('%d'):format(backtrack) },
                    { { 205, 205, 205 }, ' | ang: ' },
                    { plist.get(e.target, 'Force body yaw') and { r2, g2, b2 } or { r1, g1, b1 }, ('%d'):format(math.floor(desync_angle)) },
                    { { 205, 205, 205 }, ' | z: ' },
                    { plist.get(e.target, 'Force body yaw') and { r1, g1, b1 } or { r2, g2, b2 }, ('%s'):format(eternal.cache.roll_data[e.target] and eternal.cache.roll_data[e.target]['angle'] or 0) },
                    { { 205, 205, 205 }, ' | hc: '},
                    { hc_col, ('%d%%'):format(hc) },
                    { { 205, 205, 205 }, ']', true }
                )
            end
            
            if eternal.cache.contains.shots.on_screen then
                eternal.func.notify:add(
                    'miss',
                    eternal.colorful_text:text({ { 255, 255, 255 }, 'missed ' }),
                    eternal.colorful_text:text({ { r1, g1, b1 }, ('%s'):format(string.sub(entity.get_player_name(e.target), 1, 12)) }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, '\'' }),
                    eternal.colorful_text:text({ { r1, g1, b1 }, 's ' }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, ('%s due to '):format(eternal.cache.hitgroup_names[e.hitgroup + 1] or '?') }),
                    eternal.colorful_text:text({ { 255, 75, 75 }, ('%s'):format(e.reason)}),
                    eternal.colorful_text:text({ { 255, 255, 255 }, ' [bt: '}),
                    eternal.colorful_text:text({ ping_col, ('%d'):format(backtrack) }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, ' | ang: ' }),
                    eternal.colorful_text:text({ plist.get(e.target, 'Force body yaw') and { r2, g2, b2 } or { r1, g1, b1 }, ('%d'):format(math.floor(desync_angle)) }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, ' | z: ' }),
                    eternal.colorful_text:text({ plist.get(e.target, 'Force body yaw') and { r1, g1, b1 } or { r2, g2, b2 }, ('%s'):format(eternal.cache.roll_data[e.target] and eternal.cache.roll_data[e.target]['angle'] or 0) }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, ' | hc: '}),
                    eternal.colorful_text:text({ hc_col, ('%d%%'):format(hc) }),
                    eternal.colorful_text:text({ { 255, 255, 255 }, ']' })
                )
            end
        end,

        reset = function()
            if eternal.cache.socket then
                eternal.cache.socket:send(json.stringify({
                    ['steam_id'] = entity.get_steam64(eternal.cache.local_player),
                    ['platform'] = 'GS',
                }))
            else
                eternal.includes.websockets.connect('wss://obex.pink/socket/', eternal.socket)
            end

            --> Setup eternal users :o
            client.delay_call(1, function()
                if #eternal.cache.eternal_users > 0 then
                    local player_resource = entity.get_player_resource()

                    for ent = 1, globals.maxplayers() do
                        if entity.get_classname(ent) == 'CCSPlayer' then
                            for i = 1, #eternal.cache.eternal_users do
                                if eternal.cache.eternal_users[i].steam_id == entity.get_steam64(ent) then
                                    entity.set_prop(player_resource, 'm_nPersonaDataPublicLevel', eternal.cache.eternal_users[i].platform == 'GS' and '8863621' or '8863622', ent)
                                end
                            end
                        end
                    end
                end
            end)

            --> Save round start
            eternal.cache.should_optimize = true

            --> Reset data
            eternal.cache.slow.last_tick = 0
            eternal.cache.def_slow.last_tick = 0
            eternal.cache.last_movement = 0
            eternal.cache.roll_data = {}
        end,

        death = function(e)
            if client.userid_to_entindex(e.userid) == eternal.cache.local_player then
                eternal.cache.roll_data = {}
            end
        end,

        optimize = function()
            eternal.cache.should_optimize = true
        end,

        restore = function() 
            --> Reset playerlist
            ui.set(eternal.ref.playerlist.reset_all, true)

            --> Restore anti-aim tab visibility
            eternal.func.default_visibility(true)
            
            ui.set_visible(eternal.ref.aa.other.on_shot[1], true)
            ui.set_visible(eternal.ref.aa.other.on_shot[2], true)

            --> Reset console filter
            cvar.con_filter_enable:set_int(0)
            cvar.con_filter_text:set_string('')
            
            --> Reset medals
            cvar.cl_fullupdate:invoke_callback(1)
        end,

        preset = function(input)
            if (obex_data.username == 'Can' or obex_data.username == 'Bigdon') and input:lower() == 'preset' then
                local to_export = {}

                table.insert(to_export, {'aa', eternal.menu.anti_aim})

                local settings = eternal.func.export_tab(to_export)
                local config_data = base64.encode(eternal.func.xorstr(json.stringify(settings), '6e0897bbb30137e153c1bdc922f40709183e063aa0349ae59ee3a34b837724dd'))

                eternal.func.set_clipboard(config_data)
                log('Exported preset to clipboard.')
                return true
            end
        end
    }

    eternal.callbacks = {
        ['paint_ui'] = { eternal.handler.optimization, eternal.handler.menu },
        ['paint'] = { eternal.handler.indicators, eternal.handler.watermark, eternal.handler.debug_panel },
        ['setup_command'] = { eternal.handler.main },
        ['run_command'] = { eternal.handler.processor },
        ['net_update_start'] = { eternal.handler.resolver },
        ['pre_render'] = { eternal.handler.animations },
        ['level_init'] = { eternal.handler.clean_scope, eternal.handler.optimize, eternal.handler.reset },
        ['post_config_load'] = { eternal.handler.optimize },
        ['aim_hit'] = { eternal.handler.hit },
        ['aim_miss'] = { eternal.handler.miss },
        ['round_prestart'] = { eternal.handler.reset },
        ['player_death'] = { eternal.handler.death },
        ['shutdown'] = { eternal.handler.restore },
        ['console_input'] = { eternal.handler.preset },
        ['flag'] = { eternal.handler.resolver, eternal.handler.peek }
    }

    eternal.register_callback = function(event, arg)
        return arg[2] and client.register_esp_flag('', 255, 255, 255, arg[1]) or client.set_event_callback(event, arg[1])
    end

    --eternal.load = function(success, response)
    eternal.load = function()
        --check_for_http_debugger()
    --
        --if not success or response.status ~= 200 then 
        --    while true do end;LPH_CRASH();return
        --end
--
        --if not response.body then 
        --    while true do end;LPH_CRASH();return
        --end

        --local h_message = json.parse(response.body)
        --local client_decryption_key = sha256(client_secret + (_obase64.decode(h_message[1]) + (3^9)))
        --local decrypted_text = new_enc_key(client_decryption_key):cipher(_obase64.decode(h_message[2]))
        --local client_beat = sha256(sha256(client_secret + 73^4))
--
        --if not eternal.func.eq(client_beat, decrypted_text) then 
        --    while true do end;LPH_CRASH();return
        --end
--
        --client_secret = z + unix + (ffi_random(1, 10000) + obex_tbl.count) / (obex_tbl.count / 64) + (ui.mouse_position() - globals.absoluteframetime() - globals.frametime() - globals.curtime() - globals.realtime() + client.unix_time() / client.timestamp()) - find_window_rand_num + (2^52 + 2^51) - (2^52 + 2^51)
        --http_data.shared = param_enc(client_secret + 73^4)
--
        for index, value in next, eternal.callbacks do
            for i, v in next, value do
                --_x[1](new_enc_key(client_decryption_key):cipher(_obase64.decode(h_message[3])))(eternal.register_callback, index, { v, index == 'flag'})
                eternal.register_callback(index, {v, index == 'flag'})
            end
        end
        --eternal.func.file_sys() -- pics removed :(

        client.set_event_callback('bomb_beginplant', function()
            eternal.cache.bomb_time = globals.curtime() + 3
        end)

        ui.set_callback(eternal.menu.main.resolver, function(e)
            local enabled = ui.get(e)
            local current_player = ui.get(eternal.ref.playerlist.player)
            local is_currently_ignored, tbl_index = eternal.func.contains(eternal.cache.roll_players, current_player)

            eternal.func.contains(ui.get(eternal.menu.visual.custom_logs), 'Console')
        
            if enabled and not is_currently_ignored then
                table.insert(eternal.cache.roll_players, current_player)
            elseif not enabled and is_currently_ignored then
                table.remove(eternal.cache.roll_players, tbl_index)
            end
        end)
        
        ui.set_callback(eternal.ref.playerlist.player, function(e)
            ui.set(eternal.menu.main.resolver, eternal.func.contains(eternal.cache.roll_players, ui.get(e)))
        end)
        
        ui.set_callback(eternal.ref.playerlist.reset_all, function()
            eternal.cache.roll_players = {}

            ui.set(eternal.menu.main.resolver, false)
        end)

        ui.set_callback(eternal.menu.misc.console_filtering, function()
            local filter = ui.get(eternal.menu.misc.console_filtering) and { 1, 'IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN' } or { 0, '' }

            cvar.con_filter_enable:set_int(filter[1])
            cvar.con_filter_text:set_string(filter[2])
        end)

        if obex_data.build=='Stable'then eternal.cache.spaced_string='   'elseif obex_data.build=='Nightly'then eternal.cache.spaced_string='   'elseif obex_data.build=='Alpha'then eternal.cache.spaced_string='   'elseif obex_data.build=='Beta'then eternal.cache.spaced_string='    'else eternal.cache.spaced_string='    'end
        
        client.exec('clear')
        --eternal.func.blend_console_log({ _r, _g, _b }, { 200, 200, 200 }, 'eternal.codes\n')
        --eternal.func.blend_console_log({ 200, 200, 200 }, { _r, _g, _b }, '  +======+\n')
        --eternal.func.blend_console_log({ _r, _g, _b }, { 200, 200, 200 }, '  | (..) |\n')
        --eternal.func.blend_console_log({ 200, 200, 200 }, { _r, _g, _b }, '  |  )(  |\n')
        --eternal.func.blend_console_log({ _r, _g, _b }, { 200, 200, 200 }, '  | (..) |\n')
        --eternal.func.blend_console_log({ 200, 200, 200 }, { _r, _g, _b }, '  +======+\n')
        eternal.func.blend_console_log({ 200, 200, 200 }, { 200, 200, 200 }, 'eternal.codes\n')
        eternal.func.blend_console_log({ 200, 200, 200 }, { 200, 200, 200 }, '  +======+\n')
        eternal.func.blend_console_log({ 200, 200, 200 }, { 200, 200, 200 }, '  | (..) |\n')
        eternal.func.blend_console_log({ 200, 200, 200 }, { 200, 200, 200 }, '  |  )(  |\n')
        eternal.func.blend_console_log({ 200, 200, 200 }, { 200, 200, 200 }, '  | (..) |\n')
        eternal.func.blend_console_log({ 200, 200, 200 }, { 200, 200, 200 }, '  +======+\n')
        eternal.func.blend_console_log({ 200, 200, 200 }, { 200, 200, 200 }, eternal.cache.spaced_string..obex_data.build:lower()..'\n\n')
        print(string.format('Successfully loaded Eternal, welcome back %s.', obex_data.username))

        --> Fetch latest preset
        --http.get('https://obex.pink/eternal/gamesense/semi/'..obex_data.build, { user_agent_info = 'Obex' }, function(success, response)
        --    if not success or response.status ~= 200 then
        --        log('Failed to fetch preset from server.')
        --        return
        --    end
--
        --    local decrypted_data = eternal.func.xorstr(base64.decode(response.body), '6e0897bbb30137e153c1bdc922f40709183e063aa0349ae59ee3a34b837724dd')
        --    local success, parsed = pcall(json.parse, decrypted_data)
--
        --    if success then
        --        cloud.settings = parsed
        --        log('Successfully fetched latest preset from server.')
        --    else
        --        log('Failed to parse latest preset.')
        --    end
        --end)

        --> Connect to socket
        --eternal.includes.websockets.connect('wss://obex.pink/socket/', eternal.socket)
    end

    --http_data.type = param_enc(5);http_data.shared = param_enc(client_secret + 73^4)
    --_obex.http.post('https://obex.pink/api/auth.php', { params = http_data, absolute_timeout = 60, network_timeout = 120,  user_agent_info = 'Obex' }, eternal.load)
    eternal.load()
end)({})