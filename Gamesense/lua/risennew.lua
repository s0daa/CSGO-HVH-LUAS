LPH_JIT = function(...) return ... end
LPH_JIT_MAX = function(...) return ... end
LPH_NO_VIRTUALIZE = function(...) return ... end

local ffi = require('ffi')
local vector = require('vector')
local pui = require('gamesense/pui')
local trace_lib = require('gamesense/trace')
local weapons_c = require('gamesense/csgo_weapons')
local entity_c = require('gamesense/entity')
local string_compression = require('gamesense/lzw')
local clipboard = require('gamesense/clipboard')
local easing = require('gamesense/easing')
local http = require('gamesense/http')
local l_images = require('gamesense/images')
local inspect = require('gamesense/inspect')

local function Mcopy(o)
    if type(o) ~= 'table' then return o end
    local res = {} for k, v in pairs(o) do res[Mcopy(k)] = Mcopy(v) end return res
end

local pairs, ipairs, next, unpack, select, type = pairs, ipairs, next, unpack, select, type
local tonumber, tostring, assert, getmetatable, setmetatable = tonumber, tostring, assert, getmetatable, setmetatable
local math, table, string, bit = Mcopy(math), Mcopy(table), Mcopy(string), Mcopy(bit)

local toticks, totime = toticks, totime
local ui, client, entity, globals, renderer = Mcopy(ui), Mcopy(client), Mcopy(entity), Mcopy(globals), Mcopy(renderer)

function math.clamp(x, min, max)
    return x < min and min or x > max and max or x
end

-- function math.flat(x)
--     return math.floor(.5 + x)
-- end

function math.map(value, in_from, in_to, out_from, out_to, should_clamp)
    if should_clamp then
        return math.clamp(out_from + (value - in_from) * (out_to - out_from) / (in_to - in_from), out_from, out_to)
    end

    return out_from + (value - in_from) * (out_to - out_from) / (in_to - in_from)
end

function math.normalize_yaw(angle)
    while angle > 180 do angle = angle - 360 end
    while angle < -180 do angle = angle + 360 end
    return angle
end

function table.contains(tab, value)
    if type(tab) ~= 'table' then
        return false
    end

    for i = 0, #tab do
        if tab[i] == value then
            return true, i
        end
    end

    return false
end

local smoothy = {
    to_pairs = {
        vector = {'x', 'y', 'z'},
        imcolor =  {'r', 'g', 'b', 'a'}
    },

    get_type = LPH_NO_VIRTUALIZE(function(self, value)
        local val_type = type(value)

        if val_type == 'cdata' and value.x and value.y and value.z then
            return 'vector'
        elseif val_type == 'cdata' and value.r and value.g and value.b and value.a then
            return 'imcolor'
        elseif val_type == 'userdata' and value.__type then
            return string.lower(value.__type.name)
        end

        return val_type
    end),

    copy_tables = LPH_NO_VIRTUALIZE(function(self, destination, keysTable, valuesTable)
        valuesTable = valuesTable or keysTable
        local mt = getmetatable(keysTable)

        if mt and getmetatable(destination) == nil then
            setmetatable(destination, mt)
        end

        for k, v in pairs(keysTable) do
            if type(v) == 'table' then
                destination[k] = self:copy_tables({}, v, valuesTable[k])
            else
                local value = valuesTable[k]

                if type(value) == 'boolean' then
                    value = value and 1 or 0
                end

                destination[k] = value
            end
        end

        return destination
    end),

    resolve = LPH_NO_VIRTUALIZE(function(self, easing_fn, previous, new, clock, duration)
        if type(new) == 'boolean' then new = new and 1 or 0 end
        if type(previous) == 'boolean' then previous = previous and 1 or 0 end

        local previous = easing_fn(clock, previous, new - previous, duration)

        if type(new) == 'number' then
            if math.abs(new - previous) <= .001 then
                previous = new
            end

            if previous % 1 < .0001 then
                previous = math.floor(previous)
            elseif previous % 1 > .9999 then
                previous = math.ceil(previous)
            end
        end

        return previous
    end),

    perform_easing = LPH_NO_VIRTUALIZE(function(self, ntype, easing_fn, previous, new, clock, duration)
        if self.to_pairs[ntype] then
            for _, key in ipairs(self.to_pairs[ntype]) do
                previous[key] = self:perform_easing(
                    type(v), easing_fn,
                    previous[key], new[key],
                    clock, duration
                )
            end

            return previous
        end

        if ntype == 'table' then
            for k, v in pairs(new) do
                previous[k] = previous[k] or v
                previous[k] = self:perform_easing(
                    type(v), easing_fn,
                    previous[k], v,
                    clock, duration
                )
            end

            return previous
        end

        return self:resolve(easing_fn, previous, new, clock, duration)
    end),

    new = LPH_NO_VIRTUALIZE(function(this, default, easing_fn)
        if type(default) == 'boolean' then
            default = default and 1 or 0
        end

        local mt = { }
        local mt_data = {
            value = default or 0,
            easing = easing_fn or function(t, b, c, d)
                return c * t / d + b
            end
        }

        function mt.update(self, duration, value, easing)
            if type(value) == 'boolean' then
                value = value and 1 or 0
            end

            local clock = globals.frametime()
            local duration = duration or .15
            local value_type = this:get_type(value)
            local target_type = this:get_type(self.value)

            assert(value_type == target_type, string.format('type mismatch. expected %s (received %s)', target_type, value_type))

            if self.value == value then
                return value
            end

            if clock <= 0 or clock >= duration then
                if target_type == 'imcolor' or target_type == 'vector' then
                    self.value = value:clone()
                elseif target_type == 'table' then
                    this:copy_tables(self.value, value)
                else
                    self.value = value
                end
            else
                local easing = easing or self.easing

                self.value = this:perform_easing(
                    target_type, easing,
                    self.value, value,
                    clock, duration
                )
            end

            return self.value
        end

        return setmetatable(mt, {
            __metatable = false,
            __call = mt.update,
            __index = mt_data
        })
    end),

    new_interp = function(this, initial_value)
        return setmetatable({
            previous = initial_value or 0
        }, {
            __call = function(self, new_value, mul)
                local mul = mul or 1
                local tickinterval = globals.tickinterval() * mul
                local difference = math.abs(new_value - self.previous)

                if difference > 0 then
                    local time = math.min(tickinterval, globals.frametime()) / tickinterval
                    self.previous = self.previous + time * (new_value - self.previous)
                else
                    self.previous = new_value
                end

                self.previous = (self.previous % 1 < .0001) and 0 or self.previous

                return self.previous
            end
        })
    end
}

local Draw = {
    rectangle = LPH_NO_VIRTUALIZE(function(position, size, clr, rounding)
        local r, g, b, a = clr.r, clr.g, clr.b, clr.a

        if a <= 0 then
            return
        end

        -- local position = vector(math.floor(.5 + position.x), math.floor(.5 + position.y))
        -- local size = vector(math.floor(.5 + size.x), math.floor(.5 + size.y))

        if not rounding or rounding == 0 then
            renderer.rectangle(position.x, position.y, size.x, size.y, r, g, b, a)
            return
        end

        if type(rounding) == 'number' then
            rounding = math.min(size.x / 2, size.y / 2, rounding)

            local rectangle_data = {
                {position.x + rounding, position.y + rounding, size.x - rounding * 2, size.y - rounding * 2},
                {position.x + rounding, position.y, size.x - rounding * 2, rounding},
                {position.x + size.x - rounding, position.y + rounding, rounding, size.y - rounding * 2},
                {position.x + rounding, position.y + size.y - rounding, size.x - rounding * 2, rounding},
                {position.x, position.y + rounding, rounding, size.y - rounding * 2}
            }

            local circle_data = {
                {position.x + rounding, position.y + rounding, 180},
                {position.x + size.x - rounding, position.y + rounding, 90},
                {position.x + size.x - rounding, position.y + size.y - rounding, 360},
                {position.x + rounding, position.y + size.y - rounding, 270}
            }

            for i = 1, #rectangle_data do
                local data = rectangle_data[i]
                renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
            end

            for i = 1, #circle_data do
                local data = circle_data[i]
                renderer.circle(data[1], data[2], r, g, b, a, rounding, data[3], .25)
            end
        elseif type(rounding) == 'table' then
            local active_corners = rounding[2]
            local rounding = rounding[1]

            rounding = math.min(size.x / 2, size.y / 2, rounding)

            local rectangle_data = {
                {position.x + rounding, position.y + rounding, size.x - rounding * 2, size.y - rounding * 2},
                {position.x, position.y, size.x - rounding, rounding},
                {position.x + size.x - rounding, position.y, rounding, size.y - rounding},
                {position.x + rounding, position.y + size.y - rounding, size.x - rounding, rounding},
                {position.x, position.y + rounding, rounding, size.y - rounding}
            }

            local active_corners_data = {
                {position.x + rounding, position.y, size.x - rounding * 2, rounding},
                {position.x + size.x - rounding, position.y + rounding, rounding, size.y - rounding * 2},
                {position.x + rounding, position.y + size.y - rounding, size.x - rounding * 2, rounding},
                {position.x, position.y + rounding, rounding, size.y - rounding * 2}
            }

            for i = 1, #active_corners do
                if active_corners[i] then
                    rectangle_data[i + 1] = active_corners_data[i]
                end
            end

            local circle_data = {
                {position.x + rounding, position.y + rounding, 180},
                {position.x + size.x - rounding, position.y + rounding, 90},
                {position.x + size.x - rounding, position.y + size.y - rounding, 360},
                {position.x + rounding, position.y + size.y - rounding, 270}
            }

            for i = 1, #rectangle_data do
                local data = rectangle_data[i]
                renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
            end

            for i = 1, #circle_data do
                local data = circle_data[i]

                if active_corners[i] then
                    renderer.circle(data[1], data[2], r, g, b, a, rounding, data[3], .25)
                end
            end
        end
    end),

    rectangle_outline = LPH_NO_VIRTUALIZE(function(position, size, clr, rounding, thickness)
        local r, g, b, a = clr.r, clr.g, clr.b, clr.a

        if a <= 0 then
            return
        end

        -- local position = vector(math.floor(.5 + position.x), math.floor(.5 + position.y))
        -- local size = vector(math.floor(.5 + size.x), math.floor(.5 + size.y))

        local rectangle_data = {
            {position.x + rounding, position.y, size.x - rounding * 2, thickness},
            {position.x + size.x - thickness, position.y + rounding, thickness, size.y - rounding * 2},
            {position.x + rounding, position.y + size.y - thickness, size.x - rounding * 2, thickness},
            {position.x, position.y + rounding, thickness, size.y - rounding * 2}
        }

        local circle_data = {
            {position.x + rounding, position.y + rounding, 180},
            {position.x + size.x - rounding, position.y + rounding, 270},
            {position.x + size.x - rounding, position.y + size.y - rounding, 360},
            {position.x + rounding, position.y + size.y - rounding, 90},
        }

        for i = 1, #rectangle_data do
            local data = rectangle_data[i]
            renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
        end

        if rounding > 0 then
            for i = 1, #circle_data do
                local data = circle_data[i]
                renderer.circle_outline(data[1], data[2], r, g, b, a, rounding, data[3], .25, thickness)
            end
        end
    end),

    gradient = LPH_NO_VIRTUALIZE(function(position, size, clr1, clr2, ltr, percentage, fixed)
        local position = vector(math.floor(.5 + position.x), math.floor(.5 + position.y))
        local size = vector(math.floor(.5 + size.x), math.floor(.5 + size.y))
        local r1, g1, b1, a1 = clr1.r, clr1.g, clr1.b, clr1.a
        local r2, g2, b2, a2 = clr2.r, clr2.g, clr2.b, clr2.a

        percentage = percentage or 1

        if percentage == 1 then
            renderer.gradient(position.x, position.y, size.x, size.y, r1, g1, b1, a1, r2, g2, b2, a2, ltr)
            return
        elseif percentage == 0 then
            renderer.gradient(position.x, position.y, size.x, size.y, r2, g2, b2, a2, r1, g1, b1, a1, ltr)
            return
        end

        if ltr then
            renderer.gradient(
                position.x, position.y,
                size.x * percentage + (fixed and 1 or 0), size.y,
                r1, g1, b1, a1, r2, g2, b2, a2, true
            )

            renderer.gradient(
                position.x + size.x * percentage, position.y,
                size.x * (1 - percentage), size.y,
                r2, g2, b2, a2, r1, g1, b1, a1, true
            )
        else
            renderer.gradient(
                position.x, position.y,
                size.x, size.y * percentage + (fixed and 1 or 0),
                r1, g1, b1, a1, r2, g2, b2, a2, false
            )

            renderer.gradient(
                position.x, position.y + size.y * percentage,
                size.x, size.y * (1 - percentage),
                r2, g2, b2, a2, r1, g1, b1, a1, false
            )
        end
    end),

    shadow = LPH_NO_VIRTUALIZE(function(self, position, size, clr, rounding, steps, inside)
        if clr.a <= 0 then
            return
        end

        -- local position = vector(math.floor(.5 + position.x), math.floor(.5 + position.y))
        -- local size = vector(math.floor(.5 + size.x), math.floor(.5 + size.y))

        local accuracy = 1
        local clr = {r = clr.r, g = clr.g, b = clr.b, a = clr.a}

        if inside then
            self.rectangle(position, size, clr, rounding)
        end

        for i = 1, steps do
            clr.a = clr.a * ((steps - (i - 1)) / steps) ^ 2

            if clr.a > 1 then
                self.rectangle_outline(
                    vector(position.x - i * accuracy, position.y - i * accuracy),
                    vector(size.x + i * accuracy * 2, size.y + i * accuracy * 2),
                    clr, rounding + i * accuracy, accuracy
                )
            end
        end
    end)
}

local ref
local script_ctx
local common
local vars
local config_system
local menu
local exploit
local antiaim
local automatic_peek
local notifications

ref = {} do
    ref.antiaim_enabled = pui.reference('AA', 'Anti-aimbot angles', 'Enabled')

    ref.pitch_mode, ref.pitch_value = pui.reference('AA', 'Anti-aimbot angles', 'Pitch')
    ref.yaw_base = pui.reference('AA', 'Anti-aimbot angles', 'Yaw base')
    ref.yaw_mode, ref.yaw_value = pui.reference('AA', 'Anti-aimbot angles', 'Yaw')
    ref.yaw_jitter_mode, ref.yaw_jitter_value = pui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')
    ref.body_yaw_mode, ref.body_yaw_value = pui.reference('AA', 'Anti-aimbot angles', 'Body yaw')
    ref.freestanding_body_yaw = pui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw')

    ref.edge_yaw = pui.reference('AA', 'Anti-aimbot angles', 'Edge yaw')
    ref.freestanding = pui.reference('AA', 'Anti-aimbot angles', 'Freestanding')
    ref.roll = pui.reference('AA', 'Anti-aimbot angles', 'Roll')

    ref.fakelag = pui.reference('AA', 'Fake lag', 'Enabled')
    ref.fakelag_mode = pui.reference('AA', 'Fake lag', 'Amount')
    ref.fakelag_variance = pui.reference('AA', 'Fake lag', 'Variance')
    ref.fakelag_limit = pui.reference('AA', 'Fake lag', 'Limit')

    ref.slowmotion = pui.reference('AA', 'Other', 'Slow motion')
    ref.leg_movement = pui.reference('AA', 'Other', 'Leg movement')

    ref.onshot_antiaim = pui.reference('AA', 'Other', 'On shot anti-aim')
    ref.doubletap, ref.doubletap_mode = pui.reference('RAGE', 'Aimbot', 'Double tap')
    ref.doubletap_fakelag_limit = pui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
    ref.fakeduck = pui.reference('RAGE', 'Other', 'Duck peek assist')

    ref.target_hitbox = pui.reference('RAGE', 'Aimbot', 'Target hitbox')
    ref.hitchance = pui.reference('RAGE', 'Aimbot', 'Minimum hit chance')
    ref.min_damage = pui.reference('RAGE', 'Aimbot', 'Minimum damage')
    ref.min_damage_override, ref.min_damage_override_value = pui.reference('RAGE', 'Aimbot', 'Minimum damage override')
    ref.force_baim = pui.reference('RAGE', 'Aimbot', 'Force body aim')
    ref.force_safepoint = pui.reference('RAGE', 'Aimbot', 'Force safe point')
    ref.prefer_safepoint = pui.reference('RAGE', 'Aimbot', 'Prefer safe point')
    ref.quickstop, ref.quickstop_options = pui.reference('RAGE', 'Aimbot', 'Quick stop')
    ref.force_baim_on_peek = pui.reference('RAGE', 'Aimbot', 'Force body aim on peek')
    ref.delayshot = pui.reference('RAGE', 'Other', 'Delay shot')
    ref.automatic_scope = pui.reference('RAGE', 'Aimbot', 'Automatic scope')

    ref.quickpeek = pui.reference('RAGE', 'Other', 'Quick peek assist')
    ref.quickpeek_mode = pui.reference('RAGE', 'Other', 'Quick peek assist mode')
    ref.quickpeek_distance = pui.reference('RAGE', 'Other', 'Quick peek assist distance')

    ref.ping_spike, ref.ping_spike_value = pui.reference('MISC', 'Miscellaneous', 'Ping spike')

    ref.third_person_alive = pui.reference('VISUALS', 'Effects', 'Force third person (alive)')

    ref.maxusrcmd = ui.reference('MISC', 'Settings', 'sv_maxusrcmdprocessticks2')

    do
        local status, result = pcall(pui.reference, 'VISUALS', 'Other ESP', 'Helper')

        if status then
            ref.helper = result
        end
    end

    do
        local status, result = pcall(pui.reference, 'RAGE', 'Aimbot', 'Dormant aimbot')

        if status then
            ref.dormant_aim = result
        end
    end
