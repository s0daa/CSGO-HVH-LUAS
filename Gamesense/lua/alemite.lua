--------------------------------------------------------------------------------
-- Dump Check
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Basic Libaries -> gamesense Libaries
--------------------------------------------------------------------------------
local anti_aim = require('gamesense/antiaim_funcs')
local vector = require("vector")
local build = "Beta"
--------------------------------------------------------------------------------
-- Basic Variables -> gamesense API
--------------------------------------------------------------------------------
local bit_band, bit_lshift, client_color_log, client_create_interface, client_delay_call, client_find_signature, client_key_state, client_reload_active_scripts, client_screen_size, client_set_event_callback, client_system_time, client_timestamp, client_unset_event_callback, database_read, database_write, entity_get_classname, entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_prop, entity_get_steam64, entity_is_alive, globals_framecount, globals_realtime, math_ceil, math_floor, math_max, math_min, panorama_loadstring, renderer_gradient, renderer_line, renderer_rectangle, table_concat, table_insert, table_remove, table_sort, ui_get, ui_is_menu_open, ui_mouse_position, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_slider, ui_set, ui_set_visible, setmetatable, pairs, error, globals_absoluteframetime, globals_curtime, globals_frametime, globals_maxplayers, globals_tickcount, globals_tickinterval, math_abs, type, pcall, renderer_circle_outline, renderer_load_rgba, renderer_measure_text, renderer_text, renderer_texture, tostring, ui_name, ui_new_button, ui_new_hotkey, ui_new_label, ui_new_listbox, ui_new_textbox, ui_reference, ui_set_callback, ui_update, unpack, tonumber = bit.band, bit.lshift, client.color_log, client.create_interface, client.delay_call, client.find_signature, client.key_state, client.reload_active_scripts, client.screen_size, client.set_event_callback, client.system_time, client.timestamp, client.unset_event_callback, database.read, database.write, entity.get_classname, entity.get_local_player, entity.get_origin, entity.get_player_name, entity.get_prop, entity.get_steam64, entity.is_alive, globals.framecount, globals.realtime, math.ceil, math.floor, math.max, math.min, panorama.loadstring, renderer.gradient, renderer.line, renderer.rectangle, table.concat, table.insert, table.remove, table.sort, ui.get, ui.is_menu_open, ui.mouse_position, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.set, ui.set_visible, setmetatable, pairs, error, globals.absoluteframetime, globals.curtime, globals.frametime, globals.maxplayers, globals.tickcount, globals.tickinterval, math.abs, type, pcall, renderer.circle_outline, renderer.load_rgba, renderer.measure_text, renderer.text, renderer.texture, tostring, ui.name, ui.new_button, ui.new_hotkey, ui.new_label, ui.new_listbox, ui.new_textbox, ui.reference, ui.set_callback, ui.update, unpack, tonumber
local client_register_esp_flag, client_visible, entity_hitbox_position, math_ceil, math_pow, math_sqrt, renderer_indicator, unpack, tostring, pairs = client.register_esp_flag, client.visible, entity.hitbox_position, math.ceil, math.pow, math.sqrt, renderer.indicator, unpack, tostring, pairs
local ui_new_button, ui_new_color_picker, ui_new_label, ui_reference, ui_new_checkbox, ui_new_combobox, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_set, ui_get, ui_set_callback, ui_set_visible = ui.new_button, ui.new_color_picker, ui.new_label, ui.reference, ui.new_checkbox, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.set, ui.get, ui.set_callback, ui.set_visible
local client_screen_size, client_set_cvar, client_log, client_color_log, client_set_event_callback, client_unset_event_callback = client.screen_size, client.set_cvar, client.log, client.color_log, client.set_event_callback, client.unset_event_callback
local entity_get_player_name, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_is_alive = entity.get_player_name, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.is_alive
local globals_tickcount, globals_curtime, globals_realtime, globals_frametime = globals.tickcount, globals.curtime, globals.realtime, globals.frametime
local renderer_triangle, renderer_text, renderer_rectangle, renderer_gradient = renderer.triangle, renderer.text, renderer.rectangle, renderer.gradient
local client_exec = client.exec
local entity_set_prop = entity.set_prop
--------------------------------------------------------------------------------
-- Basic Variables -> Reference
--------------------------------------------------------------------------------
local references = {
    aa_enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    body_freestanding = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    body_yaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    jitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    freestanding = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    -- antiaim references
    fakeduck = {ui.reference("RAGE", "Other", "Duck peek assist")},
    leg_movement = ui.reference("AA", "Other", "Leg movement"),
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


    autowall =  ui.reference("RAGE", "Other", "Automatic penetration"),
    autofire = ui.reference("RAGE", "Other", "Automatic fire"),
    fov = ui.reference('RAGE', 'Other', 'Maximum FOV'),

    -- misc references
    untrust = ui.reference("MISC", "Settings", "Anti-untrusted"),
    -- end of menu references and menu creation
    fake_lag = ui.reference("AA", "Fake lag", "Amount"),
    fake_lag_limit = ui.reference("AA", "Fake lag", "Limit"),
    variance = ui.reference("AA", "Fake lag", "Variance"),
}
--------------------------------------------------------------------------------
-- Basic Variables -> Basic Libaries
--------------------------------------------------------------------------------
local TAB =  {"AA", "Anti-aimbot angles", "AA", "Anti-aimbot angles", "Fake lag"} 
local menu = {antiaim = {}, extra = {}, labels = {main = {}, builder = {}, other = {}, visual = {}}, visuals = {}}
local index = {
    tab = {"Anti-aim(Builder)", "Anti-aim(Other)", "Visuals"},
    state = {"Slow-Walk", "Moving", "Stand", "Crouch", "In-Air", "Air-Crouch", "Fakelag"},
}

