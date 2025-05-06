local steamname = panorama.open("CSGOHud").MyPersonaAPI.GetName()
local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI = js.MyPersonaAPI, js.LobbyAPI, js.PartyListAPI, js.SteamOverlayAPI



local symmetria = {
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
			enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
			yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
			fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
			edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
			fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
			forcebaim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
			safepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
			roll = { ui.reference('AA', 'Anti-aimbot angles', 'Roll') },
			clantag = ui.reference('Misc', 'Miscellaneous', 'Clan tag spammer'),

			fakelag_amount = ui.reference('AA', 'Fake lag', 'Amount'),
			fakelag_enable = ui.reference('AA', 'Fake lag', 'Enabled'),
			fakelag_limit = ui.reference('AA', 'Fake lag', 'Limit'),
			fakelag_variance = ui.reference('AA', 'Fake lag', 'Variance'),

			other_slowmotion = ui.reference('AA', 'Other', 'Slow motion'),
			other_legmovement = ui.reference('AA', 'Other', 'Leg movement'),
			other_osaa = ui.reference('AA', 'Other', '\n'),
			other_fkpeek = ui.reference('AA', 'Other', 'Fake peek'),


			pitch = { ui.reference('AA', 'Anti-aimbot angles', 'pitch'), },
			rage = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
			yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
			yawjitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
			bodyyaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
			freestand = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
			slow = { ui.reference('AA', 'Other', 'Slow motion') },
			os = { ui.reference('AA', 'Other', 'On shot anti-aim') },
			slow = { ui.reference('AA', 'Other', 'Slow motion') },
			dt = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
			minimum_damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") }
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
                build = "",
                discord = ""
            },

            crosshair = {
                text_alpha = 255,
                text_alpha_2 = 155,  
                step = 1 
            },

            watermark = {},

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
            var = json.parse(database.read("symmetria-settings") or "{}"),
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
        enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "\affc0cbFF⋆*･ﾟ:⋆*･ﾟ \aFFFFFFFFsymmetria \affc0cbFFﾟ･*⋆:ﾟ･*⋆"),
        tab = ui.new_combobox("AA", "Fake lag", "\affc0cbFFsymmetria\aFFFFFFFF ∼ \aFFFFFFFFtab", {"anti-aim", "visuals", "misc", "settings"}),
        tab2 = ui.new_combobox("AA", "Fake lag", "\affc0cbFFsymmetria\aFFFFFFFF ∼ \aFFFFFFFFhelpers", {"conditional", "helpers"}),


		lines1 = ui.new_label("AA", "Fake lag", "\a808080FF─────────────────────────────────"),
		loaded = ui.new_label("AA", "Fake lag", "\aFFFFFFFFUsername ∼ \aFFC0CBFF" .. steamname),
		playtime = ui.new_label("AA", "Fake lag", "\aFFFFFFFFBuild ∼ \aFFC0CBFFLocal"),
		invisible = ui.new_label("AA", "Fake lag", "\n"),
		buttonsd = ui.new_button("AA", "Fake lag", ("Local style: \aFFC0CBFFsymmetria"), function() SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/gloriosa") end),

        anti_aim = {},

        visuals = {
            elements = ui.new_multiselect("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ \aFFFFFFFFelements", {"crosshair", "watermark", "arrows"}),
            additional = ui.new_multiselect("AA", "Fake lag", "\affc0cbFFsymmetria\aFFFFFFFF ∼ \aFFFFFFFFadditional", {"aspect ratio", "viewmodel",  "third person", "custom hit chance"}),

            primary_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ primary \aFFFFFFFFcolor", 255, 195, 243, 255),
            secondary_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ secondary \aFFFFFFFFcolor", 255, 255, 255, 255),

            arrows_offset = ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ arrows \aFFFFFFFFoffset", -100, 20, 0, true, "px"),
            spready_arrows = ui.new_checkbox("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ spready \aFFFFFFFFarrows"),

            customize_text = ui.new_checkbox("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ custom crosshair \aFFFFFFFFtext"),
            custom_text = ui.new_textbox("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ custom crosshair \aFFFFFFFFtext"),
            custom_text_2 = ui.new_textbox("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ custom crosshair \aFFFFFFFFtext #2"),

            aspect_ratio_reference = ui.new_slider("AA", "Fake lag", "\affc0cbFFsymmetria\aFFFFFFFF ∼ force \aFFFFFFFFaspect ratio", 0, 200, 0, true, "%"),
            pust1 = ui.new_label("AA", "Fake lag", "\n"),
            tpdistanceslider = ui.new_slider("AA", "Fake lag", "\affc0cbFFsymmetria\aFFFFFFFF ∼ thirdperson distance", 30, 200, 150),

            xS = ui.new_slider("AA", "Other", "\affc0cbFFsymmetria\aFFFFFFFF ∼ viewmodel X", -20, 20, xO),
            yS = ui.new_slider("AA", "Other", "\affc0cbFFsymmetria\aFFFFFFFF ∼ viewmodel Y", -100, 100, yO),
            zS = ui.new_slider("AA", "Other", "\affc0cbFFsymmetria\aFFFFFFFF ∼ viewmodel Z", -20, 20, zO),
            vS = ui.new_slider("AA", "Other", "\affc0cbFFsymmetria\aFFFFFFFF ∼ viewmodel FOV", -60, 60, fO),


        },

        misc = {   
                
            manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ manual \aFFFFFFFFforward"),
            manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ manual \aFFFFFFFFleft"),
            manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ manual \aFFFFFFFFright"),
            freestanding = ui.new_hotkey("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ free\aFFFFFFFFstanding"),

            anti_backstab = ui.new_checkbox("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ anti \aFFFFFFFFbackstab"),
            freestanding_disablers = ui.new_multiselect("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ freestanding \aFFFFFFFFdisablers", {"in air", "crouch", "manuals"}),
            yaw_disablers = ui.new_multiselect("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ yaw \aFFFFFFFFdisablers", {"freestanding", "manuals", "knife in air"}),
            resolver_enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ resolver \aFFFFFFFFenabled")
        },

        misc1 = {
            exploit = ui.new_multiselect("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ \aFFFFFFFFexploit", {"double tap fixed", "animations", "challenge [dont missing :3]"}),
            recharge = ui.new_checkbox("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ recharge fix [double tap]"),
            animbreakers = ui.new_multiselect("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ animation \aFFFFFFFFbreakers", {"legbreaker", "static legs in air", "kinguru", "moonwalk in air", "body lean"}),

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



symmetria.resolver.helpers.refresh_data = function()
    symmetria.liblaries.http.get("https://symmetria.vip/data/resolver.txt", function(success, response)
        local s, e = pcall(function() json.parse(response.body) end)
        if not s then return false end 

        symmetria.resolver.data = json.parse(response.body)

        return true 
    end)
end

referencese = {
	enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
	yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
	fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
	edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
	fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
	forcebaim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
	safepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
	roll = { ui.reference('AA', 'Anti-aimbot angles', 'Roll') },
	clantag = ui.reference('Misc', 'Miscellaneous', 'Clan tag spammer'),

	fakelag_amount = ui.reference('AA', 'Fake lag', '\n'),
	fakelag_amount_hotkey = ui.reference('AA', 'Fake lag', 'Amount'),
	fakelag_enable = ui.reference('AA', 'Fake lag', 'Enabled'),
	fakelag_limit = ui.reference('AA', 'Fake lag', 'Limit'),
	fakelag_variance = ui.reference('AA', 'Fake lag', 'Variance'),



	pitch = { ui.reference('AA', 'Anti-aimbot angles', 'pitch'), },
	rage = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
	yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
	yawjitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
	bodyyaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
	freestand = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
	slow = { ui.reference('AA', 'Other', 'Slow motion') },
	os_r = { ui.reference('AA', 'Other', '\n\n\n\n\n') },
	os_h = ui.reference('AA', 'Other', 'Slow motion'),
    os_l = ui.reference('AA', 'Other', 'Leg movement'),
    os_os = ui.reference('AA', 'Other', 'On shot anti-aim'),
    os_fk = ui.reference('AA', 'Other', 'Fake peek'),
	dt = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
	minimum_damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") }
}

local function hide_original_menu(state)
	ui.set_visible(referencese.enabled, state)
	ui.set_visible(referencese.fakelag_amount, false)
	ui.set_visible(referencese.fakelag_amount_hotkey, false)
	ui.set_visible(referencese.fakelag_enable, false)
	ui.set_visible(referencese.fakelag_limit, false)
	ui.set_visible(referencese.fakelag_variance, false)
    ui.set_visible(referencese.os_h, false)
    ui.set_visible(referencese.os_l, false)
    ui.set_visible(referencese.os_os, false)
    ui.set_visible(referencese.os_fk, false)
	ui.set_visible(referencese.pitch[1], state)
	ui.set_visible(referencese.pitch[2], state)
	ui.set_visible(referencese.yawbase, state)
	ui.set_visible(referencese.yaw[1], state)
	ui.set_visible(referencese.yaw[2], state)
	ui.set_visible(referencese.yawjitter[1], state)
	ui.set_visible(referencese.roll[1], state)
	ui.set_visible(referencese.yawjitter[2], state)
	ui.set_visible(referencese.bodyyaw[1], state)
	ui.set_visible(referencese.bodyyaw[2], state)
	ui.set_visible(referencese.fsbodyyaw, state)
	ui.set_visible(referencese.edgeyaw, state)
	ui.set_visible(referencese.freestand[1], state)
	ui.set_visible(referencese.freestand[2], state)
end

local t = symmetria.resolver.helpers.refresh_data() and "" or symmetria.resolver.helpers.refresh_data()

symmetria.utils.gradient_text = function(text, w, h, r1, g1, b1, a1, r2, g2, b2, a2)
    local delta_r, delta_g, delta_b, delta_a, final_text, text_len = r1 - r2, g1 - g2, b1 - b2, a1 - a2, "", string.len(text)

    for i=1, text_len do 
        final_text = ""..final_text.."\a"..symmetria.utils.rgba_to_hex(r1 - (i * (delta_r / text_len)), g1 - (i * (delta_g / text_len)), b1 - (i * (delta_b / text_len)), a1 - (i * (delta_a / #text)))..""..text:sub(i, i)..""
    end 

    renderer.text(w, h, 255, 255, 255, 255, "-", 0, final_text)
end

symmetria.utils.get_side = function()
    return symmetria.utils.get_fake_amount() > 1 and -1 or 1 
end     

symmetria.utils.should_anti_knife = function()
    local enemies = entity.get_players(true)

    for i=1, #enemies do 
        local dist = symmetria.liblaries.vector(entity.get_origin(enemies[i])):dist2d(symmetria.liblaries.vector(entity.get_origin(entity.get_local_player())))

        if entity.get_classname(entity.get_player_weapon(enemies[i])) == "CKnife" and dist < 100 then 
            return true and ui.get(symmetria.menu.misc.anti_backstab)
        end 
    end 

    return false 
end 

symmetria.utils.get_manual_yaw = function()
    if symmetria.variables.anti_aim.manuals.forward then 
        return 180 
    elseif symmetria.variables.anti_aim.manuals.left then
        return -90
    elseif symmetria.variables.anti_aim.manuals.right then 
        return 90
    elseif symmetria.utils.should_anti_knife() then 
        return 180 
    end 

    return 0
end 


symmetria.math.calc_angle = function(src, dst)
    local delta = symmetria.liblaries.vector((src.x - dst.x), (src.y - dst.y), (src.z - dst.z))
    local hyp = math.sqrt(delta.x * delta.x + delta.y * delta.y)

    return symmetria.liblaries.vector(symmetria.math.pi * math.atan(delta.z / hyp), symmetria.math.pi * math.atan(delta.y / delta.x), 0)
end 

symmetria.state = {
    get = function(player)
        local data = {
            velocity = symmetria.liblaries.vector(entity.get_prop(player, "m_vecVelocity")):length2d(),
            is_in_air = bit.band(entity.get_prop(player, "m_fFlags"), 1) == 0,
            is_crouching = bit.band(entity.get_prop(player, "m_fFlags"), bit.lshift(1, 1)) ~= 0,
            is_slowwalking = ui.get(symmetria.variables.references.keybinds.items.slowwalk[2])
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

symmetria.utils.should_freestand = function()
    local boolean = symmetria.state.get(entity.get_local_player()) == 4 and symmetria.utils.table_contains(ui.get(symmetria.menu.misc.freestanding_disablers), "in air") 
            or symmetria.state.get(entity.get_local_player()) == 7 and symmetria.utils.table_contains(ui.get(symmetria.menu.misc.freestanding_disablers), "in air") 
            or symmetria.state.get(entity.get_local_player()) == 6 and symmetria.utils.table_contains(ui.get(symmetria.menu.misc.freestanding_disablers), "crouch")
            or symmetria.utils.get_manual_yaw() ~= 0 and symmetria.utils.table_contains(ui.get(symmetria.menu.misc.freestanding_disablers), "manuals")

    return not boolean
end 

symmetria.utils.should_jitter = function()
    local boolean = symmetria.utils.table_contains(ui.get(symmetria.menu.misc.yaw_disablers), "freestanding") and symmetria.utils.should_freestand() and ui.get(symmetria.menu.misc.freestanding)
            or symmetria.utils.table_contains(ui.get(symmetria.menu.misc.yaw_disablers), "manuals") and symmetria.utils.get_manual_yaw() ~= 0    
            or symmetria.utils.table_contains(ui.get(symmetria.menu.misc.yaw_disablers), "knife in air") and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CKnife" and symmetria.state.get(entity.get_local_player()) == 8

    return not boolean
end 

symmetria.resolver.helpers.angle_mod = function(angle)
    return ((360 / 65536) * (angle * (65536 / 360)))
end 

symmetria.resolver.helpers.approach_angle = function(target, value, speed)
    local adjusted_speed = speed
    if adjusted_speed < 0.0 then 
        adjusted_speed = adjusted_speed * -1
    end 

    local angle_mod_target = symmetria.resolver.helpers.angle_mod(target)
    local angle_mod_value = symmetria.resolver.helpers.angle_mod(value)

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

symmetria.utils.notify = function(string)
    local notifications = {}  -- Инициализируем локальную таблицу для уведомлений
    notifications[#notifications + 1] = {text = string, start = globals.realtime(), alpha = 0, progress = 0}
end 

symmetria.resolver.helpers.angle_diff = function(dest_angle, src_angle)
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

symmetria.resolver.helpers.get_side = function(player, animlayer)
    local left_best_delta, right_best_delta = 9999, 9999
    
    for i=1, #symmetria.resolver.data.side[1] do
        local left_delta = math.abs(animlayer.playback_rate - symmetria.resolver.data.side[1][i])

        if left_delta < left_best_delta then 
            left_best_delta = left_delta
        end 
    end

    for i=1, #symmetria.resolver.data.side[2] do
        local right_delta = math.abs(animlayer.playback_rate - symmetria.resolver.data.side[2][i])

        if right_delta < right_best_delta then 
            right_best_delta = right_delta
        end 
    end

    return left_best_delta < right_best_delta and -1 or 1
end

symmetria.resolver.helpers.process_side = function(player, side)
    if symmetria.resolver.data[player].misses then 
        if symmetria.resolver.data[player].misses % 2 == 1 then 
            side = side * -1
        end 
    end 
    
    return side 
end

symmetria.menu.state_selection = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFF\aFFFFFFFFstate", symmetria.variables.states)
for i=1, #symmetria.variables.states do 
    symmetria.menu.anti_aim[i] = {
        enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― \aFFFFFFFFenabled"),

        stuff = {
            pitch = ui.new_combobox("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― \aFFFFFFFFpitch", {"off", "default", "up", "down", "minimal", "random", "custom", "exploit"}),
            custom_pitch = ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― custom \aFFFFFFFFpitch", -89, 89, 0),
            
            yaw_base = ui.new_combobox("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― yaw \aFFFFFFFFbase", {"local view", "at targets"}),
            yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― yaw \aFFFFFFFFbase", {"off", "180", "spin", "static", "180 Z", "crosshair"}),
            yaw_amount_left = ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― yaw amount \aFFFFFFFFleft", -180, 180, 0),
            yaw_amount_right = ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― yaw amount \aFFFFFFFFright", -180, 180, 0),

            yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― yaw \aFFFFFFFFjitter", {"off", "offset", "center", "random", "skitter", "delayed"}),
            yaw_jitter_delay = ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― jitter \aFFFFFFFFdelay", 1, 64, 0),
            yaw_jitter_amount = ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― yaw \aFFFFFFFFjitter", -180, 180, 0),
            yaw_jitter_amount_2 = ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― yaw \aFFFFFFFFjitter #2", -180, 180, 0),

            body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― body \aFFFFFFFFyaw", {"off", "opposite", "jitter", "static"}),
            body_yaw_amount = ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― body \aFFFFFFFFyaw amount", -180, 180, 0),

            avoidness = ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― extra / ness", 0, 100, 20),

            anti_bruteforce_type = ui.new_combobox("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― anti-bruteforce \aFFFFFFFFtype", {"off", "generation", "jitter-generation", "custom"}),

            jitter_generation_limit = ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― generation angle \aFFFFFFFFlimit", 0, 180, 90),

            anti_bruteforce_phase = ui.new_combobox("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― anti-bruteforce \aFFFFFFFFphase", {"#1", "#2", "#3", "#4", "#5"}),

            anti_bruteforce = {
                ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― jitter value \aFFFFFFFF#1", -180, 180, 0),
                ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― jitter value \aFFFFFFFF#2", -180, 180, 0),
                ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― jitter value \aFFFFFFFF#3", -180, 180, 0),
                ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― jitter value \aFFFFFFFF#4", -180, 180, 0),
                ui.new_slider("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― jitter value \aFFFFFFFF#5", -180, 180, 0)
            },

            defensive_flicks = ui.new_combobox("AA", "Anti-aimbot angles", "\affc0cbFF"..symmetria.variables.states[i].." ― defensive flicks \aFFFFFFFFtype", {"off", "default type"})
        }
    }
end 

symmetria.utils.export_settings = function()
    local settings = {}
    
    for i=1, #symmetria.variables.states do 
        local state = symmetria.variables.states[i]

        settings[state] = {}

        for i2,v in pairs(symmetria.menu.anti_aim[i].stuff) do 
            settings[state][i2] = {}
            settings[state]["enabled"] = ui.get(symmetria.menu.anti_aim[i].enabled)

            if type(v) == "table" then 
                for i3, v2 in pairs(v) do 
                    settings[state][i2][i3] = ui.get(v2)
                end 
            else 
                settings[state][i2] = ui.get(v)
            end
        end 
    end 

    return symmetria.liblaries.base64.encode(json.stringify(settings))
end 

symmetria.utils.import_settings = function(setts)
    local settings = json.parse(symmetria.liblaries.base64.decode(setts))
    
    for i=1, #symmetria.variables.states do 
        local state = symmetria.variables.states[i]
    
        for i2,v in pairs(symmetria.menu.anti_aim[i].stuff) do 
            local s, e = pcall(function() ui.set(symmetria.menu.anti_aim[i].enabled, settings[state]["enabled"]) end)
    
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

symmetria.menu.settings = {
    selection = ui.new_listbox("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ settings \aFFFFFFFFselection", symmetria.variables.settings.names),
    other_save = ui.new_label("AA", "Other", "\affc0cbFF▪︎\aFFFFFFFF  create / save"),
    lines148 = ui.new_label("AA", "Other", "\a808080FF─────────────────────────────────"),
    name = ui.new_textbox("AA", "Other", "\affc0cbFFsymmetria\aFFFFFFFF ∼ settings \aFFFFFFFFname")
}

symmetria.utils.refresh_settings = function(write)
    symmetria.variables.settings.names = {}

    for i, v in pairs(symmetria.variables.settings.var) do 
        if v ~= nil then 
            symmetria.variables.settings.names[#symmetria.variables.settings.names + 1] = i 
        end 
    end

    ui.update(symmetria.menu.settings.selection, symmetria.variables.settings.names)

    if write then 
        database.write("symmetria-settings", json.stringify(symmetria.variables.settings.var))

        if ui.get(symmetria.menu.settings.selection) ~= nil then 
            local num = tonumber(ui.get(symmetria.menu.settings.selection)) + 1

            ui.set(symmetria.menu.settings.name, symmetria.variables.settings.names[num])
        end 
    end 
end 

symmetria.utils.refresh_settings(false)

symmetria.menu.settings.load_settings = ui.new_button("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ load \aFFFFFFFFsettings", function()
    local success, e = pcall(function() symmetria.utils.import_settings(symmetria.variables.settings.var[ui.get(symmetria.menu.settings.name)]) end)

    symmetria.utils.notify(success and "settings loaded successfully" or "failed to load settings")
end)

symmetria.menu.settings.save_settings = ui.new_button("AA", "Other", "\affc0cbFFsymmetria\aFFFFFFFF ∼ save \aFFFFFFFFsettings", function()
    symmetria.variables.settings.var[ui.get(symmetria.menu.settings.name)] = symmetria.utils.export_settings()

    symmetria.utils.notify("saved settings")

    symmetria.utils.refresh_settings(true)
end)

symmetria.menu.settings.delete_settings = ui.new_button("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ delete \aFFFFFFFFsettings", function()
    symmetria.variables.settings.var[ui.get(symmetria.menu.settings.name)] = nil 

    symmetria.utils.notify("deleted settings")

    symmetria.utils.refresh_settings(true)
end)

symmetria.menu.settings.reset_settings = ui.new_button("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ reset \aFFFFFFFFsettings", function()
    symmetria.variables.settings.var[ui.get(symmetria.menu.settings.name)] = "eyJtb3ZpbmciOnsieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXdfYW1vdW50IjowLCJwaXRjaCI6Im9mZiIsImF2b2lkbmVzcyI6MCwiYm9keV95YXciOiJvZmYiLCJhbnRpX2JydXRlZm9yY2VfcGhhc2UiOiIjMSIsInlhdyI6Im9mZiIsInlhd19hbW91bnQiOjAsImFudGlfYnJ1dGVmb3JjZV90eXBlIjoib2ZmIiwiaml0dGVyX2dlbmVyYXRpb25fbGltaXQiOjkwLCJleHRyYXBvbGF0aW9uIjowLCJ5YXdfaml0dGVyX2Ftb3VudCI6MCwieWF3X2ppdHRlciI6Im9mZiIsImVuYWJsZWQiOmZhbHNlLCJhbnRpX2JydXRlZm9yY2UiOlswLDAsMCwwLDBdLCJkZWZlbnNpdmVfZmxpY2tzIjoib2ZmIn0sImluIGFpciI6eyJ5YXdfYmFzZSI6ImxvY2FsIHZpZXciLCJib2R5X3lhd19hbW91bnQiOjAsInBpdGNoIjoib2ZmIiwiYXZvaWRuZXNzIjowLCJib2R5X3lhdyI6Im9mZiIsImFudGlfYnJ1dGVmb3JjZV9waGFzZSI6IiMxIiwieWF3Ijoib2ZmIiwieWF3X2Ftb3VudCI6MCwiYW50aV9icnV0ZWZvcmNlX3R5cGUiOiJvZmYiLCJqaXR0ZXJfZ2VuZXJhdGlvbl9saW1pdCI6OTAsImV4dHJhcG9sYXRpb24iOjAsInlhd19qaXR0ZXJfYW1vdW50IjowLCJ5YXdfaml0dGVyIjoib2ZmIiwiZW5hYmxlZCI6ZmFsc2UsImFudGlfYnJ1dGVmb3JjZSI6WzAsMCwwLDAsMF0sImRlZmVuc2l2ZV9mbGlja3MiOiJvZmYifSwic2xvd3dhbGtpbmciOnsieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXdfYW1vdW50IjowLCJwaXRjaCI6Im9mZiIsImF2b2lkbmVzcyI6MCwiYm9keV95YXciOiJvZmYiLCJhbnRpX2JydXRlZm9yY2VfcGhhc2UiOiIjMSIsInlhdyI6Im9mZiIsInlhd19hbW91bnQiOjAsImFudGlfYnJ1dGVmb3JjZV90eXBlIjoib2ZmIiwiaml0dGVyX2dlbmVyYXRpb25fbGltaXQiOjkwLCJleHRyYXBvbGF0aW9uIjowLCJ5YXdfaml0dGVyX2Ftb3VudCI6MCwieWF3X2ppdHRlciI6Im9mZiIsImVuYWJsZWQiOmZhbHNlLCJhbnRpX2JydXRlZm9yY2UiOlswLDAsMCwwLDBdLCJkZWZlbnNpdmVfZmxpY2tzIjoib2ZmIn0sImNyb3VjaCBpbiBhaXIiOnsieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXdfYW1vdW50IjowLCJwaXRjaCI6Im9mZiIsImF2b2lkbmVzcyI6MCwiYm9keV95YXciOiJvZmYiLCJhbnRpX2JydXRlZm9yY2VfcGhhc2UiOiIjMSIsInlhdyI6Im9mZiIsInlhd19hbW91bnQiOjAsImFudGlfYnJ1dGVmb3JjZV90eXBlIjoib2ZmIiwiaml0dGVyX2dlbmVyYXRpb25fbGltaXQiOjkwLCJleHRyYXBvbGF0aW9uIjowLCJ5YXdfaml0dGVyX2Ftb3VudCI6MCwieWF3X2ppdHRlciI6Im9mZiIsImVuYWJsZWQiOmZhbHNlLCJhbnRpX2JydXRlZm9yY2UiOlswLDAsMCwwLDBdLCJkZWZlbnNpdmVfZmxpY2tzIjoib2ZmIn0sImNyb3VjaGluZyI6eyJ5YXdfYmFzZSI6ImxvY2FsIHZpZXciLCJib2R5X3lhd19hbW91bnQiOjAsInBpdGNoIjoib2ZmIiwiYXZvaWRuZXNzIjowLCJib2R5X3lhdyI6Im9mZiIsImFudGlfYnJ1dGVmb3JjZV9waGFzZSI6IiMxIiwieWF3Ijoib2ZmIiwieWF3X2Ftb3VudCI6MCwiYW50aV9icnV0ZWZvcmNlX3R5cGUiOiJvZmYiLCJqaXR0ZXJfZ2VuZXJhdGlvbl9saW1pdCI6OTAsImV4dHJhcG9sYXRpb24iOjAsInlhd19qaXR0ZXJfYW1vdW50IjowLCJ5YXdfaml0dGVyIjoib2ZmIiwiZW5hYmxlZCI6ZmFsc2UsImFudGlfYnJ1dGVmb3JjZSI6WzAsMCwwLDAsMF0sImRlZmVuc2l2ZV9mbGlja3MiOiJvZmYifSwic3RhbmRpbmciOnsieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXdfYW1vdW50IjowLCJwaXRjaCI6Im9mZiIsImF2b2lkbmVzcyI6MCwiYm9keV95YXciOiJvZmYiLCJhbnRpX2JydXRlZm9yY2VfcGhhc2UiOiIjMSIsInlhdyI6Im9mZiIsInlhd19hbW91bnQiOjAsImFudGlfYnJ1dGVmb3JjZV90eXBlIjoib2ZmIiwiaml0dGVyX2dlbmVyYXRpb25fbGltaXQiOjkwLCJleHRyYXBvbGF0aW9uIjowLCJ5YXdfaml0dGVyX2Ftb3VudCI6MCwieWF3X2ppdHRlciI6Im9mZiIsImVuYWJsZWQiOmZhbHNlLCJhbnRpX2JydXRlZm9yY2UiOlswLDAsMCwwLDBdLCJkZWZlbnNpdmVfZmxpY2tzIjoib2ZmIn0sImRlZmF1bHQiOnsieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXdfYW1vdW50IjowLCJwaXRjaCI6Im9mZiIsImF2b2lkbmVzcyI6MCwiYm9keV95YXciOiJvZmYiLCJhbnRpX2JydXRlZm9yY2VfcGhhc2UiOiIjMSIsInlhdyI6Im9mZiIsInlhd19hbW91bnQiOjAsImFudGlfYnJ1dGVmb3JjZV90eXBlIjoib2ZmIiwiaml0dGVyX2dlbmVyYXRpb25fbGltaXQiOjkwLCJleHRyYXBvbGF0aW9uIjowLCJ5YXdfaml0dGVyX2Ftb3VudCI6MCwieWF3X2ppdHRlciI6Im9mZiIsImVuYWJsZWQiOnRydWUsImFudGlfYnJ1dGVmb3JjZSI6WzAsMCwwLDAsMF0sImRlZmVuc2l2ZV9mbGlja3MiOiJvZmYifX0="

    symmetria.utils.notify("resetted settings")

    symmetria.utils.refresh_settings(true)
end)

symmetria.menu.settings.export_settings = ui.new_button("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ export to \aFFFFFFFFclipboard", function()
    symmetria.liblaries.clipboard.set(symmetria.utils.export_settings())

    symmetria.utils.notify("exported settings")
end)

symmetria.menu.settings.import_settings = ui.new_button("AA", "Anti-aimbot angles", "\affc0cbFFsymmetria\aFFFFFFFF ∼ import from \aFFFFFFFFclipboard", function()
    local success, e = pcall(function() symmetria.utils.import_settings(symmetria.liblaries.clipboard.get()) end)
    
    symmetria.utils.notify(success and "settings imported successfully" or "failed to import settings")
end)

local function process_settings()
    if ui.get(symmetria.menu.settings.selection) ~= nil and symmetria.variables.settings.old_set ~= ui.get(symmetria.menu.settings.selection) then 
        local num = tonumber(ui.get(symmetria.menu.settings.selection)) + 1

        ui.set(symmetria.menu.settings.name, symmetria.variables.settings.names[num])

        symmetria.variables.settings.old_set = ui.get(symmetria.menu.settings.selection)
    end 
end 

symmetria.generation.get_lerp_time = function()
    local minupdate, maxupdate = cvar.sv_minupdaterate:get_float(), cvar.sv_maxupdaterate:get_float()
    local ratio = cvar.cl_interp_ratio:get_float() == 0.0 and 1.0 or cvar.cl_interp_ratio:get_float()
    local lerp = cvar.cl_interp:get_float()
    local cmin, cmax = cvar.sv_client_min_interp_ratio:get_float(), cvar.sv_client_max_interp_ratio:get_float()

    if cmin ~= 1 then 
        ratio = symmetria.utils.clamp(ratio, cmin, cmax)
    end 

    return math.max(lerp, ratio / maxupdate)
end 

symmetria.generation.get_backtrack_ticks = function(player)
    local net_channel = symmetria.liblaries.engineclient.get_net_channel_info()

    local sv_maxunlag = cvar.sv_maxunlag:get_float()
    local correct = symmetria.utils.clamp(symmetria.generation.get_lerp_time() + net_channel.avg_latency[0] + net_channel.avg_latency[1], 0, sv_maxunlag)

    local best_ticks, best_dmg = 0, 0
    for i=1, 64 do 
        if symmetria.variables.anti_aim.generation.data[globals.tickcount() - i] then 
            if math.abs(correct - (globals.curtime() - symmetria.variables.anti_aim.generation.data[globals.tickcount() - i].simtime)) < sv_maxunlag + net_channel.avg_latency[0] + net_channel.avg_latency[1] then 
                local head_pos = symmetria.variables.anti_aim.generation.data[globals.tickcount() - i].head_pos
                local enemy_head_pos = symmetria.liblaries.vector(entity.hitbox_position(player, 0))

                local ent, dmg = client.trace_bullet(player, enemy_head_pos.x, enemy_head_pos.y, enemy_head_pos.z, head_pos.x, head_pos.y, head_pos.z, player)

                if dmg >= best_dmg then 
                    best_ticks = i 
                    best_dmg = dmg
                end 
            end 
        end 
    end 

    symmetria.variables.visuals.generation.backtrack = best_ticks

    return best_ticks
end 

symmetria.generation.calculate_damage = function(player, angle)
    local net_channel = symmetria.liblaries.engineclient.get_net_channel_info()
    local head_pos = symmetria.liblaries.vector(entity.hitbox_position(entity.get_local_player(), 0))
    local enemy_head_pos = symmetria.liblaries.vector(entity.hitbox_position(player, 0))
    local origin = symmetria.liblaries.vector(entity.get_origin(entity.get_local_player()))

    local rad = origin:dist2d(head_pos)

    origin.z = head_pos.z 

    origin = origin - (symmetria.liblaries.vector(entity.get_prop(entity.get_local_player()), "m_vecVelocity") * symmetria.utils.time_to_ticks(net_channel.latency[0] + net_channel.latency[1]))

    local angles = symmetria.liblaries.vector():init_from_angles(0, angle + symmetria.variables.anti_aim.generation.yaw, 0) * rad

    local final_pos = origin + angles 

    local final_enemy_pos = enemy_head_pos + symmetria.math.calc_angle(enemy_head_pos, final_pos)
    local ent, damage = client.trace_bullet(player, final_enemy_pos.x, final_enemy_pos.y, final_enemy_pos.z, final_pos.x, final_pos.y, final_pos.z, player)

    -- local x, y = renderer.world_to_screen(final_pos.x, final_pos.y, final_pos.z)
    -- renderer.text(x, y, damage > 0 and 255 or 0, damage > 0 and 0 or 255, 0, 255, "-", 0, damage)

    symmetria.variables.visuals.generation.head_size_in_yaw = (4.2000004200000 * 4.5) / (symmetria.liblaries.vector():init_from_angles(0, 1, 0) * rad):length2d()

    return damage, final_pos
end

symmetria.generation.generate_angle = function(player, avoidness)
    if avoidness <= 10 then return 0 end 

    symmetria.variables.visuals.generation.dangerous = false 

    local lowest_dmg, best_angle, best_position = 9999, 0, symmetria.liblaries.vector(0, 0, 0)
    local percentage = (avoidness / 100) / 2
    local step = math.floor(10 * (avoidness / 100)) -- 20
    local range = 180 / step

    for i=-range, range do 
        local angle = i * range

        local damage, position = symmetria.generation.calculate_damage(player, angle, avoidness)
        
        if damage > 0 then symmetria.variables.visuals.generation.dangerous = true end 

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
            local damage, position = symmetria.generation.calculate_damage(player, i, avoidness)
            
            if damage > 0 then symmetria.variables.visuals.generation.dangerous = true end 

            if damage < lowest_dmg 
                or damage == lowest_dmg and best_angle > 0 and i < best_angle 
                or damage == lowest_dmg and best_angle < 0 and best_angle < i then 
            
                lowest_dmg = damage
                best_angle = i
                best_position = position
            end 
        end 
    end 

    symmetria.variables.visuals.generation.angle = math.floor(best_angle)
    symmetria.variables.visuals.generation.damage = math.floor(lowest_dmg)
    symmetria.variables.visuals.generation.best_position = best_position

    return symmetria.utils.normalize_yaw(math.floor(best_angle + (symmetria.variables.anti_aim.generation.head_size_in_yaw * best_angle)))
end 

symmetria.generation.generate_flick = function(player, avoidness)
    local best_dmg, best_angle = 0, 0
    local percentage = avoidness / 100

    for i=-180 * percentage, 180 * percentage do 
        local damage = symmetria.generation.calculate_damage(player, i, avoidness, 0)
    
        if damage > best_dmg then 
            best_dmg = damage
            best_angle = i
        end 
    end
    
    return symmetria.utils.normalize_yaw(math.floor(best_angle + (symmetria.variables.anti_aim.generation.head_size_in_yaw * best_angle)))
end 

symmetria.generation.generate_jitter = function(player, avoidness)
    local lowest_dmg, best_angle = 9999, 0
    local percentage = avoidness / 100

    for i=0, 180 * percentage do 
        local damage, damage2 = symmetria.generation.calculate_damage(player, i, avoidness), symmetria.generation.calculate_damage(player, -i, avoidness)

        damage = damage + damage2

        if damage < lowest_dmg 
            or damage == lowest_dmg and best_angle > 0 and i < best_angle 
            or damage == lowest_dmg and best_angle < 0 and best_angle < i then 
    
            lowest_dmg = damage
            best_angle = i
        end 
    end

    symmetria.variables.visuals.generation.damage = lowest_dmg
    
    return symmetria.utils.normalize_yaw(math.floor(best_angle + (symmetria.variables.anti_aim.generation.head_size_in_yaw * best_angle)))
end 

local function initialize_menu()
    ui.set(symmetria.menu.visuals.customize_text, false)
end 
initialize_menu()

local function menu_handler()
    local lua_enabled = ui.get(symmetria.menu.enabled)
    local lua_menu_enabled = not lua_enabled
    local lua_aa_enabled = lua_enabled and ui.get(symmetria.menu.tab2) == "conditional"
    local lua_conditional_enabled = lua_enabled and ui.get(symmetria.menu.tab) == "anti-aim"
    local lua_visuals_enabled = lua_enabled and ui.get(symmetria.menu.tab) == "visuals"
    local lua_angel_enabled = lua_enabled and ui.get(symmetria.menu.tab2) == "helpers"
    local lua_misc_enabled = lua_enabled and ui.get(symmetria.menu.tab) == "misc"
    local lua_helpers_enabled = lua_enabled and ui.get(symmetria.menu.tab) == "anti-aim"
    local lua_settings_enabled = lua_enabled and ui.get(symmetria.menu.tab) == "settings"

    for i, v in pairs(symmetria.variables.references) do 
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

    ui.set_visible(symmetria.menu.tab, lua_enabled)
	ui.set_visible(symmetria.menu.loaded, lua_enabled and lua_conditional_enabled)
    
	ui.set_visible(symmetria.menu.lines1, lua_enabled and lua_conditional_enabled)
	ui.set_visible(symmetria.menu.playtime, lua_enabled and lua_conditional_enabled)
	ui.set_visible(symmetria.menu.invisible, lua_enabled and lua_conditional_enabled)
	ui.set_visible(symmetria.menu.buttonsd, lua_enabled and lua_conditional_enabled)
    ui.set_visible(symmetria.menu.state_selection, lua_aa_enabled and lua_conditional_enabled)
    ui.set_visible(symmetria.menu.tab2, lua_conditional_enabled)
    ui.set_visible(symmetria.menu.misc1.animbreakers, lua_misc_enabled)
    ui.set_visible(symmetria.menu.misc1.exploit, lua_misc_enabled) 

    for i,v in pairs(symmetria.menu.visuals) do 
        ui.set_visible(v, lua_visuals_enabled)
    end 

    ui.set_visible(symmetria.menu.visuals.aspect_ratio_reference, lua_visuals_enabled and symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.additional), "aspect ratio"))

	ui.set_visible(symmetria.menu.misc1.recharge, lua_misc_enabled and symmetria.utils.table_contains(ui.get(symmetria.menu.misc1.exploit), "double tap fixed"))
    ui.set_visible(symmetria.menu.misc1.animbreakers, lua_misc_enabled and symmetria.utils.table_contains(ui.get(symmetria.menu.misc1.exploit), "animations"))

    ui.set_visible(symmetria.menu.visuals.tpdistanceslider, lua_visuals_enabled and symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.additional), "third person"))
    

    ui.set_visible(symmetria.menu.visuals.xS, lua_visuals_enabled and symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.additional), "viewmodel"))
    ui.set_visible(symmetria.menu.visuals.yS, lua_visuals_enabled and symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.additional), "viewmodel"))
    ui.set_visible(symmetria.menu.visuals.zS, lua_visuals_enabled and symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.additional), "viewmodel"))
    ui.set_visible(symmetria.menu.visuals.vS, lua_visuals_enabled and symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.additional), "viewmodel"))

    ui.set_visible(symmetria.menu.visuals.arrows_offset, lua_visuals_enabled and symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.elements), "arrows"))
    ui.set_visible(symmetria.menu.visuals.spready_arrows, lua_visuals_enabled and symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.elements), "arrows"))


    ui.set_visible(symmetria.menu.visuals.customize_text, lua_visuals_enabled and symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.elements), "crosshair"))
    ui.set_visible(symmetria.menu.visuals.custom_text, lua_visuals_enabled and ui.get(symmetria.menu.visuals.customize_text) and symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.elements), "crosshair"))
    ui.set_visible(symmetria.menu.visuals.custom_text_2, lua_visuals_enabled and ui.get(symmetria.menu.visuals.customize_text) and symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.elements), "crosshair"))

    if not ui.get(symmetria.menu.visuals.customize_text) then 
        ui.set(symmetria.menu.visuals.custom_text, "SYMMETRIA")
        ui.set(symmetria.menu.visuals.custom_text_2, "LOCAL")
    end 

    for i,v in pairs(symmetria.menu.misc) do 
        ui.set_visible(v, lua_angel_enabled and lua_helpers_enabled)
    end 

    if not (symmetria.variables.visuals.user.build == "LOCAL" or symmetria.variables.visuals.user.build == "LOCAL" or symmetria.variables.visuals.user.build == "LOCAL") then 
        ui.set(symmetria.menu.misc.resolver_enabled, false)
        ui.set_visible(symmetria.menu.misc.resolver_enabled, false)
    end 

    for i,v in pairs(symmetria.menu.settings) do 
        ui.set_visible(v, lua_settings_enabled)
    end 
    
    for i=1, #symmetria.variables.states do 
        for i2,v in pairs(symmetria.menu.anti_aim[i]) do 
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

    for i=1, #symmetria.variables.states do 
        if ui.get(symmetria.menu.state_selection) == symmetria.variables.states[i] then 
            ui.set_visible(symmetria.menu.anti_aim[i].enabled, lua_aa_enabled and lua_conditional_enabled)

            local state_enabled = ui.get(symmetria.menu.anti_aim[i].enabled) and lua_aa_enabled and lua_conditional_enabled

            ui.set_visible(symmetria.menu.anti_aim[i].stuff.pitch, state_enabled) 
            ui.set_visible(symmetria.menu.anti_aim[i].stuff.custom_pitch, state_enabled and ui.get(symmetria.menu.anti_aim[i].stuff.pitch) == "custom") 

            ui.set_visible(symmetria.menu.anti_aim[i].stuff.yaw_base, state_enabled)
            ui.set_visible(symmetria.menu.anti_aim[i].stuff.yaw, state_enabled)
            ui.set_visible(symmetria.menu.anti_aim[i].stuff.yaw_amount_left, state_enabled and ui.get(symmetria.menu.anti_aim[i].stuff.yaw) ~= "off")
            ui.set_visible(symmetria.menu.anti_aim[i].stuff.yaw_amount_right, state_enabled and ui.get(symmetria.menu.anti_aim[i].stuff.yaw) ~= "off")

            ui.set_visible(symmetria.menu.anti_aim[i].stuff.yaw_jitter, state_enabled)
            ui.set_visible(symmetria.menu.anti_aim[i].stuff.yaw_jitter_delay, state_enabled and ui.get(symmetria.menu.anti_aim[i].stuff.yaw_jitter) == "delayed")
            ui.set_visible(symmetria.menu.anti_aim[i].stuff.yaw_jitter_amount, state_enabled and ui.get(symmetria.menu.anti_aim[i].stuff.yaw_jitter) ~= "off")
            ui.set_visible(symmetria.menu.anti_aim[i].stuff.yaw_jitter_amount_2, state_enabled and ui.get(symmetria.menu.anti_aim[i].stuff.yaw_jitter) == "delayed")

            ui.set_visible(symmetria.menu.anti_aim[i].stuff.body_yaw, state_enabled)
            ui.set_visible(symmetria.menu.anti_aim[i].stuff.body_yaw_amount, state_enabled and ui.get(symmetria.menu.anti_aim[i].stuff.body_yaw) ~= "off" and ui.get(symmetria.menu.anti_aim[i].stuff.body_yaw) ~= "opposite")

            ui.set_visible(symmetria.menu.anti_aim[i].stuff.avoidness, state_enabled)
            ui.set_visible(symmetria.menu.anti_aim[i].stuff.anti_bruteforce_type, state_enabled)
            ui.set_visible(symmetria.menu.anti_aim[i].stuff.jitter_generation_limit, state_enabled and ui.get(symmetria.menu.anti_aim[i].stuff.anti_bruteforce_type) == "jitter-generation")

            ui.set_visible(symmetria.menu.anti_aim[i].stuff.anti_bruteforce_phase, state_enabled and ui.get(symmetria.menu.anti_aim[i].stuff.anti_bruteforce_type) == "custom")
            ui.set_visible(symmetria.menu.anti_aim[i].stuff.anti_bruteforce[symmetria.utils.phase_to_int(ui.get(symmetria.menu.anti_aim[i].stuff.anti_bruteforce_phase))], state_enabled and ui.get(symmetria.menu.anti_aim[i].stuff.anti_bruteforce_type) == "custom")

            ui.set_visible(symmetria.menu.anti_aim[i].stuff.defensive_flicks, state_enabled)
        end 
    end 
