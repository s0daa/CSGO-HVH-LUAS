                  genesis_loader = {}
                  genesis_loader.fetch = function()
                    local build = 'pasta'
                    local user = 'dolboeb'
                    return build, user
                end


local ffi = require 'ffi'
local vector = require 'vector'

local inspect = require 'gamesense/inspect'

local base64 = require 'gamesense/base64'
local clipboard = require 'gamesense/clipboard'

local c_entity = require 'gamesense/entity'
local csgo_weapons = require 'gamesense/csgo_weapons'

local function round(x)
    return math.floor(x + 0.5)
end

local function contains(list, value)
    for i = 1, #list do
        if list[i] == value then
            return i
        end
    end

    return nil
end

local loaderdatabuild, loaderdatausername = genesis_loader.fetch()

local script do
    script = { }

    script.name = 'spectral' do
        script.user = loaderdatausername
        script.build = 'cracked'
    end
end

local utils do
    utils = { }

    function utils.clamp(x, min, max)
        return math.max(min, math.min(x, max))
    end

    function utils.lerp(a, b, t)
        return a + t * (b - a)
    end

    function utils.inverse_lerp(a, b, x)
        return (x - a) / (b - a)
    end

    function utils.map(x, in_min, in_max, out_min, out_max, should_clamp)
        if should_clamp then
            x = utils.clamp(x, in_min, in_max)
        end

        local rel = utils.inverse_lerp(in_min, in_max, x)
        local value = utils.lerp(out_min, out_max, rel)

        return value
    end

    function utils.normalize(x, min, max)
        local d = max - min

        while x < min do
            x = x + d
        end

        while x > max do
            x = x - d
        end

        return x
    end

    function utils.trim(str)
        return str
    end

    function utils.from_hex(hex)
        hex = string.gsub(hex, '#', '')

        local r = tonumber(string.sub(hex, 1, 2), 16)
        local g = tonumber(string.sub(hex, 3, 4), 16)
        local b = tonumber(string.sub(hex, 5, 6), 16)
        local a = tonumber(string.sub(hex, 7, 8), 16)

        return r, g, b, a or 255
    end

    function utils.to_hex(r, g, b, a)
        return string.format('%02x%02x%02x%02x', r, g, b, a)
    end

    function utils.event_callback(event_name, callback, value)
        assert(callback ~= nil, 'Callback is nil')

        local fn = value and client.set_event_callback
            or client.unset_event_callback

        fn(event_name, callback)
    end

    function utils.get_eye_position(ent)
        local origin_x, origin_y, origin_z = entity.get_origin(ent)
        local offset_x, offset_y, offset_z = entity.get_prop(ent, 'm_vecViewOffset')

        if origin_x == nil or offset_x == nil then
            return nil
        end

        local eye_pos_x = origin_x + offset_x
        local eye_pos_y = origin_y + offset_y
        local eye_pos_z = origin_z + offset_z

        return eye_pos_x, eye_pos_y, eye_pos_z
    end

    function utils.closest_ray_point(a, b, p, should_clamp)
        local ray_delta = p - a
        local line_delta = b - a

        local lengthsqr = line_delta.x * line_delta.x + line_delta.y * line_delta.y
        local dot_product = ray_delta.x * line_delta.x + ray_delta.y * line_delta.y

        local t = dot_product / lengthsqr

        if should_clamp then
            if t <= 0.0 then
                return a
            end

            if t >= 1.0 then
                return b
            end
        end

        return a + t * line_delta
    end

    function utils.extrapolate(pos, vel, ticks)
        return pos + vel * (ticks * globals.tickinterval())
    end

    function utils.random_int(min, max)
        if min > max then
            min, max = max, min
        end

        return client.random_int(min, max)
    end

    function utils.random_float(min, max)
        if min > max then
            min, max = max, min
        end

        return client.random_float(min, max)
    end

    function utils.find_signature(module_name, pattern, offset)
        local match = client.find_signature(module_name, pattern)

        if match == nil then
            return nil
        end

        if offset ~= nil then
            local address = ffi.cast('char*', match)
            address = address + offset

            return address
        end

        return match
    end
end

local software do
    software = { }

    software.ragebot = {
        weapon_type = ui.reference(
            'Rage', 'Weapon type', 'Weapon type'
        ),

        aimbot = {
            enabled = {
                ui.reference('Rage', 'Aimbot', 'Enabled')
            },

            double_tap = {
                ui.reference('Rage', 'Aimbot', 'Double tap')
            },

            minimum_hit_chance = ui.reference(
                'Rage', 'Aimbot', 'Minimum hit chance'
            ),

            minimum_damage = ui.reference(
                'Rage', 'Aimbot', 'Minimum damage'
            ),

            minimum_damage_override = {
                ui.reference('Rage', 'Aimbot', 'Minimum damage override')
            }
        },

        other = {
            quick_peek_assist = {
                ui.reference('Rage', 'Other', 'Quick peek assist')
            },

            duck_peek_assist = ui.reference('Rage', 'Other', 'Duck peek assist')
        }
    }

    software.antiaimbot = {
        angles = {
            enabled = ui.reference(
                'AA', 'Anti-aimbot angles', 'Enabled'
            ),

            pitch = {
                ui.reference('AA', 'Anti-aimbot angles', 'Pitch')
            },

            yaw_base = ui.reference(
                'AA', 'Anti-aimbot angles', 'Yaw base'
            ),

            yaw = {
                ui.reference('AA', 'Anti-aimbot angles', 'Yaw')
            },

            yaw_jitter = {
                ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')
            },

            body_yaw = {
                ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')
            },

            freestanding_body_yaw = ui.reference(
                'AA', 'Anti-aimbot angles', 'Freestanding body yaw'
            ),

            edge_yaw = ui.reference(
                'AA', 'Anti-aimbot angles', 'Edge yaw'
            ),

            freestanding = {
                ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')
            },

            roll = ui.reference(
                'AA', 'Anti-aimbot angles', 'Roll'
            )
        },

        fake_lag = {
            enabled = {
                ui.reference('AA', 'Fake lag', 'Enabled')
            },

            amount = ui.reference(
                'AA', 'Fake lag', 'Amount'
            ),

            variance = ui.reference(
                'AA', 'Fake lag', 'Variance'
            ),

            limit = ui.reference(
                'AA', 'Fake lag', 'Limit'
            ),
        },

        other = {
            slow_motion = {
                ui.reference('AA', 'Other', 'Slow motion')
            },

            on_shot_antiaim = {
                ui.reference('AA', 'Other', 'On shot anti-aim')
            },

            leg_movement = ui.reference(
                'AA', 'Other', 'Leg movement'
            )
        }
    }

    software.misc = {
        movement = {
            air_strafe = ui.reference(
                'Misc', 'Movement', 'Air strafe'
            )
        },

        settings = {
            menu_color = ui.reference(
                'Misc', 'Settings', 'Menu color'
            )
        }
    }
    function software.get_color(to_hex)
        if to_hex then
            return utils.to_hex(ui.get(software.misc.settings.menu_color))
        end

        return ui.get(software.misc.settings.menu_color)
    end

    function software.get_override_damage()
        return ui.get(software.ragebot.aimbot.minimum_damage_override[3])
    end

    function software.get_minimum_damage()
        return ui.get(software.ragebot.aimbot.minimum_damage)
    end

    function software.is_slow_motion()
        return ui.get(software.antiaimbot.other.slow_motion[1])
            and ui.get(software.antiaimbot.other.slow_motion[2])
    end

    function software.is_double_tap_active()
        return ui.get(software.ragebot.aimbot.double_tap[1])
            and ui.get(software.ragebot.aimbot.double_tap[2])
    end

    function software.is_override_minimum_damage()
        return ui.get(software.ragebot.aimbot.minimum_damage_override[1])
            and ui.get(software.ragebot.aimbot.minimum_damage_override[2])
    end

    function software.is_on_shot_antiaim_active()
        return ui.get(software.antiaimbot.other.on_shot_antiaim[1])
            and ui.get(software.antiaimbot.other.on_shot_antiaim[2])
    end

    function software.is_duck_peek_assist()
        return ui.get(software.ragebot.other.duck_peek_assist)
    end

    function software.is_quick_peek_assist()
        return ui.get(software.ragebot.other.quick_peek_assist[1])
            and ui.get(software.ragebot.other.quick_peek_assist[2])
    end
end

local iinput do
    iinput = { }

	--- https://gitlab.com/KittenPopo/csgo-2018-source/-/blob/main/game/client/iinput.h

	local vector_t = ffi.typeof [[
		struct {
			float x;
			float y;
			float z;
		}
	]]

	local cusercmd_t = ffi.typeof([[
		struct {
			void     *vfptr;
			int      command_number;
			int      tickcount;
			$        viewangles;
			$        aimdirection;
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
			$        headangles;
			$        headoffset;
			char	 pad_0x4C[0x18];
		}
	]], vector_t, vector_t, vector_t, vector_t)

    local signature = {
        'client.dll', '\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85', 1
    }

	local vtable_addr = utils.find_signature(unpack(signature))
    local vtable_ptr = ffi.cast('uintptr_t***', vtable_addr)[0]

    local native_GetUserCmd = ffi.cast(ffi.typeof('$*(__thiscall*)(void*, int nSlot, int sequence_number)', cusercmd_t), vtable_ptr[0][8])

    function iinput.get_usercmd(slot, command_number)
        if command_number == 0 then
            return nil
        end

        return native_GetUserCmd(vtable_ptr, slot, command_number)
    end
end

local event_system do
    event_system = { }

    local function find(list, value)
        for i = 1, #list do
            if value == list[i] then
                return i
            end
        end

        return nil
    end

    local EventList = { } do
        EventList.__index = EventList

        function EventList:new()
            return setmetatable({
                list = { },
                count = 0
            }, self)
        end

        function EventList:__len()
            return self.count
        end

        function EventList:set(callback)
            if not find(self.list, callback) then
                self.count = self.count + 1
                table.insert(self.list, callback)
            end

            return self
        end

        function EventList:unset(callback)
            local index = find(self.list, callback)

            if index ~= nil then
                self.count = self.count - 1
                table.remove(self.list, index)
            end

            return self
        end

        function EventList:fire(...)
            local list = self.list

            for i = 1, #list do
                list[i](...)
            end

            return self
        end
    end

    local EventBus = { } do
        local function __index(list, k)
            local value = rawget(list, k)

            if value == nil then
                value = EventList:new()
                rawset(list, k, value)
            end

            return value
        end

        function EventBus:new()
            return setmetatable({ }, {
                __index = __index
            })
        end
    end

    function event_system:new()
        return EventBus:new()
    end
end

local logging_system do
    logging_system = { }

    local SOUND_SUCCESS = 'ui\\beepclear.wav'
    local SOUND_FAILURE = 'resource\\warning.wav'

    local play = cvar.play

    local function display_tag(r, g, b)
        client.color_log(r, g, b, script.name, '\0')
        client.color_log(255, 255, 255, ' ✦ ', '\0')
    end

    function logging_system.success(msg)
        display_tag(135, 135, 245)

        client.color_log(255, 255, 255, msg)
        play:invoke_callback(SOUND_SUCCESS)
    end

    function logging_system.error(msg)
        display_tag(250, 50, 75)

        client.color_log(255, 255, 255, msg)
        play:invoke_callback(SOUND_FAILURE)
    end
end

