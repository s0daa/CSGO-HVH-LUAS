local surface = require("gamesense/surface") or error("Missing the surface library - https://gamesense.pub/forums/viewtopic.php?id=18793") 
local vector = require("vector")
local bit = require("bit")
local bitband = bit.band
local pui = require("gamesense/pui")
local clipboard = require "gamesense/clipboard"
local base_64 = (function()local a=require"bit"local b={}local c,d,e=a.lshift,a.rshift,a.band;local f,g,h,i,j,k,tostring,error,pairs=string.char,string.byte,string.gsub,string.sub,string.format,table.concat,tostring,error,pairs;local l=function(m,n,o)return e(d(m,n),c(1,o)-1)end;local function p(q)local r,s={},{}for t=1,65 do local u=g(i(q,t,t))or 32;if s[u]~=nil then error("invalid alphabet: duplicate character "..tostring(u),3)end;r[t-1]=u;s[u]=t-1 end;return r,s end;local v,w={},{}v["base64"],w["base64"]=p("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")v["base64url"],w["base64url"]=p("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")local x={__index=function(y,z)if type(z)=="string"and z:len()==64 or z:len()==65 then v[z],w[z]=p(z)return y[z]end end}setmetatable(v,x)setmetatable(w,x)function b.encode(A,r)r=v[r or"base64"]or error("invalid alphabet specified",2)A=tostring(A)local B,C,D={},1,#A;local E=D%3;local F={}for t=1,D-E,3 do local G,H,I=g(A,t,t+2)local m=G*0x10000+H*0x100+I;local J=F[m]if not J then J=f(r[l(m,18,6)],r[l(m,12,6)],r[l(m,6,6)],r[l(m,0,6)])F[m]=J end;B[C]=J;C=C+1 end;if E==2 then local G,H=g(A,D-1,D)local m=G*0x10000+H*0x100;B[C]=f(r[l(m,18,6)],r[l(m,12,6)],r[l(m,6,6)],r[64])elseif E==1 then local m=g(A,D)*0x10000;B[C]=f(r[l(m,18,6)],r[l(m,12,6)],r[64],r[64])end;return k(B)end;function b.decode(K,s)s=w[s or"base64"]or error("invalid alphabet specified",2)local L="[^%w%+%/%=]"if s then local M,N;for O,P in pairs(s)do if P==62 then M=O elseif P==63 then N=O end end;L=j("[^%%w%%%s%%%s%%=]",f(M),f(N))end;K=h(tostring(K),L,'')local F={}local B,C={},1;local D=#K;local Q=i(K,-2)=="=="and 2 or i(K,-1)=="="and 1 or 0;for t=1,Q>0 and D-4 or D,4 do local G,H,I,R=g(K,t,t+3)local S=G*0x1000000+H*0x10000+I*0x100+R;local J=F[S]if not J then local m=s[G]*0x40000+s[H]*0x1000+s[I]*0x40+s[R]J=f(l(m,16,8),l(m,8,8),l(m,0,8))F[S]=J end;B[C]=J;C=C+1 end;if Q==1 then local G,H,I=g(K,D-3,D-1)local m=s[G]*0x40000+s[H]*0x1000+s[I]*0x40;B[C]=f(l(m,16,8),l(m,8,8))elseif Q==2 then local G,H=g(K,D-3,D-2)local m=s[G]*0x40000+s[H]*0x1000;B[C]=f(l(m,16,8))end;return k(B)end;local T={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/","="}local U={"v","u","m","d","2","1","4","p","t","x","c","G","f","6","7","L","Y","C","T","j","O","y","W","F","+","R","w","V","=","9","E","a","U","r","N","P","k","0","o","g","l","M","X","D","e","Q","I","8","q","B","/","i","b","H","A","n","3","J","S","s","K","z","Z","5","h"}local V={}local W={}for t=1,#T do V[T[t]]=U[t]W[U[t]]=T[t]end;function b.encrypt(X)local Y=""local Z=b.encode(X)for t=1,Z:len()do Y=Y..V[Z:sub(t,t)]end;return Y end;function b.decrypt(X)local Y=""for t=1,X:len()do Y=Y..W[X:sub(t,t)]end;return b.decode(Y)end;return b end)()

local client_draw_hitboxes, client_set_event_callback, client_userid_to_entindex, entity_get_local_player, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_slider, ui_set_callback, ui_set_visible = client.draw_hitboxes, client.set_event_callback, client.userid_to_entindex, entity.get_local_player, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.set_callback, ui.set_visible
local color_code = "\aff3e7faa"
local color_code = "\aaafeeeee"
local color_code = "\aff3300ff"
local color_code = "\aFFFB90FF"

local Update = {








}


--REFS
local ref = {
  
    byaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    yaw_jitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},

    edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    Freestand = ui.reference("AA", "Anti-aimbot angles", "Freestanding"),
    yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")},

    ui_limit_ref = ui.reference("AA", "Fake lag", "Limit"),
    ui_fakelag_ref = ui.reference("AA", "Fake lag", "Enabled"),
    ui_amount_ref = ui.reference("AA", "Fake lag", "Amount"),
    ui_Variance_ref = ui.reference("AA", "Fake lag", "Variance"),
    dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
    lg = ui.reference("MISC", "Miscellaneous", "Log damage dealt"),

    clantag = ui.reference("MISC", "Miscellaneous", "Clan tag spammer"),
}	

--MENU

