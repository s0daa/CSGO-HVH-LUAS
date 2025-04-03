local ffi = require("ffi") or error('Allow unsafe scripts')
local vector = require("vector")
local bit = require("bit")
local images = require("gamesense/images") or error('Missing https://gamesense.pub/forums/viewtopic.php?id=22917')
local steamworks = require("gamesense/steamworks") or error('Missing https://gamesense.pub/forums/viewtopic.php?id=26526')
local js = panorama.open()
local http = require("gamesense/http")
local base64 = require "gamesense/base64" or error('Missing https://gamesense.pub/forums/viewtopic.php?id=21619')
local csgo_weapons = require("gamesense/csgo_weapons")
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ent = require("gamesense/entity")
local easing = require("gamesense/easing")
local tween=(function()local a={}local b,c,d,e,f,g,h=math.pow,math.sin,math.cos,math.pi,math.sqrt,math.abs,math.asin;local function i(j,k,l,m)return l*j/m+k end;local function n(j,k,l,m)return l*b(j/m,2)+k end;local function o(j,k,l,m)j=j/m;return-l*j*(j-2)+k end;local function p(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,2)+k end;return-l/2*((j-1)*(j-3)-1)+k end;local function q(j,k,l,m)if j<m/2 then return o(j*2,k,l/2,m)end;return n(j*2-m,k+l/2,l/2,m)end;local function r(j,k,l,m)return l*b(j/m,3)+k end;local function s(j,k,l,m)return l*(b(j/m-1,3)+1)+k end;local function t(j,k,l,m)j=j/m*2;if j<1 then return l/2*j*j*j+k end;j=j-2;return l/2*(j*j*j+2)+k end;local function u(j,k,l,m)if j<m/2 then return s(j*2,k,l/2,m)end;return r(j*2-m,k+l/2,l/2,m)end;local function v(j,k,l,m)return l*b(j/m,4)+k end;local function w(j,k,l,m)return-l*(b(j/m-1,4)-1)+k end;local function x(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,4)+k end;return-l/2*(b(j-2,4)-2)+k end;local function y(j,k,l,m)if j<m/2 then return w(j*2,k,l/2,m)end;return v(j*2-m,k+l/2,l/2,m)end;local function z(j,k,l,m)return l*b(j/m,5)+k end;local function A(j,k,l,m)return l*(b(j/m-1,5)+1)+k end;local function B(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,5)+k end;return l/2*(b(j-2,5)+2)+k end;local function C(j,k,l,m)if j<m/2 then return A(j*2,k,l/2,m)end;return z(j*2-m,k+l/2,l/2,m)end;local function D(j,k,l,m)return-l*d(j/m*e/2)+l+k end;local function E(j,k,l,m)return l*c(j/m*e/2)+k end;local function F(j,k,l,m)return-l/2*(d(e*j/m)-1)+k end;local function G(j,k,l,m)if j<m/2 then return E(j*2,k,l/2,m)end;return D(j*2-m,k+l/2,l/2,m)end;local function H(j,k,l,m)if j==0 then return k end;return l*b(2,10*(j/m-1))+k-l*0.001 end;local function I(j,k,l,m)if j==m then return k+l end;return l*1.001*(-b(2,-10*j/m)+1)+k end;local function J(j,k,l,m)if j==0 then return k end;if j==m then return k+l end;j=j/m*2;if j<1 then return l/2*b(2,10*(j-1))+k-l*0.0005 end;return l/2*1.0005*(-b(2,-10*(j-1))+2)+k end;local function K(j,k,l,m)if j<m/2 then return I(j*2,k,l/2,m)end;return H(j*2-m,k+l/2,l/2,m)end;local function L(j,k,l,m)return-l*(f(1-b(j/m,2))-1)+k end;local function M(j,k,l,m)return l*f(1-b(j/m-1,2))+k end;local function N(j,k,l,m)j=j/m*2;if j<1 then return-l/2*(f(1-j*j)-1)+k end;j=j-2;return l/2*(f(1-j*j)+1)+k end;local function O(j,k,l,m)if j<m/2 then return M(j*2,k,l/2,m)end;return L(j*2-m,k+l/2,l/2,m)end;local function P(Q,R,l,m)Q,R=Q or m*0.3,R or 0;if R<g(l)then return Q,l,Q/4 end;return Q,R,Q/(2*e)*h(l/R)end;local function S(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m;if j==1 then return k+l end;Q,R,T=P(Q,R,l,m)j=j-1;return-(R*b(2,10*j)*c((j*m-T)*2*e/Q))+k end;local function U(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m;if j==1 then return k+l end;Q,R,T=P(Q,R,l,m)return R*b(2,-10*j)*c((j*m-T)*2*e/Q)+l+k end;local function V(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m*2;if j==2 then return k+l end;Q,R,T=P(Q,R,l,m)j=j-1;if j<0 then return-0.5*R*b(2,10*j)*c((j*m-T)*2*e/Q)+k end;return R*b(2,-10*j)*c((j*m-T)*2*e/Q)*0.5+l+k end;local function W(j,k,l,m,R,Q)if j<m/2 then return U(j*2,k,l/2,m,R,Q)end;return S(j*2-m,k+l/2,l/2,m,R,Q)end;local function X(j,k,l,m,T)T=T or 1.70158;j=j/m;return l*j*j*((T+1)*j-T)+k end;local function Y(j,k,l,m,T)T=T or 1.70158;j=j/m-1;return l*(j*j*((T+1)*j+T)+1)+k end;local function Z(j,k,l,m,T)T=(T or 1.70158)*1.525;j=j/m*2;if j<1 then return l/2*j*j*((T+1)*j-T)+k end;j=j-2;return l/2*(j*j*((T+1)*j+T)+2)+k end;local function _(j,k,l,m,T)if j<m/2 then return Y(j*2,k,l/2,m,T)end;return X(j*2-m,k+l/2,l/2,m,T)end;local function a0(j,k,l,m)j=j/m;if j<1/2.75 then return l*7.5625*j*j+k end;if j<2/2.75 then j=j-1.5/2.75;return l*(7.5625*j*j+0.75)+k elseif j<2.5/2.75 then j=j-2.25/2.75;return l*(7.5625*j*j+0.9375)+k end;j=j-2.625/2.75;return l*(7.5625*j*j+0.984375)+k end;local function a1(j,k,l,m)return l-a0(m-j,0,l,m)+k end;local function a2(j,k,l,m)if j<m/2 then return a1(j*2,0,l,m)*0.5+k end;return a0(j*2-m,0,l,m)*0.5+l*.5+k end;local function a3(j,k,l,m)if j<m/2 then return a0(j*2,k,l/2,m)end;return a1(j*2-m,k+l/2,l/2,m)end;a.easing={linear=i,inQuad=n,outQuad=o,inOutQuad=p,outInQuad=q,inCubic=r,outCubic=s,inOutCubic=t,outInCubic=u,inQuart=v,outQuart=w,inOutQuart=x,outInQuart=y,inQuint=z,outQuint=A,inOutQuint=B,outInQuint=C,inSine=D,outSine=E,inOutSine=F,outInSine=G,inExpo=H,outExpo=I,inOutExpo=J,outInExpo=K,inCirc=L,outCirc=M,inOutCirc=N,outInCirc=O,inElastic=S,outElastic=U,inOutElastic=V,outInElastic=W,inBack=X,outBack=Y,inOutBack=Z,outInBack=_,inBounce=a1,outBounce=a0,inOutBounce=a2,outInBounce=a3}local function a4(a5,a6,a7)a7=a7 or a6;local a8=getmetatable(a6)if a8 and getmetatable(a5)==nil then setmetatable(a5,a8)end;for a9,aa in pairs(a6)do if type(aa)=="table"then a5[a9]=a4({},aa,a7[a9])else a5[a9]=a7[a9]end end;return a5 end;local function ab(ac,ad,ae)ae=ae or{}local af,ag;for a9,ah in pairs(ad)do af,ag=type(ah),a4({},ae)table.insert(ag,tostring(a9))if af=="number"then assert(type(ac[a9])=="number","Parameter '"..table.concat(ag,"/").."' is missing from subject or isn't a number")elseif af=="table"then ab(ac[a9],ah,ag)else assert(af=="number","Parameter '"..table.concat(ag,"/").."' must be a number or table of numbers")end end end;local function ai(aj,ac,ad,ak)assert(type(aj)=="number"and aj>0,"duration must be a positive number. Was "..tostring(aj))local al=type(ac)assert(al=="table"or al=="userdata","subject must be a table or userdata. Was "..tostring(ac))assert(type(ad)=="table","target must be a table. Was "..tostring(ad))assert(type(ak)=="function","easing must be a function. Was "..tostring(ak))ab(ac,ad)end;local function am(ak)ak=ak or"linear"if type(ak)=="string"then local an=ak;ak=a.easing[an]if type(ak)~="function"then error("The easing function name '"..an.."' is invalid")end end;return ak end;local function ao(ac,ad,ap,aq,aj,ak)local j,k,l,m;for a9,aa in pairs(ad)do if type(aa)=="table"then ao(ac[a9],aa,ap[a9],aq,aj,ak)else j,k,l,m=aq,ap[a9],aa-ap[a9],aj;ac[a9]=ak(j,k,l,m)end end end;local ar={}local as={__index=ar}function ar:set(aq)assert(type(aq)=="number","clock must be a positive number or 0")self.initial=self.initial or a4({},self.target,self.subject)self.clock=aq;if self.clock<=0 then self.clock=0;a4(self.subject,self.initial)elseif self.clock>=self.duration then self.clock=self.duration;a4(self.subject,self.target)else ao(self.subject,self.target,self.initial,self.clock,self.duration,self.easing)end;return self.clock>=self.duration end;function ar:reset()return self:set(0)end;function ar:update(at)assert(type(at)=="number","dt must be a number")return self:set(self.clock+at)end;function a.new(aj,ac,ad,ak)ak=am(ak)ai(aj,ac,ad,ak)return setmetatable({duration=aj,subject=ac,target=ad,easing=ak,clock=0},as)end;return a end)();
local discord = require("gamesense/discord_webhooks")
local obex_data = obex_fetch and obex_fetch() or {username = 'Lanzer', build = 'Source', discord=''}
local user = {
    USER = obex_data.username:lower(),
    CUR_BUILD = "2.5.2",
    VER = obex_data.build:lower(),
}
local angelwings = {}
angelwings.handlers = {}
angelwings.database = ":angelwings::configs:"
angelwings.presets = {}

local bit_band, client_camera_angles, client_color_log, client_create_interface, client_delay_call, client_exec, client_eye_position, client_key_state, client_log, client_random_int, client_scale_damage, client_screen_size, client_set_event_callback, client_trace_bullet, client_userid_to_entindex, database_read, database_write, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_enemy, math_abs, math_atan2, require, error, globals_absoluteframetime, globals_curtime, globals_realtime, math_atan, math_cos, math_deg, math_floor, math_max, math_min, math_rad, math_sin, math_sqrt, print, renderer_circle_outline, renderer_gradient, renderer_measure_text, renderer_rectangle, renderer_text, renderer_triangle, string_find, string_gmatch, string_gsub, string_lower, table_insert, table_remove, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_hotkey, ui_new_multiselect, ui_reference, tostring, ui_is_menu_open, ui_mouse_position, ui_new_combobox, ui_new_slider, ui_set, ui_set_callback, ui_set_visible, tonumber, pcall = bit.band, client.camera_angles, client.color_log, client.create_interface, client.delay_call, client.exec, client.eye_position, client.key_state, client.log, client.random_int, client.scale_damage, client.screen_size, client.set_event_callback, client.trace_bullet, client.userid_to_entindex, database.read, database.write, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_enemy, math.abs, math.atan2, require, error, globals.absoluteframetime, globals.curtime, globals.realtime, math.atan, math.cos, math.deg, math.floor, math.max, math.min, math.rad, math.sin, math.sqrt, print, renderer.circle_outline, renderer.gradient, renderer.measure_text, renderer.rectangle, renderer.text, renderer.triangle, string.find, string.gmatch, string.gsub, string.lower, table.insert, table.remove, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_hotkey, ui.new_multiselect, ui.reference, tostring, ui.is_menu_open, ui.mouse_position, ui.new_combobox, ui.new_slider, ui.set, ui.set_callback, ui.set_visible, tonumber, pcall
local ui_menu_position, ui_menu_size, math_pi, renderer_indicator, entity_is_dormant, client_set_clan_tag, client_trace_line, entity_get_all, entity_get_classname = ui.menu_position, ui.menu_size, math.pi, renderer.indicator, entity.is_dormant, client.set_clan_tag, client.trace_line, entity.get_all, entity.get_local_player
local entity_get_player_weapon, entity_get_local_player, entity_get_classname, entity_get_prop, entity_get_all, math_sqrt = entity.get_player_weapon, entity.get_local_player, entity.get_classname, entity.get_prop, entity.get_all, math.sqrt

local screen = {client.screen_size()}
local center = {screen[1]/2, screen[2]/2}

ffi.cdef[[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]
local angle3d_struct = ffi.typeof("struct { float pitch; float yaw; float roll; }")
local vec_struct = ffi.typeof("struct { float x; float y; float z; }")
local cUserCmd =
    ffi.typeof(
    [[
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
        bool send_packet; 
    }
    ]],
    angle3d_struct,
    vec_struct,
    angle3d_struct,
    vec_struct
)
local client_sig = client.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85") or error("client.dll!:input not found.")
local get_cUserCmd = ffi.typeof("$* (__thiscall*)(uintptr_t ecx, int nSlot, int sequence_number)", cUserCmd)
local input_vtbl = ffi.typeof([[struct{uintptr_t padding[8];$ GetUserCmd;}]],get_cUserCmd)
local input = ffi.typeof([[struct{$* vfptr;}*]], input_vtbl)
local get_input = ffi.cast(input,ffi.cast("uintptr_t**",tonumber(ffi.cast("uintptr_t", client_sig)) + 1)[0])
local VGUI_System010 =  client_create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )
local gamerules_ptr = client.find_signature( "client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1" )
local gamerules = ffi.cast( "intptr_t**", ffi.cast( "intptr_t", gamerules_ptr) + 2)[ 0 ]
local get_clipboard_text_count = ffi.cast( "get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid" )
local set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid" )
local get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid" )

local function clip_import()
  	local clipboard_text_length = get_clipboard_text_count( VGUI_System )
	local clipboard_data = ""

	if clipboard_text_length > 0 then
		buffer = ffi.new("char[?]", clipboard_text_length)
		size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)
		get_clipboard_text( VGUI_System, 0, buffer, size )

		clipboard_data = ffi.string( buffer, clipboard_text_length-1 )
	end
	return clipboard_data
end

local function clip_export(string)
	if string then
		set_clipboard_text(VGUI_System, string, string:len())
	end
end

local return_fl = return_fl
local is_valve_ds_spoofed = 0
angelwings.refs = {}
angelwings.refs.aa = {}
angelwings.refs.aa.enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled")
angelwings.refs.aa.pitch, angelwings.refs.aa.pitch_slider = ui.reference("AA", "Anti-aimbot angles", "Pitch")
angelwings.refs.aa.yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
angelwings.refs.aa.yaw, angelwings.refs.aa.yaw_offset = ui.reference("AA", "Anti-aimbot angles", "Yaw")
angelwings.refs.aa.yaw_jitter, angelwings.refs.aa.yaw_jitter_offset = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
angelwings.refs.aa.body_yaw, angelwings.refs.aa.body_yaw_offset = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
angelwings.refs.aa.body_yaw_fs = ui_reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw')
angelwings.refs.aa.roll = ui.reference("AA", "Anti-aimbot angles", "Roll")
angelwings.refs.aa.edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge Yaw")
angelwings.refs.aa.freestanding, angelwings.refs.aa.freestanding_hk = ui.reference("AA", "Anti-aimbot angles", "Freestanding")

local ref = {
    SlowMotion = { ui.reference("AA", "Other", "Slow motion") },
    LegMovement = ui.reference("AA", "Other", "Leg movement"),
    FL = ui.reference("AA", "Fake lag", "Limit"),
    FLenb = ui.reference("AA", "Fake lag", "Enabled"),
    SafePoint = ui.reference("Rage", "Aimbot", "Force safe point"),
    FD = ui.reference("Rage", "Other", "Duck peek assist"),
    DT = {ui.reference("Rage", "Aimbot", "Double Tap")},
    DT_LIM = ui.reference("Rage", "Aimbot", "Double tap fake lag limit"),
    OSAA = {ui.reference("AA", "Other", "On shot anti-aim")},
    QuickPeek = {ui.reference("Rage", "Other", "Quick peek assist")},
    ProcessTicks = ui.reference("Misc", "Settings", "sv_maxusrcmdprocessticks2"),
    HoldAim = ui.reference("Misc", "Settings", "sv_maxusrcmdprocessticks_holdaim"),
    MaxUnlag = ui.reference("MISC", "Settings", "sv_maxunlag2"),
    AUT = ui.reference("Misc","Settings","Anti-Untrusted"),
    Tag = ui.reference("Misc", "Miscellaneous", "Clan tag spammer"),
    Ping = {ui.reference("Misc", "Miscellaneous", "Ping spike")},
    AccuracyBoost = ui.reference("Rage", "Other", "Accuracy boost"),
    MinDmg = ui.reference("Rage", "Aimbot", "Minimum damage"),
    AirStrafe = ui.reference("Misc", "Movement", "Air strafe"),
    Ind = ui.reference("Visuals", "Other ESP", "Feature indicators"),
}

local og_menu = function(x)
    for k, v in pairs(angelwings.refs.aa) do
        ui.set_visible(v, x)
    end
end

local includes = function(table, key)
    local state = false
    for i=1, #table do
        if table[i] == key then
            state = true
            break 
        end
    end
    return state
end

angelwings.handlers = {
    aa = {
        state = {}
    },
    visuals = {},
    misc = {}
}

angelwings.handlers.ui = {
    elements = {},
    config = {},
}

angelwings.handlers.ui.new = function(element, condition, config, callback)
    condition = condition or true
    config = config or false
    callback = callback or function() end

    local update = function()
        for k, v in pairs(angelwings.handlers.ui.elements) do
            if type(v.condition) == "function" then
                ui.set_visible(v.element, v.condition())
            else
                ui.set_visible(v.element, v.condition)
            end
        end
    end

    table.insert(angelwings.handlers.ui.elements, { element = element, condition = condition})

    if config then
        table.insert(angelwings.handlers.ui.config, element)
    end

    ui.set_callback(element, function(value)
        update()
        callback(value)
    end)

    update()

    return element
end

local notify = {
    storage = {},
    max = 4,
}
notify.__index = notify
local icon = images.get_panorama_image("icons/ui/warningdark.svg")

notify.queue_bottom = function()
    if #notify.storage <= notify.max then
        return 0
    end
    return #notify.storage - notify.max
end
notify.clear_bottom = function()
    for i=1, notify.queue_bottom() do
        table.remove(notify.storage, #notify.storage)
    end
end

notify.new_bottom = function(timeout, color, title, ...)
    table.insert(notify.storage, {
        started = false,
        instance = setmetatable({
            ["active"]  = false,
            ["timeout"] = timeout,
            ["color"]   = { r = color[1], g = color[2], b = color[3], a = 0 },
            ["recta"]   = 0,
            ["x"]       = screen[1]/2,
            ["y"]       = screen[2],
            ["text"]    = {...},
            ["title"]   = title,
        }, notify)
    })
end

angelwings.ui = {
    aa = {},
    builder_states = {"Global", "Stand", "Move", "Slowmotion", "Air", "Air+", "Duck", "Duck+", "Freestand", "Defensive", "On Key"},
    builder = {},
    visuals = {},
    misc = {},
    config = {},
    tab = {},
}

angelwings.ui.aa.master = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFB0B0FFangelwings.pink"))
angelwings.ui.tab = angelwings.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\nTab", { "Anti-Aim", "Builder", "Visuals", "Misc", "Config" }), function() return ui.get(angelwings.ui.aa.master);end)
angelwings.ui.aa.aa_misc = angelwings.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "\aFADADDFFAA \aFADADDFFExtras", {"Safe Knife", "Static Manuals","HS Fix"}), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim"; end, true)
angelwings.ui.aa.roll = angelwings.handlers.ui.new(ui.new_checkbox('AA', 'Anti-aimbot angles', '\aFADADDFF» Roll'), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim"; end)
angelwings.ui.aa.roll_hk = angelwings.handlers.ui.new(ui.new_hotkey('AA', 'Anti-aimbot angles', '\aFADADDFF» Roll', true), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim"; end)
angelwings.ui.aa.roll_multi = angelwings.handlers.ui.new(ui.new_multiselect('AA', 'Anti-aimbot angles', "\aFADADDFFRoll Options", "Only manual", "Reduce angle", "\af20f0fffBypass ValveDS"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim" and ui.get(angelwings.ui.aa.roll); end)
angelwings.ui.aa.edge_check = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Edge"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim"; end)
angelwings.ui.aa.edge_hk = angelwings.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", "\aFADADDFF» Edge", true), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim"; end)
angelwings.ui.aa.fs_check = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Freestand"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim"; end, true)
angelwings.ui.aa.fs_hk = angelwings.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", "\aFADADDFF» Freestand", true), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim"; end)
angelwings.ui.aa.fs_multi = angelwings.handlers.ui.new(ui.new_multiselect('AA', 'Anti-aimbot angles', "\aFADADDFFFS \aFADADDFFAvoid Conditions", "Slowmotion", "Air", "Duck", "Fake Duck", "Manual", "Defensive" ), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim" and ui.get(angelwings.ui.aa.fs_check); end, true)
angelwings.ui.aa.manual_check = angelwings.handlers.ui.new(ui.new_checkbox('AA', 'Anti-aimbot angles', '\aFADADDFF» Manual AA'), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim"; end, true)
angelwings.ui.aa.manual_left = angelwings.handlers.ui.new(ui.new_hotkey('AA', 'Anti-aimbot angles', '\aFADADDFFLeft'), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim" and ui.get(angelwings.ui.aa.manual_check); end)
angelwings.ui.aa.manual_right = angelwings.handlers.ui.new(ui.new_hotkey('AA', 'Anti-aimbot angles', '\aFADADDFFRight'), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim" and ui.get(angelwings.ui.aa.manual_check); end)
angelwings.ui.aa.manual_back = angelwings.handlers.ui.new(ui.new_hotkey('AA', 'Anti-aimbot angles', '\aFADADDFFBack'), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim" and ui.get(angelwings.ui.aa.manual_check); end)
angelwings.ui.aa.manual_forward = angelwings.handlers.ui.new(ui.new_hotkey('AA', 'Anti-aimbot angles', '\aFADADDFFForward'), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim" and ui.get(angelwings.ui.aa.manual_check); end)
angelwings.ui.aa.manual_reset = angelwings.handlers.ui.new(ui.new_hotkey('AA', 'Anti-aimbot angles', '\aFADADDFFReset Hotkey'), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Anti-Aim" and ui.get(angelwings.ui.aa.manual_check); end)

angelwings.ui.builder.state = angelwings.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aFADADDFFState", angelwings.ui.builder_states), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder"; end)
angelwings.ui.builder.states = {}
angelwings.ui.builder.state_save = "Global"

angelwings.ui.visuals.indicators = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Indicators"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Visuals"; end, true)
angelwings.ui.visuals.color1 = angelwings.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "\n Name color", 215, 185, 238, 255), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Visuals" and ui.get(angelwings.ui.visuals.indicators); end)
angelwings.ui.visuals.darkness = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFDarkness", 0, 255, 0), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Visuals" and ui.get(angelwings.ui.visuals.indicators); end, true)
angelwings.ui.visuals.ind_multi = angelwings.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "\n Indicators Multi", {"STATE", "DT", "FS", "HIDE", "BAIM", "PING"}), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Visuals" and ui.get(angelwings.ui.visuals.indicators); end, true)
angelwings.ui.visuals.tracer_check = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Bullet tracers"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Visuals"; end)
angelwings.ui.visuals.tracer_color = angelwings.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "TracerColor", 255, 255, 255, 255), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Visuals"; end)
angelwings.ui.visuals.watermark_check = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Watermark"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Visuals"; end, true)
angelwings.ui.visuals.watermark_color = angelwings.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "\n WaterColor", 215, 185, 238, 255), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Visuals"; end)
angelwings.ui.visuals.ts_check = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Arrows"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Visuals"; end, true)
angelwings.ui.visuals.ts_manual_color = angelwings.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "Manual Color", 215, 185, 238, 255), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Visuals" and ui.get(angelwings.ui.visuals.ts_check); end)

