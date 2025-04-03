local renderer_circle, bit_band, bit_lshift, client_color_log, client_create_interface, client_delay_call, client_find_signature, client_key_state, client_reload_active_scripts, client_screen_size, client_set_event_callback, client_system_time, client_timestamp, client_unset_event_callback, database_read, database_write, entity_get_classname, entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_prop, entity_get_steam64, entity_is_alive, globals_framecount, globals_realtime, math_ceil, math_floor, math_max, math_min, panorama_loadstring, renderer_gradient, renderer_line, renderer_rectangle, table_concat, table_insert, table_remove, table_sort, ui_get, ui_is_menu_open, ui_mouse_position, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_slider, ui_set, ui_set_visible, setmetatable, pairs, error, globals_absoluteframetime, globals_curtime, globals_frametime, globals_maxplayers, globals_tickcount, globals_tickinterval, math_abs, type, pcall, renderer_circle_outline, renderer_load_rgba, renderer_measure_text, renderer_text, renderer_texture, tostring, ui_name, ui_new_button, ui_new_hotkey, ui_new_label, ui_new_listbox, ui_new_textbox, ui_reference, ui_set_callback, ui_update, unpack, tonumber = renderer.circle, bit.band, bit.lshift, client.color_log, client.create_interface, client.delay_call, client.find_signature, client.key_state, client.reload_active_scripts, client.screen_size, client.set_event_callback, client.system_time, client.timestamp, client.unset_event_callback, database.read, database.write, entity.get_classname, entity.get_local_player, entity.get_origin, entity.get_player_name, entity.get_prop, entity.get_steam64, entity.is_alive, globals.framecount, globals.realtime, math.ceil, math.floor, math.max, math.min, panorama.loadstring, renderer.gradient, renderer.line, renderer.rectangle, table.concat, table.insert, table.remove, table.sort, ui.get, ui.is_menu_open, ui.mouse_position, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.set, ui.set_visible, setmetatable, pairs, error, globals.absoluteframetime, globals.curtime, globals.frametime, globals.maxplayers, globals.tickcount, globals.tickinterval, math.abs, type, pcall, renderer.circle_outline, renderer.load_rgba, renderer.measure_text, renderer.text, renderer.texture, tostring, ui.name, ui.new_button, ui.new_hotkey, ui.new_label, ui.new_listbox, ui.new_textbox, ui.reference, ui.set_callback, ui.update, unpack, tonumber

local ffi = require 'ffi'
local vector = require 'vector'
local images = require 'gamesense/images'
local anti_aim = require 'gamesense/antiaim_funcs'

