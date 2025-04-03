local vector = require("vector")
local bit = require("bit")
local ffi = require("ffi")
local antiaim_funcs = require("gamesense/antiaim_funcs")
local csgo_weapons = require("gamesense/csgo_weapons")
local menu_c = ui.reference("MISC", "Settings", "Menu color")
local menu_r, menu_g, menu_b, menu_a = ui.get(menu_c)
local android_notify=(function()local a={callback_registered=false,maximum_count=7,data2={}}function a:register_callback()if self.callback_registered then return end;client.set_event_callback('paint_ui',function()local b={client.screen_size()}local c={56,56,57}local d=5;local e=self.data2;for f=#e,1,-1 do self.data2[f].time=self.data2[f].time-globals.frametime()local g,h=255,0;local i=e[f]if i.time<0 then table.remove(self.data2,f)else local j=i.def_time-i.time;local j=j>1 and 1 or j;if i.time<0.5 or j<0.5 then h=(j<1 and j or i.time)/0.5;g=h*255;if h<0.2 then d=d+15*(1.0-h/0.2)end end;local k={renderer.measure_text(nil,i.draw)}local l={b[1]/2-k[1]/2+3,b[2]-b[2]/100*17.4+d}renderer.circle(l[1],l[2]-8,20,20,20,g,12,180,0.5)renderer.circle(l[1]+k[1],l[2]-8,20,20,20,g,12,0,0.5)renderer.rectangle(l[1],l[2]-20,k[1],24,20,20,20,g)renderer.circle_outline(l[1],l[2]-8,menu_r,menu_g,menu_b,g,12,90,0.5,1)renderer.circle_outline(l[1]+k[1],l[2]-8,menu_r,menu_g,menu_b,g,12,270,0.5,1)renderer.rectangle(l[1],l[2]-20,k[1],1,menu_r,menu_g,menu_b,g)renderer.rectangle(l[1],l[2]-20+23,k[1],1,menu_r,menu_g,menu_b,g)renderer.text(l[1]+k[1]/2,l[2]-8,255,255,255,g,'c',nil,i.draw)d=d-50 end end;self.callback_registered=true end)end;function a:paint(m,n)local o=tonumber(m)+1;for f=self.maximum_count,2,-1 do self.data2[f]=self.data2[f-1]end;self.data2[1]={time=o,def_time=o,draw=n}self:register_callback()end;return a end)()

spaces = {"", " ", "  ", "   "}
anti_aim = {}
refs = {}

local tabselection = ui.new_combobox("AA","Anti-aimbot angles","Tab Selection","Anti-Aim","Visual","Rage-Bot","Misc")
local presets = ui.new_combobox("AA","Anti-aimbot angles","Presets","Exi-Mode","Default","Custom")
local conditiontab = ui.new_combobox("AA","Anti-aimbot angles","Condition","Standing","Moving","Air","Crouching")
for i=1, 4 do 
    anti_aim[i] = {
        addition = ui.new_combobox("AA","Anti-aimbot angles","Yaw"..spaces[i],"Random","Jitter","Flick Between","Flick Around","Regarding Sides"),
        styaw = ui.new_slider("AA","Anti-aimbot angles","From"..spaces[i],-180,180,0),
        ndyaw = ui.new_slider("AA","Anti-aimbot angles","To"..spaces[i],-180,180,0),
        flick_speed = ui.new_slider("AA","Anti-aimbot angles","Flick delay"..spaces[i],1,50,7, true, "t", 1),
        body_yaw = ui.new_combobox("AA","Anti-aimbot angles","Body Yaw"..spaces[i],"Static","Jitter","Randomize Jitter"),
        body_yaw_val = ui.new_slider("AA","Anti-aimbot angles","Body Yaw Value"..spaces[i],-180,180,0),
        jitter_yaw = ui.new_combobox("AA","Anti-aimbot angles","Jitter Yaw"..spaces[i],"Off","Center","Offset","Random","Progressive"),
        jitter_yaw_val = ui.new_slider("AA","Anti-aimbot angles","Jitter Yaw Value"..spaces[i],-180,180,0),
        fake_addition = ui.new_combobox("AA","Anti-aimbot angles","Fake"..spaces[i],"Random","Jitter","Flick Between","Flick Around","Regarding Sides"),
        stfake_val = ui.new_slider("AA","Anti-aimbot angles","Frоm"..spaces[i],0,60,59),
        ndfake_val = ui.new_slider("AA","Anti-aimbot angles","Tо"..spaces[i],0,60,59),
        flick_speed2 = ui.new_slider("AA","Anti-aimbot angles","Flick delаy"..spaces[i],1,50,7, true, "t", 1),
    } 
end
local edgeyawkey = ui.new_hotkey("AA","Anti-aimbot angles","Edge Yaw on Key")
local edgeyawdisable = ui.new_multiselect("AA","Anti-aimbot angles", "Disable Edge Yaw if", "Standing", "Moving", "Air", "Crouching", "Duck Peek Assist", "Freestanding", "Roll AA", "Quick Peek Assist", "Not Safe Wall")
local syncyawtarget = ui.new_hotkey("AA","Anti-aimbot angles","Sync Yaw on Target")
local additions = ui.new_multiselect("AA","Anti-aimbot angles","AA Aditions","Freestanding")
local freestandtype = ui.new_combobox("AA","Anti-aimbot angles","Freestanding Mode","Peek Out","Peek Fake")
local forcesafe = ui.new_hotkey("AA","Anti-aimbot angles","Roll AA Key")
local ui_left = ui.new_hotkey("AA","Anti-aimbot angles", "Left")
local ui_right = ui.new_hotkey("AA","Anti-aimbot angles", "Right")
local ui_back = ui.new_hotkey("AA","Anti-aimbot angles", "Back")
local enablecustomfl = ui.new_checkbox("AA","Fake lag","NaNo LaGs")
local fltab = ui.new_combobox("AA","Fake lag","Fake Lag", "Maximum", "Dynamic", "Alternative")
local triggers = ui.new_multiselect("AA","Fake lag","Triggers","Movement","  In air", "  Moving","Animations","  Standing","  Anim layers")
local triggerlimit = ui.new_slider("AA","Fake lag","Trigger limit",1,15,15)
local sendlimit = ui.new_slider("AA","Fake lag","Send limit",1,15,11)
local forcelimit = ui.new_multiselect("AA","Fake lag", "Force low fake lag limit", "On stand", "On shot", "On hide-shots")
local indbox = ui.new_checkbox("AA","Anti-aimbot angles","Indicators")
local crossind = ui.new_multiselect("AA","Anti-aimbot angles","Crosshair Indicators", "Text", "Arrows")
local color0 = ui.new_color_picker("AA","Anti-aimbot angles","Crosshair Indicators Color",200, 170, 255, 255)
local sktind = ui.new_multiselect("AA","Anti-aimbot angles","Skeet Indicators","Roll","Enemy Information")
local uiind = ui.new_multiselect("AA","Anti-aimbot angles","UI Indicators","Watermark", "Keybinds", "FL/DT", "Anti-aimbot")
local watermarkname = ui.new_combobox("AA","Anti-aimbot angles","Watermark name","User", "Steam")
local styleui = ui.new_combobox("AA","Anti-aimbot angles","UI Style","Default", "Modern[fps warning]")
local color = ui.new_color_picker("AA","Anti-aimbot angles","UI Indicators Color",200, 170, 255, 255)
local debugind = ui.new_multiselect("AA","Anti-aimbot angles","Debug Indicators","Debug Table", "Player Information")
local d_color = ui.new_color_picker("AA","Anti-aimbot angles","Debug Indicators Color",200, 170, 255, 255)
local enableflags = ui.new_checkbox("AA","Anti-aimbot angles","Enable aimbot flags")
local flagstab = ui.new_multiselect("AA","Anti-aimbot angles","Flags","Aimbot State","Angle","Prediction")
local preferbodyif = ui.new_multiselect("AA","Anti-aimbot angles","Prefer Body Conditions", "Lethal", "In Air", "Low Damage", "DT Key Active")
local forcebodyif = ui.new_multiselect("AA","Anti-aimbot angles","Force Body Conditions", "Lethal", "In Air", "Low Damage", "DT Key Active")
local resolver_cb = ui.new_checkbox("AA","Anti-aimbot angles", "Enable Custom Resolver")
local enableantidef = ui.new_checkbox("AA","Anti-aimbot angles", "Smart Anti-Defensive")
local accuracy_def = ui.new_slider("AA","Anti-aimbot angles", "Accuracy", -1, 20, 5, true, "ms", 1, {[-1] = "According Ping"})
local extrapolate_add = ui.new_slider("AA","Anti-aimbot angles", "Exterpolate", 0, 5, 1, true, "t", 1, {[0] = "Disabled"})
local enablelogger = ui.new_checkbox("AA","Anti-aimbot angles","Logs")
local logsprinted = ui.new_multiselect("AA","Anti-aimbot angles","Logs Print to","Console", "Notify")
local printevents = ui.new_checkbox("AA","Anti-aimbot angles","Print events to Notify")
local killsay = ui.new_checkbox("AA","Anti-aimbot angles", "Trashtalk")

 fake_duck = ui.reference("RAGE","Other","Duck peek assist")
 damage = ui.reference("RAGE", "Aimbot", "Minimum damage")
 targets = ui.reference("AA","Anti-aimbot angles","Yaw Base")
 fs_tab, fs_key = ui.reference("AA","Anti-aimbot angles","Freestanding")
 os_aa, os_key = ui.reference("AA","Other","On shot anti-aim")
 yaw_am, yaw_val = ui.reference("AA","Anti-aimbot angles","Yaw")
 jyaw, jyaw_val = ui.reference("AA","Anti-aimbot angles","Yaw Jitter")
 byaw, byaw_val = ui.reference("AA","Anti-aimbot angles","Body yaw")
 fs_body_yaw = ui.reference("AA","Anti-aimbot angles","Freestanding body yaw")
 --fake_yaw = ui.reference("AA","Anti-aimbot angles","Fake yaw limit")
 edge_yaw = ui.reference("AA","Anti-aimbot angles","Edge yaw")
 sw, slowwalk = ui.reference("AA","Other","Slow motion")
 --sw_type = ui.reference("AA","Other","Slow motion type")
 lm = ui.reference("AA","Other","Leg movement")
 enablefl = ui.reference("AA","Fake lag","Enabled")
 fl_amount = ui.reference("AA", "Fake lag", "Amount")
 fl_limit = ui.reference("AA","Fake lag","Limit")
 fl_var = ui.reference("AA", "fake lag", "variance")
 dt, dt_key = ui.reference("RAGE", "Aimbot", "Double tap")
 rollskeet = ui.reference("AA","Anti-aimbot angles", "Roll")
 thirdview, thirdview_key = ui.reference("VISUALS","Effects","Force third person (alive)")
 quickpeek, quickpeek_key = ui.reference("RAGE", "Other", "Quick peek assist")
 global_fov = ui.reference("MISC", "Miscellaneous", "Override FOV")
 zoom_fov = ui.reference("MISC", "Miscellaneous", "Override zoom FOV")
 backtrack_ref = ui.reference("RAGE","Other","Accuracy boost")
 reloadscripts = ui.reference("CONFIG","Lua","Reload active scripts")

for i=1, 4 do 
    refs[i] = {
        ticks_flick_c,
        ticks_flick2_c,
        ticks_flick,
        ticks_flick2,
        flicks,
        flicks2,
        flicks_c,
        flicks2_c,
        flickyaw_c,
        flickfake_c,
        flickyaw,
        flickfake,
    } 
end

refs[1].flickyaw_c = ui.get(anti_aim[1].styaw)
refs[2].flickyaw_c = ui.get(anti_aim[2].styaw)
refs[3].flickyaw_c = ui.get(anti_aim[3].styaw)
refs[4].flickyaw_c = ui.get(anti_aim[4].styaw)
refs[1].flickfake_c = ui.get(anti_aim[1].stfake_val)
refs[2].flickfake_c = ui.get(anti_aim[2].stfake_val)
refs[3].flickfake_c = ui.get(anti_aim[3].stfake_val)
refs[4].flickfake_c = ui.get(anti_aim[4].stfake_val)
refs[1].flickyaw = 0
refs[2].flickyaw = 0
refs[3].flickyaw = 0
refs[4].flickyaw = 0
refs[1].flickfake = 0
refs[2].flickfake = 0
refs[3].flickfake = 0
refs[4].flickfake = 0

local dragging = (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider('LUA','A',u..' window position',0,x,v/j*x)local z=ui.new_slider('LUA','A','\n'..u..' window position y',0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals.framecount()~=b then c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)()
local rounding = 4
local o = 20
local rad = rounding + 2
local n = 45
local RoundedRect = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)renderer.rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)renderer.rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)renderer.circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)renderer.circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)renderer.circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25) end
local OutlineGlow = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+2,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+w-3,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+radius+rad,y+2,w-rad*2-radius*2,1,r,g,b,a)renderer.rectangle(x+radius+rad,y+h-3,w-rad*2-radius*2,1,r,g,b,a)renderer.circle_outline(x+radius+rad,y+radius+rad,r,g,b,a,radius+rounding,180,0.25,1)renderer.circle_outline(x+w-radius-rad,y+radius+rad,r,g,b,a,radius+rounding,270,0.25,1)renderer.circle_outline(x+radius+rad,y+h-radius-rad,r,g,b,a,radius+rounding,90,0.25,1)renderer.circle_outline(x+w-radius-rad,y+h-radius-rad,r,g,b,a,radius+rounding,0,0.25,1) end
local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) local n=a/255*n;renderer.rectangle(x+radius,y,w-radius*2,1,r,g,b,n)renderer.circle_outline(x+radius,y+radius,r,g,b,n,radius,180,0.25,1)renderer.circle_outline(x+w-radius,y+radius,r,g,b,n,radius,270,0.25,1)renderer.rectangle(x,y+radius,1,h-radius*2,r,g,b,n)renderer.rectangle(x+w-1,y+radius,1,h-radius*2,r,g,b,n)renderer.circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,n) for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)end end
local container_glow = function(x, y, w, h, r, g, b, a, alpha,r1, g1, b1, fn) if alpha*255>0 then renderer.blur(x,y,w,h)end;RoundedRect(x,y,w,h,rounding,17,17,17,a)FadedRoundedGlow(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o,r1,g1,b1)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end
 
local function getspeed(player_index)
    return vector(entity.get_prop(player_index, "m_vecVelocity")):length()
end

local usertab = ui.new_textbox("AA", "Anti-aimbot angles","Login")
local passwordtab = ui.new_textbox("AA", "Anti-aimbot angles","Password")

player_memory = {}
GLOBAL_ALPHA = 0
VIEW_ALPHA = 0
FIRST_ALPHA = 0
m_active = { }
references = { }
hotkey_modes = { 'holding', 'toggled', 'disabled' }
hotkeys_dragging = dragging.new('Keybinds', 100, 200)
hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
iter = 1
iAngle = {}
pressing_e_timer = {}
flipJitter = false
back_dir = true
left_dir = false
right_dir = false
last_press_t = 0
should_swap = 0
mode = "SAFE"
x_m = 14
speed = 60
otuiind_y = 0
fakeuiind_x = 0
build = "07.05.2022"
no_lethalpresetnoti = false
dmg = 0
dmg2 = 0
enemyz = 0
lz = 0
angle = 0
ChokedCommands = 0
ground_ticks, end_time = 1, 0
yaw_plus = 1
flickleft = 0
flickright = 0
right_side = true
left_side = true
curprintlog = 0
misses = 0
value = 0
killsays = { [1] = "say [half-life] buy or die", [2] = "say [half-life] better than luck", [3] = "say [half-life] no chance versus best anti-aim lua", [4] = "say [half-life] just the best lua", [5] = "say [half-life] 1000-7?" }
curswap = globals.curtime()
nextShot2 = 99999999999999999
position_y = 0
animation_stabile = globals.curtime()
animation_unstabile = globals.curtime()
animation_active = globals.curtime()
animation_disactive = globals.curtime()
tick_delay = 0
delayshot = 0

--[[loader.hwidset = function(id)
    http.request("POST", "https://half-life.tech/api/users/"..id, {params = { ["custom_fields[hardware_system_id]"] = pcdata } ,headers = { ["Content-type"] = "application/x-www-form-urlencoded", ["XF-Api-Key"] = "0hoZB6bqkJDR2nXk50qkL4uZHk-i1Xox", ["XF-Api-User"] = "1"}}, function(success, response)
        if not success or response.status ~= 200 then
            error("unexpected error [no connection]")
            return
        end
    end)
end

loader.forceban = function(id)
    http.request("POST", "https://half-life.tech/api/users/"..id, {params = { ["is_banned"] = "true" } ,headers = { ["Content-type"] = "application/x-www-form-urlencoded", ["XF-Api-Key"] = "0hoZB6bqkJDR2nXk50qkL4uZHk-i1Xox", ["XF-Api-User"] = "1"}}, function(success, response)
        if not success or response.status ~= 200 then
            error("unexpected error [no connection]")
            return
        end
    end)
end

loader.auth = function()
    local _user = ui.get(usertab)
    local _password = ui.get(passwordtab)

    if loader.dr('[half-life] stored_values').is_success then
        _user = loader.dr('[half-life] stored_values').username
        _password = loader.dr('[half-life] stored_values').password
    end

    http.request("POST", "https://half-life.tech/api/auth", {params  = {["login"]=_user, ["password"]=_password} ,headers = { ["Content-type"] = "application/x-www-form-urlencoded", ["XF-Api-Key"] = "0hoZB6bqkJDR2nXk50qkL4uZHk-i1Xox", ["XF-Api-User"] = "1"}}, function(success, response)
        if not success or response.status ~= 200 then
            error("unexpected error [username or password is not valid]")
            return
        end

        loader.dw('[half-life] stored_values', {username = _user, password = _password, is_success = true})

        userdata = json.parse(response.body);
        group_id = userdata.user.user_group_id
        steamconnected = userdata.user.custom_fields.SteamID64
        user_id = userdata.user.user_id
        hardwareid = userdata.user.custom_fields.hardware_system_id
        is_banned = userdata.user.is_banned

        if hardwareid == "" then
            loader.hwidset(user_id)
            ui.set(reloadscripts, true)
            error("unexpected error [hwid has been successfully set]")
            return
        end

        if is_banned then 
            error("unexpected error [banned user]")
            return
        end
        if tostring(hardwareid) ~= tostring(pcdata) then 
            loader.forceban(user_id)
            error("unexpected error [wrong hwid]")
            return
        end 
        if group_id <= 2 then 
            error("unexpected error [you dont have active subscription]")
            return
        end 
        if steamconnected ~= SteamId then
            error("unexpected error [wrong steam account]")
            return
        end

        loader.is_authorization_passed = true
    end)
end

if loader.dr('[half-life] stored_values').is_success then
    loader.auth()
end

local button = ui.new_button("AA", "Anti-aimbot angles", "Login", loader.auth)]]

local data = {
    side = 1,
    last_side = 0,

    last_hit = 0,
    hit_side = 0
}

ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local VGUI_System010 =  client.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )

local get_clipboard_text_count = ffi.cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

local pflFrameTime = ffi.new("float[1]")
local pflFrameTimeStdDeviation = ffi.new("float[1]")
local pflFrameStartTimeStdDeviation = ffi.new("float[1]")

local interface_ptr = ffi.typeof('void***')
local netc_bool = ffi.typeof("bool(__thiscall*)(void*)")
local netc_bool2 = ffi.typeof("bool(__thiscall*)(void*, int, int)")
local netc_float = ffi.typeof("float(__thiscall*)(void*, int)")
local netc_int = ffi.typeof("int(__thiscall*)(void*, int)")
local net_fr_to = ffi.typeof("void(__thiscall*)(void*, float*, float*, float*)")