angelwings.ui.misc.autodt = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Auto DT Discharge"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Misc"; end, true)
angelwings.ui.misc.autodt_hk = angelwings.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", "\aFADADDFF» Auto DT Discharge", true), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Misc"; end)
angelwings.ui.misc.fastladder = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Fast ladder"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Misc"; end)
angelwings.ui.misc.anim_breakers = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Anim Breaker"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Misc"; end, true)
angelwings.ui.misc.anim_breakers_combo = angelwings.handlers.ui.new(ui.new_multiselect("AA", "Anti-aimbot angles", "\n anim breakers", {"Static Legs", "In Air", "On Land", "Leg Fucker", "Allah Legs", "Haram Legs"}), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Misc" and ui.get(angelwings.ui.misc.anim_breakers); end, true)
angelwings.ui.misc.abs = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Anti Backstab"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Misc"; end, true)
angelwings.ui.misc.abs_slider = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFDistance",0,300,150,true,"u"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Misc" and ui.get(angelwings.ui.misc.abs); end, true)
angelwings.ui.misc.jumpscout = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Jumpscout"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Misc"; end, true)
angelwings.ui.misc.teleport_fix = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» TP fix"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Misc"; end, true)
angelwings.ui.misc.clantag = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Clantag"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Misc"; end, true)
angelwings.ui.misc.killsay = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFF» Kill Spam"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Misc"; end, true)

angelwings.ui.config.list = angelwings.handlers.ui.new(ui.new_listbox("AA", "Anti-aimbot angles", "Configs", ""), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Config"; end)
angelwings.ui.config.configname = angelwings.handlers.ui.new(ui.new_textbox("AA", "Anti-aimbot angles", "Config name", ""), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Config"; end)
angelwings.ui.config.load = angelwings.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\a9ED8FFFFLoad", function() end), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Config"; end)
angelwings.ui.config.save = angelwings.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\a9ED8FFFFSave", function() end), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Config"; end)
angelwings.ui.config.delete = angelwings.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\a9ED8FFFFDelete", function() end), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Config"; end)
angelwings.ui.config.import = angelwings.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\a9ED8FFFFImport settings", function() end), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Config"; end)
angelwings.ui.config.export = angelwings.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\a9ED8FFFFExport settings", function() end), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Config"; end)
angelwings.ui.config.share = angelwings.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "\a9ED8FFFFShare settings", function() end), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Config"; end)

local function bootstrap()
    notify.new_bottom(5, {ui.get(angelwings.ui.visuals.color1)}, "Angelwings", "Welcome", user.USER)
    notify.new_bottom(5, {ui.get(angelwings.ui.visuals.color1)}, "Angelwings", "Loaded", "Angelwings", "build", user.VER , "ver.", user.CUR_BUILD)
end
bootstrap()

local var = {
    in_use = false,
    def = false,
    bomb_distance = 0,
    last_press_t = 0,
    dir = "reset",
    fs = false,
    edge = false,
    plant_eq = false,
    last_time = globals.curtime(),
    anti_aim_right = 0,
    flip = 1,
    classnames = {"CWorld","CCSPlayer","CFuncBrush"},
    granade = false,
    knife = false,
    best_value = 0,
    best_roll = 90,
    best_desync = -141,
    best_desync_r = 141,
    untrusted = false,
    roll = false,
    shot_timer = 0,
    ground_ticks = 1,
    end_time = 0,
    queuet = {},
    can_shoot = false,
    timer = globals.curtime(),
    tick_delay = 0,
    aa_state = 'stand',
    hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' },
    shot_tick = 0,
    breaker_ticks = 0,
    chokedcommands = 0,
    discharge = 0,
    scope_fraction = 0,
    frac = 0,
    fl_shot_param = false,
    dt_shot_param = false,
    anim_left = 0,
    anim_right = 0,
    defensive = false,
    defensive_sim = 0,
    defensive_prev_sim = 0,
    defensive_ticks = 0,
    update_dt = 0,
}

for k, x in pairs(angelwings.ui.builder_states) do
    angelwings.ui.builder.states[x] = {}
    angelwings.ui.builder.states[x].check = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFFEnable ".."\aFADADDFF"..tostring(x).. " \aFADADDFFcondition"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x and x ~= "Global"; end, true)
    angelwings.ui.builder.states[x].check_hk = angelwings.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", "\aFADADDFFEnable HK"..tostring(x), true), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x and x == "On Key"; end)
    angelwings.ui.builder.states[x].force_defensive = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFFForce \aFADADDFFDefensive \n"..tostring(x)), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x and x ~= "Defensive"; end, true)
    angelwings.ui.builder.states[x].pitch = angelwings.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aFADADDFFPitch \n"..tostring(x), {"Off", "Default", "Up", "Custom"}), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].pitch_slider = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\n Custom Pitch Slider"..tostring(x), -89, 89, 89, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x and ui.get(angelwings.ui.builder.states[x].pitch) == "Custom"; end, true)
    angelwings.ui.builder.states[x].yawcombo = angelwings.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aFADADDFFYaw \n"..tostring(x), {"Off", "180", "180 Z", "Spin", "Directional"}), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].yaw_slider = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\n"..tostring(x).."Yaw Slider", -180, 180, 0, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x and (ui.get(angelwings.ui.builder.states[x].yawcombo) ~= "Off" and ui.get(angelwings.ui.builder.states[x].yawcombo) ~= "Directional"); end, true)
    angelwings.ui.builder.states[x].yaw_slider_left = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFLeft \aFADADDFFadd \n"..tostring(x), -60, 60, 0, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x and ui.get(angelwings.ui.builder.states[x].yawcombo) == "Directional"; end, true)
    angelwings.ui.builder.states[x].yaw_slider_right = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFRight \aFADADDFFadd \n"..tostring(x), -60, 60, 0, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x and ui.get(angelwings.ui.builder.states[x].yawcombo) == "Directional"; end, true)
    angelwings.ui.builder.states[x].yaw_jitter = angelwings.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aFADADDFFYaw \aFADADDFFJitter \n"..tostring(x), {"Off", "Offset","Center","Random","3 way", "Single", "Circle"}), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].jitter_way_1 = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFFirst \aFADADDFFMeta Way\n"..tostring(x), -180, 180, 0, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "3 way" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].jitter_way_2 = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFSecond \aFADADDFFMeta Way\n"..tostring(x), -180, 180, 0, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "3 way" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].jitter_way_3 = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFThird \aFADADDFFMeta Way\n"..tostring(x), -180, 180, 0, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "3 way" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].fl_jitter = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFFL \aFADADDFFJitter\n"..tostring(x), -180, 180, 0, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "3 way" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].jitter_min = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFMin \aFADADDFFJitter \n"..tostring(x), 0, 90, 0, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and (ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "Single" or ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "Circle" ) and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].jitter_max = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFMax \aFADADDFFJitter \n"..tostring(x), 0, 90, 0, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and (ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "Single" or ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "Circle") and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].jitter_delay = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFDelay \n"..tostring(x), 0, 20, 0, true, "ms"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and (ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "Single" or ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "Circle") and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].jitter_slider = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\nJitterSlider "..tostring(x), -180, 180, 0, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and not (ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "Single" or ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "Circle" or ui.get(angelwings.ui.builder.states[x].yaw_jitter) == "3 way") and ui.get(angelwings.ui.builder.states[x].yaw_jitter) ~= "Off" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].body_yaw = angelwings.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aFADADDFFBody \aFADADDFFYaw \n"..tostring(x), {"Off", "Static", "Opposite","Jitter"}), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].body_yaw_slider = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\nBodySlider "..tostring(x), -180, 180, 0, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.states[x].body_yaw) ~= "Off" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].body_yaw_fs = angelwings.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\aFADADDFFFreestanding body \aFADADDFFYaw \n"..tostring(x)), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].fake_custom = angelwings.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aFADADDFFCustom \aFADADDFFfake \n"..tostring(x), {"Off", "Jitter","Static","Directional"}), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].fake_custom_slider = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\nFake Yaw Limit "..tostring(x), 0, 60, 60, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.states[x].fake_custom) ~= "Off" and ui.get(angelwings.ui.builder.states[x].fake_custom) ~= "Directional" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].fake_slider_left = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFLeft \aFADADDFFfake \n"..tostring(x), 0, 60, 60, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.states[x].fake_custom) == "Directional" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].fake_slider_right = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFRight \aFADADDFFfake \n"..tostring(x), 0, 60, 60, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.states[x].fake_custom) == "Directional" and ui.get(angelwings.ui.builder.state) == x; end, true)
    angelwings.ui.builder.states[x].roll_slider = angelwings.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aFADADDFFRoll \n"..tostring(x), -50, 50, 0, true, "°"), function() return ui.get(angelwings.ui.aa.master) and ui.get(angelwings.ui.tab) == "Builder" and ui.get(angelwings.ui.builder.state) == x; end, true)
end

local notification = { }

local helper = {
    lerp = function(self, time, a, b)
        return a * (1-time) + b * time
    end,

    get_velocity = function(self,player)
        local x,y,z = entity.get_prop(player, "m_vecVelocity")
        if x == nil then return end
        return math.sqrt(x*x + y*y + z*z)
    end,

    angle_to_vec = function(self,pitch, yaw)
        local p, y = math.rad(pitch), math.rad(yaw)
        local sp, cp, sy, cy = math.sin(p), math.cos(p), math.sin(y), math.cos(y)
        return cp*cy, cp*sy, -sp
    end,

    vec3_dot = function(self,ax, ay, az, bx, by, bz)
        return ax*bx + ay*by + az*bz
    end,

    vec3_normalize = function(self,x, y, z)
        local len = math.sqrt(x * x + y * y + z * z)
        if len == 0 then
            return 0, 0, 0
        end
        local r = 1 / len
        return x*r, y*r, z*r
    end,

    get_fov_cos = function(self,ent, vx,vy,vz, lx,ly,lz)
        local ox,oy,oz = entity.get_prop(ent, "m_vecOrigin")
	    if ox == nil then
		    return -1
	    end

	    local dx,dy,dz = self:vec3_normalize(ox-vx, oy-vy, oz-vz)
	    return self:vec3_dot(dx,dy,dz, vx,vy,vz)
    end,

    distance3d = function(self, x1, y1, z1, x2, y2, z2)
        return math_sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
    end,

    entity_has_c4 = function(self, ent)
        local bomb = entity_get_all("CC4")[1]
        return bomb ~= nil and entity_get_prop(bomb, "m_hOwnerEntity") == ent
    end,

    normalize_yaw = function(self, yaw)
        while yaw > 180 do yaw = yaw - 360 end
        while yaw < -180 do yaw = yaw + 360 end
        return yaw
    end,

    get_damage = function(self, plocal, enemy, x, y,z)
        local ex = { }
        local ey = { }
        local ez = { }
        ex[0], ey[0], ez[0] = entity_hitbox_position(enemy, 1)
        ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
        ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
        ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
        ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
        ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
        ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
        local ent, dmg = nil, 0
        for i=0, 6 do
            if dmg == 0 or dmg == nil then
                ent, dmg = client_trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
            end
        end
        return ent == nil and client_scale_damage(plocal, 1, dmg) or dmg
    end,

    is_valid = function(self, nn)
        if nn == 0 then
            return false
        end
    
        if not entity_is_alive(nn) then
            return false
        end
    
        if entity_is_dormant(nn) then
            return false
        end
    
        return true
    end,

    get_nearest_enemy = function(self, plocal, enemies)

        local lx, ly, lz = client.eye_position()
        local view_x, view_y, roll = client.camera_angles()

        local bestenemy = nil
        local fov = 180
        for i=1, #enemies do
            local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
            local cur_fov = math_abs(self:normalize_yaw(self:calc_shit(lx - cur_x, ly - cur_y) - view_y + 180))
            if cur_fov < fov then
                fov = cur_fov
                bestenemy = enemies[i]
            end
        end

        return bestenemy
    end,

    calc_angle = function(self, local_x, local_y, enemy_x, enemy_y)
        local ydelta = local_y - enemy_y
        local xdelta = local_x - enemy_x
        local relativeyaw = math_atan( ydelta / xdelta )
        relativeyaw = self:normalize_yaw( relativeyaw * 180 / math_pi )
        if xdelta >= 0 then
            relativeyaw = self:normalize_yaw(relativeyaw + 180)
        end
        return relativeyaw
    end,
    
    calc_shit = function(self, xdelta, ydelta)
        if xdelta == 0 and ydelta == 0 then
            return 0
        end
        
        return math_deg(math_atan2(ydelta, xdelta))
    end,

    time_to_ticks = function(self, time)
        return math.floor(time / globals.tickinterval() + 0.5)
    end,

    time_to_ticks_2 = function(self, time)
        local t_Return = time / globals.tickinterval()
        return math.floor(t_Return)
    end,
    
    ticks_to_time = function(self, ticks)
        local t_Return = globals.tickinterval() * ticks
        return math.floor(t_Return)
    end,

    fade_animation = function(self)
        if interval == nil then
            interval = 0
            modifier = 1.3
        end
    
        interval = interval + (1-modifier) * 0.7 + 0.3
        local textPulsate = math.abs(interval*0.0175 % 2 - 1) * 255
        local fraction = (textPulsate/255)
        local disfraction = math.abs(1-fraction)
    
        return textPulsate, fraction, disfraction
    end,

    gradient_text = function(self, r1, g1, b1, a1, r2, g2, b2, a2, text)
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

    doubletap_charged = function(self)
        if not ui.get(ref.DT[1]) or not ui.get(ref.DT[2])  then
            return false
        end
        if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then
            return
        end
        local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
        if weapon == nil then
            return false
        end
    
        local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
        local jewfag = entity.get_prop(weapon, "m_flNextPrimaryAttack")
        if jewfag == nil then
            return
        end
        local next_primary_attack = jewfag + 0.5
        if next_attack == nil or next_primary_attack == nil then
            return false
        end
        return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
    end,

    measure_text = function(flags, ...)
        local args = {...}
        local string = table.concat(args, "")
    
        return vector(renderer.measure_text(flags, string))
    end,

    clamp_ind = function(self, val, lower, upper)
        if lower > upper then 
            lower = upper
            upper = lower
        end
        return math.max(lower, math.min(upper, val))
    end,
}

local ticks = 0
local aa_state = "Global"
local function player_state()
    local plocal = entity_get_local_player()
    if not plocal then return end
    local vx, vy = entity.get_prop(plocal, 'm_vecVelocity')
    local velocity2d = math.sqrt(vx^2+vy^2)
    local player_standing = velocity2d < 2
    local use = ui.get(angelwings.ui.builder.states["On Key"].check_hk) and not var.def and not var.plant_eq
    local roll_check = ui.get(angelwings.ui.aa.roll) and ui.get(angelwings.ui.aa.roll_hk) and (not includes(ui.get(angelwings.ui.aa.roll_multi), "Only manual") and true or var.dir == "reset")
    local player_duck_peek_assist = ui.get(ref.FD)
    local in_air = bit.band(entity.get_prop(plocal, 'm_fFlags'), 1) == 0
    local on_ground = bit.band(entity.get_prop( entity.get_local_player( ), "m_fFlags"), 1)

    local player_jumping = in_air and not (entity.get_prop(plocal, "m_flDuckAmount") > 0.5)
    local player_crouching = (entity.get_prop(plocal, "m_flDuckAmount") > 0.5 and not player_jumping) or player_duck_peek_assist
    local player_crouch_move = (entity.get_prop(plocal, "m_flDuckAmount") > 0.5 and not player_standing)

    local player_crouch_jump = in_air and entity.get_prop(plocal, "m_flDuckAmount") > 0.5
    local player_slow_motion = ui.get(ref.SlowMotion[1]) and ui.get(ref.SlowMotion[2]) and not player_standing and not player_crouching and not player_jumping
    local defensive = var.defensive
    local freestand = ui.get(angelwings.refs.aa.freestanding_hk) and ui.get(angelwings.refs.aa.freestanding) and (not player_standing and not player_crouching and not player_crouch_move and not roll_check)
    local knife = includes(ui.get(angelwings.ui.aa.aa_misc), "Safe Knife") and var.knife

    if on_ground == 1 then
        ticks = ticks + 1
    else
        ticks = 0
    end

    if use and ui.get(angelwings.ui.builder.states["On Key"].check) then
        var.aa_state = 'on_key'
        aa_state = 'On Key'
        angelwings.ui.builder.state_save = aa_state
        return 'on_key'
    elseif defensive and ui.get(angelwings.ui.builder.states["Defensive"].check) then
        aa_state = 'Defensive'
        var.aa_state = 'defensive'
        angelwings.ui.builder.state_save = aa_state
        return 'defensive'
    elseif freestand and ui.get(angelwings.ui.builder.states["Freestand"].check) then
        var.aa_state = 'freestand'
        aa_state = 'Freestand'
        angelwings.ui.builder.state_save = aa_state
        return 'freestand'
    elseif roll_check and ticks > 8 then
        aa_state = 'Roll'
        var.aa_state = 'roll'
        angelwings.ui.builder.state_save = aa_state
        return 'roll'
    elseif player_slow_motion and ticks > 8 then
        aa_state  = ui.get(angelwings.ui.builder.states["Slowmotion"].check) and "Slowmotion" or "Global"
        var.aa_state = 'slowmotion'
        angelwings.ui.builder.state_save = aa_state
        return 'slowmotion'
    elseif player_crouch_move and ticks > 8 then
        aa_state = ui.get(angelwings.ui.builder.states["Duck+"].check) and "Duck+" or "Global"
        var.aa_state = 'duck+'
        angelwings.ui.builder.state_save = aa_state
        return 'duck+'
    elseif player_crouching and ticks > 8 then
        aa_state = ui.get(angelwings.ui.builder.states["Duck"].check) and "Duck" or "Global"
        var.aa_state = 'duck'
        angelwings.ui.builder.state_save = aa_state
        return 'duck'
    elseif player_jumping then
        aa_state = ui.get(angelwings.ui.builder.states["Air"].check) and knife and "Safe" or ui.get(angelwings.ui.builder.states["Air"].check) and not knife and "Air" or "Global"
        var.aa_state = 'air'
        angelwings.ui.builder.state_save = aa_state
        return 'air'
    elseif player_crouch_jump then
        aa_state = ui.get(angelwings.ui.builder.states["Air+"].check) and knife and "Safe" or ui.get(angelwings.ui.builder.states["Air+"].check) and not knife and "Air+" or "Global"
        var.aa_state = 'air-duck'
        angelwings.ui.builder.state_save = aa_state
        return 'air-duck'
    elseif player_standing and ticks > 8 then
        aa_state = ui.get(angelwings.ui.builder.states["Stand"].check) and "Stand" or "Global"
        var.aa_state = 'stand'
        angelwings.ui.builder.state_save = aa_state
        return 'stand'
    elseif not player_standing and ticks > 8 then
        aa_state = ui.get(angelwings.ui.builder.states["Move"].check) and "Move" or "Global"
        var.aa_state = 'move'
        angelwings.ui.builder.state_save = aa_state
        return 'move'
    else
        aa_state = 'Global'
        angelwings.ui.builder.state_save = aa_state
        return var.aa_state
    end
