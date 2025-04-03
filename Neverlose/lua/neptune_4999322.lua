_DEBUG = true
local enc = require("neverlose/crc32")
local b_render = require("neverlose/b_renderer")

-- *Relacionado ao Cheat*
local cheat = {

    -- *Referencias*
    ref = {

        doubletap = ui.find("aimbot", "ragebot", "main", "double tap"), 
        hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
        fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck") ,
        delayshot = ui.find("Aimbot", "Ragebot", "Selection", "Global", "Min. Damage", "Delay Shot"),
        pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
        offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
        yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
        modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
        moffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
        limit1 = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
        limit2 = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
        freestand = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
        antistab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
        bodyyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
        roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
        rollval = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll"),
        airstrafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"),
        legmov = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
        slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
        lagoptions = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
        fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
        asoptions = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Stop", "Options"),
        asdtoptions = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Stop", "Double Tap")

    } 

}

-- *Utilidades*
local utils = {

    -- *Frases da killsay*
    killsay_phrases = {
        "uno",
        "go buy FuriousYaw",
        "owned by FuriousYaw", 
        "iq?"

    },

    -- *Animação*
    animation = { 
        ["lerp"] = nil,
        ["new"]  = nil,
        ["data"]     = {  }
    },

    -- *Fontes*
    fonts = {
 
        ["small_pixel"] = render.load_font("Smallest Pixel-7", 10, "o"),

    },

    -- *Gradiente*
    gradient = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
    
        local output = ''
        local len = #text-1
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len

        for i=1, len+1 do
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end
    
        
        return output
    
    end,

    -- *Grupos (Tabs)*
    groups = {

        main    = ui.create("Info", "More Info"),
        ragebot = ui.create("Anti-Aim", "RageBot-Improvements"),
        antiaim = ui.create("Anti-Aim", "Anti-Aim"),
        visuals = ui.create("Visuals", "Indi    cators"),
        other   = ui.create("Other", "Other")
    },

    -- *Callbacks (Usados para executar o codigo)*
    callbacks = { 

        draw = function(to_register)

            if to_register == nil then
                if _DEBUG == true then
                    print("Forgot to type-in function name when calling the callback!")

                    return

                else
                    common.add_notify("ERROR", "Check console for more info!")
                    return print_raw("Please Send the following code \afa7373" .. enc.crc32("draw_error") .. "\aFFFFFF in this dm\afa7373 $omeone#4103")

                end
            
            end

            events.render:set(to_register)

        end,

        aim_ack = function(to_register)

            if to_register == nil then

                if _DEBUG == true then
                    print("Forgot to type-in function name when calling the callback!")

                    return

                else
                    common.add_notify("ERROR", "Check console for more info!")
                    return print_raw("Please Send the following code \afa7373" .. enc.crc32("aim_ack_error") .. "\aFFFFFF in this dm\afa7373 $omeone#4103")

                end
            
            end

            events.aim_ack:set(function(e) to_register(e) end)

        end,

        createmove = function(to_register)


            if to_register == nil then

                if _DEBUG == true then
                    print("Forgot to type-in function name when calling the callback!")

                    return

                else
                    common.add_notify("ERROR", "Check console for more info!")
                    return print_raw("Please Send the following code \afa7373" .. enc.crc32("createmove_error") .. "\aFFFFFF in this dm\afa7373 $omeone#4103")

                end
            
            end

            events.createmove:set(to_register)

        end,

        player_death = function(to_register)

            if to_register == nil then

                if _DEBUG == true then
                    print("Forgot to type-in function name when calling the callback!")

                    return

                else
                    common.add_notify("ERROR", "Check console for more info!")
                    return print_raw("Please Send the following code \afa7373" .. enc.crc32("player_death_error") .. "\aFFFFFF in this dm\afa7373 $omeone#4103")

                end
            
            end

            events.player_death:set(function(e) to_register(e) end)

        end

    },

    console_exec = function(to_execute)

        utils.console_exec(to_execute)

    end

}


