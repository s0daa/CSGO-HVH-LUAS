--// Meant as a "project" to pass some time they're not perfect and will likely never be. Codes terrible, could be improved by a long shot but I'm bored as fuck writing these so I decided to release them.
local variables = {
    main_font = render.create_font("Segoe Ui", 13, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
}

local math_funcs = { --// Dk who this func is from was given it by a homie B), I store it like this bc it doesn't need to take up space in my editor.
    fadeInOut = function ()
        return math.floor(math.sin(math.abs((math.pi * -1) + (global_vars.cur_time() * 1.5) % (math.pi * 2))) * 255);
    end,
    get_min_dmg = function (wpn_type) --// thnx classy.
        local menu_ref = menu.find("aimbot",wpn_type,"target overrides","force min. damage")
        local force_lethal = menu.find("aimbot",wpn_type,"target overrides","force lethal shot")
        local hitbox_ovr = menu.find("aimbot",wpn_type,"target overrides","force hitbox")
        local force_sp = menu.find("aimbot",wpn_type,"target overrides","force safepoint")
        local force_hc = menu.find("aimbot",wpn_type,"target overrides","force hitchance")
        return {menu_ref[1]:get(), menu_ref[2]:get(), force_lethal[2]:get(), hitbox_ovr[2]:get(), force_sp[2]:get(), force_hc[2]:get()}
    end,
    get_screen_center = function ()
        local x,y = render.get_screen_size().x / 2, render.get_screen_size().y / 2
        return {x,y}
    end 
}

local references = {
    aimbot = {
        double_tap = menu.find('aimbot', 'general', 'exploits', 'doubletap', 'enable'),
        hideshots = menu.find('aimbot', 'general', 'exploits', 'hideshots', 'enable'),
    },
    antiaim = {
        pitch = menu.find('antiaim', 'main', 'angles', 'pitch'),
        yaw_base = menu.find('antiaim', 'main', 'angles', 'yaw base'),
        yaw_add = menu.find('antiaim', 'main', 'angles', 'yaw add'),
        rotate = menu.find('antiaim', 'main', 'angles', 'rotate'),
        jitter_mode = menu.find('antiaim', 'main', 'angles', 'jitter mode'),
        jitter_add = menu.find('antiaim', 'main', 'angles', 'jitter add'),
        body_lean = menu.find('antiaim', 'main', 'angles', 'body lean'),
    }

}

local groups = {
    ['auto'] = 0,
    ['scout'] = 1,
    ['awp'] = 2, 
    ['heavy pistols'] = 3, 
    ['pistols'] = 4, 
    ['other'] = 5, 
}

local current_min = nil
local key_active = nil
local force_lethal = nil
local hitbox_ovr = nil
local force_sp = nil
local force_hc = nil
local indicators = menu.add_checkbox('Indicators', 'Enable', true)
local indicator_selection = menu.add_multi_selection('Indicators', 'Indicator selection', {'Desync bar', 'Double tap', 'FL', 'Min damage ovr.', 'Hide shots', 'Logo', 'Auto Peek', 'Force Lethal', 'Hitbox ovr.', 'Force Safepoint', 'Hitchance ovr.'})
local height_slider = menu.add_slider('Indicators', 'Height',0, 100)
local colorpicker = indicators:add_color_picker('Indicator Color Picker', color_t(110, 181, 255, 255))
local autopeek = menu.find('aimbot', 'general', 'misc', 'autopeek')

local function get_weapon_group() --// Classy also did a func like this, might be better not sure.
    for key, value in pairs(groups) do
        if value == ragebot.get_active_cfg() then
            current_min = math_funcs.get_min_dmg(key)[1];
            key_active = math_funcs.get_min_dmg(key)[2];
            force_lethal = math_funcs.get_min_dmg(key)[3];
            hitbox_ovr = math_funcs.get_min_dmg(key)[4];
            force_sp = math_funcs.get_min_dmg(key)[5];
            force_hc = math_funcs.get_min_dmg(key)[6];
        end
    end

    return {tostring(current_min), key_active, force_lethal, hitbox_ovr, force_sp, force_hc};
end

local function draw_indicators() --// Code very bad, don't look here unless you wanna go blind B).
    if (not entity_list.get_local_player() or not entity_list.get_local_player():is_alive() or not indicators:get()) then
        return;
    end

    local l = 0
    local bar_color = color_t(colorpicker:get().r, colorpicker:get().g, colorpicker:get().b)
    local bar_color_alpha = color_t(colorpicker:get().r, colorpicker:get().g, colorpicker:get().b, colorpicker:get().a)
    local fadeinout = color_t(colorpicker:get().r, colorpicker:get().g, colorpicker:get().b, math_funcs.fadeInOut())
    local get_choked_cmds = engine.get_choked_commands()

    if (indicator_selection:get('Logo')) then
        render.text(variables.main_font, 'Another AA Script', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), fadeinout, true)
        l = l + 1
    end

    if (indicator_selection:get('Desync bar')) then
        render.rect_fade(vec2_t(math_funcs.get_screen_center()[1] - antiaim.get_max_desync_range(), math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), vec2_t(antiaim.get_max_desync_range(), 3), bar_color_alpha, bar_color, true)
        render.rect_fade(vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), vec2_t(antiaim.get_max_desync_range(), 3), bar_color, bar_color_alpha, true)
        l = l + 1
    end

    if (indicator_selection:get('Min damage ovr.') and get_weapon_group()[2]) then
        render.text(variables.main_font, get_weapon_group()[1], vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('FL') and get_choked_cmds >= 4 and not references.aimbot.double_tap[2]:get() and not references.aimbot.hideshots[2]:get()) then
        render.text(variables.main_font, 'FL', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    elseif (indicator_selection:get('FL') and get_choked_cmds <= 4 and not references.aimbot.double_tap[2]:get() and not references.aimbot.hideshots[2]:get()) then --// Really bad way of checking if "breaking" LC, would be done better if I had the knowledge on how to do it B)
        render.text(variables.main_font, 'FL', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), color_t(255, 0, 0), true)
        l = l + 1
    end

    if (indicator_selection:get('Hide shots') and references.aimbot.hideshots[2]:get() and not references.aimbot.double_tap[2]:get()) then
        render.text(variables.main_font, 'HS', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('Double tap') and exploits.get_charge() >= 14 and references.aimbot.double_tap[2]:get()) then
        render.text(variables.main_font, 'DT', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('Auto Peek') and autopeek[2]:get()) then
        render.text(variables.main_font, 'AP', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('Force Lethal') and get_weapon_group()[3]) then
        render.text(variables.main_font, 'LETHAL', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('Hitbox ovr.') and get_weapon_group()[4]) then
        render.text(variables.main_font, 'HB', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('Force Safepoint') and get_weapon_group()[5]) then
        render.text(variables.main_font, 'SP', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('Hitchance ovr.') and get_weapon_group()[6]) then
        render.text(variables.main_font, 'HC', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end
end

local function on_paint()
    if (indicators:get()) then
        draw_indicators()
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)