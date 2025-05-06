-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_camera_angles, client_create_interface, client_eye_position, client_set_event_callback, client_userid_to_entindex, entity_get_local_player, entity_get_player_name, entity_get_prop, entity_is_alive, globals_chokedcommands, globals_realtime, globals_tickcount, globals_tickinterval, math_abs, math_ceil, math_floor, string_format, string_lower, table_concat, table_insert, ui_new_checkbox, ui_reference, error, pairs, plist_get, ui_get, print, ui_set_callback = client.camera_angles, client.create_interface, client.eye_position, client.set_event_callback, client.userid_to_entindex, entity.get_local_player, entity.get_player_name, entity.get_prop, entity.is_alive, globals.chokedcommands, globals.realtime, globals.tickcount, globals.tickinterval, math.abs, math.ceil, math.floor, string.format, string.lower, table.concat, table.insert, ui.new_checkbox, ui.reference, error, pairs, plist.get, ui.get, print, ui.set_callback

local ffi = require 'ffi'
local vector = require 'vector'
local inspect = require 'gamesense/inspect'

local ffi_typeof, ffi_cast = ffi.typeof, ffi.cast

local master_switch = ui_new_checkbox('RAGE', 'Aimbot', 'Log aimbot shots')
local prefer_safe_point = ui_reference('RAGE', 'Aimbot', 'Prefer safe point')
local force_safe_point = ui_reference('RAGE', 'Aimbot', 'Force safe point')

local num_format = function(b) local c=b%10;if c==1 and b~=11 then return b..'st'elseif c==2 and b~=12 then return b..'nd'elseif c==3 and b~=13 then return b..'rd'else return b..'th'end end
local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
local weapon_to_verb = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' }

