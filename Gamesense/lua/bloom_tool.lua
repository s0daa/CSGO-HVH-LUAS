--
-- Initalization
--
local user do
    user = {} do
        user.name = _USER_NAME or "admin"
        user.role = "insiders"
        user.last_update = "no_info"
        user.debug = false

        if not LPH_OBFUSCATED then
            LPH_ENCSTR = function (...) return ... end
            LPH_NO_VIRTUALIZE = function (...) return ... end
            LPH_CRASH = function (...) print('Triggered self-descruction and crash of VM') end
        end
    end
end

LPH_NO_VIRTUALIZE(function ()
    local ffi = require 'ffi';

    ---
    --- Dependencies manager
    ---
    do
        local dependencies = {
            ['csgo_weapons'] = {
                name = 'gamesense/csgo_weapons',
                type = 'workshop',
                link = 'https://gamesense.pub/forums/viewtopic.php?id=18807'
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
            ['surface'] = {
                name = 'gamesense/surface',
                type = 'workshop',
                link = 'https://gamesense.pub/forums/viewtopic.php?id=18793'
            }
            --['tweening'] = {
            --    name = 'gamesense/tweening',
            --    type = 'workshop',
            --    link = 'soon'
            --}
        }

        if user.debug then
            dependencies['inspect'] = {
                name = 'gamesense/inspect',
                type = 'workshop',
                link = ''
            }
        end

        local located = true

        for gname, method in pairs(dependencies) do
            local success = pcall(require, method.name)

            if not success then
                if method.type == 'workshop' then
                    client.error_log(string.format('[-] Unable to locate %s library. You need to subscribe to it here %s', gname, method.link))
                elseif method.type == 'local' then
                    client.error_log(string.format('[-] Unable to locate %s library. You need to download it and put in gamesense folder. Link is %s', gname, method.link))
                end

                located = false
            end
        end

        if not located then
            return error('[~] Script was unable to start. You can investigate error above.')
        end
    end

    ---
    --- Dependencies
    ---
    local vector = require 'vector'
    local csgo_weapons = require 'gamesense/csgo_weapons'
    local base64 = require 'gamesense/base64'
    local clipboard = require 'gamesense/clipboard'
    local surface = require 'gamesense/surface'
    --local tweening = require 'gamesense/tweening'
    local inspect do
        if user.debug then
            inspect = require 'gamesense/inspect'
        end
    end

    ---
    --- Internal modules
    ---
    local c_math, c_logger, c_table, c_string, c_animations, c_tweening, c_grams do
        c_math = {} do
            c_math.min = (function (a, b)
                return a > b and b or a
            end)

            c_math.max = (function (a, b)
                return a > b and a or b
            end)

            c_math.abs = (function (a)
                return a > 0 and a or -a
            end)

            c_math.round = (function (a)
                return math.floor(a+0.5)
            end)

            c_math.normalize_yaw = (function (a)
                while a > 180 do
                    a = a - 360
                end

                while a < -180 do
                    a = a + 360
                end

                return a
            end)

            c_math.clamp = (function (v, min, max)
                if v > max then
                    return max
                end

                if v < min then
                    return min
                end

                return v
            end)

            c_math.random = (function (min, max)
                return client.random_int(min, max)
            end)

            c_math.randomf = (function (min, max)
                return min + (max-min)*math.random()
            end)

            c_math.lerp = (function (a, b, v)
                local delta = (b - a)

                if c_math.abs(delta) <= 0.095 then
                    return b
                end

                return a + delta*v
            end)

            c_math.extrapolate = (function (ent, origin, ticks)
                local tickinterval = globals.tickinterval()

                local sv_gravity = cvar.sv_gravity:get_float() * tickinterval
                local sv_jump_impulse = cvar.sv_jump_impulse:get_float() * tickinterval

                local p_origin, prev_origin = origin, origin

                local velocity = vector(entity.get_prop(ent, 'm_vecVelocity'))
                local gravity = velocity.z > 0 and -sv_gravity or sv_jump_impulse

                for i=1, ticks do
                    prev_origin = p_origin
                    p_origin = vector(
                        p_origin.x + (velocity.x * tickinterval),
                        p_origin.y + (velocity.y * tickinterval),
                        p_origin.z + (velocity.z+gravity) * tickinterval
                    )

                    local fraction = client.trace_line(-1,
                        prev_origin.x, prev_origin.y, prev_origin.z,
                        p_origin.x, p_origin.y, p_origin.z
                    )

                    if fraction <= 0.99 then
                        return prev_origin
                    end
                end

                return p_origin
            end)
        end

        c_logger = {} do
            c_logger.log = (function (format, ...)
                client.color_log(108, 181, 119, '[bloom.tool] \1\0')
                client.color_log(61, 212, 197, ('[%02d:%02d:%02d] \1\0'):format(client.system_time()))
                client.color_log(255, 255, 255, format:format(...))
            end)

            c_logger.log_error = (function (format, ...)
                client.color_log(108, 181, 119, '[bloom.tool] \1\0')
                client.color_log(61, 212, 197, ('[%02d:%02d:%02d] \1\0'):format(client.system_time()))
                client.color_log(255, 0, 255, format:format(...))
            end)

            c_logger.log_error_fatal = (function (format, ...)
                client.color_log(108, 181, 119, '[bloom.tool] \1\0')
                client.color_log(61, 212, 197, ('[%02d:%02d:%02d] \1\0'):format(client.system_time()))
                client.color_log(255, 0, 50, format:format(...))

                return error('Execution aborted due to fatal exception!')
            end)
        end

        c_table = {} do
            c_table.unpack_keywise = (function (keys, ...)
                local new_table = {}

                for i=1, #keys do
                    new_table[keys[i]] = ({...})[i]
                end

                return new_table
            end)

            c_table.combine_arrays = (function (...)
                local new_table = {}

                local arrays = {...}
                local cnt = 1

                for i=1, #arrays do
                    for _, value in pairs(arrays[i]) do
                        new_table[cnt] = value
                        cnt = cnt + 1
                    end
                end

                return new_table
            end)

            c_table.is_hotkey_active = (function (element)
                return ui.get(element[1]) and ui.get(element[2])
            end)

            c_table.contains = (function (tbl, value)
                local tbl_len = #tbl

                for i=1, tbl_len do
                    if tbl[i] == value then
                        return true
                    end
                end

                return false
            end)

            c_table.object_contains = (function (tbl, value)
                for key, tvalue in pairs(tbl) do
                    if tvalue == value then
                        return true
                    end
                end

                return false
            end)

            c_table.closest = (function (v, targets)
                local best, diff = targets[1], math.huge

                for i=1, #targets do
                    local tbl_val = targets[i]
                    local cur_diff = c_math.abs(tbl_val-v)

                    if cur_diff < diff then
                        best = tbl_val
                        diff = cur_diff
                    end
                end

                return best
            end)

            c_table.keys = (function (table)
                local keys = {}

                for key in next, table, nil do
                    keys[#keys+1] = key
                end

                return keys
            end)

            c_table.equals = (function (tbl1, tbl2)
                for k, v in pairs(tbl1) do
                    if v ~= tbl2[k] then
                        return false
                    end
                end

                for k, v in pairs(tbl2) do
                    if v ~= tbl1[k] then
                        return false
                    end
                end

                return true
            end)
        end

        c_string = {} do
            c_string.trim = (function (str)
                while str:sub(1, 1) == ' ' do
                    str = str:sub(2)
                end

                while str:sub(#str, #str) == ' ' do
                    str = str:sub(1, #str-1)
                end

                if #str == 0 or str == '' then
                    str = 'Unnamed'
                end

                return str
            end)

            c_string.split = (function (str, sep)
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
            end)
        end

        c_animations = {} do
            c_animations.data = {}

            function c_animations:new(key, increasing, speed, modifier, initial_value)
                self.data[key] = self.data[key] or {
                    method = 'lerp',
                    increasing = increasing,
                    speed = speed or 4,
                    modifier = modifier or 0,
                    value = initial_value or 0
                }

                return self.data[key]
            end

            function c_animations:sway(key, from, to, speed, iterations, initial_value)
                self.data[key] = self.data[key] or {
                    active = 0,
                    method = 'sway',
                    increasing = false,
                    start = c_math.min(from, to),
                    target = c_math.max(from, to),
                    speed = speed or 4,
                    iterations = iterations or 1,
                    value = initial_value or from
                }

                local this = self.data[key]

                this.start, this.target = c_math.min(from, to), c_math.max(from, to)
                this.speed, this.iterations = speed, iterations

                return this
            end

            function c_animations:spin(key, from, to, speed, iterations, initial_value)
                self.data[key] = self.data[key] or {
                    active = 0,
                    method = 'spin',
                    start = c_math.min(from, to),
                    target = c_math.max(from, to),
                    speed = speed or 4,
                    iterations = iterations or 1,
                    value = initial_value or from
                }

                local this = self.data[key]

                this.start, this.target = c_math.min(from, to), c_math.max(from, to)
                this.speed, this.iterations = speed, iterations

                return this
            end

            function c_animations:flick(key, from, to, speed, initial_value)
                self.data[key] = self.data[key] or {
                    active = 0,
                    method = 'flick',
                    start = c_math.min(from, to),
                    target = c_math.max(from, to),
                    speed = speed or 4,
                    value = initial_value or from
                }

                local this = self.data[key]

                this.start, this.target = c_math.min(from, to), c_math.max(from, to)
                this.speed = speed

                return this
            end

            function c_animations:frame()
                local frametime = globals.frametime()

                for key, state in pairs(self.data) do
                    if state.method == 'lerp' then
                        state.value = c_math.clamp(state.value + (state.increasing and 1 or -1) * state.speed * frametime, 0, 1)
                    end
                end
            end

            function c_animations:tick(tick)
                for key, state in pairs(self.data) do
                    if state.method == 'sway' then
                        local difference = tick - state.active

                        if difference > state.speed or c_math.abs(difference) > 64 then
                            for i=1, state.iterations do
                                if state.increasing then
                                    if state.value < state.target then
                                        state.value = state.value + 1
                                    else
                                        state.increasing = false
                                    end
                                else
                                    if state.value > state.start then
                                        state.value = state.value - 1
                                    else
                                        state.increasing = true
                                    end
                                end
                            end

                            state.active = tick
                        end
                    end

                    if state.method == 'spin' then
                        local difference = tick - state.active

                        if difference > state.speed or c_math.abs(difference) > 64 then
                            for i=1, state.iterations do
                                if state.value < state.target then
                                    state.value = state.value + 1
                                else
                                    state.value = state.start
                                end
                            end

                            state.active = tick
                        end
                    end

                    if state.method == 'flick' then
                        local difference = tick - state.active

                        if difference > state.speed or c_math.abs(difference) > 64 then
                            state.increasing = not state.increasing
                            state.value = state.increasing and state.start or state.target
                            state.active = tick
                        end
                    end
                end
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

        c_grams = {} do
            c_grams.update_gram = (function (gram, v, maxlen)
                while #gram > maxlen-1 do
                    table.remove(gram, 1)
                end

                table.insert(gram, v)
            end)

            c_grams.average = (function (gram)
                local sum, cnt = 0, 0

                for i=1, #gram do
                    sum = sum + gram[i]
                    cnt = cnt + 1
                end

                if cnt == 0 then
                    return 0
                end

                return sum / cnt
            end)
        end
    end

    ---
    --- Constant section .data
    ---
    local c_constant do
        c_constant = {} do
            c_constant.STATE_LIST = { 'Standing', 'Slow-motion', 'Moving', 'Crouching', 'Crouch moving', 'Air', 'Air & Crouch' }
            c_constant.DEFENSIVE_STATES = { 'On peek', 'Legit AA', 'Edge direction', 'Safe head', 'Triggered' }
            --c_constant.

            c_constant.fonts = {} do
                c_constant.fonts.lucida = surface.create_font('Lucida Console', 10, 400, 128)
            end

            c_constant.antiaim_presets = {} do
                c_constant.antiaim_presets['Bloom'] = {
                    ['Legit AA'] = {
                        pitch = 'Off',
                        yaw_base = 'Local view',
                        yaw_type = 'Left & Right',
                        left_offset = 180,
                        right_offset = 180,
                        
                        body_yaw_type = 'Jitter',
                        body_yaw_value = -1
                    },
                    ['Fake lag'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -19,
                        right_offset = 42,
                        yaw_delay = 5,
                        yaw_delay_second = 5,

                        yaw_modifier = 'Off',
                        modifier_offset = 0
                    },
                    ['Standing'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -24,
                        right_offset = 41,
                        yaw_delay = 2,
                        yaw_delay_second = 10,

                        yaw_modifier = 'Random',
                        modifier_offset = 0,
                        modifier_randomize = 5
                    },
                    ['Slow-motion'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -22,
                        right_offset = 44,
                        yaw_delay = 3,
                        yaw_delay_second = 9,

                        yaw_modifier = 'Off',
                        modifier_offset = 0,
                        modifier_randomize = 5
                    },
                    ['Moving'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -24,
                        right_offset = 37,
                        yaw_delay = 3,
                        yaw_delay_second = 12
                    },
                    ['Crouching'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -32,
                        right_offset = 46,
                        body_yaw_type = 'Jitter',
                        body_yaw_value = -1
                    },
                    ['Crouch moving'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -22,
                        right_offset = 44,
                        yaw_delay = 2,
                        yaw_delay_second = 9
                    },
                    ['Air'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -29,
                        right_offset = 35,
                        yaw_delay = 5,
                        yaw_delay_second = 11
                    },
                    ['Air & Crouch'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -18,
                        right_offset = 44,
                        yaw_delay = 3,
                        yaw_delay_second = 9
                    }
                }

                c_constant.antiaim_presets['Blossom'] = {
                    ['Legit AA'] = {
                        pitch = 'Off',
                        yaw_base = 'Local view',
                        yaw_type = 'Left & Right',
                        left_offset = 180,
                        right_offset = 180,
                        
                        body_yaw_type = 'Jitter',
                        body_yaw_value = -1
                    },
                    ['Fake lag'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -28,
                        right_offset = 35,
                        yaw_delay = 1,
                        yaw_delay_second = 2,

                        yaw_modifier = 'Off',
                        modifier_offset = 0
                    },
                    ['Standing'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -33,
                        right_offset = 41,
                        yaw_delay = 2,
                        yaw_delay_second = 2,

                        yaw_modifier = 'Random',
                        modifier_offset = 0,
                        modifier_randomize = 5
                    },
                    ['Slow-motion'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -38,
                        right_offset = 45,
                        yaw_delay = 3,
                        yaw_delay_second = 3,

                        yaw_modifier = 'Off',
                        modifier_offset = 0,
                        modifier_randomize = 5
                    },
                    ['Moving'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -25,
                        right_offset = 42,
                        yaw_delay = 2,
                        yaw_delay_second = 2
                    },
                    ['Crouching'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -30,
                        right_offset = 45,
                        yaw_delay = 2,
                        yaw_delay_second = 2
                    },
                    ['Crouch moving'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -30,
                        right_offset = 33,
                        yaw_delay = 2,
                        yaw_delay_second = 2
                    },
                    ['Air'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -18,
                        right_offset = 27,
                        yaw_delay = 2,
                        yaw_delay_second = 2
                    },
                    ['Air & Crouch'] = {
                        pitch = 'Minimal',
                        yaw_base = 'At targets',
                        yaw_type = 'Left & Right',
                        left_offset = -19,
                        right_offset = 47,
                        yaw_delay = 2,
                        yaw_delay_second = 2
                    }
                }
            end

            c_constant.defensive_presets = {} do
                c_constant.defensive_presets["Auto"] = {
                    -- MANUAL
                    ["Safe head"] = {
                        ["pitch"] = "Custom",
                        ["pitch_custom"] = 10,
                        ["yaw"] = "Delayed",
                        ["yaw_left"] = -135,
                        ["yaw_right"] = 135,
                        ["yaw_delay"] = 20
                    },
                    ["Triggered"] = {
                        ["pitch"] = "Up Switch",
                        ["pitch_custom"] = 10,
                        ["yaw"] = "Spinbot",
                        ["yaw_from"] = -150,
                        ["yaw_to"] = 150,
                        ["yaw_speed"] = 20
                    },
                    ["Edge direction"] = {
                        ["enable_on"] = {"Freestanding", "Manual yaw"},
                        ["pitch"] = "Custom",
                        ["pitch_custom"] = 10,
                        ["yaw"] = "Spinbot",
                        ["yaw_left"] = 0,
                        ["yaw_right"] = 0,
                        ["yaw_delay"] = 1,
                        ["yaw_from"] = -180,
                        ["yaw_to"] = 180,
                        ["yaw_speed"] = 20
                    },
                    -- MANUAL

                    ["Standing"] = {
                        ["pitch"] = "Custom",
                        ["pitch_custom"] = -45,
                        ["yaw"] = "Spinbot",
                        -- Delayed
                        ["yaw_left"] = 0,
                        ["yaw_right"] = 0,
                        ["yaw_delay"] = 1,
                        -- Spinbot
                        ["yaw_from"] = -180,
                        ["yaw_to"] = 180,
                        ["yaw_speed"] = 29,
                        -- Scissors
                        ["yaw_left_start"] = 0,
                        ["yaw_left_target"] = 0,
                        ["yaw_right_start"] = 0,
                        ["yaw_right_target"] = 0,
                        -- Randomize
                        ["yaw_randomize"] = 0
                    },
                    ["Crouching"] = {
                        ["pitch"] = "Custom",
                        ["pitch_custom"] = -45,
                        ["yaw"] = "Default",
                        -- Delayed
                        ["yaw_left"] = 0,
                        ["yaw_right"] = 0,
                        ["yaw_delay"] = 1,
                        -- Spinbot
                        ["yaw_from"] = -180,
                        ["yaw_to"] = 180,
                        ["yaw_speed"] = 29,
                        -- Scissors
                        ["yaw_left_start"] = 0,
                        ["yaw_left_target"] = 0,
                        ["yaw_right_start"] = 0,
                        ["yaw_right_target"] = 0,
                        -- Randomize
                        ["yaw_randomize"] = 0
                    },
                    ["Crouch moving"] = {
                        ["pitch"] = "Custom",
                        ["pitch_custom"] = -45,
                        ["yaw"] = "Delayed",
                        -- Delayed
                        ["yaw_left"] = -90,
                        ["yaw_right"] = 90,
                        ["yaw_delay"] = 1,
                        -- Spinbot
                        ["yaw_from"] = -180,
                        ["yaw_to"] = 180,
                        ["yaw_speed"] = 29,
                        -- Scissors
                        ["yaw_left_start"] = 0,
                        ["yaw_left_target"] = 0,
                        ["yaw_right_start"] = 0,
                        ["yaw_right_target"] = 0,
                        -- Randomize
                        ["yaw_randomize"] = 27
                    },
                    ["Air"] = {
                        ["pitch"] = "Custom",
                        ["pitch_custom"] = -45,
                        ["yaw"] = "Spinbot",
                        -- Delayed
                        ["yaw_left"] = 0,
                        ["yaw_right"] = 0,
                        ["yaw_delay"] = 1,
                        -- Spinbot
                        ["yaw_from"] = -180,
                        ["yaw_to"] = 180,
                        ["yaw_speed"] = 49,
                        -- Scissors
                        ["yaw_left_start"] = 0,
                        ["yaw_left_target"] = 0,
                        ["yaw_right_start"] = 0,
                        ["yaw_right_target"] = 0,
                        -- Randomize
                        ["yaw_randomize"] = 0
                    },
                    ["Air & Crouch"] = {
                        ["pitch"] = "Up",
                        ["pitch_custom"] = -45,
                        ["yaw"] = "Default",
                        -- Delayed
                        ["yaw_left"] = 0,
                        ["yaw_right"] = 0,
                        ["yaw_delay"] = 1,
                        -- Spinbot
                        ["yaw_from"] = -180,
                        ["yaw_to"] = 180,
                        ["yaw_speed"] = 29,
                        -- Scissors
                        ["yaw_left_start"] = 0,
                        ["yaw_left_target"] = 0,
                        ["yaw_right_start"] = 0,
                        ["yaw_right_target"] = 0,
                        -- Randomize
                        ["yaw_randomize"] = 0
                    },
                    ["On peek"] = {
                        ["pitch"] = "Up Switch",
                        ["pitch_custom"] = 10,
                        ["yaw"] = "Random",
                        ["yaw_left"] = 0,
                        ["yaw_right"] = -3,
                        ["yaw_delay"] = 1,
                        ["yaw_from"] = -150,
                        ["yaw_to"] = 150,
                        ["yaw_speed"] = 20,
                        ["yaw_randomize"] = 20
                    }
                }
            end
        end
    end

    ---
    --- Color
    ---
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

    ---
    --- UI library
    --- 
    local override = {} do
        local e_hotkey_mode = {
            [0] = "Always on",
            [1] = "On hotkey",
            [2] = "Toggle",
            [3] = "Off hotkey"
        }

        local data = { }

        local function get_value(ref)
            local value = { ui.get(ref) }
            local typeof = ui.type(ref)

            if typeof == "hotkey" then
                return { e_hotkey_mode[value[2]], value[3] }
            end

            return value
        end

        function override.get(ref, ...)
            local value = data[ref]

            if value == nil then
                return
            end

            return unpack(value)
        end

        function override.set(ref, ...)
            if data[ref] == nil then
                data[ref] = get_value(ref)
            end

            ui.set(ref, ...)
        end

        function override.unset(ref)
            if data[ref] == nil then
                return
            end

            ui.set(ref, unpack(data[ref]))
            data[ref] = nil
        end
    end

    local menu = {} do
        local items = { }
        local records = { }

        local callbacks = { }

        local function get_value(ref)
            local value = { pcall(ui.get, ref) }
            if not value[1] then return end

            return unpack(value, 2)
        end

        local function get_keys(value)
            if type(value[1]) == "table" then
                return c_table.keys(value[1])
            end

            return { }
        end

        local function update_items()
            for i = 1, #callbacks do
                callbacks[i]()
            end

            for i = 1, #items do
                local item = items[i]

                ui.set_visible(item.ref, item.is_visible)
                item.is_visible = false
            end
        end

        local c_item = { } do
            function c_item:new()
                return setmetatable({ }, self)
            end

            function c_item:init()
                local function callback(ref)
                    self:update_value(ref)
                    self:invoke_callback(ref)

                    update_items()
                end

                ui.set_callback(self.ref, callback)
            end

            function c_item:get()
                return unpack(self.value)
            end

            function c_item:set(...)
                local ref = self.ref

                ui.set(ref, ...)
                self:update_value(ref)
            end

            function c_item:have_key(key)
                return self.keys[key] ~= nil
            end

            function c_item:rawget()
                return ui.get(self.ref)
            end

            function c_item:reset()
                pcall(ui.set, self.ref, unpack(self.default))
            end

            function c_item:record(tab, name)
                if records[tab] == nil then
                    records[tab] = { }
                end

                self.is_recorded = true
                records[tab][name] = self

                return self
            end

            function c_item:save()
                if not self.is_recorded then
                    error("unable to save unrecorded item")
                    return
                end

                self.is_saved = true
                return self
            end

            function c_item:display()
                self.is_visible = true
            end

            function c_item:config_ignore()
                self.saveable = false
                return self
            end

            function c_item:set_callback(callback, run)
                if run then
                    callback(self.ref)
                end

                self.callbacks[#self.callbacks + 1] = callback
            end

            function c_item:update_value(ref)
                local value = { get_value(ref) }
                self.keys = get_keys(value)

                self.value = value
            end

            function c_item:invoke_callback(...)
                for i = 1, #self.callbacks do
                    self.callbacks[i](...)
                end
            end

            function c_item:get_ref()
                return self.ref
            end

            c_item.__index = c_item
        end

        function menu.new_item(fn, ...)
            local ref = fn(...)

            local value = { get_value(ref) }
            local typeof = ui.type(ref)

            local item = c_item:new()

            item.ref = ref
            item.name = select(3, ...)

            item.value = value
            item.default = value

            item.keys = get_keys(value)
            item.callbacks = { }

            item.is_saved = false
            item.is_visible = false
            item.is_recorded = false

            item.saveable = true

            if typeof == "button" then
                item.callbacks[#item.callbacks + 1] = select(4, ...)
            end

            item:init()
            items[#items + 1] = item

            return item
        end

        function menu.get_items()
            return items
        end

        function menu.get_records()
            return records
        end

        function menu.set_callback(callback)
            callbacks[#callbacks + 1] = callback
        end

        function menu.update()
            update_items()
        end
    end

    local config_system do
        config_system = { }

        local e_hotkey_mode = {
            [0] = "Always on",
            [1] = "On hotkey",
            [2] = "Toggle",
            [3] = "Off hotkey"
        }

        local function resolve_item_export(item)
            if not item.saveable then
                return
            end

            if ui.type(item.ref) == "label" then
                return
            end

            if ui.type(item.ref) == "hotkey" then
                local active, mode, key = item:rawget()

                return {e_hotkey_mode[mode], key}
            end

            return item.value
        end

        local function resolve_item_import(item, data)
            if ui.type(item.ref) == "label" then
                return true
            end

            if not item.saveable then
                return true
            end

            if data == nil then
                return false
            end

            item:set(unpack(data))

            return true
        end

        function config_system.export_to_str(...)
            local tabs = {...}
            local config_result = {}

            local records = menu:get_records()

            if #tabs ~= 0 then
                records = {}

                for i=1, #tabs do
                    records[tabs[i]] = menu:get_records()[tabs[i]]
                end
            end

            for tab, list in pairs(records) do
                config_result[tab] = {}

                for item_id, element in pairs(list) do
                    config_result[tab][item_id] = resolve_item_export(element)
                end
            end

            return base64.encode(json.stringify(config_result)) .. '_bloomtool'
        end

        function config_system.import_from_str(str, ...)
            local tabs = {...}
            local bloom_str = str:find("_bloomtool")

            if bloom_str then
                str = str:sub(1, bloom_str-1)
            end

            local status, config = pcall(base64.decode, str)

            if not status then
                return false, "Failed to decode config"
            end

            status, config = pcall(json.parse, config)

            if not status then
                return false, "Failed to parse config"
            end

            local records = menu:get_records()

            if #tabs ~= 0 then
                records = {}

                for i=1, #tabs do
                    records[tabs[i]] = menu:get_records()[tabs[i]]
                end
            end

            for tab, list in pairs(records) do
                if config[tab] then
                    for item_id, element in pairs(list) do
                        if config[tab][item_id] then
                            resolve_item_import(element, config[tab][item_id])
                        end
                    end
                end
            end

            return true
        end

        function config_system:retrieve_local()
            local db_data = database.read('btool_config')
        
            if db_data ~= nil and db_data[1] ~= nil then
                self.import_from_str(db_data[1])
            end
        end

        function config_system:save_local()
            local config_output = self.export_to_str()

            database.write('btool_config', {
                config_output
            })

            c_logger.log('Local config saved.')
        end
    end

    ---
    --- Reference
    ---
    local reference do
        reference = {} do
            reference.ragebot = {} do
                reference.ragebot.enabled = {ui.reference('RAGE', 'Aimbot', 'Enabled')}

                reference.ragebot.doubletap = {} do
                    reference.ragebot.doubletap.enable = {ui.reference('RAGE', 'Aimbot', 'Double tap')}
                    reference.ragebot.doubletap.fakelag = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
                end

                reference.ragebot.force_bodyaim = ui.reference('RAGE', 'Aimbot', 'Force body aim')
                reference.ragebot.force_safepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point')

                reference.ragebot.minimum_damage = ui.reference('RAGE', 'Aimbot', 'Minimum damage')
                reference.ragebot.minimum_damage_override = {ui.reference('RAGE', 'Aimbot', 'Minimum damage override')}

                reference.ragebot.quick_peek_assist = {ui.reference('RAGE', 'Other', 'Quick peek assist')}
                reference.ragebot.fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist')
            end

            reference.antiaim = {} do
                reference.antiaim.master = ui.reference('AA', 'Anti-aimbot angles', 'Enabled')

                reference.antiaim.roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll')
                reference.antiaim.freestanding = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')}

                reference.antiaim.pitch = c_table.unpack_keywise({'type', 'value'}, ui.reference('AA', 'Anti-aimbot angles', 'Pitch'))

                reference.antiaim.yaw = {} do
                    reference.antiaim.yaw.base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base')
                    reference.antiaim.yaw.yaw = c_table.unpack_keywise({'type', 'value'}, ui.reference('AA', 'Anti-aimbot angles', 'Yaw'))
                    reference.antiaim.yaw.jitter = c_table.unpack_keywise({'type', 'value'}, ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter'))
                    reference.antiaim.yaw.edge = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw')
                end

                reference.antiaim.body = {} do
                    reference.antiaim.body.yaw = c_table.unpack_keywise({'type', 'value'}, ui.reference('AA', 'Anti-aimbot angles', 'Body yaw'))
                    reference.antiaim.body.freestanding = ui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw')
                end
            end

            reference.fakelag = {} do
                reference.fakelag.enable = {ui.reference('AA', 'Fake lag', 'Enabled')}
                reference.fakelag.amount = ui.reference('AA', 'Fake lag', 'Amount')
                reference.fakelag.variance = ui.reference('AA', 'Fake lag', 'Variance')
                reference.fakelag.limit = ui.reference('AA', 'Fake lag', 'Limit')
            end

            reference.misc = {} do
                reference.misc.draw_output = ui.reference('MISC', 'Miscellaneous', 'Draw console output')
                reference.misc.freestanding = ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')

                reference.misc.pingspike = c_table.unpack_keywise({'bind', 'value'}, ui.reference('MISC', 'Miscellaneous', 'Ping spike'))
                reference.misc.slowmotion = {ui.reference('AA', 'Other', 'Slow motion')}
                reference.misc.onshot_antiaim = {ui.reference('AA', 'Other', 'On shot anti-aim')}
                reference.misc.leg_movement = ui.reference('AA', 'Other', 'Leg movement')
                reference.misc.fake_peek = {ui.reference('AA', 'Other', 'Fake peek')}

                reference.misc.grenade_toss = ui.reference('Misc', 'Miscellaneous', 'Super toss')
                reference.misc.grenade_release = {ui.reference('Misc', 'Miscellaneous', 'Automatic grenade release')}

                reference.misc.air_strafe = ui.reference('MISC', 'Movement', 'Air strafe')
            end
        end
    end

    ---
    --- Menu
    --- 
    local config = {} 

    config.navigation = {} do
        config.navigation.label = menu.new_item(ui.new_label, "AA", "Anti-aimbot angles", string.format('\v•  \rbloom.tool · %s · %s', user.name, user.role))

        config.navigation.tab = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", "Navigation: Tab", {
            "Anti-aimbot",
            "Defensive",
            "Visuals",
            "Miscellaneous",
            "Presets",
            "Configuration"
        }):config_ignore()
    end

    ---
    --- FFI
    ---
    local ffi_helpers do
        ffi_helpers = {} do
            ffi_helpers.get_client_entity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void***, int)')

            ffi_helpers.animstate = {} do
                if not pcall(ffi.typeof, 'bt_animstate_t') then
                    ffi.cdef[[
                        typedef struct {
                            char __0x108[0x108];
                            bool on_ground;
                            bool hit_in_ground_animation;
                        } bt_animstate_t, *pbt_animstate_t
                    ]]
                end

                ffi_helpers.animstate.offset = 0x9960

                ffi_helpers.animstate.get = function (self, ent)
                    local client_entity = ffi_helpers.get_client_entity(ent)

                    if not client_entity then
                        return
                    end

                    return ffi.cast('pbt_animstate_t*', ffi.cast('uintptr_t', client_entity) + self.offset)[0]
                end
            end

            ffi_helpers.animlayers = {} do
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

                ffi_helpers.animlayers.offset = ffi.cast('int*', ffi.cast('uintptr_t', client.find_signature('client.dll', '\x8B\x89\xCC\xCC\xCC\xCC\x8D\x0C\xD1')) + 2)[0]

                ffi_helpers.animlayers.get = function (self, ent)
                    local client_entity = ffi_helpers.get_client_entity(ent)

                    if not client_entity then
                        return
                    end

                    return ffi.cast('pbt_animlayer_t*', ffi.cast('uintptr_t', client_entity) + self.offset)[0]
                end
            end

            ffi_helpers.activity = {} do
                if not pcall(ffi.typeof, 'bt_get_sequence') then
                    ffi.cdef[[
                        typedef int(__fastcall* bt_get_sequence)(void* entity, void* studio_hdr, int sequence);
                    ]]
                end

                ffi_helpers.activity.offset = 0x2950 --- @offset https://github.com/frk1/hazedumper/blob/master/csgo.json#L55
                ffi_helpers.activity.location = ffi.cast('bt_get_sequence', client.find_signature('client.dll', '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83'))

                ffi_helpers.activity.get = function (self, sequence, ent)
                    local client_entity = ffi_helpers.get_client_entity(ent)

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

            ffi_helpers.user_input = {} do
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

                ffi_helpers.user_input.vtbl = ffi.cast('void***', ffi.cast('void**', ffi.cast('uintptr_t', client.find_signature('client.dll', '\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85') or error('fipp')) + 1)[0])
                ffi_helpers.user_input.location = ffi.cast('bt_get_usercmd', ffi_helpers.user_input.vtbl[0][8])

                ffi_helpers.user_input.get_command = function (self, command_number)
                    return self.location(self.vtbl, 0, command_number)
                end
            end
        end
    end

    ---
    --- Player class
    ---
    local player do
        local create_player, BaseLocal do
            BaseLocal = {} do
                --- Reset player
                ---@param full? boolean Reset valid, entindex and alive states 
                function BaseLocal:reset(full)
                    if full then
                        self.entindex = -1
                        self.alive = false
                    end

                    self.onground = true
                    self.velocity = vector()
                    self.speed = 0.0
                    self.duckamount = 0.0
                    self.stamina = 80.0
                    self.velocity_modifier = 1.0
                    self.fakeyaw = 0.0
                    self.server_fakeyaw = 0.0
                    self.smooth_fakeamount = 0.0
                    self.fakeamount_gram = {}
                    self.state = 'Standing'
                    self.defensive_active = false
                    self.defensive_predict = false
                    self.use_needed = false
                    self.landing = false
                    self.peeking = false
                    self.freestanding_side = 'none'
                    self._shifting_enough = false
                end

                function BaseLocal:is_onground()
                    local animstate = ffi_helpers.animstate:get(self.entindex)

                    if not animstate then
                        return true
                    end

                    local ptr_addr = ffi.cast('uintptr_t', ffi.cast('void*', animstate))
                    local landed_on_ground_this_frame = ffi.cast('bool*', ptr_addr + 0x120)[0] --- @offset

                    return animstate.on_ground and not landed_on_ground_this_frame
                end

                function BaseLocal:get_velocity_modifier()
                    local velocity_modifier = entity.get_prop(self.entindex, 'm_flVelocityModifier')

                    if self.stamina > 0.01 and self.onground then
                        local flSpeedScale = c_math.clamp(1.0 - self.stamina * 0.01, 0.0, 1.0)

                        flSpeedScale = flSpeedScale * flSpeedScale

                        velocity_modifier = velocity_modifier * flSpeedScale
                    end

                    return velocity_modifier
                end

                --- Get player state
                ---@return string
                function BaseLocal:get_state()
                    if not self.onground then
                        if self.duckamount > 0.5 then
                            return 'Air & Crouch'
                        else
                            return 'Air'
                        end
                    end

                    if self.duckamount > 0.5 or ui.get(reference.ragebot.fakeduck) then
                        if self.speed > 4 then
                            return 'Crouch moving'
                        else
                            return 'Crouching'
                        end
                    end

                    local slowmotion_state = c_table.is_hotkey_active(reference.misc.slowmotion)

                    if slowmotion_state then
                        return 'Slow-motion'
                    end

                    if self.speed > 4 then
                        return 'Moving'
                    end

                    return 'Standing'
                end

                local tickbase_max = 0

                function BaseLocal:get_defensive()
                    local tickbase = entity.get_prop(self.entindex, 'm_nTickBase')

                    if c_math.abs(tickbase - tickbase_max) > 64 then
                        tickbase_max = 0
                    end

                    local defensive_ticks_left = 0;

                    if tickbase > tickbase_max then
                        tickbase_max = tickbase
                    elseif tickbase_max > tickbase then
                        defensive_ticks_left = c_math.min(14, c_math.max(0, tickbase_max-tickbase-1))
                    end

                    return defensive_ticks_left > 2
                end

                ---@param wpn number
                BaseLocal.is_use_needed = (function (self, wpn)
                    if wpn then
                        local wpn_classname = entity.get_classname(wpn)

                        if wpn_classname == 'CC4' then
                            return true
                        end
                    end

                    local my_origin = vector(entity.get_origin(self.entindex))
                    local team_num = entity.get_prop(self.entindex, 'm_iTeamNum')
                    local planted_ents = entity.get_all('CPlantedC4')

                    for i=1, #planted_ents do
                        local c4 = planted_ents[i]
                        local m_hDefuser = entity.get_prop(c4, 'm_hDefuser')
                        local c4_origin = vector(entity.get_origin(c4))

                        if m_hDefuser == self.entindex or team_num == 3 and c4_origin:dist(my_origin) < 87.5 then
                            return true
                        end
                    end

                    local hostage_ents = entity.get_all('CHostage')

                    for i=1, #hostage_ents do
                        local hostage = hostage_ents[i]
                        local hostage_origin = vector(entity.get_origin(hostage))

                        if hostage_origin:dist(my_origin) < 50 and team_num == 3 then
                            return true
                        end
                    end

                    local head_origin = vector(client.eye_position())
                    local angles = vector():init_from_angles(client.camera_angles())
                    local end_point = head_origin + angles * 128

                    ---@type number, number
                    local fraction, ent = client.trace_line(self.entindex, head_origin.x, head_origin.y, head_origin.z, end_point.x, end_point.y, end_point.z)

                    if ent ~= -1 and fraction ~= 1.0 then
                        local cname = entity.get_classname(ent)

                        if cname ~= nil and cname ~= 'CWorld' and cname ~= 'CCSPlayer' and cname ~= 'CFuncBrush' then
                            return true
                        end
                    end

                    return false
                end)

                function BaseLocal:threat_yaw()
                    local aa_threat = client.current_threat()

                    if not aa_threat then
                        return
                    end

                    local my_origin = vector(entity.get_origin(self.entindex))
                    local _, threat_yaw = my_origin:to(vector(entity.get_origin(aa_threat))):angles()

                    return threat_yaw
                end

                ---@param target number Target for yaw calculation
                ---@return string
                BaseLocal.get_side = (function (self, target)
                    local local_pos, enemy_pos = vector(entity.hitbox_position(self.entindex, 0)), vector(entity.hitbox_position(target, 0))

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
                end)

                function BaseLocal:get_weapon_type(wpn)
                    if not wpn then
                        return false
                    end

                    local wpn_info = csgo_weapons(wpn)

                    if not wpn_info then
                        return false
                    end

                    return wpn_info.type
                end

                do
                    local defensive_tick = 0
                    local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')

                    function BaseLocal:handle_defensive()
                        local lp = entity.get_local_player()
            
                        if lp and entity.is_alive(lp) then
                            local Entity = native_GetClientEntity(lp)
                            local m_flOldSimulationTime = ffi.cast("float*", ffi.cast("uintptr_t", Entity) + 0x26C)[0]
                            local m_flSimulationTime = entity.get_prop(lp, "m_flSimulationTime")
                
                            local delta = m_flOldSimulationTime - m_flSimulationTime
                
                            if delta > 0 then
                                defensive_tick = globals.tickcount() + toticks(delta - client.real_latency())
                            end
                        end

                        return globals.tickcount() <= defensive_tick - 2
                    end
                end
                    

                BaseLocal.set_peeking_state = (function (self, me)
                    local target, cross_target, last_dmg, best_yaw = nil, nil, 0, 362
                    local is_peeking = false

                    local enemy_list = entity.get_players(true)
                    local camera_angles = vector(client.camera_angles())
                    local stomach_origin = vector(entity.hitbox_position(me, 2))
                    local stomach_future = c_math.extrapolate(me, stomach_origin, 16)

                    for idx=1, #enemy_list do
                        local ent = enemy_list[idx]
                        local ent_wpn = entity.get_player_weapon(ent)

                        if ent_wpn then
                            local enemy_head = vector(entity.hitbox_position(ent, 2))
                            local entindex, damage = client.trace_bullet(ent, enemy_head.x, enemy_head.y, enemy_head.z, stomach_future.x, stomach_future.y, stomach_future.z)

                            if -1 == entindex then
                                damage = 0
                            end

                            if damage > 0 then
                                is_peeking = true
                            end

                            if damage > last_dmg then
                                target = ent
                                last_dmg = damage
                            end

                            local _, yaw = (stomach_origin-enemy_head):angles()
                            local base_diff = c_math.abs(camera_angles.y-yaw)

                            if base_diff < best_yaw then
                                cross_target = ent
                                best_yaw = base_diff
                            end
                        end
                    end

                    if not target then
                        target = cross_target
                    end

                    self.peeking = is_peeking
                    self.fs_side = target and self:get_side(target) or 'none'
                end)

                local get_curtime = function (n_offset)
                    return globals.curtime() - (n_offset * globals.tickinterval())
                end

                local weapon_ready = function (ent, weapon)
                    if not ent or not weapon then
                        return false
                    end

                    if get_curtime(16) < entity.get_prop(ent, 'm_flNextAttack') then
                        return false
                    end

                    if get_curtime(0) < entity.get_prop(weapon, 'm_flNextPrimaryAttack') then
                        return false
                    end

                    return true
                end

                function BaseLocal:get_double_tap()
                    return self._shifting_enough
                end

                function BaseLocal:run_command(cmd)
                    local me = entity.get_local_player()

                    if me then
                        local m_nTickBase = entity.get_prop(me, 'm_nTickBase')
                        local client_latency = client.latency()
                        local shift = math.floor(m_nTickBase - globals.tickcount() - 3 - toticks(client_latency) * .5 + .5 * (client_latency * 10))

                        local wanted = -14 + (ui.get(reference.ragebot.doubletap.fakelag) - 1) + 3 --error margin

                        self._shifting_enough = shift <= wanted
                    end
                end

                function BaseLocal:predict_command(cmd, me, wpn)
                    if not self.valid then
                        return self:reset(true)
                    end

                    self.entindex = me
                    self.alive = entity.is_alive(self.entindex)

                    if self.alive then
                        local animstate = ffi_helpers.animstate:get(me) or {}

                        self.onground = self:is_onground()
                        self.defensive_predict = self:handle_defensive()
                        self.velocity = vector(entity.get_prop(me, 'm_vecVelocity'))
                        self.speed = self.velocity:length()
                        self.duckamount = entity.get_prop(me, 'm_flDuckAmount')
                        self.stamina = entity.get_prop(me, 'm_flStamina')
                        self.velocity_modifier = self:get_velocity_modifier()
                        self.state = self:get_state()
                        self.landing = animstate.hit_in_ground_animation
                        self:set_peeking_state(me)
                    else
                        self:reset()
                    end
                end

                function BaseLocal:setup_command(cmd, me, wpn)
                    if not self.valid then
                        return self:reset(true)
                    end

                    self.entindex = me
                    self.alive = entity.is_alive(self.entindex)

                    if cmd.chokedcommands == 0 then
                        self.packets = self.packets + 1

                        c_grams.update_gram(self.fakeamount_gram, c_math.abs(self.fakeyaw), 8)

                        self.smooth_fakeamount = c_grams.average(self.fakeamount_gram)
                        self.server_fakeyaw = entity.get_prop(me, 'm_flPoseParameter', 11) * 120 - 60
                        self.weapon_type = self:get_weapon_type(wpn)
                        self.use_needed = self:is_use_needed(wpn)
                    end
                end

                function BaseLocal:finish_command(cmd, me, wpn)
                    local command = ffi_helpers.user_input:get_command(cmd.command_number)

                    if command then
                        if cmd.chokedcommands == 0 and self._last_yaw then
                            local cheat_dsy = c_math.normalize_yaw(self._last_yaw - command.view[1])

                            self.fakeyaw = -(cheat_dsy > 0 and cheat_dsy - 60 or cheat_dsy + 60)
                        elseif cmd.chokedcommands ~= 0 then
                            self._last_yaw = command.view[1]
                        end
                    end
                end

                function BaseLocal:net_update_end()
                    if not self.valid then
                        return self:reset(true)
                    end

                    if self.alive then
                        self.defensive_active = self:get_defensive()
                    end
                end

                function BaseLocal:paint_ui()
                    local me = entity.get_local_player()

                    self.valid = me ~= nil

                    if me then
                        self.entindex = me
                        self.alive = entity.is_alive(me)
                    end
                end
            end

            --- Create player object
            ---@return table
            create_player = function ()
                return setmetatable({
                    valid = false,
                    entindex = -1,
                    packets = 0,
                    onground = true,
                    velocity = vector(),
                    speed = 0.0,
                    duckamount = 0.0,
                    stamina = 80.0,
                    velocity_modifier = 1.0,
                    fakeyaw = 0.0,
                    server_fakeyaw = 0.0,
                    smooth_fakeamount = 0.0,
                    fakeamount_gram = {},
                    state = 'Standing',
                    defensive_active = false,
                    defensive_predict = false,
                    use_needed = false,
                    weapon_type = nil,
                    landing = false,
                    peeking = false,
                    freestanding_side = 'none',
                    air_exploit = false,
                    _shifting_enough = false
                }, {
                    __index = BaseLocal
                })
            end
        end

        player = create_player()
    end

    ---
    --- Fakelag
    ---
    local fakelag do
        config.fakelag = {} do
            config.fakelag.enable = menu.new_item(ui.new_checkbox, "AA", "Fake lag", "Custom fakelag")
                :record("fakelag", "enable")
                :save()

            config.fakelag.type = menu.new_item(ui.new_combobox, "AA", "Fake lag", "Custom fakelag: Type", {
                "Cycle",
                "Randomize"
            }):record("fakelag", "type"):save()

            config.fakelag.ticks = menu.new_item(ui.new_slider, "AA", "Fake lag", "Custom fakelag: Ticks", 1, 15, 15, true, "t", 1)
                :record("fakelag", "ticks")
                :save()
        end

        fakelag = {} do
            fakelag.choking = false
            fakelag.last_choke = 0
            fakelag.choke_count = 0
            fakelag.tick = 0
            fakelag.reset = false

            fakelag.setup_command = function (self, cmd, me, wpn)
                if config.fakelag.enable:get() then
                    local max_limit = 15
                    local fakeduck_active = ui.get(reference.ragebot.fakeduck)
                    local onshot_active = c_table.is_hotkey_active(reference.misc.onshot_antiaim)
                    local doubletap_active = c_table.is_hotkey_active(reference.ragebot.doubletap.enable)

                    local type = config.fakelag.type:get()
                    local limit = config.fakelag.ticks:get()

                    if type == 'Cycle' then
                        limit = c_math.clamp(limit - self.tick % 5, 1, 15)
                    elseif type == 'Randomize' then
                        limit = c_math.clamp(limit - c_math.random(0, 5), 1, 15)
                    end

                    if player.peeking then
                        limit = 15
                    end

                    if fakeduck_active then
                        max_limit = 15
                    end

                    override.set(reference.fakelag.enable[1], max_limit ~= 1)
                    override.set(reference.fakelag.amount, player.weapon_type == 'grenade' and 'Dynamic' or 'Maximum')
                    override.set(reference.fakelag.limit, max_limit)
                    override.set(reference.fakelag.variance, 100)

                    local exploits_active = doubletap_active or onshot_active

                    if not exploits_active and player.weapon_type ~= 'grenade' and not fakeduck_active then
                        if cmd.chokedcommands < limit then
                            cmd.allow_send_packet = false
                        else
                            self.tick = self.tick + 1

                            cmd.no_choke = true
                        end
                    end

                    self.reset = false
                elseif not self.reset then
                    override.unset(reference.fakelag.enable[1]) 
                    override.unset(reference.fakelag.amount)
                    override.unset(reference.fakelag.limit)
                    override.unset(reference.fakelag.variance)

                    self.reset = true
                end

                if cmd.chokedcommands == 0 then
                    self.last_choke = self.choke_count
                    self.choke_count = 0;
                else
                    self.choke_count = self.choke_count + 1;
                end

                self.choking = self.last_choke >= 2;
            end
        end
    end

    ---
    --- Anti-aimbot angles
    ---
    local antiaimbot do
        antiaimbot = {}

        config.antiaimbot = {} do
            -- Main
            config.antiaimbot.main_label = menu.new_item(ui.new_label, "AA", "Anti-aimbot angles", "\aFF0000FFMain")
                :config_ignore()

            config.antiaimbot.options = menu.new_item(ui.new_multiselect, "AA", "Anti-aimbot angles", "AA: Modifications", {
                "On use antiaim",
                "Fast ladder",
                "Dormant preset"
            }):record("antiaimbot", "options"):save()
            
            config.antiaimbot.preset = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", "AA: Preset", {
                "Bloom",
                "Blossom",
                "Constructor"
            }):record("antiaimbot", "preset"):save()

            -- Defensive
            config.antiaimbot.defensive_aa = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "Defensive AA")
                :record("antiaimbot", "defensive_aa")
                :save()

            config.antiaimbot.force_target_yaw = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "Defensive AA: Force target yaw")
                :record("antiaimbot", "force_target_yaw")
                :save()

            config.antiaimbot.defensive_target = menu.new_item(ui.new_multiselect, "AA", "Anti-aimbot angles", "Defensive AA: Target", {
                "Double tap",
                "On shot anti-aim"
            }):record("antiaimbot", "defensive_target"):save()

            config.antiaimbot.defensive_conditions = menu.new_item(ui.new_multiselect, "AA", "Anti-aimbot angles", "Force defensive: States", c_constant.STATE_LIST)
                :record("antiaimbot", "defensive_conditions")
                :save()
        
            config.antiaimbot.defensive_triggers = menu.new_item(ui.new_multiselect, "AA", "Anti-aimbot angles", "Defensive AA: Trigger", {
                "Flashed",
                "Damage received",
                "Reloading",
                "Weapon switch"
            }):record("antiaimbot", "defensive_triggers"):save()

            config.antiaimbot.defensive_preset = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", "Defensive AA: Preset", {
                "Auto",
                "Constructor"
            }):record("antiaimbot", "defensive_preset"):save()

            config.antiaimbot.defensive_conditions_auto = menu.new_item(ui.new_multiselect, "AA", "Anti-aimbot angles", "Defensive AA: Conditions\n AUTO", c_table.combine_arrays(c_constant.DEFENSIVE_STATES, c_constant.STATE_LIST))
                :record("antiaimbot", "defensive_conditions_auto")
                :save()

            -- Misc
            config.antiaimbot.misc_label = menu.new_item(ui.new_label, "AA", "Fake lag", "\aFF0000FFMiscellaneous")
                :config_ignore()

            config.antiaimbot.safe_head = menu.new_item(ui.new_checkbox, "AA", "Fake lag", "Safe head")
                :record("antiaimbot", "safe_head")
                :save()

            config.antiaimbot.safe_head_conditions = menu.new_item(ui.new_multiselect, "AA", "Fake lag", "Safe head: Conditions", {
                "Air knife",
                "Air zeus",
                "Air & Crouch",
                "Crouch moving",
                "Crouching",
                "Slow-motion",
                "Standing"
            }):record("antiaimbot", "safe_head_conditions"):save()

            config.antiaimbot.warmup_aa = menu.new_item(ui.new_checkbox, "AA", "Fake lag", "Warmup AA")
                :record("antiaimbot", "warmup_aa")
                :save()

            config.antiaimbot.warmup_aa_conditions = menu.new_item(ui.new_multiselect, "AA", "Fake lag", "Warmup AA: Conditions", {
                "Warmup",
                "Round end"
            }):record("antiaimbot", "warmup_aa_conditions"):save()

            config.antiaimbot.animation_breaker = menu.new_item(ui.new_checkbox, "AA", "Fake lag", "Animation breaker")
                :record("antiaimbot", "animation_breaker")
                :save()

            config.antiaimbot.animation_breaker_leg = menu.new_item(ui.new_combobox, "AA", "Fake lag", "Animation breaker: Leg movement", {
                "Off",
                "Frozen",
                "Walking",
                "Sliding",
                "Jitter"
            }):record("antiaimbot", "animation_breaker_leg"):save()

            
            config.antiaimbot.animation_breaker_air = menu.new_item(ui.new_combobox, "AA", "Fake lag", "Animation breaker: In air", {
                "Off",
                "Frozen",
                "Walking"
            }):record("antiaimbot", "animation_breaker_air"):save()

            config.antiaimbot.animation_breaker_other = menu.new_item(ui.new_multiselect, "AA", "Fake lag", "Animation breaker: Other", {
                "Slide on slow-motion",
                "Slide on crouching",
                "Quick peek legs",
                "Pitch zero on land"
            }):record("antiaimbot", "animation_breaker_other"):save()

            config.antiaimbot.air_exploit = menu.new_item(ui.new_checkbox, "AA", "Fake lag", "Air exploit")
                :record("antiaimbot", "air_exploit")
                :save()

            config.antiaimbot.air_exploit_hotkey = menu.new_item(ui.new_hotkey, "AA", "Fake lag", "\nair_exploit_hotkey", true)
                :record("antiaimbot", "air_exploit_hotkey")
                :save()

            config.antiaimbot.ideal_tick = menu.new_item(ui.new_checkbox, "AA", "Fake lag", "Ideal tick")
                :record("antiaimbot", "ideal_tick")
                :save()

            config.antiaimbot.ideal_tick_hotkey = menu.new_item(ui.new_hotkey, "AA", "Fake lag", "\nideal_tick_hotkey", true)
                :record("antiaimbot", "ideal_tick_hotkey")
                :save()
                
            config.antiaimbot.manual_yaw = menu.new_item(ui.new_checkbox, "AA", "Fake lag", "Manual yaw")
                :record("antiaimbot", "manual_yaw")
                :save()

            config.manuals = {
                menu.new_item(ui.new_hotkey, "AA", "Fake lag", "Bind: Left")
                    :record("manuals", "left")
                    :save(),
                menu.new_item(ui.new_hotkey, "AA", "Fake lag", "Bind: Right")
                    :record("manuals", "right")
                    :save(),
                menu.new_item(ui.new_hotkey, "AA", "Fake lag", "Bind: Backward")
                    :record("manuals", "backward")
                    :save(),
                menu.new_item(ui.new_hotkey, "AA", "Fake lag", "Bind: Forward")
                    :record("manuals", "forward")
                    :save(),
                menu.new_item(ui.new_hotkey, "AA", "Fake lag", "Bind: Reset")
                    :record("manuals", "reset")
                    :save()
            }

            config.antiaimbot.edge_yaw = menu.new_item(ui.new_hotkey, "AA", "Fake lag", "Bind: Edge yaw")
                :record("manuals", "edge")
                :save()

            config.antiaimbot.freestanding = menu.new_item(ui.new_hotkey, "AA", "Fake lag", "Bind: Freestanding")
                :record("manuals", "freestanding")
                :save()

            config.antiaimbot.manual_options = menu.new_item(ui.new_multiselect, "AA", "Fake lag", "Manual AA: Options", {
                "Jitter disabled",
            }):record("antiaimbot", "manual_options"):save()

            config.antiaimbot.fs_options = menu.new_item(ui.new_multiselect, "AA", "Fake lag", "Freestanding: Options", {
                "Jitter disabled",
            }):record("antiaimbot", "fs_options"):save()

            config.antiaimbot.freestanding_disabler_states = menu.new_item(ui.new_multiselect, "AA", "Fake lag", "Freestanding: Ignore", c_constant.STATE_LIST)
                :record("antiaimbot", "freestanding_disabler_states")
                :save()
        end

        do
            local create_antiaim, AntiAim do
                AntiAim = {} do
                    function AntiAim:reset()
                        override.unset(reference.antiaim.pitch.type)
                        override.unset(reference.antiaim.pitch.value)

                        override.unset(reference.antiaim.yaw.base)
                        override.unset(reference.antiaim.yaw.edge)

                        override.unset(reference.antiaim.freestanding[1])
                        override.unset(reference.antiaim.freestanding[2])

                        override.unset(reference.antiaim.yaw.yaw.type)
                        override.unset(reference.antiaim.yaw.yaw.value)

                        override.unset(reference.antiaim.yaw.jitter.type)
                        override.unset(reference.antiaim.yaw.jitter.value)

                        override.unset(reference.antiaim.body.yaw.type)
                        override.unset(reference.antiaim.body.yaw.value)

                        override.unset(reference.antiaim.body.freestanding)
                    end

                    function AntiAim:tick()
                        self.pitch = nil
                        self.pitch_custom = nil
                        self.yaw_base = nil
                        self.edge_yaw = nil
                        self.freestand = nil
                        self.yaw_type = nil
                        self.yaw_offset = nil
                        self.yaw_modifier = nil
                        self.modifier_offset = nil
                        self.left_limit = nil
                        self.right_limit = nil
                        self.body_yaw_type = nil
                        self.body_yaw_value = nil
                        self.inverter = nil
                        self.body_yaw_freestanding = nil
                    end

                    function AntiAim:run()
                        local pitch = self.pitch or 'Minimal';
                        local pitch_value = self.pitch_custom or 89

                        override.set(reference.antiaim.pitch.type, pitch)
                        override.set(reference.antiaim.pitch.value, pitch_value)

                        local yaw_base = self.yaw_base or 'At targets'

                        override.set(reference.antiaim.yaw.base, yaw_base)

                        local edge_yaw = self.edge_yaw or false

                        override.set(reference.antiaim.yaw.edge, edge_yaw)

                        local freestanding = self.freestand or false

                        override.set(reference.antiaim.freestanding[1], freestanding)

                        if freestanding then
                            override.set(reference.antiaim.freestanding[2], 'Always on', 0x0)
                        else
                            override.set(reference.antiaim.freestanding[2], 'On hotkey', 0x0)
                        end

                        local yaw_type = self.yaw_type or '180'
                        local yaw_offset = self.yaw_offset or 0

                        override.set(reference.antiaim.yaw.yaw.type, yaw_type)
                        override.set(reference.antiaim.yaw.yaw.value, yaw_offset)

                        local yaw_modifier = self.yaw_modifier or 'Off'
                        local modifier_offset = self.modifier_offset or 0

                        override.set(reference.antiaim.yaw.jitter.type, yaw_modifier)
                        override.set(reference.antiaim.yaw.jitter.value, modifier_offset)

                        local left_limit, right_limit = self.left_limit or 58, self.right_limit or 58

                        local body_yaw_type = self.body_yaw_type or 'Static'
                        local body_yaw_value = self.inverter and -left_limit or right_limit

                        if self.body_yaw_type then
                            body_yaw_type = self.body_yaw_type
                            body_yaw_value = self.body_yaw_value or 0
                        end

                        override.set(reference.antiaim.body.yaw.type, body_yaw_type)
                        override.set(reference.antiaim.body.yaw.value, c_math.clamp(body_yaw_value, -1, 1))

                        local body_yaw_freestanding = self.body_yaw_freestanding or false

                        override.set(reference.antiaim.body.freestanding, body_yaw_freestanding)
                    end
                end

                function create_antiaim(initial)
                    return setmetatable(initial or {

                    }, {
                        __index = AntiAim
                    })
                end
            end

            antiaimbot.constructor = {}
            antiaimbot.defensive_constructor = {}

            antiaimbot.features = {} do
                antiaimbot.features.running = false

                antiaimbot.features.state = {
                    legit_antiaim = false,
                    safe_head = false,
                    vanish_mode = false,
                    warmup_antiaim = false,
                    manual_antiaim = false,
                    freestanding = false
                }

                antiaimbot.features.fast_ladder = {} do
                    local time_on_ladder = 0
                    local move_time = 0

                    function antiaimbot.features.fast_ladder.ladder_yaw(me)
                        local vx, vy = entity.get_prop(me, 'm_vecLadderNormal')

                        return vx == 1.0 and 180 or vx == -1.0 and 0 or vy == 1.0 and -90 or 90
                    end

                    function antiaimbot.features.fast_ladder.ladder_move(cmd, target_yaw)
                        if target_yaw == 0 then
                            return cmd.forwardmove > 0, cmd.forwardmove < 0, cmd.sidemove == 0, cmd.sidemove < 0, cmd.sidemove > 0
                        end

                        if target_yaw == 180 or target_yaw == -180 then
                            return cmd.forwardmove < 0, cmd.forwardmove > 0, cmd.sidemove == 0, cmd.sidemove > 0, cmd.sidemove < 0
                        end

                        if target_yaw == 90 then
                            return cmd.sidemove > 0, cmd.sidemove < 0, cmd.forwardmove == 0, cmd.forwardmove > 0, cmd.forwardmove < 0
                        end

                        if target_yaw == -90 then
                            return cmd.sidemove > 0, cmd.sidemove > 0, cmd.forwardmove == 0, cmd.forwardmove < 0, cmd.forwardmove > 0
                        end
                    end

                    function antiaimbot.features.fast_ladder:run(enabled, cmd, me, wpn)
                        if not enabled then
                            time_on_ladder = 0
                            move_time = 0

                            return
                        end

                        local throw_time = entity.get_prop(wpn, 'm_fThrowTime')
                        local angles = vector(client.camera_angles())

                        local ascending, descending = cmd.forwardmove > 0, cmd.forwardmove < 0
                        local moving_none, moving_left, moving_right = cmd.sidemove == 0, cmd.sidemove < 0, cmd.sidemove > 0

                        if ascending or descending or not moving_none then
                            move_time = move_time + 1
                        else
                            move_time = 0
                        end

                        if time_on_ladder < 1 then
                            time_on_ladder = time_on_ladder + 1
                        end

                        if move_time < 4 or time_on_ladder < 1 then
                            return
                        end

                        if cmd.in_jump == 1 then
                            return
                        end

                        if not wpn or (not throw_time or throw_time == 0) then
                            --local target_yaw = self.ladder_yaw(me)
                            --local closest_yaw = c_table.closest(c_math.normalize_yaw(cmd.yaw-target_yaw), {-180, -90, 0, 90, 180})
    --
                            --ascending, descending, moving_none, moving_left, moving_right = self.ladder_move(cmd, closest_yaw)
    --
                            --if ascending then
                            --    if angles.x < 45 then
                            --        cmd.pitch = 89
                            --        cmd.in_moveright = 1
                            --        cmd.in_moveleft = 0
                            --        cmd.in_forward = 0
                            --        cmd.in_back = 1
    --
                            --        if moving_none then
                            --            target_yaw = target_yaw + 90
                            --        end
    --
                            --        if moving_left then
                            --            target_yaw = target_yaw + 150
                            --        end
    --
                            --        if moving_right then
                            --            target_yaw = target_yaw + 30
                            --        end
                            --    end
                            --elseif descending then
                            --    cmd.pitch = 89
                            --    cmd.in_moveleft = 1
                            --    cmd.in_moveright = 0
                            --    cmd.in_forward = 1
                            --    cmd.in_back = 0
    --
                            --    if moving_none then
                            --        target_yaw = target_yaw + 90
                            --    end
    --
                            --    if moving_right then
                            --        target_yaw = target_yaw + 150
                            --    end
    --
                            --    if moving_left then
                            --        target_yaw = target_yaw + 30
                            --    end
                            --elseif moving_left or moving_right then
                            --    cmd.in_forward = 1
                            --    cmd.in_moveleft = 0
                            --    cmd.in_moveright = 0
                            --    cmd.in_back = 0
    --
                            --    target_yaw = target_yaw + (moving_left and 90 or -90)
                            --end
    --
                            --cmd.yaw = c_math.normalize_yaw(target_yaw)

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

                            return true
                        end
                    end
                end

                antiaimbot.features.legit_antiaim = {} do
                    local use_time = 0

                    function antiaimbot.features.legit_antiaim.run(instance, cmd, me, wpn)
                        antiaimbot.features.state.legit_antiaim = false

                        if antiaimbot.features.state.running then
                            return 'Priority surpassed'
                        end

                        if not c_table.contains(config.antiaimbot.options:get(), 'On use antiaim') then
                            return 'Not enabled'
                        end

                        if player.weapon_type == 'grenade' then
                            return 'Grenade in hands'
                        end

                        if cmd.in_use == 0 then
                            use_time = 0

                            return 'Not in use'
                        end

                        use_time = use_time + 1

                        if not player.use_needed and use_time > 2 then
                            local preset do
                                local preset_name = config.antiaimbot.preset:get()

                                if preset_name == 'Constructor' then
                                    preset = antiaimbot.constructor
                                else
                                    preset = c_constant.antiaim_presets[preset_name]
                                end
                            end

                            if preset then
                                cmd.in_use = 0

                                antiaimbot.main.run_preset(instance, preset['Legit AA'])

                                antiaimbot.features.state.legit_antiaim = true
                                antiaimbot.features.running = true

                                return 'Legit antiaim is active'
                            end

                            return 'No preset'
                        end

                        return 'Use is needed'
                    end
                end

                antiaimbot.features.manual_antiaim = {} do
                    function antiaimbot.features.manual_antiaim.run(instance, cmd, me, wpn)
                        antiaimbot.features.state.manual_antiaim = false
                        antiaimbot.features.state.freestanding = false

                        if antiaimbot.features.running then
                            return 'Priority surpassed'
                        end

                        if not config.antiaimbot.manual_yaw:get() then
                            antiaimbot.manual_antiaim.state = -1

                            return 'Not enabled'
                        end

                        local state = antiaimbot.manual_antiaim.state
                        local m_options = config.antiaimbot.manual_options:get()
                        local fs_options = config.antiaimbot.fs_options:get()
                        local ignore_freestanding = c_table.contains(config.antiaimbot.freestanding_disabler_states:get(), player.state)

                        if state ~= -1 then
                            instance.yaw_base = 'Local view'

                            instance.yaw_type = '180'
                            instance.yaw_offset = antiaimbot.manual_antiaim.convert[antiaimbot.manual_antiaim.state]

                            antiaimbot.features.state.manual_antiaim = true
                        else
                            instance.edge_yaw, instance.freestand = config.antiaimbot.edge_yaw:rawget(), config.antiaimbot.freestanding:rawget() and not ignore_freestanding

                            antiaimbot.features.state.freestanding = instance.freestand
                        end

                        local fs_detected = instance.freestand and c_table.contains(fs_options, 'Jitter disabled')

                        -- mb

                        if state ~= -1 and c_table.contains(m_options, 'Jitter disabled') or fs_detected then
                            instance.yaw_modifier = 'Off'
                            instance.modifier_offset = 0

                            if player.fs_side ~= 'none' then
                                instance.body_yaw_type = 'Static'
                                instance.body_yaw_value = player.fs_side == 'left' and 1 or -1
                            end

                            if fs_detected then
                                instance.yaw_type = '180'
                                instance.yaw_offset = 0
                            end
                        end

                        if not (antiaimbot.features.state.manual_antiaim or antiaimbot.features.state.freestanding) then
                            return 'Inactive'
                        end

                        antiaimbot.features.running = true

                        return 'Manual antiaim is active'
                    end
                end

                antiaimbot.features.warmup_antiaim = {} do
                    function antiaimbot.features.warmup_antiaim.run(instance, cmd, me, wpn)
                        antiaimbot.features.state.warmup_antiaim = false

                        if antiaimbot.features.running then
                            return 'Priority surpassed'
                        end

                        if not config.antiaimbot.warmup_aa:get() then
                            return 'Not enabled'
                        end

                        local game_rules = entity.get_game_rules()

                        if not game_rules then
                            return 'CGameRules is invalid'
                        end

                        local warmup_period do
                            local is_active = c_table.contains(config.antiaimbot.warmup_aa_conditions:get(), 'Warmup')
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

                                warmup_period = are_all_enemies_dead and globals.curtime() < (entity.get_prop(game_rules, 'm_flRestartRoundTime') or 0)
                            end
                        end

                        if warmup_period then
                            instance.pitch = 'Off'

                            instance.yaw_base = 'At targets'

                            instance.yaw_type = '180'
                            instance.yaw_offset = c_animations:spin('warmup_spin', -180, 180, 1, 32).value

                            instance.yaw_modifier = 'Off'
                            --instance.body_yaw_type = 'Static'
                            --instance.body_yaw_value = 1

                            antiaimbot.features.state.warmup_antiaim = true
                            antiaimbot.features.running = true

                            return 'Warmup AA is active'
                        end

                        return 'Conditions was not met'
                    end
                end

                antiaimbot.features.safe_head = {} do
                    local resolve_classname = {
                        ['CKnife'] = 'Air knife',
                        ['CWeaponTaser'] = 'Air zeus'
                    }

                    antiaimbot.features.safe_head.trace_thread = (function (me, threat)
                        if threat then
                            local my_origin = vector(entity.get_origin(me))
                            local my_head = vector(entity.hitbox_position(me, 0))

                            if entity.is_alive(threat) then
                                --local ent_eyes = vector(entity.hitbox_position(threat, 0))
                                local ent_origin = vector(entity.get_origin(threat))
                                --local forward_against_me = vector():init_from_angles((ent_eyes - my_head):angles())
                                --local head_distance = (my_head - my_origin):length2d()
                                --local target_eyes = my_head + forward_against_me * (head_distance * 2 + 10)

                                --local menux, dmg = client.trace_bullet(threat, target_eyes.x, target_eyes.y, target_eyes.z, my_head.x, my_head.y, my_head.z)

                                do
                                    local target = c_math.extrapolate(threat, vector(entity.hitbox_position(threat, 0)), 5)
                                    local entindex, damage = client.trace_bullet(threat, target.x, target.y, target.z, my_head.x, my_head.y, my_head.z + 6)

                                    if -1 == entindex then
                                        damage = 0
                                    end

                                    return my_origin.z - ent_origin.z > 5 and damage > 0
                                end
                            end
                        end

                        return false
                    end)

                    function antiaimbot.features.safe_head.run(instance, cmd, me, wpn)
                        antiaimbot.features.state.safe_head = false

                        if antiaimbot.features.running then
                            return 'Priority surpassed'
                        end

                        if not config.antiaimbot.safe_head:get() then
                            return 'Not enabled'
                        end

                        local is_enabled = c_table.contains(config.antiaimbot.safe_head_conditions:get(), player.state)
                        local is_safe_head = false
                        local threat = client.current_threat()

                        do
                            if player.state:match('Air') and threat then
                                if wpn then
                                    local weapon_classname = entity.get_classname(wpn)

                                    if c_table.contains(config.antiaimbot.safe_head_conditions:get(), resolve_classname[weapon_classname]) then
                                        is_safe_head = true
                                    end
                                end
                            end
                        end

                        if not is_safe_head then
                            is_safe_head = antiaimbot.features.safe_head.trace_thread(me, threat)
                        end

                        if is_enabled and is_safe_head then
                            instance.pitch = 'Minimal'

                            instance.yaw_type = '180'
                            instance.yaw_base = 'At targets'
                            --instance.yaw_offset = yaw_o
                            instance.yaw_offset = 0
                            instance.yaw_modifier = 'Off'

                            --instance.body_yaw_type = 'Static'
                            --instance.body_yaw_value = -1

                            antiaimbot.features.state.safe_head = true
                            antiaimbot.features.running = true

                            return 'Safe head is running'
                        end

                        if not is_enabled then
                            return 'Not active'
                        end

                        return 'Conditions was not met'
                    end
                end

                antiaimbot.features.vanish_mode = {} do
                    local vanish_weapons = {
                        ['CKnife'] = true,
                        ['CWeaponTaser'] = true,
                        ['CSmokeGrenade'] = true,
                        ['CDecoyGrenade'] = true,
                        ['CHEGrenade'] = true,
                        ['CMolotovGrenade'] = true,
                        ['CIncendiaryGrenade'] = true
                    }

                    function antiaimbot.features.vanish_mode.run(instance, cmd, me, wpn)
                        antiaimbot.features.state.vanish_mode = false

                        if antiaimbot.features.running then
                            return 'Priority surpassed'
                        end

                        if not c_table.contains(config.antiaimbot.options:get(), 'Dormant preset') then
                            return 'Not enabled'
                        end

                        local threat = client.current_threat();

                        if not threat or not entity.is_alive(threat) then
                            return 'Threat is invalid';
                        end

                        local threat_wpn = entity.get_player_weapon(threat);

                        if threat_wpn then
                            local wpn_classname = entity.get_classname(threat_wpn)
                            local can_hit
                            local esp_data = entity.get_esp_data(threat)

                            if esp_data then
                                can_hit = bit.band(esp_data.flags, 2048) ~= 0
                            end

                            if vanish_weapons[wpn_classname] or (entity.is_dormant(threat) and not can_hit) then
                                instance.pitch = 'Minimal'

                                instance.yaw_type = '180'
                                instance.yaw_base = 'At targets'
                                instance.yaw_offset = player.fakeyaw > 0 and 5 or -7
                                instance.yaw_modifier = 'Off'

                                -- < p >
                                instance.body_yaw_type = 'Jitter'
                                instance.body_yaw_value = -1

                                antiaimbot.features.state.vanish_mode = true
                                antiaimbot.features.running = true

                                return 'Vanish mode is running'
                            else
                                return 'Threat weapon invalid/Unsafe dormant state'
                            end
                        else
                            return 'Threat weapon is invalid'
                        end
                    end
                end

                antiaimbot.features.avoid_backstab = {} do
                    function antiaimbot.features.avoid_backstab.run(instance, cmd, me, wpn)
                        local my_origin = vector(entity.get_origin(me))

                        local player_list = entity.get_players(true)
                        local player_cnt = #player_list

                        local closest_dist, closest_yaw = math.huge, nil

                        for i=1, player_cnt do
                            local ent = player_list[i]
                            local weapon = entity.get_player_weapon(ent)
                            local player_origin = vector(entity.hitbox_position(ent, 2))
                            local distance = my_origin:dist(player_origin)
                            --local visible = client.visible(player_origin:unpack())

                            if distance < 350 and weapon ~= nil then
                                local weapon_info = csgo_weapons(weapon)

                                if weapon_info.is_melee_weapon then
                                    if distance < closest_dist then
                                        local _, yaw_to_target = (player_origin - my_origin):angles()

                                        closest_yaw = yaw_to_target
                                        closest_dist = distance
                                    end
                                end
                            end
                        end

                        if closest_yaw then
                            instance.yaw_type = 'Static'
                            instance.yaw_offset = c_math.normalize_yaw(closest_yaw)

                            return true, 'Avoid backstab is active'
                        end

                        return false, 'No target'
                    end
                end
            end

            -- refactor
            antiaimbot.defensive = {} do
                local presets = c_constant.defensive_presets['Auto']

                function antiaimbot.defensive.is_exploit_ready_and_active(wpn)
                    local fakeduck_active = ui.get(reference.ragebot.fakeduck)
                    local onshot_active = c_table.is_hotkey_active(reference.misc.onshot_antiaim)
                    local doubletap_active = c_table.is_hotkey_active(reference.ragebot.doubletap.enable)

                    if fakeduck_active or not (onshot_active or doubletap_active) or doubletap_active and not player:get_double_tap() then
                        return false
                    end

                    if wpn then
                        local wpn_info = csgo_weapons(wpn)

                        if wpn_info then
                            if wpn_info.is_revolver then
                                return false
                            end
                        end
                    end

                    return true
                end


                function antiaimbot.defensive.force(cmd, me, wpn)
                    if not config.antiaimbot.defensive_aa:get() then
                        return false
                    end

                    if not antiaimbot.defensive.is_exploit_ready_and_active(wpn) then
                        return false
                    end

                    local conditions_met = true do
                        local doubletap_active = c_table.is_hotkey_active(reference.ragebot.doubletap.enable)
                        local hideshots_active = c_table.is_hotkey_active(reference.misc.onshot_antiaim) and not doubletap_active
                        local defensive_target = config.antiaimbot.defensive_target:get()

                        if doubletap_active and not c_table.contains(defensive_target, "Double tap") then
                            conditions_met = false
                        elseif hideshots_active and not c_table.contains(defensive_target, "On shot anti-aim") then
                            conditions_met = false
                        end
                    end

                    if not conditions_met then
                        return false
                    end

                    local defensive_check = c_table.contains(config.antiaimbot.defensive_conditions:get(), player.state)

                    local defensive_triggers = config.antiaimbot.defensive_triggers:get()
                    local defensive_triggered

                    local animlayers = ffi_helpers.animlayers:get(me)

                    if not animlayers then
                        return false
                    end

                    local weapon_activity_number = ffi_helpers.activity:get(animlayers[1]['sequence'], me)
                    local flash_activity_number = ffi_helpers.activity:get(animlayers[9]['sequence'], me)
                    local is_reloading = animlayers[1]['weight'] ~= 0.0 and weapon_activity_number == 967
                    local is_flashed = animlayers[9]['weight'] > 0.1 and flash_activity_number == 960
                    local is_under_attack = animlayers[10]['weight'] > 0.1
                    local is_swapping_weapons = cmd.weaponselect > 0

                    if c_table.contains(defensive_triggers, 'Flashed') and is_flashed
                    or c_table.contains(defensive_triggers, 'Damage received') and is_under_attack
                    or c_table.contains(defensive_triggers, 'Reloading') and is_reloading
                    or c_table.contains(defensive_triggers, 'Weapon switch') and is_swapping_weapons then
                        defensive_triggered = true
                    end

                    if defensive_check or defensive_triggered then
                        cmd.force_defensive = 1

                        return true, defensive_triggered
                    end

                    return false
                end

                function antiaimbot.defensive.get_preset(wpn, forcing, triggered)
                    local is_auto = config.antiaimbot.defensive_preset:get() == 'Auto'
                    local preset_data = is_auto and presets or antiaimbot.defensive_constructor

                    if not preset_data then
                        return false
                    end
                    
                    local state_selected = antiaimbot.features.state.legit_antiaim and 'Legit AA' or player.state
                    local is_active = preset_data[state_selected] ~= nil

                    if player.peeking then
                        if (not is_active or preset_data[state_selected].global_set) and preset_data["On peek"] then
                            state_selected = 'On peek'
                            is_active = true
        
                            forcing = true
                        end
                    end

                    if not forcing then
                        return false
                    end

                    local custom_states = {
                        ['freestanding'] = {'Edge direction', 'Freestanding'},
                        ['manual_antiaim'] = {'Edge direction', 'Manual yaw'},
                        ['safe_head'] = {'Safe head'},
                        [ triggered ] = {'Triggered'}
                    }

                    for feature, data in next, custom_states, nil do
                        if feature == true or antiaimbot.features.state[feature] then
                            local state = data[1]
                            local preset_active = preset_data[state]

                            if preset_active and data[2] then
                                preset_active = preset_active and c_table.contains(preset_active.enable_on, data[2])
                            end

                            state_selected = state
                            is_active = preset_active ~= nil
                        end
                    end

                    if is_auto then
                        is_active = c_table.contains(config.antiaimbot.defensive_conditions_auto:get(), state_selected)
                    end

                    local this

                    if state_selected == 'Safe head' or state_selected == 'Edge direction' or state_selected == 'Triggered' then
                        this = presets[state_selected]
                    else
                        this = preset_data[state_selected]
                    end

                    if not this then
                        return false
                    end

                    return is_active, this, state_selected
                end

                local flicker = false
                local last_flick_at = 0

                local three_way = {
                    90,
                    180,
                    -90,
                    180,
                    90
                }

                local scissor_way = 0
                local last_scissor = 0

                function antiaimbot.defensive.get_scissor_offset(way, state)
                    local target_way = way % 6

                    local left do
                        local from = c_math.min(state.yaw_left_start, state.yaw_left_target)
                        local to = c_math.max(state.yaw_left_start, state.yaw_left_target)
                        local step = (to - from) / 12

                        left = from + step / 2 * target_way
                    end

                    local right do
                        local from = c_math.min(state.yaw_right_start, state.yaw_right_target)
                        local to = c_math.max(state.yaw_right_start, state.yaw_right_target)
                        local step = (to - from) / 12

                        right = from + step / 2 * target_way
                    end

                    return way % 2 == 0 and left or right
                end

                function antiaimbot.defensive:run(instance, cmd, me, wpn, forcing, triggered)
                    if antiaimbot.features.state.vanish_mode or antiaimbot.features.state.warmup_antiaim then
                        return false, 'Overrided by superior features'
                    end

                    if not antiaimbot.defensive.is_exploit_ready_and_active(wpn) then
                        return false, 'Exploit is invalid'
                    end

                    local is_active, this, state = self.get_preset(wpn, forcing or false, triggered or false)

                    if not is_active or not this then
                        return false, 'Preset is invalid'
                    end

                    local game_rules = entity.get_game_rules()

                    if game_rules and entity.get_prop(game_rules, 'm_bFreezePeriod') == 1 or cmd.in_use == 1 then
                        return false, 'Player state is invalid'
                    end

                    local pitch_mode = this.pitch
                    local yaw_mode = this.yaw

                    local pitch = ({
                        ['Up'] = -88,
                        ['Zero'] = 0,
                        ['Up Switch'] = c_math.random(-45, -65),
                        ['Down Switch'] = c_math.random(45, 65),
                        ['Random'] = c_math.random(-89, 89),
                        ['Custom'] = this.pitch_custom
                    })[pitch_mode]

                    local yaw = ({
                        ['Forward'] = c_math.normalize_yaw(180 + c_math.random(-30, 30)),
                        ['3-Way'] = c_math.normalize_yaw(three_way[player.packets % 5 + 1] + c_math.randomf(-15, 15)),
                        ['5-Way'] = c_math.normalize_yaw(({ 90, 135, 180, 225, 270 })[player.packets % 5 + 1] + c_math.randomf(-15, 15)),
                        ['Random'] = c_math.random(-180, 180)
                    })[yaw_mode]

                    if yaw_mode == 'Sideways' then
                        local sideways_y = c_animations:flick('sideways_y', -90, 90, 2)

                        yaw = c_math.normalize_yaw(sideways_y.value + client.random_int(-15, 15))
                    end

                    if yaw_mode == 'Spinbot' then
                        local randomize = this.yaw_randomize or 0
                        local spinbot_y = c_animations:spin(string.format('spinbot_y_%s', state), this.yaw_from, this.yaw_to, 1, this.yaw_speed)

                        yaw = c_math.normalize_yaw(spinbot_y.value + client.random_int(-randomize, randomize))
                    end

                    if yaw_mode == 'Delayed' then
                        local yaw_delay = this.yaw_delay or 1
                        local randomize = this.yaw_randomize or 0

                        if player.packets - last_flick_at >= yaw_delay then
                            flicker = not flicker

                            last_flick_at = player.packets
                        end

                        yaw = flicker and this.yaw_left or this.yaw_right

                        if randomize ~= 0 then
                            yaw = yaw + (yaw > 0 and 1 or -1) * client.random_int(0, randomize)
                        end
                    end

                    if yaw_mode == 'Scissors' then
                        local yaw_delay = this.yaw_delay or 1
                        local randomize = this.yaw_randomize or 0

                        if player.packets - last_scissor > yaw_delay then
                            scissor_way = scissor_way + 1
                            last_scissor = player.packets
                        end

                        yaw = self.get_scissor_offset(scissor_way, this) + client.random_int(0, randomize)
                    end

                    local _, view_angle_yaw = client.camera_angles()

                    view_angle_yaw = player:threat_yaw(me) or view_angle_yaw
                    view_angle_yaw = view_angle_yaw - 180

                    if globals.absoluteframetime() < globals.tickinterval() and not client.key_state(0x1) then
                        if forcing and config.antiaimbot.force_target_yaw:get() and state ~= 'On peek' and not antiaimbot.features.state.manual_antiaim then
                            instance.yaw_type = '180'
                            instance.yaw_offset = player.fakeyaw > 0 and 6 or -9

                            instance.body_yaw_type = 'Static'
                            instance.body_yaw_value = player.fs_side == 'left' and 1 or -1
                            instance.inverter = player.fs_side == 'right'
                        end

                        --if player.defensive_active then CHECKME DEFENSIVE
                        if player.defensive_predict then
                            if pitch_mode ~= 'Default' then
                                cmd.pitch = c_math.clamp(pitch, -89, 89)
                            end

                            if yaw_mode ~= 'Default' then
                                cmd.yaw = c_math.normalize_yaw(view_angle_yaw-yaw)
                            end

                            return true
                        else
                            return false, 'Defensive is inactive'
                        end
                    end

                    return false, 'Overrided by left mouse'
                end
            end

            antiaimbot.main = {} do
                local presets = c_constant.antiaim_presets
                local instance = create_antiaim()

                local antiaim_state = {
                    switch = false,
                    swap = false,
                    delay = 0,
                    last_switch = 0,
                    last_packets = 0,
                    step = 1
                }

                function antiaimbot.main.run_preset(instance, data)
                    local yaw_side = player.fakeyaw > 0 and 'left' or 'right'

                    instance.pitch = data.pitch
                    instance.pitch_custom = data.pitch_custom

                    instance.yaw_base = data.yaw_base

                    local yaw_type = data.yaw_type or '180'
                    local yaw = data.yaw_offset or 0

                    -- < yaw >
                    local can_force_body_yaw = true
                    local inverter = false
                    local yaw_modifier = data.yaw_modifier or 'Off'
                    local modifier_offset = data.modifier_offset or 0

                    if yaw_type ~= '180' then
                        if yaw_type == 'Left & Right' then
                            local left_offset = type(data.left_offset) == 'table' and client.random_int(data.left_offset[1], data.left_offset[2]) or data.left_offset
                            local right_offset = type(data.right_offset) == 'table' and client.random_int(data.right_offset[1], data.right_offset[2]) or data.right_offset

                            if data.yaw_delay ~= nil then
                                if player.packets - antiaim_state.last_packets >= antiaim_state.delay then
                                    antiaim_state.delay = client.random_int(c_math.min(data.yaw_delay, data.yaw_delay_second), c_math.max(data.yaw_delay, data.yaw_delay_second))
                                    antiaim_state.switch = not antiaim_state.switch
                                    antiaim_state.last_packets = player.packets
                                end

                                inverter = antiaim_state.switch
                                yaw_side = inverter and 'left' or 'right'
                                can_force_body_yaw = false
                            end

                            yaw_type = '180'
                            yaw = yaw_side == 'left' and left_offset or right_offset
                        end

                        if yaw_type == 'Flick' then
                            yaw_type = '180'
                            yaw = c_animations:flick(string.format('Flick%s', player.state), data.left_offset, data.right_offset, data.yaw_delay).value
                        end

                        if yaw_type == 'Sway' then
                            yaw_type = '180'
                            yaw = c_animations:sway(string.format('Sway%s', player.state), data.left_offset, data.right_offset, data.yaw_delay, data.yaw_speed).value
                        end

                        if yaw_type == 'Spin between' then
                            yaw_type = '180'
                            yaw = c_animations:spin(string.format('Spin%s', player.state), data.left_offset, data.right_offset, data.yaw_delay, data.yaw_speed).value
                        end
                    end

                    instance.yaw_type = yaw_type
                    instance.yaw_offset = c_math.normalize_yaw(yaw)

                    -- < yaw modifier >
                    local yaw_modifier_randomize = data.modifier_randomize

                    if yaw_modifier_randomize then
                        if yaw_modifier_randomize > 0 then
                            modifier_offset = client.random_int(modifier_offset-yaw_modifier_randomize, modifier_offset+yaw_modifier_randomize)
                        else
                            modifier_offset = client.random_int(modifier_offset+yaw_modifier_randomize, modifier_offset-yaw_modifier_randomize)
                        end
                    end

                    instance.yaw_modifier = yaw_modifier
                    instance.modifier_offset = c_math.normalize_yaw(modifier_offset)

                    -- < fake >
                    local left_limit = data.left_limit or 58
                    local right_limit = data.right_limit or 58

                    instance.left_limit = left_limit
                    instance.right_limit = right_limit
                    instance.inverter = inverter

                    if can_force_body_yaw then
                        instance.body_yaw_type = data.body_yaw_type
                        instance.body_yaw_value = data.body_yaw_value
                    end

                    instance.body_yaw_freestanding = data.body_yaw_freestanding
                end

                antiaimbot.main.debug = {}

                function antiaimbot.main:run(cmd, me, wpn)
                    instance:tick()

                    -- temp
                    antiaimbot.main.debug.player_exploit = player.air_exploit

                    if antiaimbot.air_exploit.run(
                        config.antiaimbot.air_exploit:get() and config.antiaimbot.air_exploit_hotkey:rawget(), cmd
                    ) then
                        return instance:run()
                    end

                    local player_state = player.state

                    local is_fakelagging = not (c_table.is_hotkey_active(reference.ragebot.doubletap.enable) or c_table.is_hotkey_active(reference.misc.onshot_antiaim))

                    if is_fakelagging or cmd.chokedcommands == 0 then
                        c_animations:tick(globals.tickcount())
                    end

                    local selected_preset = config.antiaimbot.preset:get() do
                        if selected_preset == 'Constructor' then
                            local preset_data = antiaimbot.constructor[player_state]
                            local fakelag_preset = antiaimbot.constructor['Fake lag']

                            if is_fakelagging and fakelag_preset then
                                preset_data = fakelag_preset
                            end

                            if preset_data then
                                self.run_preset(instance, preset_data)
                            end
                        else
                            local preset_data = presets[selected_preset][player_state]
                            local fakelag_preset = presets[selected_preset]['Fake lag']

                            if is_fakelagging and fakelag_preset then
                                preset_data = fakelag_preset
                            end

                            if preset_data then
                                self.run_preset(instance, preset_data)
                            end
                        end
                    end

                    antiaimbot.main.debug.preset = selected_preset

                    local move_type = entity.get_prop(me, 'm_MoveType')
                    local selected_options = config.antiaimbot.options:get()

                    local is_forcing, triggered_defensive = antiaimbot.defensive.force(cmd, me, wpn)

                    antiaimbot.main.debug.state = {
                        fakelag = is_fakelagging,
                        choking = fakelag.choking,
                        state = player_state
                    }

                    antiaimbot.main.debug.defensive = {
                        forcing = is_forcing,
                        triggered = triggered_defensive
                    }

                    if not antiaimbot.features.fast_ladder:run(
                        c_table.contains(selected_options, 'Fast ladder') and move_type == 9, cmd, me, wpn
                    ) and move_type ~= 9 then
                        antiaimbot.features.running = false

                        antiaimbot.main.debug.legit_antiaim = antiaimbot.features.legit_antiaim.run(instance, cmd, me, wpn)
                        antiaimbot.main.debug.manual_antiaim = antiaimbot.features.manual_antiaim.run(instance, cmd, me, wpn)
                        antiaimbot.main.debug.warmup_antiaim = antiaimbot.features.warmup_antiaim.run(instance, cmd, me, wpn)
                        antiaimbot.main.debug.safe_head = antiaimbot.features.safe_head.run(instance, cmd, me, wpn)
                        antiaimbot.main.debug.vanish_mode = antiaimbot.features.vanish_mode.run(instance, cmd, me, wpn)

                        local avoid_backstab = antiaimbot.features.avoid_backstab.run(instance, cmd, me, wpn)

                        antiaimbot.main.debug.avoid_backstab = avoid_backstab

                        if config.antiaimbot.defensive_aa:get() and not avoid_backstab then
                            antiaimbot.main.debug.defensive = {antiaimbot.defensive:run(instance, cmd, me, wpn, is_forcing, triggered_defensive or false)}
                        end
                    end

                    antiaimbot.ideal_tick.run()

                    instance:run()
                end

                function antiaimbot.main.get_instance()
                    return instance
                end
            end

            antiaimbot.animation_breaker = {} do
                antiaimbot.animation_breaker.anim_reset = false

                function antiaimbot.animation_breaker.run(me)
                    local leg_move = config.antiaimbot.animation_breaker_leg:get()
                    local animlayers = ffi_helpers.animlayers:get(me)

                    if not animlayers then
                        return
                    end

                    if leg_move ~= 'Off' and player.onground and (player.state == 'Moving' or player.state == 'Crouch moving') then
                        if leg_move == 'Frozen' then
                            entity.set_prop(me, 'm_flPoseParameter', 1, 0)
                            override.set(reference.misc.leg_movement, "Always slide")
                        elseif leg_move == 'Jitter' and player.state == 'Moving' then
                            entity.set_prop(me, 'm_flPoseParameter', client.random_float(0, 1), 0)
                            animlayers[12]['weight'] = client.random_float(0, 1)
                            override.set(reference.misc.leg_movement, "Always slide")
                        elseif leg_move == 'Walking' then
                            entity.set_prop(me, 'm_flPoseParameter', 0.5, 7)
                            override.set(reference.misc.leg_movement, "Never slide")
                        elseif leg_move == 'Sliding' and player.state == 'Moving' then
                            entity.set_prop(me, 'm_flPoseParameter', 0, 9)
                            entity.set_prop(me, 'm_flPoseParameter', 0, 10)
                            override.set(reference.misc.leg_movement, "Never slide")
                        else
                            override.unset(reference.misc.leg_movement)
                        end
                    else
                        override.unset(reference.misc.leg_movement)
                    end

                    local air_legs = config.antiaimbot.animation_breaker_air:get()
                    local move_type = entity.get_prop(me, 'm_MoveType')

                    if air_legs ~= 'Off' and not player.onground and not (move_type == 9 or move_type == 8) then
                        if air_legs == 'Frozen' then
                            entity.set_prop(me, 'm_flPoseParameter', 1, 6)
                        elseif air_legs == 'Walking' then
                            local cycle do
                                cycle = globals.realtime() * 0.7 % 2

                                if cycle > 1 then
                                    cycle = 1 - (cycle - 1)
                                end
                            end

                            animlayers[6]['weight'] = 1
                            animlayers[6]['cycle'] = cycle
                        end
                    end

                    local breaker_options = config.antiaimbot.animation_breaker_other:get()

                    if c_table.contains(breaker_options, 'Slide on slow-motion') and c_table.is_hotkey_active(reference.misc.slowmotion) then
                        entity.set_prop(me, 'm_flPoseParameter', 0, 9)
                    end

                    if c_table.contains(breaker_options, 'Slide on crouching') and (player.state == 'Crouching' or player.state == 'Crouch moving') then
                        entity.set_prop(me, 'm_flPoseParameter', 0, 8)
                    end

                    if c_table.contains(breaker_options, 'Pitch zero on land') and player.landing and player.onground then
                        entity.set_prop(me, 'm_flPoseParameter', 0.5, 12)
                    end
                end


                function antiaimbot.animation_breaker.post(cmd, me)
                    if c_table.contains(config.antiaimbot.animation_breaker_other:get(), 'Quick peek legs') and c_table.is_hotkey_active(reference.ragebot.quick_peek_assist) then
                        local move_type = entity.get_prop(me, 'm_MoveType')

                        if move_type == 2 then
                            local command = ffi_helpers.user_input:get_command(cmd.command_number)

                            if command then
                                command.buttons = bit.band(command.buttons, bit.bnot(8))
                                command.buttons = bit.band(command.buttons, bit.bnot(16))
                                command.buttons = bit.band(command.buttons, bit.bnot(512))
                                command.buttons = bit.band(command.buttons, bit.bnot(1024))
                            end
                        end
                    end
                end
            end

            antiaimbot.air_exploit = {} do
                local exploit_counter = 1

                function antiaimbot.air_exploit.run(enabled, cmd)
                    player.air_exploit = enabled

                    if not enabled then
                        if not antiaimbot.air_exploit.lag_reset then
                            override.unset(reference.ragebot.fakeduck)
                            antiaimbot.air_exploit.lag_reset = true
                        end

                        return
                    end

                    if player.onground or not c_table.is_hotkey_active(reference.ragebot.doubletap.enable) then
                        override.unset(reference.ragebot.fakeduck)

                        return
                    end

                    if globals.tickcount() % 2 == 1 then
                        exploit_counter = exploit_counter + 1
                    end

                    if exploit_counter > 2 then
                        override.set(reference.ragebot.fakeduck, "Always on")

                        exploit_counter = 1
                    else
                        override.set(reference.ragebot.fakeduck, "On hotkey", 0x0)
                    end

                    antiaimbot.air_exploit.lag_reset = false

                    return true
                end
            end

            antiaimbot.ideal_tick = {} do
                local ideal_tick_reset

                function antiaimbot.ideal_tick.run()
                    if config.antiaimbot.ideal_tick:get() and config.antiaimbot.ideal_tick_hotkey:get() then
                        override.set(reference.ragebot.quick_peek_assist[1], true)
                        override.set(reference.ragebot.quick_peek_assist[2], "Always on", 0x0)

                        override.set(reference.ragebot.enable[1], true)
                        override.set(reference.ragebot.enable[2], "Always on", 0x0)

                        antiaimbot.features.state.freestanding = true

                        ideal_tick_reset = true
                    else
                        if ideal_tick_reset then
                            override.unset(reference.ragebot.quick_peek_assist[1])
                            override.unset(reference.ragebot.quick_peek_assist[2])
        
                            override.unset(reference.ragebot.enable[1])
                            override.unset(reference.ragebot.enable[2])

                            ideal_tick_reset = false
                        end
                    end
                end
            end

            antiaimbot.manual_antiaim = {} do
                local list = {}

                antiaimbot.manual_antiaim.state = -1
                antiaimbot.manual_antiaim.MANUAL_LEFT = 1
                antiaimbot.manual_antiaim.MANUAL_RIGHT = 2
                antiaimbot.manual_antiaim.MANUAL_BACK = 3
                antiaimbot.manual_antiaim.MANUAL_FORWARD = 4

                antiaimbot.manual_antiaim.convert = {
                    [antiaimbot.manual_antiaim.MANUAL_LEFT] = -90,
                    [antiaimbot.manual_antiaim.MANUAL_RIGHT] = 90,
                    [antiaimbot.manual_antiaim.MANUAL_BACK] = 0,
                    [antiaimbot.manual_antiaim.MANUAL_FORWARD] = 180
                }

                for i=1, #config.manuals do
                    list[#list+1] = {
                        prev = false,
                        ref = config.manuals[i],

                        change = function (self, new_value)
                            if new_value then
                                antiaimbot.manual_antiaim.state = (antiaimbot.manual_antiaim.state == i or i == 5) and -1 or i
                            end
                        end,

                        update = function (self)
                            local new_value, mode = self.ref:rawget()

                            if new_value ~= self.prev then
                                self:change(mode == 2 and true or new_value)

                                self.prev = new_value
                            end
                        end
                    }
                end

                function antiaimbot.manual_antiaim.update()
                    for i=1, #list do
                        list[i]:update();
                    end
                end
            end

            function antiaimbot:predict_command(cmd, me, wpn)
                self.manual_antiaim.update()

                if not me then
                    return
                end

                if config.antiaimbot.animation_breaker:get() then
                    self.animation_breaker.run(me)

                    self.animation_breaker.anim_reset = false
                elseif not self.anim_reset then
                    override.unset(reference.misc.leg_movement)
                    self.animation_breaker.anim_reset = true
                end
            end

            function antiaimbot:setup_command(cmd, me, wpn)
                if me == nil then
                    return
                end

                self.main:run(cmd, me, wpn)
            end

            function antiaimbot:finish_command(cmd, me, wpn)
                if not me then
                    return
                end

                if config.antiaimbot.animation_breaker:get() then
                    self.animation_breaker.post(cmd, me);
                end
            end
        end
    end

    ---
    --- Anti-aimbot builder
    ---
    local antiaimbot_builder do
        config.builder = {} do
            config.builder.antiaim_state = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", "AA: Configured state", c_table.combine_arrays({"Global", "Fake lag"}, c_constant.STATE_LIST))
                :config_ignore()

            config.builder.defensive_state = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", "Defensive AA: Configured state", c_table.combine_arrays({"Global"}, c_constant.DEFENSIVE_STATES, c_constant.STATE_LIST))
                :config_ignore()
        end

        antiaimbot_builder = {} do
            antiaimbot_builder.settings = {} do
                local global_state_list = c_table.combine_arrays({'Global', 'Fake lag'}, c_constant.STATE_LIST)

                for i=1, #global_state_list do
                    local state = global_state_list[i]

                    antiaimbot_builder.settings[state] = {}

                    local this = antiaimbot_builder.settings[state]

                    if state ~= "Global" then
                        this.enabled = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", table.concat { "Enabled", "\n", "AA", state })
                            :record("builder", table.concat { "AA", "::", state, "::Enabled" })
                            :save()
                    end

                    this.pitch = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", table.concat { state, ": Pitch", "\n", "AA", state }, {
                        "Off",
                        "Default",
                        "Up",
                        "Down",
                        "Minimal",
                        "Random",
                        "Custom"
                    }):record("builder", table.concat { "AA", "::", state, "::Pitch" }):save()

                    this.pitch_amount = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "\n", "Pitch custom", "AA", state }, -89, 89, 0, true, "°", 1)
                        :record("builder", table.concat { "AA", "::", state, "::PitchCustom" })
                        :save()

                    this.yaw_base = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", table.concat { state, ": Yaw base", "\n", "AA", state }, {
                        "Local view",
                        "At targets"
                    }):record("builder", table.concat { "AA", "::", state, "::YawBase" }):save()

                    this.yaw_type = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", table.concat { state, ": Yaw", "\n", "AA", state }, {
                        "Off",
                        "180",
                        "Spin",
                        "Static",
                        "180 Z",
                        "Crosshair",
                        "Left & Right",
                        "Flick",
                        "Sway",
                        "Spin between"
                    }):record("builder", table.concat { "AA", "::", state, "::YawType" }):save()

                    this.yaw_amount = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "\n", "Yaw custom", "AA", state }, -180, 180, 0, true, "°", 1)
                        :record("builder", table.concat { "AA", "::", state, "::YawCustom" })
                        :save()

                    this.yaw_left = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Yaw left", "\n", "AA", state }, -180, 180, 0, true, "°", 1)
                        :record("builder", table.concat { "AA", "::", state, "::YawLeft" })
                        :save()

                    this.yaw_right = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Yaw right", "\n", "AA", state }, -180, 180, 0, true, "°", 1)
                        :record("builder", table.concat { "AA", "::", state, "::YawRight" })
                        :save()

                    this.yaw_delayed_switch = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", table.concat { state, ": Yaw delayed switch", "\n", "AA", state })
                        :record("builder", table.concat { "AA", "::", state, "::YawDelayedSwitch" })
                        :save()

                    this.yaw_switch_delay = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Yaw delayed switch: Delay", "\n", "AA", state }, 1, 12, 6, true, "t", 1, {[0] = "Off"})
                        :record("builder", table.concat { "AA", "::", state, "::YawSwitchDelay" })
                        :save()

                    this.yaw_switch_delay_second = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Yaw delayed switch: Delay second", "\n", "AA", state }, 1, 12, 6, true, "t", 1, {[0] = "Off"})
                        :record("builder", table.concat { "AA", "::", state, "::YawSwitchDelaySecond" })
                        :save()

                    this.yaw_delay = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Yaw delay", "\n", "AA", state }, 1, 64, 5, true, "t", 1, {[0] = "Off"})
                        :record("builder", table.concat { "AA", "::", state, "::YawDelay" })
                        :save()

                    this.yaw_speed = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Yaw speed", "\n", "AA", state }, 1, 64, 5, true, "t", 1, {[0] = "Off"})
                        :record("builder", table.concat { "AA", "::", state, "::YawSpeed" })
                        :save()

                    this.yaw_jitter = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", table.concat { state, ": Yaw Jitter", "\n", "AA", state }, {
                        "Off",
                        "Offset",
                        "Center",
                        "Random",
                        "Skitter"
                    }):record("builder", table.concat { "AA", "::", state, "::YawJitter" }):save()

                    this.jitter_value = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "\n", "Jitter value", "AA", state }, -180, 180, 0, true, "°", 1)
                        :record("builder", table.concat { "AA", "::", state, "::JitterValue" })
                        :save()

                    this.jitter_randomize = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Yaw jitter: Randomize", "\n", "AA", state }, -180, 180, 0, true, "°", 1, {[0] = "Off"})
                        :record("builder", table.concat { "AA", "::", state, "::JitterRandomize" })
                        :save()

                    this.body_yaw = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", table.concat { state, ": Body yaw", "\n", "AA", state }, {
                        "Off",
                        "Opposite",
                        "Jitter",
                        "Static"
                    }):record("builder", table.concat { "AA", "::", state, "::BodyYaw" }):save()

                    this.body_value = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "\n", "Body value", "AA", state }, -180, 180, 0, true, "°", 1)
                        :record("builder", table.concat { "AA", "::", state, "::BodyValue" })
                        :save()
                end

                local function onStateChange()
                    antiaimbot.constructor = {}

                    local state_list = c_table.combine_arrays({'Fake lag'}, c_constant.STATE_LIST)

                    for i=1, #state_list do
                        local state = state_list[i]

                        antiaimbot.constructor[state] = {}

                        local this = antiaimbot.constructor[state]
                        local is_enabled = antiaimbot_builder.settings[state].enabled:get()

                        if not is_enabled and state == 'Fake lag' then
                            antiaimbot.constructor[state] = nil

                            goto continue
                        end

                        local menu_state = is_enabled and antiaimbot_builder.settings[state] or antiaimbot_builder.settings['Global']

                        this.pitch = menu_state.pitch:get()
                        this.pitch_custom = menu_state.pitch_amount:get()

                        this.yaw_base = menu_state.yaw_base:get()

                        local yaw_type = menu_state.yaw_type:get()

                        this.yaw_type = yaw_type

                        if yaw_type == 'Left & Right' then
                            local yaw_delay = menu_state.yaw_switch_delay:get()

                            this.yaw_delay = menu_state.yaw_delayed_switch:get() and yaw_delay or nil
                            this.yaw_delay_second = menu_state.yaw_switch_delay_second:get()
                            this.left_offset = menu_state.yaw_left:get()
                            this.right_offset = menu_state.yaw_right:get()
                        elseif yaw_type == 'Flick' or yaw_type == 'Sway' or yaw_type == 'Spin between' then
                            this.left_offset = menu_state.yaw_left:get()
                            this.right_offset = menu_state.yaw_right:get()
                            this.yaw_delay = menu_state.yaw_delay:get()
                            this.yaw_speed = menu_state.yaw_speed:get()
                        else
                            this.yaw_offset = menu_state.yaw_amount:get()
                        end

                        local jitter_type = menu_state.yaw_jitter:get()

                        this.yaw_modifier = jitter_type

                        this.modifier_offset = menu_state.jitter_value:get()
                        this.modifier_randomize = menu_state.jitter_randomize:get()

                        this.body_yaw_type = menu_state.body_yaw:get()
                        this.body_yaw_value = menu_state.body_value:get()

                        ::continue::
                    end

                    antiaimbot.constructor['Legit AA'] = {
                        pitch = 'Off',
                        yaw_base = 'Local view',
                        yaw_type = 'Left & Right',
                        left_offset = 165,
                        right_offset = -165,

                        yaw_delay = 1,
                        yaw_delay_second = 6
                    }
                end


                local builder_keys = menu.get_records()["builder"]

                for key, element in pairs(builder_keys) do
                    element:set_callback(onStateChange)
                end

                onStateChange()
            end

            antiaimbot_builder.defensive_settings = {} do
                local defensive_state_list = c_table.combine_arrays({'Global'}, c_constant.DEFENSIVE_STATES, c_constant.STATE_LIST)

                for i=1, #defensive_state_list do
                    local state = defensive_state_list[i]

                    antiaimbot_builder.defensive_settings[state] = {}

                    local this = antiaimbot_builder.defensive_settings[state]

                    this.enabled = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", table.concat { "Enabled", "\n", "DEF", state })
                        :record("defensive", table.concat { "DEF", "::", state, "::Enabled" })
                        :save()

                    if state == "Edge direction" then
                        this.enable_on = menu.new_item(ui.new_multiselect, "AA", "Anti-aimbot angles", table.concat { state,  ": Target", "\n", "DEF" }, {"Freestanding", "Manual yaw"})
                            :record("defensive", table.concat { "DEF", "::", state, "::Target" })
                            :save()
                    end

                    if state == "Safe head" or state == "Edge direction" or state == "Triggered" then
                        goto ignore
                    end

                    this.pitch = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", table.concat { state,  ": Pitch", "\n", "DEF" }, {
                        "Default",
                        "Up",
                        "Zero",
                        "Up Switch",
                        "Down Switch",
                        "Random",
                        "Custom"
                    }):record("defensive", table.concat { "DEF", "::", state, "::Pitch" }):save()

                    this.pitch_custom = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "\n", "Pitch custom", "DEF", state }, -89, 89, 89, true, "°", 1)
                        :record("defensive", table.concat { "DEF", "::", state, "::PitchCustom" })
                        :save()

                    this.yaw = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", table.concat { state,  ": Yaw", "\n", "DEF" }, {
                        "Default",
                        "Forward",
                        "Sideways",
                        "Delayed",
                        "Scissors",
                        "Spinbot",
                        "3-Way",
                        "5-Way",
                        "Random"
                    }):record("defensive", table.concat { "DEF", "::", state, "::Yaw" }):save()

                    this.yaw_from = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: From", "\n", "DEF", state }, -180, 180, 0, true, "°", 1)
                        :record("defensive", table.concat { "DEF", "::", state, "::YawFrom" })
                        :save()
                    this.yaw_to = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: To", "\n", "DEF", state }, -180, 180, 0, true, "°", 1)
                        :record("defensive", table.concat { "DEF", "::", state, "::YawTo" })
                        :save()
                    this.yaw_speed = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Speed", "\n", "DEF", state }, 1, 64, 1, true, "t", 1)
                        :record("defensive", table.concat { "DEF", "::", state, "::YawSpeed" })
                        :save()

                    this.yaw_left = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Left", "\n", "DEF", state }, -180, 180, 0, true, "°", 1)
                        :record("defensive", table.concat { "DEF", "::", state, "::YawLeft" })
                        :save()
                    this.yaw_right = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Right", "\n", "DEF", state }, -180, 180, 0, true, "°", 1)
                        :record("defensive", table.concat { "DEF", "::", state, "::YawRight" })
                        :save()

                    this.yaw_left_start = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Left start", "\n", "DEF", state }, -180, 180, 0, true, "°", 1)
                        :record("defensive", table.concat { "DEF", "::", state, "::YawLeftStart" })
                        :save()
                    this.yaw_left_target = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Left target", "\n", "DEF", state }, -180, 180, 0, true, "°", 1)
                        :record("defensive", table.concat { "DEF", "::", state, "::YawLeftTarget" })
                        :save()

                    this.yaw_right_start = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Right start", "\n", "DEF", state }, -180, 180, 0, true, "°", 1)
                        :record("defensive", table.concat { "DEF", "::", state, "::YawRightStart" })
                        :save()
                    this.yaw_right_target = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Right target", "\n", "DEF", state }, -180, 180, 0, true, "°", 1)
                        :record("defensive", table.concat { "DEF", "::", state, "::YawRightTarget" })
                        :save()

                    this.yaw_delay = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Delay", "\n", "DEF", state }, 1, 8, 6, true, "t", 1)
                        :record("defensive", table.concat { "DEF", "::", state, "::YawDelay" })
                        :save()
                    this.yaw_randomize = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", table.concat { "Custom: Randomize", "\n", "DEF", state }, 0, 180, 0, true, "°", 1, { [0] = "Off" })
                        :record("defensive", table.concat { "DEF", "::", state, "::YawRandomize" })
                        :save()

                    ::ignore::
                end


                local function onStateChange()
                    antiaimbot.defensive_constructor = {}

                    for i=1, #defensive_state_list do
                        local state = defensive_state_list[i]

                        antiaimbot.defensive_constructor[state] = {}

                        local this = antiaimbot.defensive_constructor[state]
                        local is_enabled = antiaimbot_builder.defensive_settings[state].enabled:get()
                        local is_global = false

                        if not is_enabled then
                            local global_state = antiaimbot_builder.defensive_settings['Global']

                            if not global_state.enabled:get() then
                                antiaimbot.defensive_constructor[state] = nil

                                goto continue
                            else
                                is_global = true
                            end
                        end

                        local menu_state = antiaimbot_builder.defensive_settings[state]

                        if is_global then
                            menu_state = antiaimbot_builder.defensive_settings['Global']
                        end

                        if is_global then
                            this.enable_on = {'Freestanding', 'Manual yaw'}
                            this.global_set = true
                        else
                            if state == 'Edge direction' then
                                this.enable_on = menu_state.enable_on:get()
                            end
                        end

                        if state == 'Safe head' or state == 'Edge direction' or state == 'Triggered' then
                            goto continue
                        end

                        this.pitch = menu_state.pitch:get()
                        this.pitch_custom = menu_state.pitch_custom:get()

                        this.yaw = menu_state.yaw:get()

                        this.yaw_left = menu_state.yaw_left:get()
                        this.yaw_right = menu_state.yaw_right:get()
                        this.yaw_delay = menu_state.yaw_delay:get()

                        this.yaw_from = menu_state.yaw_from:get()
                        this.yaw_to = menu_state.yaw_to:get()
                        this.yaw_speed = menu_state.yaw_speed:get()

                        this.yaw_left_start = menu_state.yaw_left_start:get()
                        this.yaw_left_target = menu_state.yaw_left_target:get()

                        this.yaw_right_start = menu_state.yaw_right_start:get()
                        this.yaw_right_target = menu_state.yaw_right_target:get()

                        this.yaw_randomize = menu_state.yaw_randomize:get()

                        ::continue::
                    end
                end

                local builder_keys = menu.get_records()["defensive"]

                for key, element in pairs(builder_keys) do
                    element:set_callback(onStateChange)
                end

                onStateChange()
            end
        end
    end

    ---
    --- Visuals
    ---
    local visuals do
        config.visuals = {} do
            config.visuals.indicators = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "Indicators")
                :record("visuals", "indicators")
                :save()

            config.visuals.indicator_color = menu.new_item(ui.new_color_picker, "AA", "Anti-aimbot angles", "\nindicator_color")
                :record("visuals", "indicator_color")
                :save()

            config.visuals.indicator_style = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", "Indicators: Style", {
                "Modern",
                "Legacy",
                "Renewed"
            }):record("visuals", "indicator_style"):save()

            config.visuals.indicator_renewed_color = menu.new_item(ui.new_color_picker, "AA", "Anti-aimbot angles", "Indicators: Renewed")
                :record("visuals", "indicator_renewed_color")
                :save()

            config.visuals.indicator_vertical_offset = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", "Indicators: Vertical offset", 20, 100, 10, true, "px")
                :record("visuals", "indicator_vertical_offset")
                :save()

            config.visuals.indicator_options = menu.new_item(ui.new_multiselect, "AA", "Anti-aimbot angles", "Indicators: Settings", {
                "Velocity modifier",
                "Adjust while scoped",
                "Alter alpha while scoped",
                "Alter alpha on grenade"
            }):record("visuals", "indicator_options"):save()

            config.visuals.damage_marker = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "Damage marker")
                :record("visuals", "damage_marker")
                :save()

            config.visuals.damage_marker_color = menu.new_item(ui.new_color_picker, "AA", "Anti-aimbot angles", "\ndamage_marker")
                :record("visuals", "damage_marker_color")
                :save()

            config.visuals.r8_indicator = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "R8 Indicator")
                :record("visuals", "r8_indicator")
                :save()

            config.visuals.r8_indicator_color = menu.new_item(ui.new_color_picker, "AA", "Anti-aimbot angles", "\nr8_indicator")
                :record("visuals", "r8_indicator_color")
                :save()

            config.visuals.manual_arrows = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "Manual arrows")
                :record("visuals", "manual_arrows")
                :save()

            config.visuals.manual_arrows_color = menu.new_item(ui.new_color_picker, "AA", "Anti-aimbot angles", "\nmanual_arrows", 77, 77, 77, 255)
                :record("visuals", "manual_arrows_color")
                :save()

            config.visuals.manual_arrows_accent = menu.new_item(ui.new_color_picker, "AA", "Anti-aimbot angles", "Manual arrows: Accent")
                :record("visuals", "manual_arrows_accent")
                :save()

            config.visuals.manual_arrows_style = menu.new_item(ui.new_combobox, "AA", "Anti-aimbot angles", "Manual arrows: Style", {
                "Triangles",
                "Symbols #1",
                "Symbols #2",
                "Symbols #3"
            }):record("visuals", "manual_arrows_style"):save()

            config.visuals.manual_arrows_options = menu.new_item(ui.new_multiselect, "AA", "Anti-aimbot angles", "Manual arrows: Settings", {
                "Hide while scoped"
            }):record("visuals", "manual_arrows_options"):save()

            config.visuals.manual_arrows_size = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", "Manual arrows: Size", 5, 100, 10, true, "px")
                :record("visuals", "manual_arrows_size")
                :save()

            config.visuals.manual_arrows_offset = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", "Manual arrows: Offset", 10, 100, 35, true, "px")
                :record("visuals", "manual_arrows_offset")
                :save()
        end

        visuals = {} do
            local screen_size = vector(client.screen_size())
            local screen_center = screen_size * 0.5

            local state_name = player.state

            local smooth_charge = c_tweening:new(0)
            local smooth_scope = c_tweening:new(0)
            local smooth_state = c_tweening:new(1.0)

            local indicator_global = c_tweening:new(0)
            local indicator_grenade = c_tweening:new(1.0)

            visuals.modern = {} do
                local list = {
                    {
                        name = 'VELOCITY: %d%%',
                        format = function ()
                            return player.velocity_modifier * 100
                        end,
                        active = function ()
                            return c_table.contains(config.visuals.indicator_options:get(), 'Velocity modifier') and player.velocity_modifier ~= 1.0
                        end,
                        color = function ()
                            return color.yellow:lerp(color.gray, player.velocity_modifier)
                        end,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = 'SAFE HEAD',
                        active = function ()
                            return antiaimbot.features.state.safe_head
                        end,
                        color = color.fixik,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = 'DOUBLETAP',
                        active = function ()
                            return c_table.is_hotkey_active(reference.ragebot.doubletap.enable)
                        end,
                        color = function ()
                            return color.red:lerp(color.white, smooth_charge())
                        end,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = 'ONSHOT',
                        active = function ()
                            return c_table.is_hotkey_active(reference.misc.onshot_antiaim)
                        end,
                        color = color.onshot,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = 'DUCK',
                        active = function ()
                            return ui.get(reference.ragebot.fakeduck) and not player.air_exploit
                        end,
                        color = function (accent, me)
                            return color.white:lerp(color.gray, 1 - player.duckamount)
                        end,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = 'DAMAGE: %d',
                        format = function ()
                            return ui.get(reference.ragebot.minimum_damage_override[3])
                        end,
                        active = function ()
                            return c_table.is_hotkey_active(reference.ragebot.minimum_damage_override)
                        end,
                        color = color.white,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = 'FREESTAND',
                        active = function ()
                            return c_table.is_hotkey_active(reference.antiaim.freestanding)
                        end,
                        color = color.freestanding,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = 'EDGE',
                        active = function ()
                            return ui.get(reference.antiaim.yaw.edge)
                        end,
                        color = color.edge,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = 'BAIM',
                        active = function ()
                            return ui.get(reference.ragebot.force_bodyaim)
                        end,
                        color = color.raw_red,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = 'SP',
                        active = function ()
                            return ui.get(reference.ragebot.force_safepoint)
                        end,
                        color = color.raw_green,
                        animation = c_tweening:new(0)
                    }
                }

                visuals.modern.draw = (function (global_alpha, grenade_alpha)
                    local ctx_alpha = global_alpha * grenade_alpha

                    local indicator_offset = config.visuals.indicator_vertical_offset:get()
                    local indicator_position = screen_center + vector(0, indicator_offset)

                    -- local scope_animation = smooth_scope()

                    -- < label >
                    local indicator_accent = color(config.visuals.indicator_color:get())

                    local indicator_label = 'BLOOM.TOOL'

                    renderer.text(indicator_position.x , indicator_position.y, 255, 255, 255, 255*ctx_alpha, '-', 0, indicator_label)

                    indicator_position = indicator_position + vector(0, 11)

                    local indicator_body_yaw = c_math.clamp(player.smooth_fakeamount*0.0172, 0.0, 1.0)

                    renderer.rectangle(indicator_position.x + 1, indicator_position.y, 46, 5, 0, 0, 0, 255*ctx_alpha)
                    renderer.gradient(indicator_position.x + 2, indicator_position.y + 1, math.floor(indicator_body_yaw*43), 3,
                        indicator_accent.r, indicator_accent.g, indicator_accent.b, 255*ctx_alpha,
                        indicator_accent.r, indicator_accent.g, indicator_accent.b, 15*ctx_alpha,
                    true)

                    indicator_position = indicator_position + vector(0, 5)

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
                                    indicator_color = indicator.color()
                                else
                                    indicator_accent = indicator_accent:clone()
                                end
                            end

                            renderer.text(indicator_position.x, indicator_position.y, indicator_color.r, indicator_color.g, indicator_color.b, indicator_color.a*indicator_animation*ctx_alpha, '-', 0, indicator_text)

                            indicator_position = indicator_position + vector(0, 9) * indicator_animation
                        end
                    end
                end)
            end

            visuals.legacy = {} do
                local list = {
                    {
                        name = "velocity %d%%",
                        format = function()
                            return player.velocity_modifier * 100
                        end,
                        active = function()
                            return c_table.contains(config.visuals.indicator_options:get(), "Velocity modifier") and player.velocity_modifier ~= 1.0
                        end,
                        color = color.pink,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "safe head",
                        active = function()
                            return antiaimbot.features.state.safe_head
                        end,
                        color = color.fixik,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "shifting (dt)",
                        active = function()
                            return c_table.is_hotkey_active(reference.ragebot.doubletap.enable)
                        end,
                        color = function()
                            return color.red:lerp(color.white, smooth_charge())
                        end,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "onshot",
                        active = function()
                            return c_table.is_hotkey_active(reference.misc.onshot_antiaim)
                        end,
                        color = color.purplish,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "ducking",
                        active = function()
                            return ui.get(reference.ragebot.fakeduck) and not player.air_exploit
                        end,
                        color = function(accent, me)
                            return color.white:lerp(color.gray, 1 - player.duckamount)
                        end,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "damage (%d)",
                        format = function()
                            return ui.get(reference.ragebot.minimum_damage_override[3])
                        end,
                        active = function()
                            return c_table.is_hotkey_active(reference.ragebot.minimum_damage_override)
                        end,
                        color = color.white,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "onlybaim",
                        active = function()
                            return ui.get(reference.ragebot.force_bodyaim)
                        end,
                        color = color.pink,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "freestanding",
                        active = function()
                            return c_table.is_hotkey_active(reference.antiaim.freestanding)
                        end,
                        color = color("9DB0FBCA"),
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "edging",
                        active = function()
                            return ui.get(reference.antiaim.yaw.edge)
                        end,
                        color = color.pink,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "safety",
                        active = function()
                            return ui.get(reference.ragebot.force_safepoint)
                        end,
                        color = color.blue,
                        animation = c_tweening:new(0)
                    }
                }

                visuals.legacy.draw = (function (global_alpha, grenade_alpha)
                    local ctx_alpha = global_alpha * grenade_alpha

                    local indicator_offset = config.visuals.indicator_vertical_offset:get()
                    local indicator_position = screen_center + vector(0, indicator_offset)

                    local scope_animation = smooth_scope()

                    -- < label >
                    local indicator_accent = color(config.visuals.indicator_color:get())

                    local left_color, right_color do
                        if player.fakeyaw > 0 then
                            left_color = color.white
                            right_color = indicator_accent
                        else
                            left_color = indicator_accent
                            right_color = color.white
                        end
                    end

                    local indicator_label_t = {
                        {'bloom', left_color:alpha_modulate(ctx_alpha, true)},
                        {'.', color.white:alpha_modulate(ctx_alpha, true)},
                        {'tool', right_color:alpha_modulate(ctx_alpha, true)}
                    }
                    local indicator_label = ''

                    for i=1, 3 do
                        indicator_label = string.format('%s\a%s%s', indicator_label, indicator_label_t[i][2]:to_hex(), indicator_label_t[i][1])
                    end

                    local indicator_label_size = vector(renderer.measure_text('b', 'bloom.tool'))
                    local scope_offset = indicator_label_size.x * 0.5 * scope_animation + scope_animation * 4

                    renderer.text(indicator_position.x + scope_offset - indicator_label_size.x * 0.5 + 1, indicator_position.y - indicator_label_size.y * 0.5, 255, 255, 255, 255, 'b', 0, indicator_label)

                    indicator_position = indicator_position + vector(0, indicator_label_size.y)

                    local indicator_body_yaw = c_math.clamp(player.smooth_fakeamount*0.0172, 0.0, 1.0)
                    local indicator_dsy = string.format('%d%%', indicator_body_yaw*100)
                    local indicator_dsy_size = vector(renderer.measure_text('-', indicator_dsy))

                    local scope_offset_dsy = indicator_dsy_size.x * 0.5 * scope_animation + scope_animation * 3

                    renderer.text(indicator_position.x + scope_offset_dsy - indicator_dsy_size.x*0.5, indicator_position.y - indicator_dsy_size.y*0.5, indicator_accent.r, indicator_accent.g, indicator_accent.b, 255*ctx_alpha, '-', 0, indicator_dsy)

                    indicator_position = indicator_position + vector(0, indicator_dsy_size.y + 1)

                    for i=1, #list do
                        local indicator = list[i]
                        local indicator_animation = indicator.animation(0.15, ({indicator.active()})[1] or false)

                        if indicator_animation > 0.01 then
                            local indicator_text = indicator.name:format(indicator.format and indicator.format() or '')
                            local indicator_color do
                                if type(indicator.color) == 'table' then
                                    indicator_color = indicator.color
                                elseif type(indicator.color) == 'function' then
                                    indicator_color = indicator.color(indicator_accent)
                                else
                                    indicator_accent = indicator_accent:clone()
                                end
                            end

                            local text_size = vector(renderer.measure_text('', indicator_text))
                            local _scope_offset = text_size.x*scope_animation*0.5 + scope_animation * 3

                            renderer.text(indicator_position.x + _scope_offset - text_size.x*0.5 + 1, indicator_position.y - text_size.y*0.5, indicator_color.r, indicator_color.g, indicator_color.b, indicator_color.a * indicator_animation*ctx_alpha, '', 0, indicator_text)

                            indicator_position = indicator_position + vector(0, text_size.y) * indicator_animation
                        end
                    end
                end)
            end

            visuals.renewed = {} do
                visuals.renewed.states = {
                    ['Air'] = 'AIR',
                    ['Air & Crouch'] = 'AIR+',
                    ['Crouching'] = 'CROUCHING',
                    ['Crouch moving'] = 'CROUCHING'
                }
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
                        name = "%d%%",
                        format = function()
                            return player.velocity_modifier * 100
                        end,
                        active = function()
                            return c_table.contains(config.visuals.indicator_options:get(), "Velocity modifier") and player.velocity_modifier ~= 1.0
                        end,
                        color = function(accent)
                            return color.red:lerp(accent, player.velocity_modifier)
                        end,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "DMG",
                        active = function()
                            return c_table.is_hotkey_active(reference.ragebot.minimum_damage_override)
                        end,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "DT",
                        active = function()
                            return c_table.is_hotkey_active(reference.ragebot.doubletap.enable)
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
                            return c_table.is_hotkey_active(reference.antiaim.freestanding)
                        end,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "OSAA",
                        active = function()
                            return c_table.is_hotkey_active(reference.misc.onshot_antiaim)
                        end,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "EDGE",
                        active = function()
                            return ui.get(reference.antiaim.yaw.edge)
                        end,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "BAIM",
                        active = function()
                            return ui.get(reference.ragebot.force_bodyaim)
                        end,
                        animation = c_tweening:new(0)
                    },
                    {
                        name = "SP",
                        active = function()
                            return ui.get(reference.ragebot.force_safepoint)
                        end,
                        animation = c_tweening:new(0)
                    }
                }

                visuals.renewed.draw = (function (global_alpha, grenade_alpha)
                    local ctx_alpha = global_alpha * grenade_alpha

                    local indicator_offset = config.visuals.indicator_vertical_offset:get()
                    local indicator_position = screen_center + vector(0, indicator_offset)

                    local scope_animation = smooth_scope()
                    local rev_scope_animation = 1 - scope_animation

                    -- < label >
                    local indicator_accent = color(config.visuals.indicator_color:get())
                    local indicator_renewed = color(config.visuals.indicator_renewed_color:get())

                    local indicator_label = color.animated_text('bloom.tool', 1, indicator_renewed, indicator_accent, ctx_alpha*255)
                    local indicator_label_size = vector(renderer.measure_text('b', 'bloom.tool'))

                    local scope_offset = indicator_label_size.x * 0.5 * scope_animation + scope_animation * 3

                    renderer.text(indicator_position.x + scope_offset - indicator_label_size.x * 0.5, indicator_position.y - indicator_label_size.y * 0.5, 255, 255, 255, ctx_alpha*255, 'b', 0, indicator_label)

                    indicator_position = indicator_position + vector(0, indicator_label_size.y - 1)

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
                end)
            end

            local previous_state = player.state

            visuals.draw_indicators = (function (self)
                if not player.alive then
                    return
                end

                local me = player.entindex
                local indicator_options = config.visuals.indicator_options:get()
                local is_scoped = entity.get_prop(me, 'm_bIsScoped') == 1

                smooth_scope(0.1, c_table.contains(indicator_options, 'Adjust while scoped') and is_scoped)

                local exploits_charged = player:get_double_tap()

                smooth_charge(0.1, exploits_charged or false)

                local player_state = self.renewed.states[player.state] or player.state

                if antiaimbot.features.state.safe_head then
                    player_state = 'SAFE'
                end

                if previous_state ~= player_state then
                    smooth_state(0.15, 1)

                    if smooth_state() == 1.0 then
                        state_name = player_state

                        previous_state = player_state
                    end
                else
                    smooth_state(0.15, 0)
                end

                local indicator_state = indicator_global(0.15, config.visuals.indicators:get())
                local grenade_b = c_table.contains(indicator_options, 'Alter alpha on grenade') and player.weapon_type == 'grenade' or c_table.contains(indicator_options, 'Alter alpha while scoped') and is_scoped
                local grenade_state = indicator_grenade(0.15, grenade_b and 0.5 or 1.0)

                if indicator_state > 0.01 then
                    local indicator_type = config.visuals.indicator_style:get();

                    if indicator_type == 'Modern' then
                        self.modern.draw(indicator_state, grenade_state);
                    elseif indicator_type == 'Legacy' then
                        self.legacy.draw(indicator_state, grenade_state);
                    elseif indicator_type == 'Renewed' then
                        self.renewed.draw(indicator_state, grenade_state);
                    end
                end
            end)

            visuals.markers = {} do
                local marker_points = { 0, 5, 2, 13, 14, 7, 8 }
                local list = {}

                function visuals.markers.receive(event)
                    local userid, attacker = client.userid_to_entindex(event.userid), client.userid_to_entindex(event.attacker)

                    if not userid or not attacker or userid == attacker or attacker ~= player.entindex then
                        return
                    end

                    local hitbox = marker_points[event.hitgroup] or 3
                    local found_existing = false

                    for i=1, #list do
                        local marker = list[i]

                        if marker[1] == userid and marker[3]-globals.realtime() > 1 then
                            marker[5] = marker[5] + (event.dmg_health or 0)

                            found_existing = true
                        end
                    end

                    if not found_existing then
                        list[#list+1] = {
                            userid;
                            {c_tweening:new(0.01), c_tweening:new(0)},
                            globals.realtime() + 2,
                            {config.visuals.damage_marker_color:get()},
                            event.dmg_health or 0,
                            {entity.hitbox_position(userid, hitbox)}
                        }
                    end
                end

                visuals.markers.draw = (function ()
                    local realtime = globals.realtime();

                    for i, marker in ipairs(list) do
                        local time_diff = marker[3] - realtime;
                        local anim = marker[2][1](0.2, time_diff > 0 or marker[2][2]() ~= marker[5]);

                        if anim < 0.01 then
                            table.remove(list, i);
                        else
                            local anim_dmg = marker[2][2](1.5, marker[5]);
                            local screen_x, screen_y = renderer.world_to_screen(marker[6][1], marker[6][2], marker[6][3] + 60 - (time_diff * 40));

                            if screen_x then
                                renderer.text(screen_x, screen_y, marker[4][1], marker[4][2], marker[4][3], marker[4][4]*anim, 'bc', 0, math.floor(anim_dmg));
                            end
                        end
                    end
                end)
            end

            visuals.draw_markers = (function (self)
                if config.visuals.damage_marker:get() then
                    self.markers.draw()
                end
            end)

            visuals.r8_indicator = {} do
                local r8_main = c_tweening:new(0)
                local r8_process = c_tweening:new(0)

                visuals.r8_indicator.draw = (function ()
                    if not player.alive then
                        return
                    end

                    local wpn = entity.get_player_weapon(player.entindex)

                    if not wpn then
                        return
                    end

                    local wpn_info = csgo_weapons(wpn)

                    local main_alpha = r8_main(0.15, config.visuals.r8_indicator:get() and wpn_info and wpn_info.is_revolver)

                    if main_alpha < 0.01 then
                        return
                    end

                    local time = globals.curtime()


                    local m_flFireReady = entity.get_prop(wpn, 'm_flPostponeFireReadyTime')

                    if m_flFireReady > 0 and m_flFireReady < globals.curtime() then
                        if m_flFireReady + globals.tickinterval() * 14 > globals.curtime() then
                            time = m_flFireReady + globals.tickinterval() * 14
                        end
                    end

                    local r8_pct = (time - globals.curtime()) * 4.571428571 -- ( 1 / 0.21875 )

                    local circle_anim = r8_process(0.15, r8_pct) * main_alpha
                    local circle_color = color(config.visuals.r8_indicator_color:get())

                    if entity.get_prop(player.entindex, 'm_flNextAttack') - globals.curtime() >= 0 or entity.get_prop(wpn, 'm_flNextPrimaryAttack') - globals.curtime() >= 0 then
                        r8_process(0.001, 1)
                        circle_anim = 1
                    end

                    renderer.circle_outline(screen_center.x + 25, screen_center.y, 0, 0, 0, 120*main_alpha, 8.2, 0, 1, 5)
                    renderer.circle_outline(screen_center.x + 25, screen_center.y, circle_color.r, circle_color.g, circle_color.b, 255*main_alpha, 7.2, 0, (1 - circle_anim)*main_alpha, 3)
                end)
            end

            visuals.draw_r8_indicator = (function (self)
                if config.visuals.r8_indicator:get() then
                    self.r8_indicator.draw()
                end
            end)

            visuals.manual_arrows = {} do
                local arrows = {
                    main = c_tweening:new(0),
                    left = c_tweening:new(0),
                    right = c_tweening:new(0)
                }

                local arrow_svg3 = (function ()
                    return renderer.load_svg('<svg width="44" height="51" viewBox="0 0 44 51" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4.80057 0.42733L42.2181 23.2222C43.9803 24.2955 43.9775 26.8231 42.2135 27.893L4.81149 50.5757C2.3411 52.0739 -0.515033 49.3119 0.956021 46.8473L12.8323 26.9498C13.344 26.0926 13.345 25.0295 12.8351 24.1714L0.937543 4.14816C-0.528614 1.68041 2.33319 -1.07609 4.80057 0.42733Z" fill="white"/><path d="M4.80057 0.42733L42.2181 23.2222C43.9803 24.2955 43.9775 26.8231 42.2135 27.893L4.81149 50.5757C2.3411 52.0739 -0.515033 49.3119 0.956021 46.8473L12.8323 26.9498C13.344 26.0926 13.345 25.0295 12.8351 24.1714L0.937543 4.14816C-0.528614 1.68041 2.33319 -1.07609 4.80057 0.42733Z" fill="white"/></svg>', 8, 11);
                end)()

                visuals.manual_arrows.draw = (function ()
                    if not player.alive then
                        return
                    end

                    local arrow_options = config.visuals.manual_arrows_options:get()
                    local scope_check = true

                    if c_table.contains(arrow_options, 'Hide while scoped') then
                        scope_check = smooth_scope() < 1
                    end

                    local main = arrows.main(0.15, antiaimbot.manual_antiaim.state ~= -1 and config.visuals.manual_arrows:get() and scope_check)

                    if main > 0.01 then
                        local manual_color_bg = color(config.visuals.manual_arrows_color:get())
                        local manual_color = color(config.visuals.manual_arrows_accent:get())

                        local manual_size = config.visuals.manual_arrows_size:get()
                        local manual_offset = config.visuals.manual_arrows_offset:get()

                        local manual_style = config.visuals.manual_arrows_style:get()

                        local left_modifier = arrows.left(0.15, antiaimbot.manual_antiaim.state == antiaimbot.manual_antiaim.MANUAL_LEFT or antiaimbot.manual_antiaim.state == antiaimbot.manual_antiaim.MANUAL_BACK)
                        local base_position_left = vector(screen_center.x - manual_offset, screen_center.y + 1)

                        local arrow_weight = 8
                        local arrow_height = 11

                        if manual_style == 'Triangles' then
                            renderer.triangle(
                                base_position_left.x - manual_size, base_position_left.y,
                                base_position_left.x, base_position_left.y - manual_size * 0.5,
                                base_position_left.x, base_position_left.y + manual_size * 0.5,
                                manual_color_bg.r, manual_color_bg.g, manual_color_bg.b, manual_color_bg.a * main
                            )

                            renderer.triangle(
                                base_position_left.x - manual_size, base_position_left.y,
                                base_position_left.x, base_position_left.y - manual_size * 0.5,
                                base_position_left.x, base_position_left.y + manual_size * 0.5,
                                manual_color.r, manual_color.g, manual_color.b, 255 * left_modifier * main
                            )
                        elseif manual_style == 'Symbols #1' then
                            renderer.text(base_position_left.x+1, base_position_left.y-4, manual_color_bg.r, manual_color_bg.g, manual_color_bg.b, manual_color_bg.a * main, 'cb+', 0, '‹')
                            renderer.text(base_position_left.x+1, base_position_left.y-4, manual_color.r, manual_color.g, manual_color.b, 255 * left_modifier * main, 'cb+', 0, '‹')
                        elseif manual_style == 'Symbols #2' then
                            renderer.text(base_position_left.x, base_position_left.y-2, manual_color_bg.r, manual_color_bg.g, manual_color_bg.b, manual_color_bg.a * main, 'cb', 0, '⯇')
                            renderer.text(base_position_left.x, base_position_left.y-2, manual_color.r, manual_color.g, manual_color.b, 255 * left_modifier * main, 'cb', 0, '⯇')
                        elseif manual_style == 'Symbols #3' then
                            renderer.texture(arrow_svg3, base_position_left.x+1+arrow_weight/2, base_position_left.y-arrow_height/2+1, -arrow_weight, arrow_height, manual_color_bg.r, manual_color_bg.g, manual_color_bg.b, manual_color_bg.a * main, 'f')
                            renderer.texture(arrow_svg3, base_position_left.x+arrow_weight/2, base_position_left.y-arrow_height/2, -arrow_weight, arrow_height, manual_color.r, manual_color.g, manual_color.b, 255 * left_modifier * main, 'f')
                        end

                        --renderer.rectangle(base_position_left.x, base_position_left.y, 1, 100, 255, 255, 255, 255)

                        local right_modifier = arrows.right(0.15, antiaimbot.manual_antiaim.state == antiaimbot.manual_antiaim.MANUAL_RIGHT or antiaimbot.manual_antiaim.state == antiaimbot.manual_antiaim.MANUAL_BACK)
                        local base_position_right = vector(screen_center.x + manual_offset, screen_center.y + 1)

                        if manual_style == 'Triangles' then
                            renderer.triangle(
                                base_position_right.x + manual_size, base_position_right.y,
                                base_position_right.x, base_position_right.y - manual_size * 0.5,
                                base_position_right.x, base_position_right.y + manual_size * 0.5,
                                manual_color_bg.r, manual_color_bg.g, manual_color_bg.b, manual_color_bg.a * main
                            )

                            renderer.triangle(
                                base_position_right.x + manual_size, base_position_right.y,
                                base_position_right.x, base_position_right.y - manual_size * 0.5,
                                base_position_right.x, base_position_right.y + manual_size * 0.5,
                                manual_color.r, manual_color.g, manual_color.b, 255 * right_modifier * main
                            )
                        elseif manual_style == 'Symbols #1' then
                            renderer.text(base_position_right.x, base_position_right.y-4, manual_color_bg.r, manual_color_bg.g, manual_color_bg.b, manual_color_bg.a * main, 'cb+', 0, '›')
                            renderer.text(base_position_right.x, base_position_right.y-4, manual_color.r, manual_color.g, manual_color.b, 255 * right_modifier * main, 'cb+', 0, '›')
                        elseif manual_style == 'Symbols #2' then
                            renderer.text(base_position_right.x, base_position_right.y-2, manual_color_bg.r, manual_color_bg.g, manual_color_bg.b, manual_color_bg.a * main, 'cb', 0, '⯈')
                            renderer.text(base_position_right.x, base_position_right.y-2, manual_color.r, manual_color.g, manual_color.b, 255 * right_modifier * main, 'cb', 0, '⯈')
                        elseif manual_style == 'Symbols #3' then
                            renderer.texture(arrow_svg3, base_position_right.x-arrow_weight/2+2, base_position_right.y-arrow_height/2+1, arrow_weight, arrow_height, manual_color_bg.r, manual_color_bg.g, manual_color_bg.b, manual_color_bg.a * main, 'f')
                            renderer.texture(arrow_svg3, base_position_right.x-arrow_weight/2+1, base_position_right.y-arrow_height/2, arrow_weight, arrow_height, manual_color.r, manual_color.g, manual_color.b, 255 * right_modifier * main, 'f')
                        end

                        --renderer.rectangle(base_position_right.x, base_position_right.y, 1, 100, 255, 255, 255, 255)
                    end
                end)
            end

            visuals.draw_manual_arrows = (function (self)
                self.manual_arrows.draw()
            end)

            visuals.draw_forced_watermark = (function ()
                screen_size = vector(client.screen_size())
                screen_center = screen_size * 0.5

                if user.debug then
                    local str = inspect(antiaimbot.main.debug):gsub('\t', ('\x20'):rep(4))

                    renderer.text(50, screen_size.y / 4 + 100, 255, 255, 255, 255, '', 0, str)
                end

                if config.visuals.indicators:get() then
                    return
                end

                renderer.text(screen_center.x, screen_size.y - 20, 255, 255, 255, 255, 'c', 0, 'bloom.tool')
            end)

            function visuals:player_hurt(event)
                if not player.alive then
                    return
                end

                self.markers.receive(event)
            end

            function visuals:paint()
                self:draw_indicators()
                self:draw_r8_indicator()
                self:draw_manual_arrows()
                self:draw_markers()
            end

            function visuals:paint_ui()
                self:draw_forced_watermark()
            end
        end
    end

    ---
    --- Miscellaneous
    ---
    local miscellaneous do
        config.miscellaneous = {} do
            config.miscellaneous.clantag = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "Clantag")
                :record("miscellaneous", "clantag")
                :save()

            config.miscellaneous.cheat_tweaks = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "Cheat tweaks")
                :record("miscellaneous", "cheat_tweaks")
                :save()

            config.miscellaneous.cheat_tweaks_list = menu.new_item(ui.new_multiselect, "AA", "Anti-aimbot angles", "Cheat tweaks: List", {
                "Uncharge helper",
                "Super toss on grenade release",
                "Allow crouch on fakeduck"
            }):record("miscellaneous", "cheat_tweaks_list"):save()

            config.miscellaneous.automatic_tp = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "Automatic teleport")
                :record("miscellaneous", "automatic_tp")
                :save()

            config.miscellaneous.automatic_tp_weapons = menu.new_item(ui.new_multiselect, "AA", "Anti-aimbot angles", "Automatic teleport: Weapons", {
                "Auto",
                "Scout",
                "AWP",
                "Pistols",
                "Taser",
                "Knife"
            }):record("miscellaneous", "automatic_tp"):save()

            config.miscellaneous.automatic_tp_delay = menu.new_item(ui.new_slider, "AA", "Anti-aimbot angles", "Automatic teleport", 1, 6, 2, true, "t", 1)
                :record("miscellaneous", "automatic_tp_delay")
                :save()
                
            config.miscellaneous.trashtalk = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "Trashtalk")
                :record("miscellaneous", "trashtalk")
                :save()
            
            config.miscellaneous.custom_output = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "Custom output")
                :record("miscellaneous", "custom_output")
                :save()
                
            config.miscellaneous.event_logger = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "Event logger")
                :record("miscellaneous", "event_logger")
                :save()
                
            config.miscellaneous.console_filter = menu.new_item(ui.new_checkbox, "AA", "Anti-aimbot angles", "Console filter")
                :record("miscellaneous", "console_filter")
                :save()
        end

        miscellaneous = {} do
            miscellaneous.clantag = {} do
                function miscellaneous.clantag.reset()
                    for i=1, 64 do
                        client.set_clan_tag('')
                    end        
                end

                function miscellaneous.clantag.build_tag(text)
                    local prefix = '\t'
                    local suffix = '\t'

                    local temp = {}
                    local len = #text

                    if len < 2 then
                        temp[#temp+1] = text
                        return temp
                    end

                    for i = 1, 8 do
                        temp[#temp+1] = string.format('%s%s%s', prefix, text, suffix)
                    end

                    for i = 1, len do
                        local part = text:sub(i, len)
                        temp[#temp+1] = string.format('%s%s%s', prefix, part, suffix)
                    end

                    temp[#temp+1] = string.format('%s%s', prefix, suffix)

                    for i = c_math.min(2, len), len do
                        local part = text:sub(1, i)
                        temp[#temp+1] = string.format('%s%s%s', prefix, part, suffix)
                    end

                    for i = 1, 4 do
                        temp[#temp+1] = string.format('%s%s%s', prefix, text, suffix)
                    end

                    return temp
                end

                local text = 'bloom.tool'
                local cache = ''
                local chars = miscellaneous.clantag.build_tag(text)
                local restored = false

                function miscellaneous.clantag:run()
                    if not config.miscellaneous.clantag:get() then
                        if not restored then
                            client.set_clan_tag('')

                            restored = true
                        end

                        return
                    end

                    restored = false

                    local latency_out = client.latency()
                    local lock, game_rules = false, entity.get_game_rules()

                    if game_rules ~= nil then
                        local game_phase = entity.get_prop(game_rules, 'm_gamePhase')

                        lock = game_phase == 4 or game_phase == 5
                    end

                    local latency = latency_out / globals.tickinterval()
                    local predicted = globals.tickcount() + latency

                    local idx = c_math.round(predicted * 0.0625) % #chars + 1

                    local target_text = lock and string.format('%s\t', text) or chars[idx]

                    if target_text == cache then
                        return
                    end

                    client.set_clan_tag(target_text)

                    cache = target_text
                end
            end

            miscellaneous.tweaks = {} do
                miscellaneous.tweaks.dt_reset = false

                local single_fire = {40, 9, 64, 27, 29, 35}

                function miscellaneous.tweaks.uncharge_helper(me, wpn)
                    local tickbase_diff = entity.get_prop(me, 'm_nTickBase') - globals.tickcount()
                    local doubletap_active = c_table.is_hotkey_active(reference.ragebot.doubletap.enable) and not ui.get(reference.ragebot.fakeduck)

                    local wpn_info = csgo_weapons(wpn)

                    if not wpn_info then
                        return
                    end

                    local last_shot_time = entity.get_prop(wpn, 'm_fLastShotTime')

                    if not last_shot_time then
                        return
                    end

                    if not doubletap_active then
                        return
                    end

                    local single_fire_weapon = c_table.contains(single_fire, wpn_info.idx)
                    local value = single_fire_weapon and 1.50 or 0.50
                    local in_attack = globals.curtime() - last_shot_time <= value

                    if wpn_info.is_revolver then
                        local threat = client.current_threat()

                        if threat and not player:get_double_tap() and not player.onground and bit.band(entity.get_esp_data(threat).flags, 2048) == 2048 then
                            override.set(reference.ragebot.enabled[2], 'On hotkey', 0x0)
                        else
                            override.set(reference.ragebot.enabled[2], 'Always on')
                        end
                    else
                        if tickbase_diff > 0 and not player:get_double_tap() then
                            if in_attack then
                                override.set(reference.ragebot.enabled[2], 'Always on')
                            else
                                override.set(reference.ragebot.enabled[2], 'On hotkey', 0x0)
                            end

                        --local threat = client.current_threat()
                        --
                        --if threat and not player:get_double_tap() and not player.onground and bit.band(entity.get_esp_data(threat).flags, 2048) == 2048 then
                        --    reference.ragebot.enabled[2]:override('On hotkey', 0x0)
                        else
                            override.set(reference.ragebot.enabled[2], 'Always on')
                        end
                    end

                    return true
                end

                miscellaneous.tweaks.st_reset = false

                function miscellaneous.tweaks.super_toss()
                    local grenade_release_held = c_table.is_hotkey_active(reference.misc.grenade_release)

                    if grenade_release_held then
                        override.set(reference.misc.grenade_toss, true)

                        miscellaneous.tweaks.st_reset = true
                    else
                        override.unset(reference.misc.grenade_toss)
                    end
                end

                miscellaneous.tweaks.fd_reset = false

                function miscellaneous.tweaks.fakeduck_helper(cmd)
                    local state = false

                    if cmd.in_duck == 1 then
                        if player.duckamount > 0.8 then
                            state = true
                        end
                    end

                    local active, mode = ui.get(reference.ragebot.fakeduck)

                    if active and state then
                        local mode_new = 'Off hotkey'

                        if mode == 2 or mode == 3 then
                            mode_new = 'On hotkey'
                        end

                        override.set(reference.ragebot.fakeduck, mode_new)
                        miscellaneous.tweaks.fd_reset = false
                    elseif not state then
                        if not miscellaneous.tweaks.fd_reset then
                            override.unset(reference.ragebot.fakeduck)
                            miscellaneous.tweaks.fd_reset = true
                        end
                    end
                end
            end

            miscellaneous.automatic_tp = {} do
                local weapon_index = {
                    ['Auto Snipers'] = { 38, 11 },
                    ['Pistols'] = { 4, 63, 36, 3, 1, 64, 2, 30, 61, 32 },
                    ['Scout'] = { 40 },
                    ['AWP'] = { 9 },
                    ['Taser'] = { 31 }
                }

                local delay = 0
                local time = 0
                local last_full = 0

                miscellaneous.automatic_tp.reset = false

                miscellaneous.automatic_tp.trace_thread = (function (me, threat)
                    local player_resource = entity.get_player_resource()

                    if not player_resource then
                        return false
                    end

                    local ping = entity.get_prop(player_resource, 'm_iPing', threat)
                    local ticks_to_extrapolate = math.max(5, toticks( ( ping * (ping <= 10 and 2 or 1.75) ) * 0.001 ))

                    local hitbox_position = vector(entity.hitbox_position(threat, 5))
                    local local_hitbox_position = vector(entity.hitbox_position(me, 4))

                    local entindex, damage = client.trace_bullet(threat, hitbox_position.x, hitbox_position.y, hitbox_position.z, c_math.extrapolate(me, local_hitbox_position, ticks_to_extrapolate):unpack())

                    return (damage and damage > 0 or false) and (entindex and entity.get_classname(entindex) ~= 'CWorld' or false)
                end)

                function miscellaneous.automatic_tp.run(me, wpn)
                    if player.onground or player.speed < 100 or not player:get_double_tap() then
                        return globals.realtime()-last_full < 0.4
                    end

                    local threat = client.current_threat()

                    if not threat or entity.is_dormant(threat) then
                        return
                    end

                    if not wpn then
                        return
                    end

                    local wpn_info = csgo_weapons(wpn)

                    if not wpn_info then
                        return
                    end

                    local active_weapon_id = wpn_info.idx

                    local should_run, found_knife = false, false

                    for _, weapon in ipairs(config.miscellaneous.automatic_tp_weapons:get()) do
                        local curr = weapon_index[weapon]

                        if curr then
                            for __, id in ipairs(curr) do
                                if id == active_weapon_id then
                                    should_run = true
                                    break
                                end
                            end
                        else
                            if weapon == 'Knife' then
                                found_knife = true
                            end
                        end
                    end

                    if not should_run and found_knife then
                        should_run = wpn_info.is_melee_weapon
                    end

                    if not should_run then
                        return
                    end

                    local should_teleport = miscellaneous.automatic_tp.trace_thread(me, threat)

                    if should_teleport and time < globals.realtime() then
                        if delay == config.miscellaneous.automatic_tp_delay:get() then
                            time = globals.realtime() + 0.5

                            override.set(reference.ragebot.doubletap.enable.hotkey, 'On hotkey', 0x0)
                            miscellaneous.automatic_tp.reset = true

                            delay = 0
                        end

                        delay = delay + 1
                    elseif time-globals.realtime() > 0.5 and miscellaneous.automatic_tp.reset then
                        override.unset(reference.ragebot.doubletap.enable.hotkey)

                        miscellaneous.automatic_tp.reset = false
                    end

                    last_full = globals.realtime()

                    return true
                end
            end

            miscellaneous.trashtalk = {} do
                local counter = 0
                local list = {
                    ['head'] = {
                        'какой же ты хуевый / статик нынче не в моде',
                        'кузя',
                        'как же ты сочно отлетел / с луасенсом играешь что ли?',
                        '1 / только попробуй оправдаться / убогое чмо',
                        'тебя только что суйдус обоссал / твои действия?',
                        'S[[DF[F[FS[SDF[DS[FSD[FDS[F[F[F[F / stupid skeetless',
                        '1 / надеюсь теперь ты познал что такое пенить',
                        '1 / sleep dog',
                        '1 / ahahahahahahahah',
                        'не устал позориться обмудок? / ливни уже нахуй',
                        'ммм наивный / 1 хуесос',
                        'че ты там чавкаешь пиздой / сиди молча',
                        'четко в жбан / прямо как в твою мать из дробовика',
                        'БАМ',
                        'L / sit nN',
                        'u think im lucky?? / just bloom.tool',
                        'добрый вечер',
                        'нормас я тебя шлёпнул / сразу видно чувачела с асидом / только эту хуйню тапнуть можно',
                        'соси уебанец / не чувствую тебя абсолютно',
                        '1 / лови по шляпе'
                    },
                    ['body'] = {
                        'я твоей маме тараканов в жопу пихал / животное ебаное',
                        --'ХА ЧМО ЗАЦЕНИ АЙДИШНИК / market.neverlose.cc/xo-yaw',
                        'u mad? / i just broke lagcomp',
                        'я не прожимал боди / у меня чит прекрасный',
                        'FEEL THE BLOOMTOOL / чмо ебаное',
                        'как же я тебя обоссал / немощ ссаный',
                        '? / what you do dog?',
                        'нищая хуйня / куда ты поползла',
                        'скули чмо в хуй папе',
                        'ммм наивный / 1 хуесос',
                        'ты читаешься как книга / слишком хуевый для меня',
                        'ебучая калека / в следующий раз будешь умнее',
                        'сын говна / снова совершил ошибку',
                        'че шнырь ебаный / ниче не перепутал?',
                        'и что ты сейчас сделал / ты серьезно надеелся что ты сможешь меня убить?'
                    },
                    ['taser'] = {
                        'сгорел пидорас ебаный',
                        'ммм наивный / 1 хуесос',
                        'шлюха на зевсе',
                        'a12 / f12',
                        'yt bot'
                    },
                    ['inferno'] = {
                        'сгорел пидорас ебаный',
                        'че смок тяжело кинуть долбаеб?',
                        'гори в аду',
                        'нихуя я тебя зажарил ублюдка',
                        'F]DFDSFSD]F[DSFSDFS] / FIRE IN THE HELL'
                    },
                    ['hegrenade'] = {
                        'взорван хуйсос',
                        'allah akbar хуйсос',
                        'лети обратно к матери / ебанат'
                    },
                    ['death'] = {
                        'что ты сделал / безмозглый',
                        'не повезло',
                        'ну фу / что ты делаешь',
                        'only luck in this game',
                        'хуя меня пингануло жоско',
                        'НЕТ / ОНО ЖЕ ПЕРЕПИКАЕТ',
                        'чмо ебаное / 5х5 на 2к евро слетаем ссаный мусор?',
                        'ну отлично / опять в дез мисснул',
                        'сервер копеечный / ну зато у пидораса тут стреляет',
                        'F][SD[]FSD][FD[]FSD[]] / хуесосу опять повезло',
                        'фу / ублюдок что ты сделал в очередной раз',
                        'ебаный сочник / ну ниче в следующем раунде в письку дунешь',
                        'так держать / сын шлюхи ебаный',
                        'на подпике / иди нахуй'
                    },
                    ['revenge'] = {
                        '1.'
                    }
                }
                local active = false

                local attacker_index = -1

                function miscellaneous.trashtalk.run(type)
                    if not config.miscellaneous.trashtalk:get() then
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
                    local active_pool = c_string.split(phrase, ' / ')

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
                    if not config.miscellaneous.trashtalk:get() then
                        return
                    end

                    if list[event.weapon] then
                        self.run(event.weapon)
                    else
                        self.run(event.headshot and 'head' or 'body')
                    end
                end

                function miscellaneous.trashtalk:on_death(event)
                    self.run('death')
                end

                function miscellaneous.trashtalk:on_player_death(event)
                    if event.userid == attacker_index then
                        self.run('revenge')
                        attacker_index = -1
                    end
                end
            end

            miscellaneous.custom_output = {} do
                local list = {}

                miscellaneous.custom_output.paint_ui = (function (ctx)
                    if #list == 0 then
                        return
                    end

                    local hs = select(2, surface.get_text_size(c_constant.fonts.lucida , 'A'))
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

                            local this_w = surface.get_text_size(c_constant.fonts.lucida, obj.text)

                            surface.draw_text(x + w_o, y, obj.color.r, obj.color.g, obj.color.b, ncolor.a, c_constant.fonts.lucida, obj.text)

                            w_o = w_o + this_w
                        end

                        y = y + size
                    end
                end)

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
                        options[#options+1] = string.format('bt: %d tick%s (%i ms)', backtrack, c_math.abs(backtrack) == 1 and '' or 's', c_math.round(backtrack*globals.tickinterval()*1000))
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

                    if config.miscellaneous.event_logger:get() then
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
                        options[#options+1] = string.format('bt: %d tick%s (%i ms)', backtrack, c_math.abs(backtrack) == 1 and '' or 's', c_math.round(backtrack*globals.tickinterval()*1000))
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

                    if config.miscellaneous.event_logger:get() then
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

                    if config.miscellaneous.event_logger:get() then
                        print(logger_text)
                    end
                end
            end

            function miscellaneous:setup_command(cmd, me, wpn)
                local cheat_tweaks = config.miscellaneous.cheat_tweaks:get()
                local tweak_list = config.miscellaneous.cheat_tweaks_list:get()

                if cheat_tweaks and c_table.contains(tweak_list, 'Uncharge helper') or player.air_exploit then
                    self.tweaks.dt_reset = true

                    if not self.tweaks.uncharge_helper(me, wpn) then
                        override.set(reference.ragebot.enabled[2], "Always on")
                    end
                elseif self.tweaks.dt_reset then
                    override.unset(reference.ragebot.enabled[2])
                    self.tweaks.dt_reset = false
                end

                if cheat_tweaks and c_table.contains(tweak_list, 'Allow crouch on fakeduck') then
                    self.tweaks.fakeduck_helper(cmd)
                else
                    if self.tweaks.fd_reset then
                        override.unset(reference.ragebot.fakeduck)
                        self.tweaks.fd_reset = false
                    end
                end

                if not player.air_exploit and not cheat_tweaks then
                    if self.tweaks.fd_reset then
                        override.unset(reference.ragebot.fakeduck)
                        self.tweaks.fd_reset = false
                    end
                end

                if not cheat_tweaks then
                    if self.tweaks.dt_reset then
                        override.unset(reference.ragebot.doubletap.enable)
                        self.tweaks.dt_reset = false
                    end
                end

                if config.miscellaneous.automatic_tp:get() then
                    if not self.automatic_tp.run(me, wpn) and self.automatic_tp.reset then
                        override.unset(reference.ragebot.doubletap.enable.hotkey)
                        self.automatic_tp.reset = false
                    end
                elseif self.automatic_tp.reset then
                    override.unset(reference.ragebot.doubletap.enable.hotkey)
                    self.automatic_tp.reset = false
                end
            end

            function miscellaneous:aim_fire(event)
                self.event_logger.aim_fire(event)
            end

            function miscellaneous:aim_hit(event)
                self.event_logger.aim_hit(event)
            end

            function miscellaneous:aim_miss(event)
                self.event_logger.aim_miss(event)
            end

            function miscellaneous:player_death(event)
                local attacker = client.userid_to_entindex(event.attacker)
                local userid = client.userid_to_entindex(event.userid)

                if not attacker or not userid then
                    return
                end

                if attacker == player.entindex then
                    if userid ~= player.entindex then
                        self.trashtalk:on_kill(event)
                    end
                elseif userid == player.entindex then
                    self.trashtalk:on_death(event)
                else
                    self.trashtalk:on_player_death(event)
                end
            end

            function miscellaneous:player_hurt(event)
                self.event_logger.player_hurt(event)
            end

            function miscellaneous:net_update_end()
                self.clantag:run()
            end

            function miscellaneous:paint_ui()
                local tweaks = config.miscellaneous.cheat_tweaks:get()
                local tweak_list = config.miscellaneous.cheat_tweaks_list:get()

                if tweaks and c_table.contains(tweak_list, 'Super toss on grenade release') then
                    self.tweaks.super_toss()
                elseif miscellaneous.tweaks.st_reset then
                    override.unset(reference.misc.grenade_toss)
                    miscellaneous.tweaks.st_reset = false
                end

                --- ЭХХХ костыль на костыле
                do
                    if not player.valid then
                        if tweaks and c_table.contains(tweak_list, 'Uncharge helper') then
                            self.tweaks.dt_reset = true
                            override.set(reference.ragebot.enabled[2], "Always on")
                        elseif self.tweaks.dt_reset then
                            override.unset(reference.ragebot.enabled[2])
                            self.tweaks.dt_reset = false
                        end
                    end
                end

                self.custom_output.paint_ui()
            end

            function miscellaneous.output_raw(output)
                miscellaneous.custom_output.output(output)
            end

            config.miscellaneous.custom_output:set_callback(function (element)
                local enabled = ui.get(element)

                if enabled and not miscellaneous._output_set then
                    client.set_event_callback('output', miscellaneous.output_raw)

                    miscellaneous._output_set = true
                elseif not enabled and miscellaneous._output_set then
                    client.unset_event_callback('output', miscellaneous.output_raw)

                    miscellaneous._output_set = false
                end

                if enabled then
                    override.set(reference.misc.draw_output, false)
                else
                    override.unset(reference.misc.draw_output)
                end
            end, true)

            config.miscellaneous.console_filter:set_callback(function (element)
                local enabled = ui.get(element)

                if enabled then
                    client.exec('con_filter_enable 1;con_filter_text "\a";')
                else
                    client.exec('con_filter_enable 0;con_filter_text "";')
                end
            end, true)
        end
    end

    ---
    --- Settings
    ---
    local settings do
        config.settings = {} do
            config.settings.import = menu.new_item(ui.new_button, "AA", "Anti-aimbot angles", "Configuration: Import", function () end)
                :config_ignore()
            config.settings.export = menu.new_item(ui.new_button, "AA", "Anti-aimbot angles", "Configuration: Export", function () end)
                :config_ignore()
            config.settings.builtin = menu.new_item(ui.new_button, "AA", "Anti-aimbot angles", "Configuration: Builtin", function () end)
                :config_ignore()
        end

        settings = {} do
            function settings.import()
                local success, err = config_system.import_from_str(clipboard.get())

                if not success then
                    return c_logger.log_error('Failed to load config due to [%s]', err)
                end

                c_logger.log('Config loaded.')
            end

            function settings.export()
                local config_text = config_system.export_to_str()

                clipboard.set(config_text)
                c_logger.log('Config exported.')
            end

            function settings.builtin()
                local success, err = config_system.import_from_str("eyJidWlsZGVyIjp7IkFBOjpTdGFuZGluZzo6Sml0dGVyVmFsdWUiOlswXSwiQUE6OlN0YW5kaW5nOjpZYXdCYXNlIjpbIkxvY2FsIHZpZXciXSwiQUE6OkFpciAmIENyb3VjaDo6WWF3U3dpdGNoRGVsYXlTZWNvbmQiOls2XSwiQUE6OkFpciAmIENyb3VjaDo6UGl0Y2hDdXN0b20iOlswXSwiQUE6Ok1vdmluZzo6UGl0Y2giOlsiT2ZmIl0sIkFBOjpGYWtlIGxhZzo6WWF3QmFzZSI6WyJMb2NhbCB2aWV3Il0sIkFBOjpDcm91Y2hpbmc6OkppdHRlclJhbmRvbWl6ZSI6WzBdLCJBQTo6U2xvdy1tb3Rpb246Ollhd0RlbGF5ZWRTd2l0Y2giOltmYWxzZV0sIkFBOjpBaXI6Ollhd0Jhc2UiOlsiTG9jYWwgdmlldyJdLCJBQTo6RmFrZSBsYWc6OkJvZHlWYWx1ZSI6WzBdLCJBQTo6U3RhbmRpbmc6OkVuYWJsZWQiOltmYWxzZV0sIkFBOjpGYWtlIGxhZzo6WWF3Sml0dGVyIjpbIk9mZiJdLCJBQTo6QWlyOjpZYXdTcGVlZCI6WzVdLCJBQTo6U3RhbmRpbmc6Ollhd1JpZ2h0IjpbMF0sIkFBOjpHbG9iYWw6Ollhd0N1c3RvbSI6WzBdLCJBQTo6U3RhbmRpbmc6OlBpdGNoIjpbIk9mZiJdLCJBQTo6U3RhbmRpbmc6Ollhd0RlbGF5ZWRTd2l0Y2giOltmYWxzZV0sIkFBOjpHbG9iYWw6Ollhd1N3aXRjaERlbGF5U2Vjb25kIjpbNl0sIkFBOjpDcm91Y2hpbmc6Ollhd0xlZnQiOlswXSwiQUE6OkNyb3VjaGluZzo6WWF3VHlwZSI6WyJPZmYiXSwiQUE6OkNyb3VjaCBtb3Zpbmc6OkppdHRlclZhbHVlIjpbMF0sIkFBOjpGYWtlIGxhZzo6Sml0dGVyVmFsdWUiOlswXSwiQUE6Ok1vdmluZzo6Qm9keVlhdyI6WyJPZmYiXSwiQUE6OkNyb3VjaCBtb3Zpbmc6Ollhd1NwZWVkIjpbNV0sIkFBOjpBaXI6Ollhd0RlbGF5ZWRTd2l0Y2giOltmYWxzZV0sIkFBOjpDcm91Y2ggbW92aW5nOjpCb2R5WWF3IjpbIk9mZiJdLCJBQTo6R2xvYmFsOjpZYXdKaXR0ZXIiOlsiT2ZmIl0sIkFBOjpBaXI6Ollhd0RlbGF5IjpbNV0sIkFBOjpDcm91Y2hpbmc6OkVuYWJsZWQiOltmYWxzZV0sIkFBOjpNb3Zpbmc6Ollhd0N1c3RvbSI6WzBdLCJBQTo6RmFrZSBsYWc6OlBpdGNoIjpbIk9mZiJdLCJBQTo6U3RhbmRpbmc6OkJvZHlZYXciOlsiT2ZmIl0sIkFBOjpGYWtlIGxhZzo6WWF3TGVmdCI6WzBdLCJBQTo6U2xvdy1tb3Rpb246Ollhd0N1c3RvbSI6WzBdLCJBQTo6RmFrZSBsYWc6Ollhd1JpZ2h0IjpbMF0sIkFBOjpBaXIgJiBDcm91Y2g6Ollhd1R5cGUiOlsiT2ZmIl0sIkFBOjpBaXI6OlBpdGNoQ3VzdG9tIjpbMF0sIkFBOjpDcm91Y2ggbW92aW5nOjpZYXdMZWZ0IjpbMF0sIkFBOjpDcm91Y2ggbW92aW5nOjpZYXdTd2l0Y2hEZWxheVNlY29uZCI6WzZdLCJBQTo6TW92aW5nOjpZYXdSaWdodCI6WzBdLCJBQTo6TW92aW5nOjpKaXR0ZXJWYWx1ZSI6WzBdLCJBQTo6QWlyOjpCb2R5WWF3IjpbIk9mZiJdLCJBQTo6U2xvdy1tb3Rpb246Ollhd0xlZnQiOlswXSwiQUE6OlNsb3ctbW90aW9uOjpZYXdEZWxheSI6WzVdLCJBQTo6QWlyOjpZYXdUeXBlIjpbIk9mZiJdLCJBQTo6U3RhbmRpbmc6Ollhd0ppdHRlciI6WyJPZmYiXSwiQUE6OlN0YW5kaW5nOjpZYXdEZWxheSI6WzVdLCJBQTo6QWlyOjpKaXR0ZXJWYWx1ZSI6WzBdLCJBQTo6QWlyICYgQ3JvdWNoOjpZYXdTcGVlZCI6WzVdLCJBQTo6QWlyOjpFbmFibGVkIjpbZmFsc2VdLCJBQTo6RmFrZSBsYWc6OkVuYWJsZWQiOltmYWxzZV0sIkFBOjpTdGFuZGluZzo6WWF3U3dpdGNoRGVsYXkiOls2XSwiQUE6OkZha2UgbGFnOjpCb2R5WWF3IjpbIk9mZiJdLCJBQTo6Q3JvdWNoaW5nOjpQaXRjaCI6WyJPZmYiXSwiQUE6OkNyb3VjaGluZzo6WWF3U3dpdGNoRGVsYXkiOls2XSwiQUE6OkFpciAmIENyb3VjaDo6Sml0dGVyUmFuZG9taXplIjpbMF0sIkFBOjpNb3Zpbmc6Ollhd1N3aXRjaERlbGF5IjpbNl0sIkFBOjpHbG9iYWw6Ollhd1N3aXRjaERlbGF5IjpbNl0sIkFBOjpDcm91Y2ggbW92aW5nOjpKaXR0ZXJSYW5kb21pemUiOlswXSwiQUE6OkNyb3VjaGluZzo6WWF3RGVsYXkiOls1XSwiQUE6OkNyb3VjaGluZzo6UGl0Y2hDdXN0b20iOlswXSwiQUE6OkNyb3VjaCBtb3Zpbmc6OlBpdGNoIjpbIk9mZiJdLCJBQTo6U2xvdy1tb3Rpb246Ollhd1NwZWVkIjpbNV0sIkFBOjpBaXIgJiBDcm91Y2g6Ollhd0N1c3RvbSI6WzBdLCJBQTo6U3RhbmRpbmc6Ollhd0xlZnQiOlswXSwiQUE6OlN0YW5kaW5nOjpCb2R5VmFsdWUiOlswXSwiQUE6Okdsb2JhbDo6Qm9keVZhbHVlIjpbMF0sIkFBOjpDcm91Y2hpbmc6Ollhd0Jhc2UiOlsiTG9jYWwgdmlldyJdLCJBQTo6U2xvdy1tb3Rpb246Ollhd0Jhc2UiOlsiTG9jYWwgdmlldyJdLCJBQTo6RmFrZSBsYWc6Ollhd0RlbGF5ZWRTd2l0Y2giOltmYWxzZV0sIkFBOjpTbG93LW1vdGlvbjo6Sml0dGVyVmFsdWUiOlswXSwiQUE6OkZha2UgbGFnOjpQaXRjaEN1c3RvbSI6WzBdLCJBQTo6Q3JvdWNoIG1vdmluZzo6WWF3UmlnaHQiOlswXSwiQUE6OkZha2UgbGFnOjpZYXdTd2l0Y2hEZWxheSI6WzZdLCJBQTo6RmFrZSBsYWc6Ollhd1R5cGUiOlsiT2ZmIl0sIkFBOjpDcm91Y2ggbW92aW5nOjpZYXdDdXN0b20iOlswXSwiQUE6OkFpciAmIENyb3VjaDo6Qm9keVZhbHVlIjpbMF0sIkFBOjpHbG9iYWw6OlBpdGNoIjpbIk9mZiJdLCJBQTo6QWlyICYgQ3JvdWNoOjpZYXdTd2l0Y2hEZWxheSI6WzZdLCJBQTo6R2xvYmFsOjpCb2R5WWF3IjpbIk9mZiJdLCJBQTo6TW92aW5nOjpZYXdEZWxheSI6WzVdLCJBQTo6Q3JvdWNoaW5nOjpCb2R5VmFsdWUiOlswXSwiQUE6OkNyb3VjaCBtb3Zpbmc6Ollhd0Jhc2UiOlsiTG9jYWwgdmlldyJdLCJBQTo6Q3JvdWNoIG1vdmluZzo6WWF3VHlwZSI6WyJPZmYiXSwiQUE6OlNsb3ctbW90aW9uOjpQaXRjaEN1c3RvbSI6WzBdLCJBQTo6U2xvdy1tb3Rpb246Ollhd1N3aXRjaERlbGF5U2Vjb25kIjpbNl0sIkFBOjpDcm91Y2ggbW92aW5nOjpZYXdEZWxheSI6WzVdLCJBQTo6Q3JvdWNoIG1vdmluZzo6WWF3U3dpdGNoRGVsYXkiOls2XSwiQUE6OkFpcjo6Sml0dGVyUmFuZG9taXplIjpbMF0sIkFBOjpBaXI6Ollhd1N3aXRjaERlbGF5U2Vjb25kIjpbNl0sIkFBOjpNb3Zpbmc6Ollhd0Jhc2UiOlsiTG9jYWwgdmlldyJdLCJBQTo6R2xvYmFsOjpQaXRjaEN1c3RvbSI6WzBdLCJBQTo6RmFrZSBsYWc6OkppdHRlclJhbmRvbWl6ZSI6WzBdLCJBQTo6Q3JvdWNoIG1vdmluZzo6Qm9keVZhbHVlIjpbMF0sIkFBOjpTbG93LW1vdGlvbjo6UGl0Y2giOlsiT2ZmIl0sIkFBOjpDcm91Y2hpbmc6Ollhd0N1c3RvbSI6WzBdLCJBQTo6U2xvdy1tb3Rpb246OkppdHRlclJhbmRvbWl6ZSI6WzBdLCJBQTo6R2xvYmFsOjpZYXdSaWdodCI6WzBdLCJBQTo6Q3JvdWNoaW5nOjpZYXdTcGVlZCI6WzVdLCJBQTo6TW92aW5nOjpFbmFibGVkIjpbZmFsc2VdLCJBQTo6U3RhbmRpbmc6Ollhd1NwZWVkIjpbNV0sIkFBOjpDcm91Y2hpbmc6OkppdHRlclZhbHVlIjpbMF0sIkFBOjpDcm91Y2ggbW92aW5nOjpZYXdKaXR0ZXIiOlsiT2ZmIl0sIkFBOjpBaXI6Ollhd0xlZnQiOlswXSwiQUE6OkFpciAmIENyb3VjaDo6WWF3RGVsYXkiOls1XSwiQUE6Okdsb2JhbDo6WWF3TGVmdCI6WzBdLCJBQTo6U3RhbmRpbmc6OkppdHRlclJhbmRvbWl6ZSI6WzBdLCJBQTo6U2xvdy1tb3Rpb246Ollhd0ppdHRlciI6WyJPZmYiXSwiQUE6Ok1vdmluZzo6WWF3U3BlZWQiOls1XSwiQUE6Okdsb2JhbDo6WWF3VHlwZSI6WyJPZmYiXSwiQUE6OkFpciAmIENyb3VjaDo6WWF3Sml0dGVyIjpbIk9mZiJdLCJBQTo6TW92aW5nOjpQaXRjaEN1c3RvbSI6WzBdLCJBQTo6U2xvdy1tb3Rpb246OkVuYWJsZWQiOltmYWxzZV0sIkFBOjpDcm91Y2hpbmc6Ollhd1N3aXRjaERlbGF5U2Vjb25kIjpbNl0sIkFBOjpGYWtlIGxhZzo6WWF3RGVsYXkiOls1XSwiQUE6Ok1vdmluZzo6WWF3TGVmdCI6WzBdLCJBQTo6Q3JvdWNoIG1vdmluZzo6RW5hYmxlZCI6W2ZhbHNlXSwiQUE6OkFpcjo6WWF3UmlnaHQiOlswXSwiQUE6OlNsb3ctbW90aW9uOjpCb2R5WWF3IjpbIk9mZiJdLCJBQTo6QWlyOjpQaXRjaCI6WyJPZmYiXSwiQUE6Ok1vdmluZzo6WWF3VHlwZSI6WyJPZmYiXSwiQUE6OlNsb3ctbW90aW9uOjpCb2R5VmFsdWUiOlswXSwiQUE6Ok1vdmluZzo6Qm9keVZhbHVlIjpbMF0sIkFBOjpTdGFuZGluZzo6WWF3U3dpdGNoRGVsYXlTZWNvbmQiOls2XSwiQUE6Ok1vdmluZzo6WWF3RGVsYXllZFN3aXRjaCI6W2ZhbHNlXSwiQUE6OkZha2UgbGFnOjpZYXdDdXN0b20iOlswXSwiQUE6Okdsb2JhbDo6WWF3RGVsYXllZFN3aXRjaCI6W2ZhbHNlXSwiQUE6OkZha2UgbGFnOjpZYXdTd2l0Y2hEZWxheVNlY29uZCI6WzZdLCJBQTo6QWlyICYgQ3JvdWNoOjpZYXdCYXNlIjpbIkxvY2FsIHZpZXciXSwiQUE6Ok1vdmluZzo6WWF3U3dpdGNoRGVsYXlTZWNvbmQiOls2XSwiQUE6OlN0YW5kaW5nOjpZYXdDdXN0b20iOlswXSwiQUE6OlN0YW5kaW5nOjpZYXdUeXBlIjpbIk9mZiJdLCJBQTo6U2xvdy1tb3Rpb246Ollhd1JpZ2h0IjpbMF0sIkFBOjpDcm91Y2hpbmc6Ollhd1JpZ2h0IjpbMF0sIkFBOjpHbG9iYWw6OkppdHRlclZhbHVlIjpbMF0sIkFBOjpTdGFuZGluZzo6UGl0Y2hDdXN0b20iOlswXSwiQUE6Ok1vdmluZzo6WWF3Sml0dGVyIjpbIk9mZiJdLCJBQTo6R2xvYmFsOjpZYXdCYXNlIjpbIkxvY2FsIHZpZXciXSwiQUE6OkNyb3VjaGluZzo6WWF3RGVsYXllZFN3aXRjaCI6W2ZhbHNlXSwiQUE6OlNsb3ctbW90aW9uOjpZYXdUeXBlIjpbIk9mZiJdLCJBQTo6QWlyICYgQ3JvdWNoOjpFbmFibGVkIjpbZmFsc2VdLCJBQTo6Q3JvdWNoIG1vdmluZzo6WWF3RGVsYXllZFN3aXRjaCI6W2ZhbHNlXSwiQUE6Okdsb2JhbDo6WWF3U3BlZWQiOls1XSwiQUE6OkFpciAmIENyb3VjaDo6WWF3RGVsYXllZFN3aXRjaCI6W2ZhbHNlXSwiQUE6OkFpciAmIENyb3VjaDo6Qm9keVlhdyI6WyJPZmYiXSwiQUE6Okdsb2JhbDo6WWF3RGVsYXkiOls1XSwiQUE6OkFpciAmIENyb3VjaDo6Sml0dGVyVmFsdWUiOlswXSwiQUE6Ok1vdmluZzo6Sml0dGVyUmFuZG9taXplIjpbMF0sIkFBOjpDcm91Y2ggbW92aW5nOjpQaXRjaEN1c3RvbSI6WzBdLCJBQTo6QWlyICYgQ3JvdWNoOjpQaXRjaCI6WyJPZmYiXSwiQUE6OkFpcjo6WWF3Sml0dGVyIjpbIk9mZiJdLCJBQTo6Q3JvdWNoaW5nOjpCb2R5WWF3IjpbIk9mZiJdLCJBQTo6QWlyOjpZYXdTd2l0Y2hEZWxheSI6WzZdLCJBQTo6QWlyICYgQ3JvdWNoOjpZYXdMZWZ0IjpbMF0sIkFBOjpBaXI6Ollhd0N1c3RvbSI6WzBdLCJBQTo6Q3JvdWNoaW5nOjpZYXdKaXR0ZXIiOlsiT2ZmIl0sIkFBOjpBaXI6OkJvZHlWYWx1ZSI6WzBdLCJBQTo6RmFrZSBsYWc6Ollhd1NwZWVkIjpbNV0sIkFBOjpHbG9iYWw6OkppdHRlclJhbmRvbWl6ZSI6WzBdLCJBQTo6U2xvdy1tb3Rpb246Ollhd1N3aXRjaERlbGF5IjpbNl0sIkFBOjpBaXIgJiBDcm91Y2g6Ollhd1JpZ2h0IjpbMF19LCJ2aXN1YWxzIjp7ImluZGljYXRvcl92ZXJ0aWNhbF9vZmZzZXQiOlsyMF0sIm1hbnVhbF9hcnJvd3NfYWNjZW50IjpbMjU1LDAsMCwyNTVdLCJkYW1hZ2VfbWFya2VyIjpbdHJ1ZV0sImluZGljYXRvcnMiOlt0cnVlXSwicjhfaW5kaWNhdG9yX2NvbG9yIjpbMjU1LDAsMCwyNTVdLCJpbmRpY2F0b3Jfb3B0aW9ucyI6W1siVmVsb2NpdHkgbW9kaWZpZXIiLCJBZGp1c3Qgd2hpbGUgc2NvcGVkIiwiQWx0ZXIgYWxwaGEgd2hpbGUgc2NvcGVkIiwiQWx0ZXIgYWxwaGEgb24gZ3JlbmFkZSJdXSwiaW5kaWNhdG9yX2NvbG9yIjpbMjU1LDI1NSwyNTUsMjU1XSwicjhfaW5kaWNhdG9yIjpbZmFsc2VdLCJtYW51YWxfYXJyb3dzX29wdGlvbnMiOlt7fV0sIm1hbnVhbF9hcnJvd3Nfc2l6ZSI6WzEwXSwiaW5kaWNhdG9yX3N0eWxlIjpbIlJlbmV3ZWQiXSwibWFudWFsX2Fycm93c19vZmZzZXQiOlszNV0sIm1hbnVhbF9hcnJvd3NfY29sb3IiOls3Nyw3Nyw3NywyNTVdLCJtYW51YWxfYXJyb3dzIjpbZmFsc2VdLCJtYW51YWxfYXJyb3dzX3N0eWxlIjpbIlRyaWFuZ2xlcyJdLCJkYW1hZ2VfbWFya2VyX2NvbG9yIjpbMjU1LDAsMCwyNTVdLCJpbmRpY2F0b3JfcmVuZXdlZF9jb2xvciI6WzEzNywxMzcsMTM3LDI1NV19LCJhbnRpYWltYm90Ijp7ImRlZmVuc2l2ZV9jb25kaXRpb25zX2F1dG8iOltbIk9uIHBlZWsiLCJMZWdpdCBBQSIsIkVkZ2UgZGlyZWN0aW9uIiwiU2FmZSBoZWFkIiwiVHJpZ2dlcmVkIiwiU3RhbmRpbmciLCJTbG93LW1vdGlvbiIsIk1vdmluZyIsIkNyb3VjaGluZyIsIkNyb3VjaCBtb3ZpbmciLCJBaXIiLCJBaXIgJiBDcm91Y2giXV0sImlkZWFsX3RpY2siOltmYWxzZV0sIm1hbnVhbF95YXciOlt0cnVlXSwiYW5pbWF0aW9uX2JyZWFrZXJfYWlyIjpbIldhbGtpbmciXSwic2FmZV9oZWFkX2NvbmRpdGlvbnMiOltbIkFpciBrbmlmZSIsIkFpciB6ZXVzIiwiQWlyICYgQ3JvdWNoIiwiQ3JvdWNoIG1vdmluZyIsIkNyb3VjaGluZyIsIlNsb3ctbW90aW9uIiwiU3RhbmRpbmciXV0sInNhZmVfaGVhZCI6W3RydWVdLCJvcHRpb25zIjpbWyJPbiB1c2UgYW50aWFpbSIsIkZhc3QgbGFkZGVyIiwiRG9ybWFudCBwcmVzZXQiXV0sIndhcm11cF9hYV9jb25kaXRpb25zIjpbWyJXYXJtdXAiLCJSb3VuZCBlbmQiXV0sImFuaW1hdGlvbl9icmVha2VyX2xlZyI6WyJXYWxraW5nIl0sIm1hbnVhbF9vcHRpb25zIjpbWyJKaXR0ZXIgZGlzYWJsZWQiXV0sImZyZWVzdGFuZGluZ19kaXNhYmxlcl9zdGF0ZXMiOltbIkFpciIsIkFpciAmIENyb3VjaCJdXSwid2FybXVwX2FhIjpbdHJ1ZV0sImFuaW1hdGlvbl9icmVha2VyX290aGVyIjpbWyJRdWljayBwZWVrIGxlZ3MiLCJQaXRjaCB6ZXJvIG9uIGxhbmQiXV0sImFuaW1hdGlvbl9icmVha2VyIjpbdHJ1ZV0sImRlZmVuc2l2ZV9hYSI6W3RydWVdLCJhaXJfZXhwbG9pdCI6W2ZhbHNlXSwiZGVmZW5zaXZlX2NvbmRpdGlvbnMiOltbIkNyb3VjaGluZyIsIkNyb3VjaCBtb3ZpbmciLCJBaXIiLCJBaXIgJiBDcm91Y2giXV0sImlkZWFsX3RpY2tfaG90a2V5IjpbIk9uIGhvdGtleSJdLCJwcmVzZXQiOlsiQmxvc3NvbSJdLCJkZWZlbnNpdmVfdGFyZ2V0IjpbWyJEb3VibGUgdGFwIl1dLCJhaXJfZXhwbG9pdF9ob3RrZXkiOlsiT24gaG90a2V5Il0sImZzX29wdGlvbnMiOltbIkppdHRlciBkaXNhYmxlZCJdXSwiZGVmZW5zaXZlX3ByZXNldCI6WyJBdXRvIl0sImRlZmVuc2l2ZV90cmlnZ2VycyI6W1siRmxhc2hlZCIsIkRhbWFnZSByZWNlaXZlZCIsIlJlbG9hZGluZyIsIldlYXBvbiBzd2l0Y2giXV0sImZvcmNlX3RhcmdldF95YXciOlt0cnVlXX0sIm1pc2NlbGxhbmVvdXMiOnsiY2hlYXRfdHdlYWtzX2xpc3QiOltbIlVuY2hhcmdlIGhlbHBlciIsIlN1cGVyIHRvc3Mgb24gZ3JlbmFkZSByZWxlYXNlIiwiQWxsb3cgY3JvdWNoIG9uIGZha2VkdWNrIl1dLCJhdXRvbWF0aWNfdHAiOlt7fV0sImNsYW50YWciOltmYWxzZV0sInRyYXNodGFsayI6W2ZhbHNlXSwiY29uc29sZV9maWx0ZXIiOlt0cnVlXSwiYXV0b21hdGljX3RwX2RlbGF5IjpbMl0sImN1c3RvbV9vdXRwdXQiOlt0cnVlXSwiZXZlbnRfbG9nZ2VyIjpbdHJ1ZV0sImNoZWF0X3R3ZWFrcyI6W3RydWVdfSwiZGVmZW5zaXZlIjp7IkRFRjo6QWlyOjpQaXRjaCI6WyJEZWZhdWx0Il0sIkRFRjo6T24gcGVlazo6UGl0Y2giOlsiRGVmYXVsdCJdLCJERUY6Ok9uIHBlZWs6Ollhd1JhbmRvbWl6ZSI6WzBdLCJERUY6OkNyb3VjaCBtb3Zpbmc6Ollhd0xlZnRTdGFydCI6WzBdLCJERUY6OlNsb3ctbW90aW9uOjpQaXRjaCI6WyJEZWZhdWx0Il0sIkRFRjo6R2xvYmFsOjpZYXdTcGVlZCI6WzFdLCJERUY6Okdsb2JhbDo6WWF3UmFuZG9taXplIjpbMF0sIkRFRjo6TW92aW5nOjpQaXRjaCI6WyJEZWZhdWx0Il0sIkRFRjo6TGVnaXQgQUE6OlBpdGNoQ3VzdG9tIjpbODldLCJERUY6OlN0YW5kaW5nOjpZYXdSYW5kb21pemUiOlswXSwiREVGOjpDcm91Y2hpbmc6Ollhd0RlbGF5IjpbNl0sIkRFRjo6U2xvdy1tb3Rpb246Ollhd1NwZWVkIjpbMV0sIkRFRjo6R2xvYmFsOjpQaXRjaCI6WyJEZWZhdWx0Il0sIkRFRjo6RWRnZSBkaXJlY3Rpb246OkVuYWJsZWQiOltmYWxzZV0sIkRFRjo6TW92aW5nOjpZYXdMZWZ0IjpbMF0sIkRFRjo6TW92aW5nOjpZYXdUbyI6WzBdLCJERUY6OkFpciAmIENyb3VjaDo6WWF3TGVmdFRhcmdldCI6WzBdLCJERUY6OkxlZ2l0IEFBOjpQaXRjaCI6WyJEZWZhdWx0Il0sIkRFRjo6Q3JvdWNoaW5nOjpQaXRjaCI6WyJEZWZhdWx0Il0sIkRFRjo6Q3JvdWNoaW5nOjpZYXdUbyI6WzBdLCJERUY6OlNsb3ctbW90aW9uOjpZYXdSaWdodFRhcmdldCI6WzBdLCJERUY6OkNyb3VjaGluZzo6WWF3IjpbIkRlZmF1bHQiXSwiREVGOjpTbG93LW1vdGlvbjo6RW5hYmxlZCI6W2ZhbHNlXSwiREVGOjpNb3Zpbmc6Ollhd0xlZnRTdGFydCI6WzBdLCJERUY6Ok9uIHBlZWs6OlBpdGNoQ3VzdG9tIjpbODldLCJERUY6OkFpcjo6UGl0Y2hDdXN0b20iOls4OV0sIkRFRjo6R2xvYmFsOjpZYXdSaWdodFRhcmdldCI6WzBdLCJERUY6OlN0YW5kaW5nOjpQaXRjaCI6WyJEZWZhdWx0Il0sIkRFRjo6U2xvdy1tb3Rpb246Ollhd0xlZnRUYXJnZXQiOlswXSwiREVGOjpBaXI6Ollhd1JhbmRvbWl6ZSI6WzBdLCJERUY6Okdsb2JhbDo6WWF3UmlnaHRTdGFydCI6WzBdLCJERUY6OlN0YW5kaW5nOjpZYXdGcm9tIjpbMF0sIkRFRjo6TW92aW5nOjpZYXdSaWdodFN0YXJ0IjpbMF0sIkRFRjo6TW92aW5nOjpZYXdMZWZ0VGFyZ2V0IjpbMF0sIkRFRjo6QWlyICYgQ3JvdWNoOjpZYXdSaWdodFRhcmdldCI6WzBdLCJERUY6Okdsb2JhbDo6WWF3TGVmdFRhcmdldCI6WzBdLCJERUY6OkFpciAmIENyb3VjaDo6RW5hYmxlZCI6W2ZhbHNlXSwiREVGOjpHbG9iYWw6Ollhd0xlZnQiOlswXSwiREVGOjpDcm91Y2ggbW92aW5nOjpQaXRjaEN1c3RvbSI6Wzg5XSwiREVGOjpBaXIgJiBDcm91Y2g6Ollhd1JhbmRvbWl6ZSI6WzBdLCJERUY6Okdsb2JhbDo6WWF3UmlnaHQiOlswXSwiREVGOjpNb3Zpbmc6Ollhd0Zyb20iOlswXSwiREVGOjpDcm91Y2ggbW92aW5nOjpZYXdTcGVlZCI6WzFdLCJERUY6OkNyb3VjaGluZzo6WWF3UmlnaHRTdGFydCI6WzBdLCJERUY6OlNsb3ctbW90aW9uOjpZYXdGcm9tIjpbMF0sIkRFRjo6U2FmZSBoZWFkOjpFbmFibGVkIjpbZmFsc2VdLCJERUY6OlRyaWdnZXJlZDo6RW5hYmxlZCI6W2ZhbHNlXSwiREVGOjpMZWdpdCBBQTo6WWF3UmFuZG9taXplIjpbMF0sIkRFRjo6R2xvYmFsOjpQaXRjaEN1c3RvbSI6Wzg5XSwiREVGOjpBaXIgJiBDcm91Y2g6OlBpdGNoQ3VzdG9tIjpbODldLCJERUY6OkxlZ2l0IEFBOjpZYXdTcGVlZCI6WzFdLCJERUY6Ok1vdmluZzo6WWF3UmlnaHQiOlswXSwiREVGOjpBaXIgJiBDcm91Y2g6Ollhd0Zyb20iOlswXSwiREVGOjpNb3Zpbmc6OlBpdGNoQ3VzdG9tIjpbODldLCJERUY6OkFpcjo6WWF3TGVmdFN0YXJ0IjpbMF0sIkRFRjo6Q3JvdWNoIG1vdmluZzo6WWF3UmlnaHQiOlswXSwiREVGOjpNb3Zpbmc6Ollhd0RlbGF5IjpbNl0sIkRFRjo6QWlyICYgQ3JvdWNoOjpZYXciOlsiRGVmYXVsdCJdLCJERUY6OkxlZ2l0IEFBOjpZYXdMZWZ0IjpbMF0sIkRFRjo6R2xvYmFsOjpZYXciOlsiRGVmYXVsdCJdLCJERUY6OlN0YW5kaW5nOjpZYXdMZWZ0IjpbMF0sIkRFRjo6QWlyOjpZYXdSaWdodFN0YXJ0IjpbMF0sIkRFRjo6Q3JvdWNoaW5nOjpZYXdMZWZ0IjpbMF0sIkRFRjo6QWlyOjpFbmFibGVkIjpbZmFsc2VdLCJERUY6OkFpcjo6WWF3UmlnaHRUYXJnZXQiOlswXSwiREVGOjpDcm91Y2hpbmc6Ollhd1JhbmRvbWl6ZSI6WzBdLCJERUY6OlN0YW5kaW5nOjpZYXdSaWdodCI6WzBdLCJERUY6Ok9uIHBlZWs6Ollhd1JpZ2h0IjpbMF0sIkRFRjo6TGVnaXQgQUE6OkVuYWJsZWQiOltmYWxzZV0sIkRFRjo6U2xvdy1tb3Rpb246Ollhd0xlZnRTdGFydCI6WzBdLCJERUY6OkFpciAmIENyb3VjaDo6WWF3VG8iOlswXSwiREVGOjpPbiBwZWVrOjpZYXdMZWZ0VGFyZ2V0IjpbMF0sIkRFRjo6U2xvdy1tb3Rpb246Ollhd1JhbmRvbWl6ZSI6WzBdLCJERUY6Ok9uIHBlZWs6Ollhd1NwZWVkIjpbMV0sIkRFRjo6U3RhbmRpbmc6OkVuYWJsZWQiOltmYWxzZV0sIkRFRjo6U3RhbmRpbmc6OllhdyI6WyJEZWZhdWx0Il0sIkRFRjo6QWlyOjpZYXciOlsiRGVmYXVsdCJdLCJERUY6OkFpciAmIENyb3VjaDo6WWF3RGVsYXkiOls2XSwiREVGOjpMZWdpdCBBQTo6WWF3RnJvbSI6WzBdLCJERUY6OkNyb3VjaCBtb3Zpbmc6Ollhd0RlbGF5IjpbNl0sIkRFRjo6QWlyOjpZYXdGcm9tIjpbMF0sIkRFRjo6U2xvdy1tb3Rpb246OlBpdGNoQ3VzdG9tIjpbODldLCJERUY6OlNsb3ctbW90aW9uOjpZYXdSaWdodFN0YXJ0IjpbMF0sIkRFRjo6Q3JvdWNoaW5nOjpFbmFibGVkIjpbZmFsc2VdLCJERUY6Ok9uIHBlZWs6OllhdyI6WyJEZWZhdWx0Il0sIkRFRjo6U3RhbmRpbmc6Ollhd1JpZ2h0U3RhcnQiOlswXSwiREVGOjpPbiBwZWVrOjpFbmFibGVkIjpbZmFsc2VdLCJERUY6OkxlZ2l0IEFBOjpZYXdEZWxheSI6WzZdLCJERUY6OkFpcjo6WWF3VG8iOlswXSwiREVGOjpTdGFuZGluZzo6WWF3TGVmdFN0YXJ0IjpbMF0sIkRFRjo6Q3JvdWNoIG1vdmluZzo6WWF3UmlnaHRUYXJnZXQiOlswXSwiREVGOjpHbG9iYWw6Ollhd0RlbGF5IjpbNl0sIkRFRjo6Q3JvdWNoIG1vdmluZzo6WWF3IjpbIkRlZmF1bHQiXSwiREVGOjpNb3Zpbmc6OkVuYWJsZWQiOltmYWxzZV0sIkRFRjo6Q3JvdWNoaW5nOjpZYXdSaWdodFRhcmdldCI6WzBdLCJERUY6OkNyb3VjaGluZzo6WWF3U3BlZWQiOlsxXSwiREVGOjpBaXI6Ollhd1NwZWVkIjpbMV0sIkRFRjo6RWRnZSBkaXJlY3Rpb246OlRhcmdldCI6W3t9XSwiREVGOjpNb3Zpbmc6Ollhd1JhbmRvbWl6ZSI6WzBdLCJERUY6OlN0YW5kaW5nOjpQaXRjaEN1c3RvbSI6Wzg5XSwiREVGOjpNb3Zpbmc6Ollhd1NwZWVkIjpbMV0sIkRFRjo6U3RhbmRpbmc6Ollhd0xlZnRUYXJnZXQiOlswXSwiREVGOjpNb3Zpbmc6Ollhd1JpZ2h0VGFyZ2V0IjpbMF0sIkRFRjo6T24gcGVlazo6WWF3TGVmdFN0YXJ0IjpbMF0sIkRFRjo6Q3JvdWNoaW5nOjpZYXdSaWdodCI6WzBdLCJERUY6OkNyb3VjaGluZzo6UGl0Y2hDdXN0b20iOls4OV0sIkRFRjo6QWlyICYgQ3JvdWNoOjpZYXdSaWdodFN0YXJ0IjpbMF0sIkRFRjo6Q3JvdWNoIG1vdmluZzo6UGl0Y2giOlsiRGVmYXVsdCJdLCJERUY6OkxlZ2l0IEFBOjpZYXdUbyI6WzBdLCJERUY6OkxlZ2l0IEFBOjpZYXdSaWdodFRhcmdldCI6WzBdLCJERUY6OlN0YW5kaW5nOjpZYXdSaWdodFRhcmdldCI6WzBdLCJERUY6Okdsb2JhbDo6WWF3RnJvbSI6WzBdLCJERUY6Okdsb2JhbDo6WWF3TGVmdFN0YXJ0IjpbMF0sIkRFRjo6U2xvdy1tb3Rpb246Ollhd0RlbGF5IjpbNl0sIkRFRjo6Q3JvdWNoIG1vdmluZzo6WWF3UmFuZG9taXplIjpbMF0sIkRFRjo6TGVnaXQgQUE6Ollhd0xlZnRUYXJnZXQiOlswXSwiREVGOjpBaXIgJiBDcm91Y2g6Ollhd0xlZnQiOlswXSwiREVGOjpPbiBwZWVrOjpZYXdGcm9tIjpbMF0sIkRFRjo6TGVnaXQgQUE6Ollhd0xlZnRTdGFydCI6WzBdLCJERUY6Ok9uIHBlZWs6Ollhd1RvIjpbMF0sIkRFRjo6Q3JvdWNoaW5nOjpZYXdMZWZ0VGFyZ2V0IjpbMF0sIkRFRjo6Q3JvdWNoIG1vdmluZzo6WWF3VG8iOlswXSwiREVGOjpTbG93LW1vdGlvbjo6WWF3IjpbIkRlZmF1bHQiXSwiREVGOjpDcm91Y2ggbW92aW5nOjpZYXdGcm9tIjpbMF0sIkRFRjo6U2xvdy1tb3Rpb246Ollhd1RvIjpbMF0sIkRFRjo6T24gcGVlazo6WWF3RGVsYXkiOls2XSwiREVGOjpNb3Zpbmc6OllhdyI6WyJEZWZhdWx0Il0sIkRFRjo6U2xvdy1tb3Rpb246Ollhd0xlZnQiOlswXSwiREVGOjpHbG9iYWw6Ollhd1RvIjpbMF0sIkRFRjo6Q3JvdWNoIG1vdmluZzo6WWF3UmlnaHRTdGFydCI6WzBdLCJERUY6OkNyb3VjaGluZzo6WWF3RnJvbSI6WzBdLCJERUY6OkFpciAmIENyb3VjaDo6WWF3U3BlZWQiOlsxXSwiREVGOjpTbG93LW1vdGlvbjo6WWF3UmlnaHQiOlswXSwiREVGOjpDcm91Y2ggbW92aW5nOjpZYXdMZWZ0VGFyZ2V0IjpbMF0sIkRFRjo6T24gcGVlazo6WWF3TGVmdCI6WzBdLCJERUY6OkxlZ2l0IEFBOjpZYXdSaWdodFN0YXJ0IjpbMF0sIkRFRjo6T24gcGVlazo6WWF3UmlnaHRTdGFydCI6WzBdLCJERUY6OkNyb3VjaGluZzo6WWF3TGVmdFN0YXJ0IjpbMF0sIkRFRjo6QWlyICYgQ3JvdWNoOjpZYXdMZWZ0U3RhcnQiOlswXSwiREVGOjpHbG9iYWw6OkVuYWJsZWQiOltmYWxzZV0sIkRFRjo6QWlyOjpZYXdEZWxheSI6WzZdLCJERUY6OkNyb3VjaCBtb3Zpbmc6Ollhd0xlZnQiOlswXSwiREVGOjpBaXIgJiBDcm91Y2g6Ollhd1JpZ2h0IjpbMF0sIkRFRjo6TGVnaXQgQUE6OllhdyI6WyJEZWZhdWx0Il0sIkRFRjo6QWlyOjpZYXdMZWZ0VGFyZ2V0IjpbMF0sIkRFRjo6U3RhbmRpbmc6Ollhd1RvIjpbMF0sIkRFRjo6QWlyOjpZYXdSaWdodCI6WzBdLCJERUY6OkFpcjo6WWF3TGVmdCI6WzBdLCJERUY6OkNyb3VjaCBtb3Zpbmc6OkVuYWJsZWQiOltmYWxzZV0sIkRFRjo6T24gcGVlazo6WWF3UmlnaHRUYXJnZXQiOlswXSwiREVGOjpTdGFuZGluZzo6WWF3U3BlZWQiOlsxXSwiREVGOjpTdGFuZGluZzo6WWF3RGVsYXkiOls2XSwiREVGOjpMZWdpdCBBQTo6WWF3UmlnaHQiOlswXSwiREVGOjpBaXIgJiBDcm91Y2g6OlBpdGNoIjpbIkRlZmF1bHQiXX0sIm1hbnVhbHMiOnsicmlnaHQiOlsiT24gaG90a2V5Il0sImxlZnQiOlsiT24gaG90a2V5Il0sImJhY2t3YXJkIjpbIk9uIGhvdGtleSJdLCJlZGdlIjpbIk9uIGhvdGtleSJdLCJmb3J3YXJkIjpbIk9uIGhvdGtleSJdLCJyZXNldCI6WyJPbiBob3RrZXkiXSwiZnJlZXN0YW5kaW5nIjpbIk9uIGhvdGtleSJdfSwiZmFrZWxhZyI6eyJlbmFibGUiOlt0cnVlXSwidGlja3MiOlsxNF0sInR5cGUiOlsiUmFuZG9taXplIl19fQ==_bloomtool");

                if not success then
                    return c_logger.log_error('Failed to load builtin config due to [%s]', err)
                end

                c_logger.log('Bultin config loaded.')
            end

            config.settings.import:set_callback(settings.import)
            config.settings.export:set_callback(settings.export)
            config.settings.builtin:set_callback(settings.builtin)
        end
    end

    ---
    --- Antiaim presets
    ---
    local antiaim_presets do
        config.presets = {} do
            config.presets.list = menu.new_item(ui.new_listbox, "AA", "Anti-aimbot angles", "Presets: List", {})
                :config_ignore()
            config.presets.name = menu.new_item(ui.new_textbox, "AA", "Anti-aimbot angles", "Preset: Name")
                :config_ignore()

            config.presets.load = menu.new_item(ui.new_button, "AA", "Anti-aimbot angles", "Preset: Load", function () end)
                :config_ignore()
            config.presets.save = menu.new_item(ui.new_button, "AA", "Anti-aimbot angles", "Preset: Save", function () end)
                :config_ignore()
            config.presets.remove = menu.new_item(ui.new_button, "AA", "Anti-aimbot angles", "Preset: Remove", function () end)
                :config_ignore()
            config.presets.import = menu.new_item(ui.new_button, "AA", "Anti-aimbot angles", "Preset: Import", function () end)
                :config_ignore()
            config.presets.export = menu.new_item(ui.new_button, "AA", "Anti-aimbot angles", "Preset: Export", function () end)
                :config_ignore()
        end


        antiaim_presets = {} do
            local database_name = 'bloomtool_presets'
            local list = {}

            local create_preset, Preset do
                Preset = {} do
                    function Preset:load()
                        local success, err = config_system.import_from_str(self.data, "builder", "defensive")

                        if not success then
                            c_logger.log_error('Failed to load cfg [%s]', err)

                            return false
                        end
                    end

                    function Preset:import()
                        local data = clipboard.get()
                        local success, err = config_system.import_from_str(self.data, "builder", "defensive")

                        if not success then
                            c_logger.log_error('Failed to import cfg [%s]', err)

                            return false
                        end

                        self.data = data

                        return true
                    end

                    function Preset:export()
                        clipboard.set(self.data)
                    end

                    function Preset:save()
                        local result = config_system.export_to_str("builder", "defensive")
                        self.data = result
                    end

                    function Preset:to_database()
                        return {
                            name = self.name,
                            data = self.data
                        }
                    end

                    function create_preset(preset)
                        return setmetatable({
                            name = preset.name,
                            data = preset.data
                        }, {
                            __index = Preset
                        })
                    end
                end
            end

            function antiaim_presets.update_list()
                local list_names = {}
                local list_len = #list

                for i=1, list_len do
                    local preset = list[i]

                    list_names[i] = preset.name
                end

                if #list_names == 0 then
                    list_names[1] = 'No presets here! Create one'
                end

                ui.update(config.presets.list:get_ref(), list_names)
            end

            function antiaim_presets.lookup(name)
                local search = c_string.trim(name)
                local list_len = #list

                for i=1, list_len do
                    local preset = list[i]

                    if preset.name == search then
                        return preset, i - 1
                    end
                end
            end

            function antiaim_presets.create(name)
                local target = c_string.trim(name)

                local success, result = pcall(function (...)
                    return ('%s_btool'):format(config_system.export_to_str("builder", "defensive"))
                end)

                if not success then
                    c_logger.log_error('Preset failed to create [%s]', result)

                    return
                end

                list[#list+1] = create_preset({
                    name = target,
                    data = result
                })

                antiaim_presets.update_list()
                antiaim_presets.flush()
            end

            function antiaim_presets.list_name_changed()
                if #list == 0 then
                    return
                end

                local selected_id = config.presets.list:rawget() or 0
                local selected = list[selected_id + 1]

                if selected == nil then
                    selected = list[#list]
                end

                config.presets.name:set(selected.name)
            end

            function antiaim_presets.delete(target)
                local list_len = #list

                for i=1, list_len do
                    local preset = list[i]

                    if preset.name == target.name then
                        c_logger.log('Removed preset [%s]', preset.name)

                        table.remove(list, i)

                        break
                    end
                end

                antiaim_presets.update_list()
                antiaim_presets.flush()
                antiaim_presets.list_name_changed()
            end

            function antiaim_presets.initialize()
                local database_list = database.read(database_name)

                if database_list == nil then
                    database_list = {}
                end

                local list_len = #database_list

                for i=1, list_len do
                    local preset = database_list[i]

                    list[i] = create_preset(preset)
                end

                antiaim_presets.update_list()
                antiaim_presets.list_name_changed()
            end

            function antiaim_presets.flush()
                local database_list = {}

                local list_len = #list

                for i=1, list_len do
                    database_list[i] = list[i]:to_database()
                end

                c_logger.log('Presets db saved.')

                database.write(database_name, database_list)
            end

            antiaim_presets.methods = {} do
                function antiaim_presets.methods.load()
                    local name = config.presets.name:rawget()
                    local preset, id = antiaim_presets.lookup(name)

                    if preset == nil then
                        c_logger.log_error('No preset selected!');

                        return
                    end

                    c_logger.log('Loading preset "%s"', name)

                    preset:load()
                    config.presets.list:set(id)
                end

                function antiaim_presets.methods.save()
                    local name = config.presets.name:rawget()
                    local preset, id = antiaim_presets.lookup(name)

                    if preset == nil then
                        c_logger.log_error('Creating preset "%s"', name);

                        antiaim_presets.create(name)
                        config.presets.list:set(#list-1)

                        return
                    end

                    c_logger.log('Saving preset "%s"', name)

                    preset:save()
                    config.presets.list:set(id)

                    antiaim_presets.flush()
                end

                function antiaim_presets.methods.export()
                    local name = config.presets.name:rawget()
                    local preset, id = antiaim_presets.lookup(name)

                    if preset == nil then
                        c_logger.log_error('No preset selected!');

                        return
                    end

                    c_logger.log('Exporting preset "%s"', name)

                    preset:export()
                    config.presets.list:set(id)
                end

                function antiaim_presets.methods.import()
                    local name = config.presets.name:rawget()
                    local preset, id = antiaim_presets.lookup(name)
                    local new_one = false

                    if preset == nil then
                        antiaim_presets.create(name)

                        preset, id = antiaim_presets.lookup(name)
                        new_one = true;
                    end

                    if preset then
                        if preset:import() then
                            c_logger.log('Preset imported [%s].', name)
                        end

                        if new_one then
                            antiaim_presets.flush()
                        end

                        config.presets.list:set(id)
                    end
                end

                function antiaim_presets.methods.remove()
                    local name = config.presets.name:rawget()
                    local preset = antiaim_presets.lookup(name)

                    if preset == nil then
                        return
                    else
                        antiaim_presets.delete(preset)
                    end
                end
            end

            config.presets.load:set_callback(antiaim_presets.methods.load)
            config.presets.save:set_callback(antiaim_presets.methods.save)
            config.presets.export:set_callback(antiaim_presets.methods.export)
            config.presets.import:set_callback(antiaim_presets.methods.import)
            config.presets.remove:set_callback(antiaim_presets.methods.remove)

            config.presets.list:set_callback(function ()
                antiaim_presets.list_name_changed()
            end)

            antiaim_presets.initialize()
        end
    end

    ---
    --- Menu state
    ---
    local menu_state = {} do
        function menu_state.visibility(shutdown)
            local should_show_aa = shutdown
            --local should_show_fl = not config.fakelag.enable:get() or shutdown
            local should_show_fl = config.navigation.tab:get() ~= "Anti-aimbot" or shutdown

            if should_show_fl and not shutdown then
                should_show_fl = not config.fakelag.enable:get()
            end

            if should_show_aa then
                override.unset(reference.antiaim.master)
            else
                override.set(reference.antiaim.master, true)
            end

            ui.set_visible(reference.antiaim.master, should_show_aa)

            ui.set_visible(reference.antiaim.roll, should_show_aa)
            ui.set_visible(reference.antiaim.freestanding[1], should_show_aa)
            ui.set_visible(reference.antiaim.freestanding[2], should_show_aa)
            ui.set_visible(reference.antiaim.yaw.edge, should_show_aa)

            ui.set_visible(reference.antiaim.pitch.type, should_show_aa)
            ui.set_visible(reference.antiaim.pitch.value, should_show_aa and ui.get(reference.antiaim.pitch.type) == 'Custom')

            ui.set_visible(reference.antiaim.yaw.base, should_show_aa)

            ui.set_visible(reference.antiaim.yaw.yaw.type, should_show_aa)

            local should_show_yaw_value = ui.get(reference.antiaim.yaw.yaw.type) ~= 'Off'

            ui.set_visible(reference.antiaim.yaw.yaw.value, should_show_aa and should_show_yaw_value)

            ui.set_visible(reference.antiaim.yaw.jitter.type, should_show_aa)

            local should_show_yaw_jitter = ui.get(reference.antiaim.yaw.jitter.type) ~= 'Off'

            ui.set_visible(reference.antiaim.yaw.jitter.value, should_show_aa and should_show_yaw_jitter)

            ui.set_visible(reference.antiaim.body.yaw.type, should_show_aa)

            local body_yaw = ui.get(reference.antiaim.body.yaw.type)
            local should_show_body_yaw = body_yaw ~= 'Disabled' and body_yaw ~= 'Opposite'

            ui.set_visible(reference.antiaim.body.yaw.value, should_show_aa and should_show_body_yaw)

            ui.set_visible(reference.antiaim.body.freestanding, should_show_aa)

            ui.set_visible(reference.fakelag.amount, should_show_fl)
            ui.set_visible(reference.fakelag.enable[1], should_show_fl)
            ui.set_visible(reference.fakelag.enable[2], should_show_fl)
            ui.set_visible(reference.fakelag.limit, should_show_fl)
            ui.set_visible(reference.fakelag.variance, should_show_fl)

            --local should_show_other = config.navigation.tab:get() ~= "Anti-aimbot" or shutdown

            --ui.set_visible(reference.misc.slowmotion[1], should_show_other)
            --ui.set_visible(reference.misc.slowmotion[2], should_show_other)
            --ui.set_visible(reference.misc.leg_movement, should_show_other)
            --ui.set_visible(reference.misc.onshot_antiaim[1], should_show_other)
            --ui.set_visible(reference.misc.onshot_antiaim[2], should_show_other)
            --ui.set_visible(reference.misc.fake_peek[1], should_show_other)
            --ui.set_visible(reference.misc.fake_peek[2], should_show_other)
        end

        do
            local transform = function (text)
                local cache = {}

                for w in string.gmatch(text, '.[\128-\191]*') do
                    cache[#cache + 1] = {
                        w = w,
                        n = 0,
                        d = false,
                        p = {0}
                    }
                end

                return cache
            end

            local linear = function (t, d, s)
                t[1] = c_math.clamp(t[ 1 ] + (globals.frametime() * s * (d and 1 or -1)), 0, 1)
                return t[1]
            end

            local label = transform(string.format('bloom.tool : %s', user.role))
            local menu_color = ui.reference("MISC", "Settings", "Menu color")

            menu_state.label = (function ()
                local result = {}
                local sidebar, accent = { 150, 176, 186, 255 }, { ui.get(menu_color) }
                local realtime = globals.realtime()
        
                for i, v in ipairs(label) do
                    if realtime >= v.n then
                        v.d = not v.d
                        v.n = realtime + client.random_float(1, 3)
                    end
        
                    local alpha = linear(v.p, v.d, 1)
                    local r, g, b, a = color(sidebar[1], sidebar[2], sidebar[3], sidebar[4]):lerp(color(accent[1], accent[2], accent[3], accent[4]), math.min(alpha + 0.5, 1)):unpack()
        
                    result[ #result + 1 ] = string.format('\a%02x%02x%02x%02x%s', r, g, b, 200 * alpha + 55, v.w)
                end
        
                config.navigation.label:set(table.concat(result))
            end)
        end
    end

    ---
    --- Callbacks
    ---
    local callbacks, events = {}, {} do
        function callbacks.start()
            c_logger.log('Welcome back, %s!', user.name)

            client.delay_call(0.25, function ()
                config.builder.antiaim_state:set('Standing')
                antiaim_presets.initialize()
                config_system:retrieve_local()
            end)
        end

        function callbacks.menu()
            config.navigation.label:display()
            config.navigation.tab:display()

            local tab = config.navigation.tab:get()
        
            if tab == "Anti-aimbot" then
                config.antiaimbot.main_label:display() do
                    config.antiaimbot.options:display()
                    config.antiaimbot.preset:display()

                    local preset = config.antiaimbot.preset:get()

                    if preset == "Constructor" then
                        config.builder.antiaim_state:display()

                        local state = config.builder.antiaim_state:get()
                        local list = antiaimbot_builder.settings[state]
                        local show = true

                        if list.enabled then
                            list.enabled:display()

                            show = list.enabled:get()
                        end

                        if show then
                            list.pitch:display()

                            if list.pitch:get() == "Custom" then
                                list.pitch_custom:display()
                            end

                            list.yaw_base:display()
                            list.yaw_type:display()

                            local yaw_type = list.yaw_type:get()
                            local delayed_switch = false

                            if yaw_type == "Left & Right" or yaw_type == "Flick" or yaw_type == "Sway" or yaw_type == "Spin between" then
                                list.yaw_left:display()
                                list.yaw_right:display()

                                if yaw_type == "Left & Right" then
                                    list.yaw_delayed_switch:display()

                                    if list.yaw_delayed_switch:get() then
                                        delayed_switch = true

                                        list.yaw_switch_delay:display()
                                        list.yaw_switch_delay_second:display()
                                    end
                                else
                                    list.yaw_delay:display()
                                    list.yaw_speed:display()
                                end
                            elseif yaw_type ~= "Off" then
                                list.yaw_amount:display()
                            end

                            list.yaw_jitter:display()

                            if list.yaw_jitter:get() ~= "Off" then
                                list.jitter_value:display()
                                list.jitter_randomize:display()
                            end

                            if not delayed_switch then
                                list.body_yaw:display()

                                if list.body_yaw:get() ~= "Off" then
                                    list.body_value:display()
                                end
                            end
                        end
                    end
                end

                config.antiaimbot.misc_label:display() do
                    config.antiaimbot.safe_head:display()

                    if config.antiaimbot.safe_head:get() then
                        config.antiaimbot.safe_head_conditions:display()
                    end

                    config.antiaimbot.warmup_aa:display()
    
                    if config.antiaimbot.warmup_aa:get() then
                        config.antiaimbot.warmup_aa_conditions:display()
                    end

                    config.antiaimbot.animation_breaker:display()

                    if config.antiaimbot.animation_breaker:get() then
                        config.antiaimbot.animation_breaker_leg:display()
                        config.antiaimbot.animation_breaker_air:display()
                        config.antiaimbot.animation_breaker_other:display()
                    end

                    config.antiaimbot.air_exploit:display()

                    if config.antiaimbot.air_exploit:get() then
                        config.antiaimbot.air_exploit_hotkey:display()
                    end

                    config.antiaimbot.manual_yaw:display()

                    if config.antiaimbot.manual_yaw:get() then
                        for i=1, #config.manuals do
                            config.manuals[i]:display()
                        end

                        config.antiaimbot.edge_yaw:display()
                        config.antiaimbot.freestanding:display()
                        config.antiaimbot.manual_options:display()
                        config.antiaimbot.fs_options:display()
                        config.antiaimbot.freestanding_disabler_states:display()
                    end
                end
            else
                -- Fake lag
                do
                    config.fakelag.enable:display()

                    if config.fakelag.enable:get() then
                        config.fakelag.type:display()
                        config.fakelag.ticks:display()
                    end
                end
            end

            if tab == "Defensive" then
                config.antiaimbot.defensive_aa:display()

                if config.antiaimbot.defensive_aa:get() then
                    config.antiaimbot.force_target_yaw:display()
                    config.antiaimbot.defensive_target:display()
                    config.antiaimbot.defensive_conditions:display()
                    config.antiaimbot.defensive_triggers:display()
                    config.antiaimbot.defensive_preset:display()

                    local preset = config.antiaimbot.defensive_preset:get()

                    if preset == "Auto" then
                        config.antiaimbot.defensive_conditions_auto:display()
                    elseif preset == "Constructor" then
                        config.builder.defensive_state:display()

                        local state = config.builder.defensive_state:get()
                        local list = antiaimbot_builder.defensive_settings[state]

                        list.enabled:display()

                        if list.enabled:get() and not (state == "Safe head" or state == "Edge direction" or state == "Triggered") then
                            list.pitch:display()

                            if list.pitch:get() == "Custom" then
                                list.pitch_custom:display()
                            end

                            list.yaw:display()

                            local yaw = list.yaw:get()

                            if yaw == "Delayed" then
                                list.yaw_left:display()
                                list.yaw_right:display()
                                list.yaw_delay:display()
                            end

                            if yaw == "Spinbot" then
                                list.yaw_from:display()
                                list.yaw_to:display()
                                list.yaw_speed:display()
                            end

                            if yaw == "Scissors" then
                                list.yaw_left_start:display()
                                list.yaw_left_target:display()

                                list.yaw_right_start:display()
                                list.yaw_right_target:display()
                            end

                            if yaw == "Scissors" or yaw == "Delayed" then
                                list.yaw_delay:display()
                            end

                            if yaw == "Scissors" or yaw == "Delayed" or yaw == "Spinbot" then
                                list.yaw_randomize:display()
                            end
                        end
                    end
                end
            end

            if tab == "Visuals" then
                config.visuals.indicators:display()

                if config.visuals.indicators:get() then
                    config.visuals.indicator_color:display()
                    config.visuals.indicator_style:display()

                    if config.visuals.indicator_style:get() == "Renewed" then
                        config.visuals.indicator_renewed_color:display()
                    end

                    config.visuals.indicator_vertical_offset:display()
                    config.visuals.indicator_options:display()
                end

                config.visuals.damage_marker:display()

                if config.visuals.damage_marker:get() then
                    config.visuals.damage_marker_color:display()
                end

                config.visuals.r8_indicator:display()

                if config.visuals.r8_indicator:get() then
                    config.visuals.r8_indicator_color:display()
                end

                config.visuals.manual_arrows:display()

                if config.visuals.manual_arrows:get() then
                    config.visuals.manual_arrows_color:display()
                    config.visuals.manual_arrows_accent:display()
                    config.visuals.manual_arrows_style:display()
                    config.visuals.manual_arrows_options:display()
                    
                    if config.visuals.manual_arrows_style:get() == "Triangles" then
                        config.visuals.manual_arrows_size:display()
                    end

                    config.visuals.manual_arrows_offset:display()
                end
            end

            if tab == "Miscellaneous" then
                config.miscellaneous.clantag:display()

                config.miscellaneous.cheat_tweaks:display()

                if config.miscellaneous.cheat_tweaks:get() then
                    config.miscellaneous.cheat_tweaks_list:display()
                end

                config.miscellaneous.automatic_tp:display()

                if config.miscellaneous.automatic_tp:get() then
                    config.miscellaneous.automatic_tp_weapons:display()
                    config.miscellaneous.automatic_tp_delay:display()
                end

                config.miscellaneous.trashtalk:display()
                config.miscellaneous.custom_output:display()
                config.miscellaneous.event_logger:display()
                config.miscellaneous.console_filter:display()
            end

            if tab == "Presets" then
                config.presets.list:display()
                config.presets.name:display()

                config.presets.load:display()
                config.presets.save:display()
                config.presets.remove:display()
                config.presets.import:display()
                config.presets.export:display()
            end

            if tab == "Configuration" then
                config.settings.import:display()
                config.settings.export:display()
                config.settings.builtin:display()
            end
        end

        function callbacks.paint(ctx)
            visuals:paint()
        end

        function callbacks.paint_ui(ctx)
            if ui.is_menu_open() then
                menu_state.visibility()
                menu_state.label()
            end

            c_animations:frame()

            player:paint_ui()
            visuals:paint_ui()
            miscellaneous:paint_ui()
        end

        function callbacks.predict_command(cmd)
            local me = entity.get_local_player()
            local wpn = me and entity.get_player_weapon(me) or nil

            player:predict_command(cmd, me)
            antiaimbot:predict_command(cmd, me, wpn)
        end

        function callbacks.setup_command(cmd)
            local me = entity.get_local_player()
            local wpn = me and entity.get_player_weapon(me) or nil

            player:setup_command(cmd, me, wpn)
            fakelag:setup_command(cmd, me, wpn)
            antiaimbot:setup_command(cmd, me, wpn)
            miscellaneous:setup_command(cmd, me, wpn)
        end

        function callbacks.run_command(cmd)
            player:run_command(cmd)
        end

        function callbacks.finish_command(cmd)
            local me = entity.get_local_player()
            local wpn = me and entity.get_player_weapon(me) or nil

            antiaimbot:finish_command(cmd, me, wpn)
            player:finish_command(cmd, me, wpn)
        end

        function callbacks.net_update_end()
            player:net_update_end()
            miscellaneous:net_update_end()
        end

        function callbacks.console_input(text)
            if text == 'bt_debug' then
                user.debug = not user.debug

                return true
            end
        end

        function callbacks.shutdown()
            miscellaneous.clantag.reset()

            antiaimbot.main.get_instance():reset()
            antiaim_presets:flush()

            config_system:save_local()

            client.exec('con_filter_enable 0;con_filter_text "";')

            override.unset(reference.ragebot.fakeduck)

            override.unset(reference.fakelag.enable)
            override.unset(reference.fakelag.amount)
            override.unset(reference.fakelag.limit)
            override.unset(reference.fakelag.variance)

            override.unset(reference.misc.draw_output)

            override.unset(reference.misc.air_strafe)

            menu_state.visibility(true)

            c_logger.log('Shutting down...')
        end

        --- Events
        function events.aim_fire(event)
            miscellaneous:aim_fire(event)
        end

        function events.aim_hit(event)
            miscellaneous:aim_hit(event)
        end

        function events.aim_miss(event)
            miscellaneous:aim_miss(event)
        end

        function events.player_hurt(event)
            miscellaneous:player_hurt(event)
            visuals:player_hurt(event)
        end

        function events.player_death(event)
            miscellaneous:player_death(event)
        end
    end


    ---
    --- Start up
    ---
    do
        callbacks.start()

        menu.set_callback(callbacks.menu)
        menu.update()

        client.set_event_callback('paint', callbacks.paint)
        client.set_event_callback('paint_ui', callbacks.paint_ui)
        client.set_event_callback('predict_command', callbacks.predict_command)
        client.set_event_callback('setup_command', callbacks.setup_command)
        client.set_event_callback('run_command', callbacks.run_command)
        client.set_event_callback('finish_command', callbacks.finish_command)

        client.set_event_callback('net_update_end', callbacks.net_update_end)
        client.set_event_callback('console_input', callbacks.console_input)
        client.set_event_callback('shutdown', callbacks.shutdown)

        --- Events
        client.set_event_callback('aim_fire', events.aim_fire)
        client.set_event_callback('aim_hit', events.aim_hit)
        client.set_event_callback('aim_miss', events.aim_miss)

        client.set_event_callback('player_hurt', events.player_hurt)
        client.set_event_callback('player_death', events.player_death)
    end
end)()