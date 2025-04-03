local ffi = require("ffi")
ffi.cdef[[
    // UIEngine
    typedef void*(__thiscall* access_ui_engine_t)(void*, void); // 11
    typedef bool(__thiscall* is_valid_panel_ptr_t)(void*, void*); // 36
    typedef void*(__thiscall* get_last_target_panel_t)(void*); // 56
    typedef int (__thiscall *run_script_t)(void*, void*, char const*, char const*, int, int, bool, bool); // 113

    // IUIPanel
    typedef const char*(__thiscall* get_panel_id_t)(void*, void); // 9
    typedef void*(__thiscall* get_parent_t)(void*); // 25
    typedef void*(__thiscall* set_visible_t)(void*, bool); // 27
]]
local interface_ptr = ffi.typeof("void***")
local rawpanoramaengine = memory.create_interface("panorama.dll", "PanoramaUIEngine001")
local panoramaengine = ffi.cast(interface_ptr, rawpanoramaengine) -- void***
local panoramaengine_vtbl = panoramaengine[0] -- void**

local access_ui_engine = ffi.cast("access_ui_engine_t", panoramaengine_vtbl[11]) -- void*

local function get_last_target_panel(uiengineptr)
    local vtbl = uiengineptr[0] or error("uiengineptr is nil", 2)
    local func = vtbl[56] or error("uiengineptr_vtbl is nil", 2)
    local fn = ffi.cast("get_last_target_panel_t", func)
    return fn(uiengineptr)
end

local function is_valid_panel_ptr(uiengineptr, itr)
    if itr == nil then 
        return false --error("itr is nil", 2)
    end
    local vtbl = uiengineptr[0] or error("uiengineptr is nil", 2)
    local func = vtbl[36] or error("uiengineptr_vtbl is nil", 2)
    local fn = ffi.cast("is_valid_panel_ptr_t", func)
    return fn(uiengineptr, itr)
end

local function get_panel_id(panelptr)
    local vtbl = panelptr[0] or error("panelptr is nil", 2)
    local func = vtbl[9] or error("panelptr_vtbl is nil", 2)
    local fn = ffi.cast("get_panel_id_t", func)
    return ffi.string(fn(panelptr))
end

local function set_visible(panelptr, state)
    local vtbl = panelptr[0] or error("panelptr is nil", 2)
    local func = vtbl[27] or error("panelptr_vtbl is nil", 2)
    local fn = ffi.cast("set_visible_t", func)
    fn(panelptr, state)
end

local function get_parent(panelptr)
    local vtbl = panelptr[0] or error("panelptr is nil", 2)
    local func = vtbl[25] or error("panelptr_vtbl is nil", 2)
    local fn = ffi.cast("get_parent_t", func)
    return fn(panelptr)
end

local function get_root(uiengineptr, custompanel)
    local itr = get_last_target_panel(uiengineptr) 
    if itr == nil then 
        return
    end
    local ret = nil
    local panelptr = nil
    while itr ~= nil and is_valid_panel_ptr(uiengineptr, itr) do 
        panelptr = ffi.cast("void***", itr)
        if custompanel and get_panel_id(panelptr) == custompanel then 
            ret = itr
            break
        elseif get_panel_id(panelptr) == "CSGOHud" then 
            ret = itr
            break
        elseif get_panel_id(panelptr) == "CSGOMainMenu" then 
            ret = itr
            break
        end
        itr = get_parent(panelptr) or error("Couldn't get parent..", 2)
    end
    return ret
end

local uiengine = ffi.cast("void***", access_ui_engine(panoramaengine))
local run_script = ffi.cast("run_script_t", uiengine[0][113])

local rootpanel = get_root(uiengine) or error("Couldn't get root panel..", 2)

local function eval(code, custompanel, customFile)
    if custompanel then 
        rootpanel = custompanel
    else
        if rootpanel == nil then    
            rootpanel = get_root(uiengine) or error("Couldn't get root panel..", 2)
        end
    end
    local file = customFile or "panorama/layout/base_mainmenu.xml"
    run_script(uiengine, rootpanel, ffi.string(code), file, 8, 10, false, false)
end
local function get_child(childname)
    return get_root(uiengine, childname) or error("Couldn't get root panel..", 2)
end
local function change_visiblity(childptr, state)
    local panelptr = ffi.cast("void***", childptr)
    if is_valid_panel_ptr(uiengine, childptr) then 
        return set_visible(panelptr, state)
    else
        error("Invalid panel..", 2)
    end
end
local function get_child_name(childptr)
    local panelptr = ffi.cast("void***", childptr)
    if is_valid_panel_ptr(uiengine, childptr) then 
        return ffi.string(get_panel_id(panelptr))
    else
        error("Invalid panel..", 2)
    end
end

return {
    eval = eval,
    get_child = get_child,
    get_child_name = get_child_name,
    set_visible = change_visiblity
}