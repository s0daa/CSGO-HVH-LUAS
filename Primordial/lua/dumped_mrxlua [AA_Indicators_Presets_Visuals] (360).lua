local ground_tick, end_time = 1, 0
    local version = "0.0.1"
    local hitlogsList = {}
    client.log_screen(color_t(246, 214, 255), "[mrx.lua]", color_t(0, 128, 0), "Hey, ".. user.name)
    client.log_screen(color_t(246, 214, 255), "[mrx.lua]", color_t(0, 128, 0), "Version -> ".. version)
    client.log_screen(color_t(246, 214, 255), "[mrx.lua]", color_t(0, 128, 0), "Our discord -> https://discord.gg/PsTgaEBNge")
    engine.execute_cmd("playvol \"survival/buy_item_01.wav\" 1")
    ----func----
    local helpers = {
        lerp = function(self, start, end_pos, time, delta)
            if (math.abs(start - end_pos) < (delta or 0.01)) then return end_pos end

            time = global_vars.frame_time() * (time * 175) 
            if time < 0 then
            time = 0.01
            elseif time > 1 then
            time = 1
            end
            return ((end_pos - start) * time + start)
        end,
    }
    function colorLuaNameInvert(side, color_picker)
        local r, g, b, a = 255, 255, 255, 255
        local color = color_t(255, 255, 255, 255)
        if (antiaim.get_desync_side() == 1 and side == 'left') then
            color = color_picker
        end
        if (antiaim.get_desync_side() == 2 and side == 'right') then
            color = color_picker
        end
        return color
    end

    function type_writer(text, speed)
        local length = text:len()
        length = length
        local delay = global_vars.cur_time() * speed % length

        return string.sub(text, 1, delay)
    end
    function type_writer_array(array, speed)
        local length = table.getn(array)
        local delay = global_vars.cur_time() * speed % length
        return array[math.floor(delay)]
    end
    function getTypeByWeapon(weapon)
        local type
        if weapon == 'scar20' or weapon == 'g3sg1' then
            type = 'auto'
        elseif weapon == 'ssg08' then
            type = 'scout'
        elseif weapon == 'awp' then
            type = 'awp'
        elseif weapon == 'deagle' then
            type = 'deagle'
        elseif weapon == 'revolver' then
            type = 'revolver'
        elseif weapon == 'glock' or weapon == 'elite' or weapon == 'tec9'
            or weapon == 'usp-s'
            or weapon == 'fiveseven'
            or weapon == 'cz75a'
            or weapon == 'p250'
            or weapon == 'p2000' then
            type = 'pistols'
        elseif weapon == 'p90'
            or weapon == 'bizon'
            or weapon == 'ump45'
            or weapon == 'mp7'
            or weapon == 'mp9'
            or weapon == 'mac10'
            or weapon == 'galilar'
            or weapon == 'famas'
            or weapon == 'ak47'
            or weapon == 'm4a1'
            or weapon == 'm4a1-s'
            or weapon == 'sg556'
            or weapon == 'aug'
            or weapon == 'negev'
            or weapon == 'm249'
            or weapon == 'mag7'
            or weapon == 'sawedoff'
            or weapon == 'xm1014'
            or weapon == 'nova'
        then
            type = 'other'
        else
            type = 'null'
        end
        return type
    end

    function set_visible_group(table, status)
        for index, value in pairs(table) do
            value:set_visible(status)
        end
    end
    function dump(o)
        if type(o) == 'table' then
            local s = '{ '
            for k, v in pairs(o) do
                if type(k) ~= 'number' then k = '"' .. k .. '"' end
                s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
            end
            return s .. '} '
        else
            return tostring(o)
        end
    end
    ----------------------
    local ref = {
        aim = {
            dt = menu.find("aimbot", "general", "exploits", "doubletap", "enable"),
            onshot = menu.find("aimbot", "general", "exploits", "hideshots", "enable"),
            ping = menu.find("aimbot", "general", "fake ping", "enable"),
            peek = menu.find("aimbot", "general", "misc", "autopeek"), 
            rollresolver = menu.find("aimbot", "general", "aimbot", "body lean resolver"), 
            overrideresolver = menu.find("aimbot", "general", "aimbot", "override resolver"), 
            lagcomp = menu.find("aimbot", "general", "exploits", "force prediction"), 
        },
        weapons = {
            auto = {
                dmg = menu.find("aimbot", "auto", "target overrides", "force min. damage"),
                hitbox = menu.find("aimbot", "auto", "target overrides", "force hitbox"),
                safepoint = menu.find("aimbot", "auto", "target overrides", "force safepoint")
            },
            scout = {
                dmg = menu.find("aimbot", "scout", "target overrides", "force min. damage"),
                hitbox = menu.find("aimbot", "scout", "target overrides", "force hitbox"),
                safepoint = menu.find("aimbot", "scout", "target overrides", "force safepoint")
            },
            awp = {
                dmg = menu.find("aimbot", "awp", "target overrides", "force min. damage"),
                hitbox = menu.find("aimbot", "awp", "target overrides", "force hitbox"),
                safepoint = menu.find("aimbot", "awp", "target overrides", "force safepoint")
            },
            deagle = {
                dmg = menu.find("aimbot", "deagle", "target overrides", "force min. damage"),
                hitbox = menu.find("aimbot", "deagle", "target overrides", "force hitbox"),
                safepoint = menu.find("aimbot", "deagle", "target overrides", "force safepoint")
            },
            revolver = {
                dmg = menu.find("aimbot", "revolver", "target overrides", "force min. damage"),
                hitbox = menu.find("aimbot", "revolver", "target overrides", "force hitbox"),
                safepoint = menu.find("aimbot", "revolver", "target overrides", "force safepoint")
            },
            pistols = {
                dmg = menu.find("aimbot", "pistols", "target overrides", "force min. damage"),
                hitbox = menu.find("aimbot", "pistols", "target overrides", "force hitbox"),
                safepoint = menu.find("aimbot", "pistols", "target overrides", "force safepoint")
            },
            other = {
                dmg = menu.find("aimbot", "other", "target overrides", "force min. damage"),
                hitbox = menu.find("aimbot", "other", "target overrides", "force hitbox"),
                safepoint = menu.find("aimbot", "other", "target overrides", "force safepoint")
            }
        },
        aa = {
            fd = menu.find("antiaim", "main", "general", "fake duck"),
            pitch = menu.find("antiaim", "main", "angles", "pitch"),
            yawbase = menu.find("antiaim", "main", "angles", "yaw base"),
            yawadd = menu.find("antiaim", "main", "angles", "yaw add"),
            rotate = menu.find("antiaim", "main", "angles", "ratate"),
            jittermode = menu.find("antiaim", "main", "angles", "jitter mode"),
            jittertype = menu.find("antiaim", "main", "angles", "jitter type"),
            jitteradd = menu.find("antiaim", "main", "angles", "jitter add"),
            rolltype = menu.find("antiaim", "main", "angles", "body lean"),
            rolldeg = menu.find("antiaim", "main", "angles", "body lean value"),
            rollinmove = menu.find("antiaim", "main", "angles", "moving body lean"),
            freestanding = menu.find("antiaim", "main", "auto direction", "enable"),
            rollpitch = menu.find("antiaim", "main", "extended angles", "enable"),
            rollpitchValue = menu.find("antiaim", "main", "extended angles", "pitch"),
            rollpitchType = menu.find("antiaim", "main", "extended angles", "type"),
            rollpitchOffset = menu.find("antiaim", "main", "extended angles", "offset"),
            manualLeft = menu.find("antiaim", "main", "manual", "left"),
            manualRight = menu.find("antiaim", "main", "manual", "right"),
            manualBack  = menu.find("antiaim", "main", "manual", "back")
        }
    }
    local mainTab = {
        Enable = menu.add_checkbox("Main", "Enable mrxlua", false),
        menu.add_text("Main", "mrx lua version 0.0.1"),
        menu.add_text("Main", "Discord: https://discord.gg/PsTgaEBNge")
    }
    local visualTab = {
        hitlogs = menu.add_checkbox("Visual", "Hitlogs in HUD", false),
        watermark = menu.add_checkbox("Visual", "watermark", false),
        indicator = menu.add_checkbox("Visual", "Indicators", false),
        indicatorsList = menu.add_multi_selection("Visual", "Indicators", { "lua name", "State", "DT", "peek", "FD", "onshot", "force body", "fake ping", "min dmg", "hitbox override", "safe point" }),
        indicatorsListFonts = menu.add_selection("Visual", "Indicators Font Style", { "ITALIC", "UNDERLINE", "SYMBOL", "ANTIALIAS", "GAUSSIANBLUR", "ROTARY", "DROPSHADOW", "ADDITIVE", "OUTLINE" }),
        keybinds = menu.add_checkbox("Visual", "Keybinds", false),
        staticlegs = menu.add_checkbox("Visual", "Static legs in air And Pitch", false),
        defwatermark = menu.add_checkbox("Visual", "Disable standard primordial watermark",false);
        manualArrows = menu.add_checkbox("Visual", "Manual AA Arrows",false),
        sideLine = menu.add_checkbox("Visual", "Desync Side line", false)
    }

    local colorsTab = {
        indicators = visualTab.indicator:add_color_picker(""),
        keybinds = visualTab.keybinds:add_color_picker(""),
        watermark = visualTab.watermark:add_color_picker(""),
        manualArrows = visualTab.manualArrows:add_color_picker(""),
        sideLine = visualTab.sideLine:add_color_picker("")
    }
    local CustomAA = {
        Condition = menu.add_selection("CustomAA", "Condition", { "Stand", "Move", "Jump", "Duck" }),
    }
    local ConditionAA = {
        Stand = {
            pitch = menu.add_selection("CustomAA", "Pitch", { "none", "down", "up", "zero", "jitter" }),
            yawbase = menu.add_selection("CustomAA", "Yaw Base", { "none", "viewangle", "at target (crosshair)", "at target (distance)", "velocity" }),
            yawAdd = menu.add_slider("CustomAA", "Yaw add", -180, 180),
            jitterMode = menu.add_selection("CustomAA", "Jitter Mode", { "none", "static", "random" }),
            jitterType = menu.add_selection("CustomAA", "Jitter Type", { "offset", "center" }),
            jitterAdd = menu.add_slider("CustomAA", "Jitter Add", -180, 180),
            rollType = menu.add_selection("CustomAA", "Roll type", { "none", "static", "static jitter", "random jitter", "sway" }),
            rollDeg = menu.add_slider("CustomAA", "Roll Degrees", -50, 50)
        },
        Move = {
            pitch = menu.add_selection("CustomAA", "Pitch", { "none", "down", "up", "zero", "jitter" }),
            yawbase = menu.add_selection("CustomAA", "Yaw Base", { "none", "viewangle", "at target (crosshair)", "at target (distance)", "velocity" }),
            yawAdd = menu.add_slider("CustomAA", "Yaw add", -180, 180),
            jitterMode = menu.add_selection("CustomAA", "Jitter Mode", { "none", "static", "random" }),
            jitterType = menu.add_selection("CustomAA", "Jitter Type", { "offset", "center" }),
            jitterAdd = menu.add_slider("CustomAA", "Jitter Add", -180, 180),
            rollType = menu.add_selection("CustomAA", "Roll type", { "none", "static", "static jitter", "random jitter", "sway" }),
            rollDeg = menu.add_slider("CustomAA", "Roll Degrees", -50, 50),
            rollInMove = menu.add_checkbox("CustomAA", "Roll in move", false)
        },
        Jump = {
            pitch = menu.add_selection("CustomAA", "Pitch", { "none", "down", "up", "zero", "jitter" }),
            yawbase = menu.add_selection("CustomAA", "Yaw Base", { "none", "viewangle", "at target (crosshair)", "at target (distance)", "velocity" }),
            yawAdd = menu.add_slider("CustomAA", "Yaw add", -180, 180),
            jitterMode = menu.add_selection("CustomAA", "Jitter Mode", { "none", "static", "random" }),
            jitterType = menu.add_selection("CustomAA", "Jitter Type", { "offset", "center" }),
            jitterAdd = menu.add_slider("CustomAA", "Jitter Add", -180, 180),
            rollType = menu.add_selection("CustomAA", "Roll type", { "none", "static", "static jitter", "random jitter", "sway" }),
            rollDeg = menu.add_slider("CustomAA", "Roll Degrees", -50, 50),
            rollInMove = menu.add_checkbox("CustomAA", "Roll in move", false)
        },
        Duck = {
            pitch = menu.add_selection("CustomAA", "Pitch", { "none", "down", "up", "zero", "jitter" }),
            yawbase = menu.add_selection("CustomAA", "Yaw Base", { "none", "viewangle", "at target (crosshair)", "at target (distance)", "velocity" }),
            yawAdd = menu.add_slider("CustomAA", "Yaw add", -180, 180),
            jitterMode = menu.add_selection("CustomAA", "Jitter Mode", { "none", "static", "random" }),
            jitterType = menu.add_selection("CustomAA", "Jitter Type", { "offset", "center" }),
            jitterAdd = menu.add_slider("CustomAA", "Jitter Add", -180, 180),
            rollType = menu.add_selection("CustomAA", "Roll type", { "none", "static", "static jitter", "random jitter", "sway" }),
            rollDeg = menu.add_slider("CustomAA", "Roll Degrees", -50, 50),
            rollInMove = menu.add_checkbox("CustomAA", "Roll in move", false)
        }
    }

    local aaTab = {
        switchside = menu.add_checkbox("AA", "random switch desync side", false),
        presets = menu.add_selection("AA", "Presets", { "none","by MrNik", "ROLL pitch", "Custom" }),
    }
    local setup = {
        colorsTab.indicators:set(color_t(246, 214, 255, 255)),
        colorsTab.keybinds:set(color_t(246, 214, 255, 255)),
        colorsTab.watermark:set(color_t(246, 214, 255, 255)),
        colorsTab.sideLine:set(color_t(246, 214, 255)),
        colorsTab.manualArrows:set(color_t(246, 214, 255)),
        visualTab.indicatorsListFonts:set(9)
    }
    local globals = {
        crouching          = false,
        standing           = false,
        jumping            = false,
        running            = false,
        pressing_move_keys = false
    }
    local animate = {
        time = 0,
        stop = false
    }
    local as = 0
    local ClanTag = {
        " ",
        "  m",
        "  mr",
        "  mrx",
        "  mrx.",
        "  mrx.l",
        "  mrx.lu",
        "  mrx.lua",
        "  mrx.lu$",
        "  mrx.l$",
        "  mrx.$",
        "  mrx$",
        "  mr$",
        "  m$",
        "  $",
        "  ---",
        "      "
    }
    local hitgroup = {
        "GENERIC","HEAD",'CHEST','STOMACH','LEFT_ARM','RIGHT_ARM','LEFT_LEG','RIGHT_LEG','NECK','GEAR'
    }
    local setupLastValue = {
        manuals = {
            yawadd = nil
        }
    }
    menu.set_group_visibility("CustomAA", false)
    local function on_paint()
        local textSize, font, textWidth, textHeight, text, list, margin, padding, playerState
        local activeBindsList = {}
        local keybindsList = {}
        local x = render.get_screen_size().x
        local y = render.get_screen_size().y
        local r, g, b, a
        if mainTab.Enable:get() ~= true then return end
        if menu.is_open() then
            font = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW)
            text = "[mrx.lua] "..user.name.." you have subscription to lua"
            text = type_writer(text,1)
            render.rect_fade(vec2_t(menu.get_pos().x, menu.get_pos().y-25), vec2_t(menu.get_size().x, 20), color_t(20, 19, 19), color_t(20, 19, 19, 100))
            textSize = render.get_text_size(font, text)
            local renderWtextMenu = menu.get_pos().x+(menu.get_size().x/2) - (textSize.x/2)
            render.text(font, text, vec2_t(renderWtextMenu, menu.get_pos().y-5-(textSize.y)), color_t(255, 255, 255, 255))
        end
        if not engine.is_in_game() then return end
        local local_player = entity_list.get_local_player()
        if not local_player:is_alive() then return end
        if local_player:get_active_weapon() == nil then return end
        local weapon = local_player:get_active_weapon():get_name()
        local weaponType = getTypeByWeapon(weapon)
        local AAconditionId = CustomAA.Condition:get()
        local AAconditionName = CustomAA.Condition:get_item_name(AAconditionId)
        local scope = local_player:get_prop("m_bIsScoped") == 1
        local hours, minutes, seconds = client.get_local_time()
        local latency = math.floor(engine.get_latency(e_latency_flows.OUTGOING) * 1000)
        local PresetId = aaTab.presets:get()
        if globals.jumping then
            playerState = "~jump~"
        elseif globals.running then
            playerState = "~walk~"
        elseif globals.standing then
            playerState = "~stand~"
        elseif globals.crouching then
            playerState = "~duck~"
        end
        if PresetId == 4 then
            menu.set_group_visibility("CustomAA", true)
            for key, value in pairs(ConditionAA) do
                if key == AAconditionName then
                    for key, value in pairs(ConditionAA[key]) do
                        value:set_visible(true)
                    end
                else
                    for key, value in pairs(ConditionAA[key]) do
                        value:set_visible(false)
                    end
                end
            end
        else
            set_visible_group(ConditionAA.Stand, false)
            set_visible_group(ConditionAA.Jump, false)
            set_visible_group(ConditionAA.Move, false)
            set_visible_group(ConditionAA.Duck, false)
            menu.set_group_visibility("CustomAA", false)
        end
        if visualTab.manualArrows:get() and not scope then
            local manualState = antiaim.get_manual_override()
            local def_color = color_t.new(25,25,25,150)
            r,g,b = colorsTab.manualArrows:get().r, colorsTab.manualArrows:get().g, colorsTab.manualArrows:get().b
            a = math.floor(global_vars.cur_time() * 30 % 255)
            if manualState == 1 then--here
                render.triangle_filled(vec2_t.new(x/2-50, y/2), 23, color_t.new(r, g, b, a), 270)
                render.triangle_filled(vec2_t.new(x/2+50, y/2), 23, color_t.new(25,25,25,150), 90)
            elseif manualState == 3 then
                render.triangle_filled(vec2_t.new(x/2-50, y/2), 23, color_t.new(25,25,25,150), 270)
                render.triangle_filled(vec2_t.new(x/2+50, y/2), 23, color_t.new(r, g, b, a), 90)
            else
                render.triangle_filled(vec2_t.new(x/2-50, y/2), 23, color_t.new(25,25,25,150), 270)
                render.triangle_filled(vec2_t.new(x/2+50, y/2), 23, color_t.new(25,25,25,150), 90)
            end
        end
        if visualTab.sideLine:get() and not scope then
            a = math.floor(global_vars.cur_time() * 30 % 255)
            r,g,b = colorsTab.sideLine:get().r, colorsTab.sideLine:get().g, colorsTab.sideLine:get().b
            local sideState = antiaim.get_desync_side()
            if sideState == 1 then 
                render.rect_filled(vec2_t(x/2-47, y/2-(22/2)), vec2_t(3, 23), color_t(r, g, b, a))
                render.rect_filled(vec2_t(x/2+44, y/2-(22/2)), vec2_t(3, 23), color_t(25,25,25,150))
            elseif sideState == 2 then
                render.rect_filled(vec2_t(x/2-47, y/2-(22/2)), vec2_t(3, 23), color_t(25,25,25,150))
                render.rect_filled(vec2_t(x/2+44, y/2-(22/2)), vec2_t(3, 23), color_t(r, g, b, a))
            else
                render.rect_filled(vec2_t(x/2-47, y/2-(22/2)), vec2_t(3, 23), color_t(25,25,25,150))
                render.rect_filled(vec2_t(x/2+44, y/2-(22/2)), vec2_t(3, 23), color_t(25,25,25,150))
            end
        end
        if visualTab.hitlogs:get() then
            local logs = hitlogsList
            text = ''
            margin = 15
            font = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW)
            for i, v in ipairs(logs) do
                local currentLog = logs[i]
                local timenow = tonumber(client.get_unix_time()) - tonumber(currentLog.time)
                if timenow < 5 then
                    text = currentLog.msg
                    textSize = render.get_text_size(font,text)
                    render.text(font, text, vec2_t((x / 2) - (textSize.x / 2), (y / 1.5) + margin*i), colorsTab.indicators:get())
                else
                    table.remove(hitlogsList, i)
                end
            end
        end
        if visualTab.indicator:get() then
            font = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags.NORMAL, e_font_flags.DROPSHADOW)
            list = visualTab.indicatorsList:get_items()
            local marginList, marginPos = 1, 0
            for key, bind in pairs(list) do
                if visualTab.indicatorsList:get(key) ~= false then
                    if bind == 'lua name' then
                        table.insert(activeBindsList, "mrxlua")
                    end
                    if bind == 'State' then
                        table.insert(activeBindsList, playerState)
                    end
                    if bind == 'DT' and ref.aim.dt[2]:get() then
                        table.insert(activeBindsList, 'dt')
                    end
                    if bind == 'FD' and ref.aa.fd[2]:get() then
                        table.insert(activeBindsList, 'fd')
                    end
                    if bind == 'onshot' and ref.aim.onshot[2]:get() then
                        table.insert(activeBindsList, bind)
                    end
                    if bind == 'peek' and ref.aim.peek[2]:get() then
                        table.insert(activeBindsList, bind)
                    end
                    if bind == 'fake ping' and ref.aim.ping[2]:get() then
                        table.insert(activeBindsList, "ping")
                    end
                    if bind == 'min dmg' then
                        for key, value in pairs(ref.weapons) do
                            if weaponType == key and value.dmg[2]:get() then
                                table.insert(activeBindsList, "dmg")
                            end
                        end
                    end
                    if bind == 'hitbox override' then
                        for key, value in pairs(ref.weapons) do
                            if weaponType == key and value.hitbox[2]:get() then
                                table.insert(activeBindsList, "hitbox")
                            end
                        end
                    end
                    if bind == 'safe point' then
                        for key, value in pairs(ref.weapons) do
                            if weaponType == key and value.safepoint[2]:get() then
                                table.insert(activeBindsList, "safe")
                            end
                        end
                    end
                end
            end
            for key, bind in pairs(activeBindsList) do
                r, g, b, a = colorsTab.indicators:get().r, colorsTab.indicators:get().g, colorsTab.indicators:get().b, colorsTab.indicators:get().a
                text = bind
                local fontId = visualTab.indicatorsListFonts:get()
                local fontName = visualTab.indicatorsListFonts:get_item_name(fontId)
                font = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags[fontName], e_font_flags.DROPSHADOW)
                textSize = render.get_text_size(font, text)
                textWidth = (x / 2) - (textSize.x / 2)
                if scope then
                    textWidth = textWidth + 25
                end
                local prt = global_vars.cur_time() * local_player:get_prop("m_bIsScoped") % 100
                marginPos = (marginList + (key * 15))
                textHeight = (y / 2) - (textSize.y / 2) + marginPos
                if text == 'dt' then
                        as = helpers:lerp(as, 255 , 0.095 , 0.05)
                        render.text(font, text, vec2_t(textWidth, textHeight), color_t(r, g, b, math.floor(as)))
                elseif text == 'mrxlua' then
                    render.text(font, "mrx", vec2_t(textWidth, textHeight), colorLuaNameInvert("left", colorsTab.indicators:get()))
                    render.text(font, "lua", vec2_t((textWidth + textSize.x / 2) + 5, textHeight), colorLuaNameInvert("right", colorsTab.indicators:get()))
                else
                    render.text(font, text, vec2_t(textWidth, textHeight), colorsTab.indicators:get())
                end
            end
        end
        if visualTab.watermark:get() then
            local watermarkStartX, watermarkEndX, watermarkStartY, watermarkEndY = 0, 0, 0, 0
            text = "mrxlua | " .. user.name .. " | " .. tostring(latency) .. "ms | " .. client.get_tickrate() .. "tick | " .. string.format("%02d:%02d:%02d", hours, minutes, seconds) .. " | shift(" .. exploits.get_charge() .. ")"
            font = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW)
            textSize = render.get_text_size(font, text)
            watermarkStartX = x - textSize.x - 30
            watermarkEndX = textSize.x + 20
            watermarkStartY = 10
            watermarkEndY = textSize.y + 10
            render.rect_fade(vec2_t(watermarkStartX, watermarkStartY), vec2_t(watermarkEndX, watermarkEndY), color_t(20, 19, 19), color_t(20, 19, 19, 100))
            render.text(font, text, vec2_t(x - textSize.x - 20, 15), color_t(255, 255, 255, 255))
            render.rect_filled(vec2_t(watermarkStartX, watermarkStartY), vec2_t(watermarkEndX, 2), colorsTab.watermark:get())
        end
        if visualTab.keybinds:get() then
            if (ref.aim.dt[2]:get()) then
                table.insert(keybindsList, "Double Tap")
            end
            if (ref.aim.peek[2]:get()) then
                table.insert(keybindsList, "Auto peek")
            end
            if (ref.aim.ping[2]:get()) then
                table.insert(keybindsList, "Ping spike")
            end
            if (ref.aim.onshot[2]:get()) then
                table.insert(keybindsList, "Hideshots")
            end
            for key, value in pairs(ref.weapons) do
                if weaponType == key and value.dmg[2]:get() then
                    table.insert(keybindsList, "Dmg override")
                end
            end
            for key, value in pairs(ref.weapons) do
                if weaponType == key and value.hitbox[2]:get() then
                    table.insert(keybindsList, "Hitbox override")
                end
            end
            for key, value in pairs(ref.weapons) do
                if weaponType == key and value.safepoint[2]:get() then
                    table.insert(keybindsList, "Safepoint")
                end
            end
            if ref.aim.rollresolver[2]:get() then
                table.insert(keybindsList, "Roll resolver")
            end
            if ref.aim.overrideresolver[2]:get() then
                table.insert(keybindsList, "Ovr resolver")
            end
            if ref.aim.lagcomp:get() then
                table.insert(keybindsList, "Prediction")
            end
            if ref.aa.freestanding[2]:get() then
                table.insert(keybindsList, "Freestanding")
            end
            if ref.aa.rollpitch[2]:get() then
                table.insert(keybindsList, "Roll pitch")
            end
            if ref.aa.fd[2]:get() then
                table.insert(keybindsList, "Fake duck")
            end
            font = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW)
            text = "Keybinds"
            textStatus = "[status]"
            local textStatusSize = render.get_text_size(font, textStatus)
            textSize = render.get_text_size(font, text)
            local keybindsLen = table.getn(keybindsList)
            if keybindsLen ~= 0 then
                render.push_alpha_modifier(0.5)
                render.rect_filled(vec2_t(100, 500), vec2_t(150, 2), colorsTab.keybinds:get())
                render.push_alpha_modifier(1)
                render.pop_clip()
                render.rect_fade(vec2_t(100, 502), vec2_t(150, textSize.y + 10), color_t(20, 19, 19), color_t(20, 19, 19, 100))
                render.pop_clip()
                render.text(font, text, vec2_t(115, 508), color_t(255, 255, 255, 255))
                render.text(font, textStatus, vec2_t(230 - textStatusSize.x, 508), color_t(255, 255, 255, 255))
            end
            text = "Double tap"
            local marginKeybinds = 1
            for index, value in ipairs(keybindsList) do
                text = value
                textSize = render.get_text_size(font, text)
                render.text(font, text, vec2_t(115, 525 + marginKeybinds), color_t(255, 255, 255, 255))
                text = "[on]"
                textSize = render.get_text_size(font, text)
                render.text(font, text, vec2_t((230 - textStatusSize.x) + (textSize.x / 2), 525 + marginKeybinds), color_t(255, 255, 255, 255))
                marginKeybinds = marginKeybinds + 15
            end
        end
    end

    callbacks.add(e_callbacks.PAINT, on_paint)
    callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
        local local_player = entity_list.get_local_player()
        globals.pressing_move_keys = (cmd:has_button(e_cmd_buttons.MOVELEFT) or cmd:has_button(e_cmd_buttons.MOVERIGHT) or cmd:has_button(e_cmd_buttons.FORWARD) or cmd:has_button(e_cmd_buttons.BACK))
        if (not local_player:has_player_flag(e_player_flags.ON_GROUND)) or (local_player:has_player_flag(e_player_flags.ON_GROUND) and cmd:has_button(e_cmd_buttons.JUMP)) then
            globals.jumping = true
        else
            globals.jumping = false
        end

        if globals.pressing_move_keys then
            if not globals.jumping then
                if cmd:has_button(e_cmd_buttons.DUCK) then
                    globals.crouching = true
                    globals.running = false
                else
                    globals.running = true
                    globals.crouching = false
                end
            elseif globals.jumping and not cmd:has_button(e_cmd_buttons.JUMP) then
                globals.running = false
                globals.crouching = false
            end

            globals.standing = false
        elseif not globals.pressing_move_keys then
            if not globals.jumping then
                if cmd:has_button(e_cmd_buttons.DUCK) then
                    globals.crouching = true
                    globals.standing = false
                else
                    globals.standing = true
                    globals.crouching = false
                end
            else
                globals.standing = false
                globals.crouching = false
            end

            globals.running = false
        end
    end)
    local function on_antiaim(ctx)
        if mainTab.Enable:get() ~= true then return end
        if not engine.is_in_game() then return end
        local local_player = entity_list.get_local_player()
        if not local_player:is_alive() then return end
        local presetId, StateId = aaTab.presets:get(), CustomAA.Condition:get()
        if aaTab.switchside:get() then
            local side = math.floor(global_vars.cur_time() % 2)
            if side == 1 then
                ctx:set_invert_desync(true)
            else
                ctx:set_invert_desync(false)
            end
        end
        if presetId == 2 then
            ref.aa.pitch:set(2)
            ref.aa.yawbase:set(2)
            ref.aa.yawadd:set(2)
            ref.aa.jittermode:set(2)
            ref.aa.jitteradd:set(32)
            ref.aa.rolltype:set(1)
            ref.aa.rolldeg:set(0)
            ref.aa.rollpitchValue:set(0)
            ref.aa.rollpitchType:set(1)
            ref.aa.rollpitchOffset:set(0)
        end
        if presetId == 3 then
            ref.aa.pitch:set(2)
            ref.aa.yawbase:set(2)
            ref.aa.yawadd:set(-8)
            ref.aa.jittermode:set(0)
            ref.aa.jitteradd:set(0)
            ref.aa.rolltype:set(2)
            ref.aa.rolldeg:set(-45)
            ref.aa.rollpitchValue:set(-27)
            ref.aa.rollpitchType:set(1)
            ref.aa.rollpitchOffset:set(32)
            if not ref.aa.rollpitch[2]:get() then
                client.log_screen(color_t(246, 214, 255), "[mrx.lua]", color_t(0, 128, 0), "Need turn on extended angles in Anti-Aim tab")
            end
        end
        if presetId == 4 then
            if globals.jumping then
                ref.aa.pitch:set(ConditionAA.Jump.pitch:get())
                ref.aa.yawbase:set(ConditionAA.Jump.yawbase:get())
                ref.aa.yawadd:set(ConditionAA.Jump.yawAdd:get())
                ref.aa.jittermode:set(ConditionAA.Jump.jitterMode:get())
                ref.aa.jittertype:set(ConditionAA.Jump.jitterType:get())
                ref.aa.jitteradd:set(ConditionAA.Jump.jitterAdd:get())
                ref.aa.rolltype:set(ConditionAA.Jump.rollType:get())
                ref.aa.rolldeg:set(ConditionAA.Jump.rollDeg:get())
                ref.aa.rollinmove:set(ConditionAA.Jump.rollInMove:get())
            elseif globals.running then
                ref.aa.pitch:set(ConditionAA.Move.pitch:get())
                ref.aa.yawbase:set(ConditionAA.Move.yawbase:get())
                ref.aa.yawadd:set(ConditionAA.Move.yawAdd:get())
                ref.aa.jittermode:set(ConditionAA.Move.jitterMode:get())
                ref.aa.jittertype:set(ConditionAA.Move.jitterType:get())
                ref.aa.jitteradd:set(ConditionAA.Move.jitterAdd:get())
                ref.aa.rolltype:set(ConditionAA.Move.rollType:get())
                ref.aa.rolldeg:set(ConditionAA.Move.rollDeg:get())
                ref.aa.rollinmove:set(ConditionAA.Move.rollInMove:get())
            elseif globals.standing then
                ref.aa.pitch:set(ConditionAA.Stand.pitch:get())
                ref.aa.yawbase:set(ConditionAA.Stand.yawbase:get())
                ref.aa.yawadd:set(ConditionAA.Stand.yawAdd:get())
                ref.aa.jittermode:set(ConditionAA.Stand.jitterMode:get())
                ref.aa.jittertype:set(ConditionAA.Stand.jitterType:get())
                ref.aa.jitteradd:set(ConditionAA.Stand.jitterAdd:get())
                ref.aa.rolltype:set(ConditionAA.Stand.rollType:get())
                ref.aa.rolldeg:set(ConditionAA.Stand.rollDeg:get())
            elseif globals.crouching then
                ref.aa.pitch:set(ConditionAA.Duck.pitch:get())
                ref.aa.yawbase:set(ConditionAA.Duck.yawbase:get())
                ref.aa.yawadd:set(ConditionAA.Duck.yawAdd:get())
                ref.aa.jittermode:set(ConditionAA.Duck.jitterMode:get())
                ref.aa.jittertype:set(ConditionAA.Duck.jitterType:get())
                ref.aa.jitteradd:set(ConditionAA.Duck.jitterAdd:get())
                ref.aa.rolltype:set(ConditionAA.Duck.rollType:get())
                ref.aa.rolldeg:set(ConditionAA.Duck.rollDeg:get())
                ref.aa.rollinmove:set(ConditionAA.Duck.rollInMove:get())
            end
        end
        local lp = entity_list.get_local_player()
        local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1, 0)) ~= 0
        local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0
        local curtime = global_vars.cur_time()
        if visualTab.staticlegs:get() then
            if on_land == true then
                ground_tick = ground_tick + 1
            else
                ground_tick = 0
                end_time = curtime + 1
            end
            if ground_tick > 1 and end_time > curtime then
                ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
            end
            if in_air then
                ctx:set_render_pose(e_poses.JUMP_FALL, 1)
            end
        end
    end


    local function on_draw_watermark(watermark_text)
        if visualTab.defwatermark:get() then
            return ""
        else
            return "primodial - "..user.name
        end
    end
    local function on_aimbot_hit(hit)
        local player = hit.player:get_name()
        local hp = tostring(hit.damage)
        local text = string.format('Hit %s in the %s for %d damage (%d health remaining)', player, hitgroup[hit.hitgroup + 1], hp, hit.player:get_prop("m_iHealth"))
        if visualTab.hitlogs:get() then
            table.insert(hitlogsList, { msg = text, time = client.get_unix_time(), type='hit' })
        end
    end
    local function on_aimbot_miss(miss)
        if visualTab.hitlogs:get() then
        local player = miss.player:get_name()
        local reason = miss.reason_string
        local text = string.format('Missed %s (%s) due to %s', player, hitgroup[miss.aim_hitgroup + 1], reason)
        table.insert(hitlogsList, { msg = text, time = client.get_unix_time(), type='miss' })
        end
    end
    callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
    callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)
    callbacks.add(e_callbacks.AIMBOT_HIT, on_aimbot_hit)
    callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)