local menu = {


    logging_section_label = ui.new_label( 'LUA', 'B', '\aaafeeeee▁ ▂ ▃ ▄ ▅ ▆ ▇ ▉☠Rambomode-RECODE V2☠▉ ▇ ▆ ▅ ▄ ▃ ▂ ▁ '),

    logging_section_label = ui.new_label( 'LUA', 'B', '                                                  \aFFFB90FFVERSION 1.0'),
    logging_section_label = ui.new_label( 'LUA', 'B', ' '),
    logging_section_label = ui.new_label( 'LUA', 'B', '\aaafeeeee-Recoded The Anti-Aim system and reworked the whole lua'),
    logging_section_label = ui.new_label( 'LUA', 'B', '\aaafeeeee-Knowen issues are some little menü bugs and clantag bugs'),
    logging_section_label = ui.new_label( 'LUA', 'B', ' '),

    logging_section_label = ui.new_label( 'LUA', 'B', '\aaafeeeee--------------------Anti-Aim-------------------- '),



    
    d_aa = ui_new_checkbox("LUA", "B", "\aff3e7faaEnable Rambomode-AA"),
    AA = ui_new_combobox("LUA", "B", "AA-Builder", "Default", "Stand", "Move", "In-Air", "Duck", "Air-Duck"),

    d_jl = ui_new_slider("LUA", "B", "Left", -180, 180, 0, true),
    d_jr = ui_new_slider("LUA", "B", "Right", -180, 180, 0, true),
    d_s = ui_new_slider("LUA", "B", "Jitter-Speed", 3, 60, 3, true),
    BA_d = ui_new_combobox("LUA", "B", "Body-Yaw", "Jitter", "Opposite"),
    BA_ds = ui_new_slider("LUA", "B", "Jitter-Range", -180, 180, 0, true),
    
    s_aa = ui_new_checkbox("LUA", "B", "\aFFFB90FFEnable state Stand"),
    s_jl = ui_new_slider("LUA", "B", "Left", -180, 180, 0, true),
    s_jr = ui_new_slider("LUA", "B", "Right", -180, 180, 0, true),
    s_s = ui_new_slider("LUA", "B", "Jitter-Speed", 3, 60, 3, true),
    BA_s = ui_new_combobox("LUA", "B", "Body-Yaw", "Jitter", "Opposite"),
    BA_ss = ui_new_slider("LUA", "B", "Jitter-Range", -180, 180, 0, true),

    r_aa = ui_new_checkbox("LUA", "B", "\aFFFB90FFEnable state Move"),
    r_jl = ui_new_slider("LUA", "B", "Left", -180, 180, 0, true),
    r_jr = ui_new_slider("LUA", "B", "Right", -180, 180, 0, true),
    r_s = ui_new_slider("LUA", "B", "Jitter-Speed", 3, 60, 3, true),
    BA_r = ui_new_combobox("LUA", "B", "Body-Yaw", "Jitter", "Opposite"),
    BA_rs = ui_new_slider("LUA", "B", "Jitter-Range", -180, 180, 0, true),

    a_aa = ui_new_checkbox("LUA", "B", "\aFFFB90FFEnable state In-Air"),
    a_jl = ui_new_slider("LUA", "B", "Left", -180, 180, 0, true),
    a_jr = ui_new_slider("LUA", "B", "Right", -180, 180, 0, true),
    a_s = ui_new_slider("LUA", "B", "Jitter-Speed", 3, 60, 3, true),
    BA_a = ui_new_combobox("LUA", "B", "Body-Yaw", "Jitter", "Opposite"),
    BA_as = ui_new_slider("LUA", "B", "Jitter-Range", -180, 180, 0, true),

    du_aa = ui_new_checkbox("LUA", "B", "\aFFFB90FFEnable state Duck"),
    du_jl = ui_new_slider("LUA", "B", "Left", -180, 180, 0, true),
    du_jr = ui_new_slider("LUA", "B", "Right", -180, 180, 0, true),
    du_s = ui_new_slider("LUA", "B", "Jitter-Speed", 3, 60, 3, true),
    BA_du = ui_new_combobox("LUA", "B", "Body-Yaw", "Jitter", "Opposite"),
    BA_dus = ui_new_slider("LUA", "B", "Jitter-Range", -180, 180, 0, true),

    dui_aa = ui_new_checkbox("LUA", "B", "\aFFFB90FFEnable state Air-Duck"),
    dui_jl = ui_new_slider("LUA", "B", "Left", -180, 180, 0, true),
    dui_jr = ui_new_slider("LUA", "B", "Right", -180, 180, 0, true),
    dui_s = ui_new_slider("LUA", "B", "Jitter-Speed", 3, 60, 3, true),
    BA_dui = ui_new_combobox("LUA", "B", "Body-Yaw", "Jitter", "Opposite"),
    BA_duis = ui_new_slider("LUA", "B", "Jitter-Range", -180, 180, 0, true),




    logging_section_label = ui.new_label( 'LUA', 'B', '\aaafeeeee--------------------Visuals--------------------- '),

    indicator = ui.new_checkbox("LUA","B","\aff3e7faaRambomode-Indicators"),

    enabled   = ui_new_checkbox("LUA", "B", "\aff3e7faaDraw model on Kill/Hit"),
    color     = ui_new_color_picker("LUA", "B", "Color", 255, 255, 255, 255),
    mode      = ui_new_combobox("LUA", "B", "Mode", "Full", "Hitgroup"),
    duration  = ui_new_slider("LUA", "B", "\n", 1, 10000, 1000, true, "s", 0.001),


    logging_section_label = ui.new_label( 'LUA', 'B', '\aaafeeeee---------------Spam-Tools-------------------- '),

    Killsay = ui_new_checkbox("LUA", "B", "\aff3e7faaKill Say"),
    Spamsay = ui_new_checkbox("LUA", "B", "\aff3e7faaChatspam"),
    active = ui.new_checkbox("LUA", "B", "\aff3e7faaVoice Killsay"),
    loopback = ui.new_checkbox("LUA", "B", "\aff3e7faaSound loop back"),

    logging_section_label = ui.new_label( 'LUA', 'B', '\aaafeeeee--------------------Misc-------------------- '),

    clantag = ui.new_checkbox("LUA", "B", "\aff3e7faaClantag", false),
    Teleport = ui.new_hotkey("LUA", "B", "\aff3e7faaAuto-Teleport Exploit"),
    console = ui.new_checkbox("Lua", "B", "\aff3e7faaHit-Miss Log"),
    color_label = ui.new_label("LUA", "B", "\aff3e7faaaccent color"),
    color = ui.new_color_picker("LUA", "B", "\aff3e7faaaccent"),
    screen = ui.new_checkbox("Lua", "B", "\aff3e7faaScreen Hit-Logs"),


    RESO = ui_new_checkbox("LUA", "B", "\aff3e7faaEnable Rambomode-RESOLVER"),


}

----------------
ui_set_visible(menu.AA, false)
ui_set_visible(menu.d_jl, false)
ui_set_visible(menu.d_jr, false)
ui_set_visible(menu.d_s, false)
ui_set_visible(menu.BA_d, flase)
ui_set_visible(menu.s_aa, false)
ui_set_visible(menu.s_jl, false)
ui_set_visible(menu.s_jr, false)
ui_set_visible(menu.s_s, false)
ui_set_visible(menu.BA_s, false)
ui_set_visible(menu.r_aa, false)
ui_set_visible(menu.r_jl, false)
ui_set_visible(menu.r_jr, false)
ui_set_visible(menu.r_s, false)
ui_set_visible(menu.BA_r, false)
ui_set_visible(menu.a_aa, false)
ui_set_visible(menu.a_jl, false)
ui_set_visible(menu.a_jr, false)
ui_set_visible(menu.a_s, false)
ui_set_visible(menu.BA_a, false)
ui_set_visible(menu.du_aa, false)
ui_set_visible(menu.du_jl, false)
ui_set_visible(menu.du_jr, false)
ui_set_visible(menu.du_s, false)
ui_set_visible(menu.BA_du, false)
ui_set_visible(menu.dui_aa, false)
ui_set_visible(menu.dui_jl, false)
ui_set_visible(menu.dui_jr, false)
ui_set_visible(menu.dui_s, false)
ui_set_visible(menu.BA_dui, false)
ui_set_visible(menu.BA_ds, false)
ui_set_visible(menu.BA_ss, false)
ui_set_visible(menu.BA_rs, false)
ui_set_visible(menu.BA_as, false)
ui_set_visible(menu.BA_dus, false)
ui_set_visible(menu.BA_duis, false)
---------------






