ffi.cdef[[
    typedef bool(__thiscall* console_is_visible)(void*);
]]

    local neforbild                     = menu.add_text("metamethod > Information", "User: " ..user.name.. " [" ..user.uid.. "].")
   local neforver                      = menu.add_text("metamethod > Information", "Version: free.")
   local neforcord                     = menu.add_text("metamethod > Information", "Buy premium version.")




local master_switch_ragebot = menu.add_checkbox("metamethod > Ragebot", "Master Switch")

-- faster recharge
local fasterrecharge_enable = menu.add_checkbox("metamethod > Ragebot", "Fast Double tap Recharge")
local function fasterrecharge()
    if not fasterrecharge_enable:get() then return end
        exploits.force_recharge()
    end


-- interpolation
local interpol_enable = menu.add_checkbox("metamethod > Ragebot", "Disable Interpolation")
local function disableinterp()
    if interpol_enable:get() then
        cvars.cl_interpolate:set_int(0)
    else
        cvars.cl_interpolate:set_int(1)
    end
end

local function are_have_weapon(ent)
    if not ent:is_alive() or not ent:get_active_weapon() then return end
    local t_cur_wep = ent:get_active_weapon():get_class_name()
    return t_cur_wep ~= "CKnife" and t_cur_wep ~= "CC4" and t_cur_wep ~= "CMolotovGrenade" and t_cur_wep ~= "CSmokeGrenade" and t_cur_wep ~= "CHEGrenade" and t_cur_wep ~= "CWeaponTaser"
end
local function are_them_visibles(ent)
    local local_p = entity_list:get_local_player()
    local generic_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    local left_arm_pos = ent:get_hitbox_pos(e_hitgroups.LEFT_ARM)
    local right_arm_pos = ent:get_hitbox_pos(e_hitgroups.RIGHT_ARM)
    if local_p:is_point_visible(generic_pos) or local_p:is_point_visible(left_arm_pos) or local_p:is_point_visible(right_arm_pos) then return true else return false end
end
local function strangerdranger(cmd)
    if not enabled:get() then return end
    if ragebot.get_autopeek_pos() then return end
    local enemies = entity_list.get_players(true)
    for i,v in ipairs(enemies) do
        if are_them_visibles(v) and are_have_weapon(v) then
            exploits.force_uncharge()
            exploits.block_recharge()
        else
            exploits.allow_recharge()
        end
    end
end
menu.set_group_column("metamethod > Warmup", 1) -- place in left column
menu.set_group_column("metamethod > Ragebot", 1) -- place in left column
menu.set_group_column("metamethod > Settings", 2) -- place in right column
enabled = menu.add_checkbox("metamethod > Ragebot", "Teleport In Air", 1)
callbacks.add(e_callbacks.SETUP_COMMAND, strangerdranger)

local ffi_handler = {}
local tag_changer = {}
local ui = {}
local master_switch_settings = menu.add_checkbox("metamethod > Settings", "Master Switch")
ui.is_enabled = menu.add_checkbox("metamethod > Settings", "Clantag Spammer", false)
local render_c = {}
local trashtalk_enabled = menu.add_checkbox("metamethod > Settings", "Trashtalk")
function render_c.get_multitext_width(font, tbl)
    local width = 0

    for key, value in pairs(tbl) do
        if (font == nil) then
            return
        end

        width = width + render.get_text_size(font, tostring(value.text)).x
    end

    return width
end

--- @param: font: font
--- @param: vec_start: vec2_t
--- @param: tbl: table
--- @param: alpha: number
--- @return: void
function render_c.multitext(font, vec_start, tbl, alpha)
    if (vec_start == nil and type(vec_start) ~= "userdata") then
        return
    end

    if (alpha == nil) then
        alpha = 1
    end

    local x, y = vec_start.x, vec_start.y

    for key, value in pairs(tbl) do
        if (font == nil) then
            return
        end

        value.centered = value.centered or false
        value.color = value.color or color_t(255, 255, 255, 255)

        if (value.alpha ~= nil) then
            render.push_alpha_modifier(value.alpha)
            render.text(font, tostring(value.text), vec2_t(x, y), value.color)
            render.pop_alpha_modifier()
        else
            render.text(font, tostring(value.text), vec2_t(x, y), value.color)
        end

        x = x + render.get_text_size(font, value.text).x
    end
end
local font1 = render.create_font("Verdana", 12, 42, e_font_flags.ANTIALIAS)
local font = render.create_font("Verdana", 12, 42)
local master_switch_visuals = menu.add_checkbox("metamethod > Visuals", "Master Switch")
local ind_enable = menu.add_checkbox("metamethod > Visuals", "Crosshair Indicators")
local sleeve_enabled = menu.add_checkbox("metamethod > Visuals", "Remove Sleeve")
local engine_client = ffi.cast(ffi.typeof("void***"), memory.create_interface("engine.dll", "VEngineClient014"))
local console_is_visible = ffi.cast("console_is_visible", engine_client[0][11])

