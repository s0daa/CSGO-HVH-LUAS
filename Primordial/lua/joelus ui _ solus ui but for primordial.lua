--[[
       $$$$$\  $$$$$$\  $$$$$$$$\ $$\      $$\   $$\  $$$$$$\        $$\   $$\ $$$$$$\                 
       \__$$ |$$  __$$\ $$  _____|$$ |     $$ |  $$ |$$  __$$\       $$ |  $$ |\_$$  _|         $$\    
          $$ |$$ /  $$ |$$ |      $$ |     $$ |  $$ |$$ /  \__|      $$ |  $$ |  $$ |           $$ |   
          $$ |$$ |  $$ |$$$$$\    $$ |     $$ |  $$ |\$$$$$$\        $$ |  $$ |  $$ |        $$$$$$$$\ 
    $$\   $$ |$$ |  $$ |$$  __|   $$ |     $$ |  $$ | \____$$\       $$ |  $$ |  $$ |        \__$$  __|
    $$ |  $$ |$$ |  $$ |$$ |      $$ |     $$ |  $$ |$$\   $$ |      $$ |  $$ |  $$ |           $$ |   
    \$$$$$$  | $$$$$$  |$$$$$$$$\ $$$$$$$$\\$$$$$$  |\$$$$$$  |      \$$$$$$  |$$$$$$\          \__|   
     \______/  \______/ \________|\________|\______/  \______/        \______/ \______|                
                                                                                                   
     JOELUS UI CERTIFIED SCRIPT BY SLXYX MARY BARROW | UID 95 BIIIIIITCH (◣_◢)                                                                                            
                                                                                                   
]]--