-----UI--------------------------------------
local function handle_menu()

    if ui.get(menu.d_aa) then
        ui_set_visible(menu.AA, true)
        ui.set(ref.yaw[1], "180")
        ui.set(ref.yaw_jitter[1], "Off")
        ui_set_visible(ref.yaw[1], false)
        ui_set_visible(ref.yaw[2], false)
        ui_set_visible(ref.byaw[1], false)
        ui_set_visible(ref.byaw[2], false)
        ui_set_visible(ref.yaw_jitter[1], false)
        ui_set_visible(ref.yaw_jitter[2], false)
    else 
        ui_set_visible(menu.AA, false)
        ui_set_visible(ref.yaw[1], true)
        ui_set_visible(ref.yaw[2], true)
        ui_set_visible(ref.byaw[1], true)
        ui_set_visible(ref.byaw[2], true)
        ui_set_visible(ref.yaw_jitter[1], true)
        ui_set_visible(ref.yaw_jitter[2], true)
    end  

    if ui_get(menu.AA) == "Default" then
        ui_set_visible(menu.d_jl, true)
        ui_set_visible(menu.d_jr, true)
        ui_set_visible(menu.d_s, true)
        ui_set_visible(menu.BA_d, true)
        if ui_get(menu.BA_d) == "Jitter" then
            ui_set_visible(menu.BA_ds, true)
        else
            ui_set_visible(menu.BA_ds, false)
        end  
    else
        ui_set_visible(menu.d_jl, false)
        ui_set_visible(menu.d_jr, false)
        ui_set_visible(menu.d_s, false)
        ui_set_visible(menu.BA_d, false)
        ui_set_visible(menu.BA_ds, false)
        ui_set_visible(menu.BA_ds, false)  
    end

    
    if ui_get(menu.AA) == "Stand" then  
        ui_set_visible(menu.s_aa, true)
        ui_set_visible(menu.s_jl, true)
        ui_set_visible(menu.s_jr, true)
        ui_set_visible(menu.s_s, true)
        ui_set_visible(menu.BA_s, true)
        if ui_get(menu.BA_s) == "Jitter" then
            ui_set_visible(menu.BA_ss, true)
        else
            ui_set_visible(menu.BA_ss, false)
        end 
    else
        ui_set_visible(menu.s_aa, false)
        ui_set_visible(menu.s_jl, false)
        ui_set_visible(menu.s_jr, false)
        ui_set_visible(menu.s_s, false)
        ui_set_visible(menu.BA_s, false)
        ui_set_visible(menu.BA_ss, false)
        ui_set_visible(menu.BA_ss, false)
 
    end

    if ui_get(menu.AA) == "Move" then  
        ui_set_visible(menu.r_aa, true)
        ui_set_visible(menu.r_jl, true)
        ui_set_visible(menu.r_jr, true)
        ui_set_visible(menu.r_s, true)
        ui_set_visible(menu.BA_r, true)
        if ui_get(menu.BA_r) == "Jitter" then
            ui_set_visible(menu.BA_rs, true)
        else
            ui_set_visible(menu.BA_rs, false)
        end 
    else
        ui_set_visible(menu.r_aa, false)
        ui_set_visible(menu.r_jl, false)
        ui_set_visible(menu.r_jr, false)
        ui_set_visible(menu.r_s, false)
        ui_set_visible(menu.BA_r, false)
        ui_set_visible(menu.BA_rs, false)
        ui_set_visible(menu.BA_rs, false)
    end

    if ui_get(menu.AA) == "In-Air" then
        ui_set_visible(menu.a_aa, true)
        ui_set_visible(menu.a_jl, true)
        ui_set_visible(menu.a_jr, true)
        ui_set_visible(menu.a_s, true)
        ui_set_visible(menu.BA_a, true)
        if ui_get(menu.BA_a) == "Jitter" then
            ui_set_visible(menu.BA_as, true)
        else
            ui_set_visible(menu.BA_as, false)
        end
    else
        ui_set_visible(menu.a_aa, false)
        ui_set_visible(menu.a_jl, false)
        ui_set_visible(menu.a_jr, false)
        ui_set_visible(menu.a_s, false)
        ui_set_visible(menu.BA_a, false)
        ui_set_visible(menu.BA_as, false)
        ui_set_visible(menu.BA_as, false)
    end

    if ui_get(menu.AA) == "Duck" then
        ui_set_visible(menu.du_aa, true)
        ui_set_visible(menu.du_jl, true)
        ui_set_visible(menu.du_jr, true)
        ui_set_visible(menu.du_s, true)
        ui_set_visible(menu.BA_du, true)
        if ui_get(menu.BA_du) == "Jitter" then
            ui_set_visible(menu.BA_dus, true)
        else
            ui_set_visible(menu.BA_dus, false)
        end
    else
        ui_set_visible(menu.du_aa, false)
        ui_set_visible(menu.du_jl, false)
        ui_set_visible(menu.du_jr, false)
        ui_set_visible(menu.du_s, false)
        ui_set_visible(menu.BA_du, false)  
        ui_set_visible(menu.BA_dus, false)
        ui_set_visible(menu.BA_dus, false)
    end

    if ui_get(menu.AA) == "Air-Duck" then
        ui_set_visible(menu.dui_aa, true)
        ui_set_visible(menu.dui_jl, true)
        ui_set_visible(menu.dui_jr, true)
        ui_set_visible(menu.dui_s, true)
        ui_set_visible(menu.BA_dui, true)
        if ui_get(menu.BA_dui) == "Jitter" then
            ui_set_visible(menu.BA_duis, true)
        else 
            ui_set_visible(menu.BA_duis, false)
        end 
    else
        ui_set_visible(menu.dui_aa, false)
        ui_set_visible(menu.dui_jl, false)
        ui_set_visible(menu.dui_jr, false)
        ui_set_visible(menu.dui_s, false)
        ui_set_visible(menu.BA_dui, false)
        ui_set_visible(menu.BA_duis, false) 
        ui_set_visible(menu.BA_duis, false) 
    end

end
    
handle_menu()
ui_set_callback(menu.d_aa, handle_menu)
ui_set_callback(menu.AA, handle_menu)
ui_set_callback(menu.d_jl, handle_menu)
ui_set_callback(menu.d_jr, handle_menu)
ui_set_callback(menu.d_s, handle_menu)
ui_set_callback(menu.BA_d, handle_menu)
ui_set_callback(menu.s_aa, handle_menu)
ui_set_callback(menu.s_jl, handle_menu)
ui_set_callback(menu.s_jr, handle_menu)
ui_set_callback(menu.s_s, handle_menu)
ui_set_callback(menu.BA_s, handle_menu)
ui_set_callback(menu.r_aa, handle_menu)
ui_set_callback(menu.r_jl, handle_menu)
ui_set_callback(menu.r_jr, handle_menu)
ui_set_callback(menu.r_s, handle_menu)
ui_set_callback(menu.BA_r, handle_menu)
ui_set_callback(menu.a_aa, handle_menu)
ui_set_callback(menu.a_jl, handle_menu)
ui_set_callback(menu.a_jr, handle_menu)
ui_set_callback(menu.a_s, handle_menu)
ui_set_callback(menu.BA_a, handle_menu)
ui_set_callback(menu.du_aa, handle_menu)
ui_set_callback(menu.du_jl, handle_menu)
ui_set_callback(menu.du_jr, handle_menu)
ui_set_callback(menu.du_s, handle_menu)
ui_set_callback(menu.BA_du, handle_menu)
ui_set_callback(menu.dui_aa, handle_menu)
ui_set_callback(menu.dui_jl, handle_menu)
ui_set_callback(menu.dui_jr, handle_menu)
ui_set_callback(menu.dui_s, handle_menu)
ui_set_callback(menu.BA_dui, handle_menu)
ui_set_callback(menu.BA_ds, handle_menu)
ui_set_callback(menu.BA_ss, handle_menu)
ui_set_callback(menu.BA_rs, handle_menu)
ui_set_callback(menu.BA_as, handle_menu)
ui_set_callback(menu.BA_dus, handle_menu)
ui_set_callback(menu.BA_duis, handle_menu)
--------------------------------

