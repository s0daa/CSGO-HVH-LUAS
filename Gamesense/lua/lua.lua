--#region antarctica writed on pui
--[[

    Antarctica.scripts ~ GameSense
          Coder: @javasense
      Build: Reborn ~ GameSense

]]
--#endregion

--#region lua
local lua = {}
lua.configs = {}
--#endregion

--#region require
local pui = require('gamesense/pui')
local base64 = require('gamesense/base64')
local clipboard = require('gamesense/clipboard')
local antiaim_data = require('gamesense/antiaim_funcs')
local vector = require('vector')
local ffi = require('ffi')
local weapons = require('gamesense/csgo_weapons')
lua.entity = require('gamesense/entity')
--#endregion

--#region drag
local draggable = {}
draggable.__index = draggable

function draggable:new(name, base_x, base_y, width, height)
    local screen_w, screen_h = client.screen_size()
    local pos_x_slider = pui.slider('LUA', 'B', name .. ' Position X', 0, 10000, base_x / screen_w * 10000)
    local pos_y_slider = pui.slider('LUA', 'B', name .. ' Position Y', 0, 10000, base_y / screen_h * 10000)
    pos_x_slider:set_visible(false)
    pos_y_slider:set_visible(false)

    local obj = setmetatable({
        name = name,
        width = width or 200,
        height = height or 100,
        x_slider = pos_x_slider,
        y_slider = pos_y_slider,
        is_dragging = false,
        offset_x = 0,
        offset_y = 0
    }, draggable)

    return obj
end

function draggable:get_position()
    local screen_w, screen_h = client.screen_size()
    local x = self.x_slider:get() / 10000 * screen_w
    local y = self.y_slider:get() / 10000 * screen_h
    return x, y
end

function draggable:set_position(x, y)
    local screen_w, screen_h = client.screen_size()
    self.x_slider:set(x / screen_w * 10000)
    self.y_slider:set(y / screen_h * 10000)
end

function draggable:start_drag(mouse_x, mouse_y)
    local x, y = self:get_position()
    self.is_dragging = true
    self.offset_x = mouse_x - x
    self.offset_y = mouse_y - y
end

function draggable:stop_drag()
    self.is_dragging = false
end

function draggable:handle_drag()
    local mouse_x, mouse_y = ui.mouse_position()

    if self.is_dragging then
        local new_x = mouse_x - self.offset_x
        local new_y = mouse_y - self.offset_y

        local screen_w, screen_h = client.screen_size()
        new_x = math.max(0, math.min(screen_w - self.width, new_x))
        new_y = math.max(0, math.min(screen_h - self.height, new_y))

        self:set_position(new_x, new_y)

        if not client.key_state(0x01) then
            self:stop_drag()
        end
    else
        local x, y = self:get_position()
        local is_hovering = mouse_x >= x and mouse_x <= x + self.width and mouse_y >= y and mouse_y <= y + self.height

        if is_hovering and ui.is_menu_open() and client.key_state(0x01) then
            self:start_drag(mouse_x, mouse_y)
        end
    end
end
--#endregion

--#region render
local render = renderer
local screen = vector(client.screen_size())
render.frame_count = 0
render.frame_string = 0

math.exploit = function ()
    local me = entity.get_local_player()
    if not me then return end
    local tickcount = globals.tickcount()
    local tickbase = entity.get_prop(me, 'm_nTickBase')
    return tickcount > tickbase
end

render.get_frame = function ( sel, answer )
    render.frame_count = 0.9 * render.frame_count + 0.1 * globals.absoluteframetime()
    if globals.tickcount() % sel == 1 then
        render.frame_string = tostring(1 / render.frame_count)
    end

    if answer == 'string' then
        return math.floor(render.frame_string)
    elseif answer == 'count' then
        return math.floor(render.frame_count)
    end
end

render.round_rect = function (x, y, width, height, radius, r, g, b, a)
    local top_left_x, top_left_y = x + radius, y + radius
    local top_right_x, top_right_y = x + width - radius, y + radius
    local bottom_left_x, bottom_left_y = x + radius, y + height - radius
    local bottom_right_x, bottom_right_y = x + width - radius, y + height - radius

    -- circle
    render.circle(top_left_x, top_left_y, r, g, b, a, radius, 180, 0.25)         -- up left
    render.circle(top_right_x, top_right_y, r, g, b, a, radius, 90, 0.25)        -- up right
    render.circle(bottom_left_x, bottom_left_y, r, g, b, a, radius, 270, 0.25)   -- down left
    render.circle(bottom_right_x, bottom_right_y, r, g, b, a, radius, 0, 0.25)   -- down right

    -- rect
    render.rectangle(x + radius, y, width - radius * 2, radius, r, g, b, a)                    -- up
    render.rectangle(x + radius, y + height - radius, width - radius * 2, radius, r, g, b, a)  -- down
    render.rectangle(x, y + radius, radius, height - radius * 2, r, g, b, a)                   -- left
    render.rectangle(x + width - radius, y + radius, radius, height - radius * 2, r, g, b, a)  -- right

    render.rectangle(x + radius, y + radius, width - radius * 2, height - radius * 2, r, g, b, a)
end

render.shadow = function(x, y, width, height, radius, glow_size, r, g, b, a)
    for i = glow_size, 1, -1 do
        local alpha = a * (i / glow_size) * 0.6
        if alpha <= 0 then
            goto continue
        end
        render.round_rect(x - i, y - i, width + i * 2, height + i * 2, radius, r, g, b, alpha)
    end

    render.round_rect(x, y, width, height, radius, r, g, b, a)
    ::continue::
end
--#endregion

--#region lua.sounds
local function bind_signature(module, interface, signature, typestring)
    local interface = client.create_interface(module, interface) or error('invalid interface', 2)
    local instance = client.find_signature(module, signature) or error('invalid signature', 2)
    local success, typeof = pcall(ffi.typeof, typestring)
    if not success then
        error(typeof, 2)
    end
    local fnptr = ffi.cast(typeof, instance) or error('invalid typecast', 2)
    return function(...)
        return fnptr(interface, ...)
    end
end

local function vmt_entry(instance, index, type)
	return ffi.cast(type, (ffi.cast('void***', instance)[0])[index])
end

local function vmt_bind(module, interface, index, typestring)
	local instance = client.create_interface(module, interface) or error('invalid interface')
	local success, typeof = pcall(ffi.typeof, typestring)
	if not success then
		error(typeof, 2)
	end
	local fnptr = vmt_entry(instance, index, typeof) or error('invalid vtable')
	return function(...)
		return fnptr(instance, ...)
	end
end

local int_ptr	   = ffi.typeof('int[1]')
local char_buffer   = ffi.typeof('char[?]')

local find_first	= bind_signature('filesystem_stdio.dll', 'VFileSystem017', '\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D', 'const char*(__thiscall*)(void*, const char*, const char*, int*)')
local find_next	 = bind_signature('filesystem_stdio.dll', 'VFileSystem017', '\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC', 'const char*(__thiscall*)(void*, int)')
local find_close	= bind_signature('filesystem_stdio.dll', 'VFileSystem017', '\x55\x8B\xEC\x53\x8B\x5D\x08\x85', 'void(__thiscall*)(void*, int)')

local current_directory = bind_signature('filesystem_stdio.dll', 'VFileSystem017', '\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C', 'bool(__thiscall*)(void*, char*, int)')
local add_to_searchpath = bind_signature('filesystem_stdio.dll', 'VFileSystem017', '\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x56\x57', 'void(__thiscall*)(void*, const char*, const char*, int)')
local find_is_directory = bind_signature('filesystem_stdio.dll', 'VFileSystem017', '\x55\x8B\xEC\x0F\xB7\x45\x08', 'bool(__thiscall*)(void*, int)')
local surface_playsound = vmt_bind('vguimatsurface.dll', 'VGUI_Surface031', 82, 'void(__thiscall*)(void*, const char*)')