local config_system do
    config_system = { }

    local KEY = 'irEa5PqmVkMlw2Nj8B43dfnoeI9tHxzK1DX0JF6ULGAWcQuCTZpvh7syRgbYSO+/='

    local item_list = { }
    local item_data = { }

    local function get_key_values(arr)
        local list = { }

        if arr ~= nil then
            for i = 1, #arr do
                list[arr[i]] = i
            end
        end

        return list
    end

    function config_system.push(tab, name, item)
        if item_data[tab] == nil then
            item_data[tab] = { }
        end

        local data = {
            tab = tab,
            name = name,
            item = item
        }

        item_data[tab][name] = item
        table.insert(item_list, data)

        return item
    end

    function config_system.encode(data)
        local ok, result = pcall(json.stringify, data)

        if not ok then
            return false, result
        end

        ok, result = pcall(base64.encode, result, KEY)

        if not ok then
            return false, result
        end

        result = string.gsub(
            result, '[%+%/%=]', {
                ['+'] = 'g2134',
                ['/'] = 'g2634',
                ['='] = '_'
            }
        )

        result = string.format(
            'spectral: %s', result
        )

        return true, result
    end

    function config_system.decode(str)
        -- prefix detect + windows 11 notepad fix
        local matched, pad = str:match 'spectral: ([%w%+%/]+)(_*)'

        if matched == nil then
            return false, 'Config not supported'
        end

        -- enq, what the fuck...
        pad = pad and string.rep('=', #pad) or ''

        local data = string.gsub(matched, 'g2%d%d34', {
            ['g2134'] = '+',
            ['g2634'] = '/'
        })

        local ok, result = pcall(base64.decode, data .. pad, KEY)

        if not ok then
            return false, result
        end

        ok, result = pcall(json.parse, result)

        if not ok then
            return false, result
        end

        return true, result
    end

    function config_system.import(data, categories)
        if data == nil then
            return false, 'config is empty'
        end

        local keys = get_key_values(categories)

        for k, v in pairs(data) do
            if categories ~= nil and keys[k] == nil then
                goto continue
            end

            local items = item_data[k]

            if items == nil then
                goto continue
            end

            for m, n in pairs(v) do
                local item = items[m]

                if item ~= nil then
                    item:set(unpack(n))
                end
            end

            ::continue::
        end

        return true, nil
    end

    function config_system.export(categories)
        local list = { }

        local keys = get_key_values(categories)

        for k, v in pairs(item_data) do
            if categories ~= nil and keys[k] == nil then
                goto continue
            end

            local values = { }

            for m, n in pairs(v) do
                if n.type ~= 'hotkey' then
                    values[m] = n.value
                end
            end

            list[k] = values
            ::continue::
        end

        return list
    end
end

local shot_system do
    shot_system = { }

    local event_bus = event_system:new()

    local shot_list = { }

    local function create_shot_data(player)
        local tick = globals.tickcount()

        local eye_pos = vector(
            utils.get_eye_position(player)
        )

        local data = {
            tick = tick,

            player = player,
            victim = nil,

            eye_pos = eye_pos,
            impacts = { },

            damage = nil,
            hitgroup = nil
        }

        return data
    end

    local function on_weapon_fire(e)
        local userid = client.userid_to_entindex(e.userid)

        if userid == nil then
            return
        end

        table.insert(shot_list, create_shot_data(userid))
    end

    local function on_player_hurt(e)
        local userid = client.userid_to_entindex(e.userid)
        local attacker = client.userid_to_entindex(e.attacker)

        if userid == nil or attacker == nil then
            return
        end

        for i = #shot_list, 1, -1 do
            local data = shot_list[i]

            if data.player == attacker then
                data.victim = userid

                data.damage = e.dmg_health
                data.hitgroup = e.hitgroup

                break
            end
        end
    end

    local function on_bullet_impact(e)
        local userid = client.userid_to_entindex(e.userid)

        if userid == nil then
            return
        end

        for i = #shot_list, 1, -1 do
            local data = shot_list[i]

            if data.player == userid then
                local pos = vector(e.x, e.y, e.z)
                table.insert(data.impacts, pos)

                break
            end
        end
    end

    local function on_net_update_start()
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        local head_pos = nil do
            if entity.is_alive(me) then
                head_pos = vector(entity.hitbox_position(me, 0))
            end
        end

        for i = 1, #shot_list do
            local data = shot_list[i]

            local impact_count = #data.impacts

            if impact_count == 0 then
                goto continue
            end

            local eye_pos = data.eye_pos
            local end_pos = data.impacts[impact_count]

            event_bus.player_shot:fire {
                tick = data.tick,

                player = data.player,
                victim = data.victim,

                eye_pos = eye_pos,
                end_pos = end_pos,

                damage = data.damage,
                hitgroup = data.hitgroup
            }

            if head_pos ~= nil and entity.is_enemy(data.player) then
                local closest_point = utils.closest_ray_point(
                    eye_pos, end_pos, head_pos, true
                )

                local distancesqr = head_pos:distsqr(closest_point)

                if distancesqr <= 80 * 80 then
                    local distance = math.sqrt(distancesqr)

                    event_bus.enemy_shot:fire {
                        tick = data.tick,
                        distance = distance,

                        player = data.player,
                        victim = data.victim,

                        eye_pos = eye_pos,
                        end_pos = end_pos,

                        damage = data.damage,
                        hitgroup = data.hitgroup
                    }
                end
            end

            ::continue::
        end

        for i = 1, #shot_list do
            shot_list[i] = nil
        end
    end

    function shot_system.get_event_bus()
        return event_bus
    end

    client.set_event_callback('weapon_fire', on_weapon_fire)
    client.set_event_callback('player_hurt', on_player_hurt)
    client.set_event_callback('bullet_impact', on_bullet_impact)
    client.set_event_callback('net_update_start', on_net_update_start)
end

local menu do
    menu = { }

    local event_bus = event_system:new()

    local Item = { } do
        Item.__index = Item

        local function pack(ok, ...)
            if not ok then
                return nil
            end

            return ...
        end

        local function get_value_array(ref)
            return { pack(pcall(ui.get, ref)) }
        end

        local function get_key_values(arr)
            local list = { }

            for i = 1, #arr do
                list[arr[i]] = i
            end

            return list
        end

        local function update_item_values(item, initial)
            local value = get_value_array(item.ref)

            item.value = value

            if initial then
                item.default = value
            end

            if item.type == 'multiselect' then
                item.key_values = get_key_values(unpack(value))
            end
        end

        function Item:new(ref)
            return setmetatable({
                ref = ref,
                type = nil,

                list = { },
                value = { },
                default = { },
                key_values = { },

                callbacks = { }
            }, self)
        end

        function Item:init(...)
            local function callback()
                update_item_values(self, false)
                self:fire_events()

                event_bus.item_changed:fire(self)
            end

            self.type = ui.type(self.ref)

            if self.type ~= 'label' then
                update_item_values(self, true)
                pcall(ui.set_callback, self.ref, callback)
            end

            if self.type == 'multiselect' or self.type == 'list' then
                self.list = select(4, ...)
            end

            if self.type == 'button' then
                local fn = select(4, ...)

                if fn ~= nil then
                    self:set_callback(fn)
                end
            end

            event_bus.item_init:fire(self)
        end

        function Item:get(key)
            if self.type == 'hotkey' or self.type == 'textbox' then
                return ui.get(self.ref)
            end

            if key ~= nil then
                return self.key_values[key] ~= nil
            end

            return unpack(self.value)
        end

        function Item:set(...)
            ui.set(self.ref, ...)
            update_item_values(self, false)
        end

        function Item:update(...)
            ui.update(self.ref, ...)
        end

        function Item:reset()
            pcall(ui.set, self.ref, unpack(self.default))
        end

        function Item:set_enabled(value)
            return ui.set_enabled(self.ref, value)
        end

        function Item:set_visible(value)
            return ui.set_visible(self.ref, value)
        end

        function Item:set_callback(callback, force_call)
            local index = contains(self.callbacks, callback)

            if index == nil then
                table.insert(self.callbacks, callback)
            end

            if force_call then
                callback(self)
            end

            return self
        end

        function Item:unset_callback(callback)
            local index = contains(self.callbacks, callback)

            if index ~= nil then
                table.remove(self.callbacks, index)
            end

            return self
        end

        function Item:fire_events()
            local list = self.callbacks

            for i = 1, #list do
                list[i](self)
            end
        end
    end

    function menu.new(fn, ...)
        local ref = fn(...)

        local item = Item:new(ref) do
            item:init(...)
        end

        return item
    end

    function menu.get_event_bus()
        return event_bus
    end
end

local menu_logic do
    menu_logic = { }

    local item_data = { }
    local item_list = { }

    local logic_events = event_system:new()

    function menu_logic.get_event_bus()
        return logic_events
    end

    function menu_logic.set(item, value)
        if item == nil or item.ref == nil then
            return
        end

        item_data[item.ref] = value
    end

    function menu_logic.force_update()
        for i = 1, #item_list do
            local item = item_list[i]

            if item == nil then
                goto continue
            end

            local ref = item.ref

            if ref == nil then
                goto continue
            end

            local value = item_data[ref]

            if value == nil then
                goto continue
            end

            item:set_visible(value)
            item_data[ref] = false

            ::continue::
        end
    end

    local menu_events = menu.get_event_bus() do
        local function on_item_init(item)
            item_data[item.ref] = false
            item:set_visible(false)

            table.insert(item_list, item)
        end

        local function on_item_changed(...)
            logic_events.update:fire(...)
            menu_logic.force_update()
        end

        menu_events.item_init:set(on_item_init)
        menu_events.item_changed:set(on_item_changed)
    end
end

local text_anims do
    text_anims = { }

    local function u8(str)
        local chars = { }
        local count = 0

        for c in string.gmatch(str, '.[\128-\191]*') do
            count = count + 1
            chars[count] = c
        end

        return chars, count
    end

    function text_anims.gradient(str, time, r1, g1, b1, a1, r2, g2, b2, a2)
        local list = { }

        local strbuf, strlen = u8(str)
        local div = 1 / (strlen - 1)

        local delta_r = r2 - r1
        local delta_g = g2 - g1
        local delta_b = b2 - b1
        local delta_a = a2 - a1

        for i = 1, strlen do
            local char = strbuf[i]

            local t = time do
                t = t % 2

                if t > 1 then
                    t = 2 - t
                end
            end

            local r = r1 + t * delta_r
            local g = g1 + t * delta_g
            local b = b1 + t * delta_b
            local a = a1 + t * delta_a

            local hex = utils.to_hex(r, g, b, a)

            table.insert(list, '\a')
            table.insert(list, hex)
            table.insert(list, char)

            time = time + div
        end

        return table.concat(list)
    end
end

local text_fmt do
    text_fmt = { }

    local function decompose(str)
        local result, len = { }, #str

        local i, j = str:find('\a', 1)

        if i == nil then
            table.insert(result, {
                str, nil
            })
        end

        if i ~= nil and i > 1 then
            table.insert(result, {
                str:sub(1, i - 1), nil
            })
        end

        while i ~= nil do
            local hex = nil

            if str:sub(j + 1, j + 7) == 'DEFAULT' then
                j = j + 8
            else
                hex = str:sub(j + 1, j + 8)
                j = j + 9
            end

            local m, n = str:find('\a', j + 1)

            if m == nil then
                if j <= len then
                    table.insert(result, {
                        str:sub(j), hex
                    })
                end

                break
            end

            table.insert(result, {
                str:sub(j, m - 1), hex
            })

            i, j = m, n
        end

        return result
    end

    function text_fmt.color(str)
        local list = decompose(str)
        local len = #list

        return list, len
    end
end

local const do
    const = { }

    const.states = {
        'Default',
        'Standing',
        'Moving',
        'Slow Walk',
        'Jumping',
        'Jumping+',
        'Crouch',
        'Move-Crouch',
        'Legit AA',
        'Fakelag',
        'Dormant',
        'Manual AA',
        'Freestanding'
    }
end

local localplayer do
    localplayer = { }

    local pre_flags = 0
    local post_flags = 0

    localplayer.is_moving = false
    localplayer.is_onground = false
    localplayer.is_crouched = false

    localplayer.duck_amount = 0.0
    localplayer.velocity2d_sqr = 0

    localplayer.is_peeking = false
    localplayer.is_vulnerable = false

    -- from @enq
    local function is_peeking(player)
        local should, vulnerable = false, false
        local velocity = vector(entity.get_prop(player, "m_vecVelocity"))

        local eye = vector(client.eye_position())
        local peye = utils.extrapolate(eye, velocity, 14)

        local enemies = entity.get_players(true)

        for i = 1, #enemies do
            local enemy = enemies[i]

            local esp_data = entity.get_esp_data(enemy)

            if esp_data == nil then
                goto continue
            end

            if bit.band(esp_data.flags, bit.lshift(1, 11)) ~= 0 then
                vulnerable = true
                goto continue
            end

            local head = vector(entity.hitbox_position(enemy, 0))
            local phead = utils.extrapolate(head, velocity, 4)
            local entindex, damage = client.trace_bullet(player, peye.x, peye.y, peye.z, phead.x, phead.y, phead.z)

            if damage ~= nil and damage > 0 then
                should = true
                break
            end

            ::continue::
        end

        return should, vulnerable
    end

    local function on_pre_predict_command(cmd)
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        pre_flags = entity.get_prop(me, 'm_fFlags')
    end

    local function on_predict_command(cmd)
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        post_flags = entity.get_prop(me, 'm_fFlags')
    end

    local function on_setup_command(cmd)
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        local peeking, vulnerable = is_peeking(me)

        local is_onground = bit.band(pre_flags, 1) ~= 0
            and bit.band(post_flags, 1) ~= 0

        local velocity = vector(entity.get_prop(me, 'm_vecVelocity'))
        local duck_amount = entity.get_prop(me, 'm_flDuckAmount')

        local velocity2d_sqr = velocity:length2dsqr()

        localplayer.is_moving = velocity2d_sqr > 5 * 5
        localplayer.is_onground = is_onground

        localplayer.is_peeking = peeking
        localplayer.is_vulnerable = vulnerable

        if cmd.chokedcommands == 0 then
            localplayer.is_crouched = duck_amount > 0.5
            localplayer.duck_amount = duck_amount
        end

        localplayer.velocity2d_sqr = velocity2d_sqr
    end

    client.set_event_callback('pre_predict_command', on_pre_predict_command)
    client.set_event_callback('predict_command', on_predict_command)
    client.set_event_callback('setup_command', on_setup_command)
end

local exploit do
    exploit = { }

    local BREAK_LAG_COMPENSATION_DISTANCE_SQR = 64 * 64

    local max_tickbase = 0
    local run_command_number = 0

    local data = {
        old_origin = vector(),
        old_simtime = 0.0,

        shift = false,
        breaking_lc = false,

        defensive = {
            force = false,
            left = 0,
            max = 0,
        },

        lagcompensation = {
            distance = 0.0,
            teleport = false
        }
    }

    local function update_tickbase(me)
        data.shift = globals.tickcount() > entity.get_prop(me, 'm_nTickBase')
    end

    local function update_teleport(old_origin, new_origin)
        local delta = new_origin - old_origin
        local distance = delta:lengthsqr()

        local is_teleport = distance > BREAK_LAG_COMPENSATION_DISTANCE_SQR

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
                update_teleport(old_origin, origin)
            end
        end

        data.old_origin = origin
        data.old_simtime = simtime
    end

    local function update_defensive_tick(me)
        local tickbase = entity.get_prop(me, 'm_nTickBase')

        if math.abs(tickbase - max_tickbase) > 64 then
            -- nullify highest tickbase if the difference is too big
            max_tickbase = 0
        end

        local defensive_ticks_left = 0

        -- defensive effect can be achieved because the lag compensation is made so that
        -- it doesn't write records if the current simulation time is less than/equals highest acknowledged simulation time
        -- https://gitlab.com/KittenPopo/csgo-2018-source/-/blame/main/game/server/player_lagcompensation.cpp#L723

        if tickbase > max_tickbase then
            max_tickbase = tickbase
        elseif max_tickbase > tickbase then
            defensive_ticks_left = math.min(14, math.max(0, max_tickbase - tickbase - 1))
        end

        if defensive_ticks_left > 0 then
            data.breaking_lc = true
            data.defensive.left = defensive_ticks_left

            if data.defensive.max == 0 then
                data.defensive.max = defensive_ticks_left
            end
        else
            data.defensive.left = 0
            data.defensive.max = 0
        end
    end

    function exploit.get()
        return data
    end

    local function on_predict_command(cmd)
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        if cmd.command_number == run_command_number then
            update_defensive_tick(me)
            run_command_number = nil
        end
    end

    local function on_setup_command(cmd)
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        update_tickbase(me)
    end

    local function on_run_command(e)
        run_command_number = e.command_number
    end

    local function on_net_update_start()
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        update_lagcompensation(me)
    end

    client.set_event_callback('predict_command', on_predict_command)
    client.set_event_callback('setup_command', on_setup_command)
    client.set_event_callback('run_command', on_run_command)

    client.set_event_callback('net_update_start', on_net_update_start)
end

local statement do
    statement = { }

    local list = { }
    local count = 0

    local function add(state)
        count = count + 1
        list[count] = state
    end

    local function clear_list()
        for i = 1, count do
            list[i] = nil
        end

        count = 0
    end

    local function update_onground()
        if not localplayer.is_onground then
            return
        end

        if localplayer.is_moving then
            add 'Moving'

            if localplayer.is_crouched then
                return
            end

            if software.is_slow_motion() then
                add 'Slow Walk'
            end

            return
        end

        add 'Standing'
    end

    local function update_crouched()
        if not localplayer.is_crouched then
            return
        end

        add 'Crouch'

        if localplayer.is_moving then
            add 'Move-Crouch'
        end
    end

    local function update_in_air()
        if localplayer.is_onground then
            return
        end

        add 'Jumping'

        if localplayer.is_crouched then
            add 'Jumping+'
        end
    end

    function statement.get()
        return list
    end

    local function on_setup_command()
        clear_list()

        update_onground()
        update_crouched()
        update_in_air()
    end

    client.set_event_callback(
        'setup_command',
        on_setup_command
    )
end

local resource do
    resource = { }

    local function fmt(str)
        local color_accent = software.get_color(true)
        local color_reset = 'FFFFFFC8'

        local replace = string.format('\a%s%%1\a%s', color_accent, color_reset)
        local result = string.gsub(str, '${(.-)}', replace)

        return result
    end

    local function new_key(str, key)
        if str:find '\n' == nil then
            str = str .. '\n'
        end

        return str .. key
    end

    local function lock_unselection(item, default_value)
        local old_value = item:get()

        if #old_value == 0 then
            if default_value == nil then
                if item.type == 'multiselect' then
                    default_value = item.list
                elseif item.type == 'list' then
                    default_value = { }

                    for i = 1, #item.list do
                        default_value[i] = i
                    end
                end
            end

            old_value = default_value
            item:set(default_value)
        end

        item:set_callback(function()
            local value = item:get()

            if #value > 0 then
                old_value = value
            else
                item:set(old_value)
            end
        end)
    end

    local general = { } do
        general.label = menu.new(
            ui.new_label, 'AA', 'Anti-aimbot angles', 'spectral'
        )

        general.category = menu.new(
            ui.new_combobox, 'AA', 'Anti-aimbot angles', '\n spectral.category', {
                'Configs',
                'Ragebot',
                'Anti-Aim',
                'Visuals',
                'Misc'
            }
        )

        general.welcome_text = menu.new(
            ui.new_label, 'AA', 'Anti-aimbot angles', '\n spectral.welcome_text'
        )

        local function update_welcome_text(item)
            local hex = utils.to_hex(
                ui.get(item)
            )

            general.welcome_text:set(string.format(
                '\a%swelcome to spectral, %s', hex, script.user
            ))
        end

        ui.set_callback(software.misc.settings.menu_color, update_welcome_text)
        update_welcome_text(software.misc.settings.menu_color)

        client.set_event_callback('paint_ui', function()
            if not ui.is_menu_open() then
                return
            end

            local min, max = 660, 750
            local width = ui.menu_size()

            local content_region = utils.map(width, min, max, 0, 1, true)

            local r1, g1, b1, a1 = 80, 80, 80, 255
            local r2, g2, b2, a2 = software.get_color()

            local name = string.format(
                '✧ %s ✧', script.name
            )

            local text = text_anims.gradient(
                name, -globals.realtime(),
                r1, g1, b1, a1, r2, g2, b2, a2
            )

            -- content fill
            text = string.rep('\u{0020}', utils.lerp(15, 22, content_region)) .. text

            general.label:set(text)
        end)
    end

    local config = { } do
        local DB_NAME = 'spectral#db'
        local DB_DATA = database.read(DB_NAME) or { }

        local config_data = { }
        local config_list = { }

        local config_defaults = {
            [1] = {
                name = 'default',
                data = 'spectral: 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_'
            }
        }

        for i = 1, #DB_DATA do
            config_data[i] = DB_DATA[i]
        end

        for i = #config_defaults, 1, -1 do
            local list = config_defaults[i]

            if list.data == nil then
                goto continue
            end

            local ok, result = config_system.decode(list.data)

            if not ok then
                -- config is not valid
                table.remove(config_defaults, i)

                goto continue
            end

            list.data = result
            ::continue::
        end

        local function create_config(name, data, is_default)
            local list = { }

            list.name = name
            list.data = data
            list.default = is_default

            return list
        end

        local function find_by_name(list, name)
            for i = 1, #list do
                local data = list[i]

                if data.name == name then
                    return data, i
                end
            end

            return nil, -1
        end

        local function save_config_data()
            database.write(DB_NAME, config_data)
        end

        local function update_config_list()
            for i = 1, #config_list do
                config_list[i] = nil
            end

            for i = 1, #config_defaults do
                local list = config_defaults[i]

                local cell = create_config(
                    list.name, list.data, true
                )

                table.insert(config_list, cell)
            end

            for i = 1, #config_data do
                local list = config_data[i]

                local cell = create_config(
                    list.name, list.data, false
                )

                cell.data_index = i

                table.insert(config_list, cell)
            end
        end

        local function get_render_list()
            local result = { }

            for i = 1, #config_list do
                local list = config_list[i]

                local name = list.name

                if list.default then
                    name = string.format(
                        '✦ %s', name
                    )
                end

                table.insert(result, name)
            end

            return result
        end

        local function find_config(name)
            return find_by_name(
                config_list, name
            )
        end

        local function load_config(name)
            local list, idx = find_config(name)

            if list == nil or idx == -1 then
                return
            end

            local ok, result = config_system.import(list.data)

            if not ok then
                return logging_system.error(string.format(
                    'failed to import %s config: %s', name, result
                ))
            end

            logging_system.success(string.format(
                'successfully loaded %s config', name
            ))
        end

        local function save_config(name)
            local cfg_data = config_system.export()

            local list, idx = find_config(name)

            if list == nil or idx == -1 then
                table.insert(config_data, create_config(
                    name, cfg_data, false
                ))

                save_config_data()
                update_config_list()

                config.list:update(
                    get_render_list()
                )

                return logging_system.success(string.format(
                    'successfully created %s config', name
                ))
            end

            if list.default then
                return logging_system.error(string.format(
                    'cannot modify %s config', name
                ))
            end

            list.data = cfg_data

            if list.data_index ~= nil then
                local data_cell = config_data[
                    list.data_index
                ]

                if data_cell ~= nil then
                    data_cell.data = cfg_data
                end
            end

            save_config_data()
            update_config_list()

            logging_system.success(string.format(
                'successfully modified %s config', name
            ))
        end

        local function delete_config(name)
            local list, idx = find_config(name)

            if list == nil or idx == -1 then
                return
            end

            if list.default then
                return logging_system.error(string.format(
                    'cannot delete %s config', name
                ))
            end

            local data_index = list.data_index

            if data_index == nil then
                return
            end

            table.remove(config_data, data_index)

            save_config_data()
            update_config_list()

            config.list:update(
                get_render_list()
            )

            local next_input = ''

            local index = math.min(
                config.list:get() + 1,
                #config_list
            )

            local data = config_list[index]

            if data ~= nil then
                next_input = data.name
            end

            config.input:set(next_input)

            logging_system.success(string.format(
                'successfully deleted %s config', name
            ))
        end

        config.list = menu.new(
            ui.new_listbox, 'AA', 'Anti-aimbot angles', '\n config.list', { }
        )

        config.input = menu.new(
            ui.new_textbox, 'AA', 'Anti-aimbot angles', '\n config.input', ''
        )

        config.load_button = menu.new(
            ui.new_button, 'AA', 'Anti-aimbot angles', 'load', function()
                local name = utils.trim(
                    config.input:get()
                )

                if name == '' then
                    return
                end

                load_config(name)
            end
        )

        config.save_button = menu.new(
            ui.new_button, 'AA', 'Anti-aimbot angles', 'save', function()
                local name = utils.trim(
                    config.input:get()
                )

                if name == '' then
                    return
                end

                save_config(name)
            end
        )

        config.delete_button = menu.new(
            ui.new_button, 'AA', 'Anti-aimbot angles', 'delete', function()
                local name = utils.trim(
                    config.input:get()
                )

                if name == '' then
                    return
                end

                delete_config(name)
            end
        )

        config.export_button = menu.new(
            ui.new_button, 'AA', 'Anti-aimbot angles', 'export', function()
                local ok, result = config_system.encode(
                    config_system.export()
                )

                if not ok then
                    return
                end

                clipboard.set(result)

                logging_system.success 'exported config to clipboard'
            end
        )

        config.import_button = menu.new(
            ui.new_button, 'AA', 'Anti-aimbot angles', 'import', function()
                local ok, result = config_system.decode(
                    clipboard.get()
                )

                if not ok then
                    return
                end

                config_system.import(result)

                logging_system.success 'imported config from clipboard'
            end
        )

        update_config_list()

        config.list:update(
            get_render_list()
        )

        config.list:set_callback(function(item)
            local index = item:get()

            if index == nil then
                return
            end

            local list = config_list[index + 1]

            if list == nil then
                return
            end

            config.input:set(list.name)
        end)

        resource.config = config
    end

    local ragebot = { } do
        local rage_enhancements = { } do
            rage_enhancements.enabled = config_system.push(
                'visuals', 'rage_enhancements.enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Rage enhancements'
                )
            )

            rage_enhancements.body_aim_lethal = config_system.push(
                'visuals', 'rage_enhancements.body_aim_lethal', menu.new(
                    ui.new_multiselect, 'AA', 'Anti-aimbot angles', 'Force body aim if lethal', {
                        'Scout',
                        'Awp',
                        'Auto',
                        'R8 revolver',
                        'Deagle',
                        'Other'
                    }
                )
            )

            rage_enhancements.safe_head_lethal = config_system.push(
                'visuals', 'rage_enhancements.safe_head_lethal', menu.new(
                    ui.new_multiselect, 'AA', 'Anti-aimbot angles', 'Force safe point if lethal', {
                        'Scout',
                        'Awp',
                        'Auto',
                        'R8 revolver',
                        'Deagle',
                        'Other'
                    }
                )
            )

            ragebot.rage_enhancements = rage_enhancements
        end

        local aimbot_logs = { } do
            aimbot_logs.enabled = config_system.push(
                'visuals', 'aimbot_logs.enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Aimbot logs'
                )
            )

            aimbot_logs.select = config_system.push(
                'visuals', 'aimbot_logs.select', menu.new(
                    ui.new_multiselect, 'AA', 'Anti-aimbot angles', new_key('Log selection', 'aimbot_logs'), {
                        'Screen',
                        'Console'
                    }
                )
            )

            aimbot_logs.color_hit = config_system.push(
                'visuals', 'aimbot_logs.color_hit', menu.new(
                    ui.new_color_picker, 'AA', 'Anti-aimbot angles', '\n aimbot_logs.color_hit', 150, 255, 125, 255
                )
            )

            aimbot_logs.color_miss = config_system.push(
                'visuals', 'aimbot_logs.color_miss', menu.new(
                    ui.new_color_picker, 'AA', 'Anti-aimbot angles', '\n aimbot_logs.color_miss', 255, 125, 150, 255
                )
            )

            aimbot_logs.glow = config_system.push(
                'visuals', 'aimbot_logs.glow', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Glow', 'aimbot_logs'), 0, 125, 100, true, '%'
                )
            )

            aimbot_logs.offset = config_system.push(
                'visuals', 'aimbot_logs.offset', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Offset', 'aimbot_logs'), 30, 325, 200, true, 'px', 2
                )
            )

            aimbot_logs.duration = config_system.push(
                'visuals', 'aimbot_logs.duration', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Duration', 'aimbot_logs'), 30, 80, 40, true, 's.', 0.1
                )
            )

            lock_unselection(aimbot_logs.select)

            ragebot.aimbot_logs = aimbot_logs
        end

        local defensive_fix = { } do
            defensive_fix.enabled = config_system.push(
                'visuals', 'defensive_fix.enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Defensive fix'
                )
            )

            ragebot.defensive_fix = defensive_fix
        end

        local recharge_fix = { } do
            recharge_fix.enabled = config_system.push(
                'visuals', 'recharge_fix.enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Recharge fix'
                )
            )

            ragebot.recharge_fix = recharge_fix
        end

        local jitter_fix = { } do
            jitter_fix.enabled = config_system.push(
                'visuals', 'jitter_fix.enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Jitter fix'
                )
            )

            ragebot.jitter_fix = jitter_fix
        end

        local jump_scout = { } do
            jump_scout.enabled = config_system.push(
                'visuals', 'jump_scout.enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Jump scout'
                )
            )

            ragebot.jump_scout = jump_scout
        end

        resource.ragebot = ragebot
    end

    local antiaim = { } do
        local function create_defensive_items(name)
            local items = { }

            local function hash(key)
                return name .. ':defensive_' .. key
            end

            local function fmt_key(key)
                return new_key(fmt(key), hash(key))
            end

            items.force_break_lc = config_system.push(
                'antiaim', hash 'force_break_lc', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', new_key(
                        'Force break lc', hash 'force_break_lc'
                    )
                )
            )

            items.enabled = config_system.push(
                'antiaim', hash 'enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', new_key(
                        'Defensive anti-aim', hash 'enabled'
                    )
                )
            )

            items.pitch = config_system.push(
                'antiaim', hash 'pitch', menu.new(
                    ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('Pitch', hash 'pitch'), {
                        'Off',
                        'Static',
                        'Jitter',
                        'Spin',
                        'Random'
                    }
                )
            )

            items.pitch_label_1 = menu.new(
                ui.new_label, 'AA', 'Anti-aimbot angles', 'From'
            )

            items.pitch_offset_1 = config_system.push(
                'antiaim', hash 'pitch_offset_1', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('\n', hash 'pitch_offset_1'), -89, 89, 0, true, '°'
                )
            )

            items.pitch_label_2 = menu.new(
                ui.new_label, 'AA', 'Anti-aimbot angles', 'To'
            )

            items.pitch_offset_2 = config_system.push(
                'antiaim', hash 'pitch_offset_2', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('\n', hash 'pitch_offset_2'), -89, 89, 0, true, '°'
                )
            )

            items.pitch_speed = config_system.push(
                'antiaim', hash 'pitch_speed', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Speed', hash 'pitch_speed'), -50, 50, 20, true, nil, 0.1
                )
            )

            items.yaw = config_system.push(
                'antiaim', hash 'yaw', menu.new(
                    ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('Yaw', hash 'yaw'), {
                        'Off',
                        'Static',
                        'Static LR',
                        'Spin',
                        'Random'
                    }
                )
            )

            items.yaw_left = config_system.push(
                'antiaim', hash 'yaw_left', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Yaw left', hash 'yaw_left'), -180, 180, 0, true, '°'
                )
            )

            items.yaw_right = config_system.push(
                'antiaim', hash 'yaw_right', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Yaw right', hash 'yaw_right'), -180, 180, 0, true, '°'
                )
            )

            items.yaw_offset = config_system.push(
                'antiaim', hash 'yaw_offset', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('\n', hash 'yaw_offset'), 0, 360, 0, true, '°'
                )
            )

            items.yaw_speed = config_system.push(
                'antiaim', hash 'yaw_speed', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Speed', hash 'yaw_speed'), -50, 50, 20, true, '', 0.1
                )
            )

            items.yaw_modifier = config_system.push(
                'antiaim', hash 'yaw_modifier', menu.new(
                    ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('Yaw modifier', hash 'yaw_modifier'), {
                        'Off',
                        'Offset',
                        'Center',
                        'Skitter'
                    }
                )
            )

            items.modifier_offset = config_system.push(
                'antiaim', hash 'modifier_offset', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('\n', hash 'modifier_offset'), -180, 180, 0, true, '°'
                )
            )

            items.body_yaw = config_system.push(
                'antiaim', hash 'modifier_delay_2', menu.new(
                    ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('Body yaw', hash 'body_yaw'), {
                        'Off',
                        'Opposite',
                        'Static',
                        'Jitter'
                    }
                )
            )

            items.body_yaw_offset = config_system.push(
                'antiaim', hash 'body_yaw_offset', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('\n', hash 'body_yaw_offset'), -180, 180, 0, true, '°'
                )
            )

            items.freestanding_body_yaw = config_system.push(
                'antiaim', hash 'freestanding_body_yaw', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', new_key('Freestanding body yaw', hash 'freestanding_body_yaw')
                )
            )

            items.delay_1 = config_system.push(
                'antiaim', hash 'delay_1', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Delay from', hash 'delay_1'), 1, 14, 0, true, 't'
                )
            )

            items.delay_2 = config_system.push(
                'antiaim', hash 'delay_2', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Delay to', hash 'delay_2'), 1, 14, 0, true, 't'
                )
            )

            return items
        end

        local function create_builder_items(name, std_key)
            local items = { }

            local is_default = name == 'Default'
            local is_legit_aa = name == 'Legit AA'

            local function hash(key)
                return name .. ':' .. key
            end

            local function fmt_key(key)
                return new_key(fmt(key), hash(key))
            end

            if std_key ~= nil then
                function hash(key)
                    return name .. ':' .. key .. ':' .. std_key
                end
            end

            if not is_default then
                local enabled_name = string.format(
                    'Redefine %s', name
                )

                items.enabled = config_system.push(
                    'antiaim', hash 'enabled', menu.new(
                        ui.new_checkbox, 'AA', 'Anti-aimbot angles', new_key(
                            enabled_name, hash 'enabled'
                        )
                    )
                )
            end

            if not is_legit_aa then
                items.pitch = config_system.push(
                    'antiaim', hash 'pitch', menu.new(
                        ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('Pitch', hash 'pitch'), {
                            'Off',
                            'Default',
                            'Up',
                            'Down',
                            'Minimal',
                            'Random',
                            'Custom'
                        }
                    )
                )

                items.pitch_offset = config_system.push(
                    'antiaim', hash 'pitch_offset', menu.new(
                        ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('\n', hash 'pitch_offset'), -89, 89, 0, true, '°'
                    )
                )

                items.pitch:set 'Default'
            end

            if name ~= 'Freestanding' then
                items.yaw = config_system.push(
                    'antiaim', hash 'yaw', menu.new(
                        ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('Yaw', hash 'yaw'), {
                            'Off',
                            '180',
                            '180 LR',
                            'Spin',
                            'Static',
                            '180 Z',
                            'Crosshair'
                        }
                    )
                )

                items.yaw_offset = config_system.push(
                    'antiaim', hash 'yaw_offset', menu.new(
                        ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('\n', hash 'yaw_offset'), -180, 180, 0, true, '°'
                    )
                )

                items.yaw_left = config_system.push(
                    'antiaim', hash 'yaw_left', menu.new(
                        ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Yaw left', hash 'yaw_left'), -180, 180, 0, true, '°'
                    )
                )

                items.yaw_right = config_system.push(
                    'antiaim', hash 'yaw_right', menu.new(
                        ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Yaw right', hash 'yaw_right'), -180, 180, 0, true, '°'
                    )
                )

                items.yaw_asynced = config_system.push(
                    'antiaim', hash 'yaw_asynced', menu.new(
                        ui.new_checkbox, 'AA', 'Anti-aimbot angles', new_key('Asynced', hash 'yaw_asynced')
                    )
                )

                items.yaw_jitter = config_system.push(
                    'antiaim', hash 'yaw_jitter', menu.new(
                        ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('Yaw jitter', hash 'yaw_jitter'), {
                            'Off',
                            'Offset',
                            'Center',
                            'Random',
                            'Skitter'
                        }
                    )
                )

                items.jitter_offset = config_system.push(
                    'antiaim', hash 'jitter_offset', menu.new(
                        ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('\n', hash 'jitter_offset'), -180, 180, 0, true, '°'
                    )
                )

                items.yaw:set '180'
            end

            items.body_yaw = config_system.push(
                'antiaim', hash 'body_yaw', menu.new(
                    ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('Body yaw', hash 'body_yaw'), {
                        'Off',
                        'Opposite',
                        'Static',
                        'Jitter'
                    }
                )
            )

            items.body_yaw_offset = config_system.push(
                'antiaim', hash 'body_yaw_offset', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('\n', hash 'body_yaw_offset'), -180, 180, 0, true, '°'
                )
            )

            items.freestanding_body_yaw = config_system.push(
                'antiaim', hash 'freestanding_body_yaw', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', new_key(
                        'Freestanding body yaw', hash 'freestanding_body_yaw'
                    )
                )
            )

            if name ~= 'Fakelag' then
                items.delay = config_system.push(
                    'antiaim', hash 'delay', menu.new(
                        ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Delay', hash 'delay'), 1, 8, 1, true, 't', 1, {
                            [1] = 'Off'
                        }
                    )
                )
            end

            return items
        end

        antiaim.select = menu.new(
            ui.new_combobox, 'AA', 'Anti-aimbot angles', '\n antiaim.select', {
                'Builder',
                'Settings'
            }
        )

        local builder = { } do
            builder.state = menu.new(
                ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('State', 'builder'), const.states
            )

            for i = 1, #const.states do
                local state = const.states[i]

                local items = create_builder_items(state)

                if state ~= 'Fakelag' then
                    items.separator = menu.new(
                        ui.new_label, 'AA', 'Anti-aimbot angles', new_key('\n', 'separator')
                    )

                    items.defensive = create_defensive_items(state)
                end

                builder[state] = items
            end

            antiaim.builder = builder
        end

        local settings = { } do
            local avoid_backstab = { } do
                avoid_backstab.enabled = config_system.push(
                    'antiaim', 'avoid_backstab.enabled', menu.new(
                        ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Avoid backstab'
                    )
                )

                settings.avoid_backstab = avoid_backstab
            end

            local freestanding = { } do
                freestanding.enabled = config_system.push(
                    'antiaim', 'freestanding.enabled', menu.new(
                        ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Freestanding'
                    )
                )

                freestanding.hotkey = config_system.push(
                    'antiaim', 'freestanding.hotkey', menu.new(
                        ui.new_hotkey, 'AA', 'Anti-aimbot angles', '\n freestanding.hotkey', true
                    )
                )

                settings.freestanding = freestanding
            end

            local manual_yaw = { } do
                manual_yaw.enabled = config_system.push(
                    'antiaim', 'manual_yaw.enabled', menu.new(
                        ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Manual yaw'
                    )
                )

                manual_yaw.disable_yaw_modifiers = config_system.push(
                    'antiaim', 'manual_yaw.disable_yaw_modifiers', menu.new(
                        ui.new_checkbox, 'AA', 'Anti-aimbot angles', new_key('Disable yaw modifiers', 'manual_yaw')
                    )
                )

                manual_yaw.body_freestanding = config_system.push(
                    'antiaim', 'manual_yaw.body_freestanding', menu.new(
                        ui.new_checkbox, 'AA', 'Anti-aimbot angles', new_key('Body freestanding', 'manual_yaw')
                    )
                )

                manual_yaw.left_hotkey = config_system.push(
                    'antiaim', 'manual_yaw.left_hotkey', menu.new(
                        ui.new_hotkey, 'AA', 'Anti-aimbot angles', new_key(
                            'Left manual', 'manual_yaw'
                        )
                    )
                )

                manual_yaw.right_hotkey = config_system.push(
                    'antiaim', 'manual_yaw.right_hotkey', menu.new(
                        ui.new_hotkey, 'AA', 'Anti-aimbot angles', new_key(
                            'Right manual', 'manual_yaw'
                        )
                    )
                )

                manual_yaw.forward_hotkey = config_system.push(
                        'antiaim', 'manual_yaw.forward_hotkey', menu.new(
                        ui.new_hotkey, 'AA', 'Anti-aimbot angles', new_key(
                            'Forward manual', 'manual_yaw'
                        )
                    )
                )

                manual_yaw.backward_hotkey = config_system.push(
                    'antiaim', 'manual_yaw.backward_hotkey', menu.new(
                        ui.new_hotkey, 'AA', 'Anti-aimbot angles', new_key(
                            'Backward manual', 'manual_yaw'
                        )
                    )
                )

                manual_yaw.reset_hotkey = config_system.push(
                    'antiaim', 'manual_yaw.reset_hotkey', menu.new(
                        ui.new_hotkey, 'AA', 'Anti-aimbot angles', new_key(
                            'Reset manual', 'manual_yaw'
                        )
                    )
                )

                manual_yaw.left_hotkey:set 'Toggle'
                manual_yaw.right_hotkey:set 'Toggle'
                manual_yaw.forward_hotkey:set 'Toggle'
                manual_yaw.backward_hotkey:set 'Toggle'

                manual_yaw.reset_hotkey:set 'On hotkey'

                settings.manual_yaw = manual_yaw
            end

            local defensive_flick = { } do
                defensive_flick.enabled = config_system.push(
                    'antiaim', 'defensive_flick.enabled', menu.new(
                        ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Defensive flick'
                    )
                )

                defensive_flick.states = config_system.push(
                    'antiaim', 'defensive_flick.inverter', menu.new(
                        ui.new_multiselect, 'AA', 'Anti-aimbot angles', new_key('States', 'defensive_flick'), {
                            'Standing',
                            'Slow Walk',
                            'Jumping',
                            'Jumping+',
                            'Crouch',
                            'Move-Crouch'
                        }
                    )
                )

                defensive_flick.inverter = config_system.push(
                    'antiaim', 'defensive_flick.inverter', menu.new(
                        ui.new_hotkey, 'AA', 'Anti-aimbot angles', new_key('Inverter', 'defensive_flick')
                    )
                )

                lock_unselection(defensive_flick.states, {
                    'Standing',
                    'Crouch'
                })

                settings.defensive_flick = defensive_flick
            end

            antiaim.settings = settings
        end

        resource.antiaim = antiaim
    end

    local visuals = { } do
        local watermark = { } do
            watermark.select = config_system.push(
                'visuals', 'watermark.enabled', menu.new(
                    ui.new_combobox, 'AA', 'Anti-aimbot angles', 'Watermark', {
                        'Default',
                        'Alternative'
                    }
                )
            )

            watermark.color = config_system.push(
                'visuals', 'watermark.color', menu.new(
                    ui.new_color_picker, 'AA', 'Anti-aimbot angles', '\n watermark.color', 0, 255, 255, 255
                )
            )

            visuals.watermark = watermark
        end

        local indicators = { } do
            indicators.enabled = config_system.push(
                'visuals', 'indicators.enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Indicators'
                )
            )

            indicators.style = config_system.push(
                'visuals', 'indicators.style', menu.new(
                    ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('Style', 'indicators'), {
                        'Default',
                        'Sparkles'
                    }
                )
            )

            indicators.color_accent = config_system.push(
                'visuals', 'indicators.color_accent', menu.new(
                    ui.new_color_picker, 'AA', 'Anti-aimbot angles', '\n indicators.color_accent', 0, 255, 255, 255
                )
            )

            indicators.color_secondary = config_system.push(
                'visuals', 'indicators.color_secondary', menu.new(
                    ui.new_color_picker, 'AA', 'Anti-aimbot angles', '\n indicators.color_secondary', 255, 255, 255, 255
                )
            )

            indicators.offset = config_system.push(
                'visuals', 'indicators.offset', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Offset', 'indicators'), 3, 40, 11, true, 'px', 2
                )
            )

            visuals.indicators = indicators
        end

        local manual_arrows = { } do
            manual_arrows.enabled = config_system.push(
                'visuals', 'manual_arrows.enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Manual arrows'
                )
            )

            manual_arrows.style = config_system.push(
                'visuals', 'manual_arrows.style', menu.new(
                    ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('Style', 'manual_arrows'), {
                        'Default',
                        'Alternative'
                    }
                )
            )

            manual_arrows.color_accent = config_system.push(
                'visuals', 'manual_arrows.color_accent', menu.new(
                    ui.new_color_picker, 'AA', 'Anti-aimbot angles', '\n manual_arrows.color_accent', 255, 255, 255, 200
                )
            )

            manual_arrows.color_secondary = config_system.push(
                'visuals', 'manual_arrows.color_secondary', menu.new(
                    ui.new_color_picker, 'AA', 'Anti-aimbot angles', '\n manual_arrows.color_secondary', 255, 255, 255, 200
                )
            )

            visuals.manual_arrows = manual_arrows
        end

        local velocity_warning = { } do
            velocity_warning.enabled = config_system.push(
                'visuals', 'velocity_warning.enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Velocity warning'
                )
            )

            velocity_warning.color = config_system.push(
                'visuals', 'velocity_warning.color', menu.new(
                    ui.new_color_picker, 'AA', 'Anti-aimbot angles', '\n velocity_warning.color', 0, 255, 255, 255
                )
            )

            velocity_warning.offset = config_system.push(
                'visuals', 'velocity_warning.color', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Offset', 'velocity_warning'), 30, 250, 125, true, 'px', 2
                )
            )

            visuals.velocity_warning = velocity_warning
        end

        resource.visuals = visuals
    end

    local misc = { } do
        local increase_ladder_movement = { } do
            increase_ladder_movement.enabled = config_system.push(
                'visuals', 'increase_ladder_movement.enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Increase ladder movement'
                )
            )

            misc.increase_ladder_movement = increase_ladder_movement
        end

        local animation_breaker = { } do
            animation_breaker.enabled = config_system.push(
                'visuals', 'animation_breaker.enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Animation breaker'
                )
            )

            animation_breaker.in_air_legs = config_system.push(
                'visuals', 'animation_breaker.in_air_legs', menu.new(
                    ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('In-air legs', 'animation_breaker'), {
                        'Off',
                        'Static',
                        'Alien'
                    }
                )
            )

            animation_breaker.onground_legs = config_system.push(
                'visuals', 'animation_breaker.onground_legs', menu.new(
                    ui.new_combobox, 'AA', 'Anti-aimbot angles', new_key('On-ground legs', 'animation_breaker'), {
                        'Off',
                        'Static',
                        'Jitter',
                        'Alien'
                    }
                )
            )

            animation_breaker.adjust_lean = config_system.push(
                'visuals', 'animation_breaker.adjust_lean', menu.new(
                    ui.new_slider, 'AA', 'Anti-aimbot angles', new_key('Adjust lean', 'animation_breaker'), 0, 100, 0, true, '%', 1, {
                        [0] = 'Off'
                    }
                )
            )

            animation_breaker.pitch_on_land = config_system.push(
                'visuals', 'animation_breaker.pitch_on_land', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', new_key('Pitch on land', 'animation_breaker')
                )
            )

            animation_breaker.freeburger = config_system.push(
                'visuals', 'animation_breaker.freeburger', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', new_key('Freeburger', 'animation_breaker')
                )
            )

            misc.animation_breaker = animation_breaker
        end

        local walking_on_quick_peek = { } do
            walking_on_quick_peek.enabled = config_system.push(
                'visuals', 'walking_on_quick_peek.enabled', menu.new(
                    ui.new_checkbox, 'AA', 'Anti-aimbot angles', 'Walking on quick peek'
                )
            )

            misc.walking_on_quick_peek = walking_on_quick_peek
        end

        resource.misc = misc
    end

    local scene do
        local function set_antiaimbot_display(value)
            local items = software.antiaimbot.angles

            local pitch_value = ui.get(items.pitch[1])
            local yaw_value = ui.get(items.yaw[1])
            local body_yaw_value = ui.get(items.body_yaw[1])

            ui.set_visible(items.enabled, value)
            ui.set_visible(items.pitch[1], value)

            if pitch_value == 'Custom' then
                ui.set_visible(items.pitch[2], value)
            end

            ui.set_visible(items.yaw_base, value)
            ui.set_visible(items.yaw[1], value)

            if yaw_value ~= 'Off' then
                local yaw_jitter_value = ui.get(items.yaw_jitter[1])

                ui.set_visible(items.yaw[2], value)
                ui.set_visible(items.yaw_jitter[1], value)

                if yaw_jitter_value ~= 'Off' then
                    ui.set_visible(items.yaw_jitter[2], value)
                end
            end

            ui.set_visible(items.body_yaw[1], value)

            if body_yaw_value ~= 'Off' then
                if body_yaw_value ~= 'Opposite' then
                    ui.set_visible(items.body_yaw[2], value)
                end

                ui.set_visible(items.freestanding_body_yaw, value)
            end

            ui.set_visible(items.edge_yaw, value)

            ui.set_visible(items.freestanding[1], value)
            ui.set_visible(items.freestanding[2], value)

            ui.set_visible(items.roll, value)
        end

        local function update_builder_items(items)
            local defensive = items.defensive

            if items.enabled ~= nil then
                menu_logic.set(items.enabled, true)

                if not items.enabled:get() then
                    return
                end
            end

            if items.pitch ~= nil then
                menu_logic.set(items.pitch, true)

                if items.pitch:get() == 'Custom' then
                    menu_logic.set(items.pitch_offset, true)
                end
            end

            if items.yaw ~= nil then
                menu_logic.set(items.yaw, true)

                if items.yaw:get() ~= 'Off' then
                    if items.yaw:get() == '180 LR' then
                        menu_logic.set(items.yaw_left, true)
                        menu_logic.set(items.yaw_right, true)

                        menu_logic.set(items.yaw_asynced, true)
                    else
                        menu_logic.set(items.yaw_offset, true)
                    end

                    menu_logic.set(items.yaw_jitter, true)

                    if items.yaw_jitter:get() ~= 'Off' then
                        menu_logic.set(items.jitter_offset, true)
                    end
                end
            end

            menu_logic.set(items.body_yaw, true)

            if items.body_yaw:get() ~= 'Off' then
                if items.body_yaw:get() ~= 'Opposite' then
                    menu_logic.set(items.body_yaw_offset, true)
                end

                menu_logic.set(items.freestanding_body_yaw, true)

                if items.body_yaw:get() == 'Jitter' then
                    menu_logic.set(items.delay, true)
                end
            end

            if items.separator ~= nil then
                menu_logic.set(items.separator, true)
            end

            if defensive ~= nil then
                if defensive.force_break_lc ~= nil then
                    menu_logic.set(defensive.force_break_lc, true)
                end

                menu_logic.set(defensive.enabled, true)

                if defensive.enabled:get() then
                    menu_logic.set(defensive.pitch, true)

                    if defensive.pitch:get() ~= 'Off' then
                        menu_logic.set(defensive.pitch_offset_1, true)

                        if defensive.pitch:get() ~= 'Static' then
                            menu_logic.set(defensive.pitch_label_1, true)
                            menu_logic.set(defensive.pitch_label_2, true)

                            menu_logic.set(defensive.pitch_offset_2, true)
                        end

                        if defensive.pitch:get() == 'Spin' then
                            menu_logic.set(defensive.pitch_speed, true)
                        end
                    end

                    menu_logic.set(defensive.yaw, true)

                    if defensive.yaw:get() ~= 'Off' then
                        if defensive.yaw:get() == 'Static LR' then
                            menu_logic.set(defensive.yaw_left, true)
                            menu_logic.set(defensive.yaw_right, true)
                        else
                            menu_logic.set(defensive.yaw_offset, true)
                        end

                        if defensive.yaw:get() == 'Spin' then
                            menu_logic.set(defensive.yaw_speed, true)
                        end

                        menu_logic.set(defensive.yaw_modifier, true)

                        if defensive.yaw_modifier:get() ~= 'Off' then
                            menu_logic.set(defensive.modifier_offset, true)
                        end
                    end

                    menu_logic.set(defensive.body_yaw, true)

                    if defensive.body_yaw:get() ~= 'Off' then
                        if defensive.body_yaw:get() ~= 'Opposite' then
                            menu_logic.set(defensive.body_yaw_offset, true)
                        end

                        menu_logic.set(defensive.freestanding_body_yaw, true)

                        if defensive.body_yaw:get() == 'Jitter' then
                            menu_logic.set(defensive.delay_1, true)
                            menu_logic.set(defensive.delay_2, true)
                        end
                    end
                end
            end
        end

        local function force_update_scene()
            menu_logic.set(general.label, true)

            local category = general.category:get()
            menu_logic.set(general.category, true)

            if category == 'Configs' then
                menu_logic.set(general.welcome_text, true)

                menu_logic.set(config.list, true)
                menu_logic.set(config.input, true)

                menu_logic.set(config.load_button, true)
                menu_logic.set(config.save_button, true)
                menu_logic.set(config.delete_button, true)
                menu_logic.set(config.import_button, true)
                menu_logic.set(config.export_button, true)
            end

            if category == 'Ragebot' then
                local is_aimbot_logs = ragebot.aimbot_logs.enabled:get() do
                    menu_logic.set(ragebot.aimbot_logs.enabled, true)

                    if not is_aimbot_logs then
                        goto continue
                    end

                    menu_logic.set(ragebot.aimbot_logs.select, true)

                    if ragebot.aimbot_logs.select:get 'Screen' then
                        menu_logic.set(ragebot.aimbot_logs.color_hit, true)
                        menu_logic.set(ragebot.aimbot_logs.color_miss, true)

                        menu_logic.set(ragebot.aimbot_logs.glow, true)
                        menu_logic.set(ragebot.aimbot_logs.offset, true)
                        menu_logic.set(ragebot.aimbot_logs.duration, true)
                    end

                    ::continue::
                end

                local is_rage_enhancements = ragebot.rage_enhancements.enabled:get() do
                    menu_logic.set(ragebot.rage_enhancements.enabled, true)

                    if not is_rage_enhancements then
                        goto continue
                    end

                    menu_logic.set(ragebot.rage_enhancements.body_aim_lethal, true)
                    menu_logic.set(ragebot.rage_enhancements.safe_point_lethal, true)

                    ::continue::
                end

                menu_logic.set(ragebot.recharge_fix.enabled, true)
                menu_logic.set(ragebot.jitter_fix.enabled, true)
                menu_logic.set(ragebot.jump_scout.enabled, true)
            end

            if category == 'Anti-Aim' then
                local select = antiaim.select:get()
                menu_logic.set(antiaim.select, true)

                if select == 'Builder' then
                    local ref = antiaim.builder

                    local state = ref.state:get()
                    menu_logic.set(ref.state, true)

                    local items = ref[state]

                    if items == nil then
                        goto continue
                    end

                    update_builder_items(items)

                    ::continue::
                end

                if select == 'Settings' then
                    local ref = antiaim.settings

                    menu_logic.set(ref.avoid_backstab.enabled, true)

                    local is_freestanding = ref.freestanding.enabled:get() do
                        menu_logic.set(ref.freestanding.enabled, true)
                        menu_logic.set(ref.freestanding.hotkey, true)

                        if not is_freestanding then
                            goto continue
                        end

                        ::continue::
                    end

                    local is_manual_yaw = ref.manual_yaw.enabled:get() do
                        menu_logic.set(ref.manual_yaw.enabled, true)

                        if not is_manual_yaw then
                            goto continue
                        end

                        menu_logic.set(ref.manual_yaw.disable_yaw_modifiers, true)
                        menu_logic.set(ref.manual_yaw.body_freestanding, true)

                        menu_logic.set(ref.manual_yaw.left_hotkey, true)
                        menu_logic.set(ref.manual_yaw.right_hotkey, true)
                        menu_logic.set(ref.manual_yaw.forward_hotkey, true)
                        menu_logic.set(ref.manual_yaw.backward_hotkey, true)
                        menu_logic.set(ref.manual_yaw.reset_hotkey, true)

                        ::continue::
                    end

                    local is_defensive_flick = ref.defensive_flick.enabled:get() do
                        menu_logic.set(ref.defensive_flick.enabled, true)

                        if not is_defensive_flick then
                            goto continue
                        end

                        menu_logic.set(ref.defensive_flick.states, true)
                        menu_logic.set(ref.defensive_flick.inverter, true)

                        ::continue::
                    end
                end
            end

            if category == 'Visuals' then
                local watermark_value = visuals.watermark.select:get() do
                    menu_logic.set(visuals.watermark.select, true)

                    if watermark_value == 'Alternative' then
                        menu_logic.set(visuals.watermark.color, true)
                    end
                end

                local is_indicators = visuals.indicators.enabled:get() do
                    menu_logic.set(visuals.indicators.enabled, true)

                    if not is_indicators then
                        goto continue
                    end

                    menu_logic.set(visuals.indicators.style, true)

                    menu_logic.set(visuals.indicators.color_accent, true)
                    menu_logic.set(visuals.indicators.color_secondary, true)

                    menu_logic.set(visuals.indicators.offset, true)

                    ::continue::
                end

                local is_velocity_warning = visuals.velocity_warning.enabled:get() do
                    menu_logic.set(visuals.velocity_warning.enabled, true)
                    menu_logic.set(visuals.velocity_warning.color, true)

                    if not is_velocity_warning then
                        goto continue
                    end

                    menu_logic.set(visuals.velocity_warning.offset, true)

                    ::continue::
                end
            end

            if category == 'Misc' then
                menu_logic.set(misc.increase_ladder_movement.enabled, true)

                local is_animation_breaker = misc.animation_breaker.enabled:get() do
                    menu_logic.set(misc.animation_breaker.enabled, true)

                    if not is_animation_breaker then
                        goto continue
                    end

                    menu_logic.set(misc.animation_breaker.in_air_legs, true)
                    menu_logic.set(misc.animation_breaker.onground_legs, true)
                    menu_logic.set(misc.animation_breaker.adjust_lean, true)
                    menu_logic.set(misc.animation_breaker.pitch_on_land, true)
                    menu_logic.set(misc.animation_breaker.freeburger, true)

                    ::continue::
                end

                menu_logic.set(misc.walking_on_quick_peek.enabled, true)
            end
        end

        local function on_shutdown()
            set_antiaimbot_display(true)
        end

        local function on_paint_ui()
            set_antiaimbot_display(false)
        end

        local logic_events = menu_logic.get_event_bus() do
            logic_events.update:set(force_update_scene)

            force_update_scene()
            menu_logic.force_update()
        end

        client.set_event_callback('shutdown', on_shutdown)
        client.set_event_callback('paint_ui', on_paint_ui)
    end
