-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

 local ffi = require 'ffi'

ffi.cdef [[
    typedef struct
    {
        float x;
        float y;
        float z;
    } Vector_t;
]]  

local pui = require("neverlose/pui")

local base64 = require 'neverlose/base64'
local clipboard = require 'neverlose/clipboard'
local inspect = require 'neverlose/inspect'
local gradient = require("neverlose/gradient")
local drag_system = require("neverlose/drag_system") 

local tweening do
    tweening = { }

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

        local this = { }

        this.clock = 0
        this.value = default or 0

        this.easings = easings_fn or function(t, b, c, d)
            return c * t / d + b
        end

        return setmetatable(this, mt)
    end
end

local neverlose = {
    rage = {
        main = {
            dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
            lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
            hs_opt = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
            hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
        }
    },
    aa = {
        angles = {
            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
            yaw = {
                mode = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
                offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
                base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
                hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
                stab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab")
            },
            yaw_modifier = {
                mode = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
                offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")
            },
            body_yaw = {
                switch = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
                left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
                right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
                options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options")
            },
            freestand = {
                switch = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
                yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
                body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")
            }
        },
        misc = {
            fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
            slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), -- neverlose.aa.misc.slowwalk:get()
            leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
        }
    },
    visuals = {
        world = {
            main = {
                scope = {
                    zoom_value = ui.find("Visuals", "World", "Main", "Override Zoom"),
                    scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
                }
            }
        }
    },
    misc = {
        main = {
            other = {
                fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
            }
        }
    }
}

local groups = {
    main = {
        information = pui.create('\a{Link Active}\f<house>', '\f<circle-info> Information'),
        configuration = pui.create('\a{Link Active}\f<house>', '\f<gear> Configuration')
    },
    angles = {
        angle = pui.create('\a{Link Active}\f<bars>', '\f<arrow-down-to-line> Angles', 1),
        builder = pui.create('\a{Link Active}\f<bars>', '\f<building> Set up', 2),
    },
    other = {
        visual = pui.create('\a{Link Active}\f<fingerprint>', '\f<paintbrush-fine> Visuals', 1),
        misc = pui.create('\a{Link Active}\f<fingerprint>', '\f<gear> Other', 2)
    }
}
local enums = {
    states = {
        'Stand',
        'Run',
        'Walk',
        'Duck',
        'Air',
        'Air Crouch',
        'Sneak'

    }
}

local BUILD = 'live'

