local build_info = {
    type = "beta",
    version = "0.1",
    user = user.name,
    uid = user.uid
}
local function color(r, g, b, a)
    if r==nil then r = 255 end; if g==nil then g = 255 end; if b==nil then b = 255 end; if a==nil then a = 255 end;
    return color_t(r,g,b,a)
end
local function vector(x, y, z)
    x = x or 0;
    y = y or 0;
    z = z or 0;
    local m_return = { x = x, y = y, z = z }
    m_return.length = function(self)
        return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
    end
    m_return.length2d = function(self)
        return math.sqrt(self.x * self.x + self.y * self.y)
    end
    m_return.to_screen = function(self)
        local screen_pos = render.world_to_screen(vec3_t(self.x, self.y, self.z))
        return vector(screen_pos.x,screen_pos.y)
    end
    return m_return
end
local renderer = {}
renderer.normalize_pos = function(from, to)
    if from.x>to.x then
        local m = from.x
        from.x = to.x; to.x = m;
    end
    if from.y > to.y then
        local m = from.y
        from.y = to.y;
        to.y = m;
    end
    local pos = vec2_t(from.x,from.y)
    local size = vec2_t(to.x - from.x, to.y - from.y)
    return pos,size
end
renderer.create_texture = function(path)
    return render.load_image(path)
end
renderer.create_texture_buffer = function(raw_file)
    return render.load_image_buffer(raw_file)
end
renderer.create_font = function(name, size, weight, ...)
    return render.create_font(name, size, weight, ...)
end
renderer.default_font = function()
    return render.get_default_font()
end
renderer.texture = function(texture,pos,size,col)
    return render.texture(texture.id, vec2_t(pos.x, pos.y), vec2_t(size.x, size.y),col)
end
renderer.text = function(font, position, color, text, centered)
    return render.text(font, text, vec2_t(position.x, position.y), color,centered or false)
end
renderer.measure_text = function(font, text)
    local sz = render.get_text_size(font, text)
    return vector(sz.x, sz.y)
end
renderer.push_clip = function(from, to)
    return render.push_clip(renderer.normalize_pos(from, to))
end
renderer.pop_clip = function()
    return render.pop_clip()
end
renderer.push_alpha = function(float_mod)
    return render.push_alpha_modifier(float_mod)
end
renderer.pop_alpha = function()
    return render.pop_alpha_modifier()
end
renderer.screen_size = function()
    local screen_sz = render.get_screen_size()
    return vector(screen_sz.x, screen_sz.y)
end
renderer.line = function(from, to, col)
    local pos, size = renderer.normalize_pos(from, to)
    return render.line(pos,vec2_t(pos.x+size.x,pos.y+size.y),col or color())
end
renderer.line = function(from, to, col)
    local pos, size = renderer.normalize_pos(from, to)
    return render.line(pos, vec2_t(pos.x + size.x, pos.y + size.y), col or color())
end
renderer.rect = function(from, to, col, rounding)
    local pos, size = renderer.normalize_pos(from, to)
    return render.rect(pos, size, col or color(),rounding or 0)
end
renderer.rect_filled = function(from, to, col, rounding)
    local pos, size = renderer.normalize_pos(from, to)
    return render.rect_filled(pos, size, col or color(),rounding or 0)
end
renderer.rect_fade = function(from, to, col_start, col_end, horizontal)
    local pos, size = renderer.normalize_pos(from, to)
    return render.rect_fade(pos, size, col_start or color(), col_end or color(), horizontal or false)
end
renderer.circle = function(pos, col, radious, border)
    return render.circle(vec2_t(pos.x,pos.y),radious,col or color(),border or 1)
end
renderer.circle_filled = function(pos, col, radious)
    return render.circle_filled(vec2_t(pos.x, pos.y), radious, col or color())
