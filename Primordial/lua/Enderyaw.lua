--] Tank AA code
local jitter_add = menu.find("antiaim", "main", "angles", "jitter add"    )
local Yaw_base        = menu.find("antiaim", "main", "angles", "yaw add"        )

local desync_side     = menu.find("antiaim", "main", "desync", "side"           ) 
local desync_amount_l = menu.find("antiaim", "main", "desync", "left amount"    )
local desync_amount_r = menu.find("antiaim", "main", "desync", "right amount"   ) 
local antibrute       = menu.find("antiaim", "main", "desync", "anti bruteforce")
local cheat_jitter    = menu.find("antiaim", "main", "angles", "jitter mode"    )
local slowwalk_key    = menu.find("misc", "main", "movement", "slow walk"       )[2]

local text = menu.add_text("Welcome!","Username: "..user.name.."          \n")
local text2 = menu.add_text("Welcome!","UserID: "..user.uid.."          \n")
local text3 = menu.add_text("Welcome!","Hope you Enjoy the lua :)           \n")

local menu_condition  = menu.add_selection("Anti-Aim Builder", "Conditions", {"Stand", "Move", "Slow walk", "Air", "Crouching"}) 
local Yawslider  = menu.add_slider("Anti-Aim Builder", "Yaw Base", -180, 180)
local slider  = menu.add_slider("Anti-Aim Builder", "Centered Jitter Angle", -180, 180)
local desync_l  = menu.add_slider("Anti-Aim Builder", "Left Desync Amount", 0, 100)
local desync_r  = menu.add_slider("Anti-Aim Builder", "Right Desync Amount", 0, 100)
local Override_move   = menu.add_checkbox("Anti-Aim Builder", "Override Stand (Moving)")
local Override_slow   = menu.add_checkbox("Anti-Aim Builder", "Override Stand (Slow Walk)") 
local Override_air    = menu.add_checkbox("Anti-Aim Builder", "Override Stand (Air)") 
local Override_duck   = menu.add_checkbox("Anti-Aim Builder", "Override Stand (Duck)") 
-- move 
local Yawslider_move  = menu.add_slider("Anti-Aim Builder", "Yaw Base", -180, 180)
local slider_move  = menu.add_slider("Anti-Aim Builder", "Centered Jitter Angle", -180, 180)
local desync_l_move  = menu.add_slider("Anti-Aim Builder", "Left Desync Amount", 0, 100)
local desync_r_move  = menu.add_slider("Anti-Aim Builder", "Right Desync Amount", 0, 100)
-- slow 
local Yawslider_slow  = menu.add_slider("Anti-Aim Builder", "Yaw Base", -180, 180)
local slider_slow  = menu.add_slider("Anti-Aim Builder", "Centered Jitter Angle", -180, 180)
local desync_l_slow  = menu.add_slider("Anti-Aim Builder", "Left Desync Amount", 0, 100)
local desync_r_slow  = menu.add_slider("Anti-Aim Builder", "Right Desync Amount", 0, 100)
-- air 
local Yawslider_air  = menu.add_slider("Anti-Aim Builder", "Yaw Base", -180, 180)
local slider_air  = menu.add_slider("Anti-Aim Builder", "Centered Jitter Angle", -180, 180)
local desync_l_air  = menu.add_slider("Anti-Aim Builder", "Left Desync Amount", 0, 100)
local desync_r_air  = menu.add_slider("Anti-Aim Builder", "Right Desync Amount", 0, 100)
-- duck
local Yawslider_duck  = menu.add_slider("Anti-Aim Builder", "Yaw Base", -180, 180)
local slider_duck  = menu.add_slider("Anti-Aim Builder", "Centered Jitter Angle", -180, 180)
local desync_l_duck  = menu.add_slider("Anti-Aim Builder", "Left Desync Amount", 0, 100)
local desync_r_duck  = menu.add_slider("Anti-Aim Builder", "Right Desync Amount", 0, 100)







local condition = 0
local state     = 0
local side      = 0

local function main(cmd)
    local local_player          = entity_list.get_local_player()
    local velocity              = local_player:get_prop("m_vecVelocity"):length()   
    if velocity == 0 then  
        condition = 1 -- stand
    end
    if velocity > 0 then
        condition = 2 -- move
    end
    if Override_slow:get() then
        if slowwalk_key:get() then
            condition = 3 -- slow walk
        end
    end
    if local_player:get_prop("m_vecVelocity[2]") ~= 0 then 
        condition = 4  -- air
    end
    local crouch_key = input.find_key_bound_to_binding("duck")
    if  input.is_key_held(crouch_key) then
      condition = 5 --crouch
    end

    cheat_jitter:set(2)   --sets jitter mode to static

    -- general stuff for conditions to work
    local yawcondition = Yawslider:get()
    local jittercondition = slider:get()
    local ldesync_condition = desync_l:get()
    local rdesync_condition = desync_r:get()


    if Override_move:get() then
        if condition == 2 then 
           yawcondition = Yawslider_move:get()
           jittercondition = slider_move:get()
           ldesync_condition = desync_l_move:get()
           rdesync_condition = desync_r_move:get()
        end
    end
    if Override_slow:get() then
        if condition == 3 then 
           yawcondition = Yawslider_slow:get()
           jittercondition = slider_slow:get()
           ldesync_condition = desync_l_slow:get()
           rdesync_condition = desync_r_slow:get()
        end
    end
    if Override_air:get() then
        if condition == 4 then 
           yawcondition = Yawslider_air:get()
           jittercondition = slider_air:get()
           ldesync_condition = desync_l_air:get()
           rdesync_condition = desync_r_air:get()
        end
    end
    if Override_air:get() then
        if condition == 5 then 
           yawcondition = Yawslider_duck:get()
           jittercondition = slider_duck:get()
           ldesync_condition = desync_l_duck:get()
           rdesync_condition = desync_r_duck:get()
        end
    end


    Yaw_base:set(yawcondition)
    jitter_add:set(jittercondition)
    desync_amount_l:set(ldesync_condition)
    desync_amount_r:set(rdesync_condition)



end


local function menu_shit()
        menu_condition:set_visible(true)
        Yawslider:set_visible(false)
        slider:set_visible(false)
        desync_l:set_visible(false)
        desync_r:set_visible(false)
        Yawslider_air:set_visible(false)
        slider_air:set_visible(false)
        desync_l_air:set_visible(false)
        desync_r_air:set_visible(false)
        Yawslider_duck:set_visible(false)
        slider_duck:set_visible(false)
        desync_l_duck:set_visible(false)
        desync_r_duck:set_visible(false)
        Yawslider_move:set_visible(false)
        slider_move:set_visible(false)
        desync_l_move:set_visible(false)
        desync_r_move:set_visible(false)
        Yawslider_slow:set_visible(false)
        slider_slow:set_visible(false)
        desync_l_slow:set_visible(false)
        desync_r_slow:set_visible(false)
        Override_air:set_visible(false)
        Override_duck:set_visible(false)
        Override_move:set_visible(false)
        Override_slow:set_visible(false)




    -- making sure visible shit doesnt fuck up, I cant do smart code im high af rn
    
    
