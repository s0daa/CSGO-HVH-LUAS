---@diagnostic disable: undefined-global, undefined-field
-- debugging
local DEBUG = false;
local inspect;

if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function (...)
        return ...;
    end
end

if DEBUG then
    inspect = require "gamesense/inspect";
end

local ffi = require 'ffi';
local vector = require 'vector';
local anti_aim = require 'gamesense/antiaim_funcs' or error("Missing antiaim funcs library");
local clipboard = require 'gamesense/clipboard' or error("Missing clipboard library");
local http = require "gamesense/http" or error("Missing HTTP library");
local base_64 = (function()local a=require"bit"local b={}local c,d,e=a.lshift,a.rshift,a.band;local f,g,h,i,j,k,tostring,error,pairs=string.char,string.byte,string.gsub,string.sub,string.format,table.concat,tostring,error,pairs;local l=function(m,n,o)return e(d(m,n),c(1,o)-1)end;local function p(q)local r,s={},{}for t=1,65 do local u=g(i(q,t,t))or 32;if s[u]~=nil then error("invalid alphabet: duplicate character "..tostring(u),3)end;r[t-1]=u;s[u]=t-1 end;return r,s end;local v,w={},{}v["base64"],w["base64"]=p("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")v["base64url"],w["base64url"]=p("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")local x={__index=function(y,z)if type(z)=="string"and z:len()==64 or z:len()==65 then v[z],w[z]=p(z)return y[z]end end}setmetatable(v,x)setmetatable(w,x)function b.encode(A,r)r=v[r or"base64"]or error("invalid alphabet specified",2)A=tostring(A)local B,C,D={},1,#A;local E=D%3;local F={}for t=1,D-E,3 do local G,H,I=g(A,t,t+2)local m=G*0x10000+H*0x100+I;local J=F[m]if not J then J=f(r[l(m,18,6)],r[l(m,12,6)],r[l(m,6,6)],r[l(m,0,6)])F[m]=J end;B[C]=J;C=C+1 end;if E==2 then local G,H=g(A,D-1,D)local m=G*0x10000+H*0x100;B[C]=f(r[l(m,18,6)],r[l(m,12,6)],r[l(m,6,6)],r[64])elseif E==1 then local m=g(A,D)*0x10000;B[C]=f(r[l(m,18,6)],r[l(m,12,6)],r[64],r[64])end;return k(B)end;function b.decode(K,s)s=w[s or"base64"]or error("invalid alphabet specified",2)local L="[^%w%+%/%=]"if s then local M,N;for O,P in pairs(s)do if P==62 then M=O elseif P==63 then N=O end end;L=j("[^%%w%%%s%%%s%%=]",f(M),f(N))end;K=h(tostring(K),L,'')local F={}local B,C={},1;local D=#K;local Q=i(K,-2)=="=="and 2 or i(K,-1)=="="and 1 or 0;for t=1,Q>0 and D-4 or D,4 do local G,H,I,R=g(K,t,t+3)local S=G*0x1000000+H*0x10000+I*0x100+R;local J=F[S]if not J then local m=s[G]*0x40000+s[H]*0x1000+s[I]*0x40+s[R]J=f(l(m,16,8),l(m,8,8),l(m,0,8))F[S]=J end;B[C]=J;C=C+1 end;if Q==1 then local G,H,I=g(K,D-3,D-1)local m=s[G]*0x40000+s[H]*0x1000+s[I]*0x40;B[C]=f(l(m,16,8),l(m,8,8))elseif Q==2 then local G,H=g(K,D-3,D-2)local m=s[G]*0x40000+s[H]*0x1000;B[C]=f(l(m,16,8))end;return k(B)end;local T={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/","="}local U={"v","u","m","d","2","1","4","p","t","x","c","G","f","6","7","L","Y","C","T","j","O","y","W","F","+","R","w","V","=","9","E","a","U","r","N","P","k","0","o","g","l","M","X","D","e","Q","I","8","q","B","/","i","b","H","A","n","3","J","S","s","K","z","Z","5","h"}local V={}local W={}for t=1,#T do V[T[t]]=U[t]W[U[t]]=T[t]end;function b.encrypt(X)local Y=""local Z=b.encode(X)for t=1,Z:len()do Y=Y..V[Z:sub(t,t)]end;return Y end;function b.decrypt(X)local Y=""for t=1,X:len()do Y=Y..W[X:sub(t,t)]end;return b.decode(Y)end;return b end)()

local function ColorAsString(r, g, b, a)
    return string.format("\a%02X%02X%02X%02X", r, g, b, a);
end

ui.new_label("AA", "Anti-aimbot angles", " ");
ui.new_label("AA", "Anti-aimbot angles", (" >\\ xo-yaw anti aim technology </"));
ui.new_label("AA", "Anti-aimbot angles", " ");

-- ylregar*: button menu system
local current_tab = "global";

local menu_buttons =  {
    antiaim = ui.new_button("AA", "Anti-aimbot angles", "Anti Aim", function () current_tab = "antiaim" end),
    visual = ui.new_button("AA", "Anti-aimbot angles", "Visual", function () current_tab = "visual" end),
    misc = ui.new_button("AA", "Anti-aimbot angles", "Misc", function () current_tab = "misc" end),
    back = ui.new_button("AA", "Anti-aimbot angles", "Back", function () current_tab = "global" end),
};

local g_tab = ui.new_label("AA", "Anti-aimbot angles", "\n");

-- *demyaha: references
local menu = {
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled");
    pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")};
    yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base");
    yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
    yaw_jitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") };
    body_yaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") };
    freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw");
    edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw");
    freestand = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
	roll = ui.reference("AA", "Anti-aimbot angles", "Roll");
    legmovement = ui.reference("AA", "OTHER", "leg movement");
    slowmotion = { ui.reference("AA", "Other", "Slow motion") },
    onshot = { ui.reference("AA", "Other", "On shot anti-aim") },
    doubletap = { ui.reference("RAGE", "Aimbot", "Double tap") },
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist");
    auto_peek = { ui.reference("Rage", "Other", "Quick peek assist") },
    pingspike = { ui.reference("MISC", "Miscellaneous", "Ping Spike") },
    fakelag = ui.reference("AA", "Fake lag", "Enabled");
    fakelag_limit = ui.reference("AA", "Fake lag", "Limit");
    force_body = ui.reference("RAGE", "Aimbot", "Force body aim");
    force_safe = ui.reference("RAGE", "Aimbot", "Force safe point");
    menu_color = { ui.reference("MISC", "Settings", "Menu color") };
    clantag = ui.reference("MISC", "Miscellaneous", "Clan tag spammer");
    damage_bind = { ui.reference('RAGE', 'Aimbot', 'Minimum damage override') };
}

-- *demyaha: vars
local var = {
    side,
    body_yaw = 0,
    switch = false,
    legit_aa = false,
    got_left = false,
    got_right = false,
    rollroyse = false,
    clantag_restore = false,
    ground = 0,
    mode = nil,
    anti_backstab = false,
    build = "stable"
}

-- *demyaha & ylregar: helpers
-- *ylregar: libs
local animations = (function ()local a={data={}}function a:clamp(b,c,d)return math.min(d,math.max(c,b))end;function a:animate(e,f,g)if not self.data[e]then self.data[e]=0 end;g=g or 4;local b=globals.frametime()*g*(f and-1 or 1)self.data[e]=self:clamp(self.data[e]+b,0,1)return self.data[e]end;return a end)()
local sway_manager = (function ()local a={data={}}function a:new_frame(b)for c,d in pairs(self.data)do if b-d.last_tick>=d.speed then local e=d.times;for f=1,e do if d.forward then if d.value<d.max then d.value=d.value+1 else d.forward=false end else if d.value>d.min then d.value=d.value-1 else d.forward=true end end end;d.last_tick=b end end end;function a:sway(g,h,i,j,e)local k=math.min(h,i)local l=math.max(h,i)local e=e or 1;if not self.data[g]then self.data[g]={forward=true,value=k,min=k,max=l,last_tick=0,speed=j,times=e}end;local m=self.data[g]if m.min~=k or m.max~=l then self.data[g]={forward=true,value=k,min=k,max=l,last_tick=0,speed=j,times=e}end;if self.data[g].speed~=j then self.data[g].speed=j end;if self.data[g].times~=e then self.data[g].times=e end;return self.data[g].value end;return a end)()
local flick_manager = (function ()local a={data={}}function a:new_frame(b)for c,d in pairs(self.data)do if b-d.last_tick>=d.speed then d.flicked=not d.flicked;d.last_tick=b end end end;function a:flick(e,f,g,h)local i=math.min(f,g)local j=math.max(f,g)if not self.data[e]then self.data[e]={flicked=false,last_tick=0,speed=h}end;if self.data[e].speed~=h then self.data[e].speed=h end;return self.data[e].flicked and j or i end;return a end)()

local backup = {};
local ConfigSystem = {};
local custom_antiaim_state = {"Air + Ducking", "Air", "Ducking", "Slowwalking", "Running", "Standing", "Defensive"};
local r_lerp, g_lerp, b_lerp, a_lerp, r1_lerp, g1_lerp, b1_lerp, a1_lerp, руль, педали, dt_r, dt_g, dt_b = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
local msg = {"ебать я тебе по голове наебашил", "отключаю тебе сознание", "print(string.rep('ez', 228))", "кто здесь", "?", "здаров", "effortless", "чему я удивляюсь, ты же без хоява нищая", "too easy for xo-yaw", "всем ку пидорасы", "oh my god vot eto one tap", "попался хлопец", "кузя", "owned by xo-yaw.xyz", "f12", "трештолк (успокаивающий)", "зубы выпали, но не ссы, это молочные", "оправдания?", "1 дегенерат нерусский", "слишком легко для xo-yaw traditions", "юид полиция подъехала открывай дверь уебыч", "iqless kid wanna be ahead", "最好的 XO-YAW.LUA！想击败世界上最好的吗？使用 XO-YAW，您将永远领先对手一步"}
local debug = function (...)
    client.color_print(255, 0, 0, "[ XO-YAW ] \0");
    client.color_print(255, 255, 255, inspect({
        ...
    }));
end

backup.fakelag_limit = ui.get(menu.fakelag_limit)

local xoyaw_username; if _G.xoyaw_username then xoyaw_username = _G.xoyaw_username else xoyaw_username = "admin" end

local helpers = {
    last_sim_time = 0,
    defensive_until = 0,

    is_defensive_active = function (self)
        local tickcount = globals.tickcount();
        local local_player = entity.get_local_player();
        local sim_time = toticks(entity.get_prop(local_player, "m_flSimulationTime"));

        local sim_diff = sim_time - self.last_sim_time;

        if sim_diff < 0 then
            self.defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency());
        end

        self.last_sim_time = sim_time;

        return self.defensive_until > tickcount;
    end,

    doubletap_charged = function ()
        return anti_aim.get_double_tap()
    end,

    get_desync = function ()
        return anti_aim.get_desync(1)
    end,

    get_delta = function ()
        local localplayer = entity.get_local_player()
        if not localplayer then
            return ""
        end
        return entity.get_prop(localplayer, "m_flPoseParameter", 11) * 120 - 60
    end,

    get_velocity = function (e)
        local x, y, z = entity.get_prop(e, "m_vecVelocity");
        return math.sqrt(x * x + y * y + z * z);
    end,

    get_ground_state = function ()
        local localplayer = entity.get_local_player();
        local flags = entity.get_prop(localplayer, 'm_fFlags');
        if bit.band(flags, 1) == 0 then
            var.ground = 0
        elseif var.ground <= 5 then
            var.ground = var.ground + 1
        end
    end,

    get_air_state = function ()
        return var.ground >= 5
    end,

    get_player_state = function (self, localplayer)
        if not localplayer then
            return "", false;
        end

        local weapon = entity.get_player_weapon(localplayer);

        if not weapon then
            return "", false;
        end

        local velocity = self.get_velocity(localplayer);
        local flags = entity.get_prop(localplayer, "m_fFlags");
        local in_air = not self.get_air_state();
        local duckamount = entity.get_prop(localplayer, "m_flDuckAmount");
        local slowmotion = ui.get(menu.slowmotion[1]) and ui.get(menu.slowmotion[2]);

        if in_air and duckamount > 0 then
            return "Air + Ducking";
        elseif in_air then
            return "Air";
        elseif ui.get(menu.fakeduck) or duckamount > 0 and not in_air then
            return "Ducking";
        elseif slowmotion and velocity > 20 then
            return "Slowwalking";
        elseif velocity > 20 then
            return "Running";
        else
            return "Standing";
        end
    end,

    lerp = function (start, end_pos, time, delta)
        if (math.abs(start-end_pos) < (delta or 0.01)) then return end_pos end

        time =  globals.frametime() * (time * 175)
        if time < 0 then
          time = 0.01
        elseif time > 1 then
          time = 1
        end
        return ((end_pos - start) * time + start)
    end,

    clantag_cache = "",

    set_clantag = function (self, tag)
        if tag ~= self.clantag_cache then
            client.set_clan_tag(tag);

            self.clantag_cache = tag
        end
    end,
}

