-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server

local bit_band, bit_lshift, client_color_log, client_create_interface, client_delay_call, client_find_signature, client_key_state, client_reload_active_scripts, client_screen_size, client_set_event_callback, client_system_time, client_timestamp, client_unset_event_callback, database_read, database_write, entity_get_classname, entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_prop, entity_get_steam64, entity_is_alive, globals_framecount, globals_realtime, math_ceil, math_floor, math_max, math_min, panorama_loadstring, renderer_gradient, renderer_line, renderer_rectangle, table_concat, table_insert, table_remove, table_sort, ui_get, ui_is_menu_open, ui_mouse_position, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_slider, ui_set, ui_set_visible, setmetatable, pairs, error, globals_absoluteframetime, globals_curtime, globals_frametime, globals_maxplayers, globals_tickcount, globals_tickinterval, math_abs, type, pcall, renderer_circle_outline, renderer_load_rgba, renderer_measure_text, renderer_text, renderer_texture, tostring, ui_name, ui_new_button, ui_new_hotkey, ui_new_label, ui_new_listbox, ui_new_textbox, ui_reference, ui_set_callback, ui_update, unpack, tonumber = bit.band, bit.lshift, client.color_log, client.create_interface, client.delay_call, client.find_signature, client.key_state, client.reload_active_scripts, client.screen_size, client.set_event_callback, client.system_time, client.timestamp, client.unset_event_callback, database.read, database.write, entity.get_classname, entity.get_local_player, entity.get_origin, entity.get_player_name, entity.get_prop, entity.get_steam64, entity.is_alive, globals.framecount, globals.realtime, math.ceil, math.floor, math.max, math.min, panorama.loadstring, renderer.gradient, renderer.line, renderer.rectangle, table.concat, table.insert, table.remove, table.sort, ui.get, ui.is_menu_open, ui.mouse_position, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.set, ui.set_visible, setmetatable, pairs, error, globals.absoluteframetime, globals.curtime, globals.frametime, globals.maxplayers, globals.tickcount, globals.tickinterval, math.abs, type, pcall, renderer.circle_outline, renderer.load_rgba, renderer.measure_text, renderer.text, renderer.texture, tostring, ui.name, ui.new_button, ui.new_hotkey, ui.new_label, ui.new_listbox, ui.new_textbox, ui.reference, ui.set_callback, ui.update, unpack, tonumber
local client_register_esp_flag, client_visible, entity_hitbox_position, math_ceil, math_pow, math_sqrt, renderer_indicator, unpack, tostring, pairs = client.register_esp_flag, client.visible, entity.hitbox_position, math.ceil, math.pow, math.sqrt, renderer.indicator, unpack, tostring, pairs
local ui_new_button, ui_new_color_picker, ui_new_label, ui_reference, ui_new_checkbox, ui_new_combobox, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_set, ui_get, ui_set_callback, ui_set_visible = ui.new_button, ui.new_color_picker, ui.new_label, ui.reference, ui.new_checkbox, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.set, ui.get, ui.set_callback, ui.set_visible
local client_screen_size, client_set_cvar, client_log, client_color_log, client_set_event_callback, client_unset_event_callback = client.screen_size, client.set_cvar, client.log, client.color_log, client.set_event_callback, client.unset_event_callback
local entity_get_player_name, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_is_alive = entity.get_player_name, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.is_alive
local globals_tickcount, globals_curtime, globals_realtime, globals_frametime = globals.tickcount, globals.curtime, globals.realtime, globals.frametime
local renderer_triangle, renderer_text, renderer_rectangle, renderer_gradient = renderer.triangle, renderer.text, renderer.rectangle, renderer.gradient
local client_exec = client.exec
--------------------------------------------------------------------------------
-- Basic Libaries
--------------------------------------------------------------------------------
local TAB = {"RAGE", "Aimbot", "RAGE", "Aimbot", "Other"}
local configs, main, keybinds, labels, indicator = {}, {}, {}, {}, {}
local font = "-> "
local tab = 1
--------------------------------------------------------------------------------
-- Render Libaries
--------------------------------------------------------------------------------
local ragebot = {
    --[[
    RAGE, Aimbot, Automatic fire                ---> changed to: RAGE, Other, Automatic fire
    RAGE, Aimbot, Automatic penetration         ---> changed to: RAGE, Other, Automatic penetration 
    RAGE, Aimbot, Silent aim                    ---> changed to: RAGE, Other, Silent aim
    RAGE, Aimbot, Reduce aim step               ---> changed to: RAGE, Other, Reduce aim step
    RAGE, Aimbot, Maximum FOV                   ---> changed to: RAGE, Other, Maximum FOV
    RAGE, Aimbot, Log misses due to spread      ---> changed to: RAGE, Other, Log misses due to spread
    RAGE, Aimbot, Low FPS mitigations           ---> changed to: RAGE, Other, Low FPS mitigations
    RAGE, Other, Quick stop                     ---> changed to: RAGE, Aimbot, Quick stop
    RAGE, Other, Quick stop options
    RAGE, Other, Anti-aim correction override
    RAGE, Other, Prefer body aim                ---> changed to: RAGE, Aimbot, Prefer body aim     
    RAGE, Other, Prefer body aim disablers      ---> changed to: RAGE, Aimbot, Prefer body aim disablers    
    RAGE, Other, Force body aim                 ---> changed to: RAGE, Aimbot, Force body aim  
    RAGE, Other, Double tap                     ---> changed to: RAGE, Aimbot, Double tap  
    RAGE, Other, Double tap mode                ---> changed to: RAGE, Aimbot, Double tap mode
    RAGE, Other, Double tap hit chance          ---> changed to: RAGE, Aimbot, Double tap hit chance  
    RAGE, Other, Double tap fake lag limit      ---> changed to: RAGE, Aimbot, Double tap fake lag limit    
    RAGE, Other, Double tap quick stop          ---> changed to: RAGE, Aimbot, Double tap quick stop  
    AA, Anti-aimbot angles, Fake yaw limit
    AA, Other, Slow motion type
    MISC, Settings, sv_maxusrcmdprocessticks
    MISC, Settings, sv_maxunlag
    ]]

    enabled = {ui_reference(TAB[1], TAB[2], "Enabled")},
    target_selection = ui_reference(TAB[1], TAB[2], "Target selection"),
    target_hitbox = ui_reference(TAB[1], TAB[2], "Target hitbox"),
    multipoint = {ui_reference(TAB[1], TAB[2], "Multi-point")},
    multipoint_scale = ui_reference(TAB[1], TAB[2], "Multi-point scale"),
    prefer_safepoint = ui_reference(TAB[1], TAB[2], "Prefer safe point"),
    force_safepoint = ui_reference(TAB[1], TAB[2], "Force safe point"),
    avoid_unsafe_hitboxes = ui_reference(TAB[1], TAB[2], "Avoid unsafe hitboxes"),
    automatic_fire = ui_reference(TAB[1], TAB[5], "Automatic fire"),
    automatic_penetration = ui_reference(TAB[1], TAB[5], "Automatic penetration"),
    silent_aim = ui_reference(TAB[1], TAB[5], "Silent aim"),
    hitchance = ui_reference(TAB[1], TAB[2], "Minimum hit chance"),
    minimum_damage = ui_reference(TAB[1], TAB[2], "Minimum damage"),
    auto_scope = ui_reference(TAB[1], TAB[2], "Automatic scope"),
    reduce_aim_step = ui_reference(TAB[1], TAB[5], "Reduce aim step"),
    maximum_fov = ui_reference(TAB[1], TAB[5], "Maximum FOV"),
    log_misses_due_to_spread = ui_reference(TAB[1], TAB[5], "Log misses due to spread"),
    low_fps_mitigations = ui_reference(TAB[1], TAB[5], "Low FPS mitigations"),

    remove_recoil = ui_reference(TAB[1], TAB[5], "Remove recoil"),
    accuracy_boost = ui_reference(TAB[1], TAB[5], "Accuracy boost"),
    delay_shot = ui_reference(TAB[1], TAB[5], "Delay shot"),
    quick_stop = {ui_reference(TAB[1], TAB[2], "Quick stop")},
    quick_peek_assist = {ui_reference(TAB[1], TAB[5], "Quick peek assist")},
    quick_peek_assist_mode = {ui_reference(TAB[1], TAB[5], "Quick peek assist mode")},
    quick_peek_assist_distance = ui_reference(TAB[1], TAB[5], "Quick peek assist distance"),
    resolver = ui_reference(TAB[1], TAB[5], "Anti-aim correction"),
    prefer_body_aim = ui_reference(TAB[1], TAB[2], "Prefer body aim"),
    prefer_body_aim_disablers = ui_reference(TAB[1], TAB[2], "Prefer body aim disablers"),
    force_body_aim = ui_reference(TAB[1], TAB[2], "Force body aim"),
    force_body_aim_on_peek = ui_reference(TAB[1], TAB[2], "Force body aim on peek"),
    duck_peek_assist = ui_reference(TAB[1], TAB[5], "Duck peek assist"),
    double_tap = {ui_reference(TAB[1], TAB[2], "Double tap")},
    --double_tap_mode = ui_reference(TAB[1], TAB[2], "Double tap mode"),
    double_tap_hitchance = ui_reference(TAB[1], TAB[2], "Double tap hit chance"),
    double_tap_fake_lag_limit = ui_reference(TAB[1], TAB[2], "Double tap fake lag limit"),
    double_tap_quick_stop = ui_reference(TAB[1], TAB[2], "Double tap quick stop"),
    ping_spike = {ui_reference("MISC", "miscellaneous", "ping spike")},
    baim_hitboxes = {3, 4, 5, 6},
    fake_lag_limit = ui_reference("AA", "Fake lag", "Limit")
}

