local ffi_helpers = {}
local new_weapon_struct = ffi.typeof([[
    struct{
        char pad_0000[461]; //0x0000
        bool shouldnt_draw_view; //0x01CD classy is a baller also dont paste my code u fkin kidz grr
        char pad_01CE[115]; //0x01CE
    }
]])
ffi.cdef[[
    typedef struct {
        float x, y, z;
    } vector_struct_t;

    typedef void*(__thiscall* c_entity_list_GetClientEntity_t)(void*, int);
    typedef void*(__thiscall* c_entity_list_GetClientEntity_from_handle_t)(void*, uintptr_t);
    typedef int(__thiscall* c_weapon_get_muzzle_attachment_index_first_person_t)(void*, void*);
    typedef bool(__thiscall* c_entity_get_attachment_t)(void*, int, vector_struct_t*);
]]

local smallfont = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE)
local main_font = render.create_font("verdana", 17, 600, e_font_flags.ANTIALIAS)
ffi_helpers.BindArgument = function(fn, arg) return function(...) return fn(arg, ...) end end
ffi_helpers.VClientEntityList = ffi.cast(ffi.typeof("uintptr_t**"), memory.create_interface("client.dll", "VClientEntityList003"))
ffi_helpers.GetClientEntity = ffi_helpers.BindArgument(ffi.cast("c_entity_list_GetClientEntity_t", ffi_helpers.VClientEntityList[0][3]), ffi_helpers.VClientEntityList)
local sig = memory.find_pattern("client.dll", "8B 35 ?? ?? ?? ?? FF 10 0F B7 C0") or error("IWeaponSystem signature invalid")
local weapon_system_raw = ffi.cast("void****", ffi.cast("char*", sig) + 0x2)[0]
local get_weapon_info = memory.get_vfunc(tonumber(ffi.cast("unsigned int",weapon_system_raw)), 2) or error("invalid GetCSWeaponInfo index")
local get_weapon_info_fn = ffi.cast( ffi.typeof("$*(__thiscall*)(void*, unsigned int)",new_weapon_struct),get_weapon_info)

local holo = menu.add_checkbox("Manifest[Visuals]", "Enable Holo Panel")
local colors = holo:add_color_picker("Holo Panel Color")

local function viewmodel()
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end

    if not local_player:is_player() or not local_player:is_alive() then
        return
    end
    if not holo:get() then return end
    local active_weapon = local_player:get_active_weapon()
    if (active_weapon == nil) then
        return
    end

    local index = active_weapon:get_prop("m_iItemDefinitionIndex")
    if(index == nil) then
        return
    end
    local get_weapon_info_data = get_weapon_info_fn(weapon_system_raw,index)

    if(get_weapon_info_data == nil) then
        return
    end

    get_weapon_info_data.shouldnt_draw_view = not true
end

local function on_shutdown()
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end

    if not local_player:is_player() or not local_player:is_alive() then
        return
    end
    if not holo:get() then return end
    local active_weapon = local_player:get_active_weapon()
    if (active_weapon == nil) then
        return
    end

    local index = active_weapon:get_prop("m_iItemDefinitionIndex")
    if(index == nil) then
        return
    end
    local get_weapon_info_data = get_weapon_info_fn(weapon_system_raw,index)

    if(get_weapon_info_data == nil) then
        return
    end

    get_weapon_info_data.shouldnt_draw_view = true
end

local function GetWeaponEndPos()
    local Localplayer = entity_list.get_local_player()
    local Weapon_Address = ffi_helpers.GetClientEntity(entity_list.get_entity(Localplayer:get_prop("m_hActiveWeapon")):get_index())
    local Viewmodel_Address = ffi_helpers.GetClientEntity(entity_list.get_entity(Localplayer:get_prop("m_hViewModel[0]")):get_index())
    local Position = ffi.new("vector_struct_t[1]")
    ffi.cast("c_entity_get_attachment_t", ffi.cast(ffi.typeof("uintptr_t**"), Viewmodel_Address)[0][84])(Viewmodel_Address, ffi.cast("c_weapon_get_muzzle_attachment_index_first_person_t", ffi.cast(ffi.typeof("uintptr_t**"), Weapon_Address)[0][468])(Weapon_Address, Viewmodel_Address), Position)
    return vec3_t(Position[0].x, Position[0].y, Position[0].z)
    
end