-- *ylregar & demyaha helpers additional

function helpers:vector(_x, _y, _z)
    return { x = _x or 0, y = _y or 0, z = _z or 0 }
end

function helpers:normalize(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end

function helpers:ang_on_screen(x, y)
    if x == 0 and y == 0 then return 0 end
    return math.deg(math.atan2(y, x))
end

function helpers:fov(x, y, z, rng)
    local lx, ly, lz = client.eye_position();
    local view_x, view_y, roll = client.camera_angles();
    local cur_fov = helpers:normalize(helpers:ang_on_screen(lx - x, ly - y) - view_y + rng);
    return cur_fov;
end

function helpers:calc_angle(local_x, local_y, enemy_x, enemy_y)
    local ydelta = local_y - enemy_y
    local xdelta = local_x - enemy_x
    local relativeyaw = math.atan( ydelta / xdelta )
    relativeyaw = helpers:normalize( relativeyaw * 180 / math.pi )
    if xdelta >= 0 then
        relativeyaw = helpers:normalize(relativeyaw + 180)
    end
    return relativeyaw
end

function helpers:angle_vector(angle_x, angle_y)
	local sy = math.sin(math.rad(angle_y))
	local cy = math.cos(math.rad(angle_y))
	local sp = math.sin(math.rad(angle_x))
	local cp = math.cos(math.rad(angle_x))
	return cp * cy, cp * sy, -sp
end

function helpers:crosshair_target()
    local enemies = entity.get_players(true);
    local target, last_fov = nil, 180;
    for i = 1, #enemies do
        local origin = { entity.get_prop(enemies[i], 'm_vecOrigin') };
        local fov = math.abs(helpers:fov(origin[1], origin[2], origin[3], 180));
        if fov < last_fov then
            last_fov = fov;
            target = enemies[i];
        end
    end
    return target;
end

function helpers:damage_target()
    local enemies = entity.get_players(true);
    local target, last_dmg = nil, 0;
    for i = 1, #enemies do
        local origin = { entity.get_prop(enemies[i], 'm_vecOrigin') };
        local position = { entity.get_prop(entity.get_local_player(), 'm_vecOrigin') };
        local trace = { client.trace_bullet(entity.get_local_player(), position[1], position[2], position[3], origin[1], origin[2], origin[3], true) };
        if trace[2] > last_dmg then
            last_dmg = trace[2];
            target = enemies[i];
        end
    end
    return target;
end

local function get_side()
    local target = helpers:damage_target() ~= nil and helpers:damage_target() or helpers:crosshair_target();
    if target == nil then
        return 0
    end

    local me = entity.get_local_player()

    local local_pos, enemy_pos = helpers:vector(entity.hitbox_position(me, 0)), helpers:vector(entity.hitbox_position(target, 0))

    local yaw = helpers:calc_angle(local_pos.x, local_pos.y, enemy_pos.x, enemy_pos.y)
    local l_dir, r_dir = helpers:vector(helpers:angle_vector(0, (yaw + 90))), helpers:vector(helpers:angle_vector(0, (yaw - 90)))
    local l_pos, r_pos = helpers:vector(local_pos.x + l_dir.x * 110, local_pos.y + l_dir.y * 110, local_pos.z), helpers:vector(local_pos.x + r_dir.x * 110, local_pos.y + r_dir.y * 110, local_pos.z)

    local fraction, hit_ent = client.trace_line(target, enemy_pos.x, enemy_pos.y, enemy_pos.z, l_pos.x, l_pos.y, l_pos.z)
    local fraction_s, hit_ent_s = client.trace_line(target, enemy_pos.x, enemy_pos.y, enemy_pos.z, r_pos.x, r_pos.y, r_pos.z)

    if fraction > fraction_s then
        return 1;
    elseif fraction_s > fraction then
        return 2;
    elseif fraction == fraction_s then
        return 3;
    end
end

function helpers.angle_forward(angle)
    local sin_pitch = math.sin(math.rad(angle[1]))
    local cos_pitch = math.cos(math.rad(angle[1]))
    local sin_yaw = math.sin(math.rad(angle[2]))
    local cos_yaw = math.cos(math.rad(angle[2]))

    return {cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch}
end

function helpers:is_use_needed(localplayer)
    local origin = vector(entity.get_origin(localplayer));

    if not origin then
        return false
    end

    local weapon = entity.get_player_weapon(localplayer);

    if not weapon then
        return false
    end

    local weapon_classname = entity.get_classname(weapon);

    if weapon_classname == "CC4" then
        return true
    end

    local c4s = entity.get_all('CPlantedC4');

    for _, c4 in pairs(c4s) do
        local c4_origin = vector(entity.get_origin(c4));
        if (origin - c4_origin):length() < 100 then
            return true
        end
    end

    local pitch, yaw = client.camera_angles();
    local fwd = self.angle_forward({pitch, yaw, 0});
    local start_pos = {client.eye_position()};
    local me = entity.get_local_player();
    local fraction, entindex =
        client.trace_line(
        me,
        start_pos[1],
        start_pos[2],
        start_pos[3],
        start_pos[1] + (fwd[1] * 200),
        start_pos[2] + (fwd[2] * 200),
        start_pos[3] + (fwd[3] * 200)
    )

    if entindex ~= -1 then

        if entity.get_classname(entindex) == "CPropDoorRotating" then
            return true;
        elseif entity.get_classname(entindex) == "CHostage" then
            return true;
        elseif string.match(string.lower(entity.get_classname(entindex)), "weapon") or string.match(string.lower(entity.get_classname(entindex)), "deagle") or string.match(string.lower(entity.get_classname(entindex)), "revolver") then
            return true;
        end

    end

    return false
end

function helpers.FastLadder(cmd)
    local me = entity.get_local_player();

    if me == nil or entity.get_prop(me, 'm_MoveType') ~= 9 then
        return;
    end

    local wpn = entity.get_player_weapon(me);

    if wpn == nil then
        return;
    end

    local throw_time = entity.get_prop(wpn, 'm_fThrowTime');

    if throw_time ~= nil and throw_time ~= 0 then
        return;
    end

    if cmd.in_forward == 1 or cmd.in_back == 1 then
        cmd.in_moveleft = cmd.in_back;
        cmd.in_moveright = cmd.in_back == 1 and 0 or 1;

        if cmd.sidemove == 0 then
            cmd.yaw = cmd.yaw + 45;
        end

        if cmd.sidemove > 0 then
            cmd.yaw = cmd.yaw - 1;
        end

        if cmd.sidemove < 0 then
            cmd.yaw = cmd.yaw + 90;
        end
    end
end

function helpers.GetClosestEnemyWithKnife()
    local LocalPlayer = entity.get_local_player();
    local MyOrigin = vector(entity.get_origin(LocalPlayer));
    local EnemyList = entity.get_players(true);
    local KnifeList = { };

    for i, idx in pairs(EnemyList) do
        if entity.is_alive(idx) and not entity.is_dormant(idx) then
            local Weapon = entity.get_player_weapon(idx);

            if Weapon ~= nullptr then
                local WeaponClassName = entity.get_classname(Weapon);
                if WeaponClassName:match("CKnife") then
                    table.insert(KnifeList, {
                        idx,
                        MyOrigin:dist(vector(entity.get_origin(idx)));
                    });
                end
            end
        end
    end

    if #KnifeList == 0 then
        return 0, math.huge
    end

    table.sort(KnifeList, function (A, B)
        return A[2] < B[2];
    end);

    return unpack(KnifeList[1]);
end

local InRange = function (Value, A, B)
    return Value >= A and Value <= B;
end

local SeparateValue = function (AlphaModifier, Count)
    local Each = 1 / Count;

    -- Create ranges
    local Ranges = { };
    local LatestStart = 0.0;

    for i=1, Count do
        table.insert(Ranges, {
            A = LatestStart,
            B = LatestStart + Each
        });

        LatestStart = LatestStart + Each
    end

    -- Extern
    local Out = { };

    for i=1, Count do
        local Range = Ranges[i];

        if InRange(AlphaModifier, Range.A, Range.B) then
            table.insert(Out, 1);
        else
            table.insert(Out, 0.0);
        end
    end

    return Out;
end

local render = { };

-- *demyaha: get multicombo
local function getcombo(table, value)
	if table == nil then
		return false;
	end

    table = ui.get(table);
    for i=0, #table do
        if table[i] == value then
            return true;
        end
    end

    return false
end

-- *demyaha: colortext render
function render.colortext(x, y, flags, args)
    local TextNew = "";

    for i=1, #args do
        local text, r, g, b, a = unpack(args[i]);

        TextNew = TextNew .. string.format("\a%02X%02X%02X%02X%s", r, g, b, a, text);
    end

    renderer.text(x, y, 255, 255, 255, 255, flags, 0, TextNew);
end

-- *demyaha: antiaim
local function handle_aa(pitch, pitch_custom, yaw_base, yaw, yaw_offset, yaw_jitter, yaw_jitter_offset, body_yaw, body_yaw_offset, fake_yaw_limit, freestand)
    ui.set(menu.pitch[1], pitch);
    ui.set(menu.pitch[2], pitch_custom or 89);
    ui.set(menu.yaw_base, yaw_base);
    ui.set(menu.yaw[1], yaw);
    ui.set(menu.yaw[2], yaw_offset);
    ui.set(menu.yaw_jitter[1], yaw_jitter);
    ui.set(menu.yaw_jitter[2], yaw_jitter_offset);
    ui.set(menu.body_yaw[1], body_yaw);

    local body_yaw_offset_new = body_yaw_offset;

    if body_yaw_offset_new ~= 0 then
        body_yaw_offset_new = body_yaw_offset_new > 0 and fake_yaw_limit or -fake_yaw_limit;
    end

    ui.set(menu.body_yaw[2], body_yaw_offset_new);
    ui.set(menu.freestanding_body_yaw, freestand);
end

int = function(x)
    return math.floor(x + 0.5)
end

local breathe = function(offset, multiplier)
  local m_speed = globals.realtime() * (multiplier or 1.0);
  local m_factor = m_speed % math.pi;

  local m_sin = math.sin(m_factor + (offset or 0));
  local m_abs = math.abs(m_sin);

  return m_abs
end

lerpik = function(x, v, t)
    if type(x) == 'table' then
        return lerpik(x[1], v[1], t), lerpik(x[2], v[2], t), lerpik(x[3], v[3], t), lerpik(x[4], v[4], t);
    end

    local delta = v - x;

    if type(delta) == 'number' then
        if math.abs(delta) < 0.005 then
        return v
        end
    end

    return delta * t + x
end

local lua = {
    -- * антиаимы епта
    antiaim_additionals = ui.new_multiselect("AA", "Anti-aimbot angles", "Anti Aim features", {"Manual Anti Aim", "Legit AA on Use", "Anti Backstab", "Roll AA"}),
    roll_aa = ui.new_multiselect("AA", "Anti-aimbot angles", "Roll Conditions", {"Standing", "Slowwalking", "Air", "Ducking", "Running", "Manual Anti Aim", "On-key"}),
    roll_key = ui.new_hotkey("AA", "Anti-aimbot angles", "» Roll key"),
    manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "» Left key"),
    manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "» Right key"),
    manual_reset = ui.new_hotkey("AA", "Anti-aimbot angles", "» Reset manual"),
    freestanding = ui.new_hotkey("AA", "Anti-aimbot angles", "» Freestanding"),
    edge_yaw = ui.new_hotkey("AA", "Anti-aimbot angles", "» Edge Yaw"),
    adjust_fakelag = ui.new_checkbox("AA", "Anti-aimbot angles", "Adjust fake lag limit"),

    -- * визуальная хуйня
    arrows = ui.new_combobox("AA", "Anti-aimbot angles", "Arrows", {"Disabled", "Default", "Triangle"}),
    arrows_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Arrows_col", 255, 255, 255, 255),
    arrows_color2 = ui.new_color_picker("AA", "Anti-aimbot angles", "Arrows_col2", 255, 255, 255, 255),
    indicators = ui.new_combobox("AA", "Anti-aimbot angles", "Indicators", {"Disabled", "Default", "Legacy", "Bloom"}),
    indicators_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Indicators_col", 255, 255, 255, 255),
    indicators_color2 = ui.new_color_picker("AA", "Anti-aimbot angles", "Indicators_col2", 255, 255, 255, 255),
    adjust_ind_pos = ui.new_checkbox("AA", "Anti-aimbot angles", "Adjust indicator pos in scope"),
    adjust_arrows_scope = ui.new_checkbox("AA", "Anti-aimbot angles", "Hide arrows in scope"),
    indicators_speed = ui.new_slider("AA", "Anti-aimbot angles", "Animation speed", 20, 200, 0, true, 'ms', 1),
    blur = ui.new_checkbox("AA", "Anti-aimbot angles", "Blur when menu"),
    watermark = ui.new_checkbox("AA", "Anti-aimbot angles", "W4t3rm4rk"),
    watermark_color = ui.new_color_picker("AA", "Anti-aimbot angles", "watermark_col", 255, 255, 255, 255),
    watermark_round = ui.new_slider("AA", "Anti-aimbot angles", "Rounding", 0, 8, 0, true, 1),

    -- * миск пидор
    force_defensive_bratka = ui.new_checkbox("AA", "Anti-aimbot angles", "Force defensive in air"),
    leg_movement = ui.new_checkbox("AA", "Anti-aimbot angles", "Animation breaker"),
    clantag = ui.new_checkbox("AA", "Anti-aimbot angles", "Clan tag"),
    trashtalk = ui.new_checkbox("AA", "Anti-aimbot angles", "Trashtalk"),
    бездарность = ui.new_checkbox('AA', 'anti-aimbot angles', 'Fast ladder')
}