lua.sounds = {} do
    lua.sounds.sound_names = {}
    lua.sounds.sound_name_to_file = {}
    lua.sounds.collect_files = function ()
        local files = {}
        local file_handle = int_ptr()
        local file = find_first('*', 'XGAME', file_handle)
        while file ~= nil do
            local file_name = ffi.string(file)
            if find_is_directory(file_handle[0]) == false and (file_name:find('.mp3') or file_name:find('.wav')) then
                files[#files+1] = file_name
            end
            file = find_next(file_handle[0])
        end
        find_close(file_handle[0])
        return files
    end
    lua.sounds.normalize_file_name = function (name)
        if name:find('_') then
            name = name:gsub('_', ' ')
        end
        if name:find('.mp3') then
            name = name:gsub('.mp3', '')
        end
        if name:find('.wav') then
            name = name:gsub('.wav', '')
        end
        return name
    end
    lua.sounds.play = function (sound, type)
        if type == true then
            surface_playsound(sound)
        else
            cvar.play:invoke_callback(sound)
        end
    end
    lua.sounds.set = function (struct, sounds)
        for i, n in pairs(struct) do
            n:set_callback(function()
                lua.sounds.play(sounds, false)
            end, true)
        end
    end
    lua.sounds.init_sound = function (sound_name, sound_file)
	    lua.sounds.sound_names[#lua.sounds.sound_names+1] = sound_name
	    lua.sounds.sound_name_to_file[sound_name] = sound_file
    end
end
--#endregion

--#region lerp
local mathematic = {} do
	local function linear(t, b, c, d)
		return c * t / d + b
	end

	local function get_deltatime()
		return globals.frametime()
	end

    mathematic.round = (function(num)
        if num % 1 >= 0.5 then
            return math.ceil(num)
        else
            return math.floor(num)
        end
    end)

    mathematic.normalize = function (x, min, max)
        local delta = max - min

        while x < min do
            x = x + delta
        end

        while x > max do
            x = x - delta
        end

        return x
    end

    mathematic.normalize_yaw = function (x)
        return mathematic.normalize(x, -180, 180)
    end

    mathematic.calc_angle = function (a, b)
        local x_delta = b.x - a.x
        local y_delta = b.y - a.y
        local z_delta = b.z - a.z 
        local hyp = math.sqrt(x_delta^2 + y_delta^2)
        local x = math.atan2(z_delta, hyp) * 57.295779513082
        local y = math.atan2(y_delta , x_delta) * 180 / 3.14159265358979323846
        return { x = mathematic.normalize_yaw(x, 90), y = mathematic.normalize_yaw(y, 180), z = 0 }
    end

	local function solve(easing_fn, prev, new, clock, duration)
		if clock <= 0 then return new end
		if clock >= duration then return new end

		prev = easing_fn(clock, prev, new - prev, duration)

		if type(prev) == 'number' then
			if math.abs(new - prev) < 0.001 then
				return new
			end

			local remainder = math.fmod(prev, 1.0)

			if remainder < 0.001 then
				return math.floor(prev)
			end

			if remainder > 0.999 then
				return math.ceil(prev)
			end
		end

		return prev
	end

	function mathematic.interp(a, b, t, easing_fn)
		easing_fn = easing_fn or linear

		if type(b) == 'boolean' then
			b = b and 1 or 0
		end

		return solve(easing_fn, a, b, get_deltatime(), t)
	end

    mathematic.interpolation = function(start, _end, time)
        return (_end - start) * time + start
    end

    mathematic.clamp = function(value, minimum, maximum)
        assert(value and minimum and maximum, '')
        if minimum > maximum then minimum, maximum = maximum, minimum end
        return math.max(minimum, math.min(maximum, value))
    end

    mathematic.hex_rgba = function(r, g, b, a)
        return bit.tohex(
        (math.floor(r + 0.5) * 16777216) + 
        (math.floor(g + 0.5) * 65536) + 
        (math.floor(b + 0.5) * 256) + 
        (math.floor(a + 0.5))
        )
    end

    mathematic.animate_text = function(time, string, r, g, b, a, r2, g2, b2, a2)
        local t_out, t_out_iter = { }, 1

        local l = string:len( ) - 1

        local r_add = (r2 - r)
        local g_add = (g2 - g)
        local b_add = (b2 - b)
        local a_add = (a2 - a)

        for i = 1, #string do
            local iter = (i - 1)/(#string - 1) + time
            t_out[t_out_iter] = '\a' .. mathematic.hex_rgba( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )

            t_out[t_out_iter + 1] = string:sub( i, i )

            t_out_iter = t_out_iter + 2
        end

        return t_out
    end

    mathematic.lerp = function(start, _end, time)
        time = time or 0.005
        time = mathematic.clamp(globals.frametime() * time * 175.0, 0.01, 1.0)
        local a = mathematic.interpolation(start, _end, time)
        if _end == 0.0 and a < 0.01 and a > -0.01 then
            a = 0.0
        elseif _end == 1.0 and a < 1.01 and a > 0.99 then
            a = 1.0
        end
        return a
    end
    function mathematic.lerp_color(r1, g1, b1, a1, r2, g2, b2, a2, t)
		local r = mathematic.lerp(r1, r2, t)
		local g = mathematic.lerp(g1, g2, t)
		local b = mathematic.lerp(b1, b2, t)
		local a = mathematic.lerp(a1, a2, t)

		return r, g, b, a
	end
end
--#endregion

--#region lua.helps
lua.helps = {} do
    --#region lua.helps.exploits
    lua.helps.exploits = {}
    lua.helps.exploits.max_tickbase = 0
    lua.helps.exploits.ticks = 0
    lua.helps.additions = {}
    lua.helps.exploits.is_peeking = function ()
        local me = entity.get_local_player()
        if not me then return end
        local enemies = entity.get_players(true)
        if not enemies then
            return false
        end

        local predict_amt = 0.25
        local eye_position = vector(client.eye_position())
        local velocity_prop_local = vector(entity.get_prop(me, 'm_vecVelocity'))
        local predicted_eye_position = vector(eye_position.x + velocity_prop_local.x * predict_amt, eye_position.y + velocity_prop_local.y * predict_amt, eye_position.z + velocity_prop_local.z * predict_amt)
        for i = 1, #enemies do
            local player = enemies[i]
            local velocity_prop = vector(entity.get_prop(player, 'm_vecVelocity'))
            local origin = vector(entity.get_prop(player, 'm_vecOrigin'))
            local predicted_origin = vector(origin.x + velocity_prop.x * predict_amt, origin.y + velocity_prop.y * predict_amt, origin.z + velocity_prop.z * predict_amt)
            entity.get_prop(player, 'm_vecOrigin', predicted_origin)
            local head_origin = vector(entity.hitbox_position(player, 0))
            local predicted_head_origin = vector(head_origin.x + velocity_prop.x * predict_amt, head_origin.y + velocity_prop.y * predict_amt, head_origin.z + velocity_prop.z * predict_amt)
            local trace_entity, damage = client.trace_bullet(me, predicted_eye_position.x, predicted_eye_position.y, predicted_eye_position.z, predicted_head_origin.x, predicted_head_origin.y, predicted_head_origin.z)
            entity.get_prop( player, 'm_vecOrigin', origin )
            if damage > 0 then
                return true
            end
        end
        return false
    end
    lua.helps.exploits.ping = function ()
        local me = entity.get_local_player()
        if not me then return end
        local resource = entity.get_player_resource(me)
        if not resource then return end

        local ping = entity.get_prop(resource, 'm_iPing', me)
        return ping
    end
    lua.helps.exploits.defensive = function ()
        local me = entity.get_local_player()
        if not me then return end
        local tickcount = globals.tickcount()
        local tickbase = entity.get_prop(me, 'm_nTickBase')

        if math.abs(tickbase - lua.helps.exploits.max_tickbase) > 64 then
            lua.helps.exploits.max_tickbase = 0
        end

        if tickbase > lua.helps.exploits.max_tickbase then
            lua.helps.exploits.max_tickbase = tickbase
        elseif lua.helps.exploits.max_tickbase > tickbase then
            lua.helps.exploits.ticks = math.min(14, math.max(0, lua.helps.exploits.max_tickbase - tickbase - 1))
        end
        if lua.helps.exploits.ticks == nil then return 0 end
        return math.exploit and lua.helps.exploits.ticks or 0
    end
    lua.helps.exploits.get_freestand = function(p, a)
        if not p then return false end
        if not a then return false end

        local is_dynamic = lua.reference.antiaim.angles.yaw_base:get() == 'At targets'
        local player_origin = vector(entity.get_origin(p))
        local ent_origin = vector(entity.get_origin(a))
        local yaw_base = is_dynamic and mathematic.calc_angle(player_origin, ent_origin).y or vector(client.camera_angles()).y
        local yaw = yaw_base + lua.reference.antiaim.angles.yaw[2]:get()
        local fs_yaw = mathematic.normalize_yaw(entity.get_prop(p, 'm_angEyeAngles[1]') - 180, 180)
        local diff = math.abs(yaw - fs_yaw)
        local is_fs = diff > 50 and diff < 300
    
        return is_fs
    end
    lua.helps.exploits.get_freestand_direction = function(p)
        local data = {
            side = 1,
            last_side = 0,
            last_hit = 0,
            hit_side = 0
        }
    
        if not p or entity.get_prop(p, 'm_lifeState') ~= 0 then
            return
        end
    
        if data.hit_side ~= 0 and globals.curtime() - data.last_hit > 5 then
            data.last_side = 0
            data.last_hit = 0
            data.hit_side = 0
        end
    
        local eye = vector(client.eye_position())
        local ang = vector(client.camera_angles())
        local trace_data = {left = 0, right = 0}
    
        for i = ang.y - 120, ang.y + 120, 30 do
            if i ~= ang.y then
                local rad = math.rad(i)
                local px, py, pz = eye.x + 256 * math.cos(rad), eye.y + 256 * math.sin(rad), eye.z
                local fraction = client.trace_line(p, eye.x, eye.y, eye.z, px, py, pz)
                local side = i < ang.y and 'left' or 'right'
                trace_data[side] = trace_data[side] + fraction
            end
        end

        data.side = trace_data.left < trace_data.right and -1 or 1
    
        if data.side == data.last_side then
            return
        end
    
        data.last_side = data.side
    
        if data.hit_side ~= 0 then
            data.side = data.hit_side
        end
    
        return data.side
    end
    lua.helps.exploits.get_maximum_usrcmd_ticks = function (wish_ticks)
        local game_rules = entity.get_game_rules()
        local is_valve_ds =
            entity.get_prop(game_rules, 'm_bIsValveDS') == 1 or
            entity.get_prop(game_rules, 'm_bIsQueuedMatchmaking') == 1
    
        local _iTicksAllowed = is_valve_ds and 6 or lua.reference.rage.binds.usercmd:get() - 2
    
        return wish_ticks and math.min(_iTicksAllowed, wish_ticks) or _iTicksAllowed
    end
    lua.helps.additions.normalize = function (x, min, max)
        local delta = max - min;

        while x < min do
            x = x + delta;
        end

        while x > max do
            x = x - delta;
        end

        return x;
    end
    lua.helps.additions.normalize_yaw = function (x)
        return lua.helps.additions.normalize(x, -180, 180);
    end

    client.set_event_callback('level_init', function() lua.helps.exploits.max_tickbase, lua.helps.exploits.ticks = 0, 0 end)
    --#endregion
end
--#endregion

--#region lua.pui
lua.pui = {} do
    lua.pui.ui = {}

    pui.macros.name_lua = '\bFFFFFF90\bA1A1A190[Antarctica ~ Debug]'
    pui.macros.color_tabs = '\aA1A1A190'
    pui.macros.color_start = '\aFFFFFF90'
    pui.macros.color_sad = '\aA1A1FFFF'
    pui.macros.color_ref = '\aA5A5A5FF'

    lua.sounds.contract = 'ui/csgo_ui_contract_type1'
    lua.sounds.init_sound( 'Switch 3D', 'buttons/light_power_on_switch_01')
    lua.sounds.init_sound( 'Senko', 'survival/paradrop_idle_01.wav')
    lua.sounds.init_sound( 'Menu', 'ui/csgo_ui_contract_type1')
    lua.sounds.init_sound( 'Strain', 'physics/wood/wood_strain7')
    lua.sounds.init_sound( 'Stop', 'doors/wood_stop1')
    lua.sounds.init_sound( 'Impact', 'physics/wood/wood_plank_impact_hard4')
    lua.sounds.init_sound( 'Warning', 'resource/warning')

    local current_path = char_buffer(128)
	current_directory(current_path, ffi.sizeof(current_path))
	current_path = string.format('%s/csgo/sound', ffi.string(current_path))
	add_to_searchpath(current_path, 'XGAME', 0)
	local sound_files = lua.sounds.collect_files()
	for i = 1, #sound_files do
		local file_name = sound_files[i]
		lua.sounds.init_sound(lua.sounds.normalize_file_name(file_name), string.format('%s', file_name))
	end

    lua.pui.ui.group = {
        main = pui.group('aa', 'anti-aimbot angles'),
        fake = pui.group('aa', 'fake lag'),
        other = pui.group('aa', 'other')
    }

    lua.pui.ui.search = {
        group = lua.pui.ui.group.main:combobox(' ' .. '\f<color_start> Antarctica \f<color_tabs> / \f<color_sad> Debug \n ~ Group', {'Home', 'Main', 'Other'}),
        tab = lua.pui.ui.group.main:combobox('\n ~ Selection', {'Builder', 'Antiaim', 'Features', 'World', 'Other'})
    }

    lua.pui.ui.antiaim = {
        manuals = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_tabs> Manuals'),
        manuall = lua.pui.ui.group.main:hotkey('\f<color_start> ~ ' .. '\f<color_ref> Manuals ' .. '\f<color_start> / ' ..  '\f<color_tabs> Left', false, 0),
        manualr = lua.pui.ui.group.main:hotkey('\f<color_start> ~ ' .. '\f<color_ref> Manuals ' .. '\f<color_start> / ' ..  '\f<color_tabs> Right', false, 0),
        manualf = lua.pui.ui.group.main:hotkey('\f<color_start> ~ ' .. '\f<color_ref> Manuals ' .. '\f<color_start> / ' ..  '\f<color_tabs> Forward', false, 0),
        manualb = lua.pui.ui.group.main:hotkey('\f<color_start> ~ ' .. '\f<color_ref> Manuals ' .. '\f<color_start> / ' ..  '\f<color_tabs> Back', false, 0),
        manualsr = lua.pui.ui.group.main:hotkey('\f<color_start> ~ ' .. '\f<color_ref> Manuals ' .. '\f<color_start> / ' ..  '\f<color_tabs> Reset', false, 0),
        freestand = lua.pui.ui.group.main:hotkey('\f<color_start> ~ ' .. '\f<color_ref> Manuals ' .. '\f<color_start> / ' ..  '\f<color_tabs> Freestand', false, 0)
    }

    lua.pui.onground = false
    lua.pui.ticks = -1
    lua.pui.state = 'Regular'
    lua.pui.condition_names = {'Regular', 'Numb', 'Push', 'Crawling', 'Crouch', 'Ð¡reeping', 'Aerobic', 'Aerobic+', 'Using', 'Freestand', 'Manual Left', 'Manual Right', 'Manual Back', 'Manual Forward'}
    lua.pui.ui.conditions = {}
    lua.pui.ui.state = lua.pui.ui.group.main:combobox('\f<color_start> ~ ' .. '\f<color_tabs> Condition', 'Regular', 'Numb', 'Push', 'Crawling', 'Crouch', 'Ð¡reeping', 'Aerobic', 'Aerobic+', 'Using', 'Freestand', 'Manual Left', 'Manual Right', 'Manual Back', 'Manual Forward')
    lua.pui.ui.state:set_callback(function()
        lua.sounds.play(lua.sounds.contract, false)
    end, true)
    for i, name in pairs(lua.pui.condition_names) do
        lua.pui.ui.conditions[name] = {
            override = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Override '),
            yaw = lua.pui.ui.group.main:slider('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Yaw ', -180, 180, 0),
            yaw_lr = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Left / Right '),
            yaw_l = lua.pui.ui.group.main:slider('\n\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Left', -90, 90, 0),
            yaw_r = lua.pui.ui.group.main:slider('\n\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Right ', -90, 90, 0),
            yaw_multi = lua.pui.ui.group.main:multiselect('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Modifier ', {'Offset', 'Center', 'Random', 'Spray'}),
            yaw_multi_s = lua.pui.ui.group.main:slider('\n\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Modifier Slide', 0, 60, 0),
            lby = lua.pui.ui.group.main:combobox('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Body Yaw ', {'Off', 'Static', 'Ticks', 'Random Ticks'}),
            lby_yaw = lua.pui.ui.group.main:slider('\n\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Body Value ', 0, 60, 1),
            tick = lua.pui.ui.group.main:slider('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Delay ', 1, 15, 1),
            defensive = lua.pui.ui.group.fake:combobox('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Defensive ', {'Off', 'On Peek', 'Always', 'Flick'}),
            defensive_aa_on = lua.pui.ui.group.fake:checkbox('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Defensive Antiaim '),
            pitch_defensive_c = lua.pui.ui.group.fake:combobox('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Defensive Pitch', {'Default', 'Random'}),
            pitch_defensive_s = lua.pui.ui.group.fake:slider('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Defensive Pitch', -89, 89, 0),
            yawd_defensive_s = lua.pui.ui.group.fake:slider('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Defensive Yaw', 0, 180, 0),
            yaw_defensive = lua.pui.ui.group.fake:multiselect('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Defensive Modifier ', {'Offset', 'Center', 'Random', 'Spin'}),
            yaw_defensive_s = lua.pui.ui.group.fake:slider('\n\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Defensive Modifier Slide', 0, 180, 0),
            defensive_minus = lua.pui.ui.group.other:slider('\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Defensive Minus & Plus', 0, 5, 3),
            defensive_plus = lua.pui.ui.group.other:slider('\n\f<color_start> ~ ' .. '\f<color_ref> ' ..name .. ' \f<color_start> / ' .. '\f<color_tabs> Defensive Plus', 0, 14, 11),
        }
        lua.sounds.set(lua.pui.ui.conditions[name], lua.sounds.contract)
    end
    lua.pui.ui.conditions['Manual Left'].yaw:set(-90)
    lua.pui.ui.conditions['Manual Right'].yaw:set(90)
    lua.pui.ui.conditions['Manual Forward'].yaw:set(180)

    lua.pui.ui.home = {
        server = lua.pui.ui.group.main:button('\f<color_tabs> Antarctica server', function ()
            panorama.open().SteamOverlayAPI.OpenExternalBrowserURL('https://dsc.gg/antariusgg')
        end),
        antxjav = lua.pui.ui.group.main:label('\f<color_tabs> Antarctica' .. '\f<color_start> ~ ' .. '\f<color_tabs> @javasense')
    }

    lua.pui.ui.animations = {
        animations_select = lua.pui.ui.group.main:multiselect('\f<color_start> ~ ' .. '\f<color_tabs> Animations', {'Aerobic', 'Ground', 'Lean', 'Additive'}):depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Features'}),
        aerobic = lua.pui.ui.group.main:combobox('\f<color_start> ~ ' .. '\f<color_ref> Animations ' .. '\f<color_start> / ' .. '\f<color_tabs> Aerobic', {'Quadrobic', 'Static', 'Jitter', 'Trap', 'Swag', 'Walking'}),
        ground = lua.pui.ui.group.main:combobox('\f<color_start> ~ ' .. '\f<color_ref> Animations ' .. '\f<color_start> / ' .. '\f<color_tabs> Ground', {'Static', 'Static invert', 'Jitter', 'Trap', 'Swag', 'Freeze', 'Freeze & Static', 'Freeze & Static invert', 'Bugged'}),
        lean = lua.pui.ui.group.main:combobox('\f<color_start> ~ ' .. '\f<color_ref> Animations ' .. '\f<color_start> / ' .. '\f<color_tabs> Lean', {'Zero', 'Big', 'Jitter'}),
        other = lua.pui.ui.group.main:multiselect('\f<color_start> ~ ' .. '\f<color_ref> Animations ' .. '\f<color_start> / ' .. '\f<color_tabs> Additive', {'2021 animfix', 'Model scale', 'Autopeek fix', 'Animation smooth', 'Flashed', 'Zero pitch'})
    }

    lua.pui.ui.render = {
        panels_select = lua.pui.ui.group.main:multiselect('\f<color_start> ~ ' .. '\f<color_tabs> Widgets', {'Indicator', 'Damage', 'Hitmarker', 'Gamesense', 'Graph'--[[, 'Watermark', 'Binds']]}):depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Features'}),
        indicator = lua.pui.ui.group.main:multiselect('\f<color_start> ~ ' .. '\f<color_tabs> Indicator', {'Scope', 'Resume', 'Grenade'}),
        indicatorcol = lua.pui.ui.group.main:color_picker('\n ~ Indicator color', 155, 155, 155, 255),
        indicatorcol2 = lua.pui.ui.group.main:color_picker('\n ~ Indicator color 2', 100, 100, 255, 255),
        graph = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_tabs> Graph', {120, 160, 80})
    }

    lua.pui.ui.aspectratio_info = {[177] = '16:9',[161] = '16:10',[150] = '3:2',[133] = '4:3',[125] = '5:4'}
    lua.pui.ui.world = {
        world_manager = lua.pui.ui.group.main:multiselect('\f<color_start> ~ ' .. '\f<color_tabs> Selection \n world', {'Flashlight', 'Local Sharing', 'Hands Dragging', 'View Dragging'}):depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}),
        flashlight_v = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_ref> Flashlight ' .. '\f<color_start> / ' .. '\f<color_tabs> Visible'),
        flashlight = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_tabs> Flashlight'),
        me_sharing_v = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_ref> Local Sharing ' .. '\f<color_start> / ' .. '\f<color_tabs> Visible'),
        me_sharing = lua.pui.ui.group.main:combobox('\n ~ Local Sharing', {'Static', 'Dragging'}),
        me_sharingcol = lua.pui.ui.group.main:color_picker('\n ~ Local Sharing color', 255, 0, 0, 255),
        handdrag_v = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_ref> Hands Dragging ' .. '\f<color_start> / ' .. '\f<color_tabs> Visible'),
        hands_drag = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_tabs> Hands Changer'),
        hand_fov = lua.pui.ui.group.main:slider('\f<color_start> ~ ' .. '\f<color_ref> Hands ' .. '\f<color_start> / ' .. '\f<color_tabs> FOV', -90, 90, cvar.viewmodel_fov:get_float()),
        hand_x = lua.pui.ui.group.main:slider('\f<color_start> ~ ' .. '\f<color_ref> Hands ' .. '\f<color_start> / ' .. '\f<color_tabs> X', -1000, 1000, cvar.viewmodel_offset_x:get_float(), true, '', 0.01),
        hand_y = lua.pui.ui.group.main:slider('\f<color_start> ~ ' .. '\f<color_ref> Hands ' .. '\f<color_start> / ' .. '\f<color_tabs> Y', -1000, 1000, cvar.viewmodel_offset_y:get_float(), true, '', 0.01),
        hand_z = lua.pui.ui.group.main:slider('\f<color_start> ~ ' .. '\f<color_ref> Hands ' .. '\f<color_start> / ' .. '\f<color_tabs> Z', -1000, 1000, cvar.viewmodel_offset_z:get_float(), true, '', 0.01),
        viewdrag_v = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_ref> View Dragging ' .. '\f<color_start> / ' .. '\f<color_tabs> Visible'),
        custom_scope = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_tabs> Custom scope', {155, 155, 155}),
        custom_scope_position = lua.pui.ui.group.main:slider('\f<color_start> ~ ' .. '\f<color_ref> Scope ' .. '\f<color_start> / ' .. '\f<color_tabs> Position', 5, 500, 90),
        custom_scope_offset = lua.pui.ui.group.main:slider('\f<color_start> ~ ' .. '\f<color_ref> Scope ' .. '\f<color_start> / ' .. '\f<color_tabs> Offset', 3, 500, 3),
        custom_scope_fade = lua.pui.ui.group.main:slider('\f<color_start> ~ ' .. '\f<color_ref> Scope ' .. '\f<color_start> / ' .. '\f<color_tabs> Fade time', 3, 20, 12, true, 'fr', 1, { [3] = 'Off' }),
        zoom_scale = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_tabs> Zoom scaling'),
        zoom_offset = lua.pui.ui.group.main:slider('\f<color_start> ~ ' .. '\f<color_ref> Zoom ' .. '\f<color_start> / ' .. '\f<color_tabs> Offset', -25, 60, 0),
        thirdperson = lua.pui.ui.group.main:slider('\f<color_start> ~ ' .. '\f<color_ref> Thirdperson ' .. '\f<color_start> / ' .. '\f<color_tabs> Distance', 35, 300, cvar.cam_idealdist:get_int()),
        thirdperson_anim = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_ref> Thirdperson ' .. '\f<color_start> / ' .. '\f<color_tabs> Animation'),
        aspectratio = lua.pui.ui.group.main:slider('\f<color_start> ~ ' .. '\f<color_tabs> Aspect Ratio', 0, 300, 0, true, '', 0.01, lua.pui.ui.aspectratio_info),
    }

    lua.pui.ui.additive = {
        other = lua.pui.ui.group.main:multiselect('\f<color_start> ~ ' .. '\f<color_tabs> Selection \n Additive', {'Sounds', 'Razpeek', 'Fast Ladder', 'Force Update', 'Clantag'}):depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Other'}),
        force_update = lua.pui.ui.group.main:button('\f<color_tabs>Force update', function() return client.request_full_update(), client.reload_active_scripts() end),
        sounds_check = lua.pui.ui.group.main:checkbox('\f<color_start> ~ ' .. '\f<color_tabs> Hitsound'),
        sounds_list = lua.pui.ui.group.main:combobox('\n \f<color_start> ~ ' .. '\f<color_tabs> Hitsound', lua.sounds.sound_names)
    }

    local config = {lua.pui.ui.conditions, lua.pui.ui.animations, lua.pui.ui.render, lua.pui.ui.world, lua.pui.ui.additive}
    local package, data, encrypted, decrypted = pui.setup(config)

    lua.pui.ui.export = function ()
        data = package:save()
        encrypted = base64.encode(json.stringify(data))
        clipboard.set(encrypted)
    end

    lua.pui.ui.import = function (input)
        decrypted = json.parse(base64.decode(input ~= nil and input or clipboard.get()))
        package:load(decrypted)
    end

    local cfg_beta = 'W3siQ3JvdWNoIjp7ImxieV95YXciOjEsImxieSI6IlJhbmRvbSBUaWNrcyIsInlhd19yIjowLCJwaXRjaF9kZWZlbnNpdmVfcyI6LTg5LCJ5YXdfbHIiOmZhbHNlLCJ5YXdfbCI6MCwiZGVmZW5zaXZlX21pbnVzIjozLCJkZWZlbnNpdmUiOiJGbGljayIsIm92ZXJyaWRlIjp0cnVlLCJkZWZlbnNpdmVfYWFfb24iOnRydWUsInlhd19kZWZlbnNpdmVfcyI6NjUsInRpY2siOjEsInlhdyI6MCwieWF3X211bHRpX3MiOjIwLCJ5YXdkX2RlZmVuc2l2ZV9zIjo5MCwieWF3X2RlZmVuc2l2ZSI6WyJDZW50ZXIiLCJSYW5kb20iLCJTcGluIiwifiJdLCJkZWZlbnNpdmVfcGx1cyI6MTEsInlhd19tdWx0aSI6WyJDZW50ZXIiLCJSYW5kb20iLCJ+Il19LCJQdXNoIjp7ImxieV95YXciOjEsImxieSI6IlJhbmRvbSBUaWNrcyIsInlhd19yIjowLCJwaXRjaF9kZWZlbnNpdmVfcyI6LTIyLCJ5YXdfbHIiOmZhbHNlLCJ5YXdfbCI6MCwiZGVmZW5zaXZlX21pbnVzIjozLCJkZWZlbnNpdmUiOiJPbiBQZWVrIiwib3ZlcnJpZGUiOnRydWUsImRlZmVuc2l2ZV9hYV9vbiI6dHJ1ZSwieWF3X2RlZmVuc2l2ZV9zIjoyNSwidGljayI6MSwieWF3IjowLCJ5YXdfbXVsdGlfcyI6MjUsInlhd2RfZGVmZW5zaXZlX3MiOjEwMCwieWF3X2RlZmVuc2l2ZSI6WyJSYW5kb20iLCJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIkNlbnRlciIsIlJhbmRvbSIsIn4iXX0sIk1hbnVhbCBGb3J3YXJkIjp7ImxieV95YXciOjEsImxieSI6Ik9mZiIsInlhd19yIjowLCJwaXRjaF9kZWZlbnNpdmVfcyI6MCwieWF3X2xyIjpmYWxzZSwieWF3X2wiOjAsImRlZmVuc2l2ZV9taW51cyI6MywiZGVmZW5zaXZlIjoiT2ZmIiwib3ZlcnJpZGUiOmZhbHNlLCJkZWZlbnNpdmVfYWFfb24iOmZhbHNlLCJ5YXdfZGVmZW5zaXZlX3MiOjAsInRpY2siOjEsInlhdyI6MTgwLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIkFlcm9iaWMrIjp7ImxieV95YXciOjEsImxieSI6IlRpY2tzIiwieWF3X3IiOjAsInBpdGNoX2RlZmVuc2l2ZV9zIjotODksInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6IkZsaWNrIiwib3ZlcnJpZGUiOnRydWUsImRlZmVuc2l2ZV9hYV9vbiI6dHJ1ZSwieWF3X2RlZmVuc2l2ZV9zIjoxNTAsInRpY2siOjEsInlhdyI6MCwieWF3X211bHRpX3MiOjMwLCJ5YXdkX2RlZmVuc2l2ZV9zIjowLCJ5YXdfZGVmZW5zaXZlIjpbIkNlbnRlciIsIlJhbmRvbSIsIlNwaW4iLCJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIkNlbnRlciIsIn4iXX0sIkNyYXdsaW5nIjp7ImxieV95YXciOjEsImxieSI6IlRpY2tzIiwieWF3X3IiOjgsInBpdGNoX2RlZmVuc2l2ZV9zIjowLCJ5YXdfbHIiOnRydWUsInlhd19sIjotMTQsImRlZmVuc2l2ZV9taW51cyI6MywiZGVmZW5zaXZlIjoiRmxpY2siLCJvdmVycmlkZSI6dHJ1ZSwiZGVmZW5zaXZlX2FhX29uIjpmYWxzZSwieWF3X2RlZmVuc2l2ZV9zIjowLCJ0aWNrIjo1LCJ5YXciOjAsInlhd19tdWx0aV9zIjoyNywieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIlJhbmRvbSIsIn4iXX0sIkZyZWVzdGFuZCI6eyJsYnlfeWF3IjoxLCJsYnkiOiJPZmYiLCJ5YXdfciI6MCwicGl0Y2hfZGVmZW5zaXZlX3MiOjAsInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6Ik9mZiIsIm92ZXJyaWRlIjpmYWxzZSwiZGVmZW5zaXZlX2FhX29uIjpmYWxzZSwieWF3X2RlZmVuc2l2ZV9zIjowLCJ0aWNrIjoxLCJ5YXciOjAsInlhd19tdWx0aV9zIjowLCJ5YXdkX2RlZmVuc2l2ZV9zIjowLCJ5YXdfZGVmZW5zaXZlIjpbIn4iXSwiZGVmZW5zaXZlX3BsdXMiOjExLCJ5YXdfbXVsdGkiOlsifiJdfSwiTnVtYiI6eyJsYnlfeWF3IjoxLCJsYnkiOiJSYW5kb20gVGlja3MiLCJ5YXdfciI6MCwicGl0Y2hfZGVmZW5zaXZlX3MiOjAsInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6Ik9mZiIsIm92ZXJyaWRlIjp0cnVlLCJkZWZlbnNpdmVfYWFfb24iOmZhbHNlLCJ5YXdfZGVmZW5zaXZlX3MiOjAsInRpY2siOjEsInlhdyI6MCwieWF3X211bHRpX3MiOjE4LCJ5YXdkX2RlZmVuc2l2ZV9zIjowLCJ5YXdfZGVmZW5zaXZlIjpbIn4iXSwiZGVmZW5zaXZlX3BsdXMiOjExLCJ5YXdfbXVsdGkiOlsiT2Zmc2V0IiwiQ2VudGVyIiwiUmFuZG9tIiwifiJdfSwiTWFudWFsIEJhY2siOnsibGJ5X3lhdyI6MSwibGJ5IjoiT2ZmIiwieWF3X3IiOjAsInBpdGNoX2RlZmVuc2l2ZV9zIjowLCJ5YXdfbHIiOmZhbHNlLCJ5YXdfbCI6MCwiZGVmZW5zaXZlX21pbnVzIjozLCJkZWZlbnNpdmUiOiJPZmYiLCJvdmVycmlkZSI6ZmFsc2UsImRlZmVuc2l2ZV9hYV9vbiI6ZmFsc2UsInlhd19kZWZlbnNpdmVfcyI6MCwidGljayI6MSwieWF3IjowLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIk1hbnVhbCBMZWZ0Ijp7ImxieV95YXciOjEsImxieSI6Ik9mZiIsInlhd19yIjowLCJwaXRjaF9kZWZlbnNpdmVfcyI6MCwieWF3X2xyIjpmYWxzZSwieWF3X2wiOjAsImRlZmVuc2l2ZV9taW51cyI6MywiZGVmZW5zaXZlIjoiT2ZmIiwib3ZlcnJpZGUiOmZhbHNlLCJkZWZlbnNpdmVfYWFfb24iOmZhbHNlLCJ5YXdfZGVmZW5zaXZlX3MiOjAsInRpY2siOjEsInlhdyI6LTkwLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIk1hbnVhbCBSaWdodCI6eyJsYnlfeWF3IjoxLCJsYnkiOiJPZmYiLCJ5YXdfciI6MCwicGl0Y2hfZGVmZW5zaXZlX3MiOjAsInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6Ik9mZiIsIm92ZXJyaWRlIjpmYWxzZSwiZGVmZW5zaXZlX2FhX29uIjpmYWxzZSwieWF3X2RlZmVuc2l2ZV9zIjowLCJ0aWNrIjoxLCJ5YXciOjkwLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sItChcmVlcGluZyI6eyJsYnlfeWF3IjoxLCJsYnkiOiJPZmYiLCJ5YXdfciI6MCwicGl0Y2hfZGVmZW5zaXZlX3MiOjAsInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6Ik9mZiIsIm92ZXJyaWRlIjpmYWxzZSwiZGVmZW5zaXZlX2FhX29uIjpmYWxzZSwieWF3X2RlZmVuc2l2ZV9zIjowLCJ0aWNrIjoxLCJ5YXciOjAsInlhd19tdWx0aV9zIjowLCJ5YXdkX2RlZmVuc2l2ZV9zIjowLCJ5YXdfZGVmZW5zaXZlIjpbIn4iXSwiZGVmZW5zaXZlX3BsdXMiOjExLCJ5YXdfbXVsdGkiOlsifiJdfSwiUmVndWxhciI6eyJsYnlfeWF3Ijo2MCwibGJ5IjoiU3RhdGljIiwieWF3X3IiOjAsInBpdGNoX2RlZmVuc2l2ZV9zIjo4OSwieWF3X2xyIjpmYWxzZSwieWF3X2wiOjAsImRlZmVuc2l2ZV9taW51cyI6MywiZGVmZW5zaXZlIjoiRmxpY2siLCJvdmVycmlkZSI6ZmFsc2UsImRlZmVuc2l2ZV9hYV9vbiI6dHJ1ZSwieWF3X2RlZmVuc2l2ZV9zIjo5MCwidGljayI6MSwieWF3IjowLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJDZW50ZXIiLCJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIkFlcm9iaWMiOnsibGJ5X3lhdyI6NjAsImxieSI6IlRpY2tzIiwieWF3X3IiOi0xOSwicGl0Y2hfZGVmZW5zaXZlX3MiOi00NSwieWF3X2xyIjpmYWxzZSwieWF3X2wiOjE5LCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6IkFsd2F5cyIsIm92ZXJyaWRlIjp0cnVlLCJkZWZlbnNpdmVfYWFfb24iOnRydWUsInlhd19kZWZlbnNpdmVfcyI6NzAsInRpY2siOjIsInlhdyI6MCwieWF3X211bHRpX3MiOjM2LCJ5YXdkX2RlZmVuc2l2ZV9zIjo0NSwieWF3X2RlZmVuc2l2ZSI6WyJTcGluIiwifiJdLCJkZWZlbnNpdmVfcGx1cyI6MTEsInlhd19tdWx0aSI6WyJSYW5kb20iLCJ+Il19fSx7ImFlcm9iaWMiOiJUcmFwIiwiYW5pbWF0aW9uc19zZWxlY3QiOlsiQWVyb2JpYyIsIkdyb3VuZCIsIkxlYW4iLCJBZGRpdGl2ZSIsIn4iXSwibGVhbiI6IkppdHRlciIsIm90aGVyIjpbIkF1dG9wZWVrIGZpeCIsIkFuaW1hdGlvbiBzbW9vdGgiLCJ+Il0sImdyb3VuZCI6IlN3YWcifSx7ImluZGljYXRvcmNvbDIiOiIjNjQ2NEZGRkYiLCJpbmRpY2F0b3IiOlsiU2NvcGUiLCJHcmVuYWRlIiwifiJdLCJncmFwaCI6ZmFsc2UsImluZGljYXRvcmNvbCI6IiNGRkZGRkZGRiIsImdyYXBoX2MiOiIjNzhBMDUwRkYiLCJwYW5lbHNfc2VsZWN0IjpbIkluZGljYXRvciIsIn4iXX0seyJoYW5kZHJhZ192IjpmYWxzZSwidGhpcmRwZXJzb24iOjY5LCJjdXN0b21fc2NvcGVfcG9zaXRpb24iOjkwLCJmbGFzaGxpZ2h0IjpmYWxzZSwidmlld2RyYWdfdiI6ZmFsc2UsImN1c3RvbV9zY29wZV9mYWRlIjoxMiwiY3VzdG9tX3Njb3BlX29mZnNldCI6Mywiem9vbV9zY2FsZSI6ZmFsc2UsInRoaXJkcGVyc29uX2FuaW0iOmZhbHNlLCJtZV9zaGFyaW5nX3YiOmZhbHNlLCJoYW5kX3oiOi0xLCJoYW5kX3giOjEsImN1c3RvbV9zY29wZSI6ZmFsc2UsIndvcmxkX21hbmFnZXIiOlsifiJdLCJhc3BlY3RyYXRpbyI6MCwiZmxhc2hsaWdodF92IjpmYWxzZSwiaGFuZF9mb3YiOjU2LCJoYW5kc19kcmFnIjpmYWxzZSwiY3VzdG9tX3Njb3BlX2MiOiIjOUI5QjlCRkYiLCJtZV9zaGFyaW5nY29sIjoiI0ZGMDAwMEZGIiwiaGFuZF95IjotNCwibWVfc2hhcmluZyI6IlN0YXRpYyIsInpvb21fb2Zmc2V0IjowfSx7InNvdW5kc19saXN0IjoiU3dpdGNoIDNEIiwic291bmRzX2NoZWNrIjpmYWxzZSwib3RoZXIiOlsifiJdfV0='
    local cfg_agr = 'W3siQ3JvdWNoIjp7ImxieV95YXciOjEsImxieSI6IlRpY2tzIiwieWF3X3IiOjUwLCJwaXRjaF9kZWZlbnNpdmVfcyI6LTg5LCJ5YXdfbHIiOnRydWUsInlhd19sIjotMzIsImRlZmVuc2l2ZV9taW51cyI6MywiZGVmZW5zaXZlIjoiRmxpY2siLCJvdmVycmlkZSI6dHJ1ZSwiZGVmZW5zaXZlX2FhX29uIjp0cnVlLCJ5YXdfZGVmZW5zaXZlX3MiOjgxLCJ0aWNrIjoyLCJ5YXciOjAsInlhd19tdWx0aV9zIjowLCJ5YXdkX2RlZmVuc2l2ZV9zIjozNywieWF3X2RlZmVuc2l2ZSI6WyJDZW50ZXIiLCJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIlB1c2giOnsibGJ5X3lhdyI6MSwibGJ5IjoiVGlja3MiLCJ5YXdfciI6MzcsInBpdGNoX2RlZmVuc2l2ZV9zIjowLCJ5YXdfbHIiOnRydWUsInlhd19sIjotMzIsImRlZmVuc2l2ZV9taW51cyI6MywiZGVmZW5zaXZlIjoiT24gUGVlayIsIm92ZXJyaWRlIjp0cnVlLCJkZWZlbnNpdmVfYWFfb24iOmZhbHNlLCJ5YXdfZGVmZW5zaXZlX3MiOjAsInRpY2siOjIsInlhdyI6MCwieWF3X211bHRpX3MiOjAsInlhd2RfZGVmZW5zaXZlX3MiOjAsInlhd19kZWZlbnNpdmUiOlsifiJdLCJkZWZlbnNpdmVfcGx1cyI6MTEsInlhd19tdWx0aSI6WyJ+Il19LCJNYW51YWwgRm9yd2FyZCI6eyJsYnlfeWF3IjoxLCJsYnkiOiJPZmYiLCJ5YXdfciI6MCwicGl0Y2hfZGVmZW5zaXZlX3MiOjAsInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6Ik9mZiIsIm92ZXJyaWRlIjpmYWxzZSwiZGVmZW5zaXZlX2FhX29uIjpmYWxzZSwieWF3X2RlZmVuc2l2ZV9zIjowLCJ0aWNrIjoxLCJ5YXciOjAsInlhd19tdWx0aV9zIjowLCJ5YXdkX2RlZmVuc2l2ZV9zIjowLCJ5YXdfZGVmZW5zaXZlIjpbIn4iXSwiZGVmZW5zaXZlX3BsdXMiOjExLCJ5YXdfbXVsdGkiOlsifiJdfSwiQWVyb2JpYysiOnsibGJ5X3lhdyI6MSwibGJ5IjoiVGlja3MiLCJ5YXdfciI6NDcsInBpdGNoX2RlZmVuc2l2ZV9zIjotNTksInlhd19sciI6dHJ1ZSwieWF3X2wiOi0zNSwiZGVmZW5zaXZlX21pbnVzIjozLCJkZWZlbnNpdmUiOiJBbHdheXMiLCJvdmVycmlkZSI6dHJ1ZSwiZGVmZW5zaXZlX2FhX29uIjp0cnVlLCJ5YXdfZGVmZW5zaXZlX3MiOjEwNiwidGljayI6MywieWF3IjowLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJSYW5kb20iLCJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIkNyYXdsaW5nIjp7ImxieV95YXciOjEsImxieSI6IlRpY2tzIiwieWF3X3IiOjAsInBpdGNoX2RlZmVuc2l2ZV9zIjotNDcsInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6Ik9uIFBlZWsiLCJvdmVycmlkZSI6dHJ1ZSwiZGVmZW5zaXZlX2FhX29uIjpmYWxzZSwieWF3X2RlZmVuc2l2ZV9zIjoxODAsInRpY2siOjEsInlhdyI6LTMsInlhd19tdWx0aV9zIjoxMCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJSYW5kb20iLCJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIkNlbnRlciIsIn4iXX0sIkZyZWVzdGFuZCI6eyJsYnlfeWF3IjowLCJsYnkiOiJTdGF0aWMiLCJ5YXdfciI6MCwicGl0Y2hfZGVmZW5zaXZlX3MiOjAsInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjAsImRlZmVuc2l2ZSI6Ik9uIFBlZWsiLCJvdmVycmlkZSI6dHJ1ZSwiZGVmZW5zaXZlX2FhX29uIjp0cnVlLCJ5YXdfZGVmZW5zaXZlX3MiOjM1LCJ0aWNrIjoxLCJ5YXciOjAsInlhd19tdWx0aV9zIjowLCJ5YXdkX2RlZmVuc2l2ZV9zIjoxMDAsInlhd19kZWZlbnNpdmUiOlsiUmFuZG9tIiwifiJdLCJkZWZlbnNpdmVfcGx1cyI6MTEsInlhd19tdWx0aSI6WyJ+Il19LCJOdW1iIjp7ImxieV95YXciOjEsImxieSI6IlRpY2tzIiwieWF3X3IiOjM5LCJwaXRjaF9kZWZlbnNpdmVfcyI6MCwieWF3X2xyIjp0cnVlLCJ5YXdfbCI6LTIxLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6Ik9mZiIsIm92ZXJyaWRlIjp0cnVlLCJkZWZlbnNpdmVfYWFfb24iOmZhbHNlLCJ5YXdfZGVmZW5zaXZlX3MiOjAsInRpY2siOjIsInlhdyI6MCwieWF3X211bHRpX3MiOjAsInlhd2RfZGVmZW5zaXZlX3MiOjAsInlhd19kZWZlbnNpdmUiOlsifiJdLCJkZWZlbnNpdmVfcGx1cyI6MTEsInlhd19tdWx0aSI6WyJ+Il19LCJNYW51YWwgQmFjayI6eyJsYnlfeWF3IjoxLCJsYnkiOiJPZmYiLCJ5YXdfciI6MCwicGl0Y2hfZGVmZW5zaXZlX3MiOjAsInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6Ik9mZiIsIm92ZXJyaWRlIjpmYWxzZSwiZGVmZW5zaXZlX2FhX29uIjpmYWxzZSwieWF3X2RlZmVuc2l2ZV9zIjowLCJ0aWNrIjoxLCJ5YXciOjAsInlhd19tdWx0aV9zIjowLCJ5YXdkX2RlZmVuc2l2ZV9zIjowLCJ5YXdfZGVmZW5zaXZlIjpbIn4iXSwiZGVmZW5zaXZlX3BsdXMiOjExLCJ5YXdfbXVsdGkiOlsifiJdfSwiTWFudWFsIExlZnQiOnsibGJ5X3lhdyI6NjAsImxieSI6IlN0YXRpYyIsInlhd19yIjowLCJwaXRjaF9kZWZlbnNpdmVfcyI6MCwieWF3X2xyIjpmYWxzZSwieWF3X2wiOjAsImRlZmVuc2l2ZV9taW51cyI6MywiZGVmZW5zaXZlIjoiT24gUGVlayIsIm92ZXJyaWRlIjp0cnVlLCJkZWZlbnNpdmVfYWFfb24iOnRydWUsInlhd19kZWZlbnNpdmVfcyI6MCwidGljayI6MSwieWF3IjotOTAsInlhd19tdWx0aV9zIjowLCJ5YXdkX2RlZmVuc2l2ZV9zIjo5MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIk1hbnVhbCBSaWdodCI6eyJsYnlfeWF3Ijo2MCwibGJ5IjoiU3RhdGljIiwieWF3X3IiOjAsInBpdGNoX2RlZmVuc2l2ZV9zIjowLCJ5YXdfbHIiOmZhbHNlLCJ5YXdfbCI6MCwiZGVmZW5zaXZlX21pbnVzIjozLCJkZWZlbnNpdmUiOiJPbiBQZWVrIiwib3ZlcnJpZGUiOnRydWUsImRlZmVuc2l2ZV9hYV9vbiI6dHJ1ZSwieWF3X2RlZmVuc2l2ZV9zIjowLCJ0aWNrIjoxLCJ5YXciOjkwLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6OTAsInlhd19kZWZlbnNpdmUiOlsifiJdLCJkZWZlbnNpdmVfcGx1cyI6MTEsInlhd19tdWx0aSI6WyJ+Il19LCLQoXJlZXBpbmciOnsibGJ5X3lhdyI6MSwibGJ5IjoiT2ZmIiwieWF3X3IiOjAsInBpdGNoX2RlZmVuc2l2ZV9zIjowLCJ5YXdfbHIiOmZhbHNlLCJ5YXdfbCI6MCwiZGVmZW5zaXZlX21pbnVzIjozLCJkZWZlbnNpdmUiOiJPZmYiLCJvdmVycmlkZSI6ZmFsc2UsImRlZmVuc2l2ZV9hYV9vbiI6ZmFsc2UsInlhd19kZWZlbnNpdmVfcyI6MCwidGljayI6MSwieWF3IjowLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIlJlZ3VsYXIiOnsibGJ5X3lhdyI6MCwibGJ5IjoiVGlja3MiLCJ5YXdfciI6MCwicGl0Y2hfZGVmZW5zaXZlX3MiOjAsInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6Ik9uIFBlZWsiLCJvdmVycmlkZSI6ZmFsc2UsImRlZmVuc2l2ZV9hYV9vbiI6ZmFsc2UsInlhd19kZWZlbnNpdmVfcyI6ODAsInRpY2siOjEsInlhdyI6MCwieWF3X211bHRpX3MiOjI1LCJ5YXdkX2RlZmVuc2l2ZV9zIjoxMDAsInlhd19kZWZlbnNpdmUiOlsifiJdLCJkZWZlbnNpdmVfcGx1cyI6MTEsInlhd19tdWx0aSI6WyJ+Il19LCJBZXJvYmljIjp7ImxieV95YXciOjEsImxieSI6IlRpY2tzIiwieWF3X3IiOjAsInBpdGNoX2RlZmVuc2l2ZV9zIjotODksInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6IkFsd2F5cyIsIm92ZXJyaWRlIjp0cnVlLCJkZWZlbnNpdmVfYWFfb24iOnRydWUsInlhd19kZWZlbnNpdmVfcyI6MTIwLCJ0aWNrIjoxLCJ5YXciOjUsInlhd19tdWx0aV9zIjo0MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJDZW50ZXIiLCJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIkNlbnRlciIsIn4iXX19LHsiYWVyb2JpYyI6IlN0YXRpYyIsImFuaW1hdGlvbnNfc2VsZWN0IjpbIkFlcm9iaWMiLCJHcm91bmQiLCJMZWFuIiwiQWRkaXRpdmUiLCJ+Il0sImxlYW4iOiJCaWciLCJvdGhlciI6WyJBdXRvcGVlayBmaXgiLCJBbmltYXRpb24gc21vb3RoIiwifiJdLCJncm91bmQiOiJTdGF0aWMgaW52ZXJ0In0seyJpbmRpY2F0b3Jjb2wyIjoiIzY0NjRGRkZGIiwiaW5kaWNhdG9yIjpbIlNjb3BlIiwiR3JlbmFkZSIsIn4iXSwiZ3JhcGgiOmZhbHNlLCJpbmRpY2F0b3Jjb2wiOiIjRkZGRkZGRkYiLCJncmFwaF9jIjoiIzc4QTA1MEZGIiwicGFuZWxzX3NlbGVjdCI6WyJEYW1hZ2UiLCJIaXRtYXJrZXIiLCJ+Il19LHsiaGFuZGRyYWdfdiI6dHJ1ZSwidGhpcmRwZXJzb24iOjY5LCJjdXN0b21fc2NvcGVfcG9zaXRpb24iOjkwLCJmbGFzaGxpZ2h0IjpmYWxzZSwidmlld2RyYWdfdiI6dHJ1ZSwiY3VzdG9tX3Njb3BlX2ZhZGUiOjEyLCJjdXN0b21fc2NvcGVfb2Zmc2V0Ijo2MCwiem9vbV9zY2FsZSI6ZmFsc2UsInRoaXJkcGVyc29uX2FuaW0iOmZhbHNlLCJtZV9zaGFyaW5nX3YiOmZhbHNlLCJoYW5kX3oiOi0xMzUsImhhbmRfeCI6MCwiY3VzdG9tX3Njb3BlIjp0cnVlLCJ3b3JsZF9tYW5hZ2VyIjpbIkhhbmRzIERyYWdnaW5nIiwiVmlldyBEcmFnZ2luZyIsIn4iXSwiYXNwZWN0cmF0aW8iOjAsImZsYXNobGlnaHRfdiI6ZmFsc2UsImhhbmRfZm92Ijo1OSwiaGFuZHNfZHJhZyI6dHJ1ZSwiY3VzdG9tX3Njb3BlX2MiOiIjOUI5QjlCRkYiLCJtZV9zaGFyaW5nY29sIjoiI0ZGMDAwMEZGIiwiaGFuZF95IjotMjAwLCJtZV9zaGFyaW5nIjoiRHJhZ2dpbmciLCJ6b29tX29mZnNldCI6NH0seyJzb3VuZHNfbGlzdCI6IkltcGFjdCIsInNvdW5kc19jaGVjayI6dHJ1ZSwib3RoZXIiOlsiU291bmRzIiwifiJdfV0='
    local cfg = 'W3siQ3JvdWNoIjp7ImxieV95YXciOjEsImxieSI6IlRpY2tzIiwieWF3X3IiOjUwLCJwaXRjaF9kZWZlbnNpdmVfcyI6MCwieWF3X2xyIjp0cnVlLCJ5YXdfbCI6LTMyLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6IkZsaWNrIiwib3ZlcnJpZGUiOnRydWUsImRlZmVuc2l2ZV9hYV9vbiI6ZmFsc2UsInlhd19kZWZlbnNpdmVfcyI6MCwidGljayI6MiwieWF3IjowLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIlB1c2giOnsibGJ5X3lhdyI6MSwibGJ5IjoiVGlja3MiLCJ5YXdfciI6MzcsInBpdGNoX2RlZmVuc2l2ZV9zIjowLCJ5YXdfbHIiOnRydWUsInlhd19sIjotMzIsImRlZmVuc2l2ZV9taW51cyI6MywiZGVmZW5zaXZlIjoiT24gUGVlayIsIm92ZXJyaWRlIjp0cnVlLCJkZWZlbnNpdmVfYWFfb24iOmZhbHNlLCJ5YXdfZGVmZW5zaXZlX3MiOjAsInRpY2siOjIsInlhdyI6MCwieWF3X211bHRpX3MiOjEwLCJ5YXdkX2RlZmVuc2l2ZV9zIjowLCJ5YXdfZGVmZW5zaXZlIjpbIn4iXSwiZGVmZW5zaXZlX3BsdXMiOjExLCJ5YXdfbXVsdGkiOlsiUmFuZG9tIiwifiJdfSwiTWFudWFsIEZvcndhcmQiOnsibGJ5X3lhdyI6MSwibGJ5IjoiT2ZmIiwieWF3X3IiOjAsInBpdGNoX2RlZmVuc2l2ZV9zIjowLCJ5YXdfbHIiOmZhbHNlLCJ5YXdfbCI6MCwiZGVmZW5zaXZlX21pbnVzIjozLCJkZWZlbnNpdmUiOiJPZmYiLCJvdmVycmlkZSI6ZmFsc2UsImRlZmVuc2l2ZV9hYV9vbiI6ZmFsc2UsInlhd19kZWZlbnNpdmVfcyI6MCwidGljayI6MSwieWF3IjowLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIkFlcm9iaWMrIjp7ImxieV95YXciOjEsImxieSI6IlRpY2tzIiwieWF3X3IiOjQ3LCJwaXRjaF9kZWZlbnNpdmVfcyI6MCwieWF3X2xyIjp0cnVlLCJ5YXdfbCI6LTM1LCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6IkZsaWNrIiwib3ZlcnJpZGUiOnRydWUsImRlZmVuc2l2ZV9hYV9vbiI6ZmFsc2UsInlhd19kZWZlbnNpdmVfcyI6MCwidGljayI6MywieWF3IjowLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIkNyYXdsaW5nIjp7ImxieV95YXciOjEsImxieSI6IlRpY2tzIiwieWF3X3IiOjAsInBpdGNoX2RlZmVuc2l2ZV9zIjowLCJ5YXdfbHIiOmZhbHNlLCJ5YXdfbCI6MCwiZGVmZW5zaXZlX21pbnVzIjozLCJkZWZlbnNpdmUiOiJGbGljayIsIm92ZXJyaWRlIjp0cnVlLCJkZWZlbnNpdmVfYWFfb24iOmZhbHNlLCJ5YXdfZGVmZW5zaXZlX3MiOjAsInRpY2siOjEsInlhdyI6LTMsInlhd19tdWx0aV9zIjoxOSwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIkNlbnRlciIsIn4iXX0sIkZyZWVzdGFuZCI6eyJsYnlfeWF3IjoxLCJsYnkiOiJPZmYiLCJ5YXdfciI6MCwicGl0Y2hfZGVmZW5zaXZlX3MiOjAsInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6Ik9mZiIsIm92ZXJyaWRlIjp0cnVlLCJkZWZlbnNpdmVfYWFfb24iOnRydWUsInlhd19kZWZlbnNpdmVfcyI6MCwidGljayI6MSwieWF3IjowLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIk51bWIiOnsibGJ5X3lhdyI6MSwibGJ5IjoiVGlja3MiLCJ5YXdfciI6MzksInBpdGNoX2RlZmVuc2l2ZV9zIjowLCJ5YXdfbHIiOnRydWUsInlhd19sIjotMjEsImRlZmVuc2l2ZV9taW51cyI6MywiZGVmZW5zaXZlIjoiT2ZmIiwib3ZlcnJpZGUiOnRydWUsImRlZmVuc2l2ZV9hYV9vbiI6ZmFsc2UsInlhd19kZWZlbnNpdmVfcyI6MCwidGljayI6MiwieWF3IjowLCJ5YXdfbXVsdGlfcyI6MCwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIn4iXX0sIk1hbnVhbCBCYWNrIjp7ImxieV95YXciOjEsImxieSI6Ik9mZiIsInlhd19yIjowLCJwaXRjaF9kZWZlbnNpdmVfcyI6MCwieWF3X2xyIjpmYWxzZSwieWF3X2wiOjAsImRlZmVuc2l2ZV9taW51cyI6MywiZGVmZW5zaXZlIjoiT2ZmIiwib3ZlcnJpZGUiOmZhbHNlLCJkZWZlbnNpdmVfYWFfb24iOmZhbHNlLCJ5YXdfZGVmZW5zaXZlX3MiOjAsInRpY2siOjEsInlhdyI6MCwieWF3X211bHRpX3MiOjAsInlhd2RfZGVmZW5zaXZlX3MiOjAsInlhd19kZWZlbnNpdmUiOlsifiJdLCJkZWZlbnNpdmVfcGx1cyI6MTEsInlhd19tdWx0aSI6WyJ+Il19LCJNYW51YWwgTGVmdCI6eyJsYnlfeWF3IjoxLCJsYnkiOiJPZmYiLCJ5YXdfciI6MCwicGl0Y2hfZGVmZW5zaXZlX3MiOjAsInlhd19sciI6ZmFsc2UsInlhd19sIjowLCJkZWZlbnNpdmVfbWludXMiOjMsImRlZmVuc2l2ZSI6Ik9mZiIsIm92ZXJyaWRlIjpmYWxzZSwiZGVmZW5zaXZlX2FhX29uIjp0cnVlLCJ5YXdfZGVmZW5zaXZlX3MiOjAsInRpY2siOjEsInlhdyI6MCwieWF3X211bHRpX3MiOjAsInlhd2RfZGVmZW5zaXZlX3MiOjAsInlhd19kZWZlbnNpdmUiOlsifiJdLCJkZWZlbnNpdmVfcGx1cyI6MTEsInlhd19tdWx0aSI6WyJ+Il19LCJNYW51YWwgUmlnaHQiOnsibGJ5X3lhdyI6MSwibGJ5IjoiT2ZmIiwieWF3X3IiOjAsInBpdGNoX2RlZmVuc2l2ZV9zIjowLCJ5YXdfbHIiOmZhbHNlLCJ5YXdfbCI6MCwiZGVmZW5zaXZlX21pbnVzIjozLCJkZWZlbnNpdmUiOiJPZmYiLCJvdmVycmlkZSI6ZmFsc2UsImRlZmVuc2l2ZV9hYV9vbiI6dHJ1ZSwieWF3X2RlZmVuc2l2ZV9zIjowLCJ0aWNrIjoxLCJ5YXciOjAsInlhd19tdWx0aV9zIjowLCJ5YXdkX2RlZmVuc2l2ZV9zIjowLCJ5YXdfZGVmZW5zaXZlIjpbIn4iXSwiZGVmZW5zaXZlX3BsdXMiOjExLCJ5YXdfbXVsdGkiOlsifiJdfSwi0KFyZWVwaW5nIjp7ImxieV95YXciOjEsImxieSI6Ik9mZiIsInlhd19yIjowLCJwaXRjaF9kZWZlbnNpdmVfcyI6MCwieWF3X2xyIjpmYWxzZSwieWF3X2wiOjAsImRlZmVuc2l2ZV9taW51cyI6MywiZGVmZW5zaXZlIjoiT2ZmIiwib3ZlcnJpZGUiOmZhbHNlLCJkZWZlbnNpdmVfYWFfb24iOmZhbHNlLCJ5YXdfZGVmZW5zaXZlX3MiOjAsInRpY2siOjEsInlhdyI6MCwieWF3X211bHRpX3MiOjAsInlhd2RfZGVmZW5zaXZlX3MiOjAsInlhd19kZWZlbnNpdmUiOlsifiJdLCJkZWZlbnNpdmVfcGx1cyI6MTEsInlhd19tdWx0aSI6WyJ+Il19LCJSZWd1bGFyIjp7ImxieV95YXciOjEsImxieSI6IlRpY2tzIiwieWF3X3IiOjAsInBpdGNoX2RlZmVuc2l2ZV9zIjowLCJ5YXdfbHIiOmZhbHNlLCJ5YXdfbCI6MCwiZGVmZW5zaXZlX21pbnVzIjozLCJkZWZlbnNpdmUiOiJPZmYiLCJvdmVycmlkZSI6ZmFsc2UsImRlZmVuc2l2ZV9hYV9vbiI6ZmFsc2UsInlhd19kZWZlbnNpdmVfcyI6MCwidGljayI6MiwieWF3IjowLCJ5YXdfbXVsdGlfcyI6MjUsInlhd2RfZGVmZW5zaXZlX3MiOjAsInlhd19kZWZlbnNpdmUiOlsifiJdLCJkZWZlbnNpdmVfcGx1cyI6MTEsInlhd19tdWx0aSI6WyJ+Il19LCJBZXJvYmljIjp7ImxieV95YXciOjYwLCJsYnkiOiJUaWNrcyIsInlhd19yIjo0MCwicGl0Y2hfZGVmZW5zaXZlX3MiOjAsInlhd19sciI6dHJ1ZSwieWF3X2wiOi00MCwiZGVmZW5zaXZlX21pbnVzIjozLCJkZWZlbnNpdmUiOiJBbHdheXMiLCJvdmVycmlkZSI6dHJ1ZSwiZGVmZW5zaXZlX2FhX29uIjpmYWxzZSwieWF3X2RlZmVuc2l2ZV9zIjowLCJ0aWNrIjo4LCJ5YXciOjUsInlhd19tdWx0aV9zIjoxMSwieWF3ZF9kZWZlbnNpdmVfcyI6MCwieWF3X2RlZmVuc2l2ZSI6WyJ+Il0sImRlZmVuc2l2ZV9wbHVzIjoxMSwieWF3X211bHRpIjpbIlJhbmRvbSIsIn4iXX19LHsiYWVyb2JpYyI6IlN0YXRpYyIsImFuaW1hdGlvbnNfc2VsZWN0IjpbIkFlcm9iaWMiLCJMZWFuIiwiQWRkaXRpdmUiLCJ+Il0sImxlYW4iOiJCaWciLCJvdGhlciI6WyJBdXRvcGVlayBmaXgiLCJBbmltYXRpb24gc21vb3RoIiwifiJdLCJncm91bmQiOiJTdGF0aWMifSx7ImluZGljYXRvcmNvbDIiOiIjNjQ2NEZGRkYiLCJpbmRpY2F0b3IiOlsiU2NvcGUiLCJHcmVuYWRlIiwifiJdLCJncmFwaCI6ZmFsc2UsImluZGljYXRvcmNvbCI6IiNGRkZGRkZGRiIsImdyYXBoX2MiOiIjNzhBMDUwRkYiLCJwYW5lbHNfc2VsZWN0IjpbIkluZGljYXRvciIsIkhpdG1hcmtlciIsIkdhbWVzZW5zZSIsIn4iXX0seyJoYW5kZHJhZ192Ijp0cnVlLCJ0aGlyZHBlcnNvbiI6NjksImN1c3RvbV9zY29wZV9wb3NpdGlvbiI6OTAsImZsYXNobGlnaHQiOmZhbHNlLCJ2aWV3ZHJhZ192Ijp0cnVlLCJjdXN0b21fc2NvcGVfZmFkZSI6MTIsImN1c3RvbV9zY29wZV9vZmZzZXQiOjYwLCJ6b29tX3NjYWxlIjp0cnVlLCJ0aGlyZHBlcnNvbl9hbmltIjpmYWxzZSwibWVfc2hhcmluZ192IjpmYWxzZSwiaGFuZF96IjotMTQ4LCJoYW5kX3giOjEwOSwiY3VzdG9tX3Njb3BlIjp0cnVlLCJ3b3JsZF9tYW5hZ2VyIjpbIkhhbmRzIERyYWdnaW5nIiwiVmlldyBEcmFnZ2luZyIsIn4iXSwiYXNwZWN0cmF0aW8iOjE2NSwiZmxhc2hsaWdodF92IjpmYWxzZSwiaGFuZF9mb3YiOjU2LCJoYW5kc19kcmFnIjp0cnVlLCJjdXN0b21fc2NvcGVfYyI6IiNGRkZGRkZGRiIsIm1lX3NoYXJpbmdjb2wiOiIjRkYwMDAwRkYiLCJoYW5kX3kiOi00NzAsIm1lX3NoYXJpbmciOiJEcmFnZ2luZyIsInpvb21fb2Zmc2V0Ijo5fSx7InNvdW5kc19saXN0IjoiSW1wYWN0Iiwic291bmRzX2NoZWNrIjp0cnVlLCJvdGhlciI6WyJTb3VuZHMiLCJGb3JjZSBVcGRhdGUiLCJDbGFudGFnIiwifiJdfV0='
    lua.pui.ui.buttons = {
        export = lua.pui.ui.group.other:button('\f<color_tabs> Export config', function ()
            lua.pui.ui.export()
        end),
        import = lua.pui.ui.group.other:button('\f<color_tabs> Import config', function ()
            lua.pui.ui.import()
        end),
        default = lua.pui.ui.group.other:button('\f<color_tabs> Default config', function ()
            lua.pui.ui.import(cfg)
        end),
        agressive = lua.pui.ui.group.other:button('\f<color_tabs> Agressive config', function ()
            lua.pui.ui.import(cfg_agr)
        end),
        beta = lua.pui.ui.group.other:button('\f<color_tabs> Beta config', function ()
            lua.pui.ui.import(cfg_beta)
        end)
    }

    lua.sounds.set(lua.pui.ui.search, lua.sounds.contract)
    lua.sounds.set(lua.pui.ui.animations, lua.sounds.contract)
    lua.sounds.set(lua.pui.ui.render, lua.sounds.contract)
    lua.sounds.set(lua.pui.ui.world, lua.sounds.contract)
    lua.sounds.set(lua.pui.ui.additive, lua.sounds.contract)
    lua.sounds.set(lua.pui.ui.home, lua.sounds.contract)
    lua.sounds.set(lua.pui.ui.buttons, lua.sounds.contract)

    lua.pui.ui.search.tab:depend({lua.pui.ui.search.group, 'Main'})

    lua.pui.ui.home.server:depend({lua.pui.ui.search.group, 'Home'})
    lua.pui.ui.home.antxjav:depend({lua.pui.ui.search.group, 'Home'})

    lua.pui.ui.state:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Builder'})

    lua.pui.ui.antiaim.manuals:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Antiaim'})
    lua.pui.ui.antiaim.manuall:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Antiaim'}, {lua.pui.ui.antiaim.manuals, true})
    lua.pui.ui.antiaim.manualr:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Antiaim'}, {lua.pui.ui.antiaim.manuals, true})
    lua.pui.ui.antiaim.manualb:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Antiaim'}, {lua.pui.ui.antiaim.manuals, true})
    lua.pui.ui.antiaim.manualf:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Antiaim'}, {lua.pui.ui.antiaim.manuals, true})
    lua.pui.ui.antiaim.manualsr:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Antiaim'}, {lua.pui.ui.antiaim.manuals, true})
    lua.pui.ui.antiaim.freestand:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Antiaim'}, {lua.pui.ui.antiaim.manuals, true})

    lua.pui.ui.animations.ground:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Features'})
    lua.pui.ui.animations.aerobic:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Features'}, {lua.pui.ui.animations.animations_select, 'Aerobic'})
    lua.pui.ui.animations.ground:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Features'}, {lua.pui.ui.animations.animations_select, 'Ground'})
    lua.pui.ui.animations.lean:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Features'}, {lua.pui.ui.animations.animations_select, 'Lean'})
    lua.pui.ui.animations.other:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Features'}, {lua.pui.ui.animations.animations_select, 'Additive'})
    lua.pui.ui.render.indicator:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Features'}, {lua.pui.ui.render.panels_select, 'Indicator'})
    lua.pui.ui.render.indicatorcol:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Features'}, {lua.pui.ui.render.panels_select, 'Indicator'})
    lua.pui.ui.render.indicatorcol2:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Features'}, {lua.pui.ui.render.panels_select, 'Indicator'})
    lua.pui.ui.render.graph:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Features'}, {lua.pui.ui.render.panels_select, 'Graph'})

    lua.pui.ui.world.flashlight_v:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.world_manager, 'Flashlight'})
    lua.pui.ui.world.me_sharing_v:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.world_manager, 'Local Sharing'})
    lua.pui.ui.world.viewdrag_v:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.world_manager, 'View Dragging'})
    lua.pui.ui.world.handdrag_v:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.world_manager, 'Hands Dragging'})
    lua.pui.ui.world.hands_drag:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.world.handdrag_v, true}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.world_manager, 'Hands Dragging'})
    lua.pui.ui.world.hand_fov:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.world.hands_drag, true}, {lua.pui.ui.world.handdrag_v, true}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.world_manager, 'Hands Dragging'})
    lua.pui.ui.world.hand_x:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.world.hands_drag, true}, {lua.pui.ui.world.handdrag_v, true}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.world_manager, 'Hands Dragging'})
    lua.pui.ui.world.hand_y:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.world.hands_drag, true}, {lua.pui.ui.world.handdrag_v, true}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.world_manager, 'Hands Dragging'})
    lua.pui.ui.world.hand_z:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.world.hands_drag, true}, {lua.pui.ui.world.handdrag_v, true}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.world_manager, 'Hands Dragging'})
    lua.pui.ui.world.me_sharing:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.world.me_sharing_v, true}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.world_manager, 'Local Sharing'})
    lua.pui.ui.world.me_sharingcol:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.world.me_sharing_v, true}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.world_manager, 'Local Sharing'})
    lua.pui.ui.world.custom_scope:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.world.viewdrag_v, true}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.world_manager, 'View Dragging'})
    lua.pui.ui.world.custom_scope_position:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.viewdrag_v, true}, {lua.pui.ui.world.world_manager, 'View Dragging'}, {lua.pui.ui.world.custom_scope, true})
    lua.pui.ui.world.custom_scope_offset:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.viewdrag_v, true}, {lua.pui.ui.world.world_manager, 'View Dragging'}, {lua.pui.ui.world.custom_scope, true})
    lua.pui.ui.world.custom_scope_fade:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.viewdrag_v, true}, {lua.pui.ui.world.world_manager, 'View Dragging'}, {lua.pui.ui.world.custom_scope, true})
    lua.pui.ui.world.zoom_scale:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.viewdrag_v, true}, {lua.pui.ui.world.world_manager, 'View Dragging'})
    lua.pui.ui.world.zoom_offset:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.viewdrag_v, true}, {lua.pui.ui.world.world_manager, 'View Dragging'}, {lua.pui.ui.world.zoom_scale, true})
    lua.pui.ui.world.flashlight:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.flashlight_v, true}, {lua.pui.ui.world.world_manager, 'Flashlight'})
    lua.pui.ui.world.thirdperson:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.viewdrag_v, true}, {lua.pui.ui.world.world_manager, 'View Dragging'})
    lua.pui.ui.world.thirdperson_anim:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.viewdrag_v, true}, {lua.pui.ui.world.world_manager, 'View Dragging'})
    lua.pui.ui.world.aspectratio:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'World'}, {lua.pui.ui.world.viewdrag_v, true}, {lua.pui.ui.world.world_manager, 'View Dragging'})

    lua.pui.ui.buttons.export:depend({lua.pui.ui.search.group, 'Home'})
    lua.pui.ui.buttons.import:depend({lua.pui.ui.search.group, 'Home'})
    lua.pui.ui.buttons.default:depend({lua.pui.ui.search.group, 'Home'})
    lua.pui.ui.buttons.agressive:depend({lua.pui.ui.search.group, 'Home'})
    lua.pui.ui.buttons.beta:depend({lua.pui.ui.search.group, 'Home'})
    lua.pui.ui.additive.force_update:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Other'}, {lua.pui.ui.additive.other, 'Force Update'})
    lua.pui.ui.additive.sounds_check:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.search.tab, 'Other'}, {lua.pui.ui.additive.other, 'Sounds'})
    lua.pui.ui.additive.sounds_list:depend({lua.pui.ui.search.group, 'Main'}, {lua.pui.ui.additive.sounds_check, true}, {lua.pui.ui.search.tab, 'Other'}, {lua.pui.ui.additive.other, 'Sounds'})

    lua.pui.set_visible = function ()
        local selected_state = lua.pui.ui.state:get()

        for i, name in pairs(lua.pui.condition_names) do
            local enabled = name == selected_state
            local overriden = i == 1 or lua.pui.ui.conditions[name].override:get()
            local lby = lua.pui.ui.conditions[name].lby:get() ~= 'Off'
            local lr = lua.pui.ui.conditions[name].yaw_lr:get()
            local mod_s = lua.pui.ui.conditions[name].yaw_multi
            local def = lua.pui.ui.conditions[name].defensive:get() ~= 'Off'
            local defaa = lua.pui.ui.conditions[name].defensive_aa_on:get()
            local def_s = lua.pui.ui.conditions[name].yaw_defensive
            lua.pui.ui.conditions[name].override:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and i > 1)
            lua.pui.ui.conditions[name].yaw:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden)
            lua.pui.ui.conditions[name].yaw_lr:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden)
            lua.pui.ui.conditions[name].yaw_l:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden and lr)
            lua.pui.ui.conditions[name].yaw_r:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden and lr)
            lua.pui.ui.conditions[name].yaw_multi:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden)
            lua.pui.ui.conditions[name].yaw_multi_s:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden and (mod_s:get('Offset') or mod_s:get('Center') or mod_s:get('Random') or mod_s:get('Spray')))
            lua.pui.ui.conditions[name].lby:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden)
            lua.pui.ui.conditions[name].lby_yaw:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden and lby)
            lua.pui.ui.conditions[name].tick:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden)
            lua.pui.ui.conditions[name].defensive:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden)
            lua.pui.ui.conditions[name].defensive_minus:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden and def)
            lua.pui.ui.conditions[name].defensive_plus:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden and def)
            lua.pui.ui.conditions[name].defensive_aa_on:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden and def)
            lua.pui.ui.conditions[name].pitch_defensive_c:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden and def and defaa)
            lua.pui.ui.conditions[name].pitch_defensive_s:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden and def and defaa)
            lua.pui.ui.conditions[name].yawd_defensive_s:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden and def and defaa)
            lua.pui.ui.conditions[name].yaw_defensive:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden and def and defaa)
            lua.pui.ui.conditions[name].yaw_defensive_s:set_visible(lua.pui.ui.search.group:get() == 'Main' and lua.pui.ui.search.tab:get() == 'Builder' and enabled and overriden and def and defaa and (def_s:get('Offset') or def_s:get('Center') or def_s:get('Random') or def_s:get('Spin')))
        end
    end
    client.set_event_callback('paint_ui', lua.pui.set_visible)
