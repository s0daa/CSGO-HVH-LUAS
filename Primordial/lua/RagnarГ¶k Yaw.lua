local conditions_names = { "Slow Walk", "In Air", "Ducking", "Standing", "Moving" }

local references = {
    lua = {
        active_tab = menu.add_selection( "Ragnarök Yaw", "[AA Builder] select condition", conditions_names ),
    },
    menu = {
        antiaim_list = {
            menu.find("antiaim", "main", "desync", "side"),
            menu.find("antiaim", "main", "desync", "left amount"),
            menu.find("antiaim", "main", "desync", "right amount"),
            menu.find("antiaim", "main", "angles", "yaw add"),
            menu.find("antiaim", "main", "angles", "rotate"),
            menu.find("antiaim", "main", "angles", "rotate range"),
            menu.find("antiaim", "main", "angles", "rotate speed"),
            menu.find("antiaim", "main", "angles", "jitter mode"),
            menu.find("antiaim", "main", "angles", "jitter add"),
            menu.find("antiaim", "main", "angles", "body lean"),
            menu.find("antiaim", "main", "angles", "body lean value"),
            menu.find("antiaim", "main", "angles", "body lean jitter"),
        },
        slowwalk = menu.find("misc", "main", "movement", "slow walk"),
    },
}

local condition_elements = { }
local invisible_elements = { }
for i = 1, #conditions_names do
    condition_elements[ i ] = {
        menu.add_text( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] customize ".. conditions_names[ i ] .." desync" ),
        menu.add_selection( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] side",  {"none", "left", "right", "jitter", "peek fake", "peek real", "body sway" } ),
        menu.add_slider( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] left amount", 0, 100 , 1, 0.1, "%"),
        menu.add_slider( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] right amount", 0, 100 , 1, 0.1, "%"),
        menu.add_selection( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] body lean", { "none", "static", "static Jitter", "random Jitter", "sway" } ),
        menu.add_slider( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] body lean value", -50, 50 , 1, 0.1, "°"),
        menu.add_slider( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] body lean jitter", 0, 100 , 1, 0.1, "%"),
        menu.add_text( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] customize ".. conditions_names[ i ] .." real" ),
        menu.add_slider( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] yaw add left", -180, 180 , 1, 0.1, "°"),
        menu.add_slider( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] yaw add right", -180, 180 , 1, 0.1, "°"),
        menu.add_checkbox( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] rotate", false ),
        menu.add_slider( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] rotate range", 0, 360 , 1, 0.1, "°"),
        menu.add_slider( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] rotate speed", 0, 100 , 1, 0.1, "%"),
        menu.add_selection( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] jitter mode", { "none", "static", "random" } ),
        menu.add_slider( "Ragnarök Yaw", "[".. conditions_names[ i ] .."] jitter add", -180, 180 , 1, 0.1, "°"),
    }

    invisible_elements[ i ] = menu.add_text( "invis" .. i, "niel" ) --prevents from voids in menu
    invisible_elements[ i ]:set_visible( false )
end

------------------------------------------------------------------------------

local enable_inds = menu.add_checkbox("Ragnarök Indicators", "enable indicators")
--local enable_water = menu.add_checkbox("Ragnarök Indicators", "enable watermark")

local function cfg_button()
    print("Default config loaded!")
    enable_inds:set(true)
    --enable_water:set(true)
end

local def_button = menu.add_button("Ragnarök Config System", "default config", cfg_button)

------------------------------------------------------------------------------

local function get_condition_index( old_cmd )
    if references.menu.slowwalk[2]:get( ) then
        return 1
    end

    local localplayer = entity_list:get_local_player()

    if localplayer:has_player_flag( e_player_flags.ON_GROUND ) == false or old_cmd:has_player_flag( e_player_flags.ON_GROUND ) == false then
        return 2
    end

    if localplayer:has_player_flag( e_player_flags.DUCKING ) then
        return 3
    end

    local velocity = math.sqrt( math.pow( localplayer:get_prop( "m_vecVelocity[0]" ), 2 ) + math.pow( localplayer:get_prop( "m_vecVelocity[1]" ), 2 ) )
    
    if velocity <= 5 then
        return 4
    else
        return 5
    end
end