end

local override do
    override = { }

    local item_data = { }

    local e_hotkey_mode = {
        [0] = 'Always on',
        [1] = 'On hotkey',
        [2] = 'Toggle',
        [3] = 'Off hotkey'
    }

    local function get_value(item)
        local type = ui.type(item)
        local value = { ui.get(item) }

        if type == 'hotkey' then
            local mode = e_hotkey_mode[value[2]]
            local keycode = value[3] or 0

            return { mode, keycode }
        end

        return value
    end

    function override.get(item)
        local value = item_data[item]

        if value == nil then
            return nil
        end

        return unpack(value)
    end

    function override.set(item, ...)
        if item_data[item] == nil then
            item_data[item] = get_value(item)
        end

        ui.set(item, ...)
    end

    function override.unset(item)
        local value = item_data[item]

        if value == nil then
            return
        end

        ui.set(item, unpack(value))
        item_data[item] = nil
    end
end

local ragebot do
    ragebot = { }

    local item_data = { }

    local ref_weapon_type = ui.reference(
        'Rage', 'Weapon type', 'Weapon type'
    )

    local e_hotkey_mode = {
        [0] = 'Always on',
        [1] = 'On hotkey',
        [2] = 'Toggle',
        [3] = 'Off hotkey'
    }

    local function get_value(item)
        local type = ui.type(item)
        local value = { ui.get(item) }

        if type == 'hotkey' then
            local mode = e_hotkey_mode[value[2]]
            local keycode = value[3] or 0

            return { mode, keycode }
        end

        return value
    end

    function ragebot.set(item, ...)
        local weapon_type = ui.get(ref_weapon_type)

        if item_data[item] == nil then
            item_data[item] = { }
        end

        local data = item_data[item]

        if data[weapon_type] == nil then
            data[weapon_type] = {
                type = weapon_type,
                value = get_value(item)
            }
        end

        ui.set(item, ...)
    end

    function ragebot.unset(item)
        local data = item_data[item]

        if data == nil then
            return
        end

        local weapon_type = ui.get(ref_weapon_type)

        for k, v in pairs(data) do
            ui.set(ref_weapon_type, v.type)
            ui.set(item, unpack(v.value))

            data[k] = nil
        end

        ui.set(ref_weapon_type, weapon_type)
        item_data[item] = nil
    end