end
renderer.circle_progress = function(pos, col, radious, border, point)
    if radious < 1 then
        radious = 0
        render.rect_filled(vec2_t(pos.x, pos.y), vec2_t(1, 1), col or color())
    end
    return render.progress_circle(vec2_t(pos.x, pos.y), radious, col or color(), border, point)
end
renderer.world_to_screen = function(pos)
    local screen_pos = render.world_to_screen(vec3_t(pos.x, pos.y, pos.z))
    return vector(screen_pos.x,screen_pos.y,screen_pos.z)
end
local config_system = {data={},tabs = {}}
local class_data = {}
class_data.list = function(element, tabs)
    local m_return = { element = element, tabs = tabs, original_tabs = tabs }
    m_return.get = function(self)
        return self.element:get()
    end
    m_return.get_string = function(self)
        return self.element:get_active_item_name()
    end
    m_return.set = function(self, v)
        return self.element:set(v)
    end
    m_return.set_string = function(self, v)
        return self.element:set_by_name(v)
    end
    m_return.set_visible = function(self, v)
        return self.element:set_visible(v)
    end
    m_return.add_keybind = function(self, title)
        return self.element:add_keybind(title)
    end
    m_return.add_color_picker = function(self, title)
        return self.element:add_color_picker(title)
    end
    m_return.get_original_items = function(self)
        return self.original_tabs
    end
    m_return.reset_items = function(self)
        self.tabs = self.original_tabs
        return self.element:set_items(self.original_tabs)
    end
    m_return.get_items = function(self)
        return self.element:get_items()
    end
    m_return.set_items = function(self, items)
        self.tabs = items
        return self.element:set_items(items)
    end
    m_return.add_item = function(self, item)
        table.insert(self.tabs, item)
        return self.element:add_item(item)
    end
    m_return.remove_item = function(self, item)
        for n = 1, #self.tabs do
            if self.tabs[n] and self.tabs[n] == item then table.remove(self.tabs, n) end
        end
        return self.element:remove_item(item)
    end
    return m_return
end
class_data.combo = function(element, tabs)
    local m_return = { element = element, tabs = tabs,original_tabs = tabs}
    m_return.get = function(self)
        return self.element:get()
    end
    m_return.get_string = function(self)
        return self.tabs[self.element:get()]
    end
    m_return.set = function(self,v)
        return self.element:set(v)
    end
    m_return.set_string = function(self, v)
        for n =1, #self.tabs do
            if self.tabs[n]==v then self.element:set(n) end
        end
    end
    m_return.set_visible = function(self,v)
        return self.element:set_visible(v)
    end
    m_return.add_keybind = function(self,title)
        return self.element:add_keybind(title)
    end
    m_return.add_color_picker = function(self,title)
        return self.element:add_color_picker(title)
    end
    m_return.get_original_items = function(self)
        return self.original_tabs
    end
    m_return.reset_items = function(self)
        self.tabs = self.original_tabs
        return self.element:set_items(self.original_tabs)
    end
    m_return.get_items = function(self)
        return self.element:get_items()
    end
    m_return.set_items = function(self, items)
        self.tabs = items
        return self.element:set_items(items)
    end
    m_return.add_item = function(self, item)
        table.insert(self.tabs,item)
        return self.element:add_item(item)
    end
    m_return.remove_item = function(self, item)
        for n = 1, #self.tabs do
            if self.tabs[n] and self.tabs[n] == item then table.remove(self.tabs,n) end
        end
        return self.element:remove_item(item)
    end
    return m_return
