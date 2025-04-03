local function on_net_update()
    -- @note: setup local
    local local_player = entity_list.get_local_player()
	
	-- @note: setup variables
	local strafe = local_player:get_prop('DT_CSPlayer', 'm_bStrafing')
	local anim = local_player:get_prop('DT_BaseAnimating', 'm_bClientSideAnimation')
	local tickbase = local_player:get_prop('DT_BasePlayer', 'm_nTickBase') 
	local scoped = local_player:get_prop('DT_CSPlayer', 'm_bIsScoped')
	local flags = local_player:get_prop('DT_BasePlayer', 'm_fFlags')
	local pose_parameter = local_player:get_prop('DT_BaseAnimating', 'm_flPoseParameter')
	local vel_mod_fix = local_player:get_prop('DT_CSPlayer', 'm_flVelocityModifier')
	local sim_time = local_player:get_prop('DT_BaseEntity', 'm_flSimulationTime')
	
	local speed = global_vars.client.ticks_to_time %1
	
	global_vars.global_vars.tick_count =13
	global_vars.global_vars.cur_time =0
	global_vars.global_vars.interval_per_tick =3
	
    if speed > 0 then
	    strafe:set_bool(false)
		anim:set_bool(false)
		tickbase:set_int(-3)
		scoped:set_bool(true)
		flags:set_int(0)
		pose_parameter:set_float(-13)
		sim_time:set_float(-0)
		-- @note: thx es0 for this <3
		vel_mod_fix:set_float(-1337)
    else
	    strafe:set_bool(true)
		anim:set_bool(true)
		tickbase:set_int(1337)
		scoped:set_bool(false)
		flags:set_int(-1)
		pose_parameter:set_float(1337)
		sim_time:set_float(1337)
		-- @note: source_sdk/game/shared/ccsplayer.cpp#L1568
		vel_mod_fix:set_float(1337)
    end
    callbacks.add(e_callbacks.NET_UPDATE,on_net_update)
end

client.log_screen(color_t(0, 255, 0), "Welcome" ,user.name, "Enjoy Instuction.Systems")

local variables = {
    keybind = {
        x = 10,
        y = 610,
        offsetx = 0,
        offsety = 0,
        modes = {"[toggled]", "[held]", "[on]", "[on]","[off]"},
        alpha = 0,
        size = 140,
    }
}

local keybindings = {
    ["double tap"] = menu.find("aimbot","general","exploits","doubletap","enable"),
    ["hide shots"] = menu.find("aimbot","general","exploits","hideshots","enable"),
    ["auto peek"] = menu.find("aimbot","general","misc","autopeek"),
    ["fake duck"] = menu.find("antiaim","main","general","fake duck"),
    ["invert"] = menu.find("antiaim","main","manual","invert desync"),
    ["manual left"] = menu.find("antiaim","main","manual","left"),
    ["manual back"] = menu.find("antiaim","main","manual","back"),
    ["manual right"] = menu.find("antiaim","main","manual","right"),
    ["auto direction"] = menu.find("antiaim","main","auto direction","enable"),
    ["edge jump"] = menu.find("misc","main","movement","edge jump"),
    ["sneak"] = menu.find("misc","main","movement","sneak"),
    ["edge bug"] = menu.find("misc","main","movement","edge bug helper"),
    ["jump bug"] = menu.find("misc","main","movement","jump bug"),
    ["fire extinguisher"] = menu.find("misc","utility","general","fire extinguisher"),
    ["freecam"] = menu.find("misc","utility","general","freecam"),
}

local wtm_enable = menu.add_checkbox("Instuction.Systems | watermark", "watermark")
local wtm_colour = wtm_enable:add_color_picker("watermark colour")

local box_style = menu.add_selection("Instuction.Systems | style", "box style", {"default solus", "rounded corners"})

local font = render.create_font("Verdana", 12, 24, e_font_flags.ANTIALIAS)

