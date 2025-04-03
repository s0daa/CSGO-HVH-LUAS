local checkboxads = menu.add_checkbox("Aim Down Sight", "Enable")
local keybindads = checkboxads:add_keybind("ADS Bind")

local menu_elems = {

textads = menu.add_text("Aim Down Sight", "Default Viewmodel Offsets"),
xset = menu.add_slider("Aim Down Sight", "z add", -10, 10,0.1,2),
yset = menu.add_slider("Aim Down Sight", "y add", -10, 10,0.1,2),
zset = menu.add_slider("Aim Down Sight", "z add", -10, 10,0.1,2),
rset = menu.add_slider("Aim Down Sight", "r add", -10, 10,0.1,2),

xadd = menu.find("visuals", "other", "general","viewmodel offsets", "x add"),
yadd = menu.find("visuals", "other", "general","viewmodel offsets", "y add"),
zadd = menu.find("visuals", "other", "general","viewmodel offsets", "z add"),
radd = menu.find("visuals", "other", "general","viewmodel offsets", "roll add"),
}
local handle_menu = function()
local masterebd = checkboxads:get(1)
menu_elems.xset:set_visible(masterebd)
menu_elems.yset:set_visible(masterebd)
menu_elems.zset:set_visible(masterebd)
menu_elems.rset:set_visible(masterebd)

menu_elems.textads:set_visible(masterebd)

end
function do_aim_down_sights()
    if not engine.is_connected() then return end
      
    if not engine.is_in_game() then return end
      
    local local_player = entity_list.get_local_player()
      
    if not local_player:get_prop("m_iHealth") then return end

local weapon = entity_list.get_entity(local_player:get_prop("m_hActiveWeapon"))
local weapon_name = weapon:get_name()
local key_toggled = keybindads:get()

