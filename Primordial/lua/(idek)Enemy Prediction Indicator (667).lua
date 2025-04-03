--Enemy Prediction Indicator--
ffi.cdef [[
    typedef void*(__thiscall* shell_execute_t)(void*, const char*, const char*); 
]] 

local cp = ffi.typeof('void***')
local vgui = memory.create_interface('vgui2.dll', 'VGUI_System010')
local ivgui = ffi.cast(cp,vgui)
local ShellExecuteA = ffi.cast("shell_execute_t", ivgui[0][3])

local info1 = menu.add_text("Info", "Enemy Prediction Indicator | Dawio89⋕9849")
local info2 = menu.add_text("Info", "")
local info3 = menu.add_text("Info", string.format("Hello %s dm me if you have any issues/questions", user.name))
local info4 = menu.add_text("Info", "Visit my Discord for giveaway's and new lua releases!")

local open = menu.add_button("Info", "AUTISTIC Discord", function()
    ShellExecuteA(ivgui, 'open', "https://discord.com/invite/tjjEuCc4Uf")
end)
menu.set_group_column("Info", 2)

local max_distance = menu.add_slider("Enemy Prediction Indicator", "Maximum Render Distance", 0, 5000)
local color_reference_predicted = menu.add_text("Enemy Prediction Indicator", "Predicted Position Color")
local color_reference_current = menu.add_text("Enemy Prediction Indicator", "Current Position Color")
local predicted_color = color_reference_predicted:add_color_picker("Predicted color", color_t(0, 255, 0))
local current_color = color_reference_current:add_color_picker("Current color", color_t(255, 0, 0))
menu.set_group_column("Enemy Prediction Indicator", 1)

local saved_abs_origin = vec3_t(0, 0, 0)
local saved_vec_entity_velocity = vec3_t(0, 0, 0)
local sphere_timeout = 0
local prediction_sphere_timeout = 0
local predicted_origin = vec3_t(0, 0, 0)

max_distance:set(1500)

local function predict_enemy_positions(time, closest_enemy)
    local predicted_positions = {}
    if closest_enemy ~= nil then
        local abs_origin = closest_enemy:get_prop("m_vecAbsOrigin")
        local vec_entity_velocity = closest_enemy:get_prop("m_vecVelocity")
        local predicted_origin = vec3_t(abs_origin.x + vec_entity_velocity.x * time, abs_origin.y + vec_entity_velocity.y * time, abs_origin.z + vec_entity_velocity.z * time)
        table.insert(predicted_positions, predicted_origin)
    end
    return predicted_positions
end


local function on_paint()
    local local_player = entity_list.get_local_player()
    if not local_player then return end

    local player_origin = entity_list.get_local_player():get_prop("m_vecAbsOrigin")
    local closest_enemy = nil
    local closest_distance = math.huge

    local enemies_only = entity_list.get_players(true)
    for _,enemy in pairs(enemies_only) do
        local abs_origin = enemy:get_prop("m_vecAbsOrigin")
        local distance = abs_origin:dist(player_origin)
        if distance < closest_distance and enemy:is_alive() then
            closest_enemy = enemy
            closest_distance = distance
        elseif closest_distance > math.abs(max_distance:get()) then
            closest_enemy = nil
        end
    end

    if closest_enemy ~= nil then
        local abs_origin = closest_enemy:get_prop("m_vecAbsOrigin")
        saved_abs_origin = abs_origin
        saved_vec_entity_velocity = closest_enemy:get_prop("m_vecVelocity")
        sphere_timeout = globals.cur_time() + 0.5

        if globals.cur_time() < sphere_timeout and saved_abs_origin ~= abs_origin + saved_vec_entity_velocity then
            debug_overlay.add_sphere(vec3_t(saved_abs_origin.x, saved_abs_origin.y, saved_abs_origin.z), 5, 20, 5, color_t(current_color:get().r, current_color:get().g, current_color:get().b), client.ticks_to_time(1))
        end

        local predicted_positions = predict_enemy_positions(0.2, closest_enemy)

        prediction_sphere_timeout = globals.cur_time() + 0.5
        for _,predicted_origin in pairs(predicted_positions) do
            if saved_abs_origin ~= abs_origin + saved_vec_entity_velocity then
            debug_overlay.add_sphere(vec3_t(predicted_origin.x, predicted_origin.y, predicted_origin.z), 15, 20, 5, color_t(predicted_color:get().r, predicted_color:get().g, predicted_color:get().b), client.ticks_to_time(1))
            local from = render.world_to_screen(vec3_t(abs_origin.x, abs_origin.y, abs_origin.z))
            local to = render.world_to_screen(vec3_t(predicted_origin.x, predicted_origin.y, predicted_origin.z))
                if from ~= nil and to ~= nil then
                    render.line(from, to, color_t(255, 255, 255))
                end
            end
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)