local vars = { } do
    local home do
        vars.home = {}

        vars.home.username = groups.main.information:label("Welcome back again, \v" .. common.get_username() .. '\r')
        vars.home.build = groups.main.information:label( table.concat { "Your build is ", "\v ", BUILD, "\a", "ffffffc8", "." })
        
        vars.home.watermark = groups.main.information:list('Watermark \vPosition', {'Left', 'Right', 'Bottom'}) do
            vars.home.watermark_color = vars.home.watermark:color_picker('')
        end

    end

    local profile do
        vars.profile = {}

        vars.profile.list = groups.main.configuration:list('', {})
        vars.profile.input = groups.main.configuration:input('')


        local buttons = {
            ['load'] = {name = '\f<download>', tooltip = 'Load selected config.', style = false},
            ['import'] = {name = '\f<file-import>', tooltip = 'Import config from clipboard and load it.'},
            ['export'] = {name = '\f<file-export>', tooltip = 'Export current settings.'},
            ['save'] = {name = '\f<floppy-disk>', tooltip = 'Save/Create selected/new config'},
            ['delete'] = {name = '\v\f<trash>', tooltip = 'Delete selected config.'}
        }

        for index, button in pairs(buttons) do
            button.style = button.style ~= nil and button.style or true

            vars.profile[index] = groups.main.configuration:button(button.name, nil, button.style)
            vars.profile[index]:tooltip(button.tooltip)
        end
    end

    local angles do
        vars.angles = {}

        vars.angles.enable = groups.angles.angle:switch('\v\f<toggle-on>\r   Enable Angles')
        do
            vars.angles.enable:set_callback(function(self)

                self:name(string.format('%s Enable Angles', self.value and '\f<toggle-on>' or '\f<toggle-off>'))
            end)
        end

        vars.angles.anti_backstab = groups.angles.angle:switch('\v\f<knife-kitchen>\r Anti Backstab'):depend(vars.angles.enable)

        vars.angles.manual_yaw = groups.angles.angle:combo('\v\f<arrows-retweet>\r Manual Yaw', {'Disabled', 'Left', 'Right', 'Forward'}):depend(vars.angles.enable) do
            local list = vars.angles.manual_yaw
            local gear = list:create()

            list.static = gear:switch('Static Manuals'):depend(vars.angles.enable)
        end
        vars.angles.edge_yaw = groups.angles.angle:switch('\v\f<ruler>\r Edge Yaw'):depend(vars.angles.enable)

        vars.angles.freestanding = groups.angles.angle:switch('\v\f<fence>\r Freestanding'):depend(vars.angles.enable) do
            local list = vars.angles.freestanding
            local gear = list:create()

            list.disablers = gear:selectable('Disablers', enums.states):depend(vars.angles.enable, list)
            list.yaw = gear:switch('Disable Yaw Modifiers'):depend(vars.angles.enable, list)
            list.body = gear:switch('Body Freestanding'):depend(vars.angles.enable, list)
        end

        vars.angles.lag_options = groups.angles.angle:selectable('\aFFD700FF\f<bolt>\r Lag Options', enums.states):depend(vars.angles.enable)
        vars.angles.defensive = groups.angles.angle:switch('\aFFD700FF\f<bolt>\f<bolt>\r Defensive AA'):depend(vars.angles.enable) do
            local list = vars.angles.defensive
            local gear = list:create()

            vars.angles.defensive_states = gear:selectable('States', enums.states):depend(vars.angles.defensive)
            vars.angles.defensive_yaw = gear:combo('Yaw', {'Default', 'Spin', 'Sideways', 'Forward', 'Backward'}):depend(vars.angles.defensive)
            vars.angles.defensive_pitch = gear:combo('Pitch', {'Up', 'Down', 'Custom', 'Random'}):depend(vars.angles.defensive)
            vars.angles.defensive_pitch_val = gear:slider('Offset', -89, 89, 0):depend(vars.angles.defensive, {vars.angles.defensive_pitch, 'Custom'})
        end

        vars.angles.safe_head = groups.angles.angle:switch('\v\f<helmet-safety>\r Safe Head'):depend(vars.angles.enable)
    end


    local conditions do
        vars.conditions = {}
        vars.conditions.state = groups.angles.builder:combo(' Condition', enums.states):depend(vars.angles.enable)

        for i, state in next, enums.states do
            vars.conditions[state] = {}

            local group = groups.angles.builder
            local condition = vars.conditions.state

            local pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"):list()
            local yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):list()
            local yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"):list()

            local short = string.upper(state:sub(0, 1))

            vars.conditions[state].enabled = group:switch(string.format('Enable \v%s\r', state)):depend(vars.angles.enable, {condition, state})

            vars.conditions[state].pitch = group:combo(string.format('[\v%s\r] Pitch', short), pitch)
                :depend(vars.angles.enable, {condition, state}, vars.conditions[state].enabled)

                vars.conditions[state].yaw = group:combo(string.format('[\v%s\r] Yaw', short), yaw):depend(vars.angles.enable, {condition, state}, vars.conditions[state].enabled) do
                local gear = vars.conditions[state].yaw:create()

                vars.conditions[state].yaw_base = gear:combo('Base', {'Local View', 'At Target'})
                vars.conditions[state].yaw_mode = gear:combo('Type', {'Default', 'Double'}):depend({vars.conditions[state].yaw, 'Backward'})
                vars.conditions[state].yaw_offset = gear:slider('Offset', -180, 180, 0):depend({vars.conditions[state].yaw, 'Backward'}, {vars.conditions[state].yaw_mode, 'Default'})

                vars.conditions[state].yaw_left = gear:slider('Left', -180, 180, 0):depend({vars.conditions[state].yaw, 'Backward'}, {vars.conditions[state].yaw_mode, 'Double'})
                vars.conditions[state].yaw_right = gear:slider('Right', -180, 180, 0):depend({vars.conditions[state].yaw, 'Backward'}, {vars.conditions[state].yaw_mode, 'Double'})

                vars.conditions[state].yaw_delay = gear:switch('Delayed Switch'):depend({vars.conditions[state].yaw, 'Backward'}, {vars.conditions[state].yaw_mode, 'Double'})
                vars.conditions[state].yaw_delay_ticks = gear:slider('Ticks', 0, 12, 0):depend({vars.conditions[state].yaw, 'Backward'}, {vars.conditions[state].yaw_mode, 'Double'}, vars.conditions[state].yaw_delay)
            end

            vars.conditions[state].yaw_modifier = group:combo(string.format('[\v%s\r] Yaw Modifier', short), yaw_modifier):depend(vars.angles.enable, {condition, state}, vars.conditions[state].enabled) do
                local gear = vars.conditions[state].yaw_modifier:create()

                vars.conditions[state].yaw_modifier.offset = gear:slider('Offset', -180, 180, 0):depend({vars.conditions[state].yaw_modifier, 'Disabled', true})
            end

            vars.conditions[state].body = group:switch(string.format('[\v%s\r] Body Yaw', short)):depend(vars.angles.enable, {condition, state}, vars.conditions[state].enabled) do
                local gear = vars.conditions[state].body:create()
                local body = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"):list()

                vars.conditions[state].body_tweaks = gear:selectable('Options', body):depend(vars.angles.enable, {condition, state}, vars.conditions[state].enabled, vars.conditions[state].body)
                vars.conditions[state].body_left_limit = gear:slider('Left Limit', 0, 58, 0):depend(vars.angles.enable, {condition, state}, vars.conditions[state].enabled, vars.conditions[state].body)
                vars.conditions[state].body_right_limit = gear:slider('Right Limit', 0, 58, 0):depend(vars.angles.enable, {condition, state}, vars.conditions[state].enabled, vars.conditions[state].body)
            end
        end
    end

    local visuals do
        vars.visuals = { }

        vars.visuals.indication = groups.other.visual:switch('\v\f<palette>\r State Indication') do
            local gear = vars.visuals.indication:create()

            vars.visuals.indication_color = gear:color_picker('Color'):depend(vars.visuals.indication)
        end

        vars.visuals.manual_indication = groups.other.visual:switch('\v\f<left-right>\r Manual Indication') do
            local gear = vars.visuals.manual_indication:create()

            vars.visuals.manual_indication_distance = gear:slider('Distance', 0, 100, 0):depend(vars.visuals.manual_indication)
            vars.visuals.manual_indication_color = gear:color_picker('Color'):depend(vars.visuals.manual_indication)
        end

        vars.visuals.snap_lines = groups.other.visual:switch('\v\f<line>\r Snap Lines') do
            local gear = vars.visuals.snap_lines:create()

            vars.visuals.snap_lines_color = gear:color_picker('Color'):depend(vars.visuals.snap_lines)

        end


        vars.visuals.custom_scope = groups.other.visual:switch('\v\f<crosshairs>\r Custom Scope') do
            local gear = vars.visuals.custom_scope:create()

            vars.visuals.custom_scope_size = gear:slider('Size', 0, 300, 206):depend(vars.visuals.custom_scope)
            vars.visuals.custom_scope_gap =  gear:slider('Gap', 0, 300, 10):depend(vars.visuals.custom_scope)
            vars.visuals.custom_scope_color = gear:color_picker('Accent Color', color('868686FF')):depend(vars.visuals.custom_scope)
        end

        vars.visuals.minimum_damage = groups.other.visual:switch('\v\f<minimize>\r Minimum Damage Indicator') do
            local gear = vars.visuals.minimum_damage:create()

            vars.visuals.minimum_damage_x = gear:slider('x', 0, render.screen_size().x, 928):visibility(false)
            vars.visuals.minimum_damage_y = gear:slider('y', 0, render.screen_size().y, 508):visibility(false)
        end

        vars.visuals.velocity_warning = groups.other.visual:switch("\v\f<gauge-circle-bolt>\r Velocity Warning") do
            local gear = vars.visuals.velocity_warning:create()

            vars.visuals.velocity_warning_color = gear:color_picker("Accent Color"):depend(vars.visuals.velocity_warning)

            vars.visuals.velocity_warning_x = gear:slider('x', 0, render.screen_size().x, 345):visibility(true)
            vars.visuals.velocity_warning_y = gear:slider('y', 0, render.screen_size().y, 508):visibility(true)
        end

    end

    local other do
        vars.other = { }

        vars.other.logger = groups.other.misc:switch('\v\f<crosshairs>\r Aimbot Logger')
        vars.other.fake_latency = groups.other.misc:slider('\v\f<face-lying>\r Fake Latency', 0, 1000, 0)

        vars.other.avoid_collisions = groups.other.misc:switch('\v\f<block-brick>\r Avoid Collisions') do
            local gear = vars.other.avoid_collisions:create()

            vars.other.avoid_collisions_distance = gear:slider('Distance', 1, 10, 0):depend(list)
        end

        vars.other.aspect_ratio = groups.other.misc:switch('\v\f<percent>\r Aspect Ratio') do
            local gear = vars.other.aspect_ratio:create()

            vars.other.aspect_ratio_val = gear:slider('Value', 0, 200, 133, .01):depend(list)

            local ratios = {
                [177] = "16:9",
                [161] = "16:10",
                [150] = "3:2",
                [133] = "4:3",
                [125] = "5:4",
            }

            for key, value in pairs(ratios) do
                gear:button(tostring(value), function()
                    vars.other.aspect_ratio_val:set(key)
                end, true):depend(vars.other.aspect_ratio)
            end
        end

        vars.other.fall_damage = groups.other.misc:switch('\v\f<person-falling-burst>\r No Fall Damage') do
            vars.other.fall_damage:tooltip('Attempts to perform a jump bug when possible\n\nThis is 1:1 replica from \a9ACD32FFgamesense')
        end

        vars.other.fast_ladder = groups.other.misc:switch('\v\f<water-ladder>\r Fast Ladder') do
            vars.other.fast_ladder:tooltip('Abuses the ladder movement mechanic and makes you move faster.')

            local gear = vars.other.fast_ladder:create()

            vars.other.fast_ladder_mode = gear:selectable('Mode', {'Ascending', 'Descending'}):depend(vars.other.fast_ladder)
        end
    end
end

-- @region local player
local PLAYER_FLAGS = {
    FL_ONGROUND = bit.lshift(1, 0),
    FL_FROZEN   = bit.lshift(1, 5)
};

