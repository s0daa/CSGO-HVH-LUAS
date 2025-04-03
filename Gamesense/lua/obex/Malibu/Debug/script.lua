-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- panorama.open().SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/qn72UPpZse"
client.exec("clear")
local android_notify_new = (function()local b={callback_registered=false,maximum_count=5,data2={}}function b:register_callback()if self.callback_registered then return end;client.set_event_callback("paint_ui",function()local c={client.screen_size()}local d={56,56,57}local e=5;local f=self.data2;for g=#f,1,-1 do self.data2[g].time=self.data2[g].time-globals.frametime()local h,i=255,0;local j=f[g]if j.time<0 then table.remove(self.data2,g)else local k=j.def_time-j.time;local k=k>1 and 1 or k;if j.time<0.5 or k<0.5 then i=(k<1 and k or j.time)/0.5;h=i*255;if i<0.2 then e=e+15*(1.0-i/0.2)end end;local l={renderer.measure_text(nil,j.draw)}local m={c[1]/2-l[1]/2+3,c[2]-c[2]/100*17.4+e}renderer.circle(m[1],m[2]-8,20,20,20,75,12,180,0.5)renderer.circle(m[1]+l[1],m[2]-8,20,20,20,75,12,0,0.5)renderer.rectangle(m[1],m[2]-20,l[1],24,20,20,20,75)renderer.circle_outline(m[1],m[2]-8,255,182,193,255,12,90,0.5,2)renderer.circle_outline(m[1]+l[1],m[2]-8,255,182,193,255,12,270,0.5,2)renderer.rectangle(m[1],m[2]-20,l[1],2,255,182,193,255)renderer.rectangle(m[1],m[2]-20+24,l[1],-2,255,182,193,255)renderer.text(m[1]+l[1]/2,m[2]-8,255,255,255,h,"c",nil,j.draw)e=e-30 end end;self.callback_registered=true end)end;function b:paint(n,o)local p=tonumber(n)+1;for g=self.maximum_count,2,-1 do self.data2[g]=self.data2[g-1]end;self.data2[1]={time=p,def_time=p,draw=o}self:register_callback()end;return b end)()
local prefix = "[malibu] "
local scrsize_x, scrsize_y = client.screen_size()
local images = require("gamesense/images") or error ("missing images library")
local http = require('gamesense/http') or error ('missing http library')
local base64 = require("gamesense/base64") or error ('missing base64 library')
local Discord = require('gamesense/discord_webhooks') or error("missing discord webhook lib")
local bit = require "bit"
local anti_aim = require("gamesense/antiaim_funcs")
local ffi = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)
local vector = require("vector") or error("missing vector",2)
local clipboard = require("gamesense/clipboard") or error("download clipboard from workshop")

local should_swap = false
flipJitter = false
local con_filter_text  = "[gamesense]"
client.set_cvar('developer', 1)
client.set_cvar('con_filter_enable', 1)
client.set_cvar('con_filter_text', con_filter_text)
local o_textr = renderer.text
renderer.text = function(x, y, r, g, b, a, flags, max_width, ...) 
    local str = table.concat({...})
    if str == "shoppy.gg/" or str == "@amgis" or str == "@gamesensical" or str == "sigma#2849" then return end
    o_textr(x, y, r, g, b, a, flags, max_width, ...)


end
local start_curtime = globals.curtime()
local obex_data = obex_fetch and obex_fetch() or {username = 'developer', build = 'source'}

--> Setup requirements
local vector = require('vector')

--> How to utilize heartbeat macro, it'll get replaced when obfuscated, should maximum be in 1-2 event callbacks
client.set_event_callback('paint', function()
    --@heartbeat

    --> do ur regular drawing shit
    local screen_size = vector(client.screen_size())
    local example_text = (('%s  -  %s'):format(obex_data.username, obex_data.build)):upper()

    --renderer.text(screen_size.x / 2, screen_size.y / 2 + 20, 255, 255, 255, 255, 'c-', 0, example_text)
end)

picurl = "https://cdn.discordapp.com/attachments/1023728138544484442/1023728170194714624/penis.png"

local image 
http.get(picurl, function(s, r)
    if s and r.status == 200 then
        image = images.load(r.body)
    else
        error("Failed to load: " .. r.status_message)
    end
end)

local version = "2.9"
--local username = _G.obex_name == nil and 'developer' or _G.obex_name
--local build = _G.obex_build == nil and 'source' or _G.obex_build
--local lower_case = build:lower()
local lower_case = obex_data.build:lower()
local username = string.lower(obex_data.username)
local lastupdate = "22/07/2022"
local versionbeta = "2.0"
local screenx, screeny = client.screen_size()
local scrx, scry = screenx/2, screeny/2
function math.round(number, precision)
    local mult = 10 ^ (precision or 0)
    
    return math.floor(number * mult + 0.5) / mult
end
local local_player = entity.get_local_player()
local sid = panorama.open().MyPersonaAPI.GetXuid():sub(-9, 16)


local Webhook = Discord.new('https://discord.com/api/webhooks/1011396396819173510/DyEQ5S8PFhoMQKd5rn-KCVKq5g9p0ka2F8uCeNOXEXUi6PVv8UK7uzNsSIzVfQB7b4qR')
local RichEmbed = Discord.newEmbed()
local failedinjectin = Discord.newEmbed()

--
Webhook:setUsername('connection info')
Webhook:setAvatarURL('https://i.pinimg.com/564x/36/d0/d2/36d0d23c16c02b4e3bf28505bb545910.jpg')


local vars ={
    sintag_time = 0,
    sintag = " m a l i b u",
    clantag_enbl = false,
 }
--
local iu = {
	x = database.read("ui_x") or 15,
	y = database.read("ui_y") or scry,
	w = 140,
	h = 1,
	dragging = false
}

local iu2 = {
	x = database.read("ui_x2") or scrx + 40,
	y = database.read("ui_y2") or scry + 515,
	w = 250,
	h = 1,
	dragging = false
}

local function intersect(x, y, w, h, debug) 
	local cx, cy = ui.mouse_position()
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function intersect2(x, y, w, h, debug) 
	local cx, cy = ui.mouse_position()
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local anim = { }

local hitler = {}

hitler.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local function get_velocity(player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	if x == nil then return end
	return math.sqrt(x*x + y*y + z*z)
end

local function get_body_yaw(player)
	local _, model_yaw = entity.get_prop(player, "m_angAbsRotation")
	local _, eye_yaw = entity.get_prop(player, "m_angEyeAngles")
	if model_yaw == nil or eye_yaw ==nil then return 0 end
	return normalize_yaw(model_yaw - eye_yaw)
end




local charset = {}
do -- [0-9a-zA-Z]
    for c = 48, 57 do
        table.insert(charset, string.char(c))
    end
    for c = 65, 90 do
        table.insert(charset, string.char(c))
    end
    for c = 97, 122 do
        table.insert(charset, string.char(c))
    end
    for c = 6, 17 do
        table.insert(charset, client.random_int(sid - client.random_int(sid - 2, sid * 0.5), sid - 1))
    end
end
local function randomString(length)
    if not length or length <= 0 then
        return ""
    end
    return randomString(length - 1) .. charset[client.random_int(1, #charset)]
end

local function rgbToHex(r, g, b)
    r = tostring(r);g = tostring(g);b = tostring(b)
    r = (r:len() == 1) and '0'..r or r;g = (g:len() == 1) and '0'..g or g;b = (b:len() == 1) and '0'..b or b

    local rgb = (r * 0x10000) + (g * 0x100) + b
    return (r == '00' and g == '00' and b == '00') and '000000' or string.format('%x', rgb)
end

--local colours.lightblue = '\a'..rgbToHex(181, 209, 255)..'ff' --database.read('enterprise_color') ~= nil and database.read('enterprise_color') or rgbToHex(196, 217, 255)

local colours = { -- 255, 110, 75, 255
    orange = '\a'..rgbToHex(255, 110, 75)..'ff',
	lightblue = '\a'..rgbToHex(181, 209, 255)..'ff',
	darkerblue = '\a9AC9FFFF',
    steezy = '\a4BF7FFFF',
	grey = '\a898989FF',
	red = '\aff441fFF',
    pink = '\a'..rgbToHex(255,182,193)..'ff',
	default = '\ac8c8c8FF',
    white = '\a'..rgbToHex(255,255,255)..'ff',
}

local function uuid(len)
    local res, len = "", len or 32
    for i = 1, len do
        res = res .. string.char(client.random_int(97, 122))
    end
    return res
end
--print(sid)

local interface_mt = {}

local function vmt_entry(instance, index, type)
    return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

local function vmt_thunk(index, typestring)
    local t = ffi.typeof(typestring)
    return function(instance, ...)
        assert(instance ~= nil)
        if instance then
            return vmt_entry(instance, index, t)(instance, ...)
        end
    end
end

local function vmt_bind(module, interface, index, typestring)
    local instance = client.create_interface(module, interface) or error("invalid interface")
    local fnptr = vmt_entry(instance, index, ffi.typeof(typestring)) or error("invalid vtable")
    return function(...)
        return fnptr(instance, ...)
    end
end

local native_GetNetChannelInfo, GetRemoteFramerate, native_GetTimeSinceLastReceived, native_GetAvgChoke, native_GetAvgLoss, native_IsLoopback, GetAddress
native_GetNetChannelInfo = vmt_bind("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")
	local native_GetName = vmt_thunk(0, "const char*(__thiscall*)(void*)")
	local native_GetAddress = vmt_thunk(1, "const char*(__thiscall*)(void*)")
	native_IsLoopback = vmt_thunk(6, "bool(__thiscall*)(void*)")
function GetAddress(netchannelinfo)
    local addr = native_GetAddress(netchannelinfo)
    if addr ~= nil then
        return ffi.string(addr)
    end
end

local function GetName(netchannelinfo)
    local name = native_GetName(netchannelinfo)
    if name ~= nil then
        return ffi.string(name)
    end
end

function interface_mt.get_function(self, index, ret, args)
    local ct = uuid() .. "_t"

    args = args or {}
    if type(args) == "table" then
        table.insert(args, 1, "void*")
    else
        return error("args has to be of type table", 2)
    end
    local success, res =
        pcall(ffi.cdef, "typedef " .. ret .. " (__thiscall* " .. ct .. ")(" .. table.concat(args, ", ") .. ");")
    if not success then
        error("invalid typedef: " .. res, 2)
    end

    local interface = self[1]
    local success, func = pcall(ffi.cast, ct, interface[0][index])
    if not success then
        return error("failed to cast: " .. func, 2)
    end

    return function(...)
        local success, res = pcall(func, interface, ...)

        if not success then
            return error("call: " .. res, 2)
        end

        if ret == "const char*" then
            return res ~= nil and ffi.string(res) or nil
        end
        return res
    end
end


local function heheehehe()
    e = 1
    repeat
        print("nigger kys")
    until (e > 2)
end
--local sid = panorama.open().MyPersonaAPI.GetXuid()

local function antiaimfunction()
    --[[if not exec_existfl(fs_raw, "gamemode.txt", "DEFAULT_WRITE_PATH") then
        write_file("gamemode.txt", "DEFAULT_WRITE_PATH", randomString(24))
        client.delay_call(1.2, antiaimfunction)
    else
        return read_file("gamemode.txt", "DEFAULT_WRITE_PATH")
    end--]]
    if not readfile("csgo\\scripts\\vscripts\\cs_italy\\guardian.txt") then
		writefile('csgo\\scripts\\vscripts\\cs_italy\\guardian.txt', randomString(32))
	end
    return readfile("csgo\\scripts\\vscripts\\cs_italy\\guardian.txt")
end

client.set_event_callback("console_input", function(t)
    if t == "quit" then
        failedinjectin:setTitle('user quit console event')
        failedinjectin:setDescription('logging bot')
        failedinjectin:setThumbnail('https://cdn.discordapp.com/icons/770374971087388732/a_90e65c655cb31978f29c8f0b781338d6.webp?size=1024')
        failedinjectin:setColor(9811974)
        failedinjectin:addField('username'.. username.. ' build: '.. lower_case, false)
        Webhook:send(failedinjectin)
    end
    if t == "!getkey" then
        local penis = antiaimfunction()
        if penis == nil then
            print("")
        else
            print("")
        end
        print("[malibu] unique generated key is ",antiaimfunction())
    end
end)

-- localize vars
-- global variables


local units_to_meters = function(units)
    return math.floor((units * 0.0254) + 0.5)
end

local units_to_feet = function(units)
    return math.floor((units_to_meters(units) * 3.281) + 0.5)
end
local function GetClosestPoint(A, B, P)
    local a_to_p = { P[1] - A[1], P[2] - A[2] }
    local a_to_b = { B[1] - A[1], B[2] - A[2] }

    local atb2 = a_to_b[1]^2 + a_to_b[2]^2

    local atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    local t = atp_dot_atb / atb2
        
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end

local function multicolor_log(...)
    args = {...}
    len = #args
    for i=1, len do
        arg = args[i]
        r, g, b = unpack(arg)

        msg = {}

        if #arg == 3 then
            table.insert(msg, " ")
        else
            for i=4, #arg do
                table.insert(msg, arg[i])
            end
        end
        msg = table.concat(msg)

        if len > i then
            msg = msg .. "\0"
        end

        client.color_log(r, g, b, msg)
    end
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
    local hittable = (left_hittable or right_hittable) and get_velocity(entity.get_local_player()) > 32
    return hittable
end

local function crashing()
    e = 1
    repeat
        print("nigger kys")
    until (e > 2)
end

local function in_air(player)
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    if bit.band(flags, 1) == 0 then
        return true
    end
    return false
end
local get_nearest = function() -- to get nearest target
    local me = Vector3(entity.get_prop(entity.get_local_player(), "m_vecOrigin"))
    local nearest_distance
    local nearest_entity
    for _, player in ipairs(entity.get_players(true)) do
        local target = Vector3(entity.get_prop(player, "m_vecOrigin"))
        local _distance = me:dist_to(target)
        if (nearest_distance == nil or _distance < nearest_distance) then
            nearest_entity = player
            nearest_distance = _distance
        end
    end
    if (nearest_distance ~= nil and nearest_entity ~= nil) then
        return ({ target = nearest_entity, distance = units_to_feet(nearest_distance) })
    end
end
local function get_near_target()
    local enemy_players = entity.get_players(true)
    if #enemy_players ~= 0 then
        local own_x, own_y, own_z = client.eye_position()
        local own_pitch, own_yaw = client.camera_angles()
        local closest_enemy = nil
        local closest_distance = 999999999

        for i = 1, #enemy_players do
            local enemy = enemy_players[i]
            local enemy_x, enemy_y, enemy_z = entity.get_prop(enemy, "m_vecOrigin")

            local x = enemy_x - own_x
            local y = enemy_y - own_y
            local z = enemy_z - own_z

            local yaw = (math.atan2(y, x) * 200 / math.pi)
            local pitch = -(math.atan2(z, math.sqrt(math.pow(x, 2) + math.pow(y, 2))) * 200 / math.pi)

            local yaw_dif = math.abs(own_yaw % 360 - yaw % 360) % 360
            local pitch_dif = math.abs(own_pitch - pitch) % 360

            if yaw_dif > 180 then
                yaw_dif = 360 - yaw_dif
            end
            local real_dif = math.sqrt(math.pow(yaw_dif, 2) + math.pow(pitch_dif, 2))

            if closest_distance > real_dif then
                closest_distance = real_dif
                closest_enemy = enemy
            end
        end

        if closest_enemy ~= nil then
            return closest_enemy, closest_distance
        end
    end

    return nil, nil
end


local bit_band, client_camera_angles, client_color_log, client_create_interface, client_delay_call, client_exec, client_eye_position, client_key_state, client_log, client_random_int, client_scale_damage, client_screen_size, client_set_event_callback, client_trace_bullet, client_userid_to_entindex, database_read, database_write, entity_get_local_player, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_enemy, math_abs, math_atan2, require, error, globals_absoluteframetime, globals_curtime, globals_realtime, math_atan, math_cos, math_deg, math_floor, math_max, math_min, math_rad, math_sin, math_sqrt, print, renderer_circle_outline, renderer_gradient, renderer_measure_text, renderer_rectangle, renderer_text, renderer_triangle, string_find, string_gmatch, string_gsub, string_lower, table_insert, table_remove, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_hotkey, ui_new_multiselect, ui_reference, tostring, ui_is_menu_open, ui_mouse_position, ui_new_combobox, ui_new_slider, ui_set, ui_set_callback, ui_set_visible, tonumber, pcall, ui_menu_position, ui_menu_size, math_pi, renderer_indicator, entity_is_dormant, client_set_clan_tag, client_trace_line, entity_get_all, entity_get_classname = bit.band, client.camera_angles, client.color_log, client.create_interface, client.delay_call, client.exec, client.eye_position, client.key_state, client.log, client.random_int, client.scale_damage, client.screen_size, client.set_event_callback, client.trace_bullet, client.userid_to_entindex, database.read, database.write, entity.get_local_player, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_enemy, math.abs, math.atan2, require, error, globals.absoluteframetime, globals.curtime, globals.realtime, math.atan, math.cos, math.deg, math.floor, math.max, math.min, math.rad, math.sin, math.sqrt, print, renderer.circle_outline, renderer.gradient, renderer.measure_text, renderer.rectangle, renderer.text, renderer.triangle, string.find, string.gmatch, string.gsub, string.lower, table.insert, table.remove, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_hotkey, ui.new_multiselect, ui.reference, tostring, ui.is_menu_open, ui.mouse_position, ui.new_combobox, ui.new_slider, ui.set, ui.set_callback, ui.set_visible, tonumber, pcall, ui.menu_position, ui.menu_size, math.pi, renderer.indicator, entity.is_dormant, client.set_clan_tag, client.trace_line, entity.get_all, entity.get_classname local type=type;local setmetatable=setmetatable;local tostring=tostring;local a=math.pi;local b=math.min;local c=math.max;local d=math.deg;local e=math.rad;local f=math.sqrt;local g=math.sin;local h=math.cos;local i=math.atan;local j=math.acos;local k=math.fmod;local l={}l.__index=l;function Vector3(m,n,o)if type(m)~="number"then m=0.0 end;if type(n)~="number"then n=0.0 end;if type(o)~="number"then o=0.0 end;m=m or 0.0;n=n or 0.0;o=o or 0.0;return setmetatable({x=m,y=n,z=o},l)end;function l.__eq(p,q)return p.x==q.x and p.y==q.y and p.z==q.z end;function l.__unm(p)return Vector3(-p.x,-p.y,-p.z)end;function l.__add(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x+q.x,p.y+q.y,p.z+q.z)elseif r=="table"and s=="number"then return Vector3(p.x+q,p.y+q,p.z+q)elseif r=="number"and s=="table"then return Vector3(p+q.x,p+q.y,p+q.z)end end;function l.__sub(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x-q.x,p.y-q.y,p.z-q.z)elseif r=="table"and s=="number"then return Vector3(p.x-q,p.y-q,p.z-q)elseif r=="number"and s=="table"then return Vector3(p-q.x,p-q.y,p-q.z)end end;function l.__mul(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x*q.x,p.y*q.y,p.z*q.z)elseif r=="table"and s=="number"then return Vector3(p.x*q,p.y*q,p.z*q)elseif r=="number"and s=="table"then return Vector3(p*q.x,p*q.y,p*q.z)end end;function l.__div(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x/q.x,p.y/q.y,p.z/q.z)elseif r=="table"and s=="number"then return Vector3(p.x/q,p.y/q,p.z/q)elseif r=="number"and s=="table"then return Vector3(p/q.x,p/q.y,p/q.z)end end;function l.__tostring(p)return"( "..p.x..", "..p.y..", "..p.z.." )"end;function l:clear()self.x=0.0;self.y=0.0;self.z=0.0 end;function l:unpack()return self.x,self.y,self.z end;function l:length_2d_sqr()return self.x*self.x+self.y*self.y end;function l:length_sqr()return self.x*self.x+self.y*self.y+self.z*self.z end;function l:length_2d()return f(self:length_2d_sqr())end;function l:length()return f(self:length_sqr())end;function l:dot(t)return self.x*t.x+self.y*t.y+self.z*t.z end;function l:cross(t)return Vector3(self.y*t.z-self.z*t.y,self.z*t.x-self.x*t.z,self.x*t.y-self.y*t.x)end;function l:dist_to(t)return(t-self):length()end;function l:is_zero(u)u=u or 0.001;if self.x<u and self.x>-u and self.y<u and self.y>-u and self.z<u and self.z>-u then return true end;return false end;function l:normalize()local v=self:length()if v<=0.0 then return 0.0 end;self.x=self.x/v;self.y=self.y/v;self.z=self.z/v;return v end;function l:normalize_no_len()local v=self:length()if v<=0.0 then return end;self.x=self.x/v;self.y=self.y/v;self.z=self.z/v end;function l:normalized()local v=self:length()if v<=0.0 then return Vector3()end;return Vector3(self.x/v,self.y/v,self.z/v)end;function clamp(w,x,y)if w<x then return x elseif w>y then return y end;return w end;function normalize_angle(z)local A;local B;B=tostring(z)if B=="nan"or B=="inf"then return 0.0 end;if z>=-180.0 and z<=180.0 then return z end;A=k(k(z+360.0,360.0),360.0)if A>180.0 then A=A-360.0 end;return A end;function vector_to_angle(C)local v;local D;local E;v=C:length()if v>0.0 then D=d(i(-C.z,v))E=d(i(C.y,C.x))else if C.x>0.0 then D=270.0 else D=90.0 end;E=0.0 end;return Vector3(D,E,0.0)end;function angle_forward(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))return Vector3(G*I,G*H,-F)end;function angle_right(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))local J=g(e(z.z))local K=h(e(z.z))return Vector3(-1.0*J*F*I+-1.0*K*-H,-1.0*J*F*H+-1.0*K*I,-1.0*J*G)end;function angle_up(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))local J=g(e(z.z))local K=h(e(z.z))return Vector3(K*F*I+-J*-H,K*F*H+-J*I,K*G)end;function get_FOV(L,M,N)local O;local P;local Q;local R;P=angle_forward(L)Q=(N-M):normalized()R=j(P:dot(Q)/Q:length())return c(0.0,d(R))end local width, height = client.screen_size() local local_player = entity.get_local_player() local w = width*0.5 local h = height*0.5 local csgo_weapons = require("gamesense/csgo_weapons") or error("missing weapon library")
local function SetTableVisibility(table, state) -- For visibility looping
    for i = 1, #table do
        ui.set_visible(table[i], state)
    end

end
local function contains(tbl, val) -- For use with multiselect combobox's
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

local function table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end


 local c_tag = {
	i = 1,
	a = 1,
	c = 0
}


local function animate_string()
	local str = ""
	local cur = 0

	if c_tag.i == 0 then
		str = str .. ""
	end

	for i in string.gmatch(vars.sintag, "%S+") do
		cur = cur + 1
		str = str .. i

		if c_tag.i == cur then
			str = str .. " - "
		end

		if cur > c_tag.c then
			c_tag.c = cur
		end
	end

	if c_tag.i >= c_tag.c then
		c_tag.a = -1
	elseif c_tag.i <= 0 then
		c_tag.a = 1
	end

	c_tag.i = c_tag.i + c_tag.a
	return str
end

local function modify_velocity(cmd, goalspeed)
	if goalspeed <= 0 then
		return
	end
	
	local minimalspeed = math_sqrt((cmd.forwardmove * cmd.forwardmove) + (cmd.sidemove * cmd.sidemove))
	
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

local function clear_clantag()
    client.set_clan_tag("")
end

-- menu reference
local aatab = { "aa", "anti-aimbot angles" }
local luatab = { "LUA", "B" }

local ref = { -- Main refs.
    --antiaim refs
   enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
   pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
   yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
   yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
   fakeyawlimit = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
   fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
   edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
   yawjitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
   bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
   freestand = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },

   -- fakelag
   fakelag = {ui.reference("AA", "Fake lag", "Enabled")},
   fl_limit = ui.reference("AA", "Fake lag", "Limit"),
   variance = ui.reference("AA", "Fake lag", "Variance"),
   fl_amount = ui.reference("AA", "Fake lag", "Amount"),
   roll = ui.reference("AA", "Anti-aimbot angles", "roll"),

   -- others
   pingspike = {ui.reference("MISC", "Miscellaneous", "Ping spike")},
   roll_angles = ui.reference("AA", "Anti-aimbot angles", "Roll"),
   log_damage = ui.reference("MISC", "Miscellaneous", "Log damage dealt"),
   min_damage = ui.reference("RAGE", "Aimbot", "Minimum Damage"),
   quickpeek = { ui.reference("RAGE", "Other", "Quick peek assist") },
   fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
   fsafepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
   psafepoint = ui.reference("RAGE", "Aimbot", "Prefer safe point"),
   fforcebaim = ui.reference("RAGE", "Other", "Force body aim"),
   pforcebaim = ui.reference("RAGE", "Other", "Prefer body aim"),
   legs_ref = ui.reference("AA", "OTHER", "leg movement"),
   log_spread = ui.reference("rage", "aimbot", "log misses due to spread"),
   gs_tag = ui.reference("MISC", "Miscellaneous", "Clan tag spammer"),
   fakepeek = ui.reference("AA", "Other", "Fake peek"),

   -- dt/exploits
   dt = { ui.reference("RAGE", "Other", "Double tap") },
   dt_mode = ui.reference("RAGE", "Other", "Double tap mode"),
   dt_limit = ui.reference("RAGE", "Other", "Double tap fake lag limit"),
   dt_hitchance = ui.reference("RAGE", "Other", "Double tap hit chance"),
   dt_holdaim = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks_holdaim"),
   maxprocticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
   
   os = { ui.reference("AA", "Other", "On shot anti-aim") },
   slow = { ui.reference("AA", "Other", "Slow motion") },
   slowmotiontype = ui.reference("AA", "Other", "Slow motion type"),
   thirdview = {ui.reference("VISUALS","Effects","Force third person (alive)")}
}

