local counter_clockwise = function(point_1, point_2, point_3)
    return ((point_3.y - point_1.y) * (point_2.x - point_1.x)) > ((point_2.y - point_1.y) * (point_3.x - point_1.x))
end

local line_intersect = function(line1_p1, line1_p2, line2_p1, line2_p2)
    return (counter_clockwise(line1_p1, line2_p1, line2_p2) ~= counter_clockwise(line1_p2, line2_p1, line2_p2))
            and (counter_clockwise(line1_p1, line1_p2, line2_p1) ~= counter_clockwise(line1_p1, line1_p2, line2_p2))
end

local ray_cast = function(point_1, point_2, polygon)
    local intersects = 0

    for i = 1, #polygon + 1 do
        if (i ~= 1) then
            if (i <= #polygon) then
                if (line_intersect(point_1, point_2, polygon[i], polygon[i - 1])) then
                    intersects = intersects + 1
                end
            else
                if (line_intersect(point_1, point_2, polygon[1], polygon[i - 1])) then
                    intersects = intersects + 1
                end
            end
        end
    end

    return intersects
end

input.is_point_in_polygon = function(polygon, point_in)
    if (not point_in) then point_in = input.get_mouse_pos() end
    local intersections = ray_cast(point_in, vec2_t(0, 0), polygon)

    if (intersections == 0 or not intersections) then
        return false
    elseif (intersections % 2 == 0) then
        return false
    else
        return true
    end
end

input.is_point_in_circle = function(point, radius, point_in)
    if (not point_in) then point_in = input.get_mouse_pos() end
    local distance = math.sqrt((point.x - point_in.x)^2 + (point.y - point_in.y)^2)

    if (distance <= radius) then
        return true
    end

    return false
end

input.is_point_in_rectangle = function(pos, size, radius, point_in)
    local function check_bounds(pos, size, point)
        if (point.x >= pos.x and point.x <= pos.x + size.x) then
            if (point.y >= pos.y and point.y <= pos.y + size.y) then
                return true
            end
        end

        return false
    end

    if (not point_in) then point_in = input.get_mouse_pos() end
    if (not radius or radius == 0) then return check_bounds(pos, size, point_in) end

    local points = {
        corners = {
            vec2_t(pos.x + radius, pos.y + radius), -- top left
            vec2_t(pos.x + size.x - radius, pos.y + radius), -- top right
            vec2_t(pos.x + radius, pos.y + size.y - radius), -- bottom left
            vec2_t(pos.x + size.x - radius, pos.y + size.y - radius), -- bottom right
        },
        body = {
            {
                pos = vec2_t(pos.x, pos.y + radius),
                size = vec2_t(size.x, size.y - radius * 2)
            },
            {
                pos = vec2_t(pos.x + radius, pos.y),
                size = vec2_t(size.x - radius * 2, size.y)
            }
        }
    }

    local in_bounds = false

    for i = 1, #points.corners do
        if (not in_bounds and input.is_point_in_circle(points.corners[i], radius, point_in)) then
            in_bounds = true
        end
    end

    if (not in_bounds) then
        if (check_bounds(points.body[1].pos, points.body[1].size, point_in) or check_bounds(points.body[2].pos, points.body[2].size, point_in)) then
            in_bounds = true
        end
    end

    return in_bounds
end