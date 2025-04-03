local calibri = render.create_font("Calibri", 29, 700, e_font_flags.ANTIALIAS)
local main_font = render.create_font("Calibri", 12, 400)
local screen_size = render.get_screen_size() -- screen
local ctx = screen_size.x / 2
local cty = screen_size.y / 2
local x = screen_size.x / 2
local y = screen_size.y / 2

local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")
local force_baim = menu.find("aimbot", "scout", "target overrides", "force hitbox")
local min_damage = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local lethal = menu.find("aimbot", "heavy pistols", "target overrides", "force lethal shot")

local enabled = true

-- weapon damages

local min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local min_damage_h = menu.find("aimbot", "heavy pistols", "target overrides", "force min. damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")

local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
local amount_heavy = unpack(menu.find("aimbot", "heavy pistols", "target overrides", "force min. damage"))
local amount_pistol = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))

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

local checkbox = menu.add_checkbox("Indicator", "Turn On")
local list = menu.add_multi_selection("Indicators", "Choose", {"Double Tap", "Fake duck", "Force Baim", "Min DMG", "Hide Shots", "Mid screen min dmg indicator", "Lethal Shot" }) 

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
    local ind_spr = 40
    
    if engine.is_connected() then
        if local_player:is_alive() then

            if checkbox:get() then

                local text = "DT"
                local size = render.get_text_size(calibri, text)
                
                if list:get(1) then
                    if dt_ref[2]:get() then
                        if exploits.get_charge() >= 1 then
                            render.rect_fade(vec2_t(16, cty + 110 + ind_dst - 1), vec2_t(math.floor(size.x / 2), 30), color_t(0, 0, 0, 5), color_t(0, 0, 0, 180))
                            render.text(calibri, "DT", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                            render.text(calibri, "DT", vec2_t(16, cty + 114 + ind_dst), color_t(255,255,255,255))

                            ind_dst = ind_dst + ind_spr
                        end

                        if exploits.get_charge() < 1 then
                            render.rect_fade(vec2_t(16, cty + 110 + ind_dst - 1), vec2_t(math.floor(size.x / 2), 27), color_t(0, 0, 0, 5), color_t(0, 0, 0, 180))
                            render.text(calibri, "DT", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                            render.text(calibri, "DT", vec2_t(16, cty + 114 + ind_dst), color_t(255,0,0,255))

                            ind_dst = ind_dst + ind_spr
                        end
                    end
                end

                local text = "Lethal"
                local size = render.get_text_size(calibri, text)
                
                if list:get(7) then
                    if lethal[2]:get() then
                            render.rect_fade(vec2_t(13, cty + 110 + ind_dst - 3), vec2_t(math.floor(size.x / 2), 33), color_t(0, 0, 0, 5), color_t(0, 0, 0, 180))
                            render.text(calibri, "Lethal", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                            render.text(calibri, "Lethal", vec2_t(16, cty + 114 + ind_dst), color_t(255,255,255,255))

                            ind_dst = ind_dst + ind_spr
                        end
                    end
                end                

                if list:get(6) then
                    if getweapon() == "ssg08" then
                        if min_damage_s[2]:get() then
                            render.text(main_font, tostring(amount_scout:get()), vec2_t(x + 4, y - 16), color_t(255, 255, 255))
                        end
                    elseif getweapon() == "deagle" or getweapon() == "revolver" then
                        if min_damage_h[2]:get() then
                            render.text(main_font, tostring(amount_heavy:get()), vec2_t(x + 4, y - 16), color_t(255, 255, 255))
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

                if list:get(5) then
                    if hideshots[2]:get() then
                        render.rect_fade(vec2_t(17, cty + 120 + ind_dst - 4), vec2_t(math.floor(size.x), 25), color_t(0, 0, 0, 180), color_t(0, 0, 0, 5),true)
                        render.text(calibri, "ONSHOT", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                        render.text(calibri, "ONSHOT", vec2_t(16, cty + 114 + ind_dst), color_t(114, 201, 52 ,255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                local text = "DMG"
                local size = render.get_text_size(calibri, text)

                if list:get(4) then
                    if min_damage[2]:get() then
                        render.rect_fade(vec2_t(13, cty + 110 + ind_dst - 3), vec2_t(math.floor(size.x / 2), 33), color_t(0, 0, 0, 5), color_t(0, 0, 0, 180))
                        render.text(calibri, "DMG", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                        render.text(calibri, "DMG", vec2_t(16, cty + 114 + ind_dst), color_t(255, 255, 255, 255))

                        ind_dst = ind_dst + ind_spr
                    end
                end
                
                local text = "DUCK"
                local size = render.get_text_size(calibri, text)

                if list:get(2) then
                    if antiaim.is_fakeducking() then
                        render.rect_fade(vec2_t(13, cty + 110 + ind_dst - 3), vec2_t(math.floor(size.x / 2), 33), color_t(0, 0, 0, 5), color_t(0, 0, 0, 180))
                        render.text(calibri, "DUCK", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                        render.text(calibri, "DUCK", vec2_t(16, cty + 114 + ind_dst), color_t(255, 255, 255, 255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                local text = "BAIM"
                local size = render.get_text_size(calibri, text)

                if list:get(3) then
                    if force_baim[2]:get() then
                        render.rect_fade(vec2_t(15, cty + 120 + ind_dst - 4), vec2_t(math.floor(size.x + 20), 25), color_t(0, 0, 0, 150), color_t(0, 0, 0, 15),true)
                        render.text(calibri, "BAIM", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                        render.text(calibri, "BAIM", vec2_t(16, cty + 114 + ind_dst), color_t(114, 201, 52 ,255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

            end

        end

end -- termina

callbacks.add(e_callbacks.PAINT, on_paint)