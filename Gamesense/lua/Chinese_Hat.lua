-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local lp = entity.get_local_player

--elements
local enable = ui.new_checkbox("LUA", "A", "Enable China hat", true)
local color = ui.new_color_picker("LUA", "A", "China color", 0, 255, 255, 255)
local gradient = ui.new_checkbox("LUA", "A", "Gradient")
local speed = ui.new_slider("LUA", "A", "Speed \n China", 1, 10, 5)

local thirdperson = {ui.reference("Visuals", "Effects", "Force third person (alive)")}

--cope triangle function (by some nigga on forums)
local renderer_triangle = function(v2_A, v2_B, v2_C, r, g, b, a)
    local function i(j,k,l)
        local m=(k.y-j.y)*(l.x-k.x)-(k.x-j.x)*(l.y-k.y)
        if m<0 then return true end
        return false
    end
    if i(v2_A,v2_B,v2_C) then renderer.triangle(v2_A.x,v2_A.y,v2_B.x,v2_B.y,v2_C.x,v2_C.y,r,g,b,a)
    elseif i(v2_A,v2_C,v2_B) then renderer.triangle(v2_A.x,v2_A.y,v2_C.x,v2_C.y,v2_B.x,v2_B.y,r,g,b,a)
    elseif i(v2_B,v2_C,v2_A) then renderer.triangle(v2_B.x,v2_B.y,v2_C.x,v2_C.y,v2_A.x,v2_A.y,r,g,b,a)
    elseif i(v2_B,v2_A,v2_C) then renderer.triangle(v2_B.x,v2_B.y,v2_A.x,v2_A.y,v2_C.x,v2_C.y,r,g,b,a)
    elseif i(v2_C,v2_A,v2_B) then renderer.triangle(v2_C.x,v2_C.y,v2_A.x,v2_A.y,v2_B.x,v2_B.y,r,g,b,a)
    else renderer.triangle(v2_C.x,v2_C.y,v2_B.x,v2_B.y,v2_A.x,v2_A.y,r,g,b,a)end
end

--Pasted from internet
local function hsv_to_rgb(h, s, v)
	local r, g, b

	local i = math.floor(h * 6);
	local f = h * 6 - i;
	local p = v * (1 - s);
	local q = v * (1 - f * s);
	local t = v * (1 - (1 - f) * s);

	i = i % 6

	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end

	return r * 255, g * 255, b * 255
end

local function world_circle(origin, size)
    if origin[1] == nil then
        return
    end

    local last_point = nil

    --Get shit
    local gradient_g = ui.get(gradient)
    local color_g = {ui.get(color)}

    for i = 0, 360, 5 do
        local new_point = { --Rotate point
            origin[1] - (math.sin(math.rad(i)) * size),
            origin[2] - (math.cos(math.rad(i)) * size),
            origin[3]
        }

        local actual_color = color_g

        if (gradient_g) then
            local hue_offset = 0

            hue_offset = ((globals.realtime() * (ui.get(speed) * 50)) + i) % 360
            hue_offset = math.min(360, math.max(0, hue_offset))

            local r, g, b = hsv_to_rgb(hue_offset / 360, 1, 1)

            color_g = {r, g, b, 255}
        end

        --Draw line and polygon
        if last_point ~= nil then
            local old_screen_point = {renderer.world_to_screen(last_point[1], last_point[2], last_point[3])}
            local new_screen_point = {renderer.world_to_screen(new_point[1], new_point[2], new_point[3])}
            local origin_screen_point = {renderer.world_to_screen(origin[1], origin[2], origin[3] + 8)}

            if old_screen_point[1] ~= nil and new_screen_point[1] ~= nil and origin_screen_point[1] ~= nil then
                renderer_triangle({x = old_screen_point[1], y = old_screen_point[2]}, {x = new_screen_point[1], y = new_screen_point[2]}, {x = origin_screen_point[1], y = origin_screen_point[2]}, color_g[1], color_g[2], color_g[3], 50)     
                renderer.line(old_screen_point[1], old_screen_point[2], new_screen_point[1], new_screen_point[2], color_g[1], color_g[2], color_g[3], 255)
            end
        end

        --Update
        last_point = new_point
    end
end

client.set_event_callback("paint_ui", function()
    --Menu elements
    local master_state = ui.get(enable)
    ui.set_visible(color, master_state)
    ui.set_visible(gradient, master_state)
    ui.set_visible(speed, master_state and ui.get(gradient))
    
    --make actual hat
    if not master_state or (not ui.get(thirdperson[1]) or not ui.get(thirdperson[2])) or lp() == nil or entity.is_alive(lp()) == false then
        return
    end

    world_circle({entity.hitbox_position(lp(), 0)}, 10)
end)