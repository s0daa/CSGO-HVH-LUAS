local calibri = render.create_font("Calibri", 23, 700, e_font_flags.ANTIALIAS)
local main_font = render.create_font("Calibri", 12, 400)
local screen_size = render.get_screen_size()
local ctx = screen_size.x / 2
local cty = screen_size.y / 2
local x = screen_size.x / 2
local y = screen_size.y / 2

local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")
local force_baim = menu.find("aimbot", "scout", "target overrides", "hitbox")
local min_damage = menu.find("aimbot", "scout", "target overrides", "min. damage")
local lethal = menu.find("aimbot", "revolver", "target overrides", "lethal shot")
local peek = menu.find("aimbot", "general", "misc", "autopeek")
local ping = menu.find("aimbot", "general", "fake ping", "enable")
local fs = menu.find("antiaim", "main","auto direction", "enable")
local roll = menu.find("antiaim", "main","extended angles", "enable")
local ax = menu.find("aimbot", "general", "exploits", "force prediction")

local enabled = true

local min_damage_a = menu.find("aimbot", "auto", "target overrides", "min. damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "min. damage")
local min_damage_r = menu.find("aimbot", "revolver", "target overrides", "min. damage")
local min_damage_d = menu.find("aimbot", "deagle", "target overrides", "min. damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "min. damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "min. damage")

local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "min. damage"))
local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "min. damage"))
local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "min. damage"))
local amount_revolver = unpack(menu.find("aimbot", "revolver", "target overrides", "min. damage"))
local amount_deagle = unpack(menu.find("aimbot", "deagle", "target overrides", "min. damage"))
local amount_pistol = unpack(menu.find("aimbot", "pistols", "target overrides", "min. damage"))

local function getweapon()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then
    
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end

        weapon_name = active_weapon:get_name()


    else return end

    return weapon_name

end

local checkbox = menu.add_checkbox("Indicator", "Enable")
local selectall = menu.add_checkbox("Indicator", "All Indicators")
local list = menu.add_multi_selection("Indicator", "Indicator Select", {"Double Tap", "Fake duck", "Force Baim", "Damage Override", "Hide Shots", "Lethal Shot", "Auto Peek", "Fake Ping", "Freestanding", "Ext. Angles", "AX" })

