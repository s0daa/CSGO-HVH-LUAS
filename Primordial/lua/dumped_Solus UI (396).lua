local menu_text, menu_select, menu_slider, checkbox, button = menu.add_text, menu.add_selection, menu.add_slider, menu.add_checkbox, menu.add_button

local chernobyl_ui = {}
chernobyl_ui.enable_key = checkbox("Solus UI", "Enable Keybinds", false)
chernobyl_ui.enable_spec = checkbox("Solus UI", "Enable Spectator List", false)
chernobyl_ui.enable_water = checkbox("Solus UI", "Enable Watermark", false)
chernobyl_ui.enable_box = checkbox("Solus UI", "Enable Info Box", false)
chernobyl_ui.text = menu_text("Solus UI", "Color")
chernobyl_ui.colour = chernobyl_ui.text:add_color_picker("Solus ui colour")

function render.rect_fade_round_box(start_pos, end_pos, start_color, end_color, width, round)
    render.rect_filled(vec2_t(start_pos.x, start_pos.y), vec2_t(end_pos.x, end_pos.y), color_t(34,34,34, 130), round)
    render.rect_fade(vec2_t.new(start_pos.x + round, start_pos.y), vec2_t.new(end_pos.x - round * 2, end_pos.y - end_pos.y + width), start_color, end_color, true)
    render.rect_fade(vec2_t.new(start_pos.x, start_pos.y + round), vec2_t.new(start_pos.x - start_pos.x + width, end_pos.y - round * 2), color_t.new(start_color.r, start_color.g, start_color.b, start_color.a), color_t.new(end_color.r, end_color.g, end_color.b, math.floor(end_color.a / 5)), false)
    render.rect_fade(vec2_t.new(start_pos.x + end_pos.x - width, start_pos.y + round), vec2_t.new(end_pos.x - end_pos.x + width, end_pos.y - round * 2), color_t.new(end_color.r, end_color.g, end_color.b, end_color.a), color_t.new(start_color.r, start_color.g, start_color.b, math.floor(start_color.a / 5)), false)
    render.rect_fade(vec2_t.new(start_pos.x + round, start_pos.y + end_pos.y - width), vec2_t.new(end_pos.x - round * 2, start_pos.y - start_pos.y + width), color_t.new(end_color.r, end_color.g, end_color.b, math.floor(end_color.a / 5)), color_t.new(start_color.r, start_color.g, start_color.b, math.floor(start_color.a / 5)), true)
    if round ~= 0 and width ~= 0 then
        render.push_clip(vec2_t.new(start_pos.x + end_pos.x - round, start_pos.y + end_pos.y - round), vec2_t.new(round, round))
        render.progress_circle(vec2_t.new(start_pos.x + end_pos.x - round, start_pos.y + end_pos.y - round), round - width, color_t.new(start_color.r, start_color.g, start_color.b, math.floor(start_color.a / 50)), width, 1)
        render.pop_clip()
        render.push_clip(vec2_t.new(start_pos.x + end_pos.x - round, start_pos.y + round - round), vec2_t.new(round, round))
        render.progress_circle(vec2_t.new(start_pos.x + end_pos.x - round, start_pos.y + round - 1), round - width, color_t.new(end_color.r, end_color.g, end_color.b, end_color.a), width, 1)
        render.pop_clip()
        render.push_clip(vec2_t.new(start_pos.x + round - round, start_pos.y + end_pos.y - round), vec2_t.new(round, round))
        render.progress_circle(vec2_t.new(start_pos.x + round - 1, start_pos.y + end_pos.y - round), round - width, color_t.new(end_color.r, end_color.g, end_color.b, math.floor(end_color.a / 50)), width, 1)
        render.pop_clip()
        render.push_clip(vec2_t.new(start_pos.x + round - round, start_pos.y + round - round), vec2_t.new(round, round))
        render.progress_circle(vec2_t.new(start_pos.x + round - 1, start_pos.y + round - 1), round - width, color_t.new(start_color.r, start_color.g, start_color.b, start_color.a), width, 1)
        render.pop_clip()
    end
