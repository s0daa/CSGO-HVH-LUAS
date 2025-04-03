--Made by: Astral#1001
local logs = {}
local fonts = nil
local wantTimer = menu.add_checkbox("Animated Hit Logs", "Enable Timer", true)
local fontSelection = menu.add_selection("Animated Hit Logs", "Font Selection", {"Regular", "Bold"})


local function onPaint()
    if(fonts == nil) then
        fonts =
        {
            regular = render.create_font("Verdana", 12, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW);
            bold = render.create_font("Verdana Bold", 12, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW);
        }
    end

    if (engine.is_connected() ~= true) then
        return
    end

    local time = global_vars.frame_time()

    local screenSize = render.get_screen_size()
    local screenWidth = screenSize.x
    local screenHeight = screenSize.y

    for i = 1, #logs do
        local log = logs[i]
        if log == nil then goto continue
        end
        local x = screenWidth / 2
        local y = screenHeight / 1.25 + (i * 15)
        local alpha = 0

        if (log.state == 'appearing') then
            -- Fade in.
            local progress = log.currentTime / log.lifeTime.fadeIn
            x = x - Lerp(log.offset, 0, Ease(progress))
            alpha = Lerp(0, 255, Ease(progress))

            log.currentTime = log.currentTime + time
            if (log.currentTime >= log.lifeTime.fadeIn) then
                log.state = 'visible'

                -- Reset time.
                log.currentTime = 0
            end


        elseif(log.state == 'visible') then
        -- Fully opaque.
        alpha = 255

        log.currentTime = log.currentTime + time
        if (log.currentTime >= log.lifeTime.visible) then
            log.state = 'disappearing'

            -- Reset Time.
            log.currentTime = 0
        end

        elseif(log.state == 'disappearing') then
            -- Fade out.
            local progress = log.currentTime / log.lifeTime.fadeOut
            x = x + Lerp(0, log.offset, Ease(progress))
            alpha = Lerp(255, 0, Ease(progress))

            log.currentTime = log.currentTime + time
            if(log.currentTime >= log.lifeTime.fadeOut) then
                table.remove(logs, i)
                goto continue
            end
        end

        -- Increase the total time.
        log.totalTime = log.totalTime + time

        alpha = math.floor(alpha)
        local white = color_t(236, 236, 236, alpha)
        local accent_color_text, accent_color_color = unpack(menu.find("misc", "main", "config", "accent color"))
        local detail = accent_color_color:get()
        detail.a = alpha

        local message = {}

        -- Add header and body to message
        local combined = {}

        for a = 1, #log.header do
            local t = log.header[a]
            table.insert(combined, t)
        end

        for a = 1, #log.body do
            local t = log.body[a]
            table.insert(combined, t)
        end

        for j = 1, #combined do
            local data = combined[j]

            local text = tostring(data[1])
            local color = data[2]

            -- Push the data to the message.
            table.insert(message,{text, color and detail or white})
        end

        -- Add the total lifetime to the message.
        if wantTimer:get() then
            table.insert(message,{' - ', white})
            local temp = (log.lifeTime.fadeIn + log.lifeTime.visible + log.lifeTime.fadeOut) - log.totalTime
            table.insert(message, {string.format("%.1fs", temp), detail})
        elseif not wantTimer:get() then
            
        end
        -- Draw log.
        local render_font = nil
        if render_font == nil then
        local stringFont = fontSelection:get()
        if stringFont == 1 then render_font = fonts.regular
            else render_font = fonts.bold
            end
        end

        render.string(x, y, message, 'c', render_font)
        ::continue::
    end
end

local hitgroupMap = {
    [0] = 'generic',
    [1] = 'head',
    [2] = 'chest',
    [3] = 'stomach',
    [4] = 'left arm',
    [5] = 'right arm',
    [6] = 'left leg',
    [7] = 'right leg',
    [8] = 'neck',
    [9] = 'gear'
  }

function on_aimbot_hit(hit)
    local name = hit.player:get_name()
    local hitbox = hitgroupMap[hit.hitgroup]
    local damage = hit.damage
    local health = hit.player:get_prop('m_iHealth')

    AddLog('PlayerHitEvent', {
        {'Hit ', false};
        {name .. ' ', true};
        {'in the ', false};
        {hitbox .. ' ', true};
        {'for ', false};
        {damage .. ' ', true};
        {'damage (remaining: ', false};
        {health, true};
        {')', false};
    })
end

function on_aimbot_miss(miss)
    local name = miss.player:get_name()
    local hitbox = hitgroupMap[miss.aim_hitgroup]
    local damage = miss.aim_damage
    local health = miss.player:get_prop('m_iHealth')
    local reason = miss.reason_string

    AddLog('PlayerHitEvent', {
        {'Missed ', false};
        {name .. ' ', true};
        {'in the ', false};
        {hitbox .. ' ', true};
        {'due to ', false};
        {reason .. ' ', true};
    })
end

