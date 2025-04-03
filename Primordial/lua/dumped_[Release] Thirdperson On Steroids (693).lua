local ui_items = {}
ui_items.script_enabled = menu.add_checkbox("ThirdPerson", "Thirdperson", true)
ui_items.switch = ui_items.script_enabled:add_keybind("Bind")
ui_items.distance = menu.add_slider("ThirdPerson", "Thirdperson Distance", 50, 200)
ui_items.collide = menu.add_checkbox("ThirdPerson", "Cam Disable Collision")
ui_items.shoulder_cam = menu.add_checkbox("ThirdPerson", "Shoulder Cam")
ui_items.shoulder_cam_height = menu.add_slider("ThirdPerson", "Shoulder Cam Height", -20, 20)
ui_items.invert_shoulder_cam_height = ui_items.shoulder_cam_height:add_keybind("Invert Height")
ui_items.shoulder_cam_offset = menu.add_slider("ThirdPerson", "Shoulder Cam Offset", -50, 50)
ui_items.invert_shoulder_cam_offset = ui_items.shoulder_cam_offset:add_keybind("Invert Offset")
ui_items.animate = menu.add_checkbox("ThirdPerson", "Animate")
ui_items.multiply_anim = menu.add_slider("ThirdPerson", 'Speed Multiplyer', 10, 20)
ui_items.spin_camera_on_kill = menu.add_checkbox("Memes", "Spin Camera on Kill")

local third_person = {
    should_bypass = true,
    client_in_third_person = false,
    value = 0,
    shoulder_cam = 0,
    distance = 0,
    s_side = 0,
    s_top = 0,
    s_pitch = 0,
    s_killed = false
}

math.lerp = function(a, b, t)
    return a + (b - a) * t
end

third_person.fix = function()
    local lp = entity_list.get_local_player()

    local key = ui_items.switch:get() and 1 or 2
    if not lp or lp:get_prop('m_iHealth') < 1 or not engine.is_in_game() or not engine.is_connected() then 
        cvars.cam_command:set_int(0)
        third_person.s_killed = false
        return 
    end

    if not ui_items.script_enabled:get() then
        third_person.should_bypass = true
        third_person.client_in_third_person = false
        return
    end

    cvars.sv_cheats:set_int(1)

    local dist = ui_items.distance:get()
    local animations = ui_items.animate:get()
    local anim_speed = globals.frame_time() * (((dist/10) * 1.8) * ui_items.multiply_anim:get()/10)

    --third_person.client_in_third_person = key == 1 and true or false

    --third_person.distance
    local is_in_tp = animations and (math.floor(third_person.distance) <= 20 and 2 or 1) or key
    cvars.cam_command:set_int(is_in_tp)
    if not third_person.client_in_third_person and key == 1 then
        engine.execute_cmd('thirdperson')
        third_person.client_in_third_person = true
    elseif third_person.client_in_third_person and key == 2 then
        engine.execute_cmd('firstperson')
        third_person.client_in_third_person = false
    end

    local shoulder_cam = ui_items.shoulder_cam:get() and 1 or 0
    if animations then
        shoulder_cam = (math.abs(math.floor(third_person.s_top)) <= 1 or math.abs(math.floor(third_person.s_top)) <= 1 ) and shoulder_cam or 1
    end
    if shoulder_cam ~= cvars.c_thirdpersonshoulder:get_int() then
        cvars.c_thirdpersonshoulder:set_int(shoulder_cam)
    end

    local shoulder_cam_height = ui_items.shoulder_cam_height:get()
    if ui_items.invert_shoulder_cam_height:get() then
        shoulder_cam_height = -shoulder_cam_height
    end
    local animated_shoulder_height = key == 1 and shoulder_cam_height or 0
    third_person.s_top = math.lerp(third_person.s_top, animated_shoulder_height, anim_speed)
    if animations then
        shoulder_cam_height = third_person.s_top
    end
    if shoulder_cam_height ~= cvars.c_thirdpersonshoulderheight:get_int() then
        cvars.c_thirdpersonshoulderheight:set_int((shoulder_cam_height < 0 and math.floor(shoulder_cam_height) or math.ceil(shoulder_cam_height)))
    end

    local shoulder_cam_offset = ui_items.shoulder_cam_offset:get()
    if ui_items.invert_shoulder_cam_offset:get() then
        shoulder_cam_offset = -shoulder_cam_offset
    end
    local animated_shoulder_offset = key == 1 and shoulder_cam_offset or 0
    third_person.s_side = math.lerp(third_person.s_side, animated_shoulder_offset, anim_speed * 2)
    if animations then
        shoulder_cam_offset = third_person.s_side
    end
    if shoulder_cam_offset ~= cvars.c_thirdpersonshoulderoffset:get_int() then
        cvars.c_thirdpersonshoulderoffset:set_int((shoulder_cam_offset < 0 and math.floor(shoulder_cam_offset) or math.ceil(shoulder_cam_offset)))
    end

    local animated_dist = key == 1 and dist or 0
    third_person.distance = math.lerp(third_person.distance, animated_dist, anim_speed)
    cvars.c_maxdistance:set_int(animations and math.floor(third_person.distance) or dist)
    cvars.cam_idealdist:set_int(dist)
    cvars.c_thirdpersonshoulderdist:set_int(dist)
    cvars.cam_collision:set_int(ui_items.collide:get() and 0 or 1)

    if ui_items.spin_camera_on_kill:get() then
        if third_person.s_killed then
            third_person.s_pitch = third_person.s_pitch + 1
            if third_person.s_pitch >= 89 then
                third_person.s_pitch = 0
                third_person.s_killed = false
            end
        end
    else
        third_person.s_pitch = 0
    end
    
    if cvars.cam_idealpitch:get_int() ~= third_person.s_pitch then
        cvars.cam_idealpitch:set_int(third_person.s_pitch)
    end

    
end

callbacks.add(e_callbacks.EVENT, function(e)
    if e.name == "player_death" then
        local lp = entity_list.get_local_player()
        local attacker = e.attacker
        if entity_list.get_player_from_userid(attacker) == lp then
            third_person.s_killed = true
        end
    end
end)

callbacks.add(e_callbacks.PAINT, function()
    third_person.fix()
end)