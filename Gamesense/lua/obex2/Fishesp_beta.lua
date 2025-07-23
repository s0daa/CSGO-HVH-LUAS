-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local vector = require 'vector'

local round = function(value) return math.floor(value + 0.5) end
local contains = function(b,c)for d=1,#b do if b[d]==c then return true end end;return false end
local lerp = function(a, b, t) return a + (b - a) * t end
local get_distance = function(a, b) return a:dist(b) end

local tab, container = 'VISUALS', 'Other ESP'
local interface = {
    enabled = ui.new_checkbox(tab, container, 'Fish'),
    options = ui.new_multiselect(tab, container, '\n', 'Dormant', 'Health bar', 'Bounding box', 'Name', 'Flags', 'Distance', 'Chams')
}

local fish_data = {
    { name = 'jeffy', alpha = 255 },
    { name = 'sleep', alpha = 255 },
    { name = 'freaky', alpha = 255 },
    { name = 'melly', alpha = 255 },
    { name = 'jamal', alpha = 255 },
    { name = 'andi', alpha = 255 },
    { name = 'buck', alpha = 255 },
    { name = 'jared', alpha = 255 },
    { name = 'jace', alpha = 255 },
    { name = 'glock', alpha = 255 },
    { name = 'spaghetti', alpha = 255 }
}
local fish_cache = {}

renderer.bounding_box = function(x, y, w, h, r, g, b, a)
    renderer.rectangle(x + 1, y, w - 1, 1, r, g, b, a)
    renderer.rectangle(x + w - 1, y + 1, 1, h - 1, r, g, b, a)
    renderer.rectangle(x, y + h - 1, w - 1, 1, r, g, b, a)
    renderer.rectangle(x, y, 1, h - 1, r, g, b, a)
end

local w, h = 100, 100
local on_paint = function()
    local options = ui.get(interface.options)

    local player = entity.get_local_player()
    local player_origin = vector(entity.get_origin(player))

    local chams_enabled = contains(options, 'Chams')
    if chams_enabled then
        local fish = {
            de_inferno = materialsystem.find_material("models/props/de_inferno/goldfish")
        }

        if fish.de_inferno then
            fish.de_inferno:set_material_var_flag(15, chams_enabled)
        end
    end

    local get_fish = entity.get_all('CFish')
    local use_cache = #fish_cache > #get_fish
    local fishies = use_cache and fish_cache or get_fish

    for i, fish in ipairs(fishies) do
        local lifestate = entity.get_prop(fish, 'm_lifeState')
        if lifestate == 2 then goto skip end

        local fish_origin = vector(entity.get_origin(fish))

        if not contains(fish_cache, fish) then
            table.insert(fish_cache, fish)
        end

        if fish_origin and not fish_data[i].origin_cache then
            fish_data[i].origin_cache = fish_origin
        elseif fish_origin and fish_data[i].origin_cache ~= fish_origin then
            if fish_origin.x ~= 0 or fish_origin.y ~= 0 or fish_origin.z ~= 0 then
                fish_data[i].origin_cache = fish_origin
            end
        end

        local dormant = contains(fish_cache, fish) and not contains(get_fish, fish)

        fish_origin = dormant and fish_data[i].origin_cache or fish_origin

        local fish_pos = vector(renderer.world_to_screen(fish_origin:unpack()))

        if not fish_pos.x or fish_pos.x == 0 then goto skip end
        if not fish_pos.y or fish_pos.y == 0 then goto skip end

        local timing = contains(options, 'Dormant') and 0.6 or 6
        fish_data[i].alpha = dormant and lerp(fish_data[i].alpha, 0, globals.frametime() * timing) or 255

        local distance = get_distance(player_origin, fish_origin)
        local feet = distance * 2 / 30.48

        local scale = 1 / (feet / 10)
        local w, h = w * scale, h * scale

        local x1, y1, x2, y2 = fish_pos.x - w / 2, fish_pos.y - h / 2, fish_pos.x + w / 2, fish_pos.y + h / 2

        local alpha = fish_data[i].alpha

        if contains(options, 'Bounding box') then
            local clr = dormant and {143, 141, 138} or {255, 255, 255}

            renderer.bounding_box(x1 - 1, y1 - 1, x2 - x1 + 2, y2 - y1 + 2, 0, 0, 0, alpha/1.5)
            renderer.bounding_box(x1, y1, x2 - x1, y2 - y1, clr[1], clr[2], clr[3], alpha)
            renderer.bounding_box(x1 + 1, y1 + 1, x2 - x1 - 2, y2 - y1 - 2, 0, 0, 0, alpha/1.5)
        end

        if contains(options, 'Name') then
            local clr = dormant and {143, 141, 138} or {255, 255, 255}

            renderer.text(x1/2 + x2/2, y1 - 8, clr[1], clr[2], clr[3], alpha, 'c', 0, 'le fishe')
        end

        if contains(options, 'Flags') and not dormant then
            renderer.text(x2 + 2, y1, 132, 192, 43, alpha, '-', 0, '$0')
            renderer.text(x2 + 2, y1 + 10, 212, 241, 249, alpha, '-', 0, 'SWIM')
        end

        if contains(options, 'Health bar') then
            local clr = dormant and {143, 141, 138} or {120, 225, 80}

            renderer.rectangle(x1 - 6, y1 - 1, x2 - x2 + 4, y2 - y1 + 2, 0, 0, 0, alpha/1.5)
            renderer.rectangle(x1 - 5, y1, x2 - x2 + 2, y2 - y1, clr[1], clr[2], clr[3], alpha)
        end

        if contains(options, 'Distance') then
            local clr = dormant and {143, 141, 138} or {255, 255, 255}

            feet = round(feet) - round(feet) % 5

            renderer.text(x1/2 + x2/2, y2 + 6, clr[1], clr[2], clr[3], alpha, 'c-', 0, string.format('%sFT', feet))
        end

        ::skip::
    end
