local mainfont = render.create_font("Verdana", 22, 800, e_font_flags.OUTLINE,e_font_flags.ANTIALIAS)
local smallfont = render.create_font("Smallest Pixel-7", 11, 20, e_font_flags.OUTLINE,e_font_flags.ANTIALIAS)
local ScreenSize = render.get_screen_size()
local ScreenCenterX = ScreenSize.x / 2
local ScreenCenterY = ScreenSize.y / 2
local img = render.load_image("primordial//scripts//include//201.jpg")
local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local os_ref = menu.find("aimbot", "general", "exploits", "hideshots", "enable")
local fd_ref = menu.find("antiaim", "main", "general", "fake duck")
local slow_walk_ui = unpack(menu.find("misc","main","movement","slow walk"))
local checkbox = menu.add_checkbox("Holo Panel", "Enable This shit",true)
local mode = menu.add_selection("Holo Panel", "Style", {"simple","love u baby"})
local line = menu.add_checkbox("Holo Panel", "Enable the line",true)
local line_color = line:add_color_picker("hi")
local custom = menu.add_checkbox("Holo Panel", "Custom Active Color")
local Color = checkbox:add_color_picker("New1")
local new_color = custom:add_color_picker("New2")
local nor_h = menu.add_slider("Holo Panel", "FirstPersion Offest X", -ScreenCenterY, ScreenCenterY)
local nor_w = menu.add_slider("Holo Panel", "FirstPersion Offest Y", -ScreenCenterX, ScreenCenterX)
local tir_h = menu.add_slider("Holo Panel", "ThirdPersion Offest X", -ScreenCenterY, ScreenCenterY)
local tir_w = menu.add_slider("Holo Panel", "ThirdPersion Offest Y", -ScreenCenterX, ScreenCenterX)
local anime = menu.add_slider("Holo Panel", "Anime speed", 5, 10)
local disabler = menu.add_multi_selection("Holo Panel","Disabler",{"Thirdperson","On Scoped"})
local menu_color = select(2, unpack(menu.find("misc", "main", "config", "accent color")))
local ffi_helpers = {}
nor_h:set(120)
nor_w:set(40)
ffi.cdef[[
    typedef struct {
        float x, y, z;
    } vector_struct_t;

    typedef void*(__thiscall* c_entity_list_GetClientEntity_t)(void*, int);
    typedef void*(__thiscall* c_entity_list_GetClientEntity_from_handle_t)(void*, uintptr_t);
    typedef int(__thiscall* c_weapon_get_muzzle_attachment_index_first_person_t)(void*, void*);
    typedef bool(__thiscall* c_entity_get_attachment_t)(void*, int, vector_struct_t*);
]]

ffi_helpers.BindArgument = function(fn, arg) return function(...) return fn(arg, ...) end end
ffi_helpers.VClientEntityList = ffi.cast(ffi.typeof("uintptr_t**"), memory.create_interface("client.dll", "VClientEntityList003"))
ffi_helpers.GetClientEntity = ffi_helpers.BindArgument(ffi.cast("c_entity_list_GetClientEntity_t", ffi_helpers.VClientEntityList[0][3]), ffi_helpers.VClientEntityList)

