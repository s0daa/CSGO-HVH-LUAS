-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server

-- local variables for API functions. any changes to the line below will be lost on re-generationlocal 

bit_band, client_camera_angles, client_color_log, client_create_interface, client_current_threat, client_eye_position, client_key_state, client_latency, client_log, client_random_int, client_register_esp_flag, client_scale_damage, client_screen_size, client_set_clan_tag, client_set_cvar, client_set_event_callback, client_trace_bullet, client_trace_line, client_userid_to_entindex, entity_get_all, entity_get_classname, entity_get_game_rules, entity_get_local_player, entity_get_player_resource, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_enemy, entity_set_prop, globals_chokedcommands, globals_curtime, globals_framecount, globals_frametime, globals_maxplayers, globals_tickcount, globals_tickinterval, math_abs, math_atan, math_atan2, math_ceil, math_cos, math_deg, math_floor, math_max, math_min, math_rad, math_sin, math_sqrt, panorama_loadstring, renderer_circle, renderer_circle_outline, renderer_gradient, renderer_measure_text, renderer_rectangle, renderer_text, renderer_triangle, string_char, string_gmatch, string_gsub, table_insert, ui_get, ui_is_menu_open, ui_mouse_position, ui_new_slider, ui_reference, ui_set, ui_set_callback, ui_set_visible, toticks, setmetatable, string_sub, table_remove, ui_new_button, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_hotkey, ui_new_label, ui_new_multiselect, ipairs = bit.band, client.camera_angles, client.color_log, client.create_interface, client.current_threat, client.eye_position, client.key_state, client.latency, client.log, client.random_int, client.register_esp_flag, client.scale_damage, client.screen_size, client.set_clan_tag, client.set_cvar, client.set_event_callback, client.trace_bullet, client.trace_line, client.userid_to_entindex, entity.get_all, entity.get_classname, entity.get_game_rules, entity.get_local_player, entity.get_player_resource, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_enemy, entity.set_prop, globals.chokedcommands, globals.curtime, globals.framecount, globals.frametime, globals.maxplayers, globals.tickcount, globals.tickinterval, math.abs, math.atan, math.atan2, math.ceil, math.cos, math.deg, math.floor, math.max, math.min, math.rad, math.sin, math.sqrt, panorama.loadstring, renderer.circle, renderer.circle_outline, renderer.gradient, renderer.measure_text, renderer.rectangle, renderer.text, renderer.triangle, string.char, string.gmatch, string.gsub, table.insert, ui.get, ui.is_menu_open, ui.mouse_position, ui.new_slider, ui.reference, ui.set, ui.set_callback, ui.set_visible, toticks, setmetatable, string.sub, table.remove, ui.new_button, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_hotkey, ui.new_label, ui.new_multiselect, ipairs

    require, tonumber, tostring, print, pairs, error, select = require, tonumber, tostring, print, pairs, error, select

    vector = require 'vector'
    ffi = require 'ffi'
    easing = require 'gamesense/easing'
    images = require 'gamesense/images'
    anti_aim_f = require 'gamesense/antiaim_funcs'
    c_entity = require 'gamesense/entity'
    http = require 'gamesense/http'
    base64 = require 'gamesense/base64'
    clipboard = require 'gamesense/clipboard'

    ffi_cast = ffi.cast
    
    ffi.cdef [[
        typedef int(__thiscall* get_clipboard_text_count)(void*);
        typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
        typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
    ]]
    
    local VGUI_System010 =  client_create_interface('vgui2.dll', 'VGUI_System010') or print('Error finding VGUI_System010')
    local VGUI_System = ffi_cast(ffi.typeof('void***'), VGUI_System010)
    
    local get_clipboard_text_count = ffi_cast('get_clipboard_text_count', VGUI_System[ 0 ][ 7 ]) or print('get_clipboard_text_count Invalid')
    local set_clipboard_text = ffi_cast('set_clipboard_text', VGUI_System[ 0 ][ 9 ]) or print('set_clipboard_text Invalid')
    local get_clipboard_text = ffi_cast('get_clipboard_text', VGUI_System[ 0 ][ 11 ]) or print('get_clipboard_text Invalid')
    
    local buffer
    local size
    
    local function clipboard_import()
        local clipboard_text_length = get_clipboard_text_count(VGUI_System)
        local clipboard_data = ''
    
        if clipboard_text_length > 0 then
            buffer = ffi.new('char[?]', clipboard_text_length)
            size = clipboard_text_length * ffi.sizeof('char[?]', clipboard_text_length)
    
            get_clipboard_text(VGUI_System, 0, buffer, size)
    
            clipboard_data = ffi.string(buffer, clipboard_text_length - 1)
        end
        return clipboard_data
    end
    
    local function clipboard_export(string)
        if string then
            set_clipboard_text(VGUI_System, string, string:len())
        end
    end
    
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' -- You will need this for encoding/decoding
    
    local function enc(data)
        return ((data:gsub('.', function(x) 
            local r, b='', x:byte()
            for i = 8, 1, -1 do r = r .. (b%2 ^ i - b%2 ^ (i - 1) > 0 and '1' or '0') end
            return r;
        end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
            if (#x < 6) then return '' end
            local c = 0
            for i = 1, 6 do c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0) end
            return b:sub(c + 1, c + 1)
        end) .. ({ '', '==', '=' })[ #data%3 + 1 ])
    end
    
    local function dec(data)
        data = string_gsub(data, '[^' .. b .. '=]', '')
        return (data:gsub('.', function(x)
            if (x == '=') then return '' end
            local r, f = '', (b:find(x) - 1)
            for i = 6, 1, -1 do r = r .. (f%2 ^ i - f%2 ^ (i - 1) > 0 and '1' or '0') end
            return r;
        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
            if (#x ~= 8) then return '' end
            local c = 0
            for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0) end
            return string_char(c)
        end))
    end
    
    local function arr_to_string(noise)
        local str = ''
        for i = 1, #noise do
            str = str .. noise[ i ] .. (i == #noise and '' or ',')
        end
    
        if str == '' then
            str = '-'
        end
    
        return str
    end
    
    local function str_to_sub(input, sep)
        local t = {}
        for str in string_gmatch(input, '([^'..sep..']+)') do
            t[#t + 1] = string_gsub(str, '\n', '')
        end
        return t
    end
    
    local function to_boolean(str)
        if str == 'true' or str == 'false' then
            return (str == 'true')
        else
            return str
        end
    end
    
    local function SetTableVisibility(table, state)
        for i = 1, #table do
            ui_set_visible(table[ i ], state)
        end
    end
    
    local function SetTableCallback(table, item)
        for i = 1, #table do
            ui_set_callback(table[ i ], item)
        end
    end
    
    local function get_velocity(player)
        local velocity = vector(entity_get_prop(player, 'm_vecVelocity'))
        return velocity:length()
    end
    
    local function on_ground(player)
        local flags = entity_get_prop(player, 'm_fFlags')
        
        if bit_band(flags, 1) == 1 then
            return true
        end
        
        return false
    end
    
    local function in_air(player)
        local flags = entity_get_prop(player, 'm_fFlags')
        
        if bit_band(flags, 1) == 0 then
            return true
        end
        
        return false
    end
    
    local function is_crouching(player)
        local flags = entity_get_prop(player, 'm_fFlags')
        
        if bit_band(flags, 4) == 4 then
            return true
        end
        
        return false
    end
    
    local function contains(table, value)
    
        if table == nil then
            return false
        end
        
        table = ui_get(table)
        for i=0, #table do
            if table[i] == value then
                return true
            end
        end
        return false
    end
    
    local function distance3d(x1, y1, z1, x2, y2, z2)
        return math_sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
    end
    local function anti_knife_dist(x1, y1, z1, x2, y2, z2)
        return math_sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end
    
    local function scan_dmg(e, p, x, y, z)
        for i=1, 6 do
            local h = { entity_hitbox_position(e, i) }
            local ent, dmg = client_trace_bullet(p, x, y, z, h[1], h[2], h[3], p)
    
            if dmg ~= nil and dmg > 0 then
                return dmg
            end
        end
        return 0
    end
    
    local function entity_has_c4(ent)
        local bomb = entity_get_all('CC4')[1]
        return bomb ~= nil and entity_get_prop(bomb, 'm_hOwnerEntity') == ent
    end
    
    local function normalize_yaw(yaw)
        while yaw > 180 do yaw = yaw - 360 end
        while yaw < -180 do yaw = yaw + 360 end
        return yaw
    end
    
    local function round(num, decimals)
        local mult = 10^(decimals or 0)
        return math_floor(num * mult + 0.5) / mult
    end
    
    local function calc_angle(local_x, local_y, enemy_x, enemy_y)
        local ydelta = local_y - enemy_y
        local xdelta = local_x - enemy_x
        local relativeyaw = math_atan(ydelta / xdelta)
        relativeyaw = normalize_yaw(relativeyaw * 180 / math.pi)
        if xdelta >= 0 then
            relativeyaw = normalize_yaw(relativeyaw + 180)
        end
        return relativeyaw
    end
    
    local function angle_vector(angle_x, angle_y)
        local sy = math_sin(math_rad(angle_y))
        local cy = math_cos(math_rad(angle_y))
        local sp = math_sin(math_rad(angle_x))
        local cp = math_cos(math_rad(angle_x))
        return cp * cy, cp * sy, -sp
    end
    
    local function get_eye_pos(ent)
        local x, y, z = entity_get_prop(ent, 'm_vecOrigin')
        local hx, hy, hz = entity_hitbox_position(ent, 0)
        return x, y, hz
    end
    
    local function rotate_point(x, y, rot, size)
        return math_cos(math_rad(rot)) * size + x, math_sin(math_rad(rot)) * size + y
    end
    
    local function renderer_arrow(x, y, r, g, b, a, rotation, size)
        local x0, y0 = rotate_point(x, y, rotation, 45)
        local x1, y1 = rotate_point(x, y, rotation + (size / 3.5), 45 - (size / 4))
        local x2, y2 = rotate_point(x, y, rotation - (size / 3.5), 45 - (size / 4))
        renderer_triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
    end
    
    local function calc_shit(xdelta, ydelta)
        if xdelta == 0 and ydelta == 0 then
            return 0
        end
        
        return math_deg(math_atan2(ydelta, xdelta))
    end
    
    local function sway(max, speed, min)
        return math_abs(math_floor((math_sin(globals_curtime()/speed*1)*max)))
    end
    
    local function get_damage(plocal, enemy, x, y,z)
        local ex = { }
        local ey = { }
        local ez = { }
        ex[0], ey[0], ez[0] = entity_hitbox_position(enemy, 1)
        ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
        ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
        ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
        ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
        ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
        ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
        local ent
        local dmg = 0
        for i=0, 6 do
            if dmg == 0 or dmg == nil then
                ent, dmg = client_trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
            end
        end
        return ent == nil and client_scale_damage(plocal, 1, dmg) or dmg
    end
    
    local function item_count(tab)
        if tab == nil then return 0 end
        if #tab == 0 then
            local val = 0
            for k in pairs(tab) do
                val = val + 1
            end
    
            return val
        end
    
        return #tab
    end
    
    local force_teammates = false or ui_get(ui_reference('Visuals', 'Player ESP', 'Teammates'))
    
    local function get_entities(enemy_only, alive_only)
        local enemy_only = enemy_only ~= nil and enemy_only or false
        local alive_only = alive_only ~= nil and alive_only or true
    
        local result = { }
    
        local player_resource = entity_get_player_resource()
    
        for player = 1, globals_maxplayers() do
            if entity_get_prop(player_resource, 'm_bConnected', player) == 1 then
                local is_enemy, is_alive = true, true
    
                if enemy_only and not force_teammates and not entity_is_enemy(player) then is_enemy = false end
                if is_enemy then
                    if alive_only and entity_get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
                    if is_alive then table_insert(result, player) end
                end
            end
        end
    
        return result
    end
    
    local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
        local output = ''
    
        local len = #text-1
    
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len
    
        for i=1, len+1 do
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
    
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end
    
        return output
    end
    
    local last_sim_time = 0
    local defensive_until = 0
    
    local function is_defensive_active()
        local tickcount = globals_tickcount()
        local sim_time = toticks(entity_get_prop(entity_get_local_player(), 'm_flSimulationTime'))
        local sim_diff = sim_time - last_sim_time
        
        if sim_diff < 0 then
            defensive_until = tickcount + math_abs(sim_diff) - toticks(client_latency())
        end
        
        last_sim_time = sim_time
        return sim_diff
    end
    
    local lerp = function(a, b, percentage) return a + (b - a) * percentage end
    
    local dragging_fn = function(name, base_x, base_y) return (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client_screen_size()ui_set(self.x_reference,q/j*self.res)ui_set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client_screen_size()return ui_get(self.x_reference)/self.res*j,ui_get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client_screen_size()local y=ui_new_slider('LUA','A',u..' window position',0,x,v/j*x)local z=ui_new_slider('LUA','A','\n'..u..' window position y',0,x,w/k*x)ui_set_visible(y,false)ui_set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals_framecount()~=b then c=ui_is_menu_open()f,g=d,e;d,e=ui_mouse_position()i=h;h=client_key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client_screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math_max(0,math_min(j-A,q))r=math_max(0,math_min(k-B,r))end end end;table_insert(l,{q,r,A,B})return q,r,A,B end;return a end)().new(name, base_x, base_y) end
    
    local Render_engine=(function()local self={}local b=function(c,d,e,f,g,h,i)local j=0;if g==0 then return end;renderer_rectangle(c+h+j,d+h+j,e-h*2-j*2,f-h*2-j*2,17,17,17,g)renderer_circle(c+e-h-j,d+h+j,17,17,17,g,h,90,0.25)renderer_circle(c+e-h-j,d+f-h-j,17,17,17,g,h,360,0.25)renderer_circle(c+h+j,d+f-h-j,17,17,17,g,h,270,0.25)renderer_circle(c+h+j,d+h+j,17,17,17,g,h,180,0.25)renderer_rectangle(c+h+j,d+j,e-h*2-j*2,h,17,17,17,g)renderer_rectangle(c+e-h-j,d+h+j,h,f-h*2-j*2,17,17,17,g)renderer_rectangle(c+h+j,d+f-h-j,e-h*2-j*2,h,17,17,17,g)renderer_rectangle(c+j,d+h+j,h,f-h*2-j*2,17,17,17,g)end;local k=function(c,d,e,f,l,m,n,o,p,h,i)local j=h==0 and i or 0;renderer_rectangle(c+h,d,e-h*2,i,l,m,n,o)renderer_circle_outline(c+e-h,d+h,l,m,n,o,h,270,0.25,i)renderer_gradient(c+e-i,d+h+j,i,f-h*2-j*2,l,m,n,o,l,m,n,p,false)renderer_circle_outline(c+e-h,d+f-h,l,m,n,p,h,360,0.25,i)renderer_rectangle(c+h,d+f-i,e-h*2,i,l,m,n,p)renderer_circle_outline(c+h,d+f-h,l,m,n,p,h,90,0.25,i)renderer_gradient(c,d+h+j,i,f-h*2-j*2,l,m,n,o,l,m,n,p,false)renderer_circle_outline(c+h,d+h,l,m,n,o,h,180,0.25,i)end;self.render_container=function(c,d,e,f,l,m,n,o,p,g,h,i,q)local r=o~=0 and g or o;local s=o~=0 and p or o;b(c,d,e,f,r,h,i)k(c,d,e,f,l,m,n,o,s,h,i)if q and g~=255 and o~=0 then end end;return self end)()
    
    local math_clamp = function(val, min, max) return math_min(max, math_max(min, val)) end
    local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
    local gram_update = function(tab, value, forced) local new_tab = tab; if forced or new_tab[#new_tab] ~= value then table_insert(new_tab, value); table_remove(new_tab, 1); end; tab = new_tab; end
    local get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end
    
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
    
    do
        for key, easing_func in pairs(easing) do
            easing[key] = function (t, b, c, d, ...)
                return math_clamp(easing_func(t, b, c, d, ...), b, d)
            end
        end
    end
    
    local classptr = ffi.typeof('void***')
    local rawivengineclient = client_create_interface('engine.dll', 'VEngineClient014') or error('VEngineClient014 wasnt found', 2)
    local ivengineclient = ffi.cast(classptr, rawivengineclient) or error('rawivengineclient is nil', 2)
    local is_in_game = ffi.cast('bool(__thiscall*)(void*)', ivengineclient[0][26]) or error('is_in_game is nil')
    
    local get_name = panorama_loadstring([[ return MyPersonaAPI.GetName() ]])
    
    local var = {
        conditions = { 'Global', 'Standing', 'Moving', 'T Crouching', 'CT Crouching', 'Slow Walk', 'In Air duck', 'In Air', 'Legit AA', 'Fakelag', 'Warmup', 'Defensive Flick' },
        conditions_to_int = {
            [ 'Global' ] = 1,
            [ 'Standing' ] = 2,
            [ 'Moving' ] = 3,
            [ 'T Crouching' ] = 4,
            [ 'CT Crouching' ] = 5,
            [ 'Slow Walk' ] = 6,
            [ 'In Air duck' ] = 7,
            [ 'In Air' ] = 8,
            [ 'Legit AA' ] = 9,
            [ 'Fakelag' ] = 10,
            [ 'Warmup' ] = 11,
            [ 'Defensive Flick' ] = 12
        },
        override_conditions = { 'Stand', 'Move', 'T Crouch', 'CT Crouch', 'Slowwalk', 'Air duck', 'Air', 'Legitaa', 'Fakelag', 'Defensive Flick' },
        override_conditions_to_int = {
            [ 'Stand' ] = 1,
            [ 'Move' ] = 2,
            [ 'T Crouch' ] = 3,
            [ 'CT Crouch' ] = 4,
            [ 'Slowwalk' ] = 5,
            [ 'Air duck' ] = 6,
            [ 'Air' ] = 7,
            [ 'Legitaa' ] = 8,
            [ 'Fakelag' ] = 9,
            [ 'Defensive Flick' ] = 10
        },
        active_idx = 1,
        player_state = 0,
        antiaim_state = 'Global',
        best_value = 180,
        changer_state = 0,
        bestenemy = 0,
        last_nn = 0,
        miss = { },
        hit = { },
        shots = { },
        last_hit = { },
        stored_misses = { },
        stored_shots = { },
        fs_disabled = 0,
        main_yaw_value = 0,
        main_bodyyaw_value = 0,
        main_fakelimit_value = 0,
        preset_yaw_value = 0,
        preset_bodyyaw_value = 0,
        preset_fakelimit_value = 0,
        builder_yaw_value = 0,
        builder_bodyyaw_value = 0,
        builder_fakelimit_value = 0,
        legitaaon = false,
        aa_dir = 0,
        roll_enabled = false,
        lastshot = 0,
        last_press_t = 0,
        delay = 0,
        timer = 0,
        delayvalue = 0,
        lp_hit = 0,
        lp_miss = 0,
        enemy_shot_time = 0,
        dtclr = 0,
        lastUpdate = 0,
        ab_time = 0,
        ab_timer = 0,
        abmisses = 0,
        ab_type = 'R',
        roll_alpha = 0,
        classnames = {
            'CWorld',
            'CCSPlayer',
            'CFuncBrush'
        },
        nonweapons = {
            'knife',
            'hegrenade',
            'inferno',
            'flashbang',
            'decoy',
            'smokegrenade',
            'taser'
        }
    }
    
    local keybinds_references = { }
    
    local function create_item(tab, container, name, arg, cname)
        local collected = { }
        local reference = { ui_reference(tab, container, name) }
    
        for i=1, #reference do
            if i <= arg then
                collected[i] = reference[i]
            end
        end
    
        keybinds_references[cname or name] = collected
    end
    
    local menudir =  { 'AA', 'Anti-aimbot angles' }
    
    local ref = {
        enabled = ui_reference('AA', 'Anti-aimbot angles', 'Enabled'),
        pitch = { ui_reference('AA', 'Anti-aimbot angles', 'Pitch') },
        yaw_base = ui_reference('AA', 'Anti-aimbot angles', 'Yaw base'),
        yaw = { ui_reference('AA', 'Anti-aimbot angles', 'Yaw') },
        yaw_jitter = {ui_reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
        body_yaw = { ui_reference('AA', 'Anti-aimbot angles', 'Body yaw') },
        freestanding_body_yaw = ui_reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw'),
        fake_yaw_limit = ui_reference('AA', 'Anti-aimbot angles', 'Fake yaw limit'),
        edge_yaw = ui_reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
        roll = ui_reference('AA', 'Anti-aimbot angles', 'Roll'),
        freestanding = { ui_reference('AA', 'Anti-aimbot angles', 'Freestanding') },
        slowwalk = { ui_reference('AA', 'Other', 'Slow motion') },
        leg_movement = ui_reference('AA', 'Other', 'Leg movement'),
        doubletap = { ui_reference('RAGE', 'Other', 'Double tap') },
        doubletapfl = ui.reference('RAGE', 'Other', 'Double tap fake lag limit'),
        fakeduck = ui_reference('RAGE', 'Other', 'Duck peek assist'),
        safepoint = ui_reference('RAGE', 'Aimbot', 'Force safe point'),
        forcebaim = ui_reference('RAGE', 'Other', 'Force body aim'),
        quickpeek = { ui_reference('RAGE', 'Other', 'Quick peek assist') },
        onshotaa = { ui_reference('AA', 'Other', 'On shot anti-aim') },
        fakelag = { ui_reference('AA', 'Fake lag', 'Enabled') },
        amout = ui.reference('AA', 'Fake lag', 'Amount'),
        variance = ui.reference('AA', 'Fake lag', 'Variance'),
        ping_spike = { ui_reference('MISC', 'Miscellaneous', 'Ping spike') },
        sv_maxusrcmdprocessticks = ui_reference('MISC', 'Settings', 'sv_maxusrcmdprocessticks'),
    }
    
    ui_set_visible(ref.sv_maxusrcmdprocessticks, true)

    local master_switch = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Enable ETHEREAL anti-aim system')
    
    local active_tab = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Tabs', { 'Anti-Aim', 'Visuals', 'Misc', 'Config' })
    
    --aatab
    local aa_tab = {
        main_aa = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Enable ETHEREAL preset anti-aim'),
        antibruteforce = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Enable ETHEREAL antibruteforce'),
        antibruteforce_conditions = ui_new_multiselect(menudir[ 1 ], menudir[ 2 ], 'Antibruteforce conditions', { 'Stand', 'Move', 'T Crouch', 'CT Crouch', 'Slowwalk', 'Air duck', 'Air', 'Legitaa'--[[, 'Roll']] }),
        antibruteforce_type = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Antibruteforce type', { 'Opposite', 'Missed body' }),
        roll_conditions = ui_new_multiselect(menudir[ 1 ], menudir[ 2 ], 'Roll anti-aim conditions', { 'Stand', 'T Crouch', 'CT Crouch', 'Slowwalk'--[[, 'Manual anti-aim']] }),
        binds = ui_new_multiselect(menudir[ 1 ], menudir[ 2 ], 'Binds', { 'Legit anti-aimbot', 'Edge yaw', 'Freestanding', 'Roll anti-aim', 'Manual anti-aim' }),
        legit_aa_key = ui_new_hotkey(menudir[ 1 ], menudir[ 2 ], 'Legit anti-aimbot', false, 0x45),
        edge_yaw = ui_new_hotkey(menudir[ 1 ], menudir[ 2 ], 'Edge yaw', false),
        freestanding = ui_new_hotkey(menudir[ 1 ], menudir[ 2 ], 'Freestanding', false),
        roll_aa = ui_new_hotkey(menudir[ 1 ], menudir[ 2 ], 'Roll anti-aim', false),
        manual_left = ui_new_hotkey(menudir[ 1 ], menudir[ 2 ], 'Manual left   <', false),
        manual_right = ui_new_hotkey(menudir[ 1 ], menudir[ 2 ], 'Manual right >', false),
        legit_aa_type = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Legit anti-aimbot type', { 'Static', 'Center Jitter' }),
        force_flick = ui_new_hotkey(menudir[ 1 ], menudir[ 2 ], 'Defensive flick [WIP]'),
        freestanding_dis = ui_new_multiselect(menudir[ 1 ], menudir[ 2 ], 'Freestanding disablers', { 'Slow motion', 'In air', 'Crouching', 'Running'--[[, 'Roll']] }),
        --manual_aa_type = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Manual anti-aim type', { 'Local view', 'At targets' }),
    }
    
    local vis_tab = {
        ui_label2 = ui_new_label(menudir[ 1 ], menudir[ 2 ], ' '),
        --ui_animtype = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Keybinds animation type', { 'Normal', 'Legacy' }),
        crosshair_animstyle = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Crosshair Animation style', { 'New', 'Old' }),
        crosshair_style = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Crosshair style', { 'gradient', 'New','New V2','off' }),
        crosshair_main_animspeed = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Crosshair Animation speed', 1, 100, 10, true, 'fr'),
        crosshair_main_animstyle = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Crosshair Animation style', { 'Circle', 'Straight' }),
        crosshair_direction = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Crosshair Animation direction', { 'Right', 'Left' }),
        crosshair_height = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Crosshair offset', -60, 100, 20),
        crosshair_animspeed = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Crosshair animation speed', 2, 20, 5, true, 'fr'),
        crosshair_separator = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Crosshair separator', 7, 20, 8, true, 'px'),
        crosshair_font = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Crosshair font', { 'Small', 'Normal', 'Bold', 'Big' }),
        crosshair_placement = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Crosshair placement', { 'Center', 'Right', 'Left' }),
        crosshair_color_label1 = ui_new_label(menudir[ 1 ], menudir[ 2 ], 'Crosshair color 1'),
        crosshair_color1 = ui_new_color_picker(menudir[ 1 ], menudir[ 2 ], 'Crosshair clr 1', 112, 112, 112, 150),
        crosshair_color_label2 = ui_new_label(menudir[ 1 ], menudir[ 2 ], 'Crosshair color 2'),
        crosshair_color2 = ui_new_color_picker(menudir[ 1 ], menudir[ 2 ], 'Crosshair clr 2', 255, 255, 255, 255)
    }
    
    local misc_tab = {
        resolve_flag = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Resolve flag'),
        clantag = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'ETHEREAL clan tag'),
        leg_anim_breaker = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Leg breaker'),
        fakelag_break = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Fakelag breaker'),
        leg_in_air = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Static legs in air'),
        anti_backstab = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Enable Anti backstab'),
        anti_backstab_distance = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Anti backstab Distance', 50, 400, 180, true, '', 1, true),
        force_def = ui_new_hotkey(menudir[ 1 ], menudir[ 2 ], 'Force Defensive'),
        pitch_breaker = ui_new_hotkey(menudir[ 1 ], menudir[ 2 ], 'Pitch breaker'),
        pitch_breaker_val = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Pitch breaker UP val', -89, 89, 0, true, '', 1, true),
    }

    local config_tab = {
    }
    
    --preset changer
    local preset_changer = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Preset changer')
    local preset_selector = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Preset selector', var.override_conditions)
    
    local preset_change = { }
    
    for i = 1, #var.override_conditions do
        preset_change[ i ] = {
            enabled = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Enable preset [' .. var.override_conditions[ i ] .. ']'),
            pitch = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Pitch\n' .. var.override_conditions[ i ], { 'Off', 'Default', 'Up', 'Down', 'Minimal','Custom','CustomLR','Spin', 'Random', '3way' }),
            custompitch = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'custom pitch [' .. var.override_conditions[ i ] .. ']', -89, 89, 0),

            pitch_left = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Left Pitch add [' .. var.override_conditions[ i ] .. ']', -89, 89, 0),
            pitch_right = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Right Pitch add [' .. var.override_conditions[ i ] .. ']', -89, 89, 0),

            yaw_1 = ui_new_slider(menudir[ 1 ], menudir[ 2 ], '1 Yaw add [' .. var.override_conditions[ i ] .. ']', -180, 180, 0),

            yaw_left = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Left Yaw add [' .. var.override_conditions[ i ] .. ']', -180, 180, 0),
            yaw_right = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Right Yaw add [' .. var.override_conditions[ i ] .. ']', -180, 180, 0),
            yaw_jitter = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Yaw jitter [' .. var.override_conditions[ i ] .. ']', { 'Off', 'Offset', 'Center', 'Random', 'CustomLR', '3way' }),
            yaw_jitter_add = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Yaw jitter add [' .. var.override_conditions[ i ] .. ']', -180, 180, 0),

            yaw_jitter_add_1 = ui_new_slider(menudir[ 1 ], menudir[ 2 ], '1 Yaw jitter add [' .. var.override_conditions[ i ] .. ']', -180, 180, 0),

            yaw_jitter_left = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Left Yaw jitter add [' .. var.override_conditions[ i ] .. ']', -180, 180, 0),
            yaw_jitter_right = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Right Yaw jitter add [' .. var.override_conditions[ i ] .. ']', -180, 180, 0),

            freestand_body_yaw = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Freestand body yaw [' .. var.override_conditions[ i ] .. ']', { 'Gamesense', 'Freestanding', 'Reversed Freestanding', 'Jitter', 'Delay body', 'Random body' }),--[[, 'Smart']]
            body_yaw = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Body yaw [' .. var.override_conditions[ i ] .. ']', { 'Off', 'Opposite', 'Jitter', 'Static' }),

            defensive_brute = ui_new_multiselect(menudir[ 1 ], menudir[ 2 ], 'Defensive break [' .. var.override_conditions[ i ] .. ']', {'Yaw', 'Pitch'}),
            defensive_brute_tick = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Break Tick [' .. var.override_conditions[ i ] .. ']', 2, 12, 12),
            defensive_brute_yaw = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Yaw break [' .. var.override_conditions[ i ] .. ']', -180, 180, 0),
            defensive_brute_pitch = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Pitch break [' .. var.override_conditions[ i ] .. ']', -89, 89, 0),

            freestanding_body_yaw = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Freestanding body yaw [' .. var.override_conditions[ i ] .. ']'),
            body_yaw_left = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Right Body yaw add [' .. var.override_conditions[ i ] .. ']', -180, 180, 0),
            body_yaw_right = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Left Body yaw add [' .. var.override_conditions[ i ] .. ']', -180, 180, 0),
            fake_limit_left = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Left Fake limit [' .. var.override_conditions[ i ] .. ']', 0, 60, 60),
            fake_limit_right = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Right Fake limit [' .. var.override_conditions[ i ] .. ']', 0, 60, 60)
        }
    end
    
    --aabuilder
    local conditional_aa = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'AA Builder')
    local active_condition = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Active condition', var.conditions)
    
    local anti_aim = { }
    
    for i = 1, #var.conditions do
        anti_aim[ i ] = {
            enabled = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Enable ' .. var.conditions[ i ] .. ' condition'),
            pitch = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Pitch\n' .. var.conditions[ i ], { 'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random' }),
            yaw_base = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Yaw base\n[' .. var.conditions[ i ], { 'Local view', 'At targets' }),
            yaw = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Yaw\n' .. var.conditions[ i ], { 'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair' }),
            yaw_add = ui_new_slider(menudir[ 1 ], menudir[ 2 ], '\nYaw add' .. var.conditions[ i ], -180, 180, 0),
            yaw_jitter = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Yaw jitter\n' .. var.conditions[ i ], { 'Off', 'Offset', 'Center', 'Random' }),
            yaw_jitter_add = ui_new_slider(menudir[ 1 ], menudir[ 2 ], '\nYaw jitter add' .. var.conditions[ i ], -180, 180, 0),
            body_yaw = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Body yaw\n' .. var.conditions[ i ], { 'Off', 'Opposite', 'Jitter', 'Static' }),
            body_yaw_add = ui_new_slider(menudir[ 1 ], menudir[ 2 ], '\nBody yaw add' .. var.conditions[ i ], -180, 180, 0),
            freestanding_body_yaw = ui_new_checkbox(menudir[ 1 ], menudir[ 2 ], 'Freestanding body yaw\n' .. var.conditions[ i ]),
            fake_yaw_limit = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Fake yaw limit\n' .. var.conditions[ i ], 0, 60, 60),
            fake_limit_mode = ui_new_combobox(menudir[ 1 ], menudir[ 2 ], 'Fake limit modifier\n' .. var.conditions[ i ], { 'Off', 'Jitter', 'Random', 'Custom bodys' }),
            fake_limit_modifier = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Fake yaw randomization\n' .. var.conditions[ i ], 0, 60, 60),
            fake_limit_left = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Fake limit left \n' .. var.conditions[ i ], 0, 60, 60),
            fake_limit_right = ui_new_slider(menudir[ 1 ], menudir[ 2 ], 'Fake limit right \n' .. var.conditions[ i ], 0, 60, 60)
        }
    end
    ---
    ---
    
    local function load_cfg(input)
        local tbl = str_to_sub(input, '|')
        local number = 21
        ui_set(master_switch, true)
    
        for i = 1, #var.override_conditions do
            ui_set(preset_change[ i ].enabled, to_boolean(tbl[ 1 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].pitch, tbl[ 2 + (number * (i - 1)) ])
            ui_set(preset_change[ i ].yaw_left, tonumber(tbl[ 3 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].yaw_right, tonumber(tbl[ 4 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].yaw_jitter, tbl[ 5 + (number * (i - 1)) ])
            ui_set(preset_change[ i ].yaw_jitter_add, tonumber(tbl[ 6 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].freestand_body_yaw, tbl[ 7 + (number * (i - 1)) ])
            ui_set(preset_change[ i ].body_yaw, tbl[ 8 + (number * (i - 1)) ])
            ui_set(preset_change[ i ].freestanding_body_yaw, to_boolean(tbl[ 9 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].body_yaw_left, tonumber(tbl[ 10 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].body_yaw_right, tonumber(tbl[ 11 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].fake_limit_left, tonumber(tbl[ 12 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].fake_limit_right, tonumber(tbl[ 13 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].yaw_1, tonumber(tbl[ 14 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].yaw_jitter_left, tonumber(tbl[ 15 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].yaw_jitter_right, tonumber(tbl[ 16 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].yaw_jitter_add_1, tonumber(tbl[ 17 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].defensive_brute_tick, tonumber(tbl[ 18 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].defensive_brute_yaw, tonumber(tbl[ 19 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].defensive_brute_pitch, tonumber(tbl[ 20 + (number * (i - 1)) ]))
            ui_set(preset_change[ i ].defensive_brute, str_to_sub(tbl[21 + (21* (i - 1))], ','))
        end
    
        client_log('Loaded config from clipboard')
    end
    
    local function export_cfg()
        local SB = ''
    
        for i = 1, #var.override_conditions do
            --tostring = checkbox, combobox,  tonumber = slider, arr_to_string = multiselect
    
            SB = SB .. tostring(ui_get(preset_change[ i ].enabled)) .. '|'
            .. tostring(ui_get(preset_change[ i ].pitch)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].yaw_left)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].yaw_right)) .. '|'
            .. tostring(ui_get(preset_change[ i ].yaw_jitter)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].yaw_jitter_add)) .. '|'
            .. tostring(ui_get(preset_change[ i ].freestand_body_yaw)) .. '|'
            .. tostring(ui_get(preset_change[ i ].body_yaw)) .. '|'
            .. tostring(ui_get(preset_change[ i ].freestanding_body_yaw)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].body_yaw_left)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].body_yaw_right)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].fake_limit_left)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].fake_limit_right)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].yaw_1)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].yaw_jitter_left)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].yaw_jitter_right)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].yaw_jitter_add_1)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].defensive_brute_tick)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].defensive_brute_yaw)) .. '|'
            .. tonumber(ui_get(preset_change[ i ].defensive_brute_pitch)) .. '|'
            .. arr_to_string(ui_get(preset_change[ i ].defensive_brute)) .. '|'
        end
    
        clipboard_export(SB)
        client_log('Exported config to clipboard')
    end
    --
    local load_def = ui_new_button(menudir[ 1 ], menudir[ 2 ], 'Load default settings', function()
        ui_set(aa_tab.main_aa, true)
        ui_set(preset_changer, true)
        ui_set(misc_tab.leg_anim_breaker, true)
        ui_set(misc_tab.leg_in_air, true)
        ui_set(aa_tab.binds, { 'Legit anti-aimbot', 'Freestanding','Manual anti-aim'})
        ui_set(aa_tab.freestanding_dis, { 'Slow motion', 'In air', 'Crouching'})
        ui_set(vis_tab.crosshair_style, 'gradient')
        ui_set(vis_tab.crosshair_animstyle, 'New')
        ui_set(vis_tab.crosshair_color1, 129,198,255, 255)
        ui_set(vis_tab.crosshair_color2, 255, 255, 255, 255)
        load_cfg('true|3way|-35|29|Off|12|Gamesense|Static|false|12|14|59|59|12|55|55|79|12|0|0|-|true|Minimal|4|4|3way|73|Gamesense|Static|false|0|0|54|55|-16|-70|-70|84|8|-180|0|-|true|Minimal|0|0|3way|52|Gamesense|Jitter|false|0|0|54|55|0|0|0|20|12|0|0|-|true|Minimal|0|0|3way|52|Gamesense|Jitter|false|0|0|53|51|0|0|0|20|10|0|0|-|true|Minimal|5|5|Center|82|Gamesense|Jitter|false|0|0|37|37|-38|77|84|77|8|9|0|Yaw|true|Minimal|0|0|3way|8|Gamesense|Jitter|false|0|0|53|52|-7|61|68|45|11|0|-89|-|true|Minimal|0|0|Off|9|Gamesense|Opposite|true|0|-180|60|60|-7|9|-9|9|12|0|0|-|true|Off|0|0|CustomLR|75|Jitter|Jitter|false|0|0|59|17|-180|68|75|0|12|0|0|-|true|Minimal|6|6|Off|0|Gamesense|Static|false|10|0|59|59|0|0|0|0|12|0|0|-|true|Random|-100|100|Random|180|Gamesense|Static|false|0|0|60|60|-180|0|0|0|12|0|0|-|')
    end)
    
    local import_button = ui_new_button('AA', 'Anti-aimbot angles', 'Import settings', function()
        ui_set(aa_tab.main_aa, true)
        ui_set(preset_changer, true)
        load_cfg(clipboard_import())
    end)
    
    local export_button = ui_new_button('AA', 'Anti-aimbot angles', 'Export settings', function()
        export_cfg()
    end)

    for i=1, 64 do
        var.miss[i], var.hit[i], var.shots[i], var.last_hit[i], var.stored_misses[i], var.stored_shots[i] = {}, {}, {}, 0, 0, 0
        for k=1, 3 do
            var.miss[i][k], var.hit[i][k], var.shots[i][k] = {}, {}, {}
            for j=1, 1000 do
                var.miss[i][k][j], var.hit[i][k][j], var.shots[i][k][j] = 0, 0, 0
            end
        end
        var.miss[i][4], var.hit[i][4], var.shots[i][4] = 0, 0, 0
    end
    
    local function handle_menu()
        local master_switch = ui_get(master_switch)
        local activetab = ui_get(active_tab)
    
        local main_aa_enabled = ui_get(aa_tab.main_aa)
    
        ui_set_visible(active_tab, master_switch)
    
        --aa tab
        ui_set_visible(aa_tab.main_aa, master_switch and activetab == 'Anti-Aim')
        ui_set_visible(aa_tab.force_flick, master_switch and activetab == 'Anti-Aim')
        ui_set_visible(aa_tab.antibruteforce, master_switch and activetab == 'Anti-Aim' and ui_get(aa_tab.main_aa))
        ui_set_visible(aa_tab.antibruteforce_conditions, master_switch and activetab == 'Anti-Aim' and ui_get(aa_tab.main_aa) and ui_get(aa_tab.antibruteforce))
        ui_set_visible(aa_tab.antibruteforce_type, master_switch and activetab == 'Anti-Aim' and ui_get(aa_tab.main_aa) and ui_get(aa_tab.antibruteforce))
        ui_set_visible(aa_tab.roll_conditions, master_switch and activetab == 'Anti-Aim' and ui_get(aa_tab.main_aa))
        ui_set_visible(aa_tab.binds, master_switch and activetab == 'Anti-Aim')
        ui_set_visible(aa_tab.edge_yaw, master_switch and contains(aa_tab.binds, 'Edge yaw') and activetab == 'Anti-Aim')
        ui_set_visible(aa_tab.freestanding, master_switch and contains(aa_tab.binds, 'Freestanding') and activetab == 'Anti-Aim')
        ui_set_visible(aa_tab.freestanding_dis, master_switch and contains(aa_tab.binds, 'Freestanding') and activetab == 'Anti-Aim')
        ui_set_visible(aa_tab.legit_aa_key, master_switch and contains(aa_tab.binds, 'Legit anti-aimbot') and activetab == 'Anti-Aim')
        ui_set_visible(aa_tab.legit_aa_type, master_switch and contains(aa_tab.binds, 'Legit anti-aimbot') and activetab == 'Anti-Aim')
        ui_set_visible(aa_tab.roll_aa, master_switch and activetab == 'Anti-Aim' and contains(aa_tab.binds, 'Roll anti-aim'))
        ui_set_visible(aa_tab.manual_left, master_switch and activetab == 'Anti-Aim' and contains(aa_tab.binds, 'Manual anti-aim'))
        ui_set_visible(aa_tab.manual_right, master_switch and activetab == 'Anti-Aim' and contains(aa_tab.binds, 'Manual anti-aim'))
        ui_set_visible(ref.leg_movement, not ui_get(misc_tab.leg_anim_breaker))
        ---
    
        --vis tab
        ui_set_visible(vis_tab.crosshair_animstyle, master_switch and activetab == 'Visuals')
        ui_set_visible(vis_tab.crosshair_style, master_switch and activetab == 'Visuals')
        ui_set_visible(vis_tab.crosshair_main_animspeed, master_switch and activetab == 'Visuals' and ui_get(vis_tab.crosshair_style) == 'New')
        ui_set_visible(vis_tab.crosshair_main_animstyle, master_switch and activetab == 'Visuals' and ui_get(vis_tab.crosshair_style) == 'New')
        ui_set_visible(vis_tab.crosshair_direction, master_switch and activetab == 'Visuals' and ui_get(vis_tab.crosshair_main_animstyle) == 'Straight' and ui_get(vis_tab.crosshair_style) == 'New')
        ui_set_visible(vis_tab.crosshair_height, master_switch and activetab == 'Visuals')
        ui_set_visible(vis_tab.crosshair_animspeed, master_switch and activetab == 'Visuals')
        ui_set_visible(vis_tab.crosshair_separator, master_switch and activetab == 'Visuals')
        ui_set_visible(vis_tab.crosshair_font, master_switch and activetab == 'Visuals')
        ui_set_visible(vis_tab.crosshair_placement, master_switch and activetab == 'Visuals')
        ui_set_visible(vis_tab.crosshair_color_label1, master_switch and activetab == 'Visuals')
        ui_set_visible(vis_tab.crosshair_color1, master_switch and activetab == 'Visuals')
        ui_set_visible(vis_tab.crosshair_color_label2, master_switch and activetab == 'Visuals')
        ui_set_visible(vis_tab.crosshair_color2, master_switch and activetab == 'Visuals')
        ---
    
        --misc tab
        ui_set_visible(misc_tab.resolve_flag, master_switch and activetab == 'Misc')
        ui_set_visible(misc_tab.clantag, master_switch and activetab == 'Misc')
        ui_set_visible(misc_tab.leg_anim_breaker, master_switch and activetab == 'Misc')
        ui_set_visible(misc_tab.leg_in_air, master_switch and activetab == 'Misc')
        ui_set_visible(misc_tab.fakelag_break, master_switch and activetab == 'Misc')
        ui_set_visible(misc_tab.force_def, master_switch and activetab == 'Misc')
        ui_set_visible(misc_tab.pitch_breaker, master_switch and activetab == 'Misc')
        ui_set_visible(misc_tab.pitch_breaker_val, master_switch and activetab == 'Misc')
        ui_set_visible(misc_tab.anti_backstab, master_switch and activetab == 'Misc')
        ui_set_visible(misc_tab.anti_backstab_distance, master_switch and activetab == 'Misc')
        
        ---
        ui_set_visible(import_button, master_switch and activetab == 'Config')
        ui_set_visible(export_button, master_switch and activetab == 'Config')
        ui_set_visible(load_def, master_switch and activetab == 'Config')

        --preset changer
        local preset_changer_enabled = ui_get(preset_changer) and master_switch and activetab == 'Anti-Aim' and main_aa_enabled 
    
        ui_set_visible(preset_changer, master_switch and activetab == 'Anti-Aim' and main_aa_enabled)
        ui_set_visible(preset_selector, preset_changer_enabled)
    
        for i = 1, #var.override_conditions do
            local show = ui_get(preset_selector) == var.override_conditions[ i ] and preset_changer_enabled
    
            local show_conditions = show and ui_get(preset_change[ i ].enabled)
    
            ui_set_visible(preset_change[ i ].enabled, show)
            ui_set_visible(preset_change[ i ].pitch, show_conditions)
            ui_set_visible(preset_change[ i ].custompitch, show_conditions and ui_get(preset_change[ i ].pitch) == 'Custom')

            ui_set_visible(preset_change[ i ].pitch_left, show_conditions and ui_get(preset_change[ i ].pitch) == 'CustomLR')
            ui_set_visible(preset_change[ i ].pitch_right, show_conditions and ui_get(preset_change[ i ].pitch) == 'CustomLR')

            ui_set_visible(preset_change[ i ].yaw_1, show_conditions and ui_get(preset_change[ i ].pitch) == '3way')

            ui_set_visible(preset_change[ i ].yaw_left, show_conditions and ui_get(preset_selector) ~= 'Legitaa' and ui_get(preset_change[ i ].pitch) ~= '3way')
            ui_set_visible(preset_change[ i ].yaw_right, show_conditions and ui_get(preset_selector) ~= 'Legitaa' and ui_get(preset_change[ i ].pitch) ~= '3way')
            ui_set_visible(preset_change[ i ].yaw_jitter, show_conditions)
            ui_set_visible(preset_change[ i ].yaw_jitter_add, show_conditions and ui_get(preset_change[ i ].yaw_jitter) ~= 'Off' and ui_get(preset_change[ i ].yaw_jitter) ~= 'CustomLR' and ui_get(preset_change[ i ].yaw_jitter) ~= '3way')

            ui_set_visible(preset_change[ i ].yaw_jitter_left, show_conditions and ui_get(preset_change[ i ].yaw_jitter) == 'CustomLR')
            ui_set_visible(preset_change[ i ].yaw_jitter_right, show_conditions and ui_get(preset_change[ i ].yaw_jitter) == 'CustomLR')

            
            ui_set_visible(preset_change[ i ].defensive_brute, show_conditions)
            ui_set_visible(preset_change[ i ].defensive_brute_tick, show_conditions)
            ui_set_visible(preset_change[ i ].defensive_brute_yaw, show_conditions and contains(preset_change[ i ].defensive_brute, 'Yaw'))
            ui_set_visible(preset_change[ i ].defensive_brute_pitch, show_conditions and contains(preset_change[ i ].defensive_brute, 'Pitch'))
            
            ui_set_visible(preset_change[ i ].yaw_jitter_add_1, show_conditions and ui_get(preset_change[ i ].yaw_jitter) == '3way')
            
            ui_set_visible(preset_change[ i ].freestand_body_yaw, show_conditions)
            ui_set_visible(preset_change[ i ].body_yaw, show_conditions and ui_get(preset_change[ i ].freestand_body_yaw) == 'Gamesense')
            ui_set_visible(preset_change[ i ].body_yaw_left, show_conditions and ui_get(preset_change[ i ].body_yaw) ~= 'Off' and ui_get(preset_change[ i ].body_yaw) ~= 'Opposite' and ui_get(preset_change[ i ].freestand_body_yaw) == 'Gamesense')
            ui_set_visible(preset_change[ i ].body_yaw_right, show_conditions and ui_get(preset_change[ i ].body_yaw) ~= 'Off' and ui_get(preset_change[ i ].body_yaw) ~= 'Opposite' and ui_get(preset_change[ i ].freestand_body_yaw) == 'Gamesense')
            ui_set_visible(preset_change[ i ].freestanding_body_yaw, show_conditions and ui_get(preset_change[ i ].body_yaw) ~= 'Off' and ui_get(preset_change[ i ].freestand_body_yaw) == 'Gamesense')
            ui_set_visible(preset_change[ i ].fake_limit_left, show_conditions)
            ui_set_visible(preset_change[ i ].fake_limit_right, show_conditions)
    
            if ui_get(preset_change[ i ].freestand_body_yaw) ~= 'Gamesense' then
                ui_set(preset_change[ i ].freestanding_body_yaw, false)
            end
        end
    
        --aabuilder
        local builder_enabled = ui_get(conditional_aa) and master_switch and activetab == 'Anti-Aim' and not main_aa_enabled 
    
        ui_set_visible(conditional_aa, master_switch and activetab == 'Anti-Aim' and not main_aa_enabled)
        ui_set_visible(active_condition, builder_enabled)
        
        for i = 1, #var.conditions do
            local show = ui_get(active_condition) == var.conditions[ i ] and builder_enabled
    
            local show_conditions = i == 1 and show or show and ui_get(anti_aim[ i ].enabled)
    
            ui_set_visible(anti_aim[ i ].enabled, show and i > 1)
            ui_set_visible(anti_aim[ i ].pitch, show_conditions)
            ui_set_visible(anti_aim[ i ].yaw_base, show_conditions)
            ui_set_visible(anti_aim[ i ].yaw, show_conditions)
            ui_set_visible(anti_aim[ i ].yaw_add, show_conditions and ui_get(anti_aim[ i ].yaw) ~= 'Off')
            ui_set_visible(anti_aim[ i ].yaw_jitter, show_conditions and ui_get(anti_aim[ i ].yaw) ~= 'Off')
            ui_set_visible(anti_aim[ i ].yaw_jitter_add, show_conditions and ui_get(anti_aim[ i ].yaw_jitter) ~= 'Off' and ui_get(anti_aim[ i ].yaw) ~= 'Off')
            ui_set_visible(anti_aim[ i ].body_yaw, show_conditions)
            ui_set_visible(anti_aim[ i ].body_yaw_add, show_conditions and ui_get(anti_aim[ i ].body_yaw) ~= 'Off' and ui_get(anti_aim[ i ].body_yaw) ~= 'Opposite')
            ui_set_visible(anti_aim[ i ].freestanding_body_yaw, show_conditions and ui_get(anti_aim[ i ].body_yaw) ~= 'Off')
            ui_set_visible(anti_aim[ i ].fake_yaw_limit, show_conditions and ui_get(anti_aim[ i ].body_yaw) ~= 'Off')
            ui_set_visible(anti_aim[ i ].fake_limit_mode, show_conditions and ui_get(anti_aim[ i ].body_yaw) ~= 'Off')
            ui_set_visible(anti_aim[ i ].fake_limit_modifier, show_conditions and ui_get(anti_aim[ i ].fake_limit_mode) ~= 'Off' and ui_get(anti_aim[ i ].fake_limit_mode) ~= 'Custom bodys')
            ui_set_visible(anti_aim[ i ].fake_limit_left, show_conditions and ui_get(anti_aim[ i ].fake_limit_mode) == 'Custom bodys')
            ui_set_visible(anti_aim[ i ].fake_limit_right, show_conditions and ui_get(anti_aim[ i ].fake_limit_mode) == 'Custom bodys')
        end
        
        if main_aa_enabled then
            ui_set(conditional_aa, false)
        end
    end
    
    local function player_condition_builder(e)
        local localplayer = entity_get_local_player()
        if localplayer == nil then return end
    
        local enemies = entity_get_players(true)
        local dormant = #enemies == 0
        local warmup = entity_get_prop(entity_get_game_rules(), 'm_bWarmupPeriod') and ui_get(anti_aim[10].enabled)
        local team = entity_get_prop(localplayer, 'm_iTeamNum')
        local onground = on_ground(localplayer) and e.in_jump == 0
        local legit_aa = ui_get(aa_tab.legit_aa_key) and contains(aa_tab.binds, 'Legit anti-aimbot')
        local velocity = get_velocity(localplayer)
        local crouched = is_crouching(localplayer) and onground
        local flags = entity_get_prop(localplayer, 'm_fFlags') --263 crouch, 257 on ground, 256 in air
        local slowwalking = ui_get(ref.slowwalk[ 2 ]) and onground and velocity > 2 and not crouched
        local inair_crouch = in_air(localplayer) and not onground and flags == 262
        local inair = in_air(localplayer) and not onground
        local fakeducking = ui_get(ref.fakeduck) and onground
    
        if legit_aa then
            var.player_state = 9
            var.antiaim_state = 'Legitaa'
        elseif ui_get(aa_tab.force_flick) and ui_get(ref.doubletap[2]) then
            var.player_state = 12
            var.antiaim_state = 'Defensive Flick'
        elseif not ui_get(ref.doubletap[2]) and not ui_get(ref.onshotaa[2]) and not legit_aa then
            var.player_state = 10
            var.antiaim_state = 'Fakelag'
        elseif inair_crouch then
            var.player_state = 7
            var.antiaim_state = 'air duck'
        elseif inair then
            var.player_state = 8
            var.antiaim_state = 'air'
        elseif slowwalking and not fakeducking then
            var.player_state = 6
            var.antiaim_state = 'slowwalking'
        elseif onground and velocity > 2 and flags ~= 256 and flags ~= 263 and not fakeducking then
            var.player_state = 3
            var.antiaim_state = 'moving'
        elseif onground and velocity < 2 and flags ~= 256 and flags ~= 263 and not fakeducking then
            var.player_state = 2
            var.antiaim_state = 'standing'
        elseif (team == 3 and crouched) or (team == 3 and fakeducking) then
            var.player_state = 5
            var.antiaim_state = 'crouching ct'
        elseif (team == 2 and crouched) or (team == 2 and fakeducking) then
            var.player_state = 4
            var.antiaim_state = 'crouching t'
        elseif warmup == 1 and not legit_aa then
            var.player_state = 11
            var.antiaim_state = 'warmup'
        end
        if legit_aa then
            var.legitaaon = true
        else
            var.legitaaon = false
        end
    end
    local tbl = {}
    tbl.checker = 0
    tbl.defensive = 0

    local function defensivepitch()
        local local_player = entity.get_local_player()
        if not entity.is_alive(local_player) then
            return
        end
        local tickbase = entity.get_prop(entity.get_local_player(), 'm_nTickBase')
        tbl.defensive = math.abs(tickbase - tbl.checker)
        tbl.checker = math.max(tickbase, tbl.checker or 0)
    end

    local function pitchbreaker(cmd)
        if not ui_get(misc_tab.pitch_breaker) then return end
        if var.legitaaon then return end
        if (tbl.defensive > 12 and tbl.defensive < 14) and ui_get(misc_tab.pitch_breaker) then
            ui_set(ref.pitch[1], 'Custom')
            ui_set(ref.pitch[2], ui_get(misc_tab.pitch_breaker_val))
        else
        end
    end
    
    local function player_condition_main(e)
        local localplayer = entity_get_local_player()
        if localplayer == nil then return end

        local enemies = entity_get_players(true)
        local dormant = #enemies == 0
        local warmup = entity_get_prop(entity_get_game_rules(), 'm_bWarmupPeriod') and ui_get(anti_aim[10].enabled)
        local team = entity_get_prop(localplayer, 'm_iTeamNum')
        local onground = on_ground(localplayer) and e.in_jump == 0
        local legit_aa = ui_get(aa_tab.legit_aa_key) and contains(aa_tab.binds, 'Legit anti-aimbot')
        local velocity = get_velocity(localplayer)
        local crouched = is_crouching(localplayer) and onground
        local flags = entity_get_prop(localplayer, 'm_fFlags') --263 crouch, 257 on ground, 256 in air
        local slowwalking = ui_get(ref.slowwalk[ 2 ]) and onground and velocity > 2 and not crouched
        local inair_crouch = in_air(localplayer) and not onground and flags == 262
        local inair = in_air(localplayer) and not onground
        local fakeducking = ui_get(ref.fakeduck) and onground
    
        if legit_aa then
            var.player_state = 8
            var.antiaim_state = 'Legitaa'
        elseif ui_get(aa_tab.force_flick) and ui_get(ref.doubletap[2]) and (tbl.defensive > 2 and tbl.defensive < 14) then
            var.player_state = 10
            var.antiaim_state = 'Defensive Flick'
        elseif not ui_get(ref.doubletap[2]) and not ui_get(ref.onshotaa[2]) and not legit_aa then
            var.player_state = 9
            var.antiaim_state = 'Fakelag'
        elseif inair_crouch then
            var.player_state = 6
            var.antiaim_state = 'Air duck'
            e.force_defensive = 1
        elseif inair then
            var.player_state = 7
            var.antiaim_state = 'Air'
            e.force_defensive = 1
        elseif slowwalking and not fakeducking then
            var.player_state = 5
            var.antiaim_state = 'Slowwalk'
        elseif onground and velocity > 2 and flags ~= 256 and flags ~= 263 and not fakeducking then
            var.player_state = 2
            var.antiaim_state = 'Move'
        elseif onground and velocity < 2 and flags ~= 256 and flags ~= 263 and not fakeducking then
            var.player_state = 1
            var.antiaim_state = 'Stand'
        elseif (team == 3 and crouched) or (team == 3 and fakeducking) then
            var.player_state = 4
            var.antiaim_state = 'CT Crouch'
        elseif (team == 2 and crouched) or (team == 2 and fakeducking) then
            var.player_state = 3
            var.antiaim_state = 'T Crouch'
        end
        if legit_aa then
            var.legitaaon = true
        else
            var.legitaaon = false
        end
        --print(var.antiaim_state)
    end
    
    var.delay = 0.2
    var.timer = globals_curtime()
    var.delayvalue = 90
    
    local function b_body()
        if var.timer < globals_curtime() - var.delay then
            var.delayvalue = var.delayvalue == 90 and -90 or 90
            var.timer = globals_curtime()
        end
    end
    
    local function get_best_desync(fsmode)
        local plocal = entity_get_local_player()
    
        local lx, ly, lz = client_eye_position()
        local view_x, view_y, roll = client_camera_angles()
    
        local enemies = entity_get_players(true)
        var.bestenemy = client_current_threat()
    
        if var.bestenemy ~= nil and var.bestenemy ~= 0 and entity_is_alive(var.bestenemy) and fsmode ~= nil and ui_get(aa_tab.main_aa) then
            local calc_hit = var.last_hit[var.bestenemy] ~= 0 and ((contains(aa_tab.antibruteforce_conditions, var.antiaim_state)) or var.roll_enabled) and ui_get(aa_tab.antibruteforce) and ((ui_get(aa_tab.antibruteforce_type) == 'Opposite' or ui_get(aa_tab.antibruteforce_type) == 'Missed body'))
            local calc_miss = var.miss[var.bestenemy][4] > 0 and ((contains(aa_tab.antibruteforce_conditions, var.antiaim_state)) or var.roll_enabled) and ui_get(aa_tab.antibruteforce) and ((ui_get(aa_tab.antibruteforce_type) == 'Opposite' or ui_get(aa_tab.antibruteforce_type) == 'Missed body'))
    
            if not calc_hit and not calc_miss then
                local e_x, e_y, e_z = entity_hitbox_position(var.bestenemy, 0)
    
                local yaw = calc_angle(lx, ly, e_x, e_y)
                local rdir_x, rdir_y, rdir_z = angle_vector(0, (yaw + 90))
                local rend_x = lx + rdir_x * 10
                local rend_y = ly + rdir_y * 10
                
                local ldir_x, ldir_y, ldir_z = angle_vector(0, (yaw - 90))
                local lend_x = lx + ldir_x * 10
                local lend_y = ly + ldir_y * 10
                
                local r2dir_x, r2dir_y, r2dir_z = angle_vector(0, (yaw + 90))
                local r2end_x = lx + r2dir_x * 100
                local r2end_y = ly + r2dir_y * 100
    
                local l2dir_x, l2dir_y, l2dir_z = angle_vector(0, (yaw - 90))
                local l2end_x = lx + l2dir_x * 100
                local l2end_y = ly + l2dir_y * 100 
                
                local ldamage = get_damage(plocal, var.bestenemy, rend_x, rend_y, lz)
                local rdamage = get_damage(plocal, var.bestenemy, lend_x, lend_y, lz)
    
                local l2damage = get_damage(plocal, var.bestenemy, r2end_x, r2end_y, lz)
                local r2damage = get_damage(plocal, var.bestenemy, l2end_x, l2end_y, lz)
    
                if fsmode == 'Freestanding' then
                    fsmode = 'Freestand'
                elseif fsmode == 'Reversed Freestanding' then
                    fsmode = 'Reversed'
                elseif fsmode == 'Jitter' then
                    fsmode = 'Jitter'
                elseif fsmode == 'Delay body' then
                    fsmode = 'Delay'
                elseif fsmode == 'Random body' then
                    fsmode = 'Random'
                end
    
                if (fsmode == 'Freestand') or (fsmode == 'Reversed') then
                    if l2damage > r2damage or ldamage > rdamage or l2damage > ldamage then
                        var.best_value = fsmode == 'Freestand' and -90 or 90
                    elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
                        var.best_value = fsmode == 'Freestand' and 90 or -90
                    end
                elseif fsmode == 'Jitter' then
                    var.best_value = 0
                elseif fsmode == 'Delay' then
                    var.best_value = var.delayvalue
                elseif fsmode == 'Random' then
                    var.best_value = client_random_int(-5, 5)-- == 1 and 90 or -90
                end
            elseif calc_hit then
                var.best_value = var.last_hit[var.bestenemy] == 90 and -90 or 90
                var.lp_hit = var.lp_hit + 1
            elseif calc_miss then
                if var.stored_misses[var.bestenemy] ~= var.miss[var.bestenemy][4] then
                    var.best_value = var.miss[var.bestenemy][2][var.miss[var.bestenemy][4]]
                    var.stored_misses[var.bestenemy] = var.miss[var.bestenemy][4]
                    var.lp_miss = var.lp_miss + 1
                    var.enemy_shot_time = globals_curtime() + 0.5
                end
            end
        else
            var.best_value = 90
        end
    
        return var.best_value
    end
    
    local function aa_on_use(e)
        local master_switch = ui_get(master_switch)
        local legitaa_key = ui_get(aa_tab.legit_aa_key) and contains(aa_tab.binds, 'Legit anti-aimbot')
    
        if master_switch and legitaa_key then
            local plocal = entity_get_local_player()
            
            local distance = 100
            local bomb = entity_get_all('CPlantedC4')[1]
            local bomb_x, bomb_y, bomb_z = entity_get_prop(bomb, 'm_vecOrigin')
    
            if bomb_x ~= nil then
                local player_x, player_y, player_z = entity_get_prop(plocal, 'm_vecOrigin')
                distance = distance3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
            end
            
            local team_num = entity_get_prop(plocal, 'm_iTeamNum')
            local defusing = team_num == 3 and distance < 62
    
            local on_bombsite = entity_get_prop(plocal, 'm_bInBombZone')
    
            local has_bomb = entity_has_c4(plocal)
            
            local px, py, pz = client_eye_position()
            local pitch, yaw = client_camera_angles()
        
            local sin_pitch = math_sin(math_rad(pitch))
            local cos_pitch = math_cos(math_rad(pitch))
            local sin_yaw = math_sin(math_rad(yaw))
            local cos_yaw = math_cos(math_rad(yaw))
    
            local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }
    
            local fraction, entindex = client_trace_line(plocal, px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))
    
            local using = true
    
            if entindex ~= nil then
                for i=0, #var.classnames do
                    if entity_get_classname(entindex) == var.classnames[i] then
                        using = false
                    end
                end
            end
    
            if not using and not defusing then
                e.in_use = 0
            end
        end
    end

    local function handle_main_antiaim(e)
        local preset_changer_enabled = ui_get(preset_changer)
    
        local lp_bodyyaw = entity_get_prop(entity_get_local_player(), 'm_flPoseParameter', 11) * 120 - 60
    
        ui_set(ref.freestanding[ 1 ], 'Default')
    
        ui_set(aa_tab.manual_left, 'On hotkey')
        ui_set(aa_tab.manual_right, 'On hotkey')
    
        if contains(aa_tab.binds, 'Edge yaw') then
            ui_set(ref.edge_yaw, ui_get(aa_tab.edge_yaw))
        end
    
        if contains(aa_tab.freestanding_dis, 'Crouching') and (var.player_state == 3 or var.player_state == 4) then
            var.fs_disabled = 1
        elseif contains(aa_tab.freestanding_dis, 'In air') and (var.player_state == 6 or var.player_state == 7) then
            var.fs_disabled = 1
        elseif contains(aa_tab.freestanding_dis, 'Slow motion') and var.player_state == 5 then
            var.fs_disabled = 1
        elseif contains(aa_tab.freestanding_dis, 'Running') and var.player_state == 2 then
            var.fs_disabled = 1
        -- elseif (ui_get(aa_tab.roll_aa) and contains(aa_tab.binds, 'Roll anti-aim') and not var.legitaaon) or (contains(aa_tab.roll_conditions, var.antiaim_state) and var.aa_dir == 0 and not var.legitaaon) and contains(aa_tab.freestanding_dis, 'Roll') then
        --     var.fs_disabled = 1
        elseif (ui_get(aa_tab.roll_aa) and contains(aa_tab.binds, 'Roll anti-aim')) or (contains(aa_tab.roll_conditions, var.antiaim_state) and var.antiaim_state ~= 'Stand') and not var.legitaaon then
            var.fs_disabled = 1
        elseif var.player_state == 8 or var.aa_dir ~= 0 then
            var.fs_disabled = 1
        else
            var.fs_disabled = 0
        end
    
        if var.fs_disabled == 0 and ui_get(aa_tab.freestanding) and contains(aa_tab.binds, 'Freestanding') then
            ui_set(ref.freestanding[ 2 ], 'Always on')
        else
            ui_set(ref.freestanding[ 2 ], 'On hotkey')
        end
    
        if var.legitaaon then
            var.last_press_t = globals_curtime()
        elseif not contains(aa_tab.binds, 'Manual anti-aim') then
            var.last_press_t = globals_curtime()
            var.aa_dir = 0
        else
            if ui_get(aa_tab.manual_right) and var.last_press_t + 0.2 < globals_curtime() then
                var.aa_dir = var.aa_dir == 90 and 0 or 90
                var.last_press_t = globals_curtime()
            elseif ui_get(aa_tab.manual_left) and var.last_press_t + 0.2 < globals_curtime() then
                var.aa_dir = var.aa_dir == -90 and 0 or -90
                var.last_press_t = globals_curtime()
            elseif var.last_press_t > globals_curtime() then
                var.last_press_t = globals_curtime()
            end
        end
        
        local antibrute_on = var.lp_miss ~= 0 and contains(aa_tab.antibruteforce_conditions, var.antiaim_state)
    
        local disable_roll = true
        --var.roll_enabled = false
    
        ui_set(ref.pitch[1], var.player_state ~= 8 and 'Minimal' or 'Off')
        ui_set(ref.yaw_base, (var.player_state ~= 8 and var.aa_dir == 0) and 'At targets' or 'Local view')
        ui_set(ref.yaw[1], '180')
    
        if var.aa_dir ~= 0 and var.player_state ~= 8 then
            if ui_get(aa_tab.roll_aa) and contains(aa_tab.binds, 'Roll anti-aim') then
                disable_roll = false
                ui_set(ref.yaw[2], var.aa_dir == 90 and var.aa_dir or -65)
                ui_set(ref.yaw_jitter[1], 'Off')
                ui_set(ref.yaw_jitter[2], 0)
                ui_set(ref.body_yaw[1], 'Static')
                ui_set(ref.body_yaw[2], 180)
                ui_set(ref.freestanding_body_yaw, false)
                ui_set(ref.fake_yaw_limit, 60)
                e.roll = -50
                client_set_cvar('cl_bodyspeed', 130)
                client_set_cvar('cl_forwardspeed', 130)
                client_set_cvar('cl_backspeed', 130)
                var.roll_enabled = true
            else
                ui_set(ref.yaw[2], var.aa_dir)
                ui_set(ref.yaw_jitter[1], 'Off')
                ui_set(ref.yaw_jitter[2], 0)
                ui_set(ref.body_yaw[1], 'Static')
                ui_set(ref.body_yaw[2], 180)
                ui_set(ref.freestanding_body_yaw, false)
                ui_set(ref.fake_yaw_limit, 60)
            end
        else
            if globals_chokedcommands() == 0 then 
            if var.player_state == 9 and (not ui_get(preset_change[ 9 ].enabled) or not preset_changer_enabled) then --fakelag
                ui_set(ref.yaw[2], 9)
                ui_set(ref.yaw_jitter[1], 'Center')
                ui_set(ref.yaw_jitter[2], 0)
                ui_set(ref.body_yaw[1], 'Static')
                ui_set(ref.body_yaw[2], 60)
                ui_set(ref.freestanding_body_yaw, false)
                ui_set(ref.fake_yaw_limit, 32)
    
            elseif var.player_state == 5 and (not ui_get(preset_change[ 5 ].enabled) or not preset_changer_enabled) then --slowwalk
                ui_set(ref.yaw[2], (lp_bodyyaw > 0 and -20 or 32))
                ui_set(ref.yaw_jitter[1], 'Center')
                ui_set(ref.yaw_jitter[2], 23)
                ui_set(ref.body_yaw[1], 'Jitter')
                ui_set(ref.body_yaw[2], 0)
                ui_set(ref.freestanding_body_yaw, false)
                ui_set(ref.fake_yaw_limit, (lp_bodyyaw > 0 and 59 or 59))
    
            elseif var.player_state == 1 and (not ui_get(preset_change[ 1 ].enabled) or not preset_changer_enabled) then --standing
                ui_set(ref.yaw[2], (lp_bodyyaw > 0 and 12 or -7))
                ui_set(ref.yaw_jitter[1], 'Center')
                ui_set(ref.yaw_jitter[2], 77)
                ui_set(ref.body_yaw[1], 'Jitter')
                ui_set(ref.body_yaw[2], 0)
                ui_set(ref.freestanding_body_yaw, false)
                ui_set(ref.fake_yaw_limit, (lp_bodyyaw > 0 and 37 or 38))
    
            elseif var.player_state == 2 and (not ui_get(preset_change[ 2 ].enabled) or not preset_changer_enabled) then --moving
                ui_set(ref.yaw[2], (lp_bodyyaw > 0 and 7 or 3))
                ui_set(ref.yaw_jitter[1], 'Center')
                ui_set(ref.yaw_jitter[2], 77)
                ui_set(ref.body_yaw[1], 'Jitter')
                ui_set(ref.body_yaw[2], 77)
                ui_set(ref.freestanding_body_yaw, false)
                ui_set(ref.fake_yaw_limit, (lp_bodyyaw > 0 and 59 or 59))
    
            elseif var.player_state == 3 and (not ui_get(preset_change[ 3 ].enabled) or not preset_changer_enabled) then --crouch t
                ui_set(ref.yaw[2], 4)
                ui_set(ref.yaw_jitter[1], 'Center')
                ui_set(ref.yaw_jitter[2], 52)
                ui_set(ref.body_yaw[1], 'Jitter')
                ui_set(ref.body_yaw[2], 0)
                ui_set(ref.freestanding_body_yaw, false)
                ui_set(ref.fake_yaw_limit, (lp_bodyyaw > 0 and 27 or 39))
    
            elseif var.player_state == 4 and (not ui_get(preset_change[ 4 ].enabled) or not preset_changer_enabled) then --crouch ct
                ui_set(ref.yaw[2], 4)
                ui_set(ref.yaw_jitter[1], 'Center')
                ui_set(ref.yaw_jitter[2], 52)
                ui_set(ref.body_yaw[1], 'Jitter')
                ui_set(ref.body_yaw[2], 0)
                ui_set(ref.freestanding_body_yaw, false)
                ui_set(ref.fake_yaw_limit, (lp_bodyyaw > 0 and 27 or 39))
    
            elseif var.player_state == 6 and (not ui_get(preset_change[ 6 ].enabled) or not preset_changer_enabled) then --air duck
                ui_set(ref.yaw[2], (lp_bodyyaw > 0 and 13 or 6))
                ui_set(ref.yaw_jitter[1], 'Center')
                ui_set(ref.yaw_jitter[2], -60)
                ui_set(ref.body_yaw[1], 'Jitter')
                ui_set(ref.body_yaw[2], 36)
                ui_set(ref.freestanding_body_yaw, false)
                ui_set(ref.fake_yaw_limit, (lp_bodyyaw > 0 and 27 or 27))
    
            elseif var.player_state == 7 and (not ui_get(preset_change[ 7 ].enabled) or not preset_changer_enabled) then --aircustompitch
                ui_set(ref.yaw[2], 0)
                ui_set(ref.yaw_jitter[1], 'Center')
                ui_set(ref.yaw_jitter[2], 9)
                ui_set(ref.body_yaw[1], 'Opposite')
                ui_set(ref.body_yaw[2], 0)
                ui_set(ref.freestanding_body_yaw, false)
                ui_set(ref.fake_yaw_limit, (lp_bodyyaw > 0 and 60 or 60))
    
            elseif var.player_state == 8 and (not ui_get(preset_change[ 8 ].enabled) or not preset_changer_enabled) then --legitaa
                if ui_get(aa_tab.legit_aa_type) == 'Center Jitter' then
                    ui_set(ref.yaw[2], (lp_bodyyaw > 0 and 179 or -179))
                    ui_set(ref.yaw_jitter[1], 'Center')
                    ui_set(ref.yaw_jitter[2], -61) --45
                    ui_set(ref.body_yaw[1], 'Jitter')
                    ui_set(ref.body_yaw[2], 121)
                    ui_set(ref.freestanding_body_yaw, false)
                    ui_set(ref.fake_yaw_limit, (lp_bodyyaw > 0 and 59 or 59))
                elseif ui_get(aa_tab.legit_aa_type) == 'Static' then
                    ui_set(ref.yaw[2], -180)
                    ui_set(ref.yaw_jitter[1], 'Off')
                    ui_set(ref.yaw_jitter[2], 0)
                    ui_set(ref.body_yaw[1], var.lastshot + 0.15 > globals_curtime() and 'Jitter' or 'Static')
                    ui_set(ref.body_yaw[2], var.lastshot + 0.15 > globals_curtime() and get_best_desync('Jitter') or get_best_desync('Freestanding'))
                    ui_set(ref.freestanding_body_yaw, not (var.lastshot + 0.15 > globals_curtime()))
                    ui_set(ref.fake_yaw_limit, (lp_bodyyaw > 0 and 59 or 59))
                end
            end
            end
        end

        local fiveway = ((globals.tickcount() % 3) + 1)

        var.changer_state = preset_changer_enabled and (ui_get(preset_change[ var.player_state ].enabled) and var.player_state or 1)

        if contains(preset_change[ var.changer_state ].defensive_brute, 'Yaw') and (tbl.defensive > ui_get(preset_change[ var.changer_state ].defensive_brute_tick) and tbl.defensive < 14)  and var.aa_dir == 0 then
            var.preset_yaw_value = ui_get(preset_change[ var.changer_state ].defensive_brute_yaw)
        elseif globals_chokedcommands() == 0 and var.changer_state ~= 0 and preset_changer_enabled and (ui_get(preset_change[ var.changer_state ].pitch) == '3way') then
            one = ui_get(preset_change[ var.changer_state ].yaw_1)
            if fiveway == 1 and globals_chokedcommands() == 0 then
                var.preset_yaw_value = one
            elseif fiveway == 2 and globals_chokedcommands() == 0 then
                var.preset_yaw_value = 0
            elseif fiveway == 3 and globals_chokedcommands() == 0 then
                var.preset_yaw_value = -one
                fiveway = 0
            end
            var.preset_bodyyaw_value = lp_bodyyaw > 0 and ui_get(preset_change[ var.changer_state ].body_yaw_left) or ui_get(preset_change[ var.changer_state ].body_yaw_right)
            var.preset_fakelimit_value = lp_bodyyaw > 0 and ui_get(preset_change[ var.changer_state ].fake_limit_left) or ui_get(preset_change[ var.changer_state ].fake_limit_right)
            jittervalue = lp_bodyyaw > 0 and ui_get(preset_change[ var.changer_state ].yaw_jitter_left) or ui_get(preset_change[ var.changer_state ].yaw_jitter_right)
        elseif globals_chokedcommands() == 0 and var.changer_state ~= 0 and preset_changer_enabled then
            var.preset_yaw_value = lp_bodyyaw > 0 and ui_get(preset_change[ var.changer_state ].yaw_left) or ui_get(preset_change[ var.changer_state ].yaw_right)
            var.preset_bodyyaw_value = lp_bodyyaw > 0 and ui_get(preset_change[ var.changer_state ].body_yaw_left) or ui_get(preset_change[ var.changer_state ].body_yaw_right)
            var.preset_fakelimit_value = lp_bodyyaw > 0 and ui_get(preset_change[ var.changer_state ].fake_limit_left) or ui_get(preset_change[ var.changer_state ].fake_limit_right)
            jittervalue = lp_bodyyaw > 0 and ui_get(preset_change[ var.changer_state ].yaw_jitter_left) or ui_get(preset_change[ var.changer_state ].yaw_jitter_right)
            ui_set(ref.yaw[2], var.player_state == 8 and -180 or var.preset_yaw_value)
        end

        if (contains(preset_change[ var.changer_state ].defensive_brute, 'Pitch')) and (tbl.defensive > ui_get(preset_change[ var.changer_state ].defensive_brute_tick) and tbl.defensive < 14) then
            pitchval = ui_get(preset_change[ var.changer_state ].defensive_brute_pitch)
        end

        ui_set(ref.yaw[2], var.player_state == 8 and -180 or var.preset_yaw_value)

        local pitchval = 0

        if globals_chokedcommands() == 0 and var.changer_state ~= 0 and preset_changer_enabled and (ui_get(preset_change[ var.changer_state ].pitch) == 'CustomLR') then
            pitchval = lp_bodyyaw > 0 and ui_get(preset_change[ var.changer_state ].pitch_left) or ui_get(preset_change[ var.changer_state ].pitch_right)
        end

        if var.changer_state ~= 0 and preset_changer_enabled and var.aa_dir == 0 then
            if ui_get(preset_change[ var.changer_state ].pitch) == '3way' and var.legitaaon then
                ui_set(ref.pitch[1], 'Off')
            elseif contains(preset_change[ var.changer_state ].defensive_brute, 'Pitch') and (tbl.defensive > ui_get(preset_change[ var.changer_state ].defensive_brute_tick) and tbl.defensive < 14) then
                ui_set(ref.pitch[1], 'Custom')
                ui_set(ref.pitch[2], pitchval)
            elseif ui_get(preset_change[ var.changer_state ].pitch) == 'CustomLR' then
                ui_set(ref.pitch[1], 'Custom')
                ui_set(ref.pitch[2], pitchval)
            elseif ui_get(preset_change[ var.changer_state ].pitch) == '3way' then
                ui_set(ref.pitch[1], 'Minimal')
            elseif ui_get(preset_change[ var.changer_state ].pitch) == 'Spin' then
                ui_set(ref.pitch[1], 'Off')
                ui_set(ref.yaw[1], 'Spin')
                ui_set(ref.yaw[2], ui_get(preset_change[ var.changer_state ].yaw_left))
            else
                ui_set(ref.pitch[1], ui_get(preset_change[ var.changer_state ].pitch))
                ui_set(ref.pitch[2], ui_get(preset_change[ var.changer_state ].custompitch))
            end

            if ui_get(preset_change[ var.changer_state ].yaw_jitter) == 'CustomLR' then
                ui_set(ref.yaw_jitter[1], 'Center')
                ui_set(ref.yaw_jitter[2], jittervalue)
            elseif ui_get(preset_change[ var.changer_state ].yaw_jitter) == '3way' then
                one = ui_get(preset_change[ var.changer_state ].yaw_jitter_add_1)
                ui_set(ref.yaw_jitter[1], 'Center')
                if fiveway == 1 then
                    ui_set(ref.yaw_jitter[2], one)
                elseif fiveway == 2 then
                    ui_set(ref.yaw_jitter[2], 0)
                elseif fiveway == 3 then
                    ui_set(ref.yaw_jitter[2], -one)
                    fiveway = 0
                end
            else
                ui_set(ref.yaw_jitter[1], ui_get(preset_change[ var.changer_state ].yaw_jitter))
                ui_set(ref.yaw_jitter[2], ui_get(preset_change[ var.changer_state ].yaw_jitter) ~= 'Off' and ui_get(preset_change[ var.changer_state ].yaw_jitter_add) or 0)
            end

            if ui_get(preset_change[ var.changer_state ].freestand_body_yaw) == 'Gamesense' then
                ui_set(ref.body_yaw[1], ui_get(preset_change[ var.changer_state ].body_yaw)) 
                ui_set(ref.body_yaw[2], var.preset_bodyyaw_value)
                ui_set(ref.freestanding_body_yaw, ui_get(preset_change[ var.player_state ].freestanding_body_yaw))
            else
                ui_set(ref.body_yaw[1], ui_get(preset_change[ var.changer_state ].freestand_body_yaw) == 'Jitter' and 'Jitter' or 'Static') 
                ui_set(ref.body_yaw[2], get_best_desync(ui_get(preset_change[ var.changer_state ].freestand_body_yaw)))
                ui_set(ref.freestanding_body_yaw, false)
            end
            ui_set(ref.fake_yaw_limit, var.preset_fakelimit_value)
        end
    
        if (ui_get(aa_tab.roll_aa) and contains(aa_tab.binds, 'Roll anti-aim') and var.aa_dir == 0 and not var.legitaaon) or (contains(aa_tab.roll_conditions, var.antiaim_state) and var.aa_dir == 0 and not var.legitaaon) then
            ui_set(ref.yaw[2], 0)
            ui_set(ref.yaw_jitter[1], 'Off')
            ui_set(ref.yaw_jitter[2], 0)
            ui_set(ref.body_yaw[1], var.lp_miss ~= 0 and 'Static' or 'Jitter')
            ui_set(ref.body_yaw[2], get_best_desync('Jitter'))
            e.roll = lp_bodyyaw > 0 and 50 or -50
            ui_set(ref.freestanding_body_yaw, false)
            ui_set(ref.fake_yaw_limit, 60)
            client_set_cvar('cl_bodyspeed', 130)
            client_set_cvar('cl_forwardspeed', 130)
            client_set_cvar('cl_backspeed', 130)
            client_set_cvar('cl_bodyspeed ', 130)
            client_set_cvar('cl_upspeed ', 130)
            var.roll_enabled = true
        elseif disable_roll then
            var.roll_enabled = false
            e.roll = 0
            client_set_cvar('cl_bodyspeed', 450)
            client_set_cvar('cl_forwardspeed', 450)
            client_set_cvar('cl_backspeed', 450)
            client_set_cvar('cl_bodyspeed ', 450)
            client_set_cvar('cl_upspeed ', 450)
        end
    end
    
    local function leg_breaker(cmd)
        ui_set(ref.leg_movement, cmd.command_number % 3 == 0 and 'Always slide' or 'Never slide')
    end
    
    
    local function handle_builder_antiaim()
        local builder_enabled = ui_get(conditional_aa)
    
        local lp_bodyyaw = entity_get_prop(entity_get_local_player(), 'm_flPoseParameter', 11) * 120 - 60
    
        ui_set(ref.freestanding[ 1 ], 'Default')
    
        if contains(aa_tab.binds, 'Edge yaw') then
            ui_set(ref.edge_yaw, ui_get(aa_tab.edge_yaw))
        end
    
        if contains(aa_tab.freestanding_dis, 'Crouching') and (var.player_state == 4 or var.player_state == 5) then
            var.fs_disabled = 1
        elseif contains(aa_tab.freestanding_dis, 'In air') and var.player_state == 7 then
            var.fs_disabled = 1
        elseif contains(aa_tab.freestanding_dis, 'Slow motion') and var.player_state == 6 then
            var.fs_disabled = 1
        elseif contains(aa_tab.freestanding_dis, 'Running') and var.player_state == 3 then
            var.fs_disabled = 1
        elseif var.player_state == 9 then
            var.fs_disabled = 1
        else
            var.fs_disabled = 0
        end
    
        if var.fs_disabled == 0 and ui_get(aa_tab.freestanding) and contains(aa_tab.binds, 'Freestanding') then
            ui_set(ref.freestanding[2], 'Always on')
        else
            ui_set(ref.freestanding[2], 'On hotkey')
        end
    
        local getitem = ui_get(anti_aim[ var.player_state ].enabled) and var.player_state or 1
    
        if globals_chokedcommands() == 0 and builder_enabled then
            if ui_get(anti_aim[ getitem ].fake_limit_mode) == 'Custom bodys' then
                var.builder_fakelimit_value = lp_bodyyaw > 0 and ui_get(anti_aim[ getitem ].fake_limit_left) or ui_get(anti_aim[ getitem ].fake_limit_right)
            elseif ui_get(anti_aim[ getitem ].fake_limit_mode) == 'Jitter' then
                var.builder_fakelimit_value = client_random_int(0, 1) == 1 and ui_get(anti_aim[ getitem ].fake_limit_modifier) or ui_get(anti_aim[ getitem ].fake_yaw_limit)
            elseif ui_get(anti_aim[ getitem ].fake_limit_mode) == 'Random' then
                var.builder_fakelimit_value = client_random_int(math_max(math_min(60, ui_get(anti_aim[ getitem ].fake_yaw_limit) - ui_get(anti_aim[ getitem ].fake_limit_modifier)), 0), ui_get(anti_aim[ getitem ].fake_yaw_limit))
            else
                var.builder_fakelimit_value = ui_get(anti_aim[ getitem ].fake_yaw_limit)
            end
        end
    
        ui_set(ref.pitch[1], ui_get(anti_aim[ getitem ].pitch))
        ui_set(ref.pitch[2], ui_get(anti_aim[ getitem ].custompitch))
        ui_set(ref.yaw_base, ui_get(anti_aim[ getitem ].yaw_base))
        ui_set(ref.yaw[ 1 ], ui_get(anti_aim[ getitem ].yaw))
        ui_set(ref.yaw[ 2 ], ui_get(anti_aim[ getitem ].yaw_add))
        ui_set(ref.yaw_jitter[ 1 ], ui_get(anti_aim[ getitem ].yaw_jitter))
        ui_set(ref.yaw_jitter[ 2 ], ui_get(anti_aim[ getitem ].yaw_jitter_add))
        ui_set(ref.body_yaw[ 1 ], ui_get(anti_aim[ getitem ].body_yaw))
        ui_set(ref.body_yaw[ 2 ], ui_get(anti_aim[ getitem ].body_yaw_add))
        ui_set(ref.freestanding_body_yaw, ui_get(anti_aim[ getitem ].freestanding_body_yaw))
        ui_set(ref.fake_yaw_limit, var.builder_fakelimit_value)
    end
    
    local function handle_shots()
        local enemies = entity_get_players(true)
    
        for i=1, #enemies do
            local idx = enemies[i]
            local s = var.shots[idx][4]
            local h = var.hit[idx][4]
    
            if s ~= var.stored_shots[idx] then
                local missed = true
                
                if var.shots[idx][1][s] == var.hit[idx][1][h] then
                    if var.hit[idx][2][h] ~= 0 and var.hit[idx][2][h] ~= 180 then
                        var.last_hit[idx] = var.hit[idx][2][h]
                    end
                    missed = false
                end
    
                if missed then
                    var.last_hit[idx] = 0
                    var.hit[idx][2][h] = 0
                    var.miss[idx][4] = var.miss[idx][4] + 1
                    var.miss[idx][2][var.miss[idx][4]] = var.shots[idx][2][s]
                end
    
                var.last_nn = idx
                var.stored_shots[idx] = s
            end
        end
    end
    
    client_set_event_callback('weapon_fire', function(e)
        if client_userid_to_entindex(e.userid) == entity_get_local_player() then
            var.lastshot = globals_curtime()
        end
    end)
    
    local bp = {0, 0, 0}
    
    local function dist_from_3dline(shooter, e)
        local x, y, z = entity_hitbox_position(shooter, 0)
        local x1, y1, z1 = client_eye_position()
    
        --point
        local p = {x1,y1,z1}
    
        --line
        local a = {x,y,z}
        local b = {e.x,e.y,e.z}
    
        --line delta
        local ab = {b[1] - a[1], b[2] - a[2], b[3] - a[3]}
    
        --line length
        local len = math_sqrt(ab[1]^2 + ab[2]^2 + ab[3]^2)
    
        --line delta / line legth
        local d  = {ab[1] / len, ab[2] / len, ab[3] / len}
    
        --point to line origin delta
        local ap = {p[1] - a[1], p[2] - a[2], p[3] - a[3]}
    
        --direction
        local d2 = d[1]*ap[1] + d[2]*ap[2] + d[3]*ap[3]
    
        --closest point on line to point
        bp = {a[1] + d2 * d[1], a[2] + d2 * d[2], a[3] + d2 * d[3]}
    
        --distance from closest point to point
        return (bp[1]-x1) + (bp[2]-y1) + (bp[3]-z1)
    end
    
    local function on_bullet_impact(e)
        local plocal = entity_get_local_player()
        local shooter = client_userid_to_entindex(e.userid)
    
        if not entity_is_enemy(shooter) or not entity_is_alive(plocal) then
            return
        end
    
        local d = dist_from_3dline(shooter, e)
    
        if math_abs(d) < 100 then
            --var.lp_miss = var.lp_miss + 1
            --var.last_shot = globals_curtime()
        
            --local dsy = var.legitaaon and (ui_get(ref.body_yaw[2]) * -1) or ui_get(ref.body_yaw[2])
            local dsy = ui_get(ref.body_yaw[2])
    
            local previous_record = var.shots[shooter][1][var.shots[shooter][4]] == globals_curtime()
            var.shots[shooter][4] = previous_record and var.shots[shooter][4] or var.shots[shooter][4] + 1
    
            var.shots[shooter][1][var.shots[shooter][4]] = globals_curtime()
    
            local dtc = (ui_get(aa_tab.antibruteforce_type) == 'Missed body') or dsy == 0 or dsy == 180
    
            if dtc then
                var.shots[shooter][2][var.shots[shooter][4]] = math_abs(d) > 0.5 and (d < 0 and 90 or -90) or dsy
            else
                var.shots[shooter][2][var.shots[shooter][4]] = (dsy == 90 and -90 or 90)
            end
        end
    end
    
    local function on_player_hurt(e)
        local plocal = entity_get_local_player()
        local victim = client_userid_to_entindex(e.userid)
        local attacker = client_userid_to_entindex(e.attacker)
    
        if not entity_is_enemy(attacker) or not entity_is_alive(plocal) or victim ~= plocal then
            return
        end
    
        for i=1, #var.nonweapons do
            if e.weapon == var.nonweapons[i] then
                return
            end
        end
    
        var.lp_miss = var.lp_miss + 1
        var.enemy_shot_time = globals_curtime() + 0.5
    
        --local dsy = var.legitaaon and (ui_get(ref.body_yaw[2]) * -1) or ui_get(ref.body_yaw[2])
        local dsy = ui_get(ref.body_yaw[2])
    
        var.hit[attacker][4] = var.hit[attacker][4] + 1
        var.hit[attacker][1][var.hit[attacker][4]] = globals_curtime()
        var.hit[attacker][2][var.hit[attacker][4]] = dsy == 90 and 90 or -90
        var.hit[attacker][3][var.hit[attacker][4]] = e.hitgroup
    end
    
    local function reset_data(keep_hit)
        for i=1, 64 do
            var.last_hit[i], var.stored_misses[i], var.stored_shots[i] = (keep_hit and var.hit[i][2][var.hit[i][4]] ~= 0) and var.hit[i][2][var.hit[i][4]] or 0, 0, 0
            for k=1, 3 do
                for j=1, 200--[[1000]] do
                    var.miss[i][k][j], var.hit[i][k][j], var.shots[i][k][j] = 0, 0, 0
                end
            end
            var.miss[i][4], var.hit[i][4], var.shots[i][4], var.last_nn, var.best_value = 0, 0, 0, 0, 180
        end
    end
    
    local function antibrute_time()
        if var.enemy_shot_time > (globals_curtime()) and ((contains(aa_tab.antibruteforce_conditions, var.antiaim_state)) or var.roll_enabled) then 
            var.lastUpdate = (globals_curtime())
        end
    
        var.ab_time = math_floor(globals_curtime() - var.lastUpdate)
    
        if var.ab_time == 0 then
            var.ab_timer = 5
        elseif var.ab_time == 1 then
            var.ab_timer = 4
        elseif var.ab_time == 2 then
            var.ab_timer = 3
        elseif var.ab_time == 3 then
            var.ab_timer = 2
        elseif var.ab_time == 4 then
            var.ab_timer = 1
        elseif var.ab_time == 5 then
            var.ab_timer = 0
            var.lp_miss = 0
            reset_data(false)
        elseif var.ab_time > 5 then
            var.ab_timer = 0
            var.lp_miss = 0
            var.enemy_shot_time = -1
        end
    end
    
    local anim_timer, anim_value, ind_body = globals_curtime(), 0, false
    
    local function handle_animation()
        --print(anim_value)
        if anim_timer < globals_curtime() - ui_get(vis_tab.crosshair_main_animspeed) / 100 then
            if ui_get(vis_tab.crosshair_main_animstyle) == 'Circle' then
                if anim_value == 0 or anim_value == 7 then
                    ind_body = not ind_body
                end
            elseif ui_get(vis_tab.crosshair_main_animstyle) == 'Straight' then
                if anim_value == 7 and ui_get(vis_tab.crosshair_direction) == 'Right' then
                    anim_value = -1
                elseif anim_value == 0 and ui_get(vis_tab.crosshair_direction) == 'Left' then
                    anim_value = 7
                end
            end
            
            if ui_get(vis_tab.crosshair_main_animstyle) == 'Circle' then
                anim_value = ind_body and anim_value + 1 or anim_value - 1
            elseif ui_get(vis_tab.crosshair_main_animstyle) == 'Straight' then
                anim_value = ui_get(vis_tab.crosshair_direction) == 'Right' and anim_value + 1 or anim_value - 1
            end
    
            anim_timer = globals_curtime()
        end
    
        if anim_value > 7 or anim_value < 0 then
            anim_value = 0
        end
    end
    
    local s_txt_r, s_txt_g, s_txt_b, s_txt_a = 0, 0, 0, 0
    local o_txt_r, o_txt_g, o_txt_b, o_txt_a = 0, 0, 0, 0
    local l_txt_r, l_txt_g, l_txt_b, l_txt_a = 0, 0, 0, 0
    local a_txt_r, a_txt_g, a_txt_b, a_txt_a = 0, 0, 0, 0
    local c_txt_r, c_txt_g, c_txt_b, c_txt_a = 0, 0, 0, 0
    local e_txt_r, e_txt_g, e_txt_b, e_txt_a = 0, 0, 0, 0
    local f_txt_r, f_txt_g, f_txt_b, f_txt_a = 0, 0, 0, 0
    local g_txt_r, g_txt_g, g_txt_b, g_txt_a = 0, 0, 0, 0
    
    local ind_placement, ind_font, text_add, ab_add, ab_add2, maintxt_crosshair_style, maintxt_crosshair_anim_style, maintxt_reset, dtc_show, maintext = 'c', '-', 0, 0, 0, 'gradient', 'Old', false, 0, ''
    
    local values = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    local x_state = 0
    
    local function animation(check, name, value, speed) 
        if check then 
            return name + (value - name) * globals_frametime() * speed 
        else 
            return name - (value + name) * globals_frametime() * speed -- add / 2 if u want goig back effect
        end
    end

    local function RGBAtoHEX(redArg, greenArg, blueArg, alphaArg)
        return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
    end

    local function create_color_array(r, g, b)
        local colors = {}
        for i = 0, 8 do
            local color = {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + i * 5 / 30))}
            table.insert(colors, color)
        end
        return colors
    end
    local function create_color_array2(r, g, b)
        local colors = {}
        for i = 0, 28 do
            local color = {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + i * 5 / 30))}
            table.insert(colors, color)
        end
        return colors
    end

    local round = function(value, multiplier) local multiplier = 10 ^ (multiplier or 0); return math.floor(value * multiplier + 0.5) / multiplier end

    local function handle_indicators()
        local local_player = entity_get_local_player()
        if not entity_is_alive(local_player) then
            return
        end
    
        if ui_get(vis_tab.crosshair_style) ~= maintxt_crosshair_style or ui_get(vis_tab.crosshair_animstyle) ~= maintxt_crosshair_anim_style then
            maintxt_reset = true
            maintxt_crosshair_style = ui_get(vis_tab.crosshair_style)
            maintxt_crosshair_anim_style = ui_get(vis_tab.crosshair_animstyle)
        end
    
        if maintxt_reset then
            for i = 1, 10 do
                values[i] = 0
            end
            anim_value = 0
            maintxt_reset = false
        end
    
        local width, height = client_screen_size()
        local x = width / 2
        local y = height / 2
        local ind_offset = 0
    
        local ind_height = ui_get(vis_tab.crosshair_height)
        local anim_speed = ui_get(vis_tab.crosshair_animspeed)
        local ind_separator = ui_get(vis_tab.crosshair_separator)
    
        local r1, g1, b1, a1 = ui_get(vis_tab.crosshair_color1)
        local r2, g2, b2, a2 = ui_get(vis_tab.crosshair_color2)
    
        local indicator_font = ui_get(vis_tab.crosshair_font)
    
        local indicator_placement = ui_get(vis_tab.crosshair_placement)
    
        local text_width, text_height = renderer_measure_text(ind_font, 'HHH')
    
        local dtc_adderx, dtc_addery, dtc_size, dtc_thickness = 0, 0, 0, 0
    
        if indicator_placement == 'Center' then
            ind_placement = 'c'
        elseif indicator_placement == 'Right' then
            ind_placement = 'l'
        elseif indicator_placement == 'Left' then
            ind_placement = 'r'
        end
    
        if indicator_font == 'Small' then
            ind_font = ind_placement .. '-'
            text_add = 0
            ab_add = 1
            ab_add2 = 0
            dtc_size = 2.5
            dtc_thickness = 1
        elseif indicator_font == 'Normal' then
            ind_font = ind_placement .. ''
            text_add = 1
            ab_add = 3
            ab_add2 = 1
            dtc_size = 3.5
            dtc_thickness = 0.5
        elseif indicator_font == 'Bold' then
            ind_font = ind_placement .. 'b'
            text_add = 1
            ab_add = 3
            ab_add2 = 1
            dtc_size = 3.5
            dtc_thickness = 1.5
        elseif indicator_font == 'Big' then
            ind_font = ind_placement .. '+'
            text_add = 10
            ab_add = 6
            ab_add2 = 2
            dtc_size = 7.5
            dtc_thickness = 2
        end
    
        if indicator_placement == 'Center'  then
            if indicator_font == 'Small' then
                dtc_adderx, dtc_addery = 0, 1
            elseif indicator_font == 'Normal' then
                dtc_adderx, dtc_addery = -3, 1
            elseif indicator_font == 'Bold' then
                dtc_adderx, dtc_addery = -3, 1
            elseif indicator_font == 'Big' then
                dtc_adderx, dtc_addery = -4, 2
            end
        elseif indicator_placement == 'Right' then
            x = x + 1
            if indicator_font == 'Small' then
                dtc_adderx, dtc_addery = 4, 6
            elseif indicator_font == 'Normal' then
                dtc_adderx, dtc_addery = 4, 7
            elseif indicator_font == 'Bold' then
                dtc_adderx, dtc_addery = 4, 7
            elseif indicator_font == 'Big' then
                dtc_adderx, dtc_addery = 9, 16
            end
        elseif indicator_placement == 'Left' then
            x = x - 2
            if indicator_font == 'Small' then
                dtc_adderx, dtc_addery = -24, 6
            elseif indicator_font == 'Normal' then
                dtc_adderx, dtc_addery = -34, 7
            elseif indicator_font == 'Bold' then
                dtc_adderx, dtc_addery = -36, 7
            elseif indicator_font == 'Big' then
                dtc_adderx, dtc_addery = -66, 16
            end
        end
    
        if var.aa_dir ~= 0 then
            local adder = indicator_font == 'Big' and 80 or 50
            renderer_text(x - adder - 5, y + ind_height - 23, (var.aa_dir == -90 and not var.legitaaon) and 255 or 100, (var.aa_dir == -90 and not var.legitaaon) and 255 or 100, (var.aa_dir == -90 and not var.legitaaon) and 255 or 100, (var.aa_dir == -90 and not var.legitaaon) and 255 or 150, indicator_font == 'Big' and 'c+' or 'c+', nil, '<')
            renderer_text(x + adder + 5, y + ind_height - 23, (var.aa_dir == 90 and not var.legitaaon) and 255 or 100, (var.aa_dir == 90 and not var.legitaaon) and 255 or 100, (var.aa_dir == 90 and not var.legitaaon) and 255 or 100, (var.aa_dir == 90 and not var.legitaaon) and 255 or 150, indicator_font == 'Big' and 'c+' or 'c+', nil, '>')
        end
        renderer.text(x/45,y/1.2,255,255,255,255,'-',0,'ETHEREAL[LIVE] - V2 PANEL')
        renderer.text(x/45,y/1.2 + 8,255,255,255,255,'-',0,'LAST UPDATE 14/3/2023')
        renderer.text(x/45,y/1.2 + 16,255,255,255,255,'-',0,'AVOID OVERLAP - ' .. round(anti_aim_f.get_overlap(), 3))
        renderer.text(x/45,y/1.2 + 24,255,255,255,255,'-',0,'LOCAL BODY YAW - ' .. round(anti_aim_f.get_body_yaw(1), 3))
        renderer.text(x/45,y/1.2 + 32,255,255,255,255,'-',0,'SERVER BODY YAW - ' .. round(anti_aim_f.get_body_yaw(2), 3))
        renderer.text(x/45,y/1.2 + 40,255,255,255,255,'-',0,'CURRENT THREAT - ' ..string.upper(entity.get_player_name(client.current_threat())))

        if ui_get(vis_tab.crosshair_style) == 'gradient' or ui_get(vis_tab.crosshair_style) == 'off' then
            maintext = gradient_text(r1, g1, b1, 255, r2, g2, b2, 255, 'ETHEREAL')
        elseif ui_get(vis_tab.crosshair_style) == 'New V2' then
            maintext = ''
        elseif ui_get(vis_tab.crosshair_style) == 'New' then
            if anim_value == 0 then
                s_txt_r, s_txt_g, s_txt_b, s_txt_a = r2, g2, b2, a2
                o_txt_r, o_txt_g, o_txt_b, o_txt_a = r1, g1, b1, a1
                l_txt_r, l_txt_g, l_txt_b, l_txt_a = r1, g1, b1, a1
                a_txt_r, a_txt_g, a_txt_b, a_txt_a = r1, g1, b1, a1
                c_txt_r, c_txt_g, c_txt_b, c_txt_a = r1, g1, b1, a1
                e_txt_r, e_txt_g, e_txt_b, e_txt_a = r1, g1, b1, a1
                f_txt_r, f_txt_g, f_txt_b, f_txt_a = r1, g1, b1, a1
                g_txt_r, g_txt_g, g_txt_b, g_txt_a = r1, g1, b1, a1
            elseif anim_value == 1 then
                s_txt_r, s_txt_g, s_txt_b, s_txt_a = r1, g1, b1, a1
                o_txt_r, o_txt_g, o_txt_b, o_txt_a = r2, g2, b2, a2
                l_txt_r, l_txt_g, l_txt_b, l_txt_a = r1, g1, b1, a1
                a_txt_r, a_txt_g, a_txt_b, a_txt_a = r1, g1, b1, a1
                c_txt_r, c_txt_g, c_txt_b, c_txt_a = r1, g1, b1, a1
                e_txt_r, e_txt_g, e_txt_b, e_txt_a = r1, g1, b1, a1
                f_txt_r, f_txt_g, f_txt_b, f_txt_a = r1, g1, b1, a1
                g_txt_r, g_txt_g, g_txt_b, g_txt_a = r1, g1, b1, a1
            elseif anim_value == 2 then
                s_txt_r, s_txt_g, s_txt_b, s_txt_a = r1, g1, b1, a1
                o_txt_r, o_txt_g, o_txt_b, o_txt_a = r1, g1, b1, a1
                l_txt_r, l_txt_g, l_txt_b, l_txt_a = r2, g2, b2, a2
                a_txt_r, a_txt_g, a_txt_b, a_txt_a = r1, g1, b1, a1
                c_txt_r, c_txt_g, c_txt_b, c_txt_a = r1, g1, b1, a1
                e_txt_r, e_txt_g, e_txt_b, e_txt_a = r1, g1, b1, a1
                f_txt_r, f_txt_g, f_txt_b, f_txt_a = r1, g1, b1, a1
                g_txt_r, g_txt_g, g_txt_b, g_txt_a = r1, g1, b1, a1
            elseif anim_value == 3 then
                s_txt_r, s_txt_g, s_txt_b, s_txt_a = r1, g1, b1, a1
                o_txt_r, o_txt_g, o_txt_b, o_txt_a = r1, g1, b1, a1
                l_txt_r, l_txt_g, l_txt_b, l_txt_a = r1, g1, b1, a1
                a_txt_r, a_txt_g, a_txt_b, a_txt_a = r2, g2, b2, a2
                c_txt_r, c_txt_g, c_txt_b, c_txt_a = r1, g1, b1, a1
                e_txt_r, e_txt_g, e_txt_b, e_txt_a = r1, g1, b1, a1
                f_txt_r, f_txt_g, f_txt_b, f_txt_a = r1, g1, b1, a1
                g_txt_r, g_txt_g, g_txt_b, g_txt_a = r1, g1, b1, a1
            elseif anim_value == 4 then
                s_txt_r, s_txt_g, s_txt_b, s_txt_a = r1, g1, b1, a1
                o_txt_r, o_txt_g, o_txt_b, o_txt_a = r1, g1, b1, a1
                l_txt_r, l_txt_g, l_txt_b, l_txt_a = r1, g1, b1, a1
                a_txt_r, a_txt_g, a_txt_b, a_txt_a = r1, g1, b1, a1
                c_txt_r, c_txt_g, c_txt_b, c_txt_a = r2, g2, b2, a2
                e_txt_r, e_txt_g, e_txt_b, e_txt_a = r1, g1, b1, a1
                f_txt_r, f_txt_g, f_txt_b, f_txt_a = r1, g1, b1, a1
                g_txt_r, g_txt_g, g_txt_b, g_txt_a = r1, g1, b1, a1
            elseif anim_value == 5 then
                s_txt_r, s_txt_g, s_txt_b, s_txt_a = r1, g1, b1, a1
                o_txt_r, o_txt_g, o_txt_b, o_txt_a = r1, g1, b1, a1
                l_txt_r, l_txt_g, l_txt_b, l_txt_a = r1, g1, b1, a1
                a_txt_r, a_txt_g, a_txt_b, a_txt_a = r1, g1, b1, a1
                c_txt_r, c_txt_g, c_txt_b, c_txt_a = r1, g1, b1, a1
                e_txt_r, e_txt_g, e_txt_b, e_txt_a = r2, g2, b2, a2
                f_txt_r, f_txt_g, f_txt_b, f_txt_a = r1, g1, b1, a1
                g_txt_r, g_txt_g, g_txt_b, g_txt_a = r1, g1, b1, a1
            elseif anim_value == 6 then
                s_txt_r, s_txt_g, s_txt_b, s_txt_a = r1, g1, b1, a1
                o_txt_r, o_txt_g, o_txt_b, o_txt_a = r1, g1, b1, a1
                l_txt_r, l_txt_g, l_txt_b, l_txt_a = r1, g1, b1, a1
                a_txt_r, a_txt_g, a_txt_b, a_txt_a = r1, g1, b1, a1
                c_txt_r, c_txt_g, c_txt_b, c_txt_a = r1, g1, b1, a1
                e_txt_r, e_txt_g, e_txt_b, e_txt_a = r1, g1, b1, a1
                f_txt_r, f_txt_g, f_txt_b, f_txt_a = r2, g2, b2, a2
                g_txt_r, g_txt_g, g_txt_b, g_txt_a = r1, g1, b1, a1
            elseif anim_value == 7 then
                s_txt_r, s_txt_g, s_txt_b, s_txt_a = r1, g1, b1, a1
                o_txt_r, o_txt_g, o_txt_b, o_txt_a = r1, g1, b1, a1
                l_txt_r, l_txt_g, l_txt_b, l_txt_a = r1, g1, b1, a1
                a_txt_r, a_txt_g, a_txt_b, a_txt_a = r1, g1, b1, a1
                c_txt_r, c_txt_g, c_txt_b, c_txt_a = r1, g1, b1, a1
                e_txt_r, e_txt_g, e_txt_b, e_txt_a = r1, g1, b1, a1
                f_txt_r, f_txt_g, f_txt_b, f_txt_a = r1, g1, b1, a1
                g_txt_r, g_txt_g, g_txt_b, g_txt_a = r2, g2, b2, a2
            end
        
            local maintxt_s = gradient_text(s_txt_r, s_txt_g, s_txt_b, s_txt_a, s_txt_r, s_txt_g, s_txt_b, s_txt_a, 'E')
            local maintxt_o = gradient_text(o_txt_r, o_txt_g, o_txt_b, o_txt_a, o_txt_r, o_txt_g, o_txt_b, o_txt_a, 'T')
            local maintxt_L = gradient_text(l_txt_r, l_txt_g, l_txt_b, l_txt_a, l_txt_r, l_txt_g, l_txt_b, l_txt_a, 'H')
            local maintxt_a = gradient_text(a_txt_r, a_txt_g, a_txt_b, a_txt_a, a_txt_r, a_txt_g, a_txt_b, a_txt_a, 'E')
            local maintxt_c = gradient_text(c_txt_r, c_txt_g, c_txt_b, c_txt_a, c_txt_r, c_txt_g, c_txt_b, c_txt_a, 'R')
            local maintxt_e = gradient_text(e_txt_r, e_txt_g, e_txt_b, e_txt_a, e_txt_r, e_txt_g, e_txt_b, e_txt_a, 'E')
            local maintxt_f = gradient_text(f_txt_r, f_txt_g, f_txt_b, f_txt_a, f_txt_r, f_txt_g, f_txt_b, f_txt_a, 'A')
            local maintxt_g = gradient_text(g_txt_r, g_txt_g, g_txt_b, g_txt_a, g_txt_r, g_txt_g, g_txt_b, g_txt_a, 'L')
        
            maintext = ('%s%s%s%s%s%s%s%s'):format(maintxt_s, maintxt_o, maintxt_L, maintxt_a, maintxt_c, maintxt_e, maintxt_f, maintxt_g)

        end
    
        local dtclreased = easing.quad_out(var.dtclr, 0, 1, 1)
        local color = {255 - 255 * dtclreased, 255 * dtclreased, 0}
        local dtclrFT = globals_frametime() * anim_speed
        local doubletap = anti_aim_f.get_double_tap()
        var.dtclr = math_clamp(var.dtclr + (doubletap and dtclrFT or -dtclrFT), 0, 1)
    
        local body_yaw_slider_val = var.legitaaon and ui_get(ref.body_yaw[2]) * -1 or ui_get(ref.body_yaw[2])
        var.ab_type = body_yaw_slider_val > 1 and 'L' or 'R'
    
        local main_alpha = math_sin(math_abs(-math.pi + (globals_curtime() * (1 / 0.5)) % (math.pi * 2))) * 255
        if values[2] == 1 then
            var.roll_alpha = main_alpha
        else
            var.roll_alpha = values[2] * 255
        end
        if ui_get(vis_tab.crosshair_style) == 'New V2' then
        else
            --renderer_text(x / 3.5, y / 1.2, 255 ,255,255,255,'cb', 0, maintext .. ' Anti-Aim system [DEBUG]')
        end
    
        local items = {
            [1] = { true, maintext, { 255, 255, 255, 255 } },
            [2] = { var.roll_enabled, 'ROLL AA', { 126, 255, 224, 255 } },
            [3] = { var.lp_miss ~= 0 and ((contains(aa_tab.antibruteforce_conditions, var.antiaim_state)) or var.roll_enabled), 'AB[' .. var.lp_miss .. ']:[' .. var.ab_timer .. ']:[' .. var.ab_type .. ']', { 255, 50, 100, 255 } },
            [4] = { ui_get(ref.doubletap[1]) and ui_get(ref.doubletap[2]), 'DT', { color[1], color[2], color[3], 255 } },
            [5] = { ui_get(ref.onshotaa[1]) and ui_get(ref.onshotaa[2]), 'ONSHOT', { 225, 170, 160, 255 } },
            [6] = { ui_get(ref.safepoint), 'SAFE', { 120, 200, 120, 255 } },
            [7] = { ui_get(ref.forcebaim), 'BAIM', { 170, 50, 255, 255 } },
            [8] = { ui_get(ref.fakeduck), 'DUCK', { 80, 80, 255, 255 } },
            [9] = { ui_get(aa_tab.freestanding) and contains(aa_tab.binds, 'Freestanding'), 'FREESTAND', { 220, 220, 220, 255 } },
            [10] = { ui_get(ref.ping_spike[1]) and ui_get(ref.ping_spike[2]), 'PING', { 150, 200, 60, 255 } }
        }
        if ui_get(vis_tab.crosshair_style) ~= 'off' then
        for i, ref in ipairs(items) do
            local text_width, text_height = renderer_measure_text(ind_font, ref[2])
            local key = ui_get(vis_tab.crosshair_animstyle) == 'New' and (ref[1] and 1.1 or 0) or ref[1]
            local FT = globals_frametime() * anim_speed
    
            if i == 2 then
                ind_offset = ind_offset + 1
            end
    
            values[i] = ui_get(vis_tab.crosshair_animstyle) == 'New' and (math_clamp(lerp(values[i], key, globals_frametime() * 5 * 1.5), 0, 1)) or (easing.linear(values[i] + (key and FT or -FT), 0, 1, 1))
    
            if entity_get_prop(entity_get_local_player(), 'm_bIsScoped') == 1 and indicator_placement == 'Center' then
                x_state = animation(entity_get_prop(entity_get_local_player(), 'm_bIsScoped') == 1, x_state, 25, 0.7)
            else
                x_state = animation(entity_get_prop(entity_get_local_player(), 'm_bIsScoped') == 0, x_state, 0, 0.7)
            end
    
            renderer_text(x + x_state, y + ind_height + ind_offset * values[i], ref[3][1], ref[3][2], ref[3][3], ref[3][4] * values[i], ind_font, text_width * values[i] + 3, ref[2])
            if ui_get(vis_tab.crosshair_style) == 'New V2' then
            local aA = create_color_array(r2, b2, g2)

            renderer.text(x + x_state, y + ind_height, r1, g1, b1, 50, ind_font, nil, 'ETHEREAL')
            renderer.text(x + x_state, y + ind_height ,ref[3][1], ref[3][2], ref[3][3], ref[3][4] * values[i] ,ind_font,nil,string.format(
                '\a%sE\a%sT\a%sH\a%sE\a%sR\a%sE\a%sA\a%sL',
                RGBAtoHEX(unpack(aA[1])),
                RGBAtoHEX(unpack(aA[2])),
                RGBAtoHEX(unpack(aA[3])),
                RGBAtoHEX(unpack(aA[4])),
                RGBAtoHEX(unpack(aA[5])),
                RGBAtoHEX(unpack(aA[6])),
                RGBAtoHEX(unpack(aA[7])),
                RGBAtoHEX(unpack(aA[8]))
            ))
        end
    
            ind_offset = ind_offset + (text_add + ind_separator) * values[i]
        end
    end
    end
    
    local data = { }
    
    local function resolve_flag_get()
        data = { }
    
        local players = entity_get_players(true)
        for i, player in ipairs(players) do repeat
            local body_yaw = entity_get_prop(player, 'm_flPoseParameter', 11)
            if not body_yaw then
                break
            end
    
            data[ player ] = body_yaw * 120 - 60
        until true end
    end
    
    client_register_esp_flag('0', 255, 255, 255, function(entindex)
        if not ui_get(misc_tab.resolve_flag) then
            return false
        end
    
        local info = data[ entindex ]
        if not info then
            return false
        end
    
        return true, ('%.0f*'):format(info)
    end)
    
    --force def
    client_set_event_callback('setup_command', function(cmd)
        if ui_get(misc_tab.force_def) then
            cmd.force_defensive = 1
        end
    end)

    local function calc_angle(start_pos, end_pos)
        if start_pos[1] == nil or end_pos[1] == nil then
            return {0, 0}
        end

        local delta_x, delta_y, delta_z = end_pos[1] - start_pos[1], end_pos[2] - start_pos[2], end_pos[3] - start_pos[3]

        if delta_x == 0 and delta_y == 0 then
            return {(delta_z > 0 and 270 or 90), 0}
        else
            local hyp = math_sqrt(delta_x*delta_x + delta_y*delta_y)
    
            local pitch = math_deg(math_atan2(-delta_z, hyp))
            local yaw = math_deg(math_atan2(delta_y, delta_x))
    
            return {pitch, yaw}
        end
    end

    --clantag
    local clan_tag_prev = ''
    
    local function time_to_ticks(time)
        return math_floor(time / globals_tickinterval() + .5)
    end
    
    local function gamesense_anim(text, indices)
        local text_anim = '               ' .. text .. '                      ' 
        local tickinterval = globals_tickinterval()
        local tickcount = globals_tickcount() + time_to_ticks(client_latency())
        local i = tickcount / time_to_ticks(0.5)
        i = math_floor(i % #indices)
        i = indices[i+1]+1
    
        return string_sub(text_anim, i, i+15)
    end
    
    local function run_tag_animation()
        if ui_get(misc_tab.clantag) then
            local clan_tag = gamesense_anim('ETHEREAL', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22})
            if clan_tag ~= clan_tag_prev then
                client_set_clan_tag(clan_tag)
            end
            clan_tag_prev = clan_tag
        end
    end
    
    local disable_clantag = false
    
    local function clantag_paint()
        local enabled = ui_get(misc_tab.clantag)
        if enabled then
            local local_player = entity_get_local_player()
            if local_player ~= nil and (not entity_is_alive(local_player)) and globals_tickcount() % 2 == 0 then --missing noclip check
                run_tag_animation()
            end
            disable_clantag = true
        elseif not enabled and disable_clantag then
            client_set_clan_tag('\0')
            disable_clantag = false
        end
    end

    local function fakelagbreak()
        local enabled = ui_get(misc_tab.fakelag_break)
        local random = math.random(1,3)

        if enabled then
            ui_set(ref.variance, math.random(0,30))
            if random == 1 then
                ui_set(ref.amout, 'Maximum')
            elseif random == 2 then
                ui_set(ref.amout, 'Dynamic')
            elseif random == 3 then
                ui_set(ref.amout, 'Fluctuate')
            end
        end
    end
    
    local function clantag_run_command(e)
        if ui_get(misc_tab.clantag) then
            if e.chokedcommands == 0 then
                run_tag_animation()
            end
        end
    end

    local remove_aa = false
    
    local function hideskeetmenu()
        local master_switch = ui_get(master_switch)
        --skeetmenu
        ui_set_visible(ref.pitch[1], not master_switch)
        ui_set_visible(ref.pitch[2], not master_switch)

        ui_set_visible(ref.yaw_base, not master_switch)
        ui_set_visible(ref.yaw[1], not master_switch)
        ui_set_visible(ref.yaw[2], not master_switch)
        ui_set_visible(ref.yaw_jitter[1], not master_switch)
        ui_set_visible(ref.yaw_jitter[2], not master_switch)
        ui_set_visible(ref.body_yaw[1], not master_switch)
        ui_set_visible(ref.body_yaw[2], not master_switch)
        ui_set_visible(ref.freestanding_body_yaw, not master_switch)
        ui_set_visible(ref.fake_yaw_limit, not master_switch)
        ui_set_visible(ref.edge_yaw, not master_switch)
        ui_set_visible(ref.freestanding[2], not master_switch)
        ui_set_visible(ref.freestanding[1], not master_switch)
        ui_set_visible(ref.roll, not master_switch)
    
        if master_switch then
            ui_set(ref.roll, 0)
        end
    
        if master_switch and not remove_aa then
            remove_aa = true
        end
    
        if not master_switch and remove_aa then
            ui_set(ref.pitch[1], 'Off')
            ui_set(ref.yaw_base, 'Local view')
            ui_set(ref.yaw[1], 'Off')
            ui_set(ref.yaw[2], '0')
            ui_set(ref.yaw_jitter[1], 'Off')
            ui_set(ref.yaw_jitter[2], 0)
            ui_set(ref.body_yaw[1], 'Off')
            ui_set(ref.body_yaw[2], 0)
            ui_set(ref.freestanding_body_yaw, false)
            ui_set(ref.fake_yaw_limit, 60)
            ui_set(ref.edge_yaw, false)
            ui_set(ref.roll, 0)
            ui_set_visible(ref.leg_movement, true)
    
            remove_aa = false
        end
    end
    
    local function anti_backstab()
        if ui_get(misc_tab.anti_backstab) then
            local players = entity_get_players(true)
            local lx, ly, lz = entity_get_prop(entity_get_local_player(), 'm_vecOrigin')
            if players == nil then return end
            for i=1, #players do
                local x, y, z = entity_get_prop(players[i], 'm_vecOrigin')
                local distance = anti_knife_dist(lx, ly, lz, x, y, z)
                local weapon = entity_get_player_weapon(players[i])
                if entity_get_classname(weapon) == 'CKnife' and distance <= ui_get(misc_tab.anti_backstab_distance) then
                    ui_set(ref.yaw[2], 180)
                    ui_set(ref.pitch[1], 'Off')
                    ui_set(ref.yaw_base, 'At targets')
                    
                end
            end
        end
    end
    
    local function on_setup_command(e)
        local master_switch = ui_get(master_switch)
        if not master_switch then return end
    
        local main_aa_enabled = ui_get(aa_tab.main_aa)
        local aa_builder_enabled = ui_get(conditional_aa)
        
        aa_on_use(e)
        handle_shots()
        handle_menu()
    
        if main_aa_enabled then
            player_condition_main(e)
            handle_main_antiaim(e)
        elseif aa_builder_enabled then
            player_condition_builder(e)
            handle_builder_antiaim()
        end
    
        if ui_get(misc_tab.resolve_flag) then
            resolve_flag_get()
        end

        if ui_get(misc_tab.leg_anim_breaker) then
            leg_breaker(e)
        end
        
        clantag_run_command(e)
        pitchbreaker(e)
        anti_backstab()
        
    end
    
    local function onpaint()
        local master_switch = ui_get(master_switch)
        if not master_switch then return end

        if ui_get(misc_tab.fakelag_break) then
            fakelagbreak()
        end

        handle_indicators()
        clantag_paint()
    end
    
    client_set_event_callback('paint_ui', function()
        hideskeetmenu()
        defensivepitch()
    
        local master_switch = ui_get(master_switch)
        if not master_switch then return end
    
        b_body()
        antibrute_time()
        
        --antibrute_reset()
    
        maintxt_reset = false
    
        if ui_get(vis_tab.crosshair_style) == 'New' then
            handle_animation()
        end
    end)
    
    local function pre_render()
        local master_switch = ui_get(master_switch)
        if not master_switch then return end
    
        if ui_get(misc_tab.leg_in_air) then
            entity_set_prop(entity_get_local_player(), 'm_flPoseParameter', 1, 6) 
        end
        
        local self_index = c_entity.new(entity_get_local_player())
        if not self_index then
            return
        end
        local self_anim_overlay = self_index:get_anim_overlay(12)
        local my_animlayer = self_index:get_anim_overlay(6)
        if not self_anim_overlay then
            return
        end

        local x_velocity = entity.get_prop(entity_get_local_player(), 'm_vecVelocity[0]')
        if math.abs(x_velocity) >= 3 and ui_get(misc_tab.leg_anim_breaker) then
            self_anim_overlay.weight = 1
        end        

        local m_fFlags = entity.get_prop(entity_get_local_player(), 'm_fFlags')
        local is_onground = bit.band(m_fFlags, 1) ~= 0

        if not is_onground and ui_get(misc_tab.leg_anim_breaker) then
            my_animlayer.weight = 1
        end

        if ui_get(misc_tab.leg_anim_breaker) then
            entity_set_prop(entity_get_local_player(), 'm_flPoseParameter', 0, 7)
            entity_set_prop(entity_get_local_player(), 'm_flPoseParameter', 1, globals.tickcount() % 4 > 1 and 5 / 10 or 1)
        end
    end
    
    local function handle_callbacks()
        client_color_log(129, 198, 255, 'ETHEREAL')
    
        --ui_set_callback(master_switch, handle_menu)
        ui_set_callback(active_tab, handle_menu)
        ui_set_callback(aa_tab.main_aa, handle_menu)
        ui_set_callback(aa_tab.antibruteforce, handle_menu)
        ui_set_callback(aa_tab.binds, handle_menu)
        ui_set_callback(misc_tab.leg_anim_breaker, handle_menu)
        ui_set_callback(misc_tab.leg_in_air, handle_menu)
        ui_set_callback(vis_tab.crosshair_style, handle_menu)
        ui_set_callback(vis_tab.crosshair_main_animstyle, handle_menu)
        ui_set_callback(preset_changer, handle_menu)
        ui_set_callback(preset_selector, handle_menu)
        ui_set_callback(conditional_aa, handle_menu)
        ui_set_callback(active_condition, handle_menu)
    end
    handle_callbacks()
    --ui_set_callback(master_switch, handle_callbacks)
    
    local function on_player_death(e)
        if client_userid_to_entindex(e.userid) == entity_get_local_player() then
            reset_data(false)
            var.lp_miss = 0
            var.enemy_shot_time = -1
            anim_timer = globals_curtime()
            var.aa_dir = 0
            swapway = 0
            tbl.checker = 0
            tbl.defensive = 0
        end
    end
    
    local function on_round_start()
        reset_data(false)
        var.lp_miss = 0
        var.enemy_shot_time = -1
        anim_timer = globals_curtime()
        var.aa_dir = 0
        swapway = 0
    end
    
    local function on_client_disconnect()
        reset_data(false)
        var.lp_miss = 0
        var.enemy_shot_time = -1
        swapway = 0
        tbl.checker = 0
        tbl.defensive = 0
    end
    
    local function on_game_newmap()
        reset_data(false)
        var.lp_miss = 0
        var.enemy_shot_time = -1
        swapway = 0
        tbl.checker = 0
        tbl.defensive = 0
    end
    
    local function on_cs_game_disconnected()
        reset_data(false)
        var.lp_miss = 0
        var.enemy_shot_time = -1
        swapway = 0
        tbl.checker = 0
        tbl.defensive = 0
    end
    
    local ui_callback = function(c)
        local master_switch, addr = ui_get(c), ''
    
        if not master_switch then
            maintxt_reset, addr = true, 'un'
        end
    
        handle_menu()
        
        local _func = client[addr .. 'set_event_callback']
    
        _func('setup_command', on_setup_command)
    
        _func('paint', onpaint)
            
        _func('pre_render', pre_render)
    
        _func('bullet_impact', on_bullet_impact)
    
        _func('player_hurt', on_player_hurt)
    
        _func('player_death', on_player_death)
    
        _func('round_start', on_round_start)
    
        _func('client_disconnect', on_client_disconnect)
    
        _func('game_newmap', on_game_newmap)
    
        _func('cs_game_disconnected', on_cs_game_disconnected)

    end
    ui_set_callback(master_switch, ui_callback)
    ui_callback(master_switch)
    
    client_set_event_callback('shutdown', function()
        ui_set_visible(ref.pitch[1], true)
        ui_set_visible(ref.yaw_base, true)
        ui_set_visible(ref.yaw[1], true)
        ui_set_visible(ref.yaw[2], true)
        ui_set_visible(ref.yaw_jitter[1], true)
        ui_set_visible(ref.yaw_jitter[2], true)
        ui_set_visible(ref.body_yaw[1], true)
        ui_set_visible(ref.body_yaw[2], true)
        ui_set_visible(ref.freestanding_body_yaw, true)
        ui_set_visible(ref.fake_yaw_limit, true)
        ui_set_visible(ref.freestanding[2], true)
        ui_set_visible(ref.freestanding[1], true)
        ui_set_visible(ref.edge_yaw, true)
        ui_set_visible(ref.roll, true)
        ui_set_visible(ref.leg_movement, true)
    
        client_set_cvar('cl_bodyspeed', 450)
        client_set_cvar('cl_forwardspeed', 450)
        client_set_cvar('cl_backspeed', 450)
        client_set_cvar('cl_bodyspeed ', 450)
        client_set_cvar('cl_upspeed ', 450)
    
        local master_switch = ui_get(master_switch)
        if not master_switch then return end
    
        ui_set(ref.pitch[1], 'Off')
        ui_set(ref.yaw_base, 'Local view')
        ui_set(ref.yaw[1], 'Off')
        ui_set(ref.yaw[2], '0')
        ui_set(ref.yaw_jitter[1], 'Off')
        ui_set(ref.yaw_jitter[2], 0)
        ui_set(ref.body_yaw[1], 'Off')
        ui_set(ref.body_yaw[2], 0)
        ui_set(ref.freestanding_body_yaw, false)
        ui_set(ref.fake_yaw_limit, 60)
        ui_set(ref.edge_yaw, false)
        ui_set(ref.roll, 0)
    end)
