local pui = require("gamesense/pui") or error("Subscribe to PUI Library | https://gamesense.pub/forums/viewtopic.php?id=41761")
local ffi = require("ffi")
local vector = require("vector");

local option_names = {"Follow Aimbot", "Fakeduck Animation", "Hide Sliders"}
local options = {false,false,false}
local group = pui.group("Lua", "B")
local menu = {
    options = group:multiselect("[ \vViewmodel \r] Options", option_names),
    in_scope = group:checkbox("Viewmodel In scope"),
    fov = group:slider("Viewmodel Fov", 0, 120, 68, true, "", 1, {}),
    x = group:slider("\nViewmodel X", -100, 100, 0, true, "u", 0.1, { [0] = "center" }),
    y = group:slider("\nViewmodel Y", -100, 100, 0, true, "u", 0.1, { [0] = "center" }),
    z = group:slider("\nViewmodel Z", -100, 100, 0, true, "u", 0.1, { [0] = "center" }),
    pitch = group:slider("Viewmodel Pitch", -90, 90, 0, true, "°", 1, { [0] = "off" }),
    yaw = group:slider("Viewmodel Yaw", -90, 90, 0, true, "°", 1, { [0] = "off" }),
    roll = group:slider("Viewmodel Roll", -180, 180, 0, true, "°", 1, { [0] = "off" }),
}

local fakeduck_ref = pui.reference("RAGE", "Other", "Duck peek assist")

--Viewmodel
local SetAbsAngles = ffi.cast("void(__thiscall*)(void*, const Vector*)", client.find_signature("client.dll", "\x55\x8B\xEC\x83\xE4\xF8\x83\xEC\x64\x53\x56\x57\x8B\xF1"));
local IEntityList = ffi.cast("void***", client.create_interface("client.dll", "VClientEntityList003"));
local GetClientEntity = ffi.cast("uintptr_t (__thiscall*)(void*, int)", IEntityList[0][3]);

--Show in scope
local ccsweaponinfo_t = [[
    struct {
        char         __pad_0x0000[0x1cd];                   // 0x0000
        bool         hide_vm_scope;                // 0x01d1
    }
]]

local match = client.find_signature("client_panorama.dll", "\x8B\x35\xCC\xCC\xCC\xCC\xFF\x10\x0F\xB7\xC0")
local weaponsystem_raw = ffi.cast("void****", ffi.cast("char*", match) + 2)[0]
local get_weapon_info = vtable_thunk(2, ccsweaponinfo_t .. "*(__thiscall*)(void*, unsigned int)")

local shot = {
    time = 0,
    pitch = 0,
    yaw = 0,
}

local viewmodel = {} do
    viewmodel.fov = cvar.viewmodel_fov;
    viewmodel.offset_x = cvar.viewmodel_offset_x;
    viewmodel.offset_y = cvar.viewmodel_offset_y;
    viewmodel.offset_z = cvar.viewmodel_offset_z;
    viewmodel.vec = vector(0, 0, 0);

    function viewmodel:update()
        viewmodel.fov:set_raw_float(     menu.fov:get()   )
        viewmodel.offset_x:set_raw_float(menu.x:get() / 10)
        viewmodel.offset_y:set_raw_float(menu.y:get() / 10)
        viewmodel.offset_z:set_raw_float(menu.z:get() / 10)
    end
    
    function viewmodel:aim_fire(event)
        if not options[1] then return end
        local lp = entity.get_local_player();
        if not lp or not entity.is_alive(lp) then return end
    
        local pitch, yaw, roll = (vector(client.eye_position())):to(vector(event.x, event.y, event.z)):angles()
    
        shot.time = globals.curtime();
        shot.pitch = pitch;
        shot.yaw = yaw;
    end

    function viewmodel:override_view()
        local pitch, yaw = client.camera_angles();

        if shot.time ~= 0 and math.abs(globals.curtime() - shot.time) > 0.5 then
            shot.time = 0;
        end

        viewmodel.vec.x = shot.time ~= 0 and shot.pitch or pitch - menu.pitch:get();
        viewmodel.vec.y = shot.time ~= 0 and shot.yaw or yaw - menu.yaw:get();

        viewmodel.vec.z = -menu.roll:get()
    
        for _, index in pairs(entity.get_all("CPredictedViewModel")) do
            if not entity.is_dormant(index) then
                SetAbsAngles(
                    ffi.cast("int*", GetClientEntity(IEntityList, index)),
                    viewmodel.vec
                )
            end
        end
    end
    
    function viewmodel:paint()
        if not options[2] then return end
        local lp = entity.get_local_player();
        if not lp or not entity.is_alive(lp) then return end
        viewmodel.offset_z:set_raw_float(menu.z:get() / 10 - (fakeduck_ref:get() and (entity.get_prop(lp, "m_vecViewOffset[2]") - 48) * 0.5 or 0))
    end
end

--callbacks

client.set_event_callback("aim_fire", function(e) viewmodel:aim_fire(e) end)
client.set_event_callback("paint", viewmodel.paint)
client.set_event_callback("override_view", viewmodel.override_view)

menu.fov:set_callback(viewmodel.update)
menu.x:set_callback(viewmodel.update)
menu.y:set_callback(viewmodel.update)
menu.z:set_callback(viewmodel.update, true)
menu.options:set_callback(function ()
    for i, option in ipairs(option_names) do
        options[i] = menu.options:get(option)
    end
    for key, value in pairs(menu) do
        if value ~= menu.options then
            value:set_visible(not options[3])
        end
    end
end)

client.set_event_callback("run_command", function()
    local w_id = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex")
    if not weaponsystem_raw or not w_id then return end
    local res = get_weapon_info(weaponsystem_raw, w_id)
    res.hide_vm_scope = not menu.in_scope:get()
end)