local function GetWeaponEndPos()
    local Localplayer = entity_list.get_local_player()
    local Weapon_Address = ffi_helpers.GetClientEntity(entity_list.get_entity(Localplayer:get_prop("m_hActiveWeapon")):get_index())
    --local Weapon_Address = (Localplayer:get_prop("m_hActiveWeapon"):get_index()):get_address()
    local Viewmodel_Address = ffi_helpers.GetClientEntity(entity_list.get_entity(Localplayer:get_prop("m_hViewModel[0]")):get_index())
    local Position = ffi.new("vector_struct_t[1]")
    ffi.cast("c_entity_get_attachment_t", ffi.cast(ffi.typeof("uintptr_t**"), Viewmodel_Address)[0][84])(Viewmodel_Address, ffi.cast("c_weapon_get_muzzle_attachment_index_first_person_t", ffi.cast(ffi.typeof("uintptr_t**"), Weapon_Address)[0][468])(Weapon_Address, Viewmodel_Address), Position)
    return vec3_t(Position[0].x, Position[0].y, Position[0].z)
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function render_shit( x, y, Width, Height, Color, Alpha )
    local r, g, b, a = Color.r, Color.g, Color.b, Color.a
    local Rounding = 3
    local Modifier = 30
    local wish_alpha = a / 255 * Modifier
    render.rect_filled(vec2_t(x, y), vec2_t(Width, Height), color_t(0, 0, 0, 80 * (255 / a)), Rounding)
    render.rect_filled(vec2_t(x + Rounding, y), vec2_t(Width - Rounding * 2, 1), color_t(r, g, b, a))
    render.push_clip(vec2_t(x, y), vec2_t(Rounding, Rounding + 2))
    render.progress_circle(vec2_t(x + Rounding, y + Rounding), Rounding, color_t(r, g, b, a), 1, 88)
    render.pop_clip()
    render.push_clip(vec2_t(x + Width - Rounding, y), vec2_t(Rounding + 1, Rounding + 2))
    render.progress_circle(vec2_t(x + Width - Rounding, y + Rounding), Rounding, color_t(r, g, b, a), 1, 90)
    render.pop_clip()
    render.rect_fade(vec2_t(x, y + Rounding), vec2_t(1, Height - Rounding * 2), color_t(r, g, b, a), color_t(r, g, b, 0), false)
    render.rect_fade(vec2_t(x + Width, y + Rounding), vec2_t(1, Height - Rounding * 2), color_t(r, g, b, a), color_t(r, g, b, 0), false)
    render.rect(vec2_t(x, y), vec2_t(Width, Height), color_t(r, g, b, wish_alpha), Rounding)
end

local function is_scope()
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    local scoped_prop = local_player:get_prop("m_bIsScoped")
    if scoped_prop == 1 then return true else return false end
end

local function is_inv()
    local is_invert = false
    if antiaim.get_desync_side() == 2 then
        is_invert = true
    end
    if antiaim.get_desync_side() == 1 then
    is_invert = false
    end
    return is_invert
end

local function ent_speed(index)
    if not index then return end
    local pos = index:get_prop('m_vecVelocity')
    if pos.x == nil then
        return 0
    end
    return math.sqrt(pos.x * pos.x + pos.y * pos.y + pos.z * pos.z)
end

local function get_motion()
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    if input.is_key_held(e_keys.KEY_E) then return "LEGIT" end
    if ent_speed(local_player) <10 and local_player:has_player_flag(e_player_flags.ON_GROUND) and not local_player:has_player_flag(e_player_flags.DUCKING) then return "STAND" end
    if ent_speed(local_player) >10 and local_player:has_player_flag(e_player_flags.ON_GROUND) and not local_player:has_player_flag(e_player_flags.DUCKING) then return "RUN" end
    if not local_player:has_player_flag(e_player_flags.ON_GROUND) then return "AIR" end
    if local_player:has_player_flag(e_player_flags.DUCKING) then return "DUCK" end
    if slow_walk_ui:get() then return "SLOW" end
end