end


local function on_paint()
    menu_shit()
    -- centered conditions
    if menu_condition:get() == 1 then
        Yawslider:set_visible(true)
        slider:set_visible(true)
        desync_l:set_visible(true)
        desync_r:set_visible(true)
    end

    if menu_condition:get() == 2 then
        Override_move:set_visible(true)
        Yawslider_move:set_visible(true)
        slider_move:set_visible(true)
        desync_l_move:set_visible(true)
        desync_r_move:set_visible(true)
        
        if not Override_move:get() then
            Yawslider_move:set_visible(false)
            slider_move:set_visible(false)
            desync_l_move:set_visible(false)
            desync_r_move:set_visible(false)
        end
    end

    if menu_condition:get() == 3 then
        Override_slow:set_visible(true)
        Yawslider_slow:set_visible(true)
        slider_slow:set_visible(true)
        desync_l_slow:set_visible(true)
        desync_r_slow:set_visible(true)

        if not Override_slow:get() then
            Yawslider_slow:set_visible(false)
            slider_slow:set_visible(false)
            desync_l_slow:set_visible(false)
            desync_r_slow:set_visible(false)
        end
    end

    if menu_condition:get() == 4 then
        Override_air:set_visible(true)
        Yawslider_air:set_visible(true)
        slider_air:set_visible(true)
        desync_l_air:set_visible(true)
        desync_r_air:set_visible(true)


        if not Override_air:get() then 
            Yawslider_air:set_visible(false)
            slider_air:set_visible(false)
            desync_l_air:set_visible(false)
            desync_r_air:set_visible(false)
        end

    end

    if menu_condition:get() == 5 then
        Override_duck:set_visible(true)
        Yawslider_duck:set_visible(true)
        slider_duck:set_visible(true)
        desync_l_duck:set_visible(true)
        desync_r_duck:set_visible(true)
        if not Override_duck:get() then
            Yawslider_duck:set_visible(false)
            slider_duck:set_visible(false)
            desync_l_duck:set_visible(false)
            desync_r_duck:set_visible(false)
        end
    end


end
    


callbacks.add(e_callbacks.SETUP_COMMAND, main) 
callbacks.add(e_callbacks.PAINT, on_paint)

--] leg anims
local multi_selection = menu.add_multi_selection("Leg Anim", "selection", {"Reverse Slide", "Static when slow walk"})
local find_slow_walk_name, find_slow_walk_key = unpack(menu.find("misc","main","movement","slow walk"))

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
    if multi_selection:get(1) then
        ctx:set_render_pose(e_poses.RUN, 0)
    end

    if find_slow_walk_key:get() and multi_selection:get(2) then
        ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0.0, 0.0)
    end
end)

--] Fakelag Onshot

local forcesendnextpacket = false
local function on_aimbot_shoot(shot)
    forcesendnextpacket = true
end

callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)
function on_antiaim(ctx)
    if forcesendnextpacket then
    ctx:set_fakelag(false) 
    forcesendnextpacket = false
    end
end

callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
--] Auto Teleport
local function are_have_weapon(ent)
    if not ent:is_alive() or not ent:get_active_weapon() then return end
    local t_cur_wep = ent:get_active_weapon():get_class_name()
    return t_cur_wep ~= "CKnife" and t_cur_wep ~= "CC4" and t_cur_wep ~= "CMolotovGrenade" and t_cur_wep ~= "CSmokeGrenade" and t_cur_wep ~= "CHEGrenade" and t_cur_wep ~= "CWeaponTaser"
end
local function are_them_visibles(ent)
    local local_p = entity_list:get_local_player()
    local generic_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    local left_arm_pos = ent:get_hitbox_pos(e_hitgroups.LEFT_ARM)
    local right_arm_pos = ent:get_hitbox_pos(e_hitgroups.RIGHT_ARM)
    if local_p:is_point_visible(generic_pos) or local_p:is_point_visible(left_arm_pos) or local_p:is_point_visible(right_arm_pos) then return true else return false end
end
local function strangerdranger(cmd)
    if not enabled:get() then return end
    if not key:get() then return end
    if ragebot.get_autopeek_pos() then return end
    local enemies = entity_list.get_players(true)
    for i,v in ipairs(enemies) do
        if are_them_visibles(v) and are_have_weapon(v) then
            exploits.force_uncharge()
            exploits.block_recharge()
        else
            exploits.allow_recharge()
        end
    end
end
enabled = menu.add_checkbox("Teleport(when in danger)", "Teleport helper")
key     = enabled:add_keybind("Teleport keybind")
callbacks.add(e_callbacks.SETUP_COMMAND, strangerdranger)

--]Indcators
local pixel = render.create_font("Prompt", 12, 0, e_font_flags.OUTLINE)

--binds
local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") -- get doubletap
local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") -- get hideshots
local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") -- get autopeek
local isSW = menu.find("misc","main","movement","slow walk", "enable") -- get Slow Walk
local min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local min_damage_h = menu.find("aimbot", "heavy pistols", "target overrides", "force min. damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")
local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
local amount_revolver = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local amount_deagle = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local amount_pistol = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))
local isBA = menu.find("aimbot", "scout", "target overrides", "force hitbox") -- get froce baim
local isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint") -- get safe point
local isAA = menu.find("antiaim", "main", "angles", "yaw base") -- get yaw base

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
--] Indactors
local font_inds = render.create_font("Smallest Pixel-7", 13, 550, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE) -- font

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
                acatel_style_2 = "       FREESTAND"
            elseif antiaim.is_inverting_desync() then
                acatel_style_2 = "LEFT"
            else
                acatel_style_2 = "    RIGHT"
            end

                render.text(font_inds, "Ender:  ", vec2_t(x, y + 28.5), color_t(81, 157, 255)) render.text(font_inds, "     yaw:  ", vec2_t(x, y + 28.5), color_t(255,255,255)) -- render text
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
--] Callbacks
callbacks.add(e_callbacks.PAINT, on_paint)
--] Hit and Miss Logger
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

--] Custom clantag
local ffi_handler = {}
local tag_changer = {}
local ui = {}


tag_changer.custom_tag = {
    "Enderyaw",
    "Enderya",
    "Endery",
    "Ender",
    "Ende",
    "End",
    "En",
    "E",
    "E",
    "En",
    "End",
    "Ende",
    "Ender",
    "Endery",
    "Enderya",
    "Enderyaw"
}


local string_mul = function(text, mul)

    mul = math.floor(mul)

    local to_add = text

    for i = 1, mul-1 do
        text = text .. to_add
    end

    return text
end

ffi_handler.sigs = {}
ffi_handler.sigs.clantag = {"engine.dll", "53 56 57 8B DA 8B F9 FF 15"}
ffi_handler.change_tag_fn = ffi.cast("int(__fastcall*)(const char*, const char*)", memory.find_pattern(unpack(ffi_handler.sigs.clantag)))