local enabled_c = menu.add_checkbox("metamethod > Visuals", "Custom Console Color")
local recolor_console = enabled_c:add_color_picker("Console Color")

local console_materials = { "vgui_white", "vgui/hud/800corner1", "vgui/hud/800corner2", "vgui/hud/800corner3", "vgui/hud/800corner4" }
local found_materials = {}

materials.for_each(function(mat)
    for material = 1, #console_materials do
        if ( string.match( mat:get_name( ), console_materials[material] )) then
            found_materials[material] = mat
        end
    end
end)

local function on_paint()
    if not engine.is_app_active() then 
        return 
    end

    local console_color = recolor_console:get()
    for material = 1, #found_materials do
        mat = found_materials[material]

        if enabled_c:get() and console_is_visible(engine_client) then
            mat:color_modulate(console_color.r/255, console_color.g/255, console_color.b/255)
            mat:alpha_modulate(console_color.a/255)
        else
            mat:color_modulate(1, 1, 1)
            mat:alpha_modulate(1)
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)

function on_draw_model(ctx)
    if not sleeve_enabled:get() then return end
    if ctx.model_name:find("v_sleeve") == nil then 
       return
    end

    ctx.override_original = true
    
 end
 
 callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)



local variables = {
    keybind = {
        x = menu.add_slider("12", "kb_x", 0, 3000),
        y = menu.add_slider("12", "kb_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        modes = {"[toggled]", "[hold]", "[on]", "[on]","[off]"},
        alpha = 0,
        size = 140,
    },
    spectator = {
        x = menu.add_slider("12", "spec_x", 0, 3840),
        y = menu.add_slider("12", "spec_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        alpha = 0,
        list = {},
        size = 140,
    }
}

local keybindings = {
    ["Double tap"] = menu.find("aimbot","general","exploits","doubletap","enable"),
    ["On shot anti-aim"] = menu.find("aimbot","general","exploits","hideshots","enable"),
    ["Auto peek assist"] = menu.find("aimbot","general","misc","autopeek"),
    ["Duck peek assist"] = menu.find("antiaim","main","general","fake duck"),
    ["Invert anti-aim"] = menu.find("antiaim","main","manual","invert desync"),
    ["Left"] = menu.find("antiaim","main","manual","left"),
    ["Backward"] = menu.find("antiaim","main","manual","back"),
    ["Right"] = menu.find("antiaim","main","manual","right"),
    ["Direction"] = menu.find("antiaim","main","auto direction","enable"),
    ["Edge jump"] = menu.find("misc","main","movement","edge jump"),
    ["Sneak"] = menu.find("misc","main","movement","sneak"),
    ["Edge bug"] = menu.find("misc","main","movement","edge bug helper"),
    ["Jump bug"] = menu.find("misc","main","movement","jump bug"),
    ["Fire extinguisher"] = menu.find("misc","utility","general","fire extinguisher"),
    ["Freecam"] = menu.find("misc","utility","general","freecam"),
}
local widgetz = menu.add_multi_selection("metamethod > Visuals", "Widgets", {"Watermark", "Keybinds", "Spectators", "Info Panel"})
local wtm_colour = widgetz:add_color_picker("Accent")
local ind_colour = ind_enable:add_color_picker("Accent")
client.log_screen(color_t(150, 200, 59),"Welcome to metamethod.lua, "..user.name)
client.log_screen(color_t(255, 255, 0),"Its free version!")

menu.set_group_visibility("12", false)
local function watermark()
    if not widgetz:get(1)  then return end
    local fpss = client.get_fps()
    local tickrate = client.get_tickrate()
    local screensize = render.get_screen_size()
    local h, m, s = client.get_local_time()
    if engine.is_connected() then
    local wtm_string_connected = string.format("primordial.dev  | metamethod.lua | %s | %sfps| %stick | %sms | %02d:%02d:%02d", user.name, fpss, tickrate, math.floor(engine.get_latency(e_latency_flows.INCOMING)), h, m, s)
    local wtm_size = render.get_text_size(font, wtm_string_connected)
    render.rect_filled(vec2_t(screensize.x-wtm_size.x-14, 10), vec2_t(wtm_size.x+8, 2), wtm_colour:get())
        render.rect_filled(vec2_t(screensize.x-wtm_size.x-14, 11), vec2_t(wtm_size.x+8, 16), color_t(13,13,13,110))
    render.text(font, wtm_string_connected, vec2_t(screensize.x-wtm_size.x-10, 13), color_t(255,255,255,255))
else 
     local wtm_string_disconnected = string.format("primordial.dev  | metamethod.lua | %s | %sfps | %02d:%02d:%02d", user.name, fpss, h, m, s)
    local wtm_size = render.get_text_size(font, wtm_string_disconnected)
    render.rect_filled(vec2_t(screensize.x-wtm_size.x-14, 10), vec2_t(wtm_size.x+8, 2), wtm_colour:get())
        render.rect_filled(vec2_t(screensize.x-wtm_size.x-14, 11), vec2_t(wtm_size.x+8, 16), color_t(13,13,13,110))
    render.text(font, wtm_string_disconnected, vec2_t(screensize.x-wtm_size.x-10, 13), color_t(255,255,255,255))
end
end


local function keybinds()
    if not widgetz:get(2) or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.keybind.show or menu.is_open() then
        variables.keybind.alpha = variables.keybind.alpha > 254 and 255 or variables.keybind.alpha + 10
    else
        variables.keybind.alpha = variables.keybind.alpha < 1 and 0 or variables.keybind.alpha - 10
    end
    render.push_alpha_modifier(variables.keybind.alpha/255)
    render.rect_filled(vec2_t(variables.keybind.x:get(), variables.keybind.y:get()+9), vec2_t(variables.keybind.size, 2), wtm_colour:get())
        render.rect_filled(vec2_t(variables.keybind.x:get(), variables.keybind.y:get()+10), vec2_t(variables.keybind.size, 16), color_t(13,13,13,110))
    render.text(font, "keybinds", vec2_t(variables.keybind.x:get()+variables.keybind.size/2, variables.keybind.y:get()+18), color_t(255,255,255,255), true)
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(variables.keybind.x:get()-20,variables.keybind.y:get()-20),vec2_t(variables.keybind.x:get()+160,variables.keybind.y:get()+48)) then
        if not hasoffset then
            variables.keybind.offsetx = variables.keybind.x:get()-mousepos.x
            variables.keybind.offsety = variables.keybind.y:get()-mousepos.y
            hasoffset = true
        end
        variables.keybind.x:set(mousepos.x + variables.keybind.offsetx)
        variables.keybind.y:set(mousepos.y + variables.keybind.offsety)
    else
        hasoffset = false
    end
    
    offset = 1

    for i, v in pairs(keybindings) do
        local dap = v[2]
        if dap:get() then
            render.text(font, i, vec2_t(variables.keybind.x:get()+2, variables.keybind.y:get()+18+(12*offset)), color_t(255,255,255,255))
            local itssize = render.get_text_size(font, variables.keybind.modes[dap:get_mode()+1])
            render.text(font, variables.keybind.modes[dap:get_mode()+1], vec2_t(variables.keybind.x:get()+variables.keybind.size-2-itssize.x, variables.keybind.y:get()+18+(12*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
    end

    variables.keybind.show = offset > 1
end

local function spectators()
    if not widgetz:get(3) or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.spectator.show or menu.is_open() then
        variables.spectator.alpha = variables.spectator.alpha > 254 and 255 or variables.spectator.alpha + 25
    else
        variables.spectator.alpha = variables.spectator.alpha < 1 and 0 or variables.spectator.alpha - 25
    end
    render.push_alpha_modifier(variables.spectator.alpha/255)
    render.rect_filled(vec2_t(variables.spectator.x:get(), variables.spectator.y:get()+9), vec2_t(variables.spectator.size, 2), wtm_colour:get())
        render.rect_filled(vec2_t(variables.spectator.x:get(), variables.spectator.y:get()+10), vec2_t(variables.spectator.size, 16), color_t(13,13,13,110))
    render.text(font, "spectators", vec2_t(variables.spectator.x:get()+variables.spectator.size/2, variables.spectator.y:get()+18), color_t(255,255,255,255), true)
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(variables.spectator.x:get()-20,variables.spectator.y:get()-20),vec2_t(variables.spectator.x:get()+160,variables.spectator.y:get()+48)) then
        if not hasoffsetspec then
            variables.spectator.offsetx = variables.spectator.x:get()-mousepos.x
            variables.spectator.offsety = variables.spectator.y:get()-mousepos.y
            hasoffsetspec = true
        end
        variables.spectator.x:set(mousepos.x + variables.spectator.offsetx)
        variables.spectator.y:set(mousepos.y + variables.spectator.offsety)
    else
        hasoffsetspec = false
    end
    offset = 1

    curspec = 1

    local local_player = entity_list.get_local_player_or_spectating()

    local players = entity_list.get_players()

    if not players then return end

    for i,v in pairs(players) do
        if not v then return end
        if v:is_alive() or v:is_dormant() then goto skip end
        local playername = v:get_name()
        if playername == "<blank>" then goto skip end
        local observing = entity_list.get_entity(v:get_prop("m_hObserverTarget"))
        if not observing then goto skip end
        if observing:get_index() == local_player:get_index() then
            local size = render.get_text_size(font, playername)
            variables.spectator.size = size.x/2
            render.text(font, playername, vec2_t(variables.spectator.x:get()+2, variables.spectator.y:get()+18+(12*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
        ::skip::
    end

    if variables.spectator.size < 140 then variables.spectator.size = 140 end

    for i = 1, #variables.spectator.list do
        render.text(font, variables.spectator.list[i], vec2_t(variables.spectator.x:get()+2, variables.spectator.y:get()+18+(12*offset)), color_t(255,255,255,255))
        offset = offset + 1
    end

    variables.spectator.show = offset > 1
end

callbacks.add(e_callbacks.PAINT, function()
    watermark(); keybinds(); spectators()
end)

callbacks.add(e_callbacks.DRAW_WATERMARK, function() return"" end)

--Made By ! Reload#0001

local pixel = render.create_font("Smallest Pixel-7", 10, 20, e_font_flags.OUTLINE)

--binds
local isFD = menu.find("antiaim", "general", "fake duck", "enable") -- get fakeduck
local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") -- get doubletap
local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") -- get hideshots
local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") -- get autopeek
local isSW = menu.find("misc","main","movement","slow walk", "enable") -- get Slow Walk
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
local isBA = menu.find("aimbot", "scout", "target overrides", "force hitbox", "enable")
local isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint", "enable")
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
    if not ind_enable:get() then return end
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
        invert ="RIGHT"
    else
        invert ="LEFT"
    end

    --screen size
    local ay = 40
    local alpha = math.min(math.floor(math.sin((global_vars.real_time()%3) * 4) * 175 + 20), 255)
    if local_player:is_alive() then -- check if player is alive
    --render
    local eternal_ts = render.get_text_size(pixel, "METHODIC ")
    render.text(pixel, "METHODIC ", vec2_t(x/2, y/2+ay), ind_colour:get(), 10, true)
    ay = ay + 10.5
    
    local text_ =""
    local clr0 = color_t(0, 0, 0, 0)
    if isSW[2]:get() then
        text_ ="DANGEROUS "
        clr0 = color_t(255, 50, 50, 255)
    else
        text_ ="DYNAMIC "
        clr0 = color_t(255, 117, 107, 255)
    end

    local d_ts = render.get_text_size(pixel, text_)
    render.text(pixel, text_, vec2_t(x/2, y/2+ay), clr0, 10, true)
    ay = ay + 10.5
    
    render.text(pixel, invert, vec2_t(x/2, y/2+ay), color_t(250, 255, 150, 255), 10, true)
    ay = ay + 10.5

    local asadsa = math.min(math.floor(math.sin((exploits.get_charge()%2) * 1) * 122), 255)
    if isAP[2]:get() and isDT[2]:get() then 
        local ts_tick = render.get_text_size(pixel, "IDEALTICK ")
        render.text(pixel, "IDEALTICK", vec2_t(x/2, y/2+ay), color_t(255, 230, 200, 255), 10, true)
    
        ay = ay + 10.5
    else
        if isAP[2]:get() then
            render.text(pixel, "PEEK", vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
        if isDT[2]:get() then
        if exploits.get_charge() >= 1 then
            render.text(pixel, "DT", vec2_t(x/2, y/2+ay), color_t(0, 255, 0, 255), 10, true)
            ay = ay + 10.5
        end
        if exploits.get_charge() < 1 then
            render.text(pixel, "DT", vec2_t(x/2, y/2+ay), color_t(255, 0, 0, 255), 10, true)
            ay = ay + 10.5
        end
    end
    end
    if getweapon() == "ssg08" then
        if min_damage_s[2]:get() then
            render.text(pixel, "DAMAGE: "..tostring(amount_scout:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "deagle" then
        if min_damage_d[2]:get() then
            render.text(pixel, "DAMAGE: "..tostring(amount_deagle:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "revolver" then
        if min_damage_r[2]:get() then
            render.text(pixel, "DAMAGE: "..tostring(amount_revolver:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "awp" then
        if min_damage_awp[2]:get() then
            render.text(pixel, "DAMAGE: "..tostring(amount_awp:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
        if min_damage_a[2]:get() then
            render.text(pixel, "DAMAGE: "..tostring(amount_auto:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
        if min_damage_p[2]:get() then
            render.text(pixel, "DAMAGE: "..tostring(amount_pistol:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
    end

    local ax = 0
    if isHS[2]:get() then
        render.text(pixel, "ONSHOT", vec2_t(x/2, y/2+ay), color_t(250, 173, 181, 255), 10, true)
        ay = ay + 10.5
    end
end
end


--callback
callbacks.add(e_callbacks.PAINT,indicators2)



local logs = {}
local fonts = nil
local hl_enabled = menu.add_checkbox("metamethod > Visuals", "Hitlogs", false)
local fontSelection = menu.add_selection("metamethod > Visuals", "Style", {"Default", "Bold"})
        local wtm_colour1 = hl_enabled:add_color_picker("Accent")


local function onPaint()
  if not hl_enabled:get() then return end
    if(fonts == nil) then
        fonts =
        {
            regular = render.create_font("Verdana", 12, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW);
            bold = render.create_font("Verdana Bold", 12, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW);
        }
    end

    if (engine.is_connected() ~= true) then
        return
    end

    local time = global_vars.frame_time()

    local screenSize = render.get_screen_size()
    local screenWidth = screenSize.x
    local screenHeight = screenSize.y

    for i = 1, #logs do
        local log = logs[i]
        if log == nil then goto continue
        end
        local x = screenWidth / 2
        local y = screenHeight / 1.25 + (i * 15)
        local alpha = 0

        if (log.state == 'appearing') then
            -- Fade in.
            local progress = log.currentTime / log.lifeTime.fadeIn
            x = x - Lerp(log.offset, 0, Ease(progress))
            alpha = Lerp(0, 255, Ease(progress))

            log.currentTime = log.currentTime + time
            if (log.currentTime >= log.lifeTime.fadeIn) then
                log.state = 'visible'

                -- Reset time.
                log.currentTime = 0
            end


        elseif(log.state == 'visible') then
        -- Fully opaque.
        alpha = 255

        log.currentTime = log.currentTime + time
        if (log.currentTime >= log.lifeTime.visible) then
            log.state = 'disappearing'

            -- Reset Time.
            log.currentTime = 0
        end

        elseif(log.state == 'disappearing') then
            -- Fade out.
            local progress = log.currentTime / log.lifeTime.fadeOut
            x = x + Lerp(0, log.offset, Ease(progress))
            alpha = Lerp(255, 0, Ease(progress))

            log.currentTime = log.currentTime + time
            if(log.currentTime >= log.lifeTime.fadeOut) then
                table.remove(logs, i)
                goto continue
            end
        end

        -- Increase the total time.
        log.totalTime = log.totalTime + time
        alpha = math.floor(alpha)
        local white = color_t(236, 236, 236, alpha)
        local accent_color_text, accent_color_color = wtm_colour1
        local detail = wtm_colour1:get()
        detail.a = alpha

        local message = {}

        -- Add header and body to message
        local combined = {}

        for a = 1, #log.header do
            local t = log.header[a]
            table.insert(combined, t)
        end

        for a = 1, #log.body do
            local t = log.body[a]
            table.insert(combined, t)
        end

        for j = 1, #combined do
            local data = combined[j]

            local text = tostring(data[1])
            local color = data[2]

            -- Push the data to the message.
            table.insert(message,{text, color and detail or white})
        end

        -- Add the total lifetime to the message.
        
        -- Draw log.
        local render_font = nil
        if render_font == nil then
        local stringFont = fontSelection:get()
        if stringFont == 2 then render_font = fonts.regular
            else render_font = fonts.bold
            end
        end

        render.string(x, y, message, 'c', render_font)
        ::continue::
    end
end

local hitgroupMap = {
    [0] = 'generic',
    [1] = 'head',
    [2] = 'chest',
    [3] = 'stomach',
    [4] = 'left arm',
    [5] = 'right arm',
    [6] = 'left leg',
    [7] = 'right leg',
    [8] = 'neck',
    [9] = 'gear'
  }

function on_aimbot_hit(hit)
    local name = hit.player:get_name()
    local hitbox = hitgroupMap[hit.hitgroup]
    local damage = hit.damage
    local health = hit.player:get_prop('m_iHealth')

    AddLog('PlayerHitEvent', {
        {'Hit ', false};
        {name .. ' ', true};
        {'in the ', false};
        {hitbox .. ' ', true};
        {'for ', false};
        {damage .. ' ', true};

        {'damage ', false};
{'(' , false};
                {health, true};
        {' health remaining)', false};
    })
end

function on_aimbot_miss(miss)
    local name = miss.player:get_name()
    local hitbox = hitgroupMap[miss.aim_hitgroup]
    local damage = miss.aim_damage
    local health = miss.player:get_prop('m_iHealth')
    local reason = miss.reason_string

    AddLog('PlayerHitEvent', {
        {'Missed ', false};
        {name .. ' ', true};
        {'in the ', false};
        {hitbox .. ' ', true};
        {'due to ', false};
        {reason .. ' ', true};
    })
end

function AddLog(type, body)
    local log = {
        type = type,
        state = 'appearing',
        offset = 250,
        currentTime = 0,
        totalTime = 0,
        lifeTime = {
            fadeIn = 0.75,
            visible = 3,
            fadeOut = 0.75
        },
        header = {
            {' [metamethod] ', true},
        },
        body = body
    }
    table.insert(logs, log)
end

function Lerp(from, to, progress)
    return from + (to - from) * progress
end

function Ease(progress)
    return progress < 0.5 and 15 * progress * progress * progress * progress * progress or 1 - math.pow(-2 * progress + 2, 5) / 2
end

render.string = function(x, y, data, alignment, font)
    -- Get total length for all the data.
    local length = 0
    for i = 1, #data do
        local text = data[i][1]
      
        local size = render.get_text_size(font, text)
        length = length + size.x
    end

    local offset = x
    for i = 1, #data do
        local text = data[i][1]
        local color = data[i][2]

        local sX = offset
        local sY = y

        -- Adjust position based on alignment
        if(alignment) == 'l' then
            sX = offset - length
        elseif(alignment) == 'c' then
            sX = offset - (length / 2)
        elseif(alignment) == 'r' then
            sX = offset
        end



        -- Draw the text.

        render.text(font, text, vec2_t(sX + 1, sY + 1), color_t(16, 16, 16, color.a))
        render.text(font, text, vec2_t(sX, sY), color)

        -- Add the length of the text to the offset.
        local size = render.get_text_size(font, text)
        offset = offset + size.x
    end
end


callbacks.add(e_callbacks.PAINT,onPaint)
callbacks.add(e_callbacks.AIMBOT_MISS,on_aimbot_miss)
callbacks.add(e_callbacks.AIMBOT_HIT,on_aimbot_hit)

local animation_breaker = {}



animation_breaker.anim_breaker = menu.add_multi_selection("metamethod > Settings", "Animation Breaker", {"On Ground", "Static Legs In Air", "Zero Pitch On Land"})

animation_breaker.ground_tick = 1
animation_breaker.end_time = 0
animation_breaker.handle = function (poseparam)
    local localPlayer = entity_list.get_local_player()

    if not localPlayer then
        return
    end

    local flags = localPlayer:get_prop("m_fFlags")
    local on_land = bit.band(flags, bit.lshift(1, 0)) ~= 0
    local is_in_air = bit.band(flags, bit.lshift(1, 0)) == 0

    local curtime = global_vars.cur_time()

    if on_land == true then
        animation_breaker.ground_tick = animation_breaker.ground_tick + 1
    else
        animation_breaker.ground_tick = 0
        animation_breaker.end_time = curtime + 1
    end


    if animation_breaker.anim_breaker:get(1) then
        poseparam:set_render_pose(e_poses.RUN, 1)
    end

    if animation_breaker.anim_breaker:get(2) and is_in_air then
        poseparam:set_render_pose(e_poses.JUMP_FALL, 1)
    end

    if animation_breaker.anim_breaker:get(3) and animation_breaker.ground_tick > 1 and animation_breaker.end_time > curtime then
        poseparam:set_render_pose(e_poses.BODY_PITCH, 0.5)
    end
end

callbacks.add(e_callbacks.ANTIAIM, animation_breaker.handle)

local watermarkz = menu.add_checkbox("metamethod > Settings", "Remove Cheat Watermark")
local function indicators55()
    if not engine.is_connected() then return end
 if not widgetz:get(4)  then return end
local script_type = "- free user"
local screen = render.get_screen_size()
    local text = {
        {text = ("%s "):format(user.name)},
        {text = ("%s"):format(script_type), color = color_t(255,255,255)}
    }

    local player = entity_list.get_local_player()
local avatars = require "Avatars"
    local x, y = 5, screen.y / 2
        local steamID3, steamID64 = player:get_steamids()
            local avatar_size = vec2_t(30, 30)
local avatar = avatars.get(steamID64, 64)
local suffix = " free user"
local script_name = "metamethod.lua"
render.texture(avatar.id, vec2_t(x, y - (avatar_size.y / 2)), avatar_size)
render.text(font, ("%s"):format(script_name), vec2_t(x + avatar_size.x + 3, y - (avatar_size.y / 2)), color_t(255, 255, 255))
render_c.multitext(font, vec2_t(x + avatar_size.x + 3, y), text)
end
callbacks.add(e_callbacks.PAINT,indicators55)

local panorama = require 'primordial/panorama-library.248'
local js = panorama.open()

local delay = {
    tick_delay = client.time_to_ticks(1),
    last_tick = globals.tick_count()
}
local mute_enabled = menu.add_checkbox("metamethod > Settings", "Automatic Unmute")
local selection = menu.add_selection("metamethod > Settings", "Mode", {"Mute", "Unmute"})
local enemy_only =  menu.add_checkbox("metamethod > Settings", "Enemy Only", false)

local function mutePlayers()
    local players = entity_list.get_players(enemy_only:get())
    if players then
        for _, player in pairs(players) do 
            local xuid = js.GameStateAPI.GetPlayerXuidStringFromEntIndex(player:get_index())
            if selection:get() == 1 and js.GameStateAPI.IsSelectedPlayerMuted(xuid) == false then 
                js.GameStateAPI.ToggleMute(xuid)
            elseif selection:get() == 2 and js.GameStateAPI.IsSelectedPlayerMuted(xuid) == true then
                js.GameStateAPI.ToggleMute(xuid)
            end
        end
    end
end

callbacks.add(e_callbacks.PAINT, function()
    if not engine.is_connected() then return end
    if globals.tick_count() - delay.last_tick > delay.tick_delay then
        delay.last_tick = globals.tick_count()
        mutePlayers()
    end
end)

local function on_draw_watermark(watermark_text)

if watermarkz:get() then
    return ""
else

    return 'primordial' .. ' - '..user.name

end

end

callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)



tag_changer.custom_tag = {
    "metamethod",
}


local string_mul = function(text, mul)

    mul = math.floor(mul)

    local to_add = text

    for i = 1, mul-1 do
        text = text .. to_add
    end

    return text
end

ffi_handler.sigs = {}
ffi_handler.sigs.clantag = {"engine.dll", "53 56 57 8B DA 8B F9 FF 15"}
ffi_handler.change_tag_fn = ffi.cast("int(__fastcall*)(const char*, const char*)", memory.find_pattern(unpack(ffi_handler.sigs.clantag)))

tag_changer.last_time_update = -1
tag_changer.update = function(tag)
    local current_tick = global_vars.tick_count()

    if current_tick > tag_changer.last_time_update then
        tag = tostring(tag)
        ffi_handler.change_tag_fn(tag, tag)
        tag_changer.last_time_update = current_tick + 16
    end
end

tag_changer.build_first = function(text)

    local orig_text = text
    local list = {}

    text = string_mul(" ", #text * 2) .. text .. string_mul(" ", #text * 2)

    for i = 1, math.floor(#text / 1.5) do
        local add_text = text:sub(i, (i + math.floor(#orig_text * 2) % #text))

        table.insert(list, add_text .. "\t")
    end

    return list
end

tag_changer.build_second = function(text)
    local builded = {}

    for i = 1, #text do

        local tmp = text:sub(i, #text) .. text:sub(1, i-1)

        if tmp:sub(#tmp) == " " then
            tmp = tmp:sub(1, #tmp-1) .. "\t"
        end

        table.insert(builded, tmp)
    end

    return builded
end


tag_changer.current_build = tag_changer.build_first("metamethod ")
tag_changer.current_tag = "empty_string"

tag_changer.disabled = true
tag_changer.on_paint = function()

    local is_enabled = ui.is_enabled:get()
    if not engine.is_in_game() or not is_enabled then

        if not is_enabled and not tag_changer.disabled then
            ffi_handler.change_tag_fn("", "")
            tag_changer.disabled = true
        end

        tag_changer.last_time_update = -1
        return
    end    

    local ui_tag = "metamethod "
    if ui_tag ~= tag_changer.current_tag then
        tag_changer.current_build = 1 and tag_changer.build_first(ui_tag) or tag_changer.build_second(ui_tag)
    else
          local ui_tag1 = " "
    end

    local tag_speed = 5

    if tag_speed == 0 then
        tag_changer.update(ui_tag)
        return
    end

    local current_tag = math.floor(global_vars.cur_time() * tag_speed % #tag_changer.current_build) + 1
    current_tag = tag_changer.current_build[current_tag]

    tag_changer.disabled = false
    tag_changer.update(current_tag)
end

callbacks.add(e_callbacks.PAINT, tag_changer.on_paint)

local killsays = {
   "завалился петушара ебаный",
     "))",
    "улетаешь малыха",
    "омагад ботиха",
        "охайо!",
                "парни купил гранту люкс поддержанную норм?",
    "я люблю разных сучек",
        "твои яйца откушены пузатый",
        "я был приятно удивлен при игре с этим скриптом!",
        "vot eto vantap",
            "техасхук емае",
                "примо донт нид апдеит)",
    "нл донт нид апдеит)",
    "[metamethod system] Missed shot due to spread сука паста",
    "убил из-за fipp cfg",
    "эй малышка у тебя слишком классная стрижка",
    "metamethod - better solution",
    "играю с метой и курю ашкудишку",
    "primordial dont need update",
    "чернобыль говно кстати",
    "тутутуту тутутутут изи)",
    "хуйпасоус завален)",
    "чунгук отмирает)",
    "шнюк ссаныи",
    "БАЙ МЕТАМЕТОД ЛУА СУЧКАА",
        "я твою мать доской с гвоздями ебашил жирбос",
            "neverlegend#2478 - buy metamethod.lua",
                        "твоя жизнь это ирония",
                "В чёрных масках мы дырявим этот Rover",
   "shoppy.gg/@Akkov1337",
   "с позором моча бля",
      "сколько блядей я ебал в оружейной",
      "Сценарий моей жизни - получил платину",
      "+35, но все равно холод",
      "Курим со Смоки на студийной сессии",
"gamesense.pub/forums/profile.php?id=555 слыш не твой юид?",
    'за сабкой и кфг @fipp1337',
    "держи зонтик ☂, тебя обоссали",
    "𝕠𝕨𝕟𝕖𝕕 𝕓𝕪 𝕘𝕠𝕕𝕖𝕝𝕖𝕤𝕤 𝕜𝕚𝕕",
    "by rod9 хуесос)",
}

local start_random = 0
local function on_event(event)
    if not trashtalk_enabled:get() then return end
    local lp = entity_list.get_local_player()
    ::generate::
    local random = killsays[math.random(#killsays)]
    if (random == start_random) then
        goto generate
    end
    local kill_cmd = 'say ' .. random
    if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end --checking if the killer is us
    engine.execute_cmd(kill_cmd)
    start_random = random
end

callbacks.add(e_callbacks.EVENT, on_event, "player_death")

 local   master_switch_warmup             = menu.add_checkbox("metamethod > Warmup", "Master Switch", false)
  local  localserver_configure         = menu.add_button("metamethod > Warmup", "Configurate Server", function() engine.execute_cmd("sv_cheats 1; mp_do_warmup_offine 1; mp_warmuptime 14881488; mp_warmup_pausetimer 1;  mp_warmup_start; sv_infinite_ammo 1; mp_limitteams 16; mp_autoteambalance 0; bot_kick; god; sv_airaccelerate 80; bot_stop 1") end)
  local  localserver_bottext           = menu.add_text("metamethod > Warmup", "Bots")
  local localserver_botaddct          = menu.add_button("metamethod > Warmup", "Add CT Bot", function() engine.execute_cmd("bot_add_ct;") end)
  local  localserver_botaddt           = menu.add_button("metamethod > Warmup", "Add T Bot", function() engine.execute_cmd("bot_add_t;") end)
  local  localserver_botkick           = menu.add_button("metamethod > Warmup", "Kick All Bots", function() engine.execute_cmd("bot_kick;") end)

local function handle_menu(reset)
    if reset == false then
     --hitlogs
        fontSelection:set_visible(false)

        
       if hl_enabled:get() then
        fontSelection:set_visible(true)
       end

       if fontSelection:get() == 10  then
       end
--mute
enemy_only:set_visible(false)
selection:set_visible(false)

if mute_enabled:get() then 
enemy_only:set_visible(true)
selection:set_visible(true)
end


    mute_enabled:set_visible(false)
watermarkz:set_visible(false)
    animation_breaker.anim_breaker:set_visible(false)
    trashtalk_enabled:set_visible(false)
ui.is_enabled:set_visible(false)
if master_switch_settings:get() then 
    ui.is_enabled:set_visible(true)
    trashtalk_enabled:set_visible(true)
    animation_breaker.anim_breaker:set_visible(true)
    watermarkz:set_visible(true)
    mute_enabled:set_visible(true)
end
 enabled_c:set_visible(false)
hl_enabled:set_visible(false)
widgetz:set_visible(false)
sleeve_enabled:set_visible(false)
ind_enable:set_visible(false)
if master_switch_visuals:get() then 
    sleeve_enabled:set_visible(true)
    enabled_c:set_visible(true)
ind_enable:set_visible(true)
widgetz:set_visible(true)
hl_enabled:set_visible(true)
end

    localserver_configure:set_visible(false)
localserver_bottext:set_visible(false)
localserver_botaddct:set_visible(false)
localserver_botaddt:set_visible(false)
localserver_botkick:set_visible(false)

if master_switch_warmup:get() then 
    localserver_configure:set_visible(true)
localserver_bottext:set_visible(true)
localserver_botaddct:set_visible(true)
localserver_botaddt:set_visible(true)
localserver_botkick:set_visible(true)

end
    end
end

local slider = fasterrecharge_enable:get()

function on_paint()
    handle_menu(false)
end

callbacks.add(e_callbacks.PAINT, on_paint)

local function handle_menu(reset)
    if reset == false then
--mute
enabled:set_visible(false)

if master_switch_ragebot:get() then 
enabled:set_visible(true)
end

--ragebot master switch
  fasterrecharge_enable:set_visible(false)
  interpol_enable:set_visible(false)
     if master_switch_ragebot:get() then 
            fasterrecharge_enable:set_visible(true)
              interpol_enable:set_visible(true)

        end
end
end

local slider = fasterrecharge_enable:get()

function on_paint()
    handle_menu(false)
end

callbacks.add(e_callbacks.PAINT, on_paint)