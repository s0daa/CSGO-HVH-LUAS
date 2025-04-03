--------------------------------------------------------------------------------
-- Caching common functions
--------------------------------------------------------------------------------
local client_set_event_callback, ui_get, ui_new_checkbox, ui_new_slider, ui_set_callback, ui_set_visible = client.set_event_callback, ui.get, ui.new_checkbox, ui.new_slider, ui.set_callback, ui.set_visible

--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local cvar_fov      = cvar.viewmodel_fov
local cvar_offset_x = cvar.viewmodel_offset_x
local cvar_offset_y = cvar.viewmodel_offset_y     
local cvar_offset_z = cvar.viewmodel_offset_z

local default_fov       = 680
local default_offset_x  = 25 
local default_offset_y  = 0
local default_offset_z  = -15

--------------------------------------------------------------------------------
-- Viewmodel functions
--------------------------------------------------------------------------------
local function set_viewmodel(fov, x, y, z)
    cvar_fov:set_raw_float(fov * 0.1)
    cvar_offset_x:set_raw_float(x * 0.1)
    cvar_offset_y:set_raw_float(y * 0.1)
    cvar_offset_z:set_raw_float(z * 0.1)
end

--------------------------------------------------------------------------------
-- Menu
--------------------------------------------------------------------------------
local viewmodel_changer     = ui_new_checkbox("LUA", "B", "Viewmodel changer")
local viewmodel_fov         = ui_new_slider("LUA", "B", "Offset fov", -1800, 1800, default_fov, true, nil, 0.1)
local viewmodel_offset_x    = ui_new_slider("LUA", "B", "Offset x", -1800, 1800, default_offset_x, true, nil, 0.1)
local viewmodel_offset_y    = ui_new_slider("LUA", "B", "Offset y", -1800, 1800, default_offset_y, true, nil, 0.1)
local viewmodel_offset_z    = ui_new_slider("LUA", "B", "Offset z", -1800, 1800, default_offset_z, true, nil, 0.1)

local function handle_viewmodel()
    local offset_fov    = ui_get(viewmodel_fov)
    local offset_x      = ui_get(viewmodel_offset_x)
    local offset_y      = ui_get(viewmodel_offset_y)
    local offset_z      = ui_get(viewmodel_offset_z)
    set_viewmodel(offset_fov, offset_x, offset_y, offset_z)
end

ui_set_callback(viewmodel_fov, handle_viewmodel)
ui_set_callback(viewmodel_offset_x, handle_viewmodel)
ui_set_callback(viewmodel_offset_y, handle_viewmodel)
ui_set_callback(viewmodel_offset_z, handle_viewmodel)

local function handle_menu()
    local state = ui_get(viewmodel_changer)
    ui_set_visible(viewmodel_fov, state)
    ui_set_visible(viewmodel_offset_x, state)
    ui_set_visible(viewmodel_offset_y, state)
    ui_set_visible(viewmodel_offset_z, state)
    if not state then
        set_viewmodel(default_fov, default_offset_x, default_offset_y, default_offset_z)
    else
        handle_viewmodel()
    end
end

handle_menu()
ui_set_callback(viewmodel_changer, handle_menu)

--------------------------------------------------------------------------------
-- Event handling
--------------------------------------------------------------------------------
local function shutdown()
    set_viewmodel(default_fov, default_offset_x, default_offset_y, default_offset_z)
end

client_set_event_callback("shutdown", shutdown)