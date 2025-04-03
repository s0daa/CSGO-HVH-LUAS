local slider_yaw = menu.add_slider("antiaim", "yaw add", 0, 180)
local auto_yaw = menu.add_checkbox("antiaim", "automatic yaw add", true)

local function on_aimbot_shoot(shot)
if auto_yaw:get() then
  yaw_ad_on_shoot = slider_yaw:get()

  if slider_yaw:get() > 60 then yaw_ad_on_shoot = client.random_int(-30,-5) end
  
  if slider_yaw:get() < 60 and slider_yaw:get() > 40 then yaw_ad_on_shoot = client.random_int(-15,-5) end

  if slider_yaw:get() < 40 and slider_yaw:get() > 20 then yaw_ad_on_shoot = client.random_int(-5, 5) end

  if slider_yaw:get() < 20 and slider_yaw:get() > 0 then yaw_ad_on_shoot = client.random_int(5, 15) end

  if slider_yaw:get() < 3 then yaw_ad_on_shoot = client.random_int(10, 15) end

  slider_yaw:set(slider_yaw:get() + yaw_ad_on_shoot)
end
end
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)


function on_antiaim(ctx)
  local yaw = menu.find("antiaim","main","angles","yaw add")

  slider_yaw_min = slider_yaw:get() * -1

  random_num = client.random_int(0,1)


  pich = 0
if random_num == 0 then pich = -180 end
if random_num == 1 then pich = 89 end



  invert_desync = false
  random_num2 = client.random_int(0,1)
if random_num2 == 0 then invert_desync = false end
if random_num2 == 1 then invert_desync = true end

  invert_body_lean = false
random_num3 = client.random_int(0,1)
if random_num3 == 0 then invert_body_lean = false end
if random_num3 == 1 then invert_body_lean = true end

  set_fakelag = false
random_num4 = client.random_int(0,1)
if random_num4 == 0 then set_fakelag = false end
if random_num4 == 1 then set_fakelag = true end


  --ctx:set_yaw(0)--client.random_int(0,180)
  yaw:set(client.random_int(slider_yaw_min,slider_yaw:get()))
  --ctx:set_pitch(pich)
  ctx:set_desync(client.random_int(-1,1))
  ctx:set_body_lean(client.random_int(-1,1))
  ctx:set_invert_desync(invert_desync)
  --ctx:set_invert_body_lean(invert_body_lean)
  ctx:set_fakelag(set_fakelag)

  
end

callbacks.add(e_callbacks.ANTIAIM, on_antiaim)