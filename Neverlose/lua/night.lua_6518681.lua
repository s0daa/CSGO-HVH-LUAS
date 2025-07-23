-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local pui = require('neverlose/pui');
local clipboard = require('neverlose/clipboard');
local base64 = require('neverlose/base64');
local script = {}; do
    script.build = 'beta'
    script.name = common.get_username()
end
ffi.cdef [[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct {
        char  pad_0000[20];
        int m_nOrder; //0x0014
        int m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030
        char  pad_0038[4]; //0x0034
    } animstate_layer_t;

    typedef struct {
        float m_flPoseParameter[24]; // Assuming it has 24 elements
    } CPlayer;
]]
local function this_call(call_function, parameters) return function(...) return call_function(parameters, ...) end end
local entity_list_003 = ffi.cast(ffi.typeof('uintptr_t**'),
    utils.create_interface('client.dll', 'VClientEntityList003'))
local get_entity_address = this_call(ffi.cast('get_client_entity_t', entity_list_003[0][3]), entity_list_003)
local helpers = {}; do
    helpers.lerp = function(a, b, t)
        return a + (b - a) * t
    end
    helpers.breath = function(x)
        x = x % 2.0

        if x > 1.0 then
            x = 2.0 - x
        end

        return x
    end
    helpers.u8 = function(s)
        return string.gsub(s, '[\128-\191]', '')
    end
    helpers.gradient = function(s, clock, clr1, clr2)
        local buffer = {}

        local len = #helpers.u8(s)
        local div = 1 / (len - 1)

        local add_r = clr2.r - clr1.r
        local add_g = clr2.g - clr1.g
        local add_b = clr2.b - clr1.b
        local add_a = clr2.a - clr1.a

        for char in string.gmatch(s, '.[\128-\191]*') do
            local t = helpers.breath(clock)

            local r = clr1.r + add_r * t
            local g = clr1.g + add_g * t
            local b = clr1.b + add_b * t
            local a = clr1.a + add_a * t

            buffer[#buffer + 1] = '\a'
            buffer[#buffer + 1] = color(r, g, b, a):to_hex()
            buffer[#buffer + 1] = char

            clock = clock - div
        end

        return table.concat(buffer)
    end
    helpers.extrapolate = function(ent, origin, ticks)
        local tickinterval = globals.tickinterval

        local sv_gravity = cvar.sv_gravity:float() * tickinterval
        local sv_jump_impulse = cvar.sv_jump_impulse:float() * tickinterval

        local p_origin, prev_origin = origin, origin

        local velocity = vector(ent.m_vecVelocity)
        local gravity = velocity.z > 0 and -sv_gravity or sv_jump_impulse

        for i = 1, ticks do
            prev_origin = p_origin
            p_origin = vector(
                p_origin.x + (velocity.x * tickinterval),
                p_origin.y + (velocity.y * tickinterval),
                p_origin.z + (velocity.z + gravity) * tickinterval
            )

            local trace = utils.trace_line(
                prev_origin,
                p_origin,
                nil,
                2
            )

            if trace.fraction <= 0.99 then
                return prev_origin
            end
        end

        return p_origin
    end
end
local tweening
do
    tweening = {}

    local native_GetTimescale = utils.get_vfunc('engine.dll', 'VEngineClient014', 91, 'float(__thiscall*)(void*)')

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

    local mt = {}
    do
        local function update(self, duration, target, easings_fn)
            local value_type = type(self.value)
            local target_type = type(target)

            if target_type == 'boolean' then
                target = target and 1 or 0
                target_type = 'number'
            end

            assert(value_type == target_type,
                string.format('type mismatch, expected %s (received %s)', value_type, target_type))

            if target ~= self.to then
                self.clock = 0

                self.from = self.value
                self.to = target
            end

            local clock = globals.frametime / native_GetTimescale()
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

        local this = {}

        this.clock = 0
        this.value = default or 0

        this.easings = easings_fn or function(t, b, c, d)
            return c * t / d + b
        end

        return setmetatable(this, mt)
    end
end
local constants = {}; do
    constants.render = {}; do
        constants.render.screen = render.screen_size()
        constants.render.menu = render.load_image(
            network.get('https://github.com/L3V1Y/night/blob/main/night.png?raw=true', {}), vector(150, 150));
        constants.render.watermark = render.load_image(
            network.get('https://github.com/L3V1Y/night/blob/main/night.png?raw=true', {}), vector(25, 25));
        constants.render.defensive = render.load_image(
            network.get('https://github.com/L3V1Y/night/blob/main/shield.png?raw=true', {}), vector(20, 20));
        constants.render.velocity = render.load_image(
            network.get('https://github.com/L3V1Y/night/blob/main/man.png?raw=true', {}), vector(25, 25));
        constants.render.bomb = render.load_image(
            '\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x64\x00\x00\x00\x5C\x08\x03\x00\x00\x00\xAF\x15\xE0\xA6\x00\x00\x00\x01\x73\x52\x47\x42\x01\xD9\xC9\x2C\x7F\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0B\x13\x00\x00\x0B\x13\x01\x00\x9A\x9C\x18\x00\x00\x02\xDF\x50\x4C\x54\x45\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x76\x99\x69\x74\x00\x00\x00\xF5\x74\x52\x4E\x53\x00\x01\x43\x93\x58\x06\x5A\xFB\xFF\xFD\x96\x04\xD5\xF9\x02\x0E\xE3\x18\x16\xEA\x2B\x1B\xEF\x36\x29\x73\x72\x1E\xF2\x3F\x75\x6B\x20\xEB\xF4\x32\x21\xF6\x47\x2F\xE7\xE2\x37\x5E\xB7\x0F\x23\xF8\x51\x08\xB3\x9A\x7D\xF7\x63\x00\x70\x7A\xC1\x25\x6E\x2D\xE0\x62\xFC\xC2\x28\x76\xAE\x88\x0B\xC9\x5D\x7E\xFA\xE9\x27\x5C\xDF\x12\x31\x84\xD8\x8C\xCF\x97\x3A\x8A\x03\xAC\xDA\x1C\x6C\x2E\x42\x8F\x7B\xA1\x4B\x95\x10\xCA\x13\x55\x3D\x1A\x33\x0A\x4E\x69\x82\xBB\x41\xC7\x80\x87\x91\x9E\xA6\xAA\x86\x7F\x5F\x26\xDC\xFE\x49\xE8\x17\xC3\x46\x89\x92\xBA\x2C\xC0\xB8\xA3\x9F\xA8\xAF\xB1\xB5\xBC\xD4\x7C\xF3\x9D\x24\x0D\x8E\x5B\x05\xD9\xD1\x99\xF1\xCC\xCB\x9B\x4F\x14\xCE\xC5\xCD\x19\x30\xF5\x07\xDE\x15\xA4\x1D\x11\xE5\x83\x2A\xA0\x71\xD6\xD0\xC6\xB9\xA9\x6D\x52\x35\xDD\x0C\xE4\x64\xED\xBF\xC4\x8D\x77\x85\x8B\x90\xEE\xE6\xA5\x78\xEC\x09\x60\x1F\x81\xAB\x9C\x98\x38\x61\x4A\xB2\x34\x4C\xDB\xA7\xD2\x45\x39\x53\xB0\xF0\xBD\x94\x4D\xB4\x44\x54\x3E\xA2\x22\x59\x6A\xE1\xD7\xAD\x40\x48\x3B\xBE\x65\x74\x34\x72\x01\xD4\x00\x00\x07\x6E\x49\x44\x41\x54\x78\x9C\xED\x9A\xF9\x5B\xD4\x46\x18\xC7\xB3\x22\x32\x2B\x8B\x8A\x58\xD0\x42\xE5\x10\x54\x28\x42\x11\x70\x11\x11\x10\x95\x22\x28\x56\x2C\x88\x14\x05\xE4\xB4\x1C\xC5\x20\x60\x45\xBC\x51\x01\xA1\x88\x88\xA2\xA2\x78\x71\x15\x15\x0B\x88\x78\x0B\x15\x54\x14\xCF\x0A\x78\xB6\xB5\xD5\x5A\xDB\xDA\xEB\x0F\x68\x66\x26\xBB\x9B\x84\xDD\x25\x86\xA5\xCF\xD3\x3E\xBE\xBF\x64\xE7\x9B\xF7\x7D\x3F\x39\x66\x92\x77\x26\x4B\x10\x02\x4C\x34\x40\x6B\xA0\xB6\x90\xC0\x37\xB1\x41\x3A\x40\x3C\xB8\x9F\x19\xBA\x12\x00\x80\xDE\x90\xFE\x85\x0C\x1D\x46\x41\x80\x7E\xFF\x42\x86\x1B\x40\xC8\x88\xFE\x85\xBC\x63\x08\x21\x46\x9A\x4B\x38\x72\xD4\xBB\x3D\x0E\xD9\xD8\x04\x42\xDE\xE3\xA8\xA2\x91\xA3\x4D\xCD\x04\x31\xF4\xCD\x01\xB0\x18\xC3\x11\x2D\xAD\x20\x64\x2C\x47\x1D\x37\x1E\x00\x6B\x1B\x21\x90\xF7\x61\x3A\xDB\x09\x6C\xD1\xCE\x1E\xAA\x1F\xB0\x45\x87\x89\x50\x74\x14\x02\xB1\x13\xC3\x50\x27\x8E\xE8\x0C\xC5\x49\x2C\x4D\xEA\xA2\x03\xC5\xC9\x42\x20\x84\x2B\x0C\x15\xB3\x6F\xCB\x14\x3D\x28\xBA\xB1\xB4\xA9\xE3\xA1\xE6\x6E\x26\x08\xE2\xE1\x09\x83\xA7\x39\x30\x35\x2F\xA4\x4D\x67\x4A\xBA\x33\xA0\x04\x66\x0A\x62\x10\xDE\x1F\xA2\x68\x1F\xA6\x36\x02\x49\xB3\x18\x8A\xD4\xC3\x17\x4A\x7E\xB3\x85\x41\x88\x39\x28\xA3\xFF\x5C\x86\xF4\x11\x92\xE6\x31\x14\xCB\x00\x24\xCD\x17\xFC\xA8\xF9\x18\xC5\x07\x32\xE2\x83\x90\xB2\x40\x21\x04\x2F\x44\x4A\xC8\x27\x42\x19\x44\x28\xBA\x03\x16\x8B\x14\xCA\x62\x94\x32\x4C\x21\x8C\x45\x02\x08\x17\xCC\x90\xDD\x95\x08\x85\xB2\x04\x09\x91\xF2\x76\x14\xF6\x88\x8E\x11\x0E\x21\xC6\xC4\x42\x8B\x53\x08\x4B\x91\xF0\xA9\xBC\x1D\x9F\x90\xE8\x96\xE4\xF8\x59\x72\x1F\x18\x6F\xED\x7F\x63\x52\xE3\x50\xDB\x65\x83\x44\xB2\x66\x82\xA9\x9B\x13\x49\x92\x29\xCB\x23\xB1\x05\xA6\xA6\xA5\xF3\xB4\x88\x40\x18\xA0\xB5\xE2\x73\x97\x95\x19\x6C\x86\xFE\x74\x77\xAA\x57\xDB\x7B\xE1\x96\x03\x69\x0F\x34\x61\xAB\x18\x7D\x7C\xC8\x94\xF9\xAB\x32\x91\xBA\x1A\x0B\x6E\x62\x8D\x30\xA8\x27\xB5\xB7\x8C\x61\xB6\x60\x0D\xAD\x19\xAC\xC5\xCA\x3A\x0D\x31\x80\xF3\x7A\x9C\xD0\x7B\x83\xBF\x4C\xB2\x5A\x42\x63\xFD\xD5\x05\xBE\x91\x85\xA2\x7C\x1B\xCD\xE5\x42\xD6\x26\xD9\xB9\x19\xF0\xCB\x10\xB0\x79\x4B\x76\x8E\xC2\x22\xB2\xD3\x72\xD3\x17\x6E\xCD\x9B\x98\xBF\x25\xEB\x8B\x02\xEC\xB2\x0D\xE5\x93\x47\x78\x92\x51\xF2\x9B\x54\xC8\x07\x61\xA1\xF6\x6D\x14\x8B\x9D\x52\x98\x10\xCF\xED\x45\x0C\x0F\x5E\x7D\xCB\x7A\x07\x0F\x48\x31\x03\xE2\xB7\x73\x17\xD3\x83\x57\xE7\x2A\xD9\xA5\x34\x3B\x1B\xA2\x25\x87\x18\x6A\x71\x0A\x65\x3E\x0C\x20\x11\x29\xC9\xCD\x85\x04\xA2\x06\xF5\x8A\xCB\x32\xD2\xE5\x78\xF0\x82\xEC\x56\xC7\x90\x41\xF6\xA0\xC6\xDE\xD2\xD5\x5C\x04\x4F\xC8\x3E\x3E\x90\xFD\xA8\x51\x76\x40\x89\x07\x2F\xC8\x41\x3E\x90\xED\xAA\x3D\x78\x41\x0E\xF1\x81\xA4\xF6\x11\x12\x0D\x3D\x63\xE2\x0E\x1F\x11\x89\xCA\x2B\x66\x0E\x25\x2A\xC3\x4B\x8D\xE3\x35\x0D\x29\x80\x9E\xB9\x85\x3A\x55\xD5\xC3\xFD\x80\xD5\x72\x62\x52\xA6\x78\x8D\x62\x42\x41\x43\x72\xFA\x08\x91\x48\x29\xCF\x2F\x01\x30\xA9\x39\x7A\x0C\x96\x75\xC7\xA9\x9F\xB5\x5C\xC8\x89\xBE\x42\xE0\x38\xB1\xFC\x2A\x2B\xD6\x41\x64\x63\x10\xB8\x96\x98\xBD\xA0\xC4\x67\x82\xA6\x21\x75\x6A\x8B\x5C\x0D\x41\x02\x82\xFF\x05\x48\x88\xDA\x45\x0E\x1A\x82\x0B\xD9\xF1\xC3\xAA\x4A\x0A\xEA\xF7\x35\xB8\x9E\x9C\x91\xDE\xB8\x67\xDE\xA9\xA6\xD3\x4B\x45\xFC\x20\x67\x1C\x78\x40\xB2\x55\x1C\xB4\xA1\x1B\x3F\x88\xFB\x59\x1E\x90\x34\x55\x57\x66\x95\x4A\x88\x39\xAA\x79\xF6\xE2\xC6\xB9\x28\x1E\x90\x74\x55\x10\x13\x55\x90\xCC\xF3\x28\x44\x82\x5B\x17\xD4\x2E\xA4\xF4\x06\x89\x56\x05\xB9\x38\x81\x09\x11\x5F\xCA\x6B\x6E\x19\xCD\xB0\x96\xC9\xDB\x66\x91\x49\x5F\xA7\x6C\xB8\xDC\xDC\xBA\xD1\x96\x03\x11\x5B\xB4\x5D\x71\x2F\x91\x48\x0E\xBB\xE6\x5F\x6D\xBD\x66\xDA\x14\xA3\x02\xD2\x6E\x44\x5C\x2F\x52\x40\x78\x59\x23\x82\x1C\xF5\x56\xD2\xDD\x95\x07\xB4\x4A\x45\xE1\x37\x04\x41\x94\x9A\xCC\xC5\x6A\xF3\xAC\xB8\x8E\xCA\xA8\x51\xA8\x51\x65\x46\x94\x5F\x18\xCB\x80\x18\xEE\x27\x6F\xE6\x9A\x50\xDD\xAC\x99\x24\xB3\x9D\xA9\x6E\xB1\x35\x29\xE9\x96\x0E\x35\x4A\xC3\x48\xF2\xB6\x2F\x5F\x48\xBD\x11\x7E\x8D\xD7\xC0\x86\xAF\x87\x94\xB8\x03\xEE\x32\x20\xF7\xE0\x3E\x12\x80\x32\xB8\x0D\x03\x7A\x41\xD4\x46\xBA\x05\xB4\x75\xC0\xF6\x49\xEC\x93\xDB\x1B\xA4\x74\x28\x6E\x49\xBF\x81\xAD\xFB\xC1\x44\x67\x3B\x58\xC4\x80\xA0\xC5\xAD\x2E\x00\x3A\xF1\xD6\x1F\xD5\xBD\x81\xA0\x1B\x3D\x09\x22\xB1\xCF\x83\x5E\x20\x7A\xB0\xA0\xDC\x71\xF9\xA1\x44\xD2\x4E\xB5\x2A\x3A\x08\xDD\x13\x78\x69\x4E\x06\x81\x67\x45\x3C\x02\x00\x4D\x3E\x1F\xD3\xD5\xCB\x6D\xB0\xAA\x12\x6E\xB5\xF8\x41\xF2\xA8\x1F\xDA\xF7\xE9\x84\x99\xCD\x54\x1E\x67\x36\xE4\x11\x74\x6D\x02\xE0\x09\xDC\x2E\xA1\xEB\xB0\x5B\x74\xD1\x97\x8D\x7D\xD2\x7A\x81\xC0\x4B\x7E\x4F\xD6\x05\xFC\x6B\x08\x22\x15\xB0\x21\xA7\x6A\x29\x73\x02\x20\xDC\x4C\xBF\xBA\xA6\x11\x54\x94\x0D\xAF\x5E\x5A\x74\x08\x98\x07\x41\x9D\x9E\x18\x5C\xED\x05\x72\x9A\xBA\x1B\x0D\x32\xC8\x64\x6A\x86\xE1\x2A\x91\x48\xEC\xA8\xBD\x79\x12\x13\x15\x1D\xB6\xA7\xE1\x07\xE4\x01\x65\x6F\x05\xB4\x7F\x1C\x35\x3B\xAA\xA3\x7D\xCD\xD9\xCF\xA9\xC1\xBC\x21\xF8\x51\xDF\xB0\xDC\x58\x05\x04\xCE\x5F\x02\x69\xDF\xA7\xEC\xFD\x37\x91\xA8\x53\x25\x09\xF8\x96\xDA\x7A\x76\x4B\x4A\x2C\xA0\x60\x20\xA9\x6B\xA3\x36\xCE\x25\x92\xEE\x0A\x3A\x10\xD7\x5D\x56\xA0\xDD\xAD\x47\x79\x8E\xF6\xC3\x05\xB2\x8C\x76\xEC\xDB\x10\x4B\x1B\xEC\xD5\x46\xB1\xDF\x21\xB1\x39\x46\x5A\x69\x33\x0D\x00\xC7\xB3\xC4\xF5\xE4\x6E\x00\xBE\xAF\x15\xE9\x06\xED\x05\xBE\xE7\xE3\x89\x1D\xCF\xDA\x70\x20\x5E\x7F\x84\x87\xF0\xC3\x5D\x65\x90\x68\xD8\x25\xCB\x1F\x5A\xB1\x4E\x1F\xDE\xF8\x83\xF4\x6F\x38\xF8\x88\xD5\x00\xA0\x3A\x28\x14\xF8\xA1\x5A\x74\x06\xB0\x46\xC3\x2B\x15\xFB\xE0\x15\x1D\x3C\xA9\x0A\xEB\xE8\x09\x11\xFF\x08\x7F\xCE\x1D\xF0\x3C\x36\x96\x05\x91\xCA\x7A\xD7\x63\xB8\x3F\x19\x80\xA9\x70\xFB\x02\x04\xA0\x9A\x7A\x3F\x3D\x4E\xE8\xDB\x86\xD7\xA6\x86\xE1\x46\x48\x53\x30\x17\x02\xCE\x58\xD2\x4D\x11\xFB\x4C\x64\x90\xC5\x70\x5F\x17\x3D\x5E\x64\x83\x31\x82\x1E\xF9\x3F\x61\x9F\x15\x28\x41\xB7\x2C\x3C\xFD\xA5\x94\x03\x01\x75\x03\xF1\x1B\xD6\x4C\x39\xA4\x0B\xEE\xF3\x01\xE0\x67\xB8\x7D\x05\xAE\xA0\xD5\xC2\x3C\x70\x0C\xF5\x44\x7A\x14\x87\xA3\x04\x97\xE5\xF3\xC3\xAA\x04\x2E\x04\x00\xFB\x89\xC5\x24\x19\xF6\x0B\x50\x6A\x05\x17\x29\x2B\x01\xE0\xD7\xAD\xD9\x39\xE9\xD4\xAD\x0B\x89\xC8\x79\x90\x6F\x08\x7C\x2F\x41\xDD\x10\xFB\xBC\xC2\x09\x2D\x9F\xCA\xBA\x1B\x28\x9E\xCB\x85\xF4\xD5\x3C\x9F\xD0\x19\x77\x25\x94\x66\xD2\x5A\x3E\x3D\x0D\xB4\xD6\x14\x64\x8D\x97\xFC\xEA\x54\x27\xD6\xD1\x53\x51\x7A\x79\xEF\x74\xB7\xFA\x58\xDE\xD6\xC8\x2C\x65\x8F\x5C\xC3\x07\x2F\xFB\x40\x30\xD5\xBD\x4F\xB9\xC5\x15\x15\x15\x85\x06\x7E\x55\xBF\xD9\xB1\x46\x06\x61\xD6\xB2\xCF\xB0\x30\x57\x3E\x6B\x1E\x11\xDB\x17\x6B\x4A\x7E\xFD\xFA\xC5\xA6\x91\x4A\x66\x8A\xDA\x9D\x71\xF1\x3D\xD5\xB7\xF6\x5F\x31\x6F\x17\x92\x24\x9D\x7C\x18\x8B\xFD\x2F\x49\x68\xBF\x2B\x84\x3F\xA0\x0B\x39\x5D\x6D\x55\xAE\xDE\x12\xD1\x77\x24\xF1\x33\x85\xF2\x02\xF5\xDD\xF9\x0A\xE1\x39\xEE\xCD\xA6\xC2\x21\xA5\x28\xC1\x6E\x6F\x85\x62\x83\x94\x14\x85\xA0\xBD\x0C\x29\xD1\x6A\x67\x31\xEA\x6C\x10\x8A\xF7\x65\x7E\xBA\x2C\x47\x52\x12\x43\xE9\x44\xAF\x2A\x4F\x37\x6E\x30\x4F\xBB\x8E\x0F\xD2\x91\xB9\x16\xD5\xF3\x73\xD3\x90\xE3\x48\xAA\x57\xB6\x78\xC3\xC3\x6E\xA0\x3B\x72\xC1\x92\xA9\x79\xA1\xA7\x5F\x0B\x53\x8A\xA9\x47\x14\x0F\x61\x90\x3F\x51\xF0\x24\x29\x53\xCB\x40\x65\xBC\x0B\xCB\xEF\x39\x02\xAF\x13\xF4\x57\x80\xB5\xE8\x44\x6C\xD9\x6B\x05\x45\x68\xDD\x32\x91\xA5\x69\x47\x40\xCD\xBE\x4B\x08\x64\x25\x0C\x3D\x57\xCB\x16\xF1\xB7\x5F\xCE\xA5\xE9\x40\xAF\x8C\x40\x21\x90\x32\x18\x39\x87\x23\x76\xA0\xF2\x6E\x27\x47\xFD\x8B\xBA\x60\x3A\xA1\x42\x20\xBA\x91\x56\x86\x4E\xDC\x85\x95\x1A\x34\xF1\xE6\x7C\x60\x26\x1C\xFE\x0E\x28\xBD\xA7\xB9\xBF\x67\x1C\x41\x25\xE3\x7A\x8D\xE5\x53\x6A\xD5\x7E\x10\xA2\xC1\x7F\x16\x28\x33\xFC\x47\x0C\xCB\xDE\x1D\xFB\x62\xBA\x70\x96\xE1\xAB\x76\xD1\x5B\x03\x56\x4C\x41\xA6\xF5\x33\x83\x88\x69\x4D\xBF\x93\xD1\xBB\x9B\xDC\xFE\x01\x51\x90\x30\x2B\x44\x5E\xBA\x6C\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82',
            vector(32, 24));
        constants.render.gamesense = render.load_font('Calibri Bold', vector(23, 23.5, 0), 'da')
        constants.render.arrows = render.load_font('Calibri Bold', vector(23, 23.5, 0), 'a')
        constants.render.x, constants.render.y = 28, constants.render.screen.y - 350;
        constants.render.shot = 0; constants.render.hit = 0; constants.render.planting = false; constants.render.abort_defuse = false; constants.render.defused = false; constants.render.planting_site =
        ''; constants.render.fill = 0; constants.render.plant_time = 0;
        constants.render.render_indicator = function(text, col, dst, img)
            local ts = render.measure_text(constants.render.gamesense, nil, text)
            if img then
                render.gradient(vector(5, constants.render.y + 3 - dst),
                    vector(constants.render.x + ((img.width) + (ts.x)) / 2 + 3, constants.render.y + 37 - dst),
                    color(0, 0), color(0, 50), color(0, 0), color(0, 50))
                render.gradient(
                    vector(constants.render.x + ((img.width) + (ts.x)) / 2 + 3, constants.render.y + 3 - dst),
                    vector(constants.render.x + (ts.x) + (img.width) + 34, constants.render.y + 37 - dst), color(0, 50),
                    color(0, 0), color(0, 50), color(0, 0))
                render.texture(img, vector(constants.render.x, constants.render.y + 7 - dst), col)
                render.text(constants.render.gamesense,
                    vector(constants.render.x + (img.width) + 6, constants.render.y + 9 - dst), col, 'd', text)
            else
                render.gradient(vector(5, constants.render.y + 3 - dst),
                    vector(constants.render.x + (ts.x) / 2, constants.render.y + 37 - dst), color(0, 0), color(0, 50),
                    color(0, 0), color(0, 50))
                render.gradient(vector(constants.render.x + (ts.x) / 2, constants.render.y + 3 - dst),
                    vector(constants.render.x + (ts.x) + 28, constants.render.y + 37 - dst), color(0, 50), color(0, 0),
                    color(0, 50), color(0, 0))
                render.text(constants.render.gamesense, vector(constants.render.x, constants.render.y + 9 - dst), col,
                    'd', text)
            end
        end
        constants.damage_apply_armor = function(damage, armor_value)
            local armor_ratio = 0.5
            local armor_bonus = 0.5

            if armor_value > 0 then
                local flNew = damage * armor_ratio
                local flArmor = (damage - flNew) * armor_bonus

                if flArmor > armor_value then
                    flArmor = armor_value * (1 / armor_bonus)
                    flNew = damage - flArmor
                end

                damage = flNew
            end

            return damage
        end;
        constants.calculate_damage = function(from_player, other, armor_value)
            local eye_position = from_player:get_eye_position()
            local distance = eye_position:dist(other:get_origin())

            local damage = 500
            local radius = damage * 3.5

            damage = damage * math.exp(-((distance * distance) / ((radius * 2 / 3) * (radius / 3))))
            damage = math.floor(constants.damage_apply_armor(math.max(damage, 0), armor_value))

            return damage
        end;
        constants.shot = 0;
        constants.hit = 0;
        constants.aim_ack = function(shot)
            if shot.damage ~= nil then
                constants.render.hit = constants.render.hit + 1
            end
            constants.render.shot = constants.render.shot + 1
        end;
        constants.reset = function()
            constants.abort_defuse = false
            constants.defused = false
            constants.planting = false
            constants.planting_site = ''
            constants.fill = 0
            constants.plant_time = 0
        end

        constants.e_abort_defuse = function()
            constants.abort_defuse = true
            constants.defused = false
            constants.planting = false
            constants.planting_site = ''
            constants.fill = 0
            constants.plant_time = 0
        end

        constants.e_defused = function()
            constants.abort_defuse = false
            constants.defused = true
            constants.planting = false
            constants.planting_site = ''
            constants.fill = 0
            constants.plant_time = 0
        end

        -- Затяни петлю на шее да я не пойду домой

        constants.begin_plant = function(e)
            constants.abort_defuse = false
            constants.defused = false
            constants.planting = true

            local player_resource = entity.get_player_resource()

            if not player_resource then
                return
            end

            local center_a, center_b =
                player_resource.m_bombsiteCenterA,
                player_resource.m_bombsiteCenterB

            local site = entity.get(e.site)

            if not site then
                return
            end

            local mins, maxs =
                site.m_vecMins, site.m_vecMaxs

            local center = mins:lerp(maxs, 0.5)
            local distance_a, distance_b = center:dist(center_a), center:dist(center_b)

            constants.planting_site = distance_b > distance_a and 'A' or 'B'

            constants.plant_time = globals.curtime
        end
        events.aim_ack:set(function(shot)
            constants.aim_ack(shot)
        end)
        events.bomb_beginplant:set(function(e) constants.begin_plant(e) end)
        events.bomb_abortplant:set(function() constants.reset() end)
        events.bomb_planted:set(function() constants.reset() end)
        events.bomb_begindefuse:set(function() constants.reset() end)
        events.bomb_abortdefuse:set(function() constants.e_abort_defuse() end)
        events.bomb_defused:set(function() constants.e_defused() end)
        events.round_start:set(function() constants.e_defused() end)
    end
    constants.state = {}; do
        constants.state.global = { 'global', 'standing', 'running', 'walking', 'crouching', 'crouching-move', 'air',
            'air-crouching' };
    end
end
local animation = {}; do
    animation.data = {}

    function animation:new(key, increasing, speed, modifier, initial_value)
        self.data[key] = self.data[key] or {
            method = 'lerp',
            increasing = increasing,
            speed = speed or 4,
            modifier = modifier or 0,
            value = initial_value or 0
        }

        return self.data[key]
    end

    function animation:spin(key, from, to, speed, iterations, initial_value)
        self.data[key] = self.data[key] or {
            active = 0,
            method = 'spin',
            start = math.min(from, to),
            target = math.max(from, to),
            speed = speed or 4,
            iterations = iterations or 1,
            value = initial_value or from
        }

        local this = self.data[key]

        this.start, this.target = math.min(from, to), math.max(from, to)
        this.speed, this.iterations = speed, iterations

        return this
    end

    function animation:tick(tick)
        for key, state in pairs(self.data) do
            if state.method == 'spin' then
                local difference = tick - state.active

                if difference > state.speed or math.abs(difference) > 64 then
                    for i = 1, state.iterations do
                        if state.value < state.target then
                            state.value = state.value + 1
                        else
                            state.value = state.start
                        end
                    end

                    state.active = tick
                end
            end
        end
    end
end
local menu = {}; do
    menu.refs = {}; do
        menu.refs.pitch = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Pitch');
        menu.refs.yawbase = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Base');
        menu.refs.yaw = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw');
        menu.refs.base = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Base');
        menu.refs.yawoffset = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Offset');
        menu.refs.avoidbackstab = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Avoid Backstab');
        menu.refs.hidden = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Hidden');
        menu.refs.yawmodifier = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw Modifier');
        menu.refs.yawmodifieroffset = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw Modifier', 'Offset');
        menu.refs.bodyyaw = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw');
        menu.refs.bodyyaw_invert = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Inverter');
        menu.refs.bodyyaw_leftlimit = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Left Limit');
        menu.refs.bodyyaw_rightlimit = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Right Limit');
        menu.refs.bodyyaw_options = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Options');
        menu.refs.bodyyaw_freestanding = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Freestanding');
        menu.refs.freestanding = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Freestanding');
        menu.refs.antiuntrusted = pui.find('Miscellaneous', 'Main', 'Other', 'Anti Untrusted');
        menu.refs.lagoptions = pui.find('Aimbot', 'Ragebot', 'Main', 'Double Tap', 'Lag Options');
        menu.refs.hideshotsoptions = pui.find('Aimbot', 'Ragebot', 'Main', 'Hide Shots', 'Options');
        menu.refs.doubletap = pui.find('Aimbot', 'Ragebot', 'Main', 'Double Tap');
        menu.refs.hideshots = pui.find('Aimbot', 'Ragebot', 'Main', 'Hide Shots');
        menu.refs.immediateteleport = pui.find('Aimbot', 'Ragebot', 'Main', 'Double Tap', 'Immediate Teleport');
        menu.refs.fakeduck = pui.find('Aimbot', 'Anti Aim', 'Misc', 'Fake Duck');
        menu.refs.mindamage = pui.find('Aimbot', 'Ragebot', 'Selection', 'Min. Damage');
        menu.refs.fakeping = pui.find('Miscellaneous', 'Main', 'Other', 'Fake Latency');
        menu.refs.dormant = pui.find('Aimbot', 'Ragebot', 'Main', 'Enabled', 'Dormant Aimbot');
        menu.refs.safepoint = pui.find('Aimbot', 'Ragebot', 'Safety', 'Safe Points');
        menu.refs.bodyaim = pui.find('Aimbot', 'Ragebot', 'Safety', 'Body Aim');
        menu.refs.bodyaim_disablers = pui.find('Aimbot', 'Ragebot', 'Safety', 'Body Aim', 'Disablers');
        menu.refs.force_on_peek = pui.find('Aimbot', 'Ragebot', 'Safety', 'SSG-08', 'Body Aim', 'Force on Peek');
        menu.refs.slowwalk = pui.find('Aimbot', 'Anti Aim', 'Misc', 'Slow Walk');
        menu.refs.fakelag = pui.find('Aimbot', 'Anti Aim', 'Fake Lag', 'Enabled')
        menu.refs.limit = pui.find('Aimbot', 'Anti Aim', 'Fake Lag', 'Limit');
        menu.refs.variability = pui.find('Aimbot', 'Anti Aim', 'Fake Lag', 'Variability');
        menu.refs.leg = pui.find('Aimbot', 'Anti Aim', 'Misc', 'Leg Movement');
        menu.refs.hc = pui.find('Aimbot', 'Ragebot', 'Selection', 'Hit Chance');
        menu.refs.lat = pui.find('Miscellaneous', 'Main', 'Other', 'Fake Latency');
        menu.refs.peek = pui.find('Aimbot', 'Ragebot', 'Main', 'Peek Assist');
        menu.refs.peekstop = pui.find('Aimbot', 'Ragebot', 'Main', 'Peek Assist', 'Auto Stop');
        menu.refs.scope = pui.find('Visuals', 'World', 'Main', 'Override Zoom', 'Scope Overlay')
    end;
    menu.groups = {}; do
        menu.groups.navigation = pui.create('🌐global', 'night.lua');
        menu.groups.global = pui.create('🌐global', 'welcome');
        menu.groups.config = pui.create('🌐global', 'config');
        menu.groups.visuals = pui.create('🌐global', 'visuals');
        menu.groups.other = pui.create('🌐global', 'other');
        menu.groups.antiaim = pui.create('🌀anti-aim', 'anti-aim', 1)
        menu.groups.state = pui.create('🌀anti-aim', 'settings')
        menu.groups.antiaim_other = pui.create('🌀anti-aim', 'other')
        menu.groups.rage = pui.create('🚀additions', 'rage')
        menu.groups.additions = pui.create('🚀additions', 'additions')
    end;
    pui.colors.attention = color('#DADE6B')
    menu.elements = {}; do
        menu.elements.navigation = menu.groups.navigation:list('', { '🌐global', '🎨visuals' })
        menu.elements.global = {}; do
            menu.groups.global:label(string.format(
                '\abdbdbdc8welcome back, \aFFFFFFFF%s!\n\abdbdbdc8current build: \aFFFFFFFF%s\nmade by l3v1y x yuki with love//',
                script.name, script.build))
                :depend({
                    menu.elements.navigation, 1 });
            menu.elements.global.icon = menu.groups.global:texture(constants.render.menu, nil, nil, nil, 6):depend({ menu
                .elements.navigation, 1 });
        end;
        menu.elements.additions = {}; do
            menu.elements.additions.idealtick = menu.groups.rage:switch('night peek assist', false,
                'this is reworked ideal tick\nmay help you in peek baits / tracking people')
            menu.elements.additions.unlock = menu.groups.additions:switch('unlock fake latency', false, function(gear)
                local mytable = {}; do
                    mytable.amount = gear:slider('amount', 0, 200, 0, 1)
                end
                return mytable, true
            end)
            menu.elements.additions.super_toss = menu.groups.additions:switch('super toss')
            menu.elements.additions.fakelag = menu.groups.additions:switch('fakelag', false, function(gear)
                local mytable = {}; do
                    mytable.mode = gear:combo('mode', { 'cycle', 'randomized' })
                    mytable.limit = gear:slider('limit', 1, 14, 14, 1, 't')
                end
                return mytable, true
            end)
            menu.elements.additions.animation = menu.groups.additions:switch('animation breakers', false, function(gear)
                local mytable = {}; do
                    mytable.ground = gear:combo('ground', { '-', 'static', 'jitter', 'forward walking', 'kangaroo' })
                    mytable.air = gear:combo('air', { '-', 'static', 'jitter', 'walking', 'kangaroo' })
                    mytable.lean = gear:slider('lean amount', 0, 100, 75, 1, '%')
                    mytable.pitch = gear:switch('zero pitch on land')
                end
                return mytable, true
            end)
            menu.elements.additions.tag = menu.groups.additions:switch('tag');
            menu.elements.additions.killsay = menu.groups.additions:switch('kill say')
            menu.elements.additions.force_lethal = menu.groups.rage:switch('force bodyaim if lethal')
            menu.elements.additions.hitchance = menu.groups.rage:switch('custom hitchance', false, function(gear)
                local mytable = {}; do
                    mytable.conditions = gear:selectable('hitchance conditions', { 'in-air', 'noscope', 'predict' });
                    mytable.air = gear:slider('in-air', 0, 100, 35, 1, '%'):depend({ mytable.conditions, 'in-air' });
                    mytable.noscope = gear:slider('noscope', 0, 100, 35, 1, '%'):depend({ mytable.conditions, 'noscope' });;
                    mytable.predict = gear:slider('predict', 0, 100, 35, 1, '%'):depend({ mytable.conditions, 'predict' });;
                end
                return mytable, true
            end)
        end
        menu.elements.config = {}; do
            menu.groups.config:label('config system'):depend({ menu.elements.navigation, 1 });
            menu.elements.config.import = menu.groups.config:button('⤵️', function()

            end):depend({ menu.elements.navigation, 1 });
            menu.elements.config.import:tooltip('import config')
            menu.elements.config.export = menu.groups.config:button('⤴️', function()
                clipboard.set(base64.encode(json.stringify(pui.save())))
            end):depend({ menu.elements.navigation, 1 });
            menu.elements.config.export:tooltip('export config')
            menu.elements.config.default = menu.groups.config:button('🔧'):depend({ menu.elements.navigation, 1 });
            menu.elements.config.default:tooltip('default config\nbest for public ig')
            menu.elements.config.agressive = menu.groups.config:button('💀'):depend({ menu.elements.navigation, 1 });
            menu.elements.config.agressive:tooltip('agressive config\nbest for league ig')
            menu.groups.config:label('yuki config'):depend({ menu.elements.navigation, 1 });
            menu.elements.config.yuki_beta = menu.groups.config:button('✨', function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL('https://neverlose.cc/market/item?id=u5425U')
            end, true):depend({ menu.elements.navigation, 1 })
            menu.elements.config.yuki_beta:tooltip('yuki beta')
            menu.groups.config:label('l3v1y config'):depend({ menu.elements.navigation, 1 });
            menu.elements.config.l3v1y = menu.groups.config:button('💫', function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL('https://neverlose.cc/market/item?id=mMMItg')
            end, true):depend({ menu.elements.navigation, 1 })
            menu.elements.config.l3v1y:tooltip('l3v1y main')
        end;
        menu.elements.visuals = {}; do
            menu.elements.visuals.master = menu.groups.visuals:switch('master switch'):depend({ menu.elements.navigation, 2 });
            menu.elements.visuals.accent = menu.groups.other:color_picker('accent color'):depend(
                { menu.elements.visuals.master, true }, { menu.elements.navigation, 2 })
            menu.elements.visuals.watermark = menu.groups.visuals:combo('watermark',
                { 'basic', 'modern', 'gradient' }):depend({ menu.elements.visuals.master, true },
                { menu.elements.navigation, 2 });
            menu.elements.visuals.indicators = menu.groups.visuals:label('under crosshair indicators', function(gear)
                local mytable = {}; do
                    mytable.damage = gear:switch('damage indicator')
                    mytable.enable = gear:switch('enable');
                    mytable.font = gear:combo('font', { 'default', 'pixel' }):depend({ mytable.enable, true })
                    mytable.y_add = gear:slider('y add', -150, 170, 25, 1):depend({ mytable.enable, true })
                    mytable.shadow = gear:switch('glow')
                end
                return mytable
            end):depend({ menu.elements.visuals.master, true }, { menu.elements.navigation, 2 });
            menu.elements.visuals.arrows = menu.groups.visuals:combo('manual arrows',
                { 'off', 'default', 'minimalistic' }):depend({ menu.elements.visuals.master, true },
                { menu.elements.navigation, 2 });
            menu.elements.visuals.logs = menu.groups.visuals:switch('hit logs'):depend(
                { menu.elements.visuals.master, true },
                { menu.elements.navigation, 2 });
            menu.elements.visuals.gamesense = menu.groups.visuals:switch('gamesense indicators', false, function(gear)
                local mytable = {}; do
                    mytable.indicators = gear:selectable('gamesense indicators',
                        { 'double tap', 'on shot anti-aim', 'dormant aimbot', 'hit/miss rate', 'lag Compensation',
                            'fake duck', 'force safepoint', 'force body aim', 'damage override', 'peek assist',
                            'bomb info' })
                end
                return mytable
            end):depend({ menu.elements.visuals.master, true }, { menu.elements.navigation, 2 });
            menu.elements.visuals.defensive = menu.groups.visuals:switch('defensive warning'):depend(
                { menu.elements.visuals.master, true }, { menu.elements.navigation, 2 });
            menu.elements.visuals.velocity = menu.groups.visuals:switch('velocity warning'):depend(
                { menu.elements.visuals.master, true }, { menu.elements.navigation, 2 })
            menu.elements.visuals.aspect = menu.groups.other:switch('aspect ratio', false, function(gear)
                local mytable = {}; do
                    mytable.width = gear:slider('value', 0, 200, cvar.r_aspectratio:float(), 0.01)
                end
                return mytable
            end):depend(
                { menu.elements.visuals.master, true }, { menu.elements.navigation, 2 })
            menu.elements.visuals.viewmodel = menu.groups.other:switch('viewmodel', false, function(gear)
                local mytable = {}; do
                    mytable.x = gear:slider('x', -100, 100, cvar.viewmodel_offset_x:int() * 10, 0.1)
                    mytable.y = gear:slider('y', -100, 100, cvar.viewmodel_offset_y:int() * 10, 0.1)
                    mytable.z = gear:slider('z', -100, 100, cvar.viewmodel_offset_z:int() * 10, 0.1)
                    mytable.fov = gear:slider('fov', 0, 1800, cvar.viewmodel_fov:int() * 10, 0.1)
                end
                return mytable
            end):depend(
                { menu.elements.visuals.master, true }, { menu.elements.navigation, 2 });
            menu.elements.visuals.scope = menu.groups.other:switch('custom scope', false, function(gear)
                local mytable = {}; do
                    mytable.colorpicker = gear:color_picker('color')
                    mytable.offset = gear:slider('offset', 0, 500);
                    mytable.width = gear:slider('width', 0, 500);
                    mytable.removals = gear:selectable('remove', { 'top', 'bottom', 'left', 'right' });
                end
                return mytable, true
            end):depend(
                { menu.elements.visuals.master, true }, { menu.elements.navigation, 2 });
        end
        menu.elements.antiaim = {}; do
            menu.elements.antiaim.master = menu.groups.antiaim:switch('enable')

            menu.elements.antiaim.manuals = menu.groups.antiaim_other:combo('manuals',
                { 'at target', 'left', 'right', 'forward' }, function(gear)
                    local mytable = {}; do
                        mytable.disablers = gear:selectable('disable:', { 'yaw modifiers', 'fake modifiers' })
                        mytable.ebait = gear:switch('e bait')
                    end
                    return mytable
                end):depend({ menu.elements.antiaim.master, true })

            menu.elements.antiaim.freestand = menu.groups.antiaim_other:switch('freestand',
                false, function(gear)
                    local mytable = {}; do
                        mytable.disablers = gear:selectable('disable:',
                            { 'yaw modifiers', 'fake modifiers' });
                        mytable.ebait = gear:switch('e bait')
                    end
                    return mytable
                end):depend({ menu.elements.antiaim.master, true })
            menu.elements.antiaim.flick = menu.groups.antiaim_other:switch('\a[attention]flick exploit'):depend({ menu
                .elements.antiaim.master, true })
            menu.elements.antiaim.airlag = menu.groups.antiaim_other:switch('\a[attention]air lag'):depend({ menu
                .elements.antiaim.master, true })
            menu.elements.antiaim.safehead = menu.groups.antiaim_other:selectable('safe head',
                { 'air-knife', 'air-taser', 'height difference' }, function(gear)
                    local mytable = {}; do
                        mytable.ebait = gear:switch('e bait')
                    end
                    return mytable
                end):depend({ menu
                .elements.antiaim.master, true })
            menu.elements.antiaim.defensive = menu.groups.antiaim_other:switch('defensive additions', false,
                function(gear)
                    return {
                        condition = gear:selectable('on condition', { 'peek', 'velocity break' })
                    }, true
                end):depend({ menu.elements
                .antiaim.master, true })
            menu.elements.antiaim.state = menu.groups.state:combo('', constants.state.global):depend({ menu.elements
                .antiaim.master, true })
            menu.elements.antiaim.type = menu.groups.state:list('', { 'basic', 'defensive' }):depend({ menu.elements
                .antiaim.master, true })
        end;

        menu.elements.builder = { base = {}, tab = {}, def_tab = {}, defensive = {} }; do
            for i, name in ipairs(constants.state.global) do
                menu.elements.builder.tab[name] = {};
                menu.elements.builder.def_tab[name] = {};
                menu.elements.builder.base[name] = {};
                menu.elements.builder.defensive[name] = {};
                local ctx, tab, defensive, def_tab = menu.elements.builder.base[name], menu.elements.builder.tab[name],
                    menu.elements.builder.defensive[name], menu.elements.builder.def_tab[name]
                tab.tab = pui.create('🌀anti-aim', name)
                def_tab.tab = pui.create('🌀anti-aim', '\a[attention]defensive\aDEFAULT ' .. name)
                if i > 1 then
                    ctx.enable = menu.groups.state:switch('enable ' .. name):depend(
                        { menu.elements.antiaim.state, name },
                        { menu.elements.antiaim.master, true }, { menu.elements.antiaim.type, 1 });
                end
                ctx.yaw = tab.tab:label('yaw', function(gear)
                    local mytable = {}; do
                        mytable.mode = gear:combo('mode', { 'static', 'sided', 'x-way' });
                        mytable.static = gear:slider('static', -180, 180, 0, 1):depend({ mytable.mode, 'static' });
                        mytable.left = gear:slider('left', -180, 180, 0, 1):depend({ mytable.mode, 'sided' });
                        mytable.right = gear:slider('right', -180, 180, 0, 1):depend({ mytable.mode, 'sided' });
                        mytable.way = gear:slider('way', 3, 7, 3, 1):depend({ mytable.mode, 'x-way' });
                        mytable.way1 = gear:slider('way 1', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 3
                            end });
                        mytable.way2 = gear:slider('way 2', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 3
                            end });
                        mytable.way3 = gear:slider('way 3', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 3
                            end });
                        mytable.way4 = gear:slider('way 4', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 4
                            end });
                        mytable.way5 = gear:slider('way 5', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 5
                            end });
                        mytable.way6 = gear:slider('way 6', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 6
                            end });
                        mytable.way8 = gear:slider('way 7', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 7
                            end });
                    end
                    return mytable
                end):depend({ menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 1 }, i > 1 and ctx.enable);
                ctx.modifier = tab.tab:combo('yaw modifier', { 'off', 'center', 'offset' }, function(gear, self)
                    local mytable = {}; do
                        mytable.offset = gear:slider('offset', -180, 180, 0, 1);
                        mytable.randomization = gear:slider('randomization', 0, 180, 0, 1);
                    end
                    return mytable
                end):depend({ menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 1 }, i > 1 and ctx.enable);
                ctx.spin = tab.tab:switch('spin', false, function(gear)
                    local mytable = {}; do
                        mytable.range = gear:slider('range', -180, 180, 0, 1)
                        mytable.speed = gear:slider('speed', 0, 360, 0, 1)
                    end
                    return mytable, true
                end):depend({ menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 1 }, i > 1 and ctx.enable)
                ctx.fake = tab.tab:switch('body yaw', false, function(gear)
                    local mytable = {}; do
                        mytable.mode = gear:combo('mode', { 'static', 'jitter', 'automatic' });
                        mytable.inverter = gear:switch('inverter'):depend({ mytable.mode, 'static' });
                        mytable.left = gear:slider('left limit', 0, 60, 60, 1):depend({ mytable.mode, function()
                            return mytable.mode.value ~= 'automatic'
                        end });
                        mytable.right = gear:slider('right limit', 0, 60, 60, 1):depend({ mytable.mode, function()
                            return mytable.mode.value ~= 'automatic'
                        end });
                    end
                    return mytable, true
                end):depend({ menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 1 }, i > 1 and ctx.enable);
                ctx.delay = tab.tab:slider('delay', 1, 9, 1, nil, function(e)
                    if e == 1 then return 'off' end
                    return e - 1 .. 't'
                end):depend({ menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 1 }, i > 1 and ctx.enable);
                ctx.randomize_delay = tab.tab:switch('randomize delay'):depend({ menu.elements.antiaim.state, name },
                    { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 1 }, i > 1 and ctx.enable);
                defensive.enable = menu.groups.state:switch('\a[attention]enable\aDEFAULT ' .. name .. '\0'):depend(
                    { menu.elements.antiaim.state, name },
                    { menu.elements.antiaim.master, true }, { menu.elements.antiaim.type, 2 });
                defensive.force = def_tab.tab:selectable('force on', { 'doubletap', 'hideshots' }):depend(
                    { menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 2 });
                defensive.mode = def_tab.tab:combo('mode', { 'default', 'safe' }):depend(
                    { menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 2 }, defensive.enable);
                defensive.pitch = def_tab.tab:label('pitch', function(gear)
                    local mytable = {}; do
                        mytable.mode = gear:combo('mode', { 'custom', 'jitter', 'randomized', 'spinable' });
                        mytable.custom = gear:slider('custom', -89, 89, 0, 1):depend({ mytable.mode, 'custom' })
                        mytable.from = gear:slider('from', -89, 89, 0, 1):depend({ mytable.mode, function()
                            return mytable.mode.value ~= 'custom'
                        end });
                        mytable.to = gear:slider('to', -89, 89, 0, 1):depend({ mytable.mode, function()
                            return mytable.mode.value ~= 'custom'
                        end });
                        mytable.speed = gear:slider('speed', 0, 360, 0, 1):depend({ mytable.mode, 'spinable' })
                    end
                    return mytable
                end):depend({ menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 2 }, defensive.enable);
                defensive.yaw = def_tab.tab:label('yaw', function(gear)
                    local mytable = {}; do
                        mytable.mode = gear:combo('mode', { 'static', 'sided', 'x-way' });
                        mytable.static = gear:slider('static', -180, 180, 0, 1):depend({ mytable.mode, 'static' });
                        mytable.left = gear:slider('left', -180, 180, 0, 1):depend({ mytable.mode, 'sided' });
                        mytable.right = gear:slider('right', -180, 180, 0, 1):depend({ mytable.mode, 'sided' });
                        mytable.way = gear:slider('way', 3, 7, 3, 1):depend({ mytable.mode, 'x-way' });
                        mytable.way1 = gear:slider('way 1', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 3
                            end });
                        mytable.way2 = gear:slider('way 2', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 3
                            end });
                        mytable.way3 = gear:slider('way 3', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 3
                            end });
                        mytable.way4 = gear:slider('way 4', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 4
                            end });
                        mytable.way5 = gear:slider('way 5', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 5
                            end });
                        mytable.way6 = gear:slider('way 6', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 6
                            end });
                        mytable.way8 = gear:slider('way 7', -180, 180, 0, 1):depend({ mytable.mode, 'x-way' },
                            { mytable.way, function()
                                return mytable.way.value >= 7
                            end });
                    end
                    return mytable
                end):depend({ menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 2 }, defensive.enable);
                defensive.modifier = def_tab.tab:combo('yaw modifier', { 'off', 'center', 'offset' },
                    function(gear, self)
                        local mytable = {}; do
                            mytable.offset = gear:slider('offset', -180, 180, 0, 1);
                            mytable.randomization = gear:slider('randomization', 0, 180, 0, 1);
                        end
                        return mytable
                    end):depend({ menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 2 }, defensive.enable);
                defensive.spin = def_tab.tab:switch('spin', false, function(gear)
                    local mytable = {}; do
                        mytable.range = gear:slider('range', -180, 180, 0, 1)
                        mytable.speed = gear:slider('speed', 0, 360, 0, 1)
                    end
                    return mytable, true
                end):depend({ menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 2 }, defensive.enable)
                defensive.fake = def_tab.tab:switch('body yaw', false, function(gear)
                    local mytable = {}; do
                        mytable.mode = gear:combo('mode', { 'static', 'jitter', 'automatic' });
                        mytable.inverter = gear:switch('inverter'):depend({ mytable.mode, 'static' });
                        mytable.left = gear:slider('left limit', 0, 60, 60, 1):depend({ mytable.mode, function()
                            return mytable.mode.value ~= 'automatic'
                        end });
                        mytable.right = gear:slider('right limit', 0, 60, 60, 1):depend({ mytable.mode, function()
                            return mytable.mode.value ~= 'automatic'
                        end });
                    end
                    return mytable, true
                end):depend({ menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 2 }, defensive.enable);
                defensive.delay = def_tab.tab:slider('delay', 1, 9, 1, nil, function(e)
                    if e == 1 then return 'off' end
                    return e - 1 .. 't'
                end):depend({ menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 2 }, defensive.enable);
                defensive.randomize_delay = def_tab.tab:switch('randomize delay'):depend(
                    { menu.elements.antiaim.state, name }, { menu.elements.antiaim.master, true },
                    { menu.elements.antiaim.type, 2 }, defensive.enable);
            end
        end
    end;
    menu.elements.config.export:set_callback(function(fn)
        local config = pui.save()
        local encrypted = base64.encode(json.stringify(config))
        clipboard.set(encrypted)
        print_raw('\nconfig exported!')
    end)
    menu.elements.config.import:set_callback(function(fn)
        pui.load(json.parse(base64.decode(clipboard.get())))
        print_raw('\nconfig exported!')
    end)

    menu.elements.config.agressive:set_callback(function(fn)
        local config = network.get('https://raw.githubusercontent.com/L3V1Y/night/refs/heads/main/nl_agressive', {})
        pui.load(json.parse(base64.decode(config)))
        print_raw('\nagressive config loaded!')
    end)
    menu.elements.config.default:set_callback(function (fn)
        local config = network.get('https://raw.githubusercontent.com/L3V1Y/night/refs/heads/main/nl_default', {})
        pui.load(json.parse(base64.decode(config)))
            print_raw('\ndefault config loaded!')
    end)
    events.render:set(function()
        local link, bar = ui.get_style('Link Active'), ui.get_style('Sidebar Text');
        local text = helpers.gradient('night.project', globals.realtime, bar, link);
        ui.sidebar(string.format('%s\a%s %s', text, link:to_hex(), script.build), ui.get_icon('moon-stars'));
        menu.elements.global.icon:set(link)
    end);
