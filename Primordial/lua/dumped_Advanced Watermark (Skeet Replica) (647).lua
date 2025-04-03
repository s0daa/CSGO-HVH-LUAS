local font=render.create_font("Verdana.ttf", 14,400,e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local api = require("primordial/Extended API.493")

local function on_paint()
    if engine.is_in_game()==false then return end
    local h, m, s = client.get_local_time()
    local timeW = string.format("%02d:%02d:%02d", h, m, s)
    local st, mi, se = api:cs_session_time()
    local playtime = "Playtime: "..string.format("%02d:%02d:%02d", st, mi, se)
    local MapN = engine.get_level_name_short()
    local screen_size = render.get_screen_size( )
    local accent_color_text, accent_color_color = unpack(menu.find("misc", "main", "config", "accent color")) -- accent_color_color()
    local cheatN1 = "Prim"
    local cheatN2 = "ordial.dev"
    local fps = math.floor(1 / globals.frame_time()).." fps"
    local ping = math.floor(1000 * engine.get_latency(e_latency_flows.OUTGOING) + engine.get_latency(e_latency_flows.INCOMING))
    local spacer = " | "
    local primsize = render.get_text_size(font, cheatN1)
    local mordialsize = render.get_text_size(font, cheatN2)
    local local_player = entity_list.get_local_player()
    local local_name = local_player:get_name()
    local hi, lo = api:get_velocity(local_player)
    local velocity = "Speed: "..string.format("%0d", hi, lo)

    local steamID3, steamID64 = local_player:get_steamids()


    local player_index = entity_list.get_local_player():get_index()
    local kills = player_resource.get_prop("m_iKills", player_index)
    local deaths = player_resource.get_prop("m_iDeaths", player_index)
    local assists = player_resource.get_prop("m_iAssists", player_index)
    local total = player_resource.get_prop("m_iTotalCashSpent", player_index)
    local round = player_resource.get_prop("m_iCashSpentThisRound", player_index)
    local earned = player_resource.get_prop("m_iMatchStats_CashEarned_Total", player_index)
    local crosshair = player_resource.get_prop("m_szCrosshairCodes", player_index)

    local tickrate = client.get_tickrate()
    local tabIn_Out = engine.is_app_active()
    local status = ""
    if tabIn_Out==true then
        status = "Tabbed in"
    elseif tabIn_Out==false then
        status = "Tabbed out"
    else
        status = "Error"
    end
    local HP = ""
    local weapon = ""
    if engine.is_in_game()==true then
        if engine.is_connected==false then
            HP = "Not Ingame"
        elseif local_player:get_prop("m_iHealth") >0 then
            HP = "Health: "..local_player:get_prop("m_iHealth")
            weapon = "Weapon: "..local_player:get_active_weapon():get_name()
        else
            HP = "Dead"
            weapon = "None"
        end
    end

    local shoot = ""
    if client.can_fire()==true then
        shoot = "Can shoot"
    else
        shoot = "Can't shoot"
    end

    local text= cheatN1..cheatN2..spacer..user.name..spacer..local_name..spacer..fps..spacer..HP..spacer..weapon..spacer..shoot..spacer..velocity..spacer.."Kills: "..kills.." / Deaths: "..deaths.." / Assists: "..assists..spacer.."Cash: Spend This round($"..round..") Total($"..total..") / Earned($"..earned..")"..spacer.."Crosshair: "..crosshair..spacer.."SteamID64: "..steamID64..spacer..status..spacer..playtime..spacer..MapN..spacer..tickrate.." tick"..spacer..ping.." ms".."00:00:00"

    local player=entity_list.get_local_player
    if player==nil and engine.is_in_game()==false  then return end
    if engine.is_in_game()==true then
    local text_size=render.get_text_size(font, text)
    --outer blackbox
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 47, 11 ), vec2_t( text_size.x + 38, text_size.y + 24 ), color_t(18, 18, 18))
    --outer outline
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 46, 12 ), vec2_t( text_size.x + 36, text_size.y + 22 ), color_t(66, 64, 62))
    --outerbox 
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 43, 14 ), vec2_t( text_size.x + 30, text_size.y + 17 ), color_t(44, 44, 44))
    --inner outline
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 39, 18 ), vec2_t( text_size.x + 22, text_size.y + 9 ), color_t(66, 64, 62))
    --blackbox
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 37, 20 ), vec2_t( text_size.x + 18, text_size.y + 5 ), color_t(18, 18, 18))
    --rgb line
    --render.line_multicolor(x-112,14, x-textx-25, 15, render.color("#9329cc"), render.color("#2986cc"))
    --render.line_multicolor(x-15,14, x-textx-1 * -85, 15, render.color("#aacc29"), render.color("#9329cc"))

    render.text(font, cheatN1, vec2_t( screen_size.x - 31  - text_size.x, 23 ), color_t(255,255, 255, 255))
    render.text(font, cheatN2, vec2_t( screen_size.x - 31  - text_size.x + primsize.x , 23 ), accent_color_color())
    render.text(font, spacer..user.name..spacer..local_name..spacer..fps..spacer..HP..spacer..weapon..spacer..shoot..spacer..velocity..spacer.."Kills: "..kills.." / Deaths: "..deaths.." / Assists: "..assists..spacer.."Cash: Spend This round($"..round..") Total($"..total..") / Earned($"..earned..")"..spacer.."Crosshair: "..crosshair..spacer.."SteamID64: "..steamID64..spacer..status..spacer..playtime..spacer..MapN..spacer..tickrate.." tick"..spacer..ping.." ms"..spacer..timeW, vec2_t( screen_size.x - 31  - text_size.x + primsize.x + mordialsize.x, 23 ), color_t(255,255, 255, 255))
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)