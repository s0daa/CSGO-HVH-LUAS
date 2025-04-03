--[[
    ~ Revision Solus UI
    ~ by -xgor#4727
--]]

local el = {}
local kb = {}
local sp = {}
local call = {}
local anim = {}
local callbacks_add, client_get_fps, client_get_local_time, color_t, engine_get_choked_commands, engine_get_latency, engine_is_connected, entity_list_get_entity, entity_list_get_local_player, get_charge, global_vars_max_clients, input_get_mouse_pos, input_is_key_held, input_is_mouse_in_bounds, kb_handle, math_max, math_min, menu_add_checkbox, menu_add_multi_selection, menu_add_selection, menu_add_slider, menu_add_text_input, menu_find, menu_is_open, render_get_screen_size, pairs, render_create_font, render_get_text_size, render_pop_alpha_modifier, render_push_alpha_modifier, render_rect, render_rect_fade, render_rect_fade_round_box, render_rect_filled, render_ui, setmetatable, table_count, table_insert, vec2_t, type, tostring = callbacks.add, client.get_fps, client.get_local_time, color_t, engine.get_choked_commands, engine.get_latency, engine.is_connected, entity_list.get_entity, entity_list.get_local_player, exploits.get_charge, global_vars.max_clients, input.get_mouse_pos, input.is_key_held, input.is_mouse_in_bounds, kb.handle, math.max, math.min, menu.add_checkbox, menu.add_multi_selection, menu.add_selection, menu.add_slider, menu.add_text_input, menu.find, menu.is_open, render.get_screen_size, pairs, render.create_font, render.get_text_size, render.pop_alpha_modifier, render.push_alpha_modifier, render.rect, render.rect_fade, render.rect_fade_round_box, render.rect_filled, render.ui, setmetatable, table.count, table.insert, vec2_t, type, tostring

--@ menu elements
el.enabler     = menu_add_checkbox("Global", "Enabled", true)
el.selectable  = menu_add_multi_selection("Global", "Elements", {"Watermark", "Exploit State", "Hotkey List", "Spectator List (Cornered)"})
el.dat         = menu_add_checkbox("Global", "Data Editor", false)
el.sep         = menu_add_checkbox("Global", "Seperator", false)
el.prefix      = menu_add_text_input("Global", "Prefix")
el.prefix2     = menu_add_text_input("Global", "Postfix")
el.custom_name = menu_add_text_input("Global", "Name")
el.style       = menu_add_selection("Settings", "Visual Style", {"Solid", "Faded"})
el.c_solid     = el.style:add_color_picker("Solid Color") el.c_solid:set(color_t(142, 165, 229, 255))
el.c_gr2       = el.style:add_color_picker("Faded Color 2") el.c_gr2:set(color_t(255, 186, 222, 255))
el.c_gr1       = el.style:add_color_picker("Faded Color 1") el.c_gr1:set(color_t(163, 175, 255, 255))
el.bg_alpha    = menu_add_slider("Settings", "Background Alpha", 1, 255) el.bg_alpha:set(100)
el.atype       = menu_add_selection("Settings", "Anim. Type", {"Static", "Elastic"})
el.width       = menu_add_slider("Settings", "Min. Width", 128, 151)
el.padding     = menu_add_slider("Settings", "Padding", 2, 5)

--@ hidden elements
kb.x = menu_add_slider("Settings", "kb_x", 0, render_get_screen_size().x) kb.x:set(400)
kb.y = menu_add_slider("Settings", "kb_y", 0, render_get_screen_size().y) kb.y:set(400)
kb.x:set_visible(false)
kb.y:set_visible(false)
--@ end region

