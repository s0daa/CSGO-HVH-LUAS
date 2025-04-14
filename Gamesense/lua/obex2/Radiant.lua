-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
    -- SO MARY REQUIRES
local ffi = require 'ffi'
local easing = require 'gamesense/easing'
local surface = require 'gamesense/surface'
local images = require 'gamesense/images'
local vector = require 'vector'
local trace = require 'gamesense/trace'
local http = require 'gamesense/http'
local websockets = require 'gamesense/websockets'
local anti_aim = require "gamesense/antiaim_funcs"
local csgo_weapons = require 'gamesense/csgo_weapons'

local function anti_aim()
    local clipboard = {};local b=vtable_bind('vgui2.dll','VGUI_System010',7,'int(__thiscall*)(void*)')local c=vtable_bind('vgui2.dll','VGUI_System010',9,'void(__thiscall*)(void*, const char*, int)')local d=vtable_bind('vgui2.dll','VGUI_System010',11,'int(__thiscall*)(void*, int, const char*, int)')local e=ffi.typeof('char[?]')function clipboard.get()local f=b()if f>0 then local g=e(f)d(0,g,f)return ffi.string(g,f-1)end end;clipboard.paste=clipboard.get;function clipboard.set(h)h=tostring(h)c(h,h:len())end;clipboard.copy=clipboard.set

    local tab, container = 'AA', 'Anti-aimbot angles'

    local callbacks = {
        list = {},

        create = function(self, name, event, func)
            if type(event) ~= 'table' then
                self.list[name] = {event = event, func = func}
            else
                for k, v in pairs(event) do
                    self.list[name] = {event = v, func = func}
                end
            end
        end,

        handle_list = function(self, enabled)
            local set_callback = enabled and client.set_event_callback or client.unset_event_callback
            for k, v in pairs(self.list) do
                set_callback(self.list[k].event, self.list[k].func)
            end
        end,
    }

    local funcs = {
        contains = function(b,c)for d=1,#b do if b[d]==c then return true end end;return false end,
        clamp = function(b,c,d)return math.min(d,math.max(c,b))end,
        table_visible = function(a,b)for c,d in pairs(a)do if type(a[c])=='table'then for e,d in pairs(a[c])do ui.set_visible(a[c][e],b)end else ui.set_visible(a[c],b)end end end,
        is_stabable = function(self,b)if not self or not b then return false end;local c={entity.get_prop(self,'m_vecOrigin')}local d={entity.get_prop(b,'m_vecOrigin')}if not c or not d then return false end;local e=entity.get_player_weapon(b)if entity.get_classname(e)~='CKnife'then return false end;local f=math.sqrt(math.pow(d[1]-c[1],2)+math.pow(d[2]-c[2],2)+math.pow(d[3]-c[3],2))if f<=100 then return true end end,
        copy = function(self,a,b)if type(a)~='table'then return a end;if b and b[a]then return b[a]end;local c=b or{}local d=setmetatable({},getmetatable(a))c[a]=d;for e,f in pairs(a)do d[self:copy(e,c)]=self:copy(f,c)end;return d end,

        calc_angle = function(start_pos, end_pos)
            if start_pos.x == nil or end_pos.y == nil then
                return {0, 0}
            end

            local delta_x, delta_y, delta_z = end_pos.x - start_pos.x, end_pos.y - start_pos.y, end_pos.z - start_pos.z

            if delta_x == 0 and delta_y == 0 then
                return {(delta_z > 0 and 270 or 90), 0}
            else
                local hyp = math.sqrt(delta_x*delta_x + delta_y*delta_y)
        
                local pitch = math.deg(math.atan2(-delta_z, hyp))
                local yaw = math.deg(math.atan2(delta_y, delta_x))
        
                return {pitch, yaw}
            end
        end,

        normalize_yaw = function(yaw)
            yaw = (yaw % 360 + 360) % 360
            return yaw > 180 and yaw - 360 or yaw
        end,
    }

    local m = {
        -- Tables
        modes, ref, move_states,mclrs, menu, 

        init = function(self)
            self.modes = {'Automatic', 'Movement', 'Advanced'}

            self.ref = {
                load = ui.reference('CONFIG', 'Presets', 'Load'),
                maxusrcmd = ui.reference('MISC', 'Settings', 'sv_maxusrcmdprocessticks'),
                fl_limit = ui.reference(tab, 'Fake lag', 'Limit'),
                double_tap = { ui.reference('RAGE', 'Other', 'Double tap') },
                on_shot_aa = { ui.reference('AA', 'Other', 'On shot anti-aim') },
                dt_fl_limit = ui.reference('RAGE', 'Other', 'Double tap fake lag limit'),
                slow_walk = {ui.reference(tab, 'Other', 'Slow motion')},
                leg_movement = ui.reference('AA', 'Other', 'Leg movement'),
                fake_duck = ui.reference('rage','other','Duck peek assist'),
                aa = {
                    enabled = ui.reference(tab, container, 'Enabled'),
                    pitch = ui.reference(tab, container, 'Pitch'),
                    yaw_base = ui.reference(tab, container, 'Yaw base'),
                    yaw = {ui.reference(tab, container, 'Yaw')},
                    yaw_jitter = {ui.reference(tab, container, 'Yaw jitter')},
                    body_yaw = {ui.reference(tab, container, 'Body yaw')},
                    freestand = ui.reference(tab, container, 'Freestanding body yaw'),
                    fake_yaw = ui.reference(tab, container, 'Fake yaw limit'),
                    edge_yaw = ui.reference(tab, container, 'Edge yaw'),
                    freestanding = {ui.reference(tab, container, 'Freestanding')},
                    roll = ui.reference(tab, container, 'Roll'),
                }
            }

            self.move_states = {
                elem   = {'General', "Vulnerable", 'Duck', 'Stand', 'Slow', 'Run', 'Jump'},
                combo  = {'General', "Vulnerable", 'Ducking', 'Standing', 'Slow motion', 'Running', 'Jumping'},
            }

            self.mclrs = {
                main = '\aFF4444FF',
                gray = '\aD5D5D5FF',
                yellow = '\ab1b160ff',
            }

            self.menu = {
                enabled = ui.new_checkbox(tab, container, string.format('%sRadiant %santi-aim', self.mclrs.main, self.mclrs.gray)),
                mode = ui.new_combobox(tab, container, '\n', self.modes),
            
                automatic = { },
            
                -- general, ducking, standing, slow motion, running, jumping, 
                -- movement 
                movement = {
                    state_combo = ui.new_combobox(tab, container, 'Movement state:', self.move_states.combo),
                    states = self:init_states(self.move_state),
                },
            
                -- advanced
                advanced = {
                    state_combo = ui.new_combobox(tab, container, 'Movement state:', self.move_states.combo),
                    states = self:init_states(self.adv_state),
                },

                options = {
                    multi2 = ui.new_multiselect(tab, container, string.format('%s %s', self:as_tag('Other'), 'Options', self.mclrs.gray), 
                        {'Override pitch & yaw', 'Low FPS mitigations', 'Shot detection', 'Anti backstab', 'Ladder fix'}),

                        brute_combo  = ui.new_combobox(tab, container, string.format('%s %s', self:as_tag('Other'), 'Shot detection mode'), {'Automatic stages', 'Inverse angle', 'Detect missed angle', 'Custom angle'}),
                        custom_body1 = ui.new_combobox(tab, container, string.format('%s %s', self:as_tag('Other'), 'Invert body yaw'), {'Static', 'Jitter', 'Opposite'}),
                        custom_body2 = ui.new_slider  (tab, container, '\nInvert body yaw', -180, 180, 0, true, '°'),
                        custom_body3 = ui.new_slider  (tab, container, '\nInvert fake', 0, 60, 0, true, '°'),

                    multi1 = ui.new_multiselect(tab, container, string.format('%s %s', self:as_tag('Hotkey'), 'Options', self.mclrs.gray), 
                        {'Force defensive', 'Freestand yaw', 'Legit anti-aim', 'Manual yaw', 'Edge yaw', 'Force roll'}),

                        freestand_hk    = ui.new_hotkey(tab, container, string.format('%s %s', self:as_tag('Hotkey'), 'Freestand yaw'), false),
                        legit_aa_hk     = ui.new_hotkey(tab, container, string.format('%s %s', self:as_tag('Hotkey'), 'Legit anti-aim'), false),
                        edge_yaw_hk     = ui.new_hotkey(tab, container, string.format('%s %s', self:as_tag('Hotkey'), 'Edge yaw'), false),
                        defensive_hk    = ui.new_hotkey(tab, container, string.format('%s %s', self:as_tag('Hotkey'), 'Force defensive'), false),
                        force_roll_hk   = ui.new_hotkey(tab, container, string.format('%s %s', self:as_tag('Hotkey'), 'Force roll'), false),
                        manual_l_hk     = ui.new_hotkey(tab, container, string.format('%s %s', self:as_tag('Hotkey'), 'Left yaw'), false),
                        manual_l_hk_ref = ui.new_hotkey(tab, container, 'Left yaw', false),
                        manual_r_hk     = ui.new_hotkey(tab, container, string.format('%s %s', self:as_tag('Hotkey'), 'Right yaw'), false),
                        manual_r_hk_ref = ui.new_hotkey(tab, container, 'Right yaw', false),
                }
            }

            funcs.table_visible({self.menu.options.manual_l_hk_ref, self.menu.options.manual_r_hk_ref}, false)
        end,
        
        -- Helpers
        as_tag = function(self, str)
            return string.format('%s[%s%s%s]', self.mclrs.gray, self.mclrs.main, str, self.mclrs.gray)
        end,

        create_items = function(self, tag, sp)
            return {
                yaw = {
                    ui.new_slider(tab, container, string.format('%s Yaw offset%s', tag, sp), -180, 180, 0, true, '°'),
                },
                yaw_jitter = {
                    ui.new_combobox(tab, container, string.format('%s Yaw jitter%s', tag, sp), {'Off', 'Offset', 'Center', 'Random'}),
                    ui.new_slider(tab, container, string.format('\n%s Yaw jitter offset%s', tag, sp), -180, 180, 0, true, '°'),
                },
                body_yaw = {
                    ui.new_combobox(tab, container, string.format('%s Body yaw%s', tag, sp), {'Off', 'Static', 'Jitter', 'Opposite', 'Freestand', 'Reverse'}),
                    ui.new_slider(tab, container, string.format('\n%s Body yaw value%s', tag, sp), -180, 180, 0, true, '°'),
                },
                fake_yaw = {
                    ui.new_combobox(tab, container, string.format('%s Fake yaw limit%s', tag, sp), {'Static', 'Jitter', 'Step', 'Sway', 'Random'}),
                    ui.new_slider(tab, container, string.format('\n%s Fake yaw value%s', tag, sp), 0, 60, 30, true, '°'),
                },
                roll = {
                    ui.new_combobox(tab, container, string.format('%s Roll%s', tag, sp), {'Off', 'Static', 'Freestand', 'Reversed'}),
                    ui.new_combobox(tab, container, string.format('\n%s Roll option%s', tag, sp), {'Static', 'Jitter', 'Step', 'Random', 'Sway'}),
                    ui.new_slider(tab, container, string.format('\n%s Roll value1%s', tag, sp), -50, 50, 0, true, '°'),
                    ui.new_slider(tab, container, string.format('\n%s Roll value2%s', tag, sp), 0, 50, 50, true, '°'),
                },    
            }
        end,

        items_visible = function(self, m_items, active)
            ui.set_visible(m_items.yaw_jitter[2], active and ui.get(m_items.yaw_jitter[1]) ~= 'Off')
            ui.set_visible(m_items.body_yaw[2], active and ui.get(m_items.body_yaw[1]) ~= 'Off' and ui.get(m_items.body_yaw[1]) ~= 'Opposite' and ui.get(m_items.body_yaw[1]) ~= 'Freestand' and ui.get(m_items.body_yaw[1]) ~= 'Reverse')
            funcs.table_visible({m_items.fake_yaw[1], m_items.fake_yaw[2]}, active and ui.get(m_items.body_yaw[1]) ~= 'Off')
            ui.set_visible(m_items.roll[2], active and ui.get(m_items.roll[1]) ~= 'Off')
            ui.set_visible(m_items.roll[3], active and ui.get(m_items.roll[1]) ~= 'Off' and ui.get(m_items.roll[1]) == 'Static')
            ui.set_visible(m_items.roll[4], active and ui.get(m_items.roll[1]) ~= 'Off' and ui.get(m_items.roll[1]) ~= 'Static')
        end,

        -- MENU : Movement
        move_state = function(self, num)
            local sp = ' '; for i = 1, num do sp = sp .. ' ' end -- gay spacer shit 
            local tag = self:as_tag(self.move_states.elem[num])
            return {
                name = self.move_states.combo[num],
                enabled = num ~= 1 and ui.new_checkbox(tab, container, string.format('%s Enable %s', tag, sp)) or nil,
                items = self:create_items(tag, sp)
            }
        end,

        -- MENU : Advanced
        adv_state = function(self, num)
            local sp = ' ';for i = 1, num do sp = sp .. ' ' end
            local tag = self:as_tag(self.move_states.elem[num])
            return {
                name = self.move_states.combo[num],
                enabled =  num ~= 1 and ui.new_checkbox(tab, container, string.format('%s Enable       %s', tag, sp)) or nil, -- has to be spread out cuz names are taken
                side = ui.new_combobox(tab, container, string.format('%s Peek Side%s', tag, sp), {'Left', 'Right'}),
                items = {
                    left  = self:create_items(self:as_tag('Left'), sp),
                    right = self:create_items(self:as_tag('Right'), sp),
                }
            }
        end,

        -- MENU : Init Move or Adv
        init_states = function(self, state_func)
            local to_return = {}
            for i = 1, #self.move_states.elem do
                to_return[i] = state_func(self, i)
            end
            return to_return
        end,
    }
    m:init()

    local configs = {     
        import_bttn,
        export_bttn,

        init = function(self)
            self.import_bttn = ui.new_button(tab, container, 'Import from clipboard', function()
                self:import()
            end)
            self.export_bttn = ui.new_button(tab, container, 'Export to clipboard', function()
                self:export()
            end)
        end,

        get_recursion = function(self, tab)
            local to_export = {}
            for i, v in pairs(tab) do
                if type(v) == 'table' then 
                    to_export[i] = self:get_recursion(v)
                elseif type(v) == 'number' and not string.find(i, 'label') then
                    to_export[i] = ui.get(v)
                end
            end
            return to_export
        end,

        export = function(self)
            local str_tbl = json.stringify(self:get_recursion(m.menu))
        
            -- encode config
            --local encoded = base64.encode(str_tbl)
            --print(encoded)
            clipboard.set(str_tbl)
        end,
        
        set_recursion =  function(self, tab, pre_str)
            pre_str = pre_str or ''
            for i, v in pairs(tab) do
                if type(v) == 'table' and i ~= 'multi1' and i ~= 'multi2' then
                    self:set_recursion(v, string.format('%s%s*', pre_str, i))
                else
                    local indexs, str = {}, pre_str
                    while string.find(str, '*') do
                        local j = string.find(str, '*')
                        table.insert(indexs, string.sub(str, 1, j-1))
                        str = string.sub(str, j+1, #str)
                    end
                    table.insert(indexs, tostring(i))
        
                    local dive = m.menu
                    for k, j in pairs(indexs) do
                        if type(dive) ~= 'table' then break end
                        dive = dive[#j == 1 and tonumber(j) or j]
                    end
        
                    if not string.find(i, 'hk') then -- we hate Hotkey, fuck em
                        ui.set(dive, v)
                    end
                end
            end
        end,

        import = function(self)
            local to_import = json.parse(clipboard.get())
            self:set_recursion(to_import)
        end,
    }
    configs:init()

    local scan = {
        last_scanned = globals.curtime(),
        is_vulnerable = false,
        scan_width  = 10,
        scan_length = 50,
        
        scan_result, last_result,
        scan_clear = {
            is_active = false, 
            side = 'left', 
            vector = vector(0, 0, 0), 
            index = client.current_threat(), 
            length = scan_length
        },

        
        init = function(self)
            self.scan_result = funcs:copy(self.scan_clear)
            self.last_result = funcs:copy(self.scan_clear)
        end,

        vector_angles = function(start, dest)
            local origin, target
            if dest == nil then
                target, origin = start, Vector3(client_eye_position())
                if origin.x == nil then
                    return
                end
            else
                origin, target = start, dest
            end

            local delta = target - origin
            if delta.x == 0 and delta.y == 0 then
                return 0, (delta.z > 0 and 270 or 90)
            else
                local yaw = math.deg(math.atan2(delta.y, delta.x))
                local hyp = math.sqrt(delta.x * delta.x + delta.y * delta.y)
                local pitch = math.deg(math.atan2(-delta.z, hyp))

                return pitch, yaw
            end
        end,

        check_overlap = function(left, right)
            if left and not right then
                return left
            elseif not left and right then
                return right
            end

            if left.is_active and right.is_active then
                if left.length < right.length then
                    return left
                elseif left.length > right.length then
                    return right
                end
            else
                return left.is_active and left or right
            end
        end,

        scan_side = function(self, ent, local_eye, target_eye, side_angle, side_pos, side_str)
            local add, dam, j = 15, 0, 0
            local init_pos = side_pos
            while dam < 1 and add < self.scan_length do
                side_pos = local_eye + side_angle * add
                _, dam = client.trace_bullet(ent, target_eye.x, target_eye.y, target_eye.z, side_pos.x, side_pos.y, side_pos.z)
                add = add + self.scan_width
                if trace.line(init_pos, side_pos).fraction < 1 and j > 4 then
                    return nil
                end
                init_pos = side_pos
                j = j + 1
            end
            return add <= self.scan_length and {
                is_active = true, 
                vector = side_pos, 
                index = ent, 
                length = add, 
                side = side_str,
            } or nil
        end,

        angle_right = function(a) -- unminified
            local b = math.sin(math.rad(a.x))
            local c = math.cos(math.rad(a.x))
            local d = math.sin(math.rad(a.y))
            local e = math.cos(math.rad(a.y))
            local f = math.sin(math.rad(a.z))
            local g = math.cos(math.rad(a.z))
            return vector(-1.0 * f * b * e + -1.0 * g * -d, -1.0 * f * b * d + -1.0 * g * e, -1.0 * f * c)
        end,

        get_scan_result = function(self, b) -- also unminified
            if b == -1 then
                return nil
            end
            if not entity.is_alive(b) or not entity.is_enemy(b) then
                return nil
            end
            local c = entity.get_local_player()
            local d = vector(client.eye_position())
            local e = vector(entity.get_origin(c))
            local f = vector(entity.get_prop(b, 'm_vecVelocity'))
            local g = vector(entity.get_prop(b, 'm_vecOrigin')) + (f / 4)
            local h = g + vector(entity.get_prop(b, 'm_vecViewOffset'))
            local i, j = self.vector_angles(e, g)
            local k = vector(i, j, 0)
            local l = self.angle_right(k)
            local m = -self.angle_right(k)
            local n = d + m * self.scan_width
            local o = d + l * self.scan_width
            local p = vector(entity.hitbox_position(c, 1))
            local q, r = client.trace_bullet(b, h.x, h.y, h.z, p.x, p.y, p.z)
            if r <= 0 then
                local s = self:scan_side(b, d, h, m, n, 'left')
                local t = self:scan_side(b, d, h, l, o, 'right')
                return (s or t) and self.check_overlap(s, t) or nil
            else
                return nil
            end
        end,

        callback = function(self, cmd)
            local local_player = entity.get_local_player()

            if client.current_threat() then
                local from = vector(client.eye_position())
                local to = vector(entity.get_origin(client.current_threat()))
        
                _, self.is_vulnerable = client.trace_bullet(local_player, from.x, from.y, from.z, to.x, to.y, to.z)
                self.is_vulnerable = self.is_vulnerable > 0
            else
                self.is_vulnerable = false
            end

            local target_result = self:get_scan_result(client.current_threat())
            if target_result then
                self.scan_result = target_result
                self.last_result = target_result
            elseif not self.is_vulnerable then
                self.scan_result = {is_active = false, side = 'unsure', vector = vector(0, 0, 0), index = 0, length = self.scan_length}
            end

            if not entity.is_alive(local_player) then
                self.last_result = self.scan_clear
            end
            
            self.last_scanned = globals.curtime()

            _G.radiant_scan_result = self.last_result
        end,
    }
    scan:init()
    callbacks:create('angle_scan', 'run_command', function(cmd) scan:callback(cmd) end)

    local shot_detection = {
        -- key : index, value : # of shots
        player_shot_list = {},
        swap_time = 0,

        vector3_angles = function(start, dest)
            -- https://github.com/ValveSoftware/source-sdk-2013/blob/master/sp/src/mathlib/mathlib_base.cpp#L535-L563
            -- modifed for ease of use with vector lib - bassn
            local origin, target
            if dest == nil then
                target, origin = start, vector(client.eye_position())
                if origin.x == nil then
                    return
                end
            else
                origin, target = start, dest
            end
        
            local delta = target - origin
            if delta.x == 0 and delta.y == 0 then
                return 0, (delta.z > 0 and 270 or 90)
            else
                local yaw = math.deg(math.atan2(delta.y, delta.x))
                local hyp = math.sqrt(delta.x * delta.x + delta.y * delta.y)
                local pitch = math.deg(math.atan2(-delta.z, hyp))
        
                return pitch, yaw
            end
        end,

        angle_right = function(angle) -- thx vector3 lib
            local sin_pitch = math.sin( math.rad( angle.x ) );
            local cos_pitch = math.cos( math.rad( angle.x ) );
            local sin_yaw   = math.sin( math.rad( angle.y ) );
            local cos_yaw   = math.cos( math.rad( angle.y ) );
            local sin_roll  = math.sin( math.rad( angle.z ) );
            local cos_roll  = math.cos( math.rad( angle.z ) );

            return vector(
                -1.0 * sin_roll * sin_pitch * cos_yaw + -1.0 * cos_roll * -sin_yaw,
                -1.0 * sin_roll * sin_pitch * sin_yaw + -1.0 * cos_roll * cos_yaw,
                -1.0 * sin_roll * cos_pitch
            );
        end,

        dist_3d = function (p1, p2)
            return ((p1.x - p2.x) ^ 2) + ((p1.y - p2.y) ^ 2) + ((p1.z - p2.z) ^ 2)
        end,

        shot_as_3d_segment_distance = function(self, shooter, impact, player)
            local len = self.dist_3d(shooter, impact)
            if (len == 0) then
                return self.dist_3d(player, shooter)
            end

            local total = (
                (player.x - shooter.x) * (impact.x - shooter.x) + 
                (player.y - shooter.y) * (impact.y - shooter.y) + 
                (player.z - shooter.z) * (impact.z - shooter.z) 
            )

            total = math.max(0, math.min(1, total / len))

            local dist_squared = self.dist_3d(player, { 
                x = shooter.x + total * (impact.x - shooter.x),
                y = shooter.y + total * (impact.y - shooter.y),
                z = shooter.z + total * (impact.z - shooter.z),
            })

            return math.sqrt(dist_squared)
        end,

        callback_impact = function(self, data)
            if not funcs.contains(ui.get(m.menu.options.multi2), 'Shot detection') then
                return
            end
            
            if globals.curtime() > self.swap_time + 0.1 and entity.is_alive(entity.get_local_player()) then
                local shooter = client.userid_to_entindex(data.userid)  
                if entity.is_enemy(shooter) and not entity.is_dormant(shooter) then
                    local shooter_pos = vector(entity.hitbox_position(shooter, 0))
                    local impact_pos = vector(data.x, data.y, data.z)
                    local local_pos = vector(client.eye_position())

                    local shot_dist = self:shot_as_3d_segment_distance(shooter_pos, impact_pos, local_pos) 

                    if shot_dist < 45 then
                        local at_pitch, at_yaw = self.vector3_angles(local_pos, shooter_pos)
                        local camera_angle = vector(at_pitch, at_yaw, 0)

                        local dir_side = self.angle_right(camera_angle)
                        local p_right = (dir_side * 10) + local_pos
                        local p_left = (dir_side * -10) + local_pos

                        local r_dist = self:shot_as_3d_segment_distance(shooter_pos, impact_pos, p_right) 
                        local l_dist = self:shot_as_3d_segment_distance(shooter_pos, impact_pos, p_left) 

                        -- -60l to 60r
                        local shot_angle = funcs.clamp((l_dist < r_dist and -shot_dist or shot_dist) * 3, -60, 60)

                        self.player_shot_list[shooter] = self.player_shot_list[shooter] or {}
                        self.player_shot_list[shooter][1] = (self.player_shot_list[shooter][1] or 0) + 1
                        self.player_shot_list[shooter][2] = shot_angle

                        local detect_color = _G.radiant_detect_color
                        local log_options = _G.radiant_log_options

                        if funcs.contains(_G.radiant_log_options, "Console") then
                            client.color_log(detect_color[1], detect_color[2], detect_color[3], ('[ Radiant ] Shot dectection triggered by %s, adjusting anti-aim settings.'):format(entity.get_player_name(shooter)))
                        end
                        if funcs.contains(_G.radiant_log_options, "On screen") then
                            table.insert(_G.radiant_screen_logs, {
                                text = {
                                    {detect_color, ' Shot detection'},
                                    {{255, 255, 255, 255}, ' triggered by'},
                                    {detect_color, (' %s'):format(entity.get_player_name(shooter))},
                                    {{255, 255, 255, 255}, ', adjusting anti-aim.'}
                                },
                                time = globals.curtime(),
                                alpha = 1,
                                type = "detect",
                            })
                        end
                        _G.log_offset = _G.log_offset + 0.3
                        self.swap_time = globals.curtime()
                    end
                end
            end
        end,

        fix_callback = function(self, ent)
            if ent then
                if ent.userid and client.userid_to_entindex(ent.userid) == entity.get_local_player() then
                    shot_detection.player_shot_list = {}
                end
            else
                shot_detection.player_shot_list = {}
            end
        end,
    }
    callbacks:create('shot_detection1', 'bullet_impact', function(data) shot_detection:callback_impact(data) end)
    callbacks:create('shot_fix', {'player_death', 'round_start', 'client_disconnect', 'game_newmap', 'cs_game_disconnected'}, function(data) shot_detection:fix_callback(data) end) -- fixing callbacks ep3

    local aa = {
        last_manual_hk = 'back',
        left_hk_last,
        right_hk_last,
        current_state_reference,

        init = function(self)
            left_hk_last  = ui.get(m.menu.options.manual_l_hk)
            right_hk_last = ui.get(m.menu.options.manual_r_hk)  
            current_state_reference = {}
        end,

        set_use_aa = function(a)local b=entity.get_local_player()local c=vector(entity.get_prop(b,'m_vecOrigin'))local d=entity.get_all('CPlantedC4')[1]local e=vector(entity.get_prop(d,'m_vecOrigin'))local f=0;if e then f=c:dist(e)end;local g=entity.get_all('CHostage')[1]local h=vector(entity.get_prop(g,'m_vecOrigin'))local i=0;if h then i=c:dist(h)end;local j=entity.get_all('CPropDoorRotating')[1]local k=vector(entity.get_prop(j,'m_vecOrigin'))local l=0;if k then l=c:dist(k)end;local m=entity.get_prop(b,'m_iTeamNum')local n=entity.get_prop(b,'m_bInBombZone')local o=d~=nil and entity.get_prop(d,'m_hOwnerEntity')==b;local p=n~=0 and m==2 and o;local q=m==3 and f<62;local r=m==3 and i<62;local s=l<92;if p or q or r or s then return end;a.in_use=1;if a.chokedcommands==0 then a.in_use=0 end end,
        
        left_hk_callback = function(self)
            if self.last_manual_hk == 'right' or self.last_manual_hk == 'back' then
                self.last_manual_hk = 'left'
            elseif self.last_manual_hk == 'left' then
                self.last_manual_hk = 'back'
            end
        end,
        
        right_hk_callback = function(self)
            if self.last_manual_hk == 'left' or self.last_manual_hk == 'back' then
                self.last_manual_hk = 'right'
            elseif self.last_manual_hk == 'right' then
                self.last_manual_hk = 'back'
            end
        end,

        return_logic = function(logic, value, min, max) -- COOL MATH WOW
            local to_return = value
            local time = globals.curtime()
            local perc = math.sin(time * 3)
            local range = value * 0.4
            if logic == 'Static' then
                return to_return
            elseif logic == 'Step' then
                local str = tostring(math.floor(time * 20))
                to_return = value - ((tonumber(str:sub(#str,#str))) * (range * 0.14))
            elseif logic == 'Jitter' then
                to_return = value + (math.floor(time * 50) % 2 == 0 and -range*1.5  or 0)
            elseif logic == 'Random' then
                to_return = client.random_int(value - range, value + range)
            elseif logic == 'Sway' then
                to_return = (value - range) - (perc * range)
            end
            return funcs.clamp(to_return, min, max)
        end,

        set_preset = function(preset)
            ui.set(m.ref.aa.pitch, preset[1])
            ui.set(m.ref.aa.yaw_base, preset[2])
        
            ui.set(m.ref.aa.yaw[1], preset[3])
            ui.set(m.ref.aa.yaw[2], preset[4])
        
            ui.set(m.ref.aa.yaw_jitter[1], preset[5])
            ui.set(m.ref.aa.yaw_jitter[2], preset[6])
        
            ui.set(m.ref.aa.body_yaw[1], preset[7])
            ui.set(m.ref.aa.body_yaw[2], preset[8])
        
            ui.set(m.ref.aa.fake_yaw, preset[9])
            ui.set(m.ref.aa.freestand, preset[10])
        
            ui.set(m.ref.aa.roll, preset[11])
        end,

        set_state = function(self, cstate)
            self.current_state_reference = cstate
        
            ui.set(m.ref.aa.pitch, 'Default')
            ui.set(m.ref.aa.yaw_base, 'At targets')
            ui.set(m.ref.aa.yaw[1], '180')
            ui.set(m.ref.aa.yaw[2], ui.get(cstate.yaw[1]))
            ui.set(m.ref.aa.yaw_jitter[1], ui.get(cstate.yaw_jitter[1]))
            ui.set(m.ref.aa.yaw_jitter[2], ui.get(cstate.yaw_jitter[2]))
        
            local body_mode = ui.get(cstate.body_yaw[1])
            if body_mode == 'Freestand' or body_mode == 'Reverse' then
                local rev = body_mode == 'Reverse'
                if scan.scan_result.side == 'unsure' then
                    ui.set(m.ref.aa.freestand, rev and false or true)
                    ui.set(m.ref.aa.body_yaw[1], 'Static')
                    ui.set(m.ref.aa.body_yaw[2], (rev and -1 or 1) * (scan.last_result.side == 'left' and -180 or 180))
                else
                    ui.set(m.ref.aa.freestand, false)
                    ui.set(m.ref.aa.body_yaw[1], 'Static')
                    ui.set(m.ref.aa.body_yaw[2], (rev and -1 or 1) * (scan.scan_result.side == 'left' and -180 or 180))
                end
            else
                ui.set(m.ref.aa.freestand, false)
                ui.set(m.ref.aa.body_yaw[1], body_mode)
                ui.set(m.ref.aa.body_yaw[2], ui.get(cstate.body_yaw[2]))
            end
        
            ui.set(m.ref.aa.fake_yaw, self.return_logic(ui.get(cstate.fake_yaw[1]), ui.get(cstate.fake_yaw[2]), 0, 60))
        
            local to_roll = 0
            if ui.get(cstate.roll[1]) ~= 'Off' then
                to_roll = ui.get(cstate.roll[1]) == 'Static' and 
                self.return_logic(ui.get(cstate.roll[2]), ui.get(cstate.roll[3]), -50, 50) or
                self.return_logic(ui.get(cstate.roll[2]), ui.get(cstate.roll[4]), 0, 50)
            end
        
            if ui.get(cstate.roll[1]) == 'Freestand' then
                if scan.last_result.side ~= 'unsure' then
                    to_roll = to_roll * (scan.last_result.side == 'left' and -1 or 1)
                else
                    to_roll = 0
                end
            elseif ui.get(cstate.roll[1]) == 'Reversed' then
                if scan.last_result.side ~= 'unsure' then
                    to_roll = to_roll * (scan.last_result.side == 'left' and 1 or -1)
                else
                    to_roll = 0
                end
            end
            ui.set(m.ref.aa.roll, to_roll)
        end,
    }
    aa:init()

    local paint_ui = {
        callback = function(self)
            -- main
            local enabled = ui.get(m.menu.enabled)
            funcs.table_visible(m.ref.aa, not enabled)
            --funcs.table_visible(m.ref.aa, true)
        
            if not ui.is_menu_open() then return end

            ui.set_visible(configs.import_bttn, enabled)
            ui.set_visible(configs.export_bttn, enabled)
        
            local mode = ui.get(m.menu.mode)
            ui.set_visible(m.menu.mode, enabled)
        
            -- Mode :  Automatic 
            local automatic_active = enabled and mode == m.modes[1]
            funcs.table_visible(m.menu.automatic, automatic_active)
            
            -- Mode :  Movement 
            local movement_active = enabled and mode == m.modes[2]
            ui.set_visible(m.menu.movement.state_combo, movement_active)
        
            local active_element = ui.get(m.menu.movement.state_combo)
            for k, v in pairs(m.menu.movement.states) do
                local active = active_element == v.name and movement_active and enabled
                if k ~= 1 then
                    ui.set_visible(v.enabled, active)
                end
        
                active = active and (k ~= 1 and ui.get(v.enabled) or active_element == 'General')
        
                funcs.table_visible(v.items, active)
                m:items_visible(v.items, active)
            end
        
            -- Mode : Advanced
            local advanced_active = enabled and mode == m.modes[3]
            ui.set_visible(m.menu.advanced.state_combo, advanced_active)
        
            local active_element = ui.get(m.menu.advanced.state_combo)
            for k, v in pairs(m.menu.advanced.states) do -- left, right states
                local active = active_element == v.name and advanced_active and enabled
                if k ~= 1 then
                    ui.set_visible(v.enabled, active)
                end
        
                active = active and (k ~= 1 and ui.get(v.enabled) or active_element == 'General')
                ui.set_visible(v.side, active) 
        
                local m_side = ui.get(v.side)
                funcs.table_visible(v.items.left, active and m_side == 'Left')
                m:items_visible(v.items.left, active and m_side == 'Left')
        
                funcs.table_visible(v.items.right, active and m_side == 'Right')
                m:items_visible(v.items.right, active and m_side == 'Right')
            end
            
            -- Global options
            ui.set_visible(m.menu.options.multi1, enabled)
            ui.set_visible(m.menu.options.multi2, enabled)

            local auto_mode = ui.get(m.menu.mode) == 'Automatic'
            
            local multi2_active = ui.get(m.menu.options.multi2)
            ui.set_visible(m.menu.options.brute_combo,   enabled and funcs.contains(multi2_active, 'Shot detection'))
            
            local custom_mode = ui.get(m.menu.options.brute_combo) == 'Custom angle' and enabled and funcs.contains(multi2_active, 'Shot detection')
            ui.set_visible(m.menu.options.custom_body2,  custom_mode and (ui.get(m.menu.options.custom_body1) == 'Static' or ui.get(m.menu.options.custom_body1) == 'Jitter'))
            funcs.table_visible({m.menu.options.custom_body1, m.menu.options.custom_body3}, custom_mode) 

            local multi1_active = ui.get(m.menu.options.multi1)
            ui.set_visible(m.menu.options.freestand_hk,  enabled and funcs.contains(multi1_active, 'Freestand yaw'))
            ui.set_visible(m.menu.options.legit_aa_hk,   enabled and funcs.contains(multi1_active, 'Legit anti-aim'))
            ui.set_visible(m.menu.options.edge_yaw_hk,   enabled and funcs.contains(multi1_active, 'Edge yaw'))
            ui.set_visible(m.menu.options.defensive_hk, enabled and funcs.contains(multi1_active, 'Force defensive'))
            ui.set_visible(m.menu.options.force_roll_hk, enabled and funcs.contains(multi1_active, 'Force roll'))
            ui.set_visible(m.menu.options.manual_l_hk,   enabled and funcs.contains(multi1_active, 'Manual yaw'))
            ui.set_visible(m.menu.options.manual_r_hk,   enabled and funcs.contains(multi1_active, 'Manual yaw'))
        end,
    }
    paint_ui:callback()
    callbacks:create('paint_ui', 'paint_ui', function() paint_ui:callback() end)

    -- setup
    local setup_command = {
        callback = function(cmd)
            if not cmd then return end

            ui.set(m.ref.aa.enabled, ui.get(m.menu.enabled))

            local mode = ui.get(m.menu.mode)
            local local_player = entity.get_local_player()
            local is_alive = entity.is_alive(local_player)

            if not local_player or not is_alive then return end

            local velocity = {entity.get_prop(local_player, 'm_vecVelocity')}
            local is_moving = math.abs(velocity[1]) > 5 or math.abs(velocity[2]) > 5 or math.abs(velocity[3]) > 5

            local double_tap = ui.get(m.ref.double_tap[1]) and ui.get(m.ref.double_tap[2])
            local on_shot_aa = ui.get(m.ref.on_shot_aa[1]) and ui.get(m.ref.on_shot_aa[2])
            
            -- in_air, is_ducking, in_slowwalk, vulnerable, is_moving, is_standing, general
            -- {state index, bool}
            local set_tbl = {
                {7, not (bit.band(entity.get_prop(local_player, 'm_fFlags'), 1) == 1)},
                {3, entity.get_prop(local_player, 'm_flDuckAmount') > 0.5},
                {5, ui.get(m.ref.slow_walk[2])},
                {2, scan.is_vulnerable},
                {6, is_moving},
                {4, not is_moving },
                {1, true}, -- general
            }

            -- main options
            _G.radiant_master = {
                side = scan.last_result.side
            }

            local side = _G.radiant_master.side

            if mode == 'Automatic' then
                if set_tbl[1][2] then     -- air
                    aa.set_preset({'Default', 'At targets', '180', side == 'left' and -9 or 12, 'Center', 40, 'Jitter', 0, 60, false, 0})
                elseif set_tbl[3][2] then -- slow walk
                    aa.set_preset({'Default', 'At targets', '180', 8, 'Random', 8, 'Jitter', 89, 60, false, 0})
                elseif set_tbl[5][2] then -- standing
                    aa.set_preset({'Default', 'At targets', '180', 8, 'Center', 0, 'Static', side == 'left' and 180 or -180, 60, false, 0})
                else -- moving
                    aa.set_preset({'Default', 'At targets', '180', -23, 'Center', 63, 'Jitter', 0, 60, false, 0})
                end
            else
                local cside = scan.last_result.side -- 'left' or 'right'
                for i, v in ipairs(set_tbl) do
                    if v[2] and (i ~= #set_tbl and ui.get(m.menu[string.lower(mode)].states[v[1]].enabled) or i == #set_tbl) then
                        local set_to = m.menu[string.lower(mode)].states[v[1]].items
                        aa:set_state(mode == 'Advanced' and set_to[cside] or set_to)
                        break
                    end
                end
            end 

            --anti brute apply
            if funcs.contains(ui.get(m.menu.options.multi2), 'Shot detection') then
                if client.current_threat() then
                    if shot_detection.player_shot_list[client.current_threat()] then
                        local misses = shot_detection.player_shot_list[client.current_threat()][1]
                        local angle = shot_detection.player_shot_list[client.current_threat()][2]
                        local brute_mode = ui.get(m.menu.options.brute_combo)
                        if misses > 0 then
                            if brute_mode ~= 'Automatic stages' then
                                if misses % 2 ~= 0 then
                                    if brute_mode == 'Inverse angle' then
                                        ui.set(m.ref.aa.body_yaw[2], -ui.get(m.ref.aa.body_yaw[2]))
                                    elseif brute_mode == 'Custom angle' then
                                        ui.set(m.ref.aa.body_yaw[1], ui.get(m.menu.options.custom_body1))
                                        ui.set(m.ref.aa.body_yaw[2], ui.get(m.menu.options.custom_body2))
                                        ui.set(m.ref.aa.fake_yaw, ui.get(m.menu.options.custom_body3))
                                    end
                                end

                                if brute_mode == 'Detect missed angle' then
                                    if angle == 0 then
                                        ui.set(m.ref.aa.body_yaw[1], 'Jitter')
                                        ui.set(m.ref.aa.body_yaw[2], 0)
                                    else
                                        ui.set(m.ref.aa.body_yaw[1], 'Static')
                                        ui.set(m.ref.aa.body_yaw[2], funcs.clamp(angle * 1.1, -150, 150))
                                    end
                                end
                            else
                                if misses == 1 then
                                    ui.set(m.ref.aa.body_yaw[1], 'Static')
                                    ui.set(m.ref.aa.body_yaw[2], funcs.clamp(angle * 1.1, -150, 150))
                                elseif misses == 2 then
                                    ui.set(m.ref.aa.body_yaw[1], 'Jitter')
                                    ui.set(m.ref.aa.body_yaw[2], 0)
                                    ui.set(m.ref.aa.fake_yaw, client.random_int(47, 58))
                                else -- reset
                                    shot_detection.player_shot_list[client.current_threat()][2] = 0
                                end
                            end
                        end
                    end
                end
            end

            --over-riding global options
            local extensions = ui.get(m.menu.options.multi1)
            local options = ui.get(m.menu.options.multi2)

            _G.radiant_hotkeys = {}

            if funcs.contains(options, 'Override pitch & yaw') then
                ui.set(m.ref.aa.yaw[1], 'Off')
                ui.set(m.ref.aa.yaw[2], 0)
                ui.set(m.ref.aa.pitch, 'Off')
            end

            if funcs.contains(extensions, 'Freestand yaw') and ui.get(m.menu.options.freestand_hk) then
                ui.set(m.ref.aa.freestanding[1], {'Default'})
                ui.set(m.ref.aa.freestanding[2], 'Always on')

                table.insert(_G.radiant_hotkeys, {
                    reference = {ui.reference(tab, container, string.format('%s %s', m:as_tag('Hotkey'), 'Freestand yaw') )},
                    use_name = 'Freestand yaw'
                })
            else
                ui.set(m.ref.aa.freestanding[1], {})
                ui.set(m.ref.aa.freestanding[2], 'On Hotkey')
            end

            if funcs.contains(extensions, 'Edge yaw') and ui.get(m.menu.options.edge_yaw_hk) then
                ui.set(m.ref.aa.edge_yaw, ui.get(m.menu.options.edge_yaw_hk))

                table.insert(_G.radiant_hotkeys, {
                    reference = {ui.reference(tab, container, string.format('%s %s', m:as_tag('Hotkey'), 'Edge yaw') )},
                    use_name = 'Edge yaw'
                })
            else
                ui.set(m.ref.aa.edge_yaw, false)
            end

            if funcs.contains(extensions, 'Legit anti-aim') and ui.get(m.menu.options.legit_aa_hk) then
                aa.set_use_aa(cmd)
                
                table.insert(_G.radiant_hotkeys, {
                    reference = {ui.reference(tab, container, string.format('%s %s', m:as_tag('Hotkey'), 'Legit anti-aim') )},
                    use_name = 'Legit anti-aim'
                })
            end
            
            if funcs.contains(options, 'Anti backstab') then
                local enemies = entity.get_players(true)
                for i = 1, #enemies do
                    if funcs.is_stabable(local_player, enemies[i]) then
                        aa.set_use_aa(cmd)
                    end
                end
            end

            if funcs.contains(extensions, 'Force defensive') and ui.get(m.menu.options.defensive_hk) then
                cmd.force_defensive = true

                table.insert(_G.radiant_hotkeys, {
                    reference = {ui.reference(tab, container, string.format('%s %s', m:as_tag('Hotkey'), 'Force defensive') )},
                    use_name = 'Force defensive'
                })
            end

            if funcs.contains(extensions, 'Force roll') and ui.get(m.menu.options.force_roll_hk) then 
                cmd.roll = scan.last_result.side == 'left' and -55 or 55

                table.insert(_G.radiant_hotkeys, {
                    reference = {ui.reference(tab, container, string.format('%s %s', m:as_tag('Hotkey'), 'Force roll') )},
                    use_name = 'Force roll'
                })
            end

            if funcs.contains(options, 'Ladder fix') then 
                ui.set(m.ref.dt_fl_limit, entity.get_prop(local_player, 'm_MoveType') == 9 and 7 or 1)
            end

            if funcs.contains(options, 'Low FPS mitigations') then  
                scan.scan_width = 20
                scan.scan_length = 40
            else
                scan.scan_width = 20
                scan.scan_length = 60
            end

            if funcs.contains(extensions, 'Manual yaw') then
                local l_hk = ui.get(m.menu.options.manual_l_hk)
                if aa.left_hk_last ~= l_hk then
                    aa.left_hk_callback(aa)
                    aa.left_hk_last = l_hk
                end
                
                local r_hk = ui.get(m.menu.options.manual_r_hk)
                if aa.right_hk_last ~= r_hk then
                    aa.right_hk_callback(aa)
                    aa.right_hk_last = r_hk
                end

                local poop = {ui.get(m.menu.options.manual_l_hk)}

                local yaw_add = ui.get(m.ref.aa.yaw[2])

                if aa.last_manual_hk == 'left' then
                    ui.set(m.ref.aa.yaw[2], funcs.clamp(-89 + yaw_add, -180, 180))
                    ui.set(m.menu.options.manual_l_hk_ref, 'Always on')
                    ui.set(m.menu.options.manual_r_hk_ref, 'On hotkey')
                elseif aa.last_manual_hk == 'right' then
                    ui.set(m.ref.aa.yaw[2], funcs.clamp(89 + yaw_add, -180, 180))
                    ui.set(m.menu.options.manual_r_hk_ref, 'Always on')
                    ui.set(m.menu.options.manual_l_hk_ref, 'On hotkey')
                else
                    ui.set(m.ref.aa.yaw[2], funcs.clamp(yaw_add, -180, 180))
                    ui.set(m.menu.options.manual_l_hk_ref, 'On hotkey')
                    ui.set(m.menu.options.manual_r_hk_ref, 'On hotkey')
                end

                table.insert(_G.radiant_hotkeys, {
                    reference = {ui.reference(tab, container, string.format('%s %s', m:as_tag('Hotkey'), 'Left yaw') )},
                    use_name = 'Manual left'
                })

                table.insert(_G.radiant_hotkeys, {
                    reference = {ui.reference(tab, container, string.format('%s %s', m:as_tag('Hotkey'), 'Right yaw') )},
                    use_name = 'Manual right'
                })
            end
        end,
    }
    callbacks:create('apply_aa', 'setup_command', function(cmd) setup_command.callback(cmd) end)

    -- fixed ur table callbacks, put in shot detection
    --------------------Final------------------------

    local shutdown_routine = function()
        paint_ui:callback()
        callbacks:handle_list(false)
        funcs.table_visible(m.ref.aa, true)
        aa.set_preset({'Off', 'Local view', 'Off', 0, 'Off', 0, 'Off', 0, 59, false, 0})
        ui.set(m.ref.maxusrcmd, 16)
        ui.set(m.ref.fl_limit, 15)   
    end

    ui.set_callback(m.menu.enabled, function()
        callbacks:handle_list(ui.get(m.menu.enabled))
        if not ui.get(m.menu.enabled) then
            shutdown_routine()
        end
    end)

    client.set_event_callback('shutdown', shutdown_routine)
    -------------------------------------------------
end

local function visuals()

local MyPersonaAPI = panorama.open().MyPersonaAPI

-- globaL vars that are cringe
_G.log_offset = 0.1
_G.radiant_screen_logs = {}

local native_CreateDirectory = vtable_bind('filesystem_stdio.dll', 'VFileSystem017', 22, 'void(__thiscall*)(void*, const char*, const char*)')
local writedir = function(path, pathID)
    native_CreateDirectory(({path:gsub('/', '\\')})[1], pathID)
end

local has_image = readfile('materials/panorama/images/icons/xp/level1814911420.png')
function image_recursive()
    if not has_image then
        http.get('https://i.imgur.com/itrF5qx.png', function(success, response)
            if not success or response.status ~= 200 then
                client.delay_call(3, image_recursive)
            else
                writedir('/materials/panorama/images/icons/xp', 'GAME')
                writefile('materials/panorama/images/icons/xp/level1814911420.png', response.body)
            end
        end)
    end
end
image_recursive() -- recurssive walahai !

local connected_ids_tbl, websocket_connection
local connected_amount = 0
local callbacks = {
    open = function(ws)
        client.delay_call(0.1, function()
            ws:send(entity.get_steam64(entity.get_local_player()))
        end)

        websocket_connection = ws
    end,
    message = function(ws, data)
        if data:find('^%[') then
            connected_ids_tbl = loadstring("return " .. (data:gsub("^%[", "{"):gsub("%]$", "}")):sub(1, -1))()
        end
    end,
    close = function(ws, code, reason, was_clean)
        websocket_connection = nil
    end,
    error = function(ws, err)
        websocket_connection = nil
    end,
}

function ws_recursive() -- recursive websocket to handle dropped connections
    if not websocket_connection then
        websockets.connect('ws://radiant.rip/api', callbacks)
    end

    client.delay_call(3, ws_recursive)
end
ws_recursive()

local callbacks = {
    open = function(ws)
        client.delay_call(0.1, function()
            ws:send(entity.get_steam64(entity.get_local_player()))
        end)

        websocket_connection = ws
    end,
    message = function(ws, data)
        if data:find('^%[') then
            connected_ids_tbl = loadstring("return " .. (data:gsub("^%[", "{"):gsub("%]$", "}")):sub(1, -1))()
        end
    end,
    close = function(ws, code, reason, was_clean)
        websocket_connection = nil
    end,
    error = function(ws, err)
        websocket_connection = nil
    end,
}

websockets.connect('ws://radiant.rip/api', callbacks)

local callbacks = {
    list = {},

    create = function(self, name, event, func)
        if type(event) ~= 'table' then
            self.list[name] = {event = event, func = func}
        else
            for k, v in pairs(event) do
                self.list[name] = {event = v, func = func}
            end
        end
    end,

    handle_list = function(self, enabled)
        local set_callback = enabled and client.set_event_callback or client.unset_event_callback
        for k, v in pairs(self.list) do
            set_callback(self.list[k].event, self.list[k].func)
        end
    end,
}

local imgs = {
    radiant_images = {},

    svg_raw = {
        ping_icon_svg  = "<svg width='8' height='4' viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg'><path fill-rule='evenodd' clip-rule='evenodd' d='M5.25 2C5.25 2.33148 5.1183 2.64937 4.88388 2.88375C4.64947 3.11814 4.33152 3.24981 4 3.24981C3.66848 3.24981 3.35054 3.11814 3.11612 2.88375C2.8817 2.64937 2.75 2.33148 2.75 2C2.75 1.66853 2.8817 1.35064 3.11612 1.11625C3.35054 0.881868 3.66848 0.750188 4 0.750188C4.33152 0.750188 4.64947 0.881868 4.88388 1.11625C5.1183 1.35064 5.25 1.66853 5.25 2ZM5.965 2.37494C5.8777 2.83208 5.6337 3.24446 5.27505 3.54112C4.91636 3.83772 4.46547 4 4 4C3.53453 4 3.08364 3.83772 2.72497 3.54112C2.3663 3.24446 2.1223 2.83208 2.035 2.37494H0.375C0.275544 2.37494 0.180161 2.33544 0.109835 2.26513C0.0395088 2.19481 0 2.09945 0 2C0 1.90056 0.0395088 1.80519 0.109835 1.73487C0.180161 1.66456 0.275544 1.62506 0.375 1.62506H2.035C2.1223 1.16792 2.3663 0.755532 2.72497 0.458911C3.08364 0.162291 3.53453 0 4 0C4.46547 0 4.91636 0.162291 5.27505 0.458911C5.6337 0.755532 5.8777 1.16792 5.965 1.62506H7.625C7.72445 1.62506 7.81985 1.66456 7.89015 1.73487C7.9605 1.80519 8 1.90056 8 2C8 2.09945 7.9605 2.19481 7.89015 2.26513C7.81985 2.33544 7.72445 2.37494 7.625 2.37494H5.965Z' fill='white'/></svg>",
        user_icon_svg  = "<svg width='6' height='6' viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg'><path fill-rule='evenodd' clip-rule='evenodd' d='M4.25086 1.84357C4.25086 2.14922 4.11903 2.44234 3.88438 2.65847C3.64972 2.8746 3.33146 2.99602 2.99961 2.99602C2.66776 2.99602 2.3495 2.8746 2.11485 2.65847C1.88019 2.44234 1.74836 2.14922 1.74836 1.84357C1.74836 1.53792 1.88019 1.24479 2.11485 1.02867C2.3495 0.81254 2.66776 0.691123 2.99961 0.691123C3.33146 0.691123 3.64972 0.81254 3.88438 1.02867C4.11903 1.24479 4.25086 1.53792 4.25086 1.84357ZM4.28139 3.26016C4.59735 3.01752 4.82448 2.69112 4.93194 2.32536C5.03935 1.95959 5.02178 1.57224 4.88169 1.21598C4.7416 0.85973 4.48574 0.551875 4.14896 0.334297C3.81215 0.116724 3.41074 0 2.99936 0C2.58797 0 2.18657 0.116724 1.84977 0.334297C1.51297 0.551875 1.25711 0.85973 1.11702 1.21598C0.976929 1.57224 0.959392 1.95959 1.0668 2.32536C1.17422 2.69112 1.40136 3.01752 1.71733 3.26016C1.22463 3.4747 0.804552 3.80861 0.502065 4.22614C0.199578 4.64369 0.0260695 5.12911 0.000113614 5.63051C-0.0022988 5.72086 0.0337873 5.8085 0.100654 5.8746C0.167516 5.94075 0.259838 5.98016 0.357856 5.98436C0.455869 5.9886 0.55178 5.9573 0.625048 5.89719C0.698316 5.83708 0.743121 5.75295 0.749862 5.66278C0.77715 5.13012 1.02609 4.62761 1.44501 4.25956C1.86393 3.89148 2.42065 3.68613 2.99961 3.68613C3.57857 3.68613 4.13529 3.89148 4.55421 4.25956C4.97313 4.62761 5.22208 5.13012 5.24936 5.66278C5.25061 5.70883 5.26177 5.75415 5.28229 5.79614C5.30281 5.83814 5.33224 5.87594 5.36883 5.90728C5.40541 5.93868 5.44845 5.96302 5.49535 5.97887C5.5423 5.99473 5.5922 6.00178 5.64215 5.99962C5.6921 5.9975 5.74105 5.98616 5.78619 5.96633C5.83129 5.94651 5.87168 5.91862 5.90491 5.88423C5.93819 5.84985 5.96362 5.80969 5.97979 5.76613C5.996 5.72257 6.00256 5.67643 5.9991 5.63051C5.97308 5.12906 5.79951 4.6436 5.49695 4.22605C5.19435 3.80852 4.77418 3.47463 4.28139 3.26016Z' fill='white'/></svg>",
        tick_icon_svg  = "<svg width='6' height='3' viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M0.75 3C0.335786 3 0 2.66421 0 2.25C0 1.83579 0.335786 1.5 0.75 1.5C1.16421 1.5 1.5 1.83579 1.5 2.25C1.5 2.44891 1.42098 2.63968 1.28033 2.78033C1.13968 2.92098 0.948912 3 0.75 3ZM3 2.25C2.58579 2.25 2.25 1.91421 2.25 1.5C2.25 1.08579 2.58579 0.75 3 0.75C3.41421 0.75 3.75 1.08579 3.75 1.5C3.75 1.69891 3.67098 1.88968 3.53033 2.03033C3.38968 2.17098 3.19891 2.25 3 2.25ZM5.25 1.5C4.83579 1.5 4.5 1.16421 4.5 0.75C4.5 0.335786 4.83579 0 5.25 0C5.66421 0 6 0.335786 6 0.75C6 0.948912 5.92098 1.13968 5.78033 1.28033C5.63968 1.42098 5.44891 1.5 5.25 1.5Z' fill='white'/></svg>",
        clock_icon_svg = "<svg width='6' height='6' viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg'><path fill-rule='evenodd' clip-rule='evenodd' d='M0.5625 3C0.5625 2.35353 0.819308 1.73355 1.27643 1.27643C1.73355 0.819308 2.35353 0.5625 3 0.5625C3.64647 0.5625 4.26645 0.819308 4.72358 1.27643C5.1807 1.73355 5.4375 2.35353 5.4375 3C5.4375 3.64647 5.1807 4.26645 4.72358 4.72358C4.26645 5.1807 3.64647 5.4375 3 5.4375C2.35353 5.4375 1.73355 5.1807 1.27643 4.72358C0.819308 4.26645 0.5625 3.64647 0.5625 3ZM3 0C2.20435 0 1.44129 0.316071 0.878681 0.878681C0.316071 1.44129 0 2.20435 0 3C0 3.79564 0.316071 4.55873 0.878681 5.12134C1.44129 5.68391 2.20435 6 3 6C3.79564 6 4.55873 5.68391 5.12134 5.12134C5.68391 4.55873 6 3.79564 6 3C6 2.20435 5.68391 1.44129 5.12134 0.878681C4.55873 0.316071 3.79564 0 3 0ZM3.1875 1.78125C3.1875 1.70666 3.15787 1.63512 3.10512 1.58238C3.05238 1.52963 2.98084 1.5 2.90625 1.5C2.83166 1.5 2.76012 1.52963 2.70738 1.58238C2.65463 1.63512 2.625 1.70666 2.625 1.78125V3.09375C2.62501 3.14992 2.64184 3.20479 2.67332 3.25131C2.7048 3.29783 2.74949 3.33386 2.80163 3.35475L3.73912 3.72975C3.80779 3.75484 3.88354 3.75217 3.95029 3.72237C4.01704 3.69256 4.06957 3.63793 4.09672 3.57005C4.12387 3.50218 4.12354 3.42639 4.09579 3.35876C4.06804 3.29113 4.01501 3.23697 3.948 3.20775L3.1875 2.90325V1.78125Z' fill='white'/></svg>",
        binds_icon_svg = "<svg width='6' height='6' viewBox='0 0 6 6' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M1.75893 5.99999C1.04757 5.99999 0.406256 5.57149 0.133986 4.9143C-0.138284 4.25711 0.0121048 3.50062 0.515034 2.99753L1.26151 2.25105L1.75893 2.74847L1.0128 3.4946C0.746175 3.76123 0.642045 4.14985 0.739638 4.51407C0.83723 4.87829 1.12172 5.16278 1.48594 5.26038C1.85016 5.35797 2.23878 5.25384 2.50541 4.98721L3.25153 4.24108L3.74895 4.73885L3.00283 5.48498C2.67358 5.81584 2.22569 6.00128 1.75893 5.99999ZM2.00764 4.48979L1.51022 3.99237L3.99766 1.50493L4.49508 2.00234L2.00799 4.48944L2.00764 4.48979ZM4.74414 3.74366L4.24637 3.24624L4.9925 2.50012C5.26275 2.23428 5.36967 1.84393 5.2726 1.47748C5.17552 1.11104 4.88936 0.824809 4.52294 0.727646C4.15652 0.630482 3.76614 0.737311 3.50024 1.00751L2.75376 1.75364L2.25635 1.25622L3.00283 0.509737C3.69059 -0.172027 4.80006 -0.169598 5.48483 0.515172C6.1696 1.19994 6.17203 2.30942 5.49026 2.99718L4.74414 3.74331V3.74366Z' fill='white'/></svg>",
        specs_icon_svg = "<svg width='24' height='24' viewBox='0 0 24 24' fill='none'><path d='M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z' stroke-linecap='round' stroke-linejoin='round' stroke='white' stroke-width='2' fill='none'></path><circle cx='12' cy='12' r='3' stroke='white' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' fill='none'></circle></svg>",
        fps_icon_svg   = "<svg width='256' height='256' xmlns='http://www.w3.org/2000/svg' version='1.0' preserveAspectRatio='xMidYMid meet'><metadata>Created by potrace 1.10, written by Peter Selinger 2001-2011</metadata><g><title>Layer 1</title><path stroke-width='0' d='m16.08312,19.20619l0,18.5l18.5,0l18.5,0l0,-18.5l0,-18.5l-18.5,0l-18.5,0c0,6.16666 0,12.33333 0,18.5zm26.87206,1.2611l-0.02494,5.18293l-9.34712,0l-6.5,0l0,-5.44403l0,-7.76716l6.71119,0l9.16087,0l0,8.02826z' id='svg_2' fill='#fff' stroke='#000'/><path stroke-width='0' d='m0.62846,35.37154l0,18l19.21278,0l19.21278,0l0,-4l0,-4l-15.37022,0l-15.37022,0l0,-14l0,-14l-3.84256,0l-3.84256,0l0,18z' id='svg_3' fill='#fff' stroke='#000'/></g></svg>",
    },

    svg_icons,

    get_images = function(self)
        http.get('https://i.gyazo.com/a8bc85ee0938ed5b73e4864bfd468318.png', function(success, response)
            if not success or response.status ~= 200 then return end
            self.radiant_images[1] = images.load(response.body) or self.radiant_images[1]
            self.radiant_images[3] = images.load(response.body) or self.radiant_images[3]
        end)
        http.get('https://i.gyazo.com/0cf135f0e3f3d02be48bbd1e4ad1737e.png', function(success, response)
            if not success or response.status ~= 200 then return end
            self.radiant_images[2] = images.load(response.body) or self.radiant_images[2]
            self.radiant_images[4] = images.load(response.body) or self.radiant_images[4]
        end)

        client.delay_call(10, function()
            if not self.radiant_images[1] or not self.radiant_images[2] or not self.radiant_images[3] or not self.radiant_images[4] then
                self:get_images()
            end
        end)
    end,

    init = function(self)
        self:get_images()

        self.svg_icons = {
            ping_icon  = renderer.load_svg(self.svg_raw.ping_icon_svg, 100, 100),
            user_icon  = renderer.load_svg(self.svg_raw.user_icon_svg, 100, 100),
            tick_icon  = renderer.load_svg(self.svg_raw.tick_icon_svg, 100, 100),
            clock_icon = renderer.load_svg(self.svg_raw.clock_icon_svg, 100, 100),
            binds_icon = renderer.load_svg(self.svg_raw.binds_icon_svg, 100, 100),
            specs_icon = renderer.load_svg(self.svg_raw.specs_icon_svg, 100, 100),
            fps_icon   = renderer.load_svg(self.svg_raw.fps_icon_svg, 100, 100),
        }
    end,
}
imgs:init()

local funcs = {
    skip_amount = 30,
    skip_freeze = 0,

    clamp = function(b,c,d)return math.min(d,math.max(c,b))end,
    contains = function(b,c)for d=1,#b do if b[d]==c then return true end end;return false end,
    includes = function(b,c)for d=1,#b do if b[d]==c then return true,d end end;return false, -1 end,
    table_visible = function(a,b)for c,d in pairs(a)do if type(a[c])=='table'then for e,d in pairs(a[c])do ui.set_visible(a[c][e],b)end else ui.set_visible(a[c],b)end end end,
    wave_value = function(self, time, value, offset) return self.clamp(math.sin(time * 2 + (offset * 2)) * value + (255 - value), 0, 255) end,
    add_tables = function(a)local b={}for c,d in pairs(a)do for e,f in pairs(d)do b[#b+1]=f end end;return b end,
    get_players = function(b)local c={}local d=globals.maxplayers()local e=entity.get_player_resource()for f=1,d do local g=entity.is_enemy(f)local h=entity.get_prop(e,'m_bAlive',f)if not g and b or h~=1 then goto i end;table.insert(c,f)::i::end;return c end,

    get_spectating_players = function()
        local me = entity.get_local_player()
        local players, observing = {}, me
        for i = 1, globals.maxplayers() do
            if entity.get_classname(i) == 'CCSPlayer' then
                local m_iObserverMode = entity.get_prop(i, 'm_iObserverMode')
                local m_hObserverTarget = entity.get_prop(i, 'm_hObserverTarget')
                if m_hObserverTarget ~= nil and m_hObserverTarget <= 64 and not entity.is_alive(i) and (m_iObserverMode == 4 or m_iObserverMode == 5) then
                    if players[m_hObserverTarget] == nil then
                        players[m_hObserverTarget] = {}
                    end
                    if i == me then
                        observing = m_hObserverTarget
                    end
    
                    local get_avatar = (function()
                        local steam_id = entity.get_steam64(i)
                        local avatar = images.get_steam_avatar(steam_id)
    
                        if steam_id == nil or avatar == nil then return nil end
    
                        return renderer.load_rgba(avatar.contents, avatar.width, avatar.height)
                    end)()
    
                    table.insert(players[m_hObserverTarget], {i, get_avatar})
                end
            end
        end
        return players, observing
    end,
    
    raw_text = function(texts)
        local to_return = ""
        for i=1, #texts do
            to_return = to_return .. texts[i][2]
        end
        return to_return
    end,
    
    gtext_console = function(c1, text)
        text = tostring(text)
        local c2 = {c1[2], c1[3], c1[1], c1[4]}
        local incs, output, len = {}, '', #text
        
        for k, v in pairs(c1) do
            incs[k] = (c2[k] - c1[k]) / len
        end	
    
        for i = 1, len do
            if text:sub(i, i) ~= ' ' then
                client.color_log(c1[1], c1[2], c1[3], text:sub(i, i) .. '\0')
                for k, v in pairs(c1) do
                    c1[k] = c1[k] + incs[k]
                end
            else
                client.color_log(255, 255, 255, text:sub(i, i) .. '\0')
            end
        end
    end,
    
    ctext_console = function(c1, text)
        client.color_log(c1[1], c1[2], c1[3], tostring(text) .. '\0')
    end,
    
    multi_console = function(self, gradiant, ...)
        local texts = {...}
        for i = 1, #texts do
            local text = texts[i]
            if gradiant then
                self.gtext_console(text[1], i ~= #texts and text[2] or (text[2] .. '\n'))
            else
                self.ctext_console(text[1], i ~= #texts and text[2] or (text[2] .. '\n'))
            end
        end
    end,
    
    vec_to_qua = function(vec)
        local pitch, yaw;
        if vec.x == 0 and vec.y == 0 then
            pitch = (vec.z > 0) and 270 or 90
            yaw = 0
        else
            pitch = math.atan2(-vec.z, vec:length2d()) * 180 / math.pi
            if pitch < 0 then
                pitch =  pitch + 360
            end
    
            yaw = math.atan2(vec.y, vec.x) * 180 / math.pi
            if yaw < 0 then
                yaw =  yaw + 360
            end
        end
        return vector(pitch, yaw, 0)
    end,
}

local levels_cache = database.read('radiant_levels_cache') or {}
local reset_level = function()
    local player_resource = entity.get_player_resource()
    local get_players = funcs.get_players()

    for i, player in ipairs(get_players) do
        local id = tostring(entity.get_steam64(player))
        local level = entity.get_prop(player_resource, 'm_nPersonaDataPublicLevel', player)

        if level == 1814911420 then
            entity.set_prop(player_resource, 'm_nPersonaDataPublicLevel', levels_cache[id], player)
        end
    end
end
local efx = {
    peek_assist_pos = database.read('peek_assist_pos2'),
    effect_refs = {'Sparks', 'Metal sparks', 'Energy sparks', 'Muzzle flash', 'Smoke', 'Dust'},
    effect_list = {},

    get_parameters = function(self, local_velo, effect, speed, angle_offset, mode)
        local to_return = {}
        local spin_vector = vector(math.sin(globals.curtime() * speed + angle_offset - 90), math.cos(globals.curtime() * speed + angle_offset - 90), 0.1)
        if effect == self.effect_refs[1] then
            to_return = { 1, 0.6, 
                mode ~= 'Player trail' 
                    and spin_vector
                    or  local_velo,
            }
        elseif effect == self.effect_refs[2] then
            to_return = {
                mode ~= 'Player trail'
                    and spin_vector
                    or  local_velo,
            }
        elseif effect == self.effect_refs[3] then
            to_return = {
                vector(0, 0, 0), true
            }
        elseif effect == self.effect_refs[4] then
            to_return = {
                mode ~= 'Player trail'
                    and funcs.vec_to_qua(spin_vector) 
                    or  funcs.vec_to_qua(local_velo), 
                1, 1
            }
        elseif effect == self.effect_refs[5] then
            to_return = { 1, 5, 30 }
        elseif effect == self.effect_refs[6] then
            to_return = { 
                vector(0, 0, 0), 5, 10 
            }
        end
        return to_return
    end,
    
    render_effect = function(self, name, pos, colors, parameters)
        local effect = self.effect_list[name]
        local color = {255, 255, 255, 255}
        if not effect.refreshed then
            client.delay_call(0.3, function()
                self.effect_list = {[self.effect_refs[1]]={refreshed=true,func=vtable_bind('client.dll','IEffects001',3,'void(__thiscall*)(void*, const Vector&, int, int, const Vector&)'),materials={materialsystem.find_material('effects/spark',true),materialsystem.find_material('effects/yellowflare_noz',true)},parameters={1,1,vector(0,0,0)}},[self.effect_refs[2]]={refreshed=true,func=vtable_bind('client.dll','IEffects001',6,'void(__thiscall*)(void*, const Vector&, const Vector&)'),materials={materialsystem.find_material('effects/spark',true),materialsystem.find_material('effects/yellowflare',true)},parameters={vector(0,0,0)}},[self.effect_refs[3]]={refreshed=true,func=vtable_bind('client.dll','IEffects001',7,'void(__thiscall*)(void*, const Vector&, const Vector&, bool)'),materials={materialsystem.find_material('effects/spark',true),materialsystem.find_material('effects/combinemuzzle1_nocull',true),materialsystem.find_material('effects/combinemuzzle2_nocull',true)},parameters={vector(0,0,0),true}},[self.effect_refs[4]]={refreshed=true,func=vtable_bind('client.dll','IEffects001',5,'void(__thiscall*)(void*, const Vector&, const Vector&, float, int)'),materials={materialsystem.find_material('effects/muzzleflash1',true),materialsystem.find_material('effects/muzzleflash2',true),materialsystem.find_material('effects/muzzleflash3',true),materialsystem.find_material('effects/muzzleflash4',true)},parameters={vector(-90,0,0),1,1}},[self.effect_refs[5]]={refreshed=true,func=vtable_bind('client.dll','IEffects001',2,'void(__thiscall*)(void*, const Vector&, int, float, float)'),materials={materialsystem.find_material('particle/particle_smokegrenade',true),materialsystem.find_material('particle/particle_smokegrenade_2',true)},parameters={1,5,30}},[self.effect_refs[6]]={refreshed=true,func=vtable_bind('client.dll','IEffects001',4,'void(__thiscall*)(void*, const Vector&, const Vector&, float, float)'),materials={materialsystem.find_material('particle/particle_smokegrenade',true),materialsystem.find_material('particle/particle_smokegrenade_2',true)},parameters={vector(0,0,0),5,10}}}
            end)
        else
            for k, v in pairs(effect.materials) do
                color = colors[k] or color
                v:color_modulate(color[1], color[2], color[3])
                v:alpha_modulate(color[4] or 255)
            end
            effect.func(pos, table.unpack(parameters))
        end
    end,

    init = function(self)
        self.peek_assist_pos = self.peek_assist_pos and vector(self.peek_assist_pos[1], self.peek_assist_pos[2], self.peek_assist_pos[3]) or vector()    
        self.effect_list = {[self.effect_refs[1]]={refreshed=false,func=vtable_bind('client.dll','IEffects001',3,'void(__thiscall*)(void*, const Vector&, int, int, const Vector&)'),materials={materialsystem.find_material('effects/spark',true),materialsystem.find_material('effects/yellowflare_noz',true)},parameters={1,1,vector(0,0,0)}},[self.effect_refs[2]]={refreshed=false,func=vtable_bind('client.dll','IEffects001',6,'void(__thiscall*)(void*, const Vector&, const Vector&)'),materials={materialsystem.find_material('effects/spark',true),materialsystem.find_material('effects/yellowflare',true)},parameters={vector(0,0,0)}},[self.effect_refs[3]]={refreshed=false,func=vtable_bind('client.dll','IEffects001',7,'void(__thiscall*)(void*, const Vector&, const Vector&, bool)'),materials={materialsystem.find_material('effects/spark',true),materialsystem.find_material('effects/combinemuzzle1_nocull',true),materialsystem.find_material('effects/combinemuzzle2_nocull',true)},parameters={vector(0,0,0),true}},[self.effect_refs[4]]={refreshed=false,func=vtable_bind('client.dll','IEffects001',5,'void(__thiscall*)(void*, const Vector&, const Vector&, float, int)'),materials={materialsystem.find_material('effects/muzzleflash1',true),materialsystem.find_material('effects/muzzleflash2',true),materialsystem.find_material('effects/muzzleflash3',true),materialsystem.find_material('effects/muzzleflash4',true)},parameters={vector(-90,0,0),1,1}},[self.effect_refs[5]]={refreshed=false,func=vtable_bind('client.dll','IEffects001',2,'void(__thiscall*)(void*, const Vector&, int, float, float)'),materials={materialsystem.find_material('particle/particle_smokegrenade',true),materialsystem.find_material('particle/particle_smokegrenade_2',true)},parameters={1,5,30}},[self.effect_refs[6]]={refreshed=false,func=vtable_bind('client.dll','IEffects001',4,'void(__thiscall*)(void*, const Vector&, const Vector&, float, float)'),materials={materialsystem.find_material('particle/particle_smokegrenade',true),materialsystem.find_material('particle/particle_smokegrenade_2',true)},parameters={vector(0,0,0),5,10}}}
    end,
}
efx:init()

local m = {
    keybind_list = {{reference={ui.reference('rage','aimbot','Force safe point')},use_name='Safe point'},{reference={ui.reference('rage','other','Quick peek assist')},use_name='Quick peek assist'},{reference={ui.reference('rage','other','Force body aim')},use_name='Force body aim'},{reference={ui.reference('rage','other','Duck peek assist')},use_name='Duck peek assist'},{reference={ui.reference('rage','other','Double tap')},use_name='Double tap'},{reference={ui.reference('rage','other','Anti-aim correction override')},use_name='Resolver override'},{reference={ui.reference('aa','other','Slow motion')},use_name='Slow motion'},{reference={ui.reference('aa','other','On shot anti-aim')},use_name='On shot anti-aim'},{reference={ui.reference('aa','other','Fake peek')},use_name='Fake peek'},{reference={ui.reference('misc','movement','Blockbot')},use_name='Blockbot'},{reference={ui.reference('misc','miscellaneous','Last second defuse')},use_name='Last second defuse'},{reference={ui.reference('misc','miscellaneous','Ping spike')},use_name='Ping spike'}},
    mclrs = { main = '\aFF4444FF', gray = '\aD5D5D5FF' },
    ref,
    multi_tbl = {
        tab  = 'AA', 
        container = 'Anti-aimbot angles',
    
        main = {'Watermark', "Crosshair", 'Hotkey list', 'Spectator list', 'Custom logs', 'Rainbow color', 'Light theme'},
        esp = {'Sound on hit', 'Particle effects', 'Enemy ping flag', 'Precise skeleton', 'Syncing clan tag'},
        theme = {'Default', 'Glass'},
        watermark = {'Username', 'Latency', 'Frames', 'Tickrate', 'Clock'},
        crosshair = {"Dynamic position"},
        effect_modes = {'Grenade trail', 'Player trail', 'Player orbit', "Bullet impact", 'Quick peek assist'},
        hitlogs = {"On screen", "Console"},
        keybinds = {
            'Ping spike', 'Safe point', 'Force body aim', 'Resolver override', 'Duck peek assist',   
            'On shot anti-aim', 'Fake peek', 'Blockbot', 'Last second defuse', 'Double tap',  'Quick peek assist', 'Slow motion', 
        },
    },

    get_hotkey_index = function(refs)
        local to_return = {true, -1}
        for i = 1, #refs do
            if i == 1 and #refs > 1 then
                if not ui.get(refs[i]) then
                    to_return[1] = false
                end
            end
            if #{ui.get(refs[i])} > to_return[2] then
                to_return[2] = i
            end
        end
        return to_return
    end,
    
    update_list = function(self, keybind_formatted)
        for i = 1, #self.keybind_list do
            if self.keybind_list[i].use_name == keybind_formatted.use_name then
                return
            end
        end
        table.insert(self.multi_tbl.keybinds, keybind_formatted.use_name)
        table.insert(self.keybind_list, keybind_formatted)
    end,

    as_tag = function(self, str)
        return string.format('%s[%s%s%s]', self.mclrs.gray, self.mclrs.main, str, self.mclrs.gray)
    end,

    init = function(self)
        self.ref = {
            quick_peek = { ui.reference('Rage', 'Other', 'Quick peek assist') },
            on_shot_aa = { ui.reference("AA", 'Other', 'On shot anti-aim') },
            quick_peek_dist = ui.reference('Rage', 'Other', 'Quick peek assist distance'),
            dpi_scale = ui.reference('MISC', 'Settings', 'DPI scale'),
            third_person = { ui.reference('VISUALS', 'Effects', 'Force third person (alive)') },
            yaw_jitter = { ui.reference("AA", 'Anti-aimbot angles', 'Yaw jitter')},
            hit_marker_sound = ui.reference("VISUALS", "Player ESP", "Hit marker sound"),
        }

        local screen_size = {client.screen_size()}
        self.menu = {
            enabled = ui.new_checkbox(self.multi_tbl.tab, self.multi_tbl.container, string.format('%sRadiant %svisuals', self.mclrs.main, self.mclrs.gray)),
            color = ui.new_color_picker(self.multi_tbl.tab, self.multi_tbl.container, 'Radiant Color', 255, 60, 60, 255),
        
            -->
            main_options = ui.new_multiselect(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Hud'), 'Options'), self.multi_tbl.main),
            theme_options = ui.new_combobox(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Hud'), 'Theme'), self.multi_tbl.theme),
            watermark_options = ui.new_multiselect(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Watermark'), 'Options'), self.multi_tbl.watermark),
            crosshair_options = ui.new_multiselect(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Crosshair'), 'Options'), self.multi_tbl.crosshair),
            hitlog_options = ui.new_multiselect(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Custom logs'), 'Options'), self.multi_tbl.hitlogs),
        
            hitlog_hit_lbl = ui.new_label(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Custom logs'), 'Hit color')),
            hitlog_hit_clr = ui.new_color_picker(self.multi_tbl.tab, self.multi_tbl.container, 'Hitlog hit color', 132, 229, 114, 255),
            hitlog_miss_lbl = ui.new_label(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Custom logs'), 'Miss color')),
            hitlog_miss_clr = ui.new_color_picker(self.multi_tbl.tab, self.multi_tbl.container, 'Hitlog miss color', 229, 114, 114, 255),
            hitlog_shot_lbl = ui.new_label(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Custom logs'), 'Detection color')),
            hitlog_shot_clr = ui.new_color_picker(self.multi_tbl.tab, self.multi_tbl.container, 'Hitlog shot color', 229, 113, 114, 255),
            hitlog_height_off = ui.new_slider(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Custom logs'), 'Height offset'), 0, screen_size[2], screen_size[2] * 0.8, true, 'px', 1),
        
            -->
            esp_options = ui.new_multiselect(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Misc'), 'Options'), self.multi_tbl.esp),
        
            skeleton_vis = ui.new_checkbox(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Skeleton'), 'Visible')),
            skeleton_v_clr = ui.new_color_picker(self.multi_tbl.tab, self.multi_tbl.container, 'Skeleton color visible', 255, 44, 44, 255),
            skeleton_hid = ui.new_checkbox(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Skeleton'), 'Hidden')),
            skeleton_h_clr = ui.new_color_picker(self.multi_tbl.tab, self.multi_tbl.container, 'Skeleton color hidden', 33, 169, 255, 255),
        
            effect_options = ui.new_multiselect(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Effects'), 'Options'), self.multi_tbl.effect_modes),
            effect_color = ui.new_color_picker(self.multi_tbl.tab, self.multi_tbl.container, 'Effect color', 57, 137, 255, 255),
            effect_magnitude = ui.new_slider(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Effects'), 'Color Strength'), 1, 100, 255, 255),
        
            nades_options = ui.new_multiselect(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Effects'), 'Grenade trail'), efx.effect_refs),
            trail_options = ui.new_multiselect(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Effects'), 'Player trail'), efx.effect_refs),
            orbit_options = ui.new_multiselect(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Effects'), 'Player orbit'), efx.effect_refs),
            onhit_options = ui.new_multiselect(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Effects'), 'Bullet impact'), efx.effect_refs),
            quick_options = ui.new_multiselect(self.multi_tbl.tab, self.multi_tbl.container, string.format('%s %s', self:as_tag('Effects'), 'Quick peek assist'), efx.effect_refs),
        }

        ui.set_callback(self.ref.dpi_scale, function()
            funcs.skip_freeze = 1 
        end)
    end,
}
m:init()

local _v = {
    font_str  = 'Inter Semi Bold',
    font_str2 = 'Microsoft Sans Serif',

    curr_time = globals.curtime(),
    s = tonumber(ui.get(m.ref.dpi_scale):sub(1, -2))/110,
    screen_size = {client.screen_size()},

    theme = not funcs.contains(ui.get(m.menu.main_options), 'Light theme') and {{41, 41, 41}, {11, 7, 7}} or {{224, 224, 224}, {241, 249, 249}},
    theme_t = not funcs.contains(ui.get(m.menu.main_options), 'Light theme') and {244, 244, 244} or {11, 7, 7},

    color, log_color,

    update = function(self)
        self.curr_time = globals.curtime()
        self.s = tonumber(ui.get(m.ref.dpi_scale):sub(1, -2))/110
        self.screen_size = {client.screen_size()}

        self.theme = not funcs.contains(ui.get(m.menu.main_options), 'Light theme') and {{41, 41, 41}, {11, 7, 7}} or {{224, 224, 224}, {241, 249, 249}}
        self.theme_t = not funcs.contains(ui.get(m.menu.main_options), 'Light theme') and {244, 244, 244} or {11, 7, 7}

        self.color  = {funcs:wave_value(self.curr_time, 96, 2), funcs:wave_value(self.curr_time, 96, 1), funcs:wave_value(self.curr_time, 96, 0)}
        self.log_color = {funcs:wave_value(_G.log_offset, 96, 2), funcs:wave_value(_G.log_offset, 96, 1), funcs:wave_value(_G.log_offset, 96, 0)}
    end,
}
_v:update()
callbacks:create('local_globals_update', 'paint_ui', function() _v:update() end)

local draw = {
    poriton_str = function(str)
        local portions = {}
        local cursor = 1
        local in_unicode = false
        for i = 1, #str do
            local chr = string.sub(str, i, i)
            if string.byte(chr) < 128 then
                if in_unicode then
                    cursor = cursor + 1
                end
                portions[cursor] = (portions[cursor] or '') .. chr
                in_unicode = false
            else
                if not in_unicode then
                    cursor = cursor + 1
                end
                in_unicode = true
                portions[cursor] = (portions[cursor] or '') .. chr
            end
        end
        return portions
    end,
    
    draw_text_fix = function(self, x, y, r, g, b, a, f1, f2, str)
        local strs = self.poriton_str(str)
        local move_w = 0
        for i = 1, #strs do
            if strs[i] and  #strs[i] > 0 then
                if string.byte(string.sub(strs[i], 1, 1)) > 127 then
                    local w, h = surface.get_text_size(f2, strs[i])
                    surface.draw_text(x + move_w, y, r, g, b, a, f2, strs[i])
                    move_w = move_w + w
                else
                    local w, h = surface.get_text_size(f1, strs[i])
                    surface.draw_text(x + move_w, y, r, g, b, a, f1, strs[i])
                    move_w = move_w + w
                end
            end
        end
    end,
    
    draw_watermark_item = function(self, x, g, _svg, _str, font, font2, wtbl, _alpha)
        x = x + g
        renderer.texture(_svg[1], x, _svg[4], 48 *_v.s, 48 *_v.s, _v.theme_t[1], _v.theme_t[2], _v.theme_t[3], _alpha, 'f')
        x = x + g + _svg[2]
        self:draw_text_fix(x, _str[3], _v.theme_t[1], _v.theme_t[2], _v.theme_t[3], _alpha, font, font2, _str[1])
        x = x + g + _str[4]
        if wtbl[#wtbl] ~= _str[2] then
            x = x + g
            surface.draw_text(x, _str[3], 88, 88, 88, _alpha, font, '|')
            x = x + g
        end
    
        return x
    end,
    
    rounded_rectangle = function(x, y, w, h, r, g, b, a, r1, g1, b1, a1, radius, do_left, do_right, adj, fade_fix) -- credits to los, modified by bass
        y = y + radius
        local data_circle = {
            {x + radius, y, 180},
            {x + w - radius, y, 90},
            {x + radius, y + h - radius * 2, 270},
            {x + w - radius, y + h - radius * 2, 0},
        }
    
        local data = {
            {x + radius, y, w - radius * 2, h - radius * 2},
            {x + radius, y - radius, w - radius * 2, radius},
            {x + radius, y + h - radius * 2, w - radius * 2, radius},
            {x, y, radius, h - radius * 2},
            {x + w - radius, y, radius, h - radius * 2},
        }
    
        for i, data in next, data_circle do
            --renderer.text(data[1], data[2], 255, 255, 255, 255, '', 0, i)
            local _r, _g, _b, _a = i <= 2 and r or r1, i <= 2 and g or g1, i <= 2 and b or b1, i <= 2 and a or a1
            local _adj = adj and (_v.theme[1][1] == 41 and (i <= 2 and 0.9 or 0.7) or (i <= 2 and 1.1 or 1)) or 1
            if (do_left and i % 2 == 1) then
                renderer.circle(data[1], data[2], funcs.clamp(_r * _adj, 0, 255), funcs.clamp(_g * _adj, 0, 255), funcs.clamp(_b * _adj, 0, 255), fade_fix and funcs.clamp(i <= 2 and _a * 1.4 or _a * 2.3, 0, 255) or _a, radius, data[3], 0.25)
            elseif (do_right and i % 2 == 0) then
                renderer.circle(data[1], data[2], funcs.clamp(_r * _adj, 0, 255), funcs.clamp(_g * _adj, 0, 255), funcs.clamp(_b * _adj, 0, 255), fade_fix and funcs.clamp(i <= 2 and _a * 1.4 or _a * 2.3, 0, 255) or _a, radius, data[3], 0.25)
            else
                surface.draw_filled_rect(data[1], i < 3 and data[2]-radius or data[2], radius, radius, _r, _g, _b, funcs.clamp((fade_fix and i > 2) and _a * 1.7 or _a * 1.2, 0, 255))
            end
        end
    
        for i, data in next, data do
            --renderer.text(data[1], data[2], 255, 255, 255, 255, '', 0, i)
            if i == 1 or i > 3 then
                surface.draw_filled_gradient_rect(data[1], data[2], data[3], data[4], r, g, b, a, r1, g1, b1, a1, false)
            elseif i == 2 then
                surface.draw_filled_rect(data[1], data[2], data[3], data[4], r, g, b, a)
            elseif i == 3 then
                surface.draw_filled_rect(data[1], data[2], data[3], data[4], r1, g1, b1, funcs.clamp(fade_fix and a1 * 2 or a1 * 1.4, 0, 255))
            end
        end
    end,
    
    hitlog_text_line = function(self, x, y, w, h, data, f1, f2, alpha, is_light, rgb)
        local x_off = 0
        local clr_ref = {255, 255, 255}
        local size = alpha / 255
        local svg_w = h * 0.9 * size
        local rh = h + (5 * _v.s) * size
        local bk_alpha = alpha * 0.45
    
        surface.draw_filled_rect(x - svg_w + (1 * _v.s), y, w + svg_w + (2 * _v.s), rh * size, 41, 41, 41, bk_alpha)
        renderer.circle(x - svg_w + (1 * _v.s), y + ((rh / 2) * size) - size, 41, 41, 41, bk_alpha, rh / 2 * size, 180, 0.5)
        renderer.circle(x + (2.5 * _v.s) + w, y + ((rh / 2) * size) - size, 41, 41, 41, bk_alpha, (rh - 1) / 2 * size, 0, 0.5)
    
        -- draw.rounded_rectangle(x - svg_w + (1 * _v.s) - (7 * _v.s), y - _v.s, w + svg_w + (2 * _v.s) + (12 * _v.s), rh * size, 41, 41, 41, bk_alpha, 37, 37, 37, bk_alpha, 14, true, true, true)
        
        for i, v in ipairs(data) do
            local tw, th = surface.get_text_size(f1, v[2])
            if v[1][1] == 255 and  v[1][2] == 255 and v[1][3] == 255 then
                self:draw_text_fix(x + x_off, y - ((1-size) * (3 * _v.s)) - 0.5, 255, 255, 255, alpha, f1, f2, v[2])
            else
                self:draw_text_fix(x + x_off, y - ((1-size) * (3 * _v.s)) - 0.5, v[1][1], v[1][2], v[1][3], alpha, f1, f2, v[2])
                clr_ref = {v[1][1], v[1][2], v[1][3]}
            end
            x_off = x_off + tw
        end
        if imgs.radiant_images[3] and imgs.radiant_images[4] then
            imgs.radiant_images[3]:draw(x - svg_w , y + (3 * _v.s), svg_w, svg_w, clr_ref[1], clr_ref[2], clr_ref[3], alpha, true, 'f')
            imgs.radiant_images[4]:draw(x - svg_w, y + (3 * _v.s), svg_w, svg_w, 255, 255, 255, alpha, true, 'f')
        end
    end,
}

ffi.cdef('typedef struct { float x; float y; float z; } bbvec3_t;')
local ffeye = {
    pClientEntityList = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("invalid interface", 2),
    fnGetClientEntity = vtable_thunk(3, "void*(__thiscall*)(void*, int)"),

    fnGetAttachment = vtable_thunk(84, "bool(__thiscall*)(void*, int, bbvec3_t&)"),
    fnGetMuzzleAttachmentIndex1stPerson = vtable_thunk(468, "int(__thiscall*)(void*, void*)"),
    fnGetMuzzleAttachmentIndex3stPerson = vtable_thunk(469, "int(__thiscall*)(void*)"),

    get_attachment_vector = function(self, world_model)
        local me = entity.get_local_player()
        local wpn = entity.get_player_weapon(me)

        local model =
            world_model and 
            entity.get_prop(wpn, 'm_hWeaponWorldModel') or
            entity.get_prop(me, 'm_hViewModel[0]')

        if me == nil or wpn == nil then
            return
        end

        local active_weapon = self.fnGetClientEntity(self.pClientEntityList, wpn)
        local g_model = self.fnGetClientEntity(self.pClientEntityList, model)

        if active_weapon == nil or g_model == nil then
            return
        end

        local attachment_vector = ffi.new("bbvec3_t[1]")
        local att_index = world_model and
        self.fnGetMuzzleAttachmentIndex3stPerson(active_weapon) or
        self.fnGetMuzzleAttachmentIndex1stPerson(active_weapon, g_model)

        -- fnGetAttachment = wrong lol but works :D
        if att_index > 0 then
            if self.fnGetAttachment(g_model, att_index, attachment_vector[0]) then
                return vector(attachment_vector[0].x, attachment_vector[0].y, attachment_vector[0].z)
            end
        end
    end,
}

local bind = (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider('LUA','A',u..' window position',0,x,v/j*x)local z=ui.new_slider('LUA','A',u..' window position y',0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals.framecount()~=b then c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)()
local spec = (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider('LUA','A',u..' window position',0,x,v/j*x)local z=ui.new_slider('LUA','A',u..' window position y',0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals.framecount()~=b then c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)()
local hud = {
    i_height = 26,

    spectator_easing = {},
    ease_length = 0.125,

    frametimes_index = 0, 
    avg_fps = 0,

    frametimes = {}, 
    fps_updated = globals.curtime(),

    accumulate_fps = function(self)local a=globals.absoluteframetime()if a>0 then self.frametimes[self.frametimes_index]=a;self.frametimes_index=self.frametimes_index+1;if self.frametimes_index>=64 then self.frametimes_index=0 end end;local b=0;local c=0;local d=self.frametimes_index;local e=nil;for f=0,64-1 do d=d-1;if d<0 then d=64-1 end;a=self.frametimes[d]if a==0 or not a then break end;b=b+a;c=c+1;e=a;if b>=0.5 then break end end;if c==0 then return 0 end;b=b/c;local g=tonumber(1/b)if self.fps_updated+1<globals.curtime()then self.avg_fps=g;self.fps_updated=globals.curtime()end;return self.avg_fps end,

    bind_states = {'always', 'holding', 'toggled', 'off-hold'},
    bind_easing = {},
    active_binds = {},

    old_w = 0, 
    old_alpha_w = (ui.get(m.menu.enabled) and funcs.contains(ui.get(m.menu.main_options), 'Watermark')) and 255 or 0,

    bind_data = database.read('radiant_bind_drag') or {x = _v.screen_size[1] * 0.01, y = _v.screen_size[2] / 2},
    old_alpha_k = (ui.get(m.menu.enabled) and funcs.contains(ui.get(m.menu.main_options), 'Hotkey list')) and 255 or 0,

    spec_data = database.read('radiant_spec_drag') or {x = _v.screen_size[1] * 0.9, y = _v.screen_size[2] / 2},
    old_alpha_s = (ui.get(m.menu.enabled) and funcs.contains(ui.get(m.menu.main_options), 'Spectator list')) and 255 or 0,

    spectators, player,
    last_updated = _v.curr_time,

    bind, spec,

    init = function(self)
        self.bind = bind.new('radiant_hotkeys', self.bind_data.x, self.bind_data.y)
        self.spec = spec.new('radiant_spectators', self.spec_data.x, self.spec_data.y)
        self.spectators, self.player = funcs.get_spectating_players()
    end,

    callback = function(self)
        local enabled = ui.get(m.menu.enabled)
        local main_tbl = ui.get(m.menu.main_options)
        local esp_tbl = ui.get(m.menu.esp_options)
    
        local rgb_mode = funcs.contains(main_tbl, 'Rainbow color')

        if ui.is_menu_open() then 
            funcs.table_visible({m.menu.color, m.menu.main_options, m.menu.esp_options, m.menu.theme_options, m.menu.watermark_options, m.menu.keybinds_options, m.menu.spectators_options, m.menu.hitlog_options, m.menu.enemy_options}, enabled)
    
            ui.set_visible(m.menu.theme_options, #main_tbl > 0 and enabled)
            ui.set_visible(m.menu.watermark_options, funcs.contains(main_tbl, 'Watermark') and enabled)
            ui.set_visible(m.menu.crosshair_options, funcs.contains(main_tbl, 'Crosshair') and enabled)
    
            funcs.table_visible({m.menu.hitlog_miss_lbl, m.menu.hitlog_miss_clr, m.menu.hitlog_hit_lbl, m.menu.hitlog_hit_clr, m.menu.hitlog_shot_lbl, m.menu.hitlog_shot_clr, m.menu.hitlog_height_off}, funcs.contains(main_tbl, 'Custom logs') and not rgb_mode and enabled)
            funcs.table_visible({m.menu.hitlog_options}, funcs.contains(main_tbl, 'Custom logs') and enabled)
            funcs.table_visible({m.menu.skeleton_vis,   m.menu.skeleton_hid}, funcs.contains(esp_tbl, 'Precise skeleton') and enabled)
            funcs.table_visible({m.menu.skeleton_v_clr, m.menu.skeleton_h_clr}, funcs.contains(esp_tbl, 'Precise skeleton') and not rgb_mode and enabled)
    
            local effects = ui.get(m.menu.effect_options)
            ui.set_visible(m.menu.effect_options, funcs.contains(esp_tbl, 'Particle effects') and enabled)
            ui.set_visible(m.menu.effect_color,  funcs.contains(esp_tbl, 'Particle effects') and not rgb_mode and enabled)
            ui.set_visible(m.menu.effect_magnitude, funcs.contains(esp_tbl, 'Particle effects') and enabled)
            
            ui.set_visible(m.menu.nades_options, funcs.contains(esp_tbl, 'Particle effects') and funcs.contains(effects, 'Grenade trail') and enabled)
            ui.set_visible(m.menu.trail_options, funcs.contains(esp_tbl, 'Particle effects') and funcs.contains(effects, 'Player trail') and enabled)
            ui.set_visible(m.menu.orbit_options, funcs.contains(esp_tbl, 'Particle effects') and funcs.contains(effects, 'Player orbit') and enabled)
            ui.set_visible(m.menu.onhit_options, funcs.contains(esp_tbl, 'Particle effects') and funcs.contains(effects, 'Bullet impact') and enabled)
            ui.set_visible(m.menu.quick_options, funcs.contains(esp_tbl, 'Particle effects') and funcs.contains(effects, 'Quick peek assist') and enabled)
            
            ui.set_visible(m.menu.color, not rgb_mode and enabled)
            -- ui.set_visible(m.menu.ease_speed, enabled)
        end 

        if funcs.skip_freeze < funcs.skip_amount then
            funcs.skip_freeze = funcs.skip_freeze + 1
            return
        end

    
        -- Vars
        local local_player = entity.get_local_player()
        local color = rgb_mode and _v.color or {ui.get(m.menu.color)}
        local cm = math.floor(globals.absoluteframetime() * 1000)
    
        _v.theme[1][1] = funcs.clamp(_v.theme[1][1] + (not funcs.contains(main_tbl, 'Light theme') and -cm or cm), 41, 241)
        _v.theme[1][2] = funcs.clamp(_v.theme[1][2] + (not funcs.contains(main_tbl, 'Light theme') and -cm or cm), 41, 249)
        _v.theme[1][3] = funcs.clamp(_v.theme[1][3] + (not funcs.contains(main_tbl, 'Light theme') and -cm or cm), 41, 249)
    
        _v.theme[2][1] = funcs.clamp(_v.theme[2][1] + (not funcs.contains(main_tbl, 'Light theme') and -cm or cm), 11, 194)
        _v.theme[2][2] = funcs.clamp(_v.theme[2][2] + (not funcs.contains(main_tbl, 'Light theme') and -cm or cm), 7, 194)
        _v.theme[2][3] = funcs.clamp(_v.theme[2][3] + (not funcs.contains(main_tbl, 'Light theme') and -cm or cm), 7, 194)
    
        _v.theme_t[1] = funcs.clamp(_v.theme_t[1] + (not funcs.contains(main_tbl, 'Light theme') and cm or -cm), 11, 244)
        _v.theme_t[2] = funcs.clamp(_v.theme_t[2] + (not funcs.contains(main_tbl, 'Light theme') and cm or -cm), 11, 244)
        _v.theme_t[3] = funcs.clamp(_v.theme_t[3] + (not funcs.contains(main_tbl, 'Light theme') and cm or -cm), 11, 244)
    
        local gap, g = 15 * _v.s, 10 * _v.s
        local svg_w = 12 * _v.s
    
        local font = surface.create_font(_v.font_str, math.floor(16 * _v.s + 0.5), 555, {0x010})
        local font2 = surface.create_font(_v.font_str2, math.floor(16 * _v.s + 0.5), 555, {0x010})
    
        local inds_font = surface.create_font(_v.font_str, math.floor(14 * _v.s + 0.5), 555, {0x010})
        local inds_font2 = surface.create_font(_v.font_str2, math.floor(14 * _v.s + 0.5), 555, {0x010})
    
        local theme_selected = ui.get(m.menu.theme_options)
    
        -- Watermark
        if funcs.contains(main_tbl, 'Watermark') or self.old_alpha_w > 0 then
            local water_tbl = ui.get(m.menu.watermark_options)
            local font_size = {surface.get_text_size(font, 'Radiant')}
            local w, h = font_size[1] + (20 * _v.s) + g, self.i_height * _v.s
            local label_w = font_size[1] + (10 * _v.s) + g
            local text_y = gap + (h / 2) - (font_size[2] / 2) + _v.s
            local svg_y = gap + (h / 2) - (svg_w / 2)
            local prev_w = label_w + g
    
            local s_w, s_h = surface.get_text_size(font, '|')
            w = w + ((s_w + g + g) * (#water_tbl - 1))
    
            local name = {
                text = cache and cache['username'] or MyPersonaAPI.GetName(),
                size = {surface.get_text_size(font, cache and cache['username'] or MyPersonaAPI.GetName())},
            }
            w = funcs.contains(water_tbl, 'Username') and w + (3 * g) + s_w + name.size[1] or w
    
            local ping = {
                text = tostring(math.floor(client.latency() * 1000)) .. 'ms',
                size = {surface.get_text_size(font, (function()
                    local ret = ''
                    for i = 1, #(tostring(math.floor(client.latency() * 1000)) .. 'ms') - 2 do
                        ret = ret .. '0'
                    end
                    return ret .. 'ms'
                end)())},
            }
            w = funcs.contains(water_tbl, 'Latency') and w + (3 * g) + s_w + ping.size[1] or w
    
            local tick = {
                text = tostring(1 / globals.tickinterval()) .. 'tick ',
                size = {surface.get_text_size(font, tostring(1 / globals.tickinterval()) .. 'tick ')},
            }
            w = funcs.contains(water_tbl, 'Tickrate') and w + (3 * g) + s_w + tick.size[1] or w
    
            local fps = {
                text = tostring(math.floor(self:accumulate_fps() + 0.5)) .. 'fps',
                size = {surface.get_text_size(font, tostring(math.floor(self:accumulate_fps() + 0.5)) .. 'fps')},
            }
            w = funcs.contains(water_tbl, 'Frames') and w + (3 * g) + s_w + fps.size[1]  or w
    
            local clock = {
                text = ('%02d:%02d:%02d'):format(client.system_time()),
                size = {surface.get_text_size(font, ('%02d:%02d:%02d'):format(client.system_time()))},
            }
            w = funcs.contains(water_tbl, 'Clock') and w + (3 * g) + s_w + clock.size[1]  or w 
    
            w = w + g
    
            local x = _v.screen_size[1] - self.old_w - gap
    
            if theme_selected ~= 'Default' then -- this is illusion code does not exist in state of mexico
                for i=1, #main_tbl do
                    local da_tbl = main_tbl[i]
                    if da_tbl == 'Light theme' then
                        table.remove(main_tbl, i)
                    end
                end
    
                ui.set(m.menu.main_options, main_tbl)
            end
    
            if theme_selected == 'Default' then
                if #water_tbl > 0 then
                    draw.rounded_rectangle(x, gap, self.old_w, h, _v.theme[1][1], _v.theme[1][2], _v.theme[1][3], self.old_alpha_w, _v.theme[2][1], _v.theme[2][2], _v.theme[2][3], self.old_alpha_w, 8, true, true, true, false)
                end
    
                draw.rounded_rectangle(x, gap, label_w, h, color[1], color[2], color[3], self.old_alpha_w, color[1] * 0.75, color[2] * 0.75, color[3] * 0.75, self.old_alpha_w, 8, true, #water_tbl == 0, false, true)
            elseif theme_selected == 'Glass' then
                draw.rounded_rectangle(x, gap, self.old_w, h, _v.theme[1][1], _v.theme[1][2], _v.theme[1][3], self.old_alpha_w/4, _v.theme[2][1], _v.theme[2][2], _v.theme[2][3], self.old_alpha_w/4, 8, true, true, true, false)
                renderer.blur(x, gap, self.old_w, h)

                renderer.gradient(x, gap + 8, 1, h/2, color[1], color[2], color[3], self.old_alpha_w, color[1], color[2], color[3], 0, false)
                renderer.gradient(x + w - 1, gap + 8, 1, h/2, color[1], color[2], color[3], self.old_alpha_w, color[1], color[2], color[3], 0, false)
    
                renderer.rectangle(x + 8, gap, self.old_w - 15, 1, color[1], color[2], color[3], 255)
                renderer.circle_outline(x + 10, gap + 10, color[1], color[2], color[3], self.old_alpha_w, 10, 180, 0.25, 1) --> Left
                renderer.circle_outline(x + self.old_w - 10, gap + 10, color[1], color[2], color[3], self.old_alpha_w, 10, 270, 0.25, 1) --> Right
            end
    
            x = x + g
            surface.draw_text(x - 2, text_y, 255, 255, 255, self.old_alpha_w, font, 'Radiant')
            if theme_selected ~= 'Default' and #water_tbl > 0 then
                surface.draw_text(x + surface.get_text_size(font, 'Radiant') + 8, text_y, 88, 88, 88, self.old_alpha_w, font, '|')
            end
    
            x = x + (g * 1.5)  + font_size[1] + (2 * _v.s)
    
            if funcs.contains(water_tbl, 'Username') and x + self.old_w > x + prev_w + svg_w + (g * 3) + name.size[1]   then
                x = draw:draw_watermark_item(x, g, {imgs.svg_icons.user_icon, svg_w, svg_w, svg_y}, {name.text, 'Username', text_y, name.size[1] }, font, font2, water_tbl, self.old_alpha_w)
                prev_w = prev_w + (g * 2) + name.size[1] + svg_w + (water_tbl[#water_tbl] ~= 'Username' and (s_w + (g * 2)) or 0)
            end
    
            if funcs.contains(water_tbl, 'Latency') and x + self.old_w > x + prev_w + svg_w + (g * 3) + ping.size[1]  then
                x = draw:draw_watermark_item(x, g, {imgs.svg_icons.ping_icon, svg_w, svg_w * 0.6, svg_y * 1.15}, {ping.text, 'Latency', text_y, ping.size[1] }, font, font2, water_tbl, self.old_alpha_w)
                prev_w = prev_w + (g * 2) + ping.size[1] + svg_w + (water_tbl[#water_tbl] ~= 'Latency' and (s_w + (g * 2)) or 0)
            end
    
            if funcs.contains(water_tbl, 'Frames') and x + self.old_w > x + prev_w + svg_w + (g * 3) + fps.size[1]   then
                x = draw:draw_watermark_item(x + _v.s, g, {imgs.svg_icons.fps_icon, svg_w * 0.95, svg_w * 0.9, svg_y * 1.08}, {fps.text, 'Frames', text_y, fps.size[1] }, font, font2, water_tbl, self.old_alpha_w)
                prev_w = prev_w + (g * 2) + fps.size[1] + svg_w + (water_tbl[#water_tbl] ~= 'Frames' and (s_w + (g * 2)) or 0)
            end
    
            if funcs.contains(water_tbl, 'Tickrate') and x + self.old_w > x + prev_w + svg_w + (g * 3) + tick.size[1]   then
                x = draw:draw_watermark_item(x, g, {imgs.svg_icons.tick_icon, svg_w, svg_w * 0.8, svg_y * (1.1 + (_v.s / 15))}, {tick.text, 'Tickrate', text_y, tick.size[1] }, font, font2, water_tbl, self.old_alpha_w)
                prev_w = prev_w + (g * 2) + tick.size[1] + svg_w + (water_tbl[#water_tbl] ~= 'Tickrate' and (s_w + (g * 2)) or 0)
            end
    
            if funcs.contains(water_tbl, 'Clock') and x + self.old_w > x + prev_w + svg_w + (g * 3) + clock.size[1]   then
                x = draw:draw_watermark_item(x - (_v.s * 5), g, {imgs.svg_icons.clock_icon, svg_w, svg_w, svg_y}, {clock.text, 'Clock', text_y, clock.size[1] }, font, font2, water_tbl, self.old_alpha_w)
                prev_w = prev_w + (g * 2) + clock.size[1] + svg_w + (water_tbl[#water_tbl] ~= 'Clock' and (s_w + (g * 2)) or 0)
            end
    
            self.old_w = easing.quad_out(1, self.old_w, w - self.old_w, 15)
        end
    
        if funcs.contains(main_tbl, 'Spectator list') then
            if self.last_updated + 0.1 < _v.curr_time then
                self.last_updated = _v.curr_time
                self.spectators, self.player = funcs.get_spectating_players()
            end
            
            if self.spectators and self.spectators[self.player] then
                for k, v in next, self.spectators[self.player] do
                    if not self.spectator_easing[v[1]] then
                        self.spectator_easing[v[1]] = {0, 0, globals.tickcount()}
                    end
                end
            end

            if (self.player ~= nil and self.spectators[self.player]) or self.old_alpha_s > 1 then
                local pos = {self.spec:get()}
                database.write('radiant_spec_drag', {
                    x = pos[1],
                    y = pos[2]
                })
                local x, y = pos[1], pos[2]
                
                local w, h = 180 * _v.s, self.i_height * _v.s
                local t_w, t_h = surface.get_text_size(font, 'Spectators')
                if theme_selected == 'Default' then
                    draw.rounded_rectangle(x, y, w, h, _v.theme[1][1], _v.theme[1][2], _v.theme[1][3], self.old_alpha_s, _v.theme[2][1], _v.theme[2][2], _v.theme[2][3], self.old_alpha_s, 8, true, true, true, false)
                    draw.rounded_rectangle(x, y, 30 * _v.s, h, color[1], color[2], color[3], self.old_alpha_s, color[1] * 0.75, color[2] * 0.75, color[3] * 0.75, self.old_alpha_s, 8, true, false, false, true)
    
                    renderer.texture(imgs.svg_icons.specs_icon, x + 26 * _v.s * 0.35, y + 30 * _v.s / 2 - svg_w / 1.2, svg_w * 1.55, svg_w * 1.55, 255, 255, 255, self.old_alpha_s, 'f')
                    
                    surface.draw_text(x + (32 * _v.s) + svg_w, y + (t_h / 3.5), _v.theme_t[1], _v.theme_t[2], _v.theme_t[3], self.old_alpha_s, font, 'Spectators')
                    surface.draw_filled_rect(x + (32 * _v.s) + svg_w, y + h - (_v.s * 1.5), t_w, _v.s * 1.5, color[1], color[2], color[3], self.old_alpha_s)
                elseif theme_selected == 'Glass' then
                    draw.rounded_rectangle(x, y, w, h, _v.theme[1][1], _v.theme[1][2], _v.theme[1][3], self.old_alpha_w/4, _v.theme[2][1], _v.theme[2][2], _v.theme[2][3], self.old_alpha_w/4, 8, true, true, true, false)
                    renderer.blur(x, y, w, h)
                    renderer.gradient(x, y + 8, 1, h/2, color[1], color[2], color[3], self.old_alpha_s, color[1], color[2], color[3], 0, false)
                    renderer.gradient(x + w - 1, y + 8, 1, h/2, color[1], color[2], color[3], self.old_alpha_s, color[1], color[2], color[3], 0, false)
        
                    renderer.rectangle(x + 8, y, w - 16, 1, color[1], color[2], color[3], self.old_alpha_s)
                    renderer.circle_outline(x + 10, y + 10, color[1], color[2], color[3], self.old_alpha_s, 10, 180, 0.25, 1) --> Left
                    renderer.circle_outline(x + w - 10, y + 10, color[1], color[2], color[3], self.old_alpha_s, 10, 270, 0.25, 1) --> Right
    
                    renderer.texture(imgs.svg_icons.specs_icon, x + 26 * _v.s * 0.35, y + 30 * _v.s / 2 - svg_w / 1.2, svg_w * 1.55, svg_w * 1.55, 255, 255, 255, self.old_alpha_s, 'f')
                    
                    surface.draw_text(x + (32 * _v.s) + svg_w, y + (t_h / 3.5), _v.theme_t[1], _v.theme_t[2], _v.theme_t[3], self.old_alpha_s, font, 'Spectators')
                    surface.draw_filled_rect(x + (32 * _v.s) + svg_w, y + h - (_v.s * 1.5), t_w, _v.s * 1.5, color[1], color[2], color[3], self.old_alpha_s)
                end
                if self.player then
                    if self.spectators[self.player] then
                        local i = 1
                        local y_offset = 0
                        for _, specdata in pairs(self.spectators[self.player]) do
                            local line_y = y + h + y_offset + 5
                            local base_x = x + (_v.s * 4)
                            local b_alpha = self.spectator_easing[specdata[1]][1] * 255
    
                            local s_name = entity.get_player_name(specdata[1])
                            local a_w, a_h = surface.get_text_size(font, s_name)
                            if a_w + svg_w + (8 * _v.s) > w then
                                local new_name = ''
                                for i = 1, #s_name do
                                    if surface.get_text_size(font, (new_name .. string.sub(s_name, i, i))) > w - svg_w - (8 * _v.s) then
                                        break
                                    end
                                    new_name = new_name .. string.sub(s_name, i, i)          
                                end
                                s_name = new_name
                            end
                            
                            self.spectator_easing[specdata[1]][1] = easing.quad_out(self.spectator_easing[specdata[1]][2], 0, 1, self.ease_length)
                            self.spectator_easing[specdata[1]][1] = funcs.clamp(self.spectator_easing[specdata[1]][1], 0, 1)
    
                            self.spectator_easing[specdata[1]][2] = self.spectator_easing[specdata[1]][2] + globals.absoluteframetime()
                            self.spectator_easing[specdata[1]][2] = funcs.clamp(self.spectator_easing[specdata[1]][2], 0, self.ease_length)
    
                            self.spectator_easing[specdata[1]][3] = globals.tickcount()
                            
                            --surface.draw_text(base_x + (30 * _v.s), line_y + (2 * _v.s), 215, 215, 215, b_alpha, inds_font, s_name)
                            draw:draw_text_fix(base_x + (30 * _v.s), line_y + (2 * _v.s), 215, 215, 215, b_alpha, inds_font, inds_font2, s_name)
                            
                            renderer.texture(specdata[2], base_x + (7 * _v.s), line_y, 19 * _v.s, 19 * _v.s, 215, 215, 215, b_alpha, 'f')
                            i = i + 1
                            y_offset = y_offset + (19 * _v.s + 2) * self.spectator_easing[specdata[1]][1]
                        end
                    end
                end
            end
        end
        for k, v in next, self.spectator_easing do
            if v[3] ~= globals.tickcount() then
                v[1], v[2] = 0, 0
            end
        end
        
        if funcs.contains(main_tbl, 'Hotkey list') and self.old_alpha_k > 0 then
            local pos = {self.bind:get()}
            local x, y = pos[1], pos[2]
            database.write('radiant_bind_drag', {
                x = pos[1],
                y = pos[2]
            })
            local w, h = 210 * _v.s, self.i_height * _v.s
            local t_w, t_h = surface.get_text_size(font, 'Hotkeys')
    
            if theme_selected == 'Default' then
                draw.rounded_rectangle(x, y, w, h, _v.theme[1][1], _v.theme[1][2], _v.theme[1][3], self.old_alpha_k, _v.theme[2][1], _v.theme[2][2], _v.theme[2][3], self.old_alpha_k, 8, true, true, true, false)
                draw.rounded_rectangle(x, y, 30 * _v.s, h, color[1], color[2], color[3], self.old_alpha_k, color[1] * 0.75, color[2] * 0.75, color[3] * 0.75, self.old_alpha_k, 8, true, false, false, true)
        
                renderer.texture(imgs.svg_icons.binds_icon, x + (9 * _v.s), y + h / 2 - (svg_w / 2) + _v.s, svg_w, svg_w, 255, 255, 255, self.old_alpha_k, 'f')
        
                surface.draw_text(x + (32 * _v.s) + svg_w, y + (t_h / 3.5), _v.theme_t[1], _v.theme_t[2], _v.theme_t[3], self.old_alpha_k, font, 'Hotkeys')
                surface.draw_filled_rect(x + (32 * _v.s) + svg_w, y + h - (_v.s * 1.5), t_w, _v.s * 1.5, color[1], color[2], color[3], self.old_alpha_k)    
            elseif theme_selected == 'Glass' then
                draw.rounded_rectangle(x, y, w, h, _v.theme[1][1], _v.theme[1][2], _v.theme[1][3], self.old_alpha_w/4, _v.theme[2][1], _v.theme[2][2], _v.theme[2][3], self.old_alpha_w/4, 8, true, true, true, false)
                renderer.blur(x, y, w, h)
                renderer.gradient(x, y + 8, 1, h/2, color[1], color[2], color[3], self.old_alpha_k, color[1], color[2], color[3], 0, false)
                renderer.gradient(x + w - 1, y + 8, 1, h/2, color[1], color[2], color[3], self.old_alpha_k, color[1], color[2], color[3], 0, false)
    
                renderer.rectangle(x + 8, y, w - 16, 1, color[1], color[2], color[3], self.old_alpha_k)
                renderer.circle_outline(x + 10, y + 10, color[1], color[2], color[3], self.old_alpha_k, 10, 180, 0.25, 1) --> Left
                renderer.circle_outline(x + w - 10, y + 10, color[1], color[2], color[3], self.old_alpha_k, 10, 270, 0.25, 1) --> Right
    
                renderer.texture(imgs.svg_icons.binds_icon, x + (9 * _v.s), y + h / 2 - (svg_w / 2) + _v.s, svg_w, svg_w, 255, 255, 255, self.old_alpha_k, 'f')
        
                surface.draw_text(x + (32 * _v.s) + svg_w, y + (t_h / 3.5), _v.theme_t[1], _v.theme_t[2], _v.theme_t[3], self.old_alpha_k, font, 'Hotkeys')
                surface.draw_filled_rect(x + (32 * _v.s) + svg_w, y + h - (_v.s * 1.5), t_w, _v.s * 1.5, color[1], color[2], color[3], self.old_alpha_k)  
            end
    
            if _G.radiant_hotkeys then
                if #_G.radiant_hotkeys > 0 then
                    for i = 1, #_G.radiant_hotkeys do
                        m:update_list(_G.radiant_hotkeys[i])
                    end
                end
            end
    
            for i = 1, #m.keybind_list do
                local bind = m.keybind_list[i]    
                local hotkey_ind = m.get_hotkey_index(bind.reference)
                local bind_hk = {ui.get(bind.reference[hotkey_ind[2]])}
                self.active_binds[bind.use_name] = {bind.use_name, self.bind_states[bind_hk[2] + 1], bind_hk[1] and hotkey_ind[1], -1}
                if (bind_hk[1] and hotkey_ind[1]) and not self.bind_easing[bind.use_name] then
                    self.bind_easing[bind.use_name] = {0, 0}
                end
            end
    
            local inds_font = surface.create_font(_v.font_str, math.floor(14 * _v.s + 0.5), 555, {0x010})
            local inds_font2 = surface.create_font(_v.font_str2, math.floor(14 * _v.s + 0.5), 555, {0x010})
            local i = 1
            local y_offset = 0
            for j = 1, #m.multi_tbl.keybinds do
                local bind = self.active_binds[m.multi_tbl.keybinds[j]]
                if bind[3] or self.bind_easing[bind[1]] then
                    local line_y = y + h + 5 + y_offset
                    local base_x = x
                    local b_alpha = self.bind_easing[bind[1]][1] * 255
    
                    surface.draw_text(base_x + (7 * _v.s), line_y, 215, 215, 215, b_alpha, inds_font, bind[1])
    
                    local m_w, m_h = surface.get_text_size(inds_font, bind[2])
                    surface.draw_text(base_x + w - m_w - (5 * _v.s), line_y, 215, 215, 215, b_alpha, inds_font, bind[2])
                    y_offset = y_offset + m_h * (self.bind_easing[bind[1]][1])
                    
                    renderer.circle(base_x + w - (47 * _v.s) - (14 * _v.s), line_y + (8 * _v.s), color[1] * 0.9, color[2] * 0.9, color[3] * 0.9, b_alpha, _v.s * 2.5, 0, 1)
                    
                    self.bind_easing[bind[1]][1] = bind[3] and easing.quad_out(self.bind_easing[bind[1]][2], 0, 1, self.ease_length) or easing.quad_out(self.ease_length - self.bind_easing[bind[1]][2], 1, -1, self.ease_length)
                    self.bind_easing[bind[1]][1] = funcs.clamp(self.bind_easing[bind[1]][1], 0, 1)
    
                    self.bind_easing[bind[1]][2] = bind[3] and self.bind_easing[bind[1]][2] + globals.absoluteframetime() or self.bind_easing[bind[1]][2] - globals.absoluteframetime()
                    self.bind_easing[bind[1]][2] = funcs.clamp(self.bind_easing[bind[1]][2], 0, self.ease_length)
                    i = i + 1
                end
            end
        end
    
        for i = 1, #m.keybind_list do
            local bind = m.keybind_list[i]    
            local hotkey_ind = m.get_hotkey_index(bind.reference)
            local bind_hk = {ui.get(bind.reference[hotkey_ind[2]])}
            self.active_binds[bind.use_name] = {bind.use_name, self.bind_states[bind_hk[2] + 1], bind_hk[1] and hotkey_ind[1], -1}
            if (bind_hk[1] and hotkey_ind[1]) and not self.bind_easing[bind.use_name] then
                self.bind_easing[bind.use_name] = {0, 0}
            end
        end
    
        local binds_on = {}
        for j = 1, #m.multi_tbl.keybinds do
            local bind = self.active_binds[m.multi_tbl.keybinds[j]]
            if bind[3] then
                table.insert(binds_on, bind[1])
            end
        end
        
        self.old_alpha_k = funcs.clamp(self.old_alpha_k + ((ui.get(m.menu.enabled) and funcs.contains(main_tbl, 'Hotkey list')) and (#binds_on > 0 and entity.is_alive(local_player) or ui.is_menu_open()) and self.ease_length * 255 * 50 * globals.absoluteframetime() or -(self.ease_length * 255 * 50 * globals.absoluteframetime())), 0, 255)
        self.old_alpha_s = funcs.clamp(self.old_alpha_s + ((ui.get(m.menu.enabled) and funcs.contains(main_tbl, 'Spectator list') and self.spectators[self.player] and entity.get_prop(self.player, 'm_iObserverMode') ~= 6 or ui.is_menu_open()) and self.ease_length * 255 * 50 * globals.absoluteframetime() or -(self.ease_length * 255 * 50 * globals.absoluteframetime())), 0, 255)
        self.old_alpha_w = funcs.clamp(self.old_alpha_w + ((ui.get(m.menu.enabled) and funcs.contains(main_tbl, 'Watermark')) and 170 - self.ease_length or -(170 - self.ease_length)), 0, 255)
        
        self.bind:drag(210 * _v.s, 30 * _v.s)
        self.spec:drag(170 * _v.s, 30 * _v.s)
    
        _G.radiant_detect_color = rgb_mode and _v.log_color or {ui.get(m.menu.hitlog_shot_clr)}
        _G.radiant_log_options = ui.get(m.menu.hitlog_options)
    
    end,
}

hud:init()
hud:callback()
callbacks:create('hud_paint', 'paint_ui', function() hud:callback() end)


local esp = {
    bones = {{1,2},{2,7},{7,6},{6,5},{5,4},{4,3},{3,8},{8,10},{10,12},{3,9},{9,11},{11,13},{7,16},{16,17},{17,14},{7,18},{18,19},{19,15}},

    impact_list = {},

    lx = _v.screen_size[1] * 0.5 + (10 * _v.s), 
    ly = (_v.screen_size[2] * 0.5) + (10 * _v.s),
    
    lw = 7, 
    lh = _v.s * 6,

    c_a = 0,

    ct_delay = 1, -- lazy kodenz chronices ep 5? idk
    ct_index = 1,
    ct_data = {
        '[]',
        '[r]',
        '[ra]',
        '[rad]',
        '[radi]',
        '[radia]',
        '[radian]',
        '[radiant]',
        '[radiant.]',
        '[radiant.r]',
        '[radiant.ri]',
        '[radiant.rip]',
        '[radiant.rip]',
        '[radiant.rip]',
        '[radiant.rip]',
        '[radiant.rip]',
        '[radiant.rip]',
        '[radiant.ri]',
        '[radiant.r]',
        '[radiant.]',
        '[radiant]',
        '[radian]',
        '[radia]',
        '[radi]',
        '[rad]',
        '[ra]',
        '[r]',
        '[]'
    },

    partial_skeleton = function(self, camera, player, clr1, clr2)
        local local_player = entity.get_local_player()
        local opts = {skip = {local_player, player}, mask = 'MASK_SHOT'}
        for __, bone in ipairs(self.bones) do
            local bone1 = vector(entity.hitbox_position(player, bone[1]-1))
            local bone2 = vector(entity.hitbox_position(player, bone[2]-1)) 
    
            local trace2 = trace.line(camera, bone2, opts).fraction > 0.9
            local trace1 = trace.line(camera, bone1, opts).fraction > 0.9
    
            local xa, ya = renderer.world_to_screen(bone1:unpack())
            local xb, yb = renderer.world_to_screen(bone2:unpack())
    
            if (trace1 and not trace2) or (not trace1 and trace2) then
                local side = (not trace1 and trace2)
                local slide = side and vector(bone1:unpack()) or vector(bone2:unpack())
                local slope = side and bone2 - bone1 or bone1 - bone2
    
                local i, add = 1, vector(0, 0, 0)
                while i <= 4 do
                    local percent = slope * (1 / (2 ^ i))
                    local is_visible = trace.line(camera, slide + add, opts).fraction > 0.9
                    add, i = add + (is_visible and -percent or percent), i + 1
                end
    
                local c1 = side and clr2 or clr1
                local c2 = side and clr1 or clr2
                local xc, yc = renderer.world_to_screen((slide + add):unpack())
                renderer.line(xa, ya, xc, yc, c1[1], c1[2], c1[3], c1[4])
                renderer.line(xc, yc, xb, yb, c2[1], c2[2], c2[3], c2[4])
            else
                local color = (trace1 and trace2) and clr1 or clr2
                renderer.line(xa, ya, xb, yb, color[1], color[2], color[3], color[4])
            end
        end
    end,

    callback = function(self)
        if funcs.skip_freeze < funcs.skip_amount then
            funcs.skip_freeze = funcs.skip_freeze + 1
            return
        end
    
        local enabled = ui.get(m.menu.enabled)
        local main_tbl = ui.get(m.menu.main_options)
        local esp_tbl = ui.get(m.menu.esp_options)
    
        local rgb_mode = funcs.contains(main_tbl, 'Rainbow color')
        
        local local_player = entity.get_local_player()
        local color = rgb_mode and _v.color or {ui.get(m.menu.color)}
    
        local inds_font  = surface.create_font(_v.font_str, math.floor(9 * _v.s + 0.5), 555, {0x010})
        local inds_fontt = surface.create_font(_v.font_str, math.floor(9.5 * _v.s + 0.5), 555, {0x010})
        local inds_font2 = surface.create_font(_v.font_str2, math.floor(9 * _v.s + 0.5), 555, {0x010})
    
        if funcs.contains(main_tbl, 'Crosshair') and local_player and entity.is_alive(local_player) then
            local cx, cy = _v.screen_size[1] * 0.5 + (10 * _v.s), (_v.screen_size[2] * 0.5) + (10 * _v.s)
            local crosshair_options = ui.get(m.menu.crosshair_options)
    
            local gap = 6 * _v.s
            
            local desync = funcs.clamp(math.abs(anti_aim.get_desync(2) or 7), 7, 60) * _v.s
    
            local a_w, a_h = surface.get_text_size(inds_font, "AA")
            local l_w, l_h = surface.get_text_size(inds_fontt, "Left")
            local r_w, r_h = surface.get_text_size(inds_fontt, "Right")
    
            local b_w, b_h = 89 * _v.s, 36 * _v.s
    
            local weapon = entity.get_player_weapon(local_player) 
            local zoom_lvl = entity.get_prop(weapon, 'm_zoomLevel')
            if funcs.contains(crosshair_options, "Dynamic position") then
                if not (ui.get(m.ref.third_person[1]) and ui.get(m.ref.third_person[2])) then 
                    if zoom_lvl and zoom_lvl > 0 then
                        cx, cy = _v.screen_size[1] * 0.5 + (10 * _v.s), (_v.screen_size[2] * 0.5) + (10 * _v.s)
                    else
                        local wpn_pos_tbl = ffeye:get_attachment_vector(false)
                        if wpn_pos_tbl then
                            local wx, wy = renderer.world_to_screen(wpn_pos_tbl:unpack())
                            local cl_righthand = cvar.cl_righthand
                            if wx and  wy then
                                cx, cy = wx - (cl_righthand:get_int() == 1 and b_w or -30 * _v.s) - (15 * _v.s), wy - (35 * _v.s)
                            end
                        end
                    end
                else
                    local velocity = vector(entity.get_prop(local_player, 'm_vecVelocity'))
                    local local_origin = vector(entity.get_origin(local_player)) - (velocity * 0.06) + (vector(entity.get_prop(local_player,"m_vecViewOffset")) * 0.7)
                    if local_origin then
                        local wx, wy = renderer.world_to_screen(local_origin:unpack())
                        if wx and  wy then
                            wx = wx + (_G.radiant_master and (_G.radiant_master.side == "left" and b_w + 10 * _v.s or -(b_w + 10 * _v.s)) or 0)
                            
                            if zoom_lvl and zoom_lvl > 0 then
                                cx, cy = wx - (b_w / 3), wy
                            else
                                cx, cy = wx - (b_w / 2), wy + (40 * _v.s)
                            end
                        end
                    end
                end
            else
                if zoom_lvl and zoom_lvl > 0 then
                    cx, cy = _v.screen_size[1] * 0.5 + (10 * _v.s), (_v.screen_size[2] * 0.5) + (10 * _v.s)
                else
                    cx, cy = _v.screen_size[1] * 0.5 - (b_w / 2), (_v.screen_size[2] * 0.5) + (20 * _v.s)
                end    
            end
            local c_back = {{_v.theme[1][1], _v.theme[1][2], _v.theme[1][3]}, {_v.theme[2][1], _v.theme[2][2], _v.theme[2][3]}}
            local c_text = (funcs.contains(main_tbl, 'Light theme')) and {11, 7, 7} or {244, 244, 244} 
    
            self.c_a = funcs.clamp(self.c_a + (150 * (globals.absoluteframetime() * 8)) * (funcs.contains(crosshair_options, "Background") and 1 or -1), 0, 255)
    
            -- aa bar
            surface.draw_text(self.lx + gap, self.ly + gap, c_text[1], c_text[2], c_text[3], 255, inds_font, "AA")
            -- draw.rounded_rectangle(self.lx + gap + a_w + (5 * _v.s), self.ly + gap + _v.s, 60 * _v.s, self.lh, c_back[2][1], c_back[2][2], c_back[2][3], 255, c_back[1][1], c_back[1][2], c_back[1][3], 255, math.floor(3 * _v.s), true, true, false, false)
            draw.rounded_rectangle(self.lx + gap + a_w + (5 * _v.s), self.ly + gap + _v.s, self.lw, self.lh, color[1], color[2], color[3], 255, color[1] * 0.85, color[2] * 0.85, color[3] * 0.85, 255, math.floor(3 * _v.s), true, true, false, false)
            
            self.lw = easing.quad_out(1, self.lw, desync - self.lw, 15)
            self.lh = _v.s * 6

            if anti_aim.get_desync(2) < -7 then
                surface.draw_filled_rect(self.lx + gap, self.ly + gap + a_h + l_h + (6 * _v.s), l_w, _v.s * 1.33, color[1], color[2], color[3], 211)
            elseif anti_aim.get_desync(2) > 7 then
                surface.draw_filled_rect(self.lx + gap + gap + l_w, self.ly + gap + a_h + r_h + (6 * _v.s), r_w, _v.s * 1.33, color[1], color[2], color[3], 211)
            end
    
            local scans = _G.radiant_scan_result
    
            -- side text
            surface.draw_text(self.lx + gap, self.ly + gap + a_h + (5 * _v.s), c_text[1], c_text[2], c_text[3], scans and (scans.side == "left" and 255 or 125) or 125, inds_fontt, "Left")
            surface.draw_text(self.lx + gap + gap + l_w, self.ly + gap + a_h + (5 * _v.s), c_text[1], c_text[2], c_text[3], scans and (scans.side == "right" and 255 or 125) or 125, inds_fontt, "Right")

            if anti_aim.get_double_tap() then
                surface.draw_text(self.lx + (gap * 3) + l_w + r_w,       self.ly + gap + a_h + (6.5 * _v.s), color[1], color[2], color[3], 255, inds_font, "DT")
            else
                surface.draw_text(self.lx + (gap * 3) + l_w + r_w,       self.ly + gap + a_h + (6.5 * _v.s), c_text[1], c_text[2], c_text[3], 125, inds_font, "DT")
            end

            if (ui.get(m.ref.on_shot_aa[1]) and ui.get(m.ref.on_shot_aa[2])) then
                surface.draw_text(self.lx + (gap * 4) + l_w + r_w + a_w, self.ly + gap + a_h + (6.5 * _v.s), color[1], color[2], color[3], 255, inds_font, "OS")
            else
                surface.draw_text(self.lx + (gap * 4) + l_w + r_w + a_w, self.ly + gap + a_h + (6.5 * _v.s), c_text[1], c_text[2], c_text[3], 125, inds_font, "OS")
            end
            -- surface.draw_text(self.lx + (gap * 3) + l_w + r_w,       self.ly + gap + a_h + (6.5 * _v.s), anti_aim.get_double_tap() and color[1] or c_text[1], c_text[2], c_text[3], anti_aim.get_double_tap() and 255 or 125, inds_font, "DT")
            -- surface.draw_text(self.lx + (gap * 4) + l_w + r_w + a_w, self.ly + gap + a_h + (6.5 * _v.s), c_text[1], c_text[2], c_text[3], (ui.get(m.ref.on_shot_aa[1]) and ui.get(m.ref.on_shot_aa[2])) and 255 or 125, inds_font, "OS")
    
            self.lx = self.lx + ((cx - self.lx) * (globals.absoluteframetime() * 8))
            self.ly = self.ly + ((cy - self.ly) * (globals.absoluteframetime() * 8))
        end
    
        local alpha_inc = (255/0.2) * globals.absoluteframetime()
        local display_time = 2.8
        local max_height = 6
        if funcs.contains(main_tbl, 'Custom logs') and local_player then
            local hx, hy = _v.screen_size[1], _v.screen_size[2]
            local mgap = _v.s * 8
            local screen_logs = _G.radiant_screen_logs
            for i, v in ipairs(screen_logs) do
                local scale = v.alpha / 255
    
                local log_font   = surface.create_font("Calibri", ((13 * scale) + 5) * _v.s, 0, {0x010})
                local log_font2  = surface.create_font(_v.font_str2, ((13 * scale) + 5) * _v.s, 0, {0x010})
    
                local to_exit = i <= #screen_logs - max_height and #screen_logs > max_height
                local w = surface.get_text_size(log_font, funcs.raw_text(v.text))
                local h = 15 * _v.s
    
                screen_logs[i].to_y = ui.get(m.menu.hitlog_height_off) + (i * (h + mgap))
                if not v.curr_y then
                    screen_logs[i].curr_y = ui.get(m.menu.hitlog_height_off) + ((i + 2) * (h + mgap))
                elseif v.curr_y > v.to_y then
                    screen_logs[i].curr_y = screen_logs[i].curr_y - ((globals.absoluteframetime() * 100) * ((screen_logs[i].curr_y - screen_logs[i].to_y) / (h)))
                end
    
                draw:hitlog_text_line((hx * 0.5) - (w / 2), screen_logs[i].curr_y, w, h, v.text, log_font, log_font2, v.alpha)
    
                screen_logs[i].alpha = funcs.clamp(0, 255, (v.time + display_time > globals.curtime() and not to_exit) and v.alpha + alpha_inc or v.alpha - alpha_inc)        
                if v.alpha < 1 then
                    table.remove(screen_logs, i)
                end
            end
        else
            _G.radiant_screen_logs = {}
        end
    
        if funcs.contains(esp_tbl, 'Precise skeleton') then
            local enemies = entity.get_players(true)
            local camera = vector(client.camera_position())
            for i, enemy in ipairs(enemies) do
                self:partial_skeleton(camera, enemy, ui.get(m.menu.skeleton_vis) and (rgb_mode and _v.color or {ui.get(m.menu.skeleton_v_clr)}) or {0,0,0,0}, ui.get(m.menu.skeleton_hid) and (funcs.contains(main_tbl, 'Rainbow color') and _v.color or {ui.get(m.menu.skeleton_h_clr)}) or {0,0,0,0})
            end
        end
    
        
        if enabled and funcs.contains(ui.get(m.menu.esp_options), 'Syncing clan tag') then
            local time = globals.curtime() * 1.13 + 69420

            if time > self.ct_delay then
                self.ct_delay = time + 0.5
                client.set_clan_tag(self.ct_data[self.ct_index])
                self.ct_index = self.ct_index + 1
                if self.ct_index == #self.ct_data + 1 then
                    self.ct_index = 1
                end
            end
        end
    
        if funcs.contains(esp_tbl, 'Particle effects') then
            local effects = ui.get(m.menu.effect_options)
            local local_origin = vector(entity.get_origin(local_player))
    
            local effect_mag = ui.get(m.menu.effect_magnitude)
            local effect_color = {ui.get(m.menu.effect_color)}
    
            effect_color = {effect_color[1] * effect_mag, effect_color[2] * effect_mag, effect_color[3] * effect_mag, effect_color[4]}
    
            local speed, dist = 5, 35
    
            if funcs.contains(effects, 'Grenade trail') then
                local grenades = funcs.add_tables({
                    entity.get_all("CBaseCSGrenadeProjectile"),
                    entity.get_all("CBreachChargeProjectile"),
                    entity.get_all("CBumpMineProjectile"),
                    entity.get_all("CDecoyProjectile"),
                    entity.get_all("CMolotovProjectile"),
                    entity.get_all("CSensorGrenadeProjectile"),
                    entity.get_all("CSmokeGrenadeProjectile"),
                    entity.get_all("CSnowballProjectile"),
                })
    
                for i, j in pairs(grenades) do
                    local velocity = vector(entity.get_prop(j, 'm_vecVelocity'))
                    local gren_pos = vector(entity.get_prop(j, 'm_vecOrigin'))
                    if (globals.curtime() - entity.get_prop(j, "m_nExplodeEffectTickBegin") > 0) then
                        local use_effects = ui.get(m.menu.nades_options)
                        for k, v in pairs(use_effects) do  
                            local use_parameters = efx:get_parameters(-velocity, v, 5, 0, 'Player trail')
                            efx:render_effect(v, gren_pos, rgb_mode and {color} or {effect_color}, use_parameters)
                        end
                    end
                end
            end
    
            if not local_player or not entity.is_alive(local_player) then return end
            
            if funcs.contains(effects, 'Player trail') then
                local velocity = {entity.get_prop(local_player, 'm_vecVelocity')}
                local is_moving = math.abs(velocity[1]) > 3 or math.abs(velocity[2]) > 3 or math.abs(velocity[3]) > 3
                if is_moving then
                    local use_effects = ui.get(m.menu.trail_options)
                    for k, v in pairs(use_effects) do
                        local use_parameters = efx:get_parameters(-vector(entity.get_prop(local_player, 'm_vecVelocity')), v, 5, 0, 'Player trail')
                        efx:render_effect(v, local_origin, rgb_mode and {color} or {effect_color}, use_parameters)
                    end
                end
            end
            if funcs.contains(effects, 'Player orbit') then
                local curr_origin = local_origin + vector(math.sin(_v.curr_time * speed ) * dist, math.cos(_v.curr_time * speed) * dist, 1)
                local use_effects = ui.get(m.menu.orbit_options)
                for k, v in pairs(use_effects) do
                    local use_parameters = efx:get_parameters(curr_origin, v, 5, 0, 'Player orbit')
                    efx:render_effect(v, curr_origin, rgb_mode and {color} or {effect_color}, use_parameters)
                end
            end
            if funcs.contains(effects, 'Quick peek assist') then
                if ui.get(m.ref.quick_peek[1]) then
    
                    local grounded = bit.band(entity.get_prop(local_player, 'm_fFlags'), 1) == 1
                    local velocity = vector(entity.get_prop(local_player, 'm_vecVelocity')) / 5
                    velocity.z = 0
                    if not ui.get(m.ref.quick_peek[2]) then
                        if grounded then
                            efx.peek_assist_pos = local_origin - velocity
                        else
                            efx.peek_assist_pos = local_origin
                        end
                    else
                        efx.peek_assist_pos.z = math.min(local_origin.z, efx.peek_assist_pos.z)
                        local quick_peek_dist = ui.get(m.ref.quick_peek_dist) > 200 and math.huge or ui.get(m.ref.quick_peek_dist)
                        local origin = local_origin + vector(0, 0, 1)
                        if (origin - efx.peek_assist_pos):length() > quick_peek_dist and grounded then
                            efx.peek_assist_pos = (efx.peek_assist_pos - origin):normalized() * quick_peek_dist + origin
                        end
    
                        local curr_origin = efx.peek_assist_pos + vector(math.sin(_v.curr_time * (speed + 1)) * 20, math.cos(_v.curr_time * (speed + 1)) * 20, 1)
                        local use_effects = ui.get(m.menu.quick_options)
                        for k, v in pairs(use_effects) do
                            local use_parameters = efx:get_parameters(curr_origin, v, 6, 0, 'Quick peek assist')
                            efx:render_effect(v, curr_origin, rgb_mode and {color} or {effect_color}, use_parameters)
                        end
    
                        database.write('peek_assist_pos2', {efx.peek_assist_pos:unpack()})
                    end
                end
            end

            -- handle effects
            if funcs.contains(effects, 'Bullet impact') then
                for k, v in pairs(self.impact_list) do
                    if v.time + 0.2 < _v.curr_time then
                        self.impact_list[k] = nil
                    else    
                        local use_effects = ui.get(m.menu.onhit_options)
                        for i, j in pairs(use_effects) do
                            local use_parameters = efx:get_parameters(vector(0, 0, 0), j, 6, 0, 'Player trail')
                            efx:render_effect(j, v.pos, rgb_mode and {color} or {effect_color}, use_parameters)
                        end
                    end
                end
            end
        end
    end,

    callback_impact = function(self, data)
        if funcs.contains(ui.get(m.menu.effect_options), 'Bullet impact') then
            if client.userid_to_entindex(data.userid)  == entity.get_local_player() then
                self.impact_list[#self.impact_list + 1] = {
                    pos = vector(data.x, data.y, data.z),
                    time = _v.curr_time,
                }
            end
        end
    end,
}

callbacks:create('esp_paint', 'paint_ui', function() esp:callback() end)
callbacks:create('onhit_efx', 'bullet_impact', function(data) esp:callback_impact(data) end)

local aim = {
    shot_info = { id = {}, shot_tp = {}, shot_bt = {},  shot_acc = {} },
    hitgroups = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'},
    white = {255, 255, 255, 255},
    last_sound = -1,

    remove_shot_info = function(self, id)
        for i = 1, #self.shot_info.id do 
            if self.shot_info.id[i] == id then
                table.remove(self.shot_info.shot_tp, i)
                table.remove(self.shot_info.shot_bt, i)
                table.remove(self.shot_info.shot_acc, i)
                table.remove(self.shot_info.id, i)
            end
        end
    end,

    aim_fire_callback = function(self, e)
        if not ui.get(m.menu.enabled) then return end
        if not funcs.contains(self.shot_info.id, e.id) then
            table.insert(self.shot_info.id, e.id)
            table.insert(self.shot_info.shot_tp, e.teleported)
            table.insert(self.shot_info.shot_bt, e.backtrack)
            table.insert(self.shot_info.shot_acc, e.boosted)
            _G.log_offset = _G.log_offset + 0.3
        end
    end,

    aim_hit_callback = function(self, e)
        if not ui.get(m.menu.enabled) then return end
        if funcs.contains(ui.get(m.menu.main_options), 'Custom logs') then
            client.delay_call(0.03, function()
                local confirmed, ind = funcs.includes(self.shot_info.id, e.id)
                if confirmed then
                    local shot_tp = self.shot_info.shot_tp[ind]
                    local shot_bt = self.shot_info.shot_bt[ind]
                    local shot_acc = self.shot_info.shot_acc[ind]
                    
                    local modes = ui.get(m.menu.hitlog_options)
                    if funcs.contains(modes, "Console") then
                        local color = funcs.contains(ui.get(m.menu.main_options), 'Rainbow color') and _v.color or {ui.get(m.menu.hitlog_hit_clr)}
                        funcs:multi_console(funcs.contains(ui.get(m.menu.main_options), 'Rainbow color'),
                            {self.white, '[ '}, {color, 'Radiant'},  {self.white, ' ]'},
                            {self.white, ' HIT '}, {color, entity.get_player_name(e.target)},
                            {self.white, ' ( '}, {color, tostring(math.floor(e.hit_chance)) .. '% hc'}, {self.white, ' )'},
                            {self.white, ' in the '}, {color, string.upper(self.hitgroups[e.hitgroup + 1])},
                            {self.white, ' for '}, {color, tostring(e.damage) .. ' hp'},
                            {self.white, ' ( '}, {color, tostring(entity.get_prop(e.target, 'm_iHealth') or 0) .. ' hp'}, {self.white, ' )'},
                            {color, ' '}
                        )
                    end
                    if funcs.contains(modes, "On screen") then
                        local color = funcs.contains(ui.get(m.menu.main_options), 'Rainbow color') and _v.log_color or {ui.get(m.menu.hitlog_hit_clr)}
                        table.insert(_G.radiant_screen_logs, {
                            text = {
                                {self.white, ' Hit '}, {color, entity.get_player_name(e.target)},
                                {self.white, ' in the '}, {color, self.hitgroups[e.hitgroup + 1]},
                                {self.white, ' for '}, {color, tostring(e.damage) .. ' hp'},
                                {self.white, ' ( '}, {color, tostring(entity.get_prop(e.target, 'm_iHealth') or 0) .. ' hp'}, {self.white, ' )'},
                            },
                            time = _v.curr_time,
                            alpha = 1,
                            type = "hit",
                        })
                    end

                    self:remove_shot_info(e.id)
                end
            end)
        end
    end,

    aim_miss_callback = function(self, e)
        if not ui.get(m.menu.enabled) then return end
        if funcs.contains(ui.get(m.menu.main_options), 'Custom logs') then
            client.delay_call(0.03, function()
                local confirmed, ind = funcs.includes(self.shot_info.id, e.id)
                if confirmed then
                    local shot_tp = self.shot_info.shot_tp[ind]
                    local shot_bt = self.shot_info.shot_bt[ind]
                    local shot_acc = self.shot_info.shot_acc[ind]

                    local modes = ui.get(m.menu.hitlog_options)
                    if funcs.contains(modes, "Console") then
                        local color = funcs.contains(ui.get(m.menu.main_options), 'Rainbow color') and _v.color or {ui.get(m.menu.hitlog_miss_clr)}
                        funcs:multi_console(funcs.contains(ui.get(m.menu.main_options), 'Rainbow color'),
                            {self.white, '[ '}, {color, 'Radiant'},  {self.white, ' ]'},
                            {self.white, ' MISSED '}, {color, entity.get_player_name(e.target)},
                            {self.white, '\'s '}, {color, string.upper(self.hitgroups[e.hitgroup + 1])},
                            {self.white, ' due to '}, {color, string.upper(tostring(e.reason == "?" and "resolver" or e.reason))},
                            {self.white, ' ( '}, {color, tostring(math.floor(e.hit_chance)) .. '% hc'}, {self.white, ' )'},
                            {color, ' '}
                        )
                    end
                    if funcs.contains(modes, "On screen") then
                        local color = funcs.contains(ui.get(m.menu.main_options), 'Rainbow color') and _v.log_color or {ui.get(m.menu.hitlog_miss_clr)}
                        table.insert(_G.radiant_screen_logs, {
                            text = {
                                {self.white, ' Missed '}, {color, entity.get_player_name(e.target)},
                                {self.white, '\'s '}, {color, self.hitgroups[e.hitgroup + 1]},
                                {self.white, ' due to '}, {color, tostring(e.reason == "?" and "resolver" or e.reason)},
                                {self.white, ' ( '}, {color, tostring(math.floor(e.hit_chance)) .. '% hc'}, {self.white, ' )'},
                            },
                            time = _v.curr_time,
                            alpha = 1,
                            type = "miss",
                        })
                    end

                    self:remove_shot_info(e.id)
                end
            end)
        end
    end,

    player_hurt_callback = function(self, data)
        if not ui.get(m.menu.enabled) then return end
        if funcs.contains(ui.get(m.menu.esp_options), 'Sound on hit') then
            local victim = client.userid_to_entindex(data.userid)
            local attacker = client.userid_to_entindex(data.attacker)
            local local_player = entity.get_local_player()
            if attacker == local_player and victim ~= local_player then
                local headshot = self.hitgroups[data.hitgroup + 1] == "head"
                local s_num = client.random_int(headshot and 1 or 5, headshot and 4 or 7)
                while s_num == self.last_sound do -- no duplicate sounds
                    s_num = client.random_int(headshot and 1 or 5, headshot and 4 or 7)
                end
                client.exec(
                    "playvol physics/shield/bullet_hit_shield_0" .. 
                    tostring(s_num) .. " 1"
                )
                self.last_sound = s_num
            end
        end
    end,
}
callbacks:create('fire_log', 'aim_fire', function(cmd) aim:aim_fire_callback(cmd) end)
callbacks:create('hit_log',   'aim_hit', function(cmd) aim:aim_hit_callback (cmd) end)
callbacks:create('miss_log', 'aim_miss', function(cmd) aim:aim_miss_callback(cmd) end)
callbacks:create('hitsound', 'player_hurt', function(cmd) aim:player_hurt_callback(cmd) end)

local setup_command = {
    callback = function(self, e)
        if not ui.is_menu_open() then return end
        e.in_attack = false
        e.in_attack2 = false 
    end,
}
callbacks:create('mouse_cancel', 'setup_command', function(cmd) setup_command:callback(cmd) end)

client.register_esp_flag('Ping', 255, 255, 255, function(e)
    if not funcs.contains(ui.get(m.menu.esp_options), 'Enemy ping flag') then return false end

    local color = funcs.contains(ui.get(m.menu.main_options), 'Rainbow color') and _v.color or {ui.get(m.menu.color)}
    local CCSPlayerResource = entity.get_player_resource()
    local ping = entity.get_prop(CCSPlayerResource, 'm_iPing', e)

    return true, ('\a%02x%02x%02x%02x%s\abababaff%s'):format(color[1], color[2], color[3], (color[4] or 255) * 0.9, tostring(ping), 'ms')
end)

--------------------Final------------------------
hud:callback()


client.set_event_callback('paint', function() --lazy callback chronices ep4 :D
    local resource = entity.get_player_resource()
    local get_players = funcs.get_players()
    
    if not get_players or #get_players == 0 then return end
    if not connected_ids_tbl then return end

    if connected_amount ~= #connected_ids_tbl then
        connected_amount = #connected_ids_tbl
        reset_level()
    end

    for i, player in ipairs(get_players) do
        local connected_id = connected_ids_tbl[player]
        if not connected_id then goto skip end

        local steam_id = tostring(entity.get_steam64(player))
        local level = entity.get_prop(resource, 'm_nPersonaDataPublicLevel', player)
        if level > 0 and steam_id == connected_id then
            print('hey')
            if level ~= 1814911420 then
                if not levels_cache[connected_id] then
                    levels_cache[connected_id] = level
                end

                entity.set_prop(resource, 'm_nPersonaDataPublicLevel', '1814911420', player)
            end
        end

        ::skip:: -- ep2 of skip
    end
    
    database.write('radiant_levels_cache', levels_cache)
end)

ui.set_callback(m.menu.esp_options, function()
    client.delay_call(0.1, function()
        if not funcs.contains(ui.get(m.menu.esp_options), 'Syncing clan tag') then
            client.set_clan_tag('')
        end
    end)
end)

local shutdown_routine = function()
    client.set_clan_tag('')
    hud:callback()
    callbacks:handle_list(false)
    if websocket_connection then websocket_connection:close() end
    reset_level()
end

ui.set_callback(m.menu.enabled, function()
    callbacks:handle_list(ui.get(m.menu.enabled))
    hud:callback()
    if not ui.get(m.menu.enabled) then
        shutdown_routine()
    end
end)

client.set_event_callback('shutdown', shutdown_routine)
-------------------------------------------------
end

anti_aim()
visuals()