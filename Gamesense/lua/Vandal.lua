local vandal = {
    variables = {
        states = {
            "default", 
            "standing", 
            "moving",
            "in air",
            "slowwalking",
            "crouching",
            "crouch moving",
            "crouch in air"
        },

        minified_states = {
            "STA", 
            "MOV",
            "AIR",
            "SW",
            "DU",
            "DUM",
            "AD"
        },

        references = {
            enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),

            pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")},

            yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),

            yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},

            yaw_jitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},

            body_yaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},

            freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),

            edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),

            freestanding = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},

            roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),

            keybinds = {
                items = {
                    double_tap = {ui.reference("RAGE", "Aimbot", "Double tap")},
                    hide_shots = {ui.reference("AA", "Other", "On shot anti-aim")},
    
                    slowwalk = {ui.reference("AA", "Other", "Slow Motion")},

                    force_body = ui.reference("RAGE", "Aimbot", "Force body aim"),
                    quick_peek = {ui.reference("RAGE", "Other", "Quick peek assist")},
                    minumum_damage_override = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
                    force_safe_point = ui.reference("RAGE", "Aimbot", "Force safe point")
                }
            },

            other = {
                items = {
                    leg_movement = ui.reference("AA", "Other", "Leg movement")
                }
            }
        },

        visuals = {
            generation = {
                angle = 0,
                damage = 0,
                backtrack = 0,
                best_position = nil,
                dangerous = false,
                avoiding = false 
            },

            user = obex_fetch and obex_fetch() or {
                username = "Svvayyz",
                build = "Source",
                discord = ""
            },

            crosshair = {
                text_alpha = 255,
                text_alpha_2 = 155,  
                step = 1 
            },

            watermark = {},

            notifications = {}
        },

        anti_aim = {
            var = {
                side = -1
            },

            anti_bruteforce = {
                activated = 0,
                angle = 0,
                phase = 1
            },

            defensive = {
                ticks_left = 0,
                last_simtime = 0,

                max_ticks = 12
            },

            manuals = {
                cache = {
                    left = false, 
                    right = false,
                    forward = false 
                },

                left = false, 
                right = false,
                forward = false 
            },

            generation = {
                yaw = 0,

                head_size_in_yaw = 90,

                data = {}
            }
        },

        settings = {
            var = json.parse(database.read("vandal-settings") or "{}"),
            old_set = "",
            names = {}
        }
    },

    liblaries = {
        vector = require("vector"),
        entity = require("gamesense/entity"),
        base64 = require("gamesense/base64"),
        antiaim = require("gamesense/antiaim_funcs"),
        clipboard = require("gamesense/clipboard"),
        weapons = require("gamesense/csgo_weapons"),
        engineclient = require("gamesense/engineclient"),
        http = require("gamesense/http")
    },

    menu = {
        enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - ena\a78BBF9FFbled"),
        tab = ui.new_combobox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - \a78BBF9FFtab", {"anti-aim", "visuals", "misc", "settings"}),

        anti_aim = {},

        visuals = {
            elements = ui.new_multiselect("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - \a78BBF9FFelements", {"crosshair", "watermark", "arrows", "notifications"}),

            primary_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - primary \a78BBF9FFcolor", 120, 187, 249, 200),
            secondary_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - secondary \a78BBF9FFcolor", 232, 204, 21, 200),

            glow_amount = ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - notifications glow \a78BBF9FFamount", 3, 5, 3, true, "px"),

            arrows_offset = ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - arrows \a78BBF9FFoffset", -100, 20, 0, true, "px"),
            spready_arrows = ui.new_checkbox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - spready \a78BBF9FFarrows"),

            customize_text = ui.new_checkbox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - custom crosshair \a78BBF9FFtext"),
            custom_text = ui.new_textbox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - custom crosshair \a78BBF9FFtext"),
            custom_text_2 = ui.new_textbox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - custom crosshair \a78BBF9FFtext #2")
        },

        misc = {
            manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - manual \a78BBF9FFforward"),
            manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - manual \a78BBF9FFleft"),
            manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - manual \a78BBF9FFright"),
            freestanding = ui.new_hotkey("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - free\a78BBF9FFstanding"),

            anti_backstab = ui.new_checkbox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - anti \a78BBF9FFbackstab"),
            freestanding_disablers = ui.new_multiselect("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - freestanding \a78BBF9FFdisablers", {"in air", "crouch", "manuals"}),
            yaw_disablers = ui.new_multiselect("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - yaw \a78BBF9FFdisablers", {"freestanding", "manuals", "knife in air"}),
            animbreakers = ui.new_multiselect("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - animation \a78BBF9FFbreakers", {"legbreaker", "static legs in air", "moonwalk in air", "body lean"}),
            resolver_enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - resolver \a78BBF9FFenabled")
        },

        settings = {}
    },

    math = {
        pi = 180 / math.pi
    },

    utils = {
        table_contains = function(table, content)
            for i=1, #table do 
                if table[i] == content then return true end 
            end 

            return false 
        end,

        phase_to_int = function(phase) 
            return tonumber(phase:sub(2,2))
        end,

        normalize_yaw = function(yaw)
            while yaw > 180 do 
                yaw = yaw - 360 
            end 

            while yaw < -180 do
                yaw = yaw + 360 
            end 

            return yaw
        end,

        get_fake_amount = function()
            return entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        end,

        clamp = function(value, min, max)
            if value > max then 
                value = max 
            end 
    
            if value < min then 
                value = min 
            end 
    
            return value
        end,

        rgba_to_hex = function(r, g, b, a)
            return string.format("%02x%02x%02x%02x", r, g, b, a)
        end,

        time_to_ticks = function(time)
            return math.floor(0.5 + (time / globals.tickinterval()))
        end,

        ticks_to_time = function(ticks)
            return ticks * globals.tickinterval()
        end 
    },

    generation = {},

    resolver = {
        helpers = {

        },

        data = {
            side = {}
        }
    }
}

vandal.resolver.helpers.refresh_data = function()
    vandal.liblaries.http.get("https://vandal.vip/data/resolver.txt", function(success, response)
        local s, e = pcall(function() json.parse(response.body) end)
        if not s then return false end 

        vandal.resolver.data = json.parse(response.body)

        return true 
    end)
end 
local t = vandal.resolver.helpers.refresh_data() and "" or vandal.resolver.helpers.refresh_data()

