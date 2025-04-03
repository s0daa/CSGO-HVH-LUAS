local yddyaw = menu.find("antiaim","main","angles","yaw add")
local tank_sw = menu.add_checkbox("Tank AA", "Enable", true)
local tank_yaw = menu.add_slider("Tank AA", "Delta", 1, 90)
function on_paint()
    tank_yaw:set_visible(tank_sw:get())
    if not tank_sw:get() then
        return
    end
    
    x = math.random(0, 1)
    if x == 1 then
        yddyaw:set(tank_yaw:get())
    else
        yddyaw:set(0-tank_yaw:get())
    end
end
callbacks.add(e_callbacks.PAINT, on_paint)