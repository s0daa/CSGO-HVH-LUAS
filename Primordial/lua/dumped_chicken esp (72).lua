local sub_font = render.create_font("Verdanab", 14, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW, e_font_flags.GAUSSIANBLUR)
--checkmbox
local whatthefuck = menu.add_text("Chicken Esp", "enable")
local master_bind = whatthefuck:add_keybind("enabld")
local boxesintwodimensions = menu.add_checkbox("Chicken Esp", "2D Boxes")
local thetwodboxcolor = boxesintwodimensions:add_color_picker("osdkfj")
local textthing = menu.add_text("Chicken Esp", "background frame")
local bgframe = textthing:add_color_picker("bgframe", color_t(20,20,20,85))
local nameesp = menu.add_checkbox("Chicken Esp", "name")
local namecolor = nameesp:add_color_picker("fsldjk")
local healthesp = menu.add_multi_selection("Chicken Esp","health", {"bar", "text", "hide when full hp"})
local health1 = healthesp:add_color_picker("okdf", color_t(0,255,0,255))
local health2 = healthesp:add_color_picker("fsldkj", color_t(255,0,0,255))
local weaponesp = menu.add_selection("Chicken Esp","active weapon", {"off", "text"})
local weapcolor = weaponesp:add_color_picker("asldkf")
local ammoesp = menu.add_multi_selection("Chicken Esp","ammo", {"bar", "text"})
local ammocolor = ammoesp:add_color_picker("afosdk", color_t(0,0,255,255))
local aim_lines = menu.add_checkbox("Chicken Esp", "aim lines")
local aim_color = aim_lines:add_color_picker("oked")
local boxesp = menu.add_checkbox("Old Chicken Esp", "Boxes")
local capsuleesp = menu.add_checkbox("Old Chicken Esp", "Capsules")
local sphereesp = menu.add_checkbox("Old Chicken Esp", "Spheres")


--color
local boxcolor = boxesp:add_color_picker("box color")
local capsulecolor = capsuleesp:add_color_picker("capsule color")
local spherecolor = sphereesp:add_color_picker("sphere color")



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


local function calc_aim_point(render_angles, render_origin)
    local vx = math.rad(render_angles.x)
    local vy = math.rad(render_angles.y)
    
    local sinp = math.sin(vx)
    local cosp = math.cos(vx)
    local siny = math.sin(vy)
    local cosy = math.cos(vy)
    
    local vdir = vec3_t(cosp * cosy, cosp * siny, -sinp)
    
    local trace_do = trace.line(render_origin  + vec3_t(vdir.x * 21,vdir.y * 21,8), render_origin + vec3_t(0,0,8) + vec3_t(vdir.x * 1500, vdir.y * 1500, vdir.z * 1500), nil, MASK_SOLID)
    print(trace_do.fraction)
    local fend_pos = render_origin + vec3_t(0,0,8) + vec3_t(vdir.x * (trace_do.fraction * 1500), vdir.y * (trace_do.fraction * 1500), vdir.z * (trace_do.fraction * 1500))
    debug_overlay.add_line(render_origin + vec3_t(vdir.x * 11,vdir.y * 11, 8),
    fend_pos, aim_color:get(), false, 0.02)
    --debug_overlay.add_line(render_origin + vec3_t(0,0,8),
    --render_origin + vec3_t(0,0,8) + vdir * vec3_t(510,510,510), color_t(255,255,255,255), false, 0.05)
end


local screen_size = render.get_screen_size()



local function draw_esp()
    local class_list = entity_list.get_entities_by_classid(36);
