client.log_screen('Fade.Lua')

local ui_call = require("UI Callbacks")

local run_jitter = false

local text = menu.add_text("intro", "thanks for using my lua! \n"                    )
local text = menu.add_text("intro", "made by nado \n \n"    )

local text = menu.add_text("intro", "enjoy!"                                         )

menu.add_separator("Anti-Aim")
local enable    = menu.add_checkbox("Anti-Aim", "Enable", false)
local aatyp     = menu.add_selection("Anti-Aim", "Anti-Aim Mode", {"Sway [op]", "Aggressive", "Aggressive v2", "Static", "Centered Jitter","Own Built",})
local do_auto_direct  = menu.add_selection("Anti-Aim", "auto direction mode", {"none", "viewangle", "at targets (crosshair)", "at targets (distance)", "velocity"}) -- PUT THE NAMES IN HERE
local side2     = menu.add_selection("Anti-Aim", "Anti-Aim Side", {"Left", "Right", "Jitter", "LBY"})
local leftamt2  = menu.add_slider("Anti-Aim", "Desync [L]", 0, 90)
local rigtamt2  = menu.add_slider("Anti-Aim", "Desync [R]", 0, 90)
local jitter_angle_1  = menu.add_slider("Anti-Aim", "Jitter [L]", -180, 180)
local jitter_angle_2  = menu.add_slider("Anti-Aim", "Jitter [R]", -180, 180)
local modifiers = menu.add_multi_selection("Anti-Aim", "Modifiers [1]", {"Static Jitter in Air", "Static Jitter on Crouch", "Fast Jitter"} )
local modifierssta = menu.add_multi_selection("Anti-Aim", "Modifier [2]", {"Safe Head", "Non-Safe"} )






 --] MENU CONTROLS
 local yaw_base        = menu.find("antiaim", "main", "angles", "yaw add"        )
 local rotate_enable   = menu.find("antiaim", "main", "angles", "rotate"         )
 local mrotate_range   = menu.find("antiaim", "main", "angles", "rotate range"   )
 local mrotate_speed   = menu.find("antiaim", "main", "angles", "rotate speed"   )
 local desync_side     = menu.find("antiaim", "main", "desync", "side"           ) 
 local desync_amount_l = menu.find("antiaim", "main", "desync", "left amount"    )
 local desync_amount_r = menu.find("antiaim", "main", "desync", "right amount"   ) 
 local antibrute       = menu.find("antiaim", "main", "desync", "anti bruteforce")
 local cheat_jitter    = menu.find("antiaim", "main", "angles", "jitter mode"    )
 local auto_direct     = menu.find("antiaim", "main", "angles", "yaw base"       )
 local pitch           = menu.find("antiaim", "main", "angles", "pitch"          )
 local onshot          = menu.find("antiaim", "main", "desync", "on shot"        )
 local override_stand  = menu.find("antiaim", "main", "desync", "override stand" )
 
  ---------------------------------------------------------------------------   

  
local selection_item = menu.add_selection("Anti-Aim", "centered jitter", {"off", "Centered Jitter", "Random Centered Jitter"})
local jitter_value = menu.add_slider("Anti-Aim", "Centered Jitter Value", -100, 100)
local min_jitter_value = menu.add_slider("Anti-Aim", "Centered Jitter Value [MIN]", 1, 90)
local max_jitter_value = menu.add_slider("Anti-Aim", "Centered maximum Jitter Value [MAX]", 1, 90)

local delay_value = menu.add_slider("Anti-Aim", "Jitter Delay Value", 0, 60)

local yaw_menu = menu.find("antiaim","main","angles","yaw add")
local jitter_menu = menu.find("antiaim","main","angles","jitter mode")

local invert_side = false

local timer = 0

local function on_antiaim(ctx)

    local count = global_vars.real_time()
    
    if not run_jitter or (count - timer) < (delay_value:get() / 1000) then return end
    
    local jit_val = jitter_value:get()
    local min_jit_val = min_jitter_value:get()
    local max_jit_val = max_jitter_value:get()

    if selection_item:get() == 3 then jit_val = math.random(min_jit_val, max_jit_val) end

    if invert_side then jit_val = 0 - jit_val end
    yaw_menu:set(jit_val)

    invert_side = not invert_side

    timer = global_vars.real_time()
end

callbacks.add(e_callbacks.ANTIAIM, on_antiaim)

local function handle_menu()
    
    local menu_val = selection_item:get()

    run_jitter = false

    delay_value:set_visible(false)
    jitter_value:set_visible(false)
    min_jitter_value:set_visible(false)
    max_jitter_value:set_visible(false)

    if menu_val == 2 or menu_val == 3 then
        run_jitter = true
        delay_value:set_visible(true)
        jitter_value:set_visible(menu_val == 2)
        min_jitter_value:set_visible(menu_val == 3)
        max_jitter_value:set_visible(menu_val == 3)
        jitter_menu:set(1)
        timer = global_vars.real_time()
    end
