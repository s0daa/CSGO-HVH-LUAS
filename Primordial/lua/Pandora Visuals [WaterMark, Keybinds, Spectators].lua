local pixel = render.create_font("Smallest Pixel-7", 10, 20, e_font_flags.OUTLINE)
local wtf_font = render.create_font("Verdana", 12, 300, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local verdana = render.create_font("Verdana", 12, 300, e_font_flags.DROPSHADOW)

local keybindings = {
    ["Double Tap"] = menu.find("aimbot","general","exploits","doubletap","enable"),
    ["Hide Shots"] = menu.find("aimbot","general","exploits","hideshots","enable"),
    ["AutoPeek"] = menu.find("aimbot","general","misc","autopeek"),
    ["Fake Duck"] = menu.find("antiaim","main","general","fake duck"),
    ["Inverter"] = menu.find("antiaim","main","manual","invert desync"),
    ["Slow Walk"] = menu.find("misc","main","movement","slow walk"),
    ["Fake Ping"] = menu.find("aimbot","general", "fake ping","enable"),
    ["Auto Direction"] = menu.find("antiaim","main","auto direction","enable"),
    ["Edge Jump"] = menu.find("misc","main","movement","edge jump"),
    ["Sneak"] = menu.find("misc","main","movement","sneak"),
    ["Edge Bug"] = menu.find("misc","main","movement","edge bug helper"),
    ["Jump Bug"] = menu.find("misc","main","movement","jump bug"),
    ["Fire Extinguisher"] = menu.find("misc","utility","general","fire extinguisher"),
    ["Min. Damage"] = menu.find("aimbot", "auto", "target overrides", "force min. damage"),
}


local accent_color = select(2, unpack(menu.find("misc", "main", "config", "accent color")))
local background_color_fade = color_t(41, 41, 41, 50)
local background_color = color_t(41, 41, 41, 255)
local title_color = color_t(255, 255, 255, 255)
local text_color = color_t(155, 155, 155, 255)
local idle_color = color_t(35, 35, 35, 255)
local function easeInQuad(x)
    return x * x
end

local lua_menu = {
    
    Colortxt = menu.add_text("DEBUG", "Accent Color"),

    wtm_enable = menu.add_checkbox("DEBUG", "WaterMark"),
    keybind_enable = menu.add_checkbox("DEBUG", "Keybinds"),
    spectator_enable = menu.add_checkbox("DEBUG", "Spectators"),
    
}
font1 = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
font2 = render.create_font("Small Fonts", 8, 550, e_font_flags.DROPSHADOW)
local color_acc = lua_menu.Colortxt:add_color_picker("MainColor", color_t(64, 155, 246,255), true)
local variables = {
    keybind = {
        x = menu.add_slider("MANAGEMENT", "keyX", 0, 3840),
        y = menu.add_slider("MANAGEMENT", "keyY", 0, 2160),
        offsetx = 0,
        offsety = 0,
        modes = {"[toggled]", "[hold]", "[on]", "[on]","[off]"},
        alpha = 0,
        size = 160,
    },
    spectator = {
        x = menu.add_slider("MANAGEMENT", "specX", 0, 3840),
        y = menu.add_slider("MANAGEMENT", "specY", 0, 2160),
        offsetx = 0,
        offsety = 0,
        alpha = 0,
        list = {},
        size = 140,
    }
}

local screensize = render.get_screen_size()
local currentTime = global_vars.cur_time
local colors = {
    white = color_t(255, 255, 255),
    red   = color_t(255, 0, 0),
    green   = color_t(0, 255, 0),
    gray  = color_t(100, 100, 100)
}

-- watermark
local function watermark()
    if not lua_menu.wtm_enable:get() then return end
    local screensize = render.get_screen_size()
    local h, m, s = client.get_local_time()
    local color =  color_acc:get()
    local text1 = string.format("primordial.dev")
    local wtm_size1 = render.get_text_size(wtf_font, text1)
    local text2 = string.format(" / %s ",user.name)
    local wtm_size2 = render.get_text_size(wtf_font, text2)
    local text3 = string.format("%s ms ",  math.floor(engine.get_latency(e_latency_flows.INCOMING)))
    local wtm_size3 = render.get_text_size(wtf_font, text3)
    local text4 = string.format("%02d:%02d ",  h, m)
    local wtm_size4 = render.get_text_size(wtf_font, text4)
    local text5 = "time"
    local wtm_string = string.format("primordial.dev / %s %dms %02d:%02d time", user.name, math.floor(engine.get_latency(e_latency_flows.INCOMING)), h, m, s)
    local wtm_size = render.get_text_size(wtf_font, wtm_string)
    local wtm_allsize = screensize.x-wtm_size.x

    render.rect_filled(vec2_t(screensize.x-wtm_size.x-18, 8), vec2_t(wtm_size.x+14, 24), color_t(41,41,41,255), 3)
    render.rect_filled(vec2_t(screensize.x-wtm_size.x-16, 10), vec2_t(wtm_size.x+10, 20), color_t(0,0,0,255), 3)
    render.rect(vec2_t(screensize.x-wtm_size.x-19, 7), vec2_t(wtm_size.x+15, 25), color_t(0,0,0,255), 3)

    render.text(wtf_font, text1, vec2_t(screensize.x-wtm_size.x-12, 13), color)
    render.text(wtf_font, text2, vec2_t(screensize.x-wtm_size.x+wtm_size1.x-12, 13), color_t(97,97,97,255))
    render.text(wtf_font, text3, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x-12, 13), color)
    render.text(wtf_font, text4, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x-12, 13), color)
    render.text(wtf_font, text5, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x+wtm_size4.x-12, 13), color_t(97,97,97,255))