tag_changer.last_time_update = -1
tag_changer.update = function(tag)
    local current_tick = global_vars.tick_count()

    if current_tick > tag_changer.last_time_update then
        tag = tostring(tag)
        ffi_handler.change_tag_fn(tag, tag)
        tag_changer.last_time_update = current_tick + 16
    end
end

tag_changer.build_first = function(text)

    local orig_text = text
    local list = {}

    text = string_mul(" ", #text * 2) .. text .. string_mul(" ", #text * 2)

    for i = 1, math.floor(#text / 1.5) do
        local add_text = text:sub(i, (i + math.floor(#orig_text * 2) % #text))

        table.insert(list, add_text .. "\t")
    end

    return list
end

tag_changer.build_second = function(text)
    local builded = {}

    for i = 1, #text do

        local tmp = text:sub(i, #text) .. text:sub(1, i-1)

        if tmp:sub(#tmp) == " " then
            tmp = tmp:sub(1, #tmp-1) .. "\t"
        end

        table.insert(builded, tmp)
    end

    return builded
end

ui.group_name = "Clan-tag spammer"
ui.is_enabled = menu.add_checkbox(ui.group_name, "Clan-tag spammer", false)
ui.type = menu.add_selection(ui.group_name, "Animation Type", {"First", "Second", "Enderyaw"})
ui.speed = menu.add_slider(ui.group_name, "Tag speed", 0, 4)
ui.input = menu.add_text_input(ui.group_name, "Tag")

tag_changer.current_build = tag_changer.build_first("primordial.dev")
tag_changer.current_tag = "empty_string"

tag_changer.disabled = true
tag_changer.on_paint = function()

    local is_enabled = ui.is_enabled:get()
    if not engine.is_in_game() or not is_enabled then

        if not is_enabled and not tag_changer.disabled then
            ffi_handler.change_tag_fn("", "")
            tag_changer.disabled = true
        end

        tag_changer.last_time_update = -1
        return
    end    

    local tag_type = ui.type:get()
    local ui_tag = ui.input:get()
    if tag_type ~= 3 and ui_tag ~= tag_changer.current_tag then
        tag_changer.current_build = tag_type == 1 and tag_changer.build_first(ui_tag) or tag_changer.build_second(ui_tag)
    elseif tag_type == 3 then
        tag_changer.current_build = tag_changer.custom_tag
    end

    local tag_speed = ui.speed:get()
    if tag_type == 3 then
        tag_speed = math.max(1, tag_speed)
    end

    if tag_speed == 0 then
        tag_changer.update(ui_tag)
        return
    end

    local current_tag = math.floor(global_vars.cur_time() * tag_speed % #tag_changer.current_build) + 1
    current_tag = tag_changer.current_build[current_tag]

    tag_changer.disabled = false
    tag_changer.update(current_tag)
end

callbacks.add(e_callbacks.PAINT, tag_changer.on_paint)

--] more inidicators

local menu_color = select(2, unpack(menu.find("misc", "main", "config", "accent color")))
 local font = render.create_font("Arial", 14, 30,e_font_flags.ANTIALIAS)
 local screen_size = render.get_screen_size()

   local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") 
   local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") 
   local isSW = menu.find("misc","main","movement","slow walk", "enable") 
   local isBA = menu.find("aimbot", "scout", "target overrides", "force hitbox") 
   local isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint")
   local isAA = menu.find("antiaim", "main", "angles", "yaw base") 
   local isFD = menu.find("antiaim", "main", "general", "fake duck") 
   local groups = {
    ['auto'] = 0,
    ['scout'] = 1,
    ['awp'] = 2,
    ['deagle'] = 3,
    ['revolver'] = 4,
    ['pistols'] = 5,
    ['other'] = 6
}
local current_min = nil
local key_active = nil
local force_lethal = nil
local hitbox_ovr = nil
local force_sp = nil
local force_hc = nil
local math_funcs = { 

    get_min_dmg = function(wpn_type) 
        local menu_ref = menu.find("aimbot", wpn_type, "target overrides", "force min. damage")
        local force_lethal = menu.find("aimbot", wpn_type, "target overrides", "force lethal shot")
        local hitbox_ovr = menu.find("aimbot", wpn_type, "target overrides", "force hitbox")
        local force_sp = menu.find("aimbot", wpn_type, "target overrides", "force safepoint")
        local force_hc = menu.find("aimbot", wpn_type, "target overrides", "force hitchance")
        return {menu_ref[1]:get(), menu_ref[2]:get(), force_lethal[2]:get(), hitbox_ovr[2]:get(), force_sp[2]:get(),
                force_hc[2]:get()}
    end,
    vars = {
        angle = 0
    }
}

local function get_weapon_group() 
    for key, value in pairs(groups) do
        if value == ragebot.get_active_cfg() then
            current_min = math_funcs.get_min_dmg(key)[1];
            key_active = math_funcs.get_min_dmg(key)[2];
            force_lethal = math_funcs.get_min_dmg(key)[3];
            hitbox_ovr = math_funcs.get_min_dmg(key)[4];
            force_sp = math_funcs.get_min_dmg(key)[5];
            force_hc = math_funcs.get_min_dmg(key)[6];
        end
    end

    return {tostring(current_min), key_active, force_lethal, hitbox_ovr, force_sp, force_hc};
end
 local function on_paint()
    if not engine.is_connected() then
        return
    end

    if not engine.is_in_game() then
        return
    end
    local local_player = entity_list.get_local_player()

    local fake = antiaim.get_fake_angle()
    if antiaim.is_inverting_desync() == false then
        invert ="R"
    else
        invert ="L"
    end
    local x = render.get_screen_size().x
    local y = render.get_screen_size().y
    local chocking = engine.get_choked_commands()
    local charge = exploits.get_charge()
    local maxcharge = exploits.get_max_charge()
    local pos = vec2_t(0, 0)
    local addpos = vec2_t(0, 32)
    local pos = vec2_t(screen_size.x * 0.0041666666, screen_size.y * 0.47777777777)
    pos = pos
 --
    render.rect_filled(pos, vec2_t(150, 45), color_t(0,0,0))
    render.rect_fade(pos, vec2_t(3, 45), color_t(0,0,0,255),menu_color:get())
    render.rect_fade(pos+vec2_t(147,0), vec2_t(3, 45), color_t(0,0,0,255),menu_color:get())
    render.rect_filled(pos+vec2_t(0,42), vec2_t(150, 3), menu_color:get())
    --
    render.rect_filled(pos+vec2_t(0,60), vec2_t(150, 40), color_t(0,0,0))
    render.rect_filled(pos+vec2_t(0,60), vec2_t(150, 3), menu_color:get())
    render.rect_fade(pos+vec2_t(0,60), vec2_t(3, 40), menu_color:get(),color_t(0,0,0,255))
    render.rect_fade(pos+vec2_t(147,60), vec2_t(3, 40), menu_color:get(),color_t(0,0,0,255))

    render.text(font, "Fake-Lag:  ", pos+vec2_t(7,5), color_t(255,255,255,255))
    render.text(font, "[ "..chocking.." ]", pos+vec2_t(120,5), menu_color:get())
    render.text(font, "DoubleTap: ", pos+vec2_t(7,15), color_t(255,255,255,255))
    render.text(font, "[ "..charge.." ]", pos+vec2_t(120,15), menu_color:get())
    render.text(font, "FAKE YAW: ", pos+vec2_t(7,25), color_t(255,255,255,255))
    render.text(font, "[ "..invert.." ]", pos+vec2_t(120,25), menu_color:get())

    render.text(font, "DMG: ", pos+vec2_t(7,63), color_t(255,255,255,255))
    if  get_weapon_group()[2] then
        render.text(font, "["..get_weapon_group()[1].."]", pos+vec2_t(35,63), menu_color:get() or color_t(255,255,255,255))
    end

    if isSW[2]:get() then
        render.text(font, "SWALK", pos+vec2_t(7,73), menu_color:get())
    else
        render.text(font, "SWALK", pos+vec2_t(7,73), color_t(255,255,255,255))
    end
    if isHS[2]:get() then
        render.text(font, "OSAA", pos+vec2_t(63,63), menu_color:get())
    else
        render.text(font, "OSAA", pos+vec2_t(63,63), color_t(255,255,255,255))
    end
    if isAP[2]:get() then
        render.text(font, "A-PEEK", pos+vec2_t(63,73), menu_color:get())
    else
        render.text(font, "A-PEEK", pos+vec2_t(63,73), color_t(255,255,255,255))
    end
    if isBA[2]:get() then
        render.text(font, "BAIM", pos+vec2_t(7,83), menu_color:get())
    else
        render.text(font, "BAIM", pos+vec2_t(7,83), color_t(255,255,255,255))
    end
    if isSP[2]:get() then
        render.text(font, "FS", pos+vec2_t(63,83), menu_color:get())
    else
        render.text(font, "FS", pos+vec2_t(63,83), color_t(255,255,255,255))
    end
    if isFD[2]:get() then
        render.text(font, "DUCK", pos+vec2_t(105,63), menu_color:get())
    else
        render.text(font, "DUCK", pos+vec2_t(105,63), color_t(255,255,255,255))
    end

 end
 
   --=====Callback=======--
 callbacks.add(e_callbacks.PAINT, on_paint)
   --=====CallbackEnd=======--

   --] Even more indicators

   local SetCatimes_script_var = {
    --info
    info                    = {
        lua_name            = "Tesla on hit",
        coder               = "SetCatimes"
    },

    --menu var
    menu                    = {

    },

    --functions
    functions               = {

    },

    --ffi
    ffi                     = require("ffi"),

    ffi_vars                = {
        match               = memory.find_pattern("client.dll", "55 8B EC 81 EC ? ? ? ? 56 57 8B F9 8B 47 18"),
    },

    ffi_functions           = {

    },

}

---------------------------------------ffi cdef---------------------------------------

SetCatimes_script_var.ffi.cdef[[
    typedef struct { 
        float x,y,z; 
    } vec3_t; 
    
    struct tesla_info_t { 
        vec3_t m_pos; 
        vec3_t m_ang;
        int m_entindex;
        const char *m_spritename;
        float m_flbeamwidth;
        int m_nbeams;
        vec3_t m_color;
        float m_fltimevis;
        float m_flradius;
    }; 
    
    typedef void(__thiscall* FX_TeslaFn)(struct tesla_info_t&); 
    typedef int(__fastcall* clantag_t)(const char*, const char*);
]]

SetCatimes_script_var.ffi_functions.fs_tesla = ffi.cast("FX_TeslaFn", SetCatimes_script_var.ffi_vars.match)

-----------------------------------------menu-----------------------------------------

SetCatimes_script_var.menu = {
    menu.add_checkbox(SetCatimes_script_var.info.lua_name, "Tesla on hit Enable", false),
    menu.add_slider(SetCatimes_script_var.info.lua_name, "Tesla width", 0, 30),
    menu.add_slider(SetCatimes_script_var.info.lua_name, "Tesla radius", 0, 1000),
    menu.add_slider(SetCatimes_script_var.info.lua_name, "Tesla Beams", 0, 100),
    menu.add_slider(SetCatimes_script_var.info.lua_name, "Tesla Show times(ms)", 0, 3),
}

SetCatimes_script_var.menu.tesla_color = SetCatimes_script_var.menu[1]:add_color_picker("tesla_color")

---------------------------------------function---------------------------------------

SetCatimes_script_var.functions.tesla = function(shot)
    local x,y,z = 0,0,0
    local tesla_info = SetCatimes_script_var.ffi.new("struct tesla_info_t")
    local color = SetCatimes_script_var.menu.tesla_color

    tesla_info.m_flbeamwidth = SetCatimes_script_var.menu[2]:get()
    tesla_info.m_flradius = SetCatimes_script_var.menu[3]:get()
    tesla_info.m_entindex = engine.get_local_player_index()
    tesla_info.m_color = {color:get().r/255, color:get().g/255, color:get().b/255}
    tesla_info.m_pos = { shot.hitpoint_pos.x+10, shot.hitpoint_pos.y, shot.hitpoint_pos.z+10 }
    tesla_info.m_fltimevis = SetCatimes_script_var.menu[5]:get()
    tesla_info.m_nbeams = SetCatimes_script_var.menu[4]:get()
    tesla_info.m_spritename = true and "sprites/physbeam.vmt" or "sprites/purplelaser1.vmt"
    SetCatimes_script_var.ffi_functions.fs_tesla(tesla_info)
end

---------------------------------------callback---------------------------------------

callbacks.add(e_callbacks.AIMBOT_SHOOT, SetCatimes_script_var.functions.tesla)

--------------------------------------The-End-T---------------------------------------
--] Custom scope lines
local ffi = require 'ffi'

ffi.cdef[[
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
    typedef uintptr_t (__thiscall* GetClientEntityByHandle_4242425_t)(void*, uint32_t);

    struct WeaponInfo_t
    {
        char* consoleName;              // 0x0004
        char        pad_0008 [ 8 ];             // 0x0008
        void* m_pWeaponDef;  //0x0010
        int         iMaxClip1;                  // 0x0014
        int         iMaxClip2;                  // 0x0018
        int         iDefaultClip1;              // 0x001C
        int         iDefaultClip2;              // 0x0020
        char        pad_0024 [ 8 ];             // 0x0024
        char* szWorldModel;             // 0x002C
        char* szViewModel;              // 0x0030
        char* szDroppedModel;               // 0x0034
        char        pad_0038 [ 4 ];             // 0x0038
        char* N0000023E;                    // 0x003C
        char        pad_0040 [ 56 ];                // 0x0040
        char* szEmptySound;             // 0x0078
        char        pad_007C [ 4 ];             // 0x007C
        char* szBulletType;             // 0x0080
        char        pad_0084 [ 4 ];             // 0x0084
        char* szHudName;                    // 0x0088
        char* szWeaponName;             // 0x008C
        char        pad_0090 [ 60 ];                // 0x0090
        int         WeaponType;                 // 0x00C8
        int         iWeaponPrice;               // 0x00CC
        int         iKillAward;                 // 0x00D0
        char* szAnimationPrefix;            // 0x00D4
        float       flCycleTime;                // 0x00D8
        float       flCycleTimeAlt;             // 0x00DC
        float       flTimeToIdle;               // 0x00E0
        float       flIdleInterval;             // 0x00E4
        bool        bFullAuto;                  // 0x00E8
        char        pad_0x00E5 [ 3 ];           // 0x00E9
        int         iDamage;                    // 0x00EC
        float       flArmorRatio;               // 0x00F0
        int         iBullets;                   // 0x00F4
        float       flPenetration;              // 0x00F8
        float       flFlinchVelocityModifierLarge;  // 0x00FC
        float       flFlinchVelocityModifierSmall;  // 0x0100
        float       flRange;                    // 0x0104
        float       flRangeModifier;            // 0x0108
        float       flThrowVelocity;            // 0x010C
        char        pad_0x010C [ 16 ];          // 0x0110
        bool        bHasSilencer;               // 0x011C
        char        pad_0x0119 [ 3 ];           // 0x011D
        char*       pSilencerModel;             // 0x0120
        int         iCrosshairMinDistance;      // 0x0124
        float       flMaxPlayerSpeed;           // 0x0128
        float       flMaxPlayerSpeedAlt;        // 0x012C
        char        pad_0x0130 [ 4 ];           // 0x0130
        float       flSpread;                   // 0x0134
        float       flSpreadAlt;                // 0x0138
        float       flInaccuracyCrouch;         // 0x013C
        float       flInaccuracyCrouchAlt;      // 0x0140
        float       flInaccuracyStand;          // 0x0144
        float       flInaccuracyStandAlt;       // 0x0148
        float       flInaccuracyJumpInitial;    // 0x014C
        float       flInaccuracyJump;           // 0x0150
        float       flInaccuracyJumpAlt;        // 0x0154
        float       flInaccuracyLand;           // 0x0158
        float       flInaccuracyLandAlt;        // 0x015C
        float       flInaccuracyLadder;         // 0x0160
        float       flInaccuracyLadderAlt;      // 0x0164
        float       flInaccuracyFire;           // 0x0168
        float       flInaccuracyFireAlt;        // 0x016C
        float       flInaccuracyMove;           // 0x0170
        float       flInaccuracyMoveAlt;        // 0x0174
        float       flInaccuracyReload;         // 0x0178
        int         iRecoilSeed;                // 0x017C
        float       flRecoilAngle;              // 0x0180
        float       flRecoilAngleAlt;           // 0x0184
        float       flRecoilAngleVariance;      // 0x0188
        float       flRecoilAngleVarianceAlt;   // 0x018C
        float       flRecoilMagnitude;          // 0x0190
        float       flRecoilMagnitudeAlt;       // 0x0194
        float       flRecoilMagnitudeVariance;  // 0x0198
        float       flRecoilMagnitudeVarianceAlt;   // 0x019C
        float       flRecoveryTimeCrouch;       // 0x01A0
        float       flRecoveryTimeStand;        // 0x01A4
        float       flRecoveryTimeCrouchFinal;  // 0x01A8
        float       flRecoveryTimeStandFinal;   // 0x01AC
        int         iRecoveryTransitionStartBullet; // 0x01B0 
        int         iRecoveryTransitionEndBullet;   // 0x01B4
        bool        bUnzoomAfterShot;           // 0x01B8
        bool        bHideViewModelZoomed;       // 0x01B9
        char        pad_0x01B5 [ 2 ];           // 0x01BA
        char        iZoomLevels [ 3 ];          // 0x01BC
        int         iZoomFOV [ 2 ];             // 0x01C0
        float       fZoomTime [ 3 ];                // 0x01C4
        char* szWeaponClass;                // 0x01D4
        float       flAddonScale;               // 0x01D8
        char        pad_0x01DC [ 4 ];           // 0x01DC
        char* szEjectBrassEffect;           // 0x01E0
        char* szTracerEffect;               // 0x01E4
        int         iTracerFrequency;           // 0x01E8
        int         iTracerFrequencyAlt;        // 0x01EC
        char* szMuzzleFlashEffect_1stPerson;    // 0x01F0
        char        pad_0x01F4 [ 4 ];               // 0x01F4
        char* szMuzzleFlashEffect_3rdPerson;    // 0x01F8
        char        pad_0x01FC [ 4 ];           // 0x01FC
        char* szMuzzleSmokeEffect;      // 0x0200
        float       flHeatPerShot;              // 0x0204
        char* szZoomInSound;                // 0x0208
        char* szZoomOutSound;               // 0x020C
        float       flInaccuracyPitchShift;     // 0x0210
        float       flInaccuracySoundThreshold; // 0x0214
        float       flBotAudibleRange;          // 0x0218
        char        pad_0x0218 [ 8 ];           // 0x0220
        char* pWrongTeamMsg;                // 0x0224
        bool        bHasBurstMode;              // 0x0228
        char        pad_0x0225 [ 3 ];           // 0x0229
        bool        bIsRevolver;                // 0x022C
        bool        bCannotShootUnderwater;     // 0x0230
    };
]]

local ENTITY_LIST_POINTER = ffi.cast("void***", memory.create_interface("client.dll", "VClientEntityList003")) or error("Failed to find VClientEntityList003!")
local GET_CLIENT_ENTITY_FN = ffi.cast("GetClientEntity_4242425_t", ENTITY_LIST_POINTER[0][3])
local GET_CLIENT_ENTITY_BY_HANDLE_FN = ffi.cast("GetClientEntityByHandle_4242425_t", ENTITY_LIST_POINTER[0][4])

local ffi_helpers = {
    get_entity_address_by_handle = function(handle)
        local addr = GET_CLIENT_ENTITY_BY_HANDLE_FN(ENTITY_LIST_POINTER, handle)
        return addr
    end
}

local weapon_data_call = ffi.cast("int*(__thiscall*)(void*)", memory.find_pattern("client.dll", "55 8B EC 81 EC ? ? ? ? 53 8B D9 56 57 8D 8B ? ? ? ? 85 C9 75 04"))
local length = menu.add_slider("Custom Scope", "Scope Length", 1, 100)
local gap = menu.add_slider("Custom Scope", "Scope Gap", 1, 100)
local thickness = menu.add_slider("Custom Scope", "Scope Thickness", 1, 5)
local anim_speed = menu.add_slider("Custom Scope", "Scope Animation Speed", 1, 500)
local inaccuracy = menu.add_checkbox("Custom Scope", "Change size by inaccuracy")
local first_cbox_color = menu.add_checkbox("Custom Scope", "Color 1")
local color_1 = first_cbox_color:add_color_picker("Color 1")
local second_cbox_color = menu.add_checkbox("Custom Scope", "Color 2")
local color_2 = second_cbox_color:add_color_picker("Color 2")

local screen = render.get_screen_size()

local visual_items = {}

visual_items.scope_data = {
    length = 0,
    gap = 0,
    thickness = 0
}

function clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

local FL_ONGROUND = bit.lshift(1, 0)
local FL_DUCKING = bit.lshift(1, 1)

local current_movement_state = function()
    local lp = entity_list.get_local_player()
    if not lp then return end

    local flags = lp:get_prop("m_fFlags")

    local is_not_on_ground = bit.band(flags, FL_ONGROUND) == 0
    local is_crouching = bit.band(flags, FL_DUCKING) ~= 0

    local lp_velocity = lp:get_prop("m_vecVelocity")

    if is_not_on_ground then
        return 4
    else
        if is_crouching then
            return 3
        elseif lp_velocity.x > 5 or lp_velocity.x < -5 then
            return 2
        end
    end
    return 1
end

local weapon_inaccuracy = 0
local wanted_weapon_inaccuracy = 0

visual_items.custom_scope_draw = function()
    local lp = entity_list.get_local_player()
    if not lp then return end
    local lp_hp = lp:get_prop("m_iHealth")
    if lp_hp < 1 then
        visual_items.scope_data = {
            length = 0,
            gap = 0,
            thickness = 0
        }
        return
    end
    local animation_time = (global_vars.absolute_frame_time() * (1.0 / 0.9)) * anim_speed:get()
    local animation_time_2 = (global_vars.absolute_frame_time() * (1.0 / 0.9)) * 100

    local is_scoped = lp:get_prop("m_bIsScoped")
    if is_scoped == 1 then
        if visual_items.scope_data.length < length:get() then
            visual_items.scope_data.length = visual_items.scope_data.length + animation_time
        elseif visual_items.scope_data.length > length:get() then
            visual_items.scope_data.length = visual_items.scope_data.length - animation_time
        end
    else
        if visual_items.scope_data.length > 0 then
            visual_items.scope_data.length = visual_items.scope_data.length - animation_time
        end
    end

    local gradient_color_1 = color_1:get()
    local gradient_color_2 = color_2:get()

    visual_items.scope_data.length = clamp(visual_items.scope_data.length, 0, length:get())
    visual_items.scope_data.gap = gap:get()
    visual_items.scope_data.thickness = thickness:get()

    local weapon_data = ffi.cast("struct WeaponInfo_t*", weapon_data_call(ffi.cast("void*", ffi_helpers.get_entity_address_by_handle(lp:get_prop("m_hActiveWeapon")))));

    if weapon_data and inaccuracy:get() then
        local state = current_movement_state()
        if state == 4 then
            weapon_inaccuracy = weapon_data.flInaccuracyJump
        elseif state == 2 then
            weapon_inaccuracy = (weapon_data.flInaccuracyMove) * 2
        elseif state == 3 then
            weapon_inaccuracy = (weapon_data.flInaccuracyCrouch) * 0.2
        else
            weapon_inaccuracy = weapon_data.flInaccuracyStand
        end
    else
        weapon_inaccuracy = 0
        wanted_weapon_inaccuracy = 0
    end
    if weapon_inaccuracy ~= 0 then
        weapon_inaccuracy = math.floor(weapon_inaccuracy * 100)
        if wanted_weapon_inaccuracy ~= weapon_inaccuracy then
            if wanted_weapon_inaccuracy < weapon_inaccuracy then
                wanted_weapon_inaccuracy = clamp(wanted_weapon_inaccuracy + animation_time_2, 0, weapon_inaccuracy)
            else
                wanted_weapon_inaccuracy = clamp(wanted_weapon_inaccuracy - animation_time_2, weapon_inaccuracy, 2147483647)
            end
        end
    end

    if visual_items.scope_data.length > 0 then
        local draw_pos = {
            x = screen.x/2,
            y = screen.y/2,
            w = visual_items.scope_data.length,
            h = visual_items.scope_data.thickness
        }

        render.rect_fade(vec2_t(draw_pos.x - visual_items.scope_data.gap - draw_pos.w - wanted_weapon_inaccuracy, draw_pos.y - math.floor(visual_items.scope_data.thickness/2)), vec2_t(draw_pos.w, draw_pos.h), gradient_color_2, gradient_color_1, true)
        render.rect_fade(vec2_t(draw_pos.x - math.floor(visual_items.scope_data.thickness/2), draw_pos.y - visual_items.scope_data.gap - draw_pos.w - wanted_weapon_inaccuracy), vec2_t(draw_pos.h, draw_pos.w), gradient_color_2, gradient_color_1, false)

        render.rect_fade(vec2_t(draw_pos.x + visual_items.scope_data.gap + wanted_weapon_inaccuracy, draw_pos.y - math.floor(visual_items.scope_data.thickness/2)), vec2_t(draw_pos.w, draw_pos.h), gradient_color_1, gradient_color_2, true)
        render.rect_fade(vec2_t(draw_pos.x - math.floor(visual_items.scope_data.thickness/2), draw_pos.y + visual_items.scope_data.gap + wanted_weapon_inaccuracy), vec2_t(draw_pos.h, draw_pos.w), gradient_color_1, gradient_color_2, false)
    end
end

callbacks.add(e_callbacks.PAINT, function()
    visual_items.custom_scope_draw()
end)
--] Killsays

local kill_say = {}
local ui = {}
kill_say.phrases = {}

-- just found all phrases on github
table.insert(kill_say.phrases, {
    name = "Default",
    phrases = {
         "u r so ez ",
    "get clapped ",
    "did that hurt  ?",
    "do you want me to blow on that ?",
    "btw you are supposed to shoot me .",
    "sry I didn't know you were retarded ",
    "CSGO->Game->Game->TurnOnInstructorMessages that might help you ",
    "better luck next time ",
    "bro how did you hit the accept button with that aim ???",
    "ff ?",
    " should i teach you, just if you want .",
    "xD my cat killed you ",
    "better do you homework ",
    "Which controller are you using ???",
    "Did you ever think about suicide? It would make things quicker .",
    "is that a decoy, or are you trying to shoot somebody ?",
    "If this guy was the shooter Harambe would still be alive ",
    "CS:GO is too hard for you m8 maybe consider a game that requires less skill, like idk.... solitaire ",
    "Your shots are like a bad girlfriend: No Head",
    "I would call you AIDS but at least AIDS gets kills.",
    "I could swallow bullets and shit out a better spray than that",
    "Don't be a loser, buy a rope and hang yourself",
    "This guy is more toxic than the beaches at Fukushima",
    "deranking?",
    "Road to Bronce?",
    "Did you learn your spray downs in a bukkake video?",
    "Oops, I must have chosen easy bots by accident",
    "server cvar 'sv_rekt' changed to 1.",
    "Did you notice warm up is already over? Please start playing seriously!!!",
    "How do you change your difficulty settings? My CSGO is stuck on easy",
    "I'd say your aim is cancer, but cancer kills.",
    "I'd call you corona but nobody's afraid of you and corona gets kills.",
    "Nice $4750 decoy ' ' ",
    "CRY HERE ---> |___| <--- Africans need water",
    "Was that your spray on the wall or are you just happy to see me?",
    "Internet Explorer is faster than your reactions",
    "Safest place for us to stand is in front of ' ' ´s gun",
    "Is your monitor on?",
    "mad cuz bad",
    "Choose your excuse: I suck, I'm bad, I can't play CSGO, WHY ARE YOU BULLYING ME",
    "If you want to play against enemies of your skill level just go to the main menu and click 'Offline with Bots'",
    "Did you know that csgo is free to uninstall?",
        "halt die fresse noname ",
        "Your ass is grass and I've got the weed-whacker.",
        "You are the reason they put instructions on shampoo.",
        "I used to fuck guys like you in prison",
        "i'll fuck you 'til you love me, faggot",
        "I smell your drunk mom from here.",
    "I'm the reason your dad's gay",
    "If you were a CSGO match, your mother would have a 7day cool down all the time, because she kept abandoning you.",
    "If I were to commit suicide, I would jump from your ego to your elo.",
    "You sound like your parents beat each other in front of you",
    "My knife is well-worn, just like your mother",
    "You're the human equivalent of a participation award.",
    "Did you grow up near by Chernobyl or why are you so toxic?",
    "I thought I put bots on hard, why are they on easy?",
        "You sound like your parents beat each other in front of you",
    "My knife is well-worn, just like your mother",
    "You're the human equivalent of a participation award.",
    "Did you grow up near by Chernobyl or why are you so toxic?",
    "I thought I put bots on hard, why are they on easy?",
    "Your nans like my ak vulcan, battle-scarred",
    "I have a coupon code for you = y0UStUP1d. It only works for dumb people so can you maybe try that one out for me?",
    "You're almost as salty as the semen dripping from your mum's mouth",
    "If you fuck your mom and sister it's still only a 2 sum. Are you from Alabama by any chance?",
    "Maybe if you stopped taking loads in the mouth you wouldn't be so salty",
    "The only thing you carry is an extra chromosome.",
    "I kissed your mom last night. Her breath was globally offensive",
    "You can't even carry groceries in from the car",
    "You can feel the autism",
    "Who are you sponsored by? Parkinson's?",
    "You define autism",
    "You dropped your weapon just like your mom dropped you on your head as a kid",
    "Shut up kid and talk to me when your balls have reached the bottom of your spiderman underwear!",
    "The time you need to react is equal to the WindowsXP boot time!",
    "You Polish fuck, Hitler should had killed your family",
    "Do you know the STOP BULLYING ME kid? That could be you.",
    "Bro you couldn't hit an elephant in the ass with a shotgun with aim like that",
    "Hey man, dont worry about being bad. It's called a trashCAN not a trashCAN'T.",
    "Dont hate me because im beutiful ... NIGAaaa...",
    "If i wanted to listen to an asshole I would fart",
    "Sell your computer and buy a Wii",
        "eat shit",
    "fuck a baboon",
    "suck my dingleberries",
        "choke on steaming cum",
    "die in a fire",
    "gas yourself",
    "sit on garden shears",
    "choke on scrotum",
    "shove a brick up your ass",
    "swallow barbed wire",
    "move to sweden",
    "fuck a pig",
    "bow to me",
    "suck my ball sweat",
    "come back when you aren\"t garbage",
    "i will piss on everything you love",
    "kill yourself",
    "livestream suicide",
    "neck yourself",
        "go be black somewhere else",
    "rotate on it",
    "choke on it",
    "blow it out your ass",
    "go browse tumblr",
    "go back to casual",
    "sit on horse cock",
    "drive off a cliff",
    "rape yourself",
    "get raped by niggers",
    "fuck right off",
    "you mother is a whore",
    "come at me",
    "go work the corner",
    "you are literal cancer",
    "why haven\"t you killed yourself yet",
    "why do you even exist",
    "shoot your balls off with a shotgun",
    "sterilize yourself",
    "convert to islam",
    "drink bleach",
    "remove yourself",
    "choke on whale cock",
    "suck shit",
    "suck a cock",
    "lick my sphincter",
    "set yourself on fire",
    "drink jenkem",
    "get beaten to death by your dad",
    "choke on your uncle\"s cock",
    "get sat on by a 200kg feminist",
    "blow off",
    "join isis",
    "stick your cock in a blender",
    "OD yourself on meth",
    "lie under a truck",
    "lick a wall socket",
    "swallow hot coals",
    "die slowly",
    "explode yourself",
    "swing from the noose",
    "end yourself",
    "take your best shot",
    "get shot in a gay bar",
    "drink pozzed cum",
    "marry a muslim",
    "rub your dick on a cheese grater",
    "wrap a rake with barbed wire and sodomize yourself",
    "close your gaping cunt",
        "whats the max tabs you can have open on a vpn",
    "whats the time",
    "is it possible to make a clock in binary",
    "how many cars can you drive at once",
    "did you know there\"s more planes on the ground than there is submarines in the air",
    "how many busses can you fit on 1 bus",
    "how many tables does it take to support a chair",
    "how many doors does it take to screw a screw",
    "how long can you hold your eyes closed in bed",
    "how long can you hold your breath for under spagetti",
    "whats the fastest time to deliver the mail as a mail man",
    "how many bees does it take to make a wasp make honey",
    "If I paint the sun blue will it turn blue",
    "how many beavers does it take to build a dam",
    "how much wood does it take to build a computer",
    "can i have ur credit card number",
    "is it possible to blink and jump at the same time",
    "did you know that dinosaurs were, on average, large",
    "how many thursdays does it take to paint an elephant purple",
    "if cars could talk how fast would they go",
    "did you know theres no oxygen in space",
    "do toilets flush the other way in australia",
    "if i finger paint will i get a splinter",
    "can you build me an ant farm",
    "did you know australia hosts 4 out of 6 of the deadliest spiders in the world",
    "is it possible to ride a bike in space",
    "can i make a movie based around your life",
    "how many pants can you put on while wearing pants",
    "if I paint a car red can it wear pants",
    "how come no matter what colour the liquid is the froth is always white",
    "can a hearse driver drive a corpse in the car pool lane",
        "how come the sun is cold at night",
    "why is it called a TV set when there is only one",
    "if i blend strawberries can i have ur number",
    "if I touch the moon will it be as hot as the sun",
    "did u know ur dad is always older than u",
    "did u know the burger king logo spells burger king",
    "did u know if u chew on broken glass for a few mins, it starts to taste like blood",
    "did u know running is faster than walking",
    "did u know the colour blue is called blue because its blue",
    "did u know a shooting star isnt a star",
    "did u know shooting stars dont actually have guns",
    "did u know the great wall of china is in china",
    "statistictal fact: 100% of non smokers die",
    "did u kmow if you eat you poop it out",
    "did u know rain clouds r called rain clouds cus they are clouds that rain",
    "if cows drink milk is that cow a cannibal",
    "did u know you cant win a staring contest with a stuffed animal",
    "did u know if a race car is at peak speed and hits someone they\"ll die",
    "did u know the distance between the sun and earth is the same distance as the distance between the earth and the sun",
    "did u know aeroplane mode on ur phone doesnt make ur phone fly",
    "did u know too many birthdays can kill you",
    "did u know rock music isnt for rocks",
    "did u know if you eat enough ice you can stop global warming",
    "if ww2 happened before vietnam would that make vietnam world war 2",
    "did u know 3.14 isn\"t a real pie",
    "did u know 100% of stair accidents happen on stairs",
    "can vampires get AIDS",
    "what type of bird was a dodo",
    "did u know dog backwards is god",
    "did you know on average a dog barks more than a cat",
    "did u know racecar backwards is racecar"
    -- add as many as you want

    }
})

table.insert(kill_say.phrases, {
    name = "Gay AF killsays",
    phrases = {
        "S-Sorry onii-chan p-please d-do me harder ;w;",
        "Y-You got me all wet now Senpai!",
        "D-Don't t-touch me there Senpai",
        "P-Please l-love me harder oniichan ohh grrh aahhhh~!",
        "Give me all your cum Senpai ahhhhh~",
        "F-Fuck me harder chan!",
        "Oh my god I hate you so much Senpai but please k-keep fucking me harder! ahhh~",
        "D-Do you like my stripped panties getting soaked by you and your hard cock? ehhh Master you're so lewd ^0^~",
        "Kun your cute little dick between my pussy lips looks really cute, I'm blushing",
        "M-Master does it feel good when I slide by tits up and down on your cute manly part?",
        "O-Oniichan my t-toes are so warm with your cum all over them uwu~",
        "Lets take this swimsuit off already <3 i'll drink your unknown melty juice",
        "S-Stop Senpai if we keep making these lewd sounds im going to cum~~",
        "You're such a pervert for filling me up with your baby batter Senpai~~",
        "Fill up my baby chamber with your semen kun ^-^",
        "M-Master d-dont spank my petite butt so hard ahhhH~~~ you're getting me so w-wet~",
        "Senpai your cock is already throbbing from my huge tits~",
        "Hey kun, Can I have some semen?",
        "M-My baby chamber is overflowing with your semen M-Master",
        "Y-Yes M-Master right there",
        "Oh do you wanna eat? Do you wanna take a bath? Or do you want me!",
        "it's not gay if you swallow the evidence S-Sempai",
        "Fill my throat pussy with your semen kun",
        "It-It's not gay if you're wearing thigh highs M-Master",
        "I-I need somewhere to blow my load. Can i borrow your bussy?",
        "A-ah shit... Y-your cock is big and in my ass already~?!",
        "I-I'm cumming, I'm cumming, CUM with me too!",
        "Drench me and I'll do the same!",
        "I'll swallow your sticky essence along with you~!",
        "You're my personal cum bucket!!",
        "B-baka please let me be your femboy sissy cum slut!",
        "That's a penis UwU you towd me you wewe a giww!!",
        "You are cordially invited to fuck my ass!",
        "Your resistance only makes my penis harder!",
        "Grab them, squeeze them, pinch them, pull them, lick them, bite them, suck them!",
        "It feels like his dick is sliding into a slimy pile of macaroni!",
        "Cum, you naughty cock! Do it! Do it! DO IT!!!",
        "Ahhhh... It's like a dream come true... I get to stick my dick inside Tatsuki Chan's ass...!",
        "This is the cock block police! Hold it right there!",
        "Y-You'll break M-my womb M-Master",
        "Ohoo, getting creampied made you cum? What a lewd bitch you are!",
        "I've jerked off every single day... Given birth to countless snails... All while fantasizing about the day I'd get to fuck you!",
        "You're looking at porn when you could be using your little sister instead!",
        "Umm... I don't wanna sound rude, but have you had a bath? Your panties look a bit yellow...",
        "H-hey, hey S-Sempai... W-wanna cuddle? UwU",
        "F-fuck my bussy M-Master!",
        "Hey, who wants a piece of this plump 19-year-old boy-pussy? Single file, boys, come get it while it's hot!",
        "Kouji-Kun, if you keep thrusting that hard, my boobs will fall off!",
        "Papa you liar! How could you say that while having such a HUGE erection.",
        "I-I just wanna borrow y-your dick...",
        "Hehe don't touch me there Onii-chann UwU",
        "Your cum is all over my wet clit M-Master",
        "It Feels like you're pounding me with the force of a thousand suns Senpai",
        "I like when Y-you fill me with your baby water S-Senpai",
        "Y-yes right there S-Sempai hooyah",
        "P-please keep filling my baby chamber S-Sempai",
        "O-Onii-chan it felt so good when you punded my bussy",
        "P-please Onii-chan keep filling my baby chamber with your melty juice",
        "O-Onii-chan you just one shot my baby chamber",
        "I-Im nothing but a F-fucktoy slut for your M-monster fuckmeat!",
        "Dominate my ovaries with your vicious swimmers!",
        "Impregnate me with your viral stud genes!",
        "M-My body yearns for your sweet dick milk",
        "Y-Your meat septer has penetrated my tight boy hole",
        "M-My nipples are being tantalized",
        "Mnn FASTER... HARDER! Turn me into your femboy slut~!",
        "Penetrate me until I bust!",
        "Mmmm- soothe me, caress me, Fuck me, breed me!",
        "Probe your thick, wet, throbbing cock deeper and deeper into my boipussy~!!",
        "I'm your personal cum bucket!!",
        "Hya! Not my ears! Ah... It tickles! Ah!",
        "Can you really blame me for getting a boner after seeing that?",
        "The two of us will cover my sis with our cum!",
        "Kouta... I can't believe how BIG his... Wait! Forget about that!! Is Nyuu-chan really giving him a Tit-Fuck!?",
        "Senpai shove deeper your penis in m-my pussy (>ω<) please",
        "This... This is almost like... like somehow I'm the one raping him!",
        "I'm coming fwom you fwuking my asshole mmyyy!",
        "Boys just can't consider themselves an adult... Until they've had a chance to cum with a girl's ampit.",
        "P-Please be gentle, Goku-Senpai!",
        "We're both gonna fuck your pussy at the same time!"
    }
})

ui.group_name = "Kill Say"
ui.is_enabled = menu.add_checkbox(ui.group_name, "Kill Say", false)

ui.current_list = menu.add_selection(ui.group_name, "Phrase List", (function()
    local tbl = {}
    for k, v in pairs(kill_say.phrases) do
        table.insert(tbl, ("%d. %s"):format(k, v.name))
    end

    return tbl
end)())

kill_say.player_death = function(event)

    if event.attacker == event.userid or not ui.is_enabled:get() then
        return
    end

    local attacker = entity_list.get_player_from_userid(event.attacker)
    local localplayer = entity_list.get_local_player()

    if attacker ~= localplayer then
        return
    end

    local current_killsay_list = kill_say.phrases[ui.current_list:get()].phrases
    local current_phrase = current_killsay_list[client.random_int(1, #current_killsay_list)]:gsub('\"', '')
    
    engine.execute_cmd(('say "%s"'):format(current_phrase))
end

callbacks.add(e_callbacks.EVENT, kill_say.player_death, "player_death")