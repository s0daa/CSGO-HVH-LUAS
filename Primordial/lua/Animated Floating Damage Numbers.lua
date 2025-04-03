local main_font = render.create_font("Verdana", 12, 600, e_font_flags.ANTIALIAS)


local checkbox = menu.add_checkbox("Quacke Damage Numbers", "Enable")
local clr = checkbox:add_color_picker("Color")

local shot_data = {}

local function on_paint()
    if not checkbox:get() then
        return
    end
    local clr = clr:get()
    local r, g, b = clr.r, clr.g, clr.b

    for i=1, #shot_data do
        local shot = shot_data[i]
        if shot.draw then
            if shot.z >= shot.target then
                shot.alpha = shot.alpha - 1
            end
            if shot.alpha <= 0 then
                shot.draw = false
            end
            local vec = vec3_t(shot.x, shot.y, shot.z)
            local cords2d = render.world_to_screen(vec)

            if cords2d ~= nil then
                render.text(main_font, tostring(shot.damage), cords2d, color_t(r, g, b, shot.alpha))
            end
            shot.z = shot.z + 0.25
        end
    end
end


local function player_hurt(e)
    if not checkbox:get() then
        return
    end
    
    local attacker_entindex = entity_list.get_player_from_userid(e.attacker)
    local victim_entindex  = entity_list.get_player_from_userid(e.userid)
    if attacker_entindex ~= entity_list.get_local_player() then
        return
    end

    local cords = victim_entindex:get_render_origin()
    local duck_amount = victim_entindex:get_prop("m_flDuckAmount")

    local x, y, z = cords.x, cords.y, cords.z
    z = z + (46 + (1 - duck_amount) * 18)
    shot_data[#shot_data + 1] = {
        x       = x,
        y       = y,
        z       = z,
        target  = z + 25,
        damage  = e.dmg_health,
        alpha   = 255,
        draw    = true
    }
end

local function round_start()
    if not checkbox:get() then
        return
    end
    shot_data = {}
end


callbacks.add(e_callbacks.EVENT, player_hurt, "player_hurt")
callbacks.add(e_callbacks.EVENT, round_start, "round_start")
callbacks.add(e_callbacks.PAINT, on_paint)