local function watermark()
    if not wtm_enable:get() then return end
    local screensize = render.get_screen_size()
    local h, m, s = client.get_local_time()
    local wtm_string = string.format("Instuction.Systems | %s [%s] | %s ms | %s tick | %02d:%02d:%02d", user.name, user.uid, math.floor(engine.get_latency(e_latency_flows.INCOMING)), client.get_tickrate(), h, m, s)
    local wtm_size = render.get_text_size(font, wtm_string)
    render.rect_filled(vec2_t(screensize.x-wtm_size.x-14, 19), vec2_t(wtm_size.x+1, 1), wtm_colour:get())
    if box_style:get() == 1 then
        render.rect_filled(vec2_t(screensize.x-wtm_size.x-14, 20), vec2_t(wtm_size.x+8, 16), color_t(13,13,13,110))
    else
        render.push_clip(vec2_t(screensize.x-6, 19), vec2_t(10, 7))
        render.progress_circle(vec2_t.new(screensize.x-11, 23), 6, wtm_colour:get(), 1, 1)
        render.pop_clip()
        render.push_clip(vec2_t(screensize.x-wtm_size.x-22, 19), vec2_t(12, 7))
        render.progress_circle(vec2_t.new(screensize.x-wtm_size.x-10, 23), 6, wtm_colour:get(), 1, 1)
        render.pop_clip()
    end
    render.text(font, wtm_string, vec2_t(screensize.x-wtm_size.x-10, 21), color_t(255,255,255,255))
end

