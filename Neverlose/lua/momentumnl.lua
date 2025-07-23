-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

_DEBUG = true
setup = function()
    local gradient = require("neverlose/gradient") -- gradient library only used for the animated sidebar
    local file = require("neverlose/file")
    local json = require("neverlose/better_json")
    local gradient = require("neverlose/gradient")
    local main_logo = network.post("https://cdn.discordapp.com/attachments/1019481031906177044/1089391684732866641/untitled.png")
    if not pcall(ffi.sizeof, "struct vec3_t") then ffi.cdef[[struct vec3_t{ float x, y, z; };]] end
    local vec3_t = ffi.typeof("struct vec3_t")
    local main_logo_texture = render.load_image(main_logo, vector(300, 300))
    -- store static vars(only need to be declared once =))
    local script_visuals = {}
    local visuals = {}
    local definitions = {
        screen_size = render.screen_size(),
        shared_aa = {
            is_scoped,
            round_end,
            flags = {
                FL_ONGROUND	        = bit.lshift(1, 0),
                FL_DUCKING	        = bit.lshift(1, 1),
            }
        }
    }

    visuals.antiaim_states = {

    }
    
    local colors = {
		blue = "\aA9B7FFFF",
        blue_nonhex = color(169, 183, 255),
		bright = "\aE3E9FFFF",
		grey = "\aFFFFFF8D",
		bright_red = "\aFF9A9AFF",
        bright_red_non_hex = color(255, 154, 154),
        link_active = ui.get_style("Link Active")
	}

    colors.hashes = {}
    colors.gradient_text = function(text, magic_value, clrs)
    
        local clrs_hash = ""
    
        for k, v in ipairs(clrs) do
            clrs_hash = clrs_hash .. v:to_hex()
        end
    
        local hash = text .. magic_value .. clrs_hash
    
        if colors.hashes[hash] == nil then
            colors.hashes[hash] = gradient.text_animate(text, magic_value, clrs)
        end
    
        return colors.hashes[hash]
    
    end

    definitions.colored_text = function(...)
        local data = {...}
        local str = ""
        for i = 1, #data do
    
            if data[i] == nil or data[i][1] == nil then
                goto skip
            end
    
            if data[i][2] == nil then
                str = str .. data[i][1]
            else
                str = str .. ("\a%s%s\aDEFAULT"):format(data[i][2]:to_hex(), data[i][1])
            end
    
            ::skip::
        end
    
        return str
    end

    math.color_lerp = function(start, end_pos, time)
        local frametime = globals.frametime * 100
        time = time * frametime
        return start:lerp(end_pos, time)
    end
    
    math.lerp = function(start, end_pos, time)

        if start == end_pos then
            return end_pos
        end
    
        local frametime = globals.frametime * 170
        time = time * frametime
    
        local val = start + (end_pos - start) * time
    
        if(math.abs(val - end_pos) < 0.01) then
            return end_pos
        end
    
        return val
    end

    local animations = {
        base_speed = 0.07,
        _list = {}
    }

    animations.new = function(name, new_value, speed, init)
        speed = speed or animations.base_speed
        local is_color = type(new_value) ~= "number"
    
        if animations._list[name] == nil then
            animations._list[name] = (init and init) or (is_color and colors.white or 0)
        end
    
        local interp_func
    
        if is_color then
            interp_func = math.color_lerp
        else
            interp_func = math.lerp
        end
    
        animations._list[name] = interp_func(animations._list[name], new_value, speed)
        return animations._list[name]
    end
    
    -- tohle je pasted s testarossy ale je to dobry ==))
    local safe = {
        uintptr_t = ffi.typeof("uintptr_t**"),
        this_call = function(call_function, parameters)
            return function(...)
                return call_function(parameters, ...)
            end
        end,

        safecall = function(name, report, f)
            return function(...)
                local s, ret = pcall(f, ...)
        
                if not s then
                    local retmessage = name .. " : " .. ret:gsub(".{6}", "")
        
                    if report then
                        error(retmessage) --client.log_error(retmessage) -- nevim
                    end
        
                    return false, retmessage
                else
                    return ret, s
                end
            end
        end,

        -- vsechny panorama related funcs tady v
        panorama_handler = {
            -- pak pridam jeste error sound
            main = panorama.loadstring([[
                // https://github.com/TrevenT/CSGOPanorama
                var on_toggle = function() {
                    $.DispatchEventAsync(0.0, "PlaySoundEffect", "sticker_applySticker", "MOUSE")        
                }
        
                var on_shutdown = function() {
                    $.DispatchEventAsync(0.0, "PlaySoundEffect", "PanoramaUI.Lobby.Left", "MOUSE")        
                }
        
                return {
                    play_sound: on_toggle,
                    left_sound: on_shutdown
                }
            ]], "CSGOMainMenu")()
        }
    }

    local menu_items = {items = {}; visibler = {}}
    menu_items.run_update = function()
        for name, m_table in pairs(menu_items.visibler) do
            m_table.ref:visibility(m_table.condition())
        end
    end

    menu_items.new = function(name, item, conditions, sound) 
        if menu_items.items[name] ~= nil then error("item already exists")  -- pak az budou ten error handler hotovej tak to jebnu vsude
            return 
        end 
        menu_items.items[name] = item 
        if type(conditions) == "function" then 
            menu_items.visibler[name] = { ref = item, condition = conditions } 
        end 
        item:set_callback(function()
            if type(menu_items.items[name]:get()) == "userdata" then return end -- colorpicker lol
            menu_items.run_update()
            -- bypass ez
            if is_loadig then return end
            if sound then
                safe.panorama_handler.main.play_sound()
            end
        end) 
        return item 
    end

    local refs = {
        double_tap = ui.find("Aimbot", "Ragebot", "MAIN", "Double Tap"),
        hide_shots = ui.find("Aimbot", "Ragebot", "MAIN", "Hide Shots"),
        legmovement = ui.find("Aimbot", "Anti Aim", "MISC", "Leg Movement"),
        safe_points = ui.find("Aimbot", "Ragebot", "SAFETY", "Safe Points"),
        body_aim = ui.find("Aimbot", "Ragebot", "SAFETY", "Body Aim"),
        remove_scope = ui.find("Visuals", "World", "MAIN", "Override Zoom", "Scope Overlay"),
        fakeduck = ui.find("Aimbot", "Anti Aim", "MISC", "Fake Duck"),
        thirdperson = ui.find("Visuals", "World", "MAIN", "Force Thirdperson"),
        daim = ui.find("Aimbot", "Ragebot", "MAIN", "Enabled", "Dormant Aimbot"),
        slowwalk = ui.find("Aimbot", "Anti Aim", "MISC", "Slow Walk"),
        pitch = ui.find("Aimbot", "Anti Aim", "ANGLES", "Pitch"),
        fl = ui.find("Aimbot", "Anti Aim", "FAKE LAG", "Limit"),
        auto_peek = ui.find("Aimbot", "Ragebot", "MAIN", "Peek Assist"),
        yaw = ui.find("Aimbot", "Anti Aim", "ANGLES", "Yaw"), --disabled or backward
        yawbase = ui.find("Aimbot", "Anti Aim", "ANGLES", "Yaw", "Base"), --local vies or at target
        yawoffset = ui.find("Aimbot", "Anti Aim", "ANGLES", "Yaw", "Offset"), --setting up yaw angles
        yawmod = ui.find("Aimbot", "Anti Aim", "ANGLES", "Yaw Modifier"), --center, offset etc
        yawmodoffset = ui.find("Aimbot", "Anti Aim", "ANGLES", "Yaw Modifier", "Offset"), --setting up yawmod jitter angle
        desync = ui.find("Aimbot", "Anti Aim", "ANGLES", "Body Yaw"), --setting up desync
        inverter = ui.find("Aimbot", "Anti Aim", "ANGLES", "Body Yaw", "Inverter"), --?
        leftdesync = ui.find("Aimbot", "Anti Aim", "ANGLES", "Body Yaw", "Left Limit"),
        rightdesync = ui.find("Aimbot", "Anti Aim", "ANGLES", "Body Yaw", "Right Limit"),
        fakeopt = ui.find("Aimbot", "Anti Aim", "ANGLES", "Body Yaw", "Options"), --avoid overlap, jitter, rand jitter
        desyncfs = ui.find("Aimbot", "Anti Aim", "ANGLES", "Body Yaw", "Freestanding"), --peek fake peek real off
        fs = ui.find("Aimbot", "Anti Aim", "ANGLES", "Freestanding"), --switch of freestanding
        avoid_stab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab")
    }

    local antiaim = {}
    local ragebot = {}
    local menu_elements = {}
    local anitaim_condition = {}
    
    local player_states = {[1] = 'Shared', [2] = 'Standing', [3] = 'Moving', [4] = 'Slowwalk', [5] = 'Crouch', [6] = "Crouch & Move", [7] = "Air", [8] = "Air & Crouch"}

    local variables = {
        hooks = {
            hooked_function = nil
        },
        fonts = {
            verdana_anti_bold = render.load_font('verdana', 25, "ab")
        },
        other = {
            screen_size = render.screen_size(),
            list_val = 0
        }
    }

    local gsub, pairs = string.gsub, pairs
    
    local replacements = {
        ["{white}"] = "\x01",
        ["{darkred}"] = "\x02",
        ["{team}"] = "\x03",
        ["{green}"] = "\x04",
        ["{lightgreen}"] = "\x05",
        ["{lime}"] = "\x06",
        ["{red}"] = "\x07",
        ["{grey}"] = "\x08",
        ["{yellow}"] = "\x09",
        ["{bluegrey}"] = "\x0A",
        ["{blue}"] = "\x0B",
        ["{darkblue}"] = "\x0C",
        ["{purple}"] = "\x0D",
        ["{violet}"] = "\x0E",
        ["{lightred}"] = "\x0F",
        ["{orange}"] = "\x10",
        ["\u{202E}"] = "",
        ["\u{2029}"] = "",
        ["  +"] = function(c)
            return " " .. ("\x18 "):rep(c:len()-1)
        end
    }
    
    local function find_sig(mdlname, pattern, typename, offset, deref_count)
        local raw_match = utils.opcode_scan(mdlname, pattern) or error("signature not found", 2)
        local match = ffi.cast("uintptr_t", raw_match)
    
        if offset ~= nil and offset ~= 0 then
            match = match + offset
        end
    
        if deref_count ~= nil then
            for i = 1, deref_count do
                match = ffi.cast("uintptr_t*", match)[0]
                if match == nil then
                    return error("signature not found", 2)
                end
            end
        end
    
        return ffi.cast(typename, match)
    end
    
    local __thiscall = function(func, this)
        return function(...) return func(this, ...) end
    end
    local interface_ptr = ffi.typeof("void***")
    
    
    vtable_bind = function (class, _type, index)
        local this = ffi.cast("void***", class)
        local ffitype = ffi.typeof(_type)
        return function (...)
            return ffi.cast(ffitype, this[0][index])(this, ...)
        end
    end
    
    
    local vtable_entry = function(instance, i, ct)
        return ffi.cast(ct, ffi.cast(interface_ptr, instance)[0][i])
    end
    
    
    local vtable_thunk = function(i, ct)
        local t = ffi.typeof(ct)
        return function(instance, ...)
            return vtable_entry(instance, i, t)(instance, ...)
        end
    end
    
    local function table_concat_tostring(tbl, sep)
        local result = ""
        for i=1, #tbl do
            result = result .. tostring(tbl[i]) .. (i == #tbl and "" or sep)
        end
        return result
    end
    
    local hud = find_sig("client.dll", "B9 ? ? ? ? 88 46 09", "void*", 1, 1)
    
    local native_FindHudElement = find_sig("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28", "void***(__thiscall*)(void*, const char*)")
    local native_ChatPrintf = vtable_thunk(27, "void(__cdecl*)(void*, int, int, const char*, ...)")
    
    -- thisptr for native_ChatPrintf
    local hud_chat = native_FindHudElement(hud, "CHudChat")
    
    local function print_player(entindex, ...)
        local text = table_concat_tostring(entindex == 0 and {" ", ...} or {...}, "")
    
        for res, rep in pairs(replacements) do
            text = gsub(text, res, rep)
        end
    
        native_ChatPrintf(hud_chat, entindex, 0, text)
    end

    print_chat_retard = function(...)
		return print_player(0, ...)
	end

    -- @sidebar
    local sidebar_name = gradient.text_animate("momentum [dev]", 2, {color(93, 167, 223), color(209, 235, 255)})
    local sidebar_ico = gradient.text_animate("   ", 1.8, {color(93, 167, 223), color(209, 235, 255)})
    menu_elements.update_sidebar = function()
        sidebar_name:animate() -- animate the gradient
        sidebar_ico:animate() -- animate the icon
        ui.sidebar(sidebar_name:get_animated_text(), sidebar_ico:get_animated_text() .. ui.get_icon("face-awesome"))
    end

    local home_group = definitions.colored_text(
        -- group name
        {
            ui.get_icon("house-user"), colors.blue_nonhex
        },
        {
            " Home", color(255, 255, 255)
        }
    )

    local antiaim_group = definitions.colored_text(
        -- group name
        {
            ui.get_icon("shield-slash"), colors.blue_nonhex
        },
        {
            " Anti-Aim", color(255, 255, 255)
        }
    )

    local settings_group = definitions.colored_text(
        -- group name
        {
            ui.get_icon("gamepad"), colors.blue_nonhex
        },
        {
            " Settings", color(255, 255, 255)
        }
    )
    
    local misc_group = definitions.colored_text(
        -- group name
        {
            ui.get_icon("sliders"), colors.blue_nonhex
        },
        {
            " Misc", color(255, 255, 255)
        }
    )
    -- @tabs
    menu_elements.tab_home = ui.create(
        home_group,
        ui.get_icon("house") .. " Main", 1
    )
    
    menu_elements.tab_settings = ui.create(
        antiaim_group,
        ui.get_icon("gears") .. " Settings", 1
    )

    menu_elements.widgets_form_sec = ui.create(
        settings_group, "Suggestions " .. ui.get_icon("discord"), 2
    )

    menu_elements.tab_misc = ui.create(
        misc_group,
        ui.get_icon("rabbit-running") .. " Movement", 1
    )

    -- @mainer
    menu_elements.home_main = ui.create(
        home_group, ui.get_icon("circle-info") .. " Info", 3
    )

    menu_elements.happy_label = menu_elements.home_main:label(
        "Happy to see you, " .. colors.blue .. common.get_username()
    )

    menu_elements.version_label = menu_elements.home_main:label(
        "Current Version: " .. colors.blue .. "1.0 / " .. colors.bright_red .. "debug " .. ui.get_icon("bug")
    )

    -- @menu_elements logo
    menu_elements.home_image = menu_elements.tab_home:texture(
        render.load_image(
            main_logo,
            vector(554 / 2, 639 / 2) -- padding / 2
        ),
        color(128, 128, 240, 255)
    )

    -- @stats
    menu_elements.home_stats = ui.create(
        home_group, 
        ui.get_icon("signal-bars") .. " Statistics", 3
    )

    menu_elements.stats_label_load = menu_elements.home_stats:label(
        colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " Times Loaded:, " .. colors.blue .. "1"
    )

    menu_elements.stats_label_active_users = menu_elements.home_stats:label(
        colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " Active Users:, " .. colors.blue .. "1"
    )

    -- @default setts
    menu_elements.home_default_setts = ui.create(
        home_group,
        ui.get_icon("wrench") .. " Additional", 3
    )


    menu_elements.setts_load = menu_items.new("setts-button", menu_elements.home_default_setts:button(ui.get_icon("bars-progress"), true):tooltip(
        colors.bright_red .. ui.get_icon("angles-right") .. 
        colors.grey .. " By clicking this button, the lua will load the " .. colors.blue .. "developers" ..
        colors.grey .. " configuration."), nil, true
    )

    -- @discord auth
    menu_elements.setts_discord = menu_items.new("discord-button", menu_elements.home_default_setts:button(ui.get_icon("discord"), true):tooltip(
        colors.bright_red .. ui.get_icon("angles-right") .. 
        colors.grey .. " By clicking this button, a" .. colors.blue .. " broswer window " ..
        colors.grey .. "will open with our " .. colors.blue .. "Discord server" .. colors.grey .. " link."), nil, true
    )
    
    menu_elements.auth_key = menu_items.new("verification-button", menu_elements.home_default_setts:button(ui.get_icon("key-skeleton-left-right"), true):tooltip(
        colors.bright_red .. ui.get_icon("angles-right") .. 
        colors.grey .. " By clicking this button, you will be provided with a" .. colors.blue .. " one-time use code\n" ..
        colors.grey .. "\n To redeem this code, read the " ..
        colors.blue .. "\n How To Verify " .. colors.grey .. "form."), nil, true
    )

    menu_elements.discord_label = menu_items.new("discord-label", menu_elements.home_default_setts:label(
        colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " Join our" .. colors.blue .. " Discord Server"
        .. colors.bright_red .. " " .. ui.get_icon("exclamation")
    ))

    menu_elements.how_to_verify_label = menu_items.new("verify-label", menu_elements.home_default_setts:label(
        colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " Read the" .. colors.blue .. " How To Verify " .. colors.grey ..
        "Form."

        -- already verified -> "Youre all set!"
    ))

    -- @verification form
    menu_elements.home_auth = ui.create(
        home_group, ui.get_icon("robot") .. " How to verify", 1
    )

    -- tohle fakt predelavat nebudu nevim proc jsem to udelal takhle
    menu_elements.discord_verification = menu_elements.home_auth:label(
        "\aaaddffff1. \affffffffClick the \aaaddffffGet Verification Key \affffffffbutton.\n\n\aaaddffff2. \affffffffClick the \aaaddffffJoin Our Discord\affffffff button\affffffff.\n\n\aaaddffff3. \affffffffGo to the \aaaddffff#redeem-role \affffffffchannel.\n\n\aaaddffff4. \affffffffType \aaaddffff/redeem -key-\affffffff.\n"
    )

    -- lmao
    menu_elements.discord_verification:visibility(false)

    menu_elements.newww = menu_elements.home_auth:label(
        colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " You have been" .. colors.blue .. " successfully verified!\n\n"
        .. colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " If you have any" .. colors.blue .. " questions or concerns" .. colors.grey .. 
        ", please feel free to contact us at any time.\n\n"
        .. colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " We strive to provide you with the" .. colors.blue .. " best service possible " .. colors.grey .. 
        "to ensure your " .. colors.blue .. "satisfaction" .. colors.grey .."."
    )
    
    
    menu_elements.home_buttons = ui.create(home_group, ui.get_icon("triangle-exclamation") .. " Important", 2)
    menu_elements.auth_label = menu_elements.home_buttons:label(
        colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " Thank you for using momentum.\n"
        .. colors.grey .. "If you run into any problems, please visit the " .. colors.blue .. "#bug-reports "
        .. colors.grey .. "channel on our discord server.\n\n"
        .. colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " We are constantly working on the lua, to give you the best experience possible."
    )

    -- @builder menu_elements
    -- kdyztak to proste pastni z toho celestialu a ja tam pak pridam zbytek
    --menu_elements.builder_sem_kokot_pojebany = menu_items.new("kokot-switch", menu_elements.tab_settings:switch("BUILDER KOKOT"), nil, true)

    --@antiaim conditions
    menu_elements.antiaim_group_conditions = ui.create(
        antiaim_group, 
        colors.bright_red .. ui.get_icon("walking").. colors.blue .. " Conditions", 2
    )

    --@antiaim additions
    menu_elements.antiaim_group_main_additions = ui.create(
        antiaim_group, 
        colors.bright_red .. ui.get_icon("house-user").. colors.blue .. " Additions", 1
    )

    --@antiaim helpers
    menu_elements.settings_helpers = ui.create(
        antiaim_group, 
        ui.get_icon("hand-heart") .. " Antiaim helpers", 2
    )


    --@antiaim tweaks
    menu_elements.antiaim_tweaks = menu_items.new(
        "antiaim-tweaks-listable", menu_elements.settings_helpers:listable(
            ui.get_icon("wrench") .. " Additional Helpers", {
                ui.get_icon("clock-rotate-left") .. " Disable On Warmup",
                ui.get_icon("xmark") .. " Disable On Round End",
            }, 0
        ), nil, true
    )

    --@antiaim manual binds
    menu_elements.manuals = menu_items.new("menumanual", menu_elements.antiaim_tweaks:create():list(
        'Manual Yaw', 
        {
            "Disabled", "Right", "Left", "Freestanding"
        }
    ))

    --@antiaim at target disablers
    menu_elements.attdisabler = menu_items.new("attargetyaw", menu_elements.antiaim_tweaks:create():selectable(
        "FS Disablers",
        {
            "Desync Jitter", "At Targets"
        }
    ))

    --@antiaim manual disablers
    menu_elements.mandisabler = menu_items.new(
        "manualyaw", 
        menu_elements.antiaim_tweaks:create():selectable("MY Disabler", 
        {
            "Desync Jitter", "At Targets"
        }
    ))
    
    --@antiaim safety
    menu_elements.safety = menu_items.new("safety", menu_elements.antiaim_tweaks:create():selectable(
        "Safety",
        {
            "Avoid Backstab", "Static On FL"
        }
    ))

    --@antiaim main builder
    menu_elements.antiaim_builder = ui.create(
        antiaim_group, 
        ui.get_icon("wheelchair") .. " Builder"
    )
    
    --@antiaim main builder sliders
    menu_elements.antiaim_builder_sec = ui.create(
        antiaim_group, 
        ui.get_icon("wheelchair") .. " Builder 2", 2
    )

    --@antiaim main bruteforce builder
    menu_elements.antiaim_bf = ui.create(
        antiaim_group, 
        ui.get_icon("wheelchair") .. " Bruteforce"
    )
    
    --@antiaim main bruteforce sliders
    menu_elements.antiaim_bf_sec = ui.create(
        antiaim_group, 
        ui.get_icon("wheelchair") .. " Bruteforce 2", 2
    )
    
    --@antiaim desync settings
    menu_elements.antiaim_fake = ui.create(
        antiaim_group, 
        ui.get_icon("wheelchair") .. " Fake", 1
    )

    --@antiaim bruteforce desync settings
    menu_elements.antiaim_fake_bf = ui.create(
        antiaim_group, 
        ui.get_icon("wheelchair") .. " Bruteforce Fake", 1
    )

    --@antiaim state/type
    menu_elements.type = menu_items.new(
        "t", 
        menu_elements.antiaim_builder:combo('Current State', {"Loading..."}, 0)
    )

    --@antiaim freestanding mode
    menu_elements.presets1 = menu_items.new(
        "p", 
        menu_elements.antiaim_builder:combo('Freestanding ', 
        {
            "Avoid Damage"
        }, 0)
    )
    
    --@antiaim main loop/conditions
    for i = 1, 8 do
        anitaim_condition[i] = {}
        if i ~= 1 then
            --@antiaim overrider
            anitaim_condition[i].override = menu_items.new("p2".. i, menu_elements.type:create():switch('Override', false), function ()
                return menu_elements.type:get() == player_states[i]
            end)
        end

        --@antiaim body YAW mode
        anitaim_condition[i].yaw_mode = menu_items.new(
            "y_m" .. i, 
            menu_elements.antiaim_builder:combo('Body Yaw Mod', 
            {
                "Jitter", "Static"
            }, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden and in current state
        end)

        --@antiaim left real yaw
        anitaim_condition[i].yaw_add_l = menu_items.new(
            "y_a_l" .. i, 
            menu_elements.antiaim_builder_sec:slider('Yaw -> L', -180, 180, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden and in current state
        end)

        --@antiaim right real yaw
        anitaim_condition[i].yaw_add_r = menu_items.new(
            "y_a_r" .. i, 
            menu_elements.antiaim_builder_sec:slider('Yaw -> R', -180, 180, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden and in current state
        end)

        --@antiaim real jtter delay
        anitaim_condition[i].switch_ticks = menu_items.new(
            "s_t" .. i, 
            anitaim_condition[i].yaw_mode:create():slider('Delay', 4, 20, 4), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and anitaim_condition[i].yaw_mode:get() == "Jitter" 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden and in real jitter mode and in current state
        end)

        --@antiaim desync modifiers
        anitaim_condition[i].jitter = menu_items.new(
            "j" .. i, 
            menu_elements.antiaim_builder:combo('Yaw Mod', 
            {
                'Disabled', 'Center', 'Offset', 'Random', 'Spin', "3-Way", "5-Way"
            }, 0), 
            function () return menu_elements.type:get() == player_states[i] 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden and in current state
        end)

        --@antiaim desync modifier mode
        anitaim_condition[i].modifier_mode = menu_items.new(
            "m_m" .. i, 
            menu_elements.antiaim_builder:combo('Mod. Mode', 
            {
                'Static', 'Random', 'Desync'
            }, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and anitaim_condition[i].jitter:get() ~= "Disabled" 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden, not disabled
        end)

        --@antiaim desync modifier angle
        anitaim_condition[i].jitter_value = menu_items.new(
            "j_v" .. i, 
            menu_elements.antiaim_builder_sec:slider('Mod. Ang', -180, 180, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and anitaim_condition[i].jitter:get() ~= "Disabled" 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden, not disabled
        end)

        --@antiaim second desync modifier angle
        anitaim_condition[i].jitter_value1 = menu_items.new(
            "j_v2" .. i,
            menu_elements.antiaim_builder_sec:slider('Modif. Deg #2', -180, 180, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and (i == 1 or anitaim_condition[i].override:get()) 
                and anitaim_condition[i].jitter:get() ~= "Disabled" 
                and anitaim_condition[i].modifier_mode:get() ~= "Static" -- overriden, not disabled
        end)    
    
        --@antiaim desync options
        anitaim_condition[i].fake_option = menu_items.new(
            "fp" .. i, 
            menu_elements.antiaim_fake:listable('Fake Options', 
            {
                'Avoid Overlap', 'Jitter', 'Randomize Jitter'
            }, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and (i == 1 or anitaim_condition[i].override:get()) 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden
        end)

        --@antiaim desync type
        anitaim_condition[i].fake_type = menu_items.new(
            "f_t" .. i, 
            anitaim_condition[i].fake_option:create():combo('Fake Type', 
            {
                'Desync', 'Random'
            }, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and (i == 1 or anitaim_condition[i].override:get()) 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden
        end)

        --@antiaim left desync degree
        anitaim_condition[i].left_desync_value = menu_items.new(
            "l_d_v" .. i, 
            menu_elements.antiaim_builder_sec:slider('Left Limit', 0, 60, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and (i == 1 or anitaim_condition[i].override:get()) 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden
        end)

        --@antiaim right desync degree
        anitaim_condition[i].right_desync_value = menu_items.new(
            "r_d_v" .. i, 
            menu_elements.antiaim_builder_sec:slider('Right Limit', 0, 60, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and (i == 1 or anitaim_condition[i].override:get()) 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden
        end)

        --@antiaim lby mode
        anitaim_condition[i].lby_mode = menu_items.new(
            "l_m" .. i, 
            anitaim_condition[i].fake_option:create():combo('LBY Mode', 
            {
                'Disabled', 'Opposite', 'Sway'
            }, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and (i == 1 or anitaim_condition[i].override:get()) 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden
        end)

        --@antiaim freestanding desync
        anitaim_condition[i].freestand_desync = menu_items.new(
            "f_d" .. i, 
            anitaim_condition[i].fake_option:create():combo('Freestand Fake', 
            {
                'Off', 'Peek Fake', 'Peek Real'
            }, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and (i == 1 or anitaim_condition[i].override:get()) 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden
        end)

        --@antiaim onshot antiaim
        anitaim_condition[i].desync_on_shot = menu_items.new(
            "d_o_s" .. i, 
            anitaim_condition[i].fake_option:create():combo('Fake On Shot', 
            {
                'Disabled', 'Opposite', 'Freestanding', 'Switch'
            }, 0), 
            function () 
                return menu_elements.type:get() == player_states[i] 
                and (i == 1 or anitaim_condition[i].override:get()) 
                and (i == 1 or anitaim_condition[i].override:get()) -- overriden
        end)
    end

    menu_elements.animation_breakers = ui.create(
        antiaim_group, 
        ui.get_icon("wheelchair") .. " Animations", 2
    )

    menu_elements.anim_breaker_listable = menu_items.new(
        "anim-breakers-listable", menu_elements.animation_breakers:listable(
            "\af5a142FF" .. ui.get_icon("triangle-exclamation") .. " Animation Breakers", {
                ui.get_icon("person-falling") .. " Static Legs In Air",
                ui.get_icon("moon") .. " Moonwalk While In Air",
                ui.get_icon("chevrons-down") .. " Zero Pitch On Land",
            }, 0
        ), nil, true
    )

    menu_elements.list_presets = menu_items.new(
        "preset-list", menu_elements.tab_settings:list(
            ui.get_icon("wrench") .. " Antiaim settings", {
                colors.grey .. ui.get_icon("angles-right") .. colors.grey .. " Conditional | " .. colors.bright_red .. " Manual",
                colors.grey .. ui.get_icon("angles-right") .. colors.grey .. " Antibruteforce | " .. colors.bright_red .. " Manual"
            }, 0
        ), nil, true
    )

    menu_elements.list_presets:set_callback(function(value)
        selected = value:get()
        list = value:list()

        if selected == 1 then
            list[selected] = colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " Conditional | " .. colors.bright_red .. " Manual"
        else
            list[1] = colors.grey .. ui.get_icon("angles-right") .. colors.grey .. " Conditional | " .. colors.bright_red .. " Manual"
        end

        if selected == 2 then
            list[selected] = colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " Antibruteforce | " .. colors.bright_red .. " Manual"
        else
            list[2] = colors.grey .. ui.get_icon("angles-right") .. colors.grey .. " Antibruteforce | " .. colors.bright_red .. " Manual"
        end

        value:update(list)

        menu_elements.antiaim_builder:visibility(selected == 1)
        menu_elements.antiaim_builder_sec:visibility(selected == 1)
        menu_elements.antiaim_fake:visibility(selected == 1)

        menu_elements.antiaim_bf:visibility(selected == 2)
        menu_elements.antiaim_bf_sec:visibility(selected == 2)
        menu_elements.antiaim_fake_bf:visibility(selected == 2)
    end, true)

    menu_elements.team_select = menu_elements.list_presets:create():list("Team Selection", {"CT-Side", "T-Side"})
    print(menu_elements.team_select:get())
    -- @misc menu_elements
    menu_elements.widgets_form = ui.create(
        settings_group, "How To Setup " .. ui.get_icon("comment-question"), 1
    )

    menu_elements.how_to_setup = menu_elements.widgets_form:label(
        colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " Color-Pickers & Gears" .. colors.blue .. " appear after enabling " .. colors.grey .. "the selected element."
    )

    menu_elements.additional_elements = menu_elements.widgets_form:label(
        colors.bright_red .. ui.get_icon("angles-right") .. colors.grey .. " Some widgets might have additional customization located in the " .. colors.blue .. "gear icon."
    )

    
    --@visual shit
    menu_elements.widgets_screen = ui.create(settings_group, ui.get_icon("paintbrush") .. " Widgets", 1)
    menu_elements.widgets_screen_sec = ui.create(settings_group, ui.get_icon("paintbrush") .. " Visuals", 2)

    --@watermark
    menu_elements.watermark = menu_items.new(
        "watermark-switch", menu_elements.widgets_screen:switch(
            colors.blue .. "Water" .. colors.bright_red .. "mark"
        ), nil, true
    )

    --@indicator navigation
    menu_elements.indicator_tabs = menu_items.new(
        "indicator-tabs", menu_elements.watermark:create():list(
            "", 
            {
                "Preset Overriding",
                "Visual Settings"
            }
        ), nil, true
    )

    --@info label !!!!move this
    local label = menu_elements.watermark:create():label(
        definitions.colored_text(
            {
                ui.get_icon("angles-right"), colors.bright_red_non_hex
            },
            {
                " Input a text string of", color(255, 255, 255)
            },
            {
                " 4 to 12 characters in length", colors.blue_nonhex
            },
            {
                " to update the corresponding player state", color(255, 255, 255)
            }
        )
    )

    -- je to vic clean =)
    menu_elements.create_new_overrde_input = function(config_name, input_field, input_default, state_ov)
        local element = menu_items.new(
            config_name, 
            menu_elements.watermark:create():input(
                input_field, input_default
            )
        )

        element:set_callback(function(input)
            if #input:get() < 4 or #input:get() > 12 then input:set(input_default) end
            visuals.antiaim_states[state_ov] = string.upper(input:get())
            print("Callback executed!")
        end, true)

        return element
    end

    --@condition overriders
    menu_elements.override_player_coniditon_name = menu_items.new(
        "condition-names", 
        menu_elements.watermark:create():list(
            definitions.colored_text(
                { "Choose A State To ", color(255, 255, 255) },
                { "Override", colors.blue_nonhex },
                { "!", color(255, 255, 255) }
            ),
            {
                "Stand", "Run", "Slow-Walk", "Crouch", "Crouch Move", "In Air", "In Air Move"
            }
        ), nil, true
    )

    --@standing
    menu_elements.standing_override_input = menu_elements.create_new_overrde_input(
        "standing-override-input", definitions.colored_text(
            {
                "[", colors.link_active
            },
            {
                ui.get_icon("person"), color(255, 255, 255)
            },
            {
                "]", colors.link_active
            },
            {
                " Stand", color(255, 255, 255)
            }
        ), "Stand", 1
    )

    --@moving
    menu_elements.running_override_input = menu_elements.create_new_overrde_input(
        "running-override-input", definitions.colored_text(
            {
                "[", colors.link_active
            },
            {
                ui.get_icon("person-running"), color(255, 255, 255)
            },
            {
                "]", colors.link_active
            },
            {
                " Run", color(255, 255, 255)
            }
        ), "Run", 2
    )

    --@slowwalking
    menu_elements.slowwalk_override_input = menu_elements.create_new_overrde_input(
        "slowwalk-override-input", definitions.colored_text(
            {
                "[", colors.link_active
            },
            {
                ui.get_icon("turtle"), color(255, 255, 255)
            },
            {
                "]", colors.link_active
            },
            {
                " Slow", color(255, 255, 255)
            }
        ), "Slow", 3
    )

    --@crouching
    menu_elements.crouching_override_input = menu_elements.create_new_overrde_input(
        "crouching-override-input", definitions.colored_text(
            {
                "[", colors.link_active
            },
            {
                ui.get_icon("arrow-down-wide-short"), color(255, 255, 255)
            },
            {
                "]", colors.link_active
            },
            {
                " Crouch", color(255, 255, 255)
            }
        ), "Crouch", 4
    )

    --@crouching + movement
    menu_elements.crouch_move_override_input = menu_elements.create_new_overrde_input(
        "crouch-move-override-input", definitions.colored_text(
            {
                "[", colors.link_active
            },
            {
                ui.get_icon("arrows-left-right-to-line"), color(255, 255, 255)
            },
            {
                "]", colors.link_active
            },
            {
                " Crouch + M", color(255, 255, 255)
            }
        ), "C+M", 5
    )

    --@air
    menu_elements.in_air_override_input = menu_elements.create_new_overrde_input(
        "in-air-override-input", definitions.colored_text(
            {
                "[", colors.link_active
            },
            {
                ui.get_icon("arrow-up-wide-short"), color(255, 255, 255)
            },
            {
                "]", colors.link_active
            },
            {
                " In Air", color(255, 255, 255)
            }
        ), "Air", 6
    )

    --@air + crouch
    menu_elements.in_air_crouch_override_input = menu_elements.create_new_overrde_input(
        "in-air-crouch-override-input", definitions.colored_text(
            {
                "[", colors.link_active
            },
            {
                ui.get_icon("arrow-down-up-across-line"), color(255, 255, 255)
            },
            {
                "]", colors.link_active
            },
            {
                " In Air + C", color(255, 255, 255)
            }
        ), "A+C", 7
    )

    --@visiblity overriders
    menu_elements.override_player_coniditon_name:set_callback(function(val)
        selected = val:get()
        list = val:list()

        menu_elements.standing_override_input:visibility(selected == 1 and true or false)
        menu_elements.running_override_input:visibility(selected == 2 and true or false)
        menu_elements.slowwalk_override_input:visibility(selected == 3 and true or false)
        menu_elements.crouching_override_input:visibility(selected == 4 and true or false)
        menu_elements.crouch_move_override_input:visibility(selected == 5 and true or false)
        menu_elements.in_air_override_input:visibility(selected == 6 and true or false)
        menu_elements.in_air_crouch_override_input:visibility(selected == 7 and true or false)
    end, true)

    --@indicator visuals
    menu_elements.manual_arrows = menu_elements.watermark:create():combo("Manual Arrows", {
        "Simple",
        definitions.colored_text(
            {
                "Team", color(255, 255, 255)
            },
            {
                "Skeet", color("A3E908FF")
            }
        )
    })

    --@indicator accent color
    menu_elements.color_accent = menu_elements.watermark:create():color_picker(definitions.colored_text(
        {
            "Indicator ", color(255, 255, 255),
        },
        {
            "Accent", colors.bright_red_non_hex
        }
    ))

    menu_elements.manual_arrows_col = menu_elements.watermark:create():color_picker("Manual Color")

    --@indicator navigation visibility
    menu_elements.indicator_tabs:set_callback(function(e)
        menu_elements.override_player_coniditon_name:visibility(e:get() == 1)
        menu_elements.manual_arrows:visibility(e:get() == 2)
        menu_elements.color_accent:visibility(e:get() == 2)
        menu_elements.standing_override_input:visibility(false)
        menu_elements.running_override_input:visibility(false)
        menu_elements.slowwalk_override_input:visibility(false)
        menu_elements.crouching_override_input:visibility(false)
        label:visibility(e:get() == 1)
        -- ez fix my d0g
        if e:get() == 1 then
            menu_elements.override_player_coniditon_name:set(1)
        end
    end, true)


    menu_elements.spectators = menu_items.new(
        "spectator-switch", menu_elements.widgets_screen:switch(
            colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " Spectator List"
        )
    )
    
    menu_elements.spectators_col = menu_items.new("retarderer", menu_elements.spectators:color_picker(), nil, true)
    
    menu_elements.hotkeys = menu_items.new(
        "hotkey-switch", menu_elements.widgets_screen:switch(
            colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " Hotkeys"
        ), nil, true
    )


    menu_elements.notifications = menu_items.new(
        "notifications-switch", menu_elements.widgets_screen:switch(
            colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " Notificaion UI"
        ), nil, true
    )

    menu_elements.notifications_col = menu_elements.spectators:color_picker()

    menu_elements.viewmodel = menu_items.new("view-model", menu_elements.widgets_screen_sec:switch(
        colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " Viewmodel Changer"), 
        nil, true
    )

    menu_elements.viewmodel_fov = menu_items.new("view-model-fov", menu_elements.viewmodel:create():slider(
        colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " FOV", 0, 100, 68), 
        function()
            return menu_elements.viewmodel:get()
    end)

    menu_elements.viewmodel_x = menu_items.new("view-model-x", menu_elements.viewmodel:create():slider(
        colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " X Axis", -10, 10, 1), 
        function()
            return menu_elements.viewmodel:get()
    end)

    menu_elements.viewmodel_y = menu_items.new("view-model-y", menu_elements.viewmodel:create():slider(
        colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " Y Axis", -10, 10, 1), 
        function()
            return menu_elements.viewmodel:get()
    end)

    menu_elements.viewmodel_z = menu_items.new("view-model-z", menu_elements.viewmodel:create():slider(
        colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " Z Axis", -10, 10, -1), 
        function()
            return menu_elements.viewmodel:get()
    end)

    ratios = {
        [177] = "16:9",
        [161] = "16:10",
        [150] = "3:2",
        [133] = "4:3",
        [125] = "5:4",
    }

    menu_elements.aspect_ratio = menu_items.new("aspect-ratio", menu_elements.widgets_screen_sec:switch(
        colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " Aspect Ratio"), 
        nil, true
    )

    menu_elements.aspect_ratio_val = menu_items.new("aspect-raio-val", menu_elements.aspect_ratio:create():slider(
        colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " Ratio", 50, 300, 0.5, 0.01)
    )

    menu_elements.use_presets = menu_items.new("aspect-ratio-use-presets", menu_elements.aspect_ratio:create():switch(
        colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " Use Presets")
    )

    menu_elements.aspect_ratio_preset = menu_items.new("aspect-raio-preset", menu_elements.aspect_ratio:create():list(
        "", ratios):set_callback(function(e)
            selected = e:get()
            list = e:list()
            for k, v in pairs(ratios) do
                if v == list[selected] then
                    menu_elements.aspect_ratio_val:set(k)
                    break
                end
            end
    end), true)

    menu_elements.aspect_ratio:tooltip(definitions.colored_text(
        {
            ui.get_icon("angles-right"), colors.bright_red_non_hex
        },
        {
            " Widenes", colors.blue_nonhex
        },
        {
            " or ", color(255, 255, 255)
        },
        {
            "Tightenes ", colors.blue_nonhex
        },
        {
            "your screen based on your selection.\n\n"
        },
        {
            "If you dont know how to use this feature, there are already predefined presets, get to use them by clicking on the ", color(255, 255, 255)
        },
        {
            "Use Presets ", colors.blue_nonhex
        },
        {
            "checkbox.", color(255, 255, 255)
        }
    ))

    menu_elements.use_presets:set_callback(function()
        menu_elements.aspect_ratio_val:visibility(not menu_elements.use_presets:get())
        menu_elements.aspect_ratio_preset:visibility(menu_elements.use_presets:get()) 
        menu_elements.aspect_ratio_preset:set(menu_elements.use_presets:get() and 1 or 0)
        menu_elements.aspect_ratio_val:set(0.5)
    end, true)

    menu_elements.hit_particles = menu_items.new("hit-particles", menu_elements.widgets_screen_sec:switch(
        colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " Hit Particles"), 
        nil, true
    )

    menu_elements.use_presets:tooltip(definitions.colored_text(
        {
            ui.get_icon("angles-right"), colors.bright_red_non_hex
        },
        {
            " By clicking this ", color(255, 255, 255)
        },
        {
            "checkbox ", colors.blue_nonhex
        },
        {
            "a list of available presets will appear. Go ahead and pick a preset!"
        }
    ))
   
    local effects = {hit = {}}
    effects.hit.switch = menu_elements.hit_particles
    effects.hit.settings = effects.hit.switch:create()
    effects.hit.clear_decals = effects.hit.settings:switch("Clear Decals"):tooltip(definitions.colored_text(
        {
            ui.get_icon("angles-right"), colors.bright_red_non_hex
        },
        {
            " Removes decals such as ", color(255, 255, 255)
        },
        {
            "bullet holes ", colors.blue_nonhex
        },
        {
            "and ", color(255, 255, 255)
        },
        {
            "blood spray ", colors.bright_red_non_hex
        },
        {
            "in order to make the effect more visible.", color(255, 255, 255)
        }
    ))
    effects.hit.amount = effects.hit.settings:slider("Amount", 0, 10, 5)
    effects.hit.size = effects.hit.settings:slider("Size", 0, 10, 3)
    --effects.autopeek = __.menu.visuals:switch("Autopeek sparkles")
    
    effects.interface = utils.create_interface("client.dll", "IEffects001")
    effects.summon_splash = vtable_bind(effects.interface, "void(__thiscall*)(void*, const struct vec3_t&, const struct vec3_t&, bool)", 7)
    effects.summon_sparks = vtable_bind(effects.interface, "void(__thiscall*)(void*, const struct vec3_t&, int, int, const struct vec3_t&)", 3)
    effects.sparks_mat = materials.get("effects/spark")
    effects.hit.switch:tooltip(
        definitions.colored_text(
            {
                ui.get_icon("angles-right"), colors.bright_red_non_hex
            },
            {
                " Renders a ", color(255, 255, 255)
            },
            {
                "sparking effect ", colors.blue_nonhex
            },
            {
                "when the aimbot fires.", color(255, 255, 255)
            }
        )
    )

    menu_elements.shared_features = menu_items.new("shared-features", menu_elements.tab_misc:switch(
        colors.blue .. ui.get_icon("angles-right") .. colors.grey .. " Viewmodel Changer"),
        nil, true
    )

    visuals.verdana_bold = render.load_font("Verdana", 11, "bda")
    --@crosshair-indicators
    visuals.crosshair_indicators = function()
        local safe = menu_elements.watermark:get() 

        --if not main.safe then return end

        local animate = {}
        animate.main = animations.new("indicators_main", safe and 255 or 0)
    
        if animate.main < 1 then
            return
        end

        local player = entity.get_local_player()

        local intro = script_visuals['stored']['script_load']

        animate.lua_name = {}
        animate.lua_name.alpha = animations.new("lua_name_alpha", player and player:is_alive() and intro["show"] == true and safe and 255 or 0)
        animate.lua_name.move = animations.new("lua_name_move", definitions.shared_aa.is_scoped and -10 or render.measure_text(visuals.verdana_bold, nil, "momentum").x/2)
        animate.lua_name.animated_text = colors.gradient_text("momentum", 1.7, {menu_elements.color_accent:get(), color(36, 36, 36)})

        animate.lua_name.text = {
            ["Static"] = definitions.colored_text({"momentum", color(255, 255, 255)}),
            ["Animated"] = gradient.text("momentum", false, {menu_elements.color_accent:get(), color(255, 255, 255)}),
        }

        local add_y = 20

        if animate.lua_name.alpha > 1 then
            render.shadow(
                vector(
                    definitions.screen_size.x/2 - animate.lua_name.move, 
                    definitions.screen_size.y/2 + add_y + 7),
                vector(
                    definitions.screen_size.x/2 + render.measure_text(visuals.verdana_bold, nil, "momentum").x - animate.lua_name.move, 
                    definitions.screen_size.y/2 + add_y + 7),
                    color(255, 255, 255):alpha_modulate(animate.lua_name.alpha),
                    glow_strength
            )

            render.text(visuals.verdana_bold, vector(
                definitions.screen_size.x/2 - animate.lua_name.move, 
                definitions.screen_size.y/2 + add_y), 
                color(255, 255, 255):alpha_modulate(animate.lua_name.alpha), 
                nil, 
                animate.lua_name.text["Animated"]
            )

            add_y = add_y + animate.lua_name.alpha/255*10
        end

        local antiaim_state_name = visuals.antiaim_states[antiaim.player_state]

        animate.antiaim_state = {}
        animate.antiaim_state.alpha = animations.new("antiaim_state_alpha", player and player:is_alive() and intro["show"] == true and safe and 255 or 0, 0.02)
        animate.antiaim_state.move = animations.new("antiaim_state_move", definitions.shared_aa.is_scoped and -10 or render.measure_text(2, nil, antiaim_state_name).x/2)
        if animate.antiaim_state.alpha > 1 then
            render.text(
                2, 
                vector(definitions.screen_size.x/2 - animate.antiaim_state.move, 
                definitions.screen_size.y/2 + add_y), 
                color(255, 255, 255):alpha_modulate(animate.antiaim_state.alpha), 
                nil, 
                antiaim_state_name
            )

            add_y = add_y + animate.antiaim_state.alpha/255*9
        end

        animate.manual_arrows = {}

        local max_alpha = definitions.shared_aa.is_scoped and 40 or 255
    
        local manual_arrows_dst = 30
        animate.manual_arrows.alpha2 = animations.new("manual_arrows_alpha2", player and player:is_alive() and intro["show"] == true and safe and string.find(menu_elements.manual_arrows:get(), "Team") and max_alpha or 0, 0.04)
        if animate.manual_arrows.alpha2 > 1 then
            render.rect(
                vector((definitions.screen_size.x/2) - manual_arrows_dst - 12, (definitions.screen_size.y/2) - 10), 
                vector((definitions.screen_size.x/2) - manual_arrows_dst - 10, (definitions.screen_size.y/2) + 10), 
                antiaim.side == 1 and menu_elements.color_accent:get():alpha_modulate(animate.manual_arrows.alpha2) or 
                color(0, 0, 0, 255):alpha_modulate(animate.manual_arrows.alpha2/255*menu_elements.manual_arrows_col:get().a), 
                0, true
            )
            render.rect(
                vector((definitions.screen_size.x/2) + manual_arrows_dst + 12, (definitions.screen_size.y/2) - 10), 
                vector((definitions.screen_size.x/2) + manual_arrows_dst + 10, (definitions.screen_size.y/2) + 10), 
                antiaim.side == -1 and menu_elements.color_accent:get():alpha_modulate(animate.manual_arrows.alpha2) or 
                color(0, 0, 0, 255):alpha_modulate(animate.manual_arrows.alpha2/255*menu_elements.manual_arrows_col:get().a), 
                0, true
            )
            render.poly(
                menu_elements.manuals:get() == 3 and menu_elements.manual_arrows_col:get():alpha_modulate(animate.manual_arrows.alpha2) 
                or color(0, 0, 0, 255):alpha_modulate(animate.manual_arrows.alpha2/255*menu_elements.manual_arrows_col:get().a), 
                vector((definitions.screen_size.x/2) - manual_arrows_dst - 13, (definitions.screen_size.y/2) + 9),
                vector((definitions.screen_size.x/2) - manual_arrows_dst - 26, (definitions.screen_size.y/2)), 
                vector((definitions.screen_size.x/2) - manual_arrows_dst - 13, (definitions.screen_size.y/2) - 9)
            )
            render.poly(
                menu_elements.manuals:get() == 2 and menu_elements.manual_arrows_col:get():alpha_modulate(animate.manual_arrows.alpha2) 
                or color(0, 0, 0, 255):alpha_modulate(animate.manual_arrows.alpha2/255*menu_elements.manual_arrows_col:get().a),
                vector((definitions.screen_size.x/2) + manual_arrows_dst + 13, (definitions.screen_size.y/2) - 9 ), 
                vector((definitions.screen_size.x/2) + manual_arrows_dst + 26, (definitions.screen_size.y/2)), 
                vector((definitions.screen_size.x/2) + manual_arrows_dst + 13, (definitions.screen_size.y/2) + 9)
            )
        end

        local binds = {
            {nil, refs.double_tap:get()},
            {"HIDE", refs.hide_shots:get()},
            {"AUTO", refs.fs:get()},
            {"DUCK", refs.fakeduck:get()},
        }
        
        animate.retard = {}
        animate.exploit_charge = animations.new("exploit_charge", rage.exploit:get())
        for k, v in pairs(binds) do
            v[1] = v[1] or "DT\x20\x20\x20\x20\x20\x20\x20\x20"
            if animate.retard[v[1]] == nil then
                animate.retard[v[1]] = {}
                animate.retard[v[1]].move = 0
                animate.retard[v[1]].alpha = 0
            end
    
            animate.retard[v[1]].alpha = animations.new("indicators_alpha_" .. v[1], player and player:is_alive() and intro["show"] == true and safe and v[2] and 255 or 0)
            animate.retard[v[1]].move = animations.new("indicators_move_" .. v[1], definitions.shared_aa.is_scoped and -10 or render.measure_text(2, nil, v[1]).x/2)
    
            if animate.retard[v[1]].alpha > 1 then
                render.text(2, vector(definitions.screen_size.x/2 - animate.retard[v[1]].move, 
                definitions.screen_size.y/2 + add_y), 
                color(255, 0, 0):alpha_modulate(animate.retard[v[1]].alpha), nil, v[1])
    
                if v[1]:find("DT") then
                    render.circle_outline(
                        vector(
                            definitions.screen_size.x/2 - animate.retard[v[1]].move + 15, 
                            definitions.screen_size.y/2 + add_y + 6), 
                            color(255, 255, 255):alpha_modulate(animate.retard[v[1]].alpha), 4, 0, 
                            animate.exploit_charge, 1.5
                        )
                end
                add_y = add_y + animate.retard[v[1]].alpha/255*9
            end
    
        end
    end

    antiaim.conditions = {}
    antiaim.condition_names = {}

    antiaim.states = {
        unknown = -1,
        standing = 1,
        moving = 2,
        slowwalk = 3,
        crouching = 4,
        moving_crouch = 5,
        air = 6,
        air_crouch = 7
    }

    antiaim.states_names = {}
    for k, v in pairs(antiaim.states) do
        antiaim.states_names[v] = k:sub(1,1):upper() .. k:sub(2, #k)
    end

    antiaim.create_condition = function(name, condition)

        local cond_idx = #antiaim.conditions + 1
        antiaim.conditions[cond_idx] = {
            name = name,
            condition = condition,
        }
        
        table.insert(antiaim.condition_names, name)
    
        menu_elements.type:update(antiaim.condition_names)
    end

    antiaim.create_condition("Shared", function()
        return true
    end)
    
    antiaim.create_condition("Standing", function()
        return antiaim.player_state == antiaim.states.standing
    end)
    
    
    antiaim.create_condition("Moving", function()
        return antiaim.player_state == antiaim.states.moving
    end)
    
    antiaim.create_condition("Slowwalk", function()
        return antiaim.player_state == antiaim.states.slowwalk
    end)
    
    antiaim.create_condition("Crouch", function()
        return antiaim.player_state == antiaim.states.crouching
    end)
    
    antiaim.create_condition("Crouch & Move", function()
        return antiaim.player_state == antiaim.states.moving_crouch
    end)
    
    antiaim.create_condition("Air", function()
        return antiaim.player_state == antiaim.states.air
    end)
    
    antiaim.create_condition("Air & Crouch", function()
        return antiaim.player_state == antiaim.states.air_crouch
    end)

    antiaim.player_state = 1
    antiaim.update_player_state = function(cmd)
    
        local localplayer = entity.get_local_player()
    
        if localplayer == nil then
            return
        end
    
        local flags = localplayer.m_fFlags
    
        local is_crouching = bit.band(flags, definitions.shared_aa.flags.FL_DUCKING) ~= 0
        local on_ground = bit.band(flags, definitions.shared_aa.flags.FL_ONGROUND) ~= 0
        local is_not_moving = localplayer.m_vecVelocity:length() < 2
        local is_slowwalk = refs.slowwalk:get()
        local is_jumping = cmd.in_jump
    
        if is_crouching and (is_jumping or not on_ground) then
            antiaim.player_state = antiaim.states.air_crouch
            return
        end
    
        if is_jumping or not on_ground then
            antiaim.player_state = antiaim.states.air
            return
        end
    
        if is_slowwalk then
            antiaim.player_state = antiaim.states.slowwalk
            return
        end
    
        if not is_crouching and is_not_moving then
            antiaim.player_state = antiaim.states.standing
            return
        end
    
        if is_crouching and not is_not_moving and not is_slowwalk then
            antiaim.player_state = antiaim.states.moving_crouch
            return
        end
    
        if is_crouching and is_not_moving then
            antiaim.player_state = antiaim.states.crouching
            return
        end
    
        if not is_crouching and not is_not_moving and not is_slowwalk then
            antiaim.player_state = antiaim.states.moving
            return
        end
    
        antiaim.player_state = antiaim.states.unknown
    end

    ragebot.normalize_yaw = function(yaww) while yaww > 180 do yaww = yaww - 360 end while yaww < -180 do yaww = yaww + 360 end return yaww end
    antiaim.override_yaw = function(yaw_add, jitter_value, jitter_type) local yaw_modifier = yaw_add if jitter_type == 1 then yaw_modifier = yaw_modifier + (jitter_value / 2) * antiaim.side elseif jitter_type == 2 then yaw_modifier = yaw_modifier + jitter_value * ((antiaim.side+1) / 2) elseif jitter_type == 3 then yaw_modifier = math.random(-jitter_value, jitter_value) elseif jitter_type == 4 then yaw_modifier = yaw_modifier - (globals.tickcount * 3) % jitter_value end return yaw_modifier end

    math.normalize_yaw = math.normalize_yaw

    antiaim.current_side = false
    antiaim.desync_delta = 0

    antiaim.get_desync_delta = function()
        local player = entity.get_local_player()
    
        if player == nil then
            return
        end
    
        antiaim.desync_delta = math.normalize_yaw(player.m_flPoseParameter[11] * 120 - 60) / 2
    end

    antiaim.get_desync_side = function()
        antiaim.current_side = antiaim.desync_delta < 0
    end

    -- udelej ten builder vic readable
    local function entity_has_c4(presource) if presource == nil then return end return presource["m_iPlayerC4"] == 1 end
    local classnames = {"CWorld","CCSPlayer","CFuncBrush"}
    local function vec_distance(vec_one, vec_two) 
        local delta_x, delta_y, delta_z = vec_one.x - vec_two.x, vec_one.y - vec_two.y 
        return math.sqrt(delta_x * delta_x + delta_y * delta_y) 
    end

    local aainverted = false
    local yaw_m = function(localplayer) 
        local bodyyaw = localplayer.m_flPoseParameter[11] * 120 - 60 if globals.choked_commands == 0 then 
            aainverted = bodyyaw > 0 
        end 
        antiaim.side = aainverted and 1 or -1 
    end

    function state() if not entity.get_local_player() then  return  end  local flags = entity.get_local_player().m_fFlags  local first_velocity = entity.get_local_player()['m_vecVelocity[0]']  local second_velocity = entity.get_local_player()['m_vecVelocity[1]']  local velocity = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))  if bit.band(flags, 1) == 1 then  if bit.band(flags, 4) == 4 then  return "Crouching" else  if velocity <= 3 then  return "Standing" else  if ui.find("Aimbot", "Anti Aim", "MISC", "Slow Walk"):get() then   return "Slowwalking" else  return "Moving" end  end  end  elseif bit.band(flags, 1) == 0 then  if bit.band(flags, 4) == 4 then  return "Air+Duck" else  return "Air" end  end  end

    manualfunc = function()
        if (menu_elements.manuals:get() == 4) then
            refs.fs:override(true)
        else
            refs.fs:override(false)
        end
    
        if ((menu_elements.manuals:get() == 2 or menu_elements.manuals:get() == 3)) then
            return (menu_elements.manuals:get() == 2 and 102 or 0) + (menu_elements.manuals:get() == 3 and -78 or 0)
        else
            return (menu_elements.manuals:get() == 2 and 90 or 0) + (menu_elements.manuals:get() == 3 and -90 or 0)
        end
    end

    antiaim.disable_conditions = function(arg)
        local rules = entity.get_game_rules()

        if rules == nil then
            return false
        end
    
        local players = entity.get_players(true, false)
    
        if players == nil then
            return false
        end
    
        if arg == "Warmup" and rules.m_bWarmupPeriod or arg == "Round End" and definitions.shared_aa.round_end then
            return true
        else
            return false
        end
    end

    antiaim.conditions = function(cmd)
        local localplayer = entity.get_local_player()
        if not localplayer then return end
        if not localplayer:is_alive() then return end

        -- no vsak jo
        if menu_elements.antiaim_tweaks:get(1) and antiaim.disable_conditions("Warmup") 
        or menu_elements.antiaim_tweaks:get(2) 
        and antiaim.disable_conditions("Round End") then
            refs.pitch:override("Disabled")
            refs.yawoffset:override(0)
            refs.yawbase:override("Local View")
            refs.yaw:override("Disabled")
            refs.fs:override(false)
            refs.fakeopt:override()
            refs.leftdesync:override(0)
            refs.rightdesync:override(0)
        else
            antiaim.get_desync_side(cmd)
            yaw_m(localplayer)
            local active_weapon = localplayer:get_player_weapon()
    
            definitions.shared_aa.is_scoped = active_weapon and localplayer.m_bIsScoped or false
    
            local anti_aim_invert = antiaim.side ~= 1
            antiaim.update_player_state(cmd)
            local player_state = antiaim.player_state
            local default_presets = {
                -- {Yaw Add, Yaw Modifier, Modifier Degree, Left Limit, Right Limit, Fake Options, LBY Mode, Freestanding Desync, Desync On Shot}
                [1] = {
                    ['Standing'] = {(antiaim.side ~= 1) and -4 or 4, "Center", -19, 56, 56, "Jitter", "Disabled", "Off", "Freestanding"},
                    ['Moving'] = {(antiaim.side ~= 1) and 4 or 0, "Center", -12, 56, 56, "Jitter", "Disabled", "Off", "Freestanding"},
                    ['Crouching'] = {(antiaim.side ~= 1) and 4 or 4, "Center", -18, 60, 60, "Jitter", "Disabled", "Off", "Freestanding"},
                    ['Slowwalking'] = {(antiaim.side ~= 1) and 0 or -1, "Disabled", 0, 60, 60, "Jitter", "Disabled", "Off", "Default"},
                    ['Air'] = {(antiaim.side ~= 1) and -4 or -4, "Center", -29, 60, 60, "Jitter", "Disabled", "Off", "Default"},
                    ['Air+Duck'] = {(antiaim.side ~= 1) and -4 or -4, "Center", -12, 60, 60, "Jitter", "Disabled", "Off", "Default"},
                },
                [2] = {
                    ['Standing'] = {(antiaim.side ~= 1) and 3 or 8, "Center", -68, 60, 60, "Jitter", "Disabled", "Off", "Switch"},
                    ['Moving'] = {(antiaim.side ~= 1) and 0 or 0, "Center", -69, 60, 60, "Jitter", "Opposite", "Off", "Freestanding"},
                    ['Crouching'] = {(antiaim.side ~= 1) and -1 or 5, "Center", -62, 60, 60, "Jitter", "Disabled", "Off", "Switch"},
                    ['Slowwalking'] = {(antiaim.side ~= 1) and 0 or 4, "Center", -64, 60, 60, "Jitter", "Disabled", "Off", "Switch"},
                    ['Air'] = {(antiaim.side ~= 1) and 8 or 13, "Center", -48, 60, 60, {"Avoid Overlap", "Jitter"}, "Opposite", "Peek Fake", "Switch"},
                    ['Air+Duck'] = {(antiaim.side ~= 1) and -3 or 3, "Center", -80, 60, 60, "Jitter", "Disabled", "Off", "Switch"}
                }
            }

            -- hroznej builder pičo ale mam pici
            refs.pitch:override("Down")
            refs.yaw:override("Backward")
    
            refs.yawbase:override((((menu_elements.manuals:get() == 3 
            or menu_elements.manuals:get() == 2) 
            and menu_elements.mandisabler:get(2)) 
            or ((menu_elements.manuals:get() == 4) 
            and menu_elements.attdisabler:get(2))) 
            and "Local View" 
            or "At Target")
    
            aastate = 3

            refs.avoid_stab:override(menu_elements.safety:get(1))
    
            local state_aa, weapon
    
    
            if player_state == antiaim.states.standing and anitaim_condition[2].override:get() then
                state_id = 2
            elseif player_state == antiaim.states.moving and anitaim_condition[3].override:get() then
                state_id = 3
            elseif player_state == antiaim.states.slowwalk and anitaim_condition[4].override:get() then
                state_id = 4
            elseif player_state == antiaim.states.crouching and anitaim_condition[5].override:get() then
                state_id = 5
            else
                state_id = 1
            end
            
            local condition = (anitaim_condition[state_id] ~= nil and anitaim_condition[state_id] or anitaim_condition[1])
    
            local ui_modifier_mode = condition.modifier_mode:get()
            local ui_jitter = condition.jitter:get()
            local ui_jitter_value = condition.jitter_value:get()
            local ui_jitter_value1 = condition.jitter_value1:get()
            local ui_yaw_mode = condition.yaw_mode:get()
            local ui_switch_ticks = condition.switch_ticks:get()
            local ui_yaw_add_r = condition.yaw_add_r:get()
            local ui_yaw_add_l = condition.yaw_add_l:get()
            local ui_left_desync_value = condition.left_desync_value:get()
            local ui_right_desync_value = condition.right_desync_value:get()
            local ui_fake_type = condition.fake_type:get()        
         
            local jitter_value
            if ui_modifier_mode == "Static" then
                jitter_value = ui_jitter_value
            elseif ui_modifier_mode == "Random" then
                jitter_value = math.random(ui_jitter_value, ui_jitter_value1)
            else
                jitter_value = antiaim.side == 1 and ui_jitter_value or ui_jitter_value1
            end
                
            local invert
            if ui_yaw_mode == "Jitter" then
                invert = (ui_switch_ticks / 2 <= (globals.tickcount % ui_switch_ticks)) and ui_yaw_add_r or ui_yaw_add_l
            else
                if condition.fake_option:get(3) then
                    local rndm = math.random(0, 1) == 0
                    invert = rndm and ui_yaw_add_r or ui_yaw_add_l
                elseif condition.fake_option:get(2) then
                    invert = antiaim.side == 1 and ui_yaw_add_r or ui_yaw_add_l
                else
                    invert = refs.inverter:get_override() and ui_yaw_add_r or ui_yaw_add_l
                end
            end

    
            refs.yawoffset:override(0)
    
            local override_yaw_offset, override_limit, override_inverter
            if condition.fake_option:get(3) then
                override_yaw_offset = antiaim.override_yaw(invert, jitter_value, ui_jitter)
    
                local rndm = math.random(0, 1) == 0
                if ui_fake_type == 0 then
                    override_limit = rndm and ui_left_desync_value or ui_right_desync_value
                else
                    override_limit = math.random(ui_left_desync_value, ui_right_desync_value)
                end
    
                override_inverter = rndm
            elseif condition.fake_option:get(2) then
                override_yaw_offset = antiaim.override_yaw(invert, jitter_value, ui_jitter)
    
                if ui_fake_type == 0 then
                    override_limit = antiaim.side ~= 1 and ui_left_desync_value or ui_right_desync_value
                else
                    override_limit = math.random(ui_left_desync_value, ui_right_desync_value)
                end
             
                override_inverter = antiaim.side ~= 1
            else
                override_yaw_offset = antiaim.override_yaw(invert, jitter_value, ui_jitter)
    
                if ui_fake_type == 0 then
                    override_limit = refs.inverter:get_override() and ui_left_desync_value or ui_right_desync_value
                else
                    override_limit = math.random(ui_left_desync_value, ui_right_desync_value)
                end
                override_inverter = refs.inverter:get()
            end
    
            zebracky_kokot_vyjebany = function()
                local zebrak = {}
                local hahkokot = {'Avoid Overlap', 'Jitter', 'Randomize Jitter'}
                for i, retard in ipairs(hahkokot) do
                    if condition.fake_option:get(i) then
                        table.insert(zebrak, retard)
                    end
                end
                return zebrak
            end
    
            refs.yawoffset:override(
                manualfunc() ~= 0 and manualfunc() 
                or ragebot.normalize_yaw(override_yaw_offset)
            )
    
            refs.leftdesync:override(
                (((menu_elements.manuals:get() == 2 -- right side manual aa
                or menu_elements.manuals:get() == 3)  -- left side manual aa
                and menu_elements.mandisabler:get(1)) -- jitter disabler
                or ((menu_elements.manuals:get() == 4)  -- real yaw freestanding
                and menu_elements.attdisabler:get(1)))  -- at targets disabler
                and 60 -- passed - 60 else override the limit manually
                or override_limit
            )
    
            refs.rightdesync:override(
                (((menu_elements.manuals:get() == 2 
                or menu_elements.manuals:get() == 3) 
                and menu_elements.mandisabler:get(1)) 
                or ((menu_elements.manuals:get() == 4) 
                and menu_elements.attdisabler:get(1))) 
                and 
                60 
                or override_limit
            )
    
            refs.inverter:override(
                override_inverter
            )
    
            refs.yawmod:override(
                (((menu_elements.manuals:get() == 2
                or menu_elements.manuals:get() == 3) 
                and menu_elements.mandisabler:get(1)) 
                or ((menu_elements.manuals:get() == 4) 
                and menu_elements.attdisabler:get(1))) 
                and "Disabled" or ui_jitter
            )
    
            local jitter = 0
            jitter_disablers = function()
                --if ui_handler.elements["aa"]["helpers"]["Static Fakelags Yaw"] and not neverlose_refs.doubletap:get() and not neverlose_refs.hideshots:get() then
                if menu_elements.safety:get(2) and not refs.double_tap:get() and not refs.hide_shots:get() then
                    jitter = 0
                else
                    jitter = jitter_value
                end
                return jitter
            end
            refs.yawmodoffset:override(
                jitter_disablers()
            )
    
            refs.fakeopt:override(
                (((menu_elements.manuals:get() == 2 
                or menu_elements.manuals:get() == 3) 
                and menu_elements.mandisabler:get(1)) or ((menu_elements.manuals:get() == 4) 
                and menu_elements.attdisabler:get(1))) 
                and "" or zebracky_kokot_vyjebany()
            )
            
            refs.desyncfs:override(
                (((menu_elements.manuals:get() == 2 
                or menu_elements.manuals:get() == 3) 
                and menu_elements.mandisabler:get(1)) 
                or ((menu_elements.manuals:get() == 4) 
                and menu_elements.attdisabler:get(1))) 
                and "Off" 
                or 
                condition.freestand_desync:get()
            )
        end
    end

    local anim = {}
    anim = {
        lerp = function(start, vend)
            return start + (vend - start) * (globals.frametime * 6)
        end,
        
        lerp_notify = function(start, vend)
            return start + (vend - start) * (globals.frametime * 8)
        end,
        
        animate_new = function(value, startpos, endpos, condition)
            if condition ~= nil then
                if condition then
                    return anim.lerp(value,startpos)
                else
                    return anim.lerp(value,endpos)
                end
            else
                return anim.lerp(value,startpos)
            end
        end
    }

    script_visuals = {
        ['stored'] = {
            ['script_load'] = {
                ['start'] = globals.realtime,
                ['show'] = false,
                ['alpha'] = 0
            },
        },

        script_load = function()
            local v = script_visuals['stored']['script_load']
            v['alpha'] = anim.animate_new(v['alpha'],1,0,not v['show'], anim)
            --local text = gradient_text(115, 154, 255,255 * v['alpha'] + 0.5,128,128,240,255 * v['alpha'] + 0.5, "C E L E S T I A L")
            local text_size = render.measure_text(variables.fonts.verdana_anti_bold, text)
            local image_size = vector(300 * v['alpha'], 300 * v['alpha'])
    
            color_table = {
                color(128,128,240, math.floor(0 * v['alpha'])),
                color(128,128,240, math.floor(255 * v['alpha'])),
                color(128,128,240, math.floor(0 * v['alpha'])),
                color(128,128,240, math.floor(255 * v['alpha']))
            }
    
            render.blur(vector(0, 0), vector(variables.other.screen_size.x, variables.other.screen_size.y), 2, v['alpha'])
            render.rect(vector(0, 0), vector(variables.other.screen_size.x, variables.other.screen_size.y), 
            color(10, 10, 10, 150*v['alpha']))
    
            render.texture(main_logo_texture, vector(variables.other.screen_size.x / 2 - image_size.x / 2,variables.other.screen_size.y / 2 - image_size.y / 2), 
            image_size, color(128, 128, 240, math.floor(255 * v['alpha'])), "f")
    
            --render.text(variables.fonts.verdana_anti_bold, vector(variables.otherscreen_size.x / 2 - text_size.x / 2, 
            --variables.otherscreen_size.y / 2 - text_size.y / 2 + 120), 
            --color(255, 255, 255, 255), "c", text)
            
            if v['start'] + 4 < globals.realtime then
                v['start'] = globals.realtime
                v['show'] = true
            end
        end
    }

    local movement = {}
    movement.fast_ladder = function()

    end

    visuals.cvars = {
        viewmodel_fov       = cvar.viewmodel_fov,
        viewmodel_offset_x  = cvar.viewmodel_offset_x,
        viewmodel_offset_y  = cvar.viewmodel_offset_y,
        viewmodel_offset_z  = cvar.viewmodel_offset_z
    }

    visuals.viewmodel = function()
        if menu_elements.viewmodel:get() then
            visuals.cvars.viewmodel_fov      :float(menu_elements.viewmodel_fov:get(), true)
            visuals.cvars.viewmodel_offset_x :float(menu_elements.viewmodel_x:get(), true)
            visuals.cvars.viewmodel_offset_y :float(menu_elements.viewmodel_y:get(), true)
            visuals.cvars.viewmodel_offset_z :float(menu_elements.viewmodel_z:get(), true)
        else
            visuals.cvars.viewmodel_fov      :float(68   )
            visuals.cvars.viewmodel_offset_x :float(2.5  )
            visuals.cvars.viewmodel_offset_y :float(0    )
            visuals.cvars.viewmodel_offset_z :float(-1.5 )
        end
    end

    visuals.cvar = cvar.r_aspectratio
    visuals.cvar_float_raw = visuals.cvar.float
    
    visuals.aspect_ratio = function(init)
    
        local desired_value = animations.new("aspect_ratio", menu_elements.aspect_ratio_val:get() / 100, nil, menu_elements.aspect_ratio_val:get() / 100)
    
        if menu_elements.aspect_ratio_val:get() == 50 then
            desired_value = 0
        end
    
        if not menu_elements.aspect_ratio:get() then
            desired_value = 0
        end
    
        local actual_value = visuals.cvar_float_raw(visuals.cvar)
    
        if desired_value ~= actual_value then
            visuals.cvar_float_raw(visuals.cvar, desired_value)
        end
    
    end
    
    visuals.destroy = function()
        visuals.cvar_float_raw(visuals.cvar, 0)
    end

    local callbacks = {
        register = function(event, name, fn) -- s timhle registerujes callbacky (:O)
            events[event]:set(safe.safecall(name, true, fn)) -- vlastne uplne to stejny akorat ten safecall funguje jako nakej error handler (nedodelanej)
        end
    }

    definitions.shared_aa.round_end = false
    callbacks.register("render", "ui-sidebar", menu_elements.update_sidebar)
    callbacks.register("render", "visuals-intro", script_visuals.script_load)
    callbacks.register("shutdown", "other-disconnect-sound", safe.panorama_handler.main.left_sound)
    callbacks.register("createmove", "update-state", antiaim.conditions)
    callbacks.register("round_end", "disble-aa-round_end", function() definitions.shared_aa.round_end = true end)
    callbacks.register("round_start", "enable-aa-round_start", function() definitions.shared_aa.round_end = false end)
    callbacks.register("aim_ack", "summon-particles", function(e)
        if e.reason then return end
        if effects.hit.clear_decals:get() then 
            cvar.violence_ablood:int(0) -- blood
            cvar.violence_hblood:int(0) -- blood
        end
        effects.summon_sparks(vec3_t(e.aim:unpack()), effects.hit.amount:get(), effects.hit.size:get(), nil)
    end)
    
    -- top secret
    --removed due to code privacy

    callbacks.register("render", "test", function()
        variables.other.list_val = menu_elements.list_presets:get()
        visuals.crosshair_indicators()
    end)
    callbacks.register("mouse_input", "other-block_input", function()
        local v = script_visuals['stored']['script_load']
        while(v["show"] == false) -- ==))) chci to tak takze mi hul
        do
            return false
        end
    end)

    menu_items.run_update()

end

setup() -- done