local classes = {
    net_channel = function()
        local this = { }

        local class_ptr = ffi_typeof('void***')
        local engine_client = ffi_cast(class_ptr, client_create_interface("engine.dll", "VEngineClient014"))
        local get_channel = ffi_cast("void*(__thiscall*)(void*)", engine_client[0][78])

        local netc_bool = ffi_typeof("bool(__thiscall*)(void*)")
        local netc_bool2 = ffi_typeof("bool(__thiscall*)(void*, int, int)")
        local netc_float = ffi_typeof("float(__thiscall*)(void*, int)")
        local netc_int = ffi_typeof("int(__thiscall*)(void*, int)")
        local net_fr_to = ffi_typeof("void(__thiscall*)(void*, float*, float*, float*)")

        client_set_event_callback('net_update_start', function()
            local ncu_info = ffi_cast(class_ptr, get_channel(engine_client)) or error("net_channel:update:info is nil")
            local seqNr_out = ffi_cast(netc_int, ncu_info[0][17])(ncu_info, 1)
        
            for name, value in pairs({
                seqNr_out = seqNr_out,
        
                is_loopback = ffi_cast(netc_bool, ncu_info[0][6])(ncu_info),
                is_timing_out = ffi_cast(netc_bool, ncu_info[0][7])(ncu_info),
        
                latency = {
                    crn = function(flow) return ffi_cast(netc_float, ncu_info[0][9])(ncu_info, flow) end,
                    average = function(flow) return ffi_cast(netc_float, ncu_info[0][10])(ncu_info, flow) end,
                },
        
                loss = ffi_cast(netc_float, ncu_info[0][11])(ncu_info, 1),
                choke = ffi_cast(netc_float, ncu_info[0][12])(ncu_info, 1),
                got_bytes = ffi_cast(netc_float, ncu_info[0][13])(ncu_info, 1),
                sent_bytes = ffi_cast(netc_float, ncu_info[0][13])(ncu_info, 0),
        
                is_valid_packet = ffi_cast(netc_bool2, ncu_info[0][18])(ncu_info, 1, seqNr_out-1),
            }) do
                this[name] = value
            end
        end)

        function this:get()
            return (this.seqNr_out ~= nil and this or nil)
        end

        return this
    end,

    animation_state = function()
        ffi.cdef[[	
            struct aimlog_csplayer_animstate {
                char pad[3];
                char m_bForceWeaponUpdate;
                char pad1[91];
                void* m_pBaseEntity;
                void* m_pActiveWeapon;
                void* m_pLastActiveWeapon;
                float m_flLastClientSideAnimationUpdateTime;
                int m_iLastClientSideAnimationUpdateFramecount;
                float m_flAnimUpdateDelta;
                float m_flEyeYaw;
                float m_flPitch;
                float m_flGoalFeetYaw;
                float m_flCurrentFeetYaw;
                float m_flCurrentTorsoYaw;
                float m_flUnknownVelocityLean;
                float m_flLeanAmount;
                char pad2[4];
                float m_flFeetCycle;
                float m_flFeetYawRate;
                char pad3[4];
                float m_fDuckAmount;
                float m_fLandingDuckAdditiveSomething;
                char pad4[4];
                float m_vOriginX;
                float m_vOriginY;
                float m_vOriginZ;
                float m_vLastOriginX;
                float m_vLastOriginY;
                float m_vLastOriginZ;
                float m_vVelocityX;
                float m_vVelocityY;
                char pad5[4];
                float m_flUnknownFloat1;
                char pad6[8];
                float m_flUnknownFloat2;
                float m_flUnknownFloat3;
                float m_flUnknown;
                float m_flSpeed2D;
                float m_flUpVelocity;
                float m_flSpeedNormalized;
                float m_flFeetSpeedForwardsOrSideWays;
                float m_flFeetSpeedUnknownForwardOrSideways;
                float m_flTimeSinceStartedMoving;
                float m_flTimeSinceStoppedMoving;
                bool m_bOnGround;
                bool m_bInHitGroundAnimation;
                float m_flTimeSinceInAir;
                float m_flLastOriginZ;
                float m_flHeadHeightOrOffsetFromHittingGroundAnimation;
                float m_flStopToFullRunningFraction;
                char pad7[4];
                float m_flMagicFraction;
                char pad8[60];
                float m_flWorldForce;
                char pad9[462];
                float m_flMaxYaw;
            };
        ]]

        local this = { }

        local classptr, charptr = ffi.typeof('void***'), ffi.typeof('char*')
        local entity_list = ffi.cast(classptr, client_create_interface('client.dll', 'VClientEntityList003'))
        local get_client_entity = ffi.cast(ffi.typeof('void*(__thiscall*)(void*, int)'), entity_list[0][3])

        local round = function(x) 
            return x >= 0 and math_floor(x+0.5) or math_ceil(x-0.5)
        end

        local yaw_normalize = function(yaw)
            if yaw > 180 or yaw < -180 then
                local revolutions = round(math_abs(yaw / 360))
                if yaw < 0 then yaw = yaw + 360*revolutions else yaw = yaw - 360*revolutions end
            end

            return yaw
        end

        function this:get(centity)
            if centity == nil then
                return nil
            end
        
            local client_entity = get_client_entity(entity_list, centity) or error('animation_state:get:client_entity is nil')
            local player_ptr = ffi.cast(classptr, client_entity) or error('animation_state:get:client_entity_ptr is nil')
            local animstate_ptr = ffi.cast(charptr, player_ptr) + 0x3914
            
            return ffi.cast('struct aimlog_csplayer_animstate**', animstate_ptr)[0]
        end

        function this:get_feet_yaw(centity)
            if centity == nil or not entity_is_alive(centity) then
                return nil
            end

            local animation_state = this:get(centity) or error('animation_state:feet_yaw:get is nil')
            local body_yaw = yaw_normalize(animation_state.m_flEyeYaw-animation_state.m_flGoalFeetYaw)

            return (body_yaw < 10 and body_yaw > -10) and 0 or body_yaw
        end

        return this
    end,

    aimbot = function(net_channel, animation_state)
        local this = { }
        local aim_data = { }
        local bullet_impacts = { }

        local generate_flags = function(pre_data)
            return {
                pre_data.self_choke > 1 and 1 or 0,
                pre_data.velocity_modifier < 1.00 and 1 or 0,
                pre_data.flags.boosted and 1 or 0
            }
        end

        local get_safety = function(aim_data, target)
            local has_been_boosted = aim_data.boosted
            local plist_safety = plist_get(target, 'Override safe point')
            local ui_safety = { ui_get(prefer_safe_point), ui_get(force_safe_point) or plist_safety == 'On' }
    
            if not has_been_boosted then
                return -1
            end
    
            if plist_safety == 'Off' or not (ui_safety[1] or ui_safety[2]) then
                return 0
            end
    
            return ui_safety[2] and 2 or (ui_safety[1] and 1 or 0)
        end

        local get_inaccuracy_tick = function(pre_data, tick)
            local spread_angle = -1
            for k, impact in pairs(bullet_impacts) do
                if impact.tick == tick then
                    local aim, shot = 
                        (pre_data.eye-pre_data.shot_pos):angles(),
                        (pre_data.eye-impact.shot):angles()
        
                        spread_angle = vector(aim-shot):length2d()
                    break
                end
            end

            return spread_angle
        end

        this.fired = function(e)
            local this = { }
            local p_ent = e.target
            local me = entity_get_local_player()
        
            aim_data[e.id] = {
                original = e,
                dropped_packets = { },
        
                handle_time = globals_realtime(),
                self_choke = globals_chokedcommands(),
        
                flags = {
                    boosted = e.boosted
                },

                safety = get_safety(e, p_ent),
                feet_yaw = animation_state:get_feet_yaw(p_ent),
                correction = plist_get(p_ent, 'Correction active'),
        
                shot_pos = vector(e.x, e.y, e.z),
                eye = vector(client_eye_position()),
                view = vector(client_camera_angles()),
        
                velocity_modifier = entity_get_prop(me, 'm_flVelocityModifier'),
                total_hits = entity_get_prop(me, 'm_totalHitsOnServer'),

                history = globals.tickcount() - e.tick
            }
        end
        
        this.missed = function(e)
            if aim_data[e.id] == nil then
                return
            end
        
            local pre_data = aim_data[e.id]
            local shot_id = num_format((e.id % 15) + 1)
            
            local net_data = net_channel:get()
        
            local ping, avg_ping = 
                net_data.latency.crn(0)*1000, 
                net_data.latency.average(0)*1000
        
            local net_state = string_format(
                'delay: %d:%.2f | dropped: %d', 
                avg_ping, math_abs(avg_ping-ping), #pre_data.dropped_packets
            )
        
            local uflags = {
                math_abs(avg_ping-ping) < 1 and 0 or 1,
                cvar.cl_clock_correction:get_int() == 1 and 0 or 1,
                cvar.cl_clock_correction_force_server_tick:get_int() == 999 and 0 or 1
            }
        
            local spread_angle = get_inaccuracy_tick( pre_data, globals_tickcount() )
            
            -- smol stuff
            local me = entity_get_local_player()
            local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
            local target_name = string_lower(entity_get_player_name(e.target))
            local hit_chance = math_floor(pre_data.original.hit_chance + 0.5)
            local pflags = generate_flags(pre_data)
        
            local reasons = {
                ['event_timeout'] = function()
                    print(string_format(
                        'Missed %s shot due to event timeout [%s] [%s]', 
                        shot_id, target_name, net_state
                    ))
                end,

                ['death'] = function()
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to death [dropped: %d | flags: %s | error: %s]', 
                        shot_id, target_name, hgroup, hit_chance, #pre_data.dropped_packets, table_concat(pflags), table_concat(uflags)
                    ))
                end,
        
                ['prediction_error'] = function(type)
                    local type = type == 'unregistered shot' and (' [' .. type .. ']') or ''
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to prediction error%s [%s] [vel_modifier: %.1f | history(Δ): %d | error: %s]', 
                        shot_id, target_name, hgroup, hit_chance, type, net_state, entity_get_prop(me, 'm_flVelocityModifier'), pre_data.history, table_concat(uflags)
                    ))
                end,
        
                ['spread'] = function()
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to spread [angle: %.2f° | %d:%d°] ( dmg: %d | safety: %d | history(Δ): %d | flags: %s )',
                        shot_id, target_name, hgroup, hit_chance, spread_angle, 
                        pre_data.correction and 1 or 0, pre_data.feet_yaw,
                        pre_data.original.damage, pre_data.safety, pre_data.history, table_concat(pflags)
                    ))
                end,
        
                ['unknown'] = function(type)
                    local _type = {
                        ['damage_rejected'] = 'damage rejection',
                        ['unknown'] = string_format('unknown [angle: %.2f° | %d:%d°]', spread_angle, pre_data.correction and 1 or 0, pre_data.feet_yaw)
                    }

                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to %s ( dmg: %d | safety: %d | history(Δ): %d | flags: %s )',
                        shot_id, target_name, hgroup, hit_chance, _type[type or 'unknown'],
                        pre_data.original.damage, pre_data.safety, pre_data.history, table_concat(pflags)
                    ))
                end
            }
        
            local post_data = {
                event_timeout = (globals_realtime() - pre_data.handle_time) >= 0.5,
                damage_rejected = e.reason == '?' and pre_data.total_hits ~= entity_get_prop(me, 'm_totalHitsOnServer'),
                prediction_error = e.reason == 'prediction error' or e.reason == 'unregistered shot'
            }
        
            if post_data.event_timeout then 
                reasons.event_timeout()
            elseif post_data.prediction_error then 
                reasons.prediction_error(e.reason)
            elseif e.reason == 'spread' then
                reasons.spread()
            elseif e.reason == '?' then
                reasons.unknown(post_data.damage_rejected and 'damage_rejected' or 'unknown')
            elseif e.reason == 'death' then
                reasons.death()
            end
        
            aim_data[e.id] = nil
        end
        
        this.hit = function(e)
            if aim_data[e.id] == nil then
                return
            end
        
            local p_ent = e.target

            local pre_data = aim_data[e.id]
            local shot_id = num_format((e.id % 15) + 1)

            local me = entity_get_local_player()
            local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
            local aimed_hgroup = hitgroup_names[pre_data.original.hitgroup + 1] or '?'

            local target_name = string_lower(entity_get_player_name(e.target))
            local hit_chance = math_floor(pre_data.original.hit_chance + 0.5)
            local pflags = generate_flags(pre_data)

            local spread_angle = get_inaccuracy_tick( pre_data, globals_tickcount() )
            
            local _verification = function()
                local text = ''

                local hg_diff = hgroup ~= aimed_hgroup
                local dmg_diff = e.damage ~= pre_data.original.damage

                if hg_diff or dmg_diff then
                    text = string_format(
                        ' | mismatch: [ %s ]', (function()
                            local addr = ''

                            if dmg_diff then addr = 'dmg: ' .. pre_data.original.damage .. (hg_diff and ' | ' or '') end
                            if hg_diff then addr = addr .. (hg_diff and 'hitgroup: ' .. aimed_hgroup or '') end

                            return addr
                        end)()
                    )
                end

                return text
            end

            print(string_format(
                'Registered %s shot in %s\'s %s for %d damage [angle: %.2f° | %d:%d°] ( hitchance: %d%% | safety: %s | history(Δ): %d | flags: %s%s )',
                shot_id, target_name, hgroup, e.damage,
                spread_angle, pre_data.correction and 1 or 0, pre_data.feet_yaw,
                hit_chance, pre_data.safety, pre_data.history, table_concat(pflags), _verification()
            ))
        end
        
        this.bullet_impact = function(e)
            local tick = globals_tickcount()
            local me = entity_get_local_player()
            local user = client_userid_to_entindex(e.userid)
            
            if user ~= me then
                return
            end
        
            if #bullet_impacts > 150 then
                bullet_impacts = { }
            end
        
            bullet_impacts[#bullet_impacts+1] = {
                tick = tick,
                eye = vector(client_eye_position()),
                shot = vector(e.x, e.y, e.z)
            }
        end
        
        this.net_listener = function()
            local net_data = net_channel:get()
        
            if net_data == nil then
                return
            end

            if not net_channel.is_valid_packet then
                for id in pairs(aim_data) do
                    table_insert(aim_data[id].dropped_packets, net_channel.seqNr_out)
                end
            end
        end

        return this
    end
}