end


local motion do
    motion = { }

    local function linear(t, b, c, d)
        return c * t / d + b
    end

    local function get_deltatime()
        return globals.frametime()
    end

    local function solve(easing_fn, prev, new, clock, duration)
        if clock <= 0 then return new end
        if clock >= duration then return new end

        prev = easing_fn(clock, prev, new - prev, duration)

        if type(prev) == 'number' then
            if math.abs(new - prev) < 0.001 then
                return new
            end

            local remainder = prev % 1.0

            if remainder < 0.001 then
                return math.floor(prev)
            end

            if remainder > 0.999 then
                return math.ceil(prev)
            end
        end

        return prev
    end

    function motion.interp(a, b, t, easing_fn)
        easing_fn = easing_fn or linear

        if type(b) == 'boolean' then
            b = b and 1 or 0
        end

        return solve(easing_fn, a, b, get_deltatime(), t)
    end
end

local color do
    color = ffi.typeof [[
        struct {
            unsigned char r;
            unsigned char g;
            unsigned char b;
            unsigned char a;
        }
    ]]

    local M = { } do
        M.__index = M

        function M.lerp(a, b, t)
            return color(
                a.r + t * (b.r - a.r),
                a.g + t * (b.g - a.g),
                a.b + t * (b.b - a.b),
                a.a + t * (b.a - a.a)
            )
        end

        function M:unpack()
            return self.r, self.g, self.b, self.a
        end

        function M:clone()
            return color(self:unpack())
        end

        function M:__tostring()
            return string.format(
                '%i, %i, %i, %i',
                self:unpack()
            )
        end
    end

    ffi.metatype(color, M)
end

local render do
    render = { }

    local function sign(x)
        if x > 0 then
            return 1
        end

        if x < 0 then
            return -1
        end

        return 0
    end

    local function interpolate_colors(color1, color2, factor)
        local temp_array, temp_array_count = { }, 1
        local color3 = { color1[1], color1[2], color1[3], color1[4] }

        for i = 1, 4 do
            temp_array[temp_array_count] = tonumber(('%.0f'):format(
                color3[i] + factor * (color2[i] - color1[i])
            ))

            temp_array_count = temp_array_count + 1
        end

        return temp_array
    end

    local function interpolate_colors_range(color1, color2, steps)
        local factor = 1 / (steps - 1)
        local temp_array, temp_array_count = { }, 1

        for i = 0, steps-1 do
            temp_array[temp_array_count] = interpolate_colors(color1, color2, factor*i)
            temp_array_count = temp_array_count + 1
        end

        return temp_array
    end

    function render.glow(x, y, w, h, r, g, b, a, radius, steps, range)
        steps = math.max(2, steps)
        range = range or 1.0

        local outline_thickness = 1

        local colors = interpolate_colors_range(
            { r, g, b, 0 },
            { r, g, b, a * range },
            steps
        )

        for i = 1, steps do
            renderer.circle_outline(x + radius, y + radius, colors[i][1], colors[i][2], colors[i][3], colors[i][4], radius+outline_thickness+(steps-i), 180, 0.25, 1)
            renderer.circle_outline(x + w - radius, y + radius, colors[i][1], colors[i][2], colors[i][3], colors[i][4], radius+outline_thickness+(steps-i), 270, 0.25, 1)
            renderer.circle_outline(x + w - radius, y + h - radius, colors[i][1], colors[i][2], colors[i][3], colors[i][4], radius+outline_thickness+(steps-i), 0, 0.25, 1)
            renderer.circle_outline(x + radius, y + h - radius, colors[i][1], colors[i][2], colors[i][3], colors[i][4], radius+outline_thickness+(steps-i), 90, 0.25, 1)

            renderer.rectangle(x + w + i - 1, y + radius, 1, h - 2 * radius, colors[steps-i+1][1], colors[steps-i+1][2], colors[steps-i+1][3], colors[steps-i+1][4])
            renderer.rectangle(x - i, y + radius, 1, h - 2 * radius, colors[steps-i+1][1], colors[steps-i+1][2], colors[steps-i+1][3], colors[steps-i+1][4])

            renderer.rectangle(x + radius, y - i, w - 2 * radius, 1, colors[steps-i+1][1], colors[steps-i+1][2], colors[steps-i+1][3], colors[steps-i+1][4])
            renderer.rectangle(x + radius, y + h + i - 1, w - 2 * radius, 1, colors[steps-i+1][1], colors[steps-i+1][2], colors[steps-i+1][3], colors[steps-i+1][4])
        end
    end

    function render.rectangle_outline(x, y, w, h, r, g, b, a, thickness, radius)
        if thickness == nil or thickness == 0 then
            thickness = 1
        end

        if radius == nil then
            radius = 0
        end

        local wt = sign(w) * thickness
        local ht = sign(h) * thickness

        local pad = radius == 1 and 1 or 0

        local pad_2 = pad * 2
        local radius_2 = radius * 2

        renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
        renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
        renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, 270, 0.25, thickness)
        renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)

        renderer.rectangle(x, y + radius, wt, h - radius_2, r, g, b, a)
        renderer.rectangle(x + w, y + radius, -wt, h - radius_2, r, g, b, a)

        renderer.rectangle(x + pad + radius, y, w - pad_2 - radius_2, ht, r, g, b, a)
        renderer.rectangle(x + pad + radius, y + h, w - pad_2 - radius_2, -ht, r, g, b, a)
    end

    function render.rectangle(x, y, w, h, r, g, b, a, radius)
        radius = math.min(radius, w / 2, h / 2)

        local radius_2 = radius * 2

        renderer.rectangle(x + radius, y, w - radius_2, h, r, g, b, a)
        renderer.rectangle(x, y + radius, radius, h - radius_2, r, g, b, a)
        renderer.rectangle(x + w - radius, y + radius, radius, h - radius_2, r, g, b, a)

        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, 270, 0.25)
        renderer.circle(x + w - radius, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25)
    end
end

