-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local vector = require "vector"

local enable = ui.new_checkbox("Visuals", "Other ESP", "Molotov indicator")
local molotov_color = ui.new_color_picker("Visuals", "Other ESP", "Molotov indicator", 255, 20, 20, 100)

local inferno_data = {}

local function signedArea(p, q, r)
    local cross = (q.y - p.y) * (r.x - q.x)
                - (q.x - p.x) * (r.y - q.y)
    return cross
  end
  
local function isCCW(p, q, r) return signedArea(p, q, r) < 0 end
  
local function jarvis_march(points)
    local numPoints = #points
    if numPoints < 3 then return end

    local leftMostPointIndex = 1
    for i = 1, numPoints do
        if points[i].x < points[leftMostPointIndex].x then
        leftMostPointIndex = i
        end
    end

    local p = leftMostPointIndex
    local hull = {}

    repeat
        q = points[p + 1] and p + 1 or 1
        for i = 1, numPoints, 1 do
        if isCCW(points[p], points[i], points[q]) then q = i end
        end

        table.insert(hull, points[q])
        p = q
    until (p == leftMostPointIndex)

    return hull
end
  

local function get_inferno_data (inferno)
    local inferno_data = {
        positions = {},
        triangles = {}
    }

    local origin = vector(entity.get_prop(inferno, "m_vecOrigin"))

    for i=0, 63 do
        if entity.get_prop(inferno, "m_bFireIsBurning", i) == 1 then

          local x = entity.get_prop(inferno, "m_fireXDelta", i)
          local y = entity.get_prop(inferno, "m_fireYDelta", i)
          local z = entity.get_prop(inferno, "m_fireZDelta", i)

          local delta_vec = vector(x, y, z)

          table.insert(inferno_data.positions, origin + delta_vec)
        end
    end

    local points = jarvis_march(inferno_data.positions)

    if points and #points > 2 then
        for i=1, #points, 1 do
            local current = points[i]
            local next = points[i + 1] or points[1]

            table.insert(inferno_data.triangles, {
                a = current,
                b = next,
                c = origin
            })
        end
    end

    return inferno_data
end

local function on_net_update_end ()
    local infernos_all = entity.get_all("CInferno")
    local infernos_data = {}

    for _, inferno in ipairs(infernos_all) do
        local data = get_inferno_data(inferno)

        if data then
            table.insert(infernos_data, data)
        end
    end

    inferno_data = infernos_data
end


local function draw_inferno (inferno)
    local base_pos = inferno.origin

    if #inferno.triangles == 0 then
        return
    end

    local molotov_color = {ui.get(molotov_color)}

    for _, triangle in ipairs(inferno.triangles) do
        local a_w2s = vector(renderer.world_to_screen(triangle.a:unpack()))
        local b_w2s = vector(renderer.world_to_screen(triangle.b:unpack()))
        local c_w2s = vector(renderer.world_to_screen(triangle.c:unpack()))

        if a_w2s:length() ~= 0 and b_w2s:length() ~= 0 or c_w2s:length() ~= 0 then
            renderer.triangle(a_w2s.x, a_w2s.y, b_w2s.x, b_w2s.y, c_w2s.x, c_w2s.y, unpack(molotov_color))
        end
    end

end

local function on_paint ()
    for _, inferno in ipairs(inferno_data) do
        draw_inferno(inferno)
    end
end

ui.set_callback(enable, function()
    local callback = ui.get(enable) and client.set_event_callback or client.unset_event_callback

    callback("net_update_end", on_net_update_end)
    callback("paint", on_paint)
end)