end 

local ui_get = ui.get
local ui_set = ui.set
local client_exec = client.exec
local ui_new_checkbox = ui.new_checkbox
local ui_new_slider = ui.new_slider
local ui_set_callback = ui.set_callback

local function tpdistance()
	client_exec("cam_idealdist ", ui_get(symmetria.menu.visuals.tpdistanceslider))
end
ui_set_callback(symmetria.menu.visuals.tpdistanceslider, tpdistance)


local function anti_aim_handler()
    if not ui.get(symmetria.menu.enabled) and ui.get(symmetria.menu.anti_aim[1].enabled) then return end 

    symmetria.utils.should_anti_knife()

    local state = ui.get(symmetria.menu.anti_aim[symmetria.state.get(entity.get_local_player())].enabled) and symmetria.state.get(entity.get_local_player()) or 1 

    if ui.get(symmetria.menu.anti_aim[state].stuff.pitch) ~= "exploit" then 
        ui.set(symmetria.variables.references.pitch[1], ui.get(symmetria.menu.anti_aim[state].stuff.pitch))
    else 
        if symmetria.variables.anti_aim.defensive.ticks_left > 0 then 
            ui.set(symmetria.variables.references.pitch[1], ui.get(symmetria.variables.references.pitch[1]) == "Down" and "up" or "down")
        else 
            ui.set(symmetria.variables.references.pitch[1], "down")
        end 
    end 
    ui.set(symmetria.variables.references.pitch[2], ui.get(symmetria.menu.anti_aim[state].stuff.custom_pitch))

    ui.set(symmetria.variables.references.yaw_base, ui.get(symmetria.menu.anti_aim[state].stuff.yaw_base))
    ui.set(symmetria.variables.references.yaw[1], ui.get(symmetria.menu.anti_aim[state].stuff.yaw))

    local yaw = symmetria.utils.get_side() == -1 and ui.get(symmetria.menu.anti_aim[state].stuff.yaw_amount_left) or ui.get(symmetria.menu.anti_aim[state].stuff.yaw_amount_right)  

    if symmetria.utils.should_jitter() then 
        if ui.get(symmetria.menu.anti_aim[state].stuff.yaw_jitter) == "delayed" and symmetria.variables.anti_aim.anti_bruteforce.activated > 0.75 then 
            ui.set(symmetria.variables.references.yaw_jitter[1], "off")

            yaw = symmetria.utils.normalize_yaw(yaw + (symmetria.variables.anti_aim.var.side == -1 and ui.get(symmetria.menu.anti_aim[state].stuff.yaw_jitter_amount) or ui.get(symmetria.menu.anti_aim[state].stuff.yaw_jitter_amount_2)))
        else 
            ui.set(symmetria.variables.references.yaw_jitter[1], ui.get(symmetria.menu.anti_aim[state].stuff.yaw_jitter) == "delayed" and "center" or ui.get(symmetria.menu.anti_aim[state].stuff.yaw_jitter))

            if ui.get(symmetria.menu.anti_aim[state].stuff.anti_bruteforce_type) == "jitter-generation" and globals.realtime() - symmetria.variables.anti_aim.anti_bruteforce.activated < 0.75 or ui.get(symmetria.menu.anti_aim[state].stuff.anti_bruteforce_type) == "custom" and globals.realtime() - symmetria.variables.anti_aim.anti_bruteforce.activated < 0.75 then
                ui.set(symmetria.variables.references.yaw_jitter[2], symmetria.utils.normalize_yaw(symmetria.variables.anti_aim.anti_bruteforce.angle))
            else
                ui.set(symmetria.variables.references.yaw_jitter[2], ui.get(symmetria.menu.anti_aim[state].stuff.yaw_jitter_amount))
            end 
        end 

        ui.set(symmetria.variables.references.body_yaw[1], globals.realtime() - symmetria.variables.anti_aim.anti_bruteforce.activated < 0.75 and "Off" or ui.get(symmetria.menu.anti_aim[state].stuff.body_yaw))
        ui.set(symmetria.variables.references.body_yaw[2], ui.get(symmetria.menu.anti_aim[state].stuff.body_yaw_amount))
    else 
        ui.set(symmetria.variables.references.yaw_jitter[1], "Off")
        ui.set(symmetria.variables.references.body_yaw[1], "Off")
    end 

    ui.set(symmetria.variables.references.freestanding[1], symmetria.utils.should_freestand() and ui.get(symmetria.menu.misc.freestanding))
    ui.set(symmetria.variables.references.freestanding[2], ui.get(symmetria.menu.misc.freestanding) and "Always on" or "Off hotkey")

    if ui.get(symmetria.menu.anti_aim[state].stuff.yaw_jitter_delay) ~= 1 and globals.tickcount() % ui.get(symmetria.menu.anti_aim[state].stuff.yaw_jitter_delay) == 1 or 1 == 1 then 
        symmetria.variables.anti_aim.var.side = symmetria.variables.anti_aim.var.side * -1
    end 

    ui.set(symmetria.variables.references.yaw[2], yaw) -- makes animfix put current animations on simulating the newest angle so we its easier to do avoidness

    if ui.get(symmetria.menu.anti_aim[state].stuff.anti_bruteforce_type) == "generation" and globals.realtime() - symmetria.variables.anti_aim.anti_bruteforce.activated < 0.75 then 
        yaw = symmetria.utils.normalize_yaw(yaw + symmetria.variables.anti_aim.anti_bruteforce.angle + symmetria.utils.get_manual_yaw())
    else 
        if client.current_threat() then 
            if symmetria.variables.anti_aim.defensive.ticks_left > 0 and ui.get(symmetria.menu.anti_aim[state].stuff.defensive_flicks) == "default type" then 
                yaw = symmetria.utils.normalize_yaw(symmetria.generation.generate_flick(client.current_threat(), ui.get(symmetria.menu.anti_aim[state].stuff.avoidness)))
            else 
                yaw = symmetria.utils.normalize_yaw(yaw + symmetria.generation.generate_angle(client.current_threat(), ui.get(symmetria.menu.anti_aim[state].stuff.avoidness)) + symmetria.utils.get_manual_yaw())
            end 
        else 
            yaw = symmetria.utils.normalize_yaw(yaw + symmetria.utils.get_manual_yaw())
        end 
    end 

    ui.set(symmetria.variables.references.yaw[2], yaw)
