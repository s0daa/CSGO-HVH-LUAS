local indicators = menu.add_multi_selection("Indicators", "indicators", {"DoubleTap", "Safe Point", "Baim", "Lethal","Min DMG", "Hide Shots", "FakeDuck", "Fake-Lag", "Fake"})
local amgis = menu.add_checkbox("Shoppy Text", "Main Switch")
local shoppyinput = menu.add_text_input("Shoppy Text", "Shoppy Name")
local screen_size = render.get_screen_size()
local font = render.create_font("Calibri Bold", 27, 670, e_font_flags.ANTIALIAS)
local color2 = color_t(255, 255, 255, 255)
local color3 = color_t(255, 0, 0, 255)
local col_1 = color_t(0, 0, 0, 150)
local col_2 = color_t(0, 0, 0, 0)
local fontsigma = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS)

local groups = {
    auto = {0},
    scout = {1},
    awp = {2},
    heavypistols = {3},
    pistols = {4},
    other = {5}
}

local math_funcs = { -- Thanks to LosKitten1 https://primordial.dev/resources/another-indicator-lua.107/

    get_min_dmg = function(wpn_type) -- // thnx classy.
        local menu_ref = menu.find("aimbot", wpn_type, "target overrides", "force min. damage")
        local force_lethal = menu.find("aimbot", wpn_type, "target overrides", "force lethal shot")
        local hitbox_ovr = menu.find("aimbot", wpn_type, "target overrides", "force hitbox")
        local force_sp = menu.find("aimbot", wpn_type, "target overrides", "force safepoint")
        local force_hc = menu.find("aimbot", wpn_type, "target overrides", "force hitchance")
        return {menu_ref[1]:get(), menu_ref[2]:get(), force_lethal[2]:get(), hitbox_ovr[2]:get(), force_sp[2]:get(),
                force_hc[2]:get()}
    end,
    vars = {
        angle = 0
    }
}

local function calcs()
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end
    if not local_player:is_alive() then
        math_funcs.vars.angle = 0

    else
        math_funcs.vars.angle = antiaim.get_max_desync_range()
    end
end

callbacks.add(e_callbacks.ANTIAIM, calcs)

local groups = {
    ['auto'] = 0,
    ['scout'] = 1,
    ['awp'] = 2,
    ['heavy pistols'] = 3,
    ['pistols'] = 4,
    ['other'] = 5
}
local current_min = nil
local key_active = nil
local force_lethal = nil
local hitbox_ovr = nil
local force_sp = nil
local force_hc = nil

local function get_weapon_group() -- // Classy also did a func like this, might be better not sure.
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
local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")

local function gradient(x, y, w, h, col1, col2)
    render.rect_fade(vec2_t(x, y - 4), vec2_t(w / 4, h), col2, col1, true)
    render.rect_fade(vec2_t(x + (w / 4), y - 4), vec2_t(w / 4, h), col1, col2, true)
end

local function dnn()
    local maxdes = math_funcs.vars.angle
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end
    if not local_player:is_alive() then
        return
    end
    
    local pos = vec2_t(0, 0)
    local addpos = vec2_t(0, 32)
    local startpos = vec2_t(screen_size.x * 0.00741666666, screen_size.y * 0.67777777777)
    local function default(str, color)
        local text_size = render.get_text_size(font, str)
        gradient(9, pos.y + 4, 70, 28, col_1, col_2)
        render.text(font, str, pos, color)
        pos = pos - addpos
    end

    local function circle(str, color, percent)
        local text_size = render.get_text_size(font, str)
        gradient(9, pos.y + 4, 70, 28, col_1, col_2)
        render.text(font, str, pos, color)
        render.progress_circle(pos + vec2_t(text_size.x * 1.3, text_size.y / 1.9), 5, color_t(0, 0, 0, 155), 3, 1)
        render.progress_circle(pos + vec2_t(text_size.x * 1.3, text_size.y / 1.9), 5, color, 3, percent)
        pos = pos - addpos

    end

    if amgis:get() then
        
        local text_sizenigma = render.get_text_size(fontsigma, "@" .. shoppyinput:get())
        local text_sizeligma = render.get_text_size(fontsigma, "shoppy.gg/")
        render.text(fontsigma, "shoppy.gg/", vec2_t(screen_size.x - text_sizenigma.x - text_sizeligma.x, 0), color_t(255, 255, 255, 255))
        render.text(fontsigma, "@" .. shoppyinput:get(), vec2_t(screen_size.x - text_sizenigma.x, 0), color_t(50, 255, 50, 255))
    end

    pos = startpos
    if indicators:get('Fake') then
        circle("FAKE", color_t(math.floor(255 - maxdes * 1.6), math.floor(maxdes * 4), 50, 255), maxdes / 58)
    end
    if indicators:get('Fake-Lag') then
        circle("FL ", color_t(math.floor(255 - engine.get_choked_commands() * 360 / 14 * 0.25), math.floor(engine.get_choked_commands() * 360 / 14 * 0.5), 50, 255), engine.get_choked_commands() / 14)
    end

    if indicators:get('Min DMG') and get_weapon_group()[2] then
        default("DMG: " .. get_weapon_group()[1], color2)
    end

    if indicators:get("Lethal") and get_weapon_group()[3] then
        default("LETHAL", color2)
    end

    if indicators:get('Baim') and get_weapon_group()[4] then
        default("BAIM", color2)
    end

    if indicators:get('Safe Point') and get_weapon_group()[5] then
        default("SAFE", color2)
    end

    if indicators:get('FakeDuck') and antiaim.is_fakeducking() then
        default("DUCK", color2)
    end

    if hideshots[2]:get() then
        default("ONSHOT", color_t(150, 200, 60, 255))
    end

    if dt_ref[2]:get() then
        if exploits.get_charge() == 14 and indicators:get('DoubleTap') then
            default("DT", color2)
        elseif exploits.get_charge() ~= 14 and indicators:get('DoubleTap') then
            default("DT", color3)
        end
    end

end

callbacks.add(e_callbacks.PAINT, dnn)
-- callbacks.add(e_callbacks.FINISH_COMMAND, get_weapon_group())