-- { References }
local alive_thirdperson = menu.find("visuals","other","thirdperson","enable")
local cam_idealdist = menu.find("visuals","other","thirdperson","distance")
-- { Menu }
local thirdperson_animation         = menu.add_checkbox("Effects", "Thirdperson animation")
local thirdperson_distance          = menu.add_slider( "Effects", "Thirdperson distance", 0, 100 )
local thirdperson_speed          = menu.add_slider( "Effects", "Thirdperson speed", 0, 100 )
-- { Util }
local function animation(check, name, value, speed) 
    if check then 
        return name + (value - name) * global_vars.frame_time() * speed 
    else 
        return name - (value + name) * global_vars.frame_time() * speed -- add / 2 if u want goig back effect
        
    end
end
-- { Animation }
local animation_amt = 0
local on_thirdperson_animation = function ()
    if thirdperson_animation:get() then
        animation_amt = animation(alive_thirdperson[2]:get(), animation_amt, thirdperson_distance:get(), thirdperson_speed:get())
        cam_idealdist:set(animation_amt)
    end
end
-- { Callbacks }
callbacks.add(e_callbacks.PAINT, function()
    thirdperson_distance:set_visible(thirdperson_animation:get())
    thirdperson_speed:set_visible(thirdperson_animation:get())
on_thirdperson_animation()
end)