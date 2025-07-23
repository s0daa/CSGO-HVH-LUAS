-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

---@diagnostic disable: undefined-field, deprecated, undefined-global

(function(...)
    print_dev("[DEV] LOADED OPTIMIZATIONS: ", table.concat({...}, ", "))
	return jit.opt.start(...)
end)(
    "hotloop=4",
    "maxtrace=500",
    "loopunroll=8",
    "fold",
    "dce",
    "fwd",
    "maxmcode=8192"
)

local common_add_event, common_get_username, utils_random_seed, common_get_timestamp, utils_console_exec, o_error, ui_sidebar, render_gradient, render_text, json_stringify, json_parse, math_min, math_max, math_abs, math_sqrt, math_floor, type, pcall, utils_random_int, utils_random_float = common.add_event, common.get_username, utils.random_seed, common.get_timestamp, utils.console_exec, error, ui.sidebar, render.gradient, render.text, json.stringify, json.parse, math.min, math.max, math.abs, math.sqrt, math.floor, type, pcall, utils.random_int, utils.random_float

utils_random_seed(common_get_timestamp())

local function error(message)
    message = "[error manager] - "..message
    utils_console_exec("play resource\\warning.wav")
    o_error(message, 0)
end

local info = {} do
    info.username = common_get_username()
end

local pui = require("neverlose/pui")
local base64 = require("neverlose/base64")
local clipboard = require("neverlose/clipboard")

local lagrecord do
	lagrecord = require 'neverlose/lagrecord'
	lagrecord = lagrecord^lagrecord.SIGNED
end

lagrecord.set_update_callback(function(player)
    if player == entity.get_local_player() then
        return true
    end
end)

local ffi_cast, bit_band, bit_lshift, entity_get_local_player = ffi.cast, bit.band, bit.lshift, entity.get_local_player

ffi.cdef[[
typedef struct {
    char pad_0x0000[0x18];
    uint32_t sequence;
    float prev_cycle;
    float weight;
    float weight_delta_rate;
    float playback_rate;
    float cycle;
    void *entity;
    char pad_0x0038[0x4];
} AnimationLayer;
]]

local ref = {} do
    ref = {
        ["Enabled"] = pui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
        ["Pitch"] = pui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),

        ["Yaw"] = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw", {
            ["Base"] = "Base",
            ["Offset"] = "Offset",
            ["Avoid Backstab"] = "Avoid Backstab",
            ["Hidden"] = "Hidden"
        }),

        ["Yaw Modifier"] = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", {
            ["Offset"] = "Offset"
        }),

        ["Body Yaw"] = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", {
            ["Inverter"] = "Inverter",
            ["Left Limit"] = "Left Limit",
            ["Right Limit"] = "Right Limit",
            ["Options"] = "Options",
            ["Freestanding"] = "Freestanding"
        }),

        ["Slow Walk"] = pui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
        ["Fake Duck"] = pui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),

        ["Double Tap"] = pui.find("Aimbot", "Ragebot", "Main", "Double Tap", {
            ["Options"] = "Lag Options"
        }),

        ["Hide Shots"] = pui.find("Aimbot", "Ragebot", "Main", "Hide Shots", {
            ["Options"] = "Options"
        }),

        ["Freestanding"] = pui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
        ["Fake Lag"] = pui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
        ["Limit"] = pui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
        ["Variability"] = pui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability"),
        ["Leg Movement"] = pui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
    }
end

local manager = new_class()

:struct("events"){
    wrap = function(self, name, fn_name, fn)
        local event_handler = function(...)
            local success, result = pcall(fn, ...)
            if not success then
                error(tostring(fn_name) .. " - " .. tostring(name) .. ": " .. result:gsub("%[\".-\"%]:%d+: ", ""))
            end

            return result
        end

        events[name]:set(event_handler)
    end
}

:struct("ui") {
    groups = {
        home = pui.create("\f<house>", {
            {"welcome", "Main"},
            {"config", "Configuration"}
        }),
        anti_aim = pui.create("\f<shield>", {
            {"tab_selector", "Tab Selector", 1},
            {"main", "\nMain", 1},
            {"setts", "\nSettings", 2},
            {"misc", "Misc", 2},
            {"additions", "Additions", 2}
        }),

        other = pui.create("\f<gear>", {
            {"rage", "RageBot", 1},
            {"visuals", "Visuals", 2},
            {"misc", "Miscellaneous"},
        })
    }
}

:struct("render") {
    lerp = function(a, b, t)
        return a + (b - a) * t
    end
}

local builder_states = {"Default", "Standing", "Moving", "Slow Walking", "Crouching", "Crouching & Moving", "In Air", "In Air & Crouching"}
local defensive_states = {"Standing", "Moving", "Slow Walking", "Crouching", "Crouching & Moving", "In Air", "In Air & Crouching"}

local menu = {}

menu.info = {
    manager.ui.groups.home.welcome:label("Welcome back, \v" .. info.username .. "\r!"),
    export = manager.ui.groups.home.config:button("Export Configuration"),
    default = manager.ui.groups.home.config:button("Default Configuration"),
    import = manager.ui.groups.home.config:button("Import Configuration"),
}

pui.colors.red = color(255, 0, 0)
pui.colors.yellow = color(255, 223, 0)

menu.antiaim = {
    tab_selector = manager.ui.groups.anti_aim.tab_selector:list("", {"General", "Builder"}),

    main = {

    mode = manager.ui.groups.anti_aim.setts:combo(
        "Mode", {"Disabled", "Meta", "Classic", "Conditional"}
    ),

    state = manager.ui.groups.anti_aim.setts:combo("Current State", builder_states),

    manual = manager.ui.groups.anti_aim.setts:combo(
        "Manual", {"Disabled", "Left", "Right", "Forward"},
        function(gear)
            return {
                ind = gear:switch("Arrows"),
                manoverfs = gear:switch("Manual over FS")
            }
        end
    ),

    breaklcon = manager.ui.groups.anti_aim.main:selectable("Force Defensive", defensive_states),

    def = manager.ui.groups.anti_aim.main:switch(
        "Defensive AA",
        false,
        function(gear)
            return {
                mode = gear:combo("Mode", {"Default", "Extend"}),
                states = gear:selectable("States", defensive_states),
                pitch = gear:combo("Pitch", {"Up", "Up Switch", "Zero", "Down Switch", "Down", "PAKETA"}),
                yaw = gear:combo("Yaw", {"Spinbot", "Opposite", "3-Way", "5-Way", "Sideways", "Random"}),
                spin_speed = gear:slider("Speed", 1, 5)
            }
        end
    ),

    animbreak = manager.ui.groups.anti_aim.main:switch("Anim. Breaker", false, function(gear)
        return {
            air = gear:combo("Air Legs", {"Default", "Directional", "Force Falling"}),
            ground = gear:combo("Ground Legs", {"Default", "Static", "Directional", "Jitter"}),
            move_lean_force = gear:slider("Lean Force", 0, 100, 0, 1, function(value)
                if value == 0 then
                    return "Default"
                else
                    return value .. "%"
                end
            end),
        }
    end),

    flick_bind = manager.ui.groups.anti_aim.main:switch("\a[yellow] Flick Exploit Bind"),

    additions = manager.ui.groups.anti_aim.additions:listable("Additions", {"Warmup AA", "Avoid Backstab", "Safe Head", "Manual AA", "\a[yellow]Defensive Flick Exploit", "\a[yellow]Defensive Edge Bait", "\a[yellow]Defensive Flick on Safe"})
    }
}

menu.antiaim.main.flick_bind:depend({menu.antiaim.main.additions, 5})
menu.antiaim.main.manual:depend({menu.antiaim.main.additions, 4})

for _, item in pairs(menu.antiaim.main) do
    if tostring(_) == "mode" or tostring(_) == "state" or tostring(_) == "def" then

    else
        item:depend({menu.antiaim.tab_selector, 1})
    end
end

menu.antiaim.main.def:depend({menu.antiaim.tab_selector, 1}, {menu.antiaim.main.mode, "Conditional", true})

local preset_label = manager.ui.groups.anti_aim.misc:label("\vAnti-Aim \ris already \vset-up\r!")

local mode_ref = menu.antiaim.main.mode
local antiaim_state = menu.antiaim.main.state
mode_ref:depend({menu.antiaim.tab_selector, 2})
preset_label:depend({mode_ref, "Conditional", true}, {mode_ref, "Disabled", true}, {menu.antiaim.tab_selector, 2})

menu.antiaim.builder = {}
menu.antiaim.defensive_builder = {}

antiaim_state:depend({mode_ref, "Conditional"}, {menu.antiaim.tab_selector, 2})

