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

local function watermarkDraw()
    return ""
end

callbacks.add(e_callbacks.DRAW_WATERMARK, watermarkDraw)

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
local leg_slide       = menu.find("antiaim", "main", "general", "leg slide"     )

 ---------------------------------------------------------------------------
--] Save Initial Settings [--
local sYaw_base        = yaw_base:get()
local sRotate_enable   = rotate_enable:get()
local sMrotate_range   = mrotate_range:get()
local sMrotate_speed   = mrotate_speed:get()
local sDesync_side     = desync_side:get()
local sDesync_amount_l = desync_amount_l:get()
local sDesync_amount_r = desync_amount_r:get()
local sAntibrute       = antibrute:get()
local sCheat_jitter    = cheat_jitter:get()
local sAuto_direct     = auto_direct:get()
local sPitch           = pitch:get()
local sOnshot          = onshot:get()
local sOverride_stand  = override_stand:get()
local sLeg_slide       = leg_slide:get()
-- uses these to revert settings on shutdown

 ---------------------------------------------------------------------------
 --] MENU ELEMENTS [--
 
 --] Welcom message :3 [--
 local text = menu.add_text("Welcome!","Username: "..user.name.."          \n")
 local text2 = menu.add_text("Welcome!","UserID: "..user.uid.."          \n")




-- global variables
local state    = 0
local side     = 0
local uid      = user.uid
local name     = user.name

 --] Anti-Aim [--

 -- presets
local presets = menu.add_selection("anti aim", "presets", {"none", "jitter inwards fake", "jitter outwards fake", "aggressive jitter", "small jitter (hs only)", "large fake jitter"})

-- jitter builder 
local jitter_builder  = menu.add_checkbox("anti aim", "jitter builder")
local jitter_angle_1  = menu.add_slider("anti aim", "jitter angle 1", -180, 180)
local jitter_angle_2  = menu.add_slider("anti aim", "jitter angle 2", -180, 180)

local desync_amount_1 = menu.add_slider("anti aim", "desync amount 1", -100, 100)
local desync_amount_2 = menu.add_slider("anti aim", "desync amount 2", -100, 100) 

local mjitter_speed   = menu.add_slider("anti aim", "jitter speed", 1, 3)

local mpitch          = menu.add_selection("menu options", "pitch", {"none", "down", "up", "zero", "jitter"})

local mOnshot         = menu.add_selection("menu options", "onshot", {"off", "opposite", "same side", "random"})

local mleg_slide      = menu.add_selection("menu options", "leg slide", {"neutral", "never", "always", "jitter"})

local rotate          = menu.add_checkbox("anti aim", "rotate")
local rotate_angle    = menu.add_slider("anti aim", "rotate range", 0, 360)
local rotate_speed    = menu.add_slider("anti aim", "rotate speed", 0, 100)

local velocity_jitter = menu.add_checkbox("anti aim", "velocity jitter")
local vel_max_angle   = menu.add_slider("anti aim", "velocity jitter max angle", 0, 180)
local vel_min_angle   = menu.add_slider("anti aim", "velocity jitter min angle", 0, 180)
local vel_multiplier  = menu.add_slider("anti aim", "velocity multiplier", 0, 100, 1, 0, "%")

local do_auto_direct  = menu.add_selection("menu options", "auto direction mode", {"none", "viewangle", "at targets (crosshair)", "at targets (distance)", "velocity"})

local do_antibrute    = menu.add_checkbox("menu options", "anti bruteforce")


menu.set_group_column("anti aim", 2)

-- Indicators menu stuff 
local enable = menu.add_checkbox("indicators", "enable indicators")
local color  = enable:add_color_picker("indicator color")

local jitter_side        = menu.add_checkbox("indicators", "jitter side arrows")
local jitter_size        = menu.add_slider("indicators", "jitter side arrow size", 0, 100)
local jitter_side_offset = menu.add_slider("indicators", "jitter side arrow offset", -25, 200)

local watermark          = menu.add_checkbox("indicators", "custom watermark")

local time_indicator     = menu.add_checkbox("indicators", "time indicator")
local time_color         = time_indicator:add_color_picker("outline color")
local time_x_pos         = menu.add_slider("indicators", "time x pos", 0, 1920)
local time_y_pos         = menu.add_slider("indicators", "time y pos", 0, 1080)

local box       = menu.add_checkbox("indicators", "indicator box")
local box_color = box:add_color_picker("outline color")
local x_pos     = menu.add_slider("indicators", "box x pos", 0, 1920)
local y_pos     = menu.add_slider("indicators", "box y pos", 0, 1080)

local font  = render.create_font("Verdana", 12, 565, e_font_flags.OUTLINE)
local font1 = render.create_font("Verdana", 12, 20, e_font_flags.OUTLINE)
local font4 = render.create_font("Verdana", 55, 32, e_font_flags.OUTLINE)
local font2 = render.create_font("Segoe UI", 14, 700, e_font_flags.OUTLINE)
local font3 = render.create_font("Segoe UI", 14, 550, e_font_flags.OUTLINE)

menu.set_group_column("indicators", 1)
---------------------------------------------------------------------------

local function main(cmd)

    -- some menu shit 
    vel_max_angle:set_visible(velocity_jitter:get())
    vel_min_angle:set_visible(velocity_jitter:get()) -- hide if not selected
    vel_multiplier:set_visible(velocity_jitter:get())

    box:set_visible(enable:get())
    x_pos:set_visible(box:get())
    y_pos:set_visible(box:get())

    jitter_side:set_visible(enable:get())
    jitter_side_offset:set_visible(jitter_side:get())
    jitter_size:set_visible(jitter_side:get())

    watermark:set_visible(enable:get())
    time_indicator:set_visible(enable:get())
    time_x_pos:set_visible(time_indicator:get())
    time_y_pos:set_visible(time_indicator:get())

    if enable:get() == false then
        box:set_visible(false)
        x_pos:set_visible(false)
        y_pos:set_visible(false)
        jitter_side:set_visible(false)
        jitter_side_offset:set_visible(false)
        jitter_size:set_visible(false)
        time_x_pos:set_visible(false)
        time_y_pos:set_visible(false)
    end

    --] Do shit for velocity jitter and angles [--
    local vel_mult              = vel_multiplier:get() / 100
    local vel_min               = vel_min_angle:get()
    local vel_max               = vel_max_angle:get()

    local local_player          = entity_list.get_local_player()
    local velocity              = local_player:get_prop("m_vecVelocity"):length()   
    local velocity_jitter_angle = velocity * vel_mult

    
    if velocity_jitter_angle < vel_min then
        velocity_jitter_angle = vel_min
    end

    if velocity_jitter_angle > vel_max then
        velocity_jitter_angle = vel_max
    end


    -- shit to make it so user settings dont mess with it 
    cheat_jitter:set(1) -- Im using yaw offset to do jitter, this would fuck with it
    override_stand:set(false) -- only does jitter for stand so it would fuck with it


    ---------------------------------------------------------------------------
    --] Do AntiAim [--
    local preset = presets:get()

    --] Do presets [--
    if preset == 2 then   -- jitter inwards fake
        jitter_angle_1:set(20)
        jitter_angle_2:set(-20)
        desync_amount_1:set(-91)
        desync_amount_2:set(91)
    end

    if preset == 3 then   -- jitter outwards fake
        jitter_angle_1:set(30)
        jitter_angle_2:set(-30)
        desync_amount_1:set(91)
        desync_amount_2:set(-91)
    end

    if preset == 4 then   -- aggressive jitter
        jitter_angle_1:set(40)
        jitter_angle_2:set(-40)
        desync_amount_1:set(92)
        desync_amount_2:set(-92)

        rotate_enable:set(true)
        mrotate_range:set(2)
        mrotate_speed:set(100)
    end

    if preset == 5 then   -- small jitter (hs only)
        jitter_angle_1:set(8)
        jitter_angle_2:set(5)
        desync_amount_1:set(20)
        desync_amount_2:set(8)

        rotate_enable:set(true)
        mrotate_range:set(1)
        mrotate_speed:set(55)
    end

    if preset == 6 then   -- large fake jitter
        jitter_angle_1:set(13)
        jitter_angle_2:set(-13)
        desync_amount_1:set(100)
        desync_amount_2:set(-100)
    end

    local vjitter_angle_1 = jitter_angle_1:get()
    local vjitter_angle_2 = jitter_angle_2:get()
    local vdesync_amount_1 = desync_amount_1:get()
    local vdesync_amount_2 = desync_amount_2:get()

    if velocity_jitter:get() then
        vjitter_angle_1 = velocity_jitter_angle
        vjitter_angle_2 = velocity_jitter_angle * -1
    end


    --] Jitter Builder [--
    local tick_count = global_vars.tick_count()

    if jitter_builder:get() then
        local jitter_speed = mjitter_speed:get() + 1

        if state > 0 then 
            yaw_base:set(vjitter_angle_1)

            if vjitter_angle_1 > 0 then
                side = 1
            else
                side = 0
            end

            if vdesync_amount_1 < 0 then 
                desync_side:set(2)
                desync_amount_l:set(vdesync_amount_1 * -1)
                desync_amount_r:set(vdesync_amount_1 * -1)
            else
                desync_side:set(3)
                desync_amount_l:set(vdesync_amount_1)
                desync_amount_r:set(vdesync_amount_1)
            end

        else
            yaw_base:set(vjitter_angle_2)

            if vjitter_angle_2 > 0 then
                side = 1
            else
                side = 0
            end

            if vdesync_amount_2 < 0 then 
                desync_side:set(2)
                desync_amount_l:set(vdesync_amount_2 * -1)
                desync_amount_r:set(vdesync_amount_2 * -1)
            else
                desync_side:set(3)
                desync_amount_l:set(vdesync_amount_2)
                desync_amount_r:set(vdesync_amount_2)
            end
        end
        state = state + 1
        if state > jitter_speed then state = jitter_speed * -1 
        end
    end

    --] Do Auto direction [--
    auto_direct:set(do_auto_direct() + 1)

    --] Rotate [--
    local vrotate_speed = rotate_speed:get()
    local vrotate_range = rotate_angle:get()

    if  rotate:get() then
        rotate_enable:set(true)
        mrotate_speed:set(vrotate_speed)
        mrotate_range:set(vrotate_range)
    else 
        rotate_enable:set(false)
    end


    --] Anti Bruteforce [--
    if  do_antibrute:get() then
        antibrute:set(true)
    else
        antibrute:set(false)
    end


    --] Pitch [--
    pitch:set(mpitch() + 1)


    --] Onshot [--
    onshot:set(mOnshot() + 1)

    --] Leg Slide [--
    leg_slide:set(mleg_slide() + 1)

    ---------------------------------------------------------------------------

end

local function on_paint()
    if enable:get() then
        if engine.is_in_game() then
            -- variables and shit
            local x             = x_pos:get()
            local y             = y_pos:get()
            local iJitter_speed = mjitter_speed:get()
            local pos           = vec2_t(x, y)
            local color1        = color:get()
            local size          = jitter_size:get()
            local offset        = jitter_side_offset:get()
            local tickrate      = client.get_tickrate()
            local fps           = client.get_fps()
            local ping          = math.floor(engine.get_latency(e_latency_flows.OUTGOING) * 1000)
            local hr, min, sec  = client.get_local_time()
            local name_size     = render.get_text_size(font2, tostring(name))
            local time_x        = time_x_pos:get()
            local time_y        = time_y_pos:get()
            local time          = ("%02d:%02d:%02d"):format(hr, min, sec)
            local time_size     = render.get_text_size(font4, time)
            local time_color_1  = time_color:get()
            local box_color_1   = box_color:get()


            -- indicator box
            if box:get() then

                render.rect_filled(vec2_t(x, y), vec2_t(150, 100), color_t(9, 16, 18))
                render.rect(vec2_t(x + 2, y + 2), vec2_t(146, 96), color_t(box_color_1[0], box_color_1[1], box_color_1[2], box_color_1[3]))

                render.text(font1, "Velocity jitter", pos+vec2_t(32, 15), color_t(255, 255, 255, 255))
                render.text(font1, "Jitter builder", pos+vec2_t(32, 35), color_t(255, 255, 255, 255))
                render.text(font1, "Jitter speed", pos+vec2_t(40, 55), color_t(255, 255, 255, 255))

                render.text(font1, "0", pos+vec2_t(10, 70), color_t(255, 255, 255, 255))
                render.text(font1, "3", pos+vec2_t(132, 70), color_t(255, 255, 255, 255))

                -- slider
                render.rect_filled(pos+vec2_t(20, 69), vec2_t(iJitter_speed * 36, 14), color_t(color1[0], color1[1], color1[2]))

                render.rect(pos+vec2_t(19, 38), vec2_t(8, 8), color_t(0, 0, 0))
                render.rect(pos+vec2_t(19, 18), vec2_t(8, 8), color_t(0, 0, 0))
                render.rect(pos+vec2_t(19, 69), vec2_t(110, 15), color_t(100, 100, 100))

                -- checkboxes
                if velocity_jitter:get() then
                    render.rect_filled(pos+vec2_t(20, 19), vec2_t(6, 6), color_t(color1[0], color1[1], color1[2]))
                else
                    render.rect_filled(pos+vec2_t(20, 19), vec2_t(6, 6), color_t(40, 40, 40))
                end

                if jitter_builder:get() then
                    render.rect_filled(pos+vec2_t(20, 39), vec2_t(6, 6), color_t(color1[0], color1[1], color1[2]))
                else
                    render.rect_filled(pos+vec2_t(20, 39), vec2_t(6, 6), color_t(40, 40, 40))
                end
            end

            -- jitter side shit
            if jitter_side:get() then
                if jitter_builder:get() then

                    -- side 1 = right side
                    if side == 1 then
                        render.triangle_filled(vec2_t.new(1020 + offset, 540), size, color_t.new(color1[0], color1[1], color1[2]),  90)
                        render.triangle_filled(vec2_t.new(900 - offset, 540), size, color_t.new(33, 33, 33, 225), -90)
                    end

                    -- side 0 = left side
                    if side == 0 then
                        render.triangle_filled(vec2_t.new(900 - offset, 540), size, color_t.new(color1[0], color1[1], color1[2]), -90)
                        render.triangle_filled(vec2_t.new(1020 + offset, 540), size, color_t.new(33, 33, 33, 225), 90)
                    end
                    
                end
            end

            if watermark:get() then
                -- name size shit is used to change name background size based on how long the name is

                -- boxes
                render.rect_filled(vec2_t(1665 + 50 - name_size[0], 6), vec2_t(250 - 50 + name_size[0], 18), color_t(9, 16, 35), 4)
                render.rect_filled(vec2_t(1665 + 50 - name_size[0], 6), vec2_t(name_size[0] + 7, 18), color_t(color1[0], color1[1], color1[2]), 3)

                -- name
                render.text(font2, name, vec2_t(1668 + 50 - name_size[0], 8), color_t(255, 255, 255, 255))

                -- ping (round trip time)
                render.text(font1, "rtt:", vec2_t(1727, 8), color_t(255, 255, 255, 255))
                render.text(font1, tostring(ping), vec2_t(1745, 8), color_t(255, 255, 255, 255))

                -- fps
                render.text(font1, "fps:", vec2_t(1775, 8), color_t(255, 255, 255, 255))
                render.text(font1, tostring(fps), vec2_t(1795, 8), color_t(255, 255, 255, 255))

                -- tickrate
                render.text(font1, "tick:", vec2_t(1827, 8), color_t(255, 255, 255, 255))
                render.text(font1, tostring(tickrate), vec2_t(1851, 8), color_t(255, 255, 255, 255))

                -- uid
                render.text(font1, tostring(uid), vec2_t(1880, 8), color_t(255, 255, 255, 255))
                
                -- bar that makes it so the right side of name background isnt rounded                   
                render.rect_filled(vec2_t(1665 + 50 - name_size[0] + name_size[0] + 6, 6), vec2_t(4, 18), color_t(9, 16, 35))
                -- seperators
                render.rect_filled(vec2_t(1768, 9), vec2_t(1, 12), color_t(26, 41, 72))
                render.rect_filled(vec2_t(1820, 9), vec2_t(1, 12), color_t(26, 41, 72))
                render.rect_filled(vec2_t(1875, 9), vec2_t(1, 12), color_t(26, 41, 72))
            end

            -- time box/indicator
            if time_indicator:get() then

                -- the box and outline
                render.rect_filled(vec2_t(time_x, time_y), vec2_t(time_size[0] + 30, 75), color_t(9, 16, 18))
                render.rect(vec2_t(time_x + 2, time_y + 2), vec2_t(time_size[0] + 26, 71), color_t(time_color_1[0], time_color_1[1], time_color_1[2], time_color_1[3]))

                -- text/time
                render.text(font4, tostring(time), vec2_t(time_x + 15, time_y + 8), color_t(255, 255, 255, 255))

            end

        end
    end
end

local function on_shutdown()
    --] Restore Initial Settings [--
    yaw_base:set(sYaw_base)       
    rotate_enable:set(sRotate_enable) 
    mrotate_range:set(sMrotate_range)  
    mrotate_speed:set(sMrotate_speed)  
    desync_side:set(sDesync_side)    
    desync_amount_l:set(sDesync_amount_l)                                
    desync_amount_r:set(sDesync_amount_r)
    antibrute:set(sAntibrute)     
    cheat_jitter:set(sCheat_jitter)   
    auto_direct:set(sAuto_direct)    
    pitch:set(sPitch)                                                        
    onshot:set(sOnshot)                
    override_stand:set(sOverride_stand)        
    leg_slide:set(sLeg_slide)                 

    print("Settings restored.")
    print("Bye!")
end
    

local font_inds = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE) -- font