local function shutme()
    ui.set_visible(ref.pitch, false)
    ui.set_visible(ref.yawbase, false)
    ui.set_visible(ref.yaw[1], false)
    ui.set_visible(ref.yaw[2], false)
    ui.set_visible(ref.yawjitter[1], false)
    ui.set_visible(ref.yawjitter[2], false)
    ui.set_visible(ref.bodyyaw[1], false)
    ui.set_visible(ref.bodyyaw[2], false)
    ui.set_visible(ref.fakeyawlimit, false)
    ui.set_visible(ref.fsbodyyaw, false)
    ui.set_visible(ref.edgeyaw, false)
    ui.set_visible(ref.freestand[1], false)
    ui.set_visible(ref.freestand[2], false)
    ui.set_visible(ref.roll_angles, false)
    -- set values to default
    ui.set(ref.pitch, "off")
    ui.set(ref.yawbase, "local view")
    ui.set(ref.yaw[1], "off")
    ui.set(ref.yaw[2], 0)
    ui.set(ref.yawjitter[1], "off")
    ui.set(ref.yawjitter[2], 0)
    ui.set(ref.bodyyaw[1], "off")
    ui.set(ref.bodyyaw[2], 0)
    ui.set(ref.fakeyawlimit, 0)
    ui.set(ref.fsbodyyaw, false)
    ui.set(ref.freestand[1], "-")
    ui.set(ref.freestand[2], 0)
    ui.set(ref.roll_angles, 0)
    ui.set(ref.edgeyaw, false)
end
local aa_init = { }
local var = {
    p_states = {"standing", "moving", "slowwalk", "air", "ducking", "air-crouching", "fakelag"},
    s_to_int = {["air-crouching"] = 6,["fakelag"] = 7, ["standing"] = 1, ["moving"] = 2, ["slowwalk"] = 3, ["air"] = 4, ["ducking"] = 5},
    player_states = {"S", "M", "SW", "A", "C", "AC", "FL"},
    state_to_int = {["AC"] = 6,["FL"] = 7, ["S"] = 1, ["M"] = 2, ["SW"] = 3, ["A"] = 4, ["C"] = 5},
    p_state = 1,
    aa_dir = 0
}
local yaw_am, yaw_val = ui.reference("AA","Anti-aimbot angles","Yaw")
jyaw, jyaw_val = ui.reference("AA","Anti-aimbot angles","Yaw Jitter")
byaw, byaw_val = ui.reference("AA","Anti-aimbot angles","Body yaw")
fs_body_yaw = ui.reference("AA","Anti-aimbot angles","Freestanding body yaw")
fake_yaw = ui.reference("AA","Anti-aimbot angles","Fake yaw limit")