local function draw()
    local Localplayer = entity_list.get_local_player()
    if not Localplayer then return end
    local Weapon = entity_list.get_entity(Localplayer:get_prop("m_hActiveWeapon"))
    if not Weapon then return end
    if not Weapon:is_weapon() then return end
    local weapon_name = Weapon:get_name()
    if weapon_name == "knife" or weapon_name == "incgrenade" or weapon_name == "decoy" or weapon_name == "molotov" or weapon_name == "flashbang" or weapon_name == "hegrenade" or weapon_name == "smokegrenade" or weapon_name == "c4" or weapon_name == "healthshot" then return end
    local sexypos = render.world_to_screen(GetWeaponEndPos())
    if not sexypos then return end
    if not holo:get() then return end


    local thirdvalue = 0
    local thirdvaluey = 0
    if client.is_in_thirdperson() then
        thirdvalue = 80
        thirdvaluey = 50
    else
        thirdvalue = 0
        thirdvaluey = 0
    end
    local fl= menu.find("antiaim", "main", "fakelag", "amount") 
    local fakeangle = antiaim.get_fake_angle()-antiaim.get_fake_angle()%1
    local yawvalue = menu.find("antiaim", "main","angles", "yaw add")
    local hs_ref = menu.find("aimbot","general","exploits","hideshots","enable")
    local yaw = math.abs(yawvalue:get()/180)
    render.circle_filled(vec2_t.new(sexypos.x-thirdvalue, sexypos.y+thirdvaluey), 4, color_t.new(255,255,255,255))
    render.circle(vec2_t.new(sexypos.x-thirdvalue, sexypos.y+thirdvaluey), 4, color_t.new(255,255,255,255))
    render.line(vec2_t.new(sexypos.x-thirdvalue, sexypos.y+thirdvaluey), vec2_t(sexypos.x+90-thirdvalue, sexypos.y-50+thirdvaluey), color_t(255,255,255,255))
    render.rect_filled(vec2_t(sexypos.x+90-thirdvalue, sexypos.y-120+thirdvaluey), vec2_t(190, 70), color_t(255,255,255,10))
    render.rect_filled(vec2_t(sexypos.x+90-thirdvalue, sexypos.y-120+thirdvaluey), vec2_t(190, 3), colors:get())
    render.text(smallfont, "Anti-Aimbot Debug", vec2_t(sexypos.x+95-thirdvalue, sexypos.y-113+thirdvaluey), color_t(255, 255, 255, 255))
    render.progress_circle(vec2_t.new(sexypos.x+255-thirdvalue, sexypos.y-100+thirdvaluey), 10, color_t.new(0,0,0,255), 4, 1)
    render.progress_circle(vec2_t.new(sexypos.x+255-thirdvalue, sexypos.y-100+thirdvaluey), 10, colors:get(), 4, fl:get()/14)
    render.rect_fade(vec2_t(sexypos.x+95-thirdvalue, sexypos.y-98+thirdvaluey), vec2_t(3, 13), color_t(0,0,0,0), colors:get())
    render.rect_fade(vec2_t(sexypos.x+95-thirdvalue, sexypos.y-85+thirdvaluey), vec2_t(3, 13), colors:get(), color_t(0,0,0,0))
    render.text(main_font, "Fake("..fakeangle..".0)", vec2_t(sexypos.x+103-thirdvalue, sexypos.y-94+thirdvaluey), color_t(255, 255, 255, 255))
    render.text(smallfont, "sp:", vec2_t(sexypos.x+95-thirdvalue, sexypos.y-66+thirdvaluey), color_t(255, 255, 255, 255))
    render.rect_filled(vec2_t(sexypos.x+110-thirdvalue, sexypos.y-64+thirdvaluey), vec2_t(60, 7), color_t(0,0,0,255))
    render.rect_filled(vec2_t(sexypos.x+110-thirdvalue, sexypos.y-64+thirdvaluey), vec2_t(yaw*60,7), colors:get())
    render.text(smallfont, "os", vec2_t(sexypos.x+225-thirdvalue, sexypos.y-66+thirdvaluey), colors:get())
    render.text(smallfont, "aa:", vec2_t(sexypos.x+236-thirdvalue, sexypos.y-66+thirdvaluey), color_t(255, 255, 255, 255))
    if hs_ref[2]:get() then
    render.text(smallfont, "true", vec2_t(sexypos.x+250-thirdvalue, sexypos.y-66+thirdvaluey), colors:get())
    else
    render.text(smallfont, "false", vec2_t(sexypos.x+250-thirdvalue, sexypos.y-66+thirdvaluey), color_t(255, 0, 0, 255))  
    end
    
end

callbacks.add(e_callbacks.PAINT, function()
    draw()
    viewmodel()
end)
callbacks.add(e_callbacks.SHUTDOWN,on_shutdown)