
local user do
    user = {} do
        user.name = 'admin' 
        user.version = "universe x "..user.name
    end
end

do
    client.exec("clear")
    local dependencies = {
        ['pui'] = {
            name = 'gamesense/pui',
            link = 'https://gamesense.pub/forums/viewtopic.php?id=41761'
        },
        ['weapons'] = {
            name = 'gamesense/csgo_weapons',
            link = 'https://gamesense.pub/forums/viewtopic.php?id=18807'
        },
        ['surface'] = {
            name = 'gamesense/surface',
            type = 'workshop',
            link = 'https://gamesense.pub/forums/viewtopic.php?id=18793'
        },
        ['base64'] = {
            name = 'gamesense/base64',
            type = 'workshop',
            link = 'https://gamesense.pub/forums/viewtopic.php?id=21619'
        },
        ['clipboard'] = {
            name = 'gamesense/clipboard',
            type = 'workshop',
            link = 'https://gamesense.pub/forums/viewtopic.php?id=28678'
        },
    }

    local located = true

    for gname, method in pairs(dependencies) do
        local success = pcall(require, method.name)

        if not success then
            client.error_log(string.format('[-] Unable to locate %s library. You need to subscribe to it here %s', gname, method.link))
            located = false
        end
    end

    if not located then
        return error('[~] Script was unable to start. You can investigate error above.')
    end
end

local ffi = require 'ffi'
local vector = require("vector")
local pui = require("gamesense/pui")
local weapons = require ("gamesense/csgo_weapons")
local surface = require ('gamesense/surface')
local base64 = require ('gamesense/base64')
local clipboard = require ('gamesense/clipboard')

local reference = {} do
    reference.ragebot = {} do
        reference.ragebot.enabled = pui.reference("RAGE", "Aimbot", "Enabled")
        reference.ragebot.double_tap = pui.reference("RAGE", "Aimbot", "Double tap") 
        reference.ragebot.dt_limit = {pui.reference("rage", "aimbot", "Double tap fake lag limit")}
        reference.ragebot.duck = pui.reference("RAGE", "Other", "Duck peek assist")
        reference.ragebot.quick_peek =  pui.reference("Rage", "Other", "Quick peek assist") 
        reference.ragebot.ovr = { pui.reference('rage', 'aimbot', 'minimum damage override') }
        reference.ragebot.force_bodyaim = pui.reference('RAGE', 'Aimbot', 'Force body aim')
        reference.ragebot.force_safepoint = pui.reference('RAGE', 'Aimbot', 'Force safe point')
    end

    reference.antiaim = {} do
        
        reference.antiaim.enable = pui.reference("AA", "Anti-Aimbot angles", "Enabled")
        reference.antiaim.pitch = { pui.reference("AA", "Anti-Aimbot angles", "Pitch") }
        reference.antiaim.yaw = { pui.reference("AA", "Anti-Aimbot angles", "Yaw") }
        reference.antiaim.base = pui.reference("AA", "Anti-Aimbot angles", "Yaw base")
        reference.antiaim.jitter = { pui.reference("AA", "Anti-Aimbot angles", "Yaw jitter") }
        reference.antiaim.body = { pui.reference("AA", "Anti-Aimbot angles", "Body yaw") }
        reference.antiaim.edge = pui.reference("AA", "Anti-Aimbot angles", "Edge yaw")
        reference.antiaim.fs_body = pui.reference("AA", "Anti-Aimbot angles", "Freestanding body yaw")
        reference.antiaim.freestand = pui.reference("AA", "Anti-Aimbot angles", "Freestanding")
        reference.antiaim.roll = pui.reference("AA", "Anti-Aimbot angles", "Roll")
        reference.antiaim.slowmotion = pui.reference("AA", "Other", "Slow motion")
        reference.antiaim.onshot = pui.reference("AA", "Other", "On shot anti-aim")
        reference.antiaim.leg_movement = pui.reference('AA', 'Other', 'Leg movement')
    end 

    reference.fakelag = {} do
        reference.fakelag.enable = {pui.reference('AA', 'Fake lag', 'Enabled')}
        reference.fakelag.amount = pui.reference('AA', 'Fake lag', 'Amount')
        reference.fakelag.variance = pui.reference('AA', 'Fake lag', 'Variance')
        reference.fakelag.limit = pui.reference('AA', 'Fake lag', 'Limit')
    end

    reference.misc = {} do
        reference.misc.clantag = pui.reference('Misc', 'Miscellaneous', 'Clan tag spammer')
        reference.misc.draw_output = pui.reference('MISC', 'Miscellaneous', 'Draw console output')
    end

    

end

local memory = {}  do
    memory.get_client_entity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void***, int)')

    memory.animstate = {} do

        local animstate_t = ffi.typeof 'struct { char pad0[0x18]; float anim_update_timer; char pad1[0xC]; float started_moving_time; float last_move_time; char pad2[0x10]; float last_lby_time; char pad3[0x8]; float run_amount; char pad4[0x10]; void* entity; void* active_weapon; void* last_active_weapon; float last_client_side_animation_update_time; int	 last_client_side_animation_update_framecount; float eye_timer; float eye_angles_y; float eye_angles_x; float goal_feet_yaw; float current_feet_yaw; float torso_yaw; float last_move_yaw; float lean_amount; char pad5[0x4]; float feet_cycle; float feet_yaw_rate; char pad6[0x4]; float duck_amount; float landing_duck_amount; char pad7[0x4]; float current_origin[3]; float last_origin[3]; float velocity_x; float velocity_y; char pad8[0x4]; float unknown_float1; char pad9[0x8]; float unknown_float2; float unknown_float3; float unknown; float m_velocity; float jump_fall_velocity; float clamped_velocity; float feet_speed_forwards_or_sideways; float feet_speed_unknown_forwards_or_sideways; float last_time_started_moving; float last_time_stopped_moving; bool on_ground; bool hit_in_ground_animation; char pad10[0x4]; float time_since_in_air; float last_origin_z; float head_from_ground_distance_standing; float stop_to_full_running_fraction; char pad11[0x4]; float magic_fraction; char pad12[0x3C]; float world_force; char pad13[0x1CA]; float min_yaw; float max_yaw; } **'
        
        memory.animstate.offset = 0x9960

        memory.animstate.get = function (self, ent)
            if not ent then
                return
            end
            local client_entity = memory.get_client_entity(ent)

            if not client_entity then
                return
            end
            

            return ffi.cast(animstate_t, ffi.cast('uintptr_t', client_entity) + self.offset)[0]
        end

        
    end

    memory.animlayers = {} do
        if not pcall(ffi.typeof, 'bt_animlayer_t') then
            ffi.cdef[[
                typedef struct {
                    float   anim_time;
                    float   fade_out_time;
                    int     nil;
                    int     activty;
                    int     priority;
                    int     order;
                    int     sequence;
                    float   prev_cycle;
                    float   weight;
                    float   weight_delta_rate;
                    float   playback_rate;
                    float   cycle;
                    int     owner;
                    int     bits;
                } bt_animlayer_t, *pbt_animlayer_t
            ]]
        end

        memory.animlayers.offset = ffi.cast('int*', ffi.cast('uintptr_t', client.find_signature('client.dll', '\x8B\x89\xCC\xCC\xCC\xCC\x8D\x0C\xD1')) + 2)[0]


        memory.animlayers.get = function (self, ent)
            local client_entity = memory.get_client_entity(ent)

            if not client_entity then
                return
            end

            return ffi.cast('pbt_animlayer_t*', ffi.cast('uintptr_t', client_entity) + self.offset)[0]
        end
    end

    memory.activity = {} do
        if not pcall(ffi.typeof, 'bt_get_sequence') then
            ffi.cdef[[
                typedef int(__fastcall* bt_get_sequence)(void* entity, void* studio_hdr, int sequence);
            ]]
        end

        memory.activity.offset = 0x2950
        memory.activity.location = ffi.cast('bt_get_sequence', client.find_signature('client.dll', '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83'))

    
        memory.activity.get = function (self, sequence, ent)
            local client_entity = memory.get_client_entity(ent)

            if not client_entity then
                return
            end

            local studio_hdr = ffi.cast('void**', ffi.cast('uintptr_t', client_entity) + self.offset)[0]

            if not studio_hdr then
                return;
            end

            return self.location(client_entity, studio_hdr, sequence);
        end
    end

    memory.user_input = {} do
        if not pcall(ffi.typeof, 'bt_cusercmd_t') then
            ffi.cdef[[
                typedef struct {
                    struct bt_cusercmd_t (*cusercmd)();
                    int     command_number;
                    int     tick_count;
                    float   view[3];
                    float   aim[3];
                    float   move[3];
                    int     buttons;
                } bt_cusercmd_t;
            ]]
        end

        if not pcall(ffi.typeof, 'bt_get_usercmd') then
            ffi.cdef[[
                typedef bt_cusercmd_t*(__thiscall* bt_get_usercmd)(void* input, int, int command_number);
            ]]
        end

        memory.user_input.vtbl = ffi.cast('void***', ffi.cast('void**', ffi.cast('uintptr_t', client.find_signature('client.dll', '\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85') or error('fipp')) + 1)[0])
        memory.user_input.location = ffi.cast('bt_get_usercmd', memory.user_input.vtbl[0][8])

        memory.user_input.get_command = function (self, command_number)
            return self.location(self.vtbl, 0, command_number)
        end
    end

    function memory.get_simtime(ent)
        local pointer = memory.get_client_entity(ent)

        if pointer then
            return entity.get_prop(ent, "m_flSimulationTime"), ffi.cast("float*", ffi.cast("uintptr_t", pointer) + 620)[0]
        else
            return 0
        end
    end


end 