end

local function side(l,r)
    local body_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    if body_yaw < 0 then
        ui.set(angelwings.refs.aa.yaw_offset, r)
    elseif body_yaw > 0 then
        ui.set(angelwings.refs.aa.yaw_offset, l)
    end

end

local function sidef(l,r)
    local body_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
end

local OldChoke = 0
local toDraw4 = 0
local toDraw3 = 0
local toDraw2 = 0
local toDraw1 = 0
local toDraw0 = 0
local function fakelag_visuals(c)
	if c.chokedcommands < OldChoke then
		toDraw0 = toDraw1
		toDraw1 = toDraw2
		toDraw2 = toDraw3
		toDraw3 = toDraw4
		toDraw4 = OldChoke
	end
	OldChoke = c.chokedcommands
end

local custom_aa = {
    jitteroffset = 0,
    jitterdirection = true,
    yawoffsetl = 0,
    yawoffsetr = 0,
    yawdirectionl = true,
    yawdirectionr = true,
}

local aa_help = {
    use_aa = function(self)
        ui.set(angelwings.refs.aa.pitch, "Off")
        ui.set(angelwings.refs.aa.yaw_base, "Local view")
        ui.set(angelwings.refs.aa.yaw, "180")
        ui.set(angelwings.refs.aa.yaw_offset, 180)
        ui.set(angelwings.refs.aa.yaw_jitter, "Off")
        ui.set(angelwings.refs.aa.yaw_jitter_offset, 0)
        ui.set(angelwings.refs.aa.body_yaw, "Static")
        ui.set(angelwings.refs.aa.body_yaw_offset, -var.best_desync)
        ui.set(angelwings.refs.aa.body_yaw_fs, false)
    end,

    roll_m = function(self)
        local manual = {
            ["right"] = 90,
            ["left"] = -90,
            ["back"] = 0,
            ["forward"] = 180,
        }

        ui.set(angelwings.refs.aa.pitch, "Default")
        ui.set(angelwings.refs.aa.yaw, "180")
        ui.set(angelwings.refs.aa.yaw_jitter, "Off")
        ui.set(angelwings.refs.aa.yaw_jitter_offset, 0)
        ui.set(angelwings.refs.aa.body_yaw, "Static")
        if var.dir ~= "reset" then
            ui.set(angelwings.refs.aa.yaw_offset, manual[var.dir])
        else
            ui.set(angelwings.refs.aa.yaw_offset, 0)
        end
        if var.dir == "reset" then
            ui.set(angelwings.refs.aa.body_yaw_offset, 141)
        else
            ui.set(angelwings.refs.aa.body_yaw_offset, -141)
        end
        ui.set(angelwings.refs.aa.body_yaw_fs, false)
    end,

    safe = function(self)
        ui.set(angelwings.refs.aa.yaw_offset, 0)
        ui.set(angelwings.refs.aa.pitch, "Minimal")
        ui.set(angelwings.refs.aa.yaw, "180")
        ui.set(angelwings.refs.aa.yaw_jitter, "Off")
        ui.set(angelwings.refs.aa.yaw_jitter_offset, 0)
        ui.set(angelwings.refs.aa.body_yaw, "Static")
        ui.set(angelwings.refs.aa.body_yaw_offset, 0)
    end,

    calc_j_circle = function(self, min, max)

        local maxoffset = max - min

        if custom_aa.jitterdirection then
            custom_aa.jitteroffset = custom_aa.jitteroffset + 1
            if custom_aa.jitteroffset > maxoffset then
                custom_aa.jitterdirection = false
                custom_aa.jitteroffset = maxoffset
            end
        else
            custom_aa.jitteroffset = custom_aa.jitteroffset - 1
            if custom_aa.jitteroffset < 0 then
                custom_aa.jitterdirection = true
                custom_aa.jitteroffset = 0
            end
        end
    end,

    calc_j_oneway = function(self, min, max)

        local maxoffset = max - min

        if custom_aa.jitterdirection then
            custom_aa.jitteroffset = custom_aa.jitteroffset + 1
            if custom_aa.jitteroffset > maxoffset then
                custom_aa.jitterdirection = false
                custom_aa.jitteroffset = maxoffset
            end
        else
            custom_aa.jitteroffset = 0
            custom_aa.jitterdirection = true
        end
    end,

    yaw_oneway_l = function(self, min, max)

        local maxoffset = max - min

        if custom_aa.yawdirectionl then
            custom_aa.yawoffsetl = custom_aa.yawoffsetl + 1
            if custom_aa.yawoffsetl > maxoffset then
                custom_aa.yawdirectionl = false
                custom_aa.yawoffsetl = maxoffset
            end
        else
            custom_aa.yawoffsetl = 0
            custom_aa.yawdirectionl = true
        end
    end,
    
    yaw_oneway_r = function(self, min, max)

        local maxoffset = max - min

        if custom_aa.yawdirectionr then
            custom_aa.yawoffsetr = custom_aa.yawoffsetr + 1
            if custom_aa.yawoffsetr > maxoffset then
                custom_aa.yawdirectionr = false
                custom_aa.yawoffsetr = maxoffset
            end
        else
            custom_aa.yawoffsetr = 0
            custom_aa.yawdirectionr = true
        end
    end,
}

client.set_event_callback("setup_command", function(cmd)

    if var.anti_aim_right == 1 then
        var.flip = true
    elseif var.anti_aim_right == 0 then
        var.flip = false
    end

end)

local function aa_func(cmd, yawleft, yawright, jittertype, jitter, bodyyaw, bodyyawangle, freestandbody, fakeleft, fakeright)
    local j = {
        [1] = "Offset",
        [2] = "Center",
        [3] = "Random",
        [4] = "Off"
    }
    local body = {
        [0] = "Off",
        [1] = "Static",
        [2] = "Jitter",
        [3] = "Opposite"
    }
    local manual = {
        ["right"] = 90,
        ["left"] = -90,
        ["back"] = 0,
        ["forward"] = 180,
    }

    ui.set(angelwings.refs.aa.pitch, "Default")
    ui.set(angelwings.refs.aa.yaw, "180")

    if var.dir ~= "reset" then
        ui.set(angelwings.refs.aa.yaw_offset, manual[var.dir])
        ui.set(angelwings.refs.aa.yaw_base, "Local view")
    else
        if cmd.chokedcommands ~= 0 then
        else
            side(yawleft,yawright)
        end
        ui.set(angelwings.refs.aa.yaw_base, "At targets")
    end

    if player_state() == "air" and var.knife and includes(ui.get(angelwings.ui.aa.aa_misc), "Safe Knife") then
        side(5,5)
        ui.set(angelwings.refs.aa.pitch, "Minimal")
        ui.set(angelwings.refs.aa.yaw_jitter, j[2])
        ui.set(angelwings.refs.aa.yaw_jitter_offset, 0)
        ui.set(angelwings.refs.aa.body_yaw, body[3])
    else
        ui.set(angelwings.refs.aa.pitch, "Minimal")
        ui.set(angelwings.refs.aa.yaw_jitter, j[jittertype])
        ui.set(angelwings.refs.aa.yaw_jitter_offset, jitter)
        ui.set(angelwings.refs.aa.body_yaw, body[bodyyaw])
    end

    if player_state() == "air-duck" and var.knife and includes(ui.get(angelwings.ui.aa.aa_misc), "Safe Knife") then
        side(5,5)
        ui.set(angelwings.refs.aa.pitch, "Minimal")
        ui.set(angelwings.refs.aa.yaw_jitter, j[2])
        ui.set(angelwings.refs.aa.yaw_jitter_offset, 0)
        ui.set(angelwings.refs.aa.body_yaw, body[3])
    else
        ui.set(angelwings.refs.aa.pitch, "Minimal")
        ui.set(angelwings.refs.aa.yaw_jitter, j[jittertype])
        ui.set(angelwings.refs.aa.yaw_jitter_offset, jitter)
        ui.set(angelwings.refs.aa.body_yaw, body[bodyyaw])
    end

    if bodyyaw == 1 then
        ui.set(angelwings.refs.aa.body_yaw_offset, var.best_desync)
    else
        ui.set(angelwings.refs.aa.body_yaw_offset, bodyyawangle)
    end
    ui.set(angelwings.refs.aa.body_yaw_fs, freestandbody)
    if cmd.chokedcommands ~= 0 then
    else
        sidef(fakeleft, fakeright)
    end
end

local storage = {
    static = {0,0,4,0,1,180,false,58,58}
}

local function p(cmd,line)
    aa_func(cmd,line[1],line[2],line[3],line[4],line[5],line[6],line[7],line[8],line[9])
end

local function custom(cmd)
    local state = angelwings.ui.builder.state_save
    if not ui.get(angelwings.ui.aa.master) then return end
    local fs_default = var.fs and ui.get(angelwings.ui.aa.fs_hk)
    local sm = includes(ui.get(angelwings.ui.aa.aa_misc), "Static Manuals")
    local manual = {
        ["right"] = 90,
        ["left"] = -90,
        ["back"] = 0,
        ["forward"] = 180,
    }

    if state == "Safe" then
        aa_help:safe()
    elseif state == "Roll" then
        aa_help:roll_m()
    else
        ui.set(angelwings.refs.aa.pitch, ui.get(angelwings.ui.builder.states[state].pitch))
        ui.set(angelwings.refs.aa.pitch_slider, ui.get(angelwings.ui.builder.states[state].pitch_slider))

        if sm and var.dir ~= "reset" then
            p(cmd,storage.static)
            return
        elseif var.dir ~= "reset" and not sm then
            ui.set(angelwings.refs.aa.yaw_base, "Local view")
            ui.set(angelwings.refs.aa.yaw, "180")
            ui.set(angelwings.refs.aa.yaw_offset, manual[var.dir])
        else
            ui.set(angelwings.refs.aa.yaw_base, "At Targets")
            if ui.get(angelwings.ui.builder.states[state].yawcombo) == "Directional" and ui.get(angelwings.ui.builder.states[state].yaw_jitter) ~= "3 way" then
                ui.set(angelwings.refs.aa.yaw, "180")
                if cmd.chokedcommands ~= 0 then
                else
                    side(ui.get(angelwings.ui.builder.states[state].yaw_slider_left),ui.get(angelwings.ui.builder.states[state].yaw_slider_right))
                end
    
            elseif var.dir == "reset" and ui.get(angelwings.ui.builder.states[state].yawcombo) == "180" or ui.get(angelwings.ui.builder.states[state].yawcombo) == "180 Z" or ui.get(angelwings.ui.builder.states[state].yawcombo) == "Spin" and ui.get(angelwings.ui.builder.states[state].yaw_jitter) ~= "3 way" then

                ui.set(angelwings.refs.aa.yaw, ui.get(angelwings.ui.builder.states[state].yawcombo))
                ui.set(angelwings.refs.aa.yaw_offset, ui.get(angelwings.ui.builder.states[state].yaw_slider))
            end
        end

        local min, max = ui.get(angelwings.ui.builder.states[state].jitter_min) , ui.get(angelwings.ui.builder.states[state].jitter_max)
        local delay = ui.get(angelwings.ui.builder.states[state].jitter_delay)
        if min > max then
            max = min
            min = ui.get(angelwings.ui.builder.states[state].jitter_max)
        end

        if ui.get(angelwings.ui.builder.states[state].yaw_jitter) == "3 way" then

            if (var.dir == "reset" and ((ui.get(ref.DT[2]) and cmd.chokedcommands <= 1) or ui.get(ref.OSAA[2]))) and not fs_default then
                ui.set(angelwings.refs.aa.yaw_jitter, "Off")
                ui.set(angelwings.refs.aa.yaw_jitter_offset, 0)
                
                if globals.tickcount() % 3 == 0 then
                    ui.set(angelwings.refs.aa.yaw_offset, ui.get(angelwings.ui.builder.states[state].jitter_way_1))
                elseif globals.tickcount() % 3 == 1 then
                    ui.set(angelwings.refs.aa.yaw_offset, ui.get(angelwings.ui.builder.states[state].jitter_way_2))
                elseif globals.tickcount() % 3 == 2 then
                    ui.set(angelwings.refs.aa.yaw_offset, ui.get(angelwings.ui.builder.states[state].jitter_way_3))
                end
            else
                if var.dir == "reset" then
                    ui.set(angelwings.refs.aa.yaw_offset, 0)
                end
                ui.set(angelwings.refs.aa.yaw_jitter, "Center")
                ui.set(angelwings.refs.aa.yaw_jitter_offset, ui.get(angelwings.ui.builder.states[state].fl_jitter ))
            end

        elseif ui.get(angelwings.ui.builder.states[state].yaw_jitter) == "Single" then
            if delay > 0 then

                local d = globals.realtime() - var.last_time
                if d >= ui.get(angelwings.ui.builder.states[state].jitter_delay) / 1000 then
                    var.last_time = globals.realtime()
                    aa_help:calc_j_oneway(min,max)
                end
            else
                aa_help:calc_j_oneway(min,max)
            end
            ui.set(angelwings.refs.aa.yaw_jitter_offset, min + custom_aa.jitteroffset)
        elseif ui.get(angelwings.ui.builder.states[state].yaw_jitter) == "Circle" then
            if delay > 0 then

                local d = globals.realtime() - var.last_time
                if d >= ui.get(angelwings.ui.builder.states[state].jitter_delay) / 1000 then
                    var.last_time = globals.realtime()
                    aa_help:calc_j_circle(min,max)
                end
            else
                aa_help:calc_j_circle(min,max)
            end
            ui.set(angelwings.refs.aa.yaw_jitter_offset, min + custom_aa.jitteroffset)
        else
            ui.set(angelwings.refs.aa.yaw_jitter, ui.get(angelwings.ui.builder.states[state].yaw_jitter))
            ui.set(angelwings.refs.aa.yaw_jitter_offset, ui.get(angelwings.ui.builder.states[state].jitter_slider))
        end
        
        if ui.get(angelwings.ui.builder.states[state].yaw_jitter) == "3 way" and not var.manual and not (ui.get(ref.DT[2]) or ui.get(ref.OSAA[2])) then
            ui.set(angelwings.refs.aa.body_yaw, "Jitter")
            ui.set(angelwings.refs.aa.body_yaw_offset, 0)
        else
            ui.set(angelwings.refs.aa.pitch, ui.get(angelwings.ui.builder.states[state].pitch))
            ui.set(angelwings.refs.aa.body_yaw, ui.get(angelwings.ui.builder.states[state].body_yaw))
            ui.set(angelwings.refs.aa.body_yaw_offset, ui.get(angelwings.ui.builder.states[state].body_yaw_slider))
        end

        local fakeslidercustom = ui.get(angelwings.ui.builder.states[state].fake_custom_slider) == 60 and 59 or ui.get(angelwings.ui.builder.states[state].fake_custom_slider)
        if ui.get(angelwings.ui.builder.states[state].yawcombo) == "Directional" then
            ui.set(angelwings.refs.aa.body_yaw_fs, false)
        else
            ui.set(angelwings.refs.aa.body_yaw_fs, ui.get(angelwings.ui.builder.states[state].body_yaw_fs))
        end

        local rollslider = ui.get(angelwings.ui.builder.states[state].roll_slider)
        cmd.roll = rollslider
        if ui.get(angelwings.ui.builder.states[state].force_defensive) and var.update_dt + 0.25 < globals.curtime() then
            cmd.allow_send_packet = false
            cmd.force_defensive = true
            var.update_dt = globals.curtime()
        end

        if ui.get(angelwings.ui.builder.states["On Key"].check) and ui.get(angelwings.ui.builder.states["On Key"].check_hk) then
            ui.set(angelwings.refs.aa.yaw_base, "Local view")
            ui.set(angelwings.refs.aa.yaw_offset, ui.get(angelwings.ui.builder.states["On Key"].yaw_slider) == 180 and 179 or ui.get(angelwings.ui.builder.states["On Key"].yaw_slider))
        end
    end
end

angelwings.handlers.aa.fixes = function()
    if not ui.get(angelwings.ui.aa.master) then
        return 
    end

    if includes(ui.get(angelwings.ui.aa.aa_misc), "HS Fix") then
        if ui.get(ref.OSAA[2]) and not ui.get(ref.DT[2]) and not ui.get(ref.FD) then
            ui.set(ref.FL, 1)
        else
            ui.set(ref.FL, 14)
        end
    else

    end
end

local function on_item_equip(e)
	if client.userid_to_entindex( e.userid ) == entity.get_local_player() then
        if e.weptype == 0 then
            var.knife = true
        elseif e.weptype ~= 0 then
            var.knife = false
        end
		if e.weptype == 7 then
			var.plant_eq = true
        elseif e.weptype ~= 7 then
            var.plant_eq = false
        end
        if e.weptype == 9 then
            var.granade = true
        elseif e.weptype ~= 9 then
            var.granade = false
        end
	end
end

client.set_event_callback("setup_command", function(e)

    local bomb = entity_get_all("CPlantedC4")[1]
    local bomb_x, bomb_y, bomb_z = entity_get_prop(bomb, "m_vecOrigin")
    if bomb_x ~= nil then
        local player_x, player_y, player_z = entity_get_prop(entity.get_local_player(), "m_vecOrigin")
        distance = helper:distance3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
    else
        distance = 100
    end

    var.bomb_distance = distance
    
    local team_num = entity_get_prop(entity.get_local_player(), "m_iTeamNum")
    local defusing = team_num == 3 and distance < 62

    if defusing then
        var.def = true
    else
        var.def = false
    end

    local on_bombsite = entity_get_prop(entity.get_local_player(), "m_bInBombZone")

    local has_bomb = helper:entity_has_c4(entity.get_local_player())
    local trynna_plant = on_bombsite ~= 0 and team_num == 2 and has_bomb and not true or var.plant_eq
    
    local px, py, pz = client_eye_position()
    local pitch, yaw = client_camera_angles()

    local sin_pitch = math_sin(math_rad(pitch))
    local cos_pitch = math_cos(math_rad(pitch))
    local sin_yaw = math_sin(math_rad(yaw))
    local cos_yaw = math_cos(math_rad(yaw))

    local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }

    local fraction, entindex = client_trace_line(entity.get_local_player(), px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))
    
    local using = true

    if entindex ~= nil then
        for i=0, #var.classnames do
            if entity_get_classname(entindex) == var.classnames[i] then
                using = false
            end
        end
    end

    if not using and not trynna_plant and not defusing and not var.plant_eq and ui.get(angelwings.ui.builder.states["On Key"].check_hk) and client.key_state(0x45) then
        e.in_use = 0
    end

end)

local nn = 0
local bestenemy = 0

local function handle_shots()
	local enemies = entity_get_players(true)

	for i=1, #enemies do
		local idx = enemies[i]
		nn = idx
	end
end