end 



local function anti_bruteforce_handler(event)
    local enemy = client.userid_to_entindex(event.userid)
    local dist = symmetria.liblaries.vector(entity.hitbox_position(entity.get_local_player(), 0)):dist2d(symmetria.liblaries.vector(event.x, event.y, event.z))

    if not entity.is_enemy(enemy) or not entity.is_alive(enemy) or not entity.is_alive(entity.get_local_player()) or dist > 300 or globals.realtime() - symmetria.variables.anti_aim.anti_bruteforce.activated < 0.75 then 
        return 
    end 

    local backtrack = symmetria.generation.get_backtrack_ticks(enemy)
    local state = ui.get(symmetria.menu.anti_aim[symmetria.state.get(entity.get_local_player())].enabled) and symmetria.state.get(entity.get_local_player()) or 1 
    if ui.get(symmetria.menu.anti_aim[state].stuff.anti_bruteforce_type) == "off" then return end 

    local angle = 0

    if ui.get(symmetria.menu.anti_aim[state].stuff.anti_bruteforce_type) == "generation" then
        angle = symmetria.generation.generate_angle(enemy, 100)

        client.log("[symmetria] generated yaw: "..angle.." (damage: "..symmetria.variables.visuals.generation.damage.." bt: "..backtrack..")")
    elseif ui.get(symmetria.menu.anti_aim[state].stuff.anti_bruteforce_type) == "jitter-generation" then 
        angle = symmetria.generation.generate_jitter(enemy, (ui.get(symmetria.menu.anti_aim[state].stuff.jitter_generation_limit) / 180) * 100)

        client.log("[symmetria] generated jitter: "..angle.." (damage: "..(symmetria.variables.visuals.generation.damage / 2).." bt: "..backtrack..")")
    elseif ui.get(symmetria.menu.anti_aim[state].stuff.anti_bruteforce_type) == "custom" then 
        angle = ui.get(symmetria.menu.anti_aim[state].stuff.anti_bruteforce[symmetria.variables.anti_aim.anti_bruteforce.phase])
    end 

    symmetria.variables.anti_aim.anti_bruteforce.activated = globals.realtime()
    symmetria.variables.anti_aim.anti_bruteforce.angle = angle

    if ui.get(symmetria.menu.anti_aim[state].stuff.anti_bruteforce_type) == "custom" then 
        if symmetria.variables.anti_aim.anti_bruteforce.phase >= 5 then 
            symmetria.variables.anti_aim.anti_bruteforce.phase = 1
        else 
            symmetria.variables.anti_aim.anti_bruteforce.phase = symmetria.variables.anti_aim.anti_bruteforce.phase + 1
        end 
    end 

    symmetria.utils.notify("anti-brute triggered due to shot by "..entity.get_player_name(enemy).." bt: "..backtrack.."t angle: "..angle.."°")