-- AA

local function delayed_switch(time, x, y)
    return (time/2 <= (globals.tickcount() % time)) and x or y
end


function set_if_not(ui_reference, value)
    if ui.get(ui_reference) ~= value then
        ui.set(ui_reference, value)
    end
end

local function get_velocity(player)
    return vector(entity.get_prop(player, "m_vecVelocity")):length2d()
end


client.set_event_callback("paint", function(ctx)
   
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end

    local on_ground = bit.band(entity.get_prop(lp, "m_fFlags"), 1)
    local in_duck = bit.band(entity.get_prop(lp, "m_flDuckAmount"), 1)
    local velocity = get_velocity(lp)

    local con = {
        Air = on_ground == 0,
        Standing = velocity <= 100,
        Moving = velocity > 100 and on_ground == 1,
        Duck = in_duck == 1 and on_ground == 1,
        AirDuck = in_duck == 1 and on_ground == 0
    }

        --body yaw


        if ui.get(menu.d_aa) and ui_get(menu.BA_d) == "Jitter" then
            ui.set(ref.byaw[1], "Jitter")
            ui.set(ref.byaw[2], ui.get(menu.BA_ds))
        end

        if ui.get(menu.d_aa) and ui_get(menu.BA_d) == "Opposite" then
            ui.set(ref.byaw[1], "Opposite")
        end




        if ui.get(menu.s_aa) and con.Standing and ui_get(menu.BA_s) == "Jitter" then
            ui.set(ref.byaw[1], "Jitter")
            ui.set(ref.byaw[2], ui.get(menu.BA_ss))
        end

        if ui.get(menu.s_aa) and con.Standing and ui_get(menu.BA_s) == "Opposite" then
            ui.set(ref.byaw[1], "Opposite")
        end




        if ui.get(menu.r_aa) and con.Moving and ui_get(menu.BA_r) == "Jitter" then
            ui.set(ref.byaw[1], "Jitter")
            ui.set(ref.byaw[2], ui.get(menu.BA_rs))
        end

        if ui.get(menu.r_aa) and con.Moving and ui_get(menu.BA_r) == "Opposite" then
            ui.set(ref.byaw[1], "Opposite")
        end



        if ui.get(menu.a_aa) and con.Air and ui_get(menu.BA_a) == "Jitter" then
            ui.set(ref.byaw[1], "Jitter")
            ui.set(ref.byaw[2], ui.get(menu.BA_as))
        end

        if ui.get(menu.a_aa) and con.Air and ui_get(menu.BA_a) == "Opposite" then
            ui.set(ref.byaw[1], "Opposite")
        end




        if ui.get(menu.du_aa) and con.Duck and ui_get(menu.BA_du) == "Jitter" then
            ui.set(ref.byaw[1], "Jitter")
            ui.set(ref.byaw[2], ui.get(menu.BA_dus))
        end

        if ui.get(menu.du_aa) and con.Duck and ui_get(menu.BA_du) == "Opposite" then
            ui.set(ref.byaw[1], "Opposite")
        end




        if ui.get(menu.dui_aa) and con.AirDuck and ui_get(menu.BA_dui) == "Jitter" then
            ui.set(ref.byaw[1], "Jitter")
            ui.set(ref.byaw[2], ui.get(menu.BA_duis))
        end

        if ui.get(menu.dui_aa) and con.AirDuck and ui_get(menu.BA_dui) == "Opposite" then
            ui.set(ref.byaw[1], "Opposite")
        end












        --Jitter
        if ui.get(menu.s_aa) and con.Standing then
            
            ui.set(ref.yaw[2], delayed_switch(ui.get(menu.s_s), ui.get(menu.s_jl), ui.get(menu.s_jr)))
        
        end

        if ui.get(menu.r_aa) and con.Moving then
            
            ui.set(ref.yaw[2], delayed_switch(ui.get(menu.r_s), ui.get(menu.r_jl), ui.get(menu.r_jr)))
        
        end

        if ui.get(menu.a_aa) and con.Air then
            
            ui.set(ref.yaw[2], delayed_switch(ui.get(menu.a_s), ui.get(menu.a_jl), ui.get(menu.a_jr)))
        
        end

        if ui.get(menu.du_aa) and con.Duck then
            
            ui.set(ref.yaw[2], delayed_switch(ui.get(menu.du_s), ui.get(menu.du_jl), ui.get(menu.du_jr)))
        
        end

        if ui.get(menu.dui_aa) and con.AirDuck then
            
            ui.set(ref.yaw[2], delayed_switch(ui.get(menu.dui_s), ui.get(menu.dui_jl), ui.get(menu.dui_jr)))
        
        end


end)





--RESOLVER

local plist_set, plist_get = plist.set, plist.get
local getplayer = entity.get_players
local entity_is_enemy = entity.is_enemy



 
   
 local function resolve(player)
 
 
 
        if ui.get(menu.RESO) then 
	        plist_set(player, "Correction active", false)
	        plist_set(player, "Force body yaw", true )
	        plist_set(player, "Force body yaw value", math.random(-60,60 ))
			  
			  
	    else
	 
	        plist_set(player, "Correction active", true)
	        plist_set(player, "Force body yaw", false )
	        plist_set(player, "Force body yaw value", math.random(-60,60 ))
	    end
	 
	 
end
    





local function onpaint()
    local enemies = getplayer(true)
    for i = 1, #enemies do
	    local player = enemies[i]
		resolve(player)
		
		
		
	end

end


client.register_esp_flag("Resolved", 0, 255, 0, function(entindex)
    if not entity_is_enemy(entindex) then
	    return false
	end
	
	
	if plist_get(entindex, "Force body yaw") == true then
	    return true
	end
	
	return false
	
end)



client.set_event_callback('net_update_start', onpaint)






--VISUALS

  --Indicator



doubletap_box, doubletap_bind = ui.reference("RAGE","Aimbot","Double tap")
thirdperson_box,thirdperson_bind = ui.reference("VISUALS","Effects","Force third person (alive)")
fake_yaw_limit = ui.reference("AA","Anti-aimbot angles","Body yaw")
forcebaim_bind = ui.reference("RAGE","Aimbot","Force body aim")
fakeduck_bind = ui.reference("RAGE","Other","Duck peek assist")
mindmg_bind = {ui.reference("RAGE","Aimbot","Minimum damage override")}
osaa_bind = {ui.reference("AA","Other", "On shot anti-aim")}
qp_bind = {ui.reference("Rage","Other","Quick peek assist")}
f_bind = {ui.reference("AA","Anti-aimbot angles", "Freestanding")}
-- API References ( 1 per line, you can not do X, Y = client.screen_size() at least from my experience ) 
local api_references = {
    localplayer = entity.get_local_player()
}
      

-- Create surface fonts
local surface_fonts = {
    verdana = surface.create_font("Verdana",18,50,0x200),
    arial = surface.create_font("Arial",14,50,0x200)
}

