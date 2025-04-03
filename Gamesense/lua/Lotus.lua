local bit_band, bit_lshift, client_color_log, client_create_interface, client_delay_call, client_find_signature, client_key_state, client_reload_active_scripts, client_screen_size, client_set_event_callback, client_system_time, client_timestamp, client_unset_event_callback, database_read, database_write, entity_get_classname, entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_prop, entity_get_steam64, entity_is_alive, globals_framecount, globals_realtime, math_ceil, math_floor, math_max, math_min, panorama_loadstring, renderer_gradient, renderer_line, renderer_rectangle, table_concat, table_insert, table_remove, table_sort, ui_get, ui_is_menu_open, ui_mouse_position, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_slider, ui_set, ui_set_visible, setmetatable, pairs, error, globals_absoluteframetime, globals_curtime, globals_frametime, globals_maxplayers, globals_tickcount, globals_tickinterval, math_abs, type, pcall, renderer_circle_outline, renderer_load_rgba, renderer_measure_text, renderer_text, renderer_texture, tostring, ui_name, ui_new_button, ui_new_hotkey, ui_new_label, ui_new_listbox, ui_new_textbox, ui_reference, ui_set_callback, ui_update, unpack, tonumber = bit.band, bit.lshift, client.color_log, client.create_interface, client.delay_call, client.find_signature, client.key_state, client.reload_active_scripts, client.screen_size, client.set_event_callback, client.system_time, client.timestamp, client.unset_event_callback, database.read, database.write, entity.get_classname, entity.get_local_player, entity.get_origin, entity.get_player_name, entity.get_prop, entity.get_steam64, entity.is_alive, globals.framecount, globals.realtime, math.ceil, math.floor, math.max, math.min, panorama.loadstring, renderer.gradient, renderer.line, renderer.rectangle, table.concat, table.insert, table.remove, table.sort, ui.get, ui.is_menu_open, ui.mouse_position, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.set, ui.set_visible, setmetatable, pairs, error, globals.absoluteframetime, globals.curtime, globals.frametime, globals.maxplayers, globals.tickcount, globals.tickinterval, math.abs, type, pcall, renderer.circle_outline, renderer.load_rgba, renderer.measure_text, renderer.text, renderer.texture, tostring, ui.name, ui.new_button, ui.new_hotkey, ui.new_label, ui.new_listbox, ui.new_textbox, ui.reference, ui.set_callback, ui.update, unpack, tonumber
local entity_get_local_player, entity_is_enemy, entity_get_all, entity_set_prop, entity_is_alive, entity_is_dormant, entity_get_player_name, entity_get_game_rules, entity_get_origin, entity_hitbox_position, entity_get_players, entity_get_prop = entity.get_local_player, entity.is_enemy,  entity.get_all, entity.set_prop, entity.is_alive, entity.is_dormant, entity.get_player_name, entity.get_game_rules, entity.get_origin, entity.hitbox_position, entity.get_players, entity.get_prop
local math_cos, math_sin, math_rad, math_sqrt = math.cos, math.sin, math.rad, math.sqrt
local ui_new_multiselect, v_check, v_interface = ui.new_multiselect, {}, {}
-->> Libary
local vector = require 'vector'
local ffi = require "ffi"
local anti_aim = require 'gamesense/antiaim_funcs'
local trace = require("gamesense/trace")
local weapon = require("gamesense/csgo_weapons")
local asd_http_ouo = require ("gamesense/http")
local dragging_fn=function(b,c,d)return(function()local e={}local f,g,h,i,j,k,l,m,n,o,p,q,r,s;local t={__index={drag=function(self,...)local u,v=self:get()local w,x,q=e.drag(u,v,...)if u~=w or v~=x then self:set(w,x)end;return w,x,q end,status=function(self,...)local w,x=self:get()local y,z=e.status(w,x,...)return y end,set=function(self,u,v)local n,o=client_screen_size()ui_set(self.x_reference,u/n*self.res)ui_set(self.y_reference,v/o*self.res)end,get=function(self)local n,o=client_screen_size()return ui_get(self.x_reference)/self.res*n,ui_get(self.y_reference)/self.res*o end}}function e.new(y,z,A,B)B=B or 10000;local n,o=client_screen_size()local C=ui_new_slider("LUA","A",y.." window position",0,B,z/n*B)local D=ui_new_slider("LUA","A","\n"..y.." window position y",0,B,A/o*B)ui_set_visible(C,false)ui_set_visible(D,false)return setmetatable({name=y,x_reference=C,y_reference=D,res=B},t)end;function e.drag(u,v,E,F,G,H,I)local t="n"if globals_framecount()~=f then g=ui_is_menu_open()j,k=h,i;h,i=ui_mouse_position()m=l;l=client_key_state(0x01)==true;q=p;p={}s=r;r=false;n,o=client_screen_size()end;if g and m~=nil then if(not m or s)and l and j>u and k>v and j<u+E and k<v+F then r=true;u,v=u+h-j,v+i-k;if not H then u=math_max(0,math_min(n-E,u))v=math_max(0,math_min(o-F,v))end end end;if g and m~=nil then if j>u and k>v and j<u+E and k<v+F then if l then t="c"else t="o"end end end;table_insert(p,{u,v,E,F})return u,v,t,E,F end;function e.status(u,v,E,F,G,H,I)if globals_framecount()~=f then g=ui_is_menu_open()j,k=h,i;h,i=ui_mouse_position()m=l;l=true;q=p;p={}s=r;r=false;n,o=client_screen_size()end;if g and m~=nil then if j>u and k>v and j<u+E and k<v+F then return true end end;return false end;return e end)().new(b,c,d)end
require "gamesense/panorama_valve_utils"
local js = panorama.open()
local lp_ign = js.MyPersonaAPI.GetName()
local lp_st64 = js.MyPersonaAPI.GetXuid()
local outline = function(x, y, w, h, t, r, g, b, a)
    renderer.rectangle(x, y, w, t, r, g, b, a)
    renderer.rectangle(x, y, t, h, r, g, b, a)
    renderer.rectangle(x, y+h-t, w, t, r, g, b, a)
    renderer.rectangle(x+w-t, y, t, h, r, g, b, a)
end

local buttons_e = {
    attack = bit.lshift(1, 0),
    attack_2 = bit.lshift(1, 11),
    use = bit.lshift(1, 5)

}

local ffi = require 'ffi'

v_interface = {
    getClientNumber = vtable_bind("engine.dll", "VEngineClient014", 104, "unsigned int(__thiscall*)(void*)"),
}
v_check = {
    ClientCheck = function()
        -- print(getClientNumber) --> client check, 2023/1/17 (13850)
        if v_interface.getClientNumber() >= 13856 and v_interface.getClientNumber() <= 13858 then error("interface corrput #1  client number:", v_interface.getClientNumber()) end
    end,
}
--v_check.ClientCheck()
-->> FFI 
local a=ffi.typeof("struct { float pitch; float yaw; float roll; }")local b=ffi.typeof("struct { float x; float y; float z; }")local c=ffi.typeof([[
struct
{
    uintptr_t vfptr;
    int command_number;
    int tick_count;
    $ viewangles;
    $ aimdirection;
    float forwardmove;
    float sidemove;
    float upmove;
    int buttons;
    uint8_t impulse;
    int weaponselect;
    int weaponsubtype;
    int random_seed;
    short mousedx;
    short mousedy;
    bool hasbeenpredicted;
    $ headangles;
    $ headoffset;
}
]],a,b,a,b)local d=ffi.typeof("$* (__thiscall*)(uintptr_t ecx, int nSlot, int sequence_number)",c)local e=ffi.typeof([[
struct
{
    uintptr_t padding[8];
    $ GetUserCmd;
}
]],d)local f=ffi.typeof([[
struct
{
    $* vfptr;
}*
]],e)local g=ffi.cast(f,ffi.cast("uintptr_t**",tonumber(ffi.cast("uintptr_t",client.find_signature("client.dll","\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85")or error("client.dll!:input not found.")))+1)[0])

ffi.cdef [[
    typedef struct
    {
        char pad[0x117D0];
        float x;
        float y;
        float z;
    } model;
]]
-->> vmt hooks implementation
local function vmt_entry(instance, index, type)
	return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

local function vmt_bind(module, interface, index, typestring)
	local instance = client.create_interface(module, interface) or error("invalid interface")
	local success, typeof = pcall(ffi.typeof, typestring)
	if not success then
		error(typeof, 2)
	end
	local fnptr = vmt_entry(instance, index, typeof) or error("invalid vtable")
	return function(...)
		return fnptr(instance, ...)
	end
end

local function vtable_bind(module, interface, index, type)
    local addr = ffi.cast("void***", client.create_interface(module, interface)) or error(interface .. " is nil.")
    return ffi.cast(ffi.typeof(type), addr[0][index]), addr
end

local function __thiscall(func, this) -- bind wrapper for __thiscall functions
    return function(...)
        return func(this, ...)
    end
end


local native_Surface_DrawSetColor 				= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 15, "void(__thiscall*)(void*, int, int, int, int)")
local native_Surface_DrawLine 						= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 19, "void(__thiscall*)(void*, int, int, int, int)")
local nativeGetClientEntity = __thiscall(vtable_bind("client.dll","VClientEntityList003",3,"model*(__thiscall*)(void*, int)"))
-->> Renderer Libary

local draw_line = function(x0, y0, x1, y1, r, g, b, a, ctx)
    if ctx == false then return end
    native_Surface_DrawSetColor(r, g, b, a)
    return native_Surface_DrawLine(x0, y0, x1, y1)
end

local function rotate_point(x, y, rot, size)
	return math.cos(math.rad(rot)) * size + x, math.sin(math.rad(rot)) * size + y
end