end

local variables = {
    keybind = {
        x = menu.add_slider("Solus ui | hidden", "kb_x", 0, render.get_screen_size().x - 10),
        y = menu.add_slider("Solus ui | hidden", "kb_y", 0, render.get_screen_size().y - 10),
        offsetx = 0,
        offsety = 0,
        modes = {"[toggled]", "[hold]", "[on]", "[on]","[off]"},
        alpha = 0,
        size = 140,
    },
    spectator = {
        x = menu.add_slider("Solus ui | hidden", "spec_x", 0, render.get_screen_size().x - 10),
        y = menu.add_slider("Solus ui | hidden", "spec_y", 0, render.get_screen_size().y - 10),
        offsetx = 0,
        offsety = 0,
        alpha = 0,
        list = {},
        size = 140,
    },
}

local variables1 = {
    water = {
        x = menu.add_slider("Solus ui | hidden", "s_x", 247, render.get_screen_size().x - 10),
        y = menu.add_slider("Solus ui | hidden", "s_y", 0, render.get_screen_size().y - 10),
        offsetx = 0,
        offsety = 0,
        alpha = 0,
        size = 1,
        show = true
    },
}

local drag = {
    box = {
        x = menu.add_slider("Solus ui | hidden", "b_x", 0, render.get_screen_size().x - 10),
        y = menu.add_slider("Solus ui | hidden", "b_y", 0, render.get_screen_size().y - 10),
        offsetx = 0,
        offsety = 0,
        alpha = 0,
        list = {},
        size = 175,
    },
}

--@Solus ui
local draw = {}

function lerp(a, b, p)
    return a+(b-a)*p
end

function draw.string(font, text, pos, color)
    render.text(font, text, pos, color)
end

function draw.triangle_filled(pos, size, color, rotation) 
    render.triangle_filled(pos, size, color, rotation)
end

function draw.rect(pos, size, color)
    render.rect(pos, size, color)
end

function dragging(x, y, size, hasoffset, offsetx, offsety, mos_x, mos_y)
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(x:get()-20,y:get()-20),size) then
        if not hasoffset then
            offsetx = x:get()-mos_x
            offsety = y:get()-mos_y
            hasoffsetspec = true
        end
        x:set(mos_x + offsetx)
        y:set(mos_y + offsety)
    else
        hasoffset = false
    end
end

local keybindings = {
    dt = menu.find("aimbot","general","exploits","doubletap","enable"),
    hs = menu.find("aimbot","general","exploits","hideshots","enable"),
    md_a = menu.find("aimbot", "auto", "target overrides", "force min. damage"),
    md_s = menu.find("aimbot", "scout", "target overrides", "force min. damage"),
    md_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage"),
    md_aw = menu.find("aimbot", "awp", "target overrides", "force min. damage"),
    lean_r = menu.find("aimbot", "general", "aimbot", "body lean resolver"),
    ap = menu.find("aimbot","general","misc","autopeek"),
    fd = menu.find("antiaim","main","general","fake duck"),
    inv = menu.find("antiaim","main","manual","invert desync"),
    ad = menu.find("antiaim","main","auto direction","enable"),
    ej = menu.find("misc","main","movement","edge jump"),
    jb = menu.find("misc","main","movement","jump bug"),
}

local font = render.create_font("Verdana", 12, 24, e_font_flags.ANTIALIAS)
local font1 = render.create_font("Verdana", 15, 24, e_font_flags.ANTIALIAS)
menu.set_group_visibility("Solus ui | hidden", false)

local add_y_key = 0
local speed = 20
local speed1 = 20
local open_key = 0
local dt_key = 0
local hs_key = 0
local md_key = 0
local lean_key = 0
local ap_key = 0
local fd_key = 0
local inv_key = 0
local ad_key = 0
local ej_key = 0