end
class_data.multicombo = function(element, tabs)
    local m_return = { element = element, tabs = tabs,original_tabs = tabs}
    m_return.get = function(self,i)
        return self.element:get(i)
    end
    m_return.set = function(self,i,v)
        return self.element:set(i,v)
    end
    m_return.set_string = function(self,i,v)
        for n =1, #self.tabs do
            if self.tabs[n]==v then self.element:set(n,v) end
        end
    end
    m_return.set_visible = function(self,v)
        return self.element:set_visible(v)
    end
    m_return.add_keybind = function(self,title)
        return self.element:add_keybind(title)
    end
    m_return.add_color_picker = function(self,title)
        return self.element:add_color_picker(title)
    end
    m_return.get_original_items = function(self)
        return self.original_tabs
    end
    m_return.reset_items = function(self)
        self.tabs = self.original_tabs
        return self.element:set_items(self.original_tabs)
    end
    m_return.get_items = function(self)
        return self.element:get_items()
    end
    m_return.set_items = function(self, items)
        self.tabs = items
        return self.element:set_items(items)
    end
    m_return.add_item = function(self, item)
        table.insert(self.tabs,item)
        return self.element:add_item(item)
    end
    m_return.remove_item = function(self, item)
        for n = 1, #self.tabs do
            if self.tabs[n] and self.tabs[n] == item then table.remove(self.tabs,n) end
        end
        return self.element:remove_item(item)
    end
    return m_return
end
class_data.tab = function(tab, child)
    local m_return = {tab=tab,child=child}
    m_return.checkbox = function(self, title, def_value)
        if config_system.data[self.tab][title] == nil then
            config_system.data[self.tab][title] = menu.add_checkbox(self.child, title, def_value or false)
        end
        if config_system.data[self.tab].childs[self.child]==nil then
            config_system.data[self.tab].childs[self.child] = true
        end
        return config_system.data[self.tab][title]
    end
    m_return.combo = function(self, title, items)
        if config_system.data[self.tab][title] == nil then
            config_system.data[self.tab][title] = menu.add_selection(self.child, title, items)
        end
        if config_system.data[self.tab].childs[self.child]==nil then
            config_system.data[self.tab].childs[self.child] = true
        end
        return class_data.combo(config_system.data[self.tab][title])
    end
    m_return.multicombo = function(self, title, items)
        if config_system.data[self.tab][title] == nil then
            config_system.data[self.tab][title] = menu.add_multi_selection(self.child, title, items)
        end
        if config_system.data[self.tab].childs[self.child]==nil then
            config_system.data[self.tab].childs[self.child] = true
        end
        return class_data.multicombo(config_system.data[self.tab][title])
    end
    m_return.slider = function(self, title, min, max, format_str)
        if config_system.data[self.tab][title] == nil then
            config_system.data[self.tab][title] = menu.add_slider(self.child, title, min, max, 1, 0, format_str or "")
        end
        if config_system.data[self.tab].childs[self.child]==nil then
            config_system.data[self.tab].childs[self.child] = true
        end
        return config_system.data[self.tab][title]
    end
    m_return.sliderfloat = function(self, title, min, max, format_str)
        if config_system.data[self.tab][title] == nil then
            config_system.data[self.tab][title] = menu.add_slider(self.child, title, min, max, 0.1, 1, format_str or "")
        end
        if config_system.data[self.tab].childs[self.child]==nil then
            config_system.data[self.tab].childs[self.child] = true
        end
        return config_system.data[self.tab][title]
    end
    m_return.list = function(self, title, items)
        if config_system.data[self.tab][title] == nil then
            config_system.data[self.tab][title] = menu.add_list(self.child, title, items)
        end
        if config_system.data[self.tab].childs[self.child]==nil then
            config_system.data[self.tab].childs[self.child] = true
        end
        return class_data.list(config_system.data[self.tab][title],items)
    end
    return m_return
end
config_system.create = function(tab, child, side)
    if config_system.data[tab] == nil then
        config_system.data[tab] = { childs = {} }
        if tab~="Main" then table.insert(config_system.tabs,tab) end
    end
    if tab ~= "Main" then
        if side~=nil then menu.set_group_column(tab.." > "..child, side) end
        return class_data.tab(tab, tab.." > "..child)
    end
    if side~=nil then menu.set_group_column(child, side) end
    return class_data.tab(tab, child)
