local function active_weapon()
    if ragebot.get_active_cfg() == 0 then
        return 'auto'
    elseif ragebot.get_active_cfg() == 1 then
        return 'scout'
    elseif ragebot.get_active_cfg() == 2 then
        return 'awp'
    elseif ragebot.get_active_cfg() == 3 then 
        return 'deagle'
    elseif ragebot.get_active_cfg() == 4 then 
        return 'revolver'
    elseif ragebot.get_active_cfg() == 5 then 
        return 'pistols'
    else
        return 'other'
    end
end

local font = render.create_font("Arial", 14, 300, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local x,y = render.get_screen_size().x / 2, render.get_screen_size().y / 2

local function damn()
    local dmg_ovr = menu.find("aimbot", tostring(active_weapon()), "target overrides", "force min. damage")[1]
    local dmg_ovr_key = menu.find("aimbot", tostring(active_weapon()), "target overrides", "force min. damage")[2]
    local norm_dmg = menu.find("aimbot", tostring(active_weapon()), "targeting", "min. damage")
    if dmg_ovr_key:get() then
        render.text(font, tostring(dmg_ovr:get()), vec2_t(x + 5, y - 20), color_t(255, 255, 255, 255))
    else
        render.text(font, tostring(norm_dmg:get()), vec2_t(x + 5, y - 20), color_t(255, 255, 255, 255))
    end
end

callbacks.add(e_callbacks.PAINT, active_weapon)
callbacks.add(e_callbacks.PAINT, damn)