local api = {user = "scriptleaks", version = "1.0", build = "Beta"}
local bind_system = {left = false,right = false,forward = false,reset = false}
local data_condition = {fs = false, lg = false, roll = false, fire = false, edge = false, fl = false, choke = 0}
local config_db, fs_data, fakelag = {}, {side = 180, last_side = 0, last_hit = 0, hit_side = 0}, false
local notify=(function()local b={callback_registered=false,maximum_count=7,data={},svg_texture=[[<svg xmlns="http://www.w3.org/2000/svg" width="30.093" height="28.944"><path fill-rule="evenodd" clip-rule="evenodd" fill="#FFF" d="M11.443,8.821c0.219,1.083,0.241,2.045,0.064,2.887 c-0.177,0.843-0.336,1.433-0.479,1.771c0.133-0.249,0.324-0.531,0.572-0.848c0.708-0.906,1.706-1.641,2.993-2.201 c0.661-0.29,1.171-0.501,1.527-0.635c1.144-0.434,1.763-0.995,1.859-1.687c0.082-0.563,0.043-1.144-0.118-1.74 c-0.155-0.586-0.193-1.108-0.117-1.567c0.099-0.591,0.483-1.083,1.153-1.478c0.258-0.152,0.51-0.269,0.757-0.35 c-0.037,0.022-0.114,0.263-0.229,0.722c-0.115,0.458-0.038,1.018,0.234,1.676c0.271,0.658,0.472,1.133,0.604,1.42 c0.132,0.29,0.241,0.853,0.324,1.689c0.084,0.838-0.127,1.822-0.629,2.952c-0.502,1.132-1.12,1.89-1.854,2.275 c-0.732,0.386-1.145,0.786-1.237,1.203c-0.092,0.419,0.087,0.755,0.535,1.013s0.927,0.282,1.436,0.074 c0.577-0.238,0.921-0.741,1.031-1.508c0.108-0.751,0.423-1.421,0.945-2.009c0.393-0.438,0.943-0.873,1.654-1.3 c0.24-0.143,0.532-0.285,0.879-0.43c0.192-0.078,0.47-0.191,0.835-0.338c0.622-0.276,1.075-0.65,1.358-1.123 c0.298-0.491,0.465-1.19,0.505-2.096c0.011-0.284,0.009-0.571-0.004-0.862c0.446,0.265,0.796,0.788,1.048,1.568 c0.251,0.782,0.32,1.457,0.206,2.025c-0.113,0.568-0.318,1.059-0.611,1.472c-0.295,0.412-0.695,0.901-1.201,1.469 c-0.519,0.578-0.864,0.985-1.04,1.222c-0.318,0.425-0.503,0.795-0.557,1.109c-0.044,0.269-0.05,0.763-0.016,1.481 c0.05,1.016,0.075,1.695,0.075,2.037c0,1.836-0.334,3.184-1.004,4.045c-0.874,1.123-1.731,1.902-2.568,2.336 c-0.955,0.49-2.228,0.736-3.813,0.736c-1.717,0-3.154-0.246-4.313-0.736c-1.237-0.525-2.083-1.303-2.541-2.336 c-0.394-0.885-0.668-1.938-0.827-3.158c-0.05-0.385-0.083-0.76-0.103-1.127c-0.49-0.092-0.916,0.209-1.278,0.904 c-0.36,0.693-0.522,1.348-0.484,1.957c0.039,0.611,0.246,1.471,0.625,2.578c0.131,0.449,0.185,0.801,0.161,1.051 c-0.031,0.311-0.184,0.521-0.456,0.631c-0.321,0.129-0.688,0.178-1.1,0.146c-0.463-0.037-0.902-0.174-1.319-0.41 c-1.062-0.604-1.706-1.781-1.937-3.531c-0.229-1.75-0.301-3.033-0.214-3.85c0.086-0.814,0.342-1.613,0.77-2.398 c0.428-0.783,0.832-1.344,1.213-1.681c0.382-0.338,0.893-0.712,1.532-1.122c0.64-0.408,1.108-0.745,1.405-1.008 c0.438-0.383,0.715-0.807,0.83-1.271C8.824,9.292,8.52,7.952,7.613,6.456C7.33,5.988,7.005,5.532,6.637,5.087 c0.837,0.111,1.791,0.49,2.865,1.138C10.576,6.872,11.223,7.737,11.443,8.821z"/></svg>]]}local c={w=20,h=20}local d=renderer.load_svg(b.svg_texture,c.w,c.h)function b:register_callback()if self.callback_registered then return end;client_set_event_callback("paint_ui",function()local e={client_screen_size()}local f={15,15,15}local g=5;local h=self.data;for i=#h,1,-1 do h[i].time=h[i].time-globals.frametime()local j,k=255,0;local l=h[i]if l.time<0 then table.remove(h,i)else local m=l.def_time-l.time;local m=m>1 and 1 or m;if l.time<0.5 or m<0.5 then k=(m<1 and m or l.time)/0.5;j=k*255;if k<0.2 then g=g+15*(1.0-k/0.2)end end;local n={renderer.measure_text("dc",l.draw)}local o={e[1]/2-n[1]/2+3,e[2]-e[2]/100*17.4+g}renderer.rectangle(o[1]-30,o[2]-22,n[1]+60,2,161,192,255,j)renderer.rectangle(o[1]-29,o[2]-20,n[1]+58,29,f[1],f[2],f[3],j<=135 and j or 135)renderer.line(o[1]-30,o[2]-22,o[1]-30,o[2]-20+30,83,126,242,j<=50 and j or 50)renderer.line(o[1]-30+n[1]+60,o[2]-22,o[1]-30+n[1]+60,o[2]-20+30,83,126,242,j<=50 and j or 50)renderer.line(o[1]-30,o[2]-20+30,o[1]-30+n[1]+60,o[2]-20+30,83,126,242,j<=50 and j or 50)renderer.text(o[1]+n[1]/2+10,o[2]-5,255,255,255,j,"dc",nil,l.draw)renderer.texture(d,o[1]-c.w/2-5,o[2]-c.h/2-5,c.w,c.h,255,255,255,j)g=g-50 end end;self.callback_registered=true end)end;function b:paint(p,q)local r=tonumber(p)+1;for i=self.maximum_count,2,-1 do self.data[i]=self.data[i-1]end;self.data[1]={time=r,def_time=r,draw=q}self:register_callback()end;return b end)()
local g_text = function(b,c,d)local e=''local f=#d-1;local g,h,i,j=b[1],b[2],b[3],b[4]local k,l,m,n=c[1],c[2],c[3],c[4]local o=(k-g)/f;local p=(l-h)/f;local q=(m-i)/f;local r=(n-j)/f;for s=1,f+1 do e=e..('\a%02x%02x%02x%02x%s'):format(g,h,i,j,d:sub(s,s))g=g+o;h=h+p;i=i+q;j=j+r end;return e end
local dragging_fn=function(b,c,d)return(function()local e={}local f,g,h,i,j,k,l,m,n,o,p,q,r,s;local t={__index={drag=function(self,...)local u,v=self:get()local w,x,q=e.drag(u,v,...)if u~=w or v~=x then self:set(w,x)end;return w,x,q end,status=function(self,...)local w,x=self:get()local y,z=e.status(w,x,...)return y end,set=function(self,u,v)local n,o=client_screen_size()ui_set(self.x_reference,u/n*self.res)ui_set(self.y_reference,v/o*self.res)end,get=function(self)local n,o=client_screen_size()return ui_get(self.x_reference)/self.res*n,ui_get(self.y_reference)/self.res*o end}}function e.new(y,z,A,B)B=B or 10000;local n,o=client_screen_size()local C=ui_new_slider("LUA","A",y.." window position",0,B,z/n*B)local D=ui_new_slider("LUA","A","\n"..y.." window position y",0,B,A/o*B)ui_set_visible(C,false)ui_set_visible(D,false)return setmetatable({name=y,x_reference=C,y_reference=D,res=B},t)end;function e.drag(u,v,E,F,G,H,I)local t="n"if globals_framecount()~=f then g=ui_is_menu_open()j,k=h,i;h,i=ui_mouse_position()m=l;l=client_key_state(0x01)==true;q=p;p={}s=r;r=false;n,o=client_screen_size()end;if g and m~=nil then if(not m or s)and l and j>u and k>v and j<u+E and k<v+F then r=true;u,v=u+h-j,v+i-k;if not H then u=math_max(0,math_min(n-E,u))v=math_max(0,math_min(o-F,v))end end end;if g and m~=nil then if j>u and k>v and j<u+E and k<v+F then if l then t="c"else t="o"end end end;table_insert(p,{u,v,E,F})return u,v,t,E,F end;function e.status(u,v,E,F,G,H,I)if globals_framecount()~=f then g=ui_is_menu_open()j,k=h,i;h,i=ui_mouse_position()m=l;l=true;q=p;p={}s=r;r=false;n,o=client_screen_size()end;if g and m~=nil then if j>u and k>v and j<u+E and k<v+F then return true end end;return false end;return e end)().new(b,c,d)end
local console_logs=(function()local b={}b.console=function(self,...)for c,d in ipairs({...})do if type(d[1])=='table'and type(d[2])=='table'and type(d[3])=='string'then for e=1,#d[3]do local f=self:lerp(d[1],d[2],e/#d[3])client_color_log(f[1],f[2],f[3],d[3]:sub(e,e)..'\0')end elseif type(d[1])=='table'and type(d[2])=='string'then client_color_log(d[1][1],d[1][2],d[1][3],d[2]..'\0')end end end;b.lerp=function(self,g,h,i)if type(g)=='table'and type(h)=='table'then return{self:lerp(g[1],h[1],i),self:lerp(g[2],h[2],i),self:lerp(g[3],h[3],i)}end;return g+(h-g)*i end;b.log=function(self,...)for c,d in ipairs({...})do if type(d)=='table'then if type(d[1])=='table'then if type(d[2])=='string'then self:console({d[1],d[1],d[2]})if d[3]then self:console({{255,255,255},'\n'})end elseif type(d[2])=='table'then self:console({d[1],d[2],d[3]})if d[4]then self:console({{255,255,255},'\n'})end end elseif type(d[1])=='string'then self:console({{205,205,205},d[1]})if d[2]then self:console({{255,255,255},'\n'})end end end end end;local j={}j.on_aim_miss=function(k,l,m,n,o,p,q)if not l then return end;local r={"body","head","chest","stomach","left arm","right arm","left leg","right leg","neck","?","gear"}local s=r[k.hitgroup+1]or"?"local t=entity.get_player_name(k.target)local u;if k.reason=="?"then u="Resolver"else u=k.reason end;if k.reason=='spread'then if l then b:log({{m[1],m[2],m[3]},"[ Alemite ] "},{{255,255,255},"Missed "},{{n[1],n[2],n[3]},t},{{255,255,255},", HB: "},{{o[1],o[2],o[3]},s},{{255,255,255},", reason: "},{{q[1],q[2],q[3]},u},{{p[1],p[2],p}," ("},{{o[1],o[2],o[3]},tostring(math.floor(k.hit_chance))},{{p[1],p[2],p[3]},"%)"})client.color_log(217,217,217," ")end else if l then b:log({{m[1],m[2],m[3]},"[ Alemite ] "},{{255,255,255},"Missed "},{{n[1],n[2],n[3]},t},{{255,255,255},", HB:"},{{o[1],o[2],o[3]},s},{{255,255,255},", reason: "},{{q[1],q[2],q[3]},u})client.color_log(217,217,217," ")end end end;j.on_player_hurt=function(k,l,m,n,o,p,q)if not l then return end;local v=client.userid_to_entindex(k.attacker)if v==nil then return end;if v~=entity.get_local_player()then return end;local r={"body","head","chest","stomach","left arm","right arm","left leg","right leg","neck","?","gear"}local s=r[k.hitgroup+1]or"?"local w=client.userid_to_entindex(k.userid)local t=entity_get_player_name(w)local x=k.dmg_health;b:log({{m[1],m[2],m[3]},"[ Alemite ] "},{{255,255,255},"Hit "},{{n[1],n[2],n[3]},entity_get_player_name(client.userid_to_entindex(k.userid))},{{255,255,255}," in "},{{o[1],o[2],o[3]},tostring(k.dmg_health)},{{255,255,255},", HB: "},{{q[1],q[2],q[3]},r[k.hitgroup+1]or"?"},{{255,255,255},", HP: "},{{q[1],q[2],q[3]},tostring(k.health)})client.color_log(217,217,217," ")end;j.local_got_hurt=function(k,l,m,n,o,p,q)if not l then return end;local r={"body","head","chest","stomach","left arm","right arm","left leg","right leg","neck","?","gear"}if k.hitgroup==nil then return end;local s=r[k.hitgroup+1]or"?"if client.userid_to_entindex(k.userid)==entity.get_local_player()then local y=100-math.floor(anti_aim.get_overlap()*100)local z=entity.get_player_name(client.userid_to_entindex(k.attacker))hurt=true;j.byaw_log.state=true;j.byaw_log.info='Impact Detected. Hit \aFFFDA6FF'..s..'\aFFFFFFFF with Overlap: (\aFFFDA6FF'..y..'%\aFFFFFFFF).Jitter:'..ui.get(references.jitter[2]..'.')if l then b:log({{m[1],m[2],m[3]},"[ Alemite ] "},{{255,255,255},"Impact Detected. Hit "},{{n[1],n[2],n[3]},s},{{255,255,255}," with Overlap"},{{p[1],p[2],p[3]}," ("..tostring(y)..")%"},{{255,255,255}," Jitter: "},{{q[1],q[2],q[3]},tostring(ui.get(references.jitter[2]))})client.color_log(217,217,217," ")end else hurt=false end end;return j end)()
local config=(function()config_db={get=function()return database.read("config_database_name_Alemite")end,save=function(a)local b=config_db.get(a)if b==nil then local c={configs="empty"}database.write("config_database_name_Alemite",c)end;local c={configs=a}database.write("config_database_name_Alemite",c)end,load=function()local b=config_db.get()return b.configs end}local d={}local e=require("gamesense/base64")d.save=function()local f={}for g,h in pairs(index.state)do f[tostring(h)]={}for i,j in pairs(menu.antiaim[g])do f[h][i]=ui_get(j)end end;config_db.save(e.encode(json.stringify(f)))notify:paint(4,"Config Saved to database!")end;d.load=function()local database=config_db.load()if database=="empty"then notify:paint(4,"Importation failure")return end;local f=json.parse(e.decode(database))for g,h in pairs(index.state)do for i,j in pairs(menu.antiaim[g])do local k=f[h][i]if k~=nil then ui_set(j,k)end end end;notify:paint(4,"Config Loaded Loaded from database!")end;d.import=function()local l=require("gamesense/clipboard")if l.get()==nil then notify:paint(4,"Importation failure")return end;local f=json.parse(e.decode(l.get()))for g,h in pairs(index.state)do for i,j in pairs(menu.antiaim[g])do local k=f[h][i]if k~=nil then ui_set(j,k)end end end;notify:paint(4,"Config Imported from clipbroad!")end;d.export=function()local f={}local l=require("gamesense/clipboard")for g,h in pairs(index.state)do f[tostring(h)]={}for i,j in pairs(menu.antiaim[g])do f[h][i]=ui_get(j)end end;l.set(e.encode(json.stringify(f)))notify:paint(4,"Config Exported from clipbroad!")end;return d end)()
local outline = function(x, y, w, h, t, r, g, b, a)
    renderer.rectangle(x, y, w, t, r, g, b, a)
    renderer.rectangle(x, y, t, h, r, g, b, a)
    renderer.rectangle(x, y+h-t, w, t, r, g, b, a)
    renderer.rectangle(x+w-t, y, t, h, r, g, b, a)
end
local ani = {
    logs = 0,
    handler = 0
}
local lib =
    (function()
    local b = {}
    b.inair = function()
        return bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 0
    end
    b.crouch = function()
        return bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 4) == 0
    end
    b.velocity = function()
        local c = entity_get_local_player()
        local d, e = entity_get_prop(c, "m_vecVelocity")
        return math.sqrt(d ^ 2 + e ^ 2)
    end
    b.slow_walk = function()
        return ui_get(references.slow_walk[2])
    end
    b.get_state = function()
        local f =
            data_condition.fl and 7 or b.slow_walk() and 1 or
            (b.inair() and not b.crouch() and 6 or b.inair() and b.crouch() and 5) or
            not b.crouch() and 4 or
            (b.velocity() > 5 and 2 or 3)
        return f
    end
    b.fl_state = function(g, h, i, j, k, l)
        local m = {
            slow = b.slow_walk() and l,
            air = b.inair() and g,
            duck = not b.crouch() and not b.inair() and h,
            stand = b.velocity() < 5 and not b.inair() and j,
            move = b.velocity() > 5 and not b.inair() and k,
            air_duck = b.inair() and not b.crouch() and i
        }
        local n = m.slow or m.air or m.duck or m.stand or m.move or m.air_duck
        local o = ui_get(references.fake_lag_limit)
        local is_doubletap = (ui_get(references.doubletap[1]) and (ui_get(references.doubletap[2])))
        local is_onshot = (ui_get(references.onshot[1]) and (ui_get(references.onshot[2])))
        local is_fd = (ui_get(references.fakeduck[1]))
        if is_fd or (n and o > 6) and not (is_doubletap or is_onshot) then
            data_condition.fl = true
        else
            data_condition.fl = false
        end
    end
    b.ey_state = function(g, h, i, j, k, l)
        local m = {
            key = ui_get(menu.extra.freestands.edgeyaw_key),
            slow = b.slow_walk() and l,
            air = b.inair() and g,
            duck = not b.crouch() and not b.inair() and h,
            stand = b.velocity() < 5 and not b.inair() and j,
            move = b.velocity() > 5 and not b.inair() and k,
            air_duck = b.inair() and not b.crouch() and i
        }
        local p = m.slow or m.air or m.duck or m.stand or m.move or m.air_duck
        ui_set(references.edge_yaw, m.key and not p and true or false)
    end
    b.fs_state = function(g, h, i, j, k, l)
        local m = {
            key = ui_get(menu.extra.freestands.freestand_key),
            slow = b.slow_walk() and l,
            air = b.inair() and g,
            duck = b.crouch() and not b.inair() and h,
            stand = b.velocity() < 5 and not b.inair() and j,
            move = b.velocity() > 5 and not b.inair() and k,
            air_duck = b.inair() and b.crouch() and i
        }
        local q = m.slow or m.air or m.duck or m.stand or m.move or m.air_duck
        ui_set(references.freestanding[1], m.key)
    end
    b.jitter = function(r, s)
        local t = entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        return t < 0 and r or s
    end
    b.random = function(r, s, max, min)
        local u = math.random(1, 0)
        local v = u == 1 and 1 or u == 0 and -1
        local _return = r + math.random(s, s / 2) * v
        return (_return > max and max) or (_return < min and min) or _return
    end
    b.contains = function(w, x)
        for f = 1, #w do
            if w[f] == x then
                return true
            end
        end
        return false
    end
    return b
end)()

local sx, sy = client.screen_size()
local x, y = 20 , sy/4
local drags = {
    logs = dragging_fn('indicator logs', 400 , sy/4),
}

local function vanila_skeet_element(state)

    ui_set_visible(references.pitch, state)
    ui_set_visible(references.yaw_base, state)
    ui_set_visible(references.yaw[1], state)
    ui_set_visible(references.yaw[2], state)
    ui_set_visible(references.jitter[1], state)
    ui_set_visible(references.jitter[2], state)
    ui_set_visible(references.body_yaw[1], state)
    ui_set_visible(references.body_yaw[2], state)
    ui_set_visible(references.body_freestanding, state)
    ui_set_visible(references.roll[1], state)
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

local antiaim_lib = {

    backstab = function()
        local enemies = entity_get_players(true)
        local local_origin = vector(entity_get_origin(entity_get_local_player()))
        local is_near = false
        for i = 1, #enemies do
            local enemy_origin = vector(entity_get_origin(enemies[i]))
            local distance = local_origin:dist(enemy_origin)
            local weapon = entity_get_player_weapon(enemies[i])
            local class = entity_get_classname(weapon) --we get enemy's weapon here
            if distance < 128 and class == "CKnife" then return true end
        end
        return false
    end,


    freestand = function()
        local me = entity_get_local_player()

        if not me or entity_get_prop(me, "m_lifeState") ~= 0 then
            return
        end
    
        local now = globals_curtime()

        if fs_data.hit_side ~= 0 and now - fs_data.last_hit > 5 then
            fs_data.last_side = 0
            fs_data.last_hit = 0
            fs_data.hit_side = 0
        end

        local x, y, z = client.eye_position()
        local _, yaw = client.camera_angles()

        local trace_data = {left = 0, right = 0}

        for i = yaw - 90, yaw + 90, 30 do
            if i ~= yaw then
                local rad = math.rad(i)
                local px, py, pz = x + 256 * math.cos(rad), y + 256 * math.sin(rad), z

                local fraction = client.trace_line(me, x, y, z, px, py, pz)
                local side = i < yaw and "left" or "right"
                trace_data[side] = trace_data[side] + fraction
            end
        end

        fs_data.side = trace_data.left < trace_data.right and -180 or 180

        if fs_data.side == fs_data.last_side then
            return
        end

        fs_data.last_side = fs_data.side

        if fs_data.hit_side ~= 0 then
            fs_data.side = fs_data.hit_side == 180 and -180 or 180
        end

    end,

    in_use = function(cmd)
        local local_player = entity_get_local_player()
        local in_buyzone = entity_get_prop(local_player, "m_bInBuyZone")
        local in_bombzone = entity_get_prop(local_player, "m_bInBombZone")
        local weaponn = entity_get_player_weapon()

        if (client_key_state(0x45)) or (in_buyzone ~= 0) or (in_bombzone ~= 0) then return end
        if in_bombzone == 1 then return end
            if weaponn ~= nil and entity_get_classname(weaponn) == "CC4" then
                if cmd.in_attack == 1 then cmd.in_attack = 0 cmd.in_use = 1 end
            end
        if cmd.chokedcommands == 0 then cmd.in_use = 0 end
    end
}

--------------------------------------------------------------------------------
-- Basic Libaries -> UI Generations
--------------------------------------------------------------------------------

local menu_generate = function()

    local configs = menu.antiaim
    local prefix = function(prefix, content)
        local theme_color = " \aB0BDFFFF"..prefix.."\aFFFFFFFF "
        if prefix == "Hide" then
            return "\n"..content
        end
        return theme_color..content
    end

    local suffix = function(content)
        return "\n"..content
    end

    menu.labels.main.header_start = ui_new_label(TAB[3], TAB[4], prefix("       ", "<-------")..""..""..prefix("Alemite", "-------->"))
    menu.labels.main.header_c_1 = ui_new_label(TAB[3], TAB[4], prefix("        Welcome,", api.user))
    menu.labels.main.header_c_2 = ui_new_label(TAB[3], TAB[4], prefix("           Alemite Version:", api.version))
    menu.labels.main.header_c_3 = ui_new_label(TAB[3], TAB[4], prefix("             Your build is:", api.build))
    menu.labels.main.header_end = ui_new_label(TAB[3], TAB[4], prefix("       ", "<-------")..""..""..prefix("Alemite", "-------->"))
    menu.labels.main.header_b = ui_new_label(TAB[3], TAB[4], "\n")

    menu.labels.alemite = ui_new_checkbox(TAB[3], TAB[4],  "\aFFFFFFFFEnable"..prefix("Alemite", ""))

    menu.antiaim.main_tab = ui_new_combobox(TAB[1], TAB[2], prefix("Menu", "Main Tab"), index.tab)
    menu.antiaim.selector = ui_new_combobox(TAB[3], TAB[4], prefix("Anti-aim", "Selector"), index.state)

    --------------------------------------------------------------------------------
    -- Antiaim Builder -> Pitch / Yaw Base    
    --------------------------------------------------------------------------------
    
    menu.labels.builder.pitch_b = ui_new_label(TAB[3], TAB[4], "\n")
    menu.labels.builder.pitch = ui_new_label(TAB[3], TAB[4], prefix("            Base", "Modifiers"))
    menu.labels.builder.unhide = ui_new_checkbox(TAB[3], TAB[4], prefix("Base", "Unhide skeet menu"))

    for i=1, #index.state do

        if not configs[i] then
            configs[i] = {}
        end

        menu.antiaim[i].pitch = ui_new_combobox(TAB[1], TAB[2], prefix("Base", "Pitch")..suffix(index.state[i]),
        {"Minimal", "Off", "Down"})

        menu.antiaim[i].yaw_base = ui_new_combobox(TAB[1], TAB[2], prefix("Base", "Yaw")..suffix(index.state[i]),
        {"180", "Off", "Static"})

    end

    --------------------------------------------------------------------------------
    -- Antiaim Builder -> Yaw / Offsets    
    --------------------------------------------------------------------------------

    menu.labels.builder.current_labels = ui_new_label(TAB[3], TAB[4], "\n")
    menu.labels.builder.yaw = ui_new_label(TAB[3], TAB[4], prefix("            Yaw", "Modifiers"))

    for i=1, #index.state do

        if not configs[i] then
            configs[i] = {}
        end

        menu.antiaim[i].yaw = ui_new_combobox(TAB[1], TAB[2], prefix("Yaw", "Offsets")..suffix(index.state[i]),
        {"Off", "L/R Center", "Center", "3-Way", "Offset", "Random"})

        menu.antiaim[i].yaw_slider = ui_new_slider(TAB[1], TAB[2], prefix("Hide", "Slider yaw")..suffix(index.state[i]), -180, 180, 0)
        menu.antiaim[i].yaw_slider_add = ui_new_slider(TAB[1], TAB[2], prefix("Hide", "Yaw Slider add")..suffix(index.state[i]), -180, 180, 0)

        menu.antiaim[i].center = ui_new_combobox(TAB[1], TAB[2], prefix("Center", "Yaw Jitter")..suffix(index.state[i]),
        {"-", "Random Center", "L/R Center"})

        menu.antiaim[i].offset = ui_new_combobox(TAB[1], TAB[2], prefix("Offset", "Yaw Jitter")..suffix(index.state[i]),
        {"-", "Random Offset", "L/R Offset"})

        menu.antiaim[i].skitter = ui_new_combobox(TAB[1], TAB[2], prefix("3-Way", "Yaw Jitter")..suffix(index.state[i]),
        {"-", "L/R 3-Way"})

        menu.antiaim[i].random = ui_new_combobox(TAB[1], TAB[2], prefix("Random", "Yaw Jitter")..suffix(index.state[i]),
        {"-", "L/R Random"})

        menu.antiaim[i].yaw_jitter = ui_new_slider(TAB[1], TAB[2], prefix("Hide", "Yaw jitter")..suffix(index.state[i]), -180, 180, 0)
        menu.antiaim[i].yaw_jitter_add = ui_new_slider(TAB[1], TAB[2], prefix("Hide", "Yaw jitter add")..suffix(index.state[i]), -180, 180, 0)
    end

    --------------------------------------------------------------------------------
    -- Antiaim Builder -> Body Yaw / Offsets    
    --------------------------------------------------------------------------------

    menu.labels.builder.body_yaw_b = ui_new_label(TAB[3], TAB[4], "  \n")
    menu.labels.builder.body_yaw = ui_new_label(TAB[3], TAB[4], prefix("         Body yaw", "Modifiers"))

    for i=1, #index.state do

        if not configs[i] then
            configs[i] = {}
        end

        menu.antiaim[i].body_yaw = ui_new_combobox(TAB[1], TAB[2], prefix("Body Yaw", "Mode")..suffix(index.state[i]),
        {"Jitter", "Static", "Off"})

        menu.antiaim[i].bodyyaw_slider = ui_new_slider(TAB[1], TAB[2], prefix("Hide", "Slider body yaw")..suffix(index.state[i]), -180, 180, 0)
        
        menu.antiaim[i].jitter = ui_new_combobox(TAB[1], TAB[2], prefix("Jitter", "Body yaw logic"..suffix(index.state[i])),
        {"-", "Random Jitter", "L/R Jitter"})

        menu.antiaim[i].static = ui_new_combobox(TAB[1], TAB[2], prefix("Static", "Body yaw logic"..suffix(index.state[i])),
        {"-", "Randomize", "Freestand"})

        menu.antiaim[i].body_yaw_add = ui_new_slider(TAB[1], TAB[2], prefix("Hide","Body yaw add"..suffix(index.state[i])), -180, 180, 0)
    end

    --------------------------------------------------------------------------------
    -- Antiaim Builder -> Fake limit / Offsets    
    --------------------------------------------------------------------------------

    menu.labels.builder.fake_limit_b = ui_new_label(TAB[3], TAB[4], "  \n")
    menu.labels.builder.fake_limit = ui_new_label(TAB[3], TAB[4], prefix("         Fake limit", "Modifiers"))

    for i=1, #index.state do

        if not configs[i] then
            configs[i] = {}
        end

        menu.antiaim[i].fake_limit = ui_new_combobox(TAB[1], TAB[2], prefix("Fake limit", "Offsets"..suffix(index.state[i])),
        {"-", "Random", "L/R"})

        menu.antiaim[i].fake_limit_slider = ui_new_slider(TAB[1], TAB[2], prefix("Hide", "Slider fake")..suffix(index.state[i]), 0, 60, 59)
        menu.antiaim[i].fake_limit_add = ui_new_slider(TAB[1], TAB[2], prefix("Hide", "Slider fake add")..suffix(index.state[i]), 0, 60, 59)
    end

    --------------------------------------------------------------------------------
    -- Antiaim Other -> Utility
    --------------------------------------------------------------------------------

    menu.labels.other.utility_b = ui_new_label(TAB[3], TAB[4], "  \n")
    menu.labels.other.utility = ui_new_label(TAB[3], TAB[4], prefix("           Utility", "Modifiers"))

    menu.extra.utility = {
        fl_antiaim = ui_new_checkbox(TAB[1], TAB[2], prefix("Utility", "Fake-lag antiaim")),
        fakelag = {
            condition = ui_new_multiselect(TAB[1], TAB[2], prefix("Fake-Lag", "Anti-aim applier"),
            {"air", "crouch", "air crouch", "stand", "move", "slowwalk"}),

            mod = ui_new_label(TAB[1], TAB[2], "\n hide this tag")
        },

        legit_antiaim = ui_new_checkbox(TAB[1], TAB[2], prefix("Utility", "Legit AA")),
        manual = ui_new_hotkey(TAB[1], TAB[2], prefix("Manual", "Key"), false),
        legit_aa = {
            condition = ui_new_multiselect(TAB[1], TAB[2], prefix("Legit AA", "Condition"),
            {"Force Static", "Force Roll"}),
            rebind = ui_new_hotkey(TAB[1], TAB[2], "\nLegit AA bind", true),

            mod = ui_new_label(TAB[1], TAB[2], "\n hide this tag")
        },

        roll_antiaim = ui_new_checkbox(TAB[1], TAB[2], prefix("Utlity", "Roll Angle")),
        roll_aa = {
            condition = ui_new_multiselect(TAB[1], TAB[2], prefix("Legit AA", "Condition"),
            "In Air", "On Ladders", "Low Stamina", "On Key", "On Slow Walk", "Low Speed"),
            rebind = ui_new_hotkey(TAB[1], TAB[2], "\nForce roll bind", true),

            checkbox_hitchecker = ui_new_checkbox(TAB[1], TAB[2],  prefix("Roll", "Disable when Impact"), true),

            slider_roll = ui_new_slider(TAB[1], TAB[2],  prefix("Roll", "Value"), -90, 90, 50, true, "°"),

            mod = ui_new_label(TAB[1], TAB[2], "\n hide this tag")
        },

        anti_backstab = ui_new_checkbox(TAB[1], TAB[2], prefix("Utility", "Anti backstab")),
        backstab = {
            condition = ui_new_multiselect(TAB[1], TAB[2], prefix("Backstab", "Condition"),
            {"Disable Pitch", "Disable Body yaw"}),
            radius = ui_new_slider(TAB[1], TAB[2], prefix("Backstab", "Detection Range"),
            0, 360, 180, true, "m"),

            mod = ui_new_label(TAB[1], TAB[2], "\n hide this tag")
        }

    }


    --------------------------------------------------------------------------------
    -- Antiaim Other -> Fake lag
    --------------------------------------------------------------------------------
    menu.extra.fakelag = {
        mode = ui_new_combobox(TAB[1], TAB[5], prefix("Fakelag", "Mode"), {
            "Dynamic", "Maximum", "Fluctuate", "\aB0BDFFFFAlemite"
        }),

        variance = ui_new_slider(TAB[1], TAB[5], prefix("Fakelag", "Variance"), 0, 100, 0),
        amount = ui_new_slider(TAB[1], TAB[5], prefix("Fakelag", "Limit"), 1, 18, 6),

        reducer = ui_new_multiselect(TAB[1], TAB[5], prefix("Fakelag", "Reduce Onshot"),
        {"Force Defensive", "No Choke", "Force Static"}),
    }
    --------------------------------------------------------------------------------
    -- Antiaim Other -> Manual
    --------------------------------------------------------------------------------

    menu.labels.other.manual_b = ui_new_label(TAB[3], TAB[4], "  \n")
    menu.labels.other.manual = ui_new_label(TAB[3], TAB[4], prefix("           Manual", "Modifiers"))

    menu.extra.manuals = {
        left = ui_new_hotkey(TAB[1], TAB[2], prefix("Manual", "Left"), false),
        right = ui_new_hotkey(TAB[1], TAB[2], prefix("Manual", "Right"), false),
        forward = ui_new_hotkey(TAB[1], TAB[2], prefix("Manual", "Forward"), false),
        reset = ui_new_hotkey(TAB[1], TAB[2], prefix("Manual", "Reset"), false),
        manual_state = ui_new_slider(TAB[1], TAB[2], prefix("Hide", "Manual state"), 0, 3, 0),
    }

    menu.labels.other.freestand_b = ui_new_label(TAB[3], TAB[4], "  \n")
    menu.labels.other.freestand = ui_new_label(TAB[3], TAB[4], prefix("          Freestand", "Modifiers"))

    menu.extra.freestands = {
        edge_yaw = ui_new_multiselect(TAB[1], TAB[2], prefix("Edge Yaw", "Disablers"),
        {"air", "crouch", "air crouch", "stand", "move", "slowwalk"}),
        edgeyaw_key = ui_new_hotkey(TAB[1], TAB[2], "\nEdge Yaw Key", true),

        freestand = ui_new_multiselect(TAB[1], TAB[2], prefix("Freestand", "Disablers"),
        {"air", "crouch", "air crouch", "stand", "move", "slowwalk"}),
        freestand_key = ui_new_hotkey(TAB[1], TAB[2], "\nFreestanding Key", true),
    }

    menu.labels.other.config_b = ui_new_label(TAB[3], TAB[4], "  \n")
    menu.labels.other.config = ui_new_label(TAB[3], TAB[4], prefix("           Config", "Modifiers"))

    menu.extra.configs = {
        save = ui_new_button(TAB[1], TAB[2], prefix("Config", "Save"), config.save),
        load = ui_new_button(TAB[1], TAB[2], prefix("Config", "Load"), config.load),
        import = ui_new_button(TAB[1], TAB[2], prefix("Config", "Import"), config.import),
        export = ui_new_button(TAB[1], TAB[2], prefix("Config", "Export"), config.export),
    }

    --------------------------------------------------------------------------------
    -- Visuals -> Color Picker
    --------------------------------------------------------------------------------
    menu.labels.visual.ind_b = ui_new_label(TAB[3], TAB[4], "  \n")
    menu.labels.visual.ind = ui_new_label(TAB[3], TAB[4], prefix("           Visuals", "Modifiers"))
    menu.visuals = {
        crosshair = ui_new_checkbox(TAB[1], TAB[2], prefix("Visuals", "Crosshair Indicator")),
        cs_main = {
            label_a = ui_new_label(TAB[1], TAB[2], prefix("Crosshair", "Main color")),
            main = ui_new_color_picker(TAB[1], TAB[2], " 1", 141, 158, 246, 255),

            label_b = ui_new_label(TAB[1], TAB[2], prefix("Crosshair", "Alt color")),
            alt = ui_new_color_picker(TAB[1], TAB[2], " 2", 249, 112, 255, 255),

            label_c = ui_new_label(TAB[1], TAB[2], prefix("Crosshair", "Keybind color")),
            key = ui_new_color_picker(TAB[1], TAB[2], " 3", 182, 194, 253, 255),

            animation = ui_new_slider(TAB[1], TAB[2], prefix("Crosshair", "Animation Speed"), 6, 15, 8),
            keybind = ui_new_multiselect(TAB[1], TAB[2], prefix("Crosshair", "Keybind"),
            {"Double-tap", "Hide shot", "Freestand", "Edge yaw", "Body aim"}),

            label_mod = ui_new_label(TAB[1], TAB[2], prefix("Hide", "Hide").."\n")
        },

        manual = ui_new_checkbox(TAB[1], TAB[2], prefix("Visuals", "Manual Indicator")),
        ml_main = {
            label_a = ui_new_label(TAB[1], TAB[2], prefix("Manual", "Indicator Color")),
            color = ui_new_color_picker(TAB[1], TAB[2], "\nManual Color", 255, 255, 255, 255),
            dist = ui_new_slider(TAB[1], TAB[2], prefix("Manual", "Indictaor Distance"), 1, 100, 15, true, "px"),
            animation = ui_new_slider(TAB[1], TAB[2], prefix("Manual", "Animation Speed"), 6, 15, 8),
            label_mod = ui_new_label(TAB[1], TAB[2], prefix("Hide", "Hide").."\n")
        },

        breaker = ui_new_checkbox(TAB[1], TAB[2], prefix("Visuals", "Animation breaker")),
        bk_main = {
            list = ui_new_multiselect(TAB[1], TAB[2], prefix("Animation", "Selector"),
            {"Leg fucker", "Static legs in air", "Pitch zero on land"}),
        },
        
        logs = ui_new_checkbox(TAB[1], TAB[2], prefix("Visuals", "Logs information")),
        lg_main = {
            console = ui_new_multiselect(TAB[1], TAB[2], prefix("Logs", "Consoles"),
            {"Aimbot miss", "Aimbot hits"}),
            indicator = ui_new_checkbox(TAB[1], TAB[2], prefix('Logs', "Draw as indicator")),

            label_a = ui_new_label(TAB[1], TAB[2], prefix("Color", "Labels Color")),
            color_1 = ui_new_color_picker(TAB[1], TAB[2], prefix("Color", "Labels"), 161,192,255),
            label_b = ui_new_label(TAB[1], TAB[2], prefix("Color", "Targets Color")),
            color_2 = ui_new_color_picker(TAB[1], TAB[2], prefix("Color", "Targets"), 144, 255, 152),
            label_c = ui_new_label(TAB[1], TAB[2], prefix("Color", "Hitgroup")),
            color_3 = ui_new_color_picker(TAB[1], TAB[2], prefix("Color", "Hitgroup"), 255, 190, 190),
            label_d = ui_new_label(TAB[1], TAB[2], prefix("Color", "Alt Color #1")),
            color_4 = ui_new_color_picker(TAB[1], TAB[2], prefix("Color", "Alt #1"), 255, 253, 166),
            label_e = ui_new_label(TAB[1], TAB[2], prefix("Color", "Alt Color #1")),
            color_5 = ui_new_color_picker(TAB[1], TAB[2], prefix("Color", "Alt #2"), 255, 253, 166),
        }
    }
end

menu_generate()
local menu_visible = function()
    local unhide = ui_get(menu.labels.builder.unhide)
    vanila_skeet_element(unhide)
    local alemite = ui_get(menu.labels.alemite)
    local builder = ui_get(menu.antiaim.main_tab) == "Anti-aim(Builder)" and alemite
    local other = ui_get(menu.antiaim.main_tab) == "Anti-aim(Other)" and alemite
    local visuals = ui_get(menu.antiaim.main_tab) == "Visuals" and alemite
    -->> Anti-aim(Builder)
    ui_set_visible(menu.antiaim.selector, builder)
    for i=1, #index.state do
        local current = ui_get(menu.antiaim.selector) == index.state[i] and builder

        local yaw = {
            offset  =   ui_get(menu.antiaim[i].yaw) == "Offset" and current,

            center  =   (ui_get(menu.antiaim[i].yaw) == "Center" and current) or 
                        (ui_get(menu.antiaim[i].yaw) == "L/R Center" and current),

            random  =   ui_get(menu.antiaim[i].yaw) == "Random" and current,

            skitter =   ui_get(menu.antiaim[i].yaw) == "3-Way" and current
        }

        local body_yaw = {
            static = ui_get(menu.antiaim[i].body_yaw) == "Static" and current,
            jitter = ui_get(menu.antiaim[i].body_yaw) == "Jitter" and current,
        }

        local yaw_add = {
            yaw      =  ui_get(menu.antiaim[i].yaw) == "L/R Center" and current,

            jitter   =  (yaw.center and ui_get(menu.antiaim[i].center) ~= "-" and current) or
                        (yaw.offset and ui_get(menu.antiaim[i].offset) ~= "-" and current) or
                        (yaw.skitter and ui_get(menu.antiaim[i].skitter) ~= "-" and current),

            body_yaw =  (body_yaw.static and ui_get(menu.antiaim[i].static) ~= "-" and current) or 
                        (body_yaw.jitter and ui_get(menu.antiaim[i].jitter) ~= "-" and current),

            fake     =  (ui_get(menu.antiaim[i].fake_limit) == "L/R" and current) or 
                        (ui_get(menu.antiaim[i].fake_limit) == "Random" and current),
        }

        -->> Combo
        ui_set_visible(menu.antiaim[i].pitch, current)
        ui_set_visible(menu.antiaim[i].yaw_base, current)
        ui_set_visible(menu.antiaim[i].yaw, current)
        ui_set_visible(menu.antiaim[i].center, yaw.center)
        ui_set_visible(menu.antiaim[i].skitter, yaw.skitter)
        ui_set_visible(menu.antiaim[i].offset, yaw.offset)
        ui_set_visible(menu.antiaim[i].random, yaw.random)

        ui_set_visible(menu.antiaim[i].body_yaw, current)
        ui_set_visible(menu.antiaim[i].static, body_yaw.static)
        ui_set_visible(menu.antiaim[i].jitter, body_yaw.jitter)

        ui_set_visible(menu.antiaim[i].fake_limit, current)

        -->> Slider
        ui_set_visible(menu.antiaim[i].yaw_slider, current)
        ui_set_visible(menu.antiaim[i].yaw_jitter, (yaw.center or yaw.offset or yaw.random or yaw.skitter) and current)
        ui_set_visible(menu.antiaim[i].bodyyaw_slider, current)
        ui_set_visible(menu.antiaim[i].fake_limit_slider, current)

        -->> Slider add
        ui_set_visible(menu.antiaim[i].yaw_slider_add, yaw_add.yaw)
        ui_set_visible(menu.antiaim[i].yaw_jitter_add, yaw_add.jitter)
        ui_set_visible(menu.antiaim[i].body_yaw_add, yaw_add.body_yaw)
        ui_set_visible(menu.antiaim[i].fake_limit_add, yaw_add.fake)
    end

    ui_set_visible(menu.antiaim.main_tab, alemite)
    -->> Anti-aim(Other)
    for _,v in pairs(menu.extra.manuals) do
        ui_set_visible(v, other)
    end

    for _,v in pairs(menu.extra.freestands) do 
        ui_set_visible(v, other)
    end

    for _, v in pairs(menu.extra.configs) do
        ui_set_visible(v, other)
    end

    local beta = api.build == "Beta"
    for _,v in pairs(menu.extra.fakelag) do
        if _ == "reducer" then
            local alemite = ui_get(menu.extra.fakelag.mode) == "\aB0BDFFFFAlemite"
            ui_set_visible(v, beta and alemite)
        else
            ui_set_visible(v, beta)
        end
    end

    ui_set_visible(references.fake_lag, not beta)
    ui_set_visible(references.fake_lag_limit, not beta)
    ui_set_visible(references.variance, not beta)

    ui_set_visible(menu.extra.utility.fl_antiaim, other)
    ui_set_visible(menu.extra.utility.legit_antiaim, other)
    ui_set_visible(menu.extra.utility.roll_antiaim, other)
    ui_set_visible(menu.extra.utility.anti_backstab, other)

    local utlity = {
        fakelag  = ui_get(menu.extra.utility.fl_antiaim),
        legit_aa = ui_get(menu.extra.utility.legit_antiaim),
        roll_aa = ui_get(menu.extra.utility.roll_antiaim),
        manual_aa = lib.contains(ui_get(menu.extra.utility.legit_aa.condition), "Force static"),
        backstab = ui_get(menu.extra.utility.anti_backstab)
    }

    for _, v in pairs(menu.extra.utility.fakelag) do
        ui_set_visible(v, other and utlity.fakelag)
    end
    
    ui_set_visible(menu.extra.utility.manual, utlity.legit_aa and utlity.manual_aa)
    for _, v in pairs(menu.extra.utility.legit_aa) do
        ui_set_visible(v, other and utlity.legit_aa)
    end

    for _, v in pairs(menu.extra.utility.roll_aa) do
        ui_set_visible(v, other and utlity.roll_aa)
    end

    for _, v in pairs(menu.extra.utility.backstab) do
        ui_set_visible(v, other and utlity.backstab)
    end

    -->> Label Selector
    for _, v in pairs(menu.labels.main) do
        ui_set_visible(v, alemite)
    end

    for _, v in pairs(menu.labels.builder) do
        ui_set_visible(v, builder)
    end

    for _, v in pairs(menu.labels.other) do
        ui_set_visible(v, other)
    end

    for _, v in pairs(menu.labels.visual) do
        ui_set_visible(v, visuals)
    end
    -->> Visuals
    ui_set_visible(menu.visuals.crosshair, visuals)
    ui_set_visible(menu.visuals.manual, visuals)
    ui_set_visible(menu.visuals.breaker, visuals)
    ui_set_visible(menu.visuals.logs, visuals)

    local indicator = {
        crosshair = ui_get(menu.visuals.crosshair),
        manual = ui_get(menu.visuals.manual),
        breaker = ui_get(menu.visuals.breaker),
        logs = ui_get(menu.visuals.logs)
    }

    for _, v in pairs(menu.visuals.cs_main) do
        ui_set_visible(v, visuals and indicator.crosshair)
    end

    for _, v in pairs(menu.visuals.ml_main) do
        ui_set_visible(v, visuals and indicator.manual)
    end

    for _, v in pairs(menu.visuals.bk_main) do
        ui_set_visible(v, visuals and indicator.breaker)
    end

    for _, v in pairs(menu.visuals.lg_main) do
        ui_set_visible(v, visuals and indicator.logs)
    end

    -->> Manual force bind
    ui_set_visible(menu.extra.manuals.manual_state, false)
    ui_set(menu.extra.manuals.left, "On hotkey")
    ui_set(menu.extra.manuals.right, "On hotkey")
    ui_set(menu.extra.manuals.forward, "On hotkey")
    ui_set(menu.extra.manuals.reset, "On hotkey")
end
--------------------------------------------------------------------------------
-- Basic Libaries -> states
--------------------------------------------------------------------------------
local cache_fire = function()
    data_condition.fire = true
    client_delay_call(0.02, function()
        data_condition.fire = false
    end)
end

local fetch = {
    
    pitch = function(tab)
        return ui_get(menu.antiaim[tab].pitch)
    end,

    yaw_base = function(tab)
        return ui_get(menu.antiaim[tab].yaw_base)
    end,

    yaw_offset = function(tab)
        local yaw = ui_get(menu.antiaim[tab].yaw)
        local slider = {
            yaw = ui_get(menu.antiaim[tab].yaw_slider),
            yaw_add = ui_get(menu.antiaim[tab].yaw_slider_add),
        }
        local _return = (yaw == "L/R Center" and lib.jitter(slider.yaw, slider.yaw_add)) or
                        slider.yaw
        return _return
    end,

    yaw_jitter = function(tab)
        local jitter = ui_get(menu.antiaim[tab].yaw)
        local _return = (jitter == "Center" and "Center") or
                        (jitter == "L/R Center" and "Center") or
                        (jitter == "Offset" and "Offset") or
                        (jitter == "Random" and "Random") or
                        (jitter == "3-Way" and "Skitter") or
                        "Off"
        return _return
    end,

    yaw_jitter_offset = function(tab)
        local jitter = ui_get(references.jitter[1])
        local center = ui_get(menu.antiaim[tab].center)
        local offset = ui_get(menu.antiaim[tab].offset)
        local skitter = ui_get(menu.antiaim[tab].skitter)

        local slider = {
            jitter = ui_get(menu.antiaim[tab].yaw_jitter),
            jitter_add = ui_get(menu.antiaim[tab].yaw_jitter_add),
        }

        local jitter_slider = {
            center =    (center == "-" and slider.jitter) or
                        (center == "Random Center" and lib.random(slider.jitter, slider.jitter_add, 180, -180)) or
                        (center == "L/R Center" and lib.jitter(slider.jitter, slider.jitter_add)) or 
                        slider.jitter,
            offset =    (offset == "-" and slider.jitter) or
                        (offset == "Random Offset" and lib.random(slider.jitter, slider.jitter_add, 180, -180)) or
                        (offset == "L/R Offset" and lib.jitter(slider.jitter, slider.jitter_add)) or
                        slider.jitter,
            skitter =   (skitter == "-" and slider.jitter) or
                        (skitter == "L/R Skitter" and lib.jitter(slider.jitter, slider.jitter_add)) or
                        slider.jitter,

            random = slider.jitter
        }

        local _return = (jitter == "Center" and jitter_slider.center) or
                        (jitter == "Offset" and jitter_slider.offset) or
                        (jitter == "Random" and jitter_slider.random) or 
                        (jitter == "Skitter" and jitter_slider.skitter) or 0

        return _return
    end,

    body_yaw = function(tab)
        local body_yaw = ui_get(menu.antiaim[tab].body_yaw)
        local _return = (body_yaw == "Static" and "Static") or
                        (body_yaw == "Jitter" and "Jitter") or
                        "Off"
        return _return
    end,

    body_yaw_offset = function(tab)
        local body_yaw = ui_get(menu.antiaim[tab].body_yaw)
        local slider = {
            body_yaw = ui_get(menu.antiaim[tab].bodyyaw_slider),
            body_yaw_add = ui_get(menu.antiaim[tab].body_yaw_add),
        }
        local logic = {
            static = ui_get(menu.antiaim[tab].static),
            jitter = ui_get(menu.antiaim[tab].jitter)
        }
        local r = math.random(1, 2)
        -->> for here use if for optimize (static antiaim uses too much trace)

        if logic.static == "Freestand" then antiaim_lib.freestand() end

        local bodyyaw_slider = {
            static = (logic.static == "-" and slider.body_yaw) or
                     (logic.static == "Freestand" and fs_data.side) or
                     (logic.static == "Randomize" and (r == 1 and 180) or (r == 2 and -180)),

            jitter = (logic.jitter == "-" and slider.body_yaw) or
                     (logic.jitter == "Random Jitter" and lib.random(slider.body_yaw, slider.body_yaw_add, 180, -180)) or
                     (logic.jitter == "L/R Jitter" and lib.jitter(slider.body_yaw, slider.body_yaw_add))
        }

        local _return = (body_yaw == "Static" and bodyyaw_slider.static) or
                        (body_yaw == "Jitter" and bodyyaw_slider.jitter) or 
                        slider.body_yaw

        return _return
    end,

    fake_limit = function(tab)
        local fake_limit = ui_get(menu.antiaim[tab].fake_limit)

        local slider = {
            fake_limit = ui_get(menu.antiaim[tab].fake_limit_slider),
            fake_limit_add = ui_get(menu.antiaim[tab].fake_limit_add),
        }

        local _return = (fake_limit == "-" and slider.fake_limit) or
                        (fake_limit == "Random" and lib.random(slider.fake_limit, slider.fake_limit_add, 60, 0)) or
                        (fake_limit == "L/R" and lib.jitter(slider.fake_limit, slider.fake_limit_add)) or
                        slider.fake_limit
        return _return
    end,

    fake_lag = function()
        local mode = ui_get(menu.extra.fakelag.mode)

        if mode == "\aB0BDFFFFAlemite" then 
            return "Maximum"
        else
            return mode
        end
    end,

    variance = function()
        return ui_get(menu.extra.fakelag.variance)
    end,

    limit = function()
        local alemite = ui_get(menu.extra.fakelag.mode) == "\aB0BDFFFFAlemite"

        local ignore = {
            dt = ui_get(references.doubletap[1]) and ui_get(references.doubletap[2]),
            os = ui_get(references.onshot[1]) and ui_get(references.onshot[2]),
            fd = ui_get(references.fakeduck[1])
        }

        local sliders = {
            fake_lag = ui_get(menu.extra.fakelag.amount),
        }

        local _return = 
                        (alemite and (ignore.dt or ignore.os or data_condition.fire) and 1) or
                        sliders.fake_lag

        return _return
    end


}



local function roll_angle()
    local local_player = entity_get_local_player()
    local rollangle = true
    -->> InAir -> On key -> Speed -> Stamina -> On hit -> On ladders
    local InAir = (bit_band(entity_get_prop(local_player, "m_fFlags"), 1) == 0)
    local InAir_bind = lib.contains(ui_get(menu.extra.utility.roll_aa.condition), "In Air")

    local onkey_bind = ui_get(menu.extra.utility.roll_aa.rebind)

    local Speed = lib.velocity()
    local Speed_bind = lib.contains(ui_get(menu.extra.utility.roll_aa.condition), "Low Speed")

    local Stamina = (80 - entity_get_prop(local_player, "m_flStamina"))
    local Stamina_bind = lib.contains(ui_get(menu.extra.utility.roll_aa.condition), "Low Stamina")

    local onhit = (entity_get_prop(local_player, "m_flVelocityModifier"))
    local onhit_bind = (ui_get(menu.extra.utility.roll_aa.checkbox_hitchecker))

    local on_ladders = entity.get_prop(local_player, "m_MoveType") == 9
    local on_ladders_bind = lib.contains(ui_get(menu.extra.utility.roll_aa.condition), "On Ladders")

    local on_slowwalk = ui_get(references.slow_walk[2])
    local on_slowwalk_bind = lib.contains(ui_get(menu.extra.utility.roll_aa.condition), "On Slow Walk")
    --Movement Libary

    local air_status = (InAir and InAir_bind)
    local key_status = (onkey_bind)
    local sw_status = (on_slowwalk and on_slowwalk_bind)
    local ladder_status = (on_ladders and on_ladders_bind)
    local stamina_status = (Stamina_bind and 70) or 0

    --Status libary

    local should_roll   = rollangle and (
                        air_status or key_status or sw_status or
                        ((onhit >= 0.9 and Speed_bind) and Speed <= 120) or
                        Stamina <= stamina_status or
                        ladder_status)

    if should_roll then
        data_condition.roll = true
    else
        data_condition.roll = false
    end

end

vanila_skeet_element(false)
local antiaim = function(cmd)
    -->> fakelag condition
    local fakelag = ui_get(menu.extra.utility.fakelag.condition)
    local flg = {
        air = lib.contains(fakelag, "air"),
        crouch = lib.contains(fakelag, "crouch"),
        air_crouch = lib.contains(fakelag, "air crouch"),
        stand = lib.contains(fakelag, "stand"),
        move = lib.contains(fakelag, "move"),
        slowwalk = lib.contains(fakelag, "slowwalk"),
    }
    lib.fl_state(flg.air, flg.crouch, flg.air_crouch, flg.stand, flg.move, flg.slowwalk)

    -->> edge yaw condition
    local edgeyaw = ui_get(menu.extra.freestands.edge_yaw)
    local edy = {
        air = lib.contains(edgeyaw, "air"),
        crouch = lib.contains(edgeyaw, "crouch"),
        air_crouch = lib.contains(edgeyaw, "air crouch"),
        stand = lib.contains(edgeyaw, "stand"),
        move = lib.contains(edgeyaw, "move"),
        slowwalk = lib.contains(edgeyaw, "slowwalk"),
    }
    lib.ey_state(edy.air, edy.crouch, edy.air_crouch, edy.stand, edy.move, edy.slowwalk)

    -->> freestand condition
    local freetand = ui_get(menu.extra.freestands.freestand)
    local frs = {
        air = lib.contains(freetand, "air"),
        crouch = lib.contains(freetand, "crouch"),
        air_crouch = lib.contains(freetand, "air crouch"),
        stand = lib.contains(freetand, "stand"),
        move = lib.contains(freetand, "move"),
        slowwalk = lib.contains(freetand, "slowwalk"),
    }
    lib.fs_state(frs.air, frs.crouch, frs.air_crouch, frs.stand, frs.move, frs.slowwalk)

    -->> Legit AA condition
    local legit_antiaim = ui_get(menu.extra.utility.legit_antiaim)
    if legit_antiaim then antiaim_lib.in_use(cmd) end
    local legit_trigger = (legit_antiaim and client.key_state(0x45)) or
                    (legit_antiaim and ui_get(menu.extra.utility.legit_aa.rebind))

    -->> Backstab condition
    local backstab = ui_get(menu.extra.utility.anti_backstab) and antiaim_lib.backstab()

    -->> Manual condition
    local m_state = ui_get(menu.extra.manuals.manual_state)

    local states = {
        left = ui_get(menu.extra.manuals.left),
        right = ui_get(menu.extra.manuals.right),
        forward = ui_get(menu.extra.manuals.forward),
        reset = ui_get(menu.extra.manuals.reset)
    }

    if states.reset and m_state ~= 0 then ui_set(menu.extra.manuals.manual_state, 0) end

    if  (states.left == bind_system.left) and 
        (states.right == bind_system.right) and 
        (states.forward == bind_system.forward) then goto skip end

    bind_system.left, bind_system.right, bind_system.forward = states.left, states.right, states.forward

    if (states.left and m_state == 1) or (states.right and m_state == 2) or 
    (states.forward and m_state == 3) then ui_set(menu.extra.manuals.manual_state, 0) return end

    if states.left and m_state ~= 1 then ui_set(menu.extra.manuals.manual_state, 1) end
    if states.right and m_state ~= 2 then ui_set(menu.extra.manuals.manual_state, 2) end
    if states.forward and m_state ~= 3 then ui_set(menu.extra.manuals.manual_state, 3) end

    ::skip::

    -->> Extra condition
    local extra = {
        legit_aa = legit_trigger,
        static = legit_trigger and lib.contains(ui_get(menu.extra.utility.legit_aa.condition), "Force Static"),
        legit_roll = legit_trigger and lib.contains(ui_get(menu.extra.utility.legit_aa.condition), "Force Roll"),
        backstab = backstab and "Off",
        manual = (m_state == 1 and -90) or (m_state == 2 and 90) or (m_state == 3 and 180),
        roll = ui_get(menu.extra.utility.roll_antiaim),
        onshot = ui_get(menu.extra.fakelag.mode) == "\aB0BDFFFFAlemite" and api.build == "Beta",
    }

    -->> Legit Condition
    local legit = {
        disabler = extra.legit_aa and "Off",
        body_yaw = extra.static and "Static",
        side = extra.static and (ui_get(menu.extra.utility.manual) and 77 or -77),
        fake_limit = extra.legit_aa and 60,
        roll = extra.legit_roll and 50 or 0
    }

    -->> Roll condition
    if extra.roll then roll_angle() end
    local roll = {
        trigger = extra.roll and data_condition.roll,
        value = (ui_get(menu.extra.utility.roll_aa.slider_roll))
    }

    -->> Onshot condition
    local os_trigger = extra.onshot and data_condition.fire 
    local reduce = ui_get(menu.extra.fakelag.reducer)
    local onshot = {

        jitter = os_trigger and (lib.contains(reduce, "Force Static") and "Off"),

        body_yaw = os_trigger and ((lib.contains(reduce, "No Choke") and "Off") or 
                                  (lib.contains(reduce, "Force Static") and "Static")),
        
        side = os_trigger and (lib.contains(reduce, "Force Static") and 180)
    }

    if (lib.contains(reduce, "Force Defensive")) and os_trigger then cmd.force_defensive = true end
    if (lib.contains(reduce, "No Choke")) and os_trigger then cmd.no_choke = true end

    -->> antiaim
    cmd.roll = (extra.legit_aa and lib.jitter(legit.roll, -legit.roll)) or
               (roll.trigger and lib.jitter(roll.value, -roll.value))

    data_condition.roll = extra.roll
    data_condition.lg = extra.legit_aa
    data_condition.choke = cmd.chokedcommands
    if cmd.chokedcommands ~= 0 and not os_trigger then return end
    local i = lib.get_state()
    ui_set(references.pitch, legit.disabler or extra.backstab or fetch.pitch(i))
    ui_set(references.yaw[1], legit.disabler or extra.backstab or fetch.yaw_base(i))
    ui_set(references.yaw[2], extra.manual or fetch.yaw_offset(i))
    ui_set(references.jitter[1], onshot.jitter or fetch.yaw_jitter(i))
    ui_set(references.jitter[2], fetch.yaw_jitter_offset(i))
    ui_set(references.body_yaw[1], onshot.body_yaw or legit.body_yaw or fetch.body_yaw(i))
    ui_set(references.body_yaw[2], onshot.side or legit.side or fetch.body_yaw_offset(i))
    --ui_set(references.fake_limit, legit.fake_limit or fetch.fake_limit(i))
    -----------------------------------------------------------------------
    if api.build ~= "Beta" then return end
    ui_set(references.fake_lag, fetch.fake_lag())
    ui_set(references.variance, fetch.variance())
    ui_set(references.fake_lag_limit, fetch.limit())
end

local var = {
    anim = {0, 0, 0, 0, 0, 0, 0, 0, 0},
    offset = {0, 0, 0, 0, 0, 0, 0, 0},
    alpha = {0, 0, 0, 0, 0, 0},
    exp = {0, 0, 0, 0, 0, 0},
    exp_cache = {0, 0, 0, 0, 0, 0},
    text = {"DT", "HIDE", "FS", "EDGE", "BAIM"},
    line = {0, 0},
    manual = {left = 0, right = 0}
}

local function lerp(start, vend, time)
return start + (vend - start) * time end

local rgb_to_hex = function(color, a)
return string.format('%02X%02X%02X%02X', color[1], color[2], color[3], a) end

local indicator = function()
    local ss = {client_screen_size()}
    local center_x, center_y = ss[1] / 2, ss[2] / 2

    local local_player = entity_get_local_player()
	if not entity_is_alive(local_player) then return end

    local i =   data_condition.roll and 9 or
                data_condition.lg and 8 or 
                lib.get_state()
    local data = {
        name = "ALEMITE", version = string.upper(api.build),
        state = index.state[i], choke = globals.chokedcommands(), 
        color_a = {ui_get(menu.visuals.cs_main.main)}, color_b = {ui_get(menu.visuals.cs_main.alt)}, 
        color_c = {ui_get(menu.visuals.cs_main.key)}, animation = ui_get(menu.visuals.cs_main.animation)
    }

    -->> Indicator tag
    local pulse = 50 + math.abs(math.sin(globals.curtime() * 3.1) * 200);
    local long, width = renderer_measure_text("-", data.name)
    local alemite = g_text(data.color_a, data.color_b, data.name)
    renderer_text(center_x, center_y + 15, 255, 255, 255, 255, "c-", nil, alemite.."  \a"..rgb_to_hex(data.color_c, pulse), data.version)

    -->> Player state
    local state =   (i == 1 and "SLOW") or
                    (i == 2 and "RUN") or
                    (i == 3 and "STAND") or
                    (i == 4 and "DUCK") or
                    (i == 5 and "AIR") or
                    (i == 6 and "AIR-DUCK") or
                    (i == 7 and "FAKE-LAG") or
                    (i == 8 and "-LEGIT-") or
                    (i == 9 and "-ROLL-")

    for states = 1, #var.anim do
        local state_frames = data.animation * globals_frametime()
        if i == states then
            var.anim[states] = var.anim[states] + state_frames
            if var.anim[states] > 0.99 then var.anim[states] = 1 end
        else
            var.anim[states] = 0
        end
    end

    if i == 7 then
        renderer_rectangle(center_x + 4 - 20, center_y + 27 - var.anim[i] * 5, 37, 6, 17, 17, 17, 230)

        renderer_gradient(center_x + 4 - 19, center_y + 28 - var.anim[i] * 5, (18 + data.choke * ui_get(references.fake_lag_limit)) > 35 and 35 or (18 + data.choke * ui_get(references.fake_lag_limit)), 4, 
                            data.color_a[1], data.color_a[2], data.color_a[3], data.color_a[4],
                            data.color_a[1], data.color_a[2], data.color_a[3], 0, true)
    else
        local desync = entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local desync_state = (desync < 0 and "/>"..state.."</" or "\\<"..state..">\\")
        renderer_text(center_x, center_y + 30 - var.anim[i] * 5, 
                    data.color_a[1], data.color_a[2], data.color_a[3], var.anim[i] * data.color_a[4],
                    "c-", nil, desync_state)
    end



    -->> Keybind
    local key_table = ui_get(menu.visuals.cs_main.keybind)
    local keybind = {
        lib.contains(key_table, "Double-tap") and ((ui_get(references.doubletap[1]) and (ui_get(references.doubletap[2])))),
        lib.contains(key_table, "Hide shot") and ((ui_get(references.onshot[1]) and (ui_get(references.onshot[2])))),
        lib.contains(key_table, "Freestand") and ((ui_get(references.freestanding[2]))),
        lib.contains(key_table, "Edge yaw") and ( (ui_get(references.edge_yaw))),
        lib.contains(key_table, "Body aim") and ((ui_get(references.fba_key))),
    }
    for i = 1, #keybind, 1 do
        var.offset[i] = lerp(var.offset[i], keybind[i] and 15 or 0 , globals_frametime() * data.animation)
        var.alpha[i] = lerp(var.alpha[i], keybind[i] and 255 or 0 , globals_frametime() * data.animation)
        var.exp[i] = lerp(var.exp[i], keybind[i] and 10 or 0 , globals_frametime() * data.animation)
        var.exp_cache[i] =  (i == 1 and 0) or 
                            (i == 2 and var.exp[1]) or 
                            (i == 3 and var.exp[2] + var.exp[1]) or 
                            (i == 4 and var.exp[3] + var.exp[2] + var.exp[1]) or 
                            (i == 5 and var.exp[4] + var.exp[3] + var.exp[2] + var.exp[1]) or
                            (i == 6 and var.exp[5] + var.exp[4] + var.exp[3] + var.exp[2] + var.exp[1])
        renderer_text(center_x, center_y + 50 - var.offset[i] + var.exp_cache[i], 
            data.color_c[1], data.color_c[2], data.color_c[3],
        var.alpha[i], "-c", nil, var.text[i])
    end
end


local font = {left = "<", right = ">"}
local font_grabber = {

    Run = function()

        local asd_http_ouo = require "gamesense/http"

        local str_to_sub = function(input, sep)
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
            local header = '[\aBBC8FFalphaAlemite\aFFFFFFalpha] '
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


local manual_indicator = function()
    local m_state = ui_get(menu.extra.manuals.manual_state)
    local r, g, b, a = ui_get(menu.visuals.ml_main.color)
    local w, h = client.screen_size()
    local distance = (w/2) / 210 * ui_get(menu.visuals.ml_main.dist)
    -- ⯇ ⯈ ⯅ ⯆
    
    if m_state == 1 then
        var.manual.left = lerp(var.manual.left,40, globals_frametime() * 6)
        renderer_text(w/2 - distance - var.manual.left, h / 2 - 1,  r, g, b, var.manual.left * 4 + 90, "+c", 0, font.right)
        else
        var.manual.left = lerp(var.manual.left, 0, globals_frametime() * 6)
        renderer_text(w/2 - distance - var.manual.left, h / 2 - 1, r, g, b, var.manual.left * 4 + 90, "+c", 0, font.right)
    end        
    if m_state == 2 then 
        var.manual.right = lerp(var.manual.right,40, globals_frametime() * 6)
        renderer_text(w/2 + distance + var.manual.right, h / 2 - 1, r, g, b, var.manual.right * 4 + 90, "+c", 0, font.left) 
    else
        var.manual.right = lerp(var.manual.right,0, globals_frametime() * 6)
        renderer_text(w/2 + distance + var.manual.right, h / 2 - 1, r, g, b, var.manual.right * 4 + 90, "+c", 0, font.left) 
    end
end

local animation_cache = {
    ground_ticks = 0, end_time = 0,
}
local animation_breaker = function()
    local local_player = entity_get_local_player()
    if not entity_is_alive(local_player) then return end

    if lib.contains(ui_get(menu.visuals.bk_main.list),'Static legs in air') then 
        entity_set_prop(local_player, "m_flPoseParameter", 1, 6) 
    end
       
    if lib.contains(ui_get(menu.visuals.bk_main.list),'Pitch zero on land') then
        local on_ground = bit_band(entity_get_prop(local_player, "m_fFlags"), 1)
        if on_ground == 1 then
            animation_cache.ground_ticks = animation_cache.ground_ticks + 1
        else
            animation_cache.ground_ticks = 0
            animation_cache.end_time = globals_curtime() + 1
        end 
    
        if animation_cache.ground_ticks > ui_get(references.fake_lag_limit) + 1 and animation_cache.end_time > globals_curtime() then
            entity_set_prop(local_player, "m_flPoseParameter", 0.5, 12)
        end
    end 
    
    local legs_types = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
    if lib.contains(ui_get(menu.visuals.bk_main.list),'Leg fucker') then
        ui_set(references.leg_movement, legs_types[2])
        entity_set_prop(local_player, "m_flPoseParameter", 8, 0)
    end
end

local shutdown = function()
    vanila_skeet_element(true)
    ui_set_visible(references.fake_lag, true)
    ui_set_visible(references.fake_lag_limit, true)
    ui_set_visible(references.variance, true)
end

local paint_log = logs.draw()
local on_paint = function()
    menu_visible()
    local log_paint = ui_get(menu.visuals.logs) and ui_get(menu.visuals.lg_main.indicator)
    if log_paint then paint_log.main() end
    local crosshair = ui_get(menu.visuals.crosshair)
    if crosshair then indicator() end
    local manual = ui_get(menu.visuals.manual)
    if manual then manual_indicator() end
end

local function aim_miss(shot)
    local enables = {
        console = lib.contains(ui_get(menu.visuals.lg_main.console), 'Aimbot miss'),
    }
    local colors = {
        {ui_get(menu.visuals.lg_main.color_1)},
        {ui_get(menu.visuals.lg_main.color_2)},
        {ui_get(menu.visuals.lg_main.color_3)},
        {ui_get(menu.visuals.lg_main.color_4)},
        {ui_get(menu.visuals.lg_main.color_5)}
    }

    if enables.console then logs.on_aim_miss(shot) end
    console_logs.on_aim_miss(shot, enables.console, colors[1], colors[2], colors[3], colors[4], colors[5])
end

local function player_hurt(shot)
    local enables = {
        console = lib.contains(ui_get(menu.visuals.lg_main.console), 'Aimbot hits'),
    }
    local colors = {
        {ui_get(menu.visuals.lg_main.color_1)},
        {ui_get(menu.visuals.lg_main.color_2)},
        {ui_get(menu.visuals.lg_main.color_3)},
        {ui_get(menu.visuals.lg_main.color_4)},
        {ui_get(menu.visuals.lg_main.color_5)}
    }

    if enables.console then logs.on_player_hurt(shot) end
    console_logs.on_player_hurt(shot, enables.console, colors[1], colors[2], colors[3], colors[4], colors[5])
end

local function bullet_impact(shot)
    local enables = {
        console = lib.contains(ui_get(menu.visuals.lg_main.console), 'Aimbot hits'),
    }
    if enables.console then logs.miss_brute(shot) end
end

local setup_command = function(cmd)
    antiaim(cmd)
end

local pre_render = function()
    local anim = ui_get(menu.visuals.breaker)
    if anim then animation_breaker() end
end
--------------------------------------------------------------------------------
-- Basic Libaries -> Callbacks
--------------------------------------------------------------------------------
client_set_event_callback("aim_miss", aim_miss)
client_set_event_callback("player_hurt", player_hurt)
client_set_event_callback("bullet_impact", bullet_impact)
client_set_event_callback("paint_ui", on_paint)
client_set_event_callback("pre_render", pre_render)
client_set_event_callback("setup_command", setup_command)
client_set_event_callback("shutdown", shutdown)
client_set_event_callback("aim_fire", cache_fire)
