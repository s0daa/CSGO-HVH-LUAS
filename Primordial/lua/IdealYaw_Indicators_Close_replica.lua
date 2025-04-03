--Made By Astral#1001

local pixel = render.create_font("Tahoma", 12, 300, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

--binds
local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") -- get doubletap
local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") -- get hideshots
local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") -- get autopeek
local isSW = menu.find("misc","main","movement","slow walk", "enable") -- get Slow Walk
local min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local min_damage_h = menu.find("aimbot", "heavy pistols", "target overrides", "force min. damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")
local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
local amount_revolver = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local amount_deagle = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local amount_pistol = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))
local isBA = menu.find("aimbot", "scout", "target overrides", "force hitbox") -- get froce baim
local isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint") -- get safe point
local isAA = menu.find("antiaim", "main", "angles", "yaw base") -- get yaw base

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

--indicators
local fake = antiaim.get_fake_angle()
local currentTime = global_vars.cur_time
local function indicators2()
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
    --screen size
    local x = render.get_screen_size().x
    local y = render.get_screen_size().y

    --invert state
    if antiaim.is_inverting_desync() == false then
        invert ="R"
    else
        invert ="L"
    end

    --screen size
    local ay = 20
    local alpha = math.min(math.floor(math.sin((global_vars.real_time()%3) * 4) * 175 + 50), 255)
    if local_player:is_alive() then -- check if player is alive
    --render
    local eternal_ts = render.get_text_size(pixel, "ACATEL ")
    render.text(pixel, "IDEAL YAW", vec2_t(x/2, y/2+ay), color_t(220, 135, 49, 255), 12, true)
    render.text(pixel, "YAW", vec2_t(x/2+eternal_ts.x-2, y/2+ay), color_t(220, 135, 49, 0), 10, true)
    ay = ay + 10

    local asadsa = math.min(math.floor(math.sin((exploits.get_charge()%2) * 1) * 122), 100)
    if isAP[2]:get() and isDT[2]:get() then 
        local ts_tick = render.get_text_size(pixel, "IDEALTICK ")
        render.text(pixel, "IDEALTICK", vec2_t(x/2, y/2+ay), color_t(180, 159, 230, 255), 10, true)
        render.text(pixel, "x"..asadsa, vec2_t(x/2+ts_tick.x, y/2+ay), exploits.get_charge() == 1 and color_t(0, 255, 0, 255) or color_t(255, 0, 0, 255), 10, true)
        ay = ay + 10
    else
        if isAP[2]:get() then
            render.text(pixel, "PEEK", vec2_t(x/2, y/2+ay), color_t(180, 159, 230, 255), 10, true)
            ay = ay + 10
        end
        if isDT[2]:get() then
        if exploits.get_charge() >= 1 then
            render.text(pixel, "DT", vec2_t(x/2, y/2+ay), color_t(0, 255, 0, 255), 10, true)
            ay = ay + 10
        end
        if exploits.get_charge() < 1 then
            render.text(pixel, "DT", vec2_t(x/2, y/2+ay), color_t(255, 0, 0, 255), 10, true)
            ay = ay + 10
        end
    end
    end
    if getweapon() == "ssg08" then
        if min_damage_s[2]:get() then
            render.text(pixel, "DMG: "..tostring(amount_scout:get()), vec2_t(x/2, y/2+ay), color_t(180, 159, 230, 255), 10, true)
            ay = ay + 10
        end
    elseif getweapon() == "deagle" or getweapon() == "revolver" then
        if min_damage_h[2]:get() then
            render.text(pixel, "DMG: "..tostring(amount_heavy:get()), vec2_t(x/2, y/2+ay), color_t(180, 159, 230, 255), 10, true)
            ay = ay + 10
        end
    elseif getweapon() == "awp" then
        if min_damage_awp[2]:get() then
            render.text(pixel, "DMG: "..tostring(amount_awp:get()), vec2_t(x/2, y/2+ay), color_t(180, 159, 230, 255), 10, true)
            ay = ay + 10
        end
    elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
        if min_damage_a[2]:get() then
            render.text(pixel, "DMG: "..tostring(amount_auto:get()), vec2_t(x/2, y/2+ay), color_t(180, 159, 230, 255), 10, true)
            ay = ay + 10
        end
    elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
        if min_damage_p[2]:get() then
            render.text(pixel, "DMG: "..tostring(amount_pistol:get()), vec2_t(x/2, y/2+ay), color_t(180, 159, 230, 255), 10, true)
            ay = ay + 10
        end
    end

    local ax = 0
    if isHS[2]:get() then
        render.text(pixel, "AA", vec2_t(x/2, y/2+ay), color_t(120, 128, 200, 255), 12, true)
        ay = ay + 10
    end

    render.text(pixel, "BAIM", vec2_t(x/2, y/2+ay), isBA[2]:get() == 2 and color_t(255, 255, 255, 0) or color_t(255, 255, 255, 0), 10, true)
    ax = ax + render.get_text_size(pixel, "BAIM ").x

    render.text(pixel, "FS", vec2_t(x/2+ax, y/2+ay), isAA:get() == 5 and color_t(255, 255, 255, 0) or color_t(255, 255, 255, 0), 10, true)
end
end

--callback
callbacks.add(e_callbacks.PAINT,indicators2)