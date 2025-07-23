-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS


local pui = require("neverlose/pui")
local MTools = require("neverlose/mtools");
local antiaim = require("neverlose/anti_aim")
local gradient = require("neverlose/gradient")
local base64 = require ("neverlose/base64")
local smoothy = require ("neverlose/smoothy")
local clipboard = require ("neverlose/clipboard")
local bomb = require ("neverlose/bomb")


-- @REGION: reference

local screen_x, screen_y = render.screen_size().x, render.screen_size().y

local reference = {
    antiaim = {
        angels = {
            enable = pui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
            pitch = pui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
            yaw = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw", {
                base = "Base",
                offset = "Offset",
                avoid_backstab = "Avoid Backstab",
                hidden = "Hidden"
            }),
            yaw_modifier = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
            yaw_modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
            body_yaw = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", {
                inverter = "Inverter",
                left_limit = "Left Limit",
                right_limit = "Right Limit",
                options = "Options",
                freestanding = "Freestanding"
            }),
            freestanding = pui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", {
                disable_yaw_modifiers = "Disable Yaw Modifiers",
                body_freestanding = "Body Freestanding"
            }),
            extended_angels = pui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", {
                extended_pitch = "Extended Pitch",
                extended_roll = "Extended Roll"
            }),
            fake_duck = pui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")
        },
        fakelag = {
            enabled = pui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
            limit = pui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
            variability = pui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")
        },
        misc = {
            fakeduck = pui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
            slowwalk = pui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
            legmovement = pui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
            fake_latency = pui.find("Miscellaneous", "Main", "Other", "Fake Latency")
        }
    },
    ragebot = {
        double_tap = pui.find("Aimbot", "Ragebot", "Main", "Double Tap", {
            options = "Lag Options"
        }),
        osaa = pui.find("Aimbot", "Ragebot", "Main", "Hide Shots", {
            options = "Options"
        }),
        enable = pui.find("Aimbot", "Ragebot", "Main", "Enabled", {
            da = "Dormant Aimbot"
        }),
        dormant_aimbot = pui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
        body_aim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
        safe_points = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
        minimum_damage = pui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
        weapon_actions = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"),
        hitchance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance")
    },
    world = {
        override_zoom = pui.find("Visuals", "World", "Main", "Override Zoom", {
            scope_overlay = "Scope Overlay"
        })
    }
}

-- @REGION: Lerp
function lerp(a, b, t)
    return a + (b - a) * t
end

math.max_lerp_low_fps = (1 / 45) * 100
math.lerp = function(start, end_pos, time)
    if start == end_pos then
        return end_pos
    end

    local frametime = globals.frametime * 170
    time = time * math.min(frametime, math.max_lerp_low_fps)

    local val = start + (end_pos - start) * globals.frametime * time

    if(math.abs(val - end_pos) < 0.01) then
        return end_pos
    end

    return val
end

local animations = {}
animations.base_speed = 0.095
animations._list = {}
animations.new = function(name, new_value, speed, init)
    speed = speed or animations.base_speed

    if animations._list[name] == nil then
        animations._list[name] = (init and init) or 0
    end

    animations._list[name] = math.lerp(animations._list[name], new_value, speed)
    
    return animations._list[name]
end
-- @ENDREGION

-- @REGION: CALLBACKS
local callbacks, debug_enabled = {}, false; do
    local timer = (function()
        ffi.cdef [[
            typedef struct {
                long long QuadPart;
            } LARGE_INTEGER;
            int QueryPerformanceCounter(LARGE_INTEGER* lpPerformanceCount);
            int QueryPerformanceFrequency(LARGE_INTEGER* lpFrequency);
            uint64_t GetTickCount64(void);
        ]]

        local frequency = ffi.new 'LARGE_INTEGER'
        local counter = ffi.new 'LARGE_INTEGER'

        if ffi.C.QueryPerformanceFrequency(frequency) == 1 then
            local frequency_num = tonumber(frequency.QuadPart)
            return function()
                if ffi.C.QueryPerformanceCounter(counter) == 1 then
                    return tonumber(counter.QuadPart) / frequency_num
                end
                return ffi.C.GetTickCount64() / 1000
            end
        end

        return function()
            return ffi.C.GetTickCount64() / 1000
        end
    end)()

    local events_data = {
        map = {},
        performance = {},
        setup = {}
    }

    local Event = {
        set = function(self, fn)
            if not events_data.setup[self.name] then
                events_data.setup[self.name] = {}
            end

            if not self.handlers[fn] then
                table.insert(events_data.setup[self.name], fn)
                self.handlers[fn] = fn
                return true
            end
            return false
        end,

        unset = function(self, fn)
            if self.handlers[fn] then
                self.handlers[fn] = nil
                return true
            end
            return false
        end,

        call = function(self, ...)
            local event = events[self.name]
            if event then
                event:call(...)
            end
        end
    }

    local function create_event_handler(event_name, handlers)
        if type(event_name) == 'string' then
            events[event_name](function(...)
                events_data.performance[event_name] = {}

                xpcall(function(...)
                    for _, handler in pairs(handlers) do
                        local start = timer()
                        handler(...)
                        events_data.performance[event_name][handler] = (timer() - start) * 1000
                    end
                end, function(err)
                    print(string.format('[%s] Error: %s', event_name, err))
                end, ...)
            end)
        end
    end

    callbacks = events

    if debug_enabled then
        callbacks = setmetatable({}, {
            __index = function(_, event_name)
                local event = events_data.map[event_name]

                if not event then
                    print(string.format('Registering new event: %s', event_name))

                    event = setmetatable({
                        handlers = {},
                        name = event_name
                    }, {
                        __index = Event,
                        __call = function(self, fn, enabled)
                            if enabled == nil then enabled = true end
                            self[enabled and 'set' or 'unset'](self, fn)
                        end
                    })

                    events_data.map[event_name] = event
                    create_event_handler(event_name, event.handlers)
                end

                return event
            end
        })

        local font = 3
        local line_height = 16

        events.render(function()
            local screen = render.screen_size()
            local pos = vector(5, screen.y * 0.25)

            for event_name, metrics in pairs(events_data.performance) do
                render.text(font, pos, color(255, 255, 255), nil, event_name)
                pos.y = pos.y + line_height

                for i, handler in ipairs(events_data.setup[event_name] or {}) do
                    local time = metrics[handler] or 0
                    local text = string.format('  [%d]: %.3fms', i, time)
                    local color = time > 1 and color(255, 100, 100) or color(255, 255, 255)

                    render.text(font, pos, color, nil, text)
                    pos.y = pos.y + line_height
                end

                pos.y = pos.y + 8
            end
        end)
    end
end
-- @ENDREGION

-- @REGION: GET ORIGINAL
local function get_original(convar)
    return tonumber(convar:string())
end
-- @ENDREGION

-- @REGION: debug features
local info = {
    colors = {
        accent = color("#8FA1D7D8"),
    },
    _lua = {
        name = "Laura",
        build = "Debug",
        username = common.get_username(),
        update = "09.03.2025"
    }
}
-- @ENDREGION

-- @REGION: Lerp
function lerp(a, b, t)
    return a + (b - a) * t
end

math.max_lerp_low_fps = (1 / 45) * 100
math.lerp = function(start, end_pos, time)
    if start == end_pos then
        return end_pos
    end

    local frametime = globals.frametime * 170
    time = time * math.min(frametime, math.max_lerp_low_fps)

    local val = start + (end_pos - start) * globals.frametime * time

    if(math.abs(val - end_pos) < 0.01) then
        return end_pos
    end

    return val
end

local animations = {}
animations.base_speed = 0.095
animations._list = {}
animations.new = function(name, new_value, speed, init)
    speed = speed or animations.base_speed

    if animations._list[name] == nil then
        animations._list[name] = (init and init) or 0
    end

    animations._list[name] = math.lerp(animations._list[name], new_value, speed)
    
    return animations._list[name]
end
-- @ENDREGION

-- @REGION: colors
pui.colors.accent = info.colors.accent
-- @ENDREGION

local menu = {
    menulist = {},
    reference = {},

    main = {},
    antiaim = {},
    other = {}
}

-- @REGION: reference
menu.reference = {
    main = {
        conditions = {
            "Shared",
            "Standing",
            "Running",
            "Slow Walking",
            "Crouching",
            "Crouch + Moving",
            "Aerobic",
            "Aerobic + Crouching",
            "Auto Regulation",
        },
        force_defensive = {
            "Standing",
            "Running",
            "Slow Walking",
            "Crouching",
            "Crouch Moving",
            "Aerobic",
            "Aerobic + Crouching",
            "Auto Regulation",
        }
    }
}
-- @ENDREGION

configs_database = db.Lauraconfigs or { }
configs_database.config_list = configs_database.config_list or {"Default"}
configs_database.ui_list = configs_database.ui_list or {"Default"} 
configs_database.config_list[1] = "Laura_W3siYWNjZW50X2NvbG9yIjoiIzhGQTFEN0Q4IiwiaW5wdXQiOiIiLCJsaXN0Ijo2LjAsInNlbGVjdG9yMSI6MS4wLCJzaWRlYmFyY29tYm8iOiJEZWZhdWx0Iiwid2F0ZXJtYXJrcG9zaXRpb24iOiJMZWZ0Iiwid2F0ZXJtYXJrc3R5bGUiOiJMYXVyYSJ9LHsiYW5nZWxzIjp7InNlbGVjdG9yIjoiU3RhbmRpbmcifSwiZXh0cmEiOnsiYXZvaWRiYWNrc3RhYiI6dHJ1ZSwiZm9yY2VkZWYiOnRydWUsInNhZmVoZWFkIjpmYWxzZSwifmZvcmNlZGVmIjp7ImNvbmRpdGlvbnMiOls0LjAsIn4iXX0sIn5zYWZlaGVhZCI6eyJzZWxlY3RhYmxlIjpbIn4iXX19LCJob3RrZXlzIjp7ImZyZWVzdGFuZCI6ZmFsc2UsIm1hbnVhbHMiOnsibW9kIjoiZGlzYWJsZWQifSwifmZyZWVzdGFuZCI6eyJtb2QiOlsifiJdfX0sIm1hc3RlcnN3aXRjaCI6dHJ1ZX0seyJTaWRlSW5kaWNhdG9ycyI6dHJ1ZSwiYWltYm90X2xvZ3MiOnRydWUsImFzcGVjdHJhdGlvIjp0cnVlLCJjbGFudGFnIjpmYWxzZSwiZGFtYWdlX2luZGljYXRvciI6dHJ1ZSwiZG9ybWFudF9haW1ib3QiOmZhbHNlLCJmYWtlbGF0ZW5jeSI6MTQ0LjAsImZhc3RsYWRkZXIiOmZhbHNlLCJoaXRjaGFuY2VfaW5kaWNhdG9yIjpmYWxzZSwiaGl0bWFya2VyIjpmYWxzZSwia2VlcF9tb2RlbF90cmFuc3BhcmVuY3kiOmZhbHNlLCJuYWRlX3Rocm93X2ZpeCI6ZmFsc2UsIm5vZmFsbGRhbWFnZSI6ZmFsc2UsInNjb3BlX292ZXJsYXkiOnRydWUsInN1cGVyX3Rvc3MiOmZhbHNlLCJ0cmFzaHRhbGsiOmZhbHNlLCJ2aWV3bW9kZWwiOnRydWUsIn5haW1ib3RfbG9ncyI6eyIqaGl0c3dpdGNoIjoiIzhGQTFEN0Q4IiwiKm1pc3Nzd2l0Y2giOiIjRkY0NDQ0RkYiLCJoaXRzd2l0Y2giOnRydWUsImxvZ2xpc3QiOlsxLjAsMi4wLCJ+Il0sIm1pc3Nzd2l0Y2giOnRydWV9LCJ+YXNwZWN0cmF0aW8iOnsiYW1vdW50IjoxMjQuMH0sIn5kb3JtYW50X2FpbWJvdCI6eyJhdXRvX3Njb3BlIjpmYWxzZSwiZGFtYWdlIjotMS4wLCJoaXRib3hlcyI6WyJ+Il0sImhpdGNoYW5jZSI6NjAuMH0sIn5oaXRtYXJrZXIiOnsiY29sb3IiOiIjNTNBODhCRkYifSwifnNjb3BlX292ZXJsYXkiOnsicmVtb3ZlX2xpbmUiOlsifiJdLCJzY29wZV9jb2xvciI6IiM4QjhCOEJGRiIsInNjb3BlX2dhcCI6MTAuMCwic2NvcGVfc2l6ZSI6MTkwLjAsInNjb3BlX3N0eWxlIjoiZGVmYXVsdCJ9LCJ+dmlld21vZGVsIjp7ImZvdiI6NjUwLjAsIngiOjAuMCwieSI6MjAuMCwieiI6NDAuMH19LFt7ImJvZHlfeWF3IjpbIn4iXSwiYm9keV95YXdfcmFuZG9taXphdGlvbiI6MC4wLCJib2R5X3lhd192YWx1ZSI6MC4wLCJib2R5X3lhd192YWx1ZTIiOjAuMCwiZGVmZW5zaXZlX2xhYmVsIjp7ImNob2NrZV92YWx1ZSI6MC4wLCJlbmFibGUiOmZhbHNlLCJvc2FhIjpmYWxzZSwicGl0Y2giOiJkaXNhYmxlZCIsInBpdGNoX3ZhbHVlIjowLjAsInlhdyI6ImRpc2FibGVkIiwieWF3X3ZhbHVlIjowLjB9LCJvdmVycmlkZSI6dHJ1ZSwieWF3IjoiT25lIFByb3Zpc2lvbiIsInlhd19kZWZhdWx0X3ZhbHVlIjowLjAsInlhd19kZWxheV9lbmFibGUiOjEuMCwieWF3X2xlZnRfdmFsdWUiOjAuMCwieWF3X21vZGlmaWVyIjoiZGlzYWJsZWQiLCJ5YXdfbW9kaWZpZXJfcmFuZG9taXphdGlvbiI6MC4wLCJ5YXdfbW9kaWZpZXJfdmFsdWUiOjAuMCwieWF3X3JpZ2h0X3ZhbHVlIjowLjB9LHsiYm9keV95YXciOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19yYW5kb21pemF0aW9uIjowLjAsImJvZHlfeWF3X3ZhbHVlIjo2MC4wLCJib2R5X3lhd192YWx1ZTIiOjYwLjAsImRlZmVuc2l2ZV9sYWJlbCI6eyJjaG9ja2VfdmFsdWUiOjAuMCwiZW5hYmxlIjpmYWxzZSwib3NhYSI6ZmFsc2UsInBpdGNoIjoiZGlzYWJsZWQiLCJwaXRjaF92YWx1ZSI6MC4wLCJ5YXciOiJkaXNhYmxlZCIsInlhd192YWx1ZSI6MC4wfSwib3ZlcnJpZGUiOnRydWUsInlhdyI6IlR3byBQcm92aXNpb25zIiwieWF3X2RlZmF1bHRfdmFsdWUiOjAuMCwieWF3X2RlbGF5X2VuYWJsZSI6MS4wLCJ5YXdfbGVmdF92YWx1ZSI6LTM0LjAsInlhd19tb2RpZmllciI6ImRpc2FibGVkIiwieWF3X21vZGlmaWVyX3JhbmRvbWl6YXRpb24iOjAuMCwieWF3X21vZGlmaWVyX3ZhbHVlIjowLjAsInlhd19yaWdodF92YWx1ZSI6NDEuMH0seyJib2R5X3lhdyI6WyJKaXR0ZXIiLCJ+Il0sImJvZHlfeWF3X3JhbmRvbWl6YXRpb24iOjAuMCwiYm9keV95YXdfdmFsdWUiOjYwLjAsImJvZHlfeWF3X3ZhbHVlMiI6NjAuMCwiZGVmZW5zaXZlX2xhYmVsIjp7ImNob2NrZV92YWx1ZSI6MC4wLCJlbmFibGUiOmZhbHNlLCJvc2FhIjpmYWxzZSwicGl0Y2giOiJkaXNhYmxlZCIsInBpdGNoX3ZhbHVlIjowLjAsInlhdyI6ImRpc2FibGVkIiwieWF3X3ZhbHVlIjowLjB9LCJvdmVycmlkZSI6dHJ1ZSwieWF3IjoiVHdvIFByb3Zpc2lvbnMiLCJ5YXdfZGVmYXVsdF92YWx1ZSI6MC4wLCJ5YXdfZGVsYXlfZW5hYmxlIjoxLjAsInlhd19sZWZ0X3ZhbHVlIjotMjQuMCwieWF3X21vZGlmaWVyIjoiZGlzYWJsZWQiLCJ5YXdfbW9kaWZpZXJfcmFuZG9taXphdGlvbiI6MC4wLCJ5YXdfbW9kaWZpZXJfdmFsdWUiOjAuMCwieWF3X3JpZ2h0X3ZhbHVlIjo0Mi4wfSx7ImJvZHlfeWF3IjpbIn4iXSwiYm9keV95YXdfcmFuZG9taXphdGlvbiI6MC4wLCJib2R5X3lhd192YWx1ZSI6MC4wLCJib2R5X3lhd192YWx1ZTIiOjAuMCwiZGVmZW5zaXZlX2xhYmVsIjp7ImNob2NrZV92YWx1ZSI6MC4wLCJlbmFibGUiOmZhbHNlLCJvc2FhIjpmYWxzZSwicGl0Y2giOiJkaXNhYmxlZCIsInBpdGNoX3ZhbHVlIjowLjAsInlhdyI6ImRpc2FibGVkIiwieWF3X3ZhbHVlIjowLjB9LCJvdmVycmlkZSI6ZmFsc2UsInlhdyI6Ik9uZSBQcm92aXNpb24iLCJ5YXdfZGVmYXVsdF92YWx1ZSI6MC4wLCJ5YXdfZGVsYXlfZW5hYmxlIjoxLjAsInlhd19sZWZ0X3ZhbHVlIjowLjAsInlhd19tb2RpZmllciI6ImRpc2FibGVkIiwieWF3X21vZGlmaWVyX3JhbmRvbWl6YXRpb24iOjAuMCwieWF3X21vZGlmaWVyX3ZhbHVlIjowLjAsInlhd19yaWdodF92YWx1ZSI6MC4wfSx7ImJvZHlfeWF3IjpbIkppdHRlciIsIn4iXSwiYm9keV95YXdfcmFuZG9taXphdGlvbiI6MC4wLCJib2R5X3lhd192YWx1ZSI6NjAuMCwiYm9keV95YXdfdmFsdWUyIjo2MC4wLCJkZWZlbnNpdmVfbGFiZWwiOnsiY2hvY2tlX3ZhbHVlIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9zYWEiOmZhbHNlLCJwaXRjaCI6ImRpc2FibGVkIiwicGl0Y2hfdmFsdWUiOjAuMCwieWF3IjoiZGlzYWJsZWQiLCJ5YXdfdmFsdWUiOjAuMH0sIm92ZXJyaWRlIjp0cnVlLCJ5YXciOiJUd28gUHJvdmlzaW9ucyIsInlhd19kZWZhdWx0X3ZhbHVlIjowLjAsInlhd19kZWxheV9lbmFibGUiOjEuMCwieWF3X2xlZnRfdmFsdWUiOi0yMy4wLCJ5YXdfbW9kaWZpZXIiOiJjZW50ZXIiLCJ5YXdfbW9kaWZpZXJfcmFuZG9taXphdGlvbiI6MC4wLCJ5YXdfbW9kaWZpZXJfdmFsdWUiOi01LjAsInlhd19yaWdodF92YWx1ZSI6NDEuMH0seyJib2R5X3lhdyI6WyJKaXR0ZXIiLCJ+Il0sImJvZHlfeWF3X3JhbmRvbWl6YXRpb24iOjAuMCwiYm9keV95YXdfdmFsdWUiOjYwLjAsImJvZHlfeWF3X3ZhbHVlMiI6NjAuMCwiZGVmZW5zaXZlX2xhYmVsIjp7ImNob2NrZV92YWx1ZSI6MC4wLCJlbmFibGUiOmZhbHNlLCJvc2FhIjpmYWxzZSwicGl0Y2giOiJkaXNhYmxlZCIsInBpdGNoX3ZhbHVlIjowLjAsInlhdyI6ImRpc2FibGVkIiwieWF3X3ZhbHVlIjowLjB9LCJvdmVycmlkZSI6dHJ1ZSwieWF3IjoiVHdvIFByb3Zpc2lvbnMiLCJ5YXdfZGVmYXVsdF92YWx1ZSI6MC4wLCJ5YXdfZGVsYXlfZW5hYmxlIjoxLjAsInlhd19sZWZ0X3ZhbHVlIjotMTguMCwieWF3X21vZGlmaWVyIjoiY2VudGVyIiwieWF3X21vZGlmaWVyX3JhbmRvbWl6YXRpb24iOjQuMCwieWF3X21vZGlmaWVyX3ZhbHVlIjowLjAsInlhd19yaWdodF92YWx1ZSI6MzMuMH0seyJib2R5X3lhdyI6WyJKaXR0ZXIiLCJ+Il0sImJvZHlfeWF3X3JhbmRvbWl6YXRpb24iOjEyLjAsImJvZHlfeWF3X3ZhbHVlIjo2MC4wLCJib2R5X3lhd192YWx1ZTIiOjYwLjAsImRlZmVuc2l2ZV9sYWJlbCI6eyJjaG9ja2VfdmFsdWUiOjAuMCwiZW5hYmxlIjpmYWxzZSwib3NhYSI6ZmFsc2UsInBpdGNoIjoiZGlzYWJsZWQiLCJwaXRjaF92YWx1ZSI6MC4wLCJ5YXciOiJkaXNhYmxlZCIsInlhd192YWx1ZSI6MC4wfSwib3ZlcnJpZGUiOnRydWUsInlhdyI6IlR3byBQcm92aXNpb25zIiwieWF3X2RlZmF1bHRfdmFsdWUiOjAuMCwieWF3X2RlbGF5X2VuYWJsZSI6MS4wLCJ5YXdfbGVmdF92YWx1ZSI6LTEzLjAsInlhd19tb2RpZmllciI6ImNlbnRlciIsInlhd19tb2RpZmllcl9yYW5kb21pemF0aW9uIjo0LjAsInlhd19tb2RpZmllcl92YWx1ZSI6LTcuMCwieWF3X3JpZ2h0X3ZhbHVlIjoyOC4wfSx7ImJvZHlfeWF3IjpbIkppdHRlciIsIn4iXSwiYm9keV95YXdfcmFuZG9taXphdGlvbiI6MzMuMCwiYm9keV95YXdfdmFsdWUiOjU0LjAsImJvZHlfeWF3X3ZhbHVlMiI6NTQuMCwiZGVmZW5zaXZlX2xhYmVsIjp7ImNob2NrZV92YWx1ZSI6MC4wLCJlbmFibGUiOmZhbHNlLCJvc2FhIjpmYWxzZSwicGl0Y2giOiJkaXNhYmxlZCIsInBpdGNoX3ZhbHVlIjowLjAsInlhdyI6ImRpc2FibGVkIiwieWF3X3ZhbHVlIjowLjB9LCJvdmVycmlkZSI6dHJ1ZSwieWF3IjoiVHdvIFByb3Zpc2lvbnMiLCJ5YXdfZGVmYXVsdF92YWx1ZSI6MC4wLCJ5YXdfZGVsYXlfZW5hYmxlIjoxLjAsInlhd19sZWZ0X3ZhbHVlIjotMjMuMCwieWF3X21vZGlmaWVyIjoiY2VudGVyIiwieWF3X21vZGlmaWVyX3JhbmRvbWl6YXRpb24iOjEyLjAsInlhd19tb2RpZmllcl92YWx1ZSI6Ny4wLCJ5YXdfcmlnaHRfdmFsdWUiOjQxLjB9LHsiYm9keV95YXciOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19yYW5kb21pemF0aW9uIjoxMDAuMCwiYm9keV95YXdfdmFsdWUiOjIuMCwiYm9keV95YXdfdmFsdWUyIjozMy4wLCJkZWZlbnNpdmVfbGFiZWwiOnsiY2hvY2tlX3ZhbHVlIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9zYWEiOmZhbHNlLCJwaXRjaCI6ImRpc2FibGVkIiwicGl0Y2hfdmFsdWUiOjAuMCwieWF3IjoiZGlzYWJsZWQiLCJ5YXdfdmFsdWUiOjAuMH0sIm92ZXJyaWRlIjp0cnVlLCJ5YXciOiJPbmUgUHJvdmlzaW9uIiwieWF3X2RlZmF1bHRfdmFsdWUiOjAuMCwieWF3X2RlbGF5X2VuYWJsZSI6MS4wLCJ5YXdfbGVmdF92YWx1ZSI6MC4wLCJ5YXdfbW9kaWZpZXIiOiJkaXNhYmxlZCIsInlhd19tb2RpZmllcl9yYW5kb21pemF0aW9uIjowLjAsInlhd19tb2RpZmllcl92YWx1ZSI6MC4wLCJ5YXdfcmlnaHRfdmFsdWUiOjAuMH1dXQ=="