end

handle_menu()

local enable_clantag = menu.add_checkbox("Misc","Clantag")

local enabled_ref = menu.add_checkbox("Misc", "AI Auto Peek", false)
local size_ref = menu.add_slider("Misc", "AI Indicator", 100, 1200)
local color_ref = size_ref:add_color_picker("Color")

local peek_text_ref = menu.add_text("Misc", "Automatic peek")
local peek_ref = peek_text_ref:add_keybind("automatic peek key")

local reduce_fov_ref = menu.find("visuals", "other", "general", "zoom fov")
local stupid2_ref, auto_peek_ref = unpack(menu.find("aimbot", "general", "misc", "autopeek"))

local function __thiscall(func, this)
    -- bind wrapper for __thiscall functions
    return function(...)
        return func(this, ...)
    end
end

local function vtable_bind(module, interface, index, type)
    local addr = ffi.cast("void***", memory.create_interface(module, interface)) or error(interface .. " is nil.")
    return __thiscall(ffi.cast(ffi.typeof(type), addr[0][index]), addr)
end

local nativeDrawSetColor = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 15, "void(__thiscall*)(void*, int, int, int, int)")
local nativeDrawOutlinedCircle = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 103, "void(__thiscall*)(void*, int, int, int, int)")

local surface = {}

function surface.draw_outlined_circle(x, y, r, g, b, a, radius, segments)
    nativeDrawSetColor(r, g, b, a)
    return nativeDrawOutlinedCircle(x, y, radius, segments)
end

local function degree_to_radian(degree)
    return (math.pi / 180) * degree
end

local function angle_to_vector (angle)
    local pitch = degree_to_radian(angle.x)
    local yaw = degree_to_radian(angle.y)
    return vec3_t(math.cos(pitch) * math.cos(yaw), math.cos(pitch) * math.sin(yaw), -math.sin(pitch))
end

local function better_angle_to_vector (x, y)
    local pitch = degree_to_radian(x)
    local yaw = degree_to_radian(y)
    return math.cos(pitch) * math.cos(yaw), math.cos(pitch) * math.sin(yaw), -math.sin(pitch)
end

local function dist_to (vec1, vec2)
    return math.sqrt(math.pow(vec1.x - vec2.x, 2) + math.pow(vec1.y - vec2.y, 2) + math.pow(vec1.z - vec2.z, 2))
end

local function dist_to_2d (vec1, vec2)
    return math.sqrt(math.pow(vec1.x - vec2.x, 2) + math.pow(vec1.y - vec2.y, 2))
end

local function getCameraPositionInaccurate()
    local local_player = entity_list.get_local_player()
    local eye_pos = local_player:get_eye_position()
    if not client.is_in_thirdperson() then
        return eye_pos
    end
    local local_angle = angle_to_vector(engine.get_view_angles())
    local camera_pos = vec3_t(local_angle.x * -130 + eye_pos.x, local_angle.y * -130 + eye_pos.y, local_angle.z * -130 + eye_pos.z)
    local trace_result = trace.line(eye_pos, camera_pos, local_player)
    local camera_pos = vec3_t(local_angle.x * -128 * trace_result.fraction + eye_pos.x, local_angle.y * -128 * trace_result.fraction + eye_pos.y, local_angle.z * -128 * trace_result.fraction + eye_pos.z)
    return camera_pos
end

local function adjustAngle(angle)
    if angle < 0 then
        angle = (90 + angle * (-1))
    elseif angle > 0 then
        angle = (90 - angle)
    end

    return angle
end

local function get_velocity(player)
    local velocity = player:get_prop("m_vecVelocity")
    return math.sqrt(velocity.x * velocity.x, velocity.y * velocity.y)
end

local render_factor = 1

local function update_scale()
    local local_player = entity_list.get_local_player()
    if local_player == nil or not local_player:is_alive() then
        return
    end
    local weapon = local_player:get_active_weapon()
    if weapon == nil then
        return
    end
    local zoom = weapon:get_prop("m_zoomLevel")
    render_factor = 1
    if zoom ~= nil and zoom > 0 then
        local fov = local_player:get_prop("m_iFOV")
        if fov < 90 then
            render_factor = 2.6 * (reduce_fov_ref:get() + 100) / 100
        end
        if fov < 40 then
            render_factor = 6 * (reduce_fov_ref:get() + 100) / 100
        end
    end
end

local hit_pos = {}
local hit_size = {}

local mapping = {
    weapon_ssg08 = 'scout',
    weapon_awp = 'awp',
    weapon_scar20 = 'auto',
    weapon_g3sg1 = 'auto',
    weapon_deagle = 'deagle',
    weapon_revolver = 'revolver'
}

