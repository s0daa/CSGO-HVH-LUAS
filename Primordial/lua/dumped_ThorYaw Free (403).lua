--//free build 
--//</moriss>
local yaw_base = menu.find("antiaim", "main", "angles", "yaw add")
 local rotate_enable = menu.find("antiaim", "main", "angles", "rotate")
 local mrotate_range = menu.find("antiaim", "main", "angles", "rotate range")
 local mrotate_speed = menu.find("antiaim", "main", "angles", "rotate speed")
 local desync_side = menu.find("antiaim", "main", "desync", "side") 
 local desync_amount_l = menu.find("antiaim", "main", "desync", "left amount")
 local desync_amount_r = menu.find("antiaim", "main", "desync", "right amount") 
 local antibrute = menu.find("antiaim", "main", "desync", "anti bruteforce")
 local cheat_jitter = menu.find("antiaim", "main", "angles", "jitter mode")
 local auto_direct = menu.find("antiaim", "main", "angles", "yaw base")
 local pitch = menu.find("antiaim", "main", "angles", "pitch")
 local onshot = menu.find("antiaim", "main", "desync", "on shot")
 local override_stand = menu.find("antiaim", "main", "desync", "override stand" )
 local leg_slide = menu.find("antiaim", "main", "general", "leg slide")
 local min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage")
 local min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage")
 local min_damage_h = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
 local min_damage_k = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
 local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
 local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")
 local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
 local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
 local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
 local amount_deagle = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
 local amount_revolver = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
 local amount_pistol = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))
 


 local sYaw_base = yaw_base:get()
 local sRotate_enable = rotate_enable:get()
 local sMrotate_range = mrotate_range:get()
 local sMrotate_speed = mrotate_speed:get()
 local sDesync_side = desync_side:get()
 local sDesync_amount_l = desync_amount_l:get()
 local sDesync_amount_r = desync_amount_r:get()
 local sAntibrute = antibrute:get()
 local sCheat_jitter = cheat_jitter:get()
 local sAuto_direct = auto_direct:get()
 local sPitch = pitch:get()
 local sOnshot = onshot:get()
 local sOverride_stand = override_stand:get()
 local sLeg_slide = leg_slide:get()

 local build = "Free"
 local update = "06.07"

 local colors = {
    white = color_t(255, 255, 255),
    red   = color_t(255, 0, 0),
    gray  = color_t(100, 100, 100)
}

-- references cuz i couldn't be fucked to type this everytime --