-- @REGION: Menu
menu.menulist = {
    main = {
        logo = pui.create("\v\f<circle-user>", "", 1),
        selector = pui.create("\v\f<circle-user>", "\n\n", 1),
        sidebar = pui.create("\v\f<circle-user>", "\v•\r  sidebar", 1),
        socials = pui.create("\v\f<circle-user>", "\v•\r  socials", 2),

        extra = pui.create("\v\f<circle-user>", "extra", 1),
        under_extra = pui.create("\v\f<circle-user>", "hotkeys", 1),
        visuals = pui.create("\v\f<circle-user>", "main", 2),
        watermark_style = pui.create("\v\f<circle-user>", "\v•\r  Watermark", 1),
        accent_color = pui.create("\v\f<circle-user>", "\v•\r  Accent color", 1),
        misc = pui.create("\v\f<circle-user>", "misc", 2),
        updatelog = pui.create("\v\f<circle-user>", "Update log", 2),

        config_list = pui.create("\v\f<circle-user>", "\v•\r  config", 2),
        config_buttons = pui.create("\v\f<circle-user>", "\v•\r  config", 2),
    },
    antiaim = {
        switch = pui.create("\v\f<user-shield>", "\v•\r  Master Switch", 1),
        builder = {
            state = pui.create("\v\f<user-shield>", "\v•\r  state", 2),
            yaw = pui.create("\v\f<user-shield>", "\v•\r  Yaw", 2),
            yaw_modifier = pui.create("\v\f<user-shield>", "\v•\r  Yaw Modifier", 2),
            body_yaw = pui.create("\v\f<user-shield>", "\v•\r  Body Yaw", 2),
        },
        extra = pui.create("\v\f<user-shield>", "\v•\r  Extra", 1),
        hotkeys = pui.create("\v\f<user-shield>", "\v•\r  hotkeys", 1),
        defensive_aa = pui.create("\v\f<user-shield>", "\v•\r  defensive", 2),
    },
    other = {
        left_up = pui.create("\v\f<user-gear>", "\v•\r  Ragebot", 1),
        right_up = pui.create("\v\f<user-gear>", "\v•\r  Visuals", 1),
        left_down = pui.create("\v\f<user-gear>", "\v•\r  Misc", 2),
        right_down = pui.create("\v\f<user-gear>", "\v•\r  Other", 2),
    }
}

menu.main = {
    selector1 = menu.menulist.main.selector:list("      \aEBC53CC8\f<triangle-exclamation>\r  You're playing with the best script.", "\v\f<square-info>\r  Information"),
    sidebarlabel = menu.menulist.main.sidebar:label("                  \v\f<chart-bar>\r  Sidebar Customizate"),
    sidebarcombo = menu.menulist.main.sidebar:combo("", "Default", "Default + Build"),
    socials = menu.menulist.main.socials:label("\v\f<share-nodes>\r   \aDEFAULTSocials"),
    youtube_button = menu.menulist.main.socials:button("          \aFF3C3CFF\f<youtube>\r          ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@santymeaw2") end, true, "YouTube channel of lua creator, recomended subscribe! \n\n\aFF3C3CFF              ( Videos with lua )"),
    config = menu.menulist.main.socials:label("\v\f<folder-gear>\r  \aDEFAULTConfig"),
    config_button = menu.menulist.main.socials:button("\aFFBF00FF\f<star>\r MAIN", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://ru.neverlose.cc/market/item?id=BdSsCD") end, true, "Config with best settings of lua creator, but he has a better cfg - tournament! \n\n\aFF3C3CFF         ( best cfg for that price )"),
    config_button2 = menu.menulist.main.socials:button("\a664C6DFF\f<wand-magic-sparkles>\r TOUR", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://ru.neverlose.cc/market/item?id=oOYg2r") end, true, "Have more updates then MAIN and better setts for weapons! \n\n\aFF3C3CFF                    ( recomended )"),
    Discordserver = menu.menulist.main.socials:label("\v\f<badge-check>\r  \aDEFAULTDiscord"),
    Discordserver_button = menu.menulist.main.socials:button("          \a797FA3FF\f<discord>\r          ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/pe7SZNJGCa") end, true, "\aDEFAULTThis discord server will help you access other users' settings and user role. Open a ticket and be with us! \n\n\aFF3C3CFF                 ( recomended join )"),
    list = menu.menulist.main.config_buttons:list("", configs_database.ui_list),
    input = menu.menulist.main.config_buttons:input("\v\f<pen-to-square>\r  Name"),
    load = menu.menulist.main.config_buttons:button("\v\f<list-check>\r                                Load                                         ", nil, true, "load configuration"),
    import = menu.menulist.main.config_buttons:button("\v\f<arrow-down-to-bracket>          \aDEFAULTImport            ", nil, true, "import configuration"),
    export = menu.menulist.main.config_buttons:button("\v\f<arrow-up-from-bracket>          \aDEFAULTExport            ", nil, true, "export configuration"),
    create = menu.menulist.main.config_buttons:button("\v\f<layer-plus>\r    Create    ", nil, true, "create configuration"),
    save = menu.menulist.main.config_buttons:button("\v\f<floppy-disk>\r    Save     ", nil, true, "save configuration"),
    delete = menu.menulist.main.config_buttons:button("\v\f<layer-minus>\r    Delete    ", nil, true, "delete configuration"),


    -- emtylabel = menu.menulist.main.watermark_style:label("\n"),
    watermarkstyle_label = menu.menulist.main.watermark_style:label("                      \v\f<display>\r  Watermark Style"),
    watermarkstyle = menu.menulist.main.watermark_style:combo("", "Laura", "Laura Skinny", "Laura Bordered"),
    watermarkposition = menu.menulist.main.watermark_style:combo("\v\f<location-dot>\r  Position", "Left", "Down", "Right"),
    accent_color = menu.menulist.main.accent_color:color_picker("\v\f<paint-roller>\r   Accent Color", pui.colors.accent),
}

menu.antiaim = {
    masterswitch = menu.menulist.antiaim.switch:switch(" \v\f<square-check>\aDEFAULT   Override Anti-Aims"),
    extra = {
        avoidbackstab = menu.menulist.antiaim.extra:switch("\v\f<knife-kitchen>\aDEFAULT  Avoid Backstab"),
        safehead = menu.menulist.antiaim.extra:switch("\v\f<helmet-safety>\aDEFAULT  Safe Head", false, function(gear)
            return {
                selectable = gear:listable("", {"Air+Crouch Knife & Zeus"})
            }
        end),
        forcedef = menu.menulist.antiaim.extra:switch("\v\f<shield>\aDEFAULT   Force Defensive", false, function(gear)
            return {
                conditions = gear:listable("", menu.reference.main.force_defensive)
            }
        end)
    },
    hotkeys = {
        freestand = menu.menulist.antiaim.hotkeys:switch("\v\f<arrows-retweet>\aDEFAULT    Auto Regulation", false, function(gear)
            return {
                mod = gear:listable("\n", {"disable yaw mod", "body freestand"})
            }
        end),
        manuals = menu.menulist.antiaim.hotkeys:label("\v\f<arrows-left-right-to-line>\aDEFAULT    Manuals", function(gear)
            return {
                mod = gear:combo("\n\n", {"disabled", "left", "right", "forward"})
            }
        end)
    },

    angels = {
        selector = menu.menulist.antiaim.builder.state:combo("\v\f<list-dropdown>\aDEFAULT   State", menu.reference.main.conditions)
    },
}

menu.other = {
    fakelatency = menu.menulist.other.left_up:slider("\v\f<wifi>\r   \aDEFAULTPing Unlocker", 0, 200, 0, 1, function(self) if self == 0 then return 'Off' end end),

    dormant_aimbot = menu.menulist.other.left_up:switch("\v\f<eye-slash>\r  \aDEFAULTDormant Aimbot", false, function(gear)
                                return {
                                    hitboxes = gear:selectable("hitboxes", {"Head", "Chest", "Stomach", "Legs"}),
                                    hitchance = gear:slider("hitchance", 50, 85, 60, nil, "%"),
                                    damage = gear:slider("damage", -1, 130, -1, nil, function(value)
                                                    if value == -1 then
                                                        return "AI"
                                                    end
                                                    
                                                    if value > 100 then
                                                        return "+" .. (value - 100)
                                                    end
                                                    
                                                    return nil
                                                end),
                                    auto_scope = gear:switch("auto scope")
                                }
                            end),

    aimbot_logs = menu.menulist.other.left_up:switch("\v\f<reel>\r    \aDEFAULTAimbot Logs", false, function(gear)
        return {
            loglist = gear:listable("\n", "Console", "Screen", "Render"),
            hitswitch = gear:switch("\v\f<person-circle-exclamation>\r  Hit", false, {pui.colors.accent}),
            missswitch = gear:switch("\v\f<person-circle-question>\r  Miss", false, {color(255, 68, 68)}),
        }
    end),

    aspectratio = menu.menulist.other.left_down:switch("\v\f<camera-viewfinder>\r   \aDEFAULTAspect Ratio", false, function(gear)
        return 
        {
            amount = gear:slider("Amount", 0, 200, 0, 0.01),
        }
    end),

    scope_overlay = menu.menulist.other.right_up:switch("\v\f<telescope>\r  \aDEFAULTScope Overlay", false, function(gear)
                            return {
                                scope_style = gear:combo('select style', {'default', 'reversed'}),
                                remove_line = gear:selectable('exclude line', {'left', 'right', 'up', 'down'}),
                                scope_gap = gear:slider("scope gap", 0, 500, 7),
                                scope_size = gear:slider("scope size", 0, 1000, 105),
                                scope_color = gear:color_picker("scope color", color(255, 255, 255)),
                            }
                            end),

    viewmodel = menu.menulist.other.left_down:switch("\v\f<mountain-sun>\r  \aDEFAULTViewmodel Changer", false, function(gear)
                                    return {
		                                fov = gear:slider("FOV", 0, 1000, 600, 0.1),
		                                x = gear:slider("x", -100, 100, 10, 0.1),
		                                y = gear:slider("y", -100, 100, 10, 0.1),
		                                z = gear:slider("z", -100, 100, -10, 0.1),
                                    }
                            end),
    clantag = menu.menulist.other.left_down:switch("\v\f<table-tree>\r    Clantag Spammer", false),

    hitmarker = menu.menulist.other.right_up:switch("\v\f<highlighter>\r   \aDEFAULTHit Marker", false, function(gear)
                                    return {
                                        color = gear:color_picker("color", color(83, 168, 139, 255))
                                    }
                            end),

    damage_indicator = menu.menulist.other.right_up:switch("\v\f<rectangle-ad>\r   Damage Indicator"),

    hitchance_indicator = menu.menulist.other.right_up:switch("\v\f<crosshairs-simple>\r    Hitchance Indicator"),

    SideIndicators = menu.menulist.other.right_up:switch("\v\f<memo-pad>\r     Side Indicators"),

    trashtalk = menu.menulist.other.left_down:switch("\v\f<trash>\r     \aDEFAULTTrashtalk"),
    keep_model_transparency = menu.menulist.other.right_up:switch("\v\f<face-dotted>\r    Keep Model Transparency", false),
    nofalldamage = menu.menulist.other.right_down:switch(" \v\f<person-falling>\r    \aDEFAULTNo Fall Damage"),
    fastladder = menu.menulist.other.right_down:switch("\v\f<water-ladder>\r    \aDEFAULTFast Ladder"),
    nade_throw_fix = menu.menulist.other.right_down:switch("\v\f<bomb>\r    Nade Throw Fix", false),
    super_toss = menu.menulist.other.right_down:switch("\v\f<bullseye-arrow>\r    Super Toss", false),
}
-- @ENDREGION
-- @REGION: profile menu