end;
pui.setup(menu)
local antiaim = {}; do
    antiaim.normalize = function(a)
        while a > 180 do
            a = a - 360
        end

        while a < -180 do
            a = a + 360
        end

        return a
    end
    antiaim.in_air = false;
    antiaim.ticks = 0;
    antiaim.max_tickbase = 0;
    antiaim.choking = false;
    antiaim.packets = 0;
    antiaim.last_flick = 0;
    antiaim.exploit = 1;
    events.createmove:set(function(cmd)
        local me = entity.get_local_player()
        if not me then return end

        if cmd.choked_commands == 0 then
            antiaim.packets = antiaim.packets + 1
            antiaim.choking = not antiaim.choking
        end
    end)
    antiaim.get_state = function()
        local me = entity.get_local_player()
        if not me then return end

        local velocity = (me.m_vecVelocity):length();
        local flag = me.m_fFlags;
        local duck = me.m_bDucked;
        if flag == 256 or flag == 262 then
            antiaim.in_air = true
            antiaim.ticks = globals.tickcount + 3
        else
            antiaim.in_air = (antiaim.ticks > globals.tickcount) and true or false
        end
        if antiaim.in_air then
            if duck and menu.elements.builder.base['air-crouching'].enable:get() then
                return 'air-crouching'
            end
            return 'air'
        end
        if duck then
            if velocity > 15 and menu.elements.builder.base['crouching-move'].enable:get() then
                return 'crouching-move'
            end
            return 'crouching'
        end

        if velocity < 5 then
            return 'standing'
        else
            if menu.refs.slowwalk:get() then
                return 'walking'
            end
            return 'running'
        end
    end;
    antiaim.get_height_diff = function()
        if entity.get_threat() == nil then return 0 end
        local lp_origin = entity.get_local_player().m_vecOrigin
        local enemy_origin = entity.get_threat().m_vecOrigin
        local diff = lp_origin.z - enemy_origin.z or 0
        return diff
    end;
    antiaim.get_defensive = function(type)
        local me = entity.get_local_player()
        if not me then return end
        local state = antiaim.get_state()
        state = menu.elements.builder.defensive[state].enable:get() and menu.elements.builder.defensive[state] or
            menu.elements.builder.defensive['global']
        local tickbase = me.m_nTickBase

        if math.abs(tickbase - antiaim.max_tickbase) > 64 then
            antiaim.max_tickbase = 0
        end

        local defensive_ticks_left = 0

        if tickbase > antiaim.max_tickbase then
            antiaim.max_tickbase = tickbase
        elseif antiaim.max_tickbase > tickbase then
            defensive_ticks_left = math.min(14, math.max(0, antiaim.max_tickbase - tickbase - 1))
        end
        return (type == 'safe' and defensive_ticks_left > 2 or defensive_ticks_left > 0)
    end
    antiaim.force_defensive = function(type, bool)
        if type == 1 then
            menu.refs.hideshotsoptions:override(bool and 'Break LC' or nil)
        end
        if type == 2 then
            menu.refs.lagoptions:override(bool and 'Always On' or nil)
        end
    end
    antiaim.builder = {}; do
        antiaim.builder.side = -1;
        antiaim.builder.inverted = false;
        antiaim.builder.way = 1;
        antiaim.builder.jitter = 0;
        antiaim.builder.spin = { yaw = -180, pitch = -89 };
        antiaim.builder.manual = { ['left'] = -115, ['right'] = 90, ['forward'] = 180 }
        antiaim.builder.get_yaw = function()
            local state = antiaim.get_state();
            local def = menu.elements.builder.defensive[state].enable:get() and menu.elements.builder.defensive[state] or
                menu.elements.builder.defensive['global'];
            local builder = menu.elements.builder.base[state].enable:get() and menu.elements.builder.base[state] or
                menu.elements.builder.base['global'];
            local ctx = (antiaim.get_defensive(def.mode:get()) and def.enable:get()) and def or builder
            if ctx.yaw.mode:get() == 'static' then
                return ctx.yaw.static:get()
            end
            if ctx.yaw.mode:get() == 'sided' then
                return antiaim.builder.inverted and ctx.yaw.left:get() or ctx.yaw.right:get()
            end
            if ctx.yaw.mode:get() == 'x-way' then
                if antiaim.builder.way == 1 then
                    return ctx.yaw.way1:get()
                end
                if antiaim.builder.way == 2 then
                    return ctx.yaw.way2:get()
                end
                if antiaim.builder.way == 3 then
                    return ctx.yaw.way3:get()
                end
                if antiaim.builder.way == 4 then
                    return ctx.yaw.way4:get()
                end
                if antiaim.builder.way == 5 then
                    return ctx.yaw.way5:get()
                end
                if antiaim.builder.way == 6 then
                    return ctx.yaw.way6:get()
                end
                if antiaim.builder.way == 7 then
                    return ctx.yaw.way7:get()
                end
            end
        end
        antiaim.builder.get_jitter = function()
            local state = antiaim.get_state();
            local def = menu.elements.builder.defensive[state].enable:get() and menu.elements.builder.defensive[state] or
                menu.elements.builder.defensive['global'];
            local builder = menu.elements.builder.base[state].enable:get() and menu.elements.builder.base[state] or
                menu.elements.builder.base['global'];
            local ctx = (antiaim.get_defensive(def.mode:get()) and def.enable:get()) and def or builder
            if ctx.modifier:get() == 'center' then
                return (antiaim.builder.inverted and
                        -ctx.modifier.offset:get() / 2 or ctx.modifier.offset:get() / 2) +
                    utils.random_int(-ctx.modifier.randomization:get(), ctx.modifier.randomization:get())
            end
            if ctx.modifier:get() == 'offset' then
                return (antiaim.builder.inverted and
                        0 or ctx.modifier.offset:get() / 2) +
                    utils.random_int(-ctx.modifier.randomization:get(), ctx.modifier.randomization:get())
            end
            return 0
        end
        antiaim.builder.get_pitch = function()
            local state = antiaim.get_state();
            local def = menu.elements.builder.defensive[state].enable:get() and menu.elements.builder.defensive[state] or
                menu.elements.builder.defensive['global']
            if antiaim.get_defensive(def.mode:get()) and def.enable:get() then
                if def.pitch.mode:get() == 'custom' then
                    rage.antiaim:override_hidden_pitch(def.pitch.custom:get())
                end
                if def.pitch.mode:get() == 'jitter' then
                    rage.antiaim:override_hidden_pitch(antiaim.builder.inverted and def.pitch.from:get() or
                        def.pitch.to:get())
                end
                if def.pitch.mode:get() == 'randomized' then
                    rage.antiaim:override_hidden_pitch(utils.random_int(def.pitch.from:get(), def.pitch.to:get()))
                end
                if def.pitch.mode:get() == 'spinable' then
                    antiaim.builder.spin.pitch = -animation:spin('pitch spin ' .. state, def.pitch.from:get(),
                        def.pitch.to:get(), 0.01,
                        def.pitch.speed:get() / 10).value * (def.pitch.from:get() <= 0 and -1 or 1)
                    if antiaim.builder.spin.pitch >= -89 then
                        antiaim.builder.spin.pitch = animation:spin('pitch spin ' .. state, def.pitch.from:get(),
                            def.pitch.to:get(), 0.01,
                            def.pitch.speed:get() / 10).value * (def.pitch.from:get() <= 0 and 1 or -1)
                    end
                    rage.antiaim:override_hidden_pitch(antiaim.builder.spin.pitch)
                end
            else
                menu.refs.pitch:override('Down')
            end
        end
        antiaim.builder.get_fake = function(yaw)
            local state = antiaim.get_state();
            local def = menu.elements.builder.defensive[state].enable:get() and menu.elements.builder.defensive[state] or
                menu.elements.builder.defensive['global'];
            local builder = menu.elements.builder.base[state].enable:get() and menu.elements.builder.base[state] or
                menu.elements.builder.base['global'];
            local ctx = (antiaim.get_defensive(def.mode:get()) and def.enable:get()) and def or builder
            if ctx.fake.mode:get() == 'static' then
                menu.refs.bodyyaw_leftlimit:override(ctx.fake.left:get())
                menu.refs.bodyyaw_rightlimit:override(ctx.fake.right:get())
                rage.antiaim:inverter(ctx.fake.inverter:get())
            end
            if ctx.fake.mode:get() == 'jitter' then
                menu.refs.bodyyaw_leftlimit:override(ctx.fake.left:get())
                menu.refs.bodyyaw_rightlimit:override(ctx.fake.right:get())
                rage.antiaim:inverter(antiaim.builder.inverted)
            end
            if ctx.fake.mode:get() == 'automatic' then
                menu.refs.bodyyaw_leftlimit:override(yaw == 0 and 0 or ctx.fake.left:get())
                menu.refs.bodyyaw_rightlimit:override(yaw == 0 and 0 or ctx.fake.right:get())
                rage.antiaim:inverter(yaw < 0 and true or false)
            end
        end
        antiaim.builder.calculate_flick = function(cmd)
            local me = entity.get_local_player();

            local side = (me.m_nTickBase % 6) > 2 and 1 or -1;
            local cases = {
                [cmd.in_moveleft or cmd.in_left] = 90,
                [cmd.in_moveright or cmd.in_right] = -90,
                [cmd.in_forward] = 90 * side,
                [cmd.in_back] = -90 * side,
            };

            for name, value in pairs(cases) do
                if name then
                    return value
                end
            end;
            return 90 * side
        end
        antiaim.builder.handle = function(cmd)
            local me = entity.get_local_player()
            local weapon = me:get_player_weapon()
            if weapon == nil then return end
            local weapon_name = weapon:get_classname()
            local state = antiaim.get_state();
            local def = menu.elements.builder.defensive[state].enable:get() and menu.elements.builder.defensive[state] or
                menu.elements.builder.defensive['global'];
            local builder = menu.elements.builder.base[state].enable:get() and menu.elements.builder.base[state] or
                menu.elements.builder.base['global'];
            menu.refs.hidden:override(antiaim.get_defensive(def.mode:get()) and def.enable:get() or
                menu.elements.antiaim.flick:get())
            local ctx = (antiaim.get_defensive(def.mode:get()) and def.enable:get()) and def or builder
            if ctx.spin:get() then
                antiaim.builder.spin.yaw = -animation:spin('yaw spin ' .. state, -ctx.spin.range:get(),
                    ctx.spin.range:get(), 0.01,
                    ctx.spin.speed:get() / 10).value * (ctx.spin.range:get() <= 0 and 1 or -1)
                if antiaim.builder.spin.yaw >= 180 then
                    antiaim.builder.spin.yaw = -180
                end
            else
                antiaim.builder.spin.yaw = 0
            end
            if cmd.choked_commands == 0 then
                antiaim.builder.way = antiaim.builder.way + 1
                antiaim.builder.randomized = utils.random_int(1, ctx.delay:get())
            end
            if antiaim.builder.way > ctx.yaw.way:get() then antiaim.builder.way = 1 end
            if antiaim.packets - antiaim.last_flick >= (ctx.randomize_delay:get() and antiaim.builder.randomized or ctx.delay:get()) then
                antiaim.builder.inverted = not antiaim.builder.inverted

                antiaim.last_flick = antiaim.packets
            end
            antiaim.force_defensive(1, menu.elements.builder.defensive[state].force:get(2) and menu.refs.hideshots:get())
            antiaim.force_defensive(2, menu.elements.builder.defensive[state].force:get(1) and menu.refs.doubletap:get())
            local manuals = {
                ['at target'] = { 0, 'At Target' },
                ['left'] = { -90, 'Local View' },
                ['right'] = { 115, 'Local View' },
                ['forward'] = { 180, 'Local View' },
            }
            antiaim.builder.yaw = antiaim.normalize(antiaim.builder.get_yaw() + antiaim.builder.get_jitter() +
                antiaim.builder.spin.yaw + manuals[menu.elements.antiaim.manuals:get()][1])
            if (menu.elements.antiaim.freestand:get() and menu.elements.antiaim.freestand.disablers:get('yaw modifiers')) then
                antiaim.builder.yaw = 0
                antiaim.force_defensive(1, menu.elements.antiaim.freestand.ebait:get())
                antiaim.force_defensive(2, menu.elements.antiaim.freestand.ebait:get())
                if menu.elements.antiaim.freestand.ebait:get() then
                    rage.antiaim:override_hidden_pitch(utils.random_int(-25, 25));
                    rage.antiaim:override_hidden_yaw_offset(180 - manuals[menu.elements.antiaim.manuals:get()][1]);
                else
                    rage.antiaim:override_hidden_pitch(89);
                    rage.antiaim:override_hidden_yaw_offset(0);
                end
            end
            if (menu.elements.antiaim.manuals:get() ~= 'at target' and menu.elements.antiaim.manuals.disablers:get('yaw modifiers')) then
                menu.refs.freestanding:override(false)
                antiaim.builder.yaw = manuals[menu.elements.antiaim.manuals:get()][1]
                antiaim.force_defensive(1, menu.elements.antiaim.manuals.ebait:get())
                antiaim.force_defensive(2, menu.elements.antiaim.manuals.ebait:get())
                if menu.elements.antiaim.manuals.ebait:get() then
                    rage.antiaim:override_hidden_pitch(utils.random_int(-25, 25));
                    rage.antiaim:override_hidden_yaw_offset(180);
                else
                    rage.antiaim:override_hidden_pitch(89);
                    rage.antiaim:override_hidden_yaw_offset(0);
                end
            end
            menu.refs.yawmodifier:override('Disabled');
            menu.refs.bodyyaw:override(ctx.fake:get());
            menu.refs.yawoffset:override(antiaim.builder.yaw)
            antiaim.builder.get_fake(antiaim.builder.yaw)
            menu.refs.yawbase:override(manuals[menu.elements.antiaim.manuals:get()][2])
            if (menu.elements.antiaim.manuals:get() ~= 'at target' and menu.elements.antiaim.manuals.disablers:get('fake modifiers')) then
                rage.antiaim:inverter(false)
            end
            if (menu.elements.antiaim.freestand:get() and menu.elements.antiaim.freestand.disablers:get('yaw modifiers')) then
                rage.antiaim:inverter(false)
            end
            if def.enable:get() and antiaim.get_defensive(def.mode:get()) then
                menu.refs.yawoffset:override(0)
                rage.antiaim:override_hidden_yaw_offset(antiaim.builder.yaw);
            end
            menu.refs.freestanding:override(menu.elements.antiaim.freestand:get())
            local safehead = {
                (weapon_name == 'CKnife' and state:find('air') and menu.elements.antiaim.safehead:get('air-knife')),
                (weapon_name == 'CWeaponTaser' and state:find('air') and menu.elements.antiaim.safehead:get('air-taser')),
                (antiaim.get_height_diff() >= 65 and menu.elements.antiaim.safehead:get('height difference') and state ~= 'running'),
            }
            for i, fn in pairs(safehead) do
                if fn then
                    menu.refs.bodyyaw:override(true);
                    menu.refs.yawoffset:override(25)
                    menu.refs.bodyyaw_leftlimit:override(60)
                    menu.refs.bodyyaw_rightlimit:override(60)
                    rage.antiaim:inverter(false)
                    antiaim.force_defensive(1, true)
                    antiaim.force_defensive(2, true)
                    if menu.elements.antiaim.safehead.ebait:get() then
                        rage.antiaim:override_hidden_pitch(utils.random_int(-25, 25));
                        rage.antiaim:override_hidden_yaw_offset(-180 + 35);
                    else
                        rage.antiaim:override_hidden_pitch(89);
                        rage.antiaim:override_hidden_yaw_offset(0);
                    end
                end
            end
            if menu.elements.antiaim.flick:get() then
                rage.antiaim:override_hidden_pitch(cmd.send_packet and 0 or -90);
                rage.antiaim:override_hidden_yaw_offset(antiaim.builder.calculate_flick(cmd));
                if cmd.command_number % 8 == 0 then
                    cmd.force_defensive = true;
                end
            end
            if menu.elements.antiaim.defensive:get() then
                if menu.elements.antiaim.defensive.condition:get('peek') and (entity.get_threat() ~= nil and entity.get_threat(true) or false)
                    or menu.elements.antiaim.defensive.condition:get('velocity break') and me.m_flVelocityModifier ~= 1 then
                    antiaim.force_defensive(1, true)
                    antiaim.force_defensive(2, true)
                end
            end
        end
    end
    antiaim.air_lag = function(cmd)
        if menu.elements.antiaim.airlag:get() then
            if not antiaim.in_air then return end
            if globals.tickcount % 2 == 0 then
                antiaim.exploit = antiaim.exploit + 1
            end
            if antiaim.exploit > 2 then
                cmd.force_defensive = true
                menu.refs.yawoffset:override(0)
                rage.exploit:force_teleport()
                antiaim.exploit = 1
            elseif entity.get_threat(false) ~= nil then
                rage.exploit:force_charge()
            end
        end
    end
    events.createmove:set(function(cmd)
        if not menu.elements.antiaim.master:get() then return end
        antiaim.builder.get_pitch()
        antiaim.builder.handle(cmd)
        antiaim.air_lag(cmd)
        animation:tick(globals.tickcount)
    end)