-- Visuals
client.set_event_callback("paint", function()   

    if ui.get(menu.indicator) then

        --Screen size ( X = width, Y = height )
        X,Y = client.screen_size()



       -- Transforming the hitbox position into 2D values ( X, Y )
       

       -- Spacing for our Indicators
       spacing = 0
   
        -- Indicators
        -- Lua Name
       surface.draw_text(X/2 - 30,Y/2 + 5,209,13,244,200,surface_fonts.arial,"Rambomode") 
       surface.draw_text(X/2 - 25,Y/2 + 15,175,238,238,80,surface_fonts.arial,"RecodeV2")






       if ui.get(qp_bind[2]) then
            surface.draw_text(X/2 - 21,Y/2 + 32,210,105,30,255,surface_fonts.arial,"Quickpeek")

             -- Adding spacing
            spacing = spacing + 10
        end









       -- If you have Dobule tap enabled
        if ui.get(doubletap_bind) then
          surface.draw_text(X/2 - 6,Y/2 + 32 + spacing,127,255,0,125,surface_fonts.arial,"DT")

          -- Adding spacing
          spacing = spacing + 10
        end


        if ui.get(f_bind[1]) and ui.get(f_bind[2]) then
            surface.draw_text(X/2 - 6,Y/2 + 32 + spacing,19,238,238,125,surface_fonts.arial,"FS")

             -- Adding spacing
            spacing = spacing + 10
        end


        -- If you have Force baim enabled
        if ui.get(forcebaim_bind) then
            surface.draw_text(X/2 - 6,Y/2 + 32 + spacing,150,150,150,200,surface_fonts.arial,"FB")

             -- Adding spacing
            spacing = spacing + 10
        end



        if ui.get(fakeduck_bind) then
            surface.draw_text(X/2 - 6,Y/2 + 32 + spacing,150,150,150,125,surface_fonts.arial,"FD")

             -- Adding spacing
            spacing = spacing + 10
        end

        if ui.get(mindmg_bind[2]) then
            surface.draw_text(X/2 - 6,Y/2 + 32 + spacing,150,150,150,200,surface_fonts.arial,"MD")

             -- Adding spacing
            spacing = spacing + 10
        end

        if ui.get(osaa_bind[2]) then
            surface.draw_text(X/2 - 6,Y/2 + 32 + spacing,139,35,35,200,surface_fonts.arial,"OS")

             -- Adding spacing
            spacing = spacing + 10
        end


       -- player info for our other indicator / stolen idea from half-life and lunar
       

     -- not actually getting our anti aim but I have some stuff to do so ghetto
     local return_aa_x,return_aa_y = client.camera_angles()

     -- rendering the indicators
     -- string.format so I can input the states and the pitch and yaw values
     surface.draw_text(X * 0.025, Y / 2 - 100,200,200,200,255,surface_fonts.arial,"Rambomode-Recode V2 version: 1.0")
    -- surface.draw_text(X * 0.025, Y / 2 - 70,200,100,0,225,surface_fonts.arial,string.format("> anti-aim info: pitch  %i, yaw %i",return_aa_x,return_aa_y))

   end
end)





  --Draw Model

 local function handle_menuu()
    local state = ui_get(menu.enabled)
    ui_set_visible(menu.mode, state)
    ui_set_visible(menu.duration, state)
 end

handle_menuu()
ui_set_callback(menu.enabled, handle_menuu)

--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local hitgroups = {
    [1] = {0, 1},
    [2] = {4, 5, 6},
    [3] = {2, 3},
    [4] = {13, 15, 16},
    [5] = {14, 17, 18},
    [6] = {7, 9, 11},
    [7] = {8, 10, 12}
}

--------------------------------------------------------------------------------
-- Game event handling
--------------------------------------------------------------------------------
local function player_hurt(e)
    if not ui_get(menu.enabled) then
        return
    end
    local r, g, b, a    = ui_get(menu.color)
    local duration      = ui_get(menu.duration) * 0.001
    local victim_entindex   = client_userid_to_entindex(e.userid)
    local attacker_entindex = client_userid_to_entindex(e.attacker)
    if attacker_entindex ~= entity_get_local_player() then
        return
    end
    if ui_get(menu.mode) == "Hitgroup" then
        client_draw_hitboxes(victim_entindex, duration, hitgroups[e.hitgroup], r, g, b, a)
    else
        client_draw_hitboxes(victim_entindex, duration, 19, r, g, b, a)
    end
end

client_set_event_callback("player_hurt", player_hurt)








--SPAM-TOOLS


  --Killsay


  local globals_realtime = globals.realtime
local globals_curltime = globals.curltime
local globals_frametime = globals.frametime
local globals_absolute_frametime = globals.absoluteframetime
local globals_maxplayers = globals.maxplayers
local globals_tickcount = globals.tickcount
local globals_tickinterval = globals.tickinterval
local globals_mapname = globals.mapname
 
local client_set_event_callback = client.set_event_callback
local client_console_log = client.log
local client_console_cmd = client.exec
local client_userid_to_entindex = client.userid_to_entindex
local client_get_cvar = client.get_cvar
local client_set_cvar = client.set_cvar
local client_draw_debug_text = client.draw_debug_text
local client_draw_hitboxes = client.draw_hitboxes
local client_draw_indicator = client.draw_indicator
local client_draw_circle = client.draw_circle
local client_draw_circle_outline = client.draw_circle_outline
local client_random_int = client.random_int
local client_random_float = client.random_float
local client_draw_text = client.draw_text
local client_draw_rectangle = client.draw_rectangle
local client_draw_line = client.draw_line
local client_draw_gradient = client.draw_gradient
local client_draw_cricle = client.draw_circle
local client_draw_circle_outline = client.draW_circle_outline
local client_world_to_screen = client.world_to_screen
local client_screen_size = client.screen_size
local client_visible = client.visible
local client_delay_call = client.delay_call
local client_latency = client.latency
local client_camera_angles = client.camera_angles
local client_trace_line = client.trace_line
local client_eye_position = client.eye_position
 
local entity_get_local_player = entity.get_local_player
local entity_get_all = entity.get_all
local entity_get_players = entity.get_players
local entity_get_classname = entity.get_classname
local entity_set_prop = entity.set_prop
local entity_get_prop = entity.get_prop
local entity_is_enemy = entity.is_enemy
local entity_get_player_name = entity.get_player_name
local entity_get_player_weapon = entity.get_player_weapon
local entity_hitbox_position = entity.hitbox_position
local entity_get_steam64 = entity.get_steam64
local entity_get_bounding_box = entity.get_bounding_box
local entity_is_alive = entity.is_alive
 
--local ui_new_checkbox = ui.new_checkbox
--local ui_new_slider = ui.new_slider
--local ui_new_combobox = ui.new_combobox
--local ui_new_multiselect = ui.new_multiselect
--local ui_new_hotkey = ui.new_hotkey
-- ui_new_color_picker = ui.new_color_picker
--local ui_reference = ui.reference
--local ui_set = ui.set
--local ui_get = ui.get
--local ui_set_callback = ui.set_callback
--local ui_set_visible = ui.set_visible
--local ui_is_menu_open = ui.is_menu_open
 
local math_sin = math.sin
local math_cos = math.cos
local math_floor = math.floor
local math_ceil = math.ceil
local math_random = math.random
local meth_sqrt = math.sqrt
local table_insert = table.insert
local table_remove = table.remove
local table_size = table.getn
local table_sort = table.sort
local string_format = string.format
local bit_band = bit.band


local client_set_event_callback = client.set_event_callback
local userid_to_entindex = client.userid_to_entindex
local get_player_name = entity.get_player_name
local get_local_player = entity.get_local_player
local is_enemy = entity.is_enemy
local console_cmd = client.exec


