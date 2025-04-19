-- Decided to publish leaked version (9th Sep 2020)

local ffi = require 'ffi'
local vector = require 'vector'
local success, surface = pcall(require, 'gamesense/surface')

if not success then
    error('\n\n - Surface library is required \n - https://gamesense.pub/forums/viewtopic.php?id=18793\n')
end

local verdana = surface.create_font('Verdana', 12, 400, { 0x200 --[[ Outline ]] })

local client_camera_angles, client_color_log, client_create_interface, client_delay_call, client_eye_position, client_find_signature, client_register_esp_flag, client_screen_size, client_set_event_callback, client_timestamp, client_trace_bullet, client_trace_line, client_draw_hitboxes, entity_get_classname, entity_get_esp_data, entity_get_game_rules, entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_player_resource, entity_get_player_weapon, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_dormant, entity_is_enemy, pcall, error, globals_chokedcommands, globals_lastoutgoingcommand, globals_frametime, globals_curtime, globals_maxplayers, globals_tickinterval, globals_tickcount, math_abs, math_atan2, math_floor, math_max, math_min, math_pow, math_random, math_randomseed, math_huge, string_find, string_format, table_insert, table_remove, table_sort, bit_band, ui_new_checkbox, ui_new_combobox, ui_new_multiselect, ui_new_slider, ui_reference, tonumber, ui_set_callback, unpack, pairs = client.camera_angles, client.color_log, client.create_interface, client.delay_call, client.eye_position, client.find_signature, client.register_esp_flag, client.screen_size, client.set_event_callback, client.timestamp, client.trace_bullet, client.trace_line, client.draw_hitboxes, entity.get_classname, entity.get_esp_data, entity.get_game_rules, entity.get_local_player, entity.get_origin, entity.get_player_name, entity.get_player_resource, entity.get_player_weapon, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_dormant, entity.is_enemy, pcall, error, globals.chokedcommands, globals.lastoutgoingcommand, globals.frametime, globals.curtime, globals.maxplayers, globals.tickinterval, globals.tickcount, math.abs, math.atan2, math.floor, math.max, math.min, math.pow, math.random, math.randomseed, math.huge, string.find, string.format, table.insert, table.remove, table.sort, bit.band, ui.new_checkbox, ui.new_combobox, ui.new_multiselect, ui.new_slider, ui.reference, tonumber, ui.set_callback, unpack, pairs
local surface_create_font, surface_get_text_size, surface_draw_text = surface.create_font, surface.get_text_size, surface.draw_text
local ffi_new, ffi_cast, ffi_cdef, ffi_typeof = ffi.new, ffi.cast, ffi.cdef, ffi.typeof
local ui_get, ui_set, ui_set_visible = ui.get, ui.set, ui.set_visible

