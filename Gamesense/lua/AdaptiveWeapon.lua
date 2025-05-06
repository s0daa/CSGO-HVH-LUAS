--[[    

        adaptive for skeet ^^
        created by kleyff
        this story started since 2016.
        meow?
        
]]

local skeet do
    skeet = { }

    skeet.weapon_type = ui.reference('Rage', 'Weapon type', 'Weapon type')
    skeet.enabled_aim = { ui.reference("Rage", "Aimbot", "Enabled") }
    skeet.slider_limit = ui.reference('AA', 'Fake lag', 'Limit')
    skeet.duck_peek_assist = ui.reference('RAGE', 'Other', 'Duck peek assist')
    skeet.accuracy_boost = ui.reference('Rage', 'Other', 'Accuracy boost')
    skeet.delay_shot = ui.reference('Rage', 'Other', 'Delay shot')
    skeet.avoid_unsafe = ui.reference('Rage', 'Aimbot', 'Avoid unsafe hitboxes')
    skeet.prefer_body_aim = ui.reference('Rage', 'Aimbot', 'Prefer body aim disablers')
    skeet.hitchance = ui.reference('Rage', 'Aimbot', 'Minimum hit chance')
    skeet.ping_spike = { ui.reference('Misc', 'Miscellaneous', 'Ping spike') }
    skeet.damage = ui.reference('Rage', 'Aimbot', 'Minimum damage')
    skeet.damage_override = { ui.reference('Rage', 'Aimbot', 'Minimum damage override') }
    skeet.auto_scope = ui.reference('Rage', 'Aimbot', 'Automatic scope')
    skeet.auto_stop = select(3, ui.reference('Rage', 'Aimbot', 'Quick stop'))
    skeet.auto_peek = { ui.reference('Rage', 'Other', 'Quick peek assist') }
    skeet.dt = { ui.reference('Rage', 'Aimbot', 'Double tap') }
    skeet.legsbreaker = ui.reference("AA", "Other", "Leg movement")
    skeet.hide = { ui.reference('AA', 'Other', 'On shot anti-aim') }
    skeet.hide_hotkey = { ui.reference("AA", "Other", "\n On shot anti-aim") }
    skeet.edgeyaw = ui.reference('AA', 'Anti-aimbot angles', "Edge yaw")
end

function table.contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