-- *ylregar: aa sys
-- *ylregar: updated [[
local antiaim_database = { };
local demyan_style_aa = { };

if DEBUG then
    antiaim_database = json.parse(readfile('antiaim_db.json'));
    demyan_style_aa = json.parse(readfile('demyan_db.json'));
else
    print("Starting download dependencies.");

    http.get("http://xo-yaw.soteria.systems/db/antiaim_db", function (success, response)
        if not success then
            print("Antiaim preset #1 was unable to download");
            return;
        end

        local success_decode, raw_json = pcall(decode, response.body);

        if not success_decode then
            print("Antiaim preset #1 was unable to decrypt");
            return;
        end

        local success_parse, raw_data = pcall(json.parse, raw_json);

        if not success_parse then
            print("Antiaim preset #1 was unable to parse");
            return;
        end

        print("Antiaim preset #1 was successfuly downloaded");

        antiaim_database = raw_data;
    end);

    http.get("https://drainyaw.com/c_h_i_m_e_r_a/b_l_o_o_d_s_t_o_n_e/e_x_s_c_o_r_d/x_o_y_a_w/h_a_l_f_l_i_f_e/a_p_p_o_l_l_o/e_l_u_s_i_v_e/c_h_e_r_n_o_b_y_l/m_e_d_u_s_a/l_a_v_e_n_d_e_r/s_a_u_r_o_n/p_r_e_d_i_c_t_i_o_n/s_e_n_k_o_t_e_c_h/a_c_i_d_t_e_c_h/a_a_r_n_e_c_l_u_b/j_a_g_o_y_a_w/a_c_a_t_e_l/l_o_v_e_s_y_n_c/m_a_y_c_r_y/z_w_i_x_s_t_o_r_m/m_e_l_a_n_c_h_o_l_i_a/p_h_a_n_t_o_m_y_a_w/s_u_n_r_i_s_e/a_t_a_r_a_x_i_a/b_l_u_h_g_a_n_g/t_e_a_m_s_k_e_e_t/d/e/m/y/a/h/a/demyan_db", function (success, response)
        if not success then
            print("Antiaim preset #2 was unable to download");
            return;
        end

        local success_decode, raw_json = pcall(decode, response.body);

        if not success_decode then
            print("Antiaim preset #2 was unable to decrypt");
            return;
        end

        local success_parse, raw_data = pcall(json.parse, raw_json);

        if not success_parse then
            print("Antiaim preset #2 was unable to parse");
            return;
        end

        print("Antiaim preset #2 was successfuly downloaded");

        demyan_style_aa = raw_data;
    end);
end

local editing_state = "None";
local lua_custom_aa = { };
local lua_custom_aa_fake = { };
local small_stash_difors = { };
local aa_modes = {"Aggressive Jitter", "Experimental", "META", "Project Akula", "Custom"};
local empty_func = function () return true; end;

local create_custom_aa_element = function (element_type, unique_idx, visibility_context, ...)
    local arguments = {...};
    local element_name = arguments[1];

    table.remove(arguments, 1);

    return {
        id = ui["new_" .. element_type](
            'AA',
            'Anti-aimbot angles',
            ("%s\n%s"):format(element_name, unique_idx),
            unpack(arguments)
        ),
        visibility_function = visibility_context or empty_func
    };
end

for i=1000-7+1, #custom_antiaim_state+(1000-7) do
    i = i - (1000 - 7);

    local state_name = custom_antiaim_state[i];

    if not lua_custom_aa_fake[state_name] then
        lua_custom_aa_fake[state_name] = { };
    end

    local is_defensive = state_name == 'Defensive';
    local aa_modes_this = {unpack(aa_modes)};

    if is_defensive then
        aa_modes_this = {'Inherit', 'Custom'};
    end

    small_stash_difors[state_name] = {
        selected_mode = ui.new_combobox('AA', 'Anti-aimbot angles', ('%s - Mode'):format(state_name), aa_modes_this),
        customize = ui.new_checkbox('AA', 'Anti-aimbot angles', ('Customize\n^_^%s^_^'):format(state_name))
    };

    ui.set_callback(small_stash_difors[state_name].customize, function ()
        local state_dublirovanaay = state_name;

        editing_state = state_dublirovanaay;

        for bebrenuh, xgaminglox in pairs(small_stash_difors) do
            if bebrenuh ~= editing_state then
                ui.set(xgaminglox.customize, false);
            end
        end
    end);

    local state_table = lua_custom_aa_fake[state_name];

    state_table["space_upping"] = create_custom_aa_element("label", state_name, nil, "\nlolxd");
    state_table["space_up"] = create_custom_aa_element("label", state_name, nil, "<><><><><>editing<><><><><>");

    state_table["pitch"] = create_custom_aa_element("combobox", state_name, nil, 'Pitch', {
        'Minimal',
        'Off',
        'Default',
        'Down',
        'Random',
        'Custom'
    });

    local pitch_custom_visibility = function ()
        local value = ui.get(state_table["pitch"].id);

        return value == "Custom";
    end

    state_table["pitch_custom"] = create_custom_aa_element("slider", state_name, pitch_custom_visibility, '\npitch_custom', -89, 89, 89, true, '°', 1);

    state_table["yaw_mode"] = create_custom_aa_element("combobox", state_name, nil, 'Yaw Mode', {
        'Off',
        '180',
        'Sway',
        'Flick',
        'Randomized',
        'Yaw Add'
    });

    local yaw_add_visibility = function ()
        local value = ui.get(state_table["yaw_mode"].id);

        return value == "Yaw Add";
    end

    state_table["yaw_add_left"] = create_custom_aa_element("slider", state_name, yaw_add_visibility, 'Left', -180, 180, 0, true, '°', 1);
    state_table["yaw_add_right"] = create_custom_aa_element("slider", state_name, yaw_add_visibility, 'Right', -180, 180, 0, true, '°', 1);

    local yaw_amount_visibility = function ()
        local value = ui.get(state_table["yaw_mode"].id);

        return value == "180";
    end

    state_table["yaw_amount"] = create_custom_aa_element("slider", state_name, yaw_amount_visibility, '\nyaw_amount', -180, 180, 0, true, '°', 1);

    local yaw_modifier_visibility = function ()
        local value = ui.get(state_table["yaw_mode"].id);

        return value ~= 'Off' and value ~= "180" and value ~= "Yaw Add";
    end

    local yaw_delay_speed_visibility = function ()
        local value = ui.get(state_table["yaw_mode"].id);

        return value ~= 'Off' and value ~= "180" and value ~= "Yaw Add" and value ~= "Randomized";
    end

    state_table["yaw_amount_modifier"] = {
        ["start_degree"] = create_custom_aa_element("slider", state_name, yaw_modifier_visibility, 'Start Degree\nyaw', -180, 180, 0, true, '°', 1),
        ["end_degree"] = create_custom_aa_element("slider", state_name, yaw_modifier_visibility, 'End Degree\nyaw', -180, 180, 0, true, '°', 1),
        ["delay"] = create_custom_aa_element("slider", state_name, yaw_delay_speed_visibility, 'Delay\nyaw', 1, 64, 0, true, 't', 1),
        ["speed"] = create_custom_aa_element("slider", state_name, yaw_delay_speed_visibility, 'Speed\nyaw', 1, 64, 0, true, 't', 1)
    };

    local yaw_jitter_visibility = function ()
        local value = ui.get(state_table["yaw_mode"].id);

        return value ~= "Off";
    end

    state_table["yaw_jitter"] = create_custom_aa_element("combobox", state_name, yaw_jitter_visibility, 'Yaw Jitter', {
        'Off',
        'Offset',
        'Center',
        'Random',
        'Skitter'
    });

    local yaw_jitter_scale_visibility = function ()
        local value = ui.get(state_table["yaw_jitter"].id);
        local value_yaw = ui.get(state_table["yaw_mode"].id);

        return value ~= "Off" and value_yaw ~= "Off";
    end

    state_table["yaw_jitter_scale"] = create_custom_aa_element("slider", state_name, yaw_jitter_scale_visibility, '\nyaw_jitter', -180, 180, 0, true, '°', 1);

    state_table["body_yaw"] = create_custom_aa_element("combobox", state_name, nil, 'Body Yaw', {
        'Off',
        'Opposite',
        'Jitter',
        'Static'
    });

    local body_yaw_amount_visibility = function ()
        local value = ui.get(state_table["body_yaw"].id);

        return value ~= "Off" and value ~= "Opposite";
    end

    state_table["body_yaw_amount"] = create_custom_aa_element("slider", state_name, body_yaw_amount_visibility, '\nbody_yaw', -180, 180, 0, true, '°', 1);

    local fakeyaw_mode_visibility = function ()
        local value = ui.get(state_table["body_yaw"].id);

        return value ~= "Off";
    end

    state_table["fakeyaw_mode"] = create_custom_aa_element("combobox", state_name, fakeyaw_mode_visibility, 'Fake Yaw Mode', {
        'Static',
        'Sway',
        'Flick',
        'Randomized'
    });

    local fakeyaw_limit_visibility = function ()
        local value = ui.get(state_table["fakeyaw_mode"].id);
        local value_body = ui.get(state_table["body_yaw"].id);

        return value == "Static" and value_body ~= "Off";
    end

    state_table["fakeyaw_limit"] = create_custom_aa_element("slider", state_name, fakeyaw_limit_visibility, 'Fake Yaw Limit', 0, 60, 0, true, '°');

    local fakeyaw_modifier_visibility = function ()
        local value = ui.get(state_table["fakeyaw_mode"].id);
        local value_body = ui.get(state_table["body_yaw"].id);

        return value ~= "Static" and value_body ~= "Off";
    end

    local fakeyaw_delay_speed_visibility = function ()
        local value = ui.get(state_table["fakeyaw_mode"].id);
        local value_body = ui.get(state_table["body_yaw"].id);

        return value ~= "Randomized" and value ~= "Static" and value_body ~= "Off";
    end

    state_table["fakeyaw_modifier"] = {
        ["start_degree"] = create_custom_aa_element("slider", state_name, fakeyaw_modifier_visibility, 'Start Degree\nfakeyaw', 0, 60, 0, true, '°', 1),
        ["end_degree"] = create_custom_aa_element("slider", state_name, fakeyaw_modifier_visibility, 'End Degree\nfakeyaw', 0, 60, 0, true, '°', 1),
        ["delay"] = create_custom_aa_element("slider", state_name, fakeyaw_delay_speed_visibility, 'Delay\nfakeyaw', 1, 64, 0, true, 't', 1),
        ["speed"] = create_custom_aa_element("slider", state_name, fakeyaw_delay_speed_visibility, 'Speed\nfakeyaw', 1, 64, 0, true, 't', 1)
    };

    state_table["space_down"] = create_custom_aa_element("label", state_name, nil, "<><><><><>editing<><><><><>");
    state_table["space_downich"] = create_custom_aa_element("label", state_name, nil, "\nlolvillain");
end

-- haha typical russian technology!!!!!!!!!!!!!!!!!!!!!!!
local visibility_custom = function ()
    for ey_nu_i_che_ti_mne_skazezh_geroy_interneta, kogda_tvoya_pesenka_uzhe_speta in pairs(small_stash_difors) do
        ui.set_visible(kogda_tvoya_pesenka_uzhe_speta.selected_mode, current_tab == "antiaim");
        ui.set_visible(kogda_tvoya_pesenka_uzhe_speta.customize, current_tab == "antiaim" and ui.get(kogda_tvoya_pesenka_uzhe_speta.selected_mode) == "Custom");
    end

    for state_name, state_info in pairs(lua_custom_aa_fake) do
        local global_vis = ui.get(small_stash_difors[state_name].selected_mode) == "Custom" and ui.get(small_stash_difors[state_name].customize); global_vis = global_vis and state_name == editing_state and current_tab == "antiaim";

        for info_id, t_or_id in pairs(state_info) do
            if t_or_id.id ~= nil then
                ui.set_visible(t_or_id.id, t_or_id.visibility_function() and global_vis);
            else
                for info_id_recursive, id_recursive in pairs(t_or_id) do
                    ui.set_visible(id_recursive.id, id_recursive.visibility_function() and global_vis);
                end
            end
        end
    end
end

-- haha typical russian technology v2.0!!!!!!!!!!!!!!!!!!!!!!!
for state_name, state_info in pairs(lua_custom_aa_fake) do
    if not lua_custom_aa[state_name] then
        lua_custom_aa[state_name] = { };
    end

    for info_id, t_or_id in pairs(state_info) do
        if t_or_id.id ~= nil then
            lua_custom_aa[state_name][info_id] = t_or_id.id;
        else
            for info_id_recursive, id_recursive in pairs(t_or_id) do
                if not lua_custom_aa[state_name][info_id] then
                    lua_custom_aa[state_name][info_id] = { };
                end

                lua_custom_aa[state_name][info_id][info_id_recursive] = id_recursive.id;
            end
        end
    end
end
-- ]]