local variables = {
    keybind = {
        x = menu.add_slider("THORYAW | Hidden", "kb_x", 0, 3840),
        y = menu.add_slider("THORYAW | Hidden", "kb_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        modes = {"[toggled]", "[hold]", "[on]", "[on]","[off]"},
        alpha = 0,
        size = 160,
    },
    spectator = {
        x = menu.add_slider("THORYAW | Hidden", "spec_x", 0, 3840),
        y = menu.add_slider("THORYAW | Hidden", "spec_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        alpha = 0,
        list = {},
        size = 140,
    }
}

--Variables
local service = {
    notifications = {},
    text_font = render.create_font("Tahoma", 13, 400, e_font_flags.DROPSHADOW),
    direction = 1
}
local accent_color = select(2, unpack(menu.find("misc", "main", "config", "accent color")))
local background_color_fade = color_t(41, 41, 41, 50)
local background_color = color_t(41, 41, 41, 255)
local title_color = color_t(255, 255, 255, 255)
local text_color = color_t(155, 155, 155, 255)
local idle_color = color_t(35, 35, 35, 255)
local function easeInQuad(x)
    return x * x
end
local function notifications_draw()
    local screen_size = render.get_screen_size()
    local base_position = vec2_t(screen_size.x * 0.95, screen_size.y * 0.95)
    table.foreach(service.notifications, function(index, notification)
        local time_delta = notification.duration - (notification.expires_at - global_vars.real_time())
        if time_delta >= notification.duration then
            return table.remove(service.notifications, index)
        end
    end)

    local height_offset = 0
    table.foreach(service.notifications, function(index, notification)  
        local time_delta = notification.duration - (notification.expires_at - global_vars.real_time())
        local title_size = render.get_text_size(service.text_font, notification.title)
        local text_size = render.get_text_size(service.text_font, notification.text)
        local max_size = math.max(title_size.x, text_size.x)
        max_size = vec2_t(max_size + 20, title_size.y + text_size.y + 30)
        local animation_delta = 1
        if time_delta < 0.25 then
            animation_delta = easeInQuad(time_delta * 4)
        elseif time_delta > notification.duration - 0.25 then
            animation_delta = easeInQuad((notification.duration - time_delta) * 4)
        end
        max_size.x = max_size.x > 270 and 270 or max_size.x
        local size_delta = (text_size.x - max_size.x + 20)
        local text_animation = ((time_delta - 0.5) / (notification.duration - 1))
        if text_size.x < max_size.x or time_delta < 0.5 then
            text_animation = 0
        elseif time_delta > (notification.duration - 0.5) then
            text_animation = 1
        end
        local color_alpha = math.floor(255 * animation_delta)
        local time_color = accent_color:get()
        render.push_alpha_modifier(color_alpha / 255)
        local clip_position = vec2_t(base_position.x - max_size.x, base_position.y - max_size.y - height_offset)
        local position = vec2_t(base_position.x - max_size.x * animation_delta, base_position.y - max_size.y - height_offset)
        local bar_width = max_size.x * time_delta / (notification.duration - 0.25)
        local text_clip = position + vec2_t(10, 15 + title_size.y)
        if service.direction == 1 then
            bar_width = max_size.x - bar_width
        end
        render.push_clip(clip_position - vec2_t(0, 10), max_size + vec2_t(0, 10))
        if input.is_mouse_in_bounds(position, max_size) and input.is_key_pressed(e_keys.MOUSE_LEFT) then
            if time_delta < notification.duration - 0.25 then
                notification.expires_at = global_vars.real_time() + 0.25
            end
        end
        render.rect_filled(position, max_size, background_color, 5)
        render.rect_filled(position + vec2_t(0, 10), vec2_t(max_size.x, 1), idle_color)
        render.rect_filled(position + vec2_t(0, 10), vec2_t(bar_width, 1), time_color)
        render.text(service.text_font, notification.title, position + vec2_t(10, 15), title_color)
        render.push_clip(text_clip, vec2_t(250, text_size.y))
        render.text(service.text_font, notification.text, position + vec2_t(10 - size_delta * text_animation, 15 + title_size.y), text_color)
        if max_size.x == 270 then
            if text_animation > 0 then
                render.rect_fade(text_clip, vec2_t(10, text_size.y), background_color, background_color_fade, true)
            end
            if text_animation < 1 then
                render.rect_fade(text_clip + vec2_t(240, 0), vec2_t(10, text_size.y), background_color_fade, background_color, true)
            end
        end
        render.pop_clip()
        render.pop_clip()
        render.pop_alpha_modifier()
        height_offset = height_offset + max_size.y * animation_delta + 5
    end)
end



function service:add_notification(title, text, duration)
    duration = duration + 0.25
    table.insert(self.notifications, {
        title = title, text = text,
        expires_at = global_vars.real_time() + duration,
        duration = duration
    })
end
service:add_notification("THORYAW | Loader free",string.format("Sup %s", user.name), 4)

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

local logs = {}
local fonts = nil


local text = menu.add_text("THORYAW | Info", "Announcement. \n")
local text1 = menu.add_text("THORYAW | Info", "Sup \n" ..user.name)
local text2 = menu.add_text("THORYAW | Info", "Build: \n" ..build)
local text3 = menu.add_text("THORYAW | Info", "Last update: \n" ..update)
local tab = menu.add_selection("THORYAW | Info", "Select Tab", {"Info", "Anti-aim", "Visual", "Misc"})
 
 
 
-- global variables
local state = 0
local side = 0
local animation_breaker = {}
--Anti-Aim
 
 
-- jitter builder 
local jitter_builder  = menu.add_checkbox("THORYAW | Anti-aim", "Builder")
local text4 = menu.add_text("THORYAW | Anti-aim", "Enable this is checkbox for presets to work!")
local function paint5()
    if tab:get() == 2 then
        text4:set_visible(true)
    else
        text4:set_visible(false)
    end
end
callbacks.add(e_callbacks.PAINT,paint5)
local presets = menu.add_selection("THORYAW | Anti-aim", "Presets", {"none", "Jitter #1", "Jitter #2", "Agressive Jitter", "Big dick club",})
local jitter_angle_1 = menu.add_slider("THORYAW | Anti-aim", "Yaw add [L]", -180, 180)
local jitter_angle_2 = menu.add_slider("THORYAW | Anti-aim", "Yaw add [R]", -180, 180)
 
local desync_amount_1 = menu.add_slider("THORYAW | Anti-aim", "Yaw add two [L]", -100, 100)
local desync_amount_2 = menu.add_slider("THORYAW | Anti-aim", "Yaw add two [R]", -100, 100) 
 
local mjitter_speed = menu.add_slider("THORYAW | Anti-aim", "Jitter speed", 1, 3)
 
local mpitch = menu.add_selection("THORYAW | Anti-aim", "Pitch", {"none", "down", "up", "zero", "jitter"})
local mOnshot = menu.add_selection("THORYAW | Anti-aim", "On shot", {"off", "opposite", "same side", "random"})
local do_auto_direct = menu.add_selection("THORYAW | Anti-aim", "Auto Direction", {"none", "Viewangle", "At targets (crosshair)", "At targets (distance)", "Velocity"})
 
local velocity_jitter = menu.add_checkbox("THORYAW | Anti-aim", "Velocity Jitter")
 local vel_max_angle   = menu.add_slider("THORYAW | Anti-aim", "Velocity Jitter max angle", 0, 180)
 local vel_min_angle   = menu.add_slider("THORYAW | Anti-aim", "Velocity Jitter min angle", 0, 180)
 local vel_multiplier  = menu.add_slider("THORYAW | Anti-aim", "Velocity Multiplier", 0, 100, 1, 0, "%")
local do_antibrute = menu.add_checkbox("THORYAW | Misc", "Anti-brute")
local custom_font_enable = menu.add_checkbox("THORYAW | Misc", "Custom ESP font")
 
 
menu.set_group_column("THORYAW | Anti-aim", 2)
 
-- Indicators menu stuff 
local indicator = menu.add_checkbox("THORYAW | Visual", "Enable indicators")
local ind_col = indicator:add_color_picker("Indicators Color")
local wtm_enable = menu.add_checkbox("THORYAW | Visual", "Watermark")
local color2 = wtm_enable:add_color_picker("bruh2 color")
local keybind_enable = menu.add_checkbox("THORYAW | Visual", "Keybinds")
local color3 = keybind_enable:add_color_picker("bruh3 color")
local spectator_enable = menu.add_checkbox("THORYAW | Visual", "Spectators")
local color4 = spectator_enable:add_color_picker("bruh4 color")
 
 
menu.set_group_column("THORYAW | Visual", 1)


local function main(cmd)
local local_player          = entity_list.get_local_player()
local velocity              = local_player:get_prop("m_vecVelocity"):length()   
 
 
 
     cheat_jitter:set(1)
     override_stand:set(false) 
 
     --AntiAim
     local preset = presets:get()
 
     --presets
     if preset == 2 then -- jitter #1
         jitter_angle_1:set(20)
         jitter_angle_2:set(-20)
         desync_amount_1:set(-91)
         desync_amount_2:set(91)
         mpitch:set(2)
         do_auto_direct:set(2)
         mOnshot:set(4)
         mjitter_speed:set(1)
     end
 
     if preset == 3 then -- jitter #2
         jitter_angle_1:set(30)
         jitter_angle_2:set(-30)
         desync_amount_1:set(91)
         desync_amount_2:set(-91)
         mpitch:set(2)
         do_auto_direct:set(2)
         mOnshot:set(4)
         mjitter_speed:set(1)
     end
     if preset == 4 then -- jitter #3 
        jitter_angle_1:set(40)
        jitter_angle_2:set(-40)
        desync_amount_1:set(92)
        desync_amount_2:set(-92)
        mpitch:set(2)
        do_auto_direct:set(2)
        mOnshot:set(4)
        mjitter_speed:set(1)

        rotate_enable:set(true)
        mrotate_range:set(2)
        mrotate_speed:set(100)
    end
    if preset == 5 then
        jitter_angle_1:set(35)
        jitter_angle_2:set(-29)
        desync_amount_1:set(-18)
        desync_amount_2:set(17)
        mpitch:set(2)
        do_auto_direct:set(2)
        mOnshot:set(4)
        mjitter_speed:set(1)

        rotate_enable:set(true)
        mrotate_range:set(2)
        mrotate_speed:set(100)
     end
 
 
     local vjitter_angle_1 = jitter_angle_1:get()
     local vjitter_angle_2 = jitter_angle_2:get()
     local vdesync_amount_1 = desync_amount_1:get()
     local vdesync_amount_2 = desync_amount_2:get()
 
     if velocity_jitter:get() then
         vjitter_angle_1 = velocity_jitter_angle
         vjitter_angle_2 = velocity_jitter_angle * -1
     end
     --Jitter Builder
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
 
     --Auto direction
     auto_direct:set(do_auto_direct() + 1)

     --Anti Bruteforce
     if  do_antibrute:get() then
         antibrute:set(true)
     else
         antibrute:set(false)
     end
 
 
     --Pitch
     pitch:set(mpitch() + 1)
 
 
     --Onshot
     onshot:set(mOnshot() + 1)
 
     --Leg Slide
 
 end

--min dmg
local enabled = true

local screen_size = render.get_screen_size()
local x = screen_size.x / 1.98
local y = screen_size.y / 2.01
local font_inds      = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE)
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

local verdana = render.create_font("Verdana", 12, 22)

local function watermark()
    if not wtm_enable:get() then return end
    local screensize = render.get_screen_size()
    local h, m, s = client.get_local_time()
    local color =  color2:get()
    local text1 = string.format("thoryaw [%s]", build)
    local wtm_size1 = render.get_text_size(verdana, text1)
    local text2 = string.format(" / %s ",user.name)
    local wtm_size2 = render.get_text_size(verdana, text2)
    local text3 = string.format("%s ms ",  math.floor(engine.get_latency(e_latency_flows.INCOMING)))
    local wtm_size3 = render.get_text_size(verdana, text3)
    local text4 = string.format("%02d:%02d ",  h, m)
    local wtm_size4 = render.get_text_size(verdana, text4)
    local text5 = "time"
    local wtm_string = string.format("thoryaw [%s] / %s %dms %02d:%02d time", build, user.name, math.floor(engine.get_latency(e_latency_flows.INCOMING)), h, m, s)
    local wtm_size = render.get_text_size(verdana, wtm_string)
    local wtm_allsize = screensize.x-wtm_size.x

    render.rect_filled(vec2_t(screensize.x-wtm_size.x-18, 8), vec2_t(wtm_size.x+14, 24), color_t(41,41,41,255), 3)
    render.rect_filled(vec2_t(screensize.x-wtm_size.x-16, 10), vec2_t(wtm_size.x+10, 20), color_t(0,0,0,255), 3)
    render.rect(vec2_t(screensize.x-wtm_size.x-19, 7), vec2_t(wtm_size.x+15, 25), color_t(0,0,0,255), 3)

    render.text(verdana, text1, vec2_t(screensize.x-wtm_size.x-12, 13), color)
    render.text(verdana, text2, vec2_t(screensize.x-wtm_size.x+wtm_size1.x-12, 13), color_t(97,97,97,255))
    render.text(verdana, text3, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x-12, 13), color)
    render.text(verdana, text4, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x-12, 13), color)
    render.text(verdana, text5, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x+wtm_size4.x-12, 13), color_t(97,97,97,255))