end
--#endregion

--#region lua.reference
lua.reference = {} do
    lua.reference.init = function ()
		lua.reference.rage = {
			binds = {
				weapon_type = pui.reference('rage', 'weapon type', 'weapon type'),
				enabled = { pui.reference('rage', 'aimbot', 'enabled') },
				stop = { pui.reference('rage', 'aimbot', 'quick stop') },
				minimum_damage = pui.reference('rage', 'aimbot', 'minimum damage'),
				minimum_damage_override = {pui.reference('rage', 'aimbot', 'minimum damage override')},
				minimum_hitchance = pui.reference('rage', 'aimbot', 'minimum hit chance'),
				double_tap = {pui.reference('rage', 'aimbot', 'double tap')},
                body_aim = pui.reference('rage', 'aimbot', 'force body aim'),
                safe_point = pui.reference('rage', 'aimbot', 'force safe point'),
				double_tap_fl = pui.reference('rage', 'aimbot', 'double tap fake lag limit'),
				ps = { pui.reference('misc', 'miscellaneous', 'ping spike') },
				quickpeek = {pui.reference('rage', 'other', 'quick peek assist')},
				quickpeekm = {pui.reference('rage', 'other', 'quick peek assist mode')},
                fakeduck = pui.reference('rage', 'other', 'duck peek assist'),
				on_shot_anti_aim = {pui.reference('aa', 'other', 'on shot anti-aim')},
				usercmd = pui.reference('misc', 'settings', 'sv_maxusrcmdprocessticks2')
			}
		}
		lua.reference.antiaim = {
			angles = {
				enabled = pui.reference('aa', 'anti-aimbot angles', 'enabled'),
				pitch = { pui.reference('aa', 'anti-aimbot angles', 'pitch') },
				roll = pui.reference('aa', 'anti-aimbot angles', 'roll'),
				yaw_base = pui.reference('aa', 'anti-aimbot angles', 'yaw base'),
				yaw = { pui.reference('aa', 'anti-aimbot angles', 'yaw') },
				freestanding_body_yaw = pui.reference('aa', 'anti-aimbot angles', 'freestanding body yaw'),
				edge_yaw = pui.reference('aa', 'anti-aimbot angles', 'edge yaw'),
				yaw_jitter = { pui.reference('aa', 'anti-aimbot angles', 'yaw jitter') },
				desync = { pui.reference('aa', 'anti-aimbot angles', 'body yaw') },
				freestanding = pui.reference('aa', 'anti-aimbot angles', 'freestanding'),
				roll_aa = pui.reference('aa', 'anti-aimbot angles', 'roll')
			},
			fakelag = {
				on = {pui.reference('aa', 'fake lag', 'enabled')},
				amount = pui.reference('aa', 'fake lag', 'amount'),
				variance = pui.reference('aa', 'fake lag', 'variance'),
				limit = pui.reference('aa', 'fake lag', 'limit')
			},
			other = {
				slide = {pui.reference('aa','other','slow motion')},
				slow_motion = {pui.reference('aa', 'other', 'slow motion')},
				fake_peek = {pui.reference('aa', 'other', 'fake peek')},
				leg_movement = pui.reference('aa', 'other', 'leg movement')
			}
		}
		lua.reference.visuals = {
			effects = {
				thirdperson = { pui.reference('visuals', 'effects', 'force third person (alive)') },
                scope = pui.reference('visuals', 'effects', 'remove scope overlay'),
				dpi = pui.reference('misc', 'settings', 'dpi scale'),
				clrmenu = pui.reference('misc', 'settings', 'menu color'),
				output = pui.reference('misc', 'miscellaneous', 'draw console output'),
				name = { pui.reference('visuals', 'player esp', 'name') },
                ping = {pui.reference('misc', 'miscellaneous', 'ping spike')},
				fov = pui.reference('misc', 'miscellaneous', 'override fov'),
                clantag = pui.reference('MISC', 'Miscellaneous', 'Clan tag spammer'),
				zfov = pui.reference('misc', 'miscellaneous', 'override zoom fov')
			}
		}
	end
    lua.reference.hide = function(boolean)
		pui.traverse(lua.reference.antiaim.angles, function (r, path)
			r:set_visible(boolean)
		end)
        pui.traverse(lua.reference.antiaim.fakelag, function (r, path)
			r:set_visible(not boolean and lua.pui.ui.search.group:get() == 'Other')
		end)
        pui.traverse(lua.reference.antiaim.other, function (r, path)
			r:set_visible(not boolean and lua.pui.ui.search.group:get() == 'Other')
		end)
        lua.reference.rage.binds.on_shot_anti_aim[1]:set_visible(lua.pui.ui.search.group:get() == 'Other')
    end
    defer(lua.reference.hide)
    defer(function ()
        pui.traverse(lua.reference.rage, function (ref)
            ref:override()
            ref:set_enabled(true)
            if ref.hotkey then ref.hotkey:set_enabled(true) end
        end)
        pui.traverse(lua.reference.antiaim, function (ref)
            ref:override()
            ref:set_enabled(true)
            if ref.hotkey then ref.hotkey:set_enabled(true) end
        end)
        pui.traverse(lua.reference.visuals, function (ref)
            ref:override()
            ref:set_enabled(true)
            if ref.hotkey then ref.hotkey:set_enabled(true) end
        end)
        lua.reference.rage.binds.usercmd:set_visible(false)
    end)
