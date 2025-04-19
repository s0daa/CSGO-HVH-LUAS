local ui_get = ui.get
local client_set_event_callback = client.set_event_callback
local client_console_cmd = client.exec
local client_camera_angles = client.camera_angles
local client_delay_call = client.delay_call
local smokefeet = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Throw Smoke At Your Feet")
local smokefeethotkey = ui.new_hotkey("AA", "Anti-Aimbot Angles", "Smoke Hotkey")

local function on_paint(c)
    if ui_get(smokefeet) then
        if ui_get(smokefeethotkey) then
            client_console_cmd("use weapon_smokegrenade")
            client_delay_call(0.845, function(on_paint)
                client_camera_angles(90,0)
                client_console_cmd("+attack2")
                client.delay_call(0.25, function(on_paint)
                    client_console_cmd("-attack2") 
                    client_delay_call(0.7, function(on_paint)
                        client_console_cmd("slot2")
                        client_console_cmd("slot1")
                    end)
                end)
            end)
        end
    end
end

client_set_event_callback("paint", on_paint)