local function solve_preset( condition_index )
    local preset = condition_elements[ condition_index ]
    local is_right = antiaim.get_real_angle() - antiaim.get_fake_angle() > 0
    local yaw_add = preset[ is_right and 9 or 10 ]:get( )
    local body_lean_value = preset[ 5 ]:get( ) == 2 and preset[ 6 ]:get( ) or 0
    local body_lean_jitter = ( preset[ 5 ]:get( ) == 3 or preset[ 5 ]:get( ) == 4 ) and preset[ 7 ]:get( ) or 0

    local result = {
        preset[ 2 ]:get( ),
        preset[ 3 ]:get( ),
        preset[ 4 ]:get( ),
        yaw_add,
        preset[ 11 ]:get( ),
        preset[ 12 ]:get( ),
        preset[ 13 ]:get( ),
        preset[ 14 ]:get( ),
        preset[ 15 ]:get( ),
        preset[ 5 ]:get( ),
        body_lean_value,
        body_lean_jitter
    }

    return result
end


local function on_antiaim( antiaim_context_t, user_cmd_t, unpredicted_data_t )
    local condition_index = get_condition_index( unpredicted_data_t )
    local preset = solve_preset( condition_index )

    for i = 1, #references.menu.antiaim_list do
        references.menu.antiaim_list[ i ]:set( preset[ i ] )
    end

end


------------------------------------------------------------------------------

--[[local verdana = render.create_font("Verdana", 12, 24, e_font_flags.ANTIALIAS)
local get_screen = render.get_screen_size()

local function Watermark()
    if enable_water:get() then
        local x = (get_screen.x);
		local tick = client.get_tickrate()
        local fps = client.get_fps()
		local WatermarkText = string.format(" Ragnarök Yaw | %s | frames: %i | tick: %s", user.name, fps, tick)
		local text_size = 12,12
        render.rect_filled(vec2_t(1680, 17), vec2_t(230, 1), color_t(79, 203, 255, 255))
        render.rect_filled(vec2_t(1680, 18), vec2_t(230, 17), color_t(0,0,0,150))
        render.text(verdana, WatermarkText, vec2_t(1680, 19), color_t(255,255,255,255))
    end  
end]]--

local pixel = render.create_font("Smallest Pixel-7", 10, 20, e_font_flags.OUTLINE)

