local esp_names = render.create_font("Verdanab", 12, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local sub_font = render.create_font("Verdanab", 10, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW, e_font_flags.GAUSSIANBLUR)
--menu items//////////////////////////////
local esp_text = menu.add_text("esp", "enable")

local esp_bind = esp_text:add_keybind("##esp")

local name_esp = menu.add_checkbox("esp", "names")
local name_color = name_esp:add_color_picker("name color")
local box_esp = menu.add_checkbox("esp", "boxes")
local box_color = box_esp:add_color_picker("box color")
local box_type = menu.add_selection("esp", "box type", {"outline", "rounded", "cornered"})
local corner_length = menu.add_slider("esp", "cornered box length", 0, 50, 1, 0, "%")
local add_box_fill = menu.add_checkbox("esp", "box fill")
local box_fill_color = add_box_fill:add_color_picker("fillcolor", color_t(99, 164, 207, 30))
local box_outline = menu.add_multi_selection("esp", "box outline", {"inner", "outer"})
local weapon_esp = menu.add_checkbox("esp", "weapon")
local weapon_color = weapon_esp:add_color_picker("weaponcolor")
local ammo_esp = menu.add_multi_selection("esp", "ammo", {"bar", "text"})
local ammo_color = ammo_esp:add_color_picker("ammo color", color_t(123,123,255,255))
local health_esp = menu.add_multi_selection("esp", "health", {"bar", "text"})
local health_color = health_esp:add_color_picker("healthcolor", color_t(123,255,123,255))
local flag_combo = menu.add_multi_selection("esp", "flags", {"armor", "scoped", "money", "flashed", "shot", "distance", "defusing"})
local flag_color = flag_combo:add_color_picker("flcolor", color_t(220,220,220,255))
local flag_accent = flag_combo:add_color_picker("flaccent", color_t(255,123,123,255))

local function get_pos(player)
    local min = player:get_prop("m_vecMins")
    local max = player:get_prop("m_vecMaxs")
    local pos = player:get_render_origin() --collideable + pos

    if min == nil or max == nil or pos == nil then return end

    local mpoints = {
	  vec3_t(min.x, min.y, min.z),
	  vec3_t(min.x, max.y, min.z),
	  vec3_t(max.x, max.y, min.z),
	  vec3_t(max.x, min.y, min.z),
	  vec3_t(max.x, max.y, max.z),
	  vec3_t(min.x, max.y, max.z),
	  vec3_t(min.x, min.y, max.z),
	  vec3_t(max.x, min.y, max.z)
	}

    local points = {
        pos + mpoints[1],
        pos + mpoints[2],
        pos + mpoints[3],
        pos + mpoints[4],
        pos + mpoints[5],
        pos + mpoints[6],
        pos + mpoints[7],
        pos + mpoints[8]
    }

    local screen_points = {}
    
    for i = 1, 8, 1 do
        --debug_overlay.add_sphere(points[i], 4, 10, 10, color_t(255,255,255,255), 0.1)
        screen_points[i] = render.world_to_screen(points[i])
    end
    if screen_points[1] == nil then return end
    local left = screen_points[1].x
    local bot = screen_points[1].y
    for i = 1, 8, 1 do
    if screen_points[i] == nil then return end
        
        if left > screen_points[i].x then
        left = screen_points[i].x end
        if bot < screen_points[i].y then
        bot= screen_points[i].y end
    end
    return vec2_t(left, bot)
end

local function get_size(player)
    local min = player:get_prop("m_vecMins")
    local max = player:get_prop("m_vecMaxs")
    local pos = player:get_render_origin() --collideable + pos

    if min == nil or max == nil or pos == nil then return end

    local mpoints = {
	  vec3_t(min.x, min.y, min.z),
	  vec3_t(min.x, max.y, min.z),
	  vec3_t(max.x, max.y, min.z),
	  vec3_t(max.x, min.y, min.z),
	  vec3_t(max.x, max.y, max.z),
	  vec3_t(min.x, max.y, max.z),
	  vec3_t(min.x, min.y, max.z),
	  vec3_t(max.x, min.y, max.z)
	}

    local points = {
        pos + mpoints[1],
        pos + mpoints[2],
        pos + mpoints[3],
        pos + mpoints[4],
        pos + mpoints[5],
        pos + mpoints[6],
        pos + mpoints[7],
        pos + mpoints[8]
    }

    local screen_points = {}
    
    for i = 1, 8, 1 do
        --debug_overlay.add_sphere(points[i], 4, 10, 10, color_t(255,255,255,255), 0.1)
        screen_points[i] = render.world_to_screen(points[i])
    end
    if screen_points[1] == nil then return end
    local left = screen_points[1].x
    local bot = screen_points[1].y
    local right = screen_points[1].x 
    local top = screen_points[1].y
    for i = 1, 8, 1 do
    if screen_points[i] == nil then return end
        
        if left > screen_points[i].x then
        left = screen_points[i].x end
        if bot < screen_points[i].y then
        bot= screen_points[i].y end
        if right < screen_points[i].x then
        right = screen_points[i].x end
        if top > screen_points[i].y then
        top = screen_points[i].y end
    end
    return vec2_t(right - left, bot - top)
end
local shot_flag_timer = 0.0


callbacks.add(e_callbacks.PLAYER_ESP, function(ctx)
if not esp_bind:get() then return end

local local_player = entity_list.get_local_player()
local entity = ctx.player
if not entity:is_alive() then return end
if ctx.alpha_modifier <= 0 then return end
local timer
if ctx.dormant then 
    if ctx.player:get_prop("m_iHealth") <= 0 then 
return end end

        if not entity:is_alive() then goto continue end
        local mins = entity:get_prop("m_vecMins")
        local maxs = entity:get_prop("m_vecMaxs")
        local pos  = entity:get_render_origin()
        local orientation = entity:get_render_angles()
        local ok = get_pos(entity)
        local size = get_size(entity)
        if mins == nil or maxs == nil or pos == nil or orientation == nil or ok == nil or size == nil then goto continue end
            local name_size = render.get_text_size(esp_names, entity:get_name())
            if name_esp:get() then
                render.text(esp_names, entity:get_name(), vec2_t(ok.x + size.x / 2, ok.y - size.y - name_size.y / 2), name_color:get(), true)
            end
            if box_esp:get() then
                if box_type:get() == 1 then
                    render.rect(vec2_t(ok.x, ok.y - size.y), size, box_color:get(), 1)
                    if box_outline:get(1) then
                        render.rect(vec2_t(ok.x + 1, ok.y - size.y + 1), vec2_t(size.x - 2, size.y -2), color_t(0,0,0,255), 1)
                    end
                    if box_outline:get(2) then
                        render.rect(vec2_t(ok.x - 1, ok.y - size.y - 1), vec2_t(size.x + 2, size.y + 2), color_t(0,0,0,255), 1)
                    end
                end
                if box_type:get() == 2 then
                    render.rect(vec2_t(ok.x, ok.y - size.y), size, box_color:get(), 15)
                    if box_outline:get(1) then
                        render.rect(vec2_t(ok.x + 1, ok.y - size.y + 1), vec2_t(size.x - 2, size.y -2), color_t(0,0,0,255), 15)
                    end
                    if box_outline:get(2) then
                        render.rect(vec2_t(ok.x - 1, ok.y - size.y - 1), vec2_t(size.x + 2, size.y + 2), color_t(0,0,0,255), 15)
                    end
                end
                if box_type:get() == 3 then
                    local corner_width = size.x * corner_length:get() / 100
                    local corner_height = size.y * corner_length:get() / 100
                    render.line(vec2_t(ok.x, ok.y), vec2_t(ok.x + corner_width, ok.y ), box_color:get())
                    render.line(vec2_t(ok.x , ok.y - corner_height), vec2_t(ok.x, ok.y), box_color:get())
                    render.line(vec2_t(ok.x + size.x, ok.y), vec2_t(ok.x + size.x - corner_width, ok.y ), box_color:get())
                    render.line(vec2_t(ok.x + size.x , ok.y), vec2_t(ok.x + size.x, ok.y - corner_height), box_color:get())
                    render.line(vec2_t(ok.x, ok.y - size.y), vec2_t(ok.x + corner_width, ok.y - size.y), box_color:get())
                    render.line(vec2_t(ok.x , ok.y - size.y + corner_height), vec2_t(ok.x, ok.y -size.y), box_color:get())
                    render.line(vec2_t(ok.x + size.x, ok.y - size.y), vec2_t(ok.x + size.x - corner_width, ok.y - size.y), box_color:get())
                    render.line(vec2_t(ok.x + size.x , ok.y - size.y), vec2_t(ok.x + size.x, ok.y + corner_height - size.y), box_color:get())
                    if box_outline:get(1) then
                        render.line(vec2_t(ok.x + 1, ok.y - 1), vec2_t(ok.x + corner_width, ok.y - 1), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x + 1, ok.y - corner_height), vec2_t(ok.x + 1, ok.y -1), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x + size.x - 1, ok.y - 1), vec2_t(ok.x + size.x - corner_width, ok.y - 1), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x + size.x - 1, ok.y - 1), vec2_t(ok.x + size.x - 1, ok.y - corner_height), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x + 1, ok.y - size.y+ 1), vec2_t(ok.x + corner_width, ok.y - size.y + 1), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x + 1, ok.y - size.y + corner_height), vec2_t(ok.x + 1, ok.y -size.y + 1), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x + size.x - 1, ok.y - size.y + 1), vec2_t(ok.x + size.x - corner_width - 1, ok.y - size.y + 1), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x + size.x - 1, ok.y - size.y + 1), vec2_t(ok.x + size.x - 1, ok.y + corner_height - size.y), color_t(0,0,0,255))
                    end
                    if box_outline:get(2) then
                        render.line(vec2_t(ok.x - 1, ok.y + 1), vec2_t(ok.x + corner_width, ok.y + 1), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x - 1, ok.y - corner_height), vec2_t(ok.x - 1, ok.y +1), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x + size.x + 1, ok.y + 1), vec2_t(ok.x + size.x - corner_width, ok.y + 1), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x + size.x + 1, ok.y + 1), vec2_t(ok.x + size.x + 1, ok.y - corner_height), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x - 1, ok.y - size.y - 1), vec2_t(ok.x + corner_width + 1, ok.y - size.y - 1), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x - 1, ok.y - size.y + corner_height), vec2_t(ok.x - 1, ok.y -size.y - 1), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x + size.x + 1, ok.y - size.y - 1), vec2_t(ok.x + size.x - corner_width + 1, ok.y - size.y - 1), color_t(0,0,0,255))
                        render.line(vec2_t(ok.x + size.x + 1, ok.y - size.y - 1), vec2_t(ok.x + size.x + 1, ok.y + corner_height - size.y), color_t(0,0,0,255))
                    end
                end
            end
            if add_box_fill:get() then 
                if box_type:get() == 2 then 
                    render.rect_filled(vec2_t(ok.x + 2, ok.y - size.y + 2), vec2_t(size.x - 3, size.y - 3), box_fill_color:get(), 15)
                else
                    render.rect_filled(vec2_t(ok.x + 2, ok.y - size.y + 2), vec2_t(size.x - 3, size.y - 3), box_fill_color:get(), 1)
                end
            end
            if health_esp:get(1) then
                local hp_height = (size.y * entity:get_prop("m_iHealth")) / 100
                render.rect_filled(vec2_t(ok.x - 6, ok.y - size.y - 1), vec2_t(4, size.y + 2), color_t(10,10,10,125))
                render.rect_filled(vec2_t(ok.x - 5, ok.y - hp_height), vec2_t(2, hp_height), health_color:get())
            end
            if health_esp:get(2) then
                local health_text_size = render.get_text_size(sub_font, tostring(entity:get_prop("m_iHealth")))
                if health_esp:get(1) then
                    render.text(sub_font, tostring(entity:get_prop("m_iHealth")), vec2_t(ok.x - health_text_size.x - 8, ok.y - size.y), color_t(225,225,225,255))
                else
                    render.text(sub_font, tostring(entity:get_prop("m_iHealth")), vec2_t(ok.x - health_text_size.x - 3, ok.y - size.y), color_t(225,225,225,255))
                end
            end
        if not ctx.dormant then
            local weapon_size = render.get_text_size(esp_names, tostring(entity:get_active_weapon():get_name()))
            if weapon_esp:get() and not ammo_esp:get(1) then
                render.text(esp_names, entity:get_active_weapon():get_name(), vec2_t(ok.x + size.x / 2, ok.y + weapon_size.y / 1.5), weapon_color:get(), true)
            end
            if weapon_esp:get() and ammo_esp:get(1) then
                render.text(esp_names, entity:get_active_weapon():get_name(), vec2_t(ok.x + size.x / 2, ok.y + weapon_size.y / 1.5 + 6), weapon_color:get(), true)
            end
            if ammo_esp:get(1) then
            if entity:get_active_weapon():get_prop("m_iClip1") < 0 then return end
                local ammo_width = (size.x * entity:get_active_weapon():get_prop("m_iClip1") / entity:get_active_weapon():get_weapon_data().max_clip)
                render.rect_filled(vec2_t(ok.x - 1, ok.y + 3 ), vec2_t(size.x + 2, 4), color_t(10,10,10,125))
                render.rect_filled(vec2_t(ok.x, ok.y + 4), vec2_t(ammo_width, 2), ammo_color:get())
            end
            if ammo_esp:get(2) then
            if entity:get_active_weapon():get_prop("m_iClip1") < 0 then return end
                local ammo_string = tostring(entity:get_active_weapon():get_prop("m_iClip1")) .. " / " .. tostring(entity:get_active_weapon():get_weapon_data().max_clip)
                if ammo_string == nil then goto fuck end
                local ammo_text_size = render.get_text_size(esp_names, ammo_string)
                
                if not ammo_esp:get(1) and not weapon_esp:get() then
                    render.text(esp_names, ammo_string, vec2_t(ok.x + size.x / 2, ok.y + 1 + ammo_text_size.y / 1.5), color_t(255,255,255,255), true)
                
                elseif ammo_esp:get(1) and not weapon_esp:get() then
                    render.text(esp_names, ammo_string, vec2_t(ok.x + size.x / 2, ok.y + 7 + ammo_text_size.y / 1.5), color_t(255,255,255,255), true)
                elseif ammo_esp:get(1) and weapon_esp:get() then
                    render.text(esp_names, ammo_string, vec2_t(ok.x + size.x / 2, ok.y + 9 + weapon_size.y / 1.5 + ammo_text_size.y / 1.5), color_t(255,255,255,255), true)
                else
                    render.text(esp_names, ammo_string, vec2_t(ok.x + size.x / 2, ok.y + 4 + weapon_size.y / 1.5 + ammo_text_size.y / 1.5), color_t(255,255,255,255), true)
                end
            end
        end
            ::fuck::
        if not ctx.dormant then
            local flag_items = flag_combo:get_items()
            local flag_height = 0
            if flag_items == nil then goto continue end
            for i = 1, #flag_items, 1 do --i hate this language
                if i == 1 then
                    if flag_combo:get(i) then
                        if entity:get_prop("m_ArmorValue") > 0 then
                        if entity:get_prop("m_bHasHelmet") > 0 then
                            render.text(sub_font, "HK", vec2_t(ok.x + size.x + 3, ok.y - size.y + flag_height * 15), flag_color:get())
                            flag_height = flag_height + 1
                        else 
                            render.text(sub_font, "K", vec2_t(ok.x + size.x + 3, ok.y - size.y + flag_height * 15), flag_color:get())
                            flag_height = flag_height + 1
                        end 
                    end
                end      
                elseif i == 2 then 
                    if flag_combo:get(i) then
                        if entity:get_prop("m_bIsScoped") > 0 then
                            render.text(sub_font, "SCOPED", vec2_t(ok.x + size.x + 3, ok.y - size.y + flag_height * 8), flag_color:get())
                            flag_height = flag_height + 1
                        end
                    end
                elseif i == 3 then
                    if flag_combo:get(i) then
                        render.text(sub_font, tostring("$"..entity:get_prop("m_iAccount")), vec2_t(ok.x + size.x + 3, ok.y - size.y + flag_height * 8), flag_accent:get())
                        flag_height = flag_height + 1
                    end
                elseif i == 4 then
                    if flag_combo:get(i) then
                        if entity:get_prop("m_flFlashDuration") > 0 then --scuffed ish way to do it but it works
                        render.text(sub_font , "FLASHED", vec2_t(ok.x + size.x + 3, ok.y - size.y + flag_height * 8), flag_accent:get())
                        flag_height = flag_height + 1
                        end
                    end
                elseif i == 5 then
                    if flag_combo:get(i) then
                        if entity:get_active_weapon():get_prop("m_fLastShotTime") == entity:get_prop("m_flSimulationTime") or shot_flag_timer > global_vars.cur_time() then
                        render.text(sub_font, "SHOT", vec2_t(ok.x + size.x + 3, ok.y - size.y + flag_height * 8), flag_accent:get())
                        if shot_flag_timer < global_vars.cur_time() then
                        shot_flag_timer = global_vars.cur_time() + 0.1 end
                        flag_height = flag_height + 1 end
                    end
                elseif i == 6 then
                    if flag_combo:get(i) then
                        render.text(sub_font, tostring(math.floor(entity:get_render_origin():dist(local_player:get_render_origin()) / 16).."FT"), vec2_t(ok.x + size.x + 3, ok.y - size.y + flag_height * 8), flag_color:get())
                        flag_height = flag_height + 1
                    end
                elseif i == 7 then
                    if flag_combo:get(i) then 
                        if entity:get_prop("m_bIsDefusing") > 0 then
                            render.text(sub_font, "DEFUSING", vec2_t(ok.x + size.x + 3, ok.y - size.y + flag_height * 8), flag_accent:get())
                            flag_height = flag_height + 1
                        end
                    end
                elseif i == 8 then

                elseif i == 9 then

                end
            end
        end
        ::continue::
    
end)