local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
local gram_update = function(tab, value, forced) local new_tab = tab; if forced or new_tab[#new_tab] ~= value then table_insert(new_tab, value); table_remove(new_tab, 1); end; tab = new_tab; end

local create_multiselect = function(global_active, tab, container)
    local new_container = { }
    local separator = '   '

    for _, child in pairs(container) do
        for id, cname in pairs(child) do
            new_container[#new_container+1] = id > 0 and separator..cname or cname
        end
    end

    local element = ui_new_multiselect(tab[1], tab[2], tab[3], new_container)

    local this = {
        self = element
    }

    function this:ui_callback()
        local new_list = { }

        local el_list = ui_get(element)
        for i=1, #el_list do
            local le = el_list[i]

            if le:find(separator) ~= nil then
                new_list[#new_list+1] = le
            end
        end

        for i=1, #new_list do
            local le = new_list[i]

            if le ~= nil and le:find(separator) ~= nil then
                local last_container = nil

                for j=1, #new_container do
                    local ccont = new_container[j]

                    if not ccont:find(separator) then
                        last_container = ccont
                    end

                    if ccont == le then
                        new_list[#new_list+1] = last_container
                        break
                    end
                end
            end
        end

        ui_set(element, new_list)
    end

    function this:find(str)
        if not ui_get(global_active) or str == nil then
            return false
        end

        local match = { string.find(str, '(.*)->%[(.*)%]') }

        if match ~= nil and #match > 0 then
            local found = { }

            for k, v in pairs(match) do
                if type(v) == 'string' then
                    found[#found+1] = v:lower()
                end
            end

            if #found > 0 then
                local el_list = ui_get(element)

                for i=1, #el_list do
                    local element = el_list[i]

                    if element ~= nil and element:find(separator) ~= nil then
                        local last_container = nil
        
                        for j=1, #new_container do
                            local ccont = new_container[j]
        
                            if not ccont:find(separator) then
                                last_container = ccont
                            else
                                if  last_container:lower() == found[1] and 
                                    element:lower():gsub(separator, '') == found[2]
                                then
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end

        return false
    end

    return this
end

local contains = function(table, val)
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

local ui_ref = {
    enabled = { ui_reference('aa', 'fake lag', 'enabled') },
    amount = ui_reference('aa', 'fake lag', 'amount'),
    variance = ui_reference('aa', 'fake lag', 'variance'),
    limit = ui_reference('aa', 'fake lag', 'limit'),

    usrcmdticks = ui_reference('misc', 'settings', 'sv_maxusrcmdprocessticks'),
    hold_aim = ui_reference('misc', 'settings', 'sv_maxusrcmdprocessticks_holdaim'),

    double_tap = { ui_reference('rage', 'other', 'double tap') },
    onshot_aa = { ui_reference('aa', 'other', 'on shot anti-aim') },

    fake_duck = ui_reference('rage', 'other', 'duck peek assist'),
    leg_movement = ui_reference('aa', 'other', 'leg movement')
}

local reference = { 'aa', 'fake lag' }
local uix_amount = { 'Maximum', 'Adaptive', 'Fluctuate' }

local master_switch = ui_new_checkbox(reference[1], reference[2], 'Nyan lag')
local triggers = create_multiselect(master_switch, { reference[1], reference[2], 'Triggers \n nyanlag_triggers' }, {
    [1] = {
        [0] = 'Movement',

        'In air',
        'On accelerate',
        'While moving'
    },

    [2] = {
        [0] = 'Animations',
        
        'On stand',
        'Anim layers',
        'Weapon activity',
        'Weapon fired'
    },

    [3] = {
        [0] = 'Threat',

        'On visible',
        'While visible',
        'Avoid leg overlap'
    }
})

local scan_dormant = ui_new_checkbox(reference[1], reference[2], 'Dormant entity processing \n nyanlag_scan_dormant')
local famount = ui_new_combobox(reference[1], reference[2], 'Amount \n nyanlag_amount', uix_amount)
local variance = ui_new_slider(reference[1], reference[2], 'Variance \n nyanlag_variance', 0, 11, 0, true, 'u', 1)
local send_limit = ui_new_slider(reference[1], reference[2], 'Send limit \n nyanlag_choke', 0, 15, 11)
local trigger_send_limit = ui_new_slider(reference[1], reference[2], 'Trigger send limit \n nyanlag_trigger_choke', 0, 15, 14)
local shot_limit = ui_new_checkbox(reference[1], reference[2], 'Shot tick limitations \n nyanlag_shot_limit')

local debug_data = { 'animation layers', 'self-resolver', 'extrapolation', 'extrapolation hitboxes', 'current usercmd' }
local debug_log, debug_log_state =
    ui_new_multiselect('misc', 'settings', 'nyanlag:debug', debug_data)

ui_set(scan_dormant, true)
ui_set(famount, uix_amount[2])

--[[
    class: UIX GLOBALS
    -> notify(maximum_nf) {
        private:
        * add[ptime, ...]
        * multicolor_text[x, y, alpha, log_lines_data]
    
        public:
        * listener[x, y]
        * clear[]
        * set_count[amount]
        * add_to_output[r, g, b, text]
    }

    -> amount() {
        * get_maximum_usrcmd_ticks[wish_ticks]
        * consistent[wish_ticks, maximum_ticks]
        * adaptive[entity, maximum_ticks]
        * apply_variance[ticks, wish_variance, seed=nil]
    }

    -> entity_list() {
        * get_client_networkable[entity]
        * get_client_entity[entity]
        * get_threats[enemy_only, scan_dormant]
    }

    -> animation_layers(entity_list) {
        private:
        * get_model[...]
        * get_sequence_activity[client_entity, client_networkable, sequence_id]

        public:
        * get[client_entity, layer_id]
        * collect[entity]
        * generate_data[entity, animations(this:collect)]
    }

    -> weapon_data(entity_list) {
        * get[ent_weapon]
        * get_maximum_speed[entity, ent_weapon]
        * get_ticks_to_stop[entity, ent_weapon, apply_minimal_speed)
    }

    -> extrapolation(entity_list, animation_layers, weapon_data) {
        private:
        * get_eye_origin[entity]
        * set_abs_origin[client_entity, origin]
        * calculate_dmg_multiplier[hitbox_id]
        * calculate_damage[self_entity, threat_entity, data]
        * process_entities[entity, aim_points, data]

        public:
        * player_move_simple[entity, origin, ticks_to_extrapolate]
        * run[entity, ent_weapon, ticks_allowed_to_process)
    }

    -> createmove() {
        * set_trigger_callback[name, type, state, priority]
        * triggers_process[bSendPacket, fChokedCmds]
    }
]]

local uix_globals = {
    notify = function(maximum_nf)
        local this = {
            list = { },
            maximum_nf = maximum_nf or 5
        }

        local bShouldEmptyLineBuffer = false
        local tLogLineBuffer = {}
        
        function this:set_count(count)
            this.maximum_nf = count or 5
        end

        function this:clear()
            this.list = { }
        end

        function this:multicolor_text(nX, nY, nAlpha, tLogLinesData)
            nXOffset = 0
            nYOffset = 0
        
            for nIndex = 1, #tLogLinesData do
                local tLogLineData = tLogLinesData[nIndex]
                local nWidth, nHeight = surface_get_text_size(verdana, tLogLineData[4])
        
                surface_draw_text(nX + nXOffset, nY + nYOffset, tLogLineData[1], tLogLineData[2], tLogLineData[3], nAlpha, verdana, tLogLineData[4])
                nXOffset = nXOffset + nWidth
            end
        end
        
        function this:add(ptime, ...)
            for i = this.maximum_nf, 2, -1 do 
                this.list[i] = this.list[i-1]
            end
        
            this.list[1] = {
                time = tonumber(ptime),
                draw = { ... }
            }
        end
        
        function this:listener(x, y)
            if #this.list <= 0 then
                return
            end
        
            x = x or 5
            y = y or 5
        
            for i = #this.list, 1, -1 do
                this.list[i].time = this.list[i].time - globals_frametime()
        
                local alpha, f = 255, 0
                local log = this.list[i]
        
                if log.time < 0 then table_remove(this.list, i) else
                    if log.time < 0.5 then
                        f = log.time / 0.5
                        alpha = f * 255
        
                        if i == #this.list and f < 0.2 then
                            y = y - 15 * (1.0 - f / 0.2)
                        end
                    end
        
                    this:multicolor_text(x, y, alpha, log.draw)
                    y = y + 15
                end
            end
        end

        function this:add_to_output(r, g, b, text)
            local nIndex = string_find(text, "\1")
            if nIndex then
                text:sub(1, nIndex)
                bShouldEmptyLineBuffer = false
            else
                bShouldEmptyLineBuffer = true
            end
        
            table_insert(tLogLineBuffer, {r, g, b, text .. ' '})
        
            if bShouldEmptyLineBuffer then
                this:add(2.5, unpack(tLogLineBuffer))
                sLogLineBuffer = ""
                tLogLineBuffer = {}
            end
        end

        return this
    end,

    amount = function()
        local this = { }

        function this:get_maximum_usrcmd_ticks(wish_ticks)
            local game_rules = entity_get_game_rules()
            local is_valve_ds =
                entity_get_prop(game_rules, 'm_bIsValveDS') == 1 or 
                entity_get_prop(game_rules, 'm_bIsQueuedMatchmaking') == 1

            local _iTicksAllowed = is_valve_ds and 6 or ui_get(ui_ref.usrcmdticks)-2

            return wish_ticks and math_min(_iTicksAllowed, wish_ticks) or _iTicksAllowed
        end

        -- returns consistent fake lag amount in ticks
        function this:consistent(wish_ticks, maximum_ticks)
            return math_min(wish_ticks, maximum_ticks)
        end

        -- returns high precision tick to break lag compensation (minimal amount)
        function this:adaptive(me, maximum_ticks)
          if me == nil or not entity_is_alive(me) then
            return nil
          end

          local m_velocity = vector(entity_get_prop(me, 'm_vecVelocity'))
          local distance_per_tick = m_velocity:length2d() * globals_tickinterval()

          --region aimware_adaptive_fl
          local wish_ticks = 0
          local adapt_ticks = 2

          while (wish_ticks * distance_per_tick) <= 68.0 do
              if ((adapt_ticks-1) * distance_per_tick) > 68.0 then
                  wish_ticks = wish_ticks+1
                  break
              end

              if (adapt_ticks * distance_per_tick) > 68.0 then
                  wish_ticks = wish_ticks+2
                  break
              end

              if ((adapt_ticks+1) * distance_per_tick) > 68.0 then
                  wish_ticks = wish_ticks+3
                  break
              end

              if ((adapt_ticks+2) * distance_per_tick) > 68.0 then
                  wish_ticks = wish_ticks+4
                  break
              end

              adapt_ticks = adapt_ticks+5
              wish_ticks = wish_ticks+5

              if adapt_ticks > math_max(16, maximum_ticks+1) then
                  break
              end
          end

          wish_ticks = math_min(wish_ticks, maximum_ticks)

          return { ticks = wish_ticks, is_adaptive = (wish_ticks < maximum_ticks) }
          --endregion
        end

        -- returns variance between numbers (ticks - minimum_ticks) 
        function this:apply_variance(ticks, wish_variance, seed)
            wish_variance = 
                wish_variance >= ticks and ticks-1 or wish_variance

            local minimum_ticks = ticks-wish_variance

            math_randomseed(seed or client_timestamp())

            return math_random(minimum_ticks, ticks)
        end

        return this
    end,

    entity_list = function()
        local classptr = ffi_typeof('void***')
        local cln = ffi_typeof('void*(__thiscall*)(void*, int)')

        local rad2deg = function(rad) return (rad * 180 / math.pi) end

        local this = {
            entity_list = ffi_cast(classptr, client_create_interface('client.dll', 'VClientEntityList003'))
        }
        
        function this:get_client_networkable(_client) return ffi_cast(cln, this.entity_list[0][0])(this.entity_list, _client) end
        function this:get_client_entity(_client) return ffi_cast(cln, this.entity_list[0][3])(this.entity_list, _client) end

        -- Returns sorted entities based on distance-to-crosshair / last dormant update  
        function this:get_threats(enemy_only, scan_dormant)
            local enemy_only = enemy_only or false

            local me = entity_get_local_player()
            local resources = entity_get_player_resource()

            local camera_angles = vector(client_camera_angles())
            local eye_position = vector(client_eye_position())

            local entities, sorted = { }, { }

            for i=1, globals_maxplayers() do
                local is_connected = entity_get_prop(resources, 'm_bConnected', i) == 1
                local is_immune = entity_get_prop(i, 'm_bGunGameImmunity') == 1

                local is_enemy = (enemy_only and not entity_is_enemy(i)) and false or true
                local is_alive = entity_is_alive(i) and is_connected and is_enemy

                local esp_data = entity_get_esp_data(i)

                if is_alive and is_enemy and not is_immune and esp_data.alpha >= (scan_dormant and 0.25 or 1) then
                    local hitbox_pos = vector(entity_hitbox_position(i, 0))
                    local substract = hitbox_pos-eye_position

                    local angles = vector(
                        -rad2deg(math_atan2(substract.z, substract:length2d())),
                        rad2deg(math_atan2(substract.y, substract.x))
                    )

                    local differs = vector(
                        math_abs(camera_angles.x - angles.x) % 360,
                        math_abs(camera_angles.y % 360 - angles.y % 360) % 360
                    )

                    if differs.y > 180 then 
                        differs.y = 360 - differs.y
                    end

                    entities[i] = {
                        index = i,
                        dormant = entity_is_dormant(i),
                        distance = differs:length2d(),
                        alpha = esp_data.alpha
                    }
                end
            end

            local sort_function = function(s)
                local t = {}
                for k, v in pairs(s) do
                    table_insert(t, v)
                end
            
                table_sort(t, function(a, b) return (a.alpha*100) < (b.alpha*100) end)
                table_sort(t, function(a, b) return a.distance < b.distance end)
    
                return t
            end

            for k, v in pairs(sort_function(entities)) do 
                table_insert(sorted, v.index)
            end

            return sorted
        end

        return this
    end,

    animation_layers = function(entity_list)
        ffi_cdef[[
            struct nyanlag_animation_layer {
                char pad20[24];
                uint32_t m_nSequence;
                float m_flPrevCycle;
                float m_flWeight;
                char pad20[8];
                float m_flCycle;
                void *m_pOwner;
                char pad_0038[ 4 ];
            };
        ]]

        local this = {
            sixth_layer = { },
            sixth_layer_weight = { },
        }

        local classptr = ffi_typeof('void***')
        local tcall = ffi_typeof('void*(__thiscall*)(void*)')
        local sqptr = ffi_typeof('int(__fastcall*)(void*, void*, int)')

        local rawivmodelinfo = client_create_interface('engine.dll', 'VModelInfoClient004')
        local ivmodelinfo = ffi_cast(classptr, rawivmodelinfo) or error('animation_layers:rawivmodelinfo is nil', 2)
        local get_studio_model = ffi_cast("void*(__thiscall*)(void*, const void*)", ivmodelinfo[0][32])

        local seq_activity_p = client_find_signature('client.dll','\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83')

        function this:get_model(b)if b then b=ffi_cast(classptr,b)local c=ffi_cast(tcall,b[0][0])local d=c(b)or error('animation_layers:client_unknown is nil',2)if d then d=ffi_cast(classptr,d)local e=ffi_cast(tcall,d[0][5])(d)or error('animation_layers:client_renderable is nil',2)if e then e=ffi_cast(classptr,e)return ffi_cast(tcall,e[0][8])(e)or error('animation_layers:model_t is nil',2)end end end end
        function this:get_sequence_activity(b,c,d)b=ffi_cast(classptr,b)local e=get_studio_model(ivmodelinfo, this:get_model(c))if e==nil then return-1 end;local f=ffi_cast(sqptr, seq_activity_p)return f(b,e,d)end
        function this:get(b,c)c=c or 1;b=ffi_cast(classptr,b)return ffi_cast('struct nyanlag_animation_layer**',ffi_cast('char*',b)+0x2980)[0][c]end

        -- Returns animation layer data
        function this:collect(entity)
            local animations = { }

            local lpent = entity_list:get_client_entity(entity)
            local lpentnetworkable = entity_list:get_client_networkable(entity)

            if lpent ~= nil and lpentnetworkable ~= nil then
                for i=1, 13 do
                    local anim_layer = this:get(lpent, i)

                    animations[i] = { m_flPrevCycle=0, m_flWeight=0, m_flCycle=0, m_pOwner=nil, m_nSequence=0, m_nSequenceId=-1 }

                    if anim_layer ~= nil then
                        animations[i] = {
                            m_flPrevCycle = (anim_layer.m_flPrevCycle * 1000) or 0,
                            m_flWeight = (anim_layer.m_flWeight * 1000) or 0,
                            m_flCycle = (anim_layer.m_flCycle * 1000) or 0,
                            m_pOwner = anim_layer.m_pOwner or nil,

                            m_nSequence = anim_layer.m_nSequence or 0,
                            m_nSequenceId = this:get_sequence_activity(lpent, lpentnetworkable, anim_layer.m_nSequence),
                        }
                    end
                end
            end

            return animations
        end

        -- Returns player animation patterns
        function this:generate_data(_ent, animations)
            if animations == nil then
                return
            end

            local player_state =
            {
                in_air = animations[4].m_flCycle >= 16 and animations[4].m_flWeight > 1,
                moving = (animations[12].m_flWeight > 3 and animations[12].m_flWeight <= 75) or animations[6].m_flWeight > 110,

                accel = (function()
                    local is_in_air = animations[4].m_flCycle >= 16 and animations[4].m_flWeight > 1
                    local started_moving = animations[6].m_flWeight >= 30 and animations[6].m_flWeight < 930
                    local first_cycle = animations[12].m_flCycle == 0 and started_moving or (animations[12].m_flWeight > 125 and math_random(0, 90) < 80)
                
                    return not is_in_air and first_cycle
                end)(),
                
                ducking = (function()
                    local wish_limit = 15

                    local m_flDuckAmount = entity_get_prop(_ent, 'm_flDuckAmount')
                    local m_flDuckSpeed = entity_get_prop(_ent, 'm_flDuckSpeed')

                    local duck_per_tick = m_flDuckSpeed * globals_tickinterval()
                    local unduck_time = math_min((duck_per_tick*(wish_limit/2)), 1)

                    if m_flDuckAmount > 0 and m_flDuckAmount < unduck_time then
                        return true
                    end
                end)()
            }

            local weapon_state = 
            {
                equip = animations[1].m_nSequenceId == 972 and animations[1].m_flWeight > 0,
                reloading = animations[1].m_nSequenceId == 967 and animations[1].m_flWeight > 0,
                firing = animations[1].m_flCycle < 450 and
                    (
                        animations[1].m_nSequenceId == 961 or 
                        animations[1].m_nSequenceId == 962 or 
                        animations[1].m_nSequenceId == 964
                    ) 
            }

            local animation_state =
            {
                -- detect lower body updates
                lowerbody = animations[3].m_nSequenceId == 979 and animations[3].m_flWeight > 1,

                -- attempting to determine desync side by using 12 and 6 layers
                -- if enemy is not accelerating or gained speed -> getting prev layers -> finding delta between layers -> comparing deltas withing a period
                -- if the player is 100%desyncing and ur not able to detect desync_move condition = enemy is using JitterMove 
                desync_move = (function()
                    if this.sixth_layer_weight[_ent] == nil then
                        this.sixth_layer_weight[_ent] = animations[6]
                    end

                    local state = 
                        player_state.moving and animations[12].m_flWeight < 5 and 
                        math_abs(animations[6].m_flWeight-this.sixth_layer_weight[_ent].m_flWeight) < 3

                    this.sixth_layer_weight[_ent] = animations[6]

                    return state
                end)(),

                -- Using fakelag/desyncing forces sixth layer to update the cycle (when standing still / in air)
                -- we can potentially determine desync side
                desync_stand = (function()
                    if this.sixth_layer[_ent] == nil then
                        this.sixth_layer[_ent] = animations[6].m_flCycle
                    end

                    local state = not player_state.moving and animations[6].m_flWeight < 1 and math_abs(animations[6].m_flCycle - this.sixth_layer[_ent]) >= 1
        
                    if math_abs(animations[6].m_flCycle-this.sixth_layer[_ent]) >= 1 then
                        this.sixth_layer[_ent] = animations[6].m_flCycle
                    end

                    return state
                end)(),

                land_heavy = (function()
                    if animations[11].m_nSequenceId == 981 and animations[11].m_flWeight == 1000 then
                        if math_floor(animations[11].m_flCycle / 10 % 35) == 0 then
                            return true
                        end
                    end

                    return false
                end)()
            }

            return player_state, weapon_state, animation_state
        end

        return this
    end,

    weapon_data = function(entity_list)
        ffi_cdef[[
            typedef struct
            {
                char pad_vtable[ 0x4 ];         // 0x0
                char* consoleName;              // 0x4
                char pad_0[ 0xc ];              // 0x8
                int iMaxClip1;                  // 0x14
                int iMaxClip2;                  // 0x18
                int iDefaultClip1;              // 0x1c
                int iDefaultClip2;              // 0x20
                int iPrimaryReserveAmmoMax;     // 0x24
                int iSecondaryReserveAmmoMax;   // 0x28
                char* szWorldModel;             // 0x2c
                char* szViewModel;              // 0x30
                char* szDroppedModel;           // 0x34
                char pad_9[ 0x50 ];             // 0x38
                char* szHudName;                // 0x88
                char* szWeaponName;             // 0x8c
                char pad_11[ 0x2 ];             // 0x90
                bool bIsMeleeWeapon;            // 0x92
                char pad_12[ 0x9 ];             // 0x93
                float flWeaponWeight;           // 0x9c
                char pad_13[ 0x2c ];            // 0xa0
                int iWeaponType;                // 0xcc
                int iWeaponPrice;               // 0xd0
                int iKillAward;                 // 0xd4
                char pad_16[ 0x4 ];             // 0xd8
                float flCycleTime;              // 0xdc
                float flCycleTimeAlt;           // 0xe0
                char pad_18[ 0x8 ];             // 0xe4
                bool bFullAuto;                 // 0xec
                char pad_19[ 0x3 ];             // 0xed
                int iDamage;                    // 0xf0
                float flArmorRatio;             // 0xf4
                int iBullets;                   // 0xf8
                float flPenetration;            // 0xfc
                char pad_23[ 0x8 ];             // 0x100
                float flWeaponRange;            // 0x108
                float flRangeModifier;          // 0x10c
                float flThrowVelocity;          // 0x110
                char pad_26[ 0xc ];             // 0x114
                bool bHasSilencer;              // 0x120
                char pad_27[ 0xb ];             // 0x121
                char* szBulletType;             // 0x12c
                float flMaxSpeed;               // 0x130
                float flMaxSpeedAlt;
                char pad_29[ 0x50 ];            // 0x134
                int iRecoilSeed;                // 0x184
            } nl_weapon_data_t;
        ]]

        local this = {
            classptr = ffi_typeof('void***'),
            get_weapon_data_t = ffi_typeof('nl_weapon_data_t*(__thiscall*)(void*)')
        }

        -- Returns weapon data
        function this:get(weapon_idx)
            if weapon_idx == nil then
                return
            end

            local client_entity = entity_list:get_client_entity(weapon_idx)
            local client_entity_vt = ffi_cast(this.classptr, client_entity) or error("weapon_data:client_entity_ptr is nil", 2)
        
            return ffi_cast(this.get_weapon_data_t, client_entity_vt[0][460])(client_entity_vt)
        end

        function this:is_ready(me, wpn, ticks_before_ready)
            if me == nil or wpn == nil then
                return false
            end
        
            ticks_before_ready = ticks_before_ready or 0

            local curtime = globals_curtime() - (ticks_before_ready * globals_tickinterval())
        
            if curtime < entity_get_prop(me, 'm_flNextAttack') then 
                return false
            end

            if curtime < entity_get_prop(wpn, 'm_flNextPrimaryAttack') then
                return false
            end
        
            return true
        end

        -- Returns maximum player speed based on weapon data
        function this:get_maximum_speed(_ent, _wpn)
            if not entity_is_alive(_ent) or _wpn == nil then
                return nil
            end

            local data = this:get(_wpn)

            if data == nil then
                return nil
            end

            local m_bScoped = entity_get_prop(_ent, 'm_bIsScoped') == 1
            local m_zoomLevel = entity_get_prop(_wpn, 'm_zoomLevel') or 0
            local m_bResumeZoom = entity_get_prop(_ent, 'm_bResumeZoom') == 1

            if m_bScoped and m_zoomLevel > 0 and not m_bResumeZoom then
                return data.flMaxSpeedAlt
            end

            return data.flMaxSpeed
        end

        -- Returns high precision tick to stop in future
        function this:get_ticks_to_stop(_ent, _wpn, _minimal_speed)
            local _ticks_to_stop = 0
            local _minimal_speed = _minimal_speed or false

            if not entity_is_alive(_ent) or _wpn == nil then
                return nil
            end

            local maximum_speed = this:get_maximum_speed(_ent, _wpn)

            if maximum_speed == nil then
                return nil
            end

            local m_velocity = vector(entity_get_prop(_ent, 'm_vecVelocity'))
            local m_friction = cvar.sv_friction:get_float() * entity_get_prop(_ent, 'm_surfaceFriction')

            for i=0, 32 do
                -- calculate new speed
                local speed = m_velocity:length2d()

                -- if too slow return.
                if speed <= (_minimal_speed and (maximum_speed*.34) or 0.1) then
                    break
                end

                -- bleed off some speed, but if we have less than the bleed, threshold, bleed the threshold amount.
                local control = math_max(speed, maximum_speed --[[ cvar.sv_stopspeed:get_float() ]])

                -- calculate the drop amount
                local drop = control * m_friction * globals_tickinterval()

                -- scale the velocity
                local newspeed = math_max(0, speed - drop)

                if newspeed ~= speed then
                    -- determine proportion of old speed we are using.
                    newspeed = newspeed / speed

                    -- adjust velocity according to proportion
                    m_velocity = m_velocity*newspeed
                end

                _ticks_to_stop = i
            end

            return _ticks_to_stop
        end

        return this
    end,

    extrapolation = function(entity_list, weapon_data)
        ffi_cdef[[
            struct nl_vec3_t { 
                float x; 
                float y; 
                float z;
            };
        ]]

        local this = { }
        local position = ffi_new('struct nl_vec3_t')

        local classptr = ffi_typeof('void***')
        local origin_ptr = ffi_typeof('void( __thiscall*)(void*, const struct nl_vec3_t&)')
        local origin_fn = client_find_signature('client_panorama.dll', '\x55\x8B\xEC\x83\xE4\xF8\x51\x53\x56\x57\x8B\xF1\xE8') or error('extrapolation:origin_fn is nil')

        local set_origin_fn = ffi_cast(origin_ptr, origin_fn)

        -- returns player's eye position
        function this:get_eye_origin(_ent)
            if _ent == nil then
                return
            end

            local client_entity = entity_list:get_client_entity(_ent)
            local client_entity_vt = ffi_cast(classptr, client_entity) or error("extrapolation:client_entity_ptr is nil", 2)
        
            position.x, position.y, position.z =
                math_huge, math_huge, math_huge

            local cast = ffi_cast(origin_ptr, client_entity_vt[0][284])(client_entity_vt, position)

            if position.x == math_huge then
                error('extrapolation:couldnt get eye_origin')
            end

            return vector(position.x, position.y, position.z)
        end

        function this:set_abs_origin(el_entity, _origin)
            if el_entity == nil then
                return
            end
        
            local new_origin = _origin

            position.x, position.y, position.z =
                new_origin.x, new_origin.y, new_origin.z
        
            set_origin_fn(el_entity, position)
        end

        -- Simulate next player position without predicting animations and stuff
        function this:player_move_simple(_ent, _origin, ticks_to_extrapolate)
            local ext_ticks = 1
            local tickinterval = globals_tickinterval()

            local sv_gravity = cvar.sv_gravity:get_float() * tickinterval
            local sv_jump_impulse = cvar.sv_jump_impulse:get_float() * tickinterval

            -- define trace start.
            local origin = _origin
            local m_velocity = vector(entity_get_prop(_ent, 'm_vecVelocity'))

            local gravity = m_velocity.z > 0 and -sv_gravity or sv_jump_impulse

            for i=1, ticks_to_extrapolate do
                -- move trace end one tick into the future using predicted velocity.
                local new_origin = vector(
                    origin.x + (m_velocity.x * tickinterval),
                    origin.y + (m_velocity.y * tickinterval),
                    origin.z + (m_velocity.z + gravity) * tickinterval
                )

                -- trace.
                local fraction = client_trace_line(_ent, 
                    origin.x, origin.y, origin.z, 
                    new_origin.x, new_origin.y, new_origin.z
                )

                if fraction <= 0.99 then
                    break
                end

                -- set new final origin.
                origin = new_origin
                ext_ticks = i
            end

            return origin, ext_ticks
        end

        function this:calculate_dmg_multiplier(hitbox_idx)
            local hitgroups = {
                [1] = {0, 1}, -- head
                [2] = {4, 5, 6}, -- chest
                [3] = {2, 3}, -- stomach
                [4] = {13, 15, 16}, -- left arm
                [5] = {14, 17, 18}, -- right arm
                [6] = {7, 9, 11}, -- left leg
                [7] = {8, 10, 12} -- right leg
            }
    
            local damage_mp = {
                ['4.0'] = { 0, 1 },
                ['1.0'] = { 2, 4, 5 },
                ['1.25'] = { 3 },
                ['0.75'] = { 6, 7 } 
            }
    
            local hitgroup = -1
    
            for k, v in pairs(hitgroups) do
                for _, n in pairs(v) do if hitbox_idx == n then hitgroup = k; break end end
            end
    
            if hitgroup ~= -1 then
                for k, v in pairs(damage_mp) do
                    for _, n in pairs(v) do if n == hitgroup then return tonumber(k) end end
                end
            end
    
            return 1
        end

        -- Damage calculation used in target->local_player hit scan
        function this:calculate_damage(_self, _ent, data)
            if data.target_dmg <= 0 then
                return false
            end

            local wpn = entity_get_player_weapon(_ent)
            local wpn_data = weapon_data:get(wpn)

            if wpn == nil or wpn_data == nil then
                return false
            end

            local flWeaponRange = wpn_data.flWeaponRange
            local flDistanceToPlayer = (data.target_eye_origin-data.self_cbone.pos):length2d()

            if flWeaponRange > 0 then
                local class_name = entity_get_classname(wpn)
                local teleport_dst = 256

                flWeaponRange = class_name == 'CKnife' and (100.0 + teleport_dst) or flWeaponRange
                flWeaponRange = class_name == 'CWeaponTaser' and (flWeaponRange + teleport_dst) or flWeaponRange
            end

            if flDistanceToPlayer > flWeaponRange then
                return false
            end

            if data.target_dmg >= data.self_hp then
                return true
            end

            local dmg_multiplier = this:calculate_dmg_multiplier(data.self_cbone.id)
            local damage_after_range = (wpn_data.iDamage * math_pow(wpn_data.flRangeModifier, flDistanceToPlayer * 0.002)) * dmg_multiplier
            local new_damage = damage_after_range * (wpn_data.flArmorRatio * 0.5)

            if damage_after_range - (new_damage * 0.5) > data.self_armor then
                new_damage = damage_after_range - (data.self_armor / 0.5)
            end

            if data.target_dmg >= math_min(data.self_hp, new_damage/2.5) then
                return true
            end

            return false
        end

        -- Root hit-scan function (FPS Intensive)
        function this:process_entities(_ent, aim_points, data)
            local bone_positions = aim_points
            local threats = entity_list:get_threats(true, ui_get(scan_dormant))

            if #bone_positions <= 0 or #threats <= 0 then
                return nil
            end

            local target_cycle = 0
            local target_found = nil

            local self_hp = entity_get_prop(_ent, 'm_iHealth')
            local self_armor = entity_get_prop(_ent, 'm_ArmorValue')

            for _, _pid in pairs(threats) do
                local eye_origin = this:get_eye_origin(_pid)
                local esp_alpha = entity_get_esp_data(_pid).alpha

                local optimized = false
                local target_damage = 0
                local hitbox = { id = -1, pos = vector(0, 0, 0) }

                target_cycle = target_cycle + 1

                for _, cbone in pairs(bone_positions) do
                    -- we have to optimize target processing to mitigate fps drops
                    local should_optimize = target_cycle > 1 or esp_alpha < 1

                    -- run ray bullet trace processing
                    local ray_index, ray_damage = client_trace_bullet(_pid,
                        eye_origin.x, eye_origin.y, eye_origin.z,
                        cbone.pos.x, cbone.pos.y, cbone.pos.z,
                        should_optimize
                    )

                    -- calculate if higher damage is available
                    if ray_damage > target_damage then
                        target_damage, hitbox, optimized = 
                            ray_damage, cbone, should_optimize
                        
                        -- skip cycle if target can deal higher damage than ur HP 
                        if ray_damage >= self_hp then
                            break
                        end
                    end
                end

                -- scale damage to avoid misprediction (another fps invitensive cycle)
                -- if target_damage is zero we continue the cycle
                if hitbox.id ~= -1 and this:calculate_damage(_ent, _pid, {
                    self_cbone = hitbox,
                    self_hp = self_hp,
                    self_armor = self_armor,
                    self_choke = globals_chokedcommands(),

                    target_eye_origin = eye_origin,
                    target_dmg = target_damage, 
                }) then
                    -- damage scaled
                    -- writing data and breaking the cycle
                    target_found = {
                        entity = _pid,
                        dormant = esp_alpha,
                        ticks = data.extrapolated,
                        damage = target_damage,
                        hitbox = hitbox.id,
                        optimized = optimized,
                    }

                    break
                end
            end

            return target_found
        end

        -- Runs local player / target processing
        function this:run(_ent, _wpn, _iTicksAllowed)
            if _ent == nil or not entity_is_alive(_ent) or _wpn == nil then
                return
            end

            local hitboxes =
            {
                head = { 0 },
                body = { 4, 2 },
                -- limbs = { 11, 12 }
            }

            local ce_entity = entity_list:get_client_entity(_ent)
            local m_origin = vector(entity_get_origin(_ent))

            -- calculating ticks to stop (+ minimal_weapon_speed:true)
            local m_max_weapon_speed = math_floor(math_min(250, 250/weapon_data:get_maximum_speed(_ent, _wpn)) - 0.5)
            local m_ticks_to_stop = weapon_data:get_ticks_to_stop(_ent, _wpn, true)

            -- calculating final ext ticks using formula : (maximum_ticks-1) - extrapolation
            -- extra delay (1 tick) is needed since gamesense aimbot is a bit bugged and waits for something
            local _ext_final_ticks = math_max(2, _iTicksAllowed-m_ticks_to_stop+m_max_weapon_speed)

            -- getting future player_origin/ext_ticks
            local move_data = { this:player_move_simple(_ent, m_origin, _ext_final_ticks) }
            
            -- DO PREDICTION STUFF
            local ext_data = nil
            local executed, status = pcall((function()
                local _prev_origin = m_origin

                -- set predicted abs_origin for next ray traces / calculations
                this:set_abs_origin(ce_entity, move_data[1])

                -- getting new hitbox positions
                local hitbox_positions = (function()
                    local hbox = { }
                    for name, list in pairs(hitboxes) do
                        for _, id in pairs(list) do
                            hbox[#hbox+1] = { id = id, pos = vector(entity_hitbox_position(_ent, id)) }
                        end
                    end

                    return hbox
                end)()
                
                -- run entity processing and return if threat is available
                ext_data = this:process_entities(_ent, hitbox_positions, {
                    origin = m_origin,
                    new_origin = move_data[1],
                    extrapolated = move_data[2],

                    ticks_to_stop = {
                        original = m_ticks_to_stop,
                        final = _ext_final_ticks
                    }
                })

                -- store original abs_original to not break the game
                this:set_abs_origin(ce_entity, _prev_origin)
            end))

            -- sandbox debugging to prevent further bugs/errors
            if not executed then
                ext_data = nil

                client_color_log(216, 181, 121, '[nyanlag:extrapolation] \1\0')
                client_color_log(255, 0, 0, status)
            end

            this:set_abs_origin(ce_entity, m_origin)

            return ext_data
        end

        return this
    end,

    createmove = function()
        local this = {
            triggers = {
                send_state = 0,
                priority_mode = false,

                types = { hold = 1, unchoke_hold = 2, unchoke = 3 },
                list = { },
            },

            lagcomp = {
                shifting = false,

                teleport = 0,
                tick_base = 0,
                shift_ticks = 0,
            },

            target_data = nil,

            weapon_ready = false,
            has_been_fired = false,
            last_command_is_ran = false,
            shot_being_limited = false,
        
            commandack = 0,
            last_weapon_idx = -1,
        
            origin = vector(0, 0, 0),
        }

        -- Sets trigger callback and updates data if the trigger is already set
        function this:set_trigger_callback(name, type, state, priority)
            local type = this.triggers.types[type] or 1
            local state = state or false
            local priority = priority or false

            if this.triggers.list[name] == nil then
                this.triggers.list[name] = {
                    type = type,
                    old_state = state,
                    state = state,
                    on_hold = false,
                    priority = priority or false
                }

                client_color_log(216, 181, 121, '[nyanlag:createmove] \1\0')
                client_color_log(255, 255, 255, 'registered callback: \1\0')
                client_color_log(155, 220, 220, name)
                
                return true
            end

            this.triggers.list[name].type = type
            this.triggers.list[name].state = state
            this.triggers.list[name].priority = priority
        end

        -- Processes triggers and controls createmove:send_packet
        function this:triggers_process(bSendPacket, fChokedCmds)
            local _SendPacket = false
            local _PriorityMode = false
            local _ApplyVariance = true

            local new_data = { }

            for name, trigger in pairs(this.triggers.list) do
                trigger.updated = false

                if trigger.state ~= trigger.old_state then
                    trigger.updated = true
                    trigger.old_state = trigger.state
                end
    
                if trigger.state and trigger.priority and trigger.on_hold then
                    _PriorityMode = true
                    _ApplyVariance = false
                end
    
                new_data[name] = trigger
            end

            local prev_hold = this.triggers.send_state

            if fChokedCmds == 0 then 
                this.triggers.send_state = math_max(0, this.triggers.send_state-1)
            end

            for name, trigger in pairs(new_data) do
                local priority_check = true
                local state, type = trigger.state, trigger.type

                if _PriorityMode and not trigger.priority then
                    priority_check = false
                end

                if trigger.on_hold and prev_hold == 1 and fChokedCmds == 0 then
                    if type == 3 or (type == 2 and not state) then
                        this.triggers.list[name].on_hold = false
                    end
                end

                if this.triggers.send_state == 0 and state and type < 3 and priority_check then
                    this.triggers.send_state = 1
                end

                if trigger.updated and state and priority_check then
                    if type > 1 then
                        this.triggers.send_state = 2
                    end

                    _SendPacket = true
                    this.triggers.list[name].on_hold = true
                end
            end

            if this.triggers.send_state > 0 and _SendPacket then
                bSendPacket = true
            end

            return bSendPacket, this.triggers.send_state > 0, _ApplyVariance
        end

        return this
    end,
}

local notify = uix_globals.notify()

local amount = uix_globals.amount()
local cmove = uix_globals.createmove()

local entity_list = uix_globals.entity_list()
local animation_layers = uix_globals.animation_layers(entity_list)
local weapon_data = uix_globals.weapon_data(entity_list)
local extrapolation = uix_globals.extrapolation(entity_list, weapon_data)

local tickbase_data = gram_create(0, 16)

for _, cid in pairs({
    {
        'setup_command', 0.1, function(cmd)
            local me = entity_get_local_player()
            local wpn = entity_get_player_weapon(me)

            -- animations
            local animations = animation_layers:collect(me)

            local _bSendShotPacket = true
            local _bSendPacket = cmd.allow_send_packet
            local _fChokedCmds = cmd.chokedcommands
            local _iTicksAllowed = amount:get_maximum_usrcmd_ticks()

            local double_tap = ui_get(ui_ref.double_tap[1]) and ui_get(ui_ref.double_tap[2])
            local onshot_aa = ui_get(ui_ref.onshot_aa[1]) and ui_get(ui_ref.onshot_aa[2])

            local _Limit = {
                send = math_min(_iTicksAllowed, ui_get(send_limit)),
                trigger = math_min(_iTicksAllowed, ui_get(trigger_send_limit))
            }

            -- "-1" ready-offset 
            -- : keep weapon_ready state synced withing next command
            local weapon_ready = weapon_data:is_ready(me, wpn, -1)
            local weapon_index = bit_band(entity_get_prop(wpn, 'm_iItemDefinitionIndex') or 0, 0xFFFF)

            if not weapon_ready and weapon_ready ~= cmove.weapon_ready and cmove.last_weapon_idx == weapon_index then
                cmove.has_been_fired = true
            end

            -- data pre-update
            if _fChokedCmds == 0 then
                local m_origin = vector(entity_get_origin(me))

                cmove.lagcomp.teleport = (m_origin-cmove.origin):length2dsqr()
                cmove.origin = m_origin
            end

            --region:animationlayers [parsing animations and generating player/weapon states]
            local player_state, weapon_state, animation_state = 
                animation_layers:generate_data(me, animations)

            -- using sandbox due to security reasons
            -- prevents from crashing, executing `return/break/etc` (callback breakers)
            local cached = { _bSendPacket = _bSendPacket, _bSendShotPacket = _bSendShotPacket, cmove = cmove }
            local executed, status = pcall((function()
                if not ui_get(master_switch) or onshot_aa then
                    return
                end

                ui_set(ui_ref.enabled[1], false)

                local should_apply_variance, is_trigger = 
                    true, false

                -- set SendPacket to "false"
                -- since we have basic "Send limit" slider
                _bSendPacket = false

                -- region:player_extrapolation
                local exp_triggers = 
                    triggers:find('threat->[on visible]') or 
                    triggers:find('threat->[while visible]')

                if cmd.chokedcommands == 0 then
                    cmove.extrapolation = nil
                end

                if not player_state.in_air and exp_triggers and cmove.extrapolation == nil then
                    local trigger_limit = ui_get(trigger_send_limit)
                    local iTicksAllowed = amount:get_maximum_usrcmd_ticks(trigger_limit)

                    cmove.extrapolation = extrapolation:run(me, wpn, iTicksAllowed)

                    if cmove.extrapolation ~= nil and contains(ui_get(debug_log), debug_data[4]) then
                        client_draw_hitboxes(me, globals_tickinterval()*iTicksAllowed, 255, 255, 0, 35)
                    end
                end

                if exp_triggers and triggers:find('threat->[avoid leg overlap]') then
                    local leg_move = {
                        [false] = 'off',
                        [true] = 'always slide'
                    }

                    ui_set(ui_ref.leg_movement, leg_move[cmove.extrapolation ~= nil])
                end

                -- triggers
                cmove:set_trigger_callback('in_air', 'hold', triggers:find('movement->[in air]') and player_state.in_air)
                cmove:set_trigger_callback('is_moving', 'unchoke_hold', triggers:find('movement->[while moving]') and player_state.moving and not player_state.in_air)
                cmove:set_trigger_callback('on_accelerate', 'unchoke_hold', triggers:find('movement->[on accelerate]') and player_state.accel and not player_state.in_air)

                cmove:set_trigger_callback('on_stand', 'unchoke', triggers:find('animations->[on stand]') and cmd.in_duck == 0 and not player_state.in_air and player_state.ducking, true)
                cmove:set_trigger_callback('unsafe_animations', 'hold', triggers:find('animations->[anim layers]') and animation_state.land_heavy)
                cmove:set_trigger_callback('weapon_activity', 'hold', triggers:find('animations->[weapon activity]') and _fChokedCmds == 0 and (weapon_state.equip or weapon_state.reloading))
                cmove:set_trigger_callback('weapon_fired', 'hold', triggers:find('animations->[weapon fired]') and weapon_state.firing)

                -- High Priority triggers
                cmove:set_trigger_callback('threat', 'unchoke', triggers:find('threat->[on visible]') and cmove.extrapolation ~= nil, true)
                cmove:set_trigger_callback('threat_hold', 'unchoke_hold', triggers:find('threat->[while visible]') and cmove.extrapolation ~= nil, true)

                _bSendPacket, is_trigger, should_apply_variance = cmove:triggers_process(_bSendPacket, _fChokedCmds)

                -- variance / fakelag amount / stuff
                local variance = should_apply_variance and ui_get(variance) or 0
                local ticks_to_choke = _Limit[is_trigger and 'trigger' or 'send']

                -- made variance update every tick instead of on-commandack update
                local next_limit = amount:apply_variance((function()
                    return ({
                        [uix_amount[1]] = amount:consistent(ticks_to_choke, _iTicksAllowed),
                        [uix_amount[2]] = (function()
                            local lagcomp = amount:adaptive(me, ticks_to_choke)

                            if lagcomp.is_adaptive or player_state.in_air then
                                variance = 0
                            end

                            return lagcomp.ticks
                        end)(),
                        
                        [uix_amount[3]] = (function()
                            local outgoing_cmd = globals_lastoutgoingcommand()
                            local amount = amount:apply_variance(2, 1, outgoing_cmd) == 2 and ticks_to_choke or 0

                            variance = amount ~= 0 and variance or 0

                            return amount
                        end)()

                    })[ui_get(famount)]
                end)(), variance, nil --[[ g.lastoutgoingcommand ]])
                
                -- we somehow reached the maximum amount of lag.
	            -- we cannot lag anymore.
                if _fChokedCmds >= next_limit then
                    _bSendShotPacket = _bSendShotPacket
                    _bSendPacket = true
                end

                -- weapon has been fired by client
                -- using some sort of prevention from packet being sent twice when firing (by client/aimbot)
                if cmove.has_been_fired and _bSendShotPacket then
                    -- do not lag while shooting (also fixes knifebot)
                    _bSendPacket = true

                    if _fChokedCmds == 0 and cmove.last_command_is_ran then
                        local original_hbf = cmove.has_been_fired
                        local original_hbl = cmove.shot_being_limited

                        cmove.has_been_fired = false

                        -- recreating `alternative` fake-lag on-shot
                        if ui_get(shot_limit) and not cmove.shot_being_limited then
                            cmove.shot_being_limited = true
                            cmove.has_been_fired = 1
                        end

                        if original_hbf == 1 or original_hbl then
                            cmove.shot_being_limited = false
                        end
                    end
                end

                ui_set(ui_ref.limit, _iTicksAllowed)
            end))

            -- sandbox debugging / restoring previous values to prevent further bugs/errors
            if not executed then
                _bSendShotPacket = cached._bSendShotPacket
                _bSendPacket = cached._bSendPacket
                cmove = cached.cmove

                client_color_log(216, 181, 121, '[nyanlag:extrapolation] \1\0')
                client_color_log(255, 0, 0, status)
            end

            -- debugging
            local _debug_ms = ui_get(debug_log)

            if #_debug_ms > 0 then
                notify:clear()
                notify:set_count(20)
                
                if contains(_debug_ms, debug_data[1]) then
                    for i=1, 12 do
                        local color = { 255, 255, 255 }

                        if animations[i].m_nSequenceId > 0 then
                            color = { 255, 185, 185 }
                        end

                        notify:add_to_output(color[1], color[2], color[3], string_format(
                            ' > anim layer [%d:%d]: cycle: %d prev_cycle: %d weight: %d', 
                            i, animations[i].m_nSequenceId, animations[i].m_flCycle, animations[i].m_flPrevCycle, animations[i].m_flWeight
                        ))
                    end
                end

                if contains(_debug_ms, debug_data[3]) then
                    notify:add_to_output(155, 220, 220, string_format('extrapolation: [ %s ]', (function()
                        if cmove.extrapolation ~= nil then
                            local td = cmove.extrapolation
        
                            return string_format(
                                'entity:%s    damage:%d    hitbox:%d    ticks:%d    flags: %d%d',
                                entity_get_player_name(td.entity), 
                                td.damage, td.hitbox, td.ticks,
                                td.optimized and 1 or 0,
                                td.dormant < 1 and 1 or 0
                            )
                        end

                        return 'unknown'
                    end)() ))
                end

                if contains(_debug_ms, debug_data[2]) then
                    notify:add_to_output(135, 135, 170, string_format(
                        'animations (0=safe 1=unsafe): [ LAND_HEAVY:%d    BALANCEADJUST:%d    PBRATE:%d    RMOVE:%d ]',
                        animation_state.land_heavy and 1 or 0,
                        animation_state.lowerbody and 1 or 0,
                        animation_state.desync_stand and 1 or 0,
                        animation_state.desync_move and 1 or 0
                    ))
                end

                if contains(_debug_ms, debug_data[5]) then
                    notify:add_to_output(190, 75, 120, string_format(
                        'player: [move:%d accel:%d in_air:%d unducking:%d] weapon: [firing:%d reloading:%d equipping:%d]',
                        player_state.moving and 1 or 0, player_state.accel and 1 or 0, player_state.in_air and 1 or 0, (cmd.in_duck == 0 and player_state.ducking) and 1 or 0,
                        weapon_state.firing and 1 or 0, weapon_state.reloading and 1 or 0, weapon_state.equip and 1 or 0
                    ))

                    notify:add_to_output(216, 181, 121, string_format(
                        'choked_cmds:%s /%d [%d] | cmd_verified:%d weapon_fired:%d lagcomp:%s\n',

                        _fChokedCmds < 10 and ('0' .. _fChokedCmds) or _fChokedCmds,
                        ui_get(ui_ref.usrcmdticks)-2,
                        cmove.triggers.send_state,
                        cmove.last_command_is_ran and 1 or 0, 
                        cmove.has_been_fired and 1 or 0,
                        cmove.lagcomp.shifting and 'true' or 'false'
                    ))
                end
            end

            -- data post-update
            cmove.commandack = _fChokedCmds
            cmove.last_command_is_ran = false

            cmove.weapon_ready = weapon_ready
            cmove.last_weapon_idx = weapon_index

            cmd.allow_send_packet = _bSendPacket

            -- hold_aim correction
            -- condition: on createmove:run_command 
            if not onshot_aa then
                ui_set(ui_ref.hold_aim, false)
            end
        end,
    },

    {
        'run_command', 0, function(c)
            -- hold_aim correction
            -- command_is_ran: set -> true
            ui_set(ui_ref.hold_aim, true)

            cmove.last_command_is_ran = true
        end,
    },

    {
        'net_update_start', 0, function()
            local me = entity_get_local_player()

            local tick_base = entity_get_prop(me, 'm_nTickBase')
            local simulation_time = entity_get_prop(me, 'm_flSimulationTime')

            cmove.lagcomp.shifting = false

            if me == nil or tick_base == nil or simulation_time == nil then
                return
            end

            local shift_ticks = (simulation_time / globals_tickinterval()) - globals_tickcount()

            if cmove.lagcomp.teleport > 4096 or (cmove.lagcomp.tick_base ~= 0 and tick_base < cmove.lagcomp.tick_base) then
                cmove.lagcomp.shifting = true
            else
                cmove.lagcomp.shifting = math.max(unpack(tickbase_data)) < 0
            end

            if prev_tickbase ~= shift_ticks then
                gram_update(tickbase_data, shift_ticks, true)
            end

            cmove.lagcomp.tick_base = tick_base
            cmove.lagcomp.shift_ticks = shift_ticks
        end
    },

    -- notify
    {
        'paint', 0, function()
            local size = { client_screen_size() }
            local me = entity_get_local_player()

            notify:listener(12 --[[ size[1] / 2 + 16*12 ]], size[2] - size[2]/2 --[[ 285 ]])

            if not ui_get(master_switch) or me == nil or not entity_is_alive(me) then
                cmove.extrapolation = nil
                return
            end

            local text = 'lagcomp: '
            local state = cmove.lagcomp.shifting and 'broken' or 'unsafe'
        
            local color = ({
                [false] = { 255, 0, 0 },
                [true] = { 25, 255, 165 }
            })[cmove.lagcomp.shifting]
        
            local screen = { client.screen_size() }
            local offset = { 
                { surface_get_text_size(verdana, string_format('%s %s', text, state)) },
                { surface_get_text_size(verdana, text) }
            }
        
            local base_offset = screen[1] / 2 - (offset[1][1] / 2)
            local base_height = screen[2] - 40
        
            surface_draw_text(base_offset, base_height, 255, 255, 255, 255, verdana, text)
            surface_draw_text(base_offset + offset[2][1], base_height, color[1], color[2], color[3], 255, verdana, state)
        end
    },

    -- ui initialization
    {
        'ui_callback', 0, function()
            local interface_callback = function(...)
                local args = { ... }
                local shutdown = args[1] == nil and args[2] == 'shutdown'
                
                local enabled = ui_get(master_switch) and not shutdown
                local _triggers = ui_get(triggers.self)

                local exp_ms = 
                    triggers:find('threat->[on visible]') or 
                    triggers:find('threat->[while visible]')
            
                ui_set_visible(triggers.self, enabled)
                ui_set_visible(scan_dormant, enabled and #_triggers > 0 and exp_ms)
                ui_set_visible(famount, enabled)
                ui_set_visible(variance, enabled)
                ui_set_visible(send_limit, enabled)
                ui_set_visible(trigger_send_limit, enabled and #_triggers > 0)
                ui_set_visible(shot_limit, enabled and #_triggers > 0)
            
                ui_set_visible(ui_ref.enabled[1], not enabled)
                ui_set_visible(ui_ref.enabled[2], not enabled)
            
                ui_set_visible(ui_ref.amount, not enabled)
                ui_set_visible(ui_ref.variance, not enabled)
                ui_set_visible(ui_ref.limit, not enabled)
            end

            ui_set_callback(triggers.self, function(c) 
                triggers:ui_callback()
                interface_callback(c)
            end)

            ui_set_callback(ui_ref.enabled[1], interface_callback)
            ui_set_callback(ui_ref.enabled[2], interface_callback)

            ui_set_callback(master_switch, interface_callback)
            ui_set_callback(scan_dormant, interface_callback)
            ui_set_callback(famount, interface_callback)
            ui_set_callback(variance, interface_callback)
            ui_set_callback(send_limit, interface_callback)
            ui_set_callback(trigger_send_limit, interface_callback)
            ui_set_callback(shot_limit, interface_callback)

            interface_callback()

            client_register_esp_flag('EXT', 255, 125, 95, function(i)
                if cmove.extrapolation == nil or cmove.extrapolation.entity ~= i then
                    return
                end

                return true, cmove.extrapolation.damage
            end)

            client_set_event_callback('shutdown', function()
                interface_callback(nil, 'shutdown')
            end)
        end
    },

    -- debug_logging
    { 
        'pre_config_save', 0, function()
            debug_log_state = ui_get(debug_log)
            ui_set(debug_log, {})
        end,
    }, { 
        'post_config_save', 0, function()
            if debug_log_state ~= nil then
                ui_set(debug_log, debug_log_state)
                debug_log_state = nil
            end
        end,
    }, { 
        'pre_config_load', 0, function()
            debug_log_state = ui_get(debug_log)
        end,
    }, { 
        'post_config_load', 0, function()
            if debug_log_state ~= nil then
                ui_set(debug_log, debug_log_state)
                debug_log_state = nil
            end
        end,
    },
}) do
    if cid[1] == 'ui_callback' then
        cid[3]()
    else
        client_delay_call(cid[2], function()
            client_set_event_callback(cid[1], cid[3])
        end)
    end
end