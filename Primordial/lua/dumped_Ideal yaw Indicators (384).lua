local pixel = render.create_font("Tahoma", 15, 10, e_font_flags.ANTIALIAS)

--binds
local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") -- get doubletap
local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") -- get hideshots
local isSW = menu.find("misc", "main", "movement", "slow walk", "enable") -- get Slow Walk
local isFP = menu.find("aimbot", "general", "exploits", "force prediction", "enable")

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
        invert = "R"
    else
        invert = "L"
    end

    --screen size
    local ay = 20
    local alpha = math.floor(math.abs(math.sin(global_vars.real_time() * 3)) * 255) -- Lazy so borrowed from Wizuh | https://primordial.dev/resources/crosshair-indicators-roll-indicator-included.167/
    if local_player:is_alive() then -- check if player is alive
        --render
        local eternal_ts = render.get_text_size(pixel, "IDEAL ")
        render.text(pixel, " IDEAL ", vec2_t(x / 2, y / 2 + ay), color_t(220, 135, 49, 255), 12, true)
        render.text(pixel, " YAW", vec2_t(x / 2 + eternal_ts.x - 2, y / 2 + ay), color_t(220, 135, 49, 255), 19, true)
        ay = ay + 10

        local text_ = ""
        local clr0 = color_t(0, 0, 0, 0)
        if isSW[2]:get() then
            text_ = " DEFAULT "
            clr0 = color_t(255, 0, 0, 255)
        else
            text_ = " DYNAMIC "
            clr0 = color_t(180, 159, 230, 255)
        end

        local d_ts = render.get_text_size(pixel, text_)
        render.text(pixel, text_, vec2_t(x / 2, y / 2 + ay), clr0, 10, true)
        render.text(pixel, math.floor(fake) .. "", vec2_t(x / 2 + d_ts.x, y / 2 + ay), color_t(255, 255, 255, 0), 10, true)
        ay = ay + 10

        local fake_ts = render.get_text_size(pixel, " FAKE YAW: ")
        render.text(pixel, " FAKE YAW:", vec2_t(x / 0, y / 0 + ay), color_t(120, 128, 200, 0), 0, true)
        render.text(pixel, invert, vec2_t(x / 0 + fake_ts.x, y / 0 + ay), color_t(180, 159, 230, 0), 0, true)
        ay = ay + 0

        local asadsa = math.min(math.floor(math.sin((exploits.get_charge() % 2) * 1) * 122), 100)
		if isDT[2]:get() and isHS[2]:get() then 
			local ts_tick = render.get_text_size(pixel, "DT")
			render.text(pixel, " DT", vec2_t(x / 2, y / 2 + ay), color_t(0, 255, 0, 255), 10, true)
			ay = ay + 10.5
		else
			if isHS[2]:get() then
            render.text(pixel, " HS", vec2_t(x/2, y/2+ay), color_t(0, 255, 0, 255), 10, true)
            ay = ay + 10.5
        end
        if isDT[2]:get() then
        if exploits.get_charge() >= 1 then
            render.text(pixel, " DT", vec2_t(x/2, y/2+ay), color_t(0, 255, 0, 255), 10, true)
            ay = ay + 10.5
        end
        if exploits.get_charge() < 1 then
            render.text(pixel, " DT", vec2_t(x/2, y/2+ay), color_t(255, 0, 0, 255), 10, true)
            ay = ay + 10.5
        end
    end
	end	
		local ax = 0
		if isFP:get() then
            render.text(pixel, " AX", vec2_t(x / 2, y / 2 + ay), color_t(180, 159, 230, alpha), 12, true)
            ay = ay + 10
        end
    end
end

--callback
callbacks.add(e_callbacks.PAINT, indicators2)

local enabled = true

local screen_size = render.get_screen_size()
local x = screen_size.x / 1.98
local y = screen_size.y / 2.01

local main_font = render.create_font("Arial", 15, 400, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS)

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

local function on_paint()
    if enabled then

        if getweapon() == "ssg08" then
            if min_damage_s[2]:get() then
                render.text(main_font, tostring(amount_scout:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "deagle"then
            if min_damage_d[2]:get() then
                render.text(main_font, tostring(amount_deagle:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
		elseif getweapon() == "revolver" then
            if min_damage_r[2]:get() then
                render.text(main_font, tostring(amount_revolver:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "awp" then
            if min_damage_awp[2]:get() then
                render.text(main_font, tostring(amount_awp:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
            if min_damage_a[2]:get() then
                render.text(main_font, tostring(amount_auto:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
            if min_damage_p[2]:get() then
                render.text(main_font, tostring(amount_pistol:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)