for key, _ in pairs(builder_states) do
    manager.ui.groups[key] = pui.create("\f<shield>", _ .. " angles", 2)
    manager.ui.groups["defensive_"..key] = pui.create("\f<shield>", "\n" ..  _ .. " Angles [Defensive]", 2)

    local override = manager.ui.groups.anti_aim.setts:switch("Override \v"..builder_states[key])
    local pitch = manager.ui.groups[key]:combo(ref["Pitch"]:name(), ref["Pitch"]:list())
    local yaw = manager.ui.groups[key]:combo(ref["Yaw"]:name(), ref["Yaw"]:list(), function (gear)
        return {
            base = gear:combo(ref["Yaw"]["Base"]:name(), ref["Yaw"]["Base"]:list()),
            offset_left = gear:slider("Offset Left", -180,180,0),
            offset_right = gear:slider("Offset Right", -180,180,0)
        }
    end)
    local yaw_mod = manager.ui.groups[key]:combo(ref["Yaw Modifier"]:name(), ref["Yaw Modifier"]:list(), function (gear)
        return {
            offset = gear:slider("Offset", -180,180,0),
            randomization = gear:slider("Randomization", 0,180,0)
        }
    end)

    local body_yaw = manager.ui.groups[key]:switch(ref["Body Yaw"]:name(), false, function(gear)
        return {
            inverter = gear:switch(ref["Body Yaw"]["Inverter"]:name()),
            desync_limit = gear:slider("Desync Limit", 0, 60, 0),
            desync_randomization = gear:slider("Desync Randomization", 0, 60, 0),
            options = gear:selectable(ref["Body Yaw"]["Options"]:name(), ref["Body Yaw"]["Options"]:list()),
            delay = gear:slider("Delay", 0, 15, 0),
            freestanding = gear:combo(ref["Body Yaw"]["Freestanding"]:name(), ref["Body Yaw"]["Freestanding"]:list())
        }
    end)

    menu.antiaim.builder[key] = {
        override = override,
        pitch = pitch,
        yaw = yaw,
        yaw_mod = yaw_mod,
        body_yaw = body_yaw
    }

    local defensive_ui = {
        enabled = manager.ui.groups["defensive_"..key]:switch("\vDefensive \rAA"),
        pitch = manager.ui.groups["defensive_"..key]:combo("Pitch", {"Up", "Up Switch", "Zero", "Down Switch", "Down", "PAKETA", "Custom"}, function(gear)
            return {
                custom = gear:slider("Custom Pitch", -89, 89)
            }
        end),

        yaw = manager.ui.groups["defensive_"..key]:combo("Yaw", {"Spinbot", "Opposite", "3-Way", "5-Way", "Sideways", "Random", "Custom Jitter"}, function(gear)
            return {
                speed = gear:slider("Speed", 1, 5),
                custom1 = gear:slider("Jitter #1", -180, 180, 0),
                custom2 = gear:slider("Jitter #2", -180, 180, 0)
            }
        end),
    }

    menu.antiaim.defensive_builder[key] = {
        override = defensive_ui.enabled,
        pitch = defensive_ui.pitch,
        yaw = defensive_ui.yaw,
    }

    local BuilderKey = menu.antiaim.builder[key]
    local first_override = menu.antiaim.builder[1].override
    first_override:set(true)
    local depend_args_ovkey = {{mode_ref, "Conditional"}, {antiaim_state, builder_states[key]}, {antiaim_state, "Default", true}, {menu.antiaim.tab_selector, 2} }
    local depend_args = {{mode_ref, "Conditional"}, {antiaim_state, builder_states[key]}, {BuilderKey.override, true}, {menu.antiaim.tab_selector, 2} }

    BuilderKey.override:depend(unpack(depend_args_ovkey))
    BuilderKey.pitch:depend(unpack(depend_args))
    BuilderKey.yaw:depend(unpack(depend_args))
    BuilderKey.yaw_mod:depend(unpack(depend_args))
    BuilderKey.body_yaw:depend(unpack(depend_args))
    BuilderKey.body_yaw.delay:depend({BuilderKey.body_yaw.options, "Jitter"})

    local DefensiveKey = menu.antiaim.defensive_builder[key]
    local depend_args_defensive = {{mode_ref, "Conditional"}, {antiaim_state, builder_states[key]}, {BuilderKey.override, true}, {DefensiveKey.override, true}, {menu.antiaim.tab_selector, 2} }
    DefensiveKey.override:depend(unpack(depend_args))
    DefensiveKey.pitch:depend(unpack(depend_args_defensive))
    DefensiveKey.yaw:depend(unpack(depend_args_defensive))

    DefensiveKey.pitch.custom:depend({DefensiveKey.pitch, "Custom"})


    DefensiveKey.yaw.speed:depend({DefensiveKey.yaw, "Spinbot"})
    DefensiveKey.yaw.custom1:depend({DefensiveKey.yaw, "Custom Jitter"})
    DefensiveKey.yaw.custom2:depend({DefensiveKey.yaw, "Custom Jitter"})
end

local defensive_spin_speed = menu.antiaim.main.def.spin_speed
local defensive_yaw = menu.antiaim.main.def.yaw

defensive_spin_speed:depend({defensive_yaw, "Spinbot"})


menu.misc = {
    aim = manager.ui.groups.other.rage:selectable("Aimbot Logs", {"Console", "Events", "Notify"}, function(gear)
        return {
            purchases = gear:switch(string.format("Include \vPurchases")),
        }
    end),

    scope_overlay = manager.ui.groups.other.visuals:switch(string.format("\vCustom \rScope Overlay"),false,function(gear)
        return {
            opt = gear:selectable("Options", {"Inverted", "Rotated", "Animated"}),
			clr = gear:color_picker("Color", color(255, 255, 255, 255)),
			line = gear:slider("Line", 1, 300),
			gap = gear:slider("Gap", 1, 100)
        }
    end)
}

local manual_refs = {ind = true, manual = true, clr = true}

manual_refs.ind = menu.antiaim.main.manual.ind
manual_refs.manual = menu.antiaim.main.manual
manual_refs.manoverfs = menu.antiaim.main.manual.manoverfs

menu.antiaim.main.manual.manual_color = manual_refs.ind:color_picker(color(255, 255, 255, 255))

manual_refs.clr = menu.antiaim.main.manual.manual_color

local ctx = {}
do
    ctx.misc = {
        hitgroup_str = {
            [0] = "generic",
            "head",
            "chest",
            "stomach",
            "left arm",
            "right arm",
            "left leg",
            "right leg",
            "neck",
            "generic",
            "gear"
        },

        is_warmup = false,

        prefix = "\aDEFAULT[\a{Link Active}Bebra\aDEFAULTSense] \a555555FF• \aDEFAULT",

        icon_side = "😺",

        manuals = {
            ["Left"] = -90,
            ["Right"] = 90,
            ["Forward"] = 180
        }
    }

    ctx.antiaim = {
        enabled = false,
        pitch = "Disabled",
        yaw = {value = "Disabled", base = "Local View", offset = 0, avoid_backstab = false, hidden = false},
        yaw_modifier = {value = "Disabled", offset = 0},
        body_yaw = {value = false, inverter = false, left_limit = 0, right_limit = 0, options = {}, freestanding = "Off"},

        defensive = {
            enabled = false,
            state = "",
            pitch = 0,
            yaw = 0
        },

        state = "",
        idx = 0,
        current_side = ""
    }

    ctx.fakelag = {
        enabled = false,
        limit = 0,
        variability = 0
    }

    ctx.shots = {
        action = "",
        possible_actions = {
            ["taser"] = "Zeused",
            ["smokegrenade"] = "Smoked",
            ["snowball"] = "Snowballed",
            ["inferno"] = "Burned",
            ["hegrenade"] = "Naded",
            ["knife"] = "Knifed"
        }
    }

    ctx.render = {
        screen_size = render.screen_size(),
    }

    ctx.render.screen_center = ctx.render.screen_size * 0.5

    ctx.functions = {

        update_shots_action = function(cmd)
            local lp = entity_get_local_player()

            if lp ~= entity.get(cmd.attacker, true) then
                return
            end

            ctx.shots.action = ctx.shots.possible_actions[cmd.weapon] or "Hit"
        end,

        player = {
            get_flags = function(lp)
                return lp.m_fFlags
            end,

            get_crouch = function(flags)
                return bit.band(flags or 0, 4) == 4
            end,

            get_jumping = function(cmd, flags)
                return (bit.band(flags or 0, bit.lshift(1, 0)) == 0) or cmd.in_jump
            end,

            get_velocity = function(lp)
                return lp.m_vecVelocity
            end,

            sqrt_vel = function(vel)
                return math_sqrt(vel.x ^ 2 + vel.y ^ 2 + vel.z ^ 2)
            end,

            dt_charged = function()
                return rage.exploit:get() <= 0
            end,
        }
    }
end

manager.events:wrap("player_hurt", "Update shots", ctx.functions.update_shots_action)

local preview_alpha = 0
local preview_visible = true

local aimbot_logs = menu.misc.aim

local notifications = new_class()

:struct("main") {
    max = 12,
    ongoing = {},
    preview = {}
}