--@ menu callback
function el.manager()
	if not menu_is_open() then return end
	local ms = el.enabler:get()
	local any = el.selectable:get("Watermark") or el.selectable:get("Hotkey List") or el.selectable:get("Exploit State")
	local data = ms and el.dat:get() and el.selectable:get("Watermark")
	local anims = el.selectable:get("Hotkey List") or el.selectable:get("Spectator List (Cornered)")
	el.dat:set_visible(ms and el.selectable:get("Watermark"))
	el.sep:set_visible(data)
	el.prefix:set_visible(data)
	el.prefix2:set_visible(data)
	el.custom_name:set_visible(data)
	el.selectable:set_visible(ms)
	el.style:set_visible(ms and any)
	el.c_gr1:set_visible(ms and el.style:get() == 2 and any)
	el.c_gr2:set_visible(ms and el.style:get() == 2 and any)
	el.c_solid:set_visible(ms and el.style:get() == 1 and any)
	el.bg_alpha:set_visible(ms and any)
	el.atype:set_visible(ms and anims)
	el.width:set_visible(ms and el.selectable:get("Hotkey List"))
	el.padding:set_visible(ms and el.selectable:get("Hotkey List") and el.style:get() == 2)
end
--@ end region

--@ localization region
local calc_size = render_get_text_size
local flr = math.floor
local dat = el.dat

local anims = {
	w_alpha = 0,
	ex_alpha = 0,
	tsize = 0,
	extend_c = 0,
	extend_x = 0,
	disabler = 0,
	old_fl = 0,
	fl_s = 0,
}

local get_binds = {
    doubletap = menu_find("aimbot", "general", "exploits", "doubletap", "enable"),
    edge_jump = menu_find("misc", "main", "movement", "edge jump"),
    os_aa = menu_find("aimbot", "general", "exploits", "hideshots", "enable"),
    min_damage = menu_find("aimbot", "scout", "target overrides", "min. damage"),
	ping_spike = menu_find("aimbot", "general", "fake ping", "enable"),
    peek_assist = menu_find("aimbot", "general", "misc", "autopeek"),
    fake_duck = menu_find("antiaim", "main", "general", "fakeduck"),
    inverter = menu_find("antiaim", "main", "manual", "invert desync"),
    slow_walk = menu_find("misc", "main", "movement", "slow walk"),
    freestand = menu_find("antiaim", "main", "auto direction", "enable"),
    roll = menu_find("antiaim", "main", "extended angles", "enable"),
}

function anim.lerp(a,b,p) 
	return a + (b - a) *p 
end

function anim.create(name, value, time)
    if (anim[name] == nil) then anim[name] = value end
    anim[name] = anim.lerp(anim[name], value, time)
    return anim[name]
end

function is_scout()
	local lp = entity_list_get_local_player()
    if not lp:is_alive() or not lp:get_active_weapon() then return end
    local weap = lp:get_active_weapon():get_name()
    return weap == "ssg08"
end

function get_speed()
    local sp = 58
    global_speed = el.atype:get() == 0 and 0.35 or (sp/(200-sp*1.2))
    return global_speed * 1 / (client_get_fps() / 20)
end

function render_text(font, text, vector, color)
    render.text(font, text, vec2_t(vector.x+1,vector.y+1), color_t.new(0,0,0,flr(color.a*0.75)))
    render.text(font, text, vector, color_t.new(color.r,color.g,color.b,flr(color.a*0.95)))
end

function table_count(tbl)
    if tbl == nil then return 0 end
    if #tbl == 0 then 
        local count = 0
        for data in pairs(tbl) do count = count + 1 end
        return count 
    end
    return #tbl
end

--@ end region

--@ drag system
local drag = {}
function drag.new(x, y)
	return setmetatable({
		x = kb.x,
		y = kb.y,
		d_x = 0,
		d_y = 0,
		dragging = false,
	}, { __index = drag })
end

