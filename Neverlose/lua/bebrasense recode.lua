-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

---@diagnostic disable: undefined-global, deprecated
jit.flush() -- reset JIT optimizations
jit.opt.start(
    'hotloop=4',
    'maxtrace=500',
    'loopunroll=8',
    'fold',
    'dce',
    'sink',
    'narrow',
    'maxmcode=8192'
)

local user = {
    name = common.get_username(),
    branch = 'developer',
    version = '0.3',
    branch_version = 'pre-alpha'
}

local originals = {
    ['require'] = require,
    ['error'] = error
}

error = function (message, critical)
    cvar.playvol:call('resource/warning.wav')
    print_raw(string.format('\aFF0000FF [error handler]: %s', message))
    if critical then
        originals['error']()
    end
    return false
end

require = function(lib_name)
    local success, lib = pcall(originals['require'], lib_name)
    if not success then
        error(string.format('Failed to load the \'%s\' library', lib_name), true)
    end
    return lib
end

local protection = require 'neverlose/integrity'
if protection() == true then
    error('Hello, you are an idiot! don\'t try to disguise yourself.', true)
end
local pui = require 'neverlose/pui'
local base64 = require 'neverlose/base64'
local clipboard = require 'neverlose/clipboard'
local inspect = require 'neverlose/inspect'

local SCRIPT_NAME = 'Bebra'

local function merge(...)
    local str = ''

    for i = 1, select('#', ...) do
        str = str .. select(i, ...)
    end

    return str
end

local software = { } do
    software.rage = {
        main = {
            silent_aim = pui.find('Aimbot', 'Ragebot', 'Main', 'Enabled', 'Silent Aim'),
            dormant_aimbot = pui.find('Aimbot', 'Ragebot', 'Main', 'Enabled', 'Dormant Aimbot'),

            hide_shots = pui.find('Aimbot', 'Ragebot', 'Main', 'Hide Shots'),
            hide_shots_options = pui.find('Aimbot', 'Ragebot', 'Main', 'Hide Shots', 'Options'),

            double_tap = pui.find('Aimbot', 'Ragebot', 'Main', 'Double Tap'),
            double_tap_lag_options = pui.find('Aimbot', 'Ragebot', 'Main', 'Double Tap', 'Lag Options'),

            peek_assist = {
                pui.find('Aimbot', 'Ragebot', 'Main', 'Peek Assist'),
                pui.find('Aimbot', 'Ragebot', 'Main', 'Peek Assist', 'Style'),
                pui.find('Aimbot', 'Ragebot', 'Main', 'Peek Assist', 'Auto Stop'),
                pui.find('Aimbot', 'Ragebot', 'Main', 'Peek Assist', 'Retreat Mode')
            }
        },

        selection = {
            hit_chance = pui.find('Aimbot', 'Ragebot', 'Selection', 'Hit Chance'),
            minimum_damage = pui.find('Aimbot', 'Ragebot', 'Selection', 'Min. Damage')
        }
    }

    software.antiaim = {
        angles = {
            enabled = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Enabled'),
            pitch = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Pitch'),

            yaw = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw'),
            yaw_base = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Base'),
            yaw_add = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Offset'),
            avoid_backstab = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Avoid Backstab'),
            hidden = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Hidden'),

            yaw_modifier = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw Modifier'),
            modifier_offset = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw Modifier', 'Offset'),

            body_yaw = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw'),
            inverter = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Inverter'),
            left_limit = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Left Limit'),
            right_limit = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Right Limit'),
            options = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Options'),
            freestanding_body_yaw = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Freestanding'),

            freestanding = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Freestanding'),
            disable_yaw_modifiers = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Freestanding', 'Disable Yaw Modifiers'),
            body_freestanding = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Freestanding', 'Body Freestanding'),

            extended_angles = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Extended Angles'),
            extended_pitch = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Extended Angles', 'Extended Pitch'),
            extended_roll = pui.find('Aimbot', 'Anti Aim', 'Angles', 'Extended Angles', 'Extended Roll')
        },

        fake_lag = {
            enabled = pui.find('Aimbot', 'Anti Aim', 'Fake Lag', 'Enabled'),
            limit = pui.find('Aimbot', 'Anti Aim', 'Fake Lag', 'Limit'),
            variability = pui.find('Aimbot', 'Anti Aim', 'Fake Lag', 'Variability')
        },

        misc = {
            fake_duck = pui.find('Aimbot', 'Anti Aim', 'Misc', 'Fake Duck'),
            slow_walk = pui.find('Aimbot', 'Anti Aim', 'Misc', 'Slow Walk'),
            leg_movement = pui.find('Aimbot', 'Anti Aim', 'Misc', 'Leg Movement')
        }
    }

    software.visuals = {
        world = {
            main = {
                scope_overlay = pui.find('Visuals', 'World', 'Main', 'Override Zoom', 'Scope Overlay')
            },

            other = {
                world_marker = pui.find('Visuals', 'World', 'Other', 'Hit Marker', '3D Marker'),
                damage_marker = pui.find('Visuals', 'World', 'Other', 'Hit Marker', 'Damage Marker'),

                grenade_prediction = {
                    color = pui.find('Visuals', 'World', 'Other', 'Grenade Prediction', 'Color'),
                    color_hit = { pui.find('Visuals', 'World', 'Other', 'Grenade Prediction', 'Color Hit') }
                }
            }
        }
    }

    software.misc = {
        main = {
            movement = {
                air_strafe = pui.find('Miscellaneous', 'Main', 'Movement', 'Air Strafe')
            },

            in_game = {
                clan_tag = pui.find('Miscellaneous', 'Main', 'In-Game', 'Clan Tag')
            },

            other = {
                windows = pui.find('Miscellaneous', 'Main', 'Other', 'Windows'),
                log_events = pui.find('Miscellaneous', 'Main', 'Other', 'Log Events'),
                fake_latency = pui.find('Miscellaneous', 'Main', 'Other', 'Fake Latency')
            }
        }
    }