local menu = {

    label = function(type, name)
        local TAB_1 =   (type == "AA" and "AA") or
                        (type == "FL" and "Fake lag")

        local TAB_2 =   (type == "AA" and "Anti-aimbot angles") or 
                        (type == "FL" and "AA")


        return ui_new_label(TAB_1, TAB_2, name)
    end,

    hotkey = function(type, prefix, name)
        local TAB_1 =   (type == "AA" and "AA") 

        local TAB_2 =   (type == "AA" and "Anti-aimbot angles")

        local font = "\a87CEFAFF"..prefix..": \aFFFFFFFF"

        return ui_new_hotkey(TAB_1, TAB_2, font..name)
    end,

    checkbox = function(type, prefix, name)
        local TAB_1 =   (type == "AA" and "AA") or
                        (type == "FL" and "Fake lag")

        local TAB_2 =   (type == "AA" and "Anti-aimbot angles") or 
                        (type == "FL" and "AA")

        local insert =  (prefix == "AA") and "FAnti-Aim" or 
                        (prefix == "Rage") and "Rage" or
                        (prefix == "Misc") and "Misc" or
                        (prefix == "Visuals") and "Visuals" or
                        (prefix == "FL") and "FL" or prefix

        local font = "\a87CEFAFF"..insert..": \aFFFFFFFF"

        return ui_new_checkbox(TAB_1, TAB_2, font..name)
    end,

    combo = function(type, prefix, name, tbl)
        local TAB_1 =   (type == "AA" and "AA") or
                        (type == "FL" and "AA")

        local TAB_2 =   (type == "AA" and "Anti-aimbot angles") or 
                        (type == "FL" and "Fake lag")

        local insert =  (prefix == "AA") and "Anti-Aim" or 
                        (prefix == "Rage") and "Rage" or
                        (prefix == "Misc") and "Misc" or
                        (prefix == "Visuals") and "Visuals" or
                        (prefix == "FL") and "Fake lag" or prefix

        local font = "\a87CEFAFF"..insert..": \aFFFFFFFF"

        return ui_new_combobox(TAB_1, TAB_2, font..name, tbl)
    end,

    table = function(type, prefix, name, tbl)
        local TAB_1 =   (type == "AA" and "AA") or
                        (type == "FL" and "Fake lag")

        local TAB_2 =   (type == "AA" and "Anti-aimbot angles") or 
                        (type == "FL" and "AA")

        local insert =  (prefix == "AA") and "Anti-Aim" or 
                        (prefix == "Rage") and "Rage" or
                        (prefix == "Misc") and "Misc" or
                        (prefix == "Visuals") and "Visuals" or
                        (prefix == "FL") and "FL" or prefix

        local font = "\a87CEFAFF"..insert..": \aFFFFFFFF"

        return ui_new_multiselect(TAB_1, TAB_2, font..name, tbl)
    end,

    slider = function(type, prefix, name, min, max, reserved)
        local TAB_1 =   (type == "AA" and "AA") or
                        (type == "FL" and "AA")

        local TAB_2 =   (type == "AA" and "Anti-aimbot angles") or 
                        (type == "FL" and "Fake lag")

        local insert =  (prefix == "AA") and "Anti-Aim" or 
                        (prefix == "Rage") and "Rage" or
                        (prefix == "Misc") and "Misc" or
                        (prefix == "Visuals") and "Visuals" or
                        (prefix == "FL") and "FL" or prefix

        local font = "\a87CEFAFF"..insert..": \aFFFFFFFF"

        local symbol = (type == "AA" and "") or ""

        if reserved == nil then reserved = 0 end

        return ui_new_slider(TAB_1, TAB_2, font..name, min, max, reserved, true, symbol)
    end,

    contains = function(tbl, val)
        for i = 1, #tbl do
            if tbl[i] == val then
                return true
            end
        end
        return false
    end,

    find = function(method, value)
        return (method == value)
    end
}


local render = {

    gradient_text = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
        local output = ''
    
        local len = #text-1
    
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len
    
        for i=1, len+1 do
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
    
            r1 = r1 + rinc
    
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end
    
        return output
    end,

    arrow =  function(x, y, r, g, b, a, rotation, size)
        local x0, y0 = rotate_point(x, y, rotation, 45)
        local x1, y1 = rotate_point(x, y, rotation + (size / 3.5), 45 - (size / 4))
        local x2, y2 = rotate_point(x, y, rotation - (size / 3.5), 45 - (size / 4))
        renderer.triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
    end,

    draw_circle_3d = function(x, y, z, radius, degrees, start_at, r, g, b, a , ctx, lineNum)
        if ctx == false then return end
        local accuracy = 10/10
        local old = { x, y }
    
        for rot=start_at, degrees+start_at, accuracy do
            local rot_t = math.rad(rot)
            local line_ = vector(radius * math.cos(rot_t) + x, radius * math.sin(rot_t) + y, z)
            local current = { x, y }
            current.x, current.y = renderer.world_to_screen(line_.x, line_.y, line_.z)
            if current.x ~=nil and old.x ~= nil then
                draw_line(current.x, current.y, old.x, old.y, r, g, b, a)
                --m_render_engine.render_glow_line(current.x, current.y, old.x, old.y, r, g, b, a, r, g, b, 10)
            end
            old.x, old.y = current.x, current.y
        end
    end,

    lerp = function(start, vend, time)
    return start + (vend - start) * (time * globals.frametime()) end
}

-->> Font Grabber / Webhook
local font = {

    left = "<", right = ">"

}


local indicator_left, indicator_right