if not master_bind:get() then return end
    for _,chicknr in pairs(class_list) do
        local mins = chicknr:get_prop("m_vecMins")
        local maxs = chicknr:get_prop("m_vecMaxs")
        local pos  = chicknr:get_render_origin()
        local orientation = chicknr:get_render_angles()
        local boxpos = get_pos(chicknr)
        local boxsize = get_size(chicknr)
        if mins == nil or maxs == nil or pos == nil or orientation == nil then goto continue end
        
        if boxesp:get() then
            debug_overlay.add_box(pos, mins, maxs, orientation, boxcolor:get(), .02)
        end
        if sphereesp:get() then
            debug_overlay.add_sphere(chicknr:get_render_origin() + vec3_t(0, 0, 10), 15, 20, 5, spherecolor:get(), .01)
        end
        if capsuleesp:get() then
            debug_overlay.add_capsule(pos + vec3_t(-20,0,10), pos + vec3_t(20,0,10), 10, capsulecolor:get(), false,  .01)
        end
        if boxpos == nil or boxsize == nil then goto continue end
        if boxesintwodimensions:get() then
            render.rect(vec2_t(boxpos.x, boxpos.y - boxsize.y), vec2_t(boxsize.x, boxsize.y), thetwodboxcolor:get())
        end
        if healthesp:get(1) then
        if healthesp:get(3) then goto hcontinue end
            render.rect_fade(vec2_t(boxpos.x - 3, boxpos.y - boxsize.y), vec2_t(2, boxsize.y), health2:get(), health1:get(), false)
        end
        if healthesp:get(2) then
        if healthesp:get(3) then goto hcontinue end
            local health_size = render.get_text_size(sub_font, "100")
            if healthesp:get(1) then
                render.text(sub_font, "100", vec2_t(boxpos.x - health_size.x + 3, boxpos.y - boxsize.y + 5), color_t(255,255,255,255), true)
            else
                render.text(sub_font, "100", vec2_t(boxpos.x - health_size.x / 2 - 1, boxpos.y - boxsize.y + 5), color_t(255,255,255,255), true)
            end
        end
        ::hcontinue::
        if nameesp:get() then
            local the_text_size_shitter = render.get_text_size(sub_font, "chicken")
            render.rect_filled(vec2_t(boxpos.x, boxpos.y - boxsize.y - the_text_size_shitter.y), vec2_t(boxsize.x, the_text_size_shitter.y), bgframe:get())
            render.text(sub_font, "chicken", vec2_t(boxpos.x + boxsize.x / 2, boxpos.y - boxsize.y - the_text_size_shitter.y / 2), namecolor:get(), true)
        end
        if ammoesp:get(1) then
           render.rect(vec2_t(boxpos.x, boxpos.y + 1), vec2_t(boxsize.x, 2), ammocolor:get())  
        end
        if aim_lines:get() then
            calc_aim_point(orientation, pos)
        end
        local weap_text_size_shitter = render.get_text_size(sub_font, "beak")
        if weaponesp:get() == 2 then
            if not ammoesp:get(1) then
                render.text(sub_font, "beak", vec2_t(boxpos.x + boxsize.x / 2, boxpos.y + weap_text_size_shitter.y / 2), weapcolor:get(), true)
            else 
                render.text(sub_font, "beak", vec2_t(boxpos.x + boxsize.x / 2, boxpos.y + 3 + weap_text_size_shitter.y / 2), weapcolor:get(), true)
            end
        end
        if ammoesp:get(2) then
            local ammo_size = render.get_text_size(sub_font, "1 / 1")
            if weaponesp:get() == 2 and ammoesp:get(1) then
                render.text(sub_font, "1 / 1", vec2_t(boxpos.x + boxsize.x / 2, boxpos.y + weap_text_size_shitter.y / 2 + 6 + ammo_size.y / 2), color_t(255,255,255,255), true)
            elseif weaponesp:get() == 2 and not ammoesp:get(1) then
                render.text(sub_font, "1 / 1", vec2_t(boxpos.x + boxsize.x / 2, boxpos.y + weap_text_size_shitter.y / 2 + ammo_size.y / 2), color_t(255,255,255,255), true)
            else
                render.text(sub_font, "1 / 1", vec2_t(boxpos.x + boxsize.x / 2, boxpos.y + ammo_size.y / 2), color_t(255,255,255,255), true)
            end
        end
        ::continue::
    end
end

callbacks.add(e_callbacks.PAINT, draw_esp)