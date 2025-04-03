local ffi = require("ffi")
local http = require("gamesense/http")
local data = { tickbase = {  shifting = 0, list = (function() local index, max = { }, 16 for i=1, max do index[#index+1] = 0 if i == max then return index end end end)() }, } local ease = require("gamesense/easing") client.set_event_callback('net_update_start', function() local local_player = entity.get_local_player() local sim_time = entity.get_prop(local_player, "m_flSimulationTime") if local_player == nil or sim_time == nil then return end local tick_count = globals.tickcount() local shifted = math.max(unpack(data.tickbase.list)) data.tickbase.shifting = shifted < 0 and math.abs(shifted) or 0 data.tickbase.list[#data.tickbase.list+1] = sim_time/globals.tickinterval() - tick_count table.remove(data.tickbase.list, 1) end) local get_curtime = function(nOffset) return globals.curtime() - (nOffset * globals.tickinterval()) end local weapon_ready = function() local target = entity.get_local_player() local weapon = entity.get_player_weapon(target) if target == nil or weapon == nil then return false end if get_curtime(16) < entity.get_prop(target, 'm_flNextAttack') then return false end if get_curtime(0) < entity.get_prop(weapon, 'm_flNextPrimaryAttack') then return false end return true end local native_GetClipboardTextCount = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)") local native_SetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)") local native_GetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)") local new_char_arr = ffi.typeof("char[?]") local clipboard = { set = function(text) text = tostring(text) native_SetClipboardText(text, string.len(text)) end, get = function() local len = native_GetClipboardTextCount() if len > 0 then local char_arr = new_char_arr(len) native_GetClipboardText(0, char_arr, len) return ffi.string(char_arr, len-1) end end } local anti_aim = { get_double_tap = function() return weapon_ready() and data.tickbase.shifting > 0 end } local antiaim_funcs = anti_aim local images = require("gamesense/images") local vector = require("vector")
local select, setmetatable, toticks, require, tonumber, tostring, ipairs, pairs, type, pcall, writefile, assert, print, printf = select, setmetatable, toticks, require, tonumber, tostring, ipairs, pairs, type, pcall, writefile, assert, print, printf
local vector = require("vector")

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

local euphemia = euphemia_data and euphemia_data() or {
    username = "lby__",
    build = "nightly"
}
username = euphemia.username:lower()
build = euphemia.build:lower()
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


to_draw = "no"
to_up = "no"
to_draw_ticks = 0
to_draw_ticksh = 0

function defensive_indicator()

    local diff_mmeme = var_table.sim_diff()

    if diff_mmeme <= -1 then
        to_draw = "yes"
        to_up = "yes"
    end
end 

local images = require("gamesense/images")
local amnesia_icon_small
local notifs_icon
local amnesia_icon
local vel_icon
local loading_gif
local gif_decoder = require "gamesense/gif_decoder"
local gif1
local left_icon
local right_icon
local warning_widget

http.get("https://nl.euphemia.fun/img/amnesia.png", function(suc, res)
    if suc then
        warning_widget = renderer.load_svg(res.body, 1920, 1080)
    else
        print("couldn't download warning_widget icon")
    end
end)

http.get("https://nl.euphemia.fun/img/amnesia.png", function(suc, res)
    if suc then
        notifs_icon = images.load(res.body)
    else
        print("couldn't download amnesia icon")
    end
end)

start_time = globals.realtime()

http.get("https://nl.euphemia.fun/img/amnesia.png", function(suc, res)
    if suc then
        vel_icon = renderer.load_svg(res.body, 1920, 1080)
    else
        print("couldn't download amnesia icon")
    end
end)

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

local reference={
    enabled=ui[protected[2]](protected[6],protected[8],"enabled"),
    pitch=ui[protected[2]](protected[6],protected[8],"pitch"),
    yaw_base=ui[protected[2]](protected[6],protected[8],"yaw base"),
    yaw={ui[protected[2]](protected[6],protected[8],"yaw")},
    yaw_jitter={ui[protected[2]](protected[6],protected[8],"yaw jitter")},
    body_yaw={ui[protected[2]](protected[6],protected[8],"body yaw")},
    freestanding_body_yaw=ui[protected[2]](protected[6],protected[8],"freestanding body yaw"),
    edge_yaw=ui[protected[2]](protected[6],protected[8],"edge yaw"),
    freestanding={ui[protected[2]](protected[6],protected[8],"freestanding")},
    roll=ui[protected[2]](protected[6],protected[8],"roll"),
    slow_motion={ui[protected[2]](protected[6],"other","slow motion")},
    leg_movement=ui[protected[2]](protected[6],"other","leg movement"),
    on_shot_aa={ui[protected[2]](protected[6],"other","on shot anti-aim")},
    fl_limit=ui[protected[2]](protected[6],"fake lag","limit"),
    dt={ui[protected[2]]("RAGE","aimbot","Double tap")},
    fake_duck=ui[protected[2]]("rage","other","duck peek assist"),
    menu_col=ui[protected[2]]("misc","settings","menu color"),
    forcebaim=ui[protected[2]]("rage","aimbot","force body aim"),
    forcesp=ui[protected[2]]("rage","aimbot","force safe point")
}

local dt_fakelag = ui.reference("rage", "aimbot", "double tap fake lag limit")

local fix = function()
    ui.set(reference.pitch, "minimal")
    ui.set(reference.yaw_base, "at targets")
    ui.set(reference.yaw[1], "180")
    ui.set(reference.yaw[2], 0)
    ui.set(reference.yaw_jitter[1], "center")
    ui.set(reference.yaw_jitter[2], 0)
    ui.set(reference.body_yaw[1], "jitter")
    ui.set(reference.body_yaw[2], 0)
    ui.set(reference.freestanding_body_yaw, false)
end

fix()

local color = {}

function color:as_string(a,b,c,d)return("\a%02X%02X%02X%02X"):format(a,b,c,d)end;function color:accent()return self:as_string(255,188,239,255)end;function color:default()return self:as_string(205,205,205,255)end

local aa_lol={delta=0,builder={conditions={"global","stand","run","slow","crouch","crouch moving","air","air crouch","fakelag","hideshot","round-end","round-start","dormant","defensive","breaking lc","on peek", "knife"}},manual_state=0,state="NONE"}

local menu = {
    fl_limit = ui[protected[3]](protected[6], "fake lag", "Limit\n", 1, 15, ui.get(reference.fl_limit)),
    color3 = ui.new_color_picker(protected[6], protected[8], "color", 255, 188, 239, 255),
    enabled_label = ui.new_label(protected[6], protected[8], "enable amnesia ["..username.."] - v.0.0.1"),
    tabs = ui[protected[9]](protected[6], protected[8], "\n", { "anti-aim", "visuals {misc}", "config"}),
    aa_addons = ui[protected[9]](protected[6], protected[8], "\n", { "builder", "addons" }),
    antiaim_mode = ui[protected[9]](protected[6], protected[8], "mode", { "custom", "custom" }),
    space = ui.new_label(protected[6], protected[8], " "),
    team_mode = ui[protected[9]](protected[6], protected[8], "team", { "counterterrorist", "terrorist" })
}

ui.set_callback(menu.fl_limit, function () ui.set(reference.fl_limit, ui.get(menu.fl_limit)) end)

-- unused for now
local dynamic_mode = ui.new_multiselect(protected[6], protected[8], ("change / reset dynamic logic"):format(color:accent()), { "hit", "miss", "headshot"})
--local button = ui.new_button(protected[6], protected[8], "refresh presets", function () print("refreshed") end)

--ping-spike ref
local ping_spike = {ui.reference("MISC", "Miscellaneous", "Ping spike")}

local antiaim_condition = ui[protected[9]](protected[6], protected[8], ("conditions"):format(color:accent()), aa_lol.builder.conditions)

config_list=ui.new_listbox(protected[6],protected[8],"configs","")config_name=ui.new_textbox(protected[6],protected[8],"config name")config_load=ui.new_button(protected[6],protected[8],"load",function()end)config_save=ui.new_button(protected[6],protected[8],"save",function()end)config_delete=ui.new_button(protected[6],protected[8],"delete",function()end)config_import=ui.new_button(protected[6],protected[8],"import",function()end)config_export=ui.new_button(protected[6],protected[8],"export",function()end)

rgba_to_hex = function( r, g, b, a )
    return string.format( '%02x%02x%02x%02x', r, g, b, a )
end

function menu:handler()
    local element_handling = {}

    for _, v in pairs(aa_lol.builder.conditions) do
        element_handling[v] = {}

        element_handling[v].enable_state = ui.new_checkbox(protected[6], protected[8], "enable ("..v..")\nct")

        element_handling[v].jitter_val_l = ui.new_label(protected[6], protected[8], "("..v..") - jitter")
        element_handling[v].jitter_val = ui[protected[3]](protected[6], protected[8], "\nct("..v..") - jitter", -180, 180, 0, true, "°")

        element_handling[v].yaw_mode = ui[protected[9]](protected[6], protected[8], ("yaw option\nct%s"):format(v), { "l / r","delay","async","advanced","advanced(+)","interval", "light"})

        element_handling[v].yaw_left_l = ui.new_label(protected[6], protected[8], "("..v..") - left yaw")
        element_handling[v].yaw_left = ui[protected[3]](protected[6], protected[8], "\nct("..v..") - left yaw", -180, 180, 0, true, "°")
        element_handling[v].yaw_left_r = ui.new_label(protected[6], protected[8], "("..v..") - right yaw")
        element_handling[v].yaw_right = ui[protected[3]](protected[6], protected[8], "\nct("..v..") - right yaw", -180, 180, 0, true, "°")

        element_handling[v].delay_l = ui.new_label(protected[6], protected[8], "("..v..") - delay label")
        element_handling[v].delay = ui[protected[3]](protected[6], protected[8], ("\noffsetdelayct"):format(v), 0, 15, 8, true)

        element_handling[v].enable_state_t = ui.new_checkbox(protected[6], protected[8], "enable ("..v..")\nt")

        element_handling[v].jitter_val_l_t = ui.new_label(protected[6], protected[8], "("..v..") - jitter")
        element_handling[v].jitter_val_t = ui[protected[3]](protected[6], protected[8], "\nt("..v..") - jitter", -180, 180, 0, true, "°")

        element_handling[v].yaw_mode_t = ui[protected[9]](protected[6], protected[8], ("yaw option\nt%s"):format(v), { "l / r","delay","async","advanced","advanced(+)","interval", "light"})

        element_handling[v].yaw_left_l_t = ui.new_label(protected[6], protected[8], "("..v..") - left yaw")
        element_handling[v].yaw_left_t = ui[protected[3]](protected[6], protected[8], "\nt("..v..") - left yaw", -180, 180, 0, true, "°")
        element_handling[v].yaw_left_r_t = ui.new_label(protected[6], protected[8], "("..v..") - right yaw")
        element_handling[v].yaw_right_t = ui[protected[3]](protected[6], protected[8], "\nt("..v..") - right yaw", -180, 180, 0, true, "°")

        element_handling[v].delay_l_t = ui.new_label(protected[6], protected[8], "("..v..") - delay label")
        element_handling[v].delay_t = ui[protected[3]](protected[6], protected[8], ("\noffsetdelayt"):format(v), 0, 15, 8, true)
    end

    menu.builder_elements = element_handling
end

menu:handler()

local addons = {
    close_label11 = ui.new_label(protected[6], protected[8], " "),
    binds_label = ui.new_label(protected[6], protected[8], " "),
    binds = ui.new_multiselect(protected[6], protected[8], ("\nbinds"):format(color:accent()), { "manual aa", "freestanding", "freestand disablers", "edge yaw"}),
    manual_left_key = ui.new_hotkey(protected[6], protected[8], "manual left"),
    manual_right_key = ui.new_hotkey(protected[6], protected[8], "manual right"),
    manual_forward_key = ui.new_hotkey(protected[6], protected[8], "manual forward"),
    freestanding_key = ui.new_hotkey(protected[6], protected[8], "freestanding"),
    freestanding_disablers = ui.new_multiselect(protected[6], protected[8], "╰┈disablers", { "standing", "moving", "crouching", "in air", "slowwalking" }),
    edge_yaw_key = ui.new_hotkey(protected[6], protected[8], "edge yaw"),
    vis_selects = ui.new_multiselect(protected[6], protected[8], ("visual elements"):format(color:accent()), { "screen indicator", "slowdown", "watermark"}),
    misc_selects = ui.new_multiselect(protected[6], protected[8], ("misc elements"):format(color:accent()), { "air {lc} exploit", "enhance ping"}),
    enable_visuals = ui.new_checkbox(protected[6], protected[8], "enable watermark"),
    scale_clr = ui.new_checkbox(protected[6], protected[8], "scale icon color on menu"),
    enable_indicators = ui.new_checkbox(protected[6], protected[8], "enable indicators"),
    enable_slowdown = ui.new_checkbox(protected[6], protected[8], "enable slowdown indicator"),
    enable_defensive = ui.new_checkbox(protected[6], protected[8], "enable defensive indicator"),
    indicators = ui[protected[9]](protected[6], protected[8], "choose indicator style", { "-", "amnesia"}),
    reduce_ticks = ui.new_checkbox(protected[6], protected[8], 'reduce sent ticks'),
    manipulate_tick = ui.new_checkbox(protected[6], protected[8], 'manipulate ticks to enhance anti-aim')
}

local gethex=function(b,c,d,e,f,g,h,i)local j,k,l,m=c,d,e,0;local f,g,h,i=f,g,h,i;local n=globals.realtime()/2%1.3*2-1.3;local o=""for p=1,#b do local q=b:sub(p,p)local r=p/#b;local c,d,e,s=j,k,l,m;local t=r-n;if t>=0 and t<=1.4 then if t>0.7 then t=1.4-t end;r_fraction,g_fraction,b_fraction,a_fraction=f-c,g-d,h-e;c=c+r_fraction*t/0.8;d=d+g_fraction*t/0.8;e=e+b_fraction*t/0.8 end;o=o..('\a%02x%02x%02x%02x%s'):format(c,d,e,i,b:sub(p,p))end;return o end
local gradient_text_anim=function(b,c,d,e,f,g,h,i,j,k,l)local m,n,o,p=c,d,e,f;local g,h,i,j=g,h,i,j;k=k or 1;l=l or 0;l=l+3;local q=''local r=b:len()local s=globals.curtime()local t=s*k%l-2;for u=1,r do local v=b:sub(u,u)local w=(u-1)/(r-1)local x=w-t;if x>1 then x=1*2-x end;local c,d,e,f=m,n,o,p;local y=g-c;local z=h-d;local A=i-e;local B=j-f;if x>=0 and x<=1 then c=c+y*x;d=d+z*x;e=e+A*x;f=f+B*x end;q=q..('\a%02x%02x%02x%02x%s'):format(c,d,e,f,v)end;return q end

client.set_event_callback(protected[5], function()
    local r,g,b,a = ui.get(menu.color3)

    local color_out = rgba_to_hex(r,g,b,a)

    ui.set(reference.menu_col, ui.get(menu.color3))

    ui.set(menu.enabled_label, gethex("amnesia -|- "..build, 35,35,35, r,g,b,250))

    ui.set(addons.binds_label, "\a"..color_out.."[aa]\aFFFFFFC2 ~ addons")

    for _, v in pairs(aa_lol.builder.conditions) do

        local elements = menu.builder_elements[v]

        local r,g,b,a = ui.get(menu.color3)
        local color_out = rgba_to_hex(r,g,b,a)

        ui.set(elements.jitter_val_l, "\a"..color_out..""..v.." ct\aFFFFFFC2 • jitter")
        ui.set(elements.jitter_val_l_t, "\a"..color_out..""..v.." t\aFFFFFFC2 • jitter")

        ui.set(elements.delay_l, "\a"..color_out..""..v.." ct\aFFFFFFC2 • rate (x) to unsync")
        ui.set(elements.delay_l_t, "\a"..color_out..""..v.." t\aFFFFFFC2 • rate (x) to unsync")

        ui.set(elements.yaw_left_l, "\a"..color_out..""..v.." ct\aFFFFFFC2 • left")
        ui.set(elements.yaw_left_r, "\a"..color_out..""..v.." ct\aFFFFFFC2 • right")

        ui.set(elements.yaw_left_l_t, "\a"..color_out..""..v.." t\aFFFFFFC2 • left")
        ui.set(elements.yaw_left_r_t, "\a"..color_out..""..v.." t\aFFFFFFC2 • right")

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

    local disablers = ui.get(addons.binds)
    local antiaimmode = ui.get(menu.antiaim_mode)

    ui.set(reference.enabled, true)

    --skeet menu aa hidden (minified)
    ui[protected[1]](reference.enabled,not show)ui[protected[1]](reference.pitch,not show)ui[protected[1]](reference.yaw_base,not show)ui[protected[1]](reference.yaw[1],not show)ui[protected[1]](reference.yaw[2],not show)ui[protected[1]](reference.yaw_jitter[1],not show)ui[protected[1]](reference.yaw_jitter[2],not show)ui[protected[1]](reference.body_yaw[1],not show)ui[protected[1]](reference.body_yaw[2],not show)ui[protected[1]](reference.freestanding_body_yaw,not show)ui[protected[1]](reference.edge_yaw,not show)ui[protected[1]](reference.freestanding[1],not show)ui[protected[1]](reference.freestanding[2],not show)ui[protected[1]](reference.roll,not show)

    ui[protected[1]](menu.tabs, show)

    local show_aa = ui.get(menu.tabs) == "anti-aim" and ui.get(menu.aa_addons) == "builder"

    local show_misc = show and ui.get(menu.tabs) == "misc"

    local show_config = show and ui.get(menu.tabs) == "config"

    ui[protected[1]](addons.reduce_ticks, ui.get(menu.tabs) == "anti-aim" and ui.get(menu.aa_addons) == "addons")
    ui[protected[1]](addons.manipulate_tick, ui.get(menu.tabs) == "anti-aim" and ui.get(menu.aa_addons) == "addons")
    ui[protected[1]](config_list, show_config)
    ui[protected[1]](config_name, show_config)
    ui[protected[1]](config_load, show_config)
    ui[protected[1]](config_save, show_config)
    ui[protected[1]](config_delete, show_config)
    ui[protected[1]](config_import, show_config)
    ui[protected[1]](config_export, show_config)
    ui[protected[1]](addons.binds, show_aa)
    ui[protected[1]](addons.binds_label, show_aa)
    ui[protected[1]](menu.aa_addons, ui.get(menu.tabs) == "anti-aim")
    ui[protected[1]](menu.antiaim_mode, false)
    
    if contains(disablers, "manual aa") then
	    ui[protected[1]](addons.manual_left_key, show_aa)
	    ui[protected[1]](addons.manual_right_key, show_aa)
	    ui[protected[1]](addons.manual_forward_key, show_aa)
    else
        ui[protected[1]](addons.manual_left_key, false)
	    ui[protected[1]](addons.manual_right_key, false)
	    ui[protected[1]](addons.manual_forward_key, false)
    end

    if contains(disablers, "freestanding") then
	    ui[protected[1]](addons.freestanding_key, show_aa)
    else
        ui[protected[1]](addons.freestanding_key, false)
    end

    if contains(disablers, "freestand disablers") then
	    ui[protected[1]](addons.freestanding_disablers, show_aa)
    else
        ui[protected[1]](addons.freestanding_disablers, false)
    end

    if contains(disablers, "edge yaw") then
	    ui[protected[1]](addons.edge_yaw_key, show_aa)
    else
        ui[protected[1]](addons.edge_yaw_key, false)
    end

    ui[protected[1]](antiaim_condition, show_aa)


    ui[protected[1]](dynamic_mode, false)

    --custom aa loop (minified bc omg its long and ugly but im too lazy to fix it..)
    --> custom antiaim
    for _, v in pairs(aa_lol.builder.conditions) do
        local selected = ui.get(antiaim_condition) == v and show_aa and not hide_config

        local elements = menu.builder_elements[v]

        if ui.get(menu.aa_addons) == "builder" then
            ui[protected[1]](menu.team_mode, show_aa)
            ui.set(menu.builder_elements["global"].enable_state, show_aa)
            ui.set(menu.builder_elements["global"].enable_state_t, show_aa)
            ui[protected[1]](menu.builder_elements["global"].enable_state, false)
            ui[protected[1]](menu.builder_elements["global"].enable_state_t, false)
            if ui.get(menu.team_mode) == "counterterrorist" then
                ui[protected[1]](elements.enable_state_t, false)
                ui[protected[1]](elements.enable_state, selected)

                if ui.get(elements.enable_state) then
                    if ui.get(elements.yaw_mode) == "async" then
                        ui[protected[1]](elements.delay, selected)
                        ui[protected[1]](elements.delay_l, selected)
                    else
                        ui[protected[1]](elements.delay_l, false)
                        ui[protected[1]](elements.delay, false)
                    end
                    ui[protected[1]](elements.jitter_val, selected)
                    ui[protected[1]](elements.jitter_val_l, selected)
                    ui[protected[1]](elements.yaw_mode, selected)
                    ui[protected[1]](elements.yaw_left_l, selected)
                    ui[protected[1]](elements.yaw_left, selected)
                    ui[protected[1]](elements.yaw_left_r, selected)
                    ui[protected[1]](elements.yaw_right, selected)

                    ui[protected[1]](elements.jitter_val_t, false)
                    ui[protected[1]](elements.jitter_val_l_t, false)

                    ui[protected[1]](elements.yaw_mode_t, false)
                    ui[protected[1]](elements.delay_l_t, false)
                    ui[protected[1]](elements.yaw_left_l_t, false)
                    ui[protected[1]](elements.yaw_left_r_t, false)
                    ui[protected[1]](elements.yaw_left_t, false)
                    ui[protected[1]](elements.yaw_right_t, false)
                    ui[protected[1]](elements.delay_t, false)
                else
                    ui[protected[1]](elements.delay_l, false)
                    ui[protected[1]](elements.delay, false)
                    ui[protected[1]](elements.jitter_val, false)
                    ui[protected[1]](elements.jitter_val_l, false)
                    ui[protected[1]](elements.yaw_mode, false)
                    ui[protected[1]](elements.yaw_left_l, false)
                    ui[protected[1]](elements.yaw_left, false)
                    ui[protected[1]](elements.yaw_left_r, false)
                    ui[protected[1]](elements.yaw_right, false)

                    ui[protected[1]](elements.jitter_val_t, false)
                    ui[protected[1]](elements.jitter_val_l_t, false)

                    ui[protected[1]](elements.yaw_mode_t, false)
                    ui[protected[1]](elements.delay_l_t, false)
                    ui[protected[1]](elements.yaw_left_l_t, false)
                    ui[protected[1]](elements.yaw_left_r_t, false)
                    ui[protected[1]](elements.yaw_left_t, false)
                    ui[protected[1]](elements.yaw_right_t, false)
                    ui[protected[1]](elements.delay_t, false)
                end

            elseif ui.get(menu.team_mode) == "terrorist" then
                ui[protected[1]](elements.enable_state, false)
                ui[protected[1]](elements.enable_state_t, selected)

                if ui.get(elements.enable_state_t) then

                    if ui.get(elements.yaw_mode_t) == "async" then
                        ui[protected[1]](elements.delay_l_t, selected)
                        ui[protected[1]](elements.delay_t, selected)
                    else
                        ui[protected[1]](elements.delay_l_t, false)
                        ui[protected[1]](elements.delay_t, false)
                    end
                    ui[protected[1]](elements.jitter_val_l_t, selected)
                    ui[protected[1]](elements.yaw_mode_t, selected)
                    ui[protected[1]](elements.yaw_left_l_t, selected)
                    ui[protected[1]](elements.yaw_left_t, selected)
                    ui[protected[1]](elements.yaw_left_r_t, selected)
                    ui[protected[1]](elements.yaw_right_t, selected)
                    ui[protected[1]](elements.jitter_val_t, selected)

                    ui[protected[1]](elements.jitter_val, false)
                    ui[protected[1]](elements.jitter_val_l, false)
                    ui[protected[1]](elements.yaw_mode, false)
                    ui[protected[1]](elements.yaw_left_l, false)
                    ui[protected[1]](elements.delay_l, false)
                    ui[protected[1]](elements.yaw_left_r, false)
                    ui[protected[1]](elements.yaw_left, false)
                    ui[protected[1]](elements.yaw_right, false)
                    ui[protected[1]](elements.delay, false)
                else

                    ui[protected[1]](elements.delay_l_t, false)
                    ui[protected[1]](elements.delay_t, false)

                    ui[protected[1]](elements.jitter_val_l_t, false)
                    ui[protected[1]](elements.yaw_mode_t, false)
                    ui[protected[1]](elements.yaw_left_l_t, false)
                    ui[protected[1]](elements.yaw_left_t, false)
                    ui[protected[1]](elements.yaw_left_r_t, false)
                    ui[protected[1]](elements.yaw_right_t, false)
                    ui[protected[1]](elements.jitter_val_t, false)

                    ui[protected[1]](elements.jitter_val, false)
                    ui[protected[1]](elements.jitter_val_l, false)
                    ui[protected[1]](elements.yaw_mode, false)
                    ui[protected[1]](elements.yaw_left_l, false)
                    ui[protected[1]](elements.delay_l, false)
                    ui[protected[1]](elements.yaw_left_r, false)
                    ui[protected[1]](elements.yaw_left, false)
                    ui[protected[1]](elements.yaw_right, false)
                    ui[protected[1]](elements.delay, false)
                end
            end
        else
		
            ui[protected[1]](elements.enable_state_t, false)
            ui[protected[1]](elements.enable_state, false)
            ui[protected[1]](elements.jitter_val, false)
            ui[protected[1]](elements.jitter_val_t, false)
            ui[protected[1]](elements.jitter_val_l, false)
            ui[protected[1]](elements.jitter_val_l_t, false)
            ui[protected[1]](elements.delay_l, false)
            ui[protected[1]](elements.delay_l_t, false)
            ui[protected[1]](elements.yaw_mode_t, false)
            ui[protected[1]](elements.yaw_mode, false)
            ui[protected[1]](elements.yaw_left_l, false)
            ui[protected[1]](elements.yaw_left_r, false)
            ui[protected[1]](elements.yaw_left, false)
            ui[protected[1]](elements.delay_t, false)
            ui[protected[1]](elements.delay, false)
            ui[protected[1]](elements.yaw_right, false)

            ui[protected[1]](elements.yaw_left_l_t, false)
            ui[protected[1]](elements.yaw_left_r_t, false)
            ui[protected[1]](elements.yaw_left_t, false)
            ui[protected[1]](elements.yaw_right_t, false)

            ui[protected[1]](menu.team_mode, false)

        end
			
    end

    local show_visuals = show and ui.get(menu.tabs) == "visuals {misc}"
    ui[protected[1]](addons.vis_selects, show_visuals)
    ui[protected[1]](addons.misc_selects, show_visuals)
    ui[protected[1]](addons.scale_clr, false)

    if contains(ui.get(addons.vis_selects), "screen indicator") then
        ui[protected[1]](addons.enable_indicators, show_visuals)
        if show_visuals and ui.get(addons.enable_indicators) then
            ui[protected[1]](addons.indicators, true)
        else
            ui[protected[1]](addons.indicators, false)
        end
    else
        ui[protected[1]](addons.enable_indicators, false)
        ui[protected[1]](addons.indicators, false)
    end

    if contains(ui.get(addons.vis_selects), "watermark") then
        ui[protected[1]](addons.enable_visuals, show_visuals)
    else
        ui[protected[1]](addons.enable_visuals, false)
    end

    if contains(ui.get(addons.vis_selects), "slowdown") then
        ui[protected[1]](addons.enable_slowdown, show_visuals)
    else
        ui[protected[1]](addons.enable_slowdown, false)
    end

    ui[protected[1]](reference.fl_limit, not show)
    ui[protected[1]](menu.fl_limit, show)
end

function menu:show_og()ui[protected[1]](reference.enabled,true)ui[protected[1]](reference.pitch,true)ui[protected[1]](reference.yaw_base,true)ui[protected[1]](reference.yaw[1],true)ui[protected[1]](reference.yaw[2],true)ui[protected[1]](reference.yaw_jitter[1],true)ui[protected[1]](reference.yaw_jitter[2],true)ui[protected[1]](reference.body_yaw[1],true)ui[protected[1]](reference.body_yaw[2],true)ui[protected[1]](reference.freestanding_body_yaw,true)ui[protected[1]](reference.edge_yaw,true)ui[protected[1]](reference.freestanding[1],true)ui[protected[1]](reference.freestanding[2],true)ui[protected[1]](reference.roll,true)ui[protected[1]](reference.fl_limit,true)end

register("shutdown", function () menu:show_og() end)
register(protected[5], function () menu:visibility() end)

local function color_log(text, r,g,b)
    client.color_log(r,g,b, "amnesia \0")
    client.color_log(110, 110, 110, "~ \0")
    client.color_log(200,200,200, text)
end

function import_settings_fix()
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
end

ui.update(config_list, get_config_list())
--ui.set(config_name, #database.read(amnesia.database.configs) == 0 and "" or database.read(amnesia.database.configs)[ui.get(config_list)+1].name)
ui.set_callback(config_list,function(a)local b=""local c=get_config_list()local d=function()b=c[ui.get(a)+1]or""ui.set(config_name,b)end;if pcall(d)then color_log("configs fetched [success]",227,189,255)else color_log("configs fetched [failed..]",227,189,255)end end)
ui.set_callback(config_load,function()local a=ui.get(config_name)if a==""then return end;local b=function()load_config(a)end;if pcall(b)then print("loaded config - "..a)else print("failed to load config")end end)
ui.set_callback(config_save,function()local a=ui.get(config_name)if a==""then return end;if a:match("[^%w]")~=nil then print("contains not allowed letters ^%w")return end;local b=function()save_config(a)end;if pcall(b)then ui.update(config_list,get_config_list())print("saved the config - "..a)else print("failed to save the config - "..a)end end)
ui.set_callback(config_delete,function()local a=ui.get(config_name)if a==""then return end;if delete_config(a)==false then print("failed to delete")ui.update(config_list,get_config_list())return end;local b=function()delete_config(a)end;if pcall(b)then ui.update(config_list,get_config_list())ui.set(config_list,#amnesia.presets+#database.read(amnesia.database.configs)-#database.read(amnesia.database.configs))ui.set(config_name,#database.read(amnesia.database.configs)==0 and""or get_config_list()[#amnesia.presets+#database.read(amnesia.database.configs)-#database.read(amnesia.database.configs)+1])print("deleted config - "..a)else print("failed to delete config - "..a)end end)
ui.set_callback(config_import,function()local a=function()import_settings_fix()end;if pcall(a)then print("imported")else print("failed import")end end)
ui.set_callback(config_export,function()local a=function()export_settings()end;if pcall(a)then print("exported")else print("failed export")end end)

local state = {
    ground_timer = 0,
    lag_timer = 0
}

function state:fakelag()local a=ui.get(reference.dt[1])and ui.get(reference.dt[2])local b=ui.get(reference.on_shot_aa[1])and ui.get(reference.on_shot_aa[2])local c=ui.get(reference.fake_duck)if a or b or c then return false else return true end end

function state:in_air(a)if not a then return false end;local b=entity.get_prop(a,"m_fFlags")local c=bit.band(b,1)~=0;if c then if self.ground_timer==5 then return false end;self.ground_timer=self.ground_timer+1 else self.ground_timer=0 end;return true end

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
    defensive_indicator()
end


client.set_event_callback("setup_command", on_setup_command)

local http = require('gamesense/http')
local images = require('gamesense/images')

local Render_engine = (function()
	local self = {}

	local background = function(x, y, w, h, r, g, b, a, roundness, adder)
		--local adder = 1
        local roundness = roundness > 0 and roundness - 1 or roundness
		if a == 0 then return end
		renderer.rectangle(x + roundness + adder, y + roundness + adder, w - roundness * 2 - adder * 2, h - roundness * 2 - adder * 2, r, g, b, a) --background
		renderer.circle(x + w - roundness - adder, y + roundness + adder, r, g, b, a, roundness, 90, 0.25) -- right top corner
		renderer.circle(x + w - roundness - adder, y + h - roundness - adder, r, g, b, a, roundness, 360, 0.25) --right bottom corner
		renderer.circle(x + roundness + adder, y + h - roundness - adder, r, g, b, a, roundness, 270, 0.25) -- left bottom corner
		renderer.circle(x + roundness + adder, y + roundness + adder, r, g, b, a, roundness, 180, 0.25) -- left top corner
		renderer.rectangle(x + roundness + adder, y + adder, w - roundness * 2 - adder * 2, roundness, r, g, b, a)
		renderer.rectangle(x + w - roundness - adder, y + roundness + adder, roundness, h - roundness * 2 - adder * 2, r, g, b, a)
		renderer.rectangle(x + roundness + adder, y + h - roundness - adder, w - roundness * 2 - adder * 2, roundness, r, g, b, a)
		renderer.rectangle(x + adder, y + roundness + adder, roundness, h - roundness * 2 - adder * 2, r, g, b, a)
	end

	local outline = function(x, y, w, h, r, g, b, a, lower_line_alpha, roundness, line_thickness)
		local adder = 0--roundness == 0 and line_thickness or 0
		renderer.rectangle(x + roundness, y, w - roundness * 2, line_thickness, r, g, b, a) --top line
		renderer.circle_outline(x + w - roundness, y + roundness, r, g, b, a, roundness, 270, 0.25, line_thickness) -- right top corner
		renderer.gradient(x + w - line_thickness, y + roundness + adder, line_thickness, h - roundness * 2 - adder * 2, r, g, b, a, r, g, b, lower_line_alpha, false) --left gradient
		renderer.circle_outline(x + w - roundness, y + h - roundness, r, g, b, lower_line_alpha, roundness, 360, 0.25, line_thickness) --right bottom corner
		renderer.rectangle(x + roundness, y + h - line_thickness, w - roundness * 2, line_thickness, r, g, b, lower_line_alpha) -- bottom line
		renderer.circle_outline(x + roundness, y + h - roundness, r, g, b, lower_line_alpha, roundness, 90, 0.25, line_thickness) -- left bottom corner
		renderer.gradient(x, y + roundness + adder, line_thickness, h - roundness * 2 - adder * 2, r, g, b, a, r, g, b, lower_line_alpha, false) --right gradient
		renderer.circle_outline(x + roundness, y + roundness, r, g, b, a, roundness, 180, 0.25, line_thickness) -- left top corner
	end

    local watermark_iconurl, watermark_icon = "https://cdn.discordapp.com/attachments/1009102824975630476/1023535660176523346/behind_water.png", nil
    http.get(watermark_iconurl, function(s, r)
        if s and r.status == 200 then
            watermark_icon = images.load(r.body)
        end
    end)

    self.pandora_rectangle = function(x, y, w, h, r, g, b, a, r2, g2, b2, a2, bgr, bgg, bgb, bga, r3, g3, b3, a3, roundness, show)
        local show = show ~= nil and show or false
        background(x + 3, y + 3, w - 6, h - 6, bgr, bgg, bgb, bga, 0, 0)
        outline(x, y, w, h, r2, g2, b2, a2, a, roundness, 3)
        renderer.rectangle(x + 3, y + 3, 1, 1, r2, g2, b2, a2)
        renderer.rectangle(x + w - 4, y + 3, 1, 1, r2, g2, b2, a2)
        renderer.rectangle(x + w - 4, y + h - 4, 1, 1, r2, g2, b2, a2)
        renderer.rectangle(x + 3, y + h - 4, 1, 1, r2, g2, b2, a2)
		outline(x + 1, y + 1, w - 2, h - 2, r, g, b, a, a, roundness, 1)

        if show and watermark_icon ~= nil then
            watermark_icon:draw(x - 10, y + 3, w, 18, r3, g3, b3, a3, true)
        end
    end

	return self
end)()

local w_anim = -250

local ctx = (function()
	local ctx = {
		logo = nil
	}

	http.get("https://cdn.discordapp.com/attachments/1062811560285835286/1232739084984782939/cxdxd.png?ex=662b35fd&is=6629e47d&hm=c3f902d58cb75bc7d2d0196031473d9abc4103c3b87f67e6391344fc999a9c00&.png", function(success, response)
		if not success or response.status ~= 200 then
			return
		end
	
		ctx.logo = images.load_png(response.body)
	end)

    ctx.ref = {
		fd = ui.reference("Rage", "Other", "Duck peek assist"),
		dt = {ui.reference("Rage", "aimbot", "Double Tap")},
		dt_fl = ui.reference("Rage", "aimbot", "Double tap fake lag limit"),
		hs = {ui.reference("AA", "Other", "On shot anti-aim")},
		silent = ui.reference("Rage", "other", "Silent aim"),
		slow_motion = {ui.reference("AA", "Other", "Slow motion")}
	}

	ctx.helpers = {
		defensive = 0,
		checker = 0,
		contains = function(self, tbl, val)
			for k, v in pairs(tbl) do
				if v == val then
					return true
				end
			end
			return false
		end,

		easeInOut = function(self, t)
			return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
		end,

		clamp = function(self, val, lower, upper)
			assert(val and lower and upper, "not very useful error message here")
			if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
			return math.max(lower, math.min(upper, val))
		end,

		split = function(self, inputstr, sep)
			if sep == nil then
					sep = "%s"
			end
			local t={}
			for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
					table.insert(t, str)
			end
			return t
		end,

		rgba_to_hex = function(self, r, g, b, a)
		  return bit.tohex(
		    (math.floor(r + 0.5) * 16777216) + 
		    (math.floor(g + 0.5) * 65536) + 
		    (math.floor(b + 0.5) * 256) + 
		    (math.floor(a + 0.5))
		  )
		end,

		hex_to_rgba = function(self, hex)
    	local color = tonumber(hex, 16)

    	return 
        math.floor(color / 16777216) % 256, 
        math.floor(color / 65536) % 256, 
        math.floor(color / 256) % 256, 
        color % 256
		end,

		color_text = function(self, string, r, g, b, a)
			local accent = "\a" .. self:rgba_to_hex(r, g, b, a)
			local white = "\a" .. self:rgba_to_hex(255, 255, 255, a)

			local str = ""
			for i, s in ipairs(self:split(string, "$")) do
				str = str .. (i % 2 ==( string:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
			end

			return str
		end,

		animate_text = function(self, time, string, r, g, b, a)
			local t_out, t_out_iter = { }, 1

			local l = string:len( ) - 1
	
			local r_add = (255 - r)
			local g_add = (255 - g)
			local b_add = (255 - b)
			local a_add = (155 - a)
	
			for i = 1, #string do
				local iter = (i - 1)/(#string - 1) + time
				t_out[t_out_iter] = "\a" .. ctx.helpers:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )
	
				t_out[t_out_iter + 1] = string:sub( i, i )
	
				t_out_iter = t_out_iter + 2
			end
	
			return t_out
		end,

        get_velocity = function(self, ent)
			return vector(entity.get_prop(ent, "m_vecVelocity")):length()
		end,

		in_air = function(self, _ent)
			local flags = entity.get_prop(_ent, "m_fFlags")
	
			if bit.band(flags, 1) == 0 then
				return true
			end
			
			return false
		end,

		in_duck = function(self, _ent)
			local flags = entity.get_prop(_ent, "m_fFlags")
			
			if bit.band(flags, 4) == 4 then
				return true
			end
			
			return false
		end,

		get_state = function(self, ent)
			local vel = self:get_velocity(ent)
			local air = self:in_air(ent)
			local duck = self:in_duck(ent)

			local state = vel > 3 and "running" or "standing"
			if air then
				state = duck and "air crouch" or "jumping"
			elseif ui.get(ctx.ref.slow_motion[1]) and ui.get(ctx.ref.slow_motion[2]) and ent == entity.get_local_player() then
				state = "slowmotion"
			elseif duck then
				state = "crouching"
			end

			return state
		end,

		get_time = function(self, h12)
			local hours, minutes, seconds = client.system_time()

			if h12 then
					local hrs = hours % 12

					if hrs == 0 then
							hrs = 12
					else
							hrs = hrs < 10 and hrs or ('%02d'):format(hrs)
					end

					return ('%s:%02d %s'):format(
							hrs,
							minutes,
							hours >= 12 and 'pm' or 'am'
					)
			end

			return ('%02d:%02d:%02d'):format(
					hours,
					minutes,
					seconds
			)
	end,
	}

	ctx.m_render = {
		rec = function(self, x, y, w, h, radius, color)
			local r, g, b, a = unpack(color)

            radius = math.min(x/2, y/2, radius)
            renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
            renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
            renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
            renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, .25)
            renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, .25)
            renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, .25)
            renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, .25)
		end,

		rec_outline = function(self, x, y, w, h, radius, thickness, color)

			local r, g, b, a = unpack(color)

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
		end,

		glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
			local thickness = 1
			local offset = 1
			local r, g, b, a = unpack(accent)
			if accent_inner then
				self:rec(x , y, w, h + 1, rounding, accent_inner)
				--renderer.blur(x , y, w, h)
				--m_render.rec_outline(x + width*thickness - width*thickness, y + width*thickness - width*thickness, w - width*thickness*2 + width*thickness*2, h - width*thickness*2 + width*thickness*2, color(r, g, b, 255), rounding, thickness)
			end
			for k = 0, width do
				if a * (k/width)^(1) > 5 then
					local accent = {r, g, b, a * (k/width) ^ 8}
					self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
				end
			end
		end
	}

	ctx.notifications = {
		anim_time = 0.30,
		max_notifs = 6,
		data = {},

		new = function(self, string, r, g, b)
			table.insert(self.data, {
				time = globals.curtime(),
				string = string,
				color = {r, g, b, 255},
				fraction = 0
			})
			local time = 5
			for i = #self.data, 1, -1 do
				local notif = self.data[i]
				if #self.data - i + 1 > self.max_notifs and notif.time + time - globals.curtime() > 0 then
					notif.time = globals.curtime() - time
				end
			end
		end,

		render = function(self)
			local x, y = client.screen_size()
			local to_remove = {}
			local offset = 0
			for i = 1, #self.data do
				local notif = self.data[i]

				local data = {rounding = 4, size = 5, glow = 35, time = 5}

				if notif.time + data.time - globals.curtime() > 0 then
					notif.fraction = ctx.helpers:clamp(notif.fraction + globals.frametime() / self.anim_time, 0, 1)
				else
					notif.fraction = ctx.helpers:clamp(notif.fraction - globals.frametime() / self.anim_time, 0, 1)
				end

				if notif.fraction <= 0 and notif.time + data.time - globals.curtime() <= 0 then
					table.insert(to_remove, i)
				end

                w_anim = lerp(w_anim, 7.9, globals.frametime() * 9)

				local fraction = ctx.helpers:easeInOut(notif.fraction)

				local r, g, b, a = unpack(notif.color)
				local string = ctx.helpers:color_text(notif.string, r, g, b, a * fraction)

				local strw, strh = renderer.measure_text("", string)
				local strw2 = renderer.measure_text("b", "        ")

				local paddingx, paddingy = 7, data.size
				data.rounding = math.ceil(data.rounding/10 * (strh + paddingy*2)/2)

				offset = offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 - 7) * fraction

                --Render_engine.pandora_rectangle(x/2 - (strw + strw2)/2 - w_anim, y - 100 - strh/2 - paddingy - offset, strw + strw2 + w_anim*2, strh + paddingy*2 + 2, 40, 40, 40, a * fraction, 0, 0, 0, a * fraction, 15, 15, 15, a * fraction, r, g, b, 15 * fraction, 3, true)
                --m_render.glow_module_notify(x/2 - (strw + strw2)/2 - paddingx, y - 100 - strh/2 - paddingy - offset, strw + strw2 + paddingx*2, strh + paddingy*2, 15, 8, 25, 25, 25, a * fraction, r, g, b, a * fraction, true)

				ctx.m_render:glow_module(x/2 - (strw + strw2)/2 - paddingx, y - 100 - strh/2 - paddingy - offset, strw + strw2 + paddingx*2, strh + paddingy*2 + 3, data.glow, data.rounding, {0, 0, 0, 45 * fraction}, {25,25,25,255 * fraction})
				renderer.text(x/2 + strw2/2, y - 99 - offset, 255, 255, 255, 255 * fraction, "c", 0, string)

                if notifs_icon then
                    notifs_icon:draw(x/2 - strw/2 - 32, y - 109 - offset, nil, 22, 255, 255, 255, 255 * fraction, true, "f")
                    --renderer.texture(amnesia_icon_small, x/2 - strw/2 - 10, y - 105 - offset, nil, 12, 255, 255, 255, 255 * fraction)
                end
			end

			for i = #to_remove, 1, -1 do
				table.remove(self.data, to_remove[i])
			end
		end,

		clear = function(self)
			self.data = {}
		end
	}

    ctx.indicators = {
		active_fraction = 0,
		inactive_fraction = 0,
		hide_fraction = 0,
		scoped_fraction = 0,
		fraction = 0,
		render = function(self)
			local me = entity.get_local_player()

			if not me or not entity.is_alive(me) then
				return
			end

			local state = ctx.helpers:get_state(me)
			local x, y = client.screen_size()
			local r, g, b = ui.get(menu.color3)

			local scoped = entity.get_prop(me, "m_bIsScoped") == 1

			if scoped then
				self.scoped_fraction = ctx.helpers:clamp(self.scoped_fraction + globals.frametime()/0.5, 0, 1)
			else
				self.scoped_fraction = ctx.helpers:clamp(self.scoped_fraction - globals.frametime()/0.5, 0, 1)
			end

			local scoped_fraction = ctx.helpers:easeInOut(self.scoped_fraction)

            if ui.get(addons.indicators) == "amnesia" and ui.get(addons.enable_indicators) then
				local strike_w, strike_h = renderer.measure_text("-", "AMNESIA YAW")

				--ctx.m_render:glow_module(x/2 + ((strike_w + 2)/2) * scoped_fraction - strike_w/2 + 4, y/2 + 20, strike_w - 3, 5, 10, 0, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))}, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))})
				renderer.text(x/2 + ((strike_w + 2)/2) * scoped_fraction, y/2 + 20, 255, 255, 255, 255, "c-", 0, "AMNESIA ", "\a" .. ctx.helpers:rgba_to_hex( r, g, b, 255 * math.abs(math.cos(globals.curtime()*2))) .. "YAW")

				local next_attack = entity.get_prop(me, "m_flNextAttack")
				local next_primary_attack = entity.get_prop(entity.get_player_weapon(me), "m_flNextPrimaryAttack")

				local dt_toggled = ui.get(ctx.ref.dt[1]) and ui.get(ctx.ref.dt[2])
				local dt_active = data.dt_charged  --or (ctx.helpers.defensive and ctx.helpers.defensive > ui.get(ctx.ref.dt_fl))

				if dt_toggled and dt_active then
					self.active_fraction = ctx.helpers:clamp(self.active_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.active_fraction = ctx.helpers:clamp(self.active_fraction - globals.frametime()/0.15, 0, 1)
				end

				if dt_toggled and not dt_active then
					self.inactive_fraction = ctx.helpers:clamp(self.inactive_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.inactive_fraction = ctx.helpers:clamp(self.inactive_fraction - globals.frametime()/0.15, 0, 1)
				end

				if ui.get(ctx.ref.hs[1]) and ui.get(ctx.ref.hs[2]) and ui.get(ctx.ref.silent) and not dt_toggled then
					self.hide_fraction = ctx.helpers:clamp(self.hide_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.hide_fraction = ctx.helpers:clamp(self.hide_fraction - globals.frametime()/0.15, 0, 1)
				end

				if math.max(self.hide_fraction, self.inactive_fraction, self.active_fraction) > 0 then
					self.fraction = ctx.helpers:clamp(self.fraction + globals.frametime()/0.2, 0, 1)
				else
					self.fraction = ctx.helpers:clamp(self.fraction - globals.frametime()/0.2, 0, 1)
				end

				local dt_size = renderer.measure_text("-", "DT ")
				local ready_size = renderer.measure_text("-", "READY")
				renderer.text(x/2 + ((dt_size + ready_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, self.active_fraction * 255, "c-", dt_size + self.active_fraction * ready_size + 1, "DT ", "\a" .. ctx.helpers:rgba_to_hex(210, 255, 120, 255 * self.active_fraction) .. "READY")

				local charging_size = renderer.measure_text("-", "CHARGING")
				local ret = ctx.helpers:animate_text(globals.curtime(), "CHARGING", 255, 100, 100, 255)
				renderer.text(x/2 + ((dt_size + charging_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, self.inactive_fraction * 255, "c-", dt_size + self.inactive_fraction * charging_size + 1, "DT ", unpack(ret))

				local hide_size = renderer.measure_text("-", "HIDE ")
				local active_size = renderer.measure_text("-", "ACTIVE")
				renderer.text(x/2 + ((hide_size + active_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, self.hide_fraction * 255, "c-", hide_size + self.hide_fraction * active_size + 1, "HIDE ", "\a" .. ctx.helpers:rgba_to_hex(155, 155, 200, 255 * self.hide_fraction) .. "ACTIVE")
			
				local state_size = renderer.measure_text("-", '- ' .. string.upper(state) .. ' -')
				renderer.text(x/2 + ((state_size + 2)/2) * scoped_fraction, y/2 + 30 + 10 * ctx.helpers:easeInOut(self.fraction), 255, 255, 255, 255, "c-", 0, '- ' .. string.upper(state) .. ' -')
			end
		end
	}

    return ctx
end)()

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

        local r, g, b = 255, 255, 255--ui.get(menu.color3)

        if curr_text[2] then
            r, g, b = self.color.r, self.color.g, self.color.b--ui.get(menu.color3)
        end

        text = text .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, self.color.a, curr_text[1]) .. ' '
    end

    return text
end

function notify:render_bottom(index, visible_amount)
    local screen = screen_size()

    local prefix_style = ui.get(notif_prefix)

    local prefix_padding = 6
    local prefix_size = measure_text('c', prefix_style)
    
    if prefix_style == 'icon' then
        prefix_size = vector(notifs_icon:measure() - 12)
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

    if prefix_style == "icon" and notifs_icon then
        local color = ui.get(addons.scale_clr) and { r, g, b } or { 255, 255, 255 }
        
        notifs_icon:draw(x + offset + 1, y + 6, nil, 12 + ui.get(notif_size), color[1], color[2], color[3], a, true, "f")
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

client.set_event_callback("paint_ui", function()
    if type(gif1) ~= "nil" then
        if draw == true then
            load_a = lerp(load_a, 255, globals.frametime() * 1)
            load_a2 = lerp(load_a2, 30, globals.frametime() * 1)
	        local x, y = client.screen_size()
            local r,g,b,a = ui.get(menu.color3)
	        gif1:draw(globals.realtime()-start_time, x / 2 - 53, y / 2 - 52, gif1.width - 70, gif1.height - 70, r,g,b, load_a)
            renderer.text(x / 2, y / 2 + 65, 255,255,255,load_a, "c", 0, "amnesia is loading...")
            --renderer.rectangle(x / 2 - x, y / 2 - 540, x + 1000, y + 100, r,g,b,load_a2)
            client.delay_call(2, function() draw = false end)
        else
            load_a = lerp(load_a, 0, globals.frametime() * 3)
            local x, y = client.screen_size()
            local r,g,b,a = ui.get(menu.color3)
            load_a2 = lerp(load_a2, 0, globals.frametime() * 1)
	        gif1:draw(globals.realtime()-start_time, x / 2 - 53, y / 2 - 52, gif1.width - 70, gif1.height - 70, r,g,b, load_a)
            renderer.text(x / 2, y / 2 + 65, 255,255,255,load_a, "c", 0, "amnesia is loading...")
            --renderer.rectangle(x / 2 - x, y / 2 - 540, x + 1000, y + 100, r,g,b,load_a2)
        end
    end
end)

local r,g,b = ui.get(menu.color3)
ctx.notifications:new("welcome to amnesia ~ $"..build.."$ !", r,g,b)

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

local defensive_until = 0
local last_sim_time = 0
local vulnerable_ticks = 0
local last_origin = vector(0, 0, 0)

--- @return boolean boolean Returns true if the player can be hit by an enemy
local function is_vulnerable()
    for _, v in ipairs(entity.get_players(true)) do
        local flags = (entity.get_esp_data(v)).flags

        if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
            vulnerable_ticks = vulnerable_ticks + 1
            return true
        end
    end

    -- If we aren't vulnerable then we have been vulnerable for 0 ticks
    vulnerable_ticks = 0
    return false
end

--- @param local_player number The entindex of the local player
--- @return boolean boolean Returns true if defensive dt is currently active
local function is_defensive_active(local_player)
    local tickcount = globals.tickcount()
    local sim_time = toticks(entity.get_prop(local_player, "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time

    if sim_diff < 0 then
        defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
    end
    
    last_sim_time = sim_time

    return defensive_until > tickcount
end

function state:get_state(ent, cmd)
    local game_rules = entity.get_game_rules()

    local vulnerable = is_vulnerable()
    local enemies = entity.get_players(true)

    local weapon = entity.get_player_weapon(ent)
    if weapon == nil then return end

    local wpnclass = entity.get_classname(weapon)

    local in_knife = wpnclass:find("CKnife")

    local in_def = is_defensive_active(ent)

    local threat = client.current_threat()
    local height_to_threat = 0

    local is_moving = self:is_moving(ent)
    local is_crouching = self:is_crouching(ent)
    local in_air = self:in_air(ent)

    local origin = vector(entity.get_origin(ent))
    local breaking_lc = (last_origin - origin):length2dsqr() > 4096

    local hideshot_active = ui.get(reference.on_shot_aa[1]) and ui.get(reference.on_shot_aa[2])

    if cmd.chokedcommands == 0 then
        last_origin = origin
    end

    if threat then
        local threat_origin = vector(entity.get_origin(threat))
        height_to_threat = origin.z-threat_origin.z
    end

    if in_knife then
        return "knife"
    end

    if hideshot_active then
        return "hideshot"
    end

    if (entity.get_prop(game_rules, "m_fRoundStartTime") - globals.curtime()) > 0 then
        return "round-start"
    end

    if entity.get_prop(game_rules, "m_iRoundWinStatus") ~= 0 then
        return "round-end"
    end

    if #enemies == 0 then
        return "dormant"
    end

    if in_def then
        if math.random(0,1) == 1 then
            ui.set(reference.pitch, "up")
        else
            ui.set(reference.pitch, "off")
        end
    else
        ui.set(reference.pitch, "minimal")
    end

    if in_def then
        return "defensive"
    end

    if breaking_lc then
        return "breaking lc"
    end

    if state:fakelag() then
        return "fakelag"
    end

    if ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2]) then
        return "slow"
    end

    if in_air then
        cmd.force_defensive = true
        if is_crouching then
            return "air crouch"
        end

        return "air"
    end

    if vulnerable and vulnerable_ticks <= 16 then
        cmd.force_defensive = true
        return "on peek"
    end

    if is_crouching and is_moving then
        cmd.force_defensive = true
        return "crouch moving"
    end

    if is_crouching then
        cmd.force_defensive = true
        return "crouch"
    end

    if is_moving then
        return "run"
    end

    if not is_moving then
        return "stand"
    end

    return "global"
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

for i, v in next, {"stand","run","slow","crouch","crouch moving","air","air crouch","fakelag"} do
    presets_list[v] = {}
    preset_data[v] = {}
    addpreset(v, {30, 45, 61, 61}) -- default
end

client.set_event_callback("bullet_impact", function(e)

    if not entity.is_alive(entity.get_local_player()) then return end
    local ent = client.userid_to_entindex(e.userid)
    if ent ~= client.current_threat() then return end
    if entity.is_dormant(ent) or not entity.is_enemy(ent) then return end

    local ent_origin = { entity.get_prop(ent, "m_vecOrigin") }
    ent_origin[3] = ent_origin[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
    local local_head = { entity.hitbox_position(entity.get_local_player(), 0) }
    local closest = GetClosestPoint(ent_origin, { e.x, e.y, e.z }, local_head)
    local delta = { local_head[1]-closest[1], local_head[2]-closest[2] }
    local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)

    local inverted = (math.floor(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60))

    local r,g,b,a = ui.get(menu.color3)

    local col = rgba_to_hex(r,g,b,a)
    local state = aa_lol.state

    if not ui.get(menu.antiaim_mode) == "dynamic" then return nil end
    if math.abs(delta_2d) <= 45 and globals.curtime() - lastmiss > 0.015 then

        ctx.notifications:new("changed ['$tick speed$'] due to $bullet$ from $"..entity.get_player_name(ent):lower().."$ !", r,g,b)

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
    local r,g,b,a = ui.get(menu.color3)

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
    local team = ui.get(menu.team_mode)
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
    --print(json.stringify(cfg))
    clipboard.set(json.stringify(cfg))

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
    client.color_log(r,g,b, "amnesia \0")
    client.color_log(110, 110, 110, "~ \0")
    client.color_log(200,200,200, text)
end

local function handle_buttons()
    local show_aa = ui.get(menu.tabs) == "anti-aim"
    if ui.get(menu.aa_addons) == "builder" and show_aa then
        ui[protected[1]](export_button, true)
        ui[protected[1]](import_button, true)
    else
        ui[protected[1]](export_button, false)
        ui[protected[1]](import_button, false)
    end
end

client.set_event_callback(protected[5], handle_buttons)

local jitter = true
local desync = true
local counter = 0
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
    if ui.get(addons.freestanding_key) then return end

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

local pop_up = {
    icon_w = -12,
    text_size = 1,
    text_size_2 = 1,
    bar_y = 160,
    bar_y_2 = 161,
    bar_lenght = 0,
    bar_alpha = 0
}

local cached = 0
local yaw_cache = 0
local yaw_t_cache = 0
local yaw_add = 0
local check1, defensive1 = 0, 0

client.set_event_callback("predict_command", function()
    local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
    defensive1 = math.abs(tickbase - check1)
    check1 = math.max(tickbase, check1 or 0)
end)

local swap = false

function aa_lol:preset_manager(left, right, cmd)

    local state = state:get_state(entity.get_local_player(), cmd)

    local delay = 8

    if state == "run" then
        delay = 10
    else
        delay = 8
    end

    if defensive1 % 3 == 1 then
        swap = not swap
    end

    if swap then
        if cmd.chokedcommands == 0 then
            ui.set(reference.body_yaw[2], -(math.random(50,150)))
            yaw_add = left
        end
    else
        if cmd.chokedcommands == 0 then
            ui.set(reference.body_yaw[2], (math.random(50,150)))
            yaw_add = right
        end
    end

    if self.manual_state == 1 then
        yaw_add = -90
    elseif self.manual_state == 2 then
        yaw_add = 90
    elseif self.manual_state == 3 then
        yaw_add = 180
    end

    local yaw_base = self.manual_state == 0 and "at targets" or "local view"

    ui.set(reference.yaw_base, yaw_base)
    ui.set(reference.yaw[1], "180")
    ui.set(reference.yaw[2], yaw_add)
    ui.set(reference.yaw_jitter[1], "off")
    ui.set(reference.yaw_jitter[2], 0)
    ui.set(reference.body_yaw[1], "Static")
end

local jitter = not jitter
local jitter2 = not jitter2

local custom_yaw_1 = ui.new_slider("lua", "b", "{custom} -> left yaw", -180,180,0)
local custom_yaw_2 = ui.new_slider("lua", "b", "{custom} -> right yaw", -180,180,0)
local custom_desync_t = ui.new_slider("lua", "b", "{custom} -> desync", -180,180,0)

local errorcheck = function()
    ui.reference("Visuals", "Other ESP", "Helper")
    return ui.reference("Visuals", "Other ESP", "Helper")
end

local function get_yaw(at_targets)
    local threat = client.current_threat()
    local _, yaw = client.camera_angles()
    if at_targets and threat then
        local pos =  vector(entity.get_origin(entity.get_local_player()))
        local epos = vector(entity.get_origin(threat))
        _, yaw = pos:to(epos):angles()
    end
    return yaw
end

local function custom_desync(cmd, side, at_targets, yaw_add, jitter_add, limit, velocity, state)
    local dt = ui.get(reference.dt[1]) and ui.get(reference.dt[2])
    local hs = ui.get(reference.on_shot_aa[1]) and ui.get(reference.on_shot_aa[2])
    local fd = ui.get(reference.fake_duck)
    local limit2 = 13
    if fd then
        limit2 = 13
    elseif dt then
        limit2 = 1
    elseif os then
        limit2 = 1
    end
    local send_packet = true

    if cmd.chokedcommands < limit2 then
        send_packet = false
    end
    
    local command_dif = cmd.command_number - cmd.chokedcommands - globals.lastoutgoingcommand()
    send_packet = send_packet or cmd.no_choke or not cmd.allow_send_packet or command_dif ~= 1
    cmd.allow_send_packet = send_packet

    jitter_add = switch and jitter_add/2 or -jitter_add/2

    local me = entity.get_local_player()

    local vel = entity.get_prop(me, "m_vecVelocity")
    local count = globals.tickcount()

    local can_desync = can_desync(cmd, me, count, vel)

    if not can_desync then
        return
    end
    if send_packet then
        local yaw = get_yaw(at_targets)
        cmd.yaw = yaw + 180 + yaw_add + jitter_add
        cmd.pitch = 89
        cmd.roll = 0
        if send_packet then
            switch = not switch
        end
    else
        local yaw = get_yaw(at_targets)
        if side == 2 then
            yaw_add = yaw_add + (limit*2) * (switch and -1 or 1)
        elseif side == 3 then
            yaw_add = yaw_add + (limit*2) * (globals.tickcount() % 4 < 2 and -1 or 1)
        else
            yaw_add = yaw_add + (limit*2) * (side == 1 and -1 or 1)
        end
        cmd.yaw = yaw + 180 + yaw_add + jitter_add
        cmd.pitch = 90
        cmd.roll = 0
    end

    ui.set(reference.body_yaw[1], "off")
    ui.set(reference.yaw[2], 0)

    local helper = ({errorcheck()})[2]
    if tostring(ui.get(helper)) ~= "false" then
        return
    end

    if not (cmd.in_forward == 1 or cmd.in_moveleft == 1 or cmd.in_moveright == 1 or cmd.in_back == 1 or cmd.in_jump == 1) and velocity < 1.2 then
        cmd.sidemove = switch and -1.01 or 1.01
    end
end

local timer = 0
local destination = 0
local dtmode = "defensive"
local enemy_cache = 0
local body_1 = 0
local body_2 = 0

local tickcount = 0
local def_index = 0

local e_help = {
    jitter = false,
	ready = false,
	cache = 0,
	delay = 0,
	check = 0,
	defensivetick = 0
}

function aa_lol:fastladder(arg, myself)
    if not ui.get(misc["miscellaneous"]["ladder"]) then return nil end
    if myself.m_MoveType ~= 9 then return nil end
    for k, v in pairs({43, 44, 45, 46, 47, 48}) do
        if myself:get_player_weapon():get_weapon_index() == v then return nil end
    end
    if arg.sidemove == 0 then
        arg.view_angles.y = arg.view_angles.y + 45
    end
    if arg.in_forward and arg.sidemove < 0 then
        arg.view_angles.y = arg.view_angles.y + 90
    end
    if arg.in_back and arg.sidemove > 0 then
        arg.view_angles.y = arg.view_angles.y + 90
    end
    arg.in_moveleft = arg.in_back
    arg.in_moveright = arg.in_forward
    if arg.view_angles.x < 0 then
        arg.view_angles.x = -45
    end
end

local cache = 0

local csgo_weapons = require("gamesense/csgo_weapons")

local get_velocity = function(ent)
    return vector(entity.get_prop(ent, "m_vecVelocity")):length()
end

aa_lol.movementjitter = function(e)
    local me = entity.get_local_player
    local weapon_ent = entity.get_player_weapon(me)
    if not weapon_ent then
        return
    end
    local weapon = csgo_weapons(weapon_ent)
    if not weapon then
        return
    end
    local velocity = get_velocity(me)
    local max_player_speed = (entity.get_prop(me, "m_bIsScoped") == 1) and weapon.max_player_speed_alt or weapon.max_player_speed
    local max_achieved = false
    local speed = max_achieved and max_player_speed or max_player_speed * 0.95
    if max_achieved then
        if velocity >= max_player_speed * 0.99 then
            max_achieved = false
        end
    elseif velocity <= max_player_speed * 0.95 then
        max_achieved = true
    end
    local helper = ({errorcheck()})[2]
    if tostring(ui.get(helper)) ~= "false" then
        return
    end
    cvar.cl_sidespeed:set_int(speed)
    cvar.cl_forwardspeed:set_int(speed)
    cvar.cl_backspeed:set_int(speed)
end

local hold_counter = 0
local hold_counter2 = 0
local hold_counter3 = 0
local hold_counter4 = 0

local delay_switch = 0

function aa_lol:aa(lp, cmd)

    if cmd.chokedcommands == 0 then
        hold_counter = hold_counter + 1
        hold_counter2 = hold_counter2 + 1
        hold_counter3 = hold_counter3 + 1
        hold_counter4 = hold_counter4 + 1
    end
    if hold_counter >= 5 then
        hold_counter = 0
    end
    if hold_counter2 >= 8 then
        hold_counter2 = 0
    end
    if hold_counter3 >= 8 then
        hold_counter3 = 5
    end

    if globals.tickcount() % 8 == 1 then
        delay_switch = not delay_switch
    end

    aa_lol.movementjitter(cmd)

    temp_fix(self.delta, cmd)

    self.choked = cmd.chokedcommands

    local state = state:get_state(lp, cmd)

    self.state = state

    local builder = menu.builder_elements[state]

    --this is omega ghetto pls...danish tech!!

    local yaw_base = self.manual_state == 0 and "at targets" or "local view"

    local yaw = "180"

    local desyncbodyyaw = entity.get_prop(lp, "m_flPoseParameter", 11) * 120 - 60
    local side = desyncbodyyaw > 0 and 1 or -1

    local bodyyaw = "jitter"
    local yawjit = "center"

    local team_num = entity.get_prop(lp, "m_iTeamNum")

    local tickbasee = entity.get_prop(entity.get_local_player(), "m_nTickBase")

    tickcount = tickcount + 1

    if tickcount > 9 then
        def_index = math.random(1,2)
        tickcount = 0
    end

    --if def_index == 1 then
    --    cmd.force_defensive = cmd.command_number % 6 ~= 1
   -- else
    --    cmd.force_defensive = defensive1 % 5 ~= 3
   -- end

    if ui.get(menu.aa_addons) == "builder" then

        if defensive1 % 3 == 1 then
            swap = not swap
        end

        local me = entity.get_local_player()

        local enemy2 = client.current_threat()

        local vel = entity.get_prop(me, "m_vecVelocity")
        local count = globals.tickcount()

        local allow_desync = can_desync(cmd, me, count, vel)

        if self.manual_state == 1 or self.manual_state == 2 or self.manual_state == 3 then
            if self.manual_state == 1 then
                yaw_add = -90
            elseif self.manual_state == 2 then
                yaw_add = 90
            elseif self.manual_state == 3 then
                yaw_add = 180
            end
            ui.set(reference.yaw_base, yaw_base)
            ui.set(reference.yaw[1], yaw)
            ui.set(reference.yaw[2], yaw_add)
            ui.set(reference.yaw_jitter[1], "off")
            ui.set(reference.yaw_jitter[2], 0)
            ui.set(reference.body_yaw[1], "static")
            ui.set(reference.body_yaw[2], 180)
        elseif ui.get(addons.freestanding_key) then
            ui.set(reference.yaw_base, yaw_base)
            ui.set(reference.yaw[1], yaw)
            ui.set(reference.yaw[2], 0)
            ui.set(reference.yaw_jitter[1], "off")
            ui.set(reference.yaw_jitter[2], 0)
            ui.set(reference.body_yaw[1], "static")
            ui.set(reference.body_yaw[2], 180)
        elseif ui.get(reference.fake_duck) then
            ui.set(reference.yaw_base, yaw_base)
            ui.set(reference.yaw[1], yaw)
            ui.set(reference.yaw[2], 0)
            ui.set(reference.yaw_jitter[1], "off")
            ui.set(reference.yaw_jitter[2], 0)
            ui.set(reference.body_yaw[1], "static")
            ui.set(reference.body_yaw[2], 180)
        elseif self.state == "fakelag" then
            ui.set(reference.yaw_base, yaw_base)
            ui.set(reference.yaw[1], yaw)
            ui.set(reference.yaw[2], 10)
            ui.set(reference.yaw_jitter[1], "Off")
            ui.set(reference.yaw_jitter[2], 65)
            ui.set(reference.body_yaw[1], "Jitter")
            ui.set(reference.body_yaw[2], 0)
        elseif team_num == 3 then
            ui.set(reference.freestanding_body_yaw, false)
            if ui.get(builder.yaw_mode) == "async" and not is_fake_ducking then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.yaw[1], yaw)
                if cmd.command_number % ui.get(builder.delay) < (ui.get(builder.delay) / 2) then
                    if cmd.chokedcommands == 0 then
                        ui.set(reference.body_yaw[2], -ui.get(builder.jitter_val))
                        ui.set(reference.yaw[2], math.random(ui.get(builder.yaw_left), ui.get(builder.yaw_left)-11))
                    end
                else
                    if cmd.chokedcommands == 0 then
                        ui.set(reference.body_yaw[2], ui.get(builder.jitter_val))
                        ui.set(reference.yaw[2], math.random(ui.get(builder.yaw_right), ui.get(builder.yaw_right)-11))
                    end
                end
                ui.set(reference.yaw_jitter[1], "Center")
                ui.set(reference.yaw_jitter[2], 0)
                ui.set(reference.body_yaw[1], "Static")
            elseif ui.get(builder.yaw_mode) == "advanced" then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.body_yaw[1], "Static")
                ui.set(reference.yaw[1], yaw)
                ui.set(reference.yaw_jitter[1], "Off")
                ui.set(reference.yaw_jitter[2], 0)

                if cmd.command_number % math.random(3,6) == 1 then
                    ready = true
                end
                
                if ready and cmd.chokedcommands == 0 then
                    ready = false
                    jitter = not jitter
                    ui.set(reference.body_yaw[1], "Static")
                    ui.set(reference.body_yaw[2], jitter and -180 or 180)
                    if jitter then
                        cache = ui.get(builder.yaw_left)
                    else
                        cache = ui.get(builder.yaw_right)
                    end
                end
                ui.set(reference.yaw[2], cache)
            elseif ui.get(builder.yaw_mode) == "advanced(+)" then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.body_yaw[1], "Static")
                ui.set(reference.yaw[1], yaw)
                ui.set(reference.yaw_jitter[1], "Off")
                ui.set(reference.yaw_jitter[2], 0)

                if cmd.command_number % (7+1) == 1 then
                    ready = true
                end
                
                if ready and cmd.chokedcommands == 0 then
                    ready = false
                    jitter = not jitter
                    ui.set(reference.body_yaw[1], "Static")
                    ui.set(reference.body_yaw[2], jitter and -180 or 180)
                    if jitter then
                        cache = ui.get(builder.yaw_left)
                    else
                        cache = ui.get(builder.yaw_right)
                    end
                end
                ui.set(reference.yaw[2], cache)
            elseif ui.get(builder.yaw_mode) == "interval" then
                if hold_counter2 == 0 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_right)
                elseif hold_counter2 == 1 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_left)
                elseif hold_counter2 == 2 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_left)
                elseif hold_counter2 == 3 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_left)
                elseif hold_counter2 == 4 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_right)
                    ui.set(reference.yaw[2], ui.get(builder.yaw_right))
                elseif hold_counter2 == 5 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_left)
                elseif hold_counter2 == 6 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_right)
                elseif hold_counter2 == 7 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_right)
                end

                custom_desync(cmd, 2, true, cache, 0, ui.get(builder.jitter_val), get_velocity(lp), state)
            elseif ui.get(builder.yaw_mode) == "light" then
                cache = globals.tickcount() % 3 == 0 and ui.get(builder.yaw_left) or ui.get(builder.yaw_right)

                custom_desync(cmd, 0, true, cache, 0, ui.get(builder.jitter_val), get_velocity(lp), state)
            elseif ui.get(builder.yaw_mode) == "delay" then
                cache = delay_switch and ui.get(builder.yaw_left) or ui.get(builder.yaw_right)
                custom_desync(cmd, 0, true, cache, 0, ui.get(builder.jitter_val), get_velocity(lp), state)
            elseif ui.get(builder.yaw_mode) == "l / r" then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.yaw[1], yaw)
                if side == 1 and cmd.chokedcommands == 0 then
                    ui.set(reference.yaw[2], ui.get(builder.yaw_left))
                elseif side == -1 and cmd.chokedcommands == 0 then
                    ui.set(reference.yaw[2], ui.get(builder.yaw_right))
                end
                ui.set(reference.yaw_jitter[1], "Off")
                ui.set(reference.yaw_jitter[2], 0)
                ui.set(reference.body_yaw[1], "Jitter")
                ui.set(reference.body_yaw[2], ui.get(builder.jitter_val))
            end
        elseif team_num == 2 and ui.get(builder.enable_state_t) then
            ui.set(reference.freestanding_body_yaw, false)
            if ui.get(builder.yaw_mode_t) == "async" and not is_fake_ducking then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.yaw[1], yaw)
                if cmd.command_number % ui.get(builder.delay_t) < (ui.get(builder.delay_t) / 2) then
                    if cmd.chokedcommands == 0 then
                        ui.set(reference.body_yaw[2], -ui.get(builder.jitter_val_t))
                        ui.set(reference.yaw[2], math.random(ui.get(builder.yaw_left_t), ui.get(builder.yaw_left_t)-11))
                    end
                else
                    if cmd.chokedcommands == 0 then
                        ui.set(reference.body_yaw[2], ui.get(builder.jitter_val_t))
                        ui.set(reference.yaw[2], math.random(ui.get(builder.yaw_right_t), ui.get(builder.yaw_right_t)-11))
                    end
                end
                ui.set(reference.yaw_jitter[1], "Center")
                ui.set(reference.yaw_jitter[2], 0)
                ui.set(reference.body_yaw[1], "Static")
            elseif ui.get(builder.yaw_mode_t) == "advanced" then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.body_yaw[1], "Static")
                ui.set(reference.yaw[1], yaw)
                ui.set(reference.yaw_jitter[1], "Off")
                ui.set(reference.yaw_jitter[2], 0)

                if cmd.command_number % math.random(3,6) == 1 then
                    ready = true
                end

                if ready and cmd.chokedcommands == 0 then
                    ready = false
                    jitter = not jitter
                    ui.set(reference.body_yaw[1], "Static")
                    ui.set(reference.body_yaw[2], jitter and -180 or 180)
                    if jitter then
                        cache = ui.get(builder.yaw_left_t)
                    else
                        cache = ui.get(builder.yaw_right_t)
                    end
                end
                ui.set(reference.yaw[2], cache)
            elseif ui.get(builder.yaw_mode_t) == "advanced(+)" then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.body_yaw[1], "Static")
                ui.set(reference.yaw[1], yaw)
                ui.set(reference.yaw_jitter[1], "Off")
                ui.set(reference.yaw_jitter[2], 0)

                if cmd.command_number % (7+1) == 1 then
                    ready = true
                end

                if ready and cmd.chokedcommands == 0 then
                    ready = false
                    jitter = not jitter
                    ui.set(reference.body_yaw[1], "Static")
                    ui.set(reference.body_yaw[2], jitter and -180 or 180)
                    if jitter then
                        cache = ui.get(builder.yaw_left_t)
                    else
                        cache = ui.get(builder.yaw_right_t)
                    end
                end
                ui.set(reference.yaw[2], cache)
            elseif ui.get(builder.yaw_mode_t) == "interval" then
                if hold_counter2 == 0 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_right_t)
                elseif hold_counter2 == 1 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_left_t)
                elseif hold_counter2 == 2 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_left_t)
                elseif hold_counter2 == 3 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_left_t)
                elseif hold_counter2 == 4 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_right_t)
                    ui.set(reference.yaw[2], ui.get(builder.yaw_right_t))
                elseif hold_counter2 == 5 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_left_t)
                elseif hold_counter2 == 6 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_right_t)
                elseif hold_counter2 == 7 and cmd.chokedcommands == 1 then
                    cache = ui.get(builder.yaw_right_t)
                end

                custom_desync(cmd, 2, true, cache, 0, ui.get(builder.jitter_val_t), get_velocity(lp), state)
            elseif ui.get(builder.yaw_mode_t) == "light" then
                cache = globals.tickcount() % 3 == 0 and ui.get(builder.yaw_left_t) or ui.get(builder.yaw_right_t)

                custom_desync(cmd, 0, true, cache, 0, ui.get(builder.jitter_val_t), get_velocity(lp), state)
            elseif ui.get(builder.yaw_mode_t) == "delay" then
                cache = delay_switch and ui.get(builder.yaw_left_t) or ui.get(builder.yaw_right_t)
                custom_desync(cmd, 0, true, cache, 0, ui.get(builder.jitter_val_t), get_velocity(lp), state)
            elseif ui.get(builder.yaw_mode_t) == "l / r" then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.yaw[1], yaw)
                if side == 1 and cmd.chokedcommands == 0 then
                    ui.set(reference.yaw[2], ui.get(builder.yaw_left_t))
                elseif side == -1 and cmd.chokedcommands == 0 then
                    ui.set(reference.yaw[2], ui.get(builder.yaw_right_t))
                end
                ui.set(reference.yaw_jitter[1], "Off")
                ui.set(reference.yaw_jitter[2], 0)
                ui.set(reference.body_yaw[1], "Jitter")
                ui.set(reference.body_yaw[2], ui.get(builder.jitter_val_t))
            end
        else
            local global_builder = menu.builder_elements["global"]
            ui.set(reference.freestanding_body_yaw, false)
            if ui.get(global_builder.yaw_mode_t) == "async" and not is_fake_ducking then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.yaw[1], yaw)
                if cmd.command_number % ui.get(global_builder.delay_t) < (ui.get(global_builder.delay_t) / 2) then
                    if cmd.chokedcommands == 0 then
                        ui.set(reference.body_yaw[2], -ui.get(global_builder.jitter_val_t))
                        ui.set(reference.yaw[2], ui.get(global_builder.yaw_left_t))
                    end
                else
                    if cmd.chokedcommands == 0 then
                        ui.set(reference.body_yaw[2], ui.get(global_builder.jitter_val_t))
                        ui.set(reference.yaw[2], ui.get(global_builder.yaw_right_t))
                    end
                end
                ui.set(reference.yaw_jitter[1], "Center")
                ui.set(reference.yaw_jitter[2], 0)
                ui.set(reference.body_yaw[1], "Static")
            elseif ui.get(global_builder.yaw_mode_t) == "advanced" then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.body_yaw[1], "Static")
                ui.set(reference.yaw[1], yaw)
                ui.set(reference.yaw_jitter[1], "Off")
                ui.set(reference.yaw_jitter[2], 0)

                if cmd.command_number % math.random(3,6) == 1 then
                    ready = true
                end

                if ready and cmd.chokedcommands == 0 then
                    ready = false
                    jitter = not jitter
                    ui.set(reference.body_yaw[1], "Static")
                    ui.set(reference.body_yaw[2], jitter and -180 or 180)
                    if jitter then
                        cache = ui.get(global_builder.yaw_left_t)
                    else
                        cache = ui.get(global_builder.yaw_right_t)
                    end
                end
                ui.set(reference.yaw[2], cache)
            elseif ui.get(global_builder.yaw_mode_t) == "advanced(+)" then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.body_yaw[1], "Static")
                ui.set(reference.yaw[1], yaw)
                ui.set(reference.yaw_jitter[1], "Off")
                ui.set(reference.yaw_jitter[2], 0)

                if cmd.command_number % (7+1) == 1 then
                    ready = true
                end

                if ready and cmd.chokedcommands == 0 then
                    ready = false
                    jitter = not jitter
                    ui.set(reference.body_yaw[1], "Static")
                    ui.set(reference.body_yaw[2], jitter and -180 or 180)
                    if jitter then
                        cache = ui.get(global_builder.yaw_left_t)
                    else
                        cache = ui.get(global_builder.yaw_right_t)
                    end
                end
                ui.set(reference.yaw[2], cache)
            elseif ui.get(global_builder.yaw_mode_t) == "light" then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.yaw[1], yaw)
                if globals.tickcount() % 3 == 0 then
                    ui.set(reference.yaw[2], ui.get(global_builder.yaw_left_t))
                else
                    ui.set(reference.yaw[2], ui.get(global_builder.yaw_right_t))
                end
                ui.set(reference.yaw_jitter[1], "Off")
                ui.set(reference.yaw_jitter[2], 0)
                ui.set(reference.body_yaw[1], "Jitter")
                ui.set(reference.body_yaw[2], ui.get(global_builder.jitter_val_t))
            elseif ui.get(global_builder.yaw_mode_t) == "l / r" then
                ui.set(reference.yaw_base, yaw_base)
                ui.set(reference.yaw[1], yaw)
                if swap then
                    ui.set(reference.yaw[2], ui.get(global_builder.yaw_left_t))
                else
                    ui.set(reference.yaw[2], ui.get(global_builder.yaw_right_t))
                end
                ui.set(reference.yaw_jitter[1], "Off")
                ui.set(reference.yaw_jitter[2], 0)
                ui.set(reference.body_yaw[1], "Jitter")
                ui.set(reference.body_yaw[2], ui.get(global_builder.jitter_val_t))
            end
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
    --self:bruteforce(cmd)

    local is_dt = ui.get(reference.dt[1]) and ui.get(reference.dt[2])

    local in_air = state:in_air(lp) 
    
    --defensive_indicator()