end

script_ctx = {} do
    script_ctx.name = 'risen'
    script_ctx.last_update = '13.09'
    script_ctx.source = LPH_OBFUSCATED == nil
    script_ctx.debug_features = false
    script_ctx.hidden_features = false

    local versions = {
        live = 'live',
        beta = 'beta',
        debug = 'debug',
        private = 'private',
        dev = 'dev'
    }

    script_ctx.database_key = '[:]'.. string.upper(script_ctx.name) ..'[:]54321'
    -- script_ctx.database = {}
    script_ctx.database = database.read(script_ctx.database_key) or {}
    script_ctx.database.configs = script_ctx.database.configs or {}

    if script_ctx.source then
        script_ctx.username = 'admin'
        script_ctx.debug_features = true
        script_ctx.hidden_features = true
        script_ctx.version = versions.dev
    else
        local obex_builds = {
            ['User'] = 'live',
            ['Beta'] = 'beta',
            ['Debug'] = 'debug',
            ['Private'] = 'private'
        }

        local info = obex_fetch and obex_fetch() or {username = '', build = '', discord = ''}

        script_ctx.username = info.username:lower()
        script_ctx.version = versions[obex_builds[info.build]]

        if script_ctx.username == 'mag' then
            script_ctx.username = 'klyy'
            script_ctx.hidden_features = true
        elseif script_ctx.username == 'damekuchuj' then
            script_ctx.username = 'kdm'
            script_ctx.hidden_features = true
        elseif script_ctx.username == 'pedal' then
            script_ctx.username = 'maciordaowo'
            script_ctx.hidden_features = true
        elseif script_ctx.username == 'cubs' then
            script_ctx.hidden_features = true
        elseif script_ctx.username == 'august' then
            script_ctx.version = versions.private
        end

        client.exec('clear')
    end
end

common = {} do
    common.extend_vector = LPH_NO_VIRTUALIZE(function(pos, length, angle)
        local rad = angle * math.pi / 180
        return vector(pos.x + (math.cos(rad) * length), pos.y + (math.sin(rad) * length), pos.z)
    end)

    local sv_gravity = cvar.sv_gravity
    local sv_jump_impulse = cvar.sv_jump_impulse

    common.extrapolate_position = LPH_NO_VIRTUALIZE(function(ent, origin, ticks, inverted)
        local tickinterval = globals.tickinterval()

        local sv_gravity = sv_gravity:get_float() * tickinterval
        local sv_jump_impulse = sv_jump_impulse:get_float() * tickinterval

        local p_origin, prev_origin = origin, origin

        local velocity = vector(entity.get_prop(ent, 'm_vecVelocity'))
        local gravity = velocity.z > 0 and -sv_gravity or sv_jump_impulse

        for i = 1, ticks do
            prev_origin = p_origin
            p_origin = vector(
                p_origin.x + (inverted and -(velocity.x * tickinterval) or (velocity.x * tickinterval)),
                p_origin.y + (inverted and -(velocity.y * tickinterval) or (velocity.y * tickinterval)),
                p_origin.z + (inverted and -((velocity.z + gravity) * tickinterval) or (velocity.z + gravity) * tickinterval)
            )

            local fraction = client.trace_line(-1,
                prev_origin.x, prev_origin.y, prev_origin.x,
                p_origin.x, p_origin.y, p_origin.x
            )

            if fraction <= .99 then
                return prev_origin
            end
        end

        return p_origin
    end)

    common.set_movement = LPH_NO_VIRTUALIZE(function(cmd, destination, local_player)
        local move_yaw = vector(vector(entity.get_origin(local_player)):to(destination):angles()).y

        cmd.in_forward = 1
        cmd.in_back = 0
        cmd.in_moveleft = 0
        cmd.in_moveright = 0
        cmd.in_speed = 0
        cmd.forwardmove = 800
        cmd.sidemove = 0
        cmd.move_yaw = move_yaw
    end)

    common.rgb_to_hex = LPH_NO_VIRTUALIZE(function(clr)
        return string.format('%02x%02x%02x%02x', clr[1], clr[2], clr[3], clr[4])
    end)

    common.lerp = LPH_NO_VIRTUALIZE(function(a, b, percentage)
        if a == b then
            return b
        end

        return a + (b - a) * percentage
    end)

    common.color_swap = LPH_NO_VIRTUALIZE(function(color1, color2, weight)
        weight = math.clamp(weight, 0, 1)

        if weight == 0 then
            return color1
        elseif weight == 1 then
            return color2
        end

        return {
            common.lerp(color1[1], color2[1], weight),
            common.lerp(color1[2], color2[2], weight),
            common.lerp(color1[3], color2[3], weight),
            common.lerp(color1[4], color2[4], weight)
        }
    end)

    common.colored_text = LPH_NO_VIRTUALIZE(function(text, clr)
        return string.format('\a%02x%02x%02x%02x%s', clr[1], clr[2], clr[3], clr[4], text)
    end)

    common.gradient_text = LPH_NO_VIRTUALIZE(function(text, color1, color2, fraction, gradient)
        color2 = color2 or color1
        fraction = math.clamp(fraction, 0, 1)

        if fraction == 0 then
            return common.colored_text(text, color2)
        elseif fraction == 1 then
            return common.colored_text(text, color1)
        end

        local text_length = string.len(text)

        local return_text = {}

        for i = 1, text_length do
            local weight = gradient and ((1 - fraction) - (text_length - i) / (text_length - 1)) + (1 - fraction) or i - fraction * text_length
            local color = common.color_swap(color1, color2, weight)

            return_text[i] = common.colored_text(string.sub(text, i, i), color)
        end

        return table.concat(return_text)
    end)
end

vars = {} do
    vars.local_player = entity.get_local_player()
    vars.screen_size = vector(client.screen_size())
    vars.game_rules = entity.get_game_rules()

    vars.teams = {'terrorist', 'counter terrorist'}
    vars.conditions = {'stand', 'move', 'crouch', 'crouch move', 'slowwalk', 'air crouch', 'air', 'fakelag', 'legit aa'}
    vars.builder_conditions = {'shared', 'stand', 'move', 'crouch', 'crouch move', 'slowwalk', 'air crouch', 'air', 'fakelag'}

    function vars:on_net_update_end()
        self.local_player = entity.get_local_player()
        self.screen_size = vector(client.screen_size())
        self.game_rules = entity.get_game_rules()
    end
end