end

local config = { } do
    function config.override_save(element, state)
        element[0].saveable = state
    end
end

local helpers = { } do
    function helpers.utf8_len(s)
        local count = 0
        for _ in string.gmatch(s, '[%z\1-\127\194-\244][\128-\191]*') do
            count = count + 1
        end
        return count
    end

    function helpers.utf8_sub(s, i, j)
        local chars = {}
        for c in string.gmatch(s, '[%z\1-\127\194-\244][\128-\191]*') do
            table.insert(chars, c)
        end
        return table.concat(chars, '', i, j)
    end

    function helpers.contains(list, value)
        if list == nil then
            return false
        end

        for i = 1, #list do
            if list[i] == value then
                return true
            end
        end

        return false
    end
end

local decorations = { } do
    decorations.wave = function(text, color_1, color_2, invert, ...)
        local buffer = {}
        local len = helpers.utf8_len(text)
        local div = 1 / (len - 1)
        local color_diff = color(
            color_2.r - color_1.r,
            color_2.g - color_1.g,
            color_2.b - color_1.b,
            color_2.a - color_1.a
        )

        local clock = ... or globals.realtime

        for i = 1, len do
            local t = (clock % 2 > 1) and (2 - clock % 2) or (clock % 2)

            buffer[i] = string.format(
                '\a%s%s',
                color(
                    color_1.r + color_diff.r * t,
                    color_1.g + color_diff.g * t,
                    color_1.b + color_diff.b * t,
                    color_1.a + color_diff.a * t
                ):to_hex(),
                helpers.utf8_sub(text, i, i)
            )

            clock = invert and (clock - div) or (clock + div)
        end

        return table.concat(buffer)
    end

    decorations.string = { }

    decorations.string.capital = function(str)
        return merge(str:sub(1,1):upper(), str:sub(2))
    end
end

local antiaim_states = {'Default', 'Standing', 'Walking', 'Crouching', 'Crouching+', 'Running', 'Jumping', 'Jumping+'}
local antiaim_teams = {'T', 'CT'}

local menu = new_class()
:struct 'groups' {
    home = pui.create('\f<house-user>', {
        {'welcome', '##MAIN'},
        {'socials', '##SOCIALS'},
        {'config', '##CONFIGURATION', 2},
        {'watermark', '##WATERMARK', 1}
    }),

    antiaim = pui.create('\f<user-shield>', {
        {'extra', '##EXTRA'},
        {'state', '##STATE'},
        {'builder', '##BUILDER', 2},
        {'defensive', '##DEFENSIVE', 2}
    }),

    settings = pui.create('\f<user-gear>', {
        {'rage', '##RAGEBOT'},
        {'visuals', '##VISUALS'},
        {'style', '##STYLE'},
        {'widgets', '##WIDGETS'},
        {'misc', '##MISCELLANEOUS'}
    })
}

:struct 'elements' { }

