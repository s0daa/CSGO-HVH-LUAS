-- downloaded from dsc.gg/southwestcfgs

if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
end

local timer = client.timestamp()

local C = function (t) local c = {} if type(t) ~= "table" then return t end for k, v in next, t do c[k] = v end return c end

local table, math, string = C(table), C(math), C(string)
local ui, client, database, entity, ffi, globals, panorama, renderer = C(ui), C(client), C(database), C(entity), C(require "ffi"), C(globals), C(panorama), C(renderer)

local vector = require 'vector'
local pui = require 'gamesense/pui'
local base64 = require 'gamesense/base64'
local c_entity = require 'gamesense/entity'
local c_weapon = require 'gamesense/csgo_weapons'
local msgpack = require 'gamesense/msgpack'
local http = require 'gamesense/http'
local md5 = require 'gamesense/md5'

local f = string.format


username = 'mishkat'

local defines = {
    user = 'mishkat',
    build = 'source',

    screen = vector(client.screen_size()),
    screen_center = vector(client.screen_size()) / 2,

    accent = { 192, 168, 255, 255 },
    online = 999,

    conditions = { 'Global', 'Stand', 'Move', 'Slow Walk', 'Air', 'Air Crouch', 'Crouch', 'Using', 'Fake Lag' },

    functions = {
        legit = false,
        manual = false,
        backstab = false,
        safe = false
    }
}

local db do
    db = { }

    setmetatable(db, {
        __index = function (self, key)
            return database.read(key)
        end,

        __newindex = function (self, key, value)
            return database.write(key, value)
        end
    })
end

