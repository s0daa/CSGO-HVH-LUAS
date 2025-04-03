local main_alpha = menu.add_slider("Buy list", "Alpha", 0, 100, 1, 0, "%")

local slider_x = menu.add_slider("Buy list", "x", 0, render.get_screen_size().x, 1, 0, "")
local slider_y = menu.add_slider("Buy list", "y", 0, render.get_screen_size().y, 1, 0, "")

local purchases = {}
local main_font = render.get_default_font()
local weap_font = render.create_font("AstriumWep", 20, 400, e_font_flags.ANTIALIAS)

local curtime = 0

function math.lerp(name, value, speed)
    return name + (value - name) * globals.frame_time() * speed
end

callbacks.add(e_callbacks.EVENT, function(event)
    if not entity_list.get_player_from_userid(event.userid):is_enemy() then return end
    if purchases[event.userid] == nil then purchases[event.userid] = {} end
    table.insert(purchases[event.userid], event.weapon)
    curtime = globals.cur_time()
end, "item_purchase")

callbacks.add(e_callbacks.EVENT, function(event)
    if event.name == "round_start" then purchases = {}; curtime = 0 end
    if event.name == "round_end" then purchases = {}; curtime = 0 end
    if event.name == "round_prestart" then purchases = {}; curtime = 0 end
    if event.name == "round_poststart" then purchases = {}; curtime = 0 end
end)

local alpha = 0

local weap_lib = {
    ["weapon_deagle"] = "A",
    ["weapon_elite"] = "B",
    ["weapon_fiveseven"] = "C",
    ["weapon_glock"] = "D",
    ["weapon_ak47"] = "W",
    ["weapon_aug"] = "U",
    ["weapon_awp"] = "Z",
    ["weapon_famas"] = "R",
    ["weapon_m249"] = "g",
    ["weapon_g3sg1"] = "X",
    ["weapon_galilar"] = "Q",
    ["weapon_m4a1"] = "S",
    ["weapon_m4a1_silencer"] = "T",
    ["weapon_mac10"] = "K",
    ["weapon_hkp2000"] = "E",
    ["weapon_mp5sd"] = "N",
    ["weapon_ump45"] = "L",
    ["weapon_xm1014"] = "b",
    ["weapon_bizon"] = "M",
    ["weapon_mag7"] = "d",
    ["weapon_negev"] = "f",
    ["weapon_sawedoff"] = "c",
    ["weapon_tec9"] = "H",
    ["weapon_taser"] = "h",
    ["weapon_p250"] = "F",
    ["weapon_mp7"] = "N",
    ["weapon_mp9"] = "O",
    ["weapon_nova"] = "e",
    ["weapon_p90"] = "P",
    ["weapon_scar20"] = "Y",
    ["weapon_sg556"] = "V",
    ["weapon_ssg08"] = "a",
    ["weapon_flashbang"] = "i",
    ["weapon_hegrenade"] = "j",
    ["weapon_smokegrenade"] = "k",
    ["weapon_molotov"] = "l",
    ["weapon_decoy"] = "m",
    ["weapon_incgrenade"] = "n",
    ["weapon_usp_silencer"] = "G",
    ["weapon_cz75a"] = "I",
    ["weapon_revolver"] = "J",
    ["item_assaultsuit"] = "p",
    ["item_kevlar"] = "q",
    ["item_defuser"] = "r",
}

local options = {
    x = 50,
    y = 500,
}

local current_width = 0
local current_offset = 0

callbacks.add(e_callbacks.PAINT, function()
    local offset, opacity = 0, math.floor((main_alpha:get() / 100) * 255)

    options.x = slider_x:get()
    options.y = slider_y:get()

    width = 0
    height = 0

    if not engine.is_in_game() then purchases = {}; curtime = 0 end

    if curtime ~= 0 and globals.cur_time() - curtime < 10 then
        alpha = math.lerp(alpha, 255, 10)
    else
        alpha = math.lerp(alpha, 0, 10)
    end

    if alpha < 1 and menu.is_open() or not engine.is_in_game() and menu.is_open() then
        render.rect(vec2_t(options.x, options.y), vec2_t(100, weap_font.height), color_t(0, 0, 0, opacity), 5)
        render.rect_filled(vec2_t(options.x + 1, options.y + 1), vec2_t(100 - 1, weap_font.height - 1), color_t(31, 31, 31, opacity), 5)
        render.text(main_font, "buy list", vec2_t(options.x + 50, options.y + weap_font.height / 2), color_t(201, 201, 201), true)
    end

    if alpha < 1 then return end

    render.push_alpha_modifier(alpha / 255)

    render.rect(vec2_t(options.x, options.y - weap_font.height), vec2_t(current_width, weap_font.height * 2 + current_offset), color_t(0, 0, 0, opacity), 5)
    render.rect_filled(vec2_t(options.x + 1, options.y - weap_font.height + 1), vec2_t(current_width - 1, weap_font.height * 2 + current_offset - 1), color_t(31, 31, 31, opacity), 5)

    for v, k in pairs(purchases) do
        entity = entity_list.get_player_from_userid(v)
        w = ""

        for i = 1, #k do
            if weap_lib[k[i]] ~= nil then
                w = w .. weap_lib[k[i]] .. " "
            end
        end

        text_size = {
            render.get_text_size(main_font, entity:get_name() .. " bought "),
            render.get_text_size(weap_font, w),
        }

        render.text(main_font, entity:get_name() .. " bought ", vec2_t(options.x + 8, options.y + offset * 30 - (text_size[1].y / 2)), color_t(201, 201, 201))
        render.text(weap_font, w, vec2_t(options.x + 8 + text_size[1].x, options.y + offset * 30 - (text_size[2].y / 2)), color_t(201, 201, 201))

        if width < text_size[1].x + text_size[2].x + 10 then width = text_size[1].x + text_size[2].x + 10 end
        height = offset * 30 - (text_size[1].y / 2)

        offset = offset + 1
    end

    current_width = math.lerp(current_width, width, 10)
    current_offset = height

    render.pop_alpha_modifier()
end)