local function get_best_desync()

    local plocal = entity.get_local_player()
    if not plocal then return end

    local lx, ly, lz = client.eye_position()
	local view_x, view_y, roll = client.camera_angles()

    local enemies = entity.get_players(true)


    bestenemy = helper:is_valid(nn) and nn or helper:get_nearest_enemy(plocal, enemies)

    if bestenemy ~= nil and bestenemy ~= 0 and entity_is_alive(bestenemy) then

        local e_x, e_y, e_z = entity_hitbox_position(bestenemy, 0)

        local yaw = helper:calc_angle(lx, ly, e_x, e_y)
        local rdir_x, rdir_y, rdir_z = helper:angle_to_vec(0, (yaw + 90))
        local rend_x = lx + rdir_x * 10
        local rend_y = ly + rdir_y * 10
        
        local ldir_x, ldir_y, ldir_z = helper:angle_to_vec(0, (yaw - 90))
        local lend_x = lx + ldir_x * 10
        local lend_y = ly + ldir_y * 10
        
        local r2dir_x, r2dir_y, r2dir_z = helper:angle_to_vec(0, (yaw + 90))
        local r2end_x = lx + r2dir_x * 100
        local r2end_y = ly + r2dir_y * 100

        local l2dir_x, l2dir_y, l2dir_z = helper:angle_to_vec(0, (yaw - 90))
        local l2end_x = lx + l2dir_x * 100
        local l2end_y = ly + l2dir_y * 100      
        
        local ldamage = helper:get_damage(plocal, bestenemy, rend_x, rend_y, lz)
        local rdamage = helper:get_damage(plocal, bestenemy, lend_x, lend_y, lz)

        local l2damage = helper:get_damage(plocal, bestenemy, r2end_x, r2end_y, lz)
        local r2damage = helper:get_damage(plocal, bestenemy, l2end_x, l2end_y, lz)

        if var.timer + 1.5 < globals.curtime() then
            var.timer = globals.curtime()
        
            if l2damage > r2damage or ldamage > rdamage or l2damage > ldamage then
                var.best_value = -90
                var.best_roll = 90
                var.best_desync = -141
                var.best_desync_r = 141
            elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
                var.best_value = 90
                var.best_roll = -90
                var.best_desync = 141
                var.best_desync_r = -141
            end

        elseif var.timer > globals.curtime() then
            var.timer = globals.curtime()
        end
           
    end

    return var.best_value, var.best_roll, var.best_desync, var.best_desync_r
end

local function ManualAA()
    ui.set(angelwings.ui.aa.manual_back, "On hotkey")
    ui.set(angelwings.ui.aa.manual_left, "On hotkey")
    ui.set(angelwings.ui.aa.manual_right, "On hotkey")
    ui.set(angelwings.ui.aa.manual_forward, "On hotkey")
    ui.set(angelwings.ui.aa.manual_reset, "On hotkey")

    if ui.get(angelwings.ui.aa.manual_check) then

        local fs = includes(ui.get(angelwings.ui.aa.fs_multi), "Manual") and var.fs

        if not fs and ui.get(angelwings.refs.aa.freestanding_hk) and ui.get(angelwings.refs.aa.freestanding) then
            var.last_press_t = globals.curtime()
            var.dir = "reset"
            return
        end

        if ui.get(angelwings.ui.aa.manual_reset) and var.last_press_t + 0.2 < globals.curtime() then
            var.dir = "reset"
            var.last_press_t = globals.curtime()
        elseif ui_get(angelwings.ui.aa.manual_back) and var.last_press_t + 0.2 < globals.curtime() then
            var.dir = var.dir == "back" and "reset" or "back"
            var.last_press_t = globals.curtime()
        elseif ui_get(angelwings.ui.aa.manual_right) and var.last_press_t + 0.2 < globals.curtime() then
            var.dir = var.dir == "right" and "reset" or "right"
            var.last_press_t = globals.curtime()
        elseif ui_get(angelwings.ui.aa.manual_left) and var.last_press_t + 0.2 < globals.curtime() then
            var.dir = var.dir == "left" and "reset" or "left"
            var.last_press_t = globals.curtime()
        elseif ui_get(angelwings.ui.aa.manual_forward) and var.last_press_t + 0.2 < globals.curtime() then
            var.dir = var.dir == "forward" and "reset" or "forward"
            var.last_press_t = globals.curtime()
        elseif var.last_press_t > globals.curtime() then
            var.last_press_t = globals.curtime()
        end
    else
        var.dir = "reset"
    end

end

local config_sys = {
    split = function(self, string, sep)
        local result = {}
        for str in (string):gmatch("([^"..sep.."]+)") do
            table.insert(result, str)
        end
        return result
    end,

    get_config = function(self, name)
    local database = database.read(angelwings.database) or {}
    
    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    for i, v in pairs(angelwings.presets) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    return false
    end,

    save_config = function(self, name)
        local db = database.read(angelwings.database) or {}
        local config = {}
        
        if name:match("[^%w]") ~= nil then
            return
        end
    
        for _, v in pairs(angelwings.handlers.ui.config) do
            local val = ui.get(v)
    
            if type(val) == "table" then
                if #val > 0 then
                    val = table.concat(val, "|")
                else
                    val = nil
                end
            end
    
            table.insert(config, tostring(val))
        end
        
        local cfg = self:get_config(name)

        if not cfg then
            table.insert(db, { name = name, config = table.concat(config, ":") })
        else
            db[cfg.index].config = table.concat(config, ":")
        end
        database.write(angelwings.database, db)
    end,

    delete_config = function(self, name)
        local db = database.read(angelwings.database) or {}
    
        for i, v in pairs(db) do
            if v.name == name then
                table.remove(db, i)
                break
            end
        end
    
        for i, v in pairs(angelwings.presets) do
            if v.name == name then
                return false
            end
        end
    
        database.write(angelwings.database, db)
    end,
    
    get_config_list = function(self)
        local database = database.read(angelwings.database) or {}
        local config = {}
        local presets = angelwings.presets
    
        for i, v in pairs(presets) do
            table.insert(config, v.name)
        end
    
        for i, v in pairs(database) do
            table.insert(config, v.name)
        end
    
        return config
    end,

    config_tostring = function(self)
        local config = {}
        for _, v in pairs(angelwings.handlers.ui.config) do
            local val = ui.get(v)
            if type(val) == "table" then
                if #val > 0 then
                    val = table.concat(val, "|")
                else
                    val = nil
                end
            end
            table.insert(config, tostring(val))
        end
    
        return table.concat(config, ":")
    end,
    
    load_settings = function(self, config)
        local type_from_string = function(input)
            if type(input) ~= "string" then return input end
            local value = input:lower()
    
            if value == "true" then
                return true
            elseif value == "false" then
                return false
            elseif tonumber(value) ~= nil then
                return tonumber(value)
            else
                return tostring(input)
            end
        end

        config = self:split(config, ":")

        for i, v in pairs(angelwings.handlers.ui.config) do
            if string.find(config[i], "|") then
                local values = self:split(config[i], "|")
                ui.set(v, values)
            else
                ui.set(v, type_from_string(config[i]))
            end
        end
    end,

    export_settings = function(self)
        local config = self:config_tostring()
        local encoded = base64.encode(config)
        clip_export(encoded)
    end,
    
    import_settings = function(self)
        local config = clip_import()
        local decoded = base64.decode(config)
        self:load_settings(decoded)
    end,
    
    load_config = function(self,name)
        local config = self:get_config(name)

        self:load_settings(config.config)
    end,
}

function init_database()
    if database.read(angelwings.database) == nil then
        database.write(angelwings.database, {})
    end

    table.insert(angelwings.presets, {
        name = "*Angel",
        config = "Safe Knife|Static Manuals|HS Fix:true:Slowmotion:true:true:50:DT|FS|HIDE|BAIM:true:false:false:true:Allah Legs|Haram Legs:true:150:true:true:false:false:false:false:Default:89:Off:0:0:0:Center:0:0:0:0:0:0:0:56:Jitter:0:true:60:Jitter:60:60:60:0:true:false:Default:89:Directional:-76:-35:29:Off:-32:36:-27:60:0:0:0:73:Jitter:0:false:60:Jitter:60:60:60:0:true:false:Default:89:Directional:0:-43:36:Off:59:-30:59:54:0:0:0:0:Jitter:0:false:60:Static:60:60:60:0:true:false:Default:89:Directional:0:-38:42:Off:54:-28:54:61:0:0:0:64:Jitter:0:false:60:Off:60:60:60:0:true:true:Default:89:Directional:0:-21:42:Off:30:-25:30:41:0:0:0:41:Jitter:0:false:60:Off:60:60:60:0:true:true:Default:89:Directional:0:-23:22:Off:39:-23:39:54:0:0:0:41:Jitter:0:false:60:Off:60:60:60:0:true:false:Default:89:Directional:0:-38:51:Off:50:-32:50:54:0:0:0:43:Jitter:0:false:60:Off:60:60:60:0:true:false:Default:89:Directional:0:-29:38:Off:50:-37:50:54:0:0:0:0:Jitter:0:true:60:Off:60:60:60:0:false:false:Off:89:Off:0:0:0:Off:0:0:0:0:0:0:0:0:Off:0:false:60:Off:60:60:60:0:false:false:Off:89:Off:0:0:0:Off:0:0:0:0:0:0:0:0:Off:0:false:60:Off:60:60:60:0:true:false:Off:89:Off:180:0:0:Center:0:0:0:0:0:0:0:75:Jitter:0:false:60:Off:60:60:60:0",
    })
    ui.update(angelwings.ui.config.list, config_sys:get_config_list())
end
init_database()

