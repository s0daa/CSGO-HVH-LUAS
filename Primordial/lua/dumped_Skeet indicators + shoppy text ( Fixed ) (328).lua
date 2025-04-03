local indicators = menu.add_multi_selection("Indicators", "indicators", {"DoubleTap", "Lethal","Min DMG", "Hide Shots", "FakeDuck","Ping","Safe Point","Hitbox OVR", "Hitchance OVR"})
local amgis = menu.add_checkbox("Shoppy Text", "Main Switch")
local shoppyinput = menu.add_text_input("Shoppy Text", "Shoppy Name")
local screen_size = render.get_screen_size()
local font = render.create_font("Calibri Bold", 27, 670, e_font_flags.ANTIALIAS)
local color2 = color_t(255, 255, 255, 255)
local color3 = color_t(255, 0, 0, 255)
local col_1 = color_t(0, 0, 0, 150)
local col_2 = color_t(0, 0, 0, 0)
local fontsigma = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS)

local groups = {
    auto = {0},
    scout = {1},
    awp = {2},
    deagle = {3},
    revolver = {4},
    pistols = {5},
    other = {6}
}

local math_funcs = { -- Thanks to LosKitten1 https://primordial.dev/resources/another-indicator-lua.107/

    get_min_dmg = function(wpn_type) -- // thnx classy.
        local menu_ref = menu.find("aimbot", wpn_type, "target overrides", "force min. damage")
        local force_lethal = menu.find("aimbot", wpn_type, "target overrides", "force lethal shot")
        local hitbox_ovr = menu.find("aimbot", wpn_type, "target overrides", "force hitbox")
        local force_sp = menu.find("aimbot", wpn_type, "target overrides", "force safepoint")
        local force_hc = menu.find("aimbot", wpn_type, "target overrides", "force hitchance")
        return {menu_ref[1]:get(), menu_ref[2]:get(), force_lethal[2]:get(), hitbox_ovr[2]:get(), force_sp[2]:get(),
                force_hc[2]:get()}
    end,
    vars = {
        angle = 0
    }
}

local function calcs()
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end
    if not local_player:is_alive() then
        math_funcs.vars.angle = 0

    else
        math_funcs.vars.angle = antiaim.get_max_desync_range()
    end
end

callbacks.add(e_callbacks.ANTIAIM, calcs)

local groups = {
    ['auto'] = 0,
    ['scout'] = 1,
    ['awp'] = 2,
    ['deagle'] = 3,
    ['revolver'] = 4,
    ['pistols'] = 5,
    ['other'] = 6,

}
local current_min = nil
local key_active = nil
local force_lethal = nil
local hitbox_ovr = nil
local force_sp = nil
local force_hc = nil

local function get_weapon_group() -- // Classy also did a func like this, might be better not sure.
    for key, value in pairs(groups) do
        if value == ragebot.get_active_cfg() then
			local states = math_funcs.get_min_dmg(key)
		
            current_min = states[1]
            key_active = states[2]
            force_lethal = states[3]
            hitbox_ovr = states[4]
            force_sp = states[5]
            force_hc = states[6]
        end
    end

    return {tostring(current_min), key_active, force_lethal, hitbox_ovr, force_sp, force_hc}
end

local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")
local fakeping_ref = menu.find("aimbot", "general", "fake ping", "enable")

local function gradient(x, y, w, h, col1, col2)
    render.rect_fade(vec2_t(x, y - 4), vec2_t(w / 4, h), col2, col1, true)
    render.rect_fade(vec2_t(x + (w / 4), y - 4), vec2_t(w / 4, h), col1, col2, true)
end

local function dnn()
    local maxdes = math_funcs.vars.angle
    local local_player = entity_list.get_local_player()
	
    if not local_player or not local_player:is_alive() then
        return
    end
    
    local pos = vec2_t(0, 0)
    local addpos = vec2_t(0, 32)
    local startpos = vec2_t(screen_size.x * 0.00741666666, screen_size.y * 0.67777777777)
	
	local wpn = get_weapon_group()

	local function default(str, color)
		local text_size = render.get_text_size(font, str)
		gradient(9, pos.y + 4, 70, 28, col_1, col_2)
		render.text(font, str, pos, color)
		pos = pos - addpos
	end

	local function circle(str, color, percent)
		local text_size = render.get_text_size(font, str)
		gradient(9, pos.y + 4, 70, 28, col_1, col_2)
		render.text(font, str, pos, color)
		render.progress_circle(pos + vec2_t(text_size.x * 1.3, text_size.y / 1.9), 5, color_t(0, 0, 0, 155), 3, 1)
		render.progress_circle(pos + vec2_t(text_size.x * 1.3, text_size.y / 1.9), 5, color, 3, percent)
		pos = pos - addpos
	end

    if amgis:get() then     
        local text_sizenigma = render.get_text_size(fontsigma, "@" .. shoppyinput:get())
        local text_sizeligma = render.get_text_size(fontsigma, "shoppy.gg/")
        render.text(fontsigma, "shoppy.gg/", vec2_t(screen_size.x - text_sizenigma.x - text_sizeligma.x, 0), color_t(255, 255, 255, 255))
        render.text(fontsigma, "@" .. shoppyinput:get(), vec2_t(screen_size.x - text_sizenigma.x, 0), color_t(50, 255, 50, 255))
    end

    pos = startpos
	
    if indicators:get('Min DMG') and wpn[2] then
        default("DMG: " .. wpn[1], color2)
    end

    if indicators:get("Lethal") and wpn[3] then
        default("LETHAL", color2)
    end

    if indicators:get('Hitbox OVR') and wpn[4] then
        default("HITBOX OVR", color2)
    end
    
    if indicators:get('Hitchance OVR') and wpn[6] then
        default("HITCHANCE OVR", color2)
    end

    if indicators:get('Safe Point') and wpn[5] then
        default("SAFE", color2)
    end

    if indicators:get('FakeDuck') and antiaim.is_fakeducking() then
        default("DUCK", color2)
    end

    if indicators:get("Hide Shots") and hideshots[2]:get() then
        default("ONSHOT", color_t(150, 200, 60, 255))
    end
    
	if indicators:get("Ping") and fakeping_ref[2]:get() then
		default("PING", color_t(170, 237, 78, 255))
	end

    if dt_ref[2]:get() and indicators:get('DoubleTap') then
        if exploits.get_charge() == 14 then
            default("DT", color2)
        else
            default("DT", color3)
        end
    end
end

callbacks.add(e_callbacks.PAINT, dnn)

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
local lethal = menu.find("aimbot", "revolver", "target overrides", "force lethal shot")

local enabled = true

-- weapon damages

local min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local min_damage_r = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
local min_damage_d = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")

local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
local amount_revolver = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local amount_deagle = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
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

local checkbox = menu.add_checkbox("Mid screen min dmg indicator", "Turn On")

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
        end 
    end               
end -- termina

callbacks.add(e_callbacks.PAINT, on_paint)
-- callbacks.add(e_callbacks.FINISH_COMMAND, get_weapon_group())