end
local tab = {
    main = config_system.create("Main","Main",1),
    ragebot = {
        main = config_system.create("Ragebot System", "Main", 2),
        dormant = config_system.create("Ragebot System", "Dormant Aimbot", 2),
    },
    antiaim = {
        main = config_system.create("Anti-aim Tehnology","Main",2),
        builder = config_system.create("Anti-aim Tehnology","Builder",1),
        animations = config_system.create("Anti-aim Tehnology","Animations",2),
    },
    visuals = {
        main = config_system.create("Visualizations","Main",2),
        ui = config_system.create("Visualizations", "UI", 2),
    },
    misc = {
        main = config_system.create("Miscellaneous", "Main", 2),
    },
    user = {
        main = config_system.create("User Info","Main",2),
    },
}
local lua = {
    tab = tab.main:list("Solitude.solutions Selection",config_system.tabs),
    ragebot = {
        enable = tab.ragebot.main:checkbox("enable ragebot system"),
        dormantaimbot = tab.ragebot.dormant:checkbox("dormant aimbot"),
        dormanttime = tab.ragebot.dormant:slider("maximum target dormant time",100,1500,"ms"),
        dormantdamage = tab.ragebot.dormant:sliderfloat("targeted damage",0,100),
    },
    antiaim = {
        enable = tab.antiaim.main:checkbox("enable anti-aim tehnology"),
        mode = tab.antiaim.main:combo("anti-aim mode",{"preset data","custom builder"}),
        yawbase = tab.antiaim.builder:combo("yaw base",{"view angle", "at target ( crosshair )", "at target ( distance )"}),
        builderselection = tab.antiaim.main:list("builder selection", { "shared", "stand", "crouch", "slow-walk", "moving", "air", "air-duck" }),
        builder = {},
        enableanimations = tab.antiaim.animations:checkbox("enable local animations"),
        animationsoptions = tab.antiaim.animations:multicombo("animations options", {"static legs in air","backward legs on ground","pitch 0 on land","movement lean"}),
        leanammount = tab.antiaim.animations:sliderfloat("lean ammount",0,100,"%"),
    },
    visuals = {
        enable = tab.visuals.main:checkbox("enable visualizations")
    },
    misc = {
        enable = tab.misc.main:checkbox("enable miscellaneous"),
        primordialwatermark = tab.misc.main:combo("primordial watermark",{"default","solitude","none"}),
    },
    user = {
        enable = tab.user.main:checkbox("enable user info")      
    }
}
lua.ragebot.dormantaimbot_bind = lua.ragebot.dormantaimbot:add_keybind("dormant aimbot bind")
for n = 0, 6 do
    local total_states = { "", "[s] ", "[c] ", "[sw] ", "[m] ", "[a] ", "[ad] " }
    local state_add = total_states[n+1]
    local state_builder = {}
    if n~=0 then
        state_builder.override = tab.antiaim.builder:checkbox(state_add.."override shared")
    end
    state_builder.yawaddtype = tab.antiaim.builder:combo(state_add.."yaw add type",{"default","left/right"})
    state_builder.yawadd = tab.antiaim.builder:slider(state_add.."yaw add",-180,180)
    state_builder.yawaddleft = tab.antiaim.builder:slider(state_add.."yaw add left",-180,180)
    state_builder.yawaddright = tab.antiaim.builder:slider(state_add.."yaw add right",-180,180)
    state_builder.yawmodifier = tab.antiaim.builder:combo(state_add.."yaw modifier",{"disabled","center","offset","random"})
    state_builder.modifierdegree = tab.antiaim.builder:slider(state_add.."modifier degree",-180,180)
    state_builder.desynctype = tab.antiaim.builder:combo(state_add.."desync type",{"disabled","static","jitter"})
    state_builder.desyncinvert = tab.antiaim.builder:checkbox(state_add.."invert desync")
    state_builder.desyncinvert_bind = state_builder.desyncinvert:add_keybind(state_add.."invert desync bind")
    state_builder.desyncleft = tab.antiaim.builder:slider(state_add.."desync left",0,60)
    state_builder.desyncright = tab.antiaim.builder:slider(state_add.."desync right",0,60)
    lua.antiaim.builder[n] = state_builder