local localplayer = { };
do
    local MOVING_LIMIT = 1.1 * 3.3;
    local DUCK_PEEK_LIMIT = 0.45;

    local pre_flags = 0;
    local post_flags = 0;

    localplayer.flags = 0;
    localplayer.packets = 0;
    localplayer.packets_other = 0;
    localplayer.velocity = 0;

    localplayer.is_onground = false;
    localplayer.is_crouched = false;

    localplayer.is_moving = false;
    localplayer.is_landing = false;
    localplayer.is_airborne = false;



    function localplayer.pre_predict_command(e)
        local me = entity.get_local_player();
        pre_flags = me.m_fFlags;
    end

    function localplayer.predict_command(e)
        local me = entity.get_local_player();
        post_flags = me.m_fFlags;
    end

    function localplayer.net_update()
        local me = entity.get_local_player();
        if not me or me == nil or not me:is_alive() then return end

        local animstate = me:get_anim_state();
        if animstate == nil then return end

        local chokedcommands = globals.choked_commands;

        local m_fFlags = me.m_fFlags;
        localplayer.flags = m_fFlags;
        localplayer.velocity = me.m_vecVelocity:length2d()

        if chokedcommands == 0 then
            localplayer.packets = localplayer.packets + 1;
            localplayer.packets_other = localplayer.packets_other * -1
        end

        localplayer.is_onground = animstate.on_ground;
        localplayer.is_crouched = me.m_flDuckAmount > 0.45;

        localplayer.is_moving = localplayer.velocity > (1.1 * 3.3);
        localplayer.is_airborne = bit.band(pre_flags, post_flags, PLAYER_FLAGS.FL_ONGROUND) == 0;
    end

    events.createmove(localplayer.pre_predict_command);
    events.createmove_run(localplayer.predict_command);
    events.net_update_end(localplayer.net_update);

end

-- @region ctx | overriding aa values
local ctx = {} do
    local all = {}

    local references = neverlose.aa.angles

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
            print('[ctx] failed to index ', idx)
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
            print('[ctx] failed to index', idx)
        end
    end

    local used_layers = { }
    function ctx:new(name, layer)
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

    function ctx:on_cm()
        for name, reference in next, references do
            if type(reference) ~= 'table' then
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
    end; events.createmove:set(function()
        ctx:on_cm()
    end)

    function ctx:condition()
        local state = enums.states

        if localplayer.is_airborne then
            return enums.states[localplayer.is_crouched and 6 or 5]
        else
            if localplayer.is_moving then
                local slowwalk = neverlose.aa.misc.slowwalk:get()
                return enums.states[localplayer.is_crouched and 7 or (slowwalk and 3 or 2)]
            else
                return enums.states[localplayer.is_crouched and 4 or 1]
            end
        end

        return 'AFK'
    end
end

local antiaimbot = { } do
    local new_ctx = ctx:new('antiaimbot', 1)

    function antiaimbot:yaw(e)
        local me = entity.get_local_player()
        if not me or me == nil or not me:is_alive() then return end

        local inverted = (me.m_flPoseParameter[11] * 120 - 60) > 0
        local list = vars.conditions[ctx:condition()]

        local offset = list.yaw_offset.value

        if list.yaw_mode.value == 'Double' then
            if list.yaw_delay.value and list.yaw_delay_ticks.value ~= 0 then
                local delay = list.yaw_delay_ticks.value
                local target = delay * 2

                inverted = (localplayer.packets % target) >= delay

                rage.antiaim:inverter(inverted)

                offset = inverted and list.yaw_left.value or list.yaw_right.value
            else
                inverted = (me.m_flPoseParameter[11] * 120 - 60) > 0
                offset = inverted and list.yaw_left.value or list.yaw_right.value

                rage.antiaim:inverter(inverted)
            end

        end

        e.yaw.offset = offset
        e.yaw.mode = list.yaw.value
        e.yaw.base = list.yaw_base.value
    end

    function antiaimbot:yaw_modifier(e)
        local me = entity.get_local_player()
        if not me or me == nil or not me:is_alive() then return end

        local list = vars.conditions[ctx:condition()]

        e.yaw_modifier.mode = list.yaw_modifier.value
        e.yaw_modifier.offset = list.yaw_modifier.offset.value
    end

    function antiaimbot:body_yaw(e)
        local me = entity.get_local_player()
        if not me or me == nil or not me:is_alive() then return end

        local list = vars.conditions[ctx:condition()]

        e.body_yaw.switch = list.body.value
        e.body_yaw.left_limit = list.body_left_limit.value
        e.body_yaw.right_limit = list.body_right_limit.value
        e.body_yaw.options = list.body_tweaks.value
    end

    function antiaimbot:update(e)
        local list = vars.conditions[ctx:condition()]

        if list.enabled.value then
            new_ctx:tick()

            antiaimbot:yaw(new_ctx)
            antiaimbot:yaw_modifier(new_ctx)
            antiaimbot:body_yaw(new_ctx)

            new_ctx:run()
        end
    end
end

-- @region: lag options
local break_lc = { } do

    function break_lc:think(e)
        local state = ctx:condition();

        local should_override = false

        for key, value in pairs(vars.angles.lag_options.value) do
            if value == state then
                should_override = true
            end
        end

        neverlose.rage.main.lag_options:override(should_override and 'Always On' or nil)
        neverlose.rage.main.hs_opt:override(should_override and 'Break LC' or nil)
    end
end

-- @region: avoid backstab
local avoid_backstab = { } do
    function avoid_backstab:think(e)
        neverlose.aa.angles.yaw.stab:override(vars.angles.anti_backstab.value and true or nil)
    end
end

-- @region: yaw direction
local yaw_direction = { } do
    function yaw_direction.update(e)
        local list = vars.angles.freestanding
        local condition = ctx:condition()

        local should_disable = false

        for key, value in pairs(list.disablers.value) do
            if value == condition then
                should_disable = true
            end
        end

        neverlose.aa.angles.freestand.switch:override(not should_disable and list.value)
        neverlose.aa.angles.freestand.yaw_modifier:override(not should_disable and list.yaw.value)
        neverlose.aa.angles.freestand.body_freestanding:override(not should_disable and list.body.value)
    end
end

-- @region: manual direction
local manual_direction = { } do
    local new_ctx = ctx:new('manual_direction', 2)

    local directions = {
        ["Left"]    = -90,
        ["Right"]   = 90,
        ["Forward"] = 180
    };

    manual_direction.working = false

    function manual_direction.update()
        local value = vars.angles.manual_yaw.value
        local offset = directions[value]

        manual_direction.working = value ~= 'Disabled'

        new_ctx:tick()

        if offset and value ~= 'Disabled' then
            if vars.angles.manual_yaw.static:get() then
                new_ctx.body_yaw.options = {}
                new_ctx.body_yaw.left_limit = 60
                new_ctx.body_yaw.right_limit = 60
                new_ctx.yaw_modifier.mode = 'Disabled'

                rage.antiaim:inverter(false)
            end

            new_ctx.yaw.mode = 'Backward'
            new_ctx.yaw.offset = offset
            new_ctx.yaw.base = 'Local View'

            neverlose.aa.angles.freestand.switch:override(false)
        end

        new_ctx:run()
    end
end