--binds
local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") -- get doubletap
local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") -- get hideshots
local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") -- get autopeek
local isSW = menu.find("misc","main","movement","slow walk", "enable") -- get Slow Walk
local min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local min_damage_d = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
local min_damage_r = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")
local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
local amount_deagle = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
local amount_revolver = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
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
local currentTime = global_vars.cur_time
local function indicators()

    if enable_inds:get() then

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
        local ay = 40
        local alpha = math.min(math.floor(math.sin((global_vars.real_time()%3) * 1) * 175 + 50), 255)
        if local_player:is_alive() then -- check if player is alive
        --render
        local eternal_ts = render.get_text_size(pixel, "RAGNARÖK ")
        render.text(pixel, "RAGNARÖK ", vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
        render.text(pixel, "YAW", vec2_t(x/2+eternal_ts.x-2, y/2+ay), color_t(79, 203, 255, alpha), 10, true)
        ay = ay + 10.5
        
        local text_ =""
        local clr0 = color_t(0, 0, 0, 0)
        if isSW[2]:get() then
            text_ ="DANGEROUS+ "
            clr0 = color_t(255, 50, 50, 255)
        else
            text_ ="CONDITIONS- "
            clr0 = color_t(79, 203, 255, 255)
        end

        local d_ts = render.get_text_size(pixel, text_)
        render.text(pixel, text_, vec2_t(x/2, y/2+ay), clr0, 10, true)
        render.text(pixel, math.floor(antiaim.get_fake_angle()/2).."", vec2_t(x/2+d_ts.x, y/2+ay), color_t(255, 255, 255, 255), 10, true)
        ay = ay + 10.5
        
        local fake_ts = render.get_text_size(pixel, "FAKE YAW: ")
        render.text(pixel, "FAKE YAW:", vec2_t(x/2, y/2+ay), color_t(130, 130, 255, 255), 10, true)
        render.text(pixel, invert, vec2_t(x/2+fake_ts.x, y/2+ay), color_t(255, 255, 255, 255), 10, true)
        ay = ay + 10.5

        --local tickcharge = math.min(math.floor(math.sin((exploits.get_charge()%2) * 2) * 122), 100)
        
        if isAP[2]:get() and isDT[2]:get() then 
            local ts_tick = render.get_text_size(pixel, "IDEALTICK ")
            render.text(pixel, "IDEALTICK", vec2_t(x/2, y/2+ay), color_t(79, 203, 255, 255), 10, true)
            --render.text(pixel, "x"..tickcharge, vec2_t(x/2+ts_tick.x, y/2+ay), exploits.get_charge() == 1 and color_t(0, 255, 0, 255) or color_t(255, 0, 0, 255), 10, true)
            ay = ay + 10.5
        else
            if isAP[2]:get() then
                render.text(pixel, "AUTO PEEK", vec2_t(x/2, y/2+ay), color_t(79, 203, 255, 255), 10, true)
                ay = ay + 10.5
            end
            if isDT[2]:get() then
            if exploits.get_charge() >= 1 then
                render.text(pixel, "DOUBLETAP", vec2_t(x/2, y/2+ay), color_t(0, 255, 0, 255), 10, true)
                ay = ay + 10.5
            end
            if exploits.get_charge() < 1 then
                render.text(pixel, "DOUBLETAP", vec2_t(x/2, y/2+ay), color_t(255, 0, 0, 255), 10, true)
                ay = ay + 10.5
            end
        end
        end
        if getweapon() == "ssg08" then
            if min_damage_s[2]:get() then
                render.text(pixel, "MIN. DMG: "..tostring(amount_scout:get()), vec2_t(x/2, y/2+ay), color_t(79, 203, 255, 255), 10, true)
                ay = ay + 10.5
            end
        elseif getweapon() == "deagle" then
            if min_damage_d[2]:get() then
                render.text(pixel, "MIN. DMG: "..tostring(amount_deagle:get()), vec2_t(x/2, y/2+ay), color_t(79, 203, 255, 255), 10, true)
                ay = ay + 10.5
            end
        elseif getweapon() == "revolver" then
            if min_damage_r[2]:get() then
                render.text(pixel, "MIN. DMG: "..tostring(amount_revolver:get()), vec2_t(x/2, y/2+ay), color_t(79, 203, 255, 255), 10, true)
                ay = ay + 10.5
            end
        elseif getweapon() == "awp" then
            if min_damage_awp[2]:get() then
                render.text(pixel, "MIN. DMG: "..tostring(amount_awp:get()), vec2_t(x/2, y/2+ay), color_t(79, 203, 255, 255), 10, true)
                ay = ay + 10.5
            end
        elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
            if min_damage_a[2]:get() then
                render.text(pixel, "MIN. DMG: "..tostring(amount_auto:get()), vec2_t(x/2, y/2+ay), color_t(79, 203, 255, 255), 10, true)
                ay = ay + 10.5
            end
        elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
            if min_damage_p[2]:get() then
                render.text(pixel, "MIN. DMG: "..tostring(amount_pistol:get()), vec2_t(x/2, y/2+ay), color_t(79, 203, 255, 255), 10, true)
                ay = ay + 10.5
            end
        end

        local ax = 0
        if isHS[2]:get() then
            render.text(pixel, "ONSHOT", vec2_t(x/2, y/2+ay), color_t(79, 203, 255, 255), 10, true)
            ay = ay + 10.5
        end

        render.text(pixel, "BAIM", vec2_t(x/2, y/2+ay), isBA[2]:get() == 2 and color_t(255, 255, 255, 255) or color_t(255, 255, 255, 128), 10, true)
        ax = ax + render.get_text_size(pixel, "BAIM ").x

        render.text(pixel, "FS", vec2_t(x/2+ax, y/2+ay), isAA:get() == 5 and color_t(255, 255, 255, 255) or color_t(255, 255, 255, 128), 10, true)
    end
end
end

------------------------------------------------------------------------------

local function on_paint( )

    indicators()

    if menu.is_open() == false then --lol
        return
    end

    for i = 1, #conditions_names do
        local main_arg = references.lua.active_tab:get( ) == i

        for n = 1, 15 do
            condition_elements[ i ][ n ]:set_visible( main_arg )
        end

        condition_elements[ i ][ 6 ]:set_visible( main_arg and condition_elements[ i ][ 5 ]:get( ) == 2 )
        condition_elements[ i ][ 7 ]:set_visible( main_arg and ( condition_elements[ i ][ 5 ]:get( ) == 3 or condition_elements[ i ][ 5 ]:get( ) == 4 ) )
        condition_elements[ i ][ 12 ]:set_visible( main_arg and condition_elements[ i ][ 11 ]:get( ) )
        condition_elements[ i ][ 13 ]:set_visible( main_arg and condition_elements[ i ][ 11 ]:get( ) )
        condition_elements[ i ][ 15 ]:set_visible( main_arg and condition_elements[ i ][ 14 ]:get( ) > 0 )
    end

end

callbacks.add( e_callbacks.ANTIAIM, on_antiaim)
callbacks.add( e_callbacks.PAINT, on_paint )