vandal.utils.gradient_text = function(text, w, h, r1, g1, b1, a1, r2, g2, b2, a2)
    local delta_r, delta_g, delta_b, delta_a, final_text, text_len = r1 - r2, g1 - g2, b1 - b2, a1 - a2, "", string.len(text)

    for i=1, text_len do 
        final_text = ""..final_text.."\a"..vandal.utils.rgba_to_hex(r1 - (i * (delta_r / text_len)), g1 - (i * (delta_g / text_len)), b1 - (i * (delta_b / text_len)), a1 - (i * (delta_a / #text)))..""..text:sub(i, i)..""
    end 

    renderer.text(w, h, 255, 255, 255, 255, "-", 0, final_text)
end

vandal.utils.get_side = function()
    return vandal.utils.get_fake_amount() > 1 and -1 or 1 
end     

vandal.utils.should_anti_knife = function()
    local enemies = entity.get_players(true)

    for i=1, #enemies do 
        local dist = vandal.liblaries.vector(entity.get_origin(enemies[i])):dist2d(vandal.liblaries.vector(entity.get_origin(entity.get_local_player())))

        if entity.get_classname(entity.get_player_weapon(enemies[i])) == "CKnife" and dist < 100 then 
            return true and ui.get(vandal.menu.misc.anti_backstab)
        end 
    end 

    return false 
end 

vandal.utils.get_manual_yaw = function()
    if vandal.variables.anti_aim.manuals.forward then 
        return 180 
    elseif vandal.variables.anti_aim.manuals.left then
        return -90
    elseif vandal.variables.anti_aim.manuals.right then 
        return 90
    elseif vandal.utils.should_anti_knife() then 
        return 180 
    end 

    return 0
end 

vandal.utils.notify = function(string)
    vandal.variables.visuals.notifications[#vandal.variables.visuals.notifications + 1] = {text = string, start = globals.realtime(), alpha = 0, progress = 0}
end 

vandal.math.calc_angle = function(src, dst)
    local delta = vandal.liblaries.vector((src.x - dst.x), (src.y - dst.y), (src.z - dst.z))
    local hyp = math.sqrt(delta.x * delta.x + delta.y * delta.y)

    return vandal.liblaries.vector(vandal.math.pi * math.atan(delta.z / hyp), vandal.math.pi * math.atan(delta.y / delta.x), 0)
end 

vandal.state = {
    get = function(player)
        local data = {
            velocity = vandal.liblaries.vector(entity.get_prop(player, "m_vecVelocity")):length2d(),
            is_in_air = bit.band(entity.get_prop(player, "m_fFlags"), 1) == 0,
            is_crouching = bit.band(entity.get_prop(player, "m_fFlags"), bit.lshift(1, 1)) ~= 0,
            is_slowwalking = ui.get(vandal.variables.references.keybinds.items.slowwalk[2])
        }

        if data.velocity < 2 and not data.is_in_air and not data.is_crouching then 
            return 2
        elseif data.velocity > 2 and not data.is_in_air and not data.is_slowwalking and not data.is_crouching then 
            return 3 
        elseif not data.is_crouching and data.is_in_air then 
            return 4
        elseif data.is_slowwalking and not data.is_in_air and not data.is_crouching then 
            return 5
        elseif data.is_crouching and data.velocity < 2 and not data.is_in_air then 
            return 6
        elseif data.is_crouching and data.velocity > 2 and not data.is_in_air then 
            return 7 
        elseif data.is_crouching and data.is_in_air then 
            return 8
        end

        return 2
    end 
}

vandal.utils.should_freestand = function()
    local boolean = vandal.state.get(entity.get_local_player()) == 4 and vandal.utils.table_contains(ui.get(vandal.menu.misc.freestanding_disablers), "in air") 
            or vandal.state.get(entity.get_local_player()) == 7 and vandal.utils.table_contains(ui.get(vandal.menu.misc.freestanding_disablers), "in air") 
            or vandal.state.get(entity.get_local_player()) == 6 and vandal.utils.table_contains(ui.get(vandal.menu.misc.freestanding_disablers), "crouch")
            or vandal.utils.get_manual_yaw() ~= 0 and vandal.utils.table_contains(ui.get(vandal.menu.misc.freestanding_disablers), "manuals")

    return not boolean
end 

vandal.utils.should_jitter = function()
    local boolean = vandal.utils.table_contains(ui.get(vandal.menu.misc.yaw_disablers), "freestanding") and vandal.utils.should_freestand() and ui.get(vandal.menu.misc.freestanding)
            or vandal.utils.table_contains(ui.get(vandal.menu.misc.yaw_disablers), "manuals") and vandal.utils.get_manual_yaw() ~= 0    
            or vandal.utils.table_contains(ui.get(vandal.menu.misc.yaw_disablers), "knife in air") and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CKnife" and vandal.state.get(entity.get_local_player()) == 8

    return not boolean
end 

vandal.resolver.helpers.angle_mod = function(angle)
    return ((360 / 65536) * (angle * (65536 / 360)))
end 

vandal.resolver.helpers.approach_angle = function(target, value, speed)
    local adjusted_speed = speed
    if adjusted_speed < 0.0 then 
        adjusted_speed = adjusted_speed * -1
    end 

    local angle_mod_target = vandal.resolver.helpers.angle_mod(target)
    local angle_mod_value = vandal.resolver.helpers.angle_mod(value)

    local delta = angle_mod_target - angle_mod_value
    if delta >= -180 then 
        if delta >= 180 then 
            delta = delta - 360 
        end 
    else 
        if delta <= -180 then 
            delta = delta + 360 
        end 
    end 

    local ret = 0
    if delta <= adjusted_speed then 
        if (adjusted_speed * -1) <= delta then 
            ret = angle_mod_target 
        else 
            ret = (angle_mod_value - adjusted_speed)
        end 
    else 
        ret = angle_mod_value + adjusted_speed
    end 

    return ret 
end 

vandal.resolver.helpers.angle_diff = function(dest_angle, src_angle)
    local delta = math.fmod(dest_angle - src_angle, 360)

    if dest_angle > src_angle then 
        if delta >= 180 then 
            delta = delta - 360 
        end 
    else 
        if delta <= -180 then 
            delta = delta + 360 
        end 
    end 

    return delta 
end 

vandal.resolver.helpers.get_side = function(player, animlayer)
    local left_best_delta, right_best_delta = 9999, 9999
    
    for i=1, #vandal.resolver.data.side[1] do
        local left_delta = math.abs(animlayer.playback_rate - vandal.resolver.data.side[1][i])

        if left_delta < left_best_delta then 
            left_best_delta = left_delta
        end 
    end

    for i=1, #vandal.resolver.data.side[2] do
        local right_delta = math.abs(animlayer.playback_rate - vandal.resolver.data.side[2][i])

        if right_delta < right_best_delta then 
            right_best_delta = right_delta
        end 
    end

    return left_best_delta < right_best_delta and -1 or 1
end

vandal.resolver.helpers.process_side = function(player, side)
    if vandal.resolver.data[player].misses then 
        if vandal.resolver.data[player].misses % 2 == 1 then 
            side = side * -1
        end 
    end 
    
    return side 
end

vandal.menu.state_selection = ui.new_combobox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - \a78BBF9FFstate", vandal.variables.states)
for i=1, #vandal.variables.states do 
    vandal.menu.anti_aim[i] = {
        enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - \a78BBF9FFenabled"),

        stuff = {
            pitch = ui.new_combobox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - \a78BBF9FFpitch", {"off", "default", "up", "down", "minimal", "random", "custom", "exploit"}),
            custom_pitch = ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - custom \a78BBF9FFpitch", -89, 89, 0),
            
            yaw_base = ui.new_combobox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - yaw \a78BBF9FFbase", {"local view", "at targets"}),
            yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - yaw \a78BBF9FFbase", {"off", "180", "spin", "static", "180 Z", "crosshair"}),
            yaw_amount_left = ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - yaw amount \a78BBF9FFleft", -180, 180, 0),
            yaw_amount_right = ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - yaw amount \a78BBF9FFright", -180, 180, 0),

            yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - yaw \a78BBF9FFjitter", {"off", "offset", "center", "random", "skitter", "delayed"}),
            yaw_jitter_delay = ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - jitter \a78BBF9FFdelay", 1, 64, 0),
            yaw_jitter_amount = ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - yaw \a78BBF9FFjitter", -180, 180, 0),
            yaw_jitter_amount_2 = ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - yaw \a78BBF9FFjitter #2", -180, 180, 0),

            body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - body \a78BBF9FFyaw", {"off", "opposite", "jitter", "static"}),
            body_yaw_amount = ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - body \a78BBF9FFyaw amount", -180, 180, 0),

            avoidness = ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - avoidness \a78BBF9FFpercentage", 0, 100, 20),

            anti_bruteforce_type = ui.new_combobox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - anti-bruteforce \a78BBF9FFtype", {"off", "yaw-generation", "jitter-generation", "custom"}),

            jitter_generation_limit = ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - generation angle \a78BBF9FFlimit", 0, 180, 90),

            anti_bruteforce_phase = ui.new_combobox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - anti-bruteforce \a78BBF9FFphase", {"#1", "#2", "#3", "#4", "#5"}),

            anti_bruteforce = {
                ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - jitter value \a78BBF9FF#1", -180, 180, 0),
                ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - jitter value \a78BBF9FF#2", -180, 180, 0),
                ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - jitter value \a78BBF9FF#3", -180, 180, 0),
                ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - jitter value \a78BBF9FF#4", -180, 180, 0),
                ui.new_slider("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - jitter value \a78BBF9FF#5", -180, 180, 0)
            },

            defensive_flicks = ui.new_combobox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - "..vandal.variables.states[i].." - defensive flicks \a78BBF9FFtype", {"off", "highest-damage"})
        }
    }
end 

vandal.utils.export_settings = function()
    local settings = {}
    
    for i=1, #vandal.variables.states do 
        local state = vandal.variables.states[i]

        settings[state] = {}

        for i2,v in pairs(vandal.menu.anti_aim[i].stuff) do 
            settings[state][i2] = {}
            settings[state]["enabled"] = ui.get(vandal.menu.anti_aim[i].enabled)

            if type(v) == "table" then 
                for i3, v2 in pairs(v) do 
                    settings[state][i2][i3] = ui.get(v2)
                end 
            else 
                settings[state][i2] = ui.get(v)
            end
        end 
    end 

    return vandal.liblaries.base64.encode(json.stringify(settings))
end 

vandal.utils.import_settings = function(setts)
    local settings = json.parse(vandal.liblaries.base64.decode(setts))
    
    for i=1, #vandal.variables.states do 
        local state = vandal.variables.states[i]
    
        for i2,v in pairs(vandal.menu.anti_aim[i].stuff) do 
            local s, e = pcall(function() ui.set(vandal.menu.anti_aim[i].enabled, settings[state]["enabled"]) end)
    
            if type(v) == "table" then 
                for i3, v2 in pairs(v) do 
                    local s, e = pcall(function() ui.set(v2, settings[state][i2][i3]) end)
                end 
            else 
                local s, e = pcall(function() ui.set(v, settings[state][i2]) end)
            end
        end 
    end 
end 

vandal.menu.settings = {
    selection = ui.new_listbox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - settings \a78BBF9FFselection", vandal.variables.settings.names),
    name = ui.new_textbox("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - settings \a78BBF9FFname")
}

vandal.utils.refresh_settings = function(write)
    vandal.variables.settings.names = {}

    for i, v in pairs(vandal.variables.settings.var) do 
        if v ~= nil then 
            vandal.variables.settings.names[#vandal.variables.settings.names + 1] = i 
        end 
    end

    ui.update(vandal.menu.settings.selection, vandal.variables.settings.names)

    if write then 
        database.write("vandal-settings", json.stringify(vandal.variables.settings.var))

        if ui.get(vandal.menu.settings.selection) ~= nil then 
            local num = tonumber(ui.get(vandal.menu.settings.selection)) + 1

            ui.set(vandal.menu.settings.name, vandal.variables.settings.names[num])
        end 
    end 
end 

vandal.utils.refresh_settings(false)

vandal.menu.settings.load_settings = ui.new_button("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - load \a78BBF9FFsettings", function()
    local success, e = pcall(function() vandal.utils.import_settings(vandal.variables.settings.var[ui.get(vandal.menu.settings.name)]) end)

    vandal.utils.notify(success and "settings loaded successfully" or "failed to load settings")
end)

vandal.menu.settings.save_settings = ui.new_button("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - save \a78BBF9FFsettings", function()
    vandal.variables.settings.var[ui.get(vandal.menu.settings.name)] = vandal.utils.export_settings()

    vandal.utils.notify("saved settings")

    vandal.utils.refresh_settings(true)
end)

vandal.menu.settings.delete_settings = ui.new_button("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - delete \a78BBF9FFsettings", function()
    vandal.variables.settings.var[ui.get(vandal.menu.settings.name)] = nil 

    vandal.utils.notify("deleted settings")

    vandal.utils.refresh_settings(true)
end)

vandal.menu.settings.reset_settings = ui.new_button("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - reset \a78BBF9FFsettings", function()
    vandal.variables.settings.var[ui.get(vandal.menu.settings.name)] = "eyJtb3ZpbmciOnsieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXdfYW1vdW50IjowLCJwaXRjaCI6Im9mZiIsImF2b2lkbmVzcyI6MCwiYm9keV95YXciOiJvZmYiLCJhbnRpX2JydXRlZm9yY2VfcGhhc2UiOiIjMSIsInlhdyI6Im9mZiIsInlhd19hbW91bnQiOjAsImFudGlfYnJ1dGVmb3JjZV90eXBlIjoib2ZmIiwiaml0dGVyX2dlbmVyYXRpb25fbGltaXQiOjkwLCJleHRyYXBvbGF0aW9uIjowLCJ5YXdfaml0dGVyX2Ftb3VudCI6MCwieWF3X2ppdHRlciI6Im9mZiIsImVuYWJsZWQiOmZhbHNlLCJhbnRpX2JydXRlZm9yY2UiOlswLDAsMCwwLDBdLCJkZWZlbnNpdmVfZmxpY2tzIjoib2ZmIn0sImluIGFpciI6eyJ5YXdfYmFzZSI6ImxvY2FsIHZpZXciLCJib2R5X3lhd19hbW91bnQiOjAsInBpdGNoIjoib2ZmIiwiYXZvaWRuZXNzIjowLCJib2R5X3lhdyI6Im9mZiIsImFudGlfYnJ1dGVmb3JjZV9waGFzZSI6IiMxIiwieWF3Ijoib2ZmIiwieWF3X2Ftb3VudCI6MCwiYW50aV9icnV0ZWZvcmNlX3R5cGUiOiJvZmYiLCJqaXR0ZXJfZ2VuZXJhdGlvbl9saW1pdCI6OTAsImV4dHJhcG9sYXRpb24iOjAsInlhd19qaXR0ZXJfYW1vdW50IjowLCJ5YXdfaml0dGVyIjoib2ZmIiwiZW5hYmxlZCI6ZmFsc2UsImFudGlfYnJ1dGVmb3JjZSI6WzAsMCwwLDAsMF0sImRlZmVuc2l2ZV9mbGlja3MiOiJvZmYifSwic2xvd3dhbGtpbmciOnsieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXdfYW1vdW50IjowLCJwaXRjaCI6Im9mZiIsImF2b2lkbmVzcyI6MCwiYm9keV95YXciOiJvZmYiLCJhbnRpX2JydXRlZm9yY2VfcGhhc2UiOiIjMSIsInlhdyI6Im9mZiIsInlhd19hbW91bnQiOjAsImFudGlfYnJ1dGVmb3JjZV90eXBlIjoib2ZmIiwiaml0dGVyX2dlbmVyYXRpb25fbGltaXQiOjkwLCJleHRyYXBvbGF0aW9uIjowLCJ5YXdfaml0dGVyX2Ftb3VudCI6MCwieWF3X2ppdHRlciI6Im9mZiIsImVuYWJsZWQiOmZhbHNlLCJhbnRpX2JydXRlZm9yY2UiOlswLDAsMCwwLDBdLCJkZWZlbnNpdmVfZmxpY2tzIjoib2ZmIn0sImNyb3VjaCBpbiBhaXIiOnsieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXdfYW1vdW50IjowLCJwaXRjaCI6Im9mZiIsImF2b2lkbmVzcyI6MCwiYm9keV95YXciOiJvZmYiLCJhbnRpX2JydXRlZm9yY2VfcGhhc2UiOiIjMSIsInlhdyI6Im9mZiIsInlhd19hbW91bnQiOjAsImFudGlfYnJ1dGVmb3JjZV90eXBlIjoib2ZmIiwiaml0dGVyX2dlbmVyYXRpb25fbGltaXQiOjkwLCJleHRyYXBvbGF0aW9uIjowLCJ5YXdfaml0dGVyX2Ftb3VudCI6MCwieWF3X2ppdHRlciI6Im9mZiIsImVuYWJsZWQiOmZhbHNlLCJhbnRpX2JydXRlZm9yY2UiOlswLDAsMCwwLDBdLCJkZWZlbnNpdmVfZmxpY2tzIjoib2ZmIn0sImNyb3VjaGluZyI6eyJ5YXdfYmFzZSI6ImxvY2FsIHZpZXciLCJib2R5X3lhd19hbW91bnQiOjAsInBpdGNoIjoib2ZmIiwiYXZvaWRuZXNzIjowLCJib2R5X3lhdyI6Im9mZiIsImFudGlfYnJ1dGVmb3JjZV9waGFzZSI6IiMxIiwieWF3Ijoib2ZmIiwieWF3X2Ftb3VudCI6MCwiYW50aV9icnV0ZWZvcmNlX3R5cGUiOiJvZmYiLCJqaXR0ZXJfZ2VuZXJhdGlvbl9saW1pdCI6OTAsImV4dHJhcG9sYXRpb24iOjAsInlhd19qaXR0ZXJfYW1vdW50IjowLCJ5YXdfaml0dGVyIjoib2ZmIiwiZW5hYmxlZCI6ZmFsc2UsImFudGlfYnJ1dGVmb3JjZSI6WzAsMCwwLDAsMF0sImRlZmVuc2l2ZV9mbGlja3MiOiJvZmYifSwic3RhbmRpbmciOnsieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXdfYW1vdW50IjowLCJwaXRjaCI6Im9mZiIsImF2b2lkbmVzcyI6MCwiYm9keV95YXciOiJvZmYiLCJhbnRpX2JydXRlZm9yY2VfcGhhc2UiOiIjMSIsInlhdyI6Im9mZiIsInlhd19hbW91bnQiOjAsImFudGlfYnJ1dGVmb3JjZV90eXBlIjoib2ZmIiwiaml0dGVyX2dlbmVyYXRpb25fbGltaXQiOjkwLCJleHRyYXBvbGF0aW9uIjowLCJ5YXdfaml0dGVyX2Ftb3VudCI6MCwieWF3X2ppdHRlciI6Im9mZiIsImVuYWJsZWQiOmZhbHNlLCJhbnRpX2JydXRlZm9yY2UiOlswLDAsMCwwLDBdLCJkZWZlbnNpdmVfZmxpY2tzIjoib2ZmIn0sImRlZmF1bHQiOnsieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXdfYW1vdW50IjowLCJwaXRjaCI6Im9mZiIsImF2b2lkbmVzcyI6MCwiYm9keV95YXciOiJvZmYiLCJhbnRpX2JydXRlZm9yY2VfcGhhc2UiOiIjMSIsInlhdyI6Im9mZiIsInlhd19hbW91bnQiOjAsImFudGlfYnJ1dGVmb3JjZV90eXBlIjoib2ZmIiwiaml0dGVyX2dlbmVyYXRpb25fbGltaXQiOjkwLCJleHRyYXBvbGF0aW9uIjowLCJ5YXdfaml0dGVyX2Ftb3VudCI6MCwieWF3X2ppdHRlciI6Im9mZiIsImVuYWJsZWQiOnRydWUsImFudGlfYnJ1dGVmb3JjZSI6WzAsMCwwLDAsMF0sImRlZmVuc2l2ZV9mbGlja3MiOiJvZmYifX0="

    vandal.utils.notify("resetted settings")

    vandal.utils.refresh_settings(true)
end)

vandal.menu.settings.export_settings = ui.new_button("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - export to \a78BBF9FFclipboard", function()
    vandal.liblaries.clipboard.set(vandal.utils.export_settings())

    vandal.utils.notify("exported settings")
end)

vandal.menu.settings.import_settings = ui.new_button("AA", "Anti-aimbot angles", "\a78BBF9FFvandal\aE8CC15FF.tech\aFFFFFFB2 - import from \a78BBF9FFclipboard", function()
    local success, e = pcall(function() vandal.utils.import_settings(vandal.liblaries.clipboard.get()) end)
    
    vandal.utils.notify(success and "settings imported successfully" or "failed to import settings")
end)

local function process_settings()
    if ui.get(vandal.menu.settings.selection) ~= nil and vandal.variables.settings.old_set ~= ui.get(vandal.menu.settings.selection) then 
        local num = tonumber(ui.get(vandal.menu.settings.selection)) + 1

        ui.set(vandal.menu.settings.name, vandal.variables.settings.names[num])

        vandal.variables.settings.old_set = ui.get(vandal.menu.settings.selection)
    end 
end 

vandal.generation.get_lerp_time = function()
    local minupdate, maxupdate = cvar.sv_minupdaterate:get_float(), cvar.sv_maxupdaterate:get_float()
    local ratio = cvar.cl_interp_ratio:get_float() == 0.0 and 1.0 or cvar.cl_interp_ratio:get_float()
    local lerp = cvar.cl_interp:get_float()
    local cmin, cmax = cvar.sv_client_min_interp_ratio:get_float(), cvar.sv_client_max_interp_ratio:get_float()

    if cmin ~= 1 then 
        ratio = vandal.utils.clamp(ratio, cmin, cmax)
    end 

    return math.max(lerp, ratio / maxupdate)
end 

vandal.generation.get_backtrack_ticks = function(player)
    local net_channel = vandal.liblaries.engineclient.get_net_channel_info()

    local sv_maxunlag = cvar.sv_maxunlag:get_float()
    local correct = vandal.utils.clamp(vandal.generation.get_lerp_time() + net_channel.avg_latency[0] + net_channel.avg_latency[1], 0, sv_maxunlag)

    local best_ticks, best_dmg = 0, 0
    for i=1, 64 do 
        if vandal.variables.anti_aim.generation.data[globals.tickcount() - i] then 
            if math.abs(correct - (globals.curtime() - vandal.variables.anti_aim.generation.data[globals.tickcount() - i].simtime)) < sv_maxunlag + net_channel.avg_latency[0] + net_channel.avg_latency[1] then 
                local head_pos = vandal.variables.anti_aim.generation.data[globals.tickcount() - i].head_pos
                local enemy_head_pos = vandal.liblaries.vector(entity.hitbox_position(player, 0))

                local ent, dmg = client.trace_bullet(player, enemy_head_pos.x, enemy_head_pos.y, enemy_head_pos.z, head_pos.x, head_pos.y, head_pos.z, player)

                if dmg >= best_dmg then 
                    best_ticks = i 
                    best_dmg = dmg
                end 
            end 
        end 
    end 

    vandal.variables.visuals.generation.backtrack = best_ticks

    return best_ticks
end 

vandal.generation.calculate_damage = function(player, angle)
    local net_channel = vandal.liblaries.engineclient.get_net_channel_info()
    local head_pos = vandal.liblaries.vector(entity.hitbox_position(entity.get_local_player(), 0))
    local enemy_head_pos = vandal.liblaries.vector(entity.hitbox_position(player, 0))
    local origin = vandal.liblaries.vector(entity.get_origin(entity.get_local_player()))

    local rad = origin:dist2d(head_pos)

    origin.z = head_pos.z 

    origin = origin - (vandal.liblaries.vector(entity.get_prop(entity.get_local_player()), "m_vecVelocity") * vandal.utils.time_to_ticks(net_channel.latency[0] + net_channel.latency[1]))

    local angles = vandal.liblaries.vector():init_from_angles(0, angle + vandal.variables.anti_aim.generation.yaw, 0) * rad

    local final_pos = origin + angles 

    local final_enemy_pos = enemy_head_pos + vandal.math.calc_angle(enemy_head_pos, final_pos)
    local ent, damage = client.trace_bullet(player, final_enemy_pos.x, final_enemy_pos.y, final_enemy_pos.z, final_pos.x, final_pos.y, final_pos.z, player)

    -- local x, y = renderer.world_to_screen(final_pos.x, final_pos.y, final_pos.z)
    -- renderer.text(x, y, damage > 0 and 255 or 0, damage > 0 and 0 or 255, 0, 255, "-", 0, damage)

    vandal.variables.visuals.generation.head_size_in_yaw = (4.2000004200000 * 4.5) / (vandal.liblaries.vector():init_from_angles(0, 1, 0) * rad):length2d()

    return damage, final_pos
end

vandal.generation.generate_angle = function(player, avoidness)
    if avoidness <= 10 then return 0 end 

    vandal.variables.visuals.generation.dangerous = false 

    local lowest_dmg, best_angle, best_position = 9999, 0, vandal.liblaries.vector(0, 0, 0)
    local percentage = (avoidness / 100) / 2
    local step = math.floor(10 * (avoidness / 100)) -- 20
    local range = 180 / step

    for i=-range, range do 
        local angle = i * range

        local damage, position = vandal.generation.calculate_damage(player, angle, avoidness)
        
        if damage > 0 then vandal.variables.visuals.generation.dangerous = true end 

        if damage < lowest_dmg 
            or damage == lowest_dmg and best_angle > 0 and angle < best_angle 
            or damage == lowest_dmg and best_angle < 0 and best_angle < angle then 
    
            lowest_dmg = damage
            best_angle = angle
            best_position = position
        end 
    end 

    for i=best_angle - (range - 1), best_angle + (range - 1) do 
        if avoidness == 100 or i % (1 / percentage) == 1 then 
            local damage, position = vandal.generation.calculate_damage(player, i, avoidness)
            
            if damage > 0 then vandal.variables.visuals.generation.dangerous = true end 

            if damage < lowest_dmg 
                or damage == lowest_dmg and best_angle > 0 and i < best_angle 
                or damage == lowest_dmg and best_angle < 0 and best_angle < i then 
            
                lowest_dmg = damage
                best_angle = i
                best_position = position
            end 
        end 
    end 

    vandal.variables.visuals.generation.angle = math.floor(best_angle)
    vandal.variables.visuals.generation.damage = math.floor(lowest_dmg)
    vandal.variables.visuals.generation.best_position = best_position

    return vandal.utils.normalize_yaw(math.floor(best_angle + (vandal.variables.anti_aim.generation.head_size_in_yaw * best_angle)))
end 

vandal.generation.generate_flick = function(player, avoidness)
    local best_dmg, best_angle = 0, 0
    local percentage = avoidness / 100

    for i=-180 * percentage, 180 * percentage do 
        local damage = vandal.generation.calculate_damage(player, i, avoidness, 0)
    
        if damage > best_dmg then 
            best_dmg = damage
            best_angle = i
        end 
    end
    
    return vandal.utils.normalize_yaw(math.floor(best_angle + (vandal.variables.anti_aim.generation.head_size_in_yaw * best_angle)))
end 

vandal.generation.generate_jitter = function(player, avoidness)
    local lowest_dmg, best_angle = 9999, 0
    local percentage = avoidness / 100

    for i=0, 180 * percentage do 
        local damage, damage2 = vandal.generation.calculate_damage(player, i, avoidness), vandal.generation.calculate_damage(player, -i, avoidness)

        damage = damage + damage2

        if damage < lowest_dmg 
            or damage == lowest_dmg and best_angle > 0 and i < best_angle 
            or damage == lowest_dmg and best_angle < 0 and best_angle < i then 
    
            lowest_dmg = damage
            best_angle = i
        end 
    end

    vandal.variables.visuals.generation.damage = lowest_dmg
    
    return vandal.utils.normalize_yaw(math.floor(best_angle + (vandal.variables.anti_aim.generation.head_size_in_yaw * best_angle)))
end 

local function initialize_menu()
    ui.set(vandal.menu.visuals.customize_text, false)
end 
initialize_menu()

local function menu_handler()
    local lua_enabled = ui.get(vandal.menu.enabled)
    local lua_menu_enabled = not lua_enabled
    local lua_aa_enabled = lua_enabled and ui.get(vandal.menu.tab) == "anti-aim"
    local lua_visuals_enabled = lua_enabled and ui.get(vandal.menu.tab) == "visuals"
    local lua_misc_enabled = lua_enabled and ui.get(vandal.menu.tab) == "misc"
    local lua_settings_enabled = lua_enabled and ui.get(vandal.menu.tab) == "settings"

    for i, v in pairs(vandal.variables.references) do 
        if type(v) == "table" then 
            for i2, v2 in pairs(v) do 
                if type(v2) == "table" then 
                    for i3, v3 in pairs(v2) do 
                        if not type(v3) == "table" then 
                            ui.set_visible(v3, lua_menu_enabled)
                        end 
                    end 
                else 
                    ui.set_visible(v2, lua_menu_enabled)
                end 
            end 
        else 
            ui.set_visible(v, lua_menu_enabled)
        end 
    end 

    ui.set_visible(vandal.menu.tab, lua_enabled)
    ui.set_visible(vandal.menu.state_selection, lua_aa_enabled)

    for i,v in pairs(vandal.menu.visuals) do 
        ui.set_visible(v, lua_visuals_enabled)
    end 

    ui.set_visible(vandal.menu.visuals.arrows_offset, lua_visuals_enabled and vandal.utils.table_contains(ui.get(vandal.menu.visuals.elements), "arrows"))
    ui.set_visible(vandal.menu.visuals.spready_arrows, lua_visuals_enabled and vandal.utils.table_contains(ui.get(vandal.menu.visuals.elements), "arrows"))

    ui.set_visible(vandal.menu.visuals.glow_amount, lua_visuals_enabled and vandal.utils.table_contains(ui.get(vandal.menu.visuals.elements), "notifications"))

    ui.set_visible(vandal.menu.visuals.customize_text, lua_visuals_enabled and vandal.utils.table_contains(ui.get(vandal.menu.visuals.elements), "crosshair"))
    ui.set_visible(vandal.menu.visuals.custom_text, lua_visuals_enabled and ui.get(vandal.menu.visuals.customize_text) and vandal.utils.table_contains(ui.get(vandal.menu.visuals.elements), "crosshair"))
    ui.set_visible(vandal.menu.visuals.custom_text_2, lua_visuals_enabled and ui.get(vandal.menu.visuals.customize_text) and vandal.utils.table_contains(ui.get(vandal.menu.visuals.elements), "crosshair"))

    if not ui.get(vandal.menu.visuals.customize_text) then 
        ui.set(vandal.menu.visuals.custom_text, "VANDAL")
        ui.set(vandal.menu.visuals.custom_text_2, "TECH")
    end 

    for i,v in pairs(vandal.menu.misc) do 
        ui.set_visible(v, lua_misc_enabled)
    end 

    if not (vandal.variables.visuals.user.build == "Debug" or vandal.variables.visuals.user.build == "Private" or vandal.variables.visuals.user.build == "Source") then 
        ui.set(vandal.menu.misc.resolver_enabled, false)
        ui.set_visible(vandal.menu.misc.resolver_enabled, false)
    end 

    for i,v in pairs(vandal.menu.settings) do 
        ui.set_visible(v, lua_settings_enabled)
    end 
    
    for i=1, #vandal.variables.states do 
        for i2,v in pairs(vandal.menu.anti_aim[i]) do 
            if type(v) == "table" then 
                for i3, v2 in pairs(v) do 
                    if type(v2) == "table" then 
                        for i4, v3 in pairs(v2) do 
                            ui.set_visible(v3, false)
                        end 
                    else 
                        ui.set_visible(v2, false)
                    end 
                end 
            else 
                ui.set_visible(v, false)
            end 
        end     
    end 

    for i=1, #vandal.variables.states do 
        if ui.get(vandal.menu.state_selection) == vandal.variables.states[i] then 
            ui.set_visible(vandal.menu.anti_aim[i].enabled, lua_aa_enabled)

            local state_enabled = ui.get(vandal.menu.anti_aim[i].enabled) and lua_aa_enabled

            ui.set_visible(vandal.menu.anti_aim[i].stuff.pitch, state_enabled) 
            ui.set_visible(vandal.menu.anti_aim[i].stuff.custom_pitch, state_enabled and ui.get(vandal.menu.anti_aim[i].stuff.pitch) == "custom") 

            ui.set_visible(vandal.menu.anti_aim[i].stuff.yaw_base, state_enabled)
            ui.set_visible(vandal.menu.anti_aim[i].stuff.yaw, state_enabled)
            ui.set_visible(vandal.menu.anti_aim[i].stuff.yaw_amount_left, state_enabled and ui.get(vandal.menu.anti_aim[i].stuff.yaw) ~= "off")
            ui.set_visible(vandal.menu.anti_aim[i].stuff.yaw_amount_right, state_enabled and ui.get(vandal.menu.anti_aim[i].stuff.yaw) ~= "off")

            ui.set_visible(vandal.menu.anti_aim[i].stuff.yaw_jitter, state_enabled)
            ui.set_visible(vandal.menu.anti_aim[i].stuff.yaw_jitter_delay, state_enabled and ui.get(vandal.menu.anti_aim[i].stuff.yaw_jitter) == "delayed")
            ui.set_visible(vandal.menu.anti_aim[i].stuff.yaw_jitter_amount, state_enabled and ui.get(vandal.menu.anti_aim[i].stuff.yaw_jitter) ~= "off")
            ui.set_visible(vandal.menu.anti_aim[i].stuff.yaw_jitter_amount_2, state_enabled and ui.get(vandal.menu.anti_aim[i].stuff.yaw_jitter) == "delayed")

            ui.set_visible(vandal.menu.anti_aim[i].stuff.body_yaw, state_enabled)
            ui.set_visible(vandal.menu.anti_aim[i].stuff.body_yaw_amount, state_enabled and ui.get(vandal.menu.anti_aim[i].stuff.body_yaw) ~= "off" and ui.get(vandal.menu.anti_aim[i].stuff.body_yaw) ~= "opposite")

            ui.set_visible(vandal.menu.anti_aim[i].stuff.avoidness, state_enabled)
            ui.set_visible(vandal.menu.anti_aim[i].stuff.anti_bruteforce_type, state_enabled)
            ui.set_visible(vandal.menu.anti_aim[i].stuff.jitter_generation_limit, state_enabled and ui.get(vandal.menu.anti_aim[i].stuff.anti_bruteforce_type) == "jitter-generation")

            ui.set_visible(vandal.menu.anti_aim[i].stuff.anti_bruteforce_phase, state_enabled and ui.get(vandal.menu.anti_aim[i].stuff.anti_bruteforce_type) == "custom")
            ui.set_visible(vandal.menu.anti_aim[i].stuff.anti_bruteforce[vandal.utils.phase_to_int(ui.get(vandal.menu.anti_aim[i].stuff.anti_bruteforce_phase))], state_enabled and ui.get(vandal.menu.anti_aim[i].stuff.anti_bruteforce_type) == "custom")

            ui.set_visible(vandal.menu.anti_aim[i].stuff.defensive_flicks, state_enabled)
        end 
    end 
end 

local function anti_aim_handler()
    if not ui.get(vandal.menu.enabled) and ui.get(vandal.menu.anti_aim[1].enabled) then return end 

    vandal.utils.should_anti_knife()

    local state = ui.get(vandal.menu.anti_aim[vandal.state.get(entity.get_local_player())].enabled) and vandal.state.get(entity.get_local_player()) or 1 

    if ui.get(vandal.menu.anti_aim[state].stuff.pitch) ~= "exploit" then 
        ui.set(vandal.variables.references.pitch[1], ui.get(vandal.menu.anti_aim[state].stuff.pitch))
    else 
        if vandal.variables.anti_aim.defensive.ticks_left > 0 then 
            ui.set(vandal.variables.references.pitch[1], ui.get(vandal.variables.references.pitch[1]) == "Down" and "up" or "down")
        else 
            ui.set(vandal.variables.references.pitch[1], "down")
        end 
    end 
    ui.set(vandal.variables.references.pitch[2], ui.get(vandal.menu.anti_aim[state].stuff.custom_pitch))

    ui.set(vandal.variables.references.yaw_base, ui.get(vandal.menu.anti_aim[state].stuff.yaw_base))
    ui.set(vandal.variables.references.yaw[1], ui.get(vandal.menu.anti_aim[state].stuff.yaw))

    local yaw = vandal.utils.get_side() == -1 and ui.get(vandal.menu.anti_aim[state].stuff.yaw_amount_left) or ui.get(vandal.menu.anti_aim[state].stuff.yaw_amount_right)  

    if vandal.utils.should_jitter() then 
        if ui.get(vandal.menu.anti_aim[state].stuff.yaw_jitter) == "delayed" and vandal.variables.anti_aim.anti_bruteforce.activated > 0.75 then 
            ui.set(vandal.variables.references.yaw_jitter[1], "off")

            yaw = vandal.utils.normalize_yaw(yaw + (vandal.variables.anti_aim.var.side == -1 and ui.get(vandal.menu.anti_aim[state].stuff.yaw_jitter_amount) or ui.get(vandal.menu.anti_aim[state].stuff.yaw_jitter_amount_2)))
        else 
            ui.set(vandal.variables.references.yaw_jitter[1], ui.get(vandal.menu.anti_aim[state].stuff.yaw_jitter) == "delayed" and "center" or ui.get(vandal.menu.anti_aim[state].stuff.yaw_jitter))

            if ui.get(vandal.menu.anti_aim[state].stuff.anti_bruteforce_type) == "jitter-generation" and globals.realtime() - vandal.variables.anti_aim.anti_bruteforce.activated < 0.75 or ui.get(vandal.menu.anti_aim[state].stuff.anti_bruteforce_type) == "custom" and globals.realtime() - vandal.variables.anti_aim.anti_bruteforce.activated < 0.75 then
                ui.set(vandal.variables.references.yaw_jitter[2], vandal.utils.normalize_yaw(vandal.variables.anti_aim.anti_bruteforce.angle))
            else
                ui.set(vandal.variables.references.yaw_jitter[2], ui.get(vandal.menu.anti_aim[state].stuff.yaw_jitter_amount))
            end 
        end 

        ui.set(vandal.variables.references.body_yaw[1], globals.realtime() - vandal.variables.anti_aim.anti_bruteforce.activated < 0.75 and "Off" or ui.get(vandal.menu.anti_aim[state].stuff.body_yaw))
        ui.set(vandal.variables.references.body_yaw[2], ui.get(vandal.menu.anti_aim[state].stuff.body_yaw_amount))
    else 
        ui.set(vandal.variables.references.yaw_jitter[1], "Off")
        ui.set(vandal.variables.references.body_yaw[1], "Off")
    end 

    ui.set(vandal.variables.references.freestanding[1], vandal.utils.should_freestand() and ui.get(vandal.menu.misc.freestanding))
    ui.set(vandal.variables.references.freestanding[2], ui.get(vandal.menu.misc.freestanding) and "Always on" or "Off hotkey")

    if ui.get(vandal.menu.anti_aim[state].stuff.yaw_jitter_delay) ~= 1 and globals.tickcount() % ui.get(vandal.menu.anti_aim[state].stuff.yaw_jitter_delay) == 1 or 1 == 1 then 
        vandal.variables.anti_aim.var.side = vandal.variables.anti_aim.var.side * -1
    end 

    ui.set(vandal.variables.references.yaw[2], yaw) -- makes animfix put current animations on simulating the newest angle so we its easier to do avoidness

    if ui.get(vandal.menu.anti_aim[state].stuff.anti_bruteforce_type) == "yaw-generation" and globals.realtime() - vandal.variables.anti_aim.anti_bruteforce.activated < 0.75 then 
        yaw = vandal.utils.normalize_yaw(yaw + vandal.variables.anti_aim.anti_bruteforce.angle + vandal.utils.get_manual_yaw())
    else 
        if client.current_threat() then 
            if vandal.variables.anti_aim.defensive.ticks_left > 0 and ui.get(vandal.menu.anti_aim[state].stuff.defensive_flicks) == "highest-damage" then 
                yaw = vandal.utils.normalize_yaw(vandal.generation.generate_flick(client.current_threat(), ui.get(vandal.menu.anti_aim[state].stuff.avoidness)))
            else 
                yaw = vandal.utils.normalize_yaw(yaw + vandal.generation.generate_angle(client.current_threat(), ui.get(vandal.menu.anti_aim[state].stuff.avoidness)) + vandal.utils.get_manual_yaw())
            end 
        else 
            yaw = vandal.utils.normalize_yaw(yaw + vandal.utils.get_manual_yaw())
        end 
    end 

    ui.set(vandal.variables.references.yaw[2], yaw)
end 

local function anti_bruteforce_handler(event)
    local enemy = client.userid_to_entindex(event.userid)
    local dist = vandal.liblaries.vector(entity.hitbox_position(entity.get_local_player(), 0)):dist2d(vandal.liblaries.vector(event.x, event.y, event.z))

    if not entity.is_enemy(enemy) or not entity.is_alive(enemy) or not entity.is_alive(entity.get_local_player()) or dist > 300 or globals.realtime() - vandal.variables.anti_aim.anti_bruteforce.activated < 0.75 then 
        return 
    end 

    local backtrack = vandal.generation.get_backtrack_ticks(enemy)
    local state = ui.get(vandal.menu.anti_aim[vandal.state.get(entity.get_local_player())].enabled) and vandal.state.get(entity.get_local_player()) or 1 
    if ui.get(vandal.menu.anti_aim[state].stuff.anti_bruteforce_type) == "off" then return end 

    local angle = 0

    if ui.get(vandal.menu.anti_aim[state].stuff.anti_bruteforce_type) == "yaw-generation" then
        angle = vandal.generation.generate_angle(enemy, 100)

        client.log("[vandal] generated yaw: "..angle.." (damage: "..vandal.variables.visuals.generation.damage.." bt: "..backtrack..")")
    elseif ui.get(vandal.menu.anti_aim[state].stuff.anti_bruteforce_type) == "jitter-generation" then 
        angle = vandal.generation.generate_jitter(enemy, (ui.get(vandal.menu.anti_aim[state].stuff.jitter_generation_limit) / 180) * 100)

        client.log("[vandal] generated jitter: "..angle.." (damage: "..(vandal.variables.visuals.generation.damage / 2).." bt: "..backtrack..")")
    elseif ui.get(vandal.menu.anti_aim[state].stuff.anti_bruteforce_type) == "custom" then 
        angle = ui.get(vandal.menu.anti_aim[state].stuff.anti_bruteforce[vandal.variables.anti_aim.anti_bruteforce.phase])
    end 

    vandal.variables.anti_aim.anti_bruteforce.activated = globals.realtime()
    vandal.variables.anti_aim.anti_bruteforce.angle = angle

    if ui.get(vandal.menu.anti_aim[state].stuff.anti_bruteforce_type) == "custom" then 
        if vandal.variables.anti_aim.anti_bruteforce.phase >= 5 then 
            vandal.variables.anti_aim.anti_bruteforce.phase = 1
        else 
            vandal.variables.anti_aim.anti_bruteforce.phase = vandal.variables.anti_aim.anti_bruteforce.phase + 1
        end 
    end 

    vandal.utils.notify("anti-brute triggered due to shot by "..entity.get_player_name(enemy).." bt: "..backtrack.."t angle: "..angle.."°")
end 

local function initialize_indicators()
    local w, h = client.screen_size()

    vandal.variables.visuals.watermark = {
        width = w / 2 - (61 / 2), 
        height = h - 10
    }
end 
initialize_indicators()

local function indicators_handler()
    local w, h = client.screen_size()
    local state = vandal.state.get(entity.get_local_player()) - 1

    local main_r, main_g, main_b, main_a = ui.get(vandal.menu.visuals.primary_color)
    local sec_r, sec_g, sec_b, sec_a = ui.get(vandal.menu.visuals.secondary_color)

    if entity.is_alive(entity.get_local_player()) then 
        if vandal.utils.table_contains(ui.get(vandal.menu.visuals.elements), "crosshair") then 
            local stuff = {
                {
                    text = ui.get(vandal.menu.visuals.custom_text),

                    get_color = function()
                        local min, max, step = 1.75, 200, 1.75
                        if vandal.variables.visuals.crosshair.step == 1 then 
                            if vandal.variables.visuals.crosshair.text_alpha_2 < max then 
                                vandal.variables.visuals.crosshair.text_alpha_2 = vandal.variables.visuals.crosshair.text_alpha_2 + step
                            end 

                            if vandal.variables.visuals.crosshair.text_alpha > min then 
                                vandal.variables.visuals.crosshair.text_alpha = vandal.variables.visuals.crosshair.text_alpha - step
                            end 

                            if vandal.variables.visuals.crosshair.text_alpha <= min and vandal.variables.visuals.crosshair.text_alpha_2 >= max then 
                                vandal.variables.visuals.crosshair.step = 2
                            end 
                        elseif vandal.variables.visuals.crosshair.step == 2 then 
                            if vandal.variables.visuals.crosshair.text_alpha_2 > min then 
                                vandal.variables.visuals.crosshair.text_alpha_2 = vandal.variables.visuals.crosshair.text_alpha_2 - step
                            end 

                            if vandal.variables.visuals.crosshair.text_alpha < max then   
                                vandal.variables.visuals.crosshair.text_alpha = vandal.variables.visuals.crosshair.text_alpha + step
                            end 

                            if vandal.variables.visuals.crosshair.text_alpha_2 <= min and vandal.variables.visuals.crosshair.text_alpha >= max then 
                                vandal.variables.visuals.crosshair.step = 3
                            end 
                        else
                            if vandal.variables.visuals.crosshair.text_alpha > min then 
                                vandal.variables.visuals.crosshair.text_alpha = vandal.variables.visuals.crosshair.text_alpha - step
                            end 

                            if vandal.variables.visuals.crosshair.text_alpha <= min then 
                                vandal.variables.visuals.crosshair.step = 1
                            end 
                        end 

                        return {r = main_r, g = main_g, b = main_b, a = vandal.variables.visuals.crosshair.text_alpha, r2 = main_r, g2 = main_g, b2 = main_b, a2 = vandal.variables.visuals.crosshair.text_alpha_2}
                    end,

                    is_active = function()
                        return true
                    end,

                    is_a_gradient = true 
                },

                {
                    text = " "..ui.get(vandal.menu.visuals.custom_text_2).."",

                    get_color = function()
                        return {r = sec_r, g = sec_g, b = sec_b, a = vandal.variables.visuals.crosshair.text_alpha_2, r2 = sec_r, g2 = sec_g, b2 = sec_b, a2 = vandal.variables.visuals.crosshair.text_alpha}
                    end,

                    is_active = function()
                        return true
                    end,

                    is_a_gradient = true 
                },

                {
                    text = "A: "..vandal.variables.visuals.generation.damage.."DMG",

                    get_color = function()
                        return {r = 255, g = 255, b = 255, a = vandal.variables.visuals.generation.damage > 0 and 255 or 75}
                    end, 

                    is_active = function() 
                        return true
                    end 
                },

                {
                    text = "BT: "..vandal.variables.visuals.generation.backtrack.."T",

                    get_color = function()
                        return {r = 255, g = 255, b = 255, a = vandal.variables.visuals.generation.backtrack > 0 and 255 or 75}
                    end,

                    is_active = function()
                        return true 
                    end 
                },

                {
                    text = ui.get(vandal.variables.references.keybinds.items.double_tap[2]) and "DT" or ui.get(vandal.variables.references.keybinds.items.hide_shots[2]) and "OS",

                    get_color = function()
                        return {r = 255, g = 255, b = 255, a = 255}
                    end, 

                    is_active = function()
                        return ui.get(vandal.variables.references.keybinds.items.double_tap[2]) or ui.get(vandal.variables.references.keybinds.items.hide_shots[2])
                    end 
                },

                {
                    text = "DMG",

                    get_color = function()
                        return {r = 255, g = 255, b = 255, a = 255}
                    end, 

                    is_active = function() 
                        return ui.get(vandal.variables.references.keybinds.items.minumum_damage_override[2])
                    end 
                },

                {
                    text = "BAIM",

                    get_color = function()
                        return {r = 255, g = 255, b = 255, a = 255}
                    end, 

                    is_active = function() 
                        return ui.get(vandal.variables.references.keybinds.items.force_body) 
                    end 
                }
            }

            local width, max_width, height = 0, renderer.measure_text("-", ui.get(vandal.menu.visuals.custom_text)) + renderer.measure_text("-", " "..ui.get(vandal.menu.visuals.custom_text_2)..""), 0
            for i=1, #stuff do
                local v = stuff[i]

                if v.is_active() then 
                    local clr = v.get_color()

                    if v.is_a_gradient then 
                        vandal.utils.gradient_text(v.text, w / 2 + width, h / 2 + 19 + height, clr.r, clr.g, clr.b, clr.a, clr.r2, clr.g2, clr.b2, clr.a2)
                    else 
                        renderer.text(w / 2 + width, h / 2 + 19 + height, clr.r, clr.g, clr.b, clr.a, "-", 0, v.text)
                    end    

                    if width > max_width - renderer.measure_text("-", v.text) then 
                        width = 0 
                        height = height + 8
                    else 
                        width = width + (renderer.measure_text("-", v.text) + 2)
                    end 
                end 
            end 
        end 
    
        if vandal.utils.table_contains(ui.get(vandal.menu.visuals.elements), "arrows") then 
            local spready_offset = ui.get(vandal.menu.visuals.spready_arrows) and 20 * (math.abs(vandal.liblaries.vector(entity.get_prop(entity.get_local_player(), "m_vecVelocity")):length2d()) / 320) or 0
            local arrows_offset = ui.get(vandal.menu.visuals.arrows_offset)

            spready_offset = ui.get(vandal.menu.visuals.arrows_offset) >= 0 and -spready_offset or spready_offset

            if vandal.utils.get_side() == -1 then 
                renderer.line(w / 2 - 33 - arrows_offset + spready_offset, h / 2 - 10, w / 2 - 33 - arrows_offset + spready_offset, h / 2 + 10, sec_r, sec_g, sec_b, sec_a)
                renderer.line(w / 2 + 33 + arrows_offset - spready_offset, h / 2 - 10, w / 2 + 33 + arrows_offset - spready_offset, h / 2 + 10, 25, 25, 25, 125)
            else 
                renderer.line(w / 2 + 33 + arrows_offset - spready_offset, h / 2 - 10, w / 2 + 33 + arrows_offset - spready_offset, h / 2 + 10, sec_r, sec_g, sec_b, sec_a)
                renderer.line(w / 2 - 33 - arrows_offset + spready_offset, h / 2 - 10, w / 2 - 33 - arrows_offset + spready_offset, h / 2 + 10, 25, 25, 25, 125)
            end 
            
            if vandal.utils.get_manual_yaw() == -90 then 
                renderer.triangle(w / 2 - 35 - arrows_offset + spready_offset, h / 2 - 10, w / 2 - 35 - arrows_offset + spready_offset, h / 2 + 10, w / 2 - 50 - arrows_offset + spready_offset, h / 2, main_r, main_g, main_b, main_a)
                renderer.triangle(w / 2 + 35 + arrows_offset - spready_offset, h / 2 - 10, w / 2 + 35 + arrows_offset - spready_offset, h / 2 + 10, w / 2 + 50 + arrows_offset - spready_offset, h / 2, 25, 25, 25, 125)
            elseif vandal.utils.get_manual_yaw() == 90 then 
                renderer.triangle(w / 2 - 35 - arrows_offset + spready_offset, h / 2 - 10, w / 2 - 35 - arrows_offset + spready_offset, h / 2 + 10, w / 2 - 50 - arrows_offset + spready_offset, h / 2, 25, 25, 25, 125)
                renderer.triangle(w / 2 + 35 + arrows_offset - spready_offset, h / 2 - 10, w / 2 + 35 + arrows_offset - spready_offset, h / 2 + 10, w / 2 + 50 + arrows_offset - spready_offset, h / 2, main_r, main_g, main_b, main_a)
            else 
                renderer.triangle(w / 2 - 35 - arrows_offset + spready_offset, h / 2 - 10, w / 2 - 35 - arrows_offset + spready_offset, h / 2 + 10, w / 2 - 50 - arrows_offset + spready_offset, h / 2, 25, 25, 25, 125)
                renderer.triangle(w / 2 + 35 + arrows_offset - spready_offset, h / 2 - 10, w / 2 + 35 + arrows_offset - spready_offset, h / 2 + 10, w / 2 + 50 + arrows_offset - spready_offset, h / 2, 25, 25, 25, 125)
            end 
        end 

        if vandal.utils.table_contains(ui.get(vandal.menu.visuals.elements), "watermark") then 
            local width = renderer.measure_text("-", "VANDAL | "..string.upper(vandal.variables.visuals.user.build).."")

            if client.key_state(0x01) and ui.is_menu_open() then 
                local x, y = ui.mouse_position()

                if vandal.variables.visuals.watermark.width + (width) >= x and vandal.variables.visuals.watermark.width - (width) <= x
                    and vandal.variables.visuals.watermark.height + 20 >= y and vandal.variables.visuals.watermark.height - 10 <= y then 

                    vandal.variables.visuals.watermark.width = x 
                    vandal.variables.visuals.watermark.height = y
                end 

                renderer.line(vandal.variables.visuals.watermark.width + (width / 2), vandal.variables.visuals.watermark.height - 10, vandal.variables.visuals.watermark.width + (width / 2), vandal.variables.visuals.watermark.height, 255, 255, 255, 255)
                renderer.line(vandal.variables.visuals.watermark.width + (width / 2), vandal.variables.visuals.watermark.height + 20, vandal.variables.visuals.watermark.width + (width / 2), vandal.variables.visuals.watermark.height + 10, 255, 255, 255, 255)
                renderer.line(vandal.variables.visuals.watermark.width + width + 5, vandal.variables.visuals.watermark.height + 5, vandal.variables.visuals.watermark.width + width + 15, vandal.variables.visuals.watermark.height + 5, 255, 255, 255, 255)
                renderer.line(vandal.variables.visuals.watermark.width - 3, vandal.variables.visuals.watermark.height + 5, vandal.variables.visuals.watermark.width - 13, vandal.variables.visuals.watermark.height + 5, 255, 255, 255, 255)
            end 

            vandal.utils.gradient_text("VANDAL | "..string.upper(vandal.variables.visuals.user.build).."", vandal.variables.visuals.watermark.width, vandal.variables.visuals.watermark.height, main_r, main_g, main_b, 255, sec_r, sec_g, sec_b, 255)
        end 
    end
end 

local function notifications_handler()
    local w, h = client.screen_size()
    local main_r, main_g, main_b, main_a = ui.get(vandal.menu.visuals.primary_color)
    local sec_r, sec_g, sec_b, sec_a = ui.get(vandal.menu.visuals.secondary_color)

    if vandal.utils.table_contains(ui.get(vandal.menu.visuals.elements), "notifications") then 
        for i=1, #vandal.variables.visuals.notifications do 
            if not vandal.variables.visuals.notifications[i] then return end 

            local delta = globals.realtime() - vandal.variables.visuals.notifications[i].start
            local offset = ((i - 1) * 35 - 100) + (60 * vandal.variables.visuals.notifications[i].progress)

            if delta < 2.0 and vandal.variables.visuals.notifications[i].alpha < 255 then 
                vandal.variables.visuals.notifications[i].alpha = vandal.variables.visuals.notifications[i].alpha + 2.5
            end 

            if delta > 4.0 and vandal.variables.visuals.notifications[i].alpha > 0 then 
                vandal.variables.visuals.notifications[i].alpha = vandal.variables.visuals.notifications[i].alpha - 2.5
            end 

            if vandal.variables.visuals.notifications[i].progress < 0.80 then 
                vandal.variables.visuals.notifications[i].progress = vandal.variables.visuals.notifications[i].progress + 0.02
            elseif vandal.variables.visuals.notifications[i].progress < 1.00 then 
                vandal.variables.visuals.notifications[i].progress = vandal.variables.visuals.notifications[i].progress + 0.005
            end 

            local size = 5 + renderer.measure_text("", "vandal") + 1 + renderer.measure_text("", ".tech") + 11 + renderer.measure_text("", vandal.variables.visuals.notifications[i].text)

            renderer.rectangle(w / 2 - size / 2, h - 100 - offset, size, 25, 0, 0, 0, vandal.variables.visuals.notifications[i].alpha)
            renderer.rectangle(w / 2 - size / 2 - 5, h - 95 - offset, size + 10, 15, 0, 0, 0, vandal.variables.visuals.notifications[i].alpha)
        
            for i2=1, ui.get(vandal.menu.visuals.glow_amount) do 
                i2 = i2 - 2

                renderer.circle(w / 2 - size / 2, h - 80 - offset, 0, 0, 0, vandal.variables.visuals.notifications[i].alpha, 5, 270, 0.25)
                renderer.circle_outline(w / 2 - size / 2, h - 80 - offset, main_r, main_g, main_b, vandal.variables.visuals.notifications[i].alpha / i2, 5 + i2, 90, 0.25, 1) 
            
                renderer.circle(w / 2 - size / 2, h - 95 - offset, 0, 0, 0, vandal.variables.visuals.notifications[i].alpha, 5, 180, 0.25)
                renderer.circle_outline(w / 2 - size / 2, h - 95- offset, sec_r, sec_g, sec_b, vandal.variables.visuals.notifications[i].alpha / i2, 5 + i2, 180, 0.25, 1)
            
                renderer.circle(w / 2 + size / 2, h - 80 - offset, 0, 0, 0, vandal.variables.visuals.notifications[i].alpha, 5, 0, 0.25)
                renderer.circle_outline(w / 2 + size / 2, h - 80 - offset, sec_r, sec_g, sec_b, vandal.variables.visuals.notifications[i].alpha / i2, 5 + i2, 0, 0.25, 1)
            
                renderer.circle(w / 2 + size / 2, h - 95 - offset, 0, 0, 0, vandal.variables.visuals.notifications[i].alpha, 5, 90, 0.25)
                renderer.circle_outline(w / 2 + size / 2, h - 95 - offset, main_r, main_g, main_b, vandal.variables.visuals.notifications[i].alpha / i2, 5 + i2, 270, 0.25, 1) 
            
                renderer.gradient(w / 2 - size / 2, h - 100 - offset - i2, size * vandal.variables.visuals.notifications[i].progress, 1, sec_r, sec_g, sec_b, vandal.variables.visuals.notifications[i].alpha / i2, main_a, main_g, main_b, vandal.variables.visuals.notifications[i].alpha / i2, true)
                renderer.gradient(w / 2 - size / 2, h - 76 - offset + i2, size * vandal.variables.visuals.notifications[i].progress, 1, main_a, main_g, main_b, vandal.variables.visuals.notifications[i].alpha / i2, sec_r, sec_g, sec_b, vandal.variables.visuals.notifications[i].alpha / i2, true)
            
                renderer.gradient(w / 2 - size / 2 - 5 - i2, h - 95 - offset, 1, 15 * vandal.variables.visuals.notifications[i].progress, sec_r, sec_g, sec_b, vandal.variables.visuals.notifications[i].alpha / i2, main_a, main_g, main_b, vandal.variables.visuals.notifications[i].alpha / i2, false)
                renderer.gradient(w / 2 + size / 2 + 4 + i2, h - 95 - offset, 1, 15 * vandal.variables.visuals.notifications[i].progress, main_a, main_g, main_b, vandal.variables.visuals.notifications[i].alpha / i2, sec_r, sec_g, sec_b, vandal.variables.visuals.notifications[i].alpha / i2, false)
            end 
        
            renderer.text(w / 2 - size / 2 + 2, h - 93 - offset, 255, 255, 255, vandal.variables.visuals.notifications[i].alpha, "", 0, "\a"..vandal.utils.rgba_to_hex(main_r, main_g, main_b, vandal.variables.visuals.notifications[i].alpha).."vandal\a"..vandal.utils.rgba_to_hex(sec_r, sec_g, sec_b, vandal.variables.visuals.notifications[i].alpha)..".tech\a"..vandal.utils.rgba_to_hex(200, 200, 200, vandal.variables.visuals.notifications[i].alpha).." - "..vandal.variables.visuals.notifications[i].text.."")

            if delta > 2.0 and vandal.variables.visuals.notifications[i].alpha <= 0 then 
                table.remove(vandal.variables.visuals.notifications, i)
            end 
        end 
    end 
end 

local function animbreaker_handler()
    if not entity.is_alive(entity.get_local_player()) then return end 

    local localplayer = vandal.liblaries.entity.new(entity.get_local_player())
    if not localplayer then return end 

    if vandal.utils.table_contains(ui.get(vandal.menu.misc.animbreakers), "legbreaker") then 
        ui.set(vandal.variables.references.other.items.leg_movement, ui.get(vandal.variables.references.other.items.leg_movement) == "Always slide" and "Off" or "Always slide")

        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", globals.tickcount() % 2 == 1 and 25 or 1, globals.tickcount() % 2 == 1 and 0 or 1)
    end 

    if vandal.utils.table_contains(ui.get(vandal.menu.misc.animbreakers), "static legs in air") then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
    end 

    if vandal.utils.table_contains(ui.get(vandal.menu.misc.animbreakers), "moonwalk in air") and (vandal.state.get(entity.get_local_player()) == 4 or vandal.state.get(entity.get_local_player()) == 8) then 
        localplayer:get_anim_overlay(6).weight = 1.0
    end 

    if vandal.utils.table_contains(ui.get(vandal.menu.misc.animbreakers), "body lean") then 
        localplayer:get_anim_overlay(12).weight = 1.0
    end 
end 

local function defensive_handler(cmd)
    vandal.variables.anti_aim.generation.data[globals.tickcount()] = {
        head_pos = vandal.liblaries.vector(entity.hitbox_position(entity.get_local_player(), 0)),
        origin = vandal.liblaries.vector(entity.get_origin(entity.get_local_player())),
        simtime = entity.get_prop(entity.get_local_player(), "m_flSimulationTime"),
        yaw = vandal.liblaries.antiaim.get_body_yaw(1)
    }

    vandal.variables.anti_aim.generation.yaw = vandal.liblaries.antiaim.get_body_yaw(1) -- vandal.liblaries.antiaim.get_body_yaw(2)

    if cmd.in_attack == 1 then vandal.variables.anti_aim.defensive.ticks_left = 0 return end 

    cmd.force_defensive = true 

    if client.current_threat() and vandal.generation.get_backtrack_ticks(client.current_threat()) > 12 and ui.get(vandal.variables.references.keybinds.items.double_tap[2]) then 
        -- cmd.no_choke = true  
        cmd.quick_stop = true
    end 
end

local function defensive_variables_handler()
    if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then return end

    local simtime = entity.get_prop(entity.get_local_player(), "m_flSimulationTime")

    vandal.variables.anti_aim.defensive.ticks_left = vandal.utils.time_to_ticks(math.abs(simtime - vandal.variables.anti_aim.defensive.last_simtime) - client.latency())

    if vandal.variables.anti_aim.defensive.last_simtime ~= simtime then 
        vandal.variables.anti_aim.defensive.last_simtime = simtime
    end 
end

local function anti_aim_manuals_handler()
    if ui.get(vandal.menu.misc.manual_forward) ~= vandal.variables.anti_aim.manuals.cache.forward then
        vandal.variables.anti_aim.manuals.cache.forward = ui.get(vandal.menu.misc.manual_forward)

        vandal.variables.anti_aim.manuals.forward = ui.get(vandal.menu.misc.manual_forward)
        vandal.variables.anti_aim.manuals.left = false 
        vandal.variables.anti_aim.manuals.right = false 

        ui.set(vandal.menu.misc.manual_left, false)
        ui.set(vandal.menu.misc.manual_right, false)
    end 

    if ui.get(vandal.menu.misc.manual_left) ~= vandal.variables.anti_aim.manuals.cache.left then
        vandal.variables.anti_aim.manuals.cache.left = ui.get(vandal.menu.misc.manual_left)

        vandal.variables.anti_aim.manuals.forward = false 
        vandal.variables.anti_aim.manuals.left = ui.get(vandal.menu.misc.manual_left)
        vandal.variables.anti_aim.manuals.right = false 

        ui.set(vandal.menu.misc.manual_forward, false)
        ui.set(vandal.menu.misc.manual_right, false)
    end 

    if ui.get(vandal.menu.misc.manual_right) ~= vandal.variables.anti_aim.manuals.cache.right then 
        vandal.variables.anti_aim.manuals.cache.right = ui.get(vandal.menu.misc.manual_right)
       
        vandal.variables.anti_aim.manuals.forward = false 
        vandal.variables.anti_aim.manuals.left = false
        vandal.variables.anti_aim.manuals.right = ui.get(vandal.menu.misc.manual_right)

        ui.set(vandal.menu.misc.manual_forward, false)
        ui.set(vandal.menu.misc.manual_left, false)
    end 
end 

local function shutdown()
    for i, v in pairs(vandal.variables.references) do 
        if type(v) == "table" then 
            for i2, v2 in pairs(v) do 
                if type(v2) == "table" then 
                    for i3, v3 in pairs(v2) do 
                        if not type(v3) == "table" then 
                            ui.set_visible(v3, true)
                        end 
                    end 
                else 
                    ui.set_visible(v2, true)
                end 
            end 
        else 
            ui.set_visible(v, true)
        end 
    end 
end 

local done = false 
local function resolver_handler()
    local enemies = entity.get_players(true)

    for i=1, #enemies do 
        local enemy = enemies[i]

        if not vandal.resolver.data[enemy] then 
            vandal.resolver.data[enemy] = {
                misses = 0,

                playback = {
                    left = 5,
                    right = 6
                },

                lby = {
                    next_update = globals.tickinterval() * entity.get_prop(enemy, "m_nTickBase")
                },

                yaw = {
                    last_yaw = 0,
                    delta = 0,
                    last_change = globals.curtime()
                }
            }
        end 

        if ui.get(vandal.menu.misc.resolver_enabled) then 
            plist.set(enemy, "Correction active", false)
            plist.set(enemy, "Force body yaw", false)

            local player = vandal.liblaries.entity.new(enemy)
            if not player then return end 

            local animstate = player:get_anim_state()
            local animlayer = player:get_anim_overlay(6)

            local max_speed = 260
            if entity.get_player_weapon(enemy) then 
                max_speed = math.max(vandal.liblaries.weapons(entity.get_player_weapon(enemy)).max_player_speed, 0.001)
            end 

            local running_speed = math.max(vandal.liblaries.vector(entity.get_prop(player, "m_vecVelocity")):length2d(), 260) / (max_speed * 0.520)
            local ducking_speed = math.max(vandal.liblaries.vector(entity.get_prop(player, "m_vecVelocity")):length2d(), 260) / (max_speed * 0.340)

            local server_time = vandal.utils.ticks_to_time(entity.get_prop(enemy, "m_nTickBase"))
            local yaw = animstate.goal_feet_yaw

            local eye_feet_delta = animstate.eye_angles_y - animstate.goal_feet_yaw

            local yaw_modifier = ((((animstate.stop_to_full_running_fraction * -0.3) - 0.2) * vandal.utils.clamp(running_speed, 0, 1)) + 1)
            if animstate.duck_amount > 0 then 
                yaw_modifier = yaw_modifier + (animstate.duck_amount * (vandal.utils.clamp(ducking_speed, 0, 1)) * (0.5 - yaw_modifier))
            end 

            local max_yaw_modifier = yaw_modifier * animstate.max_yaw
            local min_yaw_modifier = yaw_modifier * animstate.min_yaw

            if eye_feet_delta <= max_yaw_modifier then 
                if min_yaw_modifier > eye_feet_delta then 
                    yaw = math.abs(min_yaw_modifier) + animstate.eye_angles_y
                end 
            else 
                yaw = animstate.eye_angles_y - math.abs(max_yaw_modifier)
            end 

            if vandal.liblaries.vector(entity.get_prop(player, "m_vecVelocity")):length2d() > 0.01 or math.abs(vandal.liblaries.vector(entity.get_prop(player, "m_vecVelocity")).z) > 100 then 
                yaw = vandal.resolver.helpers.approach_angle(animstate.eye_angles_y, yaw, ((animstate.stop_to_full_running_fraction * 20) + 30) * animstate.last_client_side_animation_update_time)
            else 
                yaw = vandal.resolver.helpers.approach_angle(entity.get_prop(enemy, "m_flLowerBodyYawTarget"), yaw, animstate.last_client_side_animation_update_time * 100)
            end 

            local desync = animstate.goal_feet_yaw - yaw  
            local eye_goalfeet_delta = vandal.resolver.helpers.angle_diff(animstate.eye_angles_y - yaw, 360)

            if eye_goalfeet_delta < 0.0 or animstate.max_yaw == 0.0 then 
                if animstate.min_yaw ~= 0.0 then 
                    desync = ((eye_goalfeet_delta / animstate.min_yaw) * 360) * -58
                end 
            else 
                desync = ((eye_goalfeet_delta / animstate.max_yaw) * 360) * 58
            end 

            if server_time >= vandal.resolver.data[enemy].lby.next_update then 
                desync = 120 / 58 -- lby breaker fix
            end 

            local delta = desync - vandal.resolver.data[enemy].yaw.last_yaw
            local time_delta = entity.get_prop(enemy, "m_flSimulationTime") - vandal.resolver.data[enemy].yaw.last_change
            local modifier = time_delta / vandal.resolver.data[enemy].yaw.delta

            desync = (desync * 58) + (delta * modifier)
            desync = desync * vandal.resolver.helpers.process_side(enemy, vandal.resolver.helpers.get_side(enemy, animlayer))

            plist.set(enemy, "Force body yaw", true)
            plist.set(enemy, "Force body yaw value", desync) 
            plist.set(enemy, "High priority", math.floor(time_delta) ~= 0) -- prevent missing LC

            if animstate.eye_timer ~= 0 then 
                if animstate.m_velocity > 0.1 then 
                    vandal.resolver.data[enemy].lby.next_update = server_time + 0.22
                end 

                if math.abs((animstate.goal_feet_yaw - animstate.eye_angles_y) / 360) > 35 and server_time > vandal.resolver.data[enemy].lby.next_update then 
                    vandal.resolver.data[enemy].lby.next_update = server_time + 1.1
                end 
            end 

            if vandal.resolver.data[enemy].yaw.last_yaw ~= desync then 
                vandal.resolver.data[enemy].yaw.last_yaw = desync
            end 

            if delta ~= 0 then 
                if vandal.resolver.data[enemy].yaw.delta ~= delta then 
                    vandal.resolver.data[enemy].yaw.last_change = entity.get_prop(enemy, "m_flSimulationTime")
                    vandal.resolver.data[enemy].yaw.delta = delta 
                end 
            end 

            done = false 
        else 
            if not done then 
                plist.set(enemy, "Correction active", true)
                plist.set(enemy, "Force body yaw", false)

                done = true 
            end 
        end 
    end 
end 

local function resolver_on_miss(event)
    if not ui.get(vandal.menu.misc.resolver_enabled) or event.reason == "spread" or event.reason == "death" or event.reason == "unregistered shot" then return end 

    vandal.resolver.data[event.target].misses = vandal.resolver.data[event.target].misses and vandal.resolver.data[event.target].misses + 1 or 1

    local player = vandal.liblaries.entity.new(event.target)
    if not player then return end 

    local animlayer = player:get_anim_overlay(6)

    local left, right = vandal.resolver.data[event.target].playback.left, vandal.resolver.data[event.target].playback.right
    local side = vandal.resolver.helpers.process_side(event.target, vandal.resolver.helpers.get_side(event.target, animlayer))

    if side == -1 then 
        left = animlayer.playback_rate
    elseif side == 1 then 
        right = animlayer.playback_rate
    end 

    vandal.resolver.data[event.target].playback = {
        left = left,
        right = right
    }

    client.log("[vandal resolver] detected miss at "..entity.get_player_name(event.target).." | desync: "..plist.get(event.target, "Force body yaw value").."")
end 

client.set_event_callback("aim_miss", function(event)
    resolver_on_miss(event)
end)

client.set_event_callback("bullet_impact", function(event)
    anti_bruteforce_handler(event)
end)

client.set_event_callback("paint_ui", function()
    menu_handler()
    notifications_handler()

    process_settings()
end)

client.set_event_callback("paint", function()
    anti_aim_handler()
    anti_aim_manuals_handler()

    indicators_handler()
    resolver_handler()
end)

client.set_event_callback("net_update_start", function()
    defensive_variables_handler()
end)

client.set_event_callback("pre_render", function()
    animbreaker_handler()
end)

client.set_event_callback("setup_command", function(cmd)
    defensive_handler(cmd)
end)

client.set_event_callback("shutdown", function()
    shutdown()
end)