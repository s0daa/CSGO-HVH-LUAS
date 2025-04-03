-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local ffi = require("ffi")
local http = require("gamesense/http")
local data = { tickbase = {  shifting = 0, list = (function() local index, max = { }, 16 for i=1, max do index[#index+1] = 0 if i == max then return index end end end)() }, } local ease = require("gamesense/easing") client.set_event_callback('net_update_start', function() local local_player = entity.get_local_player() local sim_time = entity.get_prop(local_player, "m_flSimulationTime") if local_player == nil or sim_time == nil then return end local tick_count = globals.tickcount() local shifted = math.max(unpack(data.tickbase.list)) data.tickbase.shifting = shifted < 0 and math.abs(shifted) or 0 data.tickbase.list[#data.tickbase.list+1] = sim_time/globals.tickinterval() - tick_count table.remove(data.tickbase.list, 1) end) local get_curtime = function(nOffset) return globals.curtime() - (nOffset * globals.tickinterval()) end local weapon_ready = function() local target = entity.get_local_player() local weapon = entity.get_player_weapon(target) if target == nil or weapon == nil then return false end if get_curtime(16) < entity.get_prop(target, 'm_flNextAttack') then return false end if get_curtime(0) < entity.get_prop(weapon, 'm_flNextPrimaryAttack') then return false end return true end local native_GetClipboardTextCount = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)") local native_SetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)") local native_GetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)") local new_char_arr = ffi.typeof("char[?]") local clipboard = { set = function(text) text = tostring(text) native_SetClipboardText(text, string.len(text)) end, get = function() local len = native_GetClipboardTextCount() if len > 0 then local char_arr = new_char_arr(len) native_GetClipboardText(0, char_arr, len) return ffi.string(char_arr, len-1) end end } local anti_aim = { get_double_tap = function() return weapon_ready() and data.tickbase.shifting > 0 end } local antiaim_funcs = anti_aim local images = require("gamesense/images") local vector = require("vector")

local protected = {}
protected[8] = "anti-aimbot angles"
protected[9] = "new_combobox"
protected[3] = "new_slider"
protected[1] = "set_visible"
protected[4] = "setup_command"
protected[5] = "paint_ui"
protected[10] = "text"
protected[6] = "aa"
protected[7] = "get_local_player"
protected[2] = "reference"

local username = function() return "flurry" end
local build = function() return "nightly" end
local images = require("gamesense/images")
local zov_icon_small
local def_icon
local loading_gif
local gif_decoder = require "gamesense/gif_decoder"
local gif1
local left_icon
local right_icon

http.get("https://cdn.discordapp.com/attachments/844966073131335713/1068212673587724338/Tranparent-Glow.png",function(a,b)if a and b.status==200 then def_icon=images.load(b.body)else print("couldn't load zov icon")end end)
http.get("https://cdn.discordapp.com/attachments/844966073131335713/1068159288247324742/gopng.png",function(a,b)if a and b.status==200 then zov_icon_small=images.load(b.body)else print("couldn't load zov icon")end end)

start_time = globals.realtime()

contains=function(b,c)for d,e in pairs(b)do if e==c then return true end end;return false end

clamp = function (val, min, max)
    return math.max(math.min(val, max), min)
end

easeInOut = function(g)
    return g>0.5 and 4*(g-1)^3+1 or 4*g^3 
end

rgba_to_hex2=function(m,n,o,p)
    return bit.tohex(math.floor(m+0.5)*16777216+math.floor(n+0.5)*65536+math.floor(o+0.5)*256+math.floor(p+0.5))
end

lerp=function(a,b,c)c=clamp(c,0.01,1)if type(a)=='table'then local d={0,0,0,0}for e in ipairs(a)do d[e]=lerp(a[e],b[e],c)end;return d end;local f=b-a;if math.abs(f)<0.001 then return b end;return a+f*c end

breathe=function(b,c,d)local e=(d or globals.realtime())*(c or 1.0)local f=e%math.pi;local g=math.sin(f+(b or 0))local h=math.abs(g)return h end

local callback = { callbacks = {} }

function register(event, func)
    if not callback.callbacks[event] then
        callback.callbacks[event] = {}
    end
    table.insert(callback.callbacks[event], func)
end

local reference={enabled=ui[protected[2]](protected[6],protected[8],"enabled"),pitch=ui[protected[2]](protected[6],protected[8],"pitch"),yaw_base=ui[protected[2]](protected[6],protected[8],"yaw base"),yaw={ui[protected[2]](protected[6],protected[8],"yaw")},yaw_jitter={ui[protected[2]](protected[6],protected[8],"yaw jitter")},body_yaw={ui[protected[2]](protected[6],protected[8],"body yaw")},freestanding_body_yaw=ui[protected[2]](protected[6],protected[8],"freestanding body yaw"),fake_yaw_limit=ui[protected[2]](protected[6],protected[8],"fake yaw limit"),edge_yaw=ui[protected[2]](protected[6],protected[8],"edge yaw"),freestanding={ui[protected[2]](protected[6],protected[8],"freestanding")},roll=ui[protected[2]](protected[6],protected[8],"roll"),slow_motion={ui[protected[2]](protected[6],"other","slow motion")},leg_movement=ui[protected[2]](protected[6],"other","leg movement"),on_shot_aa={ui[protected[2]](protected[6],"other","on shot anti-aim")},fl_limit=ui[protected[2]](protected[6],"fake lag","limit"),dt={ui[protected[2]]("RAGE","Other","Double tap")},fake_duck=ui[protected[2]]("rage","other","duck peek assist"),menu_col=ui[protected[2]]("misc","settings","menu color"),forcebaim=ui[protected[2]]("rage","other","force body aim"),forcesp=ui[protected[2]]("rage","aimbot","force safe point")}

local dt_fakelag = ui.reference("rage", "other", "double tap fake lag limit")

local fix = function()
    ui.set(reference.pitch, "minimal")
    ui.set(reference.yaw_base, "at targets")
    ui.set(reference.yaw[1], "180")
    ui.set(reference.yaw[2], 0)
    ui.set(reference.yaw_jitter[1], "center")
    ui.set(reference.yaw_jitter[2], 0)
    ui.set(reference.body_yaw[1], "jitter")
    ui.set(reference.body_yaw[2], 0)
    ui.set(reference.fake_yaw_limit, 60)
    ui.set(reference.freestanding_body_yaw, false)
end

fix()

local color = {}

function color:as_string(a,b,c,d)return("\a%02X%02X%02X%02X"):format(a,b,c,d)end;function color:accent()return self:as_string(255,188,239,255)end;function color:default()return self:as_string(205,205,205,255)end

local aa_lol={delta=0,builder={conditions={"stand","run","slow","crouch","air","air crouch","fakelag"}},manual_state=0,state="NONE"}

local menu = {
    fl_limit = ui[protected[3]](protected[6], "fake lag", "Limit\n", 1, 15, ui.get(reference.fl_limit)),
}

ui.set_callback(menu.fl_limit, function () ui.set(reference.fl_limit, ui.get(menu.fl_limit)) end)

color3 = ui.new_color_picker(protected[6], protected[8], "color", 152, 172, 238, 255)

enabled_label = ui.new_label(protected[6], protected[8], "enable amnesia [ac130] - v.0.0.1")
tabs = ui[protected[9]](protected[6], protected[8], "\n", { "anti.aim", "visuals", "misc", "config"})
antiaim_mode = ui[protected[9]](protected[6], protected[8], "mode", { "zov-mode", "custom (NOT WORKING)" })
local dynamic_mode = ui.new_multiselect(protected[6], protected[8], ("change / reset zov-mode logic"):format(color:accent()), { "hit", "miss", "headshot"})
local team_mode = ui[protected[9]](protected[6], protected[8], "team", { "counterterrorist", "terrorist" })

--ping-spike ref
local ping_spike = {ui.reference("MISC", "Miscellaneous", "Ping spike")}

local antiaim_condition = ui[protected[9]](protected[6], protected[8], ("conditions"):format(color:accent()), aa_lol.builder.conditions)

config_list=ui.new_listbox(protected[6],protected[8],"configs","")config_name=ui.new_textbox(protected[6],protected[8],"config name")config_load=ui.new_button(protected[6],protected[8],"load",function()end)config_save=ui.new_button(protected[6],protected[8],"save",function()end)config_delete=ui.new_button(protected[6],protected[8],"delete",function()end)config_import=ui.new_button(protected[6],protected[8],"import",function()end)config_export=ui.new_button(protected[6],protected[8],"export",function()end)

rgba_to_hex = function( r, g, b, a )
    return string.format( '%02x%02x%02x%02x', r, g, b, a )
end

function menu:handler()local a={}for b,c in pairs(aa_lol.builder.conditions)do a[c]={}a[c].yaw_left_l=ui.new_label(protected[6],protected[8],"("..c..") - left yaw")a[c].yaw_left=ui[protected[3]](protected[6],protected[8],"\nct("..c..") - left yaw",-180,180,0,true,"°")a[c].yaw_left_r=ui.new_label(protected[6],protected[8],"("..c..") - right yaw")a[c].yaw_right=ui[protected[3]](protected[6],protected[8],"\nct("..c..") - right yaw",-180,180,0,true,"°")a[c].yaw_jitter=ui[protected[9]](protected[6],protected[8],("yaw jitter\nct%s"):format(c),{"off","center","l & r center","offset","l & r offset","random"})a[c].yaw_jitter_range=ui[protected[3]](protected[6],protected[8],("\nctyaw_jitter%s"):format(c),-180,180,0,true,"°")a[c].yaw_jitter_range_left=ui[protected[3]](protected[6],protected[8],("left\nctyaw_jitter%s"):format(c),-180,180,0,true,"°")a[c].yaw_jitter_range_right=ui[protected[3]](protected[6],protected[8],("right\nctyaw_jitter%s"):format(c),-180,180,0,true,"°")a[c].body_yaw=ui[protected[9]](protected[6],protected[8],("body yaw\nct%s"):format(c),{"off","opposite","jitter","static"})a[c].body_yaw_add=ui[protected[3]](protected[6],protected[8],("\nctbody_yaw_add%s"):format(c),-180,180,0,true,"°")a[c].fake_yaw_limit=ui[protected[3]](protected[6],protected[8],("fake limit\nct%s"):format(c),0,60,60,true,"°")a[c].yaw_left_l_t=ui.new_label(protected[6],protected[8],"("..c..") - left yaw")a[c].yaw_left_t=ui[protected[3]](protected[6],protected[8],"\nt("..c..") - left yaw",-180,180,0,true,"°")a[c].yaw_left_r_t=ui.new_label(protected[6],protected[8],"("..c..") - right yaw")a[c].yaw_right_t=ui[protected[3]](protected[6],protected[8],"\nt("..c..") - right yaw",-180,180,0,true,"°")a[c].yaw_jitter_t=ui[protected[9]](protected[6],protected[8],("yaw jitter\nt%s"):format(c),{"off","center","l & r center","offset","l & r offset","random"})a[c].yaw_jitter_range_t=ui[protected[3]](protected[6],protected[8],("\ntyaw_jitter%s"):format(c),-180,180,0,true,"°")a[c].yaw_jitter_range_left_t=ui[protected[3]](protected[6],protected[8],("left\ntyaw_jitter%s"):format(c),-180,180,0,true,"°")a[c].yaw_jitter_range_right_t=ui[protected[3]](protected[6],protected[8],("right\ntyaw_jitter%s"):format(c),-180,180,0,true,"°")a[c].body_yaw_t=ui[protected[9]](protected[6],protected[8],("body yaw\nt%s"):format(c),{"off","opposite","jitter","static"})a[c].body_yaw_add_t=ui[protected[3]](protected[6],protected[8],("\ntbody_yaw_add%s"):format(c),-180,180,0,true,"°")a[c].fake_yaw_limit_t=ui[protected[3]](protected[6],protected[8],("fake limit\nt%s"):format(c),0,60,60,true,"°")end;menu.builder_elements=a end

menu:handler()

local binds_label = ui.new_label(protected[6], protected[8], " ")
local binds = ui.new_multiselect(protected[6], protected[8], ("\nbinds"):format(color:accent()), { "manual aa", "freestanding", "freestand disablers", "edge yaw"})

local miscs = ui.new_multiselect(protected[6], protected[8], ("\nmiscs"):format(color:accent()), { "extrapolate def cycle", "recharge def on bad cycle", "break def in air"})

local manual_left_key = ui.new_hotkey(protected[6], protected[8], "manual left")
local manual_right_key = ui.new_hotkey(protected[6], protected[8], "manual right")
local manual_forward_key = ui.new_hotkey(protected[6], protected[8], "manual forward")
local freestanding_key = ui.new_hotkey(protected[6], protected[8], "freestanding")
local freestanding_disablers = ui.new_multiselect(protected[6], protected[8], "╰┈disablers", { "standing", "moving", "crouching", "in air", "slowwalking" })
local edge_yaw_key = ui.new_hotkey(protected[6], protected[8], "edge yaw")
local random_breaker = ui.new_hotkey(protected[6], protected[8], "[!] spin exploit on defensive")
local enable_indicators = ui.new_checkbox(protected[6], protected[8], "enable indicators")
local indicators = ui[protected[9]](protected[6], protected[8], "choose indicator style", { "-", "chimera"})
local enable_arrows = ui.new_checkbox(protected[6], protected[8], "enable manual aa arrows")
local arrow_ms = ui.new_multiselect(protected[6], protected[8], ("\nmanualaaoptions"):format(color:accent()), { "show side only", "hide in scope"})
local enable_notif = ui.new_checkbox(protected[6], protected[8], "enable notifications")
local notif_color = ui.new_color_picker(protected[6], protected[8], "bgcolor", 32, 30, 30, 255)
local notif_style = ui[protected[9]](protected[6], protected[8], "choose notif style", {"default", "modern" })
local notifs = ui.new_multiselect(protected[6], protected[8], ("\nnotifs"):format(color:accent()), { "size", "speed", "glow", "prefix", "bg color"})
local notif_size = ui[protected[3]](protected[6], protected[8], "notification size", -20, 20, 0, true, "x")
local notif_speed = ui[protected[3]](protected[6], protected[8], "notification duration", 0, 10, 4, true, "s")
local notif_glow = ui[protected[3]](protected[6], protected[8], "notification glow (size)", 0, 20, 14, true, "%", 0.1)
local notif_prefix = ui[protected[9]](protected[6], protected[8], "choose prefix", { "icon", "amnesia", "!"})
local enable_revealer = ui.new_checkbox(protected[6], protected[8], "\aAAAA60FFtoggle amnesia revealer [debug]")
local enable_legs = ui.new_checkbox(protected[6], protected[8], "toggle static legs")
local reduce_ticks = ui.new_checkbox(protected[6], protected[8], 'reduce sent ticks')
local invalidate_air = ui.new_checkbox(protected[6], protected[8], 'invalidate bt ticks in air')
--local defensive_num = ui[protected[3]](protected[6], protected[8], "chance to dodge bullet", 1, 100, 90, true, "%", 1, {[1] = "low", [50] = "medium", [100] = "random"})
local gethex=function(b,c,d,e,f,g,h,i)local j,k,l,m=c,d,e,0;local f,g,h,i=f,g,h,i;local n=globals.realtime()/2%1.3*2-1.3;local o=""for p=1,#b do local q=b:sub(p,p)local r=p/#b;local c,d,e,s=j,k,l,m;local t=r-n;if t>=0 and t<=1.4 then if t>0.7 then t=1.4-t end;r_fraction,g_fraction,b_fraction,a_fraction=f-c,g-d,h-e;c=c+r_fraction*t/0.8;d=d+g_fraction*t/0.8;e=e+b_fraction*t/0.8 end;o=o..('\a%02x%02x%02x%02x%s'):format(c,d,e,i,b:sub(p,p))end;return o end
local gradient_text_anim=function(b,c,d,e,f,g,h,i,j,k,l)local m,n,o,p=c,d,e,f;local g,h,i,j=g,h,i,j;k=k or 1;l=l or 0;l=l+3;local q=''local r=b:len()local s=globals.curtime()local t=s*k%l-2;for u=1,r do local v=b:sub(u,u)local w=(u-1)/(r-1)local x=w-t;if x>1 then x=1*2-x end;local c,d,e,f=m,n,o,p;local y=g-c;local z=h-d;local A=i-e;local B=j-f;if x>=0 and x<=1 then c=c+y*x;d=d+z*x;e=e+A*x;f=f+B*x end;q=q..('\a%02x%02x%02x%02x%s'):format(c,d,e,f,v)end;return q end

client.set_event_callback(protected[5], function()
    local r,g,b,a = ui.get(color3)

    local color_out = rgba_to_hex(r,g,b,a)

    ui.set(enabled_label, gethex("zov yaw antiaim extension", 255,255,255, r,g,b,250))

    ui.set(binds_label, "\a"..color_out.."[misc]\aFFFFFFC2 - zov-binds")

    for _, v in pairs(aa_lol.builder.conditions) do

        local elements = menu.builder_elements[v]

        local r,g,b,a = ui.get(color3)
        local color_out = rgba_to_hex(r,g,b,a)

        ui.set(elements.yaw_left_l, "\a"..color_out.."["..v.." ct]\aFFFFFFC2 - left yaw")
        ui.set(elements.yaw_left_r, "\a"..color_out.."["..v.." ct]\aFFFFFFC2 - right yaw")

        ui.set(elements.yaw_left_l_t, "\a"..color_out.."["..v.." t]\aFFFFFFC2 - left yaw")
        ui.set(elements.yaw_left_r_t, "\a"..color_out.."["..v.." t]\aFFFFFFC2 - right yaw")
    end
end)

local config = {}

local amnesia = {}

amnesia.database = {
    configs = ":amnesia::configs:",
}

amnesia.presets = {}

function get_config(a)local database=database.read(amnesia.database.configs)or{}for b,c in pairs(database)do if c.name==a then return{config=c.config,index=b}end end;for b,c in pairs(amnesia.presets)do if c.name==a then return{config=base64.decode(c.config),index=b}end end;return false end
function save_config(a)local b=database.read(amnesia.database.configs)or{}local c={}if a:match("[^%w]")~=nil then return end;local d={}for e,f in pairs(aa_lol.builder.conditions)do d[f]={}for g,h in pairs(menu.builder_elements[f])do d[f][g]=ui.get(h)end end;table.insert(c,json.stringify(d))local d=get_config(a)if not d then table.insert(b,{name=a,config=table.concat(c,":")})else b[d.index].config=table.concat(c,":")end;database.write(amnesia.database.configs,b)end
function delete_config(a)local b=database.read(amnesia.database.configs)or{}for c,d in pairs(b)do if d.name==a then table.remove(b,c)break end end;for c,d in pairs(amnesia.presets)do if d.name==a then return false end end;database.write(amnesia.database.configs,b)end
function get_config_list()local database=database.read(amnesia.database.configs)or{}local a={}local b=amnesia.presets;for c,d in pairs(b)do table.insert(a,d.name)end;for c,d in pairs(database)do table.insert(a,d.name)end;return a end
function config_tostring()local a={}for b,c in pairs(aa_lol.builder.conditions)do a[c]={}for d,e in pairs(menu.builder_elements[c])do a[c][d]=ui.get(e)end end;clipboard.set(json.stringify(a))end
function load_settings(a)if not pcall(function()json.parse(a)end)then error("invalid config format.")return end;local b=json.parse(a)for c,d in pairs(b)do for e,f in pairs(d)do ui.set(menu.builder_elements[c][e],f)end end end
function export_settings()local a={}for b,c in pairs(aa_lol.builder.conditions)do a[c]={}for d,e in pairs(menu.builder_elements[c])do a[c][d]=ui.get(e)end end;clipboard.set(json.stringify(a))end
function import_settings(a)if not pcall(function()json.parse(a)end)then error("invalid config format.")return end;local b=json.parse(a)for c,d in pairs(b)do for e,f in pairs(d)do ui.set(menu.builder_elements[c][e],f)end end end
function load_config(a)local b=get_config(a)load_settings(b.config)if a=="brandon"then hide_config=true else hide_config=false end;return hide_config end


function menu:visibility()

    local show = true

    local disablers = ui.get(binds)
    local antiaimmode = ui.get(antiaim_mode)

    ui.set(reference.enabled, true)

    --skeet menu aa hidden (minified)
    ui[protected[1]](reference.enabled,not show)ui[protected[1]](reference.pitch,not show)ui[protected[1]](reference.yaw_base,not show)ui[protected[1]](reference.yaw[1],not show)ui[protected[1]](reference.yaw[2],not show)ui[protected[1]](reference.yaw_jitter[1],not show)ui[protected[1]](reference.yaw_jitter[2],not show)ui[protected[1]](reference.body_yaw[1],not show)ui[protected[1]](reference.body_yaw[2],not show)ui[protected[1]](reference.freestanding_body_yaw,not show)ui[protected[1]](reference.fake_yaw_limit,not show)ui[protected[1]](reference.edge_yaw,not show)ui[protected[1]](reference.freestanding[1],not show)ui[protected[1]](reference.freestanding[2],not show)ui[protected[1]](reference.roll,not show)

    ui[protected[1]](tabs, show)

    local show_aa = show and ui.get(tabs) == "anti.aim"

    local show_misc = show and ui.get(tabs) == "misc"

    local show_config = show and ui.get(tabs) == "config"

    ui[protected[1]](enable_legs, false)

    ui[protected[1]](reduce_ticks, false)
    ui[protected[1]](invalidate_air, false)
    ui[protected[1]](invalidate_air, false)

    ui[protected[1]](enable_revealer, false)
    ui[protected[1]](config_list, show_config)
    ui[protected[1]](config_name, show_config)
    ui[protected[1]](config_load, show_config)
    ui[protected[1]](config_save, show_config)
    ui[protected[1]](config_delete, show_config)
    ui[protected[1]](config_import, show_config)
    ui[protected[1]](config_export, show_config)
    ui[protected[1]](binds, show_misc)
    ui[protected[1]](binds_label, show_misc)
    ui[protected[1]](miscs, false)
    ui[protected[1]](antiaim_mode, show_aa)
    
    if contains(disablers, "manual aa") then
	    ui[protected[1]](manual_left_key, show_misc)
	    ui[protected[1]](manual_right_key, show_misc)
	    ui[protected[1]](manual_forward_key, show_misc)
    else
        ui[protected[1]](manual_left_key, false)
	    ui[protected[1]](manual_right_key, false)
	    ui[protected[1]](manual_forward_key, false)
    end

    if contains(disablers, "freestanding") then
	    ui[protected[1]](freestanding_key, show_misc)
    else
        ui[protected[1]](freestanding_key, false)
    end

    if contains(disablers, "freestand disablers") then
	    ui[protected[1]](freestanding_disablers, show_misc)
    else
        ui[protected[1]](freestanding_disablers, false)
    end

    if contains(disablers, "edge yaw") then
	    ui[protected[1]](edge_yaw_key, show_misc)
    else
        ui[protected[1]](edge_yaw_key, false)
    end

    if ui.get(antiaim_mode) == "custom" and show_aa then
        ui[protected[1]](antiaim_condition, show_aa)
    else
        ui[protected[1]](antiaim_condition, false)
    end

    if ui.get(antiaim_mode) == "zov-mode" and show_aa then
        ui[protected[1]](dynamic_mode, show_aa)
        ui[protected[1]](random_breaker, show_aa)
    else
        ui[protected[1]](dynamic_mode, false)
        ui[protected[1]](random_breaker, false)
    end

    --custom aa loop (minified bc omg its long and ugly but im too lazy to fix it..)
    for a,b in pairs(aa_lol.builder.conditions)do local c=ui.get(antiaim_condition)==b and show_aa and not hide_config;local d=menu.builder_elements[b]if ui.get(antiaim_mode)=="custom"then ui[protected[1]](team_mode,show_aa)if ui.get(team_mode)=="counterterrorist"then ui[protected[1]](d.yaw_left_l,c)ui[protected[1]](d.yaw_left,c)ui[protected[1]](d.yaw_left_r,c)ui[protected[1]](d.yaw_right,c)ui[protected[1]](d.yaw_jitter,c)ui[protected[1]](d.yaw_jitter_range,c and ui.get(d.yaw_jitter)~="off"and not ui.get(d.yaw_jitter):find("l & r"))ui[protected[1]](d.yaw_jitter_range_left,c and ui.get(d.yaw_jitter)~="off"and ui.get(d.yaw_jitter):find("l & r"))ui[protected[1]](d.yaw_jitter_range_right,c and ui.get(d.yaw_jitter)~="off"and ui.get(d.yaw_jitter):find("l & r"))ui[protected[1]](d.body_yaw,c)ui[protected[1]](d.body_yaw_add,c and ui.get(d.body_yaw)~="off"and ui.get(d.body_yaw)~="opposite")ui[protected[1]](d.fake_yaw_limit,c and ui.get(d.body_yaw)~="off")ui[protected[1]](d.yaw_left_l_t,false)ui[protected[1]](d.yaw_left_r_t,false)ui[protected[1]](d.yaw_left_t,false)ui[protected[1]](d.yaw_right_t,false)ui[protected[1]](d.yaw_jitter_t,false)ui[protected[1]](d.yaw_jitter_range_t,false)ui[protected[1]](d.yaw_jitter_range_left_t,false)ui[protected[1]](d.yaw_jitter_range_right_t,false)ui[protected[1]](d.body_yaw_t,false)ui[protected[1]](d.body_yaw_add_t,false)ui[protected[1]](d.fake_yaw_limit_t,false)elseif ui.get(team_mode)=="terrorist"then ui[protected[1]](d.yaw_left_l_t,c)ui[protected[1]](d.yaw_left_t,c)ui[protected[1]](d.yaw_left_r_t,c)ui[protected[1]](d.yaw_right_t,c)ui[protected[1]](d.yaw_jitter_t,c)ui[protected[1]](d.yaw_jitter_range_t,c and ui.get(d.yaw_jitter_t)~="off"and not ui.get(d.yaw_jitter_t):find("l & r"))ui[protected[1]](d.yaw_jitter_range_left_t,c and ui.get(d.yaw_jitter_t)~="off"and ui.get(d.yaw_jitter_t):find("l & r"))ui[protected[1]](d.yaw_jitter_range_right_t,c and ui.get(d.yaw_jitter_t)~="off"and ui.get(d.yaw_jitter_t):find("l & r"))ui[protected[1]](d.body_yaw_t,c)ui[protected[1]](d.body_yaw_add_t,c and ui.get(d.body_yaw_t)~="off"and ui.get(d.body_yaw_t)~="opposite")ui[protected[1]](d.fake_yaw_limit_t,c and ui.get(d.body_yaw_t)~="off")ui[protected[1]](d.yaw_left_l,false)ui[protected[1]](d.yaw_left_r,false)ui[protected[1]](d.yaw_left,false)ui[protected[1]](d.yaw_right,false)ui[protected[1]](d.yaw_jitter,false)ui[protected[1]](d.yaw_jitter_range,false)ui[protected[1]](d.yaw_jitter_range_left,false)ui[protected[1]](d.yaw_jitter_range_right,false)ui[protected[1]](d.body_yaw,false)ui[protected[1]](d.body_yaw_add,false)ui[protected[1]](d.fake_yaw_limit,false)end else ui[protected[1]](d.yaw_left_l,false)ui[protected[1]](d.yaw_left_r,false)ui[protected[1]](d.yaw_left,false)ui[protected[1]](d.yaw_right,false)ui[protected[1]](d.yaw_jitter,false)ui[protected[1]](d.yaw_jitter_range,false)ui[protected[1]](d.yaw_jitter_range_left,false)ui[protected[1]](d.yaw_jitter_range_right,false)ui[protected[1]](d.body_yaw,false)ui[protected[1]](d.body_yaw_add,false)ui[protected[1]](d.fake_yaw_limit,false)ui[protected[1]](d.yaw_left_l_t,false)ui[protected[1]](d.yaw_left_r_t,false)ui[protected[1]](d.yaw_left_t,false)ui[protected[1]](d.yaw_right_t,false)ui[protected[1]](d.yaw_jitter_t,false)ui[protected[1]](d.yaw_jitter_range_t,false)ui[protected[1]](d.yaw_jitter_range_left_t,false)ui[protected[1]](d.yaw_jitter_range_right_t,false)ui[protected[1]](d.body_yaw_t,false)ui[protected[1]](d.body_yaw_add_t,false)ui[protected[1]](d.fake_yaw_limit_t,false)ui[protected[1]](team_mode,false)end end

    local show_visuals = show and ui.get(tabs) == "visuals"
    ui[protected[1]](enable_indicators, show_visuals)
    ui[protected[1]](enable_notif, false)
    ui[protected[1]](enable_arrows, false)

    if ui.get(enable_arrows) then
        ui[protected[1]](arrow_ms, false)
    else
        ui[protected[1]](arrow_ms, false)
    end

    if ui.get(enable_notif) and show_visuals then
        ui[protected[1]](notif_style, true)
        ui[protected[1]](notifs, true)
    else
        ui[protected[1]](notif_style, false)
        ui[protected[1]](notifs, false)
    end

    if ui.get(enable_notif) and contains(ui.get(notifs), "size")and show_visuals then
        ui[protected[1]](notif_size, true)
    else
        ui[protected[1]](notif_size, false)
    end

    if ui.get(enable_notif) and contains(ui.get(notifs), "speed")and show_visuals then
        ui[protected[1]](notif_speed, true)
    else
        ui[protected[1]](notif_speed, false)
    end

    if ui.get(enable_notif) and contains(ui.get(notifs), "glow") and show_visuals then
        ui[protected[1]](notif_glow, true)
    else
        ui[protected[1]](notif_glow, false)
    end

    if ui.get(enable_notif) and contains(ui.get(notifs), "prefix") and show_visuals then
        ui[protected[1]](notif_prefix, true)
    else
        ui[protected[1]](notif_prefix, false)
    end

    if ui.get(enable_notif) and contains(ui.get(notifs), "bg color") and show_visuals then
        ui[protected[1]](notif_color, true)
    else
        ui[protected[1]](notif_color, false)
    end

    if show_visuals and ui.get(enable_indicators) then
        ui[protected[1]](indicators, true)
    else
        ui[protected[1]](indicators, false)
    end

    ui[protected[1]](reference.fl_limit, not show)
    ui[protected[1]](menu.fl_limit, show)
end

function menu:show_og()ui[protected[1]](reference.enabled,true)ui[protected[1]](reference.pitch,true)ui[protected[1]](reference.yaw_base,true)ui[protected[1]](reference.yaw[1],true)ui[protected[1]](reference.yaw[2],true)ui[protected[1]](reference.yaw_jitter[1],true)ui[protected[1]](reference.yaw_jitter[2],true)ui[protected[1]](reference.body_yaw[1],true)ui[protected[1]](reference.body_yaw[2],true)ui[protected[1]](reference.freestanding_body_yaw,true)ui[protected[1]](reference.fake_yaw_limit,true)ui[protected[1]](reference.edge_yaw,true)ui[protected[1]](reference.freestanding[1],true)ui[protected[1]](reference.freestanding[2],true)ui[protected[1]](reference.roll,true)ui[protected[1]](reference.fl_limit,true)end

register("shutdown", function () menu:show_og() end)
register(protected[5], function () menu:visibility() end)

local function color_log(text, r,g,b)
    client.color_log(r,g,b, "zov-yaw \0")
    client.color_log(110, 110, 110, "~ \0")
    client.color_log(200,200,200, text)
end

ui.update(config_list, get_config_list())
--ui.set(config_name, #database.read(amnesia.database.configs) == 0 and "" or database.read(amnesia.database.configs)[ui.get(config_list)+1].name)
ui.set_callback(config_list,function(a)local b=""local c=get_config_list()local d=function()b=c[ui.get(a)+1]or""ui.set(config_name,b)end;if pcall(d)then color_log("configs fetched [success]",227,189,255)else color_log("configs fetched [failed..]",227,189,255)end end)
ui.set_callback(config_load,function()local a=ui.get(config_name)if a==""then return end;local b=function()load_config(a)end;if pcall(b)then print("loaded config - "..a)else print("failed to load config")end end)
ui.set_callback(config_save,function()local a=ui.get(config_name)if a==""then return end;if a:match("[^%w]")~=nil then print("contains not allowed letters ^%w")return end;local b=function()save_config(a)end;if pcall(b)then ui.update(config_list,get_config_list())print("saved the config - "..a)else print("failed to save the config - "..a)end end)
ui.set_callback(config_delete,function()local a=ui.get(config_name)if a==""then return end;if delete_config(a)==false then print("failed to delete")ui.update(config_list,get_config_list())return end;local b=function()delete_config(a)end;if pcall(b)then ui.update(config_list,get_config_list())ui.set(config_list,#amnesia.presets+#database.read(amnesia.database.configs)-#database.read(amnesia.database.configs))ui.set(config_name,#database.read(amnesia.database.configs)==0 and""or get_config_list()[#amnesia.presets+#database.read(amnesia.database.configs)-#database.read(amnesia.database.configs)+1])print("deleted config - "..a)else print("failed to delete config - "..a)end end)
ui.set_callback(config_import,function()local a=function()import_settings(clipboard.get())end;if pcall(a)then print("imported")else print("failed import")end end)
ui.set_callback(config_export,function()local a=function()export_settings()end;if pcall(a)then print("exported")else print("failed export")end end)

local state = {
    ground_timer = 0,
    lag_timer = 0
}

function state:fakelag()local a=ui.get(reference.dt[1])and ui.get(reference.dt[2])local b=ui.get(reference.on_shot_aa[1])and ui.get(reference.on_shot_aa[2])local c=ui.get(reference.fake_duck)if a or b or c then return false else return true end end

function state:in_air(a)if not a then return false end;local b=entity.get_prop(a,"m_fFlags")local c=bit.band(b,1)~=0;if c then if self.ground_timer==5 then return false end;self.ground_timer=self.ground_timer+1 else self.ground_timer=0 end;return true end

local vector = require('vector')

local lerp = function(a, b, percentage)
    return a + (b - a) * percentage
end

local screen_size = function()
    return vector(client.screen_size())
end

local measure_text = function(flags, ...)
    local args = {...}
    local string = table.concat(args, "")

    return vector(renderer.measure_text(flags, string))
end

local notify = {
    notifications = {
        bottom = {}
    },
    max = {
        bottom = 6
    }
}

notify.__index = notify

notify.queue_bottom = function()
    if #notify.notifications.bottom <= notify.max.bottom then
        return 0
    end

    return #notify.notifications.bottom - notify.max.bottom
end

notify.clear_bottom = function()
    for i = 1, notify.queue_bottom() do
        table.remove(notify.notifications.bottom, #notify.notifications.bottom)
    end
end

notify.new_bottom = function(timeout, color, ...)
    table.insert(notify.notifications.bottom, {
        started = false,
        instance = setmetatable({
            active  = false,
            timeout = timeout,
            color   = { r = color[1], g = color[2], b = color[3], a = 0 },
            x       = screen_size().x / 2,
            y       = screen_size().y,
            text    = ...,
        }, notify)
    })
end

function notify:handler()
    local bottom_count = 0
    local bottom_visible_amount = 0

    for index, notification in pairs(notify.notifications.bottom) do
        if not notification.instance.active and notification.started then
            table.remove(notify.notifications.bottom, index)
        end
    end

    for i = 1, #notify.notifications.bottom do
        if notify.notifications.bottom[i].instance.active then
            bottom_visible_amount = bottom_visible_amount + 1
        end
    end

    for index, notification in pairs(notify.notifications.bottom) do
        if index > notify.max.bottom then
            goto skip
        end

        if notification.instance.active then
            notification.instance:render_bottom(bottom_count, bottom_visible_amount)
            bottom_count = bottom_count + 1
        end

        if not notification.started then
            notification.instance:start()
            notification.started = true
        end
    end

    ::skip::
end

function notify:start()
    self.active = true
    self.delay = globals.realtime() + self.timeout
end

function notify:get_text()
    local text = ''

    for i, curr_text in pairs(self.text) do
        local text_size = measure_text('', curr_text[1])

        local r, g, b = 255, 255, 255--ui.get(color3)

        if curr_text[2] then
            r, g, b = self.color.r, self.color.g, self.color.b--ui.get(color3)
        end

        text = text .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, self.color.a, curr_text[1]) .. ' '
    end

    return text
end

local m_render = (function()
    local A = {}

    A.rec = function(x, y, w, h, r, g, b, a, radius)
        radius = math.min(x/2, y/2, radius)
        renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
        renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, .25)
        renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, .25)
        renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, .25)
        renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, .25)
    end

    A.rec_outline = function(x, y, w, h, r, g, b, a, radius, thickness)
        radius = math.min(w/2, h/2, radius)
        if radius == 1 then
            renderer.rectangle(x, y, w, thickness, r, g, b, a)
            renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
        else
            renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
            renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
            renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
            renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
            renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, .25, thickness)
            renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, .25, thickness)
            renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, .25, thickness)
            renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, .25, thickness)
        end
    end

    A.glow_module_notify = function(x, y, w, h, width, rounding, cr, cg, cb, ca, g_cr, g_cg, g_cb, g_ca, show)
        local thickness = 1
        local offset = 1
        if show then
            A.rec(x , y, w, h, cr, cg, cb, ca, rounding)
            --renderer.blur(x , y, w, h)
            --m_render.rec_outline(x + width*thickness - width*thickness, y + width*thickness - width*thickness, w - width*thickness*2 + width*thickness*2, h - width*thickness*2 + width*thickness*2, color(r, g, b, 255), rounding, thickness)
        end
        for k = 0, width do
            local a = ca / 2 * (k/width) ^ 3
            A.rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h - (k - width - offset)*thickness*2, g_cr, g_cg, g_cb, a / 1.5, rounding + thickness * (width - k + offset), thickness)
        end
    end

    return A