-- *demyaha: antiaim region
local function antiaim(cmd)
    local localplayer = entity.get_local_player()
    if not localplayer or not entity.is_alive(localplayer) then return end

    -- *demyaha: eto nado
    helpers.get_ground_state();
    var.side = get_side();
    local velocity = helpers.get_velocity(localplayer);
    local desync = helpers.get_desync();
    local delta = helpers.get_delta();
    local state, is_defensive = helpers:get_player_state(localplayer), helpers:is_defensive_active();

    var.rollroyse = false;
    var.anti_backstab = false;
    ui.set(menu.roll, 0);

    sway_manager:new_frame(globals.tickcount());
    flick_manager:new_frame(globals.tickcount());

    if cmd.chokedcommands == 0 then
        var.body_yaw = delta
    end

    local AntiBackStabDistance = getcombo(lua.antiaim_additionals, "Anti Backstab") and 200 or -1;
    local ClosestEnemy, ClosestEnemyDistance = helpers.GetClosestEnemyWithKnife();
    local yaw_manager = function (left, right) if var.body_yaw > 0 then return left elseif var.body_yaw < 0 then return right else return 0 end end
    local yaw_side = function (pizdamne, ebatgm) if var.side == 1 then return pizdamne else return ebatgm end end

    local private = function (...)
        local args = {...}

        ui.set(menu.yaw[2], yaw_manager((args[1] - (args[3] / 2)), (args[2] + (args[3] / 2))));
        ui.set(menu.pitch[1], "Minimal");
        ui.set(menu.yaw_base, "At targets");
        ui.set(menu.yaw_jitter[1], "Off");
        ui.set(menu.yaw_jitter[2], 0);
        ui.set(menu.yaw[1], "180");
        ui.set(menu.body_yaw[1], "Jitter");
        ui.set(menu.body_yaw[2], 0);
        ui.set(menu.freestanding_body_yaw, false);
    end

    -- *demyaha: shit legit aa system + ylregar [05.05]: updated
    if getcombo(lua.antiaim_additionals, "Legit AA on Use") then
        local IsUseNeeded = helpers:is_use_needed(localplayer);

        if cmd.in_use == 1 and not IsUseNeeded then
            var.legit_aa = true;
            cmd.in_use = 0;
            handle_aa("Off", 0, "Local View", "180", yaw_manager(-150, 180), "Center", 60, "Jitter", 0, 60, true)
        else
            var.legit_aa = false;
        end
    else
        var.legit_aa = false;
    end

    if ui.get(lua.бездарность) then
        helpers.FastLadder(cmd);
    end

    -- *demyaha: manual antiaim system
    if getcombo(lua.antiaim_additionals, "Manual Anti Aim") then
        if ui.get(lua.manual_left) and var.got_left then
            if var.mode == "left" then
                var.mode = nil;
            else
                var.mode = "left";
            end

            var.got_left = false;

        elseif ui.get(lua.manual_right) and var.got_right then
            if var.mode == "right" then
                var.mode = nil;
            else
                var.mode = "right";
            end

            var.got_right = false;
        end

        if ui.get(lua.manual_left) == false then
            var.got_left = true;
        end

        if ui.get(lua.manual_right) == false then
            var.got_right = true;
        end

        if ui.get(lua.manual_reset) then
            var.mode = nil;
        end
    end

    if ui.get(lua.adjust_fakelag) then
        if ui.get(menu.onshot[1]) and ui.get(menu.onshot[2]) and not ui.get(menu.fakeduck) then
            ui.set(menu.fakelag_limit, 1);
        else
            ui.set(menu.fakelag_limit, 15);
        end
    end

    if not var.legit_aa then
        -- *demyaha: anti backstab
        if getcombo(lua.antiaim_additionals, "Anti Backstab") then
           if ClosestEnemyDistance < AntiBackStabDistance and not var.legit_aa then
               var.anti_backstab = true;
               handle_aa("Minimal", 0, "At targets", "180", 180, "Off", 0, "Jitter", 0, 60, false)
           end
        end

        if not var.anti_backstab then
            -- *demyaha: 3DeCb Jly4LLle BblPBaTb PyKu
            if getcombo(lua.antiaim_additionals, "Roll AA") and not ui.get(menu.fakeduck) then
                if getcombo(lua.roll_aa, "Manual Anti Aim") and var.mode ~= nil then
                    var.rollroyse = true
                    cmd.roll = 50
                    handle_aa("Minimal", 0, "Local View", "180", var.mode == "left" and -90 or var.mode == "right" and 90, "Off", 0, "Static", -141, 60, false)
                elseif var.mode == nil then
                    if getcombo(lua.roll_aa, state == "Air + Ducking" and "Air" or state) or getcombo(lua.roll_aa, "On-key") and ui.get(lua.roll_key) then
                        var.rollroyse = true

                        if getcombo(lua.roll_aa, "Air") and state == "Air" or getcombo(lua.roll_aa, "Air") and state == "Air + Ducking" then
                            cmd.roll = 50
                            handle_aa("Minimal", 0, "At targets", "180", 22, "Off", 0, "Static", 21, 60, false)
                        else
                            cmd.roll = yaw_side(-50, 50)
                            handle_aa("Minimal", 0, "At targets", "180", yaw_side(-3, 3), "Off", 0, "Static", yaw_side(-21, 21), 60, false)
                        end
                    end
                end
            end

            if not var.rollroyse then
                if var.mode ~= nil then
                    handle_aa("Minimal", 0, "Local View", "180", var.mode == "left" and -90 or var.mode == "right" and 90, "Off", 0, "Jitter", 0, 60, true)
                else
                    if state ~= "" then
                        local selected_state = state;
                        local selected_state_info = small_stash_difors[state];
                        local selected_mode = ui.get(selected_state_info.selected_mode);

                        local defensive_state_info = small_stash_difors['Defensive'];
                        local defensive_state_mode = ui.get(defensive_state_info.selected_mode);

                        if defensive_state_mode ~= 'Inherit' then
                            --cmd.force_defensive = 1;

                            if is_defensive then
                                selected_state = 'Defensive';

                                if defensive_state_mode == 'Custom' then
                                    selected_mode = 'Custom';
                                end
                            end
                        end

                        if selected_state ~= 'Defensive' and demyan_style_aa[selected_mode] then
                            local demyan_style_values = demyan_style_aa[selected_mode][state];

                            if selected_state == 'Defensive' and demyan_style_aa[selected_mode][selected_state] ~= nil then
                                demyan_style_values = demyan_style_aa[selected_mode][selected_state];
                            end

                            private(demyan_style_values.first, demyan_style_values.second, demyan_style_values.third);
                        else
                            local pitch, pitch_custom, yaw_type, yaw_amount, yaw_jitter, yaw_jitter_scale, body_type, body_yaw, limit, yaw_add_l, yaw_add_r, yaw_from, yaw_to, yaw_speed, yaw_times, limit_type, limit_from, limit_to, limit_speed, limit_times;

                            if selected_mode == "Custom" or antiaim_database[selected_mode] == nil then
                                local custom_antiaim_table = lua_custom_aa[selected_state];

                                pitch = ui.get(custom_antiaim_table.pitch);
                                pitch_custom = ui.get(custom_antiaim_table.pitch_custom);

                                yaw_type = ui.get(custom_antiaim_table.yaw_mode);
                                yaw_amount = ui.get(custom_antiaim_table.yaw_amount);
                                yaw_jitter = ui.get(custom_antiaim_table.yaw_jitter);
                                yaw_jitter_scale = ui.get(custom_antiaim_table.yaw_jitter_scale);
                                body_type = ui.get(custom_antiaim_table.body_yaw);
                                body_yaw = ui.get(custom_antiaim_table.body_yaw_amount);
                                limit = ui.get(custom_antiaim_table.fakeyaw_limit);

                                yaw_add_l = ui.get(custom_antiaim_table.yaw_add_left);
                                yaw_add_r = ui.get(custom_antiaim_table.yaw_add_right);

                                yaw_from  = ui.get(custom_antiaim_table.yaw_amount_modifier.start_degree);
                                yaw_to    = ui.get(custom_antiaim_table.yaw_amount_modifier.end_degree);
                                yaw_speed = ui.get(custom_antiaim_table.yaw_amount_modifier.delay);
                                yaw_times = ui.get(custom_antiaim_table.yaw_amount_modifier.speed);

                                limit_type  = ui.get(custom_antiaim_table.fakeyaw_mode);
                                limit_from  = ui.get(custom_antiaim_table.fakeyaw_modifier.start_degree);
                                limit_to    = ui.get(custom_antiaim_table.fakeyaw_modifier.end_degree);
                                limit_speed = ui.get(custom_antiaim_table.fakeyaw_modifier.delay);
                                limit_times = ui.get(custom_antiaim_table.fakeyaw_modifier.speed);
                            else
                                local custom_antiaim_table = antiaim_database[selected_mode][state];

                                pitch = custom_antiaim_table.pitch;
                                pitch_custom = custom_antiaim_table.pitch_custom;
                                yaw_type = custom_antiaim_table.yaw_mode;
                                yaw_amount = custom_antiaim_table.yaw_amount;
                                yaw_jitter = custom_antiaim_table.yaw_jitter;
                                yaw_jitter_scale = custom_antiaim_table.yaw_jitter_scale;
                                body_type = custom_antiaim_table.body_yaw;
                                body_yaw = custom_antiaim_table.body_yaw_amount;
                                limit = custom_antiaim_table.fakeyaw_limit;

                                yaw_add_l = custom_antiaim_table.yaw_add_left;
                                yaw_add_r = custom_antiaim_table.yaw_add_right;

                                yaw_from  = custom_antiaim_table.yaw_amount_modifier.start_degree;
                                yaw_to    = custom_antiaim_table.yaw_amount_modifier.end_degree;
                                yaw_speed = custom_antiaim_table.yaw_amount_modifier.delay;
                                yaw_times = custom_antiaim_table.yaw_amount_modifier.speed;

                                limit_type  = custom_antiaim_table.fakeyaw_mode;
                                limit_from  = custom_antiaim_table.fakeyaw_modifier.start_degree;
                                limit_to    = custom_antiaim_table.fakeyaw_modifier.end_degree;
                                limit_speed = custom_antiaim_table.fakeyaw_modifier.delay;
                                limit_times = custom_antiaim_table.fakeyaw_modifier.speed;
                            end

                            if yaw_type == 'Sway' then
                                yaw_amount = sway_manager:sway(string.format('%s_yaw', state), yaw_from, yaw_to, yaw_speed, yaw_times);
                            end

                            if yaw_type == 'Flick' then
                                yaw_amount = flick_manager:flick(string.format('%s_yaw', state), yaw_from, yaw_to, yaw_speed);
                            end

                            if yaw_type == 'Randomized' then
                                yaw_amount = math.random(yaw_from, yaw_to);
                            end

                            if yaw_type == 'Yaw Add' then
                                yaw_amount = yaw_manager(yaw_add_l, yaw_add_r);
                            end

                            if limit_type == 'Sway' then
                                limit = sway_manager:sway(string.format('%s_limit', state), limit_from, limit_to, limit_speed, limit_times);
                            end

                            if limit_type == 'Flick' then
                                limit = flick_manager:flick(string.format('%s_limit', state), limit_from, limit_to, limit_speed);
                            end

                            if limit_type == 'Randomized' then
                                limit = math.random(limit_from, limit_to);
                            end

                            handle_aa(pitch or "Minimal", pitch_custom or 89, "At targets", "180", yaw_amount, yaw_jitter, yaw_jitter_scale, body_type, body_yaw, limit, false);
                        end
                    end
                end
            end
        end
    end