function drag:get() return self.x:get(), self.y:get() end
function drag:handle(width, height)
	self.width = width
	self.height = height
	local screen = render_get_screen_size()
	local mouse_position = input_get_mouse_pos()
	if (input_is_mouse_in_bounds(vec2_t(self.x:get(), self.y:get()), vec2_t(self.width, self.height))) then
		if (input_is_key_held(e_keys.MOUSE_LEFT) and not self.dragging) then
            self.dragging = true
            self.d_x = self.x:get() - mouse_position.x
            self.d_y = self.y:get() - mouse_position.y
		end
	end
    if (not input_is_key_held(e_keys.MOUSE_LEFT)) then self.dragging = false end
    if (self.dragging and menu_is_open()) then
        local new_x = math_max(0, math_min(screen.x - self.width, mouse_position.x + self.d_x))
        local new_y = math_max(0, math_min(screen.y - self.height, mouse_position.y + self.d_y))
        new_x = mouse_position.x + self.d_x
        new_y = mouse_position.y + self.d_y
        self.x:set(new_x)
        self.y:set(new_y)
    end
end
--@ end region

--@ render region 
local fonts = {}

fonts.verdana = render_create_font("Verdana", 12, 0, nil)

function render_rect_fade_round_box(start_pos, end_pos, start_color, end_color)
    local sp, ep, sc, ec, width, round = start_pos, end_pos, start_color, end_color, 1, 3
    --[[ up/left/right/down ]]
    render_rect_fade(vec2_t.new(sp.x + round-1, sp.y), vec2_t.new(ep.x - round * 2 + 2, ep.y - ep.y + width), sc, ec, true)
    render_rect_fade(vec2_t.new(sp.x, sp.y + round-1), vec2_t.new(sp.x - sp.x + width, ep.y - round * 2+2), color_t.new(sc.r, sc.g, sc.b, sc.a), color_t.new(ec.r, ec.g, ec.b, flr(ec.a / 5)), false)
    render_rect_fade(vec2_t.new(sp.x + ep.x - width, sp.y + round-1), vec2_t.new(ep.x - ep.x + width, ep.y - round * 2+2), color_t.new(ec.r, ec.g, ec.b, ec.a), color_t.new(ec.r, ec.g, ec.b, flr(ec.a / 5)), false)
    render_rect_fade(vec2_t.new(sp.x + round-1, sp.y + ep.y - width), vec2_t.new(ep.x - round * 2+2, sp.y - sp.y + width), color_t.new(sc.r, sc.g, sc.b, flr(sc.a / 5)), color_t.new(ec.r, ec.g, ec.b, flr(ec.a / 5)), true)
    -- [[ rounding top left ]]
    render_rect(vec2_t(sp.x+1, sp.y+1), vec2_t(1, 1), color_t.new(sc.r, sc.g, sc.b, flr(sc.a*0.5)))
    render_rect(vec2_t(sp.x+1, sp.y+2), vec2_t(1, 1), color_t.new(sc.r, sc.g, sc.b, flr(sc.a*0.25)))
    render_rect(vec2_t(sp.x+2, sp.y+1), vec2_t(1, 1), color_t.new(sc.r, sc.g, sc.b, flr(sc.a*0.25)))
    render_rect(vec2_t(sp.x+1, sp.y), vec2_t(1, 1), color_t.new(sc.r, sc.g, sc.b, flr(sc.a*0.15)))
    render_rect(vec2_t(sp.x, sp.y+1), vec2_t(1, 1), color_t.new(sc.r, sc.g, sc.b, flr(sc.a*0.15)))
    -- [[ rounding top right ]]   
    render_rect(vec2_t(sp.x+ep.x-2, sp.y+1), vec2_t(1, 1), color_t.new(ec.r, ec.g, ec.b, flr(ec.a*0.5)))
    render_rect(vec2_t(sp.x+ep.x-3, sp.y+1), vec2_t(1, 1), color_t.new(ec.r, ec.g, ec.b, flr(ec.a*0.25)))
    render_rect(vec2_t(sp.x+ep.x-2, sp.y+2), vec2_t(1, 1), color_t.new(ec.r, ec.g, ec.b, flr(ec.a*0.25)))
    render_rect(vec2_t(sp.x+ep.x-1, sp.y+1), vec2_t(1, 1), color_t.new(ec.r, ec.g, ec.b, flr(ec.a*0.15)))
    render_rect(vec2_t(sp.x+ep.x-2, sp.y), vec2_t(1, 1), color_t.new(ec.r, ec.g, ec.b, flr(ec.a*0.15)))
    -- [[ rounding bottom ]]   
    render_rect(vec2_t(sp.x+1, sp.y+ep.y-2), vec2_t(1, 1), color_t.new(sc.r, sc.g, sc.b, flr(sc.a / 50)))
    render_rect(vec2_t(sp.x+ep.x-2, sp.y+ep.y-2), vec2_t(1, 1), color_t.new(ec.r, ec.g, ec.b, flr(ec.a / 50)))
