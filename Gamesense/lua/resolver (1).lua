
local ffi = require("ffi")


ffi.cdef[[
    typedef struct {
        float x, y, z;
    } Vector;

    void* malloc(size_t size);
    void free(void* ptr);
]]


local resolver_active = ui.new_checkbox("RAGE", "Other", "Enable Advanced Resolver")
local normal_resolver_active = ui.new_checkbox("RAGE", "Other", "Enable Normal Resolver")
local smart_baim_active = ui.new_checkbox("RAGE", "Other", "Enable Smart Baim")
local hp_based_resolver_active = ui.new_hotkey("RAGE", "Other", "HP Based Resolver")
local adaptive_resolver_active = ui.new_checkbox("RAGE", "Other", "Enable Adaptive Resolver")
local profile_manager_active = ui.new_button("RAGE", "Other", "Manage Profiles", function() end)
local anti_aim_correction_active = ui.new_checkbox("RAGE", "Other", "Enable Anti-Aim Correction")
local enhanced_visuals_active = ui.new_checkbox("RAGE", "Other", "Enable Enhanced Visuals")


local aggressive_resolver_active = ui.new_checkbox("RAGE", "Other", "Aggressive Resolver")
local precise_resolver_active = ui.new_checkbox("RAGE", "Other", "Precise Resolver")

local yaw_angles = {}
for i = -180, 180, 15 do
    table.insert(yaw_angles, i)
end

local angle_index = 1
local target_angles = {}
local missed_shots = 0
local max_missed_shots = 5


local function save_resolver_angle(player_index, angle)
    database.write("resolver_angle_" .. player_index, angle)
end

local function get_resolver_angle(player_index)
    return database.read("resolver_angle_" .. player_index)
end


local function normal_resolver(target)
    local yaw = ffi.new("float", entity.get_prop(target, "m_angEyeAngles[1]"))
    if yaw > 0 then
        yaw = yaw - 180
    else
        yaw = yaw + 180
    end
    entity.set_prop(target, "m_angEyeAngles[1]", yaw)
end


local function aggressive_resolver(target)

    local yaw = entity.get_prop(target, "m_angEyeAngles[1]")
    local velocity = entity.get_prop(target, "m_vecVelocity[0]")

    if velocity > 100 then
        yaw = yaw + 45
    else
        yaw = yaw + 25
    end
    entity.set_prop(target, "m_angEyeAngles[1]", yaw)
    client.log("агрресив рез изменен на" .. yaw)
end


local function precise_resolver(target)

    local yaw = entity.get_prop(target, "m_angEyeAngles[1]")
    local health = entity.get_prop(target, "m_iHealth")


    if health > 50 then
        yaw = yaw + 10
    else
        yaw = yaw - 10
    end
    entity.set_prop(target, "m_angEyeAngles[1]", yaw)
    client.log("резик изменен на " .. yaw)
end


local function select_hitbox_based_on_hp(target)
    local health = entity.get_prop(target, "m_iHealth")
    
    if health > 75 then
        return "head" 
    elseif health > 35 then
        return "chest" 
    else
        return "stomach"
    end
end


client.set_event_callback("aim_miss", function(event)
    local target = event.target

    if ui.get(normal_resolver_active) then
        normal_resolver(target) 
        return
    end

    if ui.get(adaptive_resolver_active) then
        adaptive_resolver(target) 
        return
    end

    if not ui.get(resolver_active) then return end


    if ui.get(aggressive_resolver_active) then
        aggressive_resolver(target)
    elseif ui.get(precise_resolver_active) then
        precise_resolver(target)
    else

        local current_angle = yaw_angles[angle_index]

        if target_angles[target] then
            current_angle = target_angles[target]
        else
            angle_index = angle_index + 1
            if angle_index > #yaw_angles then
                angle_index = 1
                missed_shots = missed_shots + 1
            end
        end

        if missed_shots > max_missed_shots then
            missed_shots = 0
            angle_index = angle_index + 1
            if angle_index > #yaw_angles then
                angle_index = 1
            end
        end

        entity.set_prop(target, "m_angEyeAngles[1]", current_angle)
        client.log("мисс по  " .. target .. ", пробуем угол: " .. current_angle)
    end
end)

client.set_event_callback("aim_hit", function(event)
    if not ui.get(resolver_active) then return end

    local target = event.target
    local current_angle = yaw_angles[angle_index]

    save_resolver_angle(target, current_angle)
    target_angles[target] = current_angle
    client.log("хит по " .. target .. " яв сохранен: " .. current_angle)

    missed_shots = 0
end)


client.set_event_callback("aim_fire", function(event)
    if not ui.get(smart_baim_active) then return end 

    local target = event.target
    local hitboxes = {"head", "chest", "stomach", "pelvis", "left_arm", "right_arm", "left_leg", "right_leg"}
    local best_hitbox = nil
    local best_damage = 0

    for _, hitbox in ipairs(hitboxes) do
        local x, y, z = entity.hitbox_position(target, hitbox)
        

        if x and y and z then
            local from_x, from_y, from_z = client.eye_position() 
            local trace_entindex, damage = client.trace_bullet(entity.get_local_player(), from_x, from_y, from_z, x, y, z, true)
            
            if damage > best_damage then
                best_damage = damage
                best_hitbox = hitbox
            end
        end
    end

    if best_hitbox then
        client.log("трай хит Smart Baim: " .. best_hitbox .. " приблизительный хит : " .. best_damage)
    else
        client.log("нету хитбокса для Smart Baim")
    end
end)

