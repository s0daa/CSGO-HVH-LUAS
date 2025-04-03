ideal_font = render.create_font("Smallest Pixel", 14, 700, e_font_flags.OUTLINE)
weapon_info_font = render.create_font("GoForce Bold-Alt", 16, 760)

screen_size = render.get_screen_size()

weapon_lists = {
    ['deagle'] = 1,
    ['elite'] = 2,
    ['fiveseven'] = 3,
    ['glock'] = 4,
    ['ak47'] = 7,
    ['aug'] = 8,
    ['awp'] = 9,
    ['famas'] = 10,
    ['g3sg1'] = 11,
    ['galilar'] = 13,
    ['m249'] = 14,
    ['m4a1'] = 16,
    ['mac10'] = 17,
    ['p90'] = 19,
    ['mp5sd'] = 23,
    ['ump45'] = 24,
    ['xm1014'] = 25,
    ['bizon'] = 26,
    ['mag7'] = 27,
    ['negev'] = 28,
    ['sawedoff'] = 29,
    ['tec9'] = 30,
    ['taser'] = 31,
    ['p2000'] = 32,
    ['mp7'] = 33, 
    ['mp9'] = 34, 
    ['nova'] = 35,
    ['p250'] = 36,
    ['shield'] = 37,
    ['scar20'] = 38,
    ['sg556'] = 39,
    ['ssg08'] = 40,
    ['knifegg'] = 41,
    ['knife'] = 42,
    ['flashbang'] = 43,
    ['hegrenade'] = 44,
    ['smokegrenade'] = 45,
    ['molotov'] = 46,
    ['decoy'] = 47,
    ['incgrenade'] = 48,
    ['c4'] = 49,
    ['healthshot'] = 57,
    ['knife_t'] = 59,
    ['m4a1-s'] = 60,
    ['usp-s'] = 61,
    ['cz75a'] = 63,
    ['revolver'] = 64,
    ['tagrenade'] = 68,
    ['fists'] = 69,
    ['breachcharge'] = 70, 
    ['tablet'] = 72,
    ['melee'] = 74,
    ['axe'] = 75,
    ['hammer'] = 76,    
    ['spanner'] = 78, 
    ['firebomb'] = 81, 
    ['diversion'] = 82, 
    ['frag-grenade'] = 83,
    ['snowball'] = 84,
    ['bumpmine'] = 85,
    ['boyonet'] = 500,

}

sw = menu.add_checkbox('A',"Enabled Weapon Info Panel")
xx = menu.add_slider("A",'X',0,screen_size.x)
yy = menu.add_slider("A",'Y',0,screen_size.y)

size = render.get_text_size(ideal_font, "[ Weapon Info ]")

getweapon = function()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end
        weapon_name = active_weapon:get_name()
    else 
        return 
    end
    
    return weapon_name
end

callbacks.add(e_callbacks.PAINT, function()
    local mast = sw:get()
    xx:set_visible(mast)
    yy:set_visible(mast
)
    if not sw:get() then return end
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end

    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    if local_player:get_prop("m_iHealth") <= 0 then
        return 
    end

    local weapon_list = {
        "glock",
        "p250",
        "cz75a",
        "usp-s",
        "tec9",
        "p2000",
        "fiveseven",
        "elite"
    }
    
    local pos = vec2_t(screen_size.x/2 + 30,screen_size.y/2 - 30)

    local weapon_name_ref = getweapon()

    local function Ispi()
        for i = 1,#weapon_list do
            if weapon_name_ref == weapon_list[i] then
                return true
            end
        end

        return false
    end

    if weapon_name_ref == 'ssg08' then 
        weapon_name = 'scout'
    elseif weapon_name_ref == 'scar20' or weapon_name_ref == 'g3sg1' then
        weapon_name = 'auto'
    elseif weapon_name_ref == 'awp' then
        weapon_name = 'awp'
    elseif weapon_name_ref == 'deagle' then
        weapon_name = 'deagle'
    elseif weapon_name_ref == 'revolver' then
        weapon_name = 'revolver'
    elseif Ispi() then
        weapon_name = 'pistols'
    else
        weapon_name = 'other'
    end

    if menu.find("aimbot", weapon_name, "target overrides", "force min. damage")[2]:get() then
        local s = unpack(menu.find("aimbot", weapon_name, "target overrides", "force min. damage"))
        dmg = s:get()
    else
        local s = menu.find("aimbot", weapon_name, "targeting", "min. damage")
        dmg = s:get()
    end

    if menu.find("aimbot", weapon_name, "target overrides", "force hitchance")[2]:get() then
        local hcs = unpack(menu.find("aimbot", weapon_name, "target overrides", "force hitchance"))
        hc = hcs:get()
    else
        local hcs = menu.find("aimbot", weapon_name, "targeting", "hitchance")
        hc = hcs:get()
    end

    if hc == nil or dmg == nil then return end

    if menu.find("aimbot", weapon_name, "target overrides", "force hitbox")[2]:get() then
        hitbox_fade = 255
    else
        hitbox_fade = 100
    end

    render.rect_filled(vec2_t(xx:get(), yy:get()), vec2_t(170, 95), color_t(0,0,0,180),8)
    render.text(ideal_font, "[ Weapon Info ]",vec2_t(xx:get()+85, yy:get()+15), color_t(255,255,255),true)

    if weapon_name_ref == nil then return end

    render.weapon_icon(weapon_lists[weapon_name_ref] ,vec2_t(xx:get()+20, yy:get()+30), color_t(255, 255, 255, 255))
    render.text(weapon_info_font, "DMG: "..tostring(dmg),vec2_t(xx:get()+20, yy:get()+50), color_t(255,255,255))
    render.text(weapon_info_font, "HC: "..tostring(hc),vec2_t(xx:get()+20, yy:get()+68), color_t(255,255,255))

    if menu.find("aimbot", "general", "exploits", "doubletap", 'enable')[2]:get() then
        dt_fade = 255
    else
        dt_fade = 100
    end

    if menu.find("aimbot", "general", "exploits", "hideshots", 'enable')[2]:get() then
        hs_fade = 255
    else
        hs_fade = 100
    end
    
    render.text(weapon_info_font, "| HS |",vec2_t(xx:get()+110, yy:get()+30), color_t(255,255,255,hs_fade))
    render.text(weapon_info_font, "| DT |",vec2_t(xx:get()+110, yy:get()+48), color_t(255,255,255,dt_fade))
    render.text(weapon_info_font, "| BAIM |",vec2_t(xx:get()+103, yy:get()+66), color_t(255,255,255,hitbox_fade))
end)