end
config_system.set_visibility = function()
    if not menu.is_open() then return end
    local selected_tab = lua.tab:get_string()
    for tab_name, tab in pairs(config_system.data) do
        for child_name, child in pairs(tab.childs) do
            menu.set_group_visibility(child_name, tab_name == "Main" or selected_tab == tab_name)
        end
        ::skip_tab::
    end
end
local lua_render = {}
lua_render.setup_elements = function()
    local enabled_rage = lua.ragebot.enable:get()
    lua.ragebot.dormantaimbot:set_visible(enabled_rage)
    lua.ragebot.dormanttime:set_visible(enabled_rage and lua.ragebot.dormantaimbot:get())
    lua.ragebot.dormantdamage:set_visible(enabled_rage and lua.ragebot.dormantaimbot:get())
    local enabled_aa = lua.antiaim.enable:get()
    lua.antiaim.mode:set_visible(enabled_aa)
    local builder_condition = enabled_aa and lua.antiaim.mode:get()==2
    lua.antiaim.yawbase:set_visible(builder_condition)
    lua.antiaim.builderselection:set_visible(builder_condition)
    local selected_state = lua.antiaim.builderselection:get()-1
    for n = 0, 6 do
        local state_condition = builder_condition and selected_state==n and (n==0 or lua.antiaim.builder[n].override:get())
        if n ~= 0 then
            lua.antiaim.builder[n].override:set_visible(builder_condition and selected_state == n)
        end
        lua.antiaim.builder[n].yawaddtype:set_visible(state_condition)
        lua.antiaim.builder[n].yawadd:set_visible(state_condition and lua.antiaim.builder[n].yawaddtype:get()==1)
        lua.antiaim.builder[n].yawaddleft:set_visible(state_condition and lua.antiaim.builder[n].yawaddtype:get()==2)
        lua.antiaim.builder[n].yawaddright:set_visible(state_condition and lua.antiaim.builder[n].yawaddtype:get()==2)
        lua.antiaim.builder[n].yawmodifier:set_visible(state_condition)
        lua.antiaim.builder[n].modifierdegree:set_visible(state_condition and lua.antiaim.builder[n].yawmodifier:get()>1)
        lua.antiaim.builder[n].desynctype:set_visible(state_condition)
        local enabled_desync = lua.antiaim.builder[n].desynctype:get()>1
        lua.antiaim.builder[n].desyncinvert:set_visible(state_condition and lua.antiaim.builder[n].desynctype:get()==2)
        --lua.antiaim.builder[n].desyncinvert_bind:set_visible(state_condition)
        lua.antiaim.builder[n].desyncleft:set_visible(state_condition and enabled_desync)
        lua.antiaim.builder[n].desyncright:set_visible(state_condition and enabled_desync)
    end
    local enabled_animations = lua.antiaim.enableanimations:get()
    lua.antiaim.animationsoptions:set_visible(enabled_animations)
    lua.antiaim.leanammount:set_visible(enabled_animations and lua.antiaim.animationsoptions:get(4))
    local enabled_misc = lua.misc.enable:get()
    lua.misc.primordialwatermark:set_visible(enabled_misc)