end)()

function notify:render_bottom(index, visible_amount)
    local screen = screen_size()

    local prefix_style = ui.get(notif_prefix)

    local prefix_padding = 6
    local prefix_size = measure_text('c', prefix_style)
    
    if prefix_style == 'icon' then
        prefix_size = vector(zov_icon_small:measure() - 990)
    end

    local text = self:get_text()
    local text_size = measure_text('', text)
    
    local glow_steps = 8
    local padding = 5
    local text_width = prefix_size.x + prefix_padding + text_size.x
    local w, h = text_width + padding * 2, 12 + 10 + 1--ui.get(notif_size)
    local x, y = self.x - w / 2, math.ceil(self.y - 40 + .4)
    local frametime = globals.frametime()

    if globals.realtime() < self.delay then
        self.y = lerp(self.y, (screen.y - 45) - ((visible_amount - index) * h * 1.4), frametime * 7)
        self.color.a = lerp(self.color.a, 255, frametime * 2)
    else
        self.y = lerp(self.y, self.y - 10, frametime * 15)
        self.color.a = lerp(self.color.a, 0, frametime * 20)

        if self.color.a <= 1 then
            self.active = false
        end
    end

    local r, g, b, a = self.color.r, self.color.g, self.color.b, self.color.a

    m_render.glow_module_notify(x, y, w, h, 15, glow_steps, 25, 25, 25, a, r, g, b, a, true)

    local offset = padding + 2

    if prefix_style == "icon" and zov_icon_small then
        local color = { 255, 255, 255 }
        
        zov_icon_small:draw(x + offset - 5, y, nil, 24 + ui.get(notif_size), color[1], color[2], color[3], a, true, "f")
        offset = offset + prefix_size.x + prefix_padding
    else
        renderer.text(x + offset, y + h / 2 - prefix_size.y / 2, r, g, b, a, 'b', nil, prefix_style)
        offset = offset + prefix_size.x + prefix_padding
    end

    renderer.text(x + offset, y + h / 2 - text_size.y / 2, r, g, b, a, '', nil, text)