end
local visuals = {}; do
    local x, y = constants.render.screen.x / 2, constants.render.screen.y / 2
    visuals.watermark = function()
        local clr = menu.elements.visuals.accent:get()
        if menu.elements.visuals.watermark:get() == 'basic' then
            render.text(4, vector(x, constants.render.screen.y - 20), color(255, 255, 255, 200), 'c', 'night.project')
        end
        if menu.elements.visuals.watermark:get() == 'modern' then
            local text = helpers.gradient(script.build, globals.realtime, clr, color(155))
            render.texture(constants.render.watermark, vector(15, y + 15), nil, nil, nil, 20);
            render.text(2, vector(45, y + 20), color(255), nil,
                string.format('night.project [%s\aFFFFFFFF]', text):upper())
            render.text(2, vector(45, y + 28), color(255), nil, string.format('user: %s', script.name):upper())
        end
        if menu.elements.visuals.watermark:get() == 'gradient' then
            local text = helpers.gradient('N I G H T', globals.realtime, color(255), color(155))
            render.text(1, vector(15, y + 5), color(255), '',
                string.format('%s \a%s[%s]', text, clr:to_hex(), script.build):upper())
        end
    end
    local ind_enable = tweening.new(0)
    local ind_grenade = tweening.new(0)
    local ind_scope = tweening.new(0)
    visuals.crosshair = {}; do
        visuals.crosshair.legacy = {
            {
                name = 'doubletap',
                active = function()
                    return menu.refs.doubletap:get()
                end,
                animation = tweening.new(0),
                alpha = function()
                    return math.clamp(rage.exploit:get(), 0.3, 1)
                end
            },
            {
                name = 'hideshot',
                active = function()
                    return menu.refs.hideshots:get() and not menu.refs.doubletap:get()
                end,
                animation = tweening.new(0),
                alpha = function()
                    return 1
                end
            },
            {
                name = 'damage',
                active = function()
                    for i in pairs(ui.get_binds()) do
                        if ui.get_binds()[i].name == 'Min. Damage' then
                            return ui.get_binds()[i].active
                        end
                    end
                end,
                animation = tweening.new(0),
                alpha = function()
                    return 1
                end
            },
            {
                name = 'hitchance',
                active = function()
                    for i in pairs(ui.get_binds()) do
                        if ui.get_binds()[i].name == 'Hit Chance' then
                            return ui.get_binds()[i].active
                        end
                    end
                end,
                animation = tweening.new(0),
                alpha = function()
                    return 1
                end
            },
            {
                name = 'bodyaim',
                active = function()
                    for i in pairs(ui.get_binds()) do
                        if ui.get_binds()[i].name == 'Body Aim' then
                            return ui.get_binds()[i].active
                        end
                    end
                end,
                animation = tweening.new(0),
                alpha = function()
                    return 1
                end
            },
        };
    end
    visuals.legacy_indicators = function()
        local me = entity.get_local_player()
        if not me or not me:is_alive() then return end
        ind_enable(.07, menu.elements.visuals.indicators.enable:get() and menu.elements.visuals.master:get())
        if ind_enable.value < .01 then return end
        local font = menu.elements.visuals.indicators.font:get() == 'default' and 1 or 2
        local add = menu.elements.visuals.indicators.y_add:get()
        local size = function(font, str)
            if font == 2 then
                str = str:upper()
                return str
            end
            return str
        end
        local clr = menu.elements.visuals.accent:get()
        ind_scope(.07, me.m_bIsScoped)
        if menu.elements.visuals.indicators.shadow:get() then
            render.shadow(
                vector(x - render.measure_text(font, nil, 'night.project').x / 2 + (35 * ind_scope.value), y + add),
                vector(x + render.measure_text(font, nil, 'night.project').x / 2 + (35 * ind_scope.value), y + add),
                menu.elements.visuals.accent:get(), 40)
        end
        render.text(font, vector(x + (35 * ind_scope.value), y + add), clr:alpha_modulate(255 * ind_enable.value), 'c',
            size(font, 'night.project'))
        local addition = 0
        for i, name in ipairs(visuals.crosshair.legacy) do
            name.animation(.07, ({ name.active() })[1] == true or false)
            name.sub = string.sub(size(font, name.name), 1, #name.name * name.animation.value)
            name.scope = (render.measure_text(font, nil, name.sub).x / 2 + (font == 2 and 6 or 4)) * ind_scope.value *
                ind_enable.value
            local add_y = font == 1 and 10 or 9
            render.text(font, vector(x + name.scope, y + add + add_y + addition + (add < 0 and -20 or 0)),
                clr:alpha_modulate(255 * ind_enable.value * name.animation.value * name.alpha()), 'c', name.sub)
            addition = addition + (add < 0 and -add_y or add_y) * ind_enable.value * name.animation.value
        end
    end
    visuals.arrow_anim = tweening.new(0)
    visuals.arrows = function()
        local me = entity.get_local_player()
        if not me or not me:is_alive() then return end
        visuals.arrow_anim(.07, menu.elements.antiaim.manuals:get() ~= 'at target')
        local anim = visuals.arrow_anim.value
        if menu.elements.visuals.arrows:get() == 'minimalistic' then
            local left = menu.elements.antiaim.manuals:get() == 'left' and
                menu.elements.visuals.accent:get():alpha_modulate(200 * anim) or color(25, 155)
            local right = menu.elements.antiaim.manuals:get() == 'right' and
                menu.elements.visuals.accent:get():alpha_modulate(200 * anim) or color(25, 155)
            render.text(constants.render.arrows, vector(x - 40, y - 0), left, 'c', '⯇')
            render.text(constants.render.arrows, vector(x + 40, y - 0), right, 'c', '⯈')
        end
        if menu.elements.visuals.arrows:get() == 'default' then
            if menu.elements.antiaim.manuals:get() == 'left' then
                render.text(constants.render.gamesense, vector(x - 55, y - 0),
                    menu.elements.visuals.accent:get():alpha_modulate(200 * anim), 'c', '<')
            end
            if menu.elements.antiaim.manuals:get() == 'right' then
                render.text(constants.render.gamesense, vector(x + 55, y - 0),
                    menu.elements.visuals.accent:get():alpha_modulate(200 * anim), 'c', '>')
            end
        end
    end
    visuals.gamesense = function()
        if not menu.elements.visuals.gamesense:get() then return end
        local clr, text, velocity
        local dst = 0
        local screen = constants.render.screen
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        local body = (function()
            for i in pairs(ui.get_binds()) do
                if ui.get_binds()[i].name == 'Body Aim' then
                    return ui.get_binds()[i].active
                end
            end
        end)()
        local safepoint = (function()
            for i in pairs(ui.get_binds()) do
                if ui.get_binds()[i].name == 'Safe Points' then
                    return ui.get_binds()[i].active
                end
            end
        end)()
        local damage = (function()
            for i in pairs(ui.get_binds()) do
                if ui.get_binds()[i].name == 'Min. Damage' then
                    return ui.get_binds()[i].active
                end
            end
        end)()
        if not local_player then return end

        if not local_player:is_alive() then
            constants.render.shot, constants.render.hit = 0, 0
            goto skip
        end

        clr = rage.exploit:get() == 1 and color(200) or color(255, 0, 50)
        if (menu.elements.visuals.gamesense.indicators:get(1) and menu.refs.doubletap:get()) and (menu.elements.visuals.gamesense.indicators:get(5) and menu.refs.fakeduck:get()) then
            goto continue
        elseif menu.elements.visuals.gamesense.indicators:get(1) and menu.refs.doubletap:get() then
            constants.render.render_indicator('DT', clr, dst)
            dst = dst + 41
        end

        if (menu.elements.visuals.gamesense.indicators:get('on shot anti-aim') and menu.refs.hideshots:get()) and (menu.elements.visuals.gamesense.indicators:get('double tap') and menu.refs.doubletap:get()) or (menu.elements.visuals.gamesense.indicators:get('fake Duck') and menu.refs.fakeduck:get()) then
            goto continue
        elseif menu.elements.visuals.gamesense.indicators:get('on shot anti-aim') and menu.refs.hideshots:get() then
            constants.render.render_indicator('OSAA', color(200), dst)
            dst = dst + 41
        end

        :: continue ::

        clr = (entity.get_threat() ~= nil and entity.get_threat():is_dormant() or false) and color(200) or
            color(255, 0, 50)

        if menu.elements.visuals.gamesense.indicators:get('dormant aimbot') and menu.refs.dormant:get() then
            constants.render.render_indicator('DA', clr, dst)
            dst = dst + 41
        end

        text = string.format('%d/%d (%.1f)', constants.render.hit, constants.render.shot,
            constants.render.hit > 0 and constants.render.shot > 0 and
            (constants.render.hit / constants.render.shot) * 100 or 0)

        if menu.elements.visuals.gamesense.indicators:get('hit/miss rate') then
            constants.render.render_indicator(text, color(200), dst)
            dst = dst + 41
        end

        velocity = vector(local_player['m_vecVelocity[0]'], local_player['m_vecVelocity[1]'],
            local_player['m_vecVelocity[2]'])
        clr = (velocity:length2d() > 250 or velocity.z > 250) and rage.exploit:get() ~= 1 and
            color(143, 194, 21) or color(255, 0, 50)

        if menu.elements.visuals.gamesense.indicators:get('lag compensation') and bit.band(local_player.m_fFlags, 1) == 0 then
            constants.render.render_indicator('LC', clr, dst)
            dst = dst + 41
        end

        if menu.elements.visuals.gamesense.indicators:get('fake duck') and menu.refs.fakeduck:get() then
            constants.render.render_indicator('DUCK', color(200), dst)
            dst = dst + 41
        end

        if menu.elements.visuals.gamesense.indicators:get('force safepoint') and safepoint then
            constants.render.render_indicator('SAFE', color(200), dst)
            dst = dst + 41
        end

        if menu.elements.visuals.gamesense.indicators:get('force body aim') and body then
            constants.render.render_indicator('BODY', color(200), dst)
            dst = dst + 41
        end

        if menu.elements.visuals.gamesense.indicators:get('damage override') and damage then
            constants.render.render_indicator('MD', color(200), dst)
            dst = dst + 41
        end

        if menu.elements.visuals.gamesense.indicators:get('peek assist') and menu.elements.antiaim.freestand:get() then
            constants.render.render_indicator('FS', color(200), dst)
            dst = dst + 41
        end

        :: skip ::

        if menu.elements.visuals.gamesense.indicators:get('bomb info') then
            entity.get_entities('CPlantedC4', true, function(c4)
                if c4.m_bBombDefused then
                    return
                else
                    local time = c4.m_flC4Blow - globals.curtime
                    local defused = c4.m_bBombDefused

                    if time >= -1 and not defused and not constants.render.defused then
                        local defusestart = c4.m_hBombDefuser ~= nil
                        local defuselength = c4.m_flDefuseLength
                        local defusetimer = defusestart and
                            math.floor((c4.m_flDefuseCountDown - globals.curtime) * 10) / 10 or -1

                        if defusetimer > 0 and not constants.render.abort_defuse then
                            local clr = math.floor(time) > defusetimer and color(58, 191, 54, 160) or
                                color(252, 18, 19, 125)
                            local barlength = ((screen.y - (defuselength > 5 and 50 or screen.y * 0.5)) / defuselength) *
                                defusetimer

                            render.rect(vector(), vector(21, screen.y), color(25, 160))
                            render.rect(vector(1, screen.y - barlength), vector(20, screen.y - 1), clr)
                        end

                        local site = c4.m_nBombSite == 0 and 'A' or 'B'
                        local health = local_player.m_iHealth
                        local armor = local_player.m_ArmorValue
                        local damage = constants.calculate_damage(local_player, c4, armor)
                        local fatal = damage >= health and true or false

                        constants.render.render_indicator(string.format('%s - %.1fs', site, time >= 0 and time or 0),
                            color(200), dst,
                            constants.render.bomb)
                        dst = dst + 41

                        if local_player:is_alive() and damage >= 1 then
                            if fatal then
                                constants.render.render_indicator('FATAL', color(255, 0, 50), dst)
                                dst = dst + 41
                            else
                                constants.render.render_indicator(string.format('-%d HP', damage), color(252, 243, 105),
                                    dst)
                                dst = dst + 41
                            end
                        end
                    end
                end
            end)

            if constants.render.planting then
                constants.render.render_indicator(constants.render.planting_site, color(252, 243, 105), dst,
                    constants.render.bomb)
                constants.render.fill = 3 - (3 + constants.plant_time - globals.curtime)
                if (constants.render.fill > 3) then constants.render.fill = 3 end
                render.circle_outline(vector(95, constants.render.y - dst + 20), color(0), 7, 0, 1, 4)
                render.circle_outline(vector(95, constants.render.y - dst + 20), color(200), 7, 0,
                    constants.render.fill / 3, 3)
                dst = dst + 41
            end
        end
    end
    visuals.damage = function()
        if not menu.elements.visuals.indicators.damage:get() then return end
        local me = entity.get_local_player()
        if not me or not me:is_alive() then return end
        render.text(1, vector(x + 5, y - 15), color(255, 200), nil, menu.refs.mindamage:get())
    end
    visuals.defensive_anim = tweening.new(0)
    visuals.defensive = function()
        local me = entity.get_local_player()
        if not me then return end
        local is_defensive = antiaim.get_defensive('')
        visuals.defensive_anim(.07, is_defensive and menu.elements.visuals.defensive:get())
        local anim = visuals.defensive_anim.value
        if anim > 0.01 then
            render.texture(constants.render.defensive, vector(constants.render.screen.x / 2 - 9, 80),
                menu.elements.visuals.accent:get():alpha_modulate(200 * anim), nil, nil, nil)
            render.rect(vector(constants.render.screen.x / 2 - 74, 104), vector(constants.render.screen.x / 2 + 74, 109),
                color(0, 200 * anim), 4)
            render.rect(vector(constants.render.screen.x / 2 - (72 * anim), 105),
                vector(constants.render.screen.x / 2 + 72 * anim, 108),
                menu.elements.visuals.accent:get():alpha_modulate(200 * anim), 4)
        end
    end
    visuals.velocity_anim = tweening.new(0)
    visuals.velocity = function()
        local me = entity.get_local_player()
        if not me then return end
        local value = me.m_flVelocityModifier
        visuals.velocity_anim(.07, value ~= 1 and menu.elements.visuals.velocity:get())
        local anim = visuals.velocity_anim.value
        if anim > 0.01 then
            local value = 1 - value
            render.texture(constants.render.velocity, vector(constants.render.screen.x / 2 - 12, 110),
                menu.elements.visuals.accent:get():alpha_modulate(200 * anim), nil, nil, nil)
            render.rect(vector(constants.render.screen.x / 2 - 74, 134), vector(constants.render.screen.x / 2 + 74, 139),
                color(0, 200 * anim), 4)
            render.rect(vector(constants.render.screen.x / 2 - (72 * value), 135),
                vector(constants.render.screen.x / 2 + 72 * value, 138),
                menu.elements.visuals.accent:get():alpha_modulate(200 * anim), 4)
        end
    end
    visuals.scope_enable = tweening.new(0)
    visuals.scope_scoped = tweening.new(0)
    visuals.scope = function()
        local me = entity.get_local_player()
        if not me then return end
        visuals.scope_enable(.1, menu.elements.visuals.scope:get())
        menu.refs.scope:override(menu.elements.visuals.scope:get() and 'Remove All' or nil)
        if visuals.scope_enable.value < .01 then return end
        local scoped = me.m_bIsScoped
        visuals.scope_scoped(.1, scoped)
        if visuals.scope_scoped.value < .01 then return end
        local weapon = me:get_player_weapon()
        if weapon == nil then
            return
        end
        local weapon_type = weapon:get_weapon_info().weapon_type
        if weapon_type ~= 5 then return end
        local clr = menu.elements.visuals.scope.colorpicker:get()
        local width = menu.elements.visuals.scope.width:get()
        local offset = menu.elements.visuals.scope.offset:get()
        if not menu.elements.visuals.scope.removals:get('top') then
            render.gradient(vector(x, y - offset + 1), vector(x + 1, y - width), clr:alpha_modulate(clr.a * visuals.scope_enable.value * visuals.scope_scoped.value),
                clr:alpha_modulate(clr.a * visuals.scope_enable.value * visuals.scope_scoped.value),
                clr:alpha_modulate(0),
                clr:alpha_modulate(0))
        end
        if not menu.elements.visuals.scope.removals:get('bottom') then
            render.gradient(vector(x, y + offset), vector(x + 1, y + width), clr:alpha_modulate(clr.a * visuals.scope_enable.value * visuals.scope_scoped.value),
            clr:alpha_modulate(clr.a * visuals.scope_enable.value * visuals.scope_scoped.value),
                clr:alpha_modulate(0),
                clr:alpha_modulate(0))
        end
        if not menu.elements.visuals.scope.removals:get('left') then
            render.gradient(vector(x + offset, y), vector(x + width, y + 1), clr:alpha_modulate(clr.a * visuals.scope_enable.value * visuals.scope_scoped.value),
            clr:alpha_modulate(0),
                clr:alpha_modulate(clr.a * visuals.scope_enable.value * visuals.scope_scoped.value),
                clr:alpha_modulate(0))
        end
        if not menu.elements.visuals.scope.removals:get('right') then
            render.gradient(vector(x - offset + 1, y), vector(x - width, y + 1), clr:alpha_modulate(clr.a * visuals.scope_enable.value * visuals.scope_scoped.value),
            clr:alpha_modulate(0),
                clr:alpha_modulate(clr.a * visuals.scope_enable.value * visuals.scope_scoped.value),
                clr:alpha_modulate(0))
        end
    end

    events.render:set(function()
        visuals.watermark()
        visuals.legacy_indicators()
        visuals.arrows()
        visuals.damage()
        visuals.gamesense()
        visuals.defensive()
        visuals.velocity()
        visuals.scope()
    end)
end;

local additions = {}; do
    additions.choking = false
    additions.last_choke = 0
    additions.choke_count = 0
    additions.tick = 0
    additions.fakelag = function(cmd)
        local max_limit = 14
        local fakeduck_active = menu.refs.fakeduck:get()
        local onshot_active = menu.refs.hideshots:get()
        local doubletap_active = menu.refs.doubletap:get()

        local type = menu.elements.additions.fakelag.mode:get()
        local limit = menu.elements.additions.fakelag.limit:get()
        if cmd.choked_commands < limit then
            additions.tick = additions.tick + 1
        end
        if type == 'cycle' then
            limit = math.clamp(limit - additions.tick % 6, 1, 14)
        elseif type == 'randomized' then
            limit = math.clamp(limit - math.random(0, 6), 1, 14)
        end
        if entity.get_threat(true) then
            limit = 14
        end
        if fakeduck_active then
            limit = 14
        end

        menu.refs.fakelag:override(menu.elements.additions.fakelag:get() and true or nil)
        menu.refs.limit:override(menu.elements.additions.fakelag:get() and limit or nil)
        menu.refs.variability:override(menu.elements.additions.fakelag:get() and 100 or nil)
    end
    additions.should_body = false
    esp.enemy:new_text('Body aim on lethal', 'BODYAIMED', function(player)
        if player ~= entity.get_threat() then return end
        if not additions.should_body then return end
        return 'BODY'
    end)
    additions.force_body = function(cmd)
        local me = entity.get_local_player()
        if not me then return end
        local threat = entity.get_threat()
        if not threat then
            return
        end
        local weapon = me:get_player_weapon():get_weapon_info();
        if not weapon then return end
        local armor = threat.m_ArmorValue
        additions.lethal = {
            ['weapon_ssg08'] = armor > 0 and 93 or 100,
            ['weapon_awp'] = 100,
            ['weapon_deagle'] = 45,
        }
        local should = threat.m_iHealth <=
            (additions.lethal[weapon.weapon_name] ~= nil and additions.lethal[weapon.weapon_name] or 0) and
            menu.elements.additions.force_lethal:get()
        additions.should_body = should
        menu.refs.bodyaim:override((should and additions.lethal[weapon.weapon_name] ~= nil) and 'Force' or nil)
        menu.refs.force_on_peek:override((should and additions.lethal[weapon.weapon_name] ~= nil) and true or nil)
    end
    additions.WEAPONTYPE_GRENADE = 9
    additions.GRENADE_SECONDARY_DAMPENING = 0.5
    additions.super_toss_get = function(throw_angle, throw_velocity, throw_strength, abs_velocity)
        local vel = math.clamp(throw_velocity, 15, 750)
        local clamped_throw_strength = math.clamp(throw_strength, 0.0, 1.0)

        vel = vel * helpers.lerp(additions.GRENADE_SECONDARY_DAMPENING, 1.0, clamped_throw_strength)

        local forward = vector():angles(throw_angle)
        local throw = forward * vel - abs_velocity

        return throw:angles()
    end
    additions.super_toss = function(cmd)
        if not menu.elements.additions.super_toss:get() then return end
        if render.camera_angles() ~= cmd.view_angles:clone() then return end

        local lp = entity.get_local_player()
        if lp == nil then return end

        local weapon = lp:get_player_weapon()
        if weapon == nil then return end

        local weapon_info = weapon:get_weapon_info()
        if weapon_info == nil then return end

        local weapon_type = weapon_info.weapon_type

        if weapon_type == additions.WEAPONTYPE_GRENADE then
            local predicted_time = globals.curtime - to_time(globals.clock_offset)

            if weapon.m_fThrowTime > predicted_time then
                cmd.in_speed = true

                cmd.view_angles = additions.super_toss_get(
                    render.camera_angles(),
                    weapon_info.throw_velocity,
                    weapon.m_flThrowStrength,
                    lp.m_vecVelocity
                )
            end
        end
    end
    events.grenade_override_view:set(function(ctx)
        if not menu.elements.additions.super_toss:get() then return end
        local lp = entity.get_local_player()
        if lp == nil then return end

        local weapon = lp:get_player_weapon()
        if weapon == nil then return end

        local weapon_info = weapon:get_weapon_info()
        if weapon_info == nil then return end

        ctx.angles = additions.super_toss_get(
            ctx.angles,
            weapon_info.throw_velocity,
            weapon.m_flThrowStrength,
            ctx.velocity
        )
    end)
    events.createmove:set(function(cmd)
        additions.fakelag(cmd)
        additions.force_body(cmd)
        additions.super_toss(cmd)
    end)
    additions.ground_tick = 1
    additions.end_time = 0
    ffi.cdef [[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef struct {
        char  pad_0000[20];
        int m_nOrder; //0x0014
        int m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030
        char  pad_0038[4]; //0x0034
    } c_animlayers;
]]

    local function this_call(call_function, parameters) return function(...) return call_function(parameters, ...) end end
    local entity_list_003 = ffi.cast(ffi.typeof('uintptr_t**'),
        utils.create_interface('client.dll', 'VClientEntityList003'))
    local get_entity_address = this_call(ffi.cast('get_client_entity_t', entity_list_003[0][3]), entity_list_003)
    function entity.get_anim_layer(b, c)
        c = c or 1; b = ffi.cast(ffi.typeof('void***'), b)
        return ffi.cast('c_animlayers**', ffi.cast('char*', b) + 0x2990)[0][c]
    end

    additions.animbreaker = function()
        if not menu.elements.additions.animation:get() then return end
        local me = entity.get_local_player()
        local velocity = me.m_vecVelocity
        local on_land = bit.band(me.m_fFlags, bit.lshift(1, 0)) ~= 0
        local curtime = globals.curtime

        if on_land == true then
            additions.ground_tick = additions.ground_tick + 1
        else
            additions.ground_tick = 0
            additions.end_time = curtime + 1
        end
        if menu.elements.additions.animation.ground:get() == 'static' then
            me.m_flPoseParameter[0] = 1
            menu.refs.leg:override('Sliding')
        end
        if menu.elements.additions.animation.ground:get() == 'jitter' then
            if globals.tickcount % 4 > 1 then
                me.m_flPoseParameter[0] = 1
            end
            menu.refs.leg:override('Sliding')
        end
        if menu.elements.additions.animation.ground:get() == 'forward walking' then
            me.m_flPoseParameter[7] = 1
            menu.refs.leg:override('Walking')
        end
        if menu.elements.additions.animation.ground:get() == 'kangaroo' then
            me.m_flPoseParameter[3] = utils.random_int(0, 10) / 10
            me.m_flPoseParameter[9] = utils.random_int(0, 10) / 10
            me.m_flPoseParameter[10] = utils.random_int(0, 10) / 10
            menu.refs.leg:override('Walking')
        end

        if menu.elements.additions.animation.air:get() == 'static' then
            me.m_flPoseParameter[6] = 1
        end
        if menu.elements.additions.animation.air:get() == 'jitter' then
            if globals.tickcount % 4 > 1 then
                me.m_flPoseParameter[6] = 1
            end
        end
        if menu.elements.additions.animation.air:get() == 'walking' then
            if math.abs(velocity.z) > 2 then
                entity.get_anim_layer(get_entity_address(entity.get_local_player():get_index()), 12).m_flWeight = 1
            end
        end
        if menu.elements.additions.animation.air:get() == 'kangaroo' then
            me.m_flPoseParameter[6] = utils.random_int(0, 10) / 10
        end
        if math.abs(velocity.z) > 2 then
            entity.get_anim_layer(get_entity_address(entity.get_local_player():get_index()), 12).m_flWeight =
                menu.elements.additions.animation.lean:get() / 100
        end
        if menu.elements.additions.animation.pitch:get() then
            if additions.ground_tick > 1 and additions.end_time > curtime and on_land then
                me.m_flPoseParameter[12] = .5
            end
        end
    end
    events.post_update_clientside_animation:set(function()
        additions.animbreaker()
    end)
    additions.hitchance = function()
        if not menu.elements.additions.hitchance:get() then
            menu.refs.hc:override()
            return
        end
        local me = entity.get_local_player()
        if me == nil then
            menu.refs.hc:override()
            return
        end
        local weapon = me:get_player_weapon()
        if weapon == nil then
            menu.refs.hc:override()
            return
        end
        local weapon_name = weapon:get_weapon_info().weapon_class
        local scoped = me.m_bIsScoped
        local ducked = me.m_bDucked
        local air = antiaim.in_air
        if not scoped and weapon_name == 'primary_sniper' and menu.elements.additions.hitchance.conditions:get('noscope') then
            menu.refs.hc:override(menu.elements.additions.hitchance.noscope:get())
        elseif ducked and menu.elements.additions.hitchance.conditions:get('predict') then
            menu.refs.hc:override(menu.elements.additions.hitchance.predict:get())
        elseif air and menu.elements.additions.hitchance.conditions:get('in-air') then
            menu.refs.hc:override(menu.elements.additions.hitchance.air:get())
        else
            menu.refs.hc:override(nil)
        end
    end
    additions.latency = function()
        if menu.elements.additions.unlock:get() then
            cvar.sv_maxunlag:float(0.8)
            menu.refs.lat:override(menu.elements.additions.unlock.amount:get())
        else
            cvar.sv_maxunlag:float(0.2)
            menu.refs.lat:override()
        end
    end
    additions.sv_maxusrcmdprocessticks = cvar.sv_maxusrcmdprocessticks:int()
    additions.idealtick = function()
        if menu.elements.additions.idealtick:get() then
            menu.refs.peek:override(true)
            menu.refs.peekstop:override({ 'Early' })
            menu.refs.immediateteleport:override(true)
            cvar.sv_maxusrcmdprocessticks:int(19)
        else
            menu.refs.peek:override()
            menu.refs.peekstop:override()
            menu.refs.immediateteleport:override()
            cvar.sv_maxusrcmdprocessticks:int(additions.sv_maxusrcmdprocessticks)
        end
    end
    additions.phrases = { '♛ Y u k i １ ３ ３ ７ ♛', '1', 'изи by night lua', 'хочешь играть так же? купи night.lua',
        'не можешь убить меня:( купи night.lua', 'ez', 'фу,жирный выблядок', 'аллах бабах чурки', 'изи выблядок',
        'iq?',
        '1 шлюха мать твою ебал', 'классно играешь', 'даже твоя мать с night.lua играет', 'ты старался',
        'бро почему сосал? потому что нет night.lua', 'спасибо за килл', 'ебать я тебя тапнул ущерб', 'l2p долбаеб',
        'ахахаха найс аа додик' }
    additions.clantag = {
        'night.lua',
        'night.lu',
        'night.l',
        'night.',
        'night',
        'nigh',
        'nig',
        'ni',
        'n',
        '',
        'n',
        'ni',
        'nig',
        'nigh',
        'night',
        'night.',
        'night.l',
        'night.lu',
        'night.lua',
    }
    events.aim_ack:set(function(e)
        if menu.elements.additions.idealtick:get() then
            menu.refs.immediateteleport:override(false)
            rage.exploit:force_teleport()
        end
    end)
    events.player_death:set(function(e)
        if not menu.elements.additions.killsay:get() then return end
        local lp = entity.get_local_player()
        if lp == nil then return end
        local userid = entity.get(e.userid, true)
        local attacker = entity.get(e.attacker, true)

        if lp ~= userid and lp == attacker then
            utils.console_exec('say ' .. additions.phrases[math.random(#additions.phrases)])
        end
    end)
    additions.tag = ui.find('Miscellaneous', 'Main', 'In-Game', 'Clan Tag')
    events.pre_render:set(function()
        local local_player = entity.get_local_player()
        if not local_player then return end
        local can_reset = true
        if menu.elements.additions.tag:get() then
            can_reset = false
            local realtime = math.floor((globals.curtime) * 2.5)
            if old_time ~= realtime then
                common.set_clan_tag(additions.clantag[realtime % #additions.clantag + 1]);
                old_time = realtime;
                additions.tag:override(false);
            end
        else
            can_reset = true
            local realtime = math.floor((globals.curtime) * 0)
            if old_time ~= realtime then
                if can_reset then
                    old_time = realtime;
                    additions.tag:override();
                    common.set_clan_tag('');
                    can_reset = false
                end
            end
        end
    end)
    additions.aspect = cvar.r_aspectratio:float()
    events.render:set(function()
        if menu.elements.visuals.aspect:get() then
            cvar.r_aspectratio:float(menu.elements.visuals.aspect.width:get() * 0.01)
        else
            cvar.r_aspectratio:float(0)
        end
    end)
    additions.x = cvar.viewmodel_offset_x:float()
    additions.y = cvar.viewmodel_offset_y:float()
    additions.z = cvar.viewmodel_offset_z:float()
    additions.fov = cvar.viewmodel_fov:float()
    events.render:set(function()
        if menu.elements.visuals.aspect:get() then
            cvar.r_aspectratio:float(menu.elements.visuals.aspect.width:get() * 0.01)
        else
            cvar.r_aspectratio:float(0)
        end
    end)
    events.shutdown:set(function()
        cvar.r_aspectratio:float(0)
    end)
    events.render:set(function()
        if menu.elements.visuals.viewmodel:get() then
            cvar.viewmodel_offset_x:float(menu.elements.visuals.viewmodel.x:get() * 0.1, true)
            cvar.viewmodel_offset_y:float(menu.elements.visuals.viewmodel.y:get() * 0.1, true)
            cvar.viewmodel_offset_z:float(menu.elements.visuals.viewmodel.z:get() * 0.1, true)
            cvar.viewmodel_fov:float(menu.elements.visuals.viewmodel.fov:get() * 0.1, true)
        else
            cvar.viewmodel_offset_x:float(additions.x)
            cvar.viewmodel_offset_y:float(additions.y)
            cvar.viewmodel_offset_z:float(additions.z)
            cvar.viewmodel_fov:float(additions.fov)
        end
    end)
    events.shutdown:set(function()
        cvar.viewmodel_offset_x:float(additions.x)
        cvar.viewmodel_offset_y:float(additions.y)
        cvar.viewmodel_offset_z:float(additions.z)
        cvar.viewmodel_fov:float(additions.fov)
    end)
    events.render:set(function()
        additions.hitchance()
        additions.latency()
        additions.idealtick()
    end)
    local e_hitgroup = {
        [0]  = 'generic',
        [1]  = 'head',
        [2]  = 'chest',
        [3]  = 'stomach',
        [4]  = 'chest',
        [5]  = 'chest',
        [6]  = 'legs',
        [7]  = 'legs',
        [8]  = 'head',
        [10] = 'gear'
    }
    events.aim_ack:set(function(e)
        if not menu.elements.visuals.logs:get() then return end
        local target = e.target
        local damage = e.damage or 0
        local remaining = (target.m_iHealth - damage) > 0 and (target.m_iHealth - damage) or 0

        local backtrack = e.backtrack
        local hitchance = e.hitchance

        local name = target:get_name()
        local hitgroup = e_hitgroup[e.hitgroup]
        if e.state == nil then
            local text = string.format('hit %s in %s for %s (%s remaining, %s hc, %s bt)', tostring(name),
                tostring(hitgroup), tostring(damage), tostring(remaining), hitchance, backtrack)
            common.add_notify('night.lua', text)
            print_raw(string.format('night.lua - %s', text))
        else
            local text = string.format('missed %s %s due to %s (%s hc, %s bt)', tostring(name),
                tostring(e_hitgroup[e.wanted_hitgroup]), tostring(e.state), hitchance, backtrack)
            common.add_notify('night.lua', text)
            print_raw(string.format('\aFF0000FFnight.lua \aDEFAULT- %s', text))
        end
    end)
end