end

function render_ui(vec_start, vec_end, color_s, color_e, style, blend_mode, amod)
	if (blend_mode == nil) then blend_mode = false end
	local x, y = vec_start.x, vec_start.y+3
	local w, h = vec_end.x-1, vec_end.y-3

	if (style == 1) then
		render_rect_filled(vec2_t(x, y), vec2_t(w, h+1), color_t(0, 0, 0, math.min(el.bg_alpha:get(), amod)))
		if not blend_mode then 
			render_rect_filled(vec2_t(x, y-2), vec2_t(w, 2), color_t(el.c_solid:get().r, el.c_solid:get().g, el.c_solid:get().b, amod))
		end
	else
	    render_rect_filled(vec2_t(x, y), vec2_t(w, h), color_t(0, 0, 0, math.min(el.bg_alpha:get(), amod)), 4)
		render_rect_fade_round_box(vec2_t(x, y), vec2_t(w, h+1), color_t(color_s.r, color_s.g, color_s.b, amod), color_t(color_e.r, color_e.g, color_e.b, amod))
	end
end

--@ end region

--@ keybinds region
kb.act = {}
kb.list = {
    ["Minimum damage"] = get_binds.min_damage,
    ["Double tap"] = get_binds.doubletap,
    ["Jump at edge"] = get_binds.edge_jump,
    ["Force body aim"] = get_binds.baim,
    ["On shot anti-aim"] = get_binds.os_aa,
    ["Anti-aim inverter"] = get_binds.inverter,
    ["Duck peek assist"] = get_binds.fake_duck,
    ["Quick peek assist"] = get_binds.peek_assist,
    ["Slow motion"] = get_binds.slow_walk,
    ["Freestanding"] = get_binds.freestand,
    ["Ping spike"] = get_binds.ping_spike,
    ["Rolling"] = get_binds.roll,
}

kb.modes = { 
    [0] = "toggled",
    [1] = "holding",
    [2] = "holding",
    [3] = "always"
}