end 

local function initialize_indicators()
    local w, h = client.screen_size()

    symmetria.variables.visuals.watermark = {
        width = w / 2 - (61 / 2), 
        height = h - 10
    }
end 
initialize_indicators()



local function indicators_handler()
    local w, h = client.screen_size()
    local state = symmetria.state.get(entity.get_local_player()) - 1

    local main_r, main_g, main_b, main_a = ui.get(symmetria.menu.visuals.primary_color)
    local sec_r, sec_g, sec_b, sec_a = ui.get(symmetria.menu.visuals.secondary_color)

    if entity.is_alive(entity.get_local_player()) then 
        if symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.elements), "crosshair") then 
            local stuff = {
                {
                    text = ui.get(symmetria.menu.visuals.custom_text),

                    get_color = function()
                        local min, max, step = 1.75, 200, 1.75
                        if symmetria.variables.visuals.crosshair.step == 1 then 
                            if symmetria.variables.visuals.crosshair.text_alpha_2 < max then 
                                symmetria.variables.visuals.crosshair.text_alpha_2 = symmetria.variables.visuals.crosshair.text_alpha_2 + step
                            end 

                            if symmetria.variables.visuals.crosshair.text_alpha > min then 
                                symmetria.variables.visuals.crosshair.text_alpha = symmetria.variables.visuals.crosshair.text_alpha - step
                            end 

                            if symmetria.variables.visuals.crosshair.text_alpha <= min and symmetria.variables.visuals.crosshair.text_alpha_2 >= max then 
                                symmetria.variables.visuals.crosshair.step = 2
                            end 
                        elseif symmetria.variables.visuals.crosshair.step == 2 then 
                            if symmetria.variables.visuals.crosshair.text_alpha_2 > min then 
                                symmetria.variables.visuals.crosshair.text_alpha_2 = symmetria.variables.visuals.crosshair.text_alpha_2 - step
                            end 

                            if symmetria.variables.visuals.crosshair.text_alpha < max then   
                                symmetria.variables.visuals.crosshair.text_alpha = symmetria.variables.visuals.crosshair.text_alpha + step
                            end 

                            if symmetria.variables.visuals.crosshair.text_alpha_2 <= min and symmetria.variables.visuals.crosshair.text_alpha >= max then 
                                symmetria.variables.visuals.crosshair.step = 3
                            end 
                        else
                            if symmetria.variables.visuals.crosshair.text_alpha > min then 
                                symmetria.variables.visuals.crosshair.text_alpha = symmetria.variables.visuals.crosshair.text_alpha - step
                            end 

                            if symmetria.variables.visuals.crosshair.text_alpha <= min then 
                                symmetria.variables.visuals.crosshair.step = 1
                            end 
                        end 

                        return {r = main_r, g = main_g, b = main_b, a = symmetria.variables.visuals.crosshair.text_alpha, r2 = main_r, g2 = main_g, b2 = main_b, a2 = symmetria.variables.visuals.crosshair.text_alpha_2}
                    end,

                    is_active = function()
                        return true
                    end,

                    is_a_gradient = true 
                },

                {
                    text = " "..ui.get(symmetria.menu.visuals.custom_text_2).."",

                    get_color = function()
                        return {r = sec_r, g = sec_g, b = sec_b, a = symmetria.variables.visuals.crosshair.text_alpha_2, r2 = sec_r, g2 = sec_g, b2 = sec_b, a2 = symmetria.variables.visuals.crosshair.text_alpha}
                    end,

                    is_active = function()
                        return true
                    end,

                    is_a_gradient = true 
                },

                {
                    text = "".."",

                    get_color = function()
                        return {r = 255, g = 255, b = 255, a = symmetria.variables.visuals.generation.damage > 0 and 255 or 75}
                    end, 

                    is_active = function() 
                        return true
                    end 
                },

                {
                    text = "BT: "..symmetria.variables.visuals.generation.backtrack.."T",

                    get_color = function()
                        return {r = 255, g = 255, b = 255, a = symmetria.variables.visuals.generation.backtrack > 0 and 255 or 75}
                    end,

                    is_active = function()
                        return true 
                    end 
                },

                {
                    text = ui.get(symmetria.variables.references.keybinds.items.double_tap[2]) and "DT" or ui.get(symmetria.variables.references.keybinds.items.hide_shots[2]) and "OS",

                    get_color = function()
                        return {r = 255, g = 255, b = 255, a = 255}
                    end, 

                    is_active = function()
                        return ui.get(symmetria.variables.references.keybinds.items.double_tap[2]) or ui.get(symmetria.variables.references.keybinds.items.hide_shots[2])
                    end 
                },

                {
                    text = "DMG",

                    get_color = function()
                        return {r = 255, g = 255, b = 255, a = 255}
                    end, 

                    is_active = function() 
                        return ui.get(symmetria.variables.references.keybinds.items.minumum_damage_override[2])
                    end 
                },

                {
                    text = "BAIM",

                    get_color = function()
                        return {r = 255, g = 255, b = 255, a = 255}
                    end, 

                    is_active = function() 
                        return ui.get(symmetria.variables.references.keybinds.items.force_body) 
                    end 
                }
            }

            local width, max_width, height = 0, renderer.measure_text("-", ui.get(symmetria.menu.visuals.custom_text)) + renderer.measure_text("-", " "..ui.get(symmetria.menu.visuals.custom_text_2)..""), 0
            for i=1, #stuff do
                local v = stuff[i]

                if v.is_active() then 
                    local clr = v.get_color()

                    if v.is_a_gradient then 
                        symmetria.utils.gradient_text(v.text, w / 2 + width, h / 2 + 19 + height, clr.r, clr.g, clr.b, clr.a, clr.r2, clr.g2, clr.b2, clr.a2)
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
    
        if symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.elements), "arrows") then 
            local spready_offset = ui.get(symmetria.menu.visuals.spready_arrows) and 20 * (math.abs(symmetria.liblaries.vector(entity.get_prop(entity.get_local_player(), "m_vecVelocity")):length2d()) / 320) or 0
            local arrows_offset = ui.get(symmetria.menu.visuals.arrows_offset)

            spready_offset = ui.get(symmetria.menu.visuals.arrows_offset) >= 0 and -spready_offset or spready_offset

            if symmetria.utils.get_side() == -1 then 
                renderer.line(w / 2 - 33 - arrows_offset + spready_offset, h / 2 - 10, w / 2 - 33 - arrows_offset + spready_offset, h / 2 + 10, sec_r, sec_g, sec_b, sec_a)
                renderer.line(w / 2 + 33 + arrows_offset - spready_offset, h / 2 - 10, w / 2 + 33 + arrows_offset - spready_offset, h / 2 + 10, 25, 25, 25, 125)
            else 
                renderer.line(w / 2 + 33 + arrows_offset - spready_offset, h / 2 - 10, w / 2 + 33 + arrows_offset - spready_offset, h / 2 + 10, sec_r, sec_g, sec_b, sec_a)
                renderer.line(w / 2 - 33 - arrows_offset + spready_offset, h / 2 - 10, w / 2 - 33 - arrows_offset + spready_offset, h / 2 + 10, 25, 25, 25, 125)
            end 
            
            if symmetria.utils.get_manual_yaw() == -90 then 
                renderer.triangle(w / 2 - 35 - arrows_offset + spready_offset, h / 2 - 10, w / 2 - 35 - arrows_offset + spready_offset, h / 2 + 10, w / 2 - 50 - arrows_offset + spready_offset, h / 2, main_r, main_g, main_b, main_a)
                renderer.triangle(w / 2 + 35 + arrows_offset - spready_offset, h / 2 - 10, w / 2 + 35 + arrows_offset - spready_offset, h / 2 + 10, w / 2 + 50 + arrows_offset - spready_offset, h / 2, 25, 25, 25, 125)
            elseif symmetria.utils.get_manual_yaw() == 90 then 
                renderer.triangle(w / 2 - 35 - arrows_offset + spready_offset, h / 2 - 10, w / 2 - 35 - arrows_offset + spready_offset, h / 2 + 10, w / 2 - 50 - arrows_offset + spready_offset, h / 2, 25, 25, 25, 125)
                renderer.triangle(w / 2 + 35 + arrows_offset - spready_offset, h / 2 - 10, w / 2 + 35 + arrows_offset - spready_offset, h / 2 + 10, w / 2 + 50 + arrows_offset - spready_offset, h / 2, main_r, main_g, main_b, main_a)
            else 
                renderer.triangle(w / 2 - 35 - arrows_offset + spready_offset, h / 2 - 10, w / 2 - 35 - arrows_offset + spready_offset, h / 2 + 10, w / 2 - 50 - arrows_offset + spready_offset, h / 2, 25, 25, 25, 125)
                renderer.triangle(w / 2 + 35 + arrows_offset - spready_offset, h / 2 - 10, w / 2 + 35 + arrows_offset - spready_offset, h / 2 + 10, w / 2 + 50 + arrows_offset - spready_offset, h / 2, 25, 25, 25, 125)
            end 
        end 

        if symmetria.utils.table_contains(ui.get(symmetria.menu.visuals.elements), "watermark") then 
            local width = renderer.measure_text("-", "symmetria | " .. string.upper(symmetria.variables.visuals.user.build) .. "")

            if client.key_state(0x01) and ui.is_menu_open() then 
                local x, y = ui.mouse_position()
        
                if symmetria.variables.visuals.watermark.width + (width) >= x and symmetria.variables.visuals.watermark.width - (width) <= x
                    and symmetria.variables.visuals.watermark.height + 20 >= y and symmetria.variables.visuals.watermark.height - 10 <= y then 
        
                    symmetria.variables.visuals.watermark.width = x 
                    symmetria.variables.visuals.watermark.height = y
                end 
        
                renderer.line(symmetria.variables.visuals.watermark.width + (width / 2), symmetria.variables.visuals.watermark.height - 10, symmetria.variables.visuals.watermark.width + (width / 2), symmetria.variables.visuals.watermark.height, 255, 255, 255, 255)
                renderer.line(symmetria.variables.visuals.watermark.width + (width / 2), symmetria.variables.visuals.watermark.height + 20, symmetria.variables.visuals.watermark.width + (width / 2), symmetria.variables.visuals.watermark.height + 10, 255, 255, 255, 255)
                renderer.line(symmetria.variables.visuals.watermark.width + width + 5, symmetria.variables.visuals.watermark.height + 5, symmetria.variables.visuals.watermark.width + width + 15, symmetria.variables.visuals.watermark.height + 5, 255, 255, 255, 255)
                renderer.line(symmetria.variables.visuals.watermark.width - 3, symmetria.variables.visuals.watermark.height + 5, symmetria.variables.visuals.watermark.width - 13, symmetria.variables.visuals.watermark.height + 5, 255, 255, 255, 255)
            end 
        
            symmetria.utils.gradient_text("SYMMETRIA" .. string.upper(symmetria.variables.visuals.user.build) .. "", symmetria.variables.visuals.watermark.width, symmetria.variables.visuals.watermark.height, main_r, main_g, main_b, 255, sec_r, sec_g, sec_b, 255)
        end 
    end
