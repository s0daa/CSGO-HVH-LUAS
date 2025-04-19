local ui = require "gamesense/pui"
local clipboard = (function() local a=require"ffi"local b,tostring,c=string.len,tostring,a.string;local d={}local e=vtable_bind("vgui2.dll","VGUI_System010",7,"int(__thiscall*)(void*)")local f=vtable_bind("vgui2.dll","VGUI_System010",9,"void(__thiscall*)(void*, const char*, int)")local g=vtable_bind("vgui2.dll","VGUI_System010",11,"int(__thiscall*)(void*, int, const char*, int)")local h=a.typeof("char[?]")function d.get()local i=e()if i>0 then local j=h(i)g(0,j,i)return c(j,i-1)end end;d.paste=d.get;function d.set(k)k=tostring(k)f(k,b(k))end;d.copy=d.set;return d end)()
local base64 = (function() local a=require"bit"local b={}local c,d,e=a.lshift,a.rshift,a.band;local f,g,h,i,j,k,tostring,error,pairs=string.char,string.byte,string.gsub,string.sub,string.format,table.concat,tostring,error,pairs;local l=function(m,n,o)return e(d(m,n),c(1,o)-1)end;local function p(q)local r,s={},{}for t=1,65 do local u=g(i(q,t,t))or 32;if s[u]~=nil then error("invalid alphabet: duplicate character "..tostring(u),3)end;r[t-1]=u;s[u]=t-1 end;return r,s end;local v,w={},{}v["base64"],w["base64"]=p("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")v["base64url"],w["base64url"]=p("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")local x={__index=function(y,z)if type(z)=="string"and z:len()==64 or z:len()==65 then v[z],w[z]=p(z)return y[z]end end}setmetatable(v,x)setmetatable(w,x)function b.encode(A,r)r=v[r or"base64"]or error("invalid alphabet specified",2)A=tostring(A)local B,C,D={},1,#A;local E=D%3;local F={}for t=1,D-E,3 do local G,H,I=g(A,t,t+2)local m=G*0x10000+H*0x100+I;local J=F[m]if not J then J=f(r[l(m,18,6)],r[l(m,12,6)],r[l(m,6,6)],r[l(m,0,6)])F[m]=J end;B[C]=J;C=C+1 end;if E==2 then local G,H=g(A,D-1,D)local m=G*0x10000+H*0x100;B[C]=f(r[l(m,18,6)],r[l(m,12,6)],r[l(m,6,6)],r[64])elseif E==1 then local m=g(A,D)*0x10000;B[C]=f(r[l(m,18,6)],r[l(m,12,6)],r[64],r[64])end;return k(B)end;function b.decode(K,s)s=w[s or"base64"]or error("invalid alphabet specified",2)local L="[^%w%+%/%=]"if s then local M,N;for O,P in pairs(s)do if P==62 then M=O elseif P==63 then N=O end end;L=j("[^%%w%%%s%%%s%%=]",f(M),f(N))end;K=h(tostring(K),L,'')local F={}local B,C={},1;local D=#K;local Q=i(K,-2)=="=="and 2 or i(K,-1)=="="and 1 or 0;for t=1,Q>0 and D-4 or D,4 do local G,H,I,R=g(K,t,t+3)local S=G*0x1000000+H*0x10000+I*0x100+R;local J=F[S]if not J then local m=s[G]*0x40000+s[H]*0x1000+s[I]*0x40+s[R]J=f(l(m,16,8),l(m,8,8),l(m,0,8))F[S]=J end;B[C]=J;C=C+1 end;if Q==1 then local G,H,I=g(K,D-3,D-1)local m=s[G]*0x40000+s[H]*0x1000+s[I]*0x40;B[C]=f(l(m,16,8),l(m,8,8))elseif Q==2 then local G,H=g(K,D-3,D-2)local m=s[G]*0x40000+s[H]*0x1000;B[C]=f(l(m,16,8))end;return k(B)end;return b end)()
local images = require "gamesense/images"
local anti_aims = require "gamesense/antiaim_funcs"
local weapons = require "gamesense/csgo_weapons"
local _entity = require "gamesense/entity"
local vector = require "vector"
local renderer_world_to_screen, renderer_line, globals_tickinterval, renderer_cindiator, entity_get_esp_data, bit_lshift, client_set_cvar, renderer_circle, table_insert, client_key_state, ui_mouse_position, globals_framecount, ui_is_menu_open, renderer_triangle, client_color_log, client_exec, entity_get_players, entity_set_prop, client_set_clan_tag, entity_get_player_name, client_camera_angles, math_rad, math_cos, math_sin, ui_hotkey, client_delay_call, client_random_int, client_eye_position, entity_is_enemy, entity_is_dormant, client_userid_to_entindex, globals_curtime, entity_get_player_weapon, client_latency, math_abs, globals_tickcount, entity_get_game_rules, bit_band, entity_get_local_player, entity_get_prop, entity_is_alive, vector, math_min, math_max, renderer_text, renderer_rectangle, math_floor, renderer_measure_text, globals_realtime, globals_frametime, client_screen_size, client_set_event_callback, ui_slider, ui_combobox, ui_checkbox, ui_multiselect, ui_label, ui_reference, ui_listbox, ui_textbox, ui_button = renderer.world_to_screen, renderer.line, globals.tickinterval, renderer.indicator, entity.get_esp_data, bit.lshift, client.set_cvar, renderer.circle, table.insert, client.key_state, ui.mouse_position, globals.framecount, ui.is_menu_open, renderer.triangle, client.color_log, client.exec, entity.get_players, entity.set_prop, client.set_clan_tag, entity.get_player_name, client.camera_angles, math.rad, math.cos, math.sin, ui.hotkey, client.delay_call, client.random_int, client.eye_position, entity.is_enemy, entity.is_dormant, client.userid_to_entindex, globals.curtime, entity.get_player_weapon, client.latency, math.abs, globals.tickcount, entity.get_game_rules, bit.band, entity.get_local_player, entity.get_prop, entity.is_alive, vector, math.min, math.max, renderer.text, renderer.rectangle, math.floor, renderer.measure_text, globals.realtime, globals.frametime, client.screen_size, client.set_event_callback, ui.slider, ui.combobox, ui.checkbox, ui.multiselect, ui.label, ui.reference, ui.listbox, ui.textbox, ui.button


local t_player_models = {
    -- Все модельки за T
    ["Homeless"] = "models/player/custom_player/eminem/gta_sa/Homeless.mdl",
    ["Ballas"] = "models/player/custom_player/eminem/gta_sa/Ballas.mdl",
    ["Barber"] = "models/player/custom_player/eminem/gta_sa/Barber.mdl",
    ["Groove"] = "models/player/custom_player/eminem/gta_sa/Groove.mdl",
    ["Civilian"] = "models/player/custom_player/eminem/gta_sa/Civilian.mdl",
    ["Prostitute"] = "models/player/custom_player/eminem/gta_sa/Prostitute.mdl",
    ["Wuzi"] = "models/player/custom_player/eminem/gta_sa/Wuzi.mdl",
    ["Arctic"] = "models/player/custom_player/eminem/css/Arctic_CSS.mdl",
    ["Urban"] = "models/player/custom_player/eminem/css/Urban_CSS.mdl",
    ["Phoenix"] = "models/player/custom_player/eminem/css/Phoenix_CSS.mdl",
    ["Gign"] = "models/player/custom_player/eminem/css/Gign_CSS.mdl",
    ["AndrewGS"] = "models/player/custom_player/frnchise9812/Andrew_gamesensee.mdl",
    ["AndrewNL"] = "models/player/custom_player/frnchise9812/Andrew_neverlosee.mdl",
    ["Ballas With Hat"] = "models/player/custom_player/kolka/ballas/BallasWithHat.mdl",
    ["Ballas Black & White"] = "models/player/custom_player/frnchise9812/Ballas Black & White.mdl",
    ["OgLoc"] = "models/player/custom_player/legacy/toppi/bew/gta/Ogloc.mdl",
    ["Marci"] = "models/player/custom_player/kolka/marci/Marci.mdl",
    ["Mirana"] = "models/player/custom_player/kolka/mirana/Mirana.mdl",
    ["Neon"] = "models/player/custom_player/kolka/neon/neon.mdl",
    ["Antimage Girl"] = "models/player/custom_player/kolka/antimage_girl/antimage_girl.mdl",
    ["Jett"] = "models/player/custom_player/night_fighter/valorant/jett/jett.mdl",
    ["Lisa"] = "models/player/custom_player/kuristaja/cso2/lisa/lisa.mdl",
    ["Miyu"] = "models/player/custom_player/kuristaja/cso2/miyu_schoolgirl/miyu.mdl",
    ["Hitler"] = "models/player/custom_player/kuristaja/hitler/hitler.mdl",
    ["Cameramen"] = "models/player/custom_player/csgo/cameraman_ported_lev/cameramen.mdl",
    ["Amongus"] = "models/player/custom_player/owston/amongus/white.mdl",
    ["FIB"] = "models/player/custom_player/kirby/kumlafbi/kumlafbi.mdl",
    ["Thug Leet"] = "models/player/custom_player/kirby/leetkumla/leetkumla.mdl",
    ["Tali'Zorah"] = "models/player/custom_player/hekut/talizorah/talizorah.mdl",
    ["GhostFace"] = "models/player/custom_player/kaesar/ghostface/ghostface.mdl",
    ["Gta Blood"] = "models/player/custom_player/z-piks.ru/gta_blood.mdl",
    ["Gta Crip"] = "models/player/custom_player/z-piks.ru/gta_crip.mdl",
    ["Leet Classic"] = "models/player/custom_player/bbs_93x_net_2016/legacy/classics_1337/tm_leet_variant_classic.mdl",
    ["Tommi Verseti"] = "models/player/custom_player/nf/gta/tommi.mdl",
    ["Vector"] = "models/player/custom_player/toppiofficial/reorc/vector_fix1.mdl",
    ["Dark Bom"] = "models/player/custom_player/rabidgames/dark_bom/dark_bom.mdl",
    ["Miku"] = "models/player/custom_player/toppiofficial/vocaloid/yyb/miku_10th_v2.mdl",
    ["Aztec"] = "models/player/custom_player/vla2/vla2.mdl",
    ["Putin"] = "models/player/custom_player/night_fighter/putin/putin.mdl",
    ["Trololo"] = "models/player/custom_player/fantom/troll/troll.mdl",
    ["Scoundrel"] = "models/player/custom_player/caleon1/scoundrel/scoundrel.mdl",  
    ["Reaper"] = "models/player/custom_player/uroboros/the_reaper/the_reaper.mdl",
    ["Whiteout"] = "models/player/custom_player/rabidgames/streetracermale3/whiteout.mdl",
    ["Nitelite"] = "models/player/custom_player/rabidgames/nitelite/nitelite.mdl",
    ["Ninja"] = "models/player/custom_player/rabidgames/ninja/ninja.mdl",
    ["Skye Summer"] = "models/player/custom_player/night_fighter/fortnite/summer_skye/summer_skye.mdl",
    ["Axolotl"] = "models/player/custom_player/night_fighter/fortnite/axolotl/axolotl.mdl",
    ["Bonewasp"] = "models/player/custom_player/canwit/fortnite/bonewasp.mdl",
    ["Velocity"] = "models/player/custom_player/caleon1/velocity/velocity.mdl",
    ["Mezmer"] = "models/player/custom_player/caleon1/mezmer/mezmer.mdl",
    ["Skilet"] = "models/player/custom_player/rabidgames/skilet/skilet.mdl",
    ["Wraith"] = "models/player/custom_player/ventoz/apex/wraith/wraith_default.mdl",

}

local ct_player_models = {
    -- Все модельки за КТ
    ["Homeless"] = "models/player/custom_player/eminem/gta_sa/Homeless.mdl",
    ["Ballas"] = "models/player/custom_player/eminem/gta_sa/Ballas.mdl",
    ["Barber"] = "models/player/custom_player/eminem/gta_sa/Barber.mdl",
    ["Groove"] = "models/player/custom_player/eminem/gta_sa/Groove.mdl",
    ["Civilian"] = "models/player/custom_player/eminem/gta_sa/Civilian.mdl",
    ["Prostitute"] = "models/player/custom_player/eminem/gta_sa/Prostitute.mdl",
    ["Wuzi"] = "models/player/custom_player/eminem/gta_sa/Wuzi.mdl",
    ["Arctic"] = "models/player/custom_player/eminem/css/Arctic_CSS.mdl",
    ["Urban"] = "models/player/custom_player/eminem/css/Urban_CSS.mdl",
    ["Phoenix"] = "models/player/custom_player/eminem/css/Phoenix_CSS.mdl",
    ["Gign"] = "models/player/custom_player/eminem/css/Gign_CSS.mdl",
    ["AndrewGS"] = "models/player/custom_player/frnchise9812/Andrew_gamesensee.mdl",
    ["AndrewNL"] = "models/player/custom_player/frnchise9812/Andrew_neverlosee.mdl",
    ["Ballas With Hat"] = "models/player/custom_player/kolka/ballas/BallasWithHat.mdl",
    ["Ballas Black & White"] = "models/player/custom_player/frnchise9812/Ballas Black & White.mdl",
    ["OgLoc"] = "models/player/custom_player/legacy/toppi/bew/gta/Ogloc.mdl",
    ["Marci"] = "models/player/custom_player/kolka/marci/Marci.mdl",
    ["Mirana"] = "models/player/custom_player/kolka/mirana/Mirana.mdl",
    ["Neon"] = "models/player/custom_player/kolka/neon/neon.mdl",
    ["Antimage Girl"] = "models/player/custom_player/kolka/antimage_girl/antimage_girl.mdl",
    ["Jett"] = "models/player/custom_player/night_fighter/valorant/jett/jett.mdl",
    ["Lisa"] = "models/player/custom_player/kuristaja/cso2/lisa/lisa.mdl",
    ["Miyu"] = "models/player/custom_player/kuristaja/cso2/miyu_schoolgirl/miyu.mdl",
    ["Hitler"] = "models/player/custom_player/kuristaja/hitler/hitler.mdl",
    ["Cameramen"] = "models/player/custom_player/csgo/cameraman_ported_lev/cameramen.mdl",
    ["Amongus"] = "models/player/custom_player/owston/amongus/white.mdl",
    ["FIB"] = "models/player/custom_player/kirby/kumlafbi/kumlafbi.mdl",
    ["Thug Leet"] = "models/player/custom_player/kirby/leetkumla/leetkumla.mdl",
    ["Tali'Zorah"] = "models/player/custom_player/hekut/talizorah/talizorah.mdl",
    ["GhostFace"] = "models/player/custom_player/kaesar/ghostface/ghostface.mdl",
    ["Gta Blood"] = "models/player/custom_player/z-piks.ru/gta_blood.mdl",
    ["Gta Crip"] = "models/player/custom_player/z-piks.ru/gta_crip.mdl",
    ["Leet Classic"] = "models/player/custom_player/bbs_93x_net_2016/legacy/classics_1337/tm_leet_variant_classic.mdl",
    ["Tommi Verseti"] = "models/player/custom_player/nf/gta/tommi.mdl",
    ["Vector"] = "models/player/custom_player/toppiofficial/reorc/vector_fix1.mdl",
    ["Dark Bom"] = "models/player/custom_player/rabidgames/dark_bom/dark_bom.mdl",
    ["Miku"] = "models/player/custom_player/toppiofficial/vocaloid/yyb/miku_10th_v2.mdl",
    ["Aztec"] = "models/player/custom_player/vla2/vla2.mdl",
    ["Putin"] = "models/player/custom_player/night_fighter/putin/putin.mdl",
    ["Trololo"] = "models/player/custom_player/fantom/troll/troll.mdl",
    ["Scoundrel"] = "models/player/custom_player/caleon1/scoundrel/scoundrel.mdl",  
    ["Reaper"] = "models/player/custom_player/uroboros/the_reaper/the_reaper.mdl",
    ["Whiteout"] = "models/player/custom_player/rabidgames/streetracermale3/whiteout.mdl",
    ["Nitelite"] = "models/player/custom_player/rabidgames/nitelite/nitelite.mdl",
    ["Ninja"] = "models/player/custom_player/rabidgames/ninja/ninja.mdl",
    ["Skye Summer"] = "models/player/custom_player/night_fighter/fortnite/summer_skye/summer_skye.mdl",
    ["Axolotl"] = "models/player/custom_player/night_fighter/fortnite/axolotl/axolotl.mdl",
    ["Bonewasp"] = "models/player/custom_player/canwit/fortnite/bonewasp.mdl",
    ["Velocity"] = "models/player/custom_player/caleon1/velocity/velocity.mdl",
    ["Mezmer"] = "models/player/custom_player/caleon1/mezmer/mezmer.mdl",
    ["Skilet"] = "models/player/custom_player/rabidgames/skilet/skilet.mdl",
    ["Wraith"] = "models/player/custom_player/ventoz/apex/wraith/wraith_default.mdl",

}

local function contains(tab, val)
	for i = 1, #tab do
		if tab[i] == val then
			return true
		end
	end
	return false
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local ffi = require("ffi")

ffi.cdef[[
    typedef struct 
    {
    	void*   fnHandle;        
    	char    szName[260];     
    	int     nLoadFlags;      
    	int     nServerCount;    
    	int     type;            
    	int     flags;           
    	float  vecMins[3];       
    	float  vecMaxs[3];       
    	float   radius;          
    	char    pad[0x1C];       
    }model_t;
    
    typedef int(__thiscall* get_model_index_t)(void*, const char*);
    typedef const model_t(__thiscall* find_or_load_model_t)(void*, const char*);
    typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
    typedef void*(__thiscall* find_table_t)(void*, const char*);
    typedef void(__thiscall* set_model_index_t)(void*, int);
    typedef int(__thiscall* precache_model_t)(void*, const char*, bool);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]

local class_ptr = ffi.typeof("void***")

local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(class_ptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

local rawivmodelinfo = client.create_interface("engine.dll", "VModelInfoClient004") or error("VModelInfoClient004 wasnt found", 2)
local ivmodelinfo = ffi.cast(class_ptr, rawivmodelinfo) or error("rawivmodelinfo is nil", 2)
local get_model_index = ffi.cast("get_model_index_t", ivmodelinfo[0][2]) or error("get_model_info is nil", 2)
local find_or_load_model = ffi.cast("find_or_load_model_t", ivmodelinfo[0][39]) or error("find_or_load_model is nil", 2)

local rawnetworkstringtablecontainer = client.create_interface("engine.dll", "VEngineClientStringTable001") or error("VEngineClientStringTable001 wasnt found", 2)
local networkstringtablecontainer = ffi.cast(class_ptr, rawnetworkstringtablecontainer) or error("rawnetworkstringtablecontainer is nil", 2)
local find_table = ffi.cast("find_table_t", networkstringtablecontainer[0][3]) or error("find_table is nil", 2)

local cl_fullupdate = cvar.cl_fullupdate

local model_names = {}
local model_names_ct = {}


local unique_t = {}
local unique_ct = {}


for k, v in pairs(t_player_models) do
    unique_t[k] = true
end


for k, v in pairs(ct_player_models) do
    unique_ct[k] = true
end


for k in pairs(unique_t) do
    table.insert(model_names, k)
end

for k in pairs(unique_ct) do
    table.insert(model_names_ct, k)
end


table.sort(model_names)
table.sort(model_names_ct)


label1 = ui.new_label('LUA', 'A', 'Hello, bassota')
label2 = ui.new_label('LUA', 'A', 'Please pick a model')
label3 = ui.new_label('LUA', 'A', 'https://discord.gg/KtQMfrkjsH')
local model_check = ui.new_multiselect('LUA', 'A', 'Player model picker', {"CT", "T"})
local localplayer_model_ct = ui.new_combobox("LUA", "A", "CT Model", model_names_ct)
local localplayer_model_t = ui.new_combobox("LUA", "A", "T Model", model_names)

local function precache_model(modelname)
    local rawprecache_table = find_table(networkstringtablecontainer, "modelprecache") or error("couldnt find modelprecache", 2)
    if rawprecache_table then 
        local precache_table = ffi.cast(class_ptr, rawprecache_table) or error("couldnt cast precache_table", 2)
        if precache_table then 
            local add_string = ffi.cast("add_string_t", precache_table[0][8]) or error("add_string is nil", 2)

            find_or_load_model(ivmodelinfo, modelname)
            local idx = add_string(precache_table, false, modelname, -1, nil)
            if idx == -1 then 
                return false
            end
        end
    end
    return true
end

local function set_model_index(entity, idx)
    local raw_entity = get_client_entity(ientitylist, entity)
    if raw_entity then 
        local gce_entity = ffi.cast(class_ptr, raw_entity)
        local a_set_model_index = ffi.cast("set_model_index_t", gce_entity[0][75])
        if a_set_model_index == nil then 
            error("set_model_index is nil")
        end
        a_set_model_index(gce_entity, idx)
    end
end

local function change_model(ent, model)
    if model:len() > 5 then 
        if precache_model(model) == false then 
            error("invalid model", 2)
        end
        local idx = get_model_index(ivmodelinfo, model)
        if idx == -1 then 
            return
        end
        set_model_index(ent, idx)
    end
end

local update_skins = true
client.set_event_callback("pre_render", function()
    local me = entity.get_local_player()
    if me == nil then return end

    local team = entity.get_prop(me, 'm_iTeamNum') 

    if (team == 2 and contains(ui.get(model_check), 'T') ) or (team == 3 and contains(ui.get(model_check), 'CT') ) then
		change_model(me, team == 2 and t_player_models[ui.get(localplayer_model_t)] or ct_player_models[ui.get(localplayer_model_ct)] )
    end
end)

client.set_event_callback("paint_ui", function()
    ui.set_visible(localplayer_model_t, contains(ui.get(model_check), 'T'))  
    ui.set_visible(localplayer_model_ct, contains(ui.get(model_check), 'CT'))
end)