-- @region: edge yaw
local edge_direction = { } do
    local max_distance = 25
    local max_traces = 10

    local max_delta_limit = 90

    local start_yaw = -180
    local end_yaw = 180

    local max_step = (end_yaw - start_yaw) / max_traces
    end_yaw = end_yaw - max_step

    local new_ctx = ctx:new('edge_direction', 3)

    function edge_direction.is_active()
        if not vars.angles.edge_yaw.value then
            return false
        end

        return true
    end

    function edge_direction.update(e)
        if not edge_direction.is_active() then return end
        local me = entity.get_local_player()
        if not me or me == nil or not me:is_alive() then return end

        local eye_pos = me:get_eye_position()
        local wall_angles = { }

        for i = start_yaw, end_yaw, max_step do
            local forward = vector():angles(0, i)
            local end_pos = eye_pos + forward * max_distance

            local trace = utils.trace_line(eye_pos, end_pos, 0xFFFFFFFF)

            if trace == nil or not trace:did_hit_world() then
                goto continue
            end

            wall_angles[ #wall_angles + 1 ] = i
            ::continue::
        end

        local max_angles = #wall_angles

        if max_angles == 0 then
            return
        end

        local best_angle

        if max_angles == 1 then
            best_angle = wall_angles[1]
        else
            best_angle = wall_angles[1] + 0.5 * (wall_angles[max_angles] - wall_angles[1]) -- @note just lerp to 0.5 of wall_angles[max_angles]
        end

        local new_angle = best_angle - e.view_angles.y

        if math.abs(math.normalize_yaw(new_angle)) > max_delta_limit then
            return
        end

        new_ctx:tick()
            new_ctx.yaw.offset = math.normalize_yaw(new_angle + 180)
            new_ctx.yaw.base = 'Local View'
        new_ctx:run()
    end
end

-- @region: defensive
local snap = { } do
    snap.tickbase = 0
    snap.working = false

    function snap.is_defensive(e)
        local me = entity.get_local_player()
        local tickbase = me.m_nTickBase

        if math.abs(tickbase - snap.tickbase) > 64 then
            snap.tickbase = 0
        end

        local defensive_ticks_left = 0

        if tickbase > snap.tickbase then
            snap.tickbase = tickbase
        elseif snap.tickbase > tickbase then
            defensive_ticks_left = math.min(14, math.max(0, snap.tickbase - tickbase - 1))
        end

        return defensive_ticks_left > 0
    end

    function snap.yaw()
        local yaw = vars.angles.defensive_yaw.value
        local offset = 0
        local add = 0

        if yaw == 'Spin' then
            offset = -180 + (globals.tickcount % 9) * 40 + math.random(-30, 30)
        elseif yaw == 'Forward' then
            offset = 180
        elseif yaw == 'Sideways' then
            offset = localplayer.packets_other * 90 + math.random(-30, 30)
        elseif yaw == 'Backward' then
            offset = 0
        end

        return offset
    end

    function snap.pitch()
        local pitch = vars.angles.defensive_pitch.value
        local offset = 0

        if pitch == 'Up' then
            offset = -89
        elseif pitch == 'Down' then
            offset = 89
        elseif pitch == 'Custom' then
            offset = vars.angles.defensive_pitch_val.value
        else
            offset = math.random(-89, 89)
        end

        return offset
    end

    function snap.update()
        local me = entity.get_local_player()

        if not me or me == nil then
            return
        end

        local wpn = me:get_player_weapon()

        if not wpn or wpn == nil then
            return
        end

        local wpn_info = wpn:get_weapon_info()

        local condition = ctx:condition()
        local should_work = false
        for key, state in pairs(vars.angles.defensive_states.value) do
            if state == condition and vars.angles.defensive.value and globals.absoluteframetime < globals.frametime and snap.is_defensive() and not manual_direction.working and wpn_info.weapon_type ~= 9 then
                should_work = true
            end
        end


        if should_work then
            neverlose.aa.angles.yaw.hidden:override(true)
            neverlose.rage.main.lag_options:override('Always On')
            neverlose.rage.main.hs_opt:override('Break LC')

            local yaw = snap.yaw()
            local pitch = snap.pitch()
    
            rage.antiaim:override_hidden_pitch(pitch)
    
            if yaw ~= 0 then
                rage.antiaim:override_hidden_yaw_offset(yaw)
            end
        end
    end
end

-- @region: safe head
local safe_head = { } do

    local new_ctx = ctx:new('safe_head', 5)

    function safe_head.update()
        local me = entity.get_local_player()

        if not me or me == nil then
            return
        end

        local threat = entity.get_threat()

        if not threat or threat == nil then
            return
        end

        if not vars.angles.safe_head:get() then
            return
        end

        local wpn = me:get_player_weapon()

        if not wpn or wpn == nil then
            return
        end

        local wpn_info = wpn:get_weapon_info()
        

        local damage, trace = utils.trace_bullet(threat, threat:get_origin(), me:get_hitbox_position(0), threat)

        if damage > 0 and wpn_info.weapon_type == 0 then
            new_ctx:tick()


            new_ctx.yaw.offset = 0
            new_ctx.yaw_modifier.mode = 'Disabled'

            new_ctx.body_yaw.left_limit = 0
            new_ctx.body_yaw.right_limit = 0
            rage.antiaim:inverter(false)
            

            new_ctx:run()
        end
    end
end

-- @region: indication
local indication = { } do
    local list = { global = tweening.new(), breathe = tweening.new() } do
        local INDICATORS_MAX_COUNT = 9

        for i = 1, INDICATORS_MAX_COUNT do
            list[i] = {
                alpha = tweening.new(),
                align = tweening.new(),
                width = tweening.new()
            }
        end
    end

    function indication.update()
        local me = entity.get_local_player()
        if not me or me == nil or not me:is_alive() then return end

        list.global(.2, vars.visuals.indication.value)

        if list.global.value <= 0 then
            return
        end

        local pulse = list.breathe(.5, globals.tickcount % 100 > 30)

        local position = render.screen_size() / 2
        local additional = 20
        local accent = vars.visuals.indication_color:get()

        local new_list = {
            {
                name = string.format('VETMO \a%s%s', (accent:alpha_modulate(pulse * 255)):to_hex(), BUILD:upper()),
                active = true,
                color = color()
            },
            {
                name = ctx:condition():upper(),
                active = true,
                color = color()
            },
            {
                name = 'DT',
                active = neverlose.rage.main.dt:get(),
                color = color()
            },
            {
                name = 'HIDE',
                active = neverlose.rage.main.hs:get(),
                color = color()
            }
        }



        for key, value in next, new_list do
            list[key].alpha(.1, value.active)
            list[key].align(.1, me.m_bIsScoped)

            local a = list[key].alpha.value
            local text = value.name; do
                local charge = rage.exploit:get()
                if text == "DT" or text == 'HIDE' then
                    if not value.active then
                        text = string.format("%s OFF", text);
                    elseif charge == 0 then
                        a = a * 0.3;
                        text = string.format("%s \aff4040ffWAITING", text);
                    elseif charge > 0 and charge < 1 then
                        text = string.format(
                                "%s \a%sCHARGING",
                                text,
                                (color(255, 64, 64):lerp(color(192, 255, 145), charge)):to_hex()
                        )
                    elseif snap.is_defensive() then
                        text = string.format("%s \a78ffffffACTIVE", text)
                    else
                        text = string.format("%s \ac0ff91ffREADY", text)
                    end
                end
            end

            local width = render.measure_text(2, "", text)

            list[key].width(.1, width.x)

            local max_width = width.x < list[key].width.value and math.clamp(list[key].width.value, width.x, list[key].width.value) or math.clamp(list[key].width.value, list[key].width.value, width.x)


            render.text(2, vector(position.x - max_width/2 * (1 - list[key].align.value), position.y + additional), value.color:alpha_modulate(value.color.a * a * list.global.value), '', text)

            additional = additional + 9 * list[key].alpha.value
        end
    end
end

-- @region: manuals
local manual_indication = { } do
    local font = render.load_font('Verdana', 23, 'ad')

    local list = {
        scoped = tweening.new(),
        alpha = tweening.new(),
        left = tweening.new(),
        right = tweening.new(),
        distance = tweening.new()
    }

    function manual_indication.update()
        local me = entity.get_local_player()
        if not me or me == nil or not me:is_alive() then return end

        local accent = vars.visuals.manual_indication_color:get()
        local position = render.screen_size() / 2
        local base = vars.angles.manual_yaw:get()

        list.distance(.1, vars.visuals.manual_indication_distance:get())
        list.alpha(.1, vars.visuals.manual_indication:get())
        list.left(.1, base == 'Left')
        list.right(.1, base == 'Right')
        list.scoped(.1, me.m_bIsScoped)

        if list.alpha.value <= 0 then
            return
        end

        local clr_left = accent do
            clr_left = clr_left:lerp(color(170, 170, 170, 150), 1 - list.left.value)
            clr_left = clr_left:alpha_modulate(clr_left.a * (1 - list.scoped.value))
        end

        local clr_right = accent do
            clr_right = clr_right:lerp(color(170, 170, 170, 150), 1 - list.right.value)
            clr_right = clr_right:alpha_modulate(clr_right.a * (1 - list.scoped.value))
        end



        render.text(font, position - vector(list.distance.value, 0), clr_left:alpha_modulate(clr_left.a * list.alpha.value),
            'c', '❰'
        )
        render.text(font, position + vector(list.distance.value, 0), clr_right:alpha_modulate(clr_right.a * list.alpha.value),
            'c', '❱'
        )
    end
end


-- @region: snap lines
local snap_lines = { } do

    function snap_lines.update()
        local me = entity.get_local_player()
        if not me or me == nil then return end

        if not vars.visuals.snap_lines:get() then
            return
        end

        local accent = vars.visuals.snap_lines_color:get()

        local threat = entity.get_threat(true)

        if threat and threat ~= nil then
            local from = (me:get_origin() + vector(0, 0, 40)):to_screen()
            local to = (threat:get_origin() + vector(0, 0, 40)):to_screen()

            render.line(from, to, accent)
        end
    end
end

-- @region: custom scope
local scope = { } do
    local alpha = tweening.new()
    local scoped = tweening.new()

    function scope.update()
        local lp = entity.get_local_player()
        if not lp or lp == nil or not lp:is_alive() or not globals.is_connected then return end
        

        alpha(.2, vars.visuals.custom_scope:get())

        if alpha.value <= 0.1 then
            neverlose.visuals.world.main.scope.scope_overlay:override()
            return
        end
        
        neverlose.visuals.world.main.scope.scope_overlay:override('Remove All')

        scoped(.1, lp.m_bIsScoped)

        local center = render.screen_size() / 2

        local size = vars.visuals.custom_scope_size:get()
        local gap = vars.visuals.custom_scope_gap:get()
        local accent = vars.visuals.custom_scope_color:get() do
            accent = accent:alpha_modulate(alpha.value * accent.a)
        end

        local lines = {
            {
                position_a = center - vector((size + gap) * scoped.value) + vector(1, 1),
                position_b = center - vector(gap * scoped.value) - vector(1, 0),
                top_left = color(0, 0, 0, 0),
                top_right = accent,
                bottom_left = color(0, 0, 0, 0),
                bottom_right = accent
            },
            {
                position_a = center + vector((size + gap) * scoped.value) + vector(1, 1),
                position_b = center + vector(gap * scoped.value) + vector(2, 0),
                top_left = color(0, 0, 0, 0),
                top_right = accent,
                bottom_left = color(0, 0, 0, 0),
                bottom_right = accent 
            },
            {
                position_a = center + vector(0, (size + gap) * scoped.value) + vector(1, 0),
                position_b = center + vector(0, gap * scoped.value) + vector(0, 2),
                top_left = color(0, 0, 0, 0),
                top_right = color(0, 0, 0, 0),
                bottom_left = accent,
                bottom_right = accent  
            },
            {
                position_a = center - vector(0, (size + gap) * scoped.value) + vector(1, 1),
                position_b = center - vector(0, gap * scoped.value) - vector(0, 1),
                top_left = color(0, 0, 0, 0),
                top_right = color(0, 0, 0, 0),
                bottom_left = accent,
                bottom_right = accent  
            }
        }

        for key, line in next, lines do

            render.gradient(
                line.position_a,
                line.position_b,
                line.top_left,
                line.top_right,
                line.bottom_left,
                line.bottom_right,
                0
            )
        end
    end 
end

-- @region: min.damage
local damage_indicator = { } do

    local function get_bind(name)
        local state = false
        local value = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()
        local binds = ui.get_binds()

        for i = 1, #binds do
            if binds[i].name == name and binds[i].active then
                state = true
                value = binds[i].value
            end
        end
        return {state, value}
    end

    local alpha = tweening.new()
    local activated = tweening.new()

    damage_indicator.render = drag_system.register({vars.visuals.minimum_damage_x, vars.visuals.minimum_damage_y}, vector(20, 20), "damage", function(self)
        alpha(.2, vars.visuals.minimum_damage:get())

        if alpha.value <= 0.1 then
            return
        end

        local center = render.screen_size() / 2

        local active, value = unpack(get_bind('Min. Damage'))

        if active or ui.get_alpha() > 0 then
            render.text(1, vector(self.position.x + 11, self.position.y + 10), color(255):alpha_modulate(alpha.value * 255), 'c', value)
        end

        activated(.2, ui.get_alpha() > 0)

        if activated.value > 0 then
            render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color():alpha_modulate(activated.value * 120 * alpha.value))
        end
    end)