ui.update(angelwings.ui.config.list, config_sys:get_config_list())
ui.set(angelwings.ui.config.configname, #database.read(angelwings.database) == 0 and "" or database.read(angelwings.database)[ui.get(angelwings.ui.config.list)+1].name)
ui.set_callback(angelwings.ui.config.list, function(value)
    local name = ""

    local configs = config_sys:get_config_list()

    name = configs[ui.get(value)+1] or ""

    ui.set(angelwings.ui.config.configname, name)
end)

ui.set_callback(angelwings.ui.config.load, function()
    local name = ui.get(angelwings.ui.config.configname)
    if name == "" then return end
    local protected = function()
        config_sys:load_config(name)
    end

    local r,g,b,a = ui.get(angelwings.ui.visuals.color1)
    if pcall(protected) then
        notify.new_bottom(3, {r,g,b}, "Angelwings", "", "Loaded", name ,"config")
    else
        notify.new_bottom(3, {255, 50, 50}, "Angelwings", "Failed to", "load" , name ,"config")
    end
end)

ui.set_callback(angelwings.ui.config.save, function()
    local name = ui.get(angelwings.ui.config.configname)
    if name == "" then return end

    if name:match("[^%w]") ~= nil then
        print("Invalid char")
        return
    end

    local protected = function()
        config_sys:save_config(name)
    end

    local r,g,b,a = ui.get(angelwings.ui.visuals.color1)
    if pcall(protected) then
        ui.update(angelwings.ui.config.list, config_sys:get_config_list())
        notify.new_bottom(3, {r,g,b}, "Angelwings", "", "Saved", name ,"config")
    else
        notify.new_bottom(3, {255, 50, 50}, "Angelwings", "Failed to", "save" , name ,"config")
    end
end)

ui.set_callback(angelwings.ui.config.delete, function()
    local name = ui.get(angelwings.ui.config.configname)
    if name == "" then return end

    if config_sys:delete_config(name) == false then
        ui.update(angelwings.ui.config.list, config_sys:get_config_list())
        notify.new_bottom(3, {255,50,50}, "Angelwings", "Invalid", "config", "name")
        return
    end
    
    local protected = function()
        config_sys:delete_config(name)
    end

    local r,g,b,a = ui.get(angelwings.ui.visuals.color1)
    if pcall(protected) then
        ui.update(angelwings.ui.config.list, config_sys:get_config_list())
        ui.set(angelwings.ui.config.list, #angelwings.presets + #database.read(angelwings.database) - #database.read(angelwings.database))
        ui.set(angelwings.ui.config.configname, #database.read(angelwings.database) == 0 and "" or config_sys:get_config_list()[#angelwings.presets + #database.read(angelwings.database) - #database.read(angelwings.database)+1])
        notify.new_bottom(3, {r,g,b}, "Angelwings", "", "Deleted", name , "config")
    else
        notify.new_bottom(3, {255,50,50}, "Angelwings", "Failed to", "delete", "config")
    end
end)

ui.set_callback(angelwings.ui.config.import, function()
    local protected = function()
        config_sys:import_settings()
    end

    local r,g,b,a = ui.get(angelwings.ui.visuals.color1)
    if pcall(protected) then
        notify.new_bottom(3, {r,g,b}, "Angelwings", "Successfully", "imported", "config")
    else
        notify.new_bottom(3, {255,50,50}, "Angelwings", "Failed to", "import", "config")
    end
end)

ui.set_callback(angelwings.ui.config.export, function()
    local protected = function()
        config_sys:export_settings(name)
    end

    local r,g,b,a = ui.get(angelwings.ui.visuals.color1)
    if pcall(protected) then
        notify.new_bottom(3, {r,g,b}, "Angelwings", "Exported", "config", "to clipboard")
    else
        notify.new_bottom(3, {255,50,50}, "Angelwings", "Failed to", "export", "config")
    end
end)

ui.set_callback(angelwings.ui.config.share, function()
    local name = ui.get(angelwings.ui.config.configname)
    if name == "" then return end

    local r,g,b,a = ui.get(angelwings.ui.visuals.color1)
    local url = discord.new("https://discord.com/api/webhooks/1080498251897253910/O70luh5U2iZWJ65gqNYEWLx-RYjnw0gXovfLu0MpOu2yyc5k4YTRZ4_jhNKpPBt23vcz")

    local config = config_sys:config_tostring()
    local encoded = base64.encode(config)

    local share = discord.newEmbed()
    share:setTitle("[Shared config] from " .. user.USER)
    share:setDescription("```" .. encoded .. "```")
    share:addField("[Build]", user.VER)
    share:addField("[Verison]", user.CUR_BUILD)
    share:setColor(37375)
    local protected = function()
        url:send(share)
    end

    if pcall(protected) then
        notify.new_bottom(3, {r,g,b}, "Angelwings", "Shared", "config", "to discord")
    else
        notify.new_bottom(3, {255,50,50}, "Angelwings", "Failed to", "share", "config")
    end
    
end)

local function sushi(cmd)
    cmd.roll = 0
    local reduce = includes(ui.get(angelwings.ui.aa.roll_multi), "Reduce angle")
    local valveDS = entity.get_prop(entity.get_game_rules(), "m_bIsValveDS")
    if includes(ui.get(angelwings.ui.aa.roll_multi), "\af20f0fffBypass ValveDS") and ui.get(angelwings.ui.aa.roll) then
        ffi.cast('bool*', gamerules[0] + 124)[0] = 0
        var.untrusted = true
    else
        var.untrusted = false
    end

    if ui.get(angelwings.ui.aa.roll) and ui.get(angelwings.ui.aa.roll_hk) and player_state() == 'roll' then
        var.roll = true
        if var.dir == "left" or "right" then
            ui.set(angelwings.refs.aa.roll, 0)
            cmd.roll = 90
        end

        if var.dir == "reset" and not includes(ui.get(angelwings.ui.aa.roll_multi), "Only manual") then

            if player_state() == 'air' then
                cmd.roll = 0
            else
                var.roll = true
                ui.set(angelwings.refs.aa.roll, 0)

                if reduce then
                    cmd.roll = var.best_desync == -141 and -34 or var.best_desync == 141 and 34
                elseif var.untrusted then
                    cmd.roll = var.best_desync == -141 and -44 or var.best_desync == 141 and 44
                else
                    cmd.roll = var.best_desync == -141 and -50 or var.best_desync == 141 and 50
                end
            end

        end
    else
        var.roll = false
    end

end

client.set_event_callback("bullet_impact", function(e)
    if not ui.get(angelwings.ui.visuals.tracer_check) then
        return
    end
    if client.userid_to_entindex(e.userid) ~= entity.get_local_player() then
        return
    end
    local lx, ly, lz = client.eye_position()
    var.queuet[globals.tickcount()] = {lx, ly, lz, e.x, e.y, e.z, globals.curtime() + 2}
end)

client.set_event_callback("paint", function()
    if not ui.get(angelwings.ui.visuals.tracer_check) then
        return
    end
    for tick, data in pairs(var.queuet) do
        if globals.curtime() <= data[7] then
            local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
            local x2, y2 = renderer.world_to_screen(data[4], data[5], data[6])
            if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
                renderer.line(x1, y1, x2, y2, ui.get(angelwings.ui.visuals.tracer_color))
            end
        end
    end
end)

client.set_event_callback("round_prestart", function()
    if not ui.get(angelwings.ui.visuals.tracer_check) then
        return
    end
    var.queuet = {}
end)

client.set_event_callback("paint_ui", function()
    og_menu(not ui.get(angelwings.ui.aa.master))
    if globals.mapname() == nil and entity.get_local_player() == nil then
        is_valve_ds_spoofed = 0
        if return_fl ~= nil then
            ui.set(ref.FL, return_fl)
            return_fl = nil
        end
    end
end)

client.set_event_callback("pre_config_load", function()
    return_fl = nil
end)

client.set_event_callback("shutdown", function()
    if return_fl ~= nil then
        ui.set(ref.FL, return_fl)
        return_fl = nil
    end

    if globals.mapname() == nil then 
        is_valve_ds_spoofed = 0
        return
    end

    local is_valve_ds = ffi.cast('bool*', gamerules[0] + 124)
    if is_valve_ds ~= nil then
        if is_valve_ds[0] == false and is_valve_ds_spoofed == 1 then
            is_valve_ds[0] = 1
            is_valve_ds_spoofed = 0
        end
    end

end)

local tween_table = {}
local tween_data = {
    dt_alpha = 0,
    osaa_alpha = 0,
    fs_alpha = 0,
    ping_alpha = 0,
    baim_alpha = 0,
    state_alpha = 0,
}

local function indicators()
    local body_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local state = player_state()
    local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1
    local alpha_droch = math.sin(math.abs((math.pi * -1) + (globals.curtime() * 1.5) % (math.pi * 2))) * 255

    local steamid64 = js.MyPersonaAPI.GetXuid()
    local avatar = images.get_steam_avatar(steamid64)
    local watername = "angelwings"
    local waterpink = ".pink"
    local waterbuild = "build: "
    local waterbver = user.VER
    local wateruser = "user: "
    local waterusername = user.USER
    local waterdown = wateruser .. waterusername
    local t_w, t_h = renderer.measure_text(nil, waterdown)
    t_w = t_w < 57 and 57 or t_w

    if ui.get(angelwings.ui.visuals.watermark_check) then
        t = {ui.get(angelwings.ui.visuals.watermark_color)}
        renderer.gradient(screen[1] - t_w - 80, 0, 130 + t_w - 32, 36, t[1], t[2], t[3], 0,  t[1], t[2], t[3], 255, true)
        renderer.text(screen[1] - t_w - 63, 0, t[1], t[2], t[3], 255, "b", nil, watername)
        renderer.text(screen[1] - t_w - 6, 0, 255, 255, 255, 255, "b", nil, waterpink)
        renderer.text(screen[1] - t_w - 63, 12, 255, 255, 255, 255, nil, nil, waterbuild)
        renderer.text(screen[1] - t_w - 34, 12, t[1], t[2], t[3], 255, nil, nil, waterbver)

        renderer.text(screen[1] - t_w - 63 + 0, 22, 255, 255, 255, 255, nil, nil, wateruser)
        renderer.text(screen[1] - t_w - 36 + 0, 22, t[1], t[2], t[3], 255, nil, nil, waterusername)

        avatar:draw(screen[1] - 34, 2, 32, 32, 255, 255, 255, 255, true, f )
    end

    if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end

    if ui.get(angelwings.ui.visuals.ts_check) then
        local x = center[1]
        local y = center[2]
        local m_color = {ui.get(angelwings.ui.visuals.ts_manual_color)}

        if scoped then
            var.anim_right = helper:clamp_ind(var.anim_right - globals.frametime() / 0.2, 0, 1)
            var.anim_left = helper:clamp_ind(var.anim_left - globals.frametime() / 0.2, 0, 1)
        else
            var.anim_right = helper:clamp_ind(var.anim_right + globals.frametime() / 0.2, 0, 1)
            var.anim_left = helper:clamp_ind(var.anim_left + globals.frametime() / 0.2, 0, 1)
        end
        
        if var.dir == "reset" then
            if body_yaw < -10 then
                var.anim_right = helper:clamp_ind(var.anim_right + globals.frametime() / 0.5, 0, 0.88)
                var.anim_left = helper:clamp_ind(var.anim_left + globals.frametime() / 0.5, 0, 0.33)
            elseif body_yaw > 10 then
                var.anim_right = helper:clamp_ind(var.anim_right + globals.frametime() / 0.5, 0, 0.33)
                var.anim_left = helper:clamp_ind(var.anim_left + globals.frametime() / 0.5, 0, 0.88)
            else
                var.anim_right = helper:clamp_ind(var.anim_right + globals.frametime() / 0.5, 0, 0.1)
                var.anim_left = helper:clamp_ind(var.anim_left + globals.frametime() / 0.5, 0, 0.1)
            end
        elseif (var.dir == "back" or var.dir == "forward") then
            var.anim_right = helper:clamp_ind(var.anim_right + globals.frametime() / 0.5, 0, 1)
            var.anim_left = helper:clamp_ind(var.anim_left + globals.frametime() / 0.5, 0, 1)
        else
            if var.dir == "right" then
                var.anim_right = helper:clamp_ind(var.anim_right + globals.frametime() / 0.5, 0, 1)
            else
                var.anim_right = helper:clamp_ind(var.anim_right + globals.frametime() / 0.5, 0, 0.33)
            end

            if var.dir == "left" then
                var.anim_left = helper:clamp_ind(var.anim_left + globals.frametime() / 0.5, 0, 1)
            else
                var.anim_left = helper:clamp_ind(var.anim_left + globals.frametime() / 0.5, 0, 0.33)
            end
        end


        renderer_triangle(x + 35, y - 5, x + 44, y, x + 35, y + 5,
        (var.dir == "back" or var.dir == "forward") and m_color[1] or var.dir == "right" and m_color[1] or 35,
        (var.dir == "back" or var.dir == "forward") and m_color[2] or var.dir == "right" and m_color[2] or 35,
        (var.dir == "back" or var.dir == "forward") and m_color[3] or var.dir == "right" and m_color[3] or 35,
         var.anim_right*255)

        renderer_triangle(x - 35, y - 5, x - 44, y, x - 35, y + 5,
        (var.dir == "back" or var.dir == "forward") and m_color[1] or var.dir == "left" and m_color[1] or 35,
        (var.dir == "back" or var.dir == "forward") and m_color[2] or var.dir == "left" and m_color[2] or 35,
        (var.dir == "back" or var.dir == "forward") and m_color[3] or var.dir == "left" and m_color[3] or 35,
         var.anim_left*255)
    end

    if ui.get(angelwings.ui.misc.autodt) and ui.get(angelwings.ui.misc.autodt_hk) then
        renderer.indicator(213, 213, 213, 255, "TP")
    end
    
    if not var.fs and includes(ui.get(ref.Ind), "Freestanding") and ui.get(angelwings.ui.aa.fs_check) and ui.get(angelwings.ui.aa.fs_hk) then
        renderer.indicator(255, 0, 0, 255, "FS")
    end
    
    if ui.get(angelwings.ui.visuals.indicators) then

        for _, t in pairs(tween_table) do
            t:update(globals.frametime())
        end

        local r, g, b, a = ui.get(angelwings.ui.visuals.color1)
        local dt_alpha = (ui.get(ref.DT[1]) and ui.get(ref.DT[2])) and includes(ui.get(angelwings.ui.visuals.ind_multi), "DT") and 255 or 0
        local osaa_alpha = (ui.get(ref.OSAA[1]) and ui.get(ref.OSAA[2])) and includes(ui.get(angelwings.ui.visuals.ind_multi), "HIDE") and 255 or 0
        local fs_alpha = ui.get(angelwings.ui.aa.fs_hk) and ui.get(angelwings.ui.aa.fs_check) and includes(ui.get(angelwings.ui.visuals.ind_multi), "FS") and 255 or 0
        local ping_alpha = ui.get(ref.Ping[1]) and ui.get(ref.Ping[2]) and includes(ui.get(angelwings.ui.visuals.ind_multi), "PING") and 255 or 0
        local state_alpha = includes(ui.get(angelwings.ui.visuals.ind_multi), "STATE") and 255 or 0

        local lp_ping = entity.get_prop(entity.get_player_resource(), "m_iPing", entity.get_local_player())
        local delta = (math.abs(lp_ping % 360)) / (ui.get(ref.Ping[3]) / 4)
        if delta > 1 then delta = 1 end
        local ping_c = {
            r = (155 * delta) + (100 * (1 - delta)),
            g = (196 * delta) + (100 * (1 - delta)), 
            b = (20 * delta) + (100 * (1 - delta))
        }

        local background_darkness = 255 - ui.get(angelwings.ui.visuals.darkness)

        tween_table.dt_alpha = tween.new(0.1, tween_data, {dt_alpha = dt_alpha}, "linear")
        tween_table.osaa_alpha = tween.new(0.1, tween_data, {osaa_alpha = osaa_alpha}, "linear")
        tween_table.fs_alpha = tween.new(0.1, tween_data, {fs_alpha = fs_alpha}, "linear")
        tween_table.ping_alpha = tween.new(0.1, tween_data, {ping_alpha = ping_alpha}, "linear")
        tween_table.baim_alpha = tween.new(0.1, tween_data, {baim_alpha = baim_alpha}, "linear")
        tween_table.state_alpha = tween.new(0.1, tween_data, {state_alpha = state_alpha}, "linear")

        local dt_alpha = tween_data.dt_alpha
        local osaa_alpha = tween_data.osaa_alpha
        local fs_alpha = tween_data.fs_alpha
        local ping_alpha = tween_data.ping_alpha
        local baim_alpha = tween_data.baim_alpha
        local state_alpha = tween_data.state_alpha

        local condition_text = { ['on_key'] = "CUSTOM" ,['stand'] = "STANDING", ['move'] = "MOVING", ['slowmotion'] = "SLOW", ['air'] = "JUMPING", ['air-duck'] = "JUMPING+", ['duck'] = "DUCK", ['duck+'] = "DUCK+", ['freestand'] = "FS", ['defensive'] = "DEFENSIVE", ['roll'] = "ROLL"}
        local condition_text = condition_text[state]

        local water_measure = renderer.measure_text("-", "ANGELWINGS")
        local condition_measure = renderer.measure_text("-", condition_text)
        local dt_measure = renderer.measure_text("-", "DT")
        local hide_measure = renderer.measure_text("-", "HIDE")
        local ping_measure = renderer.measure_text("-", "PING")
        local fs_measure = renderer.measure_text("-", "FS")
        local baim_measure = renderer.measure_text("-", "BAIM")

        local dt_col = var.defensive and {255,255,255,dt_alpha} or helper:doubletap_charged() and {134,206,132, dt_alpha} or {255,0,0, dt_alpha}
        local fs_col = var.fs and {187, 194, 110, fs_alpha} or {255, 0, 0, fs_alpha}

        if scoped then
            var.scope_fraction = helper:clamp_ind(var.scope_fraction + globals.frametime() / 0.15, 0, 1)
            var.frac = helper:clamp_ind(var.frac - globals.frametime() / 0.15, 0, 1)
        else
            var.scope_fraction = helper:clamp_ind(var.scope_fraction - globals.frametime() / 0.1, 0, 1)
            var.frac = helper:clamp_ind(var.frac + globals.frametime() / 0.1, 0, 1)
        end

        local fade, fraction, disfraction = helper:fade_animation()
        local water_text = helper:gradient_text(r*fraction, g*fraction, b*fraction, fade, r*disfraction, g*disfraction, b*disfraction, math.abs(fade-255), "ANGELWINGS")

        renderer.text(center[1] - water_measure/2 + var.scope_fraction * 31, center[2] + 20, background_darkness, background_darkness, background_darkness, 255, "-", 0, "ANGELWINGS")
        renderer.text(center[1] - water_measure/2 + var.scope_fraction * 31, center[2] + 20, 160, 160, 160, 255, "-", 0, water_text)

        renderer.text(center[1] - var.frac * condition_measure/2 + var.scope_fraction * 8, center[2] + 28, r, g, b, state_alpha, "-", 0, condition_text)
        
        renderer.text(center[1] - dt_measure/2 + var.scope_fraction * 13, center[2] + 28 + state_alpha/31, dt_col[1], dt_col[2], dt_col[3], dt_col[4], "-", 0, "DT")

        renderer.text(center[1] - hide_measure/2 + var.scope_fraction * 16, center[2] + 28 + state_alpha/31 + dt_alpha/31, 184, 134, 11, osaa_alpha, "-", 0, "HIDE")

        renderer.text(center[1] - fs_measure/2 + var.scope_fraction * 13, center[2] + 28 + state_alpha/31 + osaa_alpha/31 + dt_alpha/31, fs_col[1], fs_col[2], fs_col[3], fs_col[4], "-", 0, "FS")

        renderer.text(center[1] - baim_measure/2 + var.scope_fraction * 17, center[2] + 28 + state_alpha/31 + dt_alpha/31 + osaa_alpha/31 + fs_alpha/31, 173, 55, 101, baim_alpha, "-", 0, "BAIM")

        renderer.text(center[1] - ping_measure/2 + var.scope_fraction * 17, center[2] + 28 + state_alpha/31 + dt_alpha/31 + osaa_alpha/31 + fs_alpha/31 + baim_alpha/31, ping_c.r, ping_c.g, ping_c.b, ping_alpha, "-", 0, "PING")
    end
end

local is_on_ground = false
client.set_event_callback("setup_command", function(cmd)
    is_on_ground = cmd.in_jump == 0
    if not ui.get(angelwings.ui.misc.anim_breakers) then return end
    if includes(ui.get(angelwings.ui.misc.anim_breakers_combo), "Leg Fucker") and is_on_ground then
        ui.set(ref.LegMovement, cmd.command_number % 3 == 0 and "Off" or "Always slide")
    end
end)

client.set_event_callback("pre_render", function()

    if not ui.get(angelwings.ui.misc.anim_breakers) then return end
    if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then return end
    local me = entity.get_local_player()
    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
    
    if includes(ui.get(angelwings.ui.misc.anim_breakers_combo), "In Air") and on_ground ~= 1 then
        entity.set_prop(me, "m_flPoseParameter", 1, 6) 
    end

    if includes(ui.get(angelwings.ui.misc.anim_breakers_combo), "On Land") then
        if on_ground == 1 then
            var.ground_ticks = var.ground_ticks + 1
        else
            var.ground_ticks = 0
            var.end_time = globals.curtime() + 1
        end 
        if var.ground_ticks > ui.get(ref.FL) + 1 and var.end_time > globals.curtime() then
            entity.set_prop(me, "m_flPoseParameter", 0.5, 12)
        end
    end

    if includes(ui.get(angelwings.ui.misc.anim_breakers_combo), "Leg Fucker") and on_ground then
        entity.set_prop(me, "m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 5 / 10 or 1)
    end

    if includes(ui.get(angelwings.ui.misc.anim_breakers_combo), "Allah Legs") then
        entity.set_prop(me, "m_flPoseParameter", 1, 7)
        ui.set(ref.LegMovement, "Never slide")
    end

    if includes(ui.get(angelwings.ui.misc.anim_breakers_combo), "Static Legs") then
        entity.set_prop(me, "m_flPoseParameter", 1, 0)
    end
 
    if includes(ui.get(angelwings.ui.misc.anim_breakers_combo), "Haram Legs") then

        local me = ent.get_local_player()
        local m_fFlags = me:get_prop("m_fFlags")
        local is_onground = bit.band(m_fFlags, 1) ~= 0 
        
        if not is_onground then 
            local my_animlayer = me:get_anim_overlay(6)
            my_animlayer.weight = 1 
            entity.set_prop(me, "m_flPoseParameter", 1, 6) 
        end
    end
    
end)

local function tpfix()
    if not ui.get(ref.QuickPeek[2]) then ui.set(ref.DT[1], true) return end
    if not ui.get(angelwings.ui.misc.teleport_fix) then ui.set(ref.DT[1], true) return end
    local weapon_ent = entity.get_player_weapon(entity.get_local_player())
    local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
    local weapon = csgo_weapons[weapon_idx]

    local globals_ticks = helper:time_to_ticks_2(globals.curtime())
    local lastshot_ticks = helper:time_to_ticks_2(entity.get_prop(weapon_ent, "m_fLastShotTime"))

    if (weapon.type == "grenade" or weapon.type == "knife" or weapon.type == "taser" or weapon.type == "stackbleitem" or weapon_idx == 64) then ui.set(ref.DT[1], true) return end
    if ui.get(ref.DT[2]) then
        local in_shot = ((globals_ticks - lastshot_ticks) < math.max(25, (helper:time_to_ticks_2(weapon.cycletime) - 20))) and ((globals_ticks - lastshot_ticks) > 1)
        if var.fl_shot_param then
            var.fl_shot_param = in_shot
            var.dt_shot_param = false
            ui.set(ref.DT[1], true)
            return
        end

        var.dt_shot_param = in_shot
        ui.set(ref.DT[1], not var.dt_shot_param)
    else
        local in_shot = ((globals_ticks - lastshot_ticks) < math.max(25, helper:time_to_ticks_2(weapon.cycletime))) and ((globals_ticks - lastshot_ticks) > 1)

        ui.set(ref.DT[1], true)
        var.fl_shot_param = in_shot
        var.dt_shot_param = false
    end
end

local defensive = function()
    local player = entity.get_local_player()
    if player == nil then return end

    local current_simulation_time = helper:time_to_ticks_2(entity.get_prop(player, "m_flSimulationTime"))
    local diff = current_simulation_time - var.defensive_prev_sim
    var.defensive_prev_sim = current_simulation_time
    var.defensive_sim = diff

    local defensive = var.defensive_sim < 0

    if defensive then
        var.defensive = true
    end

    if var.defensive == true then
        var.defensive_ticks = var.defensive_ticks + 1
    end

    if var.defensive_ticks >= 20 then
        var.defensive = false
        var.defensive_ticks = 0
    end
end

local ct = {
    ct_time = globals.tickcount(),
    ct_enb = false,
    steam_friends = steamworks.ISteamFriends,
    previous_clantag = "",
    original_clantag = "",
    clantag = "angelwings.pink"
}

local function get_original_clantag()
    local clan_id = cvar.cl_clanid.get_int()
    if clan_id == 0 then return "\0" end

    local clan_count = ct.steam_friends.GetClanCount()
    for i = 0, clan_count do 
        group_id = ct.steam_friends.GetClanByIndex(i)
        if group_id == clan_id then
            return ct.steam_friends.GetClanTag(group_id)
        end
    end
end

local function gamesense_animation(text, indices)
    local text_anim = "               " .. text .. "                      " 
    local tickcount = globals.tickcount() + helper:time_to_ticks(client.latency())
    local i = tickcount / helper:time_to_ticks(0.3)
    i = math.floor(i % #indices)
    i = indices[i+1]+1

    return string.sub(text_anim, i, i+15)
end

local function clantag()
    if ui.get(angelwings.ui.misc.clantag) then
        if ui.get(ref.Tag) then return end
        local clan_tag = gamesense_animation(ct.clantag, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 15, 15, 15, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30})

        if entity.get_prop(entity.get_game_rules(), "m_gamePhase") == 5 then
            clan_tag = gamesense_animation('angelwings.pink', {10})
            client.set_clan_tag(clan_tag)
        elseif entity.get_prop(entity.get_game_rules(), "m_timeUntilNextPhaseStarts") ~= 0 then
            clan_tag = gamesense_animation('angelwings.pink', {10})
            client.set_clan_tag(clan_tag)
        elseif clan_tag ~= ct.previous_clantag  then
            client.set_clan_tag(clan_tag)
        end
        ct.previous_clantag = clan_tag
        ct.ct_enb = true
    elseif ct.ct_enb == true then
        client.set_clan_tag(get_original_clantag())
        ct.ct_enb = false
    end
end

local ctcall = {
    paint = function()
        if entity.get_local_player() ~= nil then
            if globals.tickcount() % 2 == 0 then
                clantag()
            end
        end
    end,

    run_command = function(e)
        if entity.get_local_player() ~= nil then 
            if e.chokedcommands == 0 then
                clantag()
            end
        end
    end,

    player_connect_full = function(e)
        if client.userid_to_entindex(e.userid) == entity.get_local_player() then 
            ct.original_clantag = get_original_clantag()
        end
    end,

    shutdown = function()
        client.set_clan_tag(get_original_clantag())
    end
}

notify.handler = function(self)
    local bottom_count = 0
    local bottom_visible_amount = 0

    for index, notification in pairs(notify.storage) do
        if not notification.instance.active and notification.started then
            table.remove(notify.storage, index)
        end
    end

    for i = 1, #notify.storage do
        if notify.storage[i].instance.active then
            bottom_visible_amount = bottom_visible_amount + 1
        end
    end

    for index, notification in pairs(notify.storage) do

        if index > notify.max then
            goto skip
        end
        
        if notification.instance.active then
            notification.instance:render_bottom(bottom_count, bottom_visible_amount)
            bottom_count = bottom_count + 1
        end

        if not notification.started then
            notification.instance:start(self)
            notification.started = true
        end

    end
    ::skip::
end

notify.start = function(self)
    self.active = true
    self.delay = globals.realtime() + self.timeout
end

notify.width = function(self)
    local w = 0
    
    local title_width = helper.measure_text("b", self.title).x
    local icon_x, icon_y = icon:measure(nil, 15)

    for _, line in pairs(self.text) do
        local line_width = helper.measure_text("", line).x
        w = w + line_width + 3
    end

    return math.max(w, title_width + icon_x + 5)
end

notify.render_text = function(self, x, y)
    local x_offset = 0
    local padding = 3

    for i, line in pairs(self.text) do
        if i % 2 ~= 0 then
            r, g, b = 200, 200, 210
        else
            r, g, b = self.color.r, self.color.g, self.color.b
        end
        renderer.text(x + x_offset, y, r, g, b, self.color.a, "", 0, line)
        x_offset = x_offset + helper.measure_text("", line).x + padding
    end
end

local renderer_rectangle_rounded = function(x, y, w, h, r, g, b, a, radius)
	y = y + radius
	local datacircle = {
		{x + radius, y, 180},
		{x + w - radius, y, 90},
		{x + radius, y + h - radius * 2, 270},
		{x + w - radius, y + h - radius * 2, 0},
	}

	local data = {
		{x + radius, y, w - radius * 2, h - radius * 2},
		{x + radius, y - radius, w - radius * 2, radius},
		{x + radius, y + h - radius * 2, w - radius * 2, radius},
		{x, y, radius, h - radius * 2},
		{x + w - radius, y, radius, h - radius * 2},
	}

	for _, data in pairs(datacircle) do
		renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
	end

	for _, data in pairs(data) do
	   renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
	end
end

notify.render_bottom = function(self, index, visible_amount)
    local screen = screen
    local x, y = self.x - 5, self.y
    local padding = 10
    local w, h = self:width() + padding + 25, 20 + padding

    if globals.realtime() < self.delay then
        self.y = easing.quad_out(0.05, self.y, (( screen[2] - 30 ) - ( (visible_amount - index) * h*1.4 )) - self.y, 1)
        self.color.a = easing.quad_in(0.18, self.color.a, 255 - self.color.a, 1)
        self.recta = easing.quad_in(0.18, self.recta, 120 - self.recta, 1)
    else
        self.y = easing.quad_in(0.1, self.y, screen[2] - self.y, 1)
        self.color.a = easing.quad_out(0.07, self.color.a, 0 - self.color.a, 1)
        self.recta = easing.quad_out(0.07, self.recta, 0 - self.recta, 1)
        if self.color.a <= 2 then
            self.active = false
        end
    end

    
    local progress = math.max(0, (self.delay - globals.realtime()) / self.timeout)
    local bar_width = (w-10) * progress
    renderer_rectangle_rounded(x - w/2, y, w, h, 25, 25, 32, self.recta, 5)

    renderer.circle_outline(x + w/2 - 5 - padding, y + padding + 5, 15, 15, 22, self.color.a, 5, 0, 1, 2)
    renderer.circle_outline(x + w/2 - 5 - padding, y + padding + 5, self.color.r, self.color.g, self.color.b, self.color.a, 5, 0, progress, 2)
    self:render_text(x - w/2 + padding, y + h/2 - helper.measure_text("", table.concat(self.text, " ")).y/2)
end

local anti_backstab = {}
anti_backstab.abs_dist = function( x1, y1, z1, x2, y2, z2 )
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end
anti_backstab.abs = function( )
    local me = entity.get_local_player()
    if not me then return end

    if ui.get(angelwings.ui.misc.abs) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")

        if players == nil then return end

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = anti_backstab.abs_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(angelwings.ui.misc.abs_slider) then
                ui.set(angelwings.refs.aa.yaw_offset, 180)
                ui.set(angelwings.refs.aa.yaw_base, "At Targets")
            end
        end
    end
end

local function FreeStand()

    local c = player_state()
    local e = client.key_state(0x45)
    local air = includes(ui.get(angelwings.ui.aa.fs_multi), "Air") and (c == "air" or c == "air-duck")
    local slow = includes(ui.get(angelwings.ui.aa.fs_multi), "Slowmotion") and c == "slowmotion"
    local duck = includes(ui.get(angelwings.ui.aa.fs_multi), "Duck") and (c == "duck" or c == "duck+")
    local fd = includes(ui.get(angelwings.ui.aa.fs_multi), "Fake Duck") and ui.get(ref.FD)
    local manual = includes(ui.get(angelwings.ui.aa.fs_multi), "Manual") and var.dir ~= "reset"
    local defensive = includes(ui.get(angelwings.ui.aa.fs_multi), "Defensive") and c == "defensive"

    if ui.get(angelwings.ui.aa.fs_hk) and ui.get(angelwings.ui.aa.fs_check) and not air and not slow and not duck and not fd and not e and not manual and not defensive then
        var.fs = true
        ui.set(angelwings.refs.aa.freestanding, 'Default')
        ui.set(angelwings.refs.aa.freestanding_hk, 'Always on')
    else
        var.fs = false
        --ui.set(angelwings.refs.aa.freestanding, '-')
        ui.set(angelwings.refs.aa.freestanding_hk, 'On hotkey')
    end
end

local function EdgeYaw()
    if ui.get(angelwings.ui.aa.edge_hk) and ui.get(angelwings.ui.aa.edge_check) then
        ui.set(angelwings.refs.aa.edge_yaw, true)
    else
        ui.set(angelwings.refs.aa.edge_yaw, false)
    end
end

local function jump_scout(c)
    if not ui.get(angelwings.ui.misc.jumpscout) then return end
    local vel_x, vel_y = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local vel = math.sqrt(vel_x^2 + vel_y^2)
    ui.set(ref.AirStrafe, not (c.in_jump and (vel < 10)) or ui.is_menu_open())
end

local function discharge(c)
    if globals.realtime( ) - var.discharge < 0.4 then
        c.in_jump = false
        ui.set(ref.DT[1], true)
    end

    if not ui.get(angelwings.ui.misc.autodt) or not ui.get(angelwings.ui.misc.autodt_hk) then return end

    local charged = antiaim_funcs.get_tickbase_shifting( ) > 0
    if not charged then return end

    local lp = entity.get_local_player( )
    if not lp then return
    end

    local players = entity.get_all( "CCSPlayer" )
    local eye_pos = vector( client.eye_position( ) )

    local velocity = vector( entity.get_prop( lp, 'm_vecVelocity' ) )
    local extrapolation = 7 * globals.tickinterval( )
    local eye_pos_extrapolated = vector( eye_pos.x + velocity.x * extrapolation, eye_pos.y + velocity.y * extrapolation, eye_pos.z + velocity.z * extrapolation )

    for i = 1, #players do
        local player = players[ i ]

        if not entity.is_enemy( player ) or not entity.is_alive( player ) or entity.is_dormant( player ) or lp == player then
            goto skip
        end

        local pos = vector( entity.hitbox_position( player, 2 ) )
        local _velocity = vector( entity.get_prop( player, 'm_vecVelocity' ) )
        local pos_extrapolated = vector( pos.x + _velocity.x * extrapolation, pos.y + _velocity.y * extrapolation, pos.z + _velocity.z * extrapolation )

        local i_1, d_1 = client.trace_bullet( lp, eye_pos_extrapolated.x, eye_pos_extrapolated.y, eye_pos_extrapolated.z, pos.x, pos.y, pos.z, false )

        if i_1 and d_1 > 0 then
            ui.set(ref.DT[1], false)
            var.discharge = globals.realtime( )
            c.in_jump = false
            break
        end

        local i_2, d_2 = client.trace_bullet( lp, eye_pos_extrapolated.x, eye_pos_extrapolated.y, eye_pos_extrapolated.z, pos_extrapolated.x, pos_extrapolated.y, pos_extrapolated.z, false )

        if i_2 and d_2 > 0 then
            ui.set(ref.DT[1], false)
            var.discharge = globals.realtime( )
            c.in_jump = false
            break
        end

        ::skip::
    end
end

local function fastladder(c)
    if not ui.get(angelwings.ui.misc.fastladder) then return end
    local local_player = entity.get_local_player()
    local pitch, yaw = client.camera_angles()
    if entity.get_prop(local_player, "m_MoveType") == 9 then
        c.yaw = math.floor(c.yaw+0.5)
        c.roll = 0

        if c.forwardmove == 0 then
            c.pitch = 89
            c.yaw = c.yaw
        end

        if c.forwardmove > 0 then
            if pitch < 45 then
                c.pitch = 89
                c.in_moveright = 1
                c.in_moveleft = 0
                c.in_forward = 0
                c.in_back = 1
                if c.sidemove == 0 then
                    c.yaw = c.yaw + 90
                end
                if c.sidemove < 0 then
                    c.yaw = c.yaw + 150
                end
                if c.sidemove > 0 then
                    c.yaw = c.yaw + 30
                end
            end 
        end

        if c.forwardmove < 0 then
            c.pitch = 89
            c.in_moveleft = 1
            c.in_moveright = 0
            c.in_forward = 1
            c.in_back = 0
            if c.sidemove == 0 then
                c.yaw = c.yaw + 90
            end
            if c.sidemove > 0 then
                c.yaw = c.yaw + 150
            end
            if c.sidemove < 0 then
                c.yaw = c.yaw + 30
            end
        end
    end
end

local kill = {"♛ＺＥＭＩＲＡＧＥ ＣＲＥＷ♛","Ｄｏ ｎｏｔ ｔｅｓｔ ｍｙ ＡＡ．","ϯвøю ʍαʍαωӄყ øϯъεbαԉ прøςϯøрӈø", "ℙ𝕆𝕊𝕋 𝕋ℍ𝕀𝕊 𝕆ℕ ℙℝ𝕆𝔽𝕀𝕃𝔼𝕊 𝕆ℕ 𝕋ℍ𝔼 ℙ𝔼𝕆ℙ𝕃𝔼 𝕐𝕆𝕌 𝔸ℝ𝔼 ℝ𝕀ℂ𝔼ℍ𝔼ℝ 𝕋ℍ𝔸ℕ, 𝕋𝕆 ℂ𝔸𝕃𝕃 𝕋ℍ𝔼𝕄 ℙ𝕆𝕆ℝ! 𝕀𝔽 𝕐𝕆𝕌 𝔾𝕆𝕋 𝕋ℍ𝕀𝕊 ℂ𝕆𝕄𝕄𝔼ℕ𝕋... 𝕎𝔼𝕃𝕃... 𝕐𝕆𝕌 𝕂ℕ𝕆𝕎 𝕎ℍ𝔸𝕋 𝕀𝕋 𝕄𝔼𝔸ℕ𝕊! ♛ (◣_◢) ♛", "Ｆｏｒｃｅ Ｓａｆｅｐｏｉｎｔ ＝ Ｉｎｓｔａ Ｋｉｌｌ","Wʜᴇɴ I ᴀᴜᴛᴏ ᴡᴀʟʟ, ᴀʟʟ ᴅᴏɢs ᴀʀᴇ sɪʟᴇɴᴛ","Ｏｎｅ ｓｈｏｔ， ｏｎｅ ｋｉｌｌ．","Ｎｏ ｌｕｃｋ， ａｌｌ ｓｋｉｌｌ．","𝟙", "ʜαсτσяɰαя ɓρατɞα - ϶τσ ϱ∂υʜυʯы, κστσρыϱ υсησ᧘ьʒƴюτ ANGELWINGS", "оωиҕки - это докᴀзᴀтᴇльство тоrо, что ты ссᴀныи пидоᴘᴀс", "϶ᴛᴏ angelwings, чᴛᴏ я дᴧя ᴛᴇбя уᴋᴩᴀᴧ", "я подᴀᴘил им всᴇм звᴇздʏ, вᴇдь подᴀᴘил им angelwings", "Обычно, девочки любят сонечку чу, а мальчики — ангелвингс. Но это только до 17 лет. А потом всё становится наоборот.", "Прощать не сложно, сложно заново поверить.", "Запомни братишка одну благодать, тебя ждет не телка, а ангелвингс", "【﻿Ибу тя в подвале】", "кумарнул ♕Ｐ Ｏ Ｄ１Ｋ♕", "не вижу предела / angelwings", "𝕊𝕆ℝℝ𝕐 𝔾𝕌𝕐𝕊 ｡.｡:+*", "MaJIeHkuu_Ho_OnacHekuu",  "ⒶaŴÞ ︻デ 一 PUTIN", 
"♛ｇｈｆｄｂｋｆ ♛", "ＳＯＳＩ ＭＯＹ ＣＨＯＰＰＡ ＣＨＵＰＳ",  "𝒰 𝒢О𝒯 ♡𝒲𝒩𝐸𝒟 𝑀𝒴 ангельские крылья", ":･ﾟ✧𝐅𝐔𝐂𝐊 𝐘𝐎𝐔","✧･ﾟ𝕂𝕐𝕊","♛ 𝕃𝕚𝕟𝕜 𝕞𝕒𝕚𝕟 𝕓𝕖𝕗𝕠𝕣𝕖 𝕤𝕡𝕖𝕒𝕜𝕚𝕟𝕘. ♛",  "♛ 𝕋𝕙𝔼 𝕘𝕃𝕠𝔹𝕒𝕃 𝕖𝕃𝕚𝕋𝕖 𝕄𝕒𝕊𝕥𝔼𝕣 𝕊𝕠𝕆𝕟 𝕋𝕄 ♛", "𝕚 𝕒𝕞 𝕙𝕧𝕙 𝕨𝕚𝕟𝕟𝕖𝕣 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝟙𝟙 𝕒𝕟𝕕 𝕤𝕙𝕒𝕕𝕠𝕨 𝕕𝕒𝕘𝕘𝕖𝕣𝕤 𝕣𝕦𝕤𝕥 𝕔𝕠𝕒𝕥 𝕔𝕠𝕞𝕚𝕟𝕘 𝕤𝕠𝕠𝕟", "˜”*°•.˜”*°• suck dick iqless doG •°*”˜.•°*”˜", "ₓ˚. ୭ ˚○◦˚𝒾𝓆𝓁𝑒𝓈𝓈 𝒹𝑜𝑔˚◦○˚ ୧ .˚ₓ",
"♛ ＳＵＳＳＹ ＢＡＬＬＳ ♛", "”*°•.★..Angel_Of_The_Night..★.•°*”˜ :", "𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕚𝕤 𝕙𝕠𝕨 𝕨𝕖 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖 ♛ 𝕞𝕒𝕜𝕖 𝕣𝕚𝕔𝕙 𝕞𝕒𝕚𝕟𝕤, 𝕟𝕠𝕥 𝕗𝕣𝕚𝕖𝕟𝕕𝕤", "ⒶaŴÞ ︻デ 一", 
"Draining rn // cant 𝑅𝑒𝓅𝓁𝓎", "Ｉ ＝ ＡＮＧＥＬＷＩＮＧＳ ， Ｕ － ＮＯ ＣＨＡＮＳ", "ｄｏ ｙｏｕ ｋｉｔｔｅｎ ｍｅ ｒｉｇｈｔ ｍｅｏｗ", "𝖜𝖎𝖘𝖊 𝖎𝖘 𝖓𝖔𝖙 𝖆𝖑𝖜𝖆𝖞𝖘 𝖜𝖎𝖘𝖊",
"Ищи себя в овердоузед дрейнерши","cya в подслушано мемесенс", "Ебать тебя козявит", "VAAAAAAAC в чат!!! (づ ◕‿◕ )", "3Jlou_ЗAdrOT", "ñüѫ¤Ƥ ñüƺѫå ϯÿƺ ɱ¤н¤ȹя", "♛Ａｌｌ Ｆａｍｉｌｙ ｉｎ ｎｏｖｏ♛", ";w;","=w=", "𝕪𝕠𝕦𝕣 𝕒𝕟𝕥𝕚𝕒𝕚𝕞 𝕤𝕠𝕝𝕧𝕖𝕕 𝕝𝕚𝕜𝕖 𝕒𝕝𝕘𝕖𝕓𝕣𝕒 𝕖𝕢𝕦𝕒𝕥𝕚𝕠𝕟", "ęβãł țýä √ řøţ", "AHHAHAHHAHAHH LIFEHACK ♥♥♥♥♥", "ПуЛи_От_БаБуЛи", "ПаРеНь БеЗ сТрАхА", "づ 从闩从长丫 仨五闩人", "1000-7 🅷🆅🅷", 
"ñƤüβ£ϯ ΨнӹƤь ϯ£ნя £ნ£ϯ j£§ɥ§","忍び 1 УПАЛ び忍", "THIS nigga is so retarded", "(◣◢) 𝕐𝕠𝕦 𝕒𝕨𝕒𝕝𝕝 𝕗𝕚𝕣𝕤𝕥? 𝕆𝕜 𝕝𝕖𝕥𝕤 𝕗𝕦𝕟 🙂", "𝕚 𝕒𝕞 𝕙𝕧𝕙 𝕨𝕚𝕟𝕟𝕖", "𝙢𝙖𝙠𝙚 𝙨𝙠𝙚𝙚𝙩 𝙣𝙤 𝙛𝙧𝙞𝙚𝙣𝙙𝙨", "ａｌｌ　ｆａｍｉｌｙ　ａｗａｌｌ　ロく河", "𝘄𝗵𝗲𝗻 𝗶 𝗽𝗹𝗮𝘆 𝗺𝗮𝗶𝗻 𝗶 𝗰𝗮𝗿𝗲 𝗳𝗼𝗿 𝘀𝗺𝗼𝗸𝗲", 
"ᴋᴏᴦдᴀ ᴛы ᴨᴩᴀʙ, ниᴋᴛᴏ ϶ᴛᴏᴦᴏ нᴇ ɜᴀᴨᴏʍинᴀᴇᴛ, ᴀ ᴋᴀᴋ ᴏɯибᴄя - ɜнᴀчиᴛ быᴧ бᴇɜ angelwings.pink",
'Эᴛᴏ ᴩᴇдᴋᴏᴄᴛь - чᴇᴧᴏʙᴇᴋ, хᴄᴀющий angelwings',
'ɜᴀ ᴋᴀждᴏй уᴄᴨᴇɯнᴏй жᴇнщинᴏй ᴄᴛᴏиᴛ ᴨᴩᴇдᴀᴛᴇᴧьᴄᴛʙᴏ ʍужчин, ɜᴀ ᴋᴀждыʍ уᴄᴨᴇɯныʍ ʍужчинᴏй ᴄᴛᴏиᴛ ᴄᴛᴀᴋ ᴄ angelwings.pink',
'ᴏ жиɜни и дᴇньᴦᴀх нᴀчинᴀюᴛ дуʍᴀᴛь, ᴋᴏᴦдᴀ ʙ их жиɜни ᴨᴏяʙᴧяᴇᴛᴄя angelwings.pink',
'ᴇᴄᴧи у ᴛᴇбя хᴏᴩᴏɯᴇᴇ нᴀᴄᴛᴩᴏᴇниᴇ, ᴛᴏ дᴧя ᴨᴏᴧнᴏᴦᴏ ᴄчᴀᴄᴛья ᴛᴏᴧьᴋᴏ angelwings.pink нᴇ хʙᴀᴛᴀᴇᴛ',
'ᴧюди ᴛᴏжᴇ ᴄᴛᴩᴀдᴀюᴛ, ᴏᴛᴛᴏᴦᴏ, чᴛᴏ у них нᴇᴛ angelwings.pink',
'быᴛь бᴏᴦᴀᴛыʍ и иʍᴇᴛь ʍнᴏᴦᴏ дᴇнᴇᴦ нᴇ ᴏднᴏ и ᴛᴏ жᴇ, ᴨᴏ нᴀᴄᴛᴏящᴇʍу бᴏᴦᴀᴛ, ᴛᴏᴛ ᴋᴛᴏ иʍᴇᴇᴛ angelwings.pink',
'ᴧюди нᴇ хᴏᴛяᴛ быᴛь бᴏᴦᴀᴛыʍи, ᴧюди хᴏᴛяᴛ angelwings.pink',
'бᴇднᴏʍу нужᴇн ʍиᴧᴧиᴏн, бᴏᴦᴀᴛᴏʍу нужᴇн angelwings.pink',
'ᴋᴛᴏ иʍᴇᴇᴛ angelwings.pink, ᴛᴏᴛ ʙᴄᴇᴦдᴀ дᴏᴄᴛᴀᴛᴏчнᴏ бᴏᴦᴀᴛ',
'нᴇ ᴄᴨᴏᴩь ᴄᴏ ʍнᴏй, angelwings.pink нᴇᴨᴏбᴇдиʍᴀ.',
'дᴇᴛᴄᴛʙᴏ ɜᴀᴋᴀнчиʙᴀᴇᴛᴄя ᴛᴏᴦдᴀ, ᴋᴏᴦдᴀ у ᴛᴇбя ᴨᴏяʙᴧяᴇᴛᴄя angelwings.pink',
'ʙ ʍᴏᴇʍ дᴇᴛᴄᴛʙᴇ нᴇ быᴧᴏ ʍᴏбиᴧьных ᴛᴇᴧᴇɸᴏнᴏʙ и инᴛᴇᴩнᴇᴛᴀ, нᴏ я ʙᴄᴇᴦдᴀ ɜнᴀᴧ, чᴛᴏ angelwings.pink будᴇᴛ ᴧучɯᴇй.' ,
'ниᴋᴏᴦдᴀ нᴇ ᴨᴏɜднᴏ уᴄᴛᴩᴏиᴛь ᴄᴇбᴇ ᴄчᴀᴄᴛᴧиʙую жиɜнь, и ᴨᴩиᴋуᴨиᴛь angelwings.pink',
'ᴄᴀʍᴀя бᴏᴧьɯᴀя ᴨᴏᴛᴇᴩя дᴧя чᴇᴧᴏʙᴇᴋᴀ, ϶ᴛᴏ ᴨᴏᴛᴇᴩя angelwings.pink',
'ʙ дᴇᴛᴄᴛʙᴇ дᴧя ᴄчᴀᴄᴛья быᴧᴏ дᴏᴄᴛᴀᴛᴏчнᴏ ᴏднᴏᴦᴏ ʍᴏᴩᴏжᴇнᴏᴦᴏ, ᴄᴇйчᴀᴄ жᴇ ʙᴄᴇʍ нᴀʍ нужᴇн angelwings.pink',
'ни у ᴋᴏᴦᴏ жиɜнь нᴇ быʙᴀᴇᴛ ᴛᴀᴋᴏй, ᴋᴀᴋ у ᴧюдᴇй ᴄ angelwings.pink',
'дᴏбᴩый чᴇᴧᴏʙᴇᴋ нᴇ ᴛᴏᴛ, ᴋᴛᴏ уʍᴇᴇᴛ дᴇᴧᴀᴛь дᴏбᴩᴏ, ᴀ ᴛᴏᴛ, у ᴋᴏᴦᴏ ᴇᴄᴛь angelwings.pink',
'ɜнᴀᴇɯь, чᴛᴏ ᴨуᴦᴀᴇᴛ бᴏᴧьɯᴇ ʙᴄᴇᴦᴏ, ᴋᴩᴏʍᴇ ᴄᴛᴩᴀхᴀ ᴏᴄᴛᴀᴛьᴄя ᴏднᴏʍу? ᴨᴩᴏʙᴇᴄᴛи ʙᴄю жиɜнь бᴇɜ angelwings.pink',
'я ʍнᴏᴦᴏ ᴄᴛᴩᴀдᴀᴧ, я ʙᴄᴇᴦдᴀ ᴏɯибᴀᴧᴄя, ʙᴇдь я быᴧ бᴇɜ angelwings.pink',
'ʍы ᴧᴇᴦᴋᴏ ɜᴀбыʙᴀᴇʍ ᴄʙᴏи ᴏɯибᴋи, ᴋᴏᴦдᴀ ᴨᴏᴋуᴨᴀᴇʍ angelwings.pink',
'ниᴋᴏᴦдᴀ нᴇ ᴄᴧᴇдуᴇᴛ ᴦᴏʙᴏᴩиᴛь ᴋᴏʍу-ᴧибᴏ, чᴛᴏ ᴏн нᴇ ᴨᴩᴀʙ, ᴀ чᴛᴏ ᴏн ᴧиɯь ᴄᴄᴀный хуᴇᴄᴏᴄ бᴇɜ angelwings.pink',
'ᴦᴧᴀʙнᴏᴇ дᴧя ʍужчины - иʍᴇᴛь angelwings.lua',
'ᴄᴀʍᴀя ʙᴩᴇднᴀя ᴏɯибᴋᴀ - ϶ᴛᴏ нᴇ ʙᴇᴩиᴛь чᴛᴏ angelwings.pink ᴧучɯᴇ ʙᴄᴇх',
"я ķ¤нɥåλ ϯβ¤£ü ɱåɱķ£ β Ƥ¤ϯ.",'•۩۞۩[̲̅П̲̅о̲̅Л̲̅Ю̲̅б̲̅А̲̅С(ٿ)̲̅Ч̲̅и̅Т̲̲̅АК̲̅]۩۞۩•','YбИuЦа_КрИпЕrОв','+Yeb@shu_v_k@shu+','Н.Е.С.О.К.Р.У.Ш.И.М.Ы.Й','KpyToI_4elOBeK',"𝖋𝖊𝖊𝖑 𝖙𝖍𝖊 𝖋𝖚𝖈𝖐𝖎𝖓𝖌 𝖌𝖆𝖒𝖊𝖘𝖊𝖓𝖘𝖊", "𝔱𝔥𝔢 𝔰𝔱𝔲𝔣𝔣 𝔶𝔬𝔲 𝔥𝔢𝔞𝔯𝔡 𝔞𝔟𝔬𝔲𝔱 𝔪𝔢 𝔦𝔰 𝔞 𝔩𝔦𝔢 ℑ 𝔞𝔪 𝔪𝔬𝔯𝔢 𝔴𝔬𝔯𝔰𝔢 𝔱𝔥𝔞𝔫 𝔶𝔬𝔲 𝔱𝔥𝔦𝔫𝔨", "𝔗𝔥𝔢 𝔬𝔫𝔩𝔶 𝔠𝔯𝔦𝔪𝔢 𝔦𝔫 𝔥𝔳𝔥 𝔦𝔰 𝔱𝔬 𝔩𝔬𝔰𝔢",  "☆꧁✬◦°˚°◦. ɮʏ ɮɛֆȶ ʟʊǟ .◦°˚°◦✬꧂☆", "vroom vroom! по ЕБУЧКЕ",'(◣◢)𝕚 𝕕𝕠𝕟𝕥 𝕔𝕒𝕣𝕖 𝕗𝕠𝕣 𝕤𝕞𝕠𝕜𝕖, 𝕚 𝕒𝕞 𝕟𝕠𝕥 𝕞𝕒𝕚𝕟. (◣◢)',"𝙒𝙝𝙚𝙣 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙈𝙈 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙛𝙤𝙧 𝙬𝙞𝙣, 𝙙𝙤𝙣'𝙩 𝙨𝙘𝙖𝙧𝙚 𝙛𝙤𝙧 𝙨𝙥𝙞𝙣, 𝙞 𝙞𝙣𝙟𝙚𝙘𝙩 𝙧𝙖𝙜𝙚 ♕", '𝕚𝕞 𝕨𝕚𝕟 𝕚𝕗 𝕚𝕞 𝕨𝕒𝕟𝕥. 𝕞𝕪 𝕤𝕡𝕚𝕟𝕓𝕠𝕥 𝕒𝕔𝕥𝕚𝕧𝕒𝕥𝕖𝕕 𝕟𝕠 𝕔𝕙𝕒𝕟𝕔𝕖 𝕗𝕠𝕣 𝕖𝕟𝕖𝕞𝕪', "𝙽𝚒𝚐𝚑𝚝𝚌𝚘𝚛𝚎𝚍", "BY ANGELWINGS 美國人 ? WACHINA ( TEXAS ) يورپ technologies","god wish i had ANGELWINGS $$$","𝕗𝕦𝕔𝕜 𝕪𝕠𝕦𝕣 𝕗𝕒𝕞𝕚𝕝𝕪 𝕒𝕟𝕕 𝕗𝕣𝕚𝕖𝕟𝕕𝕤, 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕦𝕡 ♚","𝐨𝐮𝐫 𝐥𝐢𝐟𝐞 𝐦𝐨𝐭𝐨 𝐢𝐬 𝐖𝐈𝐍 > 𝐀𝐂𝐂","꧁༺rJloTau mOu Pir()zh()]{ (c) SoSiS]{oY:XD ", "𝒪𝒱𝐸𝑅𝒟𝒪𝒮𝐸𝒟 𝐻𝒰𝐼𝒮𝒪𝒮", "＄＄＄ ｒｉｃｈ ｍｙ angelwings ＄＄＄","Чо папе чо маме?",'Сасеш как снеговик', '𝔂𝓸𝓾 𝓭𝓸𝓷𝓽 𝓷𝓮𝓮𝓭 𝓯𝓻𝓲𝓮𝓷𝓭𝓼 𝔀𝓱𝓮𝓷 𝔂𝓸𝓾 𝓱𝓪𝓿𝓮 𝓷𝓸𝓿𝓸𝓵𝓲𝓷𝓮𝓱𝓸𝓸𝓴','𝚜𝚎𝚖𝚒𝚛𝚊𝚐𝚎 𝚝𝚒𝚕𝚕 𝚢𝚘𝚞 𝚍𝚒𝚎, 𝚋𝚞𝚝 𝚠𝚎 𝚕𝚒𝚟𝚎 𝚏𝚘𝚛𝚎𝚟𝚎𝚛 (◣_◢)',"𝕝𝕚𝕗𝕖 𝕚𝕤 𝕒 𝕘𝕒𝕞𝕖, 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕚𝕤 𝕙𝕠𝕨 𝕨𝕖 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖 ♛ 𝕞𝕒𝕜𝕖 𝕣𝕚𝕔𝕙 𝕞𝕒𝕚𝕟𝕤, 𝕟𝕠𝕥 𝕗𝕣𝕚𝕖𝕟𝕕𝕤", 
"𝙒𝙝𝙚𝙣 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙈𝙈 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙛𝙤𝙧 𝙬𝙞𝙣, 𝙙𝙤𝙣'𝙩 𝙨𝙘𝙖𝙧𝙚 𝙛𝙤𝙧 𝙨𝙥𝙞𝙣, 𝙞 𝙞𝙣𝙟𝙚𝙘𝙩 𝙧𝙖𝙜𝙚 ♕", 
"𝒯𝒽𝑒 𝓅𝓇𝑜𝒷𝓁𝑒𝓂 𝒾𝓈 𝓉𝒽𝒶𝓉 𝒾 𝑜𝓃𝓁𝓎 𝒾𝓃𝒿𝑒𝒸𝓉 𝒸𝒽𝑒𝒶𝓉𝓈 𝑜𝓃 𝓂𝓎 𝓂𝒶𝒾𝓃 𝓉𝒽𝒶𝓉 𝒽𝒶𝓋𝑒 𝓃𝒶𝓂𝑒𝓈 𝓉𝒽𝒶𝓉 𝓈𝓉𝒶𝓇𝓉 𝓌𝒾𝓉𝒽 𝒩 𝒶𝓃𝒹 𝑒𝓃𝒹 𝓌𝒾𝓉𝒽 𝑜𝓋𝑜𝓁𝒾𝓃𝑒𝒽𝑜𝑜𝓀", 
"(◣◢) 𝕐𝕠𝕦 𝕒𝕨𝕒𝕝𝕝 𝕗𝕚𝕣𝕤𝕥? 𝕆𝕜 𝕝𝕖𝕥𝕤 𝕗𝕦𝕟 🙂 (◣◢)", 
"ｉ ｃａｎｔ ｌｏｓｅ ｏｎ ｏｆｆｉｃｅ ｉｔ ｍｙ ｈｏｍｅ", 
"𝕞𝕒𝕚𝕟 𝕟𝕖𝕨= 𝕔𝕒𝕟 𝕓𝕦𝕪.. 𝕙𝕧𝕙 𝕨𝕚𝕟? 𝕕𝕠𝕟𝕥 𝕥𝕙𝕚𝕟𝕜 𝕚𝕞 𝕔𝕒𝕟, 𝕚𝕞 𝕝𝕠𝕒𝕕 𝕣𝕒𝕘𝕖 ♕", 
"♛Ａｌｌ   Ｆａｍｉｌｙ   ｉｎ   ｎｏｖｏ♛", 
"u will 𝕣𝕖𝕘𝕣𝕖𝕥 rage vs me when i go on ｌｏｌｚ．ｇｕｒｕ acc.", 
"𝔻𝕠𝕟𝕥 𝕒𝕕𝕕 𝕞𝕖 𝕥𝕠 𝕨𝕒𝕣 𝕠𝕟 𝕞𝕪 𝕤𝕞𝕦𝕣𝕗 (◣◢) 𝕟𝕠𝕧𝕠𝕝𝕚𝕟𝕖 𝕒𝕝𝕨𝕒𝕪𝕤 𝕣𝕖𝕒𝕕𝕪 ♛", 
"♛ 𝓽𝓾𝓻𝓴𝓲𝓼𝓱 𝓽𝓻𝓾𝓼𝓽 𝓯𝓪𝓬𝓽𝓸𝓻 ♛", 
"𝕕𝕦𝕞𝕓 𝕕𝕠𝕘, 𝕪𝕠𝕦 𝕒𝕨𝕒𝕜𝕖 𝕥𝕙𝕖 ᴅʀᴀɢᴏɴ ʜᴠʜ ᴍᴀᴄʜɪɴᴇ, 𝕟𝕠𝕨 𝕪𝕠𝕦 𝕝𝕠𝕤𝕖 𝙖𝙘𝙘 𝕒𝕟𝕕 𝚐𝚊𝚖𝚎 ♕", 
"♛ 𝕞𝕪 𝕙𝕧𝕙 𝕥𝕖𝕒𝕞 𝕚𝕤 𝕣𝕖𝕒𝕕𝕪 𝕘𝕠 𝟙𝕩𝟙 𝟚𝕩𝟚 𝟛𝕩𝟛 𝟜𝕩𝟜 𝟝𝕩𝟝 (◣◢)", 
"ᴀɢᴀɪɴ ɴᴏɴᴀᴍᴇ ᴏɴ ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ. ɪ ꜱᴇᴇ ᴀɢᴀɪɴ ᴀᴄᴛɪᴠɪᴛʏ.", 
"ɴᴏɴᴀᴍᴇ ʟɪꜱᴛᴇɴ ᴛᴏ ᴍᴇ ! ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ ɪꜱ ɴᴏᴛ ʏᴏᴜʀ ᴘʀᴏᴘᴇʀᴛʏ.", 
"𝙋𝙤𝙤𝙧 𝙖𝙘𝙘 𝙙𝙤𝙣’𝙩 𝙘𝙤𝙢𝙢𝙚𝙣𝙩 𝙥𝙡𝙚𝙖𝙨𝙚 ♛", 
"𝕥𝕣𝕪 𝕥𝕠 𝕥𝕖𝕤𝕥 𝕞𝕖? (◣◢) 𝕞𝕪 𝕞𝕚𝕕𝕕𝕝𝕖 𝕟𝕒𝕞𝕖 𝕚𝕤 𝕘𝕖𝕟𝕦𝕚𝕟𝕖 𝕡𝕚𝕟 ♛", 
"𝓭𝓸𝓷𝓽 𝓝𝓝", 
"ℕ𝕠 𝕆𝔾 𝕀𝔻? 𝔻𝕠𝕟'𝕥 𝕒𝕕𝕕 𝕞𝕖 𝓷𝓲𝓰𝓰𝓪", 
"𝐻𝒱𝐻 𝐿𝑒𝑔𝑒𝓃𝒹𝑒𝓃 𝟤𝟢𝟤𝟤 𝑅𝐼𝒫 𝐿𝒾𝓁 𝒫𝑒𝑒𝓅 & 𝒳𝓍𝓍𝓉𝑒𝒶𝓃𝒸𝒾𝑜𝓃 & 𝒥𝓊𝒾𝒸𝑒 𝒲𝓇𝓁𝒹", 
"𝕚 𝕟𝕠𝕧𝕠 𝕦𝕤𝕖𝕣, 𝕟𝕠 𝕟𝕠𝕧𝕠 𝕟𝕠 𝕥𝕒𝕝𝕜", 
"𝐨𝐮𝐫 𝐥𝐢𝐟𝐞 𝐦𝐨𝐭𝐨 𝐢𝐬 𝐖𝐈𝐍 > 𝐀𝐂𝐂", 
"𝕗𝕦𝕔𝕜 𝕪𝕠𝕦𝕣 𝕗𝕒𝕞𝕚𝕝𝕪 𝕒𝕟𝕕 𝕗𝕣𝕚𝕖𝕟𝕕𝕤, 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕦𝕡 ♚", 
"𝚜𝚎𝚖𝚒𝚛𝚊𝚐𝚎 𝚝𝚒𝚕𝚕 𝚢𝚘𝚞 𝚍𝚒𝚎, 𝚋𝚞𝚝 𝚠𝚎 𝚕𝚒𝚟𝚎 𝚏𝚘𝚛𝚎𝚟𝚎𝚛 (◣◢)", 
"𝔂𝓸𝓾 𝓭𝓸𝓷𝓽 𝓷𝓮𝓮𝓭 𝓯𝓻𝓲𝓮𝓷𝓭𝓼 𝔀𝓱𝓮𝓷 𝔂𝓸𝓾 𝓱𝓪𝓿𝓮 𝓷𝓸𝓿𝓸𝓵𝓲𝓷𝓮𝓱𝓸𝓸𝓴", 
"-ᴀᴄᴄ? ᴡʜᴏ ᴄᴀʀꜱ ɪᴍ ʀɪᴄʜ ʜʜʜʜʜʜ", 
"𝕙𝕖𝕙𝕖𝕙𝕖, 𝕦 𝕘𝕣𝕒𝕓 𝕞𝕪 𝕗𝕒𝕝𝕝 𝕘𝕦𝕪𝕤 𝕔𝕙𝕒𝕣𝕒𝕔𝕥𝕖𝕣? 𝕚 𝕘𝕣𝕒𝕓 𝕦𝕣 𝕓𝕒𝕟𝕜 𝕕𝕖𝕥𝕒𝕚𝕝𝕤. ♛", 
"𝔾𝕖𝕥 𝕕𝕖𝕒𝕝𝕥 𝕨𝕚𝕥𝕙 𝕝𝕚𝕥𝕥𝕝𝕖 𝕓𝕠𝕪, 𝕤𝕠 𝕤𝕚𝕞𝕡𝕝𝕖, 𝕕𝕠𝕟'𝕥 𝕖𝕧𝕖𝕣 𝕒𝕡𝕡𝕣𝕠𝕒𝕔𝕙 𝕞𝕖𝕞𝕓𝕖𝕣𝕤 𝕠𝕗 𝕞𝕪 𝕥𝕖𝕒𝕞 𝕝𝕚𝕜𝕖 𝕥𝕙𝕒𝕥 𝕖𝕧𝕖𝕣 𝕒𝕘𝕒𝕚𝕟. ♛", 
"𝕠𝕟𝕖 𝕕𝕒𝕪, 𝕪𝕠𝕦 𝕨𝕚𝕝𝕝 𝕓𝕖 𝕗𝕠𝕣𝕘𝕠𝕥. 𝕓𝕦𝕥 𝕟𝕠𝕥 𝕞𝕖. 𝕞𝕪 𝕤𝕖𝕞𝕚𝕣𝕒𝕘𝕖 𝕔𝕒𝕡𝕒𝕓𝕚𝕝𝕚𝕥𝕪 𝕨𝕚𝕝𝕝 𝕘𝕠 𝕕𝕠𝕨𝕟 𝕚𝕟 𝕥𝕙𝕖 𝕙𝕚𝕤𝕥𝕠𝕣𝕪 𝕓𝕠𝕠𝕜𝕤 𝕗𝕠𝕣 𝕪𝕠𝕦𝕟𝕘 𝕥𝕠 𝕝𝕖𝕒𝕣𝕟 ♛", 
"𝕪𝕠𝕦 𝕝𝕚𝕤𝕥𝕖𝕟 𝕔𝕒𝕣𝕕𝕚 𝕓? 𝕨𝕖𝕝𝕝, 𝕚 𝕒𝕞 𝕔𝕒𝕣𝕕𝕖𝕣 𝕓, 𝕝𝕚𝕤𝕥𝕖𝕟 𝕞𝕖 𝕕𝕠𝕘 ♛", 
"𝕨𝕙𝕖𝕟 𝕞𝕖 𝕒𝕟𝕕 𝕞𝕪 𝕤𝕥𝕒𝕔𝕜 𝕙𝕚𝕥 𝕥𝕙𝕖 𝕤𝕖𝕞𝕚𝕣𝕒𝕘𝕖 𝕤𝕥𝕣𝕖𝕖𝕥𝕤, 𝕨𝕖𝕝𝕝, 𝕚𝕥 𝕨𝕒𝕤 𝕒 𝕘𝕒𝕟𝕘𝕓𝕒𝕟𝕘…", 
"𝕚𝕥𝕤 𝕒𝕝𝕨𝕒𝕪𝕤 ℕℕ 𝕟𝕖𝕧𝕖𝕣 𝕣𝕖𝕒𝕕𝕪 𝕗𝕠𝕣 𝕥𝕙𝕖 𝕤𝕖𝕞𝕚𝕣𝕒𝕘𝕖 𝕤𝕥𝕣𝕖𝕖𝕥𝕤 (◣︵◢)", 
"𝕄𝕪 𝕙𝕒𝕧𝕖 𝕔𝕙𝕖𝕒𝕥 𝕚𝕥𝕤 𝕟𝕠𝕧𝕠", 
"𝕟𝕠 𝕜𝕚𝕥𝕥𝕪 𝕝𝕦𝕒 𝕟𝕠 𝕥𝕒𝕝𝕜𝕚𝕟𝕘 (◣◢)", 
"𝕪𝕠𝕦 𝕡𝕒𝕪 𝕤𝕦𝕓 𝕗𝕠𝕣 𝟚𝟝$? 𝕞𝕪 𝕟𝕚𝕩𝕨𝕒𝕣𝕖 𝕔𝕠𝕤𝕥 𝟛$ 𝕒𝕟𝕕 𝕚 𝕠𝕣𝕕𝕖𝕣 𝟛 𝕡𝕚𝕫𝕫𝕒 𝕨𝕙𝕖𝕟 𝕚𝕞 𝕕𝕖𝕤𝕥𝕣𝕠𝕪 𝕪𝕠𝕦 𝕚𝕟 𝕞𝕞 (◣◢)", 
"𝟛 𝕕𝕒𝕪𝕤 𝕒𝕟𝕕 𝕟𝕠 𝕟𝕚𝕩𝕨𝕒𝕣𝕖 𝕔𝕗𝕘 𝕚𝕞 𝕥𝕙𝕚𝕟𝕜 𝕚𝕤 𝕪𝕠𝕦 𝕤𝕥𝕦𝕡𝕚𝕕?♛", 
"𝕚𝕗 𝕪𝕠𝕦 𝕘𝕣𝕖𝕨 𝕦𝕡 𝕚𝕟 𝕙𝕖𝕝𝕝, 𝕥𝕙𝕖𝕟 𝕠𝕗𝕔 𝕪𝕠𝕦 𝕒𝕣𝕖 𝕘𝕠𝕚𝕟𝕘 𝕥𝕠 𝕤𝕚𝕟 (◣◢)", 
"𝕨𝕙𝕖𝕟 𝕕𝕠𝕘𝕤 𝕕𝕠𝕟𝕥 𝕨𝕒𝕟𝕥 𝕙𝕖𝕒𝕕 𝕒𝕚𝕞𝕤 𝕠𝕟𝕝𝕪 𝕕𝕠 𝕓𝕠𝕕𝕪 𝕒𝕚𝕞𝕤 𝕟𝕠𝕥𝕙𝕚𝕟𝕘 𝕗𝕠𝕣 𝕥𝕖𝕒𝕞 𝕚𝕟 𝟝𝕧𝟝 𝕠𝕟𝕝𝕪 𝕘𝕠 𝕗𝕠𝕣 𝕓𝕒𝕚𝕞𝕤", 
"𝕞𝕒𝕪 𝕘𝕠𝕕 𝕗𝕠𝕣𝕘𝕚𝕧𝕖 𝕪𝕠𝕦 𝕓𝕦𝕥 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕨𝕠𝕟𝕥", 
"𝕦 𝕘𝕦𝕪𝕤 𝕞𝕒𝕜𝕖 𝕗𝕦𝕟 𝕨𝕙𝕚𝕝𝕖 𝕚 𝕞𝕒𝕜𝕖 𝕨𝕚𝕟𝕤 ♚", "THE demon inside of me is 𝙛𝙧𝙚𝙚𝙨𝙩𝙖𝙣𝙙𝙞𝙣𝙜", "Бесплатная голда и дешёвые аккаунты в стандофф? Тебе сюда! Чек описание тг: @keybinding", "Бесплатная голда и дешёвые аккаунты в стандофф? Тебе сюда! —————————> vk.com/vampire",
"最好的vk.com/vampire 中国的女孩", "ıllıllı 𝐒𝐇𝐀𝐌𝐀𝐍 - Я РУССКИЙ ıllıllı", "ищи сайт vk. com/fruit и Малышки из школы иwи у нас на сайте в названии канала sch", "Не позволю себе умерать бедным. 𝑪𝒚𝒂 2023 𝒅𝒐𝒈𝒔", "☞𝐘𝐞𝐧𝐬𝐝𝐞𝐲 𝐀𝐝𝐝𝐚𝐦𝐬☜ *твой_е6ырь*",
"─═ڿڰۣڿ☻ڿڰۣڿ═─͟х͟а͟б͟и͟п͟ ͟м͟а͟ц͟у͟к͟е͟в͟и͟ч͟ ꧂", "▄︻デ══━一 𝒅𝒂𝒓𝒌 𝒃𝒓𝒆𝒍𝒆𝒂𝒏𝒕 𝒌𝒐𝒓𝒔𝒆𝒔", "(っ◔◡◔)っ ♥ вижу фаната код10 -> хей броу скок см челочка❓ ♥", "ıllıllı 𝐂𝐀𝐏𝐈𝐓𝐀𝐋 𝐁𝐑𝐀 ஜ۩۞۩ஜ","ıllıllı ▄︻デ𝐂𝐀𝐏𝐈𝐓𝐀𝐋 𝐁𝐑𝐀══━一 ஜ۩۞۩ஜ", "наш publik+14 adminka-30грн наш сайт - http://vk.com/try2hard кто захочит капить адмику обращайтесь - https://vk.com/vampire ",
"█║►АХУЕННАЯ стрельба.", ".::НоВоСиБиРсК::.", "¸¸♬·¯·♩ ▄︻デ𝐑𝐀𝐅 𝐂𝐀𝐌𝐎𝐑𝐀══━一 ♫♪♩·.¸¸.·", "★·.·´¯`·.·★ 🅐🅚 🅐🅤🅢🅢🅔🅡🅚🅞🅝🅣🅡🅞🅛🅛🅔  ☆☆╮","Комбинированный маникюр с покрытием - 500 рублей. Телеграмм для связи t.me/keybinding", "Продаются щенки самоедкой лайки, рождённые 03.12.2022. Все вопросы по содержанию, уходу в личные сообщения! -> vk.com/vampire",
"не с кем пообщаться, в жизни нᴇт дᴘʏзᴇй? пиши - vk.com/vampire // всегда рада тебе ^_^", "—нᴇ ҕᴇдᴀ,ᴇсли нᴇт дᴘʏзᴇй, ҕᴇдᴀ,ᴇсли они фᴀльшивыᴇ и пᴘодᴀжныᴇ🫀  (C) vk.com/vampire", "главний админ pro.JOKER **DEN(vk.com/try2hard)*","⚡vk.com/vampire наглядно объяснил о важности angelwings в HvH",
"Tиктокершу заставили снять это, видео успели сохранить... Выложили по ссылке в комментах -> vk.com/vampire", "ｔ．ｍｅ／ｋｅｙｂｉｎｄｉｎｇ", "(っ◔◡◔)っ ♥ t.me/keybinding ♥", "【﻿ｔ．ｍｅ／ｋｅｙｂｉｎｄｉｎｇ】", "˜”*°•.˜”*°• t.me/keybinding •°*”˜.•°*”˜", "ＭＡＶＥＲＩＣＫ ｔｏｕｒｎａｍｅｎｔ ｈｉｇｈｌｉｇｈｔｓ ｆｔ ｇａｍｅｓｅｎｓｅ．ｐｕｂ ／ ｓｋｅｅｔ．ｃｃ",
"χợ੫℮ᗯѣ ∂℮τсķợ℮ ʙ ᥰ᧐ᥙᥴκu -> vk.com/try2hard", "χợ੫℮ᗯѣ ∂℮τсķợ℮ ʙ ᥰ᧐ᥙᥴκu -> vk.com/vampire", "по поводу настроек на кряк - vk.com/try2hard", "не с кем пообщаться, в жизни нᴇт дᴘʏзᴇй? пиши - vk.com/try2hard // всегда рада тебе ^_^","vk.com/vampire <- напиши ему привет",
"—Если ничита◣_◢ рядом —То враги падают градом 🧢", "Лучшие никсвар гифты -> vk.com/vampire","Даня Футин 23:30 я так хапнул пиздато","●▬▬▬▬▬▬▬▬▬▬▬▬ஜ۩۞۩ஜ▬▬▬▬▬▬▬▬▬▬▬▬● ░░░░░░░░░░░░░░ДОБРО ПОЖАЛОВАТЬ ░░░░░░░░░░░░░ ●▬▬▬▬▬▬▬▬▬▬▬▬ஜ۩۞۩ஜ▬▬▬▬▬▬▬▬▬▬▬▬●",
"✞я убью тебя и всех твоих родных (◣_◢)",
"STAY BLUHGANG $",
"st1vaha погиб на украине, он служил в ЧВК «Вагнер», теперь это призрак киева [◣_◢]",
"Do You Know Who is it? *rayzen,sanchezj,ptemt*",
"𝐈 𝐀𝐦 𝐋𝐞𝐠𝐞𝐧𝐝",
"Мировая личность и отбросы в фильме - Angelwings.",
"Я официально запретил *j* в нике SANCHEZ",
"OGkaneki♕ all mute 乡sad乡",
"χợ੫℮ᗯѣ ∂℮τсķợ℮ ʙ ᥰ᧐ᥙᥴκu -> vk.com/try2hard",
"１６３ ＦＮＡＹ ＯＮ ＭＹ ＮＥＣＫ",
"aBoJl_MeHeg}I{ep",
"𝔂𝓸𝓾 𝓭𝓸𝓷𝓽 𝓷𝓮𝓮𝓭 𝓯𝓻𝓲𝓮𝓷𝓭𝓼 𝔀𝓱𝓮𝓷 𝔂𝓸𝓾 𝓱𝓪𝓿𝓮 𝓷𝓸𝓿𝓸𝓵𝓲𝓷𝓮𝓱𝓸𝓸𝓴",
"M3M3C-3HCE +2 accepted only RICH MAINS",
"пророк мухаммад саллаллаху алейхи вассалам",
"♛ ｅ ｍ ｏ ｄ ｒ ａ ｉ ｎ ｓ ♛",
"6eWeHыЙ_KaHrAJl",
"fipp трогал меня ТАМ.... Мне было 13 и я очень испугался 😢",
"fipp трогал меня ТАМ... мне было 12 и он меня катал на Nissaki Almera",
"𝓐𝓛𝓗𝓐𝓜𝓓𝓤𝓛𝓘𝓛𝓛𝓐𝓗 𝓘𝓝𝓢𝓗𝓐𝓛𝓛𝓐𝓗",
"Тот самый бот, который раздевает девочек - vk.com/try2hard",
"школьный повор педофил (◣◢)",
"сегодня выпил бутылочку ягуара и ♥♥♥♥♥♥♥♥♥♥♥♥ ♥♥♥♥♥♥♥♥♥♥асов ёпраесете",
"♚ ＴＯＲＥＴＴＯＧＡＮＧ ♚ ",
"𝕠𝕨𝕟𝕖𝕕 𝕓𝕪 𝕣𝕦𝕤𝕤𝕚𝕒𝕟 𝕜𝕚𝕟𝕘𝕤 $",
"SANCHEZj,SHIBA,RIGZ vs storry,Razen,kitty,wavvy godless stack owned",
"ｒｉｃｈ ｍｙ ｍａｉｎ", 
"𝒍𝒂𝒎𝒃𝒐𝒓𝒈𝒊𝒈𝒏𝒊 𝒐𝒘𝒏𝒆𝒓", 
"𝕕𝕠 𝕪𝕠𝕦 𝕙𝕒𝕧𝕖 𝕙𝕒𝕝𝕗 𝕒𝕟𝕘𝕣𝕪 𝕔𝕠𝕟𝕗𝕚𝕘 𝕗𝕠𝕣 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖?", 
"𝙗𝙞𝙜 𝙣𝙖𝙢𝙚𝙧, 𝙞𝙢 𝙩𝙝𝙞𝙣𝙠 𝙮𝙤𝙪 𝙙𝙧𝙤𝙥 𝙮𝙤𝙪𝙧 𝙘𝙧𝙤𝙬𝙣 𝙨𝙤 𝙞𝙢 𝙬𝙚𝙣𝙩 𝙥𝙞𝙩𝙘𝙝𝙙𝙤𝙬𝙣 𝙞𝙣 𝙢𝙢 𝙖𝙣𝙙 𝙥𝙞𝙘𝙠𝙚𝙙 𝙞𝙩 𝙪𝙥, 𝙝𝙚𝙧𝙚 𝙮𝙤𝙪 𝙜𝙤 𝙠𝙞𝙣𝙜 ♛","𝕚𝕕𝕚𝕠𝕥 𝕒𝕝𝕨𝕒𝕪𝕤 𝕒𝕤𝕜 𝕞𝕖, 𝕦𝕚𝕕? 𝕒𝕟𝕕 𝕚𝕞 𝕕𝕠𝕟𝕥 𝕒𝕟𝕤𝕨𝕖𝕣, 𝕚 𝕝𝕖𝕥 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖𝕓𝕠𝕒𝕣𝕕 𝕥𝕒𝕝𝕜♛ (◣◢)","пастирал тебя хуем", "с4астлива сосешь мне", "  CFG by KuCJloTa  ", "Создатель LUA angelwings", "C͜͡n͜͡u͜͡ H͜͡a͜͡x͜͡y͜͡u͜͡", "с⃞п⃞и⃞ ш⃞л⃞ю⃞х⃞а⃞",
"✧:･ﾟ✧ 𝐅𝐔𝐂𝐊 𝐘𝐎𝐔 ✧:･ﾟ✧","манипулирую хуем над табой", "хуем па ребрам тебе", "4ота сасируеш потна", "1 спи долбаеб", "в ебыч хуйсос", "на хуе ща крутишься у мя)", "⛓𝐁𝐋𝐔𝐇𝐆𝐀𝐍𝐆 🖤 𝐕𝐒 𝐠𝐨𝐝𝐥𝐞𝐬𝐬 [𝟓𝐯𝟏𝟗] After this game they no longer believe in God rayzen,onej,vitma owned", "ебучий рекс ты сын шлюхи завали ебало",
"хахах просто легкий пидорас", "☂️Vac Enjoyer (HVH)☂️", "allah headshot", "angelwings Loading… █▒▒▒▒▒▒▒▒▒ 10% ███▒▒▒▒▒▒▒ 30% █████▒▒▒▒▒ 50% ███████▒▒▒ 100%", "на завод иди", "| Welcome to angelwings |", "▄ ▀▄ ▀▄ ▀▄ НА ТАКСИ ТЕБЯ СБИЛ ЕПТА ХАХА", "€6@L TBO|-O ᛖ@Ťѣ √ թΘТ", "▀▄▀▄▀▄▀▄▀▄▀▄", "пончик ебаный я твоей маме колени выбил битой", "глотни коки яки хуйсоска", "спи хуйсоска)", "спи нахуй пидораска", "АХХАХА МАТЬ ЕБАЛ ТВОЮ СЫН ШЛЮХИ", "ахуеnnø мамашу tvøю øbжøpиstyю ебал es ez хихи =D", "sasesh мøй хуй kpуta es ez =D", "old SANCHEZj is back but i never left [1v1] onej ПУСТЬ УМРУТ ТВОИ РОДИТЕЛИ... † OWNED MY DOG", "+rep 🅻 🅴 🅶 🅸 🆃 💥", "ALLAH DİYEN ŞOK POŞETİ | KEYDROP", "ты че пидорас в светлое будущее попрыгал что-ли?", "ХАХАХА ЧЕ ТЫ ТАМ ВРЕДИТЕЛЬ АХАХАХ СПОТИФАЙ ХАХА Х", "СПОТЛАЙТ СПОТЛАЙТ АХАХА СПИНОЙ ПИДОРАСА УБИВАЮ ХАХА", "АХХАХА ПИДОРАС ТЫ ЧЕ ТУПОЙ ТО ТАКОЙ", "пraдaлzхaйу пинaт' тvaййу мaмasху хихи es ez =D", "най чит чел..", "с хуйом маим работайш)", "SANCHEZj [1v1] ptemt Проиграл МАТЬ на 1x1, возможно навсегда. st1vaha,rayzen,vitma Owned..", "This dogs dont have chance against angelwings",
"спи нахуй пидорас ебанный куда пошёл сын шлюхи", "♛ Ｔａｄｚｈ３３ｋ ♛", "SANCHEZJ $ PTEMT BLUHGANG TEAM", "Ｌｉｎｋ ｍａｉｎ ｂｅｆｏｒｅ ｓｐｅａｋｉｎｇ ♛",": Your name - missed shot due to resolver.", "изи", "ммовский хуесос ты для чего на паблик зашел, заблудился чтоли?", "спи нахуй пидораска)", "▼- стрелочка вниз","-𝚛𝚎𝚙 0 𝚒𝚚", "$ angelwings $ LUA", "๑۩۞۩๑√ОТЛЕТАЙ НУБЯРА√๑۩۞۩๑", "ЗНẪЙ СВОЁ ḾḜḈТО НИЧТОЖḜСТВØ", "†ПоКоЙсЯ(ٿ)с(ٿ)Миром†", "я играю с конфигом от pytbylev (◣_◢)",
"₽вȁл гȫρтăнь Ŧвȫей ʍа₮еᎵน", "Аллах бабах чурки", "АХМАТ СИЛА Алла́ху А́кбар ЛЕТИ", "[̲̅Д̲̅о̲̅П̲̅р̲̅ы̲̅Г̲̅а̲̲л̲̅с̲̅я̲̅(ت)̲̅Д̲̅р̲̅У̲̅ж̲̅о̲̅Ч̲̅е̲̅К̲̅]", "я ᴇбᴀᴧ ᴛʙᴏю ʍᴀᴛь [◣_◢]", "𝐢 𝐬𝐦𝐨𝐤𝐞 𝐜𝐡𝐚𝐫𝐨𝐧 𝐚𝐧𝐝 𝐝𝐫𝐢𝐧𝐤 𝐜𝐨𝐥𝐚 𝐝𝐨𝐛𝐫𝐢𝐲", "—Если братишка рядом —То враги падают градом 🧢Z", "отсосал как 𝕥𝕖𝕕𝕪","ℳАℳКУ ЕБАЛ","𝙸<𝟹 𝙾𝙿𝙴𝚁𝙿𝙻𝚄𝙶 ☆","𝐟𝐮𝐤 𝟏𝟎𝟐","-𝒓𝒆𝒑 𝒄𝒉𝒆𝒂𝒕𝒔","CАСЁШ КАК 𝕆ℝ𝔻","𝕏עӥ☾𝕠⊂","Я бы после такого в игру не заходил *fipp,albenix,sheefu,borya,vitma,st1vaha,d4ssh*","AWpKINGNeededSmoke $ 𝐓𝐡𝐞𝐲 𝐰𝐚𝐧𝐭 𝐭𝐨 𝐛𝐞 𝐥𝐢𝐤𝐞 𝐦𝐞 𝐛𝐮𝐭 𝐈 𝐛𝐞𝐥𝐨𝐧𝐠 𝐭𝐨 𝐚 𝐟𝐚𝐦𝐢𝐥𝐲 𝐨𝐟 𝐊𝐈𝐍𝐆𝐒","⋆н⋆а⋆ ⋆к⋆о⋆л⋆е⋆н⋆и⋆","😱 В Башкирии женщина год спала с любовником и заразилась от него ВИЧ","vk.com/tryhard <-— лʏчωии свᴀдᴇҕныи фотоrᴘᴀф","vk.com/VAMPIRE <-— лʏчωии свᴀдᴇҕныи фотоrᴘᴀф","ᙐᗣᏦᑌᕼᎽᙁ ᙅᕼᚿθᙅᑌᏦᗣ","匚ㄖᗪ乇10 卂ㄥ山卂ㄚ丂 ㄖ几","я иrᴘᴀю с 𝔸𝔸ℝℕ𝔼.ℂ𝕃𝕌𝔹, ҕᴇrитᴇ","𝐬𝐥𝐨𝐰𝐞𝐝 + 𝐫𝐞𝐯𝐞𝐫𝐛","₴ⱠØ₩ɆĐ + ⱤɆVɆⱤ฿","丂ㄥㄖ山乇ᗪ + 尺乇ᐯ乇尺乃","(っ◔◡◔)っ ♥ slowed + reverb ♥","˜”°•.˜”°• slowed + reverb •°”˜.•°”˜","ｓｌｏｗｅｄ ＋ ｒｅｖｅｒｂ","”°•.˜vk.com/vampire”°•","♥vk.com/vampire♥","𝕧𝕜.𝕔𝕠𝕞/𝕧𝕒𝕞𝕡𝕚𝕣𝕖","ｖｋ．ｃｏｍ／ｖａｍｐｉｒｅ","ᴠᴋ.ᴄᴏᴍ/ᴠᴀᴍᴘɪʀᴇ","𝚟𝚔.𝚌𝚘𝚖/𝚟𝚊𝚖𝚙𝚒𝚛𝚎","ｖｋ．ｃｏｍ／ｖａｍｐｉｒｅ　リゃド","【﻿ｖｋ．ｃｏｍ／ｖａｍｐｉｒｅ】","▀▄▀▄▀▄   🎀  𝓋𝓀.𝒸☯𝓂/𝓋𝒶𝓂𝓅𝒾𝓇𝑒  🎀   ▄▀▄▀▄▀","𝕒𝕝𝕝 𝕗𝕒𝕞𝕚𝕝𝕪 𝕨𝕚𝕥𝕙 𝕦𝕤𝕖𝕣𝕟𝕒𝕞𝕖𝕤","ａｌｌ ｆａｍｉｌｙ ｗｉｔｈ ｕｓｅｒｎａｍｅｓ","FNAAAAAY В ЧАААТ (◣_◢)"
}

local function on_player_death(e)
local victim_id, attacker_id = e.userid, e.attacker
    
    if victim_id == nil or attacker_id == nil then
        return
    end

    local victim = client.userid_to_entindex(victim_id)
    local attacker = client.userid_to_entindex(attacker_id)
    
    if attacker == entity.get_local_player() and victim ~= entity.get_local_player() then
        if ui.get(angelwings.ui.misc.killsay) then
            
            local kill_str = kill[client.random_int(1, #kill)]
            client.exec('say '..kill_str)
        end
    end
end

local function reset_data()
    var.queuet = {}
    var.queue = {}
    var.manual = false
end

local get_view_angles = vtable_bind("engine.dll", "VEngineClient014", 18, "Vector (__thiscall*)(void*)")
local set_view_angles = vtable_bind("engine.dll", "VEngineClient014", 19, "void (__thiscall*)(void*, Vector&)")
local function on_override_view()
    local current_angles = get_view_angles()
    current_angles.z = 0
    set_view_angles(current_angles)
end
client.set_event_callback("override_view", on_override_view)

ffi.cdef[[
	struct cusercmd
	{
		struct cusercmd (*cusercmd)();
		int     command_number;
		int     tick_count;
	};
	typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
]]

local signature_ginput = base64.decode("uczMzMyLQDj/0ITAD4U=")
local match = client.find_signature("client.dll", signature_ginput) or error("sig1 not found")
local g_input = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("match is nil")
local g_inputclass = ffi.cast("void***", g_input)
local g_inputvtbl = g_inputclass[0]
local rawgetusercmd = g_inputvtbl[8]
local get_user_cmd = ffi.cast("get_user_cmd_t", rawgetusercmd)
local lastlocal = 0
local function reduce(e)
	local cmd = get_user_cmd(g_inputclass , 0, e.command_number)
	if lastlocal + 0.9 > globals.curtime() then
		cmd.tick_count = cmd.tick_count + 8
	else
		cmd.tick_count = cmd.tick_count + 1
	end
end

client.set_event_callback("setup_command", reduce)

local function on_shutdown()
    og_menu(true)
    ui.set_callback(angelwings.ui.aa.master, function()
        ui.set(angelwings.refs.aa.pitch, "Off")
        ui.set(angelwings.refs.aa.yaw_base, "Local View")
        ui.set(angelwings.refs.aa.yaw, "Off")
        ui.set(angelwings.refs.aa.yaw_offset, 0)
        ui.set(angelwings.refs.aa.yaw_jitter, "Off")
        ui.set(angelwings.refs.aa.yaw_jitter_offset, 0)
        ui.set(angelwings.refs.aa.body_yaw, "Off")
        ui.set(angelwings.refs.aa.body_yaw_offset, 0)
    end)
end

ct.original_clantag = get_original_clantag()

client.set_event_callback("setup_command", function(...)
    tpfix(...)
    discharge(...)
    fastladder(...)
    player_state(...)
    get_best_desync(...)
    fakelag_visuals(...)
    handle_shots(...)
    sushi(...)
    custom(...)
    jump_scout(...)
    defensive(...)
    angelwings.handlers.aa.fixes(...)
    anti_backstab.abs(...)
end)

client.set_event_callback("run_command", function(...)
    EdgeYaw(...)
    FreeStand(...)
    ManualAA(...)
    ctcall.run_command(...)
end)

client.set_event_callback("paint", function(...)
    notify.handler(...)
    indicators(...)
    clantag(...)
    ctcall.paint(...)
end)

client.set_event_callback("player_death", function(e)
    on_player_death(e)
    var.adaptive_freestand = 0
    var.def = false
end)

client.set_event_callback("round_start", function()
    lastdtshot = 0
    var.adaptive_freestand = 0
    local me = entity.get_local_player()
    if not entity.is_alive(me) then return end
    var.def = false
end)

client.set_event_callback("game_newmap", function()
    var.def = false
end)

client.set_event_callback("shutdown", on_shutdown)
client.set_event_callback("item_equip", on_item_equip)

client.set_event_callback("player_connect_full", ctcall.player_connect_full)
client.set_event_callback("shutdown", ctcall.shutdown)