end


local solus_render = LPH_NO_VIRTUALIZE(function()
    local solus_m = {}

    local Box = function(x, y, w, h, r, g, b, a, radius)
        renderer.rectangle(x, y + radius, w, h - radius, r, g, b, a) -- down
        renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a) -- up

        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25) --<
        renderer.circle(x + w - radius, y + radius, r, g, b, a, radius, 90, 0.25) -->
    end

    local n = 70

    local OutlineBox = function(x, y, w, h, r, g, b, a, radius)
        local n = a / 255 * n
        renderer.rectangle(x, y + h - 1, w, 1, r, g, b, a) -- down
        renderer.rectangle(x + radius, y, w - radius * 2 + 1, 1, r, g, b, n) -- up

        renderer.gradient(x, y + radius, 1, h - radius, r, g, b, n, r, g, b, a, false) --<
        renderer.gradient(x + w, y + radius, 1, h - radius, r, g, b, n, r, g, b, a, false) -->
        renderer.gradient(x, y + h - 1, w + 1, 6, r, g, b, n, r, g, b, 0, false) -- down

        renderer.circle_outline(x + radius, y + radius, r, g, b, n, radius, 180, 0.25, 1) --<
        renderer.circle_outline(x + w - radius + 1, y + radius, r, g, b, n, radius, 270, 0.25, 1) --> 
  end

    solus_m.container = function(x, y, w, h, r, g, b, a, radius, aa)
        if aa > 20 and radius < 6 then
            renderer.blur(x, y, w, h)
        end

        Box(x, y, w, h, 17, 17, 17, a, radius)
        OutlineBox(x, y, w, h, r, g, b, aa, radius)
    end

    return solus_m
end)()

-- *demyaha: visual
local function visual()
    local localplayer = entity.get_local_player();
    local screensize = { client.screen_size() };
    local center = { screensize[1] / 2, screensize[2] / 2 };
    local x = center[1]
    local y = center[2]
    local ss = { screensize[1] / 2, screensize[2] / 2 };
    local valid = localplayer ~= nil and entity.is_alive(localplayer);
    local scoped;
    local resume_scope;

    if not valid then
        return
    end

    local player_resource = entity.get_player_resource();

    if not player_resource then
        return;
    end

    -- *demyaha: color tbl
    local col = {
        alpha = math.min(255, 255 - animations:animate("anime", globals.realtime() * 2.5 % 6 >= 1) * 205) / 255,
        alpha2 = math.min(255, 255 - animations:animate("anime2", globals.realtime() * 2.5 % 5 >= 1) * 155) / 255,
        indicator = { ui.get(lua.indicators_color) },
        indicator2 = { ui.get(lua.indicators_color2) },
        arrows = { ui.get(lua.arrows_color) },
        arrows2 = { ui.get(lua.arrows_color2) },
        watermark = { ui.get(lua.watermark_color) },
    }

    local pingspike_ref, pingspike_hotkey, pingspike_amount = ui.get(menu.pingspike[1]), ui.get(menu.pingspike[2]), ui.get(menu.pingspike[3]);

    if valid then
        scoped = entity.get_prop(localplayer, "m_bIsScoped") == 1;
        resume_scope = entity.get_prop(localplayer, "m_bResumeZoom") == 1;
    end

    -- *demyaha: animation tbl
    local alpha = {
        default = animations:animate("on_default", not (valid and ui.get(lua.indicators) == "Default"), 4) * 255,
        legacy = animations:animate("on_legacy", not (valid and ui.get(lua.indicators) == "Legacy"), 4) * 255,
        bloom = animations:animate("on_bloom", not (valid and ui.get(lua.indicators) == "Bloom"), 4) * 255,
        arrows_def = animations:animate("on_arrows_def", not (valid and var.mode and ui.get(lua.arrows) == "Default"), 4) * 255,
        arrows_tri = animations:animate("on_arrows_tri", not (valid and ui.get(lua.arrows) == "Triangle"), 4) * 255,
        left = animations:animate("left_mode", not (var.mode == "left"), 4) * 255,
        right = animations:animate("right_mode", not (var.mode == "right"), 4) * 255,
        scope = animations:animate("scope_ind", not (valid and ui.get(lua.adjust_ind_pos) and (scoped and not resume_scope)), 8),
        scope_arrows = animations:animate('not_scoped', ui.get(lua.adjust_arrows_scope) and entity.get_prop(localplayer, 'm_bIsScoped') == 1, 8);
        watermark = animations:animate("watermark_on", not (ui.get(lua.watermark)), 4) * 255;
        watermark_off = animations:animate("watermark_off", ui.get(lua.watermark), 4) * 255;
    }

    -- *demyaha: blur when menu
    if ui.get(lua.blur) and ui.is_menu_open() then
        renderer.blur(0, 0, screensize[1], screensize[2])
    end

    if alpha.watermark > 0.01 then
        local width2 = vector(renderer.measure_text('', ("xo-yaw for gamesense | %s"):format(var.build)));
        local x = (screensize[1] - width2.x) / 2;
        local y = screensize[2] / 1.019;

        --renderer.rectangle(x - 3, y - 3, width2.x + 6, 21, 14, 14, 14, col.watermark[4] * (alpha.watermark / 255));
        --renderer.rectangle(x - 3, y - 5, width2.x + 6, 2, col.watermark[1], col.watermark[2], col.watermark[3], alpha.watermark);
        solus_render.container(x - 5, y - 3, width2.x + 10, 21, col.watermark[1], col.watermark[2], col.watermark[3], (alpha.watermark / 255) * col.watermark[4], ui.get(lua.watermark_round), alpha.watermark)

        render.colortext(x, y, "", {
            {("xo-yaw for gamesense | %s"):format(var.build), 255, 255, 255, alpha.watermark},
        }, 1);

    end

    -- *demyaha: eto tozhe tut nado
    local charge = helpers.doubletap_charged()
    local delta = helpers.get_delta()
    local state = helpers:get_player_state(localplayer)

    if state == "Air + Ducking" then
        state = "Air+"
    end

    if alpha.watermark_off > 0.01 then
        render.colortext(10, center[2] / 1.25, "", {
            {">\\ xo-yaw ", 255, 255, 255, alpha.watermark_off},
            {"anti aim ", 255, 255, 255, alpha.watermark_off},
            {"technology ", 255, 255, 255, alpha.watermark_off},
            var.build ~= 'stable' and {("[%s]"):format(var.build), 255, 255, 255, math.max(breathe(), 0.2) * alpha.watermark_off} or nil
        }, 1);
    end

    руль = helpers.lerp(руль, math.abs(delta), 0.045)
    педали = helpers.lerp(педали, delta, 0.045)

    r_lerp = helpers.lerp(r_lerp, delta > 0 and col.indicator[1] or col.indicator2[1], 0.1, 0.05)
    g_lerp = helpers.lerp(g_lerp, delta > 0 and col.indicator[2] or col.indicator2[2], 0.1, 0.05)
    b_lerp = helpers.lerp(b_lerp, delta > 0 and col.indicator[3] or col.indicator2[3], 0.1, 0.05)
    r1_lerp = helpers.lerp(r1_lerp, delta <= 0 and col.indicator[1] or col.indicator2[1], 0.1, 0.05)
    g1_lerp = helpers.lerp(g1_lerp, delta <= 0 and col.indicator[2] or col.indicator2[2], 0.1, 0.05)
    b1_lerp = helpers.lerp(b1_lerp, delta <= 0 and col.indicator[3] or col.indicator2[3], 0.1, 0.05)

    if alpha.default > 0.01 then
        local adjust_pos_x = 32 * alpha.scope;
        local m_text = 'xo-yaw.lua'
        local m_text_length = #m_text + 1
        local m_speed = ui.get(lua.indicators_speed) / 25
        local m_screen = vector(client.screen_size());
        local m_pos = vector(m_screen.x / 2 - 1, (m_screen.y / 2) + 17);
        local m_text_size = vector(renderer.measure_text('b', m_text));
        local m_text_pos = vector(m_pos.x - m_text_size.x / 2 + 1, m_pos.y);

        for idx = 1, m_text_length do
            local m_letter = m_text:sub(idx, idx);

            if idx == m_text_length then
                m_letter = '°';
            end

            local alpha1 = idx / m_text_length;
            local anim = breathe(alpha1, m_speed);

            local m_letter_size = vector(renderer.measure_text('b', m_letter));

            local r, g, b, a = lerpik(col.indicator, col.indicator2, anim)
            a = a * (alpha.default / 255)
            renderer.text(m_text_pos.x + adjust_pos_x, m_text_pos.y, r, g, b, a, 'b', nil, m_letter)
            m_text_pos.x = m_text_pos.x + m_letter_size.x;
        end

        dt_r = helpers.lerp(dt_r, charge and 132 or 255, 0.05);
        dt_g = helpers.lerp(dt_g, charge and 210 or 75, 0.05);
        dt_b = helpers.lerp(dt_b, charge and 16 or 75, 0.05);

        local xo_indicators =
        {
            {
                text = "PING",
                color = {143, 194, 21, 255},
                bool = pingspike_ref and pingspike_hotkey
            },
            {
                text = "ROLL",
                color = {255, 75, 75, 255},
                bool = var.rollroyse
            },
            {
                text = "DOUBLETAP",
                color = {dt_r, dt_g, dt_b, 255},
                bool = ui.get(menu.doubletap[1]) and ui.get(menu.doubletap[2])
            },
            {
                text = "BAIM",
                color = {221, 55, 55, 100},
                bool = ui.get(menu.force_body)
            },
            {
                text = "ON-SHOT",
                color = {156, 177, 255, 255},
                bool = ui.get(menu.onshot[1]) and ui.get(menu.onshot[2])
            },
            {
                text = "DMG",
                color = {255, 255, 255, 255},
                bool = ui.get(menu.damage_bind[1]) and ui.get(menu.damage_bind[2])
            },
            {
                text = "FS",
                color = {221, 255, 153, 100},
                bool = ui.get(lua.freestanding)
            },
        }

        local x = center[1] - 1 + adjust_pos_x
        local start_y = y + 34;

        for idx, indicator in pairs(xo_indicators) do
            local alpha_mod = indicator.custom_alpha or 255
            local indicator_alpha = animations:animate(string.format('xo1_%s', idx), not indicator.bool, 4) * alpha_mod * alpha.default / 255
            if indicator_alpha > 0.01 then
                renderer.text(x, start_y, indicator.color[1], indicator.color[2], indicator.color[3], indicator_alpha, "-c", 0, indicator.text)
                start_y = start_y + 9 * indicator_alpha / 255
            end
        end
    end

    if alpha.legacy > 0.01 then
        local adjust_pos_x = 28 * alpha.scope;
        render.colortext(center[1] - 1 + adjust_pos_x, center[2] + 30, "-c", {
            {"XO-YAW  ", col.indicator[1], col.indicator[2], col.indicator[3], alpha.legacy},
            {var.build:upper(), col.indicator2[1], col.indicator2[2], col.indicator2[3], math.max(breathe(0, 2.5), 0.2) * alpha.legacy},
        }, 1);

        renderer.text(center[1] - 1 + adjust_pos_x, center[2] + 38, col.indicator[1], col.indicator[2], col.indicator[3], alpha.legacy, "-c", 0, string.upper(state))

        dt_r = helpers.lerp(dt_r, charge and 132 or 255, 0.05);
        dt_g = helpers.lerp(dt_g, charge and 210 or 75, 0.05);
        dt_b = helpers.lerp(dt_b, charge and 16 or 75, 0.05);

        local xo_indicators =
        {
            {
                text = "PING",
                color = {143, 194, 21, 255},
                bool = pingspike_ref and pingspike_hotkey
            },
            {
                text = "DMG",
                color = {255, 255, 255, 255},
                bool = ui.get(menu.damage_bind[1]) and ui.get(menu.damage_bind[2])
            },
            {
                text = "DT",
                color = {dt_r, dt_g, dt_b, 255},
                bool = ui.get(menu.doubletap[1]) and ui.get(menu.doubletap[2])
            },
            {
                text = "OS",
                color = {125, 125, 125, 75},
                ignore_add = true,
                val_x = -1,
                bool = not ui.get(menu.onshot[2])
            },
            {
                text = "BAIM",
                color = {125, 125, 125, 75},
                val_x = -17,
                ignore_add = true,
                bool = not ui.get(menu.force_body)
            },
            {
                text = "FS",
                color = {125, 125, 125, 75},
                val_x = 10,
                ignore_add = true,
                bool = not ui.get(lua.freestanding)
            },
            {
                text = "SP",
                color = {125, 125, 125, 75},
                val_x = 22,
                ignore_add = true,
                bool = not ui.get(menu.force_safe)
            },

            {
                text = "BAIM",
                color = {255, 79, 79, 255},
                ignore_add = true,
                val_x = -17,
                bool = ui.get(menu.force_body)
            },

            {
                text = "OS",
                color = {171, 211, 255, 255},
                ignore_add = true,
                val_x = -1,
                bool = ui.get(menu.onshot[1]) and ui.get(menu.onshot[2])
            },

            {
                text = "FS",
                color = {255, 255, 255, 255},
                val_x = 10,
                ignore_add = true,
                bool = ui.get(lua.freestanding)
            },

            {
                text = "SP",
                color = {255, 195, 195, 255},
                val_x = 22,
                ignore_add = true,
                bool = ui.get(menu.force_safe)
            },
        }

        local x = center[1] - 1 + adjust_pos_x
        local start_y = y + 46;

        for idx, indicator in pairs(xo_indicators) do
            local alpha_mod = indicator.custom_alpha or 255
            local indicator_alpha = animations:animate(string.format('xo2_%s', idx), not indicator.bool, 4) * alpha_mod * alpha.legacy / 255
            if indicator_alpha > 0.01 then
                local val_x = indicator.val_x or 0
                renderer.text(x + val_x, start_y, indicator.color[1], indicator.color[2], indicator.color[3], indicator_alpha, "-c", 0, indicator.text)
                if not indicator.ignore_add then
                    start_y = start_y + 8 * indicator_alpha / 255;
                end
            end
        end
    end

    if alpha.bloom > 0.01 then
        render.colortext(center[1], center[2] + 24, "-", {
            {"XO-YAW  ", col.indicator[1], col.indicator[2], col.indicator[3], alpha.bloom},
            {var.build:upper(), col.indicator2[1], col.indicator2[2], col.indicator2[3], math.max(breathe(0, 2.5), 0.2) * alpha.bloom},
        }, 1);

        local build_x = var.build == "alpha" and 3 or -2

        renderer.rectangle(center[1] + 1, center[2] + 35, 46 + build_x, 5, 17, 17, 17, col.indicator[4] * alpha.bloom / 255)
        renderer.gradient(center[1] + 2, center[2] + 36, math.min(1.0, math.abs(руль) / 58) * 45 + build_x, 3, col.indicator[1], col.indicator[2], col.indicator[3], alpha.bloom, col.indicator[1], col.indicator[2], col.indicator[3], 0, true)

        dt_r = helpers.lerp(dt_r, charge and 255 or 255, 0.05);
        dt_g = helpers.lerp(dt_g, charge and 255 or 75, 0.05);
        dt_b = helpers.lerp(dt_b, charge and 255 or 75, 0.05);

        local xo_indicators =
        {
            {
                text = "PING",
                color = {143, 194, 21, 255},
                bool = pingspike_ref and pingspike_hotkey
            },
            {
                text = "ROLL",
                color = {251, 161, 166, 255},
                bool = var.rollroyse,
            },
            {
                text = "DOUBLETAP",
                color = {dt_r, dt_g, dt_b, 255},
                bool = ui.get(menu.doubletap[1]) and ui.get(menu.doubletap[2]),
            },
            {
                text = "ONSHOT",
                color = {167, 188, 233, 255},
                bool = ui.get(menu.onshot[1]) and ui.get(menu.onshot[2]),
            },
            {
                text = "FREESTAND",
                color = {132, 210, 16, 255},
                bool = ui.get(lua.freestanding),
            },
            {
                text = "BAIM",
                color = {255, 75, 75, 255},
                bool = ui.get(menu.force_body),
            },
            {
                text = "DMG",
                color = {255, 255, 255, 255},
                bool = ui.get(menu.damage_bind[1]) and ui.get(menu.damage_bind[2])
            },
        }

        local x = center[1]
        local start_y = y + 40;

        for idx, indicator in pairs(xo_indicators) do
            local alpha_mod = indicator.custom_alpha or 255
            local indicator_alpha = animations:animate(string.format('xo3_%s', idx), not indicator.bool, 4) * alpha_mod * alpha.bloom / 255
            if indicator_alpha > 0.01 then
                renderer.text(x, start_y, indicator.color[1], indicator.color[2], indicator.color[3], indicator_alpha, "-", 0, indicator.text)
                start_y = start_y + 10 * indicator_alpha / 255;
            end
        end
    end

    if alpha.arrows_def > 0.01 then
        alpha.arrows_def = alpha.arrows_def * alpha.scope_arrows
	    renderer.text(center[1] - 43, center[2] - 3, col.arrows[1], col.arrows[2], col.arrows[3], alpha.arrows_def / 255 * col.arrows[4], "c+", 0, "‹" )
        renderer.text(center[1] - 43, center[2] - 3, col.arrows2[1], col.arrows2[2], col.arrows2[3], alpha.arrows_def / 255 * alpha.left, "c+", 0, "‹" )

        renderer.text(center[1] + 43, center[2] - 3, col.arrows[1], col.arrows[2], col.arrows[3], alpha.arrows_def / 255 * col.arrows[4], "c+", 0, "›" )
        renderer.text(center[1] + 43, center[2] - 3, col.arrows2[1], col.arrows2[2], col.arrows2[3], alpha.arrows_def / 255 * alpha.right, "c+", 0, "›" )
	end

    if alpha.arrows_tri > 0.01 then
        alpha.arrows_tri = alpha.arrows_tri * alpha.scope_arrows
        renderer.triangle(center[1] - 40, center[2], center[1] - 30, center[2] - 6, center[1] - 30, center[2] + 6, col.arrows[1], col.arrows[2], col.arrows[3], alpha.arrows_tri / 255 * col.arrows[4])
        renderer.triangle(center[1] - 40, center[2], center[1] - 30, center[2] - 6, center[1] - 30, center[2] + 6, col.arrows2[1], col.arrows2[2], col.arrows2[3], alpha.arrows_tri / 255 * alpha.left)

        renderer.triangle(center[1] + 40, center[2], center[1] + 30, center[2] - 6, center[1] + 30, center[2] + 6, col.arrows[1], col.arrows[2], col.arrows[3], alpha.arrows_tri / 255 * col.arrows[4])
        renderer.triangle(center[1] + 40, center[2], center[1] + 30, center[2] - 6, center[1] + 30, center[2] + 6, col.arrows2[1], col.arrows2[2], col.arrows2[3], alpha.arrows_tri / 255 * alpha.right)
    end