end

local keybindings = {
    ["Double tap"] = menu.find("aimbot","general","exploits","doubletap","enable"),
    ["On shot anti-aim"] = menu.find("aimbot","general","exploits","hideshots","enable"),
    ["Quick peek assist"] = menu.find("aimbot","general","misc","autopeek"),
    ["Duck peek assist"] = menu.find("antiaim","main","general","fake duck"),
    ["Anti-Aim invert"] = menu.find("antiaim","main","manual","invert desync"),
    ["Slow motion"] = menu.find("misc","main","movement","slow walk"),
    ["Ping spike"] = menu.find("aimbot","general", "fake ping","enable"),
    ["Freestanding"] = menu.find("antiaim","main","auto direction","enable"),
    ["edge jump"] = menu.find("misc","main","movement","edge jump"),
    ["sneak"] = menu.find("misc","main","movement","sneak"),
    ["edge bug"] = menu.find("misc","main","movement","edge bug helper"),
    ["jump bug"] = menu.find("misc","main","movement","jump bug"),
    ["fire extinguisher"] = menu.find("misc","utility","general","fire extinguisher"),
    ["Damage override"] = menu.find("aimbot", "auto", "target overrides", "force min. damage"),
}

local function keybinds()
    if not keybind_enable:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.keybind.show or menu.is_open() then
        variables.keybind.alpha = variables.keybind.alpha > 254 and 255 or variables.keybind.alpha + 15
    else
        variables.keybind.alpha = variables.keybind.alpha < 1 and 0 or variables.keybind.alpha - 15
    end
   
    render.push_alpha_modifier(variables.keybind.alpha/255)

    render.rect_filled(vec2_t(variables.keybind.x:get()- 2, variables.keybind.y:get()+8), vec2_t(variables.keybind.size+4, 24), color_t(41,41,41,255), 3)
    render.rect_filled(vec2_t(variables.keybind.x:get(), variables.keybind.y:get()+10), vec2_t(variables.keybind.size, 20), color_t(0,0,0,255), 3)
    render.rect(vec2_t(variables.keybind.x:get() - 3, variables.keybind.y:get()+7), vec2_t(variables.keybind.size+5, 25), color_t(0,0,0,255), 3)

    render.text(verdana, "thor keybinds", vec2_t(variables.keybind.x:get()+variables.keybind.size/2, variables.keybind.y:get()+20), color3:get(), true)
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(variables.keybind.x:get()-20,variables.keybind.y:get()-20),vec2_t(variables.keybind.x:get()+160,variables.keybind.y:get()+48)) then
        if not hasoffset then
            variables.keybind.offsetx = variables.keybind.x:get()-mousepos.x
            variables.keybind.offsety = variables.keybind.y:get()-mousepos.y
            hasoffset = true
        end
        variables.keybind.x:set(mousepos.x + variables.keybind.offsetx)
        variables.keybind.y:set(mousepos.y + variables.keybind.offsety)
    else
        hasoffset = false
    end
   
    offset = 1

    for i, v in pairs(keybindings) do
        local dap = v[2]
        if dap:get() then
            render.text(verdana, i, vec2_t(variables.keybind.x:get()+2, variables.keybind.y:get()+22+(13*offset)), color_t(255,255,255,255))
            local itssize = render.get_text_size(verdana, variables.keybind.modes[dap:get_mode()+1])
            render.text(verdana, variables.keybind.modes[dap:get_mode()+1], vec2_t(variables.keybind.x:get()+variables.keybind.size-2-itssize.x, variables.keybind.y:get()+22+(13*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
    end

    variables.keybind.show = offset > 1
end

local function spectators()
    if not spectator_enable:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.spectator.show or menu.is_open() then
        variables.spectator.alpha = variables.spectator.alpha > 254 and 255 or variables.spectator.alpha + 15
    else
        variables.spectator.alpha = variables.spectator.alpha < 1 and 0 or variables.spectator.alpha - 15
    end
    render.push_alpha_modifier(variables.spectator.alpha/255)
    render.rect_filled(vec2_t(variables.spectator.x:get()- 2, variables.spectator.y:get()+8), vec2_t(variables.spectator.size+4, 24), color_t(41,41,41,255), 3)
    render.rect_filled(vec2_t(variables.spectator.x:get(), variables.spectator.y:get()+10), vec2_t(variables.spectator.size, 20), color_t(0,0,0,255), 3)
    render.rect(vec2_t(variables.spectator.x:get() - 3, variables.spectator.y:get()+7), vec2_t(variables.spectator.size+5, 25), color_t(0,0,0,255), 3)

    render.text(verdana, "thor spectators", vec2_t(variables.spectator.x:get()+variables.spectator.size/2, variables.spectator.y:get()+20), color4:get(), true)

    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(variables.spectator.x:get()-20,variables.spectator.y:get()-20),vec2_t(variables.spectator.x:get()+160,variables.spectator.y:get()+48)) then
        if not hasoffsetspec then
            variables.spectator.offsetx = variables.spectator.x:get()-mousepos.x
            variables.spectator.offsety = variables.spectator.y:get()-mousepos.y
            hasoffsetspec = true
        end
        variables.spectator.x:set(mousepos.x + variables.spectator.offsetx)
        variables.spectator.y:set(mousepos.y + variables.spectator.offsety)
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
            local size = render.get_text_size(verdana, playername)
            variables.spectator.size = size.x/2
            render.text(verdana, playername, vec2_t(variables.spectator.x:get()+2, variables.spectator.y:get()+22+(12*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
        ::skip::
    end

    if variables.spectator.size < 140 then variables.spectator.size = 140 end

    for i = 1, #variables.spectator.list do
        render.text(verdana, variables.spectator.list[i], vec2_t(variables.spectator.x:get()+2, variables.spectator.y:get()+22+(12*offset)), color_t(255,255,255,255))
        offset = offset + 1
    end

    variables.spectator.show = offset > 1
end

local function on_paint()
    if not engine.is_in_game() then return end
    local local_player = entity_list.get_local_player()
    local ind_offset = 0
    if not local_player:is_alive() then return end
    if not indicator:get() then return end

    if enabled then

        if menu.is_open() then return end

        if getweapon() == "ssg08" then
            if min_damage_s[2]:get() then
                render.text(font_inds, tostring(amount_scout:get()), vec2_t(x - -25 + ind_offset, y + 49), color_t(255, 255, 255))
            end
        elseif getweapon() == "deagle" then
            if min_damage_h[2]:get() then
                render.text(font_inds, tostring(amount_deagle:get()), vec2_t(x - -25 + ind_offset, y + 49), color_t(255, 255, 255))
            end
        elseif getweapon() == "revolver" then
            if min_damage_k[2]:get() then
                render.text(font_inds, tostring(amount_revolver:get()), vec2_t(x - -25 + ind_offset, y + 49), color_t(255, 255, 255))
            end
        elseif getweapon() == "awp" then
            if min_damage_awp[2]:get() then
                render.text(font_inds, tostring(amount_awp:get()), vec2_t(x - -25 + ind_offset, y + 49), color_t(255, 255, 255))
            end
        elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
            if min_damage_a[2]:get() then
                render.text(font_inds, tostring(amount_auto:get()), vec2_t(x - -25 + ind_offset, y + 49), color_t(255, 255, 255))
            end
        elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
            if min_damage_p[2]:get() then
                render.text(font_inds, tostring(amount_pistol:get()), vec2_t(x - -25 + ind_offset, y + 49), color_t(255, 255, 255))
            end
        end
    end
end

callbacks.add(e_callbacks.PAINT, function()
    indicator:set_visible(true)

    on_paint()
end)

local function paint4()
    if presets:get() == 1 then
        jitter_angle_1:set_visible(false)
        jitter_angle_2:set_visible(false)
        desync_amount_1:set_visible(false)
        desync_amount_2:set_visible(false)
        mpitch:set_visible(false)
        do_auto_direct:set_visible(false)
        mOnshot:set_visible(false)
        mjitter_speed:set_visible(false)
        velocity_jitter:set_visible(false)
        vel_max_angle:set_visible(false)
        vel_min_angle:set_visible(false)
        vel_multiplier:set_visible(false)
        jitter_angle_1:set(0)
        jitter_angle_2:set(0)
        desync_amount_1:set(0)
        desync_amount_2:set(0)
    end
    if presets:get() == 2 then
        jitter_angle_1:set_visible(false)
        jitter_angle_2:set_visible(false)
        desync_amount_1:set_visible(false)
        desync_amount_2:set_visible(false)
        mpitch:set_visible(false)
        do_auto_direct:set_visible(false)
        mOnshot:set_visible(false)
        mjitter_speed:set_visible(false)
        velocity_jitter:set_visible(false)
        vel_max_angle:set_visible(false)
        vel_min_angle:set_visible(false)
        vel_multiplier:set_visible(false)
     end
    if presets:get() == 3 then
        jitter_angle_1:set_visible(false)
        jitter_angle_2:set_visible(false)
        desync_amount_1:set_visible(false)
        desync_amount_2:set_visible(false)
        mpitch:set_visible(false)
        do_auto_direct:set_visible(false)
        mOnshot:set_visible(false)
        mjitter_speed:set_visible(false)
        velocity_jitter:set_visible(false)
        vel_max_angle:set_visible(false)
        vel_min_angle:set_visible(false)
        vel_multiplier:set_visible(false)
     end
     if presets:get() == 4 then
        jitter_angle_1:set_visible(false)
        jitter_angle_2:set_visible(false)
        desync_amount_1:set_visible(false)
        desync_amount_2:set_visible(false)
        mpitch:set_visible(false)
        do_auto_direct:set_visible(false)
        mOnshot:set_visible(false)
        mjitter_speed:set_visible(false)
        velocity_jitter:set_visible(false)
        vel_max_angle:set_visible(false)
        vel_min_angle:set_visible(false)
        vel_multiplier:set_visible(false)
     end
     if presets:get() == 5 then
        jitter_angle_1:set_visible(false)
        jitter_angle_2:set_visible(false)
        desync_amount_1:set_visible(false)
        desync_amount_2:set_visible(false)
        mpitch:set_visible(false)
        do_auto_direct:set_visible(false)
        mOnshot:set_visible(false)
        mjitter_speed:set_visible(false)
        velocity_jitter:set_visible(false)
        vel_max_angle:set_visible(false)
        vel_min_angle:set_visible(false)
        vel_multiplier:set_visible(false)
     end
end
local Visual = {}
local ui = {}
Visual.phrases = {}



table.insert(Visual.phrases, {
    name = "Kill say(ENG)",
    phrases = {
        "Got fucked by thoryaw",
        "What's up faggot",
        "Where are you flying miscarriage of an octopus, buy thoryaw",
        "Why are you dead, buy thoryaw and don't die",
        "Owned by thoryaw",
        "Faggot",
        "Very weak for ThorYaw",
        "You're a faggot, where are you going?",
        "best lua on primordial - discord.gg/guatxQ8Q3t",
        "where did ThorYaw slippers fly the best lua",
        "tired of flying away at the first bullet? Buy ThorYaw - discord.gg/guatxQ8Q3t",
        "I - use ThorYaw, suck a huge cock",
        "I'm crazy because I use ThorYaw, be like me, buy ThorYaw",
        "sip, buy ThorYaw",
        "ThorYaw > ALL",
        "1 motherfucker sleep",
        "pissed",
        "You're another parody of me.",
        "Bro, do you know that my mom is a sweetie, she's not perfect",
        "And your mother bites my nails.",
        "Are you aiming for sixes?",
        "I'm going to knock your tonsils out with a member now and then I'll smear raw children on their cheeks.",
        "Chunks love you because you're a horse, and chumps love to fuck horses",
        "You make sounds like a butterfly orgasm",
        "Killing you is too good a present for your mom",
        "This is your limit bro, your cheat is on the verge",
        "Get out the cockerel get out",
        "Are you trying not to kill me? Well, you're good at it",
        "Maurice goes ahead and gives you everything in the mouth",
        "My community is not interested in you, you are very weak for us."

    }
})

table.insert(Visual.phrases, {
    name = "Kill say(RU)",
    phrases = {
        "Получил по ебалу by thoryaw",
        "Чё сдох пидорасина",
        "Куда ты летишь выкидышь осьминога, thoryaw прикупи",
        "Ты почему сдох, thoryaw купи и не умирай",
        "Овнед by тор яв",
        "Пидорас",
        "Очень слабый для ThorYaw",
        "Ты пидорас, куда летишь",
        "лучшая луа на примордиал - discord.gg/guatxQ8Q3t",
        "куда улетел тапочек ThorYaw лучшая луа",
        "устал улетать с первой пули? Купи ThorYaw - discord.gg/guatxQ8Q3t",
        "я - использую ThorYaw, соси огромный член",
        "Я ахуенный, потому что юзаю ThorYaw, будь как я, купи ThorYaw",
        "откисай, ThorYaw купи",
        "ThorYaw > ALL",
        "1 пидорасина ебаная спи",
        "обоссан",
        "Ты очередная пародия на меня.",
        "Бро а ты вкурсе что моя мама лапочка она не прекоснавенная",
        "Да иди назад в пизду к маме ради себя обратно.",
        "Да я на тебя рвотную массу выливал.",
        "Я Тебя хуем душил.",
        "Я тебе горшок с говном на голову надевал.",
        "Я щас тебе в носдри пердану ты задахнешься.",
        "Я щас тебе яйца ампутирую.",
        "Рыба гомик.",
        "В шестёрки метишь?",
        "Я тебе сейчас гланды отстучу членом и потом размажу сырых детей по щекам.",
        "Тебя любят чурки, потому что ты лошадь, а чурки любят ебать лошадей",
        "Ты издаешь звуки похожие на оргазм бабочки",
        "Убить тебя слишком хороший подарок твоей мамке",
        "Это твой предел братюнь, твой чит на грани",
        "Высерайся петушок высерайся",
        "Вы пытаетесь меня не убить? Ну у вас хорошо получается",
        "Мы идём вперёд и всем даёт вам в рот",
        "Ты моему комьюнити не интересен, ты очень слабый для нас."
    }
})


ui.group_name = "THORYAW | Misc"
ui.is_enabled = menu.add_checkbox(ui.group_name, "Kill say", false)

ui.current_list = menu.add_selection(ui.group_name, "Say List", (function()
    local tbl = {}
    for k, v in pairs(Visual.phrases) do
        table.insert(tbl, ("%d. %s"):format(k, v.name))
    end

    return tbl
end)())

Visual.player_death = function(event)

    if event.attacker == event.userid or not ui.is_enabled:get() then
        return
    end

    local attacker = entity_list.get_player_from_userid(event.attacker)
    local localplayer = entity_list.get_local_player()

    if attacker ~= localplayer then
        return
    end

    local current_killsay_list = Visual.phrases[ui.current_list:get()].phrases
    local current_phrase = current_killsay_list[client.random_int(1, #current_killsay_list)]:gsub('\"', '')
    
    engine.execute_cmd(('say "%s"'):format(current_phrase))
end

callbacks.add(e_callbacks.EVENT, Visual.player_death, "player_death")
--
local verdana = render.create_font("Verdana", 12, 24, e_font_flags.ANTIALIAS)
local get_screen = render.get_screen_size()
 
local function indicators()
    if not engine.is_in_game() then return end
    local local_player = entity_list.get_local_player()
    if not local_player:is_alive() then return end
    if not indicator:get() then return end

	local font_inds      = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE) -- font
	local x, y           = screen_size.x / 2, screen_size.y / 2
    local text_size      = render.get_text_size(font_inds, "ThorYaw")
    local cur_weap       = local_player:get_prop("m_hActiveWeapon")
    local current_state  = "ThorYaw"
    local ind_offset     = 0
    local alpha = math.min(math.floor(math.sin((global_vars.real_time()%3) * 4) * 175 + 50), 255)

    if globals.jumping then
        current_state = "/air/"
    elseif globals.running then
        current_state = "/move/"
    elseif globals.standing then
        current_state = "/stand/"
    elseif globals.crouching then
        current_state = "/duck/"
    end
    
    render.text(font_inds, "*ThorYaw", vec2_t(x + -9, y + 43), color_t(255, 255, 255), true)
    render.text(font_inds, "free*", vec2_t(x + 11, y + 36), color_t(219, 112, 147, alpha), 10, true)

    render.text(font_inds, current_state, vec2_t(x + 1, y + 33), color_t(255, 255, 255), true)

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
    indicator:set_visible(true)

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

 local function on_shutdown()
     --Restore Initial Settings
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
 
     print("Unloaded ThorYaw")
     print("Bye!")
 end


 callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
 callbacks.add(e_callbacks.SETUP_COMMAND, main) 
 --
 local function paint()
    if jitter_builder:get() then
        jitter_angle_1:set_visible(true)
        jitter_angle_2:set_visible(true)
        desync_amount_1:set_visible(true)
        desync_amount_2:set_visible(true)
        mjitter_speed:set_visible(true)
        presets:set_visible(true)
        mpitch:set_visible(true)
        mOnshot:set_visible(true)
        do_auto_direct:set_visible(true)
        velocity_jitter:set_visible(true)
        vel_max_angle:set_visible(true)
        vel_min_angle:set_visible(true)
        vel_multiplier:set_visible(true)
    else
        jitter_angle_1:set_visible(false)
        jitter_angle_2:set_visible(false)
        desync_amount_1:set_visible(false)
        desync_amount_2:set_visible(false)
        mjitter_speed:set_visible(false)
        presets:set_visible(false)
        mpitch:set_visible(false)
        mOnshot:set_visible(false)
        do_auto_direct:set_visible(false)
        velocity_jitter:set_visible(false)
        vel_max_angle:set_visible(false)
        vel_min_angle:set_visible(false)
        vel_multiplier:set_visible(false)
    end
end
 local function paint1()
    if ui.is_enabled:get() then
        ui.current_list:set_visible(true)
    else
        ui.current_list:set_visible(false)
    end
    if velocity_jitter:get() then
        vel_max_angle:set_visible(true)
        vel_min_angle:set_visible(true)
        vel_multiplier:set_visible(true)
    else
        vel_max_angle:set_visible(false)
        vel_min_angle:set_visible(false)
        vel_multiplier:set_visible(false)
    end
end

local function paint6()
    if tab:get() == 1 then
        text:set_visible(true)
        text1:set_visible(true)
        text2:set_visible(true)
        text3:set_visible(true)
        jitter_builder:set_visible(false)
        jitter_angle_1:set_visible(false)
        jitter_angle_2:set_visible(false)
        desync_amount_1:set_visible(false)
        desync_amount_2:set_visible(false)
        mjitter_speed:set_visible(false)
        presets:set_visible(false)
        mpitch:set_visible(false)
        mOnshot:set_visible(false)
        do_auto_direct:set_visible(false)
        velocity_jitter:set_visible(false)
        vel_max_angle:set_visible(false)
        vel_min_angle:set_visible(false)
        vel_multiplier:set_visible(false)
        do_antibrute:set_visible(false)
        ui.is_enabled:set_visible(false)
        ui.current_list:set_visible(false)
        indicator:set_visible(false)
    else
        text:set_visible(false)
        text1:set_visible(false)
        text2:set_visible(false)
        text3:set_visible(false)
    end
end
callbacks.add(e_callbacks.PAINT,paint6)

local function paint3()
    if tab:get() == 1 then

        jitter_builder:set_visible(false)
        jitter_angle_1:set_visible(false)
        jitter_angle_2:set_visible(false)
        desync_amount_1:set_visible(false)
        desync_amount_2:set_visible(false)
        mjitter_speed:set_visible(false)
        presets:set_visible(false)
        mpitch:set_visible(false)
        mOnshot:set_visible(false)
        do_auto_direct:set_visible(false)
        velocity_jitter:set_visible(false)
        vel_max_angle:set_visible(false)
        vel_min_angle:set_visible(false)
        vel_multiplier:set_visible(false)
        indicator:set_visible(false)
        do_antibrute:set_visible(false)
        ui.is_enabled:set_visible(false)
        ui.current_list:set_visible(false)
        wtm_enable:set_visible(false)
        keybind_enable:set_visible(false)
        spectator_enable:set_visible(false)
        variables.keybind.x:set_visible(false)
        variables.keybind.y:set_visible(false)
        variables.spectator.x:set_visible(false)
        variables.spectator.y:set_visible(false)
    end
    if tab:get() == 2 then
        jitter_builder:set_visible(true)
        jitter_angle_1:set_visible(true)
        jitter_angle_2:set_visible(true)
        desync_amount_1:set_visible(true)
        desync_amount_2:set_visible(true)
        mjitter_speed:set_visible(true)
        presets:set_visible(true)
        mpitch:set_visible(true)
        mOnshot:set_visible(true)
        do_auto_direct:set_visible(true)
        velocity_jitter:set_visible(true)
        vel_max_angle:set_visible(true)
        vel_min_angle:set_visible(true)
        vel_multiplier:set_visible(true)
        text:set_visible(false)
        text1:set_visible(false)
        text2:set_visible(false)
        text3:set_visible(false)
    else
        jitter_builder:set_visible(false)
        jitter_angle_1:set_visible(false)
        jitter_angle_2:set_visible(false)
        desync_amount_1:set_visible(false)
        desync_amount_2:set_visible(false)
        mjitter_speed:set_visible(false)
        presets:set_visible(false)
        mpitch:set_visible(false)
        mOnshot:set_visible(false)
        do_auto_direct:set_visible(false)
        velocity_jitter:set_visible(false)
        vel_max_angle:set_visible(false)
        vel_min_angle:set_visible(false)
        vel_multiplier:set_visible(false)
    end
    if tab:get() == 3 then
        indicator:set_visible(true)
        ind_col:set_visible(true)
        text:set_visible(false)
        text1:set_visible(false)
        text2:set_visible(false)
        text3:set_visible(false)
        wtm_enable:set_visible(true)
        keybind_enable:set_visible(true)
        spectator_enable:set_visible(true)
        if keybind_enable:get() == true then
            variables.keybind.x:set_visible(true)
            variables.keybind.y:set_visible(true)
        else
            variables.keybind.x:set_visible(false)
            variables.keybind.y:set_visible(false)
        end
        if spectator_enable:get() == true then
            variables.spectator.x:set_visible(true)
            variables.spectator.y:set_visible(true)
        else
            variables.spectator.x:set_visible(false)
            variables.spectator.y:set_visible(false)
        end
    else
        indicator:set_visible(false)
        wtm_enable:set_visible(false)
        keybind_enable:set_visible(false)
        spectator_enable:set_visible(false)
        variables.keybind.x:set_visible(false)
        variables.keybind.y:set_visible(false)
        variables.spectator.x:set_visible(false)
        variables.spectator.y:set_visible(false)
    end
    if tab:get() == 4 then
        do_antibrute:set_visible(true)
        ui.is_enabled:set_visible(true)
        ui.current_list:set_visible(true)
        text:set_visible(false)
        text1:set_visible(false)
        text2:set_visible(false)
        text3:set_visible(false)
        custom_font_enable:set_visible(true)
    else
        do_antibrute:set_visible(false)
        ui.is_enabled:set_visible(false)
        ui.current_list:set_visible(false)
        custom_font_enable:set_visible(false)
    end
end

callbacks.add(e_callbacks.PAINT, notifications_draw)
callbacks.add(e_callbacks.PAINT,watermark)
callbacks.add(e_callbacks.PAINT,keybinds)
callbacks.add(e_callbacks.PAINT,spectators)
callbacks.add(e_callbacks.PAINT,paint)
callbacks.add(e_callbacks.PAINT,paint1)
callbacks.add(e_callbacks.PAINT,paint3)
callbacks.add(e_callbacks.PAINT,paint4)
---
local function on_player_esp(pidor)
    if custom_font_enable:get() then
        pidor:set_font(font1)
        pidor:set_small_font(font22)
    end
end
callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)