end
callbacks.add(e_callbacks.PAINT, function()
    config_system.set_visibility()
    lua_render.setup_elements()
end)
callbacks.add(e_callbacks.DRAW_WATERMARK, function()
    if lua.misc.enable:get() then
        local prim_watermark = lua.misc.primordialwatermark:get()
        if prim_watermark == 2 then return "solitude.solutions exclusives" elseif prim_watermark == 3 then return "" end
    end
    return "primordial - "..build_info.user
end)
local reference = {
    antiaim = {
        manual = {
            manual_left = menu.find("antiaim", "main", "manual", "left"),
            manual_right = menu.find("antiaim", "main", "manual", "right"),
        },
        angles = {
            pitch = menu.find("antiaim", "main", "angles", "pitch"),
            yaw_base = menu.find("antiaim", "main", "angles", "yaw base"),
            yaw_add = menu.find("antiaim", "main", "angles", "yaw add"),
            rotate = menu.find("antiaim", "main", "angles", "rotate"),
            jitter_mode = menu.find("antiaim", "main", "angles", "jitter mode"),
            jitter = menu.find("antiaim", "main", "angles", "jitter add"),
            body_lean = menu.find("antiaim", "main", "angles", "body lean"),
        },
        desync = {
            anti_bruteforce = menu.find("antiaim", "main", "desync", "anti bruteforce"),
            on_shot = menu.find("antiaim", "main", "desync", "on shot"),
            side = menu.find("antiaim", "main", "desync", "side#stand"),
            left_amount = menu.find("antiaim", "main", "desync", "left amount#stand"),
            right_amount = menu.find("antiaim", "main", "desync", "right amount#stand"),
            override_move = menu.find("antiaim", "main", "desync", "override stand#move"),
            override_slow_walk = menu.find("antiaim", "main", "desync", "override stand#slow walk"),
        },
        fakelag = menu.find("antiaim", "main", "fakelag", "amount"),
    }
}
local aa = {}
aa.air_time = 0
aa.local_state = 1
aa.body_yaw = false
aa.command_number = 0
aa.hitbox_data = {}
aa.get_local_state = function()
    local local_player = entity_list.get_local_player()
    local flags = local_player:get_prop("m_fFlags")
    local speed_x = local_player:get_prop("m_vecVelocity[0]")
    local speed_y = local_player:get_prop("m_vecVelocity[1]")
    local speed = math.sqrt(speed_x * speed_x + speed_y * speed_y)
    local in_air = (bit.band(flags, 1) ~= 1 or bit.band(bit.lshift(1, 1)) == 1)
    local is_crouch = (bit.band(flags, 4) == 4) or input.is_key_pressed(e_keys.KEY_LCONTROL) or antiaim.is_fakeducking()
    if in_air then aa.air_time = global_vars.cur_time() + 0.05 end
    local on_ground = global_vars.cur_time() > aa.air_time
    local state = 1
    if on_ground then
        if is_crouch then --crouch
            state = 2
        else
            if input.is_key_held(e_keys.KEY_LSHIFT) and speed > 7 then --slow-walk
                state = 3
            else
                if speed <= 7 then --stand
                    state = 1
                else --moving
                    state = 4
                end
            end
        end
    else
        if is_crouch then --crouch-air
            state = 6
        else --air
            state = 5
        end
    end
    return state