local function keybinds()
    if not chernobyl_ui.enable_key:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if keybindings.dt[2]:get() or keybindings.hs[2]:get() or keybindings.md_a[2]:get() or keybindings.md_s[2]:get() or keybindings.md_p[2]:get() or keybindings.md_aw[2]:get() or keybindings.lean_r[2]:get() or keybindings.ap[2]:get() or keybindings.fd[2]:get() or keybindings.inv[2]:get() or keybindings.ad[2]:get() or keybindings.ej[2]:get() or keybindings.jb[2]:get() then
        variables.keybind.show = true
    else
        variables.keybind.show = false
    end
    if variables.keybind.show or menu.is_open() then if variables.keybind.alpha < 255 then if variables.keybind.alpha < 255 then variables.keybind.alpha = lerp(variables.keybind.alpha, 255, speed*global_vars.frame_time()) else variables.keybind.alpha = 255 end end else if variables.keybind.alpha > 1 then variables.keybind.alpha = lerp(variables.keybind.alpha, 0, speed/2*global_vars.frame_time()) else variables.keybind.alpha = 0 end end
    local delta_open = variables.keybind.alpha/255
    render.push_alpha_modifier(variables.keybind.alpha/255)
    render.rect_fade_round_box(vec2_t.new(variables.keybind.x:get() + 1 + 20 - delta_open*20, variables.keybind.y:get() + 10), vec2_t.new(variables.keybind.size - 2 - 40 + delta_open*40, 17), chernobyl_ui.colour:get(), chernobyl_ui.colour:get(), 1, 4)
    render.text(font, "keybinds", vec2_t(variables.keybind.x:get()+variables.keybind.size/2, variables.keybind.y:get()+18), color_t(255,255,255,255), true)
    if keybindings.dt[2]:get() then if dt_key < 255 then if dt_key < 255 then dt_key = lerp(dt_key, 255, speed1*global_vars.frame_time()) else dt_key = 255 end end else if dt_key > 1 then dt_key = lerp(dt_key, 0, speed1/2*global_vars.frame_time()) else dt_key = 0 end end
    render.push_alpha_modifier(dt_key/255)
    draw.string(font, "Double Tap", vec2_t(variables.keybind.x:get() + 5 + 20 - delta_open*20, variables.keybind.y:get() + 30), color_t(255,255,255))
    local itssize_dt = render.get_text_size(font, variables.keybind.modes[keybindings.dt[2]:get_mode()+1])
    draw.string(font, variables.keybind.modes[keybindings.dt[2]:get_mode()+1], vec2_t(variables.keybind.x:get() - 20 + delta_open*20 + variables.keybind.size-2-itssize_dt.x, variables.keybind.y:get() + 30), color_t(255,255,255,255))
    render.pop_alpha_modifier()
    local delta_dt = dt_key/255
    if keybindings.hs[2]:get() then if hs_key < 255 then if hs_key < 255 then hs_key = lerp(hs_key, 255, speed1*global_vars.frame_time()) else hs_key = 255 end end else if hs_key > 1 then hs_key = lerp(hs_key, 0, speed1/2*global_vars.frame_time()) else hs_key = 0 end end
    render.push_alpha_modifier(hs_key/255)
    draw.string(font, "Hide Shots", vec2_t(variables.keybind.x:get() + 5 + 20 - delta_open*20, variables.keybind.y:get() + 30 + delta_dt*14), color_t(255,255,255))
    local itssize_hs = render.get_text_size(font, variables.keybind.modes[keybindings.dt[2]:get_mode()+1])
    draw.string(font, variables.keybind.modes[keybindings.hs[2]:get_mode()+1], vec2_t(variables.keybind.x:get() - 20 + delta_open*20 + variables.keybind.size-2-itssize_dt.x, variables.keybind.y:get() + 30 + delta_dt*14), color_t(255,255,255,255))
    render.pop_alpha_modifier()
    local delta_hs = hs_key/255
    local delta1 = delta_hs*14 + delta_dt*14
    if keybindings.md_a[2]:get() or keybindings.md_s[2]:get() or keybindings.md_p[2]:get() or keybindings.md_aw[2]:get() then if md_key < 255 then if md_key < 255 then md_key = lerp(md_key, 255, speed1*global_vars.frame_time()) else md_key = 255 end end else if md_key > 1 then md_key = lerp(md_key, 0, speed1/2*global_vars.frame_time()) else md_key = 0 end end
    render.push_alpha_modifier(md_key/255)
    draw.string(font, "Min. Damage", vec2_t(variables.keybind.x:get() + 5 + 20 - delta_open*20, variables.keybind.y:get() + 30 + delta1), color_t(255,255,255))
    local itssize_dm = render.get_text_size(font, variables.keybind.modes[keybindings.md_s[2]:get_mode()+1])
    draw.string(font, variables.keybind.modes[keybindings.md_s[2]:get_mode()+1], vec2_t(variables.keybind.x:get() - 20 + delta_open*20 + variables.keybind.size-2-itssize_dm.x, variables.keybind.y:get() + 30 + delta1), color_t(255,255,255,255))
    render.pop_alpha_modifier()
    local delta_dmg = md_key/255
    local delta2 = delta1 + delta_dmg * 12
    if keybindings.lean_r[2]:get() then if lean_key < 255 then if lean_key < 255 then lean_key = lerp(lean_key, 255, speed1*global_vars.frame_time()) else lean_key = 255 end end else if lean_key > 1 then lean_key = lerp(lean_key, 0, speed1/2*global_vars.frame_time()) else lean_key = 0 end end
    render.push_alpha_modifier(lean_key/255)
    draw.string(font, "Lean Resolver", vec2_t(variables.keybind.x:get() + 5 + 20 - delta_open*20, variables.keybind.y:get() + 30 + delta2), color_t(255,255,255))
    local itssize_lean = render.get_text_size(font, variables.keybind.modes[keybindings.lean_r[2]:get_mode()+1])
    draw.string(font, variables.keybind.modes[keybindings.lean_r[2]:get_mode()+1], vec2_t(variables.keybind.x:get() - 20 + delta_open*20 + variables.keybind.size-2-itssize_lean.x, variables.keybind.y:get() + 30 + delta2), color_t(255,255,255,255))
    render.pop_alpha_modifier()
    local delta_lean = lean_key/255
    local delta3 = delta2 + delta_lean * 12
    if keybindings.ap[2]:get() then if ap_key < 255 then if ap_key < 255 then ap_key = lerp(ap_key, 255, speed1*global_vars.frame_time()) else ap_key = 255 end end
    else if ap_key > 1 then ap_key = lerp(ap_key, 0, speed1/2*global_vars.frame_time()) else ap_key = 0 end end
    render.push_alpha_modifier(ap_key/255)
    draw.string(font, "Auto Peek", vec2_t(variables.keybind.x:get() + 5 + 20 - delta_open*20, variables.keybind.y:get() + 30 + delta3), color_t(255,255,255))
    local itssize_ap = render.get_text_size(font, variables.keybind.modes[keybindings.ap[2]:get_mode()+1])
    draw.string(font, variables.keybind.modes[keybindings.ap[2]:get_mode()+1], vec2_t(variables.keybind.x:get() - 20 + delta_open*20 + variables.keybind.size-2-itssize_ap.x, variables.keybind.y:get() + 30 + delta3), color_t(255,255,255,255))
    render.pop_alpha_modifier()
    local delta_ap = ap_key/255
    local delta4 = delta3 + delta_ap * 12
    if keybindings.fd[2]:get() then if fd_key < 255 then if fd_key < 255 then fd_key = lerp(fd_key, 255, speed1*global_vars.frame_time()) else fd_key = 255 end end else if fd_key > 1 then fd_key = lerp(fd_key, 0, speed1/2*global_vars.frame_time()) else fd_key = 0 end end
    render.push_alpha_modifier(fd_key/255)
    draw.string(font, "Fake Duck", vec2_t(variables.keybind.x:get() + 5 + 20 - delta_open*20, variables.keybind.y:get() + 30 + delta4), color_t(255,255,255))
    local itssize_fd = render.get_text_size(font, variables.keybind.modes[keybindings.fd[2]:get_mode()+1])
    draw.string(font, variables.keybind.modes[keybindings.fd[2]:get_mode()+1], vec2_t(variables.keybind.x:get() - 20 + delta_open*20 + variables.keybind.size-2-itssize_fd.x, variables.keybind.y:get() + 30 + delta4), color_t(255,255,255,255))
    render.pop_alpha_modifier()
    local delta_fd = fd_key/255
    local delta5 = delta4 + delta_fd * 12
    if keybindings.inv[2]:get() then if inv_key < 255 then if inv_key < 255 then inv_key = lerp(inv_key, 255, speed1*global_vars.frame_time()) else inv_key = 255 end end else if inv_key > 1 then inv_key = lerp(inv_key, 0, speed1/2*global_vars.frame_time()) else inv_key = 0 end end
    render.push_alpha_modifier(inv_key/255)
    draw.string(font, "Inverter", vec2_t(variables.keybind.x:get() + 5 + 20 - delta_open*20, variables.keybind.y:get() + 30 + delta5), color_t(255,255,255))
    local itssize_inv = render.get_text_size(font, variables.keybind.modes[keybindings.inv[2]:get_mode()+1])
    draw.string(font, variables.keybind.modes[keybindings.inv[2]:get_mode()+1], vec2_t(variables.keybind.x:get() - 20 + delta_open*20 + variables.keybind.size-2-itssize_inv.x, variables.keybind.y:get() + 30 + delta5), color_t(255,255,255,255))
    render.pop_alpha_modifier()
    local delta_inv = inv_key/255
    local delta6 = delta5 + delta_inv * 12
    if keybindings.ad[2]:get() then if ad_key < 255 then if ad_key < 255 then ad_key = lerp(ad_key, 255, speed1*global_vars.frame_time()) else ad_key = 255 end end else if ad_key > 1 then ad_key = lerp(ad_key, 0, speed1/2*global_vars.frame_time()) else ad_key = 0 end end
    render.push_alpha_modifier(ad_key/255)
    draw.string(font, "Auto Direction", vec2_t(variables.keybind.x:get() + 5 + 20 - delta_open*20, variables.keybind.y:get() + 30 + delta6), color_t(255,255,255))
    local itssize_ad = render.get_text_size(font, variables.keybind.modes[keybindings.ad[2]:get_mode()+1])
    draw.string(font, variables.keybind.modes[keybindings.ad[2]:get_mode()+1], vec2_t(variables.keybind.x:get() - 20 + delta_open*20 + variables.keybind.size-2-itssize_ad.x, variables.keybind.y:get() + 30 + delta6), color_t(255,255,255,255))
    render.pop_alpha_modifier()
    local delta_ad = ad_key/255
    local delta7 = delta6 + delta_ad * 12
    if keybindings.ej[2]:get() then if ej_key < 255 then if ej_key < 255 then ej_key = lerp(ej_key, 255, speed1*global_vars.frame_time()) else ej_key = 255 end end else if ej_key > 1 then ej_key = lerp(ej_key, 0, speed1/2*global_vars.frame_time()) else ej_key = 0 end end
    render.push_alpha_modifier(ej_key/255)
    draw.string(font, "Edge Jump", vec2_t(variables.keybind.x:get() + 5 + 20 - delta_open*20, variables.keybind.y:get() + 30 + delta6), color_t(255,255,255))
    local itssize_ad = render.get_text_size(font, variables.keybind.modes[keybindings.ej[2]:get_mode()+1])
    draw.string(font, variables.keybind.modes[keybindings.ej[2]:get_mode()+1], vec2_t(variables.keybind.x:get() - 20 + delta_open*20 + variables.keybind.size-2-itssize_ad.x, variables.keybind.y:get() + 30 + delta6), color_t(255,255,255,255))
    render.pop_alpha_modifier()
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(variables.keybind.x:get()-20,variables.keybind.y:get()-20),vec2_t(160,48)) then
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
end

