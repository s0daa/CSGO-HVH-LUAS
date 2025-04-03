local menu_color = select(2, unpack(menu.find("misc", "main", "config", "accent color")))
 local font = render.create_font("Arial", 13, 20,e_font_flags.ANTIALIAS)
 local screen_size = render.get_screen_size()

   local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") 
   local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") 
   local isSW = menu.find("misc","main","movement","slow walk", "enable") 
   local isBA = menu.find("aimbot", "scout", "target overrides", "force hitbox") 
   local isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint")
   local isAA = menu.find("antiaim", "main", "angles", "yaw base") 
   local isFD = menu.find("antiaim", "main", "general", "fake duck") 
   local groups = {
    ['auto'] = 0,
    ['scout'] = 1,
    ['awp'] = 2,
    ['deagle'] = 3,
    ['revolver'] = 4,
    ['pistols'] = 5,
    ['other'] = 6
}
local current_min = nil
local key_active = nil
local force_lethal = nil
local hitbox_ovr = nil
local force_sp = nil
local force_hc = nil
local math_funcs = { 

    get_min_dmg = function(wpn_type) 
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

local function get_weapon_group() 
    for key, value in pairs(groups) do
        if value == ragebot.get_active_cfg() then
            current_min = math_funcs.get_min_dmg(key)[1];
            key_active = math_funcs.get_min_dmg(key)[2];
            force_lethal = math_funcs.get_min_dmg(key)[3];
            hitbox_ovr = math_funcs.get_min_dmg(key)[4];
            force_sp = math_funcs.get_min_dmg(key)[5];
            force_hc = math_funcs.get_min_dmg(key)[6];
        end
    end

    return {tostring(current_min), key_active, force_lethal, hitbox_ovr, force_sp, force_hc};
end
 local function on_paint()
    if not engine.is_connected() then
        return
    end

    if not engine.is_in_game() then
        return
    end
    local local_player = entity_list.get_local_player()

    local fake = antiaim.get_fake_angle()
    if antiaim.is_inverting_desync() == false then
        invert ="R"
    else
        invert ="L"
    end
    local x = render.get_screen_size().x
    local y = render.get_screen_size().y
    local chocking = engine.get_choked_commands()
    local charge = exploits.get_charge()
    local maxcharge = exploits.get_max_charge()
    local pos = vec2_t(0, 0)
    local addpos = vec2_t(0, 32)
    local pos = vec2_t(screen_size.x * 0.0041666666, screen_size.y * 0.47777777777)
    pos = pos
 --
    render.rect_filled(pos, vec2_t(150, 45), color_t(0,0,0))
    render.rect_fade(pos, vec2_t(3, 45), color_t(0,0,0,255),menu_color:get())
    render.rect_fade(pos+vec2_t(147,0), vec2_t(3, 45), color_t(0,0,0,255),menu_color:get())
    render.rect_filled(pos+vec2_t(0,42), vec2_t(150, 3), menu_color:get())
    --
    render.rect_filled(pos+vec2_t(0,60), vec2_t(150, 40), color_t(0,0,0))
    render.rect_filled(pos+vec2_t(0,60), vec2_t(150, 3), menu_color:get())
    render.rect_fade(pos+vec2_t(0,60), vec2_t(3, 40), menu_color:get(),color_t(0,0,0,255))
    render.rect_fade(pos+vec2_t(147,60), vec2_t(3, 40), menu_color:get(),color_t(0,0,0,255))

    render.text(font, "Fake-Lag:  ", pos+vec2_t(7,5), color_t(255,255,255,255))
    render.text(font, "[ "..chocking.." ]", pos+vec2_t(120,5), menu_color:get())
    render.text(font, "DoubleTap: ", pos+vec2_t(7,15), color_t(255,255,255,255))
    render.text(font, "[ "..charge.." ]", pos+vec2_t(120,15), menu_color:get())
    render.text(font, "FAKE YAW: ", pos+vec2_t(7,25), color_t(255,255,255,255))
    render.text(font, "[ "..invert.." ]", pos+vec2_t(120,25), menu_color:get())

    render.text(font, "DMG: ", pos+vec2_t(7,63), color_t(255,255,255,255))
    if  get_weapon_group()[2] then
        render.text(font, "["..get_weapon_group()[1].."]", pos+vec2_t(35,63), menu_color:get() or color_t(255,255,255,255))
    end

    if isSW[2]:get() then
        render.text(font, "SWALK", pos+vec2_t(7,73), menu_color:get())
    else
        render.text(font, "SWALK", pos+vec2_t(7,73), color_t(255,255,255,255))
    end
    if isHS[2]:get() then
        render.text(font, "OSAA", pos+vec2_t(63,63), menu_color:get())
    else
        render.text(font, "OSAA", pos+vec2_t(63,63), color_t(255,255,255,255))
    end
    if isAP[2]:get() then
        render.text(font, "A-PEEK", pos+vec2_t(63,73), menu_color:get())
    else
        render.text(font, "A-PEEK", pos+vec2_t(63,73), color_t(255,255,255,255))
    end
    if isBA[2]:get() then
        render.text(font, "BAIM", pos+vec2_t(7,83), menu_color:get())
    else
        render.text(font, "BAIM", pos+vec2_t(7,83), color_t(255,255,255,255))
    end
    if isSP[2]:get() then
        render.text(font, "FS", pos+vec2_t(63,83), menu_color:get())
    else
        render.text(font, "FS", pos+vec2_t(63,83), color_t(255,255,255,255))
    end
    if isFD[2]:get() then
        render.text(font, "DUCK", pos+vec2_t(105,63), menu_color:get())
    else
        render.text(font, "DUCK", pos+vec2_t(105,63), color_t(255,255,255,255))
    end

 end
 
   --=====Callback=======--
 callbacks.add(e_callbacks.PAINT, on_paint)
   --=====CallbackEnd=======--