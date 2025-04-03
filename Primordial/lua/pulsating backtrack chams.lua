local chams_color = menu.find("visuals", "esp", "models", "history", 0)

local pulsate_master = menu.add_checkbox("backtrack chams", "[enable] pulsating backtrack chams", false)
local pulsate_color = pulsate_master:add_color_picker("pulsating backtrack chams color")
local pulsate_state = menu.add_selection("backtrack chams", "[chams] mode", {"pulsate r", "pulsate g", "pulsate b", "pulsate a"})
local pulsate_delay = menu.add_slider("backtrack chams", "[chams] pulsate delay", 0.1, 1, 0.1, 1)

local function on_paint()
    local clr = pulsate_color:get()
    local p = math.sin(math.abs(-math.pi + (global_vars.real_time() * (1 / pulsate_delay:get())) % (math.pi * 2))) * 255;
    local p_c = math.floor(p)

    if pulsate_master:get() and pulsate_state:get() == 1 then
        chams_color:set(color_t(p_c, clr.g, clr.b, clr.a))
    elseif pulsate_master:get() and pulsate_state:get() == 2 then
        chams_color:set(color_t(clr.r, p_c, clr.b, clr.a))
    elseif pulsate_master:get() and pulsate_state:get() == 3 then
        chams_color:set(color_t(clr.r, clr.g, p_c, clr.a))
    elseif pulsate_master:get() and pulsate_state:get() == 4 then
        chams_color:set(color_t(clr.r, clr.g, clr.b, p_c))
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)