local c_math , c_tweening  do

    c_math = {} do
        function c_math.normalize_yaw(a)
            while a > 180 do
                a = a - 360
            end

            while a < -180 do
                a = a + 360
            end

            return a
        end

        function c_math.threat_yaw()
            local aa_threat = client.current_threat()

            if not aa_threat then
                return
            end

            local my_origin = vector(entity.get_origin(entity.get_local_player()))
            local _, threat_yaw = my_origin:to(vector(entity.get_origin(aa_threat))):angles()

            return threat_yaw
        end
            
        function c_math.clamp(x, a, b)
            if a > x then
                return
                    a
            elseif
                b < x then
                return
                    b
            else
                return x
            end
        end

        function c_math.extend_vector(pos, length, angle)
            local rad = angle * math.pi / 180
            if rad == nil then return end
            if angle == nil or pos == nil or length == nil then return end
            return { pos[1] + (math.cos(rad) * length), pos[2] + (math.sin(rad) * length), pos[3] };
        end

        function c_math.contains(tbl, value)
            local tbl_len = #tbl

            for i=1, tbl_len do
                if tbl[i] == value then
                    return true
                end
            end

            return false
        end

        function c_math.lerp(a, b, w)  
            return a + (b - a) * w  
        end

        function c_math.color_lerp(r1, g1, b1, a1, r2, g2, b2, a2, t)
            local r = c_math.lerp(r1, r2, t)
            local g = c_math.lerp(g1, g2, t)
            local b = c_math.lerp(b1, b2, t)
            local a = c_math.lerp(a1, a2, t)

            return r, g, b, a
        end

        function c_math.closest_ray_point(p, s, e)
            local t, d = p - s, e - s
            local l = d:length()
            d = d / l
            local r = d:dot(t)
            if r < 0 then return s elseif r > l then return e end
            return s + d * r
        end

        function  c_math.split(str, sep)
            local result = {}
            local start = str:find(sep)

            if not start then
                return {str}
            end

            local pos = 1

            while start do
                result[#result+1] = str:sub(pos, start)

                pos = start+sep:len()

                start = str:find(sep, pos)

                if not start then
                    result[#result+1] = str:sub(pos)
                end
            end

            return result
        end



    end 

    c_tweening = {} do
        local native_GetTimescale = vtable_bind('engine.dll', 'VEngineClient014', 91, 'float(__thiscall*)(void*)')

        local function solve(easings_fn, prev, new, clock, duration)
            local prev = easings_fn(clock, prev, new - prev, duration)

            if type(prev) == 'number' then
                if math.abs(new - prev) <= .01 then
                    return new
                end

                local fmod = prev % 1

                if fmod < .001 then
                    return math.floor(prev)
                end

                if fmod > .999 then
                    return math.ceil(prev)
                end
            end

            return prev
        end

        local mt = {}; do
            local function update(self, duration, target, easings_fn)
                if duration == nil and target == nil and easings_fn == nil then
                    return self.value
                end

                local value_type = type(self.value)
                local target_type = type(target)

                if target_type == 'boolean' then
                    target = target and 1 or 0
                    target_type = 'number'
                end

                assert(value_type == target_type, string.format('type mismatch, expected %s (received %s)', value_type, target_type))

                if target ~= self.to then
                    self.clock = 0

                    self.from = self.value
                    self.to = target
                end

                local clock = globals.frametime() / native_GetTimescale()
                local duration = duration or .15

                if self.clock == duration then
                    return target
                end

                if clock <= 0 and clock >= duration then
                    self.clock = 0

                    self.from = target
                    self.to = target

                    self.value = target

                    return target
                end

                self.clock = math.min(self.clock + clock, duration)
                self.value = solve(easings_fn or self.easings, self.from, self.to, self.clock, duration)

                return self.value;
            end

            mt.__metatable = false
            mt.__call = update
            mt.__index = mt
        end

        function c_tweening:new(default, easings_fn)
            if type(default) == 'boolean' then
                default = default and 1 or 0
            end

            local this = {}

            this.clock = 0
            this.value = default or 0

            this.easings = easings_fn or function(t, b, c, d)
                return c * t / d + b
            end

            return setmetatable(this, mt)
        end
    end

end 

local color do
    local create_color, create_color_object, Color do
        Color = {} do
            function Color:clone()
                return create_color_object(
                    self.r, self.g, self.b, self.a
                )
            end

            function Color:to_hex()
                return ('%02X%02X%02X%02X'):format(self.r, self.g, self.b, self.a)
            end

            function Color:as_hex(hex_value)
                local r, g, b, a = hex_value:match('(%x%x)(%x%x)(%x%x)(%x%x)')

                return create_color_object(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16), tonumber(a, 16))
            end

            function Color:lerp(color_target, weight)
                return create_color_object(
                    c_math.lerp(self.r, color_target.r, weight),
                    c_math.lerp(self.g, color_target.g, weight),
                    c_math.lerp(self.b, color_target.b, weight),
                    c_math.lerp(self.a, color_target.a, weight)
                )
            end

            function Color:grayscale(ratio)
                return create_color_object(
                    self.r * ratio,
                    self.g * ratio,
                    self.b * ratio,
                    self.a
                )
            end

            function Color:alpha_modulate(alpha, modulate)
                return create_color_object(
                    self.r,
                    self.g,
                    self.b,
                    modulate and self.a*alpha or alpha
                )
            end

            function Color:unpack()
                return self.r, self.g, self.b, self.a
            end
        end

        function create_color_object(self, ...)
            local args = {...}

            if type(self) == 'number' then
                table.insert(args, 1, self)
            end

            if type(args[1]) == 'table' then
                if args[1][1] then
                    args = args[1]
                else
                    args = {args[1].r, args[1].g, args[1].b, args[1].a}
                end
            end

            if type(args[1]) == 'string' then
                return setmetatable({
                    r = 255, g = 255, b = 255, a = 255
                }, {
                    __index = Color
                }):as_hex(args[1])
            end

            return setmetatable({
                r = args[1] or 255,
                g = args[2] or 255,
                b = args[3] or 255,
                a = args[4] or 255
            }, {
                __index = Color
            })
        end

        local stock_colors = {} do
            stock_colors.raw_green = create_color_object(0, 255, 0);
            stock_colors.raw_red = create_color_object(255, 0, 0);

            stock_colors.red = create_color_object(255, 0, 50);
            stock_colors.white = create_color_object();
            stock_colors.gray = create_color_object(200, 200, 200);
            stock_colors.green = create_color_object(143, 194, 21);
            stock_colors.sea = create_color_object(59, 208, 182);
            stock_colors.blue = create_color_object(95, 156, 204);
            stock_colors.pink = create_color_object(209, 101, 145);
            stock_colors.yellow = create_color_object(233, 213, 2);
            stock_colors.purplish = create_color_object(193, 144, 252);

            stock_colors.onshot = create_color_object(100, 148, 237, 255);
            stock_colors.freestanding = create_color_object(132, 195, 16, 255);
            stock_colors.edge = create_color_object(209, 159, 230, 255);
            stock_colors.fixik = create_color_object('00FFCBFF');

            stock_colors.string_to_color_array = (function (str)
                local arr =  {}
                local match, mend = str:find('\a')

                if not match then
                    arr[#arr+1] = str
                else
                    while match do
                        local prmatch = match
                        local prend = mend

                        match, mend = str:find('\a', match+1)

                        if match == nil then
                            arr[#arr+1] = str:sub(prend, #str)

                            break
                        else
                            arr[#arr+1] = str:sub(prmatch, match-1)
                        end
                    end
                end

                local cnt = 0
                local out = {}

                for i=1, #arr do
                    for hex_col, s in arr[i]:gmatch('\a(%x%x%x%x%x%x%x%x)(.+)') do
                        out[#out+1] = {
                            color = create_color(hex_col),
                            text = s
                        };

                        cnt = cnt + 1
                    end
                end

                if cnt == 0 then
                    out[#out+1] = {
                        color = create_color('FFFFFFFF'),
                        text = str
                    }
                end

                return out
            end)

            stock_colors.animated_text = (function (text, speed, color_start, color_end, alpha)
                local first = color_start and create_color(color_start.r, color_start.g, color_start.b, alpha) or create_color(255, 200, 255, alpha)
                local second = color_end and create_color(color_end.r, color_end.g, color_end.b, alpha) or create_color(100, 100, 100, alpha)

                local res = ""

                for idx = 1, #text + 1 do
                    local letter = text:sub(idx, idx)

                    local alpha1 = (idx - 1) / (#text - 1)
                    local m_speed = globals.realtime() * ((50 / 25) or 1.0)
                    local m_factor = m_speed % math.pi

                    local c_speed = speed or 1
                    local m_sin = math.sin(m_factor * c_speed + (alpha1 or 0))
                    local m_abs = math.abs(m_sin)
                    local clr = first:lerp(second, m_abs)

                    res = ("%s\a%s%s"):format(res, clr:to_hex(), letter)
                end

                return res
            end)
        end

        create_color = setmetatable(stock_colors, {
            __call = create_color_object
        })
    end

    color = create_color
end

local player = {
    shifting = false, 
    defensive = false, 
    onground = false, 
    is_fs_peek = false,
    duckamount = 0,
    speed =0,
    packets = 0,
    fs_side = 'none',
    state = "stand",
    body_yaw = 0.0,
    get_players = {},
    lc_left = 0.0,
    crouching = false,
}  do

    local  function get_double_tap()
        local me = entity.get_local_player()
        local m_nTickBase = entity.get_prop(me, 'm_nTickBase')
        local client_latency = client.latency()
        local shift = math.floor(m_nTickBase - globals.tickcount() - 3 - toticks(client_latency) * .5 + .5 * (client_latency * 10))
        local wanted = -14 + (reference.ragebot.dt_limit[1]:get() - 1) + 3 
        return shift <= wanted
    end

    local tickbase_max = 0
    local last_commandnumber
    



    local function defensive_predict(cmd)
        local me = entity.get_local_player()

        if not me or last_commandnumber ~= cmd.command_number then
            return false
        end
        local tickbase = entity.get_prop(me, "m_nTickBase") or 0

        if math.abs(tickbase - tickbase_max) > 64 then
            tickbase_max = 0
        end
        
        if tickbase > tickbase_max then
            tickbase_max = tickbase
        elseif tickbase < tickbase_max then
            -- block empty
        end

 
        player.lc_left = math.min(14, math.max(0, tickbase_max - tickbase - 1))
        return player.lc_left ~= 1 and player.lc_left > 2  and globals.chokedcommands() < 13
        
    end
    client.set_event_callback("run_command", function(cmd)
        last_commandnumber = cmd.command_number
        player.shifting = get_double_tap()
    end)
    

    local function is_onground()
        local animstate = memory.animstate:get(entity.get_local_player())

        if not animstate then
            return true
        end

        local ptr_addr = ffi.cast('uintptr_t', ffi.cast('void*', animstate))
        local landed_on_ground_this_frame = ffi.cast('bool*', ptr_addr + 0x120)[0] --- @offset

        return animstate.on_ground and not landed_on_ground_this_frame
    end

    local function is_fs_peek()
        local me = entity.get_local_player()
        local enemy = client.current_threat()
        if not me or entity.is_dormant(enemy) then 
            return false
        end
        local pitch, yaw = client.camera_angles(me)
        --my activation arc
        local left2 = c_math.extend_vector({entity.get_origin(me)},30,yaw + 60)
        local right2 = c_math.extend_vector({entity.get_origin(me)},30,yaw - 60)
       
        local pitch, yaw_e = entity.get_prop(enemy, "m_angEyeAngles")
        local enemy_right2 = c_math.extend_vector({entity.get_origin(enemy)},20,yaw_e - 35)
        local enemy_left2 = c_math.extend_vector({entity.get_origin(enemy)},20,yaw_e + 35)

        local _, dmg_left2 =  client.trace_bullet(enemy, enemy_left2[1], enemy_left2[2], enemy_left2[3] + 30, left2[1], left2[2], left2[3], true)
        local _, dmg_right2 = client.trace_bullet(enemy, enemy_right2[1], enemy_right2[2], enemy_right2[3] + 30, right2[1], right2[2], right2[3], true)
        if  dmg_right2 > 0 and dmg_left2 > 0 then
            return  false
        elseif dmg_left2 > 0 then
            return  true
        elseif dmg_right2 > 0 then
            return  true
        end

        return false
    end 

    local function get_state()
        if not player.onground then
            if player.duckamount > 0.5 then
                return 'air crouch'
            else
                return 'air'
            end
        end

        if player.duckamount > 0.5 or reference.ragebot.duck:get() then
            if player.speed > 4 then
                return 'crouch move'
            else
                return 'crouch'
            end
        end

        local slowmotion_state = reference.antiaim.slowmotion.hotkey:get()

        if slowmotion_state then
            return 'slow-motion'
        end

        if player.speed > 4 then
            return 'move'
        end

        return 'stand'
    end
    local function get_side(target)
        local local_pos, enemy_pos = vector(entity.hitbox_position(entity.get_local_player(), 0)), vector(entity.hitbox_position(target, 0))

        local _, yaw = (local_pos-enemy_pos):angles()
        local l_dir, r_dir = vector():init_from_angles(0, yaw+90), vector():init_from_angles(0, yaw-90)
        local l_pos, r_pos = local_pos + l_dir * 110, local_pos + r_dir * 110

        local fraction = client.trace_line(target, enemy_pos.x, enemy_pos.y, enemy_pos.z, l_pos.x, l_pos.y, l_pos.z)
        local fraction_s = client.trace_line(target, enemy_pos.x, enemy_pos.y, enemy_pos.z, r_pos.x, r_pos.y, r_pos.z)

        if fraction > fraction_s then
            return 'left'
        elseif fraction_s > fraction then
            return 'right'
        elseif fraction == fraction_s then
            return 'none'
        end

        return 'none'
    end    

    local function get_fs_side()
        local me = entity.get_local_player()
        local target, cross_target,best_yaw = nil, nil, 362
        local enemy_list = entity.get_players(true)
        local stomach_origin = vector(entity.hitbox_position(me, 2))
        local camera_angles = vector(client.camera_angles())

        for idx=1, #enemy_list do
            local ent = enemy_list[idx]
            local ent_wpn = entity.get_player_weapon(ent)

            if ent_wpn then
                local enemy_head = vector(entity.hitbox_position(ent, 2))
                local _, yaw = (stomach_origin-enemy_head):angles()
                local base_diff = math.abs(camera_angles.y-yaw)

                if base_diff < best_yaw then
                    cross_target = ent
                    best_yaw = base_diff
                end
            end
        end

        if not target then
            target = cross_target
        end

        return target and get_side(target) or 'none'
    end


    function player.predict_command(cmd)
        local me = entity.get_local_player()
       
        player.speed = vector(entity.get_prop(me, 'm_vecVelocity')):length()
        
        player.state = get_state()
        player.fs_side = get_fs_side()
        player.defensive = defensive_predict(cmd)
        player.onground = is_onground()
        player.is_fs_peek = is_fs_peek()
        player.duckamount = entity.get_prop(me, 'm_flDuckAmount')
       
        
    end

    function player.setup_command(cmd)
        player.get_players = entity.get_players()
        
        player.crouching = cmd.in_duck == 1
        player.walking = player.speed > 5 and (cmd.in_speed == 1)
    end

    

end 

local ui_handler = {} do
    local group  = pui.group("AA", "anti-aimbot angles")
    local fakelag  = pui.group("AA", "Fake lag")
    local e_statement = {"global","stand","slow-motion","move","crouch","crouch move","air","air crouch","fake lag","on shot","on use","manual","safe head","freestand"}

    local configs = {} do
        configs.import = function(settings)
            assert(clipboard.get() ~= nil, 'Parameter value cannot be empty!')
            --local settings = clipboard.get():match('[%w%+%/]+%=*')
            xpcall(function()
                local parse_data = json.parse(base64.decode(settings))
                ui_handler.configs_da:load(parse_data)
            end, function()
                
            end)
            client.exec("play ui\\beepclear;")
        end
        configs.export = function()
            local settings = ui_handler.configs_da:save()
            local stringify_data = base64.encode(json.stringify(settings))
            clipboard.set(stringify_data)
            client.exec("play ui\\beepclear;")
        end

        local default = "eyJidWlsZGVyIjp7ImZha2UgbGFnIjp7IjEiOjAsIjIiOjAsIjMiOjAsIjQiOjAsIjUiOjAsIjYiOjAsIjciOjAsImVuYWJsZSI6ZmFsc2UsImV4cGFuZCI6Im9mZiIsImVwZF9yaWdodCI6MCwiZXBkX2xlZnQiOjAsInNwZWVkIjoxLCJkZWZfbGVmdCI6MCwiZGVsYXkiOjEsImJhc2UiOiJsb2NhbCB2aWV3IiwiYWRkIjowLCJieV9tb2RlIjoib2ZmIiwiZGVmX3JpZ2h0IjowLCJkZWZfYm9keSI6ImRlZmF1bHQiLCJyb2xsIjowLCJkZWZfc3BlZWQiOjEsImVwZF93YXkiOjAsImJyZWFrX2xjIjpmYWxzZSwiZGVmX3BpdGNoX251bSI6MCwiZGVmX3lhd19udW0iOjAsImJ5X251bSI6MCwiZGVmX3lhdyI6ImRlZmF1bHQiLCJkZWZfcGl0Y2giOiJkZWZhdWx0Iiwid2F5c19tYW51YWwiOmZhbHNlLCJqaXR0ZXJfYWRkIjowLCJkZWZlbnNpdmUiOmZhbHNlLCJ4X3dheSI6Mywiaml0dGVyIjoib2ZmIiwieWF3X3JhbmRvbWl6ZSI6MH0sImFpciBjcm91Y2giOnsiMSI6MCwiMiI6MCwiMyI6MCwiNCI6MCwiNSI6MCwiNiI6MCwiNyI6MCwiZW5hYmxlIjp0cnVlLCJleHBhbmQiOiJsZWZ0XC9yaWdodCIsImVwZF9yaWdodCI6NDcsImVwZF9sZWZ0IjotMTksInNwZWVkIjoxLCJkZWZfbGVmdCI6LTI0LCJkZWxheSI6MiwiYmFzZSI6ImF0IHRhcmdldHMiLCJhZGQiOjQsImJ5X21vZGUiOiJqaXR0ZXIiLCJkZWZfcmlnaHQiOjUyLCJkZWZfYm9keSI6ImF1dG8iLCJyb2xsIjowLCJkZWZfc3BlZWQiOjEsImVwZF93YXkiOjAsImJyZWFrX2xjIjp0cnVlLCJkZWZfcGl0Y2hfbnVtIjowLCJkZWZfeWF3X251bSI6MCwiYnlfbnVtIjotMTAyLCJkZWZfeWF3IjoiZGVsYXllZCIsImRlZl9waXRjaCI6ImRlZmF1bHQiLCJ3YXlzX21hbnVhbCI6ZmFsc2UsImppdHRlcl9hZGQiOjU0LCJkZWZlbnNpdmUiOnRydWUsInhfd2F5IjozLCJqaXR0ZXIiOiJvZmYiLCJ5YXdfcmFuZG9taXplIjo0fSwib24gc2hvdCI6eyIxIjowLCIyIjowLCIzIjowLCI0IjowLCI1IjowLCI2IjowLCI3IjowLCJlbmFibGUiOmZhbHNlLCJleHBhbmQiOiJvZmYiLCJlcGRfcmlnaHQiOjAsImVwZF9sZWZ0IjowLCJzcGVlZCI6MSwiZGVmX2xlZnQiOjAsImRlbGF5IjoxLCJiYXNlIjoibG9jYWwgdmlldyIsImFkZCI6MCwiYnlfbW9kZSI6Im9mZiIsImRlZl9yaWdodCI6MCwiZGVmX2JvZHkiOiJkZWZhdWx0Iiwicm9sbCI6MCwiZGVmX3NwZWVkIjoxLCJlcGRfd2F5IjowLCJicmVha19sYyI6ZmFsc2UsImRlZl9waXRjaF9udW0iOjAsImRlZl95YXdfbnVtIjowLCJieV9udW0iOjAsImRlZl95YXciOiJkZWZhdWx0IiwiZGVmX3BpdGNoIjoiZGVmYXVsdCIsIndheXNfbWFudWFsIjpmYWxzZSwiaml0dGVyX2FkZCI6MCwiZGVmZW5zaXZlIjpmYWxzZSwieF93YXkiOjMsImppdHRlciI6Im9mZiIsInlhd19yYW5kb21pemUiOjB9LCJmcmVlc3RhbmQiOnsiMSI6MCwiMiI6MCwiMyI6MCwiNCI6MCwiNSI6MCwiNiI6MCwiNyI6MCwiZW5hYmxlIjp0cnVlLCJleHBhbmQiOiJvZmYiLCJlcGRfcmlnaHQiOjAsImVwZF9sZWZ0IjowLCJzcGVlZCI6MSwiZGVmX2xlZnQiOjAsImRlbGF5IjoxLCJiYXNlIjoibG9jYWwgdmlldyIsImFkZCI6MCwiYnlfbW9kZSI6InN0YXRpYyIsImRlZl9yaWdodCI6MCwiZGVmX2JvZHkiOiJkZWZhdWx0Iiwicm9sbCI6MCwiZGVmX3NwZWVkIjoxLCJlcGRfd2F5IjowLCJicmVha19sYyI6ZmFsc2UsImRlZl9waXRjaF9udW0iOjAsImRlZl95YXdfbnVtIjoxMTgsImJ5X251bSI6MTgwLCJkZWZfeWF3IjoiZGVmYXVsdCIsImRlZl9waXRjaCI6ImRlZmF1bHQiLCJ3YXlzX21hbnVhbCI6ZmFsc2UsImppdHRlcl9hZGQiOjAsImRlZmVuc2l2ZSI6ZmFsc2UsInhfd2F5IjozLCJqaXR0ZXIiOiJvZmYiLCJ5YXdfcmFuZG9taXplIjowfSwib24gdXNlIjp7IjEiOjAsIjIiOjAsIjMiOjAsIjQiOjAsIjUiOjAsIjYiOjAsIjciOjAsImVuYWJsZSI6dHJ1ZSwiZXhwYW5kIjoibGVmdFwvcmlnaHQiLCJlcGRfcmlnaHQiOjAsImVwZF9sZWZ0IjowLCJzcGVlZCI6MSwiZGVmX2xlZnQiOjAsImRlbGF5IjoyLCJiYXNlIjoibG9jYWwgdmlldyIsImFkZCI6MCwiYnlfbW9kZSI6ImppdHRlciIsImRlZl9yaWdodCI6MCwiZGVmX2JvZHkiOiJkZWZhdWx0Iiwicm9sbCI6MCwiZGVmX3NwZWVkIjoxLCJlcGRfd2F5IjowLCJicmVha19sYyI6ZmFsc2UsImRlZl9waXRjaF9udW0iOjAsImRlZl95YXdfbnVtIjowLCJieV9udW0iOi03NSwiZGVmX3lhdyI6ImRlZmF1bHQiLCJkZWZfcGl0Y2giOiJkZWZhdWx0Iiwid2F5c19tYW51YWwiOmZhbHNlLCJqaXR0ZXJfYWRkIjowLCJkZWZlbnNpdmUiOmZhbHNlLCJ4X3dheSI6Mywiaml0dGVyIjoib2ZmIiwieWF3X3JhbmRvbWl6ZSI6MH0sInNhZmUgaGVhZCI6eyIxIjowLCIyIjowLCIzIjowLCI0IjowLCI1IjowLCI2IjowLCI3IjowLCJlbmFibGUiOnRydWUsImV4cGFuZCI6Im9mZiIsImVwZF9yaWdodCI6MCwiZXBkX2xlZnQiOjAsInNwZWVkIjoxLCJkZWZfbGVmdCI6LTE4MCwiZGVsYXkiOjEsImJhc2UiOiJhdCB0YXJnZXRzIiwiYWRkIjoyMSwiYnlfbW9kZSI6InN0YXRpYyIsImRlZl9yaWdodCI6MTgwLCJkZWZfYm9keSI6ImRlZmF1bHQiLCJyb2xsIjowLCJkZWZfc3BlZWQiOjIwLCJlcGRfd2F5IjowLCJicmVha19sYyI6dHJ1ZSwiZGVmX3BpdGNoX251bSI6MCwiZGVmX3lhd19udW0iOjAsImJ5X251bSI6MTIwLCJkZWZfeWF3Ijoic3BpbiIsImRlZl9waXRjaCI6ImRlZmF1bHQiLCJ3YXlzX21hbnVhbCI6ZmFsc2UsImppdHRlcl9hZGQiOjAsImRlZmVuc2l2ZSI6dHJ1ZSwieF93YXkiOjMsImppdHRlciI6Im9mZiIsInlhd19yYW5kb21pemUiOjB9LCJtb3ZlIjp7IjEiOjAsIjIiOjAsIjMiOjAsIjQiOjAsIjUiOjAsIjYiOjAsIjciOjAsImVuYWJsZSI6dHJ1ZSwiZXhwYW5kIjoibGVmdFwvcmlnaHQiLCJlcGRfcmlnaHQiOi0yNSwiZXBkX2xlZnQiOjQyLCJzcGVlZCI6MSwiZGVmX2xlZnQiOjAsImRlbGF5IjoyLCJiYXNlIjoiYXQgdGFyZ2V0cyIsImFkZCI6NCwiYnlfbW9kZSI6ImppdHRlciIsImRlZl9yaWdodCI6MCwiZGVmX2JvZHkiOiJkZWZhdWx0Iiwicm9sbCI6MCwiZGVmX3NwZWVkIjoxLCJlcGRfd2F5IjowLCJicmVha19sYyI6ZmFsc2UsImRlZl9waXRjaF9udW0iOjAsImRlZl95YXdfbnVtIjowLCJieV9udW0iOjEyMCwiZGVmX3lhdyI6ImRlZmF1bHQiLCJkZWZfcGl0Y2giOiJkZWZhdWx0Iiwid2F5c19tYW51YWwiOmZhbHNlLCJqaXR0ZXJfYWRkIjowLCJkZWZlbnNpdmUiOmZhbHNlLCJ4X3dheSI6Mywiaml0dGVyIjoib2ZmIiwieWF3X3JhbmRvbWl6ZSI6NX0sIm1hbnVhbCI6eyIxIjowLCIyIjowLCIzIjowLCI0IjowLCI1IjowLCI2IjowLCI3IjowLCJlbmFibGUiOnRydWUsImV4cGFuZCI6Im9mZiIsImVwZF9yaWdodCI6MCwiZXBkX2xlZnQiOjAsInNwZWVkIjoxLCJkZWZfbGVmdCI6MCwiZGVsYXkiOjEsImJhc2UiOiJsb2NhbCB2aWV3IiwiYWRkIjowLCJieV9tb2RlIjoic3RhdGljIiwiZGVmX3JpZ2h0IjowLCJkZWZfYm9keSI6ImRlZmF1bHQiLCJyb2xsIjowLCJkZWZfc3BlZWQiOjEsImVwZF93YXkiOjAsImJyZWFrX2xjIjpmYWxzZSwiZGVmX3BpdGNoX251bSI6MCwiZGVmX3lhd19udW0iOjAsImJ5X251bSI6MTgwLCJkZWZfeWF3IjoiZGVmYXVsdCIsImRlZl9waXRjaCI6ImRlZmF1bHQiLCJ3YXlzX21hbnVhbCI6ZmFsc2UsImppdHRlcl9hZGQiOjAsImRlZmVuc2l2ZSI6ZmFsc2UsInhfd2F5IjozLCJqaXR0ZXIiOiJvZmYiLCJ5YXdfcmFuZG9taXplIjowfSwiYWlyIjp7IjEiOjAsIjIiOjAsIjMiOjAsIjQiOjAsIjUiOjAsIjYiOjAsIjciOjAsImVuYWJsZSI6dHJ1ZSwiZXhwYW5kIjoibGVmdFwvcmlnaHQiLCJlcGRfcmlnaHQiOjEzLCJlcGRfbGVmdCI6LTEzLCJzcGVlZCI6MSwiZGVmX2xlZnQiOi0xOCwiZGVsYXkiOjIsImJhc2UiOiJhdCB0YXJnZXRzIiwiYWRkIjo3LCJieV9tb2RlIjoiaml0dGVyIiwiZGVmX3JpZ2h0IjoyNywiZGVmX2JvZHkiOiJhdXRvIiwicm9sbCI6MCwiZGVmX3NwZWVkIjoxLCJlcGRfd2F5IjowLCJicmVha19sYyI6dHJ1ZSwiZGVmX3BpdGNoX251bSI6MCwiZGVmX3lhd19udW0iOjAsImJ5X251bSI6LTYxLCJkZWZfeWF3IjoiZGVsYXllZCIsImRlZl9waXRjaCI6ImRlZmF1bHQiLCJ3YXlzX21hbnVhbCI6ZmFsc2UsImppdHRlcl9hZGQiOjM3LCJkZWZlbnNpdmUiOnRydWUsInhfd2F5IjozLCJqaXR0ZXIiOiJjZW50ZXIiLCJ5YXdfcmFuZG9taXplIjozfSwic2xvdy1tb3Rpb24iOnsiMSI6MCwiMiI6MCwiMyI6MCwiNCI6MCwiNSI6MCwiNiI6MCwiNyI6MCwiZW5hYmxlIjp0cnVlLCJleHBhbmQiOiJvZmYiLCJlcGRfcmlnaHQiOjAsImVwZF9sZWZ0IjowLCJzcGVlZCI6MSwiZGVmX2xlZnQiOjAsImRlbGF5IjoxLCJiYXNlIjoiYXQgdGFyZ2V0cyIsImFkZCI6LTEsImJ5X21vZGUiOiJqaXR0ZXIiLCJkZWZfcmlnaHQiOjAsImRlZl9ib2R5IjoiZGVmYXVsdCIsInJvbGwiOi00LCJkZWZfc3BlZWQiOjEsImVwZF93YXkiOjAsImJyZWFrX2xjIjpmYWxzZSwiZGVmX3BpdGNoX251bSI6MCwiZGVmX3lhd19udW0iOjAsImJ5X251bSI6MTIwLCJkZWZfeWF3IjoicmFuZG9tIHN0YXRpYyIsImRlZl9waXRjaCI6ImRlZmF1bHQiLCJ3YXlzX21hbnVhbCI6ZmFsc2UsImppdHRlcl9hZGQiOi03MCwiZGVmZW5zaXZlIjpmYWxzZSwieF93YXkiOjMsImppdHRlciI6ImNlbnRlciIsInlhd19yYW5kb21pemUiOjB9LCJzdGFuZCI6eyIxIjowLCIyIjowLCIzIjowLCI0IjowLCI1IjowLCI2IjowLCI3IjowLCJlbmFibGUiOnRydWUsImV4cGFuZCI6Im9mZiIsImVwZF9yaWdodCI6MCwiZXBkX2xlZnQiOjAsInNwZWVkIjoxLCJkZWZfbGVmdCI6LTE4MCwiZGVsYXkiOjEsImJhc2UiOiJhdCB0YXJnZXRzIiwiYWRkIjoyMSwiYnlfbW9kZSI6InN0YXRpYyIsImRlZl9yaWdodCI6MTgwLCJkZWZfYm9keSI6ImF1dG8iLCJyb2xsIjowLCJkZWZfc3BlZWQiOjMzLCJlcGRfd2F5IjowLCJicmVha19sYyI6dHJ1ZSwiZGVmX3BpdGNoX251bSI6MCwiZGVmX3lhd19udW0iOjAsImJ5X251bSI6MTIwLCJkZWZfeWF3IjoiY3VzdG9tIiwiZGVmX3BpdGNoIjoiZGVmYXVsdCIsIndheXNfbWFudWFsIjpmYWxzZSwiaml0dGVyX2FkZCI6MCwiZGVmZW5zaXZlIjpmYWxzZSwieF93YXkiOjMsImppdHRlciI6Im9mZiIsInlhd19yYW5kb21pemUiOjB9LCJjcm91Y2giOnsiMSI6MCwiMiI6MCwiMyI6MCwiNCI6MCwiNSI6MCwiNiI6MCwiNyI6MCwiZW5hYmxlIjp0cnVlLCJleHBhbmQiOiJsZWZ0XC9yaWdodCIsImVwZF9yaWdodCI6NDUsImVwZF9sZWZ0IjotMzAsInNwZWVkIjoxLCJkZWZfbGVmdCI6LTE4MCwiZGVsYXkiOjIsImJhc2UiOiJhdCB0YXJnZXRzIiwiYWRkIjowLCJieV9tb2RlIjoiaml0dGVyIiwiZGVmX3JpZ2h0IjoxODAsImRlZl9ib2R5IjoiZGVmYXVsdCIsInJvbGwiOjAsImRlZl9zcGVlZCI6MTIsImVwZF93YXkiOjAsImJyZWFrX2xjIjp0cnVlLCJkZWZfcGl0Y2hfbnVtIjowLCJkZWZfeWF3X251bSI6MCwiYnlfbnVtIjotMTIwLCJkZWZfeWF3Ijoic3BpbiIsImRlZl9waXRjaCI6InVwIiwid2F5c19tYW51YWwiOmZhbHNlLCJqaXR0ZXJfYWRkIjoxMiwiZGVmZW5zaXZlIjpmYWxzZSwieF93YXkiOjMsImppdHRlciI6Im9mZiIsInlhd19yYW5kb21pemUiOjB9LCJjcm91Y2ggbW92ZSI6eyIxIjowLCIyIjowLCIzIjowLCI0IjowLCI1IjowLCI2IjowLCI3IjowLCJlbmFibGUiOnRydWUsImV4cGFuZCI6ImxlZnRcL3JpZ2h0IiwiZXBkX3JpZ2h0IjozMywiZXBkX2xlZnQiOi0zMCwic3BlZWQiOjEsImRlZl9sZWZ0IjotMTgwLCJkZWxheSI6MiwiYmFzZSI6ImF0IHRhcmdldHMiLCJhZGQiOjAsImJ5X21vZGUiOiJqaXR0ZXIiLCJkZWZfcmlnaHQiOjE4MCwiZGVmX2JvZHkiOiJkZWZhdWx0Iiwicm9sbCI6MCwiZGVmX3NwZWVkIjoxMiwiZXBkX3dheSI6MCwiYnJlYWtfbGMiOnRydWUsImRlZl9waXRjaF9udW0iOjAsImRlZl95YXdfbnVtIjowLCJieV9udW0iOi0xMjAsImRlZl95YXciOiJzcGluIiwiZGVmX3BpdGNoIjoidXAiLCJ3YXlzX21hbnVhbCI6ZmFsc2UsImppdHRlcl9hZGQiOjAsImRlZmVuc2l2ZSI6ZmFsc2UsInhfd2F5IjozLCJqaXR0ZXIiOiJvZmYiLCJ5YXdfcmFuZG9taXplIjowfSwiZ2xvYmFsIjp7IjEiOjAsIjIiOjAsIjMiOjAsIjQiOjAsIjUiOjAsIjYiOjAsIjciOjAsImV4cGFuZCI6Im9mZiIsImVwZF9yaWdodCI6MCwiZXBkX2xlZnQiOjAsInNwZWVkIjoxLCJkZWZfbGVmdCI6LTE4MCwiZGVsYXkiOjEsImJ5X251bSI6MCwiYWRkIjowLCJieV9tb2RlIjoib2ZmIiwiZGVmX3JpZ2h0IjoxODAsImRlZl9ib2R5IjoiZGVmYXVsdCIsInJvbGwiOjAsImRlZl9zcGVlZCI6MSwiZXBkX3dheSI6MCwiYnJlYWtfbGMiOnRydWUsImRlZl9waXRjaF9udW0iOjAsImRlZl95YXdfbnVtIjowLCJkZWZlbnNpdmUiOnRydWUsImRlZl95YXciOiJzcGluIiwiZGVmX3BpdGNoIjoidXAiLCJ3YXlzX21hbnVhbCI6ZmFsc2UsImppdHRlcl9hZGQiOjUsImJhc2UiOiJsb2NhbCB2aWV3IiwieF93YXkiOjMsImppdHRlciI6Im9mZiIsInlhd19yYW5kb21pemUiOjB9fSwiY29uZGl0aW9uIjoiYWlyIGNyb3VjaCIsInZpc3VhbHMiOnsidmVydGljYWxfb2Zmc2V0IjoxMDAsImluZGljYXRvcl9jb2xvciI6IiNGRkZGRkZGRiIsIm1hbnVhbF9hcnJvd3NfYWNjZW50IjoiIzRENEQ0REZGIiwib25fYWlyX29wdGlvbnMiOiJraW5ndXJ1IiwibWFudWFsX29mZnNldCI6MTAwLCJpbmRpY2F0b3JzIjpmYWxzZSwibWFudWFsX2Fycm93c19jb2xvciI6IiNGRkZGRkZGRiIsIm1hbnVhbF9hcnJvd3MiOnRydWUsImFuaW1hdGlvbl9icmVha2VyIjpbInplcm8gb24gbGFuZCIsInNsaWRpbmcgc2xvdyBtb3Rpb24iLCJzbGlkaW5nIGNyb3VjaCIsIm9uIGdyb3VuZCIsIm9uIGFpciIsIn4iXSwib25fZ3JvdW5kX29wdGlvbnMiOiJmcm96ZW4iLCJyZW5ld2VkX2NvbG9yIjoiI0M4QzhDOEZGIn0sIm1pc2MiOnsiYXV0b19oaWRlc2hvdHMiOnRydWUsImF1dG9faGlkZXNob3RzX3dwbnMiOlsiRGVzZXJ0IEVhZ2xlIiwifiJdLCJjbGFudGFnIjp0cnVlLCJwZWVrZml4IjpmYWxzZSwiZmlsdGVyIjp0cnVlLCJmaXhfaGlkZXNob3QiOnRydWUsInVuc2FmZV9jaGFyZ2UiOnRydWUsImN1c3RvbV9vdXRwdXQiOnRydWUsImNoYXRfc3BhbW1yZSI6dHJ1ZSwiZXZlbnRfbG9nZ2VyIjp0cnVlfSwiYW50aV9haW0iOnsid2FybXVwX2FhIjpbInJvdW5kIGVuZCIsIn4iXSwiZGlzX2ZzIjpbInN0YW5kIiwibW92ZSIsIn4iXSwibWFudWFsX2FhIjp0cnVlLCJlZGdlX3lhdyI6WzEsMCwifiJdLCJ1c2VfYWEiOnRydWUsImFudGlfYnJ1dGVmb3JjZV90eXBlIjoiZGVjcmVhc2UiLCJzYWZlX2hlYWQiOlsia25pZmUiLCJ6ZXVzIiwifiJdLCJmZF9lZGdlIjp0cnVlLCJsYWRkZXIiOnRydWUsImZyZWVzdGFuZGluZyI6WzEsNSwifiJdLCJkZWZlbnNpdmUiOlsib24gc2hvdCIsImZsYXNoZWQiLCJkYW1hZ2UgcmVjZWl2ZWQiLCJyZWxvYWRpbmciLCJ3ZWFwb24gc3dpdGNoIiwifiJdLCJhbnRpX2JydXRlZm9yY2UiOnRydWUsImFudGlfYmFja3N0YWIiOnRydWV9LCJtYW51YWxfYWFfaG90a2V5Ijp7Im1hbnVhbF9iYWNrIjpbMiwwLCJ+Il0sIm1hbnVhbF9sZWZ0IjpbMiw5MCwifiJdLCJtYW51YWxfcmlnaHQiOlsyLDY3LCJ+Il0sIm1hbnVhbF9mb3J3YXJkIjpbMiwwLCJ+Il19LCJuYXZpZ2F0aW9uIjp7ImFhX2NvbWJvIjoic2V0dGluZ3MiLCJvcHRpb25zIjoiaG9tZSJ9fQ==+Il0sImNsYW50YWciOnRydWUsInBlZWtmaXgiOmZhbHNlLCJmaWx0ZXIiOnRydWUsImZpeF9oaWRlc2hvdCI6dHJ1ZSwidW5zYWZlX2NoYXJnZSI6dHJ1ZSwiY3VzdG9tX291dHB1dCI6dHJ1ZSwiY2hhdF9zcGFtbXJlIjp0cnVlLCJldmVudF9sb2dnZXIiOnRydWV9LCJhbnRpX2FpbSI6eyJ3YXJtdXBfYWEiOlsicm91bmQgZW5kIiwifiJdLCJkaXNfZnMiOlsic3RhbmQiLCJtb3ZlIiwifiJdLCJtYW51YWxfYWEiOnRydWUsImVkZ2VfeWF3IjpbMSwwLCJ+Il0sInVzZV9hYSI6dHJ1ZSwiYW50aV9icnV0ZWZvcmNlX3R5cGUiOiJkZWNyZWFzZSIsInNhZmVfaGVhZCI6WyJrbmlmZSIsInpldXMiLCJ+Il0sImZkX2VkZ2UiOnRydWUsImxhZGRlciI6dHJ1ZSwiZnJlZXN0YW5kaW5nIjpbMSw1LCJ+Il0sImRlZmVuc2l2ZSI6WyJvbiBzaG90IiwiZmxhc2hlZCIsImRhbWFnZSByZWNlaXZlZCIsInJlbG9hZGluZyIsIndlYXBvbiBzd2l0Y2giLCJ+Il0sImFudGlfYnJ1dGVmb3JjZSI6dHJ1ZSwiYW50aV9iYWNrc3RhYiI6dHJ1ZX0sIm1hbnVhbF9hYV9ob3RrZXkiOnsibWFudWFsX2JhY2siOlsyLDAsIn4iXSwibWFudWFsX2xlZnQiOlsyLDkwLCJ+Il0sIm1hbnVhbF9yaWdodCI6WzIsNjcsIn4iXSwibWFudWFsX2ZvcndhcmQiOlsyLDAsIn4iXX0sIm5hdmlnYXRpb24iOnsiYWFfY29tYm8iOiJzZXR0aW5ncyIsIm9wdGlvbnMiOiJob21lIn19+Il0sImNsYW50YWciOnRydWUsInBlZWtmaXgiOmZhbHNlLCJmaWx0ZXIiOnRydWUsImZpeF9oaWRlc2hvdCI6dHJ1ZSwidW5zYWZlX2NoYXJnZSI6dHJ1ZSwiY3VzdG9tX291dHB1dCI6dHJ1ZSwiY2hhdF9zcGFtbXJlIjp0cnVlLCJldmVudF9sb2dnZXIiOnRydWV9LCJhbnRpX2FpbSI6eyJ3YXJtdXBfYWEiOlsicm91bmQgZW5kIiwifiJdLCJkaXNfZnMiOlsic3RhbmQiLCJtb3ZlIiwifiJdLCJtYW51YWxfYWEiOnRydWUsImVkZ2VfeWF3IjpbMSwwLCJ+Il0sInVzZV9hYSI6dHJ1ZSwiYW50aV9icnV0ZWZvcmNlX3R5cGUiOiJpbmNyZWFzZSIsInNhZmVfaGVhZCI6WyJrbmlmZSIsInpldXMiLCJ+Il0sImZkX2VkZ2UiOnRydWUsImxhZGRlciI6dHJ1ZSwiZnJlZXN0YW5kaW5nIjpbMSw1LCJ+Il0sImRlZmVuc2l2ZSI6WyJvbiBzaG90IiwiZmxhc2hlZCIsImRhbWFnZSByZWNlaXZlZCIsInJlbG9hZGluZyIsIndlYXBvbiBzd2l0Y2giLCJ+Il0sImFudGlfYnJ1dGVmb3JjZSI6dHJ1ZSwiYW50aV9iYWNrc3RhYiI6dHJ1ZX0sIm1hbnVhbF9hYV9ob3RrZXkiOnsibWFudWFsX2JhY2siOlsyLDAsIn4iXSwibWFudWFsX2xlZnQiOlsyLDkwLCJ+Il0sIm1hbnVhbF9yaWdodCI6WzIsNjcsIn4iXSwibWFudWFsX2ZvcndhcmQiOlsyLDAsIn4iXX0sIm5hdmlnYXRpb24iOnsiZGVidWciOmZhbHNlLCJhYV9jb21ibyI6InNldHRpbmdzIiwib3B0aW9ucyI6ImhvbWUifX0="


        configs.default = function()
            local parse_data = json.parse(base64.decode(default))
            ui_handler.configs_da:load(parse_data)
            client.exec("play ui\\beepclear;")
        end
    end

    ui_handler.navigation  = {} do
        ui_handler.navigation.label = group:label("universe")
        ui_handler.navigation.options = group:combobox("\ntab", { "home", 'anti-aim', "visual", "miscellaneous"})
        ui_handler.navigation.aa_combo = group:combobox('\n', { "settings", "builder" }):depend({ ui_handler.navigation.options, 'anti-aim' })
        ui_handler.navigation.import = group:button("import", function() configs.import(clipboard.get():match('[%w%+%/]+%=*')) end):depend({ui_handler.navigation.options, 'home' })
        ui_handler.navigation.export = group:button("export", function() configs.export() end):depend({ui_handler.navigation.options, 'home'})
        ui_handler.navigation.default = group:button("default", function() print(3) end):depend({ui_handler.navigation.options, 'home'})
        if user.name == "admin" then
            ui_handler.navigation.debug = group:checkbox("debug"):depend({ui_handler.navigation.options, 'home'} )
        end
        
    end

    ui_handler.anti_aim = {} do
        ui_handler.anti_aim.edge_yaw = group:hotkey("\aA4B2F1FF•\r  edge yaw")
        ui_handler.anti_aim.freestanding = group:hotkey("\aA4B2F1FF•\r  freestanding")
        ui_handler.anti_aim.dis_fs = group:multiselect("\nignore_freestand",{"stand","slow-motion","move","crouch","crouch move","air","air crouch"})
        ui_handler.anti_aim.use_aa = group:checkbox("\aA4B2F1FF•\r  antiaim on use")
        ui_handler.anti_aim.anti_backstab = group:checkbox("\aA4B2F1FF•\r  avoid backstab")
        ui_handler.anti_aim.fd_edge = group:checkbox("\aA4B2F1FF•\r  fakeduck edge")
        ui_handler.anti_aim.ladder = group:checkbox("\aA4B2F1FF•\r  fast ladder")
        ui_handler.anti_aim.anti_bruteforce = group:checkbox("\aA4B2F1FF•\r  anti-bruteforce")
        ui_handler.anti_aim.anti_bruteforce_type = group:combobox("\nanti_bruteforce_type","increase","decrease"):depend({ ui_handler.anti_aim.anti_bruteforce, true})
        ui_handler.anti_aim.defensive = group:multiselect("\aA4B2F1FF•\r  defensive",{"on shot","flashed","damage received","reloading","weapon switch"})
        ui_handler.anti_aim.safe_head = group:multiselect("\aA4B2F1FF•\r  safe head",{ "height distance", "high distance", "knife", "zeus", })
        ui_handler.anti_aim.warmup_aa = group:multiselect("\aA4B2F1FF•\r  warmup aa",{"warmup","round end"})
        ui_handler.anti_aim.manual_aa = group:checkbox("\aA4B2F1FF•\r  manual antiaim")
        for _, v in pairs(ui_handler.anti_aim) do
            v:depend({ ui_handler.navigation.options, 'anti-aim' }, { ui_handler.navigation.aa_combo, "settings" })
        end
    end

    ui_handler.manual_aa_hotkey = {} do
        ui_handler.manual_aa_hotkey.manual_left = group:hotkey("\aA4B2F1FF•\r  manual left")
        ui_handler.manual_aa_hotkey.manual_right = group:hotkey("\aA4B2F1FF•\r  manual right")
        ui_handler.manual_aa_hotkey.manual_forward = group:hotkey("\aA4B2F1FF•\r  manual forward")
        ui_handler.manual_aa_hotkey.manual_back = group:hotkey("\aA4B2F1FF•\r  manual reset")
        for _, v in pairs(ui_handler.manual_aa_hotkey) do
            v:depend({ ui_handler.navigation.options, 'anti-aim'  }, { ui_handler.anti_aim.manual_aa, true },{ui_handler.navigation.aa_combo, "settings"})
        end
    end

    ui_handler.builder , ui_handler.way_manual = {} , {} do
        ui_handler.condition = group:combobox("\ncondition", e_statement):depend({ ui_handler.navigation.options, 'anti-aim'  }, { ui_handler.navigation.aa_combo, "builder" })

        local tooltips  = {delay = { [1] = "Off", [2] = "BEST",[5] = "RS",[10] = "SW" },roll = { [-40] = "MAX", [0] = "Off", [40] = "MAX" },body = { [-120] = "BEST", [0] = "Off", [120] = "BEST" },}
        for _, state in ipairs(e_statement) do
            ui_handler.builder[state] = {}
            local this = ui_handler.builder[state]
            if state ~= "global" then
                this.enable = group:checkbox('\aA4B2F1FF•\r  override\n'..state, false)
            end
            this.base = group:combobox("\aA4B2F1FF•\r  base\n"..state, {"local view", "at targets"})
            this.add = group:slider("\aA4B2F1FF•\r  yaw\n"..state, -180, 180, 0, true, "°", 1)
            this.expand = group:combobox("\aA4B2F1FF•\r  expand\n"..state,{ "off", "left/right","x-way","spin"})

            this.epd_left = group:slider("\aA4B2F1FF•\r  left \n" .. state, -180, 180, 0, true, "°", 1):depend({this.expand,"x-way",true},{this.expand,"off",true})
            this.epd_right = group:slider("\aA4B2F1FF•\r  right \n" .. state, -180, 180, 0, true, "°", 1):depend({this.expand,"x-way",true},{this.expand,"off",true})
            this.delay = group:slider("\aA4B2F1FF•\r  \aCDCDCD60delay\n" .. state, 1, 10, 0, true, "t", 1, tooltips.delay):depend({this.expand,"left/right"})
            this.speed = group:slider("\aA4B2F1FF•\r  \aCDCDCD60speed\n" .. state, 1, 64, 1, true, "t", 1):depend({this.expand,"spin"})

            this.ways_manual = group:checkbox('\aA4B2F1FF•\r  ways manual\n'..state, false):depend({ this.expand, "x-way" })
            this.x_way = group:slider("\aA4B2F1FF•\r  total \n" .. state, 3, 7, 3, true, "-w"):depend({ this.expand, "x-way" })
            this.x_waylabel = group:label("\aA4B2F1FF•\r  way"):depend({this.expand,"x-way"}, {this.ways_manual,true})

            
            this.x_way:set_callback(function (ctx) this.x_waylabel:set("\aA4B2F1FF•\r  way \aCDCDCD60" .. ctx.value) end, true)
            this.epd_way = group:slider("\aA4B2F1FF•\r  way\n" .. state, -180, 180, 0, true, "°", 1):depend({this.expand,"x-way"}, {this.ways_manual,false})
            for w = 1, 7 do
                this[w] = group:slider("\n"..w..state, -180, 180, 0, true, "°", 1, {[0] = "R"}):depend({this.expand, "x-way"}, this.ways_manual, {this.x_way, w, 7})
            end
            this.jitter = group:combobox("\aA4B2F1FF•\r  modifier\n" .. state,{ "off", "offset", "center", "random"})
            this.jitter_add = group:slider("\nyaw_jitter_add " .. state, -180, 180, 0, true,"°"):depend({this.jitter,"off",true})

            this.yaw_randomize = group:slider('\aA4B2F1FF•\r  kandomization \n' .. state, 0, 100, 0, 0, '%', 1, {[0] = "Off"})



            this.by_mode = group:combobox("\aA4B2F1FF•\r  body\n" .. state,{ "off", "static", "opposite", "jitter" })
            this.by_num = group:slider("\aA4B2F1FF•\r  \aCDCDCD60num\n" .. state, -180, 180, 0, true, "°", 1, tooltips.body):depend({ this.by_mode, "off", true }, { this.by_mode, "opposite", true })
            this.roll = group:slider("\aA4B2F1FF•\r  \aCDCDCD60roll\n" .. state, -45, 45, 0, true, "°", 1, tooltips.roll)
            this.break_lc = group:checkbox("\aA4B2F1FF•\r  force break lc\n" .. state)
            this.defensive = group:checkbox("\aA4B2F1FF•\r  defensive aa\n" .. state)

            this.def_pitch = group:combobox("\aA4B2F1FF•\r  picth\n defensive" .. state,{ "default", "up", "zero", "up switch","down switch", "random static","random","custom"}):depend({this.defensive,true})
            this.def_pitch_num = group:slider("\aA4B2F1FF•\r  \aCDCDCD60num\n picth defensive" .. state, -89, 89, 0, true, "°", 1):depend({this.defensive,true},{this.def_pitch,"custom"})

            this.def_yaw = group:combobox("\aA4B2F1FF•\r  yaw\n defensive" .. state,{ "default", "forward", "sideways", "delayed","spin","random", "random static","flick exploit","custom",}):depend({this.defensive,true})
            this.def_left = group:slider("\aA4B2F1FF•\r  \aCDCDCD60left\n yaw defensive" .. state, -180, 180, 0, true, "°", 1):depend({this.defensive,true},{this.def_yaw, function()
                return  this.def_yaw:get() == "delayed" or  this.def_yaw:get() == "spin" or  this.def_yaw:get() == "random" or  this.def_yaw:get() == "random static"
            end})
            this.def_right = group:slider("\aA4B2F1FF•\r  \aCDCDCD60right\n yaw defensive" .. state, -180, 180, 0, true, "°", 1):depend({this.defensive,true},{this.def_yaw, function()
                return  this.def_yaw:get() == "delayed" or  this.def_yaw:get() == "spin" or  this.def_yaw:get() == "random" or  this.def_yaw:get() == "random static"
            end})
            this.def_speed = group:slider("\aA4B2F1FF•\r  \aCDCDCD60speed\n yaw defensive" .. state, 1, 64, 1, true, "t", 1):depend({this.defensive,true},{this.def_yaw, "spin" })
            this.def_yaw_num = group:slider("\aA4B2F1FF•\r  \aCDCDCD60num\n yaw defensive" .. state, -180, 180, 0, true, "°", 1):depend({this.defensive,true},{this.def_yaw,"custom"})
            this.def_body = group:combobox("\aA4B2F1FF•\r  body\n defensive" .. state,{ "default", "auto", "jitter"}):depend({this.defensive,true})

            for _, v in pairs(this) do
                local arr = { { ui_handler.navigation.options, 'anti-aim' }, { ui_handler.navigation.aa_combo, "builder" }, { ui_handler.condition, state } }
                if _ ~= "enable" and state ~= "global" then
                    arr = { { ui_handler.navigation.options, 'anti-aim' }, { ui_handler.navigation.aa_combo, "builder" }, { ui_handler.condition, state }, { this.enable, true } }
                end
                v:depend(table.unpack(arr))
            end
        end
    end

    ui_handler.visuals = {} do
        ui_handler.visuals.indicators =  group:checkbox("\aA4B2F1FF•\r  indicators")  
        ui_handler.visuals.vertical_offset = group:slider("\aA4B2F1FF•\r  \aCDCDCD60offset\n indicators", 20, 100, 10, true, "px"):depend({ui_handler.visuals.indicators, true})
        ui_handler.visuals.indicator_color = group:color_picker("\nindicator_colordsadsa", 255, 255, 255, 255):depend({ui_handler.visuals.indicators, true})
        ui_handler.visuals.renewed_color = group:color_picker("\nindicator Reneweddsadsa", 77, 77, 77, 255):depend({ui_handler.visuals.indicators, true})
        ui_handler.visuals.manual_arrows =  group:checkbox("\aA4B2F1FF•\r  manual arrows")  
        ui_handler.visuals.manual_offset = group:slider("\aA4B2F1FF•\r  \aCDCDCD60offset\n manual", 10, 100, 50, true, "px"):depend({ui_handler.visuals.manual_arrows, true})
        ui_handler.visuals.manual_arrows_color = group:color_picker("\nmanual_arrowsdsadsadsa", 255, 255, 255, 255):depend({ui_handler.visuals.manual_arrows, true})
        ui_handler.visuals.manual_arrows_accent = group:color_picker("\nmanual_arrows_Accentfdafdas", 77, 77, 77, 255):depend({ui_handler.visuals.manual_arrows, true})
        ui_handler.visuals.animation_breaker = group:multiselect("\aA4B2F1FF•\r  animation breaker",{"zero on land","earthquake","sliding slow motion","sliding crouch","on ground","on air","quick peek legs"})
        ui_handler.visuals.on_ground_options = group:combobox("\aA4B2F1FF•\r  on ground", {"frozen", "walking","jitter","sliding","star"}):depend({ ui_handler.visuals.animation_breaker, "on ground" })
        ui_handler.visuals.on_air_options = group:combobox("\aA4B2F1FF•\r  on air", {"frozen", "walking", "kinguru" }):depend({ui_handler.visuals.animation_breaker, "on air" })

        for _, v in pairs(ui_handler.visuals) do
            v:depend({ ui_handler.navigation.options, 'visual' })
        end

    end

    ui_handler.misc = {} do
        ui_handler.misc.unsafe_charge = group:checkbox("\aA4B2F1FF•\r  force recharge")
        ui_handler.misc.fix_hideshot = group:checkbox("\aA4B2F1FF•\r  fix hideshot")
        ui_handler.misc.peekfix = group:checkbox("\aA4B2F1FF•\r  early defensive")
        ui_handler.misc.clantag = group:checkbox("\aA4B2F1FF•\r  clantag")
        ui_handler.misc.chat_spammre = group:checkbox('\aA4B2F1FF•\r  chat spammer')
        ui_handler.misc.custom_output =  group:checkbox("\aA4B2F1FF•\r  custom output") 
        ui_handler.misc.event_logger =  group:checkbox("\aA4B2F1FF•\r  event logger") 
        ui_handler.misc.filter = group:checkbox('\aA4B2F1FF•\r  console filter')
        ui_handler.misc.auto_hideshots = group:checkbox("\aA4B2F1FF•\r  automatic hideshots")
        ui_handler.misc.auto_hideshots_wpns = group:multiselect("\nAutomatic Hideshots Weapons",{ "Pistols", "Desert Eagle" }):depend({ ui_handler.misc.auto_hideshots, true })

        for _, v in pairs(ui_handler.misc) do
            v:depend({ ui_handler.navigation.options, 'miscellaneous' })
        end
    end
    
    ui_handler.configs_da = pui.setup(ui_handler)
  
end

local anti_aim = {} do

    anti_aim.features = {} do

        anti_aim.features.use_aa = false
        anti_aim.features.stab = false
        anti_aim.features.fast_ladder = false
        anti_aim.features.safe_head = false
        anti_aim.features.manual = 0.0
        anti_aim.features.defensive = false
        anti_aim.features.warmup_aa = false

        anti_aim.features.legit_antiaim = {} do
            local start_time = globals.realtime()

            function anti_aim.features.legit_antiaim.run(cmd)
                
                if not ui_handler.anti_aim.use_aa:get() then
                    return false
                end
    
                if cmd.in_use == 0 then
                    start_time = globals.realtime()
                    return
                end
    
                local player = entity.get_local_player()
    
                if player == nil then
                    return
                end
    
                local player_origin = { entity.get_origin(player) }
    
                local CPlantedC4 = entity.get_all('CPlantedC4')
                local dist_to_bomb = 999
    
                if #CPlantedC4 > 0 then
                    local bomb = CPlantedC4[1]
                    local bomb_origin = { entity.get_origin(bomb) }
    
                    dist_to_bomb = vector(player_origin[1], player_origin[2], player_origin[3]):dist(vector(bomb_origin[1],
                        bomb_origin[2], bomb_origin[3]))
                end
    
                local CHostage = entity.get_all('CHostage')
                local dist_to_hostage = 999
    
                if CHostage ~= nil then
                    if #CHostage > 0 then
                        local hostage_origin = { entity.get_origin(CHostage[1]) }
    
                        dist_to_hostage = math.min(
                            vector(player_origin[1], player_origin[2], player_origin[3]):dist(vector(hostage_origin[1],
                                hostage_origin[2], hostage_origin[3])),
                            vector(player_origin[1], player_origin[2], player_origin[3]):dist(vector(hostage_origin[1],
                                hostage_origin[2], hostage_origin[3])))
                    end
                end
    
                if dist_to_hostage < 65 and entity.get_prop(player, 'm_iTeamNum') ~= 2 then
                    return
                end
    
                if dist_to_bomb < 65 and entity.get_prop(player, 'm_iTeamNum') ~= 2 then
                    return
                end
    
                if cmd.in_use then
                    if globals.realtime() - start_time < 0.02 then
                        return
                    end
                end
    
                cmd.in_use = false
                return true
            end
            
        end

        anti_aim.features.anti_backstab = {} do

            function anti_aim.features.anti_backstab.run()
                local players = entity.get_players(true)
                for i = 1, #players do
                    local x, y, z = entity.get_prop(players[i], 'm_vecOrigin')
                    local origin = vector(entity.get_prop(entity.get_local_player(), 'm_vecOrigin'))
                    local distance = math.sqrt((x - origin.x) ^ 2 + (y - origin.y) ^ 2 + (z - origin.z) ^ 2)
                    local weapon = entity.get_player_weapon(players[i])
                    if entity.get_classname(weapon) == 'CKnife' and distance <= 200 then
                        return true
                    end
                end
                
                return false
            end
            
        end

        anti_aim.features.ladder = {} do
            function anti_aim.features.ladder.run(cmd)
                if not ui_handler.anti_aim.ladder:get() then
                    return false
                end
                if entity.get_prop(entity.get_local_player(), "m_MoveType") ~= 9 or cmd.forwardmove == 0 then 
                    return false
                end
                local camera_pitch, camera_yaw = client.camera_angles()
                local descending = cmd.forwardmove < 0 or camera_pitch > 45
                cmd.in_moveleft, cmd.in_moveright = descending and 1 or 0, not descending and 1 or 0
                cmd.in_forward, cmd.in_back = descending and 1 or 0, not descending and 1 or 0
                cmd.pitch, cmd.yaw = 89, c_math.normalize_yaw(cmd.yaw + 90)
                return true
            end
        end

        anti_aim.features.safe = {} do

            function anti_aim.features.safe.run(cmd)
                local result = math.huge;
                local heightDifference = 0;
                local localplayer = entity.get_local_player();
                local entities = entity.get_players(true);

                for i = 1, #entities do
                    local ent = entities[i];
                    local ent_origin = { entity.get_origin(ent) }
                    local lp_origin = { entity.get_origin(localplayer) }
                    if ent ~= localplayer and entity.is_alive(ent) then
                        local distance = (vector(ent_origin[1], ent_origin[2], ent_origin[3]) - vector(lp_origin[1], lp_origin[2], lp_origin[3])):length2d();
                        if distance < result then
                            result = distance;
                            heightDifference = ent_origin[3] - lp_origin[3];
                        end
                    end
                end

                local distance_to_enemy = { math.floor(result / 10), math.floor(heightDifference) }

                local weapon = entity.get_player_weapon(entity.get_local_player())
                local knife = weapon ~= nil and entity.get_classname(weapon) == 'CKnife'
                local zeus = weapon ~= nil and entity.get_classname(weapon) == 'CWeaponTaser'
            
                local safe_knife = (ui_handler.anti_aim.safe_head:get('knife')) and knife and not player.onground
                local safe_zeus = (ui_handler.anti_aim.safe_head:get('zeus')) and zeus and  not player.onground
                local distance_height = (ui_handler.anti_aim.safe_head:get('height distance')) and distance_to_enemy[2] < -50
                local distance_hight = (ui_handler.anti_aim.safe_head:get('high distance')) and  distance_to_enemy[1] > 119

                if safe_knife or safe_zeus  or distance_hight or distance_height then
                    return true
                end

                return false
                
           end 
        end

        anti_aim.features.manual_antiaim = {} do
            local manual_cur = nil
            local manual_keys = {
                { "left",    yaw = -90, item = ui_handler.manual_aa_hotkey.manual_left },
                { "right",   yaw = 90,  item = ui_handler.manual_aa_hotkey.manual_right },
                { "reset",   yaw = nil, item = ui_handler.manual_aa_hotkey.manual_back },
                { "forward", yaw = 180, item = ui_handler.manual_aa_hotkey.manual_forward },
            }

            for i, v in ipairs(manual_keys) do
                ui.set(v.item.ref, "Toggle")
            end

            function anti_aim.features.manual_antiaim.run()

                if not ui_handler.anti_aim.manual_aa:get() then 
                    return 0
                end

                for i, v in ipairs(manual_keys) do
                    local active, mode = v.item:get()

                    if v.active == nil then v.active = active end
                    if v.active == active then goto done end
                    v.active = active


                    if v.yaw == nil then manual_cur = nil end
    
                    if mode == 1 then
                        manual_cur = active and i or nil
                        goto done
                    elseif mode == 2 then
                        manual_cur = manual_cur ~= i and i or nil
                        goto done
                    end


                    ::done::

                end

                return manual_cur ~= nil and manual_keys[manual_cur].yaw or 0

            end

            
        end
 
        anti_aim.features.on_hotkey = {} do
            function anti_aim.features.on_hotkey.run()
                local ignore_freestanding = c_math.contains(ui_handler.anti_aim.dis_fs:get(), player.state) and not anti_aim.features.use_aa
                local fs_on_hotkey = ignore_freestanding and ui_handler.anti_aim.freestanding:get() and anti_aim.features.manual == 0
                local edge_on_hotkey = ui_handler.anti_aim.edge_yaw:get() or (ui_handler.anti_aim.fd_edge:get() and  reference.ragebot.duck:get() )
                

                reference.antiaim.edge:set(edge_on_hotkey)
                reference.antiaim.freestand:set(fs_on_hotkey)
                reference.antiaim.freestand.hotkey:set(fs_on_hotkey and "Always on" or "On hotkey")

            end
        end

        anti_aim.features.defensive_ = {} do

            local function is_exploit_ready_and_active(wpn)
         
                local doubletap_active = reference.ragebot.double_tap.hotkey:get()
                local onshot_active = reference.antiaim.onshot.hotkey:get()
                local fakeduck_active = reference.ragebot.duck:get()


                if fakeduck_active or not (onshot_active or doubletap_active) or doubletap_active and not player.shifting then
                    return false
                end

                if wpn then
                    local wpn_info = weapons(wpn)

                    if wpn_info then
                        if wpn_info.is_revolver then
                            return false
                        end
                    end
                end

                return true
            end

            function anti_aim.features.defensive_.run(cmd)
      
                if not entity.get_local_player() then
                    return false
                end
                local me = entity.get_local_player()
                local wpn = me and entity.get_player_weapon(me) or nil
                

                if not is_exploit_ready_and_active(wpn) then
                    return false
                end

                local animlayers = memory.animlayers:get(me)

                if not animlayers then
                    return false
                end

                local weapon_activity_number = memory.activity:get(animlayers[1]['sequence'], me)
                local flash_activity_number = memory.activity:get(animlayers[9]['sequence'], me)
                local is_reloading = animlayers[1]['weight'] ~= 0.0 and weapon_activity_number == 967
                local is_flashed = animlayers[9]['weight'] > 0.1 and flash_activity_number == 960
                local is_under_attack = animlayers[10]['weight'] > 0.1
                local is_swapping_weapons = cmd.weaponselect > 0

                if (ui_handler.anti_aim.defensive:get("flashed") and is_flashed)
                or (ui_handler.anti_aim.defensive:get("damage received") and is_under_attack)
                or (ui_handler.anti_aim.defensive:get("reloading") and is_reloading)
                or (ui_handler.anti_aim.defensive:get("weapon switch") and is_swapping_weapons) 
                or (ui_handler.anti_aim.defensive:get("on shot") and reference.antiaim.onshot.hotkey:get() ) then
                    return false
                end

                return true
            end
        end

        anti_aim.features.warmup_antiaim = {} do
            function anti_aim.features.warmup_antiaim.run()
                local game_rules = entity.get_game_rules()

                if not game_rules then
                    return false
                end

                local warmup_period do
                    local is_active = ui_handler.anti_aim.warmup_aa:get("warmup")
                    local is_warmup = entity.get_prop(game_rules, 'm_bWarmupPeriod') == 1

                    warmup_period = is_active and is_warmup
                end

                if not warmup_period then
                    local player_resource = entity.get_player_resource()

                    if player_resource then
                        local are_all_enemies_dead = true

                        for i=1, globals.maxplayers() do
                            if entity.get_prop(player_resource, 'm_bConnected', i) == 1 then
                                if entity.is_enemy(i) and entity.is_alive(i) then
                                    are_all_enemies_dead = false

                                    break
                                end
                            end
                        end

                        warmup_period = (are_all_enemies_dead and globals.curtime() < (entity.get_prop(game_rules, 'm_flRestartRoundTime') or 0)) and ui_handler.anti_aim.warmup_aa:get("round end")
                    end
                end

                if warmup_period then
                    return true
                end

                return false
            end
        end

        function anti_aim.features.main(cmd)
            anti_aim.features.use_aa = anti_aim.features.legit_antiaim.run(cmd)
            anti_aim.features.stab = anti_aim.features.anti_backstab.run()
            anti_aim.features.fast_ladder = anti_aim.features.ladder.run(cmd)
            anti_aim.features.safe_head = anti_aim.features.safe.run(cmd)
            anti_aim.features.manual = anti_aim.features.manual_antiaim.run()
            anti_aim.features.defensive = anti_aim.features.defensive_.run(cmd)
            anti_aim.features.on_hotkey.run()
            anti_aim.features.warmup_aa = anti_aim.features.warmup_antiaim.run(cmd)
            
        end
        
        
    end

    anti_aim.builder = {} do
        anti_aim.builder.venture = false
        anti_aim.builder.latest = 0
        anti_aim.builder.switch = false
        anti_aim.builder.delay = 0
        anti_aim.builder.restrict = 0
        anti_aim.builder.last_packets = 0
        anti_aim.builder.way = 0

        
        local function get_state(state)
            
            local double_tap = reference.ragebot.double_tap.hotkey:get()
            local onshot = reference.antiaim.onshot.hotkey:get()
            local fake_duck = reference.ragebot.duck:get()

            local freestand = ui_handler.anti_aim.freestanding:get() and player.is_fs_peek and c_math.contains(ui_handler.anti_aim.dis_fs:get(), player.state)

            
            if ui_handler.builder['on use'].enable:get()  and  anti_aim.features.use_aa then
                return  'on use'
            end
            
            if ui_handler.builder['manual'].enable:get() and anti_aim.features.manual ~= 0 then
                return 'manual'
            end

            if ui_handler.builder['freestand'].enable:get() and freestand then
                return 'freestand'
            end

           
            if  ui_handler.builder['safe head'].enable:get() and anti_aim.features.safe_head then
                return 'safe head'
            end

            if ui_handler.builder['on shot'].enable:get() and onshot and not double_tap and not fake_duck then
                return 'on shot'
            end

            if ui_handler.builder['fake lag'].enable:get() and not onshot and not double_tap and not fake_duck then
                return 'fake lag'
            end


            return state
        end

        local function yaw(this)
            if  anti_aim.features.use_aa then
                return 0 , "180" ,this.base.value 
            end
            if anti_aim.features.stab then
                return 0 , "off" ,this.base.value 
            end  
            return 'default' ,   "180" ,reference.antiaim.edge:get() and "local view" or this.base.value 
        end

        local choke  = 1
        local function modifier(this)
            local add , expand = this.add.value, this.expand.value 

            local delay = (expand ~= "left/right" or not player.shifting)  and 1 or this.delay.value 
            if globals.chokedcommands() == 0 then
                choke = choke + 1
            end
            local add_ab_left , add_ab_right= 0 , 0
            if ui_handler.anti_aim.anti_bruteforce:get() and anti_aim.builder.venture then
                if ui_handler.anti_aim.anti_bruteforce_type:get() == "increase" then
                    add_ab_right = anti_aim.builder.restrict * 3
                    add_ab_left= anti_aim.builder.restrict * -3
                elseif ui_handler.anti_aim.anti_bruteforce_type:get() == "decrease" then
                    add_ab_right = anti_aim.builder.restrict * -3
                    add_ab_left= anti_aim.builder.restrict * 3
                end
            end


            if (choke - anti_aim.builder.last_packets >= anti_aim.builder.delay)  then
                anti_aim.builder.delay = delay
                anti_aim.builder.switch = not anti_aim.builder.switch
                anti_aim.builder.last_packets = choke
            end
            
            if expand == "left/right" then
                local  epd_left , epd_right = this.epd_left.value , this.epd_right.value 
                add = add + ( anti_aim.builder.switch and epd_left +add_ab_left or epd_right + add_ab_right)
            elseif expand == "x-way" then
                local x_way , epd_way= this.x_way.value ,this.epd_way.value
                anti_aim.builder.way = anti_aim.builder.way < (x_way - 1) and (anti_aim.builder.way + 1) or 0
                if this.ways_manual.value then
                    
                   add = add +  this[anti_aim.builder.way+1]:get()
                else
                    local step = (anti_aim.builder.way) / (x_way - 1)
                    add = add + c_math.lerp(-epd_way, epd_way, step)
                end
            elseif expand == "spin" then
                local  epd_left , epd_right , speed = this.epd_left.value , this.epd_right.value , this.speed.value
                add = add + c_math.lerp(epd_left, epd_right , globals.curtime() * (speed * 0.1) % 1)
            end

            local jitter_mode, jitter_degree = this.jitter.value, this.jitter_add.value

            if jitter_mode == "offset" then
                add = add + (anti_aim.builder.switch and jitter_degree +add_ab_left or 0 + add_ab_right)
            elseif jitter_mode == "center" then
                add = add + (anti_aim.builder.switch and -jitter_degree / 2 +add_ab_left or jitter_degree / 2 + add_ab_right)
            elseif jitter_mode == "random" then
                add = add + (math.random(0, jitter_degree) - jitter_degree / 2)
            end


     
            
            if not anti_aim.features.use_aa  then

                add = add + anti_aim.features.manual + math.random(this.yaw_randomize:get() * 0.01 * -add, this.yaw_randomize:get() * 0.01 * add)
            end
            if anti_aim.features.use_aa then
                add = add + 180
            end

            

          

            return c_math.normalize_yaw(add )
        end

        local function body(this)
            local by_mdoe , by_num , by_tpye  = this.by_mode.value , 0 , "static"

            if by_mdoe == "static" then
                by_tpye = "static"
                by_num = this.by_num.value
            elseif by_mdoe == "jitter" then
                 by_tpye = "static"
                by_num = anti_aim.builder.switch and this.by_num.value or - this.by_num.value
            elseif by_mdoe == "opposite" then
                by_tpye = "static"
                if player.fs_side == 'left' then
                    by_num = 180
                elseif player.fs_side == 'right' then
                    by_num = -180
                else
                    by_num = 0
                end
            elseif by_mdoe == "off" then
                by_tpye = "off"
            end

            return c_math.normalize_yaw(by_num)  ,  by_tpye

        end

        local srx = nil
        local pitch_srx = nil
        
        local function defensive_builder(cmd,this)
     
            cmd.force_defensive = this.break_lc.value 
       
            local yaw , pitch = this.def_yaw.value , this.def_pitch.value 
            local pitch_num , yaw_num , body_tpye , body_num = 'default' ,nil ,nil ,nil
            if pitch == "up" then pitch_num = -88
            elseif pitch == "zero" then pitch_num = 0 
            elseif pitch == "up switch" then pitch_num = client.random_int(-45, 65)
            elseif pitch == "down switch" then pitch_num = client.random_int(45, 65)
            elseif pitch == "random" then pitch_num =  client.random_int(-89, 89)
            elseif pitch == "random static" then 
                

                if not pitch_srx then
                    pitch_srx = client.random_int(-89, 89)
                end
                pitch_num = pitch_srx

            elseif pitch == "custom" then pitch_num = this.def_pitch_num.value

            end


            if yaw == "sideways" then 
                yaw_num = (anti_aim.builder.switch and 90 or -90 ) + client.random_int(-15, 15)
            elseif yaw == "forward" then
                yaw_num = 180  + client.random_int(-30, 30)
            elseif yaw == "delayed" then
                local left ,  right  = this.def_left.value , this.def_right.value 
                yaw_num = (anti_aim.builder.switch and left or right ) 

            elseif yaw == "spin" then
                local left ,  right  , speed = this.def_left.value , this.def_right.value , this.def_speed.value
                yaw_num =  c_math.lerp(left, right , globals.curtime() * (speed * 0.1) % 1)
            elseif yaw == "random" then
                local left ,  right  = this.def_left.value , this.def_right.value 
                yaw_num =  client.random_int(left,right)
            elseif yaw == "random static" then
                local left ,  right  = this.def_left.value , this.def_right.value 
                if not srx then
                    srx = client.random_int(left,right)
                end
                yaw_num = srx

            elseif yaw == "flick exploit" then
                yaw_num = (player.fs_side  ==  'left' and -90 or 90) +client.random_int(-20,20)
            elseif yaw == "custom" then
                yaw_num = player.fs_side  ==  'left' and  this.def_yaw_num.value  or -this.def_yaw_num.value
            end
   
            local body = this.def_body.value
            if body == "default" then
                body_tpye = "static"
                body_num = 120
            elseif body == "auto" then
                
                if yaw_num ~= nil then
                    body_tpye = "static"
                    body_num =  yaw_num < 0 and -60 or 60
                end
              
            elseif  body == "jitter" then
                body_tpye = "static"
                body_num = anti_aim.builder.switch and -120 or 120
            end

            return pitch_num , yaw_num , body_tpye , body_num

        end
      
        function anti_aim.builder.main(cmd)
            local state = get_state(player.state)
            local this =  ui_handler.builder[state].enable.value and ui_handler.builder[state] or ui_handler.builder["global"]
            local pitch , yaw_type , yaw_base = yaw(this)
            local yaw_add = modifier(this)
            local by_num , by_tpye = body(this)
        
            --print(cmd.force_defensive)
            local pitch_num , yaw_num , body_tpye , body_num  = defensive_builder(cmd,this)
      
            if  (player.defensive  and not anti_aim.features.fast_ladder and not  anti_aim.features.use_aa  and player.shifting) and this.defensive.value and anti_aim.features.defensive then 
            
                pitch = pitch_num ~= nil and pitch_num or pitch
                yaw_add = yaw_num ~= nil and yaw_num or yaw_add
      
                by_num = body_num ~= nil and body_num or by_num

                by_tpye =  body_tpye ~= nil and body_tpye or by_tpye
            else
                srx = nil
                pitch_srx = nil
            end
     
            if anti_aim.features.warmup_aa then
                pitch = 0
                yaw_type = "spin"
                yaw_add = 42
                by_tpye = "off"
            end
           

            if anti_aim.builder.venture then
                if anti_aim.builder.latest + 2 == globals.curtime() then
                    anti_aim.builder.venture = false
                end
            end
          

          
            reference.antiaim.pitch[1]:set(type(pitch) == "number" and 'custom' or pitch)
            reference.antiaim.pitch[2]:set(type(pitch) == "number" and pitch or 0 )
            reference.antiaim.yaw[1]:set(yaw_type)
            reference.antiaim.yaw[2]:set( c_math.normalize_yaw(yaw_add) )
            reference.antiaim.base:set(yaw_base)
            reference.antiaim.fs_body:set(false)
            reference.antiaim.jitter[1]:set("off")
            reference.antiaim.jitter[2]:set(0)
            reference.antiaim.body[1]:set(by_tpye)
            reference.antiaim.body[2]:set(by_num)

        end 

    end

    anti_aim.venture = {} do
        local latest = 0
        local damaged = 0
        
        local function trigger(event)
            local me = entity.get_local_player()

           

            local valid = (me and entity.is_alive(me))
            if not valid or latest == globals.tickcount() then 
                return  
            end
            local attacker = client.userid_to_entindex(event.userid)
            if not attacker or not entity.is_enemy(attacker) or entity.is_dormant(attacker) then return end
            local impact = vector(event.x, event.y, event.z)
            local enemy_view = vector(entity.get_origin(attacker))
            enemy_view.z = enemy_view.z + 64
            local dists = {}
            for i = 1, #player.get_players do
                local v = player.get_players[i]

                if not entity.is_enemy(v) then
                    local head = vector(entity.hitbox_position(v, 0))
                    local point = c_math.closest_ray_point(head, enemy_view, impact)
                    dists[#dists+1] = head:dist(point)
                    if v == me then dists.mine = dists[#dists] end
                end
            end
            local closest = math.min( unpack(dists) )
            if (dists.mine and closest) and dists.mine < 40 or (closest == dists.mine and dists.mine < 128) then
           
                latest = globals.tickcount() 
                anti_aim.builder.latest = globals.curtime()
                anti_aim.builder.venture = true
                anti_aim.builder.restrict = math.random(1, 3)
            end
        end
        client.set_event_callback("bullet_impact", trigger)

  
        
    end

end 

local visuals = {} do
    local screen_size = vector(client.screen_size())
    local screen_center = screen_size * 0.5
    local smooth_scope = c_tweening:new(0)
    visuals.animation_breaker = {} do

        function visuals.animation_breaker.run()
            
            local me = entity.get_local_player()
            if not me then
                return
            end
            local animlayers = memory.animlayers:get(me)
            if not animlayers then
                return
            end
          
            local leg_air = ui_handler.visuals.on_air_options:get()
            
            if ui_handler.visuals.animation_breaker:get("on ground") and player.onground then
                
                local leg_move = ui_handler.visuals.on_ground_options:get()
                if leg_move == "frozen" then
                    entity.set_prop(me, 'm_flPoseParameter', 1, 0)
                    reference.antiaim.leg_movement:set("Always slide")
                elseif leg_move == "walking" then
                    entity.set_prop(me, 'm_flPoseParameter', 0.5, 7)
                    reference.antiaim.leg_movement:set("Never slide")
                elseif leg_move == "jitter" and player.state == 'move' then
                    entity.set_prop(me, 'm_flPoseParameter', client.random_float(0.65, 1), 0)
                   
                    reference.antiaim.leg_movement:set("Always slide")
                elseif leg_move == 'sliding' and player.state == 'move' then
                    entity.set_prop(me, 'm_flPoseParameter', 0, 9)
                    entity.set_prop(me, 'm_flPoseParameter', 0, 10)
                    reference.antiaim.leg_movement:set("Never slide")
                elseif leg_move == 'star' then
                    entity.set_prop(me, "m_flPoseParameter",1, globals.tickcount() % 4 > 1 and 0.5 / 10 or 1)
                end
            end

            local move_type = entity.get_prop(me, 'm_MoveType')
            if ui_handler.visuals.animation_breaker:get("on air") and not player.onground and not (move_type == 9 or move_type == 8) then
                local air_legs = ui_handler.visuals.on_air_options:get()
                
                if air_legs == 'frozen' then
                    entity.set_prop(me, 'm_flPoseParameter', 1, 6)
                elseif air_legs == 'walking' then
                    local cycle do
                        cycle = globals.realtime() * 0.7 % 2
                        if cycle > 1 then
                            cycle = 1 - (cycle - 1)
                        end
                    end
                    animlayers[6]['weight'] = 1
                    animlayers[6]['cycle'] = cycle
                elseif air_legs == 'kinguru' then
                    
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 6)
                end
            end

            if ui_handler.visuals.animation_breaker:get("sliding slow motion") and reference.antiaim.slowmotion.hotkey:get() then
                entity.set_prop(me, 'm_flPoseParameter', 0, 9)
            end

            if ui_handler.visuals.animation_breaker:get("sliding crouch") and (player.state == 'crouch' or player.state == 'crouch move') then
                entity.set_prop(me, 'm_flPoseParameter', 0, 8)
            end

            if ui_handler.visuals.animation_breaker:get("zero on land")  and memory.animstate:get(me).hit_in_ground_animation and player.onground then
                entity.set_prop(me, 'm_flPoseParameter', 0.5, 12)
            end

            if ui_handler.visuals.animation_breaker:get("earthquake")  then

                animlayers[12]['weight'] = client.random_float(-0.3, 0.75)


            end
            
            

        end

        function visuals.animation_breaker.post(cmd)
            if ui_handler.visuals.animation_breaker:get("quick peek legs") and reference.ragebot.quick_peek.hotkey:get() then
                local me = entity.get_local_player()
                local move_type = entity.get_prop(me, 'm_MoveType')

                if move_type == 2 then
                    local command = memory.user_input:get_command(cmd.command_number)

                    if command then
                        command.buttons = bit.band(command.buttons, bit.bnot(8))
                        command.buttons = bit.band(command.buttons, bit.bnot(16))
                        command.buttons = bit.band(command.buttons, bit.bnot(512))
                        command.buttons = bit.band(command.buttons, bit.bnot(1024))
                    end
                end
            end
        end


        function visuals.finish_command(cmd)
            local me = entity.get_local_player()
            if not me then
                return
            end

            visuals.animation_breaker.post(cmd)
        end

    end

    visuals.sidebar = {} do
        local name = 'universe x ' ..user.name.. '  ♪♫*•♪✦'
        local cache = {}
        for w in string.gmatch(name, '.[\128-\191]*') do
            cache[#cache + 1] = {
                w = w,
                n = 0,
                d = false,
                p = { 0 }
            }
        end

        local function linear(t, d, s)
            t[1] = c_math.clamp(t[1] + (globals.frametime() * s * (d and 1 or -1)), 0, 1)
            return t[1]
        end
        local menu_color = ui.reference("MISC", "Settings", "Menu color")
        function visuals.sidebar.run()
            if not ui.is_menu_open() then
                return
            end
            
            local result = {}
            local sidebar, accent = { 150, 176, 186, 255 }, { ui.get(menu_color) }
            local realtime = globals.realtime()

            for i, v in ipairs(cache) do
                if realtime >= v.n then
                    v.d = not v.d
                    v.n = realtime + client.random_float(1, 3)
                end

                local alpha = linear(v.p, v.d, 1)
                local r, g, b, a = c_math.color_lerp(sidebar[1], sidebar[2], sidebar[3], sidebar[4], accent[1], accent[2],
                    accent[3], accent[4], math.min(alpha + 0.5, 1))

                result[#result + 1] = string.format('\a%02x%02x%02x%02x%s', r, g, b, 200 * alpha + 55, v.w)
            end

            ui_handler.navigation.label:set(table.concat(result))
        end

    end

    visuals.hide_menu = {} do
        function visuals.hide_menu.run()
            local hide = user.name == "admin" and ui_handler.navigation.debug:get()
            ui.set_visible(reference.antiaim.enable.ref,  hide )
            ui.set_visible(reference.antiaim.pitch[1].ref,  hide )
            ui.set_visible(reference.antiaim.pitch[2].ref,  hide )
            ui.set_visible(reference.antiaim.yaw[1].ref,  hide )
            ui.set_visible(reference.antiaim.yaw[2].ref,  hide )
            ui.set_visible(reference.antiaim.base.ref,  hide )
            ui.set_visible(reference.antiaim.jitter[1].ref,  hide )
            ui.set_visible(reference.antiaim.jitter[2].ref,  hide )
            ui.set_visible(reference.antiaim.body[1].ref,  hide )
            ui.set_visible(reference.antiaim.body[2].ref,  hide )
            ui.set_visible(reference.antiaim.edge.ref,  hide )
            ui.set_visible(reference.antiaim.fs_body.ref,  hide )
            ui.set_visible(reference.antiaim.freestand.ref,  hide )
            ui.set_visible(reference.antiaim.freestand.hotkey.ref,  hide )
            ui.set_visible(reference.antiaim.roll.ref,  hide )
        end
    end

    visuals.indicators = {} do
        local indicator_global = c_tweening:new(0)
        local indicator_grenade = c_tweening:new(1.0)
        local smooth_charge = c_tweening:new(0)
        local smooth_state = c_tweening:new(1.0)
        local previous_state = player.state
        local state_name = player.state

        local list = {
            {
                name = "%s",
                format = function()
                    return state_name:upper()
                end,
                active = function()
                    return true
                end,
                color = function(accent, accent_second)
                    return accent:lerp(accent_second, smooth_state())
                end,

                animation = c_tweening:new(0)
            },
            {
                name = "DMG",
                active = function()
                    return reference.ragebot.ovr[1].hotkey:get() and reference.ragebot.ovr[1]:get() 
                end,
                animation = c_tweening:new(0)
            },
   
            {

                name = "DT",
                active = function()
                    return reference.ragebot.double_tap.hotkey:get()
                end,
                color = function(accent)
                    return color.red:lerp(accent, smooth_charge())
                end,
                render_addition = function(pos, accent, ctx)
                    renderer.circle_outline(
                        pos.x + 1,
                        pos.y,
                        accent.r,
                        accent.g,
                        accent.b,
                        255 * ctx,
                        3,
                        180,
                        smooth_charge(),
                        1
                    )
                end,
                offset_x = function(scope)
                    return smooth_charge() * -4 * scope + scope * 1
                end,
                animation = c_tweening:new(0)
            },

            {
                name = "FREESTAND",
                active = function()
                    return ui_handler.anti_aim.freestanding:get()
                end,
                animation = c_tweening:new(0)
            },

            {
                name = "OSAA",
                active = function()
                    return reference.antiaim.onshot.hotkey:get()
                end,
                animation = c_tweening:new(0)
            },

            {
                name = "EDGE",
                active = function()
                    return reference.antiaim.edge:get()
                end,
                animation = c_tweening:new(0)
            },
            {
                name = "BAIM",
                active = function()
                    return reference.ragebot.force_bodyaim:get()
                end,
                animation = c_tweening:new(0)
            },
            {
                name = "SP",
                active = function()
                    return reference.ragebot.force_bodyaim:get()
                end,
                animation = c_tweening:new(0)
            }
        }

        visuals.indicators.states = {
            ['air'] = 'AIRING',
            ['crouch'] = 'CROUCHING',
            ['crouch move'] = 'CROUCHING',
            ['move'] = 'MOVING',
            ['stand'] = 'STANDING',
           
        }

        function visuals.indicators.prerun(global_alpha, grenade_alpha)

            local ctx_alpha = global_alpha * grenade_alpha

            local indicator_offset = ui_handler.visuals.vertical_offset:get()
            local indicator_position = screen_center + vector(0, indicator_offset)
            local scope_animation = smooth_scope()
            local rev_scope_animation = 1 - scope_animation

            local indicator_accent = color(ui_handler.visuals.indicator_color:get())
            local indicator_renewed = color(ui_handler.visuals.renewed_color:get())
            local indicator_label = color.animated_text('universe', 1, indicator_renewed, indicator_accent, ctx_alpha*255)
            local indicator_label_size = vector(renderer.measure_text('b', 'universe'))
          
            
            local scope_offset = indicator_label_size.x * 0.5 * scope_animation + scope_animation * 3

            renderer.text(indicator_position.x + scope_offset - indicator_label_size.x * 0.5, indicator_position.y - indicator_label_size.y * 0.5, 255, 255, 255, ctx_alpha*255, 'b', 0, indicator_label)

            indicator_position = indicator_position + vector(0, indicator_label_size.y - 1)

            --[[
                local bar_centre = { indicator_position.x + scope_offset  -indicator_label_size.x * 0.5  -7, indicator_position.y - indicator_label_size.y*0.7 +3}
    
                local bar_color = indicator_accent

                renderer.gradient(bar_centre[1],bar_centre[2]  , 60, 1, bar_color.r, bar_color.g, bar_color.b, ctx_alpha*255, bar_color.r, bar_color.g, bar_color.b, ctx_alpha*255, true)
                renderer.gradient(bar_centre[1],bar_centre[2] , 1, 10, bar_color.r, bar_color.g, bar_color.b,  ctx_alpha *255,  bar_color.r, bar_color.g, bar_color.b, 0, false)
                renderer.gradient(bar_centre[1] + 59, bar_centre[2], 1, 10,  bar_color.r, bar_color.g, bar_color.b, ctx_alpha *255,   bar_color.r, bar_color.g, bar_color.b, 0, false)
            
            ]]


            for i=1, #list do
                local indicator = list[i]
                local indicator_animation = indicator.animation(0.15, ({indicator.active()})[1] or false)

                if indicator_animation > 0.01 then
                    local indicator_text = indicator.name:format(indicator.format and indicator.format() or '')
                    local indicator_color do
                        if type(indicator.color) == 'table' then
                            --- @type table
                            indicator_color = indicator.color
                        elseif type(indicator.color) == 'function' then
                            indicator_color = indicator.color(indicator_accent, indicator_renewed)
                        else
                            indicator_color = indicator_accent:clone()
                        end
                    end

                    local text_size = vector(renderer.measure_text('-', indicator_text))
                    local _x_offset = indicator.offset_x or 0

                    if type(_x_offset) == 'function' then
                        _x_offset = _x_offset(rev_scope_animation)
                    end

                    local _scope_offset = text_size.x*scope_animation*0.5 + scope_animation * 3

                    renderer.text(indicator_position.x + _scope_offset - text_size.x * 0.5 - 1 + _x_offset, indicator_position.y - text_size.y * 0.5, indicator_color.r, indicator_color.g, indicator_color.b, 255 * indicator_animation*ctx_alpha, '-', 0, indicator_text)

                    if indicator.render_addition then
                        indicator.render_addition(vector(indicator_position.x + text_size.x + _scope_offset + _x_offset, indicator_position.y), indicator_accent, indicator_animation*ctx_alpha)
                    end
                    indicator_position = indicator_position + vector(0, text_size.y) * indicator_animation
                end
            end
        end

        function visuals.indicators.run()
            local me = entity.get_local_player()

            if not entity.is_alive(me)  then
                return 
            end

            local wpn_info = weapons(entity.get_player_weapon(me))
            
            if not wpn_info then
                return 
            end
    
            local is_scoped = entity.get_prop(me, 'm_bIsScoped') == 1
            
            
            smooth_scope(0.1, is_scoped)
            local exploits_charged = player.shifting
            
            smooth_charge(0.1, exploits_charged or false)

            local player_state = visuals.indicators.states[player.state] or player.state


            if previous_state ~= player_state then
                smooth_state(0.15, 1)

                if smooth_state() == 1.0 then
                    state_name = player_state

                    previous_state = player_state
                end
            else
                smooth_state(0.15, 0)
            end
            
            local indicator_state = indicator_global(0.15, ui_handler.visuals.indicators:get())
            
            local grenade_b =  wpn_info == 'grenade' or is_scoped
            local grenade_state = indicator_grenade(0.15, grenade_b and 0.5 or 1.0)
            if indicator_state > 0.01 then
                
                visuals.indicators.prerun(indicator_state, grenade_state)
            
            end

        end


    end        

    visuals.manual_arrows = {} do
        local arrows = {
            main = c_tweening:new(0),
            left = c_tweening:new(0),
            right = c_tweening:new(0)
        }
        visuals.manual_arrows.prerun = function()
            local me = entity.get_local_player() 

            if not entity.is_alive(me)  then
                return 
            end

            local scope_check = smooth_scope() 
            local main = arrows.main(0.15,  ui_handler.visuals.manual_arrows:get() ) *255 
        
            if main < 1 then
                return
            end

            local  left = arrows.left(0.15, anti_aim.features.manual == -90 ) * 255 
            local  right = arrows.right(0.15,  anti_aim.features.manual == 90 ) * 255 
            
            local  manual_offset = ui_handler.visuals.manual_offset:get()
            local  manual_arrows_color = color(ui_handler.visuals.manual_arrows_color:get())
            local  manual_arrows_accent = color(ui_handler.visuals.manual_arrows_accent:get())
            local  base_position_left = vector(screen_center.x , screen_center.y + 10)
       
            renderer.triangle(
            base_position_left.x - (manual_offset + 9),
            base_position_left.y,
            base_position_left.x - manual_offset,
            base_position_left.y - 5, base_position_left.x - manual_offset,
            base_position_left.y + 5,
            manual_arrows_color.r ,
            manual_arrows_color.g ,
            manual_arrows_color.b, 
            left)

            
            renderer.triangle(
            base_position_left.x - (manual_offset + 9),
            base_position_left.y,
            base_position_left.x - manual_offset,
            base_position_left.y - 5, base_position_left.x - manual_offset,
            base_position_left.y + 5,
            manual_arrows_accent.r ,
            manual_arrows_accent.g ,
            manual_arrows_accent.b, 
            75)

            renderer.triangle(
            base_position_left.x + (manual_offset + 9),
            base_position_left.y,
            base_position_left.x + manual_offset,
            base_position_left.y - 5,
            base_position_left.x + manual_offset,
            base_position_left.y + 5,
            manual_arrows_color.r ,
            manual_arrows_color.g ,
            manual_arrows_color.b,
            right)
            renderer.triangle(
            base_position_left.x + (manual_offset + 9),
            base_position_left.y,
            base_position_left.x + manual_offset,
            base_position_left.y - 5,
            base_position_left.x + manual_offset,
            base_position_left.y + 5,
            manual_arrows_accent.r ,
            manual_arrows_accent.g ,
            manual_arrows_accent.b,
            75)

            
        end
    end

    visuals.draw_forced_watermark = function ()

        if ui_handler.visuals.indicators:get() then
            return
        end

        renderer.text(screen_center.x, screen_size.y - 20, 255, 255, 255, 255, 'bc', 0, user.version)
    end
   
    visuals.on_load = {} do
        local alpha = 69
        local toggled = false
        function visuals.on_load.run()
            
            if alpha > 0 and toggled then
                if alpha == 169 then

                end
                alpha = alpha - 0.5
            else
                if not toggled then
                    alpha = alpha + 1
                    if alpha == 254 then
                        toggled = true
                    end
                    alpha = alpha + 1
                end
            end
            if alpha > 1 then

                renderer.gradient(0, 0, screen_size.x, screen_size.y, 0, 0, 0, alpha, 0, 0, 0, alpha, false)

                local mx, my = renderer.measure_text('+', nil, "UNIVERSE")
                local vx, vy = renderer.measure_text('+', nil, '<-DEBUG->')
                renderer.text(screen_size.x / 2 - math.floor(mx / 2), screen_size.y / 2 - my / 2, 255, 255, 255, alpha, '+', 0, "UNIVERSE")
                renderer.text(screen_size.x / 2 - math.floor(vx / 2) + mx / 2 + 10, screen_size.y / 2 - vy / 2 + 30, 255, 105, 105, alpha, '-', 0,
                    '<-' .. string.upper(user.name) .. '->')
            end



        end
    end
end 

local miscellaneous = {} do

    miscellaneous.unsafe_charge = {} do
        local last = false
        local state = false
        local single_fire = {40, 9, 64, 27, 29, 35}
        function miscellaneous.unsafe_charge.prerun()
            local me = entity.get_local_player()
            if not me then
                return
            end
            local wpn =  entity.get_player_weapon(me)

            local tickbase_diff = entity.get_prop(me, 'm_nTickBase') - globals.tickcount()
            local doubletap_active = reference.ragebot.double_tap.hotkey:get() and not reference.ragebot.duck:get()
            local wpn_info = weapons(wpn)

            local last_shot_time = entity.get_prop(wpn, 'm_fLastShotTime')

            if not last_shot_time then
                return
            end


            if not wpn_info then
                return
            end


            if not doubletap_active then
                return
            end
          
            local single_fire_weapon = c_math.contains(single_fire, wpn_info.idx)
            local value = single_fire_weapon and 1.50 or 0.50
            local in_attack = globals.curtime() - last_shot_time <= value
            local threat = client.current_threat()

            if threat and not player.shifting and not player.onground and bit.band(entity.get_esp_data(threat).flags, 2048) == 2048 then
                reference.ragebot.enabled.hotkey:set("On Hotkey", 0)
            else
                reference.ragebot.enabled.hotkey:set("Always On", 0)
             
            end
    

            return true

        end
        function miscellaneous.unsafe_charge.run(cmd)
            if not ui_handler.misc.unsafe_charge:get() then
                return
            end
            if not miscellaneous.unsafe_charge.prerun() then
                reference.ragebot.enabled.hotkey:set("Always On", 0)
            end
        
        end

     

        ui_handler.misc.unsafe_charge:set_callback(function(self)
            if self.value then
                -- block empty
            elseif state ~= nil then
               
                reference.ragebot.enabled.hotkey:set("Always On", 0)
                state = nil
            end
        end)

    end

    miscellaneous.fix_onshot = {} do
        function miscellaneous.fix_onshot.run()
            if ui_handler.misc.fix_hideshot:get() then
                reference.fakelag.enable[1]:set(not reference.antiaim.onshot.hotkey:get())
            end
        end
    end

    miscellaneous.clantag = {} do
        local build = function(str)
            local tag = { ' ', ' ', ' ' }
            local prev_tag = ''

            for i = 1, #str do
                local char = str:sub(i, i)
                prev_tag = prev_tag:lower() .. char:upper()
                tag[i] = prev_tag
            end

            tag[#tag + 1] = str

            for i = #tag, 1, -1 do
                table.insert(tag, tag[i])
            end

            tag[#tag + 1] = ' '
            tag[#tag + 1] = ' '
            tag[#tag + 1] = ' '

            return tag
        end
        
        local once, old_time = false, 0

        function miscellaneous.clantag ()
            if not ui_handler.misc.clantag:get() then
                return
            end
            local tag = build("universe ")
            once = false
            local curtime = math.floor(globals.curtime() * 4.5)
            if old_time ~= curtime then
                client.set_clan_tag(tag[curtime % #tag + 1])
            end
            old_time = curtime
            reference.misc.clantag:set(false)
        end
    end

    miscellaneous.custom_output = {} do
        local list = {}
        local lucida = surface.create_font('Lucida Console', 10, 400, 128)
        miscellaneous.custom_output.paint_ui = function (ctx)
            if #list == 0 then
                return
            end

            local hs = select(2, surface.get_text_size(lucida , 'A'))
            local x, y, size = 8, 5, hs

            for i=1, #list do
                local notify = list[i]

                if notify then
                    notify.m_time = notify.m_time - globals.frametime()

                    if notify.m_time <= 0.0 then
                        table.remove(list, i)
                    end
                end
            end

            if #list == 0 then
                return
            end

            while #list > 8 do
                table.remove(list, 1)
            end

            for i=1, #list do
                local notify = list[i]
                local left = notify.m_time
                local ncolor = notify.m_color

                if left < 0.5 then
                    local fl = c_math.clamp(left, 0.0, 0.5)

                    ncolor.a = fl * 255.0

                    if i == 1 and fl < 0.2 then
                        y = y - size * (1.0 - fl * 5)
                    end
                else
                    ncolor.a = 255
                end

                local txt = notify.m_text
                local slist = color.string_to_color_array(string.format('\a%s%s', ncolor:to_hex(), txt))

                local w_o = 0

                for j=1, #slist do
                    local obj = slist[j]

                    obj.text = obj.text:gsub('\1', '')

                    local this_w = surface.get_text_size(lucida, obj.text)

                    surface.draw_text(x + w_o, y, obj.color.r, obj.color.g, obj.color.b, ncolor.a, lucida, obj.text)

                    w_o = w_o + this_w
                end

                y = y + size
            end
            
        end
        local skip_line

        function miscellaneous.custom_output.output(output)
            local text_to_draw = output.text

            local clr = color(output.r, output.g, output.b, output.a)

            if text_to_draw:find('\0') then
                text_to_draw = text_to_draw:sub(1, #text_to_draw-1)
            end

            if skip_line then
                if list[#list] then
                    list[#list].m_text = string.format('%s%s', list[#list].m_text, string.format('\a%s%s', clr:to_hex(), text_to_draw))
                else
                    list[#list+1] = {
                        m_text = text_to_draw,
                        m_color = clr,
                        m_time = 8.0
                    }
                end

                skip_line = false
            else
                for str in text_to_draw:gmatch('([^\n]+)') do
                    list[#list+1] = {
                        m_text = str,
                        m_color = clr,
                        m_time = 8.0
                    }
                end
            end

            local has_ignore_newline = output.text:find('\0')

            if has_ignore_newline ~= nil then
                skip_line = true
            end
        end    
        function miscellaneous.output_raw(output)
            miscellaneous.custom_output.output(output)
        end
        ui_handler.misc.custom_output:set_callback(function (self)
            local enabled = self.value
            
            if enabled and not miscellaneous._output_set then
                client.set_event_callback('output', miscellaneous.output_raw)

                miscellaneous._output_set = true
            elseif not enabled and miscellaneous._output_set then
                client.unset_event_callback('output', miscellaneous.output_raw)

                miscellaneous._output_set = false
            end

            if enabled then
                reference.misc.draw_output:set(false)
            else
                reference.misc.draw_output:set(true)
            end
        end)
    end

    miscellaneous.event_logger = {} do
        local cache = {}
        local hitgroups = {
            'body',
            'head',
            'chest',
            'stomach',
            'left arm',
            'right arm',
            'left leg',
            'right leg',
            'neck',
            '?',
            'gear'
        }
        function miscellaneous.event_logger.aim_fire(event)
            local this = {
                tick = event.tick,
                timestamp = client.timestamp(),
                wanted_damage = event.damage,
                wanted_hit_chance = event.hit_chance,
                wanted_hitgroup = event.hitgroup
            }

            cache[event.id] = this
        end

        function miscellaneous.event_logger.aim_hit(event)
            local cached = cache[event.id]

            if not cached then
                return
            end

            local options = {}

            local backtrack = globals.tickcount() - cached.tick

            if backtrack ~= 0 then
                options[#options+1] = string.format('bt: %d tick%s (%i ms)', backtrack, math.abs(backtrack) == 1 and '' or 's', math.round(backtrack*globals.tickinterval()*1000))
            end

            local register_delay = client.timestamp() - cached.timestamp

            if register_delay ~= 0 then
                options[#options+1] = string.format('delay: %i ms', register_delay)
            end

            local name = entity.get_player_name(event.target)
            local hitgroup = hitgroups[event.hitgroup + 1] or '?'
            local target_hitgroup = hitgroups[cached.wanted_hitgroup + 1] or '?'
            local damage = event.damage
            local health = entity.get_prop(event.target, 'm_iHealth')
            local hit_chance = event.hit_chance
            local logger_text = string.format('Hit %s\'s %s for %d%s damage (%s, %d remaining%s)',
                name,
                hitgroup,
                tonumber(damage),
                cached.wanted_damage ~= damage and string.format('(%d)', cached.wanted_damage) or '',
                target_hitgroup ~= hitgroup and string.format('aimed: %s(%d%%)', target_hitgroup, hit_chance) or string.format('th: %d%%', hit_chance),
                health,
                #options > 0 and string.format(', %s', table.concat(options, ', ')) or ''
            )

            if ui_handler.misc.event_logger:get() then
                print(logger_text)
            end
        end

        function miscellaneous.event_logger.aim_miss(event)
            local cached = cache[event.id]

            if not cached then
                return
            end

            local options = {}

            local backtrack = globals.tickcount() - cached.tick

            if backtrack ~= 0 then
                --options[#options+1] = string.format('bt: %d tick%s (%i ms)', backtrack, math.abs(backtrack) == 1 and '' or 's', math.round(backtrack*globals.tickinterval()*1000))
            end

            local register_delay = client.timestamp() - cached.timestamp

            if register_delay ~= 0 then
                options[#options+1] = string.format('delay: %i ms', register_delay)
            end

            local name = entity.get_player_name(event.target)
            local hitgroup = hitgroups[event.hitgroup + 1] or '?'
            local reason = event.reason
            local damage = cached.wanted_damage
            local hit_chance = event.hit_chance
            local logger_text = string.format('Missed %s\'s %s due to %s (td: %d, th: %d%%%s)',
                name,
                hitgroup,
                reason,
                tonumber(damage),
                hit_chance,
                #options > 0 and string.format(', %s', table.concat(options, ', ')) or ''
            )

            if ui_handler.misc.event_logger:get() then
                print(logger_text)
            end
        end

        local hurt_weapons = {
            ['knife'] = 'Knifed';
            ['hegrenade'] = 'Naded';
            ['inferno'] = 'Burned';
        }

        function miscellaneous.event_logger.player_hurt(event)
            local attacker = client.userid_to_entindex(event.attacker)

            if not attacker or attacker ~= entity.get_local_player() then
                return
            end

            local target = client.userid_to_entindex(event.userid)

            if not target then
                return
            end

            local wpn_type = hurt_weapons[event.weapon]

            if not wpn_type then
                return
            end

            local name = entity.get_player_name(target)
            local damage = event.dmg_health

            local logger_text = string.format('%s %s for %d damage',
                wpn_type,
                name,
                tonumber(damage)
            )

            if ui_handler.misc.event_logger:get() then
                print(logger_text)
            end
        end

    end
    
    miscellaneous.trashtalk = {} do
        local counter = 0

        local list = {
            ['head'] = {
                "你的aa比薯片脆",
                "实在不行你去买个模型吧",
                "你的脑子只适合玩原神?",
                "滚去玩王者荣耀吧窝囊废",
                "你是没有手吗?",
                "你的脑容量比你参群人数还少",
                "银行卡密码都被我骗出来了",
                "农村人滚回去种地",
                "你怎么一骗就出了孩子",
                "你在屏幕前红温的样子被我记录下来了",
                "我杀你只需要一根手指",
                "ez",
                "这就死了吗...我都还没开始发力",
                "我没想到你参数这么垃圾...",
                "杀你只需要一根手指",
                "1",
                "1，你怎么这么菜...",
                "你在用otc么废物?",
                "easy xD",
                "1,别急",
                "农民你被你爹1了，滚去买个好点的参数吧",
                "你也被脑控了吗",
             },
            ['body'] = {
                '你生气了吗？ /我刚刚break lagcomp',
                '我有一个很棒的LUA',
                '我怎么对你撒尿了/弱尿',
                '？ 你是什么品种的狗？',
                '你滚到哪里去了',
                '这个脑残对着爸爸的鸡鸡发牢骚',
                '嗯,天真/傻逼',
                '对我来说你就想BOT了',
                '下次你会更聪明的',
                '你确定能杀死我吗？'
            },
            ['taser'] = {
                '嗯，天真',
                'alt+f4',
                '机器人'
            },
            ['inferno'] = {
                '在地狱中燃烧',
                '你这个脑残被炸了',
                '地狱火？玩王者荣耀呢？'
            },
            ['hegrenade'] = {
                '傻逼被炸毁了',
                '飞回你妈妈身边',
            },
            ['death'] = {
                'xx克高手',
                'Lucky',
                '这场比赛只有运气',
                '这家伙给我打了个混蛋',
                '1，你终于给我杀了',
                '很好',
                '服务器很便宜/但同性恋在这里开枪',
                '脑残又开始傻逼克高手了',
                '呃/混蛋你又做了什么',
            },
            ['revenge'] = {
                '1.'
            }

        }
        local active = false
        local attacker_index = -1

        function miscellaneous.trashtalk.run(type)
            if not ui_handler.misc.chat_spammre:get() then
                return
            end

            local game_rules = entity.get_game_rules()
            local is_warmup = entity.get_prop(game_rules, 'm_bWarmupPeriod') == 1

            if is_warmup then
                return
            end

            local phrase_list = list[type]

            if not phrase_list or active then
                return
            end

            local delay = 0
            local phrase = phrase_list[counter % #phrase_list + 1]
            local active_pool = c_math.split(phrase, ' / ')

            active = true

            for i=1, #active_pool do
                local phrase_piece = active_pool[i]
                local size = phrase_piece:len()
                local new_delay = delay + size * 0.07

                client.delay_call(new_delay, function ()
                    client.exec(string.format('say "%s";', phrase_piece))

                    if i == #active_pool then
                        active = false
                    end
                end)

                delay = new_delay
            end

            counter = counter + 1
        end

        function miscellaneous.trashtalk:on_kill(event)
            if not ui_handler.misc.chat_spammre:get() then
                return
            end

            if list[event.weapon] then
                miscellaneous.trashtalk.run(event.weapon)
            else
                miscellaneous.trashtalk.run(event.headshot and 'head' or 'body')
            end
        end

        function miscellaneous.trashtalk:on_death(event)
            miscellaneous.trashtalk.run('death')
        end

        function miscellaneous.trashtalk:on_player_death(event)
            if event.userid == attacker_index then
                miscellaneous.trashtalk.run('revenge')
                attacker_index = -1
            end
        end
        
        function miscellaneous.trashtalk.player_death(event)
            local attacker = client.userid_to_entindex(event.attacker)
            local userid = client.userid_to_entindex(event.userid)
            local me = entity.get_local_player()
            if not attacker or not userid then
                return
            end

            if attacker == me then
                if userid ~= me then
                    miscellaneous.trashtalk:on_kill(event)
                end
            elseif userid == me then
                miscellaneous.trashtalk:on_death(event)
            else
                miscellaneous.trashtalk:on_player_death(event)
            end
        end


    end

    miscellaneous.auto_hideshots = {} do
        local ovr = false
        local latest = false
        function miscellaneous.auto_hideshots.run(cmd)
            if  not  ui_handler.misc.auto_hideshots:get() then
                return
            end
            local me = entity.get_local_player()
            if not me  then
                return
            end
            local weapon = entity.get_player_weapon(me) 
            local weapon_t = weapon and weapons(weapon)
            local is_dt, is_os = reference.ragebot.double_tap.hotkey:get(), reference.antiaim.onshot.hotkey:get()
            local is_peeking = reference.ragebot.quick_peek:get() and reference.ragebot.quick_peek.hotkey:get()

            local can_teleport = not ( player.crouching)
            local can_dt = false
            
            if weapon_t then
                local weapon_id = entity.get_prop(weapon, "m_iItemDefinitionIndex")
                
                local weapon_auto = weapon_t.is_full_auto
                local is_deagle = weapon_id == 1
    
                can_dt = weapon_auto
                
                if ( (weapon_t.weapon_type_int == 1 and not is_deagle) and not ui_handler.misc.auto_hideshots_wpns:get ("Pistols") )
                or ( is_deagle and not ui_handler.misc.auto_hideshots_wpns:get ("Desert Eagle") ) then
                    can_dt = true
                end
            end

            local allow = player.onground and is_dt and not (can_dt or can_teleport)

            if allow then
                reference.ragebot.double_tap:override(false)
                reference.antiaim.onshot.hotkey:override({"Always on", 0})
                ovr = true
            else
                if ovr then
                    reference.ragebot.double_tap:override(true)
                    reference.antiaim.onshot.hotkey:override()
                    ovr = false
                end
            end
        end

        ui_handler.misc.auto_hideshots:set_callback(function (this)
            if not this.value then
                reference.ragebot.double_tap:override()
                reference.antiaim.onshot.hotkey:override()
            end
        end)
    end

    miscellaneous.peekfix = {} do
        function miscellaneous.peekfix.run(cmd)
            if not ui_handler.misc.peekfix:get() then
                return
            end
            if player.is_fs_peek then
                cmd.force_defensive = true
            end
        end 
    end

    ui_handler.misc.filter:set_callback(function(self)
        cvar.con_filter_text:set_string('[gamesense]')
        cvar.con_filter_enable:set_raw_int(self.value and 1 or 0)
    end, true)

    defer(function()
        cvar.con_filter_enable:set_raw_int(tonumber(cvar.con_filter_enable:get_string()))
    end)

end

local callbacks = {} do
    function callbacks.start()
        client.color_log(108, 181, 119, '[universe] \1\0')
        client.color_log(61, 212, 197, ('[%02d:%02d:%02d] \1\0'):format(client.system_time()))
        client.color_log(255, 255, 255, ('Welcome back, %s!'):format(user.name))
    end

    callbacks.start()

    function callbacks.predict_command(cmd)
        player.predict_command(cmd)
    end

    function callbacks.paint(ctx)
        visuals.indicators.run()
        visuals.manual_arrows.prerun()
        visuals.draw_forced_watermark()
    end

    function callbacks.paint_ui()
        visuals.hide_menu.run()
        visuals.sidebar.run()
        miscellaneous.custom_output.paint_ui()
        visuals.on_load.run()
    end

    function callbacks.net_update_end() 
        miscellaneous.clantag()


    end

    function callbacks.setup_command(cmd)
        player.setup_command(cmd)
        miscellaneous.peekfix.run(cmd)
        miscellaneous.unsafe_charge.run(cmd)
        miscellaneous.auto_hideshots.run(cmd)
        anti_aim.features.main(cmd)
        anti_aim.builder.main(cmd)
        miscellaneous.fix_onshot.run()
        if ui_handler.visuals.on_ground_options:get() == 'star' and ui_handler.visuals.animation_breaker:get("on ground") then
            reference.antiaim.leg_movement:set(cmd.command_number % 3 == 0 and "Off" or "Always slide")
        end
    end

    function callbacks.aim_fire(event)
        miscellaneous.event_logger.aim_fire(event)
    end

    function callbacks.aim_hit(event)
        miscellaneous.event_logger.aim_hit(event)
    end

    function callbacks.aim_miss(event)
        miscellaneous.event_logger.aim_miss(event)
    end

    function callbacks.player_hurt(event)
        miscellaneous.event_logger.player_hurt(event)
    end
    function callbacks.player_death(event)
        miscellaneous.trashtalk.player_death(event)
    end

end

client.set_event_callback('aim_fire', callbacks.aim_fire)
client.set_event_callback('aim_hit', callbacks.aim_hit)
client.set_event_callback('aim_miss', callbacks.aim_miss)
client.set_event_callback('player_hurt', callbacks.player_hurt)
client.set_event_callback('player_death', callbacks.player_death)
client.set_event_callback("net_update_end", callbacks.net_update_end)
client.set_event_callback("paint_ui", callbacks.paint_ui)
client.set_event_callback("paint", callbacks.paint)
client.set_event_callback('finish_command', visuals.finish_command)
client.set_event_callback('setup_command', callbacks.setup_command)
client.set_event_callback("pre_render", visuals.animation_breaker.run)
client.set_event_callback('predict_command', callbacks.predict_command)