end

local load_a = 0
local load_a2 = 0
local draw = true
local welcome = false

client.delay_call(1, function()
    local r,g,b = ui.get(color3)
    notify.new_bottom(5, { r,g,b }, {
        { 'welcome to' },
        { 'zov-yaw', true },
        { '~ '..username() },
        { '~ '..build(), true },
        { '!' },
    })
end)

function state:is_moving(ent)
    local velocity = vector(entity.get_prop(ent, "m_vecVelocity"))
    return math.sqrt(velocity.x * velocity.x + velocity.y * velocity.y) > 2
end

function state:is_crouching(ent)
    local ducked = entity.get_prop(ent, "m_bDucked")
    return ducked == 1
end

function state:team_number(ent)
	local team_num = entity.get_prop(ent, "m_iTeamNum")
	return team_num
end

function state:get_state(ent)
    local is_moving = self:is_moving(ent)
    local is_crouching = self:is_crouching(ent)
    local in_air = self:in_air(ent)

    if state:fakelag() then
        return "fakelag"
    end

    if ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2]) then
        return "slow"
    end

    if in_air then
        if is_crouching then
            return "air crouch"
        end

        return "air"
    end

    if is_crouching then
        return "crouch"
    end

    if is_moving then
        return "run"
    end

    if not is_moving then
        return "stand"
    end

    return "none"