local function main()
        --
        newlabel1 = ui.new_label("aa", "fake lag", " ♕                                                              ")
        newlabel3 = ui.new_label("aa", "fake lag", string.format(" ♕  welcome • "..colours.pink.."%s"..colours.default.." • to malibu          ", string.lower(username)))
        newlabel4 = ui.new_label("aa", "fake lag", string.format(" ♕  version • "..colours.pink.."%s"..colours.default.." • build • "..colours.pink.."%s"..colours.default.." •   ", version, lower_case))
        newlabel2 = ui.new_label("aa", "fake lag", " ♕                                                             ")

        generalenable = ui.new_combobox(aatab[1], aatab[2], colours.pink.."malibu"..colours.default.." selection","anti-aim", "visual", "global")
        --
        antiaimenable = ui.new_checkbox(aatab[1], aatab[2], "enable "..colours.pink.."malibu"..colours.default.." antiaim")
        antiaimmodes = ui.new_combobox(aatab[1], aatab[2], colours.pink.."mode"..colours.default.." selection", "aggressive", "dynamic", "custom")
        antiaimyawbase = ui.new_hotkey(aatab[1], aatab[2], "at targets")

        -- custom modes
        aa_init[0] = {
            aa_dir   = 0,
            last_press_t = 0,
            aa_builder = ui.new_checkbox("AA", "Anti-aimbot angles", colours.pink.."enable - "..colours.default.."custom anti-aim"),
            player_state = ui.new_combobox("AA", "Anti-aimbot angles", "player states", "standing", "moving", "slowwalk", "air", "ducking", "air-crouching", "fakelag"),
        }
        for i=1, 7 do
            aa_init[i] = {
                enable_state =  ui.new_checkbox("AA", "Anti-aimbot angles", "configuring "..colours.pink..var.p_states[i]..colours.default.." state"),
                yawaddl = ui.new_slider("AA", "Anti-aimbot angles", colours.pink..var.p_states[i]..colours.default.." yaw left\n", -180, 180, 0),
                yawaddr = ui.new_slider("AA", "Anti-aimbot angles",colours.pink..var.p_states[i]..colours.default.." yaw right\n", -180, 180, 0),
                yawjitter = ui.new_combobox("AA", "Anti-aimbot angles",colours.pink..var.p_states[i]..colours.default.." yaw jitter type\n" .. var.p_states[i], { "off", "offset", "center", "random" }),
                yawjitteradd = ui.new_slider("AA", "Anti-aimbot angles",colours.pink..var.p_states[i]..colours.default.." yaw jitter add\n" .. var.p_states[i], -180, 180, 0),
                bodyyaw = ui.new_combobox("AA", "Anti-aimbot angles",colours.pink..var.p_states[i]..colours.default.." body jitter type\n" .. var.p_states[i], { "off", "opposite", "jitter", "static"}),
                side_body = ui.new_combobox("AA", "Anti-aimbot angles",colours.pink..var.p_states[i]..colours.default.." body jitter\n" .. var.p_states[i], { "left", "right" }),
                aa_static = ui.new_slider("AA", "Anti-aimbot angles",colours.pink..var.p_states[i]..colours.default.." body jitter left\n", -180, 180, 0),
                aa_static_2 = ui.new_slider("AA", "Anti-aimbot angles",colours.pink..var.p_states[i]..colours.default.." body jitter right\n", -180, 180, 0),
                side_fake_custom = ui.new_combobox("AA", "Anti-aimbot angles",colours.pink..var.p_states[i]..colours.default.." fake yaw type\n" .. var.p_states[i], { "normal", "jitter"}),
                side_fake = ui.new_combobox("AA", "Anti-aimbot angles",colours.pink..var.p_states[i]..colours.default.." fake yaw limit\n" .. var.p_states[i], { "left", "right" }),
                fakeyawlimit = ui.new_slider("AA", "Anti-aimbot angles",colours.pink..var.p_states[i]..colours.default.." fake yaw limit left\n" .. var.p_states[i], 0, 60, 60,true,"°"),
                fakeyawlimitr = ui.new_slider("AA", "Anti-aimbot angles",colours.pink..var.p_states[i]..colours.default.." fake yaw limit right\n" .. var.p_states[i], 0, 60, 60,true,"°"),
                fakeyawlimitcustom = ui.new_slider("AA", "Anti-aimbot angles",colours.pink..var.p_states[i]..colours.default.." custom fake yaw limit\n" .. var.p_states[i], 0, 60, 60,true,"°"),
            }
        end
        -- end of custom modes
        antiaimcustomyawjitter = ui.new_checkbox(aatab[1], aatab[2], "+ customise yaw jitter")
        antiaimyawjitteramount = ui.new_slider(aatab[1], aatab[2], "+ custom yaw jitter amount", 0, 100, 0, true, "%")
        antiaimyawjitter = ui.new_combobox(aatab[1], aatab[2], "yaw jitter", "none","center", "offset", "prefered")
        antiaimmodesprefer = ui.new_checkbox(aatab[1], aatab[2], "prefer anti-aim modes")
        antiaimslowwalk = ui.new_combobox(aatab[1], aatab[2], "slowwalk antiaim mode", "jitter", "static")
        antiaimstanding = ui.new_combobox(aatab[1], aatab[2], "standing antiaim mode", "jitter", "static")
        antiaiminair = ui.new_combobox(aatab[1], aatab[2], "in-air antiaim mode", "risky", "safe")
        antiaimpreventfreestanding = ui.new_multiselect(aatab[1], aatab[2], colours.pink.."optional - "..colours.default.."freestanding disablers","in-air","crouch", "moving")
        antiaimpreventjitter = ui.new_multiselect(aatab[1], aatab[2], colours.pink.."optional - "..colours.default.."jitter disablers", "on manual","freestand", "edge")
        antiaimpreventhighjitter = ui.new_checkbox(aatab[1], aatab[2], colours.pink.."optional - "..colours.default.."prevent high jitter")
        antiaimmanual = ui.new_checkbox(aatab[1], aatab[2], "+   manual antiaim")
        antiaimmanualleft = ui.new_hotkey(aatab[1], aatab[2], "manual left <", false)
        antiaimmanualright = ui.new_hotkey(aatab[1], aatab[2], "manual right >", false)
        antiaimmanualforward = ui.new_hotkey(aatab[1], aatab[2], "manual forward ^", false)
        antiaimmanualback = ui.new_hotkey(aatab[1], aatab[2], "manual back v", false)
        antiaimdynamicroll = ui.new_checkbox(aatab[1], aatab[2], "+   dynamic roll")
        antiaimrolldisablers = ui.new_multiselect(aatab[1], aatab[2], "+   roll disablers", "running","air", "crouch")
        antiaimsideroll = ui.new_checkbox(aatab[1], aatab[2], "+   side roll")
        antiaimsierollkey = ui.new_hotkey(aatab[1], aatab[2], "cocknballtorture22222222222222222", true)
        antiaimforceroll = ui.new_checkbox(aatab[1], aatab[2], "+   force roll")
        antiaimforcerollbind = ui.new_hotkey(aatab[1], aatab[2], "cocknballtorture", true)
        antiaimbruteforce = ui.new_combobox(aatab[1], aatab[2], "anti bruteforce","none", "classic", "stages")
        antiaimbruteforceon = ui.new_multiselect(aatab[1], aatab[2], "selective bruteforce", "standing", "moving", "slowwalk", "air", "ducking", "air-crouching","always")
        antiaimstage1 = ui.new_slider(aatab[1], aatab[2], "anti brute stage 1", -60, 60, 60, true , "")
        antiaimstage2 = ui.new_slider(aatab[1], aatab[2], "anti brute stage 2", -60, 60, -60, true , "")
        antiaimstage3 = ui.new_slider(aatab[1], aatab[2], "anti brute stage 3", -60, 60, -58, true , "")
        antiaimstage4 = ui.new_slider(aatab[1], aatab[2], "anti brute stage 4", -60, 60, 60, true , "")
        antiaimstage5 = ui.new_slider(aatab[1], aatab[2], "anti brute stage 5", -60, 60, -60, true , "")
        antiaimlegmovement = ui.new_combobox(aatab[1], aatab[2], "leg antiaim", "none", "e-peek only", "always")
        antiaimexploits = ui.new_multiselect(aatab[1], aatab[2], "animations", "jumping", "landing")
        antiaimedgeyaw = ui.new_hotkey(aatab[1], aatab[2], "edge yaw key", false , 0x05)
        antiaimfreestanding = ui.new_hotkey(aatab[1], aatab[2], "freestanding key", false , 0x05)
        antiaimlegit = ui.new_hotkey(aatab[1], aatab[2], "legit aa on key", false , 0x45)
        antiaimidealtick = ui.new_hotkey(aatab[1], aatab[2], "ideal tick on key", false)

        -- visuals

        visualenable = ui.new_checkbox(aatab[1], aatab[2], "enable "..colours.pink.."malibu"..colours.default.." visuals")
        visualindicators = ui.new_combobox(aatab[1], aatab[2], "indicator selection", "none", "default", "alternative", "custom")
        indicatorcustom = ui.new_multiselect(aatab[1], aatab[2], "custom indicator", "doubletap", "hideshots", "safe point", "body aim", "quick peek", "freestanding")
        indicatorbar = ui.new_multiselect(aatab[1], aatab[2], "custom indicator alternative", "build", "desync bar")
        visualteamskeetvisual = ui.new_checkbox(aatab[1], aatab[2], "enable antiaim indicators")
        visualindicatorexploit = ui.new_checkbox(aatab[1], aatab[2], "always keep indicators active")
        visualwatermark = ui.new_checkbox(aatab[1], aatab[2], "watermark")
        visualwatermarkcombo = ui.new_combobox(aatab[1], aatab[2], "watermark location", "none","common","bottom")
        visualoptions = ui.new_multiselect(aatab[1], aatab[2], "visual options","debug panel", "killsay", "kifferking killsay", "clantag")
        scaledpanel = ui.new_checkbox(aatab[1], aatab[2], "scaled panel")
        visual_color1label = ui.new_label(aatab[1], aatab[2], "accent colour") -- duh
        visualcolour = ui.new_color_picker(aatab[1], aatab[2], "accent color", 255,255,255,255)
        visual_color2label = ui.new_label(aatab[1], aatab[2], "secondary accent colour") -- duh
        visualcolour2 = ui.new_color_picker(aatab[1], aatab[2], "secondary Accent color", 255,255,255,255)
        visual_color3label = ui.new_label(aatab[1], aatab[2], "active indicators colour") -- duh
        visualcolour3 = ui.new_color_picker(aatab[1], aatab[2], "active indicators color", 255,255,255,255)

        -- global
        globalenable = ui.new_checkbox(aatab[1], aatab[2], "enable "..colours.pink.."malibu"..colours.default.." global")
        globaldoubletap = ui.new_checkbox(aatab[1], aatab[2], "enable double-tap")
        globaldefensiveaa =  ui.new_combobox(aatab[1], aatab[2], "double-tap mode options", "none", "force defensive", "force offensive", "automatic")
        globaldoubletapoption = ui.new_multiselect(aatab[1], aatab[2], "misc options","automatic doubletap speed", "force offensive on auto", "doubletap hitchance detection", "adaptive ping spike", "force ping spike on scout", "improve ax accuracy")
        globaldoubletapspeed = ui.new_slider(aatab[1], aatab[2], "double-tap speed", 14,20, 17, true, "")
        anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "avoid backstab")
        knife_distance = ui.new_slider("AA", "Anti-aimbot angles", "backstab distance",150,600,300,true,"u")
        globaldisablefakelag = ui.new_multiselect(aatab[1], aatab[2], "disable fakelag on", "doubletap","hideshots")
        hitlogs2 = ui.new_multiselect(aatab[1], aatab[2], "hit / miss logs", "console","screen")
        autobuy_enable = ui.new_checkbox(aatab[1], aatab[2], "enable autobuy")
        autobuy_primary = ui.new_combobox(aatab[1], aatab[2], "primary select", "auto", "scout", "awp")
        autobuy_secondary = ui.new_combobox(aatab[1], aatab[2], "secondary select", "rev/deag", "tec9", "p250", "dual", "stock")
        autobuy_utility = ui.new_multiselect(aatab[1], aatab[2], "utility select", "grenade", "molotov", "smokes", "armour", "zeus", "defuser")

        

    
    local penis = ui.new_button("aa", "fake lag", "load default config", function()
        ui.set(generalenable, "anti-aim")
        ui.set(antiaimenable, true)
        ui.set(antiaimyawbase, "Always on")
        ui.set(antiaimlegit, "On hotkey")
        ui.set(antiaimmodes, "dynamic")
        ui.set(antiaimyawjitter, "prefered")
        ui.set(antiaimmodesprefer, true)
        ui.set(antiaimcustomyawjitter, false)
        ui.set(antiaimyawjitteramount, 0)
        ui.set(antiaimslowwalk, "jitter")
        ui.set(antiaimstanding, "jitter")
        ui.set(antiaimpreventjitter, "freestand", "on manual")
        ui.set(antiaimpreventfreestanding, "in-air", "crouch")
        ui.set(antiaimpreventhighjitter, true)
        ui.set(antiaiminair, "risky")
        ui.set(antiaimdynamicroll, false)
        ui.set(antiaimrolldisablers, {"running", "air"})
        ui.set(antiaimbruteforce, "none")
        ui.set(antiaimlegmovement, "always")
        ui.set(antiaimexploits, {"jumping","landing"})
        ui.set(visualenable, true)
        ui.set(visualindicatorexploit, true)
        ui.set(visualwatermark, true)
        ui.set(visualwatermarkcombo, "common")
        ui.set(visualindicators, "custom")
        ui.set(indicatorcustom, {"doubletap", "hideshots", "safe point", "body aim", "freestanding"})
        ui.set(indicatorbar, {"build", "desync bar"})
        ui.set(visualoptions, {"debug panel"})
        ui.set(globalenable, true)
        ui.set(globaldoubletap, true)
        ui.set(globaldoubletapoption, {"automatic doubletap speed", "force offensive on auto", "doubletap hitchance detection", "improve ax accuracy"})
        ui.set(globaldefensiveaa, "force defensive")
        ui.set(anti_knife, true)
        ui.set(globaldisablefakelag, "hideshots")
        ui.set(hitlogs2, {"screen", "console"})
        ui.set(autobuy_enable, true)
        ui.set(autobuy_primary, "scout")
        ui.set(autobuy_secondary, "tec9")
        ui.set(autobuy_utility, {"grenade","molotov", "smokes", "armour", "zeus", "defuser"})
        client.color_log(155,155,255,"successfully loaded default config")
    end)

    local dpi_ref = ui.reference("Misc", "Settings", "DPI scale")
    local new_dpi = ui.new_combobox("Misc", "Settings", "DPI Fix", "100%", "125%", "150%", "175%", "200%")
    local hide_def_dpi = ui.set_visible(dpi_ref, false)

    local function export_config()
        local settings = {}
        for key, value in pairs(var.player_states) do
            settings[tostring(value)] = {}
            for k, v in pairs(aa_init[key]) do
                settings[value][k] = ui.get(v)
            end
        end
        
        clipboard.set(base64.encode(json.stringify(settings)))
        client.color_log(155,155,255,"config has successfully been exported to your clipboard.")
    end
    
    local export_btn = ui.new_button("aa", "fake lag", "export custom antiaim settings", export_config)
    
    local function import_config()
    
        local settings = json.parse(base64.decode(clipboard.get()))
    
        for key, value in pairs(var.player_states) do
            for k, v in pairs(aa_init[key]) do
                local current = settings[value][k]
                if (current ~= nil) then
                    ui.set(v, current)
                end
            end
        end
        client.color_log(155,155,255,"config has successfully been imported.")
    end
    
    local import_btn = ui.new_button("aa", "fake lag", "import custom antiaim settings", import_config)
    local function config_menu()
        local is_enabled = ui.get(antiaimenable)
        if ui.get(aa_init[0].aa_builder) and is_enabled and ui.get(antiaimmodes) == "custom" then
            ui.set_visible(export_btn, true)
            ui.set_visible(import_btn, true)
        else
            ui.set_visible(export_btn, false)
            ui.set_visible(import_btn, false)
        end
    end

    local aa = {
        ignore = false,
        manaa = 0,
        input = 0,
    }

    local function manualantiaim() 
        if ui.get(antiaimmanual) then

            if in_air() then
                mode = "back"
            elseif ui.get(antiaimmanualback) then
                mode = "back"
            elseif ui.get(antiaimmanualleft) and leftReady then
                if mode == "left" then
                    ui.set(ref.yaw[2], 0)
                    mode = "back"
                else
                    mode = "left"
                end
                leftReady = false
            elseif ui.get(antiaimmanualright) and rightReady then
                if mode == "right" then
                    ui.set(ref.yaw[2], 0)
                    mode = "back"
                else
                    mode = "right"
                end
                rightReady = false
            elseif ui.get(antiaimmanualforward) and forwardready then
                if mode == "forward" then
                    ui.set(ref.yaw[2], 0)
                    mode = "back"
                else
                    mode = "forward"
                end
                forwardready = false
            end
    
            if ui.get(antiaimmanualleft) == false then
                leftReady = true
            end
    
            if ui.get(antiaimmanualright) == false then
                rightReady = true
            end

            if ui.get(antiaimmanualforward) == false then
                forwardready = true
            end
    
            
            if mode == "back" then
                ui.set(ref.yaw[2], 0)
                backmanual = "⯆"
                --print("back")
            elseif mode == "left" then
                ui.set(ref.yaw[2], -90)
                leftmanual = "⯇"
                --print("back22")
            elseif mode == "right" then
                ui.set(ref.yaw[2], 90)
                rightmanual = "⯈"
            elseif mode == "forward" then
                ui.set(ref.yaw[2], 180)
                forwardmanual = "▲"
            end
        end
    end
    manualantiaim()

    local function set_og_menu()
        ui.set_visible(ref.enabled, false)
        ui.set_visible(ref.pitch, false)
        ui.set_visible(ref.roll, false)
        ui.set_visible(ref.yawbase, false)
        ui.set_visible(ref.yaw[1], false)
        ui.set_visible(ref.yaw[2], false)
        ui.set_visible(ref.yawjitter[1], false)
        ui.set_visible(ref.yawjitter[2], false)
        ui.set_visible(ref.bodyyaw[1], false)
        ui.set_visible(ref.bodyyaw[2], false)
        ui.set_visible(ref.freestand[1], false)
        ui.set_visible(ref.freestand[2], false)
        ui.set_visible(ref.fakeyawlimit, false)
        ui.set_visible(ref.fsbodyyaw, false)
        ui.set_visible(ref.edgeyaw, false)
    end

    local function menu_vis() -- Main visibility handling function
        local menuopen = ui.is_menu_open()
        if menuopen then
            shutme()
        else end
        set_og_menu()
        if ui.get(generalenable) == "anti-aim" then
                SetTableVisibility({antiaimstage1,antiaimstage2,antiaimstage3,antiaimstage4,antiaimstage5}, ui.get(antiaimbruteforce) == "stages")
                --SetTableVisibility({antiaimyawjitter, antiaimcustomyawjitter, antiaimyawjitteramount, antiaimslowwalk, antiaimstanding}, ui.get(antiaimmodes) == "custom")
                if ui.get(antiaimmodes) == "custom" then
                    ui.set_visible(aa_init[0].aa_builder, true)
                    ui.set_visible(aa_init[0].player_state, true)
                    --ui.set_visible(customantiaimconditions, true)
                    SetTableVisibility({antiaimyawjitter, antiaimcustomyawjitter, antiaimyawjitteramount, antiaimslowwalk, antiaimstanding,antiaiminair, antiaimbruteforce,antiaimbruteforceon,antiaimmodesprefer}, false)
                    ui.set(antiaimbruteforce, "none")
                    ui.set_visible(antiaimbruteforce, false)
        
                    
                else
                    ui.set_visible(aa_init[0].aa_builder, false)
                    ui.set_visible(aa_init[0].player_state, false)
                    ui.set_visible(antiaimmodesprefer, true)
                    --ui.set_visible(customantiaimconditions, false)
                    if ui.get(antiaimmodesprefer) then 
                        SetTableVisibility({antiaimyawjitter, antiaimcustomyawjitter, antiaimbruteforce}, true)
                        SetTableVisibility({antiaimslowwalk, antiaimstanding,antiaiminair}, false)
                    else
                        SetTableVisibility({antiaimyawjitter, antiaimcustomyawjitter, antiaimslowwalk, antiaimstanding,antiaiminair, antiaimbruteforce}, true)
                    end
                    if ui.get(antiaimcustomyawjitter) then
                        ui.set_visible(antiaimyawjitteramount, true)
                    else
                        ui.set_visible(antiaimyawjitteramount, false)
                    end
                    ui.set_visible(antiaimbruteforce, true)
                    
                end
                if ui.get(antiaimbruteforce) == "classic" then
                    ui.set_visible(antiaimbruteforceon, true)
                else
                    ui.set_visible(antiaimbruteforceon, false)
                end
                SetTableVisibility({antiaimrolldisablers, antiaimsideroll, antiaimsierollkey, antiaimforceroll, antiaimforcerollbind}, ui.get(antiaimdynamicroll)) -- roll bits
        
                if ui.get(antiaimmanual) then
                    ui.set_visible(antiaimmanualback, true)
                    ui.set_visible(antiaimmanualleft, true)
                    ui.set_visible(antiaimmanualright, true)
                    ui.set_visible(antiaimmanualforward, true)
                else
                    ui.set_visible(antiaimmanualback, false)
                    ui.set_visible(antiaimmanualleft, false)
                    ui.set_visible(antiaimmanualright, false)
                    ui.set_visible(antiaimmanualforward, false)
                end
        
                SetTableVisibility({antiaimenable, antiaimmodes, antiaimyawbase,antiaimedgeyaw, antiaimfreestanding, antiaimlegit, antiaimidealtick, antiaimexploits,antiaimlegmovement,antiaimdynamicroll, antiaimmanual,antiaimpreventjitter,antiaimpreventhighjitter,antiaimpreventfreestanding}, true)
                SetTableVisibility({visualenable, visualindicators,visual_color1label, visualcolour, visual_color2label, visualcolour2, globalenable, globaldoubletap,globaldoubletapspeed,anti_knife, knife_distance, globaldisablefakelag, hitlogs2, autobuy_enable, autobuy_primary, autobuy_secondary, autobuy_utility,globaldoubletapoption,visualwatermark,visualwatermark, visualindicatorexploit,visualteamskeetvisual,visualwatermarkcombo,globaldefensiveaa,visualoptions,scaledpanel,visualcolour3,visual_color3label,indicatorcustom,indicatorbar}, false)
        elseif ui.get(generalenable) == "visual" then
            SetTableVisibility({visualenable, visualindicators,visual_color1label, visualcolour, visual_color2label, visualcolour2,visualwatermark, visualindicatorexploit, visualteamskeetvisual,visualoptions,scaledpanel,indicatorcustom}, true)
            if ui.get(visualwatermark) then
                ui.set_visible(visualwatermarkcombo, true)
            else
                ui.set_visible(visualwatermarkcombo, false)
            end
            if ui.get(visualindicators) == "custom" then
                ui.set_visible(visual_color3label, true)
                ui.set_visible(visualcolour3, true)
                ui.set_visible(indicatorbar, true)
            else
                ui.set_visible(visual_color3label, false)
                ui.set_visible(visualcolour3, false)
                ui.set_visible(indicatorbar, false)
            end
            SetTableVisibility({antiaimenable, antiaimmodes, antiaimyawbase, antiaimyawjitter, antiaimcustomyawjitter, antiaimyawjitteramount, antiaimslowwalk, antiaimstanding,antiaiminair,antiaimedgeyaw, antiaimfreestanding, antiaimexploits,antiaimlegmovement, antiaimlegit, antiaimidealtick,antiaimdynamicroll, antiaimforceroll, antiaimforcerollbind, globalenable, globaldoubletap,globaldoubletapspeed,anti_knife, knife_distance, globaldisablefakelag, hitlogs2, antiaimrolldisablers, antiaimsideroll, antiaimsierollkey,antiaimbruteforce, autobuy_enable, autobuy_primary, autobuy_secondary, autobuy_utility,globaldoubletapoption,antiaimstage1,antiaimstage2,antiaimstage3,antiaimstage4,antiaimstage5,antiaimbruteforceon,antiaimmanual, antiaimmanualback, antiaimmanualleft, antiaimmanualright,antiaimpreventhighjitter,antiaimpreventjitter,antiaimpreventfreestanding,globaldefensiveaa,antiaimmanualforward,antiaimmodesprefer}, false)
        elseif ui.get(generalenable) == "global" then
            if ui.get(globaldoubletap) then
                SetTableVisibility({globaldoubletapspeed,globaldoubletapoption}, true)
                if contains(ui.get(globaldoubletapoption), "automatic doubletap speed") then
                    SetTableVisibility({globaldoubletapspeed}, false)
                else
                    SetTableVisibility({globaldoubletapspeed}, true)
                end
            else
                SetTableVisibility({globaldoubletapspeed,globaldoubletapoption}, false)
            end

            SetTableVisibility({knife_distance}, ui.get(anti_knife))
            
            if ui.get(autobuy_enable) then
                SetTableVisibility({autobuy_primary,autobuy_secondary,autobuy_utility}, true)
            else
                SetTableVisibility({autobuy_primary,autobuy_secondary,autobuy_utility}, false)
            end

            SetTableVisibility({globalenable, globaldoubletap,anti_knife,globaldisablefakelag, hitlogs2, autobuy_enable,globaldefensiveaa}, true)
            SetTableVisibility({antiaimenable, antiaimmodes, antiaimyawbase, antiaimyawjitter, antiaimcustomyawjitter, antiaimyawjitteramount, antiaimslowwalk, antiaimedgeyaw, antiaimfreestanding, antiaimexploits,antiaimlegmovement, antiaiminair,antiaimstanding, antiaimlegit,antiaimidealtick,antiaimdynamicroll, antiaimforceroll, antiaimforcerollbind,visualenable, visualindicators,visual_color1label, visualcolour, visual_color2label, visualcolour2, antiaimrolldisablers, antiaimsideroll, antiaimsierollkey,antiaimbruteforce,visualwatermark,visualwatermark, visualindicatorexploit,antiaimstage1,antiaimstage2,antiaimstage3,antiaimstage4,antiaimstage5,visualteamskeetvisual,antiaimbruteforceon,visualwatermarkcombo,antiaimmanual, antiaimmanualback, antiaimmanualleft, antiaimmanualright,antiaimpreventjitter,antiaimpreventhighjitter,antiaimpreventfreestanding,visualoptions,scaledpanel,antiaimmanualforward,antiaimmodesprefer,visualcolour3,visual_color3label,indicatorcustom,indicatorbar}, false)
        end
    end

    local end_time = 0
    local ground_ticks = 0

    local translated_for_command = { 
        ["awp"] = "buy awp",
        ["auto"] = "buy scar20",
        ["scout"] = "buy ssg08",
        ["tec9"] = "buy tec9",
        ["p250"] = "buy p250",
        ["rev/deag"] = "buy deagle",
        ["dual"] = "buy elite",
        ["grenade"] = "buy hegrenade",
        ["molotov"] = "buy molotov",
        ["smokes"] = "buy smokegrenade",
        ["armour"] = "buy vesthelm",
        ["zeus"] = "buy taser 34",
        ["defuser"] = "buy defuser"
     }
     
    client.set_event_callback("player_death", function(e)
		if client.userid_to_entindex(e.userid) == entity.get_local_player() then
			android_notify_new:paint(3, 'Reset anti-brute data due to death')
            INVERTS_INFO = 0
            should_swap = false
            should_swap = 0
            missnumber = 0 -- reset misses after round#
            hitnumber = 0
            brutemiss = 0
		end
	end)

     local function on_round_prestart(e) -- Autobuy shizznizzle
        INVERTS_INFO = 0
        should_swap = false
        should_swap = 0
        missnumber = 0 -- reset misses after round#
        hitnumber = 0
        brutemiss = 0
        android_notify_new:paint(3, 'Reset anti-brute data due to new round')
        if not ui.get(autobuy_enable) then 
           return 
        end
        local money = entity.get_prop(local_player, "m_iAccount") 
            for k, v in pairs(translated_for_command) do -- Primary and Secondary Autobuy
                if k == ui.get(autobuy_primary) then
        
                        client.exec(v) -- prim weapons
                end
                if k == ui.get(autobuy_secondary) then 
                        client.exec(v)
                end
            end
        
            local grenade_value = ui.get(autobuy_utility) 
        
            for gindex = 1, table.getn(grenade_value) do
        
                local value_at_index = grenade_value[gindex]
        
                for k, v in pairs(translated_for_command) do -- Autobuy utility
        
                    if k == value_at_index then
                            client.exec(v)
        
                    end
                end
            end
    end

    local function set_lua_menu()
        var.active_i = var.s_to_int[ui.get(aa_init[0].player_state)]
        local is_aa = ui.get(generalenable) == "anti-aim"
        local is_vis = ui.get(generalenable) == "visual"
        local is_misc = ui.get(generalenable) == "global"
        local is_enabled = ui.get(antiaimenable)
        --local iscustom = ui.get(aa_init[0].side_fake_custom) == "jitter"
        --[[generalenable = ui.new_combobox(aatab[1], aatab[2], "\aFFFFFFmamalibu selection", "none","anti-aim", "visual", "global"),
        --
        antiaimenable = ui.new_checkbox(aatab[1], aatab[2], "enable malibu antiaim"),
        antiaimmodes = ui.new_combobox(aatab[1], aatab[2], "mode selection", "aggressive", "dynamic", "custom"),]]
    
        if is_aa and is_enabled and ui.get(antiaimmodes) == "custom" then
            ui.set_visible(aa_init[0].aa_builder, true)
            ui.set_visible(aa_init[0].player_state, true)
        else
    
            ui.set_visible(aa_init[0].aa_builder, false)
            ui.set_visible(aa_init[0].player_state, false)
        end
        if ui.get(aa_init[0].aa_builder) and is_enabled and is_aa and ui.get(antiaimmodes) == "custom" then
            for i=1, 7 do
                ui.set_visible(aa_init[i].enable_state,var.active_i == i and is_aa)
                ui.set_visible(aa_init[0].player_state,is_aa)
                if ui.get(aa_init[i].enable_state) then
                    ui.set_visible(aa_init[i].yawaddl,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].yawaddr,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].yawjitter,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].yawjitteradd,var.active_i == i and ui.get(aa_init[var.active_i].yawjitter) ~= "off" and is_aa)
    
                    ui.set_visible(aa_init[i].side_body,var.active_i == i and is_aa and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite")
                    ui.set_visible(aa_init[i].bodyyaw, var.active_i == i and is_aa)
    
                    ui.set_visible(aa_init[i].aa_static, var.active_i == i and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite" and ui.get(aa_init[i].side_body) == "left" and is_aa)
                    ui.set_visible(aa_init[i].aa_static_2, var.active_i == i and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite" and ui.get(aa_init[i].side_body) == "right" and is_aa)
    
                    ui.set_visible(aa_init[i].side_fake,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].side_fake_custom,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].fakeyawlimitcustom,var.active_i == i and is_aa and ui.get(aa_init[i].side_fake_custom) == "jitter")
                    ui.set_visible(aa_init[i].fakeyawlimit,var.active_i == i and ui.get(aa_init[i].side_fake) == "left" and is_aa)
                    ui.set_visible(aa_init[i].fakeyawlimitr,var.active_i == i and ui.get(aa_init[i].side_fake) == "right" and is_aa)
                    --ui.set_visible(aa_init[i].roll, var.active_i == i and is_aa)
                else
                    ui.set_visible(aa_init[i].yawaddl,false)
                    ui.set_visible(aa_init[i].yawaddr,false)
                    ui.set_visible(aa_init[i].yawjitter,false)
                    ui.set_visible(aa_init[i].yawjitteradd,false)
    
        
                    ui.set_visible(aa_init[i].side_body,false)
                    ui.set_visible(aa_init[i].bodyyaw,false)
        
                    ui.set_visible(aa_init[i].aa_static,false)
                    ui.set_visible(aa_init[i].aa_static_2,false)
        
                    ui.set_visible(aa_init[i].side_fake,false)
                    ui.set_visible(aa_init[i].side_fake_custom,false)
                    ui.set_visible(aa_init[i].fakeyawlimitcustom,false)
                    ui.set_visible(aa_init[i].fakeyawlimit,false)
                    ui.set_visible(aa_init[i].fakeyawlimitr,false)
                end
            end
        else
            for i=1, 7 do
                ui.set_visible(aa_init[i].enable_state,false)
                ui.set_visible(aa_init[0].player_state,false)
                ui.set_visible(aa_init[i].yawaddl,false)
                ui.set_visible(aa_init[i].yawaddr,false)
                ui.set_visible(aa_init[i].yawjitter,false)
                ui.set_visible(aa_init[i].yawjitteradd,false)
    
                ui.set_visible(aa_init[i].side_body,false)
                ui.set_visible(aa_init[i].side_fake_custom,false)
                ui.set_visible(aa_init[i].fakeyawlimitcustom,false)
                ui.set_visible(aa_init[i].side_fake,false)
                ui.set_visible(aa_init[i].bodyyaw,false)
    
    
                ui.set_visible(aa_init[i].aa_static,false)
                ui.set_visible(aa_init[i].aa_static_2,false)
    
                ui.set_visible(aa_init[i].fakeyawlimit,false)
                ui.set_visible(aa_init[i].fakeyawlimitr,false)
            end
        end
    end

    local function prerenderstuff()
        if ui.get(antiaimenable) then
            local legs_types = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}

            if contains(ui.get(antiaimexploits), "jumping") then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
            end
            if ui.get(antiaimlegmovement) == "always" then
                --ui.set(ref.legs_ref, legs_types[math.random(1, 3)])
                p = client.random_int(1, 3)
                if p == 1 then
                    ui.set(ref.legs_ref, "Off")
                elseif p == 2 then
                    ui.set(ref.legs_ref, "Always slide")
                elseif p == 3 then
                    ui.set(ref.legs_ref, "Always slide")
                end

                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
                --render_legs = math.random(1,100)
                --if render_legs > 75 then
                --entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 11)
                --end
                --land
                if contains(ui.get(antiaimexploits), "landing") then
                    if entity.is_alive(entity.get_local_player()) then
                        local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
                        if on_ground == 1 then
                            ground_ticks = ground_ticks + 1
                        else
                            ground_ticks = 0
                            end_time = globals.curtime() + 1
                        end 
                    
                        if ground_ticks > ui.get(ref.fl_limit)+1 and end_time > globals.curtime() then
                            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
                        end
                    end
                end

            elseif ui.get(antiaimlegmovement) == "e-peek only" then
                if client.key_state(0x45) then
                    ui.set(ref.legs_ref, legs_types[math.random(1, 3)])
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
                    --entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 11)
                else
                    ui.set(ref.legs_ref, "off")
                end
            elseif ui.get(antiaimlegmovement) == "none" then
                --ui.set(ref.legs_ref,"off")
                --entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
            else
                
            end
        end
    end
    -- antiaim
    local before = ui.get(ref.bodyyaw[2])
    local brutemiss = 0
    curprintlog = 0
    local function bullet_impact(c) --= enemy has shot near now switch sides
        local lp_vel = get_velocity(lp)
        local plocal = entity.get_local_player()
    
        local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")
    
        local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
        local lp_vel = get_velocity(entity.get_local_player())
        local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
        local p_slow = ui.get(ref.slow[1]) and ui.get(ref.slow[2])
    
        local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
        local is_fd = ui.get(ref.fakeduck)
        local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
    
        local wpn = entity.get_player_weapon(plocal)
        local wpn_id = entity.get_prop(wpn, "m_iItemDefinitionIndex")
    
        local doubletapping = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
        local state = "AFK"
        --states [for searching]'
        if not is_dt and not is_os and not p_still and ui.get(aa_init[7].enable_state) and ui.get(aa_init[0].aa_builder) then
            var.p_state = 7
        elseif c.in_duck == 1 and on_ground then
            var.p_state = 5
        elseif c.in_duck == 1 and not on_ground then
            var.p_state = 6
        elseif not on_ground then
            var.p_state = 4
        elseif p_slow then
            var.p_state = 3
        elseif p_still then
            var.p_state = 1
        elseif not p_still then
            var.p_state = 2
        end
        if ui.get(antiaimbruteforce) == "none" then
            return
        elseif ui.get(antiaimbruteforce) == "classic" then
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
                    
                    if math.abs(delta_2d) < ab_range / 1.6666667 then
                        if contains(ui.get(antiaimbruteforceon), "standing") and var.p_state == 1 then
                            should_swap = globals.curtime()
                            android_notify_new:paint(3, 'Switched side due to shot')
                            should_swap = true
                            ui.set(ref.bodyyaw[2], before * -1)
                        elseif contains(ui.get(antiaimbruteforceon), "moving") and var.p_state == 2 then
                            should_swap = globals.curtime()
                            android_notify_new:paint(3, 'Switched side due to shot')
                            should_swap = true
                            ui.set(ref.bodyyaw[2], before * -1)
                        elseif contains(ui.get(antiaimbruteforceon), "slowwalk") and var.p_state == 3 then
                            should_swap = globals.curtime()
                            android_notify_new:paint(3, 'Switched side due to shot')
                            should_swap = true
                            ui.set(ref.bodyyaw[2], before * -1)
                        elseif contains(ui.get(antiaimbruteforceon), "air") and var.p_state == 4 then
                            should_swap = globals.curtime()
                            android_notify_new:paint(3, 'Switched side due to shot')
                            should_swap = true
                            ui.set(ref.bodyyaw[2], before * -1)
                        elseif contains(ui.get(antiaimbruteforceon), "ducking") and var.p_state == 5 then
                            should_swap = globals.curtime()
                            android_notify_new:paint(3, 'Switched side due to shot')
                            should_swap = true
                            ui.set(ref.bodyyaw[2], before * -1)
                        elseif contains(ui.get(antiaimbruteforceon), "air-crouching") and var.p_state == 6 then
                            should_swap = globals.curtime()
                            android_notify_new:paint(3, 'Switched side due to shot')
                            should_swap = true
                            ui.set(ref.bodyyaw[2], before * -1)
                        elseif contains(ui.get(antiaimbruteforceon), "always") then
                            should_swap = globals.curtime()
                            android_notify_new:paint(3, 'Switched side due to shot')
                            should_swap = true
                            ui.set(ref.bodyyaw[2], before * -1)
                        end
                    else
                        curprintlog = globals.curtime()
                    end
                end
            end
        elseif ui.get(antiaimbruteforce) == "stages" then
            local phase1 = ui.get(antiaimstage1)
            local phase2 = ui.get(antiaimstage2)
            local phase3 = ui.get(antiaimstage3)
            local phase4 = ui.get(antiaimstage4)
            local phase5 = ui.get(antiaimstage5)
            brutemiss = brutemiss + 1
            --print(brutemiss)
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
                    if math.abs(delta_2d) < ab_range / 1.6666667 then
                        should_swap = globals.curtime()
                        should_swap = true
                        if brutemiss % 3 == 0 then
                            ui.set(ref.bodyyaw[2], phase1)
                            android_notify_new:paint(3, 'Switched side to phase 1')
                        elseif brutemiss % 3== 1 then
                            ui.set(ref.bodyyaw[2], phase2)
                            android_notify_new:paint(3, 'Switched side to phase 2')
                        elseif brutemiss% 3 == 2 then
                            ui.set(ref.bodyyaw[2], phase3)
                            android_notify_new:paint(3, 'Switched side to phase 3')
                        elseif brutemiss % 3 == 3 then
                            ui.set(ref.bodyyaw[2], phase4)
                            android_notify_new:paint(3, 'Sswitched side to phase 4')
                        elseif brutemiss % 3 == 4 then
                            
                            ui.set(ref.bodyyaw[2], phase5)
                            android_notify_new:paint(3, 'Switched side to phase 5')
                            brutemiss = 1
                        end
                    else
                        curprintlog = globals.curtime()
                    end
                end
            end
        end
    end
    local checkbox_reference, hotkey_reference = ui.reference("AA", "Other", "Slow motion")
    local function on_setup_cmd(cmd)	
        local slowmo = ui.get(ref.slow[1]) and ui.get(ref.slow[2])
        local lp = entity.get_local_player()
        local lp_vel = get_velocity(lp)


        local exploting = ui.get(ref.dt[2]) or ui.get(ref.os[2]) or ui.get(ref.fakeduck)

                    
        local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local side = bodyyaw > 0 and 1 or -1

            if not ui.is_menu_open() then
                if ui.get(antiaimdynamicroll) and not ui.get(ref.fakeduck) then
                    cmd.roll = 180
                else
                    cmd.roll = 0
                    ui.set(ref.roll_angles, 0)
                end

            end
        if slowmo then

            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.9*side, 11)
            if not exploting and slowmo then
                ui.set(ref.slowmotiontype, (exploting and "Favor anti-aim" or "Favor high speed"))
            else
                ui.set(ref.slowmotiontype, "Favor high speed")
            end
            if ui.get(ref.slowmotiontype) == "Favor high speed" or cmd.in_attack == 1 or exploting then
                modify_velocity(cmd, (exploting and 50 or 32))
                ui.set(ref.roll_angles, 0)
                cmd.roll = 0
            elseif ui.get(ref.slowmotiontype) == "Favor anti-aim" and cmd.in_attack == 0 and not exploting then
                if ui.get(antiaimdynamicroll) then
                    cmd.roll = -50*side
                    ui.set(ref.roll_angles, -50*side)
                end 
            end
        end

        if ui.get(antiaimdynamicroll) then
            if ui.get(antiaimforceroll) and ui.get(antiaimforcerollbind) then
                return
                
            else
                if contains(ui.get(antiaimrolldisablers), "running") then
                    if lp_vel > 2 and not in_air() and not in_duck and not slowmo then
                        cmd.roll = 0
                    else
                        cmd.roll = 50
                    end
                elseif contains(ui.get(antiaimrolldisablers), "air") then
                    if in_air() and not in_duck and not slowmo then
                        cmd.roll = 0
                    else
                        cmd.roll = 50
                    end
                elseif contains(ui.get(antiaimrolldisablers), "crouch") then
                    if in_duck and not slowmo and not in_air() then
                        cmd.roll = 0
                    else
                        cmd.roll = 50
                    end
                else
                    cmd.roll = -50
                end
            end
            penis2222222 = "*   ROLL   *"
        else
            cmd.roll = 0
        end



        if ui.get(antiaimforceroll) and ui.get(antiaimforcerollbind) then -- 	0x41 = a -- 	0x44 == d
            penis222222211 = "*   FORCE   ROLL   *"
            ui.set(ref.bodyyaw[1], "static")
            ui.set(ref.yawjitter[1], "off")
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.bodyyaw[2], -180) 
            ui.set(ref.fakeyawlimit, 59)
            cmd.roll = -50
        else
            ui.set(ref.bodyyaw[1], "jitter")
        end

        if ui.get(antiaimsideroll) and ui.get(antiaimsierollkey) then
   --

   --
            ui.set(ref.yawjitter[1], "off")
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.bodyyaw[2], -180) 
            ui.set(ref.bodyyaw[1], "static")
            ui.set(ref.fakeyawlimit, 59)
            local target, dist = get_near_target()
            if target ~= nil then
                local side = get_side(target) -- side 1 == fake on right  -- side 2 == fake on left
                if side == 1 then -- fake on right side
                    ui.set(ref.roll_angles, 50)
                    cmd.roll = 50
                    rolln2 = "*   SIDE ROLL   *"
                    --ui.set(ref.pitch, "down")  
                    ui.set(ref.yaw[2], 90)
                    ui.set(ref.bodyyaw[2], -180) 
                    ui.set(ref.bodyyaw[1], "static")
                    ui.set(ref.yawjitter[1], "off")
                    ui.set(ref.yawjitter[2], 0)
                    ui.set(ref.fakeyawlimit, 60)
                elseif side == 2 then
                    ui.set(ref.roll_angles, 50)
                    cmd.roll = 50
                    rolln2 = "*   INVERT SIDE ROLL   *"
                    --ui.set(ref.pitch, "down")  
                    ui.set(ref.yaw[2], -90)
                    ui.set(ref.bodyyaw[2], -180) 
                    ui.set(ref.bodyyaw[1], "static")
                    ui.set(ref.yawjitter[1], "off")
                    ui.set(ref.yawjitter[2], 0)
                    ui.set(ref.fakeyawlimit, 60)
                else
                    -- dormant#
                    ui.set(ref.roll_angles, 50)
                    cmd.roll = 50
                    rolln2 = "*   INVERT SIDE ROLL   *"
                    --ui.set(ref.pitch, "down")  
                    ui.set(ref.yaw[2], -90)
                    ui.set(ref.bodyyaw[2], -180) 
                    ui.set(ref.bodyyaw[1], "static")
                    ui.set(ref.yawjitter[1], "off")
                    ui.set(ref.yawjitter[2], 0)
                    ui.set(ref.fakeyawlimit, 60)

                end
            else
                -- dormant#
                rolln2 = "*   INVERT SIDE ROLL   *"
                --ui.set(ref.pitch, "down")  
                ui.set(ref.yaw[2], -90)
                ui.set(ref.bodyyaw[2], -180) 
                ui.set(ref.bodyyaw[1], "static")
                ui.set(ref.yawjitter[1], "off")
                ui.set(ref.yawjitter[2], 0)
                ui.set(ref.fakeyawlimit, 60)
                cmd.roll = 50

            end
        end

    end
    

    
    local cock = ""
    
    local function on_setup_command(c)
        local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local side = bodyyaw > 0 and 1 or -1
        
        local plocal = entity.get_local_player()
        
        if in_air(plocal) then
            c.force_defensive = true
        else
            c.force_defensive = false
        end
    
        local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")
    
        local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
        local lp_vel = get_velocity(entity.get_local_player())
        local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
        local p_slow = ui.get(ref.slow[1]) and ui.get(ref.slow[2])
    
        local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
        local is_fd = ui.get(ref.fakeduck)
        local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
    
        local wpn = entity.get_player_weapon(plocal)
        local wpn_id = entity.get_prop(wpn, "m_iItemDefinitionIndex")
    
        local doubletapping = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
        local state = "AFK"
        --states [for searching]'
        if not is_dt and not is_os and not p_still and ui.get(aa_init[7].enable_state) and ui.get(aa_init[0].aa_builder) then
            var.p_state = 7
        elseif c.in_duck == 1 and on_ground then
            var.p_state = 5
        elseif c.in_duck == 1 and not on_ground then
            var.p_state = 6
        elseif not on_ground then
            var.p_state = 4
        elseif p_slow then
            var.p_state = 3
        elseif p_still then
            var.p_state = 1
        elseif not p_still then
            var.p_state = 2
        end
    
        local edgekey = ui.get(antiaimedgeyaw)
        local freestandkey = ui.get(antiaimfreestanding)
        flipJitter = not flipJitter
        local lp = entity.get_local_player()
        local lp_hittable = can_enemy_hit_on_peek(enemyclosesttocrosshair,16)


            if edgekey then
                ui.set(ref.edgeyaw, true)
            else
                ui.set(ref.edgeyaw, false)
            end
            if freestandkey then
                if not on_ground then
                    if contains(ui.get(antiaimpreventfreestanding), "in-air") then
                        ui.set(ref.freestand[1], "-")
                        ui.set(ref.freestand[2], "On Hotkey")
                    else
                        ui.set(ref.freestand[1], "Default")
                        ui.set(ref.freestand[2], "Always on")
                    end
                elseif not c.in_duck == 1 then
                    if contains(ui.get(antiaimpreventfreestanding), "crouch") then
                        ui.set(ref.freestand[1], "-")
                        ui.set(ref.freestand[2], "On Hotkey")
                    else
                        ui.set(ref.freestand[1], "Default")
                        ui.set(ref.freestand[2], "Always on")
                    end
                elseif not p_still and on_ground then
                    if contains(ui.get(antiaimpreventfreestanding), "running") then
                        ui.set(ref.freestand[1], "-")
                        ui.set(ref.freestand[2], "On Hotkey")
                    else
                        ui.set(ref.freestand[1], "Default")
                        ui.set(ref.freestand[2], "Always on")
                    end
                else
                    ui.set(ref.freestand[1], "Default")
                    ui.set(ref.freestand[2], "Always on")
                end
            else
                ui.set(ref.freestand[1], "-")
                ui.set(ref.freestand[2], "On Hotkey")
            end

        local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local side = bodyyaw > 0 and 1 or -1

        local menuopen = ui.is_menu_open()
                --if menuopen then
                --    shutme()
                --else
                    manualantiaim()
                --print(vars.p_state)
                --print("velocity: "..lp_vel)
                    if ui.get(antiaimlegit) then
                        local weaponn = entity.get_player_weapon()
                        if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
                            if c.in_attack == 1 then
                                c.in_attack = 0
                                c.in_use = 1
                                --print("pressing e222")
                            end
                            --print("pressing e33333333333333")
                        else
                            if c.chokedcommands == 0 then
                                --print(globals.curtime())
                                --print(start_curtime)
                                --if globals.curtime() - start_curtime > 0.02 then -- door cehck or pick up bomb
                                    c.in_use = 0
                                    --print("pressing e")
                                --end
                            end
                            cock = "E-PEEK"
                            ui.set(ref.yawjitter[1], "off")
                            ui.set(ref.yawjitter[2], 0)
                            ui.set(ref.bodyyaw[1], "static")
                            ui.set(ref.bodyyaw[2], 0)
                            if c.chokedcommands ~= 0 then
                            else
                                ui.set(ref.yaw[2],(side == 1 and 0 or 0))
                            end
                            ui.set(ref.fakeyawlimit, 60)
                        end
                    else
                        ui.set(ref.pitch, "default")
                        ui.set(ref.yaw[1], "180")
                        if ui.get(antiaimmodes) == "aggressive" then
                            --ui.set(ref.pitch, "Minimal")
                            if var.p_state == 1 then
                                cock = "STANDING"
                                --ui.set(ref.yawjitter[1], "Center")
                                if ui.get(antiaimmodesprefer) then
                                    ui.set(ref.yawjitter[2], 38) -- or 11 -- 36
                                    ui.set(ref.bodyyaw[1], "Jitter")
                                    ui.set(ref.bodyyaw[2], 0)
                                    if c.chokedcommands ~= 0 then
                                    else
                                        ui.set(ref.yaw[2],(side == 1 and -11 or 7)) -- 16 14 45 -- -9 9
                                    end
                                    ui.set(ref.fakeyawlimit, 60)
                                else
                                    if ui.get(antiaimstanding) == "jitter" then
                                        ui.set(ref.yawjitter[2], 38) -- or 11 -- 36
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and -11 or 7)) -- 16 14 45 -- -9 9
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                    elseif ui.get(antiaimstanding) == "static" then
                                        --print("static")
                                        --ui.set(ref.yawjitter[1], "offset") -- or 11
                                        ui.set(ref.yawjitter[2], 0) -- or 11
                                        ui.set(ref.bodyyaw[1], "static")
                                        ui.set(ref.bodyyaw[2], 95)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 0 or 0))
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                    end
                                end
                            elseif var.p_state == 2 then
                                
                                --ui.set(ref.yawjitter[1], "Center") -- 1.1 = standing 240 is max
                                if ui.get(antiaimpreventhighjitter) and lp_vel > 1.2 and lp_vel < 150 then 
                                    -- low jitter here
                                    cock = "LOW JITTER"
                                    ui.set(ref.yawjitter[2], 38)
                                    ui.set(ref.bodyyaw[1], "Jitter")
                                    ui.set(ref.bodyyaw[2], 0)
                                    if c.chokedcommands ~= 0 then
                                    else
                                        ui.set(ref.yaw[2],(side == 1 and -5 or 9))
                                    end
                                    ui.set(ref.fakeyawlimit, 60)
                                else
                                    cock = "RUNNING"
                                    ui.set(ref.yawjitter[2], 38)
                                    ui.set(ref.bodyyaw[1], "Jitter")
                                    ui.set(ref.bodyyaw[2], 0)
                                    if c.chokedcommands ~= 0 then
                                    else
                                        ui.set(ref.yaw[2],(side == 1 and -23 or 20))
                                    end
                                    ui.set(ref.fakeyawlimit, 60)
                                end
                            elseif var.p_state == 3 then
                                cock = "SLOW"
                                if ui.get(antiaimmodesprefer) then
                                    ui.set(ref.yawjitter[2], 50)
                                    ui.set(ref.bodyyaw[1], "Jitter")
                                    ui.set(ref.bodyyaw[2], 0)
                                    if c.chokedcommands ~= 0 then
                                    else
                                        ui.set(ref.yaw[2],(side == 1 and -13 or 9))
                                    end
                                    ui.set(ref.fakeyawlimit, 60)
                                else
                                    if ui.get(antiaimslowwalk) == "jitter" then
                                        --ui.set(ref.yawjitter[1], "Center")
                                        ui.set(ref.yawjitter[2], 50)
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and -13 or 9))
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                    elseif ui.get(antiaimslowwalk) == "static" then
                                        ui.set(ref.yawjitter[2], 0)
                                        ui.set(ref.bodyyaw[1], "static")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 0 or 0))
                                        end
                                        ui.set(ref.fakeyawlimit, 59)
                                    end
                                end
                            elseif var.p_state == 4 then
                                cock = "AIR"
                                --ui.set(ref.yawjitter[1], "Center")
                                if ui.get(antiaimmodesprefer) then
                                    ui.set(ref.yawjitter[2], 63)
                                    ui.set(ref.bodyyaw[1], "Jitter")
                                    ui.set(ref.bodyyaw[2], 0)
                                    if c.chokedcommands ~= 0 then
                                    else
                                        ui.set(ref.yaw[2],(side == 1 and 5 or 12))
                                    end
                                    ui.set(ref.fakeyawlimit, 60)
                                else
                                    if ui.get(antiaiminair) == "risky" then
                                        --ui.set(ref.yawjitter[1], "Center")
                                        ui.set(ref.yawjitter[2], 63)
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 5 or 12))
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                    elseif ui.get(antiaiminair) == "safe" then
                                        ui.set(ref.yawjitter[2], 0) -- 47
                                        ui.set(ref.bodyyaw[1], "Static")
                                        ui.set(ref.bodyyaw[2], -141)
                                        ui.set(ref.fsbodyyaw, false)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 0 or 0))
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                    end
                                end
                            elseif var.p_state == 5 then
                                cock = "CROUCH"
                                --ui.set(ref.yawjitter[1], "Center")
                                ui.set(ref.yawjitter[2], 48)
                                ui.set(ref.bodyyaw[1], "Jitter")
                                ui.set(ref.bodyyaw[2], 0)
                                if c.chokedcommands ~= 0 then
                                else
                                    ui.set(ref.yaw[2],(side == 1 and -10 or 15))
                                end
                                ui.set(ref.fakeyawlimit, 60)
                            elseif var.p_state == 6 then
                                cock = "C-AIR"
                                --ui.set(ref.yawjitter[1], "Center")
                                if ui.get(antiaimmodesprefer) then
                                    ui.set(ref.yawjitter[2], 53)
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and -12 or 17))
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                else
                                    if ui.get(antiaiminair) == "risky" then
                                        ui.set(ref.yawjitter[2], 53)
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and -12 or 17))
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                    elseif ui.get(antiaiminair) == "safe" then
                                        ui.set(ref.yawjitter[2], 0) -- 47
                                        ui.set(ref.bodyyaw[1], "Static")
                                        ui.set(ref.bodyyaw[2], -141)
                                        ui.set(ref.fsbodyyaw, false)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 0 or 0))
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                    end
                                end
                            end
                        elseif ui.get(antiaimmodes) == "dynamic" then
                            --ui.set(ref.pitch, "Minimal")
                            if var.p_state == 1 then
                                cock = "STANDING"
                                if ui.get(antiaimmodesprefer) then
                                    ui.set(ref.yawjitter[2], 59) -- or 11 -- 36
                                    ui.set(ref.bodyyaw[1], "Jitter")
                                    ui.set(ref.bodyyaw[2], 0)
                                    if c.chokedcommands ~= 0 then
                                    else
                                        ui.set(ref.yaw[2],(side == 1 and 2 or 1)) -- 16 14 45 -- -9 9
                                    end
                                    ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 60 or 39) -- jitter fake yaw, WAY: NORMAL : CUSTOM
                                    --ui.set(ref.fakeyawlimit, 60)
                                else
                                    if ui.get(antiaimstanding) == "jitter" then
                                        ui.set(ref.yawjitter[2], 59) -- or 11 -- 36
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 2 or 1)) -- 16 14 45 -- -9 9
                                        end
                                        ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 60 or 39) -- jitter fake yaw, WAY: NORMAL : CUSTOM
                                    elseif ui.get(antiaimstanding) == "static" then
                                        --print("static")
                                        --ui.set(ref.yawjitter[1], "offset") -- or 11
                                        ui.set(ref.yawjitter[2], 0) -- or 11
                                        ui.set(ref.bodyyaw[1], "static")
                                        ui.set(ref.bodyyaw[2], 95)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 0 or 0))
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                    end
                                end
                            elseif var.p_state == 2 then
                                
                                --ui.set(ref.yawjitter[1], "Center")
                                if ui.get(antiaimpreventhighjitter) and lp_vel > 1.2 and lp_vel < 150 then 
                                    -- low jitter here
                                    cock = "LOW JITTER"
                                    ui.set(ref.yawjitter[2], 66) -- 35
                                    ui.set(ref.bodyyaw[1], "Jitter")
                                    ui.set(ref.bodyyaw[2], 0)
                                    if c.chokedcommands ~= 0 then
                                    else
                                        ui.set(ref.yaw[2],(side == 1 and 1 or 1)) -- -12 9
                                    end
                                    ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 46 or 39) -- jitter fake yaw, WAY: NORMAL : CUSTOM
                                    --ui.set(ref.fakeyawlimit, 60)
                                else
                                    cock = "RUNNING"
                                    ui.set(ref.yawjitter[2], 69) -- 35
                                    ui.set(ref.bodyyaw[1], "Jitter")
                                    ui.set(ref.bodyyaw[2], 0)
                                    if c.chokedcommands ~= 0 then
                                    else
                                        ui.set(ref.yaw[2],(side == 1 and 1 or 1)) -- -12 9
                                    end
                                    --ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 46 or 39) -- jitter fake yaw, WAY: NORMAL : CUSTOM
                                    ui.set(ref.fakeyawlimit, 60)
                                end
                            elseif var.p_state == 3 then
                                cock = "SLOW"
                                if ui.get(antiaimmodesprefer) then
                                    ui.set(ref.yawjitter[2], 84)
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 7 or 7))
                                        end
                                        --ui.set(ref.fakeyawlimit, 60)
                                        ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 60 or 26) -- jitter fake yaw, WAY: NORMAL : CUSTOM
                                else
                                    if ui.get(antiaimslowwalk) == "jitter" then
                                        --ui.set(ref.yawjitter[1], "Center")
                                        ui.set(ref.yawjitter[2], 84)
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 7 or 7))
                                        end
                                        --ui.set(ref.fakeyawlimit, 60)
                                        ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 60 or 26) -- jitter fake yaw, WAY: NORMAL : CUSTOM
                                    elseif ui.get(antiaimslowwalk) == "static" then
                                        ui.set(ref.yawjitter[2], 0)
                                        ui.set(ref.bodyyaw[1], "static")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 0 or 0))
                                        end
                                        ui.set(ref.fakeyawlimit, 59)
                                    end
                                end
                                --ui.set(ref.yawjitter[1], "Center")
                            elseif var.p_state == 4 then
                                cock = "AIR"
                                if ui.get(antiaimmodesprefer) then
                                    ui.set(ref.yawjitter[2], 74) -- 47
                                        ui.set(ref.bodyyaw[1], "jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        ui.set(ref.fsbodyyaw, false)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 5 or 5))
                                        end
                                        ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 60 or 36)
                                        
                                else
                                    if ui.get(antiaiminair) == "risky" then
                                        ui.set(ref.yawjitter[2], 74) -- 47
                                        ui.set(ref.bodyyaw[1], "jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        ui.set(ref.fsbodyyaw, false)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 5 or 5))
                                        end
                                        ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 60 or 36)
                                    elseif ui.get(antiaiminair) == "safe" then
                                        ui.set(ref.yawjitter[2], 0) -- 47
                                        ui.set(ref.bodyyaw[1], "Static")
                                        ui.set(ref.bodyyaw[2], -141)
                                        ui.set(ref.fsbodyyaw, false)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 0 or 0))
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                    end
                                end
                                --ui.set(ref.yawjitter[1], "Center")
                            elseif var.p_state == 5 then
                                cock = "CROUCH"
                                --ui.set(ref.yawjitter[1], "Center")
                                ui.set(ref.yawjitter[2], 41) -- 47
                                ui.set(ref.bodyyaw[1], "jitter")
                                ui.set(ref.bodyyaw[2], 0)
                                ui.set(ref.fsbodyyaw, false)
                                if c.chokedcommands ~= 0 then
                                else
                                    ui.set(ref.yaw[2],(side == 1 and 5 or 5))
                                end
                                --ui.set(ref.fakeyawlimit, 59)
                                ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 60 or 46)
                            elseif var.p_state == 6 then
                                cock = "C-AIR"
                                if ui.get(antiaimmodesprefer) then
                                    ui.set(ref.yawjitter[2], 75) --  47
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 1 or 1)) -- -5 or 14 --  or 35

                                        end
                                        --ui.set(ref.fakeyawlimit, 60)
                                        ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 60 or 36)
                                else
                                    if ui.get(antiaiminair) == "risky" then
                                        ui.set(ref.yawjitter[2], 75) --  47
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 1 or 1)) -- -5 or 14 --  or 35

                                        end
                                        --ui.set(ref.fakeyawlimit, 60)
                                        ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 60 or 36)
                                    elseif ui.get(antiaiminair) == "safe" then
                                        ui.set(ref.yawjitter[2], 0) -- 47
                                        ui.set(ref.bodyyaw[1], "Static")
                                        ui.set(ref.bodyyaw[2], -141)
                                        ui.set(ref.fsbodyyaw, false)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 0 or 0))
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                    end
                                end
                                --ui.set(ref.yawjitter[1], "Center")
                            end
                        elseif ui.get(antiaimmodes) == "custom" then
                            ui.set(ref.pitch, "Default")
                            if var.p_state == 1 then
                                cock = "STANDING"
                            elseif var.p_state == 2 then
                                cock = "RUNNING"
                            elseif var.p_state == 3 then
                                cock = "SLOW"
                            elseif var.p_state == 4 then
                                cock = "AIR"
                            elseif var.p_state == 5 then
                                cock = "CROUCH"
                            elseif var.p_state == 6 then
                                cock = "C-AIR"
                            elseif var.p_state == 7 then
                                cock = "LAG"
                            end
                            ui.set(ref.bodyyaw[2], ui.get(aa_init[var.p_state].aa_static))
                            ui.set(byaw, ui.get(aa_init[var.p_state].bodyyaw))
                            if ui.get(aa_init[var.p_state].enable_state) and ui.get(aa_init[0].aa_builder) then
                                
                                if contains(ui.get(antiaimpreventjitter), "freestand") then
                                    if ui.get(antiaimfreestanding) then
                                        ui.set(ref.yawjitter[1], "off")
                                    else
                                        ui.set(jyaw, ui.get(aa_init[var.p_state].yawjitter))
                                    end
                                elseif contains(ui.get(antiaimpreventjitter), "edge") then
                                    if ui.get(antiaimedgeyaw) then
                                        ui.set(ref.yawjitter[1], "off")
                                    else
                                        ui.set(jyaw, ui.get(aa_init[var.p_state].yawjitter))
                                    end
                                elseif contains(ui.get(antiaimpreventjitter), "on manual") then
                                    if ui.get(antiaimmanualleft) or ui.get(antiaimmanualright) or ui.get(antiaimmanualback) then
                                        ui.set(ref.yawjitter[1], "off")
                                    else
                                        ui.set(jyaw, ui.get(aa_init[var.p_state].yawjitter))
                                    end
                                else
                                    ui.set(jyaw, ui.get(aa_init[var.p_state].yawjitter))
                                end
                                ui.set(jyaw_val, ui.get(aa_init[var.p_state].yawjitteradd))
                                if c.chokedcommands ~= 0 then
                                else
                                    ui.set(yaw_val,(side == 1 and ui.get(aa_init[var.p_state].yawaddl) or ui.get(aa_init[var.p_state].yawaddr)))
                                end
                                local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
                                if ui.get(aa_init[var.p_state].side_fake_custom) == "normal" then
                                    if bodyyaw > 0 then
                                        ui.set(fake_yaw, ui.get(aa_init[var.p_state].fakeyawlimitr))
                                    elseif bodyyaw < 0 then
                                        ui.set(fake_yaw,ui.get(aa_init[var.p_state].fakeyawlimit))
                                    end
                                elseif ui.get(aa_init[var.p_state].side_fake_custom) == "jitter" then
                                    if bodyyaw > 0 then
                                        ui.set(fake_yaw, client.random_int(0, 1) == 1 and ui.get(aa_init[var.p_state].fakeyawlimitr) or ui.get(aa_init[var.p_state].fakeyawlimitcustom))
                                    elseif bodyyaw < 0 then
                                        ui.set(fake_yaw, client.random_int(0, 1) == 1 and ui.get(aa_init[var.p_state].fakeyawlimit) or ui.get(aa_init[var.p_state].fakeyawlimitcustom))
                                    end
                                end
                            elseif ui.get(aa_init[0].aa_builder) then
                                if var.p_state == 1 then -- stand
                                    if not ui.get(aa_init[var.p_state].enable_state) then
                                        -- old aa_builder
                                        ui.set(ref.yawjitter[2], 35) -- or 11 -- 36
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and -7 or 8)) -- 16 14 45 -- -9 9
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                    end
                                elseif var.p_state == 2 then -- move
                                    if not ui.get(aa_init[var.p_state].enable_state) then
                                        -- old aa_builder
                                        ui.set(ref.yawjitter[2], 66) -- 38
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 1 or 1)) -- -18 16
                                        end
                                        ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 46 or 39)
                                    end
                                elseif var.p_state == 3 then -- slow
                                    if not ui.get(aa_init[var.p_state].enable_state) then
                                        -- old aa_builder
                                        ui.set(ref.yawjitter[2], 74)
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 4 or 4))
                                        end
                                        --ui.set(ref.fakeyawlimit, 60)
                                        ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 60 or 26) -- jitter fake yaw, WAY: NORMAL : CUSTOM
                                    end
                                elseif var.p_state == 4 then -- air
                                    if not ui.get(aa_init[var.p_state].enable_state) then
                                        -- old aa_builder
                                        ui.set(ref.yawjitter[2], 54) --  47
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 1 or 1)) -- -5 or 14 --  or 35
                                        end
                                        ui.set(ref.fakeyawlimit, client.random_int(0, 1) == 1 and 60 or 36)
                                    end
                                elseif var.p_state == 5 then -- duck
                                    if not ui.get(aa_init[var.p_state].enable_state) then
                                        -- old aa_builder
                                        ui.set(ref.yawjitter[2], 63) -- 47
                                        ui.set(ref.bodyyaw[1], "jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        ui.set(ref.fsbodyyaw, false)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 5 or 12))
                                        end
                                        ui.set(ref.fakeyawlimit, 59)
                                    end
                                elseif var.p_state == 6 then -- in air
                                    if not ui.get(aa_init[var.p_state].enable_state) then
                                        -- old aa_builder
                                        ui.set(ref.yawjitter[2], 54) --  47
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 1 or 1)) -- -5 or 14 --  or 35
                                        end
                                        ui.set(ref.fakeyawlimit, 60)
                                    end
                                elseif var.p_state == 7 then -- fakelag
                                    if not ui.get(aa_init[var.p_state].enable_state) then
                                        ui.set(ref.yawjitter[2], 36) --  47
                                        ui.set(ref.bodyyaw[1], "Jitter")
                                        ui.set(ref.bodyyaw[2], 0)
                                        if c.chokedcommands ~= 0 then
                                        else
                                            ui.set(ref.yaw[2],(side == 1 and 3 or 5)) -- -5 or 14 --  or 35
                                        end
                                        ui.set(ref.fakeyawlimit, 59)
                                    end
                                end

                            end
                        end
                    end
                
    end

    local function antiaim(c) -- should_swap 

        if ui.get(antiaimenable) then
            --local customjitter = ui.get(ref.yawjitter[2]) / 100 * ui.get(antiaimyawjitteramount)
            local customjitter = ui.get(antiaimyawjitteramount)
            local in_duck = (bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 2) == 2)
            local slowmo = ui.get(ref.slow[1]) and ui.get(ref.slow[2])
            local lp = entity.get_local_player()
            local lp_vel = get_velocity(lp)
            local bFreezePeriod = entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod")
            local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
            local is_fd = ui.get(ref.fakeduck)
            local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])

            local plocal = entity.get_local_player()
    
            local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")
        
            local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
            local lp_vel = get_velocity(entity.get_local_player())
            local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
            local p_slow = ui.get(ref.slow[1]) and ui.get(ref.slow[2])
        
        
            local wpn = entity.get_player_weapon(plocal)
            local wpn_id = entity.get_prop(wpn, "m_iItemDefinitionIndex")
        
            local doubletapping = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
            --local state = "AFK"
            --states [for searching]'
            if not is_dt and not is_os and not p_still then
                var.p_state = 7
            elseif c.in_duck == 1 and on_ground then
                var.p_state = 5
            elseif c.in_duck == 1 and not on_ground then
                var.p_state = 6
            elseif not on_ground then
                var.p_state = 4
            elseif p_slow then
                var.p_state = 3
            elseif p_still then
                var.p_state = 1
            elseif not p_still then
                var.p_state = 2
            end

            -- global stuff

                local x, y, z = entity.get_prop(plocal, "m_vecVelocity")
                local velocity = math.floor(math.min(10000, math.sqrt(x^2 + y^2) + 0.5))
                if ui.get(ref.slow[2]) then
                    modify_velocity(c, math.random(22, 55))
                end

            if ui.get(antiaimsideroll) and ui.get(antiaimsierollkey) then
                ui.set(ref.yawjitter[1], "off")
                ui.set(ref.yawjitter[2], 0)
                ui.set(ref.bodyyaw[2], -180) 
                ui.set(ref.bodyyaw[1], "static")
                ui.set(ref.fakeyawlimit, 60)
            end
            
            if ui.get(antiaimyawbase) then
                ui.set(ref.yawbase, "at targets")
            else
                ui.set(ref.yawbase, "local view")
            end

            -- defines

            -- end of defines
            if ui.get(antiaimyawjitter) == "none" then
                ui.set(ref.yawjitter[1], "off")
            elseif ui.get(antiaimsideroll) and ui.get(antiaimsierollkey) then
                ui.set(ref.yawjitter[1], "off")
                ui.set(ref.yawjitter[2], 0)
                ui.set(ref.bodyyaw[2], -180) 
                ui.set(ref.bodyyaw[1], "static")
                ui.set(ref.fakeyawlimit, 60)
            elseif ui.get(antiaimyawjitter) == "center" then
                ui.set(ref.yawjitter[1], "center")
            elseif ui.get(antiaimyawjitter) == "offset" then
                ui.set(ref.yawjitter[1], "offset")
            elseif ui.get(antiaimyawjitter) == "prefered" then
                if ui.get(antiaimmodes) == "aggressive" then
                    if lp_vel < 1.2 and not in_air()and not slowmo then
                        if in_duck then
                            ui.set(ref.yawjitter[1], "center")
                        else
                            if ui.get(antiaimstanding) == "jitter" then
                                ui.set(ref.yawjitter[1], "center")
                            elseif ui.get(antiaimstanding) == "static" then
                                ui.set(ref.yawjitter[1], "off")
                            end
                        end
                    elseif lp_vel > 200 and not in_air() and not in_duck and not slowmo then
                        ui.set(ref.yawjitter[1], "offset")
                    elseif lp_vel > 1.2 and lp_vel < 200 and not in_air() and not in_duck and not slowmo then
                        ui.set(ref.yawjitter[1], "center")
                    elseif in_air() and not slowmo and not in_duck  then
                        ui.set(ref.yawjitter[1], "offset")
                    elseif slowmo and not in_air() and not in_duck  then
                        if ui.get(antiaimslowwalk) == "jitter" then
                            ui.set(ref.yawjitter[1], "offset")
                        elseif ui.get(antiaimslowwalk) == "static" then
                            ui.set(ref.yawjitter[1], "off")
                        end
                    end
                elseif ui.get(antiaimmodes) == "dynamic" then ------------------------------------------if vars.p_state == 1
                    if contains(ui.get(antiaimpreventjitter), "freestand") then
                        if ui.get(antiaimfreestanding) then
                            ui.set(ref.yawjitter[1], "off")
                        else
                            if var.p_state == 1 then -- standing
                                if in_duck then
                                    ui.set(ref.yawjitter[1], "center")
                                else
                                    if ui.get(antiaimstanding) == "jitter" then
                                        ui.set(ref.yawjitter[1], "center")
                                    elseif ui.get(antiaimstanding) == "static" then
                                        ui.set(ref.yawjitter[1], "offset")
                                        --print("side2")
                                    end
                                end
                            elseif var.p_state == 2 then -- running
                                ui.set(ref.yawjitter[1], "center")
                            elseif var.p_state == 4 or var.p_state == 6 then  -- air
                                if ui.get(antiaiminair) == "risky" then
                                    ui.set(ref.yawjitter[1], "center")
                                else
                                    ui.set(ref.yawjitter[1], "center")
                                end
                            elseif var.p_state == 3 then
                                if ui.get(antiaimslowwalk) == "jitter" then
                                    ui.set(ref.yawjitter[1], "center")
                                elseif ui.get(antiaimslowwalk) == "static" then
                                    ui.set(ref.yawjitter[1], "off")
                                end
                            elseif var.p_state == 4 then
                                ui.set(ref.yawjitter[1], "center")
                            elseif var.p_state == 5 then
                                ui.set(ref.yawjitter[1], "center")
                            elseif var.p_state == 6 then
                                ui.set(ref.yawjitter[1], "center")
                            elseif var.p_state == 7 then
                                ui.set(ref.yawjitter[1], "center")
                            end
                        end
                    elseif contains(ui.get(antiaimpreventjitter), "edge") then
                        if ui.get(antiaimedgeyaw) then
                            ui.set(ref.yawjitter[1], "off")
                        else
                            if var.p_state == 1 then -- standing
                                if in_duck then
                                    ui.set(ref.yawjitter[1], "center")
                                else
                                    if ui.get(antiaimstanding) == "jitter" then
                                        ui.set(ref.yawjitter[1], "center")
                                    elseif ui.get(antiaimstanding) == "static" then
                                        ui.set(ref.yawjitter[1], "offset")
                                        --print("side2")
                                    end
                                end
                            elseif var.p_state == 2 then -- running
                                ui.set(ref.yawjitter[1], "center")
                            elseif var.p_state == 4 or var.p_state == 6 then  -- air
                                if ui.get(antiaiminair) == "risky" then
                                    ui.set(ref.yawjitter[1], "center")
                                else
                                    ui.set(ref.yawjitter[1], "center")
                                end
                            elseif var.p_state == 3 then
                                if ui.get(antiaimslowwalk) == "jitter" then
                                    ui.set(ref.yawjitter[1], "center")
                                elseif ui.get(antiaimslowwalk) == "static" then
                                    ui.set(ref.yawjitter[1], "off")
                                end
                            elseif var.p_state == 4 then
                                ui.set(ref.yawjitter[1], "center")
                            elseif var.p_state == 5 then
                                ui.set(ref.yawjitter[1], "center")
                            elseif var.p_state == 6 then
                                ui.set(ref.yawjitter[1], "center")
                            elseif var.p_state == 7 then
                                ui.set(ref.yawjitter[1], "center")
                            end
                        end
                    elseif contains(ui.get(antiaimpreventjitter), "on manual") then
                        if ui.get(antiaimmanualleft) or ui.get(antiaimmanualright) or ui.get(antiaimmanualback) or ui.get(antiaimmanualforward) then
                            ui.set(ref.yawjitter[1], "off")
                            ui.set(ref.yaw[1], "off")
                        else
                            if var.p_state == 1 then -- standing
                                if in_duck then
                                    ui.set(ref.yawjitter[1], "center")
                                    ui.set(ref.yaw[1], 180)
                                else
                                    if ui.get(antiaimstanding) == "jitter" then
                                        ui.set(ref.yawjitter[1], "center")
                                        ui.set(ref.yaw[1], 180)
                                    elseif ui.get(antiaimstanding) == "static" then
                                        ui.set(ref.yawjitter[1], "off")
                                        ui.set(ref.yaw[1], 180)
                                        --print("side2")
                                    end
                                end
                            elseif var.p_state == 2 then -- running
                                ui.set(ref.yawjitter[1], "center")
                                ui.set(ref.yaw[1], 180)
                            elseif var.p_state == 4 or var.p_state == 6 then  -- air
                                if ui.get(antiaiminair) == "risky" then
                                    ui.set(ref.yawjitter[1], "center")
                                    ui.set(ref.yaw[1], 180)
                                else
                                    ui.set(ref.yawjitter[1], "center")
                                    ui.set(ref.yaw[1], 180)
                                end
                            elseif var.p_state == 3 then
                                if ui.get(antiaimslowwalk) == "jitter" then
                                    ui.set(ref.yaw[1], 180)
                                    ui.set(ref.yawjitter[1], "center")
                                elseif ui.get(antiaimslowwalk) == "static" then
                                    ui.set(ref.yaw[1], 180)
                                    ui.set(ref.yawjitter[1], "off")
                                end
                            elseif var.p_state == 4 then
                                ui.set(ref.yawjitter[1], "center")
                                ui.set(ref.yaw[1], 180)
                            elseif var.p_state == 5 then
                                ui.set(ref.yawjitter[1], "center")
                                ui.set(ref.yaw[1], 180)
                            elseif var.p_state == 6 then
                                ui.set(ref.yawjitter[1], "center")
                                ui.set(ref.yaw[1], 180)
                            elseif var.p_state == 7 then
                                ui.set(ref.yawjitter[1], "center")
                                ui.set(ref.yaw[1], 180)
                            end
                        end
                    else
                        if var.p_state == 1 then -- standing
                            if in_duck then
                                ui.set(ref.yawjitter[1], "center")
                            else
                                if ui.get(antiaimstanding) == "jitter" then
                                    ui.set(ref.yawjitter[1], "center")
                                elseif ui.get(antiaimstanding) == "static" then
                                    ui.set(ref.yawjitter[1], "offset")
                                    --print("side2")
                                end
                            end
                        elseif var.p_state == 2 then -- running
                            ui.set(ref.yawjitter[1], "center")
                        elseif var.p_state == 4 or var.p_state == 6 then  -- air
                            if ui.get(antiaiminair) == "risky" then
                                ui.set(ref.yawjitter[1], "center")
                            else
                                ui.set(ref.yawjitter[1], "center")
                            end
                        elseif var.p_state == 3 then
                            if ui.get(antiaimslowwalk) == "jitter" then
                                ui.set(ref.yawjitter[1], "center")
                            elseif ui.get(antiaimslowwalk) == "static" then
                                ui.set(ref.yawjitter[1], "off")
                            end
                        elseif var.p_state == 4 then
                            ui.set(ref.yawjitter[1], "center")
                        elseif var.p_state == 5 then
                            ui.set(ref.yawjitter[1], "center")
                        elseif var.p_state == 6 then
                            ui.set(ref.yawjitter[1], "center")
                        elseif var.p_state == 7 then
                            ui.set(ref.yawjitter[1], "center")
                        end
                    end
                end

            end
        end
    end
    -- visual
    local indicator_list = {}
    local width, height = client.screen_size()
    local w = width*0.5
    local h = height*0.5

        local final_h3 = h+32 --  dt
        local final_h4 = h+32
        local final_h5 = h+42 --  dt
        local final_h6 = h+42

        local final_h8 = h+23
        local final_h9 = h+23

    local half_spacer = 15/2
    indicator_list = {}



    local c_cmd = 0


    local function text(t)
        local frame_data = {}
        if t == "status" or t == "STATUS" then
            frame_data.net_channel_info = frame_data.net_channel_info or native_GetNetChannelInfo()
            if frame_data.net_channel_info == nil then 
                print("you are not connected to a server retard")
            end
    
            frame_data.is_loopback = frame_data.is_loopback == nil and native_IsLoopback(frame_data.net_channel_info) or frame_data.is_loopback
            if frame_data.is_loopback then return end
    
            frame_data.is_valve_ds = frame_data.is_valve_ds == nil and entity.get_prop(entity.get_game_rules(), "m_bIsValveDS") == 1 or frame_data.is_valve_ds
            if frame_data.is_valve_ds then 
                print("you are on a valved server")
            end
    
            frame_data.server_address = frame_data.server_address or GetAddress(frame_data.net_channel_info)
            if frame_data.server_address ~= nil and frame_data.server_address ~= "" then
                text = frame_data.server_address
                print("server ip: ",text)
            else
                print("you are not connected to a server retard")
            end
        end
    end

    client.set_event_callback("run_command", function(c)
        c_cmd = c.chokedcommands
        local data = get_nearest()
        target_distance_data = 0
        target_int_data = 0 
        if data ~= nil then
            target_int_data = data.target
            target_distance_data = data.distance
        end
        if contains(ui.get(globaldoubletapoption), "adaptive ping spike") then
            local me = entity.get_local_player()
        
                -- Return if we have no available target.
            
                -- Get our localplayers weapon, you can use the item definition index for this but the name improves readability.
                local weapon_name = entity.get_classname(entity.get_player_weapon(me))
            
                -- Return if we aren't using an auto.
                if weapon_name == "CWeaponSSG08" then
            --if weapon.name == "SSG 08" then
                --print(target_distance_data/2)
                    if target_distance_data/2 <= 35 then
                        --print(target_distance_data/2)
                        --print(pingspikeref)
                        ui.set(ref.pingspike[1],false)
                    else
                        ui.set(ref.pingspike[1], true)
                    end

                else
                    return
                end
        end
        if contains(ui.get(globaldoubletapoption), "force ping spike on scout") then
            local local_player = entity.get_local_player() local weapon_ent = entity.get_player_weapon(local_player) local weapon = csgo_weapons(weapon_ent)
            ping_spike, ping_spike_hk, ping_spike_value = ui.reference("MISC", "Miscellaneous", "Ping spike")
            if weapon.name == "SSG 08" then
                ui.set(ping_spike, true)
                ui.set(ping_spike_hk, "Always on")
                ui.set(ping_spike_value, ui.get(ping_spike_value))
            else
                ui.set(ping_spike, false)
            end
        end 
    end)

    local x_mod = 0 
    local function indicators(ctx)

        alpha = math.sin(math.abs(-math.pi + (globals.curtime() * (1 / 0.5)) % (math.pi * 2))) * 90
        alpha2 = math.sin(math.abs(-math.pi + (globals.curtime() * (0.9 / 0.5)) % (math.pi * 2))) * 255
        local body_pos = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)
        local bodyyaw = entity_get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local body_yaw = math.max(-60, math.min(60, body_pos * 120 - 60 + 0.5))
        local p_yaw = body_yaw / 60 * 100
        local side2 = {}
        local r1, g1, b1, a1 = ui.get(visualcolour)
        local r2, g2, b2, a2 = ui.get(visualcolour2)
        local lp_vel = get_velocity(local_player)
        local isactive = ui.get(ref.dt[2] or ui.get(ref.os[2]))
        local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local threat = client.current_threat()
        local health = entity.get_prop(threat, 'm_iHealth')
        body_yaw = (body_yaw < 1 and body_yaw > 0.0001) and math_floor(body_yaw, 1) or body_yaw
        local abs_yaw = math_abs(body_yaw)
        local round = function(value, multiplier) local multiplier = 10 ^ (multiplier or 0); return math.floor(value * multiplier + 0.5) / multiplier end

        local threat2 = ""
        if ui.get(antiaimmodes) == "custom" then
            customnew = "c"
        else
            customnew = ""
        end
        list_indicator = 0
        if p_yaw > 0 then -- r
            side2 = "R"
        else
            side2 = "L"
            -- not
        end

        local clantag = contains(ui.get(visualoptions), "clantag")
            if ui.get(visualenable) then
                if contains(ui.get(visualoptions), "clantag") then
                    local time = globals.tickcount() * globals.tickinterval()

                    if vars.sintag_time + 0.3 < time then
                        client.set_clan_tag(animate_string())
                        vars.sintag_time = time
                    elseif vars.sintag_time > time then
                        vars.sintag_time = time
                    end

                    vars.clantag_enbl = true
                elseif not clantag and vars.clantag_enbl then
                    clear_clantag()
                    vars.clantag_enbl = false
                end
            end

        if contains(ui.get(globaldisablefakelag), "doubletap") then
            if ui.get(ref.dt[2]) then
                if ui.get(ref.fakeduck) then
                    ui.set(ref.fl_limit, 14)
                    ui.set(ref.fakelag[2], "Always on")
                else
                    ui.set(ref.fl_limit, math.random(1,3))
                        ui.set(ref.fakelag[2], "On hotkey")
                    end
                else
                    ui.set(ref.fl_limit, 14)
                    ui.set(ref.fakelag[2], "Always on")
                end
            end
            if contains(ui.get(globaldisablefakelag), "hideshots") then
                if ui.get(ref.os[2]) then
                    if ui.get(ref.fakeduck) then
                        ui.set(ref.fl_limit, 14)
                        ui.set(ref.fakelag[2], "Always on")
                    else
                        --ui.set(ref.fl_limit, math.random(1,3))
                        ui.set(ref.fakelag[2], "On hotkey")
                    end
                else
                    ui.set(ref.fl_limit, 14)
                    ui.set(ref.fakelag[2], "Always on")
                end
            end
            if ui.get(visualenable) then
                if ui.get(visualteamskeetvisual) then
                    renderer_triangle(scrx + 55, scry + 2, scrx + 42, scry - 7, scrx + 42, scry + 11, 
                    var.aa_dir == 90 and 35 or 35, 
                    var.aa_dir == 90 and 35 or 35, 
                    var.aa_dir == 90 and 35 or 35, 
                    var.aa_dir == 90 and 150 or 150)

                    renderer_triangle(scrx - 55, scry + 2, scrx - 42, scry - 7, scrx - 42, scry + 11, 
                    var.aa_dir == -90 and 35 or 35, 
                    var.aa_dir == -90 and 35 or 35, 
                    var.aa_dir == -90 and 35 or 35, 
                    var.aa_dir == -90 and 150 or 150)
                    
                    renderer_rectangle(scrx + 38, scry - 7, 2, 18, 
                    bodyyaw < -10 and r1 or 35,
                    bodyyaw < -10 and g1 or 35,
                    bodyyaw < -10 and b1 or 35,
                    bodyyaw < -10 and a1 or 150)
                    
                    renderer_rectangle(scrx - 40, scry - 7, 2, 18,			
                    bodyyaw > 10 and r1 or 35,
                    bodyyaw > 10 and g1 or 35,
                    bodyyaw > 10 and b1 or 35,
                    bodyyaw > 10 and a1 or 150)
                end

                if ui.get(visualwatermark) then
                    if ui.get(visualwatermarkcombo) == "none" then
                        --return
                    elseif ui.get(visualwatermarkcombo) == "common" then
                        if image ~= nil then
                            local hours, minutes, seconds = client.system_time()
                            local ping = math.floor(client.latency()*1000+0.5)
                            local secondsnew = {}
                            if seconds < 10 then
                                secondsnew = string.format("0%s",seconds)
                            else
                                secondsnew = seconds
                            end
                            local minutesnew = {}
                            if minutes < 10 then
                                minutesnew = string.format("0%s",minutes)
                            else
                                minutesnew = minutes
                            end
                            --local text = string.format("malibu   •   %s   •   %s ms   • %s:%s:%s",username, ping, hours, minutes, secondsnew)
                            local screen_width, screen_height = client_screen_size()
                            local latency = math_floor(client.latency()*1000+0.5)
                            local tickrate = 1/globals.tickinterval()
                            
                            -- create text
                            local text = string.format(colours.pink.."malibu [%s]  "..colours.white.."•   %s   •   %d ms", lower_case,username,latency) .. colours.white.."  •  " .. string.format("%02d:%02d:%02d", hours, minutes, seconds)
                        
                            -- modify these to change how the text appears. margin is the distance from the top right corner, padding is the size the background rectangle is larger than the text
                            local margin, padding, flags = 18, 4, nil
                        
                            -- uncomment this for a "small and capital" style
                            -- flags, text = "-", (text:upper():gsub(" ", "   "))
                        
                            -- measure text size to properly offset the text from the top right corner
                            local text_width, text_height = renderer_measure_text(flags, text)
                        
                            -- draw background and text
                            renderer.gradient(screen_width-text_width-margin-padding, margin-padding, text_width+padding*2, text_height-19+padding*2,255,182,193, a1, 255,182,193, a2, 10) -- top
                            --renderer.gradient(screen_width-text_width-margin-padding, margin-padding, text_width+padding*2, text_height+padding*2,255,182,193, a1, 255,182,193, a2, 10) -- top
                            renderer.gradient(screen_width-text_width-margin-padding, margin-padding, text_width+padding*2, text_height+padding*2, 255,255,255,65, 255,255,255,65, 10) -- main gradient
                            renderer.gradient(x, y, w, h, r1, g1, b1, a1, r2, g2, b2, a2, ltr)
                            --renderer_rectangle(screen_width-text_width-margin-padding, margin-padding, text_width+padding*2, text_height+padding*2, 32, 32, 32, 200)
                            renderer_text(screen_width-text_width-margin, margin, 235, 235, 235, 255, flags, 0, text)

    
                        end 
                    elseif ui.get(visualwatermarkcombo) == "bottom" then
                        local hours, minutes, seconds = client.system_time()
                        local steamid64 = panorama.open().MyPersonaAPI.GetXuid()
                        local avatar = images.get_steam_avatar(steamid64)
                        --avatar:draw(scrx - 80, scry + 490, 40, 40, 255,255,255,255, true)
                        --renderer.text(scrx + 0, scry + 530, r2,g2,b2,a2, "-cd", 0, string.format(""))
                        --if image2 ~= nil then
                            --image2:draw(scrx - 220, scry + 410, 275, 200, r1, g1, b1, a1, true)
                            if ui.is_menu_open() then
                                local cx, cy = ui.mouse_position()
                                if iu2.dragging and not client.key_state(0x01) then
                                    iu2.dragging = false
                                end
                                
                                if iu2.dragging and client.key_state(0x01) then
                                    iu2.x = cx - iu2.drag_x
                                    iu2.y = cy - iu2.drag_y
                                end
                            
                                if intersect2(iu2.x, iu2.y, iu2.w, iu2.h+50) and client.key_state(0x01) then 
                                    iu2.dragging = true
                                    iu2.drag_x = cx - iu2.x
                                    iu2.drag_y = cy - iu2.y
                                end
                            end
                            avatar:draw(iu2.x - 80, iu2.y - 20, 40, 40, 255,255,255,255, true)
                        renderer.text(iu2.x + 40, iu2.y + 5, 255,255,255,255, "-cd", 0, string.format(colours.white.."           TIME <   "..colours.pink.."%s:%s:%s"..colours.white.."   >  \n           USER <  "..colours.pink.."%s"..colours.white.."  >            BUILD <  "..colours.pink.."%s"..colours.white.."  > \n           LAST UPDATE <  "..colours.pink.."%s"..colours.white.."  >             VERSION <  "..colours.pink.."v%s"..colours.white.."  >", hours, minutes, seconds,string.upper(username),string.upper(lower_case),lastupdate, version))
                    end

                end

                if contains(ui.get(visualoptions), "debug panel") then
                    if ui.get(scaledpanel) then -- if scaled then it will just scale to debug panel
                        if ui.is_menu_open() then
                            local cx, cy = ui.mouse_position()
                            if iu.dragging and not client.key_state(0x01) then
                                iu.dragging = false
                            end
                            
                            if iu.dragging and client.key_state(0x01) then
                                iu.x = cx - iu.drag_x
                                iu.y = cy - iu.drag_y
                            end
                        
                            if intersect(iu.x, iu.y, iu.w, iu.h+50) and client.key_state(0x01) then 
                                iu.dragging = true
                                iu.drag_x = cx - iu.x
                                iu.drag_y = cy - iu.y
                            end
                        end
                        renderer.text(iu.x - 5, iu.y - 0, 255,255,255,255, "d", 0, string.format(" - malibu.lua - "..colours.pink.."%s", string.lower(username)))
                        renderer.text(iu.x - 5, iu.y + 12, 255,255,255,255, "d", 0, string.format(" - version: "))
                        renderer.text(iu.x + 50, iu.y + 12, 255,182,193,alpha2, "d", 0, string.format(lower_case))
                        renderer.text(iu.x - 5, iu.y + 22, 255,255,255,255, "d", 0, string.format(" - desync degree: "..colours.pink.."%s", round(abs_yaw), "°"))
                        renderer.text(iu.x - 5, iu.y + 32, 255,255,255,255, "d", 0, string.format(" - target: "..colours.pink.."%s"..colours.white.." ["..colours.pink.."%s"..colours.white.."]", string.lower(entity.get_player_name(threat)), health))
                        if ui.get(antiaimmodes) == "custom" then
                            renderer.text(iu.x - 5, iu.y + 42, 255,255,255,255, "d", 0, string.format(" - anti-aim mode: "..colours.pink.."%s "..colours.white.."["..colours.pink.."%s"..colours.white.."]", string.lower(cock), string.lower(customnew)))
                        else
                            renderer.text(iu.x - 5, iu.y + 42, 255,255,255,255, "d", 0, string.format(" - anti-aim mode: "..colours.pink.."%s", string.lower(cock)))
                        end
                    else
                        if ui.is_menu_open() then
                            ui.set(dpi_ref, ui.get(new_dpi))
                        else
                            ui.set(dpi_ref, "100%")
                        end
                        if ui.is_menu_open() then
                            local cx, cy = ui.mouse_position()
                            if iu.dragging and not client.key_state(0x01) then
                                iu.dragging = false
                            end
                            
                            if iu.dragging and client.key_state(0x01) then
                                iu.x = cx - iu.drag_x
                                iu.y = cy - iu.drag_y
                            end
                        
                            if intersect(iu.x, iu.y, iu.w, iu.h+50) and client.key_state(0x01) then 
                                iu.dragging = true
                                iu.drag_x = cx - iu.x
                                iu.drag_y = cy - iu.y
                            end
                        end

                        renderer.text(iu.x - 5, iu.y - 0, 255,255,255,255, "d", 0, string.format(" - malibu.lua - "..colours.pink.."%s", string.lower(username)))
                        renderer.text(iu.x - 5, iu.y + 12, 255,255,255,255, "d", 0, string.format(" - version: "))
                        renderer.text(iu.x + 50, iu.y + 12, 255,182,193,alpha2, "d", 0, string.format(lower_case))
                        renderer.text(iu.x - 5, iu.y + 22, 255,255,255,255, "d", 0, string.format(" - desync degree: "..colours.pink.."%s", round(abs_yaw), "°"))
                        renderer.text(iu.x - 5, iu.y + 32, 255,255,255,255, "d", 0, string.format(" - target: "..colours.pink.."%s"..colours.white.." ["..colours.pink.."%s"..colours.white.."]", string.lower(entity.get_player_name(threat)), health))
                        if ui.get(antiaimmodes) == "custom" then
                            renderer.text(iu.x - 5, iu.y + 42, 255,255,255,255, "d", 0, string.format(" - anti-aim mode: "..colours.pink.."%s "..colours.white.."["..colours.pink.."%s"..colours.white.."]", string.lower(cock), string.lower(customnew)))
                        else
                            renderer.text(iu.x - 5, iu.y + 42, 255,255,255,255, "d", 0, string.format(" - anti-aim mode: "..colours.pink.."%s", string.lower(cock)))
                        end
                    end
                end
                if ui.get(antiaimidealtick) then
                    ui.set(ref.dt[2], "Always on")
                    local perc = math.floor(c_cmd / 14 * 100 / 2)
        
                    if perc == 0 or perc == 3 then
                        amount = 100
                    else
                        amount = perc
                    end
                    
                    
                    renderer_text(scrx, scry - 40, 255, 255, 255, 255, "cd-", 0, amount.. "%")
                else
                    ui.set(ref.dt[2], "Toggle")
                end
                if ui.get(visualindicators) == "none" then end
                if ui.get(visualindicators) == "default" then
                    if entity.is_alive(entity.get_local_player()) then
                        local me = entity.get_local_player()
                        local scoped = entity.get_prop(me, "m_bIsScoped")
                        local frames = 8 * globals.frametime() -- modify to change scoped animation speed
                        if scoped == 1 then x_mod = x_mod + frames; if x_mod > 0.99 then x_mod = 1 end else x_mod = x_mod - frames; if x_mod < 0 then x_mod = 0 end end 
                        local body_pos = entity_get_prop(me, "m_flPoseParameter", 11) or 0
                        local body_yaw = math_max(-60, math_min(60, body_pos*120-60+0.5))
                        body_yaw = (body_yaw < 1 and body_yaw > 0.0001) and math_floor(body_yaw, 1) or body_yaw
                        local abs_yaw = math_abs(body_yaw)
                        local p_yaw = body_yaw / 60 * 100
                        local add_x = (50) * x_mod -- change the number in (30*1) for spacing 
                                    local r1,g1,b1,a1 = ui.get(visualcolour)
                                    renderer.text(scrx+add_x, scry + 30, r1,g1,b1,a1, "d-c", 0, "MALIBU")
                                    renderer.text(scrx+add_x, scry + 38, r1,g1,b1,a1, "d-c", 0, round(abs_yaw),"°")
                                    --renderer.text(scrx+add_x, scry - 52, 255,255,255,255, "-cd", 0, cock)
                                                        
                                    if ui.get(antiaimdynamicroll) then
                                        if ui.get(antiaimforcerollbind) and ui.get(antiaimforceroll) then
                                            --renderer.text(scrx, scry + 10, 200,100,255,alpha2, "-cd", 0, penis222222211)
                                            renderer.indicator(200,100,255, "F - ROLL")
                                        else
                                            renderer.indicator(200,100,255, "ROLL")
                                            --renderer.text(scrx, scry + 10, 200,100,255,alpha2, "-cd", 0, penis2222222)
                                        end
                                        if not ui.get(antiaimforcerollbind) and not ui.get(antiaimforceroll) then
                                            renderer.indicator(200,100,255, "ROLL")
                                            --renderer.text(scrx, scry + 10, 200,100,255,alpha2, "-cd", 0, penis2222222)
                                        end
                                    end
                                    if ui.get(antiaimsideroll) and ui.get(antiaimsierollkey) then
                                        renderer.indicator(200,100,255, "ROLL")
                                        --renderer.text(scrx, scry + 15, 200,100,255,alpha2, "-cd", 0, rolln2)
                                    end
                                    if ui.get(ref.dt[2]) then
                                        renderer.text(scrx-1+add_x, scry + 47, r2,g2,b2,a2, "-cd", 0, "DT")
                                    elseif ui.get(ref.os[2]) then
                                        renderer.text(scrx+add_x, scry + 47, r2,g2,b2,a2, "-cd", 0, "OS")
                                    end

                                    if ui.get(ref.dt[2]) or ui.get(ref.os[2]) then
                                        if ui.get(ref.fforcebaim) then
                                            renderer.text(scrx+add_x, scry + 56, r2,g2,b2,a2, "-cd", 0, "BAIM")
                                        else
                                            renderer.text(scrx+add_x, scry + 56, 255,255,255,90, "-cd", 0, "BAIM")
                                        end
                                        if ui.get(ref.fsafepoint) then
                                            renderer.text(scrx- 17+add_x, scry + 56, 255,255,255,255, "-cd", 0, "SP")
                                        else
                                            renderer.text(scrx-17+add_x, scry + 56, 255,255,255,90, "-cd", 0, "SP")
                                        end
                                        if ui.get(ref.freestand[2]) then
                                            renderer.text(scrx+17+add_x, scry + 56, 255,255,255,255, "-cd", 0, "FS")
                                        else
                                            renderer.text(scrx+17+add_x, scry + 56, 255,255,255,90, "-cd", 0, "FS")
                                        end
                                    else
                                        if ui.get(ref.fforcebaim) then
                                            renderer.text(scrx+add_x, scry + 48, r2,g2,b2,a2, "-cd", 0, "BAIM")
                                        else
                                            renderer.text(scrx+add_x, scry + 48, 255,255,255,90, "-cd", 0, "BAIM")
                                        end
                                        if ui.get(ref.fsafepoint) then
                                            renderer.text(scrx- 17+add_x, scry + 48, 255,255,255,255, "-cd", 0, "SP")
                                        else
                                            renderer.text(scrx-17+add_x, scry + 48, 255,255,255,90, "-cd", 0, "SP")
                                        end
                                        if ui.get(ref.freestand[2]) then
                                            renderer.text(scrx+17+add_x, scry + 48, 255,255,255,255, "-cd", 0, "FS")
                                        else
                                            renderer.text(scrx+17+add_x, scry + 48, 255,255,255,90, "-cd", 0, "FS")
                                        end
                                    end

                                --end
                    end


                elseif ui.get(visualindicators) == "alternative" then
                    if entity.is_alive(entity.get_local_player()) then
                        local me = entity.get_local_player()
                        local scoped = entity.get_prop(me, "m_bIsScoped")
                        local frames = 8 * globals.frametime() -- modify to change scoped animation speed
                        if scoped == 1 then x_mod = x_mod + frames; if x_mod > 0.99 then x_mod = 1 end else x_mod = x_mod - frames; if x_mod < 0 then x_mod = 0 end end 
                        local add_x = (50) * x_mod -- change the number in (30*1) for spacing 
                        if ui.get(visualindicatorexploit) then

                                    if image ~= nil then
                                        image:draw(scrx - 9 +add_x, scry + 18, 20, 20, 255,255,255,255, true)
                                        --image2:draw(scrx - 105 +add_x, scry - 35, 200, 125, 255,255,255,255, true)
                                    end
                                    renderer.rectangle(scrx - 30+add_x, scry + 42, 60, 1, 255,255,255,255) -- bottom
                                    renderer.rectangle(scrx - 30+add_x, scry + 42, 1, -3, 255,255,255,255) -- left line
                                    renderer.rectangle(scrx + 30+add_x, scry + 42, 1, -3, 255,255,255,255) -- left line

                                    --print(entity.get_player_name(client.current_threat()))
                                    if client.current_threat() == nil then
                                        renderer.text(scrx+add_x, scry + 48, 255,255,255,255, "-cd", 0, "DORMANT")
                                    else
                                        renderer.text(scrx+add_x, scry + 48, 255,255,255,255, "-cd", 0, cock)
                                    end

                                    for x in ipairs(indicator_list) do
                                        local v = x+1
                                        list_indicator = list_indicator + half_spacer + half_spacer + half_spacer

                                        if list_indicator < 250 then
                                            if ui.get(ref.dt[2]) then
                                                renderer.text(w+add_x, final_h5+8*v, 255,255,255,255, "-cd", 0, indicator_list[x])
                                            else
                                                renderer.text(w+add_x, final_h6+8*v, 255,255,255,255, "-cd", 0, indicator_list[x])
                                            end
                                        end
                                    end
                            else
                                if  ui.get(ref.dt[2]) or ui.get(ref.os[2]) or ui.get(ref.fakeduck) or ui.get(ref.fforcebaim) or ui.get(ref.freestand[2]) then
                                        --renderer.text(scrx , scry + 25, 255,200,255,alpha, "-cd", 0, "ALPHA")
                                        --[[if p_yaw > 0 then
                                            renderer.text(scrx + 10, scry + 35, r1,g1,b1,a1, "cb", 0, "ibu")
                                            renderer.text(scrx - 8, scry + 35, r2,g2,b2,a2, "cb", 0, "mal")
                                        else
                                            renderer.text(scrx + 10, scry + 35, r2,g2,b2,a2, "cb", 0, "ibu")
                                            renderer.text(scrx - 8 , scry + 35, r1,g1,b1,a1, "cb", 0, "mal")
                                        end--]]
                                        if image ~= nil then
                                            image:draw(scrx - 9 +add_x, scry + 18, 20, 20, 255,255,255,255, true)
                                            --image2:draw(scrx - 105 +add_x, scry - 35, 200, 125, 255,255,255,255, true)
                                        end
                                        renderer.rectangle(scrx - 30+add_x, scry + 42, 60, 1, 255,255,255,255) -- bottom
                                        renderer.rectangle(scrx - 30+add_x, scry + 42, 1, -3, 255,255,255,255) -- left line
                                        renderer.rectangle(scrx + 30+add_x, scry + 42, 1, -3, 255,255,255,255) -- left line

                                        if client.current_threat() == nil then
                                            renderer.text(scrx+add_x, scry + 48, 255,255,255,255, "-cd", 0, "DORMANT")
                                        else
                                            renderer.text(scrx+add_x, scry + 48, 255,255,255,255, "-cd", 0, cock)
                                        end

                                        for x in ipairs(indicator_list) do
                                            local v = x+1
                                            list_indicator = list_indicator + half_spacer + half_spacer + half_spacer

                                            if list_indicator < 250 then
                                                if ui.get(ref.dt[2]) then
                                                    renderer.text(w+add_x, final_h5+8*v, 255,255,255,255, "-cd", 0, indicator_list[x])
                                                else
                                                    renderer.text(w+add_x, final_h6+8*v, 255,255,255,255, "-cd", 0, indicator_list[x])
                                                end
                                            end
                                        end
                                end
                            end
                        else
                    end


                    indicator_list = {}

                        if ui.get(ref.dt[2]) then
                            if ui.get(ref.quickpeek[2]) then
                                local weapon_name = entity.get_classname(entity.get_player_weapon(local_player))
                                if weapon_name == "CWeaponSSG08" then
                                    table.insert(indicator_list, "DT")
                                else
                                    table.insert(indicator_list, "DT")
                                end
                            else
                                table.insert(indicator_list, "DT")
                            end
                        end
                        if ui.get(ref.os[2]) then
                            table.insert(indicator_list, "HS")
                        end
                        if ui.get(ref.fakeduck) then
                            table.insert(indicator_list, "FAKE")
                        end
                        if ui.get(ref.fforcebaim) then
                            table.insert(indicator_list, "FB")
                        end
                        if ui.get(ref.freestand[2]) then
                            table.insert(indicator_list, "FS")
                        end
                        --[[if ui.get(ref.min_damage) < 10 then
                            table.insert(indicator_list, string.format("SHOOTING:   %shp", ui.get(ref.min_damage)))
                        end--]]

                elseif ui.get(visualindicators) == "custom" then
                    if entity.is_alive(entity.get_local_player()) then
                        local me = entity.get_local_player()
                        local scoped = entity.get_prop(me, "m_bIsScoped")
                        local frames = 8 * globals.frametime() -- modify to change scoped animation speed
                        if scoped == 1 then x_mod = x_mod + frames; if x_mod > 0.99 then x_mod = 1 end else x_mod = x_mod - frames; if x_mod < 0 then x_mod = 0 end end 
                        local add_x = (50) * x_mod -- change the number in (30*1) for spacing 
                        local aha = {}
                        local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
                        local body_pos = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)
                        
                        local body_yaw = math.max(-60, math.min(60, round((entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) or 0)*120-60+0.5, 1)))
                        local p_yaw = body_yaw / 60 * 100
                        if body_yaw < 0 then p_yaw = -p_yaw end
                        local body_yaw = math.max(-60, math.min(60, body_pos * 120 - 60 + 0.5))
                        local p_yaw = body_yaw / 60 * 100
                        local side2 = {}
                        local r1, g1, b1, a1 = ui.get(visualcolour)
                        local r2, g2, b2, a2 = ui.get(visualcolour2)
                        local lp_vel = get_velocity(local_player)
                        local isactive = ui.get(ref.dt[2] or ui.get(ref.os[2]))
                        local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
                        local threat = client.current_threat()
                        local health = entity.get_prop(threat, 'm_iHealth')
                        body_yaw = (body_yaw < 1 and body_yaw > 0.0001) and math_floor(body_yaw, 1) or body_yaw
                        local abs_yaw = math_abs(body_yaw)
                        if ui.get(visualindicatorexploit) then

                                    local r1,g1,b1,a1 = ui.get(visualcolour)
                                    local r2,g2,b2,a2 = ui.get(visualcolour2)
                                    local newr, newg, newb, newa = ui.get(visualcolour3)
                                    renderer.text(scrx+add_x, scry + 30, r1,g1,b1,a1, "-c", nil, "MALIBU") 
                                    if lower_case == "source" or "Source" then
                                        newaaaa = "BETA"
                                    else
                                        newaaaa = lower_case
                                    end
                                    if ui.get(indicatorbar) then
                                        -- checkme
                                        if contains(ui.get(indicatorbar), "build") then
                                            renderer.text(scrx+add_x, scry + 20, 181, 209, 255,alpha, "c-", nil, string.upper(newaaaa)) -- ONTOP
                                        end
                                        if contains(ui.get(indicatorbar), "desync bar") then
                                            renderer.rectangle(scrx+add_x, scry + 37, -16, 3, 0,0,0,90)
                                            renderer.rectangle(scrx+add_x, scry + 37, 20, 3, 0,0,0,90)
                                            renderer.gradient(scrx -15+add_x, scry + 37, abs_yaw/1.75, 2, r1,g1,b1,a1, r2,g2,b2,a2, true)    

                                            --renderer.gradient(scrx + 2+add_x, scry + 37, body_yaw/3, 2, r2,g2,b2,a2, r2,g2,b2,a2, false)
                                            --renderer.gradient(x, y, w, h, r1, g1, b1, a1, r2, g2, b2, a2, ltr)
                                        end
                                    end
                                    for x in ipairs(indicator_list) do
                                        local v = x+1
                                        list_indicator = list_indicator + half_spacer + half_spacer + half_spacer

                                        if list_indicator < 250 then
                                            if contains(ui.get(indicatorbar), "desync bar") then
                                                if ui.get(ref.dt[2]) then
                                                    renderer.text(w+add_x, final_h8+8*v + 5, newr, newg, newb, newa, "-cd", 0, indicator_list[x])
                                                else
                                                    renderer.text(w+add_x, final_h9+8*v + 5, newr, newg, newb, newa, "-cd", 0, indicator_list[x])
                                                end
                                            else
                                                if ui.get(ref.dt[2]) then
                                                    renderer.text(w+add_x, final_h8+8*v, newr, newg, newb, newa, "-cd", 0, indicator_list[x])
                                                else
                                                    renderer.text(w+add_x, final_h9+8*v, newr, newg, newb, newa, "-cd", 0, indicator_list[x])
                                                end
                                            end
                                        end
                                    end
                            end
                        else
                    end


                    indicator_list = {}

                    if contains(ui.get(indicatorcustom), "doubletap") then
                        if ui.get(ref.dt[2]) then
                            table.insert(indicator_list, "DT")
                        end
                    end
                    if contains(ui.get(indicatorcustom), "hideshots") then
                        if ui.get(ref.os[2]) then
                            table.insert(indicator_list, "HS")
                        end
                    end
                    if contains(ui.get(indicatorcustom), "force safe point") then
                        if ui.get(ref.fakeduck) then
                            table.insert(indicator_list, "FAKE")
                        end
                    end
                    if contains(ui.get(indicatorcustom), "force body aim") then
                        
                        if ui.get(ref.fforcebaim) then
                            table.insert(indicator_list, "FB")
                        end
                    end
                    if contains(ui.get(indicatorcustom), "quick peek") then
                        if ui.get(ref.quickpeek[2]) then
                            table.insert(indicator_list, "QP")
                        end
                    end
                    if contains(ui.get(indicatorcustom), "freestanding") then
                        if ui.get(ref.freestand[2]) then
                            table.insert(indicator_list, "FS")
                        end
                    end

                end
            end
        end

        local hstable = {"1"}
        local kiffernigger={'hehehh hab gut spass für una allle mit und dampf ma jutt ein','BIn strassenschlaeger wie zau sas','Hab strassen Abitur iss beste','Iss der trizep grosser als der bizep? Oda ander herum?','Schwoere hast denn Nagel laufen Kopf getroffen','Kippen uhhh musste das da rein klopppen passt schon','Japp cl doena bestw','Passart beste','Wie gehts diir soo haute','Erst ma ne Schoenheita Maske goen hehwh','Sonnst wers ja auch nur ein timmmi','Ne. Beides geld aba der trizeps iss etwas dicker','Lol uch frag sie erst garnicht wer weis wo sie über all schoen wahr uhhhh will ich garnet wisssennnn jetz hab ich schonn son kopfkino vin der sas wie sie dat macht wtf','Geld is schner alles persische schonheiten heheh','Ahhaha jahhhhahahhaha','Geht dat','Kann ich laute finden über skype also deren ip diggi','Kannst du das al Anwendung machen die mann neben wahts app offen iss','Spamen buddda','Topp bester man liwbe gruesse on patte','Lad ma die olllen wixxxa ein Xd','Hahahhaha und ich brauche grass','Gleich dabei mein pc zusammen zu Klopppen','Morgen frueh direkt vielleicht schon','Like a steffi cree','Jor kenn nur die ein paar leute jor hahah','Im Moment chillenn budda ubd geld sammel heheh','Bein bro macht dop','Datt sind mitlaufer haahha','ik stech euch alle ab','Jooo kolowebz alllet','Und ich juttt nit patte unterwegs','hahhah top ahhah','heheheh issso fussball beste','Gohan beste weiste wieso weil er zell geboxst hat lachhh','Pate beste buddda hab siew alllw buddda','Wien Ferrari bin ich buddda','Budda hallo mgf','Klaarr conniii jutt weiber am start','Buddda die sehen auch wie geld Muenzen heheh','B udddda hahah coonnni bestw','Bau arbeiter zzzzhahahah','Breiter als drine mo yo','Soo muss dat whwhhw','Alllles jutttte euch für den kommen den tag yaa','Deine mama zei jahre bei mir in kella','Kannste zigarrre mit puls bekkommen iss dixkkea teil da haste wat zum Dampfen','Kannst auch Zigarren von mir bekommen hand gemacht mad in tostedt und so kannst auch preis bestimmen 20-30-40 euro wurde ann dickkkes ding','Du glaubst net wie mud ich bin glaub immer noch voll drauf','Die typen Mit denn roten jacken sind geferlich munkelt man cree','Bin aba net lol kommma net ma uff soo ne dummme lach','Schreib halt meher geh eh penn oda hahahaha','Auf so ne dumme sach mit. Nen Tecker ralfen berg ruter haun','Isso vorhin richtig. Dickken kloppen drauf gepackt und ich fand das sich die faben veraendert haette lachhhh','klar bin boss untet denn bossawn lagfgel','koka beste habe aus peruanische flex 87% rein','Emm iss ja bet sooo die dickkke auabeute macgt mein sis ja meher lachh','hehehh hab gut spass fuer una allle mit und dampf ma jutt ein','Begleitung muss budda D rauch zwei mit hab nix meher alllet leer :p','Dickkkke is musste maehl drauf machen um wat zu finden lol bei dir','Das doch Schoenes das leben ist ziemlich entstand muss ivh mal soo sagen','Real zieh dich ine mo flax auf mein kawensman','Half. Mir mal was sol ich da eingabenx um aufen ts zu kommwb','Hab dickken kloppen thc harz oda oel. Was das auch iss. Direkt azs Holland D','Du ueberannormalekante wie zau in denn besten zeiten heheh','Nur koka emma und weeed meher net','XD ABA GUT GEMACHT ISSSIE','XD dachte da were allles tote Sehlen um ihn herum rum','Musss mir gleich. Mql die numma von der tuhse geben die das mit trikkky macht dann bommse ich sie richtig. Laff','budda komm ts fier ist auch da nikkko ist auch da alle sind sie da','haare schon brun oda imma noch totrot','digggen neun ps4 kontroler hab ich hwhwh','ich habe auch allle whwhh','massa hack v3 isssea','Machhhe ichh heheh dicksten stein bekommste','Du. Kannnst doch nicht. Einfach so gehen allle am weinen sind sie','Wer geht wtf lafffel lol niemand geht','Schmeckt komisch man denkt als wuerde man fesseln ein artmen und das ids eklig','Kifan garten bb?::: esra?','Nop war da erst ein mal und hab mich dann mit dem wch man angelaegt und dann dann bin ich einfach rein gegangen der typ wollte mir net glauben dat ich ein termin hab','Wie zau fette sau die','Komm dir mit ugor','Lol bin kraassser','BIn strassenschlaeger wie zau sas','Aba die weiber sehen imma krass aus hab noch nie eine polin in duck gesehen','Alle waren imma dunn wie zau','Ja wer ich dann auch machen gt','Hab ja top fach manner hoer am start','Brauch net mal nen trenner hab euch heheheheh','Hab euch 5 bodybilder gleichzeitig amstart heheheh geht duch','Achsoi dann zwei top klaase bodybilder','Sol bei ihn treniren er mein er macht aus mich ne kamofmarschiene','Hahah haben aie dat ding auch mal fertig','Halt miss sein bist auch boss in Tiere?','Hahaha. Wer hats dich gefragt wars der marlon?','Mit denn neuanfang','Wers dat denn loll','Hab strassen Abitur iss beste','Boss in den Geschaeft heheh','Isso hab auch fuss ball 7 Jahre gemacht mussen 1a sein','Iss der trizep grosser als der bizep? Oda ander herum?','Konzentrazonslager wtf','Jap die neur sprwche heist gugonisch','Jap uff 100 schrank gleich doppelt so dick','Ich gerne frueh gute sachen aba uch naehme Zinsen hehehe','Mein name drinne wtf wieso sacghh ma','Fruehsten tu ich','Japp muss mir noch ne neu Grafik karte holen dann die iss irgendwue kaputt gegangen','Dat sind mitlaufer haahha','Bin boss einer ganzen armarder','Hatte ivh letzte wochh da buddda','Sonn ott hab ich hierr bei mir immma','Im Moment chillenn buddda ubd geld sammel heheh','Draussen beste zu bufffen aba wens warm iss Xd','Trotz Weltwirtschaftskrise Laeuft zaehlt die gald marschiere','brauche hilllllfeee internet von mein pc geht jetzt wieder musss nur noch das fix aba ka wie emm da hat wer nen fussball auf mein tastertur fallen lasssen dabei ist ein komische tastenkombie gedruck wurden und jetzt geht f1 f2f3 usw und esc einfg auch net meher kannnnnnn kein menu offfen -,-,-,=((((((','Uuff im bett und Langeweile schieben uff','Uffel nee duu yaayyaA','Zzz ufff deine mama steigt in in ein plantsch Becken mit 5 80Jahre alten sacken und pumpt deren sacke uff','Hab 5laute bei deina mama gehsehen ufff','Em jor uff','Uff uff? Haram pada ohne ende yaa','Scharf zimmma Blick ya bald krieg yAah','Dickkke schieber fresse haste uff','Und warze inner schnauze uffyah','Mad? Dubhahahha','Pisss dich an uff wenn vormir stehst','Vertrocknete haste Pflaume haste hahah','Wtf neher fett wie farid uff','Bitzep wie Bueffel','Habb uff mein PC noch nen paar meher pic von takken ahhah','Luecken texst ufff','Seelhanter uff hat wer die nummma','Grade Frisoer heheh dickken Boxer inner bux','Mach ma ip logger rein wenn dat geht fuer skype und whatsapp bro','Niko patte eifersuechtig wie zau issie','Jooo wat geht bei der bossauraapp heheh','Sieben )) weill drrei uff iss','Grad wach gewwufff dorst wie zau gehabt','Lafff daa kommmt jaa cer mein tages Ablauf ähnlich. Hehehe','Ka sonnnast hab ich son 20 am tach geraucht laff','Lafff das ist ein supper geschenkt. Für. Denn nikoo dieee olllen kanaks immmaa ufffharten man machen in Wahrheit gaybiy nr.1','Beste sind die hack für. Die game da ist viel mehwr muhe drinne als in game selber lacch','Trotz Weltwirtschaftskrise Läuft zählt die gald marschiere','Mein Vater is dicke mit denn chaf und mach haram pada mit Fisch und ottt ohne zu rauchen yoo'}
        local userid_to_entindex = client.userid_to_entindex

        local function killsay(e)

            local victim_userid, attacker_userid = e.userid, e.attacker

            if victim_userid == nil or attacker_userid == nil then
                return
            end
            local local_player = entity.get_local_player()

            local victim_entindex   = client.userid_to_entindex(victim_userid)
            local attacker_entindex = client.userid_to_entindex(attacker_userid)

            if attacker_entindex == local_player and entity.is_enemy(victim_entindex) then
                if ui.get(visualenable) then
                    if contains(ui.get(visualoptions), "killsay") then
                        local commandhs = 'say ' .. hstable[math.random(#hstable)]
                        client.exec(commandhs)
                    end
                    if contains(ui.get(visualoptions), "kifferking killsay") then
                        local commandhs = 'say ' .. kiffernigger[math.random(#kiffernigger)]
                        client.exec(commandhs)
                    end
                end
            end
        end

        -- global
        local lastdt = 0

        local function doubletapstuff(c)
            local local_player = entity.get_local_player()
            local weapon_ent = entity.get_player_weapon(local_player)
            if weapon_ent == nil then return end

            -- calling csgo_weapons with an entindex returns the weapon data for that entity
            local weapon = csgo_weapons(weapon_ent)
            if weapon == nil then return end

            -- alternatively you can get the data using the item definition index like this
            local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
            local weapon = csgo_weapons[weapon_idx]
            if weapon_ent == nil then return end
            local penis2 = ui.get(globaldoubletapspeed)
            if ui.get(globalenable) then
                if ui.get(globaldoubletap) then
                    if contains(ui.get(globaldoubletapoption),"automatic doubletap speed") then
                        --print("auto dt")
                        if lastdt < globals.curtime() then
                            ui.set(ref.maxprocticks, 17)
                            client.set_cvar("cl_clock_correction", "0")
                            ui.set(ref.dt_limit, 1)
                            ui.set(ref.dt_holdaim, true)
                        else
                            ui.set(ref.maxprocticks, 19)
                            client.set_cvar("cl_clock_correction", "0")
                            ui.set(ref.dt_limit, 1)
                            ui.set(ref.dt_holdaim, true)
                        end
                    else
                        ui.set(ref.maxprocticks, penis2)
                    end

                    if ui.get(globaldefensiveaa) == "none" then
                        return 
                    end
                    if ui.get(globaldefensiveaa) == "force offensive" then
                        if ui.get(globaldefensiveaa) == "force offensive on auto" then
                            if weapon.name == "SCAR-20" or weapon.name == "G3SG1" then
                                if contains(ui.get(globaldoubletapoption), "improve ax accuracy") then
                                    c.force_defensive = 1;
                                    c.no_choke = 1;
                                    c.quick_stop = 1;
                                else
                                    ui.set(ref.dt_mode, "offensive")
                                    c.force_defensive = 0;
                                    c.no_choke = 0;
                                    c.quick_stop = 0;
                                end
                            else
                                ui.set(ref.dt_mode, "offensive")
                            end
                        else
                            if contains(ui.get(globaldoubletapoption), "improve ax accuracy") then
                                c.force_defensive = 1;
                                c.no_choke = 1;
                                c.quick_stop = 1;
                            else
                                ui.set(ref.dt_mode, "offensive")
                                c.force_defensive = 0;
                                c.no_choke = 0;
                                c.quick_stop = 0;
                            end
                            ui.set(ref.dt_mode, "offensive")
                        end
                    elseif ui.get(globaldefensiveaa) == "force defensive" then
                        if contains(ui.get(globaldoubletapoption),"force offensive on auto") then
                            if weapon.name == "SCAR-20" or weapon.name == "G3SG1" then
                                if contains(ui.get(globaldoubletapoption), "improve ax accuracy") then
                                    c.force_defensive = 1;
                                    c.no_choke = 1;
                                    c.quick_stop = 1;
                                else
                                    ui.set(ref.dt_mode, "offensive")
                                    c.force_defensive = 0;
                                    c.no_choke = 0;
                                    c.quick_stop = 0;
                                end
                            else
                                ui.set(ref.dt_mode, "defensive")
                                c.force_defensive = 0
                            end
                        else
                            if contains(ui.get(globaldoubletapoption), "improve ax accuracy") then
                                c.force_defensive = 1;
                                c.no_choke = 1;
                                c.quick_stop = 1;
                            else
                                ui.set(ref.dt_mode, "offensive")
                                c.force_defensive = 0;
                                c.no_choke = 0;
                                c.quick_stop = 0;
                            end
                            ui.set(ref.dt_mode, "defensive")
                            c.force_defensive = 0
                        end
                    elseif ui.get(globaldefensiveaa) == "automatic" then
                        if contains(ui.get(globaldoubletapoption),"force offensive on auto") then
                            if weapon.name == "SCAR-20" or weapon.name == "G3SG1" then
                                if contains(ui.get(globaldoubletapoption), "improve ax accuracy") then
                                    c.force_defensive = 1;
                                    c.no_choke = 1;
                                    c.quick_stop = 1;
                                else
                                    ui.set(ref.dt_mode, "offensive")
                                    c.force_defensive = 0;
                                    c.no_choke = 0;
                                    c.quick_stop = 0;
                                end
                            else
                                ui.set(ref.dt_mode, "defensive")
                                c.force_defensive = 0
                            end
                        else
                            if contains(ui.get(globaldoubletapoption), "improve ax accuracy") then
                                c.force_defensive = 1;
                                c.no_choke = 1;
                                c.quick_stop = 1;
                            else
                                ui.set(ref.dt_mode, "offensive")
                                c.force_defensive = 0;
                                c.no_choke = 0;
                                c.quick_stop = 0;
                            end
                            ui.set(ref.dt_mode, "defensive")
                            c.force_defensive = 0
                        end
                        -- aut0om,atic djiodshjngoiufdhnjgouidfgoudfighndf
                    end

                    if contains(ui.get(globaldoubletapoption), "doubletap hitchance detection") then
                        local data = get_nearest()
                        target_distance_data = 0
                        target_int_data = 0 
                        if data ~= nil then
                            target_int_data = data.target
                            target_distance_data = data.distance
                        end
                        if target_distance_data/2 >= 100 then
                            return
                        end
                        if weapon.name == "SCAR-20" or weapon.name == "G3SG1" then
                            if target_distance_data/2 <= 40 then 
                                --print(target_distance_data/2, " 2")
                                ui.set(ref.dt_hitchance, 1)
                            else
                                --print(target_distance_data/2)
                                ui.set(ref.dt_hitchance, target_distance_data/3)
                            end
                        else
                            ui.set(ref.dt_hitchance, 1)
                        end
                    else
                        ui.set(ref.dt_hitchance, 1)
                    end
                else
                    ui.set(ref.maxprocticks, 15)
                end
            end
        end

    
        
        misc = {}
        misc.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
            return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
        end
        misc.anti_knife = function()
            if ui.get(anti_knife) then
                local players = entity.get_players(true)
                local plocal = entity.get_local_player()
                local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
                local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
                local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
                for i=1, #players do
                    local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
                    local distance = misc.anti_knife_dist(lx, ly, lz, x, y, z)
                    local weapon = entity.get_player_weapon(players[i])
                    if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(knife_distance) then
                        ui.set(yaw_slider,180)
                        ui.set(pitch,"Off")
                    end
                end
            end
        end

        



        local hitgroup_names = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }
        local hitnumber = 0
        local chance, bt
        client.set_event_callback("aim_fire", function(e)
            chance = math.floor(e.hit_chance)
            bt = globals.tickcount() - e.tick
        end)
        local function hitlog(e)
            hitnumber = hitnumber + 1
            if ui.get(globalenable) then
                    local enemies = entity.get_players(true)
                    local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
                    local name = string.lower(entity.get_player_name(e.target))
                    local health = entity.get_prop(e.target, 'm_iHealth')
                    local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60 )
                    local backtrack = bt;
                    local backtrack2 = ""
                    if backtrack < 0 then
                        backtrack2 = "predicted - 0"
                    else
                        backtrack2 = backtrack
                    end

                    if contains(ui.get(hitlogs2), "none") then
                        return
                    end
                    if contains(ui.get(hitlogs2), "screen") then
                        android_notify_new:paint(2, string.format("hit %s in %s for %d(r:%d) | t:%s", string.lower(entity.get_player_name(e.target)), hgroup, e.damage, health, backtrack2))
                    end
                    if contains(ui.get(hitlogs2), "console") then
                        --client.color_log(255, 110, 75, "[malibu] - ", 255,255,255, string.format('hit '..name.." in "..hgroup..' for '..e.damage..' damage | ('..health..'hp remaining)'))
                        multicolor_log({255, 110, 75, '[malibu] - '}, {255, 255, 255, string.format("hit %s in %s for %d(r:%d) | t:%s", string.lower(entity.get_player_name(e.target)), hgroup, e.damage, health, backtrack2)})
                        --client.color_log(255, 110, 75,string.format("[malibu] - hit < %s > in < %s > for < %d > damage | accuracy < %d%% > | backtrack < %s > | extra flags < %s >", string.lower(entity.get_player_name(e.target)), hgroup, e.damage, hc, backtrack2, boost))
                    end

            end
        end

        


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


        local function fire(e)
            if client.userid_to_entindex(e.userid) == entity.get_local_player() then
                lastlocal = globals.curtime()
                if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then
                    lastdt = globals.curtime() + 1.1
                end
            end
        end

        local missnumber = 0
        local function misslog(e)
            missnumber = missnumber + 1
            if ui.get(globalenable) then
                    local hitgroups = hitgroup_names[e.hitgroup + 1] or "?"
                    local local_health = entity.get_prop(local_player, "m_iHealth")
                    local enemy_health = entity.get_prop(e.target, "m_iHealth")
                    local reasoning2 = {}
                    local reasoning = {}
                    if not entity.is_alive(e.target) then
                        return end
                    if entity.is_alive(entity.get_local_player()) then
                        if enemy_health < 0 then
                            enemy_health = "dead"
                        else
                            enemy_health = enemy_health
                        end

                        if e.reason == "prediction error" then
                            reasoning = "prediction"
                        elseif e.reason == "death" then
                            if enemy_health == 0 then
                                reasoning = "entity died before event was handled"
                            else
                                reasoning = "local player died before event was handled"
                                
                            end
                        elseif e.reason == "unregistered shot" then
                            reasoning = "clientsided shot"
                            
                        elseif e.reason == "spread" then
                            if get_velocity(entity.get_local_player()) < 78 then
                                reasoning = "spread(hc)"
                            else
                                reasoning = "spread(move)"
                            end
                        elseif e.reason == "?" then
                            reasoning = "resolver"
                        end

                        if contains(ui.get(hitlogs2), "none") then
                            return
                        end
                        if contains(ui.get(hitlogs2), "screen") then
                            android_notify_new:paint(2,  string.format('missed %s | missed hitbox: %s | reason: %s', string.lower(entity.get_player_name(e.target)), hitgroups, reasoning))
                        end
                        if contains(ui.get(hitlogs2), "console") then
                            client.color_log(255, 100, 100, string.format("missed %s | missed hitbox: %s | reason: %s", string.lower(entity.get_player_name(e.target)), hitgroups, reasoning))
                        end
                    end

            end
        end




        local function handle_callbacks() -- Put all callbacks in herre under shutdown
            client.set_event_callback("shutdown", function()
                ui.set_visible(dpi_ref, true)
                shutme()
                failedinjectin:setTitle('user unload/close game event')
                failedinjectin:setDescription('logging bot')
                failedinjectin:setThumbnail('https://cdn.discordapp.com/icons/770374971087388732/a_90e65c655cb31978f29c8f0b781338d6.webp?size=1024')
                failedinjectin:setColor(9811974)
                failedinjectin:addField('username: '.. username.. ' build: '.. lower_case, false)
                Webhook:send(failedinjectin)
            end)
            client.set_event_callback("paint_ui", menu_vis)
        
            -- antiaim
            client.set_event_callback("setup_command", antiaim) -- yawjitter
            client.set_event_callback("setup_command", doubletapstuff)
            -- visual
            client.set_event_callback("paint", indicators)
            client.set_event_callback("player_death", killsay)
            -- global
            client.set_event_callback("pre_render", prerenderstuff)

            client.set_event_callback("aim_hit", hitlog)
            client.set_event_callback("aim_miss", misslog)
            client.set_event_callback("bullet_impact", bullet_impact)
            client.set_event_callback('setup_command', on_setup_cmd)
            client.set_event_callback("console_input", text)
            client.set_event_callback("round_prestart", on_round_prestart)
            client.set_event_callback("setup_command",misc.anti_knife)
            client.set_event_callback("weapon_fire", fire)
            client.set_event_callback("setup_command", on_setup_command) -- MAIN AA
            client.set_event_callback("setup_command", reduce)
            client.set_event_callback("paint_ui", set_lua_menu)
            client.set_event_callback("paint_ui", config_menu)
            client.set_event_callback('pre_config_save', function()
                database.write("ui_x", iu.x)
                database.write("ui_y", iu.y)
                database.write("ui_x2", iu.x2)
                database.write("ui_y2", iu.y2)
            end)
        end
        handle_callbacks()
        
    end
main()


--local r1,g1,b1,a1 = ui.get(visualcolour)
--local android_notify_new=(function()local b={callback_registered=false,maximum_count=7,data2={}}function b:register_callback()if self.callback_registered then return end;client.set_event_callback("paint_ui",function()local c={client.screen_size()}local d={56,56,57}local e=5;local f=self.data2;for g=#f,1,-1 do self.data2[g].time=self.data2[g].time-globals.frametime()local h,i=255,0;local j=f[g]if j.time<0 then table.remove(self.data2,g)else local k=j.def_time-j.time;local k=k>1 and 1 or k;if j.time<0.5 or k<0.5 then i=(k<1 and k or j.time)/0.5;h=i*255;if i<0.2 then e=e+15*(1.0-i/0.2)end end;local l={renderer.measure_text(nil,j.draw)}local m={c[1]/2-l[1]/2+3,c[2]-c[2]/100*17.4+e}renderer.circle(m[1],m[2]-8,20,20,20,75,12,180,0.5)renderer.circle(m[1]+l[1],m[2]-8,20,20,20,75,12,0,0.5)renderer.rectangle(m[1],m[2]-20,l[1],24,20,20,20,75)renderer.circle_outline(m[1],m[2]-8,r1,g1,b1,a1,12,90,0.5,2)renderer.circle_outline(m[1]+l[1],m[2]-8,r1,g1,b1,a1,12,270,0.5,2)renderer.rectangle(m[1],m[2]-20,l[1],2,r1,g1,b1,a1)renderer.rectangle(m[1],m[2]-20+24,l[1],-2,r1,g1,b1,a1)renderer.text(m[1]+l[1]/2,m[2]-8,255,255,255,h,"c",nil,j.draw)e=e-50 end end;self.callback_registered=true end)end;function b:paint(n,o)local p=tonumber(n)+1;for g=self.maximum_count,2,-1 do self.data2[g]=self.data2[g-1]end;self.data2[1]={time=p,def_time=p,draw=o}self:register_callback()end;return b end)()
client.set_cvar('developer', 1)
client.set_cvar('con_filter_enable', 1)
client.set_cvar('con_filter_text', con_filter_text)
client.exec("cam_collision 0")
client.exec("sv_lan 1") -- if banned u can join whatever
client.exec("cl_showerror 0")
client.exec("playvol \"survival/buy_item_01.wav\" 1") -- playus sopund
client.color_log(155,155,255,"   ▄▄▄▄███▄▄▄▄      ▄████████  ▄█        ▄█  ▀█████████▄  ███    █▄  ")
client.color_log(155,155,255," ▄██▀▀▀███▀▀▀██▄   ███    ███ ███       ███    ███    ███ ███    ███ ")
client.color_log(155,155,255," ███   ███   ███   ███    ███ ███       ███▌   ███    ███ ███    ███ ")
client.color_log(155,155,255," ███   ███   ███   ███    ███ ███       ███▌  ▄███▄▄▄██▀  ███    ███ ")
client.color_log(155,155,255," ███   ███   ███ ▀███████████ ███       ███▌ ▀▀███▀▀▀██▄  ███    ███ ")
client.color_log(155,155,255," ███   ███   ███   ███    ███ ███       ███    ███    ██▄ ███    ███ ")
client.color_log(155,155,255," ███   ███   ███   ███    ███ ███▌    ▄ ███    ███    ███ ███    ███ ")
client.color_log(155,155,255,"  ▀█   ███   █▀    ███    █▀  █████▄▄██ █▀   ▄█████████▀  ████████▀  ")
client.color_log(155,155,255,"                              ▀                                      ")

--local text = string.format("welcome < "..colours.pink.."%s"..colours.white.." > to malibu! > build: < "..colours.pink.."%s"..colours.white.." > version: < "..colours.pink.."%s"..colours.white.." >",username,lower_case, version)
multicolor_log({255,255,255, "welcome < "}, {255,182,193, username}, {255,255,255, " > to malibu! > build: < "}, {255,182,193, lower_case}, {255,255,255, " > version: < "}, {255,182,193, "v",version}, {255,255,255, " >"})
android_notify_new:paint(5, string.format("welcome < %s > to malibu! > build: < %s > version: < %s >", username,lower_case, version))
RichEmbed:setTitle('user login')
RichEmbed:setDescription('logging bot')
RichEmbed:setThumbnail('https://cdn.discordapp.com/icons/770374971087388732/a_90e65c655cb31978f29c8f0b781338d6.webp?size=1024')
RichEmbed:setColor(9811974)
RichEmbed:addField('username: '.. username.. ' build: '.. lower_case, false)
Webhook:send(RichEmbed)