local net_channel = classes.net_channel()
local animation_state = classes.animation_state()
local aimbot = classes.aimbot(net_channel, animation_state)

local g_player_hurt = function(e)
    local attacker_id = client_userid_to_entindex(e.attacker)
	
    if attacker_id == nil or attacker_id ~= entity_get_local_player() then
        return
    end

    local group = hitgroup_names[e.hitgroup + 1] or "?"
	
    if group == "generic" and weapon_to_verb[e.weapon] ~= nil then
        local target_id = client_userid_to_entindex(e.userid)
		local target_name = entity_get_player_name(target_id)

		print(string_format("%s %s for %i damage (%i remaining)", weapon_to_verb[e.weapon], string_lower(target_name), e.dmg_health, e.health))
	end
end

local interface_callback = function(c)
    local addr = not ui_get(c) and 'un' or ''
    local _func = client[addr .. 'set_event_callback']

    _func('aim_fire', aimbot.fired)
    _func('aim_miss', aimbot.missed)
    _func('aim_hit', aimbot.hit)
    _func('bullet_impact', aimbot.bullet_impact)
    _func('net_update_start', aimbot.net_listener)
    _func('player_hurt', g_player_hurt)
end

ui_set_callback(master_switch, interface_callback)
interface_callback(master_switch)