local RepeatSay = false
local Repeattime = 0
local spamtime = 0

local function on_player_death(e)
	if not (ui_get(menu.Killsay)) then
		return
	end
	
	local victim_userid, attacker_userid = e.userid, e.attacker
	if victim_userid == nil or attacker_userid == nil then
		return
	end

	local victim_entindex   = userid_to_entindex(victim_userid)
	local attacker_entindex = userid_to_entindex(attacker_userid)

	if attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
		if e.headshot then
			console_cmd("say 1 by ☠Rambomode-RECODE V2☠ to an NN")
			client_console_log("Headshot kill")
			if (ui_get(menu.Killsay)) then
			
				RepeatSay = true
				Repeattime = globals_tickcount()
			end
		else
			console_cmd("say To ez for ☠Rambomode-RECODE V2☠")
			client_console_log("Bodyaim kill")
		end
	end
end

local function on_paint(ctx)

	local ticks_current = globals_tickcount()
	if ticks_current > Repeattime + 50 and RepeatSay == true then
		console_cmd('say To ez for ☠Rambomode-RECODE V2☠')
		RepeatSay = false 
		Repeattime = 0


	end
	
	if (ui_get(menu.Spamsay)) then
		if ticks_current >= spamtime + 50 then
			console_cmd('say Get Good Get ☠Rambomode-RECODE V2☠')
			spamtime = globals_tickcount()
		
		end
	end
	
end


local function on_state_changed()
    if ui_get(menu.Spamsay) then
        client_console_log('Spam Chat Enabled')
    else
        client_console_log('Spam Chat Disabled')
    end
end

client_set_event_callback("paint", on_paint)
client_set_event_callback("player_death", on_player_death)




  --Voice Killsay


  local sound_exists = function(name)
    return (function(filename) return package.searchpath("", filename) == filename end)("./" .. name)
end

local disable_func = function()
    cvar.voice_loopback:set_int(0)
    cvar.voice_inputfromfile:set_int(0)
    client.exec('-voicerecord')
end

local handler = nil
local timer, enabled = 0, true

local snd_time = 3.0

handler = function()
    if globals.realtime() >= timer then
        timer = globals.realtime() + snd_time
        
        if enabled then
            disable_func()
            enabled = false
        end
    end

    client.delay_call(0.001, handler)
end


client.set_event_callback("shutdown", disable_func)
client.set_event_callback("player_death", function(e)
    local victim_userid, attacker_userid = e.userid, e.attacker

    if not ui.get(menu.active) or victim_userid == nil or attacker_userid == nil then
        return
    end

    if not sound_exists('voice_input.wav') then
        ui.set(menu.active, false)
        error("no sound ./voice_input.wav")
    end
	
    local attacker_entindex = client.userid_to_entindex(attacker_userid)
    local victim_entindex = client.userid_to_entindex(victim_userid)
    
    if attacker_entindex == entity.get_local_player() then
        local lb_active = ui.get(menu.loopback) and 1 or 0

        cvar.voice_loopback:set_int(lb_active)
        cvar.voice_inputfromfile:set_int(1)

        client.exec('+voicerecord')
        timer, enabled = globals.realtime() + snd_time, true
    end
end)

local callback = function()
    ui.set_visible(menu.loopback, ui.get(menu.active))
end

ui.set_callback(menu.active, callback)
callback()
handler()







--MISC
   --Clantag
--
local client_set_clan_tag = client.set_clan_tag
local oldTick = globals.tickcount()
local Clantag = {

    "☠",
    "☠R",
    "☠Ra",
    "☠Ram",
    "☠Ramb",
    "☠Rambo",
    "☠Rambom",
    "☠Rambomo",
    "☠Rambomod",
    "☠Rambomode",
    "☠RambomodeV",
    "☠RambomodeV2",
    "☠RambomodeV2☠",
    "☠RambomodeV2",
    "☠RambomodeV",
    "☠Rambomode",
    "☠Rambomod",
    "☠Rambomo",
    "☠Rambom",
    "☠Rambo",
    "☠Ramb",
    "☠Ram",
    "☠Ra",
    "☠R",
    "☠"
} 
local cur = 1


local function clantag(e)
    if (ui.get(menu.clantag)) then
        if globals.tickcount() - oldTick > 55 then
            cur = math_floor(globals.curtime() * (30 / 10) % (13 * 2) + 1)
            client_set_clan_tag(Clantag[cur])
            oldTick = globals.tickcount()
        end
    end
end

client.set_event_callback("paint", clantag)

------------Teleport in air-------


