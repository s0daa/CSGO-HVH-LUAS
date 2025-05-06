local L0 = require 'ffi'
local L1 = require 'bit'
local L2 = require "vector"
local L3 = require "gamesense/antiaim_funcs" or error "https://gamesense.pub/forums/viewtopic.php?id=29665"
local L4 = require "gamesense/surface"
local L5 = require "gamesense/base64" or error("Base64 library required")
local L6 = require "gamesense/clipboard" or error("Clipboard library required")
local L7, L8, L9, L10, L11, L12, L13, L14, L15 = require, pcall, ipairs, pairs, unpack, tonumber, tostring, toticks, totime;
local L16 = { new = L0.new, typeof = L0.typeof, cast = L0.cast, cdef = L0.cdef, sizeof = L0.sizeof, string = L0.string }
local L17 = { loadstring = panorama.loadstring, open = panorama.open }
local L18 = { get = plist.get, set = plist.set }
local L19 = { export = config.export, import = config.import, load = config.load }
local L20 = { flush = database.flush, read = database.read, write = database.write }
local L21 = { arshift = L1.arshift, band = L1.band, bnot = L1.bnot, bor = L1.bor, bswap = L1.bswap, bxor = L1.bxor, lshift = L1.lshift, rol = L1.rol, ror = L1.ror, rshift = L1.rshift, tobit = L1.tobit, tohex = L1.tohex }
local L22 = { byte = string.byte, char = string.char, find = string.find, format = string.format, gmatch = string.gmatch, gsub = string.gsub, len = string.len, lower = string.lower, match = string.match, rep = string.rep, reverse = string.reverse, sub = string.sub, upper = string.upper }
local L23 = { abs = math.abs, acos = math.acos, asin = math.asin, atan = math.atan, atan2 = math.atan2, ceil = math.ceil, cos = math.cos, cosh = math.cosh, deg = math.deg, exp = math.exp, floor = math.floor, fmod = math.fmod, frexp = math.frexp, ldexp = math.ldexp, log = math.log, log10 = math.log10, max = math.max, min = math.min, modf = math.modf, pow = math.pow, rad = math.rad, random = math.random, randomseed = math.randomseed, sin = math.sin, sinh = math.sinh, sqrt = math.sqrt, tan = math.tan, tanh = math.tanh, pi = math.pi }
local L24 = { get = ui.get, is_menu_open = ui.is_menu_open, menu_size = ui.menu_size, menu_position = ui.menu_position, mouse_position = ui.mouse_position, name = ui.name, new_button = ui.new_button, new_checkbox = ui.new_checkbox, new_color_picker = ui.new_color_picker, new_combobox = ui.new_combobox, new_hotkey = ui.new_hotkey, new_label = ui.new_label, new_listbox = ui.new_listbox, new_multiselect = ui.new_multiselect, new_slider = ui.new_slider, new_string = ui.new_string, new_textbox = ui.new_textbox, reference = ui.reference, set = ui.set, set_callback = ui.set_callback, set_visible = ui.set_visible, update = ui.update }
local L25 = { blur = renderer.blur, circle = renderer.circle, circle_outline = renderer.circle_outline, gradient = renderer.gradient, indicator = renderer.indicator, line = renderer.line, load_jpg = renderer.load_jpg, load_png = renderer.load_png, load_rgba = renderer.load_rgba, load_svg = renderer.load_svg, measure_text = renderer.measure_text, rectangle = renderer.rectangle, text = renderer.text, texture = renderer.texture, triangle = renderer.triangle, world_to_screen = renderer.world_to_screen }
local L26 = { absoluteframetime = globals.absoluteframetime, chokedcommands = globals.chokedcommands, commandack = globals.commandack, curtime = globals.curtime, framecount = globals.framecount, frametime = globals.frametime, lastoutgoingcommand = globals.lastoutgoingcommand, mapname = globals.mapname, maxplayers = globals.maxplayers, oldcommandack = globals.oldcommandack, realtime = globals.realtime, tickcount = globals.tickcount, tickinterval = globals.tickinterval }
local L27 = { get_all = entity.get_all, get_bounding_box = entity.get_bounding_box, get_classname = entity.get_classname, get_esp_data = entity.get_esp_data, get_game_rules = entity.get_game_rules, get_local_player = entity.get_local_player, get_origin = entity.get_origin, get_player_name = entity.get_player_name, get_player_resource = entity.get_player_resource, get_player_weapon = entity.get_player_weapon, get_players = entity.get_players, get_prop = entity.get_prop, get_steam64 = entity.get_steam64, hitbox_position = entity.hitbox_position, is_alive = entity.is_alive, is_dormant = entity.is_dormant, is_enemy = entity.is_enemy, new_prop = entity.new_prop, set_prop = entity.set_prop }
local L28 = { camera_angles = _G.client.camera_angles, camera_position = _G.client.camera_position, color_log = _G.client.color_log, create_interface = _G.client.create_interface, current_threat = _G.client.current_threat, delay_call = _G.client.delay_call, draw_debug_text = _G.client.draw_debug_text, draw_hitboxes = _G.client.draw_hitboxes, error_log = _G.client.error_log, exec = _G.client.exec, eye_position = _G.client.eye_position, find_signature = _G.client.find_signature, fire_event = _G.client.fire_event, get_cvar = _G.client.get_cvar, get_model_name = _G.client.get_model_name, key_state = _G.client.key_state, latency = _G.client.latency, log = _G.client.log, random_float = _G.client.random_float, random_int = _G.client.random_int, real_latency = _G.client.real_latency, register_esp_flag = _G.client.register_esp_flag, reload_active_scripts = _G.client.reload_active_scripts, request_full_update = _G.client.request_full_update, scale_damage = _G.client.scale_damage, screen_size = _G.client.screen_size, set_clan_tag = _G.client.set_clan_tag, set_event_callback = _G.client.set_event_callback, system_time = _G.client.system_time, timestamp = _G.client.timestamp, trace_bullet = _G.client.trace_bullet, trace_line = _G.client.trace_line, unix_time = _G.client.unix_time, unset_event_callback = _G.client.unset_event_callback, update_player_list = _G.client.update_player_list, userid_to_entindex = _G.client.userid_to_entindex, visible = _G.client.visible }
local L29 = L16.typeof('void***')
local L30 = L28.create_interface('client.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)
local L31 = L16.cast(L29, L30) or error('rawientitylist is nil', 2)
local L32 = L16.cast('void*(__thiscall*)(void*, int)', L31[0][3]) or error('get_client_entity is nil', 2)
local L33 = L16.cast('void*(__thiscall*)(void*, int)', L31[0][0]) or error('get_client_networkable_t is nil', 2)
L16.cdef([[
    struct animation_layer_t {
        char  pad_0000[20];
        uint32_t m_nOrder; //0x0014
        uint32_t m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030 // player's thisptr
        char  pad_0038[4]; //0x0034
    };

    struct animstate_t1 {
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        char m_pad[2];
        float m_flJumpToFall;
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    };

]])

-- #checkbox
ui.new_combobox("RAGE", "Other", "Wraith resolver", "off", "desync")

-- #resolver
local L647 = function(L631)
    local L632 = L27.get_players(true)
    if #L632 == 0 then
        L71 = { cur = {}, prev = {}, pre_prev = {}, pre_pre_prev = {} }
        return nil
    end;
    for L633, L634 in L9(L632) do
        if L27.is_alive(L634) and not L27.is_dormant(L634) then
            local L635 = 0;
            local L636 = L27.get_esp_data(L634).flags or 0;
            if L21.band(L636, L21.lshift(1, 17)) ~= 0 then
                L635 = L503(L27.get_prop(L634, "m_flSimulationTime")) - 14
            else
                L635 = L503(L27.get_prop(L634, "m_flSimulationTime"))
            end;
            if L71.cur[L634] == nil or L635 - L71.cur[L634].simtime >= 1 then
                L71.pre_pre_prev[L634] = L71.pre_prev[L634]
                L71.pre_prev[L634] = L71.prev[L634]
                L71.prev[L634] = L71.cur[L634]
                local L637 = L2(L27.get_prop(L631, "m_vecOrigin"))
                local L638 = L2(L27.get_prop(L634, "m_angEyeAngles"))
                local L639 = L2(L27.get_prop(L634, "m_vecOrigin"))
                local L640 = L23.floor(L138(L638.y - calculate_angle(L637, L639)))
                local L641 = L27.get_prop(L634, "m_flDuckAmount")
                local L642 = L21.band(L27.get_prop(L634, "m_fFlags"), 1) == 1;
                local L643 = L2(L27.get_prop(L634, 'm_vecVelocity')):length2d()
                local L644 = L642 and (L641 == 1 and "duck" or (L643 > 1.2 and "running" or "standing")) or "air"
                local L645 = L27.get_player_weapon(L634)
                local L646 = L27.get_prop(L645, "m_fLastShotTime")
                L71.cur[L634] = { id = L634, origin = L2(L27.get_origin(L634)), pitch = L638.x, yaw = L640, yaw_backwards = L23.floor(L138(calculate_angle(L637, L639))), simtime = L635, stance = L644, esp_flags = L27.get_esp_data(L634).flags or 0, last_shot_time = L646 }
            end
        end
    end
end;
local L648 = false;
local L672 = function(L649)
    if not L27.is_alive(L649) then
        if L648 then
        end;
        L648 = false;
        return
    end;
    local L650 = L27.get_players(true)
    if #L650 == 0 then
        return nil
    end;
    for L651, L652 in L9(L650) do
        if L27.is_alive(L652) and not L27.is_dormant(L652) then
            if L71.cur[L652] ~= nil and L71.prev[L652] ~= nil and L71.pre_prev[L652] ~= nil and L71.pre_pre_prev[L652] ~= nil then
                local L653 = nil;
                local L654 = nil;
                local L655;
                local L656;
                local L657 = L23.abs(L138(L71.cur[L652].yaw - L71.prev[L652].yaw))
                local L658 = L138(L71.cur[L652].yaw - L71.prev[L652].yaw)
                if L71.cur[L652].last_shot_time ~= nil then
                    L655 = L26.curtime() - L71.cur[L652].last_shot_time;
                    L656 = L655 / L26.tickinterval()
                    L654 = L656 <= L23.floor(0.2 / L26.tickinterval())
                end;
                if L24.get(L90["debug"][1]) == "desync" then
                    L648 = true;
                    local L659 = L71.cur[L652].yaw;
                    local L660 = L71.prev[L652].yaw;
                    local L661 = L71.pre_prev[L652].yaw;
                    local L662 = L71.pre_pre_prev[L652].yaw;
                    local L663 = L138(L659 - L660)
                    local L664 = L138(L659 - L661)
                    local L665 = L138(L660 - L662)
                    local L666 = L138(L660 - L661)
                    local L667 = L138(L661 - L662)
                    local L668 = L138(L662 - L659)
                    local L669 = L138(L657 - L668)
                    if L654 and L23.abs(L23.abs(L71.cur[L652].pitch) - L23.abs(L71.prev[L652].pitch)) > 30 and L71.cur[L652].pitch < L71.prev[L652].pitch then
                        L653 = "ON SHOT"
                    else
                        if L23.abs(L71.cur[L652].pitch) > 60 then
                            if L657 > 30 and L23.abs(L664) < 15 and L23.abs(L665) < 15 then
                                L653 = "[!!]"
                            elseif L23.abs(L663) > 15 or L23.abs(L666) > 15 or L23.abs(L667) > 15 or L23.abs(L668) > 15 then
                                L653 = "[!!!]"
                            end
                        end
                    end;
                    if L24.get(L90["debug"][5]) and L24.get(L90["debug"][6]) then
                        if L653 ~= "ON SHOT" then
                            L18.set(L652, "Add to whitelist", true)
                        else
                            L18.set(L652, "Add to whitelist", false)
                        end
                    else
                        L18.set(L652, "Add to whitelist", false)
                    end;
                    if L147[L652] and L653 ~= nil then
                        if L71.cur[L652].stance == "standing" and #L73[L652].stand < 20 then
                            table.insert(L73[L652].stand_type, L653)
                            if L653 == "[!!!]" and L657 > 5 then
                                table.insert(L73[L652].stand, L657)
                            else
                                if L653 == "[!!]" then
                                    table.insert(L73[L652].stand, L657)
                                end
                            end
                        elseif L71.cur[L652].stance == "running" and #L73[L652].run < 20 then
                            table.insert(L73[L652].run_type, L653)
                            if L653 == "[!!!]" and L657 > 5 then
                                table.insert(L73[L652].run, L657)
                            else
                                if L653 == "[!!]" then
                                    table.insert(L73[L652].run, L657)
                                end
                            end
                        elseif L71.cur[L652].stance == "air" and #L73[L652].air < 20 then
                            table.insert(L73[L652].air_type, L653)
                            if L653 == "[!!!]" and L657 > 5 then
                                table.insert(L73[L652].air, L657)
                            else
                                if L653 == "[!!]" then
                                    table.insert(L73[L652].air, L657)
                                end
                            end
                        elseif L71.cur[L652].stance == "duck" and #L73[L652].duck < 20 then
                            table.insert(L73[L652].duck_type, L653)
                            if L653 == "[!!!]" and L657 > 5 then
                                table.insert(L73[L652].duck, L657)
                            else
                                if L653 == "[!!]" then
                                    table.insert(L73[L652].duck, L657)
                                end
                            end
                        end
                    end;
                    if L71.cur[L652].pitch >= 78 and L71.prev[L652].pitch > 78 then
                        if L653 == "[!!!]" or L653 == "[!!]" then
                            if L653 == "[!!]" then
                                if L138(L659 - L660) > 0 then
                                    L18.set(L652, "Force body yaw", true)
                                    L18.set(L652, "Force body yaw value", 60)
                                elseif L138(L659 - L660) < 0 then
                                    L18.set(L652, "Force body yaw", true)
                                    L18.set(L652, "Force body yaw value", -60)
                                end
                            elseif L653 == "[!!!]" then
                                local L670 = 0;
                                local L671 = 0;
                                if (L660 == L138(L659 - L657) or L660 == L138(L659 + L657)) and (L661 == L138(L659 + L657) or L661 == L659) and (L661 == L138(L659 + L657) or L661 == L659) then
                                    L18.set(L652, "Force body yaw", true)
                                    L18.set(L652, "Force body yaw value", 0)
                                    L670 = L659
                                else
                                    if L659 ~= L670 then
                                        if L659 < 0 then
                                            L18.set(L652, "Force body yaw", true)
                                            L18.set(L652, "Force body yaw value", 60)
                                        else
                                            L18.set(L652, "Force body yaw", true)
                                            L18.set(L652, "Force body yaw value", -60)
                                        end
                                    end
                                end
                            end
                        else
                            L18.set(L652, "Force body yaw", false)
                            L18.set(L652, "Force body yaw value", 0)
                        end
                    end
                elseif L24.get(L90["debug"][1]) == "---" then
                    L653 = nil;
                    L648 = true;
                    break
                elseif L24.get(L90["debug"][1]) == "off" then
                    if L648 then
                        L653 = nil;
                        L24.set(L127.plist.reset, true)
                        L18.set(L652, "Force body yaw", false)
                        L18.set(L652, "Force body yaw value", 0)
                        L648 = false
                    end
                end;
                L72[L652] = { anti_aim_type = L653, yaw_delta = L658 }
            end
        else
            m_fired = false;
            time_difference = 0;
            ticks_since_last_shot = 0
        end
    end
end