local round = function(value, multiplier) local multiplier = 10 ^ (multiplier or 0); return math.floor(value * multiplier + 0.5) / multiplier end
local dragging_fn = function(name, base_x, base_y) return (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client_screen_size()ui_set(self.x_reference,q/j*self.res)ui_set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client_screen_size()return ui_get(self.x_reference)/self.res*j,ui_get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client_screen_size()local y=ui_new_slider('LUA','A',u..' window position',0,x,v/j*x)local z=ui_new_slider('LUA','A','\n'..u..' window position y',0,x,w/k*x)ui_set_visible(y,false)ui_set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals_framecount()~=b then c=ui_is_menu_open()f,g=d,e;d,e=ui_mouse_position()i=h;h=client_key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client_screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math_max(0,math_min(j-A,q))r=math_max(0,math_min(k-B,r))end end end;table_insert(l,{q,r,A,B})return q,r,A,B end;return a end)().new(name, base_x, base_y) end
local graphs = function()local a={}function a:renderer_line(b,c,d)renderer_line(b.x,b.y,c.x,c.y,d.r,d.g,d.b,d.a)end;function a:renderer_rectangle_outlined(b,c,d)renderer_line(b.x,b.y,b.x,c.y,d.r,d.g,d.b,d.a)renderer_line(b.x,b.y,c.x,b.y,d.r,d.g,d.b,d.a)renderer_line(c.x,b.y,c.x,c.y,d.r,d.g,d.b,d.a)renderer_line(b.x,c.y,c.x,c.y,d.r,d.g,d.b,d.a)end;function a:renderer_rectangle_filled(b,c,d)local e=c.x-b.x;local f=c.y-b.y;if e<0 then if f<0 then renderer_rectangle(c.x,c.y,-e,-f,d.r,d.g,d.b,d.a)else renderer_rectangle(c.x,b.y,-e,f,d.r,d.g,d.b,d.a)end else if f<0 then renderer_rectangle(b.x,c.y,e,-f,d.r,d.g,d.b,d.a)else renderer_rectangle(b.x,b.y,e,f,d.r,d.g,d.b,d.a)end end end;function a:renderer_rectangle_outlined(b,c,d)renderer_line(b.x,b.y,b.x,c.y,d.r,d.g,d.b,d.a)renderer_line(b.x,b.y,c.x,b.y,d.r,d.g,d.b,d.a)renderer_line(c.x,b.y,c.x,c.y,d.r,d.g,d.b,d.a)renderer_line(b.x,c.y,c.x,c.y,d.r,d.g,d.b,d.a)end;function a:renderer_rectangle_filled_gradient(b,c,g,h,i)local e=c.x-b.x;local f=c.y-b.y;if e<0 then if f<0 then renderer_gradient(c.x,c.y,-e,-f,g.r,g.g,g.b,g.a,h.r,h.g,h.b,h.a,i)else renderer_gradient(c.x,b.y,-e,f,g.r,g.g,g.b,g.a,h.r,h.g,h.b,h.a,i)end else if f<0 then renderer_gradient(b.x,c.y,e,-f,h.r,h.g,h.b,h.a,g.r,g.g,g.b,g.a,i)else renderer_gradient(b.x,b.y,e,f,h.r,h.g,h.b,h.a,g.r,g.g,g.b,g.a,i)end end end;function a:draw(j,k,l,m,n,o)local p=k;local q=n.clr_1;k=0;l=l-p;n.h=n.h-n.thickness;if o then a:renderer_rectangle_outlined({x=n.x,y=n.y},{x=n.x+n.w-1,y=n.y+n.h-1+n.thickness},{r=q[1],g=q[2],b=q[3],a=q[4]})end;if k==l then a:renderer_line({x=n.x,y=n.y+n.h},{x=n.x+n.w,y=n.y+n.h},{r=q[1],g=q[2],b=q[3],a=q[4]})return end;local r=n.w/(m-1)local s=l-k;for t=1,m-1 do local u={(j[t]-p)/s,(j[t+1]-p)/s}local v={{x=n.x+r*(t-1),y=n.y+n.h-n.h*u[1]},{x=n.x+r*t,y=n.y+n.h-n.h*u[2]}}for t=1,n.thickness do a:renderer_line({x=v[1].x,y=v[1].y+t-1},{x=v[2].x,y=v[2].y+t-1},{r=q[1],g=q[2],b=q[3],a=q[4]})end end end;function a:draw_histogram(j,k,l,m,n,o)local p=k;k=0;l=l-p;if o then a:renderer_rectangle_outlined({x=n.x,y=n.y},{x=n.x+n.w-1,y=n.y+n.h-1},{r=255,g=255,b=255,a=255})end;local r=n.w/(m-1)local s=l-k;for t=1,m-1 do local u={(j[t]-p)/s,(j[t+1]-p)/s}local v={{x=math_floor(n.x+r*(t-1)),y=math_floor(n.y+n.h-n.h*u[1])},{x=math_floor(n.x+r*t),y=math_floor(n.y+n.h)},isZero=math_floor(n.y+n.h)==math_floor(n.y+n.h-n.h*u[1])}if n.sDrawBar=="fill"then a:renderer_rectangle_filled({x=v[1].x,y=v[1].y},{x=v[2].x,y=v[2].y},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=n.clr_1[4]})elseif n.sDrawBar=="gradient_fadeout"then a:renderer_rectangle_filled_gradient({x=v[1].x,y=v[1].y},{x=v[2].x,y=v[2].y},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=0},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=n.clr_1[4]},false)elseif n.sDrawBar=="gradient_fadein"then a:renderer_rectangle_filled_gradient({x=v[1].x,y=v[1].y},{x=v[2].x,y=v[2].y},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=n.clr_1[4]},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=0},false)else end;if n.bDrawPeeks and not v.isZero then a:renderer_line({x=v[1].x,y=v[1].y},{x=v[2].x,y=v[1].y},{r=n.clr_2[1],g=n.clr_2[2],b=n.clr_2[3],a=n.clr_2[4]})end end end;return a end
local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
local gram_update = function(tab, value, forced) local new_tab = tab; if forced or new_tab[#new_tab] ~= value then table_insert(new_tab, value); table_remove(new_tab, 1); end; tab = new_tab; end
local get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end
local hsv_to_rgb = function(b,c,d,e)local f,g,h;local i=math_floor(b*6)local j=b*6-i;local k=d*(1-c)local l=d*(1-j*c)local m=d*(1-(1-j)*c)i=i%6;if i==0 then f,g,h=d,m,k elseif i==1 then f,g,h=l,d,k elseif i==2 then f,g,h=k,d,m elseif i==3 then f,g,h=k,l,d elseif i==4 then f,g,h=m,k,d elseif i==5 then f,g,h=d,k,l end;return f*255,g*255,h*255,e*255 end
local notes = function(b)local c=function(d,e)local f={}for g in pairs(d)do table_insert(f,g)end;table_sort(f,e)local h=0;local i=function()h=h+1;if f[h]==nil then return nil else return f[h],d[f[h]]end end;return i end;local j={get=function(k)local l,m=0,{}for n,o in c(package.solus_notes)do if o==true then l=l+1;m[#m+1]={n,l}end end;for p=1,#m do if m[p][1]==b then return k(m[p][2]-1)end end end,set_state=function(q)package.solus_notes[b]=q;table_sort(package.solus_notes)end,unset=function()client_unset_event_callback('shutdown',callback)end}client_set_event_callback('shutdown',function()if package.solus_notes[b]~=nil then package.solus_notes[b]=nil end end)if package.solus_notes==nil then package.solus_notes={}end;return j end
local item_count = function(b)if b==nil then return 0 end;if#b==0 then local c=0;for d in pairs(b)do c=c+1 end;return c end;return#b end
local contains = function(b,c)for d=1,#b do if b[d]==c then return true end end;return false end
local create_integer = function(b,c,d,e)return{min=b,max=c,init_val=d,scale=e,value=d}end

local doubletap = {ui.reference('rage', 'aimbot', 'Double tap')}

local linear_interpolation = function(start, _end, time)
	return (_end - start) * time + start
end

local hex = function(r, g, b, a)
    return string.format('\a%02X%02X%02X%02X', r, g, b, a or 255)
end

local function inverse_lerp(a, b, weight)
    return (weight - a) / (b - a)
end

local clamp = function(value, minimum, maximum)
	if minimum > maximum then
		return math_min(math_max(value, maximum), minimum)
	else
		return math_min(math_max(value, minimum), maximum)
	end
end

local lerp = function(start, _end, time)
	time = time or 0.005
	time = clamp(globals_frametime() * time * 175.0, 0.01, 1.0)
	local a = linear_interpolation(start, _end, time)
	if _end == 0.0 and a < 0.01 and a > -0.01 then
		a = 0.0
	elseif _end == 1.0 and a < 1.01 and a > 0.99 then
		a = 1.0
	end
	return a
end

local outline = function(x, y, w, h, rounding, r, g, b, a, thickness, alpha)
	local rounding = clamp(0, math_min(w, h) / 2, rounding)
	local a = a * alpha
	local a1 = 0

	if rounding == 0 then
		return renderer_rectangle(x, y - thickness, w, thickness, r, g, b, a)
	end

	local half_h = math_min(math_ceil(h / 2), h - rounding * 2)
	renderer_circle_outline(x + rounding, y + rounding, r, g, b, a, rounding + thickness, 180, 0.25, thickness) -- top left
	renderer_circle_outline(x + w - rounding, y + rounding, r, g, b, a, rounding + thickness, 270, 0.25, thickness) -- top right
	renderer_rectangle(x + rounding, y - thickness, w - rounding * 2, thickness, r, g, b, a) -- top

	renderer_gradient(x + w, y + rounding, thickness, half_h, r, g, b, a, r, g, b, a1, false) -- right
	renderer_gradient(x - thickness, y + rounding, thickness, half_h, r, g, b, a, r, g, b, a1, false) -- left
end

local left_outline = function(x, y, w, h, rounding, r, g, b, a, thickness, alpha, mode)
	local rounding = clamp(0, math_min(w, h) / 2, rounding)
	local a = a
	local a1 = 0

	if rounding > 0  and mode ~= 'main' then
		thickness = 1
	end

	if rounding == 0 then
		if mode == 'main' then
		renderer_rectangle(x - thickness, y, thickness, h, r, g, b, a)
		else
		renderer_gradient(x - thickness, y, thickness, h / 2, r, g, b, 0, r, g, b, a, false)
		renderer_gradient(x - thickness, y + h / 2, thickness, h / 2, r, g, b, a, r, g, b, 0, false)
		end
		return
	end

	local half_h = math_min(math_ceil(h / 2), w - rounding * 2)
	renderer_circle_outline(x + rounding, y + rounding, r, g, b, a, rounding + thickness, 180, 0.25, thickness) -- top left
	renderer_circle_outline(x + rounding, y + h - rounding, r, g, b, a, rounding + thickness, 90, 0.25, thickness) -- bottom left
	renderer_rectangle(x - thickness, y + rounding, thickness, h - rounding * 2, r, g, b, a) -- left

	renderer_gradient(x + rounding, y + h, half_h, thickness, r, g, b, a, r, g, b, a1, true) -- bottom
	renderer_gradient(x + rounding, y - thickness, half_h, thickness, r, g, b, a, r, g, b, a1, true) -- top
end

local rectangle_filed = function(x, y, w, h, rounding, r, g, b, a, alpha)
	local rounding = clamp(0, math_min(w, h) / 2, rounding)
	local a = a * alpha
	renderer_circle(x + rounding, y + rounding, r, g, b, a, rounding, 180, 0.25) -- top left
	renderer_circle(x + w - rounding, y + rounding, r, g, b, a, rounding, 90, 0.25) -- top right
	renderer_circle(x + w - rounding, y + h - rounding, r, g, b, a, rounding, 0, 0.25) -- bottom right
	renderer_circle(x + rounding, y + h - rounding, r, g, b, a, rounding, 270, 0.25) -- bottom left
	renderer_rectangle(x + rounding, y, w - rounding * 2, h, r, g, b, a) -- Mid
	renderer_rectangle(x, y + rounding, rounding, h - rounding * 2, r, g, b, a) -- left
	renderer_rectangle(x + w - rounding, y + rounding, rounding, h - rounding * 2, r, g, b, a) -- right
end

local rectangle_outline = function(x, y, w, h, r, g, b, a, thinkness, radius)
	if thinkness == nil or thinkness < 1 then
	  thinkness = 1;
	end

	if radius == nil or radius < 0 then
	  radius = 0;
	end

	local limit = math_min(w * 0.5, h * 0.5) * 0.5;
	thinkness = math_min(limit / 0.5, thinkness);

	local offset = 0;

	if radius >= thinkness then
	  radius = math_min(limit + (limit - thinkness), radius);
	  offset = radius + thinkness;
	end
	if radius == 0 then
	renderer_rectangle(x + offset - 1, y, w - offset * 2 + 2, thinkness, r, g, b, a);
	renderer_rectangle(x + offset - 1, y + h, w - offset * 2 + 2, -thinkness, r, g, b, a);
	else
	renderer_rectangle(x + offset, y, w - offset * 2, thinkness, r, g, b, a);
	renderer_rectangle(x + offset, y + h, w - offset * 2, -thinkness, r, g, b, a);
	end

	local bounds = math_max(offset, thinkness);

	renderer_rectangle(x, y + bounds, thinkness, h - bounds * 2, r, g, b, a);
	renderer_rectangle(x + w, y + bounds, -thinkness, h - bounds * 2, r, g, b, a);

	if radius == 0 then
	  return
	end

	renderer_circle_outline(x + offset, y + offset, r, g, b, a, offset, 180, 0.25, thinkness); -- ? left-top
	renderer_circle_outline(x + offset, y + h - offset, r, g, b, a, offset, 90, 0.25, thinkness); -- ? left-botttom

	renderer_circle_outline(x + w - offset, y + offset, r, g, b, a, offset, 270, 0.25, thinkness); -- ? right-top
	renderer_circle_outline(x + w - offset, y + h - offset, r, g, b, a, offset, 0, 0.25, thinkness); -- ? right-bottom
end

local shadow = function(x, y, w, h, r, g, b, a, thinkness, radius)
	if thinkness == nil or thinkness < 1 then
		thinkness = 1;
	end

	if radius == nil or radius < 0 then
		radius = 0;
	end

	local limit = math.min(w * 0.5, h * 0.5);

	radius = math.min(limit, radius);
	thinkness = thinkness + radius;

	local rd = radius * 2;
	x, y, w, h = x + radius - 1, y + radius - 1, w - rd + 2, h - rd + 2;

	local factor = 1;
	local step = inverse_lerp(radius, thinkness, radius + 1);

	for k = radius, thinkness do
	  local kd = k * 2;
	  local rounding = radius == 0 and radius or k;

	  rectangle_outline(x - k, y - k, w + kd, h + kd, r, g, b, a * factor / 3, 1, rounding);
	  factor = factor - step;
	end
end

local read_database = function(script_name, db_name, original)
	if (script_name == nil or script_name == '') or (db_name == nil or db_name == '') or (original == nil or original == { }) then
		client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
		client_color_log(255, 0, 0, 'Error occured while parsing data')
		
		error()
	end
	

	local dbase = database_read(db_name)
	local new_data, corrupted_data, missing_sectors =
		false, false, { }

	if dbase == nil then 
		dbase, new_data = original, true
	else
		for name in pairs(dbase) do
			local found_sector = false

			for oname in pairs(original) do
				if name == oname then
					found_sector = true
				end
			end

			if not found_sector then
				dbase[name] = nil
			end
		end

		for name, val in pairs(original) do
			if dbase[name] == nil then	
				dbase[name], corrupted_data = val, true
				missing_sectors[#missing_sectors+1] = '*' .. name
			else
				local corrupted_sector = false
				for sname, sdata in pairs(val) do
					if sname ~= 'keybinds' and dbase[name][sname] == nil or type(sdata) ~= type(dbase[name][sname]) then
						dbase[name][sname], corrupted_data = sdata, true

						if not corrupted_sector then
							missing_sectors[#missing_sectors+1] = '*' .. name
							corrupted_sector = true
						end
					end
				end
			end
		end

		if #missing_sectors > 0 then
			client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
			client_color_log(255, 255, 255, ('Repairing %d sector(s) \1\0'):format(#missing_sectors))
			client_color_log(155, 220, 220, ('[ %s ]'):format(table_concat(missing_sectors, ' ')))
		end
	end

	if new_data or corrupted_data then
		database_write(db_name, dbase)
	end

	return dbase, original
end

local script_name = 'solus'
local database_name = 'solus'
local menu_tab = { 'LUA', 'A', 'B' }
local menu_palette = { 'Solid', 'Rainbow' }
local m_hotkeys, m_hotkeys_update, m_hotkeys_create = { }, true

local ms_watermark = ui_new_checkbox('CONFIG', 'Presets', 'Watermark')
local ms_spectators = ui_new_checkbox('CONFIG', 'Presets', 'Spectators') 
local ms_keybinds = ui_new_checkbox('CONFIG', 'Presets', 'Hotkey list')
local ms_exploit = ui_new_checkbox('CONFIG', 'Presets', 'Lags-Exploit indication')
local ms_ieinfo = ui_new_checkbox('CONFIG', 'Presets', 'Frequency update information')

local ms_palette, ms_color = 
	ui_new_combobox('CONFIG', 'Presets', 'Solus Palette', menu_palette),
	ui_new_color_picker('CONFIG', 'Presets', 'Solus Global color', 142, 165, 229, 85)

local ms_rainbow_frequency = ui_new_slider('CONFIG', 'Presets', 'Rainbow frequency', 1, 100, 10, false, nil, 0.01)
local ms_rainbow_split_ratio = ui_new_slider('CONFIG', 'Presets', 'Rainbow split ratio', 0, 100, 100, false, nil, 0.01)

local function inverse_lerp(a, b, weight)
    return (weight - a) / (b - a)
  end

  local function entity_get(userid)
    if userid == nil then
      return entity_get_local_player()
    end

    return client_userid_to_entindex(userid)
end

local script_db, original_db = read_database(script_name, database_name, {
	watermark = {
		nickname = '',		
		beta_status = false,
		gc_state = true,
		style = create_integer(1, 4, 1, 1),
		suffix = nil,
		left =true
	},

	spectators = {
		avatars = true,
		auto_position = true
	},

	window = {
		height = create_integer(0, 7, 0, 1),
		glow = create_integer(0, 175, 150, 1),
		rounding = create_integer(0, 8, 4, 1),
		thickness = create_integer(0, 5, 1, 1)
	},

	keybinds = {
		{
			require = '',
			reference = { 'legit', 'aimbot', 'Enabled' },
			custom_name = 'Legit aimbot',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'legit', 'triggerbot', 'Enabled' },
			custom_name = 'Legit triggerbot',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'aimbot', 'Enabled' },
			custom_name = 'Rage aimbot',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'aimbot', 'Force safe point' },
			custom_name = 'Safe point',
			ui_offset = 1
		},


		{
			require = '',
			reference = { 'rage', 'aimbot', 'Quick stop' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'aimbot', 'Minimum damage override' },
			custom_name = 'Minimum damage',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'aimbot', 'Double tap' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'aimbot', 'Force body aim' },
			custom_name = '',
			ui_offset = 1
		},

		{
			require = '',
			reference = { 'rage', 'other', 'Quick peek assist' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'other', 'Duck peek assist' },
			custom_name = '',
			ui_offset = 1
		},

		{
			require = '',
			reference = { 'aa', 'anti-aimbot angles', 'Freestanding' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'aa', 'other', 'Slow motion' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'aa', 'other', 'On shot anti-aim' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'aa', 'other', 'Fake peek' },
			custom_name = '',
			ui_offset = 2
		},


		{
			require = '',
			reference = { 'misc', 'movement', 'Z-Hop' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'misc', 'movement', 'Pre-speed' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'misc', 'movement', 'Blockbot' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'misc', 'movement', 'Jump at edge' },
			custom_name = '',
			ui_offset = 2
		},


		{
			require = '',
			reference = { 'misc', 'miscellaneous', 'Last second defuse' },
			custom_name = '',
			ui_offset = 1
		},

		{
			require = '',
			reference = { 'misc', 'miscellaneous', 'Free look' },
			custom_name = '',
			ui_offset = 1
		},

		{
			require = '',
			reference = { 'misc', 'miscellaneous', 'Ping spike' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'misc', 'miscellaneous', 'Automatic grenade release' },
			custom_name = 'Grenade release',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'visuals', 'player esp', 'Activation type' },
			custom_name = 'Visuals',
			ui_offset = 1
		},
	},
})

local get_bar_color = function()
	local r, g, b, a = ui_get(ms_color)

	local palette = ui_get(ms_palette)

	if palette ~= menu_palette[1] then
		local rgb_split_ratio = ui_get(ms_rainbow_split_ratio) / 100

		local h = palette == menu_palette[2] and 
			globals_realtime() * (ui_get(ms_rainbow_frequency) / 100) or 
			 1000

		r, g, b = hsv_to_rgb(h, 1, 1, 1)
		r, g, b = 
			r * rgb_split_ratio, 
			g * rgb_split_ratio, 
			b * rgb_split_ratio
	end

	return r, g, b, a
end

local get_color = function(number, max, i)
    local Colors = {
        { 255, 0, 0 },
        { 237, 27, 3 },
        { 235, 63, 6 },
        { 229, 104, 8 },
        { 228, 126, 10 },
        { 220, 169, 16 },
        { 213, 201, 19 },
        { 176, 205, 10 },
        { 124, 195, 13 }
    }

    local math_num = function(int, max, declspec)
        local int = (int > max and max or int)
        local tmp = max / int;

        if not declspec then declspec = max end

        local i = (declspec / tmp)
        i = (i >= 0 and math_floor(i + 0.5) or math_ceil(i - 0.5))

        return i
    end

    i = math_num(number, max, #Colors)

    return
        Colors[i <= 1 and 1 or i][1], 
        Colors[i <= 1 and 1 or i][2],
        Colors[i <= 1 and 1 or i][3],
        i
end
               
local ms_classes = {
	watermark = function()
		local note = notes 'a_watermark'
		local m_alpha = 0

		local has_beta = pcall(ui_reference, 'misc', 'Settings', 'Crash logs')
		local get_name = panorama_loadstring([[ return MyPersonaAPI.GetName() ]])
		local get_gc_state = panorama_loadstring([[ return MyPersonaAPI.IsConnectedToGC() ]])

		local classptr = ffi.typeof('void***')
		local latency_ptr = ffi.typeof('float(__thiscall*)(void*, int)')

		local rawivengineclient = client_create_interface('engine.dll', 'VEngineClient014') or error('VEngineClient014 wasnt found', 2)
		local ivengineclient = ffi.cast(classptr, rawivengineclient) or error('rawivengineclient is nil', 2)
		local is_in_game = ffi.cast('bool(__thiscall*)(void*)', ivengineclient[0][26]) or error('is_in_game is nil')

		local g_paint_handler = function()
			local state = ui_get(ms_watermark)
			local r, g, b, a = get_bar_color()

			note.set_state(m_alpha > 0.01)

			note.get(function(id)
				local data_wm = script_db.watermark or { }
				local data_wd = script_db.window or { }
				local data_nickname = data_wm.nickname and tostring(data_wm.nickname) or ''
				local data_suffix = (data_wm.suffix and tostring(data_wm.sWuffix) or ''):gsub('beta', '')

				
				local global_alpha = m_alpha * 255
				
				local cstyle = { [1] = ('%sgame%ssense%s'):format(hex(255, 255, 255, 255 * m_alpha), hex(r, g, b, 255 * m_alpha), hex(255, 255, 255, 255 * m_alpha)),
					[2] = ('%sgames%sense.pub%s'):format(hex(255, 255, 255, 255 * m_alpha), hex(r, g, b, 255 * m_alpha), hex(255, 255, 255, 255 * m_alpha)),
					[3] = ('%ssk%seet%s'):format(hex(255, 255, 255, 255 * m_alpha), hex(r, g, b, 255 * m_alpha), hex(255, 255, 255, 255 * m_alpha)),
					[4] = ('%sske%set.cc%s'):format(hex(255, 255, 255, 255 * m_alpha), hex(r, g, b, 255 * m_alpha), hex(255, 255, 255, 255 * m_alpha))}


				if data_wm.beta_status --[[and has_beta]] and (not data_suffix or #data_suffix < 1) then
					data_suffix = 'beta'
				end

				local height = data_wd.height and data_wd.height.value or 0
				local rounding = data_wd.rounding and data_wd.rounding.value or 4
				local thickness = data_wd.thickness and data_wd.thickness.value or 0
				local glow = data_wd.glow and data_wd.glow.value or 0

				local sys_time = { client_system_time() }
				local actual_time = ('%02d:%02d:%02d'):format(sys_time[1], sys_time[2], sys_time[3])

				local is_connected_to_gc = not data_wm.gc_state or get_gc_state()
				local gc_state = not is_connected_to_gc and '\x20\x20\x20\x20\x20' or ''

				local nickname = #data_nickname > 0 and data_nickname or get_name()
				local suffix = ('%s%s'):format(
					cstyle[data_wm.style and data_wm.style.value or 1] or cstyle[1], 
					#data_suffix > 0 and (' [%s]'):format(data_suffix) or ''
				)

				local text = ('%s%s %s %s'):format(gc_state, suffix, nickname, actual_time)
		
				if is_in_game(is_in_game) == true then
					local latency = client.latency()*1000
					local latency_text = latency > 5 and (' delay: %dms'):format(latency) or ''

					text = ('%s%s %s%s %s'):format(gc_state, suffix, nickname, latency_text, actual_time)
				end

				local h, w = 18 + height, renderer_measure_text('d', text) + 8
				
				local x, y = client_screen_size(), 8 + (25*id) + thickness

				if data_wm.left then
					y = 8 + (25*id)
				end

				x = x - w - 10
				if data_wm.left then
					left_outline(x, y + 2, w, h, rounding, r, g, b, 255 * m_alpha, thickness, m_alpha, 'main')
				else
					outline(x, y + 2, w, h, rounding, r, g, b, 255 * m_alpha, thickness, m_alpha)
				end

				rectangle_filed(x, y + 2, w, h, rounding, 17, 17, 17, a * m_alpha, m_alpha)
				if data_wd.glow and data_wd.glow.value ~= 0  then
				shadow(x, y + 2, w, h, r, g, b, glow * m_alpha, 8, math.max(rounding, 1))
				end

				renderer_text(x+4, y + 4 + height / 2, 255, 255, 255, 255 * m_alpha, 'd', 0, text)

				if not is_connected_to_gc then
					local realtime = globals_realtime()*1.5
					
					if realtime%2 <= 1 then
						renderer_circle_outline(x+10, y + 11, 89, 119, 239, 255, 5, 0, realtime%1, 2)
					else
						renderer_circle_outline(x+10, y + 11, 89, 119, 239, 255, 5, realtime%1*370, 1-realtime%1, 2)
					end
				end
			end)

			local frames = 8 * globals_frametime()

			if state then
				m_alpha = m_alpha + frames; if m_alpha > 1 then m_alpha = 1 end
			else
				m_alpha = m_alpha - frames; if m_alpha < 0 then m_alpha = 0 end 
			end
		end

		client_set_event_callback('paint_ui', g_paint_handler)
	end,

	spectators = function()
		local screen_size = { client_screen_size() }
		local screen_size = {
			screen_size[1] - screen_size[1] * cvar.safezonex:get_float(),
			screen_size[2] * cvar.safezoney:get_float()
		}

		local dragging = dragging_fn('Spectators', screen_size[1] / 1.385, screen_size[2] / 2)
		local m_alpha, m_width, m_active, m_contents, unsorted = 0, 0, {}, {}, {}

		local get_spectating_players = function()
			local me = entity_get_local_player()

			local players, observing = { }, me
		
			for i = 1, globals_maxplayers() do
				if entity_get_classname(i) == 'CCSPlayer' then
					local m_iObserverMode = entity_get_prop(i, 'm_iObserverMode')
					local m_hObserverTarget = entity_get_prop(i, 'm_hObserverTarget')
		
					if m_hObserverTarget ~= nil and m_hObserverTarget <= 64 and not entity_is_alive(i) and (m_iObserverMode == 4 or m_iObserverMode == 5) then
						if players[m_hObserverTarget] == nil then
							players[m_hObserverTarget] = { }
						end
		
						if i == me then
							observing = m_hObserverTarget
						end
		
						table_insert(players[m_hObserverTarget], i)
					end
				end
			end
		
			return players, observing
		end

		local g_paint_handler = function()
			local data_sp = script_db.spectators or { }
			local data_wd = script_db.window or { }

			local master_switch = ui_get(ms_spectators)
			local is_menu_open = ui_is_menu_open()
			local frames = 8 * globals_frametime()
		
			local latest_item = false
			local maximum_offset = 83

			local me = entity_get_local_player()
			local spectators, player = get_spectating_players()
		
			for i=1, 64 do 
				unsorted[i] = {
					idx = i,
					active = false
				}
			end
		
			if spectators[player] ~= nil then
				for _, spectator in pairs(spectators[player]) do
					unsorted[spectator] = { 
						idx = spectator,
		
						active = (function()
							if spectator == me then
								return false
							end

							return true
						end)(),

						avatar = (function()
							if not data_sp.avatars then
								return nil
							end

							local steam_id = entity_get_steam64(spectator)
							local avatar = images.get_steam_avatar(steam_id)
		
							if steam_id == nil or avatar == nil then
								return nil
							end
		
							if m_contents[spectator] == nil or m_contents[spectator].conts ~= avatar.contents then
								m_contents[spectator] = {
									conts = avatar.contents,
									texture = renderer_load_rgba(avatar.contents, avatar.width, avatar.height)
								}
							end
		
							return m_contents[spectator].texture
						end)()
					}
				end
			end
		
			for _, c_ref in pairs(unsorted) do
				local c_id = c_ref.idx
				local c_nickname = entity_get_player_name(c_ref.idx)
		
				if c_ref.active then
					latest_item = true
		
					if m_active[c_id] == nil then
						m_active[c_id] = {
							alpha = 0, offset = 0, active = true
						}
					end
		
					local text_width = renderer_measure_text(nil, c_nickname)
		
					m_active[c_id].active = true
					m_active[c_id].offset = text_width
					m_active[c_id].alpha = m_active[c_id].alpha + frames
					m_active[c_id].avatar = c_ref.avatar
					m_active[c_id].name = c_nickname
		
					if m_active[c_id].alpha > 1 then
						m_active[c_id].alpha = 1
					end
				elseif m_active[c_id] ~= nil then
					m_active[c_id].active = false
					m_active[c_id].alpha = m_active[c_id].alpha - frames
		
					if m_active[c_id].alpha <= 0 then
						m_active[c_id] = nil
					end
				end
		
				if m_active[c_id] ~= nil and m_active[c_id].offset > maximum_offset then
					maximum_offset = m_active[c_id].offset
				end
			end
		
			if is_menu_open and not latest_item then
				local case_name = ' '
				local text_width = renderer_measure_text(nil, case_name)
		
				latest_item = true
				maximum_offset = maximum_offset < text_width and text_width or maximum_offset
		
				m_active[case_name] = {
					name = '',
					active = true,
					offset = text_width,
					alpha = 1
				}
			end
			local text = 'spectators'
			local x, y = dragging:get()
			local r, g, b, a = get_bar_color()

			local height = data_wd.height and data_wd.height.value or 0
			local rounding = data_wd.rounding and data_wd.rounding.value or 4
			local thickness = data_wd.thickness and data_wd.thickness.value or 0
			local glow = data_wd.glow and data_wd.glow.value or 0
			
			local height_offset = 23 + height
			local w, h = 55 + maximum_offset, 50
		
			if m_width == nil then
				m_width = w;
			end

			m_width = lerp(m_width, w, 0.115);
			w = round(m_width)

			w = w - (data_sp.avatars and 0 or 17) 

			local right_offset = data_sp.auto_position and (x+w/2) > (({ client_screen_size() })[1] / 2)

			outline(x, y + 2, w, 18 + height, rounding, r, g, b, 255 * m_alpha, thickness, m_alpha)
			rectangle_filed(x, y + 2, w, 18 + height, rounding, 17, 17, 17, a * m_alpha, m_alpha)

			if data_wd.glow and data_wd.glow.value ~= 0  then
			shadow(x, y + 2, w, 18 + height, r, g, b, glow * m_alpha, 8, math.max(rounding, 1))
			end
		
			renderer_text(x - renderer_measure_text(nil, text) / 2 + w/2, y + 4 + height / 2, 255, 255, 255, m_alpha*255, '', 0, text)
		
			for c_name, c_ref in pairs(m_active) do
				local _, text_h = renderer_measure_text(nil, c_ref.name)

				renderer_text(x + ((c_ref.avatar and not right_offset) and text_h or -5) + 10, y + height_offset, 255, 255, 255, m_alpha*c_ref.alpha*255, '', 0, c_ref.name)
		
				if c_ref.avatar ~= nil then
					renderer_texture(c_ref.avatar, x + (right_offset and w - 15 or 5), y + height_offset, text_h, text_h, 255, 255, 255, m_alpha*c_ref.alpha*255, 'f')
				end
		
				height_offset = height_offset + 15
			end

			dragging:drag(w, (3 + (15 * item_count(m_active))) * 2)

			if master_switch and item_count(m_active) > 0 and latest_item then
				m_alpha = m_alpha + frames; if m_alpha > 1 then m_alpha = 1 end
			else
				m_alpha = m_alpha - frames; if m_alpha < 0 then m_alpha = 0 end 
			end
		
			if is_menu_open then
				m_active[' '] = nil
			end
		end

		client_set_event_callback('paint', g_paint_handler)
	end,

	keybinds = function()
		local screen_size = { client_screen_size() }
		local screen_size = {
			screen_size[1] - screen_size[1] * cvar.safezonex:get_float(),
			screen_size[2] * cvar.safezoney:get_float()
		}

		local dragging = dragging_fn('Keybinds', screen_size[1] / 1.385, screen_size[2] / 2.5)

		local m_alpha, m_width, m_active = 0, nil, { }
		local hotkey_modes = { 'holding', 'toggled', 'disabled' }

		local elements = {
			rage = { 'aimbot', 'other' },
			aa = { 'anti-aimbot angles', 'fake lag', 'other' },
			legit = { 'weapon type', 'aimbot', 'triggerbot', 'other' },
			visuals = { 'player esp', 'colored models', 'other esp', 'effects' },
			misc = { 'miscellaneous', 'movement', 'settings' },
			skins = { 'model options', 'weapon skin' },
			players = { 'players', 'adjustments' },
			config = { 'presets', 'lua' },
			lua = { 'a', 'b' }
		}

		local reference_if_exists = function(...)
			if pcall(ui_reference, ...) then
				 return true
			end
		end

		local create_item = function(data)
			local collected = { }

			local cname = data.custom_name
			local reference = { ui_reference(unpack(data.reference)) }
		
			for i=1, #reference do
				if i <= data.ui_offset then
					collected[i] = reference[i]
				end
			end
		
			cname = (cname and #tostring(cname) > 0) and cname or nil

			data.reference[3] = data.ui_offset == 2 and ui_name(collected[1]) or data.reference[3]

			m_hotkeys[cname or (data.reference[3] or '?')] = {
				reference = data.reference,

				ui_offset = data.ui_offset,
				custom_name = cname,
				custom_file = data.require,
				collected = collected
			}

			return true
		end
		
		local create_custom_item = function(pdata)
			local reference = pdata.reference

			if  reference == nil or elements[reference[1]:lower()] == nil or 
				not contains(elements[reference[1]:lower()], reference[2]:lower()) then
				return false
			end

			if reference_if_exists(unpack(reference)) then
				return create_item(pdata)
			else
				if pcall(require, pdata.require) and reference_if_exists(unpack(reference)) then
					return create_item(pdata)
				else
					local name = (pdata.require and #pdata.require > 0) and (pdata.require .. '.lua') or '-'

					client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client_color_log(155, 220, 220, ('Unable to reference hotkey: %s [ %s ]'):format(reference[3], name))
				end
			end

			return false
		end

		local g_paint_handler = function()
			local master_switch = ui_get(ms_keybinds)
			local data_wd = script_db.window or { }
			local is_menu_open = ui_is_menu_open()
			local frames = 8 * globals_frametime()
		
			local latest_item = false
			local maximum_offset = 66

			if m_hotkeys_update == true then
				m_hotkeys = { }
				m_active = { }

				for _, item in pairs((script_db.keybinds or { })) do
					create_custom_item({
						reference = item.reference,
						custom_name = item.custom_name,
						ui_offset = item.ui_offset or 1,
						require = item.require
					})
				end

				m_hotkeys_update = false
			end
		
			for c_name, c_data in pairs(m_hotkeys) do
				local item_active = true
				local c_ref = c_data.collected

				local items = item_count(c_ref)
				local state = { ui_get(c_ref[items]) }
		
				if items > 1 then
					item_active = ui_get(c_ref[1])
				end
		
				if item_active and state[2] ~= 0 and (state[2] == 3 and not state[1] or state[2] ~= 3 and state[1]) then
					latest_item = true
		
					if m_active[c_name] == nil then
						m_active[c_name] = {
							mode = '', alpha = 0, offset = 0, active = true
						}
					end
		
					local text_width = renderer_measure_text(nil, c_name)
		
					m_active[c_name].active = true
					m_active[c_name].offset = text_width
					m_active[c_name].mode = hotkey_modes[state[2]]
					m_active[c_name].alpha = m_active[c_name].alpha + frames
		
					if m_active[c_name].alpha > 1 then
						m_active[c_name].alpha = 1
					end
				elseif m_active[c_name] ~= nil then
					m_active[c_name].active = false
					m_active[c_name].alpha = m_active[c_name].alpha - frames
		
					if m_active[c_name].alpha <= 0 then
						m_active[c_name] = nil
					end
				end
		
				if m_active[c_name] ~= nil and m_active[c_name].offset > maximum_offset then
					maximum_offset = m_active[c_name].offset
				end
			end

			if is_menu_open and not latest_item then
				local case_name = 'Menu toggled'
				local text_width = renderer_measure_text(nil, case_name)
		
				latest_item = true
				maximum_offset = maximum_offset < text_width and text_width or maximum_offset
		
				m_active[case_name] = {
					active = true,
					offset = text_width,
					mode = '~',
					alpha = 1,
				}
			end
		
			local text = 'keybinds'
			local x, y = dragging:get()
			local r, g, b, a = get_bar_color()

			local height = data_wd.height and data_wd.height.value or 0
			local rounding = data_wd.rounding and data_wd.rounding.value or 4
			local thickness = data_wd.thickness and data_wd.thickness.value or 0
			local glow = data_wd.glow and data_wd.glow.value or 0

			local height_offset = 22 + height
			local w, h = 75 + maximum_offset, 50

			if m_width == nil then
				m_width = w;
			end

			m_width = lerp(m_width, w, 0.115);
			w = round(m_width)
			

			outline(x, y + 2, w, 18 + height, rounding, r, g, b, 255 * m_alpha, thickness, m_alpha)
			rectangle_filed(x, y + 2, w, 18 + height, rounding, 17, 17, 17, a * m_alpha, m_alpha)
			
			if data_wd.glow and data_wd.glow.value ~= 0  then
			shadow(x, y + 2, w, 18 + height, r, g, b, glow * m_alpha, 8, math.max(rounding, 1))
			end

			renderer_text(x - renderer_measure_text(nil, text) / 2 + w/2, y + 4 + height / 2, 255, 255, 255, m_alpha*255, '', 0, text )
		
			for c_name, c_ref in pairs(m_active) do
				local key_type = '[' .. (c_ref.mode or '?') .. ']'
		
				renderer_text(x + 5, y + height_offset, 255, 255, 255, m_alpha*c_ref.alpha*255, '', 0, c_name)
				renderer_text(x + w - renderer_measure_text(nil, key_type) - 5, y + height_offset, 255, 255, 255, m_alpha*c_ref.alpha*255, '', 0, key_type)
		
				height_offset = height_offset + round(15 * c_ref.alpha)
			end

			dragging:drag(w, (3 + (15 * item_count(m_active))) * 2)

			if master_switch and item_count(m_active) > 0 and latest_item then
				m_alpha = m_alpha + frames

				if m_alpha > 1 then 
					m_alpha = 1
				end
			else
				m_alpha = m_alpha - frames

				if m_alpha < 0 then
					m_alpha = 0
				end 
			end
		
			if is_menu_open then
				m_active['Menu toggled'] = nil
			end
		end
		

		m_hotkeys_create = create_custom_item

		client_set_event_callback('paint', g_paint_handler)
	end,

	exploit = function()
		local native_GetClientEntity = vtable_bind("client.dll", "VClientEntityList003", 3, "uintptr_t(__thiscall*)(void*, int)");

        local note = notes 'a_wbexploit'

        local gram_fyaw = gram_create(0, 2)
        local teleport_data = gram_create(0, 3)

		local m_exploit, m_fl, m_width = 0, 0, 0

        local ind_phase, ind_num, ind_time = 0, 0, 0
        local last_sent, current_choke = 0, 0
        local teleport, last_origin = 0
        local breaking_lc = 0

		local defensive = 0;

		local g_net_update_start = function()
			local me = entity_get_local_player()

			if me == nil then
				return;
			end

			local ptr = native_GetClientEntity(me);

			local m_flSimulationTime = entity.get_prop(me, "m_flSimulationTime");
			local m_flOldSimulationTime = ffi.cast("float*", ptr + 0x26C)[0];

			if (m_flSimulationTime - m_flOldSimulationTime < 0) then
				defensive = globals.tickcount() + toticks(.200);
			end
		end

        local g_setup_command = function(c)
            local me = entity_get_local_player()

            if c.chokedcommands == 0 then
                local m_origin = vector(entity_get_origin(me))

                if last_origin ~= nil then
                    teleport = (m_origin-last_origin):length2dsqr()

                    gram_update(teleport_data, teleport, true)
                end

                gram_update(gram_fyaw, math_abs(math.min(57, entity.get_prop(entity.get_local_player(),"m_flPoseParameter", 11) * 120 - 60) or 0), true)

                last_sent = current_choke
                last_origin = m_origin
            end

            breaking_lc =
                get_average(teleport_data) > 3200 and 1 or
                    (defensive > globals.tickcount() or anti_aim.get_tickbase_shifting() > 0) and 2 or 0

            current_choke = c.chokedcommands
        end

        local g_paint_handler = function()
            local me = entity_get_local_player()

            local state = ui_get(ms_exploit)
            local _, _, _, a = get_bar_color()
			local data_wd = script_db.window or { }
			local data_wm = script_db.watermark or { }

			local height = data_wd.height and data_wd.height.value or 0
			local rounding = data_wd.rounding and data_wd.rounding.value or 4
			local thickness = data_wd.thickness and data_wd.thickness.value or 0

            if me == nil or not entity_is_alive(me) then
                note.set_state(false)
                return
            end

            note.set_state(state)
            note.get(function(id)
                local x, y = client_screen_size() - 10, 8 + (24 * id + height + thickness)

				if data_wm.left then
					y = 8 + (24 * id + height)
				end

                local ms_clr = {ui_get(ms_color)}

                local fr = globals_frametime() * 3.75
                local min_offset = 1200+math_max(0, get_average(teleport_data)-3800)
                local teleport_mt = math_abs(math_min(teleport-3800, min_offset) / min_offset * 100)

                local recharging = ui.get(doubletap[2]) and (anti_aim.get_tickbase_shifting() == 0)

                if ind_num ~= teleport_mt and ind_time < globals_realtime() then
                    ind_time = globals_realtime() + 0.005
                    ind_num = ind_num + (ind_num > teleport_mt and -1 or 1)
                end

                ind_phase = ind_phase + (breaking_lc == 1 and fr or -fr)
                ind_phase = ind_phase > 1 and 1 or ind_phase
                ind_phase = ind_phase < 0 and 0 or ind_phase

                m_exploit = lerp(m_exploit, (breaking_lc == 2) and 1 or 0, 0.065);
                m_fl = lerp(m_fl, (not recharging) and 1 or 0, 0.065);

                local r1, g1, b1 = get_bar_color()
                if ui_get(ms_exploit) then
                if m_exploit > 0.01 then
                    local text = 'EXPLOITING';
                    local text_size = renderer_measure_text(nil, text);

                    local w = text_size + 8;
                    local h = 17;

                    x = x - w

                    local r, g, b = r1, g1, b1
					rectangle_filed(x, y, w, h, rounding, 17, 17, 17, a * m_exploit, m_exploit)
                    renderer_gradient(x, y + h - 1, w/2, 1, 0, 0, 0, 25 * m_exploit, r, g, b, 255 * m_exploit, true);
                    renderer_gradient(x + w/2 - 1, y + h - 1, w - w/2, 1, r, g, b, 255 * m_exploit, 0, 0, 0, 25 * m_exploit, true);

                    renderer_text(x + 4, y + 2, 255, 255 * m_exploit, 255 * m_exploit, 255 * m_exploit, '', 0, text)
                    x = x + w - (w + 5) * m_exploit
                end


                if m_fl > 0.01 then
                    local text = ('FL: %s'):format(
                        (function()
                            if tonumber(last_sent) < 10 then
                                return '\x20\x20' .. last_sent
                            end

                            return last_sent
                        end)()
                    )

                    local r, g, b = 255, 0, 0

                    if ind_phase > 0.1 then
                        text = text .. ' | dst: \x20\x20\x20\x20\x20\x20\x20\x20\x20'
                        r, g, b = 124, 195, 13
                    end

                    local text_size = renderer_measure_text(nil, text);

                    local w = text_size + 8;
                    local h = 17;

                    x = x - w
					left_outline(x, y, w, h, rounding, r, g, b, 255 * m_fl, math_max(math_min(height, 2), 1), m_fl)
					rectangle_filed(x, y, w, h, rounding, 17, 17, 17, a * m_fl, m_fl)
                    renderer_text(x + 4, y + 2, 255, 255, 255, 255 * m_fl, '', 0, text)
                        if ind_phase > 0 then
                        renderer_gradient(
                            x + w - renderer_measure_text(nil, ' | dst: ') + 2,
                            y + 6, math_min(100, ind_num) / 100 * 24, 5,

                            ms_clr[1], ms_clr[2], ms_clr[3], m_fl * (ind_phase * 220),
                            ms_clr[1], ms_clr[2], ms_clr[3], m_fl * (ind_phase * 25),

                            true
                        )
                        end
                    x = x + w - (w + 5) * m_fl
                end
			end
            end)
        end

        client_set_event_callback('net_update_start', g_net_update_start)
        client_set_event_callback('setup_command', g_setup_command)
        client_set_event_callback('paint_ui', g_paint_handler)
	end,

    ilstate = function()
		local note = notes 'a_winput'
        local graphics = graphs()
		
        local formatting = (function(avg)
            if avg < 1 then return ('%.2f'):format(avg) end
            if avg < 10 then return ('%.1f'):format(avg) end
            return ('%d'):format(avg)
        end)

        local jmp_ecx = client_find_signature('engine.dll', '\xFF\xE1')
        local fnGetModuleHandle = ffi.cast('uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)', jmp_ecx)
        local fnGetProcAddress = ffi.cast('uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)', jmp_ecx)
        
        local pGetProcAddress = ffi.cast('uint32_t**', ffi.cast('uint32_t', client_find_signature('engine.dll', '\xFF\x15\xCC\xCC\xCC\xCC\xA3\xCC\xCC\xCC\xCC\xEB\x05')) + 2)[0][0]
        local pGetModuleHandle = ffi.cast('uint32_t**', ffi.cast('uint32_t', client_find_signature('engine.dll', '\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x74\x0B')) + 2)[0][0]
        local BindExports = function(sModuleName, sFunctionName, sTypeOf) local ctype = ffi.typeof(sTypeOf) return function(...) return ffi.cast(ctype, jmp_ecx)(fnGetProcAddress(pGetProcAddress, 0, fnGetModuleHandle(pGetModuleHandle, 0, sModuleName), sFunctionName), 0, ...) end end
        
        local fnEnumDisplaySettingsA = BindExports("user32.dll", "EnumDisplaySettingsA", "int(__fastcall*)(unsigned int, unsigned int, unsigned int, unsigned long, void*)");
        local pLpDevMode = ffi.new("struct { char pad_0[120]; unsigned long dmDisplayFrequency; char pad_2[32]; }[1]")
        
        local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
        local gram_update = function(tab, value, forced) local new_tab = tab; if forced or new_tab[#new_tab] ~= value then table_insert(new_tab, value); table_remove(new_tab, 1); end; tab = new_tab; end
        local get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end
        
        local renderTime = client_timestamp()
        local lag_data = gram_create(0, 90)
        local fps_data = gram_create(0, 30)
        local g_frameRate, g_prev_frameRate = 0, 0
        
        local post_render, pre_render = function()
            renderTime = client_timestamp()
        end, function()
            gram_update(lag_data, client_timestamp() - renderTime)
        end
        
        client_set_event_callback('post_render', post_render)
        client_set_event_callback('pre_render', pre_render)

        fnEnumDisplaySettingsA(0, 4294967295, pLpDevMode[0])

		local g_paint_handler = function()
            g_frameRate = 0.9 * g_frameRate + (1.0 - 0.9) * globals_absoluteframetime()
            gram_update(fps_data, math_abs(g_prev_frameRate-(1/g_frameRate)), true)
            g_prev_frameRate = 1/g_frameRate

			local state = ui_get(ms_ieinfo)
			local _, _, _, a = get_bar_color()

      note.set_state(state)
			note.get(function(id)

                local r, g, b = get_bar_color()

				local data_wd = script_db.window or { }
				local data_wm = script_db.watermark or { }
                local height = data_wd.height and data_wd.height.value or 0
                local rounding = data_wd.rounding and data_wd.rounding.value or 4
                local thickness = data_wd.thickness and data_wd.thickness.value or 0
                local glow = data_wd.glow and data_wd.glow.value or 0

                local avg = get_average(lag_data)
                local display_frequency = tonumber(pLpDevMode[0].dmDisplayFrequency)
				local text = ('%sms / %dhz'):format(formatting(avg), display_frequency)
		
                local interp = { get_color(15-avg, 15) }

				local h, w = 17, renderer_measure_text(nil, text) + 8

				local x, y = client_screen_size(), 7 + (23 * id) + height + thickness

				if data_wm.left then
					if not ui_get(ms_exploit) then
						y = 7 + (25*id) + height
					else
					y = 7 + (23 * id + height)
					end
				else
					if not ui_get(ms_exploit) then
						y = 7 + (25*id) + height + thickness
					else
					y = 7 + (23 * id + height + thickness	)
					end
				end
		
				x = x - w - 10

				rectangle_filed(x, y, w, h, rounding, 17, 17, 17, a, 1)
                renderer_gradient(x, y +h - 1, (w/2), 1, 0, 0, 0, 25, interp[1], interp[2], interp[3], 255, true)
                renderer_gradient(x + w/2, y+h - 1, w-w/2, 1, interp[1], interp[2], interp[3], 255, 0, 0, 0, 25, true)
				renderer_text(x+4, y + 2, 255, 255, 255, 255, '', 0, text)

                x = x - w + 26

                local text = 'IO | '
                local sub = text .. '\x20\x20\x20\x20\x20\x20\x20'
                local h, w = 17, renderer_measure_text(nil, sub) + 8
                local ie_w = renderer_measure_text(nil, text) + 4

                local g_nValues_t = { 
                    avg, 1, 3, 
                    get_average(fps_data)/4, 0
                }

                local min_value, max_value = 
                    math_min(unpack(g_nValues_t)), 
                    math_max(unpack(g_nValues_t))

				rectangle_filed(x - 4, y, w, h, rounding, 17, 17, 17, a, 1)
				left_outline(x - 4, y, w, h, rounding, r, g, b, 255, math_max(math_min(height, 2), 1), a * 255)
                renderer_text(x, y + 2, 255, 255, 255, 255, '', 0, sub)

                graphics:draw_histogram(g_nValues_t, 0, max_value, #g_nValues_t, {
                    -- x, y, w, h
                    x = x - 4 + ie_w,
                    y = y + 4, 
                    w = w - ie_w - 4,
                    h = h - 8,
            
                    sDrawBar = "gradient_fadein", -- "none", "fill", "gradient_fadeout", "gradient_fadein"
                    bDrawPeeks = false,
                    thickness = 1,
            
                    clr_1 = { r, g, b, 255 },
                    clr_2 = { 0, 127, 255, 255 },
                }, false)
			end)
		end

		client_set_event_callback('paint_ui', g_paint_handler)
    end,

	editor = function()
		local data_editor = function()
			local editor, editor_data, editor_cache, editor_callback = 
				ui_new_checkbox(menu_tab[1], menu_tab[2], 'Solus Data editor'), { }, { }, function() end
			
			for name, val in pairs(script_db) do
				if name ~= 'keybinds' then
					table_insert(editor_data, ui_new_label(menu_tab[1], menu_tab[2], name:upper()))
	
					for sname, sval in pairs(val) do
						local sval_type = type(sval)

						local _action = {
							['string'] = function()
								local _cfunction
								local label, textbox = 
									ui_new_label(menu_tab[1], menu_tab[2], ('	  > %s \n %s:%s'):format(sname, name, sname)), 
									ui_new_textbox(menu_tab[1], menu_tab[2], ('%s:%s'):format(name, sname))
	
								ui_set(textbox, script_db[name][sname])
	
								_cfunction = function()
									script_db[name][sname] = ui_get(textbox)
									client_delay_call(0.01, function()
										_cfunction()
									end)
								end
	
								_cfunction()
	
								return { label, textbox }
							end,
	
							['boolean'] = function()
								local checkbox = ui_new_checkbox(menu_tab[1], menu_tab[2], ('	  > %s \n %s:%s'):format(sname, name, sname))
	
								ui_set(checkbox, sval)
								ui_set_callback(checkbox, function(c)
									script_db[name][sname] = ui_get(c)
								end)
	
								return { checkbox }
							end,
	
							['table'] = function()
								local slider = ui_new_slider(menu_tab[1], menu_tab[2], ('	  > %s \n %s:%s'):format(sname, name, sname), sval.min, sval.max, sval.init_val, true, nil, sval.scale)
	
								ui_set(slider, sval.value or sval.init_val)
								ui_set_callback(slider, function(c)
									script_db[name][sname].value = ui_get(c)
								end)
	
								return { slider }
							end
						}
	
						if _action[sval_type] ~= nil then
							for _, val in pairs(_action[sval_type]()) do
								table_insert(editor_data, val)
							end
						end
					end
				end
			end
	
			local pre_config_save = function()
				ui_set(editor, false)
	
		
				for _, ref in pairs(editor_data) do
					editor_cache[ref] = ui_get(ref)
				end
			end
		
			local post_config_save = function()
				ui_set(editor, false)
				
				for _, ref in pairs(editor_data) do
					if editor_cache[ref] ~= nil then
						ui_set(ref, editor_cache[ref])
						editor_cache[ref] = nil
					end
				end
			end
		
			client_set_event_callback('pre_config_save', function() pre_config_save() end)
			client_set_event_callback('post_config_save', function() post_config_save() end)
			client_set_event_callback('pre_config_load', function() pre_config_save() end)
			client_set_event_callback('post_config_load', function() post_config_save() end)
	
			editor_callback = function()
				local editor_active = ui_get(editor)
		
				for _, ref in pairs(editor_data) do
					ui_set_visible(ref, editor_active)
				end
			end
		
			ui_set_callback(editor, editor_callback)
			editor_callback()
		end
	
		local keybind_editor = function()
			local create_table = function(tbl)
				local new_table = { }
		
				for k in pairs(tbl) do
					table_insert(new_table, k)
				end
			
				table_sort(new_table, function(a, b) 
					return a:lower() < b:lower() 
				end)
		
				local new_table2 = { 
					'» Create new keybind'
				}
		
				for i=1, #new_table do
					table_insert(new_table2, new_table[i])
				end
		
				return new_table2
			end
		
			local generate_kb = function()
				local new_table = { }
				
				for id, hotkey in pairs(script_db.keybinds) do
					local custom_name = hotkey.custom_name
					custom_name = (custom_name and #tostring(custom_name) > 0) and custom_name or nil
	
					new_table[custom_name or (hotkey.reference[3] or '?')] = {
						hotkey_id = id,
						reference = hotkey.reference,
						custom_name = hotkey.custom_name,
						ui_offset = hotkey.ui_offset,
						require = hotkey.require
					}
				end
	
				return new_table
			end
			
			local hk_callback, listbox_callback
			local original_hk = {
				reference = { '', '', '' },
				custom_name = '',
				ui_offset = 1,
				require = ''
			}
	
			local offset_type = {
				'Basic',
				'Extended'
			}
	
			local new_hotkey = original_hk
			
			local hk_database = generate_kb()
			local hk_list = create_table(hk_database)
	
			local hk_editor = ui_new_checkbox(menu_tab[1], menu_tab[2], 'Solus Hotkey editor')
			local listbox = ui_new_listbox(menu_tab[1], menu_tab[2], 'Solus Keybinds', hk_list)
		
			local require = {
				ui_new_checkbox(menu_tab[1], menu_tab[2], 'Custom hotkey'),
		
				ui_new_label(menu_tab[1], menu_tab[2], 'File name (without ".lua")'),
				ui_new_textbox(menu_tab[1], menu_tab[2], 'solus:keybinds:required_file')
			}
		
			local custom_name = {
				ui_new_checkbox(menu_tab[1], menu_tab[2], 'Custom name'),
				ui_new_label(menu_tab[1], menu_tab[2], 'Original name'),
				ui_new_textbox(menu_tab[1], menu_tab[2], 'solus:keybinds:custom_name')
			}
	
			local reference = {
				ui_new_label(menu_tab[1], menu_tab[2], 'Reference'),
				ui_new_textbox(menu_tab[1], menu_tab[2], 'solus:keybinds:reference1'),
				ui_new_textbox(menu_tab[1], menu_tab[2], 'solus:keybinds:reference2'),
				ui_new_textbox(menu_tab[1], menu_tab[2], 'solus:keybinds:reference3')
			}
	
			local ui_offset = {
				ui_new_combobox(menu_tab[1], menu_tab[2], 'Hotkey type', offset_type),
				ui_new_hotkey(menu_tab[1], menu_tab[3], ('Example: %s'):format(offset_type[1])),
	
				ui_new_checkbox(menu_tab[1], menu_tab[3], ('Example: %s'):format(offset_type[2])),
				ui_new_hotkey(menu_tab[1], menu_tab[3], ' ', true),
	
				ui_new_combobox(menu_tab[1], menu_tab[3], ('Example: %s'):format(offset_type[2]), '-'),
				ui_new_hotkey(menu_tab[1], menu_tab[3], ' ', true),
			}
	
			local save_changes = ui_new_button(menu_tab[1], menu_tab[2], 'Save Changes', function()
				local selected = hk_list[ui_get(listbox)+1] or hk_list[1]
				local ui_offset = ui_get(ui_offset[1]) == offset_type[2] and 2 or 1
	
				local reference = { ui_get(reference[2]):lower(), ui_get(reference[3]):lower(), ui_get(reference[4]) }
				local custom_name = ui_get(custom_name[1]) and ui_get(custom_name[3]) or ''
	
				if selected ~= hk_list[1] then
					local cdata = hk_database[selected]
	
					if cdata ~= nil then
						script_db.keybinds[cdata.hotkey_id] = {
							ui_offset = ui_offset,
							reference = reference,
							require = ui_get(require[1]) and ui_get(require[3]):lower() or '',
							custom_name = custom_name
						}
					end
				else
					local can_create, item = true, {
						ui_offset = ui_offset,
						reference = reference,
						require = ui_get(require[1]) and ui_get(require[3]) or '',
						custom_name = custom_name
					}
	
					local item_ref = { 
						item.reference[1]:lower(),
						item.reference[2]:lower(),
						item.reference[3]:lower()
					}
	
					for id, val in pairs(script_db.keybinds) do
						local val_ref = { 
							val.reference[1]:lower(),
							val.reference[2]:lower(),
							val.reference[3]:lower()
						}
	
						if val_ref[1] == item_ref[1] and val_ref[2] == item_ref[2] and val_ref[3] == item_ref[3] then
							can_create = false
							break
						end
					end
	
					if can_create and m_hotkeys_create(item) then
						script_db.keybinds[#script_db.keybinds+1] = item
	
						client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
						client_color_log(255, 255, 255, 'Created hotkey \1\0')
						client_color_log(155, 220, 220, ('[ %s ]'):format(table_concat(item.reference, ' > ')))
					end
	
					if not can_create then
						client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
						client_color_log(255, 255, 255, 'Could\'nt create hotkey \1\0')
						client_color_log(155, 220, 220, '[ keybind already exists ]')
						error()
					end
				end
	
				m_hotkeys_update = true
	
				hk_database = generate_kb()
				hk_list = create_table(hk_database)
	
				ui_update(listbox, hk_list)
				
				listbox_callback(listbox)
				hk_callback()
			end)
	
			local delete_hk = ui_new_button(menu_tab[1], menu_tab[2], 'Delete Hotkey', function()
				local selected = hk_list[ui_get(listbox)+1] or hk_list[1]
	
				if selected ~= hk_list[1] then
					local cdata = hk_database[selected]
	
					script_db.keybinds[cdata.hotkey_id] = nil
	
					local new_db = { }
	
					for i=1, #script_db.keybinds do
						if script_db.keybinds[i] ~= nil then
							new_db[#new_db+1] = script_db.keybinds[i]
						end
					end
	
					script_db.keybinds = new_db
	
					client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client_color_log(255, 255, 255, 'Removed hotkey \1\0')
					client_color_log(155, 220, 220, ('[ %s ]'):format(table_concat(cdata.reference, ' > ')))
	
					m_hotkeys_update = true
	
					hk_database = generate_kb()
					hk_list = create_table(hk_database)
		
					ui_update(listbox, hk_list)
					
					listbox_callback(listbox)
					hk_callback()
					
				end
			end)
		
			hk_callback = function()
				local active = ui_get(hk_editor)
				local LBC = ui_get(listbox) == 0
		
				ui_set_visible(listbox, active)
		
				ui_set_visible(require[1], active and LBC)
				ui_set_visible(require[2], active and ui_get(require[1]) and LBC)
				ui_set_visible(require[3], active and ui_get(require[1]) and LBC)
		
				ui_set_visible(custom_name[1], active)
				ui_set_visible(custom_name[2], active and ui_get(custom_name[1]) and not LBC)
				ui_set_visible(custom_name[3], active and ui_get(custom_name[1]))
	
				ui_set_visible(reference[1], active)
				ui_set_visible(reference[2], active and LBC)
				ui_set_visible(reference[3], active and LBC)
				ui_set_visible(reference[4], active and LBC)
	
				ui_set_visible(save_changes, active)
				ui_set_visible(delete_hk, active and not LBC)
	
				for i=1, #ui_offset do
					ui_set_visible(ui_offset[i], active and LBC)
				end
			end
	
			listbox_callback = function(c)
				local local_bd = hk_database
				local selected = hk_list[ui_get(c)+1] or hk_list[1]
	
				local cdata = local_bd[selected]
	
				if cdata == nil then
					cdata = new_hotkey
				end
	
				local ext_data = {
					require = { #cdata.require > 0, cdata.require or '' },
					custom_name = { cdata.custom_name ~= '', ('Original name: %s'):format(cdata.reference[3]), cdata.custom_name },
	
					reference = { 
						('Reference: %s > %s (%d)'):format(cdata.reference[1], cdata.reference[2], cdata.ui_offset), 
						cdata.reference[1], cdata.reference[2], cdata.reference[3]
					},
	
					ui_offset = cdata.ui_offset
				}
	
				ui_set(reference[1], selected ~= hk_list[1] and ext_data.reference[1] or 'Reference')
	
				ui_set(require[1], ext_data.require[1])
				ui_set(require[3], ext_data.require[2])
			
				ui_set(custom_name[1], ext_data.custom_name[1])
				ui_set(custom_name[2], ext_data.custom_name[2])
				ui_set(custom_name[3], ext_data.custom_name[3])
	
				ui_set(reference[2], ext_data.reference[2])
				ui_set(reference[3], ext_data.reference[3])
				ui_set(reference[4], ext_data.reference[4])
	
				ui_set(ui_offset[1], offset_type[ext_data.ui_offset])
	
				hk_callback()
			end
	
			client_set_event_callback('pre_config_save', function() ui_set(hk_editor, false) end)
			client_set_event_callback('post_config_load', function() ui_set(hk_editor, false) end)
	
			ui_set_callback(hk_editor, hk_callback)
			ui_set_callback(listbox, listbox_callback)
			ui_set_callback(require[1], hk_callback)
			ui_set_callback(custom_name[1], hk_callback)
		
			hk_callback()
	
			return hk_editor
		end
	
		client_set_event_callback('console_input', function(e)
			local e = e:gsub(' ', '')
			local _action = {
				['solus:watermark:set_suffix'] = function()
					script_db.watermark.suffix = ''
					database_write(database_name, script_db)
		
					client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client_color_log(155, 220, 220, 'Suffix is now active')
	
					client_reload_active_scripts()
				end,
	
				['solus:watermark:unset_suffix'] = function()
					script_db.watermark.suffix = nil
					database_write(database_name, script_db)
		
					client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client_color_log(155, 220, 220, 'Suffix is now inactive')
	
					client_reload_active_scripts()
				end,
	
				['solus:reset'] = function()
					for name in pairs(script_db) do
						script_db[name] = name == 'keybinds' and script_db.keybinds or { }
					end
	
					database_write(database_name, script_db)
	
					client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client_color_log(255, 0, 0, 'Wiping data sectors')
	
					client_reload_active_scripts()
				end,
	
				['solus:keybinds:reset'] = function()
					script_db.keybinds = original_db.keybinds
	
					database_write(database_name, script_db)
	
					client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client_color_log(255, 0, 0, 'Wiping keybinds sector')
	
					client_reload_active_scripts()
				end
			}
	
			if _action[e] ~= nil then
				_action[e]()
	
				return true
			end
		end)
	
		data_editor()
		keybind_editor()
	end
}

ms_classes.watermark()
ms_classes.spectators()
ms_classes.keybinds()
ms_classes.exploit()
ms_classes.ilstate()

client_delay_call(0.1, ms_classes.editor)
client_set_event_callback('shutdown', function()
	database_write(database_name, script_db)
end)

local ms_fade_callback = function()
	local active = ui_get(ms_palette)

	ui_set_visible(ms_rainbow_frequency, active ~= menu_palette[1] and active == menu_palette[2])
	ui_set_visible(ms_rainbow_split_ratio, active ~= menu_palette[1])
end

ui_set_callback(ms_palette, ms_fade_callback)
ms_fade_callback()