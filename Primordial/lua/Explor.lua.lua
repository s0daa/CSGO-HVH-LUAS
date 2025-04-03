------MASTYER

local menu_elems = {
--------Text
	test = menu.add_separator("Explor"),
    text = menu.add_text("Explor", "Welcome "..user.name),

	test5 = menu.add_separator("Explor"),
	checkboxvisuals= menu.add_checkbox("Explor", "Watermark"),
------Master
 masteroptions = menu.add_multi_selection("Settings", "Options", {"Adaptive Fakelag", "Adaptive Jitter"}),
-------fakelag
 selection_item = menu.add_selection("Adaptive Fakelag", " Velocity Detection Strength", {"High", "Medium", "Low"}),
 slider_item = menu.add_slider("Adaptive Fakelag", "Standing Fakelag Amount", 1, 15,1,0, 't'),
 fakelag = menu.find("antiaim", "main", "fakelag", "amount"),
  antionshot = menu.add_checkbox("Adaptive Fakelag", "Attempt to hide shots"),
 checkbox_item = menu.add_checkbox("Adaptive Fakelag", "Force Break Lagcomp"),
 jitterfakelagstanding = menu.add_slider("Adaptive Fakelag", "Force Break Lagcomp Speed", 1, 15,1,0, 'Ѷ'),

-------jitter
 yaw_base = menu.find("antiaim", "main", "angles", "yaw add"),
 slideryaw1= menu.add_slider("Adaptive Jitter", "[Inverted L] Yaw add", -180, 180),
 slideryaw2 = menu.add_slider("Adaptive Jitter", "[Inverted R] Yaw add", -180, 180),
 jitteramount = menu.add_slider("Adaptive Jitter", "Jitter Amount", 0, 180),
 checkbox_item2 = menu.add_checkbox("Adaptive Jitter", "Velocity Based"),
 selection_item2 = menu.add_selection("Adaptive Jitter", "Velocity Detection Strength", {"High", "Medium", "Low"}),
--------Roll

 -------Sway

 --------trial
 --test
  fakefuck = menu.find("antiaim", "main", "general", "fake duck"),
}
local handle_menu = function()
	local masterfakelag = menu_elems.masteroptions:get(1)
	local masterjitter = menu_elems.masteroptions:get(2)
	local masterjitter2 = menu_elems.masteroptions:get(2) and menu_elems.checkbox_item2:get()
	local mastersway = menu_elems.masteroptions:get(4)
	local randomfakem = menu_elems.checkbox_item:get() and menu_elems.masteroptions:get(1)

    menu_elems.selection_item:set_visible(masterfakelag)
	menu_elems.slider_item:set_visible(masterfakelag)
	menu_elems.checkbox_item:set_visible(masterfakelag)
	menu_elems.jitterfakelagstanding:set_visible(randomfakem)
	menu_elems.antionshot:set_visible(masterfakelag)
	
	menu_elems.slideryaw1:set_visible(masterjitter)
	menu_elems.slideryaw2:set_visible(masterjitter)
	menu_elems.jitteramount:set_visible(masterjitter)
	menu_elems.checkbox_item2:set_visible(masterjitter)
	menu_elems.selection_item2:set_visible(masterjitter2)
	
end

---- Adaptive fakelag
local function  adaptivefakelagmove()
    if not menu_elems.masteroptions:get(1) then return end

	local setspeedz = menu_elems.jitterfakelagstanding:get()
    local tick_count = global_vars.tick_count()
	local speedz = menu_elems.selection_item:get()*10
	local local_player = entity_list.get_local_player()
    local velocity = local_player:get_prop("m_vecVelocity"):length()
	local minammount = menu_elems.slider_item:get()
	local test = math.abs(speedz)*1
	local test2 = math.abs(setspeedz)*1
    velocity = math.floor(velocity + 0.5)

	if not menu_elems.checkbox_item:get() then
			if velocity > 40 then
			    menu_elems.fakelag:set(velocity/test)
				else		
				menu_elems.fakelag:set(minammount)
        end
	end
	
	if menu_elems.checkbox_item:get() then
			if tick_count % test2*2 > test2 and velocity > 40 then			
				menu_elems.fakelag:set(velocity/test)
				else if velocity > 40 then
				menu_elems.fakelag:set(velocity/test/2)
				else
				menu_elems.fakelag:set(minammount)
			end
        end
	end