end 


--local variables for API functions. Generated using https://github.com/sapphyrus/gamesense-lua/blob/master/generate_api.lua
local client_latency, client_set_clan_tag, client_log, client_timestamp, client_userid_to_entindex, client_trace_line, client_set_event_callback, client_screen_size, client_trace_bullet, client_color_log, client_system_time, client_delay_call, client_visible, client_exec, client_eye_position, client_set_cvar, client_scale_damage, client_draw_hitboxes, client_get_cvar, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.latency, client.set_clan_tag, client.log, client.timestamp, client.userid_to_entindex, client.trace_line, client.set_event_callback, client.screen_size, client.trace_bullet, client.color_log, client.system_time, client.delay_call, client.visible, client.exec, client.eye_position, client.set_cvar, client.scale_damage, client.draw_hitboxes, client.get_cvar, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_combobox, ui_reference, ui_is_menu_open, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.is_menu_open, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get
local renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_measure_text, renderer_indicator, renderer_world_to_screen = renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.measure_text, renderer.indicator, renderer.world_to_screen
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error
--end of local variables

local cvar_is = client.get_cvar
local cvar = client.set_cvar

local function set_aspect_ratio(aspect_ratio_multiplier)
    local screen_width, screen_height = client_screen_size()
    local aspectratio_value = (screen_width * aspect_ratio_multiplier) / screen_height

    if aspect_ratio_multiplier == 1 then
        aspectratio_value = 0
    end
    client_set_cvar("r_aspectratio", tonumber(aspectratio_value))