-- *Sla lol*
local text_color = utils.gradient(150, 170, 255, 255, 150, 170, 255, 100, "[+] ")

-- *Menu da lua*
local menu = {

    main    = { ["button_discord"]   = nil },
    ragebot = { ["switch_rage"]      = nil, ["switch_resolver"]   = nil, ["switch_jumpscout"] = nil, ["switch_accuracy"] = nil, ["combo_accuracy"] = nil, ["switch_idealtick"] = nil },
    antiaim = { ["switch_aa"]        = nil, ["combo_presets"]     = nil, builder              = { } },
    visuals = { ["switch_watermark"] = nil, ["switch_indicators"] = nil, ["cpicker_menu"]     = nil },
    other   = { ["switch_leg_break"] = nil, ["switch_killsay"]    = nil, ["switch_antistab"]  = nil, ["switch_logs"]     = nil },

}   

utils.animation["lerp"] = function(start, end_pos, time)

    if type(start) == 'userdata' then

        local color_data = {0, 0, 0, 0}

        for i, color_key in ipairs({'r', 'g', 'b', 'a'}) do
            color_data[i] = utils.animation["lerp"](start[color_key], end_pos[color_key], time)
        end

        return color(unpack(color_data))
    
	end

    return (end_pos - start) * (globals.frametime * time * 175) + start

end

utils.animation["new"] = function(name, value, time)

    if utils.animation["data"][name] == nil then
        
		utils.animation["data"][name] = value
    
	end

    utils.animation["data"][name] = utils.animation["lerp"](utils.animation["data"][name], value, time)

    return utils.animation["data"][name]

end

-- *Sidebar da lua*
ui.sidebar(utils.gradient(240, 140, 25, 255, 255, 180, 25, 255,   'Furious.yaw'), 'shield-alt') 

-- ! Se A fonte nao estiver baixada

if not files.read("nl/FuriousYaw/font.ttf") then

    -- *Cria um botao chamado "Download Font" no grupo "main" que ao clicar baixa uma fonte no diretório "nl/wraith/"*
    utils.groups.main:button("Download Font", function()
    
       files.create_folder("nl/FuriousYaw")

       files.write("nl/FuriousYaw/font.ttf", network.get("https://cdn-104.anonfiles.com/56A7C08ey0/ea9db6eb-1663531785/font.ttf"))
    end)
    
    -- *Cria um text no grupo "main"*
    utils.groups.main:label("1. Click on the button to Download the font\n2. Download the in the folder 'nl/FuriousYaw'\n3. Reload the script and Enjoy!")

    return

end


-- *main*