do
    table.convert = function(tbl)
        if tbl == nil then
            return { }
        end

        local final = { }

        for i = 1, #tbl do
            final[ tbl[i] ] = true
        end

        return final
    end

    table.invert = function(tbl)
        if tbl == nil then
            return { }
        end

        local final = { }

        for name, enabled in next, tbl do
            if enabled then
                final[ #final + 1 ] = name
            end
        end

        return final
    end
end

local adaptivelabel = ui.new_label('Rage', 'Aimbot', '\aFFFFFFFF✯--------------Adaptive Section--------------✯')

do
    local var_0_0 = client.visible
    local var_0_1 = client.eye_position
    local var_0_2 = client.log
    local var_0_3 = client.trace_bullet
    local var_0_4 = entity.get_bounding_box
    local var_0_5 = entity.get_local_player
    local var_0_6 = entity.get_origin
    local var_0_7 = entity.get_player_name
    local var_0_8 = entity.get_player_resource
    local var_0_9 = entity.get_player_weapon
    local var_0_10 = entity.get_prop
    local var_0_11 = entity.is_dormant
    local var_0_12 = entity.is_enemy
    local var_0_13 = globals.curtime
    local var_0_14 = globals.maxplayers
    local var_0_15 = globals.tickcount
    local var_0_16 = math.max
    local var_0_17 = renderer.indicator
    local var_0_18 = string.format
    local var_0_19 = ui.get
    local var_0_20 = ui.new_checkbox
    local var_0_21 = ui.new_hotkey
    local var_0_22 = ui.reference
    local var_0_23 = ui.set_callback
    local var_0_24 = sqrt
    local var_0_25 = unpack
    local var_0_26 = entity.is_alive
    local var_0_27 = plist.get
    local var_0_28 = entity.hitbox_position
    local var_0_29 = require("ffi")
    local var_0_30 = require("vector")
    local var_0_31 = require("gamesense/csgo_weapons")
    local var_0_32 = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*,int)")
    local var_0_33 = vtable_thunk(166, "bool(__thiscall*)(void*)")
    local var_0_34 = vtable_thunk(483, "float(__thiscall*)(void*)")
    local var_0_35 = {
        mindmg = var_0_22("RAGE", "Aimbot", "Minimum damage"),
        dormantEsp = var_0_22("VISUALS", "Player ESP", "Dormant"),
        override_mindmg = {
            ui.reference("RAGE", "Aimbot", "Minimum damage override")
        }
    }
    local var_0_36 = var_0_20("RAGE", "Aimbot", "\aFFFFFF90☩︎ \aAA8DF6FFDormant aimbot")
    local var_0_37 = {}
    
    var_0_37[0] = "Inherited"
    
    for iter_0_0 = 1, 26 do
        var_0_37[100 + iter_0_0] = "HP + " .. iter_0_0
    end
    local labeldormant = ui.new_label("Rage", "Other", "\aFFFFFFFF⌬︎--------------Dormant Section--------------⌬︎")
    local var_0_38 = {
        dormantKey = var_0_21("RAGE", "Aimbot", "Dormant aimbot", true),
        dormantHitboxes = ui.new_multiselect("RAGE", "Aimbot", "\aFFFFFF90~ \aD0BEFDFFDormant hitbox select", "Head", "Chest", "Stomach", "Legs"),
        dormantAccuracy = ui.new_slider("RAGE", "Aimbot", "\aFFFFFF90~ \aD0BEFDFFDormant aimbot accuracy", 50, 100, 90, true, "%", 1),
        dormantMindmg = ui.new_slider("RAGE", "Aimbot", "\aFFFFFF90~ \aD0BEFDFFDormant minimum damage", 0, 126, 10, true, nil, 1, var_0_37),
        dormantLogs = ui.new_checkbox("RAGE", "Other", "\aFFFFFF90» \aD0BEFDFFLog dormant shots"),
        dormantIndicator = ui.new_checkbox("RAGE", "Other", "\aFFFFFF90» \aD0BEFDFFDormant aimbot indicator"),
        dormantlastseen = ui.new_checkbox("RAGE", "Other", "\aFFFFFF90» \aD0BEFDFFDraw dormant position"),
        dormantlastseencolor = ui.new_color_picker("RAGE", "Other", "Dormant aimbot indicator", 255, 255, 255, 255)
    }
    local function alwayson()
        ui.set(var_0_38.dormantKey, "Toggle")
    end
    
    alwayson()
    local var_0_39 = {
        "generic",
        "head",
        "chest",
        "stomach",
        "left arm",
        "right arm",
        "left leg",
        "right leg",
        "neck",
        "?",
        "gear"
    }
    local var_0_40 = {
        "",
        "Head",
        "Chest",
        "Stomach",
        "Chest",
        "Chest",
        "Legs",
        "Legs",
        "Head",
        "",
        ""
    }
    
    local function var_0_41(arg_1_0, arg_1_1, arg_1_2)
        local var_1_0, var_1_1 = arg_1_0:to(arg_1_1):angles()
        local var_1_2 = math.rad(var_1_1 + 90)
        local var_1_3 = var_0_30(math.cos(var_1_2), math.sin(var_1_2), 0) * arg_1_2
        local var_1_4 = var_0_30(0, 0, arg_1_2)
    
        return {
            {
                text = "Middle",
                vec = arg_1_1
            },
            {
                text = "Left",
                vec = arg_1_1 + var_1_3
            },
            {
                text = "Right",
                vec = arg_1_1 - var_1_3
            }
        }
    end
    
    local function var_0_42(arg_2_0, arg_2_1)
        for iter_2_0 = 1, #arg_2_0 do
            if arg_2_0[iter_2_0] == arg_2_1 then
                return true
            end
        end
    
        return false
    end
    
    local function var_0_43(arg_3_0, arg_3_1)
        local var_3_0 = math.sqrt(arg_3_0.forwardmove * arg_3_0.forwardmove + arg_3_0.sidemove * arg_3_0.sidemove)
    
        if arg_3_1 <= 0 or var_3_0 <= 0 then
            return
        end
    
        if arg_3_0.in_duck == 1 then
            arg_3_1 = arg_3_1 * 2.94117647
        end
    
        if var_3_0 <= arg_3_1 then
            return
        end
    
        local var_3_1 = arg_3_1 / var_3_0
    
        arg_3_0.forwardmove = arg_3_0.forwardmove * var_3_1
        arg_3_0.sidemove = arg_3_0.sidemove * var_3_1
    end
    
    local function var_0_44()
        local var_4_0 = {}
        local var_4_1 = entity.get_player_resource()
    
        for iter_4_0 = 1, globals.maxplayers() do
            if entity.get_prop(var_4_1, "m_bConnected", iter_4_0) == 1 and iter_4_0 ~= entity.get_local_player() and entity.is_enemy(iter_4_0) then
                var_4_0[#var_4_0 + 1] = iter_4_0
            end
        end
    
        return var_4_0
    end
    
    local function var_0_45()
        local var_5_0 = {}
        local var_5_1 = var_0_8()
    
        for iter_5_0 = 1, globals.maxplayers() do
            if var_0_10(var_5_1, "m_bConnected", iter_5_0) ~= 1 or var_0_27(iter_5_0, "Add to whitelist") then
                -- block empty
            elseif entity.is_dormant(iter_5_0) and entity.is_enemy(iter_5_0) then
                var_5_0[#var_5_0 + 1] = iter_5_0
            end
        end
    
        return var_5_0
    end
    
    local function var_0_46(arg_6_0, arg_6_1)
        for iter_6_0, iter_6_1 in ipairs(arg_6_0) do
            if iter_6_1[1] == arg_6_1 then
                return true
            end
        end
    
        return false
    end
    
    local var_0_47 = 0
    local var_0_48 = {}
    local var_0_49 = {}
    local var_0_50 = {
        {
            scale = 5,
            hitbox = "Stomach",
            vec = var_0_30(0, 0, 40)
        },
        {
            scale = 6,
            hitbox = "Chest",
            vec = var_0_30(0, 0, 50)
        },
        {
            scale = 3,
            hitbox = "Head",
            vec = var_0_30(0, 0, 58)
        },
        {
            scale = 4,
            hitbox = "Legs",
            vec = var_0_30(0, 0, 20)
        }
    }
    local var_0_51 = {
        [0] = "Head",
        nil,
        "Stomach",
        nil,
        "Stomach",
        "Chest",
        "Chest",
        "Legs",
        "Legs"
    }
    local var_0_52 = 1
    local var_0_53
    local var_0_54
    local var_0_55
    local var_0_56
    local var_0_57
    local var_0_58 = false
    
    local function var_0_59(arg_7_0)
        local var_7_0 = var_0_19(var_0_38.dormantHitboxes)
        local var_7_1 = {}
    
        for iter_7_0, iter_7_1 in ipairs(var_0_44()) do
            local var_7_2, var_7_3, var_7_4, var_7_5, var_7_6 = entity.get_bounding_box(iter_7_1)
    
            if var_7_6 < 1 then
                if not var_0_46(var_0_49, iter_7_1) then
                    table.insert(var_0_49, {
                        iter_7_1,
                        globals.tickcount()
                    })
                end
            elseif var_0_46(var_0_49, iter_7_1) then
                for iter_7_2, iter_7_3 in ipairs(var_0_49) do
                    if iter_7_3[1] == iter_7_1 then
                        table.remove(var_0_49, iter_7_2)
                    end
                end
            end
        end
    
        if not var_0_19(var_0_36) then
            return
        end
    
        if not var_0_19(var_0_38.dormantKey) then
            return
        end
    
        local var_7_7 = var_0_5()
        local var_7_8 = var_0_9(var_7_7)
    
        if not var_7_8 then
            return
        end
    
        local var_7_9 = var_0_32(var_7_8)
    
        if not var_7_9 or not var_0_33(var_7_9) then
            return
        end
    
        local var_7_10 = var_0_34(var_7_9)
    
        if not var_7_10 then
            return
        end
    
        local var_7_11 = var_0_30(var_0_1())
        local var_7_12 = var_0_10(var_7_7, "m_flSimulationTime")
        local var_7_13 = globals.tickcount()
        local var_7_14 = var_0_31(var_7_8)
        local var_7_15 = var_0_10(var_7_7, "m_bIsScoped") == 1
        local var_7_16 = bit.band(var_0_10(var_7_7, "m_fFlags"), bit.lshift(1, 0))
        local var_7_17 = var_0_45()
    
        if var_7_13 % #var_7_17 ~= 0 then
            var_0_52 = var_0_52 + 1
        else
            var_0_52 = 1
        end
    
        local var_7_18 = var_7_17[var_0_52]
    
        if not var_7_18 then
            var_0_48 = {}
    
            return
        end
    
        if var_7_13 < var_0_47 then
            var_0_48 = {}
    
            return
        end
    
        if var_7_14.type == "grenade" or var_7_14.type == "knife" then
            var_0_48 = {}
    
            return
        end
    
        if arg_7_0.in_jump == 1 and var_7_16 == 0 then
            var_0_48 = {}
    
            return
        end
    
        local var_7_19 = {}
        local var_7_20 = var_0_19(var_0_38.dormantAccuracy)
        local var_7_21 = entity.get_esp_data(var_7_18).health
        local var_7_22 = var_0_19(var_0_35.override_mindmg[1]) and var_0_19(var_0_35.override_mindmg[2])
        local var_7_23 = var_0_19(var_0_38.dormantMindmg) == 0 and not var_7_22 and var_0_19(var_0_35.mindmg) or var_0_19(var_0_38.dormantMindmg) == 0 and var_7_22 and var_0_19(var_0_35.override_mindmg[3]) or var_0_19(var_0_38.dormantMindmg)
    
        if var_7_23 > 100 then
            var_7_23 = var_7_23 - 100 + var_7_21
        end
    
        local var_7_24 = entity.get_prop(var_7_18, "m_flDuckAmount")
    
        for iter_7_4, iter_7_5 in ipairs(var_0_50) do
            if #var_7_0 ~= 0 then
                if var_0_42(var_7_0, iter_7_5.hitbox) then
                    if iter_7_5.hitbox == "Head" then
                        table.insert(var_7_19, {
                            vec = iter_7_5.vec - var_0_30(0, 0, var_7_24 * 10),
                            scale = iter_7_5.scale,
                            hitbox = iter_7_5.hitbox
                        })
                    elseif iter_7_5.hitbox == "Chest" then
                        table.insert(var_7_19, {
                            vec = iter_7_5.vec - var_0_30(0, 0, var_7_24 * 4),
                            scale = iter_7_5.scale,
                            hitbox = iter_7_5.hitbox
                        })
                    else
                        table.insert(var_7_19, {
                            vec = iter_7_5.vec,
                            scale = iter_7_5.scale,
                            hitbox = iter_7_5.hitbox
                        })
                    end
                end
            else
                table.insert(var_7_19, 1, {
                    vec = iter_7_5.vec,
                    scale = iter_7_5.scale,
                    hitbox = iter_7_5.hitbox
                })
            end
        end
    
        local var_7_25
    
        if var_7_14.is_revolver then
            var_7_25 = var_7_12 > var_0_10(var_7_8, "m_flNextPrimaryAttack")
        else
            var_7_25 = var_7_12 > var_0_16(var_0_10(var_7_7, "m_flNextAttack"), var_0_10(var_7_8, "m_flNextPrimaryAttack"), var_0_10(var_7_8, "m_flNextSecondaryAttack"))
        end
    
        if not var_7_25 then
            return
        end
    
        local var_7_26 = var_0_30(entity.get_origin(var_7_18))
        local var_7_27 = var_0_30(var_0_28(var_7_18, 4))
        local var_7_28, var_7_29, var_7_30, var_7_31, var_7_32 = entity.get_bounding_box(var_7_18)
    
        var_0_48[var_7_18] = nil
    
        for iter_7_6 = 1, 7 do
            if #var_7_0 ~= 0 and var_0_42(var_7_0, var_0_51[iter_7_6 - 1]) and var_0_26(var_7_18) and var_7_32 > 0 and math.abs(var_7_26.x - var_7_27.x) < 7 then
                table.insert(var_7_1, {
                    scale = 3,
                    hitbox = var_0_51[iter_7_6 - 1],
                    vec = var_0_30(var_0_28(var_7_18, iter_7_6 - 1))
                })
            end
        end
    
        if var_7_26.x and var_7_32 > 0 then
            local var_7_33
            local var_7_34
            local var_7_35
    
            if not (var_7_20 < math.floor(var_7_32 * 100) + 5) then
                return
            end
    
            local var_7_44
            local var_7_45
            local var_7_46
    
            if var_7_34 ~= nil then
                var_7_44 = var_7_33
                var_7_45 = var_7_34
                var_0_54 = var_7_35
                var_0_55 = nil
                var_0_56 = var_7_18
                var_0_57 = var_7_32
            else
                for iter_7_11, iter_7_12 in ipairs(var_7_19) do
                    local var_7_47 = var_7_26 + iter_7_12.vec
                    local var_7_48 = var_0_41(var_7_11, var_7_47, iter_7_12.scale)
    
                    for iter_7_13, iter_7_14 in ipairs(var_7_48) do
                        local var_7_49 = iter_7_14.vec
                        local var_7_50, var_7_51 = var_0_3(var_7_7, var_7_11.x, var_7_11.y, var_7_11.z, var_7_49.x, var_7_49.y, var_7_49.z, true)
    
                        if var_7_51 ~= 0 and var_7_23 < var_7_51 then
                            var_7_44 = var_7_49
                            var_7_45 = var_7_51
                            var_0_54 = iter_7_12.hitbox
                            var_0_55 = iter_7_14.text
                            var_0_56 = var_7_18
                            var_0_57 = var_7_32
    
                            break
                        end
                    end
    
                    if var_7_44 and var_7_45 then
                        break
                    end
                end
            end
    
            if not var_7_45 then
                return
            end
    
            if not var_7_44 then
                return
            end
    
            if var_0_0(var_7_44.x, var_7_44.y, var_7_44.z) then
                return
            end
    
            var_0_43(arg_7_0, (var_7_15 and var_7_14.max_player_speed_alt or var_7_14.max_player_speed) * 0.33)
    
            local var_7_52, var_7_53 = var_7_11:to(var_7_44):angles()
    
            if not var_7_15 and var_7_14.type == "sniperrifle" and arg_7_0.in_jump == 0 and var_7_16 == 1 then
                arg_7_0.in_attack2 = 1
            end
    
            var_0_48[var_7_18] = true
    
            if var_7_10 < 0.01 then
                arg_7_0.pitch = var_7_52
                arg_7_0.yaw = var_7_53
                arg_7_0.in_attack = 1
                var_0_53 = true
            end
        end
    end
    
    client.register_esp_flag("DA", 255, 255, 255, function(arg_8_0)
        if ui.get(var_0_36) and entity.is_alive(var_0_5()) then
            return var_0_48[arg_8_0]
        end
    end)
    client.set_event_callback("weapon_fire", function(arg_9_0)
        client.delay_call(0.03, function()
            local var_10_0 = entity.get_local_player()
    
            if client.userid_to_entindex(arg_9_0.userid) == var_10_0 then
                if var_0_53 and not var_0_58 then
                    client.fire_event("dormant_miss", {
                        userid = var_0_56,
                        aim_hitbox = var_0_54,
                        aim_point = var_0_55,
                        accuracy = var_0_57
                    })
                end
    
                var_0_58 = false
                var_0_53 = false
                var_0_54 = nil
                var_0_55 = nil
                var_0_56 = nil
                var_0_57 = nil
            end
        end)
    end)
    
    local function var_0_60(arg_11_0)
        local var_11_0 = client.userid_to_entindex(arg_11_0.userid)
        local var_11_1 = client.userid_to_entindex(arg_11_0.attacker)
        local var_11_2, var_11_3, var_11_4, var_11_5, var_11_6 = entity.get_bounding_box(client.userid_to_entindex(arg_11_0.userid))
    
        if var_11_1 == entity.get_local_player() and var_11_0 ~= nil and var_0_53 == true then
            var_0_58 = true
    
            client.fire_event("dormant_hit", {
                userid = var_11_0,
                attacker = var_11_1,
                health = arg_11_0.health,
                armor = arg_11_0.armor,
                weapon = arg_11_0.weapon,
                dmg_health = arg_11_0.dmg_health,
                dmg_armor = arg_11_0.dmg_armor,
                hitgroup = arg_11_0.hitgroup,
                accuracy = var_11_6,
                aim_hitbox = var_0_54
            })
        end
    end
    
    local function var_0_61()
        local var_12_0 = (cvar.mp_freezetime:get_float() + 1) / globals.tickinterval()
    
        var_0_47 = var_0_15() + var_12_0
    end
    
    local function var_0_62()
        local var_13_0 = ui.get(var_0_36)
    
        for iter_13_0, iter_13_1 in pairs(var_0_38) do
            ui.set_visible(iter_13_1, var_13_0)
        end
    end
    
    var_0_23(var_0_36, function()
        local var_14_0 = var_0_19(var_0_36)
        local var_14_1 = var_14_0 and client.set_event_callback or client.unset_event_callback
    
        if var_14_0 then
            ui.set(var_0_35.dormantEsp, var_14_0)
        end
    
        var_14_1("setup_command", var_0_59)
        var_14_1("round_prestart", var_0_61)
        var_14_1("player_hurt", var_0_60)
        var_0_62()
    end)
    var_0_62()
    
    local var_0_63 = 255
    local var_0_64 = 0
    local var_0_65 = 0
    local var_0_66 = 255
    local var_0_67 = 255
    local var_0_68 = 255
    local var_0_69 = 255
    local var_0_70 = 10
    local var_0_71 = {
        0,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        15,
        16,
        17,
        18
    }
    
    client.set_event_callback("paint", function()
        local var_15_0 = ({
            var_0_19(var_0_38.dormantKey)
        })[2]
    
        if not var_0_26(var_0_5()) then
            return
        end
    
        if var_0_19(var_0_36) and var_0_19(var_0_38.dormantKey) and var_0_19(var_0_38.dormantIndicator) then
            local var_15_1 = {
                255,
                255,
                255,
                200
            }
    
            for iter_15_0, iter_15_1 in pairs(var_0_48) do
                if iter_15_1 then
                    var_15_1 = {
                        143,
                        194,
                        21,
                        255
                    }
    
                    break
                end
            end
    
            if #var_0_45() == 0 then
                var_15_1 = {
                    255,
                    0,
                    50,
                    255
                }
            end
    
            var_0_17(var_15_1[1], var_15_1[2], var_15_1[3], var_15_1[4], "⎘ DA")
        end
    
        if var_0_19(var_0_38.dormantlastseen) then
            for iter_15_2, iter_15_3 in ipairs(var_0_49) do
                local var_15_2 = var_0_30(entity.get_origin(iter_15_3[1]))
                local var_15_3 = var_0_30(var_0_28(iter_15_3[1], 4))
                local var_15_4, var_15_5, var_15_6, var_15_7, var_15_8 = entity.get_bounding_box(iter_15_3[1])
                local var_15_9, var_15_10, var_15_11, var_15_12 = var_0_19(var_0_38.dormantlastseencolor)
    
                if var_15_8 > 0 and entity.is_dormant(iter_15_3[1]) and math.abs(var_15_2.x - var_15_3.x) < 7 then
                    client.draw_hitboxes(iter_15_3[1], 0.06, var_0_71, var_15_9, var_15_10, var_15_11, math.min(var_15_12, var_15_8 / 10 * var_15_12), globals.tickcount())
                end
            end
        end
    end)
    client.set_event_callback("dormant_hit", function(arg_16_0)
        if var_0_19(var_0_38.dormantLogs) then
            local var_16_0 = entity.get_player_name(arg_16_0.userid)
    
            if var_0_40[arg_16_0.hitgroup + 1] == arg_16_0.aim_hitbox or var_0_54 == "Head" then
                print(string.format("[DA] Hit %s in the %s for %i damage (%i health remaining) (%s accuracy)", var_16_0, var_0_39[arg_16_0.hitgroup + 1], arg_16_0.dmg_health, arg_16_0.health, string.format("%.0f", arg_16_0.accuracy * 100) .. "%"))
            else
                print(string.format("[DA] Hit %s in the %s for %i damage (%i health remaining) aimed=%s (%s accuracy)", var_16_0, var_0_39[arg_16_0.hitgroup + 1], arg_16_0.dmg_health, arg_16_0.health, arg_16_0.aim_hitbox, string.format("%.0f", arg_16_0.accuracy * 100) .. "%"))
            end
        end
    end)
    client.set_event_callback("dormant_miss", function(arg_17_0)
        if var_0_19(var_0_38.dormantLogs) then
            local var_17_0 = entity.get_player_name(arg_17_0.userid)
    
            if var_0_55 ~= nil then
                print(string.format("[DA] Missed %s's %s (mp=%s) (%s accuracy)", var_17_0, var_0_54, var_0_55, string.format("%.0f", arg_17_0.accuracy * 100) .. "%"))
            else
                print(string.format("[DA] Missed %s's %s (%s accuracy)", var_17_0, var_0_54, string.format("%.0f", arg_17_0.accuracy * 100) .. "%"))
            end
        end
    end)
    
end

do
    local accuracy_boost = ui.new_combobox('Rage', 'Aimbot', '\aFFFFFF90» \aFFFFFFFFAccuracy boost', { 'Low', 'Medium', 'High', 'Maximum' })
    local delay_shot = ui.new_checkbox('Rage', 'Aimbot', '\aFFFFFF90» \aFFFFFFFFDelay shot')
    local delay_shot_key = ui.new_hotkey('Rage', 'Aimbot', '\n Delay shot key', true)

    local ping_spike = ui.new_checkbox('Rage', 'Aimbot', '\aFFFFFF90» \aFFFFFFFFPing spike', 1)
    local ping_spike_key = ui.new_hotkey('Rage', 'Aimbot', '\nPing Spike Key', true)
    local ping_spike_val = ui.new_slider('Rage', 'Aimbot', '\nPing Spike Val', 1, 200, 100, true, 'ms')

    local function alwayson()
        ui.set(delay_shot_key, "Always on")
        ui.set(ping_spike_key, "Always on")
    end
    
    alwayson()

    client.set_event_callback('paint_ui', function ()
        ui.set(skeet.delay_shot, ui.get(delay_shot) and ui.get(delay_shot_key))
        ui.set(skeet.accuracy_boost, ui.get(accuracy_boost))

        do
            local active = ui.get(ping_spike_key)

            ui.set(skeet.ping_spike[1], ui.get(ping_spike))
            ui.set(skeet.ping_spike[2], active and 'Always on' or 'On hotkey')
            ui.set(skeet.ping_spike[3], ui.get(ping_spike_val))
        end
    end)

    local function ping_spike_cb()
        ui.set_visible(ping_spike_val, ui.get(ping_spike))
    end

    ui.set_callback(ping_spike, ping_spike_cb)
    ping_spike_cb()
end

local avoid_unsafe do
    avoid_unsafe = { }

    local list = { }

    local hitboxes = ui.new_multiselect('Rage', 'Aimbot', '\aFFFFFF90» \a7BE077FFAvoid unsafe on min. damage', { 'Head', 'Chest', 'Stomach', 'Arms', 'Legs', 'Feet' })

    function avoid_unsafe.backups()
        local prev = ui.get(skeet.weapon_type)

        for k, v in pairs(list) do
            ui.set(skeet.weapon_type, k)
            ui.set(skeet.avoid_unsafe, v)

            list[k] = nil
        end

        ui.set(skeet.weapon_type, prev)
    end

    function avoid_unsafe.set(weapon, value)
        if list[weapon] == nil then
            list[weapon] = ui.get(skeet.avoid_unsafe)
        end

        ui.set(skeet.avoid_unsafe, value)
    end

    client.set_event_callback('paint_ui', function ()
        local me = entity.get_local_player()
        if me == nil or not entity.is_alive(me) then
            return
        end

        local wpn = ui.get(skeet.weapon_type)

        if ui.get(skeet.damage_override[1]) and ui.get(skeet.damage_override[2]) then
            local value = ui.get(hitboxes)
            avoid_unsafe.set(wpn, value)
            return
        end

        if list[wpn] ~= nil then
            ui.set(skeet.avoid_unsafe, list[wpn])
            list[wpn] = nil
        end
    end)

    client.set_event_callback('shutdown', avoid_unsafe.backups)
    client.set_event_callback('pre_config_save', avoid_unsafe.backups)
end

local prefer_body_aim do
    prefer_body_aim = { }

    local list = { }

    local hitboxes = ui.new_multiselect('Rage', 'Aimbot', '\aFFFFFF90» \a7BE077FFBody aim disablers on min. damage', { 'Low inaccuracy', 'Target shot fired', 'Target resolved', 'Safe point headshot' })

    function prefer_body_aim.backups()
        local prev = ui.get(skeet.weapon_type)

        for k, v in pairs(list) do
            ui.set(skeet.weapon_type, k)
            ui.set(skeet.prefer_body_aim, v)

            list[k] = nil
        end

        ui.set(skeet.weapon_type, prev)
    end

    function prefer_body_aim.set(weapon, value)
        if list[weapon] == nil then
            list[weapon] = ui.get(skeet.prefer_body_aim)
        end

        ui.set(skeet.prefer_body_aim, value)
    end

    client.set_event_callback('paint_ui', function ()
        local me = entity.get_local_player()
        if me == nil or not entity.is_alive(me) then
            return
        end

        local wpn = ui.get(skeet.weapon_type)

        if ui.get(skeet.damage_override[1]) and ui.get(skeet.damage_override[2]) then
            local value = ui.get(hitboxes)
            prefer_body_aim.set(wpn, value)
            return
        end

        if list[wpn] ~= nil then
            ui.set(skeet.prefer_body_aim, list[wpn])
            list[wpn] = nil
        end
    end)

    client.set_event_callback('shutdown', prefer_body_aim.backups)
    client.set_event_callback('pre_config_save', prefer_body_aim.backups)
end

local hitchance do
    hitchance = { }
    local list = { }

    local master = ui.new_checkbox('Rage', 'Aimbot', '\aFFFFFF90⚙ \aE2FF89FFHitchance Manipulations')
    local on_hotkey = ui.new_slider('Rage', 'Aimbot', '\aFFFFFF90~ \aECFFB4FFOn Key Hitchance', 0, 100, 50, true, '%', 1, {[0] = 'Off'})
    local hotkey = ui.new_hotkey('Rage', 'Aimbot', '\n On Key Hitchance', true)
    local in_air = ui.new_slider('Rage', 'Aimbot', '\aFFFFFF90~ \aECFFB4FFIn Air', 0, 100, 50, true, '%', 1, {[0] = 'Off'})
    local no_scope = ui.new_slider('Rage', 'Aimbot', '\aFFFFFF90~ \aECFFB4FFNo Scope', 0, 100, 50, true, '%', 1, {[0] = 'Off'})

    local function alwayson()
        ui.set(hotkey, "Toggle")
    end
    
    alwayson()

    local can_scope = {
        ['G3SG1 / SCAR-20'] = true,
        ['SSG 08'] = true,
        ['AWP'] = true,
        ['Rifles'] = true
    }

    local function cb()
        local val = ui.get(master)
        local wpn = ui.get(skeet.weapon_type)

        ui.set_visible(on_hotkey, val)
        ui.set_visible(hotkey, val)
        ui.set_visible(in_air, val)
        ui.set_visible(no_scope, val and can_scope[wpn])
    end

    ui.set_callback(master, cb)
    ui.set_callback(hotkey, cb)

    cb()

    function hitchance.backups()
        local prev = ui.get(skeet.weapon_type)

        for k, v in pairs(list) do
            ui.set(skeet.weapon_type, k)
            ui.set(skeet.hitchance, v)

            list[k] = nil
        end

        ui.set(skeet.weapon_type, prev)
    end

    function hitchance.set(weapon, value)
        if list[weapon] == nil then
            list[weapon] = ui.get(skeet.hitchance)
        end

        ui.set(skeet.hitchance, value)
    end

    client.set_event_callback('paint_ui', function ()
        local me = entity.get_local_player()
        if me == nil or not entity.is_alive(me) then
            return
        end

        local wpn = ui.get(skeet.weapon_type)

        if ui.get(master) then
            if ui.get(hotkey) then
                local value = ui.get(on_hotkey)

                if value ~= 0 then
                    renderer.indicator(255, 255, 255, 200, '⚙︎ HC')
                    hitchance.set(wpn, value)
                    return
                end
            end

            if bit.band(entity.get_prop(me, 'm_fFlags'), 1) == 0 then
                local value = ui.get(in_air)

                if value ~= 0 then
                    hitchance.set(wpn, value)
                    return
                end
            end

            if can_scope[wpn] and entity.get_prop(me, 'm_bIsScoped') == 0 then
                local value = ui.get(no_scope)

                if value ~= 0 then
                    hitchance.set(wpn, value)
                    return
                end
            end
        end

        if list[wpn] ~= nil then
            ui.set(skeet.hitchance, list[wpn])
            list[wpn] = nil
        end
    end)

    client.set_event_callback('shutdown', hitchance.backups)
    client.set_event_callback('pre_config_save', hitchance.backups)
end

local overridedamage do
    overridedamage = { }

    local list = { }

    local overridedmg = ui.new_checkbox('Rage', 'Aimbot', '\aFFFFFF90⚙ \aE2FF89FFOverride Damage')
    local overridedmg_off = ui.new_checkbox('Rage', 'Aimbot', '\aFFFFFF90~ \aECFFB4FFDisable indicator')
    local overridedmg_on_hotkey = ui.new_slider('Rage', 'Aimbot', '\aFFFFFF90~ \aECFFB4FFOn Key Override Damage', 1, 105, 50, true, 'hp', 1, {[101] = '+1hp', [102] = '+2hp', [103] = '+3hp', [104] = '+4hp', [105] = '+5hp'})
    local overridedmg_hotkey = ui.new_hotkey('Rage', 'Aimbot', '\n On Key Override Damage', true)

    local function cb()
        local val = ui.get(overridedmg)
        local wpn = ui.get(skeet.weapon_type)

        ui.set_visible(overridedmg_off, val)
        ui.set_visible(overridedmg_on_hotkey, val)
        ui.set_visible(overridedmg_hotkey, val)
    end

    ui.set_callback(overridedmg, cb)
    ui.set_callback(overridedmg_hotkey, cb)

    cb()

    function overridedamage.backups()
        local prev = ui.get(skeet.weapon_type)

        for k, v in pairs(list) do
            ui.set(skeet.weapon_type, k)
            ui.set(skeet.damage, v)

            list[k] = nil
        end

        ui.set(skeet.weapon_type, prev)
    end

    function overridedamage.set(weapon, value)
        if list[weapon] == nil then
            list[weapon] = ui.get(skeet.damage)
        end

        ui.set(skeet.damage, value)
    end

    client.set_event_callback('paint_ui', function ()
        local me = entity.get_local_player()
        if me == nil or not entity.is_alive(me) then
            return
        end

        local wpn = ui.get(skeet.weapon_type)

        if ui.get(overridedmg) then
            if ui.get(overridedmg_hotkey) then
                local value = ui.get(overridedmg_on_hotkey)

                if value ~= 0 then
                    if not ui.get(overridedmg_off) then 
                        renderer.indicator(255, 255, 255, 200, '⚔︎ DMG')
                    end
                    overridedamage.set(wpn, value)
                    return
                end
            end
        end

        if list[wpn] ~= nil then
            ui.set(skeet.damage, list[wpn])
            list[wpn] = nil
        end
    end)

    client.set_event_callback('shutdown', overridedamage.backups)
    client.set_event_callback('pre_config_save', overridedamage.backups)
end

local early do
    early = { }

    local list = { }

    local enabled = ui.new_checkbox('Rage', 'Aimbot', '\aFFFFFF90» \aFFFFFFFFEarly on auto peek')

    function early.backups()
        local prev = ui.get(skeet.weapon_type)

        for k, v in pairs(list) do
            ui.set(skeet.weapon_type, k)
            ui.set(skeet.auto_stop, v)

            list[k] = nil
        end

        ui.set(skeet.weapon_type, prev)
    end

    function early.set(weapon, value)
        if list[weapon] == nil then
            list[weapon] = ui.get(skeet.auto_stop)
        end

        ui.set(skeet.auto_stop, value)
    end

    client.set_event_callback('paint_ui', function ()
        local me = entity.get_local_player()
        if me == nil or not entity.is_alive(me) then
            return
        end

        local wpn = ui.get(skeet.weapon_type)

        if ui.get(enabled) then
            if ui.get(skeet.auto_peek[1]) and ui.get(skeet.auto_peek[2]) then
                local convert = table.convert(ui.get(skeet.auto_stop))
                if not convert['Early'] then
                    convert['Early'] = true
                end

                early.set(wpn, table.invert(convert))
                return
            end
        end

        if list[wpn] ~= nil then
            ui.set(skeet.auto_stop, list[wpn])
            list[wpn] = nil
        end
    end)

    client.set_event_callback('shutdown', early.backups)
    client.set_event_callback('pre_config_save', early.backups)
end

local deagle do
    deagle = { }

    local list = { }

    local enabled = ui.new_checkbox('Rage', 'Aimbot', '\aFFFFFF90» \aFFFFFFFFDT on Deagle')

    local function cb()
        ui.set_visible(enabled, ui.get(skeet.weapon_type) == 'Desert Eagle')
    end

    ui.set_callback(skeet.weapon_type, cb)
    cb()

    function deagle.backups()
        local prev = ui.get(skeet.weapon_type)

        for k, v in pairs(list) do
            ui.set(skeet.weapon_type, k)
            ui.set(skeet.dt[2], v)

            list[k] = nil
        end

        ui.set(skeet.weapon_type, prev)
    end

    local hotkey_modes = { [0] = 'Always on', "On hotkey", "Toggle", "Off hotkey" }

    function deagle.set(weapon, value)
        if list[weapon] == nil then
            local is_active, mode = ui.get(skeet.dt[2])
            list[weapon] = hotkey_modes[ mode ]
        end

        ui.set(skeet.dt[2], value)
    end

    client.set_event_callback('paint_ui', function ()
        local me = entity.get_local_player()
        if me == nil or not entity.is_alive(me) then
            return
        end

        local weapon = entity.get_player_weapon(me)
        if weapon == nil then
            return
        end

        local classname = entity.get_classname(weapon)
        local wpn = ui.get(skeet.weapon_type)

        if ui.get(enabled) then
            if wpn == 'Desert Eagle' and classname == 'CDEagle' then
                deagle.set(wpn, ui.get(skeet.hide[2]) and 'On hotkey' or 'Always on')
                return
            end
        end

        if list[wpn] ~= nil then
            ui.set(skeet.dt[2], list[wpn])
            list[wpn] = nil
        end
    end)

    client.set_event_callback('shutdown', deagle.backups)
    client.set_event_callback('pre_config_save', deagle.backups)
end

local scout do
    scout = { }

    local list = { }

    local airstop_keybind = ui.new_hotkey("RAGE", "Aimbot", "\aFFFFFF90☁ \a85DFF6FFScout autostop in air", false)

    local function cb()
        ui.set_visible(airstop_keybind, ui.get(skeet.weapon_type) == 'SSG 08')
    end

    ui.set_callback(skeet.weapon_type, cb)
    cb()

    local function L_3_func(L_149_arg0, L_150_arg1)
        local L_151_, L_152_ = pcall(require, L_149_arg0)
        if L_151_ then
            return L_152_
        else
            return error(L_150_arg1)
        end
    end;
    
    local L_5_ = L_3_func("bit")
    local L_9_ = L_3_func("vector", "Missing vector")
    local L_13_ = L_3_func("gamesense/csgo_weapons", "Download CS:GO weapon data library: https://gamesense.pub/forums/viewtopic.php?id=18807")
    
    local function L_57_func(L_349_arg0)
        local L_350_ = entity.get_local_player()
        local L_351_, L_352_, L_353_ = entity.hitbox_position(L_350_, 0)
        local L_354_, L_355_, L_356_ = entity.hitbox_position(L_349_arg0, 0)
        local L_357_, L_358_ = client.trace_line(L_350_, L_351_, L_352_, L_353_, L_354_, L_355_, L_356_)
        return L_357_ > 0.65
    end;
    
    local L_37_ = {
        antiaim = {
            slow_motion = {
                ui.reference("AA", "Other", "Slow motion")
            },
        }
    }
    
    function create_data(L_211_arg0, L_212_arg1)
        return {
            flags = L_211_arg0 or 0,
            velocity = L_212_arg1 or L_9_()
        }
    end;
    
    local L_52_ = {
        lp = entity.get_local_player(),
        ground_ticks = 0
    }
    
    client.set_event_callback("paint", function()
        if ui.get(airstop_keybind) then
            renderer.indicator(255, 255, 255, 200, "☁️")
        end
    end)
    
    function L_52_:is_on_ground()
        lp = entity.get_local_player()
        if not lp then
            return
        end;
        local L_339_ = entity.get_prop(lp, "m_fFlags")
        if L_5_.band(L_339_, 1) == 0 then
            L_52_.ground_ticks = 0
        elseif L_52_.ground_ticks <= 45 then
            L_52_.ground_ticks = L_52_.ground_ticks + 1
        end;
        return L_52_.ground_ticks >= 45
    end;
    
    local function L_24_func(L_209_arg0)
        return globals.curtime() >= entity.get_prop(L_209_arg0, "m_flNextAttack")
    end;
    local function L_25_func(L_210_arg0)
        return globals.curtime() >= entity.get_prop(L_210_arg0, "m_flNextPrimaryAttack")
    end
    
    local function L_26_func(L_213_arg0, L_214_arg1)
        local L_215_ = math.sin(math.rad(L_214_arg1))
        local L_216_ = math.cos(math.rad(L_214_arg1))
        local L_217_ = math.sin(math.rad(L_213_arg0))
        local L_218_ = math.cos(math.rad(L_213_arg0))
        return L_218_ * L_216_, L_218_ * L_215_, - L_217_
    end;
    
    local L_27_ = create_data()
    
    local function L_29_func(L_219_arg0, L_220_arg1)
        local L_221_ = entity.get_local_player()
        if L_221_ == nil then
            return
        end;
        local L_222_ = L_27_.velocity;
        local L_223_ = L_222_:length2d()
        local L_224_ = L_9_(L_222_:angles())
        local L_225_ = L_9_(client.camera_angles())
        L_224_.y = L_225_.y - L_224_.y;
        local L_226_ = L_9_(L_26_func(L_224_.x, L_224_.y))
        local L_227_ = - cvar.cl_sidespeed:get_float()
        local L_228_ = L_227_ * L_226_;
        L_219_arg0.in_speed = 1;
        L_219_arg0.forwardmove = L_228_.x;
        L_219_arg0.sidemove = L_228_.y
    end
    
    client.set_event_callback("setup_command", function(L_781_arg0)
        if not ui.get(airstop_keybind) then
            return
        end;
        local L_782_ = entity.get_local_player()
        local L_783_ = client.current_threat()
        if L_782_ == nil or L_783_ == nil then
            return
        end;
        airstop = false;
        local L_784_ = entity.get_player_weapon(L_782_)
        if L_784_ == nil then
            return
        end;
        local L_785_ = entity.get_classname(L_784_)
        if L_785_ ~= "CWeaponSSG08" then
            return
        end;
        if not L_24_func(L_782_) or not L_25_func(L_784_) then
            return
        end;
        local L_786_ = L_13_(L_784_)
        local L_787_ = L_9_(entity.get_origin(L_782_))
        local L_788_ = L_9_(entity.get_origin(L_783_))
        local L_789_ = 1;
        local L_790_, L_791_ = client.trace_bullet(L_782_, L_787_.x, L_787_.y, 0, L_788_.x, L_788_.y, 0)
        local L_792_ = entity.get_prop(L_783_, "m_iHealth")
        if L_791_ < L_789_ then
            return
        end;
        if not L_57_func(L_783_) then
            return
        end;
        if L_52_:is_on_ground() then
            return
        end;
        airstop = true;
        ui.set(L_37_.antiaim.slow_motion[1], true)
        L_29_func(L_781_arg0, 0)
    end)
end

local Jumpscouto do
    Jumpscouto = { }

    local list = { }

    local jumpscout_checkbox = ui.new_checkbox("RAGE", "Aimbot", "\aFFFFFF90» \aFFFFFFFFJumpscout", false)

    local function cb()
        ui.set_visible(jumpscout_checkbox, ui.get(skeet.weapon_type) == 'SSG 08')
    end
    
    ui.set_callback(skeet.weapon_type, cb)
    cb()

    local air_strafe_ref = ui.reference("MISC", "Movement", "Air strafe")
    local air_strafe_direction_ref = ui.reference("MISC", "Movement", "Air strafe direction")

    local function is_holding_ssg08()
        local local_player = entity.get_local_player()
        
        if not local_player then
            return false
        end
    
        local weapon_ent = entity.get_player_weapon(local_player)
        local weapon_name = entity.get_classname(weapon_ent)
        
        return weapon_name == "CWeaponSSG08"
    end

    local function is_player_alive()
        local local_player = entity.get_local_player()
        
        if not local_player then
            return false
        end
        
        return entity.get_prop(local_player, "m_iHealth") > 0
    end

    local function update_air_strafe_direction()
        local local_player = entity.get_local_player()
        
        if not ui.get(jumpscout_checkbox) or not local_player or not is_player_alive() or not is_holding_ssg08() then
            local current_values = ui.get(air_strafe_direction_ref)
            if not table.contains(current_values, "View angles") then
                table.insert(current_values, "View angles")
                ui.set(air_strafe_direction_ref, unpack(current_values))
            end
            return
        end
        
        local on_ground = entity.get_prop(local_player, "m_fFlags") and 1 ~= 0
        local speed = math.sqrt(entity.get_prop(local_player, "m_vecVelocity[0]")^2 + entity.get_prop(local_player, "m_vecVelocity[1]")^2)
        
        local current_values = ui.get(air_strafe_direction_ref)
        
        if on_ground and speed < 10 then
            local new_values = {}
            for i, v in ipairs(current_values) do
                if v ~= "View angles" then
                    table.insert(new_values, v)
                end
            end
            ui.set(air_strafe_direction_ref, unpack(new_values))
        else
            if not table.contains(current_values, "View angles") then
                table.insert(current_values, "View angles")
                ui.set(air_strafe_direction_ref, unpack(current_values))
            end
        end
    end

    function table.contains(table, element)
        for _, value in pairs(table) do
            if value == element then
                return true
            end
        end
        return false
    end

    local function enable_view_angles_on_load()
        local current_values = ui.get(air_strafe_direction_ref)
        if not table.contains(current_values, "View angles") then
            table.insert(current_values, "View angles")
            ui.set(air_strafe_direction_ref, unpack(current_values))
        end
    end

    enable_view_angles_on_load()

    client.set_event_callback("paint", update_air_strafe_direction)
    client.set_event_callback("shutdown", enable_view_angles_on_load)
end

label2 = ui.new_label('Rage', 'Other', '\aFFFFFFFF✧--------------Aimtool$ Section--------------✧')
--Sync rage bob binds
local synckeys do
    synckeys = { }

    local list = { }

    local var_0_0 = false
    local var_0_1 = {
        [0] = "Always on",
        "On hotkey",
        "Toggle",
        "Off hotkey"
    }
    local var_0_2 = {
        "Global",
        "G3SG1 / SCAR-20",
        "SSG 08",
        "AWP",
        "R8 Revolver",
        "Desert Eagle",
        "Pistol",
        "Zeus",
        "Rifle",
        "Shotgun",
        "SMG",
        "Machine gun"
    }
    local var_0_3 = ui.new_checkbox("RAGE", "Other", "\aFFFFFF90$$ \aFFFFFFFFSync rabebot keybinds")
    local var_0_4 = ui.reference("RAGE", "Weapon type", "Weapon type")
    
    local function var_0_5(arg_1_0)
        if var_0_0 and ui.get(var_0_3) then
            local var_1_0, var_1_1, var_1_2 = ui.get(arg_1_0)
    
            if var_1_2 == nil then
                var_1_2 = 0
            end
    
            local var_1_3 = var_0_1[var_1_1]
            local var_1_4 = ui.get(var_0_4)
    
            for iter_1_0, iter_1_1 in ipairs(var_0_2) do
                ui.set(var_0_4, iter_1_1)
                ui.set(arg_1_0, var_1_3)
                ui.set(arg_1_0, nil, var_1_2)
            end
    
            ui.set(var_0_4, var_1_4)
        end
    end
    
    local function var_0_6()
        var_0_0 = false
    end
    
    local function var_0_7()
        var_0_0 = true
    end
    
    client.set_event_callback("pre_config_load", var_0_6)
    client.set_event_callback("pre_config_save", var_0_6)
    client.set_event_callback("post_config_load", var_0_7)
    client.set_event_callback("post_config_save", var_0_7)
    
    local var_0_8 = {
        select(2, ui.reference("RAGE", "Aimbot", "Enabled")),
        select(2, ui.reference("RAGE", "Aimbot", "Multi-point")),
        select(2, ui.reference("RAGE", "Aimbot", "Minimum damage override")),
        select(1, ui.reference("RAGE", "Aimbot", "Force safe point")),
        select(1, ui.reference("RAGE", "Aimbot", "Force body aim")),
        select(2, ui.reference("RAGE", "Aimbot", "Quick stop")),
        select(2, ui.reference("RAGE", "Aimbot", "\aFFFFFF90☩︎ \aAA8DF6FFDormant aimbot")),
        (select(2, ui.reference("RAGE", "Aimbot", "Double tap")))
    }
    
    for iter_0_0, iter_0_1 in ipairs(var_0_8) do
        if ui.type(iter_0_1) == "hotkey" then
            ui.set_callback(iter_0_1, var_0_5)
        else
            print("invalid hotkey: ", iter_0_0, " ", iter_0_1)
        end
    end
    
    var_0_0 = true    
end

--MENU SETTINGS ON START 

local labelmenusafe = ui.new_label("MISC", "Settings", "\a3B3B3BFF~ for crack users ~")

local menucolorcheckbox = ui.new_checkbox("MISC", "Settings", "\aFFFFFF90☀ \a9FCA2BFFSave ur menu color")
local menucolorpicker = ui.new_color_picker("MISC", "Settings", "\n Save ur menu color", 159, 202, 43, 255)
local menu_color = ui.reference("MISC", "Settings", "Menu color")

local menu_lock_enabled = ui.new_checkbox("MISC", "Settings", "\aFFFFFF90◲ \a9FCA2BFFLock menu layout")
local lock_menu_layout = ui.reference("MISC", "Settings", "Lock menu layout")

local dpiscale = ui.new_combobox("MISC", "Settings", "\aFFFFFF90⊞ \a9FCA2BFFDPI scale", { "100%", "125%", "150%", "175%", "200%" })
local dpiscaleref = ui.reference("MISC", "Settings", "DPI scale", { "100%", "125%", "150%", "175%", "200%" })

local function menucolor_picker()
    if ui.get(menucolorcheckbox) then
        ui.set_visible(menucolorpicker, true)
    else
        ui.set_visible(menucolorpicker, false)
    end

    if ui.get(menucolorcheckbox) then
        local r, g, b, a = ui.get(menucolorpicker)  
        ui.set(menu_color, r, g, b, a)
    end
end

local function dpiscale_enabler()
    if ui.get(dpiscale) == "100%" then
        ui.set(dpiscaleref, "100%")
    end

    if ui.get(dpiscale) == "125%" then
        ui.set(dpiscaleref, "125%")
    end

    if ui.get(dpiscale) == "150%" then
        ui.set(dpiscaleref, "150%")
    end

    if ui.get(dpiscale) == "175%" then
        ui.set(dpiscaleref, "175%")
    end

    if ui.get(dpiscale) == "200%" then
        ui.set(dpiscaleref, "200%")
    end
end

local function menu_layout_enabler()
    if ui.get(menu_lock_enabled) then
        ui.set(lock_menu_layout, true)
    else
        ui.set(lock_menu_layout, false)
    end
end

client.set_event_callback("paint_ui", function()
    menucolor_picker()
    menu_layout_enabler()
    dpiscale_enabler()
end)
