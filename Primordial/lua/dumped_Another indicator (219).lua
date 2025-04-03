--made by antiorder--
 local menu_color = select(2, unpack(menu.find("misc", "main", "config", "accent color")))
 local font = render.create_font("Verdana", 12, 565,e_font_flags.OUTLINE)
 local font1 = render.create_font("Verdana", 12, 20,e_font_flags.OUTLINE)

 local screen_size = render.get_screen_size()

   local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") 
   local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") 
   local isSW = menu.find("misc","main","movement","slow walk", "enable") 
   local isBA = menu.find("aimbot", "scout", "target overrides", "force hitbox") 
   local isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint")
   local isAA = menu.find("antiaim", "main", "desync", "yaw base") 
   local isFD = menu.find("antiaim", "main", "general", "fake duck") 
   local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") 
 
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
   
    local chocking = engine.get_choked_commands()
    local charge = exploits.get_charge()
    local maxcharge = exploits.get_max_charge()
    local DS =antiaim.get_max_desync_range()
    local local_player = entity_list.get_local_player()
    local hp = local_player:get_prop("m_iHealth")
    local fake = antiaim.get_max_desync_range()
    local user = user.name
    local pos = vec2_t(0, 0)
    local addpos = vec2_t(0, 32)
    local pos = vec2_t(screen_size.x * 0.0041666666, screen_size.y * 0.47777777777)
    pos = pos
 --box
    render.rect_filled(pos+vec2_t(0, 5), vec2_t(200, 245), color_t(0,0,0))
    render.rect_filled(pos+vec2_t(1, 6), vec2_t(198, 243), color_t(60,60,60))
    render.rect_filled(pos+vec2_t(2, 7), vec2_t(196, 241), color_t(30,30,30))
    render.rect_filled(pos+vec2_t(12, 5), vec2_t(64, 2), color_t(30,30,30))
   

  
    --Nane
    render.text(font,"Indicators",pos+vec2_t(15,0), color_t(255,255,255))
    --hp
    
    render.text(font1,"HP: ",pos+vec2_t(105,15), color_t(255,255,255))
    render.text(font1,tostring(local_player:get_prop("m_iHealth")),pos+vec2_t(125,15), color_t(255,255,255))
    render.rect_filled(pos+vec2_t(84, 30), vec2_t(100, 7), color_t(0,0,0))
    render.rect_filled(pos+vec2_t(85, 31), vec2_t(98, 5), color_t(70,70,70))
    render.rect_fade(pos+vec2_t(85, 31), vec2_t(hp-2, 5),menu_color:get(), color_t(0,0,0,20) )

    render.text(font1,""..user,pos+vec2_t(20,27), color_t(255,255,255))
    --Dt
    render.text(font1,"DoubleTap",pos+vec2_t(35,55), color_t(255,255,255))
    if isDT[2]:get() then
        render.rect_filled(pos+vec2_t(19, 56), vec2_t(9, 9), color_t(0,0,0))
        render.rect_fade(pos+vec2_t(20, 57), vec2_t(7, 7), menu_color:get(), color_t(0,0,0,20))
        
    else 
        render.rect_filled(pos+vec2_t(19, 56), vec2_t(9, 9), color_t(0,0,0))
        render.rect_filled(pos+vec2_t(20, 57), vec2_t(7, 7), color_t(70,70,70))
       
    end 
    --baim
    render.text(font1,"Body-aim",pos+vec2_t(35,75), color_t(255,255,255))
    if isBA[2]:get() then
        render.rect_filled(pos+vec2_t(19, 76), vec2_t(9, 9), color_t(0,0,0))
        render.rect_fade(pos+vec2_t(20, 77), vec2_t(7, 7), menu_color:get(), color_t(0,0,0,20))
        
    else 
        render.rect_filled(pos+vec2_t(19, 76), vec2_t(9, 9), color_t(0,0,0))
        render.rect_filled(pos+vec2_t(20, 77), vec2_t(7, 7), color_t(70,70,70))
       
    end
    --desync
    render.text(font1,"Desync",pos+vec2_t(79,95), color_t(255,255,255))
    render.text(font1,"MIN",pos+vec2_t(39,107), color_t(255,255,255))
    render.text(font1,"MAX",pos+vec2_t(130,107), color_t(255,255,255))
    render.rect_filled(pos+vec2_t(64, 110), vec2_t(60, 8),  color_t(0,0,0))
    render.rect_filled(pos+vec2_t(65, 111), vec2_t(58, 6),  color_t(70,70,70))
    render.rect_fade(pos+vec2_t(65, 111), vec2_t(fake, 6), menu_color:get(), color_t(0,0,0,20))
    render.text(font1,tostring(antiaim.get_max_desync_range().."°"),pos+vec2_t(90,120), color_t(255,255,255))

    --fake
    render.text(font1,"Fake",pos+vec2_t(85,135), color_t(255,255,255))
    render.text(font1,"MIN",pos+vec2_t(61,147), color_t(255,255,255))
    render.text(font1,"MAX",pos+vec2_t(107,147), color_t(255,255,255))
    render.rect_filled(pos+vec2_t(86, 150), vec2_t(16, 8),  color_t(0,0,0))
    render.rect_filled(pos+vec2_t(87, 151), vec2_t(15, 6),  color_t(70,70,70))
    render.rect_fade(pos+vec2_t(87, 151), vec2_t(chocking, 6), menu_color:get(), color_t(0,0,0,20))
    render.text(font1,tostring(chocking.."t"),pos+vec2_t(88,160), color_t(255,255,255))