end
aa.normalize = function(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end
aa.execute = function(cmd)
    if engine.get_choked_commands() == 0 then aa.body_yaw = not aa.body_yaw end
    local antiaim_mode = lua.antiaim.mode:get()
    reference.antiaim.desync.override_move:set(false)
    reference.antiaim.desync.override_slow_walk:set(false)
    reference.antiaim.angles.pitch:set(2)
    if antiaim_mode == 1 then
        
    else
        local execute_state = aa.local_state; if not lua.antiaim.builder[execute_state].override:get() then execute_state = 0 end
        local settings_reference = lua.antiaim.builder[execute_state]
        local data = {}
        data.add_yaw = 0
        data.mod_deg = 0
        reference.antiaim.angles.yaw_base:set(lua.antiaim.yawbase:get()+1)
        if settings_reference.desynctype:get() > 1 then
            reference.antiaim.desync.side:set(aa.body_yaw and 2 or 3)
            reference.antiaim.desync.left_amount:set(settings_reference.desyncleft:get()/60*100)
            reference.antiaim.desync.right_amount:set(settings_reference.desyncleft:get()/60*100)
        else
            reference.antiaim.desync.side:set(1)
            reference.antiaim.desync.left_amount:set(0)
            reference.antiaim.desync.right_amount:set(0)
        end
        if settings_reference.yawaddtype:get() == 1 then
            data.add_yaw = settings_reference.yawadd:get()
        else
            if aa.body_yaw then
                data.add_yaw = settings_reference.yawaddleft:get()
            else
                data.add_yaw = settings_reference.yawaddright:get()
            end
        end
        local yaw_modifier = settings_reference.yawmodifier:get()
        if yaw_modifier>1 then
            if aa.body_yaw then
                data.mod_deg = settings_reference.modifierdegree:get()/2
            else
                data.mod_deg = -settings_reference.modifierdegree:get()/2
            end
        end
        reference.antiaim.angles.yaw_add:set(aa.normalize(data.add_yaw+data.mod_deg))
    end
end
aa.animations = function(antiaim_context)
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end
    local flags = local_player:get_prop("m_fFlags")
    local in_air = (bit.band(flags, 1) ~= 1 or bit.band(bit.lshift(1, 1)) == 1)
    -- Set the MOVE_BLEND_WALK param if the checkbox is checked
    if lua.antiaim.animationsoptions:get(1) then
        antiaim_context:set_render_pose(e_poses.STRAFE_DIR, 0)
    end
    -- Set the JUMP_FALL param if the checkbox is checked
    if lua.antiaim.animationsoptions:get(2) then
        antiaim_context:set_render_pose(e_poses.JUMP_FALL, 1)
    end
    if lua.antiaim.animationsoptions:get(3) and aa.local_state < 5 and global_vars.cur_time() < (aa.air_time + 0.5) then
        antiaim_context:set_render_pose(e_poses.BODY_PITCH, 0.5)
    end
    if aa.local_state > 3 and lua.antiaim.animationsoptions:get(4) then
        antiaim_context:set_render_animlayer(
            e_animlayers.LEAN, lua.antiaim.leanammount:get() / 100, 1)
    else
        antiaim_context:set_render_animlayer(
            e_animlayers.LEAN, 0, 1)
    end
end
aa.IsAlive = function()
    local local_player =  entity_list.get_local_player()
    if not local_playeror or not local_player:is_alive() then return false end
    return true
end
aa.IsScoped = function()
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then return false end
    return local_player:get_prop("m_bIsScoped")==1
end
aa.calcDistance = function(from,to)
    return math.sqrt((to.x-from.x)*(to.x-from.x)+(to.y-from.y)*(to.y-from.y))
end

aa.CalcAngle = function(src, dst)
    local vecdelta = vector(dst.x - src.x, dst.y - src.y, dst.z - src.z)
    return angle_t(math.atan2(-vecdelta.z, vecdelta:length()) * 180.0 / math.pi, (math.atan2(vecdelta.y, vecdelta.x) * 180.0 / math.pi), 0.0)
end

local dormant_time = {}

aa.bestTarget = function()
    local best_target = nil
    local best_health = 99999
    local best_distance = 1000000
    local local_player = entity_list.get_local_player()
    for n=0,64 do
        local entity = entity_list.get_entity(n)
        if not entity then goto finish_target end
        if dormant_time[n]==nil then
            dormant_time[n] = global_vars.cur_time()+lua.ragebot.dormanttime:get()/100
        end
        if entity:get_prop("m_iTeamNum") == local_player:get_prop("m_iTeamNum") or not entity:is_player() or not entity:is_alive() or not entity:is_dormant() then 
            if not entity:is_dormant() then
                dormant_time[n] = global_vars.cur_time()+lua.ragebot.dormanttime:get()/100
            end
            goto finish_target 
        end
        local player = entity
        local this_distance = aa.calcDistance(local_player:get_prop("m_vecOrigin"),player:get_prop("m_vecOrigin"))
        if entity:get_prop("m_iHealth")<=best_health and this_distance<=best_distance and dormant_time[n]>global_vars.cur_time() then 
            best_target = player
            best_distance = this_distance
        end
        ::finish_target::
    end
    return best_target
end

aa.bestHitbox = function(player,logic)
    local best_hitbox = nil
    local best_damage = lua.ragebot.dormantdamage:get()
    local hitboxes = {e_hitboxes.HEAD,e_hitboxes.NECK,e_hitboxes.PELVIS,e_hitboxes.THORAX,e_hitboxes.CHEST,e_hitboxes.UPPER_CHEST}
    local local_player = entity_list.get_local_player()
    for n,hitbox in pairs(hitboxes) do
        local hitboxPos = player:get_hitbox_pos(hitbox)
        local bulletTrace = trace.bullet(local_player:get_eye_position(),hitboxPos)
        local damageSpare = 1
        if hitbox==e_hitboxes.HEAD then
            damageSpare = 0.6
            if logic==3 then
                damageSpare = 0.9
            end
        elseif logic==2 then
            damageSpare = 1.2
        end
        if bulletTrace.valid and bulletTrace.damage > 0 and (bulletTrace.damage*damageSpare)>=best_damage then
            best_damage = bulletTrace.damage
            best_hitbox = hitbox
        end
    end
    return {hitbox=best_hitbox,damage=best_damage}
end

aa.autoStop = function(cmd)
    if cmd.move.x<-1 then
        cmd.move.x=-1
    elseif cmd.move.x>1  then
        cmd.move.x=1
    end
    if cmd.move.y<-1 then
        cmd.move.y=-1
    elseif cmd.move.y>1  then
        cmd.move.y=1
    end
    return cmd.move.x>=-1 and cmd.move.x<=1 and cmd.move.y>=-1 and cmd.move.y<=1
end
aa.scopeTime = 0
aa.autoScope = function(cmd)
    if ragebot.get_active_cfg() <= 3 and not aa.IsScoped() then
        cmd:add_button(e_cmd_buttons.ATTACK2)
        aa.scopeTime = global_vars.cur_time()+0.08
    end
    return aa.IsScoped()
end
aa.lastShot = 0
aa.dormantaimbot = function(cmd)
    if not aa.IsAlive() then return end
    if aa.local_state>4 then return end
    local local_player = entity_list.get_local_player()
    local dormantTarget = aa.bestTarget()
    if dormantTarget~=nil then
        local dormantHitbox = aa.bestHitbox(dormantTarget,1)
        if dormantHitbox.hitbox~=nil then
            aa.autoScope(cmd)
            if client.can_fire() and aa.lastShot <= global_vars.cur_time() and aa.scopeTime<global_vars.cur_time() then--ragebot
                if aa.autoStop(cmd) then
                    local shootAngle = aa.CalcAngle(local_player:get_eye_position(),dormantTarget:get_hitbox_pos(dormantHitbox.hitbox))
                    local aimPunch = local_player:get_prop("m_aimPunchAngle")
                    cmd.viewangles.x = shootAngle.x - aimPunch.x
                    cmd.viewangles.y = shootAngle.y- aimPunch.y
                    cmd.viewangles.z = 0
                    cmd:add_button(e_cmd_buttons.ATTACK)
                    aa.lastShot = global_vars.cur_time() + 0.1
                    print("primordial | dormant fire at "..dormantTarget:get_name().." for "..tostring(dormantHitbox.damage).." damage")
                end
            end
        end
    end
end
callbacks.add(e_callbacks.ANTIAIM, function(ctx,cmd)
    aa.local_state = aa.get_local_state()
    if lua.antiaim.enable:get() then aa.execute(cmd) end
    if lua.antiaim.enableanimations:get() then aa.animations(ctx) end
end)
callbacks.add(e_callbacks.SETUP_COMMAND,function(cmd)
    if lua.ragebot.enable:get() and lua.ragebot.dormantaimbot:get() and lua.ragebot.dormantaimbot_bind:get() then
        aa.dormantaimbot(cmd)
    end
end)