end

-- @region: velocity warning
local velocity_warning = { } do

    local alpha = tweening.new()
    local holding = tweening.new()
    local hovering = tweening.new()

    local function render_bar(x, y, w, h, r, g, b, a, pct)

        render.rect(vector(x, y), vector(x + w, y + h), color(0, 0, 0, a), 2)
        render.rect(vector(x + 1, y + 1), vector(x + (w - 1) * pct, y + h - 1), color(r, g, b, a), 2)
        
    end

    local function lerp(a, b, t)
        return a + t * (b - a)
    end

    local modifier = tweening.new()
    
    velocity_warning.render = drag_system.register({vars.visuals.velocity_warning_x, vars.visuals.velocity_warning_x}, vector(200, 45), "velocity", function(self)
        local lp = entity.get_local_player()
        if not lp or lp == nil or not lp:is_alive() then return end

        modifier(.2, lp.m_flVelocityModifier)

        local modifier = modifier.value
        local menu_check = ui.get_alpha() > 0

        local alive_check = lp:is_alive()
        local velocity_check = modifier < 1.0

        
        local is_dragging = self.is_dragging

        local can_show_warning = vars.visuals.velocity_warning:get() and ((alive_check and velocity_check) or menu_check)

        alpha(.2, can_show_warning)
        holding(.2, (can_show_warning and is_dragging) and 0.5 or 1.0)

        if alpha.value <= 0 then
            return
        end

        if menu_check and (not velocity_check or not alive_check) then
            modifier = math.min(1, globals.tickcount % 200 / 150)
        end

        local flags = "d"
        local percent = (1 - modifier) * 100

        local accent = vars.visuals.velocity_warning_color:get()

        if modifier < 1.0 then
            accent.r = lerp(255, accent.r, modifier)
            accent.g = lerp(75, accent.g, modifier)
            accent.b = lerp(75, accent.b, modifier)
        end

        local pos = self.position:clone()
        local size = self.size:clone()

        local text = string.format("Max velocity was reduced by %d%%", percent)
        local text_size = render.measure_text(1, "s", text)

        render.text(1,

            vector(self.position.x + (self.size.x - text_size.x) * 0.5,
            self.position.y),
            color(255, 255, 255, 255 * alpha.value * holding.value),
            flags, text
        )

        pos.y = pos.y + text_size.y
        pos.y = pos.y + 5

        local bar_pos = pos:clone()
        local bar_size = vector(text_size.x + 28, 4)

        render_bar(bar_pos.x, bar_pos.y, bar_size.x, bar_size.y, accent.r, accent.g, accent.b, accent.a * alpha.value * holding.value, modifier)
        pos.y = pos.y + bar_size.y + 5

        if holding.value > 0 and menu_check then
            render.text(1,
                vector(pos.x + 50,
                pos.y),
                color(255, 255, 255, 255 * alpha.value * holding.value),
                flags, "Press M2 to center."
            )

            if common.is_button_down(0x02) and self:is_in_area(ui.get_mouse_position()) then
                pos.x = render.screen_size().x / 2 - self.size.x / 2
                self.position.x = render.screen_size().x / 2 - self.size.x / 2
            end
        end

    end)