end

client.set_event_callback('setup_command', function(cmd)
    aa_lol:run(cmd)
end)

local hotkeys = {
	manual_last_pressed = globals.realtime()
}

function hotkeys:run(cmd)

    local lp = entity[protected[7]]()

    local freestanding = ui.get(addons.freestanding_key)

    local disablers = ui.get(addons.freestanding_disablers)

    local in_air = state:in_air(lp)
    local is_moving = state:is_moving(lp)
    local is_crouching = state:is_crouching(lp)
    local is_slowwalking = ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2])
    local is_fake_ducking = ui.get(reference.fake_duck)

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

    if aa_lol.manual_state == 1 or aa_lol.manual_state == 2 or aa_lol.manual_state == 3 then
        freestanding = false
        ui.set(reference.freestanding[2], false)
    else
        ui.set(reference.freestanding[2], true)
    end

    ui.set(reference.freestanding[1], freestanding and true)

	local edge_yaw = ui.get(addons.edge_yaw_key)

	ui.set(reference.edge_yaw, edge_yaw)

	ui.set(addons.manual_left_key, "on hotkey")
	ui.set(addons.manual_right_key, "on hotkey")
	ui.set(addons.manual_forward_key, "on hotkey")

	local curtime = globals.realtime()

	if self.manual_last_pressed + 0.2 > curtime then return end

	if ui.get(addons.manual_left_key) and aa_lol.manual_state ~= 1 then
		aa_lol.manual_state = 1
		self.manual_last_pressed = curtime
	elseif ui.get(addons.manual_right_key) and aa_lol.manual_state ~= 2 then
		aa_lol.manual_state = 2
		self.manual_last_pressed = curtime
	elseif ui.get(addons.manual_forward_key) and aa_lol.manual_state ~= 3 then
		aa_lol.manual_state = 3
		self.manual_last_pressed = curtime
	elseif ui.get(addons.manual_left_key) or ui.get(addons.manual_right_key) or ui.get(addons.manual_forward_key) then
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

	--if ui.get(enable_legs) then
		--self:static_legs(player)
	--end
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

