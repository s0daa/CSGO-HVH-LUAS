local client_camera_angles, client_create_interface, client_find_signature, client_set_event_callback, entity_get_classname, entity_get_local_player, entity_get_player_weapon, entity_get_prop, string_match, ui_get, error, ui_new_combobox, ui_new_slider = client.camera_angles, client.create_interface, client.find_signature, client.set_event_callback, entity.get_classname, entity.get_local_player, entity.get_player_weapon, entity.get_prop, string.match, ui.get, error, ui.new_combobox, ui.new_slider
local get_cvar, vo_hand, vfov, vo_x, vo_y, vo_z = client.get_cvar, cvar.cl_righthand, cvar.viewmodel_fov, cvar.viewmodel_offset_x, cvar.viewmodel_offset_y, cvar.viewmodel_offset_z

local dir, restore = { 'LUA', 'B', 4000, { '-', 'Left hand', 'Right hand' } }

local menu = {
    kpos = ui_new_combobox(dir[1], dir[2], 'Knife positioning', dir[4]),
    fov = ui_new_slider(dir[1], dir[2], 'Viewmodel FOV', -dir[3], dir[3], 0, true, '', 0.01),

    x = ui_new_slider(dir[1], dir[2], 'Viewmodel offset X', -dir[3], dir[3], 0, true, '', 0.01),
    y = ui_new_slider(dir[1], dir[2], 'Viewmodel offset Y', -dir[3], dir[3], 0, true, '', 0.01),
    z = ui_new_slider(dir[1], dir[2], 'Viewmodel offset Z', -dir[3], dir[3], 0, true, '', 0.01),
    roll = ui_new_slider(dir[1], dir[2], 'Viewmodel offset Roll', -180, 180, 0, true),
}

local ffi, bit = require 'ffi', require 'bit'
local ffi_to = {
    classptr = ffi.typeof('void***'), 
    client_entity = ffi.typeof('void*(__thiscall*)(void*, int)'),
    
    set_angles = (function()
        ffi.cdef('typedef struct { float x; float y; float z; } vmodel_vec3_t;')

        return ffi.typeof('void(__thiscall*)(void*, const vmodel_vec3_t&)')
    end)()
}

local rawelist = client_create_interface('client_panorama.dll', 'VClientEntityList003') or error('VClientEntityList003 is nil', 2)
local ientitylist = ffi.cast(ffi_to.classptr, rawelist) or error('ientitylist is nil', 2)
local get_client_entity = ffi.cast(ffi_to.client_entity, ientitylist[0][3]) or error('get_client_entity is nil', 2)

local set_angles = client_find_signature('client_panorama.dll', '\x55\x8B\xEC\x83\xE4\xF8\x83\xEC\x64\x53\x56\x57\x8B\xF1') or error('Couldn\'t find set_angles signature!')
local set_angles_fn = ffi.cast(ffi_to.set_angles, set_angles) or error('Couldn\'t cast set_angles_fn')

local get_original = function()
    return {
        rhand = get_cvar('cl_righthand'),
        fov = get_cvar('viewmodel_fov'),
        
        x = get_cvar('viewmodel_offset_x'),
        y = get_cvar('viewmodel_offset_y'),
        z = get_cvar('viewmodel_offset_z')
    }
end

local g_handler = function(...)
    local shutdown = #({...}) > 0

    local multiplier = shutdown and 0 or 0.0025
    local original, data = get_original(), 
    {
        rhand = ui_get(menu.kpos),
        fov = ui_get(menu.fov) * multiplier,
        x = ui_get(menu.x) * multiplier,
        y = ui_get(menu.y) * multiplier,
        z = ui_get(menu.z) * multiplier
    }

    vfov:set_raw_float(original.fov + data.fov)
    vo_x:set_raw_float(original.x + data.x)
    vo_y:set_raw_float(original.y + data.y)
    vo_z:set_raw_float(original.z + data.z)

    vo_hand:set_raw_int(original.rhand)

    if not shutdown and data.rhand ~= dir[4][1] then
        local is_holding_knife = false
        local me = entity_get_local_player()
        local wpn = entity_get_player_weapon(me)
    
        if me ~= nil and wpn ~= nil then
            is_holding_knife = string_match((entity_get_classname(wpn) or ''), 'Knife')
        end
    
        vo_hand:set_raw_int((
            {
                [dir[4][2]] = is_holding_knife and 0 or 1,
                [dir[4][3]] = is_holding_knife and 1 or 0,
            }
        )[data.rhand])
    end
end

local g_override_view = function()
    --[[
        Credits: 
        * tank (rave1337): proper viewmodel roll
    ]]

    local me = entity_get_local_player()
    local viewmodel = entity_get_prop(me, 'm_hViewModel[0]')

    if me == nil or viewmodel == nil then
        return
    end

    local viewmodel_ent = get_client_entity(ientitylist, viewmodel)

    if viewmodel_ent == nil then
        return
    end

    local camera_angles = { client_camera_angles() }
    local angles = ffi.cast('vmodel_vec3_t*', ffi.new('char[?]', ffi.sizeof('vmodel_vec3_t')))

    angles.x, angles.y, angles.z = 
        camera_angles[1], camera_angles[2], ui_get(menu.roll)

    set_angles_fn(viewmodel_ent, angles)
end

client_set_event_callback('pre_render', g_handler)
client_set_event_callback('override_view', g_override_view)
client_set_event_callback('shutdown', function() g_handler(true) end)
