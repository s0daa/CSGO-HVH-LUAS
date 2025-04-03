local indicator = render.create_font('Verdana', 16, 500, e_font_flags.ANTIALIAS)
local missfont = render.create_font('Verdana', 13, 200, e_font_flags.ANTIALIAS)
local main_font = render.create_font("Verdana", 13, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

local MinDMG = menu.add_checkbox("General", "Show Min Damage", on_paint)
local NormalDMG = menu.add_checkbox("General", "Show Normal Damage", on_paint)
local Hitmiss = menu.add_checkbox("General", "Show Hit/Miss Ratio", on_paint)
local Onshot = menu.add_checkbox("General", "Show Onshot indicator", on_paint)
local Safepoint = menu.add_checkbox("General", "Show Safepoint indicator", on_paint)
local Doubletapbtn = menu.add_checkbox("General", "Show Doubletap indicator", on_paint)
local Pingbtn = menu.add_checkbox("General", "Show Ping indicator", on_paint)

local data = { 
    hit = 0,
    shot = 0
}

local screen_size = render.get_screen_size()
local x = screen_size.x / 1.98
local y = screen_size.y / 2.01

local Hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")
local Doubletap = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local Ping = menu.find("aimbot", "general", "fake ping", "enable")
local AutoSP = menu.find("aimbot", "auto", "target overrides", "force safepoint")
local ScoutSP = menu.find("aimbot", "scout", "target overrides", "force safepoint")
local AwpSP = menu.find("aimbot", "awp", "target overrides", "force safepoint")
local DeagleSP = menu.find("aimbot", "deagle", "target overrides", "force safepoint")
local RevolverSP = menu.find("aimbot", "revolver", "target overrides", "force safepoint")

--DMG INDICATORS START
local AutoO = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local ScoutO = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local DeagleO = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
local RevolverO = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
local PistolO = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local AwpO = menu.find("aimbot", "awp", "target overrides", "force min. damage")
local Auto = menu.find("aimbot", "auto", "targeting","min. damage")
local Scout = menu.find("aimbot", "scout", "targeting","min. damage")
local Deagle = menu.find("aimbot", "deagle", "targeting","min. damage")
local Revolver = menu.find("aimbot", "revolver", "targeting","min. damage")
local Pistol = menu.find("aimbot", "pistols", "targeting","min. damage")
local Awp = menu.find("aimbot", "awp", "targeting","min. damage")

local AutoFO = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local ScoutFO = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local DeagleFO = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
local RevolverFO = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local PistolFO = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))
local AwpFO = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
--DMG INDICATORS END

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

local on_shot = function()
    data.shot = data.shot + 1
end

local on_hit = function ()
    data.hit = data.hit + 1
end