menu.elements.init = (function (self)
    self.watermark = {
        self.groups.home.watermark:label("            bebrasense.cc © 2024-2025")
    }

    self.home = {
        user_label = self.groups.home.welcome:label(merge('\v\f<circle-user>', '  ', '\r', 'User')),
        user_btn = self.groups.home.welcome:button(user.name, function () end, true),

        version_label = self.groups.home.welcome:label(merge('\v\f<code-branch>', '  ', '\r', 'Branch')),
        version_btn = self.groups.home.welcome:button(string.lower(merge(user.version, '-', user.branch_version)), function () end, true)
    }

    self.socials = {
        neverlose = self.groups.home.socials:button(merge('\a', color(0, 137, 173):to_hex(), '\f<crosshairs>'), function ()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL('https://neverlose.cc/market/item?id=kmsDv8')
        end, true),

        youtube = self.groups.home.socials:button(merge('\a', color(255, 0, 51):to_hex(), '\f<youtube>'), function ()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL('https://www.youtube.com/@stefan_53')
        end, true),

        discord = self.groups.home.socials:button(merge('\a', color(93,106,242):to_hex(), '\f<discord>'), function ()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL('https://discord.gg/fastleaks')
        end, true),

        verification = self.groups.home.socials:button('\v\f<cloud-check>', function ()

        end, true)
    }

    self.config = {
        export = self.groups.home.config:button(merge('\v\f<file-export>', '  \r', 'Export'), function ()

        end, true),
        import = self.groups.home.config:button(merge('\v\f<file-import>', '  \r', 'Import'), function ()

        end, true),
        default = self.groups.home.config:button(merge('\v\f<file-check>', '  \r', 'Default'), function ()

        end, true)
    }

    self.antiaim = {
        extra = {
            freestand = self.groups.antiaim.extra:switch(merge('\v\f<person-walking-dashed-line-arrow-right>', '  \r', 'Freestanding'), false, function (gear)
                return {
                    disable_yaw_modifiers = gear:switch('Disable Yaw Modiifers'),
                    body_freestanding = gear:switch('Body Freestanding')
                }
            end),
            anim = self.groups.antiaim.extra:switch(merge('\v\f<person-rays>', '  \r', 'Animation Breaker'), false, function (gear)
                return {
                    ['Air Legs'] = gear:combo('Air Legs', {'Disabled', 'Static', 'Moonwalk'}),
                    ['Ground Legs'] = gear:combo('Ground Legs', {'Disabled', 'Static', 'Jitter', 'Moonwalk'}),
                    ['Zero Pitch on Land'] = gear:switch('Zero Pitch on Land'),
                    ['Move Lean'] = gear:slider('Move Lean', -1, 100, -1, 1, function (value)
                        if value == -1 then
                            return 'Default'
                        elseif value == 0 then
                            return 'Disabled'
                        end

                        return tostring(value)..'%'
                    end)
                }
            end)
        },

        states = {
            team = self.groups.antiaim.state:combo(merge('\v\f<users>', '  \r', 'Team'), antiaim_teams),
            condition = self.groups.antiaim.state:combo(merge('\v\f<person>', '  \r', 'Anti-Aim State'), antiaim_states)
        }
    }

    self.antiaim.builder = { }

    self.settings = {
        rage = {
            logs = self.groups.settings.rage:selectable(merge('\v\f<gun>', '  \r', 'Logging'), {'Aimbot', 'Purchases'})
        },

        style = {
            accent = self.groups.settings.style:color_picker(merge('\v\f<paintbrush>', '  \r', 'Override Accent Color'), pui.accent)
        },

        visuals = {
            aspect_ratio = self.groups.settings.visuals:slider(merge('\v\f<tv>', '  \r', 'Aspect Ratio'), 0, 2*100, 0, 0.01, function (value)
                if value == 0.0 then
                    return 'Default'
                end

                return string.format('%.2f', value*0.01)
            end),

            grenades = self.groups.settings.visuals:label(merge('\v\f<bomb>', '  \r', 'Grenades'), function (gear)
                return {
                    radius = gear:color_picker('Radius', {
                        ['Smoke'] = {
                            color(119, 152, 188)
                        },
                        ['Molotov'] = {
                            color(188, 119, 119)
                        }
                    }),

                    prediction = gear:switch('Prediction'),
                    trajectory = gear:switch('Trajectory'),
                    warning = gear:switch('Proximity Warning')
                }
            end)
        },

        widgets = {
            watermark = self.groups.settings.widgets:label(merge('\v\f<copyright>', '  \r', 'Watermark'), function (gear)
                return {
                    text = gear:input('Text', merge('bebra', ' ', '[', user.branch, ']')),
                    color = gear:color_picker('Color', {
                        ['Simple'] = {
                            color(255, 255, 255, 255)
                        },

                        ['Gradient'] = {
                            color(255, 255, 255, 255),
                            color(255, 0, 0, 255)
                        }
                    })
                }
            end)
        },

        misc = {
            fast_ladder = self.groups.settings.misc:switch(merge('\v\f<water-ladder>', '  \r', 'Fast Ladder Move')),
            apdative_silent = self.groups.settings.misc:switch(merge('\v\f<crosshairs-simple>', '  \r', 'Adaptive Silent Aim'))
        }
    }
end)(menu.elements)

config.override_save(menu.elements.antiaim.states.team, false)
config.override_save(menu.elements.antiaim.states.condition, false)

local COLOR_ACCENT = color()
local ACCENT_HEX = ''
local prefix = ''

menu.elements.settings.style.accent:set_callback(function (self)
    COLOR_ACCENT = self:get()
    ACCENT_HEX = COLOR_ACCENT:to_hex()
    prefix = merge(string.format('[\a%s', ACCENT_HEX), string.lower(SCRIPT_NAME), '\aDEFAULT]')
end, true)

menu.elements.socials.youtube:tooltip(merge(
    'Click \vhere \rto get \vredirected \rto ', '\vstefan\r\'s ', '\a', color():to_hex(), 'You\a', color(255, 0, 51):to_hex(), 'Tube \r', 'channel.'
))

menu.elements.socials.discord:tooltip(merge(
    'Click \vhere \rto \vjoin \rour \a', color(93,106,242):to_hex(), 'Discord \rserver.'
))

menu.elements.socials.neverlose:tooltip(merge(
    'Click \vhere \rto get \vredirected \rto \vwishenz\r\'s \a', color(0, 137, 173):to_hex(), 'Neverlose \rconfig.'
))

menu.elements.socials.verification:tooltip(
    'Click \vhere \rto \vget \ra \vVerification Code\r.'
)

menu.elements.socials.verification:disabled(true)
menu.elements.settings.visuals.grenades:disabled(true)