function AddLog(type, body)
    local log = {
        type = type,
        state = 'appearing',
        offset = 250,
        currentTime = 0,
        totalTime = 0,
        lifeTime = {
            fadeIn = 0.75,
            visible = 3,
            fadeOut = 0.75
        },
        header = {
            {'[', false},
            {'prim', true},
            {'] ', false},
        },
        body = body
    }
    table.insert(logs, log)
end

function Lerp(from, to, progress) 
    return from + (to - from) * progress
end

function Ease(progress)
    return progress < 0.5 and 15 * progress * progress * progress * progress * progress or 1 - math.pow(-2 * progress + 2, 5) / 2
end

render.string = function(x, y, data, alignment, font)
    -- Get total length for all the data.
    local length = 0
    for i = 1, #data do
        local text = data[i][1]
        
        local size = render.get_text_size(font, text)
        length = length + size.x
    end

    local offset = x
    for i = 1, #data do
        local text = data[i][1]
        local color = data[i][2]

        local sX = offset
        local sY = y

        -- Adjust position based on alignment
        if(alignment) == 'l' then
            sX = offset - length
        elseif(alignment) == 'c' then
            sX = offset - (length / 2)
        elseif(alignment) == 'r' then
            sX = offset
        end



        -- Draw the text.

        render.text(font, text, vec2_t(sX + 1, sY + 1), color_t(16, 16, 16, color.a))
        render.text(font, text, vec2_t(sX, sY), color)

        -- Add the length of the text to the offset.
        local size = render.get_text_size(font, text)
        offset = offset + size.x
    end
end


callbacks.add(e_callbacks.PAINT,onPaint)
callbacks.add(e_callbacks.AIMBOT_MISS,on_aimbot_miss)
callbacks.add(e_callbacks.AIMBOT_HIT,on_aimbot_hit)

local Water_tog = menu.add_checkbox("MetaMod Watermark", "Enable")
local Water_Col = Water_tog:add_color_picker("Watermark Color")
local verdana = render.create_font("Verdana", 12, 24, e_font_flags.ANTIALIAS)
local get_screen = render.get_screen_size()

local function Watermark()
    if Water_tog:get() then
        local x = (get_screen.x);
		local tick = client.get_tickrate()
        local fps = client.get_fps()
		local WatermarkText = string.format(" Primordial.dev | %s | fps: %i | tick: %s", user.name, fps, tick)
		local text_size = 12,12
        render.rect_filled(vec2_t(1680, 17), vec2_t(230, 3), Water_Col:get())
        render.rect_filled(vec2_t(1680, 18), vec2_t(230, 17), color_t(0,0,0,150))
        render.text(verdana, WatermarkText, vec2_t(1680, 19), color_t(255,255,255,255))
    end  
end

callbacks.add(e_callbacks.PAINT, Watermark)

local new_weapon_struct = ffi.typeof([[
    struct{
        char pad_0000[461]; //0x0000
        bool shouldnt_draw_view; //0x01CD classy is a baller also dont paste my code u fkin kidz grr
        char pad_01CE[115]; //0x01CE
    }
]])

local viewmodel_enable = menu.add_checkbox("viewmodel scope","allow viewmodel in scope")
local sig = memory.find_pattern("client.dll", "8B 35 ?? ?? ?? ?? FF 10 0F B7 C0") or error("IWeaponSystem signature invalid")
local weapon_system_raw = ffi.cast("void****", ffi.cast("char*", sig) + 0x2)[0]
local get_weapon_info = memory.get_vfunc(tonumber(ffi.cast("unsigned int",weapon_system_raw)), 2) or error("invalid GetCSWeaponInfo index")
local get_weapon_info_fn = ffi.cast( ffi.typeof("$*(__thiscall*)(void*, unsigned int)",new_weapon_struct),get_weapon_info)

local function paint_callback()
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end


    if not local_player:is_player() or not local_player:is_alive() then
        return
    end

    local active_weapon = local_player:get_active_weapon()
    if (active_weapon == nil) then
        return
    end

    local index = active_weapon:get_prop("m_iItemDefinitionIndex")
    if(index == nil) then
        return
    end
    local get_weapon_info_data = get_weapon_info_fn(weapon_system_raw,index)

    if(get_weapon_info_data == nil) then
        return
    end

    get_weapon_info_data.shouldnt_draw_view = not viewmodel_enable:get()
end

local function on_shutdown()
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end

    if not local_player:is_player() or not local_player:is_alive() then
        return
    end

    local active_weapon = local_player:get_active_weapon()
    if (active_weapon == nil) then
        return
    end

    local index = active_weapon:get_prop("m_iItemDefinitionIndex")
    if(index == nil) then
        return
    end
    local get_weapon_info_data = get_weapon_info_fn(weapon_system_raw,index)

    if(get_weapon_info_data == nil) then
        return
    end

    get_weapon_info_data.shouldnt_draw_view = true
end

callbacks.add(e_callbacks.SHUTDOWN,on_shutdown)

callbacks.add(e_callbacks.PAINT,paint_callback)