local on_paint = function()
    local Hitandmiss = string.format('%d / %d (%s)', data.hit, data.shot, math.floor(data.hit/data.shot * 100) )
    local_player = entity_list.get_local_player( )
    if not local_player and not engine.is_connected() then
        return
    elseif Hitmiss:get() then
        render.text(missfont, Hitandmiss, vec2_t(x, y - -8), color_t(255, 255, 255, 255))
    end

    if not engine.is_in_game() then
        data.shot = 0
        data.hit = 0
    end

    local ONSHOTindi = string.format('ONSHOT')
    local SAFEindi = string.format('SAFE')
    local DTindi = string.format('DT')
    local PINGindi = string.format('PING')

    if Onshot:get() and Safepoint:get() and Doubletapbtn:get() and Pingbtn:get() and Ping[2]:get() and Doubletap[2]:get() and Hideshots[2]:get() and ScoutSP[2]:get() and AutoSP[2]:get() and AwpSP[2]:get() and DeagleSP[2]:get() and RevolverSP[2]:get() then
        render.text(indicator, ONSHOTindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
        render.text(indicator, SAFEindi, vec2_t(x, y - -30), color_t(114, 201, 52 ,255))
        render.text(indicator, PINGindi, vec2_t(x, y - -42), color_t(114, 201, 52 ,255))
        render.text(indicator, DTindi, vec2_t(x, y - -54), color_t(114, 201, 52 ,255))
    elseif Onshot:get() and Safepoint:get() and Doubletapbtn:get() and Doubletap[2]:get() and Hideshots[2]:get() and ScoutSP[2]:get() and AutoSP[2]:get() and AwpSP[2]:get() and DeagleSP[2]:get() and RevolverSP[2]:get() then
        render.text(indicator, ONSHOTindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
        render.text(indicator, SAFEindi, vec2_t(x, y - -30), color_t(114, 201, 52 ,255))
        render.text(indicator, DTindi, vec2_t(x, y - -42), color_t(114, 201, 52 ,255))
    elseif Onshot:get() and Safepoint:get() and Pingbtn:get() and Ping[2]:get() and  Hideshots[2]:get() and ScoutSP[2]:get() and AutoSP[2]:get() and AwpSP[2]:get() and DeagleSP[2]:get() and RevolverSP[2]:get() then
        render.text(indicator, ONSHOTindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
        render.text(indicator, SAFEindi, vec2_t(x, y - -30), color_t(114, 201, 52 ,255))
        render.text(indicator, PINGindi, vec2_t(x, y - -42), color_t(114, 201, 52 ,255))
    elseif Onshot:get() and Doubletapbtn:get() and Pingbtn:get() and Ping[2]:get() and Doubletap[2]:get() and Hideshots[2]:get() then
        render.text(indicator, ONSHOTindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
        render.text(indicator, PINGindi, vec2_t(x, y - -30), color_t(114, 201, 52 ,255))
        render.text(indicator, DTindi, vec2_t(x, y - -42), color_t(114, 201, 52 ,255))
    elseif Safepoint:get() and Doubletapbtn:get() and Pingbtn:get() and Ping[2]:get() and Doubletap[2]:get() and ScoutSP[2]:get() and AutoSP[2]:get() and AwpSP[2]:get() and DeagleSP[2]:get() and RevolverSP[2]:get() then
        render.text(indicator, SAFEindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
        render.text(indicator, PINGindi, vec2_t(x, y - -30), color_t(114, 201, 52 ,255))
        render.text(indicator, DTindi, vec2_t(x, y - -42), color_t(114, 201, 52 ,255))
    elseif Onshot:get() and Safepoint:get() and Hideshots[2]:get() and ScoutSP[2]:get() and AutoSP[2]:get() and AwpSP[2]:get() and DeagleSP[2]:get() and RevolverSP[2]:get() then
        render.text(indicator, ONSHOTindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
        render.text(indicator, SAFEindi, vec2_t(x, y - -30), color_t(114, 201, 52 ,255))
    elseif Onshot:get() and Doubletapbtn:get() and Hideshots[2]:get() and Doubletap[2]:get() then
        render.text(indicator, ONSHOTindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
        render.text(indicator, DTindi, vec2_t(x, y - -30), color_t(114, 201, 52 ,255))
    elseif Onshot:get() and Hideshots[2]:get() and Pingbtn:get() and Ping[2]:get()then
        render.text(indicator, ONSHOTindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
        render.text(indicator, PINGindi, vec2_t(x, y - -30), color_t(114, 201, 52 ,255))
    elseif Doubletapbtn:get() and Doubletap[2]:get() and Pingbtn:get() and Ping[2]:get() then
        render.text(indicator, PINGindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
        render.text(indicator, DTindi, vec2_t(x, y - -30), color_t(114, 201, 52 ,255))
    elseif Safepoint:get() and Pingbtn:get() and Ping[2]:get() and ScoutSP[2]:get() and AutoSP[2]:get() and AwpSP[2]:get() and DeagleSP[2]:get() and RevolverSP[2]:get() then
        render.text(indicator, SAFEindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
        render.text(indicator, PINGindi, vec2_t(x, y - -30), color_t(114, 201, 52 ,255))
    elseif Safepoint:get() and Doubletapbtn:get() and Doubletap[2]:get() and ScoutSP[2]:get() and AutoSP[2]:get() and AwpSP[2]:get() and DeagleSP[2]:get() and RevolverSP[2]:get() then
        render.text(indicator, SAFEindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
        render.text(indicator, DTindi, vec2_t(x, y - -30), color_t(114, 201, 52 ,255))
    elseif Safepoint:get() and ScoutSP[2]:get() and AutoSP[2]:get() and AwpSP[2]:get() and DeagleSP[2]:get() and RevolverSP[2]:get() then
        render.text(indicator, SAFEindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
    elseif Doubletapbtn:get() and Doubletap[2]:get() then
        render.text(indicator, DTindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
    elseif Onshot:get() and Hideshots[2]:get() then
        render.text(indicator, ONSHOTindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
    elseif Pingbtn:get() and Ping[2]:get() then
        render.text(indicator, PINGindi, vec2_t(x, y - -18), color_t(114, 201, 52 ,255))
    end
    
    NormalDMG:set_visible(false)

    if MinDMG:get() then
        NormalDMG:set_visible(true)
    end

    if NormalDMG:get() then

        if getweapon() == "ssg08" then
            if ScoutO[2]:get() then
                render.text(main_font, ("Damage:") .. tostring(ScoutFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            else NormalDMG:get()
                render.text(main_font, ("Damage:") .. tostring(Scout:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "deagle" then
            if DeagleO[2]:get() then
                render.text(main_font, ("Damage:") .. tostring(DeagleFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            else NormalDMG:get() 
                render.text(main_font, ("Damage:") .. tostring(Deagle:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "revolver" then
            if RevolverO[2]:get() then
                render.text(main_font, ("Damage:") .. tostring(RevolverFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            else NormalDMG:get() 
                render.text(main_font, ("Damage:") .. tostring(Revolver:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "awp" then
            if AwpO[2]:get() then
                render.text(main_font, ("Damage:") .. tostring(AwpFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            else NormalDMG:get() 
                render.text(main_font, ("Damage:") .. tostring(Awp:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
            if AutoO[2]:get() then
                render.text(main_font, ("Damage:") .. tostring(AutoFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            else NormalDMG:get() 
                render.text(main_font, ("Damage:") .. tostring(Auto:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
            if PistolO[2]:get() then
                render.text(main_font, ("Damage:") .. tostring(PistolFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            else NormalDMG:get() 
                render.text(main_font, ("Damage:") .. tostring(Pistol:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        end
    elseif MinDMG:get() then
        if getweapon() == "ssg08" then
            if ScoutO[2]:get() then
                render.text(main_font, ("Damage:") .. tostring(ScoutFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "deagle" then
            if DeagleO[2]:get() then
                render.text(main_font, ("Damage:") .. tostring(DeagleFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "revolver" then
            if RevolverO[2]:get() then
                render.text(main_font, ("Damage:") .. tostring(RevolverFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "awp" then
            if AwpO[2]:get() then
                render.text(main_font, ("Damage:") .. tostring(AwpFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
            if AutoO[2]:get() then
                render.text(main_font, ("Damage:") .. tostring(AutoFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
            if PistolO[2]:get() then
                render.text(main_font, ("Damage:") .. tostring(PistolFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        end
    end





















end
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_shot)
callbacks.add(e_callbacks.AIMBOT_HIT, on_hit)
callbacks.add(e_callbacks.PAINT, on_paint)