for team_id, team_name in pairs(antiaim_teams) do
    menu.elements.antiaim.builder[team_id] = {}

    for state_id, state_name in pairs(antiaim_states) do
        local override = menu.groups.antiaim.builder:switch(merge('Override', ' ', '\a{Link Active}', state_name))
        local pitch = menu.groups.antiaim.builder:combo('Pitch', software.antiaim.angles.pitch:list())

        local yaw = menu.groups.antiaim.builder:combo('Yaw', software.antiaim.angles.yaw:list(), function(gear)
            return {
                base = gear:combo('Base', software.antiaim.angles.yaw_base:list()),
                mode = gear:combo('Mode', { 'Single', 'Double' }),
                offset = gear:slider('Offset', -180, 180, 0),
                left = gear:slider('Left Offset', -180, 180, 0),
                right = gear:slider('Right Offset', -180, 180, 0)
            }
        end)

        local yaw_mod = menu.groups.antiaim.builder:combo('Yaw Modifier', software.antiaim.angles.yaw_modifier:list(), function(gear)
            return {
                offset = gear:slider('Offset', -180, 180, 0),
                randomization = gear:slider('Randomization', 0, 180, 0)
            }
        end)

        local body_yaw = menu.groups.antiaim.builder:switch('Body Yaw', false, function(gear)
            return {
                inverter = gear:switch('Inverter'),
                mode = gear:combo('Mode', { 'Single', 'Double' }),
                limit = gear:slider('Limit', 0, 60, 0),
                left_limit = gear:slider('Left Limit', 0, 60, 0),
                right_limit = gear:slider('Right Limit', 0, 60, 0),
                randomization = gear:slider('Randomization', 0, 60),
                options = gear:selectable('Options', {'Avoid Overlap', 'Jitter', 'Anti Bruteforce'}),
                delay_mode = gear:combo('Delay Mode', {'Normal', 'Random', 'Chance'}),
                delay = gear:slider('Delay', 0, 32, 0, nil, function(value)
                    return value == 0 and 'Default' or value
                end),
                switch_chance = gear:slider('Switch Chance', 1, 100, 0, nil, '%'),
                freestanding = gear:combo('Freestanding', software.antiaim.angles.freestanding_body_yaw:list())
            }
        end)

        local defensive = {
            enabled = menu.groups.antiaim.defensive:switch('Enable \vDefensive AA'),
            pitch = menu.groups.antiaim.defensive:combo('Pitch Mode', {'Straight', 'Double', '3-Way', '5-Way', 'Area'}, function (gear)
                return {
                    offset = gear:slider('Offset', -89, 89, 0),
                    l_offset = gear:slider('Offset #1', -89, 89, 0),
                    r_offset = gear:slider('Offset #2', -89, 89, 0),
                    area = gear:slider('Area', 1, 360, 360),
                    speed = gear:slider('Speed', 1, 6),
                    randmization = gear:slider('Randomization', 0, 180, 0)
                }
            end),
            yaw = menu.groups.antiaim.defensive:combo('Yaw Mode', {'Straight', 'Double', '3-Way', '5-Way', 'Area'}, function (gear)
                return {
                    offset = gear:slider('Offset', -89, 89, 0),
                    l_offset = gear:slider('Offset #1', -89, 89, 0),
                    r_offset = gear:slider('Offset #2', -89, 89, 0),
                    area = gear:slider('Area', 1, 360, 360),
                    speed = gear:slider('Speed', 1, 6),
                    randmization = gear:slider('Randomization', 0, 180, 0)
                }
            end)
        }

        menu.elements.antiaim.builder[team_id][state_id] = {
            override = override,
            pitch = pitch,
            yaw = yaw,
            yaw_modifier = yaw_mod,
            body_yaw = body_yaw,
            defensive = defensive
        }

        local BuilderKey = menu.elements.antiaim.builder[team_id][state_id]
        menu.elements.antiaim.builder[team_id][1].override:set(true)

        BuilderKey.override:depend(
            { menu.elements.antiaim.states.condition, antiaim_states[state_id] },
            { menu.elements.antiaim.states.team, antiaim_teams[team_id] },
            { menu.elements.antiaim.states.condition, antiaim_states[1], true }
        )

        BuilderKey.pitch:depend(
            { menu.elements.antiaim.states.condition, antiaim_states[state_id] },
            { menu.elements.antiaim.states.team, antiaim_teams[team_id] },
            { BuilderKey.override, true }
        )

        BuilderKey.yaw:depend(
            { menu.elements.antiaim.states.condition, antiaim_states[state_id] },
            { menu.elements.antiaim.states.team, antiaim_teams[team_id] },
            { BuilderKey.override, true }
        )

        BuilderKey.yaw.offset:depend({ BuilderKey.yaw.mode, 'Single' })
        BuilderKey.yaw.left:depend({ BuilderKey.yaw.mode, 'Double' })
        BuilderKey.yaw.right:depend({ BuilderKey.yaw.mode, 'Double' })

        BuilderKey.yaw_modifier:depend(
            { menu.elements.antiaim.states.condition, antiaim_states[state_id] },
            { menu.elements.antiaim.states.team, antiaim_teams[team_id] },
            { BuilderKey.override, true }
        )

        BuilderKey.body_yaw:depend(
            { menu.elements.antiaim.states.condition, antiaim_states[state_id] },
            { menu.elements.antiaim.states.team, antiaim_teams[team_id] },
            { BuilderKey.override, true }
        )

        BuilderKey.body_yaw.limit:depend({ BuilderKey.body_yaw.mode, 'Single' })
        BuilderKey.body_yaw.left_limit:depend({ BuilderKey.body_yaw.mode, 'Double' })
        BuilderKey.body_yaw.right_limit:depend({ BuilderKey.body_yaw.mode, 'Double' })
        BuilderKey.body_yaw.delay:depend({ BuilderKey.body_yaw.options, 'Jitter' }, { BuilderKey.body_yaw.delay_mode, 'Normal' })
        BuilderKey.body_yaw.switch_chance:depend({ BuilderKey.body_yaw.options, 'Jitter' }, { BuilderKey.body_yaw.delay_mode, 'Chance' })
        BuilderKey.body_yaw.delay_mode:depend({ BuilderKey.body_yaw.options, 'Jitter' })

        BuilderKey.defensive.enabled:depend(
            { menu.elements.antiaim.states.condition, antiaim_states[state_id] },
            { menu.elements.antiaim.states.team, antiaim_teams[team_id] },
            { BuilderKey.override, true }
        )

        BuilderKey.defensive.pitch:depend(
            { menu.elements.antiaim.states.condition, antiaim_states[state_id] },
            { menu.elements.antiaim.states.team, antiaim_teams[team_id] },
            { BuilderKey.override, true },
            { BuilderKey.defensive.enabled, true }
        )

        BuilderKey.defensive.yaw:depend(
            { menu.elements.antiaim.states.condition, antiaim_states[state_id] },
            { menu.elements.antiaim.states.team, antiaim_teams[team_id] },
            { BuilderKey.override, true },
            { BuilderKey.defensive.enabled, true }
        )

        BuilderKey.defensive.pitch.offset:depend({ BuilderKey.defensive.pitch, 'Straight' })
        BuilderKey.defensive.yaw.offset:depend({ BuilderKey.defensive.yaw, 'Straight' })

        BuilderKey.defensive.pitch.l_offset:depend({ BuilderKey.defensive.pitch, 'Double' })
        BuilderKey.defensive.yaw.l_offset:depend({ BuilderKey.defensive.yaw, 'Double' })

        BuilderKey.defensive.pitch.r_offset:depend({ BuilderKey.defensive.pitch, 'Double' })
        BuilderKey.defensive.yaw.r_offset:depend({ BuilderKey.defensive.yaw, 'Double' })
    end