kb.dragging = drag.new(0, 0)
function kb_handle()
	local accent_color = el.style:get() == "Solid" and el.c_solid:get() or el.c_gr1:get()
	local accent_color2 = el.c_gr2:get()
	local r, g, b = accent_color.r, accent_color.g, accent_color.b
	local r2, g2, b2 = accent_color2.r, accent_color2.g, accent_color2.b
	local latest_item = false
    local maximum_offset = el.width:get()+10

    for k, bind_value in pairs(kb.list) do
    	local item_active = bind_value[2]:get()
    	if (item_active) then
    		latest_item = true
    		if (kb.act[k] == nil) then
    			kb.act[k] = {mode = "", alpha = 0, offset = 0, active = false}
    		end
    		kb.act[k].mode = kb.modes[ bind_value[2]:get_mode() ]
    		kb.act[k].offset = render_get_text_size(fonts.verdana, k).x+80
            kb.act[k].active = true
            kb.act[k].alpha = anim.lerp(kb.act[k].alpha, 1, get_speed()*2)
            --kb.act[k].alpha = kb.act[k].alpha < 1 and kb.act[k].alpha + get_speed() or 1
        elseif (kb.act[k] ~= nil) then
            kb.act[k].active = false
        	if kb.act[k].alpha < 1 and kb.act[k].alpha > 0.01 then
				kb.act[k].alpha = anim.lerp(kb.act[k].alpha, 0, get_speed()*3)
        	else
            	kb.act[k].alpha = 0
        	end 
            if (kb.act[k].alpha == 0) then kb.act[k] = nil end
    	end
        if kb.act[k] ~= nil and kb.act[k].alpha > (el.atype:get() == 1 and 0 or 0.25) and kb.act[k].offset-5 > maximum_offset then
            maximum_offset = kb.act[k].offset
        end
    end

    local should_draw = ((menu_is_open() or table_count(kb.act) > 0 and latest_item)) and el.selectable:get("Hotkey List")
    local alpha = anim.create("k_alpha", should_draw and 1 or 0, should_draw and get_speed() or get_speed()*3.33)
    local text = "keybinds"
    local text_size = render_get_text_size(fonts.verdana, text)
    local x, y = kb.dragging:get()
    local width = (el.atype:get() == 1 and maximum_offset or anim.create("k_width", maximum_offset, get_speed()*1.5))*0.98
    local height = 20
    local height_offset = height + (el.style:get() == 1 and 3 or el.padding:get())

    render_ui(vec2_t(x, y), vec2_t(width, (el.style:get() == 1 or el.padding:get() ~= 2) and height or height + 1), color_t(r, g, b, 255), color_t(r2, g2, b2, 255), el.style:get(), false, flr(255*alpha))
    render_text(fonts.verdana, text, vec2_t(x + (width / 2) - (text_size.x / 2), y + (height / 2) - (text_size.y / 2) + 1), color_t(255, 255, 255, flr(255*alpha)))
    
   	for bind_name, value in pairs(kb.act) do
        local key_type = "[" .. (value.mode or "~") .. "]"
        local key_type_size = render_get_text_size(fonts.verdana, key_type)

        render_text(fonts.verdana, bind_name, vec2_t(x + 4, y + height_offset+1), color_t(255, 255, 255, flr(alpha*value.alpha*255)))
        render_text(fonts.verdana, key_type, vec2_t(x + width - key_type_size.x - 6, y + height_offset+1), color_t(255, 255, 255, flr(alpha*value.alpha*255)))

        if el.atype:get() == 1 then 
            if value.active then 
                height_offset = height_offset + 15
            else 
                if value.alpha > 0.15 then 
                    height_offset = height_offset + 15
                else
                    height_offset = height_offset
                    value.alpha = 0
                end
            end
        else
            height_offset = flr(height_offset + 15.5 * value.alpha)
        end
   	end
   	
   	kb.dragging:handle(width, 20)
end
--@ end region

--@ spectator list region
sp.act = {}
sp.unsorted = {}
function sp.get_players()
	local ent = entity_list_get_local_player()
	if (ent == nil) then return end
	local ents, observing = {}, ent
	for i = 1, global_vars_max_clients() do
		local e = entity_list_get_entity(i)
		if (e == nil) then goto skip end
		if (e:get_class_name() == "CCSPlayer" and e:is_player()) then
			local m_iObserverMode = e:get_prop("m_iObserverMode")
			local m_hObserverTarget = entity_list_get_entity(e:get_prop("m_hObserverTarget"))

			if (m_hObserverTarget ~= nil) then
				m_hObserverTarget = m_hObserverTarget:get_index()
				if (m_hObserverTarget ~= nil and m_hObserverTarget <= 64 and not e:is_alive()) then
					if (ents[m_hObserverTarget] == nil) then ents[m_hObserverTarget] = {} end
					if (e == ent) then observing = m_hObserverTarget end
					table_insert(ents[m_hObserverTarget], e:get_index())
				end
			end
		end
		::skip::
	end
	local to_return = ent
	if observing ~= nil then to_return = type(observing) == "number" and observing or observing:get_index() end
	to_return = to_return == nil and ent:get_index() or to_return
	return ents, to_return