config_system = {} do
    config_system.packages = {}
    config_system.list = {'default'}
    config_system.configs = {}
    config_system.selected_item = 0
    config_system.hidden_config = false
    config_system.autoload_item = false

    local function update_name(this)
        local selected_item = this.value
        config_system.selected_item = selected_item

        if config_system.list[selected_item + 1] then
            menu.configs.config_name:set(config_system.list[selected_item + 1])
        end
    end

    function config_system:menu_init()
        self:get_configs()

        update_name(menu.configs.config_list)

        menu.configs.config_list:set_callback(update_name)
    end

    local code = 'l29W5AU6JX1CEVIjmNFZM4xv+twdQsHLBrYG3S7h/zkPpbyoaneKqcDR)Tigf0u8'

    local function encode(data)
        return ((data:gsub('.', function(x)
            local r, b = '', x:byte()
            for i = 8, 1, -1 do r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0') end
            return r
        end) ..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
            if (#x < 6) then return '' end
            local c = 0
            for i = 1, 6 do c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0) end
            return code:sub(c + 1, c + 1)
        end) .. ({'', '==', '='})[#data % 3 + 1])
    end

    local function decode(data)
        data = string.gsub(data, '[^'.. code ..'=]', '')
        return (data:gsub('.', function(x)
            if (x == '=') then return '' end
            local r, f = '', (code:find(x) - 1)
            for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0') end
            return r
        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
            if (#x ~= 8) then return '' end
            local c = 0
            for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0) end
            return string.char(c)
        end))
    end

    function config_system:get_configs()
        self.configs.blank = encode(string_compression.compress(json.stringify({
            settings = self.packages.main:save(),
            hidden = false
        })))
    end

    local function export_raw(to_clipboard, return_settings, hidden, region)
        hidden = hidden == nil and config_system.hidden_config or hidden

        local result = {
            settings = config_system.packages.main:save(region),
            hidden = hidden
        }

        local result_final = encode(string_compression.compress(json.stringify(result)))

        if to_clipboard then
            clipboard.set(result_final)
        end

        if return_settings then
            return result_final
        end
    end

    local function import_raw(data, region)
        data = json.parse(string_compression.decompress(decode(data)))

        config_system.packages.main:load(data.settings, region)
        config_system.hidden_config = data.hidden
    end

    function config_system:export(to_clipboard, return_settings, hidden, region, text, error_text)
        if not hidden and self.hidden_config then
            print('You can\'t export hidden config as not hidden')
            return
        end

        local status, result = pcall(export_raw, to_clipboard, return_settings, hidden, region)

        text = text or ''
        error_text = error_text or ''

        if status then
            print(text)

            if return_settings then
                return result
            end
        else
            print(error_text)
        end
    end

    function config_system:import(data, region, text, error_text)
        local status, result = pcall(import_raw, data, region)

        text = text or ''
        error_text = error_text or ''

        if status then
            print(text)
        else
            print(error_text)
        end
    end

    function config_system:set_autoload(item)
        if type(item) ~= 'number' then
            print('You didn\'t select any config')
            return
        end

        item = item + 1

        local name = self.list[item]

        if self.autoload_item == item - 1 then
            local function protected()
                self.autoload_item = false
            end

            local status, result = pcall(protected)

            if status then
                string.format('Succesfully unset autoload on config [%s]', name)
            else
                string.format('Error while unsetting autoload on config [%s]', name)
            end

            return
        end

        local function protected()
            self.autoload_item = item - 1
        end

        local status, result = pcall(protected)

        if status then
            string.format('Succesfully set autoload on config [%s]', name)
        else
            string.format('Error while setting autoload on config [%s]', name)
        end
    end

    function config_system:save_config(item)
        if type(item) ~= 'number' then
            print('You didn\'t select any config')
            return
        end

        item = item + 1

        local name = menu.configs.config_name:get()

        if not table.contains(self.list, name) then
            if name == '' then
                print('You can\'t create unnamed config')
                return
            end

            local function protected()
                table.insert(script_ctx.database.configs, export_raw(false, true))
                table.insert(self.list, name)
                menu.configs.config_list:update(self.list)
                menu.configs.config_list:set(item)
            end

            local status, result = pcall(protected)

            if status then
                print(string.format('Succesfully created config [%s]', name))
            else
                print(string.format('Error while creating config [%s]', name))
            end

            return
        end

        if not self.list[item] then
            print('You didn\'t select any config')
            return
        end

        if item == 1 then
            print('You can\'t override default config')
            return
        end

        name = self.list[item]

        local function protected()
            script_ctx.database.configs[item] = export_raw(false, true)
        end

        local status, result = pcall(protected)

        if status then
            print(string.format('Succesfully saved config [%s]', name))
        else
            print(string.format('Error while saving config [%s]', name))
        end
    end

    function config_system:load_config(item, autoload)
        if type(item) ~= 'number' then
            print('You didn\'t select any config')
            return
        end

        item = item + 1

        if not self.list[item] then
            print('You didn\'t select any config')
            return
        end

        if item == 1 then
            local text = 'Succesfully loaded default config'
            local error_text = 'Error while loading default config'

            if autoload then
                text = 'Succesfully loaded your autoload config [default config]'
                error_text = 'Error while loading your autoload config [default config]'

                menu.configs.config_list:set(item - 1)
            end

            self:import(self.configs.default, nil, text, error_text)

            return
        end

        local config = script_ctx.database.configs[item]
        local name = self.list[item]

        if not config or config == '' then
            print(string.format('This config [%s] is blank', name))
            return
        end

        local function protected()
            import_raw(config)

            if autoload then
                menu.configs.config_list:set(item - 1)
            end
        end

        local status, result = pcall(protected)

        if status then
            local text = string.format('Succesfully loaded config [%s]', name)

            if autoload then
                text = string.format('Succesfully loaded your autoload config [%s]', name)
            end

            print(text)
        else
            local text = string.format('Error while loading config [%s]', name)

            if autoload then
                text = string.format('Error while loading your autoload config [%s]', name)
            end

            print(text)
            print(result)
        end
    end

    function config_system:delete_config(item)
        if type(item) ~= 'number' then
            print('You didn\'t select any config')
            return
        end

        item = item + 1

        if not self.list[item] then
            print('You didn\'t select any config')
            return
        end

        if item == 1 then
            print('You can\'t delete default config')
            return
        end

        local name = self.list[item]

        local protected = function()
            table.remove(script_ctx.database.configs, item)
            table.remove(self.list, item)
            menu.configs.config_list:update(self.list)
            menu.configs.config_list:set(item - 2)

            if self.autoload_item == item - 1 then
                self.autoload_item = false
            end
        end

        local status, result = pcall(protected)

        if status then
            print(string.format('Succesfully deleted config [%s]', name))
        else
            print(string.format('Error while deleting config [%s]', name))
        end
    end

    function config_system:reset_config(item)
        if type(item) ~= 'number' then
            print('You didn\'t select any config')
            return
        end

        item = item + 1

        if not self.list[item] then
            print('You didn\'t select any config')
            return
        end

        if item == 1 then
            print('You can\'t reset default config')
            return
        end

        local name = self.list[item]

        local function protected()
            script_ctx.database.configs[item] = self.configs.blank
            import_raw(self.configs.blank)
        end

        local status, result = pcall(protected)

        if status then
            print(string.format('Succesfully reset config [%s]', name))
        else
            print(string.format('Error while resetting config [%s]', name))
        end
    end
end

menu = {} do
    local prefix = {
        pui.format('\v•\r  '),
        pui.format('\v»\r '),
        pui.format('\v-\r '),
        pui.format('\v~\r '),
    }

    local main = pui.group('AA', 'Anti-aimbot angles')
    -- local side = pui.group('AA', 'Fake lag')
    local other = pui.group('AA', 'Other')

    menu.main_label = main:label(string.format(
        '\v%s\r ~ %s%s', script_ctx.name, script_ctx.version, script_ctx.hidden_features and ' \v☻' or ''
    ), nil, false)

    menu.accent_color = main:color_picker('\n', 255, 255, 255, 255)

    menu.tab = main:combobox('\ntab', {'Anti-aim', 'Visuals', 'Misc', 'Configs'}, nil, false)

    menu.antiaim = {} do
        menu.antiaim.tab = main:combobox('\nAnti-aim tab', {'Main', 'Additions'}, nil, false)

        menu.antiaim.main = {} do
            menu.antiaim.main.master_switch = main:checkbox('Enable anti-aim')

            menu.antiaim.main.hidden_notice = {
                main:label('\aff3d3dff! This config is hidden !'),
                main:label('(if you want to unhide anti-aim tab'),
                main:label('load different config or reset current)')
            }

            menu.antiaim.main.preset = main:combobox('\nPreset', {'Recommended', 'Configurator'})

            menu.antiaim.main.builder = {} do
                menu.antiaim.main.builder.condition = main:combobox('Condition', vars.builder_conditions)

                for i, condition in pairs(vars.builder_conditions) do
                    menu.antiaim.main.builder[condition] = {}
                    local tab = menu.antiaim.main.builder[condition]

                    tab.override_condition = main:checkbox('Override \v'.. condition)

                    if condition == 'shared' then
                        tab.override_condition:set(true)
                        tab.override_condition:depend({menu.antiaim.main.builder.condition, 'shared', true})
                    end

                    tab.yaw_mode = main:combobox('Yaw mode\n'.. condition, {'Static', 'Left & Right'})
                    tab.yaw = main:slider('Yaw '.. prefix[3] ..'Add\n'.. condition, -180, 180, 0):depend({tab.yaw_mode, 'Static'})
                    tab.yaw_left = main:slider('Yaw '.. prefix[3] ..'Left\n'.. condition, -180, 180, 0):depend({tab.yaw_mode, 'Left & Right'})
                    tab.yaw_right = main:slider('Yaw '.. prefix[3] ..'Right\n'.. condition, -180, 180, 0):depend({tab.yaw_mode, 'Left & Right'})
                    tab.yaw_jitter = main:combobox('Yaw jitter\n'.. condition, {'Off', 'Center', 'Offset', 'Random', 'Skitter'})
                    tab.yaw_jitter_value = main:slider('\nYaw jitter Add\n'.. condition, -180, 180, 0):depend({tab.yaw_jitter, 'Off', true})
                    tab.body_yaw = main:combobox('Body yaw\n'.. condition, {'Off', 'Jitter', 'Static', 'Custom'})
                    tab.body_yaw_value = main:slider('\n'.. condition, -180, 180, 0):depend({tab.body_yaw, 'Static'})
                    tab.delay_ticks = main:slider('Delay\n'.. condition, 2, 20, 0, true, 't'):depend({tab.body_yaw, 'Custom'})

                    pui.traverse(tab, function(element, path)
                        element:depend({menu.antiaim.main.builder.condition, condition})

                        if path[1] ~= 'override_condition' then
                            element:depend(tab.override_condition)
                        end
                    end)
                end
            end
        end

        menu.antiaim.additions = {} do
            menu.antiaim.additions.selector = main:multiselect('Additions', {
                'Legit anti-aim', 'Freestand', 'Manual anti-aim', 'Automatic peek', 'Force defensive', 'Defensive anti-aim', 'Safe head'
            })
            menu.antiaim.additions.legit_antiaim = main:combobox(prefix[1] ..'Legit anti-aim', {'Local view', 'At targets'}, 0):depend(
                {menu.antiaim.additions.selector, 'Legit anti-aim'}
            )
            menu.antiaim.additions.freestand = main:multiselect(prefix[1] ..'Freestand \vdisablers', {'Air', 'Slowwalk', 'Crouch', 'Move'}, 0):depend(
                {menu.antiaim.additions.selector, 'Freestand'}
            )
            menu.antiaim.additions.manual_antiaim = {
                yaw_base = main:combobox(prefix[1] ..'Manual anti-aim', {'Local view', 'At targets'}):depend(
                    {menu.antiaim.additions.selector, 'Manual anti-aim'}
                ),
                reset = main:hotkey('\t'.. prefix[3] ..'Reset'):depend({menu.antiaim.additions.selector, 'Manual anti-aim'}),
                directions = {
                    main:hotkey('\t'.. prefix[3] ..'Left'):depend({menu.antiaim.additions.selector, 'Manual anti-aim'}),
                    main:hotkey('\t'.. prefix[3] ..'Right'):depend({menu.antiaim.additions.selector, 'Manual anti-aim'}),
                    main:hotkey('\t'.. prefix[3] ..'Forward'):depend({menu.antiaim.additions.selector, 'Manual anti-aim'})
                }
            }
            menu.antiaim.additions.automatic_peek = main:combobox(prefix[1] ..'Automatic peek', {'Offensive', 'Defensive'}, 0):depend(
                {menu.antiaim.additions.selector, 'Automatic peek'}
            )
            menu.antiaim.additions.force_defensive = main:multiselect(prefix[1] ..'Force defensive', {
                'stand', 'move', 'crouch', 'crouch move', 'slowwalk', 'air crouch', 'air'
            }, 0):depend({menu.antiaim.additions.selector, 'Force defensive'})
            menu.antiaim.additions.defensive_antiaim_conditions = main:multiselect(prefix[1] ..'Defensive anti-aim conditions', {
                'stand', 'move', 'crouch', 'crouch move', 'slowwalk', 'air crouch', 'air', 'freestand', 'manual anti-aim', 'safe head'
            }, 0):depend({menu.antiaim.additions.selector, 'Defensive anti-aim'})
            menu.antiaim.additions.safe_head = main:checkbox(prefix[1] ..'Safe head'):depend({menu.antiaim.additions.selector, 'Safe head'})
        end

        pui.traverse(menu.antiaim, function(element)
            element:depend({menu.tab, 'Anti-aim'})
        end)

        pui.traverse(menu.antiaim.main, function(element, path)
            element:depend({menu.antiaim.tab, 'Main'})

            if path[1] ~= 'master_switch' then
                element:depend(menu.antiaim.main.master_switch)

                if path[1] == 'builder' then
                    element:depend({menu.antiaim.main.preset, 'Configurator'})
                end
            end
        end)

        pui.traverse(menu.antiaim.additions, function(element)
            element:depend({menu.antiaim.tab, 'Additions'})
        end)
    end

    menu.visuals = {} do
        menu.visuals.indicator = main:combobox(prefix[1] ..'Indicators', {'-', '1'})
        menu.visuals.indicator_font = main:combobox(prefix[3] ..'Font', {'Small', 'Normal', 'Bold'}):depend({menu.visuals.indicator, '-', true})
        menu.visuals.indicator_adjustments = main:multiselect(prefix[3] ..'Adjustments', {'On scope', 'On nade'}):depend(
            {menu.visuals.indicator, '-', true}
        )
        menu.visuals.indicator_height = main:slider(prefix[3] ..'Height', -300, 300, 20, true, 'px'):depend({menu.visuals.indicator, '-', true})

        menu.visuals.manual_arrows = main:combobox(prefix[1] ..'Manual arrows', {'-', 'Default', 'Modern'})
        menu.visuals.manual_arrows_padding = main:slider(prefix[3] ..'Padding', -35, 100, 35, true, 'px'):depend({menu.visuals.manual_arrows, '-', true})
        menu.visuals.manual_arrows_adjust = main:checkbox(prefix[3] ..'Adjust on scope'):depend({menu.visuals.manual_arrows, '-', true})

        menu.visuals.visualize_automatic_peek = main:checkbox(prefix[1] ..'Visualize automatic peek'):depend(
            {menu.antiaim.additions.selector, 'Automatic peek'}
        )

        menu.visuals.watermark = main:checkbox(prefix[1] ..'Watermark')
        menu.visuals.watermark_additions = main:multiselect('\nWatermark additions', {
            'Username', 'Build', 'Ping', 'Clock', 'Doubletap', 'Hideshots', 'Fakelag'
        }):depend(menu.visuals.watermark)

        pui.traverse(menu.visuals, function(element)
            element:depend({menu.tab, 'Visuals'})
        end)
    end

    menu.misc = {} do
        menu.misc.aimbot_logs = main:multiselect(prefix[1] ..'Aimbot logs', {'Notifications'})
        menu.misc.aimbot_logs_hit_clr = main:color_picker(prefix[1] ..'Hit color', 120, 255, 120, 255):depend(
            {menu.misc.aimbot_logs, 'Notifications'}
        )
        menu.misc.aimbot_logs_miss_clr = main:color_picker(prefix[1] ..'Miss color', 255, 120, 120, 255):depend(
            {menu.misc.aimbot_logs, 'Notifications'}
        )

        menu.misc.animations = main:multiselect(prefix[1] ..'Animations', {
            'Legs on ground', 'Static legs in air', 'Walk in air', 'Pitch zero on land'
        })
        menu.misc.on_ground_animation_type = main:combobox(prefix[3] ..'Legs on ground mode', {
            'Jitter', 'Moonwalk'
        }):depend({menu.misc.animations, 'Legs on ground'})

        pui.traverse(menu.misc, function(element)
            element:depend({menu.tab, 'Misc'})
        end)
    end

    menu.configs = {} do
        menu.configs.config_list = main:listbox('configs', config_system.list, nil, false)
        menu.configs.config_name = main:textbox('name', nil, false)
        menu.configs.config_load = main:button('load', function() config_system:load_config(menu.configs.config_list.value) end)
        menu.configs.config_save = main:button('save', function() config_system:save_config(menu.configs.config_list.value) end)
        menu.configs.config_delete = main:button('delete', function() config_system:delete_config(menu.configs.config_list.value) end)
        menu.configs.config_reset = main:button('reset', function() config_system:reset_config(menu.configs.config_list.value) end)
        menu.configs.config_import = main:button('import', function()
            config_system:import(
                clipboard.get(), nil,
                'Succesfully imported config to clipboard',
                'Error while importing config'
            )
        end)
        menu.configs.config_export = main:button('export', function()
            config_system:export(
                true, false, false, nil,
                'Succesfully exported config to clipboard',
                'Error while exporting config'
            )
        end)
        menu.configs.config_export_hidden = main:button('export as hidden', function()
            config_system:export(
                true, false, true, nil,
                'Succesfully exported config as hidden to clipboard',
                'Error while exporting config as hidden'
            )
        end)
        menu.configs.config_autoload = main:button('toggle autoload', function() config_system:set_autoload(menu.configs.config_list.value) end)

        pui.traverse(menu.configs, function(element)
            element:depend({menu.tab, 'Configs'})
        end)
    end

    menu.other = {} do
        if script_ctx.hidden_features then
            menu.other.dziki = other:hotkey('picie dzików =D')
        end

        if script_ctx.debug_features then
            menu.other.unhide_skeet_aa = other:checkbox('unhide skeet aa')
            menu.other.disable_custom_desync = other:checkbox('disable custom desync')
            menu.other.disableaa = other:checkbox('disable aa')
            menu.other.run_notify = other:button('add notification', function()
                notifications:add({
                    'Hit ', 'vektus', ' due to ', 'noob hvh'
                }, nil, 4)
            end)
        end
    end

    config_system.packages.main = pui.setup(menu)

    function menu:handle_hidden_notice(state)
        state = state and menu.tab.value == 'Anti-aim' and menu.antiaim.tab.value == 'Main'

        for i = 1, #menu.antiaim.main.hidden_notice do
            menu.antiaim.main.hidden_notice[i]:set_visible(state)
        end
    end

    function menu:handle_hidden()
        self:handle_hidden_notice(config_system.hidden_config)

        if not config_system.hidden_config then
            return
        end

        pui.traverse(menu.antiaim.main, function(element, path)
            if path[1] ~= 'master_switch' and path[1] ~= 'hidden_notice' then
                element:set_visible(false)
            end
        end)
    end

    local original = {} do
        local to_hide = {
            ref.antiaim_enabled,
            ref.pitch_mode,
            ref.pitch_value,
            ref.yaw_base,
            ref.yaw_mode,
            ref.yaw_value,
            ref.yaw_jitter_mode,
            ref.yaw_jitter_value,
            ref.body_yaw_mode,
            ref.body_yaw_value,
            ref.freestanding_body_yaw,
            ref.edge_yaw,
            ref.freestanding,
            ref.roll,
            -- ref.fakelag,
            -- ref.fakelag_mode,
            -- ref.fakelag_variance,
            -- ref.fakelag_limit
        }

        function original:hide(state)
            pui.traverse(to_hide, function(element)
                element:set_visible(not state)
            end)
        end
    end

    function menu:hide_original(state)
        original:hide(state)
    end
end

config_system:menu_init()

exploit = {} do
    exploit.active = false
    exploit.charged = false
    exploit.disabled = false

    local doubletap = {} do
        doubletap.active = false
        doubletap.charged = false
        doubletap.disabled = false
        doubletap.forced_discharge = false

        function doubletap:reset()
            self.active = false
            self.charged = false
            self.disabled = false
            self.forced_discharge = false
        end

        function doubletap:restore()
            ref.doubletap:override()
        end

        function doubletap:disable()
            ref.doubletap:override(false)
            self.disabled = true
        end

        ---@param cmd struct pass it to call it in the same tick
        function doubletap:force_discharge(cmd)
            if cmd and cmd.discharge_pending ~= nil then
                cmd.discharge_pending = true
            end

            self.forced_discharge = true
        end

        local restore = false

        function doubletap:on_setup_command(cmd)
            if self.disabled then
                self:reset()
                restore = true
                return
            end

            if restore then
                restore = false
                self:restore()
            end

            if self.forced_discharge then
                self.forced_discharge = false
                cmd.discharge_pending = true
            end

            if not ref.doubletap:get()
            or not ref.doubletap:get_hotkey() then
                self:reset()
                return
            end

            self.active = true
            self.charged = exploit.charged
        end
    end

    local hideshots = {} do
        hideshots.active = false
        hideshots.charged = false
        hideshots.disabled = false

        function hideshots:reset()
            self.active = false
            self.charged = false
            self.disabled = false
        end

        function hideshots:restore()
            ref.onshot_antiaim:override()
            ref.onshot_antiaim.hotkey:override()
        end

        function hideshots:disable()
            ref.onshot_antiaim:override(false)
            self.disabled = true
        end

        local restore = false

        function hideshots:on_setup_command()
            if self.disabled then
                self:reset()
                restore = true
                return
            end

            if restore then
                restore = false
                self:restore()
            end

            if not ref.onshot_antiaim.value
            or not ref.onshot_antiaim:get_hotkey() then
                self:reset()
                return
            end

            self.active = true
            self.charged = exploit.charged
        end
    end

    local defensive = {} do
        defensive.active = false
        defensive.active_until = 0
        defensive.ticks = 0
        defensive.ticks_from_activation = 0
        defensive.disabled = false
        defensive.forced = false

        function defensive:reset()
            self.active = false
            self.active_until = 0
            self.ticks = 0
            self.ticks_from_activation = 0
            self.disabled = false
            self.forced = false
        end

        function defensive:disable()
            self.disabled = true
        end

        ---@param cmd struct pass it to call it in the same tick
        function defensive:force(cmd)
            if cmd and cmd.force_defensive ~= nil then
                cmd.force_defensive = true
            end

            self.forced = true
        end

        local prev_sim_time = 0

        function defensive:detect()
            local local_player = vars.local_player
            local tickcount = globals.tickcount()

            local sim_time = toticks(entity.get_prop(local_player, 'm_flSimulationTime'))
            local sim_diff = sim_time - prev_sim_time

            if sim_diff < 0 then
                self.active_until = tickcount + math.abs(sim_diff) - toticks(client.real_latency()) - 1
                -- self.active_until = tickcount + math.abs(sim_diff)
                self.ticks = self.active_until - tickcount
            end

            prev_sim_time = sim_time

            self.active = self.active_until > tickcount

            if self.active then
                self.ticks_from_activation = self.ticks - (self.active_until - tickcount) + 1
            end
        end

        local hittable_time = 0
        local last_hittable_time = 0

        function defensive:handle(cmd)

        end

        function defensive:on_setup_command(cmd)
            if not exploit.charged then
                self:reset()
                return
            end

            if self.disabled then
                self.disabled = false
            end

            if self.forced then
                self.forced = false
                cmd.force_defensive = true
            end

            -- self:handle(cmd)
            self:detect()
        end
    end

    function exploit:reset()
        self.active = false
        self.charged = false
        self.disabled = false

        doubletap:reset()
        hideshots:reset()
        defensive:reset()
    end

    function exploit:restore()
        ref.doubletap:override()
        ref.onshot_antiaim:override()
    end

    function exploit:disable()
        ref.doubletap:override(false)
        ref.onshot_antiaim:override(false)
        self.disabled = true
    end

    function exploit:detect()
        local m_nTickBase = entity.get_prop(vars.local_player, 'm_nTickBase')
        local shift = math.floor(m_nTickBase - globals.tickcount() - 3 - toticks(client.latency()) * .4)
        local wanted = -15 + (ref.doubletap_fakelag_limit.value - 1) + 5 --error margin

        self.charged = shift <= wanted
    end

    local restore = false

    function exploit:on_setup_command(cmd)
        if self.disabled then
            self:reset()
            restore = true
            return
        end

        if restore then
            restore = false
            self:restore()
        end

        self:detect()

        doubletap:on_setup_command(cmd)
        hideshots:on_setup_command()
        defensive:on_setup_command(cmd)

        self.active = doubletap.active or hideshots.active

        -- print('\nexploit = ', inspect(exploit))
    end

    exploit.doubletap = doubletap
    exploit.hideshots = hideshots
    exploit.defensive = defensive
end

antiaim = {} do
    antiaim.p_state = {
        raw_condition = 'stand',
        condition = 'stand',
        team = 'terrorist',
        fakelag = false,
        second_condition = 'normal',
        other_condition = false,
        velocity = 0,
        pitch = 0
    }

    function antiaim:get_target()
        local current_threat = client.current_threat()

        if current_threat == nil then
            return nil, nil
        end

        local steamid = entity.get_steam64(current_threat)

        if steamid == 0 then
            steamid = current_threat
        end

        return current_threat, tostring(steamid)
    end

    local legit_antiaim = {} do
        function legit_antiaim:detect_planting(local_player)
            if entity.get_prop(local_player, 'm_bInBombZone') == 0 then
                return false
            end

            local lp_wpn = entity.get_player_weapon(local_player)

            if lp_wpn and entity.get_classname(lp_wpn) == 'CC4' then
                return true
            end

            return false
        end

        function legit_antiaim:detect_defusing(local_player)
            if entity.get_prop(local_player, 'm_iTeamNum') ~= 3
            or entity.get_prop(vars.game_rules, 'm_bBombPlanted') ~= 1 then
                return false
            end

            local bomb = entity.get_all('CPlantedC4')[1]

            if not bomb then
                return false
            end

            local bomb_pos = vector(entity.get_prop(bomb, 'm_vecOrigin'))
            local lp_pos = vector(entity.get_origin(local_player))

            if bomb_pos and lp_pos and bomb_pos:dist(lp_pos) < 60 then
                return true
            end

            return false
        end

        local classnames = {
            'CWorld',
            'CCSPlayer',
            'CFuncBrush'
        }

        function legit_antiaim:detect_action(local_player)
            local eye_pos = vector(client.eye_position())
            local destination = eye_pos + vector():init_from_angles(client.camera_angles()) * 8192

            local fraction, entindex = client.trace_line(
                local_player,
                eye_pos.x, eye_pos.y, eye_pos.z,
                destination.x, destination.y, destination.z
            )

            if entindex and entindex ~= -1 then
                local using = true
                local traced_classname = entity.get_classname(entindex)

                for i = 1, #classnames do
                    if traced_classname == classnames[i] then
                        using = false
                    end
                end

                if using then
                    return true
                end
            end

            local bomb_carrier = entity.get_prop(entity.get_player_resource(), 'm_iPlayerC4')

            if bomb_carrier and bomb_carrier ~= 0 and bomb_carrier == entindex then
                return true
            end

            return false
        end

        function legit_antiaim:verify(cmd)
            if cmd.in_use == 1 then
                local local_player = vars.local_player

                if self:detect_planting(local_player)
                or self:detect_defusing(local_player)
                or self:detect_action(local_player) then
                    return false
                end
            end

            return true
        end

        function legit_antiaim:settings()
            local data = {
                yaw = -180,
                yaw_jitter = 'Off',
                yaw_jitter_value = 0,
                body_yaw = 'Jitter',
                body_yaw_value = 0,
                freestanding_body_yaw = true
            }

            if exploit.defensive.active then
                data.yaw_jitter = 'Center'
                data.yaw_jitter_value = 180
                data.body_yaw = 'Static'
                data.body_yaw_value = -180
                data.freestanding_body_yaw = false
            end

            return data
        end
    end

    function antiaim:player_condition(cmd)
        local local_player = vars.local_player

        local legit_aa = menu.antiaim.additions.selector:get('Legit anti-aim') and menu.antiaim.additions.legit_antiaim:get_hotkey() and legit_antiaim:verify(cmd)
        local onground = cmd.in_jump == 0 and bit.band(entity.get_prop(local_player, 'm_fFlags'), 1) == 1
        local velocity = vector(entity.get_prop(local_player, 'm_vecVelocity')):length2d()
        local crouched = onground and entity.get_prop(local_player, 'm_flDuckAmount') == 1
        local fakeducking = onground and ref.fakeduck:get()
        local slowwalking = onground and velocity > 1.011 and not crouched and ref.slowmotion.value and ref.slowmotion:get_hotkey()
        local inair = not onground

        if entity.get_prop(vars.game_rules, 'm_bFreezePeriod') == 1 then
            return 'stand'
        end

        if legit_aa then
            return 'legit aa'
        elseif inair then
            if cmd.in_duck == 1 then
                return 'air crouch'
            end

            return 'air'
        elseif crouched or fakeducking then
            if velocity > 1.011 then
                return 'crouch move'
            end

            return 'crouch'
        elseif slowwalking then
            return 'slowwalk'
        elseif onground and velocity > 1.011 then
            return 'move'
        else--if onground and velocity < 1.011 then
            return 'stand'
        end
    end

    local jitter_side = false

    local team_index_to_name = {
        [2] = 'terrorist',
        [3] = 'counter terrorist'
    }

    --skeet yaw jitter 58-98 slower
    function antiaim:fixes(cmd, holding_exploit)
        if holding_exploit or self.p_state.velocity < 1.011 then
            cmd.no_choke = true
        end
    end

    function antiaim:update_vars(cmd)
        if cmd.chokedcommands == 0 then
            jitter_side = not jitter_side
        end

        local holding_exploit = (ref.doubletap.value and ref.doubletap:get_hotkey()) or (ref.onshot_antiaim.value and ref.onshot_antiaim:get_hotkey())
        local exploiting = holding_exploit and not ref.fakeduck:get()

        local local_player = vars.local_player

        local condition = self:player_condition(cmd)

        local legitaa_on = self.p_state.raw_condition == 'legit aa'
        local in_air = self.p_state.raw_condition == 'air' or self.p_state.raw_condition == 'air crouch'

        self.p_state.velocity = vector(entity.get_prop(local_player, 'm_vecVelocity')):length2d()
        self.p_state.raw_condition = condition
        self.p_state.fakelag = (ref.fakelag.value and ref.fakelag:get_hotkey()) and not exploiting and not legitaa_on and self.p_state.velocity > 1.011
        self.p_state.condition = self.p_state.fakelag and 'fakelag' or condition
        self.p_state.team = team_index_to_name[entity.get_prop(local_player, 'm_iTeamNum')] or 'terrorist'
        -- self.p_state.second_condition = condition
        -- self.p_state.other_condition = condition

        if ref.fakelag_limit.value < 14 then
            ref.fakelag_limit:set(14)
        end

        if ref.roll.value ~= 0 then
            ref.roll:set(0)
        end

        if menu.antiaim.additions.selector:get('Force defensive')
        and (menu.antiaim.additions.force_defensive:get_hotkey()
        or menu.antiaim.additions.force_defensive:get(condition)) then
            cmd.force_defensive = true
        end

        self:fixes(cmd, holding_exploit)
    end

    local system = {} do
        local ladder_time = 0

        function system:ladder_check()
            -- antiaim.p_state.velocity ~= 0
            if entity.get_prop(vars.local_player, 'm_MoveType') == 9 then
                ladder_time = globals.tickcount() + 2
            end

            if ladder_time > globals.tickcount() + 2 then
                ladder_time = 0
            end
        end

        function system:basic_check(cmd, tickcount)
            if ladder_time >= tickcount
            or cmd.in_use == 1
            or entity.get_prop(vars.game_rules, 'm_bFreezePeriod') == 1 then
                return false
            end

            return true
        end

        function system:detect_action(cmd, weapon, local_player)
            local throw_time = entity.get_prop(weapon, 'm_fThrowTime')

            if throw_time and throw_time > 0 then
                return true
            end

            if cmd.in_attack == 1 and math.max(
                entity.get_prop(weapon, 'm_flNextPrimaryAttack') or 0,
                entity.get_prop(local_player, 'm_flNextAttack') or 0
            ) <= globals.curtime() then
                return true
            end

            return false
        end

        function system:get_body_yaw(data)
            local body_yaw_mode = data.body_yaw
            local fake_limit = data.fake_limit and data.fake_limit or 60

            if body_yaw_mode == 'Off' then
                return 0, 0
            elseif body_yaw_mode == 'Opposite' then
                return 1, fake_limit
            elseif body_yaw_mode == 'Jitter' then
                return jitter_side and 1 or -1, fake_limit
            elseif body_yaw_mode == 'Static' then
                local body_yaw_value = data.body_yaw_value

                if body_yaw_value == 0 then
                    return 0, 0
                end

                local body_side = body_yaw_value > 0 and -1 or 1
                local fake = math.min(math.abs(body_yaw_value), fake_limit)

                return body_side, fake
            end
        end

        local skitter_stage = 1

        function system:get_values(cmd, data)
            local body_side, body_fake = self:get_body_yaw(data)

            local yaw_jitter_side = jitter_side

            local yaw = data.yaw
            local yaw_jitter_mode = data.yaw_jitter
            local yaw_jitter_value = data.yaw_jitter_value

            if yaw_jitter_mode == 'Offset' then
                yaw = yaw + (yaw_jitter_side and 0 or yaw_jitter_value)
            elseif yaw_jitter_mode == 'Center' then
                yaw = yaw + (yaw_jitter_side and -yaw_jitter_value / 2 or yaw_jitter_value / 2)
            elseif yaw_jitter_mode == 'Random' then
                yaw = yaw + client.random_int(-yaw_jitter_value / 2, yaw_jitter_value / 2)
            elseif yaw_jitter_mode == 'Skitter' then
                -- 131 231 232 132
                if cmd.chokedcommands == 0 then
                    skitter_stage = skitter_stage % 12
                    skitter_stage = skitter_stage + 1
                end

                local stages = {
                    -yaw_jitter_value, yaw_jitter_value, -yaw_jitter_value,
                    0, yaw_jitter_value, -yaw_jitter_value,
                    0, yaw_jitter_value, 0,
                    -yaw_jitter_value, yaw_jitter_value, 0
                }

                local value = math.clamp(stages[skitter_stage], -90, 90)

                yaw = yaw + value

                if data.body_yaw == 'Jitter' then
                    body_side = value == 0 and 0 or (value > 0 and -1 or 1)
                end
            end

            return yaw, body_side, body_fake
        end

        function system:run(cmd, data, target, pitch, yaw_base, yaw_mode)
            local local_player = vars.local_player

            local tickcount = globals.tickcount()
            local lp_wpn = entity.get_player_weapon(local_player)

            if not self:basic_check(cmd, tickcount) then
                return
            end

            local action = self:detect_action(cmd, lp_wpn, local_player)

            if action then
                cmd.no_choke = true
                return
            end

            local yaw, body_side, body_fake = self:get_values(cmd, data)
            -- print(yaw, ', ', body_side, ', ', body_fake)

            local camera_angles = vector(client.camera_angles())
            local lp_origin = vector(entity.get_origin(local_player))

            yaw = yaw + ({
                ['Local view'] = camera_angles.y,
                ['At targets'] = target and vector(lp_origin:to(vector(entity.get_origin(target))):angles()).y or camera_angles.y,
            })[yaw_base]

            if yaw_mode == '180' then
                yaw = yaw + 180
            elseif yaw_mode == 'Spin' then
                yaw = yaw + math.fmod(globals.curtime() * 30 * data.yaw, 360)
            end

            if cmd.chokedcommands == 0 then
                cmd.allow_send_packet = false

                yaw = yaw + ((body_fake * 2) * body_side)
            else
                yaw = yaw
            end

            if type(pitch) ~= 'number' then
                local pitch_values = {
                    ['Off'] = camera_angles.x,
                    ['Default'] = 89,
                    ['Up'] = -89,
                    ['Down'] = 89,
                    ['Mininal'] = 89,
                    ['Random'] = ({89, 0, -89})[client.random_int(1, 3)]
                }

                pitch = pitch_values[pitch]
            end

            -- cmd.forwardmove = 1.01 * (jitter_side and -1 or 1)

            cmd.yaw = yaw
            cmd.pitch = pitch
        end

        function system:on_run_command()
            self:ladder_check()
        end
    end

    local manual_antiaim = {} do
        manual_antiaim.active = false

        local yaw = 0
        local directions = {-90, 90, 180}
        local pressed = {}

        function manual_antiaim:handle()
            menu.antiaim.additions.manual_antiaim.reset:set('On hotkey')

            if not menu.antiaim.additions.selector:get('Manual anti-aim')
            or menu.antiaim.additions.manual_antiaim.reset:get() then
                yaw = 0
                self.active = false
                return
            end

            local keys = menu.antiaim.additions.manual_antiaim.directions

            for i = 1, #keys do
                local key = keys[i]

                key:set('On hotkey')

                if not pressed[i] and key:get() then
                    yaw = yaw == directions[i] and 0 or directions[i]
                    pressed[i] = true
                elseif not key:get() then
                    pressed[i] = false
                end
            end

            self.active = yaw ~= 0
        end

        function manual_antiaim:settings()
            local data = {
                yaw = yaw,
                yaw_jitter = 'Off',
                yaw_jitter_value = 0,
                body_yaw = 'Static',
                body_yaw_value = 180,
                freestanding_body_yaw = false
            }

            if data.yaw == 180 then
                data.body_yaw_value = 0
            end

            return data
        end
    end

    local freestand = {} do
        freestand.active = false
        freestand.hotkey = false
        freestand.disabled = false

        function freestand:reset()
            self:set_disabled()
            self.active = false
            self.disabled = false
        end

        function freestand:disable()
            self:set_disabled()
            self.disabled = true
        end

        function freestand:set_disabled()
            if ref.freestanding.value then
                ref.freestanding:set(false)
            end
        end

        function freestand:set_enabled()
            ref.freestanding:set(true)
            ref.freestanding:set_hotkey('Always on')
            self.active = true
        end

        function freestand:handle(condition)
            local key = menu.antiaim.additions.selector:get('Freestand') and menu.antiaim.additions.freestand:get_hotkey()

            if not key then
                self:reset()
                self.hotkey = false
                return
            end

            self.hotkey = true

            if condition == 'legit aa'
            or manual_antiaim.active then
                self:reset()
                return
            end

            if self.disabled then
                self:reset()
                return
            end

            local disablers = menu.antiaim.additions.freestand

            if (condition == 'air' or condition == 'air crouch') and disablers:get('Air')
            or condition == 'slowwalk' and disablers:get('Slowwalk')
            or (condition == 'crouch' or condition == 'crouch move') and disablers:get('Crouch')
            or condition == 'move' and disablers:get('Move') then
                self:reset()
                return
            end

            self:set_enabled()
        end

        function freestand:settings()
            return {
                yaw = 0,
                yaw_jitter = 'Off',
                yaw_jitter_value = 0,
                body_yaw = 'Static',
                body_yaw_value = 60,
                freestanding_body_yaw = false
            }
        end

        antiaim.freestand = freestand
    end

    local custom_jitter_side = false

    --if body_yaw == 'Jitter' to fix na bugged bodyyaw w skeet builderze to data.body_yaw_value = -1
    function antiaim:handle_antiaim_data(cmd, data, skeet)
        if data.body_yaw == 'Jitter' then
            data.body_yaw = 'Static'
            data.body_yaw_value = jitter_side and -60 or 60
            -- data.body_yaw_value = -1

            if type(data.yaw) == 'table' then
                data.yaw = data.body_yaw_value < 0 and data.yaw.left or data.yaw.right
            end

            if skeet and data.yaw_jitter ~= 'Off' then
                data.yaw = data.yaw + (jitter_side and -data.yaw_jitter_value / 2 or data.yaw_jitter_value / 2)
                data.yaw_jitter = 'Off'
            end
        elseif type(data.body_yaw) == 'table' then
            local delay = data.body_yaw[2]

            if cmd.chokedcommands == 0 then
                custom_jitter_side = cmd.command_number % (delay * 2) < delay
            end

            data.body_yaw = 'Static'
            data.body_yaw_value = custom_jitter_side and -60 or 60

            if type(data.yaw) == 'table' then
                data.yaw = custom_jitter_side and data.yaw.left or data.yaw.right
            end

            if data.yaw_jitter ~= 'Off' then
                data.yaw = data.yaw + (custom_jitter_side and -data.yaw_jitter_value / 2 or data.yaw_jitter_value / 2)
                data.yaw_jitter = 'Off'
            end
        end

        if type(data.yaw) == 'table' then
            data.yaw = data.body_yaw_value < 0 and data.yaw.left or data.yaw.right
        end

        if data.yaw_jitter == 'Off' then
            data.yaw_jitter_value = 0
        end

        if data.body_yaw == 'Off' then
            data.body_yaw_value = 0
        end

        return data
    end

    local function set_antiaim_values(data)
        ref.yaw_value:set(data.yaw)
        ref.yaw_jitter_mode:set(data.yaw_jitter)
        ref.yaw_jitter_value:set(data.yaw_jitter_value)
        ref.body_yaw_mode:set(data.body_yaw)
        ref.body_yaw_value:set(data.body_yaw_value)
        ref.freestanding_body_yaw:set(data.freestanding_body_yaw)
    end

    function antiaim:builder(condition)
        if condition == 'fakelag'
        and not menu.antiaim.main.builder[condition].override_condition.value then
            condition = self.p_state.raw_condition
        end

        if condition == 'legit aa' then
            return {
                yaw = 0,
                yaw_jitter = 'Off',
                yaw_jitter_value = 0,
                body_yaw = 'Off',
                body_yaw_value = 0,
                freestanding_body_yaw = false
            }
        end

        if not menu.antiaim.main.builder[condition].override_condition.value then
            condition = 'shared'
        end

        local tab = menu.antiaim.main.builder[condition]

        local data = {
            yaw = 0,
            yaw_jitter = tab.yaw_jitter.value,
            yaw_jitter_value = tab.yaw_jitter_value.value,
            body_yaw = 'Off',
            body_yaw_value = tab.body_yaw_value.value,
            freestanding_body_yaw = false
        }

        if tab.yaw_mode.value == 'Static' then
            data.yaw = tab.yaw.value
        else
            data.yaw = {
                left = tab.yaw_left.value,
                right = tab.yaw_right.value
            }
        end

        if tab.body_yaw.value == 'Custom' then
            data.body_yaw = {'Custom', tab.delay_ticks.value}
        else
            data.body_yaw = tab.body_yaw.value
        end

        return data
    end

    local safe_head = {} do
        local weapon_types = {
            -- [0] = 'knife zeus',
            [1] = 'pistols',
            -- [2] = 'smg',
            -- [3] = 'rifles',
            -- [4] = 'shotguns',
            -- [5] = 'snipers',
            -- [6] = 'negev m249',
            [9] = 'grenades'
        }

        local weapons_to_index = {
            ['CWeaponSSG08'] = 1,
            ['CWeaponAWP'] = 2,
            ['CWeaponG3SG1'] = 3,
            ['CWeaponSCAR20'] = 4,
            ['CWeaponTec9'] = 5,
            ['pistol'] = 6,
            ['CKnife'] = 7
        }

        local values = {
            ['terrorist'] = {
                ['stand'] = {
                    [1] = -2,
                    [2] = -2,
                    [3] = -6.4,
                    [4] = -2,
                    [5] = 4.2,
                    [6] = 12,
                    [7] = 15
                },
                -- ['Move'] = {},
                ['crouch'] = {
                    [1] = 2.4,
                    [2] = 2.4,
                    [3] = 2.4,
                    [4] = 2.4,
                    [5] = -13,
                    [6] = -13,
                    [7] = -12
                },
                ['crouch move'] = {
                    [1] = 2.4,
                    [2] = 2.4,
                    [3] = 2.4,
                    [4] = 2.4,
                    [5] = -9.3,
                    [6] = -8,
                    [7] = -9
                },
                -- ['Slowwalk'] = {},
                ['air crouch'] = {
                    [1] = 7.5,
                    [2] = 7.5,
                    [3] = 6,
                    [4] = 7,
                    [5] = -3.5,
                    [6] = -3.5,
                    [7] = -15
                },
                ['air'] = {
                    [1] = 14,
                    [2] = 14,
                    [3] = 14,
                    [4] = 14,
                    [5] = 12,
                    [6] = 17,
                    [7] = 14
                }
            },
            ['counter terrorist'] = {
                ['stand'] = {
                    [1] = -3.6,
                    [2] = -3.6,
                    [3] = -4,
                    [4] = -4,
                    [5] = 5.2,
                    [6] = 13,
                    [7] = 12
                },
                -- ['Move'] = {},
                ['crouch'] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = 4,
                    [4] = .2,
                    [5] = -11,
                    [6] = -8.5,
                    [7] = -6
                },
                ['crouch move'] = {
                    [1] = -1.6,
                    [2] = -1.6,
                    [3] = 4.3,
                    [4] = 0,
                    [5] = -7,
                    [6] = -5,
                    [7] = -14
                },
                -- ['Slowwalk'] = {},
                ['air crouch'] = {
                    [1] = 10,
                    [2] = 10,
                    [3] = 7,
                    [4] = 7,
                    [5] = 2,
                    [6] = 2,
                    [7] = -12
                },
                ['air'] = {
                    [1] = 14,
                    [2] = 14,
                    [3] = 14,
                    [4] = 14,
                    [5] = 12,
                    [6] = 17,
                    [7] = 14
                }
            }
        }

        local right_yaw = {
            ['terrorist'] = {
                ['stand'] = 23,
                -- ['Move'] = 0,
                ['crouch'] = 23,
                ['crouch move'] = 16,
                -- ['Slowwalk'] = 0,
                ['air crouch'] = 11,
                ['air'] = 17
            },
            ['counter terrorist'] = {
                ['stand'] = 35,
                -- ['Move'] = 0,
                ['crouch'] = 35,
                ['crouch move'] = 30,
                -- ['Slowwalk'] = 0,
                ['air crouch'] = 14,
                ['air'] = 23
            }
        }

        local too_high = {
            ['terrorist'] = {
                ['stand'] = 63,
                -- ['Move'] = 0,
                ['crouch'] = 41,
                ['crouch move'] = 39,
                -- ['Slowwalk'] = 0,
                ['air crouch'] = 28,
                ['air'] = 43
            },
            ['counter terrorist'] = {
                ['stand'] = 61,
                -- ['Move'] = 0,
                ['crouch'] = 44,
                ['crouch move'] = 42,
                -- ['Slowwalk'] = 0,
                ['air crouch'] = 55,
                ['air'] = 65
            }
        }

        function safe_head:handle(cmd, entindex)
            if not entindex then
                return false
            end

            if antiaim.p_state.raw_condition == 'legit aa'
            or antiaim.p_state.raw_condition == 'move'
            or antiaim.p_state.raw_condition == 'slowwalk' then
                return false
            end

            local local_player = vars.local_player

            if entity.get_prop(local_player, 'm_flNextAttack') > globals.curtime() then
                return false
            end

            local lp_weapon = entity.get_player_weapon(local_player)

            if not lp_weapon then
                return false
            end

            local target_eyepos = vector(entity.get_origin(entindex)) + vector(entity.get_prop(entindex, 'm_vecViewOffset'))
            local eyepos = vector(client.eye_position())
            local angles_to_enemy = vector(eyepos:to(target_eyepos):angles())
            local pitch, yaw = angles_to_enemy.x, angles_to_enemy.y

            -- print(pitch)

            antiaim.p_state.pitch = pitch

            local team = antiaim.p_state.team
            local terrorist = team == 'terrorist'
            local raw_condition = antiaim.p_state.raw_condition

            if pitch > too_high[team][raw_condition] then
                return false
            end

            local wpn_classname = entity.get_classname(lp_weapon)
            local wpn_info = weapons_c(lp_weapon)

            if not wpn_info then
                return false
            end

            local value = values[team][raw_condition][weapons_to_index[wpn_classname] or weapons_to_index[wpn_info.type]] or 15

            if value > pitch then
                return false
            end

            local data = {
                yaw = 0,
                yaw_jitter = 'Off',
                yaw_jitter_value = 0,
                body_yaw = 'Static',
                body_yaw_value = 0,
                freestanding_body_yaw = false
            }

            if terrorist then
                if raw_condition == 'stand' then
                    data.yaw = -1
                    -- data.yaw = 15
                    -- data.fake = 24
                elseif raw_condition == 'crouch' then
                    -- data.yaw = -2
                    -- data.yaw = 1
                    -- data.yaw = 32
                    -- data.fake = 30
                    data.yaw = 32
                    data.body_yaw_value = 40
                elseif raw_condition == 'crouch move' then
                    data.yaw = 32
                    data.body_yaw_value = 40

                    data.yaw = data.yaw + (cmd.in_moveleft == 1 and -3 or cmd.in_moveright == 1 and 4 or 0)
                    data.yaw = data.yaw + (cmd.in_forward == 1 and -5 or cmd.in_back == 1 and 2 or 0)
                elseif raw_condition == 'air' then
                    -- data.yaw = -14
                    -- data.yaw = 32
                    data.body_yaw_value = 60
                elseif raw_condition == 'air crouch' then
                    if wpn_classname == 'CKnife' then
                        data.yaw = 10
                    else
                        if antiaim.p_state.velocity > 100 then
                            data.yaw = 12
                            data.body_yaw_value = 60
                        else
                            data.yaw = 24
                            data.body_yaw_value = 60
                        end
                    end
                end
            else
                if raw_condition == 'stand' then
                    -- data.yaw = -1
                elseif raw_condition == 'crouch' then
                    -- data.yaw = -5
                    data.yaw = 32
                    data.body_yaw_value = 40
                elseif raw_condition == 'crouch move' then
                    data.yaw = 32
                    data.body_yaw_value = 40
                    -- data.yaw = 12

                    data.yaw = data.yaw + (cmd.in_moveleft == 1 and -3 or cmd.in_moveright == 1 and 4 or 0)
                    data.yaw = data.yaw + (cmd.in_forward == 1 and -3 or cmd.in_back == 1 and 2 or 0)
                elseif raw_condition == 'air crouch' then
                    if wpn_classname == 'CKnife' then
                        data.yaw = 33
                        data.body_yaw_value = -60
                    else
                        if antiaim.p_state.velocity > 100 then
                            data.yaw = 12
                            data.body_yaw_value = 60
                        else
                            data.yaw = 35
                            data.body_yaw_value = 60
                        end
                    end
                end
            end

            if pitch > right_yaw[team][raw_condition] then
                data.yaw = data.yaw + 12
            end

            return data
        end
    end

    function antiaim:update_values(cmd)
        local entindex, steamid = self:get_target()
        local condition = self.p_state.condition
        local raw_condition = self.p_state.raw_condition

        local legitaa_on = condition == 'legit aa'

        local pitch = 'Default'
        local yaw_base = 'At targets'
        local yaw_mode = '180'

        local use_skeet, skip_defensive = false, false

        local data = {
            yaw = 0,
            yaw_jitter = 'Off',
            yaw_jitter_value = 0,
            body_yaw = 'Off',
            body_yaw_value = 0,
            freestanding_body_yaw = false
        }

        local second_condition = 'normal'

        local preset = menu.antiaim.main.preset.value

        freestand:handle(raw_condition)
        manual_antiaim:handle()

        local safeaa = false

        if menu.antiaim.additions.selector:get('Safe head') and menu.antiaim.additions.safe_head:get() then
            safeaa = safe_head:handle(cmd, entindex)
        end

        if legitaa_on then
            cmd.in_use = 0
            data = legit_antiaim:settings()
            pitch = 'Off'
            yaw_base = menu.antiaim.additions.legit_antiaim.value

            use_skeet = true
        elseif manual_antiaim.active then
            data = manual_antiaim:settings()
            yaw_base = menu.antiaim.additions.manual_antiaim.yaw_base.value
            second_condition = 'manual '.. (data.yaw == 180 and 'forward' or (data.yaw == 90 and 'right' or 'left'))

            if exploit.defensive.active
            and menu.antiaim.additions.defensive_antiaim_conditions:get('manual anti-aim') then
                pitch = 0
                data.yaw = -data.yaw
            end

            use_skeet = true
        elseif freestand.active then
            data = freestand:settings()

            if exploit.defensive.active
            and menu.antiaim.additions.defensive_antiaim_conditions:get('freestand') then
                -- local eyepos = vector(client.eye_position())
                -- -- local threat_origin = vector(entity.get_origin(entindex))
                -- local head_pos = vector(entity.hitbox_position(vars.local_player, 0))
                -- local angle_to_threat = vector(eyepos:to(vector(entity.get_origin(entindex))):angles()).y
                -- local angle = math.normalize_yaw(vector(eyepos:to(head_pos):angles()).y - angle_to_threat)

                -- if angle < 90 and angle > 55 then
                --     data.yaw = 90
                -- elseif angle < -85 and angle > -130 then
                --     data.yaw = -90
                -- end

                data.yaw = jitter_side and 90 or -90
                data.body_yaw_value = -60

                pitch = 'Up'
                freestand:set_disabled()
            end

            use_skeet = true
        elseif safeaa then
            data = safeaa
            second_condition = 'safe head'

            use_skeet = true
        elseif preset == 'Configurator' then
            data = self:builder(condition)
        end

        if exploit.defensive.active
        and (second_condition == 'safe head' and menu.antiaim.additions.defensive_antiaim_conditions:get('safe head')
        or menu.antiaim.additions.defensive_antiaim_conditions:get(condition)) then
            if second_condition == 'safe head' then
                pitch = 'Up'
                data.yaw = ({30, 60, 90, 120, 150, 180, -150, -120, -90, -60, -30})[cmd.command_number % 11 + 1]
                data.yaw_jitter = 'Off'
                data.body_yaw = 'Static'
                data.body_yaw_value = 60
            elseif condition == 'crouch' then
                pitch = 0
                data.yaw = -180
                data.yaw_jitter = 'Off'
                data.body_yaw = 'Static'
                data.body_yaw_value = 60
            elseif condition == 'crouch move' then
                pitch = -45
                data.yaw = ({30, 60, 90, 120, 150, 180, -150, -120, -90, -60, -30})[cmd.command_number % 11 + 1]
                data.yaw_jitter = 'Off'
                data.body_yaw = 'Static'
                data.body_yaw_value = 60
            elseif condition == 'move' or condition == 'air' or condition == 'air crouch' then
                pitch = 0
                data.yaw = ({30, 60, 90, 120, 150, 180, -150, -120, -90, -60, -30})[cmd.command_number % 11 + 1]
                data.yaw_jitter = 'Off'
                data.body_yaw = 'Static'
                data.body_yaw_value = 60
            else
                data.yaw_jitter = 'Center'
                data.yaw_jitter_value = 180
                data.body_yaw = 'Jitter'
                data.body_yaw_value = 0
            end
        end

        -- do
        --     data = {
        --         yaw = -90,
        --         yaw_jitter = 'Off',
        --         yaw_jitter_value = 0,
        --         body_yaw = 'Static',
        --         body_yaw_value = 60,
        --         freestanding_body_yaw = false
        --     }

        --     pitch = 'Default'

        --     local tickcount = globals.servertickcount()
        --     -- print('1 ', cmd.command_number)
        --     -- print(globals.tickcount())
        --     -- print(globals.servertickcount())

        --     -- if not CLOCK then
        --     --     CLOCK = 0
        --     -- end

        --     -- CLOCK = CLOCK + 1
        --     -- print(CLOCK)

        --     -- local tickcount = CLOCK

        --     local safe_ticks = 3

        --     if not exploit.charged then
        --         SWITCH = false
        --         DELAY = 0
        --         TIME = 0
        --         LAST_UPDATE = 0

        --         -- print('reset')
        --     elseif not SWITCH then
        --         SWITCH = true
        --         cmd.force_defensive = true
        --         DELAY = tickcount + 16
        --         TIME = tickcount + 13
        --         -- print('1 UPDATE ', tickcount - LAST_UPDATE)
        --         LAST_UPDATE = tickcount
        --         -- print(tickcount - LAST_UPDATE)
        --     end

        --     if TIME - safe_ticks >= tickcount and LAST_UPDATE + 2 + safe_ticks <= tickcount then
        --         data.yaw = 90

        --         -- if LAST_UPDATE + 2 == tickcount then
        --         --     print('3 UPDATE ', tickcount - LAST_UPDATE)
        --         -- end
        --         print('3 UPDATE ', tickcount - LAST_UPDATE)
        --     end

        --     if SWITCH and DELAY <= tickcount then
        --         SWITCH = false
        --         -- print('2 UPDATE ', tickcount - LAST_UPDATE)
        --     end

        --     use_skeet = false
        -- end

        if menu.other.disable_custom_desync and menu.other.disable_custom_desync.value then
            use_skeet = true
        end

        data = self:handle_antiaim_data(cmd, data, use_skeet)

        if use_skeet then
            set_antiaim_values(data)
        else
            system:run(cmd, data, entindex, pitch, yaw_base, yaw_mode)

            set_antiaim_values({
                yaw = legitaa_on and -180 or 0,
                yaw_jitter = 'Off',
                yaw_jitter_value = 0,
                body_yaw = 'Jitter',
                body_yaw_value = 0,
                freestanding_body_yaw = false
            })
        end

        ref.antiaim_enabled:set(true)

        if type(pitch) == 'number' then
            ref.pitch_mode:set('Custom')
            ref.pitch_value:set(pitch)
        else
            ref.pitch_mode:set(pitch)
        end

        ref.yaw_base:set(yaw_base)
        ref.yaw_mode:set(yaw_mode)

        -- print(vector(entity.get_prop(vars.local_player, 'm_vecVelocity')))
        -- print(self.p_state.velocity)

        self.p_state.second_condition = second_condition
    end

    function antiaim:on_setup_command(cmd)
        self:update_vars(cmd)
        self:update_values(cmd)
    end

    function antiaim:on_run_command()
        system:on_run_command()
    end
end

automatic_peek = {} do
    local hitgroups_to_hitboxes = {
        ['Head'] = {0},
        ['Chest'] = {4, 5, 6},
        ['Stomach'] = {2, 3},
        ['Arms'] = {13, 14, 15, 16, 17, 18},
        ['Legs'] = {7, 8, 9, 10},
        ['Feet'] = {11, 12}
    }

    local allowed_hitboxes = {0, 5, 2, 15, 17, 9, 10}
    local active_hitboxes = {}

    local amount = 4
    local step_distance = 22

    local targeting = false
    local returning = false
    local should_return = false
    local teleport = false
    local disable_exploit = false

    local cache = {
        positions = {},
        middle_pos = vector(),
        last_returning_time = 0,
        active_point_index = 0,
        current_target = nil
    }

    local hotkeys = {
        main = false,
        force_baim = false
    }

    local visual = {
        values = {
            global_alpha = smoothy:new(),
            pos = {},
            alpha = {}
        },
        active = false
    }

    local function update_hitboxes(reference, force_baim)
        local new_hitboxes = {}
        local target_hitboxes = reference.value

        local force_baim_disabled_hitgroups = {'Head', 'Arms', 'Legs', 'Feet'}

        for i = 1, #target_hitboxes do
            if force_baim and table.contains(force_baim_disabled_hitgroups, target_hitboxes[i]) then
                goto continue
            end

            local hitgroup = hitgroups_to_hitboxes[target_hitboxes[i]]

            for j = 1, #hitgroup do
                local hitbox = hitgroup[j]

                if table.contains(allowed_hitboxes, hitbox) then
                    table.insert(new_hitboxes, hitbox)
                end
            end

            ::continue::
        end

        active_hitboxes = new_hitboxes
    end

    ref.target_hitbox:set_callback(update_hitboxes, true)

    local function skip_func(entindex, contents_mask)
        if entity.get_classname(entindex) == 'CCSPlayer' and entity.is_enemy(entindex) then
            return false
        end

        return true
    end

    local function handle_point(position, prev_position, angle, step_distance, index, view_offset, vec_mins, vec_maxs, max_step)
        local start_pos = prev_position and (prev_position - view_offset) or position
        local pos = common.extend_vector(start_pos, index == 0 and 0 or step_distance, angle)

        local trace_up = trace_lib.hull(
            start_pos, start_pos + vector(0, 0, max_step), vec_mins, vec_maxs, {skip = skip_func, mask = 0x201400B}
        ).end_pos

        local trace_horizontal = trace_lib.hull(
            vector(start_pos.x, start_pos.y, trace_up.z),
            vector(pos.x, pos.y, trace_up.z),
            vec_mins, vec_maxs, {skip = skip_func, mask = 0x201400B}
        ).end_pos

        if pos:dist2d(trace_horizontal) >= step_distance * .97 then
            return false
        end

        local trace_down = trace_lib.hull(
            trace_horizontal,
            vector(trace_horizontal.x, trace_horizontal.y, position.z - 240),
            vec_mins, vec_maxs, {skip = skip_func, mask = 0x201400B}
        ).end_pos

        return trace_down + view_offset
    end

    local max_step = 18

    local function setup_points(local_player, position, angle, amount, step_distance)
        local view_offset = vector(entity.get_prop(local_player, 'm_vecViewOffset'))
        local vec_mins = vector(entity.get_prop(local_player, 'm_vecMins'))
        local vec_maxs = vector(entity.get_prop(local_player, 'm_vecMaxs'))

        cache.positions[0] = handle_point(
            position, nil, 0,
            step_distance, 0, view_offset,
            vec_mins, vec_maxs, max_step
        )

        for i = 1, amount do
            local angle = i % 2 == 0 and angle - 90 or angle + 90

            local prev_point = cache.positions[i <= 2 and 0 or i - 2]

            if not prev_point then
                goto continue
            end

            local point = handle_point(
                position, prev_point, angle,
                step_distance, i, view_offset,
                vec_mins, vec_maxs, max_step
            )

            if not point or (prev_point and math.abs(prev_point.z - point.z) > max_step) then
                for k = i, amount, 2 do
                    cache.positions[k] = false
                end

                goto continue
            end

            cache.positions[i] = point

            ::continue::
        end

        return cache.positions
    end

    local function weapon_can_fire(player, weapon)
        local lp_NextAttack = entity.get_prop(player, 'm_flNextAttack')
        local wpn_NextPrimaryAttack = entity.get_prop(weapon, 'm_flNextPrimaryAttack')

        if math.max(0, lp_NextAttack or 0, wpn_NextPrimaryAttack or 0) > globals.curtime() or entity.get_prop(weapon, 'm_iClip1') <= 0 then
            return false
        end

        return true
    end

    local scope_weapons = {
        'CWeaponSSG08',
        'CWeaponAWP',
        'CWeaponG3SG1',
        'CWeaponSCAR20'
    }

    local function can_target(local_player, target)
        if not target then
            return false
        end

        local lp_wpn = entity.get_player_weapon(local_player)

        if not weapon_can_fire(local_player, lp_wpn) then
            return false
        end

        if not ref.automatic_scope.value
        and table.contains(scope_weapons, entity.get_classname(lp_wpn))
        and entity.get_prop(local_player, 'm_bIsScoped') ~= 1 then
            return false
        end

        if exploit.active and not exploit.charged then
            return false
        end

        if entity.get_prop(local_player, 'm_flVelocityModifier') ~= 1 then
            return false
        end

        local esp_data = entity.get_esp_data(target) or {alpha = 0}

        if esp_data.alpha < .75 then
            return false
        end

        return true
    end

    local function trace_enemy(positions, local_player, target, hitboxes)
        local target_health = entity.get_prop(target, 'm_iHealth')
        local minimum_damage = ref.min_damage_override.value and ref.min_damage_override:get_hotkey()
        and ref.min_damage_override_value.value or ref.min_damage.value

        for i = 1, #positions do
            local pos = positions[i]

            if not pos then
                goto continue
            end

            for j = 1, #hitboxes do
                local hitbox = hitboxes[j]
                local hitbox_pos = vector(entity.hitbox_position(target, hitbox))

                local entindex, damage = client.trace_bullet(
                    local_player,
                    pos.x, pos.y, pos.z,
                    hitbox_pos.x, hitbox_pos.y, hitbox_pos.z,
                    hitbox == 0 --bad fix
                )

                --bad fix
                if hitbox == 0 then
                    damage = damage * 4
                end

                if damage >= math.min(minimum_damage, target_health) and damage > 0 then
                    return pos, i
                end
            end

            ::continue::
        end

        return nil, 0
    end

    local function handle(cmd)
        local main_key = menu.antiaim.additions.selector:get('Automatic peek') and menu.antiaim.additions.automatic_peek:get_hotkey()

        if main_key and not hotkeys.main then
            local local_player = entity.get_local_player()
            local lp_origin = vector(entity.get_origin(local_player))
            cache.middle_pos = common.extrapolate_position(local_player, lp_origin, 13, true)
            hotkeys.main = true
        elseif not main_key and hotkeys.main then
            ref.quickpeek:override()
            ref.quickpeek.hotkey:override()
            ref.quickpeek_mode:override()
            ref.doubletap:override()
            ref.onshot_antiaim:override()
            hotkeys.main = false
        end

        local force_baim = ref.force_baim:get()

        if force_baim and not hotkeys.force_baim then
            update_hitboxes(ref.target_hitbox, true)
            hotkeys.force_baim = true
        elseif not force_baim and hotkeys.force_baim then
            update_hitboxes(ref.target_hitbox)
            hotkeys.force_baim = false
        end

        if not main_key then
            targeting = false
            returning = false
            should_return = false
            teleport = false
            disable_exploit = false
            visual.active = false
            return
        end

        ref.quickpeek:override(true)
        ref.quickpeek.hotkey:override({'Always on'})

        local move_mode = menu.antiaim.additions.automatic_peek.value

        local local_player = entity.get_local_player()
        local lp_velocity = antiaim.p_state.velocity
        local tickcount = globals.tickcount()

        local local_override = bit.band(entity.get_prop(local_player, 'm_fFlags'), 1) ~= 1
        or (cmd.in_forward == 1 or cmd.in_moveleft == 1 or cmd.in_moveright == 1 or cmd.in_back == 1 or cmd.in_jump == 1)

        local lp_origin = vector(entity.get_origin(local_player))
        local middle_pos = cache.middle_pos
        local dist_to_middle = middle_pos:dist2d(lp_origin)

        if (move_mode == 'Offensive' and not targeting and not returning)
        or (dist_to_middle > .15 and lp_velocity < 1.011 and lp_velocity ~= 0) then
            cache.middle_pos = lp_origin
        end

        local target = client.current_threat()
        cache.current_target = target

        local target_origin = target and vector(entity.get_origin(target)) or vector()
        local angle = target and vector(middle_pos:to(target_origin):angles()).y or vector(client.camera_angles()).y

        local positions = setup_points(local_player, middle_pos, angle, amount, step_distance)

        visual.active = true

        local active_point_pos, active_point_index = nil, 0

        if not local_override and not returning and can_target(local_player, target) then
            active_point_pos, active_point_index = trace_enemy(
                positions, local_player, target, active_hitboxes
            )
        end

        targeting = active_point_pos ~= nil
        cache.active_point_index = active_point_index

        if targeting then
            common.set_movement(cmd, active_point_pos, local_player)
            returning = false
            should_return = true
            teleport = false
            disable_exploit = false
        elseif local_override then
            returning = false
            should_return = false
            teleport = false
            disable_exploit = false
        elseif should_return or move_mode == 'Defensive' then
            returning = true
            should_return = false
            teleport = true
        end

        if not returning then
            cache.last_returning_time = tickcount
        end

        if returning then
            if dist_to_middle < .15 then
                returning = false
                teleport = false
                disable_exploit = false
            elseif teleport then
                if ref.doubletap:get_hotkey()
                and weapon_can_fire(local_player, entity.get_player_weapon(local_player)) then
                    if tickcount - cache.last_returning_time == 1 then
                        cmd.force_defensive = true
                    elseif tickcount - cache.last_returning_time >= 7 then
                        ref.doubletap:override(false)
                        ref.onshot_antiaim:override(false)
                        teleport = false
                        disable_exploit = true
                    end
                elseif not ref.doubletap:get_hotkey() and ref.onshot_antiaim:get_hotkey() then
                    if not exploit.defensive.active then
                        ref.onshot_antiaim:override(false)
                        teleport = false
                        disable_exploit = true
                    end
                end
            end
        end

        ref.quickpeek_mode:override(returning and {'Retreat on shot', 'Retreat on key release'} or nil)

        if disable_exploit then
            ref.doubletap:override(false)
            ref.onshot_antiaim:override(false)
        else
            ref.doubletap:override()
            ref.onshot_antiaim:override()
        end
    end

    local function render()
        local local_player = vars.local_player

        if not entity.is_alive(local_player) or not (ref.third_person_alive.value and ref.third_person_alive:get_hotkey()) then
            return
        end

        local data = cache.positions
        local color_ref = {255, 255, 255, 255}
        local active = visual.active and menu.visuals.visualize_automatic_peek.value
        local values = visual.values
        local active_point = cache.active_point_index

        local g_alpha = values.global_alpha(.045, active)

        if g_alpha <= 0 then
            return
        end

        for i = 0, #data do
            local pos = data[i]

            if pos == nil then
                goto continue
            end

            if not values.alpha[i] then
                values.alpha[i] = smoothy:new()
            end

            if not values.pos[i] then
                values.pos[i] = smoothy:new(vector())
            end

            local alpha = values.alpha[i](.045, pos and active)

            if alpha <= 0 then
                goto continue
            end

            if pos then
                values.pos[i](
                    alpha > .15 and .02 or 0,
                    vector(pos.x, pos.y, pos.z - 26 + 5 * alpha + (active_point == i and 2 or 0))
                )
            end

            local pos_screen = vector(renderer.world_to_screen(values.pos[i].value:unpack()))

            if pos_screen.x ~= 0 then
                local clr = active_point == i and color_ref or {255, 255, 255, 100}
                renderer.circle(pos_screen.x, pos_screen.y, clr[1], clr[2], clr[3], clr[4] * alpha, 3, 0, 1)
            end

            local prev_index = i <= 2 and 0 or i - 2
            local line_from = vector(renderer.world_to_screen(values.pos[prev_index].value:unpack()))
            local line_to = vector(renderer.world_to_screen(values.pos[i].value:unpack()))

            if line_from.x ~= 0 and line_to.x ~= 0 then
                renderer.line(line_from.x, line_from.y, line_to.x, line_to.y, 255, 255, 255, 100 * alpha)
            end

            ::continue::
        end
    end

    function automatic_peek:on_setup_command(cmd)
        handle(cmd)
    end

    function automatic_peek:on_paint()
        render()
    end
end

local dziki = {} do
    local positions = {}

    function dziki:picie(cmd)
        local lp_eyepos = vector(client.eye_position())
        local entities = entity.get_all('CPhysicsProp')

        positions = {}

        if entity.get_prop(vars.local_player, 'm_iHealth') > 100 then
            return
        end

        local can_shoot = false

        for i = 1, #entities do
            local ent = entities[i]

            if not ent then
                goto continue
            end

            local ent_origin = vector(entity.get_origin(ent))
            local dist_to_lp = lp_eyepos:dist(ent_origin)

            positions[i] = ent_origin

            if dist_to_lp > 90 then
                goto continue
            end

            local pitch, yaw = lp_eyepos:to(ent_origin):angles()

            if cmd.chokedcommands == 0 then
                can_shoot = true
            end

            if can_shoot then
                cmd.force_defensive = true
                cmd.pitch = pitch
                cmd.yaw = yaw
                cmd.in_use = 1
                can_shoot = false
            end

            ::continue::
        end
    end

    function dziki:esp()
        if not entity.is_alive(vars.local_player) then
            return
        end

        for i = 1, #positions do
            local pos = positions[i]

            if not pos then
                goto continue
            end

            local pos_screen = vector(renderer.world_to_screen(pos:unpack()))

            if pos_screen.x ~= 0 then
                renderer.circle(pos_screen.x, pos_screen.y, 255, 255, 255, 200, 3, 0, 1)
            end

            ::continue::
        end
    end

    function dziki:on_setup_command(cmd)
        self:picie(cmd)
    end

    function dziki:on_paint()
        self:esp()
    end
end

local indicators = {} do
    local fonts = {
        ['Small'] = '-',
        ['Normal'] = '',
        ['Bold'] = 'b'
    }

    local scope_value = 0

    local style1 = {} do
        local conditions = {
            ['stand'] = 'standing',
            ['move'] = 'moving',
            ['crouch'] = 'crouch',
            ['crouch move'] = 'crouch move',
            ['slowwalk'] = 'slowwalk',
            ['air crouch'] = 'air crouch',
            ['air'] = 'air',
            ['legit aa'] = 'legit',
            ['fakelag'] = 'fakelag'
        }

        local values = {
            state = smoothy:new(),
            dt = {
                fraction = 0,
                charge = 0,
                size = smoothy:new(),
                last_text = ''
            },
            hs = {
                fraction = 0,
                charge = 0,
                size = smoothy:new(),
                last_text = ''
            },
            other = {}
        }

        local other_items = {
            {
                text = 'FREESTAND',
                active = function()
                    return antiaim.freestand.hotkey
                end,
                color = {255, 255, 255, 255}
            },
            {
                text = 'SAFE',
                active = function()
                    return ref.force_safepoint:get()
                end,
                color = {255, 255, 255, 255}
            },
            {
                text = 'BAIM',
                active = function()
                    return ref.force_baim:get()
                end,
                color = {255, 255, 255, 255}
            },
            {
                text = 'DMG',
                active = function()
                    return ref.min_damage_override.value and ref.min_damage_override:get_hotkey()
                end,
                color = {255, 255, 255, 255}
            },
            {
                text = 'A-PEEK',
                active = function()
                    return menu.antiaim.additions.selector:get('Automatic peek') and menu.antiaim.additions.automatic_peek:get_hotkey()
                end,
                color = {255, 255, 255, 255}
            },
            {
                text = 'DORMANT',
                active = function()
                    return ref.dormant_aim and ref.dormant_aim:get() and ref.dormant_aim:get_hotkey()
                end,
                color = {200, 200, 200, 150}
            }
        }

        function style1:render()
            local local_player = vars.local_player
            local pos = vars.screen_size / 2
            pos.y = pos.y + menu.visuals.indicator_height.value
            local r, g, b, a = unpack(menu.accent_color.value)
            a = 255

            local font = fonts[menu.visuals.indicator_font.value]

            local string_func = font == '-' and string.upper or string.lower

            local frametime = globals.frametime()
            local offset = 0

            local adjust = (entity.get_prop(local_player, 'm_bIsScoped') == 1 and menu.visuals.indicator_adjustments:get('On scope'))
            or menu.visuals.indicator_adjustments:get('On nade')
            and string.find(entity.get_classname(entity.get_player_weapon(local_player)) or '', 'Grenade')

            scope_value = math.clamp(scope_value + (adjust and frametime * 6 or -frametime * 6), 0, 1)
            local scope_fr = easing.quad_in_out(scope_value, 0, 1, 1)

            local NextPrimaryAttack = entity.get_prop(entity.get_player_weapon(local_player), 'm_flNextPrimaryAttack') or 0
            local curtime = globals.curtime()
            local waiting_wpn = NextPrimaryAttack > curtime

            do
                local text = string_func(string.format(
                    '%s \a%s%s',
                    script_ctx.name, common.rgb_to_hex({r, g, b, math.abs(math.sin(curtime * 1.5)) * 255}), script_ctx.version
                ))
                local text_size = {renderer.measure_text(font, text)}
                local padding = math.floor(-text_size[1] / 2 * (1 - scope_fr) + 1 * scope_fr)

                renderer.text(pos.x + padding, pos.y, 255, 255, 255, 255, font, nil, text)

                offset = offset + text_size[2]
            end

            do
                local second_condition = antiaim.p_state.second_condition
                local text = string_func(second_condition == 'normal' and conditions[antiaim.p_state.condition] or second_condition)

                local text_size = {renderer.measure_text(font, text)}
                local adder = '-'
                local adder_size = renderer.measure_text(font, adder)
                local adder_offset = -1

                local size = math.clamp(values.state(.03, text_size[1] + 3), 0, text_size[1] + 3)
                local padding = math.floor(
                    -text_size[1] / 2 * (1 - scope_fr) * (size / (text_size[1] + 3)) + (adder_size + adder_offset + 2) * scope_fr + 1 * scope_fr
                )

                renderer.text(pos.x + padding, pos.y + offset, 255, 255, 255, 255, font, size, text)

                local padding_adder_left = math.floor((-size / 2 - adder_size - adder_offset - .5) * (1 - scope_fr) + 1 * scope_fr)
                local padding_adder_right = math.ceil((size / 2 + adder_offset) * (1 + scope_fr) + (adder_size + .5) * scope_fr + 1 * scope_fr)

                renderer.text(pos.x + padding_adder_left, pos.y + offset, 255, 255, 255, 255, font, nil, adder)
                renderer.text(pos.x + padding_adder_right, pos.y + offset, 255, 255, 255, 255, font, nil, adder)

                offset = offset + text_size[2] - 1
            end

            local doubletap_key = ref.doubletap.value and ref.doubletap:get_hotkey()

            do
                values.dt.fraction = math.clamp(values.dt.fraction + (doubletap_key and frametime * 2.5 or -frametime * 2.5), 0, 1)
                local fraction = easing.quart_in_out(values.dt.fraction, 0, 1, 1)

                values.dt.charge = math.clamp(
                    values.dt.charge + ((doubletap_key and fraction > .1) and frametime * 2.5 or -frametime * 6), 0, 1
                )
                local charge = values.dt.charge

                if not doubletap_key or waiting_wpn then
                    values.dt.charge = 0
                end

                if fraction > 0 then
                    local text = string_func(string.format(
                        '%s %s', ref.quickpeek.value and ref.quickpeek:get_hotkey() and 'IDEAL TICK' or 'DT',
                        waiting_wpn and not exploit.doubletap.charged and string.format('\a%s%s', common.rgb_to_hex({255, 0, 0, 120}), 'WAITING') or (
                            charge == 1 and (
                                exploit.defensive.active and string.format('\a%s%s', common.rgb_to_hex({127, 255, 255, 255}), 'ACTIVE')
                                or string.format('\a%s%s', common.rgb_to_hex({192, 255, 145, 255}), 'READY')
                            ) or common.gradient_text('CHARGING', {192, 255, 145, 255}, {255, 50, 50, 255}, charge, true)
                        )
                    ))

                    if doubletap_key then
                        values.dt.last_text = text
                    end

                    text = values.dt.last_text

                    local text_size = {renderer.measure_text(font, text)}
                    local size = math.clamp(values.dt.size(.05, text_size[1] + 2) * fraction, 1, text_size[1] + 2)
                    local padding = math.floor(-text_size[1] / 2 * (1 - scope_fr) * (size / (text_size[1] + 2)) + 1 * scope_fr)

                    renderer.text(pos.x + padding, pos.y + offset, 255, 255, 255, 255, font, size, text)

                    offset = offset + math.floor(.5 + (text_size[2] - 1) * fraction)
                end
            end

            do
                local hideshots_key = ref.onshot_antiaim.value and ref.onshot_antiaim:get_hotkey()

                values.hs.fraction = math.clamp(values.hs.fraction + (hideshots_key and frametime * 2.5 or -frametime * 2.5), 0, 1)
                local fraction = easing.quart_in_out(values.hs.fraction, 0, 1, 1)

                values.hs.charge = math.clamp(
                    values.hs.charge + ((hideshots_key and fraction > .1) and frametime * 3 or -frametime * 6), 0, 1
                )
                local charge = values.hs.charge

                if fraction > 0 then
                    local text = string_func(string.format(
                        '%s %s', 'HIDE',
                        charge == 1 and (
                            waiting_wpn and string.format('\a%s%s', common.rgb_to_hex({127, 255, 255, 255}), 'ACTIVE')
                            or string.format('\a%s%s', common.rgb_to_hex({192, 255, 145, 255}), 'READY')
                        ) or common.gradient_text('CHARGING', {192, 255, 145, 255}, {255, 50, 50, 255}, charge, true)
                    ))

                    if hideshots_key then
                        values.hs.last_text = text
                    end

                    text = values.hs.last_text

                    local text_size = {renderer.measure_text(font, text)}
                    local size = math.clamp(values.hs.size(.05, text_size[1] + 2) * fraction, 1, text_size[1] + 2)
                    local padding = math.floor(-text_size[1] / 2 * (1 - scope_fr) * (size / (text_size[1] + 2)) + 1 * scope_fr)

                    renderer.text(pos.x + padding, pos.y + offset, 255, 255, 255, 255, font, size, text)

                    offset = offset + math.floor(.5 + (text_size[2] - 1) * fraction)
                end
            end

            do
                local items = other_items
                local values = values.other

                for i = 1, #items do
                    local item = items[i]

                    if not values[i] then
                        values[i] = 0
                    end

                    values[i] = math.clamp(values[i] + (item.active() and frametime * 2.5 or -frametime * 2.5), 0, 1)
                    local fraction = easing.quart_in_out(values[i], 0, 1, 1)

                    if fraction <= 0 then
                        goto continue
                    end

                    local text = common.colored_text(string_func(item.text), item.color)
                    local text_size = {renderer.measure_text(font, text)}
                    local padding = math.floor(-(text_size[1] / 2) * (1 - scope_fr) * fraction + 1 * scope_fr)

                    renderer.text(pos.x + padding, pos.y + offset, 255, 255, 255, 255, font, (text_size[1] + 1) * fraction + 1, text)

                    offset = offset + math.floor(.5 + (text_size[2] - 1 + (i + 1 == #items and 1 or 0)) * fraction)

                    ::continue::
                end
            end
        end
    end

    local manual_arrows = {} do
        local fractions = {left = 0, right = 0, forward = 0}
        local scope_value = smoothy:new()
        local styles = {
            [1] = {
                left = renderer.load_svg(
                    '<svg width="124" height="149" viewBox="0 0 124 149" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M111.382 1.24609L3.79564 67.7161C-1.27136 70.8461 -1.26336 78.2164 3.80864 81.3362L111.351 147.479C118.454 151.848 126.666 143.794 122.436 136.607L88.2884 78.5858C86.8173 76.0863 86.8143 72.9864 88.2804 70.484L122.489 12.0961C126.705 4.90008 118.477 -3.13791 111.382 1.24609Z" fill="white"/></svg>',
                    12, 12
                ),
                right = renderer.load_svg(
                    '<svg width="124" height="150" viewBox="0 0 124 150" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12.3725 148.088L119.959 81.618C125.026 78.488 125.018 71.1177 119.946 67.9979L12.4039 1.8547C5.30078 -2.51406 -2.91145 5.53994 1.31827 12.7267L35.4662 70.7483C36.9373 73.2478 36.9403 76.3477 35.4742 78.8501L1.26514 137.238C-2.9505 144.434 5.27804 152.472 12.3725 148.088Z" fill="white"/></svg>',
                    12, 12
                ),
                forward = renderer.load_svg(
                    '<svg width="149" height="124" viewBox="0 0 149 124" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M147.471 111.382L81.0005 3.79564C77.8705 -1.27136 70.5002 -1.26336 67.3804 3.80864L1.23721 111.351C-3.13155 118.454 4.92245 126.666 12.1092 122.436L70.1308 88.2884C72.6303 86.8173 75.7302 86.8143 78.2326 88.2804L136.621 122.489C143.817 126.705 151.855 118.477 147.471 111.382Z" fill="white"/></svg>',
                    12, 12
                )
            }
        }

        function manual_arrows:render()
            local local_player = vars.local_player
            local pos = vars.screen_size / 2
            local r, g, b, a = unpack(menu.accent_color.value)
            a = 255

            local style = menu.visuals.manual_arrows.value
            local padding = menu.visuals.manual_arrows_padding.value

            local frametime = globals.frametime()

            local scope_enabled = entity.get_prop(local_player, 'm_bIsScoped') == 1 and menu.visuals.manual_arrows_adjust.value
            local scope_fr = scope_value(.05, scope_enabled)

            local condition = antiaim.p_state.second_condition
            fractions.left = math.clamp(fractions.left + (condition == 'manual left' and frametime * 7 or -frametime * 7), 0, 1)
            fractions.right = math.clamp(fractions.right + (condition == 'manual right' and frametime * 7 or -frametime * 7), 0, 1)
            fractions.forward = math.clamp(fractions.forward + (condition == 'manual forward' and frametime * 7 or -frametime * 7), 0, 1)

            local alpha_left = fractions.left
            local alpha_right = fractions.right
            local alpha_forward = fractions.forward

            if style == 'Modern' then
                if alpha_left > 0 then
                    renderer.texture(
                        styles[1].left,
                        pos.x - 35 - 12 + 1 - padding, pos.y - 6 - 15 * scope_fr,
                        12, 12, r, g, b, 255 * alpha_left, 'f'
                    )
                end
                if alpha_right > 0 then
                    renderer.texture(
                        styles[1].right,
                        pos.x + 35 + padding, pos.y - 6 - 15 * scope_fr,
                        12, 12, r, g, b, 255 * alpha_right, 'f'
                    )
                end
                if alpha_forward > 0 then
                    renderer.texture(
                        styles[1].forward,
                    pos.x - 6, pos.y - 35 - padding - 10 - 12 * scope_fr,
                    12, 12, r, g, b, 255 * alpha_forward, 'f'
                    )
                end
            elseif style == 'Default' then
                if alpha_left > 0 then
                    renderer.text(
                        pos.x - 35 - padding, pos.y - 2 - 15 * scope_fr,
                        r, g, b, 255 * alpha_left, 'c', nil, '❰'
                    )
                end
                if alpha_right > 0 then
                    renderer.text(
                        pos.x + 35 + padding, pos.y - 2 - 15 * scope_fr,
                        r, g, b, 255 * alpha_right, 'c', nil, '❱'
                    )
                end
                if alpha_forward > 0 then
                    renderer.text(
                        pos.x, pos.y - 30 - padding - 10 * scope_fr,
                        r, g, b, 255 * alpha_forward, 'cb', nil, '^'
                    )
                end
            end
        end
    end

    function indicators:on_paint()
        if not entity.is_alive(vars.local_player) then
            return
        end

        if menu.visuals.indicator.value == '1' then
            style1:render()
        end

        if menu.visuals.manual_arrows.value ~= '-' then
            manual_arrows:render()
        end
    end
end

local watermark = {} do
    local logo

    http.get('https://euphemia.fun/scriptleaks/other/tutajpowinnabycnazwaok/risen/risen_logo.png', function(s, r)
        if s and r.status == 200 then
            logo = l_images.load(r.body)
        end
    end)

    local wifi_icon

    http.get('https://euphemia.fun/scriptleaks/other/tutajpowinnabycnazwaok/risen/wifi_icon.png', function(s, r)
        if s and r.status == 200 then
            wifi_icon = l_images.load(r.body)
        end
    end)

    local clock_icon

    http.get('https://euphemia.fun/scriptleaks/other/tutajpowinnabycnazwaok/risen/clock_icon.png', function(s, r)
        if s and r.status == 200 then
            clock_icon = l_images.load(r.body)
        end
    end)

    local user = {
        alpha = smoothy:new(),
        width = smoothy:new()
    }

    local top_values = {}
    local top_items = {
        {
            icon = function()
                return wifi_icon
            end,
            active = function()
                return menu.visuals.watermark_additions:get('Ping') and client.latency() > 0
            end,
            text = function()
                return string.format('%d ms', client.latency() * 1000)
            end
        },
        {
            icon = function()
                return clock_icon
            end,
            active = function()
                return menu.visuals.watermark_additions:get('Clock')
            end,
            text = function()
                local sys_time = {client.system_time()}
                return string.format('%02d:%02d', sys_time[1], sys_time[2])
            end
        }
    }

    local bottom_values = {}
    local bottom_items = {
        {
            text = 'DT',
            active = function()
                return menu.visuals.watermark_additions:get('Doubletap') and exploit.doubletap.active
            end,
            vars = function()
                return exploit.doubletap.charged, exploit.defensive.active
            end
        },
        {
            text = 'HIDE',
            active = function()
                return menu.visuals.watermark_additions:get('Hideshots') and exploit.hideshots.active and not exploit.doubletap.active
            end,
            vars = function()
                return exploit.hideshots.charged, exploit.defensive.active
            end
        },
        {
            text = 'FL',
            active = function()
                return menu.visuals.watermark_additions:get('Fakelag') and not exploit.active
            end,
            vars = function()
                return globals.chokedcommands() / 15, false
            end
        }
    }

    local rounding = 5
    local item_offset = 5
    local text_offset = 6
    local padding = 5
    local bar_width = 30
    local bar_offset = 4
    local scale = .6

    function watermark:render()
        local pos = vector(vars.screen_size.x - 7, 7)
        local r, g, b, a = unpack(menu.accent_color.value)
        local b_clr = {r = 15, g = 15, b = 15, a = 140}
        local height = math.floor(45 * scale)
        local offset = vector()

        if logo ~= nil then
            local icon = logo
            local icon_size = vector(icon:measure()) * scale
            local size = vector(math.ceil(icon_size.x + padding * 2), height)

            offset.x = offset.x + size.x

            -- renderer.blur(pos.x - offset.x, pos.y - offset.y, size.x, size.y)

            Draw.rectangle(pos - offset, size, b_clr, rounding)

            icon:draw(
                pos.x - offset.x + padding, pos.y - offset.y + size.y / 2 - math.floor(icon_size.y / 2),
                icon_size.x, icon_size.y, r, g, b, 255
            )

            offset.x = offset.x + item_offset
        end

        for i = 1, #top_items do
            local this = top_items[i]

            if not top_values[i] then
                top_values[i] = {
                    alpha = smoothy:new(),
                    width = smoothy:new()
                }
            end

            local icon = this.icon()

            if not icon then
                goto continue
            end

            local values = top_values[i]

            local alpha = math.map(values.alpha(.05, this.active()), .25, 1, 0, 1, true)

            if alpha <= 0 then
                goto continue
            end

            local b_clr = {r = b_clr.r, g = b_clr.g, b = b_clr.b, a = b_clr.a * alpha}
            local icon_size = vector(icon:measure()) * scale
            local text = this.text()
            local text_size = vector(renderer.measure_text('b', text))
            local width = values.width(.1, math.max(icon_size.x + text_offset + text_size.x + 1 + padding * 2, icon_size.x + padding * 2)) * alpha
            local size = vector(math.ceil(width), height)

            offset.x = offset.x + size.x

            -- if alpha > .3 then
            --     renderer.blur(pos.x - offset.x, pos.y - offset.y, size.x, size.y)
            -- end

            Draw.rectangle(pos - offset, size, b_clr, rounding)

            icon:draw(
                pos.x - offset.x + padding, pos.y - offset.y + size.y / 2 - math.floor(icon_size.y / 2),
                icon_size.x, icon_size.y, r, g, b, 255 * alpha
            )

            renderer.text(
                pos.x - offset.x + icon_size.x + text_offset + padding, pos.y - offset.y + size.y / 2 - text_size.y / 2,
                255, 255, 255, 255 * alpha, 'b', math.max(size.x - icon_size.x - text_offset - padding * 2, 0) + 3, text
            )

            offset.x = offset.x + item_offset * alpha

            ::continue::
        end

        offset.x = 0
        offset.y = -height - item_offset
        height = math.floor(32 * scale)

        do
            local active = menu.visuals.watermark_additions:get('Username')
            local alpha = math.map(user.alpha(.05, active), .25, 1, 0, 1, true)

            if alpha > 0 then
                local build = menu.visuals.watermark_additions:get('Build')
                local b_clr = {r = b_clr.r, g = b_clr.g, b = b_clr.b, a = b_clr.a * alpha}
                local text = string.format('%s%s', script_ctx.username, build and ' ['.. script_ctx.version ..']' or '')
                local text_size = vector(renderer.measure_text('b', text))
                local width = user.width(.1, math.max(text_size.x + padding * 2, padding * 2)) * alpha
                local size = vector(math.ceil(width), height)

                offset.x = offset.x + size.x

                -- renderer.blur(pos.x - offset.x, pos.y - offset.y, size.x, size.y)

                Draw.rectangle(pos - offset, size, b_clr, rounding)

                renderer.text(
                    pos.x - offset.x + padding, pos.y - offset.y + size.y / 2 - text_size.y / 2,
                    255, 255, 255, 255 * alpha, 'b', math.max(size.x - padding * 2, 0) + 3, text
                )

                offset.x = offset.x + item_offset * alpha
            end
        end

        for i = 1, #bottom_items do
            local this = bottom_items[i]

            if not bottom_values[i] then
                bottom_values[i] = {
                    alpha = smoothy:new(),
                    fraction = smoothy:new(),
                    additional = smoothy:new()
                }
            end

            local values = bottom_values[i]

            local active = this.active()
            local alpha = math.map(values.alpha(.05, active), .25, 1, 0, 1, true)

            if alpha <= 0 then
                goto continue
            end

            local fraction, additional = this.vars()

            fraction = values.fraction(.03, fraction)

            local b_clr = {r = b_clr.r, g = b_clr.g, b = b_clr.b, a = b_clr.a * alpha}
            local text = this.text
            local text_size = vector(renderer.measure_text('b', text))
            local width = math.max(text_size.x + bar_offset + bar_width + padding * 2, rounding * 2) * alpha
            local size = vector(math.ceil(width), height)

            offset.x = offset.x + size.x

            -- if alpha > .3 then
            --     renderer.blur(pos.x - offset.x, pos.y - offset.y, size.x, size.y)
            -- end

            Draw.rectangle(pos - offset, size, b_clr, rounding)

            renderer.text(
                pos.x - offset.x + padding, pos.y - offset.y + size.y / 2 - text_size.y / 2,
                255, 255, 255, 255 * alpha, 'b', math.max(size.x - bar_offset - padding * 2, 0) + 3, text
            )

            local bar_size = vector(size.x - text_size.x - bar_offset - padding * 2, 5)
            local bar_pos = pos - offset + vector(text_size.x + bar_offset + padding, size.y / 2 - bar_size.y / 2)

            if bar_size.x > 4 then
                Draw.rectangle(bar_pos, bar_size, b_clr, 2)
            end

            if bar_size.x * fraction > 4 then
                local clr = common.color_swap({r, g, b, 255}, {255, 50, 50, 255}, values.additional(.04, additional))

                Draw.rectangle(
                    bar_pos, vector(bar_size.x * fraction, bar_size.y),
                    {r = clr[1], g = clr[2], b = clr[3], a = 255 * alpha}, 2
                )
            end

            offset.x = offset.x + item_offset * alpha

            ::continue::
        end
    end

    function watermark:on_paint()
        self:render()
    end
end

notifications = {} do
    notifications.data = {}

    local icons = {
        main = nil,
        miss = nil
    }

    http.get('https://euphemia.fun/scriptleaks/other/tutajpowinnabycnazwaok/risen/risen_logo.png', function(s, r)
        if s and r.status == 200 then
            icons.main = l_images.load(r.body)
        end
    end)

    http.get('hhttps://euphemia.fun/scriptleaks/other/tutajpowinnabycnazwaok/risen/cross-circle2.png', function(s, r)
        if s and r.status == 200 then
            icons.miss = l_images.load(r.body)
        end
    end)

    local max = 6
    local rounding = 5
    local item_offset = 5
    local padding = 4
    local scale = .55

    function notifications:render()
        local pos = vector(vars.screen_size.x / 2, vars.screen_size.y * .8)
        local height = math.floor(45 * scale)
        local h_offset = 0
        local realtime = globals.realtime()

        for i = #self.data, 1, -1 do
            local this = self.data[i]

            if not this then
                goto continue
            end

            local icon = icons[this.type]

            if not icon then
                goto continue
            end

            if realtime > this.time then
                this.hiding = true
            end

            if i > max then
                self.data[1].hiding = true
            end

            local fraction = this.fraction(.05, not this.hiding)

            if fraction <= 0 or (i == 1 and this.hiding and #self.data > max + 1) then
                table.remove(self.data, i)
                goto continue
            end

            local adder = this.adder(.05, false)

            local r, g, b, a = unpack(this.clr)
            local side_clr = {r = 15, g = 15, b = 15, a = 200 * fraction}
            local main_clr = {r = 15, g = 15, b = 15, a = 140 * fraction}

            local icon_size = vector(icon:measure()) * scale

            local text = this.text
            local ftext = {}

            for j = 1, #text do
                local phrase = text[j]

                if j % 2 == 0 then
                    phrase = common.colored_text(phrase, {r, g, b, 255 * fraction})
                end

                ftext[j] = common.colored_text(phrase, {255, 255, 255, 255 * fraction})
            end

            text = table.concat(ftext)
            local text_size = vector(renderer.measure_text('b', text))

            local side_size = math.floor(icon_size.x + padding * 2)
            local main_size = math.ceil(this.size(.05, not this.hiding and text_size.x + 1 + padding * 2 or 0))
            -- local main_size = math.ceil((text_size.x + 1 + padding * 2) * fraction)

            local size = vector(side_size + main_size, height)
            local pos = vector(math.floor(pos.x - size.x / 2), math.ceil(pos.y - h_offset - (size.y + item_offset) * adder))

            -- if fraction > .3 then
            --     renderer.blur(pos.x, pos.y, size.x, size.y)
            -- end

            Draw.rectangle(pos, vector(side_size, size.y), side_clr, {rounding, {true, false, false, true}})

            icon:draw(
                pos.x + padding, pos.y + size.y / 2 - icon_size.y / 2,
                icon_size.x, icon_size.y, r, g, b, 255 * fraction
            )

            Draw.rectangle(pos + vector(side_size), vector(main_size, size.y), main_clr, {rounding, {false, true, true, false}})

            renderer.text(
                pos.x + side_size + padding, pos.y + size.y / 2 - text_size.y / 2,
                255, 255, 255, 255 * fraction, 'b', math.max(main_size - padding * 2, 0) + 3, text
            )

            h_offset = h_offset - (size.y + item_offset) * fraction

            ::continue::
        end
    end

    function notifications:add(text, clr, time, type)
        table.insert(self.data, {
            text = text or {''},
            clr = clr or menu.accent_color.value,
            time = globals.realtime() + (time or 5),
            type = 'main',
            fraction = smoothy:new(),
            adder = smoothy:new(1),
            size = smoothy:new(),
            hiding = false
        })
    end
end

local aimbot_logs = {} do
    local hitgroups = {[0] = 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
    local shots = {}

    function aimbot_logs:on_aim_fire(data)
        data.shot = vector(data.x, data.y, data.z)

        shots[data.id] = data
    end

    function aimbot_logs:on_aim_hit(data)
        if not shots[data.id] then
            return
        end

        local target_name = string.sub(entity.get_player_name(data.target), 1, 15)

        notifications:add({
            'Hit ', target_name, '\'s ', hitgroups[data.hitgroup], ' for ', data.damage, ' damage',
        }, menu.misc.aimbot_logs_hit_clr.value, 5, 'hit')
    end

    function aimbot_logs:on_aim_miss(data)
        if not shots[data.id] then
            return
        end

        local on_fire_data = shots[data.id]

        local target_name = string.sub(entity.get_player_name(data.target), 1, 15)
        local reason = data.reason == '?' and 'correction' or data.reason

        notifications:add({
            'Missed ', target_name, '\'s ', hitgroups[on_fire_data.hitgroup] or '?', ' due to ', reason,
        }, menu.misc.aimbot_logs_miss_clr.value, 5, 'miss')
    end
end

local animations = {} do
    local ground_ticks = 1
    local end_time = 0

    function animations:handle()
        local local_player = vars.local_player

        if not entity.is_alive(local_player) then
            return
        end

        if menu.misc.animations:get('Legs on ground') then
            local leg_breaker = menu.misc.on_ground_animation_type.value

            if leg_breaker == 'Jitter' then
                entity.set_prop(local_player, 'm_flPoseParameter', 1, globals.tickcount() % 2)
                ref.leg_movement:set('Always slide')
            elseif leg_breaker == 'Moonwalk' then
                entity.set_prop(local_player, 'm_flPoseParameter', -1, 7)
                ref.leg_movement:set('Never slide')
            end
        end

        if menu.misc.animations:get('Pitch zero on land') then
            local on_ground = bit.band(entity.get_prop(local_player, 'm_fFlags'), 1)

            if on_ground == 1 then
                ground_ticks = ground_ticks + 1
            else
                ground_ticks = 0
                end_time = globals.curtime() + 1
            end

            if ground_ticks > ref.fakelag_limit.value + 1 and end_time > globals.curtime() then
                entity.set_prop(local_player, 'm_flPoseParameter', .5, 12)
            end
        end

        if menu.misc.animations:get('Walk in air') then
            local plocal_entity = entity_c.get_local_player()

            if plocal_entity then
                local m_fFlags = plocal_entity:get_prop('m_fFlags')
                local in_air = bit.band(m_fFlags, 1) == 0

                if in_air then
                    local anim_layer = plocal_entity:get_anim_overlay(6)

                    anim_layer.weight = 1
                end
            end
        elseif menu.misc.animations:get('Static legs in air') then
            entity.set_prop(local_player, 'm_flPoseParameter', 1, 6)
        end
    end

    function animations:on_pre_render()
        self:handle()
    end
end

local callbacks = {
    predict_command = function(cmd)
        -- print(1, ', ', cmd.command_number)
    end,
    setup_command = function(cmd)
        -- print(2, ', ', cmd.command_number)

        exploit:on_setup_command(cmd)

        if not (menu.other.disableaa and menu.other.disableaa.value) then
            antiaim:on_setup_command(cmd)
        end

        automatic_peek:on_setup_command(cmd)

        if menu.other.dziki and menu.other.dziki:get() then
            dziki:on_setup_command(cmd)
        end
    end,
    run_command = function(cmd)
        -- print(3, ', ', cmd.command_number)

        antiaim:on_run_command()
    end,
    net_update_start = function()
    end,
    net_update_end = function()
        vars:on_net_update_end()
    end,
    pre_render = function()
        animations:handle()
    end,
    paint_ui = function()
        notifications:render()

        if not ui.is_menu_open() then
            return
        end

        menu:handle_hidden()

        local hide = not menu.other.unhide_skeet_aa and true or not menu.other.unhide_skeet_aa.value

        menu:hide_original(hide)
    end,
    paint = function()
        indicators:on_paint()

        if menu.visuals.watermark.value then
            watermark:on_paint()
        else
            renderer.text(
                0, vars.screen_size.y - 13,
                255, 255, 255, 255, '', nil, string.format('%s - %s', script_ctx.name, script_ctx.version)
            )
        end

        automatic_peek:on_paint()

        if menu.other.dziki and menu.other.dziki:get() then
            dziki:on_paint()
        end

        if script_ctx.hidden_features then
            renderer.text(0, vars.screen_size.y - 50, 255, 255, 255, 255, '', nil, 'defensive: ', exploit.defensive.active)
            renderer.text(0, vars.screen_size.y - 60, 255, 255, 255, 255, '', nil, 'safe: ', antiaim.p_state.second_condition == 'safe head')
        end
    end,
    player_death = function(data)
        -- dead == local_player
        if client.userid_to_entindex(data.userid) == vars.local_player then
        end

        -- attacker == local_player
        if client.userid_to_entindex(data.attacker) == vars.local_player then
        end
    end,
    player_hurt = function(data)
        -- victim == local_player
        if client.userid_to_entindex(data.userid) == vars.local_player then
            if script_ctx.hidden_features
            and antiaim.p_state.second_condition == 'safe head' and data.hitgroup == 1 then
                print(
                    'Got headshoted on safe',
                    ', state: ', antiaim.p_state.raw_condition,
                    ', team: ', antiaim.p_state.team,
                    ', x: ', antiaim.p_state.pitch
                )
            end
        end

        -- attacker == local_player
        if client.userid_to_entindex(data.attacker) == vars.local_player then
        end
    end,
    aim_fire = function(data)
        if menu.misc.aimbot_logs:get('Notifications') then
            aimbot_logs:on_aim_fire(data)
        end
    end,
    aim_hit = function(data)
        if menu.misc.aimbot_logs:get('Notifications') then
            aimbot_logs:on_aim_hit(data)
        end
    end,
    aim_miss = function(data)
        if menu.misc.aimbot_logs:get('Notifications') then
            aimbot_logs:on_aim_miss(data)
        end
    end,
    shutdown = function()
        script_ctx.database.configs.list = config_system.list
        script_ctx.database.configs.hidden_config = config_system.hidden_config
        script_ctx.database.configs.autoload_config = config_system.autoload_item

        database.write(script_ctx.database_key, script_ctx.database)

        ref.quickpeek.hotkey:override()
        -- menu:hide_original(false)
    end
}

do
    if script_ctx.database.configs.hidden_config then
        config_system.hidden_config = script_ctx.database.configs.hidden_config
    end

    if script_ctx.database.configs.list then
        config_system.list = script_ctx.database.configs.list
        menu.configs.config_list:update(config_system.list)
    end

    if script_ctx.database.configs.autoload_config then
        config_system.autoload_item = script_ctx.database.configs.autoload_config
        config_system:load_config(config_system.autoload_item, true)
    end
end

for event, func in pairs(callbacks) do
    client.set_event_callback(event, func)
end