local function watermarkDraw()
    return ""
end

callbacks.add(e_callbacks.DRAW_WATERMARK, watermarkDraw)

local scope_master = menu.add_checkbox("custom scope", "[enable] custom scope", false)
local scope_color = scope_master:add_color_picker("[enable] custom scope color")
local scope_offset = menu.add_slider("custom scope", "[scope] offset", 0, 500, 1, 0)
local scope_padding = menu.add_slider("custom scope", "[scope] padding", -250, 250, 1, 0)

scope_offset:set(0)
scope_padding:set(0)

local function scope_render()
    if not scope_master:get() then return end
    local screen_size = render.get_screen_size()
    local screen_center = vec2_t(screen_size.x / 2, screen_size.y / 2)
    local lp = entity_list.get_local_player()
    if lp == nil then return end
    local health = lp:get_prop("m_iHealth")
    if health == 0 then return end
    local weap = lp:get_active_weapon()
    if weap == nil then return end
    local is_scoped = weap:get_prop("m_zoomLevel")
    local scoped_prop = lp:get_prop("m_bIsScoped")
    local in_scope = scoped_prop == 1 and true or false

    if in_scope == nil or not in_scope then return end
    if is_scoped == 0 or is_scoped == nil then return end
    local offset = scope_offset:get()

    pos = vec2_t(screen_center.x, screen_center.y - offset)
    size = vec2_t(1, offset)
    pos.y = pos.y - (scope_padding:get() - 1)
    render.rect_fade(pos, size, color_t(0, 0, 0, 0), scope_color:get())

    pos = vec2_t(screen_center.x, screen_center.y + (offset * 0 ))
    size = vec2_t(1, offset - ( offset * 0 ))
    pos.y = pos.y + scope_padding:get()
    render.rect_fade(pos, size, scope_color:get(), color_t(0, 0, 0, 0))

    pos = vec2_t(screen_center.x - offset, screen_center.y)
    size = vec2_t(offset, 1)
    pos.x = pos.x - (scope_padding:get() - 1)
    render.rect_fade(pos, size, color_t(0, 0, 0, 0), scope_color:get(), true)

    pos = vec2_t(screen_center.x + (offset * 0 ), screen_center.y)
    size = vec2_t(offset - ( offset * 0 ), 1)
    pos.x = pos.x + scope_padding:get()
    render.rect_fade(pos, size, scope_color:get(), color_t(0, 0, 0, 0), true)
end

callbacks.add(e_callbacks.PAINT, scope_render)

local calibri = render.create_font("Calibri", 29, 700, e_font_flags.ANTIALIAS)
local main_font = render.create_font("Calibri", 12, 400)
local screen_size = render.get_screen_size() -- screen
local ctx = screen_size.x / 2
local cty = screen_size.y / 2
local x = screen_size.x / 2
local y = screen_size.y / 2

local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") -- get doubletap
local hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")
local force_baim = menu.find("aimbot", "scout", "target overrides", "force hitbox")
local min_damage = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local lethal = menu.find("aimbot", "heavy pistols", "target overrides", "force lethal shot")

local enabled = true

-- weapon damages

local min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local min_damage_r = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
local min_damage_d = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")
local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
local amount_revolver = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local amount_deagle = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
local amount_pistol = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))

local function getweapon()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then
    
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end

        weapon_name = active_weapon:get_name()


    else return end

    return weapon_name

end

local switch_id = menu.add_selection( "Fast Switch After Zues ", "Weapon",  {"Primary", "Secondry", "Knife" } )

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
    
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)

local animation_breaker = {}

animation_breaker.anim_breaker = menu.add_multi_selection("Global", "Animation Breaker", {"Ground", "Air", "Zero Pitch on Land"})

animation_breaker.ground_tick = 1
animation_breaker.end_time = 0
animation_breaker.handle = function (poseparam)
    local localPlayer = entity_list.get_local_player()

    if not localPlayer then
        return
    end

    local flags = localPlayer:get_prop("m_fFlags")
    local on_land = bit.band(flags, bit.lshift(1, 0)) ~= 0
    local is_in_air = bit.band(flags, bit.lshift(1, 0)) == 0

    local curtime = global_vars.cur_time()

    if on_land == true then
        animation_breaker.ground_tick = animation_breaker.ground_tick + 1
    else
        animation_breaker.ground_tick = 0
        animation_breaker.end_time = curtime + 1
    end


    if animation_breaker.anim_breaker:get(1) then
        poseparam:set_render_pose(e_poses.RUN, 1)
    end

    if animation_breaker.anim_breaker:get(2) and is_in_air then
        poseparam:set_render_pose(e_poses.JUMP_FALL, 1)
    end

    if animation_breaker.anim_breaker:get(3) and animation_breaker.ground_tick > 1 and animation_breaker.end_time > curtime then
        poseparam:set_render_pose(e_poses.BODY_PITCH, 0.5)
    end
end

callbacks.add(e_callbacks.ANTIAIM, animation_breaker.handle)