local font_grabber = {

    Run = function()

        local asd_http_ouo = require "gamesense/http"

        str_to_sub = function(input, sep)
            local t = {}
            for str in  string.gmatch(input, "([^"..sep.."]+)") do
                t[#t + 1] = string.gsub(str, "\n", "")
            end
            return t
        end
        
        local http_get = function()

            asd_http_ouo.get("https://raw.githubusercontent.com/MLCluanchar/Special-font/main/font.txt", function(success, response)
                if not success or response.status ~= 200 then
                    print("text grabber: Conection failed")
                end
            
                local tbl = str_to_sub(response.body, '"')
            
                font.left = tbl[2]
                font.right = tbl[4]
            
            end)

        end
        http_get()
    end

}


font_grabber.Run()

-->> References 
local references = {
    aa_enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    body_freestanding = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")},
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    body_yaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    jitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    freestanding = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    
    fakeduck = {ui.reference("RAGE", "Other", "Duck peek assist")},
    legmovement = ui.reference("AA", "Other", "Leg movement"),
    slow_walk = {ui.reference("AA", "Other", "Slow motion")},
    roll = {ui.reference("AA", "Anti-aimbot angles", "Roll")},
    -- rage references
    doubletap = {ui.reference("RAGE", "Aimbot", "Double Tap")},
    dt_hit_chance = ui.reference("RAGE", "Aimbot", "Double tap hit chance"),
    onshot = {ui.reference("AA", "Other", "On shot anti-aim")},
    mindmg = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    fba_key = ui.reference("RAGE", "Aimbot", "Force body aim"),

    fsp_key = ui.reference("RAGE", "Aimbot", "Force safe point"),
    ap = ui.reference("RAGE", "Other", "Delay shot"),
    slowmotion_key = ui.reference("AA", "Other", "Slow motion"),
    quick_peek = {ui.reference("Rage", "Other", "Quick peek assist")},


    autowall = ui.reference("RAGE", "Other", "Automatic penetration"),
    autofire = ui.reference("RAGE", "Other", "Automatic fire"),
    fov = ui.reference('RAGE', 'Other', 'Maximum FOV'),

    -- misc references
    untrust = ui.reference("MISC", "Settings", "Anti-untrusted"),
    -- end of menu references and menu creation
    fake_lag = ui.reference("AA", "Fake lag", "Amount"),
    fake_lag_limit = ui.reference("AA", "Fake lag", "Limit"),
    variance = ui.reference("AA", "Fake lag", "Variance"),
}

local function vanila_skeet_element(state)

    ui_set_visible(references.pitch[1], state)
    ui_set_visible(references.pitch[2], state)
    ui_set_visible(references.yaw_base, state)
    ui_set_visible(references.yaw[1], state)
    ui_set_visible(references.yaw[2], state)
    ui_set_visible(references.jitter[1], state)
    ui_set_visible(references.jitter[2], state)
    ui_set_visible(references.body_yaw[1], state)
    ui_set_visible(references.body_yaw[2], state)
    ui_set_visible(references.body_freestanding, state)
    ------------------------------------------------------------
    ------------------------------------------------------------
    --Edge yaw
    ui_set_visible(references.edge_yaw, state)
    ------------------------------------------------------------
    --Freestanding
    ui_set_visible(references.freestanding[1], state)
    ui_set_visible(references.freestanding[2], state)
    ------------------------------------------------------------
    --Enabled
    --ui_set_visible(references.aa_enabled, state)
end


-->> Animation State
local Anim = {

    -->> Velocity Check
    velocity = function(player)
        local me = player
        local velocity_x, velocity_y = entity_get_prop(me, "m_vecVelocity")
        return math.sqrt(velocity_x ^ 2 + velocity_y ^ 2)
    end,

    -->> In Air Check
    inair = function(player)
        return (bit_band(entity_get_prop(player, "m_fFlags"), 1) == 0)
    end,

    -->> Crouch Check
    crouching = function(player)
        return (bit_band(entity_get_prop(player, "m_fFlags"), 4) == 0)
    end,

    -->> Stamina Check
    stamina = function(player)
        return (80 - entity_get_prop(player, "m_flStamina"))
    end,

    Slow_walk = function()
        return (ui_get(references.slow_walk[2]))
    end,

    -->> Extrapolate Check
    extrapolate = function( player , ticks , x, y, z )
        local xv, yv, zv =  entity.get_prop( player, "m_vecVelocity" )
        local new_x = x+globals_tickinterval( )*xv*ticks
        local new_y = y+globals_tickinterval( )*yv*ticks
        local new_z = z+globals_tickinterval( )*zv*ticks
        return new_x, new_y, new_z
    end,

    -->> Enemy visible
    enemy_visible = function(idx)
        for i=0, 8 do
            local cx, cy, cz = entity_hitbox_position(idx, i)
            if client.visible(cx, cy, cz) then
                return true
            end
        end
        return false
    end,

    is_key_release = function()

        local w = client.key_state(0x57)
        local a = client.key_state(0x41)
        local s = client.key_state(0x53)
        local d = client.key_state(0x44)
        local space = client.key_state(0x20)
    
        if w == false and a == false and s == false and d == false then
            return true
        else
            return false
        end
    end,

}

local _V3_MT   = {};
_V3_MT.__index = _V3_MT;

function _V3_MT:dot( other ) -- dot product
    return ( self.x * other.x ) + ( self.y * other.y ) + ( self.z * other.z );
end

local predict_ticks         = 5
local pi = 3.14159265358979323846
local function d2r(value)
	return value * (pi / 180)
end


local pre = {

    -->> Detection libary requires #1
    is_enemy_peeking =  function( player )
        local speed = Anim.velocity(entity.get_local_player())
        if speed < 5 then
            return false
        end
        local ex, ey, ez = entity.get_origin(player) 
        local origin = vector(entity.get_origin(player))
        local local_p = vector(entity.get_origin(entity.get_local_player()))
        local start_distance = origin:dist(local_p)
        local smallest_distance = 999999
        for ticks = 1, predict_ticks do
            local extrapolated = vector(Anim.extrapolate(player, ticks, ex, ey, ez))
            local distance = math.abs(extrapolated:dist(local_p)) 
    
            if distance < smallest_distance then
                smallest_distance = distance
            end
            if smallest_distance < start_distance then
                return true
            end
        end

        return smallest_distance < start_distance
    end,

    -->> Detection libary requires #2
    is_local_peeking_enemy =  function( player )
        local speed = Anim.velocity(entity.get_local_player())
        if speed < 5 then
            return false
        end
        local ex,ey,ez = entity_get_origin( player )
        local lx,ly,lz = entity_get_origin( entity_get_local_player() )
    
        local origin = vector(entity_get_origin(player))
        local local_p = vector(entity_get_origin(entity_get_local_player()))
        
        local start_distance = origin:dist(local_p)
        local smallest_distance = 999999
        if ticks ~= nil then
            TICKS_INFO = ticks
        else
        end
        for ticks = 1, predict_ticks do
    
            local extrapolated = vector(Anim.extrapolate( entity_get_local_player(), ticks, lx, ly, lz ))
            local distance = math.abs(extrapolated:dist(local_p)) 
            if distance < smallest_distance then
                smallest_distance = math.abs(distance)
            end
        if smallest_distance < start_distance then
                return true
            end
        end
        return smallest_distance < start_distance
    end,

    -->> Angle Forward
    angle_forward = function( angle ) -- angle -> direction vector (forward)
    local sin_pitch = math_sin( math_rad( angle.x ) );
    local cos_pitch = math_cos( math_rad( angle.x ) );
    local sin_yaw   = math_sin( math_rad( angle.y ) );
    local cos_yaw   = math_cos( math_rad( angle.y ) );

        return vector(
            cos_pitch * cos_yaw,
            cos_pitch * sin_yaw,
            -sin_pitch
        )
    end,

    -->> Vector To Angle
    vectorangle = function(x,y,z)
        local fwd_x, fwd_y, fwd_z
        local sp, sy, cp, cy
        
        sy = math.sin(d2r(y))
        cy = math.cos(d2r(y))
        sp = math.sin(d2r(x))
        cp = math.cos(d2r(x))
        fwd_x = cp * cy
        fwd_y = cp * sy
        fwd_z = -sp
        return fwd_x, fwd_y, fwd_z
    end,

    -->> Mutiplies Vector
    multiplyvalues = function(x,y,z,val)
        x = x * val y = y * val z = z * val
        return x, y, z
    end,

}

-->> Get fov
pre.get_FOV = function( view_angles, start_pos, end_pos )
    local type_str;
    local fwd;
    local delta;
    local fov;

    fwd   = pre.angle_forward( view_angles );
    delta = ( end_pos - start_pos ):normalized();
    fov   = math.acos( fwd:dot( delta ) / delta:length() );

    return math_max( 0.0, math.deg( fov ) );
end


local vars = {
    detection = 0, freestand = 0, freestand_mode = 0, cache_detection = 0, fs_bodyyaw = 180, random = 0,
    last_tick = 0, jitter_increment = 0, switch = 0, resolver = 0, fire
}

-->> Menu
local TAB, Antiaim, Antiaim_d =  { "AA", "Anti-aimbot angles", "Other", "Fake lag"}, {}, {}

-->> Menu Elements

local State = {"Global", "Crouch", "In Air", "Running", "Slow walking", "Standing"}
local AA = {}

local Init_Antiaim = function()
    for i=1, #State do
        AA[i] = {
            antiaim_state = menu.combo("AA", State[i], "Logic Selection", {
                "Manual", --"Dynamic", 
                "Freestand", "Jitter", "Slow Jitter", "Randomized Static", "Opposite"
            }),

            hide_real_free = menu.combo("AA", "Hide", "Body yaw in open \n"..State[i], {
                "Manual", "Dynamic", "Jitter", "Randomized Static", "Opposite"
            }),

            advanced = menu.checkbox("AA", State[i], "Enable Advance Settings"),

            jitter_body_yaw = menu.slider("AA", "Jitter", "Body yaw\n"..State[i], -180, 180, 0),

            left_body_yaw = menu.slider("AA", State[i], "Left Fake Limit", 0, 60, 60),
            right_body_yaw = menu.slider("AA", State[i], "Right Fake Limit", 0, 60, 60),

            roll_left = menu.slider("AA", State[i], "Roll In Left Side", -90, 90, -50),
            roll_right = menu.slider("AA", State[i], "Roll In Right Side", -90, 90, 50),
        }
    end

end

local lotus = {

    lebel = menu.label("AA", ">>Lotus"),

    antiaim = {
        
        exploits = menu.table("AA", "AA", "Enable Main Functions", { 
           "Dynamic Antiaim", "Enable Rolling", "Lower Body Yaw (move)", 
           "LBY Breaker", "\aB6B665FFRoll/Manual resolver", "\aB6B665FFValve Server Bypass",
        }),

        pitch = menu.table("AA", "AA", "Pitch Options", {
            "Dynamic Pitch Down", 
        }),

        yaw_base = menu.combo("AA", "AA", "Yaw Base", {
            "At targets", "Local view"
        }),

        avoid_silent = menu.checkbox("AA", "Roll", "reduce silent aim"),

        pitch_offset = menu.slider("AA", "Pitch", "Offset", 40, 89, 40),
        yaw_offset = menu.slider("AA", "Yaw", "Lean Value", 0, 80, 30),

        pitch_down_key = menu.hotkey("AA", "Manual", "Pitch Down key"),

        speed_roll = menu.slider("AA", "Roll", "Disable Roll in X Speed", 0, 250, 250),


        mode = menu.combo("AA", "AA", "Body Yaw Options", {
            "Globals", "Antiaim Builder"
        }),

        state = menu.combo("AA", "AA", "Antiaim Options", {
            "Crouch", "In Air", "Running", "Slow walking", "Standing"
        }),

        detect_range = menu.slider("AA", "Hide", "Detection Range", 10, 300, 80),

        lby_mode = menu.combo("AA", "AA", "LBY Options options", {
            "Default", "Sway (WIP)"
        }),

        debugger = menu.checkbox("AA", "Hide", "Unhide Debugger"),

        invert_key = menu.hotkey("AA", "Manual", "Invert Key"),

        invert_state = menu.slider("AA", "Manual", "Invert State", 1, 2, 1),

        slow_walk = menu.hotkey("AA", "Manual", "Dynamic slow walk"),

        Init_Antiaim(),
    },

    resolver = {
        modes = {
            selection = menu.table("AA", "Resolver", "Manual Options", {
                "Override Roll", "Override Desync"
            }),
            state_3 = menu.combo("AA", "Resolver", "Roll when Manual-off", {
                "Manual", "Auto"
            }),
        },
        roll = {
            left = menu.slider("AA", "Resolver", "Roll on left desync", -80, 80, 80),
            right = menu.slider("AA", "Resolver", "Roll on right desync", -80, 80, -80)
        },  
        invert = {
            state = menu.slider("AA", "Resolver", "Invert state", 1, 3, 1),
            key = menu.hotkey("AA", "Resolver", "Invert key")
        }
    },

    fakelag = {
        mode = menu.combo("FL", "Fake lag", "Amount", {
            "Dynamic", "Maximum", "Fluctuate", "Lotus-tech"
        }),

        variance = menu.slider("FL", "Fake lag", "Variance\nLotus tech", 0, 100, 0),
        amount =  menu.slider("FL", "Fake lag", "Amount\nLotus tech", 1, 18, 6),
    },

    visuals = {
        main = menu.table("AA", "Visuals", "Indicator", {
            "Status Netgraph", "Features Indicator", "Draw LBY Circle", "Better Scope visuals", "Logs" , "Unhide Menu"
        }),

        net_graph = menu.table("AA", "Netgraph", "Custom Netgraph", {
            "Custom Name Tag", "Disable Keybinds", "Costum colors", "Dsiable LBY Bar"
        }),

        ind_menu = menu.table("AA", "Indicator", "Feature Indicator", {
            "Body yaw Indicator", "Vanillia Skeet Indicator", "Costum colors"
        }),

        vanilla_ind = menu.table("AA", "Vanillia", "Enable Indicator", {
            "Fov", "Auto wall", "Automatic fire", "Desync", "Overlap", "Fake lag", "Body Yaw"
        }),

        name_tag = ui_new_textbox(TAB[1], TAB[2], "   "),

        scope_third = menu.table("AA", "Scopes", "Third Person Scopes", {
            "Remove Blur", "Remove Scope Overlay", "Remove Blood"
        }),

        scope_first = menu.table("AA", "Scopes", "First Person Scopes", {
            "Remove Blur", "Remove Scope Overlay", "Remove Blood"
        }),

        logs = menu.table("AA", "Visuals", "Hitlogs", {
            "on Impact", "on Hit", "on Miss", "on Enemy Miss"
        }),
    },

    colors = {
        Label_a = ui_new_label( "AA", "Anti-aimbot angles", "\a87CEFAFFCostum: \aFFFFFFFFLeft Color" ),
        left = ui_new_color_picker( "AA", "Anti-aimbot angles", " 1", 154, 226, 250, 255 ),
        Label_b = ui_new_label( "AA", "Anti-aimbot angles", "\a87CEFAFFCostum: \aFFFFFFFFLeft Alt Color" ),
        left_alt = ui_new_color_picker( "AA", "Anti-aimbot angles", " 2", 109, 213, 250, 255 ),
        Label_c = ui_new_label( "AA", "Anti-aimbot angles", "\a87CEFAFFCostum: \aFFFFFFFFRight Color" ),
        right = ui_new_color_picker( "AA", "Anti-aimbot angles", " 3", 255, 255, 255, 220 ),
        Label_d = ui_new_label( "AA", "Anti-aimbot angles", "\a87CEFAFFCostum: \aFFFFFFFFRight Alt Color" ),
        right_alt = ui_new_color_picker( "AA", "Anti-aimbot angles", " 4", 253, 163, 180, 220 ),

    },

    color_vnl = {
        Label_e = ui_new_label( "AA", "Anti-aimbot angles", "\a87CEFAFFCostum: \aFFFFFFFFVanilla Color" ),
        vnl_ind = ui_new_color_picker( "AA", "Anti-aimbot angles", " 5", 220, 220, 220, 180),
    },


    rages = {
        main = menu.table("AA", "Rage", "Rage Options", {
            "Dynamic Auto Wall", "Dynamic Auto Fire", "Dynamic fov", 
        }),

        autowall = menu.hotkey("AA", "Auto-Wall", "Auto Wall on key"),
        autofire = menu.hotkey("AA", "Auto-Fire", "Auto Fire on key"),

        min_fov = menu.slider("AA", "FOV", "Minimum fov", 1, 180, 20),
        max_fov = menu.slider("AA", "FOV", "Maximum fov", 1, 180, 180),
        scaling = menu.slider("AA", "FOV", "Scaling offset", 1, 250, 150),
    }


}

local bind_system = false
local antiaim_lib = {


    
    -->> Reversed Freestanding
    detection = function()

        local closest_fov           = 100000
    
        local player_list           = entity.get_players( true )
    
        local eye_pos               = vector( x, y, z )
    
        x,y,z                       = client.camera_angles( )
    
        local cam_angles            = vector( x, y, z )
        
        for i = 1 , #player_list do
            local player                  = player_list[ i ]
            if not entity_is_dormant( player ) and entity_is_alive( player ) then
                if pre.is_enemy_peeking( player ) or pre.is_local_peeking_enemy( player ) then
                    local last_time_peeked        = globals_curtime( )
                    local enemy_head_pos    = vector( entity_hitbox_position( player, 0 ) )
                    local current_fov       = pre.get_FOV( cam_angles,eye_pos, enemy_head_pos )
                    if current_fov < closest_fov then
                        closest_fov         = current_fov
                        needed_player       = player
                    end
                end
            end
        end

        if needed_player ~= -1 then
            if entity.is_alive( player ) then
                if ( ( pre.is_enemy_peeking( player ) or pre.is_local_peeking_enemy( player ) ) ) == true then
                    vars.detection = 1
                else
                    vars.detection = -1
                end
            end
        end

    end,

    -->> Freestanding
    freestanding = function(range, paint)
        local localp = entity.get_local_player()
        if entity_get_prop(localp, "m_lifeState") ~= 0 then
            return false
        --we are dead who cares
        end
    
        local eyepos_x, eyepos_y, eyepos_z = entity_get_prop(localp, "m_vecAbsOrigin")
        local offsetx, offsety, offsetz = entity_get_prop(localp, "m_vecViewOffset")
        eyepos_z = eyepos_z + offsetz
        local lowestfrac = 1
        local dir = false
        local cpitch, cyaw = client.camera_angles()
        local fractionleft, fractionright = 0, 0
        local amountleft, amountright = 0, 0
        for i = -70, 70, 5 do
            if i ~= 0 then
                local fwdx, fwdy, fwdz = pre.vectorangle(0, cyaw + i, 0)
                fwdx, fwdy, fwdz = pre.multiplyvalues(fwdx, fwdy, fwdz, range)
                --debug drawing if u want to play with the values
    
                local fraction =
                    client.trace_line(
                    localp,
                    eyepos_x,
                    eyepos_y,
                    eyepos_z,
                    eyepos_x + fwdx,
                    eyepos_y + fwdy,
                    eyepos_z + fwdz
                )
                local outx, outy = renderer.world_to_screen(eyepos_x + fwdx, eyepos_y + fwdy, eyepos_z + fwdz)

                if fraction < 1 then
                    if paint then
                        renderer.rectangle(outx - 2, outy - 2, 4, 4, 0, 255, 0, 255)
                    end
                else
                    if paint then
                        renderer.rectangle(outx - 2, outy - 2, 4, 4, 255, 255, 255, 255)
                    end
                end

                if i > 0 then
                    fractionleft = fractionleft + fraction
                    amountleft = amountleft + 1
                else
                    fractionright = fractionright + fraction
                    amountright = amountright + 1
                end
            end
        end

        local averageleft, averageright = fractionleft / amountleft, fractionright / amountright

        if averageleft < averageright then
            return "LEFT" 
        elseif averageleft > averageright then
            return "RIGHT"
        else
            return "OPEN"
        end
    end,

    random = function()
        local random = math.random(1, 2)
        if random == 1 then
            vars.random = -1
        else
            vars.random = 1
        end
    end,

    slow_jitter = function(speed)
        local localplayer = entity_get_local_player()
        local tickbase = entity.get_prop(localplayer, "m_nTickbase")
        if vars.last_tick + speed < tickbase or vars.last_tick > tickbase then
            vars.last_tick = tickbase
            vars.jitter_increment = vars.jitter_increment + 1
            vars.switch = not vars.switch 
        end
    end,

    manual = function()
        ui_set(lotus.antiaim.invert_key, "On hotkey")

        -->> Import Disable Keybindss / Current State
        local m_state = ui_get(lotus.antiaim.invert_state)
        local key_state = ui_get(lotus.antiaim.invert_key)

        vars.manual = (m_state == 1 and -1) or (m_state == 2 and 1)

        if bind_system == key_state then return end

        bind_system = key_state

        -->> Cache Keybinds
        if (bind_system and key_state == 1) then ui_set(lotus.antiaim.invert_state, 2) return end
        if key_state and m_state ~= 1 then ui_set(lotus.antiaim.invert_state, 1) return end
        if key_state and m_state ~= 2 then ui_set(lotus.antiaim.invert_state, 2) return end
    end,

    manual_r = function()
        ui_set(lotus.resolver.invert.key, "On hotkey")
    
        -->> Import Disable Keybinds / Current State
        local m_state = ui_get(lotus.resolver.invert.state)
        local key_state = ui_get(lotus.resolver.invert.key)
    
        vars.resolver = (m_state == 1 and 1) or (m_state == 2 and 2) or (m_state == 3 and 3)
    
        if bind_system == key_state then return end
    
        bind_system = key_state
    
        -->> Cache Keybinds and update the state
        if key_state then
            if m_state == 1 then
                ui_set(lotus.resolver.invert.state, 2)
            elseif m_state == 2 then
                ui_set(lotus.resolver.invert.state, 3)
            elseif m_state == 3 then
                ui_set(lotus.resolver.invert.state, 1)
            else
                ui_set(lotus.resolver.invert.state, 1)
            end
            return
        end
    end,

    get_state = function()
        local local_player = entity_get_local_player()
        local i = (ui_get(lotus.antiaim.mode) == "Globals") and 1 or
        (Anim.Slow_walk() and 5) or ((Anim.inair(local_player) and 3)) or 
        (not Anim.crouching(local_player) and 2) or (Anim.velocity(local_player) > 5 and 4 or 6)

        return i
    end

}

-->> Menu element handler
local visible_handler = function()

    -->> Antiaim Parts
    local enable = menu.contains(ui_get(lotus.antiaim.exploits), "Dynamic Antiaim")
    local pitch = menu.contains(ui_get(lotus.antiaim.pitch), "Dynamic Pitch Down")
    local resolver = menu.contains(ui_get(lotus.antiaim.exploits), "\aB6B665FFRoll/Manual resolver")
    local _state = (ui_get(lotus.antiaim.mode) == "Globals") and "Global" or ui_get(lotus.antiaim.state)
    local roll_pitch = menu.contains(ui_get(lotus.antiaim.exploits), "Enable Rolling") and pitch
    local pitch_down = ui_get(lotus.antiaim.pitch) and enable and pitch
    local global = (_state ~= "Global") and enable

    ui_set_visible(lotus.antiaim.pitch, enable)
    ui_set_visible(lotus.antiaim.yaw_base, pitch_down)
    ui_set_visible(lotus.antiaim.pitch_offset, pitch_down)
    ui_set_visible(lotus.antiaim.yaw_offset, pitch_down)

    ui_set_visible(lotus.antiaim.speed_roll, roll_pitch)
    ui_set_visible(lotus.antiaim.pitch_down_key, roll_pitch)
    ui_set_visible(lotus.antiaim.mode, enable)
    ui_set_visible(lotus.antiaim.state, global)

    ui_set_visible(lotus.antiaim.invert_state, false)
    for i=1, #State do
        local set_visible = (_state == State[i]) and enable
        local freestand = (ui_get(AA[i].antiaim_state) ==  "Freestand") and set_visible
        -->> Antiaim State
        ui_set_visible(AA[i].antiaim_state, set_visible)
        ui_set_visible(AA[i].advanced, set_visible)
        -->> Hide Logic
        ui_set_visible(AA[i].hide_real_free, freestand)
        -->> Advance Settings
        local jitter = (ui_get(AA[i].antiaim_state) == "Jitter") and set_visible
        ui_set_visible(AA[i].jitter_body_yaw, jitter)
        -->> Body Yaw
        local advance = (ui_get(AA[i].advanced)) and set_visible
        ui_set_visible(AA[i].left_body_yaw, advance)
        ui_set_visible(AA[i].right_body_yaw, advance)
        -->> Roll
        local roll = menu.contains(ui_get(lotus.antiaim.exploits), "Enable Rolling") and set_visible
        ui_set_visible(AA[i].roll_left, roll)
        ui_set_visible(AA[i].roll_right, roll)
    end

    -->> Antiaim utils
    ui_set_visible(lotus.antiaim.lby_mode, enable)
    ui_set_visible(lotus.antiaim.detect_range, enable)
    ui_set_visible(lotus.antiaim.debugger, enable)
    ui_set_visible(lotus.antiaim.invert_key, enable)
    ui_set_visible(lotus.antiaim.slow_walk, enable)

    -->> Resolver utils
    ui_set_visible(lotus.resolver.modes.selection, resolver)
    ui_set_visible(lotus.resolver.modes.state_3, resolver)
    ui_set_visible(lotus.resolver.roll.left, resolver)
    ui_set_visible(lotus.resolver.roll.right, resolver)
    ui_set_visible(lotus.resolver.invert.key, resolver)
    ui_set_visible(lotus.resolver.invert.state, false)

    -->> Visuals Parts
    local indicator = menu.contains(ui_get(lotus.visuals.main), "Status Netgraph")
    ui_set_visible(lotus.visuals.net_graph, indicator)
    
    local unhide = menu.contains(ui_get(lotus.visuals.main), "Unhide Menu")
    vanila_skeet_element(unhide)
    -- Name tag
    local Nametag = menu.contains(ui_get(lotus.visuals.net_graph), "Custom Name Tag") and indicator
    ui_set_visible(lotus.visuals.name_tag, Nametag)

    -- Scope Visuals
    local scope_visuals = menu.contains(ui_get(lotus.visuals.main), "Better Scope visuals")
    ui_set_visible(lotus.visuals.scope_first, scope_visuals)
    ui_set_visible(lotus.visuals.scope_third, scope_visuals)

    -- Logs
    local logs = menu.contains(ui_get(lotus.visuals.main), "Logs")
    ui_set_visible(lotus.visuals.logs, false)

    -- Hide Colors
    local custom = menu.contains(ui_get(lotus.visuals.net_graph), "Costum colors")

    for _, name in pairs(lotus.colors) do
        ui_set_visible(name, custom)
    end

    -- Hide Vnl Colors
    local vnl = menu.contains(ui_get(lotus.visuals.ind_menu), "Costum colors")

    for _, name in pairs(lotus.color_vnl) do
        ui_set_visible(name, vnl)
    end

    -- Feature indicator
    local feature = menu.contains(ui_get(lotus.visuals.main), "Features Indicator")
    ui_set_visible(lotus.visuals.ind_menu, feature)

    -- Vanilla Indicator
    local vanilla = menu.contains(ui_get(lotus.visuals.ind_menu), "Vanillia Skeet Indicator")
    ui_set_visible(lotus.visuals.vanilla_ind, vanilla)

    -->> Rage Parts
    local autowall = menu.contains(ui_get(lotus.rages.main), "Dynamic Auto Wall")
    ui_set_visible(lotus.rages.autowall, autowall)

    -->> Auto Fire
    local autofire = menu.contains(ui_get(lotus.rages.main), "Dynamic Auto Fire")
    ui_set_visible(lotus.rages.autofire, autofire)

    -->> Dynamic Fov
    local dynamic_fov = menu.contains(ui_get(lotus.rages.main), "Dynamic fov")
    ui_set_visible(lotus.rages.min_fov, dynamic_fov)
    ui_set_visible(lotus.rages.max_fov, dynamic_fov)
    ui_set_visible(lotus.rages.scaling, dynamic_fov)
end

-->> Freestanding Builder Libary
local freestand_builder = function(i)

    local free = antiaim_lib.freestanding(ui_get(lotus.antiaim.detect_range), false)
    if free == "LEFT" then 
        vars.freestand = -1 
        vars.freestand_mode = "Static"
    elseif free == "RIGHT" then 
        vars.freestand = 1 
        vars.freestand_mode = "Static"
    elseif free == "OPEN" then
        local manual = menu.find(ui_get(AA[i].hide_real_free), "Manual")
        if manual then antiaim_lib.manual() end        
        local Dynamic = menu.find(ui_get(AA[i].hide_real_free), "Dynamic")
        if Dynamic then antiaim_lib.detection() end
        local Randomized = menu.find(ui_get(AA[i].hide_real_free), "Randomized Static")
        if Randomized then antiaim_lib.random() end
        local Opposite = menu.find(ui_get(AA[i].hide_real_free), "Opposite")

        local Jitter = menu.find(ui_get(AA[i].hide_real_free), "Jitter")

        vars.freestand = (Dynamic and vars.detection) or
                        (Randomized and vars.random) or
                        (Jitter and ui_get(AA[i].jitter_body_yaw)) or
                        (manual and vars.manual) or 0

        vars.freestand_mode = Opposite and "Opposite" or
                             Jitter and "Jitter" or "Static"
    end
end

-->> Antiaim handler
local function bodyyaw_handler(cmd)

    -->> Sync Animation State
    local i = antiaim_lib.get_state()

    -->> Init All Logics
    local dynamic = menu.find(ui_get(AA[i].antiaim_state), "Dynamic")
    if dynamic then antiaim_lib.detection() end
    local freestand = menu.find(ui_get(AA[i].antiaim_state), "Freestand")
    if freestand then freestand_builder(i) end
    local manual = menu.find(ui_get(AA[i].antiaim_state), "Manual")
    if manual then antiaim_lib.manual() end
    local slow = menu.find(ui_get(AA[i].antiaim_state), "Slow Jitter")
    if slow then antiaim_lib.slow_jitter((vars.jitter_increment % 3 == 0 and 2 or 1) + cmd.chokedcommands) end
    local random = menu.find(ui_get(AA[i].antiaim_state), "Randomized Static")
    if random then antiaim_lib.random() end

    -->> Init Other Logics
    local jitter = menu.find(ui_get(AA[i].antiaim_state), "Jitter")
    local opposite = menu.find(ui_get(AA[i].antiaim_state), "Opposite")

    local advance = ui_get(AA[i].advanced)
    -->> Implement Antiaim
    local avoid_silent = ui_get(lotus.antiaim.avoid_silent) and vars.fire

    local pitch_down =  ((menu.contains(ui_get(lotus.antiaim.pitch), "Dynamic Pitch Down") and 
                        ui_get(lotus.antiaim.pitch_down_key)) and not avoid_silent)

    local desync = anti_aim.get_desync(1)

    local _preset = {
        base = ui_get(lotus.antiaim.yaw_base),
        pitch = ui_get(lotus.antiaim.pitch_offset),
        yaw = ui_get(lotus.antiaim.yaw_offset)
    }

    local yaw = {

        pitch_base = (pitch_down and "Custom") or "Off",

        pitch    = (pitch_down and _preset.pitch) or 0,

        yaw_base = (pitch_down and _preset.base) or "Local view",

        yaw_set =  (pitch_down and "180") or "180",

        yaw =       (pitch_down and (desync and -180 + _preset.yaw or 
                                                 180 - _preset.yaw)) or 180,

    }

    local lby = (ui_get(lotus.antiaim.lby_mode) == "Default") and Anim.velocity(entity_get_local_player()) < 20 and 180 or 1 or
                (ui_get(lotus.antiaim.lby_mode) == "Sway (WIP)") and 80

    local body_yaw = {
        
        mode =      (opposite and "Opposite") or
                    (jitter and "Jitter") or
                    (freestand and vars.freestand_mode) or
                    "Static",


        body_yaw =  (dynamic and vars.detection * lby) or
                    (freestand and vars.freestand * lby) or
                    (slow and (vars.switch and lby or -lby)) or
                    (jitter and ui_get(AA[i].jitter_body_yaw)) or
                    (random and vars.random * lby) or
                    (manual and vars.manual * lby) or
                    (opposite and 0),

        fake_limit =    (desync > 0) and 
                        ui_get(AA[i].right_body_yaw) or ui_get(AA[i].left_body_yaw)
    }

    -->> If Chocking then dont do anything
    if cmd.chokedcommands ~= 0 then return end

    ui_set(references.pitch[1], yaw.pitch_base)
    ui_set(references.pitch[2], yaw.pitch)
    ui_set(references.yaw_base, yaw.yaw_base)
    ui_set(references.yaw[1], yaw.yaw_set)
    ui_set(references.yaw[2], yaw.yaw)

    ui_set(references.body_yaw[1], body_yaw.mode)
    ui_set(references.body_yaw[2], body_yaw.body_yaw)
    --ui_set(references.fake_limit, body_yaw.fake_limit)
end

local function vanila_fakelag_element(state)
    ui_set_visible(references.fake_lag, state)
    ui_set_visible(references.fake_lag_limit, state)
    ui_set_visible(references.variance, state)

    ui_set_visible(lotus.fakelag.amount, not state)
    ui_set_visible(lotus.fakelag.mode, not state)
    ui_set_visible(lotus.fakelag.variance, not state)
end
-->> Roll Angle Handler
local roll_handler = function(h)
    local a=entity_get_local_player()if not entity_is_alive(a)then return end;local b=g.vfptr.GetUserCmd(ffi.cast("uintptr_t",g),0,h.command_number)local c=entity.get_player_weapon(a)local d=bit_band(0xffff,entity_get_prop(c,"m_iItemDefinitionIndex"))local e=({[43]=true,[44]=true,[45]=true,[46]=true,[47]=true,[48]=true,[68]=true})[d]or false;if e then local f=entity_get_prop(c,"m_fThrowTime")if bit_band(b.buttons,buttons_e.attack)==0 or bit_band(b.buttons,buttons_e.attack_2)==0 then if f>0 then return end end end

    -------------Ignoring nades
    local local_player = entity_get_local_player()
    local my_weapon = entity.get_player_weapon(local_player)
    local wepaon_id = bit_band(0xffff, entity_get_prop(my_weapon, "m_iItemDefinitionIndex"))
    local is_grenade =
        ({
        [43] = true,
        [44] = true,
        [45] = true,
        [46] = true,
        [47] = true,
        [48] = true,
        [68] = true
    })[wepaon_id] or false
    
    if is_grenade then
        if bit_band(b.buttons,buttons_e.attack)==0 or bit_band(b.buttons,buttons_e.attack_2)==0 then return end
    end

    j=g.vfptr.GetUserCmd(ffi.cast("uintptr_t",g),0,h.command_number)
    --ui.set(slider, anti_aim.get_desync(1) > 0 and -50 or 50)
    local i = antiaim_lib.get_state()

    local speed_limit = ui_get(lotus.antiaim.speed_roll) > Anim.velocity(entity.get_local_player())

    local pitch_down =  menu.contains(ui_get(lotus.antiaim.pitch), "Dynamic Pitch Down") and 
                        ui_get(lotus.antiaim.pitch_down_key)

    local roll = {

        value =     ((pitch_down) and (speed_limit and
                    ((anti_aim.get_desync(1) > 0) and (ui_get(AA[i].roll_left)) or (ui_get(AA[i].roll_right))) or
                    0))

                    or

                    ((anti_aim.get_desync(1) > 0) and (ui_get(AA[i].roll_left))) or (ui_get(AA[i].roll_right))
    }

    j.viewangles.roll = roll.value
end


local function terminate_fakelag()

    -->>Intialize fakelag
    local mode = ui_get(lotus.fakelag.mode)
    local variance = ui_get(lotus.fakelag.variance)
    local amount = ui_get(lotus.fakelag.amount)

    -->>Lotus tech logic
    local lotus_preset = menu.find(ui_get(lotus.fakelag.mode), "Lotus-tech")
    local is_fakeducking = ui_get(references.fakeduck[1])
    local onshot, onshotkey = ui.reference('aa', 'other', 'On shot anti-aim')
    local is_expoliting = ((ui_get(onshotkey) or ui.get(references.doubletap[2])))
    local is_holding = Anim.velocity(entity_get_local_player()) < 10
    local players = entity_get_players(true)
    local dormant = #players == 0 


    -->>Lotus tech handling visible/hit
    local enemies_visible = false
    local enemies_canhit = false

    for i=1, #players do
        -->> Handling enemy visibility
        local entindex = players[i]	
        if Anim.enemy_visible(entindex) then
            enemies_visible = true
        end

        -->> Handling enemy can hit local
        local esp = entity.get_esp_data(entindex)
        local hit = bit.band(esp.flags, 2048)
        if hit == 2048 then
            enemies_canhit = true
        end
    end
    -->>Lotus tech logic implementation

    -->>Logic: Holding/Fake duck -> Enemies can hit/visible -> dormant -> default slider
    local lotus_mode = (is_holding and "Dynamic") or
                       (enemies_canhit and "Maximum") or
                       (enemies_visible and "Maximum") or 
                       (dormant and "Dynamic") or
                       ("Dynamic")

    local lotus_amount = (is_fakeducking and 6) or
                         (is_holding and 1) or
                         (enemies_canhit and amount) or
                         (enemies_visible and amount) or
                         (is_expoliting and 1) or
                         (dormant and 1) or
                         (amount)

    local FL = {
        mode = (lotus_preset and lotus_mode) or mode,
        variance = variance,
        amount = (lotus_preset and lotus_amount) or amount,
    }

    -->>Avoiding retard messing their fakelag
    local tickbase = cvar.sv_maxusrcmdprocessticks:get_int() - 1
    if amount > tickbase then ui_set(lotus.fakelag.amount, tickbase) end
    if FL.amount > tickbase then FL.amount = tickbase end
    
    -->>Final Implement
    ui_set(references.fake_lag, FL.mode)
    ui_set(references.fake_lag_limit, FL.amount)
    ui_set(references.variance, FL.variance)
end


-----Antiaim Part ends

local ss = {client.screen_size()}

local ind = {
    offset = {0, 0, 0},
    left = {0, 0, 0},
    right = {0, 0, 0},
    length = 0,
    left_offset = {4, 255, 0},
    right_offset = {-4, 0, 255},
    offset_final = {0, 0, 0},
    ----------------------------
    offsets = {0, 0, 0, 0, 0, 0},
    alpha = {0, 0, 0, 0, 0, 0},
    exp = {0, 0, 0, 0, 0, 0},
    exp_cache = {0, 0, 0, 0, 0, 0},
    text = {"AWALL", "BAIM", "SAFE", "DT", "HIDE", "PITCH"},
    line = {0, 0},
    ----------------------------
    manual_left = {0, 0},
    manual_right = {0, 0}
}



local indicator_handler = function()

    -->> States Overlap/Desync
    local desync = anti_aim.get_desync(1)
    local overlap_out = math.floor(100 *anti_aim.get_overlap(rotation))

    -->> Import Color Config
    local l_r, l_g, l_b, left_a = ui_get(lotus.colors.left)
    local l_ar, l_ag, l_ab, right_a = ui_get(lotus.colors.right)

    local r_a, r_g, r_b, l_aa = ui_get(lotus.colors.left_alt)
    local r_ar, r_ag, r_ab, right_aa = ui_get(lotus.colors.right_alt)

    -->> State Customize Options
    local Nametag = menu.contains(ui_get(lotus.visuals.net_graph), "Custom Name Tag")

    local colors = {
        left = {l_r, l_g, l_b},
        right = {l_ar, l_ag, l_ab},
        left_alt = {r_a, r_g, r_b},
        right_alt = {r_ar, r_ag, r_ab},
    }
    
    -->> Handling Indicator offset
    for i = 1, #ind.offset do
        if desync >= 45 then
            ind.offset[i] = render.lerp(ind.offset[i], ind.left_offset[i], 6)
        else 
            if desync <= 45 then
                ind.offset[i] = render.lerp(ind.offset[i], ind.right_offset[i], 6)
            else
                ind.offset[i] = render.lerp(ind.offset[i], ind.offset_final[i], 6)
            end
        end
    end

    local center_x, center_y = ss[1] / 2 + ind.offset[1], ss[2] / 2 

    -->> Handling Overlap offset
    for i = 1, 3 do
        ind.left[i] = render.lerp(ind.left[i], (overlap_out > 32 and colors.left[i]) or colors.left_alt[i], 6)
        ind.right[i] = render.lerp(ind.right[i], (overlap_out > 32 and colors.right[i]) or colors.right_alt[i], 6)
    end
    
    -->> Rendering Main Text
    local main = render.gradient_text(ind.left[1], ind.left[2], ind.left[3], 255, 
                                    ind.right[1], ind.right[2], ind.right[3], 255, 
                                    Nametag and ui_get(lotus.visuals.name_tag) or "Lotus-Tech*")

    renderer_text(center_x + 3, center_y + 35, 255, 255, 255, 255, "cb", nil, main)

    -->> Rendering Overlap Bar
    local length = math.floor(58 - (anti_aim.get_overlap(rotation) * 58))

    ind.length = render.lerp(ind.length, length, 6)

    -- Background Bar
    renderer_rectangle(center_x + 4 - 30, center_y + 42, 55, 3, 17, 17, 17, 190)

    -- Colorful bar
    renderer_gradient(center_x + 3 - 30, center_y + 42, ind.length, 3, 
                        ind.left[1], ind.left[2], ind.left[3], 255, 
                        ind.right[1], ind.right[2], ind.right[3], 255, true)


    -->> Rendering Overlap Text
    local text2 = render.gradient_text(ind.left[1], ind.left[2], ind.left[3], 
                                        (overlap_out < 32 and 255) or 230,
                                        ind.right[1], ind.right[2], ind.right[3], 
                                        (overlap_out < 32 and 255) or 150, 
                                        "LAP                                     LBY")
    renderer_text(center_x - 31, center_y + 45, 255, 255, 255, 255, "-", nil, text2)

    -->> Rendering Arrows

    -- Left
    render.arrow(center_x + 12, center_y + 36 + 8, ind.left[1], ind.left[2], ind.left[3], math.floor(ind.offset[3]), 180, 13)
    -- Right 
    render.arrow(center_x - 9, center_y + 36 + 8, ind.right[1], ind.right[2], ind.right[3], ind.offset[2], 360, 15)

end

-->> Keybinds
local function keybinds()

    local center_x, center_y = ss[1] / 2 , ss[2] / 2 

    local aw = ui_get(references.autowall)
    local fb = ui_get(references.fba_key)
    local sp = ui_get(references.fsp_key)
    local dt = ui_get(references.doubletap[2])
    local os = ui_get(references.onshot[2]) and ui_get(references.onshot[1])
    local ex =  menu.contains(ui_get(lotus.antiaim.pitch), "Dynamic Pitch Down") and 
                        ui_get(lotus.antiaim.pitch_down_key)

    local keybind ={
        key = {aw, fb, sp, dt, os, ex}
    }

    local line_offset = 0
    for i = 1, #keybind.key, 1 do
        ind.offsets[i] = render.lerp(ind.offsets[i], keybind.key[i] and 80 or 0 , 6)
        ind.alpha[i] = render.lerp(ind.alpha[i], keybind.key[i] and 255 or 0 , 6)
        ind.exp[i] = render.lerp(ind.exp[i], keybind.key[i] and 10 or 0 , 6)
        
        ind.exp_cache[i] =  (i == 1 and 0) or 
                            (i == 2 and ind.exp[1]) or 
                            (i == 3 and ind.exp[2] + ind.exp[1]) or 
                            (i == 4 and ind.exp[3] + ind.exp[2] + ind.exp[1]) or 
                            (i == 5 and ind.exp[4] + ind.exp[3] + ind.exp[2] + ind.exp[1]) or
                            (i == 6 and ind.exp[5] + ind.exp[4] + ind.exp[3] + ind.exp[2] + ind.exp[1])

        renderer_text(center_x + 3 + 60 + 4, center_y + 20 + 80 - ind.offsets[i] + ind.exp_cache[i], 255, 255, 255, ind.alpha[i], "-", nil, ind.text[i])
        line_offset = ind.exp_cache[i] + ind.exp[6]
    end

    if line_offset >= 1 then
        ind.line[1] = render.lerp(ind.line[1], 50, 6)
        ind.line[2] = render.lerp(ind.line[2], 50, 6)
    else
        ind.line[1] = render.lerp(ind.line[1], 0, 6)
        ind.line[2] = render.lerp(ind.line[2], 0, 6)
    end

    renderer_gradient(center_x + 3 + 55 + 4 , center_y + 20, 1, ind.line[1], 255, 255, 255, ind.line[2], 255, 255, 255, ind.line[2], true)
    renderer_gradient(center_x + 3 + 55 + 4, center_y + 20, 1, line_offset,  255, 255, 255, 255, 255, 255, 255, 255, true)
end



local logs = {}

logs.byaw_log = {
    info = '',
    state = false,
}

logs.on_player_hurt = function(e)
    local attacker_id = client.userid_to_entindex(e.attacker)

    if attacker_id == nil then
        return
    end

    if attacker_id ~= entity.get_local_player() then
        return
    end

    local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local target_id = client.userid_to_entindex(e.userid)
    local target_name = entity.get_player_name(target_id)
    
    logs.byaw_log.state = true
    logs.byaw_log.info = 'Hit \a90FF98alpha'..target_name..'\aFFFFFFalpha in\affbebealpha '.. e.dmg_health ..'\aFFFFFFalpha, HB: \aFFFDA6alpha'..group..',\aFFFFFFalpha HP:'.. e.health
end

logs.miss_brute = function(e)
    -- credit to @ally https://gamesense.pub/forums/viewtopic.php?id=31914
    local function KaysFunction(A,B,C)
        local d = (A-B) / A:dist(B)
        local v = C - B
        local t = v:dot(d) 
        local P = B + d:scaled(t)
        
        return P:dist(C)
    end

	local local_player = entity.get_local_player()
	local shooter = client.userid_to_entindex(e.userid)

	if not entity.is_enemy(shooter) or not entity.is_alive(local_player) then return end

    local overlap = 100 - math.floor(anti_aim.get_overlap() * 100)
	local shot_start_pos 	= vector(entity.get_prop(shooter, "m_vecOrigin"))
	shot_start_pos.z 		= shot_start_pos.z + entity.get_prop(shooter, "m_vecViewOffset[2]")
	local eye_pos			= vector(client.eye_position())
	local shot_end_pos 		= vector(e.x, e.y, e.z)
	local closest			= KaysFunction(shot_start_pos, shot_end_pos, eye_pos)

	if closest < 32 then
        logs.byaw_log.state = true
        logs.byaw_log.info = 'Miss Detected. Overlap: \aFFFDA6alpha('..overlap..'%\aFFFFFFalpha)'
	end
end

logs.on_aim_miss = function(e)
    local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local target_name = entity.get_player_name(e.target)
    local reason
    if e.reason == "?" then
    	reason = "Resolver"
    else
    	reason = e.reason
    end

    logs.byaw_log.state = true
    if e.reason == 'spread' then
        logs.byaw_log.info = 'Missed \a90FF98alpha'..target_name..'\aFFFFFFalpha HB: \aFFFDA6alpha'..group..', \aFFFFFFalphareason: \affbebealpha'..reason.." \aFFFDA6alpha("..math.floor(e.hit_chance).."%)"
    else
        logs.byaw_log.info = 'Missed \a90FF98alpha'..target_name..'\aFFFFFFalpha HB: \aFFFDA6alpha'..group..', \aFFFFFFalphareason: \affbebealpha'..reason
    end
end


local ath = function(alpha)
    return string.format('%02X', alpha)
end
local sx, sy = client.screen_size()
local drags = {
    logs = dragging_fn('indicator logs', 400 , sy/4),
}
local ani = {
    logs = 0,
    handler = 0
}
logs.draw = function(...)

    local animation_cache = {}
    local draw_event_list = {}

    local function lerp(start, vend, time)
        if not start then start = 0 end
        local cache_name = string.format('%s,%s,%s',start,vend,time)
        if animation_cache[cache_name] == nil then
            animation_cache[cache_name] = 0
        end

        animation_cache[cache_name] = start + (vend - start) * time
        return animation_cache[cache_name]
    end

    local function handler_event()
        local x, y = drags.logs:get()
        if logs.byaw_log.state then
            logs.byaw_log.state = false
            table.insert(draw_event_list,{
                text = logs.byaw_log.info ,
                timer = globals.realtime() ,
                alpha = 0 ,
                x_add = x ,
            })
            logs.byaw_log.info = ''
        end
    end

    local function draw()

        local x, y = drags.logs:get()
        local font = ''

        handler_event()
        event_name = event_name == nil and 0 or event_name
        if #draw_event_list > 0 then
            event_name = lerp(
                event_name, 200, globals.frametime() * 6
            )
        else
            event_name = lerp(
                event_name, 0, globals.frametime() * 6
            )
        end

        local _, normal_width = renderer.measure_text(font)
        local header = 'Log Events : '
        local width, height = renderer.measure_text(font, header)
        local _, _c, status = drags.logs:drag(width + 5,  height + 5)
        local selected = (status == "n" and true) or false
        local clicked = (status == "c" and true) or false

        local function alt_lerp(start, vend, time)
        return start + (vend - start) * time end
            
        ani.logs = alt_lerp(ani.logs, (selected) and 0 or 255, 6 * globals.frametime())
        local menu = ui_is_menu_open()
        ani.handler = alt_lerp(ani.handler, menu and 255 or event_name, 6 * globals.frametime())
        outline(x + 20, y - 3, width + 6, height + 6, 2, 180, 180, 180, ani.logs)

        renderer_text(x + 25, y - normal_width, 255,255,255,ani.handler,font,0,header)

        for i,info in ipairs(draw_event_list) do

            if i > 10 then
                table.remove(draw_event_list,i)
            end

            if not info.text or info.text == '' then goto skip end

            local length, width = renderer.measure_text(font, header..info.text)
            
            if info.timer + 3.5 < globals.realtime() then
                info.alpha = lerp(
                    info.alpha, 0, globals_frametime() * 6
                )
                info.x_add = lerp(
                    info.x_add,x+80, globals_frametime() * 8
                )
            else
                info.alpha = lerp(
                    info.alpha, 255, globals_frametime() * 6
                )
                info.x_add = lerp(
                    info.x_add, x + 40, globals_frametime() * 8
                )
            end

            local info_text = info.text:gsub("alpha", ath(info.alpha))
            local header = '[\aBBC8FFalphaLotus-tech\aFFFFFFalpha] '
            local header_sub = header:gsub("alpha", ath(info.alpha))
            renderer_text(info.x_add,y+i * (width+3),255,255,255,info.alpha,font,0, header_sub..info_text)

            if info.timer + 4 < globals_realtime() then
                table.remove(draw_event_list,i)
            end

            ::skip::
        end
    end

    return {
        main = draw
    }
end


-->> Vanilla Indicator
local a = {
    header = {0, 0, 0},
    desync = {0, 0, 0}
}

local function desync()
    for i = 1,  #a.desync, 1 do
        local hit = math.sqrt(anti_aim.get_desync(2) ^ 2) / 60
        local color = (i == 1 and (124 * 2 - 124 * hit)) or (i == 2 and 255 * hit) or (i == 3 and 13)
        a.desync[i] = render.lerp(a.desync[i], color, 6)
    end
    return true
end

local function c_2_p(percantage)
    for i = 1,  #a.header, 1 do
        local hit = 1 - (percantage)
        local color = (i == 1 and (124 * 2 - 124 * hit)) or (i == 2 and 255 * hit) or (i == 3 and 13)
        a.header[i] = render.lerp(a.header[i], color, 6)
    end
    return true
end

local function vanilla()

    local ind = {
        FOV = menu.contains(ui_get(lotus.visuals.vanilla_ind), "Fov") and ui_get(references.fov),
        AW = menu.contains(ui_get(lotus.visuals.vanilla_ind), "Auto wall") and ui_get(references.autowall),
        TM = menu.contains(ui_get(lotus.visuals.vanilla_ind), "Automatic fire") and ui_get(references.autofire),
        FAKE = menu.contains(ui_get(lotus.visuals.vanilla_ind), "Desync") and desync(),
        LBY = menu.contains(ui_get(lotus.visuals.vanilla_ind), "Overlap") and c_2_p(anti_aim.get_overlap(rotation)),
        FL = menu.contains(ui_get(lotus.visuals.vanilla_ind), "Fake lag") and ui_get(references.fake_lag_limit),
        bodyyaw = menu.contains(ui_get(lotus.visuals.vanilla_ind), "Body Yaw") and 
        ((ui_get(references.body_yaw[1]) == "Static") and (ui_get(references.body_yaw[2]) == 180 and "LEFT") or "RIGHT") or
        ((ui_get(references.body_yaw[1]) == "Jitter") and "Jitter")
    }

    local r_ar, r_ag, r_ab, right_aa = ui_get(lotus.color_vnl.vnl_ind)
    local color = {r_ar, r_ag, r_ab, right_aa}
    for _, name in pairs(ind) do
        if name then
            if _ == "FOV" or  _ == "fakelag" then 
                renderer.indicator(color[1], color[2], color[3], color[4], _..": "..name)
            elseif _ == "bodyyaw" then
                renderer.indicator(color[1], color[2], color[3], color[4], name)
            elseif _ == "LBY" then
                renderer.indicator(a.header[1], a.header[2], a.header[3], 255, "LBY")
            elseif _ == "FAKE" then
                renderer.indicator(a.desync[1], a.desync[2], a.desync[3], 255, "FAKE")
            else
                renderer.indicator(color[1], color[2], color[3], color[4], _)
            end
        end
    end

end

-->> Scope Visuals
local function scoped_visuals()
    local scope_enable = menu.contains(ui_get(lotus.visuals.main), "Better Scope visuals")
    local enable, key = ui_reference("Visuals", "Effects", "Force third person (alive)")
    local is_third = ui_get(enable) and ui_get(key)

    local blur_scoping_third = menu.contains(ui_get(lotus.visuals.scope_third), "Remove Blur")
    local blur_scoping_first = menu.contains(ui_get(lotus.visuals.scope_first), "Remove Blur")
    local blur_conditions = (is_third and blur_scoping_third and 0) or (not is_third and blur_scoping_first and 0) or 1

    local overlay_third = menu.contains(ui_get(lotus.visuals.scope_third), "Remove Scope Overlay")
    local overlay_first = menu.contains(ui_get(lotus.visuals.scope_first), "Remove Scope Overlay")
    local overlay_conditions = (is_third and overlay_third) or (not is_third and overlay_first)

    local remove_blood_third = menu.contains(ui_get(lotus.visuals.scope_third), "Remove Blood")
    local remove_blood_first = menu.contains(ui_get(lotus.visuals.scope_first), "Remove Blood")
    local blood_conditions = (is_third and remove_blood_third) or (not is_third and remove_blood_first)


    local postprocess = cvar.mat_postprocess_enable
    local soverlay = ui.reference("Visuals", "Effects", "Remove scope overlay")
    local blooda = cvar.violence_ablood
    local bloodb = cvar.violence_hblood


    postprocess:set_int(blur_conditions)
    blooda:set_int(blood_conditions)
    bloodb:set_int(blood_conditions)
    ui.set(soverlay, overlay_conditions)
    
end

-->> Dynamic FOV
local function dynamicfov_logic(min_fov, max_fov, current_autofactor)
    local old_fov = ui.get(references.fov)
    dynamicfov_new_fov = old_fov
    local enemy_players = entity_get_players(true)

    if min_fov > max_fov then
        store_min_fov = min_fov
        min_fov = max_fov
        max_fov = store_min_fov
    end

    if #enemy_players ~= 0 then
        local own_x, own_y, own_z = client.eye_position()
        local own_pitch, own_yaw = client.camera_angles()
        closest_enemy = nil
        local closest_distance = 999999999

        for i = 1, #enemy_players do
            local enemy = enemy_players[i]
            local enemy_x, enemy_y, enemy_z = entity_hitbox_position(enemy, 0)

            local x = enemy_x - own_x
            local y = enemy_y - own_y
            local z = enemy_z - own_z

            local yaw = ((math.atan2(y, x) * 180 / math.pi))
            local pitch = -(math.atan2(z, math_sqrt(math.pow(x, 2) + math.pow(y, 2))) * 180 / math.pi)

            local yaw_dif = math_abs(own_yaw % 360 - yaw % 360) % 360
            local pitch_dif = math_abs(own_pitch - pitch) % 360

            if yaw_dif > 180 then
                yaw_dif = 360 - yaw_dif
            end

            local real_dif = math_sqrt(math.pow(yaw_dif, 2) + math.pow(pitch_dif, 2))

            if closest_distance > real_dif then
                closest_distance = real_dif
                closest_enemy = enemy
            end
        end

        if closest_enemy ~= nil
        then
            local closest_enemy_x, closest_enemy_y, closest_enemy_z = entity_hitbox_position(closest_enemy, 0)
            local real_distance = math_sqrt(math.pow(own_x - closest_enemy_x, 2) + math.pow(own_y - closest_enemy_y, 2) + math.pow(own_z - closest_enemy_z, 2))

            dynamicfov_new_fov = (3800 / real_distance) * (current_autofactor * 0.01)

            if (dynamicfov_new_fov > max_fov) then
                dynamicfov_new_fov = max_fov
            elseif dynamicfov_new_fov < min_fov then
                dynamicfov_new_fov = min_fov
            end
        end

        dynamicfov_new_fov = math_floor(dynamicfov_new_fov + 0.5)

        if (dynamicfov_new_fov > closest_distance) then
            bool_in_fov = true
        else
            bool_in_fov = false
        end
    else

        dynamicfov_new_fov = min_fov
        bool_in_fov = false
    end

    -- global
    if dynamicfov_new_fov ~= old_fov then
        ui.set(references.fov, dynamicfov_new_fov)
    end
end

-->> Body yaw indicator
local function bodyyaw_indicator()
    local w, h = client.screen_size()
    local distance = (w/2) / 210 * 15
    local r, g, b = ind.right[1], ind.right[2], ind.right[3]
    local r1, g1, b1 = ind.left[1], ind.left[2], ind.left[3] 
    if ui_get(references.body_yaw[2]) == -180 then
        ind.manual_left[1] = render.lerp(ind.manual_left[1],20, 6)
        renderer_text(w/2 - distance - ind.manual_left[1], h / 2 - 1,  r1, g1, b1, ind.manual_left[1] * 8 + 90, "+c", 0, font.right)
        else
        ind.manual_left[1] = render.lerp(ind.manual_left[1],0, 6)
        renderer_text(w/2 - distance - ind.manual_left[1], h / 2 - 1, r1, g1, b1, ind.manual_left[1] , "+c", 0, font.right)
    end   

    if ui_get(references.body_yaw[2]) == 180 then
        ind.manual_right[1] = render.lerp(ind.manual_right[1],20, 6)
        renderer_text(w/2 + distance + ind.manual_right[1], h / 2 - 1, r, g, b, ind.manual_right[1] * 8 + 90, "+c", 0, font.left) 
    else
        ind.manual_right[1] = render.lerp(ind.manual_right[1],0, 6)
        renderer_text(w/2 + distance + ind.manual_right[1], h / 2 - 1, r, g, b, ind.manual_right[1] , "+c", 0, font.left) 
    end   
end

-->> Bypasser
local gamerules_ptr = client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")
local gamerules = ffi.cast("intptr_t**", ffi.cast("intptr_t", gamerules_ptr) + 2)[0]
local function valve_bypass(cmd)
    local is_valve_ds = ffi.cast('bool*', gamerules[0] + 124)
    if is_valve_ds ~= nil then
        is_valve_ds[0] = 0
    end
end

-->> LBY

local function setSpeed(newSpeed)
	if client.get_cvar("cl_sidespeed") == 450 and newSpeed == 450 then
		return
	end

    client.set_cvar("cl_sidespeed", newSpeed)
    client.set_cvar("cl_forwardspeed", newSpeed)
    client.set_cvar("cl_backspeed", newSpeed)
end

local update_player_resolver = function()
    antiaim_lib.manual_r()
    local players = entity_get_players(true)
    local keys = {
        selection = ui_get(lotus.resolver.modes.selection),
        off_state = ui_get(lotus.resolver.modes.state_3),
        roll = {
            left = ui_get(lotus.resolver.roll.left),
            right = ui_get(lotus.resolver.roll.right)
        },
        invert_key = ui_get(lotus.resolver.invert.key),
    }

    local enable_body_yaw = true
    if (vars.resolver == 3 and not menu.contains(keys.selection, "Override desync")) then enable_body_yaw = false end

    for i, p in pairs(players) do
        local model=nativeGetClientEntity(p)

        local desync = entity_get_prop(p, "m_flPoseParameter", 11) * 120 - 60

        local off_state = (keys.off_state == "Off" and 0) or 
                        ((keys.off_state == "Roll" and desync) and 50 or -50)

        local roll =    (vars.resolver == 1 and keys.roll.left) or 
                        (vars.resolver == 2 and keys.roll.right) or 
                        (vars.resolver == 3 and off_state)

        local body_yaw = (vars.resolver == 1 and 60) or (vars.resolver == 2 and -60) or (vars.resolver == 3 and 0)

        model.z = roll
        plist.set(p, "Force body yaw value", body_yaw)
        plist.set(p, "Force body yaw", enable_body_yaw)
    end
end

local function lean_lby(cmd, status, slowwalk)

    --something important is minified but i dont want to waste time on deleting to seperate those
    local a=entity_get_local_player()if not entity_is_alive(a)then return end;local b=g.vfptr.GetUserCmd(ffi.cast("uintptr_t",g),0,cmd.command_number)local c=entity.get_player_weapon(a)local d=bit_band(0xffff,entity_get_prop(c,"m_iItemDefinitionIndex"))local e=({[43]=true,[44]=true,[45]=true,[46]=true,[47]=true,[48]=true,[68]=true})[d]or false;if e then local f=entity_get_prop(c,"m_fThrowTime")if bit_band(b.buttons,buttons_e.attack)==0 or bit_band(b.buttons,buttons_e.attack_2)==0 then if f>0 then return end end end

    if (entity.get_prop(entity.get_local_player(), "m_MoveType") or 0) == 9 then return end

    local lean_bodyyaw = anti_aim.get_desync(2)

    if lean_bodyyaw == nil then return end
    
    local lby_break = menu.contains(ui_get(lotus.antiaim.exploits), "LBY Breaker")

    if lby_break then 

    -------------Ignoring nades
    local local_player = entity_get_local_player()
    local my_weapon = entity.get_player_weapon(local_player)
    local wepaon_id = bit_band(0xffff, entity_get_prop(my_weapon, "m_iItemDefinitionIndex"))
    local is_grenade =
        ({
        [43] = true,
        [44] = true,
        [45] = true,
        [46] = true,
        [47] = true,
        [48] = true,
        [68] = true
    })[wepaon_id] or false
    
    if is_grenade then
        if cmd.in_attack == 1 or cmd.in_attack2 == 1 then return end
    end

    status = Anim.velocity(entity.get_local_player()) < 50 and 1 or 0

    -----------------Ignore grenade end
    goto ignore end

    if math.abs(anti_aim.get_desync(1)) < 50 or cmd.chokedcommands == 0 then return end

    ::ignore::


    if ui.get(references.quick_peek[2]) then return end

    -- if (math.abs(cmd.forwardmove) > 1) then return end

    cmd.in_forward = status
end

local function resolver_indicator()
    local keys = {
        selection = ui_get(lotus.resolver.modes.selection),
        off_state = ui_get(lotus.resolver.modes.state_3),
        roll = {
            left = ui_get(lotus.resolver.roll.left),
            right = ui_get(lotus.resolver.roll.right)
        },
        invert_key = ui_get(lotus.resolver.invert.key),
    }

    local players = entity_get_players(true)
    local local_player = entity_get_local_player()
    if local_player == nil or not entity_is_alive(local_player) then return end
    for i = 1, #players do
        local off_state = keys.off_state
        local player_index = players[i]
        local enemy_target_idx = client.current_threat()
        --Check is Hitbox lethal
        local x1, y1, x2, y2, mult = entity.get_bounding_box(player_index)
        local desync = (vars.resolver == 1 and "LEFT") or (vars.resolver == 2 and "RIGHT") or ""
        if x1 ~= nil and mult > 0 then
            y1 = y1 - 17
            x1 = x1 + ((x2 - x1) / 2)
            if y1 ~= nil then 
                renderer_text(x1, y1, 255, 255, 255, 255, "cb", 0, desync) 
                if player_index == enemy_target_idx  then
                    --Display current threat
                    renderer_text(x1 + 18, y1, 255, 255,  255, 255, "cbd", 0, "-") 
                    renderer_text(x1 - 18, y1, 255, 255,  255, 255, "cbd", 0, "-")
                end
            end
        end
    end
    ---renderer_indicator(255, 255, 255, 255, "R: " .. ui_get(version))
end


local paint_log = logs.draw()
local callbacks =  {
    setup_command = function(cmd)

        local local_player = entity_get_local_player()
        if not entity_is_alive(local_player) then return end

        terminate_fakelag() --> Fakelag
        
        local slow_walk = ui_get(lotus.antiaim.slow_walk)
        local lby = menu.contains(ui_get(lotus.antiaim.exploits), "Lower Body Yaw (move)")
        local tickbase = cvar.sv_maxusrcmdprocessticks:get_int()
        lean_lby(cmd, (lby and 1 or 0), slow_walk) -- > LBY

        local dynamic = menu.contains(ui_get(lotus.antiaim.exploits), "Dynamic Antiaim")
        if dynamic then bodyyaw_handler(cmd) end -- > Enable Antiaim

        local bypass = menu.contains(ui_get(lotus.antiaim.exploits), "\aB6B665FFValve Server Bypass")
        if bypass then valve_bypass(cmd); client.set_cvar("sv_maxusrcmdprocessticks", "7") end -- > Valve Bypass

        if not bypass and tickbase ~= 16 then client.set_cvar("sv_maxusrcmdprocessticks", "16") end -- > Reset Valve Bypass
    end,

    update_player_net_end = function()
        local enable = menu.contains(ui_get(lotus.antiaim.exploits), "\aB6B665FFRoll/Manual resolver")
        if enable then update_player_resolver() end
    end,

    run_command = function(h)
        local enable = menu.contains(ui_get(lotus.antiaim.exploits), "Enable Rolling")
        if enable then roll_handler(h) end -- > Enable Roll
    end,

    paint_ui = function()
        visible_handler() --> Menu

        local dynamic = menu.contains(ui_get(lotus.antiaim.exploits), "Dynamic Antiaim")

        local dynamic_fov = menu.contains(ui_get(lotus.rages.main), "Dynamic fov")
        if dynamic_fov then
        local fov = { min = ui_get(lotus.rages.min_fov), max = ui_get(lotus.rages.max_fov), factor = ui_get(lotus.rages.scaling)}
        dynamicfov_logic(fov.min, fov.max, fov.factor) end  -- > Dynamic FOV

        local logs = menu.contains(ui_get(lotus.visuals.main), "Logs")
        if logs then paint_log.main() end

        local debugger = ui_get(lotus.antiaim.debugger) and dynamic
        if debugger then antiaim_lib.freestanding(ui_get(lotus.antiaim.detect_range), true) end -- > Debug

        local indicator = menu.contains(ui_get(lotus.visuals.main), "Status Netgraph")
        if indicator then indicator_handler() end --> Main Indicator

        local scope = menu.contains(ui_get(lotus.visuals.main), "Better Scope visuals")
        if scope then scoped_visuals() end --> Scope Visuals
        
        local keybind = not menu.contains(ui_get(lotus.visuals.net_graph), "Disable Keybinds") and indicator
        if keybind then keybinds() end --> Keybinds    

        local feature = menu.contains(ui_get(lotus.visuals.main), "Features Indicator")

        local bodyyaw = menu.contains(ui_get(lotus.visuals.ind_menu), "Body yaw Indicator") and feature
        if bodyyaw then bodyyaw_indicator() end --> Bodyyaw Indicator

        local Vanillia = menu.contains(ui_get(lotus.visuals.ind_menu), "Vanillia Skeet Indicator") and feature
        if Vanillia then vanilla() end --> Vanillia Indicator

        local Autofire = menu.contains(ui_get(lotus.rages.main), "Dynamic Auto Fire")
        if Autofire then ui_set(references.autofire, ui_get(lotus.rages.autofire)) end --> Auto Fire

        local Autowall = menu.contains(ui_get(lotus.rages.main), "Dynamic Auto Wall")
        if Autowall then ui_set(references.autowall, ui_get(lotus.rages.autowall)) end --> Auto Wall

        local resolver = menu.contains(ui_get(lotus.antiaim.exploits), "\aB6B665FFRoll/Manual resolver")
        if resolver then resolver_indicator() end
    end,

    aim_miss = function(shot)
        logs.on_aim_miss(shot)
    end,

    player_hurt = function(shot)
        logs.on_player_hurt(shot)
    end,

    bullet_impact = function(shot)
        logs.miss_brute(shot)
    end,

    cache_fire = function()
        vars.fire = true
        client_delay_call(0.8, function()
            vars.fire = false
        end)
    end,    

    shutdown = function()
        vanila_skeet_element(true)
        vanila_fakelag_element(true)
        setSpeed(450)
        if cvar.sv_maxusrcmdprocessticks:get_int() then client.set_cvar("sv_maxusrcmdprocessticks", "16") end -- > Reset Valve Bypass
    end
}

visible_handler()
vanila_fakelag_element(true)
local disable = true

local function main_visible(visible)
    ui_set_visible(lotus.antiaim.exploits, visible)
    ui_set_visible(lotus.rages.main, visible)
    ui_set_visible(lotus.visuals.main, visible)
end

main_visible(false)
local function initialize()
    disable = false
    vanila_skeet_element(false)
    vanila_fakelag_element(false)
    client.set_event_callback("run_command", callbacks.run_command)
    client.set_event_callback("setup_command", callbacks.setup_command)
    client.set_event_callback("net_update_start", callbacks.update_player_net_end)
    client.set_event_callback("paint_ui", callbacks.paint_ui)
    client.set_event_callback("aim_miss", callbacks.aim_miss)
    client.set_event_callback("player_hurt", callbacks.player_hurt)
    client.set_event_callback("bullet_impact", callbacks.bullet_impact)
    client.set_event_callback("shutdown", callbacks.shutdown)
    client.set_event_callback("aim_fire", callbacks.cache_fire)
    main_visible(true)
end


initialize()