end


------Adaptive Jitter
local jit = false
local function adaptivejitters(ctx)
	if not menu_elems.masteroptions:get(2) then return end

  local desync_inverted = antiaim.is_inverting_desync()
  local g_vars_tick = global_vars.tick_count() 
  local tick_count = global_vars.tick_count()
  local side = jit and -1 or 1
  local choked = engine.get_choked_commands()
  local lag = engine.get_latency(e_latency_flows.INCOMING)
  local velocitystength = menu_elems.selection_item2:get()*10
  local trialstrength = math.abs(velocitystength)*1
  local local_player = entity_list.get_local_player()
  local velocity = local_player:get_prop("m_vecVelocity"):length()
  velocity = math.floor(velocity + 0.5)
  local jitter = menu_elems.jitteramount:get() / 2 * side
  local jitter2 = velocity/trialstrength * side
  if choked == 0 then
      return
  end

    if desync_inverted then
		if menu_elems.checkbox_item2:get() then
    menu_elems.yaw_base:set(jitter + menu_elems.slideryaw2:get() + jitter2 )
		else
	menu_elems.yaw_base:set(jitter + menu_elems.slideryaw2:get())
		end
    else
		if menu_elems.checkbox_item2:get() then
	menu_elems.yaw_base:set(jitter + menu_elems.slideryaw1:get() + jitter2  )
		else
	menu_elems.yaw_base:set(jitter + menu_elems.slideryaw1:get())
		end
    end
    jit = not jit


end


----Anti onshot with fakelag
local forcesendnextpacket = false
local function aimbot_shoots(shot)
    if not menu_elems.antionshot:get() and menu_elems.masteroptions:get(1)then return end
    forcesendnextpacket = true
end
local function  on_lagticks(ctx)
    if not menu_elems.antionshot:get() and menu_elems.masteroptions:get(1) then return end
    if forcesendnextpacket then
    ctx:set_fakelag(false) 
    forcesendnextpacket = false
    end
end
---------flicklbyd
------------Visuals
local Delay = 2;
arial = render.create_font("Helvetica", 41, 1500, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW,e_font_flags.OUTLINE)
pixel = render.create_font("Arial", 40, 1500, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

local function on_watermark()
    local screen_size = render.get_screen_size()
    local x = screen_size.x / 2
    local y = screen_size.y - 30

    local color = color_t(0, 229, 255, 255)
	local color2 = color_t(5, 8, 5, 255)

    if not engine.is_connected() then return end
      
    if not engine.is_in_game() then return end
      
    local local_player = entity_list.get_local_player()
      
    if not local_player:get_prop("m_iHealth") then return end

    local ind_dst = 0
    local ind_spr = 9
    if not menu_elems.checkboxvisuals:get() then return end
    if local_player:is_alive() then -- check if player is alive
	local local_player = entity_list.get_local_player()
    local velocity = local_player:get_prop("m_vecVelocity"):length()
    desyncrange = antiaim.get_max_desync_range()/100
	fakerange = antiaim.get_fake_angle()
	velocity = math.floor(velocity - 0.5)
	local screen_size = render.get_screen_size()
    local x = screen_size.x / 2
    local y = screen_size.y - 30
		if velocity > 1 then
		render.progress_circle(vec2_t.new(x, y - 495), 13, color_t.new(255,208,0), 2,desyncrange)
		render.text(pixel, "e", vec2_t.new(x - 9 , y - 517), color)
        else if fakerange > 25 then
	    render.progress_circle(vec2_t.new(x, y - 495), 13, color_t.new(255,208,0), 2, fakerange)
		render.text(pixel, "e", vec2_t.new(x - 9 , y - 517), color)
		else
	    render.progress_circle(vec2_t.new(x, y - 495), 13, color_t.new(255,208,0), 2, 1.0)
		render.text(pixel, "e", vec2_t.new(x - 9 , y - 517), color)
			end
		end
    else end
end


callbacks.add(e_callbacks.PAINT, on_watermark)
callbacks.add(e_callbacks.ANTIAIM, on_lagticks)
callbacks.add(e_callbacks.AIMBOT_SHOOT, aimbot_shoots)
callbacks.add(e_callbacks.ANTIAIM, adaptivejitters)
callbacks.add(e_callbacks.ANTIAIM, adaptivefakelagmove)
callbacks.add(e_callbacks.PAINT, handle_menu)