function get_table_length( table )
    length = 0

    for _ in pairs( table ) do
        length = length + 1
    end

    return length
end

local function spectators()
    if entity_list.get_local_player() == nil then return end
    if entity_list.get_local_player():get_prop("m_iHealth") < 0 then return end
    if not chernobyl_ui.enable_spec:get() then return end
    local mousepos = input.get_mouse_pos()
    if variables.spectator.show or menu.is_open() then if variables.spectator.alpha < 255 then if variables.spectator.alpha < 255 then variables.spectator.alpha = lerp(variables.spectator.alpha, 255, speed*global_vars.frame_time()) else variables.spectator.alpha = 255 end end else if variables.spectator.alpha > 1 then variables.spectator.alpha = lerp(variables.spectator.alpha, 0, speed/2*global_vars.frame_time()) else variables.spectator.alpha = 0 end end
    local delta_spec = variables.spectator.alpha/255
    render.push_alpha_modifier(variables.spectator.alpha/255)
    render.rect_fade_round_box(vec2_t.new(variables.spectator.x:get() + 1 + 20 - delta_spec*20, variables.spectator.y:get() + 10), vec2_t.new(variables.spectator.size -2 - 40 + delta_spec*40, 17), chernobyl_ui.colour:get(), chernobyl_ui.colour:get(), 1, 4)
    draw.string(font, "spectators", vec2_t(variables.spectator.x:get()+variables.spectator.size/2 - render.get_text_size(font, "spectators").x/2, variables.spectator.y:get()+12), color_t(255,255,255,255))
    dragging(variables.spectator.x, variables.spectator.y, vec2_t(160,50), hasoffsetspec, variables.spectator.offsetx, variables.spectator.offsety, mousepos.x, mousepos.y)
    offset = 1
    curspec = 1

    spectatorss = { }
    cur_spec_index = 2
    for _, player in pairs( entity_list.get_players( ) ) do
        if player == nil then return end
        local local_player = entity_list.get_local_player()
        if player:get_prop("m_iHealth") < 0 or player:is_dormant( ) then
            goto continue
        end
        ret = player:get_prop( "m_hObserverTarget" )
        if ret == nil then return end
        observer_target = entity_list.get_entity( player:get_prop( "m_hObserverTarget" ) )
        if observer_target == nil then return end
        if observer_target ~= local_player then
            goto continue
        end
        spectatorss[ cur_spec_index ] = player:get_name( )
        cur_spec_index = cur_spec_index + 1
        ::continue::
    end

    height = 11 * get_table_length(spectatorss)

    for i, spectator in pairs(spectatorss) do
        offset = offset + 1
        spectator_size = render.get_text_size(font, spectator)
        render.text(font, spectator, vec2_t(variables.spectator.x:get()+2 + 20 - delta_spec*20, variables.spectator.y:get()+5+(12*i)), color_t( 255, 255, 255))
    end
    variables.spectator.show = offset > 1