--FD
    render.text(font1,"Fak Duck",pos+vec2_t(35,170), color_t(255,255,255))
    if isFD[2]:get() then
        render.rect_filled(pos+vec2_t(19, 171), vec2_t(9, 9), color_t(0,0,0))
        render.rect_fade(pos+vec2_t(20, 172), vec2_t(7, 7), menu_color:get(), color_t(0,0,0,20))
        
    else 
        render.rect_filled(pos+vec2_t(19, 171), vec2_t(9, 9), color_t(0,0,0))
        render.rect_filled(pos+vec2_t(20, 172), vec2_t(7, 7), color_t(70,70,70))
       
    end
--HS
    render.text(font1,"Hide Shots",pos+vec2_t(35,190), color_t(255,255,255))
    if isHS[2]:get() then
        render.rect_filled(pos+vec2_t(19, 191), vec2_t(9, 9), color_t(0,0,0))
        render.rect_fade(pos+vec2_t(20, 192), vec2_t(7, 7), menu_color:get(), color_t(0,0,0,20))
        
    else 
        render.rect_filled(pos+vec2_t(19, 191), vec2_t(9, 9), color_t(0,0,0))
        render.rect_filled(pos+vec2_t(20, 192), vec2_t(7, 7), color_t(70,70,70))
       
    end
 --AP
    render.text(font1,"Auto Peek",pos+vec2_t(35,210), color_t(255,255,255))
    if isAP[2]:get() then
        render.rect_filled(pos+vec2_t(19, 211), vec2_t(9, 9), color_t(0,0,0))
        render.rect_fade(pos+vec2_t(20, 212), vec2_t(7, 7), menu_color:get(), color_t(0,0,0,20))
        
    else 
        render.rect_filled(pos+vec2_t(19, 211), vec2_t(9, 9), color_t(0,0,0))
        render.rect_filled(pos+vec2_t(20, 212), vec2_t(7, 7), color_t(70,70,70))
       
    end
   --DMG
    render.text(font1, "DMG: ", pos+vec2_t(35,230), color_t(255,255,255,255))
    if  get_weapon_group()[2] then
        render.rect_filled(pos+vec2_t(19, 231), vec2_t(9, 9), color_t(0,0,0))
        render.rect_fade(pos+vec2_t(20, 232), vec2_t(7, 7), menu_color:get(), color_t(0,0,0,20))
        render.text(font1, "[ "..get_weapon_group()[1].." ]", pos+vec2_t(67,230), menu_color:get())

        

    else
        render.rect_filled(pos+vec2_t(19, 231), vec2_t(9, 9), color_t(0,0,0))
        render.rect_filled(pos+vec2_t(20, 232), vec2_t(7, 7), color_t(70,70,70))
        render.text(font1, "[ "..get_weapon_group()[1].." ]", pos+vec2_t(67,230),color_t(255,255,255,255)) 

     
    end
 

 end
 
   --=====Callback=====--
 callbacks.add(e_callbacks.PAINT, on_paint)
   --=====Callbackend=====--