end

local function noop()
end

-- greatest common divisor
local function gcd(m, n)
    while m ~= 0 do
        m, n = math_fmod(n, m), m
    end

    return n
end

local screen_width, screen_height, aspect_ratio_reference

local function on_aspect_ratio_changed()
    local aspect_ratio = ui_get(symmetria.menu.visuals.aspect_ratio_reference) * 0.01
    aspect_ratio = 2 - aspect_ratio
    set_aspect_ratio(aspect_ratio)
end

local multiplier = 0.01
local steps = 200

local function setup(screen_width_temp, screen_height_temp)
    screen_width, screen_height = screen_width_temp, screen_height_temp
    local aspect_ratio_table = {}

    for i = 1, steps do
        local i2 = (steps - i) * multiplier
        local divisor = gcd(screen_width * i2, screen_height)
        if screen_width * i2 / divisor < 100 or i2 == 1 then
            aspect_ratio_table[i] = screen_width * i2 / divisor .. ":" .. screen_height / divisor
        end
    end

    if symmetria.menu.visuals.aspect_ratio_reference ~= nil then
        ui_set_visible(symmetria.menu.visuals.aspect_ratio_reference, false)
        ui_set_callback(symmetria.menu.visuals.aspect_ratio_reference, noop)
    end

    ui_set_callback(symmetria.menu.visuals.aspect_ratio_reference, on_aspect_ratio_changed)