end

call.spec_list = function()
	local player = entity_list_get_local_player()
	local specs, e = sp.get_players()
	local accent_color = el.style:get() == "Solid" and el.c_solid:get() or el.c_gr1:get()
	local accent_color2 = el.c_gr2:get()
	local r, g, b = accent_color.r, accent_color.g, accent_color.b
	local r2, g2, b2 = accent_color2.r, accent_color2.g, accent_color2.b
    local maximum_offset = 50
	if (e == nil and player == nil) then 
		return 
	end

	for i = 1, 64 do 
		sp.unsorted[i] = {
			idx = i,
			active = false
		}
	end

	if specs[e] ~= nil then
		for _, spectator in pairs(specs[e]) do
			sp.unsorted[spectator] = {
				idx = spectator,
				active = (function() return spectator ~= player end)(),
			}
		end
	end

	for _, value in pairs(sp.unsorted) do
		local k = value.idx
		local e = entity_list_get_entity(k)
		if (e == nil) or not engine_is_connected() then goto skip end
		local c_nickname = e:get_name()
		
		if (value.active) then
			if (sp.act[k] == nil) then sp.act[k] = {alpha = 0, offset = 0, active = true} end
			sp.act[k].name = c_nickname
    		sp.act[k].alpha = anim.lerp(sp.act[k].alpha, 1, get_speed()*2)
    		sp.act[k].offset = render_get_text_size(fonts.verdana, c_nickname).x
            sp.act[k].active = true
        elseif (sp.act[k] ~= nil) then
            sp.act[k].alpha = anim.lerp(sp.act[k].alpha, 0, get_speed()*3)
            sp.act[k].active = false
            if (sp.act[k].alpha < 0.1) then sp.act[k] = nil end
    	end
        if (sp.act[k] ~= nil and sp.act[k].alpha > 0.2 and sp.act[k].offset > maximum_offset) then
            maximum_offset = sp.act[k].offset
        end
		::skip::
	end

    local should_draw = el.selectable:get("Spectator List (Cornered)")
    local alpha = anim.create("s_alpha", should_draw and 1 or 0, should_draw and get_speed() or get_speed()*2.25)
    local x, y = render_get_screen_size().x - 10, -20
    local width, height = anim.create("s_width", 75 + maximum_offset, 8), 22
    local height_offset = height + 3
    if alpha <= 0 then return end
	for _, value in pairs(sp.act) do
		if (value.name ~= player:get_name()) then
	        render_text(fonts.verdana, value.name, vec2_t(x - render_get_text_size(fonts.verdana, value.name).x, y + height_offset), color_t(255, 255, 255, flr(alpha*value.alpha*255)))
	        if el.atype:get() == 1 then 
	            if value.active then 
	                height_offset = height_offset + 15
	            else 
	                if value.alpha > 0.15 then 
	                    height_offset = height_offset + 15
	                else
	                    height_offset = height_offset
	                    value.alpha = 0
	                end
	            end
	        else
	            height_offset = flr(height_offset + 15 * value.alpha)
	        end
	    end
   	end
end
--@ end region

--@ watermark region
function get_latency()
    local netchann_info = engine_get_latency()
    if netchann_info == nil then return "0" end
    return flr(netchann_info*800, 0)
end

