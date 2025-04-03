-- local variables for API functions. any changes to the line below will be lost on re-generation
local callbacks_add, entity_list_get_entity, math_floor, menu_add_checkbox, menu_add_selection, menu_find, pairs, render_create_font, render_get_screen_size, render_load_image_buffer, render_texture, render_world_to_screen, table_insert = callbacks.add, entity_list.get_entity, math.floor, menu.add_checkbox, menu.add_selection, menu.find, pairs, render.create_font, render.get_screen_size, render.load_image_buffer, render.texture, render.world_to_screen, table.insert

local elect_svg = render_load_image_buffer("<svg id=\"svg\" version=\"1.1\" width=\"608\" height=\"689\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" ><g id=\"svgg\"><path id=\"path0\" d=\"M185.803 18.945 C 184.779 19.092,182.028 23.306,174.851 35.722 C 169.580 44.841,157.064 66.513,147.038 83.882 C 109.237 149.365,100.864 163.863,93.085 177.303 C 88.686 184.901,78.772 202.072,71.053 215.461 C 63.333 228.849,53.959 245.069,50.219 251.505 C 46.480 257.941,43.421 263.491,43.421 263.837 C 43.421 264.234,69.566 264.530,114.025 264.635 L 184.628 264.803 181.217 278.618 C 179.342 286.217,174.952 304.128,171.463 318.421 C 167.974 332.714,160.115 364.836,153.999 389.803 C 147.882 414.770,142.934 435.254,143.002 435.324 C 143.127 435.452,148.286 428.934,199.343 364.145 C 215.026 344.243,230.900 324.112,234.619 319.408 C 238.337 314.704,254.449 294.276,270.423 274.013 C 286.397 253.750,303.090 232.582,307.519 226.974 C 340.870 184.745,355.263 166.399,355.263 166.117 C 355.263 165.937,323.554 165.789,284.798 165.789 C 223.368 165.789,214.380 165.667,214.701 164.831 C 215.039 163.949,222.249 151.366,243.554 114.474 C 280.604 50.317,298.192 19.768,298.267 19.444 C 298.355 19.064,188.388 18.576,185.803 18.945 \" stroke=\"none\" fill=\"#fff200\" fill-rule=\"evenodd\"></path></g></svg>")

local zeus_warning_switch = menu_add_checkbox("Player ESP", "Zeus warning", false)
local position = menu_add_selection("Player ESP", "Position relative to hp", {'Left', 'Bottom'})
local change_font_switch = menu_add_checkbox("Player ESP", "Change font", false)

local pixel = render_create_font("Small fonts", 9, 350, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE)
local verdana_flag = render_create_font("Verdana", 12, 0, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS)
local health_text = menu_find('visuals', 'esp', 'players', 'health#enemy')

local function get_player_weapons(idx)
	local list = {}
    
    for i = 0, 64 do
        local cwpn = idx:get_prop("m_hMyWeapons", i)

		if cwpn ~= nil and entity_list_get_entity(cwpn) ~= nil and entity_list_get_entity(cwpn):is_weapon() then
			table_insert(list, entity_list_get_entity(cwpn))
		end
	end

	return list
end

function zeus_warning(ctx)
    if change_font_switch:get() then
        ctx:set_font(verdana_flag)
        ctx:set_small_font(pixel)
    end
    position:set_visible(health_text[1]:get(2) and zeus_warning_switch:get())
    if zeus_warning_switch:get() then
        local player_origin = render_world_to_screen(ctx.render_origin)
        if (not player_origin or player_origin.x < 0 or player_origin.x > render_get_screen_size().x or player_origin.y < 0 or player_origin.y > render_get_screen_size().y) then return end
        local x1, y1, x2, y2, a = ctx.bbox_start.x, ctx.bbox_start.y, ctx.bbox_size.x, ctx.bbox_size.y, ctx.alpha_modifier
        local has_taser = 0
        local active_weapon = ctx.player:get_active_weapon()
        if active_weapon == nil then return end
        if active_weapon:get_prop("m_iItemDefinitionIndex") == 31 then
            has_taser = 2
        end

        for _, v in pairs(get_player_weapons(ctx.player)) do
            if v ~= nil and has_taser == 0 and v:get_prop("m_iItemDefinitionIndex") == 31 then
                has_taser = 1
            end
        end

        if x1 ~= 0 and a > 0.000 and has_taser > 0 and elect_svg ~= nil then
            local r, g, b = 255, 255, 0
            if has_taser == 2 then
                r, g, b = 255, 0, 0
            end
            render_texture(elect_svg.id, vec2_t(x1 - 24 + (position:get() == 1 and health_text[1]:get(2) and -10 or 0), y1 + (position:get() == 2 and health_text[1]:get(2) and 10 or 0)), vec2_t(25, 25), color_t(r, g, b, math_floor(a*255)))
        end
    end
end
callbacks_add(e_callbacks.PLAYER_ESP, zeus_warning)