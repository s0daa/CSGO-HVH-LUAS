---@diagnostic disable: need-check-nil, undefined-global
local helpers = {}
local ms = {}
local visuals = { helpers = {}, hotkey_list = {}, watermark = {}, spectator_list = {}, antiaim = {}, ilstate = {} }

local color = function(r, g, b, a)
    return color_t(math.floor(r), math.floor(g), math.floor(b), math.floor(a) or 255)
end

visuals.helpers.screen_size = render.get_screen_size()
visuals.helpers.verdana = render.create_font('Verdana', 12, 350, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
helpers.dragging_fn = function(a,b,c)return(function()local d={}local e,f,g,h,i,j,k,l,m,n,o,p,q,r;local s={__index={drag=function(self,...)local t,u=self:get()local v,w=d.drag(t,u,...)if t~=v or u~=w then self:set(v,w)end;return v,w end,set=function(self,t,u)local m,n=visuals.helpers.screen_size.x,visuals.helpers.screen_size.y;self.x_reference:set(t/m*self.res)self.y_reference:set(u/n*self.res)end,get=function(self)local m,n=visuals.helpers.screen_size.x,visuals.helpers.screen_size.y;return self.x_reference:get()/self.res*m,self.y_reference:get()/self.res*n end}}function d.new(x,y,z,A)A=A or 10000;local m,n=visuals.helpers.screen_size.x,visuals.helpers.screen_size.y;local B=menu.add_slider('a',x..' window position',0,A)if B:get()==0 then B:set(y/m*A)end;local C=menu.add_slider('a',x..' window position y',0,A)if C:get()==0 then C:set(z/n*A)end;B:set_visible(false)C:set_visible(false)return setmetatable({name=x,x_reference=B,y_reference=C,res=A},s)end;function d.drag(t,u,D,E,F,G,H)if global_vars.frame_count()~=e then f=menu.is_open()i,j=g,h;g,h=input.get_mouse_pos().x,input.get_mouse_pos().y;l=k;k=input.is_key_held(e_keys.MOUSE_LEFT)p=o;o={}r=q;q=false;m,n=visuals.helpers.screen_size.x,visuals.helpers.screen_size.y end;if f and l~=nil then if(not l or r)and k and i>t and j>u and i<t+D and j<u+E then q=true;t,u=t+g-i,u+h-j;if not G then t=math.max(0,math.min(m-D,t))u=math.max(0,math.min(n-E,u))end end end;table.insert(o,{t,u,D,E})return t,u,D,E end;return d end)().new(a,b,c)end
helpers.graphs = function()local a={}function a:renderer_line(b,c,d)render.line(vec2_t(b.x,b.y),vec2_t(c.x,c.y),color(d.r,d.g,d.b,d.a))end;function a:renderer_rectangle_outlined(b,c,d)render.line(vec2_t(b.x,b.y),vec2_t(b.x,c.y),color(d.r,d.g,d.b,d.a))render.line(vec2_t(b.x,b.y),vec2_t(c.x,b.y),color(d.r,d.g,d.b,d.a))render.line(vec2_t(c.x,b.y),vec2_t(c.x,c.y),color(d.r,d.g,d.b,d.a))render.line(vec2_t(b.x,c.y),vec2_t(c.x,c.y),color(d.r,d.g,d.b,d.a))end;function a:renderer_rectangle_filled(b,c,d)local e=c.x-b.x;local f=c.y-b.y;if e<0 then if f<0 then render.rect_filled(vec2_t(c.x,c.y),vec2_t(-e,-f),color(d.r,d.g,d.b,d.a))else render.rect_filled(vec2_t(c.x,b.y),vec2_t(-e,f),color(d.r,d.g,d.b,d.a))end else if f<0 then render.rect_filled(vec2_t(b.x,c.y),vec2_t(e,-f),color(d.r,d.g,d.b,d.a))else render.rect_filled(vec2_t(b.x,b.y),vec2_t(e,f),color(d.r,d.g,d.b,d.a))end end end;function a:renderer_rectangle_outlined(b,c,d)render.line(vec2_t(b.x,b.y),vec2_t(b.x,c.y),color(d.r,d.g,d.b,d.a))render.line(vec2_t(b.x,b.y),vec2_t(c.x,b.y),color(d.r,d.g,d.b,d.a))render.line(vec2_t(c.x,b.y),vec2_t(c.x,c.y),color(d.r,d.g,d.b,d.a))render.line(vec2_t(b.x,c.y),vec2_t(c.x,c.y),color(d.r,d.g,d.b,d.a))end;function a:renderer_rectangle_filled_gradient(b,c,g,h,i)local e=c.x-b.x;local f=c.y-b.y;if e<0 then if f<0 then render.rect_fade(vec2_t(c.x,c.y),vec2_t(-e,-f),color_t(g.r.r,g.r.g,g.r.b,255),color_t(h.r.r,h.r.g,h.r.b,0),i)else render.rect_fade(vec2_t(c.x,b.y),vec2_t(-e,f),color_t(g.r.r,g.r.g,g.r.b,255),color_t(h.r.r,h.r.g,h.r.b,0),i)end else if f<0 then render.rect_fade(vec2_t(b.x,c.y),vec2_t(e,-f),color_t(h.r.r,h.r.g,h.r.b,0),color_t(g.r.r,g.r.g,g.r.b,255),i)else render.rect_fade(vec2_t(b.x,b.y),vec2_t(e,f),color_t(h.r.r,h.r.g,h.r.b,0),color_t(g.r.r,g.r.g,g.r.b,255),i)end end end;function a:draw(j,k,l,m,n,o)local p=k;local q=n.clr_1;k=0;l=l-p;n.h=n.h-n.thickness;if o then a:renderer_rectangle_outlined({x=n.x,y=n.y},{x=n.x+n.w-1,y=n.y+n.h-1+n.thickness},{r=q[1],g=q[2],b=q[3],a=q[4]})end;if k==l then a:renderer_line({x=n.x,y=n.y+n.h},{x=n.x+n.w,y=n.y+n.h},{r=q[1],g=q[2],b=q[3],a=q[4]})return end;local r=n.w/(m-1)local s=l-k;for t=1,m-1 do local u={(j[t]-p)/s,(j[t+1]-p)/s}local v={{x=n.x+r*(t-1),y=n.y+n.h-n.h*u[1]},{x=n.x+r*t,y=n.y+n.h-n.h*u[2]}}for t=1,n.thickness do a:renderer_line({x=v[1].x,y=v[1].y+t-1},{x=v[2].x,y=v[2].y+t-1},{r=q[1],g=q[2],b=q[3],a=q[4]})end end end;function a:draw_histogram(j,k,l,m,n,o)local p=k;k=0;l=l-p;if o then a:renderer_rectangle_outlined({x=n.x,y=n.y},{x=n.x+n.w-1,y=n.y+n.h-1},{r=255,g=255,b=255,a=255})end;local r=n.w/(m-1)local s=l-k;for t=1,m-1 do local u={(j[t]-p)/s,(j[t+1]-p)/s}local v={{x=math.floor(n.x+r*(t-1)),y=math.floor(n.y+n.h-n.h*u[1])},{x=math.floor(n.x+r*t),y=math.floor(n.y+n.h)},isZero=math.floor(n.y+n.h)==math.floor(n.y+n.h-n.h*u[1])}if n.sDrawBar=='fill'then a:renderer_rectangle_filled({x=v[1].x,y=v[1].y},{x=v[2].x,y=v[2].y},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=n.clr_1[4]})elseif n.sDrawBar=='gradient_fadeout'then a:renderer_rectangle_filled_gradient({x=v[1].x,y=v[1].y},{x=v[2].x,y=v[2].y},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=0},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=n.clr_1[4]},false)elseif n.sDrawBar=='gradient_fadein'then a:renderer_rectangle_filled_gradient({x=v[1].x,y=v[1].y},{x=v[2].x,y=v[2].y},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=n.clr_1[4]},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=0},false)else end;if n.bDrawPeeks and not v.isZero then a:renderer_line({x=v[1].x,y=v[1].y},{x=v[2].x,y=v[1].y},{r=n.clr_2[1],g=n.clr_2[2],b=n.clr_2[3],a=n.clr_2[4]})end end end;return a end
helpers.gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
helpers.gram_update = function(tab, value, forced) local new_tab = tab; if forced or new_tab[#new_tab] ~= value then table.insert(new_tab, value); table.remove(new_tab, 1); end; tab = new_tab; end
helpers.get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end
helpers.hsv_to_rgb = function(b,c,d,e)local f,g,h;local i=math.floor(b*6)local j=b*6-i;local k=d*(1-c)local l=d*(1-j*c)local m=d*(1-(1-j)*c)i=i%6;if i==0 then f,g,h=d,m,k elseif i==1 then f,g,h=l,d,k elseif i==2 then f,g,h=k,d,m elseif i==3 then f,g,h=k,l,d elseif i==4 then f,g,h=m,k,d elseif i==5 then f,g,h=d,k,l end;return f*255,g*255,h*255,e*255 end
helpers.item_count = function(b)if b==nil then return 0 end;if#b==0 then local c=0;for d in pairs(b)do c=c+1 end;return c end;return#b end

ms.watermark = menu.add_checkbox('Presets', 'Watermark', false)
ms.spectators = menu.add_checkbox('Presets', 'Spectators', false)
ms.keybinds = menu.add_checkbox('Presets', 'Hotkey list', false)
ms.antiaim = menu.add_checkbox('Presets', 'Anti-aimbot indication', false)
ms.ieinfo = menu.add_checkbox('Presets', 'Frequency update information', false)

ms.palette = menu.add_selection('Presets', 'Solus Palette', {'Solid', 'Fade', 'Dynamic fade'})
ms.color = ms.palette:add_color_picker('Solus Global color', color(142, 165, 229, 85))

ms.fade_offset = menu.add_slider('Presets', 'Fade offset', 1, 1000, 0.001)
if ms.fade_offset:get() == 1 then ms.fade_offset:set(825) end
ms.fade_frequency = menu.add_slider('Presets', 'Fade frequency', 1, 100, 0.01)
if ms.fade_frequency:get() == 1 then ms.fade_frequency:set(10) end
ms.fade_split_ratio = menu.add_slider('Presets', 'Fade split ratio', 0, 100, 0.01)
if ms.fade_split_ratio:get() == 0 then ms.fade_split_ratio:set(100) end

local screen_size = {
    visuals.helpers.screen_size.x - visuals.helpers.screen_size.x * cvars.safezonex:get_float(),
    visuals.helpers.screen_size.y * cvars.safezoney:get_float()
}
local keybinds = {
    keys = {
        ['Double tap'] = menu.find('aimbot', 'general', 'exploits', 'doubletap', 'enable'),
        ['On shot anti-aim'] = menu.find('aimbot', 'general', 'exploits', 'hideshots', 'enable'),
        ['Quick peek assist'] = menu.find('aimbot', 'general', 'misc', 'autopeek'),
        ['Duck peek assist'] = menu.find('antiaim', 'main', 'general', 'fake duck'),
        ['Freestanding'] = menu.find('antiaim', 'main', 'auto direction', 'enable'),
        ['Jump at edge'] = menu.find('misc', 'main', 'movement', 'edge jump'),
        ['Sneak'] = menu.find('misc', 'main', 'movement', 'sneak'),
        ['Jump at edge'] = menu.find('misc', 'main', 'movement', 'edge bug helper'),
        ['Jump bug'] = menu.find('misc', 'main', 'movement', 'jump bug'),
        ['Fire extinguisher'] = menu.find('misc', 'utility', 'general', 'fire extinguisher'),
        ['Free look'] = menu.find('misc', 'utility', 'general', 'freecam'),
        ['Damage override'] = menu.find('aimbot', 'auto', 'target overrides', 'force min. damage'),
        ['Damage override'] = menu.find('aimbot', 'scout', 'target overrides', 'force min. damage'),
        ['Damage override'] = menu.find('aimbot', 'awp', 'target overrides', 'force min. damage'),
        ['Damage override'] = menu.find('aimbot', 'deagle', 'target overrides', 'force min. damage'),
        ['Damage override'] = menu.find('aimbot', 'revolver', 'target overrides', 'force min. damage'),
        ['Damage override'] = menu.find('aimbot', 'pistols', 'target overrides', 'force min. damage'),
        ['Damage override'] = menu.find('aimbot', 'other', 'target overrides', 'force min. damage'),
        ['Lethal shot'] = menu.find('aimbot', 'auto', 'target overrides', 'force lethal shot'),
        ['Lethal shot'] = menu.find('aimbot', 'scout', 'target overrides', 'force lethal shot'),
        ['Lethal shot'] = menu.find('aimbot', 'awp', 'target overrides', 'force lethal shot'),
        ['Lethal shot'] = menu.find('aimbot', 'deagle', 'target overrides', 'force lethal shot'),
        ['Lethal shot'] = menu.find('aimbot', 'revolver', 'target overrides', 'force lethal shot'),
        ['Lethal shot'] = menu.find('aimbot', 'pistols', 'target overrides', 'force lethal shot'),
        ['Lethal shot'] = menu.find('aimbot', 'other', 'target overrides', 'force lethal shot'),
        ['Safe point'] = menu.find('aimbot', 'auto', 'target overrides', 'force safepoint'),
        ['Safe point'] = menu.find('aimbot', 'scout', 'target overrides', 'force safepoint'),
        ['Safe point'] = menu.find('aimbot', 'awp', 'target overrides', 'force safepoint'),
        ['Safe point'] = menu.find('aimbot', 'deagle', 'target overrides', 'force safepoint'),
        ['Safe point'] = menu.find('aimbot', 'revolver', 'target overrides', 'force safepoint'),
        ['Safe point'] = menu.find('aimbot', 'pistols', 'target overrides', 'force safepoint'),
        ['Safe point'] = menu.find('aimbot', 'other', 'target overrides', 'force safepoint'),
        ['Body lean safe point'] = menu.find('aimbot', 'auto', 'target overrides', 'force body lean safepoint'),
        ['Body lean safe point'] = menu.find('aimbot', 'scout', 'target overrides', 'force body lean safepoint'),
        ['Body lean safe point'] = menu.find('aimbot', 'awp', 'target overrides', 'force body lean safepoint'),
        ['Body lean safe point'] = menu.find('aimbot', 'deagle', 'target overrides', 'force body lean safepoint'),
        ['Body lean safe point'] = menu.find('aimbot', 'revolver', 'target overrides', 'force body lean safepoint'),
        ['Body lean safe point'] = menu.find('aimbot', 'pistols', 'target overrides', 'force body lean safepoint'),
        ['Body lean safe point'] = menu.find('aimbot', 'other', 'target overrides', 'force body lean safepoint'),
        ['Resolver override'] = menu.find('aimbot', 'general', 'aimbot', 'override resolver'),
        ['Body lean resolver'] = menu.find('aimbot', 'general', 'aimbot', 'body lean resolver'),
        ['Ping spike'] = menu.find('aimbot', 'general', 'fake ping', 'enable'),
        ['Lock angle'] = menu.find('antiaim', 'main', 'general', 'lock angle')
    },
    modes = {'toggled', 'holding', '~', '~', 'disabled'}
}

helpers.get_bar_color = function()
	local r, g, b, a = ms.color:get().r, ms.color:get().g, ms.color:get().b, ms.color:get().a

	local palette = ms.palette:get()

	if palette ~= 1 then
		local rgb_split_ratio = ms.fade_split_ratio:get() / 100

		local h = palette == 3 and 
        global_vars.real_time() * (ms.fade_frequency:get() / 100) or 
			ms.fade_offset:get() / 1000

		r, g, b = helpers.hsv_to_rgb(h, 1, 1, 1)
		r, g, b = 
			r * rgb_split_ratio, 
			g * rgb_split_ratio, 
			b * rgb_split_ratio
	end

	return math.floor(r), math.floor(g), math.floor(b), math.floor(a)
end

helpers.get_color = function(number, max, i)
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
        i = (i >= 0 and math.floor(i + 0.5) or math.ceil(i - 0.5))

        return i
    end

    i = math_num(number, max, #Colors)

    return
        Colors[i <= 1 and 1 or i][1], 
        Colors[i <= 1 and 1 or i][2],
        Colors[i <= 1 and 1 or i][3],
        i
end

visuals.watermark.draw = function()
    local r, g, b, a = helpers.get_bar_color()

    if ms.watermark:get() then
        local actual_time = ('%02d:%02d:%02d'):format(client.get_local_time())
        local gc_state = --[[ not ]] is_connected_to_gc and '\x20\x20\x20\x20\x20' or 'primordial.dev'
        local nickname = user.name
        local suffix = ''
        local id = 0
        local text = ('%s%s | %s | %s'):format(gc_state, suffix, nickname, actual_time)

        if engine.is_in_game() then
            local latency = engine.get_latency(e_latency_flows.OUTGOING)*1000
            local latency_text = latency > 5 and (' | delay: %dms'):format(latency) or ''

            text = ('%s%s | %s%s | %s'):format(gc_state, suffix, nickname, latency_text, actual_time)
        end

        local h, w = 18, render.get_text_size(visuals.helpers.verdana, text).x + 8
	        local x, y = visuals.helpers.screen_size.x, 10 + (25*id)

	        x = x - w - 10

        if ms.palette:get() == 1 then
            render.rect_filled(vec2_t(x, y), vec2_t(w, 2), color(r, g, b, 255))
        else
            render.rect_fade(vec2_t(x, y), vec2_t((w/2)+1, 2), color(g, b, r, 255), color(r, g, b, 255), true)
            render.rect_fade(vec2_t(x + w/2, y), vec2_t(w-w/2, 2), color(r, g, b, 255), color(b, r, g, 255), true)
        end

        render.rect_filled(vec2_t(x, y + 2), vec2_t(w, h), color(17, 17, 17, a))
        render.text(visuals.helpers.verdana, text, vec2_t(x+4, y + 4), color(255, 255, 255, 255))

        if --[[ not ]] is_connected_to_gc then
            local realtime = global_vars.real_time()*1.5

            if realtime%2 <= 1 then
                --renderer_circle_outline(x+10, y + 11, 89, 119, 239, 255, 5, 0, realtime%1, 2)
                render.progress_circle(vec2_t.new(x+10, y + 11), 5, color.new(89, 119, 239, 255), 2, realtime%1)
            else
                render.progress_circle(vec2_t.new(x+10, y + 11), 5, color.new(89, 119, 239, 255), 2, 1-realtime%1)
                --renderer_circle_outline(x+10, y + 11, 89, 119, 239, 255, 5, realtime%1*370, 1-realtime%1, 2)
            end
        end
    end
end

local gram_fyaw = helpers.gram_create(0, 2)
local teleport_data = helpers.gram_create(0, 3)

local ind_phase, ind_num, ind_time = 0, 0, 0
local last_sent, current_choke = 0, 0
local teleport, last_origin = 0
local breaking_lc = 0

visuals.antiaim.g_setup_command = function(cmd)
    local me = entity_list.get_local_player()
    local real_yaw = antiaim.get_real_angle()
    local fake_yaw = antiaim.get_fake_angle()
    local body_yaw = math.min(math.abs(real_yaw - fake_yaw) / 2, 58)

    if engine.get_choked_commands() == 0 then
        local m_origin = me:get_render_origin()

        if last_origin ~= nil then
            teleport = #(m_origin-last_origin)

            helpers.gram_update(teleport_data, teleport, true)
        end

        helpers.gram_update(gram_fyaw, math.abs(body_yaw), true)

        last_sent = current_choke
        last_origin = m_origin
    end

    breaking_lc = 
        helpers.get_average(teleport_data) > 65 and 1 or
            (exploits.get_charge() > 0 and 2 or 0)

    current_choke = engine.get_choked_commands()
end

visuals.antiaim.draw = function()
    local me = entity_list.get_local_player()

    if me == nil or not me:is_alive() then
        return
    end

    local id = ms.watermark:get() and 1 or 0
    local state = ms.antiaim:get()
    if state then
        local _, _, _, a = helpers.get_bar_color()

        local ms_clr = ms.color:get()

        local addr, nval = '', false
        local r, g, b = 150, 150, 150
        
        local fr = global_vars.frame_time() * 3.75
        local min_offset = 1200+math.max(0, helpers.get_average(teleport_data)-3800)
        local teleport_mt = math.abs(math.min(teleport-3800, min_offset) / min_offset * 100)
        
        if ind_num ~= teleport_mt and ind_time < global_vars.real_time() then
            ind_time = global_vars.real_time() + 0.005
            ind_num = ind_num + (ind_num > teleport_mt and -1 or 1)
        end

        ind_phase = ind_phase + (breaking_lc == 1 and fr or -fr)
        ind_phase = ind_phase > 1 and 1 or ind_phase
        ind_phase = ind_phase < 0 and 0 or ind_phase

        if breaking_lc == 2 then
            addr, ind_phase, ind_num = ' | SHIFTING', 0, 0
            r, g, b = 228, 126, 10
        elseif ind_phase > 0.1 then
            addr = ' | dst: \x20\x20\x20\x20\x20\x20\x20\x20\x20'
        end

        local text = ('FL: %s%s'):format(
            (function()
                if tonumber(last_sent) < 10 then
                    return '\x20\x20' .. last_sent
                end

                return last_sent
            end)(),
        addr)
        
        local h, w = 17, render.get_text_size(visuals.helpers.verdana, text).x + 8
        local x, y = visuals.helpers.screen_size.x, 10 + (25*id)
        
        x = x - w - 10
        
        render.rect_fade(vec2_t(x, y + h), vec2_t(w/2, 1), color(0, 0, 0, 25), color(r, g, b, 255), true)
        render.rect_fade(vec2_t(x + w/2, y + h), vec2_t(w - w/2, 1), color(r, g, b, 255), color(0, 0, 0, 25), true)
        
        render.rect_filled(vec2_t(x, y), vec2_t(w, h), color(17, 17, 17, a))
        render.text(visuals.helpers.verdana, text, vec2_t(x+4, y + 2), color(255, 255, 255, 255))
        
        if ind_phase > 0 then
            render.rect_fade(
                vec2_t(x + w - render.get_text_size(visuals.helpers.verdana,' | dst: ').x + 2, 
                y + 6), vec2_t(math.min(100, ind_num) / 100 * 24, 5),
        
                color(ms_clr[0], ms_clr[1], ms_clr[2], ind_phase*220),
                color(ms_clr[0], ms_clr[1], ms_clr[2], ind_phase * 25),
        
                true
            )
        end

        -- FAKE INDICATION
        local real_yaw = antiaim.get_real_angle()
        local fake_yaw = antiaim.get_fake_angle()
        local body_yaw = math.min(math.abs(real_yaw - fake_yaw) / 2, 58)
        --local lower_body = anti_aim.get_balance_adjust()
        local r, g, b = helpers.get_color(math.abs(body_yaw), 30)

        local text = ('FAKE (%.1f°)'):format(helpers.get_average(gram_fyaw))
        local h, w = 18, render.get_text_size(visuals.helpers.verdana, text).x + 8

        -- INDICATIN GRADIENT
        local dec = { r - (r/100 * 50), g - (g/100 * 50), b - (b/100 * 50) }

        render.rect_fade(vec2_t(x - w - 6, y), vec2_t(2, h / 2), color(dec[1], dec[2], dec[3], 0), color(r, g, b, 255), false)
        render.rect_fade(vec2_t(x - w - 6, y + h/2), vec2_t(2, h / 2), color(r, g, b, 255), color(dec[1], dec[2], dec[3], 0), false)

        -- BACKGROUND GRADIENT
        render.rect_fade(vec2_t(x - w - 4, y), vec2_t(w / 2, h), color(17, 17, 17, 25), color(17, 17, 17, a), true)
        render.rect_fade(vec2_t(x - w - 4 + w / 2, y), vec2_t(w / 2, h), color(17, 17, 17, a), color(17, 17, 17, 25), true)
        render.text(visuals.helpers.verdana, text, vec2_t(x - w, y + 2), color(255, 255, 255, 255))

        --if helpers.get_average(gram_fyaw) > 0 then
        --    render.progress_circle(vec2_t.new(x - w + 6, y + 8.5), 5, color(89, 119, 239, 255), 2, (helpers.get_average(gram_fyaw)*6.21)/360)
        --end
    end
end

local graphics = helpers.graphs()
		
local formatting = (function(avg)
    if avg < 1 then return ('%.2f'):format(avg) end
    if avg < 10 then return ('%.1f'):format(avg) end
    return ('%d'):format(avg)
end)
local jmp_ecx = memory.find_pattern('engine.dll', 'FF E1')
local fnGetModuleHandle = ffi.cast('uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)', jmp_ecx)
local fnGetProcAddress = ffi.cast('uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)', jmp_ecx)

local pGetProcAddress = ffi.cast('uint32_t**', ffi.cast('uint32_t', memory.find_pattern('engine.dll', 'FF 15 ? ? ? ? A3 ? ? ? ? EB 05')) + 2)[0][0]
local pGetModuleHandle = ffi.cast('uint32_t**', ffi.cast('uint32_t', memory.find_pattern('engine.dll', 'FF 15 ? ? ? ? 85 C0 74 0B')) + 2)[0][0]
local BindExports = function(sModuleName, sFunctionName, sTypeOf) local ctype = ffi.typeof(sTypeOf) return function(...) return ffi.cast(ctype, jmp_ecx)(fnGetProcAddress(pGetProcAddress, 0, fnGetModuleHandle(pGetModuleHandle, 0, sModuleName), sFunctionName), 0, ...) end end

local fnEnumDisplaySettingsA = BindExports('user32.dll', 'EnumDisplaySettingsA', 'int(__fastcall*)(unsigned int, unsigned int, unsigned int, unsigned long, void*)');
local pLpDevMode = ffi.new('struct { char pad_0[120]; unsigned long dmDisplayFrequency; char pad_2[32]; }[1]')
fnEnumDisplaySettingsA(0, 4294967295, pLpDevMode[0])
local frequency = pLpDevMode[0].dmDisplayFrequency
local fps_data = helpers.gram_create(0, 30)
local g_frameRate, g_prev_frameRate, avg = 0, 0, 0

visuals.ilstate.draw = function()
    g_frameRate = 0.9 * g_frameRate + (1.0 - 0.9) * global_vars.absolute_frame_time()
    helpers.gram_update(fps_data, math.abs(g_prev_frameRate-(1/g_frameRate)), true)
    g_prev_frameRate = 1/g_frameRate
    local me = entity_list.get_local_player()
    if me == nil then return end
	local state = ms.ieinfo:get()
    local id = ms.watermark:get() and ((ms.antiaim:get() and (me ~= nil and me:is_alive())) and 2 or 1) or ((ms.antiaim:get() and (me ~= nil and me:is_alive())) and 1 or 0)
    if state then
    	local _, _, _, a = helpers.get_bar_color()

        if engine.get_choked_commands() == 0 then
            avg = math.abs(global_vars.frame_time()*600)
        end
    	local text = ('%sms / %dhz'):format(formatting(avg), frequency)
    
        local interp = { helpers.get_color(15-avg, 15) }

    	local h, w = 18, render.get_text_size(visuals.helpers.verdana, text).x + 8
    	local x, y = visuals.helpers.screen_size.x, 10 + (25*id)
    
    	x = x - w - 10

        render.rect_fade(vec2_t(x, y+h), vec2_t((w/2), 1), color(0, 0, 0, 25), color(interp[1], interp[2], interp[3], 255), true)
        render.rect_fade(vec2_t(x + w/2, y+h), vec2_t(w-w/2, 1), color(interp[1], interp[2], interp[3], 255), color(255, 0, 0, 0, 25), true)

        render.rect_filled(vec2_t(x, y), vec2_t(w, h), color(17, 17, 17, a))
        render.text(visuals.helpers.verdana, text, vec2_t(x+4, y + 2), color(255, 255, 255, 255))

        local text = 'IO | '
        local sub = text .. '\x20\x20\x20\x20\x20\x20\x20'
        local h, w = 18, render.get_text_size(visuals.helpers.verdana, sub).x + 8
        local ie_w = render.get_text_size(visuals.helpers.verdana, text).x + 4
        local r, g, b = ms.color:get()

        local g_nValues_t = { 
            avg, 1, 3, 
            helpers.get_average(fps_data)/4, 0
        }

        local min_value, max_value = 
            math.min(unpack(g_nValues_t)), 
            math.max(unpack(g_nValues_t))

        render.rect_filled(vec2_t(x - w - 4, y), vec2_t(w, h), color(17, 17, 17, a))
        render.text(visuals.helpers.verdana, sub, vec2_t(x - w, y + 2), color(255, 255, 255, 255))

        graphics:draw_histogram(g_nValues_t, 0, max_value, #g_nValues_t, {
            -- x, y, w, h
            x = x - w - 4 + ie_w,
            y = y + 4, 
            w = w - ie_w - 4,
            h = h - 8,
        
            sDrawBar = 'gradient_fadein', -- 'none', 'fill', 'gradient_fadeout', 'gradient_fadein'
            bDrawPeeks = false,
            thickness = 1,
        
            clr_1 = { r, g, b, 255 },
            clr_2 = { 0, 127, 255, 255 },
        }, false)
    end
end

local screen_size = {
	visuals.helpers.screen_size.x - visuals.helpers.screen_size.x * cvars.safezonex:get_float(),
	visuals.helpers.screen_size.y * cvars.safezoney:get_float()
}
visuals.hotkey_list.dragging = helpers.dragging_fn('Keybinds', screen_size[1] / 1.385, screen_size[2] / 2.5)
local m_alpha, m_active = 0, { }
local m_hotkeys, m_hotkeys_update, m_hotkeys_create = { }, true
visuals.hotkey_list.draw = function()
    local master_switch = ms.keybinds:get()
    local is_menu_open = menu.is_open()
	local frames = 8 * global_vars.frame_time()

    local latest_item = false
    local maximum_offset = 66
    m_hotkeys = keybinds.keys
    if m_hotkeys_update == true then
        m_hotkeys = { }
        m_active = { }
        
        m_hotkeys_update = false
    end
    
    for c_name, c_data in pairs(m_hotkeys) do
        local item_active = true
        local c_ref = c_data

        local items = helpers.item_count(c_ref)
        local state = { c_ref[items]:get(), c_ref[items]:get_mode()+1 }

        if items > 1 then
            item_active = c_ref[2]:get()
        end
        if item_active and state[2] ~= 0 and (state[2] == 5 and not state[1] or state[2] ~= 5 and state[1]) then
            latest_item = true

            if m_active[c_name] == nil then
                m_active[c_name] = {
                    mode = '', alpha = 0, offset = 0, active = true
                }
            end

            local text_width = render.get_text_size(visuals.helpers.verdana, c_name).x
            m_active[c_name].active = true
            m_active[c_name].offset = text_width
            m_active[c_name].mode = keybinds.modes[state[2]]
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
        local text_width = render.get_text_size(visuals.helpers.verdana, case_name).x

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
	local x, y = visuals.hotkey_list.dragging:get()
	local r, g, b, a = helpers.get_bar_color()
	
	local height_offset = 23
	local w, h = 75 + maximum_offset, 50
    if ms.palette:get() == 1 then
        render.rect_filled(vec2_t(x, y), vec2_t(w, 2), color(r, g, b, m_alpha*255))
    else
        render.rect_fade(vec2_t(x, y), vec2_t((w/2)+1, 2), color(g, b, r, m_alpha*255), color(r, g, b, m_alpha*255), true)
        render.rect_fade(vec2_t(x + w/2, y), vec2_t(w-w/2, 2), color(r, g, b, m_alpha*255), color(b, r, g, m_alpha*255), true)
    end

    render.rect_filled(vec2_t(x, y + 2), vec2_t(w, 18), color(17, 17, 17, m_alpha*a))
    render.text(visuals.helpers.verdana, text, vec2_t(x - render.get_text_size(visuals.helpers.verdana, text).x / 2 + w/2, y + 4), color(255, 255, 255, m_alpha*255))

    for c_name, c_ref in pairs(m_active) do
        local key_type = '[' .. (c_ref.mode or '?') .. ']'
        
        render.text(visuals.helpers.verdana, c_name, vec2_t(x + 5, y + height_offset), color(255,255,255,m_alpha*c_ref.alpha*255))
        render.text(visuals.helpers.verdana, key_type, vec2_t(x + w - render.get_text_size(visuals.helpers.verdana, key_type).x - 5, y + height_offset), color(255,255,255,m_alpha*255))
        height_offset = height_offset + 15
    end
    visuals.hotkey_list.dragging:drag(w, (3 + (15 * helpers.item_count(m_active))) * 2)
    if master_switch and helpers.item_count(m_active) > 0 and latest_item then
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

visuals.spectator_list.screen_size = {
	visuals.helpers.screen_size.x - visuals.helpers.screen_size.x * cvars.safezonex:get_float(),
	visuals.helpers.screen_size.y * cvars.safezoney:get_float()
}
visuals.spectator_list.dragging = helpers.dragging_fn('Spectators', visuals.spectator_list.screen_size[1] / 1.385, visuals.spectator_list.screen_size[2] / 2)
visuals.spectator_list.m_alpha, visuals.spectator_list.m_active, visuals.spectator_list.m_contents, visuals.spectator_list.unsorted = 0, {}, {}, {}

local Png = {}
Png.__index = Png
local png_ihdr_t = ffi.typeof([[
struct {
	char type[4];
	uint32_t width;
	uint32_t height;
	char bitDepth;
	char colorType;
	char compression;
	char filter;
	char interlace;
} *
]])

local jpg_segment_t = ffi.typeof([[
struct {
	char type[2];
	uint16_t size;
} *
]])

local jpg_segment_sof0_t = ffi.typeof([[
struct {
	uint16_t size;
	char precision;
	uint16_t height;
	uint16_t width;
} __attribute__((packed)) *
]])

local uint16_t_ptr = ffi.typeof("uint16_t*")
local charbuffer = ffi.typeof("unsigned char[?]")
local uintbuffer = ffi.typeof("unsigned int[?]")

local DEFLATE_MAX_BLOCK_SIZE = 65535

local function putBigUint32(val, tbl, index)
    for i=0,3 do
        tbl[index + i] = bit.band(bit.rshift(val, (3 - i) * 8), 0xFF)
    end
end

function Png:writeBytes(data, index, len)
    index = index or 1
    len = len or #data
    for i=index,index+len-1 do
        table.insert(self.output, string.char(data[i]))
    end
end

function Png:write(pixels)
    local count = #pixels  -- Byte count
    local pixelPointer = 1
    while count > 0 do
        if self.positionY >= self.height then
            error("All image pixels already written")
        end

        if self.deflateFilled == 0 then -- Start DEFLATE block
            local size = DEFLATE_MAX_BLOCK_SIZE;
            if (self.uncompRemain < size) then
                size = self.uncompRemain
            end
            local header = {  -- 5 bytes long
                bit.band((self.uncompRemain <= DEFLATE_MAX_BLOCK_SIZE and 1 or 0), 0xFF),
                bit.band(bit.rshift(size, 0), 0xFF),
                bit.band(bit.rshift(size, 8), 0xFF),
                bit.band(bit.bxor(bit.rshift(size, 0), 0xFF), 0xFF),
                bit.band(bit.bxor(bit.rshift(size, 8), 0xFF), 0xFF),
            }
            self:writeBytes(header)
            self:crc32(header, 1, #header)
        end
        assert(self.positionX < self.lineSize and self.deflateFilled < DEFLATE_MAX_BLOCK_SIZE);

        if (self.positionX == 0) then  -- Beginning of line - write filter method byte
            local b = {0}
            self:writeBytes(b)
            self:crc32(b, 1, 1)
            self:adler32(b, 1, 1)
            self.positionX = self.positionX + 1
            self.uncompRemain = self.uncompRemain - 1
            self.deflateFilled = self.deflateFilled + 1
        else -- Write some pixel bytes for current line
            local n = DEFLATE_MAX_BLOCK_SIZE - self.deflateFilled;
            if (self.lineSize - self.positionX < n) then
                n = self.lineSize - self.positionX
            end
            if (count < n) then
                n = count;
            end
            assert(n > 0);

            self:writeBytes(pixels, pixelPointer, n)

            -- Update checksums
            self:crc32(pixels, pixelPointer, n);
            self:adler32(pixels, pixelPointer, n);

            -- Increment positions
            count = count - n;
            pixelPointer = pixelPointer + n;
            self.positionX = self.positionX + n;
            self.uncompRemain = self.uncompRemain - n;
            self.deflateFilled = self.deflateFilled + n;
        end

        if (self.deflateFilled >= DEFLATE_MAX_BLOCK_SIZE) then
            self.deflateFilled = 0; -- End current block
        end

        if (self.positionX == self.lineSize) then  -- Increment line
            self.positionX = 0;
            self.positionY = self.positionY + 1;
            if (self.positionY == self.height) then -- Reached end of pixels
                local footer = {  -- 20 bytes long
                    0, 0, 0, 0,  -- DEFLATE Adler-32 placeholder
                    0, 0, 0, 0,  -- IDAT CRC-32 placeholder
                    -- IEND chunk
                    0x00, 0x00, 0x00, 0x00,
                    0x49, 0x45, 0x4E, 0x44,
                    0xAE, 0x42, 0x60, 0x82,
                }
                putBigUint32(self.adler, footer, 1)
                self:crc32(footer, 1, 4)
                putBigUint32(self.crc, footer, 5)
                self:writeBytes(footer)
                self.done = true
            end
        end
    end
end

function Png:crc32(data, index, len)
    self.crc = bit.bnot(self.crc)
    for i=index,index+len-1 do
        local byte = data[i]
        for j=0,7 do  -- Inefficient bitwise implementation, instead of table-based
            local nbit = bit.band(bit.bxor(self.crc, bit.rshift(byte, j)), 1);
            self.crc = bit.bxor(bit.rshift(self.crc, 1), bit.band((-nbit), 0xEDB88320));
        end
    end
    self.crc = bit.bnot(self.crc)
end
function Png:adler32(data, index, len)
    local s1 = bit.band(self.adler, 0xFFFF)
    local s2 = bit.rshift(self.adler, 16)
    for i=index,index+len-1 do
        s1 = (s1 + data[i]) % 65521
        s2 = (s2 + s1) % 65521
    end
    self.adler = bit.bor(bit.lshift(s2, 16), s1)
end

local function begin(width, height, colorMode)
    -- Default to rgb
    colorMode = colorMode or "rgb"

    -- Determine bytes per pixel and the PNG internal color type
    local bytesPerPixel, colorType
    if colorMode == "rgb" then
        bytesPerPixel, colorType = 3, 2
    elseif colorMode == "rgba" then
        bytesPerPixel, colorType = 4, 6
    else
        error("Invalid colorMode")
    end

    local state = setmetatable({ width = width, height = height, done = false, output = {} }, Png)

    -- Compute and check data siezs
    state.lineSize = width * bytesPerPixel + 1
    -- TODO: check if lineSize too big

    state.uncompRemain = state.lineSize * height

    local numBlocks = math.ceil(state.uncompRemain / DEFLATE_MAX_BLOCK_SIZE)

    -- 5 bytes per DEFLATE uncompressed block header, 2 bytes for zlib header, 4 bytes for zlib Adler-32 footer
    local idatSize = numBlocks * 5 + 6
    idatSize = idatSize + state.uncompRemain;

    -- TODO check if idatSize too big

    local header = {  -- 43 bytes long
        -- PNG header
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
        -- IHDR chunk
        0x00, 0x00, 0x00, 0x0D,
        0x49, 0x48, 0x44, 0x52,
        0, 0, 0, 0,  -- 'width' placeholder
        0, 0, 0, 0,  -- 'height' placeholder
        0x08, colorType, 0x00, 0x00, 0x00,
        0, 0, 0, 0,  -- IHDR CRC-32 placeholder
        -- IDAT chunk
        0, 0, 0, 0,  -- 'idatSize' placeholder
        0x49, 0x44, 0x41, 0x54,
        -- DEFLATE data
        0x08, 0x1D,
    }
    putBigUint32(width, header, 17)
    putBigUint32(height, header, 21)
    putBigUint32(idatSize, header, 34)

    state.crc = 0
    state:crc32(header, 13, 17)
    putBigUint32(state.crc, header, 30)
    state:writeBytes(header)

    state.crc = 0
    state:crc32(header, 38, 6);  -- 0xD7245B6B
    state.adler = 1

    state.positionX = 0
    state.positionY = 0
    state.deflateFilled = 0

    return state
end

ffi.cdef([[
	typedef struct
	{
		void* steam_client;
		void* steam_user;
		void* steam_friends;
		void* steam_utils;
		void* steam_matchmaking;
		void* steam_user_stats;
		void* steam_apps;
		void* steam_matchmakingservers;
		void* steam_networking;
		void* steam_remotestorage;
		void* steam_screenshots;
		void* steam_http;
		void* steam_unidentifiedmessages;
		void* steam_controller;
		void* steam_ugc;
		void* steam_applist;
		void* steam_music;
		void* steam_musicremote;
		void* steam_htmlsurface;
		void* steam_inventory;
		void* steam_video;
	} S_steamApiCtx_t;
]])

local pS_SteamApiCtx = ffi.cast(
	"S_steamApiCtx_t**", ffi.cast(
		"char*",
		memory.find_pattern(
			"client.dll",
			"FF 15 ?? ?? ?? ?? B9 ?? ?? ?? ?? E8 ?? ?? ?? ?? 6A"
		)
	) + 7
)[0] or error("invalid interface", 2)

local native_ISteamFriends = ffi.cast("void***", pS_SteamApiCtx.steam_friends)
local native_ISteamUtils = ffi.cast("void***", pS_SteamApiCtx.steam_utils)
local native_ISteamFriends_GetSmallFriendAvatar = ffi.cast("int(__thiscall*)(void*, uint64_t)" ,native_ISteamFriends[0][34] )
local native_ISteamUtils_GetImageSize = ffi.cast("bool(__thiscall*)(void*, int, uint32_t*, uint32_t*)" , native_ISteamUtils[0][5])
local native_ISteamUtils_GetImageRGBA =  ffi.cast("bool(__thiscall*)(void*, int, unsigned char*, int)" , native_ISteamUtils[0][6])

local get_avatar = function(steamid)
    local counter = 4
    local rgba_image = {}
    local penis = nil
    local handle = native_ISteamFriends_GetSmallFriendAvatar( native_ISteamFriends , tonumber(steamid:sub(4, -1)) + 76500000000000000ULL)

    local image_bytes = ""

    if handle > 0 then
        local width = uintbuffer(1)
        local height = uintbuffer(1)
        if native_ISteamUtils_GetImageSize(native_ISteamUtils, handle, width, height) then
            if width[0] > 0 and height[0] > 0 then
                local rgba_buffer_size = width[0]*height[0]*4
                local rgba_buffer = charbuffer(rgba_buffer_size)
                if native_ISteamUtils_GetImageRGBA(native_ISteamUtils, handle, rgba_buffer, rgba_buffer_size) then
                    local png = begin(width[0], height[0], "rgba")
                    for x =0 , width[0]-1 do
                        for y =0, height[0]-1 do
                            local sub_penis = x*(height[0]*4) + y*4
                            png:write { rgba_buffer[sub_penis], rgba_buffer[sub_penis+1], rgba_buffer[sub_penis+2], rgba_buffer[sub_penis+3]}
                        end
                    end
                    penis = png.output
                end
            end
        end
    elseif handle ~= -1 then
        penis = nil
    end
    function transform(input)
        local output = string.format("%x", input ) -- "7F"
        return ("\\x" .. string.upper(output))
    end
    if not penis then return end
    for i=1 ,#penis do  
        image_bytes = image_bytes..penis[i]
    end

    local image_loaded = render.load_image_buffer(image_bytes)

    return image_loaded
end

local avatars = {}
avatars.data = {}
avatars.default_image = render.load_image_buffer("\xFF\xD8\xFF\xE0\x00\x10\x4A\x46\x49\x46\x00\x01\x01\x00\x00\x01\x00\x01\x00\x00\xFF\xFE\x00\x3B\x43\x52\x45\x41\x54\x4F\x52\x3A\x20\x67\x64\x2D\x6A\x70\x65\x67\x20\x76\x31\x2E\x30\x20\x28\x75\x73\x69\x6E\x67\x20\x49\x4A\x47\x20\x4A\x50\x45\x47\x20\x76\x36\x32\x29\x2C\x20\x71\x75\x61\x6C\x69\x74\x79\x20\x3D\x20\x38\x30\x0A\xFF\xDB\x00\x43\x00\x06\x04\x05\x06\x05\x04\x06\x06\x05\x06\x07\x07\x06\x08\x0A\x10\x0A\x0A\x09\x09\x0A\x14\x0E\x0F\x0C\x10\x17\x14\x18\x18\x17\x14\x16\x16\x1A\x1D\x25\x1F\x1A\x1B\x23\x1C\x16\x16\x20\x2C\x20\x23\x26\x27\x29\x2A\x29\x19\x1F\x2D\x30\x2D\x28\x30\x25\x28\x29\x28\xFF\xDB\x00\x43\x01\x07\x07\x07\x0A\x08\x0A\x13\x0A\x0A\x13\x28\x1A\x16\x1A\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\x28\xFF\xC0\x00\x11\x08\x00\x40\x00\x40\x03\x01\x22\x00\x02\x11\x01\x03\x11\x01\xFF\xC4\x00\x1F\x00\x00\x01\x05\x01\x01\x01\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\xFF\xC4\x00\xB5\x10\x00\x02\x01\x03\x03\x02\x04\x03\x05\x05\x04\x04\x00\x00\x01\x7D\x01\x02\x03\x00\x04\x11\x05\x12\x21\x31\x41\x06\x13\x51\x61\x07\x22\x71\x14\x32\x81\x91\xA1\x08\x23\x42\xB1\xC1\x15\x52\xD1\xF0\x24\x33\x62\x72\x82\x09\x0A\x16\x17\x18\x19\x1A\x25\x26\x27\x28\x29\x2A\x34\x35\x36\x37\x38\x39\x3A\x43\x44\x45\x46\x47\x48\x49\x4A\x53\x54\x55\x56\x57\x58\x59\x5A\x63\x64\x65\x66\x67\x68\x69\x6A\x73\x74\x75\x76\x77\x78\x79\x7A\x83\x84\x85\x86\x87\x88\x89\x8A\x92\x93\x94\x95\x96\x97\x98\x99\x9A\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9\xBA\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFF\xC4\x00\x1F\x01\x00\x03\x01\x01\x01\x01\x01\x01\x01\x01\x01\x00\x00\x00\x00\x00\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\xFF\xC4\x00\xB5\x11\x00\x02\x01\x02\x04\x04\x03\x04\x07\x05\x04\x04\x00\x01\x02\x77\x00\x01\x02\x03\x11\x04\x05\x21\x31\x06\x12\x41\x51\x07\x61\x71\x13\x22\x32\x81\x08\x14\x42\x91\xA1\xB1\xC1\x09\x23\x33\x52\xF0\x15\x62\x72\xD1\x0A\x16\x24\x34\xE1\x25\xF1\x17\x18\x19\x1A\x26\x27\x28\x29\x2A\x35\x36\x37\x38\x39\x3A\x43\x44\x45\x46\x47\x48\x49\x4A\x53\x54\x55\x56\x57\x58\x59\x5A\x63\x64\x65\x66\x67\x68\x69\x6A\x73\x74\x75\x76\x77\x78\x79\x7A\x82\x83\x84\x85\x86\x87\x88\x89\x8A\x92\x93\x94\x95\x96\x97\x98\x99\x9A\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9\xBA\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFF\xDA\x00\x0C\x03\x01\x00\x02\x11\x03\x11\x00\x3F\x00\xF0\x89\xE6\x93\xCF\x93\xF7\x8F\xF7\x8F\xF1\x1F\x5A\x67\x9D\x27\xFC\xF4\x7F\xFB\xE8\xD1\x3F\xFA\xF9\x3F\xDE\x3F\xCE\x99\x40\x0F\xF3\xA4\xFF\x00\x9E\x8F\xFF\x00\x7D\x1A\x3C\xE9\x3F\xE7\xA3\xFF\x00\xDF\x46\x99\x5A\x3A\x2E\x87\xAA\xEB\x93\x34\x5A\x3E\x9D\x75\x7A\xEB\xF7\x84\x11\x17\xDB\xF5\x23\xA7\xE3\x40\x14\x7C\xE9\x3F\xE7\xA3\xFF\x00\xDF\x46\x8F\x3A\x4F\xF9\xE8\xFF\x00\xF7\xD1\xAD\x1D\x6F\xC3\xBA\xCE\x86\x57\xFB\x63\x4B\xBC\xB2\x0F\xC2\xB4\xD1\x15\x56\xFA\x1E\x86\xB2\xE8\x01\xFE\x74\x9F\xF3\xD1\xFF\x00\xEF\xA3\x4F\x82\x69\x3C\xF8\xFF\x00\x78\xFF\x00\x78\x7F\x11\xF5\xA8\x69\xF0\x7F\xAF\x8F\xFD\xE1\xFC\xE8\x00\x9F\xFD\x7C\x9F\xEF\x1F\xE7\x4C\xA7\xCF\xFE\xBE\x4F\xF7\x8F\xF3\xA6\x50\x05\xDD\x13\x4F\x7D\x5B\x59\xB0\xD3\xA2\x60\xB2\x5D\xCF\x1C\x0A\x4F\x62\xCC\x14\x1F\xD6\xBE\xA8\xF1\x77\x88\x74\x8F\x84\x5E\x12\xD3\xED\x34\xDD\x3C\x4A\xD2\x13\x1C\x10\x06\xD9\xBC\x80\x37\x48\xED\x8E\xBC\x8C\xFA\x93\x5F\x27\x5B\xCF\x2D\xB5\xC4\x73\xDB\xC8\xF1\x4D\x13\x07\x49\x11\x8A\xB2\xB0\x39\x04\x11\xD0\x83\x56\xF5\x4D\x67\x53\xD5\xFC\xBF\xED\x5D\x46\xF2\xF7\xCB\xCE\xCF\xB4\x4C\xD2\x6D\xCF\x5C\x64\x9C\x74\x14\x01\xF5\x17\xC3\xEF\x1C\xE9\x9F\x14\x74\xDD\x47\x4B\xD5\x74\xC4\x8A\x54\x4C\xCD\x6C\xED\xE6\x24\x88\x4E\x37\x29\xC0\x20\x83\xF9\x71\x83\x5F\x34\xF8\xDB\x44\x1E\x1C\xF1\x66\xA9\xA4\xAB\x17\x4B\x59\xCA\x23\x1E\xA5\x0F\x2B\x9F\x7C\x11\x5F\x42\x7C\x16\xF0\xA4\x5E\x06\xF0\x9D\xDF\x88\xBC\x40\xE2\xDA\xE6\xE6\x11\x2C\x9E\x67\x1E\x44\x23\x90\x0F\xFB\x47\xA9\x1F\x41\xD6\xBE\x7A\xF1\xAE\xB7\xFF\x00\x09\x1F\x8A\xF5\x4D\x58\x21\x44\xBA\x98\xBA\x29\xEA\x13\xA2\x83\xEF\x80\x28\x03\x16\x9F\x07\xFA\xF8\xFF\x00\xDE\x1F\xCE\x99\x4F\x83\xFD\x7C\x7F\xEF\x0F\xE7\x40\x04\xFF\x00\xEB\xE4\xFF\x00\x78\xFF\x00\x3A\x65\x3E\x7F\xF5\xF2\x7F\xBC\x7F\x9D\x32\x80\x0A\xED\xFE\x0B\x69\x96\xDA\xBF\xC4\xAD\x1E\xDA\xF6\x31\x24\x0A\xCF\x31\x46\x19\x0C\x51\x19\x86\x7D\xB2\x05\x71\x15\xD3\xFC\x36\xD3\x75\x4D\x5F\xC6\x16\x76\x5A\x0E\xA0\x74\xED\x42\x45\x90\xC7\x72\x19\x97\x68\x08\x49\xE5\x79\xE4\x02\x3F\x1A\x00\xF5\x1F\xDA\x6F\xC4\xF7\x62\xFE\xCF\xC3\x70\x31\x8E\xCF\xCA\x5B\xA9\xF1\xD6\x46\x2C\xC1\x41\xF6\x1B\x73\xF5\x3E\xD5\xE0\xF5\xD8\xFC\x56\xD1\xF5\xAD\x13\xC4\xE9\x6B\xE2\x3D\x50\xEA\x97\xA6\xDD\x1C\x4E\x5D\x9B\x08\x4B\x61\x72\xDC\xF5\x07\xF3\xAE\x3A\x80\x0A\x7C\x1F\xEB\xE3\xFF\x00\x78\x7F\x3A\x65\x3E\x0F\xF5\xF1\xFF\x00\xBC\x3F\x9D\x00\x13\xFF\x00\xAF\x93\xFD\xE3\xFC\xE9\x95\x34\xF0\xC9\xE7\xC9\xFB\xB7\xFB\xC7\xF8\x4F\xAD\x33\xC9\x93\xFE\x79\xBF\xFD\xF2\x68\x01\x95\x7B\x43\xD5\xEF\xF4\x2D\x4A\x2D\x43\x49\xB8\x6B\x6B\xC8\xC1\x09\x22\x80\x48\xC8\x20\xF5\x04\x74\x26\xAA\x79\x32\x7F\xCF\x37\xFF\x00\xBE\x4D\x1E\x4C\x9F\xF3\xCD\xFF\x00\xEF\x93\x40\x1A\x1E\x21\xD7\xB5\x3F\x11\x5F\x8B\xDD\x6A\xED\xAE\xEE\x82\x08\xC4\x8C\xA0\x1D\xA0\x92\x07\x00\x7A\x9A\xCC\xA7\xF9\x32\x7F\xCF\x37\xFF\x00\xBE\x4D\x1E\x4C\x9F\xF3\xCD\xFF\x00\xEF\x93\x40\x0C\xA7\xC1\xFE\xBE\x3F\xF7\x87\xF3\xA3\xC9\x93\xFE\x79\xBF\xFD\xF2\x69\xF0\x43\x27\x9F\x1F\xEE\xDF\xEF\x0F\xE1\x3E\xB4\x01\xFF\xD9")
avatars.fn_create_item = function(name) 
    avatars.data[name] = {}
    avatars.data[name].url = nil
    avatars.data[name].image = nil
    avatars.data[name].loaded = false
    avatars.data[name].loading = false
end
avatars.fn_get_avatar = function(name, entindex)
    if avatars.data[name] and avatars.data[name].loaded then
        return avatars.data[name].image
    end

    if avatars.data[name] == nil then
        avatars.fn_create_item(name)
        local steamID3, steam_id = entity_list.get_entity(entindex):get_steamids()

        if #steam_id<5 then return end
        if steam_id == nil or avatars.default_image == nil then
            return nil
        end
        avatars.data[name].image = get_avatar(steam_id)
        avatars.data[name].loaded = true
    end
    return avatars.default_image
end
local specs = {}
local spectating_players = function(player)
    local buffer = { }
    local frames = 8 * global_vars.frame_time()

    local players = entity_list.get_entities_by_name('CCSPlayer')
    for tbl_idx, player_pointer in pairs(players) do
        if player_pointer:get_index() ~= player:get_index() then
            if not player_pointer:is_alive() and not player_pointer:is_dormant() then
                local spectatingMode = player_pointer:get_prop('m_iObserverMode')
                local spectatingPlayer = player_pointer:get_prop('m_hObserverTarget')

                if spectatingPlayer then
                    if spectatingMode >= 4 or spectatingMode <= 5 then
                        if spectatingPlayer < 0 then
                            chlen = -1
                        else
                            chlen = 1
                        end
                        
                        local spectatingEntity = entity_list.get_entity(spectatingPlayer*chlen)
                        if spectatingEntity ~= nil and spectatingEntity:get_index() == player:get_index() then
                            if specs[player_pointer:get_index()] == nil then
                                specs[player_pointer:get_index()] = {
                                    alpha = 0, offset = 0, active = true
                                }
                            end
                            specs[player_pointer:get_index()].active = true
                            specs[player_pointer:get_index()].alpha = specs[player_pointer:get_index()].alpha + frames
                    
                            if specs[player_pointer:get_index()].alpha > 1 then
                                specs[player_pointer:get_index()].alpha = 1
                            end


                            table.insert(buffer, 1, {
                                ['alpha'] = specs[player_pointer:get_index()].alpha,
                                ['id'] = player_pointer:get_index(),
                                ['name'] = player_pointer:get_name()
                            })
                        elseif specs[player_pointer:get_index()] ~= nil then
                            specs[player_pointer:get_index()].active = false
					        specs[player_pointer:get_index()].alpha = specs[player_pointer:get_index()].alpha - frames

					        if specs[player_pointer:get_index()].alpha <= 0 then
					        	specs[player_pointer:get_index()] = nil
					        end
                        end
                    end
                else
                    specs[player_pointer:get_index()] = nil
                end
            else
                specs[player_pointer:get_index()] = nil
            end
        end
    end

    return buffer
end

local get_spectating_players = function()
    if not engine.is_connected() or entity_list.get_local_player() == nil then return end
    local local_player = entity_list.get_local_player()
    if local_player:is_alive() then
        return spectating_players(local_player)
    else
        local m_hObserverTarget = local_player:get_prop('m_hObserverTarget')
        if m_hObserverTarget then
            local targetEntity = entity_list.get_entity(m_hObserverTarget)
            if targetEntity ~= nil then
                if targetEntity:is_player() then
                    return spectating_players(targetEntity)
                end
            end
        end
    end
end

visuals.spectator_list.draw = function()
    local master_switch = ms.spectators:get()
    local is_menu_open = menu.is_open()
    local frames = 8 * global_vars.frame_time()

    local latest_item = false
    maximum_offset = 85

    local me = entity_list.get_local_player()
    local get_spectators = get_spectating_players()
    if get_spectators == nil then return end

    local text = 'spectators'
    local x, y = visuals.spectator_list.dragging:get()
    local r, g, b, a = helpers.get_bar_color()

    local height_offset = 23
    w, h = 55 + maximum_offset, 50

    w = w - (0 or 17)

    right_offset = (x+w/2) > (visuals.helpers.screen_size.x / 2)
    
    local active_spec = {}
    
    for i = 1, #get_spectators do
        local v = get_spectators[i]
        
        local val = avatars.fn_get_avatar(v.name, v.id)
        local text_h = render.get_text_size(visuals.helpers.verdana, v.name)
        if text_h.x > maximum_offset then
            maximum_offset = text_h.x
        end
        w, h = 55 + maximum_offset, 50
        if #get_spectators then
            table.insert(active_spec, #get_spectators)
        end

        render.text(visuals.helpers.verdana, v.name, vec2_t(x + ((avatars.default_image.id and not right_offset) and text_h.y or -6) + 11, y + height_offset), color(255, 255, 255, visuals.spectator_list.m_alpha*v.alpha*255))
        if val ~= nil then
            render.texture(val.id, vec2_t(x + (right_offset and w - 19 or 6), y + height_offset), vec2_t(text_h.y, text_h.y), color(255, 255, 255, visuals.spectator_list.m_alpha*v.alpha*255))
        end
        
        height_offset = height_offset + 15
    end

    if ms.palette:get() == 1 then
        render.rect_filled(vec2_t(x, y), vec2_t(w, 2), color(r, g, b, visuals.spectator_list.m_alpha*255))
    else
        render.rect_fade(vec2_t(x, y), vec2_t((w/2)+1, 2), color(g, b, r, visuals.spectator_list.m_alpha*255), color(r, g, b, visuals.spectator_list.m_alpha*255), true)
        render.rect_fade(vec2_t(x + w/2, y), vec2_t(w-w/2, 2), color(r, g, b, visuals.spectator_list.m_alpha*255), color(b, r, g, visuals.spectator_list.m_alpha*255), true)
    end

    render.rect_filled(vec2_t(x, y + 2), vec2_t(w, 18), color(17, 17, 17, visuals.spectator_list.m_alpha*a))
    render.text(visuals.helpers.verdana, text, vec2_t(x - render.get_text_size(visuals.helpers.verdana, text).x / 2 + w/2, y + 4), color(255, 255, 255, visuals.spectator_list.m_alpha*255))
    visuals.spectator_list.dragging:drag(w, (3 + ((get_spectators ~= nil and helpers.item_count(get_spectators) > 0) and (15 * helpers.item_count(get_spectators)) or 7)) * 2)
    if master_switch and ((get_spectators ~= nil and helpers.item_count(get_spectators) > 0) or is_menu_open) then
        visuals.spectator_list.m_alpha = visuals.spectator_list.m_alpha + frames; if visuals.spectator_list.m_alpha > 1 then visuals.spectator_list.m_alpha = 1 end
    else
        visuals.spectator_list.m_alpha = visuals.spectator_list.m_alpha - frames; if visuals.spectator_list.m_alpha < 0 then visuals.spectator_list.m_alpha = 0 end 
    end

    if is_menu_open and get_spectators ~= nil then
        get_spectators[' '] = nil
    end
end

callbacks.add(e_callbacks.PAINT, visuals.watermark.draw)
callbacks.add(e_callbacks.SETUP_COMMAND, visuals.antiaim.g_setup_command)
callbacks.add(e_callbacks.PAINT, visuals.antiaim.draw)
callbacks.add(e_callbacks.PAINT, visuals.ilstate.draw)
callbacks.add(e_callbacks.PAINT, visuals.hotkey_list.draw)
callbacks.add(e_callbacks.PAINT, visuals.spectator_list.draw)