local features do
    local rage do
        local air_autostop do
            local HEIGHT_PEAK = 18

            local cl_sidespeed = cvar.cl_sidespeed

            local item_enabled = ui.new_checkbox(
                'Rage', 'Aimbot', 'Air autostop *spectral*'
            )

            local item_air_autoscope = ui.new_checkbox(
                'Rage', 'Aimbot', 'Air autoscope'
            )

            local item_on_peak_of_height = ui.new_checkbox(
                'Rage', 'Aimbot', 'On peak of height'
            )

            local item_distance = ui.new_slider(
                'Rage', 'Aimbot', 'Distance', 0, 1000, 350, true, 'u', 1, {
                    [0] = '∞'
                }
            )

            local item_delay = ui.new_slider(
                'Rage', 'Aimbot', 'Delay', 0, 16, 0, true, 't', 1, {
                    [0] = 'Off'
                }
            )

            local item_minimum_damage = ui.new_slider(
                'Rage', 'Aimbot', 'Minimum damage', -1, 130, -1, true, 'hp', 1, (function()
                    local hint = {
                        [-1] = 'Inherited'
                    }

                    for i = 1, 30 do
                        hint[100 + i] = string.format(
                            'HP + %d', i
                        )
                    end

                    return hint
                end)()
            )

            local stop_tick = -1
            local prediction_data = nil

            local function entity_is_ready(ent)
                return globals.curtime() >= entity.get_prop(ent, 'm_flNextAttack')
            end

            local function entity_can_fire(ent)
                return globals.curtime() >= entity.get_prop(ent, 'm_flNextPrimaryAttack')
            end

            function create_data(flags, velocity)
                local data = { }

                data.flags = flags or 0
                data.velocity = velocity or vector()

                return data
            end

            local function get_highest_damage(player, target)
                local eye_pos = nil

                if player == entity.get_local_player() then
                    eye_pos = vector(client.eye_position())
                else
                    eye_pos = vector(utils.get_eye_position(player))
                end

                local head = vector(entity.hitbox_position(target, 0))
                local stomach = vector(entity.hitbox_position(target, 3))

                local _, head_damage = client.trace_bullet(player, eye_pos.x, eye_pos.y, eye_pos.z, head.x, head.y, head.z)
                local _, stomach_damage = client.trace_bullet(player, eye_pos.x, eye_pos.y, eye_pos.z, stomach.x, stomach.y, stomach.z)

                return math.max(head_damage, stomach_damage)
            end

            local function update_autostop(cmd, minimum)
                local me = entity.get_local_player()

                if me == nil or prediction_data == nil then
                    return
                end

                local velocity = prediction_data.velocity
                local speed = velocity:length2d()

                if minimum ~= nil and speed < minimum then
                    return
                end

                local direction = vector(velocity:angles())
                local real_view = vector(client.camera_angles())

                direction.y = real_view.y - direction.y

                local forward = vector():init_from_angles(
                    direction:unpack()
                )

                local negative_side_move = -cl_sidespeed:get_float()
                local negative_direction = negative_side_move * forward

                cmd.in_speed = 1

                cmd.forwardmove = negative_direction.x
                cmd.sidemove = negative_direction.y
            end

            local function on_predict_command(cmd)
                local me = entity.get_local_player()

                if me == nil then
                    return
                end

                local flags = entity.get_prop(me, 'm_fFlags')
                local velocity = vector(entity.get_prop(me, 'm_vecVelocity'))

                prediction_data = create_data(flags, velocity)
            end

            local function on_setup_command(cmd)
                local me = entity.get_local_player()
                local threat = client.current_threat()

                if me == nil or threat == nil then
                    return
                end

                local wpn = entity.get_player_weapon(me)

                if wpn == nil or not entity_is_ready(me) or not entity_can_fire(wpn) then
                    return
                end

                local origin = vector(client.eye_position())
                local pos = vector(entity.get_origin(threat))

                pos.z = pos.z + 60

                local distance = pos:dist(origin)
                local max_distance = ui.get(item_distance)

                if max_distance ~= 0 and distance > max_distance then
                    return
                end

                local velocity = vector(entity.get_prop(me, 'm_vecVelocity'))
                local animstate = c_entity(me):get_anim_state()

                if animstate == nil or animstate.on_ground then
                    return
                end

                local tick = cmd.command_number
                local delay = ui.get(item_delay)

                local is_delaying = delay ~= 0
                local check_peak = ui.get(item_on_peak_of_height)

                local is_scoped = entity.get_prop(me, 'm_bIsScoped') ~= 0
                local is_force = is_delaying and (stop_tick > tick) or true

                local is_peaking = check_peak and (math.abs(velocity.z) < HEIGHT_PEAK) or true
                local is_downgoing = origin.z < animstate.last_origin_z

                if not is_force then
                    if is_downgoing or not is_peaking then
                        return
                    end

                    if is_delaying then
                        stop_tick = tick + delay
                    end
                end

                local max_damage = software.is_override_minimum_damage()
                    and software.get_override_damage()
                    or software.get_minimum_damage()

                local damage = get_highest_damage(me, threat)
                local health = entity.get_prop(threat, 'm_iHealth')

                if max_damage > 100 then
                    max_damage = health + (max_damage - 100)
                end

                if damage < max_damage then
                    return
                end

                local data = csgo_weapons(wpn)

                local max_speed = is_scoped
                    and data.max_player_speed_alt
                    or data.max_player_speed

                max_speed = max_speed * 0.34

                -- make sniperrifle check
                if ui.get(item_air_autoscope) then
                    if data.type == 'sniperrifle' and not is_scoped then
                        cmd.in_attack2 = 1
                    end
                end

                update_autostop(cmd, max_speed)
            end

            local callbacks do
                local function on_enabled(item)
                    local value = ui.get(item)

                    ui.set_visible(item_air_autoscope, value)
                    ui.set_visible(item_on_peak_of_height, value)
                    ui.set_visible(item_distance, value)
                    ui.set_visible(item_delay, value)
                    ui.set_visible(item_minimum_damage, value)

                    utils.event_callback('predict_command', on_predict_command, value)
                    utils.event_callback('setup_command', on_setup_command, value)
                end

                ui.set_callback(item_enabled, on_enabled)
                on_enabled(item_enabled)
            end
        end

        local rage_enhancements do
            local ref = resource.ragebot.rage_enhancements

            local HITGROUP_HEAD = 1
            local HITGROUP_STOMACH = 3
            local HITGROUP_LEFTLEG = 6
            local HITGROUP_RIGHTLEG = 7

            local WEAPON_DEAGLE = 1
            local WEAPON_REVOLVER = 64
            local WEAPON_AWP = 9
            local WEAPON_SSG08 = 40

            local manipulation do
                manipulation = { }

                local item_data = { }

                function manipulation.set(entindex, item_name, ...)
                    if item_data[entindex] == nil then
                        item_data[entindex] = { }
                    end

                    if item_data[entindex][item_name] == nil then
                        item_data[entindex][item_name] = {
                            plist.get(entindex, item_name)
                        }
                    end

                    plist.set(entindex, item_name, ...)
                end

                function manipulation.unset(entindex, item_name)
                    local entity_data = item_data[entindex]

                    if entity_data == nil then
                        return
                    end

                    local item_values = entity_data[item_name]

                    if item_values == nil then
                        return
                    end

                    plist.set(entindex, item_name, unpack(item_values))

                    entity_data[item_name] = nil
                end

                function manipulation.override(entindex, item_name, ...)
                    if ... ~= nil then
                        manipulation.set(entindex, item_name, ...)
                    else
                        manipulation.unset(entindex, item_name)
                    end
                end
            end

            local function get_hitbox_damage_mult(hitgroup)
                if hitgroup == HITGROUP_HEAD then
                    return 4.0
                end

                if hitgroup == HITGROUP_STOMACH then
                    return 1.25
                end

                if hitgroup == HITGROUP_LEFTLEG then
                    return 0.75
                end

                if hitgroup == HITGROUP_RIGHTLEG then
                    return 0.75
                end

                return 1.0
            end

            local function scale_damage(enemy, damage, hitgroup, weapon_armor_ratio)
                damage = damage * get_hitbox_damage_mult(hitgroup)

                local m_ArmorValue = entity.get_prop(enemy, 'm_ArmorValue')
                local m_bHasHelmet = entity.get_prop(enemy, 'm_bHasHelmet')

                if m_ArmorValue > 0 then
                    if hitgroup == HITGROUP_HEAD then
                        if m_bHasHelmet ~= 0 then
                            damage = damage * (weapon_armor_ratio * 0.5)
                        end
                    else
                        damage = damage * (weapon_armor_ratio * 0.5)
                    end
                end

                return damage
            end

            local function simulate_damage(start_pos, end_pos, enemy, hitgroup, weapon)
                local data = csgo_weapons(weapon)
                local delta = end_pos - start_pos

                local damage = data.damage
                local armor_ratio = data.armor_ratio

                local range = data.range
                local range_modifier = data.range_modifier

                local length = math.min(range, delta:length())

                damage = damage * math.pow(range_modifier, length * 0.002)
                damage = scale_damage(enemy, damage, hitgroup, armor_ratio)

                return damage
            end

            local function is_lethal(start_pos, end_pos, enemy, hitgroup, weapon)
                local damage = simulate_damage(start_pos, end_pos, enemy, hitgroup, weapon)
                local health = entity.get_prop(enemy, 'm_iHealth')

                return damage >= health
            end

            local function get_weapon_type(weapon)
                local weapon_info = csgo_weapons(weapon)

                if weapon_info == nil then
                    return nil
                end

                local weapon_idx = weapon_info.idx
                local weapon_type = weapon_info.type

                if weapon_type == 'pistol' then
                    if weapon_idx == WEAPON_DEAGLE then
                        return 'Deagble'
                    end

                    if weapon_idx == WEAPON_REVOLVER then
                        return 'R8 revolver'
                    end
                end

                if weapon_type == 'sniperrifle' then
                    if weapon_idx == WEAPON_AWP then
                        return 'Awp'
                    end

                    if weapon_idx == WEAPON_SSG08 then
                        return 'Scout'
                    end

                    return 'Auto'
                end

                return 'Other'
            end

            local function reset_player_list()
                local enemies = entity.get_players(true)

                for i = 1, #enemies do
                    local enemy = enemies[i]

                    manipulation.unset(enemy, 'Override prefer body aim')
                    manipulation.unset(enemy, 'Override safe point')
                end
            end

            local function on_shutdown()
                reset_player_list()
            end

            local function on_run_command()
                local me = entity.get_local_player()

                if me == nil then
                    return
                end

                local weapon = entity.get_player_weapon(me)

                if weapon == nil then
                    return
                end

                local enemies = entity.get_players(true)
                local weapon_type = get_weapon_type(weapon)

                for i = 1, #enemies do
                    local enemy = enemies[i]

                    local eye_pos = vector(client.eye_position())
                    local stomach = vector(entity.hitbox_position(enemy, 5))

                    local lethal = is_lethal(eye_pos, stomach, enemy, 3, weapon)

                    local body_aim = lethal and ref.body_aim_lethal:get(weapon_type)
                    local safe_point = lethal and ref.safe_head_lethal:get(weapon_type)

                    manipulation.override(enemy, 'Override safe point', safe_point and 'On' or nil)
                    manipulation.override(enemy, 'Override prefer body aim', body_aim and 'Force' or nil)
                end
            end

            local callbacks do
                local function on_enabled(item)
                    local value = item:get()

                    if not value then
                        reset_player_list()
                    end

                    utils.event_callback('shutdown', on_shutdown, value)
                    utils.event_callback('run_command', on_run_command, value)
                end

                ref.enabled:set_callback(
                    on_enabled, true
                )
            end
        end

        local defensive_fix do
            local ref = resource.ragebot.defensive_fix

            local ref_doubletap = {
                ui.reference('Rage', 'Aimbot', 'Double tap')
            }

            local function extrapolate(pos, velocity, ticks)
                return pos + velocity * (globals.tickinterval() * ticks)
            end

            local function is_double_tap()
                return ui.get(ref_doubletap[1])
                    and ui.get(ref_doubletap[2])
            end

            local function is_player_peeking(ticks)
                local me = entity.get_local_player()

                if me == nil then
                    return
                end

                local enemies = entity.get_players(true)

                -- if has no visible enemies
                if next(enemies) == nil then
                    return false
                end

                local eye_pos = extrapolate(
                    vector(client.eye_position()),
                    vector(entity.get_prop(me, 'm_vecVelocity')),
                    ticks
                )

                for i = 1, #enemies do
                    local enemy = enemies[i]

                    local head_pos = extrapolate(
                        vector(entity.hitbox_position(enemy, 0)),
                        vector(entity.get_prop(enemy, 'm_vecVelocity')),
                        ticks
                    )

                    local _, damage = client.trace_bullet(me, eye_pos.x, eye_pos.y, eye_pos.z, head_pos.x, head_pos.y, head_pos.z)

                    if damage > 0 then
                        return true
                    end
                end

                return false
            end

            local function should_update()
                if not is_double_tap() then
                    return false
                end

                if not is_player_peeking(14) then
                    return false
                end

                return true
            end

            local function on_setup_command(cmd)
                if not should_update() then
                    return
                end

                cmd.force_defensive = true
            end

            local callbacks do
                local function on_enabled(item)
                    utils.event_callback(
                        'setup_command',
                        on_setup_command,
                        item:get()
                    )
                end

                ref.enabled:set_callback(
                    on_enabled, true
                )
            end
        end

        local recharge_fix do
            local ref = resource.ragebot.recharge_fix

            local prev_state = false

            local ref_enabled = {
                ui.reference('Rage', 'Aimbot', 'Enabled')
            }

            local ref_double_tap = {
                ui.reference('Rage', 'Aimbot', 'Double tap')
            }

            local ref_on_shot_antiaim = {
                ui.reference('AA', 'Other', 'On shot anti-aim')
            }

            local function is_double_tap_active()
                return ui.get(ref_double_tap[1])
                    and ui.get(ref_double_tap[2])
            end

            local function is_on_shot_antiaim_active()
                return ui.get(ref_on_shot_antiaim[1])
                    and ui.get(ref_on_shot_antiaim[2])
            end

            local function is_tickbase_changed(player)
                return (globals.tickcount() - entity.get_prop(player, 'm_nTickBase')) > 0
            end

            local function should_change()
                local me = entity.get_local_player()

                if me == nil then
                    return false
                end

                local state = is_double_tap_active()
                local charged = is_tickbase_changed(me)

                if prev_state ~= state then
                    if state and not charged then
                        return true
                    end

                    prev_state = state
                end

                if is_on_shot_antiaim_active() then
                    return not is_tickbase_changed(me)
                end

                return false
            end

            local function on_shutdown()
                ragebot.unset(ref_enabled[1])
            end

            local function on_setup_command()
                if should_change() then
                    ragebot.set(ref_enabled[1], false)
                else
                    ragebot.unset(ref_enabled[1])
                end
            end

            local callbacks do
                local function on_enabled(item)
                    local value = item:get()

                    if not value then
                        ragebot.unset(ref_enabled[1])
                    end

                    utils.event_callback('shutdown', on_shutdown, value)
                    utils.event_callback('setup_command', on_setup_command, value)
                end

                ref.enabled:set_callback(
                    on_enabled, true
                )
            end
        end

        local jitter_fix do
            local ref = resource.ragebot.jitter_fix

            local ref_antiaim_correction = ui.reference(
                'Rage', 'Other', 'Anti-aim correction'
            )

            local player_data = { }

            local function erase_player_data()
                for k in pairs(player_data) do
                    player_data[k] = nil
                end
            end

            local function unset_player_body_yaw(entindex)
                plist.set(entindex, 'Force body yaw', false)
                plist.set(entindex, 'Force body yaw value', 0)
            end

            local function set_player_body_yaw(entindex, value)
                plist.set(entindex, 'Force body yaw', true)
                plist.set(entindex, 'Force body yaw value', value)
            end

            local function get_max_desync_delta(animstate)
                local duck_amount = animstate.duck_amount

                local stop_to_full_running_fraction = animstate.stop_to_full_running_fraction

                local speed_fraction = math.max(0, math.min(animstate.feet_speed_forwards_or_sideways, 1))
                local speed_factor = math.max(0, math.min(animstate.feet_speed_unknown_forwards_or_sideways, 1))

                local value = ((stop_to_full_running_fraction * -0.30000001) - 0.19999999) * speed_fraction + 1

                if duck_amount > 0 then
                    value = value + ((duck_amount * speed_factor) * (0.5 - value))
                end

                return animstate.max_yaw * value
            end

            local function get_enemies()
                local player_resource = entity.get_player_resource()

                if player_resource == nil then
                    return nil
                end

                local list = { }

                for i = 1, globals.maxplayers() do
                    local is_connected = entity.get_prop(
                        player_resource, 'm_bConnected', i
                    )

                    if is_connected ~= 1 then
                        goto continue
                    end

                    local is_alive = entity.get_prop(
                        player_resource, 'm_bAlive', i
                    )

                    if not is_alive or not entity.is_enemy(i) then
                        goto continue
                    end

                    table.insert(list, i)
                    ::continue::
                end

                return list
            end

            local function reset_player_list()
                local enemies = get_enemies()

                if enemies == nil then
                    return
                end

                for i = 1, #enemies do
                    unset_player_body_yaw(enemies[i])
                end
            end

            local function on_shutdown()
                override.unset(ref_antiaim_correction)

                reset_player_list()
                erase_player_data()
            end

            local function on_aim_miss(e)
                local target = e.target

                if target == nil then
                    return
                end

                local data = player_data[target]

                if data == nil then
                    return
                end

                local is_forced_body_yaw = plist.get(
                    target, 'Force body yaw'
                )

                if not is_forced_body_yaw then
                    return
                end

                local is_valid_reason = (
                    e.reason == '?' or
                    e.reason == 'resolver' or
                    e.reason == 'correction'
                )

                if not is_valid_reason then
                    return
                end

                data.misses = data.misses + 1
            end

            local function on_player_spawn(e)
                local me = entity.get_local_player()
                local userid = client.userid_to_entindex(e.userid)

                if me ~= userid then
                    return
                end

                erase_player_data()
            end

            local function on_net_update_end()
                local me = entity.get_local_player()

                if me == nil then
                    return
                end

                override.set(ref_antiaim_correction, true)

                local enemies = get_enemies()

                if enemies == nil then
                    return
                end

                local my_origin = vector(
                    entity.get_origin(me)
                )

                for i = 1, #enemies do
                    local enemy = enemies[i]

                    local player_info = c_entity.new(enemy)

                    if player_info == nil then
                        goto continue
                    end

                    if not player_data[enemy] then
                        player_data[enemy] = {
                            misses = 0,
                            last_yaw = 0,
                            last_yaw_update_time = 0
                        }
                    end

                    local data = player_data[enemy]

                    if data == nil then
                        goto continue
                    end

                    local is_correction_active = plist.get(
                        enemy, 'Correction active'
                    )

                    if not is_correction_active or data.misses > 2 then
                        unset_player_body_yaw(enemy)

                        goto continue
                    end

                    local animstate = player_info:get_anim_state()

                    if animstate == nil then
                        goto continue
                    end

                    local head_center_position = vector(
                        entity.hitbox_position(enemy, 0)
                    )

                    local targets = vector((head_center_position - my_origin):angles())
                    local yaw = utils.normalize(targets.y - animstate.eye_angles_y + 180, -180, 180)

                    if data.last_yaw ~= yaw then
                        if math.abs(data.last_yaw - yaw) >= 20 and math.abs(data.last_yaw - yaw) <= 340 then
                            data.last_yaw_update_time = globals.tickcount() + 15
                        end

                        data.last_yaw = yaw
                    end

                    local is_jitter = data.last_yaw_update_time > globals.tickcount()

                    if not is_jitter then
                        unset_player_body_yaw(enemy)

                        goto continue
                    end

                    local mod = data.misses == 0 and 1 or -1
                    local side = utils.clamp(yaw, -1, 1) * mod

                    local max_desync = get_max_desync_delta(animstate)
                    set_player_body_yaw(enemy, max_desync * side)

                    ::continue::
                end
            end

            local callbacks do
                local function on_enabled(item)
                    local value = item:get()

                    if not value then
                        reset_player_list()
                        erase_player_data()
                    end

                    utils.event_callback('shutdown', on_shutdown, value)

                    utils.event_callback('aim_miss', on_aim_miss, value)
                    utils.event_callback('player_spawn', on_player_spawn, value)

                    utils.event_callback('net_update_end', on_net_update_end, value)
                end

                ref.enabled:set_callback(
                    on_enabled, true
                )
            end
        end

        local jump_scout do
            local ref = resource.ragebot.jump_scout

            local function should_update()
                local me = entity.get_local_player()

                if me == nil then
                    return false
                end

                local weapon = entity.get_player_weapon(me)

                if weapon == nil then
                    return false
                end

                local weapon_info = csgo_weapons(weapon)

                if weapon_info == nil then
                    return nil
                end

                -- is weapon scout
                if weapon_info.idx ~= 40 then
                    return false
                end

                if localplayer.velocity2d_sqr > (10 * 10) then
                    return false
                end

                return true
            end

            local function restore_values()
                override.unset(software.misc.movement.air_strafe)
            end

            local function on_shutdown()
                restore_values()
            end

            local function on_paint_ui()
                restore_values()
            end

            local function on_setup_command(cmd)
                if should_update() then
                    override.set(software.misc.movement.air_strafe, false)
                else
                    override.unset(software.misc.movement.air_strafe)
                end
            end

            local callbacks do
                local function on_enabled(item)
                    local value = item:get()

                    if not value then
                        restore_values()
                    end

                    utils.event_callback('shutdown', on_shutdown, value)
                    utils.event_callback('paint_ui', on_paint_ui, value)
                    utils.event_callback('setup_command', on_setup_command, value)
                end

                ref.enabled:set_callback(
                    on_enabled, true
                )
            end
        end

        local aimbot_logs do
            local ref = resource.ragebot.aimbot_logs

            local PADDING_W = 8
            local PADDING_H = 6

            local GAP_BETWEEN = 4

            local e_hitgroup = {
                [0]  = 'generic',
                [1]  = 'head',
                [2]  = 'chest',
                [3]  = 'stomach',
                [4]  = 'left arm',
                [5]  = 'right arm',
                [6]  = 'left leg',
                [7]  = 'right leg',
                [8]  = 'neck',
                [10] = 'gear'
            }

            local hurt_weapons = {
                ['c4'] = 'bombed',
                ['knife'] = 'knifed',
                ['decoy'] = 'decoyed',
                ['inferno'] = 'burned',
                ['molotov'] = 'harmed',
                ['flashbang'] = 'harmed',
                ['hegrenade'] = 'naded',
                ['incgrenade'] = 'harmed',
                ['smokegrenade'] = 'harmed'
            }

            local log_glow = 0
            local log_offset = 0
            local log_duration = 5

            local fire_data = { }
            local draw_queue = { }

            local function clear_draw_queue()
                for i = 1, #draw_queue do
                    draw_queue[i] = nil
                end
            end

            local function add_log(r, g, b, a, text)
                if not ref.select:get 'Screen' then
                    return
                end

                local time = log_duration

                local id = #draw_queue + 1
                local color = { r, g, b, a }

                draw_queue[id] = {
                    text = text,
                    color = color,

                    time = time,
                    alpha = 0.0
                }

                return id
            end

            local function console_log(r, g, b, text)
                local list, count = text_fmt.color(text)

                for i = 1, count do
                    local value = list[i]

                    local str = value[1]
                    local hex = value[2]

                    if i ~= count then
                        str = str .. '\0'
                    end

                    if hex == nil then
                        client.color_log(
                            r, g, b, str
                        )

                        goto continue
                    end

                    local hex_r, hex_g, hex_b = utils.from_hex(hex)

                    client.color_log(
                        hex_r, hex_g, hex_b, str
                    )

                    ::continue::
                end
            end

            local function format_text(text, hex_a, hex_b)
                local result = string.gsub(text, '${(.-)}', string.format(
                    '\a%s%%1\a%s', hex_a, hex_b
                ))

                if result:sub(1, 1) ~= '\a' then
                    result = '\a' .. hex_b .. result
                end

                return result
            end

            local function get_logo_text(logo_type)
                return 'spectral'
            end

            local function update_text_alpha(text, alpha)
                local result = text:gsub('\a(%x%x%x%x%x%x)(%x%x)', function(rgb, a)
                    return '\a' .. rgb .. string.format('%02x', tonumber(a, 16) * alpha)
                end)

                return result
            end

            local function draw_box(x, y, w, h, r1, g1, b1, a1, r2, g2, b2, a2, alpha)
                local radius = 8

                if log_glow > 0 then
                    local glow_alpha = utils.map(
                        log_glow, 0.0, 1.5, 0, a2 * 0.5, true
                    )

                    render.glow(x, y, w, h, r2, g2, b2, glow_alpha * alpha, radius, round(8 * log_glow))
                end

                render.rectangle(x, y, w, h, r1, g1, b1, a1 * alpha, radius)
            end

            local function on_paint()
                local r0, g0, b0, a0 = 18, 18, 18, 225

                local dt = globals.frametime()
                local len = #draw_queue

                local screen_size = vector(
                    client.screen_size()
                )

                local position = screen_size / 2 do
                    position.y = position.y + log_offset
                end

                local logo_text = get_logo_text(logo_type)
                local logo_flags = ''

                local logo_size = vector(renderer.measure_text(logo_flags, logo_text))

                for i = len, 1, -1 do
                    local data = draw_queue[i]

                    local is_life = data.time > 0 and (len - i) < 6

                    data.alpha = motion.interp(
                        data.alpha, is_life, 0.075
                    )

                    if is_life then
                        data.time = data.time - dt
                    else
                        if data.alpha <= 0.0 then
                            table.remove(draw_queue, i)
                        end
                    end
                end

                local flags = ''

                for i = 1, #draw_queue do
                    local data = draw_queue[i]

                    local r, g, b, a = unpack(data.color)
                    local text, alpha = data.text, data.alpha

                    local text_size = vector(renderer.measure_text(flags, text))
                    local box_size = text_size + vector(PADDING_W, PADDING_H) * 2

                    if logo_text ~= nil then
                        box_size.x = box_size.x + logo_size.x + GAP_BETWEEN
                    end

                    local box_pos = position - box_size / 2

                    local text_pos = box_pos + vector(PADDING_W, PADDING_H)
                    local logo_pos = vector(text_pos.x, box_pos.y + (box_size.y - logo_size.y) / 2)

                    draw_box(box_pos.x, box_pos.y, box_size.x, box_size.y, r0, g0, b0, a0, r, g, b, a * 0.34, alpha)

                    if logo_text ~= nil then
                        renderer.text(
                            logo_pos.x, logo_pos.y,
                            r, g, b, a * alpha,
                            logo_flags, nil, logo_text
                        )

                        text_pos.x = text_pos.x + logo_size.x + GAP_BETWEEN
                    end

                    text_pos.y = box_pos.y + (box_size.y - text_size.y) / 2

                    text = update_text_alpha(
                        text, alpha
                    )

                    renderer.text(
                        text_pos.x, text_pos.y,
                        255, 255, 255, 200 * alpha,
                        flags, nil, text
                    )

                    position.y = position.y - round((box_size.y + 8) * alpha)
                end
            end
            local function on_aim_hit(e)
                local data = fire_data[e.id]

                if data == nil then
                    return
                end

                local target = e.target

                if target == nil then
                    return
                end

                local r, g, b, a = ref.color_hit:get()

                local player_name = entity.get_player_name(target)
                local player_health = entity.get_prop(target, 'm_iHealth')

                local hit_chance = e.hit_chance or 0
                local aim_history = data.history or 0

                local damage = e.damage or 0
                local aim_damage = data.aim.damage or 0

                local hitgroup = e_hitgroup[e.hitgroup] or '?'
                local aim_hitgroup = e_hitgroup[data.aim.hitgroup] or '?'

                local damage_mismatch = (aim_damage - damage) > 0
                local hitgroup_mismatch = aim_hitgroup ~= hitgroup

                local screen_text do
                    screen_text = string.format(
                        'Hit ${%s} in ${%s} for ${%d} damage (${%d} health remaining)',
                        player_name, hitgroup, damage, player_health
                    )
                end

                local console_text do
                    local damage_text = string.format('${%d}', damage)
                    local hitgroup_text = string.format('${%s}', hitgroup)

                    if damage_mismatch then
                        damage_text = string.format(
                            '%s(${%d})', damage_text, aim_damage
                        )
                    end

                    if hitgroup_mismatch then
                        hitgroup_text = string.format(
                            '%s(${%s})', hitgroup_text, aim_hitgroup
                        )
                    end

                    local details = { } do
                        table.insert(details, string.format('hc: ${%d%%}', hit_chance))
                        table.insert(details, string.format('history: ${%dt}', aim_history))
                    end

                    console_text = string.format(
                        'Hit ${%s} in %s for %s damage (${%d} health remaining) (%s)',
                        player_name, hitgroup_text, damage_text, player_health, table.concat(details, ' ∙ ')
                    )
                end

                screen_text = format_text(
                    screen_text, utils.to_hex(r, g, b, a), 'c8c8c8ff'
                )

                console_text = format_text(
                    console_text, utils.to_hex(r, g, b, a), 'c8c8c8ff'
                )

                add_log(r, g, b, a, screen_text)
                console_log(255, 255, 255, console_text)
            end

            local function on_aim_miss(e)
                local data = fire_data[e.id]

                if data == nil then
                    return
                end

                local target = e.target

                if target == nil then
                    return
                end

                local r, g, b, a = ref.color_miss:get()

                local player_name = entity.get_player_name(target)

                local miss_reason = e.reason or '?'
                local hit_chance = e.hit_chance or 0

                local aim_damage = data.aim.damage or 0
                local aim_history = data.history or 0

                local aim_hitgroup = e_hitgroup[data.aim.hitgroup] or '?'

                local screen_text do
                    screen_text = string.format(
                        'Missed ${%s} in ${%s} due to ${%s}',
                        player_name, aim_hitgroup, miss_reason
                    )
                end

                local console_text do
                    local details = { } do
                        table.insert(details, string.format('hc: ${%d%%}', hit_chance))
                        table.insert(details, string.format('history: ${%dt}', aim_history))
                    end

                    console_text = string.format(
                        'Missed ${%s}\'s ${%s} due to ${%s} (%s)',
                        player_name, aim_hitgroup, miss_reason, table.concat(details, ' ∙ ')
                    )
                end

                screen_text = format_text(
                    screen_text, utils.to_hex(r, g, b, a), 'c8c8c8ff'
                )

                console_text = format_text(
                    console_text, utils.to_hex(r, g, b, a), 'c8c8c8ff'
                )

                add_log(r, g, b, a, screen_text)
                console_log(200, 200, 200, console_text)
            end

            local function on_aim_fire(e)
                local safe = plist.get(e.target, 'Override safe point')
                local history = globals.tickcount() - e.tick

                fire_data[e.id] = {
                    aim = e,

                    safe = safe == 'On',
                    history = history
                }
            end

            local function on_player_hurt(e)
                local me = entity.get_local_player()

                local userid = client.userid_to_entindex(e.userid)
                local attacker = client.userid_to_entindex(e.attacker)

                if attacker ~= me or userid == me then
                    return
                end

                local weapon = e.weapon
                local action = hurt_weapons[weapon]

                if action == nil then
                    return
                end

                local r, g, b, a = ref.color_hit:get()

                local player_name = entity.get_player_name(userid)
                local player_health = entity.get_prop(userid, 'm_iHealth')

                local damage = e.dmg_health

                local screen_text do
                    screen_text = string.format(
                        '%s ${%s} for ${%d} dmg',
                        action, player_name, damage
                    )
                end

                local console_text do
                    local buffer = { }

                    table.insert(buffer, string.format('target: ${%s}', player_name))
                    table.insert(buffer, string.format('hp: ${%d}', damage))

                    if player_health <= 0 then
                        table.insert(buffer, 'rhp: ${0} (dead)')
                    else
                        table.insert(buffer, string.format('rhp: ${%d}', player_health))
                    end

                    table.insert(buffer, string.format('by: ${%s}', weapon))

                    console_text = table.concat(buffer, '  ')
                end

                screen_text = format_text(
                    screen_text, utils.to_hex(r, g, b, a), 'c8c8c8ff'
                )

                console_text = format_text(
                    console_text, utils.to_hex(r, g, b, a), 'c8c8c8ff'
                )

                add_log(r, g, b, a, screen_text)
                console_log(255, 255, 255, console_text)
            end

            local callbacks do
                local function on_glow(item)
                    log_glow = item:get() * 0.01
                end

                local function on_offset(item)
                    log_offset = item:get() * 2
                end

                local function on_duration(item)
                    log_duration = item:get() * 0.1
                end

                local function on_select(item)
                    local is_screen = item:get 'Screen'

                    if is_screen then
                        ref.glow:set_callback(on_glow, true)
                        ref.offset:set_callback(on_offset, true)
                        ref.duration:set_callback(on_duration, true)
                    else
                        ref.glow:unset_callback(on_glow)
                        ref.offset:unset_callback(on_offset)
                        ref.duration:unset_callback(on_duration)
                    end

                    if not is_screen then
                        clear_draw_queue()
                    end

                    utils.event_callback('paint', on_paint, is_screen)
                end

                local function on_enabled(item)
                    local value = item:get()

                    if value then
                        ref.select:set_callback(on_select, true)
                    else
                        ref.select:unset_callback(on_select)
                    end

                    if not value then
                        ref.glow:unset_callback(on_glow)
                        ref.offset:unset_callback(on_offset)
                        ref.duration:unset_callback(on_duration)

                        utils.event_callback('paint', on_paint, false)
                        clear_draw_queue()
                    end

                    utils.event_callback('aim_hit', on_aim_hit, value)
                    utils.event_callback('aim_miss', on_aim_miss, value)
                    utils.event_callback('aim_fire', on_aim_fire, value)
                    utils.event_callback('player_hurt', on_player_hurt, value)
                end

                ref.enabled:set_callback(
                    on_enabled, true
                )
            end
        end
    end

    local antiaim = { } do
        local inverts = 0
        local inverted = false

        local delay_ptr = {
            default = 0,
            defensive = 0
        }

        local skitter = {
            -1, 1, 0,
            -1, 1, 0,
            -1, 0, 1,
            -1, 0, 1
        }

        local buffer = { } do
            local ref = software.antiaimbot.angles

            local function override_value(item, ...)
                if ... == nil then
                    return
                end

                override.set(item, ...)
            end

            local Buffer = { } do
                Buffer.__index = Buffer

                function Buffer:clear()
                    for k in pairs(self) do
                        self[k] = nil
                    end
                end

                function Buffer:copy(target)
                    for k, v in pairs(target) do
                        self[k] = v
                    end
                end

                function Buffer:unset()
                    override.unset(ref.roll)

                    override.unset(ref.freestanding[2])
                    override.unset(ref.freestanding[1])

                    override.unset(ref.edge_yaw)

                    override.unset(ref.freestanding_body_yaw)

                    override.unset(ref.body_yaw[2])
                    override.unset(ref.body_yaw[1])

                    override.unset(ref.yaw[2])
                    override.unset(ref.yaw[1])

                    override.unset(ref.yaw_jitter[2])
                    override.unset(ref.yaw_jitter[1])

                    override.unset(ref.yaw_base)

                    override.unset(ref.pitch[2])
                    override.unset(ref.pitch[1])

                    override.unset(ref.enabled)
                end

                function Buffer:set()
                    if self.pitch_offset ~= nil then
                        self.pitch_offset = utils.clamp(
                            self.pitch_offset, -89, 89
                        )
                    end

                    if self.yaw_offset ~= nil then
                        self.yaw_offset = utils.normalize(
                            self.yaw_offset, -180, 180
                        )
                    end

                    if self.jitter_offset ~= nil then
                        self.jitter_offset = utils.normalize(
                            self.jitter_offset, -180, 180
                        )
                    end

                    if self.body_yaw_offset ~= nil then
                        self.body_yaw_offset = utils.clamp(
                            self.body_yaw_offset, -180, 180
                        )
                    end

                    override_value(ref.enabled, self.enabled)

                    override_value(ref.pitch[1], self.pitch)
                    override_value(ref.pitch[2], self.pitch_offset)

                    override_value(ref.yaw_base, self.yaw_base)

                    override_value(ref.yaw[1], self.yaw)
                    override_value(ref.yaw[2], self.yaw_offset)

                    override_value(ref.yaw_jitter[1], self.yaw_jitter)
                    override_value(ref.yaw_jitter[2], self.jitter_offset)

                    override_value(ref.body_yaw[1], self.body_yaw)
                    override_value(ref.body_yaw[2], self.body_yaw_offset)

                    override_value(ref.freestanding_body_yaw, self.freestanding_body_yaw)

                    override_value(ref.edge_yaw, self.edge_yaw)

                    if self.freestanding == true then
                        override_value(ref.freestanding[1], true)
                        override_value(ref.freestanding[2], 'Always on')
                    elseif self.freestanding == false then
                        override_value(ref.freestanding[1], false)
                        override_value(ref.freestanding[2], 'On hotkey')
                    end

                    override_value(ref.roll, self.roll)
                end
            end

            setmetatable(buffer, Buffer)
            antiaim.buffer = buffer
        end

        local defensive = { } do
            local pitch_inverted = false
            local modifier_delay_ticks = 0

            local function update_pitch_inverter()
                pitch_inverted = not pitch_inverted
            end

            local function update_modifier_inverter()
                modifier_delay_ticks = modifier_delay_ticks + 1
            end

            local function update_pitch(buffer, items)
                if items.pitch == nil then
                    return
                end

                local value = items.pitch:get()
                local speed = items.pitch_speed:get()

                local pitch_offset_1 = items.pitch_offset_1:get()
                local pitch_offset_2 = items.pitch_offset_2:get()

                if value == 'Off' then
                    return
                end

                if value == 'Static' then
                    buffer.pitch = 'Custom'
                    buffer.pitch_offset = pitch_offset_1

                    return
                end

                if value == 'Jitter' then
                    local offset = pitch_inverted
                        and pitch_offset_2
                        or pitch_offset_1

                    buffer.pitch = 'Custom'
                    buffer.pitch_offset = offset

                    return
                end

                if value == 'Spin' then
                    local time = globals.curtime() * speed * 0.1
                    local offset = utils.lerp(pitch_offset_1, pitch_offset_2, time % 1)

                    buffer.pitch = 'Custom'
                    buffer.pitch_offset = offset

                    return
                end

                if value == 'Random' then
                    buffer.pitch = 'Custom'

                    buffer.pitch_offset = utils.random_int(
                        pitch_offset_1, pitch_offset_2
                    )

                    return
                end
            end

            local function update_yaw_modifier(buffer, items)
                if items.yaw_modifier == nil then
                    return
                end

                local value = items.yaw_modifier:get()
                local offset = items.modifier_offset:get()

                if value == 'Off' then
                    return
                end

                if value == 'Offset' then
                    buffer.yaw_offset = buffer.yaw_offset + (
                        inverted and 0 or offset
                    )

                    return
                end

                if value == 'Center' then
                    if buffer.body_yaw == 'Jitter' then
                        buffer.yaw_left = buffer.yaw_left - offset * 0.5
                        buffer.yaw_right = buffer.yaw_right + offset * 0.5
                    else
                        buffer.yaw_offset = buffer.yaw_offset + 0.5 * (
                            inverted and -offset or offset
                        )
                    end

                    return
                end

                if value == 'Skitter' then
                    local index = inverts % #skitter
                    local multiplier = skitter[index + 1]

                    buffer.yaw_offset = buffer.yaw_offset + (
                        offset * multiplier
                    )

                    return
                end
            end

            local function update_yaw(buffer, items)
                if items.yaw == nil then
                    return
                end

                local value = items.yaw:get()
                local speed = items.yaw_speed:get()

                local yaw_offset = items.yaw_offset:get()

                if value == 'off' then
                    return
                end

                buffer.freestanding = false

                buffer.yaw_left = 0
                buffer.yaw_right = 0

                buffer.yaw_offset = 0

                buffer.yaw_jitter = 'Off'
                buffer.jitter_offset = nil

                if value == 'Static' then
                    buffer.yaw = '180'
                    buffer.yaw_offset = yaw_offset
                end

                if value == 'Spin' then
                    local time = globals.curtime() * speed * 0.1
                    local offset = yaw_offset * 0.5

                    offset = 180 + utils.lerp(
                        -offset, offset, time % 1
                    )

                    buffer.yaw = '180'
                    buffer.yaw_offset = offset
                end

                if value == 'Random' then
                    local offset = math.abs(
                        yaw_offset * 0.5
                    )

                    offset = 180 + utils.random_int(
                        -offset, offset
                    )

                    buffer.yaw = '180'
                    buffer.yaw_offset = offset
                end

                if value == 'Static LR' then
                    buffer.yaw = '180'
                    buffer.yaw_offset = 0

                    buffer.yaw_left = buffer.yaw_left + items.yaw_left:get()
                    buffer.yaw_right = buffer.yaw_right + items.yaw_right:get()
                end

                update_yaw_modifier(buffer, items)
            end

            local function update_body_yaw(buffer, items)
                if items.body_yaw == nil then
                    return
                end

                local value = items.body_yaw:get()
                local offset = items.body_yaw_offset:get()

                if value == 'Off' then
                    return
                end

                buffer.body_yaw = value
                buffer.body_yaw_offset = offset

                buffer.delay = nil

                if value == 'Jitter' then
                    local delay_1 = items.delay_1:get()
                    local delay_2 = items.delay_2:get()

                    local delay = utils.random_int(
                        delay_1, delay_2
                    )

                    buffer.delay = math.max(1, delay)
                end
            end

            function defensive:update(cmd)
                if cmd.chokedcommands == 0 then
                    update_pitch_inverter()
                    update_modifier_inverter()
                end
            end

            function defensive:apply(cmd, items)
                if items.force_break_lc ~= nil and items.force_break_lc:get() then
                    cmd.force_defensive = true
                end

                local is_exploit_active = software.is_double_tap_active()
                    or software.is_on_shot_antiaim_active()

                local is_duck_peek_active = software.is_duck_peek_assist()

                if not is_exploit_active or is_duck_peek_active then
                    return false
                end

                local exploit_data = exploit.get()
                local defensive_data = exploit_data.defensive

                local is_defensive = defensive_data.left > 0

                if not items.enabled:get() or not is_defensive then
                    return false
                end

                local buffer_ctx = { }

                update_body_yaw(buffer_ctx, items)
                update_pitch(buffer_ctx, items)
                update_yaw(buffer_ctx, items)

                buffer.defensive = buffer_ctx

                return true
            end
        end

        local builder = { } do
            local ref = resource.antiaim.builder

            local function is_dormant()
                return next(entity.get_players(true)) == nil
            end

            local function update_pitch(items)
                if items.pitch == nil then
                    return
                end

                buffer.pitch = items.pitch:get()
                buffer.pitch_offset = items.pitch_offset:get()
            end

            local function update_yaw(items)
                if items.yaw == nil then
                    return
                end

                buffer.yaw = items.yaw:get()
                buffer.yaw_offset = items.yaw_offset:get()

                if buffer.yaw == '180 LR' then
                    local yaw_left = items.yaw_left:get()
                    local yaw_right = items.yaw_right:get()

                    if items.yaw_asynced:get() then
                        yaw_left = utils.random_int(yaw_left, yaw_left - 20)
                        yaw_right = utils.random_int(yaw_right, yaw_right - 20)
                    end

                    buffer.yaw = '180'
                    buffer.yaw_offset = 0

                    buffer.yaw_left = yaw_left
                    buffer.yaw_right = yaw_right
                end
            end

            local function update_jitter(items)
                if items.yaw_jitter == nil then
                    return
                end

                buffer.yaw_jitter = items.yaw_jitter:get()
                buffer.jitter_offset = items.jitter_offset:get()
            end

            local function update_body_yaw(items)
                if items.body_yaw == nil then
                    return
                end

                buffer.body_yaw = items.body_yaw:get()
                buffer.body_yaw_offset = items.body_yaw_offset:get()
                buffer.freestanding_body_yaw = items.freestanding_body_yaw:get()

                if items.delay ~= nil then
                    buffer.delay = items.delay:get()
                end
            end

            function builder:get(state)
                return ref[state]
            end

            function builder:is_active_ex(items)
                return items.enabled == nil
                    or items.enabled:get()
            end

            function builder:is_active(state)
                local items = self:get(state)

                if items == nil then
                    return false
                end

                return self:is_active_ex(items)
            end

            function builder:apply_ex(items)
                if items == nil then
                    return false
                end

                buffer.enabled = true

                update_pitch(items)
                update_yaw(items)
                update_jitter(items)
                update_body_yaw(items)

                return true
            end

            function builder:apply(state)
                local items = self:get(state)

                if items == nil then
                    return false, nil
                end

                if not self:is_active_ex(items) then
                    return false, items
                end

                self:apply_ex(items)
                return true, items
            end

            function builder:update(cmd)
                if not exploit.get().shift then
                    local state, items = self:apply 'Fakelag'

                    if state and items ~= nil then
                        return state, items
                    end
                end

                if is_dormant() then
                    local state, items = self:apply 'Dormant'

                    if state and items ~= nil then
                        return state, items
                    end
                end

                local states = statement.get()
                local state = states[#states]

                if state == nil then
                    return false, nil
                end

                local active, items = self:apply(state)

                if not active or items == nil then
                    local _, new_items = self:apply 'Default'

                    if new_items ~= nil then
                        items = new_items
                    end
                end

                return true, items
            end
        end

        local legit_aa = { } do
            local is_interact_traced = false

            local function should_update(cmd, items)
                local me = entity.get_local_player()

                if me == nil then
                    return false
                end

                local weapon = entity.get_player_weapon(me)

                if weapon == nil then
                    return false
                end

                local weapon_info = csgo_weapons(weapon)

                if weapon_info == nil then
                    return false
                end

                local team = entity.get_prop(me, 'm_iTeamNum')
                local my_origin = vector(entity.get_origin(me))

                local is_weapon_bomb = weapon_info.idx == 49

                local is_defusing = entity.get_prop(me, 'm_bIsDefusing') == 1
                local is_rescuing = entity.get_prop(me, 'm_bIsGrabbingHostage') == 1

                local in_bomb_site = entity.get_prop(me, 'm_bInBombZone') == 1

                if is_defusing or is_rescuing then
                    return false
                end

                if in_bomb_site and is_weapon_bomb then
                    return false
                end

                if team == 3 and cmd.pitch > 15 then
                    local bombs = entity.get_all 'CPlantedC4'

                    for i = 1, #bombs do
                        local bomb = bombs[i]

                        local origin = vector(
                            entity.get_origin(bomb)
                        )

                        local delta = origin - my_origin
                        local distancesqr = delta:lengthsqr()

                        if distancesqr < (62 * 62) then
                            return false
                        end
                    end
                end

                local camera = vector(client.camera_angles())
                local forward = vector():init_from_angles(camera:unpack())

                local eye_pos = vector(client.eye_position())
                local end_pos = eye_pos + forward * 128

                local fraction, entindex = client.trace_line(
                    me, eye_pos.x, eye_pos.y, eye_pos.z, end_pos.x, end_pos.y, end_pos.z
                )

                if fraction ~= 1 then
                    if entindex == -1 then
                        return true
                    end

                    local classname = entity.get_classname(entindex)

                    if classname == 'CWorld' then
                        return true
                    end

                    if classname == 'CFuncBrush' then
                        return true
                    end

                    if classname == 'CCSPlayer' then
                        return true
                    end

                    if classname == 'CHostage' then
                        local origin = vector(entity.get_origin(entindex))
                        local distance = eye_pos:distsqr(origin)

                        if distance < (84 * 84) then
                            return false
                        end
                    end

                    if not is_interact_traced then
                        is_interact_traced = true
                        return false
                    end
                end

                return true
            end

            function legit_aa:update(cmd)
                if cmd.in_use == 0 then
                    is_interact_traced = false

                    return false
                end

                local items = builder:get 'Legit AA'

                if items == nil then
                    return false
                end

                if items.override ~= nil and not items.override:get() then
                    return false
                end

                if not should_update(cmd, items) then
                    return false
                end

                buffer.pitch = 'Custom'
                buffer.pitch_offset = cmd.pitch

                buffer.yaw_base = 'Local view'

                builder:apply_ex(items)

                if items ~= nil and items.defensive ~= nil then
                    defensive:apply(cmd, items.defensive)
                end

                buffer.yaw_offset = buffer.yaw_offset + 180
                buffer.freestanding = false

                cmd.in_use = 0

                return true
            end
        end

        local avoid_backstab = { } do
            local ref = resource.antiaim.settings.avoid_backstab

            local WEAPONTYPE_KNIFE = 0
            local MAX_DISTANCE_SQR = 240 * 240

            local function is_weapon_knife(weapon)
                local weapon_info = csgo_weapons(weapon)

                if weapon_info == nil then
                    return false
                end

                -- is weapon taser
                if weapon_info.idx == 31 then
                    return false
                end

                return weapon_info.weapon_type_int == WEAPONTYPE_KNIFE
            end

            local function is_player_weapon_knife(player)
                local weapon = entity.get_player_weapon(player)

                if weapon == nil then
                    return false
                end

                return is_weapon_knife(weapon)
            end

            local function get_backstab_angle(player)
                local best_delta = nil
                local best_target = nil
                local best_distancesqr = math.huge

                local origin = vector(
                    entity.get_origin(player)
                )

                local enemies = entity.get_players(true)

                for i = 1, #enemies do
                    local enemy = enemies[i]

                    if not is_player_weapon_knife(enemy) then
                        goto continue
                    end

                    local enemy_origin = vector(
                        entity.get_origin(enemy)
                    )

                    local delta = enemy_origin - origin
                    local distancesqr = delta:lengthsqr()

                    best_delta = delta
                    best_target = enemy
                    best_distancesqr = distancesqr

                    ::continue::
                end

                return best_target, best_distancesqr, best_delta
            end

            function avoid_backstab:update()
                if not ref.enabled:get() then
                    return false
                end

                local me = entity.get_local_player()

                if me == nil then
                    return false
                end

                local target, distancesqr, delta = get_backstab_angle(me)

                if target == nil or distancesqr > MAX_DISTANCE_SQR then
                    return false
                end

                local angle = vector(
                    delta:angles()
                )

                buffer.enabled = true
                buffer.yaw_base = 'Local view'

                buffer.yaw = 'Static'
                buffer.yaw_offset = angle.y

                buffer.freestanding_body_yaw = false

                buffer.edge_yaw = false
                buffer.freestanding = false

                buffer.roll = 0

                return true
            end
        end

        local manual_yaw = { } do
            local ref = resource.antiaim.settings.manual_yaw

            local current_dir = nil
            local hotkey_data = { }

            local dir_rotations = {
                ['left'] = -90,
                ['right'] = 90,
                ['forward'] = 180,
                ['backward'] = 0
            }

            local function get_hotkey_state(old_state, state, mode)
                if mode == 1 or mode == 2 then
                    return old_state ~= state
                end

                return false
            end

            local function update_hotkey_state(data, state, mode)
                local active = get_hotkey_state(
                    data.state, state, mode
                )

                data.state = state
                return active
            end

            local function update_hotkey_data(id, dir)
                if hotkey_data[id] == nil then
                    hotkey_data[id] = {
                        state = false
                    }
                end

                local changed = update_hotkey_state(
                    hotkey_data[id], ui.get(id)
                )

                if not changed then
                    return
                end

                if current_dir == dir then
                    current_dir = nil
                else
                    current_dir = dir
                end
            end

            local function on_paint_ui()
                update_hotkey_data(ref.left_hotkey.ref, 'left')
                update_hotkey_data(ref.right_hotkey.ref, 'right')
                update_hotkey_data(ref.forward_hotkey.ref, 'forward')
                update_hotkey_data(ref.backward_hotkey.ref, 'backward')

                update_hotkey_data(ref.reset_hotkey.ref, nil)
            end

            function manual_yaw:get()
                return current_dir
            end

            function manual_yaw:update(cmd)
                local angle = dir_rotations[
                    current_dir
                ]

                if angle == nil then
                    return false
                end

                local yaw = buffer.yaw_offset or 0

                buffer.enabled = true

                buffer.yaw_offset = yaw + angle

                buffer.edge_yaw = false
                buffer.freestanding = false

                buffer.roll = 0

                if ref.disable_yaw_modifiers:get() then
                    buffer.yaw_offset = yaw + angle

                    buffer.yaw_left = 0
                    buffer.yaw_right = 0

                    buffer.yaw_jitter = 'Off'
                    buffer.jitter_offset = 0
                end

                if ref.body_freestanding:get() then
                    buffer.body_yaw = 'Static'
                    buffer.body_yaw_offset = 180
                    buffer.freestanding_body_yaw = true
                end

                local state, items = builder:apply 'Manual AA'

                if state and items ~= nil then
                    buffer.yaw_offset = buffer.yaw_offset + angle

                    if items.defensive ~= nil then
                        if defensive:apply(cmd, items.defensive) then
                            local yaw_offset = buffer.defensive.yaw_offset

                            if yaw_offset ~= nil then
                                buffer.defensive.yaw_offset = yaw_offset + angle
                            end
                        end
                    end
                end

                buffer.yaw_base = 'Local view'

                return true
            end

            client.set_event_callback(
                'paint_ui', on_paint_ui
            )

            antiaim.manual_yaw = manual_yaw
        end

        local freestanding = { } do
            local ref = resource.antiaim.settings.freestanding

            local last_ack_defensive_side = nil
            local freestanding_side = nil

            local function is_value_near(value, target)
                return math.abs(target - value) <= 2.0
            end

            local function get_target_yaw(player)
                local threat = client.current_threat()

                if threat == nil then
                    return nil
                end

                local player_origin = vector(
                    entity.get_origin(player)
                )

                local threat_origin = vector(
                    entity.get_origin(threat)
                )

                local delta = threat_origin - player_origin
                local _, yaw = delta:angles()

                return yaw - 180
            end

            local function get_approximated_side(yaw)
                if is_value_near(yaw, -90) then
                    return -90
                end

                if is_value_near(yaw, 90) then
                    return 90
                end

                return nil
            end

            local function get_side()
                local me = entity.get_local_player()

                if me == nil then
                    return nil
                end

                local entity_data = c_entity(me)

                if entity_data == nil then
                    return nil
                end

                local animstate = entity_data:get_anim_state()

                if animstate == nil then
                    return nil
                end

                local target_yaw = get_target_yaw(me)

                if target_yaw == nil then
                    return nil
                end

                return get_approximated_side(
                    utils.normalize(animstate.eye_angles_y - target_yaw, -180, 180)
                )
            end

            local function is_enabled()
                if not ref.enabled:get() then
                    return false
                end

                if not ref.hotkey:get() then
                    return false
                end

                return true
            end

            local function update_freestanding_options(cmd)
                local items = builder:get 'Freestanding'

                if not builder:is_active_ex(items) then
                    items = nil
                end

                if freestanding_side ~= nil then
                    buffer.pitch = 'Default'

                    -- if ref.options:get 'disable yaw modifiers' then
                    --     buffer.yaw_left = 0
                    --     buffer.yaw_right = 0

                    --     buffer.yaw_jitter = 'Off'
                    --     buffer.jitter_offset = 0
                    -- end

                    -- if ref.options:get 'body freestanding' then
                    --     buffer.body_yaw = 'Static'
                    --     buffer.body_yaw_offset = 180
                    --     buffer.freestanding_body_yaw = true
                    -- end

                    if items ~= nil then
                        builder:apply_ex(items)
                    end
                end

                if localplayer.is_vulnerable then
                    if items ~= nil and items.defensive ~= nil then
                        if defensive:apply(cmd, items.defensive) then
                            local yaw_offset = buffer.defensive.yaw_offset

                            if yaw_offset ~= nil and last_ack_defensive_side ~= nil then
                                buffer.defensive.yaw_offset = yaw_offset + last_ack_defensive_side
                            end
                        else
                            if freestanding_side ~= nil then
                                last_ack_defensive_side = freestanding_side
                            end
                        end
                    end
                end
            end

            function freestanding:update(cmd)
                if not is_enabled() then
                    freestanding_side = nil
                    return
                end

                if cmd.chokedcommands == 0 then
                    freestanding_side = get_side()
                end

                buffer.freestanding = true
                update_freestanding_options(cmd)
            end
        end

        local defensive_flick = { } do
            local ref = resource.antiaim.settings.defensive_flick

            local function get_state()
                if not localplayer.is_onground then
                    if localplayer.is_crouched then
                        return 'Jumping+'
                    end

                    return 'Jumping'
                end

                if localplayer.is_crouched then
                    if localplayer.is_moving then
                        return 'Move-Crouch'
                    end

                    return 'Crouch'
                end

                if localplayer.is_moving then
                    if software.is_slow_motion() then
                        return 'Slow Walk'
                    end

                    return 'Moving'
                end

                return 'Standing'
            end

            local function should_update()
                if not ref.enabled:get() then
                    return false
                end

                local me = entity.get_local_player()

                if me == nil then
                    return false
                end

                local weapon = entity.get_player_weapon(me)

                if weapon == nil then
                    return false
                end

                local weapon_info = csgo_weapons(weapon)

                if weapon_info == nil or weapon_info.is_revolver then
                    return false
                end

                local exp_data = exploit.get()

                if not exp_data.shift then
                    return false
                end

                return ref.states:get(get_state())
            end

            function defensive_flick:update(cmd)
                if not should_update() then
                    return
                end

                local inverter = ref.inverter:get()
                local defensive = exploit.get().defensive

                local is_defensive_active = defensive.left ~= 0
                cmd.force_defensive = cmd.command_number % 7 == 0

                buffer.pitch = is_defensive_active and 'Custom' or 'Default'
                buffer.pitch_offset = 0

                buffer.yaw_base = 'At targets'

                buffer.yaw = '180'
                buffer.yaw_offset = is_defensive_active and 90 or 0

                buffer.yaw_left = 0
                buffer.yaw_right = 0

                buffer.yaw_jitter = 'Off'
                buffer.jitter_offset = 0

                buffer.body_yaw = 'Static'
                buffer.body_yaw_offset = is_defensive_active and -1 or 1

                buffer.freestanding_body_yaw = false

                buffer.edge_yaw = false
                buffer.freestanding = false

                buffer.roll = 0

                if inverter then
                    buffer.yaw_offset = -buffer.yaw_offset
                    -- buffer.body_yaw_offset = -buffer.body_yaw_offset
                end
            end
        end

        local function update_defensive(cmd)
            local list = buffer.defensive

            local exp_data = exploit.get()
            local defensive = exp_data.defensive

            local is_valid = (
                list ~= nil and
                defensive.left > 0
            )

            if not is_valid then
                return false
            end

            buffer:copy(list)
            return true
        end

        local function update_inverter(mode)
            if exploit.get().shift then
                local delay = math.max(
                    1, buffer.delay or 1
                )

                delay_ptr[mode] = delay_ptr[mode] + 1

                if delay_ptr[mode] < delay then
                    return
                end
            end

            local should_invert = true

            if buffer.body_yaw == 'Random' then
                should_invert = utils.random_int(0, 1) == 0
            end

            inverts = inverts + 1

            if should_invert then
                inverted = not inverted
            end

            delay_ptr[mode] = 0
        end

        local function update_antiaims(cmd)
            buffer.freestanding = false

            defensive:update(cmd)

            local state, items = builder:update(cmd)

            if legit_aa:update(cmd) then
                return
            end

            if manual_yaw:update(cmd) then
                return
            end

            if avoid_backstab:update() then
                return
            end

            if state and items ~= nil and items.defensive ~= nil then
                defensive:apply(cmd, items.defensive)
            end

            freestanding:update(cmd)
            defensive_flick:update(cmd)
        end

        local function update_yaw_offset()
            if buffer.body_yaw_offset == nil then
                return
            end

            if buffer.yaw_left ~= nil and buffer.yaw_right ~= nil then
                local yaw = buffer.yaw_offset or 0

                if buffer.body_yaw_offset < 0 then
                    buffer.yaw_offset = yaw + buffer.yaw_left
                end

                if buffer.body_yaw_offset > 0 then
                    buffer.yaw_offset = yaw + buffer.yaw_right
                end

                return
            end
        end

        local function update_yaw_jitter()
            if buffer.yaw_jitter == 'Offset' then
                local yaw = buffer.yaw_offset or 0
                local offset = buffer.jitter_offset

                buffer.yaw_jitter = 'Off'
                buffer.jitter_offset = 0

                buffer.yaw_offset = yaw + (inverted and offset or 0)

                return
            end

            if buffer.yaw_jitter == 'Center' then
                local yaw = buffer.yaw_offset or 0
                local offset = buffer.jitter_offset

                if not inverted then
                    offset = -offset
                end

                buffer.yaw_jitter = 'Off'
                buffer.jitter_offset = 0

                buffer.yaw_offset = yaw + offset / 2

                return
            end

            if buffer.yaw_jitter == 'Skitter' then
                local index = inverts % #skitter
                local multiplier = skitter[index + 1]

                local yaw = buffer.yaw_offset or 0
                local offset = buffer.jitter_offset

                buffer.yaw_jitter = 'Off'
                buffer.jitter_offset = 0

                buffer.yaw_offset = yaw + (offset * multiplier)

                return
            end

            if buffer.yaw_jitter == 'Spin' then
                local time = globals.curtime() * 3

                local yaw = buffer.yaw_offset or 0
                local offset = buffer.jitter_offset

                buffer.yaw_jitter = 'Off'
                buffer.jitter_offset = 0

                buffer.yaw_offset = yaw + utils.lerp(
                    -offset, offset, time % 1
                )

                return
            end
        end

        local function update_body_yaw()
            if buffer.body_yaw == 'Jitter' then
                local offset = buffer.body_yaw_offset

                if offset == 0 then
                    offset = 1
                end

                if not inverted then
                    offset = -offset
                end

                buffer.body_yaw = 'Static'
                buffer.body_yaw_offset = offset
            end

            if buffer.body_yaw == 'Random' then
                local offset = buffer.body_yaw_offset

                if offset == 0 then
                    offset = 1
                end

                buffer.body_yaw = 'Static'
                buffer.body_yaw_offset = inverted and offset or -offset
            end
        end

        local function update_buffer(cmd)
            local mode = 'default'

            if update_defensive(cmd) then
                mode = 'defensive'
            end

            if cmd.chokedcommands == 0 then
                update_inverter(mode)
            end

            update_body_yaw()
            update_yaw_jitter()
            update_yaw_offset()
        end

        local function on_shutdown()
            buffer:clear()
            buffer:unset()
        end

        local function on_setup_command(cmd)
            buffer:clear()
            buffer:unset()

            update_antiaims(cmd)
            update_buffer(cmd)

            buffer:set()
        end

        client.set_event_callback('shutdown', on_shutdown)
        client.set_event_callback('setup_command', on_setup_command)
    end

    local visuals = { } do
        local watermark do
            local ref = resource.visuals.watermark

            local TITLE = string.format(
                '%s %s', script.name, script.build
            )

            local function get_text_array(text)
                local arr, size = { }, #text

                for i = 1, size do
                    arr[i] = text:sub(i, i)
                end

                return arr, size
            end

            local function get_caps_animation(text, time, start_pos, end_pos)
                local arr, size = get_text_array(text)
                local delta_pos = end_pos - start_pos + 1

                local index = start_pos + math.floor(time % delta_pos)

                if arr[index] ~= nil then
                    arr[index] = arr[index]:upper()
                end

                return table.concat(arr, nil, 1, size)
            end

            local function draw_default()
                local screen_size = vector(
                    client.screen_size()
                )

                local position = vector(
                    screen_size.x * 0.5,
                    screen_size.y - 8
                )

                local str = TITLE do
                    local time = globals.realtime() * 4

                    str = get_caps_animation(
                        str, time, 2, #str
                    )
                end

                local text_size = vector(
                    renderer.measure_text('', str)
                )

                position.x = position.x - text_size.x * 0.5 + 0.5
                position.y = position.y - text_size.y

                renderer.text(position.x, position.y, 255, 255, 255, 200, '', nil, str)
            end

            local function draw_alternative()
                local screen_size = vector(
                    client.screen_size()
                )

                local position = vector(
                    screen_size.x * 0.5,
                    screen_size.y - 8
                )

                local r0, g0, b0, a0 = 255, 255, 255, 255

                local text_list = { } do
                    local time = globals.realtime() * 3

                    local r1, g1, b1, a1 = 80, 80, 80, 255
                    local r2, g2, b2, a2 = ref.color:get()

                    table.insert(text_list, string.format(
                        '%s {%s\a%s}', script.name, text_anims.gradient(
                            script.build, time, r1, g1, b1, a1, r2, g2, b2, a2
                        ), utils.to_hex(r0, g0, b0, a0)
                    ))

                    table.insert(text_list, string.format(
                        'delay: %dms', client.latency() * 1000
                    ))

                    table.insert(text_list, string.format(
                        '%02d:%02d:%02d', client.system_time()
                    ))
                end

                local text = table.concat(text_list, '   ')

                local text_size = vector(
                    renderer.measure_text('', text)
                )

                local box_size = text_size + vector(8, 10)

                position.x = position.x - box_size.x * 0.5
                position.y = position.y - box_size.y

                local text_pos = position + (box_size - text_size) * 0.5

                renderer.rectangle(position.x, position.y, box_size.x, box_size.y, 32, 32, 32, 50)
                renderer.text(text_pos.x, text_pos.y, r0, g0, b0, a0, '', nil, text)
            end

            local callbacks do
                local function on_select(item)
                    local value = item:get()

                    utils.event_callback('paint_ui', draw_default, value == 'Default')
                    utils.event_callback('paint_ui', draw_alternative, value == 'Alternative')
                end

                ref.select:set_callback(
                    on_select, true
                )
            end
        end

        local indicators do
            local ref = resource.visuals.indicators

            local y_offset = 0

            local TITLE_NAME = script.name:upper()
            local BUILD_NAME = script.build:upper()

            local draw_sparkles_indicators do
                local stars = {
                    { '★', -1, 7, 0.6 },
                    { '⋆', -8, 3, 0.2 },
                    { '✨', -2, 8, 0.7 },
                    { '✦', -2, 12, 0.5 },
                    { '★', -3, 8, 0.4 },
                    { '⋆', -5, 4, 0.3 },
                    { '✨', -3, 6, 0.7 },
                    { '⋆', -4, 5, 0.2 }
                }

                local alpha_value = 0.0
                local align_value = 0.0

                local dt_value = 0.0
                local dmg_value = 0.0
                local osaa_value = 0.0

                local function get_state()
                    if not localplayer.is_onground then
                        if localplayer.is_crouched then
                            return 'jump+'
                        end

                        return 'jump'
                    end

                    if localplayer.is_crouched then
                        return 'crouch'
                    end

                    if localplayer.is_moving then
                        if software.is_slow_motion() then
                            return 'slow'
                        end

                        return 'move'
                    end

                    return 'stand'
                end

                local function draw_stars(position, r, g, b, a)
                    local time = globals.realtime()

                    local dpi = 1.0

                    local x, y = position.x, position.y

                    local sizes, len = { }, #stars
                    local width, height = 0, 0

                    for i = 1, len do
                        local data = stars[i]

                        local measure = vector(
                            renderer.measure_text('', data[1])
                        )

                        width = width + (measure.x + data[2]) * dpi
                        height = math.max(height, measure.y + data[3])

                        sizes[i] = measure
                    end

                    x = round(x - (width * 0.5) * (1 - align_value))

                    for i = 1, len do
                        local star = stars[i]
                        local size = sizes[i]

                        local text = star[1]

                        local offset_x = star[2]
                        local offset_y = star[3]

                        local phase = star[4]

                        local phase_value = math.sin(time * phase) do
                            phase_value = phase_value * 0.5 + 0.5
                            phase_value = phase_value * 0.7 + 0.3
                        end

                        renderer.text(
                            x + offset_x, y + offset_y,
                            r, g, b, a * phase_value,
                            '', nil, text
                        )

                        x = x + (size.x + offset_x) * dpi
                    end

                    position.y = position.y + height * 0.58 * dpi
                end

                local function draw_state(position, r, g, b, a, alpha)
                    local text, flags = get_state(), ''

                    local measure = vector(
                        renderer.measure_text(flags, text)
                    )

                    local x, y = position.x, position.y do
                        x = round(x - (measure.x * 0.5) * (1 - align_value))
                    end

                    renderer.text(x, y, r, g, b, a * alpha, flags, nil, text)

                    position.y = position.y + round(measure.y)
                end

                local function draw_title(position, r1, g1, b1, a1, r2, g2, b2, a2)
                    local text, flags = script.name, 'b'

                    local measure = vector(
                        renderer.measure_text(flags, text)
                    )

                    local time = -globals.realtime()

                    text = text_anims.gradient(
                        text, time * 1.25,
                        r1, g1, b1, a1,
                        r2, g2, b2, a2
                    )

                    local x, y = position.x, position.y do
                        x = round(x - (measure.x * 0.5) * (1 - align_value))
                    end

                    renderer.text(x, y, r1, g1, b1, a1, flags, nil, text)

                    position.y = position.y + measure.y
                end

                local function draw_double_tap(position, r, g, b, a, alpha)
                    local text, flags = 'dt', ''

                    local measure = vector(
                        renderer.measure_text(flags, text)
                    )

                    local x, y = position.x, position.y do
                        x = round(x - (measure.x * 0.5) * (1 - align_value))
                    end

                    if software.is_duck_peek_assist() then
                        a = a * 0.5
                    end

                    renderer.text(x, y, r, g, b, a * alpha, flags, nil, text)

                    position.y = position.y + round(measure.y * alpha)
                end

                local function draw_minimum_damage(position, r, g, b, a, alpha)
                    local text, flags = 'dmg', ''

                    local measure = vector(
                        renderer.measure_text(flags, text)
                    )

                    local x, y = position.x, position.y do
                        x = round(x - (measure.x * 0.5) * (1 - align_value))
                    end

                    renderer.text(x, y, r, g, b, a * alpha, flags, nil, text)

                    position.y = position.y + round(measure.y * alpha)
                end

                local function draw_onshot_antiaim(position, r, g, b, a, alpha)
                    local text, flags = 'hs', ''

                    local measure = vector(
                        renderer.measure_text(flags, text)
                    )

                    local x, y = position.x, position.y do
                        x = round(x - (measure.x * 0.5) * (1 - align_value))
                    end

                    renderer.text(x, y, r, g, b, a * alpha, flags, nil, text)

                    position.y = position.y + round(measure.y * alpha)
                end

                local function update_values(me)
                    local is_alive = entity.is_alive(me)
                    local is_scoped = entity.get_prop(me, 'm_bIsScoped')

                    local is_double_tap = software.is_double_tap_active()
                    local is_min_damage = software.is_override_minimum_damage()
                    local is_onshot_aa = software.is_on_shot_antiaim_active()

                    alpha_value = motion.interp(alpha_value, is_alive, 0.04)
                    align_value = motion.interp(align_value, is_scoped == 1, 0.04)

                    dt_value = motion.interp(dt_value, is_double_tap, 0.04)
                    dmg_value = motion.interp(dmg_value, is_min_damage, 0.04)
                    osaa_value = motion.interp(osaa_value, is_onshot_aa, 0.04)
                end

                local function draw_indicators()
                    local screen = vector(client.screen_size())
                    local position = screen * 0.5

                    local r1, g1, b1, a1 = ref.color_accent:get()
                    local r2, g2, b2, a2 = ref.color_secondary:get()

                    position.x = position.x + round(10 * align_value)
                    position.y = position.y + y_offset

                    a1 = a1 * alpha_value
                    a2 = a2 * alpha_value

                    draw_stars(position, r1, g1, b1, a1 * 0.75)

                    draw_title(position, r1, g1, b1, a1, r2, g2, b2, a2)
                    draw_state(position, 255, 255, 255, 255, alpha_value)

                    draw_double_tap(position, 255, 255, 255, 255, dt_value * alpha_value)
                    draw_onshot_antiaim(position, 255, 255, 255, 255 * (1 - dt_value * 0.5), (1 - dt_value) * osaa_value * alpha_value)
                    draw_minimum_damage(position, 255, 255, 255, 255, dmg_value * alpha_value)
                end

                function draw_sparkles_indicators()
                    local me = entity.get_local_player()

                    if me == nil then
                        return
                    end

                    update_values(me)

                    if alpha_value > 0 then
                        draw_indicators()
                    end
                end
            end

            local draw_default_indicators do
                local old_exploit = ''

                local alpha_value = 0.0
                local align_value = 0.0

                local state_width = 0

                local dt_value = 0.0
                local dmg_value = 0.0
                local osaa_value = 0.0
                local exploit_value = 0.0

                local function is_holding_grenade(player)
                    local weapon = entity.get_player_weapon(player)

                    if weapon == nil then
                        return false
                    end

                    local weapon_info = csgo_weapons(weapon)

                    if weapon_info == nil then
                        return false
                    end

                    local weapon_type = weapon_info.type

                    if weapon_type ~= 'grenade' then
                        return false
                    end

                    return true
                end

                local function get_pulse(a, b)
                    local time = 0.6 + globals.realtime() * 3.0
                    local pulse = math.abs(math.sin(time))

                    return utils.lerp(a, b, pulse)
                end

                local function get_state()
                    if not localplayer.is_onground then
                        return '-AIR-'
                    end

                    if localplayer.is_crouched then
                        return '-CROUCH-'
                    end

                    if localplayer.is_moving then
                        if software.is_slow_motion() then
                            return '-WALKING-'
                        end

                        return '-MOVING-'
                    end

                    return '-STANDING-'
                end

                local function get_exploit_text()
                    if software.is_double_tap_active() then
                        old_exploit = 'DT'
                    elseif software.is_on_shot_antiaim_active() then
                        old_exploit = 'HIDE'
                    end

                    return old_exploit
                end

                local function update_text_alpha(text, alpha)
                    local result = text:gsub('\a(%x%x%x%x%x%x)(%x%x)', function(rgb, a)
                        return '\a' .. rgb .. string.format('%02x', tonumber(a, 16) * alpha)
                    end)

                    return result
                end

                local function draw_title(position, r1, g1, b1, a1, r2, g2, b2, a2, alpha)
                    local flags, pad = '-', 1

                    local title1, title2 = TITLE_NAME, BUILD_NAME

                    local measure1 = vector(renderer.measure_text(flags, title1))
                    local measure2 = vector(renderer.measure_text(flags, title2))

                    local width = measure1.x + measure2.x + pad
                    local height = math.max(measure1.y, measure2.y)

                    local x, y = position:unpack() do
                        x = round(x - (2 + width * 0.5) * (1 - align_value))
                    end

                    local pulse = get_pulse(0.25, 1.0)

                    renderer.text(x, y, r2, g2, b2, a2 * alpha, flags, nil, title1)
                    x = x + measure1.x + pad

                    renderer.text(x, y, r1, g1, b1, a1 * alpha * pulse, flags, nil, title2)
                    position.y = position.y + height
                end

                local function draw_state(position, r, g, b, a, alpha)
                    local text, flags = get_state(), '-'

                    local measure = vector(
                        renderer.measure_text(flags, text)
                    )

                    measure.x = measure.x + 1

                    if measure.x < state_width then
                        state_width = measure.x
                    else
                        state_width = motion.interp(
                            state_width, measure.x, 0.045
                        )
                    end

                    local x, y = position:unpack() do
                        x = round(x - (2 + state_width * 0.5) * (1 - align_value))
                    end

                    renderer.text(x, y, r, g, b, a * alpha, flags, round(state_width), text)
                    position.y = position.y + measure.y
                end

                local function draw_exploit(position, alpha, global_alpha)
                    local exp = exploit.get()
                    local def = exp.defensive

                    local text, flags = get_exploit_text(), '-'
                    local status, r, g, b, a = 'IDLE', 255, 255, 255, 200

                    if exploit_value == 1 then
                        if def.left > 0 then
                            status = 'ACTIVE'
                            r, g, b, a = 120, 255, 255, 255
                        else
                            status = 'READY'
                            r, g, b, a = 192, 255, 109, 255
                        end
                    elseif exploit_value == 0 then
                        status = 'WAITING'
                        r, g, b, a = 255, 64, 64, 128
                    else
                        status = 'CHARGING'

                        r = utils.lerp(255, 192, exploit_value)
                        g = utils.lerp(64, 255, exploit_value)
                        b = utils.lerp(64, 145, exploit_value)
                        a = 255
                    end

                    text = string.format(
                        '\a%s%s \a%s%s',
                        utils.to_hex(255, 255, 255, a), text,
                        utils.to_hex(r, g, b, a), status
                    )

                    local global_text = update_text_alpha(text, global_alpha * alpha)
                    local alpha_text = update_text_alpha(global_text, 0.5 * alpha)

                    local measure = vector(renderer.measure_text(flags, text)) do
                        measure.x = measure.x + 1
                    end

                    local width = round(measure.x * alpha)
                    local height = round(measure.y * alpha)

                    local charge_width = round(width * exploit_value)

                    local x, y = position:unpack() do
                        x = round(x - (1 + width * 0.5) * (1 - align_value))
                    end

                    if charge_width ~= 0 then
                        renderer.text(x, y, r, g, b, a * alpha * global_alpha, flags, charge_width, global_text)
                    end

                    if width ~= 0 then
                        renderer.text(x, y, r, g, b, a * alpha * global_alpha, flags, width, alpha_text)
                    end

                    position.y = position.y + height
                end

                local function draw_minimum_damage(position, alpha, global_alpha)
                    local text, flags = 'DMG', '-'

                    local measure = vector(
                        renderer.measure_text(flags, text)
                    )

                    measure.x = measure.x + 1

                    local width = round(measure.x)
                    local height = round(measure.y * alpha)

                    if width == 0 then
                        return
                    end

                    local x, y = position:unpack() do
                        x = round(x - (2 + width * 0.5) * (1 - align_value))
                    end

                    renderer.text(x, y, 255, 255, 255, 255 * alpha * global_alpha, flags, width, text)
                    position.y = position.y + height
                end

                local function update_values(me)
                    local exp = exploit.get()

                    local is_alive = entity.is_alive(me)
                    local is_scoped = entity.get_prop(me, 'm_bIsScoped')

                    local is_grenade = is_holding_grenade(me)

                    local is_double_tap = software.is_double_tap_active()
                    local is_min_damage = software.is_override_minimum_damage()
                    local is_onshot_aa = software.is_on_shot_antiaim_active()

                    local alpha = 0.0

                    if is_alive then
                        alpha = is_grenade and 0.5 or 1.0
                    end

                    alpha_value = motion.interp(alpha_value, alpha, 0.04)
                    align_value = motion.interp(align_value, is_scoped == 1, 0.04)

                    dt_value = motion.interp(dt_value, is_double_tap, 0.03)
                    dmg_value = motion.interp(dmg_value, is_min_damage, 0.03)
                    osaa_value = motion.interp(osaa_value, is_onshot_aa, 0.03)
                    exploit_value = motion.interp(exploit_value, exp.shift, 0.025)

                    if not exp.shift then
                        exploit_value = 0
                    end
                end

                local function draw_indicators()
                    local screen = vector(client.screen_size())
                    local position = screen * 0.5

                    local r1, g1, b1, a1 = ref.color_accent:get()
                    local r2, g2, b2, a2 = ref.color_secondary:get()

                    position.x = position.x + round(10 * align_value)
                    position.y = position.y + y_offset

                    draw_title(position, r1, g1, b1, a1, r2, g2, b2, a2, alpha_value)
                    draw_state(position, 255, 255, 255, 255, alpha_value)

                    draw_exploit(position, math.max(dt_value, osaa_value), alpha_value)
                    draw_minimum_damage(position, dmg_value, alpha_value)
                end

                function draw_default_indicators()
                    local me = entity.get_local_player()

                    if me == nil then
                        return
                    end

                    update_values(me)

                    if alpha_value > 0 then
                        draw_indicators()
                    end
                end
            end

            local callbacks do
                local function on_style(item)
                    local value = item:get()

                    utils.event_callback('paint_ui', draw_default_indicators, value == 'Default')
                    utils.event_callback('paint_ui', draw_sparkles_indicators, value == 'Sparkles')
                end

                local function on_offset(item)
                    y_offset = item:get() * 5
                end

                local function on_enabled(item)
                    local value = item:get()

                    if value then
                        ref.style:set_callback(on_style, true)
                        ref.offset:set_callback(on_offset, true)
                    else
                        ref.style:unset_callback(on_style)
                        ref.offset:unset_callback(on_offset)
                    end

                    if not value then
                        utils.event_callback('paint_ui', draw_default_indicators, false)
                        utils.event_callback('paint_ui', draw_sparkles_indicators, false)
                    end
                end

                ref.enabled:set_callback(
                    on_enabled, true
                )
            end
        end

        local manual_arrows do
            local ref = resource.visuals.manual_arrows

            local draw_default do
                local PADDING = 40

                local left_value = 0
                local right_value = 0
                local forward_value = 0

                local scope_align = 0

                local function update_values(me)
                    local value = antiaim.manual_yaw:get()

                    local is_alive = entity.is_alive(me)
                    local is_scoped = entity.get_prop(me, 'm_bIsScoped')

                    left_value = motion.interp(left_value, is_alive and value == 'left', 0.05)
                    right_value = motion.interp(right_value, is_alive and value == 'right', 0.05)
                    forward_value = motion.interp(forward_value, is_alive and value == 'forward', 0.05)

                    scope_align = motion.interp(scope_align, is_scoped, 0.05)
                end

                local function draw_left_arrow(x, y, r, g, b, a, alpha)
                    if alpha <= 0 then
                        return
                    end

                    local flags, text = '+', '<'

                    local text_size = vector(
                        renderer.measure_text(
                            flags, text
                        )
                    )

                    x = x - round(text_size.x - 1)
                    y = y - round(text_size.y / 2)

                    renderer.text(x, y, r, g, b, a * alpha, flags, nil, text)
                end

                local function draw_right_arrow(x, y, r, g, b, a, alpha)
                    if alpha <= 0 then
                        return
                    end

                    local flags, text = '+', '>'

                    local text_size = vector(
                        renderer.measure_text(
                            flags, text
                        )
                    )

                    y = y - round(text_size.y / 2)

                    renderer.text(x, y, r, g, b, a * alpha, flags, nil, text)
                end

                local function draw_forward_arrow(x, y, r, g, b, a, alpha)
                    if alpha <= 0 then
                        return
                    end

                    local flags, text = '+', '^'

                    local text_size = vector(
                        renderer.measure_text(
                            flags, text
                        )
                    )

                    x = x - round(text_size.x / 2)
                    y = y - round(text_size.y * 0.5)

                    renderer.text(x, y, r, g, b, a * alpha, flags, nil, text)
                end

                local function draw_arrows()
                    local r, g, b, a = ref.color_accent:get()

                    local screen_size = vector(
                        client.screen_size()
                    )

                    local position = screen_size / 2

                    draw_forward_arrow(position.x, position.y - PADDING, r, g, b, a, forward_value)

                    position.y = position.y - round(
                        scope_align * 15
                    )

                    draw_left_arrow(position.x - PADDING, position.y, r, g, b, a, left_value)
                    draw_right_arrow(position.x + PADDING, position.y, r, g, b, a, right_value)
                end

                function draw_default()
                    local me = entity.get_local_player()

                    if me == nil then
                        return
                    end

                    update_values(me)
                    draw_arrows()
                end
            end

            local draw_alternative do
                local PADDING = 40

                local function draw_arrows()
                    local screen_size = vector(
                        client.screen_size()
                    )

                    local position = screen_size / 2

                    local color_accent = color(ref.color_accent:get())
                    local color_secondary = color(ref.color_secondary:get())

                    local manual_value = antiaim.manual_yaw:get()
                    local desync_angle = antiaim.buffer.body_yaw_offset

                    local x_offset = PADDING
                    local rect_size = 2

                    local width = 13
                    local height = 9

                    local color_inactive = color(35, 35, 35, 150)

                    local left_manual = manual_value == 'left' and color_accent or color_inactive
                    local right_manual = manual_value == 'right' and color_accent or color_inactive

                    local left_desync = (desync_angle ~= nil and desync_angle < 0) and color_secondary or color_inactive
                    local right_desync = (desync_angle ~= nil and desync_angle > 0) and color_secondary or color_inactive

                    local left_x = position.x - x_offset - (rect_size + 2)
                    local right_x = position.x + x_offset + (rect_size + 2)

                    left_desync = left_desync:clone()
                    right_desync = right_desync:clone()

                    renderer.triangle(left_x - width, position.y, left_x, position.y - height, left_x, position.y + height, left_manual:unpack())
                    renderer.triangle(right_x + width, position.y, right_x, position.y - height, right_x, position.y + height, right_manual:unpack())

                    renderer.rectangle(left_x + rect_size + 2, position.y - height, -rect_size, height * 2, left_desync:unpack())
                    renderer.rectangle(right_x - rect_size - 2, position.y - height, rect_size, height * 2, right_desync:unpack())
                end

                function draw_alternative()
                    local me = entity.get_local_player()

                    if me == nil or not entity.is_alive(me) then
                        return
                    end

                    draw_arrows()
                end
            end

            local callbacks do
                local function on_style(item)
                    local value = item:get()

                    utils.event_callback('paint_ui', draw_default, value == 'Default')
                    utils.event_callback('paint_ui', draw_alternative, value == 'Alternative')
                end

                local function on_enabled(item)
                    local value = item:get()

                    if value then
                        ref.style:set_callback(on_style, true)
                    else
                        ref.style:unset_callback(on_style)
                    end

                    if not value then
                        utils.event_callback('paint_ui', draw_default, false)
                        utils.event_callback('paint_ui', draw_alternative, false)
                    end
                end

                ref.enabled:set_callback(
                    on_enabled, true
                )
            end
        end

        local velocity_warning do
            local ref = resource.visuals.velocity_warning

            local alpha_value = 0

            local function draw_bar(x, y, w, h, r, g, b, a, alpha)
                render.glow(x, y, w, h, r, g, b, a * alpha * 0.075, 1, 8)
                renderer.rectangle(x, y, w, h, 0, 0, 0, a / 2 * alpha)
            end

            local function on_paint()
                local me = entity.get_local_player()

                if me == nil then
                    return
                end

                local screen_size = vector(
                    client.screen_size()
                )

                local position = vector(
                    screen_size.x * 0.5,
                    ref.offset:get() * 2
                )

                local is_alive = entity.is_alive(me)
                local is_menu_open = ui.is_menu_open()

                local velocity_modifier = entity.get_prop(
                    me, 'm_flVelocityModifier'
                )

                if not is_alive then
                    velocity_modifier = 1.0
                end

                local should_interp = is_menu_open or (is_alive and velocity_modifier < 1.0)

                alpha_value = motion.interp(alpha_value, should_interp, 0.05)

                if alpha_value <= 0 then
                    return
                end

                local fill_color = color(
                    ref.color:get()
                )

                local text_color = color(
                    255, 255, 255, 200
                )

                text_color.a = text_color.a * alpha_value

                local flags, text = '', string.format(
                    'Your velocity is reduced by %d%%',
                    (1 - velocity_modifier) * 100
                )

                local text_size = vector(
                    renderer.measure_text(flags, text)
                )

                local text_pos = position + vector(
                    -text_size.x * 0.5 + 1, 0
                )

                renderer.text(text_pos.x, text_pos.y, text_color.r, text_color.g, text_color.b, text_color.a, flags, nil, text)

                position.y = position.y + text_size.y + 7

                if fill_color.a > 0 then
                    local rect_size = vector(180, 4)

                    local rect_pos = position + vector(
                        -rect_size.x * 0.5, 0
                    )

                    draw_bar(
                        rect_pos.x, rect_pos.y, rect_size.x, rect_size.y,
                        fill_color.r, fill_color.g, fill_color.b, fill_color.a,
                        alpha_value
                    )

                    renderer.rectangle(
                        rect_pos.x + 1, rect_pos.y + 1, (rect_size.x - 2) * velocity_modifier, rect_size.y - 2,
                        fill_color.r, fill_color.g, fill_color.b, fill_color.a * alpha_value
                    )
                end
            end

            local callbacks do
                local function on_enabled(item)
                    local value = item:get()

                    utils.event_callback(
                        'paint',
                        on_paint,
                        value
                    )
                end

                ref.enabled:set_callback(
                    on_enabled, true
                )
            end
        end
    end

    local misc = { } do
        local increase_ladder_movement do
            local ref = resource.misc.increase_ladder_movement

            local MOVETYPE_LADDER = 9

            local function on_setup_command(cmd)
                local me = entity.get_local_player()

                if me == nil then
                    return
                end

                local movetype = entity.get_prop(
                    me, 'm_movetype'
                )

                if movetype ~= MOVETYPE_LADDER then
                    return
                end

                local pitch = client.camera_angles()

				cmd.yaw = round(cmd.yaw)
				cmd.roll = 0

				if cmd.forwardmove > 0 and pitch < 45 then
					cmd.pitch = 89
					cmd.in_moveright, cmd.in_moveleft, cmd.in_forward, cmd.in_back = 1, 0, 0, 1

					if cmd.sidemove == 0 then cmd.yaw = cmd.yaw + 90 end
					if cmd.sidemove < 0 then cmd.yaw = cmd.yaw + 150 end
					if cmd.sidemove > 0 then cmd.yaw = cmd.yaw + 30 end
				elseif cmd.forwardmove < 0 then
					cmd.pitch = 89
					cmd.in_moveleft, cmd.in_moveright, cmd.in_forward, cmd.in_back = 1, 0, 1, 0

					if cmd.sidemove == 0 then cmd.yaw = cmd.yaw + 90 end
					if cmd.sidemove > 0 then cmd.yaw = cmd.yaw + 150 end
					if cmd.sidemove < 0 then cmd.yaw = cmd.yaw + 30 end
				end
            end

            local callbacks do
                local function on_enabled(item)
                    utils.event_callback(
                        'setup_command',
                        on_setup_command,
                        item:get()
                    )
                end

                ref.enabled:set_callback(
                    on_enabled, true
                )
            end
        end

        local animation_breaker do
            local ref = resource.misc.animation_breaker

            local MOVETYPE_WALK = 2

            local ANIMATION_LAYER_MOVEMENT_MOVE = 6
            local ANIMATION_LAYER_LEAN = 12

            local function update_onground(player)
                if localplayer.is_onground then
                    local value = ref.onground_legs:get()

                    if value == 'Static' then
                        override.set(software.antiaimbot.other.leg_movement, 'Always slide')
                        entity.set_prop(player, 'm_flPoseParameter', 0, 0)

                        return
                    end

                    if value == 'Jitter' then
                        override.set(software.antiaimbot.other.leg_movement, 'Always slide')
                        entity.set_prop(player, 'm_flPoseParameter', 1, globals.tickcount() % 4 > 1 and 0.5 or 1)

                        return
                    end

                    if value == 'Alien' then
                        override.set(software.antiaimbot.other.leg_movement, 'Never slide')
                        entity.set_prop(player, 'm_flPoseParameter', 0, 7)

                        return
                    end
                end

                override.unset(software.antiaimbot.other.leg_movement)
            end

            local function update_in_air(player)
                local value = ref.in_air_legs:get()

                if value == 'off' then
                    return
                end

                if localplayer.is_onground then
                    return
                end

                if value == 'Static' then
                    entity.set_prop(player, 'm_flPoseParameter', 0.5, 6)

                    return
                end

                if value == 'Alien' then
                    if not localplayer.is_moving then
                        return
                    end

                    local entity_info = c_entity(player)

                    if entity_info == nil then
                        return
                    end

                    local layer_move = entity_info:get_anim_overlay(
                        ANIMATION_LAYER_MOVEMENT_MOVE
                    )

                    if layer_move == nil then
                        return
                    end

                    layer_move.weight = 1

                    return
                end
            end

            local function update_earthquake(player)
                if not ref.freeburger:get() then
                    return
                end

                local entity_info = c_entity(player)

                if entity_info == nil then
                    return
                end

                local layer_lean = entity_info:get_anim_overlay(
                    ANIMATION_LAYER_LEAN
                )

                if layer_lean == nil then
                    return
                end

                layer_lean.weight = utils.random_float(0, 1)
            end

            local function update_body_lean(player)
                local value = ref.adjust_lean:get()

                if value == 0 then
                    return
                end

                local entity_info = c_entity(player)

                if entity_info == nil then
                    return
                end

                local layer_lean = entity_info:get_anim_overlay(
                    ANIMATION_LAYER_LEAN
                )

                if layer_lean == nil then
                    return
                end

                layer_lean.weight = value * 0.1
            end

            local function update_pitch_on_land(player)
                if not ref.pitch_on_land:get() then
                    return
                end

                if not localplayer.is_onground then
                    return
                end

                local entity_info = c_entity(player)

                if entity_info == nil then
                    return
                end

                local animstate = entity_info:get_anim_state()

                if animstate == nil or not animstate.hit_in_ground_animation then
                    return
                end

                entity.set_prop(player, 'm_flPoseParameter', 0.5, 12)
            end

            local function on_pre_render()
                local me = entity.get_local_player()

                if me == nil then
                    return
                end

                local movetype = entity.get_prop(
                    me, 'm_movetype'
                )

                if movetype == MOVETYPE_WALK then
                    update_onground(me)
                    update_in_air(me)
                    update_pitch_on_land(me)
                end

                update_body_lean(me)
                update_earthquake(me)
            end

            local callbacks do
                local function on_enabled(item)
                    local value = item:get()

                    if not value then
                        override.unset(software.antiaimbot.other.leg_movement)
                    end

                    utils.event_callback(
                        'pre_render',
                        on_pre_render,
                        value
                    )
                end

                ref.enabled:set_callback(
                    on_enabled, true
                )
            end
        end

        local walking_on_quick_peek do
            local ref = resource.misc.walking_on_quick_peek

            local MOVETYPE_WALK = 2

            local IN_FORWARD   = bit.lshift(1, 3)
            local IN_BACK      = bit.lshift(1, 4)
            local IN_MOVELEFT  = bit.lshift(1, 9)
            local IN_MOVERIGHT = bit.lshift(1, 10)

            local function on_finish_command(e)
                if not software.is_quick_peek_assist() then
                    return
                end

                local me = entity.get_local_player()

                if me == nil then
                    return
                end

                local movetype = entity.get_prop(
                    me, 'm_movetype'
                )

                if movetype ~= MOVETYPE_WALK then
                    return
                end

                local cmd = iinput.get_usercmd(
                    0, e.command_number
                )

                if cmd == nil then
                    return
                end

                cmd.buttons = bit.band(cmd.buttons, bit.bnot(IN_FORWARD))
                cmd.buttons = bit.band(cmd.buttons, bit.bnot(IN_BACK))
                cmd.buttons = bit.band(cmd.buttons, bit.bnot(IN_MOVELEFT))
                cmd.buttons = bit.band(cmd.buttons, bit.bnot(IN_MOVERIGHT))
            end

            local callbacks do
                local function on_enabled(item)
                    utils.event_callback(
                        'finish_command',
                        on_finish_command,
                        item:get()
                    )
                end

                ref.enabled:set_callback(
                    on_enabled, true
                )
            end
        end
    end
end