end

-- function vector_angles(vec)
--     return vector(math.deg(math.atan2(-vec.z, vec:length2d())), math.deg(math.atan2(vec.y, vec.x)), 0)
-- end

-- function angle_vectors(angle)
--     local forward = vector(0, 0, 0)
--     local right = vector(0, 0, 0)
--     local up = vector(0, 0, 0)

--     local cp = math.cos(math.rad(angle.x))
--     local sp = math.sin(math.rad(angle.x))
--     local cy = math.cos(math.rad(angle.y))
--     local sy = math.sin(math.rad(angle.y))
--     local cr = math.cos(math.rad(angle.z))
--     local sr = math.sin(math.rad(angle.z))

-- 	forward = vector(
--         cp * cy,
-- 	    cp * sy,
-- 	    -sp
--     )

--     right = vector(
--         -1 * sr * sp * cy + -1 * cr * -sy,
--         -1 * sr * sp * sy + -1 * cr * cy,
--         -1 * sr * cp
--     )

--     up = vector(
--         cr * sp * cy + -sr * -sy,
--         cr * sp * sy + -sr * cy,
--         cr * cp
--     )
    
--     return forward, right, up
-- end

-- local get_fov = function(viewangles, start_pos, end_pos)
-- 	local delta = (end_pos - start_pos):normalized()
-- 	local fov = math.acos(viewangles:dot(delta) / delta:length())

-- 	return math.max(0, math.deg(fov))
-- end

-- local targets = {}
-- local on_setup = function(cmd)
--     local local_player = entity.get_local_player()
--     local is_alive = entity.is_alive(local_player)
--     if not local_player or not is_alive then
--         return
--     end

--     local m_flNextAttack = entity.get_prop(local_player, 'm_flNextAttack')
-- 	if m_flNextAttack > globals.curtime() then
-- 		return
-- 	end

--     local fishies = entity.get_all('CFish')

--     local eye_angles = vector(client.camera_angles())
--     local eye_pos = vector(client.eye_position())
--     local forward = angle_vectors(eye_angles)

--     for i, fish in ipairs(fishies) do
--         local lifestate = entity.get_prop(fish, 'm_lifeState')
--         if lifestate == 2 then 
--             table.remove(targets, i)
--             goto skip
--         end

--         local fish_origin = vector(entity.get_origin(fish))

--         if not fish_origin then goto skip end

--         local fov = get_fov(forward, eye_pos, fish_origin)

--         local target = {
--             ent = fish,
--             pos = fish_origin,
--             fov = fov
--         }

--         if not targets[i] and lifestate ~= 2 then
--             table.insert(targets, i, target)
--         end

--         if targets[i] then
--             targets[i].pos = fish_origin
--             targets[i].fov = fov
--         end

--         table.sort(targets, function(a, b)
--             if not a or not b then return end
--             return a.fov < b.fov
--         end)

--         local top = targets[1]

--         if top then
--             local aim = vector_angles(top.pos - eye_pos)
--             -- client.camera_angles(aim.x, aim.y, 0)
            
--         cmd.pitch = aim.x
--         cmd.yaw = aim.y

--         -- +attack here man
--         client.exec('attack')
--         end


--         ::skip::
--     end
-- end

local handle_interface = function()
    ui.set_visible(interface.options, ui.get(interface.enabled))
end

local handle_tables = function()
    fishies = {}

    local fish = {
        de_inferno = materialsystem.find_material("models/props/de_inferno/goldfish")
    }

    if fish.de_inferno then
        fish.de_inferno:set_material_var_flag(15, false)
    end
end

local handle_callbacks = function(self)
    local handle = ui.get(self) and client.set_event_callback or client.unset_event_callback

    handle('paint', on_paint)

    handle('player_death', handle_tables)
    handle('round_start', handle_tables)
    handle('client_disconnect', handle_tables)
    handle('game_newmap', handle_tables)
    handle('cs_game_disconnected', handle_tables)

    handle('shutdown', handle_tables)
end
ui.set_callback(interface.enabled, function()
    handle_interface()
    handle_callbacks(interface.enabled)
end)
handle_interface()