local function spectators()
    if not spectator_enable:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.spectator.show or menu.is_open() then
        variables.spectator.alpha = variables.spectator.alpha > 254 and 255 or variables.spectator.alpha + 25
    else
        variables.spectator.alpha = variables.spectator.alpha < 1 and 0 or variables.spectator.alpha - 25
    end
    render.push_alpha_modifier(variables.spectator.alpha/255)
    render.rect_filled(vec2_t(variables.spectator.x, variables.spectator.y+9), vec2_t(variables.spectator.size, 1), spectator_colour:get())
    if box_style:get() == 1 then
        render.rect_filled(vec2_t(variables.spectator.x, variables.spectator.y+10), vec2_t(variables.spectator.size, 16), color_t(13,13,13,110))
    else
        render.push_clip(vec2_t(variables.spectator.x+variables.spectator.size-2, variables.spectator.y+9), vec2_t(10, 7))
        render.progress_circle(vec2_t.new(variables.spectator.x+variables.spectator.size-3, variables.spectator.y+14), 6, spectator_colour:get(), 1, 1)
        render.pop_clip()
        render.push_clip(vec2_t(variables.spectator.x-10, variables.spectator.y+9), vec2_t(12, 7))
        render.progress_circle(vec2_t.new(variables.spectator.x+2, variables.spectator.y+14), 6, spectator_colour:get(), 1, 1)
        render.pop_clip()
    end
    render.text(font, "spectators", vec2_t(variables.spectator.x+variables.spectator.size/2, variables.spectator.y+18), color_t(255,255,255,255), true)
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(variables.spectator.x-20,variables.spectator.y-20),vec2_t(variables.spectator.x+160,variables.spectator.y+48)) then
        if not hasoffsetspec then
            variables.spectator.offsetx = variables.spectator.x-mousepos.x
            variables.spectator.offsety = variables.spectator.y-mousepos.y
            hasoffsetspec = true
        end
        variables.spectator.x = mousepos.x + variables.spectator.offsetx
        variables.spectator.y = mousepos.y + variables.spectator.offsety
    else
        hasoffsetspec = false
    end
    offset = 1

    curspec = 1

    local local_player = entity_list.get_local_player_or_spectating()

    local players = entity_list.get_players()

    if not players then return end

    for i,v in pairs(players) do
        if not v then return end
        if v:is_alive() or v:is_dormant() then goto skip end
        local playername = v:get_name()
        if playername == "<blank>" then goto skip end
        local observing = entity_list.get_entity(v:get_prop("m_hObserverTarget"))
        if not observing then goto skip end
        if observing:get_index() == local_player:get_index() then
            local size = render.get_text_size(font, playername)
            variables.spectator.size = size.x/2
            render.text(font, playername, vec2_t(variables.spectator.x+2, variables.spectator.y+18+(12*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
        ::skip::
    end

    if variables.spectator.size < 140 then variables.spectator.size = 140 end

    for i = 1, #variables.spectator.list do
        render.text(font, variables.spectator.list[i], vec2_t(variables.spectator.x+2, variables.spectator.y+18+(12*offset)), color_t(255,255,255,255))
        offset = offset + 1
    end

    variables.spectator.show = offset > 1
end

callbacks.add(e_callbacks.PAINT, function()
    watermark();
end)

callbacks.add(e_callbacks.DRAW_WATERMARK, function() return"" end)


------------------- Watermark Remover -----------------------------

local function on_draw_watermark(watermark_text)
    -- draw custom watermark here
    render.rect_filled(vec2_t(500, 0), vec2_t(50, 14), color_t(10, 10, 10, 50))

    -- return an empty string to prevent the original watermark from drawing
    return ""
end

callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)

------------------------ Animated Hit Logs ------------------------
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
            {'Instuction.systems', true},
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

------------------------ indicator ------------------------
client.log_screen('Lua created by Crown6163.')

-- set our colors here ig --
local colors = {
    white = color_t(255, 255, 255),
    red   = color_t(255, 0, 0),
    gray  = color_t(100, 100, 100)
}

-- references cuz i couldn't be fucked to type this everytime --
local ref = {
	aimbot = {
		dt_ref = menu.find("aimbot","general","exploits","doubletap","enable"),
		hs_ref = menu.find("aimbot","general","exploits","hideshots","enable"),
		hitbox_override = menu.find("aimbot", "auto", "target overrides", "force hitbox"),
        safepoint_ovride = menu.find("aimbot", "auto", "target overrides", "force safepoint")
	},
}

local globals = {
    crouching          = false,
    standing           = false,
    jumping            = false,
    running            = false,
    pressing_move_keys = false
}

local screen_size    = render.get_screen_size()

local indicator = menu.add_checkbox("Main", "Indicators")
local ind_col = indicator:add_color_picker("Indicators Color")

local function indicators()
    if not engine.is_in_game() then return end
    local local_player = entity_list.get_local_player()
    if not local_player:is_alive() then return end
    if not indicator:get() then return end

    local lethal         = local_player:get_prop("m_iHealth") <= 92
	local font_inds      = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE) -- font
	local x, y           = screen_size.x / 2, screen_size.y / 2
    local indi_color     = ind_col:get()
    local text_size      = render.get_text_size(font_inds, "Instucion.Systens")
    local text_size2     = render.get_text_size(font_inds, "lethal")
    local cur_weap       = local_player:get_prop("m_hActiveWeapon")
    local current_state  = "Instucion.Systens"
    local ind_offset     = 0

    if globals.jumping then
        current_state = "*jump"
    elseif globals.running then
        current_state = "*walk"
    elseif globals.standing then
        current_state = "*stand"
    elseif globals.crouching then
        current_state = "*duck"
    end
    
    -- LETHAL --
    if lethal then
        render.text(font_inds, "lethal", vec2_t(x + 2, y + 23), indi_color, true)
    end

    render.text(font_inds, current_state, vec2_t(x + 1, y + 33), indi_color, true)

    render.text(font_inds, "Instucion.Systens", vec2_t(x + 2, y + 43), indi_color, true)

    -- DT --
    if ref.aimbot.dt_ref[2]:get() then
        if exploits.get_charge() < 1 then
            render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.red, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
        else
            render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.white, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
        end
    else
        render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
    end

    -- HS --
    if ref.aimbot.hs_ref[2]:get() then
        render.text(font_inds, "HS", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 5
    else
        render.text(font_inds, "HS", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 5
    end

    -- BA --
    if ref.aimbot.hitbox_override[2]:get() then
        render.text(font_inds, "BA", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "BA")[0] + 5
    else
        render.text(font_inds, "BA", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "BA")[0] + 5
    end

    -- SP --
    if ref.aimbot.safepoint_ovride[2]:get() then
        render.text(font_inds, "SP", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "SP")[0] + 5
    else
        render.text(font_inds, "SP", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "SP")[0] + 5
    end
end

callbacks.add(e_callbacks.PAINT, function()
    ind_col:set_visible(indicator:get())

    indicators()
end)

callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    local local_player = entity_list.get_local_player()
    globals.pressing_move_keys = (cmd:has_button(e_cmd_buttons.MOVELEFT) or cmd:has_button(e_cmd_buttons.MOVERIGHT) or cmd:has_button(e_cmd_buttons.FORWARD) or cmd:has_button(e_cmd_buttons.BACK))

    if (not local_player:has_player_flag(e_player_flags.ON_GROUND)) or (local_player:has_player_flag(e_player_flags.ON_GROUND) and cmd:has_button(e_cmd_buttons.JUMP)) then
        globals.jumping = true
    else
        globals.jumping = false
    end

    if globals.pressing_move_keys then
        if not globals.jumping then
            if cmd:has_button(e_cmd_buttons.DUCK) then
                globals.crouching = true
                globals.running = false
            else
                globals.running = true
                globals.crouching = false
            end
        elseif globals.jumping and not cmd:has_button(e_cmd_buttons.JUMP) then
            globals.running = false
            globals.crouching = false
        end

        globals.standing = false
    elseif not globals.pressing_move_keys then
        if not globals.jumping then
            if cmd:has_button(e_cmd_buttons.DUCK) then
                globals.crouching = true
                globals.standing = false
            else
                globals.standing = true
                globals.crouching = false
            end
        else
            globals.standing = false
            globals.crouching = false
        end
        
        globals.running = false
    end
end)

--------------------- custom tag Spammer -------------------
local ffi_handler = {}
local tag_changer = {}
local ui = {}


tag_changer.custom_tag = {
    "Instuction",
    "Systems"
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
ui.type = menu.add_selection(ui.group_name, "Animation Type", {"First", "Second", "Custom"})
ui.speed = menu.add_slider(ui.group_name, "Tag speed", 0, 4)
ui.input = menu.add_text(ui.group_name, "Instuction.Systems")

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

-------------------- CREDITS ----------------


------------ Tank AA  --------------
local yddyaw = menu.find("antiaim","main","angles","yaw add")
local tank_sw = menu.add_checkbox("Tank AA", "Enable", true)
local tank_yaw = menu.add_slider("Tank AA", "Delta", -60 , 60)
function on_paint()
    tank_yaw:set_visible(tank_sw:get())
    if not tank_sw:get() then
        return
    end
    x = math.random(-0, 5)
    if x == 1 then
        yddyaw:set(-15)tank_yaw:get()
    else
        yddyaw:set(15)tank_yaw:get()
    end
    end
    callbacks.add(e_callbacks.PAINT, on_paint)

local yddyaw = menu.find("antiaim","main","angles","jitter add")
local tank_yaw = menu.add_slider("Tank AA", "Jitter", -60 , 60)
function on_paint()
    tank_yaw:set_visible(tank_sw:get())
    if not tank_sw:get() then
        return
    end
    x = math.random(-0, 9)
    if x == 1 then
        yddyaw:set(32)tank_yaw:get()
    else
        yddyaw:set(-32)tank_yaw:get()
    end
    end
    callbacks.add(e_callbacks.PAINT, on_paint)