local helpers = {
    colored_single_text = function(r1, g1, b1, a1, text, r2, g2, b2, a2)
        local output = ''

        output = ('\a%02x%02x%02x%02x%s\a%02x%02x%02x%02x'):format(r1, g1, b1, a1, text, r2, g2, b2, a2)

        return output
    end
}

client.set_event_callback('paint', function()

    local r, g, b, a = ui.get(menu.color3)

    local x, height = client.screen_size()

    local dpi_scale = nil

    local font = ''

    local text = ''

    local offset, h = 12, math.floor(21)

    local h = h + 3

    local lua_name = 'amnesia.lol ['..build..']'
    local username = username

    wt2 = lerp(wt2, 255, globals.frametime() * 2)

    local name_txt = helpers.colored_single_text( r, g, b, 255, lua_name, 255, 255, 255, 255 )
    local latency = client.latency() * 1000
    local latencytext = ('%d'):format(latency)
    local latency_text = helpers.colored_single_text( r, g, b, 255, latencytext, 255, 255, 255, 255 )

    local sys_time = { client.system_time() }
    local actual_time = ('%02d:%02d'):format(sys_time[1] % 12, sys_time[2])
    local actual_time_text = helpers.colored_single_text( r, g, b, 255, actual_time, 255, 255, 255, 255 )
    local time_format = sys_time[1] > 12 and 'pm' or 'am'

    text = ('%s  / %s  %s ms %s %s'):format(name_txt, username, latency_text, actual_time_text, time_format)

    local text_size = { renderer.measure_text(font, text) }
    local w = text_size[1] + 7 + 7

    if ui.get(addons.enable_visuals) then
		wt1 = lerp(wt1, 255, globals.frametime() * 1)

        Render_engine.pandora_rectangle(x - w - offset, offset, w, h, 40, 40, 40, wt1, 0, 0, 0, wt1, 15, 15, 15, wt1, r, g, b, 13, 3, true)

        renderer.text(x - w / 2 - offset, offset + h / 2, 255, 255, 255, wt1, 'c' .. font, nil, text)
    elseif not ui.get(addons.enable_visuals) then
        wt2 = lerp(wt2, 0, globals.frametime() * 2)
		wt1 = lerp(wt1, 0, globals.frametime() * 1)

        renderer[protected[10]](x / 2 - 70, height - 22, 255, 255, 255, 155, "", nil, "enhanced by amnesia.lol"..gradient_text_anim(" ["..username.."]", 0,0,0,155, r,g,b,155, 2.2, 0 ))
    end
end)

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