end

local function watermark()
    if entity_list.get_local_player() == nil then return end
    if not chernobyl_ui.enable_water:get() then return end
    local screensize = render.get_screen_size()
    local h, m, s = client.get_local_time()
    local wtm_string = string.format("primordial.dev | %s | %s ms | %s tick | %02d:%02d:%02d", user.name, math.floor(engine.get_latency()*1000+0.5), client.get_tickrate(), h, m, s)
    local wtm_size = render.get_text_size(font, wtm_string)
    local wtm_minus = render.get_text_size(font, user.name) + wtm_size
    local mousepos = input.get_mouse_pos()
    if variables1.water.show then variables1.water.alpha = variables1.water.alpha > 254 and 255 or variables1.water.alpha + 10 else variables1.water.alpha = variables1.water.alpha < 1 and 0 or variables1.water.alpha - 10 end
    render.push_alpha_modifier(variables1.water.alpha/255)
    render.rect_fade_round_box(vec2_t.new(variables1.water.x:get() + 1 - wtm_minus.x, variables1.water.y:get() + 10), vec2_t.new(render.get_text_size(font, wtm_string).x + 10, 17), chernobyl_ui.colour:get(), chernobyl_ui.colour:get(), 1, 4)
    draw.string(font, wtm_string, vec2_t(variables1.water.x:get()+7 - wtm_minus.x, variables1.water.y:get()+12), color_t(255,255,255,255))
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(variables1.water.x:get()-230,variables1.water.y:get()-20),vec2_t(260,48)) then
        if not hasoffsetsp then
            variables1.water.offsetx = variables1.water.x:get()-mousepos.x
            variables1.water.offsety = variables1.water.y:get()-mousepos.y
            hasoffsetsp = true
        end
        variables1.water.x:set(mousepos.x + variables1.water.offsetx)
        variables1.water.y:set(mousepos.y + variables1.water.offsety)
    else
        hasoffsetsp = false
    end
