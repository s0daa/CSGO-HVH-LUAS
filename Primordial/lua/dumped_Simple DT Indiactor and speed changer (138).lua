--Pasted by Remine Thank Reload for Source code
--https://primordial.dev/resources/meta-mod-like-watermark.75

local get_screen = render.get_screen_size()
local dt_tog = menu.add_checkbox("DT Speed Changer", "Enable", false)
local warning = menu.add_text("DT Speed Changer", "Recommand Don't Set above 15 (Depeneded Server)")
local dt_speed = menu.add_slider("DT Speed Changer", "Double Tap Speed",14,18)
local dt_ind_tog = menu.add_checkbox("DT Indiactor", "Enable", true)
local dt_style = menu.add_selection("DT Indiactor", "Style", {"Most Simple", "Simple"})
local dt_CCol = dt_ind_tog:add_color_picker("DT Indiactor Charged Color")
local dt_UCol = dt_ind_tog:add_color_picker("DT Indiactor Uncharged Color")
local dt_FCol = dt_ind_tog:add_color_picker("DT Indiactor Fade Color")
local xslid = menu.add_slider("DT Indiactor", "Ind x",0,get_screen.x)
local yslid = menu.add_slider("DT Indiactor", "Ind y",0,get_screen.y)
local verdana = render.create_font("Verdana", 15, 16, e_font_flags.ANTIALIAS)
local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")

local function dt_ind()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    local choice = dt_style:get()
    local dt_tick = exploits.get_charge()
    local posx = xslid:get()
    local posy = yslid:get()
    local cur_time = global_vars.cur_time()
    local pulse = math.sin(math.abs(-math.pi + (cur_time * 1) % (math.pi * 2))) * 1
	local text_size = 12,12
    local magic = 0.07142
    if dt_tick == 15 then
        magic = 0.06666
    else if dt_tick == 16 then
        magic = 0.06252
    else if dt_tick == 17 then
        magic = 0.05882
    else if dt_tick == 18 then
        magic = 0.05555
    end
  end 
 end
end
    --draw ind
    local col = dt_CCol:get()
    local fade = dt_FCol:get()
    if dt_tick < 14 then
    col = dt_UCol:get()
    end
    local isr = dt_tick < 14 and "X " or "✔ "
    local text = string.format(" Primordial DT | Ready: "..isr)
    if local_player:get_prop("m_iHealth") > 0 then
    if dt_ind_tog:get() and choice == 1 then
    local dtText = string.format(" Primordial DT | ticks："..dt_tick)
	local text_size = 12,12
    render.rect_filled(vec2_t(posx, posy), vec2_t(180, 2), color_t(255,255,255,150))
    render.rect_filled(vec2_t(posx, posy), vec2_t(180*dt_tick*magic, 2), col)
    render.rect_filled(vec2_t(posx, posy), vec2_t(180, 20), color_t(0,0,0,150))
    render.text(verdana, dtText, vec2_t(posx+10, posy+3), color_t(255,255,255))
    end  
    if dt_ind_tog:get() and choice == 2 then
    local dtText = string.format(" Primordial DT | ticks："..dt_tick)
    local text_size = 12,12
    render.text(verdana, text, vec2_t(posx+10, posy+3), color_t(255,255,255)) --text
    render.rect_filled(vec2_t(posx, posy), vec2_t(180, 20), color_t(0,0,0,120)) --shadow
    render.push_alpha_modifier(pulse)
    render.rect_fade(vec2_t(posx, posy-1), vec2_t(90, 1), fade, col, true) --top left
    render.rect_fade(vec2_t(posx+90, posy-1), vec2_t(90, 1), col, fade, true) --top right
    render.rect_fade(vec2_t(posx, posy+20), vec2_t(90, 1), fade, col, true) --down left
    render.rect_fade(vec2_t(posx+90, posy+20), vec2_t(90, 1), col, fade, true) --down right
    render.pop_alpha_modifier() 
    end
    --change dt speed
    if dt_tog:get() and dt_ref[2]:get() then
        cvars.sv_maxusrcmdprocessticks:set_int(dt_speed:get()+2)
        cvars.cl_clock_correction:set_int(0)
        cvars.cl_clock_correction_adjustment_max_amount:set_int(450)
    else
        cvars.sv_maxusrcmdprocessticks:set_int(16)
        cvars.cl_clock_correction:set_int(1)
    end
end
end

callbacks.add(e_callbacks.PAINT, dt_ind)