menu.main["button_discord"] = utils.groups.main:button("Discord Server where the lua was leaked", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks")end)

menu.main["button_cfg"] = utils.groups.main:button("Best leaks", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leak")end)

-- *Ragebot*

menu.ragebot["switch_rage"]      = utils.groups.ragebot:switch(text_color .. "\aFFFFFFFFEnable Ragebot",          false)
menu.ragebot["switch_resolver"]  = utils.groups.ragebot:switch(text_color .. "\aFFFFFFFFEnable Calculate Angle", false)
menu.ragebot["switch_jumpscout"] = utils.groups.ragebot:switch(text_color .. "\aFFFFFFFFEnable JumpScout Fix",  false)
menu.ragebot["switch_accuracy"]  = utils.groups.ragebot:switch(text_color .. "\aFFFFFFFFEnable Accuracy Fix",  false)
menu.ragebot["combo_accuracy"]   = menu.ragebot["switch_accuracy"]:create():combo("Accuracy Mode", "Safest", "Safe", "Unsafe")
menu.ragebot["switch_idealtick"] = utils.groups.ragebot:switch(text_color .. "\aFFFFFFFFEnable Ideal Tick",     false)

-- *AntiAim*

menu.antiaim["switch_aa"]                             = utils.groups.antiaim:switch(text_color .. "\aFFFFFFFFEnable AntiAim", false)
menu.antiaim["combo_presets"]                         = utils.groups.antiaim:combo (text_color .. "\aFFFFFFFFPresets",   "Jitter High", "Jitter Low", "Low Delta", "Custom")
menu.antiaim.builder["combo_state"]                   = utils.groups.antiaim:combo (text_color .. "\aFFFFFFFFState", "Standing", "Walking", "Running", "Air")
menu.antiaim.builder["combo_jitter_mode#standing"]    = utils.groups.antiaim:combo (text_color .. "\aFFFFFFFFJitter Mode", "Disabled", "Center")
menu.antiaim.builder["slider_yaw_offset#standing"]    = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFYaw Offset", -180, 180, 0)
menu.antiaim.builder["slider_jitter_offset#standing"] = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFJitter Offset", -180, 180, 0)
menu.antiaim.builder["slider_left_limit#standing"]    = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFLeft Limit", 0, 60, 60)
menu.antiaim.builder["slider_right_limit#standing"]   = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFRight Limit", 0, 60, 60)

menu.antiaim.builder["combo_jitter_mode#walking"]     = utils.groups.antiaim:combo (text_color .. "\aFFFFFFFFJitter Mode", "Disabled", "Center")
menu.antiaim.builder["slider_yaw_offset#walking"]     = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFYaw Offset", -180, 180, 0)
menu.antiaim.builder["slider_jitter_offset#walking"]  = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFJitter Offset", -180, 180, 0)
menu.antiaim.builder["slider_left_limit#walking"]     = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFLeft Limit", 0, 60, 60)
menu.antiaim.builder["slider_right_limit#walking"]    = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFRight Limit", 0, 60, 60)

menu.antiaim.builder["combo_jitter_mode#running"]     = utils.groups.antiaim:combo (text_color .. "\aFFFFFFFFJitter Mode", "Disabled", "Center")
menu.antiaim.builder["slider_yaw_offset#running"]     = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFYaw Offset", -180, 180, 0)
menu.antiaim.builder["slider_jitter_offset#running"]  = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFJitter Offset", -180, 180, 0)
menu.antiaim.builder["slider_left_limit#running"]     = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFLeft Limit", 0, 60, 60)
menu.antiaim.builder["slider_right_limit#running"]    = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFRight Limit", 0, 60, 60)

menu.antiaim.builder["combo_jitter_mode#air"]         = utils.groups.antiaim:combo (text_color .. "\aFFFFFFFFJitter Mode", "Disabled", "Center")
menu.antiaim.builder["slider_yaw_offset#air"]         = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFYaw Offset", -180, 180, 0)
menu.antiaim.builder["slider_jitter_offset#air"]      = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFJitter Offset", -180, 180, 0)
menu.antiaim.builder["slider_left_limit#air"]         = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFLeft Limit", 0, 60, 60)
menu.antiaim.builder["slider_right_limit#air"]        = utils.groups.antiaim:slider(text_color .. "\aFFFFFFFFRight Limit", 0, 60, 60)

-- *Visuals*
 
menu.visuals["switch_watermark"]  = utils.groups.visuals:switch      (text_color .. "\aFFFFFFFFEnable Watermark",                        false)
menu.visuals["switch_indicators"] = utils.groups.visuals:switch      (text_color .. "\aFFFFFFFFEnable Indicators",                      false)
menu.visuals["cpicker_menu"]      = utils.groups.visuals:color_picker(text_color .. "\aFFFFFFFFIndicators Color", color(150, 170, 255, 255)) 

-- *Misc*

menu.other["switch_leg_break"] = utils.groups.other:switch(text_color .. "\aFFFFFFFFEnable Leg Breaker",     false)
menu.other["switch_antistab"]  = utils.groups.other:switch(text_color .. "\aFFFFFFFFEnable Anti Backstab", false)
menu.other["switch_killsay"]   = utils.groups.other:switch(text_color .. "\aFFFFFFFFEnable Killsay",   false)
menu.other["switch_logs"]      = utils.groups.other:switch(text_color .. "\aFFFFFFFFEnable Logs",        false)

-- *Funçoes*

hitgroups = { [0] = 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', 'generic', 'gear' }
					
logs = function(e)

    local target, damage, wanted_damage, wanted_hitgroup, hc, state, bt
          = entity.get(e.target), e.damage, e.wanted_damage, hitgroups[e.wanted_hitgroup], e.hitchance, e.state, e.backtrack 
	
	if not target then return end

	local hp = target["m_iHealth"]
	local hitgroup = hitgroups[e.hitgroup]

	if state == "spread"                         then state = "\aFEEA7Dspread"end
    if state == "prediction error"               then state = "\aFEEA7Dpred. error" end
    if state == "correction"                     then state = "\aFF5959resolver" end
    if state == "jitter correction"              then state = "\aFF5959jitter correction \aa2a0ff(angle: " .. string.format("%.3f", e.spread * 12) .. ")" end
    if state == "lagcomp failure"                then state = "\aFF5959backtrack" end
	if state == "unregistered shot"              then state = "\a999999unregistered shot" end

	if state ~= nil then print_raw(("\aABDAFF[FuriousYaw] \aD5D5D5Missed shot at \aABDAFFs\aFFFFFF's \aABDAFFs \aFFFFFFdue to "..state..'\aFF6464 (hc: '..string.format("%.f", hc)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup)) return end
		
	print_raw(("\aABDAFF[FuriousYaw] \aD5D5D5Registered shot at \aABDAFFs\aFFFFFF's \aABDAFFs \aFFFFFFfor \aFF6464".. damage .." \aFFFFFFdamage\aFF6464 (hp: "..hp..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))

end

jumpscout = function()

    cheat.ref.airstrafe:set( not menu.ragebot["switch_jumpscout"]:get())
	
end

antibackstab = function()

    cheat.ref.antistab:set(menu.other["switch_antistab"]:get())

end

antiaim = function()

    tick = globals.client_tick % 30 > 15

    cheat.ref.pitch:set("Down")
    cheat.ref.yaw:set("Backward")

    for _, menu_items in pairs(menu.antiaim.builder) do

        menu_items:visibility(menu.antiaim["combo_presets"]:get() == "Custom")

    end

    if menu.antiaim["combo_presets"]:get() == "Jitter High" then 

        cheat.ref.modifier:set("Center")
        cheat.ref.moffset:set(tick and -37 or 37)
        cheat.ref.offset:set(tick and -2 or 2)
        cheat.ref.limit1:set(tick and math.random(10, 30) or 60)
        cheat.ref.limit2:set(tick and math.random(10, 30) or 60)

        return

    elseif menu.antiaim["combo_presets"]:get() == "Jitter Low" then 
    
        cheat.ref.modifier:set("Center")
        cheat.ref.moffset:set(tick and -15 or 15)
        cheat.ref.offset:set(tick and -3 or 3)
        cheat.ref.limit1:set(tick and math.random(30, 40) or 60)
        cheat.ref.limit2:set(tick and math.random(30, 40) or 60)

        return

    elseif menu.antiaim["combo_presets"]:get() == "Low Delta" then 

        cheat.ref.modifier:set("Center")
        cheat.ref.moffset:set(tick and -1 or 1)
        cheat.ref.offset:set(tick and -8 or 8)
        cheat.ref.limit1:set(tick and math.random(10, 25) or 30)
        cheat.ref.limit2:set(tick and math.random(10, 25) or 30)

        return

    elseif menu.antiaim["combo_presets"]:get() == "Custom" then

        local standing = { yaw_offset = menu.antiaim.builder["slider_yaw_offset#standing"], jitter_mode = menu.antiaim.builder["combo_jitter_mode#standing"], jitter_offset = menu.antiaim.builder["slider_jitter_offset#standing"], limit1 = menu.antiaim.builder["slider_left_limit#standing"], limit2 = menu.antiaim.builder["slider_right_limit#standing"] }
        local walking  = { yaw_offset = menu.antiaim.builder["slider_yaw_offset#walking"] , jitter_mode = menu.antiaim.builder["combo_jitter_mode#walking"] , jitter_offset = menu.antiaim.builder["slider_jitter_offset#walking"] , limit1 = menu.antiaim.builder["slider_left_limit#walking"] , limit2 = menu.antiaim.builder["slider_right_limit#walking"] }
        local running  = { yaw_offset = menu.antiaim.builder["slider_yaw_offset#running"] , jitter_mode = menu.antiaim.builder["combo_jitter_mode#running"] , jitter_offset = menu.antiaim.builder["slider_jitter_offset#running"] , limit1 = menu.antiaim.builder["slider_left_limit#running"] , limit2 = menu.antiaim.builder["slider_right_limit#running"] }
        local air      = { yaw_offset = menu.antiaim.builder["slider_yaw_offset#air"]     , jitter_mode = menu.antiaim.builder["combo_jitter_mode#air"]     , jitter_offset = menu.antiaim.builder["slider_jitter_offset#air"]     , limit1 = menu.antiaim.builder["slider_left_limit#air"]     , limit2 = menu.antiaim.builder["slider_right_limit#air"]}

        --standing.yaw_offset:visibility(false)
        --standing.jitter_mode:visibility(false)
        --standing.jitter_offset:visibility(false)

        --walking.yaw_offset:visibility(false)
        --walking.jitter_mode:visibility(false)
        --walking.jitter_offset:visibility(false)

        --running.yaw_offset:visibility(false)
        --running.jitter_mode:visibility(false)
        --running.jitter_offset:visibility(false)

        --air.yaw_offset:visibility(false)
        --air.jitter_mode:visibility(false)
        --air.jitter_offset:visibility(false)

        if menu.antiaim["combo_presets"]:get() ~= "Custom" then return end

        if menu.antiaim.builder["combo_state"]:get()     == "Standing"then

            for _, standing in pairs(standing) do standing:visibility(true) end
            for _, walking  in pairs(walking)  do walking:visibility(false) end
            for _, running  in pairs(running)  do running:visibility(false) end
            for _, air      in pairs(air)      do air:visibility(false)     end

        elseif menu.antiaim.builder["combo_state"]:get() == "Walking" then

            for _, standing in pairs(standing) do standing:visibility(false) end   
            for _, walking  in pairs(walking)  do walking:visibility(true)   end
            for _, running  in pairs(running)  do running:visibility(false)  end
            for _, air      in pairs(air)      do air:visibility(false)      end

        elseif menu.antiaim.builder["combo_state"]:get() == "Running" then

            for _, standing in pairs(standing) do standing:visibility(false) end
            for _, walking  in pairs(walking)  do walking:visibility(false)  end
            for _, running  in pairs(running)  do running:visibility(true)   end
            for _, air      in pairs(air)      do air:visibility(false)      end

        elseif menu.antiaim.builder["combo_state"]:get() == "Air" then
 
            for _, standing in pairs(standing) do standing:visibility(false) end   
            for _, walking  in pairs(walking)  do walking:visibility(false)  end
            for _, running  in pairs(running)  do running:visibility(false)  end
            for _, air      in pairs(air)      do air:visibility(true)       end

        end


        

        --for _, state in pairs(menu.antiaim.builder) do

        --    state:visibility(menu.antiaim["combo_presets"]:get() == "Custom")
    
        --end

	    local speed = entity.get_local_player().m_vecVelocity:length()

        if speed < 2 then

            cheat.ref.offset:set  (menu.antiaim.builder["slider_yaw_offset#standing"]   :get())
            cheat.ref.modifier:set(menu.antiaim.builder["combo_jitter_mode#standing"]   :get())
            cheat.ref.moffset:set (menu.antiaim.builder["slider_jitter_offset#standing"]:get())
            cheat.ref.limit1:set  (menu.antiaim.builder["slider_left_limit#standing"]   :get())
            cheat.ref.limit2:set  (menu.antiaim.builder["slider_right_limit#standing"]  :get())

        end

        if cheat.ref.slowwalk:get() then
			
            cheat.ref.offset:set  (menu.antiaim.builder["slider_yaw_offset#walking"]   :get())
            cheat.ref.modifier:set(menu.antiaim.builder["combo_jitter_mode#walking"]   :get())
            cheat.ref.moffset:set (menu.antiaim.builder["slider_jitter_offset#walking"]:get())
            cheat.ref.limit1:set  (menu.antiaim.builder["slider_left_limit#walking"]   :get())
            cheat.ref.limit2:set  (menu.antiaim.builder["slider_right_limit#walking"]  :get())
            
        end

        if not cheat.ref.slowwalk:get() and speed > 2 then
			
            cheat.ref.offset:set  (menu.antiaim.builder["slider_yaw_offset#running"]   :get())
            cheat.ref.modifier:set(menu.antiaim.builder["combo_jitter_mode#running"]   :get())
            cheat.ref.moffset:set (menu.antiaim.builder["slider_jitter_offset#running"]:get())
            cheat.ref.limit1:set  (menu.antiaim.builder["slider_left_limit#running"]   :get())
            cheat.ref.limit2:set  (menu.antiaim.builder["slider_right_limit#running"]  :get())
                    
        end

        if bit.band(entity.get_local_player().m_fFlags, 1) == 0 then
			
            cheat.ref.offset:set  (menu.antiaim.builder["slider_yaw_offset#air"]   :get())
            cheat.ref.modifier:set(menu.antiaim.builder["combo_jitter_mode#air"]   :get())
            cheat.ref.moffset:set (menu.antiaim.builder["slider_jitter_offset#air"]:get())
            cheat.ref.limit1:set  (menu.antiaim.builder["slider_left_limit#air"]   :get())
            cheat.ref.limit2:set  (menu.antiaim.builder["slider_right_limit#air"]  :get())
                
        end

    end


end

watermark = function()

    if not menu.visuals["switch_watermark"]:get() then return end

	local screen_x, screen_y = render.screen_size().x, render.screen_size().y
	local watermark_text = 'Furious.yaw | ' .. common.get_username() .. ' | ' .. common.get_date("%m/%d")
	local text_size = render.measure_text(utils.fonts["small_pixel"], "",  watermark_text)

	local val = globals.realtime % 4 > 2
    local val2 = globals.realtime % 4 > 2

    local pos_x = utils.animation["new"]('teste pos', val2 and text_size.x + 10 or 30, 0.015)

    --local color = menu.visuals["cpicker_menu"].r():get()

    local col = menu.visuals["cpicker_menu"]:get()

    b_render.rectangle(screen_x - text_size.x - 10, 10, 125, 1.5, 100, 100, 100, 255)
    b_render.rectangle(screen_x - pos_x, 10, 20, 1.5, col.r, col.g, col.b, 255)

    render.blur(vector(screen_x - text_size.x - 10, text_size.y), vector(screen_x - text_size.x + 130, text_size.y + text_size.y), 2, 255)
	render.text(utils.fonts["small_pixel"], vector(screen_x - text_size.x - 10, 10), color(255, 255, 255, 255), "nil", watermark_text)

end

indicator = function()

    if not menu.visuals["switch_indicators"]:get() then return end
    local exploit_charge = rage.exploit:get() < 1
    local itick = menu.ragebot["switch_idealtick"]:get()

    local col  = menu.visuals["cpicker_menu"]:get()
    local font = utils.fonts["small_pixel"]

    local dt        = not cheat.ref.doubletap:get()
	local hs        = not cheat.ref.hideshots:get() 
    local dt_col    = utils.animation["new"]('doubletap color', dt and color(155,155,155, 200) or col , 0.07)
	local hs_col    = utils.animation["new"]('hideshots color', hs and color(155,155,155, 200) or col , 0.07)
    local itick_col = utils.animation["new"]('ideal tick color', exploit_charge and color(155,155,155, 200) or col , 0.07)
    local bar_color = utils.animation["new"]('test color', exploit_charge and color(155,155,155, 200) or col, 0.07)
    
    local screen_x, screen_y = render.screen_size().x, render.screen_size().y
	local text_size = render.measure_text(font, "",  'FuriousyYaw')
	local x = utils.animation["new"]('test x', val and -20 or 26.5, 0.07)

	render.text(font, vector(screen_x / 2 - text_size.x / 2, screen_y / 2 + 18), color(255, 255, 255, 255), "nil", 'furious.')
    render.text(font, vector(screen_x / 2 + text_size.x / 2 - 18, screen_y / 2 + 18), bar_color, "nil", 'yaw')
    render.text(font, vector(screen_x / 2 - render.measure_text(font, "", 'doubletap').x / 2 - 3, screen_y / 2 + render.measure_text(font, "",  'doubletap').y + 14.5), dt_col, "nil", 'doubletap')
	render.text(font, vector(screen_x / 2 - render.measure_text(font, "", 'hideshots').x / 2 - 3, screen_y / 2 + render.measure_text(font, "",  'hideshots').y + 22), hs_col, "nil", 'hideshots')
    
    if itick and hs then render.text(font, vector(screen_x / 2 - render.measure_text(font, "", 'ideal tick').x / 2 - 1, screen_y / 2 + render.measure_text(font, "", 'ideal tick').y + 30.5), itick_col, "nil", 'ideal tick') end

end

better_accuracy = function()

    if not menu.ragebot["switch_accuracy"]:get() then return end

    if menu.ragebot["combo_accuracy"]:get()     == "Unsafe"  then
        cheat.ref.delayshot:set(false)
        cheat.ref.asoptions:set("Early", "Move Btw. Shots")
        cheat.ref.asdtoptions:set("Early", "Move Btw. Shots")
    elseif menu.ragebot["combo_accuracy"]:get() == "Safe"    then
        cheat.ref.delayshot:set(true)
        cheat.ref.asoptions:set("Early", "Full Stop", "Move Btw. Shots")
        cheat.ref.asdtoptions:set("Early", "Move Btw. Shots")
    elseif menu.ragebot["combo_accuracy"]:get() == "Safest" then
        cheat.ref.delayshot:set(true)
        cheat.ref.fakelag:set(1)
        cheat.ref.asoptions:set("Full Stop", "Move Btw. Shots")
        cheat.ref.asdtoptions:set("Move Btw. Shots", "Full Stop")
        
    end

end

idealtick = function()

	if menu.ragebot["switch_idealtick"]:get() then

        cheat.ref.lagoptions:set("Disabled")

    else

            cheat.ref.lagoptions:set("On Peek")
    
    end

end

legbreaker = function()

	if not globals.is_in_game then return end
	
	local tick1 = globals.client_tick % 20 > 10

	if menu.other["switch_leg_break"]:get() then 

		cheat.ref.legmov:set(tick1 and "Sliding" or "Walking")

	end
		

end 

killsay = function(e)

	if not globals.is_in_game then return end
	
	local lPlayer = entity.get_local_player()
	local attacker = entity.get(e.attacker, true)
	
    local text = tostring(utils.killsay_phrases[math.random(#utils.killsay_phrases)])

	if lPlayer == attacker and menu.other["switch_killsay"]:get() then

		utils.console_exec("say " .. text) 

	end

end

-- *Callbacks*

utils.callbacks.draw(function()

    if not globals.is_in_game then return end

    watermark()
    indicator()

end) 

utils.callbacks.createmove(function() 
    
    if menu.antiaim["switch_aa"]:get() then cheat.ref.bodyyaw:set(true) antiaim() end

    if menu.ragebot["switch_rage"]:get() then jumpscout() better_accuracy() idealtick() end

    antibackstab()
    legbreaker()

end)

utils.callbacks.aim_ack(function(e) 

    if not menu.other["switch_logs"]:get() then return end
    logs(e)

end)

utils.callbacks.player_death(function(e)

    killsay(e)

end)