end
lua.reference.init()
--#endregion

--#region lua.keybinds 
lua.keybinds = {}
lua.keybinds.add = function(name, ref, gradient_fn)
    lua.keybinds.binds[#lua.keybinds.binds + 1] = { name = string.sub(name, 1, 2), full_name = name, ref = ref, color = disabled_color, alpha = 0, gradient_progress = 0, gradient_fn = gradient_fn }
end
lua.keybinds.text = function(x, y, r, g, b, a, text, alpha)
    if alpha == nil then
        alpha = 1
    end

    if alpha <= 0 then
        return
    end

    local text_wh = vector(render.measure_text(nil, text))

    render.text(x + 10, y, r, g, b, a, nil, nil, '~ '..text)

    lua.keybinds.y = lua.keybinds.y + text_wh.y * alpha
end
lua.keybinds.binds = {}
lua.keybinds.add('Force body', lua.reference.rage.binds.body_aim)
lua.keybinds.add('Safe point', lua.reference.rage.binds.safe_point)
lua.keybinds.add('Double tap', lua.reference.rage.binds.double_tap[1].hotkey)
lua.keybinds.add('Hide shots', lua.reference.rage.binds.on_shot_anti_aim[1].hotkey)
lua.keybinds.add('Min. damage', lua.reference.rage.binds.minimum_damage_override[1].hotkey)
lua.keybinds.add('Fake ducking', lua.reference.rage.binds.fakeduck)
lua.keybinds.add('Fake latency', lua.reference.visuals.effects.ping[1].hotkey)
lua.keybinds.add('Auto direction', lua.reference.antiaim.angles.freestanding.hotkey)
--#endregion

--#region lua.animations, lua.render
lua.animations = {} lua.render = {} do
    lua.animations.aerobic = function ()
        local me = entity.get_local_player()
        if not me then return end
        local self_index = lua.entity.new(me)
        if self_index:get_anim_state().on_ground == true then return end

        if lua.pui.ui.animations.aerobic:get() == 'Quadrobic' then
           entity.set_prop(me, 'm_flPoseParameter', self_index:get_anim_state().time_since_in_air, 6)
        end

        if lua.pui.ui.animations.aerobic:get() == 'Static' then
            entity.set_prop(me, 'm_flPoseParameter', 1, 6)
        end

        if lua.pui.ui.animations.aerobic:get() == 'Trap' then
            entity.set_prop(me, 'm_flPoseParameter', client.random_float(5 / 10, 10 / 5), 6)
        end

        if lua.pui.ui.animations.aerobic:get() == 'Swag' then
            entity.set_prop(me, 'm_flPoseParameter', math.random(math.random(0.0, 1.0), client.random_float(self_index:get_anim_state().time_since_in_air, 1)), 6)
        end

        if lua.pui.ui.animations.aerobic:get() == 'Jitter' then
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.5, 1.0), 6)
        end

        if lua.pui.ui.animations.aerobic:get() == 'Walking' then
            self_index:get_anim_overlay(6).weight = 1
            self_index:get_anim_overlay(6).cycle = globals.realtime() * 0.5 % 1
        end
    end

    lua.animations.ground = function ()
        local me = entity.get_local_player()
        if not me then return end
        local self_index = lua.entity.new(me)
        if self_index:get_anim_state().on_ground == false then return end

        if lua.pui.ui.animations.ground:get() == 'Static' then
            entity.set_prop(me, 'm_flPoseParameter', 1, 0)
            entity.set_prop(me, 'm_flPoseParameter', 1, 7)
        end

        if lua.pui.ui.animations.ground:get() == 'Static invert' then
            entity.set_prop(me, 'm_flPoseParameter', 0.5, 0)
            entity.set_prop(me, 'm_flPoseParameter', 0, 7)
        end

        if lua.pui.ui.animations.ground:get() == 'Trap' then
            entity.set_prop(me, 'm_flPoseParameter', client.random_float(5 / 10, 10 / 5), 0)
            entity.set_prop(me, 'm_flPoseParameter', client.random_float(5 / 10, 10 / 5), 7)
        end

        if lua.pui.ui.animations.ground:get() == 'Swag' then
            entity.set_prop(me, 'm_flPoseParameter', math.random(client.random_float(0.0, 5.0), client.random_float(0.0, 1.0)), 0)
            entity.set_prop(me, 'm_flPoseParameter', math.random(client.random_float(0.0, 5.0), client.random_float(0.0, 1.0)), 7)
        end

        if lua.pui.ui.animations.ground:get() == 'Jitter' then
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 7)
            entity.set_prop(me, 'm_flPoseParameter', math.random(client.random_float(0.0, 1.0), client.random_float(0.0, 1.0)), 0)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 1)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 3)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 4)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 5)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 8)
        end

        if lua.pui.ui.animations.ground:get() == 'Freeze' then
            entity.set_prop(me, 'm_flPoseParameter', 0, 10)
        end

        if lua.pui.ui.animations.ground:get() == 'Freeze & Static' then
            entity.set_prop(me, 'm_flPoseParameter', 1, 0)
            entity.set_prop(me, 'm_flPoseParameter', 0, 10)
        end

        if lua.pui.ui.animations.ground:get() == 'Freeze & Static invert' then
            entity.set_prop(me, 'm_flPoseParameter', 0.5, 0)
            entity.set_prop(me, 'm_flPoseParameter', 0, 10)
        end

        if lua.pui.ui.animations.ground:get() == 'Bugged' then
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 7)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 0)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 1)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 2)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 3)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 4)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 5)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 8)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 9)
            entity.set_prop(me, 'm_flPoseParameter', math.random(0.0, 1.0), 10)
        end
    end

    lua.animations.lean = function ()
        local me = entity.get_local_player()
        if not me then return end
        local self_index = lua.entity.new(me)

        if lua.pui.ui.animations.lean:get() == 'Jitter' then
            self_index:get_anim_overlay(12).weight = math.random(0.3, 1)
            self_index:get_anim_overlay(12).cycle = globals.realtime() * 0.5 % 1
        end

        if self_index:get_anim_state().m_velocity < 10 then return end

        if lua.pui.ui.animations.lean:get() == 'Zero' then
            self_index:get_anim_overlay(12).weight = 0
            self_index:get_anim_overlay(12).cycle = globals.realtime() * 0.5 % 1
        end

        if lua.pui.ui.animations.lean:get() == 'Big' then
            self_index:get_anim_overlay(12).weight = 1
            self_index:get_anim_overlay(12).cycle = globals.realtime() * 0.5 % 1
        end
    end

    lua.animations.other = function ()
        local me = entity.get_local_player()
        if not me then return end
        local self_index = lua.entity.new(me)

        if lua.pui.ui.animations.other:get('2021 animfix') then
            entity.set_prop(me, 'm_flPoseParameter', 0.5, 11)
        end

        if lua.pui.ui.animations.other:get('Animation smooth') then
            self_index:get_anim_overlay(3).weight = 1
            self_index:get_anim_overlay(3).cycle = globals.realtime() * 0.5 % 1
        end

        if lua.pui.ui.animations.other:get('Autopeek fix') and lua.reference.antiaim.other.leg_movement:get() ~= 'Always slide' and lua.reference.rage.binds.quickpeek[1]:get() then
            self_index:get_anim_overlay(7).weight = 0
        end

        if lua.pui.ui.animations.other:get('Model scale') then
            entity.set_prop(me, 'm_flModelScale', 0.5)
            entity.set_prop(me, 'm_ScaleType', 1)
        else
            entity.set_prop(me, 'm_flModelScale', 1)
            entity.set_prop(me, 'm_ScaleType', 0)
        end

        if lua.pui.ui.animations.other:get('Flashed') then
            self_index:get_anim_overlay(0).sequence = 227
        end

        if lua.pui.ui.animations.other:get('Zero pitch') and self_index:get_anim_state().hit_in_ground_animation == true 
        and self_index:get_anim_state().magic_fraction == 1 and self_index:get_anim_state().on_ground == true then
            entity.set_prop(me, 'm_flPoseParameter', 0.5, 12)
        end
    end

    lua.pui.ui.animations.animations_select:set_event('pre_render', lua.animations.aerobic, function (this)
        return this:get('Aerobic')
    end)
    lua.pui.ui.animations.animations_select:set_event('pre_render', lua.animations.ground, function (this)
        return this:get('Ground')
    end)
    lua.pui.ui.animations.animations_select:set_event('pre_render', lua.animations.lean, function (this)
        return this:get('Lean')
    end)
    lua.pui.ui.animations.animations_select:set_event('pre_render', lua.animations.other, function (this)
        return this:get('Additive')
    end)

    lua.render.anims = {
        a = 0,
        b = 0,
        c = 0,
        d = 0,
        e = 0,
        f = 0,
        g = 0,
        h = 0,
        i = 0,
        j = 0,
        k = 0,
        l = 0,
        m = 0,
        n = 0,
        o = 0,
        p = 0,
        q = 0,
        r = 0,
        s = 0,
        t = 0,
        u = 0,
        v = 0,
        w = 0,
        x = 0,
        y = 0,
        z = 0
    }

    lua.render.lni = {
        center = {
            a = 0,
            b = 0,
            c = 0,
            d = 0,
            e = 0,
            f = 0,
            g = 0,
            h = 0,
            i = 0,
            j = 0,
            k = 0,
            l = 0
        },
        crosshair_indicator = {},
    }

    lua.render.interpfuncs = function ()
        local me = entity.get_local_player()
        if not me then return end
        local grenade = false
        local weapon = entity.get_player_weapon(me)
        if weapon ~= nil then
            local weaponi = weapons(weapon)
            if weaponi.weapon_type_int == 9 then
                grenade = true
            end
        end

        lua.render.lni.center.a = mathematic.lerp(lua.render.lni.center.a, lua.pui.ui.render.panels_select:get('Indicator') and 1 or 0, 0.06)
        lua.render.lni.center.b = mathematic.lerp(lua.render.lni.center.b, lua.reference.rage.binds.double_tap[1].hotkey:get() and 1 or 0, 0.06)
        lua.render.lni.center.d = mathematic.lerp(lua.render.lni.center.d, lua.reference.rage.binds.minimum_damage_override[1]:get_hotkey() and 1 or 0, 0.06)
        lua.render.lni.center.f = mathematic.lerp(lua.render.lni.center.f, math.exploit() and 1 or 0, 0.03)
        lua.render.lni.center.h = mathematic.lerp(lua.render.lni.center.h, lua.pui.ui.render.indicator:get('Grenade') and grenade and lua.render.lni.center.a and 1 or 0, 0.06)
        lua.render.lni.center.i = mathematic.lerp(lua.render.lni.center.i, lua.pui.ui.render.indicator:get('Resume') and entity.get_prop(me, 'm_bResumeZoom') == 1 and lua.render.lni.center.a and 1 or 0, 0.05)
        lua.render.anims.a = mathematic.lerp(lua.render.anims.a, lua.pui.ui.render.panels_select:get('Watermark') and 1 or 0, 0.06)
        lua.render.anims.b = mathematic.lerp(lua.render.anims.b, lua.pui.ui.world.world_manager:get('Local Sharing') and 1 or 0, 0.06)
        lua.render.anims.c = mathematic.lerp(lua.render.anims.c, math.exploit and lua.helps.exploits.defensive() > 0 and 1 or 0, 0.06)
        lua.render.anims.d = mathematic.lerp(lua.render.anims.d, lua.pui.ui.render.panels_select:get('Binds') and 1 or 0, 0.06)
        lua.render.anims.f = mathematic.lerp(lua.render.anims.f, lua.pui.ui.render.panels_select:get('Graph') and lua.pui.ui.render.graph:get() and 1 or 0, 0.06)
        lua.render.anims.h = mathematic.lerp(lua.render.anims.h, lua.pui.ui.render.indicator:get('Scope') and entity.get_prop(me, 'm_bIsScoped') == 1 and 1 or 0, 0.06)
        lua.render.anims.m = mathematic.lerp(lua.render.anims.m, entity.get_prop(me, 'm_bIsScoped') == 1 and 1 or 0, 0.06)
    end
    lua.render.data_hit = {}

    client.set_event_callback('player_hurt', function(e)
        local player = entity.get_local_player()
        if player == nil then
            return
        end

        local victim = client.userid_to_entindex(e.userid)
        if victim == nil then
            return
        end

        local attacker = client.userid_to_entindex(e.attacker)
        if attacker == nil then
            return
        end

        if attacker == player then
            table.insert(lua.render.data_hit, 
                {
                    position = entity.hitbox_position(victim, e.hitgroup),
                    damage = e.dmg_health,
                    weapon = e.weapon,
                    alpha_3d = 0,
                    alpha_crosshair = 0,
                    time = globals.realtime(),
                }
            )
        end
    end)

    lua.render.hitmarker = function()
        local x, y = screen.x / 2, screen.y / 2
        for k, v in pairs(lua.render.data_hit) do
            v.alpha_crosshair = mathematic.lerp(v.alpha_crosshair, v.time + 0.5 > globals.realtime() and 1 or 0, 0.095)
            lua.render.lni.center.g = v.alpha_crosshair
        end
        render.line(x - 5, y - 5, x - 10, y - 10, 255, 255, 255, 255 * lua.render.lni.center.g)
        render.line(x + 5, y + 5, x + 10, y + 10, 255, 255, 255, 255 * lua.render.lni.center.g)
        render.line(x - 5, y + 5, x - 10, y + 10, 255, 255, 255, 255 * lua.render.lni.center.g)
        render.line(x + 5, y - 5, x + 10, y - 10, 255, 255, 255, 255 * lua.render.lni.center.g)
    end

    lua.render.dragapf = function ()
        local me = entity.get_local_player()
        if not me then return end
        local weapon = entity.get_player_weapon(me)
        if lua.reference.rage.binds.quickpeek[1]:get_hotkey() and lua.reference.rage.binds.double_tap[1].hotkey:get() and lua.reference.rage.binds.double_tap[1]:get() then
            local fire = 0
            local wpn = 0
            for k, v in pairs(lua.render.data_hit) do
                wpn = v.weapon
                fire = v.damage
                if v.time + 0.01 < globals.realtime() then
                    table.remove(lua.render.data_hit, k)
                end
            end

            local scout = 0
            if weapon ~= nil and fire ~= 0 then
                local weaponi = weapons(weapon)
                if weaponi.weapon_type_int == 5 then
                    scout = 1
                end
            end

            if fire ~= 0 and scout and wpn == 'ssg08' then
                cvar.slot3:invoke_callback()
            else
                cvar.slot1:invoke_callback()
            end
        end

        
    end

    local _graph = {}
    lua.render.graph = function ()
        local me = entity.get_local_player()
        if not me then return end
        if lua.render.anims.f < 0.1 then return end

        local _fps_meter = render.get_frame(500, 'string')
        if globals.tickcount() % 100 == 1 then
            table.insert(_graph, 1, _fps_meter)
        end
        if #_graph > 30 then
            table.remove(_graph, #_graph)
        end

        local base_position = vector(screen.x / 1.25, 150)
        local get_pos = vector(0, 0)
        local last_position
        for index = #_graph, 1, -1 do
            local position = base_position - vector(index * 10, mathematic.clamp(_graph[index] / 10, 0, 50))
            get_pos = position
        end
        lua.render.anims.g = mathematic.lerp(lua.render.anims.g, #_graph < 30 and lua.render.anims.f > 0.1 and 1 or 0, 0.06)
        local r, g, b = lua.pui.ui.render.graph:get_color()
        render.round_rect(get_pos.x - 61 - get_pos.x / 6, base_position.y + 1, get_pos.x / 5 + 32, -102, 12, 80, 80, 80, 255 * lua.render.anims.f)
        render.round_rect(get_pos.x - 60 - get_pos.x / 6, base_position.y, get_pos.x / 5 + 30, -100, 12, 37, 37, 37, 255 * lua.render.anims.f)
        render.text(get_pos.x - get_pos.x / 11.5, base_position.y - 60, 200, 200, 200, 200 * lua.render.anims.f, 'b', nil, string.format('%s', #_graph))
        render.text(get_pos.x - get_pos.x / 10, base_position.y - 50, 200, 200, 200, 200 * lua.render.anims.f, 'c+', nil, string.format('%s', _fps_meter))
        render.text(get_pos.x - 50 - get_pos.x / 6, base_position.y - 1.5, 200, 200, 200, 200 * lua.render.anims.f, '', nil, string.format('AUI Graphic', #_graph))
        local fx = 'Loaded parameters '..#_graph..' / 30'
        local kx = render.measure_text('', fx)
        render.text(get_pos.x - 50 - get_pos.x / 8, base_position.y - 1.5, 200, 200, 200, 200 * lua.render.anims.g, '', (kx + 1) * lua.render.anims.g, fx)
        for index = #_graph, 1, -1 do
            local position = base_position - vector(index * 10, mathematic.clamp(_graph[index] / 10, 0, 50))
            get_pos = position
            if last_position then
                render.line(last_position.x, last_position.y - 2, position.x, position.y - 2, 255, 255, 255, 255 * lua.render.anims.f)
            end
            last_position = position
        end
    end

    local steit = ''
    function draggable:indicator ()
        local me = entity.get_local_player()
        if not me then return end

        local state = lua.createmove.get_state()
        if not lua.pui.ui.conditions[state].override:get() then
            state = 'Regular'
        end
        state = ''..state:upper()..''

        lua.render.lni.crosshair_indicator.y = 15
        lua.render.lni.crosshair_indicator.scope = lua.render.lni.center.i + lua.render.lni.center.h + lua.render.anims.h
        local offset = 1
		if lua.render.lni.crosshair_indicator.scope > 0 then
			offset = offset - lua.render.lni.crosshair_indicator.scope
		end
        local r, g, b = lua.pui.ui.render.indicatorcol:get()
        local r2, g2, b2 = lua.pui.ui.render.indicatorcol2:get()

        local weapon = entity.get_player_weapon(me)
        if not weapon then return end
        local next_attack = entity.get_prop(me, 'm_flNextAttack')
        local next_primary_attack = entity.get_prop(weapon, 'm_flNextPrimaryAttack')
        if not next_primary_attack then return end
        local x, y = self:get_position()

        if not (math.max(next_primary_attack, next_attack) > globals.curtime()) and lua.reference.rage.binds.double_tap[1].hotkey:get() and lua.reference.rage.binds.double_tap[1]:get() then
            lua.render.lni.center.c = mathematic.clamp(lua.render.lni.center.c + globals.frametime() / 0.15, 0, 1)
        else
            lua.render.lni.center.c = mathematic.clamp(lua.render.lni.center.c - globals.frametime() / 0.15, 0, 1)
        end

        if (math.max(next_primary_attack, next_attack) > globals.curtime()) and lua.reference.rage.binds.double_tap[1].hotkey:get() and lua.reference.rage.binds.double_tap[1]:get() then
            lua.render.lni.center.j = mathematic.clamp(lua.render.lni.center.j + globals.frametime() / 0.15, 0, 1)
        else
            lua.render.lni.center.j = mathematic.clamp(lua.render.lni.center.j - globals.frametime() / 0.15, 0, 1)
        end

        if lua.reference.rage.binds.on_shot_anti_aim[1]:get() and lua.reference.rage.binds.on_shot_anti_aim[1].hotkey:get() and not lua.reference.rage.binds.double_tap[1].hotkey:get() then
            lua.render.lni.center.e = mathematic.clamp(lua.render.lni.center.e + globals.frametime() / 0.15, 0, 1)
        else
            lua.render.lni.center.e = mathematic.clamp(lua.render.lni.center.e - globals.frametime() / 0.15, 0, 1)
        end

        local antarctica = vector(render.measure_text('b', 'antarctica'))
        local antarctica_gr = mathematic.animate_text(globals.curtime(), 'antarctica', r2, g2, b2, 255 * lua.render.lni.center.a, r, g, b, 255 * lua.render.lni.center.a)
        render.text(x - (antarctica.x * offset * 0.5 - 5 * lua.render.lni.crosshair_indicator.scope), y + 20, r, g, b, 255 * lua.render.lni.center.a, 'b', nil, unpack(antarctica_gr))

        local state_mt = render.measure_text('-', state:upper())
        if state == steit then
            lua.render.lni.center.k = mathematic.clamp(lua.render.lni.center.k + globals.frametime() / 0.15, 0, 1)
        else
            lua.render.lni.center.k = mathematic.clamp(lua.render.lni.center.k - globals.frametime() / 0.15, 0, 1)
        end
        if lua.render.lni.center.k < .1 then
            steit = state
        end
        render.text(x - ((state_mt * lua.render.lni.center.k) * offset * 0.5 - 5 * lua.render.lni.crosshair_indicator.scope), y + 32, r, g, b, 255 * lua.render.lni.center.k, '-', state_mt * lua.render.lni.center.k + 1.9, steit)

        local dt = render.measure_text('-', 'DT ')
        local dt_ready = 'READY'
        local string_dt = render.measure_text('-', dt_ready)
        render.text(x - ((dt + string_dt * lua.render.lni.center.c) * offset * 0.5 - 5 * lua.render.lni.crosshair_indicator.scope), y + 42, r, g, b, 255 * lua.render.lni.center.c, '-', dt + string_dt * lua.render.lni.center.c + 1.9, 'DT '..'\a'..mathematic.hex_rgba(155, 255, 155, 255 * lua.render.lni.center.c)..dt_ready, lua.render.lni.center.c)

        local wait_dt = render.measure_text('-', 'CHARGING')
        local charging = mathematic.animate_text(globals.curtime(), 'CHARGING', 255, 100, 100, 255 * lua.render.lni.center.j, r, g, b, 255 * lua.render.lni.center.j)
        render.text(x - ((dt + wait_dt * lua.render.lni.center.j) * offset * 0.5 - 5 * lua.render.lni.crosshair_indicator.scope), y + 42, r, g, b, 255 * lua.render.lni.center.j, '-', dt + wait_dt * lua.render.lni.center.j + 1.9, 'DT ', unpack(charging))

        local osaa = vector(render.measure_text('-', 'OSAA '))
        local os_ready = 'ACTIVE'
        local string_os = render.measure_text('-', os_ready)
        local os_gr = mathematic.animate_text(globals.curtime(), os_ready, r2, g2, b2, 255 * lua.render.lni.center.e, r, g, b, 255 * lua.render.lni.center.e)
        render.text(x - ((osaa.x + string_os * lua.render.lni.center.e) * offset * 0.5 - 5 * lua.render.lni.crosshair_indicator.scope), y + 42, r, g, b, 255 * lua.render.lni.center.e, '-', osaa.x + string_os * lua.render.lni.center.e + 1.9, 'OSAA ', unpack(os_gr))

        render.rectangle(x, y, self.weight, self.height, 255, 255, 255, 55)
    end

    local draggable_ind = draggable:new('draggable indicator', screen.x / 2, screen.y / 2 + 20, 20, 50)

    local initiliaze_indicator = function ()
        draggable_ind:handle_drag()
        draggable_ind:indicator()
    end

    lua.render.custom_scope = function ()
        local enable = lua.pui.ui.world.custom_scope:get()
        local r, g, b, a = lua.pui.ui.world.custom_scope:get_color()
        local position = lua.pui.ui.world.custom_scope_position:get() * screen.y / 1080
        local offset = lua.pui.ui.world.custom_scope_offset:get() * screen.y / 1080
        local fade =  lua.pui.ui.world.custom_scope_fade:get()

        local me = entity.get_local_player()
        if not me then return end
        local wpn = entity.get_player_weapon(me)
        if not wpn then return end

        if enable then
            lua.reference.visuals.effects.scope:override(false)
        end

        local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
        local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
        local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1
        local is_valid = entity.is_alive(me) and wpn ~= nil and scope_level ~= nil
        local act = enable and is_valid and scope_level > 0 and scoped and not resume_zoom

        local fadetime = fade > 3 and globals.frametime() * fade or 1
        local alpha = mathematic.lerp(lua.render.anims.k, 0, 0.06)

        local x = screen.x / 2
        local y = screen.y / 2

        local scopeda = lua.render.anims.m
        local left_center_x = x - scopeda * position - offset + 1
        local right_center_x = x + offset
        local up_center_y = y - scopeda * position - scopeda * offset
        local down_center_y = y + scopeda * offset

        render.gradient(left_center_x, y, scopeda * position, 1, r, g, b, 0, r, g, b, alpha * a, true)
        render.gradient(left_center_x + scopeda * position + scopeda * offset / 2 - 1, y, - scopeda * offset / 2, 1, r, g, b, 0, r, g, b, alpha * a, true)
        render.gradient(right_center_x, y, scopeda * position, 1, r, g, b, alpha * a, r, g, b, 0, true)
        render.gradient(right_center_x - scopeda * offset / 2, y, scopeda * offset / 2 + 1, 1, r, g, b, 0, r, g, b, alpha * a, true)

        render.gradient(x, up_center_y, 1, scopeda * position + scopeda * 2, r, g, b, 0, r, g, b, alpha * a, false)
        render.gradient(x, up_center_y + scopeda * position + scopeda * offset / 2, 1, - scopeda * offset / 2, r, g, b, 0, r, g, b, alpha * a, false)
        render.gradient(x, down_center_y, 1, scopeda * position, r, g, b, alpha * a, r, g, b, 0, false)
        render.gradient(x, down_center_y - scopeda * offset / 2, 1, scopeda * offset / 2 + 1, r, g, b, 0, r, g, b, alpha * a, false)

        lua.render.anims.k = mathematic.clamp(lua.render.anims.k + (act and fadetime or -fadetime), 0, 1)
    end

    local function add_bind(icon, name, ref, gradient_fn, enabled_color, disabled_color)
		enabled_color = {
			[1] = 230,
			[2] = 230,
			[3] = 230,
			[4] = 230
		}
		disabled_color = {
			[1] = 155,
			[2] = 155,
			[3] = 155,
			[4] = 0
		}
		lua.render.indicators_table.binds[#lua.render.indicators_table.binds + 1] = { icon = string.sub(icon, 1, 2), full_icon = icon, name = string.sub(name, 1, 2), full_name = name, ref = ref, color = disabled_color, enabled_color = enabled_color, disabled_color = disabled_color, chars = 0, alpha = 0, gradient_progress = 0, gradient_fn = gradient_fn }
	end

    lua.render.indicators_table = {}
    lua.render.indicators_table.binds = {}
    add_bind('î ', 'FS', lua.pui.ui.antiaim.freestand)
    add_bind('â­ ', 'MD', lua.reference.rage.binds.minimum_damage_override[1].hotkey)
    add_bind('î¼ ', 'BA', lua.reference.rage.binds.body_aim)
    add_bind('î¼ ', 'SP', lua.reference.rage.binds.safe_point)
    add_bind('î ', 'DT', lua.reference.rage.binds.double_tap[1].hotkey)
    add_bind('â ', 'OS', lua.reference.rage.binds.on_shot_anti_aim[1].hotkey)
    add_bind('î¼ ', 'DUCK', lua.reference.rage.binds.fakeduck)
    add_bind('î© ', 'PING', lua.reference.visuals.effects.ping[1].hotkey)

    local add_gamesense_text = function(x, y, r, g, b, a, re, ge, be, ae, icon, text, i_alpha, alpha)
		if alpha == nil then
			alpha = 1
		end

		if alpha <= 0 then
			return
		end

        local icon_wh = vector(render.measure_text('+', icon))
        local text_wh = vector(render.measure_text('+', text))

        local width_ind = math.floor(text_wh.x / 2)
        local y = y + screen.y / 2 + 50
        render.gradient(4, y + text_wh.y, width_ind + 24, text_wh.y + 4, 5, 5, 5, 0, 5, 5, 5, 55 * alpha, true)
        render.gradient(28 + width_ind, y + text_wh.y, 29 + width_ind, text_wh.y + 4, 5, 5, 5, 55 * alpha, 5, 5, 5, 0, true)

        render.text(x * alpha, y + icon_wh.y, re, ge, be, ae * i_alpha, '+', nil, icon)

		render.text(x + icon_wh.x * i_alpha, y + icon_wh.y + 1, r, g, b, a, '+', nil, text)

		lua.render.indicators_table.y = lua.render.indicators_table.y + 40 * alpha
	end

    lua.render.gamesense = function ()
        local me = entity.get_local_player()
        if not me then return end
        lua.render.indicators_table.y = 15
        local ping = lua.helps.exploits.ping()
        for index, bind in ipairs(lua.render.indicators_table.binds) do
            local alpha = mathematic.lerp(bind.alpha, entity.is_alive(me) and bind.ref:get() and 1 or 0.0, 0.05)
            local chars = mathematic.lerp(bind.chars, entity.is_alive(me) and bind.ref:get() and 1 or 0.0, 0.05)
            local n, y, k, w = 255, 255, 255, 255
            local r, g, b, a = mathematic.lerp_color(255, 255, 255, 255, n, y, k, w, alpha)
            local icon = bind.full_icon
            local name = bind.full_name
            local clr = {r, g, b, a}

            if name == 'DT' then
                icon = lua.render.lni.center.f > .3 and 'î ' or 'î '
                clr = {
                    [1] = r,
                    [2] = g * lua.render.lni.center.f,
                    [3] = b * lua.render.lni.center.f,
                    [4] = a
                }
            elseif name == 'PING' then
                icon = ping > 100 and 'î© ' or 'î§ '
                clr = {
                    [1] = 255 - ping / 2,
                    [2] = 230,
                    [3] = 255 - ping * 1.222222,
                    [4] = 255
                }
            elseif name == 'OS' then
                icon = lua.render.lni.center.f > .3 and 'â ' or 'î¸ '
            end

            add_gamesense_text(10, lua.render.indicators_table.y, clr[1], clr[2], clr[3], clr[4] * alpha, clr[1], clr[2], clr[3], clr[4] * alpha, icon, name, chars, alpha)
            lua.render.indicators_table.binds[index].alpha = alpha
            lua.render.indicators_table.binds[index].name = name
            lua.render.indicators_table.binds[index].chars = chars
            lua.render.indicators_table.binds[index].color = r, g, b, a
        end
    end

    local returner = function ()
        if lua.pui.ui.render.panels_select:get('Gamesense') then return end
    end

    function draggable:dmg_indicator()
        local me = entity.get_local_player()
        if not me then return end

        local check = entity.get_player_weapon(me) and weapons(me)
        local valid = check and check.weapon_type_int == 9 and check.weapon_type_int == 0
        if lua.pui.ui.render.panels_select:get('Damage') then
            if lua.reference.rage.binds.minimum_damage_override[1]:get_hotkey() then
                lua.render.anims.n = mathematic.lerp(lua.render.anims.n, 1, 0.06)
            elseif pui.menu_open then
                lua.render.anims.n = mathematic.lerp(lua.render.anims.n, 1, 0.06)
            else
                lua.render.anims.n = mathematic.lerp(lua.render.anims.n, 0.5, 0.06)
            end
        else
            lua.render.anims.n = mathematic.lerp(lua.render.anims.n, 0, 0.06)
        end
        lua.render.anims.p = mathematic.lerp(lua.render.anims.p, lua.reference.rage.binds.minimum_damage_override[1]:get_hotkey() and lua.reference.rage.binds.minimum_damage_override[2].value or lua.reference.rage.binds.minimum_damage:get() + 0.5, 0.06)

        local x, y = self:get_position()
        render.text(x, y, 255, 255, 255, 255 * lua.render.anims.n, '-', 0, math.floor(lua.render.anims.p))
    end

    local draggable_dmg = draggable:new('draggable dmg', screen.x / 2 + 15, screen.y / 2 - 15, 30, 10)

    local initiliaze_dmg = function ()
        draggable_dmg:handle_drag()
        draggable_dmg:dmg_indicator()
    end

    function draggable:watermark()
        local me = entity.get_local_player()
        if not me then return end

        local x, y = self:get_position()
        render.round_rect(x - 2, y - 2, self.width + 4, self.height + 4, 6, 80, 80, 80, 255 * lua.render.anims.a)
        render.round_rect(x - 1, y - 1, self.width + 2, self.height + 2, 6, 37, 37, 37, 255 * lua.render.anims.a)
        render.text(x + 10, y + self.height / 4, 255, 255, 255, 255 * lua.render.anims.a, nil, 0, 'â¨ Antarctica  î¯ Javasense  î Developer')
    end

    local draggable_window = draggable:new('draggable watermark', screen.x - 240, 10, 230, 30)

    local initiliaze_watermark = function ()
        draggable_window:handle_drag()
        draggable_window:watermark()
    end

    local watermark = function()
        local me = entity.get_local_player()
        if not me then return end

        local text = 'ANTARCTICA REBORN'
        local text_xy = vector(render.measure_text('-', text))
        render.text(screen.x / 2 - text_xy.x / 2, screen.y - 15, 255, 255, 255, 255 * (1 - lua.render.anims.a), '-', 0, 'ANTARCTICA REBORN')
    end

    lua.pui.ui.render.panels_select:set_event('paint_ui', initiliaze_indicator, function (this)
        return this:get('Indicator')
    end)

    lua.pui.ui.render.panels_select:set_event('paint_ui', lua.render.hitmarker, function (this)
        return this:get('Hitmarker')
    end)

    lua.pui.ui.render.panels_select:set_event('paint_ui', lua.render.graph, function (this)
        return this:get('Graph')
    end)

    --lua.pui.ui.render.panels_select:set_event('paint_ui', initiliaze_watermark, function (this)
    --    return this:get('Watermark')
    --end)

    lua.pui.ui.render.panels_select:set_event('paint_ui', watermark, function (this)
        return not this:get('Watermark')
    end)

    lua.pui.ui.render.panels_select:set_event('paint_ui', initiliaze_dmg, function (this)
        return this:get('Damage')
    end)

    --lua.pui.ui.render.panels_select:set_event('paint_ui', initiliaze_keybinds, function (this)
    --    return this:get('Binds')
    --end)

    lua.pui.ui.render.panels_select:set_event('paint_ui', lua.render.gamesense, function (this)
        return this:get('Gamesense')
    end)

    lua.pui.ui.render.panels_select:set_event('indicator', returner, function (this)
        return this:get('Gamesense')
    end)

    lua.pui.ui.world.world_manager:set_event('paint', lua.render.custom_scope, function (this)
        return this:get('View Dragging')
    end)

    lua.pui.ui.additive.other:set_event('paint', lua.render.dragapf, function (this)
        return this:get('Razpeek')
    end)

    client.set_event_callback('paint_ui', function ()
        lua.reference.visuals.effects.scope:override(true)
        lua.render.interpfuncs()
        lua.reference.hide(false)
    end)

    lua.reference.init()
end
--#endregion

--#region anti-crasher
local CS_UM_SendPlayerItemFound = 63
local DispatchUserMessage_t = ffi.typeof [[ bool(__thiscall*)(void*, int msg_type, int nFlags, int size, const void* msg)
]]

local VClient018 = client.create_interface('client.dll', 'VClient018')
local pointer = ffi.cast('uintptr_t**', VClient018)
local vtable = ffi.cast('uintptr_t*', pointer[0])
local size = 0
while vtable[size] ~= 0x0 do
   size = size + 1
end

local hooked_vtable = ffi.new('uintptr_t[?]', size)
for i = 0, size - 1 do
    hooked_vtable[i] = vtable[i]
end

pointer[0] = hooked_vtable
local oDispatch = ffi.cast(DispatchUserMessage_t, vtable[38])
local function hkDispatch(thisptr, msg_type, nFlags, size, msg)
    if msg_type == CS_UM_SendPlayerItemFound then
        return false
    end

    return oDispatch(thisptr, msg_type, nFlags, size, msg)
end

client.set_event_callback('shutdown', function()
    hooked_vtable[38] = vtable[38]
    pointer[0] = vtable
end)
hooked_vtable[38] = ffi.cast('uintptr_t', ffi.cast(DispatchUserMessage_t, hkDispatch))
--#endregion

--#region lua.cvar, lua.world
cvar.weapon_accuracy_forcespread:set_raw_float(0)
cvar.sv_airaccelerate:set_raw_float(100)
lua.cvar = {} lua.world = {} do
    lua.world.flashlight = function ()
        local me = entity.get_local_player()
        if me == nil then return end
        if not lua.pui.ui.world.flashlight:get() then return end

        effects = entity.get_prop(me, 'm_fEffects')
        entity.set_prop(me, 'm_fEffects', bit.bor(effects, 4))
    end

    lua.pui.ui.world.world_manager:set_event('pre_render', lua.world.flashlight, function (this)
        return this:get('Flashlight')
    end)

    lua.world.me_sharing = function (cmd)
        local me = entity.get_local_player()
        local iTicksAllowed = lua.helps.exploits.get_maximum_usrcmd_ticks(14)
        local flags = entity.get_prop(me, 'm_fFlags')
        if lua.reference.visuals.effects.thirdperson[1].hotkey:get() == false then return end
        lua.render.anims.e = mathematic.lerp(lua.render.anims.e, (cmd.chokedcommands == 10 or lua.helps.exploits.defensive() > 13) and 1 or 0, 0.025)
        local r, g, b = lua.pui.ui.world.me_sharingcol:get()
        if lua.pui.ui.world.me_sharing:get() == 'Dragging' then
            client.draw_hitboxes(me, globals.tickinterval() * iTicksAllowed * lua.render.anims.b, 
            255 * lua.render.anims.b, r * lua.render.anims.b, g * lua.render.anims.b, b * lua.render.anims.b, 255 * lua.render.anims.e)
        else
            if cmd.chokedcommands == 10 or lua.helps.exploits.defensive() > 13 then
                client.draw_hitboxes(me, globals.tickinterval() * iTicksAllowed * lua.render.anims.b, 
                255 * lua.render.anims.b, r * lua.render.anims.b, g * lua.render.anims.b, b * lua.render.anims.b, 255 * lua.render.anims.b)
            end
        end
    end

    lua.pui.ui.world.world_manager:set_event('setup_command', lua.world.me_sharing, function (this)
        return this:get('Local Sharing')
    end)

    lua.world.hands_drag = function ()
        cvar.viewmodel_fov:set_raw_float(lua.pui.ui.world.hand_fov:get())
        cvar.viewmodel_offset_x:set_raw_float(lua.pui.ui.world.hand_x:get() * 0.01)
        cvar.viewmodel_offset_y:set_raw_float(lua.pui.ui.world.hand_y:get() * 0.01)
        cvar.viewmodel_offset_z:set_raw_float(lua.pui.ui.world.hand_z:get() * 0.01)
    end

    lua.world.thirdperson = function ()
        local thirdperson = lua.pui.ui.world.thirdperson:get()
        local anim = lua.pui.ui.world.thirdperson_anim:get()
        lua.render.anims.w = mathematic.lerp(lua.render.anims.w, anim and thirdperson or 1, 0.035)
        lua.render.anims.x = mathematic.lerp(lua.render.anims.x, anim and lua.reference.visuals.effects.thirdperson[1].hotkey:get() and 1 or 0, 0.035)

        if anim then
            if lua.reference.visuals.effects.thirdperson[1].hotkey:get() then
                cvar.cam_idealdist:set_int(lua.render.anims.w * lua.render.anims.x)
            else
                cvar.cam_idealdist:set_int(thirdperson)
            end
        else
            cvar.cam_idealdist:set_int(thirdperson)
        end
    end

    lua.pui.ui.world.world_manager:set_event('paint', lua.world.thirdperson, function (this)
        return this:get('View Dragging')
    end)

    lua.world.aspectratio = function ()
        local aspect = lua.pui.ui.world.aspectratio:get()
        lua.render.anims.y = mathematic.lerp(lua.render.anims.y, aspect * 0.01, 0.035)
        cvar.r_aspectratio:set_float(aspect ~= 0.0 and lua.render.anims.y or 0)
    end

    lua.pui.ui.world.world_manager:set_event('paint', lua.world.aspectratio, function (this)
        return this:get('View Dragging')
    end)

    lua.pui.ui.world.world_manager:set_event('paint', lua.world.hands_drag, function (this)
        return this:get('Hands Dragging')
    end)

    lua.world.zoom = function (z)
        local me = entity.get_local_player()
        if not lua.pui.ui.world.zoom_scale:get() then return end
        local offset = lua.pui.ui.world.zoom_offset:get()
        local wpn = entity.get_player_weapon(me)
        if not wpn then return end
        local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
        local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
        local act = 0
        if scoped then
            if scope_level == 1 then
                act = 1
            else
                act = 2
            end
        else
            act = 0
        end
        lua.render.anims.z = mathematic.lerp(lua.render.anims.z, scoped and act or 0, 0.06)

        z.fov = z.fov - offset * lua.render.anims.z
    end

    lua.pui.ui.world.world_manager:set_event('override_view', lua.world.zoom, function (this)
        return this:get('View Dragging')
    end)

    lua.cvar.clantag_list = {
        ena = false,
        en = 0,
        cl = {
            'a',
            'ant',
            'anta',
            'ant4',
            'anta',
            '4^%a',
            'antar',
            'antarc',
            'anta7ct',
            '4|tarcti',
            'antarcti',
            'an$4rcti',
            'antarctic',
            'antarctica',
            'anta7%tica',
            'antarctic',
            '4#$tarcti',
            'antarct1',
            'antarc%',
            'antar/',
            'ant//&%',
            '$%#2arcti',
            '$%#2*cti',
            '$%#2*%#@$',
            '$%#2*%#@$/',
            '$%#2/',
            '%/',
            '/',
            '|'
        }

    }

    lua.cvar.clantag = function ()
        if lua.cvar.clantag_list.ena and not lua.pui.ui.additive.other:get('Clantag') then
			lua.cvar.clantag_list.ena = false
			client.unset_event_callback('net_update_end', lua.cvar.clantag)
			client.set_clan_tag()
		end

        local time = math.floor(globals.curtime() * 4 + 0.5)
		local i = time % #lua.cvar.clantag_list.cl + 1

		if i == lua.cvar.clantag_list.en then return end
		lua.cvar.clantag_list.en = i

		client.set_clan_tag(lua.cvar.clantag_list.cl[i])
    end

    lua.cvar.clantag_on = function ()
		lua.pui.ui.additive.other:set_callback(function (this)
            lua.reference.visuals.effects.clantag:set_enabled(not this:get('Clantag'))

			if this:get('Clantag') then
				lua.cvar.clantag_list.ena = true
				client.set_event_callback('net_update_end', lua.cvar.clantag)
				lua.reference.visuals.effects.clantag:override(false)
			else
				lua.reference.visuals.effects.clantag:override()
				client.set_clan_tag()
			end
		end, true)
		defer(function ()
			lua.reference.visuals.effects.clantag:set_enabled(true)
			lua.reference.visuals.effects.clantag:override()
			client.set_clan_tag()
		end)
    end
    lua.cvar.clantag_on()
end
--#endregion

--#region lua.hitsound 
lua.hitsound = {} do
    lua.hitsound.hurt = function (k)
        if not lua.pui.ui.additive.sounds_check:get() then return end
        local me = entity.get_local_player()
        local attacker_id = client.userid_to_entindex(k.attacker)
		if attacker_id == nil or attacker_id ~= me then
			return
		end

        local sound_file = lua.sounds.sound_name_to_file[lua.pui.ui.additive.sounds_list:get()]
        lua.sounds.play(sound_file, false)
    end

    lua.pui.ui.additive.other:set_event('player_hurt', lua.hitsound.hurt, function (this)
        return this:get('Sounds')
    end)
end
--#endregion

--#region lua.createmove
lua.createmove = {} do
lua.createmove.enabled = false
lua.createmove.start_time = globals.realtime()
lua.createmove.use_enable = function (cmd)
    lua.createmove.enabled = false

    if not lua.pui.ui.conditions['Using'].override:get() then
        return
    end

    if cmd.in_use == 0 then
        lua.createmove.start_time = globals.realtime()
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local player_origin = { entity.get_origin(player) }
	
    local CPlantedC4 = entity.get_all('CPlantedC4')
    local dist_to_bomb = 999

    if #CPlantedC4 > 0 then
        local bomb = CPlantedC4[1]
        local bomb_origin = { entity.get_origin(bomb) }

        dist_to_bomb = vector(player_origin[1], player_origin[2], player_origin[3]):dist(vector(bomb_origin[1], bomb_origin[2], bomb_origin[3]))
    end

    local CHostage = entity.get_all('CHostage')
    local dist_to_hostage = 999

    if CHostage ~= nil then
        if #CHostage > 0 then
            local hostage_origin = {entity.get_origin(CHostage[1])}

            dist_to_hostage = math.min(vector(player_origin[1], player_origin[2], player_origin[3]):dist(vector(hostage_origin[1], hostage_origin[2], hostage_origin[3])), vector(player_origin[1], player_origin[2], player_origin[3]):dist(vector(hostage_origin[1], hostage_origin[2], hostage_origin[3])))
        end
    end

    if dist_to_hostage < 65 and entity.get_prop(player, 'm_iTeamNum') ~= 2 then
        return
    end

    if dist_to_bomb < 65 and entity.get_prop(player, 'm_iTeamNum') ~= 2 then
        return
    end

    if cmd.in_use then
        if globals.realtime() - lua.createmove.start_time < 0.02 then
            return
        end
    end

    cmd.in_use = false
    lua.createmove.enabled = true
end

lua.createmove.get_state = function ()
    local me = entity.get_local_player()
    if not me then
        return 'Regular'
    end

    local first_velocity, second_velocity = entity.get_prop(me, 'm_vecVelocity')
    lua.createmove.speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))

    if entity.get_prop(me, 'm_hGroundEntity') == 0 then
        lua.pui.ticks = lua.pui.ticks + 1
    else
        lua.pui.ticks = 0
    end

    lua.createmove.onground = lua.pui.ticks >= 32

    if lua.createmove.enabled and lua.pui.ui.conditions['Using'].override:get() then
        return 'Using'
    end

    if lua.createmove.selected_manual == 1 then
        return 'Manual Left'
    end

    if lua.createmove.selected_manual == 2 then
        return 'Manual Right'
    end

    if lua.createmove.selected_manual == 3 then
        return 'Manual Back'
    end

    if lua.createmove.selected_manual == 4 then
        return 'Manual Forward'
    end

    if lua.pui.ui.antiaim.freestand:get() and lua.pui.ui.conditions['Freestand'].override:get() then
        return 'Freestand'
    end

    if not lua.createmove.onground then
        if entity.get_prop(me, 'm_flDuckAmount') == 1 and lua.pui.ui.conditions['Aerobic+'].override:get() then
            return 'Aerobic+'
        end

        return 'Aerobic'
    end

    if entity.get_prop(me, 'm_flDuckAmount') == 1 then
        if lua.createmove.speed > 5 and lua.pui.ui.conditions['Ð¡reeping'].override:get() then
            return 'Ð¡reeping'
        end

        return 'Crouch'
    end

    if lua.reference.antiaim.other.slide[1].hotkey:get() and lua.pui.ui.conditions['Crawling'].override:get() then
        return 'Crawling'
    end

    if lua.createmove.speed > 5 then
        return 'Push'
    end

    return 'Numb'
end

lua.createmove.set_invert = false
lua.createmove.set_tick = 0
lua.createmove.get_invert = function (ref, cmd)
    local me = entity.get_local_player()
    if not me then return end

    if globals.tickcount() > lua.createmove.set_tick + ref then
        if cmd.chokedcommands == 0 then
            lua.createmove.set_invert = not lua.createmove.set_invert
            lua.createmove.set_tick = globals.tickcount()
        end
    end

    if globals.tickcount() < lua.createmove.set_tick then
        lua.createmove.set_tick = globals.tickcount()
    end

    return lua.createmove.set_invert
end

lua.createmove.fast_ladder = function(cmd)
    if not lua.pui.ui.additive.other:get('Fast Ladder') then return end
    local me = entity.get_local_player()
    if not me then return end

    local move_type = entity.get_prop(me, 'm_MoveType')
    local weapon = entity.get_player_weapon(me)
    local throw = entity.get_prop(weapon, 'm_fThrowTime')

    if move_type ~= 9 then
        return
    end

    if weapon == nil then
        return
    end

    if throw ~= nil and throw ~= 0 then
        return
    end

    if cmd.forwardmove > 0 then
        if cmd.pitch < 45 then
            cmd.pitch = 89
            cmd.in_moveright = 1
            cmd.in_moveleft = 0
            cmd.in_forward = 0
            cmd.in_back = 1

            if cmd.sidemove == 0 then
                cmd.yaw = cmd.yaw + 90
            end

            if cmd.sidemove < 0 then
                cmd.yaw = cmd.yaw + 150
            end

            if cmd.sidemove > 0 then
                cmd.yaw = cmd.yaw + 30
            end
        end
    elseif cmd.forwardmove < 0 then
        cmd.pitch = 89
        cmd.in_moveleft = 1
        cmd.in_moveright = 0
        cmd.in_forward = 1
        cmd.in_back = 0

        if cmd.sidemove == 0 then
            cmd.yaw = cmd.yaw + 90
        end

        if cmd.sidemove > 0 then
            cmd.yaw = cmd.yaw + 150
        end

        if cmd.sidemove < 0 then
            cmd.yaw = cmd.yaw + 30
        end
    end
end

lua.createmove.manual = function()
    lua.pui.ui.antiaim.manuall:set('On hotkey')
    lua.pui.ui.antiaim.manualr:set('On hotkey')
    lua.pui.ui.antiaim.manualb:set('On hotkey')
    lua.pui.ui.antiaim.manualf:set('On hotkey')
    lua.pui.ui.antiaim.manualsr:set('On hotkey')

    if not lua.pui.ui.antiaim.manuals:get() then
        lua.createmove.selected_manual = 0
        return
    end

    if lua.createmove.selected_manual == nil then
        lua.createmove.selected_manual = 0
    end

    local left_pressed = lua.pui.ui.antiaim.manuall:get()
    if left_pressed and not lua.createmove.left_pressed then
        if lua.createmove.selected_manual == 1 then
            lua.createmove.selected_manual = 0
        else
            lua.createmove.selected_manual = 1
        end
    end

    local right_pressed = lua.pui.ui.antiaim.manualr:get()
    if right_pressed and not lua.createmove.right_pressed then
        if lua.createmove.selected_manual == 2 then
            lua.createmove.selected_manual = 0
        else
            lua.createmove.selected_manual = 2
        end
    end

    local back_pressed = lua.pui.ui.antiaim.manualb:get()
    if back_pressed and not lua.createmove.back_pressed then
        if lua.createmove.selected_manual == 3 then
            lua.createmove.selected_manual = 0
        else
            lua.createmove.selected_manual = 3
        end
    end

    local forward_pressed = lua.pui.ui.antiaim.manualf:get()
    if forward_pressed and not lua.createmove.forward_pressed then
        if lua.createmove.selected_manual == 4 then
            lua.createmove.selected_manual = 0
        else
            lua.createmove.selected_manual = 4
        end
    end

    local reset_pressed = lua.pui.ui.antiaim.manualsr:get()
    if reset_pressed and not lua.createmove.reset_pressed then
        if lua.createmove.selected_manual == 5 then
            lua.createmove.selected_manual = 5
        else
            lua.createmove.selected_manual = 0
        end
    end

    lua.createmove.left_pressed = left_pressed
    lua.createmove.right_pressed = right_pressed
    lua.createmove.back_pressed = back_pressed
    lua.createmove.forward_pressed = forward_pressed
    lua.createmove.reset_pressed = reset_pressed
end

lua.createmove.freestand = function()
    local state = lua.createmove.get_state()
    if not lua.pui.ui.conditions[state].override:get() then
        state = 'Regular'
    end

    local fs = lua.pui.ui.antiaim.freestand:get()
    if lua.createmove.selected_manual ~= 0 then
        fs = false
    end

    if lua.helps.exploits.defensive() > lua.pui.ui.conditions[state].defensive_minus:get() and 
    lua.helps.exploits.defensive() < lua.pui.ui.conditions[state].defensive_plus:get() and 
        lua.pui.ui.conditions[state].defensive_aa_on:get() and
        lua.pui.ui.conditions[state].defensive:get() ~= 'Off' then

        lua.reference.antiaim.angles.freestanding.hotkey:set('always on')
        lua.reference.antiaim.angles.freestanding:set(false)
    else
        lua.reference.antiaim.angles.freestanding.hotkey:set('always on')
        lua.reference.antiaim.angles.freestanding:set(fs)
    end
end

lua.createmove.spray = 0
lua.createmove.spin = 0
lua.createmove.builder = function (cmd)
    local me = entity.get_local_player()
    if not me then return end

    local state = lua.createmove.get_state()

    if not lua.pui.ui.conditions[state].override:get() then
        state = 'Regular'
    end

    local yaw_da = 0
    local delay = lua.pui.ui.conditions[state].lby:get() == 'Random Ticks' and client.random_int(lua.pui.ui.conditions[state].tick:get(), lua.pui.ui.conditions[state].tick:get() * 5) or lua.pui.ui.conditions[state].tick:get()
    local invert = lua.createmove.get_invert(delay, cmd)

    local direction_freestand = lua.helps.exploits.get_freestand_direction(me)

    local def_pitch = lua.pui.ui.conditions[state].pitch_defensive_c:get() == 'Default' and lua.pui.ui.conditions[state].pitch_defensive_s:get() or client.random_int(-lua.pui.ui.conditions[state].pitch_defensive_s:get(), lua.pui.ui.conditions[state].pitch_defensive_s:get())
    local yawd_defensive_s = lua.pui.ui.conditions[state].yawd_defensive_s:get()
    local def_p = lua.pui.ui.conditions[state].defensive_plus
    local def_m = lua.pui.ui.conditions[state].defensive_minus
    local defensive = lua.pui.ui.conditions[state].defensive
    local defensive_aa = lua.pui.ui.conditions[state].defensive_aa_on
    local defensive_yaw = lua.pui.ui.conditions[state].yaw_defensive
    local defensive_yaw_slide = lua.pui.ui.conditions[state].yaw_defensive_s:get()
    local d_yaw = 0
    if lua.createmove.spin > 180 then
        lua.createmove.spin = -180
    end
    lua.createmove.spin = lua.createmove.spin + defensive_yaw_slide / 9

    if defensive_yaw:get('Offset') then
        d_yaw = d_yaw + (invert and -defensive_yaw_slide / 2 or defensive_yaw_slide)
    end

    if defensive_yaw:get('Center') then
        d_yaw = d_yaw + (invert and -defensive_yaw_slide or defensive_yaw_slide)
    end

    if defensive_yaw:get('Random') then
        d_yaw = d_yaw + (invert and -client.random_int(0, defensive_yaw_slide) or client.random_int(0, defensive_yaw_slide))
    end

    if defensive_yaw:get('Spin') then
        d_yaw = d_yaw + lua.createmove.spin
    end

    local yaw = lua.pui.ui.conditions[state].yaw:get()
    local lr = lua.pui.ui.conditions[state].yaw_lr:get()
    local r = lua.pui.ui.conditions[state].yaw_r:get()
    local l = lua.pui.ui.conditions[state].yaw_l:get()
    local invert_lr = lr and (invert and l or r) or 0

    local modifier_sel = lua.pui.ui.conditions[state].yaw_multi
    local modifier_slide = lua.pui.ui.conditions[state].yaw_multi_s:get()
    local multiselect_modifier = 0
    if modifier_sel:get('Offset') then
        local mod_offset = invert and modifier_slide / 2 or modifier_slide
        multiselect_modifier = multiselect_modifier + mod_offset
    end

    if modifier_sel:get('Center') then
        local mod_center = invert and -modifier_slide or modifier_slide
        multiselect_modifier = multiselect_modifier + mod_center
    end

    if modifier_sel:get('Random') then
        local mod_random = invert and -client.random_int(0, modifier_slide) or client.random_int(0, modifier_slide)
        multiselect_modifier = multiselect_modifier + mod_random
    end

    if lua.createmove.spray > 60 or lua.createmove.spray < -60 then
        lua.createmove.spray = 0
    end

    if modifier_sel:get('Spray') then
        lua.createmove.spray = lua.createmove.spray + (invert and - modifier_slide or modifier_slide) / 4
        local spray = lua.createmove.spray
        multiselect_modifier = multiselect_modifier + spray
    end

    local body_yaw = lua.pui.ui.conditions[state].lby:get()
    local body_value = lua.pui.ui.conditions[state].lby_yaw:get()
    local lby_count = 'Off'
    local lby_number = 'Off'
    if body_yaw == 'Ticks' then
        lby_count = 'Static'
        lby_number = invert and -body_value or body_value
    elseif body_yaw == 'Random Ticks' then
        lby_count = 'Static'
        lby_number = invert and -body_value or body_value
    elseif body_yaw == 'Static' then
        lby_count = 'Static'
        lby_number = direction_freestand == -1 and -body_value or body_value
    else
        lby_count = 'Off'
        lby_number = 0
    end

    local byaw = 0
    local players = entity.get_players(true)
    if next(players) == nil then
        byaw = false
    end
    for i=1, #players do
        local x, y, z = entity.get_prop(players[i], 'm_vecOrigin')
        local origin = vector(entity.get_prop(entity.get_local_player(), 'm_vecOrigin'))
        local distance = math.sqrt((x - origin.x)^2 + (y - origin.y)^2 + (z - origin.z)^2) 
        local weapon = entity.get_player_weapon(players[i])
        if weapon == nil then return end
        if entity.get_classname(weapon) == 'CKnife' and distance <= 150 then
            byaw = true
        else
            byaw = false
        end
    end

    if lua.pui.ui.antiaim.manuals:get() and lua.createmove.selected_manual == 2 and not lua.pui.ui.conditions['Manual Right'].override:get() then
        if lua.helps.exploits.defensive() > 3
        and lua.helps.exploits.defensive() < 11
        then
            yaw_da = lua.helps.additions.normalize_yaw(direction_freestand * yawd_defensive_s + d_yaw)
            lua.reference.antiaim.angles.yaw[2]:override(yaw_da)
            lua.reference.antiaim.angles.pitch[2]:override(-89)
        else
            yaw_da = lua.helps.additions.normalize_yaw(90)
            lua.reference.antiaim.angles.yaw[2]:override(yaw_da)
            lua.reference.antiaim.angles.pitch[2]:override(89)
        end
    elseif lua.pui.ui.antiaim.manuals:get() and lua.createmove.selected_manual == 1 and not lua.pui.ui.conditions['Manual Left'].override:get() then
        if lua.helps.exploits.defensive() > 3
        and lua.helps.exploits.defensive() < 11
        then
            yaw_da = lua.helps.additions.normalize_yaw(direction_freestand * yawd_defensive_s + d_yaw)
            lua.reference.antiaim.angles.yaw[2]:override(yaw_da)
            lua.reference.antiaim.angles.pitch[2]:override(-89)
        else
            yaw_da = lua.helps.additions.normalize_yaw(-90)
            lua.reference.antiaim.angles.yaw[2]:override(yaw_da)
            lua.reference.antiaim.angles.pitch[2]:override(89)
        end
    elseif lua.pui.ui.antiaim.manuals:get() and lua.createmove.selected_manual == 4 and not lua.pui.ui.conditions['Manual Forward'].override:get() then
        if lua.helps.exploits.defensive() > 3
        and lua.helps.exploits.defensive() < 11
        then
            yaw_da = lua.helps.additions.normalize_yaw(direction_freestand * yawd_defensive_s + d_yaw)
            lua.reference.antiaim.angles.yaw[2]:override(yaw_da)
            lua.reference.antiaim.angles.pitch[2]:override(-89)
        else
            yaw_da = lua.helps.additions.normalize_yaw(180)
            lua.reference.antiaim.angles.yaw[2]:override(yaw_da)
            lua.reference.antiaim.angles.pitch[2]:override(89)
        end
    elseif lua.pui.ui.antiaim.manuals:get() and lua.createmove.selected_manual == 3 and not lua.pui.ui.conditions['Manual Back'].override:get() then
        if lua.helps.exploits.defensive() > 3
        and lua.helps.exploits.defensive() < 11
        then
            yaw_da = lua.helps.additions.normalize_yaw(direction_freestand * yawd_defensive_s + d_yaw)
            lua.reference.antiaim.angles.yaw[2]:override(yaw_da)
            lua.reference.antiaim.angles.pitch[2]:override(-89)
        else
            yaw_da = lua.helps.additions.normalize_yaw(0)
            lua.reference.antiaim.angles.yaw[2]:override(yaw_da)
            lua.reference.antiaim.angles.pitch[2]:override(89)
        end
    else
        if lua.helps.exploits.defensive() > def_m:get()
        and lua.helps.exploits.defensive() < def_p:get()
        and defensive_aa:get() and defensive:get() ~= 'Off' then
            yaw_da = lua.helps.additions.normalize_yaw(direction_freestand * yawd_defensive_s + d_yaw)
            lua.reference.antiaim.angles.yaw[2]:override(yaw_da)
            lua.reference.antiaim.angles.pitch[2]:override(def_pitch)
        else
            yaw_da = lua.helps.additions.normalize_yaw(((lua.createmove.enabled and lua.pui.ui.conditions['Using'].override:get() or byaw) and 180 or 0) + yaw + invert_lr + multiselect_modifier)
            lua.reference.antiaim.angles.yaw[2]:override(yaw_da)
            lua.reference.antiaim.angles.pitch[2]:override(lua.createmove.enabled and lua.pui.ui.conditions['Using'].override:get() and 0 or 89)
        end
    end
    lua.reference.antiaim.angles.pitch[1]:override('custom')
    lua.reference.antiaim.angles.yaw_base:override((lua.createmove.enabled and lua.pui.ui.conditions['Using'].override:get() or lua.createmove.selected_manual ~= 0) and 'local view' or 'at targets')
    lua.reference.antiaim.angles.yaw[1]:override('180')
    lua.reference.antiaim.angles.yaw_jitter[1]:override('off')
    lua.reference.antiaim.angles.yaw_jitter[2]:override(0)
    lua.reference.antiaim.angles.desync[1]:override(lby_count)
    lua.reference.antiaim.angles.desync[2]:override(lby_number)
end

lua.createmove.defensive = function (cmd)
    local state = lua.createmove.get_state()
    if not lua.pui.ui.conditions[state].override:get() then
        state = 'Regular'
    end

    if not lua.reference.rage.binds.double_tap[1].hotkey:get() and not lua.reference.rage.binds.double_tap[1]:get() then
        return
    end

    if lua.pui.ui.conditions[state].defensive:get() == 'Always' then
        cmd.force_defensive = true
    elseif lua.helps.exploits.is_peeking() and lua.pui.ui.conditions[state].defensive:get() == 'On Peek' then
        cmd.allow_send_packet = false
        cmd.force_defensive = true
    elseif lua.pui.ui.conditions[state].defensive:get() == 'Flick' then
        cmd.force_defensive = cmd.command_number % 8 == 0
    else
        cmd.force_defensive = false
    end
end

lua.createmove.allow_charge = function (cmd)
    local tickbase = entity.get_prop(entity.get_local_player(), 'm_nTickBase') - globals.tickcount()
    local os_ref = lua.reference.rage.binds.on_shot_anti_aim[1].hotkey:get() and lua.reference.rage.binds.on_shot_anti_aim[1]:get() and not lua.reference.rage.binds.fakeduck:get()
    local doubletap_ref = lua.reference.rage.binds.double_tap[1].hotkey:get() and lua.reference.rage.binds.double_tap[1]:get() and not lua.reference.rage.binds.fakeduck:get()
    local active_weapon = entity.get_prop(entity.get_local_player(), 'm_hActiveWeapon')

    if active_weapon == nil then
        return
    end

    local weapon_idx = entity.get_prop(active_weapon, 'm_iItemDefinitionIndex')

    if weapon_idx == nil or weapon_idx == 64 then
        return
    end

    local last_shot = entity.get_prop(active_weapon, 'm_fLastShotTime')

    if last_shot == nil then
        return
    end

    local single_fire_weapon =
        weapon_idx == 40 or weapon_idx == 9 or weapon_idx == 64 or weapon_idx == 27 or weapon_idx == 29 or
        weapon_idx == 35
    local value = single_fire_weapon and 0 or 0.50
    local in_attack = globals.curtime() - last_shot <= value

    if tickbase > 0 and os_ref then
        if in_attack then
            lua.reference.rage.binds.enabled[1]:override(true)
        else
            lua.reference.rage.binds.enabled[1]:override(false)
        end
    elseif tickbase > 0 and doubletap_ref then
        if in_attack then
            lua.reference.rage.binds.enabled[1]:override(true)
        else
            lua.reference.rage.binds.enabled[1]:override(false)
        end
    else
        lua.reference.rage.binds.enabled[1]:override(true)
    end
end

client.set_event_callback('setup_command', lua.createmove.fast_ladder)
client.set_event_callback('setup_command', lua.createmove.defensive)
client.set_event_callback('setup_command', lua.createmove.use_enable)
client.set_event_callback('setup_command', lua.createmove.builder)
client.set_event_callback('setup_command', lua.createmove.allow_charge)
client.set_event_callback('pre_render', lua.createmove.manual)
client.set_event_callback('setup_command', lua.createmove.freestand)
end
--#endregion