end

local function box()
    local alpha = math.floor(math.sin(math.abs(-math.pi + (global_vars.cur_time() * (1 / .9)) % (math.pi * 2))) * 255)
    if not chernobyl_ui.enable_box:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    drag.box.show = true
    if drag.box.show then if drag.box.alpha < 255 then if drag.box.alpha < 255 then drag.box.alpha = lerp(drag.box.alpha, 255, speed*global_vars.frame_time()) else drag.box.alpha = 255 end end else if drag.box.alpha > 1 then drag.box.alpha = lerp(drag.box.alpha, 0, speed/2*global_vars.frame_time()) else drag.box.alpha = 0 end end
    render.push_alpha_modifier(alpha/255)
    render.rect_fade_round_box(vec2_t.new(drag.box.x:get() + 1, drag.box.y:get() + 10), vec2_t.new(drag.box.size -2, 41), chernobyl_ui.colour:get(), chernobyl_ui.colour:get(), 1, 4)
    render.pop_alpha_modifier()
    render.push_alpha_modifier(drag.box.alpha/255)
    draw.string(font1, "»", vec2_t(drag.box.x:get() + render.get_text_size(font, ">>").x - 7, drag.box.y:get()+15 - 3), color_t(255,255,255,255))
    draw.string(font, "primordial anti aim technology", vec2_t(drag.box.x:get() + render.get_text_size(font, ">>").x + 5, drag.box.y:get()+13), color_t(255,255,255,255))
    draw.string(font1, "»", vec2_t(drag.box.x:get() + render.get_text_size(font, ">>").x - 7, drag.box.y:get()+26 - 3), color_t(255,255,255,255))
    draw.string(font, "user: " .. user.name, vec2_t(drag.box.x:get() + render.get_text_size(font, ">>").x + 5, drag.box.y:get()+24), color_t(255,255,255,255))
    draw.string(font1, "»", vec2_t(drag.box.x:get() + render.get_text_size(font, ">>").x - 7, drag.box.y:get()+37 - 3), color_t(255,255,255,255))
    draw.string(font, "build: beta", vec2_t(drag.box.x:get() + render.get_text_size(font, ">>").x + 5, drag.box.y:get()+35), color_t(255,255,255,255))
    dragging(drag.box.x, drag.box.y, vec2_t(160,50), hasoffsetspec, drag.box.offsetx, drag.box.offsety, mousepos.x, mousepos.y)
end

callbacks.add(e_callbacks.PAINT, function()
    keybinds()
    spectators()
    watermark()
    box()
end)