local Smooth_x = 0
local Smooth_y = 0
local function draw()
    local Localplayer = entity_list.get_local_player()
    if not Localplayer then return end
    local my_health = Localplayer:get_prop("m_iHealth")
    local Weapon = entity_list.get_entity(Localplayer:get_prop("m_hActiveWeapon"))
    if not Weapon then return end
    local in_codition = false
    if disabler:get(1) and client.is_in_thirdperson() then in_codition = true return end
    if disabler:get(2) and is_scope() then in_codition = true return end
    if not Weapon:is_weapon()then return end
    local weapon_name = Weapon:get_name()
    if weapon_name == "knife" then return end
    local sexypos = render.world_to_screen(GetWeaponEndPos())
    if sexypos == nil then
        sexypos = vec2_t(0, 0)
    end
    local color1 = Color:get()
    local dt_text = dt_ref[2]:get() and "on" or "off"
    local os_text = os_ref[2]:get() and "on" or "off"
    local wish_color = custom:get() and new_color:get() or menu_color:get()
    local dis = 0
    local W,H = 0
    if client.is_in_thirdperson() then
        W = tir_w:get()
        H = tir_h:get()
    else
        W = nor_w:get()
        H = nor_h:get()
    end
    Smooth_x = in_codition and lerp(Smooth_x,sexypos.x + W,global_vars.frame_time() * anime:get()) or lerp(Smooth_x,sexypos.x + W,global_vars.frame_time() * anime:get())
    Smooth_y = in_codition and lerp(Smooth_y,sexypos.y - H,global_vars.frame_time() * anime:get()) or lerp(Smooth_y,sexypos.y - H,global_vars.frame_time() * anime:get())
    if checkbox:get() and mode:get() == 1 then
          if dt_ref[2]:get() then 
        render.text(mainfont, "DT", vec2_t(Smooth_x,Smooth_y+dis), exploits.get_charge() > 12 and wish_color or color1)
        render.push_alpha_modifier(0.5)
        render.rect_fade(vec2_t(Smooth_x-5, Smooth_y+dis - 5), vec2_t(20, 30), color_t(0,0,0), color_t(60,60,60),true)
        render.rect_fade(vec2_t(Smooth_x+15, Smooth_y+dis -5 ), vec2_t(20, 30), color_t(60,60,60), color_t(0,0,0),true)
        render.pop_alpha_modifier()
        dis = dis + 60
        end
          if os_ref[2]:get() then 
        render.text(mainfont, "OS", vec2_t(Smooth_x,Smooth_y+dis), wish_color)
        render.push_alpha_modifier(0.5)
        render.rect_fade(vec2_t(Smooth_x-5, Smooth_y+dis - 5), vec2_t(20, 30), color_t(0,0,0), color_t(60,60,60),true)
        render.rect_fade(vec2_t(Smooth_x+15, Smooth_y+dis -5 ), vec2_t(20, 30), color_t(60,60,60), color_t(0,0,0),true)
        render.pop_alpha_modifier()
        dis = dis + 60
        end
          if fd_ref[2]:get() then
        render.text(mainfont, "FD", vec2_t(Smooth_x,Smooth_y+dis), wish_color)
        render.push_alpha_modifier(0.5)
        render.rect_fade(vec2_t(Smooth_x-5, Smooth_y+dis - 5), vec2_t(20, 30), color_t(0,0,0), color_t(60,60,60),true)
        render.rect_fade(vec2_t(Smooth_x+15, Smooth_y+dis -5 ), vec2_t(20, 30), color_t(60,60,60), color_t(0,0,0),true)
        render.pop_alpha_modifier()
        dis = dis + 60
        end
    end
    if checkbox:get() and mode:get() == 2 then
        render_shit(Smooth_x, Smooth_y , 140, 70, Color:get())
        if line:get() and not client.is_in_thirdperson() and not is_scope() then
        render.line(vec2_t(sexypos.x, sexypos.y), vec2_t(Smooth_x, Smooth_y+70), line_color:get())
        end
        render.text(smallfont, "ANTI-AIMBOT DEBUG", vec2_t(Smooth_x+25,Smooth_y+5), color_t( 255, 255, 255, 255 ))
        render.texture(img.id, vec2_t(Smooth_x + 105, Smooth_y + 5), vec2_t(30, 29))
        render.rect_fade(vec2_t(Smooth_x+10,Smooth_y+30), vec2_t(2, 15), menu_color:get(), color_t(30, 30 , 30, 70), false)
        render.rect_fade(vec2_t(Smooth_x+10,Smooth_y+15), vec2_t(2, 15), color_t(30, 30 , 30, 70), menu_color:get(), false)
        render.text(smallfont, "FAKE: "..antiaim.get_max_desync_range().." ST: "..get_motion(), vec2_t(Smooth_x+17,Smooth_y+20), color_t( 255, 255, 255, 255 ))
        render.text(smallfont, "DT: ", vec2_t(Smooth_x+17,Smooth_y+35), color_t( 255, 255, 255, 255 ))
        render.text(smallfont, dt_text, vec2_t(Smooth_x+32,Smooth_y+35), dt_ref[2]:get() and color_t(0,255,0,255) or color_t(255,0,0,255))
        render.text(smallfont, "OS-AA: ", vec2_t(Smooth_x+57,Smooth_y+35), color_t( 255, 255, 255, 255 ))
        render.text(smallfont, os_text, vec2_t(Smooth_x+88,Smooth_y+35), os_ref[2]:get() and color_t(0,255,0,255) or color_t(255,0,0,255))
        render.text(smallfont, "SP: ", vec2_t(Smooth_x+17,Smooth_y+53), color_t( 255, 255, 255, 255 ))
        render.rect_filled(vec2_t(Smooth_x+35,Smooth_y+56), vec2_t(50, 5), color_t( 0, 0, 0, 70))
        render.rect_filled(vec2_t(Smooth_x+35,Smooth_y+56), vec2_t(25, 5), is_inv() and Color:get() or color_t(0,0,0,0))
        render.rect_filled(vec2_t(Smooth_x+60,Smooth_y+56), vec2_t(25, 5), is_inv() and color_t(0,0,0,0) or Color:get())
    end
end
callbacks.add(e_callbacks.PAINT, draw)