end

-- @region: aimbot logger
local logger = { } do

    local hitgroups = {
        [0] = 'generic',
        'head', 'chest', 'stomach',
        'left arm', 'right arm',
        'left leg', 'right leg',
        'neck', 'generic', 'gear'
    }

    local weapon_verb = {
        ['taser'] = 'tasered'
    }

    function logger.player_hurt(e)
        local lp = entity.get_local_player()
        if not lp or lp == nil or not lp:is_alive() then return end

        if not vars.other.logger:get() then
            return
        end

        local userid = entity.get(e.userid, true)
        local attacker = entity.get(e.attacker, true)

        local verb = weapon_verb[ e.weapon ] or 'hit'

        if userid == lp then
            print_raw(table.concat({
                '\a{Link Active}huyanza.woof \aDEFAULT· ',
                verb,
                string.format(' by \a{Link Active}%s\aDEFAULT ', attacker:get_name()),
                'for ',
                string.format('\a{Link Active}%s \aDEFAULTdamage ', e.dmg_health or 0),
                string.format('(\a{Link Active}%d \aDEFAULThealth remaining)', e.health or 0)
            }, ''))

            print_dev(table.concat({
                verb,
                string.format(' by \a{Link Active}%s\aDEFAULT ', attacker:get_name()),
                'for ',
                string.format('\a{Link Active}%s \aDEFAULTdamage ', e.dmg_health or 0),
                string.format('(\a{Link Active}%d \aDEFAULThealth remaining)', e.health or 0)
            }, ''))
        end
    end

    function logger.on_hit(ctx)
        local lp = entity.get_local_player()
        if not lp or lp == nil or not lp:is_alive() then return end

        if ctx.state ~= nil then
            return
        end

        if ctx.damage == nil then
            return
        end

        if not vars.other.logger:get() then
            return
        end

        local gray = '\aA9A9A9FF'
        local link_active = '\a{Link Active}'

        local missmatched_dmg = ctx.damage ~= ctx.wanted_damage
        local missmatch_dmg = ctx.wanted_damage

        local missmatched_hgroup = ctx.hitgroup ~= ctx.wanted_hitgroup

        
        local wpn = lp:get_player_weapon()

        if not wpn or wpn == nil then
            return
        end
        
        local wpn_name = wpn:get_weapon_info().weapon_name do
            wpn_name = wpn_name:sub(8, #wpn_name)
        end

        local verb = weapon_verb[ wpn_name ] or 'hit'

        if ctx.target.m_iHealth <= 0 and weapon_verb[ wpn_name ] == nil then
            verb = 'killed'
        end

        local text = string.format(
            '%s %s in the %s for %s damage (hc: %s · history: %s)',

            verb,

            link_active .. ctx.target:get_name() .. '\aDEFAULT',
            gray .. (hitgroups [ ctx.hitgroup ] .. (missmatched_hgroup and string.format('/%s', hitgroups [ ctx.wanted_hitgroup ]) or '')) .. '\aDEFAULT',
            gray .. (ctx.damage .. (missmatched_dmg and string.format('(wanted: %s)', missmatch_dmg) or '')) .. '\aDEFAULT',
            gray .. ctx.hitchance .. '%\aDEFAULT',
            gray .. ctx.backtrack .. 't\aDEFAULT'         
        )

        print_raw('\a{Link Active}huyanza.woof \aDEFAULT· ' .. text)
        print_dev(text)
    end

    function logger.on_miss(ctx)
        local lp = entity.get_local_player()
        if not lp or lp == nil or not lp:is_alive() then return end

        if ctx.state == nil then
            return
        end

        if not vars.other.logger:get() then
            return
        end

        local gray = '\aA9A9A9FF'
        local link_active = '\a{Link Active}'


        local text = string.format(
            'missed %s\'s %s for %s damage due to %s (hc: %s · history: %st)',

            link_active .. ctx.target:get_name() .. '\aDEFAULT',
            gray .. hitgroups [ ctx.wanted_hitgroup ] .. '\aDEFAULT',
            gray .. ctx.wanted_damage .. '\aDEFAULT',
            gray .. ctx.state .. '\aDEFAULT',
            gray .. ctx.hitchance .. '%\aDEFAULT',
            gray .. ctx.backtrack .. '\aDEFAULT'
        )

        print_raw('\a{Link Active}huyanza.woof \aDEFAULT· ' .. text)
        print_dev(text)
    end
end

-- @region: fake latency
local latency = { } do
    local sv_maxunlag = cvar.sv_maxunlag

    function latency.update()
        sv_maxunlag:float(2)
        neverlose.misc.main.other.fake_latency:disabled(true)
        neverlose.misc.main.other.fake_latency:override(vars.other.fake_latency:get())
    end
end

-- @region: avoid collisions
local avoid_collisions = { } do
    local Collideable = utils.get_vfunc(3, "uintptr_t*(__thiscall*)(void*)")
    local ObbMins = utils.get_vfunc(1, "Vector_t*(__thiscall*)(void*)")
    local ObbMaxs = utils.get_vfunc(2, "Vector_t*(__thiscall*)(void*)")

    local function update_yaw(cmd, yaw, trace)
        if math.abs(trace.plane.normal.z) > 0.1 or trace.plane.normal:length() < 0.1 then
            return
        end

        local yaw_manipulation = math.atan2(trace.plane.normal.y, trace.plane.normal.x) * (360 / (math.pi * 2)) + (trace.plane.normal.y < trace.plane.normal.x and 180 or -180)
        local difference = math.normalize_yaw(yaw - yaw_manipulation)

        if math.abs(difference) > 90 then
            return
        end

        if (cmd.sidemove < -10 and difference < 0) then
            difference = 1
        elseif (cmd.sidemove > 10 and difference > 0) then
            difference = -1
        end


        yaw_manipulation = yaw_manipulation + (difference > 0 and 90 or -90)
        yaw_manipulation = math.normalize_yaw(90 - yaw_manipulation)

        cmd.move_yaw = math.normalize_yaw(90 - yaw_manipulation)
        cmd.in_speed = 0
        cmd.in_moveleft, cmd.in_moveright = 0, 0
        cmd.forwardmove = 450
        cmd.sidemove = 0
    end

    function avoid_collisions.update(e)
        if not vars.other.avoid_collisions:get() then
            return
        end

        if e.forwardmove < 0 then
            return
        end

        local player = entity.get_local_player()

        if not player then
            return
        end

        local valid = ctx:condition() == 'Air' or ctx:condition() == 'Air Crouch'

        if player.m_MoveType ~= 2 or not valid then
            return
        end


        local player_raw = player[0]
        local collideable = Collideable(player_raw)

        local obbMins = ObbMins(collideable)
        local obbMaxs = ObbMaxs(collideable)

        local vec_obbMins, vec_obbMaxs = vector(obbMins.x, obbMins.y, obbMins.z) * 0.85, vector(obbMaxs.x, obbMaxs.y, obbMaxs.z) * 0.85
        local camera_angles = vector(0, render.camera_angles().y)


        local origin = player:get_origin()

        local trace_end = origin + vector():angles(camera_angles.x, camera_angles.y) * (player.m_vecVelocity:length() * globals.tickinterval * vars.other.avoid_collisions_distance:get())

        local trace = utils.trace_hull(origin, trace_end, vec_obbMins, vec_obbMaxs, entity.get_players(false, false), 33636363, 0)

        if trace.entity == nil or bit.band(trace.contents, 0x20000000) ~= 0 then
            return
        end

        update_yaw(e, camera_angles.y, trace)
    end
end

-- @region aspect ratio
local aspect_ratio = { } do
    local r_aspectratio = cvar.r_aspectratio
    local interpolated = tweening.new()

    function aspect_ratio.update()
        if vars.other.aspect_ratio:get() then
            interpolated(.2, vars.other.aspect_ratio_val:get() / 100)
            cvar.r_aspectratio:float(interpolated.value or 0)
        else
            cvar.r_aspectratio:int(0, true)
        end
    end

end

-- @region: no fall damage
local jump_bug = { } do
    local function extrapolate(entity, distance)
        local x, y, z = entity.m_vecOrigin:unpack()
        local max_radias = math.pi * 2
        local step = max_radias / 8

        for a = 0, max_radias, step do

            local ptX, ptY = ((10 * math.cos( a ) ) + x), ((10 * math.sin( a ) ) + y)
            local trace = utils.trace_line(vector(ptX, ptY, z), vector(ptX, ptY, z - distance), entity)

            local fraction, ent = trace.fraction, trace.entity

            if fraction ~= 1 then
                return true
            end

        end

        return false
    end

    function jump_bug.update(e)
        local lp = entity.get_local_player()

        if not lp then
            return
        end

        if not vars.other.fall_damage:get() or not lp:is_alive() then
            return
        end

        local velocity = lp.m_vecVelocity

        if velocity.z < -500 then
            if extrapolate(lp, 15) then
                e.in_duck = 0
            elseif extrapolate(lp, 75) then
                e.in_duck = 1
            end
        end
    end

end

-- @region: fast ladder
local fast_ladder = { } do
    function fast_ladder.is_state_valid()
        local lp = entity.get_local_player()

        if not lp then
            return false
        end

        if not vars.other.fast_ladder:get() or not lp:is_alive() then
            return false
        end

        if #vars.other.fast_ladder_mode:list() == 0 then
            return false
        end

        if lp.m_MoveType ~= 9 then
            return false
        end

        
        local weapon = lp:get_player_weapon()

        if not weapon then
            return false
        end

        local throw_time = weapon.m_fThrowTime

        if throw_time ~= nil and throw_time ~= 0 then
            return false
        end
        
        return true
    end

    function fast_ladder.update(e)
        if not fast_ladder.is_state_valid() then
            return
        end

        if e.forwardmove > 0 and vars.other.fast_ladder_mode:get(1) then
            if e.view_angles.x < 45 then
                e.view_angles.x = 89
                e.in_moveright = 1
                e.in_moveleft = 0
                e.in_forward = 0
                e.in_back = 1

                if e.sidemove == 0 then
                    e.view_angles.y = e.view_angles.y + 90
                end

                if e.sidemove < 0 then
                    e.view_angles.y = e.view_angles.y + 150
                end

                if e.sidemove > 0 then
                    e.view_angles.y = e.view_angles.y + 30
                end
            end
        elseif e.forwardmove < 0 and vars.other.fast_ladder_mode:get(2) then
            e.view_angles.x = 89
            e.in_moveleft = 1
            e.in_moveright = 0
            e.in_forward = 1
            e.in_back = 0

            if e.sidemove == 0 then
                e.view_angles.y = e.view_angles.y + 90
            end

            if e.sidemove > 0 then
                e.view_angles.y = e.view_angles.y + 150
            end

            if e.sidemove < 0 then
                e.view_angles.y = e.view_angles.y + 30
            end
        end
    end
end

-- @region: configs

local settings = { } do
    local data = db['huyanza.woof'] or { }

    if not data['Default'] then
        data['Default'] = 'eyJhbmdsZXMiOnsiYW50aV9iYWNrc3RhYiI6dHJ1ZSwiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX3BpdGNoIjoiVXAiLCJkZWZlbnNpdmVfcGl0Y2hfdmFsIjowLjAsImRlZmVuc2l2ZV9zdGF0ZXMiOlsifiJdLCJkZWZlbnNpdmVfeWF3IjoiRGVmYXVsdCIsImVkZ2VfeWF3IjpmYWxzZSwiZW5hYmxlIjp0cnVlLCJmcmVlc3RhbmRpbmciOmZhbHNlLCJsYWdfb3B0aW9ucyI6WyJXYWxrIiwiQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwic2FmZV9oZWFkIjp0cnVlfSwiY29uZGl0aW9ucyI6eyJBaXIiOnsiYm9keSI6dHJ1ZSwiYm9keV9sZWZ0X2xpbWl0Ijo1OC4wLCJib2R5X3JpZ2h0X2xpbWl0Ijo1OC4wLCJib2R5X3R3ZWFrcyI6WyJKaXR0ZXIiLCJ+Il0sImVuYWJsZWQiOnRydWUsInBpdGNoIjoiRG93biIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfZGVsYXkiOmZhbHNlLCJ5YXdfZGVsYXlfdGlja3MiOjAuMCwieWF3X2xlZnQiOjAuMCwieWF3X21vZGUiOiJEZWZhdWx0IiwieWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodCI6MC4wfSwiQWlyIENyb3VjaCI6eyJib2R5Ijp0cnVlLCJib2R5X2xlZnRfbGltaXQiOjU4LjAsImJvZHlfcmlnaHRfbGltaXQiOjU4LjAsImJvZHlfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwiZW5hYmxlZCI6dHJ1ZSwicGl0Y2giOiJEb3duIiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfYmFzZSI6IkF0IFRhcmdldCIsInlhd19kZWxheSI6ZmFsc2UsInlhd19kZWxheV90aWNrcyI6MC4wLCJ5YXdfbGVmdCI6LTE5LjAsInlhd19tb2RlIjoiRG91YmxlIiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHQiOjI0LjB9LCJEdWNrIjp7ImJvZHkiOnRydWUsImJvZHlfbGVmdF9saW1pdCI6NTguMCwiYm9keV9yaWdodF9saW1pdCI6NTguMCwiYm9keV90d2Vha3MiOlsiSml0dGVyIiwifiJdLCJlbmFibGVkIjp0cnVlLCJwaXRjaCI6IkRvd24iLCJ5YXciOiJCYWNrd2FyZCIsInlhd19iYXNlIjoiTG9jYWwgVmlldyIsInlhd19kZWxheSI6ZmFsc2UsInlhd19kZWxheV90aWNrcyI6MC4wLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkRlZmF1bHQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodCI6MC4wfSwiUnVuIjp7ImJvZHkiOnRydWUsImJvZHlfbGVmdF9saW1pdCI6NTguMCwiYm9keV9yaWdodF9saW1pdCI6NTguMCwiYm9keV90d2Vha3MiOlsiSml0dGVyIiwifiJdLCJlbmFibGVkIjp0cnVlLCJwaXRjaCI6IkRvd24iLCJ5YXciOiJCYWNrd2FyZCIsInlhd19iYXNlIjoiQXQgVGFyZ2V0IiwieWF3X2RlbGF5IjpmYWxzZSwieWF3X2RlbGF5X3RpY2tzIjowLjAsInlhd19sZWZ0IjowLjAsInlhd19tb2RlIjoiRGVmYXVsdCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjowLjB9LCJTbmVhayI6eyJib2R5Ijp0cnVlLCJib2R5X2xlZnRfbGltaXQiOjU4LjAsImJvZHlfcmlnaHRfbGltaXQiOjU4LjAsImJvZHlfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwiZW5hYmxlZCI6dHJ1ZSwicGl0Y2giOiJEb3duIiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfYmFzZSI6IkF0IFRhcmdldCIsInlhd19kZWxheSI6ZmFsc2UsInlhd19kZWxheV90aWNrcyI6MC4wLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkRlZmF1bHQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodCI6MC4wfSwiU3RhbmQiOnsiYm9keSI6dHJ1ZSwiYm9keV9sZWZ0X2xpbWl0Ijo1OC4wLCJib2R5X3JpZ2h0X2xpbWl0Ijo1OC4wLCJib2R5X3R3ZWFrcyI6WyJKaXR0ZXIiLCJ+Il0sImVuYWJsZWQiOnRydWUsInBpdGNoIjoiRG93biIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfZGVsYXkiOmZhbHNlLCJ5YXdfZGVsYXlfdGlja3MiOjAuMCwieWF3X2xlZnQiOjAuMCwieWF3X21vZGUiOiJEZWZhdWx0IiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHQiOjAuMH0sIldhbGsiOnsiYm9keSI6dHJ1ZSwiYm9keV9sZWZ0X2xpbWl0IjowLjAsImJvZHlfcmlnaHRfbGltaXQiOjAuMCwiYm9keV90d2Vha3MiOlsifiJdLCJlbmFibGVkIjp0cnVlLCJwaXRjaCI6IkRvd24iLCJ5YXciOiJCYWNrd2FyZCIsInlhd19iYXNlIjoiTG9jYWwgVmlldyIsInlhd19kZWxheSI6ZmFsc2UsInlhd19kZWxheV90aWNrcyI6MC4wLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkRlZmF1bHQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodCI6MC4wfSwibW9kZSI6IkN1c3RvbWl6YWJsZSIsInN0YXRlIjoiU3RhbmQifSwiaG9tZSI6eyJ3YXRlcm1hcmsiOjMuMH0sIm90aGVyIjp7ImFzcGVjdF9yYXRpbyI6dHJ1ZSwiYXZvaWRfY29sbGlzaW9ucyI6ZmFsc2UsImZha2VfbGF0ZW5jeSI6MC4wLCJmYWxsX2RhbWFnZSI6dHJ1ZSwiZmFzdF9sYWRkZXIiOnRydWUsImxvZ2dlciI6dHJ1ZX0sInByb2ZpbGUiOnsiaW5wdXQiOiJEZWZhdWx0MTIzIiwibGlzdCI6Mi4wfSwidmlzdWFscyI6eyIqaW5kaWNhdGlvbiI6IiNGRkZGRkZGRiIsIiptYW51YWxfaW5kaWNhdGlvbiI6IiNGRkZGRkZGRiIsIipzbmFwX2xpbmVzIjoiI0ZGRkZGRkZGIiwiaW5kaWNhdGlvbiI6ZmFsc2UsIm1hbnVhbF9pbmRpY2F0aW9uIjpmYWxzZSwic25hcF9saW5lcyI6ZmFsc2V9fQ=='
    end

    function settings:update_list()
        local list = { }

        for k, v in pairs(data) do
            list[k] = k
        end

        vars.profile.list:update(list)
    end; settings:update_list()

    function settings:load()
        local input = vars.profile.input.value

        if data[input] then
           local decoded = json.parse(base64.decode(data[input]))

           pui.load(decoded)
        end
    end

    function settings:import()
        local config = clipboard.get() or ''
        local input = vars.profile.input.value

        local success, decoded = pcall(base64.decode, config)

        if not success then
            return print_raw('\a{Link Active}huyanza.woof \aDEFAULT· Failed to decode configuration.')
        end

        local success, cfg = pcall(json.parse, decoded)

        if not success then
            return print_raw('\a{Link Active}huyanza.woof \aDEFAULT· Failed to parse configuration.')
        end

        pui.load(cfg)
        data[input] = config

    end

    function settings:export()
        local stringified = json.stringify(pui.save())
        local encoded = base64.encode(stringified)

        clipboard.set(encoded)

    end

    function settings:save()
        local input = vars.profile.input.value

        data[input] = base64.encode(json.stringify(pui.save()))
    end


    function settings:delete()
        local input = vars.profile.input.value

        if input == 'Default' then
            return print_raw('\a{Link Active}huyanza.woof \aDEFAULT· Failed to delete default configuration.')
        end

        if data[input] ~= nil then
            data[input] = nil
        end
    end

    for key, value in pairs(vars.profile) do
        if key ~= 'list' and key ~= 'input' then
            vars.profile[key]:set_callback(function()
                settings[key]()
                settings:update_list()
            end)
        end
    end

    vars.profile.list:set_callback(function(self)
        local list = self:list()[self:get()]

        if not list or #list == 0 then
            return
        end

        vars.profile.input:set(list)
    end)

    events.shutdown:set(function()
        db['huyanza.woof'] = data
    end)
end

local watermark = { } do
    local TEXT_TO_ANIMATE = gradient.text_animate('huyanza.woof', 1, {
        color(255),
        vars.home.watermark_color:get()
    })
    function watermark.update()
        local center = render.screen_size() / 2


        TEXT_TO_ANIMATE:set_colors({
            color(255),
            vars.home.watermark_color:get()
        })
        local text = vars.home.watermark:get() == 3 and 'huyanza.woof' or 
            string.format('%s\aDEFAULT \ae05353ff[PARIS]', 
                TEXT_TO_ANIMATE:get_animated_text():upper()
            )

        local pos = vector(15, center.y) do
            if vars.home.watermark:get() == 2 then
                pos = vector(center.x * 2 - 15, center.y)
            elseif vars.home.watermark:get() == 3 then
                pos = vector(center.x, center.y * 2 - 10)
            end
        end
    
        local flags = '' do
            if vars.home.watermark:get() == 2 then
                flags = 'r'
            elseif vars.home.watermark:get() == 3 then
                flags = 'c'
            end 
        end
        render.text(1, pos, color(), flags, text)

        TEXT_TO_ANIMATE:animate()
    end

end

local sidebar = { } do
    local TEXT_TO_ANIMATE = gradient.text_animate('huyanza.woof •', -1, {
        color(255),
        ui.get_style()['Link Active']
    })
    function sidebar.update()
        local text = string.format('%s \f<brackets-curly>', TEXT_TO_ANIMATE:get_animated_text())

        pui.sidebar(text, 'star')

        TEXT_TO_ANIMATE:animate()
    end
end

events.createmove:set(function(e)
    antiaimbot:update(e)
    break_lc:think(e)
    avoid_backstab:think(e)
end)

events.createmove:set(yaw_direction.update)
events.createmove:set(manual_direction.update)
events.createmove:set(edge_direction.update)
events.createmove:set(snap.update)
events.createmove:set(latency.update)
events.createmove:set(avoid_collisions.update)
events.createmove:set(safe_head.update)
events.createmove:set(jump_bug.update)
events.createmove:set(fast_ladder.update)


events.render:set(watermark.update)
events.render:set(sidebar.update)
events.render:set(indication.update)
events.render:set(manual_indication.update)
events.render:set(aspect_ratio.update)
events.render:set(snap_lines.update)
events.render:set(scope.update)
events.render:set(function()
    damage_indicator.render:update()
    velocity_warning.render:update()
end)

events.shutdown:set(function()
    neverlose.visuals.world.main.scope.scope_overlay:override('Remove All')
end)

events.player_hurt:set(logger.player_hurt)
events.aim_ack:set(logger.on_hit)
events.aim_ack:set(logger.on_miss)


pui.setup(vars)