end

local LP = { } do
    LP.self = nil
    LP.flags = 0
    LP.in_air = false
    LP.moving = false
    LP.crouched = false
    LP.velocity = 0
    LP.team_num = 0

    local on_createmove = function (cmd)
        local me = entity.get_local_player()

        if me == nil or not me:is_alive() then
            LP.self = nil
            return
        end

        LP.self = me

        local flags = me.m_fFlags
        LP.flags = flags
        LP.in_air = (bit.band(flags or 0, bit.lshift(1, 0)) == 0) or cmd.in_jump
        LP.velocity = me.m_vecVelocity:length2d()
        LP.moving = LP.velocity > 1.1 * 3.3
        LP.crouched = me.m_flDuckAmount > 0
        LP.team_num = me.m_iTeamNum - 1
    end

    events.createmove(on_createmove)
end

local ctx = { } do
    ctx.angles = { }
    ctx.angles[1] = false
    ctx.angles.pitch = 'Disabled'
    ctx.angles.yaw = {[1] = 'Disabled', base = 'Local View', offset = 0, avoid_backstab = false}
    ctx.angles.yaw_mod = {[1] = 'Disabled', offset = 0}
    ctx.angles.body_yaw = {[1] = false, inverter = false, left_limit = 0, right_limit = 0, options = {}, freestanding = 'Off'}
    ctx.angles.freestand = {[1] = false, disable_yaw_modifiers = false, body_freestanding = false}

    ctx.fake_lag = { }
    ctx.fake_lag[1] = false
    ctx.fake_lag.limit = 0
    ctx.fake_lag.variability = 0

    ctx.hidden = {[1] = false, pitch = 0, yaw = 0}

    ctx.state = '?'
    ctx.idx = 0
end