local color = color_ref:get()
local color_border = color_ref:get()
color_border = color_t(color_border.r * 1.8 > 255 and 255 or math.floor(color_border.r * 1.8), color_border.g * 1.8 > 255 and 255 or math.floor(color_border.g * 1.8), color_border.b * 1.8 > 255 and 255 or math.floor(color_border.b * 1.8, 200))
color.a = 150
local size = size_ref:get()

local dmg1 = 0
local dmg2 = 0

local hitscan = { 4, 2, 0, 6 }

local eye_pos = vec3_t(0, 0, 0)
local auto_side = 0

local last_auto_peek = false

local function handle_auto_peek(cmd, origin, pos, speed)
    if pos == nil or origin == nil then
        return
    end
    local vec2pos_x, vec2pos_y = pos.x - origin.x, pos.y - origin.y
    local angle2pos = math.atan2(vec2pos_y, vec2pos_x) * (180 / math.pi)
    local view = engine.get_view_angles()
    local viewyaw = view.y - 180
    local moveangle = (adjustAngle(angle2pos - viewyaw) + 90) * (math.pi / 180)
    cmd.move.x = math.cos(moveangle) * speed
    cmd.move.y = math.sin(moveangle) * speed
end

local function on_setup_command(cmd)
    if not enabled_ref:get() then
        hit_pos = {}
        hit_size = {}
        last_auto_peek = false
        return
    end
    local local_player = entity_list.get_local_player()
    local enemies_1 = entity_list.get_players(true)
    local enemies = {}
    for _, v in pairs(enemies_1) do
        if not v:is_dormant() and v:is_alive() then
            table.insert(enemies, v)
        else
            hit_pos[v:get_index()] = nil
        end
    end
    if #enemies == 0 then
        hit_pos = {}
        hit_size = {}
        last_auto_peek = false
        return
    end

    local enemy = enemies[1 + global_vars.tick_count() % #enemies]
    if global_vars.tick_count() % 32 == 0 then
        update_scale()
    end
    local cameraPos = getCameraPositionInaccurate()
    if cameraPos == nil then
        return
    end
    if peek_ref:get() and not last_auto_peek then
        eye_pos = local_player:get_eye_position()
        auto_side = 0
    elseif not peek_ref:get() then
        eye_pos = local_player:get_eye_position()
    end
    last_auto_peek = peek_ref:get()

    local enemy_pos = enemy:get_render_origin()
    local vec2enemy_x, vec2enemy_y = eye_pos.x - enemy_pos.x, eye_pos.y - enemy_pos.y
    local ang2enemy = math.atan2(vec2enemy_y, vec2enemy_x) * (180 / math.pi)

    local extrapolate_distance = 30 + get_velocity(local_player) / 15

    local left_x, left_y, left_z = better_angle_to_vector(0, ang2enemy + 90)
    local right_x, right_y, right_z = better_angle_to_vector(0, ang2enemy - 90)
    local eye_left = vec3_t(left_x * extrapolate_distance + eye_pos.x, left_y * extrapolate_distance + eye_pos.y, eye_pos.z)
    local eye_right = vec3_t(right_x * extrapolate_distance + eye_pos.x, right_y * extrapolate_distance + eye_pos.y, eye_pos.z)
    local trace_result_left = trace.line(eye_pos, eye_left, local_player).fraction * 0.99
    local trace_result_right = trace.line(eye_pos, eye_right, local_player).fraction * 0.99
    eye_left = vec3_t(left_x * extrapolate_distance * trace_result_left + eye_pos.x, left_y * extrapolate_distance * trace_result_left + eye_pos.y, eye_pos.z)
    eye_right = vec3_t(right_x * extrapolate_distance * trace_result_right + eye_pos.x, right_y * extrapolate_distance * trace_result_right + eye_pos.y, eye_pos.z)

    local dmg_vis = dmg1 == 100 and enemy:get_prop("m_iHealth") or dmg1
    local dmg_hid = dmg2 == 100 and enemy:get_prop("m_iHealth") or dmg2

    for _, i in ipairs(hitscan) do
        local hitpos = enemy:get_hitbox_pos(i)
        local trace_result_left = trace.bullet(eye_left, hitpos, local_player, enemy)
        if (trace_result_left.valid and trace_result_left.damage > (trace_result_left.pen_count > 0 and dmg_hid or dmg_vis)) then
            hit_pos[enemy:get_index()] = hitpos
            hit_size[enemy:get_index()] = math.atan(10 / (2 * dist_to(cameraPos, hitpos))) * size
            if auto_side == 0 then
                auto_side = eye_left
            end
            goto
            auto
        end
        local trace_result_right = trace.bullet(eye_right, hitpos, local_player, enemy)
        if (trace_result_right.valid and trace_result_right.damage > (trace_result_right.pen_count > 0 and dmg_hid or dmg_vis)) then
            hit_pos[enemy:get_index()] = hitpos
            hit_size[enemy:get_index()] = math.atan(10 / (2 * dist_to(cameraPos, hitpos))) * size
            if auto_side == 0 then
                auto_side = eye_right
            end
            goto
            auto
        end
        local trace_result_mid = trace.bullet(eye_pos, hitpos, local_player, enemy)
        if (trace_result_mid.valid and trace_result_mid.damage > (trace_result_mid.pen_count > 0 and dmg_hid or dmg_vis)) then
            hit_pos[enemy:get_index()] = hitpos
            hit_size[enemy:get_index()] = math.atan(10 / (2 * dist_to(cameraPos, hitpos))) * size
            return
        end

    end
    hit_pos[enemy:get_index()] = nil
    :: auto ::
    local dopeek = false
    for i, v in pairs(hit_pos) do
        if v ~= nil then
            dopeek = true
            break
        end
    end
    if last_auto_peek then
        if not dopeek or not client.can_fire() then
            auto_side = 0
            local distance = dist_to_2d(eye_pos, local_player:get_render_origin())
            if distance > 1 then
                handle_auto_peek(cmd, local_player:get_render_origin(), eye_pos, math.max(10, math.min(450, math.pow(distance, 2.5))))
            end
        else
            if auto_side ~= 0 then
                handle_auto_peek(cmd, local_player:get_render_origin(), auto_side, 450)
            end
        end
    end
end

local _set_clantag = ffi.cast('int(__fastcall*)(const char*, const char*)', memory.find_pattern('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))
local _last_clantag = nil

local set_clantag = function(v)
  if v == _last_clantag then return end
  _set_clantag(v, v)
  _last_clantag = v
end

local tag = {
    'F',
    'Fa',
    'Fad',
    'Fade',
    'Fade.',
    'Fade.l',
    'Fade.lu',
    'Fade.lua',
    'Fade.lua',
    'Fade.lua',
    'Fade.lua'
} 


callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)

local function on_item_equip(event)
    if not enabled_ref:get() then
        return
    end
    if engine.get_player_index_from_user_id(event.userid) == engine.get_local_player_index() then
        color = color_ref:get()
        color_border = color_ref:get()
        color_border = color_t(color_border.r * 1.8 > 255 and 255 or math.floor(color_border.r * 1.8), color_border.g * 1.8 > 255 and 255 or math.floor(color_border.g * 1.8), color_border.b * 1.8 > 255 and 255 or math.floor(color_border.b * 1.8, 200))
        size = size_ref:get()
        color.a = 150
        client.delay_call(function()
            local local_player = entity_list.get_local_player()
            if local_player == nil then
                return
            end
            local weapon = local_player:get_active_weapon()
            if weapon == nil then
                return
            end
            local weapon_data = weapon:get_weapon_data()
            local weapon_group = "other"
            if mapping[weapon_data.console_name] ~= nil then
                weapon_group = mapping[weapon_data.console_name]
            elseif
            weapon_data.type == 2 then
                weapon_group = "pistols"
            elseif
            weapon_data.type == 3 or weapon_data.type == 4 then
                weapon_group = "other"
            end
            local mindmg, mindmg_enabled = unpack(menu.find("aimbot", weapon_group, "target overrides", "force min. damage"))
            if mindmg_enabled:get() then
                dmg1 = mindmg:get()
                dmg2 = dmg1
            else
                dmg1 = menu.find("aimbot", weapon_group, "targeting", "min. damage"):get()
                dmg2 = menu.find("aimbot", weapon_group, "targeting", "override autowall damage"):get() and menu.find("aimbot", weapon_group, "targeting", "autowall"):get() or dmg1
            end
        end, 0.1)
        update_scale()
    end
end

callbacks.add(e_callbacks.EVENT, on_item_equip, "item_equip")

local function on_weapon_zoom(event)
    if not enabled_ref:get() then
        return
    end
    if engine.get_player_index_from_user_id(event.userid) == engine.get_local_player_index() then
        update_scale()
    end
end

callbacks.add(e_callbacks.EVENT, on_weapon_zoom, "weapon_zoom")
callbacks.add(e_callbacks.EVENT, on_weapon_zoom, "weapon_fire")

local function on_player_death(event)
    if engine.get_player_index_from_user_id(event.userid) == engine.get_local_player_index() then
        update_scale()
        hit_pos = {}
        hit_size = {}
    end
end

callbacks.add(e_callbacks.EVENT, on_player_death, "player_death")

local function on_paint()
    if not enabled_ref:get() then
        return
    end

    if last_auto_peek then
        local screen_pos = render.world_to_screen(vec3_t(eye_pos.x, eye_pos.y, eye_pos.z - 16))
        if screen_pos ~= nil then
            render.circle_filled(screen_pos, 25, color)
        end
    end

    local cbr, cbg, cbb = color_border.r, color_border.g, color_border.b

    for i, v in pairs(hit_pos) do
        local screen_pos = render.world_to_screen(v)
        if screen_pos ~= nil then
            local circle_size = math.ceil(hit_size[i] * render_factor)
            render.circle_filled(screen_pos, circle_size, color)
            local outline = math.ceil(hit_size[i] * render_factor / 3)
            for x = 0, outline do
                nativeDrawSetColor(cbr, cbg, cbb, 255 - (250 / outline) * x)
                nativeDrawOutlinedCircle(screen_pos.x, screen_pos.y, circle_size + x, 10 + circle_size / 2)
            end
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)

local yawadd    = menu.find("antiaim", "main", "angles", "yaw add")
local side      = menu.find("antiaim", "main", "desync", "side")
local leftamt   = menu.find("antiaim", "main", "desync", "left amount")
local rigtamt   = menu.find("antiaim", "main", "desync", "right amount")
local moveaa    = menu.find("antiaim", "main", "desync", "move", "")
local antibrut  = menu.find("antiaim", "main", "desync", "anti bruteforce")

local bCrouchin = false
local bInAir    = false
local BInMove   = false

local checkbox = menu.add_checkbox("Visual", "Indicator")
local enable_detector = menu.add_checkbox("Visual","Primordial Detector",false)
local switch_id = menu.add_selection( "Misc ", "Fast Weapon Switch [After Zeus]",  {"Primary", "Secondry", "Knife" } )
local teleport = menu.add_text("Movement", "Force Teleport"):add_keybind("Teleport")

local indicfont = render.create_font("Tahoma", 12, 300, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local screen_size = render.get_screen_size()
local x, y = screen_size.x / 2, screen_size.y / 2
local dtenabled = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local hsenabled = menu.find("aimbot", "general", "exploits", "hideshots", "enable")

local multi_selection = menu.add_multi_selection("Animation Breaker", "selection", {"Static Legs [Walk/Run]", "Static Legs [SlowWalk]", "Static Legs [In Air]", "Lean in Air/Move"})
local find_slow_walk_name, find_slow_walk_key = unpack(menu.find("misc","main","movement","slow walk"))

local engine_client_interface = memory.create_interface("engine.dll", "VEngineClient014")
local get_net_channel_info = ffi.cast("void*(__thiscall*)(void*)",memory.get_vfunc(engine_client_interface,78))
local net_channel_info = get_net_channel_info(ffi.cast("void***",engine_client_interface))
local get_latency = ffi.cast("float(__thiscall*)(void*,int)",memory.get_vfunc(tonumber(ffi.cast("unsigned long",net_channel_info)),9))

local function clantag_animation()
    if not engine.is_connected() then return end

    local latency = get_latency(ffi.cast("void***",net_channel_info),1) / global_vars.interval_per_tick()
    local tickcount_pred = global_vars.tick_count() + latency
    local iter = math.floor(math.fmod(tickcount_pred / 24, #tag) + 1)
    if enable_clantag:get() then
        set_clantag(tag[iter])
    else
        set_clantag("")
    end 
end

local function clantag_destroy()
    set_clantag("")
end

callbacks.add(e_callbacks.PAINT, function()
    clantag_animation()
end)

callbacks.add(e_callbacks.SHUTDOWN, function()
    clantag_destroy()
end)

function on_paint()
    if not engine.is_connected() then
        return
    end

    if not engine.is_in_game() then
        return
    end

    local local_player = entity_list.get_local_player()

    if not local_player:get_prop("m_iHealth") then
        return
    end

    if local_player:is_alive() and checkbox:get() then
        local ind_dst = 0
        local ind_spr = 8
        local text = "BASIC"
        local size = render.get_text_size(indicfont, text)

        render.text(indicfont, "Fade.lua", vec2_t(x, y + 40), color_t(218, 118, 0))

        if aatyp:get() == 1 then
            render.text(indicfont, "Default", vec2_t(x, y + 50), color_t(234, 115, 255))
        elseif aatyp:get() == 2 then
            render.text(indicfont, "Aggressive", vec2_t(x, y + 50), color_t(234, 115, 255))
        elseif aatyp:get() == 3 then
            render.text(indicfont, "Aggressive v2", vec2_t(x, y + 50), color_t(234, 115, 255))
        elseif aatyp:get() == 4 then
            render.text(indicfont, "Static", vec2_t(x, y + 50), color_t(234, 115, 255))
        elseif aatyp:get() == 5 then
            render.text(indicfont, "Centered Jitter", vec2_t(x, y + 50), color_t(234, 115, 255))
        elseif aatyp:get() == 6 then
            render.text(indicfont, "Dynamic", vec2_t(x, y + 50), color_t(234, 115, 255))
        end


        local dt_color = color_t(0, 0, 0, 0)
        local hs_color = color_t(234, 115, 255)

        if dtenabled[2]:get() then
            if exploits.get_charge() < 1 then
                dt_color = color_t(255, 0, 0)
            else
                dt_color = color_t(0, 255, 0)
            end
        end

        --DT
        if dtenabled[2]:get() then
            render.text(indicfont, "DT", vec2_t(x, y + 60 + ind_dst), dt_color)
        else
            render.text(indicfont, "DT", vec2_t(x, y + 60 + ind_dst), color_t(0, 0, 0, 0))
        end
        if hsenabled[2]:get() and not dtenabled[2]:get() then
            render.text(indicfont, "HS", vec2_t(x, y + 60 + ind_dst), hs_color)
        else
            render.text(indicfont, "HS", vec2_t(x, y + 60 + ind_dst), color_t(0, 0, 0, 0))
        end
    end
end


local function new_wpn()
    local choice = switch_id:get()
    if choice == 1 then return "slot1" end
    if choice == 2 then return "slot2" end
    if choice == 3 then return "slot3" end
end

local function on_aimbot_shoot(shot)
local local_player = entity_list:get_local_player()
local weapon = entity_list.get_entity(local_player:get_prop("m_hActiveWeapon"))
local weapon_name = weapon:get_name()
if weapon_name ~= "taser" then return end
    engine.execute_cmd(new_wpn())
end


callbacks.add(e_callbacks.PAINT, function()
    aatyp:set_visible(enable:get())

    if enable:get() then
        leftamt2:set_visible(aatyp:get() == 6,5)
        rigtamt2:set_visible(aatyp:get() == 6,5)
        side2:set_visible(aatyp:get() == 6)
        modifiers:set_visible(aatyp:get() == 6)
        modifierssta:set_visible(aatyp:get() == 6)--jitter_angle_1
        jitter_angle_1:set_visible(aatyp:get() == 6)--jitter_angle_1
        jitter_angle_2:set_visible(aatyp:get() == 6)--jitter_angle_1
        selection_item:set_visible(aatyp:get() == 5)--jitter_angle_1
        jitter_value:set_visible(aatyp:get() == 5)--jitter_angle_1
        min_jitter_value:set_visible(aatyp:get() == 5)--jitter_angle_1
        max_jitter_value:set_visible(aatyp:get() == 5)--jitter_angle_1
        delay_value:set_visible(aatyp:get() == 5)--jitter_angle_1



        --animrsolver:set_visible(aatyp:get() == 6)


    else
        leftamt2:set_visible(false)
        rigtamt2:set_visible(false)
        side2:set_visible(false)
       jitter_angle_1:set_visible(false)
       jitter_angle_2:set_visible(false)
       selection_item:set_visible(false)
       jitter_value:set_visible(false)
       min_jitter_value:set_visible(false)
       max_jitter_value:set_visible(false)
       delay_value:set_visible(false)


        modifiers:set_visible(false)
        modifierssta:set_visible(false)
        do_auto_direct:set_visible(true)

    end

    menu.find("antiaim", "main", "desync", "override stand#move"):set(false)
    menu.find("antiaim", "main", "desync", "override stand#slow walk"):set(false)
end)

local function is_prim_user(ent) -- if use give credits -_-
    if not ent or not ent:is_player() then
        return false
    end
    
    local public_level = player_resource.get_prop("m_nPersonaDataPublicLevel", ent:get_index())
    return public_level == 2233
end

auto_direct:set(do_auto_direct() + 1)


local function on_esp(ctx)
    if not enable_detector:get() then
        return
    end

    if not is_prim_user(ctx.player) then
        return
    end

    ctx:add_flag("Fade.lua",color_t(226,181,199))
end

callbacks.add(e_callbacks.PLAYER_ESP, on_esp)
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)
callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.SUPPORTIVE_RECTANGLE, on_supportive_rectangle)
menu.add_callback(selection_item, handle_menu)




callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    local local_player = entity_list.get_local_player()

    function setup_comm(cmd)
        if teleport:get() then
            exploits.force_uncharge()
            exploits.block_recharge()
        else
            exploits.allow_recharge()
        end
    end

    auto_direct:set(do_auto_direct() + 1)

    local vjitter_angle_1 = jitter_angle_1:get()
    local vjitter_angle_2 = jitter_angle_2:get()

    if not local_player:has_player_flag(e_player_flags.ON_GROUND) then
		bInAir = true
	else
		bInAir = false
	end

    if not local_player:has_player_flag(e_animlayers.AIMMATRIX) then
		BInMove = true
	else
		BInMove = false
	end

    if not local_player:has_player_flag(e_animlayers.LEAN) then
		BInMove = true
	else
		BInMove = false
	end

    if not local_player:has_player_flag(e_animlayers.MOVEMENT_MOVE) then
		BInMove = true
	else
		BInMove = false
	end

    if cmd:has_button(e_cmd_buttons.DUCK) and not inaircrc then
        bCrouchin = true
    else
        bCrouchin = false
    end
end)

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
    local local_player = entity_list.get_local_player()
    local bRunOnceAir  = nil
    local bRunOnceGrnd = nil

local lp = entity_list.get_local_player()
local sexgod = lp:get_prop("m_vecVelocity[1]") ~= 0    
    if multi_selection:get(1) then
        ctx:set_render_pose(e_poses.RUN, 0)
    end
    if find_slow_walk_key:get() and multi_selection:get(2) then
        ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0.0, 0.0)
    end
    if multi_selection:get(4) then
        if sexgod then
            ctx:set_render_animlayer(e_animlayers.LEAN, 1)
        end
    end
    if multi_selection:get(3) then
        ctx:set_render_pose(e_poses.JUMP_FALL, 1)
    end
    
    if enable:get() then
    if aatyp:get() == 1 then
        yawadd:set(-17)
        leftamt:set(79)
        rigtamt:set(83)
        if not bInAir then
            side:set(7)
            yawadd:set(17)
        elseif bInAir and bCrouchin then
            yawadd:set(-13)
            side:set(5)
            leftamt:set(58)
            rigtamt:set(58)
        end

    elseif aatyp:get() == 2 then
        yawadd:set(10)
        rigtamt:set(60)
        leftamt:set(45)

        if not bInAir then
            side:set(4)
            yawadd:set(-10)
        elseif bInAir and bCrouchin then
            yawadd:set(10)
            side:set(7)
        end

        elseif aatyp:get() == 3 then
            yawadd:set(-26)
            rigtamt:set(75)
            leftamt:set(55)
            side:set(4)

        elseif aatyp:get() == 4 then
            yawadd:set(-10)
            rigtamt:set(89)
            leftamt:set(90)
            if not bInAir then
                side:set(7)
                yawadd:set(-15)
            elseif bInAir and bCrouchin then
                yawadd:set(-15)
                side:set(4)
            end

        elseif aatyp:get() == 4 then
            yawadd:set(-10)
            leftamt:set(leftamt2:get() * 60/6)
            rigtamt:set(rigtamt2:get() * 90/6)


        elseif aatyp:get() == 6 then
            yawadd:set(0)
            leftamt:set(leftamt2:get() * 10/9)
            rigtamt:set(rigtamt2:get() * 10/9)

            if not modifiers:get(1) and not modifiers:get(2) then
                side:set(side2:get() + 1)
            end

            if modifiers:get(1) then
                if bInAir then
                    bRunOnceAir = false
                    side:set(3)
                else
                    if not bRunOnceAir then
                        side:set(side2:get() + 1)
                        bRunOnceAir = true
                    end
                end
            end

            if modifiers:get(2) then
                if bCrouchin then
                    side:set(3)
                    bRunOnceGrnd = false
                else
                    if not bRunOnceGrnd then
                        side:set(side2:get() + 1)
                        bRunOnceGrnd = true
                    end
                end
            end
                --modifierssta
            if modifiers:get(3) then
                if bInAir then
                    bRunOnceAir = false
                    jitter_angle_1:set(20)
                    jitter_angle_2:set(-20)
                    rigtamt:set(-91)
                    leftamt:set(91)
                else
                    if not bRunOnceAir then
                        jitter_angle_1:set(20)
                        jitter_angle_2:set(-20)
                        rigtamt:set(-91)
                        leftamt:set(91)
                        bRunOnceAir = true
                    end
                end

                if modifierssta:get(1) then
                    if BInMove then
                        bRunOnceGrnd = false
                        side:set(3)
                    else
                        if not bRunOnceGrnd then
                            side:set(side2:get() + 3)
                            bRunOnceGrnd = true
                        end
                    end
                end

                if modifierssta:get(2) then
                    if BInMove then
                        bRunOnceGrnd = false
                        side:set(3)
                    else
                        if not bRunOnceGrnd then
                            side:set(side2:get() + 0)
                            bRunOnceGrnd = true
                        end
                    end
                end
            end
        end
    end
