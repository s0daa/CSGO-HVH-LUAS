--- @region: prepare helpers
table.contains = function(source, target)
    local source_element = ui.get(source)
    for id, name in pairs(source_element) do
        if name == target then
            return true
        end
    end

    return false
end

local c_entity = require("gamesense/entity")
local E_POSE_PARAMETERS = {
    STRAFE_YAW = 0,
    STAND = 1,
    LEAN_YAW = 2,
    SPEED = 3,
    LADDER_YAW = 4,
    LADDER_SPEED = 5,
    JUMP_FALL = 6,
    MOVE_YAW = 7,
    MOVE_BLEND_CROUCH = 8,
    MOVE_BLEND_WALK = 9,
    MOVE_BLEND_RUN = 10,
    BODY_YAW = 11,
    BODY_PITCH = 12,
    AIM_BLEND_STAND_IDLE = 13,
    AIM_BLEND_STAND_WALK = 14,
    AIM_BLEND_STAND_RUN = 14,
    AIM_BLEND_CROUCH_IDLE = 16,
    AIM_BLEND_CROUCH_WALK = 17,
    DEATH_YAW = 18
}

local is_on_ground = false
local slidewalk_directory = ui.reference("AA", "other", "leg movement")
--- @endregion

--- @region: prepare menu elements
local m_elements = ui.new_multiselect("AA", "Fake lag", "Old elements", {"Adjust body lean", "Slide slow-walking", "Reset pitch on land", "Break legs while in air", "Break legs while landing"})

local slide_elements = ui.new_multiselect("AA", "Fake lag", "Sliding elements", {"While walking", "While running", "While crouching"})
local body_lean_value = ui.new_slider("AA", "Fake lag", "Body lean value", 0, 10000, 0, true, "%", 0.01, {[0] = "Disabled", [35] = "Small", [50] = "Medium", [75] = "High", [100] = "Extreme", [10000] = "ahuet1"})
local break_air_value = ui.new_slider("AA", "Fake lag", "Breakable air value", 0, 10, 5, true, "%", 0.1, {[0] = "Disabled", [5] = "Default", [10] = "Maximum"})
local break_land_value = ui.new_slider("AA", "Fake lag", "Breakable land value", 0, 10, 5, true, "%", 0.1, {[0] = "Slowest", [5] = "Fastest", [10] = "Disabled"})

local adjust_visibility = function()
    ui.set_visible(body_lean_value, table.contains(m_elements, "Adjust body lean"))
    ui.set_visible(slide_elements, table.contains(m_elements, "Slide slow-walking"))
    ui.set_visible(break_air_value, table.contains(m_elements, "Break legs while in air"))
    ui.set_visible(break_land_value, table.contains(m_elements, "Break legs while landing"))
end

adjust_visibility()
ui.set_callback(m_elements, adjust_visibility)
--- @endregion

--- @region: process main work
client.set_event_callback("setup_command", function(cmd)
    is_on_ground = cmd.in_jump == 0

    if table.contains(m_elements, "Break legs while landing") then
        ui.set(slidewalk_directory, cmd.command_number % 3 == 0 and "Off" or "Always slide")
    end
end)

client.set_event_callback("pre_render", function()
    local self = entity.get_local_player()
    if not self or not entity.is_alive(self) then
        return
    end

    local self_index = c_entity.new(self)
    local self_anim_state = self_index:get_anim_state()

    if not self_anim_state then
        return
    end

    if table.contains(m_elements, "Slide slow-walking") then
        if table.contains(slide_elements, "While walking") then
            entity.set_prop(self, "m_flPoseParameter", 0, E_POSE_PARAMETERS.MOVE_BLEND_WALK)
        end

        if table.contains(slide_elements, "While running") then
            entity.set_prop(self, "m_flPoseParameter", 0, E_POSE_PARAMETERS.MOVE_BLEND_RUN)
        end

        if table.contains(slide_elements, "While crouching") then
            entity.set_prop(self, "m_flPoseParameter", 0, E_POSE_PARAMETERS.MOVE_BLEND_CROUCH)
        end
    end

    if table.contains(m_elements, "Break legs while in air") then
        entity.set_prop(self, "m_flPoseParameter", ui.get(break_air_value) / 10, E_POSE_PARAMETERS.JUMP_FALL)
    end

    if table.contains(m_elements, "Break legs while landing") then
        entity.set_prop(self, "m_flPoseParameter", E_POSE_PARAMETERS.STAND, globals.tickcount() % 4 > 1 and ui.get(break_land_value) / 10 or 1)
    end
    
    if table.contains(m_elements, "Adjust body lean") then
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then
            return
        end

        local x_velocity = entity.get_prop(self, "m_vecVelocity[0]")
        if math.abs(x_velocity) >= 3 then
            self_anim_overlay.weight = ui.get(body_lean_value) / 100
        end
    end

    if table.contains(m_elements, "Reset pitch on land") then
        if not self_anim_state.hit_in_ground_animation or not is_on_ground then
            return
        end

        entity.set_prop(self, "m_flPoseParameter", 0.5, E_POSE_PARAMETERS.BODY_PITCH)
    end 
end)
--- @endregion