local screen_size = render.get_screen_size() -- screen
local x, y = screen_size.x / 2, screen_size.y / 2 -- x and y

local checkbox = menu.add_checkbox("Indicator", "Turn On") -- checkbox ( turn on the indicator)

local text_inds = 10

local dt_ref = menu.find("aimbot","general","exploits","doubletap","enable") -- get doubletap
local hs_ref = menu.find("aimbot","general","exploits","hideshots","enable") -- get hideshots
local direction = menu.find("antiaim","main","auto direction","enable") -- get auto direction 
local damage_override = menu.find("aimbot", "auto", "target overrides", "force min. damage") -- get damage override

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

    local baim_color = color_t(255,255,255,255)
	local hs_color = color_t(255,255,255,255)
	local sp_color = color_t(255,255,255,255)
	local fakeduck_color = color_t(255,255,255,255)
    local damage_color = color_t(255,255,255,255)

    if local_player:is_alive() then
        if checkbox:get() then

            local ind_dst = 0
            local ind_spr = 8

            local text = "BASIC"
            local size = render.get_text_size(font_inds, text)

            if direction[2]:get() then
                acatel_style_2 = "FREESTAND"
            elseif antiaim.is_inverting_desync() then
                acatel_style_2 = "JITTER"
            else
                acatel_style_2 = "JITTER"
            end

            render.text(font_inds, "REQUIEM  ", vec2_t(x, y + 20.5), color_t(226, 195, 225, 225))            
                render.text(font_inds, "SMART:  ", vec2_t(x, y + 28.5), color_t(220, 91, 97, 255)) -- render text
                render.text(font_inds, acatel_style_2, vec2_t(x + 29, y + 28), color_t(138, 137, 204, 255)) -- render text
                    
                local dt_color = color_t(1,1,1,255)
                    
                if dt_ref[2]:get() then
                    
                    if exploits.get_charge() < 1 then
                        dt_color = color_t(255,0,0,255)
                    else
                        dt_color = color_t(255,255,255,255)
                    end
                end
                    
                --DT
                if dt_ref[2]:get() then
                    render.text(font_inds, "DT", vec2_t(x, y + 36 + ind_dst), dt_color) -- render text
                else
                    render.text(font_inds, "DT", vec2_t(x, y + 36 + ind_dst), color_t(48,48,48,255)) -- render tex
                end

                -- hideshots
                if hs_ref[2]:get() then
                    render.text(font_inds, "HS", vec2_t(x + 13, y + 36 + ind_dst), hs_color) -- render text
                else
                    render.text(font_inds, "HS", vec2_t(x + 13, y + 36 + ind_dst), color_t(48,48,48,255)) -- render text
                end

                -- safepoint
                if antiaim.is_fakeducking() then
                    render.text(font_inds, "FD", vec2_t(x + 26, y + 36 + ind_dst), fakeduck_color) -- render text
                else
                    render.text(font_inds, "FD", vec2_t(x + 26, y + 36 + ind_dst), color_t(48,48,48,255)) -- render text
                end

                -- damage override
                if damage_override[2]:get() then
                    render.text(font_inds, "DMG", vec2_t(x + 39, y + 36 + ind_dst), damage_color) -- render text
                else
                    render.text(font_inds, "DMG", vec2_t(x + 39, y + 36 + ind_dst), color_t(48,48,48,255)) -- render text
                end
        end
    end
end

callbacks.add(e_callbacks.AIMBOT_MISS,on_aimbot_miss)
callbacks.add(e_callbacks.AIMBOT_HIT,on_aimbot_hit)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.SETUP_COMMAND, main)
callbacks.add(e_callbacks.PAINT, on_paint)