local utilities do
    utilities = { }

    function utilities.contains(tbl, key)
        local state = false
        for i, item in next, tbl do
            if item == key then
                state = true
                break
            end
        end

        return state
    end

    function utilities.normalize(yaw)
        return (yaw + 180) % -360 + 180
    end

    local sv_gravity = cvar.sv_gravity
    function utilities.extrapolate(ent, pos)
        local tick_interval = globals.tickinterval()

        local velocity = vector(entity.get_prop(ent, "m_vecVelocity"))
        local new_pos = pos:clone()

        local ticks = 16
        if #velocity < 32 then
            ticks = 32
        end

        new_pos.x = new_pos.x + velocity.x * tick_interval * ticks
        new_pos.y = new_pos.y + velocity.y * tick_interval * ticks

        if entity.get_prop(ent, "m_hGroundEntity") == nil then
            new_pos.z = new_pos.z + velocity.z * tick_interval * ticks - sv_gravity:get_float() * tick_interval
        end

        return new_pos
    end

    function utilities.lerp(a, b, t)
        return a + t * (b - a)
    end

    function utilities.extended_lerp(start, end_pos, time, delta)
        if math.abs(start - end_pos) < (delta or 0.01) then
            return end_pos
        end

        time = globals.frametime() * (time * 175)
        if time < 0 then
            time = 0.01
        elseif time > 1 then
            time = 1
        end

        return (end_pos - start) * time + start
    end

    function utilities.color_lerp(r1, g1, b1, a1, r2, g2, b2, a2, t)
        local r = utilities.lerp(r1, r2, t)
        local g = utilities.lerp(g1, g2, t)
        local b = utilities.lerp(b1, b2, t)
        local a = utilities.lerp(a1, a2, t)

        return r, g, b, a
    end

    function utilities.strip(str)
        while str:sub(1, 1) == ' ' do
            str = str:sub(2)
        end

        while str:sub(#str, #str) == ' ' do
            str = str:sub(1, #str - 1)
        end

        if #str == 0 or str == '' then
            str = string.format('%s ~ %s', defines.user, 'Config')
        end

        return str
    end

    function utilities.get_eye_position(ent)
        local x1, y1, z1 = entity.get_origin(ent)
        if x1 == nil then return end

        local x2, y2, z2 = entity.get_prop(ent, "m_vecViewOffset")
        if x2 == nil then return end

        return x1 + x2, y1 + y2, z1 + z2
    end

    function utilities.clamp(value, min, max)
        if value < min then
            return min
        elseif value > max then
            return max
        else
            return value
        end
    end

    function utilities.breathe(offset, multiplier)
        local speed = globals.realtime() * (multiplier or 1.0)
        local factor = speed % math.pi

        local sin = math.sin(factor + (offset or 0))
        local abs = math.abs(sin)

        return abs
    end

    function utilities.table_convert(tbl)
        if tbl == nil then
            return { }
        end

        local final = { }

        for i = 1, #tbl do
            final[ tbl[i] ] = true
        end

        return final
    end

    function utilities.table_invert(tbl)
        if tbl == nil then
            return { }
        end

        local final = { }

        for name, enabled in next, tbl do
            if enabled then
                final[ #final + 1 ] = name
            end
        end

        return final
    end

    function utilities.to_hex(r, g, b, a)
        return f('%02x%02x%02x%02x', r, g, b, a or 255)
    end

    function utilities.to_rgb(hex)
        hex = hex:gsub('#', '')
        return tonumber('0x' .. hex:sub(1, 2)), tonumber('0x' .. hex:sub(3, 4)), tonumber('0x' .. hex:sub(5, 6))
    end

    function utilities.format(str, r, g, b, a)
        if type(str) ~= 'string' then
            return str
        end

        str = string.gsub(str, '[\v\r\f]', {
            ['\v'] = r and '\a' .. utilities.to_hex(r, g, b, a) or '\a' .. pui.accent,
            ['\r'] = r and '\aFFFFFFFF' or '\aCDCDCDFF',
            ['\f'] = '\aFF5065FF'
        })

        return str
    end

    function utilities.gradient(str, r, g, b, a, r1, g1, b1, a1, speed)
        local i = 0
        local n = 1 / (#str:gsub('[\128-\191]', '') - 1)

        local out = str:gsub('(.[\128-\191]*)', function(char)
            local factor = utilities.breathe(i, speed)
            local r, g, b, a = utilities.color_lerp(r, g, b, a, r1, g1, b1, a1, factor)

            i = i + n
            return f('\a%s%s', utilities.to_hex(r, g, b, a), char)
        end)

        return out
    end

    function utilities.clean_up(str)
        local text = str:gsub('(\a%x%x%x%x%x%x)%x%x', '%1')
        return text
    end

    function utilities.alpha_modulate(str, alpha)
        local result = string.gsub(str, '\a(%x%x%x%x%x%x)(%x%x)', function(rgb, a)
            return f('\a%s%02x', rgb, tonumber(a, 16) * alpha)
        end)

        return result
    end
end

local printc do
	printc = function (...)
		for i, v in ipairs{...} do
			local r = '\aD9D9D9' .. v
			for col, text in r:gmatch('\a(%x%x%x%x%x%x)([^\a]*)') do
                local r, g, b = utilities.to_rgb(col)
				client.color_log(r, g, b, string.format('%s\0', text))
			end
            client.color_log(255, 255, 255, '\n\0')
		end
	end
end

local print_format do
    print_format = function (...)
        return printc(utilities.clean_up(utilities.format(f(...))))
    end
end

local lp_info do
    lp_info = {
        flags = 0,
        movetype = 0,
        velocity = 0,
        air = false,
        is_moving = false,
        on_ground = false,
        ducking = false,
        landing = false,
        choking = 1,
        body_yaw = 0,
        inverted = false,
        chokes = 0,
        condition = 'Stand'
    }
end

local clipboard do
    clipboard = { }

    local GetClipboardTextCount = vtable_bind('vgui2.dll', 'VGUI_System010', 7, 'int(__thiscall*)(void*)')
    local SetClipboardText = vtable_bind('vgui2.dll', 'VGUI_System010', 9, 'void(__thiscall*)(void*, const char*, int)')
    local GetClipboardText = vtable_bind('vgui2.dll', 'VGUI_System010', 11, 'int(__thiscall*)(void*, int, const char*, int)')

    local function set(...)
        local text = tostring(table.concat({ ... }))

        SetClipboardText(text, string.len(text))
    end

    local function get()
        local len = GetClipboardTextCount()

        if len > 0 then
            local char_arr = ffi.typeof('char[?]')(len)
            GetClipboardText(0, char_arr, len)
            local text = ffi.string(char_arr, len - 1)

            local text_end do
                text_end = text:find('_exscord')

                if text_end then
                    text = text:sub(1, text_end)
                end
            end

            return text
        end
    end

    clipboard.set = set
    clipboard.get = get
end

local callbacks do
    callbacks = { }


    local stored_data = { }
    local function set_callback_data(callback)
        if stored_data[callback] == nil then
            stored_data[callback] = {
                local_player = nil,
                is_valid = nil
            }

            client.set_event_callback(callback, function (ctx)
                local this = stored_data[callback]

                this.local_player = entity.get_local_player()
                this.is_valid = this.local_player ~= nil and entity.is_alive(this.local_player)
            end)

            return stored_data[callback]
        end

        return stored_data[callback]
    end

    local events_mt = {
        __index = function (self, index)

            local methods = {
                set = function (_self, fun)
                    local data = set_callback_data(index)

                    local callback
                        callback = function (ctx)
                            if ctx == nil then
                                return fun(data.local_player, data.is_valid)
                            else
                                return fun(ctx, data.local_player, data.is_valid)
                            end
                        end

                    client.set_event_callback(index, callback)
                end
            }

            return methods
        end,

        __tostring = function (self)
            return self.name
        end
    }

    local data = { }
    local function get_callback(name)
        if data[name] == nil then
            data[name] = setmetatable({ name = name }, events_mt)
        end

        return data[name]
    end

    local mt = {
        __index = function (self, name)
            return get_callback(name)
        end
    }

    setmetatable(callbacks, mt)
end

local reference do
    reference = { }

    reference.AA = { }

    reference.logging = {
        spread = pui.reference('Rage', 'Other', 'Log misses due to spread'),
        damage = pui.reference('Misc', 'Miscellaneous', 'Log damage dealt'),
        purchases = pui.reference('Misc', 'Miscellaneous', 'Log weapon purchases')
    }

    reference.AA.angles = {
        enabled = { pui.reference('AA', 'Anti-aimbot angles', 'Enabled') },
        pitch =  { pui.reference('AA', 'Anti-aimbot angles', 'Pitch') },
        yaw_base = { pui.reference('AA', 'Anti-aimbot angles', 'Yaw Base') },
        yaw = { pui.reference('AA', 'Anti-aimbot angles', 'Yaw') },
        body_yaw = { pui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
        yaw_modifier = { pui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
        freestanding = { pui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
        freestanding_byaw = { pui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw') },
        edge_yaw = { pui.reference('AA', 'Anti-aimbot angles', 'Edge yaw') },
        roll = { pui.reference('AA', 'Anti-aimbot angles', 'Roll') }
    }

    reference.AA.other = {
        leg_movement = pui.reference('AA', 'Other', 'Leg movement')
    }

    reference.AA.fakelag = {
        enabled = { pui.reference('AA', 'Fake lag', 'Enabled') },
        amount = pui.reference('AA', 'Fake lag', 'Amount'),
        variance = pui.reference('AA', 'Fake lag', 'Variance'),
        limit = pui.reference('AA', 'Fake lag', 'Limit')
    }

    reference.RAGE = {
        enabled = pui.reference('Rage', 'Aimbot', 'Enabled'),
        hitchance = pui.reference('Rage', 'Aimbot', 'Minimum hit chance'),
        autoscope = pui.reference('Rage', 'Aimbot', 'Automatic scope'),
        min_damage = pui.reference('RAGE', 'Aimbot', 'Minimum damage'),
        damage_override = { pui.reference('RAGE', 'Aimbot', 'Minimum damage override') },
        force_safe_point = pui.reference('RAGE', 'Aimbot', 'Force safe point'),
        force_body_aim = pui.reference('RAGE', 'Aimbot', 'Force body aim'),
        double_tap = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
        hide_shots = { ui.reference('AA', 'Other', 'On shot anti-aim') },
        autopeek = { pui.reference('RAGE', 'Other', 'Quick peek assist') },
        fakeduck = pui.reference('RAGE', 'Other', 'Duck peek assist'),
        slowwalk = { ui.reference('AA', 'Other', 'Slow motion') }
    }

    reference.MISC = {
        clantag = pui.reference('Misc', 'Miscellaneous', 'Clan tag spammer'),
        ticks = pui.reference("Misc", "Settings", "sv_maxusrcmdprocessticks2"),
        color = pui.reference('Misc', 'Settings', 'Menu color')
    }

    function reference.is_doubletap()
        return ui.get(reference.RAGE.double_tap[1]) and ui.get(reference.RAGE.double_tap[2])
    end

    function reference.is_slowwalk()
        return ui.get(reference.RAGE.slowwalk[1]) and ui.get(reference.RAGE.slowwalk[2])
    end

    function reference.is_freestanding()
        local is_active = reference.AA.angles.freestanding[1]:get_hotkey()
        return is_active and reference.AA.angles.freestanding[1]:get()
    end

    function reference.is_mindamage_override()
        return reference.RAGE.damage_override[1]:get() and reference.RAGE.damage_override[1]:get_hotkey()
    end

    function reference.get_damage()
        if reference.is_mindamage_override() then
            return reference.RAGE.damage_override[2]:get()
        end

        return reference.RAGE.min_damage:get()
    end
end

local anti_aim do
    anti_aim = { }
    local all = { }

    local references = reference.AA.angles

    local override_values = { }
    local push_refs = { } do
        for name, ref in next, references do
            local is_table = type(ref) == 'table'

            push_refs[name] = is_table

            if is_table then
                override_values[name] = { }

                for subname, _ in next, ref  do
                    override_values[name][subname] = { 0, -1 }
                end
            else
                override_values[name] = { 0, -1 }
            end
        end
    end

    local highest_layer_overriden = -1

    local methods = {
        run = function (self)
            highest_layer_overriden = math.max(self.layer, highest_layer_overriden)

            for name, value in next, self.overrides do
                local this = override_values[name]

                if push_refs[name] then
                    for subname, subvalue in next, value do
                        if subname ~= '__mt' then
                            if this[subname][2] <= self.layer then
                                this[subname][1] = subvalue
                                this[subname][2] = self.layer
                            end
                        end
                    end
                else
                    this[1] = value
                    this[2] = self.layer
                end
            end
        end,

        tick = function (self)
            self.overrides = { }
        end
    }

    local mt = { }
    mt.__newindex = function (self, idx, value)
        if push_refs[idx] ~= nil then
            if not push_refs[idx] then
                self.overrides[idx] = value
            end
        else
            print('[Anti Aim] Failed to index', idx)
        end
    end

    mt.__index = function (self, idx)
        if methods[idx] then
            return methods[idx]
        end

        if push_refs[idx] ~= nil then
            if push_refs[idx] then
                if self.overrides[idx] == nil then
                    self.overrides[idx] = { }

                    self.overrides[idx].__mt = setmetatable({ }, {
                        __newindex = function (_, i, value)
                            self.overrides[idx][i] = value
                        end
                    })
                end

                return self.overrides[idx].__mt
            end
        else
            print('[Anti Aim] Failed to index', idx)
        end
    end

    local used_layers = { }
    function anti_aim.new(name, layer)
        assert(all[name] == nil, 'aa name already used')
        assert(used_layers[layer] == nil, 'aa layer already used')

        used_layers[layer] = true

        all[name] = {
            name  = name,
            layer = layer,

            overrides = { }
        }

        return setmetatable(all[name], mt)
    end

    function anti_aim.on_cm()
        for name, reference in next, references do
            if type(reference) == 'table' then
                for subname, subreference in next, reference do
                    --subreference:override()
                end
            else
                reference:override()
            end
        end

        for name, override in next, override_values do
            if push_refs[name] then
                for subname, suboverride in next, override do
                    if suboverride[2] ~= -1 then
                        references[name][subname]:override(suboverride[1])
                        suboverride[2] = -1
                    else
                        references[name][subname]:override()
                    end
                end
            else
                if override[2] ~= -1 then
                    references[name]:override(override[1])
                    override[2] = -1
                else
                    references[name]:override()
                end
            end
        end

        highest_layer_overriden = -1
    end

    function anti_aim.condition(ignore_fl)
        local is_duck = lp_info.ducking or reference.RAGE.fakeduck:get()

        local fakelag = ignore_fl and not (ui.get(reference.RAGE.double_tap[2]) or ui.get(reference.RAGE.hide_shots[2]))

        if fakelag and not defines.functions.legit then
            return defines.conditions[ 9 ]
        end

        if defines.functions.legit then
            return defines.conditions[ 8 ]
        end

        if lp_info.air then
            return defines.conditions [ is_duck and 6 or 5 ]
        end

        if is_duck then
            return defines.conditions[ 7 ]
        end

        if lp_info.velocity > 2 then
            return defines.conditions[ reference.is_slowwalk() and 4 or 3 ]
        end

        return defines.conditions[ 2 ]
    end
end

local tweening do
    tweening = { }

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

    local mt = { } do
        local function update(self, duration, target, easings_fn)
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

            return self.value
        end

        mt.__metatable = false
        mt.__call = update
        mt.__index = mt
    end

    function tweening.new(default, easings_fn)
        if type(default) == 'boolean' then
            default = default and 1 or 0
        end

        local this = { }

        this.clock = 0
        this.value = default or 0

        this.easings = easings_fn or function(t, b, c, d)
            return c * t / d + b
        end

        return setmetatable(this, mt)
    end
end

local exploit do
    exploit = { }

    local LAG_COMPENSATION_TELEPORTED_DISTANCE_SQR = 64 * 64

    local data = {
        old_origin = vector(),
        old_simtime = 0.0,

        shift = false,
        breaking_lc = false,
        defensive_tick = 0,

        defensive = {
            begin = 0,
            duration = 0
        },

        lagcompensation = {
            distance = 0.0,
            teleport = false
        }
    }

    local function update_tickbase(me)
        local tickcount = globals.tickcount()
        local m_nTickBase = entity.get_prop(me, "m_nTickBase")

        data.shift = tickcount > m_nTickBase
    end

    local function update_defensive(tick)
        data.breaking_lc = true

        data.defensive.begin = globals.tickcount()
        data.defensive.duration = tick
    end

    local function update_teleport(old_origin, new_origin)
        local delta = new_origin - old_origin
        local distance = delta:lengthsqr()

        local is_teleport = distance > LAG_COMPENSATION_TELEPORTED_DISTANCE_SQR

        data.breaking_lc = is_teleport

        data.lagcompensation.distance = distance
        data.lagcompensation.teleport = is_teleport
    end

    local function update_lagcompensation(me)
        local old_origin = data.old_origin
        local old_simtime = data.old_simtime

        local origin = vector(entity.get_origin(me))
        local simtime = toticks(entity.get_prop(me, 'm_flSimulationTime'))

        if old_simtime ~= nil then
            local delta = simtime - old_simtime

            if delta < 0 or delta > 0 and delta <= 64 then
                local tick = delta - 1

                update_teleport(old_origin, origin)

                if delta < 0 then
                    update_defensive(math.abs(tick))
                end
            end
        end

        data.old_origin = origin
        data.old_simtime = simtime
    end

    function exploit.get()
        return data
    end

    function exploit.setup_command(cmd, me)
        update_tickbase(me)
    end

    function exploit.net_update(me)
        if me == nil then
            return
        end

        update_lagcompensation(me)
    end

    local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')

    function exploit.update_defensive(lp)
        if lp == nil then
            return
        end

        local ent = native_GetClientEntity(lp)
        local old_simtime = ffi.cast('float*', ffi.cast('uintptr_t', ent) + 0x26C)[0]
        local simtime = entity.get_prop(lp, 'm_flSimulationTime')

        local delta = old_simtime - simtime

        if delta > 0 then
            data.defensive_tick = globals.tickcount() + toticks(delta - client.real_latency())
            return
        end
    end

    callbacks['Exploits']['net_update_end']:set(function (lp, valid)
        exploit.net_update(lp)
        exploit.update_defensive(lp)
    end)
end

local easings do
    easings = { }

    function easings.outQuad(t, b, c, d)
        t = t / d
        return -c * t * (t - 2) + b
    end

    function easings.outCirc(t, b, c, d)
        t = t / d - 1
        return (c * math.sqrt(1 - math.pow(t, 2)) + b)
    end
end

local vars = { }
LPH_NO_VIRTUALIZE(function ()
    do
        pui.macros.dot = '\v•  \r'
    
        local ui_group = pui.group('AA', 'Fake lag')
        local group = pui.group('AA', 'Anti-aimbot angles')
    
        local selection do
            vars.selection = { }
    
            vars.selection.label = ui_group:label(string.format('\f<dot>exscord · %s · %s', defines.user, defines.build))
    
            vars.selection.tab = ui_group:combobox('\f<dot>Selection', { 'Ragebot', 'Anti Aim', 'Visuals', 'Misc', 'Configs' }, false, false)
            vars.selection.aa_tab = ui_group:combobox('\nAA Tab', { 'Main', 'Angles' }, false, false):depend({ vars.selection.tab, 'Anti Aim' })
    
            vars.selection.tab_label = group:label(string.format('\f<dot> %s', vars.selection.tab.value))
    
            vars.selection.tab:set_callback(function (self)
                vars.selection.tab_label:set(string.format('\f<dot>%s', self.value))
            end, true)
        end
    
        local rage do
            vars.rage = { }
    
            do
                vars.rage.logger = { }
    
                vars.rage.logger.main = group:checkbox('Event Logger'):depend({ vars.selection.tab, 'Ragebot' })
                vars.rage.logger.events = group:multiselect('\f<dot>Events', { 'Aimbot Shots', 'Damage Dealt', 'Purchases' }):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.logger.main)
                vars.rage.logger.output = group:multiselect('\f<dot>Output', { 'Console', 'Notifications' }):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.logger.main)
                vars.rage.logger.hit = group:label('\f<dot>Hit Color', { 182, 231, 23, 255 }):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.logger.main, { vars.rage.logger.events, 'Aimbot Shots', 'Damage Dealt' })
                vars.rage.logger.miss = group:label('\f<dot>Miss Color', { 255, 80, 101, 255 }):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.logger.main, { vars.rage.logger.events, 'Aimbot Shots' })
                vars.rage.logger.purchase = group:label('\f<dot>Purchases Color', { 255, 184, 79, 255 }):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.logger.main, { vars.rage.logger.events, 'Purchases' })
    
                vars.rage.logger.main:set_callback(function (self)
                    local val = self.value
                    for _, item in next, reference.logging do
                        item:set_enabled(not val)
                        if val then
                            item:override(false)
                        else
                            item:override()
                        end
                    end
                end, true)
            end
    
            do
                vars.rage.hitchance = { }
    
                local weapons = { 'Auto', 'SSG-08', 'AWP', 'R8 Revolver' }
    
                vars.rage.hitchance.main = group:checkbox('Custom Hitchance'):depend({ vars.selection.tab, 'Ragebot' })
                vars.rage.hitchance.weapons = group:combobox('\f<dot>Weapon', weapons):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.hitchance.main)
    
                for _, weapon in next, weapons do
                    vars.rage.hitchance[ weapon ] = { }
                    vars.rage.hitchance[ weapon ].enabled = group:checkbox(f('Override %s', weapon)):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.hitchance.main, { vars.rage.hitchance.weapons, weapon })
                    vars.rage.hitchance[ weapon ].conditions = group:multiselect(f('\f<dot>Conditions \n%s', weapon), { 'No Scope', 'In Air' }):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.hitchance.main, { vars.rage.hitchance.weapons, weapon }, vars.rage.hitchance[ weapon ].enabled)
                    vars.rage.hitchance[ weapon ].distance = group:slider(f('\f<dot>Distance \n%s', weapon), 100, 1001, 500, true, 'm', 0.01, { [1001] = 'Inf.' }):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.hitchance.main, { vars.rage.hitchance.weapons, weapon }, vars.rage.hitchance[ weapon ].enabled, { vars.rage.hitchance[ weapon ].conditions, 'No Scope' })
                    vars.rage.hitchance[ weapon ].noscope = group:slider(f('\f<dot>No Scope \n%s', weapon), 1, 100, 50, true, '%'):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.hitchance.main, { vars.rage.hitchance.weapons, weapon }, vars.rage.hitchance[ weapon ].enabled, { vars.rage.hitchance[ weapon ].conditions, 'No Scope' })
                    vars.rage.hitchance[ weapon ].air = group:slider(f('\f<dot>In Air \n%s', weapon), 1, 100, 50, true, '%'):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.hitchance.main, { vars.rage.hitchance.weapons, weapon }, vars.rage.hitchance[ weapon ].enabled, { vars.rage.hitchance[ weapon ].conditions, 'In Air' })
                end
            end
        end
    
        local antiaim do
            vars.aa = { }
    
            vars.aa.disablers = group:checkbox('Warmup Disablers'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
            vars.aa.legit = group:checkbox('Legit AA on Use'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
            vars.aa.backstab = group:checkbox('Anti Backstab'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
    
            do
                vars.aa.manual = { }
                vars.aa.manual.main = group:checkbox('Manual Yaw Base'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
                vars.aa.manual.static = group:checkbox('\f<dot>Disable Yaw Modifiers'):depend({ vars.selection.tab, 'Anti Aim' }, vars.aa.manual.main, { vars.selection.aa_tab, 'Main' })
                vars.aa.manual.defensive = group:checkbox('\f<dot>Edge Direction'):depend({ vars.selection.tab, 'Anti Aim' }, vars.aa.manual.main, { vars.selection.aa_tab, 'Main' })
                vars.aa.manual.left = group:hotkey('\f<dot>Left'):depend({ vars.selection.tab, 'Anti Aim' }, vars.aa.manual.main, { vars.selection.aa_tab, 'Main' })
                vars.aa.manual.right = group:hotkey('\f<dot>Right'):depend({ vars.selection.tab, 'Anti Aim' }, vars.aa.manual.main, { vars.selection.aa_tab, 'Main' })
                vars.aa.manual.forward = group:hotkey('\f<dot>Forward'):depend({ vars.selection.tab, 'Anti Aim' }, vars.aa.manual.main, { vars.selection.aa_tab, 'Main' })
                vars.aa.manual.reset = group:hotkey('\f<dot>Reset'):depend({ vars.selection.tab, 'Anti Aim' }, vars.aa.manual.main, { vars.selection.aa_tab, 'Main' })
            end
    
            do
                vars.aa.freestanding = { }
    
                vars.aa.freestanding.main = group:checkbox('Freestanding', 0):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' }) do
                    vars.aa.freestanding.main.hotkey:depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' }, vars.aa.freestanding.main)
                end
    
                vars.aa.freestanding.disablers = group:multiselect('\f<dot>Disablers', { 'Stand', 'Move', 'Slow Walk', 'Air', 'Air Crouch', 'Crouch' }):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' }, vars.aa.freestanding.main)
            end
    
            do
                vars.aa.defensive = { }
                vars.aa.defensive.main = group:checkbox('Defensive Options'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
    
                vars.aa.defensive.mode = group:multiselect('\f<dot>Mode', { 'Double Tap', 'Hide Shots' }):depend(vars.aa.defensive.main, { vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
                vars.aa.defensive.conditions = group:multiselect('\f<dot>Conditions', { 'Stand', 'Move', 'Slow Walk', 'Air', 'Air Crouch', 'Crouch', 'On Peek' }):depend(vars.aa.defensive.main, { vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
                vars.aa.defensive.apply = group:checkbox('\f<dot>Apply Anti Aim'):depend(vars.aa.defensive.main, { vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
                vars.aa.defensive.pitch = group:combobox('\f<dot>Pitch', { 'Default', 'Zero', 'Up', 'Up-Switch', 'Down-Switch', 'Random' }):depend(vars.aa.defensive.main, { vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
                vars.aa.defensive.yaw = group:combobox('\f<dot>Yaw', { 'Default', 'Sideways', 'Forward', 'Spinbot', 'Random' }):depend(vars.aa.defensive.main, { vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
    
                vars.aa.defensive.apply:set_callback(function (self)
                    local val = self.value
                    vars.aa.defensive.pitch:set_enabled(val)
                    vars.aa.defensive.yaw:set_enabled(val)
                end, true)
            end
    
            vars.aa.safe = group:multiselect('Safe Head', { 'Stand', 'Crouch', 'Air Crouch', 'Air Zeus', 'Air Knife' }):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
        end
    
        local angles do
            vars.angles = { }
    
            vars.angles.type = group:combobox('Mode', { 'Default', 'Builder', 'Preset' }):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' })
            vars.angles.condition = group:combobox('Player Condition', defines.conditions):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' })
    
            vars.angles.label = group:label('You are using Preset.'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Preset' })
            vars.angles.label2 = group:label('Everything is already set up.'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Preset' })
            vars.angles.label3 = group:label(f('Enjoy, \v%s', defines.user)):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Preset' })
        end
    
        local conditions do
            vars.conditions = { }
    
            for idx, condition in next, defines.conditions do
                vars.conditions[ condition ] = { }
    
                if condition ~= defines.conditions[ 1 ] then
                    vars.conditions[ condition ].enabled = group:checkbox(f('Redefine %s', condition))
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition })
                end
    
                do
                    vars.conditions[ condition ].pitch = group:combobox(f('Pitch \n%s', condition), { 'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random', 'Custom' })
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].pitch_value = group:slider(f('\nPitch Value %s', condition), -89, 89, 0, true, '°')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].pitch, 'Custom' }, vars.conditions[ condition ].enabled)
                end
    
                do
                    vars.conditions[ condition ].yaw_base = group:combobox(f('Yaw Base \n%s', condition), { 'Local view', 'At targets' })
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, vars.conditions[ condition ].enabled)
                end
    
                do
                    vars.conditions[ condition ].yaw = group:combobox(f('Yaw \n%s', condition), { 'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair', '180 Left / Right' })
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].yaw_offset = group:slider(f('\nYaw Offset %s', condition), -180, 180, 0, true, '°')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, '180', 'Spin', 'Static', '180 Z', 'Crosshair' }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].delayed_swap = group:checkbox(f('\f<dot>Delayed Switch\n%s', condition))
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, '180 Left / Right' }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].yaw_left = group:slider(f('\f<dot>Left Offset \n%s', condition), -180, 180, 0, true, '°')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, '180 Left / Right' }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].yaw_right = group:slider(f('\f<dot>Right Offset \n%s', condition), -180, 180, 0, true, '°')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, '180 Left / Right' }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].yaw_delay = group:slider(f('\f<dot>Delay \n%s', condition), 1, 10, 5, true, 't')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, '180 Left / Right' }, vars.conditions[ condition ].delayed_swap, vars.conditions[ condition ].enabled)
                end
    
                if condition == defines.conditions[ 8 ] then
                    vars.conditions[ condition ].pitch:set_enabled(false)
                    vars.conditions[ condition ].yaw_base:set_enabled(false)
                    vars.conditions[ condition ].yaw:set_enabled(false)
                end
    
                do
                    vars.conditions[ condition ].yaw_modifier = group:combobox(f('Yaw Modifier \n%s', condition), { 'Off', 'Offset', 'Center', 'Random', 'Skitter' })
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].yaw_modifier_offset = group:slider(f('\nModifier Offset \n%s', condition), -180, 180, 0, true, '°')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true }, { vars.conditions[ condition ].yaw_modifier, 'Off', true }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].yaw_modifier_randomize = group:slider(f('\f<dot>Randomize \n%s', condition), 0, 180, 0, true, '°', 1, { [0] = 'Off' })
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true }, { vars.conditions[ condition ].yaw_modifier, 'Off', true }, vars.conditions[ condition ].enabled)
                end
    
                do
                    vars.conditions[ condition ].body_yaw = group:combobox(f('Body Yaw \n%s', condition), { 'Off', 'Opposite', 'Jitter', 'Static' })
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].body_yaw_offset = group:slider(f('\nBody Yaw Offset \n%s', condition), -180, 180, 0, true, '°')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].body_yaw, 'Jitter', 'Static' }, vars.conditions[ condition ].enabled)
                end
    
                vars.conditions[ condition ].freestanding = group:checkbox(f('Freestanding Body Yaw \n%s', condition))
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].body_yaw, 'Off', true }, vars.conditions[ condition ].enabled)
            end
    
            vars.angles.copy = group:button('Export'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' })
            vars.angles.import = group:button('Import'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' })
            
            vars.angles.copy:set_enabled(true)
            vars.angles.import:set_enabled(true)
        end
    
        local visuals do
            vars.visuals = { }
    
            vars.visuals.indicators = group:checkbox('Crosshair Indicators', defines.accent):depend({ vars.selection.tab, 'Visuals' }) do
                vars.visuals.damage = group:checkbox('Damage Indicator'):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.indicators)
            end
    
            vars.visuals.arrows = group:checkbox('Manual Arrows', defines.accent):depend({ vars.selection.tab, 'Visuals' })
            vars.visuals.watermark = group:checkbox('Watermark', defines.accent):depend({ vars.selection.tab, 'Visuals' })
            vars.visuals.watermark_items = group:multiselect('\f<dot>Items', { 'Username', 'Latency', 'Framerate', 'Time' }):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.watermark)
        end
    
        local misc do
            vars.misc = { }
    
            vars.misc.shared = group:checkbox('Shared Logo'):depend({ vars.selection.tab, 'Misc' }) do
                vars.misc.shared:set_enabled(false)
            end
    
            do
                vars.misc.clantag = group:checkbox('Clan Tag'):depend({ vars.selection.tab, 'Misc' })
    
                local function utililize_clantag()
                    if vars.misc.clantag.value then
                        reference.MISC.clantag:set_enabled(false)
                        reference.MISC.clantag:override(false)
                    else
                        reference.MISC.clantag:set_enabled(true)
                        client.set_clan_tag ''
                        reference.MISC.clantag:override()
                    end
                end
    
                vars.misc.clantag:set_callback(utililize_clantag, true)
                reference.MISC.clantag:set_callback(utililize_clantag, true)
            end
    
            vars.misc.ladder = group:checkbox('Fast Ladder Move'):depend({ vars.selection.tab, 'Misc' })
    
            do
                vars.misc.breakers = { }
    
                vars.misc.breakers.main = group:checkbox('Animation Breakers'):depend({ vars.selection.tab, 'Misc' })
    
                vars.misc.breakers.global = group:multiselect('\f<dot>Global', { 'Static Legs on Slow Walk', 'Zero Pitch on Land' }):depend({ vars.selection.tab, 'Misc' }, vars.misc.breakers.main)
                vars.misc.breakers.ground = group:combobox('\f<dot>Leg Movement', { 'Disabled', 'Static', 'Walking' }):depend({ vars.selection.tab, 'Misc' }, vars.misc.breakers.main)
                vars.misc.breakers.air = group:combobox('\f<dot>In Air', { 'Disabled', 'Static', 'Walking' }):depend({ vars.selection.tab, 'Misc' }, vars.misc.breakers.main)
    
                reference.AA.other.leg_movement:depend(true, { vars.misc.breakers.main, false })
            end
    
            vars.misc.filter = group:checkbox('Console Filter'):depend({ vars.selection.tab, 'Misc' }) do
                vars.misc.filter:set_callback(function (self)
                    cvar.con_filter_text:set_string('[gamesense]')
                    cvar.con_filter_enable:set_raw_int(self.value and 1 or 0)
                end, true)
    
                defer(function ()
                    cvar.con_filter_enable:set_raw_int(tonumber(cvar.con_filter_enable:get_string()))
                end)
            end
        end
    
        local configs do
            vars.configs = { }
    
            vars.configs.list = group:listbox('\nConfig List', { 'No Configs!' }, '', false):depend({ vars.selection.tab, 'Configs' })
            vars.configs.name = group:textbox('\nConfig Name', '', false):depend({ vars.selection.tab, 'Configs' })
            vars.configs.load = group:button('Load', nil, true):depend({ vars.selection.tab, 'Configs' })
            vars.configs.save = group:button('Save', nil, true):depend({ vars.selection.tab, 'Configs' })
            vars.configs.export = group:button('Export', nil, true):depend({ vars.selection.tab, 'Configs' })
            vars.configs.import = group:button('Import', nil, true):depend({ vars.selection.tab, 'Configs' })
            vars.configs.remove = group:button('Remove', nil, true):depend({ vars.selection.tab, 'Configs' })
        end
    
        local function set_skeet_ui(state)
            for _, ref in next, reference.AA.angles do
                for __, subref in next, ref do
                    subref:set_visible(state)
                end
            end
        end
    
        local function reset_overrides()
            for _, ref in next, reference.AA.angles do
                for __, subref in next, ref do
                    subref:override()
                end
            end
        end
    
        local function hide_fakelag(state)
            for _, ref in next, reference.AA.fakelag do
                if ref.name then
                    ref:set_visible(state)
                else
                    for __, subref in next, ref do
                        subref:set_visible(state)
                    end
                end
            end
        end
    
        hide_fakelag(false)
    
        callbacks['Vars']['paint_ui']:set(function ()
            if not ui.is_menu_open() then
                return
            end
    
            set_skeet_ui(false)
        end)
    
        callbacks['Vars']['shutdown']:set(function ()
            hide_fakelag(true)
            set_skeet_ui(true)
            reset_overrides()
        end)
    end
