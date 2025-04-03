local ui_call = require("UI Callbacks")

local run_jitter = false

local selection_item = menu.add_selection("Anti-Aim Helper", "centered jitter", {"off", "centered", "random-centered"})
local jitter_value = menu.add_slider("Anti-Aim Helper", "centered jitter value", 1, 90)
local min_jitter_value = menu.add_slider("Anti-Aim Helper", "centered minimum jitter value", 1, 90)
local max_jitter_value = menu.add_slider("Anti-Aim Helper", "centered maximum jitter value", 1, 90)
menu.add_separator("Anti-Aim Helper")
local delay_value = menu.add_slider("Anti-Aim Helper", "delay value", 16, 60)

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

menu.add_callback(selection_item, handle_menu)