end)

    local function __thiscall(func, this) -- bind wrapper for __thiscall functions
        return function(...)
            return func(this, ...)
        end
    end
    
    local interface_ptr = ffi.typeof("void***")
    local vtable_bind = function(module, interface, index, typedef)
        local addr = ffi.cast("void***", memory.create_interface(module, interface)) or safe_error(interface .. " is nil.")
        return __thiscall(ffi.cast(typedef, addr[0][index]), addr)
    end
    
    local vtable_entry = function(instance, i, ct)
        return ffi.cast(ct, ffi.cast(interface_ptr, instance)[0][i])
    end
    
    local vtable_thunk = function(i, ct)
        local t = ffi.typeof(ct)
        return function(instance, ...)
            return vtable_entry(instance, i, t)(instance, ...)
        end
    end
    
    local nativeCBaseEntityGetClassName = vtable_thunk(143, "const char*(__thiscall*)(void*)")
    local nativeCBaseEntitySetModelIndex = vtable_thunk(75, "void(__thiscall*)(void*,int)")
    
    local nativeClientEntityListGetClientEntityFromHandle = vtable_bind("client.dll", "VClientEntityList003", 4, "void*(__thiscall*)(void*,void*)")
    local nativeModelInfoClientGetModelIndex = vtable_bind("engine.dll", "VModelInfoClient004", 2, "int(__thiscall*)(void*, const char*)")
    
    local list_names =
    {
        'Dallas',
        'Battle Mask',
        'Evil Clown',
        'Anaglyph',
        'Boar',
        'Bunny',
        'Bunny Gold',
        'Chains',
        'Chicken',
        'Devil Plastic',
        'Hoxton',
        'Pumpkin',
        'Samurai',
        'Sheep Bloody',
        'Sheep Gold',
        'Sheep Model',
        'Skull',
        'Template',
        'Wolf',
        'Doll',
    }
    
    local filepath = {
        'player/holiday/facemasks/facemask_dallas',
        'player/holiday/facemasks/facemask_battlemask',
        'player/holiday/facemasks/evil_clown',
        'player/holiday/facemasks/facemask_anaglyph',
        'player/holiday/facemasks/facemask_boar',
        'player/holiday/facemasks/facemask_bunny',
        'player/holiday/facemasks/facemask_bunny_gold',
        'player/holiday/facemasks/facemask_chains',
        'player/holiday/facemasks/facemask_chicken',
        'player/holiday/facemasks/facemask_devil_plastic',
        'player/holiday/facemasks/facemask_hoxton',
        'player/holiday/facemasks/facemask_pumpkin',
        'player/holiday/facemasks/facemask_samurai',
        'player/holiday/facemasks/facemask_sheep_bloody',
        'player/holiday/facemasks/facemask_sheep_gold',
        'player/holiday/facemasks/facemask_sheep_model',
        'player/holiday/facemasks/facemask_skull',
        'player/holiday/facemasks/facemask_template',
        'player/holiday/facemasks/facemask_wolf',
        'player/holiday/facemasks/porcelain_doll',
    }
    
    local masks = menu.add_selection("Mask Changer", "Select", list_names)
    local custom_models = menu.add_checkbox("Mask Changer", "Enable Custom Model / Disable Currently", false)
    local custom_modes_path = menu.add_text_input("Mask Changer", "Path")
    
    callbacks.add(e_callbacks.PAINT, function()
    
        local local_player = entity_list.get_local_player()
    
        if local_player == nil then return end
    
        local models = ""
    
        if custom_models:get() then
            custom_modes_path:set_visible(true)
            models = custom_modes_path:get()
        else
            custom_modes_path:set_visible(false)
            models = "models/" .. filepath[masks:get()] .. ".mdl"
        end
    
        local modelIndex = nativeModelInfoClientGetModelIndex(models)
        if modelIndex == -1 then
            client.precache_model(models)
        end
        modelIndex = nativeModelInfoClientGetModelIndex(models)
    
        local local_player = entity_list.get_local_player()
    
        local lpAddr = ffi.cast("intptr_t*", local_player:get_address())
    
        local m_AddonModelsHead = ffi.cast("intptr_t*", lpAddr + 0x462F) -- E8 ? ? ? ? A1 ? ? ? ? 8B CE 8B 40 10
        local m_AddonModelsInvalidIndex = -1
    
        local i, next = m_AddonModelsHead[0], -1
    
        while i ~= m_AddonModelsInvalidIndex do
            next = ffi.cast("intptr_t*", lpAddr + 0x462C)[0] + 0x18 * i -- this is the pModel (CAddonModel) afaik
            i = ffi.cast("intptr_t*", next + 0x14)[0]
    
            local m_pEnt = ffi.cast("intptr_t**", next)[0] -- CHandle<C_BaseAnimating> m_hEnt -> Get()
            local m_iAddon = ffi.cast("intptr_t*", next + 0x4)[0]
    
            if tonumber(m_iAddon) == 16 and modelIndex ~= -1 then -- face mask addon bits
                local entity = nativeClientEntityListGetClientEntityFromHandle(m_pEnt)
                nativeCBaseEntitySetModelIndex(entity, modelIndex)
            end
        end
    end)
    
    callbacks.add(e_callbacks.NET_UPDATE, function()
        local local_player = entity_list.get_local_player()
        if local_player == nil then return end
        if bit.band(local_player:get_prop("m_iAddonBits"), 0x10000) ~= 0x10000 then
            local_player:set_prop("m_iAddonBits", 0x10000 + local_player:get_prop("m_iAddonBits"))
        end
    end)