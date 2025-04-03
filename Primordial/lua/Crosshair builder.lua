-- made by stars#3787

local crosshair_style      = menu.add_selection("Crosshair builder", "Crosshair style", {"default", "default static", "dynamic when move/shoot", "full static", "semi static"}) -- style
local crosshair_t          = menu.add_checkbox("Crosshair builder", "Crosshair T shape") -- t shape
local crosshairgap_wpn     = menu.add_checkbox("Crosshair builder", "Crosshair gap weapon based") -- gap based on which weapon is held
local crosshair_color      = menu.add_checkbox("Crosshair builder", "Crosshair color") -- color
local crosshair_clr        = crosshair_color:add_color_picker("crosshair color")
local crosshair_size       = menu.add_slider("Crosshair builder", "Crosshair size", 0, 15, 0.25) -- size
local crosshair_thick      = menu.add_slider("Crosshair builder", "Crosshair thickness", 0, 10, 0.25) -- thickness
local crosshair_gap        = menu.add_slider("Crosshair builder", "Crosshair gap", -5, 10, 0.25) -- gap
local crosshair_dot        = menu.add_checkbox("Crosshair builder", "Crosshair dot") -- dot
local crosshair_out_enable = menu.add_checkbox("Crosshair builder", "Enable crosshair outline")
local crosshair_outline    = menu.add_slider("Crosshair builder", "Crosshair outline", 0, 5, 0.25) -- outline

-- Tables for numbers
local style = {
    0, 
    1, 
    3,
    4,
    5
}

-- apply settings button
local apply_settings = menu.add_button("Crosshair builder", "Apply crosshair settings", function()
    local crosshairt = 0
    local crosshairgapwpn = 0
    local crosshairdot = 0
    local crosshairoutline = 0

    local clr_get = crosshair_clr:get()
    
    -- stuff for checkboxes
    if crosshair_t:get() then crosshairt = 1 else crosshairt = 0 end
    if crosshairgap_wpn:get() then crosshairgapwpn = 1 else crosshairgapwpn = 0 end
    if crosshair_dot:get() then crosshairdot = 1 else crosshairdot = 0 end
    if crosshair_out_enable:get() then crosshairoutline = 1 else crosshairoutline = 0 end

    -- commands
    engine.execute_cmd("cl_crosshairstyle " .. style[crosshair_style:get()])
    engine.execute_cmd("cl_crosshair_t " .. crosshairt)
    engine.execute_cmd("cl_crosshairgap_useweaponvalue " .. crosshairgapwpn)

    -- color stuff
    if crosshair_color:get() then
        engine.execute_cmd("cl_crosshaircolor 5") -- sets it to custom color
        engine.execute_cmd("cl_crosshairusealpha 1") -- makes it use alpha
        engine.execute_cmd("cl_crosshaircolor_r " .. clr_get[0])
        engine.execute_cmd("cl_crosshaircolor_g " .. clr_get[1])
        engine.execute_cmd("cl_crosshaircolor_b " .. clr_get[2])
        engine.execute_cmd("cl_crosshairalpha " .. clr_get[3])
    end

    -- rest of commands
    engine.execute_cmd("cl_crosshairsize " .. crosshair_size:get())
    engine.execute_cmd("cl_crosshairthickness " .. crosshair_thick:get())
    engine.execute_cmd("cl_crosshairgap " .. crosshair_gap:get())
    engine.execute_cmd("cl_crosshairdot " .. crosshairdot)
    engine.execute_cmd("cl_crosshair_drawoutline " .. crosshairoutline)
    engine.execute_cmd("cl_crosshair_outlinethickness " .. crosshair_outline:get())

    print("Crosshair set!")
end)

local function on_paint()

end

callbacks.add(e_callbacks.PAINT, on_paint)