end

local to_number = tonumber
local math_floor = math.floor
local math_random = math.random
local table_insert = table.insert
local table_remove = table.remove
local table_size = table.getn
local string_format = string.format
local xO = 0
local yO = 0
local zO = 0
local fO = 0
local function cache()
    xO = cvar_is("viewmodel_offset_x")
    yO = cvar_is("viewmodel_offset_y")
    zO = cvar_is("viewmodel_offset_z")
  --  fO = cvar_is("viewmodel_fov")
end

cache()
-------------------------------------Menu Elements-----------------------------------------------------

--hide_on_load()
local function on_paint(ctx)
    local viewmodel = 68 + ui_get(symmetria.menu.visuals.vS)
    local x         = ui_get(symmetria.menu.visuals.xS)
    local y         = ui_get(symmetria.menu.visuals.yS)
    local z         = ui_get(symmetria.menu.visuals.zS)
    cvar("viewmodel_offset_x", x)
    cvar("viewmodel_offset_y", y)
    cvar("viewmodel_offset_z", z)
    cvar("viewmodel_fov",      viewmodel)
end

client.set_event_callback("paint", on_paint)

local function enable_aspect_ratio()
    setup(client_screen_size())
end

local function disable_aspect_ratio()
    set_aspect_ratio(1)  -- Вернем соотношение сторон к стандартному (1:1)
end

local function on_additional_option_changed()
    local additional_option = ui_get(symmetria.menu.visuals.additional)
    if additional_option == "aspect ratio" then
        enable_aspect_ratio()
    else
        disable_aspect_ratio()
    end
end

-- Инициализация при загрузке скрипта
setup(client_screen_size())
ui_set_callback(symmetria.menu.visuals.additional, on_additional_option_changed)

local function on_paint(ctx)
    local screen_width_temp, screen_height_temp = client_screen_size()
    if screen_width_temp ~= screen_width or screen_height_temp ~= screen_height then
        setup(screen_width_temp, screen_height_temp)
    end
end
client.set_event_callback("paint", on_paint)





local ref = {
    aimbot = ui.reference('RAGE', 'Aimbot', 'Enabled'),
    doubletap = {
        main = {ui.reference('RAGE', 'Aimbot', 'Double tap')},
        fakelag_limit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
    },
    onshot_antiaim = {ui.reference('AA', 'Other', 'On shot anti-aim')}
}

client.set_event_callback('setup_command', function()
    if not ((ui.get(ref.doubletap.main[1]) and ui.get(ref.doubletap.main[2])) or (ui.get(ref.onshot_antiaim[1]) and ui.get(ref.onshot_antiaim[2]))) then
        ui.set(ref.aimbot, true)
        return
    end

    local m_nTickBase = entity.get_prop(entity.get_local_player(), 'm_nTickBase')
    local shift = math.floor(m_nTickBase - globals.tickcount() - 3 - toticks(client.latency()) * .4)
    local ticks_charged = shift <= -15 + (ui.get(ref.doubletap.fakelag_limit) - 1) + 5

    local threat = client.current_threat()

    if ticks_charged
    or not threat
    or bit.band(entity.get_esp_data(threat).flags, bit.lshift(1, 11)) ~= 2048 then
        ui.set(ref.aimbot, true)
        return
    end

    ui.set(ref.aimbot, false)
end)

client.set_event_callback('shutdown', function()
    ui.set(ref.aimbot, true)
end)



local function animbreaker_handler()
    if not entity.is_alive(entity.get_local_player()) then return end 

    local localplayer = symmetria.liblaries.entity.new(entity.get_local_player())
    if not localplayer then return end 

    if symmetria.utils.table_contains(ui.get(symmetria.menu.misc1.animbreakers), "legbreaker") then 
        ui.set(symmetria.variables.references.other.items.leg_movement, ui.get(symmetria.variables.references.other.items.leg_movement) == "Always slide" and "Off" or "Always slide")

        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", globals.tickcount() % 2 == 1 and 25 or 1, globals.tickcount() % 2 == 1 and 0 or 1)
    end 

    if symmetria.utils.table_contains(ui.get(symmetria.menu.misc1.animbreakers), "static legs in air") then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
    end 

    if symmetria.utils.table_contains(ui.get(symmetria.menu.misc1.animbreakers), "moonwalk in air") and (symmetria.state.get(entity.get_local_player()) == 4 or symmetria.state.get(entity.get_local_player()) == 8) then 
        localplayer:get_anim_overlay(6).weight = 1.0
    end 

    if symmetria.utils.table_contains(ui.get(symmetria.menu.misc1.animbreakers), "body lean") then 
        localplayer:get_anim_overlay(12).weight = 1.0
    end 
	if symmetria.utils.table_contains(ui.get(symmetria.menu.misc1.animbreakers), "kinguru") then
        local player = entity.get_local_player()
        entity.set_prop(player, "m_flPoseParameter", math.random(0, 2) / 2, 2)
        entity.set_prop(player, "m_flPoseParameter", math.random(0, 2) / 2, 1)
        entity.set_prop(player, "m_flPoseParameter", math.random(0, 2) / 2, 2)
    end
