local ui = require "gamesense/pui"
local clipboard = (function() local a=require"ffi"local b,tostring,c=string.len,tostring,a.string;local d={}local e=vtable_bind("vgui2.dll","VGUI_System010",7,"int(__thiscall*)(void*)")local f=vtable_bind("vgui2.dll","VGUI_System010",9,"void(__thiscall*)(void*, const char*, int)")local g=vtable_bind("vgui2.dll","VGUI_System010",11,"int(__thiscall*)(void*, int, const char*, int)")local h=a.typeof("char[?]")function d.get()local i=e()if i>0 then local j=h(i)g(0,j,i)return c(j,i-1)end end;d.paste=d.get;function d.set(k)k=tostring(k)f(k,b(k))end;d.copy=d.set;return d end)()
local base64 = (function() local a=require"bit"local b={}local c,d,e=a.lshift,a.rshift,a.band;local f,g,h,i,j,k,tostring,error,pairs=string.char,string.byte,string.gsub,string.sub,string.format,table.concat,tostring,error,pairs;local l=function(m,n,o)return e(d(m,n),c(1,o)-1)end;local function p(q)local r,s={},{}for t=1,65 do local u=g(i(q,t,t))or 32;if s[u]~=nil then error("invalid alphabet: duplicate character "..tostring(u),3)end;r[t-1]=u;s[u]=t-1 end;return r,s end;local v,w={},{}v["base64"],w["base64"]=p("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")v["base64url"],w["base64url"]=p("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")local x={__index=function(y,z)if type(z)=="string"and z:len()==64 or z:len()==65 then v[z],w[z]=p(z)return y[z]end end}setmetatable(v,x)setmetatable(w,x)function b.encode(A,r)r=v[r or"base64"]or error("invalid alphabet specified",2)A=tostring(A)local B,C,D={},1,#A;local E=D%3;local F={}for t=1,D-E,3 do local G,H,I=g(A,t,t+2)local m=G*0x10000+H*0x100+I;local J=F[m]if not J then J=f(r[l(m,18,6)],r[l(m,12,6)],r[l(m,6,6)],r[l(m,0,6)])F[m]=J end;B[C]=J;C=C+1 end;if E==2 then local G,H=g(A,D-1,D)local m=G*0x10000+H*0x100;B[C]=f(r[l(m,18,6)],r[l(m,12,6)],r[l(m,6,6)],r[64])elseif E==1 then local m=g(A,D)*0x10000;B[C]=f(r[l(m,18,6)],r[l(m,12,6)],r[64],r[64])end;return k(B)end;function b.decode(K,s)s=w[s or"base64"]or error("invalid alphabet specified",2)local L="[^%w%+%/%=]"if s then local M,N;for O,P in pairs(s)do if P==62 then M=O elseif P==63 then N=O end end;L=j("[^%%w%%%s%%%s%%=]",f(M),f(N))end;K=h(tostring(K),L,'')local F={}local B,C={},1;local D=#K;local Q=i(K,-2)=="=="and 2 or i(K,-1)=="="and 1 or 0;for t=1,Q>0 and D-4 or D,4 do local G,H,I,R=g(K,t,t+3)local S=G*0x1000000+H*0x10000+I*0x100+R;local J=F[S]if not J then local m=s[G]*0x40000+s[H]*0x1000+s[I]*0x40+s[R]J=f(l(m,16,8),l(m,8,8),l(m,0,8))F[S]=J end;B[C]=J;C=C+1 end;if Q==1 then local G,H,I=g(K,D-3,D-1)local m=s[G]*0x40000+s[H]*0x1000+s[I]*0x40;B[C]=f(l(m,16,8),l(m,8,8))elseif Q==2 then local G,H=g(K,D-3,D-2)local m=s[G]*0x40000+s[H]*0x1000;B[C]=f(l(m,16,8))end;return k(B)end;return b end)()
local images = require "gamesense/images"
local anti_aims = require "gamesense/antiaim_funcs"
local weapons = require "gamesense/csgo_weapons"
local _entity = require "gamesense/entity"
local vector = require "vector"
--local msg_pack=(function()local b,c,d,e,f,g,ipairs,print,h,i,type,error,pairs,assert,j,k=math.floor,math.fmod,math.frexp,math.ldexp,string.reverse,table.insert,ipairs,print,string.byte,table.remove,type,error,pairs,assert,string.sub,table.concat;local l=require"bit"local m=string.char;local n=0;local o=0;local p,q,r,s=l.bor,l.band,l.bxor,l.rshift;local function t(u,v)if u<0 then u=u+256 end;return u%v end;local w=""local x={}local function y(z,A)if z<0 then z=z+65536 end;g(x,m(A,b(z/256),z%256))end;local function B(z,A)if z<0 then z=z+4294967296 end;g(x,m(A,b(z/16777216),b(z/65536)%256,b(z/256)%256,z%256))end;local C;local D=function(z)o=o+1;local E=C(z)g(x,m(0xcb))g(x,f(E))end;C=function(u)local function F(v)return b(v/256),m(c(b(v),256))end;local G=0;if u<0 then G=1;u=-u end;local H,I=d(u)if u==0 then H,I=0,0 elseif u==1/0 then H,I=0,2047 else H=(H*2-1)*e(0.5,53)I=I+1022 end;local v,J=""u=H;for K=1,6 do u,J=F(u)v=v..J end;u,J=F(I*16+u)v=v..J;u,J=F(G*128+u)v=v..J;return v end;local function L(M)local u=0;local N=0.5;for K,v in ipairs(M)do u=u+N*v;N=N/2 end;return u end;local function O(M)local P={}for K,v in ipairs(M)do for Q=0,7,1 do g(P,q(s(v,7-Q),1))end end;return P end;local function R(M)local S=""for K,v in ipairs(M)do S=S..v.." "if K%8==0 then S=S.." "end end;print(S)end;local function T(v)local G=b(v:byte(8)/128)local U=q(v:byte(8),127)*16+s(v:byte(7),4)-1023;local V={q(v:byte(7),15),v:byte(6),v:byte(5),v:byte(4),v:byte(3),v:byte(2),v:byte(1)}local W=O(V)for K=1,4 do i(W,1)end;if G==1 then G=-1 else G=1 end;local X=L(W)if U==-1023 and X==0 then return 0 end;if U==1024 and X==0 then return 1/0*G end;local Y=e(1+X,U)return Y*G end;local Z={}Z.dynamic=function(_)local a0=type(_)return Z[a0](_)end;Z["nil"]=function(_)g(x,m(0xc0))end;Z.boolean=function(_)if _ then g(x,m(0xc3))else g(x,m(0xc2))end end;Z.number=function(z)if b(z)==z then if z>=0 then if z<128 then g(x,m(z))elseif z<256 then g(x,m(0xcc,z))elseif z<65536 then y(z,0xcd)elseif z<4294967296 then B(z,0xce)else D(z)end else if z>=-32 then g(x,m(0xe0+(z+256)%32))elseif z>=-128 then g(x,m(0xd0,t(z,0x100)))elseif z>=-32768 then y(z,0xd1)elseif z>=-2147483648 then B(z,0xd2)else D(z)end end else D(z)end end;Z.string=function(_)local z=#_;if z<32 then g(x,m(0xa0+z))elseif z<65536 then y(z,0xda)elseif z<4294967296 then B(z,0xdb)else error("overflow")end;g(x,_)end;Z["function"]=function(_)error("unimplemented:function")end;Z.userdata=function(_)error("unimplemented:userdata")end;Z.thread=function(_)error("unimplemented:thread")end;Z.table=function(_)local a1,a2,a3=false,0,0;for a4,a5 in pairs(_)do if type(a4)=="number"then if a4>a3 then a3=a4 end else a1=true end;a2=a2+1 end;if a1 then if a2<16 then g(x,m(0x80+a2))elseif a2<65536 then y(a2,0xde)elseif a2<4294967296 then B(a2,0xdf)else error("overflow")end;for a4,v in pairs(_)do Z[type(a4)](a4)Z[type(v)](v)end else if a3<16 then g(x,m(0x90+a3))elseif a3<65536 then y(a3,0xdc)elseif a3<4294967296 then B(a3,0xdd)else error("overflow")end;for K=1,a3 do Z[type(_[K])](_[K])end end end;local a6={[0xc0]="nil",[0xc2]="false",[0xc3]="true",[0xca]="float",[0xcb]="double",[0xcc]="uint8",[0xcd]="uint16",[0xce]="uint32",[0xcf]="uint64",[0xd0]="int8",[0xd1]="int16",[0xd2]="int32",[0xd3]="int64",[0xda]="raw16",[0xdb]="raw32",[0xdc]="array16",[0xdd]="array32",[0xde]="map16",[0xdf]="map32"}local a7=function(z)if a6[z]then return a6[z]elseif z<0xc0 then if z<0x80 then return"fixnum_posi"elseif z<0x90 then return"fixmap"elseif z<0xa0 then return"fixarray"else return"fixraw"end elseif z>0xdf then return"fixnum_neg"else return"undefined"end end;local a8={uint16=2,uint32=4,uint64=8,int16=2,int32=4,int64=8,float=4,double=8}local a9={}local aa=function(ab,ac,ad)local ae,af,ag,ah,ai,aj,ak,al;if ad>=2 then ae,af=h(w,ab+1,ab+2)end;if ad>=4 then ag,ah=h(w,ab+3,ab+4)end;if ad>=8 then ai,aj,ak,al=h(w,ab+5,ab+8)end;if ac=="uint16_t"then return ae*256+af elseif ac=="uint32_t"then return ae*65536*256+af*65536+ag*256+ah elseif ac=="int16_t"then local z=ae*256+af;local am=(65536-z)*-1;if am==-65536 then am=0 end;return am elseif ac=="int32_t"then local z=ae*65536*256+af*65536+ag*256+ah;local am=(4294967296-z)*-1;if am==-4294967296 then am=0 end;return am elseif ac=="double_t"then local S=m(al,ak,aj,ai,ah,ag,af,ae)n=n+1;local z=T(S)return z else error("unpack_number: not impl:"..ac)end end;local function an(ab)local ao=a7(h(w,ab+1,ab+1))local ad=a8[ao]local ac;if ao=="float"then error("float is not implemented")else ac=ao.."_t"end;return ab+ad+1,aa(ab+1,ac,ad)end;local function ap(ab,z)local aq={}local a4,v;for K=1,z do ab,a4=a9.dynamic(ab)assert(ab)ab,v=a9.dynamic(ab)assert(ab)aq[a4]=v end;return ab,aq end;local function ar(ab,z)local aq={}for K=1,z do ab,aq[K]=a9.dynamic(ab)assert(ab)end;return ab,aq end;function a9.dynamic(ab)if ab>=#w then error("need more data")end;local ao=a7(h(w,ab+1,ab+1))return a9[ao](ab)end;function a9.undefined(ab)error("unimplemented:undefined")end;a9["nil"]=function(ab)return ab+1,nil end;a9["false"]=function(ab)return ab+1,false end;a9["true"]=function(ab)return ab+1,true end;a9.fixnum_posi=function(ab)return ab+1,h(w,ab+1,ab+1)end;a9.uint8=function(ab)return ab+2,h(w,ab+2,ab+2)end;a9.uint16=an;a9.uint32=an;a9.uint64=an;a9.fixnum_neg=function(ab)local z=h(w,ab+1,ab+1)local am=(256-z)*-1;return ab+1,am end;a9.int8=function(ab)local K=h(w,ab+2,ab+2)if K>127 then K=(256-K)*-1 end;return ab+2,K end;a9.int16=an;a9.int32=an;a9.int64=an;a9.float=an;a9.double=an;a9.fixraw=function(ab)local z=t(h(w,ab+1,ab+1),0x1f+1)local E;if#w-1-ab<z then error("require more data")end;if z>0 then E=j(w,ab+1+1,ab+1+1+z-1)else E=""end;return ab+z+1,E end;a9.raw16=function(ab)local z=aa(ab+1,"uint16_t",2)if#w-1-2-ab<z then error("require more data")end;local E=j(w,ab+1+1+2,ab+1+1+2+z-1)return ab+z+3,E end;a9.raw32=function(ab)local z=aa(ab+1,"uint32_t",4)if#w-1-4-ab<z then error("require more data (possibly bug)")end;local E=j(w,ab+1+1+4,ab+1+1+4+z-1)return ab+z+5,E end;a9.fixarray=function(ab)return ar(ab+1,t(h(w,ab+1,ab+1),0x0f+1))end;a9.array16=function(ab)return ar(ab+3,aa(ab+1,"uint16_t",2))end;a9.array32=function(ab)return ar(ab+5,aa(ab+1,"uint32_t",4))end;a9.fixmap=function(ab)return ap(ab+1,t(h(w,ab+1,ab+1),0x0f+1))end;a9.map16=function(ab)return ap(ab+3,aa(ab+1,"uint16_t",2))end;a9.map32=function(ab)return ap(ab+5,aa(ab+1,"uint32_t",4))end;local as=function(_)x={}Z.dynamic(_)local S=k(x,"")return S end;local at=function(S,ab)if ab==nil then ab=0 end;if type(S)~="string"then return false,"invalid argument"end;local _;w=S;ab,_=a9.dynamic(ab)return _,ab end;local function au()return{double_decode_count=n,double_encode_count=o}end;local av={pack=as,unpack=at,stat=au}return av end)()

local renderer_world_to_screen, renderer_line, globals_tickinterval, renderer_indicator, entity_get_esp_data, bit_lshift, client_set_cvar, renderer_circle, table_insert, client_key_state, ui_mouse_position, globals_framecount, ui_is_menu_open, renderer_triangle, client_color_log, client_exec, entity_get_players, entity_set_prop, client_set_clan_tag, entity_get_player_name, client_camera_angles, math_rad, math_cos, math_sin, ui_hotkey, client_delay_call, client_random_int, client_eye_position, entity_is_enemy, entity_is_dormant, client_userid_to_entindex, globals_curtime, entity_get_player_weapon, client_latency, math_abs, globals_tickcount, entity_get_game_rules, bit_band, entity_get_local_player, entity_get_prop, entity_is_alive, vector, math_min, math_max, renderer_text, renderer_rectangle, math_floor, renderer_measure_text, globals_realtime, globals_frametime, client_screen_size, client_set_event_callback, ui_slider, ui_combobox, ui_checkbox, ui_multiselect, ui_label, ui_reference, ui_listbox, ui_textbox, ui_button = renderer.world_to_screen, renderer.line, globals.tickinterval, renderer.indicator, entity.get_esp_data, bit.lshift, client.set_cvar, renderer.circle, table.insert, client.key_state, ui.mouse_position, globals.framecount, ui.is_menu_open, renderer.triangle, client.color_log, client.exec, entity.get_players, entity.set_prop, client.set_clan_tag, entity.get_player_name, client.camera_angles, math.rad, math.cos, math.sin, ui.hotkey, client.delay_call, client.random_int, client.eye_position, entity.is_enemy, entity.is_dormant, client.userid_to_entindex, globals.curtime, entity.get_player_weapon, client.latency, math.abs, globals.tickcount, entity.get_game_rules, bit.band, entity.get_local_player, entity.get_prop, entity.is_alive, vector, math.min, math.max, renderer.text, renderer.rectangle, math.floor, renderer.measure_text, globals.realtime, globals.frametime, client.screen_size, client.set_event_callback, ui.slider, ui.combobox, ui.checkbox, ui.multiselect, ui.label, ui.reference, ui.listbox, ui.textbox, ui.button

local obex_data = obex_fetch and obex_fetch() or {username = 'Ideal', build = 'Beta'}
local version = "1.1"
local cfg_tbl = {
    {
        name = "Default",
        data = "W3sidGFiIjoiTWFpbiIsIm1haW5fY2hlY2siOnRydWUsIm1haW4iOnsiY2ZnX2xpc3QiOjEsIm1haW5fY29sb3JfYyI6IiNCNzg1M0FGRiIsImNmZ19uYW1lIjoiIn0sImFudGlfYWltcyI6eyJidWlsZGVyIjp7InN0YXRlIjoiQy1BaXIifSwiZ2VuZXJhbCI6eyJtYW51YWxfZnMiOlsxLDAsIn4iXSwib25fdXNlX2FhIjp0cnVlLCJtYWluX2NoZWNrIjpmYWxzZSwibWFudWFsX3lhdyI6dHJ1ZSwibWFudWFsX3JpZ2h0IjpbMSw2NywifiJdLCJmYWtlbGFnX2NoZWNrIjp0cnVlLCJtYW51YWxfc3RhdGljIjpmYWxzZSwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwiZmFzdF9sYWRkZXIiOnRydWUsImF2b2lkX2JhY2tzdGFiIjp0cnVlLCJtYW51YWxfZWRnZSI6WzEsMCwifiJdLCJmYWtlbGFnX2Rpc2FibGVycyI6WyJ+Il0sImZha2VsYWdfYW1vdW50IjoxNSwiZm9yY2Vfc3RhdGljIjpmYWxzZSwiZGVmZW5zaXZlX29uX2hzIjpmYWxzZSwibWFudWFsX2xlZnQiOlsxLDkwLCJ+Il0sImZha2VsYWdfbW9kZSI6Ik1heGltdW0ifSwidGFiIjoiQnVpbGRlciIsImFudGlfYnJ1dGUiOnsibWFpbl9jaGVjayI6dHJ1ZSwiY29uZGl0aW9ucyI6WyJPbiBEZWF0aCIsIn4iXSwib3B0aW9ucyI6WyJTaWRlIiwifiJdLCJ0aW1lciI6dHJ1ZSwidGltZXJfdmFsdWUiOjk3fX0sInNldHRpbmdzIjp7ImhpdG1hcmtlcl9mX2NsX2MiOiIjMDBGRkZGRkYiLCJ2ZWxvY2l0eV93YXJuaW5nIjp0cnVlLCJhcnJvd3MiOmZhbHNlLCJ0ZWxlcG9ydF9leHBsb2l0IjpmYWxzZSwiYXV0b19oaWRlc2hvdHNfd3BucyI6WyJQaXN0b2wiLCJTY2FyIiwiUmlmbGUiLCJ+Il0sImJldHRlcl9qdW1wX3Njb3V0X29wdCI6WyJ+Il0sImNsYW50YWciOmZhbHNlLCJ2aWV3bW9kZWxfY2hlY2siOmZhbHNlLCJ2aWV3bW9kZWxfeSI6MTAsImRpc2FibGVfdHBfaW5kaWMiOmZhbHNlLCJidWxsZXRfdHJhY2VyIjp0cnVlLCJkZWZfaW5kaWNhdG9yX2MiOiIjQzFDQkZGRkYiLCJ2aWV3bW9kZWxfeiI6LTEwLCJlbmRfY29sX2MiOiIjMzczNDQzRkYiLCJhdXRvX2hpZGVzaG90cyI6dHJ1ZSwiYXV0b190ZWxlcG9ydCI6ZmFsc2UsImtpbGxzYXlfdHlwZSI6IkRlZmF1bHQiLCJvdXRwdXQiOlsiT24gc2NyZWVuIiwiQ29uc29sZSIsIn4iXSwiZHJhZ2dpbmciOnsidmVsX3kiOjM1MCwiZGVmX3kiOjI1MCwidmVsX3giOjEyMTYsImRlZl94IjoxMjMwfSwiaGl0bG9ncyI6dHJ1ZSwiaW5kaWNhdG9ycyI6ZmFsc2UsImNvbnNvbGVfZmlsdGVyIjp0cnVlLCJidWxsZXRfdHJhY2VyX2MiOiIjRkZGRkZGRkYiLCJ1bnNhZmVfZGlzY2hhcmdlIjp0cnVlLCJpbmRpY19zd2l0Y2hfY29sb3JfYyI6IiNGRjk3OTdGRiIsImtpbGxzYXkiOmZhbHNlLCJoaXRtYXJrZXIiOnRydWUsImRlZl9pbmRpY2F0b3IiOnRydWUsImFuaW1fYnJlYWtlciI6ZmFsc2UsImF1dG9fdGVsZXBvcnRfaCI6WzEsMCwifiJdLCJ0ZWxlcG9ydF9leHBsb2l0X2giOlsxLDAsIn4iXSwiYmV0dGVyX2p1bXBfc2NvdXQiOmZhbHNlLCJzdGFydF9jb2xfYyI6IiNCNzg1M0FGRiIsImFuaW1fYnJlYWtlcl9zZWxlY3Rpb24iOlsifiJdLCJoaXRtYXJrZXJfc19jbF9jIjoiIzAwRkYwMEZGIiwidmlld21vZGVsX3giOjEwLCJ0eXBlIjpbIkhpdCIsIk1pc3MiLCJOYWRlIiwiQW50aS1icnV0ZSIsIn4iXSwidmVsb2NpdHlfd2FybmluZ19jIjoiIzhEOUZGRkZGIiwid2F0ZXJtYXJrIjp0cnVlLCJpbmRpY190eXBlIjoiQ2xhc3NpYyJ9fSxbeyJlbmFibGUiOnRydWUsInlhd19mbGlja19kZWxheSI6MSwiYm9keXlhd19hZGQiOjE0LCJib2R5X3lhdyI6IkppdHRlciIsImRlZmVuc2l2ZV9waXRjaF92YWx1ZSI6MCwiZGVmZW5zaXZlX3lhd19kZWxheSI6MCwieWF3X2ppdHRlciI6IkNlbnRlciIsImRlZmVuc2l2ZV95YXdfbWFpbiI6IlNwaW4iLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjo1Miwid2F5XzYiOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfc3cyIjowLCJ3YXlfNSI6LTE4MCwiZGVmZW5zaXZlX3BpdGNoX3N3MiI6MCwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3NlY29uZCI6MCwicGl0Y2giOiJEb3duIiwieWF3X29mZnNldCI6IkRlZmF1bHQiLCJ5YXdfb2Zmc2V0X3ZhbHVlIjoyLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ3YXlfMiI6MTgwLCJkZWZlbnNpdmVfcGl0Y2hfc3ciOjAsIndheV8xIjo5MCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6NTAsInlhd19mbGlja19maXJzdCI6MCwiZGVmZW5zaXZlX3N0YXRlIjoiTm9uZSIsIndheV83Ijo5MCwieWF3IjoiMTgwIiwieWF3X3JpZ2h0IjowLCJkZWZlbnNpdmVfeWF3X3N3IjowLCJ3YXlfMyI6MCwieWF3X2xlZnQiOjAsInBpdGNoX3ZhbHVlIjowLCJ4X3dheV9zbGlkZXIiOjF9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfZmxpY2tfZGVsYXkiOjgsImJvZHl5YXdfYWRkIjo2NywiYm9keV95YXciOiJKaXR0ZXIiLCJkZWZlbnNpdmVfcGl0Y2hfdmFsdWUiOjAsImRlZmVuc2l2ZV95YXdfZGVsYXkiOjAsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJkZWZlbnNpdmVfeWF3X21haW4iOiJTcGluIiwieWF3X2ppdHRlcl9zbGlkZXJfciI6MjcsIndheV82IjowLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X3N3MiI6MCwid2F5XzUiOi0xODAsImRlZmVuc2l2ZV9waXRjaF9zdzIiOjAsIndheV80IjotOTAsInlhd19mbGlja19zZWNvbmQiOi0zNCwicGl0Y2giOiJEb3duIiwieWF3X29mZnNldCI6IkRlZmF1bHQiLCJ5YXdfb2Zmc2V0X3ZhbHVlIjowLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ3YXlfMiI6MTgwLCJkZWZlbnNpdmVfcGl0Y2hfc3ciOjAsIndheV8xIjo5MCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MjcsInlhd19mbGlja19maXJzdCI6MzQsImRlZmVuc2l2ZV9zdGF0ZSI6Ik5vbmUiLCJ3YXlfNyI6OTAsInlhdyI6IjE4MCIsInlhd19yaWdodCI6MCwiZGVmZW5zaXZlX3lhd19zdyI6MCwid2F5XzMiOjAsInlhd19sZWZ0IjowLCJwaXRjaF92YWx1ZSI6MCwieF93YXlfc2xpZGVyIjoxfSx7ImVuYWJsZSI6dHJ1ZSwieWF3X2ZsaWNrX2RlbGF5IjoxLCJib2R5eWF3X2FkZCI6NjIsImJvZHlfeWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlX3BpdGNoX3ZhbHVlIjowLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjowLCJ5YXdfaml0dGVyIjoiWC1XYXkiLCJkZWZlbnNpdmVfeWF3X21haW4iOiJTcGluIiwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwid2F5XzYiOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfc3cyIjowLCJ3YXlfNSI6LTE4MCwiZGVmZW5zaXZlX3BpdGNoX3N3MiI6MCwid2F5XzQiOjU5LCJ5YXdfZmxpY2tfc2Vjb25kIjowLCJwaXRjaCI6IkRvd24iLCJ5YXdfb2Zmc2V0IjoiRGVmYXVsdCIsInlhd19vZmZzZXRfdmFsdWUiOjEsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsIndheV8yIjo1MiwiZGVmZW5zaXZlX3BpdGNoX3N3IjowLCJ3YXlfMSI6NTQsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsInlhd19mbGlja19maXJzdCI6MCwiZGVmZW5zaXZlX3N0YXRlIjoiTm9uZSIsIndheV83Ijo5MCwieWF3IjoiMTgwIiwieWF3X3JpZ2h0IjowLCJkZWZlbnNpdmVfeWF3X3N3IjowLCJ3YXlfMyI6NTcsInlhd19sZWZ0IjowLCJwaXRjaF92YWx1ZSI6MCwieF93YXlfc2xpZGVyIjo0fSx7ImVuYWJsZSI6dHJ1ZSwieWF3X2ZsaWNrX2RlbGF5IjoxLCJib2R5eWF3X2FkZCI6ODEsImJvZHlfeWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlX3BpdGNoX3ZhbHVlIjotNjYsImRlZmVuc2l2ZV95YXdfZGVsYXkiOjAsInlhd19qaXR0ZXIiOiJYLVdheSIsImRlZmVuc2l2ZV95YXdfbWFpbiI6IlN3aXRjaCIsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsIndheV82IjowLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X3N3MiI6MCwid2F5XzUiOi0xODAsImRlZmVuc2l2ZV9waXRjaF9zdzIiOjAsIndheV80IjotOTAsInlhd19mbGlja19zZWNvbmQiOjAsInBpdGNoIjoiRG93biIsInlhd19vZmZzZXQiOiJEZWZhdWx0IiwieWF3X29mZnNldF92YWx1ZSI6LTMsImRlZmVuc2l2ZV9waXRjaCI6IkN1c3RvbSIsIndheV8yIjo1NSwiZGVmZW5zaXZlX3BpdGNoX3N3IjowLCJ3YXlfMSI6NTcsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsInlhd19mbGlja19maXJzdCI6MCwiZGVmZW5zaXZlX3N0YXRlIjoiTm9uZSIsIndheV83Ijo5MCwieWF3IjoiMTgwIiwieWF3X3JpZ2h0IjowLCJkZWZlbnNpdmVfeWF3X3N3IjowLCJ3YXlfMyI6NTYsInlhd19sZWZ0IjowLCJwaXRjaF92YWx1ZSI6MCwieF93YXlfc2xpZGVyIjozfSx7ImVuYWJsZSI6dHJ1ZSwieWF3X2ZsaWNrX2RlbGF5Ijo1LCJib2R5eWF3X2FkZCI6ODMsImJvZHlfeWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlX3BpdGNoX3ZhbHVlIjowLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjowLCJ5YXdfaml0dGVyIjoiWC1XYXkiLCJkZWZlbnNpdmVfeWF3X21haW4iOiJTcGluIiwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwid2F5XzYiOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfc3cyIjowLCJ3YXlfNSI6LTE4MCwiZGVmZW5zaXZlX3BpdGNoX3N3MiI6MCwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3NlY29uZCI6MjEsInBpdGNoIjoiTWluaW1hbCIsInlhd19vZmZzZXQiOiJMXC9SIiwieWF3X29mZnNldF92YWx1ZSI6MSwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwid2F5XzIiOjU5LCJkZWZlbnNpdmVfcGl0Y2hfc3ciOjAsIndheV8xIjo1NywieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwieWF3X2ZsaWNrX2ZpcnN0IjotMTQsImRlZmVuc2l2ZV9zdGF0ZSI6IlRpY2siLCJ3YXlfNyI6OTAsInlhdyI6IjE4MCIsInlhd19yaWdodCI6LTEsImRlZmVuc2l2ZV95YXdfc3ciOjAsIndheV8zIjo2MSwieWF3X2xlZnQiOjEsInBpdGNoX3ZhbHVlIjowLCJ4X3dheV9zbGlkZXIiOjN9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfZmxpY2tfZGVsYXkiOjEsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6IkppdHRlciIsImRlZmVuc2l2ZV9waXRjaF92YWx1ZSI6MCwiZGVmZW5zaXZlX3lhd19kZWxheSI6MCwieWF3X2ppdHRlciI6Ik9mZnNldCIsImRlZmVuc2l2ZV95YXdfbWFpbiI6IlNwaW4iLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjoxMCwid2F5XzYiOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfc3cyIjowLCJ3YXlfNSI6LTE4MCwiZGVmZW5zaXZlX3BpdGNoX3N3MiI6MCwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3NlY29uZCI6MCwicGl0Y2giOiJEZWZhdWx0IiwieWF3X29mZnNldCI6IkRlZmF1bHQiLCJ5YXdfb2Zmc2V0X3ZhbHVlIjowLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ3YXlfMiI6MTgwLCJkZWZlbnNpdmVfcGl0Y2hfc3ciOjAsIndheV8xIjo5MCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MTAsInlhd19mbGlja19maXJzdCI6MCwiZGVmZW5zaXZlX3N0YXRlIjoiTm9uZSIsIndheV83Ijo5MCwieWF3IjoiMTgwIiwieWF3X3JpZ2h0IjowLCJkZWZlbnNpdmVfeWF3X3N3IjowLCJ3YXlfMyI6MCwieWF3X2xlZnQiOjAsInBpdGNoX3ZhbHVlIjowLCJ4X3dheV9zbGlkZXIiOjF9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfZmxpY2tfZGVsYXkiOjEsImJvZHl5YXdfYWRkIjotMTI3LCJib2R5X3lhdyI6IkppdHRlciIsImRlZmVuc2l2ZV9waXRjaF92YWx1ZSI6MCwiZGVmZW5zaXZlX3lhd19kZWxheSI6MCwieWF3X2ppdHRlciI6IkNlbnRlciIsImRlZmVuc2l2ZV95YXdfbWFpbiI6IlNwaW4iLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjo1Miwid2F5XzYiOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfc3cyIjowLCJ3YXlfNSI6LTE4MCwiZGVmZW5zaXZlX3BpdGNoX3N3MiI6MCwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3NlY29uZCI6MCwicGl0Y2giOiJEb3duIiwieWF3X29mZnNldCI6IkRlZmF1bHQiLCJ5YXdfb2Zmc2V0X3ZhbHVlIjozLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ3YXlfMiI6MTgwLCJkZWZlbnNpdmVfcGl0Y2hfc3ciOjAsIndheV8xIjo5MCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6NTIsInlhd19mbGlja19maXJzdCI6MCwiZGVmZW5zaXZlX3N0YXRlIjoiTm9uZSIsIndheV83Ijo5MCwieWF3IjoiMTgwIiwieWF3X3JpZ2h0IjowLCJkZWZlbnNpdmVfeWF3X3N3IjowLCJ3YXlfMyI6MCwieWF3X2xlZnQiOjAsInBpdGNoX3ZhbHVlIjowLCJ4X3dheV9zbGlkZXIiOjF9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfZmxpY2tfZGVsYXkiOjEsImJvZHl5YXdfYWRkIjo4OSwiYm9keV95YXciOiJKaXR0ZXIiLCJkZWZlbnNpdmVfcGl0Y2hfdmFsdWUiOjAsImRlZmVuc2l2ZV95YXdfZGVsYXkiOjAsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJkZWZlbnNpdmVfeWF3X21haW4iOiJTcGluIiwieWF3X2ppdHRlcl9zbGlkZXJfciI6NDEsIndheV82IjowLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X3N3MiI6MCwid2F5XzUiOi0xODAsImRlZmVuc2l2ZV9waXRjaF9zdzIiOjAsIndheV80IjotOTAsInlhd19mbGlja19zZWNvbmQiOjAsInBpdGNoIjoiRG93biIsInlhd19vZmZzZXQiOiJMXC9SIiwieWF3X29mZnNldF92YWx1ZSI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwid2F5XzIiOjE4MCwiZGVmZW5zaXZlX3BpdGNoX3N3IjowLCJ3YXlfMSI6OTAsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjM5LCJ5YXdfZmxpY2tfZmlyc3QiOjAsImRlZmVuc2l2ZV9zdGF0ZSI6Ik5vbmUiLCJ3YXlfNyI6OTAsInlhdyI6IjE4MCIsInlhd19yaWdodCI6NSwiZGVmZW5zaXZlX3lhd19zdyI6MCwid2F5XzMiOjAsInlhd19sZWZ0IjozLCJwaXRjaF92YWx1ZSI6MCwieF93YXlfc2xpZGVyIjoxfSx7ImVuYWJsZSI6dHJ1ZSwieWF3X2ZsaWNrX2RlbGF5IjoxLCJib2R5eWF3X2FkZCI6MTIsImJvZHlfeWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlX3BpdGNoX3ZhbHVlIjowLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjowLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwiZGVmZW5zaXZlX3lhd19tYWluIjoiU3BpbiIsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjU1LCJ3YXlfNiI6MCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19zdzIiOjAsIndheV81IjotMTgwLCJkZWZlbnNpdmVfcGl0Y2hfc3cyIjowLCJ3YXlfNCI6LTkwLCJ5YXdfZmxpY2tfc2Vjb25kIjowLCJwaXRjaCI6IkRvd24iLCJ5YXdfb2Zmc2V0IjoiRGVmYXVsdCIsInlhd19vZmZzZXRfdmFsdWUiOjEsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsIndheV8yIjoxODAsImRlZmVuc2l2ZV9waXRjaF9zdyI6MCwid2F5XzEiOjkwLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjo1NSwieWF3X2ZsaWNrX2ZpcnN0IjowLCJkZWZlbnNpdmVfc3RhdGUiOiJOb25lIiwid2F5XzciOjkwLCJ5YXciOiIxODAiLCJ5YXdfcmlnaHQiOjAsImRlZmVuc2l2ZV95YXdfc3ciOjAsIndheV8zIjowLCJ5YXdfbGVmdCI6MCwicGl0Y2hfdmFsdWUiOjAsInhfd2F5X3NsaWRlciI6MX0seyJlbmFibGUiOmZhbHNlLCJ5YXdfZmxpY2tfZGVsYXkiOjEsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6Ik9mZiIsImRlZmVuc2l2ZV9waXRjaF92YWx1ZSI6MCwiZGVmZW5zaXZlX3lhd19kZWxheSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsImRlZmVuc2l2ZV95YXdfbWFpbiI6IlNwaW4iLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjowLCJ3YXlfNiI6MCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19zdzIiOjAsIndheV81IjotMTgwLCJkZWZlbnNpdmVfcGl0Y2hfc3cyIjowLCJ3YXlfNCI6LTkwLCJ5YXdfZmxpY2tfc2Vjb25kIjowLCJwaXRjaCI6Ik9mZiIsInlhd19vZmZzZXQiOiJEZWZhdWx0IiwieWF3X29mZnNldF92YWx1ZSI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwid2F5XzIiOjE4MCwiZGVmZW5zaXZlX3BpdGNoX3N3IjowLCJ3YXlfMSI6OTAsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsInlhd19mbGlja19maXJzdCI6MCwiZGVmZW5zaXZlX3N0YXRlIjoiTm9uZSIsIndheV83Ijo5MCwieWF3IjoiT2ZmIiwieWF3X3JpZ2h0IjowLCJkZWZlbnNpdmVfeWF3X3N3IjowLCJ3YXlfMyI6MCwieWF3X2xlZnQiOjAsInBpdGNoX3ZhbHVlIjowLCJ4X3dheV9zbGlkZXIiOjF9LHsiZW5hYmxlIjpmYWxzZSwieWF3X2ZsaWNrX2RlbGF5IjoxLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJPZmYiLCJkZWZlbnNpdmVfcGl0Y2hfdmFsdWUiOjAsImRlZmVuc2l2ZV95YXdfZGVsYXkiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJkZWZlbnNpdmVfeWF3X21haW4iOiJTcGluIiwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwid2F5XzYiOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfc3cyIjowLCJ3YXlfNSI6LTE4MCwiZGVmZW5zaXZlX3BpdGNoX3N3MiI6MCwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3NlY29uZCI6MCwicGl0Y2giOiJPZmYiLCJ5YXdfb2Zmc2V0IjoiRGVmYXVsdCIsInlhd19vZmZzZXRfdmFsdWUiOjAsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsIndheV8yIjoxODAsImRlZmVuc2l2ZV9waXRjaF9zdyI6MCwid2F5XzEiOjkwLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJ5YXdfZmxpY2tfZmlyc3QiOjAsImRlZmVuc2l2ZV9zdGF0ZSI6Ik5vbmUiLCJ3YXlfNyI6OTAsInlhdyI6Ik9mZiIsInlhd19yaWdodCI6MCwiZGVmZW5zaXZlX3lhd19zdyI6MCwid2F5XzMiOjAsInlhd19sZWZ0IjowLCJwaXRjaF92YWx1ZSI6MCwieF93YXlfc2xpZGVyIjoxfV1d"
    }
}

local w, h = client_screen_size()
local group = ui.group("AA", "Anti-aimbot angles")
local main_group = ui.group("AA", "Fake lag")
local other_group = ui.group("AA", "Other")
local aa_states = {"Shared", "Stand", "Run", "Air", "C-Air", "Slowwalk", "Crouch", "C-MOVE", "Break LC", "Warmup", "TP"}
local short_names = {"SH", "S", "R", "A", "C-A", "SL", "C", "C-M", "LC", "W", "TP"}
local indicator_names = {"shared", "stand", "run", "air", "c-air", "walk", "crouch", "C-MOVE", "LC", "WP", "TP"}
local warning = images.load_svg([[<svg xmlns="http://www.w3.org/2000/svg" width="600" height="600">
<path style="fill:#ffffff; stroke:none;" d="M292 145C259.262 145 226.667 150.478 194 151.961C180.035 152.595 159.349 150.927 148.015 160.34C138.424 168.305 137.329 181.64 134.525 193C128.692 216.637 123.278 240.38 117.373 264C114.357 276.068 109.358 288.824 114.479 301C122.682 320.504 148.539 321.148 160.876 305.961C170.872 293.655 172.169 270.173 175.651 255C179.362 238.83 184.787 222.434 187 206L232 207C225.396 241.052 218.203 274.989 211.4 309C208.526 323.365 207.92 344.39 200.451 357C177.59 395.599 151.133 432.616 126.333 470C117.47 483.359 98.8484 502.504 98.0401 519C97.6278 527.416 96.988 536.508 101.349 544C113.109 564.205 141.937 568.976 158.985 552.907C177.54 535.418 190.616 508.728 205.427 488C221.034 466.16 236.646 444.248 251.67 422C259.521 410.373 269.164 398.286 274 385L317 421L317 422C310.531 428.272 306.479 438.206 302 446C292.097 463.231 273.486 484.648 272.091 505C270.471 528.633 294.204 545.433 316 536.525C328.609 531.372 333.975 518.093 340.281 507C354.381 482.196 370.048 457.601 382.627 432C393.077 410.731 379.327 395.327 365 381C351.809 367.809 338.501 354.726 325.196 341.665C319.786 336.354 308.649 329.444 306.407 322C304.339 315.135 313.285 300.52 315.811 294C318.057 288.201 319.913 279.753 324.278 275.204C329.556 269.705 334.869 274.755 340 277.716C352.448 284.9 364.72 294.269 378 299.801C389.796 304.715 401.018 298.753 412 294.399C436.913 284.521 467.123 277.699 490 263.786C498.594 258.56 505.379 247.579 502.529 237.285C498.753 223.641 486.044 218.024 473 219.093C453.366 220.703 430.253 234.5 412 241.8C405.766 244.293 394.612 251.187 388 248.424C376.937 243.803 366.285 235.726 356 229.551C352.573 227.493 346.87 224.993 345.438 220.957C343.372 215.132 347.382 203.732 346.91 197C345.917 182.826 338.076 170.421 329 160C346.212 159.953 364.582 154.617 376.826 141.91C406.512 111.102 396.589 58.2419 357 41.4282C316.627 24.2816 272.195 54.8403 271.129 98C270.689 115.808 279.918 132.662 292 145z"/>
</svg>]])

local ui_elements = {
    main_check = ui_checkbox(group, "\bA998FF\b685F95[inferno.lua]"),
    tab = ui_combobox(group, "\n", {"Main", "Anti-Aim", "Settings"}),
    info = {
        label_sp = ui_label(main_group, "\n\n\n"),
        label_tab2 = ui_label(main_group, "\v•\r Information"),
        label2 = ui_label(main_group, "\a464646CC¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯"),
        username_label = ui_label(main_group, "Username: \v" .. obex_data.username),
        build_label = ui_label(main_group, "Version: \v" .. version .. "\aB6B6B6FF" .. (obex_data.build == "Beta" and " \aE25252FF[" .. obex_data.build .. "]" or "")),
        label_space = ui_label(main_group, "\n\n\n\n\n"),
        label_tab = ui_label(main_group, "\v•\r Settings"),
        label = ui_label(main_group, "\a464646CC¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯"),
    },
    main = {
        main_color = ui_label(main_group, "Accent Color", {162, 142, 229}),
        label_cfg_s = ui_label(group, "\n\n\n"),
        label_cfg = ui_label(group, "\v•\r Local Configs"),
        --label = ui_label(group, "\a464646CC¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯"),
        cfg_list = ui_listbox(group, 'Cfg List', 'None', false),
        selected_cfg = ui_label(group, "Selected Config: \v-"),
        load_btn = ui_button(group, "Load", function() end),
        save_btn = ui_button(group, "Save", function() end),
        del_btn = ui_button(group, "\aFF6969FFDelete", function() end),
        cfg_name_l = ui_label(other_group, "Config name"),
        cfg_name =  ui_textbox(other_group, 'Config name'),
        create_btn = ui_button(other_group, "Create", function() end),
        import_btn = ui_button(other_group, "Import", function() end),
        export_btn = ui_button(other_group, "Export", function() end),
    },
    anti_aims = {
        label_space = ui_label(main_group, "\n\n\n"),
        label_tab = ui_label(main_group, "\v•\r Tab Selection"),
        label = ui_label(main_group, "\a464646CC¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯"),
        tab = ui_combobox(main_group, "\nAA Tab", {"General", "Builder", "Anti-brute"}),
        general = {
            main_check = ui_checkbox(group, "\vGL \a5C5C5CFF| \rEnable"),
            yaw_base = ui_combobox(group, "Yaw Base", {"Local view", "At targets"}),
            manual_yaw = ui_checkbox(group, "Manual Yaw"),
            manual_left = ui_hotkey(group, "  \v› \rLeft"),
            manual_right = ui_hotkey(group, "  \v› \rRight"),
            manual_forward = ui_hotkey(group, "  \v› \rForward"),
            manual_edge = ui_hotkey(group, "  \v› \rEdge yaw"),
            manual_fs = ui_hotkey(group, "  \v› \rFreestanding"),
            freestanding_disablers = ui_multiselect(group, "Freestanding Disablers", {"Standing", "Moving", "Slowwalking", "In air", "Fakeducking", "Ducking"}),
            manual_static = ui_checkbox(group, "Static Manual"),
            avoid_backstab = ui_checkbox(group, "Avoid backstab"),
            on_use_aa = ui_checkbox(group, "On use AA"),
            fast_ladder = ui_checkbox(group, "Fast Ladder"),
            safe_head = ui_checkbox(group, "Safe Head"),
            safe_head_wpns = ui_multiselect(group, "Weapons", {"Zeus", "Knife"}),
            defensive_on_hs = ui_checkbox(group, "Defensive AA On Hideshots"),
            fakelag_sp = ui_label(main_group, "\n\n\n\n\n"),
            fakelag_check = ui_checkbox(main_group, "\vFL \a5C5C5CFF| \rEnable"),
            fakelag_mode = ui_combobox(main_group, "\nMode", "Adaptive", "Dynamic", "Maximum", "Fluctuate", "Random"),
            fakelag_amount = ui_slider(main_group, "Limit", 1, 15),
            fakelag_disablers = ui_multiselect(main_group, "Disablers", {"Standing", "Jittering", "Ducking"}),
        },
        anti_brute = {
            main_check = ui_checkbox(group, "\vAB \a5C5C5CFF| \rEnable"),
            options = ui_multiselect(group, "Options", {"Side", "Yaw Offset", "Jitter Offset"}),
            conditions = ui_multiselect(group, "Reset Conditions", {"On Death", "On Round Start", "On unsafe shot"}),
            timer = ui_checkbox(group, "Reset Timer"),
            timer_value = ui_slider(group, "\nTimer", 1, 300, 57, true, "s", 0.1),
        },
        builder = {
            gen_label_s = ui_label(group, "\n\n\n"),
            gen_label = ui_label(group, "\v•\r Builder"),
            gen_label_line = ui_label(group, "\a464646CC¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯"),
            state = ui_combobox(group, "\nState", aa_states),
        },
    },
    settings = {
        rage_label = ui_label(main_group, "\v•\r Ragebot"),
        rage_label_line = ui_label(main_group, "\a464646CC¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯"),
        auto_teleport = ui_checkbox(main_group, "Auto Teleport", 0),
        teleport_exploit = ui_checkbox(main_group, "Teleport Exploit", 0),
        disable_tp_indic = ui_checkbox(main_group, "Disable Teleport Indicator"),
        smart_baim = ui_checkbox(main_group, "Smart Baim"),
        smart_baim_opts = ui_multiselect(main_group, "\nSmart Baim Options", obex_data.build == "Beta" and {"Lethal", "Defensive AA \aD1AA3DFF[BETA]"} or {"Lethal"}),
        smart_baim_wpns = ui_multiselect(main_group, "\nSmart Baim Weapons", {"Scout", "Scar", "R8 Revolver", "AWP", "Deagle", "Shotgun"}),
        smart_baim_disablers = ui_multiselect(main_group, "Smart Baim Disablers", {"Body Not Hittable", "Jump Scouting"}),
        better_jump_scout = ui_checkbox(main_group, "Better Jump Scout"),
        better_jump_scout_opt = ui_multiselect(main_group, "\nJump Scout Options", {"Adjust Strafer", "Crouch"}),
        auto_hideshots = ui_checkbox(main_group, "Automatic Hideshots"),
        auto_hideshots_wpns = ui_multiselect(main_group, "\nAutomatic Hideshots Weapons", {"Pistol", "Scout", "Scar", "Rifle", "SMG", "Machinegun", "Shotgun"}),
        unsafe_discharge = ui_checkbox(main_group, "Unsafe Discharge In Air"),
        rage_space = ui_label(group, "\n\n"),
        gen_label = ui_label(group, "\v•\r Visuals"),
        gen_label_line = ui_label(group, "\a464646CC¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯"),
        arrows = ui_checkbox(group, "Arrows"),
        watermark = ui_checkbox(group, "Watermark"),
        start_col = ui_label(group, "Start Color", {138, 120, 197}),
        end_col = ui_label(group, "End Color", {55, 52, 67}),
        indicators = ui_checkbox(group, "Indicators"),
        indic_type = ui_combobox(group, "\nIndicators type", {"Classic", "Alt"}),
        indic_switch_color = ui_label(group, "Switch Color", {255, 151, 151}),
        hitmarker = ui_checkbox(group, "Hitmarker"),
        hitmarker_f_cl = ui_label(group, "First Color", {0,255,255}),
        hitmarker_s_cl = ui_label(group, "Second Color", {0,255,0}),
        hitlogs = ui_checkbox(group, "Hitlogs"),
        output = ui_multiselect(group, "Display", {"On screen", "Console"}),
        type = ui_multiselect(group, "Type", {"Hit", "Miss", "Nade", "Anti-brute"}),
        bullet_tracer = ui_checkbox(group, "Bullet Tracer", {255, 255, 255}),
        def_indicator = ui_checkbox(group, "Defensive Indicator", {255, 255, 255}),
        velocity_warning = ui_checkbox(group, "Velocity Warning", {255, 81, 81}),
        space = ui_label(other_group, "\n\n"),
        misc_label = ui_label(other_group, "\v•\r Miscellaneous"),
        misc_label_line = ui_label(other_group, "\a464646CC¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯"),
        aspect_ratio = ui_checkbox(other_group, "Aspect Ratio"),
        aspect_ratio_slider = ui_slider(other_group, "\nAspect Ratio", 50, 200, 100, true, "", 0.01, {
            [133] = "4:3",
            [160] = "16:10",
            [178] = "16:9",
            [150] = "3:2",
            [125] = "5:4"
        }),
        anim_breaker = ui_checkbox(other_group, "Animation Breaker"),
        anim_breaker_selection = ui_multiselect(other_group, "\nAnim Breaker Selection", {"Backward legs", "Freeze legs in air", "Pitch 0"}),
        killsay = ui_checkbox(other_group, "Killsay"),
        killsay_type = ui_combobox(other_group, "\nKillsay type", {"Default", "Ad"}),
        clantag = ui_checkbox(other_group, "Clantag"),
        console_filter = ui_checkbox(other_group, "Console Filter"),
        viewmodel_check = ui_checkbox(other_group, "Viewmodel changer"),
        viewmodel_x = ui_slider(other_group, "X", -100, 200, 10, true, nil, 0.1),
        viewmodel_y = ui_slider(other_group, "Y", -100, 200, 10, true, nil, 0.1),
        viewmodel_z = ui_slider(other_group, "Z", -100, 200, -10, true, nil, 0.1),
        enhance_bt = ui_checkbox(other_group, "Enhance Backtrack"),
        dragging = {
            vel_x = ui_slider(group, "\nX Vel", 0, w, w/2-64),
            vel_y = ui_slider(group, "\nY Vel", 0, h, 350),
            def_x = ui_slider(group, "\nX Defensive", 0, w, w/2-50),
            def_y = ui_slider(group, "\nY Defensive", 0, h, 250),
        }
    },
}

local exclude_el = {
    label_space = true,
    label_sp = true,
    label_tab2 = true,
    label2 = true,
    username_label = true,
    build_label = true,
    label_tab = true,
    label = true,
    tab = true
}

local exclude_ab = {
    main_check = true,
}

local exclude_gen = {
    main_check = true,
    fakelag_check = true,
    fakelag_sp = true,
    fakelag_mode = true,
    fakelag_amount = true,
    fakelag_disablers = true,
}

local tab_names = {
    main = "Main",
    anti_aims = "Anti-Aim",
    settings = "Settings",
    info = "Main"
}
local tab_names_aa = {
    general = "General",
    builder = "Builder",
    anti_brute = "Anti-brute"
}

local aa_builder = {}
local def_ways = {
    90,
    180,
    0,
    -90,
    -180,
    0,
    90
}

local delay_tbl = {
    [-6] = "Always On",
    [0] = "Off"
}
local yaw_offset_tbl = obex_data.build == "Beta" and {"Default", "L/R", "Jitter", "Delayed"} or {"Default", "L/R", "Delayed"}
local config
for i=1, #aa_states do
    aa_builder[i] = {
        enable = ui_checkbox(group, "\v" .. short_names[i] .. " \a5C5C5CFF| \rToggle"),
        pitch = ui_combobox(group, "\v" .. short_names[i] .. ": \rPitch", "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitch_value = ui_slider(group, "\n" .. short_names[i], -90, 90, 0),
        yaw = ui_combobox(group, "\v" .. short_names[i] .. ": \rYaw", "Off", "180", "Spin", "180 Z", "Crosshair"),
        yaw_offset = ui_combobox(group, "\v" .. short_names[i] .. ": \rYaw Offset", yaw_offset_tbl),
        yaw_offset_value = ui_slider(group, "\v" .. short_names[i] .. ": \rOffset\n" .. aa_states[i], -180, 180, 0),
        yaw_left = ui_slider(group, "\v" .. short_names[i] .. ": \rLeft\n" .. aa_states[i], -180, 180, 0),
        yaw_right = ui_slider(group, "\v" .. short_names[i] .. ": \rRight\n" .. aa_states[i], -180, 180, 0),
        yaw_flick_first = ui_slider(group, "\v" .. short_names[i] .. ": \rFrom\n" .. aa_states[i], -180, 180, 0),
        yaw_flick_second = ui_slider(group, "\v" .. short_names[i] .. ": \rTo\n" .. aa_states[i], -180, 180, 0),
        yaw_flick_delay = ui_slider(group, "\v" .. short_names[i] .. ": \rDelay\n" .. aa_states[i], 1, 100),
        yaw_jitter = ui_combobox(group, "\v" .. short_names[i] .. ": \rYaw Jitter", "Off", "Offset", "Center", "Random", "Skitter", "X-Way"),
        yaw_jitter_slider_r = ui_slider(group, "\v" .. short_names[i] .. ": \r Right Jitter", -180, 180, 0),
        yaw_jitter_slider_l = ui_slider(group, "\v" .. short_names[i] .. ": \r Left Jitter", -180, 180, 0),
        x_way_slider = ui_slider(group, "Ways\n" .. short_names[i], 1, 7, 0, 1),
    }
    
    for k = 1, 7 do
        aa_builder[i]["way_" .. k] = ui_slider(group, "[\a6BFFA1FF" .. k .. "\aCDCDCDFF] Way\n" .. aa_states[i], -180, 180, def_ways[k])
    end
    
    aa_builder[i]["body_yaw"] = ui_combobox(group, "\v" .. short_names[i] ..  ": \rBody yaw", "Off", "Opposite", "Jitter", "Static")
    aa_builder[i]["bodyyaw_add"] = ui_slider(group, "\v" .. short_names[i] ..  ": \rFake", -180, 180, 0)
    aa_builder[i]["defensive_aa"] = ui_checkbox(group, "\v" .. short_names[i] .. ": \rDefensive AA")
    aa_builder[i]["defensive_pitch"] = ui_combobox(group, "Pitch\a00000000" .. aa_states[i], "Off", "Down", "Semi-Up", "Up", "Random", "Switch", "Custom")
    aa_builder[i]["defensive_pitch_sw"] = ui_slider(group, "[" .. short_names[i] .. "] Min", -89, 89, 0)
    aa_builder[i]["defensive_pitch_sw2"] = ui_slider(group, "[" .. short_names[i] .. "] Max", -89, 89, 0)
    aa_builder[i]["defensive_pitch_value"] = ui_slider(group, "\nPitch Value" .. short_names[i], -89, 89, 0)
    aa_builder[i]["defensive_yaw_main"] = ui_combobox(group, "Yaw\a00000000" .. aa_states[i], "Spin", "Switch", "Sideways", "Inferno", "Flick", "Random")
    aa_builder[i]["defensive_yaw_sw"] = ui_slider(group, "[" .. short_names[i] .. "] Yaw Min", -180, 180, 0)
    aa_builder[i]["defensive_yaw_sw2"] = ui_slider(group, "[" .. short_names[i] .. "] Yaw Max", -180, 180, 0)
    aa_builder[i]["label_other_sp"] = ui_label(other_group, "\n\n")
    aa_builder[i]["label_other"] = ui_label(other_group, "\v•\r Other")
    aa_builder[i]["label"] = ui_label(other_group, "\a464646CC¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯")
    aa_builder[i]["defensive_state"] = ui_combobox(other_group, "Defensive\a00000000" .. aa_states[i], "None", "Tick", "Force")
    aa_builder[i]["defensive_yaw_delay"] = ui_slider(other_group, "[" .. short_names[i] .. "] Defensive Delay", -6, 10, 0, true, "t", 1, delay_tbl)
    aa_builder[i]["defensive_adaptive_def_delay"] = ui_checkbox(other_group, "Adaptive Defensive Delay\n" .. short_names[i])
    aa_builder[i]["label_other_sp_sp"] = ui_label(main_group, "\n\n")
    aa_builder[i]["aa_import_btn"] = ui_button(main_group, "Import", function() 
        local s, err = pcall(function()  
            local raw = base64.decode(clipboard.get())
            local raw_clean = raw:gsub("null,", ""):gsub("%[%[", "[null,["):gsub("%[%{", "[" .. ("null,"):rep(i-1) .. "{")
            local json_data = json.parse(raw_clean)
            config:load(json_data, 2, i)
        end)
            if s then
                print("AA Imported!")
            else
                print("Invalid Config! [" .. err .. "]")
            end
    end)
    aa_builder[i]["aa_export_btn"] = ui_button(main_group, "Export", function() 
            local config_data = config:save(2, i)
            local s = pcall(function() clipboard.set(base64.encode(json.stringify(config_data))) end)
            if s then
            print("AA state Exported! [" .. aa_states[i] .. "]")
            else
            print("Failed to export [" .. aa_states[i] .. "] state")
            end
    end)
end

config = ui.setup({ui_elements, aa_builder})


local ignored_elements = {
    main_check = true,
    tab = true,
    main_color = true,
}

local aa_refs = {
    leg_movement = ui_reference("AA", "other", "leg movement"),
    main_check = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = {ui_reference("AA", "Anti-aimbot angles", "Pitch")},
    yaw = {ui_reference("AA", "Anti-aimbot angles", "Yaw")},
    yaw_jitter = {ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    aa_yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    body_yaw = {ui_reference("AA", "Anti-aimbot angles", "body yaw")},
    freestanding = {ui_reference("AA", "Anti-aimbot angles", "Freestanding")},
    freestanding_body = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    roll = ui_reference("AA", "Anti-aimbot angles", "Roll"),
    doubletap = ui_reference("RAGE", "aimbot", "Double tap"),
    on_shot = ui_reference("AA", "Other", "On shot anti-aim"),
    slow_walk = ui_reference('aa', 'other', 'Slow motion'),
    duck_assist = ui_reference("RAGE", "Other", "Duck peek assist"),
    edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    fakelag_check = {ui_reference("AA", "Fake lag", "Enabled")},
    fakelag_limit = ui_reference("AA", "Fake lag", "Limit"),
    fakelag_combo = ui_reference("AA", "Fake lag", "Amount"),
    fakelag_var = ui_reference("AA", "Fake lag", "Variance"),
    autostrafer = ui_reference("misc", "movement", "Air strafe"),
    aimbot = ui_reference("RAGE", "Aimbot", "Enabled"),
}

local hide_elements = {
    leg_movement = ui_reference("AA", "other", "leg movement"),
    main_check = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = {ui_reference("AA", "Anti-aimbot angles", "Pitch")},
    yaw = {ui_reference("AA", "Anti-aimbot angles", "Yaw")},
    yaw_jitter = {ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    aa_yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    body_yaw = {ui_reference("AA", "Anti-aimbot angles", "body yaw")},
    freestanding_body = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    freestanding = {ui_reference("AA", "Anti-aimbot angles", "Freestanding")},
    roll = ui_reference("AA", "Anti-aimbot angles", "Roll"),
    fakelag_check = {ui_reference("AA", "Fake lag", "Enabled")},
    fakelag_limit = ui_reference("AA", "Fake lag", "Limit"),
    fakelag_combo = ui_reference("AA", "Fake lag", "Amount"),
    fakelag_var = ui_reference("AA", "Fake lag", "Variance"),
}

local tp_exploit_active = false
local main_funcs = {
    delay_air = 0,
    in_air = function(self)
        local ent = entity_get_local_player()
        local flag = bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1)
        if flag == 1 then
            if self.delay_air < 15 then
            self.delay_air = self.delay_air + 1
            end
        else
            self.delay_air = 0
        end 
        return flag == 0 or self.delay_air < 15
    end,
    create_clantag = function(text)
        local value = {" "}
        for i=1, #text do
            value[#value+1] = text:sub(1, i)
        end
    
        for i=#value-1, 1, -1 do
            value[#value+1] = value[i]
        end
      return value
    end,
    is_warmup = function()
        return entity_get_prop(entity_get_game_rules(), "m_bWarmupPeriod") == 1
    end,
    is_freezetime = function()
        return entity_get_prop(entity_get_game_rules(), "m_bFreezePeriod") == 1
    end,
    crouching_in_air = function(self)
        return self:in_air() and bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 2) == 2
    end,
    in_move = function(_, e)
       return e.in_forward == 1 or e.in_back == 1 or e.in_moveleft == 1 or e.in_moveright == 1
    end,
    last_origin = vector(0,0,0),
    current_state = 1,
    get_aa_state = function(self, e)
        local ent = entity_get_local_player()
        if not ui_elements.main_check.value or not entity_is_alive(ent) then return end
        local state = 1
        local standing = vector(entity_get_prop(ent, "m_vecVelocity")):length2d() < 2
        local origin = vector(entity_get_prop(ent, "m_vecOrigin"))
        local breaking_lc = (self.last_origin - origin):length2dsqr() > 4096
        if e.chokedcommands == 0 then
            self.last_origin = origin
        end
        if self:is_warmup() and aa_builder[10].enable.value then
            state = 10
        elseif tp_exploit_active and aa_builder[11].enable.value then
            state = 11
        elseif breaking_lc and aa_builder[9].enable.value then
            state = 9
        elseif self:crouching_in_air() and aa_builder[5].enable.value then
            state = 5
        elseif self:in_air() and aa_builder[4].enable.value then
            state = 4
        elseif aa_refs.slow_walk.hotkey:get() and aa_builder[6].enable.value then
            state = 6
        elseif e.in_duck == 1 and self:in_move(e) and aa_builder[8].enable.value then
            state = 8
        elseif e.in_duck == 1 and aa_builder[7].enable.value then
            state = 7
        elseif self:in_move(e) and aa_builder[3].enable.value then
            state = 3
        elseif standing and aa_builder[2].enable.value then
            state = 2
        end
        self.current_state = state
        local check = state ~= 1 and true or aa_builder[1].enable.value
        return state, check
    end,
    clamp = function(_, value, minimum, maximum)
        return math_min( math_max( value, minimum ), maximum )
    end,
    lerp = function(self, delta, from, to)
        if from == nil then from = 0 end
        if ( delta > 1 ) then return to end
        if ( delta < 0 ) then return from end
        return from + ( to - from ) * delta
    end,
    smooth_lerp = function(self, time, s, e, no_rounding) 
        if (math_abs(s - e) < 1 or s == e) and not no_rounding then return e end
        local time = self:clamp(globals_frametime() * time * 165, 0.01, 1.0) 
        local value = self:lerp(time, s, e)
        return value 
    end,
    last_sim_time = 0,
    def = 0,
    blocked_types = {
        ["knife"] = true,
        ["c4"] = true,
        ["grenade"] = true,
        ["taser"] = true
    },
    get_weapon_index = function(player)
        local wpn = entity_get_player_weapon(player)
        if wpn == nil then return end
        return entity_get_prop(wpn, "m_iItemDefinitionIndex")
    end,
    get_weapon_struct = function(player)
        local wpn = entity_get_player_weapon(player)
        if wpn == nil then return end
        local wep = weapons[entity_get_prop(wpn, "m_iItemDefinitionIndex")]
        if wep == nil then return end
        return wep
    end,
    can_fire = function(self, ent)
	    local wpn = entity_get_prop(ent, "m_hActiveWeapon")
	    local nextAttack = entity_get_prop(wpn, "m_flNextPrimaryAttack")
	    return nextAttack ~= nil and globals_curtime() >= nextAttack
    end,
    tp_exploit_disable = function(self)
        local ent = entity_get_local_player()
        local players = entity_get_players(true)
        if players ~= nil then
            local wpn_type = self.get_weapon_struct(ent).type
            local lp_pos = vector(entity_get_prop(ent, "m_vecOrigin"))
            for _, enemy in pairs(players) do
                local ent_pos = vector(entity_get_prop(enemy, "m_vecOrigin"))
                if wpn_type == "taser" and ent_pos:dist(lp_pos) <= 130 then
                    return true
                end
            end
        end
    end,
    defensive_state = function(self, delay, entity)
        delay = delay or 0
        local ent = entity_get_local_player()
        if entity == nil and not entity_is_alive(ent) or ( (not aa_refs.doubletap:get() or not aa_refs.doubletap.hotkey:get()) and not ui_elements.anti_aims.general.defensive_on_hs:get() ) or aa_refs.duck_assist:get() then return end
        ent = entity ~= nil and entity or ent
        local tickcount = globals_tickcount()
        local sim_time = toticks(entity_get_prop(ent, "m_flSimulationTime"))
        local diff = sim_time - self.last_sim_time
        if diff < 0 then
            self.def = tickcount + math_abs(diff) - toticks(client_latency())
        end
        self.last_sim_time = sim_time
        if delay <= -6 then return not self:is_freezetime() and not self.blocked_types[self.get_weapon_struct(ent).type] end
        local extra_check = entity ~= nil and true or (not self:is_freezetime() and not self.blocked_types[self.get_weapon_struct(ent).type])
        return self.def > tickcount + delay and extra_check
    end,
    player_connect = function(self, e)
    local lp = entity_get_local_player()
    if client_userid_to_entindex(e.userid) == lp then
       self.def = 0
    end
    end,
    closest_point_on_ray = function(ray_from, ray_to, desired_point)
        local to = desired_point - ray_from
        local direction = ray_to - ray_from
        local ray_length = #direction
        direction = vector(direction.x / ray_length, direction.y / ray_length, direction.z / ray_length)
        local dir = direction.x * to.x + direction.y * to.y + direction.z * to.z
        if dir < 0 then return ray_from end
        if dir > ray_length then return ray_to end
        return vector(ray_from.x + direction.x * dir, ray_from.y + direction.y * dir, ray_from.z + direction.z * dir)
    end,
    rgba_to_hex = function(b, c, d, e) e = e or 255 return string.format('%02x%02x%02x%02x', b, c, d, e) end,
    hex_to_rgba = function(hex) return tonumber('0x' .. hex:sub(1, 2)), tonumber('0x' .. hex:sub(3, 4)), tonumber('0x' .. hex:sub(5, 6)), tonumber('0x' .. hex:sub(7, 8)) or 255 end,
    text_animation = function(self, speed, color1, color2, text)
        local final_text = ''
        local curtime = globals_curtime()
        for i = 0, #text do
            local x = i * 10  
            local wave = math_cos(2 * speed * curtime / 4 + x / 30)
            local color = self.rgba_to_hex(
                self:lerp(self:clamp(wave, 0, 1), color1[1], color2[1]),
                self:lerp(self:clamp(wave, 0, 1), color1[2], color2[2]),
                self:lerp(self:clamp(wave, 0, 1), color1[3], color2[3]),
                color1[4]
            ) 
            final_text = final_text .. '\a' .. color .. text:sub(i, i) 
        end
        
        return final_text
    end,
    color_log = function(self, str)  
        for color_code, message in str:gmatch("(%x%x%x%x%x%x%x%x)([^\aFFFFFFFF]+)") do
            local r, g, b = self.hex_to_rgba(color_code)
            message = message:gsub("\a" .. color_code, "")

            client_color_log(r, g, b, message .. "\0")
        end
        client_color_log(255, 255, 255, " ")
    end,
    doubletap_charged = function()
        if not aa_refs.doubletap.value or not aa_refs.doubletap.hotkey:get() or aa_refs.duck_assist:get() then return end    
        local me = entity_get_local_player()
        if me == nil or not entity_is_alive(me) then return end
        local weapon = entity_get_prop(me, "m_hActiveWeapon")
        if weapon == nil then return end
        local next_attack = entity_get_prop(me, "m_flNextAttack")
        local next_primary_attack = entity_get_prop(weapon, "m_flNextPrimaryAttack")
        if next_attack == nil or next_primary_attack == nil then return end
        next_attack = next_attack + 0.25
        next_primary_attack = next_primary_attack + 0.5
        return next_attack - globals_curtime() < 0 and next_primary_attack - globals_curtime() < 0
    end,
    rectangle_outline = function(x, y, w, h, r, g, b, a, s)
        renderer_rectangle(x, y, w, s, r, g, b, a)
        renderer_rectangle(x, y+h-s, w, s, r, g, b, a)
        renderer_rectangle(x, y+s, s, h-s*2, r, g, b, a)
        renderer_rectangle(x+w-s, y+s, s, h-s*2, r, g, b, a)
    end,
    rounded_rectangle = function(x, y, w, h, r, g, b, a, radius, side)
        y = y + radius
        local data_circle = {
            {x + radius, y, 180},
            side and {} or {x + w - radius, y, 90},
            {x + radius, y + h - radius * 2, 270},
            side and {} or {x + w - radius, y + h - radius * 2, 0},
        }
    
        local data = {
            {x + radius, y, w - radius * 2, h - radius * 2},
            {x + radius, y - radius, w - radius * 2, radius},
            {x + radius, y + h - radius * 2, w - radius * 2, radius},
            {x, y, radius, h - radius * 2},
            side and {} or {x + w - radius, y, radius, h - radius * 2},
        }
    
        for _, data in next, data_circle do
            if data ~= nil then
               renderer_circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
            end
        end

        for _, data in next, data do
            if data ~= nil then
               renderer_rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
            end
        end
    end,
    draw_velocity = function(self,modifier,r,g,b,alpha,x,y)	
        local text_width = renderer_measure_text(nil, ("%s %d%%"):format("Recovery ~ ", modifier*100))
        local iw, ih = warning:measure(nil, 17)
        local rx, ry, rw, rh = x+iw+12, y+17, text_width, 2
        self.rounded_rectangle(x, y, iw+11, rh+ih+5, 21, 21, 21, 255, 5, true)
        self.rounded_rectangle(rx-9, y, rw+16, rh+ih+5, 18, 18, 18, 150, 5)
        renderer_rectangle(rx-6, y, 2, rh+ih+5, 100, 100, 100, 125)
        warning:draw(x+4, y+4, nil, 17, r,g,b, alpha)

        renderer_text(rx+2, y+2, 255, 255, 255, 255, nil, 0, ("%s %d%%"):format("Recovery ~ ", modifier*100))
        
        self.rectangle_outline(rx+1, ry, rw, rh+2, 0, 0, 0, 255, 1)
        renderer_rectangle(rx+2, ry+1, rw-2, rh, 16, 16, 16, 180)
        renderer_rectangle(rx+2, ry+1, math_floor((rw-3)*modifier), rh, r, g, b, 210)
        return iw+rw+20
    end,
    get_desync = function()
        local me = entity_get_local_player()
        return math_max(-60, math_min(60, math_floor((entity_get_prop(me,"m_flPoseParameter", 11) or 0)*120-60+0.5)))
    end,
    viewmodel_changer_func = function()
        if not ui_elements.settings.viewmodel_check.value then return end 
        client_set_cvar("viewmodel_offset_x", ui_elements.settings.viewmodel_x:get()/10) 
        client_set_cvar("viewmodel_offset_y", ui_elements.settings.viewmodel_y:get()/10)
        client_set_cvar("viewmodel_offset_z", ui_elements.settings.viewmodel_z:get()/10) 
    end,
    console_filter_f = function(f)
        local active = ui_elements.settings.console_filter:get() and f ~= true
        cvar.con_filter_enable:set_int(active and 1 or 0)
        cvar.con_filter_text:set_string(active and "inferno" or "")
    end,
    backtrack_f = function(f)
        if obex_data.build ~= "Beta" then return end
        local active = ui_elements.settings.enhance_bt:get() and f ~= true
        cvar.sv_maxunlag:set_int(active and 1 or .2)
    end,
}

local icon = images.load_svg([[
    <svg width="563" height="563" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 563 563"><path style="fill:#ffffff; stroke:none;" d="M153.6 29.9l16-21.3C173.6 3.2 180 0 186.7 0C198.4 0 208 9.6 208 21.3V43.5c0 13.1 5.4 25.7 14.9 34.7L307.6 159C356.4 205.6 384 270.2 384 337.7C384 434 306 512 209.7 512H192C86 512 0 426 0 320v-3.8c0-48.8 19.4-95.6 53.9-130.1l3.5-3.5c4.2-4.2 10-6.6 16-6.6C85.9 176 96 186.1 96 198.6V288c0 35.3 28.7 64 64 64s64-28.7 64-64v-3.9c0-18-7.2-35.3-19.9-48l-38.6-38.6c-24-24-37.5-56.7-37.5-90.7c0-27.7 9-54.8 25.6-76.9z"/></svg>
]])

local notification = (function(self)
    local notification = {}
    local notif = {callback_created = false, max_count = 5}
    notif.register_callback = function(self)
    if self.callback_created then return end
    local screen_x, screen_y = client_screen_size()
    local pos = {x = screen_x / 2, y = screen_y / 1.2}
    client_set_event_callback("paint_ui", function()
    local extra_space = 0
    for i = #notification, 1, -1 do
    local data = notification[i]
    if data == nil then return end
    if data.alpha < 1 and data.real_time + data.time < globals_realtime() then
        table.remove(notification, i)
    else
        data.alpha = main_funcs:lerp(4 * globals_frametime(), data.alpha, data.real_time + data.time - 0.1 < globals_realtime() and 0 or 255)
        if data.alpha <= 120 then
            data.move = data.move - 0.2
        end
        local text_size_x, text_size_y = renderer_measure_text(nil, data.text)
        local col = data.color
        local img_w, img_h = 32, 36
        local x, y = pos.x-text_size_x/2-img_w/2, pos.y-data.move-extra_space
        local smooth_location = math_floor(data.alpha + .5)/255
        data.text = data.text:gsub("\a(%x%x)(%x%x)(%x%x)(%x%x)", ("\a%%1%%2%%3%02X"):format(data.alpha))
        renderer_rectangle(x, y, text_size_x+img_w+5, img_h/2+7, 20, 20, 20, data.alpha/1.3)    
        renderer_rectangle(x+img_w-7, y, 2, img_h/2+7, 100, 100, 100, data.alpha/2)
        renderer_rectangle(x, y, 2, (img_h/2+7)*smooth_location, col[1], col[2], col[3], data.alpha)
        icon:draw(x+7, y+3, nil, 20, col[1], col[2], col[3], data.alpha)
        renderer_text(x+img_w, y+6, 255, 255, 255, data.alpha, nil, 0, data.text)
        extra_space = extra_space + math_floor(data.alpha/255 * (text_size_y + 23) + .5)
    end
    end
    end)
    self.callback_created = true
    end
    notif.add = function(self, t, txt)
        for i = self.max_count, 2, -1 do notification[i] = notification[i - 1] end
        local col = {ui_elements.main.main_color.color:get()}
        notification[1] = {alpha = 0, text = txt, real_time = globals_realtime(), time = t, move = 0, color = col}
        self:register_callback()
    end
    return notif
end)()

local dragging_fn = function(name, base_x, base_y)
    return (function()
        local a = {}
        local b, menu_open, m_x, m_y, old_m_x, old_m_y, m1_active, old_m1, x, y, dragging, old_dragging
        local p = {__index = {drag = function(self, w, h, ...)
                    local x, y = self:get()
                    local s, t = a.drag(x, y, self.w, self.h, self, ...)
                    if x ~= s or y ~= t then
                        self:set(s, t)
                    end
                    return s, t
                end, set = function(self, x, y)
                    self.x_reference:set(x)
                    self.y_reference:set(y)
                end, get = function(self)
                    self.x_reference:set_visible(false)
                    self.y_reference:set_visible(false)
                    return self.x_reference:get(), self.y_reference:get()
                end, set_w_h = function(self, w, h)
                    self.w = w
                    self.h = h
                end}}
        function a.new(name, ref_x, ref_y)
            return setmetatable({name = name, x_reference = ref_x, y_reference = ref_y, w = 0, h = 0, alpha = 0}, p)
        end
        function a.drag(pos_x, pos_y, w, h, self, C, D)
            if globals_framecount() ~= b then
                menu_open = ui_is_menu_open()
                old_m_x, old_m_y = m_x, m_y
                m_x, m_y = ui_mouse_position()
                old_m1 = m1_active
                m1_active = client_key_state(0x01) == true
                old_dragging = dragging
                dragging = false
                x, y = client_screen_size()
            end
            if menu_open and old_m1 ~= nil then
                w = w + 6
                h = h + 5
                local dragging_value = old_dragging and 1 or 0
                if dragging_value ~= self.alpha then
                self.alpha = main_funcs:lerp(8 * globals_frametime(), self.alpha, dragging_value)
                end
                if self.alpha > 0 then
                renderer_rectangle(0, 0, x, y, 45, 45, 45, self.alpha * 100, 5)
                end
                main_funcs.rounded_rectangle(pos_x, pos_y, w, h, 100, 100, 100, 100, 5)
                if (not old_m1 or old_dragging) and m1_active and old_m_x > pos_x and old_m_y > pos_y and old_m_x < pos_x + w and old_m_y < pos_y + h then
                    dragging = true
                    pos_x, pos_y = pos_x + m_x - old_m_x, pos_y + m_y - old_m_y
                    if not D then
                        pos_x = math_max(0, math_min(x - w, pos_x))
                        pos_y = math_max(0, math_min(y - h, pos_y))
                    end
                end
            end
            return pos_x, pos_y, w, h
        end
        return a
    end)().new(name, base_x, base_y)
end

local handle_ui_elements = function()
ui.traverse(ui_elements, function(element, path)
    if not ignored_elements[path[1]] then
        element:depend(ui_elements.main_check, {ui_elements.tab, tab_names[path[1]]})
    end
end)
ui.traverse(ui_elements.anti_aims, function(element, path)
    if not exclude_el[path[1]] then
        element:depend({ui_elements.anti_aims.tab, tab_names_aa[path[1]]})
    end
end)

ui.traverse(ui_elements.anti_aims.general, function(element, path)
    if not exclude_gen[path[1]] then
        element:depend(ui_elements.anti_aims.general.main_check)
    end
end)

ui.traverse(ui_elements.anti_aims.anti_brute, function(element, path)
    if not exclude_ab[path[1]] then
        element:depend(ui_elements.anti_aims.anti_brute.main_check)
    end
end)
ui_elements.anti_aims.anti_brute.timer_value:depend(ui_elements.anti_aims.anti_brute.timer)
ui.traverse(aa_builder[11], function(el, p)
    el:depend(true, ui_elements.settings.teleport_exploit)
end)
ui.traverse(aa_builder, function(element, path)
    element:depend(ui_elements.main_check, {ui_elements.tab, "Anti-Aim"}, {ui_elements.anti_aims.tab, "Builder"}, {ui_elements.anti_aims.builder.state, aa_states[path[1]]})
end)
ui_elements.anti_aims.general.fakelag_mode:depend(ui_elements.anti_aims.general.fakelag_check)
ui_elements.anti_aims.general.safe_head_wpns:depend(ui_elements.anti_aims.general.safe_head)
ui_elements.anti_aims.general.fakelag_amount:depend(ui_elements.anti_aims.general.fakelag_check)
ui_elements.anti_aims.general.fakelag_disablers:depend(ui_elements.anti_aims.general.fakelag_check)

ui_elements.anti_aims.general.manual_left:depend(ui_elements.anti_aims.general.manual_yaw)
ui_elements.anti_aims.general.manual_right:depend(ui_elements.anti_aims.general.manual_yaw)
ui_elements.anti_aims.general.manual_edge:depend(ui_elements.anti_aims.general.manual_yaw)
ui_elements.anti_aims.general.manual_fs:depend(ui_elements.anti_aims.general.manual_yaw)
ui_elements.anti_aims.general.freestanding_disablers:depend(ui_elements.anti_aims.general.manual_yaw)
ui_elements.anti_aims.general.manual_static:depend(ui_elements.anti_aims.general.manual_yaw)
ui_elements.settings.start_col:depend(ui_elements.settings.watermark)
ui_elements.settings.end_col:depend(ui_elements.settings.watermark)

ui_elements.anti_aims.builder.state:depend({ui_elements.anti_aims.tab, "Builder"})
ui_elements.main.main_color:depend(ui_elements.main_check)
ui_elements.settings.viewmodel_x:depend(ui_elements.settings.viewmodel_check)
ui_elements.settings.viewmodel_y:depend(ui_elements.settings.viewmodel_check)
ui_elements.settings.viewmodel_z:depend(ui_elements.settings.viewmodel_check)
ui_elements.settings.enhance_bt:set_enabled(obex_data.build == "Beta")
ui_elements.settings.output:depend(ui_elements.settings.hitlogs)
ui_elements.settings.type:depend(ui_elements.settings.hitlogs)
ui_elements.settings.better_jump_scout_opt:depend(ui_elements.settings.better_jump_scout)
ui_elements.settings.disable_tp_indic:depend(ui_elements.settings.teleport_exploit)
ui_elements.settings.auto_hideshots_wpns:depend(ui_elements.settings.auto_hideshots)

ui_elements.settings.smart_baim_opts:depend(ui_elements.settings.smart_baim)
ui_elements.settings.smart_baim_wpns:depend(ui_elements.settings.smart_baim)
ui_elements.settings.smart_baim_disablers:depend(ui_elements.settings.smart_baim)

ui_elements.settings.indic_type:depend(ui_elements.settings.indicators)
ui_elements.settings.indic_switch_color:depend(ui_elements.settings.indicators, {ui_elements.settings.indic_type, "Alt"})
ui_elements.settings.hitmarker_f_cl:depend(ui_elements.settings.hitmarker)
ui_elements.settings.hitmarker_s_cl:depend(ui_elements.settings.hitmarker)


ui_elements.settings.anim_breaker_selection:depend(ui_elements.settings.anim_breaker)
ui_elements.settings.aspect_ratio_slider:depend(ui_elements.settings.aspect_ratio)
ui_elements.settings.killsay_type:depend(ui_elements.settings.killsay)

ui_elements.tab:depend(ui_elements.main_check)

for i=1, #aa_states do
    local builder = aa_builder[i]
    ui.traverse(builder, function(element, path)
        if path[1] ~= "enable" then
            element:depend(builder.enable)
        end
    end)
    builder.pitch_value:depend({builder.pitch, "Custom"})
    builder.yaw_flick_second:depend({builder.yaw_offset, "Delayed"})
    builder.yaw_flick_first:depend({builder.yaw_offset, "Delayed"})
    builder.yaw_flick_delay:depend({builder.yaw_offset, "Delayed"})
    builder.yaw_offset_value:depend({builder.yaw_offset, "Default"})
    builder.yaw_left:depend({builder.yaw_offset, function() return builder.yaw_offset.value == "L/R" or builder.yaw_offset.value == "Jitter" end})
    builder.yaw_right:depend({builder.yaw_offset, function() return builder.yaw_offset.value == "L/R" or builder.yaw_offset.value == "Jitter" end})
    builder.x_way_slider:depend({builder.yaw_jitter, "X-Way"})
    builder.yaw_jitter_slider_r:depend({builder.yaw_jitter, function() return builder.yaw_jitter.value ~= "X-Way" and builder.yaw_jitter.value ~= "Off" end})
    builder.yaw_jitter_slider_l:depend({builder.yaw_jitter, function() return builder.yaw_jitter.value ~= "X-Way" and builder.yaw_jitter.value ~= "Off" end})
    builder.bodyyaw_add:depend({builder.body_yaw, "Off", true}, {builder.yaw_offset, function() return builder.yaw_offset.value ~= "Delayed" and builder.yaw_offset.value ~= "Jitter" end})

    builder.defensive_pitch:depend(builder.defensive_aa)
    builder.defensive_pitch_sw:depend(builder.defensive_aa, {builder.defensive_pitch, "Switch"})
    builder.defensive_pitch_sw2:depend(builder.defensive_aa, {builder.defensive_pitch, "Switch"})
    builder.defensive_pitch_value:depend(builder.defensive_aa, {builder.defensive_pitch, "Custom"})
    builder.defensive_yaw_main:depend(builder.defensive_aa)
    builder.defensive_yaw_sw:depend(builder.defensive_aa, {builder.defensive_yaw_main, "Random", true}, {builder.defensive_yaw_main, "Sideways", true})
    builder.defensive_yaw_sw2:depend(builder.defensive_aa, {builder.defensive_yaw_main, "Random", true}, {builder.defensive_yaw_main, "Sideways", true})
    builder.defensive_yaw_delay:depend(builder.defensive_aa, {builder.defensive_adaptive_def_delay, false})
    builder.defensive_adaptive_def_delay:depend(builder.defensive_aa)
    builder.defensive_adaptive_def_delay:set_enabled(obex_data.build == "Beta")
    
    for h=1, 7 do
        aa_builder[i]["way_" .. h]:depend({builder.yaw_jitter, "X-Way"}, {builder.x_way_slider, function() return builder.x_way_slider.value >= h end})
    end
end
end
handle_ui_elements()

local hide_elements_func = function()
    for name, ref in pairs(hide_elements) do
        if ref['ref'] == nil then
            for k, v in pairs(ref) do
                v:set_visible(not ui_elements.main_check.value)
            end
        else
        ref:set_visible(not ui_elements.main_check.value)
        end
     end
     ui.traverse(ui_elements.settings.dragging, function(el)
        el:set_visible(false)
    end)
end


local fs_disablers_funcs = {
fs_disablers = {
    ["Standing"] = function()
        local ent = entity_get_local_player()
        return vector(entity_get_prop(ent, "m_vecVelocity")):length2d() < 2
    end,
    ["Moving"] = function(e) return main_funcs:in_move(e) end,
    ["Slowwalking"] = function() return aa_refs.slow_walk.hotkey:get() end,
    ["In air"] = function(e) return main_funcs:in_air(e) end,
    ["Fakeducking"] = function() return aa_refs.duck_assist:get() end,
    ["Ducking"] = function(e) return e.in_duck == 1 end
},
disable_freestanding = function(self, e)
    if #ui_elements.anti_aims.general.freestanding_disablers.value <= 0 then return end
    for k, name in pairs(ui_elements.anti_aims.general.freestanding_disablers:get()) do
        if self.fs_disablers[name](e) then return true end
    end
end
}

local switch_side = false
local tbl_data = {side = false, yaw_offset = 0, jitter_offset = 0, f_called = false}
local current_stage = 1
local extra_dir = 0
local old_curtime = globals_curtime()
local switch_des = 1
local switch_ticks = 0
local switch_def_delay = false
local exclude_yaw = {
    ["X-Way"] = true
}
local pitch_conv = {
    ["Semi-Up"] = "Custom",
    ["Switch"] = "Custom"
}
local sideways_values = {
    -65,
    63,
    24,
    -46,
    33,
    54,
    -68
}
local conv_wpns = {
    ['knife'] = "Knife",
    ['taser'] = "Zeus"
}
local switch_value = 1

local switch_pending = false
local builder_func = function(e)
    if not ui_elements.main_check.value then return end
    local state, check = main_funcs:get_aa_state(e)
    local lp = entity_get_local_player()
    local builder_state = aa_builder[state]

    ui_elements.anti_aims.general.manual_left:set("On hotkey")
    ui_elements.anti_aims.general.manual_right:set("On hotkey")
    ui_elements.anti_aims.general.manual_forward:set("On hotkey")
    aa_refs.edge_yaw:override(ui_elements.anti_aims.general.manual_edge:get())
    local avoid_active = false
    if ui_elements.anti_aims.general.avoid_backstab.value then
        local players = entity_get_players(true)
        if players ~= nil then
            local lp_pos = vector(entity_get_prop(lp, "m_vecOrigin"))
            for i, enemy in pairs(players) do
                local ent_pos = vector(entity_get_prop(enemy, "m_vecOrigin"))
                local weapon_type = main_funcs.get_weapon_struct(enemy) ~= nil and main_funcs.get_weapon_struct(enemy).type
                if weapon_type == "knife" and 350 >= ent_pos:dist(lp_pos) then
                    avoid_active = true
                end
            end
        end
    end
    local weapon_type = main_funcs.get_weapon_struct(lp) ~= nil and main_funcs.get_weapon_struct(lp).type
    local wpn_selected = conv_wpns[weapon_type] ~= nil and ui_elements.anti_aims.general.safe_head_wpns:get(conv_wpns[weapon_type]) or false
    local safe_head_active = ui_elements.anti_aims.general.safe_head.value and main_funcs:in_air() and wpn_selected

    if not ui_elements.anti_aims.general.manual_yaw.value then
    extra_dir = 0
    old_curtime = globals_curtime()
    aa_refs.freestanding[1]:override(false)
    else
    if ui_elements.anti_aims.general.manual_fs:get() and not fs_disablers_funcs:disable_freestanding(e) then
        aa_refs.freestanding[1]:override(true)
    else
        aa_refs.freestanding[1]:override(false)
    end
    aa_refs.freestanding[1].hotkey:override({"Always on", nil})
    if ui_elements.anti_aims.general.manual_left:get() and old_curtime + 0.2 < globals_curtime() then
        extra_dir = extra_dir == -90 and 0 or -90
        old_curtime = globals_curtime()
    elseif ui_elements.anti_aims.general.manual_right:get() and old_curtime + 0.2 < globals_curtime() then
        extra_dir = extra_dir == 90 and 0 or 90
        old_curtime = globals_curtime()
    elseif ui_elements.anti_aims.general.manual_forward:get() and old_curtime + 0.2 < globals_curtime() then
        extra_dir = extra_dir == 180 and 0 or 180
        old_curtime = globals_curtime()
    elseif old_curtime > globals_curtime() then
        old_curtime = globals_curtime()
    end
    end
    if builder_state == nil then return end
    if not builder_state.enable.value or safe_head_active then
    aa_refs.yaw[1]:override("180")
    aa_refs.yaw[2]:override(avoid_active and 180 or extra_dir)
    if safe_head_active then
        aa_refs.pitch[1]:override("down")
        aa_refs.aa_yaw_base:override("At targets")
        aa_refs.yaw_jitter[1]:override("Off")
        aa_refs.body_yaw[1]:override("Off")
    end
    end
    if not builder_state.enable.value or not check or safe_head_active then return end
    local ticks = globals_tickcount()
    local yaw_jitter = builder_state.yaw_jitter.value
    local def_yaw = exclude_yaw[yaw_jitter] and "Center" or yaw_jitter
    if (builder_state.yaw_jitter.value == "X-Way" and ticks % 3 > 1) then
        local max_value = builder_state.x_way_slider.value
        if max_value <= 1 then return end
        current_stage = current_stage + 1
        if current_stage > max_value then current_stage = 1 end
    end

    local offset, jitter_offset = tbl_data.yaw_offset, tbl_data.jitter_offset
    local yaw_val
    local force_static = (extra_dir ~= 0 and ui_elements.anti_aims.general.manual_static.value)

    if builder_state.yaw_offset.value == "Default" then
        yaw_val = builder_state.yaw_offset_value.value
    elseif builder_state.yaw_offset.value == "L/R" then
        yaw_val = main_funcs.get_desync() > 0 and builder_state.yaw_right.value or builder_state.yaw_left.value
    elseif builder_state.yaw_offset.value == "Jitter" then
        local random_num = client.random_int(1, 2)

        if switch_ticks >= 2 and switch_des == random_num then
            switch_ticks, switch_des = 0, random_num == 1 and 2 or 1
        else
            switch_des = random_num
        end
        if e.command_number % switch_des == 1 then
            switch_side = not switch_side
            switch_ticks = switch_ticks + 1
        end
        yaw_val = switch_side and builder_state.yaw_right.value or builder_state.yaw_left.value
    elseif builder_state.yaw_offset.value == "Delayed" then
        if e.command_number % (builder_state.yaw_flick_delay.value+2) == 1 then
            switch_pending = true
        end
        if e.chokedcommands == 0 and switch_pending then 
            switch_side = not switch_side
            switch_pending = false
        end
        yaw_val = switch_side and builder_state.yaw_flick_second.value or builder_state.yaw_flick_first.value
    end
    yaw_val = force_static and extra_dir or (yaw_val+extra_dir+offset > 180 or yaw_val+extra_dir+offset < -180) and yaw_val or yaw_val+extra_dir+offset

    if builder_state.defensive_state.value == "Force" then
        e.force_defensive = true
    elseif builder_state.defensive_state.value == "Tick" then
        e.force_defensive = e.command_number % 3 ~= 1 or e.weaponselect ~= 0 or e.quick_stop == 1
    end
    local def_delay = builder_state.defensive_yaw_delay.value
    if builder_state.defensive_adaptive_def_delay.value then
        def_delay = switch_def_delay and 1 or 0
    end
    if builder_state.defensive_aa.value and main_funcs:defensive_state(def_delay) then
        local defensive_speed = builder_state.defensive_yaw_sw.value

        aa_refs.pitch[1]:override(pitch_conv[builder_state.defensive_pitch.value] or builder_state.defensive_pitch.value)
        local pitch_value =  builder_state.defensive_pitch_value.value
        if builder_state.defensive_pitch.value == "Semi-Up" or builder_state.defensive_pitch.value == "Custom" then 
            pitch_value = builder_state.defensive_pitch.value == "Semi-Up" and -60 or builder_state.defensive_pitch_value.value
        elseif builder_state.defensive_pitch.value == "Switch" then
           pitch_value = ticks % 8 >= 4 and builder_state.defensive_pitch_sw2.value or builder_state.defensive_pitch_sw.value
        end
        aa_refs.pitch[2]:override(pitch_value)

        aa_refs.yaw[1]:override(avoid_active and "180" or (builder_state.defensive_yaw_main.value ~= "Spin" and builder_state.yaw.value or builder_state.defensive_yaw_main.value))

        if builder_state.defensive_yaw_main.value == "Switch" then 
            defensive_speed = e.command_number % 6 > 3 and builder_state.defensive_yaw_sw2.value or builder_state.defensive_yaw_sw.value 
        elseif builder_state.defensive_yaw_main.value == "Flick" then
            defensive_speed = ticks % 8 == 0 and builder_state.defensive_yaw_sw2.value or builder_state.defensive_yaw_sw.value
        elseif builder_state.defensive_yaw_main.value == "Sideways" then
            defensive_speed = sideways_values[switch_value]
            switch_value = switch_value >= #sideways_values and 1 or switch_value + 1
        elseif builder_state.defensive_yaw_main.value == "Inferno" then
            defensive_speed = e.command_number % 6 > 3 and 111 or -111
        elseif builder_state.defensive_yaw_main.value == "Random" then
            defensive_speed = client_random_int(-180, 180)
        end
        aa_refs.yaw[2]:override(avoid_active and 180 or defensive_speed)
    else
        aa_refs.pitch[1]:override(builder_state.pitch.value)
        if builder_state.pitch.value == "Custom" then aa_refs.pitch[2]:override(builder_state.pitch_value.value) end
        
        aa_refs.yaw[1]:override(avoid_active and "180" or builder_state.yaw.value)
        if builder_state.yaw_offset.value == "Delayed" or builder_state.yaw_offset.value == "Jitter" then
        if e.chokedcommands == 0 then
            aa_refs.yaw[2]:override(avoid_active and 180 or yaw_val)
        end
        else
           aa_refs.yaw[2]:override(avoid_active and 180 or yaw_val)
        end

    end
    aa_refs.yaw_jitter[1]:override(force_static and "Off" or def_yaw)
    aa_refs.aa_yaw_base:override(ui_elements.anti_aims.general.yaw_base.value)

    local yaw_jit = anti_aims.get_desync(1) <= 0 and builder_state.yaw_jitter_slider_r.value or builder_state.yaw_jitter_slider_l.value
    local x_way_value = aa_builder[state]["way_" .. current_stage].value+jitter_offset
    x_way_value = (x_way_value > 180 or x_way_value < -180) and aa_builder[state]["way_" .. current_stage].value or x_way_value

    aa_refs.yaw_jitter[2]:override(yaw_jitter == "X-Way" and x_way_value or yaw_jit)
    
    aa_refs.body_yaw[1]:override(force_static and "Static" or builder_state.body_yaw.value)
    local body_yaw_value = tbl_data.swap and -builder_state.bodyyaw_add.value or builder_state.bodyyaw_add.value
    if (builder_state.yaw_offset.value == "Delayed" or builder_state.yaw_offset.value == "Jitter") and e.chokedcommands == 0 then
        aa_refs.body_yaw[2]:override(force_static and -180 or ui.get(aa_refs.yaw[2].ref))
    else
        aa_refs.body_yaw[2]:override(force_static and -180 or body_yaw_value)
    end
end

local classnames = {
    ["CWorld"] = true,
    ["CCSPlayer"] = true,
    ["CFuncBrush"] =  true
}

local general_aa = {
    on_use_aa = function(e)
        if not ui_elements.main_check.value or not ui_elements.anti_aims.general.on_use_aa.value or e.chokedcommands ~= 0 then return end
        local lp = entity_get_local_player()
        local team_num = entity_get_prop(lp, "m_iTeamNum")
        local on_bombsite = entity_get_prop(lp, "m_bInBombZone") ~= 0
        local ex, ey, ez = client_eye_position()
        local p, y = client_camera_angles()

        local planting = on_bombsite and team_num == 2 and main_funcs.get_weapon_struct(lp) ~= nil and main_funcs.get_weapon_struct(lp).type
        local sin_pitch, cos_pitch, sin_yaw, cos_yaw = math_sin(math_rad(p)), math_cos(math_rad(p)), math_sin(math_rad(y)), math_cos(math_rad(y))
        local dir_vec = {cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch}
        local fr, ent = client.trace_line(lp, ex, ey, ez, ex + (dir_vec[1] * 8192), ey + (dir_vec[2] * 8192), ez + (dir_vec[3] * 8192)) 
        if fr == 1 or ent == nil or not classnames[entity.get_classname(ent)] or planting then return end
            e.in_use = 0
    end,
    fast_ladder = function(e)
        local ent = entity_get_local_player()
        if not ui_elements.main_check.value or not ui_elements.anti_aims.general.fast_ladder or entity_get_prop(ent, "m_MoveType") ~= 9 then return end
        local pitch = client_camera_angles()
        e.roll = 0
        e.pitch = 89
        local value = pitch < 45 and e.forwardmove or -e.forwardmove
        if value > 0 then
            e.in_moveright = 1
            e.in_moveleft = 0
            e.in_forward = 0
            e.in_back = 1
            if e.sidemove == 0 then e.yaw = e.yaw + 90 end
            if e.sidemove < 0 then e.yaw = e.yaw + 150 end
            if e.sidemove > 0 then e.yaw = e.yaw + 30 end
        elseif value < 0 then
            e.in_moveleft = 1
            e.in_moveright = 0
            e.in_forward = 1
            e.in_back = 0
            if e.sidemove == 0 then e.yaw = e.yaw + 90 end
            if e.sidemove > 0 then e.yaw = e.yaw + 150 end
            if e.sidemove < 0 then e.yaw = e.yaw + 30 end
        end
    end,
    disablers_tbl = {
        ["Standing"] = function()
           local ent = entity_get_local_player()
           return vector(entity_get_prop(ent, "m_vecVelocity")):length2d() < 2
        end,
        ["Jittering"] = function()
           local offset = aa_refs.yaw_jitter[2]:get()
           local check = aa_refs.yaw_jitter[1]:get() == "Center" and (offset >= 55 or offset <= -55)
           return check
        end,
        ["Ducking"] = function(e)
           return e.in_duck == 1
        end,
    },
    fl_modes_func = function(cmd)
        local mode, amount = ui_elements.anti_aims.general.fakelag_mode.value, ui_elements.anti_aims.general.fakelag_amount.value
        if mode == "Adaptive" then
            aa_refs.fakelag_combo:override("Maximum")
            if main_funcs:in_air() then
                local val = amount < 13 and amount or 13
                aa_refs.fakelag_limit:override(val)
            elseif main_funcs:in_move(cmd) then
                aa_refs.fakelag_limit:override(6)  
            else
                aa_refs.fakelag_limit:override(amount)
            end
            elseif mode == "Random" then
                aa_refs.fakelag_combo:override("Maximum")
                aa_refs.fakelag_limit:override(client_random_int(1, amount))
            else
                aa_refs.fakelag_combo:override(mode)
                aa_refs.fakelag_limit:override(amount)
            end
    end,
    fl_func = function(self, cmd)
        if not ui_elements.anti_aims.general.fakelag_check.value or main_funcs.doubletap_charged() then return end
        if not aa_refs.fakelag_check[1]:get() then aa_refs.fakelag_check[1]:override(true) end
        local disablers = ui_elements.anti_aims.general.fakelag_disablers.value
        if #disablers <= 0 then self.fl_modes_func(cmd) return end
        for k, v in ipairs(disablers) do
        if self.disablers_tbl[v](cmd) then aa_refs.fakelag_check[1]:override(false) return end
            self.fl_modes_func(cmd)
        end
    end
}

local killsay_normal = {
    "1", 
    "I'd tell you to shoot yourself, but I bet your miss", 
    "You should let your chair play, at least it knows how to support.", 
    "The only thing lower than your k/d ratio is your I.Q.", 
    "Did you know sharks only kill 5 people each year? Looks like you got some competition",
    "My knife is well-worn, just like your mother.", 
    "Get the bomb, at least you will carry something this game.", 
    "Options -> How To Play", 
    "My dead dad has better aim than you, it only took him one bullet", 
    "Some babies were dropped on their heads but you were clearly thrown at a wall",
    "I would smack you, but I am against animal abuse"
}

local killsay_ad = {
    "Got rekt by Inferno.lua",
    "𝔾𝕖𝕥 𝕘𝕠𝕠𝕕 𝕘𝕖𝕥 𝕀𝕟𝕗𝕖𝕣𝕟𝕠.𝕝𝕦𝕒",
    "Don't be a pussy go and buy Inferno.lua",
    "1 by Inferno.lua",
    "Just buy Inferno.lua already",
    "Stop using a PASTE, go and buy Inferno.lua",
    "NN Blasted by Inferno.lua",
    "You won't kill me because I use Inferno.lua",
    "$$$ OwNeD By Inferno.lua $$$",
    "Don't be a piece of shit just get Inferno.lua",
    "Too ez for Inferno.lua"
}

local killsay_func = function(e)
   if not ui_elements.main_check.value or not ui_elements.settings.killsay.value then return end
   local ent = entity_get_local_player()
   local victim_userid, attacker_userid = e.userid, e.attacker
   if victim_userid == nil or attacker_userid == nil then
       return
   end
   local attacker_entindex = client_userid_to_entindex(attacker_userid)
   local victim_entindex = client_userid_to_entindex(victim_userid)
   if attacker_entindex ~= ent or not entity_is_enemy(victim_entindex) then 
       return
    end
   local tbl = ui_elements.settings.killsay_type.value == "Default" and killsay_normal or killsay_ad
   client_delay_call(3, function()
       client_exec("say " .. tbl[client_random_int(1, #tbl)])
   end)
end

local clantag, prev_tag = main_funcs.create_clantag("inferno.lua ")
local clantag_func = function()
if not ui_elements.settings.clantag.value then return end
local ent = entity_get_local_player()
local ly = client_latency()
local tickcount = globals_tickcount() + toticks(ly)
local sw = math_floor(tickcount / toticks(0.3))
local tag_cur = clantag[sw % #clantag+1]
if tag_cur ~= prev_tag then
    client_set_clan_tag(tag_cur)
end
prev_tag = tag_cur
end

local clantag_change = function(el,force) if el.value and not force then return end client_set_clan_tag() end

local center = { w/2,h/2 }
local arrows_func = function()
    local ent = entity_get_local_player()
    if not ui_elements.main_check.value or not ui_elements.settings.arrows.value or not entity_is_alive(ent) then return end
    local bodyyaw = anti_aims.get_desync(1)
    local manual_aa1 = extra_dir == 90
    local manual_aa2 = extra_dir == -90
    local r,g,b,a = 110, 110, 110, 255
    local r1,g1,b1,a1 = 129, 142, 255, 255
    
    renderer_triangle(center[1] + 52, center[2], center[1] + 42, center[2] - 5, center[1] + 42, center[2] + 7, manual_aa1 and r or 45, manual_aa1 and g or 45, manual_aa1 and b or 45, manual_aa1 and a or 150)
    renderer_triangle(center[1] - 52, center[2], center[1] - 42, center[2] - 5, center[1] - 42, center[2] + 7, manual_aa2 and r or 45, manual_aa2 and g or 45, manual_aa2 and b or 45, manual_aa2 and a or 150)
 
    renderer_rectangle(center[1] + 38, center[2] - 5, 2, 12, bodyyaw <= -1 and r1 or 45, bodyyaw <= -1 and g1 or 45, bodyyaw <= -1 and b1 or 45, bodyyaw <= -1 and a1 or 150)
    renderer_rectangle(center[1] - 40, center[2] - 5, 2, 12, bodyyaw >= 0 and r1 or 45, bodyyaw >= 0 and g1 or 45, bodyyaw >= 0 and b1 or 45, bodyyaw >= 0 and a1 or 150)
end

local function rgb_based(p)
	local r = 124*2 - 124 * p
	local g = 195 * p
	local b = 13
	return r, g, b
end

local vel = dragging_fn("Velocity", ui_elements.settings.dragging.vel_x, ui_elements.settings.dragging.vel_y)

local velocity_warning = function()
if not ui_elements.main_check.value or not ui_elements.settings.velocity_warning.value then return end
local ent = entity_get_local_player()
local modifier = entity_get_prop(ent, "m_flVelocityModifier") or 1
local r, g, b = ui_elements.settings.velocity_warning.color:get()
local menu = ui_is_menu_open()
local x, y = vel:get()
vel:drag()
if modifier == 1 or not entity_is_alive(ent) then if menu then local w = main_funcs:draw_velocity(0.5, r, g, b, 255, x+3, y+3) vel:set_w_h(w, 25) end return end
local w = main_funcs:draw_velocity(modifier, r, g, b, 255, x+3, y+3)
vel:set_w_h(w, 25)
end

local defensive = dragging_fn("Defensive", ui_elements.settings.dragging.def_x, ui_elements.settings.dragging.def_y)
local alpha, length = 0, 0
local defensive_indicator = function()
    if not ui_elements.main_check.value or not ui_elements.settings.def_indicator.value then return end
        local x, y = defensive:get()
        local r, g, b, a = ui_elements.settings.def_indicator.color:get()
        defensive:drag()
        defensive:set_w_h(95, 20)
        local ent = entity_get_local_player()
        local menu = ui_is_menu_open()
        alpha = menu and 1 or main_funcs:clamp(alpha + (globals_tickcount() <= main_funcs.def and 1 * globals_frametime() or -1 * globals_frametime()), 0, 1)
        local defensive_active = main_funcs:defensive_state(main_funcs.current_state ~= nil and aa_builder[main_funcs.current_state].defensive_yaw_delay.value or 0)
        if defensive_active or menu then
        length = defensive_active and main_funcs:lerp(4 * globals_frametime(), length, (main_funcs.last_sim_time-globals_tickcount())*-1) or 8.2
        length = length > 16 and 16 or length
        local hex = main_funcs.rgba_to_hex(r,g,b,255)
        local offset_x, offset_y = 3, 2
        renderer_text(x+offset_x+2, y+offset_y, 255, 255, 255, 255, nil, 0, "defensive: \a" .. hex .. "choking")
        main_funcs.rectangle_outline(x+offset_x, y+offset_y+14, 95, 5, 0, 0, 0, 255, 1)
        renderer_rectangle(x+offset_x+1, y+offset_y+15, 93, 3, 16, 16, 16, 180)
        renderer_rectangle(x+offset_x+1, y+offset_y+15, (length*6)-3, 3, r, g, b, a)
    end
end

local watermark_func = function()
    if not ui_elements.main_check.value or not ui_elements.settings.watermark.value then return end
    local start, en = ui_elements.settings.start_col.color.value, ui_elements.settings.end_col.color.value
    local text = main_funcs:text_animation(5, start, en, "I N F E R N O . L U A")
    renderer_text(w/2, h-25, 255, 255, 255, 255, 'c', 0, text .. (obex_data.build == "Beta" and "  \aE25252FF[" .. obex_data.build:upper() .. "]" or ""))
end

local hitmarker = {
queue = {},
aim_fire_f = function(self, e)
    self.queue[globals_tickcount()] = {e.x, e.y, e.z, globals_curtime() + 2}
end,
render_func = function(self)
    if not ui_elements.main_check.value or not ui_elements.settings.hitmarker.value then return end
    for tick, data in pairs(self.queue) do
        if globals_curtime() <= data[4] then
            local x1, y1 = renderer_world_to_screen(data[1], data[2], data[3])
            if x1 ~= nil and y1 ~= nil then
            renderer_line(x1 - 6, y1, x1 + 6, y1, ui_elements.settings.hitmarker_f_cl.color:get())
            renderer_line(x1, y1 - 6, x1, y1 + 6, ui_elements.settings.hitmarker_s_cl.color:get())
            end
        else
            table.remove(self.queue, tick)
        end
    end
end,
}

local tracer = {
queue = {},
bullet_impact_f = function(self, e)
    if client_userid_to_entindex(e.userid) ~= entity_get_local_player() then return end
    local lx, ly, lz = client_eye_position()
    self.queue[globals_tickcount()] = {lx, ly, lz, e.x, e.y, e.z, globals_curtime() + 2}
end,
render_func = function(self)
    if not ui_elements.main_check.value or not ui_elements.settings.bullet_tracer.value then return end
    for tick, data in pairs(self.queue) do
        if globals_curtime() <= data[7] then
            local x1, y1 = renderer_world_to_screen(data[1], data[2], data[3])
            local x2, y2 = renderer_world_to_screen(data[4], data[5], data[6])
            if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
                renderer_line(x1, y1, x2, y2, ui_elements.settings.bullet_tracer.color:get())
            end
        else
            table.remove(self.queue, tick)
        end
    end
end
}

local func = function() end
local function func_switcher(v)
  return setmetatable({v}, {
    __call = function (tbl, func)
      local check = #tbl == 0 and  {} or tbl[1]
      return (func[check] or func[func] or {})(check)
    end
 })
end

local indicator_tbl = {
    {
        value = false,
        custom_name = '',
        custom_color = {255, 255, 255},
        alpha = 0
    },
    {
        reference = ui_reference("RAGE", "aimbot", "Double tap").hotkey,
        custom_name = 'DT',
        custom_color = {255, 255, 255},
        alpha = 0
    },
    {
        reference = ui_reference('aa', 'other', 'On shot anti-aim').hotkey,
        custom_name = {'ON-SHOT', "HS"},
        custom_color = {170, 255, 100},
        alpha = 0
    },
    {
        reference = ui_reference('rage', 'aimbot', 'Minimum damage override').hotkey,
        custom_name = 'MD',
        custom_color = {255, 255, 255},
        alpha = 0
    },
    {
        reference = ui_reference('rage', 'aimbot', 'Force safe point'),
        custom_name = 'SAFE',
        custom_color = {241, 218, 255},
        alpha = 0
    },
    {
        reference = ui_reference('rage', 'aimbot', 'Force body aim'),
        custom_name = 'BAIM',
        custom_color = {255, 82, 82},
        alpha = 0
    },
    {
        reference = ui_reference('rage', 'other', 'Duck peek assist'),
        custom_name = 'DUCK',
        custom_color = {240, 240, 240},
        alpha = 0
    },
    {
        reference = ui_reference('aa', 'anti-aimbot angles', 'Freestanding'),
        custom_name = 'FS',
        custom_color = {240, 240, 240},
        alpha = 0
    }
}

local extra_x = 28

local text_flags, text_flags_def = "-", "c-"
local indicators = function()
    local ent = entity_get_local_player()
    if not ui_elements.main_check.value or not ui_elements.settings.indicators.value or not entity_is_alive(ent) then return end
    local extra_space = 18
    local r, g, b, a = ui_elements.main.main_color.color:get()
    local scoped = entity_get_prop(ent, "m_bIsScoped") == 1
    local speed = 9 * globals_frametime()
    local offset = 30
    if ui_elements.settings.indic_type.value == "Alt" then offset = 22 end
    extra_x = main_funcs:smooth_lerp(0.07, extra_x, scoped and offset or 0)
    func_switcher(ui_elements.settings.indic_type.value) {
        ["Classic"] = function()
            renderer_text(center[1] + extra_x, center[2] + extra_space, r, g, b, a, "cb-", 0, "inferno.lua")
            extra_space = extra_space + 9

            local dt_charged = main_funcs.doubletap_charged()
            indicator_tbl[1].value = true
            indicator_tbl[1].custom_name = ("-%s-"):format(indicator_names[main_funcs.current_state]:upper())
            indicator_tbl[1].custom_color = {r, g, b}
            indicator_tbl[2].custom_color = {main_funcs:lerp(speed, indicator_tbl[2].custom_color[1], dt_charged and 121 or 230), main_funcs:lerp(speed, indicator_tbl[2].custom_color[2], dt_charged and 255 or 43), main_funcs:lerp(speed, indicator_tbl[2].custom_color[3], dt_charged and 161 or 39)}
        
            for k, v in pairs(indicator_tbl) do
            local check = v.reference ~= nil and v.reference:get() or v.value
            if v.reference ~= nil then
                check = v.reference.hotkey ~= nil and (check and v.reference.hotkey:get()) or check
            end

            if not check then 
                if v.alpha > 0 then 
                    v.alpha = main_funcs:lerp(speed, v.alpha, -0.1) 
                end 
            end
            if check then v.alpha = main_funcs:lerp(speed, v.alpha, 1.1) if v.alpha >= 1 then v.alpha = 1 end end
            if v.alpha > 0 then
                local name = type(v.custom_name) == "table" and v.custom_name[1] or v.custom_name
                local r, g, b = unpack(v.custom_color)
                local text_x = renderer_measure_text(text_flags_def, name)
                renderer_text(center[1] + extra_x, center[2] + extra_space, r, g, b, v.alpha*255, text_flags_def, (text_x*v.alpha)+1, name)

                extra_space = extra_space + math_floor(8 * v.alpha + .5)
            end
            end
        end,
        ["Alt"] = function()
            local r1, g1, b1 = ui_elements.settings.indic_switch_color.color:get()
            renderer_text(center[1] + extra_x, center[2] + extra_space, r, g, b, a, 'c-', 0,  main_funcs:text_animation(5, {r,g,b,a}, {r1, g1, b1, a}, "I N F E R N O"))
            extra_space = extra_space + 3

            local dt_charged = main_funcs.doubletap_charged()

            indicator_tbl[1].value = true
            indicator_tbl[1].custom_name = ("/%s/"):format(indicator_names[main_funcs.current_state]:upper())
            indicator_tbl[1].custom_color = {r, g, b}
            indicator_tbl[2].custom_color = {main_funcs:lerp(speed, indicator_tbl[2].custom_color[1], dt_charged and 121 or 230), main_funcs:lerp(speed, indicator_tbl[2].custom_color[2], dt_charged and 255 or 43), main_funcs:lerp(speed, indicator_tbl[2].custom_color[3], dt_charged and 161 or 39)}
        
            for k, v in pairs(indicator_tbl) do
            local check = v.reference ~= nil and v.reference:get() or v.value
            local name = type(v.custom_name) == "table" and v.custom_name[2] or v.custom_name
            if v.reference ~= nil then
                check = v.reference.hotkey ~= nil and (check and v.reference.hotkey:get()) or check
            end
            local text_x = renderer_measure_text(text_flags, name)
            if v.pos == nil then v.pos = 0 end
            if not check then 
                if v.alpha > 0 then 
                    v.alpha = main_funcs:lerp(speed, v.alpha, -0.1) 
                end 
                if v.alpha <= 0 then
                    v.pos = scoped and -4 or text_x/2
                end 
            end

            if check then v.alpha = main_funcs:lerp(speed, v.alpha, 1.1) if v.alpha >= 1 then v.alpha = 1 end end
            if v.alpha > 0 then
                local r, g, b = unpack(v.custom_color)
                v.pos = scoped and main_funcs:smooth_lerp(0.07, v.pos, -4) or main_funcs:smooth_lerp(0.07, v.pos, text_x/2)
        
                renderer_text(center[1] - v.pos, center[2] + extra_space, r, g, b, v.alpha*255, text_flags, 0, name)

                extra_space = extra_space + math_floor(8 * v.alpha + .5)
            end
            end
        end,
    }
end

local animation_breaker = function()
    local ent = entity_get_local_player()
    if not ui_elements.main_check.value or not ui_elements.settings.anim_breaker.value or #ui_elements.settings.anim_breaker_selection.value <= 0 or not entity_is_alive(ent) then return end
    local _ent = _entity.new(ent)
    if ui_elements.settings.anim_breaker_selection:get("Backward legs") then
    aa_refs.leg_movement:set("Always Slide")
    entity_set_prop(ent, "m_flPoseParameter", 1, 0)
    end
    if ui_elements.settings.anim_breaker_selection:get("Freeze legs in air") and main_funcs:in_air() then
    entity_set_prop(ent, "m_flPoseParameter", 1, 6) 
    end
    if ui_elements.settings.anim_breaker_selection:get("Pitch 0") then
        local anim_state = _ent:get_anim_state()
        if not anim_state.hit_in_ground_animation or main_funcs:in_air() then 
            return 
        end
        entity_set_prop(ent, "m_flPoseParameter", 0.5, 12)
    end
end

local console_log = function(r, g, b, text)
    client_color_log(158, 158, 158, "» \0")
	main_funcs:color_log(text)
end

local last_shot_t = globals_curtime()
local function reset_anti_brute()
    if ui_elements.settings.hitlogs.value and ui_elements.settings.output:get("On screen") and ui_elements.settings.type:get("Anti-brute") then notification:add(5, "Switched anti-bruteforce due to reset") end
    tbl_data = {side = false, yaw_offset = 0, jitter_offset = 0, f_called = false}
    last_shot_t = globals_curtime()
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
local anti_brute_force = {
func = function(e)
local ent = entity_get_local_player()
local tick = globals_curtime()
if not ui_elements.main_check.value or not entity_is_alive(ent) or not ui_elements.anti_aims.anti_brute.main_check.value or #ui_elements.anti_aims.anti_brute.options.value <= 0 or last_shot_t+1 > tick then return end
local user = e.userid
if user == nil then return end
local shooter = client_userid_to_entindex(user)
if entity_is_dormant(shooter) or not entity_is_enemy(shooter) then return end
local bullet_impact = vector(e.x, e.y, e.z)
local eye_pos = vector(entity_get_prop(shooter, "m_vecOrigin"))
eye_pos.z = eye_pos.z + entity_get_prop(shooter, "m_vecViewOffset[2]")
if not eye_pos then
    return
end
local local_eye_pos = vector(client_eye_position())
if not local_eye_pos then
    return
end
local distance = main_funcs.closest_point_on_ray(eye_pos, bullet_impact, local_eye_pos):dist(local_eye_pos)
if distance < 100 then
    last_shot_t = globals_curtime()

    if ui_elements.anti_aims.anti_brute.options:get("Side") then tbl_data.swap = type(tbl_data.swap) ~= "boolean" and true or not tbl_data.swap end
    local num = ui_elements.anti_aims.anti_brute.options:get("Yaw Offset") and client_random_int(-7, 7) or 0
    local num2 = ui_elements.anti_aims.anti_brute.options:get("Jitter Offset") and client_random_int(-5, 5) or 0
    tbl_data.yaw_offset = num
    tbl_data.jitter_offset = num2
    if tbl_data.f_called ~= true then
        if ui_elements.anti_aims.anti_brute.timer.value then client_delay_call(ui_elements.anti_aims.anti_brute.timer_value.value/10, reset_anti_brute) end
        tbl_data.f_called = true
    end
    if ui_elements.settings.hitlogs.value and ui_elements.settings.output:get("On screen") and ui_elements.settings.type:get("Anti-brute") then notification:add(5, "Switched anti-bruteforce due to enemy shot") end
end
end,
reset_on_round_start = function()
    switch_def_delay = not switch_def_delay
    if not ui_elements.main_check.value or not ui_elements.anti_aims.anti_brute.main_check.value then return end
    if ui_elements.settings.hitlogs.value and ui_elements.settings.output:get("On screen") and ui_elements.settings.type:get("Anti-brute") then notification:add(5, "Switched anti-bruteforce due to round start", true) end
    tbl_data = {side = false, yaw_offset = 0, jitter_offset = 0, f_called = false}
    last_shot_t = globals_curtime()
end,
reset_on_death = function(e)
    if not ui_elements.main_check.value or not ui_elements.anti_aims.anti_brute.main_check.value then return end
    local victim, attacker = e.userid, e.attacker
    if victim == nil or attacker == nil then return end
    local ent_victim, ent_attacker = client_userid_to_entindex(victim), client_userid_to_entindex(attacker)
    local ent = entity_get_local_player()
    if ent == ent_victim and ent ~= ent_attacker then
        if ui_elements.settings.hitlogs.value and ui_elements.settings.output:get("On screen") and ui_elements.settings.type:get("Anti-brute") then notification:add(5, "Switched anti-bruteforce due to death") end
        tbl_data = {side = false, yaw_offset = 0, jitter_offset = 0, f_called = false}
        last_shot_t = globals_curtime()
    end
end,
reset_on_unsafe_shot = function(e)
    if not ui_elements.main_check.value or not ui_elements.anti_aims.anti_brute.main_check.value then return end
    local group = hitgroup_names[e.hitgroup + 1] ~= "generic" and hitgroup_names[e.hitgroup + 1] ~= "left arm" and hitgroup_names[e.hitgroup + 1] ~= "right arm" and hitgroup_names[e.hitgroup + 1] ~= "neck"
    if group then return end
    if ui_elements.settings.hitlogs.value and ui_elements.settings.output:get("On screen") and ui_elements.settings.type:get("Anti-brute") then notification:add(5, "Switched anti-bruteforce due to an unsafe shot") end
    tbl_data = {side = false, yaw_offset = 0, jitter_offset = 0, f_called = false}
    last_shot_t = globals_curtime()
end,
}

local current_value, old_val = ui_elements.settings.aspect_ratio_slider:get()/100
local aspect_ratio = {
main_f = function()
if not ui_elements.settings.aspect_ratio:get() or ("%.2f"):format(current_value) == ("%.2f"):format(ui_elements.settings.aspect_ratio_slider:get()/100) then return end
    current_value = main_funcs:smooth_lerp(0.05, current_value, ui_elements.settings.aspect_ratio_slider:get()/100, true)
    client_set_cvar("r_aspectratio", current_value)
end,
change = function()if ui_elements.settings.aspect_ratio:get() then client_set_cvar("r_aspectratio", current_value) return end;client_set_cvar("r_aspectratio", 0);current_value = ui_elements.settings.aspect_ratio_slider:get()/100;end
}

local smart_baim = {
    weapon_enabled = function(wpn_struct)
        local weapon_name_tbl = {
            ["SSG 08"] = "Scout",
            ["SCAR-20"] = "Scar",
            ["G3SG1"] = "Scar",
            ["R8 Revoler"] = "R8 Revolver",
            ["AWP"] = "AWP",
            ["Desert Eagle"] = "Deagle"
        }
        local weapons_type_tbl = {
            ["shotgun"] = "Shotgun"
        }
        local check = weapons_type_tbl[wpn_struct.type] ~= nil and ui_elements.settings.smart_baim_wpns:get(weapons_tbl[wpn_struct.type])
        local check2 = weapon_name_tbl[wpn_struct.name] ~= nil and ui_elements.settings.smart_baim_wpns:get(weapon_name_tbl[wpn_struct.name])
        return check or check2
    end,
    is_lethal = function(self, player)
        local local_player = entity_get_local_player()
        if local_player == nil or not entity_is_alive(local_player) then return end
        local local_origin = vector(entity_get_prop(local_player, "m_vecAbsOrigin"))
        local distance = local_origin:dist(vector(entity.get_prop(player, "m_vecOrigin")))
        local enemy_health = entity.get_prop(player, "m_iHealth")
    
        local weapon_struct = main_funcs.get_weapon_struct(local_player)
        if weapon_struct == nil or not self.weapon_enabled(weapon_struct) then return end
    
        local dmg_after_range = (weapon_struct.damage * math.pow(weapon_struct.range_modifier, (distance * 0.002))) * 1.25
        local armor = entity_get_prop(player,"m_ArmorValue")
        local newdmg = dmg_after_range * (weapon_struct.armor_ratio * 0.5)
        if dmg_after_range - (dmg_after_range * (weapon_struct.armor_ratio * 0.5)) * 0.5 > armor then
            newdmg = dmg_after_range - (armor / 0.5)
        end
        return newdmg >= enemy_health
    end,
    enemy_def_active = function(self, player)
        local p, y = entity_get_prop(player, "m_angEyeAngles")
        return p <= 0 and main_funcs:defensive_state(0, player)
    end,
    can_hit_body = function(player)
        local hitboxes = {2,3,4,5}
        local lp = entity_get_local_player()
        local eye_x, eye_y, eye_z = client_eye_position()
        for k, v in pairs(hitboxes) do
            local x, y, z = entity.hitbox_position(player, v)
            local ent, dmg = client.trace_bullet(lp, eye_x, eye_y, eye_z, x, y, z, false)
            if ent == player and dmg > 1 then return true end
        end
    end,
    baim_active = function(self, ent, cmd)
        local disablers = {
            ["Body Not Hittable"] = function() return not self.can_hit_body(ent) end,
            ["Jump Scouting"] = function() return main_funcs:in_air() and (cmd.in_speed == 1 or not (cmd.in_forward == 1 or cmd.in_back == 1 or cmd.in_moveleft == 1 or cmd.in_moveright == 1 or cmd.in_jump == 1)) end
        }
        local disable = false
        for k, v in pairs(disablers) do
            disable = ui_elements.settings.smart_baim_disablers:get(k) and disablers[k]()
            if disable then break end
        end
        return ui_elements.settings.smart_baim:get() and ( (ui_elements.settings.smart_baim_opts:get("Lethal") and self:is_lethal(ent) and not disable) or ui_elements.settings.smart_baim_opts:get("Defensive AA \aD1AA3DFF[BETA]") and self:enemy_def_active(ent))
    end,
    main_f = function(self, cmd) --override baim
        local enemies = entity.get_players(true)
        for i = 1, #enemies do
            if enemies[i] == nil then return end
            --if self:enemy_def_active(entity_get_local_player()) then print("DEFENSIVE - " .. i) else print("end") end
            local value = self:baim_active(enemies[i], cmd) and "Force" or "-"
            plist.set(enemies[i], "Override prefer body aim", value)
        end
    end,
    disable_f = function()
        local enemies = entity.get_players(true)
        for i = 1, #enemies do
            if enemies[i] == nil then return end
            plist.set(enemies[i], "Override prefer body aim", "-")
        end
    end,
}

client.register_esp_flag("B", 255, 81, 81, function(ent)
    return plist.get(ent, "Override prefer body aim") == "Force"
end)

local weapons_tbl = {
    ["pistol"] = "Pistol",
    ["rifle"] = "Rifle",
    ["smg"] = "SMG",
    ["machinegun"] = "Machinegun",
    ["shotgun"] = "Shotgun"
}

local weapon_name_tbl = {
    ["SSG 08"] = "Scout",
    ["SCAR-20"] = "Scar",
    ["G3SG1"] = "Scar",
}

local cur_cmd_num = 0
local tp_tick = 0
local pre_tick = nil
local tp_turn = false
local rage_settings_module = {
    auto_teleport = function(cmd)
        if not ui_elements.main_check.value or not ui_elements.settings.auto_teleport.value or not ui_elements.settings.auto_teleport.hotkey:get() or not aa_refs.doubletap.value or not aa_refs.doubletap.hotkey:get() then return end
        if main_funcs:in_air() and (cmd.in_forward == 1 or cmd.in_back == 1 or cmd.in_moveleft == 1 or cmd.in_moveright == 1 or cmd.in_jump == 1) then
                local active = false
                local players = entity_get_players(true)
                if players ~= nil then
                    for _, enemy in pairs(players) do
                        local vulnerable = bit_band(entity_get_esp_data(enemy).flags, bit_lshift(1, 11)) == 2048
                        if vulnerable then active = true end
                    end
                end
                if active then
                cmd.force_defensive = true
                if tp_tick >= 14 then
                    tp_turn = true
                end
                if tp_turn and tp_tick == 0 then
                    aa_refs.doubletap:override(false)
                    client.delay_call(0.1, function() aa_refs.doubletap:override(true) end)
                    tp_turn = false
                end
            end
        end
    end,
    auto_teleport_level_init = function()
        pre_tick, cur_cmd_num = nil, 0
    end,
    auto_teleport_run_cmd = function(cmd)
        if not ui_elements.main_check.value or not ui_elements.settings.auto_teleport.value then return end
        cur_cmd_num = cmd.command_number
    end,
    auto_teleport_predict_cmd = function(cmd)
        if not ui_elements.main_check.value or not ui_elements.settings.auto_teleport.value then return end
        if cmd.command_number == cur_cmd_num then
            cur_cmd_num = 0
            local lp = entity_get_local_player()
            local tick_base = entity_get_prop(lp, "m_nTickBase")
    
            if pre_tick ~= nil then
                tp_tick = tick_base - pre_tick
            end
    
            pre_tick = math.max(tick_base, pre_tick or 0)
        end
    end,
    blocked_indexes = {
        [64] = true
    },
    auto_hideshots = function(self, cmd)
        if not ui_elements.main_check.value or not ui_elements.settings.auto_hideshots.value or #ui_elements.settings.auto_hideshots_wpns.value <= 0 then return end
        if tp_exploit_active then aa_refs.on_shot.hotkey:override() return end
        local ent = entity_get_local_player()
        local wpn_struct = main_funcs.get_weapon_struct(ent)
        if wpn_struct == nil then return end
        local check = weapons_tbl[wpn_struct.type] ~= nil and ui_elements.settings.auto_hideshots_wpns:get(weapons_tbl[wpn_struct.type])
        local check2 = weapon_name_tbl[wpn_struct.name] ~= nil and ui_elements.settings.auto_hideshots_wpns:get(weapon_name_tbl[wpn_struct.name])
        if cmd.in_duck == 1 and not main_funcs:in_air() and aa_refs.doubletap.hotkey:get() and (check or check2) and not self.blocked_indexes[main_funcs.get_weapon_index(ent)] then
            aa_refs.on_shot.hotkey:override({"Always on", nil})
            aa_refs.doubletap:override(false)
        else
            aa_refs.doubletap:override(true)
            aa_refs.on_shot.hotkey:override()
        end
    end,
    teleport_exploit_render = function(self)
        if not ui_elements.main_check.value or not ui_elements.settings.teleport_exploit.value or not ui_elements.settings.teleport_exploit.hotkey:get() or ui_elements.settings.disable_tp_indic:get() then return end
        local disabled = main_funcs:tp_exploit_disable()
        renderer_indicator(disabled and 230 or 245, disabled and 43 or 245, disabled and 39 or 245, 255, "TP")
    end,
    teleport_exploit_f = function(self, cmd)
        if not ui_elements.main_check.value or not ui_elements.settings.teleport_exploit.value or not ui_elements.settings.teleport_exploit.hotkey:get() then aa_refs.aimbot:override(true) tp_exploit_active = false return end
        local ent = entity_get_local_player()
        if cmd.in_jump == 1 and aa_refs.doubletap.hotkey:get() and not main_funcs:tp_exploit_disable() then
            aa_refs.doubletap:override(globals_tickcount() % 20 > 1)
            aa_refs.aimbot:override(false)
            tp_exploit_active = true
        else
            aa_refs.aimbot:override(true)
            aa_refs.doubletap:override(true)
            tp_exploit_active = false
        end
    end,
    unsafe_discharge_f = function(self, cmd)
        if not ui_elements.main_check.value or not ui_elements.settings.unsafe_discharge.value or tp_exploit_active then return end
        local ent = entity_get_local_player()
        local threat = client.current_threat()
        if threat == nil then return end
        local wpn_struct = main_funcs.get_weapon_struct(ent)
        local jump_scout = main_funcs:in_air() and (cmd.in_speed == 1 or not (cmd.in_forward == 1 or cmd.in_back == 1 or cmd.in_moveleft == 1 or cmd.in_moveright == 1 or cmd.in_jump == 1))
        local binds = aa_refs.doubletap.hotkey:get() or aa_refs.on_shot.hotkey:get()
        local weapon_can_fire = main_funcs:can_fire(ent) and wpn_struct.type == "knife"
        if (bit.band(entity.get_esp_data(threat).flags, bit.lshift(1, 11)) == 2048) and main_funcs:in_air() and binds and not jump_scout and not weapon_can_fire then
            aa_refs.aimbot:override(false)
        else
            aa_refs.aimbot:override(true)
        end
    end,
    better_jump_scout = function(cmd)
        if not ui_elements.main_check.value or not ui_elements.settings.better_jump_scout.value  or #ui_elements.settings.better_jump_scout_opt.value <= 0 then aa_refs.autostrafer:override() return end
        if cmd.quick_stop and main_funcs:in_air() and (cmd.in_speed == 1 or not (cmd.in_forward == 1 or cmd.in_back == 1 or cmd.in_moveleft == 1 or cmd.in_moveright == 1 or cmd.in_jump == 1)) then
            if ui_elements.settings.better_jump_scout_opt:get("Adjust Strafer") then aa_refs.autostrafer:override(false) end
            if ui_elements.settings.better_jump_scout_opt:get("Crouch") then cmd.in_duck = 1 end
        else
            aa_refs.autostrafer:override()
        end
    end,
    better_jump_scout_disable = function() aa_refs.autostrafer:override() end
}

local steamworks = require "gamesense/steamworks"
local ISteamNetworking = steamworks.ISteamNetworking
local EP2PSend = steamworks.EP2PSend
local js = panorama.open()
local MyPersonaAPI = js.MyPersonaAPI
local GameStateAPI = js.GameStateAPI
local shared_logo = {
    main_f = function()

        steamworks.set_callback("P2PSessionRequest_t", function(request)
            -- ISteamNetworking.CloseP2PSessionWithUser(request.m_steamIDRemote)

            print(request.m_steamIDRemote)
            ISteamNetworking.AcceptP2PSessionWithUser(request.m_steamIDRemote)
            local success, result = ISteamNetworking.GetP2PSessionState(request.m_steamIDRemote)
            print(request.m_steamIDRemote)

        end)
        for player=1, globals.maxplayers() do
            local SteamXUID = GameStateAPI.GetPlayerXuidStringFromEntIndex(player)

            if SteamXUID:len() > 7 and SteamXUID ~= MyPersonaAPI.GetXuid() then
               print(SteamXUID .. "-PRE")
                local target = steamworks.SteamID(SteamXUID)
                local msg = "hello"
                ISteamNetworking.CloseP2PSessionWithUser(target)
                ISteamNetworking.AcceptP2PSessionWithUser(target)
                ISteamNetworking.SendP2PPacket(target, "asdf", 4, EP2PSend.UnreliableNoDelay, 0)
                -- local identity = steamworks.
                -- ISteamNetworking.accept_session_with_user(player)
                -- ISteamNetworking.send_message_to_user(target, "asdb", 4, 8, 1337)
            end
        end
        -- local tbl, s = ISteamNetworking.receive_messages_on_channel(1337, )
        -- for i = 1, tbl do
        --     print(tbl.m_pData == nil)
        --     if s[i - 1][0] and ffi.string(tbl.m_pData) and entity.get(slot7.idx) then
        --         print("YES")
        --     end
        -- end
    end,
    disable_f = function()
        for player=1, globals.maxplayers() do
            local SteamXUID = GameStateAPI.GetPlayerXuidStringFromEntIndex(player)
            if SteamXUID:len() > 7 and SteamXUID ~= MyPersonaAPI.GetXuid() then
                local target = steamworks.SteamID(SteamXUID)
                local success, result = ISteamNetworking.GetP2PSessionState(target)
for k, v in pairs(result) do print(k .. " - " .. tostring(v)) end
                ISteamNetworking.CloseP2PSessionWithUser(target)
            end
        end
    end,
}
-- shared_logo.main_f()
-- client_delay_call(5, function() shared_logo.disable_f() end)
local aim_fire_data = {}
local hitlogs_module = {
    aim_fire = function(e)
    if not ui_elements.main_check.value or not ui_elements.settings.hitlogs.value then return end
        aim_fire_data[e.id] = {
            aimed_hitbox = hitgroup_names[e.hitgroup + 1] or '?',
            pred_dmg = e.damage,
            bt = globals_tickcount()-e.tick > 0 and globals_tickcount()-e.tick or 0
        }
    end,
    aim_hit = function(e)
        if not ui_elements.main_check.value or not ui_elements.settings.hitlogs.value or not ui_elements.settings.type:get("Hit") then return end
        local name = (entity_get_player_name(e.target)):lower()
        local hitgroup = hitgroup_names[e.hitgroup + 1] or '?'
        local health = entity_get_prop(e.target, 'm_iHealth')
        local r, g, b = ui_elements.main.main_color.color:get()
        local hex = main_funcs.rgba_to_hex(r, g, b)
        local hitchance = math_floor(e.hit_chance + 0.5)
        local data = aim_fire_data[e.id]
        if ui_elements.settings.output:get("Console") then 
            local mismatch = hitgroup ~= data.aimed_hitbox and (" [\aB1B1B1FF%s\aFFFFFFFF]"):format(data.aimed_hitbox) or ""
            local under_min_dmg = e.damage ~= data.pred_dmg and (", w_dmg: \a%s%s\aFFFFFFFF"):format(hex, data.pred_dmg) or ""
            console_log(r, g, b, ("\a%sHurt\aFFFFFFFF %s in \a%s%s\aFFFFFFFF%s for \a%s%i\aFFFFFFFF damage (hp: \a%s%i\aFFFFFFFF, bt: \a%s%s\aFFFFFFFF,  hc: \a%s%i\aFFFFFFFF%s)"):format(hex, name, hex, hitgroup, mismatch, hex, e.damage, hex, health, hex, data.bt, hex, hitchance, under_min_dmg))
        end
        if not ui_elements.settings.output:get("On screen") then return end
        notification:add(5, ("\a%sHurt\aFFFFFFFF %s in \a%s%s\aFFFFFFFF for \a%s%i\aFFFFFFFF damage (\a%s%i\aFFFFFFFF health remaining)"):format(hex, name, hex, hitgroup, hex, e.damage, hex, health))
    end,
    aim_miss = function(e)
        if not ui_elements.main_check.value or not ui_elements.settings.hitlogs.value or not ui_elements.settings.type:get("Miss") then return end
        local reason = {
            ["?"] = "resolver"
        }
        local name = (entity_get_player_name(e.target)):lower()
        local hitgroup = hitgroup_names[e.hitgroup + 1] or '?'
        local hitchance = math_floor(e.hit_chance + 0.5)
        local data = aim_fire_data[e.id]
        local r, g, b = ui_elements.main.main_color.color:get()
        local hex = main_funcs.rgba_to_hex(r, g, b)
        if ui_elements.settings.output:get("Console") then
            console_log(r, g, b, ("\a%sMissed\aFFFFFFFF %s's \a%s%s\aFFFFFFFF due to \a%s%s\aFFFFFFFF (dmg: \a%s%i\aFFFFFFFF, bt: \a%s%s\aFFFFFFFF, hc: \a%s%i\aFFFFFFFF)"):format(hex, name, hex, data.aimed_hitbox, hex, reason[e.reason] ~= nil and reason[e.reason] or e.reason, hex, data.pred_dmg, hex, data.bt, hex, hitchance))
        end
        if not ui_elements.settings.output:get("On screen") then return end
        notification:add(5, ("\a%sMissed\aFFFFFFFF %s's \a%s%s\aFFFFFFFF due to \a%s%s\aFFFFFFFF"):format(hex, name, hex, data.aimed_hitbox, hex, reason[e.reason] ~= nil and reason[e.reason] or e.reason))
    end,
    player_hurt = function(e)
        if not ui_elements.main_check.value or not ui_elements.settings.hitlogs.value or not ui_elements.settings.type:get("Nade") then return end
        local weapon_to_verb = { hegrenade = "Naded", inferno = "Burned"}
        local id = client_userid_to_entindex(e.attacker)
        local ent = entity_get_local_player()
        if id == nil or id ~= ent then return end
        local hitgroup = hitgroup_names[e.hitgroup + 1] or '?'
        if hitgroup ~= "generic" or weapon_to_verb[e.weapon] == nil then return end
        local target = client_userid_to_entindex(e.userid)
        local name = (entity_get_player_name(target)):lower()
        local r, g, b = ui_elements.main.main_color.color:get()
        local hex = main_funcs.rgba_to_hex(r, g, b)
        if ui_elements.settings.output:get("Console") then
            console_log(r, g, b, ("\a%s%s\aFFFFFFFF %s for \a%s%i\aFFFFFFFF damage (hp: \a%s%i\aFFFFFFFF)"):format(hex, weapon_to_verb[e.weapon], name, hex, e.dmg_health, hex, e.health))
        end
        if not ui_elements.settings.output:get("On screen") then return end
        notification:add(5, ("\a%s%s\aFFFFFFFF %s for \a%s%i\aFFFFFFFF damage (hp: \a%s%i\aFFFFFFFF)"):format(hex, weapon_to_verb[e.weapon], name, hex, e.dmg_health, hex, e.health))
    end
}

local cfg_manager = function(tbl)
    ui_elements.main.cfg_list:update(tbl)
end
 
local error_func = function()
    print("If this error continues to popup please contact the staff")
end

local config_data = database.read("inferno_cfgs") or {}
local list_tbl = {}

local delay_value = 3
local handle_names = function(_, value, delay)
    local delay = delay or 0
    if value ~= nil then ui_elements.main.selected_cfg:set(value) end
    client_delay_call(delay, function()
        local selected = ui_elements.main.cfg_list:get()+1
        local name = list_tbl[selected] or "-"
        ui_elements.main.selected_cfg:set("Selected Config: \v" .. name)
    end)
end

local config_system = {
    get_cfg_list = function()
        local update_tbl = {}
        for _, data in pairs(cfg_tbl) do
            table.insert(update_tbl, data.name)
            data.data = json.parse(base64.decode(data.data))
        end
        xpcall(function() for name, data in pairs(config_data) do table.insert(update_tbl, name) end end, error_func)

        cfg_manager(update_tbl)
        list_tbl = update_tbl
    end,
    create_btn_callback = function()
        local name = ui_elements.main.cfg_name:get()
        if #name <= 0 then handle_names(nil, "\aFF5151FFERROR: \rCan't use an empty name!", delay_value) return end
        if config_data[name] ~= nil then handle_names(nil, "\aFF5151FFERROR: \rConfig with this name already exists!", delay_value) return end
        
        local list, cfg = list_tbl, config:save()
        list[#list+1] = name
        config_data[name] = cfg
        database.write("inferno_cfgs", config_data)
        cfg_manager(list)
    end,
    save_btn_callback = function()
        local list, selected = list_tbl, ui_elements.main.cfg_list:get()+1
        local sel_name = list[selected]
        if selected > #cfg_tbl then
            config_data[sel_name] = config:save()
            database.write("inferno_cfgs", config_data)
            handle_names(nil, "\v" .. sel_name ..  "\r config has been saved!", delay_value)
        else
            handle_names(nil, "\aFF5151FFERROR: \r" .. sel_name ..  " is a built-in config!", delay_value)
            client.exec("play resource/warning.wav")
        end
        cfg_manager(list)
    end,
    load_btn_callback = function()
        local selected = ui_elements.main.cfg_list:get()+1
        local sel_name = list_tbl[selected]
        local s = pcall(function()
            if selected <= #cfg_tbl then
                config:load(cfg_tbl[selected].data)
            else
                config:load(config_data[sel_name])
            end
        end)
        if s then
            client.exec("play survival/buy_item_01.wav")
            handle_names(nil, "\v" .. sel_name ..  "\r config has been loaded!", delay_value)
        else
            client.exec("play resource/warning.wav")
            handle_names(nil, "\aFF5151FFERROR: \r" .. sel_name ..  " config is broken!", delay_value)
        end
    end,
    del_btn_callback = function()
        local list = list_tbl
        local selected = ui_elements.main.cfg_list:get()+1
        local sel_name = list[selected]
        if #list > 1 and selected > #cfg_tbl then
            table.remove(list, selected)
            config_data[sel_name] = nil
            database.write("inferno_cfgs", config_data)
            handle_names(nil, "\v" .. sel_name ..  "\r config has been deleted!", delay_value)
        else
            handle_names(nil, "\aFF5151FFERROR: \r" .. sel_name ..  " is a built-in config!", delay_value)
        end
        cfg_manager(list)
    end,
    import_callback = function()
        local raw = clipboard.get()
        local s = pcall(function() config:load(json.parse(base64.decode(raw))) end)
        if s then
        notification:add(5, "Config Imported!")
        else
        notification:add(5, "Invalid Config!")
        end
    end,
    export_callback = function()
        local raw = clipboard.get()
        local config_data = config:save()
        local s = pcall(function() clipboard.set(base64.encode(json.stringify(config_data))) end)
        if s then
        notification:add(5, "Config Exported!")
        else
        notification:add(5, "Unknown error!")
        end 
    end,
}
config_system.get_cfg_list()
handle_names()

defer(function()
    aa_refs.freestanding[1].hotkey:override() 
    aa_refs.doubletap:override(true)
    aa_refs.on_shot.hotkey:override()
    aa_refs.aimbot:override(true)
    main_funcs.console_filter_f(true)
    main_funcs.backtrack_f(true)
    clantag_change(ui_elements.settings.clantag,true)
end)

local reset_on_join = function()
    main_funcs.def = 0
    hitmarker.queue = {} 
    tracer.queue = {}
end

client_set_event_callback("setup_command", builder_func)
client_set_event_callback("paint_ui", hide_elements_func)
client_set_event_callback("level_init", reset_on_join)
client_set_event_callback("player_connect_full", function(e) main_funcs:player_connect(e) end)
client_set_event_callback("round_prestart", function() hitmarker.queue = {} tracer.queue = {} end)
ui_elements.anti_aims.general.on_use_aa:set_event("setup_command", general_aa.on_use_aa)
ui_elements.anti_aims.general.fast_ladder:set_event("setup_command", general_aa.fast_ladder)
ui_elements.anti_aims.general.fakelag_check:set_event("setup_command", function(e) general_aa:fl_func(e) end)
ui_elements.settings.auto_teleport:set_event("setup_command", rage_settings_module.auto_teleport)
ui_elements.settings.auto_teleport:set_event("run_command", rage_settings_module.auto_teleport_run_cmd)
ui_elements.settings.auto_teleport:set_event("level_init", rage_settings_module.auto_teleport_level_init)
ui_elements.settings.auto_hideshots:set_event("setup_command", function(cmd) rage_settings_module:auto_hideshots(cmd) end)
ui_elements.settings.teleport_exploit:set_event("setup_command", function(cmd) rage_settings_module:teleport_exploit_f(cmd) end)
ui_elements.settings.unsafe_discharge:set_event("setup_command", function(cmd) rage_settings_module:unsafe_discharge_f(cmd) end)
ui_elements.settings.teleport_exploit:set_event("paint", function(cmd) rage_settings_module:teleport_exploit_render() end)
ui_elements.settings.auto_teleport:set_event("predict_command", rage_settings_module.auto_teleport_predict_cmd)
ui_elements.settings.better_jump_scout:set_event("setup_command", rage_settings_module.better_jump_scout)
ui_elements.settings.better_jump_scout:set_callback(rage_settings_module.better_jump_scout_disable)
ui_elements.settings.smart_baim:set_event("setup_command", function(e) smart_baim:main_f(e) end)
ui_elements.anti_aims.anti_brute.main_check:set_event("bullet_impact", anti_brute_force.func)
ui_elements.anti_aims.anti_brute.conditions:set_event("round_start", anti_brute_force.reset_on_round_start, function(el) return el:get("On Round Start") end)
ui_elements.anti_aims.anti_brute.conditions:set_event("player_death", anti_brute_force.reset_on_death, function(el) return el:get("On Death") end)
ui_elements.anti_aims.anti_brute.conditions:set_event("aim_hit", anti_brute_force.reset_on_unsafe_shot, function(el) return el:get("On unsafe shot") end)


ui_elements.settings.anim_breaker:set_event("pre_render", animation_breaker)
ui_elements.settings.clantag:set_event("paint", clantag_func)
ui_elements.settings.arrows:set_event("paint", arrows_func)
ui_elements.settings.indicators:set_event("paint", indicators)
ui_elements.settings.aspect_ratio:set_event("paint", aspect_ratio.main_f)
ui_elements.settings.velocity_warning:set_event("paint_ui", velocity_warning)
ui_elements.settings.watermark:set_event("paint_ui", watermark_func)
ui_elements.settings.hitmarker:set_event("aim_fire", function(e) hitmarker:aim_fire_f(e) end)
ui_elements.settings.hitmarker:set_event("paint", function() hitmarker:render_func() end)
ui_elements.settings.bullet_tracer:set_event("bullet_impact", function(e) tracer:bullet_impact_f(e) end)
ui_elements.settings.bullet_tracer:set_event("paint", function() tracer:render_func() end)

ui_elements.settings.def_indicator:set_event("paint_ui", defensive_indicator)

ui_elements.settings.killsay:set_event("player_death", killsay_func)

ui_elements.settings.hitlogs:set_event('aim_fire', hitlogs_module.aim_fire)
ui_elements.settings.hitlogs:set_event('aim_hit', hitlogs_module.aim_hit)
ui_elements.settings.hitlogs:set_event('aim_miss', hitlogs_module.aim_miss)
ui_elements.settings.hitlogs:set_event('player_hurt', hitlogs_module.player_hurt)

ui_elements.settings.console_filter:set_callback(main_funcs.console_filter_f)
ui_elements.settings.enhance_bt:set_callback(main_funcs.backtrack_f)
client_delay_call(0.1, function() main_funcs.console_filter_f() main_funcs.viewmodel_changer_func() main_funcs.backtrack_f() end)

ui_elements.settings.viewmodel_check:set_callback(main_funcs.viewmodel_changer_func)
ui_elements.settings.viewmodel_x:set_callback(main_funcs.viewmodel_changer_func)
ui_elements.settings.viewmodel_y:set_callback(main_funcs.viewmodel_changer_func)
ui_elements.settings.viewmodel_z:set_callback(main_funcs.viewmodel_changer_func)
ui_elements.settings.aspect_ratio:set_callback(aspect_ratio.change)
ui_elements.settings.clantag:set_callback(clantag_change)
ui_elements.main.cfg_list:set_callback(handle_names)
ui_elements.main.create_btn:set_callback(config_system.create_btn_callback)
ui_elements.main.import_btn:set_callback(config_system.import_callback)
ui_elements.settings.smart_baim:set_callback(smart_baim.disable_f)
ui_elements.main.export_btn:set_callback(config_system.export_callback)
ui_elements.main.save_btn:set_callback(config_system.save_btn_callback)
ui_elements.main.load_btn:set_callback(config_system.load_btn_callback)
ui_elements.main.del_btn:set_callback(config_system.del_btn_callback)