end)()

local notifications = { }
LPH_NO_VIRTUALIZE(function ()
    do
        notifications = { }
    
        local queue = { }
    
        local function inSine(t, b, c, d)
            return -c * math.cos(t / d * (math.pi / 2)) + c + b
        end
    
        function notifications.push(duration, text)
            queue[ #queue + 1 ] = {
                text = text,
                duration = globals.realtime() + duration,
                animation = tweening.new(0, inSine)
            }
        end
    
        callbacks['Notifications']['paint']:set(function ()
            local field = defines.screen:clone() do
                field.x = field.x * .5
                field.y = field.y - 340
            end
    
            local realtime = globals.realtime()
            local offset = 0
    
            for i = #queue, 1, -1 do
                local notification = queue[ i ]
                if not notification then
                    goto skip
                end
    
                local difference = notification.duration - realtime
                local alpha = notification.animation(.15, difference > 0)
                if alpha < 0.001 and difference < 0 then
                    table.remove(queue, i)
                    goto skip
                end
    
                local text = utilities.alpha_modulate(notification.text, alpha)
                local size = renderer.measure_text(nil, text)
                local width = size * alpha
    
                renderer.text(field.x - width * .5, field.y + offset, 255, 255, 255, 255 * alpha, nil, math.ceil(width + 1), text)
    
                offset = offset + 14 * alpha
                ::skip::
            end
    
            for i = 1, #queue do
                local count = #queue - i
    
                if count > 7 then
                    queue[ i ].duration = 0
                end
            end
        end)
    
        setmetatable(notifications, {
            __call = function (self, ...)
                notifications.push(...)
            end
        })
    end
end)()

