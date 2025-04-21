local ffi = require 'ffi'
local pui = require 'gamesense/pui';
local base64 = require 'gamesense/base64';
local clipboard = require 'gamesense/clipboard';
local vector = require 'vector';
local ent = require "gamesense/entity"
local http = require("gamesense/http")
local images = require 'gamesense/images'
local downloadfile = function()
    http.get('https://github.com/th3bloor4/night-lua/blob/main/moon.png?raw=true', function(success, response)
        if not success or response.status ~= 200 then
            return
        end
        writefile('night.png', response.body)
    end)
end
downloadfile()
local new_class = function()
    local mt, mt_data, this_mt = {}, {}, {}

    mt.__metatable = false
    mt_data.struct = function(self, name)
        assert(type(name) == 'string', 'invalid class name')
        assert(rawget(self, name) == nil, 'cannot overwrite subclass')

        return function(data)
            assert(type(data) == 'table', 'invalid class data')
            rawset(self, name, setmetatable(data, {
                __metatable = false,
                __index = function(self, key)
                    return
                        rawget(mt, key) or
                        rawget(this_mt, key)
                end
            }))

            return this_mt
        end
    end

    this_mt = setmetatable(mt_data, mt)

    return this_mt
end
local ctx = new_class()
    :struct 'functions' {
        create = function(self)
            self.animation = {}; do
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

                        assert(value_type == target_type,
                            string.format('type mismatch, expected %s (received %s)', value_type, target_type))

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

                function self.animation:create(default, easings_fn)
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
            end;
            self.render = {}; do
                self.render.to_hex = function(r, g, b, a)
                    return string.format("%02x%02x%02x%02x", r, g, b, a or 255)
                end
                self.render.breath = function(x)
                    x = x % 2.0

                    if x > 1.0 then
                        x = 2.0 - x
                    end

                    return x
                end
                self.render.gradient_text = function(s, clock, r1, g1, b1, a1, r2, g2, b2, a2)
                    local buffer = {}

                    local len = #string.gsub(s, "[\128-\191]", "")
                    local div = 1 / (len - 1)

                    local add_r = r2 - r1
                    local add_g = g2 - g1
                    local add_b = b2 - b1
                    local add_a = a2 - a1

                    for char in string.gmatch(s, ".[\128-\191]*") do
                        local t = self.render.breath(clock)

                        local r = r1 + add_r * t
                        local g = g1 + add_g * t
                        local b = b1 + add_b * t
                        local a = a1 + add_a * t

                        buffer[#buffer + 1] = "\a"
                        buffer[#buffer + 1] = self.render.to_hex(r, g, b, a)
                        buffer[#buffer + 1] = char

                        clock = clock - div
                    end

                    return table.concat(buffer)
                end
            end;
        end
    }
    :struct 'constants' {
        states = {
            { 'global', 'standing', 'running', 'walking', 'air',  'air-crouch', 'crouch', 'crouch-move' },
            { 'g',      's',        'r',       'w',       'a',    'a-c',        'c',      'c-m' },
            { '',       ' ',        '  ',      '   ',     '    ', '     ',      '      ', '       ' },
            { '',       ' ',        '  ',      '   ',     '    ', '     ',      '      ', '       ' },
        },
    }
    :struct 'menu' {
        config = nil,
        refs = {
            rage = {
                enabled = pui.reference('rage', 'aimbot', 'enabled'),
                correction = pui.reference('rage', 'other', 'anti-aim correction'),
                quickpeek = pui.reference('rage', 'other', 'quick peek assist'),
                duckpeek = pui.reference('rage', 'other', 'duck peek assist'),
                damage = pui.reference('rage', 'aimbot', 'minimum damage'),
                minimumdamage = { pui.reference('rage', 'aimbot', 'minimum damage override') },
                safepoint = pui.reference('rage', 'aimbot', 'force safe point'),
                bodyaim = pui.reference('rage', 'aimbot', 'force body aim'),
                doubletap = pui.reference('rage', 'aimbot', 'double tap'),
                onshot = pui.reference('aa', 'other', 'on shot anti-aim'),
            },
            antiaim = {
                enabled = pui.reference('aa', 'anti-aimbot angles', 'enabled'),
                pitch = ({ pui.reference('aa', 'anti-aimbot angles', 'pitch') })[1],
                custom = ({ pui.reference('aa', 'anti-aimbot angles', 'pitch') })[2],
                yaw = ({ pui.reference('aa', 'anti-aimbot angles', 'yaw') })[1],
                add = ({ pui.reference('aa', 'anti-aimbot angles', 'yaw') })[2],
                base = pui.reference('aa', 'anti-aimbot angles', 'yaw base'),
                jitter = ({ pui.reference('aa', 'anti-aimbot angles', 'yaw jitter') })[1],
                range = ({ pui.reference('aa', 'anti-aimbot angles', 'yaw jitter') })[2],
                body = ({ pui.reference('aa', 'anti-aimbot angles', 'body yaw') })[1],
                amount = ({ pui.reference('aa', 'anti-aimbot angles', 'body yaw') })[2],
                freestandingbody = pui.reference('aa', 'anti-aimbot angles', 'freestanding body yaw'),
                edgeyaw = pui.reference('aa', 'anti-aimbot angles', 'edge yaw'),
                freestanding = pui.reference('aa', 'anti-aimbot angles', 'freestanding'),
                roll = pui.reference('aa', 'anti-aimbot angles', 'roll'),
                fakepeek = pui.reference('aa', 'other', 'fake peek'),
            },
            fakelag = {
                enabled = pui.reference('aa', 'fake lag', 'enabled'),
                amount = pui.reference('aa', 'fake lag', 'amount'),
                variance = pui.reference('aa', 'fake lag', 'variance'),
                limit = pui.reference('aa', 'fake lag', 'limit'),
            },
            misc = {
                clantag = pui.reference('misc', 'miscellaneous', 'clan tag spammer'),
                damage = pui.reference('misc', 'miscellaneous', 'log damage dealt'),
                spread = pui.reference('rage', 'other', 'log misses due to spread'),
                slowmotion = pui.reference('aa', 'other', 'slow motion'),
                legs = pui.reference('aa', 'other', 'leg movement'),
                fakeduck = pui.reference('rage', 'other', 'duck peek assist'),
            },
        },
        groups = {
            angles = pui.group('aa', 'anti-aimbot angles'),
            fakelag = pui.group('aa', 'fake lag'),
            other = pui.group('aa', 'other'),
        },
        tab = {
            value = 1
        },
        create = function(self)
            self.welcome = {
                name = pui.label('aa', 'fake lag', 'night developer'),
                welcome = pui.label('aa', 'fake lag', 'welcome back, user!'),
                made = pui.label('aa', 'fake lag', 'made by l3v1y with love..//'),
            };
            self.navigation = {
                global = pui.button('aa', 'fake lag', 'global', function()
                    self.tab.value = 1
                end),
                antiaim = pui.button('aa', 'fake lag', 'antiaim', function()
                    self.tab.value = 2
                end),
                visual = pui.button('aa', 'fake lag', 'visual', function()
                    self.tab.value = 3
                end),
                gamesense = pui.button('aa', 'fake lag', 'gamesense', function()
                    self.tab.value = 4
                end)
            };
            self.configs = {
                name = pui.label('aa', 'other', 'config system'),
                export = pui.button('aa', 'other', 'export', function()
                    local config = self.config:save()
                    local encrypted = base64.encode(json.stringify(config))
                    print(json.stringify(config))
                    clipboard.set(encrypted)
                end),
                import = pui.button('aa', 'other', 'import', function()
                    local config = json.parse(base64.decode(clipboard.get()))
                    self.config:load(config)
                end),
                default = pui.button('aa', 'other', 'default config'),
            };
            local global = {}; do
                global.master = self.groups.angles:checkbox('global master');
                global.logs = self.groups.angles:checkbox('hit logging');
                global.fast_ladder = self.groups.angles:checkbox('fast ladder');
                global.clantag = self.groups.angles:checkbox('clan tag');
                global.killsay = self.groups.angles:checkbox('kill say');

                global.breaker = self.groups.angles:multiselect('animation breakers', { 'on ground', 'in air', 'other' });
                global.ground = self.groups.angles:combobox('ground',
                    { 'static', 'jitter', 'forward walking', 'kangaroo' });
                global.air = self.groups.angles:combobox('air', { 'static', 'jitter', 'walking', 'kangaroo' });
                global.lean = self.groups.angles:slider('movelean', -1, 100, -1, true, '%', 1, {
                    [-1] = 'gs',
                    [0] = 'off',
                    [100] = 'max',
                });
            end
            self.global = global
            local visual = {}; do
                visual.accent = self.groups.angles:label('accent color');
                visual.color = self.groups.angles:color_picker('accent', 255, 255, 255, 255);

                visual.master = self.groups.angles:checkbox('visual master');
                visual.mark = self.groups.angles:combobox('watermark', { 'basic', 'gradient', 'modern' })
                visual.indicators = self.groups.angles:multiselect('indicators', { 'under crosshair', 'minimum damage' });
                visual.damage = self.groups.angles:checkbox('damage marker');
            end
            self.visual = visual
            local antiaim = {}; do
                antiaim.master = self.groups.angles:checkbox('antiaim master');
                antiaim.manuals = {
                    master = self.groups.other:checkbox('manual anti-aim'),
                    hotkeys = {
                        freestand = self.groups.other:hotkey('freestanding'),
                        left = self.groups.other:hotkey('manual left'),
                        right = self.groups.other:hotkey('manual right'),
                        forward = self.groups.other:hotkey('manual forward'),
                        edgeyaw = self.groups.other:hotkey('edge yaw'),
                    },
                };
                antiaim.setting = self.groups.angles:combobox('current setting', { 'basic', 'defensive' });
                antiaim.state = self.groups.angles:combobox('current state', self.constants.states[1]);
            end;
            self.antiaim = antiaim

            local builder = {}; do
                for i, id in ipairs(self.constants.states[1]) do
                    local name = self.constants.states[3][i]
                    builder[id] = {}
                    local aa = builder[id]
                    if i > 1 then
                        aa.enable = self.groups.angles:checkbox('enable' .. name);
                    end
                    aa.yaw = self.groups.angles:combobox('yaw' .. name, { 'static', 'l/r', 'x-way' });
                    aa.static = self.groups.angles:slider('static' .. name, -180, 180, 0, true, '°');

                    aa.left = self.groups.angles:slider('left' .. name, -180, 180, 0, true, '°');
                    aa.right = self.groups.angles:slider('right' .. name, -180, 180, 0, true, '°');

                    aa.way = self.groups.angles:slider('ways' .. name, 3, 7, 3, true, 'w')
                    aa.ways = {}; do
                        for w = 1, 7 do
                            aa.ways[w] = self.groups.angles:slider('way ' .. w .. name, -180, 180, 0, true, '°')
                        end
                    end
                    aa.jitter = self.groups.angles:combobox('yaw jitter' .. name, { 'off', 'offset', 'center' });
                    aa.range = self.groups.angles:slider('jitter range' .. name, -180, 180, 0, true, '°')
                    aa.randomize = self.groups.angles:slider('randomize' .. name, -180, 180, 0, true, '°')
                    aa.desync = self.groups.angles:combobox('desync' .. name, { 'off', 'static', 'jitter' });
                    aa.amount = self.groups.angles:slider('fake amount' .. name, -180, 180, 0, true, '°')

                    aa.delay = self.groups.angles:slider('delay' .. name, 1, 8, 1, true, 't', 1, {
                        [1] = 'jitter',
                    })
                end
            end;
            local defensive = {}; do
                for i, id in ipairs(self.constants.states[1]) do
                    local name = self.constants.states[3][i]
                    defensive[id] = {}
                    local aa = defensive[id]
                    aa.force = self.groups.angles:checkbox('force defensive' .. name);
                    aa.enable = self.groups.angles:checkbox('!enable' .. name);
                    aa.pitch = self.groups.angles:combobox('!pitch' .. name, { 'static', 'randomized', 'spinable' })
                    aa.pitch_static = self.groups.angles:slider('!static pitch' .. name, -89, 89, 0)
                    aa.pitch_start = self.groups.angles:slider('!start pitch' .. name, -89, 89, 0)
                    aa.pitch_end = self.groups.angles:slider('!end pitch' .. name, -89, 89, 0)
                    aa.pitch_spin = self.groups.angles:slider('!pitch spin' .. name, 0, 89)
                    aa.pitch_speed = self.groups.angles:slider('!pitch speed' .. name, -180, 180, 0)
                    aa.yaw = self.groups.angles:combobox('!yaw' .. name, { 'static', 'l/r', 'x-way' });
                    aa.static = self.groups.angles:slider('!static' .. name, -180, 180, 0, true, '°');

                    aa.left = self.groups.angles:slider('!left' .. name, -180, 180, 0, true, '°');
                    aa.right = self.groups.angles:slider('!right' .. name, -180, 180, 0, true, '°');

                    aa.way = self.groups.angles:slider('!ways' .. name, 3, 7, 3, true, 'w')
                    aa.ways = {}; do
                        for w = 1, 7 do
                            aa.ways[w] = self.groups.angles:slider('!way ' .. w .. name, -180, 180, 0, true, '°')
                        end
                    end
                    aa.jitter = self.groups.angles:combobox('!yaw jitter' .. name, { 'off', 'offset', 'center' });
                    aa.range = self.groups.angles:slider('!jitter range' .. name, -180, 180, 0, true, '°')
                    aa.randomize = self.groups.angles:slider('!randomize' .. name, -180, 180, 0, true, '°')

                    aa.spin = self.groups.angles:checkbox('!spin' .. name)
                    aa.spinrange = self.groups.angles:slider('!spin range', 0, 180, 0)
                    aa.spinspeed = self.groups.angles:slider('!spin speed', 0, 180, 0)

                    aa.desync = self.groups.angles:combobox('!desync' .. name, { 'off', 'static', 'jitter' });
                    aa.amount = self.groups.angles:slider('!fake amount' .. name, -180, 180, 0, true, '°')

                    aa.delay = self.groups.angles:slider('!delay' .. name, 1, 8, 1, true, 't', 1, {
                        [1] = 'jitter',
                    })
                end
            end;
            self.builder = { builder = builder, defensive = defensive }
            self.config = pui.setup({ self.global, self.visual, self.antiaim, self.builder.builder, self.builder
                .defensive })
        end,
        visibility = function(self)
            for i, element in pairs(self.refs.fakelag) do
                element:set_visible(false);
            end;
            client.set_event_callback('paint_ui', function()
                for i, element in pairs(self.configs) do
                    element:set_visible(self.tab.value == 1)
                end

                self.refs.misc.slowmotion:set_visible(self.tab.value == 4);
                self.refs.misc.legs:set_visible(self.tab.value == 4);
                self.refs.rage.onshot:set_visible(self.tab.value == 4);
                for i, element in pairs(self.refs.antiaim) do
                    element:set_visible(self.tab.value == 4);
                end;
                self.global.master:set_visible(self.tab.value == 1)
                self.global.logs:set_visible(self.tab.value == 1 and self.global.master:get())
                self.global.fast_ladder:set_visible(self.tab.value == 1 and self.global.master:get())
                self.global.clantag:set_visible(self.tab.value == 1 and self.global.master:get())
                self.global.killsay:set_visible(self.tab.value == 1 and self.global.master:get())
                self.global.breaker:set_visible(self.tab.value == 1 and self.global.master:get())

                self.global.ground:set_visible(self.tab.value == 1 and self.global.master:get() and
                    self.global.breaker:get('on ground'))
                self.global.air:set_visible(self.tab.value == 1 and self.global.master:get() and
                    self.global.breaker:get('in air'))
                self.global.lean:set_visible(self.tab.value == 1 and self.global.master:get() and
                    self.global.breaker:get('other'))


                self.antiaim.master:set_visible(self.tab.value == 2);
                self.antiaim.manuals.master:set_visible(self.tab.value == 2 and self.antiaim.master:get());
                for i, element in pairs(self.antiaim.manuals.hotkeys) do
                    element:set_visible(self.tab.value == 2 and self.antiaim.manuals.master:get() and
                        self.antiaim.master:get())
                end

                self.antiaim.setting:set_visible(self.tab.value == 2 and self.antiaim.master:get());
                self.antiaim.state:set_visible(self.tab.value == 2 and self.antiaim.master:get());

                for i, name in ipairs(self.constants.states[1]) do
                    local builder = self.builder.builder[name]
                    local visible = i == 1 and true or builder.enable:get()
                    local check = self.tab.value == 2 and self.antiaim.master:get() and
                        self.antiaim.state:get() == self.constants.states[1][i] and self.antiaim.setting:get() == 'basic'
                    if i > 1 then
                        builder.enable:set_visible(check)
                    end
                    builder.yaw:set_visible(check and visible)

                    builder.static:set_visible(check and visible and builder.yaw:get() == 'static')

                    builder.left:set_visible(check and visible and builder.yaw:get() == 'l/r')
                    builder.right:set_visible(check and visible and builder.yaw:get() == 'l/r')

                    builder.way:set_visible(check and visible and builder.yaw:get() == 'x-way')
                    for w = 1, 7 do
                        builder.ways[w]:set_visible(check and visible and builder.yaw:get() == 'x-way' and
                            builder.way:get() >= w)
                    end

                    builder.jitter:set_visible(check and visible)
                    builder.range:set_visible(check and visible and builder.jitter:get() ~= 'off')
                    builder.randomize:set_visible(check and visible and builder.jitter:get() ~= 'off')

                    builder.desync:set_visible(check and visible);
                    builder.amount:set_visible(check and visible and builder.desync:get() ~= 'off')
                    builder.delay:set_visible(check and visible)

                    builder = self.builder.defensive[name]
                    local visible = builder.enable:get()
                    local check = self.tab.value == 2 and self.antiaim.master:get() and
                        self.antiaim.state:get() == self.constants.states[1][i] and
                        self.antiaim.setting:get() == 'defensive'
                    builder.enable:set_visible(check)
                    builder.yaw:set_visible(check and visible)
                    builder.pitch:set_visible(check and visible)
                    builder.pitch_static:set_visible(check and visible and builder.pitch:get() == 'static')

                    builder.pitch_start:set_visible(check and visible and builder.pitch:get() == 'randomized')
                    builder.pitch_end:set_visible(check and visible and builder.pitch:get() == 'randomized')
                    builder.pitch_speed:set_visible(check and visible and builder.pitch:get() == 'spinable')
                    builder.pitch_spin:set_visible(check and visible and builder.pitch:get() == 'spinable')
                    builder.force:set_visible(check)
                    builder.static:set_visible(check and visible and builder.yaw:get() == 'static')

                    builder.left:set_visible(check and visible and builder.yaw:get() == 'l/r')
                    builder.right:set_visible(check and visible and builder.yaw:get() == 'l/r')

                    builder.way:set_visible(check and visible and builder.yaw:get() == 'x-way')
                    for w = 1, 7 do
                        builder.ways[w]:set_visible(check and visible and builder.yaw:get() == 'x-way' and
                            builder.way:get() >= w)
                    end

                    builder.jitter:set_visible(check and visible)
                    builder.range:set_visible(check and visible and builder.jitter:get() ~= 'off')
                    builder.randomize:set_visible(check and visible and builder.jitter:get() ~= 'off')

                    builder.spin:set_visible(check and visible)
                    builder.spinrange:set_visible(check and visible and builder.spin:get())
                    builder.spinspeed:set_visible(check and visible and builder.spin:get())

                    builder.desync:set_visible(check and visible);
                    builder.amount:set_visible(check and visible and builder.desync:get() ~= 'off')
                    builder.delay:set_visible(check and visible)
                end

                self.visual.master:set_visible(self.tab.value == 3)
                self.visual.accent:set_visible(self.tab.value == 3)
                self.visual.color:set_visible(self.tab.value == 3)
                self.visual.indicators:set_visible(self.tab.value == 3 and self.visual.master:get())
                self.visual.mark:set_visible(self.tab.value == 3 and self.visual.master:get())
                self.visual.damage:set_visible(self.tab.value == 3 and self.visual.master:get())
            end)
        end,
    }
    :struct 'updates' {
        me = {},
        call = function(self)
            client.set_event_callback('paint', function()
                self.me.player = entity.get_local_player();
                self.me.valid = entity.is_alive(self.me.player)
            end)
        end
    }
    :struct 'render' {
        screen = { client.screen_size() },
        setup = function(self)
            local x = self.screen[1] / 2;
            local y = self.screen[2] / 2;
            local r, g, b, a
            self.damage = 0;
            self.indicators = {}; do
                self.indicators.scoped = self.functions.animation:create(0)
                self.indicators.cross = self.functions.animation:create(0)
                self.indicators.dmg = self.functions.animation:create(0)
                self.indicators.list = {
                    {
                        name = 'doubletap',
                        get = function()
                            return ({ self.menu.refs.rage.doubletap:get_hotkey() })[1]
                        end,
                        anim = self.functions.animation:create(0),
                        sub = '',
                    },
                    {
                        name = 'hideshots',
                        get = function()
                            return ({ self.menu.refs.rage.onshot:get_hotkey() })[1] and
                                not ({ self.menu.refs.rage.doubletap:get_hotkey() })[1]
                        end,
                        anim = self.functions.animation:create(0),
                        sub = '',
                    },
                    {
                        name = 'damage',
                        get = function()
                            return ({ self.menu.refs.rage.minimumdamage[1]:get_hotkey() })[1]
                        end,
                        anim = self.functions.animation:create(0),
                        sub = '',
                    },
                    {
                        name = 'bodyaim',
                        get = function()
                            return ({ self.menu.refs.rage.bodyaim:get() })[1] -- люблю скит
                        end,
                        anim = self.functions.animation:create(0),
                        sub = '',
                    },
                    {
                        name = 'idealtick',
                        get = function()
                            return ({ self.menu.refs.rage.quickpeek:get_hotkey() })[1] and
                                ({ self.menu.refs.antiaim.freestanding:get_hotkey() })[1]
                        end,
                        anim = self.functions.animation:create(0),
                        sub = '',
                    },
                }
                self.indicators.crosshair = function()
                    r, g, b, a = self.menu.visual.color:get()
                    self.indicators.cross(.07,
                        self.menu.visual.master:get() and self.menu.visual.indicators:get('under crosshair') and
                        self.updates.me.valid)
                    if self.indicators.cross.value < .01 then return end
                    self.indicators.scoped(.07, entity.get_prop(self.updates.me.player, 'm_bIsScoped'))
                    local x_add = 35 * self.indicators.scoped.value * self.indicators.cross.value

                    renderer.text(x + x_add, y + 20, r, g, b, 255 * self.indicators.cross.value, 'cd', nil,
                        'night.project')
                        renderer.text(x + x_add, y + 10, r, g, b, 255 * self.indicators.cross.value, 'cd', nil,
                        ' ₊‧.°.⋆✦⋆.°.₊  ')
                    local y_add = 0
                    for i, element in ipairs(self.indicators.list) do
                        element.anim(.07, element.get());
                        element.sub = string.sub(element.name, 1, #element.name * element.anim.value)
                        element.scope = (renderer.measure_text('cd', element.sub) / 2 + 4) * self.indicators.scoped
                            .value *
                            self.indicators.cross.value
                        renderer.text(x + element.scope, y + 30 + y_add, r, g, b,
                            255 * element.anim.value * self.indicators.cross.value, 'cd', nil, element.sub)
                        y_add = y_add + 10 * element.anim.value
                    end
                end
                self.indicators.max_dmg = self.functions.animation:create(0)
                self.value_dmg = 0

                self.clamp = function(value, minimum, maximum)
                    assert(value and minimum and maximum, '')
                    if minimum > maximum then minimum, maximum = maximum, minimum end
                    return math.max(minimum, math.min(maximum, value))
                end

                self.lerping = function(a, b, w)
                    return a + (b - a) * w
                end

                self.lerp = function(start, enp, time)
                    time = time or 0.005
                    time = self.clamp(globals.absoluteframetime() * time * 175.0, 0.01, 1.0)
                    local a = self.lerping(start, enp, time)
                    if enp == 0.0 and a < 0.02 and a > -0.02 then
                        a = 0.0
                    elseif enp == 1.0 and a < 1.01 and a > 0.99 then
                        a = 1.0
                    end
                    return a
                end
                self.indicators.damage = function()
                    self.indicators.dmg(.07,
                        self.menu.visual.master:get() and self.menu.visual.indicators:get('minimum damage') and
                        self.updates.me.valid)
                    if self.indicators.dmg.value < .01 then
                        self.value_dmg = self.lerp(self.value_dmg, 1, 0.06)
                    elseif ({ self.menu.refs.rage.minimumdamage[1]:get_hotkey() })[1] then
                        self.value_dmg = self.lerp(self.value_dmg, 1, 0.06)
                    else
                        self.value_dmg = self.lerp(self.value_dmg, 0, 0.06)
                    end
                    self.value_dmg = self.lerp(self.value_dmg,
                    ({ self.menu.refs.rage.minimumdamage[1]:get_hotkey() })[1] and
                    self.menu.refs.rage.minimumdamage[2].value or self.menu.refs.rage.damage:get() + 0.5, 0.06)
                    local value = ({ self.menu.refs.rage.minimumdamage[1]:get_hotkey() })[1] and
                        self.menu.refs.rage.minimumdamage[2].value or self.menu.refs.rage.damage:get()
                    if self.value_dmg > 100 then
                        self.value_dmg = '+' .. math.floor(self.value_dmg - 100)
                    elseif self.value_dmg == 0 then
                        self.value_dmg = 'auto'
                    else
                        self.value_dmg = math.floor(self.value_dmg)
                    end
                    renderer.text(x + 5, y - 15, r, g, b, 255 * self.indicators.dmg.value, 'd', nil, self.value_dmg)
                end
            end
            self.name = panorama.open().MyPersonaAPI.GetName()
            self.watermark = function()
                if self.menu.visual.mark:get() == 'basic' then
                    renderer.text(x, self.screen[2] - 15, r, g, b, 200, 'cb', nil, 'night.project')
                end
                if self.menu.visual.mark:get() == 'gradient' then
                    local text = self.functions.render.gradient_text('N I G H T', globals.curtime(), r, g, b, 255, 155,
                        155, 155, 200)
                    local tx, ty = renderer.measure_text('cd',
                        string.format('%s\a%s %s', text, self.functions.render.to_hex(r, g, b, 200), '[DEV]'))
                    renderer.text(self.screen[1] - tx / 2 - 1840, y - 10, r, g, b, 200, 'cd', nil,
                        string.format('%s\a%s %s', text, self.functions.render.to_hex(r, g, b, 200), '[DEV]'))
                end
                if self.menu.visual.mark:get() == 'modern' then
                    local png = images.load_png(readfile('night.png'))
                    local text = self.functions.render.gradient_text('beta', globals.realtime(), r, g, b, 255, 155,
                        155, 155, 200):upper()
                    png:draw(15, y + 15, 25, 25, r, g, b, alpha)
                    renderer.text(45, y + 20, 255, 255, 255, 200, '-', nil,
                        string.format('night.project [%s\aFFFFFFFF]', text):upper())
                    renderer.text(45, y + 28, 255, 255, 255, 200, '-', nil, string.format('user: %s', self.name):upper())
                end
            end
            function self.getbuild() return "beta" end

            function self.rgba(r, g, b, a, ...) return ("\a%x%x%x%x"):format(r, g, b, a) .. ... end

            local w, h = client.screen_size()
            local alpha = 69
            local toggled = false
            client.set_event_callback("paint_ui", function()
                local png = images.load_png(readfile('night.png'))
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
                    renderer.gradient(0, 0, w, h, 0, 0, 0, alpha, 0, 0, 0, alpha, true)
                    renderer.text(x, y - 200, r, g, b, alpha, 'cd+', nil, 'night: 2024 - ∞ ')
                    png:draw(x - 25, y - 200 + 25, 50, 50, r, g, b, alpha)
                end
            end)
            self.damages = {}
            client.set_event_callback('player_hurt', function(e)
                if not self.menu.visual.master:get() then return end
                if not self.menu.visual.damage:get() then return end
                local userid, attacker, damage, health = e.userid, e.attacker, e.dmg_health, e.health
                if userid == nil or attacker == nil or damage == nil then
                    return
                end

                local player = client.userid_to_entindex(userid)
                local x, y, z = entity.get_prop(player, "m_vecOrigin")
                if x == nil or y == nil or z == nil then
                    return
                end
                local voZ = entity.get_prop(player, "m_vecViewOffset[2]")

                table.insert(self.damages,
                    { damage, globals.realtime(), x, y, z + voZ, e, alpha = self.functions.animation:create(0) })
            end)
            self.render_damage = function(ctx)
                if not self.menu.visual.master:get() then return end
                if not self.menu.visual.damage:get() then
                    return
                end

                self.damages_new = {}
                local max_time_delta = 6 / 2
                local speed = 4 / 3
                local realtime = globals.realtime()
                local max_time = realtime - max_time_delta / 2

                for i = 1, #self.damages do
                    local damage_indicator_display = self.damages[i]
                    local damage, time, x, y, z, e = damage_indicator_display[1], damage_indicator_display[2],
                        damage_indicator_display[3], damage_indicator_display[4], damage_indicator_display[5],
                        damage_indicator_display[6]
                    local r, g, b, a = 255, 255, 255, 255
                    if time > max_time then
                        local sx, sy = client.world_to_screen(ctx, x, y, z)

                        if (time - max_time) < 0.7 then
                            a = (time - max_time) / 0.7 * 255
                        end

                        if not (sx == nil or sy == nil) then
                            client.draw_text(ctx, sx, sy, r, g, b, a, "c-", 0, damage)
                        end
                        table.insert(self.damages_new, { damage, time, x, y, z, e })
                    end
                end

                self.damages = self.damages_new
            end
            client.set_event_callback('paint', function(ctx)
                self.indicators.crosshair()
                self.indicators.damage()
                self.watermark()
                self.render_damage(ctx)
            end)
        end
    }
    :struct 'builder' {
        state = 'global',
        defensive = false,
        tickbase_max = 0,
        command = 0,
        last_flick = 0,
        jitter = {
            process = false
        },
        in_air = false,
        air_tick = 0,
        setup = function(self)
            self.normalize = function(a, b)
                b = b or 180
                while a > b do
                    a = a - b * 2
                end

                while a < -b do
                    a = a + b * 2
                end

                return a
            end
            self.is_defensive = function()
                local me = self.updates.me.player
                local tickbase = entity.get_prop(me, 'm_nTickBase') or 0
                if math.abs(tickbase - self.tickbase_max) > 64 then
                    self.tickbase_max = 0
                end

                local defensive_ticks_left = 0;

                if tickbase > self.tickbase_max then
                    self.tickbase_max = tickbase
                elseif self.tickbase_max > tickbase then
                    defensive_ticks_left = math.min(14, math.max(0, self.tickbase_max - tickbase - 1))
                end
                return defensive_ticks_left > 1
            end;
            client.set_event_callback('net_update_end', function()
                self.defensive = self.is_defensive()
            end)
            self.do_jitter = function(slowed)
                slowed = type(slowed) == 'table' and slowed or { false, 1 }
                slowed = slowed[1] == true and slowed or { false, 1 }
                if self.command - self.last_flick >= slowed[2] then
                    self.jitter.process = not self.jitter.process
                    self.last_flick = self.command
                end
                return self.jitter.process
            end
            self.get_state = function(raw)
                local state = ''
                if not self.updates.me.valid then
                    state = 'global'
                    return
                end
                local ent = self.updates.me.player
                if ent == nil then
                    state = 'global'
                    return
                end
                local flag = entity.get_prop(ent, "m_fFlags")
                local vel = vector(entity.get_prop(ent, 'm_vecVelocity')):length2d() or 0
                local ducked = entity.get_prop(ent, 'm_bDucked') == 1
                if flag == 256 or flag == 262 then
                    self.in_air = true
                    self.air_tick = globals.tickcount() + 3
                else
                    self.in_air = (self.air_tick > globals.tickcount()) and true or false
                end
                if vel > 5 and not self.in_air then
                    state = 'running'
                    if ({ self.menu.refs.misc.slowmotion:get_hotkey() })[1] then
                        state = 'walking'
                    end
                else
                    state = 'standing'
                end
                if self.in_air then
                    if ducked then
                        if self.menu.builder.builder['air-crouch'].enable:get() then
                            state = 'air-crouch'
                        else
                            state = 'air'
                        end
                    else
                        state = 'air'
                    end
                end
                if (ducked or self.menu.refs.misc.fakeduck:get()) and not self.in_air then
                    state = 'crouch'
                    if vel > 5 then
                        if self.menu.builder.builder['crouch-move'].enable:get() then
                            state = 'crouch-move'
                        end
                    end
                end
                return raw and state or
                    (self.menu.builder.builder[state].enable:get() or self.menu.builder.defensive[state].enable:get()) and
                    state or 'global'
            end;
            self.should_defensive = function()
                local state = self.get_state()
                local me = self.updates.me.player
                local tickbase = entity.get_prop(me, 'm_nTickBase') or 0
                local tickcount = globals.tickcount()
                local ready = (tickbase - tickcount) > 0 and false or true
                local should = ({ self.menu.refs.rage.onshot:get_hotkey() })[1] or
                ({ self.menu.refs.rage.doubletap:get_hotkey() })[1]
                return self.defensive and self.menu.builder.defensive[state].enable:get() and ready and should
            end
            self.get_builder = function()
                local state = self.get_state()
                return self.should_defensive() and self.menu.builder.defensive[state] or self.menu.builder.builder
                    [state]
            end
            self.create_yaw = function(slowed)
                local ctx = self.get_builder()
                local inverted
                local static = ctx.static:get()
                if ctx.yaw:get() == 'static' then
                    return static
                end
                if ctx.yaw:get() == 'l/r' then
                    inverted = self.do_jitter(slowed)
                    return (inverted and ctx.left:get() or ctx.right:get())
                end
                if ctx.yaw:get() == 'x-way' then
                    local way = (self.command % ctx.way:get()) + 1
                    return ctx.ways[way]:get()
                end
                return 0
            end
            self.create_fake = function(slowed)
                local ctx = self.get_builder()
                local NUM = ctx.amount:get()
                local inverted
                if ctx.desync:get() == 'off' then
                    return { 'Off', 0 }
                end
                if ctx.desync:get() == 'static' then
                    return { 'Static', NUM }
                end
                if ctx.desync:get() == 'jitter' then
                    inverted = self.do_jitter(slowed)
                    local dsy = NUM * (inverted and -1 or 1)
                    return { 'Static', dsy }
                end
                return { 'Off', 0 }
            end
            self.create_jitter = function(slowed)
                local ctx = self.get_builder()
                local inverted
                local random = client.random_int(-ctx.randomize:get(), ctx.randomize:get())
                if ctx.jitter:get() == 'off' then
                    return 0
                end
                if ctx.jitter:get() == 'center' then
                    inverted = self.do_jitter(slowed)
                    return (inverted and -ctx.range:get() / 2 or ctx.range:get() / 2) + random
                end
                if ctx.jitter:get() == 'offset' then
                    inverted = self.do_jitter(slowed)
                    return (inverted and 0 or ctx.range:get() / 2) + random
                end
                return 0
            end
            self.create_spin = function()
                if not self.defensive then return 0 end
                local state = self.get_state()
                if not self.menu.builder.defensive[state].enable:get() then return 0 end
                local ctx = self.menu.builder.defensive[state]
                local spin = ctx.spinrange:get() == 0 and 1 or ctx.spinrange:get()
                if ctx.spin:get() then
                    return self.normalize(globals.curtime() * ctx.spinspeed:get() * 5 % spin * 2) or 0
                else
                    return 0
                end
            end
            self.get_pitch = function()
                local state = self.get_state()
                local ctx = self.menu.builder.defensive[state]
                if not self.defensive or not ctx.enable:get() then
                    return 89
                end
                if ctx.pitch:get() == 'static' then
                    return ctx.pitch_static:get()
                end
                if ctx.pitch:get() == 'randomized' then
                    return client.random_int(ctx.pitch_start:get(), ctx.pitch_end:get())
                end
                if ctx.pitch:get() == 'spinable' then
                    local start = ctx.pitch_spin:get() == 0 and 1 or ctx.pitch_spin:get()
                    local pitch = self.normalize(globals.curtime() * ctx.pitch_speed:get() * 5 % start * 2,
                        start)
                    return pitch
                end
                return 89
            end
            self.left = false
            self.right = false
            self.forward = false
            self.manual = 0
            self.get_manual = function()
                if not self.menu.antiaim.manuals.master:get() then return 0 end
                local yaw = {
                    [1] = -90,
                    [2] = 90,
                    [3] = 180
                }
                local left = self.menu.antiaim.manuals.hotkeys.left:get()
                local right = self.menu.antiaim.manuals.hotkeys.right:get()
                local forward = self.menu.antiaim.manuals.hotkeys.forward:get()
                if left ~= self.left then
                    self.menu.antiaim.manuals.hotkeys.right:set(false)
                    if self.manual == 1 then
                        self.manual = 0
                    else
                        self.manual = 1
                    end
                end
                if right ~= self.right then
                    self.menu.antiaim.manuals.hotkeys.left:set(false)
                    if self.manual == 2 then
                        self.manual = 0
                    else
                        self.manual = 2
                    end
                end
                if forward ~= self.forward then
                    self.menu.antiaim.manuals.hotkeys.left:set(false)
                    self.menu.antiaim.manuals.hotkeys.right:set(false)
                    if self.manual == 3 then
                        self.manual = 0
                    else
                        self.manual = 3
                    end
                end
                self.left, self.right, self.forward = left, right, forward
                return yaw[self.manual] or 0
            end
            self.get_yaw = function(delay)
                local ctx = self.get_builder()
                return self.normalize(self.create_yaw({ delay, ctx.delay:get() }) +
                    self.create_jitter(delay) + (self.defensive and self.create_spin() or 0) + self.get_manual())
            end
            --[[
                        local defensive = {}; do
                for i, id in ipairs(self.constants.states[1]) do
                    local name = self.constants.states[3][i]
                    defensive[id] = {}
                    local aa = defensive[id]
                    aa.force = self.groups.angles:checkbox('force defensive' .. name);
                    aa.enable = self.groups.angles:checkbox('!enable' .. name);
                    aa.pitch = self.groups.angles:combobox('!pitch' .. name, { 'static', 'randomized', 'spinable' })
                    aa.pitch_static = self.groups.angles:slider('!static pitch' .. name, -89, 89, 0)
                    aa.pitch_start = self.groups.angles:slider('!start pitch' .. name, -89, 89, 0)
                    aa.pitch_end = self.groups.angles:slider('!end pitch' .. name, -89, 89, 0)
                    aa.pitch_speed = self.groups.angles:slider('!pitch speed' .. name, -180, 180, 0)
                    aa.yaw = self.groups.angles:combobox('!yaw' .. name, { 'static', 'l/r', 'x-way' });
                    aa.static = self.groups.angles:slider('!static' .. name, -180, 180, 0, true, '°');

                    aa.left = self.groups.angles:slider('!left' .. name, -180, 180, 0, true, '°');
                    aa.right = self.groups.angles:slider('!right' .. name, -180, 180, 0, true, '°');

                    aa.way = self.groups.angles:slider('!ways' .. name, 3, 7, 3, true, 'w')
                    aa.ways = {}; do
                        for w = 1, 7 do
                            aa.ways[w] = self.groups.angles:slider('!way ' .. w .. name, -180, 180, 0, true, '°')
                        end
                    end
                    aa.jitter = self.groups.angles:combobox('!yaw jitter' .. name, { 'off', 'offset', 'center' });
                    aa.range = self.groups.angles:slider('!jitter range' .. name, -180, 180, 0, true, '°')
                    aa.randomize = self.groups.angles:slider('!randomize' .. name, -180, 180, 0, true, '°')

                    aa.spin = self.groups.angles:checkbox('!spin' .. name)
                    aa.spinrange = self.groups.angles:slider('!spin range', 0, 180, 0)
                    aa.spinspeed = self.groups.angles:slider('!spin speed', 0, 180, 0)

                    aa.desync = self.groups.angles:combobox('!desync' .. name, { 'off', 'static', 'jitter' });
                    aa.amount = self.groups.angles:slider('!fake amount' .. name, -180, 180, 0, true, '°')

                    aa.delay = self.groups.angles:slider('!delay' .. name, 1, 8, 1, true, 't', 1, {
                        [1] = 'jitter',
                    })
                end
            local builder = {}; do
                for i, id in ipairs(self.constants.states[1]) do
                    local name = self.constants.states[3][i]
                    builder[id] = {}
                    local aa = builder[id]
                    if i > 1 then
                        aa.enable = self.groups.angles:checkbox('enable' .. name);
                    end
                    aa.yaw = self.groups.angles:combobox('yaw' .. name, { 'static', 'l/r', 'x-way' });
                    aa.static = self.groups.angles:slider('static' .. name, -180, 180, 0, true, '°');

                    aa.left = self.groups.angles:slider('left' .. name, -180, 180, 0, true, '°');
                    aa.right = self.groups.angles:slider('right' .. name, -180, 180, 0, true, '°');

                    aa.way = self.groups.angles:slider('ways' .. name, 3, 7, 3, true, 'w')
                    aa.ways = {}; do
                        for w = 1, 7 do
                            aa.ways[w] = self.groups.angles:slider('way ' .. w .. name, -180, 180, 0, true, '°')
                        end
                    end
                    aa.jitter = self.groups.angles:combobox('yaw jitter' .. name, { 'off', 'offset', 'center' });
                    aa.range = self.groups.angles:slider('jitter range' .. name, -180, 180, 0, true, '°')
                    aa.randomize = self.groups.angles:slider('randomize' .. name, -180, 180, 0, true, '°')
                    aa.desync = self.groups.angles:combobox('desync' .. name, { 'off', 'static', 'jitter' });
                    aa.amount = self.groups.angles:slider('fake amount' .. name, -180, 180, 0, true, '°')

                    aa.delay = self.groups.angles:slider('delay' .. name, 1, 8, 1, true, 't', 1, {
                        [1] = 'jitter',
                    })
                end]]
            client.set_event_callback('setup_command', function(cmd)
                if not self.menu.antiaim.master:get() then return end
                if cmd.chokedcommands == 0 then
                    self.command = self.command + 1
                end
                local ctx = self.get_builder()
                if ctx == nil then return end
                local state = self.get_state(true)
                local slowed = { (function()
                    return ctx.delay:get() ~= 1
                end)(), ctx.delay:get() }
                local yaw = self.get_yaw(slowed)
                local desync = self.create_fake(slowed)
                self.menu.refs.antiaim.add:override(yaw)
                self.menu.refs.antiaim.body:override(desync[1])
                self.menu.refs.antiaim.amount:override(desync[2])
                self.menu.refs.antiaim.jitter:override('Off')
                self.menu.refs.antiaim.freestandingbody:override(false)
                cmd.force_defensive = self.menu.builder.defensive[state].force:get()
                self.menu.refs.antiaim.pitch:set('Custom')
                self.menu.refs.antiaim.custom:set(self.get_pitch())
                self.menu.refs.antiaim.freestanding:set(self.menu.antiaim.manuals.master:get() and
                    self.menu.antiaim.manuals.hotkeys.freestand:get() and self.manual == 0)
                self.menu.refs.antiaim.edgeyaw:set(self.menu.antiaim.manuals.master:get() and
                    self.menu.antiaim.manuals.hotkeys.edgeyaw:get())
            end)
        end
    }
    :struct 'animbreaker' {
        init = function(self)
            self.set_pos = function(ent, int, value)
                return entity.set_prop(ent, 'm_flPoseParameter', int, value)
            end
            client.set_event_callback("pre_render", function()
                if not self.menu.global.master:get() then return end
                local me = self.updates.me.player
                if not me then return end
                local lp = ent.new(me)
                if not lp then return end
                local aero = lp:get_anim_overlay(6)
                local lean = lp:get_anim_overlay(12)
                local x_velocity = entity.get_prop(me, "m_vecVelocity[0]")
                if self.menu.global.breaker:get('on ground') then
                    if self.menu.global.ground:get() == 'static' then
                        self.set_pos(me, 0, 0)
                        self.menu.refs.misc.legs:override('Always slide')
                    end
                    if self.menu.global.ground:get() == 'jitter' then
                        self.set_pos(me, 0, globals.tickcount() % 4 > 1 and 0 or 1)
                        self.menu.refs.misc.legs:override('Always slide')
                    end
                    if self.menu.global.ground:get() == 'forward walking' then
                        self.set_pos(me, .5, 7)
                        self.menu.refs.misc.legs:override('Never slide')
                    end
                    if self.menu.global.ground:get() == 'kangaroo' then
                        self.set_pos(me, client.random_float(0, 1), 7)
                        self.menu.refs.misc.legs:override('Never slide')
                    end
                end
                if self.menu.global.breaker:get('in air') then
                    local cycle
                    do
                        cycle = globals.realtime() * 0.7 % 2

                        if cycle > 1 then
                            cycle = 1 - (cycle - 1)
                        end
                    end
                    if self.menu.global.air:get() == 'static' then
                        self.set_pos(me, 1, 6)
                    end
                    if self.menu.global.air:get() == 'jitter' then
                        self.set_pos(me, globals.tickcount() % 4 > 1 and 1 or 0, 6)
                    end
                    if self.menu.global.air:get() == 'kangaroo' then
                        self.set_pos(me, client.random_float(0, 1), 6)
                    end
                    if self.menu.global.air:get() == 'walking' then
                        local cycle
                        do
                            cycle = globals.realtime() * 0.7 % 2

                            if cycle > 1 then
                                cycle = 1 - (cycle - 1)
                            end
                        end
                        if math.abs(x_velocity) > 2 then
                            aero.weight = 1
                            if self.builder.in_air then
                                aero.cycle = cycle
                            end
                        end
                    end
                end

                if self.menu.global.breaker:get('other') then
                    if math.abs(x_velocity) > 2 then
                        lean.weight = self.menu.global.lean:get() / 100
                    end
                end
            end)
        end
    }
    :struct 'other' {
        --[[            local global = {}; do
                global.master = self.groups.angles:checkbox('global master');
                global.logs = self.groups.angles:multiselect('hit logging', { 'on screen', 'console', 'corner' });
                global.fast_ladder = self.groups.angles:checkbox('fast ladder');
                global.clantag = self.groups.angles:checkbox('clan tag');
                global.killsay = self.groups.angles:checkbox('kill say');

                global.breaker = self.groups.angles:multiselect('animation breakers', { 'on ground', 'in air', 'other' });
                global.ground = self.groups.angles:combobox('ground',
                    { 'static', 'jitter', 'forward walking', 'kangaroo' });
                global.air = self.groups.angles:combobox('air', { 'static', 'jitter', 'walking', 'kangaroo' });
                global.lean = self.groups.angles:slider('movelean', -1, 100, -1, true, '%', 1, {
                    [-1] = 'gs',
                    [0] = 'off',
                    [100] = 'max',
                });
                global.pitch = self.groups.angles:checkbox('pitch 0 on land');
            end
            self.global = global]]

        create = function(self)
            self.notify     = { logs = {} }
            self.notify.add = function(text)
                table.insert(self.notify.logs, 1, { text = text, time = globals.curtime() + 4, alpha = 0 })
            end
            self.tag        = {
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
            self.killsays   = {
                "1",
                "я твою маму резал шампуром который засунул в жепу твоего бати)))",
                "когда ты просишь сметану к борщу у мамы, она всегда добавляет мою сперму и ты даже это не замечаешь))",
                "когда тебе на твой нищий день рождения приносят торт который делала твоя мама, она добавляла туда 10мг моей спермы аххахах",
                "очередной клоп еденичкой отлетел)",
                "купи night lua и играй",
                "под медию санчеза запенил",
                "чурка без примо высерает мне что то?",
                "ты че хачела ахуела играть хвх",
                "уже время не для хвх, пора спатки в кроватки",
                "я заминировал твою маму 10 мг спермой, жди братика",
                "купи резолвер by хуйпачес",
                "1111111ыыыыы",
                "потею на хвх со скитом против примо ыыы",
                "math.random(idi nahui klop)",
                "111 ты че с кфг кизару?, не позорься купи кфг у bloor4",
            }
            client.set_event_callback('player_death', function(event)
                if not self.menu.global.master:get() then return end
                if not self.menu.global.killsay:get() then return end
                local attacker = client.userid_to_entindex(event.attacker)
                local userid = client.userid_to_entindex(event.userid)
                if not attacker or not userid then
                    return
                end
                if attacker == self.updates.me.player then
                    if userid ~= self.updates.me.player then
                        client.exec(string.format('say %s', self.killsays[math.random(#self.killsays)]))
                    end
                end
            end)
            client.set_event_callback("setup_command", function(e)
                if not self.menu.global.master:get() then return end
                if not self.menu.global.fast_ladder:get() then return end
                local pitch, yaw = client.camera_angles()
                if entity.get_prop(self.updates.me.player, "m_MoveType") == 9 then
                    e.yaw = math.floor(e.yaw + 0.5)
                    e.roll = 0
                    if e.forwardmove == 0 then
                        if e.sidemove ~= 0 then
                            e.pitch = 89
                            e.yaw = e.yaw + 180
                            if e.sidemove < 0 then
                                e.in_moveleft = 0
                                e.in_moveright = 1
                            end
                            if e.sidemove > 0 then
                                e.in_moveleft = 1
                                e.in_moveright = 0
                            end
                        end
                    end
                    if e.forwardmove > 0 then
                        if pitch < 45 then
                            e.pitch = 89
                            e.in_moveright = 1
                            e.in_moveleft = 0
                            e.in_forward = 0
                            e.in_back = 1
                            if e.sidemove == 0 then
                                e.yaw = e.yaw + 90
                            end
                            if e.sidemove < 0 then
                                e.yaw = e.yaw + 150
                            end
                            if e.sidemove > 0 then
                                e.yaw = e.yaw + 30
                            end
                        end
                    end

                    if e.forwardmove < 0 then
                        e.pitch = 89
                        e.in_moveleft = 1
                        e.in_moveright = 0
                        e.in_forward = 1
                        e.in_back = 0
                        if e.sidemove == 0 then
                            e.yaw = e.yaw + 90
                        end
                        if e.sidemove > 0 then
                            e.yaw = e.yaw + 150
                        end
                        if e.sidemove < 0 then
                            e.yaw = e.yaw + 30
                        end
                    end
                end
            end)
            client.set_event_callback("net_update_end", function(e)
                local local_player = self.updates.me.player
                if not local_player then return end
                local can_reset = true
                if self.menu.global.clantag:get() and self.menu.global.master:get() then
                    can_reset = false
                    local realtime = math.floor((globals.curtime()) * 2.5)
                    if old_time ~= realtime then
                        client.set_clan_tag(self.tag[realtime % #self.tag + 1])
                        old_time = realtime;
                    end
                else
                    can_reset = true
                    local realtime = math.floor((globals.curtime()) * 0)
                    if old_time ~= realtime then
                        if can_reset then
                            old_time = realtime;
                            client.set_clan_tag('')
                            can_reset = false
                        end
                    end
                end
            end)
            client.set_event_callback("aim_miss", function(e)
                if not self.menu.global.master:get() then return end
                local hitgroup_names = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg",
                    "right leg", "neck", "?", "gear" }
                local clr = self.functions.render.to_hex(255, 90, 90, 255)
                local text = string.format("missed \a%s%s \aFFFFFFFFin \a%s%s\aFFFFFFFF due to \a%s%s", clr,
                    entity.get_player_name(e.target), clr, hitgroup_names[e.hitgroup + 1], clr, e.reason)
                self.notify.add(text)
            end)
            client.set_event_callback("aim_hit", function(e)
                if not self.menu.global.master:get() then return end
                local hitgroup_names = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg",
                    "right leg", "neck", "?", "gear" };
                local clr = self.functions.render.to_hex(150, 200, 60, 255)
                local text = string.format(
                    "hit \a%s%s\aFFFFFFFF for \a%s%s\aFFFFFFFF in \a%s%s \aFFFFFFFF(%s remaining)",
                    clr, entity.get_player_name(e.target), clr, e.damage, clr, hitgroup_names[e.hitgroup + 1] or "?",
                    entity.get_prop(e.target, "m_iHealth"))
                self.notify.add(text)
            end)
            self.lerp = function(x, v, t)
                if type(x) == 'table' then
                    return self.lerp(x[1], v[1], t), self.lerp(x[2], v[2], t), self.lerp(x[3], v[3], t),
                        self.lerp(x[4], v[4], t)
                end

                local delta = v - x

                if type(delta) == 'number' then
                    if math.abs(delta) < 0.005 then
                        return v
                    end
                end

                return delta * t + x
            end
            local x = self.render.screen[1] / 2;
            local y = self.render.screen[2] / 2;
            client.set_event_callback('paint', function()
                if not self.menu.global.master:get() then return end
                if not self.menu.global.master:get() then return end
                if not self.menu.global.logs:get() then return end
                if not entity.get_local_player() then self.notify.logs = {} end
                local offset = 0
                for i, v in pairs(self.notify.logs) do
                    if v.time > globals.curtime() and i <= 6 then
                        v.alpha = self.lerp(v.alpha, 255, 0.1)
                    else
                        v.alpha = self.lerp(v.alpha, 0, 0.1)
                        if v.alpha < 1 then
                            table.remove(self.notify.logs, i)
                        end
                    end
                    renderer.text(x, y + 155 + offset, 255, 255, 255, v.alpha,
                        "c", 0, v.text)
                    offset = offset + 15 * (v.alpha / 255)
                end
            end)
        end


    }
    
ffi.cdef [[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);

    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct
    {
        char pad20[24];
        uint32_t m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        char pad20[8];
        float m_flCycle;
        void *m_pOwner;
        char pad_0038[ 4 ];
    } animation_layer_t;

    typedef struct
    {
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    } anim_state_t;
    typedef struct
    {
        char   pad0[0x14];             //0x0000
        bool        bProcessingMessages;    //0x0014
        bool        bShouldDelete;          //0x0015
        char   pad1[0x2];              //0x0016
        int         iOutSequenceNr;         //0x0018 last send outgoing sequence number
        int         iInSequenceNr;          //0x001C last received incoming sequence number
        int         iOutSequenceNrAck;      //0x0020 last received acknowledge outgoing sequence number
        int         iOutReliableState;      //0x0024 state of outgoing reliable data (0/1) flip flop used for loss detection
        int         iInReliableState;       //0x0028 state of incoming reliable data
        int         iChokedPackets;         //0x002C number of choked packets
    } INetChannel; // Size: 0x0444

    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
    typedef int BOOL;
    typedef long LONG;
    typedef unsigned long HWND;
    typedef struct{
        LONG x, y;
    }POINT, *LPPOINT;
    typedef unsigned long DWORD, *PDWORD, *LPDWORD;

    typedef struct {
        DWORD  nLength;
        void* lpSecurityDescriptor;
        BOOL   bInheritHandle;
    } SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;

    short GetAsyncKeyState(int vKey);
    typedef struct mask {
        char m_pDriverName[512];
        unsigned int m_VendorID;
        unsigned int m_DeviceID;
        unsigned int m_SubSysID;
        unsigned int m_Revision;
        int m_nDXSupportLevel;
        int m_nMinDXSupportLevel;
        int m_nMaxDXSupportLevel;
        unsigned int m_nDriverVersionHigh;
        unsigned int m_nDriverVersionLow;
        int64_t pad_0;
        union {
            int xuid;
            struct {
                int xuidlow;
                int xuidhigh;
            };
        };
        char name[128];
        int userid;
        char guid[33];
        unsigned int friendsid;
        char friendsname[128];
        bool fakeplayer;
        bool ishltv;
        unsigned int customfiles[4];
        unsigned char filesdownloaded;
    };
    typedef int(__thiscall* get_current_adapter_fn)(void*);
    typedef void(__thiscall* get_adapters_info_fn)(void*, int adapter, struct mask& info);
    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
    typedef long(__thiscall* get_file_time_t)(void* this, const char* pFileName, const char* pPathID);
]]

ffi.cdef 'int sleep(int);'
local security = {}; do
    security.hwid = function()
       local material_system = client.create_interface('materialsystem.dll', 'VMaterialSystem080')
       local material_interface = ffi.cast('void***', material_system)[0]
 
       local get_current_adapter = ffi.cast('get_current_adapter_fn', material_interface[25])
       local get_adapter_info = ffi.cast('get_adapters_info_fn', material_interface[26])
 
       local current_adapter = get_current_adapter(material_interface)
 
       local adapter_struct = ffi.new('struct mask')
       get_adapter_info(material_interface, current_adapter, adapter_struct)
 
       local driverName = tostring(ffi.string(adapter_struct['m_pDriverName']))
       local vendorId = tostring(adapter_struct['m_VendorID'])
       local deviceId = tostring(adapter_struct['m_DeviceID'])
       local class_ptr = ffi.typeof("void***")
       local rawfilesystem = client.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
       local filesystem = ffi.cast(class_ptr, rawfilesystem)
       local file_exists = ffi.cast("file_exists_t", filesystem[0][10])
       local get_file_time = ffi.cast("get_file_time_t", filesystem[0][13])
 
       local function bruteforce_directory()
          for i = 65, 90 do
             local directory = string.char(i) .. ":\\Windows\\Setup\\State\\State.ini"
 
             if (file_exists(filesystem, directory, "ROOT")) then
                return directory
             end
          end
          return nil
       end
 
       local directory = bruteforce_directory()
       local install_time = get_file_time(filesystem, directory, "ROOT")
       local hardwareID = install_time * 2
       local m_id = ((vendorId * deviceId) * 3) + hardwareID
       return m_id
    end
    security.process = function()
       http.get("https://raw.githubusercontent.com/th3bloor4/night-lua/refs/heads/main/gamesense_beta", function(c, r)
          if c then
             if string.find(r.body, tostring(security.hwid())) then
                ctx.menu:create()
                ctx.menu:visibility()
                ctx.functions:create()
                ctx.updates:call()
                ctx.render:setup()
                ctx.builder:setup()
                ctx.animbreaker:init()
                ctx.other:create()
             else
                client.log("Hello, your hwid not in database.\n Please create ticket and send hwid: " .. security.hwid())
             end
          end
       end)

    end
 end
 security:process()