:struct("normal") {
    add = function(self,text,duration)
        table.insert(
            self.main.ongoing,
            {
                text = text,
                duration = duration,
                alpha = 0,
                offset = vector(0, 0)
            }
        )
    end,

    render = function(self)
        if #self.main.ongoing < 1 then return end
        render.pop_clip_rect()
        local frame_time = globals.frametime
        local screen_center = ctx.render.screen_center
        local offset = vector(0, 12)

        local total_notifications = #self.main.ongoing

        for i = 1, total_notifications do
            local notification = self.main.ongoing[i]

            if not notification then return end

            notification.offset = notification.offset:lerp(vector(0, (total_notifications - i) * offset.y), frame_time * 15)

            notification.duration = notification.duration - 1
            notification.is_visible = (notification.duration > 100)
            notification.alpha = manager.render.lerp(notification.alpha, notification.is_visible and 255 or 0, frame_time * 10)
            notification.displayed_text = string.sub(notification.text, 1, math_floor(notification.alpha / 255 * #notification.text))

            if total_notifications - i + 1 > self.main.max then
                notification.duration = math_min(notification.duration, 100)
            end

            if notification.duration <= 30 or total_notifications - i + 1 >= 32 then
                table.remove(self.main.ongoing, i)
            end

            local length = render.measure_text(1, "c", notification.displayed_text)

            render.push_clip_rect(
                screen_center + vector(-length.x / 2 - 4, 500 - notification.offset.y - 7),
                screen_center + vector(length.x / 2 + 4, 500 - notification.offset.y + 7),
                true
            )

            render.text(
                1,
                vector(screen_center.x, screen_center.y + 500 - notification.offset.y),
                color(255, 255, 255, notification.alpha),
                "c",
                notification.text
            )

            render.pop_clip_rect()
        end
    end


}

:struct("preview") {
    add = function(self,text)
        table.insert(
            self.main.preview,
            {
                text = text,
                offset = vector(0, 0)
            }
        )
    end,

    render = function(self)
        local frame_time = globals.frametime
        local screen_center = ctx.render.screen_center
        local offset = vector(0, 12)

        if ui.get_alpha() < 0.5 or #self.main.ongoing > 0 or not aimbot_logs:get("Notify") then
            for i = #self.main.preview, 1, -1 do
                local notification = self.main.preview[i]
                notification.offset = notification.offset:lerp(vector(0, 0), globals.frametime * 15)
                preview_visible = false
                preview_alpha = 0
            end
            return
        end

        preview_visible = true
        preview_alpha = manager.render.lerp(preview_alpha, preview_visible and 255 or 0, frame_time * 5)

        for i = #self.main.preview, 1, -1 do
            local notification = self.main.preview[i]
            notification.offset = notification.offset:lerp(vector(0, i * offset.y), frame_time * 15)
            render.text(
                1,
                vector(screen_center.x, screen_center.y + 500 - notification.offset.y),
                color(255, 255, 255, preview_alpha),
                "c",
                notification.text
            )
        end


        render.rect_outline(
            screen_center + vector(-400/2 - 20, 500),
            screen_center + vector(400/2 + 20, 490 - 144),
            color(255, 255, 255, preview_alpha/255*120),
            0,
            10,
            true
        )

        render.text(1, vector(screen_center.x, screen_center.y + 480 - 144), color(255,255,255,preview_alpha), "c", "Notifications \a{Link Active}Preview")
    end
}

local actions = {"Hit", "Missed", "Naded", "Burned", "Knifed", "Zeused", "Hit", "Hit", "Missed"}
local names = {"Mishkat", "Cage", "vitma", "v1pix", "demyaha", "Zabolotny", "KuCJloTa1337", "cutegirlgamer", "enQ", "Kaynel", "Derose", "Salvatore", "vektus", "XGAMING", "K1Z4RU", "Serene", "tylerdurden", "h3llfi5h", "L3D451R7", "huizhang233"}
local miss_reasons = {"spread", "correction", "misprediction", "prediction error", "backtrack failure", "damage rejection", "unregistered shot", "player death", "death"}

local used_names = {}

for i = 1, 12 do
    local action = actions[utils_random_int(1, #actions)]
    local name = names[utils_random_int(1, #names)]

    while used_names[name] do
        name = names[utils_random_int(1, #names)]
    end

    used_names[name] = true

    local dmg = utils_random_int(1, 100)
    local remaining_health = 100 - dmg
    local str = ""

    if action == "Hit" then
        str = string.format("%s \a{Link Active}%s\aDEFAULT's \a{Link Active}%s\aDEFAULT for \a{Link Active}%d\aDEFAULT damage (\a{Link Active}%d health remaining\aDEFAULT)", action, name, ctx.misc.hitgroup_str[utils_random_int(1,8)], dmg, remaining_health)
    elseif action == "Missed" then
        local reason = miss_reasons[utils_random_int(1, #miss_reasons)]
        str = string.format("%s \a{Link Active}%s\aDEFAULT's \a{Link Active}%s\aDEFAULT due to \a{Link Active}%s\aDEFAULT", action, name, ctx.misc.hitgroup_str[utils_random_int(1,8)], reason)
    else
        str = string.format("%s \a{Link Active}%s\aDEFAULT for \a{Link Active}%d\aDEFAULT damage (\a{Link Active}%d health remaining\aDEFAULT)", action, name, dmg, remaining_health)
    end

    notifications.preview:add(str)
end

notifications.main.on_hit = function(e)
    if not aimbot_logs:get("Notify") then
        return
    end

    local lp = entity_get_local_player()

    if lp ~= entity.get(e.attacker, true) then
        return
    end

    local target = entity.get(e.userid, true)
    local hitgroup = ctx.misc.hitgroup_str[e.hitgroup]
    local shit = ctx.shots.action == "Hit" and ("'s \a{Link Active}" .. hitgroup) or ("")
    local dmg = e.dmg_health

    local str = ctx.shots.action .. " \a{Link Active}" .. target:get_name() .. "\aDEFAULT" .. shit .. " \aDEFAULTfor \a{Link Active}" .. dmg .. " \aDEFAULTdamage (\a{Link Active}" .. e.health .. " health remaining\aDEFAULT)"

    notifications.normal:add(str, 2000)
end

notifications.main.on_miss = function(e)
    if not aimbot_logs:get("Notify") then
        return
    end

    local target = e.target
    local wanted_hitgroup = ctx.misc.hitgroup_str[e.wanted_hitgroup]
    local miss_r = e.state

    local str = "Missed \a{Link Active}" .. target:get_name() .. "\aDEFAULT's \a{Link Active}" .. wanted_hitgroup .. "\aDEFAULT due to \a{Link Active}" .. miss_r .. "\aDEFAULT"

    notifications.normal:add(str, 2000)
end

local console = {hit = {}}

console.hit.shot = function(e)
    if not aimbot_logs:get("Console") or e.state ~= nil then
        return
    end

    local target = e.target
    local hitgroup = e.wanted_hitgroup ~= e.hitgroup and (ctx.misc.hitgroup_str[e.hitgroup] .. "\aDEFAULT(\a{Link Active}" .. ctx.misc.hitgroup_str[e.wanted_hitgroup] .. "\aDEFAULT)") or ctx.misc.hitgroup_str[e.hitgroup]
    local dmg = e.wanted_damage ~= e.damage and (e.damage .. "\aDEFAULT(\a{Link Active}" .. e.wanted_damage .. "\aDEFAULT)") or (e.damage)
    local str = ctx.shots.action .. " \a{Link Active}" .. target:get_name() .. "\aDEFAULT's \a{Link Active}" .. hitgroup .. "\aDEFAULT for \a{Link Active}" .. dmg .. "\aDEFAULT damage (\a{Link Active}" .. target.m_iHealth .. " health remaining\aDEFAULT) [bt: \a{Link Active}" .. e.backtrack .. "\aDEFAULT \a555555FF/ \aDEFAULThc: \a{Link Active}" .. e.hitchance .. "\aDEFAULT]"

    print_raw(ctx.misc.prefix .. str)
end

print_raw(ctx.misc.prefix .. "Hello, " .. info.username)

console.hit.other = function(e)
    if not aimbot_logs:get("Console") or ctx.shots.action == "Hit" then
        return
    end

    local lp = entity_get_local_player()

    if lp ~= entity.get(e.attacker, true) then
        return
    end

    local target = entity.get(e.userid, true)
    local str = ctx.shots.action .. " \a{Link Active}" .. target:get_name() .. "\aDEFAULT for \a{Link Active}" .. e.dmg_health .. "\aDEFAULT damage (\a{Link Active}" .. e.health .. " health remaining\aDEFAULT)"

    print_raw(ctx.misc.prefix .. str)
end

console.miss = function(e)
    if not aimbot_logs:get("Console") then
        return
    end


    local target = e.target
    local wanted_hitgroup = ctx.misc.hitgroup_str[e.wanted_hitgroup]
    local wanted_dmg = e.wanted_damage

    local str = "Missed \a{Link Active}" .. target:get_name() .. "\aDEFAULT's \a{Link Active}" .. wanted_hitgroup .. "\aDEFAULT for \a{Link Active}" .. wanted_dmg .. "\aDEFAULT damage due to \a{Link Active}" .. e.state .. "\aDEFAULT [bt: \a{Link Active}" .. e.backtrack .. "\aDEFAULT \a555555FF/ \aDEFAULThc: \a{Link Active}" .. e.hitchance .. "\aDEFAULT]"

    print_raw(ctx.misc.prefix .. str)
end

local eventlog = {}

eventlog.hit = function(e)
    if not aimbot_logs:get("Events") then
        return
    end
    local lp = entity_get_local_player()

    if lp ~= entity.get(e.attacker, true) then
        return
    end

    local target = entity.get(e.userid, true)
    local hitgroup = ctx.misc.hitgroup_str[e.hitgroup]
    local shit = ctx.shots.action == "Hit" and ("'s \a{Link Active}" .. hitgroup) or ("")
    local dmg = e.dmg_health

    local str = ctx.shots.action .. " \a{Link Active}" .. target:get_name() .. "\aDEFAULT" .. shit .. " \aDEFAULTfor \a{Link Active}" .. dmg .. " \aDEFAULTdamage (\a{Link Active}" .. e.health .. " health remaining\aDEFAULT)"

    print_dev(str)
end

eventlog.miss = function(e)
    if not aimbot_logs:get("Events") then
        return
    end

    local target = e.target
    local wanted_hitgroup = ctx.misc.hitgroup_str[e.wanted_hitgroup]
    local miss_r = e.state

    local str = "Missed \a{Link Active}" .. target:get_name() .. "\aDEFAULT's \a{Link Active}" .. wanted_hitgroup .. "\aDEFAULT due to \a{Link Active}" .. miss_r .. "\aDEFAULT"

    print_dev(str)
end

notifications.main.purchase = function(e, bebroid)
    if not aimbot_logs:get("Notify") then
        return
    end

    notifications.normal:add(string.format("\a{Link Active}%s \aDEFAULTbought \a{Link Active}%s", entity.get(e.userid, true):get_name(), string.sub(e.weapon, bebroid)), 1700)
end

console.purchase = function(e, bebroid)
    if not aimbot_logs:get("Console") then
        return
    end

    print_raw(ctx.misc.prefix .. string.format("\a{Link Active}%s \aDEFAULTbought \a{Link Active}%s", entity.get(e.userid, true):get_name(), string.sub(e.weapon, bebroid)))
end

eventlog.purchase = function(e, bebroid)
    if not aimbot_logs:get("Events") then
        return
    end

    common_add_event(string.format("\a{Link Active}%s \aDEFAULTbought \a{Link Active}%s", entity.get(e.userid, true):get_name(), string.sub(e.weapon, bebroid), ui.get_icon("cart-shopping")))
end

local aa_options = menu.antiaim.main.additions

local update_warmup = function()
    ctx.misc.is_warmup = false

    if not aa_options:get(1) or not entity.get_game_rules() then
        return
    end

    if not entity.get_game_rules().m_bWarmupPeriod then
        return
    end

    ctx.misc.is_warmup = true
end

local antiaim = {}

MOVE_LIMIT = 3.63

antiaim.update_states = function(cmd)
    local lp = entity_get_local_player()
    if not lp then return end

    local flags = ctx.functions.player.get_flags(lp)
    local crouch = ctx.functions.player.get_crouch(flags)
    local jumping = ctx.functions.player.get_jumping(cmd, flags)
    local velocity = ctx.functions.player.sqrt_vel(ctx.functions.player.get_velocity(lp))

    local state, idx = "Standing", 1

    if velocity < 5 and not jumping and not ref["Fake Duck"]:get() then
        if crouch then
            state, idx = "Crouching", 4
        end
    elseif jumping and not ref["Fake Duck"]:get() then
        state, idx = crouch and "In Air & Crouching" or "In Air", crouch and 7 or 6
    elseif velocity > MOVE_LIMIT and not ref["Fake Duck"]:get() then
        if crouch and not ref["Slow Walk"]:get() then
            state, idx = "Crouching & Moving", 5
        elseif not crouch and ref["Slow Walk"]:get() then
            state, idx = "Slow Walking", 3
        else
            state, idx = "Moving", 2
        end
    end

    ctx.antiaim.defensive.state = state
    ctx.antiaim.state = (menu.antiaim.builder[idx+1].override:get() or mode_ref:get() ~= "Conditional") and state or "Default"
    ctx.antiaim.idx = (menu.antiaim.builder[idx+1].override:get() or mode_ref:get() ~= "Conditional") and idx+1 or 1
end

function antiaim.safe_weapon(cmd, flags, wpn)
    if not wpn then return false end

    local wpn_class = wpn:get_classname()

    return
           (wpn_class == "CKnife" or wpn_class == "CWeaponTaser") and
           ctx.functions.player.get_jumping(cmd, flags) and
           ctx.functions.player.get_crouch(flags)
end

local delay_swap = false

antiaim.Meta = function(cmd)
    local lp = entity.get_local_player()

    if not lp or not lp:is_alive() then return end

    local snapshot = lagrecord.get_snapshot(lp)

    if snapshot == nil then
        return
    end

    local defensive = snapshot.command.no_entry

    ctx.antiaim.current_side = (lp.m_flPoseParameter[11] or 0) * 120 - 60 + 0.5 < 0 and "Left" or "Right"

    local state = ctx.antiaim.state

    ctx.antiaim.pitch = "Down"
    ctx.antiaim.yaw.value = "Backward"
    ctx.antiaim.yaw.base = "At Target"

    local manual_state = manual_refs.manual:get()
    local manual_over_fs = manual_refs.manoverfs:get()
    ctx.antiaim.yaw.avoid_backstab = aa_options:get(2)

    if manual_state ~= "Disabled" and not ((menu.antiaim.main.additions:get(4) and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() and ctx.antiaim.yaw.hidden)) and not ctx.functions.player.get_jumping(cmd, ctx.functions.player.get_flags(lp)) and menu.antiaim.main.additions:get(4)  then
        ctx.antiaim.yaw.offset = ctx.misc.manuals[manual_state]
        ctx.antiaim.body_yaw.options = {}
        ctx.antiaim.yaw.base = "Local View"
        ref["Freestanding"]:override(ref["Freestanding"]:get() and not manual_over_fs)
        return
    end

    if antiaim.safe_weapon(cmd, lp.m_fFlags, lp:get_player_weapon(false)) and aa_options:get(3) then
        ctx.antiaim.body_yaw.value = true
        ctx.antiaim.body_yaw.left_limit = 5
        ctx.antiaim.body_yaw.right_limit = 5
        ctx.antiaim.body_yaw.options = {}
        ctx.antiaim.yaw.offset = 10
        ctx.antiaim.yaw_modifier.value = "Disabled"
        ctx.antiaim.yaw_modifier.offset = 0
        return
    end

    ctx.antiaim.body_yaw.value = true
    ctx.antiaim.body_yaw.left_limit = 60
    ctx.antiaim.body_yaw.right_limit = 60
    ctx.antiaim.body_yaw.options = {"Jitter"}
    ctx.antiaim.body_yaw.freestanding = "Off"

    ctx.fakelag.enabled = true
    ctx.fakelag.limit = 14
    ctx.fakelag.variability = utils_random_float(30, 60)

    local yaw_offset_mapping = {
        ["Standing"] = {30,-10},
        ["Moving"] = {30,-20},
        ["Slow Walking"] = {30,-30},
        ["Crouching"] = {35,-20},
        ["Crouching & Moving"] = {37,-20},
        ["In Air"] = {10,-10},
        ["In Air & Crouching"] = {35,-20}
    }

    local delay_mapping = {
        ["Standing"] = utils_random_int(1, 10),
        ["Moving"] = 5,
        ["Slow Walking"] = 0,
        ["Crouching"] = 0,
        ["Crouching & Moving"] = 4,
        ["In Air"] = 0,
        ["In Air & Crouching"] = 4
    }

    ctx.antiaim.yaw.offset = 0

    if not (ctx.antiaim.yaw.hidden and defensive.x > 0) then
        ctx.antiaim.yaw.offset = (ctx.antiaim.current_side == "Left" and yaw_offset_mapping[state][1] or yaw_offset_mapping[state][2])
        if delay_mapping[state] == 0 then
        ctx.antiaim.body_yaw.inverter = ctx.antiaim.current_side == "Left"
        else
            if globals.tickcount % delay_mapping[state] == delay_mapping[state] - 1 then
                delay_swap = not delay_swap
            end

            ctx.antiaim.body_yaw.inverter = delay_swap
            ctx.antiaim.body_yaw.options = {""}
        end
    end

    if state == "Standing" then
        ctx.antiaim.yaw_modifier.value = "3-Way"
        ctx.antiaim.yaw_modifier.offset = 12
    elseif state == "Slow Walking" or state == "Moving" then
        ctx.antiaim.yaw_modifier.value = "5-Way"
        ctx.antiaim.yaw_modifier.offset = 12
    else
        ctx.antiaim.yaw_modifier.value = "Disabled"
        ctx.antiaim.yaw_modifier.offset = 0
    end
end

antiaim.Classic = function(cmd)
    local lp = entity.get_local_player()

    if not lp or not lp:is_alive() then return end

    local snapshot = lagrecord.get_snapshot(lp)

    if snapshot == nil then
        return
    end

    local defensive = snapshot.command.no_entry

    ctx.antiaim.current_side = (lp.m_flPoseParameter[11] or 0) * 120 - 60 + 0.5 < 0 and "Left" or "Right"


    local state = ctx.antiaim.state

    ctx.antiaim.pitch = "Down"
    ctx.antiaim.yaw.value = "Backward"
    ctx.antiaim.yaw.base = "At Target"

    local manual_state = manual_refs.manual:get()
    local manual_over_fs = manual_refs.manoverfs:get()
    ctx.antiaim.yaw.avoid_backstab = aa_options:get(2)

    if manual_state ~= "Disabled" and not ((menu.antiaim.main.additions:get(4) and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() and ctx.antiaim.yaw.hidden)) and not ctx.functions.player.get_jumping(cmd, ctx.functions.player.get_flags(lp))  and menu.antiaim.main.additions:get(4)  then
        ctx.antiaim.yaw.offset = ctx.misc.manuals[manual_state]
        ctx.antiaim.body_yaw.options = {}
        ctx.antiaim.yaw.base = "Local View"
        ref["Freestanding"]:override(ref["Freestanding"]:get() and not manual_over_fs)
        return
    end

    if antiaim.safe_weapon(cmd, lp.m_fFlags, lp:get_player_weapon(false)) and aa_options:get(3) then
        ctx.antiaim.body_yaw.value = true
        ctx.antiaim.body_yaw.left_limit = 5
        ctx.antiaim.body_yaw.right_limit = 5
        ctx.antiaim.body_yaw.options = {}
        ctx.antiaim.yaw.offset = 10
        ctx.antiaim.yaw_modifier.value = "Disabled"
        ctx.antiaim.yaw_modifier.offset = 0
        return
    end

    ctx.antiaim.body_yaw.value = true
    ctx.antiaim.body_yaw.left_limit = 60
    ctx.antiaim.body_yaw.right_limit = 60
    ctx.antiaim.body_yaw.options = {"Jitter"}
    ctx.antiaim.body_yaw.freestanding = "Off"
    ctx.antiaim.body_yaw.inverter = false

    ctx.fakelag.enabled = true
    ctx.fakelag.limit = 14
    ctx.fakelag.variability = utils_random_float(30, 60)

    local yaw_offset_mapping = {
        ["Standing"] = {23,-10},
        ["Moving"] = {24,-20},
        ["Slow Walking"] = {30,-30},
        ["Crouching"] = {35,-20},
        ["Crouching & Moving"] = {27,-10},
        ["In Air"] = {10,-10},
        ["In Air & Crouching"] = {28,-15}
    }

    ctx.antiaim.yaw.offset = 0

    if not (ctx.antiaim.yaw.hidden and defensive.x > 0) then

    ctx.antiaim.yaw.offset = (ctx.antiaim.current_side == "Left" and yaw_offset_mapping[state][1] or yaw_offset_mapping[state][2])

    end

    ctx.antiaim.yaw_modifier.value = "Disabled"
    ctx.antiaim.yaw_modifier.offset = 0
end

local desync_value = 0

local PAKETA_pitches = { -89, -45, 0, 45 }
local defensive_pitch = menu.antiaim.main.def.pitch

local function translate_defensive_pitch(cmd, str)
    local offset_mapping = {
        ["Up"] = -89,
        ["Up Switch"] = -45,
        ["Zero"] = 0,
        ["Down Switch"] = 45,
        ["Down"] = 89,
        ["PAKETA"] = PAKETA_pitches[utils_random_int(1, #PAKETA_pitches)]
    }

    return offset_mapping[str] or 0
end

local defensive_3_way = { 90, 180, -90 }
local defensive_5_way = { 90, 135, 180, -135, -90 }



local function translate_defensive_yaw(cmd, str)
    local lp = entity_get_local_player()
    if not lp or not lp:is_alive() then return end

    local offset_mapping = {
        ["Spinbot"] = (globals.tickcount * (2^defensive_spin_speed:get())) % 360,
        ["Opposite"] = -180,
        ["Sideways"] = ctx.antiaim.current_side == "Left" and -65 or 65,
        ["Random"] = utils_random_float(-180, 180),
        ["3-Way"] = defensive_3_way[globals.tickcount % 3 + 1],
        ["5-Way"] = defensive_5_way[globals.tickcount % 5 + 1]
    }

    return offset_mapping[str] or 0
end

antiaim.Conditional = function(cmd)
    local lp = entity_get_local_player()

    if not lp or not lp:is_alive() then return end

    local snapshot = lagrecord.get_snapshot(lp)

    if snapshot == nil then
        return
    end

    local defensive = snapshot.command.no_entry

    local DefensiveKey = menu.antiaim.defensive_builder[ctx.antiaim.idx]

    ctx.antiaim.yaw.hidden = DefensiveKey.override:get()

    ctx.antiaim.current_side = (lp.m_flPoseParameter[11] or 0) * 120 - 60 + 0.5 < 0 and "Left" or "Right"

    local BuilderKey = menu.antiaim.builder[ctx.antiaim.idx]
    local manual_state = manual_refs.manual:get()
    local manual_over_fs = manual_refs.manoverfs:get()
    ctx.antiaim.yaw.avoid_backstab = aa_options:get(2)

    if manual_state ~= "Disabled" and not ((menu.antiaim.main.additions:get(5) and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() and ctx.antiaim.yaw.hidden)) and not ctx.functions.player.get_jumping(cmd, ctx.functions.player.get_flags(lp)) and menu.antiaim.main.additions:get(4)  then
        ctx.antiaim.yaw.offset = ctx.misc.manuals[manual_state]
        ctx.antiaim.body_yaw.options = {}
        ctx.antiaim.yaw.base = "Local View"
        ref["Freestanding"]:override(ref["Freestanding"]:get() and not manual_over_fs)
        return
    end

    ctx.antiaim.body_yaw.options = (defensive_yaw:get() == "Sideways" and ctx.antiaim.yaw.hidden and (not menu.antiaim.main.additions:get(4) and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get()) and {"Jitter"} or {"Jitter"})

    local yaw_modification = BuilderKey.yaw_mod:get() == "Center" and ctx.antiaim.yaw_modifier.offset/2 or 0

    ctx.antiaim.pitch = BuilderKey.pitch:get()
    ctx.antiaim.yaw.value = BuilderKey.yaw:get()
    ctx.antiaim.yaw.base = BuilderKey.yaw.base:get()

    if antiaim.safe_weapon(cmd, lp.m_fFlags, lp:get_player_weapon(false)) and aa_options:get(3) then
        ctx.antiaim.body_yaw.value = true
        ctx.antiaim.body_yaw.left_limit = 5
        ctx.antiaim.body_yaw.right_limit = 5
        ctx.antiaim.body_yaw.options = {}
        ctx.antiaim.yaw.offset = 10
        ctx.antiaim.yaw_modifier.value = "Disabled"
        ctx.antiaim.yaw_modifier.offset = 0
        return
    end

    ctx.antiaim.yaw.offset = (ctx.antiaim.current_side == "Left" and BuilderKey.yaw.offset_left:get() or BuilderKey.yaw.offset_right:get()) + yaw_modification
    ctx.antiaim.yaw_modifier.value = (BuilderKey.yaw_mod:get() == "Center" or BuilderKey.yaw_mod:get() == "Offset") and "Disabled" or BuilderKey.yaw_mod:get()
    ctx.antiaim.yaw_modifier.offset = (BuilderKey.yaw_mod.offset:get() + utils_random_float(-BuilderKey.yaw_mod.randomization:get(), BuilderKey.yaw_mod.randomization:get()))
    ctx.antiaim.body_yaw.value = BuilderKey.body_yaw:get()

    local desync_limit = BuilderKey.body_yaw.desync_limit:get()
    local desync_randomization = BuilderKey.body_yaw.desync_randomization:get()

    if desync_limit > 0 then
        local range = utils.random_float(0, desync_randomization)

        if desync_limit + desync_randomization > 60 then
            desync_value = desync_limit - range
        else
            desync_value = desync_limit + utils.random_float(-desync_randomization, desync_randomization)
        end

        if desync_value == 0 then
            desync_value = 60
        end
    end

    ctx.antiaim.body_yaw.left_limit = desync_value
    ctx.antiaim.body_yaw.right_limit = desync_value
    ctx.antiaim.body_yaw.options = (defensive_yaw:get() == "Sideways" and ctx.antiaim.yaw.hidden and (not menu.antiaim.main.additions:get(4) and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get()) and {"Jitter"} or BuilderKey.body_yaw.options:get())
    ctx.antiaim.body_yaw.freestanding = BuilderKey.body_yaw.freestanding:get()

    if BuilderKey.body_yaw.options:get("Jitter") and not (ctx.antiaim.yaw.hidden and defensive.x > 0) then
        if BuilderKey.body_yaw.delay:get() == 0 then
            ctx.antiaim.body_yaw.inverter = ctx.antiaim.current_side == "Left"
        else

            if globals.tickcount % BuilderKey.body_yaw.delay:get() == BuilderKey.body_yaw.delay:get() -1 then
                delay_swap = not delay_swap
            end

            ctx.antiaim.body_yaw.inverter = delay_swap
            ctx.antiaim.body_yaw.options = {""}
        end
    end

    ctx.fakelag.enabled = true
    ctx.fakelag.limit = 14
    ctx.fakelag.variability = utils_random_float(30, 60)

    if DefensiveKey.pitch:get() == "Custom" then
        ctx.antiaim.defensive.pitch = DefensiveKey.pitch.custom:get()
    else
        ctx.antiaim.defensive.pitch = translate_defensive_pitch(cmd, DefensiveKey.pitch:get())
    end

    if DefensiveKey.yaw:get() == "Custom Jitter" then
        ctx.antiaim.defensive.yaw = ctx.antiaim.current_side == "Left" and DefensiveKey.yaw.custom1:get() or DefensiveKey.yaw.custom2:get()
    elseif DefensiveKey.yaw:get() == "Spinbot" then
        ctx.antiaim.defensive.yaw = (globals.tickcount * (2^DefensiveKey.yaw.speed:get())) % 360
    else
        ctx.antiaim.defensive.yaw = translate_defensive_yaw(cmd, DefensiveKey.yaw:get())
    end
end

antiaim.warmup = function(cmd)
    if not entity_get_local_player() then
        return
    end

    ctx.antiaim.pitch = "Disabled"
    ctx.antiaim.yaw.value = "Static"
    ctx.antiaim.yaw.offset = (globals.tickcount*(2^5)) % 360
    ctx.antiaim.yaw_modifier.value = "Disabled"
    ctx.antiaim.body_yaw.value = false
    ctx.fakelag.enabled = false
end

function antiaim.anti_backstab()
    local lp = entity_get_local_player()
    if not lp then return false end

    local threat = entity.get_threat()
    if not threat then return false end

    local wpn = threat:get_player_weapon(false)
    if not wpn then return false end

    return wpn:get_classname() == "CKnife" and lp:get_origin():dist(threat:get_origin()) <= 275 and aa_options:get(2)
end

function antiaim.safe_manual(cmd)
    local lp = entity_get_local_player()
    local manual = manual_refs.manual:get()
    return (manual ~= "Disabled" and manual ~= "Forward") and not ctx.functions.player.get_jumping(cmd, ctx.functions.player.get_flags(lp))
end

function antiaim.defensive_safe_head(cmd)
    local lp = entity.get_local_player()

    local threat = entity.get_threat()
    if not threat or threat:is_dormant() or not menu.antiaim.main.additions:get(6) then return false end

    local safe_dist = lp:get_origin():dist(threat:get_origin()) > 1450 and menu.antiaim.main.additions:get(7)
    local safe_fs = (rage.antiaim:get_target(true) and ref["Freestanding"]:get()) and menu.antiaim.main.additions:get(6)
    local df_state = ctx.antiaim.defensive.state
    local safe_state = (df_state == "Crouch" or df_state == "Crouch-W") and (lp:get_origin().z - threat:get_origin().z > 50) and menu.antiaim.main.additions:get(7)
    local wpn = lp:get_player_weapon(false)

    return (antiaim.safe_weapon(cmd, lp.m_fFlags, wpn) and menu.antiaim.main.additions:get(7)) or safe_dist or safe_fs or safe_state
end

local antiaim_anti_backstab = antiaim.anti_backstab

local lcstate = menu.antiaim.main.breaklcon
local def_states = menu.antiaim.main.def.states
local def = menu.antiaim.main.def

antiaim.defensive = function(cmd)
    if (not menu.antiaim.main.def:get() and menu.antiaim.main.mode:get() ~= "Conditional") or antiaim_anti_backstab() or ctx.misc.is_warmup or rage.exploit:get() ~= 1 then
        ctx.antiaim.defensive.pitch = 0
        ctx.antiaim.defensive.yaw = 0
        ctx.antiaim.yaw.hidden = false
        ref["Hide Shots"]["Options"]:override("Favor Fire Rate")
        return
    end

    local manual = manual_refs.manual
    local state = ctx.antiaim.defensive.state
    local flick_sideways = antiaim.defensive_safe_head(cmd)
    local get_lc = flick_sideways and true or lcstate:get(state) and def_states:get(state)

    if (get_lc and manual ~= "Forward") then
        ctx.antiaim.yaw.hidden = true
    else
        ctx.antiaim.yaw.hidden = false
    end

    if not get_lc or manual == "Forward" then
        ctx.antiaim.defensive.pitch = 0
        ctx.antiaim.defensive.yaw = 0
        ctx.antiaim.yaw.hidden = false
        ref["Hide Shots"]["Options"]:override("Favor Fire Rate")
        return
    end

    if menu.antiaim.main.def.mode:get() == "Default" then
        ctx.antiaim.defensive.pitch = translate_defensive_pitch(cmd, defensive_pitch:get())
        ctx.antiaim.defensive.yaw = (translate_defensive_yaw(cmd, menu.antiaim.main.def.yaw:get()) + utils_random_float(-30, 30))
    else
        ctx.antiaim.defensive.pitch = 89
        ctx.antiaim.defensive.yaw = ctx.antiaim.yaw.offset + ctx.antiaim.yaw_modifier.offset
    end
end

local final_defensive_pitch = 0
local final_defensive_yaw = 0



antiaim.override = function(cmd)
    if mode_ref:get() == "Disabled" and not ctx.misc.is_warmup then
        for _,v in pairs(ref) do
            v:override()
        end
        return
    end
    local lp = entity_get_local_player()

    if not lp or not lp:is_alive() then
        return
    end

    ctx.antiaim.enabled = true

    ref["Enabled"]:override(ctx.antiaim.enabled)

    ref["Pitch"]:override(ctx.antiaim.pitch)

    ref["Yaw"]:override(ctx.antiaim.yaw.value)
    ref["Yaw"]["Base"]:override(ctx.antiaim.yaw.base)
    ref["Yaw"]["Offset"]:override(ctx.antiaim.yaw.offset)
    ref["Yaw"]["Avoid Backstab"]:override(ctx.antiaim.yaw.avoid_backstab)
    ref["Yaw"]["Hidden"]:override(x and ctx.antiaim.yaw.hidden)

    ref["Yaw Modifier"]:override(ctx.antiaim.yaw_modifier.value)
    ref["Yaw Modifier"]["Offset"]:override(ctx.antiaim.yaw_modifier.offset)

    ref["Body Yaw"]:override(ctx.antiaim.body_yaw.value)
    ref["Body Yaw"]["Inverter"]:override(ctx.antiaim.body_yaw.inverter)
    ref["Body Yaw"]["Left Limit"]:override(ctx.antiaim.body_yaw.left_limit)
    ref["Body Yaw"]["Right Limit"]:override(ctx.antiaim.body_yaw.right_limit)
    ref["Body Yaw"]["Options"]:override(ctx.antiaim.body_yaw.options)
    ref["Body Yaw"]["Freestanding"]:override(ctx.antiaim.body_yaw.freestanding)

    ref["Fake Lag"]:override(ctx.fakelag.enabled)
    ref["Limit"]:override(ctx.fakelag.limit)
    ref["Variability"]:override(ctx.fakelag.variability)

    if (antiaim.defensive_safe_head(cmd)) then
        final_defensive_pitch = 0
        final_defensive_yaw = 180
    elseif antiaim.safe_manual(cmd) and menu.antiaim.main.additions:get(6) then
        final_defensive_pitch = 0
        final_defensive_yaw = 180
    elseif menu.antiaim.main.flick_bind:get() and menu.antiaim.main.additions:get(5) then
        final_defensive_pitch = 89
        final_defensive_yaw = 90
    else
        final_defensive_pitch = ctx.antiaim.defensive.pitch
        final_defensive_yaw = ctx.antiaim.defensive.yaw
    end

    rage.antiaim:override_hidden_pitch(final_defensive_pitch or 0)
    rage.antiaim:override_hidden_yaw_offset(final_defensive_yaw or 90)

    local state = ctx.antiaim.defensive.state

    ref["Hide Shots"]["Options"]:override(lcstate:get(state) and not ctx.misc.is_warmup and "Break LC" or "Favor Fire Rate")
    ref["Double Tap"]["Options"]:override(lcstate:get(state) and not ctx.misc.is_warmup and "Always On" or "Disabled")

end

local vector_tables = { ["Forward"] = {}, ["Left"] = {}, ["Right"] = {}, ["Disabled"] = {} }

vector_tables = {
    ["Forward"] = {
        var1 = vector(ctx.render.screen_center.x + 6, ctx.render.screen_center.y - 73),
        var2 = vector(ctx.render.screen_center.x, ctx.render.screen_center.y - 78),
        var3 = vector(ctx.render.screen_center.x - 6, ctx.render.screen_center.y - 73)
    },
    ["Left"] = {
        var1 = vector(ctx.render.screen_center.x - 75, ctx.render.screen_center.y + 5),
        var2 = vector(ctx.render.screen_center.x - 80, ctx.render.screen_center.y),
        var3 = vector(ctx.render.screen_center.x - 75, ctx.render.screen_center.y - 5)
    },
    ["Right"] = {
        var1 = vector(ctx.render.screen_center.x + 75, ctx.render.screen_center.y + 5),
        var2 = vector(ctx.render.screen_center.x + 80, ctx.render.screen_center.y),
        var3 = vector(ctx.render.screen_center.x + 75, ctx.render.screen_center.y - 5)
    },
    ["Disabled"] = {
        var1 = vector(ctx.render.screen_center.x, ctx.render.screen_center.y),
        var2 = vector(ctx.render.screen_center.x, ctx.render.screen_center.y),
        var3 = vector(ctx.render.screen_center.x, ctx.render.screen_center.y)
    }
}

local indicators = {manual_aa = true, custom_scope = true}
local current_vectors = {var1 = ctx.render.screen_center, var2 = ctx.render.screen_center, var3 = ctx.render.screen_center}

indicators.manual_aa = function()
    local lp = entity_get_local_player()
    if not lp or not lp:is_alive() or not manual_refs.ind:get() or not menu.antiaim.main.additions:get(4) then
        return
    end

    local manual_state = manual_refs.manual:get()
    local manual_color = manual_refs.clr:get()

    current_vectors.var1 = current_vectors.var1:lerp(vector_tables[manual_state].var1, globals.frametime * 15)
    current_vectors.var2 = current_vectors.var2:lerp(vector_tables[manual_state].var2, globals.frametime * 15)
    current_vectors.var3 = current_vectors.var3:lerp(vector_tables[manual_state].var3, globals.frametime * 15)

    render.poly_line(
        color(manual_color.r, manual_color.g, manual_color.b, 255),
        current_vectors.var1,
        current_vectors.var2,
        current_vectors.var3
    )
end

local misc = {animations = {}, local_transparency = true}

misc.animations = {air_legs = true, ground_legs = true, lean = true}
local anim_refs = {animbreak = true, airlegs = true, groundlegs = true, lean_force = true}

anim_refs.animbreak = menu.antiaim.main.animbreak
anim_refs.airlegs = menu.antiaim.main.animbreak.air
anim_refs.groundlegs = menu.antiaim.main.animbreak.ground
anim_refs.lean_force = menu.antiaim.main.animbreak.move_lean_force

misc.animations.air_legs = function(player)
    if anim_refs.airlegs:get() == "Default" then return end

    local airlegs = anim_refs.airlegs:get()

    local animlayer = ffi_cast("AnimationLayer**", ffi_cast("char*", ffi_cast("void***", player[0])) + 0x2990)[0] -- ffi_cast("AnimationLayer**", ffi_cast("char*", ffi_cast("void***", player[0])) + 0x2990)[0]
    local in_air = (bit_band(player.m_fFlags or 0, bit_lshift(1, 0)) == 0)

    if airlegs == "Directional" and in_air then
        animlayer[6].weight = 1
    else
        player.m_flPoseParameter[6] = 1
    end
end

misc.animations.ground_legs = function(player)
    if anim_refs.groundlegs:get() == "Default" then return end

    local groundlegs = anim_refs.groundlegs:get()

    if groundlegs == "Static" then
        ref["Leg Movement"]:override("Sliding")
        player.m_flPoseParameter[0] = 1
    elseif groundlegs == "Directional" then
        ref["Leg Movement"]:override("Walking")
        player.m_flPoseParameter[7] = 0
    else
        ref["Leg Movement"]:override("Sliding")
        player.m_flPoseParameter[0] = globals.tickcount % 4 and math.random(utils.random_float(0.1, 0.9), 1.0) or utils.random_float(0.0, 1.0)
    end
end

misc.animations.lean = function(player)
    if anim_refs.lean_force:get() == 0 or ctx.antiaim.defensive.state == "Standing" then return end

    local amount = anim_refs.lean_force:get() / 100
    local animlayer = ffi_cast("AnimationLayer**", ffi_cast("char*", ffi_cast("void***", player[0])) + 0x2990)[0]

    animlayer[12].weight = amount
end

manager.events:wrap("post_update_clientside_animation", "Local Animations", function(player)
    if not anim_refs.animbreak:get() then return end

    local lp = entity_get_local_player()

    if player ~= lp or not lp or type(player) ~= "userdata" or not player:is_player() then return end

    misc.animations.air_legs(player)
    misc.animations.ground_legs(player)
    misc.animations.lean(player)
end)

local bebroid, purchase_ref = 1, menu.misc.aim.purchases

manager.events:wrap("item_purchase", "Item Purchases", function(e)
    if e.weapon == "weapon_unknown" or not purchase_ref:get() or not entity.get(e.userid, true):is_enemy() then return end

    if string.find(e.weapon, "weapon_") == 1 then
        bebroid = 8
    elseif string.find(e.weapon, "item_") == 1 then
        bebroid = 6
    else
        bebroid = 1
    end

    notifications.main.purchase(e, bebroid)
    console.purchase(e, bebroid)
    eventlog.purchase(e, bebroid)
end)

manager.events:wrap("aim_ack", "Aimbot Shots", function(e)
    console.hit.shot(e)
    if e.state == nil then return end
    console.miss(e)
    eventlog.miss(e)
    notifications.main.on_miss(e)
end)

manager.events:wrap("player_hurt", "Hits", function(e)
    console.hit.other(e)
    eventlog.hit(e)
    notifications.main.on_hit(e)
end)

manager.events:wrap("createmove", "Update States", antiaim.update_states)
manager.events:wrap("createmove", "Defensive Manager", antiaim.defensive)

manager.events:wrap("createmove", "Anti-Aim", function(cmd)
    if mode_ref:get() == "Disabled" then return end

    antiaim[mode_ref:get()](cmd)
end)

manager.events:wrap("createmove", "Warmup AA", function(cmd)
    if not ctx.misc.is_warmup or not menu.antiaim.main.additions:get(1) then return end

    antiaim.warmup(cmd)
end)

manager.events:wrap("createmove", "Update Warmup", update_warmup)
manager.events:wrap("createmove", "Override AA", antiaim.override)

manager.events:wrap("render", "Manual AA", indicators.manual_aa)
manager.events:wrap("render", "Notifications Render", function ()
    notifications.normal:render()
end)
manager.events:wrap("render", "Notifications Preview", function ()
    notifications.preview:render()
end)

local config = pui.setup(menu, true)

local export_button, default_button, import_button = menu.info.export, menu.info.default, menu.info.import

export_button:set_callback(function()
    local data = base64.encode(json_stringify(config:save()))

    clipboard.set(data)
end)

local DefaultPreset = [[eyJhbnRpYWltIjp7ImJ1aWxkZXIiOlt7ImJvZHlfeWF3Ijp0cnVlLCJvdmVycmlkZSI6dHJ1ZSwicGl0Y2giOiJEb3duIiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfbW9kIjoiRGlzYWJsZWQiLCJ+Ym9keV95YXciOnsiZGVsYXkiOjQuMCwiZGVzeW5jX2xpbWl0Ijo2MC4wLCJkZXN5bmNfcmFuZG9taXphdGlvbiI6MC4wLCJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0Iiwib2Zmc2V0X2xlZnQiOjMwLjAsIm9mZnNldF9yaWdodCI6LTMwLjB9LCJ+eWF3X21vZCI6eyJvZmZzZXQiOjAuMCwicmFuZG9taXphdGlvbiI6MC4wfX0seyJib2R5X3lhdyI6ZmFsc2UsIm92ZXJyaWRlIjpmYWxzZSwicGl0Y2giOiJEaXNhYmxlZCIsInlhdyI6IkRpc2FibGVkIiwieWF3X21vZCI6IkRpc2FibGVkIiwifmJvZHlfeWF3Ijp7ImRlbGF5IjowLjAsImRlc3luY19saW1pdCI6MC4wLCJkZXN5bmNfcmFuZG9taXphdGlvbiI6MC4wLCJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsIm9wdGlvbnMiOlsifiJdfSwifnlhdyI6eyJiYXNlIjoiTG9jYWwgVmlldyIsIm9mZnNldF9sZWZ0IjowLjAsIm9mZnNldF9yaWdodCI6MC4wfSwifnlhd19tb2QiOnsib2Zmc2V0IjowLjAsInJhbmRvbWl6YXRpb24iOjAuMH19LHsiYm9keV95YXciOnRydWUsIm92ZXJyaWRlIjpmYWxzZSwicGl0Y2giOiJEb3duIiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfbW9kIjoiRGlzYWJsZWQiLCJ+Ym9keV95YXciOnsiZGVsYXkiOjE1LjAsImRlc3luY19saW1pdCI6NDcuMCwiZGVzeW5jX3JhbmRvbWl6YXRpb24iOjYwLjAsImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjp0cnVlLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXX0sIn55YXciOnsiYmFzZSI6IkF0IFRhcmdldCIsIm9mZnNldF9sZWZ0IjotMTMuMCwib2Zmc2V0X3JpZ2h0IjoxMy4wfSwifnlhd19tb2QiOnsib2Zmc2V0IjoxOS4wLCJyYW5kb21pemF0aW9uIjoyNC4wfX0seyJib2R5X3lhdyI6ZmFsc2UsIm92ZXJyaWRlIjpmYWxzZSwicGl0Y2giOiJEaXNhYmxlZCIsInlhdyI6IkRpc2FibGVkIiwieWF3X21vZCI6IkRpc2FibGVkIiwifmJvZHlfeWF3Ijp7ImRlbGF5IjowLjAsImRlc3luY19saW1pdCI6MC4wLCJkZXN5bmNfcmFuZG9taXphdGlvbiI6MC4wLCJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsIm9wdGlvbnMiOlsifiJdfSwifnlhdyI6eyJiYXNlIjoiTG9jYWwgVmlldyIsIm9mZnNldF9sZWZ0IjowLjAsIm9mZnNldF9yaWdodCI6MC4wfSwifnlhd19tb2QiOnsib2Zmc2V0IjowLjAsInJhbmRvbWl6YXRpb24iOjAuMH19LHsiYm9keV95YXciOmZhbHNlLCJvdmVycmlkZSI6ZmFsc2UsInBpdGNoIjoiRGlzYWJsZWQiLCJ5YXciOiJEaXNhYmxlZCIsInlhd19tb2QiOiJEaXNhYmxlZCIsIn5ib2R5X3lhdyI6eyJkZWxheSI6MC4wLCJkZXN5bmNfbGltaXQiOjAuMCwiZGVzeW5jX3JhbmRvbWl6YXRpb24iOjAuMCwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJvcHRpb25zIjpbIn4iXX0sIn55YXciOnsiYmFzZSI6IkxvY2FsIFZpZXciLCJvZmZzZXRfbGVmdCI6MC4wLCJvZmZzZXRfcmlnaHQiOjAuMH0sIn55YXdfbW9kIjp7Im9mZnNldCI6MC4wLCJyYW5kb21pemF0aW9uIjowLjB9fSx7ImJvZHlfeWF3IjpmYWxzZSwib3ZlcnJpZGUiOmZhbHNlLCJwaXRjaCI6IkRpc2FibGVkIiwieWF3IjoiRGlzYWJsZWQiLCJ5YXdfbW9kIjoiRGlzYWJsZWQiLCJ+Ym9keV95YXciOnsiZGVsYXkiOjAuMCwiZGVzeW5jX2xpbWl0IjowLjAsImRlc3luY19yYW5kb21pemF0aW9uIjowLjAsImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwib3B0aW9ucyI6WyJ+Il19LCJ+eWF3Ijp7ImJhc2UiOiJMb2NhbCBWaWV3Iiwib2Zmc2V0X2xlZnQiOjAuMCwib2Zmc2V0X3JpZ2h0IjowLjB9LCJ+eWF3X21vZCI6eyJvZmZzZXQiOjAuMCwicmFuZG9taXphdGlvbiI6MC4wfX0seyJib2R5X3lhdyI6ZmFsc2UsIm92ZXJyaWRlIjpmYWxzZSwicGl0Y2giOiJEaXNhYmxlZCIsInlhdyI6IkRpc2FibGVkIiwieWF3X21vZCI6IkRpc2FibGVkIiwifmJvZHlfeWF3Ijp7ImRlbGF5IjowLjAsImRlc3luY19saW1pdCI6MC4wLCJkZXN5bmNfcmFuZG9taXphdGlvbiI6MC4wLCJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsIm9wdGlvbnMiOlsifiJdfSwifnlhdyI6eyJiYXNlIjoiTG9jYWwgVmlldyIsIm9mZnNldF9sZWZ0IjowLjAsIm9mZnNldF9yaWdodCI6MC4wfSwifnlhd19tb2QiOnsib2Zmc2V0IjowLjAsInJhbmRvbWl6YXRpb24iOjAuMH19LHsiYm9keV95YXciOmZhbHNlLCJvdmVycmlkZSI6ZmFsc2UsInBpdGNoIjoiRGlzYWJsZWQiLCJ5YXciOiJEaXNhYmxlZCIsInlhd19tb2QiOiJEaXNhYmxlZCIsIn5ib2R5X3lhdyI6eyJkZWxheSI6MC4wLCJkZXN5bmNfbGltaXQiOjAuMCwiZGVzeW5jX3JhbmRvbWl6YXRpb24iOjAuMCwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJvcHRpb25zIjpbIn4iXX0sIn55YXciOnsiYmFzZSI6IkxvY2FsIFZpZXciLCJvZmZzZXRfbGVmdCI6MC4wLCJvZmZzZXRfcmlnaHQiOjAuMH0sIn55YXdfbW9kIjp7Im9mZnNldCI6MC4wLCJyYW5kb21pemF0aW9uIjowLjB9fV0sImRlZmVuc2l2ZV9idWlsZGVyIjpbeyJvdmVycmlkZSI6ZmFsc2UsInBpdGNoIjoiWmVybyIsInlhdyI6IkN1c3RvbSBKaXR0ZXIiLCJ+cGl0Y2giOnsiY3VzdG9tIjotODkuMH0sIn55YXciOnsiY3VzdG9tMSI6LTguMCwiY3VzdG9tMiI6NjcuMCwic3BlZWQiOjUuMH19LHsib3ZlcnJpZGUiOmZhbHNlLCJwaXRjaCI6IlVwIiwieWF3IjoiU3BpbmJvdCIsIn5waXRjaCI6eyJjdXN0b20iOi04OS4wfSwifnlhdyI6eyJjdXN0b20xIjowLjAsImN1c3RvbTIiOjAuMCwic3BlZWQiOjEuMH19LHsib3ZlcnJpZGUiOmZhbHNlLCJwaXRjaCI6IlVwIiwieWF3IjoiU3BpbmJvdCIsIn5waXRjaCI6eyJjdXN0b20iOi04OS4wfSwifnlhdyI6eyJjdXN0b20xIjowLjAsImN1c3RvbTIiOjAuMCwic3BlZWQiOjEuMH19LHsib3ZlcnJpZGUiOmZhbHNlLCJwaXRjaCI6IlVwIiwieWF3IjoiU3BpbmJvdCIsIn5waXRjaCI6eyJjdXN0b20iOi04OS4wfSwifnlhdyI6eyJjdXN0b20xIjowLjAsImN1c3RvbTIiOjAuMCwic3BlZWQiOjEuMH19LHsib3ZlcnJpZGUiOmZhbHNlLCJwaXRjaCI6IlVwIiwieWF3IjoiU3BpbmJvdCIsIn5waXRjaCI6eyJjdXN0b20iOi04OS4wfSwifnlhdyI6eyJjdXN0b20xIjowLjAsImN1c3RvbTIiOjAuMCwic3BlZWQiOjEuMH19LHsib3ZlcnJpZGUiOmZhbHNlLCJwaXRjaCI6IlVwIiwieWF3IjoiU3BpbmJvdCIsIn5waXRjaCI6eyJjdXN0b20iOi04OS4wfSwifnlhdyI6eyJjdXN0b20xIjowLjAsImN1c3RvbTIiOjAuMCwic3BlZWQiOjEuMH19LHsib3ZlcnJpZGUiOmZhbHNlLCJwaXRjaCI6IlVwIiwieWF3IjoiU3BpbmJvdCIsIn5waXRjaCI6eyJjdXN0b20iOi04OS4wfSwifnlhdyI6eyJjdXN0b20xIjowLjAsImN1c3RvbTIiOjAuMCwic3BlZWQiOjEuMH19LHsib3ZlcnJpZGUiOmZhbHNlLCJwaXRjaCI6IlVwIiwieWF3IjoiU3BpbmJvdCIsIn5waXRjaCI6eyJjdXN0b20iOi04OS4wfSwifnlhdyI6eyJjdXN0b20xIjowLjAsImN1c3RvbTIiOjAuMCwic3BlZWQiOjEuMH19XSwibWFpbiI6eyJhZGRpdGlvbnMiOlsxLjAsMi4wLDMuMCw0LjAsNS4wLDYuMCw3LjAsIn4iXSwiYW5pbWJyZWFrIjpmYWxzZSwiYnJlYWtsY29uIjpbIlN0YW5kaW5nIiwiTW92aW5nIiwiU2xvdyBXYWxraW5nIiwiQ3JvdWNoaW5nIiwiQ3JvdWNoaW5nICYgTW92aW5nIiwiSW4gQWlyIiwiSW4gQWlyICYgQ3JvdWNoaW5nIiwifiJdLCJkZWYiOnRydWUsImZsaWNrX2JpbmQiOmZhbHNlLCJtYW51YWwiOiJEaXNhYmxlZCIsIm1vZGUiOiJNZXRhIiwib3B0aW9ucyI6WyJBbnRpIEJhY2tzdGFiIiwiU2FmZSBIZWFkIiwifiJdLCJzdGF0ZSI6IkRlZmF1bHQiLCJ+YW5pbWJyZWFrIjp7ImFpciI6IkRlZmF1bHQiLCJncm91bmQiOiJKaXR0ZXIiLCJtb3ZlX2xlYW5fZm9yY2UiOjAuMH0sIn5kZWYiOnsiZXh0cmEiOlsiU2FmZSIsIn4iXSwicGl0Y2giOiJVcCBTd2l0Y2giLCJzcGluX3NwZWVkIjoxLjAsInN0YXRlcyI6WyJNb3ZpbmciLCJJbiBBaXIiLCJJbiBBaXIgJiBDcm91Y2hpbmciLCJ+Il0sInlhdyI6IjMtV2F5In0sIn5tYW51YWwiOnsiKmluZCI6IiNGRkZGRkZGRiIsImluZCI6ZmFsc2UsIm1hbm92ZXJmcyI6ZmFsc2V9fSwidGFiX3NlbGVjdG9yIjoxLjB9LCJtaXNjIjp7ImFpbSI6WyJDb25zb2xlIiwiRXZlbnRzIiwiTm90aWZ5IiwifiJdLCJzY29wZV9vdmVybGF5Ijp0cnVlLCJ+YWltIjp7InB1cmNoYXNlcyI6dHJ1ZX0sIn5zY29wZV9vdmVybGF5Ijp7ImNsciI6IiM3QkM0RkRGRiIsImdhcCI6MjAuMCwibGluZSI6NTUuMCwib3B0IjpbIkludmVydGVkIiwiUm90YXRlZCIsIkFuaW1hdGVkIiwifiJdfX19]]

default_button:set_callback(function()
    local data = json_parse(base64.decode(DefaultPreset))

    config:load(data)
end)

import_button:set_callback(function()
    local data = json_parse(base64.decode(clipboard.get()))

    config:load(data)
end)

local function create_gradient(s, c1, c2, clock)
    local buffer = {}
    local len, div, c3 = #s, 1/ (#s - 1), color(c2.r - c1.r, c2.g - c1.g, c2.b - c1.b, c2.a - c1.a)

    for i = 1, len do
        local t = (clock % 2 > 1) and (2 - clock % 2) or (clock % 2)
        buffer[i] = string.format("\a%s%s", color(c1.r + c3.r * t, c1.g + c3.g * t, c1.b + c3.b * t, c1.a + c3.a * t):to_hex(), s:sub(i, i))
        clock = clock + div
    end

    return table.concat(buffer)
end

manager.events:wrap("render", "Watermark", function()
    local watermark_text = create_gradient("BebraSense", color(), pui.accent, globals.realtime)
    ui_sidebar(watermark_text, ctx.misc.icon_side)
    render_text(1, vector(ctx.render.screen_center.x, ctx.render.screen_size.y*(1/1.01)), color(), "c", watermark_text .. "\afa5757FF [ALPHA]")
end)

local alpha = 0
local length = 0
local scope_ref = pui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")

local scope_refs = {scope_overlay = true, gap_ref = true, clr_ref = true, opt_ref = true, line_ref = true}
scope_refs.scope_overlay = menu.misc.scope_overlay
scope_refs.gap = menu.misc.scope_overlay.gap
scope_refs.clr = menu.misc.scope_overlay.clr
scope_refs.opt = menu.misc.scope_overlay.opt
scope_refs.line = menu.misc.scope_overlay.line

local rotation = 0

function indicators.custom_scope()
    if not scope_refs.scope_overlay:get() then
        scope_ref:override()
		return
    end

    render.push_rotation(scope_refs.opt:get("Rotated") and rotation or 0)

    scope_ref:override("Remove All")

	local lp = entity_get_local_player()

	if not lp or not lp:is_alive() or not scope_refs.opt:get("Animated") and not lp.m_bIsScoped then
        scope_ref:override()
		return
    end

    rotation = manager.render.lerp(rotation, scope_refs.opt:get("Rotated") and 45 or 0, globals.frametime * 25)

	local screen_center = ctx.render.screen_center
	local gap = scope_refs.gap:get() + 5
	local clr = scope_refs.clr:get()
	local is_visible = scope_refs.opt:get("Animated") and lp.m_bIsScoped or false


	alpha = scope_refs.opt:get("Animated") and manager.render.lerp(alpha, is_visible and clr.a or 0, globals.frametime * 25) or clr.a
	length = scope_refs.opt:get("Animated") and manager.render.lerp(length, is_visible and scope_refs.line:get() or 0, globals.frametime * 25) or scope_refs.line:get()

	local clr1 = color(clr.r, clr.g, clr.b, scope_refs.opt:get("Inverted") and 0 or alpha)
	local clr2 = color(clr.r, clr.g, clr.b, scope_refs.opt:get("Inverted") and alpha or 0)

    render.gradient(vector(screen_center.x - gap, screen_center.y + 1), vector(screen_center.x - gap - length - 25, screen_center.y), clr1, clr2, clr1, clr2)
    render.gradient(vector(screen_center.x + gap, screen_center.y + 1), vector(screen_center.x + gap + length + 25, screen_center.y), clr1, clr2, clr1, clr2)
    render.gradient(vector(screen_center.x, screen_center.y - gap), vector(screen_center.x + 1, screen_center.y - gap - length - 25), clr1, clr1, clr2, clr2)
    render.gradient(vector(screen_center.x, screen_center.y + gap), vector(screen_center.x + 1, screen_center.y + gap + length + 25), clr1, clr1, clr2, clr2)

    render.pop_rotation()
end

manager.events:wrap("render", "Custom Scope Overlay", indicators.custom_scope)