end

-- *demyaha: miscellaneous
local function misc()
    local localplayer = entity.get_local_player();
    if not localplayer or not entity.is_alive(localplayer) then return end
    if ui.get(lua.leg_movement) then
        if (bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 1) then
            local legs = math.random(0, 1);
            if legs == 1 then
                ui.set(menu.legmovement, "Always Slide");
            elseif legs == 1 then
                ui.set(menu.legmovement, "Never Slide");
            end
        end
    end

    -- *demyaha: ebat a naxuya dolbaeb
    ui.set(lua.manual_left, "On hotkey");
    ui.set(lua.manual_right, "On hotkey");
    ui.set(lua.manual_reset, "On hotkey");

    if ui.get(lua.freestanding) and var.mode == nil and not var.legit_aa then
        ui.set(menu.freestand[1], true);
        ui.set(menu.freestand[2], "Always On");
    else
        ui.set(menu.freestand[1], false);
        ui.set(menu.freestand[2], "On hotkey");
    end

    if ui.get(lua.edge_yaw) and var.mode == nil then
        ui.set(menu.edge_yaw, true);
    else
        ui.set(menu.edge_yaw, false);
    end
end

-- *demyaha: clantag
local function clantag()
    local localplayer = entity.get_local_player();
    if not localplayer then return end

    if ui.get(lua.clantag) then
        ui.set(menu.clantag, false)
        local tag = {
            "    xo-yaw.lua    ",
            "    xo-yaw.lua    ",
            "    xo-yaw.lua    ",
            "    xo-yaw.lua    ",
            "    xo-yaw.lua    ",
            "    xo-yaw.lua    ",
            "    xo-yaw.lua    ",
            "    xo-yaw.lua    ",
            "    xo-yaw.lua    ",
            "    o-yaw.lua    ",
            "    -yaw.lua    ",
            "    yaw.lua    ",
            "    aw.lua    ",
            "    w.lua    ",
            "    .lua    ",
            "    lua    ",
            "    ua    ",
            "    a    ",
            "        ",
            "    xo    ",
            "    xo-    ",
            "    xo-y    ",
            "    xo-ya    ",
            "    xo-yaw    ",
            "    xo-yaw.    ",
            "    xo-yaw.l    ",
            "    xo-yaw.lu    ",
            "    xo-yaw.lua    ",
            "    xo-yaw.lua    ",
            "    xo-yaw.lua    ",
            "    xo-yaw.lua    ",
            "    xo-yaw.lua    ",
        }

        local latency = client.latency() / globals.tickinterval();
        local tickcount_pred = globals.tickcount() + latency;
        local cur = math.floor(math.fmod(tickcount_pred / 16, #tag) + 1);

        helpers:set_clantag(tag[cur])
        var.clantag_restore = false;

    elseif not var.clantag_restore then
        helpers:set_clantag("")
    end
end

-- *demyaha: trashtalk
local function trashtalk(e)
    local localplayer = entity.get_local_player()
    if not localplayer or not entity.is_alive(localplayer) then return end

    if ui.get(lua.trashtalk) then
        local sms = (msg[math.random(#msg)])
        local victim_userid, attacker_userid = e.userid, e.attacker
        if victim_userid == nil or attacker_userid == nil then
        	return
        end

        local victim_entindex = client.userid_to_entindex(victim_userid)
        local attacker_entindex = client.userid_to_entindex(attacker_userid)

        if attacker_entindex == localplayer and entity.is_enemy(victim_entindex) then
        	client.exec("say " .. sms)
        end
    end
end

local function mishkatiki_prigaut(cmd)
    local localplayer = entity.get_local_player()
    if not localplayer or not entity.is_alive(localplayer) then return end
    local state = helpers:get_player_state(localplayer);
    if ui.get(lua.force_defensive_bratka) then
        if state:find("Air") then
            if ui.get(menu.doubletap[1]) and ui.get(menu.doubletap[2]) then
                local charged_dt = helpers.doubletap_charged();
                if charged_dt then
                    cmd.force_defensive = 1;
                    cmd.no_choke = 1;
                    cmd.quick_stop = 1;
                end
            end
        end
    end
end

client.set_event_callback("player_connect_full", function (e)
    local localplayer = entity.get_local_player();
    local event_player = client.userid_to_entindex(e.userid);

    if localplayer == event_player then
        sway_manager.data = { };
        flick_manager.data = { };
    end
end);

client.set_event_callback("pre_render", function ()
    local localplayer = entity.get_local_player();
    if not localplayer or not entity.is_alive(localplayer) then return end
    local velocity = helpers.get_velocity(localplayer);
    if ui.get(lua.leg_movement) and velocity > 100 then
		local on_ground = bit.band(entity.get_prop(localplayer, "m_fFlags"), 1) == 1;
        local m_choked = globals.chokedcommands();
		entity.set_prop(localplayer, "m_flPoseParameter", 1, not on_ground and 6 or m_choked == 0 and math.random(0, 1) or 0)
    end
end)

-- * config system
-- ylregar*: 30.05 updated
function ConfigSystem:Warn(Message, ...)
    client.error_log(Message:format(...));
end

function ConfigSystem:Export(Aliases)
    local ExportTable = { };

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

function ConfigSystem:Import(Aliases, Data)
    local SuccessfulyDecoded, DecodedData = pcall(base_64.decode, Data);

    if not SuccessfulyDecoded then
        self:Warn("Loaded config was unable to decode.");
        return;
    end

    local SuccessfulyParsed, ImportTable = pcall(json.parse, DecodedData);

    if not SuccessfulyParsed then
        self:Warn("Loaded config was unable to parse.");
        return;
    end

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
                        self:Warn("Loaded config was containing function that was not found ( %s )", FunctionOrTableKey);
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
                                    self:Warn("Loaded config was containing function that was not found ( %s->%s )", FunctionOrTableKey, ExtendedTableKey);
                                end
                            else
                                self:Warn("Loaded config was containing extended table that was not found ( %s )", FunctionOrTableKey);
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
                                        self:Warn("Loaded config was containing function that was not found ( %s->%s->%s )", FunctionOrTableKey, ExtendedTableKey, ExtendedTableKeyRecursive);
                                    end
                                else
                                    self:Warn("Loaded config was containing extended table that was not found ( %s->%s )", FunctionOrTableKey, ExtendedTableKey);
                                end
                            end
                        end
                    end
                end
            else
                self:Warn("Loaded config was containing menu table that was not found ( %s )", MenuTableName);
            end
        end
    end
end

local default = ui.new_button("AA", "Anti-aimbot angles", "Load Default Config", function ()
    local ConfigStream = "eyJBbnRpYWltIjp7IkR1Y2tpbmciOnsic3BhY2VfdXBwaW5nIjpbIiJdLCJwaXRjaCI6WyJNaW5pbWFsIl0sImZha2V5YXdfbGltaXQiOls1OF0sImJvZHlfeWF3IjpbIkppdHRlciJdLCJmYWtleWF3X21vZGUiOlsiU3RhdGljIl0sInlhd19hbW91bnRfbW9kaWZpZXIiOnsic3BlZWQiOlsxXSwiZW5kX2RlZ3JlZSI6WzBdLCJkZWxheSI6WzFdLCJzdGFydF9kZWdyZWUiOlswXX0sInNwYWNlX2Rvd25pY2giOlsiIl0sInlhd19qaXR0ZXIiOlsiQ2VudGVyIl0sInlhd19tb2RlIjpbIllhdyBBZGQiXSwiYm9keV95YXdfYW1vdW50IjpbMF0sInBpdGNoX2N1c3RvbSI6Wzg5XSwieWF3X2FkZF9sZWZ0IjpbLTEwXSwieWF3X2Ftb3VudCI6WzBdLCJ5YXdfYWRkX3JpZ2h0IjpbMjZdLCJzcGFjZV9kb3duIjpbIjw+PD48Pjw+PD5lZGl0aW5nPD48Pjw+PD48PiJdLCJzcGFjZV91cCI6WyI8Pjw+PD48Pjw+ZWRpdGluZzw+PD48Pjw+PD4iXSwieWF3X2ppdHRlcl9zY2FsZSI6WzMwXSwiZmFrZXlhd19tb2RpZmllciI6eyJzcGVlZCI6WzFdLCJlbmRfZGVncmVlIjpbMF0sImRlbGF5IjpbMV0sInN0YXJ0X2RlZ3JlZSI6WzBdfX0sIkFpciI6eyJzcGFjZV91cHBpbmciOlsiIl0sInBpdGNoIjpbIk1pbmltYWwiXSwiZmFrZXlhd19saW1pdCI6WzU4XSwiYm9keV95YXciOlsiSml0dGVyIl0sImZha2V5YXdfbW9kZSI6WyJTd2F5Il0sInlhd19hbW91bnRfbW9kaWZpZXIiOnsic3BlZWQiOls2NF0sImVuZF9kZWdyZWUiOlsyN10sImRlbGF5IjpbMl0sInN0YXJ0X2RlZ3JlZSI6Wy0yOF19LCJzcGFjZV9kb3duaWNoIjpbIiJdLCJ5YXdfaml0dGVyIjpbIkNlbnRlciJdLCJ5YXdfbW9kZSI6WyJSYW5kb21pemVkIl0sImJvZHlfeWF3X2Ftb3VudCI6WzBdLCJwaXRjaF9jdXN0b20iOls4OV0sInlhd19hZGRfbGVmdCI6Wy02XSwieWF3X2Ftb3VudCI6WzBdLCJ5YXdfYWRkX3JpZ2h0IjpbOV0sInNwYWNlX2Rvd24iOlsiPD48Pjw+PD48PmVkaXRpbmc8Pjw+PD48Pjw+Il0sInNwYWNlX3VwIjpbIjw+PD48Pjw+PD5lZGl0aW5nPD48Pjw+PD48PiJdLCJ5YXdfaml0dGVyX3NjYWxlIjpbMjddLCJmYWtleWF3X21vZGlmaWVyIjp7InNwZWVkIjpbMzJdLCJlbmRfZGVncmVlIjpbNDRdLCJkZWxheSI6WzJdLCJzdGFydF9kZWdyZWUiOls1XX19LCJTbG93d2Fsa2luZyI6eyJzcGFjZV91cHBpbmciOlsiIl0sInBpdGNoIjpbIk1pbmltYWwiXSwiZmFrZXlhd19saW1pdCI6WzU4XSwiYm9keV95YXciOlsiU3RhdGljIl0sImZha2V5YXdfbW9kZSI6WyJTdGF0aWMiXSwieWF3X2Ftb3VudF9tb2RpZmllciI6eyJzcGVlZCI6WzFdLCJlbmRfZGVncmVlIjpbMF0sImRlbGF5IjpbMV0sInN0YXJ0X2RlZ3JlZSI6WzBdfSwic3BhY2VfZG93bmljaCI6WyIiXSwieWF3X2ppdHRlciI6WyJDZW50ZXIiXSwieWF3X21vZGUiOlsiWWF3IEFkZCJdLCJib2R5X3lhd19hbW91bnQiOlswXSwicGl0Y2hfY3VzdG9tIjpbODldLCJ5YXdfYWRkX2xlZnQiOlstMjJdLCJ5YXdfYW1vdW50IjpbMF0sInlhd19hZGRfcmlnaHQiOlsyMl0sInNwYWNlX2Rvd24iOlsiPD48Pjw+PD48PmVkaXRpbmc8Pjw+PD48Pjw+Il0sInNwYWNlX3VwIjpbIjw+PD48Pjw+PD5lZGl0aW5nPD48Pjw+PD48PiJdLCJ5YXdfaml0dGVyX3NjYWxlIjpbNTRdLCJmYWtleWF3X21vZGlmaWVyIjp7InNwZWVkIjpbMV0sImVuZF9kZWdyZWUiOlswXSwiZGVsYXkiOlsxXSwic3RhcnRfZGVncmVlIjpbMF19fSwiQWlyICsgRHVja2luZyI6eyJzcGFjZV91cHBpbmciOlsiIl0sInBpdGNoIjpbIk1pbmltYWwiXSwiZmFrZXlhd19saW1pdCI6WzU4XSwiYm9keV95YXciOlsiU3RhdGljIl0sImZha2V5YXdfbW9kZSI6WyJTd2F5Il0sInlhd19hbW91bnRfbW9kaWZpZXIiOnsic3BlZWQiOls2NF0sImVuZF9kZWdyZWUiOlsxNF0sImRlbGF5IjpbMl0sInN0YXJ0X2RlZ3JlZSI6Wy05XX0sInNwYWNlX2Rvd25pY2giOlsiIl0sInlhd19qaXR0ZXIiOlsiQ2VudGVyIl0sInlhd19tb2RlIjpbIlN3YXkiXSwiYm9keV95YXdfYW1vdW50IjpbMF0sInBpdGNoX2N1c3RvbSI6Wzg5XSwieWF3X2FkZF9sZWZ0IjpbMTZdLCJ5YXdfYW1vdW50IjpbOF0sInlhd19hZGRfcmlnaHQiOlsxNF0sInNwYWNlX2Rvd24iOlsiPD48Pjw+PD48PmVkaXRpbmc8Pjw+PD48Pjw+Il0sInNwYWNlX3VwIjpbIjw+PD48Pjw+PD5lZGl0aW5nPD48Pjw+PD48PiJdLCJ5YXdfaml0dGVyX3NjYWxlIjpbMzJdLCJmYWtleWF3X21vZGlmaWVyIjp7InNwZWVkIjpbNjRdLCJlbmRfZGVncmVlIjpbNDldLCJkZWxheSI6WzJdLCJzdGFydF9kZWdyZWUiOlsxOF19fSwiRGVmZW5zaXZlIjp7InNwYWNlX3VwcGluZyI6WyIiXSwicGl0Y2giOlsiRGVmYXVsdCJdLCJmYWtleWF3X2xpbWl0IjpbMF0sImJvZHlfeWF3IjpbIlN0YXRpYyJdLCJmYWtleWF3X21vZGUiOlsiU3RhdGljIl0sInlhd19hbW91bnRfbW9kaWZpZXIiOnsic3BlZWQiOlsxXSwiZW5kX2RlZ3JlZSI6WzBdLCJkZWxheSI6WzFdLCJzdGFydF9kZWdyZWUiOlswXX0sInNwYWNlX2Rvd25pY2giOlsiIl0sInlhd19qaXR0ZXIiOlsiT2Zmc2V0Il0sInlhd19tb2RlIjpbIllhdyBBZGQiXSwiYm9keV95YXdfYW1vdW50IjpbLTE4MF0sInBpdGNoX2N1c3RvbSI6Wzg5XSwieWF3X2FkZF9sZWZ0IjpbLTE4MF0sInlhd19hbW91bnQiOlswXSwieWF3X2FkZF9yaWdodCI6WzE4MF0sInNwYWNlX2Rvd24iOlsiPD48Pjw+PD48PmVkaXRpbmc8Pjw+PD48Pjw+Il0sInNwYWNlX3VwIjpbIjw+PD48Pjw+PD5lZGl0aW5nPD48Pjw+PD48PiJdLCJ5YXdfaml0dGVyX3NjYWxlIjpbLTE4MF0sImZha2V5YXdfbW9kaWZpZXIiOnsic3BlZWQiOlsxXSwiZW5kX2RlZ3JlZSI6WzBdLCJkZWxheSI6WzFdLCJzdGFydF9kZWdyZWUiOlswXX19LCJSdW5uaW5nIjp7InNwYWNlX3VwcGluZyI6WyIiXSwicGl0Y2giOlsiTWluaW1hbCJdLCJmYWtleWF3X2xpbWl0IjpbNThdLCJib2R5X3lhdyI6WyJKaXR0ZXIiXSwiZmFrZXlhd19tb2RlIjpbIlN3YXkiXSwieWF3X2Ftb3VudF9tb2RpZmllciI6eyJzcGVlZCI6WzY0XSwiZW5kX2RlZ3JlZSI6WzIxXSwiZGVsYXkiOlsxXSwic3RhcnRfZGVncmVlIjpbLTE0XX0sInNwYWNlX2Rvd25pY2giOlsiIl0sInlhd19qaXR0ZXIiOlsiQ2VudGVyIl0sInlhd19tb2RlIjpbIllhdyBBZGQiXSwiYm9keV95YXdfYW1vdW50IjpbMF0sInBpdGNoX2N1c3RvbSI6Wzg5XSwieWF3X2FkZF9sZWZ0IjpbLThdLCJ5YXdfYW1vdW50IjpbMF0sInlhd19hZGRfcmlnaHQiOlsxNF0sInNwYWNlX2Rvd24iOlsiPD48Pjw+PD48PmVkaXRpbmc8Pjw+PD48Pjw+Il0sInNwYWNlX3VwIjpbIjw+PD48Pjw+PD5lZGl0aW5nPD48Pjw+PD48PiJdLCJ5YXdfaml0dGVyX3NjYWxlIjpbMjRdLCJmYWtleWF3X21vZGlmaWVyIjp7InNwZWVkIjpbNDRdLCJlbmRfZGVncmVlIjpbMjhdLCJkZWxheSI6WzJdLCJzdGFydF9kZWdyZWUiOlsxMl19fSwiU3RhbmRpbmciOnsic3BhY2VfdXBwaW5nIjpbIiJdLCJwaXRjaCI6WyJNaW5pbWFsIl0sImZha2V5YXdfbGltaXQiOls1OF0sImJvZHlfeWF3IjpbIk9wcG9zaXRlIl0sImZha2V5YXdfbW9kZSI6WyJTdGF0aWMiXSwieWF3X2Ftb3VudF9tb2RpZmllciI6eyJzcGVlZCI6WzY0XSwiZW5kX2RlZ3JlZSI6WzI4XSwiZGVsYXkiOlszXSwic3RhcnRfZGVncmVlIjpbLTI4XX0sInNwYWNlX2Rvd25pY2giOlsiIl0sInlhd19qaXR0ZXIiOlsiQ2VudGVyIl0sInlhd19tb2RlIjpbIllhdyBBZGQiXSwiYm9keV95YXdfYW1vdW50IjpbMF0sInBpdGNoX2N1c3RvbSI6Wzg5XSwieWF3X2FkZF9sZWZ0IjpbLTVdLCJ5YXdfYW1vdW50IjpbMF0sInlhd19hZGRfcmlnaHQiOlszXSwic3BhY2VfZG93biI6WyI8Pjw+PD48Pjw+ZWRpdGluZzw+PD48Pjw+PD4iXSwic3BhY2VfdXAiOlsiPD48Pjw+PD48PmVkaXRpbmc8Pjw+PD48Pjw+Il0sInlhd19qaXR0ZXJfc2NhbGUiOlsxNV0sImZha2V5YXdfbW9kaWZpZXIiOnsic3BlZWQiOls2NF0sImVuZF9kZWdyZWUiOls2MF0sImRlbGF5IjpbMV0sInN0YXJ0X2RlZ3JlZSI6WzRdfX19LCJBbnRpYWltU2VsZWN0b3IiOnsiRHVja2luZyI6eyJzZWxlY3RlZF9tb2RlIjpbIkN1c3RvbSJdLCJjdXN0b21pemUiOltmYWxzZV19LCJBaXIiOnsic2VsZWN0ZWRfbW9kZSI6WyJDdXN0b20iXSwiY3VzdG9taXplIjpbZmFsc2VdfSwiU2xvd3dhbGtpbmciOnsic2VsZWN0ZWRfbW9kZSI6WyJDdXN0b20iXSwiY3VzdG9taXplIjpbZmFsc2VdfSwiQWlyICsgRHVja2luZyI6eyJzZWxlY3RlZF9tb2RlIjpbIkN1c3RvbSJdLCJjdXN0b21pemUiOltmYWxzZV19LCJEZWZlbnNpdmUiOnsic2VsZWN0ZWRfbW9kZSI6WyJJbmhlcml0Il0sImN1c3RvbWl6ZSI6W2ZhbHNlXX0sIlJ1bm5pbmciOnsic2VsZWN0ZWRfbW9kZSI6WyJDdXN0b20iXSwiY3VzdG9taXplIjpbZmFsc2VdfSwiU3RhbmRpbmciOnsic2VsZWN0ZWRfbW9kZSI6WyJDdXN0b20iXSwiY3VzdG9taXplIjpbZmFsc2VdfX0sIk90aGVyIjp7Im1hbnVhbF9sZWZ0IjpbZmFsc2UsMV0sImFycm93c19jb2xvcjIiOlsyMDgsMjA4LDI0OSwyNTVdLCJpbmRpY2F0b3JzX3NwZWVkIjpbMTE5XSwibWFudWFsX3JpZ2h0IjpbZmFsc2UsMV0sImFudGlhaW1fYWRkaXRpb25hbHMiOltbIk1hbnVhbCBBbnRpIEFpbSIsIkxlZ2l0IEFBIG9uIFVzZSIsIkFudGkgQmFja3N0YWIiXV0sImluZGljYXRvcnMiOlsiTGVnYWN5Il0sImxlZ19tb3ZlbWVudCI6W3RydWVdLCJyb2xsX2tleSI6W3RydWUsMSwxXSwiZGFtYWdlX2JpbmQiOltmYWxzZSwxLDZdLCJhZGp1c3RfYXJyb3dzX3Njb3BlIjpbZmFsc2VdLCJlZGdlX3lhdyI6W2ZhbHNlLDFdLCJhcnJvd3MiOlsiVHJpYW5nbGUiXSwid2F0ZXJtYXJrIjpbZmFsc2VdLCJ3YXRlcm1hcmtfY29sb3IiOls5Myw2NCw5OCwxMTJdLCJyb2xsX2FhIjpbWyJNYW51YWwgQW50aSBBaW0iXV0sImNsYW50YWciOlt0cnVlXSwiZnJlZXN0YW5kaW5nIjpbZmFsc2UsMSwxOF0sIndhdGVybWFya19yb3VuZCI6WzVdLCJpbmRpY2F0b3JzX2NvbG9yMiI6WzE3NiwxNzYsMTc2LDI1NV0sInRyYXNodGFsayI6W3RydWVdLCJmb3JjZV9kZWZlbnNpdmVfYnJhdGthIjpbdHJ1ZV0sIm1hbnVhbF9yZXNldCI6W2ZhbHNlLDFdLCJhZGp1c3RfaW5kX3BvcyI6W3RydWVdLCJhZGp1c3RfZmFrZWxhZyI6W3RydWVdLCJhcnJvd3NfY29sb3IiOlszMCwzMCwzMCw2M10sImJsdXIiOltmYWxzZV0sImluZGljYXRvcnNfY29sb3IiOlsxNjcsMTQzLDE5NywyNTVdfX0="
    ConfigSystem:Import({
        Antiaim = lua_custom_aa,
        AntiaimSelector = small_stash_difors,
        Other = lua
    }, ConfigStream);
end)

local import = ui.new_button("AA", "Anti-aimbot angles", "Import Config", function ()
    local ConfigStream = clipboard.get();

    ConfigSystem:Import({
        Antiaim = lua_custom_aa,
        AntiaimSelector = small_stash_difors,
        Other = lua
    }, ConfigStream);
end)

local export = ui.new_button("AA", "Anti-aimbot angles", "Export Config", function ()
    local ConfigStream = ConfigSystem:Export({
        Antiaim = lua_custom_aa,
        AntiaimSelector = small_stash_difors,
        Other = lua
    });

    clipboard.set(ConfigStream);
end)

client.set_event_callback("player_death", trashtalk)

ui.set_callback(lua.adjust_fakelag, function()
    if not ui.get(lua.adjust_fakelag) then
        ui.set(menu.fakelag_limit, 15)
    end
end)

client.set_event_callback("paint_ui", function ()
    visual();
    clantag();
    visibility_custom();

    ui.set_visible(menu.enabled, true);
    ui.set_visible(menu.pitch[1], false);
    ui.set_visible(menu.pitch[2], false);
    ui.set_visible(menu.yaw_base, false);
    ui.set_visible(menu.yaw[1], false);
    ui.set_visible(menu.yaw[2], false);
    ui.set_visible(menu.yaw_jitter[1], false);
    ui.set_visible(menu.yaw_jitter[2], false);
    ui.set_visible(menu.body_yaw[1], false);
    ui.set_visible(menu.body_yaw[2], false);
    ui.set_visible(menu.freestanding_body_yaw, false);
    ui.set_visible(menu.edge_yaw, false);
    ui.set_visible(menu.freestand[1], false);
    ui.set_visible(menu.freestand[2], false);
    ui.set_visible(menu.roll, false);
    ui.set_visible(menu.legmovement, true);
    ui.set_visible(menu.fakelag_limit, true);

    ui.set_visible(lua.antiaim_additionals, current_tab == "antiaim");
    ui.set_visible(lua.roll_aa, current_tab == "antiaim" and getcombo(lua.antiaim_additionals, "Roll AA"));
    ui.set_visible(lua.roll_key, current_tab == "antiaim" and getcombo(lua.antiaim_additionals, "Roll AA") and getcombo(lua.roll_aa, "On-key"));
    ui.set_visible(lua.manual_left, current_tab == "antiaim" and getcombo(lua.antiaim_additionals, "Manual Anti Aim"));
    ui.set_visible(lua.manual_right, current_tab == "antiaim" and getcombo(lua.antiaim_additionals, "Manual Anti Aim"));
    ui.set_visible(lua.manual_reset, current_tab == "antiaim" and getcombo(lua.antiaim_additionals, "Manual Anti Aim"));
    ui.set_visible(lua.freestanding, current_tab == "antiaim");
    ui.set_visible(lua.edge_yaw, current_tab == "antiaim");
    ui.set_visible(lua.adjust_fakelag, current_tab == "antiaim");

    ui.set_visible(lua.arrows, current_tab == "visual");
    ui.set_visible(lua.arrows_color, current_tab == "visual" and not (ui.get(lua.arrows) == "Disabled"));
    ui.set_visible(lua.arrows_color2, current_tab == "visual" and not (ui.get(lua.arrows) == "Disabled"));
    ui.set_visible(lua.indicators, current_tab == "visual");
    ui.set_visible(lua.indicators_color, current_tab == "visual" and not (ui.get(lua.indicators) == "Disabled"));
    ui.set_visible(lua.indicators_color2, current_tab == "visual" and not (ui.get(lua.indicators) == "Disabled"));
    ui.set_visible(lua.indicators_speed, current_tab == "visual" and (ui.get(lua.indicators) == "Default"));
    ui.set_visible(lua.adjust_ind_pos, current_tab == "visual" and ui.get(lua.indicators) == "Default" or current_tab == "visual" and ui.get(lua.indicators) == "Legacy");
    ui.set_visible(lua.adjust_arrows_scope, current_tab == "visual" and ui.get(lua.arrows) ~= "Disabled");
    ui.set_visible(lua.blur, current_tab == "visual");
    ui.set_visible(lua.watermark, current_tab == "visual");
    ui.set_visible(lua.watermark_color, current_tab == "visual" and ui.get(lua.watermark));
    ui.set_visible(lua.watermark_round, current_tab == "visual" and ui.get(lua.watermark));

    ui.set_visible(lua.leg_movement, current_tab == "misc");
    ui.set_visible(lua.clantag, current_tab == "misc");
    ui.set_visible(lua.trashtalk, current_tab == "misc");
    ui.set_visible(lua.бездарность, current_tab == "misc");
    ui.set_visible(lua.force_defensive_bratka, current_tab == "misc");

    ui.set_visible(g_tab, current_tab == "global")
    ui.set_visible(default, current_tab == "global")
    ui.set_visible(import, current_tab == "global")
    ui.set_visible(export, current_tab == "global")

    for button_name, menu_id in pairs(menu_buttons) do
        if button_name == "back" then
            ui.set_visible(menu_id, current_tab ~= "global");
        else
            ui.set_visible(menu_id, current_tab == "global");
        end
    end
end)

client.set_event_callback("setup_command", function (cmd)
    antiaim(cmd)
    mishkatiki_prigaut(cmd)
    misc()

    if globals.chokedcommands() == 0 then
        var.switch = not var.switch
    end

end)

local save_local_config = function ()
    writefile('xo-yaw.cfg', ConfigSystem:Export({
        Antiaim = lua_custom_aa,
        AntiaimSelector = small_stash_difors,
        Other = lua
    }));
end

local load_local_config = function ()
    if readfile('xo-yaw.cfg') then
        ConfigSystem:Import({
            Antiaim = lua_custom_aa,
            AntiaimSelector = small_stash_difors,
            Other = lua
        }, readfile('xo-yaw.cfg'));
    end
end

load_local_config();

client.set_event_callback("shutdown", function ()
    ui.set(menu.fakelag_limit, backup.fakelag_limit)
    print("Saved latest config")
    handle_aa("Minimal", 0, "At targets", "180", 0, "Off", 0, "Static", 0, 60, false)
    ui.set_visible(menu.enabled, true)
    ui.set_visible(menu.pitch[1], true)
    ui.set_visible(menu.pitch[2], true)
    ui.set_visible(menu.yaw_base, true)
    ui.set_visible(menu.yaw[1], true)
    ui.set_visible(menu.yaw[2], true)
    ui.set_visible(menu.yaw_jitter[1], true)
    ui.set_visible(menu.yaw_jitter[2], true)
    ui.set_visible(menu.body_yaw[1], true)
    ui.set_visible(menu.body_yaw[2], true)
    ui.set_visible(menu.freestanding_body_yaw, true)
    ui.set_visible(menu.edge_yaw, true)
    ui.set_visible(menu.freestand[1], true)
    ui.set_visible(menu.freestand[2], true)
    ui.set_visible(menu.roll, true)
    ui.set_visible(menu.legmovement, true)

    save_local_config();

    helpers:set_clantag("")
end);