local xsetvalue = menu_elems.xset:get()
local ysetvalue = menu_elems.yset:get()
local zsetvalue = menu_elems.zset:get()
local rsetvalue = menu_elems.rset:get()

	
if checkboxads:get() and local_player:is_alive() then
------USPS-----------
if weapon_name == "usp-s" and (key_toggled) then
menu_elems.xadd:set(-5.33)
menu_elems.yadd:set(1.6)
menu_elems.zadd:set(2.8)
menu_elems.radd:set(0)
else if weapon_name == "glock" and (key_toggled) then
menu_elems.xadd:set(-5.33)
menu_elems.yadd:set(1.6)
menu_elems.zadd:set(2.95)
menu_elems.radd:set(0)
else if weapon_name == "tec9" and (key_toggled) then
menu_elems.xadd:set(-7.65)
menu_elems.yadd:set(1.3)
menu_elems.zadd:set(4.0)
menu_elems.radd:set(0)
else if weapon_name == "revolver" and (key_toggled) then
menu_elems.xadd:set(-6.2)
menu_elems.yadd:set(2.3)
menu_elems.zadd:set(2.4)
menu_elems.radd:set(0)
else if weapon_name == "cz75a" and (key_toggled) then
menu_elems.xadd:set(-5.3)
menu_elems.yadd:set(2.1)
menu_elems.zadd:set(2.6)
menu_elems.radd:set(0)
else if weapon_name == "p2000" and (key_toggled) then
menu_elems.xadd:set(-5.3)
menu_elems.yadd:set(2.1)
menu_elems.zadd:set(2.6)
menu_elems.radd:set(0)
else if weapon_name == "deagle" and (key_toggled) then
menu_elems.xadd:set(-6.32)
menu_elems.yadd:set(5.7)
menu_elems.zadd:set(2.0)
menu_elems.radd:set(0)
else if weapon_name == "elite" and (key_toggled) then
menu_elems.xadd:set(-2.8)
menu_elems.yadd:set(1.3)
menu_elems.zadd:set(3.0)
menu_elems.radd:set(0)
else if weapon_name == "p250" and (key_toggled) then
menu_elems.xadd:set(-5.3)
menu_elems.yadd:set(3.2)
menu_elems.zadd:set(2.46)
menu_elems.radd:set(0)
else if weapon_name == "fiveseven" and (key_toggled) then
menu_elems.xadd:set(-5.28)
menu_elems.yadd:set(1.0)
menu_elems.zadd:set(2.38)
menu_elems.radd:set(0)
else if weapon_name == "m4a1-s" and (key_toggled) then
menu_elems.xadd:set(-7.74)
menu_elems.yadd:set(-7.0)
menu_elems.zadd:set(1.98)
menu_elems.radd:set(0)
else if weapon_name == "m4a1" and (key_toggled) then
menu_elems.xadd:set(-7.66)
menu_elems.yadd:set(-3.8)
menu_elems.zadd:set(2.15)
menu_elems.radd:set(2)
else if weapon_name == "famas" and (key_toggled) then
menu_elems.xadd:set(-8.8)
menu_elems.yadd:set(-0.4)
menu_elems.zadd:set(2.5)
menu_elems.radd:set(2)
else if weapon_name == "galilar" and (key_toggled) then
menu_elems.xadd:set(-7.83)
menu_elems.yadd:set(-5.8)
menu_elems.zadd:set(3.15)
menu_elems.radd:set(0)
else if weapon_name == "ak47" and (key_toggled) then
menu_elems.xadd:set(-7.541)
menu_elems.yadd:set(-3.3)
menu_elems.zadd:set(2.45)
menu_elems.radd:set(2)
else if weapon_name == "mac10" and (key_toggled) then
menu_elems.xadd:set(-8.7)
menu_elems.yadd:set(2.9)
menu_elems.zadd:set(3.45)
menu_elems.radd:set(2)
else if weapon_name == "mp9" and (key_toggled) then
menu_elems.xadd:set(-7.244)
menu_elems.yadd:set(-0.0)
menu_elems.zadd:set(2.34)
menu_elems.radd:set(0)
else if weapon_name == "mp5sd" and (key_toggled) then
menu_elems.xadd:set(-7.7)
menu_elems.yadd:set(-8.0)
menu_elems.zadd:set(3.22)
menu_elems.radd:set(0)
else if weapon_name == "ump45" and (key_toggled) then
menu_elems.xadd:set(-7.6)
menu_elems.yadd:set(-5.3)
menu_elems.zadd:set(2.9)
menu_elems.radd:set(0)
else if weapon_name == "p90" and (key_toggled) then
menu_elems.xadd:set(-7.69)
menu_elems.yadd:set(-8.2)
menu_elems.zadd:set(1.17)
menu_elems.radd:set(0)
else if weapon_name == "bizon" and (key_toggled) then
menu_elems.xadd:set(-7.6)
menu_elems.yadd:set(-7.4)
menu_elems.zadd:set(2.5)
menu_elems.radd:set(0)
else if weapon_name == "mp7" and (key_toggled) then
menu_elems.xadd:set(-7.82)
menu_elems.yadd:set(-1.9)
menu_elems.zadd:set(2.3)
radd:set(2)
else if weapon_name == "nova" and (key_toggled) then
menu_elems.xadd:set(-6.8)
menu_elems.yadd:set(-3.8)
menu_elems.zadd:set(4.2)
menu_elems.radd:set(0)
else if weapon_name == "xm1014" and (key_toggled) then
menu_elems.xadd:set(-6.8)
menu_elems.yadd:set(-8.4)
menu_elems.zadd:set(4.33)
menu_elems.radd:set(0)
else if weapon_name == "mag7" and (key_toggled) then
menu_elems.xadd:set(-8.89)
menu_elems.yadd:set(-0.0)
menu_elems.zadd:set(4.8)
menu_elems.radd:set(0)
else if weapon_name == "m249" and (key_toggled) then
menu_elems.xadd:set(-10.0)
menu_elems.yadd:set(-10.0)
menu_elems.zadd:set(3.0)
menu_elems.radd:set(0)
else if weapon_name == "negev" and (key_toggled) then
menu_elems.xadd:set(-10.0)
menu_elems.yadd:set(-10.0)
menu_elems.zadd:set(3.5)
menu_elems.radd:set(0)
else if weapon_name == "taser" and (key_toggled) then
menu_elems.xadd:set(-7.339)
menu_elems.yadd:set(-10.0)
menu_elems.zadd:set(4.0)
menu_elems.radd:set(0)
else
menu_elems.xadd:set(xsetvalue)
menu_elems.yadd:set(ysetvalue)
menu_elems.zadd:set(zsetvalue)
menu_elems.radd:set(rsetvalue)

                             end 
                            end 
                           end 
                          end 
                         end 
                        end 
                       end 
                      end 
                     end 
				    end 
				   end 
				  end 
				 end 
				end 
			   end 
			  end 
			 end 
			end 
		   end 
		  end 
	     end 
        end 
       end 
      end 
     end
    end
   end
  end
 end 
end

callbacks.add(e_callbacks.PAINT, handle_menu)
callbacks.add(e_callbacks.ANTIAIM, do_aim_down_sights)