end 

local function defensive_handler(cmd)
    symmetria.variables.anti_aim.generation.data[globals.tickcount()] = {
        head_pos = symmetria.liblaries.vector(entity.hitbox_position(entity.get_local_player(), 0)),
        origin = symmetria.liblaries.vector(entity.get_origin(entity.get_local_player())),
        simtime = entity.get_prop(entity.get_local_player(), "m_flSimulationTime"),
        yaw = symmetria.liblaries.antiaim.get_body_yaw(1)
    }

    symmetria.variables.anti_aim.generation.yaw = symmetria.liblaries.antiaim.get_body_yaw(1) -- symmetria.liblaries.antiaim.get_body_yaw(2)

    if cmd.in_attack == 1 then symmetria.variables.anti_aim.defensive.ticks_left = 0 return end 

    cmd.force_defensive = true 

    if client.current_threat() and symmetria.generation.get_backtrack_ticks(client.current_threat()) > 12 and ui.get(symmetria.variables.references.keybinds.items.double_tap[2]) then 
        -- cmd.no_choke = true  
        cmd.quick_stop = true
    end 
end

local function defensive_variables_handler()
    if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then return end

    local simtime = entity.get_prop(entity.get_local_player(), "m_flSimulationTime")

    symmetria.variables.anti_aim.defensive.ticks_left = symmetria.utils.time_to_ticks(math.abs(simtime - symmetria.variables.anti_aim.defensive.last_simtime) - client.latency())

    if symmetria.variables.anti_aim.defensive.last_simtime ~= simtime then 
        symmetria.variables.anti_aim.defensive.last_simtime = simtime
    end 
end

client.set_event_callback("aim_miss", function()
    if symmetria.utils.table_contains(ui.get(symmetria.menu.misc1.exploit), "challenge [dont missing :3]") then
        client.exec("disconnect")
    end
end)


local function anti_aim_manuals_handler()
    if ui.get(symmetria.menu.misc.manual_forward) ~= symmetria.variables.anti_aim.manuals.cache.forward then
        symmetria.variables.anti_aim.manuals.cache.forward = ui.get(symmetria.menu.misc.manual_forward)

        symmetria.variables.anti_aim.manuals.forward = ui.get(symmetria.menu.misc.manual_forward)
        symmetria.variables.anti_aim.manuals.left = false 
        symmetria.variables.anti_aim.manuals.right = false 

        ui.set(symmetria.menu.misc.manual_left, false)
        ui.set(symmetria.menu.misc.manual_right, false)
    end 

    if ui.get(symmetria.menu.misc.manual_left) ~= symmetria.variables.anti_aim.manuals.cache.left then
        symmetria.variables.anti_aim.manuals.cache.left = ui.get(symmetria.menu.misc.manual_left)

        symmetria.variables.anti_aim.manuals.forward = false 
        symmetria.variables.anti_aim.manuals.left = ui.get(symmetria.menu.misc.manual_left)
        symmetria.variables.anti_aim.manuals.right = false 

        ui.set(symmetria.menu.misc.manual_forward, false)
        ui.set(symmetria.menu.misc.manual_right, false)
    end 

    if ui.get(symmetria.menu.misc.manual_right) ~= symmetria.variables.anti_aim.manuals.cache.right then 
        symmetria.variables.anti_aim.manuals.cache.right = ui.get(symmetria.menu.misc.manual_right)
       
        symmetria.variables.anti_aim.manuals.forward = false 
        symmetria.variables.anti_aim.manuals.left = false
        symmetria.variables.anti_aim.manuals.right = ui.get(symmetria.menu.misc.manual_right)

        ui.set(symmetria.menu.misc.manual_forward, false)
        ui.set(symmetria.menu.misc.manual_left, false)
    end 
end 

local function shutdown()
    for i, v in pairs(symmetria.variables.references) do 
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

        if not symmetria.resolver.data[enemy] then 
            symmetria.resolver.data[enemy] = {
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

        if ui.get(symmetria.menu.misc.resolver_enabled) then 
            plist.set(enemy, "Correction active", false)
            plist.set(enemy, "Force body yaw", false)

            local player = symmetria.liblaries.entity.new(enemy)
            if not player then return end 

            local animstate = player:get_anim_state()
            local animlayer = player:get_anim_overlay(6)

            local max_speed = 260
            if entity.get_player_weapon(enemy) then 
                max_speed = math.max(symmetria.liblaries.weapons(entity.get_player_weapon(enemy)).max_player_speed, 0.001)
            end 

            local running_speed = math.max(symmetria.liblaries.vector(entity.get_prop(player, "m_vecVelocity")):length2d(), 260) / (max_speed * 0.520)
            local ducking_speed = math.max(symmetria.liblaries.vector(entity.get_prop(player, "m_vecVelocity")):length2d(), 260) / (max_speed * 0.340)

            local server_time = symmetria.utils.ticks_to_time(entity.get_prop(enemy, "m_nTickBase"))
            local yaw = animstate.goal_feet_yaw

            local eye_feet_delta = animstate.eye_angles_y - animstate.goal_feet_yaw

            local yaw_modifier = ((((animstate.stop_to_full_running_fraction * -0.3) - 0.2) * symmetria.utils.clamp(running_speed, 0, 1)) + 1)
            if animstate.duck_amount > 0 then 
                yaw_modifier = yaw_modifier + (animstate.duck_amount * (symmetria.utils.clamp(ducking_speed, 0, 1)) * (0.5 - yaw_modifier))
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

            if symmetria.liblaries.vector(entity.get_prop(player, "m_vecVelocity")):length2d() > 0.01 or math.abs(symmetria.liblaries.vector(entity.get_prop(player, "m_vecVelocity")).z) > 100 then 
                yaw = symmetria.resolver.helpers.approach_angle(animstate.eye_angles_y, yaw, ((animstate.stop_to_full_running_fraction * 20) + 30) * animstate.last_client_side_animation_update_time)
            else 
                yaw = symmetria.resolver.helpers.approach_angle(entity.get_prop(enemy, "m_flLowerBodyYawTarget"), yaw, animstate.last_client_side_animation_update_time * 100)
            end 

            local desync = animstate.goal_feet_yaw - yaw  
            local eye_goalfeet_delta = symmetria.resolver.helpers.angle_diff(animstate.eye_angles_y - yaw, 360)

            if eye_goalfeet_delta < 0.0 or animstate.max_yaw == 0.0 then 
                if animstate.min_yaw ~= 0.0 then 
                    desync = ((eye_goalfeet_delta / animstate.min_yaw) * 360) * -58
                end 
            else 
                desync = ((eye_goalfeet_delta / animstate.max_yaw) * 360) * 58
            end 

            if server_time >= symmetria.resolver.data[enemy].lby.next_update then 
                desync = 120 / 58 -- lby breaker fix
            end 

            local delta = desync - symmetria.resolver.data[enemy].yaw.last_yaw
            local time_delta = entity.get_prop(enemy, "m_flSimulationTime") - symmetria.resolver.data[enemy].yaw.last_change
            local modifier = time_delta / symmetria.resolver.data[enemy].yaw.delta

            desync = (desync * 58) + (delta * modifier)
            desync = desync * symmetria.resolver.helpers.process_side(enemy, symmetria.resolver.helpers.get_side(enemy, animlayer))

            plist.set(enemy, "Force body yaw", true)
            plist.set(enemy, "Force body yaw value", desync) 
            plist.set(enemy, "High priority", math.floor(time_delta) ~= 0) -- prevent missing LC

            if animstate.eye_timer ~= 0 then 
                if animstate.m_velocity > 0.1 then 
                    symmetria.resolver.data[enemy].lby.next_update = server_time + 0.22
                end 

                if math.abs((animstate.goal_feet_yaw - animstate.eye_angles_y) / 360) > 35 and server_time > symmetria.resolver.data[enemy].lby.next_update then 
                    symmetria.resolver.data[enemy].lby.next_update = server_time + 1.1
                end 
            end 

            if symmetria.resolver.data[enemy].yaw.last_yaw ~= desync then 
                symmetria.resolver.data[enemy].yaw.last_yaw = desync
            end 

            if delta ~= 0 then 
                if symmetria.resolver.data[enemy].yaw.delta ~= delta then 
                    symmetria.resolver.data[enemy].yaw.last_change = entity.get_prop(enemy, "m_flSimulationTime")
                    symmetria.resolver.data[enemy].yaw.delta = delta 
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
    if not ui.get(symmetria.menu.misc.resolver_enabled) or event.reason == "spread" or event.reason == "death" or event.reason == "unregistered shot" then return end 

    symmetria.resolver.data[event.target].misses = symmetria.resolver.data[event.target].misses and symmetria.resolver.data[event.target].misses + 1 or 1

    local player = symmetria.liblaries.entity.new(event.target)
    if not player then return end 

    local animlayer = player:get_anim_overlay(6)

    local left, right = symmetria.resolver.data[event.target].playback.left, symmetria.resolver.data[event.target].playback.right
    local side = symmetria.resolver.helpers.process_side(event.target, symmetria.resolver.helpers.get_side(event.target, animlayer))

    if side == -1 then 
        left = animlayer.playback_rate
    elseif side == 1 then 
        right = animlayer.playback_rate
    end 

    symmetria.resolver.data[event.target].playback = {
        left = left,
        right = right
    }

    client.log("[symmetria resolver] detected miss at "..entity.get_player_name(event.target).." | desync: "..plist.get(event.target, "Force body yaw value").."")
end 

client.set_event_callback("aim_miss", function(event)
    resolver_on_miss(event)
end)


client.set_event_callback("bullet_impact", function(event)
    anti_bruteforce_handler(event)
end)


client.set_event_callback("paint_ui", function()
    menu_handler()

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

client.set_event_callback('paint_ui', function()
	hide_original_menu(false)
end)

client.set_event_callback('shutdown', function()
	hide_original_menu(true)
end)

client.set_event_callback("setup_command", function(cmd)
    defensive_handler(cmd)
end)

client.set_event_callback("shutdown", function()
    shutdown()
end)