local update_ctx do
    local update_freestand do
        local update_freestanding = function ()
            ctx.angles.freestand[1] = menu.elements.antiaim.extra.freestand:get()
        end

        local update_disable_yaw_modifiers = function ()
            ctx.angles.freestand.disable_yaw_modifiers = menu.elements.antiaim.extra.freestand.disable_yaw_modifiers:get()
        end

        local update_body_freestanding = function ()
            ctx.angles.freestand.body_freestanding = menu.elements.antiaim.extra.freestand.body_freestanding:get()
        end

        events.createmove(function ()
            update_freestanding()
            update_disable_yaw_modifiers()
            update_body_freestanding()
        end)
    end

    local update_anti_backstab do
        local on_createmove = function ()
            ctx.angles.yaw.avoid_backstab = true
        end

        events.createmove(on_createmove)
    end

    local update_state do
        local on_createmove = function (cmd)
            local lp = LP.self

            if not lp then return end

            local flags = LP.flags
            local crouching = LP.crouched
            local jumping = LP.in_air
            local moving = LP.moving and not software.antiaim.misc.slow_walk:get()
            local slow_walk = software.antiaim.misc.slow_walk:get()

            local state, idx = 'Standing', 2

            if not jumping then
                if crouching then
                    if moving then
                        state, idx = 'Crouching+', 5
                    else
                        state, idx = 'Crouching', 4
                    end
                else
                    if moving then
                        state, idx = 'Running', 6
                    end
                end
            else
                if crouching then
                    state, idx = 'Jumping+', 8
                else
                    state, idx = 'Jumping', 7
                end
            end

            if slow_walk and not jumping and not crouching and LP.velocity > 1.11 then
                state, idx = 'Walking', 3
            end

            local BuilderKey = menu.elements.antiaim.builder[LP.team_num][idx]
            if BuilderKey.override:get() then
                ctx.state = state
                ctx.idx = idx
            else
                ctx.state = 'Default'
                ctx.idx = 1
            end
        end

        events.createmove(on_createmove)
    end

    local update_builder do
        local on_createmove = function ()
            local me = LP.self

            if not me then return end

            local side = rage.antiaim:inverter()

            local BuilderKey = menu.elements.antiaim.builder[LP.team_num][ctx.idx]

            ctx.angles[1] = true

            local pitch = BuilderKey.pitch:get()
            local yaw = BuilderKey.yaw:get()
            local yaw_base = BuilderKey.yaw.base:get()
            local yaw_offset_mode = BuilderKey.yaw.mode:get()
            local yaw_offset = yaw_offset_mode == 'Double' and (side and BuilderKey.yaw.left:get() or BuilderKey.yaw.right:get()) or BuilderKey.yaw.offset:get()
            local yaw_modifier = BuilderKey.yaw_modifier:get()
            local modifier_offset = BuilderKey.yaw_modifier.offset:get()
            local yaw_randomization = BuilderKey.yaw_modifier.randomization:get()
            yaw_randomization = math.random(-yaw_randomization, yaw_randomization)


            ctx.angles.pitch = pitch
            ctx.angles.yaw[1] = yaw
            ctx.angles.yaw.base = yaw_base
            ctx.angles.yaw.offset = yaw_offset
            ctx.angles.yaw_mod[1] = yaw_modifier
            ctx.angles.yaw_mod.offset = modifier_offset + yaw_randomization

            local body_yaw = BuilderKey.body_yaw:get()
            local body_mode = BuilderKey.body_yaw.mode:get()
            local body_left = BuilderKey.body_yaw.left_limit:get()
            local body_right = BuilderKey.body_yaw.right_limit:get()
            local body_single = BuilderKey.body_yaw.limit:get()
            local body_randomization = BuilderKey.body_yaw.randomization:get()
            body_randomization = math.random(-body_randomization, body_randomization)
            local body_limit = body_mode == 'Double' and {body_left + body_randomization, body_right + body_randomization} or {body_single + body_randomization, body_single + body_randomization}

            for i = 1, #body_limit do
                body_limit[i] = math.clamp(body_limit[i], -60, 60)
            end

            local body_options = BuilderKey.body_yaw.options:get()
            local body_freestanding  = BuilderKey.body_yaw.freestanding:get()

            ctx.angles.body_yaw[1] = body_yaw
            ctx.angles.body_yaw.left_limit = body_limit[1]
            ctx.angles.body_yaw.right_limit = body_limit[2]
            ctx.angles.body_yaw.freestanding = body_freestanding

            local delay_mode = BuilderKey.body_yaw.delay_mode:get()
            local delay = BuilderKey.body_yaw.delay:get()
            local delay_chance = BuilderKey.body_yaw.switch_chance:get()

            local custom_body_options = {}
            for _, v in ipairs(body_options) do
                table.insert(custom_body_options, v)
            end

            for i, v in ipairs(custom_body_options) do
                if v == 'Jitter' then
                    table.remove(custom_body_options, i)
                    break
                end
            end

            if (delay == 0 and delay_mode == 'Normal') or (delay_chance == 100 and delay_mode == 'Chance') then
                ctx.angles.body_yaw.options = body_options
            else
                ctx.angles.body_yaw.options = custom_body_options
            end

            if delay_mode == 'Normal' then
                if globals.tickcount % delay == delay - 1 then
                    ctx.angles.body_yaw.inverter = not ctx.angles.body_yaw.inverter
                end
            elseif delay_mode == 'Random' then
                local delay_amount = math.random(1, 12)
                if globals.tickcount % delay_amount == delay_amount - 1 then
                    ctx.angles.body_yaw.inverter = not ctx.angles.body_yaw.inverter
                end
            else
                ctx.angles.body_yaw.inverter = utils.random_int(1, 100) <= delay_chance
            end

            ctx.fake_lag[1] = true
            ctx.fake_lag.limit = 14
            ctx.fake_lag.variability = 45
        end

        events.createmove(on_createmove)
    end
end

events.render:set(function ()
    local screen = render.screen_size() * .45
    render.text(1, vector(10, screen.y), color(), nil, inspect(ctx) )
end)

local function apply_ctx()
    software.antiaim.angles.enabled:override(ctx.angles[1])
    software.antiaim.angles.pitch:override(ctx.angles.pitch)
    software.antiaim.angles.yaw:override(ctx.angles.yaw[1])
    software.antiaim.angles.yaw_base:override(ctx.angles.yaw.base)
    software.antiaim.angles.yaw_add:override(ctx.angles.yaw.offset)
    software.antiaim.angles.avoid_backstab:override(ctx.angles.yaw.avoid_backstab)

    software.antiaim.angles.yaw_modifier:override(ctx.angles.yaw_mod[1])
    software.antiaim.angles.modifier_offset:override(ctx.angles.yaw_mod.offset)

    software.antiaim.angles.body_yaw:override(ctx.angles.body_yaw[1])
    software.antiaim.angles.inverter:override(ctx.angles.body_yaw.inverter)
    software.antiaim.angles.left_limit:override(ctx.angles.body_yaw.left_limit)
    software.antiaim.angles.right_limit:override(ctx.angles.body_yaw.right_limit)
    software.antiaim.angles.options:override(ctx.angles.body_yaw.options)
    software.antiaim.angles.freestanding_body_yaw:override(ctx.angles.body_yaw.freestanding)

    software.antiaim.angles.freestanding:override(ctx.angles.freestand[1])
    software.antiaim.angles.disable_yaw_modifiers:override(ctx.angles.freestand.disable_yaw_modifiers)
    software.antiaim.angles.body_freestanding:override(ctx.angles.freestand.body_freestanding)

    software.antiaim.fake_lag.enabled:override(ctx.fake_lag[1])
    software.antiaim.fake_lag.limit:override(ctx.fake_lag.limit)
    software.antiaim.fake_lag.variability:override(ctx.fake_lag.variability)

    software.antiaim.angles.hidden:override(ctx.hidden[1])
    rage.antiaim:override_hidden_pitch(ctx.hidden.pitch)
    rage.antiaim:override_hidden_yaw_offset(ctx.hidden.yaw)