local rawivengineclient = client.create_interface("engine.dll", "VEngineClient014") or error("VEngineClient014 wasnt found", 2)
local ivengineclient = ffi.cast(interface_ptr, rawivengineclient) or error("rawivengineclient is nil", 2)
local get_net_channel_info = ffi.cast("void*(__thiscall*)(void*)", ivengineclient[0][78]) or error("ivengineclient is nil")
local slv_is_ingame_t = ffi.cast("bool(__thiscall*)(void*)", ivengineclient[0][26]) or error("is_in_game is nil")

local get_client_entity2 = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*,int)")
local get_inaccuracy = vtable_thunk(483, "float(__thiscall*)(void*)")

local GetNetChannel = function(INetChannelInfo)
    if INetChannelInfo == nil then
        return
    end

    local seqNr_out = ffi.cast(netc_int, INetChannelInfo[0][17])(INetChannelInfo, 1)

    return {
        seqNr_out = seqNr_out,

        is_loopback = ffi.cast(netc_bool, INetChannelInfo[0][6])(INetChannelInfo),
        is_timing_out = ffi.cast(netc_bool, INetChannelInfo[0][7])(INetChannelInfo),

        latency = {
            crn = function(flow) return ffi.cast(netc_float, INetChannelInfo[0][9])(INetChannelInfo, flow) end,
            average = function(flow) return ffi.cast(netc_float, INetChannelInfo[0][10])(INetChannelInfo, flow) end,
        },

        loss = ffi.cast(netc_float, INetChannelInfo[0][11])(INetChannelInfo, 1),
        choke = ffi.cast(netc_float, INetChannelInfo[0][12])(INetChannelInfo, 1),
        got_bytes = ffi.cast(netc_float, INetChannelInfo[0][13])(INetChannelInfo, 1),
        sent_bytes = ffi.cast(netc_float, INetChannelInfo[0][13])(INetChannelInfo, 0),

        is_valid_packet = ffi.cast(netc_bool2, INetChannelInfo[0][18])(INetChannelInfo, 1, seqNr_out-1),
    }
end

local function is_crouching(player)
    local flags = entity.get_prop(player, "m_fFlags")
    
    if bit.band(flags, 4) == 4 then
        return true
    end
    
    return false
end

local function in_air(player)
    local flags = entity.get_prop(player, "m_fFlags")
    
    if bit.band(flags, 1) == 0 then
        return true
    end
    
    return false
end

function apply_variance(ticks, wish_variance, seed)
    wish_variance = wish_variance >= ticks and ticks-1 or wish_variance

    local minimum_ticks = ticks-wish_variance

    math.randomseed(seed or client.timestamp())

    return math.random(minimum_ticks, ticks)
end

function consistent(wish_ticks, maximum_ticks)
    return math.min(wish_ticks, maximum_ticks)
end

local function contains(table, value)

	if table == nil then
		return false
	end
	
    table = ui.get(table)
    for i=0, #table do
        if table[i] == value then
            return true
        end
    end
    return false
end

local function item_count(tab)
    if tab == nil then return 0 end
    if #tab == 0 then
        local val = 0
        for k in pairs(tab) do
            val = val + 1
        end

        return val
    end

    return #tab
end

--[[local function create_item(tab, container, name, arg, cname)
    local collected = { }
    --local reference = { ui.reference(tab, container, name) }

    for i=1, #reference do
        if i <= arg then
            collected[i] = reference[i]
        end
    end

    references[cname or name] = collected
end]]

local create_custom_item = function(req, ref)
    local reference_if_exists = function(...)
        if pcall(ui.reference, ...) then
             return true
        end
    end

    local get_script_name = function()
        local funca, err = pcall(function() GS_THROW_ERROR() end)
        return (not funca and err:match("\\(.*):(.*):") or nil)
    end

    if not reference_if_exists(ref[1], ref[2], ref[3]) then
        if pcall(require, req) and reference_if_exists(ref[1], ref[2], ref[3]) then
            create_item(unpack(ref))
        else
            client.log(string.format('%s: Unable to reference - %s (%s.lua/ljbc)', get_script_name(), ref[3], req))
        end
    else
        create_item(unpack(ref))
    end
end

local function Angle_Vector(angle_x, angle_y)
	local sp, sy, cp, cy = nil
    sy = math.sin(math.rad(angle_y));
    cy = math.cos(math.rad(angle_y));
    sp = math.sin(math.rad(angle_x));
    cp = math.cos(math.rad(angle_x));
    return cp * cy, cp * sy, -sp;
end

local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local function calc_angle(local_x, local_y, enemy_x, enemy_y)
	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math.atan( ydelta / xdelta )
	relativeyaw = normalize_yaw( relativeyaw * 180 / math.pi )
	if xdelta >= 0 then
		relativeyaw = normalize_yaw(relativeyaw + 180)
	end
	return relativeyaw
end

local function calcu_angle(x_src, y_src, z_src, x_dst, y_dst, z_dst)
    local x_delta = x_src - x_dst
    local y_delta = y_src - y_dst
    local z_delta = z_src - z_dst
    local hyp = math.sqrt(x_delta^2 + y_delta^2)
    local x = math.atan2(z_delta, hyp) * 57.295779513082
    local y = math.atan2(y_delta , x_delta) * 180 / 3.14159265358979323846
 
    if y > 180 then
        y = y - 180
    end
    if y < -180 then
        y = y + 180
    end
    return y
end

local function CalcAngle(localplayerxpos, localplayerypos, enemyxpos, enemyypos)
    local relativeyaw = math.atan( (localplayerypos - enemyypos) / (localplayerxpos - enemyxpos) )
     return relativeyaw * 180 / math.pi
end

