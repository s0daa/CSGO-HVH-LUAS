-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local ffi = require 'ffi'
local vector = require 'vector'
local inspect = require 'gamesense/inspect'

local pui = require 'gamesense/pui'
local websockets = require 'gamesense/websockets'
local base64 = require 'gamesense/base64'
local c_entity = require 'gamesense/entity'
local c_weapon = require 'gamesense/csgo_weapons'
local msgpack = require 'gamesense/msgpack'

local f = string.format

local obex_data = obex_fetch and obex_fetch() or {
    username = 'admin',
    build = 'Debug'
}

local defines = {
    user = obex_data.username,
    build = obex_data.build,

    dev = obex_data.username == 'admin',

    screen = vector(client.screen_size()),
    screen_center = vector(client.screen_size()) / 2,

    accent = { 192, 168, 255, 255 },

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

local lp_info do
    lp_info = { }

    lp_info.velocity = 0
    lp_info.is_moving = false
    lp_info.on_ground = false
    lp_info.ducking = false
    lp_info.landing = false
    lp_info.choking = 1
    lp_info.body_yaw = 0
    lp_info.inverted = false
    lp_info.chokes = 0
    lp_info.condition = 'Idling'
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
    callbacks.DEV_MODE = true

    local reports do
        reports = { }

        local function generate_signature(username, secretKey)
            return md5.sumhexa(string.format('reports-%s%s',
                username,
                secretKey
            ))
        end

        local already_reported = { }

        function reports.send(username, report, callback)
            if already_reported[callback] then
                return false
            end

            already_reported[callback] = true

            local signature = generate_signature(username, '99w2HabpkgfgUY')

            -- http:post('https://mentally-stable.dev/reports')

            -- network.post('https://mentally-stable.dev/reports',
            -- {
            --     ['username']    = username,
            --     ['signature']   = signature,
            --     ['report']      = report
            -- },
            -- {
            --     ['Content-Type'] = 'application/json'
            -- },
            -- function(...) end)
        end

        function reports.markup(callback, event, err)
            return string.format('\n\nUsername: <b>%s</b>\nCallback: <b>%s</b> (%s)\n\n<b>Error:</b>\n<code>%s</code>', defines.user, callback, event, err)
        end
    end

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
                    if not callbacks.DEV_MODE then
                        callback = function (ctx)
                            local status, result

                            if ctx == nil then
                                status, result = pcall(fun, data.local_player, data.is_valid)
                            else
                                status, result = pcall(fun, ctx, data.local_player, data.is_valid)
                            end

                            if not status then
                                return reports.send(defines.user, reports.markup(self.name, index, result), self.name)
                            end

                            return result
                        end
                    else
                        callback = function (ctx)
                            if ctx == nil then
                                return fun(data.local_player, data.is_valid)
                            else
                                return fun(ctx, data.local_player, data.is_valid)
                            end
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
        min_damage_override = {pui.reference('RAGE', 'Aimbot', 'Minimum damage override')},
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

        if not lp_info.on_ground then
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
        local simtime = toticks(entity.get_prop(me, "m_flSimulationTime"))

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

    function utilities.color_lerp(r1, g1, b1, a1, r2, g2, b2, a2, t)
        local r = utilities.lerp(r1, r2, t)
        local g = utilities.lerp(g1, g2, t)
        local b = utilities.lerp(b1, b2, t)
        local a = utilities.lerp(a1, a2, t)

        return r, g, b, a
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
        return string.format('%02x%02x%02x%02x', r, g, b, a or 255)
    end

    function utilities.format(str, r, g, b, a)
        if type(str) ~= 'string' then
            return str
        end

        str = string.gsub(str, '[\v\r]', {
            ['\v'] = r and '\a' .. utilities.to_hex(r, g, b, a) or '\a' .. pui.accent,
            ['\r'] = '\aCDCDCDFF'
        })

        return str
    end
end

local printc do
    local hex_to_rgb = function( hex )
        hex = hex:gsub('#', '')
        return tonumber('0x' .. hex:sub(1, 2)), tonumber('0x' .. hex:sub(3, 4)), tonumber('0x' .. hex:sub(5, 6))
    end

	printc = function (...)
		for i, v in ipairs{...} do
			local r = "\aD9D9D9" .. v
			for col, text in r:gmatch("\a(%x%x%x%x%x%x)([^\a]*)") do
                local r, g, b = hex_to_rgb(col)
				client.color_log(r, g, b, string.format('%s\0', text))
			end
            client.color_log(255, 255, 255, '\n\0')
		end
	end
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

local vars do
    vars = { }

    pui.macros.dot = '\v•  \r'

    local ui_group = pui.group('AA', 'Fake lag')
    local group = pui.group('AA', 'Anti-aimbot angles')

    local selection do
        vars.selection = { }

        vars.selection.label = ui_group:label(string.format('\f<dot>exscord · %s · %s', defines.user, defines.build))
        --vars.selection.online = ui_group:label('')

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
            vars.rage.logger.hit = group:label('\f<dot>Hit Color', { 150, 200, 60, 255 }):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.logger.main, { vars.rage.logger.events, 'Aimbot Shots', 'Damage Dealt' })
            vars.rage.logger.miss = group:label('\f<dot>Miss Color', { 255, 25, 25, 255 }):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.logger.main, { vars.rage.logger.events, 'Aimbot Shots' })
            vars.rage.logger.purchase = group:label('\f<dot>Purchases Color', { 255, 25, 25, 255 }):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.logger.main, { vars.rage.logger.events, 'Purchases' })
        end

        do
            vars.rage.hitchance = { }

            local weapons = { 'Auto', 'SSG-08', 'AWP', 'R8 Revolver' }

            vars.rage.hitchance.main = group:checkbox('Custom Hitchance'):depend({ vars.selection.tab, 'Ragebot' })
            vars.rage.hitchance.weapons = group:combobox('\f<dot>Weapons', weapons):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.hitchance.main)

            for _, weapon in next, weapons do
                vars.rage.hitchance[ weapon ] = { }
                vars.rage.hitchance[ weapon ].enabled = group:checkbox(f('Override %s', weapon)):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.hitchance.main, { vars.rage.hitchance.weapons, weapon })
                vars.rage.hitchance[ weapon ].conditions = group:multiselect(f('\f<dot>Conditions \n%s', weapon), { 'No Scope', 'In Air' }):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.hitchance.main, { vars.rage.hitchance.weapons, weapon }, vars.rage.hitchance[ weapon ].enabled)
                vars.rage.hitchance[ weapon ].distance = group:slider(f('\f<dot>Distance \n%s', weapon), 100, 1001, 500, true, 'm', 0.01, { [1001] = 'Inf.' }):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.hitchance.main, { vars.rage.hitchance.weapons, weapon }, vars.rage.hitchance[ weapon ].enabled, { vars.rage.hitchance[ weapon ].conditions, 'No Scope' })
                vars.rage.hitchance[ weapon ].noscope = group:slider(f('\f<dot>No Scope \n%s', weapon), 1, 100, 50, true, '%'):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.hitchance.main, { vars.rage.hitchance.weapons, weapon }, vars.rage.hitchance[ weapon ].enabled, { vars.rage.hitchance[ weapon ].conditions, 'No Scope' })
                vars.rage.hitchance[ weapon ].air = group:slider(f('\f<dot>In Air \n%s', weapon), 1, 100, 50, true, '%'):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.hitchance.main, { vars.rage.hitchance.weapons, weapon }, vars.rage.hitchance[ weapon ].enabled, { vars.rage.hitchance[ weapon ].conditions, 'In Air' })
            end
        end

        do
            vars.rage.tp = { }

            vars.rage.tp.main = group:checkbox('Air Lag Exploit', 0):depend({ vars.selection.tab, 'Ragebot' })
            vars.rage.tp.ticks = group:slider('\f<dot>Ticks', 1, 30, 18, true, 't'):depend({ vars.selection.tab, 'Ragebot' }, vars.rage.tp.main)
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
            vars.aa.manual.defensive = group:checkbox('\f<dot>Flick on Defensive'):depend({ vars.selection.tab, 'Anti Aim' }, vars.aa.manual.main, { vars.selection.aa_tab, 'Main' })
            vars.aa.manual.left = group:hotkey('\f<dot>Left'):depend({ vars.selection.tab, 'Anti Aim' }, vars.aa.manual.main, { vars.selection.aa_tab, 'Main' })
            vars.aa.manual.right = group:hotkey('\f<dot>Right'):depend({ vars.selection.tab, 'Anti Aim' }, vars.aa.manual.main, { vars.selection.aa_tab, 'Main' })
            vars.aa.manual.forward = group:hotkey('\f<dot>Forward'):depend({ vars.selection.tab, 'Anti Aim' }, vars.aa.manual.main, { vars.selection.aa_tab, 'Main' })
            vars.aa.manual.reset = group:hotkey('\f<dot>Reset'):depend({ vars.selection.tab, 'Anti Aim' }, vars.aa.manual.main, { vars.selection.aa_tab, 'Main' })
        end

        do
            vars.aa.defensive = { }
            vars.aa.defensive.main = group:checkbox('Defensive Options'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })

            vars.aa.defensive.mode = group:multiselect('\f<dot>Mode', { 'Double Tap', 'Hide Shots' }):depend(vars.aa.defensive.main, { vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
            vars.aa.defensive.conditions = group:multiselect('\f<dot>Conditions', { 'Stand', 'Move', 'Slow Walk', 'Air', 'Air Crouch', 'Crouch', 'On Peek' }):depend(vars.aa.defensive.main, { vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
            vars.aa.defensive.pitch = group:combobox('\f<dot>Pitch', { 'Default', 'Zero', 'Up', 'Up-Switch', 'Up-Down', 'Random' }):depend(vars.aa.defensive.main, { vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
            vars.aa.defensive.yaw = group:combobox('\f<dot>Yaw', { 'Default', 'Sideways', 'Forward', 'Spinbot', 'Random' }):depend(vars.aa.defensive.main, { vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Main' })
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
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition })

                vars.conditions[ condition ].pitch_value = group:slider(f('\nPitch Value %s', condition), -89, 89, 0, true, '°')
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].pitch, 'Custom' })
            end

            do
                vars.conditions[ condition ].yaw_base = group:combobox(f('Yaw Base \n%s', condition), { 'Local view', 'At targets' })
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition })
            end

            do
                vars.conditions[ condition ].yaw = group:combobox(f('Yaw \n%s', condition), { 'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair', '180 Left / Right' })
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition })

                vars.conditions[ condition ].yaw_offset = group:slider(f('\nYaw Offset %s', condition), -180, 180, 0, true, '°')
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, '180', 'Spin', 'Static', '180 Z', 'Crosshair' })

                vars.conditions[ condition ].yaw_mode = group:combobox(f('\f<dot>Mode \n%s', condition), { 'Inverter Based', 'Delayed Switch' })
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, '180 Left / Right' })

                vars.conditions[ condition ].yaw_left = group:slider(f('\f<dot>Left Offset \n%s', condition), -180, 180, 0, true, '°')
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, '180 Left / Right' })

                vars.conditions[ condition ].yaw_right = group:slider(f('\f<dot>Right Offset \n%s', condition), -180, 180, 0, true, '°')
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, '180 Left / Right' })

                vars.conditions[ condition ].yaw_delay = group:slider(f('\f<dot>Delay \n%s', condition), 1, 10, 5, true, 't')
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, '180 Left / Right' }, { vars.conditions[ condition ].yaw_mode, 'Delayed Switch' })
            end

            do
                vars.conditions[ condition ].yaw_modifier = group:combobox(f('Yaw Modifier \n%s', condition), { 'Off', 'Offset', 'Center', 'Random', 'Skitter', 'AcidTech' })
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true })

                vars.conditions[ condition ].acid_mode = group:combobox(f('\nAcid Mode %s', condition), { '2-Way', '3-Way', '5-Way' })
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true }, { vars.conditions[ condition ].yaw_modifier, 'AcidTech' })

                vars.conditions[ condition ].yaw_modifier_offset = group:slider(f('\nModifier Offset \n%s', condition), -180, 180, 0, true, '°')
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true }, { vars.conditions[ condition ].yaw_modifier, 'Off', true })

                vars.conditions[ condition ].yaw_modifier_randomize = group:slider(f('\f<dot>Randomize \n%s', condition), 0, 180, 0, true, '°', 1, { [0] = 'Off' })
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true }, { vars.conditions[ condition ].yaw_modifier, 'Off', true })

                vars.conditions[ condition ].acid_cycle = group:slider(f('\f<dot>Delay Cycle \n%s', condition), 5, 200, 5, true, '', 1, { [5] = 'Off' })
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true }, { vars.conditions[ condition ].yaw_modifier, 'AcidTech' })

                vars.conditions[ condition ].acid_delay = group:slider(f('\f<dot>Delay Time \n%s', condition), 5, 30, 5)
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true }, { vars.conditions[ condition ].yaw_modifier, 'AcidTech' })

                vars.conditions[ condition ].acid_safe = group:checkbox(f('\f<dot>Safe Yaw \n%s', condition))
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true }, { vars.conditions[ condition ].yaw_modifier, 'AcidTech' })
            end

            do
                vars.conditions[ condition ].acid_cycle:set_callback(reset_delay)
                vars.conditions[ condition ].acid_delay:set_callback(reset_delay)
                vars.conditions[ condition ].acid_safe:set_callback(reset_delay)
            end

            do
                vars.conditions[ condition ].body_yaw = group:combobox(f('Body Yaw \n%s', condition), { 'Off', 'Opposite', 'Jitter', 'Static' })
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition })

                vars.conditions[ condition ].body_yaw_offset = group:slider(f('\nBody Yaw Offset \n%s', condition), -180, 180, 0, true, '°')
                :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].body_yaw, 'Jitter', 'Static' })
            end

            vars.conditions[ condition ].freestanding = group:checkbox(f('Freestanding Body Yaw \n%s', condition))
            :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' }, { vars.angles.condition, condition }, { vars.conditions[ condition ].body_yaw, 'Off', true })

            if vars.conditions[ condition ].enabled then
                vars.conditions[ condition ].pitch:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].pitch_value:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].yaw_base:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].yaw:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].yaw_offset:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].yaw_mode:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].yaw_left:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].yaw_right:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].yaw_delay:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].yaw_modifier:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].yaw_modifier_offset:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].yaw_modifier_randomize:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].body_yaw:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].body_yaw_offset:depend(vars.conditions[ condition ].enabled)
                vars.conditions[ condition ].freestanding:depend(vars.conditions[ condition ].enabled)
            end
        end

        if defines.dev then
            vars.angles.copy = group:button('Export'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' })
            vars.angles.import = group:button('Import'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Angles' }, { vars.angles.type, 'Builder' })
        end
    end

    local visuals do
        vars.visuals = { }

        vars.visuals.indicators = group:checkbox('Crosshair Indicators', defines.accent):depend({ vars.selection.tab, 'Visuals' })
        vars.visuals.arrows = group:checkbox('Manual Arrows', defines.accent):depend({ vars.selection.tab, 'Visuals' })
        vars.visuals.watermark = group:checkbox('Watermark', defines.accent):depend({ vars.selection.tab, 'Visuals' })
    end

    local misc do
        vars.misc = { }

        vars.misc.shared = group:checkbox('Shared Logo'):depend({ vars.selection.tab, 'Misc' })
        vars.misc.features = group:multiselect('Features', { 'Shared Logo', 'Clan Tag' }):depend({ vars.selection.tab, 'Misc' })

        local function utililize_clantag()
            if vars.misc.features:get('Clan Tag') then
                reference.MISC.clantag:override(false)
            else
                client.set_clan_tag ''
                reference.MISC.clantag:override()
            end
        end

        vars.misc.features:set_callback(utililize_clantag, true)
        reference.MISC.clantag:set_callback(utililize_clantag, true)
    end

    local configs do
        vars.configs = { }

        vars.configs.export = group:button('Export'):depend({ vars.selection.tab, 'Configs' })
        vars.configs.import = group:button('Import'):depend({ vars.selection.tab, 'Configs' })
        vars.configs.default = group:button('Default'):depend({ vars.selection.tab, 'Configs' })
    end

    local function set_skeet_ui(state)
        for _, ref in next, reference.AA.angles do
            for __, subref in next, ref do
                subref:set_visible(state)
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
    end)
end

local configs do
    configs = { }

    configs.instance = pui.setup(vars)
    configs.prefix = 'exscord:'

    function configs.export()
        local str = configs.instance:save()
        if str == nil then
            return
        end

        local success, stringified = pcall(msgpack.pack, str)
        if not success then
            return
        end

        local success, encode = pcall(base64.encode, stringified)
        if not success then
            return
        end

        return string.format('exscord:%s_exscord', encode)
    end

    function configs.import(str)
        local config = str or clipboard.get()
        if config == nil then
            return
        end

        if string.sub(config, 1, #configs.prefix) ~= configs.prefix then
            return print('Config is not compatible.')
        end

        config = config:gsub('exscord:', ''):gsub('_exscord', '')

        local success, decoded = pcall(base64.decode, config)
        if not success then
            return print('failed to decode')
        end

        local success, data = pcall(msgpack.unpack, decoded)
        if not success then
            return print('failed to parse')
        end

        configs.instance:load(data)
    end

    vars.configs.export:set_callback(function ()
        clipboard.set(configs.export())
    end)

    vars.configs.import:set_callback(function ()
        configs.import()
    end)

    function configs.startup()
        client.delay_call(.1, function ()
            configs.import(db.exscord)
        end)
    end

    callbacks['Configs']['shutdown']:set(function ()
        db.exscord = configs.export()
    end)

    configs.startup()
end

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

    function logger.clean_up(str)
        local text = str:gsub('(\a%x%x%x%x%x%x)%x%x', '%1')
        return text
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

        local target = shot.target
        if target == nil then
            return
        end

        local r, g, b = vars.rage.logger.hit:get_color()
        local health = entity.get_prop(target, 'm_iHealth')

        local info = {
            '\vexscord \r· ',
            health > 0 and 'Hit ' or 'Killed ',
            f('\v%s\r ', entity.get_player_name(target)),
            'in the ',
            shot.hitgroup ~= logger.wanted_hitgroup and f('\v%s\r (aimed: \v%s\r) ', logger.hitgroups[ shot.hitgroup ], logger.hitgroups[ logger.wanted_hitgroup ]) or f('\v%s\r ', logger.hitgroups[ shot.hitgroup ]),
            health > 0 and 'for ' or '',
            health > 0 and (shot.damage ~= logger.wanted_damage and f('\v%d\r(\v%d\r) ', shot.damage, logger.wanted_damage) or f('\v%d\r ', shot.damage)) or '',
            health > 0 and 'damage ' or '',
            logger.backtrack ~= 0 and f('(history: \v%d\r) ', logger.backtrack) or '',
            health > 0 and f('(\v%d \rhealth remaining)', health) or ''
        }

        local str = logger.clean_up(utilities.format(table.concat(info, ''), r, g, b))
        printc(str)
    end)

    callbacks['Logger']['aim_miss']:set(function (shot, lp, valid)
        if not vars.rage.logger.main.value or not valid then
            return
        end

        if not utilities.contains(vars.rage.logger.events.value, 'Aimbot Shots') then
            return
        end

        local target = shot.target
        if target == nil then
            return
        end

        local r, g, b = vars.rage.logger.miss:get_color()

        local info = {
            '\vexscord \r· ',
            'Missed at ',
            f('\v%s\r\'s ', entity.get_player_name(target)),
            f('\v%s\r(\v%d%%\r) ', logger.hitgroups[ shot.hitgroup ], shot.hit_chance or 0),
            'due to ',
            f('\v%s\r ', shot.reason),
            f('(dmg: \v%d\r | history: \v%d\r)', logger.wanted_damage or 0, logger.backtrack or 0)
        }

        local str = logger.clean_up(utilities.format(table.concat(info, ''), r, g, b))
        printc(str)
    end)

    callbacks['Logger']['player_hurt']:set(function (e, lp, valid)
        if not vars.rage.logger.main.value or not valid then
            return
        end

        if not utilities.contains(vars.rage.logger.events.value, 'Damage Dealt') then
            return
        end

        local victim = client.userid_to_entindex(e.userid)
        local attacker = client.userid_to_entindex(e.attacker)
        if victim == nil or victim == lp or attacker ~= lp then
            return
        end

        local verb = logger.weapon_verb[ e.weapon ]
        if verb == nil then
            return
        end

        local r, g, b, a = vars.rage.logger.hit:get_color()

        local info = {
            '\vexscord \r· ',
            verb,
            string.format(' \v%s\r ', entity.get_player_name(victim)),
            'for ',
            string.format('\v%s \rdamage ', e.dmg_health or 0),
            e.health ~= 0 and string.format('(\v%d \rhealth remaining)', e.health or 0) or '(\vdead\r)'
        }

        local str = logger.clean_up(utilities.format(table.concat(info, ''), r, g, b, a))
        printc(str)
    end)

    callbacks['Logger']['item_purchase']:set(function (e, lp, valid)
        if not vars.rage.logger.main.value or not valid then
            return
        end

        if not utilities.contains(vars.rage.logger.events.value, 'Purchases') then
            return
        end

        local player = client.userid_to_entindex(e.userid)
        if player == nil or not entity.is_enemy(player) then
            return
        end

        local weapon = e.weapon
        if weapon == 'weapon_unknown' then
            return
        end

        local r, g, b, a = vars.rage.logger.purchase:get_color()

        local info = {
            '\vexscord \r· ',
            string.format('\v%s\r ', entity.get_player_name(player)),
            'bought ',
            string.format('\v%s\r', weapon)
        }

        local str = logger.clean_up(utilities.format(table.concat(info, ''), r, g, b, a))
        printc(str)
    end)
end

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

local disablers do
    local layer = anti_aim.new('Disablers', 124)

    callbacks['Randomization']['setup_command']:set(function (cmd, lp, valid)
        if not vars.aa.disablers:get() or not valid then
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

local manuals do
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

        layer.yaw_base[1] = 'Local view'
        layer.yaw[2] = manual_yaw

        if vars.aa.manual.static.value then
            layer.yaw_modifier[1] = 'Off'
            layer.body_yaw[1] = 'Static'
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
        if not vars.aa.legit:get() or not alive then
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

        if entity.get_classname(weapon) == 'CC4' then
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

        cmd.in_use = tick > globals.tickcount() and 1 or 0

        layer:tick()

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
    local layer = anti_aim.new('Defensive', 3422)

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
                yaw_value = utils.normalize(math.random(-180, 180), -180, 180)
            end

            if manual_yaw ~= 0 and should_flick then
                yaw_value = manual_offsets[ manual_yaw ] + client.random_float(0, 10)
            end
        end

        if should_skip or defines.functions.backstab then
            return
        end

        layer:tick()

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
        layer.yaw[2] = yaw_value

        layer:run()
    end)
end

local air_teleport do
    air_teleport = {
        reset = false
    }

    function air_teleport.backups()
        if air_teleport.reset then
            reference.RAGE.enabled:override()
            reference.RAGE.fakeduck:override()
            reference.AA.fakelag.limit:override()
            air_teleport.reset = false
        end
    end

    callbacks['Air Teleport']['setup_command']:set(function (cmd, lp, valid)
        if not vars.rage.tp.main.value or not valid then
            return air_teleport.backups()
        end

        local is_active, key = vars.rage.tp.main:get_hotkey()
        if not is_active then
            return air_teleport.backups()
        end

        if not reference.is_doubletap() then
            return air_teleport.backups()
        end

        if lp_info.on_ground then
            return air_teleport.backups()
        end

        local exploit = exploit.get()
        reference.AA.fakelag.limit:override(15)

        if exploit.shift then
            reference.RAGE.enabled:override(true)
            cmd.discharge_pending = true
        else
            reference.RAGE.enabled:override(false)
            reference.RAGE.fakeduck:override(globals.tickcount() % vars.rage.tp.ticks:get() == 0 and { 'Always on', 0 } or nil)
        end

        air_teleport.reset = true
    end)

end

local anti_backstab do
    local layer = anti_aim.new('Anti Backstab', 24)

    callbacks['Anti Backstab']['setup_command']:set(function (cmd, lp, valid)
        defines.functions.backstab = false
        if not vars.aa.backstab:get() or not valid then
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

        layer.yaw_base[1] = 'Local view'
        layer.yaw[2] = yaw

        layer:run()

        defines.functions.backstab = true
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
                if safe_head.is_air_weapon then
                    current_preset = safe_head.presets['Other']
                else
                    return
                end
            end

            local preset_for_team = current_preset[ entity.get_prop(lp, 'm_iTeamNum') ]
            if not preset_for_team then
                return
            end

            --antiaim.body_yaw.main = true

            layer.yaw[2] = preset_for_team.offset
            layer.yaw_base[1] = 'At targets'
            layer.yaw_modifier[1] = 'Off'
            layer.body_yaw[1] = 'Static'

            -- antiaim.body_yaw.options = ''
            -- antiaim.yaw.main = 'Backward'

            -- antiaim.yaw.offset = preset_for_team.offset

            -- antiaim.body_yaw.left_limit = preset_for_team.left_limit
            -- antiaim.body_yaw.right_limit = preset_for_team.right_limit

            -- rage.antiaim:inverter(preset_for_team.inverter)
        end

        layer:run()
    end)
end

local builder do
    local layer = anti_aim.new('Builder', 1)
    local randomized_val = 0

    local acidyaw_ways = {
        ['2-Way'] = { -0.5, 0.5 },
        ['3-Way'] = { -0.5, 0, 0.5 },
        ['5-Way'] = { -0.75, 1, 0, 0.4, -0.25 }
    }

    local delay_data_all = { }

    local function reset_delay()
        for _, condition in next, defines.conditions do
            delay_data_all[ condition ] = {
                ticks = 0,
                is_active = false,
                current = 0,
                previous_angle = 0
            }
        end
    end

    reset_delay()

    callbacks['Builder']['setup_command']:set(function (cmd, lp, valid)
        if vars.angles.type.value ~= 'Builder' or not valid then
            return
        end

        local condition = anti_aim.condition(vars.conditions[ 'Fake Lag' ].enabled.value)
        if not vars.conditions[ condition ].enabled:get() then
            condition = 'Global'
        end

        layer:tick()

        local previous_add_yaw = 0
        local side = lp_info.body_yaw < 0
        local yaw = vars.conditions[ condition ].yaw:get()
        local yaw_offset = vars.conditions[ condition ].yaw_offset:get()
        local yaw_mode = vars.conditions[ condition ].yaw_mode:get()

        local yaw_modifier = vars.conditions[ condition ].yaw_modifier:get()
        local yaw_modifier_offset = vars.conditions[ condition ].yaw_modifier_offset:get()
        local yaw_modifier_randomize = vars.conditions[ condition ].yaw_modifier_randomize:get()

        local body_yaw = vars.conditions[ condition ].body_yaw:get()
        local body_yaw_offset = vars.conditions[ condition ].body_yaw_offset:get()

        if yaw == '180 Left / Right' then
            yaw = '180'

            local inverted = lp_info.body_yaw > 0

            if yaw_mode == 'Delayed Switch' then
                local delay = vars.conditions[ condition ].yaw_delay:get()
                local target = delay * 2

                inverted = (lp_info.chokes % target) >= delay

                body_yaw = 'Static'
                body_yaw_offset = inverted and 1 or -1
            end

            yaw_offset = inverted and vars.conditions[ condition ].yaw_left:get() or vars.conditions[ condition ].yaw_right:get()
        end

        if yaw_modifier_randomize ~= 0 then
            if lp_info.chokes % 2 == 0 or randomized_val == nil then
                randomized_val = client.random_int(0, (yaw_modifier_offset > 0 and 1 or -1) * yaw_modifier_randomize)
            end

            yaw_modifier_offset = utilities.normalize(yaw_modifier_offset + randomized_val)
        end

        if yaw_modifier == 'AcidTech' then
            yaw_modifier = 'Off'
            local delay_data = delay_data_all[ condition ]
            delay_data.ticks = delay_data.ticks + 1

            local mode = vars.conditions[ condition ].acid_mode:get()
            local cycle = vars.conditions[ condition ].acid_cycle:get()
            local delay = vars.conditions[ condition ].acid_delay:get()

            local ways = acidyaw_ways[mode]
            local way = ways[(lp_info.chokes % #ways) + 1]

            if cycle ~= 4 and not delay_data.is_delay and delay_data.ticks % cycle == 0 then
                delay_data.is_delay = true
            end

            local ignore_yaw = false
            if delay_data.is_delay then
                if delay_data.current < delay then
                    delay_data.current = delay_data.current + 1

                    if vars.conditions[ condition ].acid_safe:get() then
                        local current_preset = safe_head.presets[ 'Stand' ]
                        local preset_for_team = current_preset[ entity.get_prop(lp, 'm_iTeamNum') ]

                        yaw_offset = preset_for_team.offset

                        ignore_yaw = true
                    end

                    yaw_offset = yaw_offset + previous_add_yaw
                else
                    delay_data.is_delay = false
                    delay_data.ticks = 0
                    delay_data.current = 0
                    delay_data.previous_angle = 0
                    previous_add_yaw = 0
                end
            else
                local angle = 0
                if mode == '2-Way' and body_yaw == 'Jitter' then
                    angle = utilities.normalize(yaw_offset + (side and yaw_modifier_offset / 2 or yaw_modifier_offset * -1 / 2))
                else
                    angle = utilities.normalize(yaw_offset + yaw_modifier_offset * way)
                end

                delay_data.previous_angle = angle
            end

            if not ignore_yaw then
                yaw_offset = delay_data.previous_angle
            end
        else
            reset_delay()
        end

        layer.pitch[1] = vars.conditions[ condition ].pitch:get()
        layer.pitch[2] = vars.conditions[ condition ].pitch_value:get()

        layer.yaw_base[1] = vars.conditions[ condition ].yaw_base:get()
        layer.yaw[1] = yaw
        layer.yaw[2] = yaw_offset

        layer.yaw_modifier[1] = yaw_modifier
        layer.yaw_modifier[2] = yaw_modifier_offset

        layer.body_yaw[1] = body_yaw
        layer.body_yaw[2] = body_yaw_offset
        layer.freestanding_byaw[1] = vars.conditions[ condition ].freestanding:get()

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

    presets.default = presets.parse('gapjb25kaXRpb25ziaRNb3Zl3gAUs3lhd19tb2RpZmllcl9vZmZzZXQApXBpdGNoo09mZqp5YXdfb2Zmc2V0AKlhY2lkX21vZGWlMi1XYXmvYm9keV95YXdfb2Zmc2V0AKxmcmVlc3RhbmRpbmfCqWFjaWRfc2FmZcKoeWF3X21vZGWqU2lkZSBCYXNlZKh5YXdfYmFzZapMb2NhbCB2aWV3qmFjaWRfZGVsYXkFqXlhd19kZWxheQWjeWF3o09mZqphY2lkX2N5Y2xlBahib2R5X3lhd6NPZmarcGl0Y2hfdmFsdWUArHlhd19tb2RpZmllcqNPZmaoeWF3X2xlZnQAp2VuYWJsZWTCqXlhd19yaWdodAC2eWF3X21vZGlmaWVyX3JhbmRvbWl6ZQCpU2xvdyBXYWxr3gAUs3lhd19tb2RpZmllcl9vZmZzZXQApXBpdGNoo09mZqp5YXdfb2Zmc2V0AKlhY2lkX21vZGWlMi1XYXmvYm9keV95YXdfb2Zmc2V0AKxmcmVlc3RhbmRpbmfCqWFjaWRfc2FmZcKoeWF3X21vZGWqU2lkZSBCYXNlZKh5YXdfYmFzZapMb2NhbCB2aWV3qmFjaWRfZGVsYXkFqXlhd19kZWxheQWjeWF3o09mZqphY2lkX2N5Y2xlBahib2R5X3lhd6NPZmarcGl0Y2hfdmFsdWUArHlhd19tb2RpZmllcqNPZmaoeWF3X2xlZnQAp2VuYWJsZWTCqXlhd19yaWdodAC2eWF3X21vZGlmaWVyX3JhbmRvbWl6ZQClU3RhbmTeABSzeWF3X21vZGlmaWVyX29mZnNldAClcGl0Y2ijT2Zmqnlhd19vZmZzZXQAqWFjaWRfbW9kZaUyLVdhea9ib2R5X3lhd19vZmZzZXQArGZyZWVzdGFuZGluZ8KpYWNpZF9zYWZlwqh5YXdfbW9kZapTaWRlIEJhc2VkqHlhd19iYXNlqkxvY2FsIHZpZXeqYWNpZF9kZWxheQWpeWF3X2RlbGF5BaN5YXejT2ZmqmFjaWRfY3ljbGUFqGJvZHlfeWF3o09mZqtwaXRjaF92YWx1ZQCseWF3X21vZGlmaWVyo09mZqh5YXdfbGVmdACnZW5hYmxlZMKpeWF3X3JpZ2h0ALZ5YXdfbW9kaWZpZXJfcmFuZG9taXplAKpBaXIgQ3JvdWNo3gAUs3lhd19tb2RpZmllcl9vZmZzZXQApXBpdGNoo09mZqp5YXdfb2Zmc2V0AKlhY2lkX21vZGWlMi1XYXmvYm9keV95YXdfb2Zmc2V0AKxmcmVlc3RhbmRpbmfCqWFjaWRfc2FmZcKoeWF3X21vZGWqU2lkZSBCYXNlZKh5YXdfYmFzZapMb2NhbCB2aWV3qmFjaWRfZGVsYXkFqXlhd19kZWxheQWjeWF3o09mZqphY2lkX2N5Y2xlBahib2R5X3lhd6NPZmarcGl0Y2hfdmFsdWUArHlhd19tb2RpZmllcqNPZmaoeWF3X2xlZnQAp2VuYWJsZWTCqXlhd19yaWdodAC2eWF3X21vZGlmaWVyX3JhbmRvbWl6ZQCjQWly3gAUs3lhd19tb2RpZmllcl9vZmZzZXQApXBpdGNoo09mZqp5YXdfb2Zmc2V0AKlhY2lkX21vZGWlMi1XYXmvYm9keV95YXdfb2Zmc2V0AKxmcmVlc3RhbmRpbmfCqWFjaWRfc2FmZcKoeWF3X21vZGWqU2lkZSBCYXNlZKh5YXdfYmFzZapMb2NhbCB2aWV3qmFjaWRfZGVsYXkFqXlhd19kZWxheQWjeWF3o09mZqphY2lkX2N5Y2xlBahib2R5X3lhd6NPZmarcGl0Y2hfdmFsdWUArHlhd19tb2RpZmllcqNPZmaoeWF3X2xlZnQAp2VuYWJsZWTCqXlhd19yaWdodAC2eWF3X21vZGlmaWVyX3JhbmRvbWl6ZQClVXNpbmfeABSzeWF3X21vZGlmaWVyX29mZnNldAClcGl0Y2ijT2Zmqnlhd19vZmZzZXQAqWFjaWRfbW9kZaUyLVdhea9ib2R5X3lhd19vZmZzZXQArGZyZWVzdGFuZGluZ8KpYWNpZF9zYWZlwqh5YXdfbW9kZapTaWRlIEJhc2VkqHlhd19iYXNlqkxvY2FsIHZpZXeqYWNpZF9kZWxheQWpeWF3X2RlbGF5BaN5YXejT2ZmqmFjaWRfY3ljbGUFqGJvZHlfeWF3o09mZqtwaXRjaF92YWx1ZQCseWF3X21vZGlmaWVyo09mZqh5YXdfbGVmdACnZW5hYmxlZMKpeWF3X3JpZ2h0ALZ5YXdfbW9kaWZpZXJfcmFuZG9taXplAKhGYWtlIExhZ94AFLN5YXdfbW9kaWZpZXJfb2Zmc2V0AKVwaXRjaKNPZmaqeWF3X29mZnNldACpYWNpZF9tb2RlpTItV2F5r2JvZHlfeWF3X29mZnNldACsZnJlZXN0YW5kaW5nwqlhY2lkX3NhZmXCqHlhd19tb2RlqlNpZGUgQmFzZWSoeWF3X2Jhc2WqTG9jYWwgdmlld6phY2lkX2RlbGF5Bal5YXdfZGVsYXkFo3lhd6NPZmaqYWNpZF9jeWNsZQWoYm9keV95YXejT2Zmq3BpdGNoX3ZhbHVlAKx5YXdfbW9kaWZpZXKjT2ZmqHlhd19sZWZ0AKdlbmFibGVkwql5YXdfcmlnaHQAtnlhd19tb2RpZmllcl9yYW5kb21pemUApkdsb2JhbN4AE7N5YXdfbW9kaWZpZXJfb2Zmc2V0E6VwaXRjaKdEZWZhdWx0qnlhd19vZmZzZXQAqWFjaWRfbW9kZaUyLVdhea9ib2R5X3lhd19vZmZzZXTQ2KxmcmVlc3RhbmRpbmfCqWFjaWRfc2FmZcKoeWF3X21vZGWqU2lkZSBCYXNlZKh5YXdfYmFzZapBdCB0YXJnZXRzqmFjaWRfZGVsYXkFqXlhd19kZWxheQWjeWF3ozE4MKphY2lkX2N5Y2xlBahib2R5X3lhd6ZKaXR0ZXKpeWF3X3JpZ2h0AKh5YXdfbGVmdACseWF3X21vZGlmaWVyp1NraXR0ZXKrcGl0Y2hfdmFsdWUAtnlhd19tb2RpZmllcl9yYW5kb21pemUUpkNyb3VjaN4AFLN5YXdfbW9kaWZpZXJfb2Zmc2V0AKVwaXRjaKNPZmaqeWF3X29mZnNldACpYWNpZF9tb2RlpTItV2F5r2JvZHlfeWF3X29mZnNldACsZnJlZXN0YW5kaW5nwqlhY2lkX3NhZmXCqHlhd19tb2RlqlNpZGUgQmFzZWSoeWF3X2Jhc2WqTG9jYWwgdmlld6phY2lkX2RlbGF5Bal5YXdfZGVsYXkFo3lhd6NPZmaqYWNpZF9jeWNsZQWoYm9keV95YXejT2Zmq3BpdGNoX3ZhbHVlAKx5YXdfbW9kaWZpZXKjT2ZmqHlhd19sZWZ0AKdlbmFibGVkwql5YXdfcmlnaHQAtnlhd19tb2RpZmllcl9yYW5kb21pemUA')

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
        local yaw_mode = preset[ condition ].yaw_mode

        local yaw_modifier = preset[ condition ].yaw_modifier
        local yaw_modifier_offset = preset[ condition ].yaw_modifier_offset
        local yaw_modifier_randomize = preset[ condition ].yaw_modifier_randomize

        local body_yaw = preset[ condition ].body_yaw
        local body_yaw_offset = preset[ condition ].body_yaw_offset

        if yaw == '180 Left / Right' then
            yaw = '180'

            local inverted = lp_info.body_yaw > 0

            if yaw_mode == 'Delayed Switch' then
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

        layer.pitch[1] = preset[ condition ].pitch
        layer.pitch[2] = preset[ condition ].pitch_value

        layer.yaw_base[1] = preset[ condition ].yaw_base
        layer.yaw[1] = yaw
        layer.yaw[2] = yaw_offset

        layer.yaw_modifier[1] = yaw_modifier
        layer.yaw_modifier[2] = yaw_modifier_offset

        layer.body_yaw[1] = body_yaw
        layer.body_yaw[2] = body_yaw_offset
        layer.freestanding_byaw[1] = preset[ condition ].freestanding

        layer:run()
    end)

    if defines.dev then
        vars.angles.copy:set_callback(presets.copy)
        vars.angles.import:set_callback(function ()
            presets.parse(clipboard.get(), true)
        end)
    end
end

local indicators do
    indicators = {
        alpha = tweening.new(),
        align = tweening.new(0, easings.outCirc)
    }

    indicators.items = {
        {
            text = 'DT',

            state = function ()
                local lol, smth = ui.get(reference.RAGE.double_tap[2])
                return lol
            end,

            alpha = tweening.new()
        },

        {
            text = 'OS',

            state = function ()
                local lol, smth = ui.get(reference.RAGE.hide_shots[2])
                return lol
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

        local scoped = lp and entity.get_prop(lp, 'm_bIsScoped') == 1 or false
        local scoped_anim = indicators.align(.1, not scoped)

        local zone = defines.screen_center:clone() do
            zone.x = zone.x + (1 - scoped_anim)
            zone.y = zone.y + 20
        end

        local r, g, b, a = vars.visuals.indicators:get_color()
        a = 255 * global_alpha

        local heading = string.format('EXSCORD \a%s%s', utilities.to_hex(r, g, b, a), defines.build:upper()) do
            local heading_size = renderer.measure_text('-', heading) * .5 * scoped_anim

            renderer.text(zone.x - heading_size, zone.y, 255, 255, 255, 255 * global_alpha, '-', nil, heading)
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

            local text_size = renderer.measure_text('-', item.text) * .5 * scoped_anim

            renderer.text(zone.x - text_size, zone.y + offset, 255, 255, 255, 255 * bind_alpha * global_alpha, '-', nil, item.text)
            offset = offset + 8 * bind_alpha
            ::skip::
        end
    end)
end

-- local shared do
--     shared = {
--         socket = nil,
--         data = { },
--         icon_data = { },
--         link = 'wss://mentally-stable.dev/ws',
--         failed_connections = 0,
--         encoder = 'ILOVEexscordABCDFGHJKMNPQRSTUWXYZabfghijklmnpqtuvwyz0123456789+/='
--     }

--     local scoreboard = panorama.loadstring([[
--         let _get_xuid = function(entity_index) {
--             let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entity_index);
--             return xuid;
--         }

--         let _set_icon = function(entity_index, icon) {
--             let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entity_index);
--             let context_panel = $.GetContextPanel();
--             let ctx = context_panel.FindChildTraverse('ScoreboardContainer').FindChildTraverse('Scoreboard') || context_panel.FindChildTraverse('id-eom-scoreboard-container').FindChildTraverse('Scoreboard')
--             if (ctx == null)
--                 return;

--             ctx.FindChildrenWithClassTraverse('sb-row').forEach(function(e) {
--                 if (e.m_xuid != xuid)
--                     return false;

--                 e.Children().forEach(function(child) {
--                     let attribute = child.GetAttributeString('data-stat', '');
--                     if (attribute != 'rank')
--                         return false;

--                     var image = child.FindChildTraverse('image');
--                     if (!image || !image.IsValid())
--                         return false;

--                     image.SetImage(icon === null ? '' : icon)
--                     return true;
--                 })
--             })

--             return xuid;
--         }

--         return {
--             xuid: _get_xuid,
--             set_icon: _set_icon
--         }
--     ]], 'CSGOHud')()

--     local panorama = panorama.open()

--     shared.retrieve = function ()
--         local info = json.stringify({
--             steam = tostring(panorama.MyPersonaAPI.GetXuid():sub(7) - 97960265728),
--             logo = 'Stable'
--         })

--         return base64.encode(info, shared.encoder)
--     end

--     shared.callbacks = {
--         open = function(ws)
--             ws:send(shared.retrieve())

--             shared.socket = ws
--         end,

--         message = function(ws, data)
--             local success, data = pcall(base64.decode, data, shared.encoder)
--             if not success or type(data) ~= 'string' then
--                 return
--             end

--             local success, data = pcall(json.parse, data)
--             if not success then
--                 return
--             end

--             print(inspect(data))

--             local online = 10

--             for _, object in next, data do
--                 if type(object) == 'string' then
--                     online = online + 1
--                 end
--             end

--             vars.selection.online:set(string.format('Current Online: %d', online))

--             shared.data = data
--         end,

--         close = function (ws)
--             shared.socket = nil
--             utils.execute_after(10, websockets.connect, shared.link, shared.callbacks)
--         end
--     }

--     shared.send = function ()
--         if not shared.socket then
--             return
--         end

--         shared.socket:send(shared.retrieve())
--     end

--     shared.attach = function (condition)
--         local enabled = vars.misc.shared.value and not condition

--         for i = 1, globals.maxplayers() do
--             if entity.get_classname(i) ~= 'CCSPlayer' then
--                 goto skip
--             end

--             local steam_id = tostring(scoreboard.xuid(i):sub(7) - 97960265728)

--             if not enabled then
--                 if not shared.icon_data[ steam_id ] then
--                     scoreboard.set_icon(i, '')
--                     shared.icon_data[ steam_id ] = true
--                 end

--                 goto skip
--             end

--             local logo_id = shared.data[ steam_id ]

--             if logo_id then
--                 scoreboard.set_icon(i, string.format('https://mentally-stable.dev/exscord/%s.png', logo_id))
--                 shared.icon_data[ steam_id ] = false
--             else
--                 if not shared.icon_data[ steam_id ] then
--                     scoreboard.set_icon(i, '')
--                     shared.icon_data[ steam_id ] = true
--                 end
--             end

--             ::skip::
--         end
--     end

--     shared.init = function ()
--         websockets.connect(shared.link, shared.callbacks)

--         shared.send()
--         vars.misc.shared:set_callback(shared.send)
--         client.delay_call(2, shared.send)

--         callbacks['Shared']['paint']:set(function ()
--             shared.attach()
--         end)

--         callbacks['Shared']['shutdown']:set(function ()
--             shared.attach(true)
--         end)
--     end

--     shared.init()
-- end

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
        if not utilities.contains(vars.misc.features.value, 'Clan Tag') then
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

do
    local function get_body_yaw(animstate)
        local body_yaw = animstate.eye_angles_y - animstate.goal_feet_yaw
        body_yaw = utilities.normalize(body_yaw)

        return body_yaw
    end

    callbacks['Anti Aim']['setup_command']:set(function (cmd, lp, valid)
        local data = c_entity(lp)
        if data == nil then
            return
        end

        local animstate = c_entity.get_anim_state(data)
        if animstate == nil then
            return
        end

        if cmd.chokedcommands == 0 then
            lp_info.chokes = lp_info.chokes + 1
            lp_info.choking = lp_info.choking * -1
            lp_info.body_yaw = get_body_yaw(animstate)
        end

        lp_info.velocity = animstate.m_velocity
        lp_info.is_moving = lp_info.velocity > 5
        lp_info.on_ground = animstate.on_ground
        lp_info.ducking = entity.get_prop(lp, 'm_flDuckAmount') > .89
        lp_info.landing = animstate.hit_in_ground_animation
        lp_info.condition = anti_aim.condition(false)

        anti_aim.on_cm()
        exploit.setup_command(cmd, lp)
    end)
end

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

        for i, v in ipairs(cache) do
            if globals.realtime() >= v.n then
                v.d = not v.d
                v.n = globals.realtime() + client.random_float(1, 3)
            end

            local alpha = linear(v.p, v.d, 1)
            local r, g, b, a = utilities.color_lerp(sidebar[1], sidebar[2], sidebar[3], sidebar[4], accent[1], accent[2], accent[3], accent[4], math.min(alpha + 0.5, 1))

            result[ #result + 1 ] = f("\a%02x%02x%02x%02x%s", r, g, b, 200 * alpha + 55, v.w)
        end

        vars.selection.label:set(table.concat(result))
    end)
end