end

events.createmove(apply_ctx)

local r_aspectratio = cvar.r_aspectratio

menu.elements.settings.visuals.aspect_ratio:set_callback(function (self)
    local value = self:get() * 0.01

    if value ~= 0.0 then
        r_aspectratio:float(value, true)
    else
        r_aspectratio:float(tonumber(r_aspectratio:string()), true)
    end
end, true)

local fast_ladder do
    local function update_movement(cmd)
        local pitch = render.camera_angles().x

        if pitch < 45 and cmd.forwardmove ~= 0 then
            local moving_forward = cmd.forwardmove > 0
            cmd.view_angles.x = 89

            cmd.in_forward, cmd.in_back = moving_forward and 0 or 1, moving_forward and 1 or 0
            cmd.in_moveleft, cmd.in_moveright = moving_forward and 0 or 1, moving_forward and 1 or 0

            if cmd.sidemove == 0 then
                cmd.view_angles.y = cmd.view_angles.y + 90
            elseif cmd.sidemove < 0 then
                cmd.view_angles.y = cmd.view_angles.y + (moving_forward and 150 or 30)
            elseif cmd.sidemove > 0 then
                cmd.view_angles.y = cmd.view_angles.y + (moving_forward and 30 or 150)
            end
        end
    end

    local function on_createmove(cmd)
        local me = entity.get_local_player()

        if me == nil or me.m_MoveType ~= 9 then
            return
        end

        update_movement(cmd)
    end

    menu.elements.settings.misc.fast_ladder:set_callback(function(self)
        events.createmove(on_createmove, self:get())
    end, true)
end

local silent_aim do
    local function on_render()
        local me = entity.get_local_player()
        if not me or not me:is_alive() then
            return
        end

	    local camera_position = render.camera_position()
	    local camera_angles = render.camera_angles()
        local direction = vector():angles(camera_angles)
        local closest_distance = math.huge

        for _, enemy in ipairs(entity.get_players(true)) do
            local head_position = enemy:get_hitbox_position(1)
            local ray_distance = head_position:dist_to_ray(camera_position, direction)

            if ray_distance < closest_distance then
                closest_distance = ray_distance
            end
        end

        if closest_distance == math.huge or closest_distance > 200 then
            software.rage.main.silent_aim:override()
            return
        end

        software.rage.main.silent_aim:override(false)
    end

    menu.elements.settings.misc.apdative_silent:set_callback(function(self)
        events.render(on_render, self:get())
    end, true)
end