local function extrapolate_position(xpos,ypos,zpos,ticks,player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	for i=0, ticks do
		xpos =  xpos + (x*globals.tickinterval())
		ypos =  ypos + (y*globals.tickinterval())
		zpos =  zpos + (z*globals.tickinterval())
	end
	return xpos,ypos,zpos
end

local function get_velocity(player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	if x == nil then return end
	return math.sqrt(x*x + y*y + z*z)
end

local function rotate_point(x, y, rot, size)
	return math.cos(math.rad(rot)) * size + x, math.sin(math.rad(rot)) * size + y
end

local function renderer_arrow(x, y, r, g, b, a, rotation, size)
	local x0, y0 = rotate_point(x, y, rotation, 45)
	local x1, y1 = rotate_point(x, y, rotation + (size / 2.5), 35 - (size / 5))
	local x2, y2 = rotate_point(x, y, rotation - (size / 100), 45 - (size / 5))
	renderer.triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
end

local function renderer_arrow2(x, y, r, g, b, a, rotation, size)
	local x0, y0 = rotate_point(x, y, rotation, 45)
	local x1, y1 = rotate_point(x, y, rotation + (size / 100), 45 - (size / 5))
	local x2, y2 = rotate_point(x, y, rotation - (size / 2.5), 35 - (size / 5))
	renderer.triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
end

local function player()
	local local_player = entity.get_local_player()
	
	local player = not entity.is_alive(local_player) and entity.get_prop(local_player, 'm_hObserverTarget') or local_player
	if entity.get_prop(local_player, 'm_iObserverMode') == 6 then
		player = nil
	end

	return player
end

local function DoFreestanding(enemy, ...)
	local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
	local viewangle_x, viewangle_y, roll = client.camera_angles()
	local headx, heady, headz = entity.hitbox_position(entity.get_local_player(), 0)
	local enemyx, enemyy, enemyz = entity.get_prop(enemy, "m_vecOrigin")
	local bestangle = nil
	local lowest_dmg = math.huge

	if(entity.is_alive(enemy)) then
		local yaw = CalcAngle(lx, ly, enemyx, enemyy)
		for i,v in pairs({...}) do
			local dir_x, dir_y, dir_z = Angle_Vector(0, (yaw + v))
			local end_x = lx + dir_x * 55
			local end_y = ly + dir_y * 55
			local end_z = lz + 80			
			
			local index, damage = client.trace_bullet(enemy, enemyx, enemyy, enemyz + 70, end_x, end_y, end_z,true)
			local index2, damage2 = client.trace_bullet(enemy, enemyx, enemyy, enemyz + 70, end_x + 12, end_y, end_z,true) --test
			local index3, damage3 = client.trace_bullet(enemy, enemyx, enemyy, enemyz + 70, end_x - 12, end_y, end_z,true) --test

			if(damage < lowest_dmg) then
				lowest_dmg = damage
				if(damage2 > damage) then
					lowest_dmg = damage2
				end
				if(damage3 > damage) then
					lowest_dmg = damage3
				end	
				if(lx - enemyx > 0) then
					bestangle = v
				else
					bestangle = v * -1
				end
			elseif(damage == lowest_dmg) then
					return 0
			end
		end
	end
	return bestangle
end

local function DoEarlyFreestanding(enemy, ...)
	local lx, ly, lz = entity.get_prop(enemy, "m_vecOrigin") -- to
	local viewangle_x, viewangle_y, roll = client.camera_angles()
	local localplayer = entity.get_local_player()
	local headx, heady, headz = entity.hitbox_position(localplayer, 0)
	local enemyx, enemyy, enemyz = entity.get_prop(localplayer, "m_vecOrigin") -- from
	local bestangle = nil
	local lowest_dmg = math.huge
	local last_moved = 0
	local fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z = nil
	if(entity.is_alive(enemy)) then
		local yaw = CalcAngle(enemyx, enemyy, lx, ly)
		for i,v in pairs({...}) do
			local dir_x, dir_y, dir_z = Angle_Vector(0, (yaw + v))
			local end_x = lx + dir_x * 55
			local end_y = ly + dir_y * 55
			local end_z = lz + 80
			local eyepos_x, eyepos_y, eyepos_z = client.eye_position()
			local local_velocity = get_velocity(entity.get_local_player())
			local can_be_extrapolated = local_velocity > 15
			local ticks_to_extrapolate = 11
			if (local_velocity < 50) then
				ticks_to_extrapolate = 90
			elseif (local_velocity >= 50 and local_velocity < 120) then
				ticks_to_extrapolate = 50
			elseif (local_velocity >= 120 and local_velocity < 190) then
				ticks_to_extrapolate = 40
			elseif (local_velocity >= 190) then
				ticks_to_extrapolate = 20
			end

			if can_be_extrapolated then
				eyepos_x, eyepos_y, eyepos_z = extrapolate_position(eyepos_x, eyepos_y, eyepos_z, ticks_to_extrapolate, entity.get_local_player())
				fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z = eyepos_x, eyepos_y, eyepos_z
				last_moved = globals.curtime() + 1
			else
				if last_moved ~= 0 then
					if globals.curtime() > last_moved then
						last_moved = 0
						fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z = nil
					else
						eyepos_x, eyepos_y, eyepos_z = fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z
					end
				else
					eyepos_x, eyepos_y, eyepos_z = extrapolate_position(eyepos_x, eyepos_y, eyepos_z, ticks_to_extrapolate, entity.get_local_player())
				end
			end
			
			local index, damage = client.trace_bullet(localplayer, enemyx, enemyy, enemyz + 70, end_x, end_y, end_z,true)
			local index2, damage2 = client.trace_bullet(localplayer, enemyx, enemyy, enemyz + 70, end_x + 12, end_y, end_z,true)
			local index3, damage3 = client.trace_bullet(localplayer, enemyx, enemyy, enemyz + 70, end_x - 12, end_y, end_z,true)

			if fs_stored_eyepos_x ~= nil then
				index, damage = client.trace_bullet(localplayer, fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z + 70, end_x, end_y, end_z,true)
				index2, damage2 = client.trace_bullet(localplayer, fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z + 70, end_x + 12, end_y, end_z,true)
				index3, damage3 = client.trace_bullet(localplayer, fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z + 70, end_x - 12, end_y, end_z,true)
			end

			if(damage < lowest_dmg) then
				lowest_dmg = damage
				if(damage2 > damage) then
					lowest_dmg = damage2
				end
				if(damage3 > damage) then
					lowest_dmg = damage3
				end	
				if(enemyx - lx > 0) then
					bestangle = v
				else
				bestangle = v * -1
				end
			elseif(damage == lowest_dmg) then
				return 0
			end
		end
	end
	return bestangle
end

local function resolver_data_fs()
    local me = entity.get_local_player()
    if (not me or entity.get_prop(me, "m_lifeState") ~= 0) then
        return
    end

    local player_list = entity.get_players(true)
    for t = 1 , #player_list do
        player = player_list[t]
    end
    

    local now = globals.curtime()

    if data.hit_side ~= 0 and now - data.last_hit > 5 then

        data.last_side = 0

        data.last_hit = 0
        data.hit_side = 0
    end

    local x, y, z = client.eye_position()
    local _, yaw = client.camera_angles()

    local trace_data = {left = 0, right = 0}

    for i = yaw - 120, yaw + 120, 30 do

        if i ~= yaw then

            local rad = math.rad(i)

            local px, py, pz = x + 256 * math.cos(rad), y + 256 * math.sin(rad), z

            local fraction = client.trace_line(me, x, y, z, px, py, pz)
            local side = i < yaw and "left" or "right"

            trace_data[side] = trace_data[side] + fraction
        end
    end

    data.side = trace_data.left < trace_data.right and 1 or 2

    if data.side == data.last_side then
        return
    end

    data.last_side = data.side

    if data.hit_side ~= 0 then
        data.side = data.hit_side == 1 and 2 or 1
    end
end

local function vec3_dot(ax, ay, az, bx, by, bz)
	return ax*bx + ay*by + az*bz
end

local function vec3_normalize(x, y, z)
	local len = math.sqrt(x * x + y * y + z * z)
	if len == 0 then
		return 0, 0, 0
	end
	local r = 1 / len
	return x*r, y*r, z*r
end

local function get_fov_cos(ent, vx,vy,vz, lx,ly,lz)
	local ox,oy,oz = entity.get_prop(ent, "m_vecOrigin")
	if ox == nil then
		return -1
	end

	local dx,dy,dz = vec3_normalize(ox-vx, oy-vy, oz-vz)
	return vec3_dot(dx,dy,dz, vx,vy,vz)
end

local function angle_to_vec(pitch, yaw)
	local p, y = math.rad(pitch), math.rad(yaw)
	local sp, cp, sy, cy = math.sin(p), math.cos(p), math.sin(y), math.cos(y)
	return cp*cy, cp*sy, -sp
end

local function can_enemy_hit_on_peek(ent,ticks)	
	if ent == nil then return end
	
	local origin_x, origin_y, origin_z = entity.get_prop(ent, "m_vecOrigin")
	if origin_z == nil then return end
	
	local sx,sy,sz = entity.hitbox_position(entity.get_local_player(), 11)
	local dx,dy,dz = entity.hitbox_position(entity.get_local_player(), 12)

	sx,sy,sz = extrapolate_position(sx, sy, sz, ticks, entity.get_local_player())
	dx,dy,dz = extrapolate_position(dx, dy, dz, ticks, entity.get_local_player())
	
	local ___, left_dmg = client.trace_bullet(ent, origin_x, origin_y, origin_z, sx, sy, sz, true)
	local __, right_dmg = client.trace_bullet(ent, origin_x, origin_y, origin_z, dx, dy, dz, true)

	local left_hittable = left_dmg ~= nil and left_dmg > 12
	local right_hittable = right_dmg ~= nil and right_dmg > 12
	local hittable = (left_hittable or right_hittable) and get_velocity(entity.get_local_player()) 
	
	return hittable
end

local function GetClosestPoint(A, B, P)
    local a_to_p = { P[1] - A[1], P[2] - A[2] }
    local a_to_b = { B[1] - A[1], B[2] - A[2] }

    local atb2 = a_to_b[1]^2 + a_to_b[2]^2

    local atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    local t = atp_dot_atb / atb2
        
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end

local function clipboard_import( )
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

local function clipboard_export(string)
	if string then
		set_clipboard_text(VGUI_System, string, string:len())
	end
end

local function str_to_sub(input, sep)
	local t = {}
	for str in string.gmatch(input, "([^"..sep.."]+)") do
		t[#t + 1] = string.gsub(str, "\n", "")
	end
	return t
end

local function load_cfg(input)
	local tbl = str_to_sub(input, ",")

	ui.set(anti_aim[1].addition, tbl[1])
	ui.set(anti_aim[1].styaw, tonumber(tbl[2]))
    ui.set(anti_aim[1].ndyaw, tonumber(tbl[3]))
    ui.set(anti_aim[1].flick_speed, tonumber(tbl[4]))
	ui.set(anti_aim[1].body_yaw, tbl[5])
    ui.set(anti_aim[1].body_yaw_val, tonumber(tbl[6]))
    ui.set(anti_aim[1].jitter_yaw, tbl[7])
    ui.set(anti_aim[1].jitter_yaw_val, tonumber(tbl[8]))
    ui.set(anti_aim[1].fake_addition, tbl[9])
	ui.set(anti_aim[1].stfake_val, tonumber(tbl[10]))
    ui.set(anti_aim[1].ndfake_val, tonumber(tbl[11]))
    ui.set(anti_aim[1].flick_speed2, tonumber(tbl[12]))
    ui.set(anti_aim[2].addition, tbl[13])
	ui.set(anti_aim[2].styaw, tonumber(tbl[14]))
    ui.set(anti_aim[2].ndyaw, tonumber(tbl[15]))
    ui.set(anti_aim[2].flick_speed, tonumber(tbl[16]))
	ui.set(anti_aim[2].body_yaw, tbl[17])
    ui.set(anti_aim[2].body_yaw_val, tonumber(tbl[18]))
    ui.set(anti_aim[2].jitter_yaw, tbl[19])
    ui.set(anti_aim[2].jitter_yaw_val, tonumber(tbl[20]))
    ui.set(anti_aim[2].fake_addition, tbl[21])
	ui.set(anti_aim[2].stfake_val, tonumber(tbl[22]))
    ui.set(anti_aim[2].ndfake_val, tonumber(tbl[23]))
    ui.set(anti_aim[2].flick_speed2, tonumber(tbl[24]))
    ui.set(anti_aim[3].addition, tbl[25])
	ui.set(anti_aim[3].styaw, tonumber(tbl[26]))
    ui.set(anti_aim[3].ndyaw, tonumber(tbl[27]))
    ui.set(anti_aim[3].flick_speed, tonumber(tbl[28]))
	ui.set(anti_aim[3].body_yaw, tbl[29])
    ui.set(anti_aim[3].body_yaw_val, tonumber(tbl[30]))
    ui.set(anti_aim[3].jitter_yaw, tbl[31])
    ui.set(anti_aim[3].jitter_yaw_val, tonumber(tbl[32]))
    ui.set(anti_aim[3].fake_addition, tbl[33])
	ui.set(anti_aim[3].stfake_val, tonumber(tbl[34]))
    ui.set(anti_aim[3].ndfake_val, tonumber(tbl[35]))
    ui.set(anti_aim[3].flick_speed2, tonumber(tbl[36]))
    ui.set(anti_aim[4].addition, tbl[37])
	ui.set(anti_aim[4].styaw, tonumber(tbl[38]))
    ui.set(anti_aim[4].ndyaw, tonumber(tbl[39]))
    ui.set(anti_aim[4].flick_speed, tonumber(tbl[40]))
	ui.set(anti_aim[4].body_yaw, tbl[41])
    ui.set(anti_aim[4].body_yaw_val, tonumber(tbl[42]))
    ui.set(anti_aim[4].jitter_yaw, tbl[43])
    ui.set(anti_aim[4].jitter_yaw_val, tonumber(tbl[44]))
    ui.set(anti_aim[4].fake_addition, tbl[45])
	ui.set(anti_aim[4].stfake_val, tonumber(tbl[46]))
    ui.set(anti_aim[4].ndfake_val, tonumber(tbl[47]))
    ui.set(anti_aim[4].flick_speed2, tonumber(tbl[48]))

	client.log("Loaded custom preset from clipboard")
end

local function save_cfg()
	local str = ""

	for i=1, 4 do

		str = str .. tostring(ui.get(anti_aim[i].addition)) .. ","
		.. tostring(ui.get(anti_aim[i].styaw)) .. ","
		.. tostring(ui.get(anti_aim[i].ndyaw)) .. ","
		.. tostring(ui.get(anti_aim[i].flick_speed)) .. ","
		.. tostring(ui.get(anti_aim[i].body_yaw)) .. ","
		.. tostring(ui.get(anti_aim[i].body_yaw_val)) .. ","
		.. tostring(ui.get(anti_aim[i].jitter_yaw)) .. ","
		.. tostring(ui.get(anti_aim[i].jitter_yaw_val)) .. ","
		.. tostring(ui.get(anti_aim[i].fake_addition)) .. ","
		.. tostring(ui.get(anti_aim[i].stfake_val)) .. ","
		.. tostring(ui.get(anti_aim[i].ndfake_val)) .. ","
		.. tostring(ui.get(anti_aim[i].flick_speed2)) .. ","
	end

	clipboard_export(str)
	client.log("Save custom anti-aim preset to clipboard")
end

local function stop_micromove(cmd)
    if (math.abs(cmd.forwardmove) > 1) or (math.abs(cmd.sidemove) > 1) or cmd.in_jump == 1 then
        return
    end

    if (entity.get_prop(entity.get_local_player(), "m_MoveType")) == 9 then --ladder fix
        return
    end

    cmd.forwardmove = 0.000000000000000000000000000000001
    cmd.in_forward = 1.5
end

local function oppositefix(cmd)
    local desync_amount = antiaim_funcs.get_desync(2)
    if math.abs(desync_amount) < 15 or cmd.chokedcommands == 0 then
        return
    end

    stop_micromove(cmd)
end

local function weapon_is_enabled(idx)
	if (idx == 38 or idx == 11) then
		return true
	elseif (idx == 40) then
		return true
	elseif (idx == 9) then
		return true
	elseif (idx == 64) then
		return true
	elseif (idx == 1) then
		return true
	else
		return true
	end
	return false
end

local function is_lethal_enemy(player)
    local local_player = entity.get_local_player()
    if local_player == nil or not entity.is_alive(local_player) then return end
    local local_origin = vector(entity.get_prop(local_player, "m_vecAbsOrigin"))
    local distance = local_origin:dist(vector(entity.get_prop(player, "m_vecOrigin")))
    local enemy_health = entity.get_prop(player, "m_iHealth")

	local weapon_ent = entity.get_player_weapon(entity.get_local_player())
	if weapon_ent == nil then return end
	
	local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
	if weapon_idx == nil then return end
	
	local weapon = csgo_weapons[weapon_idx]
	if weapon == nil then return end

	if not weapon_is_enabled(weapon_idx) then return end

	local dmg_after_range = (weapon.damage * math.pow(weapon.range_modifier, (distance * 0.002))) * 1.25
	local armor = entity.get_prop(player,"m_ArmorValue")
	local newdmg = dmg_after_range * (weapon.armor_ratio * 0.5)
	if dmg_after_range - (dmg_after_range * (weapon.armor_ratio * 0.5)) * 0.5 > armor then
		newdmg = dmg_after_range - (armor / 0.5)
	end
	return newdmg >= enemy_health
end

local function is_lethal_lp(player)
    local local_player = entity.get_local_player()
    if local_player == nil or not entity.is_alive(local_player) then return end
    local local_origin = vector(entity.get_prop(player, "m_vecAbsOrigin"))
    local distance = local_origin:dist(vector(entity.get_prop(local_player, "m_vecOrigin")))
    local enemy_health = entity.get_prop(local_player, "m_iHealth")

	local weapon_ent = entity.get_player_weapon(player)
	if weapon_ent == nil then return end
	
	local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
	if weapon_idx == nil then return end
	
	local weapon = csgo_weapons[weapon_idx]
	if weapon == nil then return end

	if not weapon_is_enabled(weapon_idx) then return end

	local dmg_after_range = (weapon.damage * math.pow(weapon.range_modifier, (distance * 0.002))) * 1.25
	local armor = entity.get_prop(local_player,"m_ArmorValue")
	local newdmg = dmg_after_range * (weapon.armor_ratio * 0.5)
	if dmg_after_range - (dmg_after_range * (weapon.armor_ratio * 0.5)) * 0.5 > armor then
		newdmg = dmg_after_range - (armor / 0.5)
	end
	return newdmg >= enemy_health
end


client.set_event_callback("bullet_impact", function(c)
    
    if entity.is_alive(entity.get_local_player()) then
        local ent = client.userid_to_entindex(c.userid)
        if not entity.is_dormant(ent) and entity.is_enemy(ent) then
            local ent_shoot = { entity.get_prop(ent, "m_vecOrigin") }
            ent_shoot[3] = ent_shoot[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
            local player_head = { entity.hitbox_position(entity.get_local_player(), 0) }
            local closest = GetClosestPoint(ent_shoot, { c.x, c.y, c.z }, player_head)
            local delta = { player_head[1]-closest[1], player_head[2]-closest[2] }
            local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)
            local ab_range = 32
            local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
            if math.abs(delta_2d) < ab_range then
                should_swap = globals.curtime()
                --android_notify:paint(3, 'Switched side due to shot')
                if bodyyaw < 0 then
                    left_side = true
                    right_side = false
                elseif bodyyaw > 0 then
                    right_side = true
                    left_side = false
                end
            else
                curprintlog = globals.curtime()
            end
        end
    end
end)

local function roll_move_fix(cmd, lp_vel, side, angle)
    local lp_vel_normalize = lp_vel > 180 and 180 or lp_vel
    local vel_roll = 120 - math.abs(lp_vel_normalize) + angle

    vel_roll = vel_roll * side

    return vel_roll
end

local function modify_velocity(cmd, goalspeed)
	if goalspeed <= 0 then
		return
	end
	
	local minimalspeed = math.sqrt((cmd.forwardmove * cmd.forwardmove) + (cmd.sidemove * cmd.sidemove))
	
	if minimalspeed <= 0 then
		return
	end
	
	if cmd.in_duck == 1 then
		goalspeed = goalspeed * 2.94117647 -- wooo cool magic number
	end
	
	if minimalspeed <= goalspeed then
		return
	end
	
	local speedfactor = goalspeed / minimalspeed
	cmd.forwardmove = cmd.forwardmove * speedfactor
	cmd.sidemove = cmd.sidemove * speedfactor
end

local function extrapolating_position(ent, ticks)
    local vx, vy, vz = entity.get_prop(ent, "m_vecVelocity")
    local ex, ey, ez = entity.hitbox_position(ent, 2)
    for i=0, ticks do
        ex, ey, ez = ex + (vx * globals.tickinterval()), ey + (vy * globals.tickinterval()), ez + (vz * globals.tickinterval())
    end
    return ex, ey, ez
end

local function distance_3d(x1,y1,z1,x2,y2,z2)
    return math.sqrt( (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) )
end

local function extrapolate(player , ticks , x,y,z )
    local xv,yv,zv =  entity.get_prop(player, "m_vecVelocity")
    local new_x = x + globals.tickinterval() * xv * ticks
    local new_y = y + globals.tickinterval() * yv * ticks
    local new_z = z + globals.tickinterval() * zv * ticks

    return new_x,new_y,new_z
end

local function enemy_side_peek(enemy, ...)
    local localplayer = entity.get_local_player()
    local lx, ly, lz = entity.get_prop(localplayer, "m_vecOrigin") -- to
	local enemyx, enemyy, enemyz = entity.get_prop(enemy, "m_vecOrigin") -- from
	local bestangle = nil
	local lowest_dmg = math.huge
	local last_moved = 0
	local fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z = nil
	if(entity.is_alive(enemy)) then
		local yaw = CalcAngle(enemyx, enemyy, lx, ly)
		for i,v in pairs({...}) do
			local dir_x, dir_y, dir_z = Angle_Vector(0, (yaw + v))
			local end_x = lx + dir_x * 55
			local end_y = ly + dir_y * 55
			local end_z = lz + 80
			local eyepos_x, eyepos_y, eyepos_z = entity.hitbox_position(enemy, 0)
			local local_velocity = getspeed(enemy)
			local can_be_extrapolated = local_velocity > 15
			local ticks_to_extrapolate = 11
			if (local_velocity < 50) then
				ticks_to_extrapolate = 90
			elseif (local_velocity >= 50 and local_velocity < 120) then
				ticks_to_extrapolate = 50
			elseif (local_velocity >= 120 and local_velocity < 190) then
				ticks_to_extrapolate = 40
			elseif (local_velocity >= 190) then
				ticks_to_extrapolate = 20
			end

			if can_be_extrapolated then
				eyepos_x, eyepos_y, eyepos_z = extrapolate_position(eyepos_x, eyepos_y, eyepos_z, ticks_to_extrapolate, enemy)
				fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z = eyepos_x, eyepos_y, eyepos_z
				last_moved = globals.curtime() + 1
			else
				if last_moved ~= 0 then
					if globals.curtime() > last_moved then
						last_moved = 0
						fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z = nil
					else
						eyepos_x, eyepos_y, eyepos_z = fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z
					end
				else
					eyepos_x, eyepos_y, eyepos_z = extrapolate_position(eyepos_x, eyepos_y, eyepos_z, ticks_to_extrapolate, enemy)
				end
			end
			
			local index, damage = client.trace_bullet(enemy, enemyx, enemyy, enemyz + 70, end_x, end_y, end_z,true)
			local index2, damage2 = client.trace_bullet(enemy, enemyx, enemyy, enemyz + 70, end_x + 12, end_y, end_z,true)
			local index3, damage3 = client.trace_bullet(enemy, enemyx, enemyy, enemyz + 70, end_x - 12, end_y, end_z,true)

			if fs_stored_eyepos_x ~= nil then
				index, damage = client.trace_bullet(enemy, fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z + 70, end_x, end_y, end_z,true)
				index2, damage2 = client.trace_bullet(enemy, fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z + 70, end_x + 12, end_y, end_z,true)
				index3, damage3 = client.trace_bullet(enemy, fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z + 70, end_x - 12, end_y, end_z,true)
			end

			if(damage < lowest_dmg) then
				lowest_dmg = damage
				if(damage2 > damage) then
					lowest_dmg = damage2
				end
				if(damage3 > damage) then
					lowest_dmg = damage3
				end	
				if(enemyx - lx > 0) then
					bestangle = v
				else
				bestangle = v * -1
				end
			elseif(damage == lowest_dmg) then
				return 0
			end
		end
	end
	return bestangle
end

local function is_local_peeking_enemy(player)
    local vx,vy,vz = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local speed = math.sqrt(vx*vx + vy*vy + vz*vz)
    if speed < 5 then
        return false
    end
    local ex,ey,ez = entity.get_origin(player)
    local lx,ly,lz = entity.get_origin(entity.get_local_player())
    local start_distance = math.abs(distance_3d(ex,ey,ez,lx,ly,lz))
    local smallest_distance = 999999
    for ticks = 1,25 do

        local tex,tey,tez = extrapolate(entity.get_local_player(),ticks,lx,ly,lz)
        local distance = distance_3d(ex,ey,ez,tex,tey,tez)

        if distance < smallest_distance then
            smallest_distance = math.abs(distance)
        end
    if smallest_distance < start_distance then
            return true
        end
    end
    return smallest_distance < start_distance
end

local function is_enemy_peeking(player)
    local vx,vy,vz = entity.get_prop(player, "m_vecVelocity")
    local speed = math.sqrt(vx*vx + vy*vy + vz*vz)
    if speed < 5 then
        return false
    end
    local ex,ey,ez = entity.get_origin(player)
    local lx,ly,lz = entity.get_origin(entity.get_local_player())
    local start_distance = math.abs(distance_3d(ex,ey,ez,lx,ly,lz))
    local smallest_distance = 999999
    for ticks = 1,25 do

        local tex,tey,tez = extrapolate(player,ticks,ex,ey,ez)
        local distance = math.abs(distance_3d(tex,tey,tez,lx,ly,lz))

        if distance < smallest_distance then
            smallest_distance = distance
        end
        if smallest_distance < start_distance then
            return true
        end
    end

    return smallest_distance < start_distance
end

client.set_event_callback("aim_hit", function(e)
    
    local enemies = entity.get_players(true)
    local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local name = string.lower(entity.get_player_name(e.target))
    local health = entity.get_prop(e.target, 'm_iHealth')
    local menu_r, menu_b, menu_g, menu_a = ui.get(menu_c)
    local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60 )
    if health == 0 and ui.get(killsay) then
        client.exec(killsays[math.random(1,5)])
    end
    if not ui.get(enablelogger) then return end

    if contains(logsprinted, "Notify") then
    android_notify:paint(3, string.format('Registred shot at '..name.."'s "..hgroup..' for '..e.damage..' remaining ('..health..'hp) at angle: ['..angle..']'))
    end
    if contains(logsprinted, "Console") then
    print(string.format('Registred shot at '..name.."'s "..hgroup..' for '..e.damage..' remaining ('..health..'hp) at angle: ['..angle..']'))
    end
end)

client.set_event_callback("aim_miss", function(e)
    
    local enemies = entity.get_players(true)
    local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local name = string.lower(entity.get_player_name(e.target))
    local health = entity.get_prop(e.target, 'm_iHealth')
    local menu_r, menu_b, menu_g, menu_a = ui.get(menu_c)
    local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60 )
    if ui.get(enablelogger) then 
        if contains(logsprinted, "Notify") then
            android_notify:paint(3, string.format('Missed shot at '..name.."'s "..hgroup..' due to '..e.reason..' remaining ('..health..'hp) at angle: ['..angle..']'))
        end
        if contains(logsprinted, "Console") then
            print(string.format('Missed shot at '..name.."'s "..hgroup..' due to '..e.reason..' remaining ('..health..'hp) at angle: ['..angle..']'))
        end
    end
    if e.reason ~= "?" then return end
    if not player_memory[e.target] then
        table.insert(player_memory, e.target, {
            misses = misses + 1
        })
    else
        if player_memory[e.target].misses == nil or player_memory[e.target].misses == true or player_memory[e.target].misses == false then player_memory[e.target].misses = 0 end
        player_memory[e.target].misses = player_memory[e.target].misses + 1
    end
end)

local function swap(ent) 
    local active_weapon = entity.get_prop(ent, "m_hActiveWeapon")

    local nextAttack = entity.get_prop(ent,"m_flNextAttack") 
    local nextShot = entity.get_prop(active_weapon,"m_flNextPrimaryAttack")
    local nextShotSecondary = entity.get_prop(active_weapon,"m_flNextSecondaryAttack")

    if nextAttack == nil or nextShot == nil or nextShotSecondary == nil then
        return
    end

    if curswap + 1 < globals.curtime() and entity.is_alive(ent) then
    nextShot2 = nextShot
    curswap = globals.curtime()
    end

    if nextShot2 < nextShot then swapping = true else swapping = false end
    
    return swapping
end

    ffi.cdef[[
        struct animation_layer_t {
            char pad20[24];
            uint32_t m_nSequence;
            float m_flPrevCycle;
            float m_flWeight;
            char pad20[8];
            float m_flCycle;
            void *m_pOwner;
            char pad_0038[ 4 ];
        };
        struct c_animstate { 
            char pad[ 3 ];
            char m_bForceWeaponUpdate; //0x5
            char pad1[ 91 ];
            void* m_pBaseEntity; //0x60
            void* m_pActiveWeapon; //0x64
            void* m_pLastActiveWeapon; //0x68
            float m_flLastClientSideAnimationUpdateTime; //0x6C
            int m_iLastClientSideAnimationUpdateFramecount; //0x70
            float m_flAnimUpdateDelta; //0x74
            float m_flEyeYaw; //0x78
            float m_flPitch; //0x7C
            float m_flGoalFeetYaw; //0x80
            float m_flCurrentFeetYaw; //0x84
            float m_flCurrentTorsoYaw; //0x88
            float m_flUnknownVelocityLean; //0x8C
            float m_flLeanAmount; //0x90
            char pad2[ 4 ];
            float m_flFeetCycle; //0x98
            float m_flFeetYawRate; //0x9C
            char pad3[ 4 ];
            float m_fDuckAmount; //0xA4
            float m_fLandingDuckAdditiveSomething; //0xA8
            char pad4[ 4 ];
            float m_vOriginX; //0xB0
            float m_vOriginY; //0xB4
            float m_vOriginZ; //0xB8
            float m_vLastOriginX; //0xBC
            float m_vLastOriginY; //0xC0
            float m_vLastOriginZ; //0xC4
            float m_vVelocityX; //0xC8
            float m_vVelocityY; //0xCC
            char pad5[ 4 ];
            float m_flUnknownFloat1; //0xD4
            char pad6[ 8 ];
            float m_flUnknownFloat2; //0xE0
            float m_flUnknownFloat3; //0xE4
            float m_flUnknown; //0xE8
            float m_flSpeed2D; //0xEC
            float m_flUpVelocity; //0xF0
            float m_flSpeedNormalized; //0xF4
            float m_flFeetSpeedForwardsOrSideWays; //0xF8
            float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
            float m_flTimeSinceStartedMoving; //0x100
            float m_flTimeSinceStoppedMoving; //0x104
            bool m_bOnGround; //0x108
            bool m_bInHitGroundAnimation; //0x109
            float m_flTimeSinceInAir; //0x10A
            float m_flLastOriginZ; //0x10E
            float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
            float m_flStopToFullRunningFraction; //0x116
            char pad7[ 4 ]; //0x11A
            float m_flMagicFraction; //0x11E
            char pad8[ 60 ]; //0x122
            float m_flWorldForce; //0x15E
            char pad9[ 462 ]; //0x162
            float m_flMaxYaw; //0x334
        };
    ]]

    local classptr = ffi.typeof('void***')
    local rawientitylist = client.create_interface('client.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)

    local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
    local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity is nil', 2)

    function GetAnimationState(_Entity)
        if not (_Entity) then
            return
        end
        local player_ptr = ffi.cast( "void***", get_client_entity(ientitylist, _Entity))
        local animstate_ptr = ffi.cast( "char*" , player_ptr ) + 0x9960
        local state = ffi.cast( "struct animation_layer_t**", animstate_ptr )[0]
    
        return state
    end

    function GetAnimationState1(_Entity)
        if not (_Entity) then
            return
        end
        local player_ptr = ffi.cast( "void***", get_client_entity(ientitylist, _Entity))
        local animstate_ptr = ffi.cast( "char*" , player_ptr ) + 0x9960
        local state = ffi.cast( "struct c_animstate**", animstate_ptr )[0]
    
        return state
    end

    function GetPlayerCycle(_Entity)
        local S_animationState_t = GetAnimationState(_Entity)
        local nValue =
            (S_animationState_t.m_flCycle * -0.30000001 - 0.19999999) + 1
        local nDeltaYaw = nValue
        return nDeltaYaw < 60 and nDeltaYaw >= 0 and nDeltaYaw or 0
    end

    function WeaponUpdateSide(_Entity)
        local swapping = swap(_Entity)
        local S_animationState_t = GetAnimationState1(_Entity)
        if swapping == true then
        local nValue = S_animationState_t.m_bForceWeaponUpdate
        local animside = (nValue == 51 and "left" or "right")
        return animside
        end
    end

    function GetPlayerLean(_Entity)
        local S_animationState_t = GetAnimationState1(_Entity)
        local nValue =
            (S_animationState_t.m_flLeanAmount * -0.30000001 - 0.19999999) + 1
        local nDeltaYaw = nValue
        return nDeltaYaw < 60 and nDeltaYaw >= 0 and nDeltaYaw or 0
    end

    function DesyncLean(_Entity)
        local S_animationState_t = GetAnimationState1(_Entity)
        local nValue =
            (S_animationState_t.m_flFeetYawRate * -0.30000001 - 0.19999999) + 1
        local nDeltaYaw = nValue
        return nDeltaYaw < 60 and nDeltaYaw >= 0 and nDeltaYaw or 0
    end

    local function player_angle(speed, yaw, lowdelta, slowwalk, cycle)
        local enemy_vel = speed
        local lowangle = lowdelta
        local enemy_yaw = yaw*-1
        local max_angle = 60
        local stabile_velo = enemy_vel/7.5
        local max_yaw = 0
        local max_yaw2 = 0
        local result = 0

        if cycle < 0 then cycle = cycle*1 else cycle = cycle end
    
        if (enemy_yaw > -100 and enemy_yaw < -16) or (enemy_yaw > 16 and enemy_yaw < 100) then stabile_enemy_yaw = enemy_yaw/4.5 else stabile_enemy_yaw = 0 end
    
        max_yaw = max_angle - stabile_velo

        max_yaw2 = max_angle - stabile_enemy_yaw

        if max_yaw < 27 then max_yaw = 27 else max_yaw = max_yaw end

        if (enemy_yaw > -100 and enemy_yaw < -70) or (enemy_yaw > 70 and enemy_yaw < 100) then
        if max_yaw2 < 20 then max_yaw2 = 20 else max_yaw2 = max_yaw2 end
        else
        if max_yaw2 < 29 then max_yaw2 = 29 else max_yaw2 = max_yaw2 end
        end
    
        stabile_enemy_yaw = math.floor(stabile_enemy_yaw)
    
        if max_yaw2 < max_yaw then result = -max_yaw2 else result = max_yaw end
    
        if (enemy_yaw > -100 and enemy_yaw < -16) or (enemy_yaw > 16 and enemy_yaw < 100) then
            result = result
        else
            result = data.side == 1 and result or -result
        end

        result = math.floor(result)
        
        return result
    end

    
    local function state(lp_vel)
        if lp_vel < 5 and not in_air(entity.get_local_player()) and not ((is_crouching(entity.get_local_player())) or ui.get(fake_duck)) then
            cnds = 1
        elseif in_air(entity.get_local_player()) then
            cnds = 3
        elseif ((is_crouching(entity.get_local_player()) and not in_air(entity.get_local_player())) or ui.get(fake_duck)) then
            cnds = 4
        else
            cnds = 2
        end

        return cnds
    end

client.set_event_callback("setup_command", function(cmd)
    
    oppositefix(cmd)
    local weaponn = entity.get_player_weapon()
    local menu_r, menu_b, menu_g, menu_a = ui.get(menu_c)
    ChokedCommands = cmd.chokedcommands

    if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
        if cmd.in_attack == 1 then
            cmd.in_attack = 0 
            cmd.in_use = 1
        end
    else
        if cmd.chokedcommands == 0 then
            cmd.in_use = 0
        end
    end
    if cmd.chokedcommands == 0 then
        if cmd.in_use == 1 then
            angle = 0
        else
            angle = math.min(57, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60))
        end
    end

    local lp_vel = get_velocity(entity.get_local_player())
    local ticks_to_extrapolate = math.floor(0.5 + client.latency() / globals.tickinterval()) + ui.get(extrapolate_add)
    local sim_time = entity.get_prop(entity.get_local_player(), "m_flSimulationTime")
    local local_pos = vector(extrapolating_position(entity.get_local_player(), ticks_to_extrapolate))
    local lpweapon = entity.get_player_weapon(entity.get_local_player())
    local wpnclassname = entity.get_classname(lpweapon)
    local wpnindx = bit.band(65535,entity.get_prop(lpweapon, "m_iItemDefinitionIndex"))
    local hit_chance = math.floor(100 - (get_inaccuracy(get_client_entity2(lpweapon))*100))
    local delayshot = ui.get(accuracy_def) == -1 and math.floor(client.latency()*10) or (ui.get(accuracy_def)/10)
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local enablelean = ui.get(forcesafe)
    local side = bodyyaw > 0 and 1 or -1
    local vel_roll = roll_move_fix(cmd, lp_vel, side, angle)
    local doubletap_ref = ui.get(dt) and ui.get(dt_key)
    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
    local m_velocity = vector(entity.get_prop(entity.get_local_player(), 'm_vecVelocity'))
    local distance_per_tick = m_velocity:length2d() * globals.tickinterval()
    local state = state(lp_vel)

    if on_ground == 1 then
        ground_ticks = ground_ticks + 1
    else
        ground_ticks = 0
        end_time = globals.curtime() + 1
    end 

    local exploting = ui.get(dt_key) or ui.get(os_key) or ui.get(fake_duck)
    if not exploting and ui.get(slowwalk) then
       -- ui.set(sw_type, (flipJitter and "Favor anti-aim" or "Favor high speed"))
    else
       -- ui.set(sw_type, "Favor high speed")
    end

    --[[if ui.get(slowwalk) then
        if ui.get(sw_type) == "Favor high speed" or cmd.in_attack == 1 or exploting then
            modify_velocity(cmd, (exploting and 50 or 32))
            ui.set(rollskeet, 0)
            cmd.roll = 0
        elseif ui.get(sw_type) == "Favor anti-aim" and cmd.in_attack == 0 and not exploting then
            cmd.roll = -50*side
            ui.set(rollskeet, -50*side)
        end
    end]]

    local moving_t = distance_per_tick > 0.0158 and not in_air(entity.get_local_player()) and (contains(triggers, "  Moving") or contains(triggers, "Movement"))
    
    local air_t = in_air(entity.get_local_player()) and (contains(triggers, "  In air") or contains(triggers, "Movement"))

    local standing_t = distance_per_tick < 0.0158 and (contains(triggers, "  Standing") or contains(triggers, "Animations"))

    local land_heavy_t = ground_ticks > cmd.chokedcommands+1 and end_time > globals.curtime() and (contains(triggers, "  Anim layers") or contains(triggers, "Animations"))

    if air_t or moving_t or land_heavy_t or standing_t or ui.get(fake_duck) then
        triggering = true 
    else
        triggering = false
    end 

    local lc = in_air(entity.get_local_player()) or distance_per_tick >= 3 or (doubletap_ref and distance_per_tick > 0.0158)
        
    if ui.get(fake_duck) then
        fakelags = 15
    else
        if (cmd.in_attack == 1 and contains(forcelimit, "On shot") and not (wpnindx == 44 or wpnindx == 46 or wpnindx == 43 or wpnindx == 47 or wpnindx == 45 or wpnindx == 48)) or (distance_per_tick < 0.0158 and not in_air(entity.get_local_player()) and contains(forcelimit, "On stand")) or (ui.get(os_key) and contains(forcelimit, "On hide-shots")) then
            fakelags = 1
        elseif ui.get(fltab) == "Maximum" then
            fakelags = ui.get(sendlimit)
        elseif ui.get(fltab) == "Dynamic" then
            fakelags = (triggering == true and ui.get(triggerlimit) or ui.get(sendlimit))
        else
            fakelags = (flipJitter and ui.get(triggerlimit) or ui.get(sendlimit))
        end
    end

    
    local fl_stabile = lc and 14 or fakelags

    local send = consistent(14,15)
    local lagcomp = lc and send or 2
    local outgoing_cmd = globals.lastoutgoingcommand()
    local amount = apply_variance(lagcomp, 1, outgoing_cmd) == 2 and fl_stabile or 0

    if ui.get(enablecustomfl) then
        ui.set(enablefl, false)
        ui.set(fl_limit,fakelags)
        ui.set(fl_amount, "Maximum")
        ui.set(fl_var, 0)

        cmd.allow_send_packet = amount
    else
        ui.set(enablefl, true)
    end

    if not ui.is_menu_open() then
        if enablelean and not ui.get(fake_duck) then
        cmd.roll = 180
        ui.set(rollskeet, 45*side)
        else
        cmd.roll = 0
        ui.set(rollskeet, 0)
        end
    end

    local enemies = entity.get_players(true)
    local pitch, yaw = client.camera_angles()
    local vx, vy, vz = angle_to_vec(pitch, yaw)
    
    local closest_fov_cos = -1
    enemyclosesttocrosshair = nil

    for itter = 1, #enemies do
        local i = enemies[itter]
        if not player_memory[i] then
            table.insert(player_memory, i, {
                notifilethalwas = false,
                misses = 0,
                value = 0
            })
        end

        if player_memory[i].misses == nil then player_memory[i].misses = 0 end
        if player_memory[i].value == nil then player_memory[i].value = 0 end
        
        local fov_cos = get_fov_cos(i, vx,vy,vz, lx,ly,lz)

        if entity.is_alive(i) then
            if fov_cos > closest_fov_cos then
                closest_fov_cos = fov_cos
                enemyclosesttocrosshair = i
            end
        end

        lpx, lpy, lpz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        enemyx, enemyy, enemyz = entity.get_prop(enemyclosesttocrosshair, "m_vecOrigin")

        ent, dmg = client.trace_bullet(enemyclosesttocrosshair, enemyx, enemyy, enemyz, lpx, lpy, lpz)
        ent2, dmg2 = client.trace_bullet(enemyclosesttocrosshair, lpx, lpy, lpz, enemyx, enemyy, enemyz)
        if dmg2 == 1 or dmg2 > 100 then dmg2 = 100 else dmg2 = dmg2 end

        enemy_pos = vector(extrapolating_position(i, ticks_to_extrapolate))
        peeking = enemy_side_peek(i, -90, 90)
        ent3, dmg3 = client.trace_bullet(entity.get_local_player(), local_pos.x, local_pos.y, local_pos.z, enemy_pos.x, enemy_pos.y, enemy_pos.z, false)

        if is_lethal_lp(enemyclosesttocrosshair) then
            lp_lethal = true
        else
            lp_lethal = false
        end

        if is_lethal_enemy(i) and contains(preferbodyif, "Lethal") and player_memory[i].notifilethalwas == false and ui.get(printevents) then
            android_notify:paint(3, string.format(entity.get_player_name(i)..' is lethal now, setting preference body aim'))
            player_memory[i].notifilethalwas = true
        elseif is_lethal_enemy(i) and contains(forcebodyif, "Lethal") and player_memory[i].notifilethalwas == false and ui.get(printevents) then
            android_notify:paint(3, string.format(entity.get_player_name(i)..' is lethal now, setting force body aim'))
            player_memory[i].notifilethalwas = true
        end

        if is_lethal_enemy(i) then
            if contains(forcebodyif, "Lethal") then
                plist.set(i,"Override prefer body aim", "Force")
            elseif contains(preferbodyif, "Lethal") then
                plist.set(i,"Override prefer body aim", "On")
            else
                plist.set(i,"Override prefer body aim", "-")
            end
        elseif ui.get(damage) < 10 then
            if contains(forcebodyif, "Low Damage") then
                plist.set(i,"Override prefer body aim", "Force")
            elseif contains(preferbodyif, "Low Damage") then
                plist.set(i,"Override prefer body aim", "On")
            else
                plist.set(i,"Override prefer body aim", "-")
            end
        elseif in_air(i) then
            if contains(forcebodyif, "In Air") then
                plist.set(i,"Override prefer body aim", "Force")
            elseif contains(preferbodyif, "In Air") then
                plist.set(i,"Override prefer body aim", "On")
            else
                plist.set(i,"Override prefer body aim", "-")
            end
        elseif ui.get(dt_key) then
            if contains(forcebodyif, "DT Key Active") then
                plist.set(i,"Override prefer body aim", "Force")
            elseif contains(preferbodyif, "DT Key Active") then
                plist.set(i,"Override prefer body aim", "On")
            else
                plist.set(i,"Override prefer body aim", "-")
            end
        else
            plist.set(i,"Override prefer body aim", "-")
        end

        hitbox_pos = {x,y,z}
        hitbox_pos.x,hitbox_pos.y,hitbox_pos.z = entity.hitbox_position(i, 0)
        local_x, local_y, local_z = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        
         dynamic = calcu_angle(local_x, local_y, local_z, hitbox_pos.x,hitbox_pos.y,hitbox_pos.z)
         Pitch = entity.get_prop(i, "m_angEyeAngles[0]")
         FakeYaw = math.floor(normalize_yaw(entity.get_prop(i, "m_angEyeAngles[1]")))
                
         BackAng = math.floor(normalize_yaw(dynamic+180))
         LeftAng = math.floor(normalize_yaw(dynamic-90))
         RightAng = math.floor(normalize_yaw(dynamic+90))
         ForwAng = math.floor(normalize_yaw(dynamic))
         AreaDist = 35
                
                
        if (RightAng-FakeYaw <= AreaDist and RightAng-FakeYaw > -AreaDist) or (RightAng-FakeYaw >= -AreaDist and RightAng-FakeYaw < AreaDist) then
            iAngle[i] = "right"
        elseif (LeftAng-FakeYaw <= AreaDist and LeftAng-FakeYaw > -AreaDist) or (LeftAng-FakeYaw >= -AreaDist and LeftAng-FakeYaw < AreaDist) then
            iAngle[i] = "left"
        elseif (BackAng-FakeYaw <= AreaDist and BackAng-FakeYaw > -AreaDist) or (BackAng-FakeYaw >= -AreaDist and BackAng-FakeYaw < AreaDist) then
            iAngle[i] = "backward"
        elseif (ForwAng-FakeYaw <= AreaDist and ForwAng-FakeYaw > -AreaDist) or (ForwAng-FakeYaw >= -AreaDist and ForwAng-FakeYaw < AreaDist) then
            iAngle[i] = "forward"
        else
            iAngle[i] = nil
        end
         pitch_e = Pitch >= -10 and Pitch <= 51
         pitch_sideways = Pitch <= 90 and Pitch >= 70
         e_check = iAngle[i] == "forward" and pitch_e
         sideways_forward = iAngle[i] == "forward" and pitch_sideways
         sideways_left_right = iAngle[i] == "left" or iAngle[i] == "right"
        
        if e_check then
            if pressing_e_timer[i] == nil then
                pressing_e_timer[i] = 0
            end
            pressing_e_timer[i] = pressing_e_timer[i] + 1
        else
            pressing_e_timer[i] = 0
        end
        
         pressing_e = e_check and pressing_e_timer[i] > 5 and not in_air(i)
         onshot = e_check and pressing_e_timer[i] < 10 and not in_air(i)
         flags = entity.get_prop(i, "m_fFlags")
         slowwalking = bit.band(flags, bit.lshift(1, 0)) == 1 and bit.band(flags, bit.lshift(1, 1)) == 0
         speed = getspeed(i)
         enemy_yaw = (math.floor(normalize_yaw(dynamic)) - FakeYaw) > 0 and (math.floor(normalize_yaw(dynamic)) - FakeYaw) - 180 or (math.floor(normalize_yaw(dynamic)) - FakeYaw) + 180
         max_cycle = GetPlayerCycle(i)
         lean_player = GetPlayerLean(i)
         lowdelta_detect = DesyncLean(i)
         animside_player = WeaponUpdateSide(i)
         weapon = entity.get_player_weapon(i)
         in_grenade = entity.get_prop(weapon, 'm_bPinPulled') == true
         if not in_grenade then
            curtothrow = globals.curtime()
         end
         max_yaw = player_angle(speed, enemy_yaw, lowdelta_detect, slowwalking, max_cycle)
        if is_bot then
            player_memory[i].value = 0
        elseif speed > 5 and speed < 200 then
            if enemy_yaw > -16 and enemy_yaw < 16 then
                player_memory[i].value = 60
                if ui.get(resolver_cb) then
                    entity.set_prop(i, "m_angEyeAngles", -90, 0, 180)
                end
            else
                player_memory[i].value = -60
                if ui.get(resolver_cb) then
                    entity.set_prop(i, "m_angEyeAngles", -90, 0, -50)
                end
            end
        elseif animside_player ~= nil then
            if animside_player == "right" then
                player_memory[i].value = max_yaw
            elseif animside_player == "left" then
                player_memory[i].value = -max_yaw
            end
        elseif in_grenade and curtothrow + 1 > globals.curtime() then
            if plist.get(i,"Force body yaw value") > 0 then
                player_memory[i].value = -max_yaw
            else
                player_memory[i].value = max_yaw
            end
         else
            if player_memory[i].misses == 0 then
                player_memory[i].value = max_yaw
            elseif player_memory[i].misses == 1 then
                player_memory[i].value = -max_yaw
            elseif player_memory[i].misses == 2 then
                player_memory[i].value = -max_yaw
            elseif player_memory[i].misses == 3 then
                player_memory[i].misses = 0
            end
         end
         if ui.get(resolver_cb) then
            plist.set(i, "Force body yaw", true)
            plist.set(i, "Force body yaw value", player_memory[i].value)
         else
            plist.set(i, "Force body yaw", false)
            plist.set(i, "Force body yaw value", 0)
         end
         
         if ((peeking ~= 0 and is_enemy_peeking(i)) or client.visible(enemy_pos.x, enemy_pos.y, enemy_pos.z) or (dmg3 > ui.get(damage))) and lpweapon ~= 549 and lpweapon ~= 164 then
             if (globals.curtime()-tick_delay) > delayshot then
                 can_shoot = true
             else
                 can_shoot = false
             end
         else
             tick_delay = globals.curtime()
             can_shoot = false
         end
 
         if can_shoot and not in_air(i) and not in_air(entity.get_local_player()) then
             antidefensive = true
         else
             antidefensive = false
         end
    end

    if ui.get(enableantidef) then
        if cvar.sv_unlag:get_int() ~= 1 then
            cvar.sv_unlag:set_int(1)
        end
        if cvar.cl_clock_correction:get_int() ~= 0 then
            cvar.cl_clock_correction:set_int(0)
        end
        if antidefensive == true then
            if cvar.cl_lagcompensation:get_int() ~= 0 then
                cvar.cl_lagcompensation:set_int(0)
            end
            if cvar.sv_maxunlag:get_int() ~= 0 then
                cvar.sv_maxunlag:set_int(0)
            end
            ui.set(backtrack_ref, "Low")
        else
            if cvar.cl_lagcompensation:get_int() ~= 1 then
                cvar.cl_lagcompensation:set_int(1)
            end
            if cvar.sv_maxunlag:get_int() ~= 1 then
                cvar.sv_maxunlag:set_int(1)
            end
            ui.set(backtrack_ref, "Maximum")
        end
    else
        if cvar.sv_unlag:get_int() ~= 0 then
            cvar.sv_unlag:set_int(0)
        end
        if cvar.cl_clock_correction:get_int() ~= 0 then
            cvar.cl_clock_correction:set_int(0)
        end
        if cvar.cl_lagcompensation:get_int() ~= 1 then
            cvar.cl_lagcompensation:set_int(1)
        end
        if cvar.sv_maxunlag:get_int() ~= 1 then
            cvar.sv_maxunlag:set_int(1)
        end
        ui.set(backtrack_ref, "Maximum")
    end

end)

local function onshot_antiaim(side)
    ui.set(byaw_val, (side == 1 and 180 or -180))
    ui.set(byaw, "Static")
    ui.set(jyaw,"Off")
    ui.set(jyaw_val, 0)
    ui.set(fake_yaw, 59)
end

local function roll_antiaim(back_dir)
    ui.set(byaw_val, (back_dir and 180 or -180))
    ui.set(byaw, "Static")
    ui.set(jyaw,"Off")
    ui.set(jyaw_val, 0)
   -- ui.set(fake_yaw, 59)
end

local function leftpeek_antiaim()
    if ui.get(freestandtype) == "Peek Out" then
        ui.set(byaw_val, 180)
        ui.set(byaw, "Static")
        ui.set(jyaw,"Center")
        ui.set(jyaw_val, math.random(0,7))
       -- ui.set(fake_yaw, 59)
    else
        ui.set(byaw_val, -180)
        ui.set(byaw, "Static")
        ui.set(jyaw,"Center")
        ui.set(jyaw_val, math.random(-7,0))
        ui.set(fake_yaw, 59)
    end
end

local function rightpeek_antiaim()
    if ui.get(freestandtype) == "Peek Out" then
        ui.set(byaw_val, -180)
        ui.set(byaw, "Static")
        ui.set(jyaw,"Center")
        ui.set(jyaw_val, math.random(-7,0))
        --ui.set(fake_yaw, 59)
    else
        ui.set(byaw_val, 180)
        ui.set(byaw, "Static")
        ui.set(jyaw,"Center")
        ui.set(jyaw_val, math.random(0,7))
        --ui.set(fake_yaw, 59)
    end
end

local function slowwalk_antiaim()
    if right_side == true then
        ui.set(byaw_val, -180)
        ui.set(byaw, "Static")
        ui.set(jyaw,"Offset")
        ui.set(jyaw_val, 0)
       -- ui.set(fake_yaw, 59)
    else
        ui.set(byaw_val, 180)
        ui.set(byaw, "Static")
        ui.set(jyaw,"Offset")
        ui.set(jyaw_val, 0)
      --  ui.set(fake_yaw, 59)
    end
end

local function dangerous_antiaim(flipJitter)
    ui.set(byaw_val, 90)
    ui.set(byaw, "Static")
    ui.set(jyaw,"Offset")
    ui.set(jyaw_val, 5)
   -- ui.set(fake_yaw, (flipJitter and 20 or 35))
end

local function lethal_antiaim(adaptive_freestand)
    if adaptive_freestand == -90 then
        ui.set(byaw_val, 90)
        ui.set(byaw, "Static")
        ui.set(jyaw,"Center")
        ui.set(jyaw_val, math.random(0,7))
       -- ui.set(fake_yaw, 59)
    else
        ui.set(byaw_val, -90)
        ui.set(byaw, "Static")
        ui.set(jyaw,"Center")
        ui.set(jyaw_val, math.random(-7,0))
       -- ui.set(fake_yaw, 59)
    end
end

local function experimental_antiaim(lp_vel,bodyyaw)
    if lp_vel < 5 and not in_air(entity.get_local_player()) and not ((is_crouching(entity.get_local_player())) or ui.get(fake_duck)) then
        ui.set(byaw_val, 30)
        ui.set(byaw, "Jitter")
        ui.set(jyaw,"Center")
        ui.set(jyaw_val, 53)
       -- ui.set(fake_yaw, (flipJitter and 35 or 59))
    elseif in_air(entity.get_local_player()) then
        ui.set(byaw_val, 0)
        ui.set(byaw, "Jitter")
        ui.set(jyaw,"Center")
        ui.set(jyaw_val, 27)
       -- ui.set(fake_yaw, (flipJitter and 18 or 33))
    elseif ((is_crouching(entity.get_local_player()) and not in_air(entity.get_local_player())) or ui.get(fake_duck)) then
        ui.set(byaw_val, 0)
        ui.set(byaw, "Jitter")
        ui.set(jyaw,"Center")
        ui.set(jyaw_val, 61)
      --  ui.set(fake_yaw, 59)
    else
        ui.set(byaw_val, 90)
        ui.set(byaw, "Jitter")
        ui.set(jyaw,"Center")
        ui.set(jyaw_val, -47)
      --  ui.set(fake_yaw, 59)
    end
end

local function default_antiaim(lp_vel,bodyyaw)
    ui.set(byaw_val, 0)
    ui.set(byaw, "Jitter")
    ui.set(jyaw,"Offset")
    ui.set(jyaw_val, 0)
   -- ui.set(fake_yaw,59)
end

local function custom_antiaim(lp_vel, bodyyaw, state) 
        if ui.get(anti_aim[state].body_yaw) == "Randomize Jitter" then
            ui.set(byaw_val, math.random(1,2) == 1 and -ui.get(anti_aim[state].body_yaw_val) or ui.get(anti_aim[state].body_yaw_val))
            ui.set(byaw, "Static")
        else
            ui.set(byaw_val, ui.get(anti_aim[state].body_yaw_val))
            ui.set(byaw, ui.get(anti_aim[state].body_yaw))
        end
        if ui.get(anti_aim[state].jitter_yaw) == "Progressive" then 
            ui.set(jyaw, "Offset")
        else
            ui.set(jyaw, ui.get(anti_aim[state].jitter_yaw))
        end
        if ui.get(anti_aim[state].jitter_yaw) == "Progressive" then 
            ui.set(jyaw_val, globals.tickcount() % ui.get(anti_aim[state].jitter_yaw_val))
        else
            ui.set(jyaw_val, ui.get(anti_aim[state].jitter_yaw_val))
        end
        if ui.get(anti_aim[state].fake_addition) == "Random" then
       -- ui.set(fake_yaw, client.random_int(ui.get(anti_aim[state].stfake_val), ui.get(anti_aim[state].ndfake_val)))
        elseif ui.get(anti_aim[state].fake_addition) == "Jitter" then
        --ui.set(fake_yaw, (flipJitter and ui.get(anti_aim[state].stfake_val) or ui.get(anti_aim[state].ndfake_val)))
        elseif ui.get(anti_aim[state].fake_addition) == "Flick Between" or ui.get(anti_aim[state].fake_addition) == "Flick Around" then
        ui.set(fake_yaw, refs[state].flickfake_c)
        else
       -- ui.set(fake_yaw, (bodyyaw > 0 and ui.get(anti_aim[state].stfake_val) or ui.get(anti_aim[state].ndfake_val)))
        end
end

client.set_event_callback("paint", function(cmd)
    
        flipJitter = not flipJitter

        local local_velocity = get_velocity(entity.get_local_player())
        local lp_hittable = can_enemy_hit_on_peek(enemyclosesttocrosshair,16) and not in_air(entity.get_local_player())
        local lp_vel = get_velocity(entity.get_local_player())
        local state = state(lp_vel)

        if ui.get(presets) == "Custom" then
            refs[state].ticks_flick_c = globals.tickcount() % (ui.get(anti_aim[state].flick_speed) + 1)
        else
            if lp_vel < 5 and not in_air(entity.get_local_player()) and not ((is_crouching(entity.get_local_player())) or ui.get(fake_duck)) then
                refs[state].ticks_flick = globals.tickcount() % 19
            elseif in_air(entity.get_local_player()) then
                refs[state].ticks_flick = globals.tickcount() % 10
            elseif ((is_crouching(entity.get_local_player()) and not in_air(entity.get_local_player())) or ui.get(fake_duck)) then
                refs[state].ticks_flick = globals.tickcount() % 25
            else
                refs[state].ticks_flick = globals.tickcount() % 28
            end
        end

        if ui.get(presets) == "Custom" then
                refs[state].ticks_flick2_c = globals.tickcount() % (ui.get(anti_aim[state].flick_speed2) + 1)
        else
            if lp_vel < 5 and not in_air(entity.get_local_player()) and not ((is_crouching(entity.get_local_player())) or ui.get(fake_duck)) then
                refs[state].ticks_flick2 = globals.tickcount() % 10
            elseif in_air(entity.get_local_player()) then
                refs[state].ticks_flick2 = globals.tickcount() % 10
            elseif ((is_crouching(entity.get_local_player()) and not in_air(entity.get_local_player())) or ui.get(fake_duck)) then
                refs[state].ticks_flick2 = globals.tickcount() % 10
            else
                refs[state].ticks_flick2 = globals.tickcount() % 10
            end
        end

        if ui.get(presets) == "Custom" then
            refs[state].flicks_c = refs[state].ticks_flick_c == ui.get(anti_aim[state].flick_speed)
        else
            if lp_vel < 5 and not in_air(entity.get_local_player()) and not ((is_crouching(entity.get_local_player())) or ui.get(fake_duck)) then
                refs[state].flicks = refs[state].ticks_flick == 18
            elseif in_air(entity.get_local_player()) then
                refs[state].flicks = refs[state].ticks_flick == 9
            elseif ((is_crouching(entity.get_local_player()) and not in_air(entity.get_local_player())) or ui.get(fake_duck)) then
                refs[state].flicks = refs[state].ticks_flick == 24
            else
                refs[state].flicks = refs[state].ticks_flick == 27
            end
        end

        if ui.get(presets) == "Custom" then
            refs[state].flicks2_c = refs[state].ticks_flick2_c == ui.get(anti_aim[state].flick_speed2)
        else
            if lp_vel < 5 and not in_air(entity.get_local_player()) and not ((is_crouching(entity.get_local_player())) or ui.get(fake_duck)) then
                refs[state].flicks2 = refs[state].ticks_flick2 == 9
            elseif in_air(entity.get_local_player()) then
                refs[state].flicks2 = refs[state].ticks_flick2 == 9
            elseif ((is_crouching(entity.get_local_player()) and not in_air(entity.get_local_player())) or ui.get(fake_duck)) then
                refs[state].flicks2 = refs[state].ticks_flick2 == 9
            else
                refs[state].flicks2 = refs[state].ticks_flick2 == 9
            end
        end

        local health = entity.get_prop(entity.get_local_player(), 'm_iHealth')
        local armor = entity.get_prop(entity.get_local_player(), 'm_ArmorValue')
        local helmet = entity.get_prop(entity.get_local_player(), 'm_bHasHelmet') 
        local menu_r, menu_b, menu_g, menu_a = ui.get(menu_c)
        

            if ui.get(presets) == "Custom" then
                if refs[state].flicks_c then
                    if ui.get(anti_aim[state].fake_addition) == "Flick Between" then
                        refs[state].flickyaw_c = (ui.get(yaw_val) == ui.get(anti_aim[state].ndyaw) and ui.get(anti_aim[state].styaw) or ui.get(anti_aim[state].ndyaw))
                    else
                        refs[state].flickyaw_c = client.random_int(ui.get(anti_aim[state].styaw), ui.get(anti_aim[state].ndyaw))
                    end
                end
            else
                if lp_vel < 5 and not in_air(entity.get_local_player()) and  refs[state].flicks then
                    refs[state].flickyaw = (ui.get(yaw_val) == -5 and 10 or -5)
                elseif in_air(entity.get_local_player()) and  refs[state].flicks then
                    refs[state].flickyaw = (ui.get(yaw_val) == -5 and 5 or -5)
                elseif ((is_crouching(entity.get_local_player()) and not in_air(entity.get_local_player())) or ui.get(fake_duck)) and  refs[state].flicks then
                    refs[state].flickyaw = (ui.get(yaw_val) == 0 and 18 or 0)
                else
                    if  refs[state].flicks then
                        refs[state].flickyaw = ((ui.get(yaw_val) == -11 or ui.get(yaw_val) == 7) and 8 or 0)
                    end
                end
            end

            if ui.get(presets) == "Custom" then
                if refs[state].flicks2_c then
                    if ui.get(anti_aim[state].fake_addition) == "Flick Between" then
                        refs[state].flickfake_c = (ui.get(fake_yaw) == ui.get(anti_aim[state].ndfake_val) and ui.get(anti_aim[state].stfake_val) or ui.get(anti_aim[state].ndfake_val))
                    else
                        refs[state].flickfake_c = client.random_int(ui.get(anti_aim[state].stfake_val), ui.get(anti_aim[state].ndfake_val))
                    end
                end
            else
                if lp_vel < 5 and not in_air(entity.get_local_player()) and refs[state].flicks2 then
                    --refs[state].flickfake = (ui.get(fake_yaw) == -5 and 5 or -5)
                elseif in_air(entity.get_local_player()) and  refs[state].flicks2 then
                   -- refs[state].flickfake = (ui.get(fake_yaw) == -5 and 5 or -5)
                elseif ((is_crouching(entity.get_local_player()) and not in_air(entity.get_local_player())) or ui.get(fake_duck)) and  refs[state].flicks2 then
                   -- refs[state].flickfake = (ui.get(fake_yaw) == -5 and 5 or -5)
                else
                    if refs[state].flicks2 then
                        --refs[state].flickfake = (ui.get(fake_yaw) == -5 and 5 or -5)
                    end
                end
            end

        if ui.get(ui_back) then
            back_dir = true
            right_dir = false
            left_dir = false
            last_press_t = globals.curtime()
        elseif ui.get(ui_right) then
            if right_dir == true and last_press_t + 0.02 < globals.curtime() then
            back_dir = true
            right_dir = false
            left_dir = false
            elseif right_dir == false and last_press_t + 0.02 < globals.curtime() then
            right_dir = true
            back_dir = false
            left_dir = false
            end
            last_press_t = globals.curtime()
        elseif ui.get(ui_left) then
            if left_dir == true and last_press_t + 0.02 < globals.curtime() then
            back_dir = true
            right_dir = false
            left_dir = false
            elseif left_dir == false and last_press_t + 0.02 < globals.curtime() then
            left_dir = true
            back_dir = false
            right_dir = false
            end
            last_press_t = globals.curtime()
        end

        local players = entity.get_players(true)	
        local pitch, yaw = client.camera_angles()
        local vx, vy, vz = angle_to_vec(pitch, yaw)
        
        local closest_fov_cos = -1
        enemyclosesttocrosshair = nil
        for i=1, #players do
            local idx = players[i]
            if entity.is_alive(idx) then
                local fov_cos = get_fov_cos(idx, vx,vy,vz, lx,ly,lz)
                if fov_cos > closest_fov_cos then
                    closest_fov_cos = fov_cos
                    enemyclosesttocrosshair = idx
                end
            end
        end
    
        if (enemyclosesttocrosshair ~= nil and #players ~= 0) then
            realtime_freestand = DoFreestanding(enemyclosesttocrosshair, -90, 90)
            realtime_freestand_v2 = DoEarlyFreestanding(enemyclosesttocrosshair, -90, 90)
            if realtime_freestand_v2 == 90 or realtime_freestand == 90 then
                adaptive_freestand = 90
            elseif realtime_freestand_v2 == -90 or realtime_freestand == -90 then
                adaptive_freestand = -90
            else
                adaptive_freestand = 0
            end
        end
    
        local xlp, zlp, ylp = entity.hitbox_position(entity.get_local_player(), 0)
        if enemyclosesttocrosshair ~= nil then xe, ze, ye = entity.hitbox_position(enemyclosesttocrosshair, 0) else xe, ze, ye = 9999999999, 9999999999, 9999999999 end
        local safejitter = lp_hittable or in_air(entity.get_local_player()) or lp_vel < 32
        local checkforcedisableantibrute = (contains(additions, "Freestanding") and adaptive_freestand == 0) or not (contains(additions, "Freestanding"))
        local forcedisableantibrute = lp_vel > 5 and not ui.get(forcesafe) and checkforcedisableantibrute and mode == "SAFE" and lp_vel > 5 and not in_air(entity.get_local_player())
        local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local side = bodyyaw > 0 and 1 or -1
        local side_flick = right_side and 180 or -180
        local active_weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
        local hotkey_rf, active_rf, bind_rf = ui.get(edgeyawkey)

        if active_weapon == nil then
            return
        end

        local zoom_lvl = entity.get_prop(active_weapon, 'm_zoomLevel')
        local nextAttack = entity.get_prop(entity.get_local_player(),"m_flNextAttack") 
        local nextShot = entity.get_prop(active_weapon,"m_flNextPrimaryAttack")
        local nextShotSecondary = entity.get_prop(active_weapon,"m_flNextSecondaryAttack")
    
        if nextAttack == nil or nextShot == nil or nextShotSecondary == nil then
            return
        end
    
        nextAttack = nextAttack + 0.5
        nextShot = nextShot + 0.5
        nextShotSecondary = nextShotSecondary + 0.5

        if hotkey_rf and bind_rf ~= 0 then
            if (contains(edgeyawdisable, "Standing") and state == 1) or (contains(edgeyawdisable, "Moving") and state == 2) or (contains(edgeyawdisable, "Crouching") and state == 4 and not ui.get(fake_duck)) or (contains(edgeyawdisable, "Air") and state == 3) or (contains(edgeyawdisable, "Duck Peek Assist") and ui.get(fake_duck)) or (contains(edgeyawdisable, "Freestanding") and contains(additions, "Freestanding") and adaptive_freestand ~= 0) or (contains(edgeyawdisable, "Roll AA") and ui.get(forcesafe)) or (contains(edgeyawdisable, "Quick Peek Assist") and ui.get(quickpeek_key)) or (contains(edgeyawdisable, "Not Safe Wall") and dmg ~= 0) then
                ui.set(edge_yaw, false)
            else
                ui.set(edge_yaw, true)
            end
        else
            ui.set(edge_yaw, false)
        end

        if ui.get(slowwalk) and not ui.get(forcesafe) then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.9*side, 11)
        end

        if not ui.is_menu_open() then
        ui.set(fs_body_yaw, false)

        if back_dir == true then
            ui.set(targets,(ui.get(syncyawtarget) and "At targets" or "Local View"))
            ui.set(yaw_am,"180")
            if mode == "SAFE" then
                if ui.get(presets) == "Exi-Mode" then
                    if lp_vel < 5 and not in_air(entity.get_local_player()) then
                        ui.set(yaw_val, refs[state].flickyaw)
                    elseif in_air(entity.get_local_player()) then
                        ui.set(yaw_val,(side == 1 and -18 or 8))
                    elseif ((is_crouching(entity.get_local_player()) and not in_air(entity.get_local_player())) or ui.get(fake_duck)) then
                        ui.set(yaw_val, refs[state].flickyaw)
                    else
                        ui.set(yaw_val,(side == 1 and (-11+refs[state].flickyaw) or (7+refs[state].flickyaw)))
                    end 
                elseif ui.get(presets) == "Default" then
                    if lp_vel < 5 and not in_air(entity.get_local_player()) then
                        ui.set(yaw_val,(side == 1 and -25 or 32))
                    elseif in_air(entity.get_local_player()) then
                        ui.set(yaw_val,(side == 1 and -30 or 45))
                    else
                        ui.set(yaw_val,(side == 1 and -42 or 42))
                    end 
                else
                    if ui.get(anti_aim[state].addition) == "Flick Between" or ui.get(anti_aim[state].addition) == "Flick Around" then
                        ui.set(yaw_val, refs[state].flickyaw_c)
                    elseif ui.get(anti_aim[state].addition) == "Random" then
                        ui.set(yaw_val,client.random_int(ui.get(anti_aim[state].styaw), ui.get(anti_aim[state].ndyaw)))
                    elseif ui.get(anti_aim[state].addition) == "Jitter" then
                        ui.set(yaw_val,(flipJitter and ui.get(anti_aim[state].styaw) or ui.get(anti_aim[state].ndyaw)))
                    else
                        ui.set(yaw_val,(side == 1 and ui.get(anti_aim[state].styaw) or ui.get(anti_aim[state].ndyaw)))
                    end
                end
            else
                ui.set(yaw_val,0)
            end
        elseif right_dir == true then
            ui.set(yaw_am,"180")
            ui.set(targets,"Local view")
            ui.set(yaw_val,90)
        elseif left_dir == true then
            ui.set(yaw_am,"180")
            ui.set(targets,"Local view")
            ui.set(yaw_val,-90)
        end

        --if math.max(nextShot) - globals.curtime() > 1.88 and not ui.get(os_key)  then
        --    onshot_antiaim(side)
        if ui.get(forcesafe) then
            mode = "STATE"
            roll_antiaim(back_dir)
        else
            if adaptive_freestand == 90 and contains(additions, "Freestanding") then
                mode = "STATE"
                leftpeek_antiaim()
            elseif adaptive_freestand == -90 and contains(additions, "Freestanding") then
                mode = "STATE"
                rightpeek_antiaim()
            else
                if ui.get(slowwalk) then
                    mode = "STATE"
                    slowwalk_antiaim()
                elseif ((ylp > (enemyz + 300) and enemyz ~= 0) or ui.get(fake_duck)) then
                    mode = "STATE"
                    dangerous_antiaim(flipJitter)
                elseif dmg >= health then
                    mode = "STATE"
                    lethal_antiaim(adaptive_freestand)
                else
                    mode = "SAFE"
                    if ui.get(presets) == "Exi-Mode" then
                        experimental_antiaim(lp_vel, bodyyaw)
                    elseif ui.get(presets) == "Default" then
                        default_antiaim(lp_vel, bodyyaw)
                    else
                        custom_antiaim(lp_vel, bodyyaw, state)
                    end
                end
            end
        end
    end

        if lp_hittable then
            ui.set(lm,"off")
        else
            ui.set(lm,flipJitter and lp_vel > 100 and "always slide" or "never slide")
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
        end
        
    local scrsize_x, scrsize_y = client.screen_size()
    local center_x, center_y = scrsize_x / 2, scrsize_y / 2
    local cx, cy = scrsize_x, 10
    local cam = vector(client.camera_angles())
    local h = vector(entity.hitbox_position(entity.get_local_player(), "head_0"))
    local p = vector(entity.hitbox_position(entity.get_local_player(), "pelvis"))
    local yaw = normalize_yaw(calc_angle(p.x, p.y, h.x, h.y) - cam.y + 120)
    local fakeangle = normalize_yaw(yaw + bodyyaw)
    local color1, color2, color3, color4 = ui.get(color)
    local c1, c2, c3, c4 = ui.get(color0)
    local col1, col2, col3, col4 = ui.get(d_color)
    local fakecolor = { 255-(angle*2.29824561404), angle*3.42105263158, angle*0.22807017543 }
    local desync_angle = math.abs(antiaim_funcs.get_desync(2))
    if desync_angle > 60 then desync_angle = 60 elseif desync_angle < 0 then desync_angle = 0 else desync_angle = desync_angle end
    local hour, minute, seconds, milliseconds = client.system_time()
    local alpha = color4 - 100
    local watername = entity.get_player_name(entity.get_local_player())
    local INetChannelInfo = ffi.cast("void***", get_net_channel_info(ivengineclient)) or error("netchaninfo is nil")
    local net_channel = GetNetChannel(INetChannelInfo)
    local outgoing, incoming = net_channel.latency.crn(0), net_channel.latency.crn(1)
    local ping, avg_ping = outgoing*1000, net_channel.latency.average(0)*1000
    local a = 255 + (0 - 255) * 0.04 * (globals.absoluteframetime() * 100)
    local pos_x, pos_y = scrsize_x / 2 + 300, scrsize_y - 600
    local frames = 8 * globals.frametime()
    local fov_y_pos = 150 - (ui.get(global_fov) + cvar.cam_idealdist:get_int())
    local stabile_fov_y_pos = (zoom_lvl ~= 0 and fov_y_pos + ui.get(zoom_fov) or fov_y_pos)*2
    local x_pos = (ui.get(thirdview) and ui.get(thirdview_key) and 0 or 550)
    local player = player()
    local player_weapon = entity.get_player_weapon(player)
    local active_weapon2 = csgo_weapons(player_weapon)
    local weaponname = active_weapon2.name
    local max_clip = active_weapon2.primary_clip_size
    local curr_ammo = entity.get_prop(player_weapon, 'm_iClip1')
    local max_inaccuracy = active_weapon2.spread
    local eyepos = vector(client.camera_angles())
    local stabile_attargets = 50 - eyepos.y 
    
    if ui.get(dt) and ui.get(dt_key) then animcur = 1.2 else animcur = 1.5 end
    
    if ((ui.get(damage) - dmg2)/2) < 5 then damage_danger = 5 else damage_danger = (ui.get(damage) - dmg2)/2 end


    if ui.get(jyaw_val) < 0 then jitter_val_yaw = ui.get(jyaw_val)*-1 else jitter_val_yaw = ui.get(jyaw_val) end

    if ui.get(jyaw) == "Offset" then
        jitter_yaw_stabile = (side == 1 and 0 or jitter_val_yaw)
    elseif ui.get(jyaw) == "Center" then
        jitter_yaw_stabile = (side == 1 and -jitter_val_yaw/2 or jitter_val_yaw/2)
    else
        jitter_yaw_stabile = math.random(0,jitter_val_yaw)
    end

    yaw_stabile = jitter_yaw_stabile + ui.get(yaw_val)

    if ui.get(thirdview) and ui.get(thirdview_key) then
        VIEW_ALPHA = VIEW_ALPHA + frames; if VIEW_ALPHA > 1 then VIEW_ALPHA = 1 end
        FIRST_ALPHA = FIRST_ALPHA - frames; if FIRST_ALPHA < 0 then FIRST_ALPHA = 0 end 
    else
        VIEW_ALPHA = VIEW_ALPHA - frames; if VIEW_ALPHA < 0 then VIEW_ALPHA = 0 end 
        FIRST_ALPHA = FIRST_ALPHA + frames; if FIRST_ALPHA > 1 then FIRST_ALPHA = 1 end
    end

    if ui.get(thirdview) and ui.get(thirdview_key) then
        if state ~= 3 and state ~= 4 then
            animation_stabile = math.floor((globals.curtime()*20))
            if position_y >= 100 then position_y = 0 end
            if position_y > 5 then
                position_y = position_y - (animation_stabile - animation_unstabile)
            elseif position_y < -5 then
                position_y = position_y + (animation_stabile - animation_unstabile)
            else
                position_y = 0
            end
        else
            animation_unstabile = math.floor((globals.curtime()*20))
            if state == 4 then
                if position_y >= 100 then position_y = 0 end
                if position_y + (animation_unstabile - animation_stabile) > 50 then
                    position_y = 50
                    animation_stabile = math.floor((globals.curtime()*20))
                else
                    position_y = position_y + (animation_unstabile - animation_stabile)
                end
            elseif state == 3 and is_crouching(entity.get_local_player()) then
                if position_y >= 100 then position_y = 0 end
                if position_y < -50 then
                    if position_y + (animation_unstabile - animation_stabile) > -50 then
                        position_y = -50
                        animation_stabile = math.floor((globals.curtime()*20))
                    else
                        position_y = position_y + (animation_unstabile - animation_stabile)
                    end
                else
                    if position_y + (animation_stabile - animation_unstabile) < -50 then
                        position_y = -50
                        animation_stabile = math.floor((globals.curtime()*20))
                    else
                        position_y = position_y + (animation_stabile - animation_unstabile)
                    end
                end
            else
                if position_y >= 100 then position_y = 0 end
                if position_y + (animation_stabile - animation_unstabile) < -100 then
                    position_y = -100
                    animation_stabile = math.floor((globals.curtime()*20))
                else
                    position_y = position_y + (animation_stabile - animation_unstabile)
                end
            end
        end
        animation_active = math.floor((globals.curtime()*3000))
    else
        animation_disactive = math.floor((globals.curtime()*3000))
        if (math.max(nextShot) < nextAttack) and (nextAttack - globals.curtime() > animcur) then
            animation_active = math.floor((globals.curtime()*3000))
            position_y = scrsize_y
        else
            if scrsize_y + (animation_active - animation_disactive) < scrsize_y - 1300 then
                position_y = scrsize_y - 1300
            else
                position_y = scrsize_y + (animation_active - animation_disactive)
            end
        end
    end



    if contains(debugind, "Player Information") then
        --renderer.line(center_x + x_pos, pos_y + 50 + position_y/3 + stabile_fov_y_pos, pos_x + 2 + x_pos, pos_y + position_y + 2 + stabile_fov_y_pos, col1, col2, col3, VIEW_ALPHA*100)
        container_glow(pos_x + x_pos, pos_y + position_y + stabile_fov_y_pos, 150, 100, col1, col2, col3, col4, 1.2, col1, col2, col3)

        renderer.text(pos_x + 10 + x_pos, pos_y + position_y + 10 + stabile_fov_y_pos, 255, 255, 255, VIEW_ALPHA*255, "-", 0, "FAKE:")
        renderer.text(pos_x + 10 + x_pos, pos_y + position_y + 30 + stabile_fov_y_pos, 255, 255, 255, VIEW_ALPHA*255, "-", 0, "YAW ANGLE:")
        if (yaw_stabile < 0 and yaw_stabile > -10) or (yaw_stabile > 9 and yaw_stabile < 100) then
            renderer.text(pos_x + 95 + x_pos, pos_y + position_y + 55 + stabile_fov_y_pos, 255, 255, 255, VIEW_ALPHA*255, "-", 0, math.floor(yaw_stabile))
        elseif (yaw_stabile < -9 and yaw_stabile > -100) or yaw_stabile > 99 then
            renderer.text(pos_x + 93 + x_pos, pos_y + position_y + 55 + stabile_fov_y_pos, 255, 255, 255, VIEW_ALPHA*255, "-", 0, math.floor(yaw_stabile))
        elseif yaw_stabile < -99 then
            renderer.text(pos_x + 91 + x_pos, pos_y + position_y + 55 + stabile_fov_y_pos, 255, 255, 255, VIEW_ALPHA*255, "-", 0, math.floor(yaw_stabile))
        elseif yaw_stabile > -1 and yaw_stabile < 10 then
            renderer.text(pos_x + 97 + x_pos, pos_y + position_y + 55 + stabile_fov_y_pos, 255, 255, 255, VIEW_ALPHA*255, "-", 0, math.floor(yaw_stabile))
        end
        if helmet == 1 and armor ~= 0 then
            renderer.text(pos_x + 15 + x_pos, pos_y + position_y + 50 + stabile_fov_y_pos, 255, 255, 255, VIEW_ALPHA*255, "+", 0, "HK")
        elseif helmet == 0 and armor ~= 0 then
            renderer.text(pos_x + 25 + x_pos, pos_y + position_y + 50 + stabile_fov_y_pos, 255, 255, 255, VIEW_ALPHA*255, "+", 0, "K")
        else
            renderer.text(pos_x + 25 + x_pos, pos_y + position_y + 50 + stabile_fov_y_pos, 255, 255, 255, VIEW_ALPHA*255, "+", 0, "L")
        end
        renderer.rectangle(pos_x + 50 + x_pos, pos_y + position_y + 12 + stabile_fov_y_pos, 90, 6, 0, 0, 0, VIEW_ALPHA*255)
        renderer.gradient(pos_x + 50 + x_pos, pos_y + position_y + 12 + stabile_fov_y_pos, angle*1.5, 6, col1, col2, col3, VIEW_ALPHA*255, col1, col2, col3, VIEW_ALPHA*0, true)
        renderer.circle_outline(pos_x + 100 + x_pos, pos_y + position_y + 60 + stabile_fov_y_pos, col1, col2, col3, VIEW_ALPHA*255, 30, 360, 1.0, 6)
        renderer.circle_outline(pos_x + 100 + x_pos, pos_y + position_y + 60 + stabile_fov_y_pos, 132, 196, 20, VIEW_ALPHA*255, 30,5-yaw, 0.1, 6)

        renderer.text(pos_x + 10 + x_pos, pos_y + position_y + 20 + stabile_fov_y_pos, 255, 255, 255, FIRST_ALPHA*255, "-", 0, "AMMO CLIP:")
        if curr_ammo < 0 then
            renderer.text(pos_x + 70 + x_pos, pos_y + position_y + 10 + stabile_fov_y_pos, 255, 255, 255, FIRST_ALPHA*255, "+", 0, "STATIC")
        else
            if curr_ammo < 10 and max_clip < 10 then
                renderer.text(pos_x + 105 + x_pos, pos_y + position_y + 10 + stabile_fov_y_pos, 255, 255, 255, FIRST_ALPHA*255, "+", 0, curr_ammo.."/"..max_clip)
            elseif curr_ammo < 10 and max_clip > 9 then
                renderer.text(pos_x + 92 + x_pos, pos_y + position_y + 10 + stabile_fov_y_pos, 255, 255, 255, FIRST_ALPHA*255, "+", 0, curr_ammo.."/"..max_clip)
            else
                renderer.text(pos_x + 82 + x_pos, pos_y + position_y + 10 + stabile_fov_y_pos, 255, 255, 255, FIRST_ALPHA*255, "+", 0, curr_ammo.."/"..max_clip)
            end
        end
        renderer.text(pos_x + 10 + x_pos, pos_y + position_y + 40 + stabile_fov_y_pos, 255, 255, 255, FIRST_ALPHA*255, "-", 0, "INACCURACY:")
        renderer.rectangle(pos_x + 70 + x_pos, pos_y + position_y + 42 + stabile_fov_y_pos, 70, 6, 0, 0, 0, FIRST_ALPHA*255)
        renderer.gradient(pos_x + 70 + x_pos, pos_y + position_y + 42 + stabile_fov_y_pos, max_inaccuracy*10000+lp_vel/10, 6, col1, col2, col3, FIRST_ALPHA*255, col1, col2, col3, FIRST_ALPHA*0, true)
        renderer.text(pos_x + 10 + x_pos, pos_y + position_y + 60 + stabile_fov_y_pos, 255, 255, 255, FIRST_ALPHA*255, "-", 0, "MINIMUM DAMAGE :  "..ui.get(damage))
        renderer.text(pos_x + 10 + x_pos, pos_y + position_y + 80 + stabile_fov_y_pos, 255, 255, 255, FIRST_ALPHA*255, "-", 0, "CAN SHOT :  "..dmg2)
        renderer.gradient(pos_x + 100 + x_pos, pos_y + position_y + 62 + stabile_fov_y_pos, damage_danger,30, 255, 0, 0, FIRST_ALPHA*255, 255, 0, 0, FIRST_ALPHA*0, true)
    end

    otuiind_y = 0
    fakeuiind_x = 60

    if build == "beta" then build2 = "BETA" else build2 = "LIVE" end

    watername = "cracked"
    if hour < 10 then hour = "0"..tostring(hour) end
    if minute < 10 then minute = "0"..tostring(minute) end
    if seconds < 10 then seconds = "0"..tostring(seconds) end
    if speed > 0 then speed = speed else speed = 1 end
    if back_dir then dir_ind = "BACK" elseif right_dir then dir_ind = "RIGHT" elseif left_dir then dir_ind = "LEFT" else dir_ind = "FS" end

    local watertext =  " ["..build.."] "..watername.." delay: "..math.floor(avg_ping).."ms "..hour..":"..minute..":"..seconds

	if ui.get(indbox) == false then return end
    if contains(crossind, "Arrows") then
        if bodyyaw > 0 then
            renderer_arrow(center_x, center_y, color1, color2, color3, 255, (yaw_stabile - 90) * -1, 65)
            renderer_arrow2(center_x, center_y, 255, 255, 255, 255, (yaw_stabile - 90) * -1, 65)
        else
            renderer_arrow2(center_x, center_y, color1, color2, color3, 255, (yaw_stabile - 90) * -1, 65)
            renderer_arrow(center_x, center_y, 255, 255, 255, 255, (yaw_stabile - 90) * -1, 65)
        end
    end

    if contains(crossind, "Text") then
        renderer.text( center_x-20, center_y+45, 255, 255, 255, 255, "-", 0, "HALF")
        renderer.text( center_x-2, center_y+45, c1, c2, c3, 255, "-", 0, "- LIFE")
        renderer.gradient(center_x, center_y+59, angle/2, 3, c1, c2, c3, 255, c1, c2, c3, 0, true)
        renderer.gradient(center_x, center_y+59, -angle/2, 3, c1, c2, c3, 255, c1, c2, c3, 0, true)
        if ui.get(presets) == "Exi-Mode" then
            renderer.text( center_x-19, center_y+65, 255, 255, 255, 255, "-", 0, "EXI-MODE")
        elseif ui.get(presets) == "Default" then
            renderer.text( center_x-18, center_y+65, 255, 255, 255, 255, "-", 0, "DEFAULT")
        else
            renderer.text( center_x-18, center_y+65, 255, 255, 255, 255, "-", 0, "CUSTOM")
        end
        if ui.get(forcesafe) then
            renderer.text( center_x-11, center_y+75, c1, c2, c3, 255, "-", 0, "ROLL")
        elseif lp_vel < 5 and not in_air(entity.get_local_player()) and not ((is_crouching(entity.get_local_player())) or ui.get(fake_duck)) then
            renderer.text( center_x-20, center_y+75, c1, c2, c3, 255, "-", 0, "STANDING")
        elseif in_air(entity.get_local_player()) then
            renderer.text( center_x-8, center_y+75, c1, c2, c3, 255, "-", 0, "AIR")
        elseif ((is_crouching(entity.get_local_player()) and not in_air(entity.get_local_player())) or ui.get(fake_duck)) then
            renderer.text( center_x-19, center_y+75, c1, c2, c3, 255, "-", 0, "DUCKING")
        else
            renderer.text( center_x-16, center_y+75, c1, c2, c3, 255, "-", 0, "MOVING")
        end
        renderer.text( center_x-20, center_y+85, 255, 255, 255, 100, "-", 0, "DT")
        renderer.text( center_x-7, center_y+85, 255, 255, 255, 100, "-", 0, "OS")
        renderer.text( center_x+7, center_y+85, 255, 255, 255, 100, "-", 0, "FS")
        if ui.get(os_key) and not ui.get(dt_key) and not ui.get(fake_duck) then
            renderer.text( center_x-7, center_y+85, 132, 196, 20, 255, "-", 0, "OS")
        elseif ui.get(os_key) and (ui.get(dt_key) or ui.get(fake_duck)) then
            renderer.text( center_x-7, center_y+85, 255, 0, 0, 255, "-", 0, "OS")
        end
        if ui.get(fs_key) then
            renderer.text( center_x+7, center_y+85, 132, 196, 20, 255, "-", 0, "FS")
        end
 
        if ui.get(dt_key) then
            if math.max(nextShot,nextShotSecondary) < nextAttack then
                if nextAttack - globals.curtime() > 0.00 then
                    renderer.text( center_x-20, center_y+85, 255, 0, 0, 255, "-", 0, "DT")
                else
                    renderer.text( center_x-20, center_y+85, 132, 196, 20, 255, "-", 0, "DT")
                end
            else
                if math.max(nextShot,nextShotSecondary) - globals.curtime() > 0.00  then
                    renderer.text( center_x-20, center_y+85, 255, 0, 0, 255, "-", 0, "DT")
                else
                    if math.max(nextShot,nextShotSecondary) - globals.curtime() < 0.00  then
                        renderer.text( center_x-20, center_y+85, 132, 196, 20, 255, "-", 0, "DT")
                    else
                        renderer.text( center_x-20, center_y+85, 132, 196, 20, 255, "-", 0, "DT")
                    end
                end
            end
        end
    end

    if contains(sktind, "Roll") and ui.get(forcesafe) then
        renderer.indicator(255, 255, 255, 255, "ROLL")
    end
    if contains(sktind, "Enemy Information") then
        local enemies = entity.get_players(true)
        for itter = 1, #enemies do
            local i = enemies[itter]
    
            local hitbox_pos_x, hitbox_pos_y, hitbox_pos_z = entity.hitbox_position(i, 0)
            local local_x, local_y, local_z = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
            
            local dynamic = calcu_angle(local_x, local_y, local_z, hitbox_pos_x,hitbox_pos_y,hitbox_pos_z)
            local FakeYaw = math.floor(normalize_yaw(entity.get_prop(i, "m_angEyeAngles[1]")))
            local speed = getspeed(i)
    
            local name = string.lower(entity.get_player_name(i))
            local angle = math.floor(entity.get_prop(i, "m_flPoseParameter", 11) * 120 - 60 )
            local enemy_yaw = (math.floor(normalize_yaw(dynamic)) - FakeYaw) > 0 and (math.floor(normalize_yaw(dynamic)) - FakeYaw) - 180 or (math.floor(normalize_yaw(dynamic)) - FakeYaw) + 180
            local velocity = math.floor(speed)
            
            renderer.indicator(255, 200, 110, 255, "TARGET NAME: ["..name.."], TARGET ANGLE: ["..angle.."], TARGET YAW: ["..enemy_yaw.."], TARGET VELOCITY: ["..velocity.."]")
        end
    end

    if contains(debugind, "Debug Table") then
        container_glow(center_x/200, center_y*1.2 + 15, 165, 50, col1, col2, col3, col4, 1.2, col1, col2, col3)
        renderer.text(center_x/200 + 5, center_y*1.2 + 20, 255, 255, 255, 255, "Light", 0, ">> half.life anti-aim")
        renderer.text(center_x/200 + 107, center_y*1.2 + 20, col1, col2, col3, 255, "Light", 0, "technology")
        renderer.text(center_x/200 + 5, center_y*1.2 + 32.5, 255, 255, 255, 255, "Light", 0, ">> user:")
        renderer.text(center_x/200 + 50, center_y*1.2 + 32.5, col1, col2, col3, 255, "Light", 0, "loader.dr('[half-life] stored_values').username")
        renderer.text(center_x/200 + 5, center_y*1.2 + 45, 255, 255, 255, 255, "Light", 0, ">> build:")
        renderer.text(center_x/200 + 52, center_y*1.2 + 45, col1, col2, col3, 255, "Light", 0, build)
    end

    if contains(uiind, "Watermark") then
        if ui.get(styleui) == "Default" then
            renderer.blur(cx - renderer.measure_text(nil, watertext) - 60,cy + 2,50 + renderer.measure_text(nil, watertext),18)
            renderer.rectangle(cx - renderer.measure_text(nil, watertext) - 53,cy, 35 + renderer.measure_text(nil, watertext), 20, 20, 20, 20, color4)
            renderer.circle(cx - renderer.measure_text(nil, watertext) - 53, cy + 7, 20, 20, 20, color4, 7, 180, 0.25)
            renderer.circle(cx - 18, cy + 7, 20, 20, 20, color4, 7, 90, 0.25)
            renderer.rectangle(cx - renderer.measure_text(nil, watertext) - 60,cy + 7, 7, 13, 20, 20, 20, color4)
            renderer.rectangle(cx - 18,cy + 7, 7, 13, 20, 20, 20, color4)
            renderer.rectangle(cx - renderer.measure_text(nil, watertext) - 53,cy, 35 + renderer.measure_text(nil, watertext), 2, color1, color2, color3, 255)
            renderer.circle_outline(cx - renderer.measure_text(nil, watertext) - 53, cy + 10, color1, color2, color3, 255, 10, 220, 0.15, 2)
            renderer.circle_outline(cx - 18, cy + 10, color1, color2, color3, 255, 10, 270, 0.15, 2)
            renderer.gradient(cx - renderer.measure_text(nil, watertext) - 61, cy + 4, 2, 14, color1, color2, color3, 255, color1, color2, color3, 0, false) 
            renderer.gradient(cx - 12, cy + 4, 2, 14, color1, color2, color3, 255, color1, color2, color3, 0, false) 
            renderer.text(cx - renderer.measure_text(nil, watertext) - 55, cy + 4, 255, 255, 255, 255, nil, 0, "half")
            renderer.text(cx - renderer.measure_text(nil, watertext) - 36, cy + 4, color1, color2, color3, 255, nil, 0, "-life")
            renderer.text(cx - renderer.measure_text(nil, watertext) - 15, cy + 4, 255, 255, 255, 255, nil, 0, watertext)
        else
            container_glow(cx - renderer.measure_text(nil, watertext) - 60, cy, 49 + renderer.measure_text(nil, watertext), 20, color1, color2, color3, color4, 1.2, color1, color2, color3)
            renderer.text(cx - renderer.measure_text(nil, watertext) - 55, cy + 3, 255, 255, 255, 255, nil, 0, "half")
            renderer.text(cx - renderer.measure_text(nil, watertext) - 35.5, cy + 3, color1, color2, color3, 255, nil, 0, "-life")
            renderer.text(cx - renderer.measure_text(nil, watertext) - 16.5, cy + 3, 255, 255, 255, 255, nil, 0, watertext)
        end
        otuiind_y = 40
    end

    if contains(uiind, "FL/DT") then
        if ui.get(styleui) == "Default" then
            renderer.blur(cx - 56,cy + otuiind_y + 2,45,18)
            renderer.rectangle(cx - 49,cy + otuiind_y, 30, 20, 20, 20, 20, color4)
            renderer.circle(cx - 49, cy + otuiind_y + 7, 20, 20, 20, color4, 7, 180, 0.25)
            renderer.circle(cx - 19, cy + otuiind_y + 7, 20, 20, 20, color4, 7, 90, 0.25)
            renderer.rectangle(cx - 56,cy + otuiind_y + 7, 7, 13, 20, 20, 20, color4)
            renderer.rectangle(cx - 19,cy + otuiind_y + 7, 7, 13, 20, 20, 20, color4)
            renderer.rectangle(cx - 49,cy + otuiind_y, 30, 2, color1, color2, color3, 255)
            renderer.circle_outline(cx - 49, cy + otuiind_y + 10, color1, color2, color3, 255, 10, 220, 0.15, 2)
            renderer.circle_outline(cx - 19, cy + otuiind_y + 10, color1, color2, color3, 255, 10, 270, 0.15, 2)
            renderer.gradient(cx - 57, cy + otuiind_y + 4, 2, 14, color1, color2, color3, 255, color1, color2, color3, 0, false) 
            renderer.gradient(cx - 13, cy + otuiind_y + 4, 2, 14, color1, color2, color3, 255, color1, color2, color3, 0, false)
            if antiaim_funcs.get_double_tap() then
                if antiaim_funcs.get_tickbase_shifting() < 10 then
                    renderer.text(cx - 46, cy + otuiind_y + 4, 255, 255, 255, 255, nil, 0, "DT: "..math.floor(antiaim_funcs.get_tickbase_shifting()))
                else
                    renderer.text(cx - 50, cy + otuiind_y + 4, 255, 255, 255, 255, nil, 0, "DT: "..math.floor(antiaim_funcs.get_tickbase_shifting()))
                end
            else
                if ChokedCommands < 10 then
                    renderer.text(cx - 46, cy + otuiind_y + 4, 255, 255, 255, 255, nil, 0, "FL: "..math.floor(ChokedCommands))
                else
                    renderer.text(cx - 48, cy + otuiind_y + 4, 255, 255, 255, 255, nil, 0, "FL: "..math.floor(ChokedCommands))
                end
            end
        else
            container_glow(cx - 56,cy + otuiind_y, 44, 20, color1, color2, color3, color4, 1.2, color1, color2, color3)
            if antiaim_funcs.get_double_tap() then
                if antiaim_funcs.get_tickbase_shifting() < 10 then
                    renderer.text(cx - 46, cy + otuiind_y + 4, 255, 255, 255, 255, nil, 0, "DT: "..math.floor(antiaim_funcs.get_tickbase_shifting()))
                else
                    renderer.text(cx - 50, cy + otuiind_y + 4, 255, 255, 255, 255, nil, 0, "DT: "..math.floor(antiaim_funcs.get_tickbase_shifting()))
                end
            else
                if ChokedCommands < 10 then
                    renderer.text(cx - 46, cy + otuiind_y + 4, 255, 255, 255, 255, nil, 0, "FL: "..math.floor(ChokedCommands))
                else
                    renderer.text(cx - 48, cy + otuiind_y + 4, 255, 255, 255, 255, nil, 0, "FL: "..math.floor(ChokedCommands))
                end
            end
        end
        fakeuiind_x = 70
    end

    if contains(uiind, "Anti-aimbot") then
        if ui.get(styleui) == "Default" then
            renderer.blur(cx - fakeuiind_x - 56,cy + otuiind_y + 2,50,18)
            renderer.gradient(cx - fakeuiind_x - 56,cy + otuiind_y, 50, 20, 0, 0, 0, 0, 20, 20, 20, 100, true)
            renderer.rectangle(cx - fakeuiind_x - 49,cy + otuiind_y, 43, 2, fakecolor[1], fakecolor[2], fakecolor[3], 255)
            renderer.rectangle(cx - fakeuiind_x - 56,cy + otuiind_y + 4, 2, 15, fakecolor[1], fakecolor[2], fakecolor[3], 255)
            renderer.circle_outline(cx - fakeuiind_x - 48, cy + otuiind_y + 10, fakecolor[1], fakecolor[2], fakecolor[3], 255, 10, 220, 0.15, 2)
            renderer.text(cx - fakeuiind_x - 52, cy + otuiind_y + 4, 255, 255, 255, 255, nil, 0, "FAKE: "..math.floor(angle))
        else
            container_glow(cx - fakeuiind_x - 56,cy + otuiind_y, 50, 20, color1, color2, color3, color4, 1.2, color1, color2, color3)
            renderer.text(cx - fakeuiind_x - 52, cy + otuiind_y + 4, 255, 255, 255, 255, nil, 0, "FAKE: "..math.floor(angle))
        end
    end

    local master_switch = contains(uiind, "Keybinds")
    local is_menu_open = ui.is_menu_open()

    local latest_item = false
    local maximum_offset = 0

    for c_name, c_ref in pairs(references) do
        local item_active = true

        local items = item_count(c_ref)
        local state = { ui.get(c_ref[items]) }

        if items > 1 then
            item_active = ui.get(c_ref[1])
        end

        if item_active and state[2] ~= 0 and (state[2] == 3 and not state[1] or state[2] ~= 3 and state[1]) then
            latest_item = true

            if m_active[c_name] == nil then
                m_active[c_name] = {
                    mode = '', alpha = 0, offset = 0, active = true
                }
            end

            local text_width = renderer.measure_text(nil, c_name)

            m_active[c_name].active = true
            m_active[c_name].offset = text_width
            m_active[c_name].mode = hotkey_modes[state[2]]
            m_active[c_name].alpha = m_active[c_name].alpha + frames

            if m_active[c_name].alpha > 1 then
                m_active[c_name].alpha = 1
            end
        elseif m_active[c_name] ~= nil then
            m_active[c_name].active = false
            m_active[c_name].alpha = m_active[c_name].alpha - frames

            if m_active[c_name].alpha <= 0 then
                m_active[c_name] = nil
            end
        end

        if m_active[c_name] ~= nil and m_active[c_name].offset > maximum_offset then
            maximum_offset = m_active[c_name].offset
        end
    end

    if is_menu_open and not latest_item then
        local case_name = 'Menu toggled'
        local text_width = renderer.measure_text(nil, case_name)

        latest_item = true
        maximum_offset = maximum_offset < text_width and text_width or maximum_offset

        m_active[case_name] = {
            active = true,
            offset = text_width,
            mode = '~',
            alpha = 1,
        }
    end

    local keybindtext = 'keybinds'
    local x, y = hotkeys_dragging:get()

    local height_offset = 23
    local w, h = 75 + maximum_offset, 50

    if ui.get(styleui) == "Default" then
        if GLOBAL_ALPHA ~= 0 then
            renderer.blur(x,y+4,w,16)   
        end
        renderer.rectangle(x + 7, y + 2, w - 14, 18, 20, 20, 20, GLOBAL_ALPHA*color4)
        renderer.circle(x + 7, y + 9, 20, 20, 20, GLOBAL_ALPHA*color4, 7, 180, 0.25)
        renderer.rectangle(x, y + 9, 7, 11, 20, 20, 20, GLOBAL_ALPHA*color4)
        renderer.circle(x + w - 7, y + 9, 20, 20, 20, GLOBAL_ALPHA*color4, 7, 90, 0.25)
        renderer.rectangle(x + w - 7, y + 9, 7, 11, 20, 20, 20, GLOBAL_ALPHA*color4)
        renderer.rectangle(x + 7, y + 2, w - 14, 2, color1, color2, color3, GLOBAL_ALPHA*255)
        renderer.gradient(x - 1, y + 6, 2, 14, color1, color2, color3, GLOBAL_ALPHA*255, color1, color2, color3, 0, false) 
        renderer.gradient(x - 1 + w, y + 6, 2, 14, color1, color2, color3, GLOBAL_ALPHA*255, color1, color2, color3, 0, false) 
        renderer.circle_outline(x + 7, y + 12, color1, color2, color3, GLOBAL_ALPHA*255, 10, 220, 0.15, 2)
        renderer.circle_outline(x + w - 7, y + 12, color1, color2, color3, GLOBAL_ALPHA*255, 10, 270, 0.15, 2)
        renderer.text(x - renderer.measure_text(nil, keybindtext) / 2 + w/2, y + 5.5, 255, 255, 255, GLOBAL_ALPHA*255, '', 0, keybindtext)
    else
        container_glow(x, y, w, 18, color1, color2, color3, GLOBAL_ALPHA*color4, GLOBAL_ALPHA*1.2, color1, color2, color3)
        renderer.text(x - renderer.measure_text(nil, keybindtext) / 2 + w/2, y + 2.5, 255, 255, 255, GLOBAL_ALPHA*255, '', 0, keybindtext)
    end

    for c_name, c_ref in pairs(m_active) do
        local key_type = '[' .. c_ref.mode .. ']'

        renderer.text(x + 5, y + height_offset, 255, 255, 255, GLOBAL_ALPHA*c_ref.alpha*255, '', 0, c_name)
        renderer.text(x + w - renderer.measure_text(nil, key_type) - 5, y + height_offset, 255, 255, 255, GLOBAL_ALPHA*c_ref.alpha*255, '', 0, key_type)

        height_offset = height_offset + 15
    end

    hotkeys_dragging:drag(w, (3 + (15 * item_count(m_active))) * 2)

    if master_switch and item_count(m_active) > 0 and latest_item then
        GLOBAL_ALPHA = GLOBAL_ALPHA + frames; if GLOBAL_ALPHA > 1 then GLOBAL_ALPHA = 1 end
    else
        GLOBAL_ALPHA = GLOBAL_ALPHA - frames; if GLOBAL_ALPHA < 0 then GLOBAL_ALPHA = 0 end 
    end

    if is_menu_open then
        m_active['Menu toggled'] = nil
    end
end)

--[[create_item('LEGIT', 'Aimbot', 'Enabled', 2, 'Legit aimbot')
create_item('LEGIT', 'Triggerbot', 'Enabled', 2, 'Legit triggerbot')

create_item('RAGE', 'Aimbot', 'Enabled', 2, 'Rage aimbot')
create_item('RAGE', 'Aimbot', 'Force safe point', 1, 'Safe point')

create_item('RAGE', 'Other', 'Quick stop', 2)
create_item('RAGE', 'Other', 'Force body aim', 1)
create_item('RAGE', 'Other', 'Duck peek assist', 1)
create_item('RAGE', 'Other', 'Double tap', 2)

create_item('RAGE', 'Other', 'Anti-aim correction override', 1, 'Resolver override')
create_item('AA', 'Anti-aimbot angles', 'Freestanding', 2)
create_item('AA', 'Other', 'Slow motion', 2)
create_item('AA', 'Other', 'On shot anti-aim', 2)

create_item('MISC', 'Movement', 'Z-Hop', 2)
create_item('MISC', 'Movement', 'Pre-speed', 2)
create_item('MISC', 'Movement', 'Blockbot', 2)
create_item('MISC', 'Movement', 'Jump at edge', 2)

create_item('MISC', 'Miscellaneous', 'Last second defuse', 1)
create_item('MISC', 'Miscellaneous', 'Free look', 1)

create_item('MISC', 'Miscellaneous', 'Ping spike', 2)
create_item('MISC', 'Miscellaneous', 'Automatic grenade release', 2, 'Grenade release')
create_item('VISUALS', 'Player ESP', 'Activation type', 1, 'Visuals')

create_item('AA', 'Anti-aimbot angles', 'Edge Yaw on Key', 1)
create_item('AA', 'Anti-aimbot angles', 'Sync Yaw on Target', 1)
create_item('AA', 'Anti-aimbot angles', 'Roll AA key', 1)
create_item('RAGE', 'Other', 'Quick peek assist',2)]]

local function hide_menu()
    ui.set_visible(conditiontab, false)
    ui.set_visible(anti_aim[1].addition, false)
    ui.set_visible(anti_aim[1].styaw, false)
    ui.set_visible(anti_aim[1].ndyaw, false)
    ui.set_visible(anti_aim[1].flick_speed, false)
    ui.set_visible(anti_aim[1].body_yaw, false)
    ui.set_visible(anti_aim[1].body_yaw_val, false)
    ui.set_visible(anti_aim[1].jitter_yaw, false)
    ui.set_visible(anti_aim[1].jitter_yaw_val, false)
    ui.set_visible(anti_aim[1].fake_addition, false)
    ui.set_visible(anti_aim[1].stfake_val, false)
    ui.set_visible(anti_aim[1].ndfake_val, false)
    ui.set_visible(anti_aim[1].flick_speed2, false)
    ui.set_visible(anti_aim[2].addition, false)
    ui.set_visible(anti_aim[2].fake_addition, false)
    ui.set_visible(anti_aim[2].styaw, false)
    ui.set_visible(anti_aim[2].ndyaw, false)
    ui.set_visible(anti_aim[2].flick_speed, false)
    ui.set_visible(anti_aim[2].body_yaw, false)
    ui.set_visible(anti_aim[2].body_yaw_val, false)
    ui.set_visible(anti_aim[2].jitter_yaw, false)
    ui.set_visible(anti_aim[2].jitter_yaw_val, false)
    ui.set_visible(anti_aim[2].stfake_val, false)
    ui.set_visible(anti_aim[2].ndfake_val, false)
    ui.set_visible(anti_aim[2].flick_speed2, false)
    ui.set_visible(anti_aim[3].addition, false)
    ui.set_visible(anti_aim[3].fake_addition, false)
    ui.set_visible(anti_aim[3].styaw, false)
    ui.set_visible(anti_aim[3].ndyaw, false)
    ui.set_visible(anti_aim[3].flick_speed, false)
    ui.set_visible(anti_aim[3].body_yaw, false)
    ui.set_visible(anti_aim[3].body_yaw_val, false)
    ui.set_visible(anti_aim[3].jitter_yaw, false)
    ui.set_visible(anti_aim[3].jitter_yaw_val, false)
    ui.set_visible(anti_aim[3].stfake_val, false)
    ui.set_visible(anti_aim[3].ndfake_val, false)
    ui.set_visible(anti_aim[3].flick_speed2, false)
    ui.set_visible(anti_aim[4].addition, false)
    ui.set_visible(anti_aim[4].styaw, false)
    ui.set_visible(anti_aim[4].ndyaw, false)
    ui.set_visible(anti_aim[4].flick_speed, false)
    ui.set_visible(anti_aim[4].body_yaw, false)
    ui.set_visible(anti_aim[4].body_yaw_val, false)
    ui.set_visible(anti_aim[4].jitter_yaw, false)
    ui.set_visible(anti_aim[4].jitter_yaw_val, false)
    ui.set_visible(anti_aim[4].fake_addition, false)
    ui.set_visible(anti_aim[4].stfake_val, false)
    ui.set_visible(anti_aim[4].ndfake_val, false)
    ui.set_visible(anti_aim[4].flick_speed2, false)
end

local function handle_menu()
    hide_menu()

    if ui.get(presets) ~= "Custom" then return end

    ui.set_visible(conditiontab, true)
    
    if ui.get(conditiontab) == "Standing" then
        ui.set_visible(anti_aim[1].addition, true)
        ui.set_visible(anti_aim[1].styaw, true)
        ui.set_visible(anti_aim[1].ndyaw, true)
        if ui.get(anti_aim[1].addition) == "Flick Between" or ui.get(anti_aim[1].addition) == "Flick Around" then
            ui.set_visible(anti_aim[1].flick_speed, true)
        else
            ui.set_visible(anti_aim[1].flick_speed, false)
        end
        ui.set_visible(anti_aim[1].body_yaw, true)
        ui.set_visible(anti_aim[1].body_yaw_val, true)
        ui.set_visible(anti_aim[1].jitter_yaw, true)
        if ui.get(anti_aim[1].jitter_yaw) ~= "Off" then
            ui.set_visible(anti_aim[1].jitter_yaw_val, true)
        end
        ui.set_visible(anti_aim[1].fake_addition, true)
        ui.set_visible(anti_aim[1].stfake_val, true)
        ui.set_visible(anti_aim[1].ndfake_val, true)
        if ui.get(anti_aim[1].fake_addition) == "Flick Between" or ui.get(anti_aim[1].fake_addition) == "Flick Around" then
            ui.set_visible(anti_aim[1].flick_speed2, true)
        else
            ui.set_visible(anti_aim[1].flick_speed2, false)
        end
    elseif ui.get(conditiontab) == "Moving" then
        ui.set_visible(anti_aim[2].addition, true)
        ui.set_visible(anti_aim[2].styaw, true)
        ui.set_visible(anti_aim[2].ndyaw, true)
        if ui.get(anti_aim[2].addition) == "Flick Between" or ui.get(anti_aim[2].addition) == "Flick Around" then
            ui.set_visible(anti_aim[2].flick_speed, true)
        else
            ui.set_visible(anti_aim[2].flick_speed, false)
        end
        ui.set_visible(anti_aim[2].body_yaw, true)
        ui.set_visible(anti_aim[2].body_yaw_val, true)
        ui.set_visible(anti_aim[2].jitter_yaw, true)
        if ui.get(anti_aim[2].jitter_yaw) ~= "Off" then
            ui.set_visible(anti_aim[2].jitter_yaw_val, true)
        end
        ui.set_visible(anti_aim[2].fake_addition, true)
        ui.set_visible(anti_aim[2].stfake_val, true)
        ui.set_visible(anti_aim[2].ndfake_val, true)
        if ui.get(anti_aim[2].fake_addition) == "Flick Between" or ui.get(anti_aim[2].fake_addition) == "Flick Around" then
            ui.set_visible(anti_aim[2].flick_speed2, true)
        else
            ui.set_visible(anti_aim[2].flick_speed2, false)
        end
    elseif ui.get(conditiontab) == "Air" then
        ui.set_visible(anti_aim[3].addition, true)
        ui.set_visible(anti_aim[3].styaw, true)
        ui.set_visible(anti_aim[3].ndyaw, true)
        if ui.get(anti_aim[3].addition) == "Flick Between" or ui.get(anti_aim[3].addition) == "Flick Around" then
            ui.set_visible(anti_aim[3].flick_speed, true)
        else
            ui.set_visible(anti_aim[3].flick_speed, false)
        end
        ui.set_visible(anti_aim[3].body_yaw, true)
        ui.set_visible(anti_aim[3].body_yaw_val, true)
        ui.set_visible(anti_aim[3].jitter_yaw, true)
        if ui.get(anti_aim[3].jitter_yaw) ~= "Off" then
            ui.set_visible(anti_aim[3].jitter_yaw_val, true)
        end
        ui.set_visible(anti_aim[3].fake_addition, true)
        ui.set_visible(anti_aim[3].stfake_val, true)
        ui.set_visible(anti_aim[3].ndfake_val, true)
        if ui.get(anti_aim[3].fake_addition) == "Flick Between" or ui.get(anti_aim[3].fake_addition) == "Flick Around" then
            ui.set_visible(anti_aim[3].flick_speed2, true)
        else
            ui.set_visible(anti_aim[3].flick_speed2, false)
        end
    else
        ui.set_visible(anti_aim[4].addition, true)
        ui.set_visible(anti_aim[4].styaw, true)
        ui.set_visible(anti_aim[4].ndyaw, true)
        if ui.get(anti_aim[4].addition) == "Flick Between" or ui.get(anti_aim[4].addition) == "Flick Around" then
            ui.set_visible(anti_aim[4].flick_speed, true)
        else
            ui.set_visible(anti_aim[4].flick_speed, false)
        end
        ui.set_visible(anti_aim[4].body_yaw, true)
        ui.set_visible(anti_aim[4].body_yaw_val, true)
        ui.set_visible(anti_aim[4].jitter_yaw, true)
        if ui.get(anti_aim[4].jitter_yaw) ~= "Off" then
            ui.set_visible(anti_aim[4].jitter_yaw_val, true)
        end
        ui.set_visible(anti_aim[4].fake_addition, true)
        ui.set_visible(anti_aim[4].stfake_val, true)
        ui.set_visible(anti_aim[4].ndfake_val, true)
        if ui.get(anti_aim[4].fake_addition) == "Flick Between" or ui.get(anti_aim[4].fake_addition) == "Flick Around" then
            ui.set_visible(anti_aim[4].flick_speed2, true)
        else
            ui.set_visible(anti_aim[4].flick_speed2, false)
        end
    end
end

client.set_event_callback("paint_ui", function()
    local hotkey_rf, active_rf, bind_rf = ui.get(edgeyawkey)
    if ui.get(tabselection) == "Anti-Aim" then
        handle_menu()
        ui.set_visible(tabselection, true)
        ui.set_visible(presets, true)
        ui.set_visible(edgeyawkey, true)
        if hotkey_rf or bind_rf ~= nil then
            ui.set_visible(edgeyawdisable, true)
        else
            ui.set_visible(edgeyawdisable, false)
        end
        ui.set_visible(syncyawtarget, true)
        ui.set_visible(additions, true)
        ui.set_visible(forcesafe, true)
        ui.set_visible(freestandtype, true)
        ui.set_visible(ui_left, true)
        ui.set_visible(ui_right, true)
        ui.set_visible(ui_back, true)
        if contains(additions, "Freestanding") then
            ui.set_visible(freestandtype, true)
        else
            ui.set_visible(freestandtype, false)
        end
        ui.set_visible(indbox, false)
        ui.set_visible(color, false)
        ui.set_visible(color0, false)
        ui.set_visible(crossind, false)
        ui.set_visible(sktind, false)
        ui.set_visible(uiind, false)
        ui.set_visible(debugind, false)
        ui.set_visible(watermarkname, false)
        ui.set_visible(preferbodyif, false)
        ui.set_visible(forcebodyif, false)
        ui.set_visible(resolver_cb, false)
        ui.set_visible(enablelogger, false)
        ui.set_visible(logsprinted, false)
        ui.set_visible(printevents, false)
        ui.set_visible(enableflags, false)
        ui.set_visible(flagstab, false)
        ui.set_visible(killsay, false)
        ui.set_visible(styleui, false)
        ui.set_visible(enableantidef, false)
        ui.set_visible(accuracy_def, false)
        ui.set_visible(extrapolate_add, false)
    elseif ui.get(tabselection) == "Visual" then
        hide_menu()
        ui.set_visible(tabselection, true)
        ui.set_visible(indbox, true)
        if ui.get(indbox) then
            ui.set_visible(color, true)
            ui.set_visible(crossind, true)
            ui.set_visible(sktind, true)
            ui.set_visible(uiind, true)
            ui.set_visible(debugind, true)
            ui.set_visible(enableflags, true)
            if ui.get(enableflags) then
                ui.set_visible(flagstab, true)
            else
                ui.set_visible(flagstab, false)
            end
            if contains(uiind, "Watermark") then
                ui.set_visible(watermarkname, true)
            else
                ui.set_visible(watermarkname, false)
            end
            if contains(uiind, "Keybinds") or contains(uiind, "Watermark") or contains(uiind, "FL/DT") or contains(uiind, "Anti-aimbot") then
                ui.set_visible(styleui, true)
                ui.set_visible(color, true)
            else
                ui.set_visible(styleui, false)
                ui.set_visible(color, false)
            end
            if ui.get(crossind) then
                ui.set_visible(color0, true)
            else
                ui.set_visible(color0, false)
            end
        else
            ui.set_visible(color, false)
            ui.set_visible(color0, false)
            ui.set_visible(crossind, false)
            ui.set_visible(sktind, false)
            ui.set_visible(uiind, false)
            ui.set_visible(debugind, false)
            ui.set_visible(watermarkname, false)
        end
        if contains(debugind, "Debug Table") or contains(debugind, "Player Information") then
            ui.set_visible(d_color,true)
        else
            ui.set_visible(d_color,false)
        end
        ui.set_visible(presets, false)
        ui.set_visible(additions, false)
        ui.set_visible(forcesafe, false)
        ui.set_visible(freestandtype, false)
        ui.set_visible(ui_left, false)
        ui.set_visible(ui_right, false)
        ui.set_visible(ui_back, false)
        ui.set_visible(preferbodyif, false)
        ui.set_visible(forcebodyif, false)
        ui.set_visible(resolver_cb, false)
        ui.set_visible(enablelogger, false)
        ui.set_visible(logsprinted, false)
        ui.set_visible(printevents, false)
        ui.set_visible(killsay, false)


        ui.set_visible(syncyawtarget, false)
        ui.set_visible(edgeyawkey, false)
        ui.set_visible(edgeyawdisable, false)
        ui.set_visible(enableantidef, false)
        ui.set_visible(accuracy_def, false)
        ui.set_visible(extrapolate_add, false)
    elseif ui.get(tabselection) == "Rage-Bot" then
        hide_menu()
        ui.set_visible(tabselection, true)
        ui.set_visible(preferbodyif, true)
        ui.set_visible(forcebodyif, true)
        ui.set_visible(resolver_cb, true)
        ui.set_visible(enableantidef, true)
        if ui.get(enableantidef) then
            ui.set_visible(accuracy_def, true)
            ui.set_visible(extrapolate_add, true)
        else
            ui.set_visible(accuracy_def, false)
            ui.set_visible(extrapolate_add, false)
        end
        ui.set_visible(presets, false)
        ui.set_visible(additions, false)
        ui.set_visible(forcesafe, false)
        ui.set_visible(freestandtype, false)
        ui.set_visible(ui_left, false)
        ui.set_visible(ui_right, false)
        ui.set_visible(ui_back, false)
        ui.set_visible(indbox, false)
        ui.set_visible(color, false)
        ui.set_visible(color0, false)
        ui.set_visible(crossind, false)
        ui.set_visible(sktind, false)
        ui.set_visible(uiind, false)
        ui.set_visible(debugind, false)
        ui.set_visible(watermarkname, false)
        ui.set_visible(enablelogger, false)
        ui.set_visible(logsprinted, false)
        ui.set_visible(printevents, false)
        ui.set_visible(enableflags, false)
        ui.set_visible(flagstab, false)
        ui.set_visible(killsay, false)
        ui.set_visible(styleui, false)


        ui.set_visible(syncyawtarget, false)
        ui.set_visible(edgeyawkey, false)
        ui.set_visible(edgeyawdisable, false)
        ui.set_visible(d_color,false)
    elseif ui.get(tabselection) == "Misc" then
        hide_menu()
        ui.set_visible(tabselection, true)
        ui.set_visible(enablelogger, true)
        ui.set_visible(printevents, true)
        ui.set_visible(killsay, true)
        if ui.get(enablelogger) then
            ui.set_visible(logsprinted, true)
        else
            ui.set_visible(logsprinted, false)
        end
        ui.set_visible(presets, false)
        ui.set_visible(additions, false)
        ui.set_visible(forcesafe, false)
        ui.set_visible(freestandtype, false)
        ui.set_visible(ui_left, false)
        ui.set_visible(ui_right, false)
        ui.set_visible(ui_back, false)
        ui.set_visible(indbox, false)
        ui.set_visible(color, false)
        ui.set_visible(color0, false)
        ui.set_visible(crossind, false)
        ui.set_visible(sktind, false)
        ui.set_visible(uiind, false)
        ui.set_visible(debugind, false)
        ui.set_visible(watermarkname, false)
        ui.set_visible(preferbodyif, false)
        ui.set_visible(forcebodyif, false)
        ui.set_visible(resolver_cb, false)
        ui.set_visible(enableflags, false)
        ui.set_visible(flagstab, false)
        ui.set_visible(styleui, false)


        ui.set_visible(syncyawtarget, false)
        ui.set_visible(edgeyawkey, false)
        ui.set_visible(edgeyawdisable, false)
        ui.set_visible(d_color,false)
        ui.set_visible(enableantidef, false)
        ui.set_visible(accuracy_def, false)
        ui.set_visible(extrapolate_add, false)
    else
        hide_menu()
        ui.set_visible(tabselection, false)
        ui.set_visible(presets, false)
        ui.set_visible(additions, false)
        ui.set_visible(forcesafe, false)
        ui.set_visible(freestandtype, false)
        ui.set_visible(ui_left, false)
        ui.set_visible(ui_right, false)
        ui.set_visible(ui_back, false)
        ui.set_visible(indbox, false)
        ui.set_visible(color, false)
        ui.set_visible(color0, false)
        ui.set_visible(crossind, false)
        ui.set_visible(sktind, false)
        ui.set_visible(uiind, false)
        ui.set_visible(debugind, false)
        ui.set_visible(watermarkname, false)
        ui.set_visible(preferbodyif, false)
        ui.set_visible(forcebodyif, false)
        ui.set_visible(enablelogger, false)
        ui.set_visible(logsprinted, false)
        ui.set_visible(printevents, false)
        ui.set_visible(enableflags, false)
        ui.set_visible(killsay, false)
        ui.set_visible(resolver_cb, false)
        ui.set_visible(flagstab, false)
        ui.set_visible(styleui, false)
        ui.set_visible(syncyawtarget, false)
        ui.set_visible(edgeyawkey, false)
        ui.set_visible(edgeyawdisable, false)
        ui.set_visible(d_color,false)
        ui.set_visible(enableantidef, false)
        ui.set_visible(accuracy_def, false)
        ui.set_visible(extrapolate_add, false)
        ui.set_visible(usertab, true)
        ui.set_visible(passwordtab, true)
        ui.set_visible(button, true)
    end
    ui.set_visible(targets,false)
    ui.set_visible(yaw_am,false)
    ui.set_visible(yaw_val,false)
    ui.set_visible(jyaw,false)
    ui.set_visible(jyaw_val,false)
    ui.set_visible(byaw,false)
    ui.set_visible(byaw_val,false)
    ui.set_visible(fs_body_yaw,false)
    --ui.set_visible(fake_yaw,false)
    ui.set_visible(rollskeet,false)
    ui.set_visible(edge_yaw, false)

    ui.set_visible(enablecustomfl, true)

    if ui.get(enablecustomfl) then
        ui.set_visible(enablefl,false)
        ui.set_visible(fl_amount,false)
        ui.set_visible(fl_limit,false)
        ui.set_visible(fl_var,false)
        ui.set_visible(fltab, true)
        if ui.get(fltab) == "Dynamic" then
            ui.set_visible(triggers,true)
        else
            ui.set_visible(triggers,false)
        end
        if ui.get(fltab) == "Maximum" then
            ui.set_visible(triggerlimit,false)
        else
            ui.set_visible(triggerlimit,true)
        end
        ui.set_visible(sendlimit,true)
        ui.set_visible(forcelimit,true)
    else
        ui.set_visible(enablefl,true)
        ui.set_visible(fl_amount,true)
        ui.set_visible(fl_limit,true)
        ui.set_visible(fl_var,true)
        ui.set_visible(fltab, false)
        ui.set_visible(triggers,false)
        ui.set_visible(forcelimit,false)
        ui.set_visible(triggerlimit,false)
        ui.set_visible(sendlimit,false)
    end
end)

client.set_event_callback("round_start", function()
    local menu_r, menu_b, menu_g, menu_a = ui.get(menu_c)
    fakeFlick = false
    flipJitter = false
    back_dir = true
    left_dir = false
    right_dir = false
    last_press_t = 0
    should_swap = 0
    adaptive_freestand = 0
    ticks_flick = 0
    flicks = false
    no_lethalpresetnoti = false
    lp_lethal = false
    right_side = true
    left_side = false
    position_y = 0

    if ui.get(printevents) then
    android_notify:paint(3, string.format('Reloading anti-aim preset cache'))
    end

    local enemies = entity.get_players(true)

    for itter = 1, #enemies do
        local player = enemies[itter]
        if not player_memory[player] then
            table.insert(player_memory, player, {
                notifilethalwas = false,
                misses = 0
            })
        end
        player_memory[player].notifilethalwas = false
        player_memory[player].misses = false
    end
end)

client.set_event_callback("player_connect_full", function()
    local menu_r, menu_b, menu_g, menu_a = ui.get(menu_c)
    fakeFlick = false
    flipJitter = false
    back_dir = true
    left_dir = false
    right_dir = false
    last_press_t = 0
    should_swap = 0
    adaptive_freestand = 0
    ticks_flick = 0
    flicks = false
    no_lethalpresetnoti = false
    lp_lethal = false
    right_side = true
    left_side = false
    position_y = 0

    local enemies = entity.get_players(true)

    for itter = 1, #enemies do
        local player = enemies[itter]
        if not player_memory[player] then
            table.insert(player_memory, player, {
                notifilethalwas = false,
                misses = 0
            })
        end
        player_memory[player].notifilethalwas = false
        player_memory[player].misses = false
    end
end)

client.set_event_callback("shutdown", function()
    ui.set(targets, "At targets")
    ui.set(yaw_am, "180")
    ui.set(yaw_val, 0)
    ui.set(jyaw, "Off")
    ui.set(jyaw_val, 0)
    ui.set(byaw, "Static")
    ui.set(byaw_val, 180)
    ui.set(fs_body_yaw, true)
   -- ui.set(fake_yaw, 60)
    ui.set(rollskeet, 0)
    ui.set_visible(targets,true)
    ui.set_visible(yaw_am,true)
    ui.set_visible(yaw_val,true)
    ui.set_visible(jyaw,true)
    ui.set_visible(jyaw_val,true)
    ui.set_visible(byaw,true)
    ui.set_visible(byaw_val,true)
    ui.set_visible(fs_body_yaw,true)
    --ui.set_visible(fake_yaw,true)
    ui.set_visible(rollskeet,true)
    ui.set_visible(enablefl,true)
    ui.set_visible(fl_amount,true)
    ui.set_visible(fl_limit,true)
    ui.set_visible(fl_var,true)
    ui.set_visible(edge_yaw, true)
end)

client.register_esp_flag("angle", 255, 255, 255, function(entity_index)
    if not ui.get(enableflags) or not contains(flagstab, "Angle") then return end
    local anglesss = "{"..math.floor(entity.get_prop(entity_index, "m_flPoseParameter", 11) * 120 - 60 ).."}"
    return true, anglesss
end)

client.register_esp_flag("condition", 255, 190, 100, function(entity_index)
    if not ui.get(enableflags) or not contains(flagstab, "Aimbot State") then return end
    if plist.get(entity_index, "Override prefer body aim") == "On" then condition = "PREFER" elseif plist.get(entity_index, "Override prefer body aim") == "Force" then condition = "FORCE" else condition = "DEFAULT" end
    return true, condition
end)

client.register_esp_flag("predict", 145, 255, 180, function(entity_index)
    if not ui.get(enableflags) or not contains(flagstab, "Prediction") then return end
    if cvar.cl_lagcompensation:get_int() ~= 1 then prediction = "PREDICTION" else prediction = "LC" end
    return true, prediction
end)