LPH_NO_VIRTUALIZE(function ()
    local configs do
        configs = { }
    
        configs.instance = pui.setup(vars)
        configs.prefix = 'exscord:'
    
        local data = db.exscord or { }
        if type(data) ~= 'table' then
            data = { }
        end
    
        function configs.export()
            local config = configs.instance:save()
            if config == nil then
                return
            end
    
            local data = {
                author = defines.user,
                data = config,
                name = vars.configs.name.value
            }
    
            local success, packed = pcall(msgpack.pack, data)
            if not success then
                return
            end
    
            local success, encode = pcall(base64.encode, packed)
            if not success then
                return
            end
    
            return f('exscord:%s_exscord', encode)
        end
    
        function configs.import(str)
            local config = str or clipboard.get()
            if config == nil then
                return print_format('\vexscord \r· Input is empty.')
            end
    
            if string.sub(config, 1, #configs.prefix) ~= configs.prefix then
                return print_format('\vexscord \r· Looks like this config is not for exscord...')
            end
    
            config = config:gsub('exscord:', ''):gsub('_exscord', '')
    
            local success, decoded = pcall(base64.decode, config)
            if not success then
                return print_format('\vexscord \r· Failed to decode configuration.')
            end
    
            local success, data = pcall(msgpack.unpack, decoded)
            if not success then
                return print_format('\vexscord \r· Failed to parse configuration.')
            end
    
            configs.instance:load(data.data)
        end
    
        local configs_mt = {
            __index = {
                load = function(self)
                    configs.import(self.data)
                end,
    
                export = function(self)
                    if not self.data:find('_exscord') then
                        self.data = f('%s_exscord', self.data)
                    end
    
                    clipboard.set(self.data)
                end,
    
                save = function(self, data)
                    if data == nil then
                        data = configs.export()
                    end
    
                    self.data = data
                    self.author = defines.user
                end,
    
                to_db = function(self)
                    return {
                        name = self.name,
                        data = self.data,
                        author = defines.user
                    }
                end
            }
        }
    
        local database_mt = setmetatable({ }, {
            __index = function(self, key)
                local storage = data.configs
    
                if storage == nil then
                    return nil
                end
    
                local success, parsed = pcall(json.parse, storage)
                if not success then
                    return nil
                end
    
                return parsed[ key ]
            end,
    
            __newindex = function(self, key, v)
                local storage = data.configs
    
                if storage == nil then
                    storage = '{}'
                end
    
                local success, parsed = pcall(json.parse, storage)
                if not success then
                    parsed = { }
                end
    
                parsed[ key ] = v
    
                data.configs = json.stringify(parsed)
            end
        })
    
        local database_name = 'exscord'
        local live_list = { }
    
        function configs.update_list()
            local list_names = { }
    
            local val = vars.configs.list:get() + 1
    
            for i = 1, #live_list do
                local obj = live_list[ i ]
    
                list_names[ #list_names + 1 ] = f('%s%s', val == i and '\a' .. pui.accent .. '• ' or '', obj.name)
            end
    
            if #list_names == 0 then
                list_names[ #list_names + 1 ] = 'Config list is empty!'
            end
    
            vars.configs.list:update(list_names)
        end
    
        function configs.lookup(name)
            name = utilities.strip(name)
    
            for i = 1, #live_list do
                local obj = live_list[ i ]
    
                if obj.name == name then
                    return obj, i
                end
            end
        end
    
        function configs.create(name, data, author)
            name = utilities.strip(name)
    
            local new_preset = {
                name = name,
                data = data or configs.export(),
                author = author or defines.user
            }
    
            live_list[ #live_list + 1 ] = setmetatable(new_preset, configs_mt)
    
            configs.update_list()
            configs.flush()
        end
    
        function configs.on_list_name()
            if #live_list == 0 then
                return vars.configs.name:set('')
            end
    
            local selected_preset = live_list[ vars.configs.list:get() + 1 ]
    
            if selected_preset == nil then
                selected_preset = live_list[ #live_list ]
            end
    
            vars.configs.name:set(selected_preset.name)
        end
    
        function configs.destroy(preset)
            for i = 1, #live_list do
                local obj = live_list[ i ]
    
                if obj.name == preset.name then
                    table.remove(live_list, i)
                    break
                end
            end
    
            configs.update_list()
            configs.flush()
            configs.on_list_name()
        end
    
        function configs.init()
            local db_info = database_mt[ database_name ]
    
            if db_info == nil then
                db_info = { }
            end
    
            for i = 1, #db_info do
                local obj = db_info[ i ]
    
                live_list[ i ] = setmetatable(obj, configs_mt)
            end
    
            configs.update_list()
            configs.on_list_name()
        end
    
        function configs.flush()
            local db_info = { }
    
            for i = 1, #live_list do
                local obj = live_list[ i ]
    
                db_info[ #db_info + 1 ] = obj:to_db()
            end
    
            database_mt[ database_name ] = db_info
        end
    
        function configs.startup()
            if not data.stored_config then
                return print_format('\vexscord \r· Successfully inited config database.')
            end
    
            client.delay_call(0.01, configs.import, data.stored_config)
        end
    
        local basic_controls = { 'load', 'export' }
        local sentences = {
            ['load'] = 'loaded',
            ['export'] = 'copied'
        }
    
        for _, type in next, basic_controls do
            vars.configs[ type ]:set_callback(function()
                local selected_name = vars.configs.name:get()
                local selected_preset, id = configs.lookup(selected_name)
    
                if selected_preset == nil then
                    return print_format('\vexscord \r· Failed to \v%s\r, configuration doesnt exist.', type)
                end
    
                print_format('\vexscord \r· Successfully %s \v%s\r.', sentences[ type ], selected_preset.name)
                selected_preset[type](selected_preset)
    
                configs.on_list_name()
                configs.update_buttons()
            end)
        end
    
        vars.configs.save:set_callback(function()
            local selected_name = vars.configs.name:get()
            local selected_preset, id = configs.lookup(selected_name)
    
            if selected_preset == nil then
                configs.create(selected_name)
                vars.configs.list:set(#live_list)
                print_format('\vexscord \r· Config \v%s \rwas successfully saved.', utilities.strip(selected_name))
            else
                print_format('\vexscord \r· Config \v%s \rwas successfully overwrited.', utilities.strip(selected_name))
                selected_preset:save()
            end
    
            configs.on_list_name()
            configs.update_buttons()
        end)
    
        vars.configs.import:set_callback(function ()
            local clipboard_text = clipboard.get()
            local s = clipboard_text
            if s == nil then
                return print_format('\vexscord \r· Your clipboard is empty.')
            end
    
            do
                if s:sub(1, #configs.prefix) ~= configs.prefix then
                    return print_format('\vexscord \r· Looks like this config is not for exscord...')
                end
    
                s = s:sub(#configs.prefix + 1)
    
                if s:find('_exscord') then
                    s = s:gsub('_exscord', '')
                end
            end
    
            local success, decoded = pcall(base64.decode, s)
            if not success then
                return print_format('\vexscord \r· Failed to decode your configuration.')
            end
    
            local success, unpacked = pcall(msgpack.unpack, decoded)
            if not success then
                return print_format('\vexscord \r· Failed to unpack your configuration.')
            end
    
            local selected_preset, id = configs.lookup(unpacked.name)
            if selected_preset == nil then
                print_format('\vexscord \r· Added \v%s \rby \v%s\r.', utilities.strip(unpacked.name), unpacked.author)
                configs.create(unpacked.name, clipboard_text, unpacked.author)
                vars.configs.list:set(#live_list)
            else
                print_format('\vexscord \r· Config \v%s \rwas successfully overwrited.', utilities.strip(unpacked.name))
                selected_preset:save(clipboard_text)
            end
    
            configs.import(clipboard_text)
            configs.on_list_name()
            configs.update_buttons()
        end)
    
        vars.configs.remove:set_callback(function()
            local selected_name = vars.configs.name:get()
            local selected_preset, id = configs.lookup(selected_name)
    
            if selected_preset == nil then
                return
            end
    
            print_format('\vexscord \r· Config \v%s \rwas successfully removed.', selected_preset.name)
    
            configs.destroy(selected_preset)
            configs.update_buttons()
        end)
    
        function configs.update_buttons()
            local selected_name = vars.configs.name:get()
            local selected_preset, id = configs.lookup(selected_name)
    
            local state = selected_preset ~= nil
            vars.configs.load:set_enabled(state)
            vars.configs.export:set_enabled(state)
            vars.configs.remove:set_enabled(state)
        end
    
        vars.configs.list:set_callback(function (self)
            local selected_name = vars.configs.name:get()
            local selected_preset, id = configs.lookup(selected_name)
    
            configs.on_list_name()
            configs.update_list()
            configs.update_buttons()
        end, true)
    
        configs.init()
        configs.startup()
        client.delay_call(.1, function ()
            configs.on_list_name()
            configs.update_buttons()
        end)

    
        callbacks['Configs']['shutdown']:set(function ()
            configs.flush()
            data.stored_config = configs.export()
            db.exscord = data
        end)
    end
end)()

LPH_NO_VIRTUALIZE(function ()
    local logger do
        logger = {
            hitgroups = {
                [0] = 'generic',
                'head', 'chest', 'stomach',
                'left arm', 'right arm',
                'left leg', 'right leg',
                'neck', 'generic', 'gear'
            },
    
            weapon_verb = {
                ['hegrenade'] = 'Naded',
                ['inferno'] = 'Burned',
                ['knife'] = 'Knifed',
                ['taser'] = 'Tasered'
            },
    
            wanted_damage = 0,
            wanted_hitgroup = 0,
            backtrack = 0
        }
    
        function logger.push(str, notify_str)
            local ref = vars.rage.logger.output.value
            if #ref == 0 then
                return
            end
    
            local convert = utilities.table_convert(ref)
    
            if convert['Console'] then
                printc(utilities.clean_up(str))
            end
    
            if convert['Notifications'] then
                notifications(5, notify_str)
            end
        end
    
        callbacks['Logger']['aim_fire']:set(function (shot, lp, valid)
            if not vars.rage.logger.main.value or not valid then
                return
            end
    
            if not utilities.contains(vars.rage.logger.events.value, 'Aimbot Shots') then
                return
            end
    
            logger.wanted_damage = shot.damage
            logger.wanted_hitgroup = shot.hitgroup
            logger.backtrack = globals.tickcount() - shot.tick
        end)
    
        callbacks['Logger']['aim_hit']:set(function (shot, lp, valid)
            if not vars.rage.logger.main.value or not valid then
                return
            end
    
            if not utilities.contains(vars.rage.logger.events.value, 'Aimbot Shots') then
                return
            end
    
            local output = vars.rage.logger.output.value
            if #output == 0 then
                return
            end
    
            local convert = utilities.table_convert(output)
    
            local target = shot.target
            if target == nil then
                return
            end
    
            local r, g, b = vars.rage.logger.hit:get_color()
    
            local name = entity.get_player_name(target)
            local health = entity.get_prop(target, 'm_iHealth')
            local hitgroup = logger.hitgroups[ shot.hitgroup ]
    
            if convert['Console'] then
                local info = {
                    '\vexscord \r· ',
                    health > 0 and 'Hit ' or 'Killed ',
                    f('\v%s\r ', name),
                    'in the ',
                    shot.hitgroup ~= logger.wanted_hitgroup and f('\v%s\r (aimed: \v%s\r) ', hitgroup, logger.hitgroups[ logger.wanted_hitgroup ]) or f('\v%s\r ', hitgroup),
                    health > 0 and 'for ' or '',
                    health > 0 and (shot.damage ~= logger.wanted_damage and f('\v%d\r(\v%d\r) ', shot.damage, logger.wanted_damage) or f('\v%d\r ', shot.damage)) or '',
                    health > 0 and 'damage ' or '',
                    logger.backtrack ~= 0 and f('(history: \v%d\r) ', logger.backtrack) or '',
                    health > 0 and f('(\v%d \rhealth remaining)', health) or ''
                }
                
                printc(utilities.clean_up(utilities.format(table.concat(info, ''), r, g, b)))
            end
    
            if convert['Notifications'] then
                local notify_data = {
                    health > 0 and 'Hit ' or 'Killed ',
                    f('\v%s\r ', name),
                    'in the ',
                    f('\v%s\r ', hitgroup),
                    health > 0 and 'for ' or '',
                    health > 0 and f('\v%d\r ', shot.damage) or '',
                    health > 0 and 'damage' or ''
                }
        
                notifications(5, utilities.format(table.concat(notify_data, ''), r, g, b))
            end
        end)
    
        callbacks['Logger']['aim_miss']:set(function (shot, lp, valid)
            if not vars.rage.logger.main.value or not valid then
                return
            end
    
            if not utilities.contains(vars.rage.logger.events.value, 'Aimbot Shots') then
                return
            end
    
            local output = vars.rage.logger.output.value
            if #output == 0 then
                return
            end
    
            local convert = utilities.table_convert(output)
    
            local target = shot.target
            if target == nil then
                return
            end
    
            local r, g, b = vars.rage.logger.miss:get_color()
    
            local name = entity.get_player_name(target)
    
    
            if convert['Console'] then
                local info = {
                    '\vexscord \r· ',
                    'Missed at ',
                    f('\v%s\r\'s ', name),
                    f('\v%s\r(\v%d%%\r) ', logger.hitgroups[ shot.hitgroup ], shot.hit_chance or 0),
                    'due to ',
                    f('\v%s\r ', shot.reason),
                    f('(dmg: \v%d\r | history: \v%d\r)', logger.wanted_damage or 0, logger.backtrack or 0)
                }
                
                printc(utilities.clean_up(utilities.format(table.concat(info, ''), r, g, b)))
            end
    
            if convert['Notifications'] then
                local notify_data = {
                    'Missed at ',
                    f('\v%s\r ', name),
                    'due to ',
                    f('\v%s\r ', shot.reason)
                }
    
                notifications(5, utilities.format(table.concat(notify_data, ''), r, g, b))
            end
        end)
    
        callbacks['Logger']['player_hurt']:set(function (e, lp, valid)
            if not vars.rage.logger.main.value or not valid then
                return
            end
    
            if not utilities.contains(vars.rage.logger.events.value, 'Damage Dealt') then
                return
            end
    
            local output = vars.rage.logger.output.value
            if #output == 0 then
                return
            end
    
            local convert = utilities.table_convert(output)
    
            local victim = client.userid_to_entindex(e.userid)
            local attacker = client.userid_to_entindex(e.attacker)
            if victim == nil or victim == lp or attacker ~= lp then
                return
            end
    
            local verb = logger.weapon_verb[ e.weapon ]
            if verb == nil then
                return
            end
    
            local r, g, b = vars.rage.logger.hit:get_color()
            local name = entity.get_player_name(victim)
    
            if convert['Console'] then
                local info = {
                    '\vexscord \r· ',
                    verb,
                    f(' \v%s\r ', name),
                    'for ',
                    f('\v%s \rdamage ', e.dmg_health or 0),
                    e.health ~= 0 and f('(\v%d \rhealth remaining)', e.health or 0) or '(\vdead\r)'
                }
                
                printc(utilities.clean_up(utilities.format(table.concat(info, ''), r, g, b)))
            end
    
            if convert['Notifications'] then
                local notify_data = {
                    verb,
                    f(' \v%s\r ', name),
                    'for ',
                    f('\v%s \rdamage ', e.dmg_health or 0)
                }
    
                notifications(5, utilities.format(table.concat(notify_data, ''), r, g, b))
            end
        end)
    
        callbacks['Logger']['item_purchase']:set(function (e, lp, valid)
            if not vars.rage.logger.main.value or not valid then
                return
            end
    
            if not utilities.contains(vars.rage.logger.events.value, 'Purchases') then
                return
            end
    
            local output = vars.rage.logger.output.value
            if #output == 0 then
                return
            end
    
            local convert = utilities.table_convert(output)
    
            local player = client.userid_to_entindex(e.userid)
            if player == nil or not entity.is_enemy(player) then
                return
            end
    
            local weapon = e.weapon
            if weapon == 'weapon_unknown' then
                return
            end
    
            local r, g, b, a = vars.rage.logger.purchase:get_color()
            local name = entity.get_player_name(player)
    
            if convert['Console'] then
                local info = {
                    '\vexscord \r· ',
                    f('\v%s\r ', name),
                    'bought ',
                    f('\v%s\r', weapon)
                }
    
                printc(utilities.clean_up(utilities.format(table.concat(info, ''), r, g, b)))
            end
    
            if convert['Notifications'] then
                local notify_data = {
                    f('\v%s\r ', name),
                    'bought ',
                    f('\v%s\r', weapon)
                }
                
                notifications(5, utilities.format(table.concat(notify_data, ''), r, g, b))
            end
        end)
    end
end)()

LPH_NO_VIRTUALIZE(function ()
    local hitchance do
        hitchance = {
            reset = false
        }
    
        local weapons = {
            [11] = 'Auto',
            [38] = 'Auto',
            [40] = 'SSG-08',
            [9] = 'AWP',
            [64] = 'R8 Revolver'
        }
    
        function hitchance.backups()
            if hitchance.reset then
                reference.RAGE.hitchance:override()
                reference.RAGE.autoscope:override()
                hitchance.reset = false
            end
        end
    
        function hitchance.distance(lp, distance)
            local origin = vector(entity.get_origin(lp))
            if origin == nil then
                return
            end
    
            local target = client.current_threat()
            if target == nil then
                return
            end
    
            local threat_origin = vector(entity.get_origin(target))
            if threat_origin == nil then
                return
            end
    
            if distance == 1001 then
                return 'Inf.'
            end
    
            return origin:dist(threat_origin) <= distance
        end
    
        callbacks['Hit Chance']['setup_command']:set(function (cmd, lp, valid)
            if not vars.rage.hitchance.main.value or not valid then
                return hitchance.backups()
            end
    
            local weapon = entity.get_player_weapon(lp)
            if weapon == nil then
                return hitchance.backups()
            end
    
            local weapon_info = c_weapon(weapon)
            if weapon_info == nil then
                return hitchance.backups()
            end
    
            local normalized_weapon = weapons[ weapon_info.idx ]
            if normalized_weapon == nil then
                return hitchance.backups()
            end
    
            if not vars.rage.hitchance[ normalized_weapon ].enabled.value then
                return hitchance.backups()
            end
    
            local distance = hitchance.distance(lp, vars.rage.hitchance[ normalized_weapon ].distance.value)
            local conditions = utilities.table_convert(vars.rage.hitchance[ normalized_weapon ].conditions.value)
    
            if conditions[ 'In Air' ] and not lp_info.on_ground then
                reference.RAGE.hitchance:override(vars.rage.hitchance[ normalized_weapon ].air.value)
            elseif conditions[ 'No Scope' ] and entity.get_prop(lp, 'm_bIsScoped') == 0 and distance then
                reference.RAGE.hitchance:override(vars.rage.hitchance[ normalized_weapon ].noscope.value)
                reference.RAGE.autoscope:override(false)
            else
                return hitchance.backups()
            end
    
            if distance == 'Inf.' then
                reference.RAGE.autoscope:override()
            end
    
            hitchance.reset = true
        end)
    end
end)()

local manuals = { }
LPH_JIT_MAX(function ()
    local disablers do
        local layer = anti_aim.new('Disablers', 124)
    
        callbacks['Randomization']['setup_command']:set(function (cmd, lp, valid)
            if not vars.aa.disablers.value or not valid then
                return
            end
    
            local game_rules = entity.get_game_rules()
            if game_rules == nil then
                return
            end
    
            if entity.get_prop(game_rules, 'm_bWarmupPeriod') == 0 then
                return
            end
    
            layer:tick()
    
            layer.enabled[1] = false
    
            layer:run()
        end)
    end
    
    do
        manuals = {
            reset = 0,
            yaw = 0,
    
            items = {
                [ vars.aa.manual.left.ref ] = {
                    yaw = 1,
                    state = false,
                },
    
                [ vars.aa.manual.right.ref ] = {
                    yaw = 2,
                    state = false,
                },
    
                [ vars.aa.manual.forward.ref ] = {
                    yaw = 3,
                    state = false,
                },
    
                [ vars.aa.manual.reset.ref ] = {
                    yaw = 0,
                    state = false,
                }
            },
    
            degree = {
                -90,
                90,
                180,
                0
            }
        }
    
        for manual in next, manuals.items do
            ui.set(manual, 'Toggle')
        end
    
        local layer = anti_aim.new('Manual Yaw', 5)
    
        callbacks['Manual Yaw']['setup_command']:set(function (cmd, lp, valid)
            defines.functions.manual = false
            if not vars.aa.manual.main.value then
                manuals.yaw = 0
                return
            end
    
            for key, value in pairs(manuals.items) do
                local state, mode = ui.get(key)
    
                if state == value.state then
                    goto skip
                end
    
                value.state = state
    
                if mode == 1 then
                    manuals.yaw = state and value.yaw or manuals.reset
                    goto skip
                end
    
                if mode == 2 then
                    if manuals.yaw == value.yaw then
                        manuals.yaw = manuals.reset
                    else
                        manuals.yaw = value.yaw
                    end
    
                    goto skip
                end
    
                ::skip::
            end
    
            local manual_yaw = manuals.degree[ manuals.yaw ]
            if manual_yaw == nil then
                return
            end
    
            layer:tick()
    
            layer.enabled[1] = true
            layer.yaw_base[1] = 'Local view'
            layer.yaw[2] = manual_yaw
    
            if vars.aa.manual.static.value then
                layer.yaw_modifier[1] = 'Off'
                layer.body_yaw[1] = 'Static'
                layer.body_yaw[2] = 120
            end
    
            layer.freestanding[1] = false
    
            defines.functions.manual = true
    
            layer:run()
        end)
    end
    
    local legit_aa do
        local function is_nearby(lp_origin, entities)
            for _, ent in next, entities do
                local origin = vector(entity.get_origin(ent))
    
                if lp_origin:dist(origin) < 128 then
                    return true
                end
            end
    
            return false
        end
    
        local entities = { 'CHostage', 'CPlantedC4' }
        local tick = -1
    
        local layer = anti_aim.new('Legit AA', 6)
    
        callbacks['Legit AA']['setup_command']:set(function (cmd, me, alive)
            defines.functions.legit = false
            if not vars.aa.legit.value or not alive then
                return
            end
    
            if cmd.in_use == 0 then
                tick = -1
                return
            end
    
            local weapon = entity.get_player_weapon(me)
            if weapon == nil then
                return
            end
    
            local classname = entity.get_classname(weapon)
            if classname == 'CC4' then
                return
            end
    
            local my_origin = vector(entity.get_origin(me))
            if my_origin == nil then
                return
            end
    
            for i = 1, #entities do
                if is_nearby(my_origin, entity.get_all(entities[ i ])) then
                    return
                end
            end
    
            if tick == -1 then
                tick = globals.tickcount() + 1
            end
    
            if entity.get_prop(me, 'm_bInBombZone') == 1 then
                cmd.in_use = 0
            else
                cmd.in_use = tick > globals.tickcount() and 1 or 0
            end
    
            layer:tick()
    
            layer.enabled[1] = true
            layer.pitch[1] = 'Off'
            layer.yaw_base[1] = 'Local view'
            layer.yaw[1] = '180'
            layer.yaw[2] = 180
            layer.freestanding[1] = false
    
            layer:run()
    
            defines.functions.legit = true
        end)
    end
    
    local defensive_aa do
        defensive_aa = { }
        local layer = anti_aim.new('Defensive', 7)
    
        local modes = {
            ['Double Tap'] = reference.RAGE.double_tap,
            ['Hide Shots'] = reference.RAGE.hide_shots
        }
    
        local manual_offsets = {
            [1] = 90,
            [2] = -90,
            [3] = 0
        }
    
        callbacks['Defensive']['setup_command']:set(function (cmd, lp, valid)
            if not vars.aa.defensive.main.value then
                return
            end
    
            local work_on_mode = false
            for idx, mode in next, vars.aa.defensive.mode.value do
                if modes[ mode ] and ui.get(modes[ mode ][ 2 ]) then
                    work_on_mode = true
                    break
                end
            end
    
            local double_tap = exploit.get()
    
            if not work_on_mode or not double_tap.shift then
                return
            end
    
            local should_work = false
            local on_peek = false
            for _, condition in next, vars.aa.defensive.conditions.value do
                if condition == 'On Peek' then
                    should_work = true
                    on_peek = true
                    break
                else
                    if condition == lp_info.condition then
                        should_work = true
                        break
                    end
                end
            end
    
            if not should_work then
                return
            end
    
            if not on_peek then
                cmd.force_defensive = true
            end
    
            local manual_yaw = manuals.yaw
            local should_flick = vars.aa.manual.defensive.value and lp_info.condition == 'Crouch'
            local should_skip = reference.is_freestanding() or (manual_yaw ~= 0 and not should_flick)
    
            local pitch_value, pitch_mode = 0, 'Default'
            do
                local val = vars.aa.defensive.pitch.value
                if val == 'Zero' then
                    pitch_value, pitch_mode = 0, 'Custom'
                elseif val == 'Up' then
                    pitch_mode = 'Up'
                elseif val == 'Up-Switch' then
                    pitch_value, pitch_mode = client.random_float(45, 65) * -1, 'Custom'
                elseif val == 'Down-Switch' then
                    pitch_value, pitch_mode = client.random_float(45, 65), 'Custom'
                elseif val == 'Random' then
                    pitch_value, pitch_mode = client.random_float(-89, 89), 'Custom'
                end
    
                if manual_yaw ~= 0 and should_flick then
                    pitch_value, pitch_mode = client.random_float(-5, 10), 'Custom'
                end
            end
    
            local yaw_value, yaw_mode = 0, '180'
            do
                local val = vars.aa.defensive.yaw.value
                if val == 'Sideways' then
                    yaw_value = lp_info.choking * 90 + client.random_float(-30, 30)
                elseif val == 'Forward' then
                    yaw_value = lp_info.choking * 180 + client.random_float(-30, 30)
                elseif val == 'Spinbot' then
                    yaw_value = -180 + (globals.tickcount() % 9) * 40 + client.random_float(-30, 30)
                elseif val == 'Random' then
                    yaw_value = client.random_float(-180, 180)
                end
    
                if manual_yaw ~= 0 and should_flick then
                    yaw_value = manual_offsets[ manual_yaw ] + client.random_float(0, 10)
                end
            end
    
            if should_skip or defines.functions.backstab or not vars.aa.defensive.apply.value then
                return
            end
    
            layer:tick()
    
            layer.enabled[1] = true
    
            if should_flick then
                layer.body_yaw[1] = 'Static'
                layer.body_yaw[2] = 180
            end
    
            if globals.tickcount() > double_tap.defensive_tick - 2 then
                return
            end
    
            layer.pitch[1] = pitch_mode
            layer.pitch[2] = pitch_value
    
            layer.yaw[1] = yaw_mode
            layer.yaw[2] = utilities.normalize(yaw_value)
    
            layer:run()
        end)
    end
    
    local anti_backstab do
        local layer = anti_aim.new('Anti Backstab', 24)
    
        callbacks['Anti Backstab']['setup_command']:set(function (cmd, lp, valid)
            defines.functions.backstab = false
            if not vars.aa.backstab.value or not valid then
                return
            end
    
            if defines.functions.legit then
                return
            end
    
            local target = {
                ent = nil,
                distance = 220
            }
    
            local eye = vector(client.eye_position())
            local enemies = entity.get_players(true)
    
            for _, ent in pairs(enemies) do
                local weapon = entity.get_player_weapon(ent)
                if weapon == nil then
                    goto skip
                end
    
                local weapon_name = entity.get_classname(weapon)
                if weapon_name ~= 'CKnife' then
                    goto skip
                end
    
                local origin = vector(entity.get_origin(ent))
                local distance = eye:dist(origin)
    
                if distance > target.distance then
                    goto skip
                end
    
                target.ent = ent
                target.distance = distance
                ::skip::
            end
    
            if not target.ent then
                return
            end
    
            local origin = vector(entity.get_origin(target.ent))
            local delta = eye - origin
            local angle = vector(delta:angles())
            local camera = vector(client.camera_angles())
            local yaw = utilities.normalize(angle.y - camera.y)
    
            layer:tick()
    
            layer.enabled[1] = true
            layer.yaw_base[1] = 'Local view'
            layer.yaw[2] = yaw
    
            layer:run()
    
            defines.functions.backstab = true
        end)
    end
    
    local fs_disablers do
        local layer = anti_aim.new('Freestanding', 3)
    
        callbacks['Freestanding']['setup_command']:set(function (cmd, lp, valid)
            if not vars.aa.freestanding.main.value or not valid then
                return
            end
    
            layer:tick()
    
            local condition = anti_aim.condition(false)
            local should_disable = false
            for _, item in next, vars.aa.freestanding.disablers.value do
                if item == condition then
                    should_disable = true
                    break
                end
            end
    
            local is_active, key = vars.aa.freestanding.main:get_hotkey()
    
            layer.freestanding[1] = not should_disable and is_active
            reference.AA.angles.freestanding[1].hotkey:override(is_active and { 'Always on', 0 } or nil)
    
            layer:run()
        end)
    end
    
    local fast_ladder do
        callbacks['Fast Ladder']['setup_command']:set(function (cmd, lp, valid)
            if not vars.misc.ladder.value or not valid then
                return
            end
    
            if entity.get_prop(lp, 'm_MoveType') ~= 9 then
                return
            end
    
            local weapon = entity.get_player_weapon(lp)
            if weapon == nil then
                return
            end
    
            local throw_time = entity.get_prop(weapon, 'm_fThrowTime')
    
            if throw_time ~= nil and throw_time ~= 0 then
                return
            end
    
            if cmd.forwardmove > 0 then
                if cmd.pitch < 45 then
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
            elseif cmd.forwardmove < 0 then
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
        end)
    end
    
    local safe_head do
        safe_head = {
            presets = {
                ['Stand'] = {
                    [3] = {
                        offset = 5,
    
                        inverter = false,
    
                        left_limit = 20,
                        right_limit = 20
                    },
    
                    [2] = {
                        offset = 0,
    
                        inverter = false,
    
                        left_limit = 20,
                        right_limit = 25
                    }
                },
    
                ['Crouch'] = {
                    [3] = {
                        offset = -5,
    
                        inverter = true,
    
                        left_limit = 35,
                        right_limit = 60
                    },
    
                    [2] = {
                        offset = 17,
    
                        inverter = false,
    
                        left_limit = 20,
                        right_limit = 26
                    }
                },
    
                ['Air Crouch'] = {
                    [3] = {
                        offset = 0,
    
                        inverter = false,
    
                        left_limit = 25,
                        right_limit = 25
                    },
    
                    [2] = {
                        offset = 0,
    
                        inverter = false,
    
                        left_limit = 25,
                        right_limit = 25
                    }
                },
    
                ['CKnife'] = {
                    [3] = {
                        offset = 0,
    
                        inverter = true,
    
                        left_limit = 60,
                        right_limit = 60
                    },
    
                    [2] = {
                        offset = 0,
    
                        inverter = true,
    
                        left_limit = 60,
                        right_limit = 60
                    }
                },
    
                ['CWeaponTaser'] = {
                    [3] = {
                        offset = 23,
    
                        inverter = false,
    
                        left_limit = 60,
                        right_limit = 30
                    },
    
                    [2] = {
                        offset = 17,
    
                        inverter = false,
    
                        left_limit = 20,
                        right_limit = 60
                    }
                }
            },
    
            weapon = false,
            on_condition = false,
            is_air_weapon = false
        }
    
        local layer = anti_aim.new('Safe Head', 15)
    
        callbacks['Safe Head']['setup_command']:set(function (cmd, lp, valid)
            defines.functions.safe = false
            safe_head.weapon = false
    
            if #vars.aa.safe.value == 0 or defines.functions.legit or manuals.yaw ~= 0 then
                return
            end
    
            safe_head.on_condition = false
            safe_head.is_air_weapon = false
            safe_head.classname = 0
    
            local condition = lp_info.condition
    
            if condition == 'Air' or condition == 'Air Crouch' and not safe_head.on_condition then
                local weapon = entity.get_player_weapon(lp)
    
                if weapon then
                    local classname = entity.get_classname(weapon)
                    safe_head.classname = classname
                    if classname == 'CKnife' then
                        safe_head.on_condition = vars.aa.safe:get('Air Knife')
                    elseif classname == 'CWeaponTaser' then
                        safe_head.on_condition = vars.aa.safe:get('Air Zeus')
                    end
    
                    safe_head.is_air_weapon = true
                end
            end
    
            if not safe_head.on_condition then
                for _, condition in next, vars.aa.safe.value do
                    if lp_info.condition == condition then
                        safe_head.on_condition = true
                        break
                    end
                end
            end
    
            if not safe_head.on_condition then
                return
            end
    
            defines.functions.safe = safe_head.is_air_weapon
    
            if not defines.functions.safe then
                local start = vector(entity.get_origin(lp))
                local player = client.current_threat()
                local z_origin = 0
    
                if player and entity.is_alive(player) then
                    local eye_pos = utilities.extrapolate(player, vector(utilities.get_eye_position(player)))
                    local head_pos = vector(entity.hitbox_position(lp, 0))
                    eye_pos.z = eye_pos.z + 5
    
                    if head_pos.z > eye_pos.z then
                        local entindex, damage = client.trace_bullet(player, eye_pos.x, eye_pos.y, eye_pos.z, head_pos.x, head_pos.y, head_pos.z + 6, player)
    
                        defines.functions.safe = damage > 0
                    end
                end
            end
    
            safe_head.weapon = safe_head.is_air_weapon
    
            layer:tick()
    
            if defines.functions.safe then
                local current_preset = safe_head.is_air_weapon and safe_head.presets[ safe_head.classname ] or safe_head.presets[ lp_info.condition ]
                if not current_preset then
                    return
                end
    
                local preset_for_team = current_preset[ entity.get_prop(lp, 'm_iTeamNum') ]
                if not preset_for_team then
                    return
                end
    
                layer.enabled[1] = true
                layer.yaw_base[1] = 'At targets'
                layer.yaw[2] = preset_for_team.offset
                layer.yaw_modifier[1] = 'Off'
                layer.body_yaw[1] = 'Static'
                layer.body_yaw[2] = preset_for_team.inverter and -120 or 120
            end
    
            layer:run()
        end)
    end
    
    local builder do
        local layer = anti_aim.new('Builder', 1)
        local randomized_val = 0
    
        callbacks['Builder']['setup_command']:set(function (cmd, lp, valid)
            if vars.angles.type.value ~= 'Builder' or not valid then
                return
            end
        
            local condition = anti_aim.condition(vars.conditions[ 'Fake Lag' ].enabled.value)
            if not vars.conditions[ condition ].enabled.value then
                condition = 'Global'
            end
        
            layer:tick()
        
            local yaw = vars.conditions[ condition ].yaw.value
            local yaw_offset = vars.conditions[ condition ].yaw_offset.value
        
            local yaw_modifier = vars.conditions[ condition ].yaw_modifier.value
            local yaw_modifier_offset = vars.conditions[ condition ].yaw_modifier_offset.value
            local yaw_modifier_randomize = vars.conditions[ condition ].yaw_modifier_randomize.value
        
            local body_yaw = vars.conditions[ condition ].body_yaw.value
            local body_yaw_offset = vars.conditions[ condition ].body_yaw_offset.value
        
            if yaw == '180 Left / Right' then
                yaw = '180'
        
                local inverted = lp_info.body_yaw > 0
        
                if vars.conditions[ condition ].delayed_swap.value then
                    local delay = vars.conditions[ condition ].yaw_delay.value
                    local target = delay * 2
        
                    inverted = (lp_info.chokes % target) >= delay
        
                    body_yaw = 'Static'
                    body_yaw_offset = inverted and 1 or -1
                end
        
                yaw_offset = inverted and vars.conditions[ condition ].yaw_left.value or vars.conditions[ condition ].yaw_right.value
            end
        
            if yaw_modifier_randomize ~= 0 then
                if lp_info.chokes % 2 == 0 or randomized_val == nil then
                    randomized_val = client.random_int(0, (yaw_modifier_offset > 0 and 1 or -1) * yaw_modifier_randomize)
                end
        
                yaw_modifier_offset = utilities.normalize(yaw_modifier_offset + randomized_val)
            end
        
            layer.enabled[1] = true
            layer.pitch[1] = vars.conditions[ condition ].pitch.value
            layer.pitch[2] = vars.conditions[ condition ].pitch_value.value
        
            layer.yaw_base[1] = vars.conditions[ condition ].yaw_base.value
            layer.yaw[1] = yaw
            layer.yaw[2] = utilities.normalize(yaw_offset)
        
            layer.yaw_modifier[1] = yaw_modifier
            layer.yaw_modifier[2] = yaw_modifier_offset
        
            layer.body_yaw[1] = body_yaw
            layer.body_yaw[2] = body_yaw_offset
            layer.freestanding_byaw[1] = vars.conditions[ condition ].freestanding.value
        
            layer:run()
        end)
    end
    
    local presets do
        presets = { }
    
        local layer = anti_aim.new('Presets', 2)
        local randomized_val = 0
    
        function presets.copy()
            local config = configs.instance:save('conditions')
            if config == nil then
                return
            end
    
            local success, packed = pcall(msgpack.pack, config)
            if not success then
                return
            end
    
            local success, encoded = pcall(base64.encode, packed)
            if not success then
                return
            end
    
            clipboard.set(encoded)
    
            return encoded
        end
    
        function presets.parse(str, menu)
            local succees, decoded = pcall(base64.decode, str)
            if not succees then
                return
            end
    
            local succees, data = pcall(msgpack.unpack, decoded)
            if not succees then
                return
            end
    
            if menu then
                configs.instance:load(data)
            end
    
            return data.conditions
        end
    
        presets.default = presets.parse('gapjb25kaXRpb25ziaRNb3Zl3gAUs3lhd19tb2RpZmllcl9vZmZzZXQ+pXBpdGNop01pbmltYWyqeWF3X29mZnNldACpYWNpZF9tb2RlpTItV2F5r2JvZHlfeWF3X29mZnNldNDYrGZyZWVzdGFuZGluZ8KpYWNpZF9zYWZlwqh5YXdfbW9kZa5JbnZlcnRlciBCYXNlZKh5YXdfYmFzZapBdCB0YXJnZXRzqmFjaWRfZGVsYXkFqXlhd19kZWxheQWjeWF3ozE4MKphY2lkX2N5Y2xlBahib2R5X3lhd6ZKaXR0ZXKrcGl0Y2hfdmFsdWUArHlhd19tb2RpZmllcqZDZW50ZXKoeWF3X2xlZnTQ3KdlbmFibGVkw6l5YXdfcmlnaHQktnlhd19tb2RpZmllcl9yYW5kb21pemUPqVNsb3cgV2Fsa94AFLN5YXdfbW9kaWZpZXJfb2Zmc2V0HqVwaXRjaKdEZWZhdWx0qnlhd19vZmZzZXQAqWFjaWRfbW9kZaUyLVdhea9ib2R5X3lhd19vZmZzZXTQ2KxmcmVlc3RhbmRpbmfCqWFjaWRfc2FmZcKoeWF3X21vZGWuSW52ZXJ0ZXIgQmFzZWSoeWF3X2Jhc2WqQXQgdGFyZ2V0c6phY2lkX2RlbGF5Bal5YXdfZGVsYXkFo3lhd7AxODAgTGVmdCAvIFJpZ2h0qmFjaWRfY3ljbGUFqGJvZHlfeWF3pkppdHRlcqtwaXRjaF92YWx1ZQCseWF3X21vZGlmaWVyp1NraXR0ZXKoeWF3X2xlZnT4p2VuYWJsZWTDqXlhd19yaWdodAa2eWF3X21vZGlmaWVyX3JhbmRvbWl6ZQelU3RhbmTeABSzeWF3X21vZGlmaWVyX29mZnNldB6lcGl0Y2inRGVmYXVsdKp5YXdfb2Zmc2V0AKlhY2lkX21vZGWlMi1XYXmvYm9keV95YXdfb2Zmc2V00NisZnJlZXN0YW5kaW5nwqlhY2lkX3NhZmXCqHlhd19tb2RlrkludmVydGVyIEJhc2VkqHlhd19iYXNlqkF0IHRhcmdldHOqYWNpZF9kZWxheQWpeWF3X2RlbGF5A6N5YXewMTgwIExlZnQgLyBSaWdodKphY2lkX2N5Y2xlBahib2R5X3lhd6ZKaXR0ZXKrcGl0Y2hfdmFsdWUArHlhd19tb2RpZmllcqZDZW50ZXKoeWF3X2xlZnT2p2VuYWJsZWTDqXlhd19yaWdodAq2eWF3X21vZGlmaWVyX3JhbmRvbWl6ZQ+qQWlyIENyb3VjaN4AFLN5YXdfbW9kaWZpZXJfb2Zmc2V0I6VwaXRjaKdEZWZhdWx0qnlhd19vZmZzZXQAqWFjaWRfbW9kZaUyLVdhea9ib2R5X3lhd19vZmZzZXTQ2KxmcmVlc3RhbmRpbmfCqWFjaWRfc2FmZcKoeWF3X21vZGWuSW52ZXJ0ZXIgQmFzZWSoeWF3X2Jhc2WqQXQgdGFyZ2V0c6phY2lkX2RlbGF5Bal5YXdfZGVsYXkFo3lhd7AxODAgTGVmdCAvIFJpZ2h0qmFjaWRfY3ljbGUFqGJvZHlfeWF3pkppdHRlcqtwaXRjaF92YWx1ZQCseWF3X21vZGlmaWVypkNlbnRlcqh5YXdfbGVmdPinZW5hYmxlZMOpeWF3X3JpZ2h0D7Z5YXdfbW9kaWZpZXJfcmFuZG9taXplBaNBaXLeABSzeWF3X21vZGlmaWVyX29mZnNldCilcGl0Y2inRGVmYXVsdKp5YXdfb2Zmc2V0AKlhY2lkX21vZGWlMi1XYXmvYm9keV95YXdfb2Zmc2V00NisZnJlZXN0YW5kaW5nwqlhY2lkX3NhZmXCqHlhd19tb2RlrkludmVydGVyIEJhc2VkqHlhd19iYXNlqkF0IHRhcmdldHOqYWNpZF9kZWxheQWpeWF3X2RlbGF5BaN5YXejMTgwqmFjaWRfY3ljbGUFqGJvZHlfeWF3pkppdHRlcqtwaXRjaF92YWx1ZQCseWF3X21vZGlmaWVypkNlbnRlcqh5YXdfbGVmdACnZW5hYmxlZMOpeWF3X3JpZ2h0ALZ5YXdfbW9kaWZpZXJfcmFuZG9taXplBaVVc2luZ94AFLN5YXdfbW9kaWZpZXJfb2Zmc2V0HqVwaXRjaKdEZWZhdWx0qnlhd19vZmZzZXQAqWFjaWRfbW9kZaUyLVdhea9ib2R5X3lhd19vZmZzZXTQ2KxmcmVlc3RhbmRpbmfCqWFjaWRfc2FmZcKoeWF3X21vZGWuSW52ZXJ0ZXIgQmFzZWSoeWF3X2Jhc2WqQXQgdGFyZ2V0c6phY2lkX2RlbGF5Bal5YXdfZGVsYXkFo3lhd6MxODCqYWNpZF9jeWNsZQWoYm9keV95YXemSml0dGVyq3BpdGNoX3ZhbHVlAKx5YXdfbW9kaWZpZXKnU2tpdHRlcqh5YXdfbGVmdACnZW5hYmxlZMOpeWF3X3JpZ2h0ALZ5YXdfbW9kaWZpZXJfcmFuZG9taXplFKhGYWtlIExhZ94AFLN5YXdfbW9kaWZpZXJfb2Zmc2V0CqVwaXRjaKdEZWZhdWx0qnlhd19vZmZzZXQDqWFjaWRfbW9kZaUyLVdhea9ib2R5X3lhd19vZmZzZXQArGZyZWVzdGFuZGluZ8OpYWNpZF9zYWZlwqh5YXdfbW9kZa5JbnZlcnRlciBCYXNlZKh5YXdfYmFzZapBdCB0YXJnZXRzqmFjaWRfZGVsYXkFqXlhd19kZWxheQWjeWF3ozE4MKphY2lkX2N5Y2xlBahib2R5X3lhd6hPcHBvc2l0ZatwaXRjaF92YWx1ZQCseWF3X21vZGlmaWVypk9mZnNldKh5YXdfbGVmdACnZW5hYmxlZMOpeWF3X3JpZ2h0ALZ5YXdfbW9kaWZpZXJfcmFuZG9taXplAKZHbG9iYWzeABOzeWF3X21vZGlmaWVyX29mZnNldAClcGl0Y2ijT2Zmqnlhd19vZmZzZXQAqWFjaWRfbW9kZaUyLVdhea9ib2R5X3lhd19vZmZzZXQArGZyZWVzdGFuZGluZ8KpYWNpZF9zYWZlwqh5YXdfbW9kZa5JbnZlcnRlciBCYXNlZKh5YXdfYmFzZapMb2NhbCB2aWV3qmFjaWRfZGVsYXkFqXlhd19kZWxheQWjeWF3o09mZqphY2lkX2N5Y2xlBahib2R5X3lhd6NPZmapeWF3X3JpZ2h0AKh5YXdfbGVmdACseWF3X21vZGlmaWVyo09mZqtwaXRjaF92YWx1ZQC2eWF3X21vZGlmaWVyX3JhbmRvbWl6ZQCmQ3JvdWNo3gAUs3lhd19tb2RpZmllcl9vZmZzZXQ8pXBpdGNop0RlZmF1bHSqeWF3X29mZnNldAqpYWNpZF9tb2RlpTItV2F5r2JvZHlfeWF3X29mZnNldNDYrGZyZWVzdGFuZGluZ8KpYWNpZF9zYWZlwqh5YXdfbW9kZa5JbnZlcnRlciBCYXNlZKh5YXdfYmFzZapBdCB0YXJnZXRzqmFjaWRfZGVsYXkFqXlhd19kZWxheQWjeWF3ozE4MKphY2lkX2N5Y2xlBahib2R5X3lhd6ZKaXR0ZXKrcGl0Y2hfdmFsdWUArHlhd19tb2RpZmllcqZDZW50ZXKoeWF3X2xlZnQAp2VuYWJsZWTDqXlhd19yaWdodAC2eWF3X21vZGlmaWVyX3JhbmRvbWl6ZQo=')
    
        callbacks['Presets']['setup_command']:set(function (cmd, lp, valid)
            if vars.angles.type.value ~= 'Preset' or not valid then
                return
            end
    
            local preset = presets.default
    
            local condition = anti_aim.condition(preset[ 'Fake Lag' ].enabled)
            if not preset[ condition ].enabled then
                condition = 'Global'
            end
    
            layer:tick()
    
            local yaw = preset[ condition ].yaw
            local yaw_offset = preset[ condition ].yaw_offset
    
            local yaw_modifier = preset[ condition ].yaw_modifier
            local yaw_modifier_offset = preset[ condition ].yaw_modifier_offset
            local yaw_modifier_randomize = preset[ condition ].yaw_modifier_randomize
    
            local body_yaw = preset[ condition ].body_yaw
            local body_yaw_offset = preset[ condition ].body_yaw_offset
    
            if yaw == '180 Left / Right' then
                yaw = '180'
    
                local inverted = lp_info.body_yaw > 0
    
                if preset[ condition ].delayed_swap then
                    local delay = preset[ condition ].yaw_delay
                    local target = delay * 2
    
                    inverted = (lp_info.chokes % target) >= delay
    
                    body_yaw = 'Static'
                    body_yaw_offset = inverted and 1 or -1
                end
    
                yaw_offset = inverted and preset[ condition ].yaw_left or preset[ condition ].yaw_right
            end
    
            if yaw_modifier_randomize ~= 0 then
                if lp_info.chokes % 2 == 0 or randomized_val == nil then
                    randomized_val = client.random_int(0, (yaw_modifier_offset > 0 and 1 or -1) * yaw_modifier_randomize)
                end
    
                yaw_modifier_offset = utilities.normalize(yaw_modifier_offset + randomized_val)
            end
    
            layer.enabled[1] = true
    
            layer.pitch[1] = preset[ condition ].pitch
            layer.pitch[2] = preset[ condition ].pitch_value
    
            layer.yaw_base[1] = preset[ condition ].yaw_base
            layer.yaw[1] = yaw
            layer.yaw[2] = utilities.normalize(yaw_offset)
    
            layer.yaw_modifier[1] = yaw_modifier
            layer.yaw_modifier[2] = yaw_modifier_offset
    
            layer.body_yaw[1] = body_yaw
            layer.body_yaw[2] = body_yaw_offset
            layer.freestanding_byaw[1] = preset[ condition ].freestanding
    
            layer:run()
        end)
    
        vars.angles.copy:set_callback(presets.copy)
        vars.angles.import:set_callback(function ()
            presets.parse(clipboard.get(), true)
        end)
    end
end)()

LPH_NO_VIRTUALIZE(function ()
    local indicators do
        indicators = {
            alpha = tweening.new(),
            align = tweening.new(0, easings.outCirc),
            dt = tweening.new(),
            blind = tweening.new(0, easings.outQuad),
    
            damage = tweening.new(),
            damage_num = tweening.new()
        }
    
        indicators.items = {
            {
                text = 'DT',
    
                state = function ()
                    local status, key = ui.get(reference.RAGE.double_tap[2])
                    return status
                end,
    
                clr = function ()
                    local data = exploit.get()
    
                    local color = { utilities.color_lerp(255, 0, 0, 255, 255, 255, 255, 255, indicators.dt(.2, data.shift)) }
    
                    return color
                end,
    
                alpha = tweening.new()
            },
    
            {
                text = 'OS',
    
                state = function ()
                    local status, key = ui.get(reference.RAGE.hide_shots[2])
                    return status
                end,
    
                alpha = tweening.new()
            },
    
            {
                text = 'DUCK',
    
                state = function ()
                    local status, key = reference.RAGE.fakeduck:get()
                    return status
                end,
    
                alpha = tweening.new()
            },
    
            {
                text = 'BAIM',
    
                state = function ()
                    local status, key = reference.RAGE.force_body_aim:get()
                    return status
                end,
    
                alpha = tweening.new()
            },
    
            {
                text = 'SAFE',
    
                state = function ()
                    local status, key = reference.RAGE.force_safe_point:get()
                    return status
                end,
    
                alpha = tweening.new()
            },
    
            {
                text = 'FS',
    
                state = function ()
                    local status, key = reference.AA.angles.freestanding[1]:get_hotkey()
                    return status and reference.AA.angles.freestanding[1]:get()
                end,
    
                alpha = tweening.new()
            }
        }
    
        function indicators.get_state()
            if defines.functions.backstab then
                return 'BACKSTAB'
            end
    
            if defines.functions.safe then
                return 'SAFE'
            end
    
            return lp_info.condition
        end
    
        callbacks['Indicators']['paint']:set(function (lp, valid)
            local global_alpha = indicators.alpha(.2, vars.visuals.indicators.value and valid)
            if global_alpha < 0.001 then
                return
            end
        
            local weapon = entity.get_player_weapon(lp)
            if weapon == nil then
                return
            end
        
            local c_weapon = c_weapon(weapon)
            if c_weapon == nil then
                return
            end
        
            local blind = indicators.blind(.2, c_weapon.is_grenade and 0.3 or 1)
        
            local scoped = lp and entity.get_prop(lp, 'm_bIsScoped') == 1 or false
            local scoped_anim = indicators.align(.1, not scoped)
        
            local zone = defines.screen_center:clone() do
                zone.x = zone.x + (5 - 5 * scoped_anim)
                zone.y = zone.y + 20
            end
        
            local r, g, b, a = vars.visuals.indicators:get_color()
            a = 255 * global_alpha * blind
        
            local heading = string.format('EXSCORD \a%s%s', utilities.to_hex(r, g, b, a), defines.build:upper()) do
                local heading_size = renderer.measure_text('-', heading) * .5 * scoped_anim
        
                renderer.text(zone.x - heading_size, zone.y, 255, 255, 255, a, '-', nil, heading)
                zone.y = zone.y + 8
            end
        
            local condition = string.upper(indicators.get_state()) do
                local condition_size = renderer.measure_text('-', condition) * .5 * scoped_anim
        
                renderer.text(zone.x - condition_size, zone.y, r, g, b, a, '-', nil, condition)
                zone.y = zone.y + 8
            end
        
            local offset = 0
            for _, item in next, indicators.items do
                local bind_alpha = item.alpha(.1, item.state())
                if bind_alpha < 0.001 then
                    goto skip
                end
        
                local clr = item.clr and item.clr() or { 255, 255, 255, 255 }
                local b_r, b_g, b_b = unpack(clr)
                local text_size = renderer.measure_text('-', item.text) * .5 * scoped_anim
        
                renderer.text(zone.x - text_size, zone.y + offset, b_r, b_g, b_b, a * bind_alpha, '-', nil, item.text)
                offset = offset + 8 * bind_alpha
                ::skip::
            end
        
            local damage_alpha = indicators.damage(.2, vars.visuals.damage.value)
            if damage_alpha ~= 0 then
                local damage = reference.get_damage()
                local damage_anim = indicators.damage_num(.06, damage)
                local text = damage_anim == 0 and 'AUTO' or math.floor(damage_anim)
        
                renderer.text(defines.screen_center.x + 8, defines.screen_center.y - 22, r, g, b, a * damage_alpha, '-', nil, text)
            end
        end)
    end

    local arrows do
        arrows = {
            alpha = tweening.new(),
            left = tweening.new(),
            right = tweening.new(),
            scoped = tweening.new()
        }
    
        callbacks['Arrows']['paint']:set(function (lp, valid)
            local global_alpha = arrows.alpha(.2, vars.visuals.arrows.value and valid)
            if global_alpha < 0.001 then
                return
            end
    
            local pos = defines.screen_center:clone() do
                pos.y = pos.y - 7
            end
    
            local scoped = lp and entity.get_prop(lp, 'm_bIsScoped') == 1 or false
            local scoped_anim = arrows.scoped(.1, not scoped)
            if scoped_anim < 0.001 then
                return
            end
    
            local yaw_base = manuals.yaw
            local r, g, b, a = vars.visuals.arrows:get_color()
    
            local r_l, g_l, b_l, a_l = utilities.color_lerp(200, 200, 200, 60, r, g, b, a, arrows.left(.2, yaw_base == 1))
            local r_r, g_r, b_r, a_r = utilities.color_lerp(200, 200, 200, 60, r, g, b, a, arrows.right(.2, yaw_base == 2))
    
            renderer.text(pos.x - 47, pos.y, r_l, g_l, b_l, a_l * global_alpha * scoped_anim, nil, nil, '❰')
            renderer.text(pos.x + 43, pos.y, r_r, g_r, b_r, a_r * global_alpha * scoped_anim, nil, nil, '❱')
        end)
    end
    
    local watermark do
        watermark = {
            alpha = tweening.new(),
            width = tweening.new(0, easings.outQuad),
    
            latency = nil,
            latency_update = 0,
    
            framerate = nil,
            framerate_update = 0,
    
            time = nil,
            time_update = 0
        }
    
        local framerate = 0
        local last_framerate = 0
    
        local function get_framerate()
            framerate = 0.9 * framerate + (1.0 - 0.9) * globals.absoluteframetime()
            return last_framerate
        end

        local separator = ' \a96B0BAFF|\aFFFFFFFF '
    
        callbacks['Watermark']['paint_ui']:set(function (lp, valid)
            local global_alpha = watermark.alpha(.2, vars.visuals.watermark.value and valid)
            if global_alpha < 0.001 then
                return
            end
    
            local realtime = globals.realtime()
            local items = utilities.table_convert(vars.visuals.watermark_items.value)
            local r, g, b, a = vars.visuals.watermark:get_color()
            a = 255 * global_alpha
    
            local queue = { 
                f('exs\a%scord\aFFFFFFFF', utilities.to_hex(r, g, b, a))
            }
    
            if items['Username'] then
                queue[ #queue + 1 ] = defines.user
            end
    
            if items['Latency'] then
                if not watermark.latency or realtime > watermark.latency_update then
                    watermark.latency = f('%d ms', client.real_latency() * 1000)
                    watermark.latency_update = realtime + 3
                end
    
                queue[ #queue + 1 ] = watermark.latency
            end
    
            if items['Framerate'] then
                get_framerate()
    
                if not watermark.framerate or realtime > watermark.framerate_update then
                    last_framerate = framerate > 0 and framerate or 1
    
                    watermark.framerate = f('%d fps', 1 / last_framerate)
                    watermark.framerate_update = realtime + 1
                end
    
                queue[ #queue + 1 ] = watermark.framerate
            end
    
            if items['Time'] then
                if not watermark.time or realtime > watermark.time_update then
                    watermark.time = f('%02d:%02d', client.system_time())
                    watermark.time_update = realtime + 5
                end
    
                queue[ #queue + 1 ] = watermark.time
            end
    
            local text = table.concat(queue, ' · ')
            local text_sz = renderer.measure_text(nil, text) + 9
            local width = watermark.width(.1, text_sz)
            local position = vector(defines.screen.x - width - 9, 12)
            local size = vector(width, 21)
    
            renderer.rectangle(position.x, position.y, size.x, size.y, 0, 0, 0, 150 * global_alpha)
            renderer.text(position.x + 4, position.y + 4, 255, 255, 255, 255 * global_alpha, nil, nil, text)
        end)
    end
    
    local animations do
        animations = {
            reset = false
        }
    
        function animations.backups()
            if animations.reset then
                animations.reset = false
                reference.AA.other.leg_movement:override()
            end
        end
    
        callbacks['Animation Breakers']['pre_render']:set(function (lp, valid)
            if not vars.misc.breakers.main.value or not valid then
                return animations.backups()
            end
    
            local ent = c_entity(lp)
            if ent == nil then
                return animations.backups()
            end
    
            if lp_info.move_type == 8 or lp_info.move_type == 9 then
                return animations.backups()
            end
    
            if lp_info.on_ground and not lp_info.air then
                local mode = vars.misc.breakers.ground.value
                if mode ~= 'Disabled' then
                    if mode == 'Static' then
                        entity.set_prop(lp, 'm_flPoseParameter', 1, 0)
                        reference.AA.other.leg_movement:override('Always slide')
                        animations.reset = true
                    elseif mode == 'Walking' then
                        entity.set_prop(lp, 'm_flPoseParameter', .5, 7)
                        reference.AA.other.leg_movement:override('Never slide')
                        animations.reset = true
                    end
                else
                    animations.backups()
                end
            else
                local mode = vars.misc.breakers.air.value
                if mode ~= 'Disabled' then
                    if mode == 'Static' then
                        entity.set_prop(lp, 'm_flPoseParameter', 1, 6)
                    elseif mode == 'Walking' then
                        local animlayer = ent:get_anim_overlay(6)
                        animlayer.weight = 1
                    end
                end
            end
    
            local global = vars.misc.breakers.global.value
    
            if #global ~= 0 then
                local convert = utilities.table_convert(global)
    
                if convert['Static Legs on Slow Walk'] and reference.is_slowwalk() then
                    entity.set_prop(lp, 'm_flPoseParameter', 0, 9)
                end
    
                if convert['Zero Pitch on Land'] and lp_info.landing then
                    entity.set_prop(lp, 'm_flPoseParameter', .5, 12)
                end
            end
        end)
    end

    local clantag do
        clantag = { }
    
        local clantag_prefix = '\t'
        local clantag_suffix = '\t'
        local clantag_index = -1
        local clantag_array = ''
    
        function clantag.build(x)
            local temp = { }
            local len = #x
    
            if len < 2 then
                table.insert(temp, x)
                return temp
            end
    
            for i = 1, 8 do
                table.insert(temp, string.format('%s%s%s', clantag_prefix, x, clantag_suffix))
            end
    
            for i = 1, len do
                local part = x:sub(i, len)
                table.insert(temp, string.format('%s%s%s', clantag_prefix, part, clantag_suffix))
            end
    
            table.insert(temp, string.format('%s%s', clantag_prefix, clantag_suffix))
    
            for i = math.min(2, len), len do
                local part = x:sub(1, i)
                table.insert(temp, string.format('%s%s%s', clantag_prefix, part, clantag_suffix))
            end
    
            for i = 1, 4 do
                table.insert(temp, string.format('%s%s%s', clantag_prefix, x, clantag_suffix))
            end
    
            return temp
        end
    
        local clantag_array = clantag.build('exscord')
    
        callbacks['Clantag']['net_update_end']:set(function (me, alive)
            if not vars.misc.clantag.value then
                return
            end
    
            if me == nil or entity.get_prop(me, 'm_iTeamNum') == 0 then
                return
            end
    
            local latency = client.real_latency() / globals.tickinterval()
            local predicted = globals.tickcount() + latency
    
            local idx = math.floor(predicted * 0.0625) % #clantag_array + 1
    
            if idx == clantag_index then
                return
            end
    
            clantag_index = idx
    
            client.set_clan_tag(clantag_array[ idx ] or '')
        end)
    end
end)()

LPH_NO_VIRTUALIZE(function ()
    do
        local function get_body_yaw(animstate)
            local body_yaw = animstate.eye_angles_y - animstate.goal_feet_yaw
            body_yaw = utilities.normalize(body_yaw)
    
            return body_yaw
        end
    
        local pre_flags, post_flags = 0, 0
    
        function lp_info.pre_predict_command(e, me)
            pre_flags = entity.get_prop(me, 'm_fFlags')
        end
    
        function lp_info.predict_command(e, me)
            post_flags = entity.get_prop(me, 'm_fFlags')
        end
    
        function lp_info.net_update_end(me, valid)
            local data = c_entity(me)
            if data == nil then
                return
            end
    
            local animstate = c_entity.get_anim_state(data)
            if animstate == nil then
                return
            end
    
            local chokedcommands = globals.chokedcommands()
    
            local m_fFlags = entity.get_prop(me, 'm_fFlags')
            local m_movetype = entity.get_prop(me, 'm_movetype')
            local m_flDuckAmount = entity.get_prop(me, 'm_flDuckAmount')
    
            if chokedcommands == 0 then
                lp_info.chokes = lp_info.chokes + 1
                lp_info.choking = lp_info.choking * -1
                lp_info.body_yaw = get_body_yaw(animstate)
            end
    
            lp_info.flags = m_fFlags
            lp_info.movetype = m_movetype
            lp_info.velocity = animstate.m_velocity
            lp_info.is_moving = lp_info.velocity > 5
            lp_info.on_ground = animstate.on_ground
            lp_info.ducking = m_flDuckAmount > .89
            lp_info.landing = animstate.hit_in_ground_animation and lp_info.on_ground and not lp_info.air
            lp_info.air = bit.band(pre_flags, post_flags, 1) == 0
        end
    
        callbacks['Localplayer']['net_update_end']:set(lp_info.net_update_end)
        callbacks['Localplayer']['pre_predict_command']:set(lp_info.pre_predict_command)
        callbacks['Localplayer']['predict_command']:set(lp_info.predict_command)
        callbacks['Anti Aim']['setup_command']:set(function (cmd, me, valid)
            exploit.setup_command(cmd, me)
            anti_aim.on_cm()
            lp_info.condition = anti_aim.condition(false)
        end)
    end
end)()

LPH_NO_VIRTUALIZE(function ()
    do
        local name = 'exscord (ʘ‿ʘ)ノ✿'
    
        local cache = { }
        for w in string.gmatch(name, '.[\128-\191]*') do
            cache[ #cache + 1 ] = {
                w = w,
                n = 0,
                d = false,
                p = { 0 }
            }
        end
    
        local function linear(t, d, s)
            t[ 1 ] = utilities.clamp(t[ 1 ] + (globals.frametime() * s * (d and 1 or -1)), 0, 1)
            return t[ 1 ]
        end
    
        callbacks['Sidebar']['paint_ui']:set(function ()
            if not ui.is_menu_open() then
                return
            end
    
            local result = { }
            local sidebar, accent = { 150, 176, 186, 255 }, { reference.MISC.color:get() }
            local realtime = globals.realtime()
    
            for i, v in ipairs(cache) do
                if realtime >= v.n then
                    v.d = not v.d
                    v.n = realtime + client.random_float(1, 3)
                end
    
                local alpha = linear(v.p, v.d, 1)
                local r, g, b, a = utilities.color_lerp(sidebar[1], sidebar[2], sidebar[3], sidebar[4], accent[1], accent[2], accent[3], accent[4], math.min(alpha + 0.5, 1))
    
                result[ #result + 1 ] = f('\a%02x%02x%02x%02x%s', r, g, b, 200 * alpha + 55, v.w)
            end
    
            vars.selection.label:set(table.concat(result))
        end)
    end
end)()

print_format('\vexscord \r· welcome, \v%s\r branch: \v%s\r, load time: \v%d \rms', defines.user:lower(), defines.build:lower(), client.timestamp() - timer)