end

local lastmiss = 0

local function GetClosestPoint(A, B, P)
    a_to_p = { P[1] - A[1], P[2] - A[2] }
    a_to_b = { B[1] - A[1], B[2] - A[2] }

    atb2 = a_to_b[1]^2 + a_to_b[2]^2

    atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    t = atp_dot_atb / atb2

    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end

local bruteforce_reset = true
local stage = 0
local shot_time = 0

local vect = require "vector"

local preset_data = {}

local presets_list = {}

local function addpreset(state, preset, reset)
    if reset then
        presets_list[state] = {} -- remove the default, as we added custom one
    end
    presets_list[state][#presets_list[state]+1] = preset
end

for i, v in next, {"stand","run","slow","crouch","air","air crouch","fakelag"} do
    presets_list[v] = {}
    preset_data[v] = {}
    addpreset(v, {-10, 10, 75, 75}) -- default
end

addpreset("air crouch", {10, 18, 39, 46}, true)
addpreset("air", {-5, 15, 25, 30}, true)
addpreset("stand", {3, 13, 45, 41}, true)
addpreset("run", {-10, 15, 52, 46}, true)
addpreset("crouch", {-7, 9, 49, 52}, true)

client.set_event_callback("bullet_impact", function(e)

    if not entity.is_alive(entity.get_local_player()) then return end
    local ent = client.userid_to_entindex(e.userid)
    if ent ~= client.current_threat() then return end
    if entity.is_dormant(ent) or not entity.is_enemy(ent) then return end

    local ent_origin = { entity.get_prop(ent, "m_vecOrigin") }
    ent_origin[3] = ent_origin[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
    local local_head = { entity.hitbox_position(entity.get_local_player(), 1) }
    local closest = GetClosestPoint(ent_origin, { e.x, e.y, e.z }, local_head)
    local delta = { local_head[1]-closest[1], local_head[2]-closest[2] }
    local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)

    local inverted = (math.floor(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60))

    local r,g,b,a = ui.get(color3)

    local col = rgba_to_hex(r,g,b,a)
    local state = aa_lol.state

    if math.abs(delta_2d) <= 75 and globals.curtime() - lastmiss > 0.015 then
        local preset = client.random_int(1,#presets_list[state])
        preset_data[state][ent] = presets_list[state][client.random_int(preset)] -- select a new preset
    end

    if not ui.get(antiaim_mode) == "zov-mode" then return nil end
    if bruteforce then return nil end
    if math.abs(delta_2d) <= 75 and globals.curtime() - lastmiss > 0.015 then

        notify.new_bottom(5, { r,g,b }, {
            { "changed [" },
            { "zov-mode", true },
            { "] due to bullet from" },
            { entity.get_player_name(ent):lower(), true },
        })
        lastmiss = globals.curtime()
        bruteforce = true
        shot_time = globals.realtime()
        stage = stage >= 3 and 0 or stage + 1
        stage = stage == 0 and 1 or stage
    end
end)

local function Returner()
    brut3 = true

    return brut3
end

function aa_lol:bruteforce (cmd)
    local r,g,b,a = ui.get(color3)

    local col = rgba_to_hex(r,g,b,a)
    if bruteforce then
        client.set_event_callback("paint_ui", Returner)
        bruteforce = false
        bruteforce_reset = false
        stage = stage == 0 and 1 or stage
        set_brute = true
    else
        if shot_time + 3 < globals.realtime()
        then
            client.unset_event_callback("paint_ui", Returner)
            set_brute = false
            brut3 = false
            stage = 0
            bruteforce_reset = true
            set_brute = false
        end
    end
    return shot_time
end

function aa_lol:handle_yaw(left, right, cmd)

    if pcall(cmd.chokedcommands ~= 0) then return end

    if self.delta > 0 then
        return left
    else
        return right
    end
end

local export_button = ui.new_button(protected[6], protected[8], "export current state", function()
    local condition = ui.get(antiaim_condition)
    local team = ui.get(team_mode)
    local cfg = {
        [condition] = {}
    }
    for setting_name, setting_value in pairs(menu.builder_elements[condition]) do
        if team == "counterterrorist" then
            if not setting_name:find("_t") then
                setting_name = setting_name .. "_t"
            else
                goto skip
            end
        else
            if setting_name:find("_t") then
                setting_name = setting_name:gsub("_t", "")
            else
                goto skip
            end
        end
        cfg[condition][setting_name] = ui.get(setting_value)
        ::skip::
    end
    clipboard.set(json.stringify(cfg))

end)

local export_button_abf = ui.new_button(protected[6], protected[8], "export current state", function()
    local condition = ui.get(antiaim_condition)
    local team = ui.get(team_mode_abf)
    local cfg = {
        [condition] = {}
    }
    for setting_name, setting_value in pairs(menu.abf_elements[condition]) do
        if team == "counterterrorist" then
            if not setting_name:find("_t") then
                setting_name = setting_name .. "_t"
            else
                goto skip
            end
        else
            if setting_name:find("_t") then
                setting_name = setting_name:gsub("_t", "")
            else
                goto skip
            end
        end
        print(ui.name(setting_value))
        cfg[condition][setting_name] = ui.get(setting_value)
        ::skip::
    end
    clipboard.set(json.stringify(cfg))

end)

local import_button_abf = ui.new_button(protected[6], protected[8], "import", function()
    local cfg_string = clipboard.get()
    if not pcall(function() json.parse(cfg_string) end) then
        error("Invalid config format!")
        return
    end
    local cfg = json.parse(cfg_string)
    local input = ""
    local team = ""
    for condition, settings in pairs(cfg) do
        input = condition
        for setting_name, setting_value in pairs(settings) do
            if team == "" then
                if setting_name:find("_t") then
                    team = "terrorist"
                else
                    team = "counterterrorist"
                end
            end
            ui.set(menu.abf_elements[condition][setting_name], setting_value)
        end
    end
end)

local import_button = ui.new_button(protected[6], protected[8], "import", function()
    local cfg_string = clipboard.get()
    if not pcall(function() json.parse(cfg_string) end) then
        error("Invalid config format!")
        return
    end
    local cfg = json.parse(cfg_string)
    local input = ""
    local team = ""
    for condition, settings in pairs(cfg) do
        input = condition
        for setting_name, setting_value in pairs(settings) do
            if team == "" then
                if setting_name:find("_t") then
                    team = "terrorist"
                else
                    team = "counterterrorist"
                end
            end
            ui.set(menu.builder_elements[condition][setting_name], setting_value)
        end
    end
end)

local function color_log(text, r,g,b)
    client.color_log(r,g,b, "zov-yaw \0")
    client.color_log(110, 110, 110, "~ \0")
    client.color_log(200,200,200, text)
end

local function handle_buttons()
    local show_aa = ui.get(tabs) == "anti.aim"
    if ui.get(antiaim_mode) == "custom" and show_aa then
        ui[protected[1]](export_button, true)
        ui[protected[1]](import_button, true)
    else
        ui[protected[1]](export_button, false)
        ui[protected[1]](import_button, false)
    end

    if ui.get(antiaim_mode) == "anti-bruteforce" and show_aa then
        ui[protected[1]](export_button_abf, true)
        ui[protected[1]](import_button_abf, true)
    else
        ui[protected[1]](export_button_abf, false)
        ui[protected[1]](import_button_abf, false)
    end
end

client.set_event_callback(protected[5], handle_buttons)

local jitter = not jitter
local r_jit = not r_jit
local r_jit2 = not r_jit2
local jitter2 = not jitter2
local jitter3 = not jitter3
local send = false
local anti_aim_f = require('gamesense/antiaim_funcs')

local vector = require "vector"

n_cache = {
    nade = 0,
    on_ladder = false,
    holding_nade = false
}

local run_command_check = function()
    local me = entity.get_local_player()
    if me == nil then return end

    n_cache.on_ladder = entity.get_prop(me, "m_MoveType") == 9
end

local nade_check = function(weapon, cmd)
    local pin_pulled = entity.get_prop(weapon, "m_bPinPulled")
    if pin_pulled ~= nil then
        if pin_pulled == 0 or cmd.in_attack == 1 or cmd.in_attack2 == 1 then
            local throw_time = entity.get_prop(weapon, "m_fThrowTime")
            if throw_time ~= nil and throw_time > 0 and throw_time < globals.curtime() then
                return true
            end
        end
    end
    return nil
end

local can_desync = function(cmd, ent, count, vel)
    if ui.get(freestanding_key) then return end

    local weapon = entity.get_player_weapon(ent)
    if weapon == nil then return end
    local srv_time = entity.get_prop(ent, "m_nTickBase") * globals.tickinterval()
    local wpnclass = entity.get_classname(weapon)

    if wpnclass:find("Grenade") == nil and cmd.in_attack == 1 and srv_time > entity.get_prop(weapon, "m_flNextPrimaryAttack") - 0.1 then return end

    if nade_check(weapon, cmd) then return end

    if entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1 then return false end

    if n_cache.on_ladder then return false end
    if cmd.in_use == 1 then return false end

    return true
end

client.set_event_callback("run_command", function()
    run_command_check()
end)

local calc_angle = function(local_pos, enemy_pos)
    local ydelta = local_pos.y - enemy_pos.y
    local xdelta = local_pos.x - enemy_pos.x
    local relativeyaw = math.atan(ydelta / xdelta)
    relativeyaw = anti_aim_f.normalize_angle(relativeyaw * 180 / math.pi)
    if xdelta >= 0 then
        relativeyaw = anti_aim_f.normalize_angle(relativeyaw + 180)
    end
    return relativeyaw
end

local var_table = {};

local prev_simulation_time = 0


local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end
local diff_sim = 0
function var_table:sim_diff() 
    local current_simulation_time = time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
end

sim_time_dt = 0
to_draw = "no"
to_up = "no"
to_draw_ticks = 0
go_ = "no"
recharge_def = "no"
def_inds = 0

local function desync_func(desync, cmd, state, yaw, yaw2, angle, enemy_pos, local_player_pos, delta)
    if desync then

        cmd.allow_send_packet = false

        if cmd.chokedcommands == 0 then
            if jitter then
                --print(math.abs(delta))
                if math.abs(delta) < 28.21 then
                    recharge_def = "yes"
                    jitter = not jitter
                    jitter2 = not jitter2
                else
                    recharge_def = "no"
                end
            end
            jitter = not jitter
            jitter2 = not jitter2
            if stage == 0 then
                angle = angle + (jitter and yaw or yaw2)
            elseif stage == 1 then
                angle = angle + (jitter2 and yaw or yaw2)
            end
        else
            if cmd.chokedcommands > 1 then
                angle = angle + (globals.tickcount() % 10 > 5 and yaw or yaw2)
            else
                jitter3 = not jitter3
                angle = angle + (jitter3 and 40 or -40)
            end
        end

        if enemy_pos.x ~= 0 then
            if state == 0 then
                cmd.yaw = ({client.camera_angles()})[2] + enemy_pos.x ~= 0 and calc_angle(local_player_pos, enemy_pos) - angle
            else
                cmd.yaw = ({client.camera_angles()})[2] + angle
            end
        else
            cmd.yaw = ({client.camera_angles()})[2] + angle
        end

        cmd.pitch = 89 --customize maybe?
    end
end

local function temp_fix(delta, cmd)
    if cmd.chokedcommands == 0 then
        if jitter then
            --print(math.abs(delta))
            if math.abs(delta) < 20.21 then
                    recharge_def = "yes"
            else
                recharge_def = "no"
            end
        end
    end
end

function defensive_indicator()

    X,Y = client.screen_size()
   
    local diff_mmeme = var_table.sim_diff()

    if recharge_def == "yes" and contains(ui.get(miscs), "recharge def on bad cycle") or recharge_def == "yes" and contains(ui.get(miscs), "break def in air") then
        to_draw = "yes"
        to_up = "yes"
        go_ = "yes"
    end
end

local pop_up = {
    icon_w = -12,
    text_size = 1,
    text_size_2 = 1,
    bar_y = 160,
    bar_y_2 = 161,
    bar_lenght = 0,
    bar_alpha = 0
}

local to_draw_ticks = 0

local cached = 0
local yaw_cache = 0
local yaw_t_cache = 0

function aa_lol:preset_manager(left, right, l_jitter, r_jitter, jitter_mode, fake, cmd)

    local yaw_sweaty_test = yaw_cache 
    if cmd.chokedcommands == 0 then
        yaw_sweaty_test = self.delta > 0 and left or right
    end

    yaw_cache = yaw_sweaty_test

    yaw_add = yaw_sweaty_test

    if self.manual_state == 1 then
        yaw_add = -90
    elseif self.manual_state == 2 then
        yaw_add = 90
    elseif self.manual_state == 3 then
        yaw_add = 180
    end

    local yaw_sweaty_test_jit = cached 
    if cmd.chokedcommands == 0 then
        yaw_sweaty_test_jit = self.delta > 0 and l_jitter or r_jitter
    end
 
    cached = yaw_sweaty_test_jit

    local yaw_base = self.manual_state == 0 and "at targets" or "local view"

    ui.set(reference.pitch, "minimal")
    ui.set(reference.yaw_base, yaw_base)
    ui.set(reference.yaw[1], "180")
    ui.set(reference.yaw[2], yaw_add)
    ui.set(reference.yaw_jitter[1], jitter_mode)
    ui.set(reference.yaw_jitter[2], yaw_sweaty_test_jit)
    ui.set(reference.body_yaw[1], "jitter")
    ui.set(reference.body_yaw[2], 0)
    ui.set(reference.fake_yaw_limit, fake)
end

local timer = 0
local destination = 0
local dtmode = "defensive"
local enemy_cache = 0

function aa_lol:aa(lp, cmd)

    temp_fix(self.delta, cmd)

    self.choked = cmd.chokedcommands

    local state = state:get_state(lp)

    self.state = state

    if state == "none" then return end

    local builder = menu.builder_elements[state]

    local yaw_base = self.manual_state == 0 and "at targets" or "local view"

    if cmd.weaponselect ~= 0 then
        destination = ((cmd.weaponselect/2)-128)-64
        timer = 0
    end

    dtmode = "defensive"

    if destination > timer then
        timer = timer + 1
        dtmode = "offensive"
    end

    local dt_mode = ui.reference("rage", "other", "double tap mode")

    local yaw = "180"

    local bodyyaw = "jitter"
    local yawjit = "center"

    local team_num = entity.get_prop(lp, "m_iTeamNum")

    if ui.get(antiaim_mode) == "zov-mode" then
        local me = entity.get_local_player()

        local enemy = client.current_threat()

        if enemy == nil then
            enemy = me
        end

        enemy_cache = enemy

        if preset_data[state][enemy] == nil then -- first preset generate
            preset_data[state][enemy] = presets_list[state][client.random_int(1,#presets_list[state])]
        end

        local getpreset = preset_data[state][enemy] -- returns {-10, 10, 75}

        if me == nil then return end

        cmd.force_defensive = cmd.command_number % (3+1) ~= 0 and not cmd.no_choke

        --else electus thing
         --   arg.force_defensive = (arg.quick_stop or arg.weaponselect ~= 0) or (ui.get(menutbl.defensive) == "Always")
        --end

        if ui.get(freestanding_key) then
            ui.set(reference.pitch, "minimal")
            ui.set(reference.yaw_base, yaw_base)
            ui.set(reference.yaw[1], yaw)
            ui.set(reference.yaw[2], 0)
            ui.set(reference.yaw_jitter[1], "off")
            ui.set(reference.yaw_jitter[2], 0)
            ui.set(reference.body_yaw[1], "static")
            ui.set(reference.body_yaw[2], 0)
            ui.set(reference.fake_yaw_limit, 60)
        elseif ui.get(random_breaker) and self.state ~= "fakelag" then
            ui.set(reference.pitch, "minimal")
            ui.set(reference.yaw_base, yaw_base)
            ui.set(reference.yaw[1], yaw)
            ui.set(reference.yaw[2], math.random(-180,180))
            ui.set(reference.yaw_jitter[1], "off")
            ui.set(reference.yaw_jitter[2], 0)
            ui.set(reference.body_yaw[1], "jitter")
            ui.set(reference.body_yaw[2], 0)
            ui.set(reference.fake_yaw_limit, 60)
        elseif self.manual_state == 1 or self.manual_state == 2 or self.manual_state == 3 then
            if self.manual_state == 1 then
                yaw_add = -90
            elseif self.manual_state == 2 then
                yaw_add = 90
            elseif self.manual_state == 3 then
                yaw_add = 180
            end
            ui.set(reference.pitch, "minimal")
            ui.set(reference.yaw_base, yaw_base)
            ui.set(reference.yaw[1], yaw)
            ui.set(reference.yaw[2], yaw_add)
            ui.set(reference.yaw_jitter[1], "off")
            ui.set(reference.yaw_jitter[2], 0)
            ui.set(reference.body_yaw[1], "static")
            ui.set(reference.body_yaw[2], 0)
            ui.set(reference.fake_yaw_limit, 60)
        else
            aa_lol:preset_manager(getpreset[1], getpreset[2], getpreset[3], getpreset[4], "center", 60, cmd)
        end
    elseif ui.get(antiaim_mode) == "custom" then

        local left = ui.get(builder.yaw_left)
        local right = ui.get(builder.yaw_right)
        local yaw_sweaty_test = yaw_cache 
        if cmd.chokedcommands == 0 then
            yaw_sweaty_test = self.delta > 0 and left or right
        end

        --print(yaw_sweaty_test)

        yaw_cache = yaw_sweaty_test

        --yaw_add = self:handle_yaw(ui.get(builder.yaw_left), ui.get(builder.yaw_right),cmd)
        yaw_add = yaw_sweaty_test

        if self.manual_state == 1 then
            yaw_add = -90
        elseif self.manual_state == 2 then
            yaw_add = 90
        elseif self.manual_state == 3 then
            yaw_add = 180
        end

        local left_t = ui.get(builder.yaw_left_t)
        local right_t = ui.get(builder.yaw_right_t)
        local yaw_sweaty_test_t = yaw_t_cache
        if cmd.chokedcommands == 0 then
            yaw_sweaty_test_t = self.delta > 0 and left_t or right_t
        end

        yaw_t_cache = yaw_sweaty_test_t

        yaw_add_t = yaw_sweaty_test_t

        if self.manual_state == 1 then
            yaw_add_t = -90
        elseif self.manual_state == 2 then
            yaw_add_t = 90
        elseif self.manual_state == 3 then
            yaw_add_t = 180
        end

        local left_jitter = ui.get(builder.yaw_jitter_range_left)
        local right_jitter = ui.get(builder.yaw_jitter_range_right)
        local yaw_sweaty_test_jit = cached 
        if cmd.chokedcommands == 0 then
            yaw_sweaty_test_jit = self.delta > 0 and left_jitter or right_jitter
        end

        cached = yaw_sweaty_test_jit

        local yaw_jitter = ui.get(builder.yaw_jitter):find("l & r") and (ui.get(builder.yaw_jitter):find("center") and "center" or "offset") or ui.get(builder.yaw_jitter)
        local yaw_jitter_range = ui.get(builder.yaw_jitter):find("l & r") and yaw_sweaty_test_jit or ui.get(builder.yaw_jitter_range)

        local yaw_jitter_t = ui.get(builder.yaw_jitter_t):find("l & r") and (ui.get(builder.yaw_jitter_t):find("center") and "center" or "offset") or ui.get(builder.yaw_jitter_t)
        local yaw_jitter_range_t = ui.get(builder.yaw_jitter_t):find("l & r") and self:handle_yaw(ui.get(builder.yaw_jitter_range_left_t), ui.get(builder.yaw_jitter_range_right_t),cmd) or ui.get(builder.yaw_jitter_range_t)

        local body_yaw = ui.get(builder.body_yaw)
        local body_yaw_add = ui.get(builder.body_yaw_add)

        local body_yaw_t = ui.get(builder.body_yaw_t)
        local body_yaw_add_t = ui.get(builder.body_yaw_add_t)

	    local fake_yaw_limit = ui.get(builder.fake_yaw_limit)
        local fake_yaw_limit_t = ui.get(builder.fake_yaw_limit_t)

        if ui.get(freestanding_key) then
            ui.set(reference.yaw_jitter[2], 0)
        elseif team_num == 3 then
            ui.set(reference.pitch, "minimal")
            ui.set(reference.yaw_base, yaw_base)
            ui.set(reference.yaw[1], yaw)
            ui.set(reference.yaw[2], yaw_add)
            ui.set(reference.yaw_jitter[1], yaw_jitter)
            ui.set(reference.yaw_jitter[2], yaw_sweaty_test_jit)
            ui.set(reference.body_yaw[1], body_yaw)
            ui.set(reference.body_yaw[2], body_yaw_add)
            ui.set(reference.fake_yaw_limit, fake_yaw_limit)

            ui.set(reference.roll, 0)
            ui.set(reference.freestanding_body_yaw, false)
        elseif team_num == 2 then
            ui.set(reference.pitch, "minimal")
            ui.set(reference.yaw_base, yaw_base)
            ui.set(reference.yaw[1], yaw)
            ui.set(reference.yaw[2], yaw_add_t)
            ui.set(reference.yaw_jitter[1], yaw_jitter_t)
            ui.set(reference.yaw_jitter[2], yaw_sweaty_test_jit)
            ui.set(reference.body_yaw[1], body_yaw_t)
            ui.set(reference.body_yaw[2], body_yaw_add_t)
            ui.set(reference.fake_yaw_limit, fake_yaw_limit_t)

            ui.set(reference.roll, 0)
            ui.set(reference.freestanding_body_yaw, false)
        end
    end
end

function aa_lol:on_shot()
    if ui.get(reference.on_shot_aa[1]) and ui.get(reference.on_shot_aa[2]) and not ui.get(reference.fake_duck) then
        ui.set(reference.fl_limit, 1)
    elseif ui.get(reference.fake_duck) then
        ui.set(reference.fl_limit, 13)
    else
        ui.set(reference.fl_limit, ui.get(menu.fl_limit))
    end
end

register(protected[4], function () aa_lol:on_shot() end)

function aa_lol:run(cmd)
    local lp = entity[protected[7]]()

    self.delta = math.max(-60, math.min(60, math.floor((entity.get_prop(entity.get_local_player(),"m_flPoseParameter", 11) or 0)*120-60+0.5)))
    if self.delta > 0 and self.delta > 60 then self.delta = 60 end
    if self.delta < 0 and self.delta < -60 then self.delta = -60 end

    self:aa(lp, cmd)
    self:bruteforce(cmd)

    local dt_mode = ui.reference("rage", "other", "double tap mode")

    local is_dt = ui.get(reference.dt[1]) and ui.get(reference.dt[2])

    local in_air = state:in_air(lp) 
    
    defensive_indicator()
end


register(protected[4], function (cmd) aa_lol:run(cmd) end)

local hotkeys = {
	manual_last_pressed = globals.realtime()
}

function hotkeys:run(cmd)

    local lp = entity[protected[7]]()

    local freestanding = ui.get(freestanding_key)

    local disablers = ui.get(freestanding_disablers)

    local in_air = state:in_air(lp)
    local is_moving = state:is_moving(lp)
    local is_crouching = state:is_crouching(lp)
    local is_slowwalking = ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2])
    local is_fake_ducking = ui.get(reference.fake_duck)

	--if ui.get(exploits) and ui.get(antiaim_mode) ~= "new" then
     --   if globals.tickcount() % (6) == 0 then
    --        cmd.force_defensive = true
    --    else
    --        cmd.force_defensive = false
    --    end
	--end

    if is_moving and not is_crouching and contains(disablers, "moving") and not in_air and self.manual_state == 0 then
        freestanding = false
    end

    if not is_moving and not is_crouching and not in_air and contains(disablers, "standing") and self.manual_state == 0 then
        freestanding = false
    end

    if in_air and contains(disablers, "in air") then
        freestanding = false
    end

    if is_crouching and not in_air and contains(disablers, "crouching") and not is_fake_ducking and self.manual_state == 0 then
        freestanding = false
    end

    if is_fake_ducking and contains(disablers, "fake duck") and self.manual_state == 0 then
        freestanding = false
    end

    if is_slowwalking and contains(disablers, "slowwalking") and self.manual_state == 0 then
        freestanding = false
    end

    ui.set(reference.freestanding[1], freestanding and "default" or "-")
    ui.set(reference.freestanding[2], "always on")

	local edge_yaw = ui.get(edge_yaw_key)

	ui.set(reference.edge_yaw, edge_yaw)

	ui.set(manual_left_key, "on hotkey")
	ui.set(manual_right_key, "on hotkey")
	ui.set(manual_forward_key, "on hotkey")

	local curtime = globals.realtime()

	if self.manual_last_pressed + 0.2 > curtime then return end

	if ui.get(manual_left_key) and aa_lol.manual_state ~= 1 then
		aa_lol.manual_state = 1
		self.manual_last_pressed = curtime
	elseif ui.get(manual_right_key) and aa_lol.manual_state ~= 2 then
		aa_lol.manual_state = 2
		self.manual_last_pressed = curtime
	elseif ui.get(manual_forward_key) and aa_lol.manual_state ~= 3 then
		aa_lol.manual_state = 3
		self.manual_last_pressed = curtime
	elseif ui.get(manual_left_key) or ui.get(manual_right_key) or ui.get(manual_forward_key) then
		aa_lol.manual_state = 0
		self.manual_last_pressed = curtime
	end
end


register(protected[4], function (cmd) hotkeys:run(cmd) end)

local animations = {}

function animations:static_legs(ent)
	local in_air = state:in_air(ent)
	if not in_air then return end
	entity.set_prop(ent, "m_flPoseParameter", 1, 6)
end

function animations:run()
	local player = entity.get_local_player()

    --self:leg_fucker(player)

end

register("pre_render", function () animations:run() end)

local animation = {}

function animation:new(x, value, time)
    if time == nil then
        time = 0.095;
    end

    time = time * (globals.frametime() * 175);

    return lerp(x, value, time);
end

local wt1 = 0
local wt2 = 2

local http = require('gamesense/http')
local images = require('gamesense/images')

local helpers = {
    colored_single_text = function(r1, g1, b1, a1, text, r2, g2, b2, a2)
        local output = ''

        output = ('\a%02x%02x%02x%02x%s\a%02x%02x%02x%02x'):format(r1, g1, b1, a1, text, r2, g2, b2, a2)

        return output
    end
}

local x,y = client.screen_size()
local width, height = client.screen_size()
local center_width = width/2
local center_height = height/2

local function lerp (start, vend, time)
    return start + (vend - start) * time
end

local amnesia_lerp = 0
local speed_mod = true

local function fade_col(col1, col2, speed)
    local r = math.floor(col1.r + (col2.r - col1.r) * speed)
    local g = math.floor(col1.g + (col2.g - col1.g) * speed)
    local b = math.floor(col1.b + (col2.b - col1.b) * speed)
    local a = math.floor(col1.a + (col2.a - col1.a) * speed)

    return { r = r, g = g, b = b, a = a }
end

local function to_hex(r, g, b, a)
    return string.format("%02x%02x%02x%02x", r, g, b, a)
end

local ease = require "gamesense/easing"
local aa = require "gamesense/antiaim_funcs"

local state_size_t = 0
local amnesia_a = 0

function pulsate(speed)
    return math.sin(math.abs(-math.pi + (globals.curtime() * speed) % (math.pi * 2))) * 255
end

local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end

local value = gram_create(0,7)

local test_pos_y = 0

local visuals = {
    indicators = {
        charge = 0,
        charge_col = { r = 255, g = 255, b = 255, a = 255 },
    },
    size = 0,
}

local entity2 = require "gamesense/entity"

local data = {
    last_sim_time = 0,
    defensive_active_until = 0,
    dt_charged = false,
}

local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end


local function on_setup_command (c)
    local player = entity2.get_local_player()

    local sim_time = time_to_ticks(player:get_prop("m_flSimulationTime"))
    local delta = sim_time - data.last_sim_time

    if data.dt_charged then
        if delta < 0 then
            data.defensive_active_until = globals.tickcount() + math.abs(delta)
        end
    
        data.last_sim_time = sim_time    
    end
end


client.set_event_callback("setup_command", on_setup_command)

local indicators_tb = {}

client.set_event_callback('indicator', function(indicator)
    if indicator.text == "DT" then
        data.dt_charged = (indicator.r == 255 and indicator.g == 255 and indicator.b == 255)
        if globals.tickcount() <= data.defensive_active_until then
            indicator.r = 132
            indicator.g = 196
            indicator.b = 20
        end
    end

    indicators_tb[#indicators_tb + 1] = indicator
end)

local dt_enable, dt_hotkey = ui.reference("RAGE", "Other", "Double tap")

client.set_event_callback('paint_ui', function()
    local h = select(2, client.screen_size())
    
    local starting = h - 350

    for index, indicator in pairs(indicators_tb) do index = index - 1 -- this is how you fix lua tables lol
        local width, height = renderer.measure_text('d+', indicator.text)
        local offset = index * (height + 8)

        local gradient_width = math.floor(width / 2)
        
        local y = starting - offset

        renderer.gradient(10                 , y, gradient_width, height + 4, 0, 0, 0, 0, 0, 0, 0, 50, true)
        renderer.gradient(10 + gradient_width, y, gradient_width, height + 4, 0, 0, 0, 50, 0, 0, 0, 0, true)
        renderer.text(20, y + 2, indicator.r, indicator.g, indicator.b, indicator.a, 'd+', 0, indicator.text)
    end

    indicators_tb = {}
end)

local charge = false
local dash_pos = 0
local dash_pos2 = 0
local dt_size = 0

function visuals:draw_center2()
    local local_player = entity.get_local_player()
    if not entity.is_alive(local_player) then return end

    local screen_size = vector(client.screen_size())

    local ind_height = 20

    local pos = { x = screen_size.x / 2, y = screen_size.y / 2 + ind_height }

    local color_ref = { ui.get(color3) }

    local color = { r = color_ref[1], g = color_ref[2], b = color_ref[3], a = color_ref[4] }

    local frametime = globals.frametime()

    local r, g, b, a = ui.get(color3)

    if data.dt_charged then
        charge = true
    end

    local dt_text = ""

    local dt_color = {r = 255, g = 255, b = 255, a= 255}

    if data.dt_charged and not (globals.tickcount() <= data.defensive_active_until) then
        dt_text = "READY"
        dt_color = {r = 160, g = 235, b = 136, a= 255}
        dt_size = lerp(dt_size, 50, globals.frametime() * 5)
    elseif globals.tickcount() <= data.defensive_active_until then
        dt_text = "ACTIVE"
        dt_color = {r = 135, g = 189, b = 255, a= 255}
        dt_size = lerp(dt_size, 60, globals.frametime() * 5)
    else
        dt_text = "WAIT"
        dt_size = lerp(dt_size, 14, globals.frametime() * 5)
        dt_color = {r = 255, g = 0, b = 0, a= 255}
    end

    --local charge = data.tickbase.shifting ~= 0

    local exploiting = (ui.get(reference.dt[1]) and ui.get(reference.dt[2])) or (ui.get(reference.on_shot_aa[1]) and ui.get(reference.on_shot_aa[2]))
    local inverted = (math.floor(math.min(60, (entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60)))) > 0
    local delta = math.floor(aa.get_desync(1))

    self.indicators.charge_col = fade_col(self.indicators.charge_col, dt_color, globals.frametime() * 9)

    local col = {
        on = { r = r, g = g, b = b, a = 255 },
        off = { r = 255, g = 255, b = 255, a = 100 },
        main = { r = r, g = g, b = b, a = 255 },
    }

    local hex = {
        on = "\a" .. to_hex(col.on.r, col.on.g, col.on.b, col.on.a),
        off = "\a" .. to_hex(col.off.r, col.off.g, col.off.b, col.off.a),
        charge = "\a" .. to_hex(self.indicators.charge_col.r, self.indicators.charge_col.g, self.indicators.charge_col.b, self.indicators.charge_col.a),
    }

    local offset = { x = 0, y = 0 }

    local scoped = entity.get_prop(local_player, 'm_bIsScoped') == 1

    local doubletap = ui.get(reference.dt[1]) and ui.get(reference.dt[2])

    local hideshots = ui.get(reference.on_shot_aa[1]) and ui.get(reference.on_shot_aa[2])

    local scope_fraction = ease.quad_in_out(amnesia_lerp, 0, 1, 1)
    amnesia_lerp = clamp(amnesia_lerp + (scoped and frametime * 2.5 or -frametime * 2.5), 0, 1)

    local text = "ZOV  " .. gradient_text_anim("NIGHTLY", r,g,b,255, r,g,b,255, 0, 0 )

    local ind_offset = 0

    local text_size = vector(renderer.measure_text('-', text))

    local state_size = vector(renderer.measure_text("-", aa_lol.state:upper():gsub("RUN", "RUNNING")))

    local scope_text = math.floor(-(text_size.x / 2) * (1 - scope_fraction) + 2 * scope_fraction)
    local scope_text2 = math.floor(-(state_size.x / 2 - 2) * (1 - scope_fraction) + 8 * scope_fraction)

    visuals.size = ease.quad_out(globals.frametime(), visuals.size, (state_size.x + 10) - visuals.size, 0.4)
    
    dash_pos = ease.quad_out(globals.frametime(), dash_pos, (scope_text2 - 5.9) - dash_pos, 0.15)
    dash_pos2 = ease.quad_out(globals.frametime(), dash_pos2, (scope_text2 + state_size.x - 1) - dash_pos2, 0.15)

    renderer.text(pos.x + scope_text, pos.y, 255, 255, 255, 255, '-', nil, text)

    renderer.text(pos.x + dash_pos, pos.y + 10, 255, 255, 255, 255, '-', nil, "-")

    renderer.text(pos.x + dash_pos2, pos.y + 10, 255, 255, 255, 255, '-', nil, "-")

    renderer.text(pos.x + scope_text2, pos.y + 10, 255, 255, 255, 255, '-', visuals.size, ("%s"):format((aa_lol.state:upper()):gsub("RUN", "RUNNING")))

    local modifier = entity.get_prop(local_player, "m_flVelocityModifier")
	if modifier == 1 then
        speed_mod = false
    else
        speed_mod = true
    end

    local items = {
        [1] = { active = ui.get(reference.dt[1]) and ui.get(reference.dt[2]), text = 'DT '..hex.charge..""..dt_text, color = { r = 255, g = 255, b = 255, a = 255 } },
        --[2] = { active = ui.get(reference.on_shot_aa[1]) and ui.get(reference.on_shot_aa[2]), text = 'HIDE', color = { r = 148, g = 171, b = 255, a = 255 } },
        --[3] = { active = ui.get(reference.forcesp), text = 'SAFE', color = { r = 255, g = 255, b = 255, a = 255 } },
        --[4] = { active = speed_mod, text = 'SLOW: '..math.floor(modifier*100).."%", color = { r = 255, g = 255, b = 255, a = 255 } },
        --[5] = { active = ui.get(reference.fake_duck), text = 'DUCK', color = { r = 255, g = 255, b = 255, a = 255 } }
    }

    for i, bind in ipairs(items) do
        local text_size = { renderer.measure_text('c-', bind.text) }

        local speed = globals.frametime() * 5
        local alpha = ease.quad_in_out(value[i], 0, 1, 1)
        value[i] = clamp(value[i] + (bind.active and speed or -speed), 0, 1)

        local adaptive_pos = (math.floor(text_size[1] / 2) * scope_fraction) + 3 * scope_fraction

        if alpha <= 0 then
            goto skip
        end

        self.indicators.charge_col.a = bind.color.a * alpha

        renderer.text(pos.x + adaptive_pos, pos.y + ind_offset + 25, bind.color.r, bind.color.g, bind.color.b, bind.color.a * alpha, 'c-', dt_size, bind.text)

        ind_offset = ind_offset + 10 * alpha
        test_pos_y = ind_offset
        ::skip::
    end
end

function visuals:run_indicators()
	self.screen_width, self.screen_height = client.screen_size()

    self.r, self.g, self.b = ui.get(color3)

    --if not ui.get(menu.enable_visuals) then return end

    local lp = entity[protected[7]]()

    if not lp or not entity.is_alive(lp) then return end

    if ui.get(indicators) == "chimera" and ui.get(enable_indicators) then
        visuals:draw_center2()
    end

end

register("paint", function () visuals:run_indicators() end)

ffi.cdef[[
	struct cusercmd
	{
		struct cusercmd (*cusercmd)();
		int     command_number;
		int     tick_count;
	};
	typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
]]
base64=require("gamesense/base64")signature_ginput=base64.decode("uczMzMyLQDj/0ITAD4U=")match=client.find_signature("client.dll",signature_ginput)or error("sig1 not found")g_input=ffi.cast("void**",ffi.cast("char*",match)+1)[0]or error("match is nil")g_inputclass=ffi.cast("void***",g_input)g_inputvtbl=g_inputclass[0]rawgetusercmd=g_inputvtbl[8]get_user_cmd=ffi.cast("get_user_cmd_t",rawgetusercmd)lastlocal=0;local function a(b)local c=get_user_cmd(g_inputclass,0,b.command_number)if ui.get(reduce_ticks)then if lastlocal+0.9>globals.curtime()then c.tick_count=c.tick_count+8 else c.tick_count=c.tick_count+1 end end end;client.set_event_callback("setup_command",a)

split = function(j,k)
    if k==nil then 
        k="%s"
    end
    local g={}
    for l in string.gmatch(j,"([^"..k.."]+)") do 
        table.insert(g,l)
    end
    return g 
end

client.set_event_callback("player_death", function(e)
    local r,g,b = ui.get(color3)
    local color_out = rgba_to_hex2(r,g,b,0)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() and ui.get(antiaim_mode) == "zov-mode" then
        notify.new_bottom(5, { r,g,b }, {
            { "reset ["},
            { "zov-mode", true },
            { "] due to" },
            { "death", true },
        })
    end
end)

client.set_event_callback("round_start", function()
    lastlocal = 0
    local r,g,b,a = ui.get(color3)
    local col = rgba_to_hex2(r,g,b,0)
    local me = entity.get_local_player()
    if not entity.is_alive(me) then return end
    if not ui.get(antiaim_mode) == "zov-mode" then return end
    notify.new_bottom(5, { r,g,b }, {
        { "reset ["},
        { "zov-mode", true },
        { "] due to" },
        { "new round", true },
    })
end)

function setup()
    for k, v in pairs(callback.callbacks) do
        local funcs = {}

        for key, val in pairs(v) do
            table.insert(funcs, val)
        end

        local func = function (...)
            for _, v in pairs(funcs) do
                v(...)
            end
        end

        client.set_event_callback(k, func)
    end
end

setup()

client.set_event_callback(protected[5], function()
    notify:handler()
end)