end

-- keybinds
local function keybinds()
    if not lua_menu.keybind_enable:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.keybind.show or menu.is_open() then
        variables.keybind.alpha = variables.keybind.alpha > 254 and 255 or variables.keybind.alpha + 15
    else
        variables.keybind.alpha = variables.keybind.alpha < 1 and 0 or variables.keybind.alpha - 15
    end
   
    render.push_alpha_modifier(variables.keybind.alpha/255)

    render.rect_filled(vec2_t(variables.keybind.x:get()- 2, variables.keybind.y:get()+8), vec2_t(variables.keybind.size+4, 24), color_t(41,41,41,255), 3)
    render.rect_filled(vec2_t(variables.keybind.x:get(), variables.keybind.y:get()+10), vec2_t(variables.keybind.size, 20), color_t(0,0,0,255), 3)
    render.rect(vec2_t(variables.keybind.x:get() - 3, variables.keybind.y:get()+7), vec2_t(variables.keybind.size+5, 25), color_t(0,0,0,255), 3)

    render.text(wtf_font, "keybinds", vec2_t(variables.keybind.x:get()+variables.keybind.size/2, variables.keybind.y:get()+20), color_acc:get(), true)
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
            render.text(wtf_font, i, vec2_t(variables.keybind.x:get()+2, variables.keybind.y:get()+22+(13*offset)), color_t(255,255,255,255))
            local itssize = render.get_text_size(wtf_font, variables.keybind.modes[dap:get_mode()+1])
            render.text(wtf_font, variables.keybind.modes[dap:get_mode()+1], vec2_t(variables.keybind.x:get()+variables.keybind.size-2-itssize.x, variables.keybind.y:get()+22+(13*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
    end

    variables.keybind.show = offset > 1
end

-- spectators
local function spectators()
    if not lua_menu.spectator_enable:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.spectator.show or menu.is_open() then
        variables.spectator.alpha = variables.spectator.alpha > 254 and 255 or variables.spectator.alpha + 15
    else
        variables.spectator.alpha = variables.spectator.alpha < 1 and 0 or variables.spectator.alpha - 15
    end
    render.push_alpha_modifier(variables.spectator.alpha/255)
    render.rect_filled(vec2_t(variables.spectator.x:get()- 2, variables.spectator.y:get()+8), vec2_t(variables.spectator.size+4, 24), color_t(41,41,41,255), 3)
    render.rect_filled(vec2_t(variables.spectator.x:get(), variables.spectator.y:get()+10), vec2_t(variables.spectator.size, 20), color_t(0,0,0,255), 3)
    render.rect(vec2_t(variables.spectator.x:get() - 3, variables.spectator.y:get()+7), vec2_t(variables.spectator.size+5, 25), color_t(0,0,0,255), 3)

    render.text(wtf_font, "spectators", vec2_t(variables.spectator.x:get()+variables.spectator.size/2, variables.spectator.y:get()+20), color_acc:get(), true)

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
            local size = render.get_text_size(wtf_font, playername)
            variables.spectator.size = size.x/2
            render.text(verdana, playername, vec2_t(variables.spectator.x:get()+2, variables.spectator.y:get()+22+(12*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
        ::skip::
    end

    if variables.spectator.size < 140 then variables.spectator.size = 140 end

    for i = 1, #variables.spectator.list do
        render.text(verdana, variables.spectator.list[i], vec2_t(variables.spectator.x:get()+2, variables.spectator.y:get()+22+(12*offset)), color_t(255,255,255,255))
        offset = offset + 1
    end

    variables.spectator.show = offset > 1
end

function on_paint()
    watermark()
    keybinds()
    spectators()

    local local_player = entity_list.get_local_player()
    if not local_player then return end

end

callbacks.add(e_callbacks.PAINT, on_paint)