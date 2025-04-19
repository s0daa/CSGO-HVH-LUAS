local entity_get_prop = entity.get_prop
local ui_get = ui.get
local client_camera_angles = client.camera_angles
local fast_ladder = ui.new_multiselect("MISC", "Movement", "Fast ladder", "Ascending", "Descending")
local ladder_yaw_checkbox = ui.new_checkbox("AA", "Anti-aimbot angles", "Ladder yaw")
local ladder_yaw_slider = ui.new_slider("AA", "Anti-aimbot angles", "\nLadder yaw", -180, 180, 0, true, "°")

local function contains(tbl, val) 
    for i=1, #tbl do
        if tbl[i] == val then return true end 
    end 
    return false 
end

client.set_event_callback("setup_command", function(e)
    local local_player = entity.get_local_player()
    local pitch, yaw = client_camera_angles()
    if entity_get_prop(local_player, "m_MoveType") == 9 then
        e.yaw = math.floor(e.yaw+0.5)
        e.roll = 0
        if ui_get(ladder_yaw_checkbox) then
            if e.forwardmove == 0 then
                e.pitch = 89
                e.yaw = e.yaw + ui_get(ladder_yaw_slider)
                if math.abs(ui_get(ladder_yaw_slider)) > 0 and math.abs(ui_get(ladder_yaw_slider)) < 180 and e.sidemove ~= 0 then
                    e.yaw = e.yaw - ui_get(ladder_yaw_slider)
                end
                if math.abs(ui_get(ladder_yaw_slider)) == 180 then
                    if e.sidemove < 0 then
                        e.in_moveleft = 0
                        e.in_moveright = 1
                    end
                    if e.sidemove > 0 then
                        e.in_moveleft = 1
                        e.in_moveright = 0
                    end
                end
            end
        end

        if contains(ui_get(fast_ladder), "Ascending") then
            if e.forwardmove > 0 then
                if pitch < 45 then
                    e.pitch = 89
                    e.in_moveright = 1
                    e.in_moveleft = 0
                    e.in_forward = 0
                    e.in_back = 1
                    if e.sidemove == 0 then
                        e.yaw = e.yaw + 90
                    end
                    if e.sidemove < 0 then
                        e.yaw = e.yaw + 150
                    end
                    if e.sidemove > 0 then
                        e.yaw = e.yaw + 30
                    end
                end 
            end
        end
        if contains(ui_get(fast_ladder), "Descending") then
            if e.forwardmove < 0 then
                e.pitch = 89
                e.in_moveleft = 1
                e.in_moveright = 0
                e.in_forward = 1
                e.in_back = 0
                if e.sidemove == 0 then
                    e.yaw = e.yaw + 90
                end
                if e.sidemove > 0 then
                    e.yaw = e.yaw + 150
                end
                if e.sidemove < 0 then
                    e.yaw = e.yaw + 30
                end
            end
        end
    end
end)