local antiaim do
    antiaim_builder = {}

    -- @REGION: antiaimbot:ui
    menu.antiaim.extra.avoidbackstab:depend(menu.antiaim.masterswitch)
    if info._lua.build == "Live" then
        menu.antiaim.extra.safehead:depend(menu.antiaim.masterswitch)
        menu.antiaim.extra.safehead:disabled(true)
    else
        menu.antiaim.extra.safehead:depend(menu.antiaim.masterswitch)
        menu.antiaim.extra.safehead:disabled(false)
    end
    menu.antiaim.extra.forcedef:depend(menu.antiaim.masterswitch)
    menu.antiaim.angels.selector:depend(menu.antiaim.masterswitch)
    menu.antiaim.hotkeys.freestand:depend(menu.antiaim.masterswitch)
    menu.antiaim.hotkeys.manuals:depend(menu.antiaim.masterswitch)

    for x, y in ipairs(menu.reference.main.conditions) do
        antiaim_builder[x] = {}
        antiaim_builder[x].override = menu.menulist.antiaim.builder.state:switch("\v\f<user-check>\aDEFAULT  Override")
                            :depend(
                                menu.antiaim.masterswitch, selector_antiaim, {menu.antiaim.angels.selector, menu.reference.main.conditions[x]},
                                {menu.antiaim.angels.selector, function() return menu.reference.main.conditions ~= "shared" end })

        antiaim_builder[x].yaw_default_value = menu.menulist.antiaim.builder.yaw:slider("Value", -90, 90, 0, 1, "°", false, function(gear)
            return {
                yaw_left_value = gear:slider("Left", -90, 90, 0)
                                    :depend(antiaim_builder[x].override,
                                        {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                        {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),
                
                yaw_right_value = gear:slider("Right", -90, 90, 0)
                                    :depend(antiaim_builder[x].override,
                                        {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                        {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),
                yaw_randomization = gear:slider("Randomization", 0, 100, 0, 1, "%")
                                    :depend(antiaim_builder[x].override,
                                        {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                        {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),
    
                                    }
            end)
                                    :depend(antiaim_builder[x].override,
                                        {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                        {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch)

        antiaim_builder[x].yaw_modifier =  menu.menulist.antiaim.builder.yaw:combo("Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"}, false, function(gear)
            return {
                yaw_modifier_value = gear:slider("Value", -90, 90, 0)
                                    :depend(antiaim_builder[x].override,
                                        {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                        {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),
                
                                    }
            end)
                                    :depend(antiaim_builder[x].override,
                                            {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                            {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch)

                
        antiaim_builder[x].body_yaw =  menu.menulist.antiaim.builder.yaw:selectable("Body Yaw", {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"}, false, function(gear)
            return {
                yaw_delay_enable = gear:slider("Delay", 1, 10, 0, 1, "t")
                                    :depend(antiaim_builder[x].override,
                                            {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                            {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),

                body_yaw_value = gear:slider("Left Value", 0, 60, 0, 1, "°")
                                    :depend(antiaim_builder[x].override,
                                            {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                            {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),
                body_yaw_value2 = gear:slider("Right Value", 0, 60, 0, 1, "°")
                                    :depend(antiaim_builder[x].override,
                                            {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                            {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),

                body_yaw_randomization = gear:slider("Random", 0, 100, 0, 1, "%")
                                    :depend(antiaim_builder[x].override,
                                            {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                            {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),
                                    }
            end)
                                    :depend(antiaim_builder[x].override,
                                            {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                            {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch)
                                                      
        
        antiaim_builder[x].defensive_label = menu.menulist.antiaim.defensive_aa:label("\v\f<shield>\aDEFAULT    Defensive AA", function(gear)
                            return {
                                enable = gear:switch("\aDEFAULTEnable")
                                                    :depend(antiaim_builder[x].override,
                                                        {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                                        {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),
                                
                                osaa = gear:switch("\aDEFAULTOn OSAA")
                                                    :depend(antiaim_builder[x].override,
                                                        {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                                        {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),

                                pitch = gear:combo("\aDEFAULTPitch", { "disabled", "custom", "up", "down", "zero", "random", "progressive"})
                                                    :depend(antiaim_builder[x].override,
                                                        {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                                        {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),

                                pitch_value = gear:slider("\aDEFAULTValue", -89, 89, 0)
                                                    :depend(antiaim_builder[x].override,
                                                        {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                                        {menu.antiaim.angels.selector, menu.reference.main.conditions[x], }, menu.antiaim.masterswitch),
                                
                                yaw = gear:combo("\aDEFAULTYaw", { "disabled", "custom", "jitter", "opposite", "spin", "random"})
                                                    :depend(antiaim_builder[x].override,
                                                        {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                                        {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),

                                yaw_value = gear:slider("\aDEFAULTValue", -180, 180, 0),

                                chocke_value = gear:slider("\aDEFAULTChoke Value", 0, 7, 0, nil, "", "break command number\ndefault - 0\nbreakable - 5\nextra - 7")
                                                    :depend(antiaim_builder[x].override,
                                                        {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                                        {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch),

                                                    }
                            end)
                            :depend(antiaim_builder[x].override,
                                {menu.antiaim.masterswitch, function() if(x == 1) then return true else return antiaim_builder[x].override:get() end end},
                                {menu.antiaim.angels.selector, menu.reference.main.conditions[x]}, menu.antiaim.masterswitch)
    end    
    -- @ENDREGION

    local aa_builder_visibility = function()
        for x, y in ipairs(menu.reference.main.conditions) do
            antiaim_builder[x].defensive_label.pitch_value:visibility(antiaim_builder[x].defensive_label.pitch:get() == "custom" or antiaim_builder[x].defensive_label.pitch:get() == "random" or antiaim_builder[x].defensive_label.pitch:get() == "progressive")
            antiaim_builder[x].defensive_label.yaw_value:visibility(antiaim_builder[x].defensive_label.yaw:get() == "custom" or antiaim_builder[x].defensive_label.yaw:get() == "jitter" or antiaim_builder[x].defensive_label.yaw:get() == "random")
        end
    end

    local player_state = function()
        local local_player = entity.get_local_player()
        if not local_player then 
            return "not connected" 
        end
        local on_ground = bit.band(local_player.m_fFlags, 1) == 1
        local jump = bit.band(local_player.m_fFlags, 1) == 0
        local crouch = local_player.m_flDuckAmount > 0.7
        local vx, vy, vz = local_player.m_vecVelocity.x, local_player.m_vecVelocity.y, local_player.m_vecVelocity.z
        local move = math.sqrt(vx ^ 2 + vy ^ 2) > 5

        if jump and crouch then 
            return menu.reference.main.conditions[8] 
        end

        if menu.antiaim.hotkeys.freestand:get() then 
            return menu.reference.main.conditions[9] 
        end

        if reference.antiaim.misc.fakeduck:get() then 
            return menu.reference.main.conditions[10] 
        end

        if crouch and move then 
            return menu.reference.main.conditions[6] 
        end

        if jump then 
            return menu.reference.main.conditions[7] 
        end

        if crouch then
            return menu.reference.main.conditions[5] 
        end

        if on_ground and reference.antiaim.misc.slowwalk:get() and move then 
            return menu.reference.main.conditions[4] 
        end

        if on_ground and not move then 
            return menu.reference.main.conditions[2] 
        end

        if on_ground and move then 
            return menu.reference.main.conditions[3] 
        end
    end

    local stateid = function()
        if antiaim_builder[2].override:get() and player_state() == menu.reference.main.conditions[2] then 
            return 2
        elseif antiaim_builder[3].override:get() and player_state() == menu.reference.main.conditions[3] then 
            return 3
        elseif antiaim_builder[4].override:get() and player_state() == menu.reference.main.conditions[4] then 
            return 4
        elseif antiaim_builder[5].override:get() and player_state() == menu.reference.main.conditions[5] then 
            return 5
        elseif antiaim_builder[6].override:get() and player_state() == menu.reference.main.conditions[6] then 
            return 6
        elseif antiaim_builder[7].override:get() and player_state() == menu.reference.main.conditions[7] then 
            return 7
        elseif antiaim_builder[8].override:get() and player_state() == menu.reference.main.conditions[8] then 
            return 8
        elseif antiaim_builder[9].override:get() and player_state() == menu.reference.main.conditions[9] then 
            return 9
        else
            return 1
        end
    end

    local freestand_antiaim = function(fs, fs_global, fs_gear, dis_yaw, body_fs)

        if fs:get() then
            fs_global:override(true)
        else
            fs_global:override(false)
        end

        if fs_gear:get("disable yaw mod") then
            dis_yaw:override(true)
        else
            dis_yaw:override(false)
        end

        if fs_gear:get("body freestand") then
            body_fs:override(true)
        else
            body_fs:override(false)
        end

    end

    local manual_antiaim = function(manual_type, yaw_offset)
        if manual_type:get() == "left" then
            yaw_offset:override(-90)
        end
        if manual_type:get() == "right" then
            yaw_offset:override(90)
        end
        if manual_type:get() == "forward" then
            yaw_offset:override(180)
        end
    end

    local safehead = function(cmd, stateid)
        if not menu.antiaim.extra.safehead:get() then return end
        if stateid == 8 and menu.main.extra.safehead.selectable:get(1) and entity.get_local_player():get_player_weapon(false):get_weapon_info().weapon_type == 0 then
            reference.antiaim.angels.yaw.hidden:set(false)
            reference.antiaim.angels.yaw.offset:override(0)
            reference.antiaim.angels.body_yaw.options:override({})
            reference.antiaim.angels.body_yaw.inverter:override(true)
        end
    end

    local function randomize_value(original_value, percent)
        local min_range = original_value - (original_value * percent / 100)
        local max_range = original_value + (original_value * percent / 100)
        return math.random(min_range, max_range)
    end    
    
    is_inverted = false
    ticks = 0
    switch = false
    yaw_amount = 0
    local setup = function(cmd, stateid)
        if not menu.antiaim.masterswitch:get() then return end
    
        if cmd.choked_commands == 0 then 
            reference.antiaim.angels.enable:override(true)
            reference.antiaim.angels.pitch:override("down")
            reference.antiaim.angels.yaw:override("backward")
            reference.antiaim.angels.yaw.base:override("at target")
            reference.antiaim.angels.yaw_modifier:override(antiaim_builder[stateid].yaw_modifier:get())
            
            local yaw_modifier_value = antiaim_builder[stateid].yaw_modifier.yaw_modifier_value:get()
            local yaw_randomization = antiaim_builder[stateid].yaw_default_value.yaw_randomization:get() / 100
    
            local final_yaw_modifier_offset = yaw_modifier_value
            if yaw_randomization > 0 and antiaim_builder[stateid].yaw_modifier:get() ~= "disabled" then
                local random_offset = utils.random_int(-90 * yaw_randomization, 90 * yaw_randomization)
                final_yaw_modifier_offset = yaw_modifier_value + random_offset
                final_yaw_modifier_offset = math.clamp(final_yaw_modifier_offset, -180, 180)
            end

            reference.antiaim.angels.yaw_modifier_offset:set(final_yaw_modifier_offset)
            local jit_amount = randomize_value(antiaim_builder[stateid].yaw_modifier.yaw_modifier_value:get(), yaw_randomization)
            if antiaim_builder[stateid].yaw_modifier:get() == 'Center' then
                yaw_amount = rage.antiaim:inverter() and (yaw_l + jit_amount / 2) or (yaw_r - jit_amount / 2)
            elseif antiaim_builder[stateid].yaw_modifier:get() == 'Offset' then
                yaw_amount = rage.antiaim:inverter() and yaw_l or (yaw_r - jit_amount / 2)
            elseif antiaim_builder[stateid].yaw_modifier:get() == 'Random' then
                yaw_amount = rage.antiaim:inverter() and (yaw_l + jit_amount / 2) or (yaw_r - jit_amount / 2)
            elseif antiaim_builder[stateid].yaw_modifier:get() == '3-Way' then
                local phase = globals.tickcount() % 3
                if phase == 0 then 
                    yaw_amount = rage.antiaim:inverter() and (yaw_l + jit_amount / 2) or yaw_r
                elseif phase == 1 then 
                    yaw_amount = rage.antiaim:inverter() and yaw_l or yaw_r
                else
                    yaw_amount = rage.antiaim:inverter() and yaw_l or (yaw_r - jit_amount / 2)
                end
            else
                yaw_amount = rage.antiaim:inverter() and yaw_l or yaw_r
            end
    
            reference.antiaim.angels.body_yaw:override(true)
        
            is_inverted = not rage.antiaim:inverter()
        
            if antiaim_builder[stateid].body_yaw.yaw_delay_enable:get() then 
                if antiaim_builder[stateid].body_yaw.yaw_delay_enable:get() > 1 then
                    ticks = ticks + 1.5
                
                    if ticks > antiaim_builder[stateid].body_yaw.yaw_delay_enable:get() then
                        ticks = 0
                        switch = not switch
                    end
                
                    is_inverted = switch
                end     
            end
        
            if antiaim_builder[stateid].body_yaw.yaw_delay_enable:get() then
                if antiaim_builder[stateid].body_yaw.yaw_delay_enable:get() > 1 then
                    reference.antiaim.angels.body_yaw.inverter:override(is_inverted)
                    reference.antiaim.angels.body_yaw.options:override("")
                else
                    reference.antiaim.angels.body_yaw.inverter:override()
                    reference.antiaim.angels.body_yaw.options:override(antiaim_builder[stateid].body_yaw:get())
                end  
            else
                reference.antiaim.angels.body_yaw.options:override(antiaim_builder[stateid].body_yaw:get())
            end
        
            reference.antiaim.angels.body_yaw.left_limit:override(antiaim_builder[stateid].body_yaw.body_yaw_randomization:get() > 0 and utils.random_int(antiaim_builder[stateid].body_yaw.body_yaw_value:get() - (antiaim_builder[stateid].body_yaw.body_yaw_randomization:get()/100) * antiaim_builder[stateid].body_yaw.body_yaw_value:get(), antiaim_builder[stateid].body_yaw.body_yaw_value:get()) or antiaim_builder[stateid].body_yaw.body_yaw_value:get())
            reference.antiaim.angels.body_yaw.right_limit:override(antiaim_builder[stateid].body_yaw.body_yaw_randomization:get() > 0 and utils.random_int(antiaim_builder[stateid].body_yaw.body_yaw_value2:get() - (antiaim_builder[stateid].body_yaw.body_yaw_randomization:get()/100) * antiaim_builder[stateid].body_yaw.body_yaw_value2:get(), antiaim_builder[stateid].body_yaw.body_yaw_value2:get()) or antiaim_builder[stateid].body_yaw.body_yaw_value2:get())
            
            reference.antiaim.angels.body_yaw.freestanding:override("Off") 
    
        
            if antiaim_builder[stateid].yaw_default_value:get() then
                yaw_add = is_inverted and antiaim_builder[stateid].yaw_default_value.yaw_left_value:get() or antiaim_builder[stateid].yaw_default_value.yaw_right_value:get()
            else
                yaw_add = antiaim_builder[stateid].yaw_default_value:get()
            end
        
            if antiaim_builder[stateid].body_yaw.yaw_delay_enable:get() then
                if is_inverted then
                    yaw_add = yaw_add + final_yaw_modifier_offset * 0.5
                else
                    yaw_add = yaw_add - final_yaw_modifier_offset * 0.5
                end

            end

            reference.antiaim.angels.yaw.offset:override(yaw_add)
        end
        
        --safehead(cmd, stateid)
        
        freestand_antiaim(
            menu.antiaim.hotkeys.freestand,
            reference.antiaim.angels.freestanding,
            menu.antiaim.hotkeys.freestand.mod,
            reference.antiaim.angels.freestanding.disable_yaw_modifiers,
            reference.antiaim.angels.freestanding.body_freestanding
        )
        manual_antiaim(
            menu.antiaim.hotkeys.manuals.mod,
            reference.antiaim.angels.yaw.offset
        )

        reference.antiaim.angels.yaw.avoid_backstab:override(menu.antiaim.extra.avoidbackstab:get())
    end

    local force_defensive = function(stateid)
        if menu.antiaim.extra.forcedef:get(stateid - 1) then
            reference.ragebot.double_tap.options:override("Always On")
        else
            reference.ragebot.double_tap.options:override("On Peek")
        end
    end

    local defensive_choke = function(cmd, value)
        cmd.force_defensive = cmd.command_number % value == 0
    end

    local setup_defensive = function(cmd, stateid)
        if antiaim_builder[stateid].defensive_label.enable:get() then
            reference.antiaim.angels.yaw.hidden:override(true)
            defensive_choke(cmd, antiaim_builder[stateid].defensive_label.chocke_value:get())
        else
            reference.antiaim.angels.yaw.hidden:override(false)
            defensive_choke(cmd, 0)
        end

        if antiaim_builder[stateid].defensive_label.osaa:get() then
            reference.ragebot.osaa.options:override("Break LC")
        else
            reference.ragebot.osaa.options:override("favor fire rate")
        end

        if antiaim_builder[stateid].defensive_label.pitch:get() == "disabled" then
            rage.antiaim:override_hidden_pitch(89)
        elseif antiaim_builder[stateid].defensive_label.pitch:get() == "custom" then
            rage.antiaim:override_hidden_pitch(antiaim_builder[stateid].defensive_label.pitch_value:get())
        elseif antiaim_builder[stateid].defensive_label.pitch:get() == "up" then
            rage.antiaim:override_hidden_pitch(-89)
        elseif antiaim_builder[stateid].defensive_label.pitch:get() == "down" then
            rage.antiaim:override_hidden_pitch(89)
        elseif antiaim_builder[stateid].defensive_label.pitch:get() == "zero" then
            rage.antiaim:override_hidden_pitch(0)
        elseif antiaim_builder[stateid].defensive_label.pitch:get() == "random" then
            rage.antiaim:override_hidden_pitch(utils.random_int(-antiaim_builder[stateid].defensive_label.pitch_value:get(), antiaim_builder[stateid].defensive_label.pitch_value:get()))
        elseif antiaim_builder[stateid].defensive_label.pitch:get() == "progressive" then
            rage.antiaim:override_hidden_pitch(((globals.curtime * 7) % 2 - 1) * antiaim_builder[stateid].defensive_label.pitch_value:get())
        end

        if antiaim_builder[stateid].defensive_label.yaw:get() == "disabled" then
            rage.antiaim:override_hidden_yaw_offset(0)
        elseif antiaim_builder[stateid].defensive_label.yaw:get() == "custom" then
            rage.antiaim:override_hidden_yaw_offset(antiaim_builder[stateid].defensive_label.yaw_value:get())
        elseif antiaim_builder[stateid].defensive_label.yaw:get() == "jitter" then
            rage.antiaim:override_hidden_yaw_offset((rage.antiaim:inverter() and -90 or 90))
        elseif antiaim_builder[stateid].defensive_label.yaw:get() == "opposite" then
            rage.antiaim:override_hidden_yaw_offset(180)
        elseif antiaim_builder[stateid].defensive_label.yaw:get() == "spin" then
            rage.antiaim:override_hidden_yaw_offset(globals.curtime * (70 * 12) % 360)
        elseif antiaim_builder[stateid].defensive_label.yaw:get() == "random" then
            rage.antiaim:override_hidden_yaw_offset(utils.random_int(-antiaim_builder[stateid].defensive_label.yaw_value:get(), antiaim_builder[stateid].defensive_label.yaw_value:get()))
        end
        
        -- Override hidden antiaim

    end

    local return_builder = function()
        antiaim_build = antiaim_builder
        return antiaim_build
    end

    local safe_head = function(stateid)
        if not menu.antiaim.extra.safehead:get() then return end
        if menu.antiaim.extra.safehead.selectable:get(1) then
            if entity.get_local_player():get_player_weapon() == nil then return end
            local knife = entity.get_local_player():get_player_weapon():get_classname() == "CKnife"
            if (knife) and stateid == 8 then
                reference.antiaim.angels.yaw.hidden:set(false)
                reference.antiaim.angels.yaw.offset:override(0)
                reference.antiaim.angels.yaw.base:override("At Target")
                reference.antiaim.angels.yaw_modifier:override("Disabled")
                reference.antiaim.angels.body_yaw.options:override("")
                reference.antiaim.angels.body_yaw.left_limit:override(0)
                reference.antiaim.angels.body_yaw.right_limit:override(0)
                reference.antiaim.angels.body_yaw.freestanding:override("Off")
            end
        end
    end


    events.createmove:set(function(cmd)
        local stateid = stateid()
        setup(cmd, stateid)
        force_defensive(stateid)
        setup_defensive(cmd, stateid)
        safe_head(stateid)
        return_builder()
    end)

    events.render:set(function()
        aa_builder_visibility()
    end)
end

local verdana = render.load_font("Verdana", 16, "ad")
local calibri = render.load_font("Calibri", 24, "bad")

local bomb_img = render.load_image("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x64\x00\x00\x00\x5C\x08\x03\x00\x00\x00\xAF\x15\xE0\xA6\x00\x00\x00\x01\x73\x52\x47\x42\x01\xD9\xC9\x2C\x7F\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0B\x13\x00\x00\x0B\x13\x01\x00\x9A\x9C\x18\x00\x00\x02\xDF\x50\x4C\x54\x45\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x76\x99\x69\x74\x00\x00\x00\xF5\x74\x52\x4E\x53\x00\x01\x43\x93\x58\x06\x5A\xFB\xFF\xFD\x96\x04\xD5\xF9\x02\x0E\xE3\x18\x16\xEA\x2B\x1B\xEF\x36\x29\x73\x72\x1E\xF2\x3F\x75\x6B\x20\xEB\xF4\x32\x21\xF6\x47\x2F\xE7\xE2\x37\x5E\xB7\x0F\x23\xF8\x51\x08\xB3\x9A\x7D\xF7\x63\x00\x70\x7A\xC1\x25\x6E\x2D\xE0\x62\xFC\xC2\x28\x76\xAE\x88\x0B\xC9\x5D\x7E\xFA\xE9\x27\x5C\xDF\x12\x31\x84\xD8\x8C\xCF\x97\x3A\x8A\x03\xAC\xDA\x1C\x6C\x2E\x42\x8F\x7B\xA1\x4B\x95\x10\xCA\x13\x55\x3D\x1A\x33\x0A\x4E\x69\x82\xBB\x41\xC7\x80\x87\x91\x9E\xA6\xAA\x86\x7F\x5F\x26\xDC\xFE\x49\xE8\x17\xC3\x46\x89\x92\xBA\x2C\xC0\xB8\xA3\x9F\xA8\xAF\xB1\xB5\xBC\xD4\x7C\xF3\x9D\x24\x0D\x8E\x5B\x05\xD9\xD1\x99\xF1\xCC\xCB\x9B\x4F\x14\xCE\xC5\xCD\x19\x30\xF5\x07\xDE\x15\xA4\x1D\x11\xE5\x83\x2A\xA0\x71\xD6\xD0\xC6\xB9\xA9\x6D\x52\x35\xDD\x0C\xE4\x64\xED\xBF\xC4\x8D\x77\x85\x8B\x90\xEE\xE6\xA5\x78\xEC\x09\x60\x1F\x81\xAB\x9C\x98\x38\x61\x4A\xB2\x34\x4C\xDB\xA7\xD2\x45\x39\x53\xB0\xF0\xBD\x94\x4D\xB4\x44\x54\x3E\xA2\x22\x59\x6A\xE1\xD7\xAD\x40\x48\x3B\xBE\x65\x74\x34\x72\x01\xD4\x00\x00\x07\x6E\x49\x44\x41\x54\x78\x9C\xED\x9A\xF9\x5B\xD4\x46\x18\xC7\xB3\x22\x32\x2B\x8B\x8A\x58\xD0\x42\xE5\x10\x54\x28\x42\x11\x70\x11\x11\x10\x95\x22\x28\x56\x2C\x88\x14\x05\xE4\xB4\x1C\xC5\x20\x60\x45\xBC\x51\x01\xA1\x88\x88\xA2\xA2\x78\x71\x15\x15\x0B\x88\x78\x0B\x15\x54\x14\xCF\x0A\x78\xB6\xB5\xD5\x5A\xDB\xDA\xEB\x0F\x68\x66\x26\xBB\x9B\x84\xDD\x25\x86\xA5\xCF\xD3\x3E\xBE\xBF\x64\xE7\x9B\xF7\x7D\x3F\x39\x66\x92\x77\x26\x4B\x10\x02\x4C\x34\x40\x6B\xA0\xB6\x90\xC0\x37\xB1\x41\x3A\x40\x3C\xB8\x9F\x19\xBA\x12\x00\x80\xDE\x90\xFE\x85\x0C\x1D\x46\x41\x80\x7E\xFF\x42\x86\x1B\x40\xC8\x88\xFE\x85\xBC\x63\x08\x21\x46\x9A\x4B\x38\x72\xD4\xBB\x3D\x0E\xD9\xD8\x04\x42\xDE\xE3\xA8\xA2\x91\xA3\x4D\xCD\x04\x31\xF4\xCD\x01\xB0\x18\xC3\x11\x2D\xAD\x20\x64\x2C\x47\x1D\x37\x1E\x00\x6B\x1B\x21\x90\xF7\x61\x3A\xDB\x09\x6C\xD1\xCE\x1E\xAA\x1F\xB0\x45\x87\x89\x50\x74\x14\x02\xB1\x13\xC3\x50\x27\x8E\xE8\x0C\xC5\x49\x2C\x4D\xEA\xA2\x03\xC5\xC9\x42\x20\x84\x2B\x0C\x15\xB3\x6F\xCB\x14\x3D\x28\xBA\xB1\xB4\xA9\xE3\xA1\xE6\x6E\x26\x08\xE2\xE1\x09\x83\xA7\x39\x30\x35\x2F\xA4\x4D\x67\x4A\xBA\x33\xA0\x04\x66\x0A\x62\x10\xDE\x1F\xA2\x68\x1F\xA6\x36\x02\x49\xB3\x18\x8A\xD4\xC3\x17\x4A\x7E\xB3\x85\x41\x88\x39\x28\xA3\xFF\x5C\x86\xF4\x11\x92\xE6\x31\x14\xCB\x00\x24\xCD\x17\xFC\xA8\xF9\x18\xC5\x07\x32\xE2\x83\x90\xB2\x40\x21\x04\x2F\x44\x4A\xC8\x27\x42\x19\x44\x28\xBA\x03\x16\x8B\x14\xCA\x62\x94\x32\x4C\x21\x8C\x45\x02\x08\x17\xCC\x90\xDD\x95\x08\x85\xB2\x04\x09\x91\xF2\x76\x14\xF6\x88\x8E\x11\x0E\x21\xC6\xC4\x42\x8B\x53\x08\x4B\x91\xF0\xA9\xBC\x1D\x9F\x90\xE8\x96\xE4\xF8\x59\x72\x1F\x18\x6F\xED\x7F\x63\x52\xE3\x50\xDB\x65\x83\x44\xB2\x66\x82\xA9\x9B\x13\x49\x92\x29\xCB\x23\xB1\x05\xA6\xA6\xA5\xF3\xB4\x88\x40\x18\xA0\xB5\xE2\x73\x97\x95\x19\x6C\x86\xFE\x74\x77\xAA\x57\xDB\x7B\xE1\x96\x03\x69\x0F\x34\x61\xAB\x18\x7D\x7C\xC8\x94\xF9\xAB\x32\x91\xBA\x1A\x0B\x6E\x62\x8D\x30\xA8\x27\xB5\xB7\x8C\x61\xB6\x60\x0D\xAD\x19\xAC\xC5\xCA\x3A\x0D\x31\x80\xF3\x7A\x9C\xD0\x7B\x83\xBF\x4C\xB2\x5A\x42\x63\xFD\xD5\x05\xBE\x91\x85\xA2\x7C\x1B\xCD\xE5\x42\xD6\x26\xD9\xB9\x19\xF0\xCB\x10\xB0\x79\x4B\x76\x8E\xC2\x22\xB2\xD3\x72\xD3\x17\x6E\xCD\x9B\x98\xBF\x25\xEB\x8B\x02\xEC\xB2\x0D\xE5\x93\x47\x78\x92\x51\xF2\x9B\x54\xC8\x07\x61\xA1\xF6\x6D\x14\x8B\x9D\x52\x98\x10\xCF\xED\x45\x0C\x0F\x5E\x7D\xCB\x7A\x07\x0F\x48\x31\x03\xE2\xB7\x73\x17\xD3\x83\x57\xE7\x2A\xD9\xA5\x34\x3B\x1B\xA2\x25\x87\x18\x6A\x71\x0A\x65\x3E\x0C\x20\x11\x29\xC9\xCD\x85\x04\xA2\x06\xF5\x8A\xCB\x32\xD2\xE5\x78\xF0\x82\xEC\x56\xC7\x90\x41\xF6\xA0\xC6\xDE\xD2\xD5\x5C\x04\x4F\xC8\x3E\x3E\x90\xFD\xA8\x51\x76\x40\x89\x07\x2F\xC8\x41\x3E\x90\xED\xAA\x3D\x78\x41\x0E\xF1\x81\xA4\xF6\x11\x12\x0D\x3D\x63\xE2\x0E\x1F\x11\x89\xCA\x2B\x66\x0E\x25\x2A\xC3\x4B\x8D\xE3\x35\x0D\x29\x80\x9E\xB9\x85\x3A\x55\xD5\xC3\xFD\x80\xD5\x72\x62\x52\xA6\x78\x8D\x62\x42\x41\x43\x72\xFA\x08\x91\x48\x29\xCF\x2F\x01\x30\xA9\x39\x7A\x0C\x96\x75\xC7\xA9\x9F\xB5\x5C\xC8\x89\xBE\x42\xE0\x38\xB1\xFC\x2A\x2B\xD6\x41\x64\x63\x10\xB8\x96\x98\xBD\xA0\xC4\x67\x82\xA6\x21\x75\x6A\x8B\x5C\x0D\x41\x02\x82\xFF\x05\x48\x88\xDA\x45\x0E\x1A\x82\x0B\xD9\xF1\xC3\xAA\x4A\x0A\xEA\xF7\x35\xB8\x9E\x9C\x91\xDE\xB8\x67\xDE\xA9\xA6\xD3\x4B\x45\xFC\x20\x67\x1C\x78\x40\xB2\x55\x1C\xB4\xA1\x1B\x3F\x88\xFB\x59\x1E\x90\x34\x55\x57\x66\x95\x4A\x88\x39\xAA\x79\xF6\xE2\xC6\xB9\x28\x1E\x90\x74\x55\x10\x13\x55\x90\xCC\xF3\x28\x44\x82\x5B\x17\xD4\x2E\xA4\xF4\x06\x89\x56\x05\xB9\x38\x81\x09\x11\x5F\xCA\x6B\x6E\x19\xCD\xB0\x96\xC9\xDB\x66\x91\x49\x5F\xA7\x6C\xB8\xDC\xDC\xBA\xD1\x96\x03\x11\x5B\xB4\x5D\x71\x2F\x91\x48\x0E\xBB\xE6\x5F\x6D\xBD\x66\xDA\x14\xA3\x02\xD2\x6E\x44\x5C\x2F\x52\x40\x78\x59\x23\x82\x1C\xF5\x56\xD2\xDD\x95\x07\xB4\x4A\x45\xE1\x37\x04\x41\x94\x9A\xCC\xC5\x6A\xF3\xAC\xB8\x8E\xCA\xA8\x51\xA8\x51\x65\x46\x94\x5F\x18\xCB\x80\x18\xEE\x27\x6F\xE6\x9A\x50\xDD\xAC\x99\x24\xB3\x9D\xA9\x6E\xB1\x35\x29\xE9\x96\x0E\x35\x4A\xC3\x48\xF2\xB6\x2F\x5F\x48\xBD\x11\x7E\x8D\xD7\xC0\x86\xAF\x87\x94\xB8\x03\xEE\x32\x20\xF7\xE0\x3E\x12\x80\x32\xB8\x0D\x03\x7A\x41\xD4\x46\xBA\x05\xB4\x75\xC0\xF6\x49\xEC\x93\xDB\x1B\xA4\x74\x28\x6E\x49\xBF\x81\xAD\xFB\xC1\x44\x67\x3B\x58\xC4\x80\xA0\xC5\xAD\x2E\x00\x3A\xF1\xD6\x1F\xD5\xBD\x81\xA0\x1B\x3D\x09\x22\xB1\xCF\x83\x5E\x20\x7A\xB0\xA0\xDC\x71\xF9\xA1\x44\xD2\x4E\xB5\x2A\x3A\x08\xDD\x13\x78\x69\x4E\x06\x81\x67\x45\x3C\x02\x00\x4D\x3E\x1F\xD3\xD5\xCB\x6D\xB0\xAA\x12\x6E\xB5\xF8\x41\xF2\xA8\x1F\xDA\xF7\xE9\x84\x99\xCD\x54\x1E\x67\x36\xE4\x11\x74\x6D\x02\xE0\x09\xDC\x2E\xA1\xEB\xB0\x5B\x74\xD1\x97\x8D\x7D\xD2\x7A\x81\xC0\x4B\x7E\x4F\xD6\x05\xFC\x6B\x08\x22\x15\xB0\x21\xA7\x6A\x29\x73\x02\x20\xDC\x4C\xBF\xBA\xA6\x11\x54\x94\x0D\xAF\x5E\x5A\x74\x08\x98\x07\x41\x9D\x9E\x18\x5C\xED\x05\x72\x9A\xBA\x1B\x0D\x32\xC8\x64\x6A\x86\xE1\x2A\x91\x48\xEC\xA8\xBD\x79\x12\x13\x15\x1D\xB6\xA7\xE1\x07\xE4\x01\x65\x6F\x05\xB4\x7F\x1C\x35\x3B\xAA\xA3\x7D\xCD\xD9\xCF\xA9\xC1\xBC\x21\xF8\x51\xDF\xB0\xDC\x58\x05\x04\xCE\x5F\x02\x69\xDF\xA7\xEC\xFD\x37\x91\xA8\x53\x25\x09\xF8\x96\xDA\x7A\x76\x4B\x4A\x2C\xA0\x60\x20\xA9\x6B\xA3\x36\xCE\x25\x92\xEE\x0A\x3A\x10\xD7\x5D\x56\xA0\xDD\xAD\x47\x79\x8E\xF6\xC3\x05\xB2\x8C\x76\xEC\xDB\x10\x4B\x1B\xEC\xD5\x46\xB1\xDF\x21\xB1\x39\x46\x5A\x69\x33\x0D\x00\xC7\xB3\xC4\xF5\xE4\x6E\x00\xBE\xAF\x15\xE9\x06\xED\x05\xBE\xE7\xE3\x89\x1D\xCF\xDA\x70\x20\x5E\x7F\x84\x87\xF0\xC3\x5D\x65\x90\x68\xD8\x25\xCB\x1F\x5A\xB1\x4E\x1F\xDE\xF8\x83\xF4\x6F\x38\xF8\x88\xD5\x00\xA0\x3A\x28\x14\xF8\xA1\x5A\x74\x06\xB0\x46\xC3\x2B\x15\xFB\xE0\x15\x1D\x3C\xA9\x0A\xEB\xE8\x09\x11\xFF\x08\x7F\xCE\x1D\xF0\x3C\x36\x96\x05\x91\xCA\x7A\xD7\x63\xB8\x3F\x19\x80\xA9\x70\xFB\x02\x04\xA0\x9A\x7A\x3F\x3D\x4E\xE8\xDB\x86\xD7\xA6\x86\xE1\x46\x48\x53\x30\x17\x02\xCE\x58\xD2\x4D\x11\xFB\x4C\x64\x90\xC5\x70\x5F\x17\x3D\x5E\x64\x83\x31\x82\x1E\xF9\x3F\x61\x9F\x15\x28\x41\xB7\x2C\x3C\xFD\xA5\x94\x03\x01\x75\x03\xF1\x1B\xD6\x4C\x39\xA4\x0B\xEE\xF3\x01\xE0\x67\xB8\x7D\x05\xAE\xA0\xD5\xC2\x3C\x70\x0C\xF5\x44\x7A\x14\x87\xA3\x04\x97\xE5\xF3\xC3\xAA\x04\x2E\x04\x00\xFB\x89\xC5\x24\x19\xF6\x0B\x50\x6A\x05\x17\x29\x2B\x01\xE0\xD7\xAD\xD9\x39\xE9\xD4\xAD\x0B\x89\xC8\x79\x90\x6F\x08\x7C\x2F\x41\xDD\x10\xFB\xBC\xC2\x09\x2D\x9F\xCA\xBA\x1B\x28\x9E\xCB\x85\xF4\xD5\x3C\x9F\xD0\x19\x77\x25\x94\x66\xD2\x5A\x3E\x3D\x0D\xB4\xD6\x14\x64\x8D\x97\xFC\xEA\x54\x27\xD6\xD1\x53\x51\x7A\x79\xEF\x74\xB7\xFA\x58\xDE\xD6\xC8\x2C\x65\x8F\x5C\xC3\x07\x2F\xFB\x40\x30\xD5\xBD\x4F\xB9\xC5\x15\x15\x15\x85\x06\x7E\x55\xBF\xD9\xB1\x46\x06\x61\xD6\xB2\xCF\xB0\x30\x57\x3E\x6B\x1E\x11\xDB\x17\x6B\x4A\x7E\xFD\xFA\xC5\xA6\x91\x4A\x66\x8A\xDA\x9D\x71\xF1\x3D\xD5\xB7\xF6\x5F\x31\x6F\x17\x92\x24\x9D\x7C\x18\x8B\xFD\x2F\x49\x68\xBF\x2B\x84\x3F\xA0\x0B\x39\x5D\x6D\x55\xAE\xDE\x12\xD1\x77\x24\xF1\x33\x85\xF2\x02\xF5\xDD\xF9\x0A\xE1\x39\xEE\xCD\xA6\xC2\x21\xA5\x28\xC1\x6E\x6F\x85\x62\x83\x94\x14\x85\xA0\xBD\x0C\x29\xD1\x6A\x67\x31\xEA\x6C\x10\x8A\xF7\x65\x7E\xBA\x2C\x47\x52\x12\x43\xE9\x44\xAF\x2A\x4F\x37\x6E\x30\x4F\xBB\x8E\x0F\xD2\x91\xB9\x16\xD5\xF3\x73\xD3\x90\xE3\x48\xAA\x57\xB6\x78\xC3\xC3\x6E\xA0\x3B\x72\xC1\x92\xA9\x79\xA1\xA7\x5F\x0B\x53\x8A\xA9\x47\x14\x0F\x61\x90\x3F\x51\xF0\x24\x29\x53\xCB\x40\x65\xBC\x0B\xCB\xEF\x39\x02\xAF\x13\xF4\x57\x80\xB5\xE8\x44\x6C\xD9\x6B\x05\x45\x68\xDD\x32\x91\xA5\x69\x47\x40\xCD\xBE\x4B\x08\x64\x25\x0C\x3D\x57\xCB\x16\xF1\xB7\x5F\xCE\xA5\xE9\x40\xAF\x8C\x40\x21\x90\x32\x18\x39\x87\x23\x76\xA0\xF2\x6E\x27\x47\xFD\x8B\xBA\x60\x3A\xA1\x42\x20\xBA\x91\x56\x86\x4E\xDC\x85\x95\x1A\x34\xF1\xE6\x7C\x60\x26\x1C\xFE\x0E\x28\xBD\xA7\xB9\xBF\x67\x1C\x41\x25\xE3\x7A\x8D\xE5\x53\x6A\xD5\x7E\x10\xA2\xC1\x7F\x16\x28\x33\xFC\x47\x0C\xCB\xDE\x1D\xFB\x62\xBA\x70\x96\xE1\xAB\x76\xD1\x5B\x03\x56\x4C\x41\xA6\xF5\x33\x83\x88\x69\x4D\xBF\x93\xD1\xBB\x9B\xDC\xFE\x01\x51\x90\x30\x2B\x44\x5E\xBA\x6C\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", vector(32, 27))

local function render_indicators(text, colors, ind_dst, img)
    local ts = render.measure_text(calibri, "bad", text)
    local x = 28
    local y = screen_y - 350
    
    if img then
        render.blur(vector(19, y - 350 - ind_dst + 350), vector(32 + (render.measure_text(calibri, "bad", text).x), (y - 345 - ind_dst) + 28 + 350), 1.5, 0.9, 10)
        render.rect_outline(vector(18, y - 350 - ind_dst + 350), vector(33 + (render.measure_text(calibri, "bad", text).x), (y - 345 - ind_dst) + 28 + 350), color(34,34,34, 55), 0.9, 10)
        render.text(calibri, vector(26, (y - 343) - ind_dst + 350), color(0, 0, 0, 150), "bad", text)
        render.text(calibri, vector(25, (y - 344) - ind_dst + 350), colors, "bad", text)
    else
        render.blur(vector(19, y - 350 - ind_dst + 350), vector(32 + (render.measure_text(calibri, "bad", text).x), (y - 345 - ind_dst) + 28 + 350), 1.5, 0.9, 10)
        render.rect_outline(vector(18, y - 350 - ind_dst + 350), vector(33 + (render.measure_text(calibri, "bad", text).x), (y - 345 - ind_dst) + 28 + 350), color(34,34,34, 55), 0.9, 10)
        render.text(calibri, vector(25, (y - 344) - ind_dst + 350), colors, "bad", text)
    end
end

get_bind = function(name)
    local state = false
    local value = 0
    local binds = ui.get_binds()
    for i = 1, #binds do
        if binds[i].name == name and binds[i].active then
            state = true
            value = binds[i].value
        end
    end
    return {state, value}
end

events.render:set(function()
    if menu.other.SideIndicators:get() then

        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end
    
        local weapon = lp:get_player_weapon()
        if not weapon or weapon == nil then return end

        local function calc_dist(pos1, pos2)
            local lx = pos1.x
            local ly = pos1.y
            local lz = pos1.z
            local tx = pos2.x
            local ty = pos2.y
            local tz = pos2.z
            local dx = lx - tx
            local dy = ly - ty
            local dz = lz - tz
            return math.sqrt(dx * dx + dy * dy + dz * dz);
        end

        local ind_dst = 0
        local ind_spr = 41

        local x = 28
        local y = screen_y - 350

        if reference.antiaim.misc.fake_latency:get() > 0 then
            render_indicators(ui.get_icon "link" .. " PING", color(150, 189, 18, 255), ind_dst)
            ind_dst = ind_dst + ind_spr
        end
    
        if reference.ragebot.double_tap:get() then
            render_indicators(ui.get_icon "objects-align-center-horizontal" .. "  DT", rage.exploit:get() == 1 and color(215, 215, 215, 255) or color(255, 0, 0, 255), ind_dst)
            ind_dst = ind_dst + ind_spr
        elseif reference.ragebot.osaa:get() and not reference.ragebot.double_tap:get()  then
            render_indicators(ui.get_icon "user-shield" .. "  OSAA", color(215, 215, 215, 255), ind_dst)
            ind_dst = ind_dst + ind_spr
        end
        
        if reference.antiaim.angels.freestanding:get() then
            render_indicators(ui.get_icon "arrows-retweet" .. "  FS", color(215, 215, 215, 255), ind_dst)
            ind_dst = ind_dst + ind_spr
        end
    
        if reference.ragebot.body_aim:get() == "Force" then
            render_indicators(ui.get_icon "vest-patches" .. "  BODY", color(215, 215, 215, 255), ind_dst)
            ind_dst = ind_dst + ind_spr
        end
    
        if get_bind("Min. Damage")[1] then
            render_indicators(ui.get_icon "droplet" .. "  MD", color(215, 215, 215, 255), ind_dst)
            ind_dst = ind_dst + ind_spr
        end
    
        if get_bind("Hit Chance")[1] then
            render_indicators(ui.get_icon "crosshairs-simple" .. "  HC", color(215, 215, 215, 255), ind_dst)
            ind_dst = ind_dst + ind_spr
        end
            
        if reference.antiaim.angels.fake_duck:get() then
            render_indicators(ui.get_icon "duck" .. "  DUCK", color(215, 215, 215, 255), ind_dst)
            ind_dst = ind_dst + ind_spr
        end
    
        local dormant_work = #entity.get_players(true, false) ~= #entity.get_players(true, true)
        if reference.ragebot.dormant_aimbot:get() then
            if dormant_work then
                render_indicators(ui.get_icon "eye" .. "  DA", color(215, 215, 215, 255), ind_dst)
            else
                render_indicators(ui.get_icon "eye" .. "  DA", color(255, 0, 0, 255), ind_dst)
            end
            ind_dst = ind_dst + ind_spr
        end
    
        if reference.ragebot.safe_points:get() == "Force" then
            render_indicators(ui.get_icon "bullseye-pointer" .. "  SAFE", color(215, 215, 215, 255), ind_dst)
            ind_dst = ind_dst + ind_spr
        end

        local c4 = entity.get_entities("CPlantedC4")[1];
        if c4 ~= nil then
            local time = ((c4.m_flC4Blow - globals.curtime) * 10) / 10
            local defused = c4.m_bBombDefused

            if math.floor(time) >= -1 and not defused then
                local defusestart = c4.m_hBombDefuser ~= 4294967295
                local defuselength = c4.m_flDefuseLength
                local defusetimer = defusestart and math.floor((c4.m_flDefuseCountDown - globals.curtime) * 10) / 10 or -1

                if defusetimer > 0 and not abort_defuse then
                    local col = math.floor(time) > defusetimer and color(58, 191, 54, 160) or color(252, 18, 19, 125)
                    local barlength = (((y - 50) / defuselength) * (defusetimer))
                    render.rect(vector(0, 0), vector(16, y), color(25, 25, 25, 160))
                    render.rect(vector(0, y - barlength), vector(16, y), col)
                end

                local bombsite = c4.m_nBombSite == 0 and "A" or "B"
                local health = lp.m_iHealth
                local armor = lp.m_ArmorValue
                local will_die = false
                local eLoc = c4.m_vecOrigin
                local lLoc = lp.m_vecOrigin
                local distance = calc_dist(eLoc, lLoc)
                local a = 450.7
                local b = 75.68
                local c = 789.2
                local d = (distance - b) / c;
                local damage = a * math.exp(-d * d)

                if armor > 0 then
                    local newDmg = damage * 0.5;
                    local armorDmg = (damage - newDmg) * 0.5
                    if armorDmg > armor then
                        armor = armor * (1 / .5)
                        newDmg = damage - armorDmg
                    end
                    damage = newDmg;
                end

                local dmg = math.ceil(damage)

                if dmg >= health then
                    will_die = true
                else
                    will_die = false
                end

                if time > 0.01 then
                    render_indicators(ui.get_icon "land-mine-on" .. " " .. bombsite .. " - " .. string.format("%.1f", time >= 0 and time or 0) .. "s", color(215, 215, 215, 255), ind_dst, bomb_img)
                    ind_dst = ind_dst + ind_spr

                    if will_die then
                        render_indicators(ui.get_icon "circle-exclamation" .. "  FATAL", color(255, 0, 0, 255), ind_dst)
                        ind_dst = ind_dst + ind_spr
                    elseif damage > 0.5 then
                        render_indicators(ui.get_icon "monitor-waveform" .. "  -" .. dmg .. " HP", color(255, 240, 100, 255), ind_dst)
                        ind_dst = ind_dst + ind_spr
                    end
                end
            end
        end

        if bomb.state == false then
            render_indicators(ui.get_icon "land-mine-on" .. " " .. bomb.site, color(255, 240, 100, 255), ind_dst, bomb_img)
            ts = render.measure_text(calibri, "bad", bomb.site) + vector(20, 0)
            ind_dst = ind_dst + ind_spr
        end
    end
end)
    

local animation_breaker do
    local animations = {}

    local animlayer_t = ffi.typeof [[
        struct {
            float  m_flLayerAnimtime;
            float  m_flLayerFadeOuttime;

            // dispatch flags
            void  *m_pDispatchedStudioHdr;
            int    m_nDispatchedSrc;
            int    m_nDispatchedDst;

            int    m_nOrder;
            int    m_nSequence;
            float  m_flPrevCycle;
            float  m_flWeight;
            float  m_flWeightLauraRate;

            // used for automatic crossfades between sequence changes;
            float  m_flPlaybackRate;
            float  m_flCycle;
            int    m_pOwner;
            int    m_nInvalidatePhysicsBits;
        } **
    ]]

    animations_enable = menu.menulist.other.right_down:switch("\v\f<street-view>\r    Animations", false, function(gear, item)
        return {
            --type = gear:selectable("\n", {"landing pitch","static leg in air","static leg in crouch","static leg in slow-walk","move Lean","skeet leg fucker","earthquake","kangaroo"}),
            moveleanforce = gear:slider("move lean force", 0, 100, 100, nil, "%"):depend(item),
            moveleanonground = gear:switch("on ground force"):depend(item)
        }
    end):depend(menu.antiaim.masterswitch, (selector_antiaim))
    animations.gear = animations_enable:create()
    --animations.type = animations.gear:selectable("\n", {"landing pitch","static leg in air","static leg in crouch","static leg in slow-walk","move Lean","skeet leg fucker","earthquake","kangaroo"}):depend({tab_selector, 4}, animations_enable)
    animations.type_inair = animations.gear:selectable("In Air", {"static"}):depend(animations_enable)
    animations.type_onground = animations.gear:selectable("On Ground", {"static in crouch", "static in slow-walk", "jitter"}):depend(animations_enable)
    animations.type_addons = animations.gear:listable("Addons", {"landing pitch", "earthquake", "kangaroo"}):depend(animations_enable)

    local function get_animation_layer(player)
        return ffi.cast(animlayer_t, ffi.cast("uintptr_t", player[0]) + 0x2990)[0]
    end

    local function get_earthquake_value(frequency)
        local current_tick = globals.tickcount / 10
        local factor = 0.5 + 0.5 * math.sin(current_tick * frequency)

        return factor * 100
    end

    local function update_static_leg_in_air(player, animlayers)
        if not animations.type_inair:get "static" then
            return
        end

        player.m_flPoseParameter[6] = 1
    end

    local function update_static_leg_in_crouch(player, animlayers)
        if not animations.type_onground:get "static in crouch" then
            return
        end

        player.m_flPoseParameter[8] = 0
    end

    local function update_static_leg_in_slow_walk(player, animlayers)
        if not animations.type_onground:get "static in slow-walk" then
            return
        end

        if not ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then
            return
        end

        player.m_flPoseParameter[9] = 0
    end

    local function update_leg_fucker(player, animlayers)
        if not animations.type_onground:get "jitter" then
            return
        end

        player.m_flPoseParameter[0] = utils.random_float(0.8 / 10, 1)
        if utils.random_int(0, 1) == 1 then
            ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override("Sliding")
        else
            ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override("Default")
        end
    end

    local function update_move_lean(player, animlayers)
        if not animations.type_addons:get "move lean" then
            return
        end

        if player.is_onground and not animations_enable.moveleanonground:get() then
            return
        end

        local weight = animlayers[12].m_flWeight
        local amount = animations_enable.moveleanforce:get()

        animlayers[12].m_flWeight = math.clamp(weight + weight * amount, 0.0, 1.0)
    end

    local function update_landing_pitch(player, animstate)
        if not animations.type_addons:get "landing pitch" then
            return
        end

        if animstate.landing then
            player.m_flPoseParameter[12] = 0.5
        end
    end

    local function update_earthquake(player, animlayers)
        if not animations.type_addons:get "earthquake" then
            return
        end

        if player.is_onground and animations.type_onground:get "skeet leg fucker" then
            return
        end

        if globals.tickcount % 10 > 1 then
            animlayers[12].m_flWeight = get_earthquake_value(7) / 100
        end
    end

    local function update_kangaroo(player)
        if not animations.type_addons:get "kangaroo" then
            return
        end

        if player.is_onground and animations.type_onground:get "skeet leg fucker" then
            return
        end

        player.m_flPoseParameter[3] = math.random(0, 10) / 10
        player.m_flPoseParameter[6] = math.random(0, 10) / 10
        player.m_flPoseParameter[7] = math.random(0, 10) / 10

        if animations.type_inair:get "static leg in air" then
            player.m_flPoseParameter[6] = 1
        end
    end

    local function on_update_csa(player)
        local me = entity.get_local_player()

        if me ~= player then
            return
        end

        local animstate = player:get_anim_state()

        if animstate == nil then
            return
        end

        local animlayers = get_animation_layer(player)

        if animlayers == nil then
            return
        end

        update_leg_fucker(player, animlayers)
            update_landing_pitch(player, animstate)

            update_static_leg_in_crouch(player, animlayers)
            update_static_leg_in_slow_walk(player, animlayers)
        update_static_leg_in_air(player, animlayers)
        

        update_kangaroo(player)

        update_move_lean(player, animlayers)
        update_earthquake(player, animlayers)
    end

    local function on_shutdown()
        ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override()
    end

    local function update_event_callbacks(value)
        events.shutdown(on_shutdown, value)
        events.post_update_clientside_animation(on_update_csa, value)
    end

    local function on_enabled(item)
        local value = item:get()

        if not value then
            on_shutdown()
        end

        update_event_callbacks(value)
    end

    animations_enable:set_callback(on_enabled, true)
end

-- @REGION: visuals
local visuals do
    local menupos = ui.get_position()
    local scope_overlay = {}
    local hitmarker_gs = {}

    local calibri2 = render.load_font("Calibri", 10, "bad")
    local calibri3 = render.load_font("Calibri", 15, "bad")

    local watermark = function()
        local accent_clr = menu.main.accent_color:get()

        if menu.main.watermarkstyle:get() == "Laura" then
            if menu.main.watermarkposition:get() == "Down" then
                if not globals.is_in_game or not entity.get_local_player() then return end
                local localplayer = entity.get_local_player()
                local avatar = localplayer:get_steam_avatar()
                local name = localplayer:get_name()
                -- render.blur(vector(990,render.screen_size().y/2+505),vector(866,render.screen_size().y-7), 1.5, 0.9, 10)
                -- render.texture(avatar,vector(809,render.screen_size().y-35),vector(25,25),color(),nil,3)
                name = string.sub(name,1,10)
                if string.len(name) >= 10 then
                    name = name .. "..."
                end
                local laura_gradient_text = gradient.text_animate(ui.get_icon "moon" .. " L A U R A", -2, { accent_clr, color(40) })
                render.text(calibri3,vector(912,render.screen_size().y-30),color(175,175,175),"", laura_gradient_text:get_animated_text())
                laura_gradient_text:animate()
            elseif menu.main.watermarkposition:get() == "Left" then
                if not globals.is_in_game or not entity.get_local_player() then return end
                local localplayer = entity.get_local_player()
                local avatar = localplayer:get_steam_avatar()
                local name = localplayer:get_name()
                -- render.blur(vector(10,render.screen_size().y/2+11),vector(135,render.screen_size().y-502), 1.5, 0.9, 10)
                -- render.texture(avatar,vector(809,render.screen_size().y-35),vector(25,25),color(),nil,3)
                name = string.sub(name,1,10)
                if string.len(name) >= 10 then
                    name = name .. "..."
                end
                local laura_gradient_text = gradient.text_animate(ui.get_icon "moon" .. " L A U R A", -2, { accent_clr, color(40) })
                render.text(calibri3,vector(15,render.screen_size().y-525),color(175,175,175),"", laura_gradient_text:get_animated_text())
                laura_gradient_text:animate()
            elseif menu.main.watermarkposition:get() == "Right" then
                if not globals.is_in_game or not entity.get_local_player() then return end
                local localplayer = entity.get_local_player()
                local avatar = localplayer:get_steam_avatar()
                local name = localplayer:get_name()
                -- render.blur(vector(1911,render.screen_size().y/2+11),vector(1790,render.screen_size().y-502), 1.5, 0.9, 10)
                -- render.texture(avatar,vector(809,render.screen_size().y-35),vector(25,25),color(),nil,3)
                name = string.sub(name,1,10)
                if string.len(name) >= 10 then
                    name = name .. "..."
                end
                local laura_gradient_text = gradient.text_animate(ui.get_icon "moon" .. " L A U R A", -2, { accent_clr, color(40) })
                render.text(calibri3,vector(1825,render.screen_size().y-525),color(175,175,175),"", laura_gradient_text:get_animated_text())
                laura_gradient_text:animate()
            end
        end

        if menu.main.watermarkstyle:get() == "Laura Skinny" then
            if menu.main.watermarkposition:get() == "Down" then
                if not globals.is_in_game or not entity.get_local_player() then return end
                local localplayer = entity.get_local_player()
                local avatar = localplayer:get_steam_avatar()
                local name = localplayer:get_name()
                -- render.blur(vector(990,render.screen_size().y/2+505),vector(866,render.screen_size().y-7), 1.5, 0.9, 10)
                -- render.texture(avatar,vector(809,render.screen_size().y-35),vector(25,25),color(),nil,3)
                name = string.sub(name,1,10)
                if string.len(name) >= 10 then
                    name = name .. "..."
                end
                local laura_gradient_text = gradient.text_animate("L A U R A", -2, { accent_clr, color(40) })
                render.text(1,vector(925,render.screen_size().y-25),color(175,175,175),"", laura_gradient_text:get_animated_text())
                laura_gradient_text:animate()
            elseif menu.main.watermarkposition:get() == "Left" then
                if not globals.is_in_game or not entity.get_local_player() then return end
                local localplayer = entity.get_local_player()
                local avatar = localplayer:get_steam_avatar()
                local name = localplayer:get_name()
                -- render.blur(vector(10,render.screen_size().y/2+11),vector(135,render.screen_size().y-502), 1.5, 0.9, 10)
                -- render.texture(avatar,vector(809,render.screen_size().y-35),vector(25,25),color(),nil,3)
                name = string.sub(name,1,10)
                if string.len(name) >= 10 then
                    name = name .. "..."
                end
                local laura_gradient_text = gradient.text_animate("L A U R A", -2, { accent_clr, color(40) })
                render.text(1,vector(15,render.screen_size().y-525),color(175,175,175),"", laura_gradient_text:get_animated_text())
                laura_gradient_text:animate()
            elseif menu.main.watermarkposition:get() == "Right" then
                if not globals.is_in_game or not entity.get_local_player() then return end
                local localplayer = entity.get_local_player()
                local avatar = localplayer:get_steam_avatar()
                local name = localplayer:get_name()
                -- render.blur(vector(1911,render.screen_size().y/2+11),vector(1790,render.screen_size().y-502), 1.5, 0.9, 10)
                -- render.texture(avatar,vector(809,render.screen_size().y-35),vector(25,25),color(),nil,3)
                name = string.sub(name,1,10)
                if string.len(name) >= 10 then
                    name = name .. "..."
                end
                local laura_gradient_text = gradient.text_animate("L A U R A", -2, { accent_clr, color(40) })
                render.text(1,vector(1850,render.screen_size().y-525),color(175,175,175),"", laura_gradient_text:get_animated_text())
                -- local laura_text = text("[DEBUG]", { accent_clr, color(40) })
                -- render.text(1,vector(1850,render.screen_size().y-525),color(175,175,175),"[DEBUG]")
                laura_gradient_text:animate()
            end
        end

        if menu.main.watermarkstyle:get() == "Laura Bordered" then
            if menu.main.watermarkposition:get() == "Left" then
                if not globals.is_in_game or not entity.get_local_player() then return end
                local localplayer = entity.get_local_player()
                local avatar = localplayer:get_steam_avatar()
                local name = localplayer:get_name()
                render.blur(vector(4,render.screen_size().y/2+30),vector(120,render.screen_size().y/2+65), 1.5, 0.9, 10)
                render.texture(avatar,vector(9,render.screen_size().y/2+34),vector(25,25),color(),nil,3)
                name = string.sub(name,1,10)
                if string.len(name) >= 10 then
                    name = name .. "..."
                end
                render.text(calibri2,vector(38,render.screen_size().y/1.87),color(175,175,175),"", "\aDEFAULT".. info._lua.username .. "")
                render.text(calibri2,vector(38,render.screen_size().y/1.835),color(175,175,175),"","\aDEFAULTbuild: ".. info._lua.build .. "")
            elseif menu.main.watermarkposition:get() == "Down" then
                if not globals.is_in_game or not entity.get_local_player() then return end
                local localplayer = entity.get_local_player()
                local avatar = localplayer:get_steam_avatar()
                local name = localplayer:get_name()
                render.blur(vector(985,render.screen_size().y/2+500),vector(870,render.screen_size().y-5), 1.5, 0.9, 10)
                render.texture(avatar,vector(875,render.screen_size().y/2+505),vector(25,25),color(),nil,3)
                name = string.sub(name,1,10)
                if string.len(name) >= 10 then
                    name = name .. "..."
                end
                render.text(calibri2,vector(905,render.screen_size().y/1.03),color(175,175,175),"", "\aDEFAULT".. info._lua.username .. "")
                render.text(calibri2,vector(905,render.screen_size().y/1.019),color(175,175,175),"","\aDEFAULTbuild: ".. info._lua.build .. "")
            elseif menu.main.watermarkposition:get() == "Right" then
                if not globals.is_in_game or not entity.get_local_player() then return end
                local localplayer = entity.get_local_player()
                local avatar = localplayer:get_steam_avatar()
                local name = localplayer:get_name()
                render.blur(vector(1911,render.screen_size().y/2+30),vector(1790,render.screen_size().y/2+65), 1.5, 0.9, 10)
                render.texture(avatar,vector(1795,render.screen_size().y/2+35),vector(25,25),color(),nil,3)
                name = string.sub(name,1,10)
                if string.len(name) >= 10 then
                    name = name .. "..."
                end
                render.text(calibri2,vector(1825,render.screen_size().y/1.87),color(175,175,175),"", "\aDEFAULT".. info._lua.username .. "")
                render.text(calibri2,vector(1825,render.screen_size().y/1.83),color(175,175,175),"","\aDEFAULTbuild: ".. info._lua.build .. "")
            end
        end
    end

    local sidebar = function()
        if menu.main.sidebarcombo:get() == "Default" then
            local accent_clr = menu.main.accent_color:get()
            local accent_clr2 = menu.main.accent_color:get():to_hex()
            local animated_sidebar = gradient.text_animate(MTools.String.FirstUpper(info._lua.name).." ", 0.5, { accent_clr, color(40) })
            local animated_sidebar2 = gradient.text_animate(ui.get_icon "moon", 0.5, { accent_clr, color(40) })
            ui.sidebar(animated_sidebar:get_animated_text(), animated_sidebar2:get_animated_text())
            animated_sidebar:animate()
            animated_sidebar2:get_animated_text()
        end
        if menu.main.sidebarcombo:get() == "Default + Build" then
            local accent_clr = menu.main.accent_color:get()
            local accent_clr2 = menu.main.accent_color:get():to_hex()
            local animated_sidebar = gradient.text_animate(MTools.String.FirstUpper(info._lua.name).." | "..info._lua.build.. " ", 2, { accent_clr, color(40) })
            local animated_sidebar2 = gradient.text_animate(ui.get_icon "moon", 2, { accent_clr, color(40) })
            ui.sidebar(animated_sidebar:get_animated_text(), animated_sidebar2:get_animated_text())
            animated_sidebar:animate()
            animated_sidebar2:get_animated_text()
        end
    end

    local aspectratio = function()
        local lp = entity.get_local_player()
        if lp == nil then return end
    
        if menu.other.aspectratio:get() then
            local aspect_ratio_value = animations.new("aspect_ratio_value", menu.other.aspectratio.amount:get() / 100, 5)
            cvar.r_aspectratio:float(aspect_ratio_value)
        else
            cvar.r_aspectratio:float(0)
        end
    end

    local viewmodel = function()
        local viewmodel_fov_value = animations.new("viewmodel_fov_value", menu.other.viewmodel:get() and menu.other.viewmodel.fov:get() / 10 or get_original(cvar.viewmodel_fov), 5)
        local viewmodel_x_value = animations.new("viewmodel_x_value", menu.other.viewmodel:get() and menu.other.viewmodel.x:get() / 10 or get_original(cvar.viewmodel_offset_x), 5)
        local viewmodel_y_value = animations.new("viewmodel_y_value", menu.other.viewmodel:get() and menu.other.viewmodel.y:get() / 10 or get_original(cvar.viewmodel_offset_y), 5)
        local viewmodel_z_value = animations.new("viewmodel_z_value", menu.other.viewmodel:get() and menu.other.viewmodel.z:get() / 10 or get_original(cvar.viewmodel_offset_z), 5)

        cvar.viewmodel_fov:float(viewmodel_fov_value, true)
        cvar.viewmodel_offset_x:float(viewmodel_x_value, true)
        cvar.viewmodel_offset_y:float(viewmodel_y_value, true)
        cvar.viewmodel_offset_z:float(viewmodel_z_value, true)
    end



    scope_overlay.anim_num = 0
    scope_overlay.lerp = function(a, b, t)
        return a + (b - a) * t
    end

    scope_overlay.setup = function()
        if not menu.other.scope_overlay:get() then return end
        reference.world.override_zoom.scope_overlay:override("remove all")
        local_player = entity.get_local_player()
    
        if not local_player or not local_player:is_alive() or not local_player["m_bIsScoped"] then 
            scope_overlay.anim_num = scope_overlay.lerp(scope_overlay.anim_num, 0, 15 * globals.frametime)
        else
            scope_overlay.anim_num = scope_overlay.lerp(scope_overlay.anim_num, 1, 15 * globals.frametime)
        end

        scope_overlay.offset = menu.other.scope_overlay.scope_gap:get() * scope_overlay.anim_num
        scope_overlay.length = menu.other.scope_overlay.scope_size:get() * scope_overlay.anim_num
        scope_overlay.col_1 = menu.other.scope_overlay.scope_color:get()
        scope_overlay.width = 1
    
        scope_overlay.col_1.a = scope_overlay.col_1.a * scope_overlay.anim_num
    
        scope_overlay.start_x = render.screen_size().x / 2
        scope_overlay.start_y = render.screen_size().y / 2
    
        if menu.other.scope_overlay.scope_style:get() == 'default' then
            render.gradient(vector(scope_overlay.start_x - scope_overlay.offset, scope_overlay.start_y), vector(scope_overlay.start_x - scope_overlay.offset - scope_overlay.length, scope_overlay.start_y + scope_overlay.width), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('left') and 0 or scope_overlay.col_1.a), color(255, 255, 255, 0), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('left') and 0 or scope_overlay.col_1.a), color(255, 255, 255, 0))
            render.gradient(vector(scope_overlay.start_x + scope_overlay.offset, scope_overlay.start_y), vector(scope_overlay.start_x + scope_overlay.offset + scope_overlay.length, scope_overlay.start_y + scope_overlay.width), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('right') and 0 or scope_overlay.col_1.a), color(255, 255, 255, 0), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('right') and 0 or scope_overlay.col_1.a), color(255, 255, 255, 0))
            render.gradient(vector(scope_overlay.start_x, scope_overlay.start_y + scope_overlay.offset), vector(scope_overlay.start_x + scope_overlay.width, scope_overlay.start_y + scope_overlay.offset + scope_overlay.length), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('down') and 0 or scope_overlay.col_1.a), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('down') and 0 or scope_overlay.col_1.a), color(255, 255, 255, 0), color(255, 255, 255, 0))
            render.gradient(vector(scope_overlay.start_x, scope_overlay.start_y - scope_overlay.offset), vector(scope_overlay.start_x + scope_overlay.width, scope_overlay.start_y - scope_overlay.offset - scope_overlay.length), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('up') and 0 or scope_overlay.col_1.a), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('up') and 0 or scope_overlay.col_1.a), color(255, 255, 255, 0), color(255, 255, 255, 0))
        else
            render.gradient(vector(scope_overlay.start_x - scope_overlay.offset, scope_overlay.start_y), vector(scope_overlay.start_x - scope_overlay.offset - scope_overlay.length, scope_overlay.start_y + scope_overlay.width), color(255, 255, 255, 0), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('left') and 0 or scope_overlay.col_1.a), color(255, 255, 255, 0), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('left') and 0 or scope_overlay.col_1.a))
            render.gradient(vector(scope_overlay.start_x + scope_overlay.offset, scope_overlay.start_y), vector(scope_overlay.start_x + scope_overlay.offset + scope_overlay.length, scope_overlay.start_y + scope_overlay.width), color(255, 255, 255, 0), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('right') and 0 or scope_overlay.col_1.a), color(255, 255, 255, 0), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('right') and 0 or scope_overlay.col_1.a))
            render.gradient(vector(scope_overlay.start_x, scope_overlay.start_y + scope_overlay.offset), vector(scope_overlay.start_x + scope_overlay.width, scope_overlay.start_y + scope_overlay.offset + scope_overlay.length), color(255, 255, 255, 0), color(255, 255, 255, 0), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('down') and 0 or scope_overlay.col_1.a), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('down') and 0 or scope_overlay.col_1.a))
            render.gradient(vector(scope_overlay.start_x, scope_overlay.start_y - scope_overlay.offset), vector(scope_overlay.start_x + scope_overlay.width, scope_overlay.start_y - scope_overlay.offset - scope_overlay.length), color(255, 255, 255, 0), color(255, 255, 255, 0), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('up') and 0 or scope_overlay.col_1.a), color(scope_overlay.col_1.r, scope_overlay.col_1.g, scope_overlay.col_1.b, menu.other.scope_overlay.remove_line:get('up') and 0 or scope_overlay.col_1.a))
        end
    end

    hitmarker_gs.fade_time = 0.5
    hitmarker_gs.wait_time = 1.0
    hitmarker_gs.shots = {}

    hitmarker_gs.render = function()
        if not menu.other.hitmarker:get() then return end
        for i, Shot in pairs(hitmarker_gs.shots) do
            if Shot.FadeTime <= 0 then
                hitmarker_gs.shots[i] = nil
            else
                Shot.WaitTime = Shot.WaitTime - globals.frametime
                if Shot.WaitTime <= 0 then
                    Shot.FadeTime  = Shot.FadeTime - ((1 / hitmarker_gs.fade_time) * globals.frametime)
                end
            
                if Shot.Position.x ~= nil and Shot.Position.y ~= nil and Shot.Position.z ~= nil and Shot.Reason == nil then
                    local pos = render.world_to_screen(vector(Shot.Position.x, Shot.Position.y, Shot.Position.z))
                    if pos ~= nil then
                        local x, y = pos.x, pos.y
                        local ss = render.screen_size() 
                        local r, g, b, a = menu.other.hitmarker.color:get():unpack()
                        render.rect(vector(x - (1/ss.x) * ss.x, y - (5/ss.y) * ss.y), vector(x + (1/ss.x) * ss.x, y + (5/ss.y) * ss.y), color(r, g, b, a * Shot.FadeTime), 0, true)
                        render.rect(vector(x - (5/ss.x) * ss.x, y - (1/ss.y) * ss.y), vector(x + (5/ss.x) * ss.x, y + (1/ss.y) * ss.y), color(r, g, b, a * Shot.FadeTime), 0, true)
                    end
                end
            end
        end
    end

    hitmarker_gs.aim_ack = function(Shot)
        hitmarker_gs.shots[Shot.id] = {
            Position = Shot.aim,
            WaitTime = hitmarker_gs.wait_time,
            FadeTime = 1,
            Reason = Shot.state,
        }
    end
    hitmarker_gs.refresh_shots = function() hitmarker_gs.shots = {} end

    local clantag = {} do
        clantag.time_to_ticks = function(t) return math.floor(t / globals.tickinterval + 0.5) end
        clantag.vars = {
            clantag_cache = "",
            set_clantag = function(self, tag)
                if tag ~= self.clantag_cache then
                    common.set_clan_tag(tag)    
                    self.clantag_cache = tag
                end
            end
        }
        clantag.animation = function(text, indices)
            local text_anim = "               " .. text .. "                      " 
            local netchann_info = utils.net_channel()
            if netchann_info == nil then return end
            local tickcount = globals.tickcount + clantag.time_to_ticks(netchann_info.latency[0] + 0.321)
            local i = tickcount / clantag.time_to_ticks(0.3)
            i = math.floor(i % #indices)
            i = indices[i+1]+1
            return text_anim:sub(i, i+15)
        end
        clantag.clan_tag_prev = ''
        clantag.executer = function()
            local local_player = entity.get_local_player()
            if not local_player then return end
            if menu.other.clantag:get() then
                local clan_tag = clantag.animation("Laura", {0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23})
                local game_rules = entity.get_game_rules()
                if game_rules.m_gamePhase == 5 or game_rules.m_timeUntilNextPhaseStarts ~= 0 then
                    clantag.vars:set_clantag(clantag.animation("Laura", {11}))
                end
                if clan_tag ~= clantag.clan_tag_prev then
                    clantag.vars:set_clantag(clan_tag)
                end
                clantag.clan_tag_prev = clan_tag
            end
        end
    end

    local damage_indicator = function()
        if not globals.is_in_game or not entity.get_local_player() then return end
        if menu.other.damage_indicator:get() then
            render.text(1, vector(screen_x / 2 + 3, screen_y / 2 - 15), color(255), nil, reference.ragebot.minimum_damage:get())
        end
    end

    local hitchance_indicator = function()
        if not globals.is_in_game or not entity.get_local_player() then return end
        if menu.other.hitchance_indicator:get() then
            render.text(1, vector(screen_x / 2 - 15, screen_y / 2 + 3), color(255), nil, reference.ragebot.hitchance:get())
            -- render.text(calibri2,vector(38,render.screen_size().y/1.83),color(175,175,175),"","\aDEFAULTbuild: ".. info._lua.build .. "")
        end
    end

    menu.other.clantag:set_callback(function(el) if not el:get() then common.set_clan_tag("\0") end end)
    events.pre_render:set(clantag.executer)

    events.aim_ack:set(hitmarker_gs.aim_ack)
    
    events.round_start:set(function()
        hitmarker_gs.refresh_shots()
    end)
    
    events.player_spawned:set(function(e)
        hitmarker_gs.refresh_shots()
    end)

    events.render:set(function()
        watermark()
        sidebar()
        aspectratio()
        viewmodel()
        damage_indicator()
        hitchance_indicator()
        -- keep_model_transparency()
        hitmarker_gs.render()
        scope_overlay.setup()
    end)

end

-- @ENDREGION


-- @REGION: misc
local misc do

    local nofdamage = {}

    local trashtalk = {}

    menu.other.fakelatency:set_callback(function(fakelatency)
        local sv_maxunlag = cvar.sv_maxunlag
        if fakelatency:get() then
            sv_maxunlag:float(0.400, true)
            ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):override(fakelatency:get())
            ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
        else
            sv_maxunlag:float(0.200, true)
            ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):override(0)
            ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
        end
    end)

    -- local advanced_fakelag = function()
    --     if menu.other.advanced_fakelag:get() then
    --         utils.random_int(0, 100) then
    --         ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")
            
    --     end
    -- end

    local fastladder = function(cmd)
        if not menu.other.fastladder:get() then return end

        local lp = entity.get_local_player()
        if lp.m_MoveType == 9 then
            if cmd.forwardmove > 0 then
                if render.camera_angles().x < 45 then
                    cmd.view_angles.x = 89

                    cmd.in_moveright = 1
                    cmd.in_moveleft = 0
                    cmd.in_forward = 0
                    cmd.in_back = 1

                    if cmd.sidemove == 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 90
                    end

                    if cmd.sidemove < 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 150
                    end

                    if cmd.sidemove > 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 30
                    end
                end
            end

            if cmd.forwardmove < 0 then
                cmd.view_angles.x = 89

                cmd.in_moveleft = 1
                cmd.in_moveright = 0
                cmd.in_forward = 1
                cmd.in_back = 0

                if cmd.sidemove == 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 90
                end

                if cmd.sidemove > 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 150
                end

                if cmd.sidemove < 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 30
                end
            end
        end
    end

    nofdamage.trace = function(player, length)
        local origin = player:get_origin()

        for i = 0, math.pi * 2.0, math.pi * 2.0 / 8 do
            local sin = math.sin(i)
            local cos = math.cos(i)

            local x = origin.x + cos * 10
            local y = origin.y + sin * 10

            local start_pos = vector(x, y, origin.z)
            local end_pos = start_pos:clone()

            end_pos.z = end_pos.z - length

            local trace = utils.trace_line(start_pos, end_pos, player)

            if trace.fraction ~= 1 then
                return true
            end
        end

        return false
    end

    nofdamage.setup = function(cmd)
        if not menu.other.nofalldamage:get() then return end
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        local velocity = me.m_vecVelocity

        if velocity.z >= -500 then
            nfldstate = false
            return
        end

        if nofdamage.trace(me, 15) then
            nfldstate = false
        elseif nofdamage.trace(me, 75) then
            nfldstate = true
        end

        cmd.in_duck = nfldstate
    end

    trashtalk.texts = {
        "кто твой язык кроме пидора",
        "смотри щас оппонент восстанет во всех временах и скажет с хуем в жопе",
        "что в хуй у меня рот твой",
        "расскажи как тебя я выебал тапом",
        "проебываешь мапу словом каким",
        "кто в тя харкал? у меня между ног трибуны, а ты оратор, продолжай. твой микрофон это мой хуй",
        "сегодня зафейлишся у тебя мать шлюха у всех твоя мать, че маме?",
        "жопу твою с хуя снимал шо на лице у тебя?",
        "Что тебя трахает Что венозному русику в дикачину кто трогает тебя?",
    }

    trashtalk.delay = 1.2

    trashtalk.say = function(delay, msg)
        return utils.execute_after(delay, function() utils.console_exec('say ' .. msg) end)
    end

    trashtalk.player_death = function(e)
        if not menu.other.trashtalk:get() then return end
        local me = entity.get_local_player()
        local victim = entity.get(e.userid, true)
        local attacker = entity.get(e.attacker, true)

        if (victim ~= attacker and attacker == me) then
            local text = trashtalk.texts[math.random(1, #trashtalk.texts)]
            trashtalk.say(trashtalk.delay, text)
        end
    end

    events.player_death:set(trashtalk.player_death)
    
    events.createmove:set(function(cmd)
        fastladder(cmd)
        nofdamage.setup(cmd)

        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end
    
        local weapon = lp:get_player_weapon()
        if not weapon or weapon == nil then return end
    
        local weapon_info = weapon:get_weapon_info()
        if not weapon_info or weapon_info == nil then return end
    
        local is_grenade = weapon_info.weapon_type == 9

        if menu.other.nade_throw_fix:get() then
            if weapon_info.weapon_type == 9 then
                reference.ragebot.weapon_actions:override("")
            else
                reference.ragebot.weapon_actions:override()
            end
        else
            reference.ragebot.weapon_actions:override()
        end
    end)
end
-- @ENDREGION

-- @REGION: ragebot
local ragebot do

    -- if info._lua.build == "Live" then
    --     menu.main.dormant_aimbot:disabled(true)
    --     menu.main.fastladder:disabled(true)
    --     menu.main.nofalldamage:disabled(true)
    --     menu.main.keep_model_transparency:disabled(true)
    --     menu.main.consolecolor:disabled(true)        
    -- else
    --     menu.main.keep_model_transparency:disabled(false)
    --     menu.main.consolecolor:disabled(false) 
    --     menu.main.dormant_aimbot:disabled(false)
    --     menu.main.fastladder:disabled(false)
    --     menu.main.nofalldamage:disabled(false)
    -- end

    -- if info._lua.build == "Nightly" then
    --     menu.main.fastladder:disabled(true)
    --     menu.main.nofalldamage:disabled(true)
    -- else
    --     menu.main.fastladder:disabled(false)
    --     menu.main.nofalldamage:disabled(false)
    -- end

    -- if info._lua.build == "Debug" then
    --     menu.main.keep_model_transparency:disabled(true)
    --     menu.main.consolecolor:disabled(true)        
    -- else
    --     menu.main.keepmokeep_model_transparencydeltrancparency:disabled(false)
    --     menu.main.consolecolor:disabled(false) 
    -- end

    local WEAPONTYPE_SNIPER_RIFLE = 5

    local aim_target
    local aim_point
    local aim_hitbox
    local aim_damage
    local aim_accuracy

    local is_hit = false
    local is_shot = false

    local target_index = 1
    local round_started = 0.0

    local e_hitbox = {
        [0]  = "Generic",
        [1]  = "Head",
        [2]  = "Chest",
        [3]  = "Stomach",
        [4]  = "Chest",
        [5]  = "Chest",
        [6]  = "Legs",
        [7]  = "Legs",
        [8]  = "Head",
        [10] = "Gear"
    }

    local hitbox_points = {
        {
            scale = 5,
            hitbox = "Stomach",
            vec = vector(0, 0, 40)
        },

        {
            scale = 6,
            hitbox = "Chest",
            vec = vector(0, 0, 50)
        },

        {
            scale = 3,
            hitbox = "Head",
            vec = vector(0, 0, 58)
        },

        {
            scale = 4,
            hitbox = "Legs",
            vec = vector(0, 0, 20)
        }
    }

    local function contains(list, value)
        for i = 1, #list do
            if list[i] == value then
                return true
            end
        end

        return false
    end

    local function is_weapon_gun(type)
        return type >= 1 and type <= 6
    end

    local function get_aimbot_targets()
        local list = { }

        local player_resource = entity.get_player_resource()

        for i = 1, globals.max_players do
            local player = entity.get(i)

            if player == nil then
                goto continue
            end

            local is_target_valid = player_resource.m_bConnected[i]
                and player:is_enemy() and player:is_dormant()

            if not is_target_valid then
                goto continue
            end

            table.insert(list, player)
            ::continue::
        end

        return list
    end

    local function create_multipoints(from, to, radius)
        local angles = from:to(to):angles()
        local radian = math.rad(angles.y + 90)

        local forward = vector(math.cos(radian), math.sin(radian), 0)
        local direction = forward * radius

        return {
            {
                text = "Middle",
                vec = to
            },

            {
                text = "Left",
                vec = to + direction
            },

            {
                text = "Right",
                vec = to - direction
            }
        }
    end

    local function trace_bullet(player, start_pos, end_pos, skip)
        local damage, trace = utils.trace_bullet(player, start_pos, end_pos, skip)

        if trace ~= nil then
            local ent = trace.entity

            if ent == nil then
                return 0, trace
            end

            if ent:is_player() and not ent:is_enemy() then
                return 0, trace
            end
        end

        return damage, trace
    end

    local function on_createmove(cmd)
        reference.ragebot.enable.da:override(false)

        local me = entity.get_local_player()

        if me == nil then
            return
        end

        local weapon = me:get_player_weapon()

        if weapon == nil then
            return
        end

        local weapon_info = weapon:get_weapon_info()

        if weapon_info == nil then
            return
        end

        local inaccuracy = weapon:get_inaccuracy()

        if inaccuracy == nil then
            return
        end

        local tickcount = globals.tickcount

        local eye_pos = me:get_eye_position()
        local simtime = me:get_simulation_time().current

        local onground = bit.band(me.m_fFlags, bit.lshift(1, 0)) ~= 0

        if tickcount < round_started then
            return
        end

        if cmd.in_jump and not onground then
            return
        end

        local weapon_type = weapon_info.weapon_type

        if not is_weapon_gun(weapon_type) or weapon.m_iClip1 <= 0 then
            return false
        end

        local targets = get_aimbot_targets()
        local hitboxes = menu.other.dormant_aimbot.hitboxes:get()

        if tickcount % #targets ~= 0 then
            target_index = target_index + 1
        else
            target_index = 1
        end

        local target = targets[target_index]

        if target == nil then
            return
        end

        local bbox = target:get_bbox()
        local origin = target:get_origin()

        local duck_amount = target.m_flDuckAmount

        local hitchance = menu.other.dormant_aimbot.hitchance:get()
        local desired_damage = menu.other.dormant_aimbot.damage:get()

        if desired_damage == -1 then
            desired_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()
        end

        if desired_damage > 100 then
            desired_damage = desired_damage - 100 + target.m_iHealth
        end

        local points = { }

        for i = 1, #hitbox_points do
            local data = hitbox_points[i]

            local vec = data.vec
            local scale = data.scale
            local hitbox = data.hitbox

            if hitbox == "Head" then
                vec = vec - vector(0, 0, 10 * duck_amount)
            end

            if hitbox == "Chest" then
                vec = vec - vector(0, 0, 4 * duck_amount)
            end

            if #hitboxes ~= 0 then
                if contains(hitboxes, hitbox) then
                    table.insert(points, {
                        vec = vec,
                        scale = scale,
                        hitbox = hitbox
                    })
                end
            else
                table.insert(points, 1, {
                    vec = vec,
                    scale = scale,
                    hitbox = hitbox
                })
            end
        end

        local is_available_to_shoot = weapon_info.is_revolver and weapon.m_flNextPrimaryAttack < simtime
            or math.max(me.m_flNextAttack, weapon.m_flNextPrimaryAttack, weapon.m_flNextSecondaryAttack) < simtime

        if not is_available_to_shoot then
            return
        end

        local found_pos
        local found_damage

        if hitchance >= math.floor(bbox.alpha * 100) + 5 then
            return
        end

        for j = 1, #points do
            local point = points[j]
            local multipoints = create_multipoints(eye_pos, origin + point.vec, point.scale)

            for k = 1, #multipoints do
                local multipoint = multipoints[k]
                local aimpoint = multipoint.vec

                local damage, tr = trace_bullet(me, eye_pos, aimpoint, function(ent)
                    return ent == target
                end)

                if tr ~= nil and tr:is_visible() then
                    goto continue
                end

                if damage ~= 0 and desired_damage < damage then
                    found_pos = aimpoint
                    found_damage = damage

                    aim_target = target
                    aim_hitbox = point.hitbox
                    aim_damage = damage
                    aim_point = multipoint.text
                    aim_accuracy = bbox.alpha

                    break
                end

                ::continue::
            end

            if found_pos and found_damage then
                break
            end
        end

        if not found_pos or not found_damage then
            return
        end

        local angles = eye_pos:to(found_pos):angles()

        cmd.block_movement = 1

        if menu.other.dormant_aimbot.auto_scope:get() then
            local is_onground = not cmd.in_jump and onground

            local is_scoped = me.m_bIsScoped or me.m_bResumeZoom
            local is_sniper = weapon_info.weapon_type == WEAPONTYPE_SNIPER_RIFLE

            if not is_scoped and is_sniper and is_onground then
                cmd.in_attack2 = true
            end
        end

        if inaccuracy < 0.01 then
            cmd.view_angles = angles
            cmd.in_attack = true

            is_shot = true
        end
    end

    local function on_weapon_fire(e)
        utils.execute_after(0.03, function()
            if entity.get(e.userid, true) == entity.get_local_player() then
                if is_shot and not is_hit then
                    events["dormant_miss"]:call {
                        userid = aim_target,
                        aim_hitbox = aim_hitbox,
                        aim_damage = aim_damage,
                        aim_point = aim_point,
                        accuracy = aim_accuracy
                    }
                end

                is_hit = false
                is_shot = false

                aim_target = nil
                aim_hitbox = nil
                aim_damage = nil
                aim_point = nil
                aim_accuracy = nil
            end
        end)
    end

    local function on_player_hurt(e)
        local me = entity.get_local_player()

        local userid = entity.get(e.userid, true)
        local attacker = entity.get(e.attacker, true)

        if userid == nil or attacker ~= me then
            return
        end

        local bbox = userid:get_bbox()

        if bbox == nil then
            return
        end

        if userid:is_dormant() and is_shot == true then
            is_hit = true

            events["dormant_hit"]:call {
                userid = userid,
                attacker = attacker,
                health = e.health,
                armor = e.armor,
                weapon = e.weapon,
                dmg_health = e.dmg_health,
                dmg_armor = e.dmg_armor,
                hitgroup = e.hitgroup,
                accuracy = bbox.alpha,
                hitbox = e_hitbox[e.hitgroup],
                aim_point = aim_point,
                aim_hitbox = aim_hitbox,
                aim_damage = aim_damage
            }
        end
    end

    local function on_shutdown()
        reference.ragebot.enable.da:override()
    end

    menu.other.dormant_aimbot:set_callback(function(item)
        local value = item:get()

        if not value then
            reference.ragebot.enable.da:override()
        end

        events.shutdown(on_shutdown, value)
        events.createmove(on_createmove, value)

        events.weapon_fire(on_weapon_fire, value)
        events.player_hurt(on_player_hurt, value)
    end, true)


    local HITGROUPS = {
        [0] = 'generic',
        'head', 'chest', 'stomach',
        'left arm', 'right arm',
        'left leg', 'right leg',
        'neck', 'generic', 'gear'
    }

    function lerp(a, b, t)
        return a + (b - a) * t
    end

    local tables = {notifications = {}, session_info = {kills = 0, hits = 0, misses = 0, headshots = 0, deaths = 0}}
    local screen_log = function(text, change_color)
    
        if text == "" then
            return 
        end
    
        table.insert(tables.notifications, {
            string = text,
    
            timer = 0,
            alpha = 0,
            color = change_color
        })
    end

    local frametime = function()
        local _ft = globals.frametime * 8
        return _ft
    end

    local render_logs = function()

        
        local x, y = render.screen_size().x, render.screen_size().y
        local add_y = 0
        for i, v in ipairs(tables.notifications) do
            local positions = {
    
                ["Centered"] = {
                    background = {
                        starting = vector(x/2 - 8 - render.measure_text(1, nil, v.string).x/2, y/2 + 90 + add_y),
                        ending = vector(x/2 + render.measure_text(1, nil, v.string).x + 7 - render.measure_text(1, nil, v.string).x/2, y/2 + 110 + add_y)
                    },
    
                    text = {
                        position = vector(x/2 - render.measure_text(1, nil, v.string).x/2, y/2 + 93 + add_y)
                    }
                }
            }
    
            
            v.timer = v.timer + (0.19*render.measure_text(1, nil, v.string).x*0.0115)*frametime()*10
    
            if math.max(0,(render.measure_text(1, nil, v.string).x + 1 - v.timer)) > 0 then
                v.alpha = lerp(v.alpha, 1, frametime())
            end
        
            render.shadow(positions["Centered"].background.starting + 10, positions["Centered"].background.ending - 10, color(255 ,255 ,255, v.alpha*130), 25, 0, 0)
            render.text(1, positions["Centered"].text.position, color(255, 255, 255, v.alpha*255), nil, v.string)
    
            if math.max(0,(render.measure_text(1, nil, v.string) + 1 - v.timer).x) == 0 or #tables.notifications > 5 then
                v.alpha = lerp(v.alpha, 0, frametime()*2)
            end
    
            if v.alpha < 0.01 or #tables.notifications > 5 then
                table.remove(tables.notifications, i)
            end
    
            add_y = math.floor(add_y + 25 * v.alpha)
        end
    end

    
    local ambot_logs = function(ctx)
        if not menu.other.aimbot_logs:get() then return end
        local miss_clr = menu.other.aimbot_logs.missswitch.color:get():to_hex()
        local hit_clr = menu.other.aimbot_logs.hitswitch.color:get():to_hex()
        local local_player = entity.get_local_player()
        local enenmy = entity.get(ctx.target)
        local enenmy_damage = ctx.damage
        local enenmy_wanted_damage = ctx.wanted_damage
        local enenmy_wanted_hitgroup = HITGROUPS[ctx.wanted_hitgroup]
        local hitchance = ctx.hitchance
        local misstype = ctx.state
        local backtrack = ctx.backtrack
        if not enenmy then return end
        if enenmy == nil then return end
        local health = enenmy["m_iHealth"]
        local hitgroup = HITGROUPS[ctx.hitgroup]
        
        if menu.other.aimbot_logs.hitswitch:get("\v\f<person-circle-exclamation>\r  hit") then 
            if misstype == nil then
                if not globals.is_connected and not globals.is_in_game then return false end
                --..hitgroup..
                --..enenmy_damage..
                --..hitchance..
                --..enenmy_wanted_damage..
                --..health..
                --..enenmy_wanted_hitgroup..
                --..enenmy:get_name()..
                if menu.other.aimbot_logs.loglist:get("Console") then
                    print_raw("     \a".. hit_clr.."Laura\aDEFAULT · Hit "..enenmy:get_name().." in "..hitgroup.."("..enenmy_wanted_hitgroup..")".." for "..enenmy_damage.."("..enenmy_wanted_damage..")".." damage".." [ hitchance: "..hitchance.." | backtrack "..backtrack.." ]")
                end

                if menu.other.aimbot_logs.loglist:get("Screen") then
                    print_dev("\a".. hit_clr.."Laura\aDEFAULT · Hit "..enenmy:get_name().." in "..hitgroup.."("..enenmy_wanted_hitgroup..")".." for "..enenmy_damage.."("..enenmy_wanted_damage..")".." damage".." [ hitchance: "..hitchance.." | backtrack "..backtrack.." ]")
                end

                if menu.other.aimbot_logs.loglist:get("Render") then
                    screen_log("\a" .. hit_clr.. ui.get_icon "check" .. "\aDEFAULT Hit \a"..hit_clr..enenmy:get_name().."'s\aDEFAULT in the \a"..hit_clr..hitgroup.."\aDEFAULT for \a"..hit_clr..enenmy_damage.."\aDEFAULT dmg", false)
                end
            end
        end
        if menu.other.aimbot_logs.missswitch:get("\v\f<person-circle-question>\r  miss") then 
            if misstype ~= nil then
                if menu.other.aimbot_logs.loglist:get("Console") then
                    print_raw("     \a".. miss_clr.."Laura\aDEFAULT · Missed shot due to "..enenmy_wanted_hitgroup.." at "..enenmy:get_name().." in the "..misstype.." for "..enenmy_wanted_damage.." damage".." [ hitchance: "..hitchance.." | backtrack "..backtrack.." ]")
                end
                if menu.other.aimbot_logs.loglist:get("Screen") then
                    print_dev("\a".. miss_clr.."Laura\aDEFAULT · Missed shot due to "..enenmy_wanted_hitgroup.." at "..enenmy:get_name().." in the "..misstype.." for "..enenmy_wanted_damage.." damage".." [ hitchance: "..hitchance.." | backtrack "..backtrack.." ]")
                end

                if menu.other.aimbot_logs.loglist:get("Render") then
                    screen_log("\a" .. miss_clr.. ui.get_icon "xmark" ..  "\aDEFAULT Missed \a"..miss_clr..enenmy:get_name().."\aDEFAULT due to \a"..miss_clr..misstype.."\aDEFAULT in the \a"..miss_clr..enenmy_wanted_hitgroup, false)
                end
            end
        end


    end

    events.aim_ack:set(function(shot)
        ambot_logs(shot)
    end)

    events.render:set(function()
        render_logs()
    end)
end

local supertoss do
    local function compensate_throwable(angles, throw_velocity, throw_strength, velocity)
        angles.x = angles.x - 10 + math.abs(angles.x) / 9

        local goal_forward = vector():angles(angles)
        local player_vel = velocity * 1.25

        local vel = math.clamp(throw_velocity * 0.9, 15, 750)
        local clamped_throw_strength = math.clamp(throw_strength, 0, 1)

        vel = vel * lerp(0.3, 1.0, clamped_throw_strength)

        local new_forward = goal_forward

        for _ = 1, 8 do
            new_forward = (goal_forward * (new_forward * vel + player_vel):length() - player_vel) / vel
            new_forward:normalize()
        end

        local new_angles = new_forward:angles()

        if new_angles.x > -10 then
            new_angles.x = 0.9 * new_angles.x + 9
        else
            new_angles.x = 1.125 * new_angles.x + 11.25
        end

        return new_angles
    end

    callbacks.createmove(function(e)
        if not menu.other.super_toss:get() then
            return
        end

        local me = entity.get_local_player()
        if not me then return end

        local weapon = me:get_player_weapon()
        if not weapon then return end

        local weapon_info = weapon:get_weapon_info()
        if not weapon_info or weapon_info.weapon_type ~= 9 or weapon.m_fThrowTime < globals.curtime or not e.jitter_move then
            return
        end

        local simulation = me:simulate_movement()
        simulation:think()

        e.view_angles = compensate_throwable(e.view_angles, weapon_info.throw_velocity, weapon.m_flThrowStrength, simulation.velocity)
    end)

    callbacks.grenade_override_view(function(e)
        if not menu.other.super_toss:get() then
            return
        end

        local me = entity.get_local_player()
        if not me then return end

        local weapon = me:get_player_weapon()
        if not weapon then return end

        local weapon_info = weapon:get_weapon_info()
        if not weapon_info then return end

        e.angles = compensate_throwable(e.angles, weapon_info.throw_velocity, weapon.m_flThrowStrength, e.velocity)
    end)
end

local localplayer_transparency = function()
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() then return end

    if menu.other.keep_model_transparency:get() then 
        return (lp.m_bIsScoped or lp.m_bResumeZoom) and 59 or 255
    end
end

events.localplayer_transparency:set(localplayer_transparency)
-- @ENDREGION

-- @REGION: tooltips
menu.antiaim.extra.avoidbackstab:tooltip("Automatically deploys your model so that your opponent cannot stab you in 1 hit.")
menu.antiaim.extra.safehead:tooltip("Changes the position of the head while flying with the knife.")
menu.antiaim.extra.forcedef:tooltip("Automatically makes your fakelag disappear at a certain character position.")
menu.antiaim.hotkeys.freestand:tooltip("Automatically rotates the character's body based on the opponent's position to avoid hs.")
menu.antiaim.hotkeys.manuals:tooltip("Allows you to independently rotate the character model at your discretion.")
animations_enable:tooltip("Changes the animation of your character.")

menu.other.hitchance_indicator:tooltip("You will see an inscription on your screen that shows your minimum hitchance.")
menu.other.damage_indicator:tooltip("You will see an inscription on your screen that shows your minimum damage.")
menu.other.hitmarker:tooltip("After the shot draws a cross showing the place where you hit the opponent.")
menu.other.clantag:tooltip("Includes a caption with the name of our lua in tab.")
menu.other.viewmodel:tooltip("Allows you to change the location of your hands.")
menu.other.scope_overlay:tooltip("Allows you to make a versatile scope for you.")
menu.other.aspectratio:tooltip("Allows you to stretch your resolution to your desired width.")
menu.other.aimbot_logs:tooltip("Gives information about your encounter with the enemy.")
menu.other.dormant_aimbot:tooltip("Helps the cheat to fire even if the wh on the opponent is absent.")
menu.other.fakelatency:tooltip("Makes your ping much higher, which allows for a higher chance of backtracking.")
menu.other.keep_model_transparency:tooltip("Leaves your model transparent even after a shot, but until you exit the scope.")
menu.other.nofalldamage:tooltip("Tries to minimize the resulting damage from the fall.")
menu.other.fastladder:tooltip("Makes your stair climbing much faster.")
menu.other.nade_throw_fix:tooltip("Automatically turns off the quick switch feature so that your grenades are thrown without delay.\n\n             \aFF3C3CFF( Can break supertoss )")
menu.other.super_toss:tooltip("Makes your grenades fly with less dispersion.")
menu.other.SideIndicators:tooltip("Creates indicators on the left side of the screen, they help you navigate the buttons used.")
menu.other.trashtalk:tooltip("Sends messages in chat, these messages provoke the opponent.")
-- @ENDREGION

--@REGION: config system
local config = pui.setup({menu.main, menu.antiaim, menu.other, antiaim_builder}, true)
local low_iq_fix = {backup = 1}

menu.main.create:set_callback(function()
    c_input = menu.main.input:get()
    if c_input == "" then print_raw("Failed to create config: empty config name") utils.console_exec("play resource\\warning.wav") return end
    for i, v in pairs(configs_database.ui_list) do if c_input == v then print_raw("Failed to create config: config with this name already exists", true) utils.console_exec("play resource\\warning.wav") return end end

    -- getting current antiaim settings
    local data = config:save()
    local encrypted = "Laura_"..base64.encode(json.stringify(data))

    -- managing database and updating ui config list
    table.insert(configs_database.ui_list, c_input)
    table.insert(configs_database.config_list, encrypted)
    menu.main.input:set("")

    db.Lauraconfigs = configs_database

    for k, v in ipairs(configs_database.ui_list) do
        configs_database.ui_list[k] = configs_database.ui_list[k]:gsub("\a"..ui.get_style("Link Active"):to_hex()..">>  \aDEFAULT", "")
    end
    configs_database.ui_list[#configs_database.ui_list] = "\a"..ui.get_style("Link Active"):to_hex()..">>  \aDEFAULT"..configs_database.ui_list[#configs_database.ui_list]
    
    menu.main.list:update(configs_database.ui_list)
    
    cvar.play:call("ambient\\tones\\elev1")
end)

menu.main.save:set_callback(function()
    if menu.main.list:get() == 1 then print_raw("Failed to save config: you cant change default config") utils.console_exec("play resource\\warning.wav") return end

    low_iq_fix.backup = menu.main.list:get()

    local data = config:save()
    local encrypted = "Laura_"..base64.encode(json.stringify(data))

    for i, v in pairs(configs_database.config_list) do
        if i == menu.main.list:get() then
            configs_database.config_list[i] = encrypted
        end
    end

    db.Lauraconfigs = configs_database

    for k, v in ipairs(configs_database.ui_list) do
        configs_database.ui_list[k] = configs_database.ui_list[k]:gsub("\a"..ui.get_style("Link Active"):to_hex()..">>  \aDEFAULT", "")
    end
    configs_database.ui_list[menu.main.list:get()] = "\a"..ui.get_style("Link Active"):to_hex()..">>  \aDEFAULT"..configs_database.ui_list[menu.main.list:get()]

    menu.main.list:update(configs_database.ui_list)

    cvar.play:call("ambient\\tones\\elev1")
end)

menu.main.load:set_callback(function()
    low_iq_fix.backup = menu.main.list:get()

    selected_config = configs_database.config_list[menu.main.list:get()]:gsub("Laura_", "")
    local decrypted = json.parse(base64.decode(selected_config))
    config:load(decrypted)

    menu.main.list:set(low_iq_fix.backup)
    menu.main.input:set("")

    for k, v in ipairs(configs_database.ui_list) do
        configs_database.ui_list[k] = configs_database.ui_list[k]:gsub("\a"..ui.get_style("Link Active"):to_hex()..">>  \aDEFAULT", "")
    end

    configs_database.ui_list[low_iq_fix.backup] = "\a"..ui.get_style("Link Active"):to_hex()..">>  \aDEFAULT"..configs_database.ui_list[low_iq_fix.backup]

    menu.main.list:update(configs_database.ui_list)
    
    cvar.play:call("ambient\\tones\\elev1")
end)

menu.main.delete:set_callback(function()
    if menu.main.list:get() == 1 then print_raw("Failed to delete config: you cant delete default config") utils.console_exec("play resource\\warning.wav") return end

    for i, v in pairs(configs_database.config_list) do
        if i == menu.main.list:get() then
            table.remove(configs_database.config_list, i)
            table.remove(configs_database.ui_list, i)
        end
    end

    db.Lauraconfigs = configs_database
    menu.main.list:update(configs_database.ui_list)

    cvar.play:call("ambient\\tones\\elev1")
end)

menu.main.export:set_callback(function()
    clipboard.set(json.stringify(config:save()))
    cvar.play:call("ambient\\tones\\elev1")
end)

menu.main.import:set_callback(function()
    config:load(json.parse(clipboard.get()))
    cvar.play:call("ambient\\tones\\elev1")
end)
--@ENDREGION