local notify=(function()local b={callback_registered=false,maximum_count=7,data={},svg_texture=[[<svg xmlns="http://www.w3.org/2000/svg" width="30.093" height="28.944"><path fill-rule="evenodd" clip-rule="evenodd" fill="#FFF" d="M11.443,8.821c0.219,1.083,0.241,2.045,0.064,2.887 c-0.177,0.843-0.336,1.433-0.479,1.771c0.133-0.249,0.324-0.531,0.572-0.848c0.708-0.906,1.706-1.641,2.993-2.201 c0.661-0.29,1.171-0.501,1.527-0.635c1.144-0.434,1.763-0.995,1.859-1.687c0.082-0.563,0.043-1.144-0.118-1.74 c-0.155-0.586-0.193-1.108-0.117-1.567c0.099-0.591,0.483-1.083,1.153-1.478c0.258-0.152,0.51-0.269,0.757-0.35 c-0.037,0.022-0.114,0.263-0.229,0.722c-0.115,0.458-0.038,1.018,0.234,1.676c0.271,0.658,0.472,1.133,0.604,1.42 c0.132,0.29,0.241,0.853,0.324,1.689c0.084,0.838-0.127,1.822-0.629,2.952c-0.502,1.132-1.12,1.89-1.854,2.275 c-0.732,0.386-1.145,0.786-1.237,1.203c-0.092,0.419,0.087,0.755,0.535,1.013s0.927,0.282,1.436,0.074 c0.577-0.238,0.921-0.741,1.031-1.508c0.108-0.751,0.423-1.421,0.945-2.009c0.393-0.438,0.943-0.873,1.654-1.3 c0.24-0.143,0.532-0.285,0.879-0.43c0.192-0.078,0.47-0.191,0.835-0.338c0.622-0.276,1.075-0.65,1.358-1.123 c0.298-0.491,0.465-1.19,0.505-2.096c0.011-0.284,0.009-0.571-0.004-0.862c0.446,0.265,0.796,0.788,1.048,1.568 c0.251,0.782,0.32,1.457,0.206,2.025c-0.113,0.568-0.318,1.059-0.611,1.472c-0.295,0.412-0.695,0.901-1.201,1.469 c-0.519,0.578-0.864,0.985-1.04,1.222c-0.318,0.425-0.503,0.795-0.557,1.109c-0.044,0.269-0.05,0.763-0.016,1.481 c0.05,1.016,0.075,1.695,0.075,2.037c0,1.836-0.334,3.184-1.004,4.045c-0.874,1.123-1.731,1.902-2.568,2.336 c-0.955,0.49-2.228,0.736-3.813,0.736c-1.717,0-3.154-0.246-4.313-0.736c-1.237-0.525-2.083-1.303-2.541-2.336 c-0.394-0.885-0.668-1.938-0.827-3.158c-0.05-0.385-0.083-0.76-0.103-1.127c-0.49-0.092-0.916,0.209-1.278,0.904 c-0.36,0.693-0.522,1.348-0.484,1.957c0.039,0.611,0.246,1.471,0.625,2.578c0.131,0.449,0.185,0.801,0.161,1.051 c-0.031,0.311-0.184,0.521-0.456,0.631c-0.321,0.129-0.688,0.178-1.1,0.146c-0.463-0.037-0.902-0.174-1.319-0.41 c-1.062-0.604-1.706-1.781-1.937-3.531c-0.229-1.75-0.301-3.033-0.214-3.85c0.086-0.814,0.342-1.613,0.77-2.398 c0.428-0.783,0.832-1.344,1.213-1.681c0.382-0.338,0.893-0.712,1.532-1.122c0.64-0.408,1.108-0.745,1.405-1.008 c0.438-0.383,0.715-0.807,0.83-1.271C8.824,9.292,8.52,7.952,7.613,6.456C7.33,5.988,7.005,5.532,6.637,5.087 c0.837,0.111,1.791,0.49,2.865,1.138C10.576,6.872,11.223,7.737,11.443,8.821z"/></svg>]]}local c={w=20,h=20}local d=renderer.load_svg(b.svg_texture,c.w,c.h)function b:register_callback()if self.callback_registered then return end;client_set_event_callback("paint_ui",function()local e={client_screen_size()}local f={15,15,15}local g=5;local h=self.data;for i=#h,1,-1 do h[i].time=h[i].time-globals.frametime()local j,k=255,0;local l=h[i]if l.time<0 then table.remove(h,i)else local m=l.def_time-l.time;local m=m>1 and 1 or m;if l.time<0.5 or m<0.5 then k=(m<1 and m or l.time)/0.5;j=k*255;if k<0.2 then g=g+15*(1.0-k/0.2)end end;local n={renderer.measure_text("dc",l.draw)}local o={e[1]/2-n[1]/2+3,e[2]-e[2]/100*17.4+g}renderer.rectangle(o[1]-30,o[2]-22,n[1]+60,2,161,192,255,j)renderer.rectangle(o[1]-29,o[2]-20,n[1]+58,29,f[1],f[2],f[3],j<=135 and j or 135)renderer.line(o[1]-30,o[2]-22,o[1]-30,o[2]-20+30,83,126,242,j<=50 and j or 50)renderer.line(o[1]-30+n[1]+60,o[2]-22,o[1]-30+n[1]+60,o[2]-20+30,83,126,242,j<=50 and j or 50)renderer.line(o[1]-30,o[2]-20+30,o[1]-30+n[1]+60,o[2]-20+30,83,126,242,j<=50 and j or 50)renderer.text(o[1]+n[1]/2+10,o[2]-5,255,255,255,j,"dc",nil,l.draw)renderer.texture(d,o[1]-c.w/2-5,o[2]-c.h/2-5,c.w,c.h,255,255,255,j)g=g-50 end end;self.callback_registered=true end)end;function b:paint(p,q)local r=tonumber(p)+1;for i=self.maximum_count,2,-1 do self.data[i]=self.data[i-1]end;self.data[1]={time=r,def_time=r,draw=q}self:register_callback()end;return b end)()
local solus_render=(function()local b={}local c=function(x,y,d,e,f,g,h,i,j)renderer.rectangle(x+f,y,d-f*2,f,g,h,i,j)renderer.rectangle(x,y+f,f,e-f*2,g,h,i,j)renderer.rectangle(x+f,y+e-f,d-f*2,f,g,h,i,j)renderer.rectangle(x+d-f,y+f,f,e-f*2,g,h,i,j)renderer.rectangle(x+f,y+f,d-f*2,e-f*2,g,h,i,j)renderer.circle(x+f,y+f,g,h,i,j,f,180,0.25)renderer.circle(x+d-f,y+f,g,h,i,j,f,90,0.25)renderer.circle(x+f,y+e-f,g,h,i,j,f,270,0.25)renderer.circle(x+d-f,y+e-f,g,h,i,j,f,0,0.25)end;local k=4;local l=k+2;local m=45;local n=20;local o=function(x,y,p,q,f,g,h,i,j)renderer.rectangle(x+2,y+f+l,1,q-l*2-f*2,g,h,i,j)renderer.rectangle(x+p-3,y+f+l,1,q-l*2-f*2,g,h,i,j)renderer.rectangle(x+f+l,y+2,p-l*2-f*2,1,g,h,i,j)renderer.rectangle(x+f+l,y+q-3,p-l*2-f*2,1,g,h,i,j)renderer.circle_outline(x+f+l,y+f+l,g,h,i,j,f+k,180,0.25,1)renderer.circle_outline(x+p-f-l,y+f+l,g,h,i,j,f+k,270,0.25,1)renderer.circle_outline(x+f+l,y+q-f-l,g,h,i,j,f+k,90,0.25,1)renderer.circle_outline(x+p-f-l,y+q-f-l,g,h,i,j,f+k,0,0.25,1)end;local r=function(x,y,p,q,f,g,h,i,j,s)local m=j/255*m;renderer.rectangle(x+f,y,p-f*2,1,g,h,i,j)renderer.circle_outline(x+f,y+f,g,h,i,j,f,180,0.25,1)renderer.circle_outline(x+p-f,y+f,g,h,i,j,f,270,0.25,1)renderer.gradient(x,y+f,1,q-f*2,g,h,i,j,g,h,i,m,false)renderer.gradient(x+p-1,y+f,1,q-f*2,g,h,i,j,g,h,i,m,false)renderer.circle_outline(x+f,y+q-f,g,h,i,m,f,90,0.25,1)renderer.circle_outline(x+p-f,y+q-f,g,h,i,m,f,0,0.25,1)renderer.rectangle(x+f,y+q-1,p-f*2,1,g,h,i,m)local t=true;if t then for f=4,s do local f=f/2;o(x-f,y-f,p+f*2,q+f*2,f,g,h,i,s-f*2)end end end;local u=function(x,y,p,q,f,g,h,i,j,s,v,w,z,A)local m=j/255*m;renderer.rectangle(x,y+f,1,q-f*2,g,h,i,j)renderer.circle_outline(x+f,y+f,g,h,i,j,f,180,0.25,1)renderer.circle_outline(x+f,y+q-f,g,h,i,j,f,90,0.25,1)renderer.gradient(x+f,y,p/3.5-f*2,1,g,h,i,j,0,0,0,m/0,true)renderer.gradient(x+f,y+q-1,p/3.5-f*2,1,g,h,i,j,0,0,0,m/0,true)renderer.rectangle(x+f,y+q-1,p-f*2,1,v,w,z,m)renderer.rectangle(x+f,y,p-f*2,1,v,w,z,m)renderer.circle_outline(x+p-f,y+f,v,w,z,m,f,-90,0.25,1)renderer.circle_outline(x+p-f,y+q-f,v,w,z,m,f,0,0.25,1)renderer.rectangle(x+p-1,y+f,1,q-f*2,v,w,z,m)if A then for f=4,s do local f=f/2;o(x-f,y-f,p+f*2,q+f*2,f,v,w,z,s-f*2)end end end;local B=function(x,y,p,q,f,g,h,i,j,s,v,w,z)local m=j/255*m;renderer.rectangle(x+f,y,p-f*2,1,g,h,i,m)renderer.circle_outline(x+f,y+f,g,h,i,m,f,180,0.25,1)renderer.circle_outline(x+p-f,y+f,g,h,i,m,f,270,0.25,1)renderer.rectangle(x,y+f,1,q-f*2,g,h,i,m)renderer.rectangle(x+p-1,y+f,1,q-f*2,g,h,i,m)renderer.circle_outline(x+f,y+q-f,g,h,i,m,f,90,0.25,1)renderer.circle_outline(x+p-f,y+q-f,g,h,i,m,f,0,0.25,1)renderer.rectangle(x+f,y+q-1,p-f*2,1,g,h,i,m)if ui_get(config.glow_enabled)then for f=4,s do local f=f/2;o(x-f,y-f,p+f*2,q+f*2,f,v,w,z,s-f*2)end end end;b.linear_interpolation=function(C,D,E)return(D-C)*E+C end;b.clamp=function(F,G,H)if G>H then return math.min(math.max(F,H),G)else return math.min(math.max(F,G),H)end end;b.lerp=function(C,D,E)E=E or 0.005;E=b.clamp(globals.frametime()*E*175.0,0.01,1.0)local j=b.linear_interpolation(C,D,E)if D==0.0 and j<0.01 and j>-0.01 then j=0.0 elseif D==1.0 and j<1.01 and j>0.99 then j=1.0 end;return j end;b.container=function(x,y,p,q,g,h,i,j,I,J,K,L,M,N)if I*255>0 then renderer.blur(x,y,p,q)end;c(x,y,p,q,k,J,K,L,M)r(x,y,p,q,k,g,h,i,j,I*n)if not N then return end;N(x+k,y+k,p-k*2,q-k*2.0)end;b.horizontal_container=function(x,y,p,q,g,h,i,j,I,v,w,z,N)if I*255>0 then renderer.blur(x,y,p,q)end;c(x,y,p,q,k,17,17,17,j)u(x,y,p,q,k,g,h,i,I*255,I*n,v,w,z)if not N then return end;N(x+k,y+k,p-k*2,q-k*2.0)end;b.container_glow=function(x,y,p,q,g,h,i,j,I,v,w,z,N)if I*255>0 then renderer.blur(x,y,p,q)end;c(x,y,p,q,k,17,17,17,j)B(x,y,p,q,k,g,h,i,I*255,I*n,v,w,z)if not N then return end;N(x+k,y+k,p-k*2,q-k*2.0)end;b.measure_multitext=function(O,P)local j=0;for i,Q in pairs(P)do Q.flags=Q.flags or""j=j+renderer.measure_text(Q.flags,Q.text)end;return j end;b.multitext=function(x,y,P)for j,i in pairs(P)do i.flags=i.flags or""i.limit=i.limit or 0;i.color=i.color or{255,255,255,255}i.color[4]=i.color[4]or 255;renderer.text(x,y,i.color[1],i.color[2],i.color[3],i.color[4],i.flags,i.limit,i.text)x=x+renderer.measure_text(i.flags,i.text)end end;return b end)()
local dragging_fn=function(b,c,d)return(function()local e={}local f,g,h,i,j,k,l,m,n,o,p,q,r,s;local t={__index={drag=function(self,...)local u,v=self:get()local w,x,q=e.drag(u,v,...)if u~=w or v~=x then self:set(w,x)end;return w,x,q end,status=function(self,...)local w,x=self:get()local y,z=e.status(w,x,...)return y end,set=function(self,u,v)local n,o=client_screen_size()ui_set(self.x_reference,u/n*self.res)ui_set(self.y_reference,v/o*self.res)end,get=function(self)local n,o=client_screen_size()return ui_get(self.x_reference)/self.res*n,ui_get(self.y_reference)/self.res*o end}}function e.new(y,z,A,B)B=B or 10000;local n,o=client_screen_size()local C=ui_new_slider("LUA","A",y.." window position",0,B,z/n*B)local D=ui_new_slider("LUA","A","\n"..y.." window position y",0,B,A/o*B)ui_set_visible(C,false)ui_set_visible(D,false)return setmetatable({name=y,x_reference=C,y_reference=D,res=B},t)end;function e.drag(u,v,E,F,G,H,I)local t="n"if globals_framecount()~=f then g=ui_is_menu_open()j,k=h,i;h,i=ui_mouse_position()m=l;l=client_key_state(0x01)==true;q=p;p={}s=r;r=false;n,o=client_screen_size()end;if g and m~=nil then if(not m or s)and l and j>u and k>v and j<u+E and k<v+F then r=true;u,v=u+h-j,v+i-k;if not H then u=math_max(0,math_min(n-E,u))v=math_max(0,math_min(o-F,v))end end end;if g and m~=nil then if j>u and k>v and j<u+E and k<v+F then if l then t="c"else t="o"end end end;table_insert(p,{u,v,E,F})return u,v,t,E,F end;function e.status(u,v,E,F,G,H,I)if globals_framecount()~=f then g=ui_is_menu_open()j,k=h,i;h,i=ui_mouse_position()m=l;l=true;q=p;p={}s=r;r=false;n,o=client_screen_size()end;if g and m~=nil then if j>u and k>v and j<u+E and k<v+F then return true end end;return false end;return e end)().new(b,c,d)end
local lerp=function(start, vend, time) return start + (vend - start) * time end
local g_text=function(b,c,d)local e=''local f=#d-1;local g=(c[1]-b[1])/f;local h=(c[2]-b[2])/f;local i=(c[3]-b[3])/f;local j=(c[4]-b[4])/f;for k=1,f+1 do e=e..('\a%02x%02x%02x%02x%s'):format(b[1],b[2],b[3],b[4],d:sub(k,k))b[1]=b[1]+g;b[2]=b[2]+h;b[3]=b[3]+i;b[4]=b[4]+j end;return e end

local outline_text = function(x, y, r, g, b, a, flags, text)
    renderer_text(x + 1,y - 1,12,12,12,a*0.7,flags,0,text)
    renderer_text(x + 1,y + 1,12,12,12,a*0.7,flags,0,text)
    renderer_text(x - 1,y + 1,12,12,12,a*0.7,flags,0,text)
    renderer_text(x - 1,y - 1,12,12,12,a*0.7,flags,0,text)
    renderer_text(x,y,r,g,b,a,flags,0,text)
end

local outline = function(x, y, w, h, t, r, g, b, a)
    renderer.rectangle(x, y, w, t, r, g, b, a)
    renderer.rectangle(x, y, t, h, r, g, b, a)
    renderer.rectangle(x, y+h-t, w, t, r, g, b, a)
    renderer.rectangle(x+w-t, y, t, h, r, g, b, a)
end


local index = {
    weapons = { "Global", "Taser", "Revolver", "Pistol", "Auto", "Scout", "AWP", "Rifle", "SMG", "Shotgun", "Deagle" },
    menu_index = { "In-Built Weapon", "Global", "Taser", "Revolver", "Pistol", "Auto", "Scout", "AWP", "Rifle", "SMG", "Shotgun", "Deagle" },
    index_wpn = { [1] = 11, [2] = 4,[3] = 4,[4] = 4,[7] = 8,[8] = 8,[9] = 7,[10] = 8,[11] = 5,[13] = 8,[14] = 8,[16] = 8,[17] = 9,[19] = 9,[23] = 9,[24] = 9,[25] = 10,[26] = 9,[27] = 10,[28] = 8,[29] = 10,[30] = 4,[31] = 2,  [32] = 4,[33] = 9,[34] = 9,[35] = 10,[36] = 4,[38] = 5,[39] = 8,[40] = 6,[60] = 8,[61] = 4,[63] = 4,[64] = 3, [0] = 1},
    index_dmg = { [0] = "Auto", [101] = "HP + 1", [102] = "HP + 2", [103] = "HP + 3", [104] = "HP + 4", [105] = "HP + 5", [106] = "HP + 6", [107] = "HP + 7", [108] = "HP + 8", [109] = "HP + 9", [110] = "HP + 10", [111] = "HP + 11", [112] = "HP + 12", [113] = "HP + 13", [114] = "HP + 14", [115] = "HP + 15", [116] = "HP + 16", [117] = "HP + 17", [118] = "HP + 18", [119] = "HP + 19", [120] = "HP + 20", [121] = "HP + 21", [122] = "HP + 22", [123] = "HP + 23", [124] = "HP + 24", [125] = "HP + 25", [126] = "HP + 26" },
    quickstop = {"Early", "Slow motion", "Duck", "Fake duck", "Move between shots", "Ignore molotov", "Taser", "Jump Scout"},
    preferbaim = {"Low inaccuracy", "Target shot fired", "Target resolved", "Safe point headshot"},
    hitgroup = { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" },
    backtrack = {"Low", "Medium", "High", "Maximum"}
}

local prefix = function(tab, type)
    local color = "\aB0BDFFFF"
    if type == nil then
        return color..index.weapons[tab]..": \affffffff"
    end
    if tab == nil then
        return  color..type..": \affffffff"
    end
    if type == "Hide" then
        return  "\n"..index.weapons[tab].."\n\aB0BDFFFF"..type..": \affffffff"
    end

    return color..type..": \affffffff\n"..index.weapons[tab]
end

local suffix = function(tab)
    return "\n"..index.weapons[tab]
end

local lib = {

    get_weapon = function()
        local me = entity.get_local_player()
        local weapon = entity_get_player_weapon(me)
        local weapon_id = (entity_get_prop(weapon, "m_iItemDefinitionIndex"))
        local index = index.index_wpn[weapon_id]
        if index == nil then return 1 end
        return index
    end,

    tbl_to_string = function(table)
        local string = ""
        if #table == 0 then return "-" end
        for i = 1, #table do
            string = string..(i <= 4 and table[i] or "")..((i ~= #table and i <= 4) and ", " or "")
        end
        return string
    end,

    get_hitbox = function(table)
        if #table > 0 then
            for i=1, #table do
                if table[i] == "Head" and #table == 1 then
                    return "HEAD"
                end

                if table[i] == "Head" and #table > 1 then
                    return ""
                end
            end
        end
        return "BAIM"
    end,

    is_key_down = function(element)
        return (ui_get(element))
    end,

    is_in_air = function()
        return (bit.band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 0)
    end,

    is_double_tapping = function()
        local doubletap = {ui_reference("RAGE", TAB[5], "Double Tap")}
        return (ui_get(doubletap[2]) and ui_get(doubletap[1]))
    end,

    is_scoped = function()
        local is_scoped = entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_zoomLevel" )
        if is_scoped == nil then is_scoped = 0 end
        return is_scoped >= 1
    end,

    contains = function(table, val)
        if #table > 0 then
            for i=1, #table do
                if table[i] == val then
                    return true
                end
            end
        end
        return false
    end,

    enemy_visible = function()
        for i=0, 8 do
            local idx = client.current_threat()
            if idx == nil then return false end
            local cx, cy, cz = entity_hitbox_position(idx, i)
            if client_visible(cx, cy, cz) then
                return true
            end
        end
        return false
    end,

    replace = function(select, target)
        ui_set(select, target)
    end,

    fill_table = function(tbl, target)
        if #ui_get(tbl) == 0 then
            ui_set(tbl, target)
        end
    end,

    config_export = function()
        local settings = {}
        local clipboard = require("gamesense/clipboard")
        local base64 = require("gamesense/base64")

        for key, value in pairs(index.weapons) do
            settings[tostring(value)] = {}
            for k, v in pairs(configs[key]) do
                settings[value][k] = ui_get(v)
            end
        end

        clipboard.set((base64.encode(json.stringify(settings))))
        notify:paint(4, "[Config] Exported from clipborad!")
    end,

    config_import = function()
        local clipboard = require("gamesense/clipboard")
        local base64 = require("gamesense/base64")

        if clipboard.get() == nil then 
            notify:paint(4, "Importation failure")
        return end

        local settings = json.parse(base64.decode(clipboard.get()))

        for key, value in pairs(index.weapons) do
            for k, v in pairs(configs[key]) do
                local current = settings[value][k]
                if (current ~= nil) then
                    ui_set(v, current)
                end
            end
        end

        notify:paint(4, "[Config] Imported from clipborad!")
    end,

    config_download = function()
        local http = require "gamesense/http"
        local base64 = require("gamesense/base64")

        http.get("https://raw.githubusercontent.com/MLCluanchar/config/main/config.txt", function(success, response)

            if not success or response.status ~= 200 then
                notify:paint(4, "[Config] Connection Failure")
            end

            local settings = json.parse(base64.decode(response.body))

            for key, value in pairs(index.weapons) do
                for k, v in pairs(configs[key]) do
                    print(configs[key])
                    local current = settings[value][k]
                    if (current ~= nil) then
                        ui_set(v, current)
                    end
                end
            end

            notify:paint(4, "[Config] Downloaded Config from Server!")
        end)
    end

}

--------------------------------------------------------------------------------
-- Menu References
--------------------------------------------------------------------------------
local references = {
    target_selection = ui_reference(TAB[1], TAB[2], "Target selection"),
    target_hitbox = ui_reference(TAB[1], TAB[2], "Target hitbox"),
    multipoint = ui_reference(TAB[1], TAB[2], "Multi-point"),
    multipoint_scale = ui_reference(TAB[1], TAB[2], "Multi-point scale"),
    prefer_safe_point = ui_reference(TAB[1], TAB[2], "Prefer safe point"),
    force_safepoint = ui_reference(TAB[1], TAB[2], "Force safe point"),
    unsafe = ui_reference(TAB[1], TAB[2], "Avoid unsafe hitboxes"),
    automatic_fire = ui_reference(TAB[1], TAB[5], "Automatic fire"),
    automatic_penetration = ui_reference(TAB[1], TAB[5], "Automatic penetration"),
    silent_aim = ui_reference(TAB[1], TAB[5], "Silent aim"),
    hitchance = ui_reference(TAB[1], TAB[2], "Minimum hit chance"),
    mindamage = ui_reference(TAB[1], TAB[2], "Minimum damage"),
    automatic_scope = ui_reference(TAB[1], TAB[2], "Automatic scope"),
    reduce_aimstep = ui_reference(TAB[1], TAB[5], "Reduce aim step"),
    log_spread = ui_reference(TAB[1], TAB[5], "Log misses due to spread"),
    low_fps_mitigations = ui_reference(TAB[1], TAB[5], "Low FPS mitigations"),
    Maximum_FOV = ui_reference(TAB[1], TAB[5], 'Maximum FOV'),
    ----------------------------------------------------------------------------
    accuracy_boost = ui_reference(TAB[1], TAB[5], "Accuracy boost"),
    quickstop = ui_reference(TAB[1], TAB[2], "Quick stop"),
    quickstop_option = {ui_reference(TAB[1], TAB[2], "Quick stop")},
    delay_shot = ui_reference(TAB[1], TAB[5], "Delay shot"),
    prefer_bodyaim = ui_reference(TAB[1], TAB[2], "Prefer body aim"),
    prefer_bodyaim_disabler = ui_reference(TAB[1], TAB[2], "Prefer body aim disablers"),
    force_body_aim_on_peek = ui_reference(TAB[1], TAB[2], "Force body aim on peek"),
    ----------------------------------------------------------------------------
    ping_spike = {ui_reference("MISC", "miscellaneous", "ping spike")},
    ----------------------------------------------------------------------------
    menu_color = ui_reference("MISC", "Settings", "Menu color"),
}
--------------------------------------------------------------------------------
-- Initialize UI Elements
--------------------------------------------------------------------------------
local inti = {

    main = function()

        main = {

            --------------------------------------------------------------------------------
            -- Inserting None-Override adaptive utiles
            --------------------------------------------------------------------------------    

            other_label = ui_new_label(TAB[3], TAB[5], "\n"),
            other_mod = ui_new_label(TAB[3], TAB[5], prefix(nil, "         Others \aFFFFFFFFModifiers")),

            quick_peek_assist = ui_new_checkbox(TAB[3], TAB[5], prefix(nil, "Others").."Quick Peek Assist", false),
            quick_peek_assist_hotkey = ui_new_hotkey(TAB[3], TAB[5], "\n quick peek key", true),
            quick_peek_assist_mode = ui_new_multiselect(TAB[3], TAB[5], prefix(nil, "Quick Peek").."Assist Mode", 
            {"Retreat on shot", "Retreat on key release"}),
            quick_peek_assist_distance = ui_new_slider(TAB[3], TAB[5], prefix(nil, "Quick Peek").."Assist Distance", 16, 201, 201, true, "m", 1),

            antiaim_correction = ui_new_checkbox(TAB[3], TAB[5], prefix(nil, "Others").."Anti-Aim Correction", false),
            antiaim_correction_override = ui_new_hotkey(TAB[3], TAB[5], prefix(nil, "Correction").."Override hotkey", false),
             
            doubletap = ui_new_checkbox(TAB[3], TAB[5], prefix(nil, "Others").."\aB6B665FFDouble Tap", false),
            doubletap_key = ui_new_hotkey(TAB[3], TAB[5], prefix(nil, "Double Tap").."Key", true),
            double_tap_mode = ui_new_combobox(TAB[3], TAB[5], prefix(nil, "Double Tap").."Mode", 
            {"Offensive", "Defensive"}),
            double_tap_hitchance = ui_new_slider(TAB[3], TAB[5], prefix(nil, "Double Tap").."Hitchance", 0, 100, 0, true, "%", 1),
            double_tap_fake_lag_limit = ui_new_slider(TAB[3], TAB[5], prefix(nil, "Double Tap").."Fake Lag Limit", 1, 10, 1, true, "", 1),

            hotkey_label = ui_new_label(TAB[3], TAB[5], "\n"),
            hotkey_mod = ui_new_label(TAB[3], TAB[5], prefix(nil, "         Hotkey \aFFFFFFFFModifiers")),

            force_body_aim = ui_new_hotkey(TAB[3], TAB[5], prefix(nil, "Hotkey").."Force Body Aim", false),
            duck_peek_assist = ui_new_hotkey(TAB[3], TAB[5], prefix(nil, "Hotkey").."Duck peek assist", false),
            force_safepoint = ui_new_hotkey(TAB[3], TAB[5], prefix(nil, "Hotkey").."Force Safe Point", false),
            --------------------------------------------------------------------------------
            -- Main functions
            --------------------------------------------------------------------------------

            main_label = ui_new_label(TAB[3], TAB[5], "\n"),
            main_mod = ui_new_label(TAB[3], TAB[5], prefix(nil, "         Weapons \aFFFFFFFFModifiers")),

            -- enable = ui_new_checkbox(TAB[3], TAB[4], "Enable", false),
            tab = ui_new_combobox(TAB[3], TAB[5], prefix(nil, "General").."Weapon Selection", index.menu_index),
            current = ui_new_label(TAB[3], TAB[5], prefix(nil, "Current Config:")..""),

        }
    end,


    --------------------------------------------------------------------------------
    -- Initialize Weapon Config
    --------------------------------------------------------------------------------

    config_1 = function()

        labels.current_labels = ui_new_label(TAB[3], TAB[4], "\n")
        labels.hitbox_mod = ui_new_label(TAB[3], TAB[4], prefix(nil, "         Hitscan \aFFFFFFFFModifiers"))

        for i=1, #index.weapons do

            if not configs[i] then
                configs[i] = {}
            end


            configs[i].target_selection = ui_new_combobox(TAB[3], TAB[4], prefix(nil, "Targets").."Selection"..suffix(i), {
                "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Best hit chance"
            })
            configs[i].target_hitbox = ui_new_multiselect(TAB[3], TAB[4], prefix(nil, "Targets").."Hitboxes"..suffix(i), index.hitgroup)

            configs[i].enable_hitbox = ui_new_checkbox(TAB[3], TAB[4], prefix(nil, "Override").."Hitbox Override"..suffix(i))
            configs[i].custom_hitbox = ui_new_multiselect(TAB[3], TAB[4], prefix(i, "Hide").."\nHitbox Option", { "On-key", "On-key 2", "In-Air", "Double tap", "Force Body Aim"})

        end

        --------------------------------------------------------------------------------
        -- Inserting Keybinds : Hitbox
        --------------------------------------------------------------------------------

        for i=1, #index.weapons do

            if not configs[i] then
                configs[i] = {}
            end
            configs[i].hitbox_ovr = ui_new_multiselect(TAB[3], TAB[4],  prefix(nil, "On-Key #1") .."Hitbox"..suffix(i), index.hitgroup)   
        end

        keybinds.hitbox_key = ui_new_hotkey(TAB[3], TAB[4], prefix(nil, "Key #1").."Hitbox Override", true)

        for i=1, #index.weapons do

            if not configs[i] then
                configs[i] = {}
            end
            configs[i].hitbox_ovr2 = ui_new_multiselect(TAB[3], TAB[4],  prefix(nil, "On-Key #2") .."Hitbox"..suffix(i), index.hitgroup)
        end

        keybinds.hitbox_key2 = ui_new_hotkey(TAB[3], TAB[4], prefix(nil, "Key #2").."Hitbox Override", true)

        --------------------------------------------------------------------------------

        for i=1, #index.weapons do

            if not configs[i] then
                configs[i] = {}
            end

            --------------------------------------------------------------------------------
            -- Inserting In Air / Double tap hitbox
            --------------------------------------------------------------------------------

            configs[i].hitbox_air = ui_new_multiselect(TAB[3], TAB[4], prefix(nil, "In Air").."Hitbox"..suffix(i), index.hitgroup)
            configs[i].hitbox_dt = ui_new_multiselect(TAB[3], TAB[4],  prefix(nil, "DT").."Hitbox"..suffix(i), index.hitgroup)

            configs[i].multipoint = ui_new_multiselect(TAB[3], TAB[4], prefix(nil, "Targets").."Multi-point"..suffix(i), index.hitgroup)
            configs[i].multipoint_scale = ui_new_slider(TAB[3], TAB[4], prefix(i).."Multi-point scale", 24, 100, 60, true, "%", 1, { [24] = "Auto" })

            configs[i].enable_multipoint = ui_new_checkbox(TAB[3], TAB[4], prefix(nil, "Override") .."Multi-point Override"..suffix(i))
            configs[i].custom_multipoint = ui_new_multiselect(TAB[3], TAB[4], prefix(i, "Hide").."\nMultipoint Option", { "On-key", "On-key 2", "Damage Override", "In-Air", "Double tap"})
        end

        --------------------------------------------------------------------------------
        -- Inserting Keybinds : Multi-point
        --------------------------------------------------------------------------------

        for i=1, #index.weapons do
            if not configs[i] then
                configs[i] = {}
            end
            configs[i].multipoint_ovr = ui_new_slider(TAB[3], TAB[4],  prefix(nil, "On-Key #1").."Multi-point scale"..suffix(i), 24, 100, 50, true, "%", 1, { [24] = "Auto" }) 
        end

        keybinds.multipoint_key = ui_new_hotkey(TAB[3], TAB[4], prefix(nil, "On-Key #2").."Multi-point Override", true)


        for i=1, #index.weapons do
            if not configs[i] then
                configs[i] = {}
            end
            configs[i].multipoint_ovr2 = ui_new_slider(TAB[3], TAB[4],  prefix(nil, "On-Key #2") .."Multi-point scale"..suffix(i), 24, 100, 50, true, "%", 1, { [24] = "Auto" })    
        end

        keybinds.multipoint_key2 = ui_new_hotkey(TAB[3], TAB[4], "Multi-point Override [On Key 2]", true)

        --------------------------------------------------------------------------------

        for i=1, #index.weapons do

            if not configs[i] then
                configs[i] = {}
            end

            configs[i].multipoint_ovr3 = ui_new_slider(TAB[3], TAB[4],  prefix(nil, "Damage") .."Multi-point scale"..suffix(i), 24, 100, 50, true, "%", 1, { [24] = "Auto" })
            configs[i].multipoint_air = ui_new_slider(TAB[3], TAB[4],  prefix(nil, "In Air") .."Multi-point scale"..suffix(i), 24, 100, 50, true, "%", 1, { [24] = "Auto" })
            configs[i].multipoint_dt = ui_new_slider(TAB[3], TAB[4],  prefix(nil, "DT") .."Multi-point scale"..suffix(i), 24, 100, 50, true, "%", 1, { [24] = "Auto" })

        end   

        labels.hide_label_dm = ui_new_label(TAB[3], TAB[4], "\n")
        labels.dm_mod = ui_new_label(TAB[3], TAB[4], prefix(nil, "         Accuracy \aFFFFFFFFModifiers"))

        for i=1, #index.weapons do

            if not configs[i] then
                configs[i] = {}
            end

            --------------------------------------------------------------------------------
            -- Inserting Accuracy Modifiers
            --------------------------------------------------------------------------------

            configs[i].hitchance = ui_new_slider(TAB[3], TAB[4], prefix(nil, "Accuracy").."Hitchance"..suffix(i), 0, 100, 50, true, "%", 1, {"Off"})
            configs[i].enable_hitchance = ui_new_checkbox(TAB[3], TAB[4],  prefix(nil, "Override") .."Hitchance Override"..suffix(i))
            configs[i].custom_hitchance = ui_new_multiselect(TAB[3], TAB[4], prefix(i, "Hide").."\nHitchance Option", {"On-key", "On-key 2", "In-Air", "Double tap", "No Scope"})
        end

        --------------------------------------------------------------------------------
        -- Inserting Keybinds : Hitchance
        --------------------------------------------------------------------------------

        for i=1, #index.weapons do
            if not configs[i] then
                configs[i] = {}
            end
            configs[i].hitchance_ovr = ui_new_slider(TAB[3], TAB[4],  prefix(nil, "On-Key #1").."Hitchance"..suffix(i), 0, 100, 50, true, "%", 1, {"Off"}) 
        end

        keybinds.hitchance_key = ui_new_hotkey(TAB[3], TAB[4], "Hitchance Override [On-key]", true)


        for i=1, #index.weapons do
            if not configs[i] then
                configs[i] = {}
            end
            configs[i].hitchance_ovr2 = ui_new_slider(TAB[3], TAB[4],  prefix(nil, "On-Key #2") .."Hitchance"..suffix(i), 0, 100, 50, true, "%", 1, {"Off"})    
        end

        keybinds.hitchance_key2 = ui_new_hotkey(TAB[3], TAB[4], "Hitchance Override [On-key 2]", true)

        --------------------------------------------------------------------------------

        for i=1, #index.weapons do

            if not configs[i] then
                configs[i] = {}
            end

            --------------------------------------------------------------------------------
            -- Inserting In Air / No Scoped / Double tap hitchance
            --------------------------------------------------------------------------------

            configs[i].hitchance_air = ui_new_slider(TAB[3], TAB[4],  prefix(nil, "In Air") .."Hitchance"..suffix(i), 0, 100, 50, true, "%", 1, {"Off"})   
            configs[i].hitchance_dt = ui_new_slider(TAB[3], TAB[4],  prefix(nil, "DT") .."Hitchance"..suffix(i), 0, 100, 50, true, "%", 1, {"Off"})     
            configs[i].hitchance_ns = ui_new_slider(TAB[3], TAB[4],  prefix(nil, "No Scope") .."Hitchance"..suffix(i), 0, 100, 50, true, "%", 1, {"Off"})


            configs[i].min_damage = ui_new_slider(TAB[3], TAB[4], prefix(nil, "Accuracy").."Damage"..suffix(i), 0, 126, 20, true, nil, 1, index.index_dmg)
            configs[i].enable_damage = ui_new_checkbox(TAB[3], TAB[4],  prefix(nil, "Override") .."Damage Override"..suffix(i))
            configs[i].custom_damage = ui_new_multiselect(TAB[3], TAB[4], prefix(i, "Hide") .."\nDamage Option", {"On-key", "On-key 2", "Visible", "In-Air", "No Scope", "Double tap"})

        end

        --------------------------------------------------------------------------------
        -- Inserting Keybinds : Damage
        --------------------------------------------------------------------------------


        for i=1, #index.weapons do
            if not configs[i] then
                configs[i] = {}
            end
            configs[i].ovr_min_damage = ui_new_slider(TAB[3], TAB[4],  prefix(nil, "On-Key #1").."Damage"..suffix(i), 0, 126, 20, true, nil, 1, index.index_dmg)
        end

        keybinds.damage_key = ui_new_hotkey(TAB[3], TAB[4], "Damage Override [On-key]", true)

        for i=1, #index.weapons do
            if not configs[i] then
                configs[i] = {}
            end
            configs[i].ovr_min_damage2 = ui_new_slider(TAB[3], TAB[4],  prefix(nil, "On-Key #2").."Damage"..suffix(i), 0, 126, 1, true, nil, 1, index.index_dmg)
        end

        keybinds.damage_key2 = ui_new_hotkey(TAB[3], TAB[4], "Damage Override [On-key 2]", true)

        --------------------------------------------------------------------------------

        for i=1, #index.weapons do

            if not configs[i] then
                configs[i] = {}
            end

            --------------------------------------------------------------------------------
            -- Inserting Visible / In Air / Double tap Min damage
            --------------------------------------------------------------------------------

            configs[i].vis_min_damage = ui_new_slider(TAB[3], TAB[4], prefix(nil, "Visible") .."Damage"..suffix(i), 0, 126, 20, true, nil, 1, index.index_dmg)
            configs[i].nc_min_damage = ui_new_slider(TAB[3], TAB[4], prefix(nil, "No Scope") .. "Damage"..suffix(i), 0, 126, 20, true, nil, 1 , index.index_dmg)
            configs[i].air_min_damage = ui_new_slider(TAB[3], TAB[4], prefix(nil, "In Air") .."Damage"..suffix(i), 0, 126, 20, true, nil, 1, index.index_dmg)
            configs[i].dt_min_damage = ui_new_slider(TAB[3], TAB[4], prefix(nil, "DT") .."Damage"..suffix(i), 0, 126, 20, true, nil, 1, index.index_dmg)


        end


        labels.hide_label_ut = ui_new_label(TAB[3], TAB[4], "\n")
        labels.utiles_mod = ui_new_label(TAB[3], TAB[4], prefix(nil, "         Utiles \aFFFFFFFFModifiers"))

        for i = 1, #index.weapons do
            
            if not configs[i] then
                configs[i] = {}
            end

            --------------------------------------------------------------------------------
            -- Inserting None-Override utils
            --------------------------------------------------------------------------------

            configs[i].prefer_safe_point = ui_new_checkbox(TAB[3], TAB[4], prefix(i).."Prefer safe point")
            configs[i].unsafe = ui_new_multiselect(TAB[3], TAB[4], prefix(i).."Avoid unsafe hitboxes", index.hitgroup)
            configs[i].automatic_fire = ui_new_checkbox(TAB[3], TAB[4], prefix(i).."Automatic fire")
            configs[i].automatic_penetration = ui_new_checkbox(TAB[3], TAB[4], prefix(i).."Automatic penetration")
            configs[i].automatic_scope = ui_new_checkbox(TAB[3], TAB[4], prefix(i).."Automatic scope")
            configs[i].silent_aim = ui_new_checkbox(TAB[3], TAB[4], prefix(i).."Silent aim")
        end

    end,

    --------------------------------------------------------------------------------
    -- Initializing Misc Options
    --------------------------------------------------------------------------------

    config_2 = function()

        labels.hide_label_misc = ui_new_label(TAB[3], TAB[5], "\n")
        labels.misc_mod = ui_new_label(TAB[3], TAB[5], prefix(nil, "           Misc \aFFFFFFFFModifiers"))
        
        for i=1, #index.weapons do

            if not configs[i] then
                configs[i] = {}
            end

            configs[i].accuracy = ui_new_combobox(TAB[3], TAB[5], prefix(i).."Accuracy Boost", index.backtrack)
            configs[i].delayshot = ui_new_checkbox(TAB[3], TAB[5],  prefix(i).."Delay shot")

            configs[i].quickstop = ui_new_checkbox(TAB[3], TAB[5], prefix(i).."Quick stop")
            configs[i].quickstop_mode = ui_new_multiselect(TAB[3], TAB[5], prefix(i, "Hide").."\nQuick stop options", index.quickstop)

            configs[i].preferbaim = ui_new_checkbox(TAB[3], TAB[5], prefix(i).."Prefer Body Aim")
            configs[i].prefer_bodyaim_disabler = ui_new_multiselect(TAB[3], TAB[5], prefix(i, "Hide").."\n", index.preferbaim)

            configs[i].ping_spike = ui_new_checkbox(TAB[3], TAB[5], prefix(i).."Ping spike")
            configs[i].ping_spike_bar = ui_new_slider(TAB[3], TAB[5], prefix(i, "Hide").."\nPing Spike [Bar]", 1, 200, 0, true, "ms")
        end

        labels.hide_label_config = ui_new_label(TAB[3], TAB[5], "\n")
        labels.config_mod = ui_new_label(TAB[3], TAB[5], prefix(nil, "         Config \aFFFFFFFFModifiers"))

        keybinds.deafult = ui_new_button(TAB[3], TAB[5], prefix(nil, "Config").."Download Preset", lib.config_download)
        keybinds.import = ui_new_button(TAB[3], TAB[5], prefix(nil, "Config").."Import", lib.config_import)
        keybinds.export = ui_new_button(TAB[3], TAB[5], prefix(nil, "Config").."Export", lib.config_export)

    end,

    configs_3 = function()
        indicator.hide_label_indicator = ui_new_label(TAB[3], TAB[5], "\n")
        indicator.config_ind = ui_new_label(TAB[3], TAB[5], prefix(nil, "         Index \aFFFFFFFFModifiers"))

        indicator.crosshair = ui_new_checkbox(TAB[3], TAB[5], prefix(nil, "Index").. "Cross Hair Indicators")
        indicator.corsshair_clr = ui_new_color_picker(TAB[3], TAB[5], prefix(nil, "Hide").."\nCrosshair Color", 255, 255, 255, 255)
        indicator.crosshair_tbl = ui_new_multiselect(TAB[3], TAB[5], "\n Crosshair table", {
            "Damage", "Hitchance", "Multipoint", "Hitbox state"
        })

        indicator.feature = ui_new_checkbox(TAB[3], TAB[5], prefix(nil, "Index").. "Feature Indicators")
        indicator.feature_clr_1 = ui_new_color_picker(TAB[3], TAB[5], prefix(nil, "Hide").."\nFeature Color #1", 200, 200, 200, 255)
        indicator.feature_clr_2 = ui_new_color_picker(TAB[3], TAB[5], prefix(nil, "Hide").."\nFeature Color #2", 200, 200, 200, 255)
        indicator.feature_tbl = ui_new_multiselect(TAB[3], TAB[5], "\n Feature table", {
            "Min Damage States", "Hitchance States", "Hitbox States"
        })

        indicator.debugger = ui_new_checkbox(TAB[3], TAB[5], prefix(nil, "Index").. "Debug Indicators")
        indicator.debugger_type = ui_new_combobox(TAB[3], TAB[5], "\nDebugger Type", {
            "Menu position", "Customize"
        })
    end,

}

--------------------------------------------------------------------------------
-- Set Ui Element Visible
--------------------------------------------------------------------------------

local visible = {

    original_menu = function(state)
        ui_set_visible(ragebot.target_selection, state)
        ui_set_visible(ragebot.target_hitbox, state)
        ui_set_visible(ragebot.multipoint[1], state)
        ui_set_visible(ragebot.multipoint_scale, state)
        ui_set_visible(ragebot.prefer_safepoint, state)
        ui_set_visible(ragebot.force_safepoint, state)
        ui_set_visible(ragebot.avoid_unsafe_hitboxes, state)
        ui_set_visible(ragebot.automatic_fire, state)
        ui_set_visible(ragebot.automatic_penetration, state)
        ui_set_visible(ragebot.silent_aim, state)
        ui_set_visible(ragebot.hitchance, state)
        ui_set_visible(ragebot.remove_recoil, state)
        ui_set_visible(ragebot.accuracy_boost, state)
        ui_set_visible(ragebot.minimum_damage, state)
        ui_set_visible(ragebot.auto_scope, state)
        ui_set_visible(ragebot.automatic_penetration, state)
        ui_set_visible(ragebot.reduce_aim_step, state)
        ui_set_visible(ragebot.maximum_fov, state)
        ui_set_visible(ragebot.quick_stop[1], state)
        ui_set_visible(ragebot.quick_stop[2], state)
        ui_set_visible(ragebot.quick_stop[3], state)
        ui_set_visible(ragebot.delay_shot, state)
        ui_set_visible(ragebot.double_tap_quick_stop, state)
        ui_set_visible(ragebot.prefer_body_aim, state)
        ui_set_visible(ragebot.prefer_body_aim_disablers, state)
        ui_set_visible(ragebot.log_misses_due_to_spread, state)
        ui_set_visible(ragebot.low_fps_mitigations, state)
        ui_set_visible(ragebot.quick_peek_assist[1], state)
        ui_set_visible(ragebot.quick_peek_assist[2], state)
        ui_set_visible(ragebot.quick_peek_assist_distance, state)
        ui_set_visible(ragebot.quick_peek_assist_mode[1], state)
        ui_set_visible(ragebot.resolver, state)
        ui_set_visible(ragebot.double_tap[1], state)
        ui_set_visible(ragebot.double_tap[2], state)
        ui_set_visible(ragebot.double_tap_fake_lag_limit, state)
        ui_set_visible(ragebot.double_tap_hitchance, state)
        --ui_set_visible(ragebot.double_tap_mode, state)
        ui_set_visible(ragebot.force_body_aim_on_peek, state)
    end,

    weapon = function()
        lib.fill_table(main.quick_peek_assist_mode, "Retreat on shot")
        for i=1, #index.weapons do
            
            -->> Fixing Hitboxes
            lib.fill_table(configs[i].target_hitbox, "Head")
            lib.fill_table(configs[i].hitbox_ovr, "Head")
            lib.fill_table(configs[i].hitbox_ovr2, "Head")
            lib.fill_table(configs[i].hitbox_air, "Head")
            lib.fill_table(configs[i].hitbox_dt, "Head")

            --------------------------------------------------------------------------------
            -- Set Visible: Rage
            --------------------------------------------------------------------------------

            local aimbot = true
            local weapon_hand = ui_get(main.tab) == "In-Built Weapon"
            local current = (index.weapons[i] == (weapon_hand and index.weapons[lib.get_weapon()] or ui_get(main.tab)))
            local tab_1 = current and aimbot

            if weapon_hand then
                ui_set(main.current, "\aB0BDFFFF        Current Config: ".."\aFFFFFFFF"..index.weapons[lib.get_weapon()])
            end
            ui_set_visible(main.current, weapon_hand)

            --if weapon_hand then i = lib.get_weapon() end
            
            if index.weapons[i] == ui_get(main.tab) then tab = i 
            elseif weapon_hand then tab = lib.get_weapon() end
            ui_set_visible(configs[i].multipoint, tab_1)
            ui_set_visible(configs[i].prefer_safe_point, tab_1)
            ui_set_visible(configs[i].unsafe, tab_1)
            ui_set_visible(configs[i].automatic_fire, tab_1)
            ui_set_visible(configs[i].automatic_penetration, tab_1)
            ui_set_visible(configs[i].automatic_scope, tab_1)
            ui_set_visible(configs[i].silent_aim, tab_1)

            -->> Default utils
            ui_set_visible(configs[i].target_selection, tab_1)
            ui_set_visible(configs[i].target_hitbox, tab_1)
            ui_set_visible(configs[i].multipoint_scale, tab_1)
            ui_set_visible(configs[i].hitchance, tab_1)
            ui_set_visible(configs[i].min_damage, tab_1)

            -->> Custom Hitbox
            local ht_enable = ui_get(configs[i].enable_hitbox)
            local ht_ovr = lib.contains(ui_get(configs[i].custom_hitbox), "On-key") and current and ht_enable and aimbot
            local ht_ovr2 = lib.contains(ui_get(configs[i].custom_hitbox), "On-key 2") and current and ht_enable and aimbot
            local ht_air = lib.contains(ui_get(configs[i].custom_hitbox), "In-Air") and current and ht_enable and aimbot
            local ht_dt = lib.contains(ui_get(configs[i].custom_hitbox), "Double tap") and current and ht_enable and aimbot

            ui_set_visible(configs[i].enable_hitbox, tab_1)
            ui_set_visible(configs[i].custom_hitbox, tab_1 and ht_enable)

            ui_set_visible(configs[i].hitbox_ovr, ht_ovr)
            ui_set_visible(keybinds.hitbox_key, ht_ovr)

            ui_set_visible(configs[i].hitbox_ovr2, ht_ovr2)
            ui_set_visible(keybinds.hitbox_key2, ht_ovr2)

            ui_set_visible(configs[i].hitbox_air, ht_air)
            ui_set_visible(configs[i].hitbox_dt, ht_dt)

            -->> Custom Multipoint
            local mp_enable = ui_get(configs[i].enable_multipoint)
            local mp_ovr = lib.contains(ui_get(configs[i].custom_multipoint), "On-key") and current and mp_enable and aimbot
            local mp_ovr2 = lib.contains(ui_get(configs[i].custom_multipoint), "On-key 2") and current and mp_enable and aimbot
            local mp_ovr3 = lib.contains(ui_get(configs[i].custom_multipoint), "Damage Override") and current and mp_enable and aimbot
            local mp_air = lib.contains(ui_get(configs[i].custom_multipoint), "In-Air") and current and mp_enable and aimbot
            local mp_dt = lib.contains(ui_get(configs[i].custom_multipoint), "Double tap") and current and mp_enable and aimbot

            ui_set_visible(configs[i].enable_multipoint, tab_1)
            ui_set_visible(configs[i].custom_multipoint, tab_1 and mp_enable)

            ui_set_visible(configs[i].multipoint_ovr, mp_ovr)
            ui_set_visible(configs[i].multipoint_ovr2, mp_ovr2)
            ui_set_visible(configs[i].multipoint_ovr3, mp_ovr3)
            ui_set_visible(configs[i].multipoint_air, mp_air)
            ui_set_visible(configs[i].multipoint_dt, mp_dt)

            -->> Custom Hitchance
            local hc_enable = ui_get(configs[i].enable_hitchance)
            local hc_ovr = lib.contains(ui_get(configs[i].custom_hitchance), "On-key") and current and hc_enable and aimbot
            local hc_ovr2 = lib.contains(ui_get(configs[i].custom_hitchance), "On-key 2") and current and hc_enable and aimbot
            local hc_air = lib.contains(ui_get(configs[i].custom_hitchance), "In-Air") and current and hc_enable and aimbot
            local hc_dt = lib.contains(ui_get(configs[i].custom_hitchance), "Double tap") and current and hc_enable and aimbot
            local hc_ns = lib.contains(ui_get(configs[i].custom_hitchance), "No Scope") and current and hc_enable and aimbot

            ui_set_visible(configs[i].enable_hitchance, tab_1)
            ui_set_visible(configs[i].custom_hitchance, tab_1 and hc_enable)
            ui_set_visible(configs[i].hitchance_ovr, hc_ovr)
            ui_set_visible(configs[i].hitchance_ovr2, hc_ovr2)
            ui_set_visible(configs[i].hitchance_air, hc_air)
            ui_set_visible(configs[i].hitchance_dt, hc_dt)
            ui_set_visible(configs[i].hitchance_ns, hc_ns)

            -->>Custom Damage
            local cd_enable = ui_get(configs[i].enable_damage)
            local cd_ovr = lib.contains(ui_get(configs[i].custom_damage), "On-key") and current and cd_enable and aimbot
            local cd_ovr2 = lib.contains(ui_get(configs[i].custom_damage), "On-key 2") and current and cd_enable and aimbot
            local cd_vis = lib.contains(ui_get(configs[i].custom_damage), "Visible") and current and cd_enable and aimbot
            local cd_nc = lib.contains(ui_get(configs[i].custom_damage), "No Scope") and current and cd_enable and aimbot
            local cd_air = lib.contains(ui_get(configs[i].custom_damage), "In-Air") and current and cd_enable and aimbot
            local cd_dt = lib.contains(ui_get(configs[i].custom_damage), "Double tap") and current and cd_enable and aimbot

            ui_set_visible(configs[i].enable_damage, tab_1)
            ui_set_visible(configs[i].custom_damage, tab_1 and cd_enable)
            ui_set_visible(configs[i].ovr_min_damage, cd_ovr)
            ui_set_visible(configs[i].ovr_min_damage2, cd_ovr2)
            ui_set_visible(configs[i].vis_min_damage, cd_vis)
            ui_set_visible(configs[i].nc_min_damage, cd_nc)
            ui_set_visible(configs[i].air_min_damage, cd_air)
            ui_set_visible(configs[i].dt_min_damage, cd_dt)

            --------------------------------------------------------------------------------
            -- Set Visible: Misc
            --------------------------------------------------------------------------------

            local other = true

            local tab_2 = current and other

            ui_set_visible(configs[i].accuracy, tab_2)

            ui_set_visible(configs[i].delayshot, tab_2)

            local is_quickstop = ui_get(configs[i].quickstop)
            ui_set_visible(configs[i].quickstop, tab_2)
            ui_set_visible(configs[i].quickstop_mode, tab_2 and is_quickstop)

            local is_pingspike = ui_get(configs[i].ping_spike)
            ui_set_visible(configs[i].ping_spike, tab_2)
            ui_set_visible(configs[i].ping_spike_bar, tab_2 and is_pingspike)

            local is_prefer_baim = ui_get(configs[i].preferbaim) and tab_2
            ui_set_visible(configs[i].preferbaim, tab_2)
            ui_set_visible(configs[i].prefer_bodyaim_disabler, is_prefer_baim)

            --------------------------------------------------------------------------------
            -- Set Visible: labels
            --------------------------------------------------------------------------------


            -- ui_set_visible(configs[i].hide_label_dm, tab_1)
            -- ui_set_visible(configs[i].dm_mod, tab_1)
        end
    end,
    
    labels = function()
        local tab_1 = true
        local tab_2 = true
        
        ui_set_visible(labels.current_labels, tab_1)
        ui_set_visible(labels.hitbox_mod, tab_1)

        ui_set_visible(labels.hide_label_dm, tab_1)
        ui_set_visible(labels.dm_mod, tab_1)

        ui_set_visible(labels.hide_label_ut, tab_1)
        ui_set_visible(labels.utiles_mod, tab_1)

        ui_set_visible(labels.hide_label_misc, tab_2)
        ui_set_visible(labels.misc_mod, tab_2)

        ui_set_visible(labels.hide_label_config, tab_2)
        ui_set_visible(labels.config_mod, tab_2)
    end,

    others = function()
        local quick_peek = ui_get(main.quick_peek_assist)
        ui_set_visible(main.quick_peek_assist_mode, quick_peek)
        ui_set_visible(main.quick_peek_assist_hotkey, quick_peek)
        ui_set_visible(main.quick_peek_assist_distance, quick_peek)
        
        local resolver = ui_get(main.antiaim_correction)
        ui_set_visible(main.antiaim_correction_override, resolver)


        local doubletap = ui_get(main.doubletap)
        ui_set_visible(main.double_tap_mode, doubletap)
        ui_set_visible(main.doubletap_key, doubletap)
        ui_set_visible(main.double_tap_fake_lag_limit, doubletap)
        ui_set_visible(main.double_tap_hitchance, doubletap)
    end,
    indicators = function()
        local ind_tab = true
        local crosshair = (ui_get(indicator.crosshair)) and ind_tab
        local feature = (ui_get(indicator.feature)) and ind_tab
        local debugger = (ui_get(indicator.debugger)) and ind_tab

        ui_set_visible(indicator.hide_label_indicator, ind_tab)
        ui_set_visible(indicator.config_ind, ind_tab)

        ui_set_visible(indicator.crosshair, ind_tab)
        ui_set_visible(indicator.corsshair_clr, crosshair)
        ui_set_visible(indicator.crosshair_tbl, crosshair)

        ui_set_visible(indicator.feature, ind_tab)
        ui_set_visible(indicator.feature_clr_1, feature)
        ui_set_visible(indicator.feature_clr_2, feature)
        ui_set_visible(indicator.feature_tbl, feature)

        ui_set_visible(indicator.debugger, ind_tab)
        ui_set_visible(indicator.debugger_type, debugger)
    end,

    keybinds = function()
        local aimbot = true
        local ht_enable = ui_get(configs[tab].enable_hitbox) and aimbot
        local ht_ovr = lib.contains(ui_get(configs[tab].custom_hitbox), "On-key") and ht_enable
        local ht_ovr2 = lib.contains(ui_get(configs[tab].custom_hitbox), "On-key 2") and ht_enable

        ui_set_visible(keybinds.hitbox_key, ht_ovr)
        ui_set_visible(keybinds.hitbox_key2, ht_ovr2)

        local mp_enable = ui_get(configs[tab].enable_multipoint) and aimbot
        local mp_ovr = lib.contains(ui_get(configs[tab].custom_multipoint), "On-key") and mp_enable
        local mp_ovr2 = lib.contains(ui_get(configs[tab].custom_multipoint), "On-key 2") and mp_enable

        ui_set_visible(keybinds.multipoint_key, mp_ovr)
        ui_set_visible(keybinds.multipoint_key2, mp_ovr2)

        local hc_enable = ui_get(configs[tab].enable_hitchance) and aimbot
        local hc_ovr = lib.contains(ui_get(configs[tab].custom_hitchance), "On-key") and hc_enable
        local hc_ovr2 = lib.contains(ui_get(configs[tab].custom_hitchance), "On-key 2") and hc_enable

        ui_set_visible(keybinds.hitchance_key, hc_ovr)
        ui_set_visible(keybinds.hitchance_key2, hc_ovr2)

        local cd_enable = ui_get(configs[tab].enable_damage) and aimbot
        local cd_ovr = lib.contains(ui_get(configs[tab].custom_damage), "On-key") and cd_enable
        local cd_ovr2 = lib.contains(ui_get(configs[tab].custom_damage), "On-key 2") and cd_enable

        ui_set_visible(keybinds.damage_key, cd_ovr)
        ui_set_visible(keybinds.damage_key2, cd_ovr2)

        local tab_2 = true
        ui_set_visible(keybinds.deafult, tab_2)
        ui_set_visible(keybinds.import, tab_2)
        ui_set_visible(keybinds.export, tab_2)
    end,

}

local fetch = {

    sync = function(origin, target, type)
        if type == "Hotkey" then
            ui_set(origin, (ui_get(target) and "Always on") or "On hotkey")
        else
            ui_set(origin, ui_get(target))
        end
    end,
    --------------------------------------------------------------------------------
    -- Set Override: Hitbox/Multipoint/Hitchance/Damage
    --------------------------------------------------------------------------------

    target_hitbox = function(tab)
        local hitbox = ui_get(configs[tab].enable_hitbox)
        local hitbox_ovr = lib.contains(ui_get(configs[tab].custom_hitbox), "On-key") and hitbox
        local hitbox_ovr2 = lib.contains(ui_get(configs[tab].custom_hitbox), "On-key 2") and hitbox
        local hitbox_air = lib.contains(ui_get(configs[tab].custom_hitbox), "In-Air") and hitbox
        local hitbox_dt = lib.contains(ui_get(configs[tab].custom_hitbox), "Double tap") and hitbox
        local hitbox_o = ui_get(configs[tab].target_hitbox)


        if hitbox_ovr and lib.is_key_down(keybinds.hitbox_key) then
            return ui_get(configs[tab].hitbox_ovr)
        elseif hitbox_ovr2 and lib.is_key_down(keybinds.hitbox_key2) then
            return ui_get(configs[tab].hitbox_ovr2)
        elseif hitbox_air and lib.is_in_air() then
            return ui_get(configs[tab].hitbox_air)
        elseif hitbox_dt and lib.is_double_tapping() then
            return ui_get(configs[tab].hitbox_dt)
        else
            return hitbox_o
        end
    end,

    multipoint_scale = function(tab)
        local multipoint = ui_get(configs[tab].enable_multipoint)
        local multipoint_ovr = lib.contains(ui_get(configs[tab].custom_multipoint), "On-key") and multipoint
        local multipoint_ovr2 = lib.contains(ui_get(configs[tab].custom_multipoint), "On-key 2") and multipoint
        local multipoint_ovr3 = lib.contains(ui_get(configs[tab].custom_multipoint), "Damage Override") and multipoint
        local multipoint_vis = lib.contains(ui_get(configs[tab].custom_multipoint), "Visible") and multipoint
        local multipoint_air = lib.contains(ui_get(configs[tab].custom_multipoint), "In-Air") and multipoint
        local multipoint_dt = lib.contains(ui_get(configs[tab].custom_multipoint), "Double tap") and multipoint
        local multipoint_o = ui_get(configs[tab].multipoint_scale)

        if multipoint_ovr and lib.is_key_down(keybinds.multipoint_key) then
            return ui_get(configs[tab].multipoint_ovr)
        elseif multipoint_ovr2 and lib.is_key_down(keybinds.multipoint_key2) then
            return ui_get(configs[tab].multipoint_ovr2)
        elseif multipoint_ovr3 and (lib.is_key_down(keybinds.damage_key) or lib.is_key_down(keybinds.damage_key2)) then
            return ui_get(configs[tab].multipoint_ovr3)  
        elseif multipoint_air and lib.is_in_air() then
            return ui_get(configs[tab].multipoint_air)
        elseif multipoint_dt and lib.is_double_tapping() then
            return ui_get(configs[tab].multipoint_dt)
        elseif multipoint_vis and lib.enemy_visible() then
            return ui_get(configs[tab].multipoint_vis)
        else
            return multipoint_o
        end
    end,

    hitchance = function(tab)
        local hitchance = ui_get(configs[tab].enable_hitchance)
        local hitchance_ovr = lib.contains(ui_get(configs[tab].custom_hitchance), "On-key") and hitchance
        local hitchance_ovr2 = lib.contains(ui_get(configs[tab].custom_hitchance), "On-key 2") and hitchance
        local hitchance_air = lib.contains(ui_get(configs[tab].custom_hitchance), "In-Air") and hitchance
        local hitchance_dt = lib.contains(ui_get(configs[tab].custom_hitchance), "Double tap") and hitchance
        local hitchance_ns = lib.contains(ui_get(configs[tab].custom_hitchance), "No Scope") and hitchance

        local hitchance_o = ui_get(configs[tab].hitchance)


        if hitchance_ovr and lib.is_key_down(keybinds.hitchance_key) then
            return ui_get(configs[tab].hitchance_ovr), "Ovr"
        elseif hitchance_ovr2 and lib.is_key_down(keybinds.hitchance_key2) then
            return ui_get(configs[tab].hitchance_ovr2), "Ovr2"
        elseif hitchance_air and lib.is_in_air() then
            return ui_get(configs[tab].hitchance_air), "Air"
        elseif hitchance_ns and not lib.is_scoped() then
            return ui_get(configs[tab].hitchance_ns), "N/C"
        elseif hitchance_dt and lib.is_double_tapping() then
            return ui_get(configs[tab].hitchance_dt), "DT"
        else
            return hitchance_o, "Def"
        end
    end,

    damage = function(tab)
        local damage = ui_get(configs[tab].enable_damage)
        --{"On-key", "On-key 2", "Visible", "In-Air", "No Scope", "Double tap"}
        local damage_ovr = lib.contains(ui_get(configs[tab].custom_damage), "On-key") and damage
        local damage_ovr2 = lib.contains(ui_get(configs[tab].custom_damage), "On-key 2") and damage
        local damage_air = lib.contains(ui_get(configs[tab].custom_damage), "In-Air") and damage
        local damage_nc = lib.contains(ui_get(configs[tab].custom_damage), "No Scope") and damage
        local damage_dt = lib.contains(ui_get(configs[tab].custom_damage), "Double tap") and damage
        local damage_vis = lib.contains(ui_get(configs[tab].custom_damage), "Visible") and damage
        local damage_o = ui_get(configs[tab].min_damage)

        if damage_ovr and lib.is_key_down(keybinds.damage_key) then
            return ui_get(configs[tab].ovr_min_damage), "Ovr"
        elseif damage_ovr2 and lib.is_key_down(keybinds.damage_key2) then
            return ui_get(configs[tab].ovr_min_damage2), "Ovr2"
        elseif damage_air and lib.is_in_air() then
            return ui_get(configs[tab].air_min_damage), "Air"
        elseif damage_dt and lib.is_double_tapping() then
            return ui_get(configs[tab].dt_min_damage), "DT"
        elseif damage_nc and not lib.is_scoped() then
            return ui_get(configs[tab].nc_min_damage), "N/C"
        elseif damage_vis and lib.enemy_visible() then
            return ui_get(configs[tab].vis_min_damage), "Vis"
        else
            return damage_o, "Def"
        end
    end,

    --------------------------------------------------------------------------------
    -- Set Default Override
    --------------------------------------------------------------------------------

    multipoint = function(tab)
        return ui_get(configs[tab].multipoint)
    end,

    target_selection = function(tab)
        return ui_get(configs[tab].target_selection)
    end,

    prefer_safe_point = function(tab)
        return ui_get(configs[tab].prefer_safe_point)
    end,

    unsafe = function(tab)
        return ui_get(configs[tab].unsafe)
    end,

    automatic_fire = function(tab)
        return ui_get(configs[tab].automatic_fire)
    end,

    automatic_penetration = function(tab)
        return ui_get(configs[tab].automatic_penetration)
    end,

    automatic_scope = function(tab)
        return ui_get(configs[tab].automatic_scope)
    end,

    silent_aim = function(tab)
        return ui_get(configs[tab].silent_aim)
    end,

    accuracy = function(tab)
        return ui_get(configs[tab].accuracy)
    end,

    delay_shot = function(tab)
        return ui_get(configs[tab].delayshot)
    end,

    quickstop = function(tab)
        return ui_get(configs[tab].quickstop)
    end,

    quickstop_mode = function(tab)
        return ui_get(configs[tab].quickstop_mode)
    end,

    prefer_bodyaim = function(tab)
        return ui_get(configs[tab].preferbaim)
    end,

    prefer_bodyaim_disabler = function(tab)
        return ui_get(configs[tab].prefer_bodyaim_disabler)
    end,

    ping_spike = function(tab)
        return ui_get(configs[tab].ping_spike)
    end,

    ping_spike_bar = function(tab)
        return ui_get(configs[tab].ping_spike_bar)
    end,
}

local fetchs = function()
    local i = lib.get_weapon()
    ui_set(references.target_selection, fetch.target_selection(i))
    ui_set(references.target_hitbox, fetch.target_hitbox(i))
    ui_set(references.prefer_safe_point, fetch.prefer_safe_point(i))
    ui_set(references.unsafe, fetch.unsafe(i))
    ui_set(references.automatic_fire, fetch.automatic_fire(i))
    ui_set(references.automatic_penetration, fetch.automatic_penetration(i))
    ui_set(references.automatic_scope, fetch.automatic_scope(i))
    ui_set(references.silent_aim, fetch.silent_aim(i))
    ui_set(references.multipoint, fetch.multipoint(i))
    ui_set(references.multipoint_scale, fetch.multipoint_scale(i))
    ui_set(references.mindamage, fetch.damage(i))
    ui_set(references.hitchance, fetch.hitchance(i))
    ------------------------------------------------
    ui_set(references.accuracy_boost, fetch.accuracy(i))
    ui_set(references.delay_shot, fetch.delay_shot(i))
    ui_set(references.quickstop, fetch.quickstop(i))
    ui_set(references.quickstop_option[3], fetch.quickstop_mode(i))
    ui_set(references.prefer_bodyaim, fetch.prefer_bodyaim(i))
    ui_set(references.prefer_bodyaim_disabler, fetch.prefer_bodyaim_disabler(i))
    ------------------------------------------------
    ui_set(references.ping_spike[1], fetch.ping_spike(i))
    ui_set(references.ping_spike[2], fetch.ping_spike(i) and "Always on" or "On hotkey")
    ui_set(references.ping_spike[3], fetch.ping_spike_bar(i))
    ------------------------------------------------
    fetch.sync(ragebot.quick_peek_assist[1], main.quick_peek_assist)
    fetch.sync(ragebot.quick_peek_assist_distance, main.quick_peek_assist_distance)
    fetch.sync(ragebot.quick_peek_assist_mode[1], main.quick_peek_assist_mode)

    fetch.sync(ragebot.double_tap[1], main.doubletap)
    --fetch.sync(ragebot.double_tap_mode, main.double_tap_mode)
    fetch.sync(ragebot.double_tap_hitchance, main.double_tap_hitchance)
    fetch.sync(ragebot.double_tap_fake_lag_limit, main.double_tap_fake_lag_limit)

    fetch.sync(ragebot.double_tap[2], main.doubletap_key, "Hotkey")
    fetch.sync(ragebot.quick_peek_assist[2], main.quick_peek_assist_hotkey, "Hotkey")
    fetch.sync(ragebot.force_body_aim, main.force_body_aim, "Hotkey")
    fetch.sync(ragebot.force_safepoint, main.force_safepoint, "Hotkey")
    fetch.sync(ragebot.duck_peek_assist, main.duck_peek_assist, "Hotkey")
end

local drags = {
    -- For Corsshair element
    damage = dragging_fn('damage', 600, 600),
    hitchance = dragging_fn('hitchance', 650, 600),
    multipoint = dragging_fn('multipoint', 700, 600),
    hitbox = dragging_fn("hitbox", 750, 600),
    debugger = dragging_fn("debugger", 0, 500),

    infobox = dragging_fn("Container", 100, 600)
}

local ani = {
    damage = {0, 0},
    hitchance = {0, 0},
    multipoint = {0, 0},
    hitbox = {0, 0, 0, 0, 0},
    debugger = {0, 0, 0, 0, 0},
    debugger_pos = {0, 0, 0},

    infobox = {0, 0}
}

local paint = {

    --------------------------------------------------------------------------------
    -- Cross Hair indicator
    --------------------------------------------------------------------------------

    damage_cs = function(color)
        local text = ui_get(references.mindamage)
        local damage = text
        local x, y = drags.damage:get()
        local width, height = renderer.measure_text("", damage)
        local _, _, status = drags.damage:drag(width + 3, height + 3)
        local selected = (status == "n" and true) or false
        local clicked = (status == "c" and true) or false
        ani.damage[1] = lerp(ani.damage[1], clicked and 150 or 250, 6 * globals.frametime())
        ani.damage[2] = lerp(ani.damage[2], selected and 0 or 250, 3.5 * globals.frametime())
        outline(x - 3, y - 3, width + 6, height + 6, 2, color[1], color[2], color[3], ani.damage[2])
        renderer_text(x, y, color[1], color[2], color[3], ani.damage[1], "", nil, damage)
    end,

    hitchance_cs = function(color)
        local text = ui_get(references.hitchance)
        local hitchance = text.."%"
        local x, y = drags.hitchance:get()
        local width, height = renderer.measure_text("", hitchance)
        local _, _, status = drags.hitchance:drag(width + 3, height + 3)
        local selected = (status == "n" and true) or false
        local clicked = (status == "c" and true) or false
        ani.hitchance[1] = lerp(ani.hitchance[1], clicked and 150 or 250, 6 * globals.frametime())
        ani.hitchance[2] = lerp(ani.hitchance[2], selected and 0 or 250, 3.5 * globals.frametime())
        outline(x - 3, y - 3, width + 6, height + 6, 2, color[1], color[2], color[3], ani.hitchance[2])
        renderer_text(x, y, color[1], color[2], color[3], ani.hitchance[1], "", nil, hitchance)
    end,

    multipoint_cs = function(color)
        local text = ui_get(references.multipoint_scale)
        local multipoint = text.."%"
        local x, y = drags.multipoint:get()
        local width, height = renderer.measure_text("", multipoint)
        local _, _, status = drags.multipoint:drag(width + 3, height + 3)
        local selected = (status == "n" and true) or false
        local clicked = (status == "c" and true) or false
        ani.multipoint[1] = lerp(ani.multipoint[1], clicked and 150 or 250, 6 * globals.frametime())
        ani.multipoint[2] = lerp(ani.multipoint[2], selected and 0 or 250, 3.5 * globals.frametime())
        outline(x - 3, y - 3, width + 6, height + 6, 2, color[1], color[2], color[3], ani.multipoint[2])
        renderer_text(x, y, color[1], color[2], color[3], ani.multipoint[1], "", nil, multipoint)
    end,

    hitbox_cs = function(color)
        local hitbox_state = ui_get(references.target_hitbox)
        local head_only = lib.contains(hitbox_state, "Head") and #hitbox_state == 1
        local body_only = not lib.contains(hitbox_state, "Head")
        local hitbox = head_only and "HEAD" or body_only and "BODY" or "NONE"
        local x, y = drags.hitbox:get()
        local width, height = renderer.measure_text("", hitbox)
        local _, _, status = drags.hitbox:drag(width + 3, height + 3)
        local selected = (status == "n" and true) or false
        local clicked = (status == "c" and true) or false
        ani.hitbox[1] = lerp(ani.hitbox[1], clicked and 150 or 250, 6 * globals.frametime())
        ani.hitbox[2] = lerp(ani.hitbox[2], selected and 0 or 250, 3.5 * globals.frametime())
        ani.hitbox[3] = lerp(ani.hitbox[3], (head_only and 255) or (body_only and 0) or color[1], 3.5 * globals.frametime())
        ani.hitbox[4] = lerp(ani.hitbox[4], (head_only and 180) or (body_only and 255) or color[2], 3.5 * globals.frametime())
        ani.hitbox[5] = lerp(ani.hitbox[5], (head_only and 180) or (body_only and 0) or color[3], 3.5 * globals.frametime())
        outline(x - 3, y - 3, width + 6, height + 6, 2, color[1], color[2], color[3], ani.hitbox[2])
        renderer_text(x, y, ani.hitbox[3], ani.hitbox[4], ani.hitbox[5], ani.hitbox[1], "", nil, hitbox)
    end,

    --------------------------------------------------------------------------------
    -- Info Boxes
    --------------------------------------------------------------------------------

    infobox = function()
        local x, y = drags.infobox:get()
        local _, _, status = drags.infobox:drag(68, 25 + 5)
        local selected = (status ~= "n" and true) or false
        local clicked = (status == "o" and true) or false
        ani.infobox[1] = lerp(ani.infobox[1], clicked and 180 or 250, 6 * globals.frametime())
        ani.infobox[2] = lerp(ani.infobox[2], selected and 2.3 or 1.1, 3.5 * globals.frametime())
        solus_render.container(x, y, 68, 25 + 5, 184, 187, 230, 230, ani.infobox[2], 134, 137, 180, 80)
    end,

    --------------------------------------------------------------------------------
    -- Feature Indicators
    --------------------------------------------------------------------------------

    vanilla = function(color_1, color_2)

        local i = lib.get_weapon()

        local ind = {
            dmg = lib.contains(ui_get(indicator.feature_tbl), "Min Damage States"),
            hc = lib.contains(ui_get(indicator.feature_tbl), "Hitchance States"),
            hb = lib.contains(ui_get(indicator.feature_tbl), "Hitbox States"),
        }

        local damage, state = fetch.damage(i)
        local dmg_states = (ind.dmg and "D: "..state) or ""

        local hitchance, state = fetch.hitchance(i)
        local hc_states = (ind.hc and "H: "..state) or ""

        local Seperate = (ind.dmg and ind.hc) and " | " or ""
        local print_screen = g_text(color_1, color_2, dmg_states..Seperate..hc_states)

        renderer.indicator(255, 255, 255, 255, print_screen)

        local hitbox = ui_get(references.target_hitbox)
        local print_screen = ind.hb and lib.get_hitbox(hitbox) or ""
        
        renderer.indicator(255, 80, 80, 255, print_screen)
    end,

    draw_layer_1 = function(x, y, w, h, header, a)
        local c = {10, 60, 40, 40, 40, 60, 20}
    
        for i = 0,6,1 do
            renderer.rectangle(x+i, y+i, w-(i*2), h-(i*2), c[i+1], c[i+1], c[i+1], a)
        end
        if header then
            local x_inner, y_inner = x+7, y+7
            local w_inner = w-14
    
            local a_lower = a
            renderer.gradient(x_inner, y_inner+1, math_floor(w_inner/2), 1, 59, 175, 222, a_lower, 202, 70, 205, a_lower, true)
            renderer.gradient(x_inner+math.floor(w_inner/2), y_inner+1, math.ceil(w_inner/2), 1, 202, 70, 205, a_lower, 201, 227, 58, a_lower, true)
        end
    end,

    draw_layer2 = function(x, y, w, h, a)
        renderer_rectangle(x + 13, y + 15, math_abs(w - 30 + 2 + 2), math_abs(h-30 + 2 + 2), 12, 12, 12, a)
        renderer_rectangle(x + 14, y + 16, math_abs(w - 30 + 2), math_abs(h-30 + 2), 40, 40, 40,a)
        renderer_rectangle(x + 15 ,y + 17, math_abs(w - 30), math_abs(h-30), 23, 23, 23, a)
    end,


    draw_layer_boxes = function(x, y, a, text, content)
        renderer_text(x + 25,y + (25), 205, 205, 205, a,"",0, text)
        renderer_rectangle(x + 25, y + 15+ (25), 150 + 2, 20, 12, 12, 12, a)
        renderer_rectangle(x + 25 + 1, y + 15 +1 + (25), 150, 18, 44, 44, 44, a)
        renderer_text(x + 25 + 8, y + 15 +3 + (25), 147, 147, 147, a, "", 0, content)
    end,

    draw_layer_slider = function(x, y, a, text, slider, index, mpy)
        local r,g,b, alpha = ui_get(references.menu_color)
        renderer_text(x + 25,y + 30, 205, 205, 205, a,"",0, text)
        renderer_rectangle(x + 25 - 1, y + 45 -1, 150 + 2, 5 + 2, 12, 12, 12, a)
        renderer_rectangle(x + 25, y + 45, 150, 5, 60, 60, 60, a)
        renderer_rectangle(x + 25, y + 45, slider * mpy, 4, r, g, b, a)
        outline_text(x + 25 + slider * mpy, y + 47,205,205,205, a,"bc", index)
    end,

}

local g_callback = {

    call = function()

        inti.main()
        inti.config_1()
        inti.config_2()
        inti.configs_3()

        --lib.config_download()

        local handle_visible = function()
            visible.weapon()
            visible.keybinds()
            visible.labels()
            visible.indicators()
            visible.others()
            visible.original_menu(false)
        end

        local weapon_fetch = function()
            fetchs()
        end

        local paints_cs = function(color)
            local cs_dmg = lib.contains(ui_get(indicator.crosshair_tbl), "Damage")
            if cs_dmg then paint.damage_cs(color) end

            local cs_hc = lib.contains(ui_get(indicator.crosshair_tbl), "Hitchance")
            if cs_hc then paint.hitchance_cs(color) end

            local cs_mp = lib.contains(ui_get(indicator.crosshair_tbl), "Multipoint")
            if cs_mp then paint.multipoint_cs(color) end

            local cs_hb = lib.contains(ui_get(indicator.crosshair_tbl), "Hitbox state")
            if cs_hb then paint.hitbox_cs(color) end

            -- paint.infobox()
        end

        local paints_vn = function(color_1, color_2)
            local vc_enable = ui_get(indicator.feature)
            if vc_enable then paint.vanilla(color_1, color_2) end
        end

        local paints_debug = function()
            local config = {
                damage = ui_get(references.mindamage),
                hitchance = ui_get(references.hitchance),
                hitbox = ui_get(references.target_hitbox),
                multipoint = ui_get(references.multipoint),
                multipoint_scale = ui_get(references.multipoint_scale),
                unsafe = ui_get(references.unsafe),
            }

            local get_menu_x , get_menu_y = ui.menu_position()
            local w,h = 200, 250
            local animation = 12

            local custom = (ui_get(indicator.debugger_type) == "Customize")
            local menu = (ui_get(indicator.debugger_type) == "Menu position")
            local drag_x, drag_y = drags.debugger:get()
            local menu_open = ui_is_menu_open()

            ani.debugger[1] = lerp(ani.debugger[1], menu_open and 255 or 0, 14 * globals.frametime())

            ani.debugger_pos[1] = lerp(ani.debugger_pos[1], ani.debugger[1] < 3 and 200 or 0, 14 * globals_frametime())

            ani.debugger_pos[2] = lerp(ani.debugger_pos[2], (menu and get_menu_x + (w + 630 - ani.debugger_pos[1])) or (custom and drag_x), animation * globals.frametime())
            ani.debugger_pos[3] = lerp(ani.debugger_pos[3], (menu and get_menu_y + 100) or (custom and drag_y), animation * globals.frametime())

            if ani.debugger[1] < 1 then return end

            local x, y = ani.debugger_pos[2], ani.debugger_pos[3]

            local _, _, status = drags.debugger:drag(w + 3, h + 3)
            ani.debugger[5] = lerp(ani.debugger[5], custom and status == "o" and 180 or 0, 8 * globals.frametime())

            -->> Background container
            paint.draw_layer_1(x, y, w, h, true, ani.debugger[1]) 
            paint.draw_layer2(x, y, w, h, ani.debugger[1])

            -->> Header
            renderer_text(x + 25 , y + 13, 204, 204, 204 - ani.debugger[5], ani.debugger[1], "b", nil, index.weapons[lib.get_weapon()])

            -->> Hitbox
            paint.draw_layer_boxes(x, y + 5, ani.debugger[1], "Target Hitbox", lib.tbl_to_string(config.hitbox))

            -->> Multipoint
            paint.draw_layer_boxes(x, y + 5 + 38, ani.debugger[1], "Multi-point", lib.tbl_to_string(config.multipoint))

            -->> Multipoint scale
            local multipoint_index = (config.multipoint_scale < 25 and "Auto" or config.multipoint_scale.."%")
            ani.debugger[2] = lerp(ani.debugger[2], (config.multipoint_scale) - 25, animation * globals.frametime())
            paint.draw_layer_slider(x, y + 3 + 73, ani.debugger[1], "Multi-point Scale", ani.debugger[2], multipoint_index, 1.9)

            -->> Unsafe hitbox
            paint.draw_layer_boxes(x, y + 3 + 105, ani.debugger[1], "Avoid unsafe hitboxes", lib.tbl_to_string(config.unsafe))

            -->> Hitchance
            local hitchance_index = ((config.hitchance == 0 and "Off") or config.hitchance .. "%")
            ani.debugger[3] = lerp(ani.debugger[3], (config.hitchance), animation * globals.frametime())
            paint.draw_layer_slider(x, y + 140, ani.debugger[1], "Hitchance", ani.debugger[3], hitchance_index, 1.45)

            -->> Damage
            local damage_index = ((config.damage > 100 or config.damage == 0) and ""..index.index_dmg[config.damage]) or config.damage
            ani.debugger[4] = lerp(ani.debugger[4], (config.damage), animation * globals.frametime())
            paint.draw_layer_slider(x, y + 165, ani.debugger[1], "Mindamage",  ani.debugger[4], damage_index, 1.15)
        end

        local callback = function()
            handle_visible()

            local local_player = entity_get_local_player()
            if not entity_is_alive(local_player) then return end
            
            weapon_fetch()

            local color = {
                cs = {ui_get(indicator.corsshair_clr)},
                vn_1 = {ui_get(indicator.feature_clr_1)},
                vn_2 = {ui_get(indicator.feature_clr_2)}
            }
            
            local run_crosshair = (ui_get(indicator.crosshair))
            if run_crosshair then paints_cs(color.cs) end

            local run_feature = (ui_get(indicator.feature))
            if run_feature then paints_vn(color.vn_1, color.vn_2) end

            local run_debug = (ui_get(indicator.debugger))
            if run_debug then paints_debug() end
        end

        local shutdown = function()
            visible.original_menu(true)
        end

        client.set_event_callback("paint_ui", callback)
        client.set_event_callback("shutdown", shutdown)
    end
}

g_callback.call()