local logging do
    local hitgroup_str = {
        [0] = 'generic',
        'head', 'chest', 'stomach',
        'left arm', 'right arm',
        'left leg', 'right leg',
        'neck', 'generic', 'gear'
    }

    local function on_hit(cmd)
        local target = cmd.target

        if target == nil then
            return
        end

        local name = target:get_name()
        local hitgroup = cmd.hitgroup
        local wanted_hitgroup = cmd.wanted_hitgroup
        hitgroup = hitgroup == wanted_hitgroup and hitgroup_str[hitgroup] or merge(hitgroup_str[hitgroup], '(', hitgroup_str[wanted_hitgroup], ')')
        local damage = cmd.damage
        local wanted_damage = cmd.wanted_damage
        damage = damage == wanted_damage and damage or merge(damage, '(', wanted_damage, ')')
        local hitchance = cmd.hitchance
        local backtrack = cmd.backtrack
        local spread = cmd.spread or 0.00

        local text = { } do
            text.dev = string.format(
                '\aDEFAULTHit \a%s%s \aDEFAULTin the \a%s%s \aDEFAULTfor \a%s%s \aDEFAULTdamage { hc = \a%s%d%% \aDEFAULT| bt = \a%s%dt(%dms) \aDEFAULT| spread = \a%s%.2f° \aDEFAULT}',
                ACCENT_HEX, name, ACCENT_HEX, hitgroup, ACCENT_HEX, damage, ACCENT_HEX, hitchance, ACCENT_HEX, backtrack, to_time(backtrack)*1000, ACCENT_HEX, spread
            )

            text.raw = string.format(
                '\aDEFAULT%s Hit \a%s%s \aDEFAULTin the \a%s%s \aDEFAULTfor \a%s%s \aDEFAULTdamage { hc = \a%s%d%% \aDEFAULT| bt = \a%s%dt(%dms) \aDEFAULT| spread = \a%s%.2f° \aDEFAULT}',
                prefix, ACCENT_HEX, name, ACCENT_HEX, hitgroup, ACCENT_HEX, damage, ACCENT_HEX, hitchance, ACCENT_HEX, backtrack, to_time(backtrack)*1000, ACCENT_HEX, spread
            )
        end

        print_dev(text.dev)
        print_raw(text.raw)
    end

    local function on_miss(cmd)
        local target = cmd.target

        if target == nil then
            return
        end

        local name = target:get_name()
        local wanted_hitgroup = cmd.wanted_hitgroup
        local wanted_damage = cmd.wanted_damage
        local hitchance = cmd.hitchance
        local backtrack = cmd.backtrack
        local spread = cmd.spread or 0.00

        local text = { } do
            text.dev = string.format(
                '\aDEFAULTMissed \a%s%s \aDEFAULTin the \a%s%s \aDEFAULTdue to \a%s%s \aDEFAULTfor \a%s%s \aDEFAULTdamage { hc = \a%s%d%% \aDEFAULT| bt = \a%s%dt(%dms) \aDEFAULT| spread = \a%s%.2f° \aDEFAULT}',
                ACCENT_HEX, name, ACCENT_HEX, hitgroup_str[wanted_hitgroup], ACCENT_HEX, cmd.state, ACCENT_HEX, wanted_damage, ACCENT_HEX, hitchance, ACCENT_HEX, backtrack, to_time(backtrack)*1000, ACCENT_HEX, spread
            )

            text.raw = string.format(
                '\aDEFAULT%s \aDEFAULTMissed \a%s%s \aDEFAULTin the \a%s%s \aDEFAULTdue to \a%s%s \aDEFAULTfor \a%s%s \aDEFAULTdamage { hc = \a%s%d%% \aDEFAULT| bt = \a%s%dt(%dms) \aDEFAULT| spread = \a%s%.2f° \aDEFAULT}',
                prefix, ACCENT_HEX, name, ACCENT_HEX, hitgroup_str[wanted_hitgroup], ACCENT_HEX, cmd.state, ACCENT_HEX, wanted_damage, ACCENT_HEX, hitchance, ACCENT_HEX, backtrack, to_time(backtrack)*1000, ACCENT_HEX, spread
            )
        end

        print_dev(text.dev)
        print_raw(text.raw)
    end

    local function on_aim_ack(cmd)
        if cmd.state == nil then
            on_hit(cmd)
        else
            on_miss(cmd)
        end
    end

    local function on_aim_fire(cmd)
        local target = cmd.target

        if target == nil then
            return
        end

        local name = target:get_name()
        local shot_id = cmd.id
        local damage = cmd.damage
        local hitchance = cmd.hitchance
        local hitgroup = cmd.hitgroup
        local backtrack = cmd.backtrack
        local aim = cmd.aim
        local angle = cmd.angle

        local text = { } do
            text.dev = string.format(
                '\a%sfired shot at %s\'s %s { id = %d | damage = %s | hitchance = %s%% | backtrack = %dt(%dms) | aim = %s | angle = %s }',
                ACCENT_HEX, name, hitgroup_str[hitgroup], shot_id, damage, hitchance, backtrack, to_time(backtrack)*1000, aim, angle
            )

            text.raw = string.format(
                '\a%s[debug] fired shot at %s\'s %s { id = %d | damage = %s | hitchance = %s%% | backtrack = %dt(%dms) | aim = %s | angle = %s }',
                ACCENT_HEX, name, hitgroup_str[hitgroup], shot_id, damage, hitchance, backtrack, to_time(backtrack)*1000, aim, angle
            )
        end

        print_dev(text.dev)
        print_raw(text.raw)
    end

    local on_item_purchase = function (cmd)
        local userid = cmd.userid
        local ent = entity.get(userid, true)

        if ent == nil then
            return
        end

        local me = entity.get_local_player()
        local team_num = cmd.team

        if team_num == me.m_iTeamNum then
            return
        end

        local weapon = cmd.weapon

        if weapon == nil then
            return
        end

        local name = ent:get_name()

        local text = { } do
            text.dev = string.format('\a%s%s \aDEFAULTbought \a%s%s', ACCENT_HEX, name, ACCENT_HEX, weapon)
            text.raw = string.format('\aDEFAULT%s \a%s%s \aDEFAULTbought \a%s%s', prefix, ACCENT_HEX, name, ACCENT_HEX, weapon)
        end

        print_dev(text.dev)
        print_raw(text.raw)
    end

    menu.elements.settings.rage.logs:set_callback(function (self)
        local has_aimbot = self:get('Aimbot')
        local has_purchases = self:get('Purchases')

        events.aim_ack(on_aim_ack, has_aimbot)
        events.aim_fire(on_aim_fire, has_aimbot)

        events.item_purchase(on_item_purchase, has_purchases)
    end, true)
end

local watermark do
    local on_render = function()
        local text = menu.elements.settings.widgets.watermark.text:get()
        local mode, colors = menu.elements.settings.widgets.watermark.color:get()
        if type(colors) == 'table' then
            local c1, c2 = unpack(colors)
            text = decorations.wave(text, c1, c2, true)
        end
        local screen = render.screen_size()
        render.text(
            4,
            vector(screen.x/2, screen.y*0.99),
            type(colors) == 'table' and color() or colors,
            'c',
            text
        )
    end

    events.render(on_render)
end

local sidebar do
    local text = merge(decorations.string.capital(SCRIPT_NAME), ' ', decorations.string.capital(user.branch))
    local on_render = function ()
        if pui.get_alpha() == 0 then
            return
        end

        pui.sidebar(decorations.wave(text, pui.accent/1.5, pui.accent, true), 'steam')
    end

    events.render:set(on_render)
end