call.watermarker = function()
    local screen = render_get_screen_size()
	local accent_color = el.style:get() == 1 and el.c_solid:get() or el.c_gr1:get()
	local accent_color2 = el.c_gr2:get()
	local r, g, b = accent_color.r, accent_color.g, accent_color.b
	local r2, g2, b2 = accent_color2.r, accent_color2.g, accent_color2.b
    local ping = get_latency()
    local diff = ('%02d'):format(client_get_local_time())
    local clocks = el.style:get() == 1 and (('%02d:%02d:%02d'):format(client_get_local_time())) or (('%02d:%02d:%02d'):format(client_get_local_time()))
    local padding = 20
    local var = screen.x - anims.tsize - padding
    local x, y, w, h, ty = var - 5, 7, anims.tsize + 12, 17, 12
    local sep = el.sep:get() and "|" or ""
    local should_draw = el.selectable:get("Watermark")
    local alpha = anim.create("w_alpha", should_draw and 1 or 0, should_draw and get_speed() or get_speed()*3.33)

    if alpha <= 0 then return end
    render_push_alpha_modifier(alpha)
    render_ui(vec2_t(x+4, y), vec2_t(w, h+3), color_t(r, g, b, 255), color_t(r2, g2, b2, 255), el.style:get(), false, flr(255*alpha))
    local text_changer = (dat:get() and ((el.prefix:get() == "" or #el.prefix:get() > 20) and "revi" or el.prefix:get()) or "revi")
    local username = dat:get() and ((el.custom_name:get() == "" or #el.custom_name:get() > 20) and tostring(user.name) or el.custom_name:get()) or tostring(user.name)
    local wide = calc_size(fonts.verdana, tostring((dat:get() and ((el.prefix:get() == "" or #el.prefix:get() > 20) and "revi" or el.prefix:get()) or "revi") .. (dat:get() and ((el.prefix:get() == "" or #el.prefix:get() > 20) and "sion" or el.prefix:get()) or "sion")))
    render_text(fonts.verdana, text_changer, vec2_t(var+4, ty), color_t(255,255,255,255))

    wide = calc_size(fonts.verdana, text_changer)
    var = var + wide.x
    text_changer = (dat:get() and ((el.prefix2:get() == "" or #el.prefix2:get() > 20) and "sion" or el.prefix2:get()) or "sion")
    render_text(fonts.verdana, text_changer, vec2_t(var+4, ty), color_t(r,g,b,255))
    
    wide = calc_size(fonts.verdana, text_changer)
    var = var + wide.x - 1
    text_changer =  " " .. sep .. " ".. username .. " " .. sep .. (el.style:get() == 1 and " delay: " or  " ") .. (engine_is_connected() and (ping .. "ms") or "loopback")
    render_text(fonts.verdana, text_changer, vec2_t(var+5, ty), color_t(255,255,255,255))

    wide = calc_size(fonts.verdana, text_changer)
    var = var + wide.x - 1
    text_changer = " " .. sep .. " " .. clocks --.. (el.style:get() == 1 and "" or ((tonumber(diff) >= 12 and tonumber(diff) < 0) and "am" or "pm"))

    render_text(fonts.verdana, text_changer, vec2_t(var+5, ty), color_t(255,255,255,255))
    render_pop_alpha_modifier()

    wide = calc_size(fonts.verdana, text_changer)
    var = var + wide.x
    anims.tsize = var - (screen.x - anims.tsize - padding)
end
--@ end region

--@ exploit state
function delayed_fl()
    if engine_get_choked_commands() < anims.old_fl then anims.fl_s = anims.old_fl end
    anims.old_fl = engine_get_choked_commands()
    return anims.fl_s <= 14 and anims.fl_s or 14
end

call.ex_state = function()
    local me = entity_list_get_local_player()
    if not me then return end
    local screen = render_get_screen_size()
	local accent_color = el.style:get() == 1 and el.c_solid:get() or el.c_gr1:get()
	local accent_color2 = el.c_gr2:get()
	local r, g, b = accent_color.r, accent_color.g, accent_color.b
	local r2, g2, b2 = accent_color2.r, accent_color2.g, accent_color2.b
    local charge = tostring(flr(get_charge()))
    local ex_text = ((get_charge()/get_charge() == 1) and "EXPLOITING" or (get_binds.doubletap[2]:get() and "CHARGING" or "CHOKING"))
    local fl_text = "FL: "
    local fl_nums = (get_charge()/get_charge() == 0) and tostring(delayed_fl()) or (get_binds.doubletap[2]:get() and 1 or (tostring(delayed_fl())))
    local tsf = calc_size(fonts.verdana, fl_text).x
    local tsn = calc_size(fonts.verdana, tostring(fl_nums)).x
    local tse = calc_size(fonts.verdana, tostring(ex_text)).x
    local x = screen.x - tsf - 100 - flr(anims.extend_c) - flr(anims.extend_x)
    local x2 = screen.x - tsf - 75 - flr(anims.extend_c) - flr(anims.extend_x)
    local h = 33
    local text_y = h + 2
    local empty = color_t(17, 17, 17, el.bg_alpha:get()*anims.ex_alpha)
    local empty2 = color_t(0, 0, 0, 0)
    local fl_color = color_t(255-flr(delayed_fl()/14*100), 55+flr(delayed_fl()/14*200), 55, 255)
    anims.extend_c = anim.lerp(anims.extend_c, (get_charge()/get_charge() < 1 and get_binds.doubletap[2]:get()) and 10 or 0, get_speed()*0.5)
    anims.extend_x = anim.lerp(anims.extend_x, (get_charge()/get_charge() == 1) and 15 or 0, get_speed()*0.5)
    anims.disabler = anim.lerp(anims.disabler, el.selectable:get("Watermark") and 0 or 1, get_speed())
    local dis = flr(anims.disabler*27)
    local should_draw = el.selectable:get("Exploit State")
    local alpha = anim.create("ex_alpha", should_draw and 1 or 0, should_draw and get_speed() or get_speed()*2.25)

    if alpha <= 0 then return end
    render_push_alpha_modifier(alpha)
    --fl
    render_ui(vec2_t(x-13, h-dis), vec2_t(tsf+28, h/2+4), color_t(r, g, b, 255), color_t(r2, g2, b2, 255), el.style:get(), el.style:get() == 1, flr(255*alpha))
    if el.style:get() == 1 then render_rect_filled(vec2_t(x-13, h-dis+3), vec2_t(2, h/2+2), fl_color) end    
    render_text(fonts.verdana, fl_text, vec2_t(x-6, text_y-dis+3), color_t(255,255,255,255))
    render_text(fonts.verdana, tostring(fl_nums), vec2_t(x2+3-tsn, text_y-dis+3), color_t(255,255,255,255))
    --exploiting
    render_ui(vec2_t(screen.x - 21 - tse, h-dis), vec2_t(tse+11, h/2+4), color_t(r, g, b, 255), color_t(r2, g2, b2, 255), el.style:get(), el.style:get() == 1, flr(255*alpha))
    render_text(fonts.verdana, ex_text, vec2_t(screen.x - tse - 16, text_y-dis+3), color_t(255,255,255,255))
	render_rect_fade(vec2_t(screen.x - 10 - tse, h*1.5+4-dis), vec2_t(tse/2-5, 1), empty2, el.style:get() == 1 and color_t(r, g, b, 200) or color_t(r2, g2, b2, 200), true)
	render_rect_fade(vec2_t(screen.x - 20 - tse/2+5, h*1.5+4-dis), vec2_t(tse/2-5, 1), el.style:get() == 1 and color_t(r, g, b, 200) or color_t(r2, g2, b2, 200), empty2, true)
    render_pop_alpha_modifier()
end
--@ end region

--@ callbacks setup
callbacks_add(e_callbacks.PAINT, function() 
	el.manager() 
	call.watermarker() 
	call.ex_state() 
	kb_handle() 
	call.spec_list() 
end)