function on_paint()

    if not engine.is_connected() then
        return
      end
      
    if not engine.is_in_game() then
        return
    end
      
    local local_player = entity_list.get_local_player()
      
    if not local_player:get_prop("m_iHealth") then
        return
    end

    local ind_dst = 0
    local ind_spr = 30
    
    if engine.is_connected() then
        if local_player:is_alive() then

            if checkbox:get() then

                local text = "DT"
                local size = render.get_text_size(calibri, text)
                
                if list:get(1) or selectall:get() then
                    if dt_ref[2]:get() then
                        if exploits.get_charge() >= 1 then
                            render.text(calibri, "DT", vec2_t(16, cty + 114 + ind_dst), color_t(255,255,255,255))

                            ind_dst = ind_dst + ind_spr
                        end

                        if exploits.get_charge() < 1 then
                            render.text(calibri, "DT", vec2_t(16, cty + 114 + ind_dst), color_t(255,0,0,255))

                            ind_dst = ind_dst + ind_spr
                        end
                    end
                end

                local text = "Lethal"
                local size = render.get_text_size(calibri, text)
                
                if list:get(6) or selectall:get() then
                    if lethal[2]:get() then
                            render.text(calibri, "LETHAL", vec2_t(16, cty + 114 + ind_dst), color_t(255,255,255,255))

                            ind_dst = ind_dst + ind_spr
                        end
                    end
                end                

                if list:get(6) or selectall:get() then
                    if getweapon() == "ssg08" then
                        if min_damage_s[2]:get() then
                            render.text(main_font, tostring(amount_scout:get()), vec2_t(x + 4, y - 16), color_t(255, 255, 255))
                        end
                    elseif getweapon() == "revolver" then
                        if min_damage_r[2]:get() then
                            render.text(main_font, tostring(amount_revolver:get()), vec2_t(x + 4, y - 16), color_t(255, 255, 255))
                        end
                    elseif getweapon() == "deagle" then
                        if min_damage_d[2]:get() then
                            render.text(main_font, tostring(amount_deagle:get()), vec2_t(x + 4, y - 16), color_t(255, 255, 255))
                        end
                    elseif getweapon() == "awp" then
                        if min_damage_awp[2]:get() then
                            render.text(main_font, tostring(amount_awp:get()), vec2_t(x + 4, y - 16), color_t(255, 255, 255))
                        end
                    elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
                        if min_damage_a[2]:get() then
                            render.text(main_font, tostring(amount_auto:get()), vec2_t(x + 4, y - 16), color_t(255, 255, 255))
                        end
                    elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" then
                        if min_damage_p[2]:get() then
                            render.text(main_font, tostring(amount_pistol:get()), vec2_t(x + 4, y - 16), color_t(255, 255, 255))
                        end
                    end
                end
                
                
                local text = "ONSHOT"
                local size = render.get_text_size(calibri, text)

                if list:get(5) or selectall:get() then
                    if hideshots[2]:get() then
                        render.text(calibri, "OSAA", vec2_t(16, cty + 114 + ind_dst), color_t(114, 201, 52 ,255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                local text = "DMG"
                local size = render.get_text_size(calibri, text)

                if list:get(4) or selectall:get() then
                    if min_damage[2]:get() then
                        render.text(calibri, "DMG", vec2_t(16, cty + 114 + ind_dst), color_t(255, 255, 255, 255))

                        ind_dst = ind_dst + ind_spr
                    end
                end
                
                local text = "DUCK"
                local size = render.get_text_size(calibri, text)

                if list:get(2) or selectall:get() then
                    if antiaim.is_fakeducking() then
                        render.text(calibri, "DUCK", vec2_t(16, cty + 114 + ind_dst), color_t(255, 255, 255, 255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                local text = "BAIM"
                local size = render.get_text_size(calibri, text)

                if list:get(3) or selectall:get() then
                    if force_baim[2]:get() then
                        render.text(calibri, "BAIM", vec2_t(16, cty + 114 + ind_dst), color_t(114, 201, 52 ,255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                local text = "PEEK"
                local size = render.get_text_size(calibri, text)

                if list:get(7) or selectall:get() then
                    if peek[2]:get() then
                        render.text(calibri, "PEEK", vec2_t(16, cty + 114 + ind_dst), color_t(255, 255, 255 ,255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                local text = "PING"
                local size = render.get_text_size(calibri, text)

                if list:get(8) or selectall:get() then
                    if ping[2]:get() then
                        render.text(calibri, "PING", vec2_t(16, cty + 114 + ind_dst), color_t(114, 201, 52 ,255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                local text = "FREE"
                local size = render.get_text_size(calibri, text)

                if list:get(9) or selectall:get() then
                    if fs[2]:get() then
                        render.text(calibri, "FS", vec2_t(16, cty + 114 + ind_dst), color_t(255, 255, 255 ,255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                local text = "ROLL"
                local size = render.get_text_size(calibri, text)

                if list:get(10) or selectall:get() then
                    if roll[2]:get() then
                        render.text(calibri, "ROLL", vec2_t(16, cty + 114 + ind_dst), color_t(255, 255, 255 ,255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                local text = "AX"
                local size = render.get_text_size(calibri, text)

                if list:get(11) or selectall:get() then
                    if ax:get() then
                        render.text(calibri, "AX", vec2_t(16, cty + 114 + ind_dst), color_t(255, 255, 255 ,255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

            end

        end

end

callbacks.add(e_callbacks.PAINT, on_paint)