local indicators_tb = {}

client.set_event_callback('indicator', function(indicator)
    if indicator.text == "DT" then
        data.dt_charged = (indicator.r == 255 and indicator.g == 255 and indicator.b == 255)
    end
    indicators_tb[#indicators_tb + 1] = indicator
end)

local dt_enable, dt_hotkey = ui.reference("RAGE", "aimbot", "Double tap")

client.set_event_callback('paint_ui', function()
    local h = select(2, client.screen_size())
    
    local starting = h - 350

    for index, indicator in pairs(indicators_tb) do index = index - 1 -- this is how you fix lua tables lol
        local width, height = renderer.measure_text('d+', indicator.text)
        local offset = index * (height - 5)

        local gradient_width = math.floor(width / 2)
        
        local y = starting - offset

       -- renderer.gradient(10                 , y, gradient_width, height + 4, 0, 0, 0, 0, 0, 0, 0, 50, true)
       -- renderer.gradient(10 + gradient_width, y, gradient_width, height + 4, 0, 0, 0, 50, 0, 0, 0, 0, true)
        renderer.text(10, y + 2, indicator.r, indicator.g, indicator.b, indicator.a, 'd+', 0, indicator.text)
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

    local color_ref = { ui.get(menu.color3) }

    local color = { r = color_ref[1], g = color_ref[2], b = color_ref[3], a = color_ref[4] }

    local frametime = globals.frametime()

    local r, g, b, a = ui.get(menu.color3)

    if data.dt_charged then
        charge = true
    end

    local dt_text = ""

    local dt_color = {r = 255, g = 255, b = 255, a= 255}

    local fd_on = ui.get(reference.fake_duck)

    if data.dt_charged then
        dt_text = "READY"
        dt_color = {r = 160, g = 235, b = 136, a= 255}
        dt_size = lerp(dt_size, 50, globals.frametime() * 5)
    --elseif globals.tickcount() <= data.defensive_active_until then
    --    dt_text = "ACTIVE"
     --   dt_color = {r = 135, g = 189, b = 255, a= 255}
     --   dt_size = lerp(dt_size, 60, globals.frametime() * 5)
    elseif fd_on then
        dt_text = "BLOCKED"
        dt_color = {r = 255, g = 0, b = 0, a= 255}
        dt_size = lerp(dt_size, 90, globals.frametime() * 5)
    else
        dt_text = "CHARGING"
        dt_color = {r = 255, g = 0, b = 0, a= 255}
        dt_size = lerp(dt_size, 90, globals.frametime() * 5)
    end

    --local charge = data.tickbase.shifting ~= 0

    local exploiting = (ui.get(reference.dt[1]) and ui.get(reference.dt[2])) or (ui.get(reference.on_shot_aa[1]) and ui.get(reference.on_shot_aa[2]))
    local inverted = (math.floor(math.min(60, (entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60)))) > 0
    local delta = math.floor(aa.get_desync(1))

    self.addons.indicators.charge_col = fade_col(self.addons.indicators.charge_col, dt_color, globals.frametime() * 9)

    local col = {
        on = { r = r, g = g, b = b, a = 255 },
        off = { r = 255, g = 255, b = 255, a = 100 },
        main = { r = r, g = g, b = b, a = 255 },
    }

    local hex = {
        on = "\a" .. to_hex(col.on.r, col.on.g, col.on.b, col.on.a),
        off = "\a" .. to_hex(col.off.r, col.off.g, col.off.b, col.off.a),
        charge = "\a" .. to_hex(self.addons.indicators.charge_col.r, self.addons.indicators.charge_col.g, self.addons.indicators.charge_col.b, self.addons.indicators.charge_col.a),
    }

    local offset = { x = 0, y = 0 }

    local scoped = entity.get_prop(local_player, 'm_bIsScoped') == 1

    local doubletap = ui.get(reference.dt[1]) and ui.get(reference.dt[2])

    local hideshots = ui.get(reference.on_shot_aa[1]) and ui.get(reference.on_shot_aa[2])

    local scope_fraction = ease.quad_in_out(amnesia_lerp, 0, 1, 1)
    amnesia_lerp = clamp(amnesia_lerp + (scoped and frametime * 2.5 or -frametime * 2.5), 0, 1)

    local text = "AMNESIA  " .. gradient_text_anim("YAW", r,g,b,255, r,g,b,255, 0, 0 )

    local ind_offset = 0

    local text_size = vector(renderer.measure_text('-', text))

    local state_size = vector(renderer.measure_text("-", aa_lol.state:upper():gsub("RUN", "RUNNING")))

    local scope_text = math.floor(-(text_size.x / 2) * (1 - scope_fraction) + 2 * scope_fraction)
    local scope_text2 = math.floor(-(state_size.x / 2 - 2) * (1 - scope_fraction) + 8 * scope_fraction)

    visuals.size = ease.quad_out(globals.frametime(), visuals.size, (state_size.x + 10) - visuals.size, 0.4)
    
    dash_pos = ease.quad_out(globals.frametime(), dash_pos, (scope_text2 - 5.9) - dash_pos, 0.15)
    dash_pos2 = ease.quad_out(globals.frametime(), dash_pos2, (scope_text2 + state_size.x - 0.9) - dash_pos2, 0.15)

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
        [2] = { active = ui.get(reference.on_shot_aa[1]) and ui.get(reference.on_shot_aa[2]), text = 'HIDESHOT', color = { r = 255, g = 255, b = 255, a = 255 } },
        [3] = { active = ui.get(addons.freestanding_key), text = 'FREESTAND', color = { r = 255, g = 255, b = 255, a = 255 } },
        [4] = { active = ui.get(reference.forcesp), text = 'SAFE', color = { r = 255, g = 255, b = 255, a = 255 } },
        [5] = { active = speed_mod, text = 'SLOW: '..math.floor(modifier*100).."%", color = { r = 255, g = 255, b = 255, a = 255 } },
        [6] = { active = ui.get(reference.fake_duck), text = 'DUCK', color = { r = 255, g = 255, b = 255, a = 255 } }
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

        self.addons.indicators.charge_col.a = bind.color.a * alpha

        renderer.text(pos.x + adaptive_pos, pos.y + ind_offset + 25, bind.color.r, bind.color.g, bind.color.b, bind.color.a * alpha, 'c-', dt_size, bind.text)

        ind_offset = ind_offset + 10 * alpha
        test_pos_y = ind_offset
        ::skip::
    end
end

local vel_y = 600
local vel_y_t = 600
local vel_y_t2 = 600
local vel_a = 0
local vel_a2 = 0

local images = require "gamesense/images"
local warning = images.get_panorama_image("icons/ui/warning.svg")


local script = {}

script.helpers = {
    defensive = 0,
    checker = 0,

    easeInOut = function(self, t)
        return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
    end,

    clamp = function(self, val, lower, upper)
        assert(val and lower and upper, "not very useful error message here")
        if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
        return math.max(lower, math.min(upper, val))
    end,

    split = function(self, inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
    end,

    rgba_to_hex = function(self, r, g, b, a)
      return bit.tohex(
        (math.floor(r + 0.5) * 16777216) + 
        (math.floor(g + 0.5) * 65536) + 
        (math.floor(b + 0.5) * 256) + 
        (math.floor(a + 0.5))
      )
    end,

    hex_to_rgba = function(self, hex)
    local color = tonumber(hex, 16)

    return 
    math.floor(color / 16777216) % 256, 
    math.floor(color / 65536) % 256, 
    math.floor(color / 256) % 256, 
    color % 256
    end,

    color_text = function(self, string, r, g, b, a)
        local accent = "\a" .. self:rgba_to_hex(r, g, b, a)
        local white = "\a" .. self:rgba_to_hex(255, 255, 255, a)

        local str = ""
        for i, s in ipairs(self:split(string, "$")) do
            str = str .. (i % 2 ==( string:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
        end

        return str
    end,

    animate_text = function(self, time, string, r, g, b, a)
        local t_out, t_out_iter = { }, 1

        local l = string:len( ) - 1

        local r_add = (255 - r)
        local g_add = (255 - g)
        local b_add = (255 - b)
        local a_add = (155 - a)

        for i = 1, #string do
            local iter = (i - 1)/(#string - 1) + time
            t_out[t_out_iter] = "\a" .. script.helpers:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )

            t_out[t_out_iter + 1] = string:sub( i, i )

            t_out_iter = t_out_iter + 2
        end

        return t_out
    end,

    get_time = function(self, h12)
        local hours, minutes, seconds = client.system_time()

        if h12 then
                local hrs = hours % 12

                if hrs == 0 then
                        hrs = 12
                else
                        hrs = hrs < 10 and hrs or ('%02d'):format(hrs)
                end

                return ('%s:%02d %s'):format(
                        hrs,
                        minutes,
                        hours >= 12 and 'pm' or 'am'
                )
        end

        return ('%02d:%02d:%02d'):format(
                hours,
                minutes,
                seconds
        )
end,
}

prophesy = {
    table = {
        config_data = {};
        visuals = {
            picture = "https://cdn.discordapp.com/attachments/1110068391785529415/1110418348258365440/255px-Transgender_Pride_flag.png";
            image_loaded = "";
            animation_variables = {};
            new_change = true;
            to_draw_ticks = 0;
            offset_maxed2 = 0;
            indi_op = 0;
            offset_maxed = 0;
            indi_op2 = 0;
            indi_op3 = 0;
            indi_op4 = 0;
        };
    };
    reference = {};
    menu = {};
    anti_aim = {
        is_invert = false;
        tick_var = 0;
        cur_team = 0;
        state_id = 0;
        is_active_inds = 0;
        pitch = "";
        pitch_value = 0;
        yaw_base = "";
        yaw = "";
        yaw_value = 0;
        yaw_jitter = "";
        yaw_jitter_value = 0;
        body_yaw = "";
        body_yaw_value = 0;
        freestanding_body_yaw = false;
        freestanding = "";
        freestanding_value = 0;
        defensive_ct = false;
        defensive_t = false;
        is_active = false;
        last_press = 0;
        aa_dir = 0;
        defensive = false;
        defensive_ticks = 0;
        ground_time = 0;
        current_preset = 0;
    };
}


script.renderer = {
    rec = function(self, x, y, w, h, radius, color)
         radius = math.min(x/2, y/2, radius)
         local r, g, b, a = unpack(color)
         renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
         renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
         renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
         renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
         renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
         renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
         renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
     end,
 
     rec_outline = function(self, x, y, w, h, radius, thickness, color)
         radius = math.min(w/2, h/2, radius)
         local r, g, b, a = unpack(color)
         if radius == 1 then
             renderer.rectangle(x, y, w, thickness, r, g, b, a)
             renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
         else
             renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
             renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
             renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
             renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
             renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
             renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
             renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
             renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
         end
     end,
 
     glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
         local thickness = 1
         local offset = 1
         local r, g, b, a = unpack(accent)
         if accent_inner then
             self:rec(x , y, w, h + 1, rounding, accent_inner)
         end
         for k = 0, width do
             if a * (k/width)^(1) > 5 then
                 local accent = {r, g, b, a * (k/width)^(2)}
                 self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
             end
         end
     end
 }
 
 rounded_rectangle = function(x, y, r, g, b, a, width, height, radius)
    -- rectangles
  
    renderer.rectangle(x + radius, y, width - (radius * 2), radius, r, g, b, a)
    renderer.rectangle(x + radius, y + height - radius, width - (radius * 2), radius, r, g, b, a)
    renderer.rectangle(x, y + radius, radius, height - (radius * 2), r, g, b, a)
    renderer.rectangle(x + (width - radius), y + radius, radius, height - (radius * 2), r, g, b, a)

    -- circles
    renderer.circle(x + radius, y + radius, r, g, b,a, radius, 145, radius * 0.1)
    renderer.circle(x + width - radius, y + radius, r, g, b, a, radius, 90, radius * 0.1)
    renderer.circle(x + radius, y + height - radius, r, g, b, a, radius, 180, radius * 0.1)
    renderer.circle(x + width - radius, y + height - radius, r, g, b, a, radius, 0, radius * 0.1)
end


defensive_opa = 0
defensive_opa2 = 0
defensive_opa3 = 0
local screen = {client.screen_size()}

function visuals:run_indicators()
    local screen_size = vector(client.screen_size())

    local ind_height = 20

    local pos = { x = screen_size.x / 2, y = screen_size.y / 2 + ind_height }

	self.screen_width, self.screen_height = client.screen_size()

    self.r, self.g, self.b = ui.get(menu.color3)

    --if not ui.get(menu.addons.enable_visuals) then return end

    local lp = entity[protected[7]]()

    if not lp or not entity.is_alive(lp) then return end

    if ui.get(addons.indicators) == "amnesia" and ui.get(addons.enable_indicators) then
        --visuals:draw_center2()
        ctx.indicators:render()
    end

    if ui.get(addons.enable_defensive) then
        
        X,Y = screen[1], screen[2]
        value2 = 0
        draw_art = to_draw_ticks * 98 / 175
        if is_active then
            value2 = 0.4
        else value2 = 5 
        end
        
        is_active = true -- bindy
        if is_active then
            defensive_opa = script.helpers:clamp(defensive_opa + globals.frametime()/0.4, 0, 1)
            defensive_opa2 = script.helpers:clamp(defensive_opa2 + globals.frametime()/0.15, 0, 1)
            defensive_opa3 =  script.helpers:clamp(defensive_opa2 + globals.frametime()/0.15, 0, 1)
        else
            defensive_opa = script.helpers:clamp(defensive_opa - globals.frametime()/0.25, 0, 1)
            defensive_opa2 = script.helpers:clamp(defensive_opa2 - globals.frametime()/0.25, 0, 1)
            defensive_opa3 = script.helpers:clamp(defensive_opa2 - globals.frametime()/0.25, 0, 1)
        end
       
        --local r, g, b = {255,255,255}
        if to_draw == "yes" then
            local jedi_icon = '<svg t="1650815150236" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1757" width="1000" height="1000"><path d="M398.5 373.6c95.9-122.1 17.2-233.1 17.2-233.1 45.4 85.8-41.4 170.5-41.4 170.5 105-171.5-60.5-271.5-60.5-271.5 96.9 72.7-10.1 190.7-10.1 190.7 85.8 158.4-68.6 230.1-68.6 230.1s-.4-16.9-2.2-85.7c4.3 4.5 34.5 36.2 34.5 36.2l-24.2-47.4 62.6-9.1-62.6-9.1 20.2-55.5-31.4 45.9c-2.2-87.7-7.8-305.1-7.9-306.9v-2.4 1-1 2.4c0 1-5.6 219-7.9 306.9l-31.4-45.9 20.2 55.5-62.6 9.1 62.6 9.1-24.2 47.4 34.5-36.2c-1.8 68.8-2.2 85.7-2.2 85.7s-154.4-71.7-68.6-230.1c0 0-107-118.1-10.1-190.7 0 0-165.5 99.9-60.5 271.5 0 0-86.8-84.8-41.4-170.5 0 0-78.7 111 17.2 233.1 0 0-26.2-16.1-49.4-77.7 0 0 16.9 183.3 222 185.7h4.1c205-2.4 222-185.7 222-185.7-23.6 61.5-49.9 77.7-49.9 77.7z" p-id="1758" fill="#ffffff"></path></svg>'
           -- local jedi_icon2 = renderer.load_svg(jedi_icon,50,50)
            script.renderer:glow_module(X / 2 - 55, Y / 2 - 220, defensive_opa * 110, 0, 10, 0, {r, g, b, defensive_opa * 100}, {r, g, b, defensive_opa * 100})
            rounded_rectangle(X / 2 - 55, Y / 2 - 220, 255, 255, 255, defensive_opa * 140, draw_art, 2, 1)
            charged_mes = renderer.measure_text("", "defensive manager ") + renderer.measure_text("", "ready  ")
            exploit_mes = renderer.measure_text("", "defensive manager ") 
            local ret = script.helpers:animate_text(globals.curtime(), "ready", 255, 255, 2, defensive_opa2 * 255)
            renderer.text(X / 2, Y / 2 - 232,255, 255, 255, defensive_opa2 * 255, "c",  defensive_opa2 * charged_mes + 1, "defensive manager ", unpack(ret))
            renderer.texture(jedi_icon2, X/2 - 11, Y/2 - 260, 50, 50, r, g, b, defensive_opa * 220, 'f')
            to_draw_ticks = to_draw_ticks + 4
            if to_draw_ticks == 200 then
                to_draw_ticks = 0
                to_draw = "no"
            end
        end
    end

    local modifier = entity.get_prop(lp, "m_flVelocityModifier")

	if modifier == 1 then
        speed_mod = false
    else
        speed_mod = true
    end

    if speed_mod then

        vel_y = lerp(vel_y, 649.9, globals.frametime() * 11)
        vel_y_t = lerp(vel_y_t, 400.9, globals.frametime() * 11)
        vel_y_t2 = lerp(vel_y_t2, 411.9, globals.frametime() * 11)
        vel_a = lerp(vel_a, 255, globals.frametime() * 11)

        --vel_icon:draw(screen_size.x/2 - screen_size.x/3.8, screen_size.y - screen_size.y/2.74 - vel_y, nil, 540, 255, 255, 255, vel_a, true)
        renderer.text(pos.x - 3, pos.y - vel_y_t2, 255, 255, 255, vel_a, 'c', nil, "slowed down")
        renderer.text(pos.x, pos.y - vel_y_t, 255, 255, 255, 255, 'c', nil, gradient_text_anim(math.floor(modifier*100).."", 255,255,255,vel_a, r,g,b,vel_a, 2.2, 0 ).."%")
    elseif speed_mod == false  then 
        vel_a = lerp(vel_a, 0, globals.frametime() * 11)
        vel_y = lerp(vel_y, 700, globals.frametime() * 11)
        vel_y_t = lerp(vel_y_t, 500, globals.frametime() * 11)
        vel_y_t2 = lerp(vel_y_t2, 500, globals.frametime() * 11)
      --  vel_icon:draw(screen_size.x/2 - screen_size.x/3.8, screen_size.y - screen_size.y/2.74 - vel_y, nil, 540, 255, 255, 255, vel_a, true)
        renderer.text(pos.x - 3, pos.y - vel_y, 255, 255, 255, vel_a, 'c', nil, "slowed down")
        --renderer.text(pos.x, pos.y - vel_y_t, 255, 255, 255, 255, 'cb', nil, gradient_text_anim(math.floor(modifier*100).."", 255,255,255,vel_a, r,g,b,vel_a, 2.2, 0 ).."%")
    end

    --defensive_indicator_paint()
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
base64=require("gamesense/base64")signature_ginput=base64.decode("uczMzMyLQDj/0ITAD4U=")match=client.find_signature("client.dll",signature_ginput)or error("sig1 not found")g_input=ffi.cast("void**",ffi.cast("char*",match)+1)[0]or error("match is nil")g_inputclass=ffi.cast("void***",g_input)g_inputvtbl=g_inputclass[0]rawgetusercmd=g_inputvtbl[8]get_user_cmd=ffi.cast("get_user_cmd_t",rawgetusercmd)lastlocal=0;local function a(b)local c=get_user_cmd(g_inputclass,0,b.command_number)if ui.get(addons.reduce_ticks)then if lastlocal+0.9>globals.curtime()then c.tick_count=c.tick_count+8 else c.tick_count=c.tick_count+1 end end end;client.set_event_callback("setup_command",a)

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
    local r,g,b = ui.get(menu.color3)
    local color_out = rgba_to_hex2(r,g,b,0)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() and ui.get(menu.antiaim_mode) == "dynamic" then
        ctx.notifications:new("reset ['$dynamic$'] due to $death$ !", r,g,b)
        ctx.notifications:clear()
    end
end)

client.set_event_callback("round_start", function()
    lastlocal = 0
    local r,g,b,a = ui.get(menu.color3)
    local col = rgba_to_hex2(r,g,b,0)
    local me = entity.get_local_player()
    if not entity.is_alive(me) then return end
    if not ui.get(menu.antiaim_mode) == "dynamic" then return end
    ctx.notifications:new("reset ['$dynamic$'] due to $new round$ !", r,g,b)
    ctx.notifications:clear()
end)

client.set_event_callback("round_end", function()
    ctx.notifications:clear()
    --print("helooooo")
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

client.set_event_callback("paint", function()
    --notify:handler()
    ctx.notifications:render()
end)