local vars = {
    localPlayer = 0,
    hitgroup_names = { 'Generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', '?', 'Gear' },
    aaStates = {"Global", "Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Legit-AA"},
    pStates = {"G", "S", "M", "SW", "C", "A", "AC", "LA"},
	sToInt = {["Global"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["Slowwalking"] = 4, ["Crouching"] = 5, ["Air"] = 6, ["Air-Crouching"] = 7,["Legit-AA"] = 8},
    intToS = {[1] = "Global", [2] = "Stand", [3] = "Move", [4] = "Slowwalk", [5] = "Crouch", [6] = "Air", [7] = "Air+C", [8] = "Legit"},
    currentTab = 1,
    activeState = 1,
    pState = 1,
    should_disable = false,
    defensive_until = 0,
    defensive_prev_sim = 0,
    fs = false,
    choke1 = 0,
    choke2 = 0,
    choke3 = 0,
    choke4 = 0,
    switch = false,
}




client.set_event_callback("setup_command", function(cmd)
    if ui.get(menu.Teleport) then
        if dtEnabled == nil then
            dtEnabled = true
        end
        local enemies = entity.get_players(true)
        local vis = false
        local health = entity.get_prop(vars.localPlayer, "m_iHealth")
        for i=1, #enemies do
            local entindex = enemies[i]
            local body_x,body_y,body_z = entity.hitbox_position(entindex, 1)
            if client.visible(body_x, body_y, body_z + 18) then
                vis = true
            end
        end	

        if vis then
            ui.set(ref.dt[1],false)
            client.delay_call(0.01, function() 
                ui.set(ref.dt[1],true)
            end)
        end
    else
        if dtEnabled == true then
            ui.set(ref.dt[1], dtEnabled)
            dtEnabled = false
        end
    end
end)



--------HIT-MISS LOG------

local pi, max = math.pi, math.max

local dynamic = {}
dynamic.__index = dynamic

function dynamic.new(f, z, r, xi)
   f = max(f, 0.001)
   z = max(z, 0)

   local pif = pi * f
   local twopif = 2 * pif

   local a = z / pif
   local b = 1 / ( twopif * twopif )
   local c = r * z / twopif

   return setmetatable({
      a = a,
      b = b,
      c = c,

      px = xi,
      y = xi,
      dy = 0
   }, dynamic)
end

local function bal()
    if ui.get(menu.console, true) then
        ui.set(r.lg, false)
    end
end



function dynamic:update(dt, x, dx)
   if dx == nil then
      dx = ( x - self.px ) / dt
      self.px = x
   end

   self.y  = self.y + dt * self.dy
   self.dy = self.dy + dt * ( x + self.c * dx - self.y - self.a * self.dy ) / self.b
   return self
end

function dynamic:get()
   return self.y
end

local function roundedRectangle(b, c, d, e, f, g, h, i, j, k)
    renderer.rectangle(b, c, d, e, f, g, h, i)
    renderer.circle(b, c, f - 8, g - 8, h - 8, i, k, -180, 0.25)
    renderer.circle(b + d, c, f - 8, g - 8, h - 8, i, k, 90, 0.25)
    renderer.rectangle(b, c - k, d, k, f, g, h, i)
    renderer.circle(b + d, c + e, f - 8, g - 8, h - 8, i, k, 0, 0.25)
    renderer.circle(b, c + e, f - 8, g - 8, h - 8, i, k, -90, 0.25)
    renderer.rectangle(b, c + e, d, k, f, g, h, i)
    renderer.rectangle(b - k, c, k, e, f, g, h, i)
    renderer.rectangle(b + d, c, k, e, f, g, h, i)
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
local logs = {}

function fired(e)
    stored_shot = {
        damage = e.damage,
        hitbox = hitgroup_names[e.hitgroup + 1],
        lagcomp = e.teleported,
        backtrack = globals.tickcount() - e.tick
    }
end

function hit(e)
    local string = string.format("hit %s for %s [%s] in the %s [%s] [hc: %s, bt: %s, lc: %s]", string.lower(entity.get_player_name(e.target)), e.damage, stored_shot.damage, hitgroup_names[e.hitgroup + 1] or '?', stored_shot.hitbox, math.floor(e.hit_chance).."%", stored_shot.backtrack, stored_shot.lagcomp)
    table.insert(logs, {
        text = string
    }) 
    if ui.get(menu.console) then
        r,g,b = ui.get(menu.color)
        client.color_log(r, g, b, "[Rambomode-RECODE V2] \0")
        client.color_log(12, 240, 240, string)
    end
end

function missed(e)
    local string = string.format("missed %s's %s due to %s [dmg: %s, bt: %s, lc: %s]", string.lower(entity.get_player_name(e.target)), stored_shot.hitbox, e.reason, stored_shot.damage, stored_shot.lagcomp, stored_shot.backtrack)
    table.insert(logs, {
        text = string
    })
    if ui.get(menu.console) then
        r,g,b = ui.get(menu.color)
        client.color_log(r, g, b, "[Rambomode-RECODE V2] \0")
        client.color_log(255, 0, 0, string)
    end
end

function logging()
  if ui.get(menu.screen) then 
    local screen = {client.screen_size()}
    for i = 1, #logs do
        if not logs[i] then return end
        if not logs[i].init then
            logs[i].y = dynamic.new(2, 1, 1, -30)
            logs[i].time = globals.tickcount() + 128
            logs[i].init = true
        end
        r,g,b,a = ui.get(menu.color)
        local string_size = renderer.measure_text("c", logs[i].text)
        roundedRectangle(screen[1]/2-string_size/2-25, screen[2]-logs[i].y:get(), string_size+30, 16, 0,240,240,5,"", 4)
        renderer.text(screen[1]/2-20, screen[2]-logs[i].y:get()+8, 255,255,255,255,"c",0,logs[i].text)
        renderer.circle_outline(screen[1]/2+string_size/2-6, screen[2]-logs[i].y:get()+8, 13, 13, 13, 255, 7, 0, 1, 4)
        renderer.circle_outline(screen[1]/2+string_size/2-6, screen[2]-logs[i].y:get()+8, r,g,b,a, 6, 0, (logs[i].time-globals.tickcount())/256, 2)
        if tonumber(logs[i].time) < globals.tickcount() then
            if logs[i].y:get() < -10 then
                table.remove(logs, i)
            else
                logs[i].y:update(globals.frametime(), -50, nil)
            end
        else
            logs[i].y:update(globals.frametime(), 20+(i*28), nil)
        end
    end
  end
end

client.set_event_callback('paint', logging)
client.set_event_callback("aim_fire", fired)
client.set_event_callback("aim_hit", hit)
client.set_event_callback("aim_miss", missed)











-- CFG SYSTEM

local menu3 = {
    logging_section_label = ui.new_label( 'LUA', 'B', '\aaafeeeee--------------------Cfg-SYSTEM-------------------- '),
}
-- the only local needed
local ConfigSystem = {};

-- * config system
function ConfigSystem:Warn(Message, ...)
    client.error_log(Message:format(...));
end
-- * export function
function ConfigSystem:Export(Aliases)
    local ExportTable = { };

    --in most cases you dont need to change this function
    for MenuTableName, Alias in pairs(Aliases) do
        ExportTable[MenuTableName] = ExportTable[MenuTableName] or { };

        for MenuTableKey, ElementOrTable in pairs(Alias) do
            if type(ElementOrTable) == "number" then
                ExportTable[MenuTableName][MenuTableKey] = {
                    ui.get(ElementOrTable)
                };
            else
                ExportTable[MenuTableName][MenuTableKey] = ExportTable[MenuTableName][MenuTableKey] or { };

                for ExtendedTableKey, ElementOrTableRecursive in pairs(ElementOrTable) do
                    if type(ElementOrTableRecursive) == "table" then
                        ExportTable[MenuTableName][MenuTableKey][ExtendedTableKey] = ExportTable[MenuTableName][MenuTableKey][ExtendedTableKey] or { };

                        for ExtendedTableKeyRecursive, Element in pairs(ElementOrTableRecursive) do
                            ExportTable[MenuTableName][MenuTableKey][ExtendedTableKey][ExtendedTableKeyRecursive] = {
                                ui.get(Element)
                            };
                        end
                    else
                        ExportTable[MenuTableName][MenuTableKey][ExtendedTableKey] = {
                            ui.get(ElementOrTableRecursive)
                        };
                    end
                end
            end
        end
    end
    
    return base_64.encode(json.stringify(ExportTable));
end
-- * function for import
function ConfigSystem:Import(Aliases, Data)
    local SuccessfulyDecoded, DecodedData = pcall(base_64.decode, Data);

    if not SuccessfulyDecoded then
        self:Warn("Imported data was unable to be decoded."); -- change "" to whatever you want
        return;
    end

    local SuccessfulyParsed, ImportTable = pcall(json.parse, DecodedData);

    if not SuccessfulyParsed then
        self:Warn("Imported data was unable to be parsed."); -- change "" to whatever you want
        return;
    end
    --in most cases you dont need to change this function
    for MenuTableName, FunctionsTable in pairs(ImportTable) do
        for FunctionOrTableKey, ElementValueOrTable in pairs(FunctionsTable) do
            if Aliases[MenuTableName] then
                if ElementValueOrTable[1] ~= nil then
                    if Aliases[MenuTableName][FunctionOrTableKey] then
                        if type(ElementValueOrTable[1]) == 'boolean' and type(ElementValueOrTable[2]) == 'number' and type(ElementValueOrTable[3]) == 'number' then
                            table.remove(ElementValueOrTable, 1);
                        end

                        local Success = pcall(ui.set, Aliases[MenuTableName][FunctionOrTableKey], unpack(ElementValueOrTable));
                    else
                        self:Warn("Imported data was containing function that was not found ( %s )", FunctionOrTableKey); -- change "" to whatever you want
                    end
                else
                    for ExtendedTableKey, ElementValueOrTableRecursive in pairs(ElementValueOrTable) do
                        if ElementValueOrTableRecursive[1] ~= nil then
                            if Aliases[MenuTableName][FunctionOrTableKey] then
                                if Aliases[MenuTableName][FunctionOrTableKey][ExtendedTableKey] then
                                    if type(ElementValueOrTableRecursive[1]) == 'boolean' and type(ElementValueOrTableRecursive[2]) == 'number' and type(ElementValueOrTableRecursive[3]) == 'number' then
                                        table.remove(ElementValueOrTableRecursive, 1);
                                    end

                                    local Success = pcall(ui.set, Aliases[MenuTableName][FunctionOrTableKey][ExtendedTableKey], unpack(ElementValueOrTableRecursive));
                                else
                                    self:Warn("Imported data was containing function that was not found ( %s->%s )", FunctionOrTableKey, ExtendedTableKey); -- change "" to whatever you want
                                end
                            else
                                self:Warn("Imported data was containing extended table that was not found ( %s )", FunctionOrTableKey); -- change "" to whatever you want
                            end
                        else
                            for ExtendedTableKeyRecursive, ElementValue in pairs(ElementValueOrTableRecursive) do
                                if Aliases[MenuTableName][FunctionOrTableKey][ExtendedTableKey] then
                                    if Aliases[MenuTableName][FunctionOrTableKey][ExtendedTableKey][ExtendedTableKeyRecursive] then
                                        if type(ElementValue[1]) == 'boolean' and type(ElementValue[2]) == 'number' and type(ElementValue[3]) == 'number' then
                                            table.remove(ElementValue, 1);
                                        end

                                        local Success = pcall(ui.set, Aliases[MenuTableName][FunctionOrTableKey][ExtendedTableKey][ExtendedTableKeyRecursive], unpack(ElementValue));
                                    else
                                        self:Warn("Imported data was containing function that was not found ( %s->%s->%s )", FunctionOrTableKey, ExtendedTableKey, ExtendedTableKeyRecursive); -- change "" to whatever you want
                                    end
                                else
                                    self:Warn("Imported data was containing extended table that was not found ( %s->%s )", FunctionOrTableKey, ExtendedTableKey); -- change "" to whatever you want
                                end
                            end
                        end
                    end
                end
            else
                self:Warn("Imported data was containing table that was not found ( %s )", MenuTableName);
            end
        end
    end
end
--default button
local default = ui.new_button("LUA", "B", "Load Preset cfg", function ()  -- change "" to whatever you want 
    local ConfigStream = "eyJBbnRpYWltIjp7ImFjdGl2ZSI6W2ZhbHNlXSwiU3BhbXNheSI6W2ZhbHNlXSwic19zIjpbM10sIkJBX3IiOlsiSml0dGVyIl0sIkJBX2R1cyI6Wy0xXSwiZF9qbCI6WzBdLCJBQSI6WyJNb3ZlIl0sImNvbnNvbGUiOlt0cnVlXSwicl9qciI6WzE3XSwic19qciI6WzIxXSwiS2lsbHNheSI6W2ZhbHNlXSwiZHVfYWEiOlt0cnVlXSwiZHVpX2FhIjpbdHJ1ZV0sIkJBX2R1IjpbIkppdHRlciJdLCJzX2FhIjpbdHJ1ZV0sIkJBX2FzIjpbMF0sImluZGljYXRvciI6W3RydWVdLCJyX2psIjpbLTI0XSwiZW5hYmxlZCI6W2ZhbHNlXSwiQkFfZHVpcyI6WzBdLCJyX2FhIjpbdHJ1ZV0sImRfYWEiOlt0cnVlXSwiQkFfYSI6WyJPcHBvc2l0ZSJdLCJkX3MiOlszXSwiY29sb3IiOlsyNTUsMjU1LDI1NSwyNTVdLCJzX2psIjpbLTM2XSwiYV9zIjpbNl0sImR1X3MiOls5XSwiYV9hYSI6W3RydWVdLCJkdWlfamwiOlstMTldLCJyX3MiOlsyNF0sIkJBX2RzIjpbMF0sImxvb3BiYWNrIjpbdHJ1ZV0sIm1vZGUiOlsiRnVsbCJdLCJCQV9zcyI6Wy0xOV0sIkJBX3MiOlsiSml0dGVyIl0sImFfamwiOlstMTZdLCJCQV9ycyI6WzEyXSwiQkFfZHVpIjpbIk9wcG9zaXRlIl0sImR1cmF0aW9uIjpbMTAwMF0sIkJBX2QiOlsiSml0dGVyIl0sImxvZ2dpbmdfc2VjdGlvbl9sYWJlbCI6WyIgICAgICAgICAgICAgICAgICAgICAgICAgXHUwMDA3YWFmZWVlZWVNaXNjICJdLCJhX2pyIjpbMTZdLCJzY3JlZW4iOlt0cnVlXSwiZHVpX2pyIjpbMTldLCJkdWlfcyI6WzZdLCJSRVNPIjpbdHJ1ZV0sImNvbG9yX2xhYmVsIjpbIlx1MDAwN2ZmM2U3ZmFhYWNjZW50IGNvbG9yIl0sIlRlbGVwb3J0IjpbdHJ1ZSwwLDBdLCJjbGFudGFnIjpbdHJ1ZV0sImR1X2pyIjpbMTJdLCJkdV9qbCI6Wy0yN10sImRfanIiOlswXX19"  -- export config you want to set as default and paste the code in "".
    ConfigSystem:Import({

        -- all these are you have to change to your lua needs
        Antiaim = menu,
        AntiaimSelector = small_stash_difors,
        Other = lua
    }, ConfigStream);
end)
--import  button
local import = ui.new_button("LUA", "B", "Import Config", function () -- change "" to whatever you want 
    local ConfigStream = clipboard.get();

    ConfigSystem:Import({

        -- all these are you have to change to your lua needs
        Antiaim = menu,
        AntiaimSelector = small_stash_difors,
        Other = lua
    }, ConfigStream);
end)
--export button
local export = ui.new_button("LUA", "B", "Export Config", function () -- change "" to whatever you want 
    local ConfigStream = ConfigSystem:Export({

        -- all these are you have to change to your lua needs
        Antiaim = menu,
        AntiaimSelector = small_stash_difors,
        Other = lua
    });

    clipboard.set(ConfigStream);
end)


--save configs in Steam\steamapps\common\Counter-Strike Global Offensive 

local save_local_config = function ()
    writefile('Rambo-pub.cfg', ConfigSystem:Export({ --saves the "... .cfg" config.

        -- all these are you have to change to your lua needs
        Antiaim = menu,
        AntiaimSelector = small_stash_difors,
        Other = lua
    })); 
end

local load_local_config = function ()
    if readfile('Rambo-pub.cfg') then
        ConfigSystem:Import({

            -- all these are you have to change to your lua needs
            Antiaim = menu,
            AntiaimSelector = small_stash_difors,
            Other = lua
        }, readfile('Rambo-pub.cfg'));-- that file will be read and imported 
    end
end

load_local_config();--dont move





local ende = {
    logging_section_label = ui.new_label( 'LUA', 'B', '   '),
    logging_section_label = ui.new_label( 'LUA', 'B', '\aaafeeeee▉ ▇ ▆ ▅ ▄ ▃ ▂ ▁ ☠Rambomode-RECODE V2☠▁ ▂ ▃ ▄ ▅ ▆ ▇ ▉')
}