local variables = {
    keybind = {
        x = menu.add_slider("joelus ui | hidden", "kb_x", 0, 3840),
        y = menu.add_slider("joelus ui | hidden", "kb_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        modes = {"[toggled]", "[held]", "[on]", "[on]","[off]"},
        alpha = 0,
        size = 140,
    },
    spectator = {
        x = menu.add_slider("joelus ui | hidden", "spec_x", 0, 3840),
        y = menu.add_slider("joelus ui | hidden", "spec_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        alpha = 0,
        list = {},
        size = 140,
    }
}

local keybindings = {
    ["double tap"] = menu.find("aimbot","general","exploits","doubletap","enable"),
    ["hide shots"] = menu.find("aimbot","general","exploits","hideshots","enable"),
    ["auto peek"] = menu.find("aimbot","general","misc","autopeek"),
    ["fake duck"] = menu.find("antiaim","main","general","fake duck"),
    ["invert"] = menu.find("antiaim","main","manual","invert desync"),
    ["manual left"] = menu.find("antiaim","main","manual","left"),
    ["manual back"] = menu.find("antiaim","main","manual","back"),
    ["manual right"] = menu.find("antiaim","main","manual","right"),
    ["auto direction"] = menu.find("antiaim","main","auto direction","enable"),
    ["edge jump"] = menu.find("misc","main","movement","edge jump"),
    ["sneak"] = menu.find("misc","main","movement","sneak"),
    ["edge bug"] = menu.find("misc","main","movement","edge bug helper"),
    ["jump bug"] = menu.find("misc","main","movement","jump bug"),
    ["fire extinguisher"] = menu.find("misc","utility","general","fire extinguisher"),
    ["freecam"] = menu.find("misc","utility","general","freecam"),
}

local wtm_enable = menu.add_checkbox("joelus ui | watermark", "watermark")
local wtm_colour = wtm_enable:add_color_picker("watermark colour")

local keybind_enable = menu.add_checkbox("joelus ui | keybinds", "keybinds")
local keybind_colour = keybind_enable:add_color_picker("keybinds colour")

local spectator_enable = menu.add_checkbox("joelus ui | spectators", "spectators")
local spectator_colour = spectator_enable:add_color_picker("spectators colour")

local box_style = menu.add_selection("joelus ui | style", "box style", {"default solus", "rounded corners"})

menu.set_group_visibility("joelus ui | hidden", false)

local font = render.create_font("Verdana", 12, 24, e_font_flags.ANTIALIAS)

local function watermark()
    if not wtm_enable:get() then return end
    local screensize = render.get_screen_size()
    local h, m, s = client.get_local_time()
    local wtm_string = string.format("primordial | %s [%s] | %s ms | %s tick | %02d:%02d:%02d", user.name, user.uid, math.floor(engine.get_latency(e_latency_flows.INCOMING)), client.get_tickrate(), h, m, s)
    local wtm_size = render.get_text_size(font, wtm_string)
    render.rect_filled(vec2_t(screensize.x-wtm_size.x-14, 19), vec2_t(wtm_size.x+8, 1), wtm_colour:get())
    if box_style:get() == 1 then
        render.rect_filled(vec2_t(screensize.x-wtm_size.x-14, 20), vec2_t(wtm_size.x+8, 16), color_t(13,13,13,110))
    else
        render.push_clip(vec2_t(screensize.x-6, 19), vec2_t(10, 7))
        render.progress_circle(vec2_t.new(screensize.x-11, 23), 6, wtm_colour:get(), 1, 1)
        render.pop_clip()
        render.push_clip(vec2_t(screensize.x-wtm_size.x-22, 19), vec2_t(12, 7))
        render.progress_circle(vec2_t.new(screensize.x-wtm_size.x-10, 23), 6, wtm_colour:get(), 1, 1)
        render.pop_clip()
    end
    render.text(font, wtm_string, vec2_t(screensize.x-wtm_size.x-10, 21), color_t(255,255,255,255))
end

local function keybinds()
    if not keybind_enable:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.keybind.show or menu.is_open() then
        variables.keybind.alpha = variables.keybind.alpha > 254 and 255 or variables.keybind.alpha + 10
    else
        variables.keybind.alpha = variables.keybind.alpha < 1 and 0 or variables.keybind.alpha - 10
    end
    render.push_alpha_modifier(variables.keybind.alpha/255)
    render.rect_filled(vec2_t(variables.keybind.x:get(), variables.keybind.y:get()+9), vec2_t(variables.keybind.size, 1), keybind_colour:get())
    if box_style:get() == 1 then
        render.rect_filled(vec2_t(variables.keybind.x:get(), variables.keybind.y:get()+10), vec2_t(variables.keybind.size, 16), color_t(13,13,13,110))
    else
        render.push_clip(vec2_t(variables.keybind.x:get()+variables.keybind.size-2, variables.keybind.y:get()+9), vec2_t(10, 7))
        render.progress_circle(vec2_t.new(variables.keybind.x:get()+variables.keybind.size-3, variables.keybind.y:get()+14), 6, keybind_colour:get(), 1, 1)
        render.pop_clip()
        render.push_clip(vec2_t(variables.keybind.x:get()-10, variables.keybind.y:get()+9), vec2_t(12, 7))
        render.progress_circle(vec2_t.new(variables.keybind.x:get()+2, variables.keybind.y:get()+14), 6, keybind_colour:get(), 1, 1)
        render.pop_clip()
    end
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
    if not spectator_enable:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.spectator.show or menu.is_open() then
        variables.spectator.alpha = variables.spectator.alpha > 254 and 255 or variables.spectator.alpha + 25
    else
        variables.spectator.alpha = variables.spectator.alpha < 1 and 0 or variables.spectator.alpha - 25
    end
    render.push_alpha_modifier(variables.spectator.alpha/255)
    render.rect_filled(vec2_t(variables.spectator.x:get(), variables.spectator.y:get()+9), vec2_t(variables.spectator.size, 1), spectator_colour:get())
    if box_style:get() == 1 then
        render.rect_filled(vec2_t(variables.spectator.x:get(), variables.spectator.y:get()+10), vec2_t(variables.spectator.size, 16), color_t(13,13,13,110))
    else
        render.push_clip(vec2_t(variables.spectator.x:get()+variables.spectator.size-2, variables.spectator.y:get()+9), vec2_t(10, 7))
        render.progress_circle(vec2_t.new(variables.spectator.x:get()+variables.spectator.size-3, variables.spectator.y:get()+14), 6, spectator_colour:get(), 1, 1)
        render.pop_clip()
        render.push_clip(vec2_t(variables.spectator.x:get()-10, variables.spectator.y:get()+9), vec2_t(12, 7))
        render.progress_circle(vec2_t.new(variables.spectator.x:get()+2, variables.spectator.y:get()+14), 6, spectator_colour:get(), 1, 1)
        render.pop_clip()
    end
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